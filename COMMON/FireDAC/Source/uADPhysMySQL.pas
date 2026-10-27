{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                 FireDAC MySQL driver                  }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysMySQL"'}

unit uADPhysMySQL;

interface

uses
  Classes,
  uADStanIntf,
  uADPhysManager;

type
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TADPhysMySQLDriverLink = class(TADPhysDriverLink)
  private
    FEmbeddedArgs: TStrings;
    FEmbeddedGroups: TStrings;
    procedure SetEmbeddedArgs(const AValue: TStrings);
    procedure SetEmbeddedGroups(const AValue: TStrings);
  protected
    function GetBaseDriverID: String; override;
    function IsConfigured: Boolean; override;
    procedure ApplyTo(const AParams: IADStanDefinition); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property EmbeddedArgs: TStrings read FEmbeddedArgs write SetEmbeddedArgs;
    property EmbeddedGroups: TStrings read FEmbeddedGroups write SetEmbeddedGroups;
  end;

{-------------------------------------------------------------------------------}
implementation

uses
{$IFDEF MSWINDOWS}
  // Preventing from "Inline has not expanded"
  Windows,
{$ENDIF}
  SysUtils, DB, SyncObjs,
{$IFDEF AnyDAC_D6Base}
  Variants, FmtBCD,
  {$IFDEF AnyDAC_D6}
  SqlTimSt, DateUtils,
  {$ENDIF}
{$ENDIF}
  uADStanOption, uADStanParam, uADStanError, uADStanUtil,
    uADStanConst,
  uADGUIxIntf,
  uADDatSManager,
  uADPhysIntf, uADPhysCmdGenerator, uADPhysMySQLCli, uADPhysMySQLWrapper,
    uADPhysMySQLMeta;

type
  TADPhysMySQLDriver = class;
  TADPhysMySQLConnection = class;
  TADPhysMySQLTransaction = class;
  TADPhysMySQLCommand = class;

  TADPhysMySQLDriver = class(TADPhysDriver)
  private
    FLib: TMySQLLib;
  protected
    class function GetBaseDriverID: String; override;
    procedure InternalLoad; override;
    procedure InternalUnload; override;
    function InternalCreateConnection(AConnHost: TADPhysConnectionHost): TADPhysConnection; override;
    function GetCliObj: Pointer; override;
    function GetConnParamCount(AKeys: TStrings): Integer; override;
    procedure GetConnParams(AKeys: TStrings; AIndex: Integer;
      var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer); override;
  public
    constructor Create(AManager: TADPhysManager; const ADriverDef: IADStanDefinition); override;
    destructor Destroy; override;
  end;

  TADPhysMySQLResultMode = (hrStore, hrUse, hrChoose);

  TADPhysMySQLConnection = class(TADPhysConnection)
  private
    FSession: TMySQLSession;
    FServerVersion, FClientVersion: TADVersion;
    FLock: TCriticalSection;
    FResultMode: TADPhysMySQLResultMode;
    FNameModes: TADPhysMySQLNameModes;
    FTinyIntFormat: TADDataType;
    procedure UpdateServerOutput;
  protected
    procedure InternalConnect; override;
    procedure InternalDisconnect; override;
    procedure InternalPing; override;
    function InternalCreateCommand: TADPhysCommand; override;
    function InternalCreateTransaction: TADPhysTransaction; override;
{$IFDEF AnyDAC_MONITOR}
    procedure InternalTracingChanged; override;
{$ENDIF}
    function GetItemCount: Integer; override;
    procedure GetItem(AIndex: Integer; out AName: String;
      out AValue: Variant; out AKind: TADMoniAdapterItemKind); override;
    procedure InternalChangePassword(const AUserName, AOldPassword, ANewPassword: String); override;
    function InternalCreateMetadata: TObject; override;
    function InternalCreateCommandGenerator(const ACommand: IADPhysCommand): TADPhysCommandGenerator; override;
    procedure InternalExecuteDirect(const ASQL: String; ATransaction: TADPhysTransaction); override;
    function GetMessages: EADDBEngineException; override;
    function GetCliObj: Pointer; override;
    function InternalGetCliHandle: Pointer; override;
    function GetLastAutoGenValue(const AName: String): Variant; override;
    function QueryValue(const ACmd: String; AColIndex: Integer): String;
    function InternalGetCurrentCatalog: String; override;
    procedure InternalAnalyzeSession(AMessages: TStrings); override;
  public
    constructor Create(ADriverObj: TADPhysDriver; AConnHost: TADPhysConnectionHost); override;
    destructor Destroy; override;
  end;

  TADPhysMySQLTransaction = class(TADPhysTransaction)
  protected
    procedure InternalStartTransaction(ATxID: LongWord); override;
    procedure InternalCommit(ATxID: LongWord); override;
    procedure InternalRollback(ATxID: LongWord); override;
    procedure InternalChanged; override;
    procedure InternalNotify(ANotification: TADPhysTxNotification;
      ACommandObj: TADPhysCommand); override;
  end;

  TADPhysMySQLCommand = class(TADPhysCommand)
  private
    FMetaInfoSQLs: array of String;
    FColIndex: LongWord;
    FCursor: TMySQLResult;
    function GetExpandedSQL(ATimes, AOffset: Integer): TADByteString;
    function DataValue2MySQL(AData: Pointer; ALen: LongWord; AType: TADDataType;
      out ATypeSupported: Boolean): TADByteString;
    function MySQL2DataValue(ASrcData: PADByteString; ASrcLen: LongWord;
      var ADestData: Pointer; var ADestLen: LongWord; AType: TADDataType;
      AAttributes: TADDataAttributes; out ATypeSupported: Boolean): Boolean;
    procedure FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
    procedure FetchMetaRow(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowIndex: Integer);
    procedure MySQLType2ADType(var AStr: String; var AType: TADDataType;
      var AAttrs: TADDataAttributes; var ALen: LongWord; var APrec, AScale: Integer);
    function GetResultMode: TADPhysMySQLResultMode;
    function FetchFKRows(ATable: TADDatSTable; AParentRow: TADDatSRow): Integer;
    function GetCrsData(ACrsCol: Integer; var AData: Pointer;
      var ALen: LongWord; AType: TADDataType): Boolean; overload;
    function GetCrsData(ACrsCol: Integer; AData: Pointer): String; overload;
    function FetchSPParamRows(ATable: TADDatSTable;
      AParentRow: TADDatSRow): Integer;
    procedure GetParamValues(AIndex: Integer);
    procedure GetCursor;
    procedure CloseStatement(AForceClose: Boolean; AIndex: Integer);
  protected
    procedure InternalClose; override;
    procedure InternalExecute(ATimes, AOffset: Integer; var ACount: TADCounter); override;
    function InternalFetchRowSet(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowsetSize: LongWord): LongWord; override;
    procedure InternalAbort; override;
    function InternalOpen: Boolean; override;
    function InternalNextRecordSet: Boolean; override;
    procedure InternalPrepare; override;
    function InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean; override;
    function InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean; override;
    procedure InternalUnprepare; override;
    function GetCliObj: Pointer; override;
  end;

const
  S_AD_CharacterSets = 'big5;dec8;cp850;hp8;koi8r;latin1;latin2;swe7;ascii;ujis;' +
    'sjis;cp1251;hebrew;tis620;euckr;koi8u;gb2312;greek;cp1250;gbk;latin5;armscii8;' +
    'cp866;keybcs2;macce;macroman;cp852;latin7;cp1256;cp1257;binary;utf8';

  S_AD_StoreResult = 'Store';
  S_AD_UseResult = 'Use';
  S_AD_ChooseResult = 'Choose';

  S_AD_Boolean = 'Boolean';
  S_AD_Integer = 'Integer';

var
  GLock: TCriticalSection;

{-------------------------------------------------------------------------------}
{ TADPhysMySQLDriverLink                                                        }
{-------------------------------------------------------------------------------}
constructor TADPhysMySQLDriverLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEmbeddedArgs := TADStringList.Create;
  FEmbeddedGroups := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysMySQLDriverLink.Destroy;
begin
  ADFreeAndNil(FEmbeddedArgs);
  ADFreeAndNil(FEmbeddedGroups);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLDriverLink.GetBaseDriverID: String;
begin
  Result := S_AD_MySQLId;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLDriverLink.ApplyTo(const AParams: IADStanDefinition);

  function ToText(AStrs: TStrings): String;
  var
    i: Integer;
  begin
    Result := '';
    for i := 0 to AStrs.Count - 1 do begin
      if Result <> '' then
        Result := Result + ';';
      Result := Result + AStrs[i];
    end;
  end;

begin
  inherited ApplyTo(AParams);
  if FEmbeddedArgs.Count > 0 then
    AParams.AsString[S_AD_ConnParam_MySQL_EmbeddedArgs] := ToText(FEmbeddedArgs);
  if FEmbeddedArgs.Count > 0 then
    AParams.AsString[S_AD_ConnParam_MySQL_EmbeddedGroups] := ToText(FEmbeddedGroups);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLDriverLink.IsConfigured: Boolean;
begin
  Result := inherited IsConfigured or (FEmbeddedArgs.Count > 0) or
    (FEmbeddedGroups.Count > 0);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLDriverLink.SetEmbeddedArgs(const AValue: TStrings);
begin
  FEmbeddedArgs.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLDriverLink.SetEmbeddedGroups(const AValue: TStrings);
begin
  FEmbeddedGroups.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
{ TADPhysMySQLDriver                                                            }
{-------------------------------------------------------------------------------}
constructor TADPhysMySQLDriver.Create(AManager: TADPhysManager;
  const ADriverDef: IADStanDefinition);
begin
  inherited Create(AManager, ADriverDef);
  GLock := TCriticalSection.Create;
  FLib := TMySQLLib.Create(ADPhysManagerObj);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysMySQLDriver.Destroy;
begin
  inherited Destroy;
  ADFreeAndNil(FLib);
  ADFreeAndNil(GLock);
end;

{-------------------------------------------------------------------------------}
class function TADPhysMySQLDriver.GetBaseDriverID: String;
begin
  Result := S_AD_MySQLId;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLDriver.InternalLoad;
var
  sHome, sLib, sEmbArgs, sEmbGrps: String;
begin
  sHome := '';
  sLib := '';
  sEmbArgs := '';
  sEmbGrps := '';
  if Params <> nil then begin
    GetVendorParams(sHome, sLib);
    sEmbArgs := Params.AsString[S_AD_ConnParam_MySQL_EmbeddedArgs];
    sEmbGrps := Params.AsString[S_AD_ConnParam_MySQL_EmbeddedGroups];
  end;
  FLib.Load(sHome, sLib, sEmbArgs, sEmbGrps);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLDriver.InternalUnload;
begin
  FLib.Unload;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLDriver.InternalCreateConnection(
  AConnHost: TADPhysConnectionHost): TADPhysConnection;
begin
  Result := TADPhysMySQLConnection.Create(Self, AConnHost);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLDriver.GetCliObj: Pointer;
begin
  Result := FLib;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 12;
  if (AKeys <> nil) and
     (CompareText(AKeys.Values[S_AD_ConnParam_MySQL_UseSSL], S_AD_True) = 0) then
    Result := Result + 5;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
begin
  ALoginIndex := -1;
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
        AType := S_AD_Local;
        ADefVal := S_AD_Local;
        ALoginIndex := 2;
      end;
    1:
      begin
        AName := S_AD_ConnParam_Common_Port;
        AType := '@I';
        ADefVal := IntToStr(MYSQL_PORT);
        ALoginIndex := 3;
      end;
    2:
      begin
        AName := S_AD_ConnParam_MySQL_Compress;
        AType := '@L';
        ADefVal := S_AD_True;
      end;
    3:
      begin
        AName := S_AD_ConnParam_MySQL_UseSSL;
        AType := '@L';
        ADefVal := S_AD_False;
      end;
    4:
      begin
        AName := S_AD_ConnParam_Common_LoginTimeout;
        AType := '@I';
        ADefVal := '';
      end;
    5:
      begin
        AName := S_AD_ConnParam_MySQL_ReadTimeout;
        AType := '@I';
        ADefVal := '';
      end;
    6:
      begin
        AName := S_AD_ConnParam_MySQL_WriteTimeout;
        AType := '@I';
        ADefVal := '';
      end;
    7:
      begin
        AName := S_AD_ConnParam_MySQL_ResultMode;
        AType := S_AD_StoreResult + ';' + S_AD_UseResult + ';' + S_AD_ChooseResult;
        ADefVal := S_AD_StoreResult;
      end;
    8:
      begin
        AName := S_AD_ConnParam_Common_CharacterSet;
        AType := S_AD_CharacterSets;
        ADefVal := '';
      end;
    9:
      begin
        AName := S_AD_ConnParam_MySQL_TinyIntFormat;
        AType := S_AD_Boolean + ';' + S_AD_Integer;
        ADefVal := S_AD_Boolean;
      end;
    10:
      begin
        AName := S_AD_ConnParam_Common_MetaDefCatalog;
        AType := '@S';
        ADefVal := '';
      end;
    11:
      begin
        AName := S_AD_ConnParam_Common_MetaCurCatalog;
        AType := '@S';
        ADefVal := '';
      end;
    else
      if (AKeys <> nil) and
         (CompareText(AKeys.Values[S_AD_ConnParam_MySQL_UseSSL], S_AD_True) = 0) then begin
        AType := '@S';
        ADefVal := '';
        case AIndex - inherited GetConnParamCount(AKeys) of
       12: AName := S_AD_ConnParam_MySQL_SSL_key;
       13: AName := S_AD_ConnParam_MySQL_SSL_cert;
       14: AName := S_AD_ConnParam_MySQL_SSL_ca;
       15: AName := S_AD_ConnParam_MySQL_SSL_capath;
       16: AName := S_AD_ConnParam_MySQL_SSL_cipher;
        end;
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysMySQLConnection                                                        }
{-------------------------------------------------------------------------------}
constructor TADPhysMySQLConnection.Create(ADriverObj: TADPhysDriver;
  AConnHost: TADPhysConnectionHost);
begin
  FLock := TCriticalSection.Create;
  inherited Create(ADriverObj, AConnHost);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysMySQLConnection.Destroy;
begin
  inherited Destroy;
  ADFreeAndNil(FLock);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.InternalCreateCommand: TADPhysCommand;
begin
  Result := TADPhysMySQLCommand.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.InternalCreateTransaction: TADPhysTransaction;
begin
  Result := TADPhysMySQLTransaction.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.InternalCreateMetadata: TObject;
begin
  Result := TADPhysMySQLMetadata.Create(Self, False, FServerVersion,
    FClientVersion, FNameModes,
    (FSession <> nil) and (FSession.Encoder.Encoding in [ecUTF8, ecUTF16]));
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysMySQLCommandGenerator.Create(ACommand)
  else
    Result := TADPhysMySQLCommandGenerator.Create(Self);
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalTracingChanged;
begin
  if FSession <> nil then begin
    FSession.Monitor := FMonitor;
    FSession.Tracing := FTracing;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalConnect;
var
  sHost, sDatabase, sUserName, sPwd: String;
  s: String;
  iPort: Integer;
  uiClientFlag: LongWord;
  oDef: IADStanConnectionDef;

  procedure SetTimeout(const AParamName: String; AOption: mysql_option);
  var
    uiTimeout: LongWord;
  begin
    if GetConnectionDef.HasValue(AParamName) then begin
      uiTimeout := GetConnectionDef.AsInteger[AParamName];
      FSession.Options[AOption] := @uiTimeout;
    end;
  end;

begin
  sHost := GetConnectionDef.Server;
  if CompareText(sHost, S_AD_Local) = 0 then
    sHost := '127.0.0.1';
  if GetConnectionDef.HasValue(S_AD_ConnParam_Common_Port) then
    iPort := GetConnectionDef.Port
  else
    iPort := MYSQL_PORT;
  sDatabase := GetConnectionDef.ExpandedDatabase;
  sUserName := GetConnectionDef.UserName;
  sPwd := GetConnectionDef.Password;

  if InternalGetSharedCliHandle() <> nil then
    FSession := TMySQLSession.CreateUsingHandle(TADPhysMySQLDriver(DriverObj).FLib,
      PMYSQL(InternalGetSharedCliHandle()), Self)
  else
    FSession := TMySQLSession.Create(TADPhysMySQLDriver(DriverObj).FLib, Self);
  UpdateServerOutput;
{$IFDEF AnyDAC_MONITOR}
  InternalTracingChanged;
{$ENDIF}
  FClientVersion := FSession.ClientVersion;
  if InternalGetSharedCliHandle() = nil then
    FSession.Init;

  FResultMode := hrStore;
  if GetConnectionDef.HasValue(S_AD_ConnParam_MySQL_ResultMode) then begin
    s := GetConnectionDef.AsString[S_AD_ConnParam_MySQL_ResultMode];
    if CompareText(s, S_AD_StoreResult) = 0 then
      FResultMode := hrStore
    else if CompareText(s, S_AD_UseResult) = 0 then
      FResultMode := hrUse
    else if CompareText(s, S_AD_ChooseResult) = 0 then
      FResultMode := hrChoose;
  end;
  FTinyIntFormat := dtBoolean;
  if CompareText(GetConnectionDef.AsString[S_AD_ConnParam_MySQL_TinyIntFormat], S_AD_Integer) = 0 then
    FTinyIntFormat := dtSByte;

  if InternalGetSharedCliHandle() = nil then begin
    if GetConnectionDef.AsBoolean[S_AD_ConnParam_MySQL_Compress] then
      FSession.Options[MYSQL_OPT_COMPRESS] := nil;
    SetTimeout(S_AD_ConnParam_Common_LoginTimeout, MYSQL_OPT_CONNECT_TIMEOUT);
    SetTimeout(S_AD_ConnParam_MySQL_ReadTimeout, MYSQL_OPT_READ_TIMEOUT);
    SetTimeout(S_AD_ConnParam_MySQL_WriteTimeout, MYSQL_OPT_WRITE_TIMEOUT);

    uiClientFlag := CLIENT_FOUND_ROWS or CLIENT_LONG_FLAG;
    if not IsConsole then
      uiClientFlag := uiClientFlag or CLIENT_INTERACTIVE;
    if sDatabase <> '' then
      uiClientFlag := uiClientFlag or CLIENT_CONNECT_WITH_DB;
    if GetConnectionDef.AsBoolean[S_AD_ConnParam_MySQL_UseSSL] then begin
      uiClientFlag := uiClientFlag or CLIENT_SSL;
      oDef := GetConnectionDef;
      FSession.SSLInit(oDef.AsString[S_AD_ConnParam_MySQL_SSL_key],
                       oDef.AsString[S_AD_ConnParam_MySQL_SSL_cert],
                       oDef.AsString[S_AD_ConnParam_MySQL_SSL_ca],
                       oDef.AsString[S_AD_ConnParam_MySQL_SSL_capath],
                       oDef.AsString[S_AD_ConnParam_MySQL_SSL_cipher]);
    end;
    if FClientVersion >= mvMySQL050000 then
      uiClientFlag := uiClientFlag or AD_50_CLIENT_PROTOCOL_41 or CLIENT_MULTI_QUERIES or
        CLIENT_MULTI_RESULTS
    else if FClientVersion >= mvMySQL040100 then
      uiClientFlag := uiClientFlag or CLIENT_PROTOCOL_41 or CLIENT_MULTI_STATEMENTS;

    GLock.Enter;
    try
      FSession.Connect(sHost, sUserName, sPwd, sDatabase, iPort, uiClientFlag);
    finally
      GLock.Leave;
    end;
  end;

  FServerVersion := FSession.ServerVersion;
  if FServerVersion < mvMySQL032000 then
    ADException(Self, [S_AD_LPhys, S_AD_MySQLId], er_AD_MySQLBadVersion, [FServerVersion]);

  if InternalGetSharedCliHandle() = nil then begin
    if GetConnectionDef.HasValue(S_AD_ConnParam_Common_CharacterSet) then
      FSession.CharacterSetName := GetConnectionDef.AsString[S_AD_ConnParam_Common_CharacterSet];
    InternalExecuteDirect('SET SQL_AUTO_IS_NULL = 0', nil);
  end;

  FNameModes := [nmCaseSens, nmDBApply];
  if FServerVersion >= mvMySQL032306 then begin
    case StrToIntDef(QueryValue('SHOW VARIABLES LIKE ''lower_case_table_names''', 1), 0) of
    0: FNameModes := [nmCaseSens];
    1: FNameModes := [nmDefLowerCase];
    2: FNameModes := [];
    end;
    if FServerVersion >= mvMySQL040002 then
      Include(FNameModes, nmDBApply);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalDisconnect;
begin
  if FSession <> nil then begin
    GLock.Enter;
    try
      FSession.Disconnect;
    finally
      GLock.Leave;
      ADFreeAndNil(FSession);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalPing;
begin
  FLock.Enter;
  try
    FSession.Ping;
  finally
    FLock.Leave;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalExecuteDirect(const ASQL: String;
  ATransaction: TADPhysTransaction);
begin
  FLock.Enter;
  try
    UpdateServerOutput;
    FSession.Query(ASQL, Self);
  finally
    FLock.Leave;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.QueryValue(const ACmd: String; AColIndex: Integer): String;
var
  oRes: TMySQLResult;
  pData: Pointer;
  iLen: LongWord;
begin
  InternalExecuteDirect(ACmd, nil);
  oRes := FSession.StoreResult;
  try
    oRes.Fetch(1);
    pData := nil;
    iLen := 0;
    oRes.GetData(AColIndex, pData, iLen);
    Result := FSession.Encoder.Decode(PADByteString(pData), iLen);
  finally
    ADFree(oRes);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalChangePassword(const AUserName, AOldPassword,
  ANewPassword: String);
var
  s: String;
begin
  FLock.Enter;
  try
    s := QueryValue('SELECT CONCAT(SUBSTRING_INDEX(USER(), ''@'', 1), ''@"'', SUBSTRING_INDEX(USER(), ''@'', -1), ''"'')', 0);
    InternalExecuteDirect('SET PASSWORD FOR ' + s + ' = PASSWORD("' + ANewPassword + '")', nil);
  finally
    FLock.Leave;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.GetLastAutoGenValue(const AName: String): Variant;
begin
  if FSession <> nil then
{$IFDEF AnyDAC_D6Base}
    Result := FSession.Insert_ID
{$ELSE}
    Result := Integer(FSession.Insert_ID)
{$ENDIF}
  else
    Result := Null;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.GetItemCount: Integer;
begin
  Result := inherited GetItemCount;
  if DriverObj.State in [drsLoaded, drsActive] then begin
    Inc(Result, 2);
    if FSession <> nil then
      Inc(Result, 6);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.GetItem(AIndex: Integer; out AName: String;
  out AValue: Variant; out AKind: TADMoniAdapterItemKind);
var
  s: String;
begin
  if AIndex < inherited GetItemCount then
    inherited GetItem(AIndex, AName, AValue, AKind)
  else
    case AIndex - inherited GetItemCount of
    0:
      begin
        AName := 'DLL';
        AValue := TADPhysMySQLDriver(DriverObj).FLib.DLLName;
        AKind := ikClientInfo;
      end;
    1:
      begin
        AName := 'Client version';
        AValue := IntToStr(TADPhysMySQLDriver(DriverObj).FLib.Version);
        AKind := ikClientInfo;
      end;
    2:
      begin
        AName := 'Server info';
        AValue := FSession.ServerInfo;
        AKind := ikSessionInfo;
      end;
    3:
      begin
        AName := 'Client info';
        AValue := FSession.ClientInfo;
        AKind := ikSessionInfo;
      end;
    4:
      begin
        AName := 'Characterset name';
        AValue := FSession.CharacterSetName;
        AKind := ikSessionInfo;
      end;
    5:
      begin
        AName := 'Host info';
        AValue := FSession.HostInfo;
        AKind := ikSessionInfo;
      end;
    6:
      begin
        AName := 'Name modes';
        s := '';
        if nmCaseSens in FNameModes then
          s := s + 'CS'
        else
          s := s + 'CI';
        if nmDefLowerCase in FNameModes then
          s := s + 'LC'
        else
          s := s + 'AI';
        if nmDBApply in FNameModes then
          s := s + 'TD'
        else
          s := s + 'T';
        AValue := s;
        AKind := ikSessionInfo;
      end;
    7:
      begin
        AName := 'SSL Cipher';
        AValue := FSession.SSLCipher;
        AKind := ikSessionInfo;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.GetMessages: EADDBEngineException;
begin
  if FSession <> nil then
    Result := FSession.Info
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.GetCliObj: Pointer;
begin
  Result := FSession;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.InternalGetCliHandle: Pointer;
begin
  if FSession <> nil then
    Result := FSession.MySQL
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLConnection.InternalGetCurrentCatalog: String;
begin
  if FSession <> nil then
    Result := String(FSession.DB)
  else
    Result := inherited InternalGetCurrentCatalog;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.InternalAnalyzeSession(AMessages: TStrings);
begin
  inherited InternalAnalyzeSession(AMessages);
  if (FServerVersion >= mvMySQL050000) and (FServerVersion < mvMySQL050100) then
    AMessages.Add(Format('Warning: The server [%s] version does not support Foreign ' +
                         'Key/Foreign Key Columns metadata retrieval.', [ADVerInt2Str(FServerVersion)]));
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLConnection.UpdateServerOutput;
begin
  FSession.ServerOutput := TADTopResourceOptions(FOptions.ResourceOptions).ServerOutput;
end;

{-------------------------------------------------------------------------------}
{ TADPhysMySQLTransaction                                                       }
{-------------------------------------------------------------------------------}
procedure TADPhysMySQLTransaction.InternalChanged;
var
  s: String;
begin
  if xoAutoCommit in GetOptions.Changed then
    TADPhysMySQLConnection(ConnectionObj).InternalExecuteDirect(
      'SET AUTOCOMMIT = ' + IntToStr(Integer(GetOptions.AutoCommit)), nil);
  if xoIsolation in GetOptions.Changed then begin
    case GetOptions.Isolation of
    xiUnspecified:    Exit;
    xiDirtyRead:      s := 'READ UNCOMMITTED';
    xiReadCommitted:  s := 'READ COMMITTED';
    xiRepeatableRead: s := 'REPEATABLE READ';
    xiSnapshot:       s := 'REPEATABLE READ';
    xiSerializible:   s := 'SERIALIZABLE';
    end;
    TADPhysMySQLConnection(ConnectionObj).InternalExecuteDirect(
      'SET SESSION TRANSACTION ISOLATION LEVEL ' + s, nil);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLTransaction.InternalStartTransaction(ATxID: LongWord);
begin
  DisconnectCommands(nil, dmRelease);
  TADPhysMySQLConnection(ConnectionObj).InternalExecuteDirect('BEGIN', nil);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLTransaction.InternalCommit(ATxID: LongWord);
begin
  DisconnectCommands(nil, dmRelease);
  TADPhysMySQLConnection(ConnectionObj).InternalExecuteDirect('COMMIT', nil);
  if Retaining then
    InternalStartTransaction(ATxID);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLTransaction.InternalRollback(ATxID: LongWord);
begin
  DisconnectCommands(nil, dmRelease);
  TADPhysMySQLConnection(ConnectionObj).InternalExecuteDirect('ROLLBACK', nil);
  if Retaining then
    InternalStartTransaction(ATxID);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLTransaction.InternalNotify(ANotification: TADPhysTxNotification;
  ACommandObj: TADPhysCommand);
begin
  if (ANotification = cpBeforeCmdExecute) and (
        // When server may have more results, eg in case of CALL <sp>, then
        // next mysql_real_query will give "Commands out of sync" error. See
        // http://dev.mysql.com/doc/refman/5.0/en/c-api-multiple-queries.html
        TADPhysMySQLConnection(ConnectionObj).FSession.HasMoreResults or
        (TADPhysMySQLCommand(ACommandObj).GetCommandKind in [skCommit, skRollback])
     ) then
    DisconnectCommands(nil, dmRelease);
  inherited InternalNotify(ANotification, ACommandObj);
end;

{-------------------------------------------------------------------------------}
{ TADPhysMySQLCommand                                                           }
{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.GetCliObj: Pointer;
begin
  Result := FCursor;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.InternalPrepare;
var
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
  i: Integer;
begin
  // generate metadata SQL command
  if GetMetaInfoKind <> uADPhysIntf.mkNone then begin
    GetSelectMetaInfoParams(rName);
    // SHOW INDEX FOR dual - always returns error
    if (GetMetaInfoKind in [mkTableFields, mkIndexes, mkIndexFields,
                            mkPrimaryKey, mkPrimaryKeyFields,
                            mkForeignKeys, mkForeignKeyFields]) and
       (CompareText(rName.FBaseObject, 'dual') = 0) then
      Exit;
    GenerateSelectMetaInfo(rName);
    i := 1;
    while i <= Length(FDbCommandText) do begin
      SetLength(FMetaInfoSQLs, Length(FMetaInfoSQLs) + 1);
      FMetaInfoSQLs[Length(FMetaInfoSQLs) - 1] := ADExtractFieldName(FDbCommandText, i);
    end;
  end

  // generate metadata SQL command
  else if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
    GetConnection.CreateMetadata(oConnMeta);
    oConnMeta.DecodeObjName(Trim(GetCommandText()), rName, Self, []);
    FDbCommandText := '';
    if fiMeta in FOptions.FetchOptions.Items then
      GenerateStoredProcParams(rName);
    if FDbCommandText = '' then
      GenerateStoredProcCall(rName);
  end;

  // adjust SQL command
  GenerateLimitSelect();
  GenerateParamMarkers();
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.InternalUnprepare;
begin
  CloseStatement(True, -1);
  SetLength(FMetaInfoSQLs, 0);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean;
begin
  ASSERT(ATabInfo.FSourceID = -1);
  Result := OpenBlocked;
  if Result then
    if ATabInfo.FSourceID = -1 then begin
      ATabInfo.FSourceName := GetCommandText;
      ATabInfo.FSourceID := 1;
      ATabInfo.FOriginName := '';
      FColIndex := 0;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean;
var
  oFld:     TMySQLField;
  name:     PADAnsiString;
  srcname:  PADAnsiString;
  db:       PADAnsiString;
  table:    PADAnsiString;
  type_:    Byte;
  length:   LongWord;
  flags:    LongWord;
  decimals: LongWord;
  charset:  LongWord;
  oFmtOpts: TADFormatOptions;
  eType:    TADDataType;
  oEnc:     TADEncoder;

  function IsBinary: Boolean;
  begin
    Result := ((charset = 63) or (charset = 0)) and ((flags and BINARY_FLAG) <> 0);
  end;

begin
  if FColIndex >= FCursor.FieldCount then begin
    Result := False;
    Exit;
  end;
  oFmtOpts := FOptions.FormatOptions;
  oFld := FCursor.Fields[FColIndex];
  name := nil;
  srcname := nil;
  db := nil;
  table := nil;
  type_ := 0;
  length := 0;
  flags := 0;
  decimals := 0;
  charset := 0;
  oFld.GetInfo(name, srcname, table, db, type_, length, flags, decimals, charset);

  // MySQL returns BINARY_FLAG for non-DBMS column based SELECT items,
  // like a DAYNAME(SYSDATE()). So, just workaround this issue.
  if ((srcname = nil) or (srcname^ = TADAnsiChar(#0))) and
     (type_ = FIELD_TYPE_VAR_STRING) and (flags and BINARY_FLAG <> 0) then begin
    flags := flags and not BINARY_FLAG;
    if TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Encoding = ecUTF8 then
      length := length * C_AD_MaxUTF8Len;
  end;

  AColInfo.FSourceID := FColIndex + 1;
  oEnc := TADPhysMySQLConnection(FConnectionObj).FSession.Encoder;
  AColInfo.FSourceName := oEnc.Decode(name, -1);
  AColInfo.FOriginColName := oEnc.Decode(srcname, -1);
  AColInfo.FOriginTabName.FCatalog := oEnc.Decode(db, -1);
  AColInfo.FOriginTabName.FObject := oEnc.Decode(table, -1);

  AColInfo.FAttrs := [];
  AColInfo.FForceAddOpts := [];
  if (flags and NOT_NULL_FLAG) = 0 then
    Include(AColInfo.FAttrs, caAllowNull);
  if not (type_ in [FIELD_TYPE_TINY_BLOB, FIELD_TYPE_MEDIUM_BLOB,
                    FIELD_TYPE_LONG_BLOB, FIELD_TYPE_BLOB]) then
    Include(AColInfo.FAttrs, caSearchable);
  if (flags and AUTO_INCREMENT_FLAG) <> 0 then begin
    Include(AColInfo.FAttrs, caAutoInc);
    Include(AColInfo.FAttrs, caAllowNull);
    Include(AColInfo.FForceAddOpts, coAfterInsChanged);
  end;
  if (TADPhysMySQLConnection(FConnectionObj).FServerVersion >= mvMySQL050200) and
     not (caAutoInc in AColInfo.FAttrs) and
     ((flags and NO_DEFAULT_VALUE_FLAG) = 0) then
    Include(AColInfo.FAttrs, caDefault);

  eType := dtUnknown;
  AColInfo.FLen := 0;
  AColInfo.FPrec := 0;
  AColInfo.FScale := 0;

  case type_ of
  FIELD_TYPE_BIT:
    if length = 1 then
      eType := dtBoolean
    else begin
      eType := dtByteString;
      AColInfo.FLen := (length + 7) div 8;
      Include(AColInfo.FAttrs, caFixedLen);
    end;
  FIELD_TYPE_TINY:
    begin
      if (length = 1) and (TADPhysMySQLConnection(FConnectionObj).FTinyIntFormat = dtBoolean) then
        eType := dtBoolean
      else if (flags and UNSIGNED_FLAG) <> 0 then
        eType := dtByte
      else
        eType := dtSByte;
      AColInfo.FPrec := length;
    end;
  FIELD_TYPE_SHORT:
    begin
      if (flags and UNSIGNED_FLAG) <> 0 then
        eType := dtUInt16
      else
        eType := dtInt16;
      AColInfo.FPrec := length;
    end;
  FIELD_TYPE_LONG,
  FIELD_TYPE_INT24:
    begin
      if (flags and UNSIGNED_FLAG) <> 0 then
        eType := dtUInt32
      else
        eType := dtInt32;
      AColInfo.FPrec := length;
    end;
  FIELD_TYPE_LONGLONG:
    begin
      if (flags and UNSIGNED_FLAG) <> 0 then
        eType := dtUInt64
      else
        eType := dtInt64;
      AColInfo.FPrec := length;
    end;
  FIELD_TYPE_FLOAT,
  FIELD_TYPE_DOUBLE:
    begin
      if length = 12 then
        eType := dtSingle
      else
        eType := dtDouble;
      AColInfo.FPrec := length;
      AColInfo.FScale := decimals;
    end;
  FIELD_TYPE_DECIMAL,
  FIELD_TYPE_NEWDECIMAL:
    begin
      if decimals = 0 then
        if (flags and UNSIGNED_FLAG) <> 0 then begin
          if length <= 3 then
            eType := dtByte
          else if length <= 5 then
            eType := dtUInt16
          else if length <= 10 then
            eType := dtUInt32
          else if length <= 21 then
            eType := dtUInt64;
        end
        else begin
          if length <= 2 then
            eType := dtSByte
          else if length <= 4 then
            eType := dtInt16
          else if length <= 9 then
            eType := dtInt32
          else if length <= 20 then
            eType := dtInt64;
        end;
      AColInfo.FPrec := length;
      if decimals > 0 then
        Dec(AColInfo.FPrec);
      if (flags and UNSIGNED_FLAG) = 0 then
        Dec(AColInfo.FPrec);
      AColInfo.FScale := decimals;
      if eType = dtUnknown then
        if (AColInfo.FScale <= oFmtOpts.MaxBcdScale) and
           (AColInfo.FPrec <= oFmtOpts.MaxBcdPrecision) then
          eType := dtBCD
        else
          eType := dtFmtBCD;
    end;
  FIELD_TYPE_DATE,
  FIELD_TYPE_NEWDATE:
    eType := dtDate;
  FIELD_TYPE_TIME:
    eType := dtTime;
  FIELD_TYPE_DATETIME:
    eType := dtDateTime;
  FIELD_TYPE_YEAR:
    eType := dtUInt16;
  FIELD_TYPE_TIMESTAMP:
    begin
      eType := dtDateTimeStamp;
      Include(AColInfo.FAttrs, caRowVersion);
      Include(AColInfo.FAttrs, caAllowNull);
    end;
  FIELD_TYPE_ENUM,
  FIELD_TYPE_SET,
  FIELD_TYPE_VAR_STRING,
  FIELD_TYPE_STRING,
  FIELD_TYPE_VARCHAR:
    if length <= oFmtOpts.MaxStringSize then begin
      AColInfo.FLen := length;
      if IsBinary then
        eType := dtByteString
{$IFNDEF AnyDAC_NATIVE_UTF8}
      else if TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Encoding = ecUTF8 then begin
        eType := dtWideString;
        // MySQL multiplies character length by 3 for UTF8 client character set
        AColInfo.FLen := length div 3;
      end
{$ENDIF}
      else
        eType := dtAnsiString;
      if type_ = FIELD_TYPE_STRING then
        Include(AColInfo.FAttrs, caFixedLen);
    end
    else begin
      if IsBinary then
        eType := dtBlob
{$IFNDEF AnyDAC_NATIVE_UTF8}
      else if TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Encoding = ecUTF8 then
        eType := dtWideMemo
{$ENDIF}
      else
        eType := dtMemo;
      Include(AColInfo.FAttrs, caBlobData);
    end;
  FIELD_TYPE_TINY_BLOB,
  FIELD_TYPE_MEDIUM_BLOB,
  FIELD_TYPE_LONG_BLOB,
  FIELD_TYPE_BLOB:
    if length <= oFmtOpts.MaxStringSize then begin
      AColInfo.FLen := length;
      if IsBinary then
        eType := dtByteString
{$IFNDEF AnyDAC_NATIVE_UTF8}
      else if TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Encoding = ecUTF8 then
        eType := dtWideString
{$ENDIF}
      else
        eType := dtAnsiString;
    end
    else begin
      if IsBinary then
        eType := dtBlob
{$IFNDEF AnyDAC_NATIVE_UTF8}
      else if TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Encoding = ecUTF8 then
        eType := dtWideMemo
{$ENDIF}
      else
        eType := dtMemo;
      Include(AColInfo.FAttrs, caBlobData);
    end;
  FIELD_TYPE_NULL:
    if (flags and NUM_FLAG) <> 0 then
      eType := dtInt32
{$IFNDEF AnyDAC_NATIVE_UTF8}
    else if TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Encoding = ecUTF8 then
      eType := dtWideString
{$ENDIF}
    else
      eType := dtAnsiString;
  end;
  AColInfo.FSourceType := eType;
  if GetMetaInfoKind = mkNone then
    oFmtOpts.ResolveDataType(AColInfo.FSourceName, eType, AColInfo.FLen,
      AColInfo.FPrec, AColInfo.FScale, AColInfo.FType, AColInfo.FLen, True)
  else
    AColInfo.FType := eType;
  Inc(FColIndex);
  Result := True;
end;

{-------------------------------------------------------------------------------}
{$WARNINGS OFF}
// D2007 gives strange warning "Return value might be undefined"
function TADPhysMySQLCommand.DataValue2MySQL(AData: Pointer; ALen: LongWord;
  AType: TADDataType; out ATypeSupported: Boolean): TADByteString;
const
  SDateFmt: String = '''%.4d-%.2d-%.2d''';
  STimeFmt: String = '''%s%.2d:%.2d:%.2d.%.6d''';
  SDateTimeFmt1: String = '''%.4d-%.2d-%.2d %.2d:%.2d:%.2d.%.6d''';
  SDateTimeFmt2: String = '''%.4d%.2d%.2d%.2d%.2d%.2d''';
  SUnsignedFmt: String = '%u';
var
  iSz: Integer;
  aBuff: array [0..65] of Char;
  pBuff: PChar;
  s: String;
  dt: TDateTime;
  y, mo, d, h, mi, se, ms: Word;
  sFmt: String;
  rTS: TADSQLTimeStamp;

  procedure RetStr(const AStr: String);
  begin
    s := AStr;
    pBuff := PChar(s);
    iSz := Length(s);
  end;

  function EncodeUTF8(AData: Pointer; ALen: LongWord; AEncoding: TADEncoding): TADByteString;
  var
    pUTF8: Pointer;
    iSz: Integer;
  begin
{$IFDEF AnyDAC_NATIVE_UTF8}
    if not (AEncoding in [ecANSI, ecUTF8]) then begin
{$ENDIF}
      pUTF8 := nil;
      iSz := TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.
        Encode(AData, ALen, pUTF8, AEncoding, ecUTF8);
{$IFDEF AnyDAC_NATIVE_UTF8}
    end
    else begin
      pUTF8 := AData;
      iSz := ALen;
    end;
{$ENDIF}
    SetLength(Result, (iSz * 2 + 9) * SizeOf(TADAnsiChar));
    iSz := TADPhysMySQLConnection(FConnectionObj).FSession.EscapeString(
      PADAnsiString(Result) + 6 * SizeOf(TADAnsiChar), PADAnsiString(pUTF8), iSz);
    PADAnsiString(Result)^ := TADAnsiChar('_');
    (PADAnsiString(Result) + 1)^ := TADAnsiChar('u');
    (PADAnsiString(Result) + 2)^ := TADAnsiChar('t');
    (PADAnsiString(Result) + 3)^ := TADAnsiChar('f');
    (PADAnsiString(Result) + 4)^ := TADAnsiChar('8');
    (PADAnsiString(Result) + 5)^ := TADAnsiChar('''');
    (PADAnsiString(Result) + iSz + 6)^ := TADAnsiChar('''');
    (PADAnsiString(Result) + iSz + 7)^ := TADAnsiChar(#0);
    SetLength(Result, iSz + 8);
  end;

begin
  SetLength(Result, 0);
  ATypeSupported := True;
  pBuff := aBuff;
  iSz := SizeOf(aBuff) div SizeOf(Char);
  case AType of
  dtBoolean:
    if TADPhysMySQLConnection(FConnectionObj).FServerVersion >= mvMySQL050000 then
      if PWordBool(AData)^ then
        RetStr('TRUE')
      else
        RetStr('FALSE')
    else
      if PWordBool(AData)^ then
        RetStr('1')
      else
        RetStr('0');
  dtSByte:
    ADInt2Str(AData, SizeOf(ShortInt), pBuff, iSz, 0);
  dtInt16:
    ADInt2Str(AData, SizeOf(SmallInt), pBuff, iSz, 0);
  dtInt32:
    ADInt2Str(AData, SizeOf(Integer), pBuff, iSz, 0);
  dtInt64:
    ADInt2Str(AData, SizeOf(Int64), pBuff, iSz, 0);
  dtByte:
    iSz := {$IFDEF AnyDAC_Unicode} WideFormatBuf {$ELSE} FormatBuf {$ENDIF}
      (aBuff[0], iSz, PChar(SUnsignedFmt)^, Length(SUnsignedFmt),
      [LongWord(PByte(AData)^)]);
  dtUInt16:
    iSz := {$IFDEF AnyDAC_Unicode} WideFormatBuf {$ELSE} FormatBuf {$ENDIF}
      (aBuff[0], iSz, PChar(SUnsignedFmt)^, Length(SUnsignedFmt),
      [LongWord(PWord(AData)^)]);
  dtUInt32:
    iSz := {$IFDEF AnyDAC_Unicode} WideFormatBuf {$ELSE} FormatBuf {$ENDIF}
      (aBuff[0], iSz, PChar(SUnsignedFmt)^, Length(SUnsignedFmt),
      [PLongWord(AData)^]);
  dtUInt64:
    iSz := {$IFDEF AnyDAC_Unicode} WideFormatBuf {$ELSE} FormatBuf {$ENDIF}
      (aBuff[0], iSz, PChar(SUnsignedFmt)^, Length(SUnsignedFmt),
      [PUInt64(AData)^]);
  dtCurrency:
    ADCurr2Str(pBuff, iSz, PCurrency(AData)^, '.');
  dtSingle:
    RetStr(ADFloat2Str(PSingle(AData)^, '.', 8));
  dtDouble:
    RetStr(ADFloat2Str(PDouble(AData)^, '.', 16));
  dtExtended:
    RetStr(ADFloat2Str(PExtended(AData)^, '.', 20));
  dtBCD,
  dtFmtBCD:
    ADBCD2Str(pBuff, iSz, PADBcd(AData)^, '.');
  dtDate:
    begin
      rTS := ADDate2SQLTimeStamp(PLongint(AData)^);
      iSz := {$IFDEF AnyDAC_Unicode} WideFormatBuf {$ELSE} FormatBuf {$ENDIF}
        (aBuff[0], iSz, PChar(SDateFmt)^, Length(SDateFmt),
        [rTS.Year, rTS.Month, rTS.Day]);
    end;
  dtTime:
    begin
      rTS := ADTime2SQLTimeStamp(PLongint(AData)^);
      // Delphi does not support negative time value, but MySQL does
      if PLongint(AData)^ < 0 then
        s := '-'
      else
        s := '';
      iSz := {$IFDEF AnyDAC_Unicode} WideFormatBuf {$ELSE} FormatBuf {$ENDIF}
        (aBuff[0], iSz, PChar(STimeFmt)^, Length(STimeFmt),
        [s, rTS.Hour, rTS.Minute, rTS.Second, rTS.Fractions]);
    end;
  dtDateTime:
    begin
      dt := ADMSecs2DateTime(PADDateTimeData(AData)^.DateTime);
      DecodeDate(dt, y, mo, d);
      DecodeTime(dt, h, mi, se, ms);
      iSz := {$IFDEF AnyDAC_Unicode} WideFormatBuf {$ELSE} FormatBuf {$ENDIF}
        (aBuff[0], iSz, PChar(SDateTimeFmt1)^, Length(SDateTimeFmt1),
        [y, mo, d, h, mi, se, ms]);
    end;
  dtDateTimeStamp:
    begin
      rTS := PADSQLTimeStamp(AData)^;
      if TADPhysMySQLConnection(FConnectionObj).FServerVersion >= mvMySQL040100 then
        sFmt := SDateTimeFmt1
      else
        sFmt := SDateTimeFmt2;
      iSz := {$IFDEF AnyDAC_Unicode} WideFormatBuf {$ELSE} FormatBuf {$ENDIF}
        (aBuff[0], iSz, PChar(sFmt)^, Length(sFmt),
        [rTS.Year, rTS.Month, rTS.Day, rTS.Hour, rTS.Minute, rTS.Second, rTS.Fractions]);
    end;
  dtByteString,
  dtBlob:
    if (ALen = 0) and FOptions.FormatOptions.StrsEmpty2Null then
      RetStr('NULL')
    else begin
      SetLength(Result, (ALen * 2 + 4) * SizeOf(TADAnsiChar));
      ADBin2HexBS(AData, ALen, PADByteString(Result) + 2 * SizeOf(TADAnsiChar));
      PADAnsiString(Result)^ := TADAnsiChar('x');
      (PADAnsiString(Result) + 1)^ := TADAnsiChar('''');
      (PADAnsiString(Result) + ALen * 2 + 2)^ := TADAnsiChar('''');
      (PADAnsiString(Result) + ALen * 2 + 3)^ := TADAnsiChar(#0);
    end;
  dtAnsiString,
  dtMemo:
    if (ALen = 0) and FOptions.FormatOptions.StrsEmpty2Null then
      RetStr('NULL')
    else if TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Encoding = ecUTF8 then
      Result := EncodeUTF8(AData, ALen, ecANSI)
    else begin
      SetLength(Result, (ALen * 2 + 4) * SizeOf(TADAnsiChar));
      iSz := TADPhysMySQLConnection(FConnectionObj).FSession.EscapeString(
        PADAnsiString(PADByteString(Result)) + 1 * SizeOf(TADAnsiChar),
        PADAnsiString(AData), ALen);
      PADAnsiString(Result)^ := TADAnsiChar('''');
      (PADAnsiString(Result) + iSz + 1)^ := TADAnsiChar('''');
      (PADAnsiString(Result) + iSz + 2)^ := TADAnsiChar(#0);
      SetLength(Result, iSz + 3);
    end;
  dtWideString,
  dtWideMemo,
  dtXML:
    if (ALen = 0) and FOptions.FormatOptions.StrsEmpty2Null then
      RetStr('NULL')
    else
      Result := EncodeUTF8(AData, ALen, ecUTF16);
  else
    ATypeSupported := False;
  end;
  if Length(Result) = 0 then
    Result := TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Encode(pBuff, iSz);
end;
{$WARNINGS ON}

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.MySQL2DataValue(ASrcData: PADByteString; ASrcLen: LongWord;
  var ADestData: Pointer; var ADestLen: LongWord; AType: TADDataType;
  AAttributes: TADDataAttributes; out ATypeSupported: Boolean): Boolean;
var
  E: Extended;
  wYear, wMonth, wDay, wHour, wMin, wSec, wMSec: Word;
  lwFrac: LongWord;
  iBase: Integer;
  lNeg: Boolean;
  iSz: Integer;
  aBuff: array [0..65] of Char;
  pBuff: PChar;
begin
  Result := True;
  ADestLen := 0;
  ATypeSupported := True;
  if not (AType in [dtAnsiString, dtMemo, dtWideString, dtWideMemo, dtByteString, dtBlob]) then begin
    pBuff := aBuff;
    iSz := TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Decode(
      ASrcData, ASrcLen, Pointer(pBuff));
  end
  else begin
    iSz := 0;
    pBuff := nil;
  end;
  case AType of
  dtBoolean:
    PWordBool(ADestData)^ := (pBuff^ <> '0') and (pBuff^ <> #0);
  dtSByte:
    ADStr2Int(pBuff, iSz, ADestData, SizeOf(ShortInt), False);
  dtInt16:
    ADStr2Int(pBuff, iSz, ADestData, SizeOf(SmallInt), False);
  dtInt32:
    ADStr2Int(pBuff, iSz, ADestData, SizeOf(Integer), False);
  dtInt64:
    ADStr2Int(pBuff, iSz, ADestData, SizeOf(Int64), False);
  dtByte:
    ADStr2Int(pBuff, iSz, ADestData, SizeOf(Byte), True);
  dtUInt16:
    ADStr2Int(pBuff, iSz, ADestData, SizeOf(Word), True);
  dtUInt32:
    ADStr2Int(pBuff, iSz, ADestData, SizeOf(LongWord), True);
  dtUInt64:
    ADStr2Int(pBuff, iSz, ADestData, SizeOf(UInt64), True);
  dtSingle,
  dtDouble,
  dtExtended:
    begin
      ADStr2Float(pBuff, iSz, E, '.');
      case AType of
      dtSingle:   PSingle(ADestData)^ := E;
      dtDouble:   PDouble(ADestData)^ := E;
      dtExtended: PExtended(ADestData)^ := E;
      end;
    end;
  dtCurrency:
    ADStr2Curr(pBuff, iSz, PCurrency(ADestData)^, '.');
  dtBCD,
  dtFmtBCD:
    ADStr2BCD(pBuff, iSz, PADBcd(ADestData)^, '.');
  dtDate:
    begin
      ADStr2Int(pBuff,     4, @wYear, SizeOf(Word), True);
      ADStr2Int(pBuff + 5, 2, @wMonth, SizeOf(Word), True);
      ADStr2Int(pBuff + 8, 2, @wDay, SizeOf(Word), True);
      if (wYear = 0) and (wMonth = 0) and (wDay = 0) then begin
        PLongint(ADestData)^ := 0;
        Result := False;
      end
      else
        PLongint(ADestData)^ := ADDateTime2Date(EncodeDate(wYear, wMonth, wDay));
    end;
  dtTime:
    begin
      if pBuff^ = '-' then begin
        lNeg := True;
        Inc(pBuff);
      end
      else
        lNeg := False;
      ADStr2Int(pBuff,     2, @wHour, SizeOf(Word), True);
      ADStr2Int(pBuff + 3, 2, @wMin, SizeOf(Word), True);
      ADStr2Int(pBuff + 6, 2, @wSec, SizeOf(Word), True);
      if pBuff[8] = '.' then begin
        ADStr2Int(pBuff + 9, 6, @lwFrac, SizeOf(LongWord), True);
        wMSec := lwFrac div 1000;
      end
      else
        wMSec := 0;
      PLongint(ADestData)^ := ADDateTime2Time(EncodeTime(wHour, wMin, wSec, wMSec));
      // Delphi does not support negative time value, and
      // TimeToStr for -0.123 returns the same value as for 0.123
      if lNeg then
        PLongint(ADestData)^ := - PLongint(ADestData)^;
    end;
  dtDateTime:
    begin
      ADStr2Int(pBuff,     4, @wYear, SizeOf(Word), True);
      ADStr2Int(pBuff + 5, 2, @wMonth, SizeOf(Word), True);
      ADStr2Int(pBuff + 8, 2, @wDay, SizeOf(Word), True);
      if (wYear = 0) and (wMonth = 0) and (wDay = 0) then begin
        PADDateTimeData(ADestData)^.DateTime := 0;
        Result := False;
      end
      else begin
        if pBuff[10] = #0 then begin
          wHour := 0;
          wMin := 0;
          wSec := 0;
          wMSec := 0;
        end
        else begin
          ADStr2Int(pBuff + 11, 2, @wHour, SizeOf(Word), True);
          ADStr2Int(pBuff + 14, 2, @wMin, SizeOf(Word), True);
          ADStr2Int(pBuff + 17, 2, @wSec, SizeOf(Word), True);
          if pBuff[19] = '.' then begin
            ADStr2Int(pBuff + 20, 6, @lwFrac, SizeOf(LongWord), True);
            wMSec := lwFrac div 1000;
          end
          else
            wMSec := 0;
        end;
        PADDateTimeData(ADestData)^.DateTime := ADDateTime2MSecs(
          ADEncodeDateTime(wYear, wMonth, wDay, wHour, wMin, wSec, wMSec));
      end;
    end;
  dtDateTimeStamp:
    begin
      if iSz >= 19 then begin
        ADStr2Int(pBuff,     4, @wYear, SizeOf(Word), True);
        ADStr2Int(pBuff + 5, 2, @wMonth, SizeOf(Word), True);
        ADStr2Int(pBuff + 8, 2, @wDay, SizeOf(Word), True);
        ADStr2Int(pBuff + 11,2, @wHour, SizeOf(Word), True);
        ADStr2Int(pBuff + 14,2, @wMin, SizeOf(Word), True);
        ADStr2Int(pBuff + 17,2, @wSec, SizeOf(Word), True);
        if pBuff[19] = '.' then begin
          ADStr2Int(pBuff + 20, 6, @lwFrac, SizeOf(LongWord), True);
          wMSec := lwFrac div 1000;
        end
        else
          wMSec := 0;
      end
      else begin
        wYear := 0;
        wMonth := 0;
        wDay := 0;
        wHour := 0;
        wMin := 0;
        wSec := 0;
        wMSec := 0;
        if (iSz = 14) or (iSz = 8) then begin
          ADStr2Int(pBuff, 4, @wYear, SizeOf(Word), True);
          iBase := 4;
        end
        else begin
          ADStr2Int(pBuff, 2, @wYear, SizeOf(Word), True);
          iBase := 2;
        end;
        if iSz > 2 then begin
          ADStr2Int(pBuff + iBase, 2, @wMonth, SizeOf(Word), True);
          if iSz > 4 then begin
            ADStr2Int(pBuff + iBase + 2, 2, @wDay, SizeOf(Word), True);
            if iSz >= 10 then begin
              ADStr2Int(pBuff + iBase + 4, 2, @wHour, SizeOf(Word), True);
              ADStr2Int(pBuff + iBase + 6, 2, @wMin, SizeOf(Word), True);
              if iSz > 10 then
                ADStr2Int(pBuff + iBase + 8, 2, @wSec, SizeOf(Word), True);
            end;
          end;
        end;
      end;
      if (wYear = 0) and (wMonth = 0) and (wDay = 0) then begin
        ADFillChar(PADSQLTimeStamp(ADestData)^, SizeOf(TADSQLTimeStamp), 0);
        Result := False;
      end
      else begin
        PADSQLTimeStamp(ADestData)^.Year := wYear;
        PADSQLTimeStamp(ADestData)^.Month := wMonth;
        PADSQLTimeStamp(ADestData)^.Day := wDay;
        PADSQLTimeStamp(ADestData)^.Hour := wHour;
        PADSQLTimeStamp(ADestData)^.Minute := wMin;
        PADSQLTimeStamp(ADestData)^.Second := wSec;
        PADSQLTimeStamp(ADestData)^.Fractions := wMSec;
      end;
    end;
  dtAnsiString,
  dtMemo:
    begin
      ADestData := ASrcData;
      ADestLen := ASrcLen;
      if (caFixedLen in AAttributes) and GetOptions.FormatOptions.StrsTrim then
        while (ADestLen > 0) and (PADAnsiString(ADestData)[ADestLen - 1] = TADAnsiChar(' ')) do
          Dec(ADestLen);
      if (ADestLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
        Result := False;
    end;
  dtWideString,
  dtWideMemo:
    begin
      ADestLen := TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Decode(
        ASrcData, ASrcLen, ADestData, ecUTF16);
      if (caFixedLen in AAttributes) and GetOptions.FormatOptions.StrsTrim then
        while (ADestLen > 0) and (PWideChar(ADestData)[ADestLen - 1] = ' ') do
          Dec(ADestLen);
      if (ADestLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
        Result := False;
    end;
  dtByteString,
  dtBlob:
    begin
      ADestData := ASrcData;
      ADestLen := ASrcLen;
      if (ADestLen = 0) and GetOptions.FormatOptions.StrsEmpty2Null then
        Result := False;
    end;
  else
    Result := False;
    ATypeSupported := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.GetExpandedSQL(ATimes, AOffset: Integer): TADByteString;
var
  pSrcCh, pDestCh, pDestEnd: PADByteString;
  i, iOrigLen, iFullLen, iPar, iRow: Integer;
  sSQL, sValues: String;
  sSubst, sEncSQL, sNULL, sQMark: TADByteString;
  oParam: TADParam;
  iSize, iSrcDataLen, iDestDataLen: LongWord;
  iPrec, iScale: Integer;
  iFieldType: TFieldType;
  iSrcDataType, iDestDataType: TADDataType;
  oFmtOpts: TADFormatOptions;
  lTypeSupported: Boolean;
  oParams: TADParams;

  procedure ErrorParamType(const AReason: String);
  begin
    ADException(Self, [S_AD_LPhys, S_AD_MySQLId], er_AD_MySQLBadParams,
      [oParam.Name, AReason]);
  end;

  procedure ExtendDest(AMinLen: Integer);
  var
    iPos: Integer;
  begin
    if AMinLen < 1024 then
      AMinLen := 1024;
    if pDestCh = nil then
      iPos := 0
    else
      iPos := pDestCh - PADByteString(Result);
    SetLength(Result, ADByteStrLength(Result) + AMinLen);
    pDestCh := PADByteString(Result) + iPos;
    pDestEnd := PADByteString(Result) + ADByteStrLength(Result);
  end;

  procedure WriteDest(const AStr: TADByteString);
  var
    iLen: Integer;
  begin
    iLen := ADByteStrLength(AStr);
    if pDestCh + iLen >= pDestEnd then
      ExtendDest(iLen);
    Move(PADByteString(AStr)^, pDestCh^, iLen * SizeOf(TADAnsiChar));
    Inc(pDestCh, iLen);
  end;

begin
  sSQL := FDbCommandText;
  if (GetCommandKind in [skInsert, skMerge]) and (FSQLValuesPos > 0) and (ATimes - AOffset > 1) then begin
    if FSQLValuesPosEnd = 0 then
      FSQLValuesPosEnd := Length(sSQL);
    sValues := ',' + Copy(sSQL, FSQLValuesPos + 6, FSQLValuesPosEnd - (FSQLValuesPos + 6) + 1);
    iOrigLen := Length(sSQL);
    iFullLen := iOrigLen + (ATimes - 2 - AOffset + 1) * Length(sValues);
    SetLength(sSQL, iFullLen);
    if FSQLValuesPosEnd < Length(FDbCommandText) then
      Move(sSQL[FSQLValuesPosEnd + 1], sSQL[iFullLen - (iOrigLen - FSQLValuesPosEnd) + 1],
        (iOrigLen - FSQLValuesPosEnd) * SizeOf(Char));
    for i := AOffset to ATimes - 2 do
      Move(sValues[1], sSQL[FSQLValuesPosEnd + 1 + (i - AOffset) * Length(sValues)],
        Length(sValues) * SizeOf(Char));
  end;
  sEncSQL := TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Encode(sSQL);
  oParams := GetParams();
  if oParams.Count = 0 then
    Result := sEncSQL
  else begin
    oFmtOpts := GetOptions.FormatOptions;
    pSrcCh := PADByteString(sEncSQL);
    pDestCh := nil;
    ExtendDest(0);
    iPar := 0;
    iRow := AOffset;
    SetLength(sNULL, 0);
    SetLength(sQMark, 0);
    while True do begin
      { TODO -cMySQL : If command text will contain char constant with '?' in it, then that will fail }
      while (PADAnsiString(pSrcCh)^ <> TADAnsiChar(#0)) and
            (PADAnsiString(pSrcCh)^ <> TADAnsiChar('?')) do begin
        if pDestCh = pDestEnd then
          ExtendDest(0);
        pDestCh^ := pSrcCh^;
        Inc(pDestCh);
        Inc(pSrcCh);
      end;
      if PADAnsiString(pSrcCh)^ = TADAnsiChar(#0) then
        Break
      else if PADAnsiString(pSrcCh)^ = TADAnsiChar('?') then begin
        oParam := nil;
        while True do begin
          case GetParams.BindMode of
          pbByName:   oParam := oParams.FindParam(oParams.Markers[iPar]);
          pbByNumber: oParam := oParams.FindParam(iPar + 1);
          end;
          if (oParam = nil) or (oParam.ParamType in [ptUnknown, ptInput, ptInputOutput]) then
            Break;
          if iPar = oParams.Markers.Count - 1 then begin
            oParam := nil;
            Break;
          end;
          Inc(iPar);
        end;
        if oParam <> nil then begin
          // check parameter definition
          if oParam.ParamType in [ptOutput, ptResult] then
            ErrorParamType('Output parameters are not supported');
          if oParam.DataType = ftUnknown then
            ParTypeUnknownError(oParam);
          iFieldType := ftUnknown;
          iSize := 0;
          iPrec := 0;
          iSrcDataType := dtUnknown;
          iDestDataType := dtUnknown;
          iDestDataLen := 0;
          oFmtOpts.ResolveFieldType('', oParam.DataType, oParam.ADDataType, oParam.Size,
            oParam.Precision, oParam.NumericScale, iFieldType, iSize, iPrec, iScale,
            iSrcDataType, iDestDataType, False);
          iSrcDataLen := oParam.GetDataLength(iRow);
          if oParam.IsNulls[iRow] then begin
            if Length(sNULL) = 0 then
              sNULL := TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Encode('NULL');
            sSubst := sNULL;
          end
          else begin
            // approximating destination data size and allocate buffer
            FBuffer.Extend(iSrcDataLen, iDestDataLen, iSrcDataType, iDestDataType);
            // fill buffer with value, converting it, if required
            oParam.GetData(FBuffer.Ptr, iRow);
            oFmtOpts.ConvertRawData(iSrcDataType, iDestDataType, FBuffer.Ptr,
              iSrcDataLen, FBuffer.FBuffer, FBuffer.Size, iDestDataLen,
              TADPhysMySQLConnection(FConnectionObj).FSession.Encoder);
            sSubst := DataValue2MySQL(FBuffer.Ptr, iDestDataLen, iDestDataType,
              lTypeSupported);
            if not lTypeSupported then
              ParTypeMapError(oParam);
          end;
          WriteDest(sSubst);
          Inc(iPar);
          if iPar >= oParams.Markers.Count then begin
            iPar := 0;
            Inc(iRow);
          end;
        end
        else begin
          if Length(sQMark) = 0 then
            sQMark := TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Encode('?');
          WriteDest(sQMark);
        end;
      end;
      Inc(pSrcCh);
    end;
    iFullLen := pDestCh - PADByteString(Result);
    SetLength(Result, iFullLen + 1);
    (PADAnsiString(Result) + iFullLen)^ := TADAnsiChar(#0);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.GetResultMode: TADPhysMySQLResultMode;
var
  oCon: TADPhysMySQLConnection;
begin
  oCon := TADPhysMySQLConnection(FConnectionObj);
  case oCon.FResultMode of
  hrStore:
    Result := hrStore;
  hrUse:
    Result := hrUse;
  hrChoose:
    if FOptions.FetchOptions.Mode in [fmAll, fmExactRecsMax] then
      Result := hrStore
    else
      Result := hrUse;
  else
    Result := hrStore;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.GetCursor;
var
  oCon: TADPhysMySQLConnection;
begin
  oCon := TADPhysMySQLConnection(FConnectionObj);
  repeat
    ADFreeAndNil(FCursor);
    if GetResultMode = hrStore then
      FCursor := oCon.FSession.StoreResult
    else
      FCursor := oCon.FSession.UseResult;
  until (FCursor <> nil) or
        not oCon.FSession.MoreResults or
        not oCon.FSession.NextResult;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.InternalExecute(ATimes, AOffset: Integer;
  var ACount: TADCounter);
var
  sSQL: TADByteString;
  oCon: TADPhysMySQLConnection;
  i: Integer;
  iCount: TADCounter;
  iRows: Int64;
begin
  ACount := 0;
  // For a while driver can create batch only for INSERT INTO statement.
  // Probably, may be used similar to FB EXECUTE BLOCK technique.
  if (GetCommandKind in [skInsert, skMerge]) and (FSQLValuesPos > 0) and (ATimes - AOffset > 1) then
    sSQL := GetExpandedSQL(ATimes, AOffset)
  // otherwise just emulate batch
  else if ATimes - AOffset > 1 then begin
    for i := AOffset to ATimes - 1 do begin
      iCount := 0;
      try
        InternalExecute(i + 1, i, iCount);
      finally
        Inc(ACount, iCount);
      end;
      CheckExact(False, 1, 0, iCount, False);
    end;
    Exit;
  end
  else
    sSQL := GetExpandedSQL(ATimes, AOffset);
  oCon := TADPhysMySQLConnection(FConnectionObj);
  oCon.FLock.Enter;
  try
    try
      try
        oCon.UpdateServerOutput;
        oCon.FSession.QuerySB(sSQL, Self);
      except
        on E: EMySQLNativeException do begin
          if ATimes - AOffset = 1 then
            E.Errors[0].RowIndex := AOffset;
          raise;
        end;
      end;
    finally
      if FCursor = nil then begin
        iRows := oCon.FSession.AffectedRows;
        if iRows > 0 then
          Inc(ACount, iRows);
      end;
    end;
    CloseStatement(True, AOffset);
  finally
    oCon.FLock.Leave;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.InternalAbort;
var
  oCon: TADPhysMySQLConnection;
begin
  oCon := TADPhysMySQLConnection(FConnectionObj);
  if oCon.FServerVersion >= mvMySQL050000 then
    oCon.FSession.KillQuery
  else
    inherited InternalAbort;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.InternalOpen: Boolean;
var
  sSQL: TADByteString;
  iSQL: Integer;
  oCon: TADPhysMySQLConnection;
begin
  if FCursor = nil then begin
    oCon := TADPhysMySQLConnection(FConnectionObj);
    iSQL := 0;
    if not (GetMetaInfoKind in [mkNone, mkForeignKeys, mkForeignKeyFields]) then
      if Length(FMetaInfoSQLs) = 0 then
        SetLength(sSQL, 0)
      else
        sSQL := oCon.FSession.Encoder.Encode(FMetaInfoSQLs[0])
    else
      sSQL := GetExpandedSQL(1, 0);
    while Length(sSQL) <> 0 do begin
      oCon.FLock.Enter;
      try
        try
          oCon.UpdateServerOutput;
          oCon.FSession.QuerySB(sSQL, Self);
          SetLength(sSQL, 0);
          GetCursor;
          if GetMetaInfoKind = mkNone then
            GetParamValues(-1);
        except
          on E: EMySQLNativeException do
            if GetMetaInfoKind <> mkNone then begin
              Inc(iSQL);
              if iSQL = Length(FMetaInfoSQLs) then
                if E.Kind = ekObjNotExists then
                  SetLength(sSQL, 0)
                else
                  raise
              else
                sSQL := oCon.FSession.Encoder.Encode(FMetaInfoSQLs[iSQL]);
            end
            else
              raise;
        end;
      finally
        oCon.FLock.Leave;
      end;
    end;
  end;
  Result := (FCursor <> nil);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.InternalNextRecordSet: Boolean;
var
  oCon: TADPhysMySQLConnection;
begin
  oCon := TADPhysMySQLConnection(FConnectionObj);
  oCon.FLock.Enter;
  try
    InternalClose;
    Result := oCon.FSession.MoreResults;
    if Result then begin
      Result := oCon.FSession.NextResult;
      if Result then begin
        GetCursor;
        if GetMetaInfoKind = mkNone then
          GetParamValues(-1);
      end;
    end;
  finally
    oCon.FLock.Leave;
  end;
  Result := (FCursor <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.GetParamValues(AIndex: Integer);
var
  oTab: TADDatSTable;
  i, j: Integer;
  s: String;
  v: Variant;
  oParams: TADParams;
  oPar: TADParam;
  ePrevState: TADPhysCommandState;
  rState: TADDatSLoadState;
begin
  if (FCursor <> nil) and not TADPhysMySQLConnection(FConnectionObj).FSession.MoreResults and
     (GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs]) then begin
    if AIndex < 0 then
      AIndex := 0;
    oParams := GetParams();
    oTab := TADDatSTable.Create;
    oTab.Setup(FOptions);
    ePrevState := GetState;
    SetState(csOpen);
    try
      Define(oTab);
      oTab.BeginLoadData(rState, lmHavyFetching);
      try
        FCursor.Fetch(1);
        FetchRow(oTab, nil);
        for i := 0 to oTab.Columns.Count - 1 do begin
          oPar := oParams.FindParam(oTab.Columns[i].Name);
          if (oPar <> nil) and (oPar.ParamType in [ptOutput, ptInputOutput, ptResult]) then begin
            v := oTab.Rows[0].GetData(i);
            case oPar.DataType of
            {$IFDEF AnyDAC_D14} ftSingle, {$ENDIF}
            ftFloat,
            {$IFDEF AnyDAC_D12} ftExtended, {$ENDIF}
            ftCurrency,
            ftBCD
            {$IFDEF AnyDAC_D6}, ftFMTBcd {$ENDIF}:
              if {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator <> '.' then begin
{$IFDEF AnyDAC_FPC}
                // FPC fails to perform automatic VarBCD to String cast
                if VarIsFmtBCD(v) then
                  s := BCDToStr(VarToBCD(v))
                else
{$ENDIF}
                  s := v;
                j := Pos('.', s);
                if j <> 0 then
                  s[j] := {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator;
                oPar.Values[AIndex] := s;
              end
              else
                oPar.Values[AIndex] := v;
            ftBoolean:
              begin
                s := Trim(UpperCase(v));
                oPar.Values[AIndex] := (s = '1') or (s = 'TRUE');
              end;
            else
              oPar.Values[AIndex] := v;
            end;
          end;
        end;
        GetCursor;
      finally
        oTab.EndLoadData(rState);
      end;
    finally
      SetState(ePrevState);
      ADFree(oTab);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.InternalClose;
begin
  CloseStatement(False, -1);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.CloseStatement(AForceClose: Boolean; AIndex: Integer);
var
  oCon: TADPhysMySQLConnection;
begin
  if AForceClose or not GetNextRecordSet then begin
    oCon := TADPhysMySQLConnection(FConnectionObj);
    while oCon.FSession.MoreResults and oCon.FSession.NextResult do begin
      GetCursor;
      if GetMetaInfoKind = mkNone then
        GetParamValues(AIndex);
    end;
  end;
  ADFreeAndNil(FCursor);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
var
  oRow: TADDatSRow;
  oCol: TADDatSColumn;
  j: Integer;
  iSrcLen, iDestLen: LongWord;
  pSrcData: PADByteString;
  pDestData: Pointer;
  lHasValue, lTypeSupported: Boolean;
begin
  oRow := ATable.NewRow(False);
  try
    for j := 0 to ATable.Columns.Count - 1 do begin
      oCol := ATable.Columns[j];
      if (oCol.SourceID > 0) and CheckFetchColumn(oCol.SourceDataType, oCol.Attributes) then begin
        lTypeSupported := True;
        // if need conversion
        if oCol.SourceDataType <> oCol.DataType then begin
          pSrcData := nil;
          iSrcLen := 0;
          lHasValue := FCursor.GetData(ocol.SourceID - 1, Pointer(pSrcData), iSrcLen);
          if lHasValue then begin
            pDestData := FBuffer.Check((iSrcLen + 1) * SizeOf(WideChar));
            iDestLen := 0;
            lHasValue := MySQL2DataValue(pSrcData, iSrcLen, pDestData, iDestLen,
              oCol.SourceDataType, oCol.Attributes, lTypeSupported);
          end;
          if lHasValue then
            FOptions.FormatOptions.ConvertRawData(oCol.SourceDataType, oCol.DataType,
              pDestData, iDestLen, pDestData, FBuffer.Size, iDestLen,
              TADPhysMySQLConnection(FConnectionObj).FSession.Encoder);
        end
        // if dont need conversion
        else begin
          lHasValue := FCursor.GetData(oCol.SourceID - 1, Pointer(pSrcData), iSrcLen);
          if lHasValue then begin
            pDestData := FBuffer.Check((iSrcLen + 1) * SizeOf(WideChar));
            lHasValue := MySQL2DataValue(pSrcData, iSrcLen, pDestData, iDestLen,
              oCol.SourceDataType, oCol.Attributes, lTypeSupported);
          end;
        end;
        if not lTypeSupported then
          ColTypeMapError(oCol);
        // set data
        if lHasValue then
          oRow.SetData(j, pDestData, iDestLen)
        else
          oRow.SetData(j, nil, 0);
      end;
    end;
    ATable.Rows.Add(oRow);
  except
    ADFree(oRow);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.MySQLType2ADType(var AStr: String; var AType: TADDataType;
  var AAttrs: TADDataAttributes; var ALen: LongWord; var APrec, AScale: Integer);
var
  i1, i2: Integer;
  iLen: LongWord;
  sType, sArgs, sMod: String;
  lUnsigned: Boolean;
  oFmt: TADFormatOptions;

  procedure SetPrecScale(ADefPrec, ADefScale: Integer);
  var
    sPrec, sScale: String;
    i: Integer;
  begin
    i := Pos(',', sArgs);
    if i = 0 then
      sPrec := sArgs
    else begin
      sPrec := Copy(sArgs, 1, i - 1);
      sScale := Copy(sArgs, i + 1, Length(sArgs));
    end;
    APrec := StrToIntDef(sPrec, ADefPrec);
    AScale := StrToIntDef(sScale, ADefScale);
  end;

  procedure SetLen(ADefLen: Integer);
  begin
    ALen := StrToIntDef(sArgs, ADefLen);
  end;

begin
  i1 := Pos('(', AStr);
  i2 := Pos(')', AStr);
  if i1 = 0 then begin
    i1 := Pos(' ', AStr);
    if i1 = 0 then begin
      sType := UpperCase(AStr);
      sArgs := '';
      sMod := '';
    end
    else begin
      sType := UpperCase(Copy(AStr, 1, i1 - 1));
      sArgs := '';
      sMod := UpperCase(Copy(AStr, i1 + 1, Length(AStr)));
    end;
  end
  else begin
    sType := UpperCase(Copy(AStr, 1, i1 - 1));
    sArgs := Copy(AStr, i1 + 1, i2 - i1 - 1);
    sMod := UpperCase(Copy(AStr, i2 + 1, Length(AStr)));
  end;
  lUnsigned := Pos(' UNSIGNED', sMod) <> 0;
  AType := dtUnknown;
  AAttrs := [caSearchable];
  ALen := 0;
  APrec := 0;
  AScale := 0;
  if sType = 'ENUM' then begin
    AType := dtAnsiString;
    AAttrs := [caSearchable];
    i1 := 1;
    repeat
      i2 := ADPosEx(',', sArgs, i1);
      if i2 = 0 then
        i2 := Length(sArgs) + 1;
      iLen := i2 - i1;
      if sArgs[i1] = '''' then
        Dec(iLen, 2);
      if ALen < iLen then
        ALen := iLen;
      i1 := i2 + 1;
    until i2 > Length(sArgs);
  end
  else if sType = 'SET' then begin
    AType := dtAnsiString;
    AAttrs := [caSearchable];
    i1 := 1;
    repeat
      i2 := ADPosEx(',', sArgs, i1);
      if i2 = 0 then
        i2 := Length(sArgs) + 1;
      iLen := i2 - i1;
      if sArgs[i1] = '''' then
        Dec(iLen, 2);
      Inc(ALen, Longword(iLen + 1));
      i1 := i2 + 1;
    until i2 > Length(sArgs);
  end
  else if sType = 'TINYINT' then begin
    SetPrecScale(0, 0);
    if (APrec = 1) and (TADPhysMySQLConnection(FConnectionObj).FTinyIntFormat = dtBoolean) then
      AType := dtBoolean
    else if lUnsigned then
      AType := dtByte
    else
      AType := dtSByte;
  end
  else if sType = 'BIT' then begin
    AType := dtByteString;
    SetLen(1);
    ALen := (ALen + 7) div 8;
    Include(AAttrs, caFixedLen);
  end
  else if sType = 'BOOL' then
    AType := dtBoolean
  else if sType = 'SMALLINT' then begin
    SetPrecScale(0, 0);
    if lUnsigned then
      AType := dtUInt16
    else
      AType := dtInt16;
  end
  else if (sType = 'MEDIUMINT') or (sType = 'INTEGER') or (sType = 'INT') then begin
    SetPrecScale(0, 0);
    if lUnsigned then
      AType := dtUInt32
    else
      AType := dtInt32;
  end
  else if sType = 'BIGINT' then begin
    SetPrecScale(0, 0);
    if lUnsigned then
      AType := dtUInt64
    else
      AType := dtInt64
  end
  else if (sType = 'FLOAT') or (sType = 'DOUBLE') or (sType = 'REAL') then begin
    SetPrecScale(0, 0);
    if APrec > 16 then begin
      oFmt := FOptions.FormatOptions;
      if (APrec <= oFmt.MaxBcdPrecision) and (AScale <= oFmt.MaxBcdScale) then
        AType := dtBCD
      else
        AType := dtFmtBCD;
    end
    else if sType = 'FLOAT' then
      AType := dtSingle
    else
      AType := dtDouble;
  end
  else if (sType = 'DECIMAL') or (sType = 'DEC') or (sType = 'NUMERIC') then begin
    SetPrecScale(10, 0);
    if AScale = 0 then
      if lUnsigned then begin
        if APrec <= 3 then
          AType := dtByte
        else if APrec <= 5 then
          AType := dtUInt16
        else if APrec <= 10 then
          AType := dtUInt32
        else if APrec <= 21 then
          AType := dtUInt64;
      end
      else begin
        if APrec <= 2 then
          AType := dtSByte
        else if APrec <= 4 then
          AType := dtInt16
        else if APrec <= 9 then
          AType := dtInt32
        else if APrec <= 20 then
          AType := dtInt64;
      end;
    if AType = dtUnknown then begin
      oFmt := FOptions.FormatOptions;
      if (APrec <= oFmt.MaxBcdPrecision) and (AScale <= oFmt.MaxBcdScale) then
        AType := dtBCD
      else
        AType := dtFmtBCD;
    end;
  end
  else if sType = 'DATE' then
    AType := dtDate
  else if sType = 'DATETIME' then
    AType := dtDateTime
  else if sType = 'TIMESTAMP' then begin
    AType := dtDateTimeStamp;
    Include(AAttrs, caRowVersion);
  end
  else if sType = 'TIME' then
    AType := dtTime
  else if sType = 'YEAR' then
    AType := dtUInt16
  else if sType = 'CHAR' then begin
    SetLen(1);
    AType := dtAnsiString;
    Include(AAttrs, caFixedLen);
  end
  else if sType = 'VARCHAR' then begin
    SetLen(255);
    AType := dtAnsiString;
  end
  else if sType = 'BINARY' then begin
    SetLen(1);
    AType := dtByteString;
    Include(AAttrs, caFixedLen);
  end
  else if sType = 'VARBINARY' then begin
    SetLen(255);
    AType := dtByteString;
  end
  else if sType = 'TINYBLOB' then begin
    AType := dtByteString;
    ALen := 255;
  end
  else if sType = 'TINYTEXT' then begin
    AType := dtAnsiString;
    ALen := 255;
  end
  else if (sType = 'BLOB') or (sType = 'MEDIUMBLOB') or (sType = 'LONGBLOB') then begin
    Exclude(AAttrs, caSearchable);
    Include(AAttrs, caBlobData);
    AType := dtBlob;
  end
  else if (sType = 'TEXT') or (sType = 'MEDIUMTEXT') or (sType = 'LONGTEXT') then begin
    Exclude(AAttrs, caSearchable);
    Include(AAttrs, caBlobData);
    AType := dtMemo;
  end;
  AStr := sType;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.GetCrsData(ACrsCol: Integer; var AData: Pointer;
  var ALen: LongWord; AType: TADDataType): Boolean;
var
  pSrcData: Pointer;
  iSrcLen: LongWord;
  lTypeSupported: Boolean;
begin
  pSrcData := nil;
  iSrcLen := 0;
  Result := FCursor.GetData(ACrsCol, pSrcData, iSrcLen) and
    MySQL2DataValue(pSrcData, iSrcLen, AData, ALen, AType, [], lTypeSupported) and
    lTypeSupported;
  if not Result then
    ALen := 0;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.GetCrsData(ACrsCol: Integer; AData: Pointer): String;
var
  iLen: LongWord;
begin
  GetCrsData(ACrsCol, AData, iLen, dtAnsiString);
  Result := TADPhysMySQLConnection(FConnectionObj).FSession.Encoder.Decode(AData, iLen);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysMySQLCommand.FetchMetaRow(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowIndex: Integer);
const
  C_Primary: TADWideString = 'PRIMARY';
var
  pData: Pointer;
  uiLen: LongWord;
  oRow: TADDatSRow;
  lDeleteRow: Boolean;
  s: String;
  eType: TADDataType;
  eAttrs: TADDataAttributes;
  iPrec, iScale: Integer;
  iRecNo: Integer;
  eIndKind: TADPhysIndexKind;
  i: Integer;
  rName: TADPhysParsedName;
  oConnMeta: IADPhysConnectionMetadata;
begin
  lDeleteRow := False;
  iRecNo := FRecordsFetched + ARowIndex + 1;
  oRow := ATable.NewRow(False);
  pData := FBuffer.Check(1024);
  case GetMetaInfoKind of
  mkCatalogs:
    begin
      oRow.SetData(0, iRecNo);
      uiLen := 0;
      GetCrsData(0, pData, uiLen, dtWideString);
      oRow.SetData(1, pData, uiLen);
    end;
  mkTables:
    begin
      oRow.SetData(0, iRecNo);
      oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).InternalGetCurrentCatalog);
      oRow.SetData(2, nil, 0);
      uiLen := 0;
      GetCrsData(0, pData, uiLen, dtWideString);
      oRow.SetData(3, pData, uiLen);
      oRow.SetData(4, SmallInt(tkTable));
      oRow.SetData(5, SmallInt(osMy));
      lDeleteRow := not (tkTable in GetTableKinds) or
        not (osMy in GetObjectScopes);
    end;
  mkTableFields:
    begin
      oRow.SetData(0, iRecNo);
      oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).InternalGetCurrentCatalog);
      oRow.SetData(2, nil, 0);
      FConnection.CreateMetadata(oConnMeta);
      oConnMeta.DecodeObjName(GetCommandText, rName, Self, [doUnquote, doNormalize]);
      oRow.SetData(3, rName.FObject);
      GetCrsData(0, pData, uiLen, dtWideString);
      oRow.SetData(4, pData, uiLen);
      oRow.SetData(5, iRecNo);
      s := GetCrsData(1, pData);
      eType := dtUnknown;
      eAttrs := [];
      uiLen := 0;
      iPrec := 0;
      iScale := 0;
      MySQLType2ADType(s, eType, eAttrs, uiLen, iPrec, iScale);
{$IFDEF AnyDAC_D6Base}
      oRow.SetData(6, LongWord(eType));
{$ELSE}
      oRow.SetData(6, Integer(eType));
{$ENDIF}
      oRow.SetData(7, s);
      oRow.SetData(9, iPrec);
      oRow.SetData(10, iScale);
{$IFDEF AnyDAC_D6Base}
      oRow.SetData(11, uiLen);
{$ELSE}
      oRow.SetData(11, Integer(uiLen));
{$ENDIF}
      Include(eAttrs, caBase);
      if CompareText(GetCrsData(2, pData), 'YES') = 0 then
        Include(eAttrs, caAllowNull);
      if GetCrsData(4, pData) <> '' then
        Include(eAttrs, caDefault);
      if CompareText(GetCrsData(5, pData), 'AUTO_INCREMENT') = 0 then begin
        Include(eAttrs, caAutoInc);
        Include(eAttrs, caAllowNull);
      end;
      oRow.SetData(8, PWord(@eAttrs)^);
    end;
  mkIndexes,
  mkPrimaryKey:
    begin
      oRow.SetData(0, iRecNo);
      oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).InternalGetCurrentCatalog);
      oRow.SetData(2, nil, 0);
      GetCrsData(0, pData, uiLen, dtWideString);
      oRow.SetData(3, pData, uiLen);
      GetCrsData(1, pData, uiLen, dtUInt16);
      if PWord(pData)^ = 0 then
        eIndKind := ikUnique
      else
        eIndKind := ikNonUnique;
      GetCrsData(2, pData, uiLen, dtWideString);
      if (eIndKind = ikUnique) and (ADStrLIComp(PWideChar(pData), PWideChar(C_Primary), 7) = 0) then
        eIndKind := ikPrimaryKey;
      oRow.SetData(4, pData, uiLen);
      if eIndKind = ikPrimaryKey then
        oRow.SetData(5, pData, uiLen)
      else
        oRow.SetData(5, nil, 0);
      oRow.SetData(6, Integer(eIndKind));
      if (GetMetaInfoKind = mkPrimaryKey) and (iRecNo > 1) then
        lDeleteRow := True;
      if not lDeleteRow then
        for i := 0 to ATable.Rows.Count - 1 do begin
          if (VarToStr(ATable.Rows[i].GetData(1, rvDefault)) = VarToStr(oRow.GetData(1, rvDefault))) and
             (VarToStr(ATable.Rows[i].GetData(2, rvDefault)) = VarToStr(oRow.GetData(2, rvDefault))) and
             (VarToStr(ATable.Rows[i].GetData(3, rvDefault)) = VarToStr(oRow.GetData(3, rvDefault))) and
             (VarToStr(ATable.Rows[i].GetData(4, rvDefault)) = VarToStr(oRow.GetData(4, rvDefault))) then begin
            lDeleteRow := True;
            Break;
          end;
        end;
    end;
  mkIndexFields,
  mkPrimaryKeyFields:
    begin
      oRow.SetData(0, iRecNo);
      oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).InternalGetCurrentCatalog);
      oRow.SetData(2, nil, 0);
      GetCrsData(0, pData, uiLen, dtWideString);
      oRow.SetData(3, pData, uiLen);
      GetCrsData(1, pData, uiLen, dtInt32);
      if PSmallInt(pData)^ = 0 then
        eIndKind := ikUnique
      else
        eIndKind := ikNonUnique;
      GetCrsData(2, pData, uiLen, dtWideString);
      if (eIndKind = ikUnique) and (ADStrLIComp(PWideChar(pData), PWideChar(C_Primary), 7) = 0) then
        eIndKind := ikPrimaryKey;
      oRow.SetData(4, pData, uiLen);
      GetCrsData(4, pData, uiLen, dtWideString);
      oRow.SetData(5, pData, uiLen);
      GetCrsData(3, pData, uiLen, dtInt32);
      oRow.SetData(6, pData, uiLen);
      GetCrsData(5, pData, uiLen, dtWideString);
      oRow.SetData(7, pData, uiLen);
      oRow.SetData(8, nil, 0);
      FConnection.CreateMetadata(oConnMeta);
      oConnMeta.DecodeObjName(GetCommandText, rName, Self, [doUnquote, doNormalize]);
      if not lDeleteRow then
        if (GetMetaInfoKind = mkPrimaryKeyFields) and
             ((eIndKind <> ikPrimaryKey) or
              (iRecNo > 1) and
              (AnsiCompareText(VarToStr(ATable.Rows[0].GetData(4, rvDefault)), VarToStr(oRow.GetData(4, rvDefault))) <> 0)
             ) or
           (GetMetaInfoKind = mkIndexFields) and
             (AnsiCompareText(VarToStr(oRow.GetData(4, rvDefault)), rName.FObject) <> 0) then
          lDeleteRow := True;
    end;
  mkForeignKeys:
    begin
      oRow.SetData(0, iRecNo);
      GetCrsData(1, pData, uiLen, dtWideString);
      oRow.SetData(1, pData, uiLen);
      oRow.SetData(2, nil, 0);
      GetCrsData(3, pData, uiLen, dtWideString);
      oRow.SetData(3, pData, uiLen);
      GetCrsData(4, pData, uiLen, dtWideString);
      oRow.SetData(4, pData, uiLen);
      GetCrsData(5, pData, uiLen, dtWideString);
      oRow.SetData(5, pData, uiLen);
      oRow.SetData(6, nil, 0);
      GetCrsData(7, pData, uiLen, dtWideString);
      oRow.SetData(7, pData, uiLen);
      GetCrsData(8, pData, uiLen, dtInt32);
      oRow.SetData(8, pData, uiLen);
      GetCrsData(9, pData, uiLen, dtInt32);
      oRow.SetData(9, pData, uiLen);
    end;
  mkForeignKeyFields:
    begin
      oRow.SetData(0, iRecNo);
      GetCrsData(1, pData, uiLen, dtWideString);
      oRow.SetData(1, pData, uiLen);
      oRow.SetData(2, nil, 0);
      GetCrsData(3, pData, uiLen, dtWideString);
      oRow.SetData(3, pData, uiLen);
      GetCrsData(4, pData, uiLen, dtWideString);
      oRow.SetData(4, pData, uiLen);
      GetCrsData(5, pData, uiLen, dtWideString);
      oRow.SetData(5, pData, uiLen);
      GetCrsData(6, pData, uiLen, dtWideString);
      oRow.SetData(6, pData, uiLen);
      GetCrsData(7, pData, uiLen, dtInt32);
      oRow.SetData(7, pData, uiLen);
    end;
  mkProcs:
    begin
      oRow.SetData(0, iRecNo);
      if GetCrsData(1, pData, uiLen, dtWideString) then
        oRow.SetData(1, pData, uiLen);
      if GetCrsData(2, pData, uiLen, dtWideString) then
        oRow.SetData(2, pData, uiLen);
      if GetCrsData(3, pData, uiLen, dtWideString) then
        oRow.SetData(3, pData, uiLen);
      if GetCrsData(4, pData, uiLen, dtWideString) then
        oRow.SetData(4, pData, uiLen);
      if GetCrsData(5, pData, uiLen, dtInt32) then
        oRow.SetData(5, pData, uiLen);
      if GetCrsData(6, pData, uiLen, dtInt32) then
        oRow.SetData(6, pData, uiLen);
      if GetCrsData(7, pData, uiLen, dtInt32) then
        oRow.SetData(7, pData, uiLen);
      if GetCrsData(8, pData, uiLen, dtInt32) then
        oRow.SetData(8, pData, uiLen);
      if GetCrsData(9, pData, uiLen, dtInt32) then
        oRow.SetData(9, pData, uiLen);
    end;
  mkProcArgs:
    ASSERT(False);
  else
    lDeleteRow := True;
  end;
  if lDeleteRow then
    oRow.Free
  else
    ATable.Rows.Add(oRow);
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.FetchSPParamRows(ATable: TADDatSTable;
  AParentRow: TADDatSRow): Integer;
var
  sMode, sSQL: String;
  lAnsiQuotes, {lNoBackslash,} lInQuote1, lInQuote2: Boolean;
  i, iBraces, iPrev, iRecNo: Integer;
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;

  procedure AddParam(const ASQL: String; AFrom, ATo: Integer);
  var
    iPrev: Integer;
    sType, sName: String;
    eDir: TParamType;
    eType: TADDataType;
    eAttrs: TADDataAttributes;
    iPrec, iScale: Integer;
    uiLen: LongWord;
    oRow: TADDatSRow;
  begin
    while (AFrom <= ATo) and ADInSet(ASQL[AFrom], [' ', #9, #13, #10]) do
      Inc(AFrom);
    if StrLIComp(PChar(ASQL) + AFrom - 1, PChar('RETURNS'), 7) = 0 then begin
      eDir := ptResult;
      Inc(AFrom, 7);
    end
    else if StrLIComp(PChar(ASQL) + AFrom - 1, PChar('INOUT'), 5) = 0 then begin
      eDir := ptInputOutput;
      Inc(AFrom, 5);
    end
    else if StrLIComp(PChar(ASQL) + AFrom - 1, PChar('IN'), 2) = 0 then begin
      eDir := ptInput;
      Inc(AFrom, 2);
    end
    else if StrLIComp(PChar(ASQL) + AFrom - 1, PChar('OUT'), 3) = 0 then begin
      eDir := ptOutput;
      Inc(AFrom, 3);
    end
    else
      eDir := ptInput;
    if eDir = ptResult then
      sName := 'result'
    else begin
      while (AFrom <= ATo) and AdInSet(ASQL[AFrom], [' ', #9, #13, #10]) do
        Inc(AFrom);
      if ASQL[AFrom] = '`' then begin
        iPrev := AFrom;
        repeat
          Inc(AFrom);
        until (AFrom > ATo) or (ASQL[AFrom] = '`');
        sName := Copy(ASQL, iPrev + 1, AFrom - iPrev - 1);
      end
      else begin
        iPrev := AFrom;
        repeat
          Inc(AFrom);
        until (AFrom > ATo) or AdInSet(ASQL[AFrom], [')', '(', ',', ' ', #9, #13, #10]);
        sName := Copy(ASQL, iPrev, AFrom - iPrev);
      end;
      Inc(AFrom);
    end;

    if (GetWildcard <> '') and not ADStrLike(sName, GetWildcard) then
      Exit;

    while (AFrom <= ATo) and AdInSet(ASQL[AFrom], [' ', #9, #13, #10]) do
      Inc(AFrom);
    eType := dtUnknown;
    eAttrs := [];
    uiLen := 0;
    iPrec := 0;
    iScale := 0;
    sType := Copy(ASQL, AFrom, ATo - AFrom + 1);
    MySQLType2ADType(sType, eType, eAttrs, uiLen, iPrec, iScale);

    oRow := ATable.NewRow(False);
    oRow.SetData(0, iRecNo);
    oRow.SetData(1, rName.FCatalog);
    oRow.SetData(2, rName.FSchema);
    oRow.SetData(3, nil, 0);
    oRow.SetData(4, rName.FObject);
    oRow.SetData(5, 0);
    oRow.SetData(6, sName);
    oRow.SetData(7, Smallint(iRecNo));
    oRow.SetData(8, Smallint(eDir));
    oRow.SetData(9, Smallint(eType));
    oRow.SetData(10, nil, 0);
    oRow.SetData(11, PWord(@eAttrs)^);
    oRow.SetData(12, iPrec);
    oRow.SetData(13, iScale);
{$IFDEF AnyDAC_D6Base}
    oRow.SetData(14, uiLen);
{$ELSE}
    oRow.SetData(14, Integer(uiLen));
{$ENDIF}
    ATable.Rows.Add(oRow);
    Inc(iRecNo);
  end;

begin
  Result := 0;
  iRecNo := 1;
  sMode := GetCrsData(1, FBuffer.Ptr);
  sSQL := GetCrsData(2, FBuffer.Ptr);
  FConnection.CreateMetadata(oConnMeta);
  oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self, [doNormalize, doUnquote]);

  lAnsiQuotes := Pos('ANSI_QUOTES', sMode) <> 0;
  // lNoBackslash := Pos('NO_BACKSLASH_ESCAPES', sMode) <> 0;

  { TODO -cMySQL : SP parameter parsing will fail if a comment contains '(' }
  i := Pos('(', sSQL) + 1;
  lInQuote1 := False;
  lInQuote2 := False;
  iBraces := 0;
  iPrev := i;
  while i < Length(sSQL) do begin
    case sSQL[i] of
    '`':
      if not lInQuote2 then
        lInQuote1 := not lInQuote1;
    '"':
      if lAnsiQuotes and not lInQuote1 then
        lInQuote2 := not lInQuote2;
    '(':
      if not lInQuote2 and not lInQuote1 then
        Inc(iBraces);
    ')':
      if not lInQuote2 and not lInQuote1 then
        if iBraces = 0 then begin
          if iPrev <= i - 1 then begin
            AddParam(sSQL, iPrev, i - 1);
            Inc(Result);
          end;
          Inc(i);
          Break;
        end
        else
          Dec(iBraces);
    ',':
      if not lInQuote2 and not lInQuote1 and (iBraces = 0) then begin
        AddParam(sSQL, iPrev, i - 1);
        Inc(Result);
        iPrev := i + 1;
      end;
    end;
    Inc(i);
  end;

  while (i < Length(sSQL)) and AdInSet(sSQL[i], [' ', #9, #13, #10]) do
    Inc(i);
  if StrLIComp(PChar(sSQL) + i - 1, PChar('RETURNS'), 7) = 0 then begin
    AddParam(sSQL, i, Length(sSQL));
    Inc(Result);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.FetchFKRows(ATable: TADDatSTable;
  AParentRow: TADDatSRow): Integer;

  function TrimQuotes(const AStr: String): String;
  begin
    Result := ADUnquote(Trim(AStr), '`');
  end;

var
  sFKCat, sFKTab, sFKName, sComment, sTabName, sFKey, sFKFields, sFields: String;
  iCommentField, i, i1, i2, i3, i4, i5, j1, j2, iRecNo: Integer;
  oRow: TADDatSRow;
begin
  Result := 0;
  iRecNo := 1;
  if TADPhysMySQLConnection(FConnectionObj).FServerVersion < mvMySQL040100 then
    iCommentField := 14
  else
    iCommentField := 15;
  sComment := GetCrsData(iCommentField, FBuffer.Ptr);
  sTabName := GetCrsData(0, FBuffer.Ptr);
  if Pos('InnoDB', sComment) = 1 then begin
    i := 1;
    ADExtractFieldName(sComment, i, GSemicolonFmtSettings);
    while i <= Length(sComment) do begin
      sFKey := ADExtractFieldName(sComment, i, GSemicolonFmtSettings);
      i1 := ADPosEx('(', sFKey, 1);
      i2 := ADPosEx(')', sFKey, i1);
      i3 := ADPosEx('/', sFKey, i2);
      i4 := ADPosEx('(', sFKey, i3);
      i5 := ADPosEx(')', sFKey, i4);
      if (i1 <> -1) and (i2 <> -1) and (i3 <> -1) and (i4 <> -1) and (i5 <> -1) then begin
        sFKCat := TrimQuotes(Copy(sFKey, i2 + 8, i3 - i2 - 8));
        sFKTab := TrimQuotes(Copy(sFKey, i3 + 1, i4 - i3 - 1));
        sFKName := sTabName + '_to_' + sFKTab;
        sFields := Copy(sFKey, i1 + 1, i2 - i1 - 1);
        sFKFields := Copy(sFKey, i4 + 1, i5 - i4 - 1);
        if GetMetaInfoKind = mkForeignKeys then begin
          oRow := ATable.NewRow(False);
          oRow.SetData(0, iRecNo);
          oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).InternalGetCurrentCatalog);
          oRow.SetData(2, nil, 0);
          oRow.SetData(3, sTabName);
          oRow.SetData(4, sFKName);
          oRow.SetData(5, sFKCat);
          oRow.SetData(6, nil, 0);
          oRow.SetData(7, sFKTab);
          oRow.SetData(8, IntToStr(Integer(ckCascade)));
          oRow.SetData(9, IntToStr(Integer(ckCascade)));
          ATable.Rows.Add(oRow);
          Inc(iRecNo);
          Inc(Result);
        end
        else if AnsiCompareText(sFKName, TrimQuotes(GetCommandText)) = 0 then begin
          j1 := 1;
          j2 := 1;
          while (j1 <= Length(sFields)) and (j2 <= Length(sFKFields)) do begin
            oRow := ATable.NewRow(False);
            oRow.SetData(0, iRecNo);
            oRow.SetData(1, TADPhysMySQLConnection(FConnectionObj).InternalGetCurrentCatalog);
            oRow.SetData(2, nil, 0);
            oRow.SetData(3, sTabName);
            oRow.SetData(4, sFKName);
            oRow.SetData(5, TrimQuotes(ADExtractFieldName(sFields, j1, GSpaceFmtSettings)));
            oRow.SetData(6, TrimQuotes(ADExtractFieldName(sFKFields, j2, GSpaceFmtSettings)));
            oRow.SetData(7, Result + 1);
            ATable.Rows.Add(oRow);
            Inc(iRecNo);
            Inc(Result);
          end;
          Break;
        end;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysMySQLCommand.InternalFetchRowSet(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowsetSize: LongWord): LongWord;
var
  i: LongWord;
begin
  Result := 0;
  if GetMetaInfoKind = mkProcArgs then begin
    if FCursor.Fetch(1) then
      Result := FetchSPParamRows(ATable, AParentRow);
  end
  else if (GetMetaInfoKind in [mkForeignKeys, mkForeignKeyFields]) and
          (TADPhysMySQLConnection(FConnectionObj).FServerVersion < mvMySQL050100) then begin
    if FCursor.Fetch(1) then
      Result := FetchFKRows(ATable, AParentRow);
  end
  else
    for i := 1 to ARowsetSize do begin
      if not FCursor.Fetch(i) then
        Break;
      if GetMetaInfoKind = mkNone then
        FetchRow(ATable, AParentRow)
      else
        FetchMetaRow(ATable, AParentRow, i - 1);
      Inc(Result);
    end;
end;

{-----------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterDriverClass(TADPhysMySQLDriver);

end.
