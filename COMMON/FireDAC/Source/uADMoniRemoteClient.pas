{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{     FireDAC monitor TCP/IP based implementation       }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADMoniRemoteClient"'}

unit uADMoniRemoteClient;

interface

uses
  Classes,
  uADStanIntf, uADStanConst,
  uADMoniBase;

type
  {----------------------------------------------------------------------------}
  { TADMoniRemoteClientLink                                                    }
  {----------------------------------------------------------------------------}
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
  TADMoniRemoteClientLink = class(TADMoniClientLinkBase)
  private
    FRemoteClient: IADMoniRemoteClient;
    function IsHS: Boolean;
    function GetHost: String;
    procedure SetHost(const AValue: String);
    function GetPort: Integer;
    procedure SetPortI(const AValue: Integer);
    function GetTimeout: Integer;
    procedure SetTimeout(const AValue: Integer);
  protected
    function GetMoniClient: IADMoniClient; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property RemoteClient: IADMoniRemoteClient read FRemoteClient;
  published
    property Host: String read GetHost write SetHost stored IsHS;
    property Port: Integer read GetPort write SetPortI default C_AD_MonitorPort;
    property Timeout: Integer read GetTimeout write SetTimeout default C_AD_MonitorTimeout;
    property Tracing;
  end;

implementation

uses
{$IFDEF MSWINDOWS}
  Windows, WinSock,
{$ENDIF}  
{$IFDEF UNIX}
  sockets, netdb,
{$ENDIF}
  SysUtils,
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}
{$IFDEF AnyDAC_FPC}
  ssockets,
{$ELSE}
  ScktComp,
{$ENDIF}
{$IFDEF AnyDAC_D17}
  System.Generics.Collections,
  System.Types,
{$ENDIF}
  uADMoniRemoteBase, uADStanFactory, uADStanUtil;

type
  // client
  TADMoniRemoteClientQueueItem = class;
  TADMoniRemoteClientAdapterList = class;
  TADMoniRemoteSender = class;
  TADMoniRemoteClient = class;

  {----------------------------------------------------------------------------}
  { TADMoniRemoteClientQueueItem                                               }
  {----------------------------------------------------------------------------}
  TADMoniRemoteClientQueueItem = class(TADMoniRemoteQueueItem)
  end;

  {----------------------------------------------------------------------------}
  { TADMoniRemoteClientAdapterList                                             }
  {----------------------------------------------------------------------------}
  TADMoniRemoteClientAdapterList = class(TADMoniRemoteAdapterList)
  private
    FNextHandle: Integer;
  public
    function GetUniqueHandle: LongWord;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniRemoteSender                                                        }
  {----------------------------------------------------------------------------}
  TADMoniRemoteSender = class(TADMoniRemoteQueueWorker)
  private
    FTCPClient: {$IFNDEF AnyDAC_FPC} TClientSocket {$ELSE} TInetSocket {$ENDIF};
    FStream: TADMoniRemoteStream;
    FClient: TADMoniRemoteClient;
    FTimeout: Integer;
    FHost: String;
    FPort: Integer;
    FOnDisconnect: TNotifyEvent;
    function GetTracing: Boolean;
    procedure SetTracing(const AValue: Boolean);
    function IsMonitorRunning: Boolean;
{$IFNDEF AnyDAC_FPC}
    procedure DoDisconnect(Sender: TObject; Socket: TCustomWinSocket);
{$ENDIF}
  protected
    function GetQueue: TADMoniRemoteQueue; override;
    procedure DoAction; override;
  public
    constructor Create(AClient: TADMoniRemoteClient);
    destructor Destroy; override;
    property Port: Integer read FPort write FPort default C_AD_MonitorPort;
    property Host: String read FHost write FHost;
    property Timeout: Integer read FTimeout write FTimeout default C_AD_MonitorTimeout;
    property Tracing: Boolean read GetTracing write SetTracing default False;
    property OnDisconnect: TNotifyEvent read FOnDisconnect write FOnDisconnect;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniRemoteClient                                                        }
  {----------------------------------------------------------------------------}
  TADMoniRemoteClient = class (TADMoniClientBase, IADMoniRemoteClient)
  private
    FSender: TADMoniRemoteSender;
    FQueue: TADMoniRemoteQueue;
    FAdapterList: TADMoniRemoteClientAdapterList;
    FPackVersion: Integer;
    FProcessID: LongWord;
    FMonitorID: LongWord;
    FDestroying: Boolean;
    FDisconnecting: Boolean;
    function BuildItem(AEventKind: TADMoniRemoteQueueEventKind): TADMoniRemoteClientQueueItem;
    procedure DoDisconnected(Sender: TObject);
  protected
    // IADMoniClient
    procedure Notify(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      ASender: TObject; const AMsg: String; const AArgs: array of const); override;
    function RegisterAdapter(const AAdapter: IADMoniAdapter): LongWord; override;
    procedure UnregisterAdapter(const AAdapter: IADMoniAdapter); override;
    procedure AdapterChanged(const AAdapter: IADMoniAdapter); override;
    // IADMoniRemoteClient
    function GetHost: String;
    procedure SetHost(const AValue: String);
    function GetPort: Integer;
    procedure SetPortI(const AValue: Integer);
    function GetTimeout: Integer;
    procedure SetTimeout(const AValue: Integer);
    // other
    function DoTracingChanged: Boolean; override;
    function OperationAllowed: Boolean; override;
  public
    procedure Initialize; override;
    destructor Destroy; override;
    property Sender: TADMoniRemoteSender read FSender;
  end;

var
  FClients: TList;

{-------------------------------------------------------------------------------}
{ TADMoniRemoteClientAdapterList                                                }
{-------------------------------------------------------------------------------}
function TADMoniRemoteClientAdapterList.GetUniqueHandle: LongWord;
begin
  Result := LongWord(InterlockedIncrement(FNextHandle));
end;

{-------------------------------------------------------------------------------}
{ TADMoniRemoteSender                                                           }
{-------------------------------------------------------------------------------}
constructor TADMoniRemoteSender.Create(AClient: TADMoniRemoteClient);
begin
  inherited Create;
  FClient := AClient;
  FStream := TADMoniRemoteStream.Create;
  FHost := '127.0.0.1';
  FPort := C_AD_MonitorPort;
  FTimeout := C_AD_MonitorTimeout;
  Priority := tpHighest;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniRemoteSender.Destroy;
begin
  Tracing := False;
  Sleep(1);
  ADFreeAndNil(FTCPClient);
  ADFreeAndNil(FStream);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_FPC}
procedure TADMoniRemoteSender.DoDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  if Assigned(FOnDisconnect) then
    FOnDisconnect(Sender);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADMoniRemoteSender.GetTracing: Boolean;
begin
  Result := (FTCPClient <> nil) {$IFNDEF AnyDAC_FPC} and FTCPClient.Active {$ENDIF};
end;

{-------------------------------------------------------------------------------}
{$IFDEF MSWINDOWS}
var
  GWSAData: TWSAData;
  GWSAFailed: Boolean;
  GWSAInitialized: Boolean;

function TADMoniRemoteSender.IsMonitorRunning: Boolean;
var
  iSock: TSocket;
  rAddr: TSockAddrIn;
  prHost: PHostEnt;
  pCh: {$IFDEF NEXTGEN} MarshaledAString {$ELSE} PAnsiChar {$ENDIF};
begin
  Result := False;

  if not GWSAInitialized then begin
    GWSAFailed := WSAStartup($0101, GWSAData) <> 0;
    GWSAInitialized := True;
  end;
  if GWSAFailed then
    Exit;

  try
    iSock := socket(PF_INET, SOCK_STREAM, IPPROTO_IP);
    if iSock <> INVALID_SOCKET then begin
      rAddr.sin_family := PF_INET;
      rAddr.sin_addr.s_addr := INADDR_ANY;
      rAddr.sin_port := 0;
      if bind(iSock, rAddr, SizeOf(rAddr)) <> SOCKET_ERROR then begin
        rAddr.sin_family := PF_INET;
        prHost := gethostbyname({$IFNDEF NEXTGEN} PAnsiChar {$ENDIF}(TADEncoder.Enco(FHost, ecANSI)));
        if prHost <> nil then begin
          pCh := prHost^.h_addr_list^;
          rAddr.sin_addr.S_un_b.s_b1 := pCh[0];
          rAddr.sin_addr.S_un_b.s_b2 := pCh[1];
          rAddr.sin_addr.S_un_b.s_b3 := pCh[2];
          rAddr.sin_addr.S_un_b.s_b4 := pCh[3];
          rAddr.sin_port := htons(FPort);
          if connect(iSock, rAddr, SizeOf(rAddr)) <> SOCKET_ERROR then
            Result := True;
        end;
      end;
      shutdown(iSock, 2);
      closesocket(iSock);
    end;
  except
    // no exceptions visible
  end;
end;
{$ENDIF}

{$IFDEF AnyDAC_POSIX}
function TADMoniRemoteSender.IsMonitorRunning: Boolean;
var
  iSock: TSocket;
  rAddr: TSockAddr;
  rHost: THostEntry;
  sb: TADByteString;
begin
  Result := False;
  try
    iSock := fpSocket(PF_INET, SOCK_STREAM, IPPROTO_IP);
    if iSock <> -1 then begin
      rAddr.sin_family := PF_INET;
      rAddr.sin_addr.s_addr := INADDR_ANY;
      rAddr.sin_port := 0;
      if fpBind(iSock, @rAddr, SizeOf(rAddr)) = 0 then begin
        rAddr.sin_family := PF_INET;
        sb := TADEncoder.Enco(FHost, ecANSI);
        if GetHostByName(sb, rHost) or
           ResolveHostByName(sb, rHost) then begin
          rAddr.sin_addr := rHost.Addr;
          rAddr.sin_port := htons(FPort);
          if fpConnect(iSock, @rAddr, SizeOf(rAddr)) = 0 then
            Result := True;
        end;
      end;
      fpShutdown(iSock, 2);
      CloseSocket(iSock);
    end;
  except
    // no exceptions visible
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteSender.SetTracing(const AValue: Boolean);
begin
  if Tracing <> AValue then
    if AValue then begin
      if IsMonitorRunning then
        try
{$IFNDEF AnyDAC_FPC}
          FTCPClient := TClientSocket.Create(nil);
          FTCPClient.Host := FHost;
          FTCPClient.Port := FPort;
          FTCPClient.ClientType := ctBlocking;
          FTCPClient.OnDisconnect := DoDisconnect;
          // ScktComp does not support timeout
          // FTCPClient.ConnectTimeout := FTimeout;
          FTCPClient.Open;
{$ELSE}
          FTCPClient := TInetSocket.Create(FHost, Word(FPort));
{$ENDIF}
        except
          ADFreeAndNil(FTCPClient);
          raise;
        end
    end
    else begin
      try
        while FStream.IsOpen do
          Sleep(1);
{$IFNDEF AnyDAC_FPC}
        FTCPClient.Close;
{$ENDIF}
      except
        // no exceptions visible
      end;
      ADFreeAndNil(FTCPClient);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteSender.DoAction;
var
  oItem: TADMoniRemoteClientQueueItem;
begin
  oItem := TADMoniRemoteClientQueueItem(GetQueue.GetItem);
  if oItem <> nil then
  try
    FStream.Open({$IFNDEF AnyDAC_FPC} FTCPClient.Socket {$ELSE} FTCPClient {$ENDIF}, omWrite);
    try
      FStream.WriteInteger(S_AD_MsgEvent, Integer(oItem.FEvent));
      FStream.WriteBeginBlock(C_AD_Mon_PacketBodyBlockID);
      case oItem.FEvent of
        ptConnectClient:
          begin
            FStream.WriteLongWord(S_AD_MsgProcessId, oItem.FProcessID);
            FStream.WriteLongWord(S_AD_MsgMonitorId, oItem.FMonitorID);
            FStream.WriteInteger(S_AD_MsgVersion, FClient.FPackVersion);
            FStream.WriteLongWord(S_AD_MsgTime, oItem.FTime);
            FStream.WriteString(S_AD_MsgText, oItem.FMessage);
          end;
        ptDisConnectClient:
          begin
            FStream.WriteLongWord(S_AD_MsgProcessId, oItem.FProcessID);
            FStream.WriteLongWord(S_AD_MsgMonitorId, oItem.FMonitorID);
            FStream.WriteLongWord(S_AD_MsgTime, oItem.FTime);
          end;
        ptRegisterAdapter:
          begin
            FStream.WriteLongWord(S_AD_MsgAdapterHandle, oItem.FHandle);
            FStream.WriteLongWord(S_AD_MsgTime, oItem.FTime);
            FStream.WriteString(S_AD_MsgText, oItem.FPath);
          end;
        ptUnRegisterAdapter:
          begin
            FStream.WriteLongWord(S_AD_MsgAdapterHandle, oItem.FHandle);
            FStream.WriteLongWord(S_AD_MsgTime, oItem.FTime);
          end;
        ptUpdateAdapter:
          begin
            FStream.WriteLongWord(S_AD_MsgAdapterHandle, oItem.FHandle);
            FStream.WriteLongWord(S_AD_MsgTime, oItem.FTime);
            FStream.WriteBlob(S_AD_MsgArgs, oItem.FArgs);
          end;
        ptNotify:
          begin
            FStream.WriteLongWord(S_AD_MsgAdapterHandle, oItem.FHandle);
            FStream.WriteInteger(S_AD_MsgNotifyKind, Integer(oItem.FKind));
            FStream.WriteInteger(S_AD_MsgNotifyStep, Integer(oItem.FStep));
            FStream.WriteLongWord(S_AD_MsgTime, oItem.FTime);
            FStream.WriteString(S_AD_MsgText, oItem.FMessage);
            FStream.WriteBlob(S_AD_MsgArgs, oItem.FArgs);
          end;
      end;
      FStream.WriteEndBlock;
    finally
      try
        if (FStream <> nil) and GetTracing then
          FStream.Close;
      except
        if FTCPClient <> nil then
          FClient.SetTracing(False);
        raise;
      end;
    end;
  finally
    ADFree(oItem);
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteSender.GetQueue: TADMoniRemoteQueue;
begin
  Result := FClient.FQueue;
end;

{-------------------------------------------------------------------------------}
{ TADMoniRemoteClient                                                           }
{-------------------------------------------------------------------------------}
var
  ADMonitorLastID: Integer = 0;

procedure TADMoniRemoteClient.Initialize;
begin
  inherited Initialize;
  FSender := TADMoniRemoteSender.Create(Self);
  FSender.Host := '127.0.0.1';
  FSender.Port := C_AD_MonitorPort;
  FSender.Timeout := C_AD_MonitorTimeout;
  FSender.OnDisconnect := DoDisconnected;
  FQueue := TADMoniRemoteQueue.Create(FSender);
  FAdapterList := TADMoniRemoteClientAdapterList.Create;
  FPackVersion := C_AD_Mon_PacketVersion;
{$IFDEF MSWINDOWS}
  FProcessID := GetCurrentProcessId;
{$ENDIF}
{$IFDEF AnyDAC_POSIX}
  FProcessID := GetProcessId;
{$ENDIF}
  FMonitorID := InterlockedIncrement(ADMonitorLastID);
  if FClients <> nil then
    FClients.Add(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADMoniRemoteClient.Destroy;
begin
  if FClients <> nil then
    FClients.Remove(Self);
  FDestroying := True;
  SetTracing(False);
  ADFreeAndNil(FQueue);
  ADFreeAndNil(FSender);
  ADFreeAndNil(FAdapterList);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteClient.DoDisconnected(Sender: TObject);
begin
  FDisconnecting := True;
  SetTracing(False);
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteClient.BuildItem(AEventKind: TADMoniRemoteQueueEventKind): TADMoniRemoteClientQueueItem;
begin
  Result := TADMoniRemoteClientQueueItem.Create;
  Result.FProcessID := FProcessID;
  Result.FMonitorID := FMonitorID;
  Result.FEvent := AEventKind;
  Result.FTime := ADGetTickCount();
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D14}
  {$WARNINGS OFF}
{$ENDIF}
function TADMoniRemoteClient.DoTracingChanged: Boolean;
var
  oItem: TADMoniRemoteClientQueueItem;
  iStartTime: LongWord;
begin
  Result := True;
  if GetTracing then begin
    FSender.Tracing := True;
    if FSender.Tracing then begin
      if FSender.Suspended then
        FSender.Resume;
      oItem := BuildItem(ptConnectClient);
      oItem.FMessage := ParamStr(0) + ';' + GetName;
      FQueue.PostItem(oItem);
    end
    else begin
      Result := False;
      if not FSender.Suspended then
        FSender.Suspend;
    end;
  end
  else begin
    FQueue.Clear;
    if FSender.Tracing then begin
      oItem := BuildItem(ptDisConnectClient);
      FQueue.PostItem(oItem);
      iStartTime := ADGetTickCount();
      while (FQueue.Count > 0) and FSender.Tracing do begin
        Sleep(10);
        if ADTimeout(iStartTime, GetTimeout) then
          FQueue.Clear;
      end;
    end;
    FAdapterList.Clear;
    FSender.Tracing := False;
    if not FDestroying and not FDisconnecting and not FSender.Suspended then
      FSender.Suspend;
  end;
end;
{$IFDEF AnyDAC_D14}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADMoniRemoteClient.OperationAllowed: Boolean;
begin
  Result := (FClients <> nil);
end;

{-------------------------------------------------------------------------------}
type
  __TInterfacedObject = class(TInterfacedObject)
  end;

procedure TADMoniRemoteClient.Notify(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
  ASender: TObject; const AMsg: String; const AArgs: array of const);
var
  oItem: TADMoniRemoteClientQueueItem;
  hHandle: LongWord;
  oMAIntf: IADMoniAdapter;
  iRefCount: Integer;
  sClassName, sName: String;
begin
  if GetTracing and (AKind in GetEventKinds) then begin
    hHandle := 0;
    if (ASender <> nil) and (ASender is TInterfacedObject) then begin
      iRefCount := __TInterfacedObject(ASender).FRefCount;
      __TInterfacedObject(ASender).FRefCount := 2;
      try
        if Supports(ASender, IADMoniAdapter, oMAIntf) then begin
          hHandle := oMAIntf.GetHandle;
          oMAIntf := nil;
        end;
      finally
        __TInterfacedObject(ASender).FRefCount := iRefCount;
      end;
    end;
    oItem := BuildItem(ptNotify);
    oItem.FKind := AKind;
    oItem.FStep := AStep;
    oItem.FHandle := hHandle;
    oItem.FMessage := AMsg;
    oItem.SetArgs(AArgs);
    FQueue.PostItem(oItem);
    if GetOutputHandler <> nil then begin
      GetObjectNames(ASender, sClassName, sName);
      GetOutputHandler.HandleOutput(sClassName, sName, AMsg);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteClient.RegisterAdapter(const AAdapter: IADMoniAdapter): LongWord;
var
  oItem: TADMoniRemoteClientQueueItem;
  sPath: string;
  oObj: IADStanObject;
begin
  if GetTracing then begin
    oObj := AAdapter as IADStanObject;
    sPath := '';
    repeat
      if sPath <> '' then
        sPath := '.' + sPath;
      sPath := oObj.Name + sPath;
      oObj := oObj.Parent;
    until oObj = nil;
    Result := FAdapterList.FindByPath(sPath);
    if Result = 0 then begin
      Result := FAdapterList.GetUniqueHandle;
      oItem := BuildItem(ptRegisterAdapter);
      oItem.FPath := sPath;
      oItem.FHandle := Result;
      FQueue.PostItem(oItem);
    end;
  end
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteClient.UnRegisterAdapter(const AAdapter: IADMoniAdapter);
var
  oItem: TADMoniRemoteClientQueueItem;
  hHandle: LongWord;
begin
  if GetTracing then begin
    hHandle := AAdapter.GetHandle;
    if hHandle <> 0 then begin
      FAdapterList.RemoveAdapter(hHandle);
      oItem := BuildItem(ptUnRegisterAdapter);
      oItem.FHandle := hHandle;
      FQueue.PostItem(oItem);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteClient.AdapterChanged(const AAdapter: IADMoniAdapter);
var
  oItem: TADMoniRemoteClientQueueItem;
  hHandle: LongWord;
  V: Variant;
  i: Integer;
  sName: String;
  vValue: Variant;
  eKind: TADMoniAdapterItemKind;
begin
  if GetTracing then begin
    hHandle := AAdapter.GetHandle;
    if hHandle <> 0 then begin
      oItem := BuildItem(ptUpdateAdapter);
      oItem.FHandle := hHandle;
      V := VarArrayCreate([0, AAdapter.ItemCount * 3 - 1], varVariant);
      for i := 0 to AAdapter.ItemCount - 1 do begin
        AAdapter.GetItem(i, sName, vValue, eKind);
        V[i * 3 + 0] := sName;
        V[i * 3 + 1] := vValue;
        V[i * 3 + 2] := Byte(eKind);
      end;
      oItem.SetArgs(V);
      FQueue.PostItem(oItem);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteClient.GetHost: String;
begin
  Result := FSender.Host;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteClient.SetHost(const AValue: String);
begin
  FSender.Host := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteClient.GetPort: Integer;
begin
  Result := FSender.Port;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteClient.SetPortI(const AValue: Integer);
begin
  FSender.Port := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteClient.GetTimeout: Integer;
begin
  Result := FSender.Timeout;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteClient.SetTimeout(const AValue: Integer);
begin
  FSender.Timeout := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADMoniRemoteClientLink                                                       }
{-------------------------------------------------------------------------------}
constructor TADMoniRemoteClientLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRemoteClient := MoniClient as IADMoniRemoteClient;
  Host := '127.0.0.1';
  Port := C_AD_MonitorPort;
  Timeout := C_AD_MonitorTimeout;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniRemoteClientLink.Destroy;
begin
  FRemoteClient := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteClientLink.GetMoniClient: IADMoniClient;
var
  oRemClient: IADMoniRemoteClient;
begin
  ADCreateInterface(IADMoniRemoteClient, oRemClient);
  Result := oRemClient as IADMoniClient;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteClientLink.GetHost: String;
begin
  Result := RemoteClient.Host;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteClientLink.SetHost(const AValue: String);
begin
  RemoteClient.Host := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteClientLink.IsHS: Boolean;
begin
  Result := ADMoniRemoteIsLocalHost(GetHost);
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteClientLink.GetPort: Integer;
begin
  Result := RemoteClient.Port;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteClientLink.SetPortI(const AValue: Integer);
begin
  RemoteClient.Port := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteClientLink.GetTimeout: Integer;
begin
  Result := RemoteClient.Timeout;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteClientLink.SetTimeout(const AValue: Integer);
begin
  RemoteClient.Timeout := AValue;
end;

{-------------------------------------------------------------------------------}
procedure StopAllClients;
var
  i: Integer;
  oClient: TADMoniRemoteClient;
begin
  for i := 0 to FClients.Count - 1 do begin
    oClient := TADMoniRemoteClient(FClients[i]);
    oClient.FDestroying := True;
    oClient.SetTracing(False);
  end;
end;

{-------------------------------------------------------------------------------}
var
  oFact: TADFactory;

initialization
{$IFDEF MSWINDOWS}
  GWSAFailed := False;
  GWSAInitialized := False;
{$ENDIF}
  FClients := TList.Create;
  oFact := TADSingletonFactory.Create(TADMoniRemoteClient, IADMoniRemoteClient);

finalization
  StopAllClients;
  ADFreeAndNil(FClients);
{$IFDEF MSWINDOWS}
  if GWSAInitialized then
    WSACleanup;
{$ENDIF}
  ADReleaseFactory(oFact);

end.
