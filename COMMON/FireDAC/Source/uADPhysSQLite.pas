{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                 FireDAC SQLite driver                 }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysSQLite"'}

unit uADPhysSQLite;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Classes,
  uADStanIntf, uADStanOption, uADStanUtil,
  uADPhysManager, uADPhysSQLiteWrapper;

type
  TADPhysSQLiteDriverLink = class;
  TADSQLiteBackup = class;
  TADSQLiteValidate = class;
  TADSQLiteSecurity = class;
  TADSQLiteFunction = class;
  TADSQLiteCollation = class;
  TADSQLiteRTree = class;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADPhysSQLiteDriverLink = class(TADPhysDriverLink)
  protected
    function GetBaseDriverID: String; override;
  end;

  TADSQLiteService = class (TADPhysDriverService)
  private
    function GetDriverLink: TADPhysSQLiteDriverLink;
    procedure SetDriverLink(const AValue: TADPhysSQLiteDriverLink);
  published
    property DriverLink: TADPhysSQLiteDriverLink read GetDriverLink write SetDriverLink;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADSQLiteBackup = class (TADSQLiteService)
  private
    FDestPassword: String;
    FOnProgress: TADPhysServiceProgressEvent;
    FDestDatabase: String;
    FPassword: String;
    FDatabase: String;
    FDestMode: TSQLiteDatabaseMode;
    FPagesPerStep: Integer;
    FWaitForLocks: Boolean;
    FDestCatalog: String;
    FCatalog: String;
    FBackup: TSQLiteBackup;
    FBusyTimeout: Integer;
    FDestDatabaseObj: TSQLiteDatabase;
    FDatabaseObj: TSQLiteDatabase;
    procedure SetDatabase(const AValue: String);
    procedure SetDatabaseObj(const AValue: TSQLiteDatabase);
    procedure SetDestDatabase(const AValue: String);
    procedure SetDestDatabaseObj(const AValue: TSQLiteDatabase);
    function GetPageCount: Integer;
    function GetRemaining: Integer;
  protected
    procedure InternalExecute; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Backup;
    property Remaining: Integer read GetRemaining;
    property PageCount: Integer read GetPageCount;

    property DatabaseObj: TSQLiteDatabase read FDatabaseObj write SetDatabaseObj;
    property DestDatabaseObj: TSQLiteDatabase read FDestDatabaseObj write SetDestDatabaseObj;

  published
    property PagesPerStep: Integer read FPagesPerStep write FPagesPerStep default -1;
    property WaitForLocks: Boolean read FWaitForLocks write FWaitForLocks default True;
    property BusyTimeout: Integer read FBusyTimeout write FBusyTimeout default 10000;

    property Database: String read FDatabase write SetDatabase;
    property Catalog: String read FCatalog write FCatalog;
    property Password: String read FPassword write FPassword;

    property DestDatabase: String read FDestDatabase write SetDestDatabase;
    property DestCatalog: String read FDestCatalog write FDestCatalog;
    property DestMode: TSQLiteDatabaseMode read FDestMode write FDestMode default smCreate;
    property DestPassword: String read FDestPassword write FDestPassword;
    property OnProgress: TADPhysServiceProgressEvent read FOnProgress write FOnProgress;
  end;

  TADSQLiteValidateAction = (saCheckOnly, saSweep, saAnalyze);
  TADSQLiteValidateOption = (voCheckIndexes);
  TADSQLiteValidateOptions = set of TADSQLiteValidateOption;
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADSQLiteValidate = class (TADSQLiteService)
  private
    FAction: TADSQLiteValidateAction;
    FDatabase: String;
    FMaxErrors: Integer;
    FOptions: TADSQLiteValidateOptions;
    FTable, FIndex: String;
    FOnProgress: TADPhysServiceProgressEvent;
    FPassword: String;
    FLastStatus: Boolean;
  protected
    procedure InternalExecute; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CheckOnly: Boolean;
    procedure Sweep;
    procedure Analyze(const ATable: String = ''; const AIndex: String = '');
  published
    property Database: String read FDatabase write FDatabase;
    property Password: String read FPassword write FPassword;
    property MaxErrors: Integer read FMaxErrors write FMaxErrors default -1;
    property Options: TADSQLiteValidateOptions read FOptions write FOptions default [voCheckIndexes];
    property OnProgress: TADPhysServiceProgressEvent read FOnProgress write FOnProgress;
  end;

  TADSQLiteSecurityAction = (saSetPassword, saRemovePassword, saChangePassword,
    saCheckEncryption);
  TADSQLiteSecurityOptions = set of (soSetLargeCache);
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADSQLiteSecurity = class (TADSQLiteService)
  private
    FAction: TADSQLiteSecurityAction;
    FDatabase: String;
    FToPassword: String;
    FPassword: String;
    FEncryption: String;
    FOptions: TADSQLiteSecurityOptions;
  protected
    procedure InternalExecute; override;
  public
    procedure SetPassword;
    procedure RemovePassword;
    procedure ChangePassword;
    function CheckEncryption: String;
  published
    property Database: String read FDatabase write FDatabase;
    property Password: String read FPassword write FPassword;
    property ToPassword: String read FToPassword write FToPassword;
    property Options: TADSQLiteSecurityOptions read FOptions write FOptions default [];
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADSQLiteFunction = class (TADSQLiteService)
  private
    FArgumentsCount: Integer;
    FOnFinalize: TSQLiteFunctionFinalizeEvent;
    FOnCalculate: TSQLiteFunctionCalculateEvent;
    FAggregated: Boolean;
    FFunctionName: String;
    FFunction: TSQLiteFunction;
    procedure SetAggregated(const AValue: Boolean);
    procedure SetArgumentsCount(const AValue: Integer);
    procedure SetFunctionName(const AValue: String);
    procedure SetOnCalculate(const AValue: TSQLiteFunctionCalculateEvent);
    procedure SetOnFinalize(const AValue: TSQLiteFunctionFinalizeEvent);
  protected
    function GetActualActive: Boolean; override;
    procedure InternalUninstall; override;
    procedure InternalInstall; override;
  published
    property Active;
    property FunctionName: String read FFunctionName write SetFunctionName;
    property ArgumentsCount: Integer read FArgumentsCount write SetArgumentsCount default 0;
    property Aggregated: Boolean read FAggregated write SetAggregated default False;
    property OnCalculate: TSQLiteFunctionCalculateEvent read FOnCalculate write SetOnCalculate;
    property OnFinalize: TSQLiteFunctionFinalizeEvent read FOnFinalize write SetOnFinalize;
  end;

  TADSQLiteCollationKind = (scCompareString, scCustomUTF8, scCustomUTF16);
  TADSQLiteCollationFlag = (sfLingIngoreCase, sfLingIgnoreDiacritic,
    sfIgnoreCase, sfIgnoreKanatype, sfIgnoreNonSpace, sfIgnoreSymbols,
    sfIgnoreWidth, sfLingCasing, sfDigitAsNumbers, sfStringSort);
  TADSQLiteCollationFlags = set of TADSQLiteCollationFlag;
{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADSQLiteCollation = class (TADSQLiteService)
  private
    FCollationName: String;
    FLocale: TADLocalID;
    FCollationKind: TADSQLiteCollationKind;
    FFlags: TADSQLiteCollationFlags;
    FCollation: TSQLiteCollation;
    FOnCompare: TSQLiteCollationEvent;
    procedure SetCollationKind(const AValue: TADSQLiteCollationKind);
    procedure SetCollationName(const AValue: String);
    procedure SetFlags(const AValue: TADSQLiteCollationFlags);
    procedure SetLocale(const AValue: TADLocalID);
    procedure SetOnCompare(const AValue: TSQLiteCollationEvent);
  protected
    function GetActualActive: Boolean; override;
    procedure InternalUninstall; override;
    procedure InternalInstall; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Active;
    property CollationName: String read FCollationName write SetCollationName;
    property CollationKind: TADSQLiteCollationKind read FCollationKind
      write SetCollationKind default scCompareString;
    property Locale: TADLocalID read FLocale write SetLocale
      {$IFDEF MSWINDOWS} default LOCALE_USER_DEFAULT {$ENDIF};
    property Flags: TADSQLiteCollationFlags read FFlags write SetFlags default [];
    property OnCompare: TSQLiteCollationEvent read FOnCompare write SetOnCompare;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADSQLiteRTree = class (TADSQLiteService)
  private
    FRTree: TSQLiteRTree;
    FOnFinalize: TSQLiteRTreeFinalizeEvent;
    FOnCalculate: TSQLiteRTreeCalculateEvent;
    FRTreeName: String;
    procedure SetOnCalculate(const AValue: TSQLiteRTreeCalculateEvent);
    procedure SetOnFinalize(const AValue: TSQLiteRTreeFinalizeEvent);
    procedure SetRTreeName(const AValue: String);
  protected
    function GetActualActive: Boolean; override;
    procedure InternalUninstall; override;
    procedure InternalInstall; override;
  published
    property Active;
    property RTreeName: String read FRTreeName write SetRTreeName;
    property OnCalculate: TSQLiteRTreeCalculateEvent read FOnCalculate write SetOnCalculate;
    property OnFinalize: TSQLiteRTreeFinalizeEvent read FOnFinalize write SetOnFinalize;
  end;

procedure ADSQLiteTypeName2ADDataType(const AOptions: IADStanOptions;
  const AColName, ATypeName: String; out ABaseColName, ABaseTypeName: String;
  out AType: TADDataType; out AAttrs: TADDataAttributes; out ALen: LongWord;
  out APrec, AScale: Integer);

{-------------------------------------------------------------------------------}
implementation

uses
{$IFDEF AnyDAC_D6Base}
  Variants, FmtBCD,
  {$IFDEF AnyDAC_D6}
  SQLTimSt,
  {$ENDIF}
{$ENDIF}
{$IFDEF POSIX}
  Posix.Pthread,
{$ENDIF}
  SysUtils, DB,
  uADStanParam, uADStanError, uADStanConst, uADStanCipher, uADStanFactory,
{$IFNDEF AnyDAC_D7}
    uADStanDef,
{$ENDIF}
  uADDatSManager,
  uADPhysIntf, uADPhysCmdGenerator, uADPhysSQLiteCli, uADPhysSQLiteMeta;

type
  TADPhysSQLiteDriver = class;
  TADPhysSQLiteConnection = class;
  TADPhysSQLiteTransaction = class;
  TADPhysSQLiteEventAlerter = class;
  TADPhysSQLiteCommand = class;

  TADPhysSQLiteDriver = class(TADPhysDriver)
  private
    FLib: TSQLiteLib;
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

  TADPhysSQLiteConnection = class(TADPhysConnection)
  private
    FDatabase: TSQLiteDatabase;
    FStringFormat: TSQLiteExtDataType;
    FGuidFormat: TSQLiteExtDataType;
    FDateTimeFormat: TSQLiteExtDataType;
    FBusyTimeout: Integer;
    procedure SetupForStmt(AUpdOptions: TADUpdateOptions);
    function PreparePwd(const APwd: String): String;
  protected
    procedure InternalConnect; override;
    procedure InternalSetMeta; override;
    procedure InternalDisconnect; override;
    procedure InternalPing; override;
    function InternalCreateTransaction: TADPhysTransaction; override;
    function InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter; override;
    function InternalCreateCommand: TADPhysCommand; override;
    function InternalCreateMetadata: TObject; override;
    function InternalCreateCommandGenerator(const ACommand: IADPhysCommand): TADPhysCommandGenerator; override;
{$IFDEF AnyDAC_MONITOR}
    procedure InternalTracingChanged; override;
{$ENDIF}
    procedure InternalChangePassword(const AUserName, AOldPassword, ANewPassword: String); override;
    procedure InternalExecuteDirect(const ASQL: String; ATransaction: TADPhysTransaction); override;
    procedure GetItem(AIndex: Integer; out AName: String;
      out AValue: Variant; out AKind: TADMoniAdapterItemKind); override;
    function GetItemCount: Integer; override;
    function GetMessages: EADDBEngineException; override;
    function GetCliObj: Pointer; override;
    function InternalGetCliHandle: Pointer; override;
    function GetLastAutoGenValue(const AName: String): Variant; override;
    function InternalGetCurrentCatalog: String; override;
  public
    constructor Create(ADriverObj: TADPhysDriver; AConnHost: TADPhysConnectionHost); override;
    destructor Destroy; override;
    property SQLiteDatabase: TSQLiteDatabase read FDatabase;
  end;

  TADPhysSQLiteTransaction = class(TADPhysTransaction)
  protected
    procedure InternalStartTransaction(ATxID: LongWord); override;
    procedure InternalCommit(ATxID: LongWord); override;
    procedure InternalRollback(ATxID: LongWord); override;
    procedure InternalChanged; override;
    procedure InternalCheckState(ACommandObj: TADPhysCommand; ASuccess: Boolean); override;
    procedure InternalNotify(ANotification: TADPhysTxNotification; ACommandObj: TADPhysCommand); override;
  end;

  TADPhysSQLitePostEventFunc = class(TSQLiteFunction)
  protected
    class procedure Register(ALib: TSQLiteLib); override;
    procedure DoCalculate(AData: TSQLiteFunctionData); override;
  public
    constructor Create(ALib: TSQLiteLib); override;
  end;

  TADPhysSQLiteEventAlerter = class(TADPhysEventAlerter)
  protected
    // TADPhysEventAlerter
    procedure InternalHandle(AEventMessage: TADPhysEventMessage); override;
    procedure InternalSignal(const AEvent: String; const AArgument: Variant); override;
  end;

  PADSQLiteVarInfoRec = ^TADSQLiteVarInfoRec;
  TADSQLiteVarInfoRec = record
    FName,
    FOriginDBName,
    FOriginTabName,
    FOriginColName: String;
    FPos: Integer;
    FSrcFieldType: TFieldType;
    FSize: LongWord;
    FPrec, FScale: Integer;
    FAttrs: TADDataAttributes;
    FSrcDataType,
    FDestDataType,
    FOutDataType: TADDataType;
    FSrcTypeName: String;
    FOutSQLDataType: TSQLiteExtDataType;
    FVar: TSQLiteStmtVar;
    FParamType: TParamType;
    FOpts: TADDataOptions;
  end;

  TADPhysSQLiteStatementProps = set of (cpBatch, cpOnNextResult, cpOnNextResultValue);

  TADPhysSQLiteCommand = class(TADPhysCommand)
  private
    FStmt: TSQLiteStatement;
    FColumnIndex: Integer;
    FColInfos: array of TADSQLiteVarInfoRec;
    FParInfos: array of TADSQLiteVarInfoRec;
    FStatementProps: TADPhysSQLiteStatementProps;
    FPreparedBatchSize: Integer;
    procedure SetupStatement(AStmt: TSQLiteStatement);
    procedure FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
    function FetchMetaRow(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowNo: Longword): Boolean;
    function GetConnection: TADPhysSQLiteConnection;
    procedure DestroyParamInfos;
    procedure DestroyColInfos;
    procedure CreateColInfos;
    procedure CreateParamInfos;
    function AD2SQLiteDataType(ADataType: TADDataType): TSQLiteExtDataType;
    function SQLite2ADDataType(ADataType: TSQLiteExtDataType;
      AUnsigned: Boolean): TADDataType;
    procedure TypeName2ADDataType(const AColName, ATypeName: String;
      out ABaseColName, ABaseTypeName: String; out AType: TADDataType;
      out AAttrs: TADDataAttributes; out ALen: LongWord; out APrec, AScale: Integer);
    procedure SetParamValue(AFmtOpts: TADFormatOptions; AParam: TADParam;
      AVar: TSQLiteStmtVar; ApInfo: PADSQLiteVarInfoRec; AParIndex: Integer);
    procedure SetParamValues(ABatchSize, AOffset: Integer);
    function GetCursor(AOffset: Integer): Boolean;
    function CheckArray(ASize: Integer): Boolean;
    procedure ExecuteBatchInsert(ATimes, AOffset: Integer;
      var ACount: TADCounter);
  protected
    procedure InternalClose; override;
    procedure InternalExecute(ATimes, AOffset: Integer; var ACount: TADCounter); override;
    function InternalFetchRowSet(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowsetSize: LongWord): LongWord; override;
    procedure InternalAbort; override;
    function InternalOpen: Boolean; override;
    function InternalNextRecordSet: Boolean; override;
    procedure InternalPrepare; override;
    function InternalUseStandardMetadata: Boolean; override;
    function InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean; override;
    function InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean; override;
    procedure InternalUnprepare; override;
    function GetCliObj: Pointer; override;
  public
    property SQLiteConnection: TADPhysSQLiteConnection read GetConnection;
    property SQLiteStatement: TSQLiteStatement read FStmt;
  end;

const
  S_AD_CreateUTF8 = 'CreateUTF8';
  S_AD_CreateUTF16 = 'CreateUTF16';
  S_AD_ReadWrite = 'ReadWrite';
  S_AD_ReadOnly = 'ReadOnly';
  S_AD_Normal = 'Normal';
  S_AD_Exclusive = 'Exclusive';
  S_AD_Full = 'Full';
  S_AD_Off = 'Off';
  S_AD_On = 'On';
  S_AD_CacheSize = '10000';
  S_AD_String = 'String';
  S_AD_Binary = 'Binary';
  S_AD_DateTime = 'DateTime';
  S_AD_Choose = 'Choose';
  S_AD_Unicode = 'Unicode';
  S_AD_ANSI = 'ANSI';
  S_AD_Delete = 'Delete';
  S_AD_Truncate = 'Truncate';
  S_AD_Persist = 'Persist';
  S_AD_Memory = 'Memory';
  S_AD_WAL = ' WAL';

  C_AD_Type2SQLDataType: array [TADDataType] of TSQLiteExtDataType = (
    etUnknown,
    etBoolean,
    etInteger, etInteger, etInteger, etInteger,
    etInteger, etInteger, etInteger, etInteger,
    etDouble, etDouble, etDouble,
    etCurrency, etNumber, etNumber,
    etDateTime, etTime, etDate, etDateTime,
    etUnknown, etUnknown, etUnknown,
    etString, etUString, etBlob,
    etBlob, etString, etUString, etUString,
    etBlob, etString, etUString,
    etBlob,
    etUnknown, etUnknown, etUnknown,
      etUnknown, etUnknown,
    etString, etUnknown
  );

  C_AD_SQLDataType2Type: array [TSQLiteExtDataType] of TADDataType =
    (dtUnknown, dtAnsiString, dtWideString, dtInt64, dtDouble,
     dtFmtBCD, dtCurrency, dtByteString, dtBoolean, dtDate, dtTime, dtDateTimeStamp);

{-------------------------------------------------------------------------------}
{ TADPhysSQLiteDriverLink                                                       }
{-------------------------------------------------------------------------------}
function TADPhysSQLiteDriverLink.GetBaseDriverID: String;
begin
  Result := S_AD_SQLiteId;
end;

{-------------------------------------------------------------------------------}
{ TADSQLiteService                                                              }
{-------------------------------------------------------------------------------}
function TADSQLiteService.GetDriverLink: TADPhysSQLiteDriverLink;
begin
  Result := inherited DriverLink as TADPhysSQLiteDriverLink;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteService.SetDriverLink(const AValue: TADPhysSQLiteDriverLink);
begin
  inherited DriverLink := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADSQLiteBackup                                                               }
{-------------------------------------------------------------------------------}
constructor TADSQLiteBackup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPagesPerStep := -1;
  FWaitForLocks := True;
  FBusyTimeout := 10000;
  FCatalog := 'MAIN';
  FDestCatalog := 'MAIN';
  FDestMode := smCreate;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteBackup.SetDatabase(const AValue: String);
begin
  FDatabase := AValue;
  if AValue <> '' then
    DatabaseObj := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteBackup.SetDatabaseObj(const AValue: TSQLiteDatabase);
begin
  FDatabaseObj := AValue;
  if AValue <> nil then
    Database := '';
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteBackup.SetDestDatabase(const AValue: String);
begin
  FDestDatabase := AValue;
  if AValue <> '' then
    DestDatabaseObj := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteBackup.SetDestDatabaseObj(const AValue: TSQLiteDatabase);
begin
  FDestDatabaseObj := AValue;
  if AValue <> nil then
    DestDatabase := '';
end;

{-------------------------------------------------------------------------------}
function TADSQLiteBackup.GetPageCount: Integer;
begin
  if FBackup = nil then
    Result := 0
  else
    Result := FBackup.PageCount;
end;

{-------------------------------------------------------------------------------}
function TADSQLiteBackup.GetRemaining: Integer;
begin
  if FBackup = nil then
    Result := 0
  else
    Result := FBackup.Remaining;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteBackup.InternalExecute;
var
  oLib: TSQLiteLib;
  oSrc, oDest: TSQLiteDatabase;
begin
  oLib := CliObj as TSQLiteLib;
  if DatabaseObj <> nil then
    oSrc := DatabaseObj
  else
    oSrc := TSQLiteDatabase.Create(oLib, Self);
  if DestDatabaseObj <> nil then
    oDest := DestDatabaseObj
  else
    oDest := TSQLiteDatabase.Create(oLib, Self);
  FBackup := TSQLiteBackup.Create(oLib, oDest);
  try
    if DatabaseObj = nil then begin
      oSrc.Open(ADExpandStr(Database), smReadOnly, scDefault);
      oSrc.BusyTimeout := BusyTimeout;
      if Password <> '' then
        oSrc.Key(Password);
    end;
    if DestDatabaseObj = nil then begin
      oDest.Open(ADExpandStr(DestDatabase), DestMode, scDefault);
      if DestPassword <> '' then
        oDest.Key(DestPassword);
    end;
    FBackup.SourceDatabase := oSrc;
    FBackup.SourceDBName := Catalog;
    FBackup.DestinationDatabase := oDest;
    FBackup.DestinationDBName := DestCatalog;
    FBackup.PagesPerStep := PagesPerStep;
    FBackup.WaitForLocks := WaitForLocks;
    FBackup.Init;
    try
      while not FBackup.Step do
        if Assigned(FOnProgress) then
          FOnProgress(Self, '');
    finally
      FBackup.Finish;
    end;
  finally
    ADFreeAndNil(FBackup);
    if DatabaseObj = nil then
      ADFree(oSrc);
    if DestDatabaseObj = nil then
      ADFree(oDest);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteBackup.Backup;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
{ TADSQLiteValidate                                                             }
{-------------------------------------------------------------------------------}
constructor TADSQLiteValidate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOptions := [voCheckIndexes];
  FMaxErrors := -1;
end;

{-------------------------------------------------------------------------------}
function TADSQLiteValidate.CheckOnly: Boolean;
begin
  FLastStatus := True;
  FAction := saCheckOnly;
  Execute;
  Result := FLastStatus;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteValidate.Sweep;
begin
  FLastStatus := True;
  FAction := saSweep;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteValidate.Analyze(const ATable, AIndex: String);
begin
  FLastStatus := True;
  FTable := ATable;
  FIndex := AIndex;
  FAction := saAnalyze;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteValidate.InternalExecute;
var
  oConn: IADPhysConnection;
  oCmd: IADPhysCommand;
  oTab: TADDatSTable;
  sConn, sAction, sLine: String;
  i, j: Integer;
  rFmt: TADParseFmtSettings;
begin
  sConn := 'DriverID=' + DriverLink.ActualDriverID + ';Database=' + Database;
  if Password <> '' then
    sConn := sConn + ';Password=' + Password;
  ADPhysManager().CreateConnection(sConn, oConn);
  oConn.Open;
  oConn.CreateCommand(oCmd);
  case FAction of
  saCheckOnly:
    begin
      sAction := 'PRAGMA ';
      if voCheckIndexes in Options then
        sAction := sAction + 'integrity_check'
      else
        sAction := sAction + 'quick_check';
      if MaxErrors >= 0 then
        sAction := sAction + '(' + IntToStr(MaxErrors) + ')';
    end;
  saSweep:
    sAction := 'VACUUM';
  saAnalyze:
    begin
      sAction := 'ANALYZE';
      if FTable <> '' then
        sAction := sAction + ' ' + FTable;
    end;
  end;
  oCmd.Prepare(sAction);
  if FAction = saCheckOnly then begin
    oTab := oCmd.Define();
    try
      oCmd.Open(True);
      oCmd.Fetch(oTab, True, True);
      FLastStatus := (oTab.Rows.Count = 0) or
        (oTab.Rows.Count = 1) and (CompareText(oTab.Rows[0].ValueI[0], 'ok') = 0);
      if not FLastStatus and Assigned(FOnProgress) then begin
        rFmt.FQuote := #0;
        rFmt.FQuote1 := #0;
        rFmt.FQuote2 := #0;
        rFmt.FDelimiter := #10;
        for i := 0 to oTab.Rows.Count - 1 do begin
          sLine := VarToStr(oTab.Rows[i].ValueI[0]);
          j := 1;
          while j <= Length(sLine) do
            FOnProgress(Self, ADExtractFieldName(sLine, j, rFmt));
        end;
      end;
    finally
      ADFree(oTab);
    end;
  end
  else
    oCmd.Execute();
end;

{-------------------------------------------------------------------------------}
{ TADSQLiteSecurity                                                             }
{-------------------------------------------------------------------------------}
procedure TADSQLiteSecurity.SetPassword;
begin
  FAction := saSetPassword;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteSecurity.RemovePassword;
begin
  FAction := saRemovePassword;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteSecurity.ChangePassword;
begin
  FAction := saChangePassword;
  Execute;
end;

{-------------------------------------------------------------------------------}
function TADSQLiteSecurity.CheckEncryption: String;
begin
  FAction := saCheckEncryption;
  FEncryption := '';
  Execute;
  Result := FEncryption;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteSecurity.InternalExecute;
var
  oDef: IADStanConnectionDef;
  oConn: IADPhysConnection;

  procedure SetLargerCache;
  var
    sDB: String;
    oFS: TFileStream;
    iSize: Int64;
  begin
    if soSetLargeCache in Options then begin
      sDB := oDef.ExpandedDatabase;
      if FileExists(sDB) then begin
        oFS := TFileStream.Create(sDB, fmOpenRead or fmShareDenyNone);
        try
          iSize := Trunc(oFS.Size * 1.1) div 1024;
          if iSize > StrToInt(S_AD_CacheSize) then
            oDef.Params.Add(S_AD_ConnParam_SQLite_CacheSize + '=' + IntToStr(iSize));
        finally
          ADFree(oFS);
        end;
      end;
    end;
  end;

begin
  ADCreateInterface(IADStanConnectionDef, oDef);
  oDef.DriverID := DriverLink.ActualDriverID;
  oDef.Database := Database;
  case FAction of
  saSetPassword:
    begin
      SetLargerCache;
      oDef.Params.Add(S_AD_ConnParam_Common_NewPassword + '=' + Password);
    end;
  saRemovePassword:
    begin
      SetLargerCache;
      oDef.Params.Add(S_AD_ConnParam_Common_Password + '=' + Password);
      oDef.Params.Add(S_AD_ConnParam_Common_NewPassword + '=');
    end;
  saChangePassword:
    begin
      SetLargerCache;
      oDef.Params.Add(S_AD_ConnParam_Common_Password + '=' + Password);
      oDef.Params.Add(S_AD_ConnParam_Common_NewPassword + '=' + ToPassword);
    end;
  saCheckEncryption:
    oDef.Params.Add(S_AD_ConnParam_Common_Password + '=' + Password);
  end;
  ADPhysManager().CreateConnection(oDef, oConn);
  try
    oConn.Open;
    if FAction = saCheckEncryption then
      FEncryption := TSQLiteDatabase(oConn.CliObj).Encryption;
  except
    on E: EADDBEngineException do
      if FAction <> saCheckEncryption then
        raise
      else if E.ADCode = er_AD_SQLiteDBUnencrypted then
        FEncryption := '<unencrypted>'
      else if (E.ADCode = er_AD_SQLitePwdInvalid) or
              (E.ADCode = er_AD_SQLiteAlgFailure) or
              (E[0].ErrorCode = SQLITE_NOTADB) then
        FEncryption := '<encrypted>';
  end;
end;

{-------------------------------------------------------------------------------}
{ TADSQLiteFunction                                                             }
{-------------------------------------------------------------------------------}
procedure TADSQLiteFunction.SetAggregated(const AValue: Boolean);
begin
  if FAggregated <> AValue then begin
    Active := False;
    FAggregated := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteFunction.SetArgumentsCount(const AValue: Integer);
begin
  if FArgumentsCount <> AValue then begin
    Active := False;
    FArgumentsCount := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteFunction.SetFunctionName(const AValue: String);
begin
  if FFunctionName <> AValue then begin
    Active := False;
    FFunctionName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteFunction.SetOnCalculate(const AValue: TSQLiteFunctionCalculateEvent);
begin
  if (TMethod(FOnCalculate).Code <> TMethod(AValue).Code) or
     (TMethod(FOnCalculate).Data <> TMethod(AValue).Data) then begin
    Active := False;
    FOnCalculate := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteFunction.SetOnFinalize(const AValue: TSQLiteFunctionFinalizeEvent);
begin
  if (TMethod(FOnFinalize).Code <> TMethod(AValue).Code) or
     (TMethod(FOnFinalize).Data <> TMethod(AValue).Data) then begin
    Active := False;
    FOnFinalize := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADSQLiteFunction.GetActualActive: Boolean;
begin
  Result := inherited GetActualActive and (FunctionName <> '') and
    Assigned(OnCalculate);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteFunction.InternalUninstall;
begin
  ADFreeAndNil(FFunction);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteFunction.InternalInstall;
begin
  FFunction := TSQLiteFunction.Create(CliObj as TSQLiteLib);
  FFunction.Name := FunctionName;
  FFunction.Args := ArgumentsCount;
  FFunction.Aggregate := Aggregated;
  FFunction.OnCalculate := OnCalculate;
  FFunction.OnFinalize := OnFinalize;
  FFunction.InstallAll;
end;

{-------------------------------------------------------------------------------}
{ TADSQLiteCollation                                                            }
{-------------------------------------------------------------------------------}
constructor TADSQLiteCollation.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF MSWINDOWS}
  FLocale := LOCALE_USER_DEFAULT;
{$ENDIF}
  FCollationKind := scCompareString;
end;

{-------------------------------------------------------------------------------}
function TADSQLiteCollation.GetActualActive: Boolean;
begin
  Result := inherited GetActualActive and (CollationName <> '') and
    ((CollationKind = scCompareString) or Assigned(FOnCompare));
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteCollation.SetCollationKind(const AValue: TADSQLiteCollationKind);
begin
  if FCollationKind <> AValue then begin
    Active := False;
    FCollationKind := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteCollation.SetCollationName(const AValue: String);
begin
  if FCollationName <> AValue then begin
    Active := False;
    FCollationName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteCollation.SetFlags(const AValue: TADSQLiteCollationFlags);
begin
  if FFlags <> AValue then begin
    Active := False;
    FFlags := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteCollation.SetLocale(const AValue: TADLocalID);
begin
  if FLocale <> AValue then begin
    Active := False;
    FLocale := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteCollation.SetOnCompare(const AValue: TSQLiteCollationEvent);
begin
  if (TMethod(FOnCompare).Code <> TMethod(AValue).Code) or
     (TMethod(FOnCompare).Data <> TMethod(AValue).Data) then begin
    Active := False;
    FOnCompare := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteCollation.InternalInstall;
{$IFDEF MSWINDOWS}
const
  SORT_DIGITSASNUMBERS  = $00000008;
  LINGUISTIC_IGNORECASE = $00000010;
  LINGUISTIC_IGNOREDIACRITIC = $00000020;
  SORT_STRINGSORT = $00001000;
  NORM_LINGUISTIC_CASING = $08000000;
  C_Flags: array [TADSQLiteCollationFlag] of LongWord = (LINGUISTIC_IGNORECASE,
    LINGUISTIC_IGNOREDIACRITIC, NORM_IGNORECASE, NORM_IGNOREKANATYPE,
    NORM_IGNORENONSPACE, NORM_IGNORESYMBOLS, NORM_IGNOREWIDTH,
    NORM_LINGUISTIC_CASING, SORT_DIGITSASNUMBERS, SORT_STRINGSORT);
var
  eFlag: TADSQLiteCollationFlag;
{$ENDIF}
begin
  if CollationKind = scCompareString then begin
{$IFDEF MSWINDOWS}
    FCollation := TSQLiteCollationCompareStringW.Create(CliObj as TSQLiteLib);
    TSQLiteCollationCompareStringW(FCollation).OwningObj := Self;
    TSQLiteCollationCompareStringW(FCollation).Locale := Locale;
    TSQLiteCollationCompareStringW(FCollation).Flags := 0;
    for eFlag := Low(TADSQLiteCollationFlag) to High(TADSQLiteCollationFlag) do
      if eFlag in Flags then
        TSQLiteCollationCompareStringW(FCollation).Flags :=
          TSQLiteCollationCompareStringW(FCollation).Flags or C_Flags[eFlag];
{$ELSE}
    ADCapabilityNotSupported(Self, [S_AD_LPhys, DriverLink.ActualDriverID]);
{$ENDIF}
  end
  else begin
    FCollation := TSQLiteCollation.Create(CliObj as TSQLiteLib);
    FCollation.OwningObj := Self;
    FCollation.OnCompare := OnCompare;
    if CollationKind = scCustomUTF8 then
      FCollation.Encoding := SQLITE_UTF8
    else
      FCollation.Encoding := SQLITE_UTF16;
  end;
  FCollation.Name := CollationName;
  FCollation.InstallAll;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteCollation.InternalUninstall;
var
  oMan: IADPhysManager;
begin
  oMan := ADPhysManager();
  if (oMan <> nil) and (oMan.State = dmsActive) and
     (DriverLink.DriverIntf.ConnectionCount > 0) then
    FCollation := nil
  else
    ADFreeAndNil(FCollation);
end;

{-------------------------------------------------------------------------------}
{ TADSQLiteRTree                                                                }
{-------------------------------------------------------------------------------}
procedure TADSQLiteRTree.SetRTreeName(const AValue: String);
begin
  if FRTreeName <> AValue then begin
    Active := False;
    FRTreeName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteRTree.SetOnCalculate(const AValue: TSQLiteRTreeCalculateEvent);
begin
  if (TMethod(FOnCalculate).Code <> TMethod(AValue).Code) or
     (TMethod(FOnCalculate).Data <> TMethod(AValue).Data) then begin
    Active := False;
    FOnCalculate := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteRTree.SetOnFinalize(const AValue: TSQLiteRTreeFinalizeEvent);
begin
  if (TMethod(FOnFinalize).Code <> TMethod(AValue).Code) or
     (TMethod(FOnFinalize).Data <> TMethod(AValue).Data) then begin
    Active := False;
    FOnFinalize := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADSQLiteRTree.GetActualActive: Boolean;
begin
  Result := inherited GetActualActive and Assigned(FOnCalculate);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteRTree.InternalUninstall;
begin
  ADFreeAndNil(FRTree);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLiteRTree.InternalInstall;
begin
  FRTree := TSQLiteRTree.Create(CliObj as TSQLiteLib);
  FRTree.Name := RTreeName;
  FRTree.OnCalculate := OnCalculate;
  FRTree.OnFinalize := OnFinalize;
  FRTree.InstallAll;
end;

{-------------------------------------------------------------------------------}
{ TADPhysSQLiteDriver                                                           }
{-------------------------------------------------------------------------------}
constructor TADPhysSQLiteDriver.Create(AManager: TADPhysManager;
  const ADriverDef: IADStanDefinition);
begin
  inherited Create(AManager, ADriverDef);
  FLib := TSQLiteLib.Create(ADPhysManagerObj);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysSQLiteDriver.Destroy;
begin
  inherited Destroy;
  ADFreeAndNil(FLib);
end;

{-------------------------------------------------------------------------------}
class function TADPhysSQLiteDriver.GetBaseDriverID: String;
begin
  Result := S_AD_SQLiteId;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteDriver.InternalLoad;
var
  sHome, sLib: String;
begin
  sHome := '';
  sLib := '';
  GetVendorParams(sHome, sLib);
  FLib.Load(sHome, sLib);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteDriver.InternalUnload;
begin
  FLib.Unload;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteDriver.InternalCreateConnection(
  AConnHost: TADPhysConnectionHost): TADPhysConnection;
begin
  Result := TADPhysSQLiteConnection.Create(Self, AConnHost);
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteDriver.GetCliObj: Pointer;
begin
  Result := FLib;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 16;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
begin
  ALoginIndex := -1;
  if AIndex < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then begin
      ALoginIndex := 0;
      AType := '@F:SQLite Database|*.sdb;*.db';
    end
    else if AName = S_AD_ConnParam_Common_UserName then
      ALoginIndex := -1
    else if AName = S_AD_ConnParam_Common_Password then
      ALoginIndex := 1;
  end
  else begin
    ADefVal := '';
    case AIndex - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_SQLite_OpenMode;
        AType := S_AD_CreateUTF8 + ';' + S_AD_CreateUTF16 + ';' + S_AD_ReadWrite + ';' + S_AD_ReadOnly;
        ADefVal := S_AD_CreateUTF8;
      end;
    1:
      begin
        AName := S_AD_ConnParam_SQLite_Encrypt;
        AType := S_AD_No + ';' + ADCipherGetClasses();
        ADefVal := S_AD_No;
      end;
    2:
      begin
        AName := S_AD_ConnParam_SQLite_BusyTimeout;
        AType := '@I';
        ADefVal := '10000';
      end;
    3:
      begin
        AName := S_AD_ConnParam_SQLite_CacheSize;
        AType := '@I';
        ADefVal := S_AD_CacheSize;
      end;
    4:
      begin
        AName := S_AD_ConnParam_SQLite_SharedCache;
        AType := '@L';
        ADefVal := S_AD_True;
      end;
    5:
      begin
        AName := S_AD_ConnParam_SQLite_LockingMode;
        AType := S_AD_Normal + ';' + S_AD_Exclusive;
        ADefVal := S_AD_Exclusive;
      end;
    6:
      begin
        AName := S_AD_ConnParam_SQLite_Synchronous;
        AType := S_AD_Full + ';' + S_AD_Normal + ';' + S_AD_Off;
        ADefVal := S_AD_Off;
      end;
    7:
      begin
        AName := S_AD_ConnParam_SQLite_JournalMode;
        AType := S_AD_Delete + ';' + S_AD_Truncate + ';' + S_AD_Persist + ';' +
          S_AD_Memory + ';' + S_AD_WAL + ';' + S_AD_Off;
        ADefVal := S_AD_Delete;
      end;
    8:
      begin
        AName := S_AD_ConnParam_SQLite_ForeignKeys;
        AType := S_AD_On + ';' + S_AD_Off;
        ADefVal := S_AD_On;
      end;
    9:
      begin
        AName := S_AD_ConnParam_SQLite_StringFormat;
        AType := S_AD_Choose + ';' + S_AD_Unicode + ';' + S_AD_ANSI;
        ADefVal := S_AD_Choose;
      end;
   10:
      begin
        AName := S_AD_ConnParam_SQLite_GUIDFormat;
        AType := S_AD_String + ';' + S_AD_Binary;
        ADefVal := S_AD_String;
      end;
   11:
      begin
        AName := S_AD_ConnParam_SQLite_DateTimeFormat;
        AType := S_AD_String + ';' + S_AD_Binary + ';' + S_AD_DateTime;
        ADefVal := S_AD_String;
      end;
   12:
      begin
        AName := S_AD_ConnParam_SQLite_Extensions;
        AType := '@S';
        ADefVal := S_AD_False;
      end;
   13:
      begin
        AName := S_AD_ConnParam_SQLite_Advanced;
        AType := '@S';
      end;
   14:
      begin
        AName := S_AD_ConnParam_Common_MetaDefCatalog;
        AType := '@S';
        ADefVal := 'MAIN';
      end;
   15:
      begin
        AName := S_AD_ConnParam_Common_MetaCurCatalog;
        AType := '@S';
        ADefVal := '';
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysSQLiteConnection                                                       }
{-------------------------------------------------------------------------------}
constructor TADPhysSQLiteConnection.Create(ADriverObj: TADPhysDriver;
  AConnHost: TADPhysConnectionHost);
begin
  inherited Create(ADriverObj, AConnHost);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysSQLiteConnection.Destroy;
begin
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteConnection.InternalCreateTransaction: TADPhysTransaction;
begin
  Result := TADPhysSQLiteTransaction.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteConnection.InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter;
begin
  if CompareText(AEventKind, S_AD_EventKind_SQLite_Events) = 0 then
    Result := TADPhysSQLiteEventAlerter.Create(Self, AEventKind)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteConnection.InternalCreateCommand: TADPhysCommand;
begin
  Result := TADPhysSQLiteCommand.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysSQLiteCommandGenerator.Create(ACommand)
  else
    Result := TADPhysSQLiteCommandGenerator.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteConnection.InternalCreateMetadata: TObject;
var
  oLib: TSQLiteLib;
begin
  oLib := TADPhysSQLiteDriver(DriverObj).FLib;
  Result := TADPhysSQLiteMetadata.Create(Self, oLib.Brand, oLib.Version, oLib.Version,
    FStringFormat = etUString, Assigned(oLib.Fsqlite3_column_database_name));
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_Monitor}
procedure TADPhysSQLiteConnection.InternalTracingChanged;
begin
  if FDatabase <> nil then begin
    FDatabase.Monitor := FMonitor;
    FDatabase.Tracing := FTracing;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADPhysSQLiteConnection.PreparePwd(const APwd: String): String;
var
  s: String;
begin
  Result := APwd;
  s := GetConnectionDef.AsString[S_AD_ConnParam_SQLite_Encrypt];
  if (s <> '') and (CompareText(s, S_AD_No) <> 0) and
     (Result <> '') and (Pos(':', Result) = 0) then
    Result := s + ':' + Result;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteConnection.InternalConnect;

  procedure FillList(AList: TStrings; const AParam, ADefVal: String);
  var
    sExt: String;
    i: Integer;
  begin
    AList.Clear;
    if GetConnectionDef.HasValue(AParam) then begin
      sExt := GetConnectionDef.AsString[AParam];
      i := 1;
      while i <= Length(sExt) do
        AList.Add(ADExtractFieldName(sExt, i));
    end
    else
      AList.Add(ADefVal);
  end;

  procedure SetPragma(const AParam, ADef, APragma: String);
  var
    s: String;
  begin
    if GetConnectionDef.HasValue(AParam) then
      s := GetConnectionDef.AsString[AParam]
    else
      s := ADef;
    InternalExecuteDirect('PRAGMA ' + APragma + ' = ' + s, nil);
  end;

var
  sDatabase, s: String;
  eSharedCache: TSQLiteSharedCache;
  eMode: TSQLiteDatabaseMode;
  eEncoding: TADEncoding;
  i: Integer;
begin
  sDatabase := GetConnectionDef.ExpandedDatabase;
  if sDatabase = '' then
    sDatabase := ':memory:';
  eMode := smCreate;
  eEncoding := ecDefault;
  eSharedCache := scDefault;
  if GetConnectionDef.HasValue(S_AD_ConnParam_SQLite_OpenMode) then begin
    s := GetConnectionDef.AsString[S_AD_ConnParam_SQLite_OpenMode];
    if CompareText(s, S_AD_CreateUTF8) = 0 then begin
      eMode := smCreate;
      eEncoding := ecUTF8;
    end
    else if CompareText(s, S_AD_CreateUTF16) = 0 then begin
      eMode := smCreate;
      eEncoding := ecUTF16;
    end
    else if CompareText(s, S_AD_ReadWrite) = 0 then
      eMode := smReadWrite
    else if CompareText(s, S_AD_ReadOnly) = 0 then
      eMode := smReadOnly;
  end;
  if GetConnectionDef.HasValue(S_AD_ConnParam_SQLite_SharedCache) then
    if GetConnectionDef.AsBoolean[S_AD_ConnParam_SQLite_SharedCache] then
      eSharedCache := scShared
    else
      eSharedCache := scPrivate;

  if InternalGetSharedCliHandle() <> nil then
    FDatabase := TSQLiteDatabase.CreateUsingHandle(TADPhysSQLiteDriver(DriverObj).FLib,
      psqlite3(InternalGetSharedCliHandle()), Self)
  else
    FDatabase := TSQLiteDatabase.Create(TADPhysSQLiteDriver(DriverObj).FLib, Self);
{$IFDEF AnyDAC_MONITOR}
  InternalTracingChanged;
{$ENDIF}

  FStringFormat := etUnknown;
  s := GetConnectionDef.AsString[S_AD_ConnParam_SQLite_StringFormat];
  if CompareText(s, S_AD_Unicode) = 0 then
    FStringFormat := etUString
  else if CompareText(s, S_AD_ANSI) = 0 then
    FStringFormat := etString;
  FGuidFormat := etString;
  if CompareText(GetConnectionDef.AsString[S_AD_ConnParam_SQLite_GUIDFormat], S_AD_Binary) = 0 then
    FGuidFormat := etBlob;
  s := GetConnectionDef.AsString[S_AD_ConnParam_SQLite_DateTimeFormat];
  FDateTimeFormat := etString;
  if CompareText(s, S_AD_Binary) = 0 then
    FDateTimeFormat := etInteger
  else if CompareText(s, S_AD_DateTime) = 0 then
    FDateTimeFormat := etDateTime;
  FDatabase.DateTimeFormat := FDateTimeFormat;

  if GetConnectionDef.HasValue(S_AD_ConnParam_SQLite_BusyTimeout) then
    FBusyTimeout := GetConnectionDef.AsInteger[S_AD_ConnParam_SQLite_BusyTimeout]
  else
    FBusyTimeout := 10000;

  if InternalGetSharedCliHandle() = nil then begin
    FillList(FDatabase.Extensions, S_AD_ConnParam_SQLite_Extensions, S_AD_False);

    FDatabase.Open(sDatabase, eMode, eSharedCache);
    if GetConnectionDef.HasValue(S_AD_ConnParam_Common_Password) then
      FDatabase.Key(PreparePwd(GetConnectionDef.Password));

    case eEncoding of
    ecUTF8:  InternalExecuteDirect('PRAGMA encoding = "UTF-8"', nil);
    ecUTF16: InternalExecuteDirect('PRAGMA encoding = "UTF-16"', nil);
    end;

    SetPragma(S_AD_ConnParam_SQLite_CacheSize, S_AD_CacheSize, 'cache_size');
    SetPragma(S_AD_ConnParam_SQLite_LockingMode, S_AD_Exclusive, 'locking_mode');
    SetPragma(S_AD_ConnParam_SQLite_Synchronous, S_AD_Off, 'synchronous');
    if TADPhysSQLiteDriver(DriverObj).FLib.Version >= svSQLite030700 then
      SetPragma(S_AD_ConnParam_SQLite_JournalMode, S_AD_Delete, 'journal_mode');
    if TADPhysSQLiteDriver(DriverObj).FLib.Version >= svSQLite030619 then
      SetPragma(S_AD_ConnParam_SQLite_ForeignKeys, S_AD_On, 'foreign_keys');

    if GetConnectionDef.HasValue(S_AD_ConnParam_SQLite_Advanced) then begin
      s := GetConnectionDef.AsString[S_AD_ConnParam_SQLite_Advanced];
      i := 1;
      while i <= Length(s) do
        InternalExecuteDirect('PRAGMA ' + ADExpandStr(ADExtractFieldName(s, i)), nil);
    end;

    if GetConnectionDef.IsSpecified(S_AD_ConnParam_Common_NewPassword) then
      FDatabase.ReKey(PreparePwd(GetConnectionDef.NewPassword));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteConnection.InternalSetMeta;
begin
  inherited InternalSetMeta;
  if FDefaultCatalog = '' then
    FDefaultCatalog := 'MAIN';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteConnection.InternalDisconnect;
begin
  ADFreeAndNil(FDatabase);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteConnection.InternalPing;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteConnection.InternalExecuteDirect(const ASQL: String;
  ATransaction: TADPhysTransaction);
var
  oStmt: TSQLiteStatement;
begin
  SetupForStmt(FOptions.UpdateOptions);
  oStmt := TSQLiteStatement.Create(FDatabase, Self);
  try
    oStmt.Prepare(ASQL);
    repeat
      oStmt.Execute;
    until not oStmt.PrepareNextCommand;
  finally
    ADFree(oStmt);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteConnection.InternalChangePassword(const AUserName,
  AOldPassword, ANewPassword: String);
var
  oDB: TSQLiteDatabase;
begin
  if (FDatabase = nil) or (FDatabase.Handle = nil) then begin
    oDB := TSQLiteDatabase.Create(TADPhysSQLiteDriver(DriverObj).FLib, Self);
    oDB.Open(GetConnectionDef.ExpandedDatabase, smReadWrite, scPrivate);
  end
  else
    oDB := FDatabase;
  try
    if AOldPassword <> '' then
      oDB.Key(PreparePwd(AOldPassword));
    oDB.ReKey(PreparePwd(ANewPassword));
  finally
    if FDatabase <> oDB then
      ADFree(oDB);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteConnection.GetLastAutoGenValue(const AName: String): Variant;
begin
  if (FDatabase <> nil) and (AName = '') then
{$IFDEF AnyDAC_D6Base}
    Result := FDatabase.LastInsertRowid
{$ELSE}
    Result := Integer(FDatabase.LastInsertRowid)
{$ENDIF}
  else
    Result := inherited GetLastAutoGenValue(AName);
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteConnection.GetItemCount: Integer;
begin
  Result := inherited GetItemCount;
  if DriverObj.State in [drsLoaded, drsActive] then begin
    Inc(Result, 3);
    if FDatabase <> nil then
      Inc(Result, 4);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteConnection.GetItem(AIndex: Integer; out AName: String;
  out AValue: Variant; out AKind: TADMoniAdapterItemKind);
var
  s, sDef: String;
  pOpt: PADAnsiString;
  i, iLen: Integer;
begin
  if AIndex < inherited GetItemCount then
    inherited GetItem(AIndex, AName, AValue, AKind)
  else
    case AIndex - inherited GetItemCount of
    0:
      begin
        AName := 'DLL';
{$IFDEF AnyDAC_SQLITE_STATIC}
        AValue := '<statically linked>';
{$ELSE}
        AValue := TADPhysSQLiteDriver(DriverObj).FLib.DLLName;
{$ENDIF}
        AKind := ikClientInfo;
      end;
    1:
      begin
        AName := 'Client version';
        AValue := TADEncoder.Deco(TADPhysSQLiteDriver(DriverObj).FLib.Fsqlite3_libversion(), -1, ecANSI);
        AKind := ikClientInfo;
      end;
    2:
      begin
        if Assigned(TADPhysSQLiteDriver(DriverObj).FLib.Fsqlite3_compileoption_get) then begin
          s := '';
          i := 0;
          iLen := 0;
          while True do begin
            pOpt := TADPhysSQLiteDriver(DriverObj).FLib.Fsqlite3_compileoption_get(i);
            if pOpt = nil then
              Break;
            sDef := TADEncoder.Deco(pOpt, -1, ecANSI);
            if iLen + Length(sDef) + 1 > 50 then begin
              s := s + C_AD_EOL + '  ';
              iLen := 0;
            end;
            s := s + sDef + ';';
            Inc(iLen, Length(sDef) + 1);
            Inc(i);
          end;
          s := Copy(s, 1, Length(s) - 1);
        end
        else
          s := '<unknown>';
        AName := 'Compile options';
        AValue := s;
        AKind := ikClientInfo;
      end;
    3:
      begin
        AName := 'Total changes';
        AValue := FDatabase.TotalChanges;
        AKind := ikSessionInfo;
      end;
    4:
      begin
        AName := 'Database encoding';
        AValue := FDatabase.CharacterSet;
        AKind := ikSessionInfo;
      end;
    5:
      begin
        AName := 'Encryption mode';
        AValue := FDatabase.Encryption;
        AKind := ikSessionInfo;
      end;
    6:
      begin
        AName := 'Cache size';
        AValue := FDatabase.CacheSize;
        AKind := ikSessionInfo;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteConnection.GetMessages: EADDBEngineException;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteConnection.GetCliObj: Pointer;
begin
  Result := FDatabase;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteConnection.InternalGetCliHandle: Pointer;
begin
  if FDatabase <> nil then
    Result := FDatabase.Handle
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteConnection.InternalGetCurrentCatalog: String;
begin
  Result := 'MAIN';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteConnection.SetupForStmt(AUpdOptions: TADUpdateOptions);
begin
  if (AUpdOptions <> nil) and AUpdOptions.LockWait then
    FDatabase.BusyTimeout := FBusyTimeout
  else
    FDatabase.BusyTimeout := 0;
end;

{-------------------------------------------------------------------------------}
{ TADPhysSQLiteTransaction                                                      }
{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteTransaction.InternalChanged;
var
  s: String;
begin
  if xoIsolation in GetOptions.Changed then begin
    if GetOptions.Isolation = xiDirtyRead then
      s := '1'
    else
      s := '0';
    TADPhysSQLiteConnection(ConnectionObj).InternalExecuteDirect(
      'PRAGMA read_uncommitted = ' + s, Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteTransaction.InternalStartTransaction(ATxID: LongWord);
var
  sMode: String;
begin
  case GetOptions.Isolation of
  xiSnapshot:     sMode := 'IMMEDIATE';
  xiSerializible: sMode := 'EXCLUSIVE';
  else            sMode := 'DEFERRED';
  end;
  TADPhysSQLiteConnection(ConnectionObj).InternalExecuteDirect(
    'BEGIN ' + sMode + ' TRANSACTION t_' + IntToStr(ATxID), Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteTransaction.InternalCommit(ATxID: LongWord);
begin
  TADPhysSQLiteConnection(ConnectionObj).InternalExecuteDirect(
    'COMMIT TRANSACTION t_' + IntToStr(ATxID), Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteTransaction.InternalRollback(ATxID: LongWord);
begin
  DisconnectCommands(nil, dmRelease);
  TADPhysSQLiteConnection(ConnectionObj).InternalExecuteDirect(
    'ROLLBACK TRANSACTION t_' + IntToStr(ATxID), Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteTransaction.InternalCheckState(ACommandObj: TADPhysCommand;
  ASuccess: Boolean);
var
  lInTran: Boolean;
begin
  lInTran := TADPhysSQLiteCommand(ACommandObj).SQLiteConnection.
    SQLiteDatabase.InTransaction;
  if GetActive <> lInTran then
    if lInTran then
      TransactionStarted
    else
      TransactionFinished;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteTransaction.InternalNotify(ANotification: TADPhysTxNotification;
  ACommandObj: TADPhysCommand);
begin
  if (ANotification = cpBeforeCmdExecute) and
     (TADPhysSQLiteCommand(ACommandObj).GetCommandKind = skRollback) then
    DisconnectCommands(nil, dmRelease);
  inherited InternalNotify(ANotification, ACommandObj);
end;

{-------------------------------------------------------------------------------}
{ TADPhysSQLiteEventMessage                                                     }
{-------------------------------------------------------------------------------}
type
  TADPhysSQLiteEventMessage = class(TADPhysEventMessage)
  private
    FName: String;
    FParams: Variant;
  public
    constructor Create(const AName: String; const AParams: Variant);
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysSQLiteEventMessage.Create(const AName: String;
  const AParams: Variant);
begin
  inherited Create;
  FName := AName;
  FParams := AParams;
end;

{-------------------------------------------------------------------------------}
{ TADPhysSQLitePostEventFunc                                                    }
{-------------------------------------------------------------------------------}
constructor TADPhysSQLitePostEventFunc.Create(ALib: TSQLiteLib);
begin
  inherited Create(ALib);
  Name := 'POST_EVENT';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLitePostEventFunc.DoCalculate(AData: TSQLiteFunctionData);
var
  i, j: Integer;
  oConn: TADPhysSQLiteConnection;
  sName: String;
  vParams, V: Variant;
  oInput: TSQLiteValue;
begin
  oConn := TADPhysSQLiteConnection(AData.Database.OwningObj);
  sName := AData.Inputs.Inputs[0].AsString;
  vParams := Unassigned;
  for i := 0 to oConn.FEventList.Count - 1 do
    if TADPhysSQLiteEventAlerter(oConn.FEventList[i]).GetNames.IndexOf(sName) >= 0 then begin
      if VarIsEmpty(vParams) then begin
        vParams := VarArrayCreate([0, AData.Inputs.Count - 2], varVariant);
        for j := 1 to AData.Inputs.Count - 1 do begin
          oInput := AData.Inputs[j];
          V := Unassigned;
          case AData.Inputs[j].ExtDataType of
          etUnknown,
          etString:   V := oInput.AsAnsiString;
          etUString:  V := oInput.AsWideString;
          etInteger:  V := {$IFDEF AnyDAC_D6} oInput.AsInteger
                           {$ELSE} Integer(oInput.AsInteger) {$ENDIF};
          etDouble:   V := oInput.AsFloat;
          etNumber:   V := {$IFDEF AnyDAC_D6} VarFMTBcdCreate(oInput.AsNumber)
                           {$ELSE} oInput.AsFloat {$ENDIF};
          etCurrency: V := oInput.AsCurrency;
          etBlob:     V := oInput.AsAnsiString;
          etBoolean:  V := oInput.AsBoolean;
          etDate:     V := oInput.AsDate;
          etTime:     V := oInput.AsTime;
          etDateTime: V := oInput.AsDateTime;
          end;
          vParams[j - 1] := V;
        end;
      end;
{$IFDEF AnyDAC_D6}
      if GetCurrentThreadID = MainThreadID then
        CheckSynchronize();
{$ENDIF}
      TADPhysSQLiteEventAlerter(oConn.FEventList[i]).FMsgThread.EnqueueMsg(
        TADPhysSQLiteEventMessage.Create(sName, vParams));
    end;
end;

{-------------------------------------------------------------------------------}
class procedure TADPhysSQLitePostEventFunc.Register(ALib: TSQLiteLib);
var
  i: Integer;
begin
  for i := 0 to 4 do
    TADPhysSQLitePostEventFunc.Create(ALib).Args := 1 + i;
end;

{-------------------------------------------------------------------------------}
{ TADPhysSQLiteEventAlerter                                                     }
{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteEventAlerter.InternalHandle(AEventMessage: TADPhysEventMessage);
var
  oMsg: TADPhysSQLiteEventMessage;
begin
  if GetHandler <> nil then begin
    oMsg := TADPhysSQLiteEventMessage(AEventMessage);
    GetHandler.HandleEvent(oMsg.FName, oMsg.FParams);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteEventAlerter.InternalSignal(const AEvent: String;
  const AArgument: Variant);
var
  sCmd: String;
  oCmd: IADPhysCommand;
begin
  GetConnection.CreateCommand(oCmd);
  SetupCommand(oCmd);
  sCmd := 'SELECT POST_EVENT(' + QuotedStr(AEvent);
  if not VarIsEmpty(AArgument) then
    sCmd := sCmd + ', ' + QuotedStr(VarToStr(AArgument));
  sCmd := sCmd + ')';
  oCmd.Prepare(sCmd);
  oCmd.Open(True);
end;

{-------------------------------------------------------------------------------}
{ TADPhysSQLiteCommand                                                          }
{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommand.GetConnection: TADPhysSQLiteConnection;
begin
  Result := TADPhysSQLiteConnection(FConnectionObj);
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommand.GetCliObj: Pointer;
begin
  Result := FStmt;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.SetupStatement(AStmt: TSQLiteStatement);
var
  oFmtOpts: TADFormatOptions;
begin
  oFmtOpts := FOptions.FormatOptions;
  if GetMetaInfoKind <> mkNone then begin
    AStmt.StrsTrim := True;
    AStmt.StrsEmpty2Null := True;
    AStmt.MaxStringSize := C_AD_DefMaxStrSize;
    AStmt.UseColumnMetadata := False;
  end
  else begin
    AStmt.StrsTrim := oFmtOpts.StrsTrim;
    AStmt.StrsEmpty2Null := oFmtOpts.StrsEmpty2Null;
    AStmt.MaxStringSize := oFmtOpts.MaxStringSize;
    // No need to control the UseColumnMetadata by a conndef option. The
    // sqlite3_table_column_metadata is faster, than mkPrimaryKeyFields.
    AStmt.UseColumnMetadata := fiMeta in FOptions.FetchOptions.Items;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.InternalPrepare;
var
  rName: TADPhysParsedName;
begin
  FStatementProps := [];

  // generate metadata SQL command
  if GetMetaInfoKind <> uADPhysIntf.mkNone then begin
    GetSelectMetaInfoParams(rName);
    GenerateSelectMetaInfo(rName);
    if FDbCommandText = '' then
      Exit;
  end

  // generate metadata SQL command
  else if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_SQLiteId]);

  // adjust SQL command
  if GetMetaInfoKind = uADPhysIntf.mkNone then
    GenerateLimitSelect();
  GenerateParamMarkers();

  FStmt := TSQLiteStatement.Create(SQLiteConnection.FDatabase, Self);
  SetupStatement(FStmt);
  FStmt.Prepare(FDbCommandText);
  if FStmt.MoreCommands then
    Include(FStatementProps, cpBatch)
  else
    // for a single command create cached parameter infos at prepare
    CreateParamInfos;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.InternalUnprepare;
begin
  if FStmt = nil then
    Exit;
  FStmt.Unprepare;
  DestroyColInfos;
  DestroyParamInfos;
  ADFreeAndNil(FStmt);
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommand.AD2SQLiteDataType(ADataType: TADDataType): TSQLiteExtDataType;
begin
  if ADataType = dtGUID then
    Result := SQLiteConnection.FGuidFormat
  else
    Result := C_AD_Type2SQLDataType[ADataType];
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommand.SQLite2ADDataType(ADataType: TSQLiteExtDataType;
  AUnsigned: Boolean): TADDataType;
begin
  Result := C_AD_SQLDataType2Type[ADataType];
  if AUnsigned and (Result = dtInt64) then
    Result := dtUInt64;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.CreateParamInfos;
var
  i: Integer;
  oDef: TSQLiteValueDef;
  pInfo: PADSQLiteVarInfoRec;
  oParams: TADParams;
  oParam: TADParam;
  oFmtOpts: TADFormatOptions;
  eDestFldType: TFieldType;
begin
  oParams := GetParams;
  if (oParams.Count = 0) or (FStmt = nil) then
    Exit;

  oFmtOpts := FOptions.FormatOptions;

  SetLength(FParInfos, FStmt.ParamDefsCount);
  for i := 0 to Length(FParInfos) - 1 do begin
    oDef := FStmt.ParamDefs[i];
    pInfo := @FParInfos[i];
    try
      case GetParams.BindMode of
      pbByName:
        begin
          pInfo^.FName := oDef.Name;
          oParam := oParams.FindParam(Copy(pInfo^.FName, 2, Length(pInfo^.FName)));
        end;
      pbByNumber:
        begin
          pInfo^.FName := '';
          oParam := oParams.FindParam(FStmt.BaseParamIndex + oDef.Index + 1);
        end;
      else
        oParam := nil;
      end;
      if oParam = nil then begin
        pInfo^.FPos := -1;
        Continue;
      end;

      pInfo^.FPos := oParam.Index;

      if oParam.ParamType = ptUnknown then
        oParam.ParamType := ptInput;
      if not (oParam.ParamType in [ptUnknown, ptInput]) then
        ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_SQLiteId]);
      pInfo^.FParamType := oParam.ParamType;

      pInfo^.FSrcFieldType := oParam.DataType;
      if oParam.DataType = ftUnknown then
        ParTypeUnknownError(oParam);
      oFmtOpts.ResolveFieldType('', oParam.DataType, oParam.ADDataType, oParam.Size,
        oParam.Precision, oParam.NumericScale, eDestFldType, pInfo^.FSize, pInfo^.FPrec,
        pInfo^.FScale, pInfo^.FSrcDataType, pInfo^.FDestDataType, False);
      pInfo^.FOutSQLDataType := AD2SQLiteDataType(pInfo^.FDestDataType);
      pInfo^.FOutDataType := SQLite2ADDataType(pInfo^.FOutSQLDataType,
        pInfo^.FDestDataType in C_AD_NumUnsignedTypes);

      pInfo^.FVar := TSQLiteBind.Create(FStmt.Params);
      pInfo^.FVar.ExtDataType := pInfo^.FOutSQLDataType;
    finally
      ADFree(oDef);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.DestroyParamInfos;
begin
  SetLength(FParInfos, 0);
  if FStmt <> nil then
    FStmt.Params.Clear;
end;

{-------------------------------------------------------------------------------}
procedure ADSQLiteTypeName2ADDataType(const AOptions: IADStanOptions;
  const AColName, ATypeName: String; out ABaseColName, ABaseTypeName: String;
  out AType: TADDataType; out AAttrs: TADDataAttributes; out ALen: LongWord;
  out APrec, AScale: Integer);
const
  C_TypeDelim = '::';
var
  i1, i2: Integer;
  sTypeName, sBaseColName, sArgs, sMod: String;
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

  procedure SetLen(ADefLen: Integer; AAdjustUTF8: Boolean);
  begin
    ALen := StrToIntDef(sArgs, ADefLen);
{$IFDEF AnyDAC_NATIVE_UTF8}
    if AAdjustUTF8 then begin
      ALen := ALen * C_AD_MaxUTF8Len;
      if ALen > AOptions.FormatOptions.MaxStringSize then
        ALen := AOptions.FormatOptions.MaxStringSize;
    end;
{$ENDIF}
  end;

begin
  AType := dtUnknown;
  AAttrs := [caSearchable];
  ALen := 0;
  APrec := 0;
  AScale := 0;

  i1 := Pos(C_TypeDelim, AColName);
  if i1 = 0 then begin
    sTypeName := ATypeName;
    ABaseColName := AColName;
  end
  else begin
    sTypeName := Copy(AColName, i1 + Length(C_TypeDelim), MAXINT);
    ABaseColName := Copy(AColName, 1, i1 - 1);
  end;

  i1 := Pos(C_AD_SysColumnPrefix, ABaseColName);
  if i1 <> 0 then
    sBaseColName := Copy(ABaseColName, Length(C_AD_SysColumnPrefix) + 1, MAXINT)
  else
    sBaseColName := ABaseColName;

  i1 := Pos('(', sTypeName);
  i2 := Pos(')', sTypeName);
  if i1 = 0 then begin
    ABaseTypeName := Trim(UpperCase(sTypeName));
    sArgs := '';
  end
  else begin
    ABaseTypeName := Trim(UpperCase(Copy(sTypeName, 1, i1 - 1)));
    sArgs := Trim(Copy(sTypeName, i1 + 1, i2 - i1 - 1));
  end;
  i1 := Pos(' ', ABaseTypeName);
  if i1 = 0 then
    sMod := ''
  else begin
    sMod := Trim(Copy(ABaseTypeName, i1 + 1, Length(ABaseTypeName)));
    ABaseTypeName := Copy(ABaseTypeName, 1, i1 - 1);
    if (ABaseTypeName = 'UNSIGNED') and (sMod <> '') then begin
      ABaseTypeName := sMod;
      sMod := 'UNSIGNED';
    end;
  end;

  if ((CompareText(sBaseColName, 'ROWID') = 0) or
      (CompareText(sBaseColName, '_ROWID_') = 0) or
      (CompareText(sBaseColName, 'OID') = 0)) and
     (ABaseTypeName = 'INTEGER') then begin
    AType := dtInt64;
    AAttrs := AAttrs + [caAllowNull, caROWID, caAutoInc];
  end
  else if (ABaseTypeName = 'BIT') or (ABaseTypeName = 'BOOL') or (ABaseTypeName = 'BOOLEAN') or
     (ABaseTypeName = 'LOGICAL') or (ABaseTypeName = 'YESNO') then
    AType := dtBoolean
  else if (ABaseTypeName = 'TINYINT') or (ABaseTypeName = 'SHORTINT') or (ABaseTypeName = 'INT8') then
    if sMod = 'UNSIGNED' then
      AType := dtByte
    else
      AType := dtSByte
  else if (ABaseTypeName = 'BYTE') or (ABaseTypeName = 'UINT8') then
    AType := dtByte
  else if (ABaseTypeName = 'SMALLINT') or (ABaseTypeName = 'INT16') then
    if sMod = 'UNSIGNED' then
      AType := dtUInt16
    else
      AType := dtInt16
  else if (ABaseTypeName = 'WORD') or (ABaseTypeName = 'UINT16') or (ABaseTypeName = 'YEAR') then
    AType := dtUInt16
  else if (ABaseTypeName = 'MEDIUMINT') or (ABaseTypeName = 'INTEGER') or (ABaseTypeName = 'INT') or (ABaseTypeName = 'INT32') then
    if sMod = 'UNSIGNED' then
      AType := dtUInt32
    else
      AType := dtInt32
  else if (ABaseTypeName = 'LONGWORD') or (ABaseTypeName = 'UINT32') then
    AType := dtUInt32
  else if (ABaseTypeName = 'BIGINT') or (ABaseTypeName = 'INT64') or
          (ABaseTypeName = 'COUNTER') or (ABaseTypeName = 'AUTOINCREMENT') or (ABaseTypeName = 'IDENTITY') then
    if sMod = 'UNSIGNED' then
      AType := dtUInt64
    else
      AType := dtInt64
  else if (ABaseTypeName = 'LONGLONGWORD') or (ABaseTypeName = 'UINT64') then
    AType := dtUInt64
  else if (ABaseTypeName = 'FLOAT') or (ABaseTypeName = 'REAL') or
          ((ABaseTypeName = 'DOUBLE') or (ABaseTypeName = 'SINGLE')) and ((sMod = '') or (sMod = 'PRECISION')) then begin
    SetPrecScale(0, 0);
    if APrec > 16 then begin
      oFmt := AOptions.FormatOptions;
      if (APrec <= oFmt.MaxBcdPrecision) and (AScale <= oFmt.MaxBcdScale) then
        AType := dtBCD
      else
        AType := dtFmtBCD;
    end
    else if ABaseTypeName = 'SINGLE' then
      AType := dtSingle
    else
      AType := dtDouble;
  end
  else if (ABaseTypeName = 'DECIMAL') or (ABaseTypeName = 'DEC') or (ABaseTypeName = 'NUMERIC') or (ABaseTypeName = 'NUMBER') then begin
    SetPrecScale(10, 0);
    if AScale = 0 then
      if sMod = 'UNSIGNED' then begin
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
      oFmt := AOptions.FormatOptions;
      if (APrec <= oFmt.MaxBcdPrecision) and (AScale <= oFmt.MaxBcdScale) then
        AType := dtBCD
      else
        AType := dtFmtBCD;
    end;
  end
  else if (ABaseTypeName = 'MONEY') or (ABaseTypeName = 'SMALLMONEY') or (ABaseTypeName = 'CURRENCY') or
          (ABaseTypeName = 'FINANCIAL') then begin
    SetPrecScale(19, 4);
    AType := dtCurrency;
  end
  else if (ABaseTypeName = 'DATE') or (ABaseTypeName = 'SMALLDATE') then
    AType := dtDate
  else if (ABaseTypeName = 'DATETIME') or (ABaseTypeName = 'SMALLDATETIME') then
    AType := dtDateTime
  else if ABaseTypeName = 'TIMESTAMP' then
    AType := dtDateTimeStamp
  else if ABaseTypeName = 'TIME' then
    AType := dtTime
  else if ((ABaseTypeName = 'CHAR') or (ABaseTypeName = 'CHARACTER')) and (sMod = '') then begin
    SetLen(AOptions.FormatOptions.MaxStringSize, False);
    AType := dtAnsiString;
    Include(AAttrs, caFixedLen);
  end
  else if (ABaseTypeName = 'VARCHAR') or (ABaseTypeName = 'VARCHAR2') or (ABaseTypeName = 'TYNITEXT') or
          ((ABaseTypeName = 'CHARACTER') or (ABaseTypeName = 'CHAR')) and (sMod = 'VARYING') then begin
    SetLen(AOptions.FormatOptions.MaxStringSize, False);
    AType := dtAnsiString;
  end
  else if (ABaseTypeName = 'NCHAR') or (ABaseTypeName = 'NATIONAL') and (
          (sMod = 'CHAR') or (sMod = 'CHARACTER')) then begin
    SetLen(1, True);
    AType := {$IFDEF AnyDAC_NATIVE_UTF8} dtAnsiString {$ELSE} dtWideString {$ENDIF};
    Include(AAttrs, caFixedLen);
  end
  else if (ABaseTypeName = 'NVARCHAR') or (ABaseTypeName = 'NVARCHAR2') or (ABaseTypeName = 'NATIONAL') and (
            (sMod = 'CHAR VARYING') or (sMod = 'CHARACTER VARYING') or
            (sMod = 'VARYING CHAR') or (sMod = 'VARYING CHARACTER')) or
          (ABaseTypeName = 'STRING') then begin
    SetLen(AOptions.FormatOptions.MaxStringSize, True);
    AType := {$IFDEF AnyDAC_NATIVE_UTF8} dtAnsiString {$ELSE} dtWideString {$ENDIF};
  end
  else if (ABaseTypeName = 'RAW') or (ABaseTypeName = 'TYNIBLOB') or (ABaseTypeName = 'VARBINARY') or
          (ABaseTypeName = 'BINARY') and ((sMod = '') or (sMod = 'VARYING')) then begin
    SetLen(AOptions.FormatOptions.MaxStringSize, False);
    AType := dtByteString;
    if (ABaseTypeName = 'BINARY') and (sMod = '') then
      Include(AAttrs, caFixedLen);
  end
  else if (ABaseTypeName = 'BLOB') or (ABaseTypeName = 'MEDIUMBLOB') or (ABaseTypeName = 'LONGBLOB') or
          (ABaseTypeName = 'GENERAL') or (ABaseTypeName = 'LONG') and ((sMod = 'BINARY') or (sMod = 'RAW')) or
          (ABaseTypeName = 'LONGVARBINARY') or (ABaseTypeName = 'OLEOBJECT') or (ABaseTypeName = 'TINYBLOB') or
          (ABaseTypeName = 'IMAGE') or (ABaseTypeName = 'GRAPHIC') or (ABaseTypeName = 'PICTURE') or
          (ABaseTypeName = 'PHOTO') then begin
    SetLen(0, False);
    if (ALen > 0) and (ALen < AOptions.FormatOptions.MaxStringSize) then
      AType := dtByteString
    else begin
      // SQLite allows to use BLOB in WHERE
      // Exclude(AAttrs, caSearchable);
      Include(AAttrs, caBlobData);
      AType := dtBlob;
    end;
  end
  else if (ABaseTypeName = 'TEXT') or (ABaseTypeName = 'MEDIUMTEXT') or (ABaseTypeName = 'LONGTEXT') or
          (ABaseTypeName = 'CLOB') or (ABaseTypeName = 'MEMO') or (ABaseTypeName = 'NOTE') or
          (ABaseTypeName = 'LONG') and ((sMod = '') or (sMod = 'TEXT')) or
          (ABaseTypeName = 'LONGCHAR') or (ABaseTypeName = 'LONGVARCHAR') or (ABaseTypeName = 'TINYTEXT') then begin
    SetLen(0, False);
    if (ALen > 0) and (ALen < AOptions.FormatOptions.MaxStringSize) then
      AType := dtAnsiString
    else begin
      // SQLite allows to use CLOB in WHERE
      // Exclude(AAttrs, caSearchable);
      Include(AAttrs, caBlobData);
      AType := dtMemo;
    end;
  end
  else if (ABaseTypeName = 'NTEXT') or (ABaseTypeName = 'WTEXT') or (ABaseTypeName = 'NCLOB') or (ABaseTypeName = 'NMEMO') or
          (ABaseTypeName = 'LONG') and ((sMod = 'NTEXT') or (sMod = 'WTEXT')) or
          (ABaseTypeName = 'NATIONAL') and (sMod = 'TEXT') or
          (ABaseTypeName = 'LONGWCHAR') or (ABaseTypeName = 'LONGWVARCHAR') or
          (ABaseTypeName = 'HTML') then begin
    SetLen(0, True);
    if (ALen > 0) and (ALen <= AOptions.FormatOptions.MaxStringSize) then
      AType := {$IFDEF AnyDAC_NATIVE_UTF8} dtAnsiString {$ELSE} dtWideString {$ENDIF}
    else begin
      // SQLite allows to use NCLOB in WHERE
      // Exclude(AAttrs, caSearchable);
      Include(AAttrs, caBlobData);
      AType := {$IFDEF AnyDAC_NATIVE_UTF8} dtMemo {$ELSE} dtWideMemo {$ENDIF};
    end;
  end
  else if (ABaseTypeName = 'XMLDATA') or (ABaseTypeName = 'XMLTYPE') or (ABaseTypeName = 'XML') then begin
    // SQLite allows to use XML in WHERE
    // Exclude(AAttrs, caSearchable);
    Include(AAttrs, caBlobData);
    AType := dtXML;
  end
  else if (ABaseTypeName = 'GUID') or (ABaseTypeName = 'UNIQUEIDENTIFIER') then
    AType := dtGUID
  else begin
    SetLen(AOptions.FormatOptions.MaxStringSize, True);
    AType := {$IFDEF AnyDAC_NATIVE_UTF8} dtAnsiString {$ELSE} dtWideString {$ENDIF};
  end
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.TypeName2ADDataType(const AColName, ATypeName: String;
  out ABaseColName, ABaseTypeName: String; out AType: TADDataType;
  out AAttrs: TADDataAttributes; out ALen: LongWord; out APrec, AScale: Integer);
begin
  ADSQLiteTypeName2ADDataType(FOptions, AColName, ATypeName, ABaseColName,
    ABaseTypeName, AType, AAttrs, ALen, APrec, AScale);
  case SQLiteConnection.FStringFormat of
{$IFNDEF AnyDAC_NATIVE_UTF8}
  etUString:
    case AType of
    dtAnsiString: AType := dtWideString;
    dtMemo:       AType := dtWideMemo;
    dtHMemo:      AType := dtWideHMemo;
    end;
{$ELSE}
  etUString,
{$ENDIF}
  etString:
    case AType of
    dtWideString: AType := dtAnsiString;
    dtWideMemo:   AType := dtMemo;
    dtWideHMemo:  AType := dtHMemo;
    dtXML:        AType := dtMemo;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.CreateColInfos;
var
  i: Integer;
  oDef: TSQLiteValueDef;
  pInfo: PADSQLiteVarInfoRec;
  oFmtOpts: TADFormatOptions;
  sName, sType: String;
begin
  oFmtOpts := FOptions.FormatOptions;
  SetLength(FColInfos, FStmt.ColumnDefsCount);
  for i := 0 to Length(FColInfos) - 1 do begin
    oDef := FStmt.ColumnDefs[i];
    pInfo := @FColInfos[i];
    try
      TypeName2ADDataType(oDef.Name, oDef.TypeName, sName, sType, pInfo^.FSrcDataType,
        pInfo^.FAttrs, pInfo^.FSize, pInfo^.FPrec, pInfo^.FScale);

      pInfo^.FName := sName;
      pInfo^.FOriginDBName := oDef.DBName;
      pInfo^.FOriginTabName := oDef.TabName;
      pInfo^.FOriginColName := oDef.ColName;
      pInfo^.FSrcTypeName := oDef.TypeName;
      pInfo^.FPos := i + 1;

      if not oDef.NotNull then
        Include(pInfo^.FAttrs, caAllowNull);
      if oDef.AutoInc then
        Include(pInfo^.FAttrs, caAutoInc);
      if oDef.InPrimaryKey then
        pInfo^.FOpts := [coInKey]
      else
        pInfo^.FOpts := [];

      // mapping data types
      if GetMetaInfoKind = mkNone then
        oFmtOpts.ResolveDataType(pInfo^.FName, pInfo^.FSrcDataType, pInfo^.FSize,
          pInfo^.FPrec, pInfo^.FScale, pInfo^.FDestDataType, pInfo^.FSize, True)
      else
        pInfo^.FDestDataType := pInfo^.FSrcDataType;
      pInfo^.FOutSQLDataType := AD2SQLiteDataType(pInfo^.FDestDataType);
      pInfo^.FOutDataType := SQLite2ADDataType(pInfo^.FOutSQLDataType,
        pInfo^.FDestDataType in C_AD_NumUnsignedTypes);

      if CheckFetchColumn(pInfo^.FSrcDataType, pInfo^.FAttrs) then begin
        pInfo^.FVar := TSQLiteColumn.Create(FStmt.Columns);
        pInfo^.FVar.ExtDataType := pInfo^.FOutSQLDataType;
        pInfo^.FVar.Index := oDef.Index;
      end
      else
        pInfo^.FVar := nil;
    finally
      ADFree(oDef);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.DestroyColInfos;
begin
  SetLength(FColInfos, 0);
  if FStmt <> nil then
    FStmt.Columns.Clear;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommand.InternalUseStandardMetadata: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommand.InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean;
begin
  Result := OpenBlocked;
  if ATabInfo.FSourceID = -1 then begin
    ATabInfo.FSourceName := GetCommandText;
    ATabInfo.FSourceID := 1;
    FColumnIndex := 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommand.InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean;
var
  pColInfo: PADSQLiteVarInfoRec;
begin
  if FColumnIndex < Length(FColInfos) then begin
    pColInfo := @FColInfos[FColumnIndex];
    AColInfo.FSourceName := pColInfo^.FName;
    AColInfo.FSourceID := pColInfo^.FPos;
    AColInfo.FSourceType := pColInfo^.FSrcDataType;
    AColInfo.FSourceTypeName := pColInfo^.FSrcTypeName;
    AColInfo.FOriginTabName.FCatalog := pColInfo^.FOriginDBName;
    AColInfo.FOriginTabName.FObject := pColInfo^.FOriginTabName;
    AColInfo.FOriginColName := pColInfo^.FOriginColName;
    AColInfo.FType := pColInfo^.FDestDataType;
    AColInfo.FLen := pColInfo^.FSize;
    AColInfo.FPrec := pColInfo^.FPrec;
    AColInfo.FScale := pColInfo^.FScale;
    AColInfo.FAttrs := pColInfo^.FAttrs;
    AColInfo.FForceAddOpts := pColInfo^.FOpts;
    Inc(FColumnIndex);
    Result := True;
  end
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.SetParamValue(AFmtOpts: TADFormatOptions;
  AParam: TADParam; AVar: TSQLiteStmtVar; ApInfo: PADSQLiteVarInfoRec;
  AParIndex: Integer);
var
  pData: PADByteString;
  iSize, iSrcSize: LongWord;
begin
  pData := nil;
  iSize := 0;

  // null
  if AParam.IsNulls[AParIndex] then
    AVar.SetData(nil, 0)

  // conversion is not required
  else if ApInfo^.FOutDataType = ApInfo^.FSrcDataType then begin

    { TODO -cNEXTGEN : Avoid conversion for etString / AnsiString:
      FPar (UTF16) -> GetData (>ANSI) -> SetData(UTF16 DB >UTF16) }
    if ApInfo^.FOutSQLDataType in [{$IFNDEF NEXTGEN} etString, {$ENDIF} etUString, etBlob] then begin
      AParam.GetBlobRawData(iSize, pData, AParIndex);
      AVar.SetData(pData, iSize);
    end

    else begin
      iSize := AParam.GetDataLength(AParIndex);
      FBuffer.Check(iSize);
      AParam.GetData(FBuffer.Ptr, AParIndex);
      AVar.SetData(FBuffer.Ptr, iSize);
    end;
  end

  // conversion is required
  else begin
    // calculate buffer size to move param values
    iSrcSize := AParam.GetDataLength(AParIndex);
    FBuffer.Extend(iSrcSize, iSize, ApInfo^.FSrcDataType, ApInfo^.FOutDataType);

    // get, convert and set parameter value
    AParam.GetData(FBuffer.Ptr, AParIndex);
    AFmtOpts.ConvertRawData(ApInfo^.FSrcDataType, ApInfo^.FOutDataType,
      FBuffer.Ptr, iSrcSize, FBuffer.FBuffer, FBuffer.Size, iSize,
      SQLiteConnection.FDatabase.Encoder);

    AVar.SetData(FBuffer.Ptr, iSize);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.SetParamValues(ABatchSize, AOffset: Integer);
var
  oParams: TADParams;
  oFmtOpts: TADFormatOptions;
  oParam: TADParam;
  oSqParam: TSQLiteStmtVar;
  iParamsCount, i, j: Integer;
  pParInfo: PADSQLiteVarInfoRec;
begin
  oParams := GetParams;
  if oParams.Count = 0 then
    Exit;

  oFmtOpts := GetOptions.FormatOptions;
  iParamsCount := Length(FParInfos);
  for i := 0 to Length(FParInfos) - 1 do begin
    pParInfo := @FParInfos[i];
    if pParInfo^.FPos <> -1 then begin
      oParam := oParams[pParInfo^.FPos];
      if (pParInfo^.FVar <> nil) and
         (oParam.DataType <> ftCursor) and
         (oParam.ParamType in [ptInput, ptInputOutput, ptUnknown]) then
        CheckParamMatching(oParam, pParInfo^.FSrcFieldType, pParInfo^.FParamType, 0);
        for j := 0 to ABatchSize - 1 do begin
          if j = 0 then
            oSqParam := pParInfo^.FVar
          else
            oSqParam := FStmt.Params[j * iParamsCount + pParInfo^.FPos];
          SetParamValue(oFmtOpts, oParam, oSqParam, pParInfo, j + AOffset);
        end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.ExecuteBatchInsert(ATimes, AOffset: Integer;
  var ACount: TADCounter);
var
  sBatchSQL: String;
  iBatchSQLPos: Integer;

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
  oParams: TADParams;
  iParamsCount: Integer;
  oSqParam: TSQLiteStmtVar;
  oSrcSqParam: TSQLiteStmtVar;
  i, j: Integer;
  lIsQuest: Boolean;
  lIsParam: Boolean;
  iQuestPos: Integer;
  aParamsPos: array of Integer;
  iBatchParamInd: Integer;
  iMaxSize, iBatchSize, iCurTimes, iCurOffset: Integer;
begin
  oParams := GetParams;
  iParamsCount := Length(FParInfos);

  iBatchSize := ATimes - AOffset;
  iMaxSize := SQLiteConnection.FDatabase.Limits[SQLITE_LIMIT_VARIABLE_NUMBER] div iParamsCount;
  if iBatchSize > iMaxSize then
    iBatchSize := iMaxSize;
  iMaxSize := GetOptions.ResourceOptions.ArrayDMLSize;
  if (iMaxSize <> $7FFFFFFF) and (iBatchSize > iMaxSize) then
    iBatchSize := iMaxSize;

  iCurOffset := AOffset;
  iCurTimes := AOffset + iBatchSize;
  try
    while iCurOffset < ATimes do begin
      if iCurTimes > ATimes then begin
        iCurTimes := ATimes;
        iBatchSize := iCurTimes - iCurOffset;
      end;

      if not CheckArray(iBatchSize) then begin
        lIsQuest := False;
        lIsParam := False;
        iQuestPos := 1;
        i := FSQLValuesPos;
        j := 1;
        SetLength(aParamsPos, oParams.Count * 2 + 2);
        aParamsPos[0] := FSQLValuesPos + 5;
        while i <= FSQLValuesPosEnd do begin
          case FDBCommandText[i] of
          '?':
            begin
              lIsQuest := True;
              iQuestPos := i;
            end;
          '0'..'9':
            lIsParam := lIsQuest;
          else
            if lIsParam then begin
              aParamsPos[j] := iQuestPos - 2;
              aParamsPos[j + 1] := i - 1;
              Inc(j, 2);
            end;
            lIsQuest := False;
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
            W('?');
            W(IntToStr(iBatchParamInd));
            C(aParamsPos[i * 2], aParamsPos[i * 2 + 1] - aParamsPos[i * 2] + 1);
            Inc(iBatchParamInd);
          end;
        end;
        C(FSQLValuesPosEnd, Length(FDBCommandText) - FSQLValuesPosEnd);
        SetLength(sBatchSQL, iBatchSQLPos);

        FStmt.Unprepare;
        FStmt.Params.Clear(iParamsCount);
        for i := 1 to iBatchSize - 1 do
          for j := 0 to iParamsCount - 1 do begin
            oSrcSqParam := FStmt.Params[j];
            oSqParam := TSQLiteBind.Create(FStmt.Params);
            oSqParam.ExtDataType := oSrcSqParam.ExtDataType;
          end;
        FStmt.Prepare(sBatchSQL);
      end;

      FStmt.Rewind;
      SetParamValues(iBatchSize, iCurOffset);
      try
        FStmt.Execute;
      finally
        Inc(ACount, FStmt.Changes);
      end;

      Inc(iCurOffset, iBatchSize);
      Inc(iCurTimes, iBatchSize);
    end;
  finally
    FStmt.Unprepare;
    FStmt.Params.Clear(iParamsCount);
    FStmt.Prepare(FDbCommandText);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommand.CheckArray(ASize: Integer): Boolean;
begin
  Result := (ASize = 1) and (FPreparedBatchSize <= 1) or
            (ASize = FPreparedBatchSize);
  if not Result then begin
    FStmt.Unprepare;
    FPreparedBatchSize := ASize;
    if ASize = 1 then
      FStmt.Prepare(FDBCommandText);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.InternalExecute(ATimes, AOffset: Integer;
  var ACount: TADCounter);
var
  i, iChanges: Integer;
begin
  SQLiteConnection.SetupForStmt(FOptions.UpdateOptions);
  ACount := 0;
  try
    if (ATimes - AOffset > 1) and
       (TADPhysSQLiteDriver(SQLiteConnection.DriverObj).FLib.Version >= svSQLite030711) and
       (GetCommandKind in [skInsert, skMerge]) and not (cpBatch in FStatementProps) and
       (FSQLValuesPos > 0) and (GetParams.BindMode = pbByNumber) then
      ExecuteBatchInsert(ATimes, AOffset, ACount)

    else begin
      CheckArray(1);
      for i := AOffset to ATimes - 1 do begin
        FStmt.Rewind;
        Exclude(FStatementProps, cpOnNextResult);
        if cpBatch in FStatementProps then begin
          DestroyColInfos;
          DestroyParamInfos;
          CreateParamInfos;
        end;
        SetParamValues(1, i);
        try
          try
            FStmt.Execute;
          finally
            iChanges := FStmt.Changes;
            Inc(ACount, iChanges);
          end;
          CheckExact(ATimes = 1, 1, 0, iChanges, False);
          if (cpBatch in FStatementProps) and (GetState <> csAborting) and
             (FStmt.ColumnDefsCount = 0) then begin
            Include(FStatementProps, cpOnNextResult);
            if GetCursor(i) then
              Include(FStatementProps, cpOnNextResultValue)
            else
              Exclude(FStatementProps, cpOnNextResultValue);
          end;
        except
          on E: EADDBEngineException do begin
            E[0].RowIndex := i;
            raise;
          end;
        end;
      end;
    end;
  finally
    FStmt.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.InternalAbort;
begin
  if (FStmt <> nil) and (SQLiteConnection.SQLiteDatabase <> nil) then
    SQLiteConnection.SQLiteDatabase.Interrupt;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommand.GetCursor(AOffset: Integer): Boolean;
begin
  if cpBatch in FStatementProps then
    while (FStmt.ColumnDefsCount = 0) and
          (GetState <> csAborting) and
          FStmt.MoreCommands and FStmt.PrepareNextCommand do begin
      if FStmt.ParamDefsCount > 0 then begin
        DestroyParamInfos;
        CreateParamInfos;
        SetParamValues(1, AOffset);
      end;
      FStmt.Execute;
    end;
  Result := FStmt.ColumnDefsCount > 0;
  if Result and (FStmt.Columns.Count = 0) then
    CreateColInfos;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommand.InternalOpen: Boolean;
begin
  if (GetMetaInfoKind <> mkNone) and (FDbCommandText = '') then begin
    Result := False;
    Exit;
  end
  else if (FStmt <> nil) and not (FStmt.State in [ssInactive, ssPrepared,
                                                  ssRewinded, ssExecuted]) then begin
    Result := True;
    Exit;
  end
  else begin
    if GetNextRecordSet then
      FStmt.Reset
    else
      FStmt.Rewind;
    if cpBatch in FStatementProps then begin
      DestroyColInfos;
      DestroyParamInfos;
      CreateParamInfos;
    end;
    SetParamValues(1, 0);
    SQLiteConnection.SetupForStmt(FOptions.UpdateOptions);
    FStmt.Execute;
    Exclude(FStatementProps, cpOnNextResult);
    Result := GetCursor(0) or
      // PRAGMA's return empty column list, if there is no data
      (GetMetaInfoKind <> mkNone);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommand.InternalNextRecordSet: Boolean;
begin
  if FStmt.State = ssRewinded then
    Result := False
  else if cpOnNextResult in FStatementProps then begin
    Exclude(FStatementProps, cpOnNextResult);
    Result := cpOnNextResultValue in FStatementProps;
  end
  else begin
    Result := FStmt.MoreCommands;
    if Result then begin
      DestroyColInfos;
      Result := FStmt.PrepareNextCommand;
      if Result then begin
        SQLiteConnection.SetupForStmt(FOptions.UpdateOptions);
        FStmt.Execute;
        Result := GetCursor(0);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.InternalClose;
begin
  if FStmt <> nil then begin
    FStmt.Reset;
    if not GetNextRecordSet then
      FStmt.Rewind;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysSQLiteCommand.FetchRow(ATable: TADDatSTable;
  AParentRow: TADDatSRow);
var
  oRow: TADDatSRow;
  oCol: TADDatSColumn;
  oFmtOpts: TADFormatOptions;
  pColInfo: PADSQLiteVarInfoRec;
  j: Integer;
  lMetadata: Boolean;

  procedure ProcessColumn(AColIndex: Integer; ARow: TADDatSRow;
    ApInfo: PADSQLiteVarInfoRec);
  var
    pData, pDestData: Pointer;
    iSize: Integer;
    iDestSize: LongWord;
    lByRef: Boolean;
  begin
    pData := FBuffer.Check;
    iSize := 0;
    lByRef := ApInfo^.FOutSQLDataType in [etString, etUString, etBlob];

    // null
    if not ApInfo^.FVar.GetData(pData, iSize, lByRef) then
      ARow.SetData(AColIndex, nil, 0)

    // conversion is not required
    else if ApInfo^.FOutDataType = ApInfo^.FDestDataType then
      ARow.SetData(AColIndex, pData, iSize)

    // conversion is required
    else begin
      pDestData := FBuffer.Extend(iSize, iDestSize, ApInfo^.FOutDataType,
        ApInfo^.FDestDataType);
      iDestSize := 0;
      oFmtOpts.ConvertRawData(ApInfo^.FOutDataType, ApInfo^.FDestDataType,
        pData, iSize, pDestData, FBuffer.Size, iDestSize,
        SQLiteConnection.FDatabase.Encoder);
      ARow.SetData(AColIndex, pDestData, iDestSize);
    end;
  end;

  procedure ProcessMetaColumn(AColIndex: Integer; ARow: TADDatSRow;
    ApInfo: PADSQLiteVarInfoRec);
  begin
    if AColIndex = 0 then
      ARow.SetData(0, ATable.Rows.Count + 1)
    else begin
      ApInfo^.FDestDataType := ATable.Columns[AColIndex].DataType;
      ProcessColumn(AColIndex, ARow, ApInfo);
    end;
  end;

begin
  oFmtOpts := FOptions.FormatOptions;
  oRow := ATable.NewRow(False);
  lMetadata := GetMetaInfoKind <> mkNone;
  try
    for j := 0 to ATable.Columns.Count - 1 do begin
      oCol := ATable.Columns[j];
      if (oCol.SourceID > 0) and CheckFetchColumn(oCol.SourceDataType, oCol.Attributes) then begin
        pColInfo := @FColInfos[oCol.SourceID - 1];
        if pColInfo^.FVar <> nil then
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
function TADPhysSQLiteCommand.FetchMetaRow(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowNo: Longword): Boolean;

  function GetFKAction(const AAction: String): TADPhysCascadeRuleKind;
  begin
    if (CompareText(AAction, 'NO ACTION') = 0) or
       (CompareText(AAction, 'RESTRICT') = 0) then
      Result := ckRestrict
    else if CompareText(AAction, 'CASCADE') = 0 then
      Result := ckCascade
    else if CompareText(AAction, 'SET DEFAULT') = 0 then
      Result := ckSetDefault
    else if CompareText(AAction, 'SET NULL') = 0 then
      Result := ckSetNull
    else
      Result := ckNone;
  end;

var
  oRow: TADDatSRow;
  iRecNo: Integer;
  rName: TADPhysParsedName;
  iLen: LongWord;
  iPrec, iScale: Integer;
  eType: TADDataType;
  eAttrs: TADDataAttributes;
  lDeleteRow: Boolean;
  oConnMeta: IADPhysConnectionMetadata;
  sName, sTmp, sTypeName, sWildcard, sCollation: String;
  bNotNull, bInPK, bAutoInc: Boolean;
  sBaseName, sBaseTypeName: String;
begin
  lDeleteRow := False;
  sWildcard := GetWildcard;
  iRecNo := FRecordsFetched + Integer(ARowNo);
  oRow := ATable.NewRow(False);
  try
    FConnection.CreateMetadata(oConnMeta);
    oConnMeta.DecodeObjName(Trim(GetCommandText), rName, Self, [doNormalize, doUnquote]);
    case GetMetaInfoKind of
    mkTableFields:
      begin
        eAttrs := [];
        oRow.SetData(0, iRecNo);
        oRow.SetData(1, rName.FCatalog);
        oRow.SetData(2, Null);
        oRow.SetData(3, rName.FObject);
        sName := FStmt.Columns[1].AsString;
        if (sWildcard <> '') and not ADStrLike(sName, sWildcard, True) then
          lDeleteRow := True
        else begin
          oRow.SetData(4, sName);
          oRow.SetData(5, Integer(FStmt.Columns[0].AsInteger + 1));
          sTypeName := FStmt.Columns[2].AsString;
          FStmt.Database.DescribeColumn(rName.FCatalog, rName.FObject, sName,
            sTmp, sCollation, bNotNull, bInPK, bAutoInc, False);
          TypeName2ADDataType(sName, sTypeName, sBaseName, sBaseTypeName, eType,
            eAttrs, iLen, iPrec, iScale);
          Include(eAttrs, caBase);
          if (FStmt.Columns[3].AsInteger = 0) or not bNotNull then
            Include(eAttrs, caAllowNull);
          if FStmt.Columns[4].AsString <> '' then
            Include(eAttrs, caDefault);
          if bAutoInc then
            Include(eAttrs, caAutoInc);
          oRow.SetData(6, Smallint(eType));
          oRow.SetData(7, sBaseTypeName);
          oRow.SetData(8, PWord(@eAttrs)^);
          oRow.SetData(9, iPrec);
          oRow.SetData(10, iScale);
{$IFDEF AnyDAC_D6Base}
          oRow.SetData(11, iLen);
{$ELSE}
          oRow.SetData(11, Integer(iLen));
{$ENDIF}
        end;
      end;
    mkIndexes:
      begin
        oRow.SetData(0, iRecNo);
        oRow.SetData(1, rName.FCatalog);
        oRow.SetData(2, Null);
        oRow.SetData(3, rName.FObject);
        sName := FStmt.Columns[1].AsString;
        if (sWildcard <> '') and not ADStrLike(sName, sWildcard, True) then
          lDeleteRow := True
        else begin
          oRow.SetData(4, sName);
          oRow.SetData(5, Null);
          if FStmt.Columns[2].AsInteger = 0 then
            oRow.SetData(6, Smallint(ikNonUnique))
          else
            oRow.SetData(6, Smallint(ikUnique));
        end;
      end;
    mkIndexFields:
      begin
        oRow.SetData(0, iRecNo);
        oRow.SetData(1, rName.FCatalog);
        oRow.SetData(2, Null);
        oRow.SetData(3, rName.FBaseObject);
        oRow.SetData(4, rName.FObject);
        sName := FStmt.Columns[2].AsString;
        if (sWildcard <> '') and not ADStrLike(sName, sWildcard, True) then
          lDeleteRow := True
        else begin
          oRow.SetData(5, sName);
          oRow.SetData(6, Integer(FStmt.Columns[0].AsInteger + 1));
          oRow.SetData(7, 'A');
          oRow.SetData(8, Null);
        end;
      end;
    mkPrimaryKey:
      begin
        lDeleteRow := iRecNo > 1;
        if not lDeleteRow then begin
          oRow.SetData(0, iRecNo);
          oRow.SetData(1, rName.FCatalog);
          oRow.SetData(2, Null);
          oRow.SetData(3, rName.FObject);
          if (FStmt.Columns[5].AsInteger = 0) or
             (sWildcard <> '') and not ADStrLike(sName, sWildcard, True) then
            lDeleteRow := True
          else begin
            oRow.SetData(4, 'PRIMARY');
            oRow.SetData(5, 'PRIMARY');
            oRow.SetData(6, Smallint(ikPrimaryKey));
          end;
        end;
      end;
    mkPrimaryKeyFields:
      begin
        oRow.SetData(0, iRecNo);
        oRow.SetData(1, rName.FCatalog);
        oRow.SetData(2, Null);
        oRow.SetData(3, rName.FBaseObject);
        oRow.SetData(4, 'PRIMARY');
        sName := FStmt.Columns[1].AsString;
        if (FStmt.Columns[5].AsInteger = 0) or
           (sWildcard <> '') and not ADStrLike(sName, sWildcard, True) then
          lDeleteRow := True
        else begin
          oRow.SetData(5, sName);
          oRow.SetData(6, iRecNo);
          oRow.SetData(7, 'A');
          oRow.SetData(8, Null);
        end;
      end;
    mkForeignKeys:
      if FStmt.Columns[1].AsInteger > 0 then
        lDeleteRow := True
      else begin
        oRow.SetData(0, iRecNo);
        oRow.SetData(1, rName.FCatalog);
        oRow.SetData(2, Null);
        oRow.SetData(3, rName.FObject);
        oRow.SetData(4, 'FK_' + FStmt.Columns[0].AsString);
        oRow.SetData(5, rName.FCatalog);
        oRow.SetData(6, Null);
        oRow.SetData(7, FStmt.Columns[2].AsString);
        oRow.SetData(9, GetFKAction(FStmt.Columns[5].AsString));
        oRow.SetData(8, GetFKAction(FStmt.Columns[6].AsString));
      end;
    mkForeignKeyFields:
      if CompareText('FK_' + FStmt.Columns[0].AsString, rName.FObject) <> 0 then
        lDeleteRow := True
      else begin
        oRow.SetData(0, iRecNo);
        oRow.SetData(1, rName.FCatalog);
        oRow.SetData(2, Null);
        oRow.SetData(3, rName.FBaseObject);
        oRow.SetData(4, rName.FObject);
        oRow.SetData(5, FStmt.Columns[3].AsString);
        oRow.SetData(6, FStmt.Columns[4].AsString);
        oRow.SetData(7, Integer(FStmt.Columns[1].AsInteger + 1));
      end;
    end;
    if lDeleteRow then begin
      ADFree(oRow);
      Result := False;
    end
    else begin
      ATable.Rows.Add(oRow);
      Result := True;
    end;
  except
    ADFree(oRow);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysSQLiteCommand.InternalFetchRowSet(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowsetSize: LongWord): LongWord;
var
  i: LongWord;
begin
  Result := 0;
  if GetMetaInfoKind in [mkNone, mkTables] then
    for i := 1 to ARowsetSize do begin
      if not FStmt.Fetch then
        Break;
      FetchRow(ATable, AParentRow);
      Inc(Result);
    end
  else
    for i := 1 to ARowsetSize do begin
      if not FStmt.Fetch then
        Break;
      if FetchMetaRow(ATable, AParentRow, Result + 1) then
        Inc(Result);
    end;
end;

{-----------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterDriverClass(TADPhysSQLiteDriver);
  ADExtensionManager().AddExtension([TADPhysSQLitePostEventFunc]);

finalization
//  ADPhysManagerObj.UnRegisterDriverClass(TADPhysSQLiteConnection);

end.

