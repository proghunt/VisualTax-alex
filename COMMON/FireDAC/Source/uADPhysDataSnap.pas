{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                FireDAC DataSnap driver                }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysDataSnap"'}

unit uADPhysDataSnap;

interface

uses
  Classes,
  uADPhysTDBXBase;

type
  TADPhysDataSnapDriverLink = class;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADPhysDataSnapDriverLink = class(TADPhysTDBXBaseDriverLink)
  protected
    function GetBaseDriverID: String; override;
  end;

{-------------------------------------------------------------------------------}
implementation

uses
  SysUtils, IniFiles, Variants,
  DBXCommon, DbxDatasnap, DbxJSON, DSHTTPCommon, DSService, DSProxy,
{$IFDEF AnyDAC_D18}
    DSCommon,
{$ELSE}
  {$IFDEF AnyDAC_D17}
    DSSession,
  {$ENDIF}
{$ENDIF}
  uADStanIntf, uADStanConst, uADStanUtil, uADStanError,
  uADPhysIntf, uADPhysManager, uADPhysCmdGenerator, uADPhysConnMeta,
    uADPhysDataSnapMeta;

type
  TADPhysDataSnapDriver = class;
  TADPhysDataSnapConnection = class;
  TADPhysDataSnapEventAlerter = class;
  TADPhysDataSnapCommand = class;

  TADPhysDataSnapDriver = class(TADPhysTDBXDriverBase)
  protected
    class function GetBaseDriverID: String; override;
    function InternalCreateConnection(AConnHost: TADPhysConnectionHost): TADPhysConnection; override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; Index: Integer;
      var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  end;

  TADPhysDataSnapConnection = class(TADPhysTDBXConnectionBase)
  private
    FProductVersion: TADVersion;
    function CheckNetworkError(AExc: Exception; AObj: TObject): Boolean;
  protected
    function InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter; override;
    function InternalCreateCommand: TADPhysCommand; override;
    function InternalCreateCommandGenerator(const ACommand: IADPhysCommand):
      TADPhysCommandGenerator; override;
    function InternalCreateMetadata: TObject; override;
    procedure InternalConnect; override;
    procedure InternalPing; override;
    procedure CheckDBXDriver; override;
    procedure BuildDBXConnParams(const AConnectionDef: IADStanConnectionDef;
      AConnProps: TDBXProperties); override;
  end;

  TADPhysDataSnapEventAlerter = class(TADPhysEventAlerter)
  private
    FManagers: TADObjList;
    FCallbacks: TADStringList;
    function GetDSConn: TADPhysDataSnapConnection;
  protected
    procedure InternalAllocHandle; override;
    procedure InternalReleaseHandle; override;
    procedure InternalHandle(AEventMessage: TADPhysEventMessage); override;
    procedure InternalRegister; override;
    procedure InternalUnregister; override;
    procedure InternalSignal(const AEvent: String; const AArgument: Variant); override;
  public
    constructor Create(AConnection: TADPhysConnection; const AKind: String); override;
    destructor Destroy; override;
    property DSConn: TADPhysDataSnapConnection read GetDSConn;
  end;

  TADPhysDataSnapCommand = class(TADPhysTDBXCommand)
  private
    function GetDSConn: TADPhysDataSnapConnection;
  protected
    procedure InternalExecute(ATimes, AOffset: Integer; var ACount: TADCounter); override;
    function InternalOpen: Boolean; override;
    function InternalNextRecordSet: Boolean; override;
    procedure InternalPrepare; override;
  public
    property DSConn: TADPhysDataSnapConnection read GetDSConn;
  end;

const
  S_AD_TCPIP = 'TCP/IP';
  S_AD_HTTP = 'HTTP';

{-------------------------------------------------------------------------------}
{ TADPhysDataSnapDriverLink                                                     }
{-------------------------------------------------------------------------------}
function TADPhysDataSnapDriverLink.GetBaseDriverID: String;
begin
  Result := S_AD_DataSnapId;
end;

{-------------------------------------------------------------------------------}
{ TADPhysDataSnapDriver                                                         }
{-------------------------------------------------------------------------------}
class function TADPhysDataSnapDriver.GetBaseDriverID: String;
begin
  Result := S_AD_DataSnapId;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapDriver.InternalCreateConnection(
  AConnHost: TADPhysConnectionHost): TADPhysConnection;
begin
  Result := TADPhysDataSnapConnection.Create(Self, AConnHost);
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 5;
  if (AKeys <> nil) and
     (CompareText(AKeys.Values[S_AD_ConnParam_DataSnap_Protocol], S_AD_HTTP) = 0) then
    Result := Result + 9;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapDriver.GetConnParams(AKeys: TStrings; Index: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
begin
  ALoginIndex := -1;
  ADefVal := '';
  if Index < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, Index, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then
      ALoginIndex := -1;
  end
  else begin
    Index := Index - inherited GetConnParamCount(AKeys);
    case Index of
    0:
      begin
        AName := S_AD_ConnParam_DataSnap_Protocol;
        AType := S_AD_TCPIP + ';' + S_AD_HTTP;
        ADefVal := S_AD_TCPIP;
      end;
    1:
      begin
        AName := S_AD_ConnParam_Common_Server;
        AType := '@S';
        ADefVal := '127.0.0.1';
        ALoginIndex := 2;
      end;
    2:
      begin
        AName := TDBXPropertyNames.Port;
        AType := '@I';
        if (AKeys <> nil) and
           (CompareText(AKeys.Values[S_AD_ConnParam_DataSnap_Protocol], S_AD_HTTP) = 0) then
          ADefVal := '8080'
        else
          ADefVal := '211';
        ALoginIndex := 3;
      end;
    3:
      begin
        AName := TDBXPropertyNames.BufferKBSize;
        AType := '@I';
        ADefVal := '32';
      end;
    4:
      begin
        AName := TDBXPropertyNames.Filters;
        AType := '@S';
      end;
    else
      if (AKeys <> nil) and
         (CompareText(AKeys.Values[S_AD_ConnParam_DataSnap_Protocol], S_AD_HTTP) = 0) then
        case Index of
        5:
          begin
            AName := TDBXPropertyNames.URLPath;
            AType := '@S';
          end;
        6:
          begin
            AName := TDBXPropertyNames.DatasnapContext;
            AType := '@S';
            ADefVal := DS_CONTEXT;
          end;
        7:
          begin
            AName := TDBXPropertyNames.DSProxyHost;
            AType := '@S';
          end;
        8:
          begin
            AName := TDBXPropertyNames.DSProxyPort;
            AType := '@I';
          end;
        9:
          begin
            AName := TDBXPropertyNames.DSProxyUsername;
            AType := '@S';
          end;
        10:
          begin
            AName := TDBXPropertyNames.DSProxyPassword;
            AType := '@S';
          end;
        11:
          begin
            AName := TDBXPropertyNames.DSAuthenticationScheme;
            AType := ';basic';
          end;
        12:
          begin
            AName := S_AD_ConnParam_Common_LoginTimeout;
            AType := '@I';
          end;
        13:
          begin
            AName := TDBXPropertyNames.CommunicationTimeout;
            AType := '@I';
          end;
        end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysDataSnapConnection                                                     }
{-------------------------------------------------------------------------------}
function TADPhysDataSnapConnection.InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter;
begin
  if CompareText(AEventKind, S_AD_EventKind_DataSnap_Events) = 0 then
    Result := TADPhysDataSnapEventAlerter.Create(Self, AEventKind)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapConnection.InternalCreateCommand: TADPhysCommand;
begin
  Result := TADPhysDataSnapCommand.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  Result := TADPhysCommandGenerator.Create(ACommand);
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapConnection.InternalCreateMetadata: TObject;
begin
  Result := TADPhysDataSnapMetadata.Create(Self, 0, FProductVersion,
    {$IFDEF AnyDAC_Unicode} True {$ELSE} False {$ENDIF});
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapConnection.CheckDBXDriver;
begin
  FDriverName := 'DataSnap';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapConnection.BuildDBXConnParams(
  const AConnectionDef: IADStanConnectionDef; AConnProps: TDBXProperties);

  procedure SetParam(const ADbxPar, AADPar, ADef: String);
  var
    s: String;
  begin
    s := AADPar;
    if s = '' then
      s := ADbxPar;
    s := AConnectionDef.AsString[s];
    if s = '' then
      s := ADef;
    if s <> '' then
      AConnProps.Values[ADbxPar] := s;
  end;

begin
  AConnProps.Values[TDBXPropertyNames.DriverName] := FDriverName;
  AConnProps.Values[TDBXPropertyNames.DriverUnit] := 'Data.DbxDatasnap';
  SetParam(TDBXPropertyNames.CommunicationProtocol, S_AD_ConnParam_DataSnap_Protocol, S_AD_TCPIP);
  SetParam(TDBXPropertyNames.HostName, S_AD_ConnParam_Common_Server, '127.0.0.1');
  if CompareText(AConnectionDef.AsString[S_AD_ConnParam_DataSnap_Protocol], S_AD_TCPIP) = 0 then
    SetParam(TDBXPropertyNames.Port, '', '211')
  else
    SetParam(TDBXPropertyNames.Port, '', '8080');
  SetParam(TDBXPropertyNames.BufferKBSize, '', '32');
  SetParam(TDBXPropertyNames.Filters, '', '');
  SetParam(TDBXPropertyNames.URLPath, '', '');
  SetParam(TDBXPropertyNames.DatasnapContext, '', DS_CONTEXT);
  SetParam(TDBXPropertyNames.DSProxyHost, '', '');
  SetParam(TDBXPropertyNames.DSProxyPort, '', '');
  SetParam(TDBXPropertyNames.DSProxyUsername, '', '');
  SetParam(TDBXPropertyNames.DSProxyPassword, '', '');
  SetParam(TDBXPropertyNames.DSAuthenticationUser, S_AD_ConnParam_Common_UserName, '');
  SetParam(TDBXPropertyNames.DSAuthenticationPassword, S_AD_ConnParam_Common_Password, '');
  SetParam(TDBXPropertyNames.DSAuthenticationScheme, '', '');
  SetParam(TDBXPropertyNames.ConnectTimeout, S_AD_ConnParam_Common_LoginTimeout, '');
  SetParam(TDBXPropertyNames.CommunicationTimeout, '', '');
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapConnection.CheckNetworkError(AExc: Exception; AObj: TObject): Boolean;
var
  oExc: ETDBXNativeException;
  oExcClass: TClass;
begin
  oExcClass := AExc.ClassType;
  while (oExcClass <> nil) and (CompareText(oExcClass.ClassName, 'EIdException') <> 0) do
    oExcClass := oExcClass.ClassParent;
  if oExcClass <> nil then begin
    oExc := ETDBXNativeException.Create(er_AD_DBXGeneral,
      ADExceptionLayers([S_AD_LPhys, S_AD_TDBXId, S_AD_DataSnapId]) + ' ' + AExc.Message);
    oExc.AppendError(1, TDBXErrorCodes.ConnectionFailed, AExc.Message, '', ekServerGone, -1, -1);
    ADException(AObj, oExc {$IFDEF AnyDAC_Monitor}, False {$ENDIF});
    Result := True;
  end
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapConnection.InternalConnect;
begin
  try
    inherited InternalConnect;
    FProductVersion := ADVerStr2Int(DbxConnection.ProductVersion);
  except
    on E: Exception do
      if not CheckNetworkError(E, Self) then
        raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapConnection.InternalPing;
begin
  try
    // simplest DataSnap command
    DbxConnection.GetVendorProperty(TDBXPropertyNames.ProductVersion);
  except
    on E: Exception do
      if not CheckNetworkError(E, Self) then
        raise;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysDataSnapEventMessage                                                   }
{-------------------------------------------------------------------------------}
type
  TADPhysDataSnapEventMessage = class(TADPhysEventMessage)
  private
    FCBName: String;
    FArgs: Variant;
  public
    constructor Create(const ACBName: String; const AArgs: Variant);
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysDataSnapEventMessage.Create(const ACBName: String;
  const AArgs: Variant);
begin
  inherited Create;
  FCBName := ACBName;
  FArgs := AArgs;
end;

{-------------------------------------------------------------------------------}
{ TADDataSnapCallback                                                           }
{-------------------------------------------------------------------------------}
type
  TADDataSnapCallback = class(TDBXCallback)
  private
    FAlerter: TADPhysDataSnapEventAlerter;
    FName: String;
  public
    constructor Crate(AAlerter: TADPhysDataSnapEventAlerter; const AName: String);
    function Execute(const AArg: TJSONValue): TJSONValue; overload; override;
    function Execute(AArg: TObject): TObject; overload; override;
  end;

{-------------------------------------------------------------------------------}
constructor TADDataSnapCallback.Crate(AAlerter: TADPhysDataSnapEventAlerter;
  const AName: String);
begin
  inherited Create;
  FAlerter := AAlerter;
  FName := AName;
end;

{-------------------------------------------------------------------------------}
function TADDataSnapCallback.Execute(const AArg: TJSONValue): TJSONValue;
var
  V: Variant;
  i: Integer;
begin
  if AArg is TJSONArray then begin
    V := VarArrayCreate([0, TJSONArray(AArg).Size - 1], varADWString);
    for i := 0 to TJSONArray(AArg).Size - 1 do
      V[i] := TJSONArray(AArg).Get(i).Value;
  end
  else
    V := AArg.Value;

  if FAlerter.IsRunning then
    FAlerter.FMsgThread.EnqueueMsg(TADPhysDataSnapEventMessage.Create(FName, V));

  Result := TJSONTrue.Create;
end;

{-------------------------------------------------------------------------------}
function TADDataSnapCallback.Execute(AArg: TObject): TObject;
begin
  Result := Execute(TDSClientCallbackChannelManager(FAlerter.FManagers[0]).
    MarshalData(AArg));
end;

{-------------------------------------------------------------------------------}
{ TADPhysDataSnapEventAlerter                                                   }
{-------------------------------------------------------------------------------}
constructor TADPhysDataSnapEventAlerter.Create(AConnection: TADPhysConnection;
  const AKind: String);
begin
  inherited Create(AConnection, AKind);
  FManagers := TADObjList.Create;
  FCallbacks := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysDataSnapEventAlerter.Destroy;
begin
  inherited Destroy;
  ADFreeAndNil(FManagers);
  ADFreeAndNil(FCallbacks);
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapEventAlerter.GetDSConn: TADPhysDataSnapConnection;
begin
  Result := TADPhysDataSnapConnection(ConnectionObj);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapEventAlerter.InternalAllocHandle;
var
  oDef: IADStanConnectionDef;
  oNames: TStrings;
  i: Integer;
  oMan: TDSClientCallbackChannelManager;
  sCBName: String;
  sChnlName: String;

  function Def(const AValue, ADef: String): String;
  begin
    if AValue = '' then
      Result := ADef
    else
      Result := AValue;
  end;

  function GenSessionId: String;
  begin
{$IFDEF AnyDAC_D18}
    Result := TDSSessionHelper.GenerateSessionId;
{$ELSE}
    Result := TDSTunnelSession.GenerateSessionId;
{$ENDIF}
  end;

begin
  oDef := DSConn.ConnectionDef;
  oNames := GetNames;

  for i := 0 to oNames.Count - 1 do begin
    oMan := TDSClientCallbackChannelManager.Create(nil);
    FManagers.Add(oMan);

    oMan.CommunicationProtocol := Def(oDef.AsString[S_AD_ConnParam_DataSnap_Protocol], S_AD_TCPIP);
    oMan.DSHostname := Def(oDef.Server, '127.0.0.1');
    if CompareText(oMan.CommunicationProtocol, S_AD_TCPIP) = 0 then
      oMan.DSPort := Def(oDef.AsString[S_AD_ConnParam_Common_Port], '211')
    else
      oMan.DSPort := Def(oDef.AsString[S_AD_ConnParam_Common_Port], '8080');
    oMan.DSPath := oDef.AsString[TDBXPropertyNames.URLPath];
    oMan.UserName := oDef.UserName;
    oMan.Password := oDef.Password;
    oMan.ProxyHost := oDef.AsString[TDBXPropertyNames.DSProxyHost];
    oMan.ProxyPort := oDef.AsInteger[TDBXPropertyNames.DSProxyPort];
    oMan.ProxyUsername := oDef.AsString[TDBXPropertyNames.DSProxyUsername];
    oMan.ProxyPassword := oDef.AsString[TDBXPropertyNames.DSProxyPassword];
    oMan.ConnectionTimeout := oDef.AsString[S_AD_ConnParam_Common_LoginTimeout];
    oMan.CommunicationTimeout := oDef.AsString[TDBXPropertyNames.CommunicationTimeout];
    oMan.ManagerId := GenSessionId;

    sChnlName := ADNameFromIndex(oNames, i);
    if sChnlName = '' then
      sChnlName := GenSessionId;
    oMan.ChannelName := sChnlName;

    sCBName := ADValueFromIndex(oNames, i);
    if sCBName = '' then
      sCBName := GenSessionId;
    FCallbacks.Add(sCBName);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapEventAlerter.InternalHandle(
  AEventMessage: TADPhysEventMessage);
begin
  if GetHandler = nil then
    Exit;
  GetHandler.HandleEvent(TADPhysDataSnapEventMessage(AEventMessage).FCBName,
                         TADPhysDataSnapEventMessage(AEventMessage).FArgs);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapEventAlerter.InternalRegister;
var
  i: Integer;
  oCB: TADDataSnapCallback;
begin
  for i := 0 to FManagers.Count - 1 do begin
    oCB := TADDataSnapCallback.Crate(Self, FCallbacks[i]);
    TDSClientCallbackChannelManager(FManagers[i]).RegisterCallback(oCB.FName, oCB);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapEventAlerter.InternalUnregister;
var
  i: Integer;
begin
  for i := 0 to FManagers.Count - 1 do
    TDSClientCallbackChannelManager(FManagers[i]).UnregisterCallback(FCallbacks[i]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapEventAlerter.InternalReleaseHandle;
var
  i: Integer;
begin
  for i := 0 to FManagers.Count - 1 do
    ADFree(TDSClientCallbackChannelManager(FManagers[i]));
  FManagers.Clear;
  FCallbacks.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapEventAlerter.InternalSignal(const AEvent: String;
  const AArgument: Variant);
var
  iChnl, i: Integer;
  oClnt: TDSAdminClient;
  oArr: TJSONArray;
  oMsg: TJSONValue;
  oRsp: TJSONValue;
begin
  iChnl := GetNames.IndexOfName(AEvent);
  if iChnl = -1 then
    iChnl := GetNames.IndexOf(AEvent);

  if VarIsArray(AArgument) then begin
    oArr := TJSONArray.Create;
    for i := VarArrayLowBound(AArgument, 1) to VarArrayHighBound(AArgument, 1) do
      oArr.Add(VarToStrDef(AArgument[i], ''));
    oMsg := oArr;
  end
  else
    oMsg := TJSONString.Create(VarToStrDef(AArgument, ''));

  oClnt := TDSAdminClient.Create(DSConn.DbxConnection);
  try
    if iChnl <> -1 then
      oClnt.BroadcastToChannel(AEvent, oMsg)
    else
      oClnt.NotifyCallback(AArgument[0], AEvent, oMsg, oRsp);
  finally
    ADFree(oClnt);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysDataSnapCommand                                                        }
{-------------------------------------------------------------------------------}
function TADPhysDataSnapCommand.GetDSConn: TADPhysDataSnapConnection;
begin
  Result := TADPhysDataSnapConnection(TDBXConn);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapCommand.InternalPrepare;
begin
  try
    inherited InternalPrepare;
  except
    on E: Exception do
      if not DSConn.CheckNetworkError(E, Self) then
        raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysDataSnapCommand.InternalExecute(ATimes, AOffset: Integer;
  var ACount: TADCounter);
begin
  try
    inherited InternalExecute(ATimes, AOffset, ACount);
  except
    on E: Exception do
      if not DSConn.CheckNetworkError(E, Self) then
        raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapCommand.InternalOpen: Boolean;
begin
  Result := False;
  try
    Result := inherited InternalOpen;
  except
    on E: Exception do
      if not DSConn.CheckNetworkError(E, Self) then
        raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysDataSnapCommand.InternalNextRecordSet: Boolean;
begin
  Result := False;
  try
    Result := inherited InternalNextRecordSet;
  except
    on E: Exception do
      if not DSConn.CheckNetworkError(E, Self) then
        raise;
  end;
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterDriverClass(TADPhysDataSnapDriver);

finalization
//  ADPhysManagerObj.UnRegisterDriverClass(TADPhysDataSnapDriver);

end.
