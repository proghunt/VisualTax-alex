{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{           FireDAC Interbase/Firebird driver           }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysIB"'}

unit uADPhysIB;

interface

uses
  Classes,
  uADDatSManager,
  uADPhysManager, uADPhysIBWrapper;

type
  TADPhysIBDriverLink = class;
  TADIBService = class;
  TADIBBackup = class;
  TADIBNBackup = class;
  TADIBRestore = class;
  TADIBNRestore = class;
  TADIBValidate = class;
  TADIBTrace = class;
  TADIBSecurity = class;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADPhysIBDriverLink = class(TADPhysDriverLink)
  protected
    function GetBaseDriverID: String; override;
  end;

  TADIBProtocol = (ipLocal, ipTCPIP, ipNetBEUI);

  TADIBService = class (TADPhysDriverService)
  private
    FQueryTimeout: LongWord;
    FProtocol: TADIBProtocol;
    FPassword: String;
    FHost: String;
    FUserName: String;
    FOnProgress: TADPhysServiceProgressEvent;
    FSqlRoleName: String;
    function GetDriverLink: TADPhysIBDriverLink;
    procedure SetDriverLink(const AValue: TADPhysIBDriverLink);
  protected
    // TADPhysDriverService
    procedure InternalExecute; override;
    // introduced
    function CreateService(AEnv: TIBEnv): TIBService; virtual; abstract;
    procedure SetupService(AService: TIBService); virtual;
    procedure QueryService(AService: TIBService); virtual;
    procedure DeleteService(var AService: TIBService); virtual;
    procedure DoProgress(AService: TIBService; const AMessage: String); virtual;
  published
    property DriverLink: TADPhysIBDriverLink read GetDriverLink write SetDriverLink;
    property Protocol: TADIBProtocol read FProtocol write FProtocol default ipLocal;
    property Host: String read FHost write FHost;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property SqlRoleName: String read FSqlRoleName write FSqlRoleName;
    property QueryTimeout: LongWord read FQueryTimeout write FQueryTimeout default 0;
    property OnProgress: TADPhysServiceProgressEvent read FOnProgress write FOnProgress;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADIBBackup = class (TADIBService)
  private
    FBackupFiles: TStrings;
    FVerbose: Boolean;
    FDatabase: String;
    FOptions: TIBBackupOptions;
    procedure SetBackupFiles(const AValue: TStrings);
  protected
    function CreateService(AEnv: TIBEnv): TIBService; override;
    procedure SetupService(AService: TIBService); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Backup;
  published
    property Database: String read FDatabase write FDatabase;
    property BackupFiles: TStrings read FBackupFiles write SetBackupFiles;
    property Verbose: Boolean read FVerbose write FVerbose default False;
    property Options: TIBBackupOptions read FOptions write FOptions default [];
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TADIBNBackup = class (TADIBService)
  private
    FLevel: Integer;
    FBackupFile: String;
    FDatabase: String;
    FOptions: TIBNBackupOptions;
  protected
    function CreateService(AEnv: TIBEnv): TIBService; override;
    procedure SetupService(AService: TIBService); override;
  public
    procedure Backup;
  published
    property Database: String read FDatabase write FDatabase;
    property BackupFile: String read FBackupFile write FBackupFile;
    property Level: Integer read FLevel write FLevel default 0;
    property Options: TIBNBackupOptions read FOptions write FOptions default [];
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADIBRestore = class (TADIBService)
  private
    FBackupFiles: TStrings;
    FVerbose: Boolean;
    FPageSize: LongWord;
    FDatabase: String;
    FOptions: TIBRestoreOptions;
    FPageBuffers: LongWord;
    procedure SetBackupFiles(const AValue: TStrings);
  protected
    function CreateService(AEnv: TIBEnv): TIBService; override;
    procedure SetupService(AService: TIBService); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Restore;
  published
    property Database: String read FDatabase write FDatabase;
    property BackupFiles: TStrings read FBackupFiles write SetBackupFiles;
    property Verbose: Boolean read FVerbose write FVerbose default False;
    property Options: TIBRestoreOptions read FOptions write FOptions default [];
    property PageSize: LongWord read FPageSize write FPageSize default 0;
    property PageBuffers: LongWord read FPageBuffers write FPageBuffers default 0;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TADIBNRestore = class (TADIBService)
  private
    FBackupFiles: TStrings;
    FDatabase: String;
    FOptions: TIBNBackupOptions;
    procedure SetBackupFile(const AValue: TStrings);
  protected
    function CreateService(AEnv: TIBEnv): TIBService; override;
    procedure SetupService(AService: TIBService); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Restore;
  published
    property Database: String read FDatabase write FDatabase;
    property BackupFiles: TStrings read FBackupFiles write SetBackupFile;
    property Options: TIBNBackupOptions read FOptions write FOptions default [];
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADIBValidate = class(TADIBService)
  private
    FMode: TIBRepairMode;
    FDatabase: String;
    FOptions: TIBRepairOptions;
  protected
    function CreateService(AEnv: TIBEnv): TIBService; override;
    procedure SetupService(AService: TIBService); override;
  public
    procedure CheckOnly;
    procedure Repair;
    procedure Sweep;
    procedure Analyze(const ATable: String = ''; const AIndex: String = '');
  published
    property Database: String read FDatabase write FDatabase;
    property Options: TIBRepairOptions read FOptions write FOptions default [];
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADIBTrace = class (TADIBService)
  private
    FAction: TIBTraceAction;
    FSessionName: String;
    FConfig: TStrings;
    FSessionID: Integer;
    FThread: TThread;
    procedure SetConfig(const AValue: TStrings);
  protected
    function CreateService(AEnv: TIBEnv): TIBService; override;
    procedure SetupService(AService: TIBService); override;
    procedure DoProgress(AService: TIBService; const AMessage: String); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;
    procedure Suspend;
    procedure Resume;
    procedure List;
  published
    property SessionName: String read FSessionName write FSessionName;
    property SessionID: Integer read FSessionID write FSessionID default 0;
    property Config: TStrings read FConfig write SetConfig;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADIBSecurity = class (TADIBService)
  private
    FAction: TIBSecurityAction;
    FValues: array [Low(TIBSecurityValue) .. High(TIBSecurityValue)] of String;
    FModified: TIBSecurityValues;
    FUsers: TADDatSTable;
    function GetInt(const AIndex: Integer): Integer;
    function GetStr(const AIndex: Integer): String;
    procedure SetInt(const AIndex, AValue: Integer);
    procedure SetStr(const AIndex: Integer; const AValue: String);
    function IsStored(const AIndex: Integer): Boolean;
  protected
    function CreateService(AEnv: TIBEnv): TIBService; override;
    procedure SetupService(AService: TIBService); override;
    procedure QueryService(AService: TIBService); override;
    procedure DeleteService(var AService: TIBService); override;
  public
    property Users: TADDatSTable read FUsers;
    procedure AddUser;
    procedure DeleteUser;
    procedure ModifyUser;
    procedure DisplayUser;
    procedure DisplayUsers;
  published
    property Modified: TIBSecurityValues read FModified write FModified default [];
    property AUserName: String index ord(svUserName) read GetStr write SetStr stored IsStored;
    property APassword: String index ord(svPassword) read GetStr write SetStr stored IsStored;
    property AFirstName: String index ord(svFirstName) read GetStr write SetStr stored IsStored;
    property AMiddleName: String index ord(svMiddleName) read GetStr write SetStr stored IsStored;
    property ALastName: String index ord(svLastName) read GetStr write SetStr stored IsStored;
    property AUserID: Integer index ord(svUserID) read GetInt write SetInt stored IsStored;
    property AGroupID: Integer index ord(svGroupID) read GetInt write SetInt stored IsStored;
    property AGroupName: String index ord(svGroupName) read GetStr write SetStr stored IsStored;
    property ARoleName: String index ord(svRoleName) read GetStr write SetStr stored IsStored;
  end;

{-------------------------------------------------------------------------------}
implementation

uses
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}
  SysUtils, DB,
  uADStanIntf, uADStanParam, uADStanError, uADStanOption, uADStanUtil,
    uADStanConst,
  uADPhysIntf, uADPhysIBMeta, uADPhysCmdGenerator, uADPhysIBCli;

type
  TADPhysIBDriver = class;
  TADPhysIBConnection = class;
  TADPhysIBTransaction = class;
  TADPhysIBEventAlerter = class;
  TADPhysIBCommand = class;

  TADPhysIBCliHandles = array [0..1] of PPointer;
  PADPhysIBCliHandles = ^TADPhysIBCliHandles;

  TADPhysIBDriver = class(TADPhysDriver)
  private
    FLib: TIBLib;
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

  TADPhysIBConnection = class(TADPhysConnection)
  private
    FEnv: TIBEnv;
    FDatabase: TIBDatabase;
    FDialect: Word;
    FServerVersion: TADVersion;
    FServerBrand: TADPhysIBBrand;
    FCliHandles: TADPhysIBCliHandles;
    FSharedTxHandle: IscTrHandle;
    FMetaTransaction: IADPhysTransaction;
    FExtendedMetadata: Boolean;
  protected
    procedure InternalConnect; override;
    procedure InternalDisconnect; override;
    procedure InternalPing; override;
    procedure InternalChangePassword(const AUserName, AOldPassword, ANewPassword: String); override;
    function InternalCreateTransaction: TADPhysTransaction; override;
    function InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter; override;
    function InternalCreateCommand: TADPhysCommand; override;
    function InternalCreateMetaInfoCommand: TADPhysCommand; override;
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
    procedure InternalAnalyzeSession(AMessages: TStrings); override;
  public
    constructor Create(ADriverObj: TADPhysDriver; AConnHost: TADPhysConnectionHost); override;
    destructor Destroy; override;
  end;

  TADPhysIBTransaction = class(TADPhysTransaction)
  private
    FParams: TStrings;
    FTransaction: TIBTransaction;
    function GetIBConnection: TADPhysIBConnection;
  protected
    // IADMoniAdapter
    function GetItemCount: Integer; override;
    procedure GetItem(AIndex: Integer; out AName: String; out AValue: Variant;
      out AKind: TADMoniAdapterItemKind); override;
    // TADPhysTransaction
    procedure InternalStartTransaction(AID: LongWord); override;
    procedure InternalCommit(AID: LongWord); override;
    procedure InternalRollback(AID: LongWord); override;
    procedure InternalChanged; override;
    procedure InternalAllocHandle; override;
    procedure InternalReleaseHandle; override;
    procedure InternalNotify(ANotification: TADPhysTxNotification;
      ACommandObj: TADPhysCommand); override;
    function GetCliObj: Pointer; override;
    property IBConnection: TADPhysIBConnection read GetIBConnection;
  end;

  TADPhysIBEventAlerter = class(TADPhysEventAlerter)
  private
    FEvents: TIBEvents;
    FEventsConnection: IADPhysConnection;
    procedure DoFired(AEvents: TIBEvents; ABaseIndex: Integer;
      const ACounts: TISCStatusVector);
  protected
    // TADPhysEventAlerter
    procedure InternalAllocHandle; override;
    procedure InternalRegister; override;
    procedure InternalHandle(AEventMessage: TADPhysEventMessage); override;
    procedure InternalUnregister; override;
    procedure InternalReleaseHandle; override;
    procedure InternalSignal(const AEvent: String; const AArgument: Variant); override;
  end;

  TADIBColInfoRec = record
    FVar: TIBVariable;
    FName: String;
    FOriginTabName,
    FOriginColName: String;
    FPos: Integer;
    FLen,
    FPrec,
    FScale: SmallInt;
    FSrcSQLDataType,
    FSrcSQLSubType: SmallInt;
    FSrcDataType,
    FDestDataType: TADDataType;
    FSrcTypeName: String;
    FAttrs: TADDataAttributes;
    FADLen: LongWord;
    FInPK: Boolean;
  end;
  PADIBColInfoRec = ^TADIBColInfoRec;

  TADIBParInfoRec = record
    FVar: TIBVariable;
    FParamIndex: Integer;
    FLen,
    FPrec,
    FScale: SmallInt;
    FDestSQLDataType,
    FDestSQLSubType: SmallInt;
    FDestDataType,
    FSrcDataType: TADDataType;
    FADLen: LongWord;
    FSrcFieldType: TFieldType;
    FSrcSize: LongWord;
    FSrcPrec: Integer;
    FSrcScale: Integer;
    FParamType: TParamType;
  end;
  PADIBParInfoRec = ^TADIBParInfoRec;

  TADPhysIBCommand = class(TADPhysCommand)
  private
    FStmt: TIBStatement;
    FColInfos: array of TADIBColInfoRec;
    FParInfos: array of TADIBParInfoRec;
    FColumnIndex: Integer;
    FSPParsedName: TADPhysParsedName;
    FCursorCanceled: Boolean;
    FMaxInputPos: Integer;
    FRetWithOut: Boolean;
    function GetConnection: TADPhysIBConnection; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    procedure SetupStatement(AStmt: TIBStatement);
    procedure CreateColInfos;
    procedure DestroyColInfos;
    procedure CreateParamInfos(AVars: TIBVariables; AInput, AFB2Batch: Boolean);
    procedure DestroyParamInfos;
    procedure SQL2ADColInfo(ASQLDataType, ASQLSubType, ASQLLen, ASQLPrec,
      ASQLScale: Smallint; out AType: TADDataType; var AAttrs: TADDataAttributes;
      out ALen: LongWord; out APrec, AScale: Integer; AFmtOpts: TADFormatOptions);
    procedure SetParamValue(AFmtOpts: TADFormatOptions; AParam: TADParam;
      AVar: TIBVariable; ApInfo: PADIBParInfoRec; AVarIndex, AParIndex: Integer);
    procedure SetParamValues(ATimes, AOffset: Integer);
    procedure SetFB2BatchParamValues(AStmt: TIBStatement; ATimes, AOffset: Integer);
    procedure GetParamValue(AFmtOpts: TADFormatOptions; AParam: TADParam;
      AVar: TIBVariable; ApInfo: PADIBParInfoRec; AVarIndex,
      AParIndex: Integer);
    procedure GetParamValues(ATimes, AOffset: Integer);
    procedure GetFB2BatchParamValues(AStmt: TIBStatement; ATimes,
      AOffset: Integer);
    procedure DoExecuteIB2007Batch(ATimes, AOffset: Integer; var ACount: TADCounter);
    function GenerateFB2BatchSQL(ATimes, AOffset: Integer): String;
    procedure DoExecuteFB2Batch(ATimes, AOffset: Integer; var ACount: TADCounter);
    procedure DoExecute(ATimes, AOffset: Integer; var ACount: TADCounter);
    procedure FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
    function UseExecDirect: Boolean;
    function IsReturning: Boolean;
    procedure CheckColInfos;
    procedure CheckParamInfos;
    procedure PrepareBase;
    procedure CheckSPPrepared(ASPUsage: TADPhysCommandKind);
  protected
    procedure InternalAbort; override;
    procedure InternalClose; override;
    procedure InternalExecute(ATimes: LongInt; AOffset: LongInt; var ACount: TADCounter); override;
    function InternalFetchRowSet(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowsetSize: LongWord): LongWord; override;
    function InternalOpen: Boolean; override;
    function InternalNextRecordSet: Boolean; override;
    procedure InternalPrepare; override;
    function InternalUseStandardMetadata: Boolean; override;
    function InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean; override;
    function InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean; override;
    procedure InternalUnprepare; override;
    function GetCliObj: Pointer; override;
    function GetItemCount: Integer; override;
    procedure GetItem(AIndex: Integer; out AName: String;
      out AValue: Variant; out AKind: TADMoniAdapterItemKind); override;
  public
    property IBConnection: TADPhysIBConnection read GetConnection;
    property IBStatement: TIBStatement read FStmt;
  end;

const
  S_AD_UTF8 = 'UTF8';
  S_AD_UnicodeFSS = 'UNICODE_FSS';
  S_AD_CharacterSets = 'NONE;ASCII;BIG_5;CYRL;DOS437;DOS850;DOS852;DOS857;' +
    'DOS860;DOS861;DOS863;DOS865;EUCJ_0208;GB_2312;ISO8859_1;' +
    'ISO8859_2;KSC_5601;NEXT;OCTETS;SJIS_0208;' + S_AD_UnicodeFSS + ';' +
    'WIN1250;WIN1251;WIN1252;WIN1253;WIN1254;' +
    // FB 1.5
    'DOS737;DOS775;DOS858;DOS862;DOS864;DOS866;DOS869;' +
    'WIN1255;WIN1256;WIN1257;ISO8859_3;ISO8859_4;ISO8859_5;' +
    'ISO8859_6;ISO8859_7;ISO8859_8;ISO8859_9;ISO8859_13;' +
    // IB 7.1
    'ISO8859_15;' +
    // FB 2.0
    'KOI8R;KOI8U;' + S_AD_UTF8 + ';' +
    // IB 2007
    'UNICODE_LE;UNICODE_BE';
  S_AD_Local = 'Local';
  S_AD_NetBEUI = 'NetBEUI';
  S_AD_NovelSPX = 'SPX';
  S_AD_TCPIP = 'TCPIP';

{-------------------------------------------------------------------------------}
{ TADPhysIBDriverLink                                                           }
{-------------------------------------------------------------------------------}
function TADPhysIBDriverLink.GetBaseDriverID: String;
begin
  Result := S_AD_IBId;
end;

{-------------------------------------------------------------------------------}
{ TADIBService                                                                  }
{-------------------------------------------------------------------------------}
function TADIBService.GetDriverLink: TADPhysIBDriverLink;
begin
  Result := inherited DriverLink as TADPhysIBDriverLink;
end;

{-------------------------------------------------------------------------------}
procedure TADIBService.SetDriverLink(const AValue: TADPhysIBDriverLink);
begin
  inherited DriverLink := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADIBService.SetupService(AService: TIBService);
begin
  AService.Protocol := Integer(Protocol);
  AService.Host := Host;
  AService.UserName := UserName;
  AService.Password := Password;
  AService.SqlRoleName := SqlRoleName;
  AService.QueryTimeout := QueryTimeout;
end;

{-------------------------------------------------------------------------------}
procedure TADIBService.DeleteService(var AService: TIBService);
begin
  ADFree(AService);
  AService := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADIBService.DoProgress(AService: TIBService; const AMessage: String);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, AMessage);
end;

{-------------------------------------------------------------------------------}
procedure TADIBService.QueryService(AService: TIBService);
var
  sMsg: String;
begin
  while not AService.QueryString(sMsg) do
    DoProgress(AService, sMsg);
end;

{-------------------------------------------------------------------------------}
procedure TADIBService.InternalExecute;
var
  oEnv: TIBEnv;
  oSvc: TIBService;
begin
  oEnv := TIBEnv.Create(CliObj as TIBLib, Self);
  oSvc := CreateService(oEnv);
  try
    SetupService(oSvc);
    oSvc.Attach;
    try
      oSvc.Start;
      QueryService(oSvc);
    finally
      oSvc.Detach;
    end;
  finally
    DeleteService(oSvc);
    ADFree(oEnv);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADIBBackup                                                                   }
{-------------------------------------------------------------------------------}
constructor TADIBBackup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBackupFiles := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADIBBackup.Destroy;
begin
  ADFreeAndNil(FBackupFiles);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADIBBackup.SetBackupFiles(const AValue: TStrings);
begin
  FBackupFiles.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADIBBackup.CreateService(AEnv: TIBEnv): TIBService;
begin
  Result := TIBBackup.Create(AEnv, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADIBBackup.SetupService(AService: TIBService);
begin
  inherited SetupService(AService);
  TIBBackup(AService).DatabaseName := Database;
  TIBBackup(AService).BackupFiles := BackupFiles;
  TIBBackup(AService).Verbose := Verbose;
  TIBBackup(AService).Options := Options;
end;

{-------------------------------------------------------------------------------}
procedure TADIBBackup.Backup;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
{ TADIBNBackup                                                                  }
{-------------------------------------------------------------------------------}
function TADIBNBackup.CreateService(AEnv: TIBEnv): TIBService;
begin
  Result := TIBNBackup.Create(AEnv, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADIBNBackup.SetupService(AService: TIBService);
begin
  inherited SetupService(AService);
  TIBNBackup(AService).DatabaseName := Database;
  TIBNBackup(AService).BackupFile := BackupFile;
  TIBNBackup(AService).Level := Level;
  TIBNBackup(AService).Options := Options;
end;

{-------------------------------------------------------------------------------}
procedure TADIBNBackup.Backup;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
{ TADIBRestore                                                                  }
{-------------------------------------------------------------------------------}
constructor TADIBRestore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBackupFiles := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADIBRestore.Destroy;
begin
  ADFreeAndNil(FBackupFiles);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADIBRestore.SetBackupFiles(const AValue: TStrings);
begin
  FBackupFiles.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADIBRestore.CreateService(AEnv: TIBEnv): TIBService;
begin
  Result := TIBRestore.Create(AEnv, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADIBRestore.SetupService(AService: TIBService);
begin
  inherited SetupService(AService);
  TIBRestore(AService).DatabaseName := Database;
  TIBRestore(AService).BackupFiles := BackupFiles;
  TIBRestore(AService).Verbose := Verbose;
  TIBRestore(AService).Options := Options;
  TIBRestore(AService).PageSize := PageSize;
  TIBRestore(AService).PageBuffers := PageBuffers;
end;

{-------------------------------------------------------------------------------}
procedure TADIBRestore.Restore;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
{ TADIBNRestore                                                                 }
{-------------------------------------------------------------------------------}
constructor TADIBNRestore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBackupFiles := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADIBNRestore.Destroy;
begin
  ADFreeAndNil(FBackupFiles);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADIBNRestore.SetBackupFile(const AValue: TStrings);
begin
  FBackupFiles.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADIBNRestore.CreateService(AEnv: TIBEnv): TIBService;
begin
  Result := TIBNRestore.Create(AEnv, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADIBNRestore.SetupService(AService: TIBService);
begin
  inherited SetupService(AService);
  TIBNRestore(AService).DatabaseName := Database;
  TIBNRestore(AService).BackupFiles := BackupFiles;
  TIBNRestore(AService).Options := Options;
end;

{-------------------------------------------------------------------------------}
procedure TADIBNRestore.Restore;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
{ TADIBValidate                                                                 }
{-------------------------------------------------------------------------------}
function TADIBValidate.CreateService(AEnv: TIBEnv): TIBService;
begin
  Result := TIBRepair.Create(AEnv, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADIBValidate.SetupService(AService: TIBService);
begin
  inherited SetupService(AService);
  TIBRepair(AService).DatabaseName := Database;
  TIBRepair(AService).Mode := FMode;
  TIBRepair(AService).Options := Options;
end;

{-------------------------------------------------------------------------------}
procedure TADIBValidate.CheckOnly;
begin
  FMode := rmCheckOnly;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADIBValidate.Repair;
begin
  FMode := rmRepair;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADIBValidate.Sweep;
begin
  FMode := rmSweep;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADIBValidate.Analyze(const ATable, AIndex: String);
const
  C_Prots: array [TADIBProtocol] of String = (S_AD_Local, S_AD_TCPIP, S_AD_NetBEUI);
var
  sConnStr: String;
  oConn: IADPhysConnection;
  oCmd: IADPhysCommand;

  procedure Add(const AParam, AValue: String);
  begin
    if AValue <> '' then begin
      if sConnStr <> '' then
        sConnStr := sConnStr + ';';
      sConnStr := sConnStr + AParam + '=' + AValue;
    end;
  end;

begin
  if Assigned(BeforeExecute) then
    BeforeExecute(Self);
  CheckActive(False, False);
  Add(S_AD_ConnParam_Common_DriverID, DriverLink.ActualDriverID);
  Add(S_AD_ConnParam_IB_Protocol, C_Prots[Protocol]);
  Add(S_AD_ConnParam_Common_Server, Host);
  Add(S_AD_ConnParam_Common_UserName, UserName);
  Add(S_AD_ConnParam_Common_Password, Password);
  Add(S_AD_ConnParam_Common_Database, Database);
  Add(S_AD_ConnParam_IB_SQLDialect, '3');
  ADPhysManager.CreateConnection(sConnStr, oConn);
  oConn.ErrorHandler := Self as IADStanErrorHandler;
  oConn.Open;
  oConn.CreateCommand(oCmd);
  oCmd.Options.ResourceOptions.CmdExecMode := amBlocking;
  oCmd.Options.ResourceOptions.PreprocessCmdText := False;
  if AIndex <> '' then
    oCmd.Prepare('SET STATISTICS INDEX ' + AIndex)
  else if ATable <> '' then
    oCmd.Prepare('EXECUTE BLOCK AS' + C_AD_EOL +
                 'DECLARE VARIABLE index_name VARCHAR(31);' + C_AD_EOL +
                 'BEGIN' + C_AD_EOL +
                 'FOR SELECT RDB$INDEX_NAME FROM RDB$INDICES INTO :index_name WHERE RDB$RELATION_NAME = ''' + ATable + ''' DO' + C_AD_EOL +
                 'EXECUTE STATEMENT ''SET STATISTICS INDEX "'' || :index_name || ''";'';' + C_AD_EOL +
                 'END')
  else
    oCmd.Prepare('EXECUTE BLOCK AS' + C_AD_EOL +
                 'DECLARE VARIABLE index_name VARCHAR(31);' + C_AD_EOL +
                 'BEGIN' + C_AD_EOL +
                 'FOR SELECT RDB$INDEX_NAME FROM RDB$INDICES INTO :index_name DO' + C_AD_EOL +
                 'EXECUTE STATEMENT ''SET STATISTICS INDEX "'' || :index_name || ''";'';' + C_AD_EOL +
                 'END');
  oCmd.Execute();
  if Assigned(AfterExecute) then
    AfterExecute(Self);
end;

{-------------------------------------------------------------------------------}
{ TADIBTraceThread                                                              }
{-------------------------------------------------------------------------------}
type
  TADIBTraceThread = class(TThread)
  private
    FTrace: TADIBTrace;
  protected
    procedure Execute; override;
  public
    constructor Create(ATrace: TADIBTrace);
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
constructor TADIBTraceThread.Create(ATrace: TADIBTrace);
begin
  FTrace := ATrace;
  FTrace.FThread := Self;
  FreeOnTerminate := True;
  inherited Create(False);
end;

{-------------------------------------------------------------------------------}
destructor TADIBTraceThread.Destroy;
begin
  FTrace.FThread := nil;
  FTrace := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADIBTraceThread.Execute;
begin
  FTrace.FAction := taStart;
  FTrace.Execute;
end;

{-------------------------------------------------------------------------------}
{ TADIBTrace                                                                    }
{-------------------------------------------------------------------------------}
constructor TADIBTrace.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConfig := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADIBTrace.Destroy;
begin
  if FThread <> nil then
    Stop;
  ADFreeAndNil(FConfig);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADIBTrace.SetConfig(const AValue: TStrings);
begin
  FConfig.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADIBTrace.CreateService(AEnv: TIBEnv): TIBService;
begin
  Result := TIBTrace.Create(AEnv, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADIBTrace.SetupService(AService: TIBService);
begin
  inherited SetupService(AService);
  TIBTrace(AService).Action := FAction;
  TIBTrace(AService).SessionName := SessionName;
  TIBTrace(AService).SessionID := SessionID;
  TIBTrace(AService).Config := Config;
end;

{-------------------------------------------------------------------------------}
procedure TADIBTrace.DoProgress(AService: TIBService; const AMessage: String);
begin
  if TIBTrace(AService).Action = taStart then
    SessionID := TIBTrace(AService).SessionID;
  inherited DoProgress(AService, AMessage);
end;

{-------------------------------------------------------------------------------}
procedure TADIBTrace.Start;
begin
  CheckActive(False, False);
  if FThread <> nil then
    ADException(Self, [S_AD_LPhys, DriverLink.ActualDriverID], er_AD_IBTraceIsActive, []);
  TADIBTraceThread.Create(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADIBTrace.Stop;
begin
  FAction := taStop;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADIBTrace.Suspend;
begin
  FAction := taSuspend;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADIBTrace.Resume;
begin
  FAction := taResume;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADIBTrace.List;
begin
  FAction := taList;
  Execute;
end;

{-------------------------------------------------------------------------------}
{ TADIBSecurity                                                                 }
{-------------------------------------------------------------------------------}
function TADIBSecurity.GetInt(const AIndex: Integer): Integer;
begin
  Result := StrToIntDef(GetStr(AIndex), 0);
end;

{-------------------------------------------------------------------------------}
procedure TADIBSecurity.SetInt(const AIndex, AValue: Integer);
begin
  SetStr(AIndex, IntToStr(AValue));
end;

{-------------------------------------------------------------------------------}
function TADIBSecurity.GetStr(const AIndex: Integer): String;
begin
  Result := FValues[TIBSecurityValue(AIndex)];
end;

{-------------------------------------------------------------------------------}
procedure TADIBSecurity.SetStr(const AIndex: Integer; const AValue: String);
begin
  Include(FModified, TIBSecurityValue(AIndex));
  FValues[TIBSecurityValue(AIndex)] := AValue;
end;

{-------------------------------------------------------------------------------}
function TADIBSecurity.IsStored(const AIndex: Integer): Boolean;
begin
  Result := TIBSecurityValue(AIndex) in FModified;
end;

{-------------------------------------------------------------------------------}
function TADIBSecurity.CreateService(AEnv: TIBEnv): TIBService;
begin
  Result := TIBSecurity.Create(AEnv, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADIBSecurity.SetupService(AService: TIBService);
var
  i: TIBSecurityValue;
begin
  inherited SetupService(AService);
  TIBSecurity(AService).Action := FAction;
  TIBSecurity(AService).Modified := [];
  for i := Low(TIBSecurityValue) to High(TIBSecurityValue) do
    if i in Modified then
      TIBSecurity(AService).SetStr(Integer(i), FValues[i]);
end;

{-------------------------------------------------------------------------------}
procedure TADIBSecurity.QueryService(AService: TIBService);
begin
  if TIBSecurity(AService).Action in [saDisplayUser, saDisplayUsers] then
    TIBSecurity(AService).QuerySecurity
  else
    inherited QueryService(AService);
end;

{-------------------------------------------------------------------------------}
procedure TADIBSecurity.DeleteService(var AService: TIBService);
var
  i: TIBSecurityValue;
begin
  case TIBSecurity(AService).Action of
  saDisplayUser:
    begin
      for i := Low(TIBSecurityValue) to High(TIBSecurityValue) do
        SetStr(Integer(i), TIBSecurity(AService).GetStr(Integer(i)));
      Modified := [];
    end;
  saDisplayUsers:
    begin
      FUsers := TIBSecurity(AService).Users;
      FUsers.AddRef;
    end;
  end;
  inherited DeleteService(AService);
end;

{-------------------------------------------------------------------------------}
procedure TADIBSecurity.AddUser;
begin
  FAction := saAddUser;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADIBSecurity.DeleteUser;
begin
  FAction := saDeleteUser;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADIBSecurity.ModifyUser;
begin
  FAction := saModifyUser;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADIBSecurity.DisplayUser;
begin
  FAction := saDisplayUser;
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADIBSecurity.DisplayUsers;
begin
  FAction := saDisplayUsers;
  Execute;
end;

{-------------------------------------------------------------------------------}
{ TADPhysIBDriver                                                               }
{-------------------------------------------------------------------------------}
constructor TADPhysIBDriver.Create(AManager: TADPhysManager;
  const ADriverDef: IADStanDefinition);
begin
  inherited Create(AManager, ADriverDef);
  FLib := TIBLib.Create(ADPhysManagerObj);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysIBDriver.Destroy;
begin
  inherited Destroy;
  ADFreeAndNil(FLib);
end;

{-------------------------------------------------------------------------------}
class function TADPhysIBDriver.GetBaseDriverID: String;
begin
  Result := S_AD_IBId;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBDriver.InternalLoad;
var
  sHome, sLib: String;
begin
  sHome := '';
  sLib := '';
  GetVendorParams(sHome, sLib);
  FLib.Load(sHome, sLib);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBDriver.InternalUnload;
begin
  FLib.Unload;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBDriver.InternalCreateConnection(
  AConnHost: TADPhysConnectionHost): TADPhysConnection;
begin
  Result := TADPhysIBConnection.Create(Self, AConnHost);
end;

{-------------------------------------------------------------------------------}
function TADPhysIBDriver.GetCliObj: Pointer;
begin
  Result := FLib;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := inherited GetConnParamCount(AKeys) + 11;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBDriver.GetConnParams(AKeys: TStrings; AIndex: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
begin
  ALoginIndex := -1;
  if AIndex < inherited GetConnParamCount(AKeys) then begin
    inherited GetConnParams(AKeys, AIndex, AName, AType, ADefVal, ACaption, ALoginIndex);
    if AName = S_AD_ConnParam_Common_Database then begin
      ALoginIndex := 2;
      AType := '@F:Firebird Database|*.fdb;*.fb|Interbase Database|*.gdb;*.ib';
    end;
  end
  else begin
    case AIndex - inherited GetConnParamCount(AKeys) of
    0:
      begin
        AName := S_AD_ConnParam_Common_OSAuthent;
        AType := '@Y';
        ADefVal := '';
      end;
    1:
      begin
        AName := S_AD_ConnParam_IB_Protocol;
        AType := S_AD_Local + ';' + S_AD_NetBEUI + ';' + S_AD_NovelSPX + ';' + S_AD_TCPIP;
        ADefVal := S_AD_Local;
      end;
    2:
      begin
        AName := S_AD_ConnParam_Common_Server;
        AType := '@S';
        ADefVal := '';
      end;
    3:
      begin
        AName := S_AD_ConnParam_IB_InstanceName;
        AType := '@S';
        ADefVal := '';
      end;
    4:
      begin
        AName := S_AD_ConnParam_IB_SQLDialect;
        AType := '@I';
        ADefVal := '3';
      end;
    5:
      begin
        AName := S_AD_ConnParam_IB_RoleName;
        AType := '@S';
        ADefVal := '';
      end;
    6:
      begin
        AName := S_AD_ConnParam_Common_CharacterSet;
        AType := S_AD_CharacterSets;
        ADefVal := '';
      end;
    7:
      begin
        AName := S_AD_ConnParam_Common_ExtendedMetadata;
        AType := '@L';
        ADefVal := S_AD_False;
      end;
    8:
      begin
        AName := S_AD_ConnParam_IB_CreateDatabase;
        AType := '@Y';
        ADefVal := S_AD_No;
      end;
    9:
      begin
        AName := S_AD_ConnParam_IB_PageSize;
        AType := '1024;2048;4096;8192;16384';
        ADefVal := '1024';
      end;
    10:
      begin
        AName := S_AD_ConnParam_IB_Advanced;
        AType := '@S';
        ADefVal := '';
      end;
    end;
    ACaption := AName;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysIBConnection                                                           }
{-------------------------------------------------------------------------------}
constructor TADPhysIBConnection.Create(ADriverObj: TADPhysDriver;
  AConnHost: TADPhysConnectionHost);
var
  oOpts: TADTxOptions;
begin
  FEnv := TIBEnv.Create(TADPhysIBDriver(ADriverObj).FLib, Self);
  inherited Create(ADriverObj, AConnHost);
  CreateTransaction(FMetaTransaction);
  _Release;
  oOpts := FMetaTransaction.Options;
  oOpts.AutoCommit := True;
  oOpts.ReadOnly := True;
  oOpts.Isolation := xiReadCommitted;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysIBConnection.Destroy;
begin
  ADHighRefCounter(FRefCount);
  ForceDisconnect;
  FMetaTransaction := nil;
  ADFreeAndNil(FEnv);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBConnection.InternalCreateTransaction: TADPhysTransaction;
begin
  Result := TADPhysIBTransaction.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysIBConnection.InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter;
begin
  if CompareText(AEventKind, S_AD_EventKind_IB_Events) = 0 then
    Result := TADPhysIBEventAlerter.Create(Self, AEventKind)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBConnection.InternalCreateCommand: TADPhysCommand;
begin
  Result := TADPhysIBCommand.Create(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysIBConnection.InternalCreateMetaInfoCommand: TADPhysCommand;
begin
  Result := inherited InternalCreateMetaInfoCommand;
  TADPhysIBCommand(Result).SetTransaction(FMetaTransaction);
end;

{-------------------------------------------------------------------------------}
function TADPhysIBConnection.InternalCreateCommandGenerator(
  const ACommand: IADPhysCommand): TADPhysCommandGenerator;
begin
  if ACommand <> nil then
    Result := TADPhysIBCommandGenerator.Create(ACommand,
      FEnv.Lib.IDUTF8, FDatabase.Encoder.Encoding)
  else
    Result := TADPhysIBCommandGenerator.Create(Self,
      FEnv.Lib.IDUTF8, FDatabase.Encoder.Encoding);
end;

{-------------------------------------------------------------------------------}
function TADPhysIBConnection.InternalCreateMetadata: TObject;
begin
  Result := TADPhysIBMetadata.Create(Self, FEnv.Lib.Brand, FServerVersion,
    FEnv.Lib.Version, FDialect,
    (FDatabase <> nil) and (FDatabase.Encoder.Encoding in [ecUTF8, ecUTF16]));
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TADPhysIBConnection.InternalTracingChanged;
begin
  if FEnv <> nil then begin
    FEnv.Monitor := FMonitor;
    FEnv.Tracing := FTracing;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADPhysIBConnection.InternalConnect;
var
  oParams: TADStringList;
  sCharSet: String;
  pCliHandles: PADPhysIBCliHandles;
  i: Integer;
  sAdv: String;
  oStrs: TStrings;
  sDB, sProt, sSrv: String;
begin
  if InternalGetSharedCliHandle() <> nil then begin
    pCliHandles := PADPhysIBCliHandles(InternalGetSharedCliHandle());
    FDatabase := TIBDatabase.CreateUsingHandle(FEnv, pCliHandles^[0], Self);
    FSharedTxHandle := pCliHandles^[1];
  end
  else begin
    FDatabase := TIBDatabase.Create(FEnv, Self);
    FSharedTxHandle := nil;
  end;
{$IFDEF AnyDAC_MONITOR}
  InternalTracingChanged;
{$ENDIF}

  sCharSet := GetConnectionDef.AsString[S_AD_ConnParam_Common_CharacterSet];
  if (CompareText(sCharSet, S_AD_UTF8) = 0) or (CompareText(sCharSet, S_AD_UnicodeFSS) = 0) then
    FDatabase.Encoder.Encoding := ecUTF8
  else
    FDatabase.Encoder.Encoding := ecANSI;
  if GetConnectionDef.HasValue(S_AD_ConnParam_Common_ExtendedMetadata) then
    FExtendedMetadata := GetConnectionDef.AsBoolean[S_AD_ConnParam_Common_ExtendedMetadata]
  else
    FExtendedMetadata := False;

  if GetConnectionDef.HasValue(S_AD_ConnParam_IB_SQLDialect) then
    FDialect := Word(GetConnectionDef.AsInteger[S_AD_ConnParam_IB_SQLDialect])
  else
    FDialect := 3;

  sDB := GetConnectionDef.ExpandedDatabase;
  sSrv := GetConnectionDef.Server;
  if GetConnectionDef.HasValue(S_AD_ConnParam_IB_Protocol) or (sSrv <> '') then begin
    sProt := GetConnectionDef.AsString[S_AD_ConnParam_IB_Protocol];
    if CompareText(sProt, S_AD_NetBEUI) = 0 then
      sDB := '\\' + sSrv + '\' + sDB
    else if CompareText(sProt, S_AD_NovelSPX) = 0 then
      sDB := sSrv + '@' + sDB
    else if (CompareText(sProt, S_AD_TCPIP) = 0) or (sSrv <> '') then
      sDB := sSrv + ':' + sDB
  end;

  if InternalGetSharedCliHandle() = nil then begin
    oParams := TADStringList.Create;
    try
{$IFDEF AnyDAC_D6}
      oParams.CaseSensitive := False;
{$ENDIF}
      i := 1;
      sAdv := GetConnectionDef.AsString[S_AD_ConnParam_IB_Advanced];
      while i <= Length(sAdv) do
        oParams.Add(ADExtractFieldName(sAdv, i));
      if GetConnectionDef.HasValue(S_AD_ConnParam_IB_InstanceName) then
        oParams.Add('instance_name=' + GetConnectionDef.AsString[S_AD_ConnParam_IB_InstanceName]);
      if GetConnectionDef.HasValue(S_AD_ConnParam_Common_OSAuthent) and
         GetConnectionDef.GetOSAuthent then
        oParams.Add('trusted_auth')
      else begin
        if GetConnectionDef.HasValue(S_AD_ConnParam_Common_UserName) then
          oParams.Add('user_name=' + GetConnectionDef.UserName);
        if GetConnectionDef.HasValue(S_AD_ConnParam_Common_Password) then
          oParams.Add('password=' + GetConnectionDef.Password);
      end;
      if GetConnectionDef.HasValue(S_AD_ConnParam_IB_RoleName) then
        oParams.Add('sql_role_name=' + GetConnectionDef.AsString[S_AD_ConnParam_IB_RoleName]);
      if sCharSet <> '' then
        oParams.Add('lc_ctype=' + sCharSet);
      if GetConnectionDef.HasValue(S_AD_ConnParam_IB_PageSize) then
        oParams.Add('page_size=' + GetConnectionDef.AsString[S_AD_ConnParam_IB_PageSize]);
      oParams.Add('sql_dialect=' + IntToStr(FDialect));
      if GetConnectionDef.AsYesNo[S_AD_ConnParam_IB_CreateDatabase] then
        FDatabase.CreateDatabase(sDB, oParams)
      else
        FDatabase.Attach(sDB, oParams);
    finally
      ADFree(oParams);
    end;
  end;

  if FEnv.Lib.Brand in [ibFirebird, ibYaffil] then
    oStrs := FDatabase.firebird_version
  else
    oStrs := FDatabase.isc_version;
  if oStrs.Count >= 2 then
    i := 1
  else
    i := 0;
  FServerVersion := ADVerStr2Int(oStrs[i]);
  if Pos('Firebird', oStrs[i]) > 0 then
    FServerBrand := ibFirebird
  else if (Pos('Interbase', oStrs[i]) > 0) or (Pos('WI-V', oStrs[i]) > 0) or
          (Pos('DE-V', oStrs[i]) > 0) then
    FServerBrand := ibInterbase
  else
    FServerBrand := ibYaffil;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBConnection.InternalDisconnect;
begin
  if GetConnectionDef.AsYesNo[S_AD_ConnParam_IB_DropDatabase] then
    FDatabase.Drop;
  ADFreeAndNil(FDatabase);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBConnection.InternalPing;
begin
  FDatabase.Ping;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBConnection.InternalChangePassword(const AUserName, AOldPassword,
  ANewPassword: String);
begin
  if (FEnv.Lib.Brand = ibFirebird) and (FServerVersion >= ivFB020500) then
    InternalExecuteDirect('ALTER USER ' + AUserName + ' SET PASSWORD ''' +
      ANewPassword + '''', TransactionObj)
  else
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_IBId]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBConnection.InternalExecuteDirect(const ASQL: String;
  ATransaction: TADPhysTransaction);
var
  oStmt: TIBStatement;
begin
  oStmt := TIBStatement.Create(FDatabase,
    TADPhysIBTransaction(ATransaction).FTransaction, Self);
  try
    oStmt.InVars.VarCount := 0;
    oStmt.ExecuteImmediate(ASQL);
  finally
    ADFree(oStmt);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBConnection.GetItemCount: Integer;
begin
  Result := inherited GetItemCount;
  if FEnv <> nil then begin
    Inc(Result, 3);
    if (FDatabase <> nil) and (FDatabase.FDBHandle <> nil) then
      Inc(Result, 1);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBConnection.GetItem(AIndex: Integer; out AName: String;
  out AValue: Variant; out AKind: TADMoniAdapterItemKind);
begin
  if AIndex < inherited GetItemCount then
    inherited GetItem(AIndex, AName, AValue, AKind)
  else
    case AIndex - inherited GetItemCount of
    0:
      begin
        AName := 'Brand';
        case FEnv.Lib.Brand of
        ibInterbase: AValue := 'Interbase';
        ibFirebird:  AValue := 'Firebird';
        ibYaffil:    AValue := 'Yaffil';
        end;
        AKind := ikClientInfo;
      end;
    1:
      begin
        AName := 'Client version';
        AValue := Integer(FEnv.Lib.Version);
        AKind := ikClientInfo;
      end;
    2:
      begin
        AName := 'Client DLL name';
        AValue := FEnv.Lib.DLLName;
        AKind := ikClientInfo;
      end;
    3:
      begin
        AName := 'Server version';
        if FEnv.Lib.Brand in [ibFirebird, ibYaffil] then
          AValue := ADFixCRLF(FDatabase.firebird_version.Text)
        else
          AValue := ADFixCRLF(FDatabase.isc_version.Text);
        AKind := ikSessionInfo;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBConnection.GetMessages: EADDBEngineException;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBConnection.GetCliObj: Pointer;
begin
  Result := FDatabase;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBConnection.InternalGetCliHandle: Pointer;
begin
  if FDatabase <> nil then begin
    FCliHandles[0] := FDatabase.FDBHandle;
    FCliHandles[1] := TADPhysIBTransaction(TransactionObj).FTransaction.FTRHandle;
    Result := @FCliHandles;
  end
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBConnection.InternalAnalyzeSession(AMessages: TStrings);
begin
  inherited InternalAnalyzeSession(AMessages);

  // 2. Use FB client for FB server, and IB client for IB server
  if (FServerBrand = ibFirebird) and (FEnv.Lib.Brand = ibInterbase) then
    AMessages.Add('Warning: For Firebird server use the fbclient.dll')
  else if (FServerBrand = ibInterbase) and (FEnv.Lib.Brand = ibFirebird) then
    AMessages.Add('Warning: For Interbase server use the gds32.dll');
end;

{-------------------------------------------------------------------------------}
{ TADPhysIBTransaction                                                          }
{-------------------------------------------------------------------------------}
function TADPhysIBTransaction.GetIBConnection: TADPhysIBConnection;
begin
  Result := TADPhysIBConnection(ConnectionObj);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBTransaction.InternalAllocHandle;
begin
  FParams := TADStringList.Create;
  if IBConnection.FSharedTxHandle <> nil then begin
    FTransaction := TIBTransaction.CreateUsingHandle(IBConnection.FEnv,
      IBConnection.FSharedTxHandle, Self);
    IBConnection.FSharedTxHandle := nil;
  end
  else
    FTransaction := TIBTransaction.Create(IBConnection.FEnv, Self);
  FTransaction.AddDatabase(IBConnection.FDatabase);
  InternalChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBTransaction.InternalReleaseHandle;
begin
  ADFreeAndNil(FParams);
  if FTransaction <> nil then begin
    FTransaction.RemoveDatabase(IBConnection.FDatabase);
    ADFreeAndNil(FTransaction);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBTransaction.InternalChanged;
var
  i, j: Integer;
  oCustom, oParams: TStrings;
begin
  oParams := FTransaction.Params;
  oParams.BeginUpdate;
  try
    oParams.Clear;
    oCustom := GetOptions.Params;
    if (oCustom.IndexOf('read') = -1) and (oCustom.IndexOf('write') = -1) then
      if GetOptions.ReadOnly then
        oParams.Add('read')
      else
        oParams.Add('write');
    if (oCustom.IndexOf('read_committed') = -1) and (oCustom.IndexOf('rec_version') = -1) and
       (oCustom.IndexOf('concurrency') = -1) and (oCustom.IndexOf('consistency') = -1) then
      case GetOptions.Isolation of
      xiUnspecified:
        ;
      xiDirtyRead,
      xiReadCommitted:
        begin
          oParams.Add('read_committed');
          oParams.Add('rec_version');
        end;
      xiRepeatableRead,
      xiSnapshot:
        oParams.Add('concurrency');
      xiSerializible:
        oParams.Add('consistency');
      end;
    if (oCustom.IndexOf('wait') = -1) and (oCustom.IndexOf('nowait') = -1) then
      if IBConnection.GetOptions.UpdateOptions.LockWait then
        oParams.Add('wait')
      else
        oParams.Add('nowait');
    for i := 0 to oCustom.Count - 1 do begin
      j := oParams.IndexOfName(ADNameFromIndex(oCustom, i));
      if j = -1 then
        j := oParams.IndexOf(oCustom[i]);
      if j = -1 then
        oParams.Add(oCustom[i])
      else
        oParams.Strings[j] := oCustom[i];
    end;
  finally
    oParams.EndUpdate;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBTransaction.InternalStartTransaction(AID: LongWord);
begin
  FTransaction.StartTransaction();
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBTransaction.InternalCommit(AID: LongWord);
begin
  if Retaining then
    FTransaction.CommitRetaining()
  else begin
    DisconnectCommands(nil, dmOffline);
    FTransaction.Commit();
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBTransaction.InternalRollback(AID: LongWord);
begin
  if Retaining then
    FTransaction.RollbackRetaining()
  else begin
    DisconnectCommands(nil, dmOffline);
    FTransaction.Rollback();
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBTransaction.GetCliObj: Pointer;
begin
  Result := FTransaction;
end;

{-------------------------------------------------------------------------------}
function DisconnectionBeforeStart(ACmdObj: TObject): Boolean;
var
  oCmd: TADPhysIBCommand;
begin
  oCmd := TADPhysIBCommand(TIBStatement(ACmdObj).OwningObj);
  Result := not ((oCmd.GetCommandKind in [skCommit, skRollback]) and
    (oCmd.GetState = csExecuting));
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBTransaction.InternalNotify(ANotification: TADPhysTxNotification;
  ACommandObj: TADPhysCommand);
begin
  if ANotification = cpAfterCmdPrepareSuccess then
    Exit;
  ConnectionObj.Lock;
  try
    case ANotification of
    cpBeforeCmdPrepare:
      if not (TADPhysIBCommand(ACommandObj).GetCommandKind in [skStartTransaction, skCommit, skRollback]) then
        if GetOptions.AutoStart and not GetActive then begin
          StartTransaction;
          FIDAutoCommit := GetSerialID;
        end;
    cpBeforeCmdExecute:
      if TADPhysIBCommand(ACommandObj).GetCommandKind in [skCommit, skRollback] then
        DisconnectCommands(DisconnectionBeforeStart, dmOffline);
    cpAfterCmdPrepareFailure,
    cpAfterCmdUnprepare,
    cpAfterCmdExecuteSuccess,
    cpAfterCmdExecuteFailure:
      if not (TADPhysIBCommand(ACommandObj).GetCommandKind in [skStartTransaction, skCommit, skRollback]) then begin
        if GetOptions.AutoStop and GetActive and
           (not (xoIfAutoStarted in GetOptions.StopOptions) or
            (FIDAutoCommit <> 0) and (FIDAutoCommit = GetSerialID)) then
          // allowunprepare, force, success
          CheckStoping(not (ANotification in [cpAfterCmdUnprepare, cpAfterCmdPrepareFailure]),
                       not (xoIfCmdsInactive in GetOptions.StopOptions),
                       not (ANotification in [cpAfterCmdPrepareFailure, cpAfterCmdExecuteFailure]),
                       ACommandObj);
      end
      else if ANotification = cpAfterCmdExecuteSuccess then
        InternalCheckState(ACommandObj, True);
    end;
  finally
    ConnectionObj.UnLock;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBTransaction.GetItemCount: Integer;
begin
  Result := inherited GetItemCount;
  if FTransaction <> nil then
    Inc(Result);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBTransaction.GetItem(AIndex: Integer; out AName: String;
  out AValue: Variant; out AKind: TADMoniAdapterItemKind);
begin
  if AIndex < inherited GetItemCount then
    inherited GetItem(AIndex, AName, AValue, AKind)
  else
    case AIndex - inherited GetItemCount of
    0:
      begin
        AName := '@Params';
        AValue := FTransaction.Params.Text;
        AKind := ikSQL;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADPhysIBEventMessage                                                         }
{-------------------------------------------------------------------------------}
type
  TADPhysIBEventMessage = class(TADPhysEventMessage)
  private
    FBaseIndex: Integer;
    FCounts: TISCStatusVector;
  public
    constructor Create(ABaseIndex: Integer; const ACounts: TISCStatusVector);
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysIBEventMessage.Create(ABaseIndex: Integer;
  const ACounts: TISCStatusVector);
begin
  inherited Create;
  FBaseIndex := ABaseIndex;
  FCounts := ACounts;
end;

{-------------------------------------------------------------------------------}
{ TADPhysIBEventAlerter                                                         }
{-------------------------------------------------------------------------------}
procedure TADPhysIBEventAlerter.InternalAllocHandle;
begin
  FEventsConnection := GetConnection.Clone;
  if FEventsConnection.State = csDisconnected then
    FEventsConnection.Open;
  FEvents := TIBEvents.Create(TIBDatabase(FEventsConnection.CliObj), Self);
  FEvents.Names.Assign(GetNames);
  FEvents.OnFired := DoFired;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBEventAlerter.DoFired(AEvents: TIBEvents; ABaseIndex: Integer;
  const ACounts: TISCStatusVector);
begin
  if IsRunning then
    FMsgThread.EnqueueMsg(TADPhysIBEventMessage.Create(ABaseIndex, ACounts));
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBEventAlerter.InternalHandle(AEventMessage: TADPhysEventMessage);
var
  i, iFrom, iTo: Integer;
begin
  iFrom := TADPhysIBEventMessage(AEventMessage).FBaseIndex;
  iTo := iFrom + 15 - 1;
  if iTo >= GetNames.Count then
    iTo := GetNames.Count - 1;
  for i := iFrom to iTo do begin
    if GetHandler = nil then
      Break;
    if TADPhysIBEventMessage(AEventMessage).FCounts[i - iFrom] <> 0 then
      GetHandler.HandleEvent(GetNames[i],
        TADPhysIBEventMessage(AEventMessage).FCounts[i - iFrom]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBEventAlerter.InternalRegister;
begin
  FEvents.Allocate;
  FEvents.Register;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBEventAlerter.InternalUnregister;
begin
  FEvents.Cancel;
  FEvents.Release;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBEventAlerter.InternalReleaseHandle;
begin
  ADFreeAndNil(FEvents);
  FEventsConnection := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBEventAlerter.InternalSignal(const AEvent: String;
  const AArgument: Variant);
var
  oCmd: IADPhysCommand;
begin
  if TADPhysIBConnection(ConnectionObj).FEnv.Lib.Brand <> ibFirebird then
    ADCapabilityNotSupported(Self, [S_AD_LPhys, S_AD_IBId]);
  GetConnection.CreateCommand(oCmd);
  SetupCommand(oCmd);
  oCmd.Prepare('EXECUTE BLOCK AS BEGIN POST_EVENT ' + QuotedStr(AEvent) + '; END');
  oCmd.Execute();
end;

{-------------------------------------------------------------------------------}
{ TADPhysIBCommand                                                              }
{-------------------------------------------------------------------------------}
function TADPhysIBCommand.GetConnection: TADPhysIBConnection;
begin
  Result := TADPhysIBConnection(FConnectionObj);
end;

{-------------------------------------------------------------------------------}
function TADPhysIBCommand.GetCliObj: Pointer;
begin
  Result := IBStatement;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.SetupStatement(AStmt: TIBStatement);
var
  oFmtOpts: TADFormatOptions;
begin
  oFmtOpts := FOptions.FormatOptions;
  if GetMetaInfoKind <> mkNone then begin
    AStmt.StrsTrim := True;
    AStmt.StrsEmpty2Null := True;
  end
  else begin
    AStmt.StrsTrim := oFmtOpts.StrsTrim;
    AStmt.StrsEmpty2Null := oFmtOpts.StrsEmpty2Null;
  end;
  AStmt.Dialect := IBConnection.FDialect;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.SQL2ADColInfo(ASQLDataType, ASQLSubType, ASQLLen,
  ASQLPrec, ASQLScale: Smallint; out AType: TADDataType; var AAttrs: TADDataAttributes;
  out ALen: LongWord; out APrec, AScale: Integer; AFmtOpts: TADFormatOptions);
begin
  AType := dtUnknown;
  ALen := 0;
  APrec := 0;
  AScale := 0;
  Exclude(AAttrs, caFixedLen);
  Exclude(AAttrs, caBlobData);
  Include(AAttrs, caSearchable);
  case ASQLDataType of
  SQL_TEXT,
  SQL_VARYING,
  SQL_NULL:
    if LongWord(ASQLLen) <= AFmtOpts.MaxStringSize then begin
      if ASQLSubType = csIDOctets then begin
        AType := dtByteString;
        ALen := ASQLLen;
      end
      else if IBConnection.FEnv.Lib.IsUTF8(ASQLSubType) then begin
        AType := dtWideString;
        ALen := ASQLLen;
      end
      else begin
        AType := dtAnsiString;
        ALen := ASQLLen div SizeOf(TADAnsiChar);
      end;
      if (ASQLDataType = SQL_TEXT) or (ASQLDataType = SQL_NULL) then
        Include(AAttrs, caFixedLen);
    end
    else begin
      if ASQLSubType = csIDOctets then
        AType := dtBlob
      else if IBConnection.FDatabase.Encoder.Encoding = ecUTF8 then
        AType := dtWideMemo
      else
        AType := dtMemo;
      Include(AAttrs, caBlobData);
    end;
  SQL_SHORT:
    if ASQLScale = 0 then
      AType := dtInt16
    else begin
      APrec := 4;
      AScale := -ASQLScale;
      if AScale <= 4 then
        AType := dtCurrency
      else if (APrec <= AFmtOpts.MaxBcdPrecision) and
              (AScale <= AFmtOpts.MaxBcdScale) then
        AType := dtBCD
      else
        AType := dtFmtBCD;
    end;
  SQL_LONG:
    if ASQLScale = 0 then
      AType := dtInt32
    else begin
      APrec := 9;
      AScale := -ASQLScale;
      if AScale <= 4 then
        AType := dtCurrency
      else if (APrec <= AFmtOpts.MaxBcdPrecision) and
              (AScale <= AFmtOpts.MaxBcdScale) then
        AType := dtBCD
      else
        AType := dtFmtBCD;
    end;
  SQL_INT64,
  SQL_QUAD:
    if ASQLScale = 0 then
      AType := dtInt64
    else begin
      APrec := 18;
      AScale := -ASQLScale;
      if (APrec <= AFmtOpts.MaxBcdPrecision) and
         (AScale <= AFmtOpts.MaxBcdScale) then
        AType := dtBCD
      else
        AType := dtFmtBCD;
    end;
  SQL_FLOAT:
    begin
      AType := dtSingle;
      APrec := 8;
    end;
  SQL_DOUBLE,
  SQL_D_FLOAT:
    begin
      AType := dtDouble;
      APrec := 16;
    end;
  SQL_TIMESTAMP:
    AType := dtDateTimeStamp;
  SQL_TYPE_TIME:
    AType := dtTime;
  SQL_TYPE_DATE:
    AType := dtDate;
  SQL_BOOLEAN_IB,
  SQL_BOOLEAN_FB:
    AType := dtBoolean;
  SQL_BLOB:
    begin
      if ASQLSubType = isc_blob_text then
        if IBConnection.FDatabase.Encoder.Encoding = ecUTF8 then
          AType := dtWideMemo
        else
          AType := dtMemo
      else
        AType := dtBlob;
      Include(AAttrs, caBlobData);
      Exclude(AAttrs, caSearchable);
    end;
  SQL_ARRAY:
    begin
      AType := dtArrayRef;
      Exclude(AAttrs, caSearchable);
    end;
  else
    AType := dtUnknown;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.CreateColInfos;
var
  i, j, k: Integer;
  oVar: TIBVariable;
  oFmtOpts: TADFormatOptions;
  oFetchOpts: TADFetchOptions;
  iPrec, iScale: Integer;
  oTabs: TADStringList;
  sTableNames: String;
  lGetDSInfo: Boolean;
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  pColInfo: PADIBColInfoRec;
  oRow: TADDatSRow;
begin
  oFmtOpts := FOptions.FormatOptions;
  oFetchOpts := FOptions.FetchOptions;
  sTableNames := '';
  oTabs := nil;
  lGetDSInfo := (GetMetaInfoKind = mkNone) and (fiMeta in oFetchOpts.Items) and
    IBConnection.FExtendedMetadata;

  SetLength(FColInfos, FStmt.OutVars.VarCount);
  for i := 0 to Length(FColInfos) - 1 do begin
    oVar := FStmt.OutVars[i];

    pColInfo := @FColInfos[i];
    pColInfo^.FVar := oVar;
    pColInfo^.FName := oVar.aliasname;
    pColInfo^.FOriginTabName := oVar.relname;
    if pColInfo^.FOriginTabName <> '' then
      pColInfo^.FOriginColName := oVar.sqlname;
    pColInfo^.FPos := i + 1;

    if lGetDSInfo and (pColInfo^.FOriginTabName <> '') and
      (pColInfo^.FOriginColName <> '') then begin
      // If there is only a single table, then GetSelectMetaInfo will use a
      // parameter to substitute a table name. So, oTabs must be unquoted.
      // Otherwise - oTabs must be a list of quoted table names. And will
      // be concatenated with the mkResultSetFields SQL query.
      if oTabs = nil then begin
        oTabs := TADStringList.Create;
        oTabs.Sorted := True;
      end;
      if oTabs.IndexOf(pColInfo^.FOriginTabName) = -1 then
        oTabs.Add(pColInfo^.FOriginTabName);
    end;

    pColInfo^.FLen := oVar.sqllen;
    pColInfo^.FPrec := oVar.sqlprecision;
    pColInfo^.FScale := oVar.sqlscale;
    pColInfo^.FSrcSQLDataType := oVar.SQLDataType;
    pColInfo^.FSrcSQLSubType := oVar.sqlsubtype;

    pColInfo^.FAttrs := [];
    pColInfo^.FInPK := False;

    if oVar.IsNullable then
      Include(pColInfo^.FAttrs, caAllowNull);
    if CompareText(pColInfo^.FOriginColName, 'DB_KEY') = 0 then
      pColInfo^.FOriginColName := 'RDB$DB_KEY';
    if CompareText(pColInfo^.FOriginColName, 'RDB$DB_KEY') = 0 then begin
      Include(pColInfo^.FAttrs, caROWID);
      Include(pColInfo^.FAttrs, caAllowNull);
    end;

    SQL2ADColInfo(pColInfo^.FSrcSQLDataType, pColInfo^.FSrcSQLSubType,
      pColInfo^.FLen, pColInfo^.FPrec, pColInfo^.FScale, pColInfo^.FSrcDataType,
      pColInfo^.FAttrs, pColInfo^.FADLen, iPrec, iScale, oFmtOpts);
    pColInfo^.FPrec := iPrec;
    pColInfo^.FScale := iScale;
  end;

  if lGetDSInfo and (oTabs <> nil) and (oTabs.Count > 0) then begin
    GetConnection.CreateMetadata(oConnMeta);
    if oTabs.Count = 1 then
      sTableNames := oTabs[0]
    else
      for k := 0 to oTabs.Count - 1 do begin
        if sTableNames <> '' then
          sTableNames := sTableNames + ', ';
        sTableNames := sTableNames + QuotedStr(oTabs[k]);
      end;
    ADFree(oTabs);
    oView := oConnMeta.GetResultSetFields(sTableNames);
    try
      for i := 0 to Length(FColInfos) - 1 do begin
        pColInfo := @FColInfos[i];
        if (pColInfo^.FOriginTabName <> '') and
           (pColInfo^.FOriginColName <> '') then begin
          j := oView.Find([pColInfo^.FOriginTabName, pColInfo^.FOriginColName],
            'TABLE_NAME;COLUMN_NAME', []);
          if j <> -1 then begin
            oRow := oView.Rows[j];
            pColInfo^.FSrcTypeName := AnsiUpperCase(oRow.AsString['DOMAIN_NAME']);
            if StrLComp(PChar(pColInfo^.FSrcTypeName), PChar('RDB$'), 4) = 0 then
              pColInfo^.FSrcTypeName := '';
            if Pos('BOOL', pColInfo^.FSrcTypeName) <> 0 then
              pColInfo^.FDestDataType := dtBoolean
            else if Pos('GUID', pColInfo^.FSrcTypeName) <> 0 then
              pColInfo^.FDestDataType := dtGUID;
            if not VarIsNull(oRow.ValueS['IN_PKEY']) then
              pColInfo^.FInPK := True;
            if not VarIsNull(oRow.ValueS['GENERATOR_NAME']) then begin
              Include(pColInfo^.FAttrs, caAutoInc);
              Include(pColInfo^.FAttrs, caAllowNull);
            end;
            if oRow.ValueS['ISCOMPUTED'] = 1 then begin
              Include(pColInfo^.FAttrs, caReadOnly);
              Include(pColInfo^.FAttrs, caCalculated);
            end;
            if oRow.ValueS['HASDEFAULT'] = 1 then
              Include(pColInfo^.FAttrs, caDefault);
            if (IBConnection.FServerBrand = ibFirebird) and (oConnMeta.ServerVersion >= ivFB030000) then
              if not VarIsNull(oRow.ValueS['IDENT_TYPE']) and (oRow.ValueS['IDENT_TYPE'] >= 1) then
                Include(pColInfo^.FAttrs, caAutoInc);
          end;
        end;
      end;
    finally
      ADClearMetaView(oView, oFetchOpts);
    end;
  end;

  for i := 0 to Length(FColInfos) - 1 do begin
    pColInfo := @FColInfos[i];
    // mapping data types
    if pColInfo^.FDestDataType = dtUnknown then
      if GetMetaInfoKind = mkNone then
        oFmtOpts.ResolveDataType(pColInfo^.FName, pColInfo^.FSrcDataType,
          pColInfo^.FADLen, pColInfo^.FPrec, pColInfo^.FScale,
          pColInfo^.FDestDataType, pColInfo^.FADLen, True)
      else
        pColInfo^.FDestDataType := pColInfo^.FSrcDataType;

    if not CheckFetchColumn(pColInfo^.FSrcDataType, pColInfo^.FAttrs) then
      pColInfo^.FVar := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.DestroyColInfos;
begin
  SetLength(FColInfos, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.CreateParamInfos(AVars: TIBVariables; AInput, AFB2Batch: Boolean);
var
  iBase, iPar, i: Integer;
  oVar: TIBVariable;
  oFmtOpts: TADFormatOptions;
  iPrec, iScale: Integer;
  eAttrs: TADDataAttributes;
  oParams: TADParams;
  oParam: TADParam;
  pInfo: PADIBParInfoRec;

  procedure SetupStringVariable(AParam: TADParam; var AInfo: TADIBParInfoRec;
    var AVar: TIBVariable);
  begin
    if caFixedLen in eAttrs then
      AVar.SQLDataType := SQL_TEXT
    else
      AVar.SQLDataType := SQL_VARYING;
    case AInfo.FSrcDataType of
    dtAnsiString: AVar.sqlsubtype := csIDNone;
    dtByteString: AVar.sqlsubtype := csIDOctets;
    dtWideString: AVar.sqlsubtype := FStmt.Lib.IDUTF8;
    end;
    if AParam.Size <> 0 then
      AVar.sqllen := AParam.Size
    else
      AVar.sqllen := C_AD_DefStrSize;
    AVar.sqlprecision := 0;
    AVar.sqlscale := 0;
    AInfo.FLen := AVar.sqllen;
    AInfo.FPrec := AVar.sqlprecision;
    AInfo.FScale := AVar.sqlscale;
    AInfo.FDestSQLDataType := AVar.SQLDataType;
    AInfo.FDestSQLSubType := AVar.sqlsubtype;
    AInfo.FDestDataType := AInfo.FSrcDataType;
  end;

begin
  oFmtOpts := FOptions.FormatOptions;
  oParams := GetParams;
  iBase := Length(FParInfos);
  iPar := iBase - 1;
  SetLength(FParInfos, iBase + AVars.VarCount);

  for i := 0 to AVars.VarCount - 1 do begin

    if iPar >= oParams.Markers.Count - 1 then
      if AFB2Batch then
        iPar := -1
      else
        Break;

    oParam := nil;
    while iPar < oParams.Markers.Count - 1 do begin
      Inc(iPar);
      case GetParams.BindMode of
      pbByName:   oParam := oParams.FindParam(oParams.Markers[iPar]);
      pbByNumber: oParam := oParams.FindParam(iPar + 1);
      end;
      if (oParam = nil) or
         (oParam.DataType <> ftCursor) and (
          AInput and (oParam.ParamType in [ptUnknown, ptInput, ptInputOutput]) or
          not AInput and (oParam.ParamType in [ptOutput, ptInputOutput, ptResult])) then
        Break;
    end;

    pInfo := @FParInfos[iBase + i];
    if oParam = nil then begin
      pInfo^.FParamIndex := -1;
      Continue;
    end;
    oVar := AVars[i];

    pInfo^.FVar := oVar;
    pInfo^.FParamIndex := oParam.Index;

    if AInput and not oVar.IsNullable then
      oVar.IsNullable := True;
    if (oVar.DumpLabel = '') or (oVar.DumpLabel[1] = '#') then
      oVar.DumpLabel := oParam.DisplayName;
    pInfo^.FParamType := oParam.ParamType;

    pInfo^.FLen := oVar.sqllen;
    pInfo^.FPrec := oVar.sqlprecision;
    pInfo^.FScale := oVar.sqlscale;
    pInfo^.FDestSQLDataType := oVar.SQLDataType;
    pInfo^.FDestSQLSubType := oVar.sqlsubtype;

    eAttrs := [];
    SQL2ADColInfo(pInfo^.FDestSQLDataType, pInfo^.FDestSQLSubType, pInfo^.FLen,
      pInfo^.FPrec, pInfo^.FScale, pInfo^.FDestDataType, eAttrs, pInfo^.FADLen,
      iPrec, iScale, oFmtOpts);

    if oParam.DataType = ftUnknown then begin
      oFmtOpts.ResolveDataType('', pInfo^.FDestDataType, pInfo^.FADLen,
        iPrec, iScale, pInfo^.FSrcDataType, pInfo^.FADLen, False);
      if pInfo^.FDestDataType <> pInfo^.FSrcDataType then
        eAttrs := [];

      oFmtOpts.ColumnDef2FieldDef(pInfo^.FSrcDataType, pInfo^.FADLen, iPrec,
        iScale, eAttrs, pInfo^.FSrcFieldType, pInfo^.FSrcSize, pInfo^.FSrcPrec,
        pInfo^.FSrcScale);
      oParam.DataType := pInfo^.FSrcFieldType;
      oParam.Size := pInfo^.FSrcSize;
      oParam.Precision := pInfo^.FSrcPrec;
      oParam.NumericScale := pInfo^.FSrcScale;
    end

    else begin
      pInfo^.FSrcFieldType := oParam.DataType;
      pInfo^.FSrcSize := oParam.Size;
      pInfo^.FSrcPrec := oParam.Precision;
      pInfo^.FSrcScale := oParam.NumericScale;
      oFmtOpts.FieldDef2ColumnDef(pInfo^.FSrcFieldType, pInfo^.FSrcSize,
        pInfo^.FSrcPrec, pInfo^.FSrcScale, pInfo^.FSrcDataType, pInfo^.FADLen,
        iPrec, iScale, eAttrs);
      case pInfo^.FSrcDataType of
      dtAnsiString,
      dtByteString,
      dtWideString:
        if (pInfo^.FDestSQLDataType <> SQL_VARYING) and
           (pInfo^.FDestSQLDataType <> SQL_TEXT) and
           (pInfo^.FDestSQLDataType <> SQL_BLOB) then
          // When assigning a textual parameter value to a non-textual parameter,
          // then let FB handle a conversion, as it is FB data format dependent.
          // For example '1996-07-05' to a DATE parameter. In other cases the
          // conversion will be performed by FireDAC.
          SetupStringVariable(oParam, FParInfos[iBase + i], oVar)
        else if pInfo^.FADLen <> 0 then
          oVar.sqllen := pInfo^.FADLen;
      dtBCD,
      dtFmtBCD,
      dtCurrency:
        begin
          if iPrec <> 0 then
            oVar.sqlprecision := iPrec;
          if iScale <> 0 then
            oVar.sqlscale := - iScale;
        end;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.DestroyParamInfos;
begin
  SetLength(FParInfos, 0);
end;

{-------------------------------------------------------------------------------}
function TADPhysIBCommand.UseExecDirect: Boolean;
begin
  // ResourceOptions.DirectExecute is not used. Because then TIBStatement.GetRowCounts
  // cannot be called and updated rows count will be zero.
  Result := GetCommandKind in [skCreate, skAlter, skDrop, skStartTransaction,
    skCommit, skRollback, skSet, skSetSchema];
end;

{-------------------------------------------------------------------------------}
function TADPhysIBCommand.IsReturning: Boolean;
begin
  Result := (FStmt.Lib.Brand = ibFirebird) and (FStmt.Lib.Version >= ivFB020000) and
    (FStmt.sql_stmt_type = isc_info_sql_stmt_exec_procedure) and
    (GetCommandKind in [skDelete, skInsert, skMerge, skUpdate]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.PrepareBase;
var
  i: Integer;
begin
  FStmt.Prepare(FDbCommandText);
  FStmt.DescribeSelect;
  FStmt.DescribeBind;
  if FStmt.InVars.VarCount > 0 then
    CreateParamInfos(FStmt.InVars, True, False);
  // Do not create here column infos or output param infos, we does not
  // know how programmer will use command - Execute or Open. If Execute,
  // then create param infos, else column infos.

  FRetWithOut := False;
  if IsReturning then
    for i := 0 to GetParams.Count - 1 do
      if GetParams[i].ParamType in [ptOutput, ptInputOutput, ptResult] then begin
        FRetWithOut := True;
        Break;
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.InternalPrepare;
var
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
begin
  // generate metadata SQL command
  if GetMetaInfoKind <> uADPhysIntf.mkNone then begin
    GetSelectMetaInfoParams(rName);
    GenerateSelectMetaInfo(rName);
    if FDbCommandText = '' then
      Exit;
  end

  // generate stored proc call SQL command
  else if GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
	  GetConnection.CreateMetadata(oConnMeta);
    oConnMeta.DecodeObjName(Trim(GetCommandText()), FSPParsedName, Self, []);
    FDbCommandText := '';
    if fiMeta in FOptions.FetchOptions.Items then
      GenerateStoredProcParams(FSPParsedName);
    // If an exact stored proc kind is not specified, then do not build a stored
    // proc call SQL, we does not know how a programmer will use a command - Execute
    // or Open. If Execute, then - EXEC PROC, else - SELECT.
    if (FDbCommandText = '') and (GetCommandKind <> skStoredProc) then
      GenerateStoredProcCall(FSPParsedName, GetCommandKind);
  end;

  // adjust SQL command
  GenerateLimitSelect();
  GenerateParamMarkers();

  FStmt := TIBStatement.Create(IBConnection.FDatabase,
    TADPhysIBTransaction(FTransactionObj).FTransaction, Self);
  SetupStatement(FStmt);
  if (GetCommandKind <> skStoredProc) and not UseExecDirect then
    PrepareBase;
  FCursorCanceled := True;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.CheckSPPrepared(ASPUsage: TADPhysCommandKind);
begin
  if (FDbCommandText <> '') or (GetCommandKind <> skStoredProc) then
    Exit;
  GenerateStoredProcCall(FSPParsedName, ASPUsage);
  PrepareBase;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.CheckColInfos;
begin
  if (FStmt.OutVars.VarCount > 0) and (Length(FColInfos) = 0) then
    CreateColInfos;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.CheckParamInfos;
begin
  if (FStmt.OutVars.VarCount > 0) and (FStmt.InVars.VarCount = Length(FParInfos)) then
    CreateParamInfos(FStmt.OutVars, False, False);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.InternalUnprepare;
begin
  if FStmt = nil then
    Exit;
  FStmt.Unprepare;
  DestroyColInfos;
  DestroyParamInfos;
  ADFreeAndNil(FStmt);
end;

{-------------------------------------------------------------------------------}
function TADPhysIBCommand.InternalUseStandardMetadata: Boolean;
begin
  Result := not IBConnection.FExtendedMetadata;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBCommand.InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean;
begin
  // After Prepare call the columns are defined. But here a
  // command is executing to make OpenOrExecute method working.
  Result := InternalOpen;
  if ATabInfo.FSourceID = -1 then begin
    ATabInfo.FSourceName := GetCommandText;
    ATabInfo.FSourceID := 1;
    FColumnIndex := 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBCommand.InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean;
var
  pColInfo: PADIBColInfoRec;
begin
  if FColumnIndex < Length(FColInfos) then begin
    pColInfo := @FColInfos[FColumnIndex];
    AColInfo.FSourceName := pColInfo^.FName;
    AColInfo.FSourceID := pColInfo^.FPos;
    AColInfo.FSourceType := pColInfo^.FSrcDataType;
    AColInfo.FSourceTypeName := pColInfo^.FSrcTypeName;
    AColInfo.FOriginTabName.FObject := pColInfo^.FOriginTabName;
    AColInfo.FOriginColName := pColInfo^.FOriginColName;
    AColInfo.FType := pColInfo^.FDestDataType;
    AColInfo.FLen := pColInfo^.FADLen;
    AColInfo.FPrec := pColInfo^.FPrec;
    AColInfo.FScale := Abs(pColInfo^.FScale);
    AColInfo.FAttrs := pColInfo^.FAttrs;
    AColInfo.FForceAddOpts := [];
    if pColInfo^.FInPK then
      Include(AColInfo.FForceAddOpts, coInKey);
    Inc(FColumnIndex);
    Result := True;
  end
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.SetParamValue(AFmtOpts: TADFormatOptions; AParam: TADParam;
  AVar: TIBVariable; ApInfo: PADIBParInfoRec; AVarIndex, AParIndex: Integer);

  function CreateBlob(ADestDataType: TADDataType): TIBBlob;
  begin
    Result := TIBBlob.Create(FStmt.Database,
      TADPhysIBTransaction(FTransactionObj).FTransaction, Self);
    if ADestDataType in C_AD_CharTypes then
      Result.sqlsubtype := isc_blob_text;
    Result.Add;
  end;

var
  pData: PADByteString;
  iSize, iSrcSize: LongWord;
  oBlob: TIBBlob;
begin
  pData := nil;
  iSize := 0;

  // null
  if AParam.IsNulls[AParIndex] then
    AVar.SetData(AVarIndex, nil, 0)

  // conversion is not required
  else if ApInfo^.FSrcDataType = ApInfo^.FDestDataType then begin

    // byte string data, then optimizing - get data directly
    if ApInfo^.FDestSQLDataType = SQL_BLOB then begin
      oBlob := CreateBlob(ApInfo^.FDestDataType);
      try
        AParam.GetBlobRawData(iSize, pData, AParIndex);
        oBlob.Write(PByte(pData), iSize);
        AVar.SetData(AVarIndex, @oBlob.FBlobID, SizeOf(oBlob.FBlobID),
          ApInfo^.FDestDataType);
      finally
        ADFree(oBlob);
      end;
    end

    else if ApInfo^.FDestDataType in (C_AD_VarLenTypes {$IFDEF NEXTGEN} - C_AD_AnsiTypes {$ENDIF}) then begin
      AParam.GetBlobRawData(iSize, pData, AParIndex);
      AVar.SetData(AVarIndex, pData, iSize, ApInfo^.FDestDataType);
    end

    else begin
      iSize := AParam.GetDataLength(AParIndex);
      FBuffer.Check(iSize);
      AParam.GetData(FBuffer.Ptr, AParIndex);
      AVar.SetData(AVarIndex, FBuffer.Ptr, iSize, ApInfo^.FDestDataType);
    end;
  end

  // conversion is required
  else begin
    // calculate buffer size to move param values
    iSrcSize := AParam.GetDataLength(AParIndex);
    FBuffer.Extend(iSrcSize, iSize, ApInfo^.FSrcDataType, ApInfo^.FDestDataType);

    // get, convert and set parameter value
    AParam.GetData(FBuffer.Ptr, AParIndex);
    AFmtOpts.ConvertRawData(ApInfo^.FSrcDataType, ApInfo^.FDestDataType,
      FBuffer.Ptr, iSrcSize, FBuffer.FBuffer, FBuffer.Size, iSize,
      IBConnection.FDatabase.Encoder);

    if ApInfo^.FDestSQLDataType = SQL_BLOB then begin
      oBlob := CreateBlob(ApInfo^.FDestDataType);
      try
        oBlob.Write(FBuffer.Ptr, iSize);
        AVar.SetData(AVarIndex, @oBlob.FBlobID, SizeOf(oBlob.FBlobID),
          ApInfo^.FDestDataType);
      finally
        ADFree(oBlob);
      end;
    end

    else
      AVar.SetData(AVarIndex, FBuffer.Ptr, iSize, ApInfo^.FDestDataType);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.SetParamValues(ATimes, AOffset: Integer);
var
  oParams: TADParams;
  oFmtOpts: TADFormatOptions;
  oParam: TADParam;
  iArraySize, i, j: Integer;
  pParInfo: PADIBParInfoRec;
begin
  oParams := GetParams;
  if oParams.Count = 0 then
    Exit;

  oFmtOpts := GetOptions.FormatOptions;
  iArraySize := oParams.ArraySize;
  if ATimes < iArraySize then
    iArraySize := ATimes;

  for i := 0 to Length(FParInfos) - 1 do begin
    pParInfo := @FParInfos[i];
    if pParInfo^.FParamIndex <> -1 then begin
      oParam := oParams[pParInfo^.FParamIndex];
      if (pParInfo^.FVar <> nil) and
         (oParam.DataType <> ftCursor) and
         (oParam.ParamType in [ptInput, ptInputOutput, ptUnknown]) then begin
        CheckParamMatching(oParam, pParInfo^.FSrcFieldType, pParInfo^.FParamType,
          pParInfo^.FSrcPrec);
        for j := AOffset to iArraySize - 1 do
          SetParamValue(oFmtOpts, oParam, pParInfo^.FVar, pParInfo, j - AOffset, j);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.SetFB2BatchParamValues(AStmt: TIBStatement; ATimes, AOffset: Integer);
var
  oParams: TADParams;
  oFmtOpts: TADFormatOptions;
  oParam: TADParam;
  iArraySize, i, j: Integer;
  pParInfo: PADIBParInfoRec;
begin
  oParams := GetParams;
  if oParams.Count = 0 then
    Exit;

  oFmtOpts := GetOptions.FormatOptions;
  iArraySize := oParams.ArraySize;
  if ATimes < iArraySize then
    iArraySize := ATimes;

  for i := 0 to Length(FParInfos) - 1 do begin
    pParInfo := @FParInfos[i];
    if pParInfo^.FParamIndex <> -1 then begin
      oParam := oParams[pParInfo^.FParamIndex];
      if (pParInfo^.FVar <> nil) and
         (oParam.DataType <> ftCursor) and
         (oParam.ParamType in [ptInput, ptInputOutput, ptUnknown]) then begin
        CheckParamMatching(oParam, pParInfo^.FSrcFieldType, pParInfo^.FParamType,
          pParInfo^.FSrcPrec);
        for j := AOffset to iArraySize - 1 do
          SetParamValue(oFmtOpts, oParam, AStmt.InVars[LongWord(FStmt.InVars.VarCount *
            (j - AOffset)) + pParInfo^.FVar.Index], pParInfo, 0, j);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.GetParamValue(AFmtOpts: TADFormatOptions;
  AParam: TADParam; AVar: TIBVariable; ApInfo: PADIBParInfoRec;
  AVarIndex, AParIndex: Integer);

  function CreateBlob(const ABlobID: TISCQuad; ADestDataType: TADDataType): TIBBlob;
  begin
    Result := TIBBlob.Create(FStmt.Database,
      TADPhysIBTransaction(FTransactionObj).FTransaction, Self);
    Result.BlobID := ABlobID;
    if ADestDataType in C_AD_CharTypes then
      Result.sqlsubtype := isc_blob_text;
    Result.Open;
  end;

var
  pData: Pointer;
  iSize, iByteSize, iDestSize: LongWord;
  oBlob: TIBBlob;
begin
  pData := nil;
  iSize := 0;

  // null
  if not AVar.GetData(AVarIndex, pData, iSize, True) then
    AParam.Clear(AParIndex)

  // conversion is not required
  else if ApInfo^.FDestDataType = ApInfo^.FSrcDataType then begin

    // byte string data, then optimizing - get data directly
    if ApInfo^.FDestSQLDataType = SQL_BLOB then begin
      oBlob := CreateBlob(PISCQuad(pData)^, ApInfo^.FDestDataType);
      try
        iSize := oBlob.total_length;
        pData := AParam.SetBlobRawData(iSize, nil, AParIndex);
        if iSize > 0 then
          oBlob.Read(pData, iSize);
      finally
        ADFree(oBlob);
      end;
    end

    else if ApInfo^.FDestDataType in C_AD_VarLenTypes then
      AParam.SetData(PADByteString(pData), iSize, AParIndex)

    else begin
      FBuffer.Check(iSize);
      AVar.GetData(AVarIndex, FBuffer.FBuffer, iSize, False);
      AParam.SetData(FBuffer.Ptr, iSize, AParIndex);
    end;
  end

  // conversion is required
  else begin
    if ApInfo^.FDestSQLDataType = SQL_BLOB then begin
      oBlob := CreateBlob(PISCQuad(pData)^, ApInfo^.FDestDataType);
      try
        iSize := oBlob.total_length;
        iByteSize := iSize;
        if oBlob.National then
          iByteSize := iByteSize * SizeOf(WideChar);
        pData := FBuffer.Check(iByteSize);
        if iSize > 0 then
          oBlob.Read(pData, iSize);
      finally
        ADFree(oBlob);
      end;
    end

    else begin
      FBuffer.Check(iSize);
      AVar.GetData(AVarIndex, FBuffer.FBuffer, iSize, False);
    end;

    iDestSize := 0;
    AFmtOpts.ConvertRawData(ApInfo^.FDestDataType, ApInfo^.FSrcDataType,
      FBuffer.Ptr, iSize, FBuffer.FBuffer, FBuffer.Size, iDestSize,
      IBConnection.FDatabase.Encoder);
    AParam.SetData(FBuffer.Ptr, iDestSize, AParIndex);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.GetParamValues(ATimes, AOffset: Integer);
var
  oParams: TADParams;
  oFmtOpts: TADFormatOptions;
  iArraySize, i, j: Integer;
  oParam: TADParam;
  pParInfo: PADIBParInfoRec;
begin
  oParams := GetParams;
  if oParams.Count = 0 then
    Exit;

  oFmtOpts := FOptions.FormatOptions;
  iArraySize := oParams.ArraySize;
  if ATimes < iArraySize then
    iArraySize := ATimes;

  for i := 0 to Length(FParInfos) - 1 do begin
    pParInfo := @FParInfos[i];
    if pParInfo^.FParamIndex <> -1 then begin
      oParam := oParams[pParInfo^.FParamIndex];
      if (pParInfo^.FVar <> nil) and
         (oParam.DataType <> ftCursor) and
         (oParam.ParamType in [ptOutput, ptResult, ptInputOutput]) then begin
        CheckParamMatching(oParam, pParInfo^.FSrcFieldType, pParInfo^.FParamType,
          pParInfo^.FSrcPrec);
        for j := AOffset to iArraySize - 1 do
          GetParamValue(oFmtOpts, oParam, pParInfo^.FVar, pParInfo, j - AOffset, j);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.GetFB2BatchParamValues(AStmt: TIBStatement; ATimes, AOffset: Integer);
var
  oParams: TADParams;
  oFmtOpts: TADFormatOptions;
  oParam: TADParam;
  iArraySize, i, j: Integer;
  pParInfo: PADIBParInfoRec;
begin
  oParams := GetParams;
  if oParams.Count = 0 then
    Exit;

  oFmtOpts := GetOptions.FormatOptions;
  iArraySize := oParams.ArraySize;
  if ATimes < iArraySize then
    iArraySize := ATimes;

  for i := 0 to Length(FParInfos) - 1 do begin
    pParInfo := @FParInfos[i];
    if pParInfo^.FParamIndex <> -1 then begin
      oParam := oParams[pParInfo^.FParamIndex];
      if (pParInfo^.FVar <> nil) and
         (oParam.DataType <> ftCursor) and
         (oParam.ParamType in [ptOutput, ptResult, ptInputOutput]) then begin
        CheckParamMatching(oParam, pParInfo^.FSrcFieldType, pParInfo^.FParamType,
          pParInfo^.FSrcPrec);
        for j := AOffset to iArraySize - 1 do
          GetParamValue(oFmtOpts, oParam, AStmt.OutVars[LongWord(FStmt.OutVars.VarCount *
            (j - AOffset)) + pParInfo^.FVar.Index], pParInfo, 0, j);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.DoExecuteIB2007Batch(ATimes, AOffset: Integer;
  var ACount: TADCounter);
var
  iBatchSize, iRows: LongWord;
  iCurTimes, iCurOffset, i: Integer;
  oResOpts: TADResourceOptions;
begin
  oResOpts := FOptions.ResourceOptions;
  // total size of XSQLVAR, which will be send to server in single packet
  iBatchSize := FStmt.MaximumBatchSize;
  if iBatchSize > LongWord(oResOpts.ArrayDMLSize) then
    iBatchSize := LongWord(oResOpts.ArrayDMLSize);

  // If block will have only single command or there are OUT params, then go
  // by standard route - execute command once for each param array item.
  if (iBatchSize <= 1) or (FStmt.OutVars.VarCount > 0) then begin
    DoExecute(ATimes, AOffset, ACount);
    Exit;
  end;

  iCurOffset := AOffset;
  iCurTimes := LongWord(AOffset) + iBatchSize;
  while iCurOffset < ATimes do begin
    if iCurTimes > ATimes then
      iCurTimes := ATimes;
    FStmt.InVars.RowCount := Word(iCurTimes - iCurOffset);
    SetParamValues(iCurTimes, iCurOffset);
    try
      try
        FStmt.ExecuteBatch;
      finally
        if FStmt <> nil then
          for i := 0 to FStmt.InVars.RowCount - 1 do begin
            iRows := FStmt.InVars.FRowsAffected[i];
            if iRows = $FFFFFFFF then
              Break;
            if iRows > 0 then
              Inc(ACount);
          end;
      end;
    except
      on E: EIBNativeException do begin
        E.Errors[0].RowIndex := iCurOffset + ACount;
        raise;
      end;
    end;
    if FStmt.OutVars.VarCount > 0 then
      GetParamValues(iCurTimes, iCurOffset);
    FStmt.Close;
    Inc(iCurOffset, iBatchSize);
    Inc(iCurTimes, iBatchSize);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBCommand.GenerateFB2BatchSQL(ATimes, AOffset: Integer): String;
var
  iCurPos, iRow, iVar, iPrev, i: Integer;
  lInStr1, lInStr2, lInComment: Boolean;

  procedure W(const AStrs: array of String);
  var
    i: Integer;
  begin
    for i := Low(AStrs) to High(AStrs) do begin
      while iCurPos + Length(AStrs[i]) > Length(Result) do
        SetLength(Result, Length(Result) * 2);
      Move(PChar(AStrs[i])^, (PChar(Result) + iCurPos)^, Length(AStrs[i]) * SizeOf(Char));
      Inc(iCurPos, Length(AStrs[i]));
    end;
  end;

  procedure AppendDBCmdText;
  begin
    while iCurPos + i - iPrev > Length(Result) do
      SetLength(Result, Length(Result) * 2);
    Move((PChar(FDbCommandText) + iPrev - 1)^, (PChar(Result) + iCurPos)^, (i - iPrev) * SizeOf(Char));
    Inc(iCurPos, i - iPrev);
    iPrev := i + 1;
  end;

  procedure AppendParameter(const ALetter: String; ARowIndex: Integer; AVar: TIBVariable);
  var
    iPrec, iLen: Integer;
    lUTF8: Boolean;
  begin
    W([ALetter, IntToStr(ARowIndex - AOffset), '_', IntToStr(AVar.Index), ' ']);
    case AVar.SQLDataType of
    SQL_NULL:
      W(['CHAR(1)']);
    SQL_TEXT:
      begin
        lUTF8 := IBConnection.FEnv.Lib.IsUTF8(AVar.sqlsubtype);
        if lUTF8 then
          iLen := (AVar.sqllen + (C_AD_MaxUTF8Len - 1)) div C_AD_MaxUTF8Len
        else
          iLen := AVar.sqllen;
        W(['CHAR(', IntToStr(iLen), ')']);
        if lUTF8 then
          W([' CHARACTER SET ', IBConnection.FEnv.Lib.GetUTF8CSName(AVar.sqlsubtype)]);
      end;
    SQL_VARYING:
      begin
        lUTF8 := IBConnection.FEnv.Lib.IsUTF8(AVar.sqlsubtype);
        if lUTF8 then
          iLen := (AVar.sqllen + (C_AD_MaxUTF8Len - 1)) div C_AD_MaxUTF8Len
        else
          iLen := AVar.sqllen;
        W(['VARCHAR(', IntToStr(iLen), ')']);
        if lUTF8 then
          W([' CHARACTER SET ', IBConnection.FEnv.Lib.GetUTF8CSName(AVar.sqlsubtype)]);
      end;
    SQL_SHORT:
      if AVar.sqlscale = 0 then
        W(['SMALLINT'])
      else begin
        iPrec := AVar.sqlprecision;
        if iPrec = 0 then
          iPrec := 4;
        W(['DECIMAL(', IntToStr(iPrec), ',',
                       IntToStr(-AVar.sqlscale), ')']);
      end;
    SQL_LONG:
      if AVar.sqlscale = 0 then
        W(['INTEGER'])
      else begin
        iPrec := AVar.sqlprecision;
        if iPrec = 0 then
          iPrec := 9;
        W(['DECIMAL(', IntToStr(iPrec), ',',
                       IntToStr(-AVar.sqlscale), ')']);
      end;
    SQL_INT64:
      if AVar.sqlscale = 0 then
        W(['BIGINT'])
      else begin
        iPrec := AVar.sqlprecision;
        if iPrec = 0 then
          iPrec := 18;
        W(['DECIMAL(', IntToStr(iPrec), ',',
                       IntToStr(-AVar.sqlscale), ')']);
      end;
    SQL_FLOAT:
      W(['FLOAT']);
    SQL_DOUBLE,
    SQL_D_FLOAT:
      W(['DOUBLE PRECISION']);
    SQL_TYPE_TIME:
      W(['TIME']);
    SQL_TYPE_DATE:
      W(['DATE']);
    SQL_TIMESTAMP:
      W(['TIMESTAMP']);
    SQL_BLOB:
      W(['BLOB']);
    SQL_BOOLEAN_FB:
      W(['BOOLEAN'])
    else
      // SQL_ARRAY, SQL_QUAD, SQL_BOOLEAN_IB
      ASSERT(False);
    end;
  end;

begin
  iCurPos := 0;
  SetLength(Result, 16384);
  W(['EXECUTE BLOCK(']);
  for iRow := AOffset to ATimes - 1 do begin
    for iVar := 0 to FStmt.InVars.VarCount - 1 do begin
      if not ((iRow = AOffset) and (iVar = 0)) then
        W([',']);
      AppendParameter('I', iRow, FStmt.InVars[iVar]);
      W(['=?']);
    end;
    W([#10]);
  end;
  W([')'#10]);
  if FStmt.OutVars.VarCount > 0 then begin
    W(['RETURNS (']);
    for iRow := AOffset to ATimes - 1 do begin
      for iVar := 0 to FStmt.OutVars.VarCount - 1 do begin
        if not ((iRow = AOffset) and (iVar = 0)) then
          W([',']);
        AppendParameter('O', iRow, FStmt.OutVars[iVar]);
      end;
      W([#10]);
    end;
    W([')'#10]);
  end;
  W(['AS'#10'BEGIN'#10]);
  for iRow := AOffset to ATimes - 1 do begin
    iPrev := 1;
    lInStr1 := False;
    lInStr2 := False;
    lInComment := False;
    i := 1;
    iVar := 0;
    while i <= Length(FDbCommandText) do begin
      case FDbCommandText[i] of
      '''':
        if not lInStr2 and not lInComment then
          if FDbCommandText[i + 1] <> '''' then
            lInStr1 := not lInStr1
          else
            Inc(i);
      '"':
        if not lInStr1 and not lInComment then
          if FDbCommandText[i + 1] <> '"' then
            lInStr2 := not lInStr2
          else
            Inc(i);
      '/':
        if not lInStr1 and not lInStr2 then
          if FDbCommandText[i + 1] = '*' then begin
            lInComment := True;
            Inc(i);
          end;
      '*':
        if not lInStr1 and not lInStr2 then
          if FDbCommandText[i + 1] = '/' then begin
            lInComment := False;
            Inc(i);
          end;
      '?':
        if not lInStr1 and not lInStr2 and not lInComment then begin
          AppendDBCmdText;
          W([':I', IntToStr(iRow - AOffset), '_', IntToStr(iVar)]);
          Inc(iVar);
        end;
      end;
      Inc(i);
    end;
    AppendDBCmdText;
    if FStmt.OutVars.VarCount > 0 then begin
      // If EXECUTE PROCEDURE -> RETURNING_VALUES :o1, :o2, ...
      // If INSERT/UPDATE/DELETE RETURNING f1, f2, ... -> INTO :o1, :o2, ...
      if GetCommandKind = skStoredProcNoCrs then
        W([' RETURNING_VALUES '])
      else
        W([' INTO ']);
      for iVar := 0 to FStmt.OutVars.VarCount - 1 do begin
        if iVar > 0 then
          W([',']);
        W([':O', IntToStr(iRow - AOffset), '_', IntToStr(iVar)]);
      end;
    end;
    W([';'#10]);
  end;
  W(['END']);
  SetLength(Result, iCurPos);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.DoExecuteFB2Batch(ATimes, AOffset: Integer;
  var ACount: TADCounter);
var
  sBatchSQL: String;
  iBatchSize, iBatchSize2: LongWord;
  iInVarsCount, iOutVarsCount: Smallint;
  iCurTimes, iCurOffset, iLastBatchSize: Integer;
  oStmt: TIBStatement;
  oResOpts: TADResourceOptions;
begin
  oResOpts := FOptions.ResourceOptions;
  // total size of XSQLVAR, which will be send to server in single packet
  iBatchSize := FStmt.MaximumBatchSize;

  // total count of XSQLVAR's. UPDATE OR INSERT command will use few times
  // more variables, than actually the command text has
  iInVarsCount := FStmt.InVars.VarCount;
  case GetCommandKind of
  skMerge:  iInVarsCount := iInVarsCount * 5;
  skUpdate: iInVarsCount := iInVarsCount * 3;
  end;
  iOutVarsCount := FStmt.OutVars.VarCount;

  // total size of SQL command, which will be send to server
  iBatchSize2 := 32700 div
    (Length(FDBCommandText) +
     iInVarsCount * 11 + 2 + iInVarsCount * (11 + 15 + 3) +
     iOutVarsCount * 11 + 2 + iOutVarsCount * (11 + 15 + 3));
  if iBatchSize2 < iBatchSize then
    iBatchSize := iBatchSize2;

  // maximum number of contexts
  if iBatchSize > 255 then
    iBatchSize := 255;

  if iBatchSize > LongWord(oResOpts.ArrayDMLSize) then
    iBatchSize := LongWord(oResOpts.ArrayDMLSize);

  // If block will have only single command, then go by standard
  // route - execute command once for each param array item.
  if iBatchSize <= 1 then begin
    DoExecute(ATimes, AOffset, ACount);
    Exit;
  end;

  iCurOffset := AOffset;
  iCurTimes := LongWord(AOffset) + iBatchSize;
  iLastBatchSize := 0;

  oStmt := TIBStatement.Create(IBConnection.FDatabase,
    TADPhysIBTransaction(FTransactionObj).FTransaction, Self);
  try
    SetupStatement(oStmt);

    while iCurOffset < ATimes do begin
      if iCurTimes > ATimes then
        iCurTimes := ATimes;

      if iLastBatchSize <> iCurTimes - iCurOffset then begin
        sBatchSQL := GenerateFB2BatchSQL(iCurTimes, iCurOffset);
        oStmt.Unprepare;
        oStmt.Prepare(sBatchSQL);
        if FStmt.OutVars.VarCount > 0 then
          oStmt.DescribeSelect;
        FStmt.OutVars.RowCount := 1;
        if FStmt.InVars.VarCount > 0 then
          oStmt.DescribeBind;
        FStmt.InVars.RowCount := 1;
        iLastBatchSize := iCurTimes - iCurOffset;
      end;

      SetFB2BatchParamValues(oStmt, iCurTimes, iCurOffset);
      oStmt.Execute(True);
      GetFB2BatchParamValues(oStmt, iCurTimes, iCurOffset);
      Inc(ACount, oStmt.RowsAffected);
      oStmt.Close;

      Inc(iCurOffset, iBatchSize);
      Inc(iCurTimes, iBatchSize);
    end;

  finally
    ADFree(oStmt);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.DoExecute(ATimes, AOffset: Integer;
  var ACount: TADCounter);
var
  i: Integer;
  iCount: TADCounter;
begin
  if ATimes - AOffset > 1 then begin
    for i := AOffset to ATimes - 1 do begin
      iCount := 0;
      DoExecute(i + 1, i, iCount);
      Inc(ACount, iCount);
    end;
  end
  else begin
    FStmt.InVars.RowCount := 1;
    SetParamValues(ATimes, AOffset);
    try
      try
        if UseExecDirect then
          FStmt.ExecuteImmediate(FDbCommandText)
        else
          // If it is INSERT / UPDATE ... RETURNING, then Firebird describes it
          // as EXECUTE PROCEDURE. In this case force to count inserted / updated
          // records.
          FStmt.Execute(IsReturning);
      except
        on E: EIBNativeException do begin
          E.Errors[0].RowIndex := AOffset;
          raise;
        end;
      end;
    finally
      if FStmt <> nil then
        Inc(ACount, FStmt.RowsAffected);
    end;
    if FStmt.OutVars.VarCount > 0 then
      GetParamValues(ATimes, AOffset);
    FStmt.Close;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.InternalExecute(ATimes, AOffset: Integer;
  var ACount: TADCounter);
begin
  CheckSPPrepared(skStoredProcNoCrs);
  CheckParamInfos;
  ACount := 0;
  if ATimes - AOffset > 1 then
    if (FStmt.Lib.Brand = ibInterbase) and (FStmt.Lib.Version >= ivIB110000) then
      DoExecuteIB2007Batch(ATimes, AOffset, ACount)
    else if (FStmt.Lib.Brand = ibFirebird) and (FStmt.Lib.Version >= ivFB020000) then
      DoExecuteFB2Batch(ATimes, AOffset, ACount)
    else
      DoExecute(ATimes, AOffset, ACount)
  else
    DoExecute(ATimes, AOffset, ACount);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.InternalAbort;
begin
  if FStmt <> nil then
    FStmt.Cancel;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBCommand.InternalOpen: Boolean;
var
  oFetchOpts: TADFetchOptions;
  iCount: TADCounter;
  lExactFetch: Boolean;
begin
  if not FCursorCanceled then begin
    Result := True;
    Exit;
  end
  else if (GetMetaInfoKind <> mkNone) and (FDbCommandText = '') then begin
    Result := False;
    Exit;
  end
  else if GetMetaInfoKind = mkProcArgs then
    FMaxInputPos := 0;
  if (GetCommandKind <> skStoredProc) and UseExecDirect then
    PrepareBase
  else
    CheckSPPrepared(skStoredProcWithCrs);
  CheckColInfos;
  Result := Length(FColInfos) > 0;
  if not Result then begin
    iCount := 0;
    InternalExecute(GetParams.ArraySize, 0, iCount);
  end
  else begin
    oFetchOpts := FOptions.FetchOptions;
    SetParamValues(1, 0);
    lExactFetch := (oFetchOpts.Mode = fmExactRecsMax) and (oFetchOpts.RecsMax = 1) and
      // isc_dsql_execute2 returns "Attempt to reopen an open cursor" on
      // second call for SELECT FOR UPDATE statement. For simple SELECT - OK.
      (FStmt.sql_stmt_type <> isc_info_sql_stmt_select_for_upd);
    try
      FStmt.Open(lExactFetch or (FStmt.sql_stmt_type = isc_info_sql_stmt_exec_procedure));
    except
      on E: EIBNativeException do begin
        if lExactFetch and (E.Kind in [ekNoDataFound, ekTooManyRows]) then
          // ADQA checks ADCode = er_AD_AccExactFetchMismatch in fmExactRecsMax tests
          E.ADCode := er_AD_AccExactMismatch;
        raise;
      end;
    end;
    FCursorCanceled := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.InternalClose;
begin
  if (FStmt <> nil) and not FCursorCanceled then begin
    if FRetWithOut then begin
      if not FStmt.Eof then
        FStmt.Fetch;
      CheckParamInfos;
      GetParamValues(1, 0);
    end;
    FCursorCanceled := True;
    FStmt.Close;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.FetchRow(ATable: TADDatSTable; AParentRow: TADDatSRow);
var
  oRow: TADDatSRow;
  oFmtOpts: TADFormatOptions;
  pColInfo: PADIBColInfoRec;
  j: Integer;
  lMetadata: Boolean;
  oCol: TADDatSColumn;

  function CreateBlob(const ABlobID: TISCQuad; ASrcDataType: TADDataType): TIBBlob;
  begin
    Result := TIBBlob.Create(FStmt.Database,
      TADPhysIBTransaction(FTransactionObj).FTransaction, Self);
    Result.BlobID := ABlobID;
    if ASrcDataType in C_AD_CharTypes then
      Result.sqlsubtype := isc_blob_text;
    Result.Open;
  end;

  procedure ProcessColumn(AColIndex: Integer; ARow: TADDatSRow;
    ApInfo: PADIBColInfoRec; ARowIndex: Integer);
  var
    pData: Pointer;
    iSize, iByteSize, iDestSize: LongWord;
    oBlob: TIBBlob;
  begin
    pData := nil;
    iSize := 0;

    // null
    if not ApInfo^.FVar.GetData(ARowIndex, pData, iSize, True) then
      ARow.SetData(AColIndex, nil, 0)

    // conversion is not required
    else if ApInfo^.FSrcDataType = ApInfo^.FDestDataType then
      if ApInfo^.FSrcSQLDataType = SQL_BLOB then begin
        oBlob := CreateBlob(PISCQuad(pData)^, ApInfo^.FSrcDataType);
        try
          iSize := oBlob.total_length;
          pData := ARow.BeginDirectWriteBlob(AColIndex, iSize);
          try
            if iSize > 0 then
              iSize := oBlob.Read(pData, iSize);
          finally
            ARow.EndDirectWriteBlob(AColIndex, iSize);
          end;
        finally
          ADFree(oBlob);
        end;
      end

      else if ApInfo^.FDestDataType in C_AD_VarLenTypes then
        ARow.SetData(AColIndex, pData, iSize)
      else begin
        FBuffer.Check(iSize);
        ApInfo^.FVar.GetData(ARowIndex, FBuffer.FBuffer, iSize, False);
        ARow.SetData(AColIndex, FBuffer.Ptr, iSize);
      end

    // conversion is required
    else begin
      if ApInfo^.FSrcSQLDataType = SQL_BLOB then begin
        oBlob := CreateBlob(PISCQuad(pData)^, ApInfo^.FSrcDataType);
        try
          iSize := oBlob.total_length;
          iByteSize := iSize;
          if oBlob.National then
            iByteSize := iByteSize * SizeOf(WideChar);
          pData := FBuffer.Check(iByteSize);
          if iSize > 0 then
            oBlob.Read(pData, iSize);
        finally
          ADFree(oBlob);
        end;
      end
      else begin
        iByteSize := iSize;
        if ApInfo^.FVar.National then
          iByteSize := iByteSize * SizeOf(WideChar);
        FBuffer.Check(iByteSize);
        ApInfo^.FVar.GetData(ARowIndex, FBuffer.FBuffer, iSize, False);
      end;
      iDestSize := 0;
      oFmtOpts.ConvertRawData(ApInfo^.FSrcDataType, ApInfo^.FDestDataType,
        FBuffer.Ptr, iSize, FBuffer.FBuffer, FBuffer.Size, iDestSize,
        IBConnection.FDatabase.Encoder);
      ARow.SetData(AColIndex, FBuffer.Ptr, iDestSize);
    end;
  end;

  function ProcessIB71MetaColumn(AColIndex: Integer; ARow: TADDatSRow;
    ApInfo: PADIBColInfoRec; ARowIndex: Integer): Boolean;
  var
    iVal: Integer;
    iSize: Longword;
    eIndexType: TADPhysIndexKind;
    eTableType: TADPhysTableKind;
    eScope: TADPhysObjectScope;
    pBlob: PISCQuad;
    eDataType: TADDataType;
    eRule: TADPhysCascadeRuleKind;
    s: String;

    procedure SetScope;
    begin
      if not ApInfo^.FVar.GetData(iVal, iSize) or (iVal = 0) then
        eScope := osMy
      else
        eScope := osSystem;
      ARow.SetData(AColIndex, Integer(eScope));
    end;

    procedure SetDataType;
    begin
      if not ApInfo^.FVar.GetData(iVal, iSize) or (iVal = 0) then
        eDataType := dtUnknown
      else
        case iVal of
        7: eDataType := dtInt16;
        8: eDataType := dtInt32;
        9: eDataType := dtInt64;
        10: eDataType := dtSingle;
        11: eDataType := dtDouble;
        12: eDataType := dtDate;
        13: eDataType := dtTime;
        14: eDataType := dtAnsiString;
        16: eDataType := dtInt64;
        17: eDataType := dtBoolean;
        27: eDataType := dtDouble;
        35: eDataType := dtDateTimeStamp;
        37: eDataType := dtAnsiString;
        40: eDataType := dtAnsiString;
        45: eDataType := dtBlob;
        261: eDataType := dtMemo;
        else eDataType := dtUnknown;
        end;
      ARow.SetData(AColIndex, Integer(eDataType));
    end;

  begin
    Result := False;
    case GetMetaInfoKind of
    mkIndexes:
      if AColIndex = 6 then begin
        if not ApInfo^.FVar.GetData(iVal, iSize) or (iVal = 0) then
          eIndexType := ikNonUnique
        else if (iVal = 1) and not VarIsNull(ARow.GetData(5)) then
          eIndexType := ikPrimaryKey
        else
          eIndexType := ikUnique;
        ARow.SetData(AColIndex, Integer(eIndexType));
        Result := True;
      end;
    mkTables:
      if AColIndex = 4 then begin
        if not ApInfo^.FVar.GetData(pBlob, iSize) then
          eTableType := tkTable
        else
          eTableType := tkView;
        ARow.SetData(AColIndex, Integer(eTableType));
        Result := True;
      end
      else if AColIndex = 5 then begin
        SetScope;
        Result := True;
      end;
    mkTableFields:
      if AColIndex = 6 then begin
        SetDataType;
        Result := True;
      end;
    mkForeignKeys:
      if (AColIndex = 8) or (AColIndex = 9) then begin
        s := ApInfo^.FVar.AsString;
        if CompareText('RESTRICT', s) = 0 then
          eRule := ckRestrict
        else if CompareText('CASCADE', s) = 0 then
          eRule := ckCascade
        else if CompareText('SET NULL', s) = 0 then
          eRule := ckSetNull
        else if CompareText('SET DEFAULT', s) = 0 then
          eRule := ckSetDefault
        else
          eRule := ckNone;
        ARow.SetData(AColIndex, Integer(eRule));
        Result := True;
      end;
    mkProcs:
      if AColIndex = 7 then begin
        SetScope;
        Result := True;
      end;
    mkProcArgs:
      if AColIndex = 9 then begin
        SetDataType;
        Result := True;
      end;
    mkGenerators:
      if AColIndex = 4 then begin
        SetScope;
        Result := True;
      end;
    mkResultSetFields:
      if (AColIndex = 7) or (AColIndex = 8) then begin
        if not ApInfo^.FVar.GetData(pBlob, iSize) then
          iVal := 0
        else
          iVal := 1;
        ARow.SetData(AColIndex, iVal);
        Result := True;
      end;
    end;
  end;

  procedure ProcessMetaColumn(AColIndex: Integer; ARow: TADDatSRow;
    ApInfo: PADIBColInfoRec; ARowIndex: Integer);
  var
    pData: Pointer;
    iSize, iDestSize: Longword;
  begin
    pData := nil;
    iSize := 0;

    if (IBConnection.FServerBrand = ibInterbase) and
       (IBConnection.FServerVersion < ivIB070500) and
       ProcessIB71MetaColumn(AColIndex, ARow, ApInfo, ARowIndex) then
      Exit

    else if AColIndex = 0 then
      ARow.SetData(0, ATable.Rows.Count + 1)

    else if not ApInfo^.FVar.GetData(ARowIndex, pData, iSize, True) then
      ARow.SetData(AColIndex, nil, 0)

    else if ApInfo^.FDestDataType in C_AD_VarLenTypes then begin
      if iSize > ATable.Columns[AColIndex].Size then
        iSize := ATable.Columns[AColIndex].Size;
      if ApInfo^.FDestDatatype in C_AD_AnsiTypes then begin
        FBuffer.Check(iSize * SizeOf(WideChar));
        oFmtOpts.ConvertRawData(dtAnsiString, dtWideString,
          pData, iSize, FBuffer.FBuffer, FBuffer.Size, iDestSize,
          IBConnection.FDatabase.Encoder);
        ARow.SetData(AColIndex, FBuffer.Ptr, iDestSize);
      end
      else
        ARow.SetData(AColIndex, pData, iSize);
    end

    else begin
      FBuffer.Check(iSize);
      ApInfo^.FVar.GetData(ARowIndex, FBuffer.FBuffer, iSize, False);
      iDestSize := 0;
      if ApInfo^.FDestDataType in C_AD_NumTypes then
        oFmtOpts.ConvertRawData(ApInfo^.FSrcDataType, ATable.Columns[AColIndex].DataType,
          FBuffer.Ptr, iSize, FBuffer.FBuffer, FBuffer.Size, iDestSize,
          IBConnection.FDatabase.Encoder)
      else
        iDestSize := iSize;
      ARow.SetData(AColIndex, FBuffer.Ptr, iDestSize);
    end;
  end;

  procedure AdjustProcArgPos;
  var
    eParamType: TParamType;
    iPos: Integer;
  begin
    eParamType := TParamType(oRow.GetData(8));
    case eParamType of
    ptInput:
      begin
        iPos := oRow.GetData(7);
        if iPos > FMaxInputPos then
          FMaxInputPos := iPos;
      end;
    ptOutput:
      oRow.SetData(7, oRow.GetData(7) + FMaxInputPos);
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
            ProcessMetaColumn(j, oRow, pColInfo, 0)
          else
            ProcessColumn(j, oRow, pColInfo, 0);
        end;
      end;
    if lMetadata and (GetMetaInfoKind = mkProcArgs) then
      AdjustProcArgPos;
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
function TADPhysIBCommand.InternalFetchRowSet(ATable: TADDatSTable;
  AParentRow: TADDatSRow; ARowsetSize: LongWord): LongWord;
var
  i: LongWord;
begin
  Result := 0;
  if FStmt <> nil then
    for i := 1 to ARowsetSize do begin
      if not FStmt.Fetch then
        Break;
      FetchRow(ATable, AParentRow);
      Inc(Result);
    end;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBCommand.InternalNextRecordSet: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADPhysIBCommand.GetItemCount: Integer;
begin
  Result := inherited GetItemCount;
  if FStmt <> nil then
    Inc(Result, 4);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysIBCommand.GetItem(AIndex: Integer; out AName: String;
  out AValue: Variant; out AKind: TADMoniAdapterItemKind);

  function Cnv(AValue: Int64): Variant;
  begin
{$IFNDEF AnyDAC_D6Base}
    Result := Integer(AValue);
{$ELSE}
    Result := AValue;
{$ENDIF}
  end;

begin
  if AIndex < inherited GetItemCount then
    inherited GetItem(AIndex, AName, AValue, AKind)
  else
    case AIndex - inherited GetItemCount of
    0:
      begin
        AName := 'Rows inserted';
        AValue := Cnv(FStmt.RowsInserted);
        AKind := ikStat;
      end;
    1:
      begin
        AName := 'Rows updated';
        AValue := Cnv(FStmt.RowsUpdated);
        AKind := ikStat;
      end;
    2:
      begin
        AName := 'Rows deleted';
        AValue := Cnv(FStmt.RowsDeleted);
        AKind := ikStat;
      end;
    3:
      begin
        AName := 'Rows selected';
        AValue := Cnv(FStmt.RowsSelected);
        AKind := ikStat;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
initialization
  ADPhysManager();
  ADPhysManagerObj.RegisterDriverClass(TADPhysIBDriver);

end.
