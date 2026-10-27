{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{      FireDAC monitor TCP/IP based implementation      }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADMoniRemoteServer;

interface

uses
{$IFDEF MSWINDOWS}
  Windows, WinSock,
{$ENDIF}
  Classes, SysUtils, ScktComp,
  uADStanIntf, uADStanConst, uADMoniRemoteBase;

type
  // server
  TADMoniRemoteServerQueueItem = class;
  TADMoniRemoteReceiver = class;
  TADMoniRemoteServerClientThread = class;
  TADMoniRemoteServer = class;

  {----------------------------------------------------------------------------}
  { TADMoniRemoteServerQueueItem                                               }
  {----------------------------------------------------------------------------}
  TADMoniRemoteServerQueueItem = class(TADMoniRemoteQueueItem)
  public
    FHost: String;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniRemoteReceiver                                                      }
  {----------------------------------------------------------------------------}
  TADMoniRemoteReceiver = class(TADMoniRemoteQueueWorker)
  private
    FServer: TADMoniRemoteServer;
    procedure DoMessage;
  protected
    function GetQueue: TADMoniRemoteQueue; override;
    procedure DoAction; override;
  public
    constructor Create(AServer: TADMoniRemoteServer);
    destructor Destroy; override;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniRemoteServerClientThread                                            }
  {----------------------------------------------------------------------------}
  TADMoniRemoteServerClientThread = class (TServerClientThread)
  private
    FServer: TADMoniRemoteServer;
    FStream: TADMoniRemoteStream;
    FAdapterList: TADMoniRemoteAdapterList;
    FProcessID: LongWord;
    FMonitorID: LongWord;
    FVersion: LongWord;
    procedure RemoveAllAdapters;
  protected
    procedure ClientExecute; override;
  public
    constructor Create(AServer: TADMoniRemoteServer; ASocket: TServerClientWinSocket);
    destructor Destroy; override;
    property ProcessID: LongWord read FProcessID write FProcessID;
    property MonitorID: LongWord read FMonitorID write FMonitorID;
    property Version: LongWord read FVersion write FVersion;
  end;

  {----------------------------------------------------------------------------}
  { TADMoniRemoteServer                                                        }
  {----------------------------------------------------------------------------}
  TADMoniRemoteServerMessageEvent = procedure (Sender: TObject; AMessage: TADMoniRemoteQueueItem) of object;
  TADMoniRemoteServer = class (TObject)
  private
    FTCPServer: TServerSocket;
    FQueue: TADMoniRemoteQueue;
    FReceiver: TADMoniRemoteReceiver;
    FPackVersion: Integer;
    FSynchronize: TADMoniRemoteQueueEventKinds;
    FOnMessage: TADMoniRemoteServerMessageEvent;
    procedure DoMessage(AMessage: TADMoniRemoteServerQueueItem);
    procedure DoGetThread(Sender: TObject; ClientSocket: TServerClientWinSocket;
      var SocketThread: TServerClientThread);
    procedure DoExecute(AClient: TADMoniRemoteServerClientThread);
    function GetTracing: Boolean;
    procedure SetTracing(const AValue: Boolean);
    function GetPort: Integer;
    procedure SetPortI(const AValue: Integer);
    function BuildItem(AClient: TADMoniRemoteServerClientThread): TADMoniRemoteServerQueueItem;
  public
    constructor Create;
    destructor Destroy; override;
    property Queue: TADMoniRemoteQueue read FQueue;
    property Receiver: TADMoniRemoteReceiver read FReceiver;
    property Port: Integer read GetPort write SetPortI default C_AD_MonitorPort;
    property Tracing: Boolean read GetTracing write SetTracing default False;
    property Synchronize: TADMoniRemoteQueueEventKinds read FSynchronize write FSynchronize default [];
    property OnMessage: TADMoniRemoteServerMessageEvent read FOnMessage write FOnMessage;
  end;

implementation

uses
{$IFDEF AnyDAC_D6}
  Variants,
{$ENDIF}
  uADStanUtil, uADStanFactory;

{-------------------------------------------------------------------------------}
{ TADMoniRemoteReceiver                                                         }
{-------------------------------------------------------------------------------}
constructor TADMoniRemoteReceiver.Create(AServer: TADMoniRemoteServer);
begin
  inherited Create;
  FServer := AServer;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniRemoteReceiver.Destroy;
begin
  FServer := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteReceiver.GetQueue: TADMoniRemoteQueue;
begin
  Result := FServer.FQueue;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteReceiver.DoAction;
begin
  if GetQueue.GetNextEvent in FServer.Synchronize then
    Synchronize(DoMessage)
  else
    DoMessage;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteReceiver.DoMessage;
var
  oItem: TADMoniRemoteServerQueueItem;
  i: Integer;
begin
  i := 5;
  repeat
    oItem := TADMoniRemoteServerQueueItem(GetQueue.GetItem);
    if oItem <> nil then
      try
        FServer.DoMessage(oItem);
      finally
        ADFree(oItem);
      end;
    Dec(i);
  until (GetQueue.Count = 0) or (i = 0) or
        not (GetQueue.GetNextEvent in FServer.Synchronize);
end;

{-------------------------------------------------------------------------------}
{ TADMoniRemoteServerClientThread                                               }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D14}
  {$WARNINGS OFF}
{$ENDIF}
constructor TADMoniRemoteServerClientThread.Create(AServer: TADMoniRemoteServer;
  ASocket: TServerClientWinSocket);
begin
  inherited Create(True, ASocket);
  FServer := AServer;
  FAdapterList := TADMoniRemoteAdapterList.Create;
  FStream := TADMoniRemoteStream.Create;
  Resume;
end;
{$IFDEF AnyDAC_D14}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
destructor TADMoniRemoteServerClientThread.Destroy;
begin
  FServer := nil;
  ADFreeAndNil(FAdapterList);
  ADFreeAndNil(FStream);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteServerClientThread.RemoveAllAdapters;
var
  i: Integer;
  oItem: TADMoniRemoteServerQueueItem;
begin
  try
    for i := 0 to FAdapterList.Count - 1 do begin
      oItem := FServer.BuildItem(Self);
      oItem.FEvent := ptUnRegisterAdapter;
      oItem.FHandle := FAdapterList.Handles[i];
      oItem.FPath := FAdapterList.Paths[i];
      FServer.FQueue.PostItem(oItem);
    end;
  finally
    FAdapterList.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteServerClientThread.ClientExecute;
var
  FDSet: TFDSet;
  TimeVal: TTimeVal;
begin
  while not Terminated and ClientSocket.Connected do begin
    FD_ZERO(FDSet);
    FD_SET(ClientSocket.SocketHandle, FDSet);
    TimeVal.tv_sec := 0;
    TimeVal.tv_usec := 500;
    if (select(0, @FDSet, nil, nil, @TimeVal) > 0) and not Terminated then
      if ClientSocket.ReceiveBuf(FDSet, -1) = 0 then
        Break
      else
        FServer.DoExecute(Self);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADMoniRemoteServer                                                           }
{-------------------------------------------------------------------------------}
constructor TADMoniRemoteServer.Create;
begin
  inherited Create;
  FTCPServer := TServerSocket.Create(nil);
  FTCPServer.Port := C_AD_MonitorPort;
  FTCPServer.ServerType := stThreadBlocking;
  FTCPServer.OnGetThread := DoGetThread;

  FReceiver := TADMoniRemoteReceiver.Create(Self);
  FQueue := TADMoniRemoteQueue.Create(FReceiver);
  FPackVersion := C_AD_Mon_PacketVersion;
  FSynchronize := [];
  //FReceiver.PingTime := 1000000;
end;

{-------------------------------------------------------------------------------}
destructor TADMoniRemoteServer.Destroy;
begin
  Tracing := False;
  ADFreeAndNil(FTCPServer);
  ADFreeAndNil(FReceiver);
  ADFreeAndNil(FQueue);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteServer.GetTracing: Boolean;
begin
  Result := FTCPServer.Active;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D14}
  {$WARNINGS OFF}
{$ENDIF}
procedure TADMoniRemoteServer.SetTracing(const AValue: Boolean);
begin
  if Tracing <> AValue then
    if AValue then begin
      FTCPServer.Active := True;
      FReceiver.Resume;
    end
    else begin
      FTCPServer.Active := False;
      while FReceiver.GetQueue.Count > 0 do begin
        if (FReceiver.GetQueue.GetNextEvent in Synchronize) and
           (GetCurrentThreadID = MainThreadID) then
{$IFDEF AnyDAC_D6}
          CheckSynchronize()
{$ELSE}
          FReceiver.GetQueue.Clear
{$ENDIF}
        else
          Sleep(1);
      end;
      FReceiver.Suspend;
    end;
end;
{$IFDEF AnyDAC_D14}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADMoniRemoteServer.GetPort: Integer;
begin
  Result := FTCPServer.Port;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteServer.SetPortI(const AValue: Integer);
begin
  FTCPServer.Port := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMoniRemoteServer.BuildItem(AClient: TADMoniRemoteServerClientThread): TADMoniRemoteServerQueueItem;
begin
  Result := TADMoniRemoteServerQueueItem.Create;
  Result.FHost := AClient.ClientSocket.RemoteHost;
  Result.FProcessID := AClient.FProcessID;
  Result.FMonitorID := AClient.FMonitorID;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteServer.DoGetThread(Sender: TObject;
  ClientSocket: TServerClientWinSocket; var SocketThread: TServerClientThread);
begin
  SocketThread := TADMoniRemoteServerClientThread.Create(Self, ClientSocket);
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteServer.DoExecute(AClient: TADMoniRemoteServerClientThread);
var
  oItem: TADMoniRemoteServerQueueItem;
  oStream: TADMoniRemoteStream;
begin
  oItem := BuildItem(AClient);
  oStream := AClient.FStream;
  try
    oStream.Open(AClient.ClientSocket, omRead);
    try
      oItem.FEvent := TADMoniRemoteQueueEventKind(oStream.ReadInteger(S_AD_MsgEvent));
      oStream.ReadBeginBlock(C_AD_Mon_PacketBodyBlockID);
      case oItem.FEvent of
        ptConnectClient:
          begin
            AClient.FProcessID := oStream.ReadLongWord(S_AD_MsgProcessId);
            AClient.FMonitorID := oStream.ReadLongWord(S_AD_MsgMonitorId);
            AClient.FVersion := oStream.ReadInteger(S_AD_MsgVersion);
            oItem.FProcessID := AClient.FProcessID;
            oItem.FMonitorID := AClient.FMonitorID;
            oItem.FTime := oStream.ReadLongWord(S_AD_MsgTime);
            oItem.FMessage := oStream.ReadString(S_AD_MsgText);
          end;
        ptDisConnectClient:
          begin
            oStream.ReadLongWord(S_AD_MsgProcessId);
            oStream.ReadLongWord(S_AD_MsgMonitorId);
            oStream.ReadLongWord(S_AD_MsgTime);
            AClient.RemoveAllAdapters;
            AClient.ClientSocket.Close;
          end;
        ptRegisterAdapter:
          begin
            oItem.FHandle := oStream.ReadLongWord(S_AD_MsgAdapterHandle);
            oItem.FTime := oStream.ReadLongWord(S_AD_MsgTime);
            oItem.FPath := oStream.ReadString(S_AD_MsgText);
            AClient.FAdapterList.AddAdapter(oItem.FPath, oItem.FHandle);
          end;
        ptUnRegisterAdapter:
          begin
            oItem.FHandle := oStream.ReadLongWord(S_AD_MsgAdapterHandle);
            oItem.FTime := oStream.ReadLongWord(S_AD_MsgTime);
            oItem.FPath := AClient.FAdapterList.FindByHandle(oItem.FHandle);
            AClient.FAdapterList.RemoveAdapter(oItem.FHandle);
          end;
        ptUpdateAdapter:
          begin
            oItem.FHandle := oStream.ReadLongWord(S_AD_MsgAdapterHandle);
            oItem.FTime := oStream.ReadLongWord(S_AD_MsgTime);
            oStream.ReadBlob(S_AD_MsgArgs, oItem.FArgs);
          end;
        ptNotify:
          begin
            oItem.FHandle := oStream.ReadLongWord(S_AD_MsgAdapterHandle);
            if oItem.FHandle > 0 then
              oItem.FPath := AClient.FAdapterList.FindByHandle(oItem.FHandle);
            oItem.FKind := TADMoniEventKind(oStream.ReadInteger(S_AD_MsgNotifyKind));
            oItem.FStep := TADMoniEventStep(oStream.ReadInteger(S_AD_MsgNotifyStep));
            oItem.FTime := oStream.ReadLongWord(S_AD_MsgTime);
            oItem.FMessage := oStream.ReadString(S_AD_MsgText);
            oStream.ReadBlob(S_AD_MsgArgs, oItem.FArgs);
          end;
      end;
      oStream.ReadEndBlock;
      FQueue.PostItem(oItem);
    finally
      oStream.Close;
    end;
  except
    on E: Exception do begin
      AClient.ClientSocket.Close;
      // connection reset by peer
      if (E is ESocketError) and (Pos('10054', LowerCase(E.Message)) <> 0) then begin
        oItem.FEvent := ptDisConnectClient;
        FQueue.PostItem(oItem);
      end
      else begin
        ADFree(oItem);
        raise;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniRemoteServer.DoMessage(AMessage: TADMoniRemoteServerQueueItem);
begin
  if Assigned(FOnMessage) then
    FOnMessage(Self, AMessage);
end;

end.
