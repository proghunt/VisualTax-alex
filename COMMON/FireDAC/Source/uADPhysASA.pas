{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{          FireDAC Sybase SQL Anywhere driver           }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysASA"'}

unit uADPhysASA;

interface

uses
  Classes,
  uADStanIntf,
  uADPhysManager, uADPhysODBCWrapper, uADPhysODBCBase, uADPhysASAWrapper;

type
  TADPhysASADriverLink = class;
{$IFDEF AnyDAC_ASM}
  TADASAService = class;
  TADASABackup = class;
  TADASAValidate = class;
{$ENDIF}

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TADPhysASADriverLink = class(TADPhysODBCBaseDriverLink)
  private
    FToolLib: String;
  protected
    function GetBaseDriverID: String; override;
    function IsConfigured: Boolean; override;
    procedure ApplyTo(const AParams: IADStanDefinition); override;
  published
    property ToolLib: String read FToolLib write FToolLib;
  end;

{$IFDEF AnyDAC_ASM}
  TADASAProgressEvent = type TASAToolMessageEvent;

  TADASAService = class (TADPhysODBCBaseService)
  private
    FOnProgress: TADASAProgressEvent;
    function GetDriverLink: TADPhysASADriverLink;
    procedure SetDriverLink(const AValue: TADPhysASADriverLink);
    function GetToolLib: TASAToolLib;
  protected
    function GetEnv: TODBCEnvironment; override;
    procedure CheckActive(AAutoActivate, ANeedActivation: Boolean); override;
  public
    property ToolLib: TASAToolLib read GetToolLib;
  published
    property DriverLink: TADPhysASADriverLink read GetDriverLink write SetDriverLink;
    property OnProgress: TADASAProgressEvent read FOnProgress write FOnProgress;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32)]
{$ENDIF}
  TADASABackup = class (TADASAService)
  private
    FConnectParams: String;
    FCheckpointLogType: TASABackupCheckpointLogType;
    FPageBlocksize: Longword;
    FHotlogFilename: String;
    FOutputDir: String;
    FFlags: TASABackupFlags;
    FStartLine: String;
  protected
    procedure InternalExecute; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Backup;
  published
    property ConnectParams: String read FConnectParams write FConnectParams;
    property StartLine: String read FStartLine write FStartLine;
    property OutputDir: String read FOutputDir write FOutputDir;
    property HotlogFilename: String read FHotlogFilename write FHotlogFilename;
    property CheckpointLogType: TASABackupCheckpointLogType read FCheckpointLogType
      write FCheckpointLogType default bclDefault;
    property PageBlocksize: Longword read FPageBlocksize write FPageBlocksize
      default 0;
    property Flags: TASABackupFlags read FFlags write FFlags default [];
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32)]
{$ENDIF}
  TADASAValidate = class (TADASAService)
  private
    FConnectParams: String;
    FStartLine: String;
    FValidateType: TASAValidateType;
    FTables: TStrings;
    FFlags: TASAValidateFlags;
    procedure SetTables(const AValue: TStrings);
  protected
    procedure InternalExecute; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Validate;
  published
    property ConnectParams: String read FConnectParams write FConnectParams;
    property StartLine: String read FStartLine write FStartLine;
    property Tables: TStrings read FTables write SetTables;
    property Flags: TASAValidateFlags read FFlags write FFlags default [];
    property ValidateType: TASAValidateType read FValidateType write FValidateType default vtNormal;
  end;
{$ENDIF}

{-------------------------------------------------------------------------------}
implementation

uses
  SysUtils,
{$IFDEF AnyDAC_D6Base}
  StrUtils, Variants,
{$ENDIF}
  uADStanConst, uADStanError, uADStanUtil,
  uADPhysIntf, uADPhysCmdGenerator, uADPhysODBCCli, uADPhysASACli, uADPhysASAMeta;

type
  TADPhysASADriver = class;
  TADPhysASAConnection = class;
  TADPhysASAEventAlerter = class;

  TADPhysASACliHandles = array [0..1] of Pointer;
  PADPhysASACliHandles = ^TADPhysODBCCliHandles;

  TADPhysASADriver = class(TADPhysODBCDriverBase)
  private
    FToolLib: TASAToolLib;
    FCliObj: TADPhysASACliHandles;
  protected
    class function GetBaseDriverID: String; override;
    procedure InternalLoad; override;
    procedure InternalUnload; override;
    function InternalCreateConnection(AConnHost: TADPhysConnectionHost): TADPhysConnection; override;
    function GetCliObj: Pointer; override;
    procedure GetODBCConnectStringKeywords(AKeywords: TStrings); override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; AIndex: Integer; var AName, AType,
      ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  public
    constructor Create(AManager: TADPhysManager; const ADriverDef: IADStanDefinition); override;
    destructor Destroy; override;
  end;

  TADPhysASAConnection = class (TADPhysODBCConnectionBase)
  private
{$IFDEF AnyDAC_ASM}
    FMsgCbkThunk: TADMethodThunk;
    procedure DoMsgCallback(SQLCA: Pointer; msg_type: byte; code: LongWord;
      len: Word; msg: PChar); stdcall;
{$ENDIF}
  protected
    function InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter; override;
    function InternalCreateCommandGenerator(const ACommand:
      IADPhysCommand): TADPhysCommandGenerator; override;
    function InternalCreateMetadata: TObject; override;
    procedure GetStrsMaxSizes(AStrDataType: SQLSmallint; AFixedLen: Boolean;
      out ACharSize, AByteSize: Integer); override;
    function GetExceptionClass: EODBCNativeExceptionClass; override;
    procedure InternalConnect; override;
    procedure InternalDisconnect; override;
  public
    constructor Create(ADriverObj: TADPhysDriver; AConnHost: TADPhysConnectionHost); override;
    destructor Destroy; override;
  end;

  TADPhysASAEventAlerter = class (TADPhysEventAlerter)
  private
{$IFDEF AnyDAC_ASM}
    function ParseMessage(const AMessage: String): Boolean;
{$ENDIF}
  protected
    procedure InternalHandle(AEventMessage: TADPhysEventMessage); override;
    procedure InternalSignal(const AEvent: String; const AArgument: Variant); override;
  end;

{-------------------------------------------------------------------------------}
{ TADPhysASADriverLink                                                          }
{-------------------------------------------------------------------------------}
function TADPhysASADriverLink.GetBaseDriverID: String;
begin
  Result := S_AD_ASAId;
end;

{-------------------------------------------------------------------------------}
function TADPhysASADriverLink.IsConfigured: Boolean;
begin
  Result := inherited IsConfigured or (FToolLib <> '');
end;

{-------------------------------------------------------------------------------}
procedure TADPhysASADriverLink.ApplyTo(const AParams: IADStanDefinition);
begin
  inherited ApplyTo(AParams);
  if FToolLib <> '' then
    AParams.AsString[S_AD_ConnParam_ASA_ToolLib] := FToolLib;
end;

{-------------------------------------------------------------------------------}
{ TADASAService                                                                 }
{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_ASM}
function TADASAService.GetDriverLink: TADPhysASADriverLink;
begin
  Result := inherited DriverLink as TADPhysASADriverLink;
end;

{-------------------------------------------------------------------------------}
procedure TADASAService.SetDriverLink(const AValue: TADPhysASADriverLink);
begin
  inherited DriverLink := AValue;
end;

{-------------------------------------------------------------------------------}
function TADASAService.GetEnv: TODBCEnvironment;
begin
  Result := TODBCEnvironment(PADPhysASACliHandles(CliObj)^[0]);
end;

{-------------------------------------------------------------------------------}
function TADASAService.GetToolLib: TASAToolLib;
begin
  Result := TASAToolLib(PADPhysASACliHandles(CliObj)^[1]);
end;

{-------------------------------------------------------------------------------}
procedure TADASAService.CheckActive(AAutoActivate, ANeedActivation: Boolean);
begin
  inherited CheckActive(AAutoActivate, ANeedActivation);
  if not Assigned(ToolLib.DBToolsInit) then
    ADException(Self, [S_AD_LPhys, DriverLink.ActualDriverID], er_AD_ASADBToolNotFound, []);
end;

{-------------------------------------------------------------------------------}
{ TADASABackup                                                                  }
{-------------------------------------------------------------------------------}
constructor TADASABackup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCheckpointLogType := bclDefault;
end;

{-------------------------------------------------------------------------------}
procedure TADASABackup.InternalExecute;
var
  oBckp: TASABackup;
begin
  oBckp := TASABackup.Create(ToolLib, Self);
  try
    oBckp.ConnectParams := ConnectParams;
    oBckp.StartLine := StartLine;
    oBckp.OutputDir := OutputDir;
    oBckp.HotlogFilename := HotlogFilename;
    oBckp.CheckpointLogType := CheckpointLogType;
    oBckp.PageBlocksize := PageBlocksize;
    oBckp.Flags := Flags;
    oBckp.OnMessage := OnProgress;
    oBckp.Backup;
  finally
    ADFree(oBckp);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADASABackup.Backup;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
{ TADASAValidate                                                                }
{-------------------------------------------------------------------------------}
constructor TADASAValidate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTables := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADASAValidate.Destroy;
begin
  ADFreeAndNil(FTables);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADASAValidate.SetTables(const AValue: TStrings);
begin
  FTables.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADASAValidate.InternalExecute;
var
  oVldt: TASAValidate;
begin
  oVldt := TASAValidate.Create(ToolLib, Self);
  try
    oVldt.ConnectParams := ConnectParams;
    oVldt.StartLine := StartLine;
    oVldt.Tables := Tables;
    oVldt.Flags := Flags;
    oVldt.ValidateType := ValidateType;
    oVldt.OnMessage := OnProgress;
    oVldt.Validate;
  finally
    ADFree(oVldt);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADASAValidate.Validate;
begin
  Execute;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADPhysASADriver                                                              }
{-------------------------------------------------------------------------------}
constructor TADPhysASADriver.Create(AManager: TADPhysManager;
  const ADriverDef: IADStanDefinition);
begin
  inherited Create(AManager, ADriverDef);
  FToolLib := TASAToolLib.Create(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysASADriver.Destroy;
begin
  inherited Destroy;
  ADFreeAndNil(FToolLib);
end;

{-------------------------------------------------------------------------------}
class function TADPhysASADriver.GetBaseDriverID: String;
begin
  Result := S_AD_ASAId;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysASADriver.InternalLoad;
var
  sToolLib: String;
begin
  ODBCAdvanced := 'CommLinks=ShMem';
  inherited InternalLoad;
  if ODBCDriver = '' then
    ODBCDriver := FindBestDriver(
      {$IFDEF MSWINDOWS} ['SQL Anywhere 12', 'SQL Anywhere 11', 'SQL Anywhere 10',
      'Adaptive Server Anywhere 9.%', 'Adaptive Server Anywhere 8.%',
      'Adaptive Server Anywhere 7.%', 'Sybase SQL Anywhere %'] {$ENDIF}
      {$IFDEF AnyDAC_POSIX} ['SQL Anywhere%', 'SQLAnywhere%'], C_SQLAnywhere12Lib {$ENDIF});
  if Params <> nil then
    sToolLib := Params.AsXString[S_AD_ConnParam_ASA_ToolLib]
  else
    sToolLib := '';
  FToolLib.Load(sToolLib);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysASADriver.InternalUnload;
begin
  FToolLib.Unload;
  inherited InternalUnload;
end;

{-------------------------------------------------------------------------------}
function TADPhysASADriver.InternalCreateConnection(
  AConnHost: TADPhysConnectionHost): TADPhysConnection;
begin
  Result := TADPhysASAConnection.Create(Self, AConnHost);
end;

{-------------------------------------------------------------------------------}
function TADPhysASADriver.GetCliObj: Pointer;
begin
  FCliObj[0] := ODBCEnvironment;
  FCliObj[1] := FToolLib;
  Result := @FCliObj[0];
end;

{-------------------------------------------------------------------------------}
procedure TADPhysASADriver.GetODBCConnectStringKeywords(AKeywords: TStrings);
var
  i: Integer;
begin
  inherited GetODBCConnectStringKeywords(AKeywords);
  i := AKeywords.IndexOfName(S_AD_ConnParam_Common_Password);
  if i <> -1 then
    AKeywords[i] := S_AD_ConnParam_Common_Password + '=PWD*';
  AKeywords.Add(S_AD_ConnParam_Common_Server + '=EngineName');
  AKeywords.Add(S_AD_ConnParam_Common_Database + '=DatabaseName');
  AKeywords.Add(S_AD_ConnParam_ASA_DatabaseFile + '=' +
    S_AD_ConnParam_ASA_DatabaseFile + '*');
  AKeywords.Add(S_AD_ConnParam_Common_OSAuthent + '=Integrated');
  AKeywords.Add(S_AD_ConnParam_ASA_Compress);
  AKeywords.Add(S_AD_ConnParam_ASA_Encrypt + '=Encryption');
  AKeywords.Add(S_AD_ConnParam_Common_ApplicationName + '=AppInfo');
  AKeywords.Add('=COMMLINKS');
end;

{-------------------------------------------------------------------------------}
function TADPhysASADriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 10;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysASADriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
begin
  ALoginIndex := -1;
  ADefVal := '';
  if AIndex < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then
      ALoginIndex := 4;
  end
  else begin
    case AIndex - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_Common_Server;
        AType := '@S';
        ALoginIndex := 3;
      end;
    1:
      begin
        AName := S_AD_ConnParam_ASA_DatabaseFile;
        AType := '@F:SQL Anywhere Database|*.db';
      end;
    2:
      begin
        AName := S_AD_ConnParam_Common_OSAuthent;
        AType := '@Y';
        ALoginIndex := 2;
      end;
    3:
      begin
        AName := S_AD_ConnParam_ASA_Compress;
        AType := '@Y';
      end;
    4:
      begin
        AName := S_AD_ConnParam_ASA_Encrypt;
        AType := '@S';
      end;
    5:
      begin
        AName := S_AD_ConnParam_Common_ApplicationName;
        AType := '@S';
      end;
    6:
      begin
        AName := S_AD_ConnParam_Common_MetaDefCatalog;
        AType := '@S';
      end;
    7:
      begin
        AName := S_AD_ConnParam_Common_MetaDefSchema;
        AType := '@S';
      end;
    8:
      begin
        AName := S_AD_ConnParam_Common_MetaCurCatalog;
        AType := '@S';
      end;
    9:
      begin
        AName := S_AD_ConnParam_Common_MetaCurSchema;
        AType := '@S';
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysASAConnection                                                          }
{-------------------------------------------------------------------------------}
constructor TADPhysASAConnection.Create(ADriverObj: TADPhysDriver;
  AConnHost: TADPhysConnectionHost);
begin
  inherited Create(ADriverObj, AConnHost);
{$IFDEF AnyDAC_ASM}
  FMsgCbkThunk := TADMethodThunk.Create(Self, @TADPhysASAConnection.DoMsgCallback);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
destructor TADPhysASAConnection.Destroy;
begin
  inherited Destroy;
{$IFDEF AnyDAC_ASM}
  ADFreeAndNil(FMsgCbkThunk);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADPhysASAConnection.InternalCreateEvent(
  const AEventKind: String): TADPhysEventAlerter;
begin
  if CompareText(AEventKind, S_AD_EventKind_ASA_Events) = 0 then
    Result := TADPhysASAEventAlerter.Create(Self, AEventKind)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysASAConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysASACommandGenerator.Create(ACommand)
  else
    Result := TADPhysASACommandGenerator.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysASAConnection.InternalCreateMetadata: TObject;
var
  iSrvVer, iClntVer: TADVersion;
begin
  GetVersions(iSrvVer, iClntVer);
  Result := TADPhysASAMetadata.Create(Self, iSrvVer, iClntVer, GetKeywords);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysASAConnection.GetStrsMaxSizes(AStrDataType: SQLSmallint;
  AFixedLen: Boolean; out ACharSize, AByteSize: Integer);
begin
  AByteSize := 32766;
  ACharSize := AByteSize;
  case AStrDataType of
  SQL_C_CHAR, SQL_C_BINARY:
    ;
  SQL_C_WCHAR:
    ACharSize := AByteSize div SizeOf(SQLWChar);
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_ASAId]);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysASAConnection.GetExceptionClass: EODBCNativeExceptionClass;
begin
  Result := EASANativeException;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysASAConnection.InternalConnect;
begin
  inherited InternalConnect;
{$IFDEF AnyDAC_ASM}
  if ADVerStr2Int(ODBCConnection.DRIVER_VER) >= cvSybaseASA9 then
    ODBCConnection.REGISTER_MESSAGE_CALLBACK := FMsgCbkThunk.CallAddress;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysASAConnection.InternalDisconnect;
begin
{$IFDEF AnyDAC_ASM}
  if ODBCConnection.Connected and (ADVerStr2Int(ODBCConnection.DRIVER_VER) >= cvSybaseASA9) then
    ODBCConnection.REGISTER_MESSAGE_CALLBACK := nil;
{$ENDIF}
  inherited InternalDisconnect;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_ASM}
procedure TADPhysASAConnection.DoMsgCallback(SQLCA: Pointer; msg_type: byte;
  code: LongWord; len: Word; msg: PChar); stdcall;
var
  sMsg: String;
  lParse: Boolean;
  i: Integer;
begin
  SetString(sMsg, msg, len);
  lParse := False;
  for i := 0 to GetEventCount - 1 do
    lParse := lParse or TADPhysASAEventAlerter(FEventList[i]).ParseMessage(sMsg);
  if not lParse then begin
    if ODBCConnection.Info = nil then
      ODBCConnection.Info := EASANativeException.Create(SQL_SUCCESS, ODBCConnection);
    EASANativeException(ODBCConnection.Info).AppendError(ODBCConnection,
      SQLSmallint(ODBCConnection.Info.ErrorCount + 1), '', code, sMsg, sMsg,
      '', '', ekServerOutput, 0, -1);
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADPhysASAEventMessage                                                        }
{-------------------------------------------------------------------------------}
type
  TADPhysASAEventMessage = class(TADPhysEventMessage)
  private
    FEvent,
    FMessage: String;
  public
    constructor Create(const AEvent, AMessage: String);
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysASAEventMessage.Create(const AEvent, AMessage: String);
begin
  inherited Create;
  FEvent := AEvent;
  FMessage := AMessage;
end;

{-------------------------------------------------------------------------------}
{ TADPhysASAEventAlerter                                                        }
{-------------------------------------------------------------------------------}
const
  C_Delim = '$$';

{$IFDEF AnyDAC_ASM}
function TADPhysASAEventAlerter.ParseMessage(const AMessage: String): Boolean;
var
  sEvent, sMsg: String;
  i1, i2: Integer;
begin
  if Pos(C_AD_SysNamePrefix + C_Delim, AMessage) = 1 then begin
    i1 := Length(C_AD_SysNamePrefix) + Length(C_Delim) + 1;
    i2 := ADPosEx(C_Delim, AMessage, i1);
    if i2 = 0 then
      i2 := Length(AMessage) + 1;
    sEvent := Copy(AMessage, i1, i2 - i1);
    sMsg := Copy(AMessage, i2, Length(AMessage) - i2);
    if GetNames.IndexOf(sEvent) >= 0 then
      FMsgThread.EnqueueMsg(TADPhysASAEventMessage.Create(sEvent, sMsg));
    Result := True;
  end
  else
    Result := False;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADPhysASAEventAlerter.InternalHandle(AEventMessage: TADPhysEventMessage);
var
  oMsg: TADPhysASAEventMessage;
begin
  if GetHandler <> nil then begin
    oMsg := TADPhysASAEventMessage(AEventMessage);
    GetHandler.HandleEvent(oMsg.FEvent, oMsg.FMessage);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysASAEventAlerter.InternalSignal(const AEvent: String;
  const AArgument: Variant);
var
  s: String;
  oCmd: IADPhysCommand;
begin
  // _AD_$$event$$argument
  s := C_AD_SysNamePrefix + C_Delim + AEvent;
  if not (VarIsNull(AArgument) or VarIsEmpty(AArgument)) then
    s := s + C_Delim + VarToStr(AArgument);
  GetConnection.CreateCommand(oCmd);
  SetupCommand(oCmd);
  oCmd.Prepare('MESSAGE ' + QuotedStr(s) + ' TYPE INFO TO CLIENT FOR ALL');
  oCmd.Execute();
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterDriverClass(TADPhysASADriver);

end.
