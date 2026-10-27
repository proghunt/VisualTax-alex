{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{               FireDAC PostgreSQL driver               }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysPG"'}

unit uADPhysPG;

interface

uses
  Classes,
  uADPhysManager;

type
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TADPhysPgDriverLink = class(TADPhysDriverLink)
  protected
    function GetBaseDriverID: String; override;
  end;

{-------------------------------------------------------------------------------}
implementation

uses
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}
{$IFNDEF NEXTGEN}
  {$IFDEF AnyDAC_Unicode}
  AnsiStrings,
  {$ENDIF}
{$ENDIF}
  SysUtils, DB,
  uADStanIntf, uADStanParam, uADStanError, uADStanOption, uADStanUtil,
    uADStanConst, uADStanFactory,
  uADDatSManager,
  uADPhysIntf, uADPhysPGMeta, uADPhysCmdGenerator, uADPhysPGCli,
    uADPhysPGWrapper;

type
  TADPhysPgDriver = class;
  TADPhysPgConnection = class;
  TADPhysPgTransaction = class;
  TADPhysPgEventAlerter = class;
  TADPhysPgCommand = class;

  TADPhysPGCliHandles = array [0..1] of Pointer;
  PADPhysPGCliHandles = ^TADPhysPGCliHandles;

  TADPhysOidAsBlob = (oabChoose, oabNo, oabYes);

  TADPhysPgDriver = class(TADPhysDriver)
  private
    FLib: TPgLib;
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

  TADPhysPgConnection = class(TADPhysConnection)
  private
    FEnv: TPgEnv;
    FConnection: TPgConnection;
    FServerVersion: TADVersion;
    FOidAsBlob: TADPhysOidAsBlob;
    FExtendedMetadata: Boolean;
    FCliHandles: TADPhysPGCliHandles;
    FUseMonthsBetween: Boolean;
    function BuildPgConnectString(const AConnectionDef: IADStanConnectionDef): String;
    procedure UpdateCurrentMeta;
    function AdjustOIDasBLOB(const ATypeName, ANameSpace: String;
      var ADataType: TADDataType; var AAttrs: TADDataAttributes): Boolean;
  protected
    procedure InternalConnect; override;
    procedure InternalSetMeta; override;
    procedure InternalDisconnect; override;
    procedure InternalChangePassword(const AUserName, AOldPassword,
      ANewPassword: String); override;
    function InternalCreateTransaction: TADPhysTransaction; override;
    function InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter; override;
    function InternalCreateCommand: TADPhysCommand; override;
    function InternalCreateMetadata: TObject; override;
    function InternalCreateCommandGenerator(const ACommand: IADPhysCommand): TADPhysCommandGenerator; override;
{$IFDEF AnyDAC_MONITOR}
    procedure InternalTracingChanged; override;
{$ENDIF}
    procedure InternalExecuteDirect(const ASQL: String; ATransaction: TADPhysTransaction); override;
    procedure GetItem(AIndex: Integer; out AName: String;
      out AValue: Variant; out AKind: TADMoniAdapterItemKind); override;
    function GetItemCount: Integer; override;
    function GetMessages: EADDBEngineException; override;
    function GetCliObj: Pointer; override;
    function InternalGetCliHandle: Pointer; override;
    function GetLastAutoGenValue(const AName: String): Variant; override;
  public
    constructor Create(ADriverObj: TADPhysDriver; AConnHost: TADPhysConnectionHost); override;
    destructor Destroy; override;
    property PgConnection: TPgConnection read FConnection;
  end;

  TADPhysPgTransaction = class(TADPhysTransaction)
  protected
    procedure InternalStartTransaction(ATxID: LongWord); override;
    procedure InternalCommit(ATxID: LongWord); override;
    procedure InternalRollback(ATxID: LongWord); override;
    procedure InternalChanged; override;
    procedure InternalCheckState(ACommandObj: TADPhysCommand; ASuccess: Boolean); override;
    procedure InternalNotify(ANotification: TADPhysTxNotification; ACommandObj: TADPhysCommand); override;
  end;

  TADPhysPgEventAlerter = class(TADPhysEventAlerter)
  private
    FWaitConnection: IADPhysConnection;
    FWaitThread: TThread;
  protected
    // TADPhysEventAlerter
    procedure InternalAllocHandle; override;
    procedure InternalRegister; override;
    procedure InternalHandle(AEventMessage: TADPhysEventMessage); override;
    procedure InternalAbortJob; override;
    procedure InternalUnregister; override;
    procedure InternalReleaseHandle; override;
    procedure InternalSignal(const AEvent: String; const AArgument: Variant); override;
  end;

  PADPgParInfoRec = ^TADPgParInfoRec;
  PADPgVecInfoRec = ^TADPgVecInfoRec;
  PADPgColInfoRec = ^TADPgColInfoRec;
  PADPgRecInfoRec = ^TADPgRecInfoRec;
  PADProcArgRec = ^TADProcArgRec;

  TADPgParInfoRec = record
    FPgParamIndex: Integer;
    FParamIndex: Integer;
    FOutSQLDataType: OID;
    FDestDataType: TADDataType;
    FSrcDataType: TADDataType;
    FOutDataType: TADDataType;
    FSrcFieldType: TFieldType;
    FSrcSize: LongWord;
    FSrcPrec: Integer;
    FSrcScale: Integer;
    FParamType: TParamType;
    FVecInfo: PADPgVecInfoRec;
  end;

  TADPgVecInfoRec = record
    FParInfos: array of TADPgParInfoRec;
  end;

  TADPgColInfoRec = record
    FName: String;
    FPos: Integer;
    FLen: LongWord;
    FPrec,
    FScale: Integer;
    FSrcSQLDataType: Oid;
    FSrcDataType,
    FDestDataType: TADDataType;
    FAttrs: TADDataAttributes;
    FField: TPgField;
    FOriginSchemaName,
    FOriginTabName,
    FOriginColName: String;
    FTableCol: Integer;
    FTableOid: Oid;
    FInPK: WordBool;
    FRecInfo: PADPgRecInfoRec;
  end;

  TADPgRecInfoRec = record
    FColInfos: array of TADPgColInfoRec;
    // next members are actually temporary variables
    FColIndex: Integer;
    FFixedLength: Integer;
    FParentColName: String;
  end;

  TADProcArgRec = record
    FName: String;
    FParamType: TParamType;
    FTypeOid: Oid;
  end;
  TADProcArgRecs = array of TADProcArgRec;

  TADPhysPgSPDescriber = class(TObject)
  private
    FCommand: TADPhysPgCommand;
    FName: TADPhysParsedName;
    procedure CreateParam(AName: String; AParamType: TParamType; ATypeOid: Oid);
  public
    constructor Create(ACommand: TADPhysPgCommand; const AName: TADPhysParsedName);
    procedure CreateParams;
    procedure ReadProcArgs(var AProcArgs: TADProcArgRecs);
  end;

  TADPhysPgCommand = class(TADPhysCommand)
  private
    FStmt: TPgStatement;
    FBaseStmt: TPgStatement;
    FBaseVecInfo: TADPgVecInfoRec;
    FBaseRecInfo: TADPgRecInfoRec;
    FCurrentRecInfo: PADPgRecInfoRec;
    FInfoStack: TADPtrList;
    FCursorCanceled: Boolean;
    FCursors: array of String;
    FActiveCrs: Integer;
    FMetaProcName: String;
    FMetaProcOverload: Word;
    FOidAsBlob: Boolean;
    FStmtParamsCount: Integer;
    FPreparedBatchSize: Integer;

    function GetConnection: TADPhysPgConnection;

    function ADType2SQL(AType: TADDataType): Oid;
    procedure SQL2ADColInfo(ASQLTypeOid: Oid; ASQLLen: LongWord; ASQLPrec,
      ASQLScale: Integer; out AType: TADDataType; var AAttrs: TADDataAttributes;
      out ALen: LongWord; out APrec, AScale: Integer; AFmtOpts: TADFormatOptions);

    function CreateStmt: TPgStatement;
    function UseExecDirect: Boolean;

    procedure CreateParamInfos;
    procedure DestroyParamInfos;
    procedure CreateColInfos;
    procedure DestroyColInfos;
    procedure CheckColInfos;
    function BuildColumnName(ApRecInfo: PADPgRecInfoRec; ApColInfo: PADPgColInfoRec): String;

    procedure SetParamValue(AFmtOpts: TADFormatOptions; AParam: TADParam;
      APgParam: TPgParam; ApInfo: PADPgParInfoRec; AArrIndex: Integer);
    procedure SetParamValues(AArrIndex: Integer = 0);
    procedure GetParamValues(AArrIndex: Integer = 0);
    procedure ExecuteBatchInsert(ATimes, AOffset: Integer; var ACount: TADCounter);
    procedure DoExecute(ATimes, AOffset: Integer; var ACount: TADCounter);
    function CheckArray(ASize: Integer): Boolean;

    procedure FetchRow(ApRecInfo: PADPgRecInfoRec; ATable: TADDatSTable;
      AParentRow: TADDatSRow);
    procedure FetchTableFieldsRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
    procedure FetchProcsRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
    function FetchSPParamRows(ATable: TADDatSTable; AParentRow: TADDatSRow): Integer;
  protected
    procedure InternalPrepare; override;
    function InternalUseStandardMetadata: Boolean; override;
    function InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean; override;
    function InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean; override;
    procedure InternalExecute(ATimes: LongInt; AOffset: LongInt; var ACount: TADCounter); override;
    function InternalOpen: Boolean; override;
    function InternalNextRecordSet: Boolean; override;
    function InternalFetchRowSet(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowsetSize: LongWord): LongWord; override;
    procedure InternalAbort; override;
    procedure InternalClose; override;
    procedure InternalUnprepare; override;
    function GetCliObj: Pointer; override;
  public
    constructor Create(AConnectionObj: TADPhysConnection);
    destructor Destroy; override;
    property PgConnection: TADPhysPgConnection read GetConnection;
    property PgStatement: TPgStatement read FStmt;
  end;

const
  S_AD_CharacterSets = 'BIG5;EUC_CN;EUC_JP;EUC_KR;EUC_TW;GB18030;GBK;ISO_8859_5;' +
    'ISO_8859_6;ISO_8859_7;ISO_8859_8;JOHAB;KOI8;LATIN1;LATIN2;LATIN3;LATIN4;LATIN5;' +
    'LATIN6;LATIN7;LATIN8;LATIN9;LATIN10;MULE_INTERNAL;SJIS;SQL_ASCII;UHC;UTF8;' +
    'WIN866;WIN874;WIN1250;WIN1251;WIN1252;WIN1256;WIN1258';
  S_AD_Choose = 'Choose';
  S_AD_Error = 'Error';
  S_AD_BYTEA = 'BYTEA';

{-------------------------------------------------------------------------------}
{ TADPhysIBDriverLink                                                           }
{-------------------------------------------------------------------------------}
function TADPhysPgDriverLink.GetBaseDriverID: String;
begin
  Result := S_AD_PgId;
end;

{-------------------------------------------------------------------------------}
{ TADPhysIBDriver                                                               }
{-------------------------------------------------------------------------------}
constructor TADPhysPgDriver.Create(AManager: TADPhysManager;
  const ADriverDef: IADStanDefinition);
begin
  inherited Create(AManager, ADriverDef);
  FLib := TPgLib.Create(ADPhysManagerObj);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysPgDriver.Destroy;
begin
  inherited Destroy;
  ADFreeAndNil(FLib);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgDriver.InternalLoad;
var
  sHome, sLib: String;
begin
  sHome := '';
  sLib := '';
  GetVendorParams(sHome, sLib);
  FLib.Load(sHome, sLib);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgDriver.InternalUnload;
begin
  FLib.Unload;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgDriver.InternalCreateConnection(
  AConnHost: TADPhysConnectionHost): TADPhysConnection;
begin
  Result := TADPhysPgConnection.Create(Self, AConnHost);
end;

{-------------------------------------------------------------------------------}
class function TADPhysPgDriver.GetBaseDriverID: String;
begin
  Result := S_AD_PgId;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgDriver.GetCliObj: Pointer;
begin
  Result := FLib;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 11;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
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
        ADefVal := '5432';
        ALoginIndex := 3;
      end;
    2:
      begin
        AName := S_AD_ConnParam_Common_LoginTimeout;
        AType := '@I';
        ADefVal := '0';
      end;
    3:
      begin
        AName := S_AD_ConnParam_Common_CharacterSet;
        AType := S_AD_CharacterSets;
        ADefVal := '';
      end;
    4:
      begin
        AName := S_AD_ConnParam_Common_ExtendedMetadata;
        AType := '@L';
        ADefVal := S_AD_False;
      end;
    5:
      begin
        AName := S_AD_ConnParam_PG_OidAsBlob;
        AType := S_AD_No + ';' + S_AD_Yes + ';' + S_AD_Choose;
        ADefVal := S_AD_Choose;
      end;
    6:
      begin
        AName := S_AD_ConnParam_PG_UnknownFormat;
        AType := S_AD_Error + ';' + S_AD_BYTEA;
        ADefVal := S_AD_Error;
      end;
    7:
      begin
        AName := S_AD_ConnParam_Common_ApplicationName;
        AType := '@S';
        ADefVal := '';
      end;
    8:
      begin
        AName := S_AD_ConnParam_PG_Advanced;
        AType := '@S';
        ADefVal := '';
      end;
    9:
      begin
        AName := S_AD_ConnParam_Common_MetaDefSchema;
        AType := '@S';
        ADefVal := 'public';
      end;
   10:
      begin
        AName := S_AD_ConnParam_Common_MetaCurSchema;
        AType := '@S';
        ADefVal := '';
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysPgConnection                                                           }
{-------------------------------------------------------------------------------}
constructor TADPhysPgConnection.Create(ADriverObj: TADPhysDriver; AConnHost: TADPhysConnectionHost);
begin
  inherited Create(ADriverObj, AConnHost);
  FEnv := TPgEnv.Create(TADPhysPgDriver(DriverObj).FLib, Self);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysPgConnection.Destroy;
begin
  inherited Destroy;
  ADFreeAndNil(FEnv);
end;

{-------------------------------------------------------------------------------}
function TADPhysPgConnection.InternalCreateTransaction: TADPhysTransaction;
begin
  Result := TADPhysPgTransaction.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysPgConnection.InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter;
begin
  if CompareText(AEventKind, S_AD_EventKind_PG_Events) = 0 then
    Result := TADPhysPgEventAlerter.Create(Self, AEventKind)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgConnection.InternalCreateCommand: TADPhysCommand;
begin
  Result := TADPhysPgCommand.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysPgConnection.InternalCreateMetadata: TObject;
begin
  Result := TADPhysPgMetadata.Create(Self, FServerVersion,
    TADPhysPgDriver(DriverObj).FLib.Version,
    (Fconnection <> nil) and (FConnection.Encoder.Encoding in [ecUTF8, ecUTF16]),
    FExtendedMetadata, FUseMonthsBetween);
end;

{-------------------------------------------------------------------------------}
function TADPhysPgConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysPgCommandGenerator.Create(ACommand)
  else
    Result := TADPhysPgCommandGenerator.Create(Self);
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TADPhysPgConnection.InternalTracingChanged;
begin
  if FEnv <> nil then begin
    FEnv.Monitor := FMonitor;
    FEnv.Tracing := FTracing;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADPhysPgConnection.BuildPgConnectString(const AConnectionDef: IADStanConnectionDef): String;

  function IsIpAddress(const AAddr: String): Boolean;
  var
    iFrom, iVal, iCode, iCnt: Integer;
  begin
    iFrom := 1;
    iCnt := 0;
    while (iFrom <= Length(AAddr)) and (iCnt <= 5) do begin
      Val(ADStrToken(AAddr, '.', iFrom), iVal, iCode);
      if (iCode = 0) and (iVal <= 255) then
        Inc(iCnt)
      else
        Break;
    end;
    Result := (iCnt = 4);
  end;

  procedure Add(const AParam: String);
  begin
    if Result <> '' then
      Result := Result + ' ';
    Result := Result + AParam;
  end;

var
  i: Integer;
  sAdv: String;
begin
  Result := '';
  i := 1;
  sAdv := AConnectionDef.AsString[S_AD_ConnParam_PG_Advanced];
  while i <= Length(sAdv) do
    Add(ADExtractFieldName(sAdv, i));
  if AConnectionDef.HasValue(S_AD_ConnParam_Common_Server) then
    if IsIpAddress(AConnectionDef.Server) then
      Add('hostaddr=' + AConnectionDef.Server)
    else
      Add('host=' + AConnectionDef.Server);
  if AConnectionDef.HasValue(S_AD_ConnParam_Common_Port) then
    Add('port=' + IntToStr(AConnectionDef.Port));
  if AConnectionDef.HasValue(S_AD_ConnParam_Common_Database) then
    Add('dbname=' + AConnectionDef.Database);
  if AConnectionDef.HasValue(S_AD_ConnParam_Common_UserName) then
    Add('user=' + AConnectionDef.UserName);
  if AConnectionDef.HasValue(S_AD_ConnParam_Common_Password) then
    Add('password=' + AConnectionDef.Password);
  if AConnectionDef.HasValue(S_AD_ConnParam_Common_LoginTimeout) then
    Add('connect_timeout=' + AConnectionDef.AsString[S_AD_ConnParam_Common_LoginTimeout]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgConnection.InternalConnect;
var
  sEncoding, sMode: String;
  pCliHandles: PADPhysPGCliHandles;
begin
  if InternalGetSharedCliHandle() <> nil then begin
    pCliHandles := PADPhysPGCliHandles(InternalGetSharedCliHandle());
    FConnection := TPgConnection.CreateUsingHandle(FEnv, pCliHandles^[0], Self);
  end
  else
    FConnection := TPgConnection.Create(FEnv, Self);
{$IFDEF AnyDAC_MONITOR}
  InternalTracingChanged;
{$ENDIF}

  if InternalGetSharedCliHandle() = nil then begin
    FConnection.Connect(BuildPgConnectString(GetConnectionDef));

    if GetConnectionDef.HasValue(S_AD_ConnParam_Common_CharacterSet) then
      FConnection.ClientEncoding := GetConnectionDef.AsString[S_AD_ConnParam_Common_CharacterSet];

    if GetConnectionDef.NewPassword <> '' then
      InternalExecuteDirect('ALTER USER ' + GetConnectionDef.UserName +
        ' PASSWORD ''' + GetConnectionDef.NewPassword + '''', nil);
  end;

  FServerVersion := FConnection.ServerVersion;
  sEncoding := FConnection.ClientEncoding;
  if SameText(sEncoding, 'UTF8') or SameText(sEncoding, 'UNICODE') then
    FConnection.Encoder.Encoding := ecUTF8
  else
    FConnection.Encoder.Encoding := ecANSI;
  if GetConnectionDef.HasValue(S_AD_ConnParam_Common_ExtendedMetadata) then
    FExtendedMetadata := GetConnectionDef.AsBoolean[S_AD_ConnParam_Common_ExtendedMetadata]
  else
    FExtendedMetadata := False;
  sMode := GetConnectionDef.AsString[S_AD_ConnParam_PG_OidAsBlob];
  if CompareText(sMode, S_AD_Yes) = 0 then
    FOidAsBlob := oabYes
  else if CompareText(sMode, S_AD_No) = 0 then
    FOidAsBlob := oabNo
  else
    FOidAsBlob := oabChoose;
  sMode := GetConnectionDef.AsString[S_AD_ConnParam_PG_UnknownFormat];
  if CompareText(sMode, S_AD_BYTEA) = 0 then
    FConnection.UnknownFormat := SQL_BYTEA
  else
    FConnection.UnknownFormat := 0;

  if (FServerVersion >= svPGSQL090000) and
     GetConnectionDef.HasValue(S_AD_ConnParam_Common_ApplicationName) then
    InternalExecuteDirect('SET APPLICATION_NAME TO ''' +
      GetConnectionDef.AsString[S_AD_ConnParam_Common_ApplicationName] + '''', nil);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgConnection.InternalSetMeta;
begin
  inherited InternalSetMeta;
  if FCurrentSchema = '' then
    UpdateCurrentMeta;
  if FDefaultSchema = '' then
    FDefaultSchema := 'public';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgConnection.InternalDisconnect;
begin
  ADFreeAndNil(FConnection);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgConnection.InternalChangePassword(const AUserName,
  AOldPassword, ANewPassword: String);
var
  oConnDef: IADStanConnectionDef;
  oConn: TPgConnection;
begin
  ADCreateInterface(IADStanConnectionDef, oConnDef);
  oConnDef.ParentDefinition := ConnectionDef;
  oConnDef.UserName := AUserName;
  oConnDef.Password := AOldPassword;
  oConn := TPgConnection.Create(FEnv, Self);
  try
    oConn.Connect(BuildPgConnectString(oConnDef));
    oConn.ExecuteQuery('ALTER USER ' + oConnDef.UserName +
      ' PASSWORD ''' + ANewPassword + '''');
  finally
    ADFree(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgConnection.InternalExecuteDirect(const ASQL: String;
  ATransaction: TADPhysTransaction);
begin
  FConnection.ExecuteQuery(ASQL);
end;

{-------------------------------------------------------------------------------}
function TADPhysPgConnection.GetLastAutoGenValue(const AName: String): Variant;
begin
  if (FConnection <> nil) and (AName = '') then
    if FConnection.LastInsertOid = InvalidOid then
      Result := Null
    else
{$IFDEF AnyDAC_D6Base}
      Result := FConnection.LastInsertOid
{$ELSE}
      Result := Integer(FConnection.LastInsertOid)
{$ENDIF}
  else
    Result := inherited GetLastAutoGenValue(AName);
end;

{-------------------------------------------------------------------------------}
function TADPhysPgConnection.GetItemCount: Integer;
begin
  Result := inherited GetItemCount;
  if FEnv <> nil then begin
    Inc(Result, 2);
    if FConnection <> nil then
      Inc(Result, 9);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgConnection.GetItem(AIndex: Integer; out AName: String;
  out AValue: Variant; out AKind: TADMoniAdapterItemKind);
begin
  if AIndex < inherited GetItemCount then
    inherited GetItem(AIndex, AName, AValue, AKind)
  else
    case AIndex - inherited GetItemCount of
    0:
      begin
        AName := 'Client version';
        AValue := Integer(FEnv.Lib.Version);
        AKind := ikClientInfo;
      end;
    1:
      begin
        AName := 'Client DLL name';
        AValue := FEnv.Lib.DLLName;
        AKind := ikClientInfo;
      end;
    2:
      begin
        AName := 'Server version';
        AValue := FConnection.SERVER_VERSION;
        AKind := ikSessionInfo;
      end;
    3:
      begin
        AName := 'Server encoding';
        AValue := FConnection.SERVER_ENCODING;
        AKind := ikSessionInfo;
      end;
    4:
      begin
        AName := 'Client encoding';
        AValue := FConnection.CLIENT_ENCODING;
        AKind := ikSessionInfo;
      end;
    5:
      begin
        AName := 'Is superuser';
        AValue := FConnection.IS_SUPERUSER;
        AKind := ikSessionInfo;
      end;
    6:
      begin
        AName := 'Session authorization';
        AValue := FConnection.SESSION_AUTHORIZATION;
        AKind := ikSessionInfo;
      end;
    7:
      begin
        AName := 'Date style';
        AValue := FConnection.DATESTYLE;
        AKind := ikSessionInfo;
      end;
    8:
      begin
        AName := 'Integer date/times';
        AValue := FConnection.INTEGER_DATETIMES;
        AKind := ikSessionInfo;
      end;
    9:
      begin
        AName := 'Time zone';
        AValue := FConnection.TIMEZONE;
        AKind := ikSessionInfo;
      end;
    10:
      begin
        AName := 'Standard conforming strings';
        AValue := FConnection.STANDARD_CONFORMING_STRINGS;
        AKind := ikSessionInfo;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgConnection.GetMessages: EADDBEngineException;
begin
  if FConnection <> nil then
    Result := FConnection.Notices
  else
    Result := nil; 
end;

{-------------------------------------------------------------------------------}
function TADPhysPgConnection.GetCliObj: Pointer;
begin
  Result := FConnection;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgConnection.InternalGetCliHandle: Pointer;
begin
  if FConnection <> nil then begin
    FCliHandles[0] := FConnection.FHandle;
    Result := @FCliHandles;
  end
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgConnection.UpdateCurrentMeta;
var
  oStmt: TPgStatement;
  dt: TDateTime;
  sTS: String;
  iLen: LongWord;
  iUseMonths: Integer;
  rTS: TADSQLTimeStamp;
begin
  FUseMonthsBetween := False;
  dt := Now();
  sTS := FormatDateTime('yyyy''-''mm''-''dd hh'':''nn'':''ss', dt);
  oStmt := TPgStatement.Create(FConnection, Self);
  try
    oStmt.PrepareSQL('SELECT CURRENT_SCHEMA(), ''' + sTS + '''::TIMESTAMPTZ, ' +
      '(SELECT MIN(1) FROM PG_CATALOG.PG_PROC WHERE PRONAME = ''months_between'')');
    oStmt.Execute;
    oStmt.DescribeFields;
    oStmt.Fetch;
    FCurrentSchema := oStmt.Fields[0].GetAsString;
    if oStmt.ResultFormat = 1 then begin
      oStmt.Fields[1].GetData(@rTS, iLen);
      FConnection.TimeZoneOffset :=
        Trunc((dt - ADSQLTimeStamp2DateTime(rTS) + 1 / (24 * 60 * 60)) / (1 / 24));
      FUseMonthsBetween := (oStmt.Fields[2].GetData(@iUseMonths, iLen) and (iUseMonths = 1));
    end;
  finally
    ADFree(oStmt);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgConnection.AdjustOIDasBLOB(const ATypeName, ANameSpace: String;
  var ADataType: TADDataType; var AAttrs: TADDataAttributes): Boolean;
begin
  Result :=
    (FOidAsBlob = oabYes) or (FOidAsBlob = oabChoose) and (
       // large object column must have a specially named domain
       (CompareText(ATypeName, 'LO') = 0) or
       (CompareText(ATypeName, 'LARGEOBJECT') = 0) or
       (CompareText(ATypeName, 'BLOB') = 0)
     ) and not (
       // large object column cannot be in the dictionary
       (CompareText(ANameSpace, 'information_schema') = 0) or
       (CompareText(ANameSpace, 'pg_catalog') = 0)
     );
  if Result then begin
    AAttrs := AAttrs - [caSearchable] + [caBlobData];
    ADataType := dtHBlob;
  end
  else begin
    AAttrs := AAttrs + [caSearchable] - [caBlobData];
    ADataType := dtUInt32;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysPgTransaction                                                          }
{-------------------------------------------------------------------------------}
procedure TADPhysPgTransaction.InternalStartTransaction(ATxID: LongWord);
begin
  TADPhysPgConnection(ConnectionObj).InternalExecuteDirect('BEGIN', nil);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgTransaction.InternalCommit(ATxID: LongWord);
begin
  DisconnectCommands(nil, dmRelease);
  TADPhysPgConnection(ConnectionObj).InternalExecuteDirect('COMMIT', nil);
  if Retaining then
    InternalStartTransaction(ATxID);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgTransaction.InternalRollback(ATxID: LongWord);
begin
  DisconnectCommands(nil, dmRelease);
  TADPhysPgConnection(ConnectionObj).InternalExecuteDirect('ROLLBACK', nil);
  if Retaining then
    InternalStartTransaction(ATxID);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgTransaction.InternalChanged;
var
  sSQL: String;
begin
  sSQL := '';
  if GetOptions.Isolation <> xiUnspecified then begin
    sSQL := sSQL + ' ISOLATION LEVEL ';
    case GetOptions.Isolation of
    xiDirtyRead:
      sSQL := sSQL + 'READ UNCOMMITTED';
    xiReadCommitted:
      sSQL := sSQL + 'READ COMMITTED';
    xiRepeatableRead,
    xiSnapshot:
      sSQL := sSQL + 'REPEATABLE READ';
    xiSerializible:
      sSQL := sSQL + 'SERIALIZABLE';
    end;
  end;
  if GetOptions.ReadOnly then
    sSQL := sSQL + ' READ ONLY';
  if sSQL <> '' then
    TADPhysPgConnection(ConnectionObj).InternalExecuteDirect(
      'SET SESSION CHARACTERISTICS AS TRANSACTION' + sSQL, nil);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgTransaction.InternalCheckState(ACommandObj: TADPhysCommand;
  ASuccess: Boolean);
var
  oCmd: TADPhysPgCommand;
begin
  oCmd := TADPhysPgCommand(ACommandObj);
  if (oCmd.PgConnection.PgConnection <> nil) and
     (GetActive <> (oCmd.PgConnection.PgConnection.TransactionStatus = PQTRANS_INTRANS)) then
    case oCmd.PgConnection.PgConnection.TransactionStatus of
    PQTRANS_IDLE:
      TransactionFinished;
    PQTRANS_INTRANS:
      TransactionStarted;
    PQTRANS_INERROR:
      if GetNestingLevel = 1 then begin
        // Seting FState to csRecovering is needed to avoid fetching by
        // datasets. They will set FSourceEOF to True without fetching.
        oCmd.PgConnection.Lock;
        try
          oCmd.PgConnection.FState := csRecovering;
          DisconnectCommands(nil, dmOffline);
        finally
          if oCmd.PgConnection.FState = csRecovering then
            oCmd.PgConnection.FState := csConnected;
          oCmd.PgConnection.UnLock;
        end;
        // Now application must explicitly Commit / Rollback failed transaction
        // TransactionFinished;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgTransaction.InternalNotify(ANotification: TADPhysTxNotification;
  ACommandObj: TADPhysCommand);
begin
  if (ANotification = cpBeforeCmdExecute) and
     (TADPhysPgCommand(ACommandObj).GetCommandKind in [skCommit, skRollback]) then
    DisconnectCommands(nil, dmRelease);
  inherited InternalNotify(ANotification, ACommandObj);
end;

{-------------------------------------------------------------------------------}
{ TADPhysPgEventMessage                                                         }
{-------------------------------------------------------------------------------}
type
  TADPhysPgEventMessage = class(TADPhysEventMessage)
  private
    FName: String;
    FProcID: Integer;
    FParam: String;
  public
    constructor Create(const AName: String; AProcID: Integer; const AParam: String);
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysPgEventMessage.Create(const AName: String; AProcID: Integer;
  const AParam: String);
begin
  inherited Create;
  FName := AName;
  FProcID := AProcID;
  FParam := AParam;
end;

{-------------------------------------------------------------------------------}
{ TADPhysPgEventThread                                                          }
{-------------------------------------------------------------------------------}
type
  TADPhysPgEventThread = class(TThread)
  private
    FAlerter: TADPhysPgEventAlerter;
  protected
    procedure Execute; override;
  public
    constructor Create(AAlerter: TADPhysPgEventAlerter);
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysPgEventThread.Create(AAlerter: TADPhysPgEventAlerter);
begin
  inherited Create(False);
  FAlerter := AAlerter;
  FreeOnTerminate := True;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysPgEventThread.Destroy;
begin
  FAlerter.FWaitThread := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgEventThread.Execute;
var
  oConn: TPgConnection;
  sName, sParam: String;
  iProcID: Integer;
begin
  while not Terminated and FAlerter.IsRunning do
    try
      oConn := TPgConnection(FAlerter.FWaitConnection.CliObj);
      if oConn.CheckForInput() then
        while oConn.ReadNotifies(sName, iProcID, sParam) do
          FAlerter.FMsgThread.EnqueueMsg(TADPhysPgEventMessage.Create(
            sName, iProcID, sParam));
    except
      on E: EADDBEngineException do
        if E.Kind <> ekCmdAborted then begin
          Terminate;
          FAlerter.AbortJob;
        end;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysPgEventAlerter                                                         }
{-------------------------------------------------------------------------------}
procedure TADPhysPgEventAlerter.InternalAllocHandle;
begin
  FWaitConnection := GetConnection.Clone;
  if FWaitConnection.State = csDisconnected then
    FWaitConnection.Open;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgEventAlerter.InternalRegister;
var
  i: Integer;
  oCmd: IADPhysCommand;
begin
  FWaitConnection.CreateCommand(oCmd);
  SetupCommand(oCmd);
  for i := 0 to GetNames.Count - 1 do begin
    oCmd.Prepare('LISTEN ' + GetNames[i]);
    oCmd.Execute();
  end;
  FWaitThread := TADPhysPgEventThread.Create(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgEventAlerter.InternalHandle(AEventMessage: TADPhysEventMessage);
var
  oMsg: TADPhysPgEventMessage;
begin
  if GetHandler <> nil then begin
    oMsg := TADPhysPgEventMessage(AEventMessage);
    GetHandler.HandleEvent(oMsg.FName, VarArrayOf([oMsg.FProcID, oMsg.FParam]));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgEventAlerter.InternalAbortJob;
begin
  if FWaitThread <> nil then
    FWaitThread.Terminate;
  TPgConnection(FWaitConnection.CliObj).Abort;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgEventAlerter.InternalUnregister;
var
  i: Integer;
  oCmd: IADPhysCommand;
begin
  FWaitConnection.CreateCommand(oCmd);
  SetupCommand(oCmd);
  for i := 0 to GetNames.Count - 1 do begin
    oCmd.Prepare('UNLISTEN ' + GetNames[i]);
    oCmd.Execute();
  end;
  FWaitThread := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgEventAlerter.InternalReleaseHandle;
begin
  FWaitConnection := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgEventAlerter.InternalSignal(const AEvent: String;
  const AArgument: Variant);
var
  oCmd: IADPhysCommand;
  sCmd: String;
begin
  FWaitConnection.CreateCommand(oCmd);
  SetupCommand(oCmd);
  sCmd := 'NOTIFY ' + AEvent;
  if not VarIsEmpty(AArgument) then
    if TADPhysPgConnection(ConnectionObj).FServerVersion >= svPGSQL090000 then
      sCmd := sCmd + ', ' + QuotedStr(VarToStr(AArgument))
    else
      ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_PGId]);
  oCmd.Prepare(sCmd);
  oCmd.Execute();
end;

{-------------------------------------------------------------------------------}
{ TADPhysPgSPDesriber                                                           }
{-------------------------------------------------------------------------------}
constructor TADPhysPgSPDescriber.Create(ACommand: TADPhysPgCommand;
  const AName: TADPhysParsedName);
begin
  inherited Create;
  FCommand := ACommand;
  FName := AName;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgSPDescriber.CreateParams;
var
  i: Integer;
  oProcArgs: TADProcArgRecs;
  pArg: PADProcArgRec;
begin
  ReadProcArgs(oProcArgs);
  for i := 0 to Length(oProcArgs) - 1 do begin
    pArg := @oProcArgs[i];
    CreateParam(pArg^.FName, pArg^.FParamType, pArg^.FTypeOid);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgSPDescriber.CreateParam(AName: String; AParamType: TParamType; ATypeOid: Oid);
var
  uiSize: LongWord;
  iPrec, iScale: Integer;
  eSrcADDataType, eDestADDataType: TADDataType;
  eDestDataType: TFieldType;
  eSrcAttrs: TADDataAttributes;
  uiDestSize: LongWord;
  iDestPrec, iDestScale: Integer;
  oType: TPgType;
  i: Integer;
  oParam: TADParam;
  oFmt: TADFormatOptions;
  oMbr: TPgMember;
begin
  uiSize := 0;
  iPrec := 0;
  iScale := 0;
  eSrcAttrs := [];
  FCommand.SQL2ADColInfo(ATypeOid, 0, 0, 0, eSrcADDataType, eSrcAttrs,
    uiSize, iPrec, iScale, FCommand.FOptions.FormatOptions);
  if eSrcADDataType <> dtUnknown then begin
    oParam := FCommand.GetParams.Add;
    try
      oParam.Name := AName;
      oParam.Position := oParam.Index + 1;
      oParam.ParamType := AParamType;

      oFmt := FCommand.FOptions.FormatOptions;
      eDestADDataType := dtUnknown;
      eDestDataType := ftUnknown;
      uiDestSize := 0;
      iDestPrec := 0;
      iDestScale := 0;
      oFmt.ResolveDataType(AName, eSrcADDataType, uiSize, iPrec, iScale,
        eDestADDataType, uiSize, True);
      oFmt.ColumnDef2FieldDef(eDestADDataType, uiSize, iPrec, iScale, eSrcAttrs,
        eDestDataType, uiDestSize, iDestPrec, iDestScale);
    except
      ADFree(oParam);
      raise;
    end;
    oParam.DataType := eDestDataType;
    oParam.ADDataType := eDestADDataType;
    oParam.Size := uiDestSize;
    oParam.Precision := iDestPrec;
    oParam.NumericScale := iDestScale;
  end
  else
    if AParamType = ptResult then begin
      oType := FCommand.PgConnection.FConnection.TypesManager.Types[ATypeOid];
      for i := 0 to Length(oType.Members) - 1 do begin
        oMbr := oType.Members[i];
        CreateParam(oMbr.Name, AParamType, oMbr.TypeOid);
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgSPDescriber.ReadProcArgs(var AProcArgs: TADProcArgRecs);

  function SplitTextArray(const AStr: String): TADStringArray;
  var
    i: Integer;
    iPrevPos: Integer;
    iIndex: Integer;
    iLen: Integer;
  begin
    iIndex := 0;
    iPrevPos := 1;
    iLen := Length(AStr);
    if iLen = 0 then
      Exit;
    SetLength(Result, iLen shr 1 + 1);
    for i := 1 to iLen do
      if (AStr[i] = ';') then begin
        Result[iIndex] := Copy(AStr, iPrevPos, i - iPrevPos);
        iPrevPos := i + 1;
        Inc(iIndex);
      end;
    Result[iIndex] := Copy(AStr, iPrevPos, Length(AStr));
    SetLength(Result, iIndex + 1);
  end;
  
var
  i: Integer;
  iIndex, iOverload: Integer;
  sParamName, sParamType: String;
  sParamTypes, sDataTypes, sParamNames: TADStringArray;
  bHasOutParams: Boolean;
  iResTypeOid: Oid;
  oPgStmt: TPgStatement;
  oPgPar: TPgParam;
  oGen: IADPhysCommandGenerator;
begin
  sParamNames := nil;
  sDataTypes := nil;
  sParamTypes := nil;
  oPgStmt := TPgStatement.Create(FCommand.PgConnection.FConnection, Self);
  try
    FCommand.CreateCommandGenerator(oGen);
    oPgStmt.Params.Count := 2;

    oPgPar := oPgStmt.Params[0];
    oPgPar.TypeOid := SQL_NAME;
    oPgPar.Size := 70;
    oPgPar.Encoding := {$IFDEF AnyDAC_Unicode} ecUTF16 {$ELSE} ecANSI {$ENDIF};
    oPgPar.SetData(PChar(FName.FObject), Length(FName.FObject));

    oPgPar := oPgStmt.Params[1];
    oPgPar.TypeOID := SQL_INT4;
    oPgPar.Size := SizeOf(Integer);
    iOverload := FCommand.GetOverload();
    oPgPar.SetData(@iOverload, SizeOf(iOverload));

    oPgStmt.PrepareSQL(oGen.GenerateSelectMetaInfo(mkProcArgs,
      FName.FCatalog, FName.FSchema, FName.FBaseObject, FName.FObject,
      FCommand.GetWildcard(), FCommand.GetObjectScopes(), FCommand.GetTableKinds(),
      FCommand.GetOverload()));
    oPgStmt.Execute;
    oPgStmt.DescribeFields;

    if not oPgStmt.Fetch then
      ADException(Self, [S_AD_LPhys, S_AD_PGId], er_AD_PgProcNotFound,
        [Trim(FCommand.GetCommandText)]);

    iIndex := 0;
    bHasOutParams := False;

    sParamNames := SplitTextArray(oPgStmt.Fields[5].GetAsString);
    sDataTypes := SplitTextArray(oPgStmt.Fields[3].GetAsString);
    if Length(sDataTypes) = 0 then
      sDataTypes := SplitTextArray(oPgStmt.Fields[2].GetAsString);
    sParamTypes := SplitTextArray(oPgStmt.Fields[4].GetAsString);

    for i := 0 to Length(sDataTypes) - 1 do begin
      if Length(sParamTypes) > i then
        sParamType := sParamTypes[i]
      else
        sParamType := 'i';
      if Length(sParamNames) > i then
        sParamName := sParamNames[i]
      else
        sParamName := '';

      SetLength(AProcArgs, iIndex + 1);

      AProcArgs[iIndex].FName := sParamName;
      AProcArgs[iIndex].FTypeOid := StrToIntDef(sDataTypes[i], 0);
      if sParamType = 'i' then
        AProcArgs[iIndex].FParamType := ptInput
      else
      if sParamType = 'b' then
        AProcArgs[iIndex].FParamType := ptInputOutput
      else
      if sParamType = 'o' then
        AProcArgs[iIndex].FParamType := ptOutput
      else
        ASSERT(False);

      if AProcArgs[iIndex].FParamType = ptOutput then
        bHasOutParams := True;
      Inc(iIndex);
    end;

    if not bHasOutParams and oPgStmt.Fields[1].GetData(@iResTypeOid) then
      if iResTypeOid <> SQL_VOID then begin
        SetLength(AProcArgs, iIndex + 1);
        AProcArgs[iIndex].FName := 'result';
        AProcArgs[iIndex].FParamType := ptResult;
        AProcArgs[iIndex].FTypeOid := iResTypeOid;
      end;
  finally
    ADFree(oPgStmt);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysPgCommand                                                              }
{-------------------------------------------------------------------------------}
constructor TADPhysPgCommand.Create(AConnectionObj: TADPhysConnection);
begin
  inherited Create(AConnectionObj);
  FInfoStack := TADPtrList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysPgCommand.Destroy;
begin
  inherited Destroy;
  ADFreeAndNil(FInfoStack);
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.GetCliObj: Pointer;
begin
  Result := FStmt;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.GetConnection: TADPhysPgConnection;
begin
  Result := TADPhysPgConnection(FConnectionObj);
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.UseExecDirect: Boolean;
begin
  // FPQexec is used for direct execution of SQL without parameters.
  // FPQexec returns ResultFormat = 0, which is not supported.
  // So do not use direct execute for SELECT's without parameters.
  Result := (FOptions.ResourceOptions.DirectExecute) and
    not ((GetCommandKind in [skSelect, skSelectForLock, skSelectForUnLock,
                             skStoredProcWithCrs]) and (GetParams.Count = 0)) or
    (GetCommandKind in [skSet, skSetSchema, skCreate, skDrop, skAlter, skOther,
                        skStartTransaction, skCommit, skRollback]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.InternalPrepare;
var
  rName: TADPhysParsedName;
  oConnMeta: IADPhysConnectionMetadata;
  oDesc: TADPhysPgSPDescriber;
begin
  FInfoStack.Clear;
  FActiveCrs := -1;
  GetConnection.CreateMetadata(oConnMeta);

  // generate metadata SQL command
  if GetMetaInfoKind <> mkNone then begin
    if GetMetaInfoKind = mkProcArgs then
      // A select meta info command will be executed right in InternalFetchRowSet,
      // inside of FetchSPParamRows
      FDbCommandText := ''
    else begin
      GetSelectMetaInfoParams(rName);
      // To restrict schema in GetSelectMetaInfo to an explicitly specified one,
      // clear implicitly specified 'public'.
      if (GetMetaInfoKind in [mkTables, mkPackages, mkProcs, mkGenerators]) and
         (GetSchemaName = '') and (CompareText(rName.FSchema, 'public') = 0) then
        rName.FSchema := '';
      GenerateSelectMetaInfo(rName);
    end;
    if FDbCommandText = '' then
      Exit;
  end

  // generate stored proc call SQL command
  else if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
    FDbCommandText := '';
    if fiMeta in FOptions.FetchOptions.Items then begin
      oConnMeta.DecodeObjName(Trim(GetCommandText()), rName, Self, [doNormalize, doUnquote]);
      GetParams.Clear;
      oDesc := TADPhysPgSPDescriber.Create(Self, rName);
      try
        oDesc.CreateParams;
      finally
        ADFree(oDesc);
      end;
    end;
    if FDbCommandText = '' then begin
      oConnMeta.DecodeObjName(Trim(GetCommandText()), rName, Self, []);
      GenerateStoredProcCall(rName);
    end;
  end;

  // adjust SQL command
  GenerateLimitSelect();
  GenerateParamMarkers();

  FOidAsBlob := False;
  case PgConnection.FOidAsBlob of
  oabYes:
    FOidAsBlob := True;
  oabChoose:
    if (GetMetaInfoKind = mkNone) and
       oConnMeta.DecodeObjName(GetSourceObjectName, rName, Self,
                               [doNormalize, doUnquote, doNotRaise]) then
      FOidAsBlob := not ((CompareText(rName.FSchema, 'pg_catalog') = 0) or
                         (CompareText(rName.FSchema, 'information_schema') = 0) or
                         (CompareText(Copy(rName.FObject, 1, 3), 'pg_') = 0));
  end;

  FStmt := CreateStmt;
  FBaseStmt := FStmt;

  // describe params
  if GetParams.Count > 0 then
    CreateParamInfos;

  if not UseExecDirect then
    FStmt.PrepareSQL(FDbCommandText);
  FCursorCanceled := True;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.ADType2SQL(AType: TADDataType): Oid;
begin
  case AType of
  dtSByte,
  dtByte,
  dtInt16,
  dtUInt16:
    Result := SQL_INT2;
  dtInt32,
  dtUInt32:
    Result := SQL_INT4;
  dtInt64,
  dtUInt64:
    Result := SQL_INT8;
  dtSingle:
    Result := SQL_FLOAT4;
  dtDouble,
  dtExtended:
    Result := SQL_FLOAT8;
  dtCurrency:
    Result := SQL_CASH;
  dtBCD,
  dtFmtBcd:
    Result := SQL_NUMERIC;
  dtAnsiString,
  dtWideString:
    Result := SQL_VARCHAR;
  dtMemo,
  dtWideMemo,
  dtHMemo,
  dtWideHMemo:
    Result := SQL_TEXT;
  dtXML:
    Result := SQL_XML;
  dtByteString,
  dtBlob,
  dtHBFile:
    Result := SQL_BYTEA;
  dtHBlob:
    Result := SQL_OID;
  dtDate:
    Result := SQL_DATE;
  dtTime:
    Result := SQL_TIME;
  dtDateTime,
  dtDateTimeStamp:
    Result := SQL_TIMESTAMP;
  dtTimeIntervalFull,
  dtTimeIntervalYM,
  dtTimeIntervalDS:
    Result := SQL_INTERVAL;
  dtBoolean:
    Result := SQL_BOOL;
  dtCursorRef:
    Result := SQL_REFCURSOR;
  dtGUID:
    Result := SQL_UUID;
  else
    Result := SQL_UNKNOWN;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.SQL2ADColInfo(ASQLTypeOID: Oid; ASQLLen: LongWord;
  ASQLPrec, ASQLScale: Integer; out AType: TADDataType; var AAttrs: TADDataAttributes;
  out ALen: LongWord; out APrec, AScale: Integer; AFmtOpts: TADFormatOptions);
var
  oType: TPgType;
begin
  AType := dtUnknown;
  ALen := 0;
  APrec := 0;
  AScale := 0;
  Exclude(AAttrs, caFixedLen);
  Exclude(AAttrs, caBlobData);
  Include(AAttrs, caSearchable);

  case ASQLTypeOid of
  SQL_INT2,
  SQL_SMGR:
    AType := dtInt16;
  SQL_INT4:
    AType := dtInt32;
  SQL_INT8:
    AType := dtInt64;
  SQL_FLOAT4:
    AType := dtSingle;
  SQL_FLOAT8:
    AType := dtDouble;
  SQL_CASH:
    begin
      APrec := 19;
      AScale := 4;
      AType := dtCurrency;
    end;
  SQL_NUMERIC:
    begin
      APrec := ASQLPrec;
      AScale := ASQLScale;
      if (APrec > AFmtOpts.MaxBcdPrecision) or (AScale > AFmtOpts.MaxBcdScale) or
         // this information is not provided for SP
         ((APrec = 0) and (AScale = 0)) then
        AType := dtFmtBCD
      else
        AType := dtBCD;
    end;
  SQL_CHAR,
  SQL_BPCHAR,
  SQL_VARCHAR,
  SQL_NAME,
  SQL_ACLITEM,
  SQL_VOID:
    if ASQLLen <= AFmtOpts.MaxStringSize then begin
      ALen := ASQLLen;
{$IFNDEF AnyDAC_NATIVE_UTF8}
      if PgConnection.FConnection.Encoder.Encoding = ecUTF8 then
        AType := dtWideString
      else
{$ELSE}
      ALen := ASQLLen * C_AD_MaxUTF8Len;
{$ENDIF}
        AType := dtAnsiString;
      if paFixed in PgConnection.FConnection.TypesManager.Types[ASQLTypeOID].Attrs then
        Include(AAttrs, caFixedLen);
    end
    else begin
{$IFNDEF AnyDAC_NATIVE_UTF8}
      if PgConnection.FConnection.Encoder.Encoding = ecUTF8 then
        AType := dtWideMemo
      else
{$ENDIF}
        AType := dtMemo;
      Include(AAttrs, caBlobData);
    end;
  SQL_MACADDR,
  SQL_CIDR,
  SQL_INET,
  SQL_BIT:
    begin
      AType := dtByteString;
      ALen := ASQLLen;
      Include(AAttrs, caFixedLen);
    end;
  SQL_VARBIT:
    begin
      AType := dtByteString;
      ALen := ASQLLen;
    end;
  SQL_UNKNOWN:
    begin
      ALen := AFmtOpts.MaxStringSize;
{$IFNDEF AnyDAC_NATIVE_UTF8}
      if PgConnection.FConnection.Encoder.Encoding = ecUTF8 then
        AType := dtWideString
      else
{$ENDIF}
        AType := dtAnsiString;
    end;
  SQL_TEXT:
    begin
{$IFNDEF AnyDAC_NATIVE_UTF8}
      if PgConnection.FConnection.Encoder.Encoding = ecUTF8 then
        AType := dtWideMemo
      else
{$ENDIF}
        AType := dtMemo;
      Include(AAttrs, caBlobData);
    end;
  SQL_XML:
    begin
      AType := dtXML;
      Include(AAttrs, caBlobData);
    end;
  SQL_BYTEA:
    begin
      AType := dtBlob;
      Include(AAttrs, caBlobData);
    end;
  SQL_ANY:
    begin
      AType := dtByteString;
      ALen := ASQLLen;
    end;
  SQL_DATE:
    AType := dtDate;
  SQL_TIME,
  SQL_TIMETZ:
    begin
      AType := dtTime;
      if (ASQLScale >= 0) and (ASQLScale < 3) then
        AScale := C_AD_ScaleFactor[3 - ASQLScale];
    end;
  SQL_TIMESTAMP,
  SQL_TIMESTAMPTZ,
  SQL_RELTIME,
  SQL_ABSTIME:
    begin
      AType := dtDateTimeStamp;
      if (ASQLScale >= 0) and (ASQLScale < 3) then
        AScale := C_AD_ScaleFactor[3 - ASQLScale];
    end;
  SQL_INTERVAL:
    begin
      AType := dtTimeIntervalFull;
      if (ASQLScale >= 0) and (ASQLScale < 3) then
        AScale := C_AD_ScaleFactor[3 - ASQLScale];
    end;
  SQL_BOOL:
    AType := dtBoolean;
  SQL_OID:
    if FOidAsBlob and ([caROWID, caReadOnly] * AAttrs = []) then begin
      AType := dtHBlob;
      Include(AAttrs, caBlobData);
    end
    else
      AType := dtUInt32;
  SQL_XID,
  SQL_CID,
  SQL_REGPROC,
  SQL_REGPROCEDURE,
  SQL_REGOPER,
  SQL_REGOPERATOR,
  SQL_REGCLASS,
  SQL_REGTYPE:
    AType := dtUInt32;
  SQL_TID:
    begin
      AType := dtByteString;
      ALen := SizeOf(Tid);
      Include(AAttrs, caFixedLen);
    end;
  SQL_REFCURSOR:
    AType := dtCursorRef;
  SQL_UUID:
    AType := dtGUID;
  else
    oType := PgConnection.FConnection.TypesManager.Types[ASQLTypeOID];
    if paEnum in oType.Attrs then begin
{$IFNDEF AnyDAC_NATIVE_UTF8}
      if PgConnection.FConnection.Encoder.Encoding = ecUTF8 then
        AType := dtWideString
      else
{$ENDIF}
        AType := dtAnsiString;
      ALen := NAMEMAXLEN;
    end
    else
      AType := dtUnknown;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.CreateStmt: TPgStatement;
var
  oFmt: TADFormatOptions;
  oFtch: TADFetchOptions;
begin
  Result := TPgStatement.Create(PgConnection.FConnection, Self);
  oFmt := FOptions.FormatOptions;
  oFtch := FOptions.FetchOptions;

  Result.StrsTrim := oFmt.StrsTrim;
  Result.StrsEmpty2Null := oFmt.StrsEmpty2Null;

  if (oFtch.Mode in [fmManual, fmOnDemand]) and (oFtch.CursorKind <> ckDefault) and
     (GetCommandKind <> skStoredProcNoCrs) and not FOptions.ResourceOptions.DirectExecute then
    Result.RowsetSize := oFtch.ActualRowsetSize
  else
    Result.RowsetSize := -1;
  Result.WithHold := (GetCommandKind <> skSelectForLock) and
    not PgConnection.GetTransaction.Active or (oFtch.CursorKind = ckStatic);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.CreateParamInfos;
var
  i: Integer;
  oFmtOpts: TADFormatOptions;
  oParams: TADParams;
  oParam: TADParam;
  iPgParIndex, iPgParRef: Integer;
  oPgParam: TPgParam;
  eDestFldType: TFieldType;
  eAttrs: TADDataAttributes;
  iPrec, iScale: Integer;
  iLen: LongWord;
  pInfo: PADPgParInfoRec;
begin
  oFmtOpts := FOptions.FormatOptions;
  oParams := GetParams;

  iPgParIndex := 0;
  for i := 0 to oParams.Count - 1 do
    if oParams[i].ParamType in [ptUnknown, ptInput, ptInputOutput] then
      Inc(iPgParIndex);

  FStmt.Params.Count := iPgParIndex;
  SetLength(FBaseVecInfo.FParInfos, iPgParIndex);

  iPgParIndex := 0;
  for i := 0 to oParams.Count - 1 do begin
    oParam := oParams[i];
    if oParam.ParamType in [ptUnknown, ptInput, ptInputOutput] then begin
      pInfo := @FBaseVecInfo.FParInfos[iPgParIndex];
      case GetParams.BindMode of
      pbByName:   iPgParRef := iPgParIndex;
      pbByNumber: iPgParRef := oParam.Position - 1;
      else        iPgParRef := -1;
      end;
      if (iPgParRef >= 0) and (iPgParRef < FStmt.Params.Count) then begin
        oPgParam := FStmt.Params[iPgParRef];
        pInfo^.FPgParamIndex := iPgParRef;
        pInfo^.FParamIndex := i;

        if oParam.DataType = ftUnknown then
          ParTypeUnknownError(oParam);

        pInfo^.FSrcFieldType := oParam.DataType;
        oFmtOpts.ResolveFieldType('', oParam.DataType, oParam.ADDataType,
          oParam.Size, oParam.Precision, oParam.NumericScale, eDestFldType,
          pInfo^.FSrcSize, pInfo^.FSrcPrec, pInfo^.FSrcScale, pInfo^.FSrcDataType,
          pInfo^.FDestDataType, False);

        pInfo^.FOutSQLDataType := ADType2SQL(pInfo^.FDestDataType);
        eAttrs := [];
        SQL2ADColInfo(pInfo^.FOutSQLDataType, pInfo^.FSrcSize, pInfo^.FSrcPrec,
          pInfo^.FSrcScale, pInfo^.FOutDataType, eAttrs, iLen, iPrec, iScale, oFmtOpts);

        if oPgParam.DumpLabel = '' then
          oPgParam.DumpLabel := oParam.DisplayName;
        oPgParam.TypeOID := pInfo^.FOutSQLDataType;
        oPgParam.Size := pInfo^.FSrcSize;
        if pInfo^.FOutDataType in [dtWideString, dtWideMemo, dtXML, dtWideHMemo] then
          oPgParam.Encoding := ecUTF16
        else
          oPgParam.Encoding := ecANSI;
        pInfo^.FParamType := oParam.ParamType;
      end;
      Inc(iPgParIndex);
    end;
    FStmtParamsCount := iPgParIndex;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.DestroyParamInfos;
begin
  SetLength(FBaseVecInfo.FParInfos, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.CreateColInfos;
var
  lGetDSInfo: Boolean;
  i: Integer;
  oFmtOpts: TADFormatOptions;
  oFetchOpts: TADFetchOptions;
  oField: TPgField;
  sTableOid, sTablesOids: String;
  iAttrs: Integer;
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  j: Integer;
  V: Variant;
  iBaseTableOid: OId;
  pInfo: PADPgColInfoRec;
  oRow: TADDatSRow;

  procedure CreateRecInfo(ADsField: TPgField; AType: TPgType;
    var ARecInfo: TADPgRecInfoRec);

    function Def(AVal, ADef: Integer): Integer;
    begin
      if AVal <= 0 then
        Result := ADef
      else
        Result := AVal;
    end;

  var
    i, nFields: Integer;
    pInfo: PADPgColInfoRec;
    oMember: TPgMember;
    oField: TPgField;
  begin
    ARecInfo.FColIndex := 0;
    nFields := Length(AType.Members);
    SetLength(ARecInfo.FColInfos, nFields);

    for i := 0 to nFields - 1 do begin
      pInfo := @ARecInfo.FColInfos[i];
      oMember := AType.Members[i];
      oField := ADsField.Fields[i];

      pInfo^.FField := oField;
      pInfo^.FName := oMember.Name;
      pInfo^.FPos := i + 1;
      pInfo^.FSrcSQLDataType := oMember.TypeOid;
      pInfo^.FAttrs := oMember.Attrs;

      if [paArray, paRecord] * oMember.TypeRef.Attrs <> [] then begin
        if paRecord in oField.TypeRef.Attrs then
          pInfo^.FSrcDataType := dtRowRef
        else begin
          Include(pInfo^.FAttrs, caReadOnly);
          if oMember.TypeRef.IsFlatFixedArray then begin
            pInfo^.FSrcDataType := dtArrayRef;
            pInfo^.FLen := oMember.TypeRef.FixedLen;
          end
          else
            pInfo^.FSrcDataType := dtRowSetRef;
        end;

        GetMem(pInfo^.FRecInfo, SizeOf(TADPgRecInfoRec));
        ADFillChar(pInfo^.FRecInfo^, SizeOf(TADPgRecInfoRec), 0);
        CreateRecInfo(oField, oMember.TypeRef, pInfo^.FRecInfo^);
      end
      else
        SQL2ADColInfo(oMember.TypeOid, Def(oMember.Len, oField.Len),
          Def(oMember.Prec, oField.Prec), Def(oMember.Scale, oField.Scale),
          pInfo^.FSrcDataType, pInfo^.FAttrs, pInfo^.FLen, pInfo^.FPrec,
          pInfo^.FScale, oFmtOpts);
    end;
  end;

  procedure MapRecInfoTypes(var ARecInfo: TADPgRecInfoRec);
  var
    i: Integer;
    pInfo: PADPgColInfoRec;
  begin
    for i := 0 to Length(ARecInfo.FColInfos) - 1 do begin
      pInfo := @ARecInfo.FColInfos[i];
      // mapping data types
      if GetMetaInfoKind = mkNone then
        oFmtOpts.ResolveDataType(pInfo^.FName, pInfo^.FSrcDataType, pInfo^.FLen,
          pInfo^.FPrec, pInfo^.FScale, pInfo^.FDestDataType, pInfo^.FLen, True)
      else
        pInfo^.FDestDataType := pInfo^.FSrcDataType;

      if not CheckFetchColumn(pInfo^.FSrcDataType, pInfo^.FAttrs) then
        pInfo^.FField := nil;

      if pInfo^.FRecInfo <> nil then
        MapRecInfoTypes(pInfo^.FRecInfo^);
    end;
  end;

begin
  oFmtOpts := FOptions.FormatOptions;
  oFetchOpts := FOptions.FetchOptions;
  sTablesOids := '';
  iBaseTableOid := InvalidOid;
  lGetDSInfo := (GetMetaInfoKind = mkNone) and (fiMeta in oFetchOpts.Items) and
    PgConnection.FExtendedMetadata;

  SetLength(FBaseRecInfo.FColInfos, FStmt.Fields.Count);
  FBaseRecInfo.FColIndex := 0;
  for i := 0 to Length(FBaseRecInfo.FColInfos) - 1 do begin
    oField := FStmt.Fields[i];
    pInfo := @FBaseRecInfo.FColInfos[i];

    pInfo^.FField := oField;
    pInfo^.FName := oField.Name;
    pInfo^.FPos := i + 1;

    pInfo^.FTableOid := oField.TableOid;
    pInfo^.FTableCol := oField.TableCol;
    pInfo^.FSrcSQLDataType := oField.TypeOid;
    pInfo^.FInPK := False;
    pInfo^.FAttrs := [caAllowNull];
    if lGetDSInfo then begin
      if (pInfo^.FTableOid <> InvalidOid) and (pInfo^.FTableCol >= 0) then begin
        sTableOid := IntToStr(pInfo^.FTableOid);
        if Pos(sTableOid, sTablesOids) = 0 then begin
          if sTablesOids <> '' then
            sTablesOids := sTablesOids + ', ';
          sTablesOids := sTablesOids + sTableOid;
        end;
      end;
    end
    else begin
      if iBaseTableOid = InvalidOid then
        iBaseTableOid := pInfo^.FTableOid;
      if pInfo^.FTableCol = 0 then begin
        Include(pInfo^.FAttrs, caExpr);
        Include(pInfo^.FAttrs, caReadOnly);
      end
      else if (pInfo^.FTableCol > 0) and (iBaseTableOid = pInfo^.FTableOid) then
        Include(pInfo^.FAttrs, caBase);
    end;

    // system columns
    if pInfo^.FTableCol < 0 then begin
      Include(pInfo^.FAttrs, caReadOnly);
      case oField.TableCol of
      SelfItemPointerAttributeNumber:
        begin
          Include(pInfo^.FAttrs, caVolatile);
          pInfo^.FOriginColName := 'ctid';
        end;
      ObjectIdAttributeNumber:
        begin
          Include(pInfo^.FAttrs, caROWID);
          pInfo^.FOriginColName := 'oid';
        end;
      MinTransactionIdAttributeNumber:
        begin
          Include(pInfo^.FAttrs, caVolatile);
          pInfo^.FOriginColName := 'xmin';
        end;
      MinCommandIdAttributeNumber:
        begin
          Include(pInfo^.FAttrs, caVolatile);
          pInfo^.FOriginColName := 'cmin';
        end;
      MaxTransactionIdAttributeNumber:
        begin
          Include(pInfo^.FAttrs, caVolatile);
          pInfo^.FOriginColName := 'xmax';
        end;
      MaxCommandIdAttributeNumber:
        begin
          Include(pInfo^.FAttrs, caVolatile);
          pInfo^.FOriginColName := 'cmax';
        end;
      TableOidAttributeNumber:
        begin
          Include(pInfo^.FAttrs, caDefault);
          pInfo^.FOriginColName := 'tableoid';
        end;
      else
        ASSERT(False);
      end;
    end;

    if [paArray, paRecord] * oField.TypeRef.Attrs <> [] then begin
      if paRecord in oField.TypeRef.Attrs then
        pInfo^.FSrcDataType := dtRowRef
      else begin
        Include(pInfo^.FAttrs, caReadOnly);
        if oField.TypeRef.IsFlatFixedArray then begin
          pInfo^.FSrcDataType := dtArrayRef;
          pInfo^.FLen := oField.TypeRef.FixedLen;
        end
        else
          pInfo^.FSrcDataType := dtRowSetRef;
      end;

      GetMem(pInfo^.FRecInfo, SizeOf(TADPgRecInfoRec));
      ADFillChar(pInfo^.FRecInfo^, SizeOf(TADPgRecInfoRec), 0);
      CreateRecInfo(oField, oField.TypeRef, pInfo^.FRecInfo^);
    end
    else
      SQL2ADColInfo(pInfo^.FSrcSQLDataType, oField.Len, oField.Prec, oField.Scale,
        pInfo^.FSrcDataType, pInfo^.FAttrs, pInfo^.FLen, pInfo^.FPrec, pInfo^.FScale,
        oFmtOpts);
  end;

  // There are possible optimizations:
  // - if any non-system OID, then ask for domain -> LO
  // - if no system OID, then ask for PK
  if lGetDSInfo and (sTablesOids <> '') then begin
    GetConnection.CreateMetadata(oConnMeta);
    oView := oConnMeta.GetResultSetFields(sTablesOids);
    try
      for i := 0 to Length(FBaseRecInfo.FColInfos) - 1 do begin
        pInfo := @FBaseRecInfo.FColInfos[i];
        if (pInfo^.FTableOid <> InvalidOid) and (pInfo^.FTableCol >= 0) then begin
          j := oView.Find([{$IFNDEF AnyDAC_D6} Integer(pInfo^.FTableOid) {$ELSE} pInfo^.FTableOid {$ENDIF},
                           pInfo^.FTableCol], 'ATTRELID;ATTNUM', []);
          if j <> -1 then begin
            oRow := oView.Rows[j];
            pInfo^.FOriginSchemaName := oRow.AsString['NSPNAME'];
            pInfo^.FOriginTabName := oRow.AsString['RELNAME'];
            pInfo^.FOriginColName := oRow.AsString['ATTNAME'];
            V := oRow.ValueS['ATTRS'];
            if not VarIsNull(V) then begin
              iAttrs := V;
              pInfo^.FAttrs := pInfo^.FAttrs - [caAllowNull, caReadOnly, caROWID] +
                TADDataAttributes(Pointer(@iAttrs)^);
            end;
            if not VarIsNull(oRow.ValueS['INDISPRIMARY']) then
              pInfo^.FInPK := True;
            if paOID in PgConnection.FConnection.TypesManager.Types[pInfo^.FSrcSQLDataType].Attrs then
              PgConnection.AdjustOIDasBLOB(oRow.AsString['TYPNAME'], pInfo^.FOriginSchemaName,
                pInfo^.FSrcDataType, pInfo^.FAttrs);
          end;
        end;
      end;
    finally
      ADClearMetaView(oView, oFetchOpts);
    end;
  end;

  MapRecInfoTypes(FBaseRecInfo);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.DestroyColInfos;

  procedure DestroyRecInfo(var ARecInfo: TADPgRecInfoRec);
  var
    i: Integer;
    pInfo: PADPgColInfoRec;
  begin
    ARecInfo.FParentColName := '';
    for i := 0 to Length(ARecInfo.FColInfos) - 1 do begin
      pInfo := @ARecInfo.FColInfos[i];
      if pInfo^.FRecInfo <> nil then begin
        DestroyRecInfo(pInfo^.FRecInfo^);
        FreeMem(pInfo^.FRecInfo, SizeOf(TADPgRecInfoRec));
        pInfo^.FRecInfo := nil;
      end;
    end;
    SetLength(ARecInfo.FColInfos, 0);
  end;

begin
  DestroyRecInfo(FBaseRecInfo);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.CheckColInfos;
begin
  if (FStmt.Fields.Count > 0) and (Length(FBaseRecInfo.FColInfos) = 0) then
    CreateColInfos;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.SetParamValue(AFmtOpts: TADFormatOptions; AParam: TADParam;
  APgParam: TPgParam; ApInfo: PADPgParInfoRec; AArrIndex: Integer);
var
  pData: PADByteString;
  iSize, iSrcSize: LongWord;
//  i: Integer;

  procedure SetBlobData(AData: Pointer; ASize: LongWord);
  var
    oLargeObject: TPgLargeObject;
  begin
    oLargeObject := TPgLargeObject.Create(GetConnection.FConnection, False, Self);
    try
      oLargeObject.CreateObj;
      oLargeObject.Open;
      oLargeObject.Write(PByte(AData), ASize);
      APgParam.SetData(@oLargeObject.FObjOid, SizeOf(oLargeObject.FObjOid), True);
    finally
      ADFree(oLargeObject);
    end;
  end;

begin
  pData := nil;
  iSize := 0;

  // null
  if AParam.IsNulls[AArrIndex] then
    APgParam.SetData(nil, 0)

  // unbound array
  { TODO -cPG : unbound array }
//  else if ApInfo^.FOutDataType = dtRowSetRef then begin
//    APgParam.SetArrayBounds(0, AParam.ArraySize - 1);
//    try
//      for i := 0 to AParam.ArraySize - 1 do begin
//        APgParam.ArrayIndex := i;
//        SetParamValue(AFmtOpts, AParam, APgParam, ApInfo, i);
//      end;
//    finally
//      APgParam.ArrayIndex := -1;
//    end;
//  end

  // conversion is not required
  else if ApInfo^.FSrcDataType = ApInfo^.FOutDataType then begin

    if ApInfo^.FOutDataType = dtHBlob then begin
      AParam.GetBlobRawData(iSize, pData, AArrIndex);
      SetBlobData(pData, iSize);
    end
    // byte string data, then optimizing - get data directly
    else if ApInfo^.FOutDataType in [dtAnsiString, dtWideString, dtMemo, dtWideMemo,
                                     dtXML, dtBlob, dtByteString] then begin
      AParam.GetBlobRawData(iSize, pData, AArrIndex);
      APgParam.SetData(pData, iSize, True);
    end
    else begin
      iSize := AParam.GetDataLength(AArrIndex);
      FBuffer.Check(iSize);
      AParam.GetData(FBuffer.Ptr, AArrIndex);
      APgParam.SetData(FBuffer.Ptr, iSize);
    end;
  end

  // conversion is required
  else begin
    // calculate buffer size to move param values
    iSrcSize := AParam.GetDataLength(AArrIndex);
    FBuffer.Extend(iSrcSize, iSize, ApInfo^.FSrcDataType, ApInfo^.FOutDataType);

    // get, convert and set parameter value
    AParam.GetData(FBuffer.Ptr, AArrIndex);
    AFmtOpts.ConvertRawData(ApInfo^.FSrcDataType, ApInfo^.FOutDataType,
      FBuffer.Ptr, iSrcSize, FBuffer.FBuffer, FBuffer.Size, iSize,
      PgConnection.FConnection.Encoder);

    if ApInfo^.FOutDataType = dtHBlob then
      SetBlobData(FBuffer.Ptr, iSize)
    else
      APgParam.SetData(FBuffer.Ptr, iSize);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.SetParamValues(AArrIndex: Integer = 0);
var
  oFmtOpts: TADFormatOptions;
  oParams: TADParams;
  oParam: TADParam;
  oPgParam: TPgParam;
  i: Integer;
  pParInfo: PADPgParInfoRec;
begin
  oParams := GetParams;
  if oParams.Count = 0 then
    Exit;

  oFmtOpts := GetOptions.FormatOptions;
  for i := 0 to Length(FBaseVecInfo.FParInfos) - 1 do begin
    pParInfo := @FBaseVecInfo.FParInfos[i];
    oParam := oParams[pParInfo^.FParamIndex];
    if (pParInfo^.FPgParamIndex <> -1) and
       (oParam.DataType <> ftCursor) and
       (oParam.ParamType in [ptInput, ptInputOutput, ptUnknown]) then begin
      oPgParam := FStmt.Params[pParInfo^.FPgParamIndex];
      CheckParamMatching(oParam, pParInfo^.FSrcFieldType, pParInfo^.FParamType, 0);
      SetParamValue(oFmtOpts, oParam, oPgParam, pParInfo, AArrIndex);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.GetParamValues(AArrIndex: Integer = 0);
var
  oTab: TADDatSTable;
  i, iPar, iCrs: Integer;
  oParams: TADParams;
  oPar: TADParam;
  ePrevState: TADPhysCommandState;
  rState: TADDatSLoadState;
begin
  FStmt.DescribeFields;
  if (FStmt.Fields.Count = 0) or (FStmt.Fields[0].TypeOID = SQL_UNKNOWN) then
    Exit;

  oParams := GetParams;
  CheckColInfos;

  oTab := TADDatSTable.Create;
  oTab.Setup(FOptions);
  ePrevState := GetState;
  SetState(csOpen);
  try
    FStmt.Fetch;
    Define(oTab);
    if oTab.Columns.Count > 0 then begin
      oTab.BeginLoadData(rState, lmHavyFetching);
      try
        FetchRow(@FBaseRecInfo, oTab, nil);
        if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
          // for SP parameters are binded by name
          for i := 0 to oTab.Columns.Count - 1 do begin
            oPar := oParams.FindParam(oTab.Columns[i].Name);
            if (oPar <> nil) and (oPar.ParamType in [ptOutput, ptInputOutput, ptResult]) then
              oPar.Values[AArrIndex] := oTab.Rows[0].GetData(i);
          end;
        end
        else begin
          // for ... RETURNING ... {INTO ...} parameters are binded by position
          iPar := -1;
          for i := 0 to oParams.Count - 1 do
            if oParams[i].ParamType in [ptOutput, ptInputOutput, ptResult] then begin
              iPar := i;
              Break;
            end;
          if iPar <> -1 then
            for i := 0 to oTab.Columns.Count - 1 do begin
              while iPar < oParams.Count do begin
                oPar := oParams[iPar];
                Inc(iPar);
                if oPar.ParamType in [ptOutput, ptInputOutput] then begin
                  oPar.Values[AArrIndex] := oTab.Rows[0].GetData(i);
                  Break;
                end;
              end;
              if iPar >= oParams.Count then
                Break;
            end;
        end;
      finally
        oTab.EndLoadData(rState);
      end;
    end;

    if GetCommandKind = skStoredProcWithCrs then begin
      // grab cursor names
      iCrs := 0;
      for i := 0 to FStmt.Fields.Count - 1 do
        if FStmt.Fields[i].TypeOid = SQL_REFCURSOR then
          Inc(iCrs);
      SetLength(FCursors, iCrs);
      iCrs := 0;
      for i := 0 to FStmt.Fields.Count - 1 do
        if FStmt.Fields[i].TypeOid = SQL_REFCURSOR then begin
          FCursors[iCrs] := FStmt.Fields[i].GetAsString;
          Inc(iCrs);
        end;
    end;

  finally
    SetState(ePrevState);
    ADFree(oTab);
    DestroyColInfos;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.InternalUseStandardMetadata: Boolean;
begin
  Result := not PgConnection.FExtendedMetadata;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.BuildColumnName(ApRecInfo: PADPgRecInfoRec; ApColInfo: PADPgColInfoRec): String;
begin
  if (ApRecInfo^.FParentColName <> '') and
     (ApColInfo^.FField <> nil) and (ApColInfo^.FField.ParentField <> nil) and
     (paArray in ApColInfo^.FField.ParentField.TypeRef.Attrs) then
    if ApRecInfo^.FFixedLength > 0 then
      Result := ApRecInfo^.FParentColName + '[' + IntToStr(ApRecInfo^.FColIndex - 1) + ']'
    else
      Result := ApRecInfo^.FParentColName + '[]'
  else
    Result := ApColInfo^.FName;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean;
var
  pColInfo: PADPgColInfoRec;
  sParName: String;
begin
  Result := OpenBlocked;
  if ATabInfo.FSourceID = -1 then begin
    ATabInfo.FSourceName := GetCommandText;
    ATabInfo.FSourceID := 1;

    FCurrentRecInfo := @FBaseRecInfo;
    FCurrentRecInfo^.FColIndex := 0;
    FCurrentRecInfo^.FFixedLength := 0;
    FCurrentRecInfo^.FParentColName := '';
  end

  else begin
    pColInfo := @FCurrentRecInfo^.FColInfos[ATabInfo.FSourceID - 1];
    ATabInfo.FSourceName := pColInfo^.FName;
    ATabInfo.FSourceID := ATabInfo.FSourceID;
    sParName := BuildColumnName(FCurrentRecInfo, pColInfo);

    FInfoStack.Add(FCurrentRecInfo);
    FCurrentRecInfo := pColInfo^.FRecInfo;
    FCurrentRecInfo^.FColIndex := 0;
    FCurrentRecInfo^.FFixedLength := pColInfo^.FLen;
    FCurrentRecInfo^.FParentColName := sParName;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean;
var
  iCol: Integer;
  pColInfo: PADPgColInfoRec;
begin
  if (FCurrentRecInfo^.FFixedLength > 0) and
       (FCurrentRecInfo^.FColIndex < FCurrentRecInfo^.FFixedLength * Length(FCurrentRecInfo^.FColInfos)) or
     (FCurrentRecInfo^.FFixedLength = 0) and
       (FCurrentRecInfo^.FColIndex < Length(FCurrentRecInfo^.FColInfos)) then begin
    iCol := FCurrentRecInfo^.FColIndex mod Length(FCurrentRecInfo^.FColInfos);
    pColInfo := @FCurrentRecInfo^.FColInfos[iCol];

    AColInfo.FSourceName := BuildColumnName(FCurrentRecInfo, pColInfo);
    AColInfo.FSourceID := pColInfo^.FPos;
    AColInfo.FSourceType := pColInfo^.FSrcDataType;
    if (pColInfo^.FField <> nil) and
       ([paRecord, paEnum] * pColInfo^.FField.TypeRef.Attrs <> []) then
      AColInfo.FSourceTypeName := pColInfo^.FField.TypeRef.Name
    else
      AColInfo.FSourceTypeName := '';
    AColInfo.FOriginTabName.FSchema := pColInfo^.FOriginSchemaName;
    AColInfo.FOriginTabName.FObject := pColInfo^.FOriginTabName;
    AColInfo.FOriginColName := pColInfo^.FOriginColName;
    AColInfo.FType := pColInfo^.FDestDataType;
    AColInfo.FLen := pColInfo^.FLen;
    AColInfo.FPrec := pColInfo^.FPrec;
    AColInfo.FScale := pColInfo^.FScale;
    AColInfo.FAttrs := pColInfo^.FAttrs;
    AColInfo.FForceAddOpts := [];
    if pColInfo^.FInPK then
      Include(AColInfo.FForceAddOpts, coInKey);

    Inc(FCurrentRecInfo^.FColIndex);
    Result := True;
  end
  else begin
    if FInfoStack.Count > 0 then begin
      FCurrentRecInfo := PADPgRecInfoRec(FInfoStack.Last);
      FInfoStack.Delete(FInfoStack.Count - 1);
    end;
    Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.ExecuteBatchInsert(ATimes, AOffset: Integer;
  var ACount: TADCounter);
var
  sBatchSQL: String;
  iBatchSQLPos: Integer;
  pParInfo: PADPgParInfoRec;

  procedure W(const AStr: String);
  var
    iLen: Integer;
  begin
    iLen := Length(AStr);
    if iBatchSQLPos + iLen > Length(sBatchSQL) then
      SetLength(sBatchSQL, Length(sBatchSQL) * 2);
    Move(PChar(AStr)^, (PChar(sBatchSQL) + iBatchSQLPos)^, iLen * SizeOf(Char));
    Inc(iBatchSQLPos, iLen);
  end;

  procedure C(AIndex, ACount: Integer);
  begin
    if iBatchSQLPos + ACount > Length(sBatchSQL) then
      SetLength(sBatchSQL, Length(sBatchSQL) * 2);
    Move((PChar(FDBCommandText) + AIndex)^, (PChar(sBatchSQL) + iBatchSQLPos)^, ACount * SizeOf(Char));
    Inc(iBatchSQLPos, ACount);
  end;

var
  oFmtOpts: TADFormatOptions;
  oParams: TADParams;
  oParam: TADParam;
  oPgParam: TPgParam;
  oSrcPgParam: TPgParam;

  i, j: Integer;
  lIsDollar: Boolean;
  lIsParam: Boolean;
  iDollarPos: Integer;
  aParamsPos: array of Integer;

  iBatchParamInd: Integer;
  iBatchSize: Integer;
begin
  oParams := GetParams;
  iBatchSize := ATimes - AOffset;

  if not CheckArray(iBatchSize) then begin
    lIsDollar := False;
    lIsParam := False;
    iDollarPos := 1;
    i := FSQLValuesPos;
    j := 1;
    SetLength(aParamsPos, oParams.Count * 2 + 2);
    aParamsPos[0] := FSQLValuesPos + 5;
    while i <= FSQLValuesPosEnd do begin
      case FDBCommandText[i] of
      '$':
        begin
          lIsDollar := not lIsDollar;
          if lIsDollar then
            iDollarPos := i;
        end;
      '0'..'9':
        lIsParam := lIsDollar;
      else
        if lIsParam then begin
          aParamsPos[j] := iDollarPos - 2;
          aParamsPos[j + 1] := i - 1;
          Inc(j, 2);
        end;
        lIsDollar := False;
        lIsParam := False;
      end;
      Inc(i);
    end;
    ASSERT(j = Length(aParamsPos) - 1);
    aParamsPos[j] := FSQLValuesPosEnd - 1;

    iBatchSQLPos := 0;
    iBatchParamInd := 1;
    SetLength(sBatchSQL, 16384);
    C(0, FSQLValuesPos + 5);
    for j := 0 to iBatchSize - 1 do begin
      if j > 0 then
        W(',');
      C(aParamsPos[0], aParamsPos[1] - aParamsPos[0] + 1);
      for i := 1 to Length(aParamsPos) div 2 - 1 do begin
        W('$');
        W(IntToStr(iBatchParamInd));
        C(aParamsPos[i * 2], aParamsPos[i * 2 + 1] - aParamsPos[i * 2] + 1);
        Inc(iBatchParamInd);
      end;
    end;
    C(FSQLValuesPosEnd, Length(FDBCommandText) - FSQLValuesPosEnd);
    SetLength(sBatchSQL, iBatchSQLPos);

    FStmt.Params.Count := FStmtParamsCount * iBatchSize;
    for i := 0 to iBatchSize - 1 do
      for j := 0 to FStmtParamsCount - 1 do begin
        oSrcPgParam := FStmt.Params[j];
        oPgParam := FStmt.Params[i * oParams.Count + j];

        oPgParam.TypeOid := oSrcPgParam.TypeOid;
        oPgParam.Encoding := oSrcPgParam.Encoding;
        oPgParam.Size := oSrcPgParam.Size;
        oPgParam.DumpLabel := Format('%s [%d]', [oSrcPgParam.DumpLabel, j]);
      end;
    FStmt.PrepareSQL(sBatchSQL);
  end;

  oFmtOpts := GetOptions.FormatOptions;
  for i := 0 to iBatchSize - 1 do
    for j := 0 to Length(FBaseVecInfo.FParInfos) - 1 do begin
      oParam := oParams[j];
      pParInfo := @FBaseVecInfo.FParInfos[j];
      oPgParam := FStmt.Params[i * FStmtParamsCount + pParInfo^.FPgParamIndex];
      SetParamValue(oFmtOpts, oParam, oPgParam, pParInfo, i + AOffset);
    end;
  FStmt.Execute;
  Inc(ACount, iBatchSize);
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.CheckArray(ASize: Integer): Boolean;
begin
  Result := (ASize = 1) and (FPreparedBatchSize <= 1) or
            (ASize = FPreparedBatchSize);
  if not Result then begin
    FStmt.Unprepare;
    FPreparedBatchSize := ASize;
    if ASize = 1 then begin
      FStmt.Params.Count := FStmtParamsCount;
      FStmt.PrepareSQL(FDBCommandText);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.DoExecute(ATimes, AOffset: Integer; var ACount: TADCounter);
var
  i: Integer;
  iTimes: Integer;
  iCount: TADCounter;
begin
  if ATimes - AOffset > 1 then begin
    if (PgConnection.FServerVersion >= svPGSQL080100) and
       (GetCommandKind in [skInsert, skMerge]) and (FSQLValuesPos > 0) then
      ExecuteBatchInsert(ATimes, AOffset, ACount)

    else begin
      if ATimes > GetParams.ArraySize then
        iTimes := GetParams.ArraySize
      else
        iTimes := ATimes;
      for i := AOffset to iTimes - 1 do begin
        iCount := 0;
        try
          DoExecute(i + 1, i, iCount);
        finally
          Inc(ACount, iCount);
        end;
        CheckExact(ATimes = 1, 1, 0, iCount, False);
      end;
    end;
  end

  else begin
    CheckArray(1);
    SetParamValues(AOffset);
    try
      try
        if UseExecDirect then
          FStmt.ExecuteDirect(FDbCommandText)
        else
          FStmt.Execute;
      except
        on E: EPgNativeException do begin
          E.Errors[0].RowIndex := AOffset;
          raise;
        end;
      end;
    finally
      Inc(ACount, FStmt.RowsAffected);
    end;
    GetParamValues;
    FStmt.Close;

    if GetCommandKind = skSetSchema then
      PgConnection.UpdateCurrentMeta;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.InternalExecute(ATimes: LongInt; AOffset: LongInt;
  var ACount: TADCounter);
begin
  ACount := 0;
  DoExecute(ATimes, AOffset, ACount);
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.InternalOpen: Boolean;
begin
  if not GetNextRecordSet then
    FActiveCrs := -1;

  if GetMetaInfoKind = mkProcArgs then begin
    Result := True;
    Exit;
  end
  else if (GetMetaInfoKind <> mkNone) and (FDbCommandText = '') then begin
    Result := False;
    Exit;
  end
  else if not FCursorCanceled then begin
    Result := True;
    Exit;
  end;

  if GetMetaInfoKind = mkProcs then begin
    FMetaProcName := '';
    FMetaProcOverload := 0;
  end;

  SetParamValues;
  if GetCommandKind = skStoredProcWithCrs then begin
    if FActiveCrs = - 1 then begin
      FActiveCrs := 0;
      if UseExecDirect then
        FStmt.ExecuteDirect(FDbCommandText)
      else
        FStmt.Execute;
      GetParamValues;
    end;
    ASSERT(FActiveCrs < Length(FCursors));
    FStmt := CreateStmt;
    try
      FStmt.PrepareCursor(FCursors[FActiveCrs]);
    except
      ADFreeAndNil(FStmt);
      raise;
    end;
  end;

  try
    if UseExecDirect then
      FStmt.ExecuteDirect(FDbCommandText)
    else
      FStmt.Execute;
    FStmt.DescribeFields;
    CheckColInfos;
    Result := Length(FBaseRecInfo.FColInfos) > 0;
    FCursorCanceled := False;
  except
    FCursorCanceled := True;
    InternalClose;
    raise;
  end;

  if GetCommandKind = skSetSchema then
    PgConnection.UpdateCurrentMeta;
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.InternalNextRecordSet: Boolean;
begin
  if FActiveCrs < 0 then begin
    Result := False;
    Exit;
  end;
  if FActiveCrs < Length(FCursors) then
    Inc(FActiveCrs);
  if FActiveCrs < Length(FCursors) then
    Result := InternalOpen
  else begin
    InternalClose;
    Result := False;
    FCursorCanceled := True;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.FetchRow(ApRecInfo: PADPgRecInfoRec;
  ATable: TADDatSTable; AParentRow: TADDatSRow);
var
  oRow: TADDatSRow;
  oCol: TADDatSColumn;
  oFmtOpts: TADFormatOptions;
  pColInfo: PADPgColInfoRec;
  j: Integer;
  lMetadata: Boolean;

  procedure ProcessColumn(AColIndex: Integer; ARow: TADDatSRow;
    ApInfo: PADPgColInfoRec);
  var
    pData: Pointer;
    iSize, iDestSize: LongWord;
    iOid: Integer;
    oLargeObject: TPgLargeObject;
    iLBound, iHBound, i: Integer;
    oNestedTable: TADDatSTable;
    oNestedRow: TADDatSRow;
    lClosed: Boolean;
  begin
    pData := nil;
    iSize := 0;
    if (ApInfo^.FField = nil) or not CheckFetchColumn(ApInfo^.FSrcDataType, ApInfo^.FAttrs) then
      Exit

    // null
    else if not ApInfo^.FField.GetData(pData, iSize, True) then
      ARow.SetData(AColIndex, nil, 0)

    // composite type
    else if ApInfo^.FDestDataType = dtRowRef then begin
      oNestedTable := ARow.Table.Columns[AColIndex].NestedTable;
      FetchRow(ApInfo^.FRecInfo, oNestedTable, ARow);
    end

    // unbound array
    else if ApInfo^.FDestDataType = dtRowSetRef then begin
      ApInfo^.FField.GetArrayBounds(iLBound, iHBound, lClosed);
      if iHBound - iLBound >= 0 then begin
        oNestedTable := ARow.Table.Columns[AColIndex].NestedTable;
        try
          for i := iLBound to iHBound do begin
            ApInfo^.FField.ArrayIndex := i;
            FetchRow(ApInfo^.FRecInfo, oNestedTable, ARow);
          end;
          if lClosed then begin
            ApInfo^.FField.ArrayIndex := 0;
            FetchRow(ApInfo^.FRecInfo, oNestedTable, ARow);
          end;
        finally
          ApInfo^.FField.ArrayIndex := -1;
        end;
      end;
    end

    // constrained array
    else if ApInfo^.FDestDataType = dtArrayRef then begin
      ApInfo^.FField.GetArrayBounds(iLBound, iHBound, lClosed);
      if iHBound - iLBound >= 0 then begin
        oNestedTable := ARow.Table.Columns[AColIndex].NestedTable;
        oNestedRow := oNestedTable.NewRow(False);
        try
          for i := iLBound to iHBound do begin
            ApInfo^.FField.ArrayIndex := i;
            ProcessColumn(i, oNestedRow, @ApInfo^.FRecInfo.FColInfos[0]);
          end;
          ApInfo^.FField.ArrayIndex := -1;
          oNestedRow.ParentRow := ARow;
          oNestedTable.Rows.Add(oNestedRow);
        except
          ApInfo^.FField.ArrayIndex := -1;
          ADFree(oNestedRow);
          raise;
        end;
        ARow.Fetched[AColIndex] := True;
      end;
    end

    // conversion is not required
    else if ApInfo^.FSrcDataType = ApInfo^.FDestDataType then
      if ApInfo^.FDestDataType = dtHBlob then begin
        if ApInfo^.FField.GetData(@iOid, iSize) then begin
          oLargeObject := TPgLargeObject.Create(GetConnection.FConnection,
            True, Self, iOid);
          try
            oLargeObject.Open;
            iSize := oLargeObject.Len;
            pData := ARow.BeginDirectWriteBlob(AColIndex, iSize);
            try
              if iSize > 0 then
                oLargeObject.Read(pData, iSize);
            finally
              ARow.EndDirectWriteBlob(AColIndex, iSize);
            end;
          finally
            ADFree(oLargeObject);
          end;
        end
      end
      else
      if ApInfo^.FDestDataType in [dtAnsiString, dtWideString, dtMemo, dtWideMemo,
                                   dtXML, dtBlob, dtByteString] then
        ARow.SetData(AColIndex, pData, iSize)
      else begin
        FBuffer.Check(iSize);
        ApInfo^.FField.GetData(FBuffer.FBuffer, iSize);
        ARow.SetData(AColIndex, FBuffer.Ptr, iSize);
      end

    // conversion is required
    else begin
      FBuffer.Check((iSize + 1) * SizeOf(WideChar));
      ApInfo^.FField.GetData(FBuffer.FBuffer, iSize);
      iDestSize := 0;
      oFmtOpts.ConvertRawData(ApInfo^.FSrcDataType, ApInfo^.FDestDataType,
        FBuffer.Ptr, iSize, FBuffer.FBuffer, FBuffer.Size, iDestSize,
        PgConnection.FConnection.Encoder);
      ARow.SetData(AColIndex, FBuffer.Ptr, iDestSize);
    end;
  end;

  procedure ProcessMetaColumn(AColIndex: Integer; ARow: TADDatSRow;
    ApInfo: PADPgColInfoRec);
  var
    pData: Pointer;
    iSize, iDestSize: Longword;
  begin
    pData := nil;
    iSize := 0;

    if AColIndex = 0 then
      ARow.SetData(0, ATable.Rows.Count + 1)

    else if not ApInfo^.FField.GetData(pData, iSize, True) then
      ARow.SetData(AColIndex, nil, 0)

    else if ApInfo^.FDestDataType in [dtAnsiString, dtWideString, dtMemo, dtWideMemo,
                                      dtXML, dtBlob, dtByteString] then begin
      if iSize > ATable.Columns[AColIndex].Size then
        iSize := ATable.Columns[AColIndex].Size;
      if ApInfo^.FDestDatatype in C_AD_AnsiTypes then begin
        FBuffer.Check(iSize * SizeOf(WideChar));
        oFmtOpts.ConvertRawData(dtAnsiString, dtWideString,
          pData, iSize, FBuffer.FBuffer, FBuffer.Size, iDestSize,
          PgConnection.FConnection.Encoder);
        ARow.SetData(AColIndex, FBuffer.Ptr, iDestSize);
      end
      else
        ARow.SetData(AColIndex, pData, iSize);
    end
    else begin
      FBuffer.Check(iSize);
      ApInfo^.FField.GetData(FBuffer.FBuffer, iSize, False);
      iDestSize := 0;
      if ApInfo^.FDestDataType in [dtUInt16, dtUInt32, dtInt16, dtInt32,
                                   dtSingle, dtDouble, dtBCD, dtFmtBCD] then
        oFmtOpts.ConvertRawData(ApInfo^.FSrcDataType, ATable.Columns[AColIndex].DataType,
          FBuffer.Ptr, iSize, FBuffer.FBuffer, FBuffer.Size, iDestSize,
          PgConnection.FConnection.Encoder);
      ARow.SetData(AColIndex, FBuffer.Ptr, iDestSize);
    end;
  end;

begin
  oFmtOpts := FOptions.FormatOptions;
  oRow := ATable.NewRow(False);
  lMetadata := GetMetaInfoKind <> mkNone;
  try
    for j := 0 to ATable.Columns.Count - 1 do begin
      oCol := ATable.Columns[j];
      if oCol.SourceID > 0 then begin
        pColInfo := @ApRecInfo^.FColInfos[oCol.SourceID - 1];
        if lMetadata then
          ProcessMetaColumn(j, oRow, pColInfo)
        else
          ProcessColumn(j, oRow, pColInfo);
      end;
    end;
    if AParentRow <> nil then begin
      oRow.ParentRow := AParentRow;
      AParentRow.Fetched[ATable.Columns.ParentCol] := True;
    end;
    ATable.Rows.Add(oRow);
  except
    ADFree(oRow);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.FetchTableFieldsRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
var
  oRow: TADDatSRow;
  eType: TADDataType;
  eAttrs: TADDataAttributes;
  iTypeOid: Oid;
  iAttrs: Word;
  iLen: LongWord;
  iPrec: Integer;
  iScale: Integer;
begin
  FetchRow(@FBaseRecInfo, ATable, AParentRow);
  oRow := ATable.Rows[ATable.Rows.Count - 1];
  iAttrs := oRow.GetData(8);
  eAttrs := TADDataAttributes(Pointer(@iAttrs)^);
  iTypeOid := LongWord(oRow.GetData(6));
  SQL2ADColInfo(iTypeOid, oRow.GetData(11), oRow.GetData(9),
    oRow.GetData(10), eType, eAttrs, iLen, iPrec, iScale, FOptions.FormatOptions);
  if paOID in PgConnection.FConnection.TypesManager.Types[iTypeOid].Attrs then
    PgConnection.AdjustOIDasBLOB(oRow.GetData(7), oRow.GetData(2), eType, eAttrs);
  oRow.SetData(6, Integer(eType));
  oRow.SetData(8, PWord(@eAttrs)^);
  oRow.SetData(9, iPrec);
  oRow.SetData(10, iScale);
  oRow.SetData(11, Integer(iLen));
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.FetchProcsRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
var
  sProcName: String;
  oRow: TADDatSRow;
begin
  FetchRow(@FBaseRecInfo, ATable, AParentRow);
  oRow := ATable.Rows[ATable.Rows.Count - 1];
  sProcName := oRow.GetData(4);
  if sProcName = FMetaProcName then
    Inc(FMetaProcOverload)
  else begin
    FMetaProcName := sProcName;
    FMetaProcOverload := 0;
  end;
  if FMetaProcOverload > 0 then
    oRow.SetData(5, FMetaProcOverload);
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.FetchSPParamRows(ATable: TADDatSTable; AParentRow: TADDatSRow): Integer;
var
  iRecNo: Integer;
  i: Integer;
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
  oProcArgs: TADProcArgRecs;
  oDesc: TADPhysPgSPDescriber;
  pArg: PADProcArgRec;

  procedure AddParam(const AParamName: String; ATypeOID: Integer; AParamType: TParamType);
  var
    oRow: TADDatSRow;
    eType: TADDataType;
    eAttrs: TADDataAttributes;
    iPrec: Integer;
    iScale: Integer;
    uiLen: LongWord;
  begin
    eType := dtUnknown;
    iPrec := 0;
    iScale := 0;
    eAttrs := [];

    SQL2ADColInfo(ATypeOID, 0, 0, 0, eType, eAttrs, uiLen, iPrec,
      iScale, FOptions.FormatOptions);

    oRow := ATable.NewRow(False);
    oRow.SetData(0, iRecNo);
    oRow.SetData(1, rName.FCatalog);
    oRow.SetData(2, rName.FSchema);
    oRow.SetData(3, nil, 0);
    oRow.SetData(4, rName.FObject);
    oRow.SetData(5, GetOverload);
    oRow.SetData(6, AParamName);
    oRow.SetData(7, Smallint(iRecNo));
    oRow.SetData(8, Smallint(AParamType));
    oRow.SetData(9, Smallint(eType));
    oRow.SetData(10, nil, 0);
    oRow.SetData(11, PWord(@eAttrs)^);
    oRow.SetData(12, 0);
    oRow.SetData(13, 0);
{$IFDEF AnyDAC_D6Base}
    oRow.SetData(14, uiLen);
{$ELSE}
    oRow.SetData(14, Integer(uiLen));
{$ENDIF}
    ATable.Rows.Add(oRow);
    Inc(iRecNo);
  end;

begin
  FConnection.CreateMetadata(oConnMeta);
  oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self, [doNormalize, doUnquote]);
  CheckMetaInfoParams(rName);
  oDesc := TADPhysPgSPDescriber.Create(Self, rName);
  try
    oDesc.ReadProcArgs(oProcArgs);
  finally
    ADFree(oDesc);
  end;
  iRecNo := 0;
  for i := 0 to Length(oProcArgs) - 1 do begin
    pArg := @oProcArgs[i];
    AddParam(pArg^.FName, pArg^.FTypeOid, pArg^.FParamType);
  end;
  Result := Length(oProcArgs);
end;

{-------------------------------------------------------------------------------}
function TADPhysPgCommand.InternalFetchRowSet(ATable: TADDatSTable; AParentRow: TADDatSRow;
  ARowsetSize: LongWord): LongWord;
var
  i: LongWord;
begin
  Result := 0;
  if GetMetaInfoKind = mkProcArgs then
    Result := FetchSPParamRows(ATable, AParentRow)
  else
    for i := 1 to ARowsetSize do begin
      if not FStmt.Fetch then
        Break;
      case GetMetaInfoKind of
      mkTableFields: FetchTableFieldsRow(ATable, AParentRow);
      mkProcs:       FetchProcsRow(ATable, AParentRow);
      else           FetchRow(@FBaseRecInfo, ATable, AParentRow);
      end;
      Inc(Result);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.InternalAbort;
begin
  TADPhysPgConnection(FConnectionObj).FConnection.Abort;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.InternalClose;
begin
  if (FStmt <> nil) and not FCursorCanceled then begin
    FCursorCanceled := True;
    DestroyColInfos;
    FStmt.Close;
  end;
  if FStmt <> FBaseStmt then begin
    ADFree(FStmt);
    FStmt := FBaseStmt;
  end;
  if not GetNextRecordSet then begin
    if FBaseStmt <> nil then
      FBaseStmt.Close;
    FActiveCrs := -1;
  end;
  FInfoStack.Clear;
  FCurrentRecInfo := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysPgCommand.InternalUnprepare;
begin
  FPreparedBatchSize := 0;
  if FStmt = nil then
    Exit;
  FStmt.Unprepare;
  DestroyParamInfos;
  DestroyColInfos;
  ADFreeAndNil(FStmt);
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterDriverClass(TADPhysPgDriver);

end.
