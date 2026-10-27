{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{             FireDAC high-level components             }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADCompClient;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Classes, SysUtils, DB,
  uADStanIntf, uADStanParam, uADStanUtil, uADStanError,
  uADDatSManager,
  uADGUIxIntf,
  uADPhysIntf,
  uADDAptColumn, uADDAptIntf,
  uADCompDataSet, uADCompGUIx, uADStanOption;

type
  TADCustomManager = class;
  TADCustomManagerClass = class of TADCustomManager;
  TADCustomConnection = class;
  TADCustomConnectionClass = class of TADCustomConnection;
  TADCustomTransaction = class;
  TADCustomEventAlerter = class;
  TADCustomCommand = class;
  TADCustomTableAdapter = class;
  TADCustomSchemaAdapter = class;
  TADCustomUpdateObject = class;
  TADLocalSQLDataSet = class;
  TADLocalSQLDataSets = class;
  TADCustomLocalSQL = class;
  TADAdaptedDataSet = class;
  TADCustomMemTable = class;
  TADRdbmsDataSet = class;
  TADCustomQuery = class;
  TADCustomStoredProc = class;

  TADManager = class;
  TADConnection = class;
  TADTransaction = class;
  TADEventAlerter = class;
  TADCommand = class;
  TADTableAdapter = class;
  TADSchemaAdapter = class;
  TADMetaInfoCommand = class;
  TADMemTable = class;
  TADQuery = class;
  TADTable = class;
  TADStoredProc = class;
  TADMetaInfoQuery = class;
  TADUpdateSQL = class;

  TADConnectionLoginEvent = procedure (AConnection: TADCustomConnection;
    const AConnectionDef: IADStanConnectionDef) of object;
  TADReconcileRowEvent = procedure (ASender: TObject; ARow: TADDatSRow;
    var Action: TADDAptReconcileAction) of object;
  TADUpdateRowEvent = procedure (ASender: TObject; ARow: TADDatSRow;
    ARequest: TADUpdateRequest; AUpdRowOptions: TADUpdateRowOptions;
    var AAction: TADErrorAction) of object;
  TADExecuteErrorEvent = procedure (ASender: TObject; ATimes, AOffset: LongInt;
    AError: EADDBEngineException; var AAction: TADErrorAction) of object;
  TADConnectionRecoverEvent = procedure (ASender: TObject; const AInitiator: IADStanObject;
    AException: Exception; var AAction: TADPhysConnectionRecoverAction) of object;
  TADEventAlerterEvent = procedure (ASender: TADCustomEventAlerter;
    const AEventName: String; const AArgument: Variant) of object;
  TADOperationFinishedEvent = procedure (ASander: TObject; AState: TADStanAsyncState;
    AException: Exception) of object;
{$IFDEF AnyDAC_FPC}
  TADConnectChangeEvent = procedure (ASender: TObject; AConnecting: Boolean) of object;
{$ENDIF}
  TADGetDatasetEvent = procedure (ASender: TObject; const AName: String;
    var ADataSet: TDataSet; var AAdapter: IADPhysLocalQueryAdapter) of object;
  TADReadDatasetEvent = procedure (ASender: TObject; const AName: String;
    const ADataSet: TDataSet) of object;

  TADCommandFlags = set of (ckMacros, ckLockParse, ckPrepare,
    ckCreateIntfDontPrepare);
  TADBindedBy = (bbNone, bbName, bbObject);
  TADReleaseClientMode = (rmFetchAll, rmClose, rmOffline, rmDisconnect);
  TADInfoReportItems = set of (riConnDef, riFireDAC, riClientLog, riClient,
    riSessionHints, riSession, riTryConnect, riKeepConnected);
  TADInfoReportStatus = set of (rsClientError, rsSessionError, rsClientWarning,
    rsSessionWarning);

  PADTableBookmarkData = ^TADTableBookmarkData;
  TADTableBookmarkData = record
    FDatasetData: TADBookmarkData;
    FValuesBuffer: array of Byte;
  end;

  TADCustomManager = class(TADComponent, {$IFNDEF AnyDAC_D6} IUnknown, {$ENDIF}
    IADStanOptions, IADStanObject)
  private
    FAutoCreated: Boolean;
    FStreamedActive: Boolean;
    FConnections: TADObjList;
    FBeforeStartup: TNotifyEvent;
    FAfterStartup: TNotifyEvent;
    FBeforeShutdown: TNotifyEvent;
    FAfterShutdown: TNotifyEvent;
    FLock: TADMREWSynchronizer;
    FOptionsIntf: IADStanOptions;
    FCachedConnection: TADCustomConnection;
    FActiveStoredUsage: TADStoredActivationUsage;
    function GetActive: Boolean;
    function GetConnectionDefFileName: String;
    function GetConnection(AIndex: Integer): TADCustomConnection;
    function GetConnectionCount: Integer;
    function GetSilentMode: Boolean;
    function GetWaitCursor: TADGUIxScreenCursor;
    procedure SetActive(const AValue: Boolean);
    procedure SetConnectionDefFileName(const AValue: String);
    procedure SetSilentMode(const AValue: Boolean);
    procedure SetWaitCursor(const AValue: TADGUIxScreenCursor);
    procedure AddConnection(AConn: TADCustomConnection);
    procedure RemoveConnection(AConn: TADCustomConnection);
    procedure SetOptionsIntf(const AValue: IADStanOptions);
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetResourceOptions: TADTopResourceOptions;
    function GetUpdateOptions: TADUpdateOptions;
    procedure SetFetchOptions(const AValue: TADFetchOptions);
    procedure SetFormatOptions(const AValue: TADFormatOptions);
    procedure SetUpdateOptions(const AValue: TADUpdateOptions);
    procedure SetResourceOptions(const AValue: TADTopResourceOptions);
    function GetConnectionDefs: IADStanConnectionDefs;
    function GetState: TADPhysManagerState;
    function GetAfterLoadConnectionDefFile: TNotifyEvent;
    function GetBeforeLoadConnectionDefFile: TNotifyEvent;
    function GetConnectionDefAutoLoad: Boolean;
    function GetConnectionDefsLoaded: Boolean;
    procedure SetAfterLoadConnectionDefFile(const AValue: TNotifyEvent);
    procedure SetBeforeLoadConnectionDefFile(const AValue: TNotifyEvent);
    procedure SetConnectionDefAutoLoad(const AValue: Boolean);
    function GetCanRefreshConnectionDefFile: Boolean;
    function GetDriverDefAutoLoad: Boolean;
    function GetDriverDefFileName: String;
    procedure SetDriverDefAutoLoad(const AValue: Boolean);
    procedure SetDriverDefFileName(const AValue: String);
    function GetDriverDefs: IADStanDefinitions;
    function GetActualConnectionDefFileName: String;
    function GetActualDriverDefFileName: String;
  protected
    // other
    procedure InternalClose; virtual;
    procedure InternalOpen; virtual;
    function InternalAcquireConnection(AConnection: TADCustomConnection;
      const AConnectionName, AObjName: String): TADCustomConnection; virtual;
    function InternalAcquireTemporaryConnection(const AConnectionName: string): TADCustomConnection; virtual;
    procedure InternalReleaseConnection(var AConnection: TADCustomConnection); virtual;
    function InternalFindConnection(const AConnectionName: string): TADCustomConnection; virtual;
    procedure DoBeforeStartup; virtual;
    procedure DoAfterStartup; virtual;
    procedure DoBeforeShutdown; virtual;
    procedure DoAfterShutdown; virtual;
    procedure Loaded; override;
    procedure CheckActive;
    procedure CheckInactive;
    { IADStanObject }
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    // IADStanOptions
    property OptionsIntfImpl: IADStanOptions read FOptionsIntf implements IADStanOptions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open;
    procedure Close;
    function AcquireConnection(const AConnectionName,
      AObjName: String): TADCustomConnection; overload;
    function AcquireConnection(AConnection: TADCustomConnection;
      const AObjName: String): TADCustomConnection; overload;
    procedure ReleaseConnection(var AConnection: TADCustomConnection);
    procedure DropConnections;
    function FindConnection(const AConnectionName: string): TADCustomConnection;
    procedure GetConnectionNames(AList: TStrings);
    procedure GetConnectionDefNames(AList: TStrings);
    procedure GetDriverNames(AList: TStrings; AValidate: Boolean = False;
      ABaseOnly: Boolean = False);
    procedure GetCatalogNames(const AConnectionName, APattern: string; AList: TStrings);
    procedure GetSchemaNames(const AConnectionName, ACatalogName, APattern: string;
      AList: TStrings);
    procedure GetTableNames(const AConnectionName, ACatalogName, ASchemaName,
      APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes = [osMy];
      AFullName: Boolean = True);
    procedure GetFieldNames(const AConnectionName, ACatalogName, ASchemaName,
      ATableName, APattern: string; AList: TStrings);
    procedure GetKeyFieldNames(const AConnectionName, ACatalogName, ASchemaName,
      ATableName, APattern: string; AList: TStrings);
    procedure GetPackageNames(const AConnectionName, ACatalogName, ASchemaName,
      APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes = [osMy];
      AFullName: Boolean = True);
    procedure GetStoredProcNames(const AConnectionName, ACatalogName, ASchemaName,
      APackage, APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes = [osMy];
      AFullName: Boolean = True);
    procedure GetGeneratorNames(const AConnectionName, ACatalogName, ASchemaName,
      APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes = [osMy];
      AFullName: Boolean = True);
    function IsConnectionDef(const AName: String): Boolean;
    procedure AddConnectionDef(const AName, ADriver: string; AList: TStrings;
      APersistent: Boolean = False);
    procedure DeleteConnectionDef(const AName: string);
    procedure ModifyConnectionDef(const AName: string; AList: TStrings);
    procedure GetConnectionDefParams(const AName: string; AList: TStrings);
    procedure CloseConnectionDef(const AName: string);
    procedure SaveConnectionDefFile;
    procedure LoadConnectionDefFile;
    procedure RefreshMetadataCache;
    procedure RefreshConnectionDefFile;
    function GetBaseDriverID(const ADriverID: String): String;
    function GetRDBMSKind(const ADriverID: String): TADRDBMSKind;
    // RO
    property State: TADPhysManagerState read GetState;
    property AutoCreated: Boolean read FAutoCreated;
    property ConnectionCount: Integer read GetConnectionCount;
    property Connections[Index: Integer]: TADCustomConnection read GetConnection;
    property ConnectionDefs: IADStanConnectionDefs read GetConnectionDefs;
    property DriverDefs: IADStanDefinitions read GetDriverDefs;
    property ConnectionDefFileLoaded: Boolean read GetConnectionDefsLoaded;
    property CanRefreshConnectionDefFile: Boolean read GetCanRefreshConnectionDefFile;
    property ActualDriverDefFileName: String read GetActualDriverDefFileName;
    property ActualConnectionDefFileName: String read GetActualConnectionDefFileName;
    // RW
    property DriverDefFileAutoLoad: Boolean read GetDriverDefAutoLoad
      write SetDriverDefAutoLoad default True;
    property DriverDefFileName: String read GetDriverDefFileName
      write SetDriverDefFileName;
    property ConnectionDefFileAutoLoad: Boolean read GetConnectionDefAutoLoad
      write SetConnectionDefAutoLoad default True;
    property ConnectionDefFileName: String read GetConnectionDefFileName
      write SetConnectionDefFileName;

    property WaitCursor: TADGUIxScreenCursor read GetWaitCursor
      write SetWaitCursor default gcrSQLWait;
    property SilentMode: Boolean read GetSilentMode write SetSilentMode default False;

    property OptionsIntf: IADStanOptions read FOptionsIntf write SetOptionsIntf;
    property FetchOptions: TADFetchOptions read GetFetchOptions write SetFetchOptions;
    property FormatOptions: TADFormatOptions read GetFormatOptions write SetFormatOptions;
    property UpdateOptions: TADUpdateOptions read GetUpdateOptions write SetUpdateOptions;
    property ResourceOptions: TADTopResourceOptions read GetResourceOptions write SetResourceOptions;

    property Active: Boolean read GetActive write SetActive default False;
    property ActiveStoredUsage: TADStoredActivationUsage read FActiveStoredUsage
      write FActiveStoredUsage default [auDesignTime, auRunTime];

    property BeforeStartup: TNotifyEvent read FBeforeStartup write FBeforeStartup;
    property AfterStartup: TNotifyEvent read FAfterStartup write FAfterStartup;
    property BeforeShutdown: TNotifyEvent read FBeforeShutdown write FBeforeShutdown;
    property AfterShutdown: TNotifyEvent read FAfterShutdown write FAfterShutdown;
    property BeforeLoadConnectionDefFile: TNotifyEvent
      read GetBeforeLoadConnectionDefFile write SetBeforeLoadConnectionDefFile;
    property AfterLoadConnectionDefFile: TNotifyEvent
      read GetAfterLoadConnectionDefFile write SetAfterLoadConnectionDefFile;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADManager = class(TADCustomManager)
  published
    property DriverDefFileAutoLoad;
    property DriverDefFileName;
    property ConnectionDefFileAutoLoad;
    property ConnectionDefFileName;
    property WaitCursor;
    property SilentMode;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property ActiveStoredUsage;
    property Active;
    property BeforeStartup;
    property AfterStartup;
    property BeforeShutdown;
    property AfterShutdown;
    property BeforeLoadConnectionDefFile;
    property AfterLoadConnectionDefFile;
  end;

  TADCustomConnection = class(TCustomConnection,
    {$IFNDEF AnyDAC_D6} IUnknown, {$ENDIF}
    IADStanOptions, IADStanErrorHandler, IADStanObject, IADPhysConnectionRecoveryHandler,
    IADPhysTransactionStateHandler)
  private
{$IFDEF AnyDAC_FPC}
    FClients: TADObjList;
    FDataSets: TADObjList;
    FConnectEvents: TADObjList;
{$ENDIF}
    FConnectionIntf: IADPhysConnection;
    FTmpConnectionIntf: IADPhysConnection;
    FConnectionName: String;
    FParams: IADStanConnectionDef;
    FRefCount: Integer;
    FTemporary: Boolean;
    FOnLogin: TADConnectionLoginEvent;
    FOptionsIntf: IADStanOptions;
    FTxOptions: TADTxOptions;
    FCommands: TADObjList;
    FOnError: TADErrorEvent;
    FLoginDialog: TADGUIxLoginDialog;
    FSharedCliHandle: Pointer;
    FOfflined: Boolean;
    FOnLosted: TNotifyEvent;
    FOnRestored: TNotifyEvent;
    FOnRecover: TADConnectionRecoverEvent;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FUpdateTransaction: TADCustomTransaction;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FTransaction: TADCustomTransaction;
    FLastUsed: TDateTime;
    FConnectedStoredUsage: TADStoredActivationUsage;
    FExecSQLCommand: IADPhysCommand;
    FExecSQLTab: TADDatSTable;
    FDisconnecting: Boolean;
    FDeferredUnregs: TADObjList;
    FBeforeStartTransaction: TNotifyEvent;
    FAfterStartTransaction: TNotifyEvent;
    FBeforeCommit: TNotifyEvent;
    FAfterCommit: TNotifyEvent;
    FBeforeRollback: TNotifyEvent;
    FAfterRollback: TNotifyEvent;
    function GetParams: TStrings;
    procedure SetConnectionName(const AValue: String);
    procedure SetParams(const AValue: TStrings);
    procedure ParamsChanging(ASender: TObject);
    function GetConnectionDefName: string;
    procedure SetConnectionDefName(const AValue: string);
    function GetDriverName: string;
    procedure SetDriverName(const AValue: string);
    function GetInTransaction: Boolean;
    function GetSQLBased: Boolean;
    procedure AttachClient(AObj: TObject);
    procedure DetachClient(AObj: TObject);
    function GetCommandCount: Integer;
    function GetCommands(AIndex: Integer): TADCustomCommand;
    procedure GetParentOptions(out AOpts: IADStanOptions);
    procedure SetOptionsIntf(const AValue: IADStanOptions);
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetUpdateOptions: TADUpdateOptions;
    function GetResourceOptions: TADTopResourceOptions;
    procedure SetFetchOptions(const AValue: TADFetchOptions);
    procedure SetFormatOptions(const AValue: TADFormatOptions);
    procedure SetUpdateOptions(const AValue: TADUpdateOptions);
    procedure SetResourceOptions(const AValue: TADTopResourceOptions);
    procedure SetTxOptions(const AValue: TADTxOptions);
    function GetRDBMSKind: TADRDBMSKind;
    function CnvMetaValue(const AStr: Variant; const ADefault: String = ''): String;
    procedure DoInternalLogin;
    function GetConnectionMetadata(AOpen: Boolean = False): IADPhysConnectionMetadata;
    procedure SetLoginDialog(const AValue: TADGUIxLoginDialog);
    function GetCliObj: Pointer;
    function GetCliHandle: Pointer;
    procedure SetOfflined(AValue: Boolean);
    procedure AcquireDefaultTransaction(const AConnIntf: IADPhysConnection);
    procedure AcquireConnectionIntf(out AConnIntf: IADPhysConnection);
    procedure ReleaseDefaultTransaction(const AConnIntf: IADPhysConnection);
    procedure ReleaseConnectionIntf(var AConnIntf: IADPhysConnection);
    function GetMessages: EADDBEngineException;
    function BaseCreateSQL: IADPhysCommand;
    function BasePrepareSQL(const ACommand: IADPhysCommand; const ASQL: String;
      const AParams: array of Variant; const ATypes: array of TFieldType): Boolean;
    function GetConnectionMetadataIntf: IADPhysConnectionMetadata;
    function GetConnectionString: String;
    procedure SetConnectionString(const AConnectionString: String);
    procedure SetUserNamePassword(const AUserName, APassword: String);
    procedure PrepareConnectionDef;
    procedure SetSharedCliHandle(const AValue: Pointer);
    function EncodeListName(const ACatalogName, ASchemaName: String;
      const ABaseField, AObjField: String; ARow: TADDatSRow; AList: TStrings;
      AFullName: Boolean): String;
  protected
    { IADStanObject }
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    { IADStanErrorHandler }
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception); virtual;
    { IADPhysConnectionRecoveryHandler }
    procedure HandleConnectionRecover(const AInitiator: IADStanObject;
      AException: Exception; var AAction: TADPhysConnectionRecoverAction);
    procedure HandleConnectionRestored;
    procedure HandleConnectionLosted;
    { IADPhysTransactionStateHandler }
    procedure HandleDisconnectCommands(AFilter: TADPhysDisconnectFilter;
      AMode: TADPhysDisconnectMode);
    procedure HandleTxOperation(AOperation: TADPhysTransactionState;
      ABefore: Boolean);
    // other
{$IFDEF AnyDAC_FPC}
    function GetDataSet(AIndex: Integer): TDataSet; override;
    function GetDataSetCount: Integer; override;
    procedure SendConnectEvent(AConnecting: Boolean);
    procedure RegisterClient(AClient: TObject; AEvent: TADConnectChangeEvent = nil);
{$ENDIF}
    procedure UnRegisterClient(AClient: TObject); {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    procedure DoConnect; override;
    procedure DoDisconnect; override;
    procedure DoValidateName(const AName: string); virtual;
    function GetConnected: Boolean; override;
    procedure SetConnected(AValue: Boolean); override;
    procedure DoLogin(const AConnectionDef: IADStanConnectionDef); virtual;
    procedure DoRecover(const AInitiator: IADStanObject; AException: Exception;
      var AAction: TADPhysConnectionRecoverAction); virtual;
    procedure DoRestored; virtual;
    procedure DoLosted; virtual;
    function GetADDataSet(AIndex: Integer): TADDataSet;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure SetTransaction(const AValue: TADCustomTransaction); virtual;
    procedure SetUpdateTransaction(const AValue: TADCustomTransaction); virtual;
    // IADStanOptions
    property OptionsIntfImpl: IADStanOptions read FOptionsIntf implements IADStanOptions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Commit;
    procedure CommitRetaining;
    procedure Rollback;
    procedure RollbackRetaining;
    procedure StartTransaction;

    procedure Open(const AConnectionString: String); overload;
    procedure Open(const AConnectionString: String;
      const AUserName: String; const APassword: String); overload;
    procedure Open(const AUserName: String; const APassword: String); overload;
    procedure Offline;
    procedure Online;
    procedure CheckOnline;
    procedure CheckActive;
    procedure CheckInactive;
    function Ping: Boolean;
    procedure AbortJob(AWait: Boolean = False);

{$IFDEF AnyDAC_MONITOR_Comp}
    procedure Trace(AStep: TADMoniEventStep; ASender: TObject;
      const AMsg: String; const AArgs: array of const);
{$ENDIF}
    function GetInfoReport(AList: TStrings;
      AItems: TADInfoReportItems = [riConnDef .. riKeepConnected]): TADInfoReportStatus;

    procedure GetCatalogNames(const APattern: string; AList: TStrings);
    procedure GetSchemaNames(const ACatalogName, APattern: string; AList: TStrings);
    procedure GetTableNames(const ACatalogName, ASchemaName, APattern: string;
      AList: TStrings; AScopes: TADPhysObjectScopes = [osMy];
      AKinds: TADPhysTableKinds = [tkSynonym, tkTable, tkView];
      AFullName: Boolean = True);
    procedure GetFieldNames(const ACatalogName, ASchemaName, ATableName, APattern: string;
      AList: TStrings);
    procedure GetKeyFieldNames(const ACatalogName, ASchemaName, ATableName, APattern: string;
      AList: TStrings);
    procedure GetPackageNames(const ACatalogName, ASchemaName, APattern: string;
      AList: TStrings; AScopes: TADPhysObjectScopes = [osMy];
      AFullName: Boolean = True);
    procedure GetStoredProcNames(const ACatalogName, ASchemaName, APackage, APattern: string;
      AList: TStrings; AScopes: TADPhysObjectScopes = [osMy]; AFullName: Boolean = True);
    procedure GetGeneratorNames(const ACatalogName, ASchemaName, APattern: string;
      AList: TStrings; AScopes: TADPhysObjectScopes = [osMy]; AFullName: Boolean = True);
    procedure RefreshMetadataCache(const AObjName: String = '');

    function EncodeObjectName(const ACatalogName, ASchemaName, ABaseObjectName,
      AObjectName: String): String;
    procedure DecodeObjectName(const AFullName: String; var ACatalogName,
      ASchemaName, ABaseObjectName, AObjectName: String);

    procedure CheckConnectionDef; virtual;
    procedure ApplyUpdates(const ADataSets: array of TADDataSet);
    procedure ReleaseClients(AMode: TADReleaseClientMode = rmDisconnect);
    function GetLastAutoGenValue(const AName: String): Variant;
    function ExecSQL(const ASQL: String): LongInt; overload;
    function ExecSQL(const ASQL: String; const AParams: array of Variant): LongInt; overload;
    function ExecSQL(const ASQL: String; const AParams: array of Variant;
      const ATypes: array of TFieldType): LongInt; overload;
    function ExecSQLScalar(const ASQL: String): Variant; overload;
    function ExecSQLScalar(const ASQL: String; const AParams: array of Variant): Variant; overload;
    function ExecSQLScalar(const ASQL: String; const AParams: array of Variant;
      const ATypes: array of TFieldType): Variant; overload;

    property IsSQLBased: Boolean read GetSQLBased;
    property RDBMSKind: TADRDBMSKind read GetRDBMSKind;
    property InTransaction: Boolean read GetInTransaction;
    property DataSets[AIndex: Integer]: TADDataSet read GetADDataSet;
    property CommandCount: Integer read GetCommandCount;
    property Commands[AIndex: Integer]: TADCustomCommand read GetCommands;
    property LastUsed: TDateTime read FLastUsed;
    property RefCount: Integer read FRefCount;
    property Messages: EADDBEngineException read GetMessages;

    property ConnectionIntf: IADPhysConnection read FConnectionIntf;
    property ConnectionMetaDataIntf: IADPhysConnectionMetadata read GetConnectionMetadataIntf;
    property CliObj: Pointer read GetCliObj;
    property CliHandle: Pointer read GetCliHandle;
    property SharedCliHandle: Pointer read FSharedCliHandle write SetSharedCliHandle;

    property ConnectionName: String read FConnectionName write SetConnectionName;
    property ConnectionDefName: String read GetConnectionDefName write SetConnectionDefName stored False;
    property ConnectionString: String read GetConnectionString write SetConnectionString;
    property DriverName: string read GetDriverName write SetDriverName stored False;
    property Params: TStrings read GetParams write SetParams;
    property ResultConnectionDef: IADStanConnectionDef read FParams;

    property OptionsIntf: IADStanOptions read FOptionsIntf write SetOptionsIntf;
    property FetchOptions: TADFetchOptions read GetFetchOptions write SetFetchOptions;
    property FormatOptions: TADFormatOptions read GetFormatOptions write SetFormatOptions;
    property UpdateOptions: TADUpdateOptions read GetUpdateOptions write SetUpdateOptions;
    property ResourceOptions: TADTopResourceOptions read GetResourceOptions write SetResourceOptions;
    property TxOptions: TADTxOptions read FTxOptions write SetTxOptions;

    property Temporary: Boolean read FTemporary write FTemporary default False;
    {$IFDEF AnyDAC_D17} [Default(False)] {$ENDIF}
{$IFDEF AnyDAC_FPC}
    // FPC does not have "default" value for this property
    property Connected default False;
{$ENDIF}
{$IFDEF AnyDAC_D14}
    // include Connected into public section, so DOM will allow to document this property
    property Connected default False;
{$ENDIF}
    property ConnectedStoredUsage: TADStoredActivationUsage read FConnectedStoredUsage
      write FConnectedStoredUsage default [auDesignTime, auRunTime];
    property Offlined: Boolean read FOfflined write SetOfflined default False;
    {$IFDEF AnyDAC_D17} [Default(True)] {$ENDIF}
    property LoginPrompt default True;
    property LoginDialog: TADGUIxLoginDialog read FLoginDialog write SetLoginDialog;

    property Transaction: TADCustomTransaction read FTransaction
      write SetTransaction;
    property UpdateTransaction: TADCustomTransaction read FUpdateTransaction
      write SetUpdateTransaction;

    property OnLogin: TADConnectionLoginEvent read FOnLogin write FOnLogin;
    property OnError: TADErrorEvent read FOnError write FOnError;
    property OnLosted: TNotifyEvent read FOnLosted write FOnLosted;
    property OnRestored: TNotifyEvent read FOnRestored write FOnRestored;
    property OnRecover: TADConnectionRecoverEvent read FOnRecover write FOnRecover;
    property BeforeStartTransaction: TNotifyEvent read FBeforeStartTransaction
      write FBeforeStartTransaction;
    property AfterStartTransaction: TNotifyEvent read FAfterStartTransaction
      write FAfterStartTransaction;
    property BeforeCommit: TNotifyEvent read FBeforeCommit write FBeforeCommit;
    property AfterCommit: TNotifyEvent read FAfterCommit write FAfterCommit;
    property BeforeRollback: TNotifyEvent read FBeforeRollback write FBeforeRollback;
    property AfterRollback: TNotifyEvent read FAfterRollback write FAfterRollback;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADConnection = class(TADCustomConnection)
  published
    property ConnectionDefName;
    property DriverName;
    property ConnectionName;
    property Params;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property TxOptions;
    property ConnectedStoredUsage;
    property Connected;
    property LoginDialog;
    property LoginPrompt;
    property Transaction;
    property UpdateTransaction;
    property OnLogin;
    property OnError;
    property OnLosted;
    property OnRestored;
    property OnRecover;
    property AfterConnect;
    property BeforeConnect;
    property AfterDisconnect;
    property BeforeDisconnect;
    property BeforeStartTransaction;
    property AfterStartTransaction;
    property BeforeCommit;
    property AfterCommit;
    property BeforeRollback;
    property AfterRollback;
  end;

  TADCustomTransaction = class(TADComponent, IADPhysTransactionStateHandler)
  private
    FTransactionIntf: IADPhysTransaction;
    FConnection: TADCustomConnection;
    FOptionsIntf: TADTxOptions;
    FDataSets: TADObjList;
    FNestingLevel: LongWord;
    FSerialID: LongWord;
    FBeforeStartTransaction: TNotifyEvent;
    FAfterStartTransaction: TNotifyEvent;
    FBeforeCommit: TNotifyEvent;
    FAfterCommit: TNotifyEvent;
    FBeforeRollback: TNotifyEvent;
    FAfterRollback: TNotifyEvent;
    function GetActive: Boolean;
    function GetDataSetCount: Integer;
    function GetDataSets(AIndex: Integer): TADDataSet;
    procedure SetConnection(const AValue: TADCustomConnection);
    procedure SetOptions(const AValue: TADTxOptions);
    procedure DoConnectChanged(Sender: TObject; Connecting: Boolean);
    procedure InternalCreateTxIntf;
    procedure InternalDeleteTxIntf;
    procedure CheckReleased(ARetaining, AMyTrans: Boolean);
  protected
    procedure CheckConnected;
    function CheckActive: Boolean;
    // IADPhysTransactionStateHandler
    procedure HandleDisconnectCommands(AFilter: TADPhysDisconnectFilter;
      AMode: TADPhysDisconnectMode);
    procedure HandleTxOperation(AOperation: TADPhysTransactionState;
      ABefore: Boolean);
    // other
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StartTransaction;
    procedure Commit;
    procedure CommitRetaining;
    procedure Rollback;
    procedure RollbackRetaining;
    property Active: Boolean read GetActive;
    property TransactionIntf: IADPhysTransaction read FTransactionIntf;
    property DataSetCount: Integer read GetDataSetCount;
    property DataSets[AIndex: Integer]: TADDataSet read GetDataSets;
    property Options: TADTxOptions read FOptionsIntf write SetOptions;
    property Connection: TADCustomConnection read FConnection write SetConnection;
    property BeforeStartTransaction: TNotifyEvent read FBeforeStartTransaction
      write FBeforeStartTransaction;
    property AfterStartTransaction: TNotifyEvent read FAfterStartTransaction
      write FAfterStartTransaction;
    property BeforeCommit: TNotifyEvent read FBeforeCommit write FBeforeCommit;
    property AfterCommit: TNotifyEvent read FAfterCommit write FAfterCommit;
    property BeforeRollback: TNotifyEvent read FBeforeRollback write FBeforeRollback;
    property AfterRollback: TNotifyEvent read FAfterRollback write FAfterRollback;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADTransaction = class(TADCustomTransaction)
  published
    property Options;
    property Connection;
    property BeforeStartTransaction;
    property AfterStartTransaction;
    property BeforeCommit;
    property AfterCommit;
    property BeforeRollback;
    property AfterRollback;
  end;

  TADCustomEventAlerter = class (TADComponent, IADPhysEventHandler)
  private
    FEventAlerterIntf: IADPhysEventAlerter;
    FConnection: TADCustomConnection;
    FNames: TStrings;
    FOptionsIntf: TADEventAlerterOptions;
    FOnAlert: TADEventAlerterEvent;
    FOnTimeout: TNotifyEvent;
    FStreamedActive: Boolean;
    procedure CheckAutoRegister;
    function GetActive: Boolean;
    procedure SetConnection(const AValue: TADCustomConnection);
    procedure SetNames(const AValue: TStrings);
    procedure SetOptions(const AValue: TADEventAlerterOptions);
    procedure DoConnectChanged(Sender: TObject; Connecting: Boolean);
    procedure DoNamesChanged(ASender: TObject);
    procedure SetActive(const AValue: Boolean);
  protected
    // IADPhysEventHandler
    procedure HandleEvent(const AEventName: String; const AArgument: Variant);
    procedure HandleTimeout(var AContinue: Boolean);
    // other
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Register;
    procedure Unregister;
    procedure Signal(const AEvent: String; const AArgument: Variant);
    property Active: Boolean read GetActive write SetActive default False;
    property EventAlerterIntf: IADPhysEventAlerter read FEventAlerterIntf;
    property Connection: TADCustomConnection read FConnection write SetConnection;
    property Names: TStrings read FNames write SetNames;
    property Options: TADEventAlerterOptions read FOptionsIntf write SetOptions;
    property OnAlert: TADEventAlerterEvent read FOnAlert write FOnAlert;
    property OnTimeout: TNotifyEvent read FOnTimeout write FOnTimeout;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADEventAlerter = class(TADCustomEventAlerter)
  published
    property Active;
    property Connection;
    property Names;
    property Options;
    property OnAlert;
    property OnTimeout;
  end;

  TADCustomCommand = class(TADComponent, {$IFNDEF AnyDAC_D6} IUnknown, {$ENDIF}
    IADStanOptions, IADStanErrorHandler, IADStanObject, IADStanAsyncHandler,
    IADPhysCommandStateHandler)
  private
    FCommandIntf: IADPhysCommand;
    FCommandText: TStrings;
    FConnectionName: String;
    FConnection: TADCustomConnection;
    FOptionsIntf: IADStanOptions;
    FParams: TADParams;
    FMacros: TADMacros;
    FStreamedActive, FStreamedPrepared: Boolean;
    FFlags: TADCommandFlags;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FOwner: TADDataSet;
    FRowsAffected: TADCounter;
    FOverload: Word;
    FBeforePrepare, FAfterPrepare,
    FBeforeUnprepare, FAfterUnprepare,
    FBeforeOpen, FAfterOpen,
    FBeforeClose, FAfterClose,
    FBeforeExecute, FAfterExecute,
    FBeforeFetch, FAfterFetch: TNotifyEvent;
    FFixedCommandKind: Boolean;
    FCommandKind: TADPhysCommandKind;
    FBaseObjectName: String;
    FSchemaName: String;
    FCatalogName: String;
    FBindedBy: TADBindedBy;
    FOnError: TADErrorEvent;
    FOnCommandChanged: TNotifyEvent;
    FOperationFinished: TADOperationFinishedEvent;
    FThreadID: TADThreadID;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FTableAdapter: TADCustomTableAdapter;
    FTransaction: TADCustomTransaction;
    FActiveStoredUsage: TADStoredActivationUsage;
    function GetCommandKind: TADPhysCommandKind;
    function GetState: TADPhysCommandState;
    procedure SetConnection(const AValue: TADCustomConnection);
    procedure SetConnectionName(const AValue: String);
    function GetActive: Boolean;
    procedure SetActiveBase(const AValue, ABlocked: Boolean);
    procedure SetActive(const AValue: Boolean);
    function IsPS: Boolean;
    function GetPrepared: Boolean;
    procedure SetPrepared(const AValue: Boolean);
    procedure CheckInactive;
    procedure CheckActive;
    procedure GetParentOptions(out AOpts: IADStanOptions);
    procedure SetOptionsIntf(const AValue: IADStanOptions);
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetResourceOptions: TADBottomResourceOptions;
    function GetUpdateOptions: TADBottomUpdateOptions;
    procedure SetFetchOptions(const AValue: TADFetchOptions);
    procedure SetFormatOptions(const AValue: TADFormatOptions);
    procedure SetUpdateOptions(const AValue: TADBottomUpdateOptions);
    procedure SetResourceOptions(const AValue: TADBottomResourceOptions);
    procedure DoSQLChanging(ASender: TObject);
    procedure DoSQLChange(ASender: TObject);
    procedure PreprocessSQL(const ASQL: String; AParams: TADParams;
      AMacrosUpd, AMacrosRead: TADMacros; ACreateParams, ACreateMacros,
      AExpandMacros, AExpandEscape, AParseSQL: Boolean;
      var ACommandKind: TADPhysCommandKind; var AFrom: String);
    procedure SetCommandTextStrs(const AValue: TStrings); overload;
    procedure SetCommandText(const ASQL: String; AResetParams: Boolean); overload;
    procedure SetMacros(const AValue: TADMacros);
    procedure SetParams(const AValue: TADParams);
    function IsCNNS: Boolean;
    function IsCNS: Boolean;
    procedure SetOverload(const AValue: Word);
    procedure CheckUnprepared;
    procedure CheckAsyncProgress;
    procedure CheckPrepared;
    procedure SetCommandKind(const AValue: TADPhysCommandKind);
    procedure SetBaseObjectName(const AValue: String);
    procedure SetSchemaName(const AValue: String);
    function CheckComponentState(AState: TComponentState): Boolean;
    procedure SetCatalogName(const AValue: String);
    procedure MacrosChanged(ASender: TObject);
    procedure PropertyChange;
    procedure SetParamBindMode(const AValue: TADParamBindMode);
    procedure InternalCloseConnection;
    function GetConnectionMetadata: IADPhysConnectionMetadata;
    procedure FetchFinished(ASender: TObject; AState: TADStanAsyncState;
      AException: Exception);
    procedure ReadMacros(Reader: TReader);
    procedure ReadParams(Reader: TReader);
    procedure WriteMacros(Writer: TWriter);
    procedure WriteParams(Writer: TWriter);
    function GetParamBindMode: TADParamBindMode;
    function IsCKS: Boolean;
    function GetParamsOwner: TPersistent;
    function GetDisplayName: String;
    function GetSQLText: String;
    function GetValues(const AParamNames: String): Variant;
    procedure SetValues(const AParamNames: String; const AValue: Variant);
    procedure ReadPrepared(Reader: TReader);
    function DoStoredActivation: Boolean;
  protected
    FEnableParamsStorage: Boolean;
    { IADStanObject }
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    { IADStanErrorHandler }
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception); virtual;
    { IADPhysCommandStateHandler }
    procedure HandleFinished(const AInitiator: IADStanObject;
      AState: TADStanAsyncState; AException: Exception); virtual;
    procedure HandleUnprepare;
    // other
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure DefineProperties(AFiler: TFiler); override;
    // own
    procedure InternalCreateCommandIntf; virtual;
    procedure InternalPrepare; virtual;
    procedure InternalUnprepare; virtual;
    procedure InternalOpen(ABlocked: Boolean); virtual;
    procedure InternalOpenFinished(ASender: TObject; AState: TADStanAsyncState;
      AException: Exception); virtual;
    procedure InternalClose(AAll: Boolean); virtual;
    procedure InternalExecute(ATimes: Integer; AOffset: Integer; ABlocked: Boolean); virtual;
    procedure InternalExecuteFinished(ASender: TObject; AState: TADStanAsyncState;
      AException: Exception); virtual;
    procedure DoBeforePrepare; virtual;
    procedure DoBeforeUnprepare; virtual;
    procedure DoAfterPrepare; virtual;
    procedure DoAfterUnprepare; virtual;
    procedure DoBeforeOpen; virtual;
    procedure DoBeforeClose; virtual;
    procedure DoAfterOpen; virtual;
    procedure DoAfterClose; virtual;
    procedure DoAfterExecute; virtual;
    procedure DoBeforeExecute; virtual;
    procedure DoAfterFetch; virtual;
    procedure DoBeforeFetch; virtual;
    procedure SetTransaction(const AValue: TADCustomTransaction); virtual;
    // IADStanOptions
    property OptionsIntfImpl: IADStanOptions read FOptionsIntf implements IADStanOptions;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetConnection(ACheck: Boolean): TADCustomConnection;
    function AcquireConnection: TADCustomConnection;
    procedure ReleaseConnection(var AConnection: TADCustomConnection);
    procedure FillParams(AParams: TADParams; const ASQL: String = '');
    function FindParam(const AValue: string): TADParam;
    function ParamByName(const AValue: string): TADParam;
    function FindMacro(const AValue: string): TADMacro;
    function MacroByName(const AValue: string): TADMacro;

{$IFDEF AnyDAC_MONITOR_Comp}
    procedure Trace(AStep: TADMoniEventStep;
      const AMsg: String; const AArgs: array of const);
{$ENDIF}

    procedure AbortJob(AWait: Boolean = False);
    procedure Disconnect(AAbortJob: Boolean = False);
    procedure Prepare(const ACommandText: String = '');
    procedure Unprepare;
    procedure Open(ABlocked: Boolean = False);
    function OpenOrExecute(ABlocked: Boolean = False): Boolean;
    procedure Close;
    procedure CloseAll;
    procedure NextRecordSet;
    procedure Execute(ATimes: Integer = 0; AOffset: Integer = 0; ABlocked: Boolean = False); overload;
    function Execute(const ASQL: String): LongInt; overload;
    function Execute(const ASQL: String; const AParams: array of Variant): LongInt; overload;
    function Execute(const ASQL: String; const AParams: array of Variant;
      const ATypes: array of TFieldType): LongInt; overload;
    function Define(ASchema: TADDatSManager; ATable: TADDatSTable = nil;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset): TADDatSTable; overload;
    function Define(ATable: TADDatSTable = nil;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset): TADDatSTable; overload;
    procedure Fetch(ATable: TADDatSTable; AAll: Boolean = True; ABlocked: Boolean = False); overload;

    property BindedBy: TADBindedBy read FBindedBy;
    property CommandIntf: IADPhysCommand read FCommandIntf;
    property RowsAffected: TADCounter read FRowsAffected;
    property State: TADPhysCommandState read GetState;
    property SQLText: String read GetSQLText;
    property DataSet: TADDataSet read FOwner;

    property OptionsIntf: IADStanOptions read FOptionsIntf write SetOptionsIntf;
    property FormatOptions: TADFormatOptions read GetFormatOptions write SetFormatOptions;
    property FetchOptions: TADFetchOptions read GetFetchOptions write SetFetchOptions;
    property ResourceOptions: TADBottomResourceOptions read GetResourceOptions write SetResourceOptions;
    property UpdateOptions: TADBottomUpdateOptions read GetUpdateOptions write SetUpdateOptions;

    property Connection: TADCustomConnection read FConnection write SetConnection stored IsCNS;
    property ConnectionName: String read FConnectionName write SetConnectionName stored IsCNNS;
    property Transaction: TADCustomTransaction read FTransaction write SetTransaction;
    property CatalogName: String read FCatalogName write SetCatalogName;
    property SchemaName: String read FSchemaName write SetSchemaName;
    property BaseObjectName: String read FBaseObjectName write SetBaseObjectName;
    property Overload: Word read FOverload write SetOverload default 0;
    property Macros: TADMacros read FMacros write SetMacros stored False;
    property Params: TADParams read FParams write SetParams stored False;
    property ParamBindMode: TADParamBindMode read GetParamBindMode
      write SetParamBindMode default pbByName;
    property FixedCommandKind: Boolean read FFixedCommandKind write FFixedCommandKind;
    property CommandKind: TADPhysCommandKind read GetCommandKind write SetCommandKind
      stored IsCKS default skUnknown;
    property CommandText: TStrings read FCommandText write SetCommandTextStrs;
    property Values[const AParamNames: String]: Variant read GetValues write SetValues; default;

    property Prepared: Boolean read GetPrepared write SetPrepared stored IsPS default False;
    property Active: Boolean read GetActive write SetActive default False;
    property ActiveStoredUsage: TADStoredActivationUsage read FActiveStoredUsage
      write FActiveStoredUsage default [auDesignTime, auRunTime];

    property BeforePrepare: TNotifyEvent read FBeforePrepare write FBeforePrepare;
    property AfterPrepare: TNotifyEvent read FAfterPrepare write FAfterPrepare;
    property AfterUnprepare: TNotifyEvent read FAfterUnprepare write FAfterUnprepare;
    property BeforeUnprepare: TNotifyEvent read FBeforeUnprepare write FBeforeUnprepare;
    property BeforeExecute: TNotifyEvent read FBeforeExecute write FBeforeExecute;
    property AfterExecute: TNotifyEvent read FAfterExecute write FAfterExecute;
    property BeforeClose: TNotifyEvent read FBeforeClose write FBeforeClose;
    property AfterClose: TNotifyEvent read FAfterClose write FAfterClose;
    property BeforeOpen: TNotifyEvent read FBeforeOpen write FBeforeOpen;
    property AfterOpen: TNotifyEvent read FAfterOpen write FAfterOpen;
    property BeforeFetch: TNotifyEvent read FBeforeFetch write FBeforeFetch;
    property AfterFetch: TNotifyEvent read FAfterFetch write FAfterFetch;
    property OnError: TADErrorEvent read FOnError write FOnError;
    property OnCommandChanged: TNotifyEvent read FOnCommandChanged write FOnCommandChanged;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADCommand = class(TADCustomCommand)
  published
    property ConnectionName;
    property Connection;
    property Transaction;
    property CatalogName;
    property SchemaName;
    property BaseObjectName;
    property Overload;
    property Params;
    property Macros;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property CommandKind;
    property CommandText;
    property ActiveStoredUsage;
    property Active;
    property BeforeClose;
    property BeforeOpen;
    property AfterClose;
    property AfterOpen;
    property BeforeUnprepare;
    property BeforePrepare;
    property AfterUnprepare;
    property AfterPrepare;
    property BeforeExecute;
    property AfterExecute;
    property OnError;
    property OnCommandChanged;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADMetaInfoCommand = class(TADCustomCommand)
  private
    FWildcard: String;
    FMetaInfoKind: TADPhysMetaInfoKind;
    FTableKinds: TADPhysTableKinds;
    FObjectScopes: TADPhysObjectScopes;
    procedure SetMetaInfoKind(const AValue: TADPhysMetaInfoKind);
    procedure SetTableKinds(const AValue: TADPhysTableKinds);
    procedure SetWildcard(const AValue: String);
    function GetObjectName: String;
    procedure SetObjectName(const AValue: String);
    procedure SetObjectScopes(const AValue: TADPhysObjectScopes);
  protected
    procedure InternalCreateCommandIntf; override;
    procedure InternalPrepare; override;
    procedure DoAfterClose; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Active;
    property ConnectionName;
    property Connection;
    property FormatOptions;
    property Overload;
    property ObjectName: String read GetObjectName write SetObjectName;
    property MetaInfoKind: TADPhysMetaInfoKind read FMetaInfoKind
      write SetMetaInfoKind default mkTables;
    property TableKinds: TADPhysTableKinds read FTableKinds
      write SetTableKinds default [tkSynonym, tkTable, tkView];
    property Wildcard: String read FWildcard write SetWildcard;
    property ObjectScopes: TADPhysObjectScopes read FObjectScopes
      write SetObjectScopes default [osMy];
    property CatalogName;
    property SchemaName;
    property BaseObjectName;
    property BeforeClose;
    property BeforeOpen;
    property AfterClose;
    property AfterOpen;
    property OnError;
    property OnCommandChanged;
  end;

  TADCustomTableAdapter = class(TADComponent, {$IFNDEF AnyDAC_D6} IUnknown, {$ENDIF}
    IADStanErrorHandler, IADDAptUpdateHandler)
  private
    FTableAdapterIntf: IADDAptTableAdapter;
    FTableAdapterOwned: Boolean;
    FSelectCommand: TADCustomCommand;
    FInsertCommand: TADCustomCommand;
    FUpdateCommand: TADCustomCommand;
    FDeleteCommand: TADCustomCommand;
    FLockCommand: TADCustomCommand;
    FUnLockCommand: TADCustomCommand;
    FFetchRowCommand: TADCustomCommand;
    FOnError: TADErrorEvent;
    FOnReconcileRow: TADReconcileRowEvent;
    FOnUpdateRow: TADUpdateRowEvent;
    FSchemaAdapter: TADCustomSchemaAdapter;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FAdaptedDataSet: TADAdaptedDataSet;
    FUpdateTransaction: TADCustomTransaction;

    procedure SetUpdateTransaction(const AValue: TADCustomTransaction);
    procedure SetDeleteCommand(const AValue: TADCustomCommand);
    procedure SetFetchRowCommand(const AValue: TADCustomCommand);
    procedure SetInsertCommand(const AValue: TADCustomCommand);
    procedure SetLockCommand(const AValue: TADCustomCommand);
    procedure SetSelectCommand(const AValue: TADCustomCommand);
    procedure SetUnLockCommand(const AValue: TADCustomCommand);
    procedure SetUpdateCommand(const AValue: TADCustomCommand);
    procedure InternalUpdateTransaction;
    function InternalUpdateAdapterCmd(ACmd: TADActionRequest): Boolean;
    procedure UpdateAdapterCmd(ACmd: TADActionRequest);
    procedure UpdateAdapterCmds(const ACmds: array of TADActionRequest);
    procedure SetAdapterCmd(const ACmd: IADPhysCommand;
      ACmdKind: TADActionRequest);
    procedure SetCommand(var AVar: TADCustomCommand;
      const AValue: TADCustomCommand; ACmdKind: TADActionRequest);
    function GetDatSTable: TADDatSTable;
    function GetDatSTableName: String;
    function GetMetaInfoMergeMode: TADPhysMetaInfoMergeMode;
    function GetSourceRecordSetID: Integer;
    function GetSourceRecordSetName: String;
    function GetUpdateTableName: String;
    procedure SetDatSTable(const AValue: TADDatSTable);
    procedure SetDatSTableName(const AValue: String);
    procedure SetMetaInfoMergeMode(const AValue: TADPhysMetaInfoMergeMode);
    procedure SetSourceRecordSetID(const AValue: Integer);
    procedure SetSourceRecordSetName(const AValue: String);
    procedure SetUpdateTableName(const AValue: String);
    function GetColumnMappings: TADDAptColumnMappings;
    procedure SetSchemaAdapter(const AValue: TADCustomSchemaAdapter);
    function IsSRSNS: Boolean;
    function GetCommand(ACmdKind: TADActionRequest): TADCustomCommand;
    procedure SetTableAdapterIntf(const AAdapter: IADDAptTableAdapter;
      AOwned: Boolean);
    procedure SetColumnMappings(const AValue: TADDAptColumnMappings);
    function IsDTNS: Boolean;
    function IsUTNS: Boolean;
    function IsCMS: Boolean;
    function GetDatSManager: TADDatSManager;
    procedure SetDatSManager(AValue: TADDatSManager);
    function GetSender: TObject;
    function GetActualTransaction: TADCustomTransaction;
    function GetActualUpdateTransaction: TADCustomTransaction;
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception); virtual;
    // IADDAptUpdateHandler
    procedure ReconcileRow(ARow: TADDatSRow; var AAction: TADDAptReconcileAction); virtual;
    procedure UpdateRow(ARow: TADDatSRow; ARequest: TADUpdateRequest;
      AUpdRowOptions: TADUpdateRowOptions; var AAction: TADErrorAction); virtual;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Define: TADDatSTable;
    procedure Fetch(AAll: Boolean = False); overload;
    function ApplyUpdates(AMaxErrors: Integer = -1): Integer; overload;
    function Reconcile: Boolean;
    procedure Reset;

    procedure Fetch(ARow: TADDatSRow; var AAction: TADErrorAction;
      AColumn: Integer; ARowOptions: TADPhysFillRowOptions); overload;
    procedure Update(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADUpdateRowOptions = []; AForceRequest: TADActionRequest = arFromRow); overload;
    procedure Lock(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADUpdateRowOptions = []);
    procedure UnLock(ARow: TADDatSRow; var AAction: TADErrorAction;
      AUpdRowOptions: TADUpdateRowOptions = []);

    property SchemaAdapter: TADCustomSchemaAdapter read FSchemaAdapter
      write SetSchemaAdapter;

    property SourceRecordSetName: String read GetSourceRecordSetName
      write SetSourceRecordSetName stored IsSRSNS;
    property SourceRecordSetID: Integer read GetSourceRecordSetID
      write SetSourceRecordSetID default -1;
    property UpdateTableName: String read GetUpdateTableName write SetUpdateTableName
      stored IsUTNS;
    property DatSTableName: String read GetDatSTableName write SetDatSTableName
      stored IsDTNS;
    property DatSTable: TADDatSTable read GetDatSTable write SetDatSTable;
    property MetaInfoMergeMode: TADPhysMetaInfoMergeMode read GetMetaInfoMergeMode
      write SetMetaInfoMergeMode default mmReset;
    property DatSManager: TADDatSManager read GetDatSManager write SetDatSManager;

    property TableAdapterIntf: IADDAptTableAdapter read FTableAdapterIntf;
    property ColumnMappings: TADDAptColumnMappings read GetColumnMappings
      write SetColumnMappings stored IsCMS;

    property UpdateTransaction: TADCustomTransaction read FUpdateTransaction
      write SetUpdateTransaction;
    property SelectCommand: TADCustomCommand read FSelectCommand
      write SetSelectCommand;
    property InsertCommand: TADCustomCommand read FInsertCommand
      write SetInsertCommand;
    property UpdateCommand: TADCustomCommand read FUpdateCommand
      write SetUpdateCommand;
    property DeleteCommand: TADCustomCommand read FDeleteCommand
      write SetDeleteCommand;
    property LockCommand: TADCustomCommand read FLockCommand
      write SetLockCommand;
    property UnLockCommand: TADCustomCommand read FUnLockCommand
      write SetUnLockCommand;
    property FetchRowCommand: TADCustomCommand read FFetchRowCommand
      write SetFetchRowCommand;

    property OnError: TADErrorEvent read FOnError write FOnError;
    property OnReconcileRow: TADReconcileRowEvent read FOnReconcileRow
      write FOnReconcileRow;
    property OnUpdateRow: TADUpdateRowEvent read FOnUpdateRow
      write FOnUpdateRow;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADTableAdapter = class(TADCustomTableAdapter)
  published
    property SchemaAdapter;
    property SourceRecordSetName;
    property SourceRecordSetID;
    property UpdateTableName;
    property DatSTableName;
    property MetaInfoMergeMode;
    property UpdateTransaction;
    property SelectCommand;
    property InsertCommand;
    property UpdateCommand;
    property DeleteCommand;
    property LockCommand;
    property UnLockCommand;
    property FetchRowCommand;
    property ColumnMappings;
    property OnError;
    property OnReconcileRow;
    property OnUpdateRow;
  end;

  TADCustomSchemaAdapter = class(TADComponent, IUnknown,
    IADStanErrorHandler, IADDAptUpdateHandler)
  private
    FTableAdapters: TADObjList;
    FDAptSchemaAdapter: IADDAptSchemaAdapter;
    FBeforeApplyUpdate: TNotifyEvent;
    FAfterApplyUpdate: TNotifyEvent;
    FOnError: TADErrorEvent;
    FOnReconcileRow: TADReconcileRowEvent;
    FOnUpdateRow: TADUpdateRowEvent;
    function GetTableAdaptersIntf: IADDAptTableAdapters;
    function GetDatSManager: TADDatSManager;
    procedure SetDatSManager(const AValue: TADDatSManager);
    function GetCount: Integer;
    function GetTableAdapters(AIndex: Integer): TADCustomTableAdapter;
  protected
    procedure DoAfterApplyUpdate(AErrors: Integer); virtual;
    procedure DoBeforeApplyUpdate; virtual;
    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception); virtual;
    // IADDAptUpdateHandler
    procedure ReconcileRow(ARow: TADDatSRow; var AAction: TADDAptReconcileAction); virtual;
    procedure UpdateRow(ARow: TADDatSRow; ARequest: TADUpdateRequest;
      AUpdRowOptions: TADUpdateRowOptions; var AAction: TADErrorAction); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function ApplyUpdates(AMaxErrors: Integer = -1): Integer;
    function Reconcile: Boolean;

    property DatSManager: TADDatSManager read GetDatSManager write SetDatSManager;
    property TableAdaptersIntf: IADDAptTableAdapters read GetTableAdaptersIntf;

    property TableAdapters[AIndex: Integer]: TADCustomTableAdapter read GetTableAdapters; default;
    property Count: Integer read GetCount;

    property BeforeApplyUpdate: TNotifyEvent read FBeforeApplyUpdate write FBeforeApplyUpdate;
    property AfterApplyUpdate: TNotifyEvent read FAfterApplyUpdate write FAfterApplyUpdate;
    property OnError: TADErrorEvent read FOnError write FOnError;
    property OnReconcileRow: TADReconcileRowEvent read FOnReconcileRow
      write FOnReconcileRow;
    property OnUpdateRow: TADUpdateRowEvent read FOnUpdateRow
      write FOnUpdateRow;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADSchemaAdapter = class(TADCustomSchemaAdapter)
  published
    property OnError;
    property OnReconcileRow;
    property OnUpdateRow;
  end;

  TADCustomUpdateObject = class(TADComponent)
  private
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FDataSet: TADAdaptedDataSet;
    procedure SetDataSet(const AValue: TADAdaptedDataSet);
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure AttachToAdapter; virtual; abstract;
    procedure DetachFromAdapter; virtual; abstract;
  public
    procedure Apply(ARequest: TADUpdateRequest; var AAction: TADErrorAction;
      AOptions: TADUpdateRowOptions); virtual; abstract;
    property DataSet: TADAdaptedDataSet read FDataSet write SetDataSet;
  end;

  TADLocalSQLDataSet = class (TCollectionItem)
  private
    FDataSet: TDataSet;
    FName: String;
    FAdapter: IADPhysLocalQueryAdapter;
    FTemporary: Boolean;
    procedure SetName(const AValue: String);
    procedure SetDataSet(const AValue: TDataSet);
    procedure SetAdapter(const AValue: IADPhysLocalQueryAdapter);
    procedure Changing;
    procedure Changed;
    procedure CheckDefaultAdapter;
    function GetActualName: String;
    function GetIsValid: Boolean;
  protected
    function GetDisplayName: String; override;
  public
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    property ActualName: String read GetActualName;
    property IsValid: Boolean read GetIsValid;
    property Adapter: IADPhysLocalQueryAdapter read FAdapter write SetAdapter;
  published
    property DataSet: TDataSet read FDataSet write SetDataSet;
    property Name: String read FName write SetName;
    property Temporary: Boolean read FTemporary write FTemporary default False;
  end;

  TADLocalSQLDataSets = class (TCollection)
  private
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FOwner: TADCustomLocalSQL;
    function GetItems(AIndex: Integer): TADLocalSQLDataSet;
    procedure SetItems(AIndex: Integer; const AValue: TADLocalSQLDataSet);
    procedure CheckUnique(AItem: TADLocalSQLDataSet);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AOwner: TADCustomLocalSQL);
    function Add: TADLocalSQLDataSet; overload;
    function Add(ADataSet: TDataSet; const AName: String = '';
      const AAdapter: IADPhysLocalQueryAdapter = nil): TADLocalSQLDataSet; overload;
    procedure Remove(ADataSet: TDataSet);
    property Items[AIndex: Integer]: TADLocalSQLDataSet read GetItems write SetItems; default;
  end;

  TADCustomLocalSQL = class(TADComponent, IADPhysSQLHandler)
  private
    FActive: Boolean;
    FStreamedActive: Boolean;
    FActivated: Boolean;
    FConnection: TADCustomConnection;
    FDataSets: TADLocalSQLDataSets;
    FOnGetDataSet: TADGetDatasetEvent;
    FOnReadDataSet: TADReadDatasetEvent;
    procedure SetConnection(const AValue: TADCustomConnection);
    procedure DoConnectChanged(Sender: TObject; Connecting: Boolean);
    procedure CheckDataSetAdded(const AItem: TADLocalSQLDataSet);
    procedure CheckDataSetRemoving(const AItem: TADLocalSQLDataSet);
    procedure SetActive(const AValue: Boolean);
    procedure SetDataSets(const AValue: TADLocalSQLDataSets);
    procedure ReadDataSets(Reader: TReader);
    procedure WriteDataSets(Writer: TWriter);
  protected
    // IADPhysSQLHandler
    function FindDataSet(const ASchema, AName: String): IADPhysLocalQueryAdapter; virtual;
    function DataSetNotFound(const AName: String): Boolean; virtual;
    procedure ReadDataSet(const ASchema, AName: String; ADataSet: TObject); virtual;
    // introduced
    procedure InternalAttachToSQL; virtual; abstract;
    procedure InternalDetachFromSQL; virtual; abstract;
    procedure InternalDataSetAdded(ADataSet: TADLocalSQLDataSet); virtual; abstract;
    procedure InternalDataSetRemoving(ADataSet: TADLocalSQLDataSet); virtual; abstract;
    // other
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure DefineProperties(AFiler: TFiler); override;
    procedure Loaded; override;
    function GetActualActive: Boolean;
    procedure CheckActivate;
    procedure CheckDeactivate;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property DataSets: TADLocalSQLDataSets read FDataSets write SetDataSets stored False;
    property Active: Boolean read FActive write SetActive default False;
    property Connection: TADCustomConnection read FConnection write SetConnection;
    property OnGetDataSet: TADGetDatasetEvent read FOnGetDataSet write FOnGetDataSet;
    property OnReadDataSet: TADReadDatasetEvent read FOnReadDataSet write FOnReadDataSet;
  end;

  TADAdaptedDataSet = class(TADDataSet)
  private
    FAdapter: TADCustomTableAdapter;
    FDatSManager: TADDatSManager;
    FUpdateObject: TADCustomUpdateObject;
    FServerEditRow: TADDatSRow;
    FServerEditRequest: TADActionRequest;
    FOnExecuteError: TADExecuteErrorEvent;
    FOnError: TADErrorEvent;
    FUnpreparing: Boolean;
    FForcePropertyChange: Boolean;
    FLocalSQL: TADCustomLocalSQL;
    procedure SetUpdateObject(const AValue: TADCustomUpdateObject);
    procedure InternalServerEdit(AServerEditRequest: TADUpdateRequest);
    function GetConnection(ACheck: Boolean): TADCustomConnection;
    function GetPointedConnection: TADCustomConnection;
    procedure InternalUpdateErrorHandler(ASender: TObject;
      const AInitiator: IADStanObject; var AException: Exception);
    procedure InternalReconcileErrorHandler(ASender: TObject; ARow: TADDatSRow;
      var AAction: TADDAptReconcileAction);
    function GetCommand: TADCustomCommand;
    procedure InternalUpdateRecordHandler(ASender: TObject;
      ARow: TADDatSRow; ARequest: TADUpdateRequest;
      AOptions: TADUpdateRowOptions; var AAction: TADErrorAction);
    procedure SetDatSManager(AManager: TADDatSManager);
    procedure SetLocalSQL(const AValue: TADCustomLocalSQL);
    function InternalPSExecuteStatement(const ASQL: string; AParams: TParams;
      AMode: Integer; var AResultSet: TADQuery): Integer;
  protected
    FVclParams: TParams;
    procedure SetAdapter(AAdapter: TADCustomTableAdapter);
    // TComponent
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    // TDataSet
    procedure InternalClose; override;
    // TADDataSet
    procedure CheckOnline(APrepare: Boolean = True); override;
    procedure ReleaseBase(AOffline: Boolean); override;
    procedure DoDefineDatSManager; override;
    procedure DoOpenSource(ABlocked, AInfoQuery, AStructQuery: Boolean); override;
    function DoIsSourceOpen: Boolean; override;
    function DoIsSourceAsync: Boolean; override;
    function DoIsSourceOnline: Boolean; override;
    procedure DoPrepareSource; override;
    procedure DoUnprepareSource; override;
    function DoApplyUpdates(ATable: TADDatSTable; AMaxErrors: Integer): Integer; override;
    function DoFetch(ATable: TADDatSTable; AAll: Boolean;
      ADirection: TADFetchDirection = fdDown): Integer; overload; override;
    function DoFetch(ARow: TADDatSRow; AColumn: Integer;
      ARowOptions: TADPhysFillRowOptions): Boolean; overload; override;
    procedure DoClearBeforeRefetch; override;
    procedure DoMasterDefined; override;
    procedure DoMasterParamSetValues(AMasterFieldList: TADFieldList); override;
    function DoMasterParamDependent(AMasterFieldList: TADFieldList): Boolean; override;
    procedure DoCloseSource; override;
    procedure DoResetDatSManager; override;
    function DoGetDatSManager: TADDatSManager; override;
    function DoGetTableName: String; override;
    procedure DoProcessUpdateRequest(ARequest: TADUpdateRequest;
      AOptions: TADUpdateRowOptions); override;
    procedure DoExecuteSource(ATimes, AOffset: Integer); override;
    procedure DoCloneCursor(AReset, AKeepSettings: Boolean); override;
    function GetParams: TADParams; override;
    function DoStoredActivation: Boolean; override;
    property UpdateObject: TADCustomUpdateObject read FUpdateObject
      write SetUpdateObject;
    // IADStanOptions
    function GetOptionsIntf: IADStanOptions; override;
    procedure SetOptionsIntf(const AValue: IADStanOptions); override;
    // IProviderSupport
{$IFDEF AnyDAC_D6}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}
    function PSInTransaction: Boolean; override;
    procedure PSStartTransaction; override;
    procedure PSEndTransaction(Commit: Boolean); override;
    function PSIsSQLBased: Boolean; override;
    function PSIsSQLSupported: Boolean; override;
    function PSGetQuoteChar: string; override;
    function PSGetParams: TParams; override;
    procedure PSSetParams(AParams: TParams); override;
{$IFDEF AnyDAC_FullIPS}
    function PSGetCommandText: string; override;
    function PSGetCommandType: TPSCommandType; override;
{$ENDIF}
    procedure PSSetCommandText(const CommandText: string); override;
    function PSExecuteStatement(const ASQL: string; AParams: TParams;
      AResultSet: Pointer = nil): Integer; overload; {$IFNDEF NEXTGEN} override; {$ENDIF}
{$IFDEF AnyDAC_D17}
    function PSExecuteStatement(const ASQL: string; AParams: TParams;
      var AResultSet: TDataSet): Integer; overload; override;
    function PSExecuteStatement(const ASQL: string;
      AParams: TParams): Integer; overload; override;
{$ENDIF}
    procedure PSGetAttributes(AList: {$IFDEF AnyDAC_D18} TPacketAttributeList {$ELSE} TList {$ENDIF}); override;
{$IFDEF AnyDAC_D6}
  {$WARN SYMBOL_DEPRECATED ON}
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AttachTable(ATable: TADDatSTable; AView: TADDatSView); override;
    procedure NextRecordSet;
    procedure GetResults;
    procedure AbortJob(AWait: Boolean = False);
    procedure Disconnect(AAbortJob: Boolean = False); override;
    procedure ServerAppend;
    procedure ServerEdit;
    procedure ServerDelete;
    procedure ServerPerform;
    procedure ServerCancel;
    procedure ServerDeleteAll(ANoUndo: Boolean = False);
    procedure ServerSetKey;
    function ServerGotoKey: Boolean;
    property Adapter: TADCustomTableAdapter read FAdapter;
    property DatSManager write SetDatSManager;
    property Command: TADCustomCommand read GetCommand;
    property PointedConnection: TADCustomConnection read GetPointedConnection;
    property ServerEditRequest: TADActionRequest read FServerEditRequest;
    property LocalSQL: TADCustomLocalSQL read FLocalSQL write SetLocalSQL;
    property OnExecuteError: TADExecuteErrorEvent read FOnExecuteError
      write FOnExecuteError;
    property OnError: TADErrorEvent read FOnError write FOnError;
  end;

  TADCustomMemTable = class(TADAdaptedDataSet)
  private
    FOptionsIntf: IADStanOptions;
    function GetDisableStringTrim: Boolean;
    function GetFetchOnDemand: Boolean;
    function GetIsClone: Boolean;
    function GetLogChanges: Boolean;
    function GetProviderEOF: Boolean;
    function GetReadOnly: Boolean;
    function GetStatusFilter: TADUpdateRecordTypes;
    function GetXMLData: string;
    procedure SetDisableStringTrim(const AValue: Boolean);
    procedure SetFetchOnDemand(const AValue: Boolean);
    procedure SetLogChanges(const AValue: Boolean);
    procedure SetProviderEOF(const AValue: Boolean);
    procedure SetReadOnly(const AValue: Boolean);
    procedure SetStatusFilter(const AValue: TADUpdateRecordTypes);
    procedure SetXMLData(const AValue: string);
    function GetCommandText: TADWideString;
    procedure SetCommandText(const AValue: TADWideString);
    function GetFileName: string;
    function GetPacketRecords: Integer;
    procedure SetFileName(const AValue: string);
    procedure SetPacketRecords(const AValue: Integer);
    function GetOptionalParamTab: TADDatSTable;
  protected
    FStoreDefs: Boolean;
{$IFNDEF AnyDAC_FPC}
    procedure DefChanged(ASender: TObject); override;
{$ENDIF}
    function SaveToDFM: Boolean; override;
    property StoreDefs: Boolean read FStoreDefs write FStoreDefs default False;
    // IADStanOptions
    function GetOptionsIntf: IADStanOptions; override;
    procedure GetParentOptions(out AOpts: IADStanOptions);
 public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Adapter write SetAdapter;
    // TClientDataSet compatibility
    procedure AppendData(const AData: IADDataSetReference; AHitEOF: Boolean = True);
    function ConstraintsDisabled: Boolean;
    procedure MergeChangeLog;
    function GetOptionalParam(const AParamName: string): Variant;
    procedure SetOptionalParam(const AParamName: string; const AValue: Variant;
      AIncludeInDelta: Boolean = False); virtual;
    property IsClone: Boolean read GetIsClone;
    property CommandText: TADWideString read GetCommandText write SetCommandText;
    property DisableStringTrim: Boolean read GetDisableStringTrim write SetDisableStringTrim;
    property FetchOnDemand: Boolean read GetFetchOnDemand write SetFetchOnDemand;
    property FileName: string read GetFileName write SetFileName;
    property LogChanges: Boolean read GetLogChanges write SetLogChanges;
    property PacketRecords: Integer read GetPacketRecords write SetPacketRecords;
    property ProviderEOF: Boolean read GetProviderEOF write SetProviderEOF;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
    property StatusFilter: TADUpdateRecordTypes read GetStatusFilter write SetStatusFilter;
    property XMLData: string read GetXMLData write SetXMLData;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADMemTable = class(TADCustomMemTable)
  published
    property ActiveStoredUsage;
    { TDataSet }
    property Active;
    property AutoCalcFields;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;
    property Filtered;
    property FilterOptions;
    property Filter;
    property OnFilterRecord;
{$IFNDEF AnyDAC_FPC}
    property ObjectView default True;
    property Constraints;
    property DataSetField;
{$ENDIF}
    property FieldDefs stored FStoreDefs;
    { TADDataSet }
    property FilterChanges;
    property CachedUpdates;
    property IndexDefs stored FStoreDefs;
    property Indexes;
    property IndexesActive;
    property IndexName;
    property IndexFieldNames;
    property Aggregates;
    property AggregatesActive;
    property ConstraintsEnabled;
    property MasterSource;
    property MasterFields;
    property DetailFields;
    property OnUpdateRecord;
    property OnUpdateError;
    property OnReconcileError;
    property BeforeApplyUpdates;
    property AfterApplyUpdates;
    property BeforeGetRecords;
    property AfterGetRecords;
    property AfterGetRecord;
    property BeforeRowRequest;
    property AfterRowRequest;
    property BeforeExecute;
    property AfterExecute;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    { TADAdaptedDataSet }
    property LocalSQL;
    { TADCustomMemTable }
    property Adapter;
    property StoreDefs;
  end;

  TADRdbmsDataSet = class(TADAdaptedDataSet)
  private
    FStreamedPrepared: Boolean;
    function GetConnection: TADCustomConnection;
    function GetConnectionName: String;
    procedure SetConnection(const AValue: TADCustomConnection);
    procedure SetConnectionName(const AValue: String);
    function GetPrepared: Boolean;
    procedure SetPrepared(const AValue: Boolean);
    function IsCNNS: Boolean;
    function IsCNS: Boolean;
    function GetOnError: TADErrorEvent;
    procedure SetOnError(const AValue: TADErrorEvent);
    function GetParamBindMode: TADParamBindMode;
    procedure SetParamBindMode(const AValue: TADParamBindMode);
    function GetOnCommandChanged: TNotifyEvent;
    procedure SetOnCommandChanged(const AValue: TNotifyEvent);
    function GetMacrosCount: Word;
    function GetMacros: TADMacros;
    procedure SetMacros(const AValue: TADMacros);
    function IsPS: Boolean;
    function GetRowsAffected: TADCounter;
    function GetTransaction: TADCustomTransaction;
    function GetUpdateTransaction: TADCustomTransaction;
    function GetSchemaAdapter: TADCustomSchemaAdapter;
    procedure SetSchemaAdapter(const AValue: TADCustomSchemaAdapter);
  protected
    procedure Loaded; override;
    procedure DefineProperties(AFiler: TFiler); override;
    // TDataSet
    procedure InternalClose; override;
    procedure OpenCursor(InfoQuery: Boolean); override;
    procedure CheckCachedUpdatesMode; override;
    procedure ReleaseBase(AOffline: Boolean); override;
    // introduced
    function InternalCreateAdapter: TADCustomTableAdapter; virtual;
    procedure SetTransaction(const AValue: TADCustomTransaction); virtual;
    procedure SetUpdateTransaction(const AValue: TADCustomTransaction); virtual;
    // props
    property ParamBindMode: TADParamBindMode read GetParamBindMode write SetParamBindMode default pbByName;
    property Macros: TADMacros read GetMacros write SetMacros stored False;
    property MacroCount: Word read GetMacrosCount;
    property RowsAffected: TADCounter read GetRowsAffected;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Disconnect(AAbortJob: Boolean = False); override;
    procedure Prepare;
    procedure Unprepare;
{$IFNDEF AnyDAC_D7}
    procedure Open; overload;
{$ENDIF}
    procedure Open(const ASQL: String); overload;
    procedure Open(const ASQL: String; const AParams: array of Variant); overload;
    procedure Open(const ASQL: String; const AParams: array of Variant;
      const ATypes: array of TFieldType); overload;
    function MacroByName(const AValue: string): TADMacro;
    function FindMacro(const AValue: string): TADMacro;
    property ConnectionName: String read GetConnectionName write SetConnectionName stored IsCNNS;
    property Connection: TADCustomConnection read GetConnection write SetConnection stored IsCNS;
    property Prepared: Boolean read GetPrepared write SetPrepared stored IsPS default False;
    property Transaction: TADCustomTransaction read GetTransaction write SetTransaction;
    property UpdateTransaction: TADCustomTransaction read GetUpdateTransaction write SetUpdateTransaction;
    property SchemaAdapter: TADCustomSchemaAdapter read GetSchemaAdapter write SetSchemaAdapter;
    property OnError: TADErrorEvent read GetOnError write SetOnError;
    property OnCommandChanged: TNotifyEvent read GetOnCommandChanged write SetOnCommandChanged;
    { TADDataSet }
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADUpdateSQL = class(TADCustomUpdateObject)
  private
    FCommands: array [0 .. 5] of TADCustomCommand;
    FConnectionName: String;
    FConnection: TADCustomConnection;
    function GetSQL(const AIndex: Integer): TStrings;
    procedure SetSQL(const AIndex: Integer; const AValue: TStrings);
    function GetCommand(ARequest: TADUpdateRequest): TADCustomCommand;
    function GetURSQL(ARequest: TADUpdateRequest): TStrings;
    procedure SetURSQL(ARequest: TADUpdateRequest; const Value: TStrings);
    procedure SetConnection(const Value: TADCustomConnection);
    procedure SetConnectionName(const Value: String);
    procedure UpdateAdapter;
  protected
    procedure Notification(AComponent: TComponent; AOperation: TOperation); override;
    procedure AttachToAdapter; override;
    procedure DetachFromAdapter; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Apply(ARequest: TADUpdateRequest; var AAction: TADErrorAction;
      AOptions: TADUpdateRowOptions); override;
    property Commands[ARequest: TADUpdateRequest]: TADCustomCommand read GetCommand;
    property SQL[ARequest: TADUpdateRequest]: TStrings read GetURSQL write SetURSQL;
  published
    property Connection: TADCustomConnection read FConnection write SetConnection;
    property ConnectionName: String read FConnectionName write SetConnectionName;
    property InsertSQL: TStrings index 0 read GetSQL write SetSQL;
    property ModifySQL: TStrings index 1 read GetSQL write SetSQL;
    property DeleteSQL: TStrings index 2 read GetSQL write SetSQL;
    property LockSQL: TStrings index 3 read GetSQL write SetSQL;
    property UnlockSQL: TStrings index 4 read GetSQL write SetSQL;
    property FetchRowSQL: TStrings index 5 read GetSQL write SetSQL;
  end;

  TADCustomQuery = class(TADRdbmsDataSet)
  private
    procedure SetSQL(const AValue: TStrings);
    function GetSQL: TStrings;
    function GetText: String;
    function GetDS: TDataSource;
    procedure SetDS(const AValue: TDataSource);
    procedure ReadDataSource(AReader: TReader);
  protected
    procedure UpdateRecordCount; override;
    procedure DefineProperties(AFiler: TFiler); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ExecSQL; overload;
    function ExecSQL(const ASQL: String): LongInt; overload;
    function ExecSQL(const ASQL: String; const AParams: array of Variant): LongInt; overload;
    function ExecSQL(const ASQL: String; const AParams: array of Variant;
      const ATypes: array of TFieldType): LongInt; overload;
    property SQL: TStrings read GetSQL write SetSQL;
    property Text: String read GetText;
    property ParamCount;
    property DataSource: TDataSource read GetDS write SetDS;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADQuery = class(TADCustomQuery)
  public
    property RowsAffected;
    property MacroCount;
  published
    property ActiveStoredUsage;
    { TDataSet }
    property Active;
    property AutoCalcFields;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;
    property Filtered;
    property FilterOptions;
    property Filter;
    property OnFilterRecord;
{$IFNDEF AnyDAC_FPC}
    property ObjectView default True;
    property Constraints;
{$ENDIF}
    { TADDataSet }
    property FilterChanges;
    property CachedUpdates;
    property Indexes;
    property IndexesActive;
    property IndexName;
    property IndexFieldNames;
    property Aggregates;
    property AggregatesActive;
    property ConstraintsEnabled;
    property MasterSource;
    property MasterFields;
    property DetailFields;
    property OnUpdateRecord;
    property OnUpdateError;
    property OnReconcileError;
    property BeforeExecute;
    property AfterExecute;
    property BeforeApplyUpdates;
    property AfterApplyUpdates;
    property BeforeGetRecords;
    property AfterGetRecords;
    property AfterGetRecord;
    property BeforeRowRequest;
    property AfterRowRequest;
    property OnMasterSetValues;
    { TADAdaptedDataSet }
    property LocalSQL;
    { TADRdbmsDataSet }
    property ConnectionName;
    property Connection;
    property Transaction;
    property UpdateTransaction;
    property SchemaAdapter;
    property Params;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property UpdateObject;
    property OnError;
    property OnExecuteError;
    property OnCommandChanged;
    { TADCustomQuery }
    property SQL;
    property Macros;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADTable = class(TADCustomQuery)
  private
    FWindowSize: Integer;
    FServerCursor: Boolean;
    FTableName: String;
    FExclusive: Boolean;
    FCatalogName: String;
    FSchemaName: String;
    FTableParams: TADPhysTableParams;
    FWindowOperation: Boolean;
    FPrimaryKeyFields: String;
    FResetIndexFieldNames: Boolean;
    FIndexFieldChanged: Boolean;
    procedure MoveData(ATableSrc, ATableDst: TADDatSTable);
    procedure TableChanged;
    procedure SetTableName(const AValue: String);
    procedure SetCatalogName(const AValue: String);
    procedure SetSchemaName(const AValue: String);
    function GetBookmarkColSize(ACol: TADDatSColumn): LongWord;
    function Bookmark2Fields(const ABookmark: TBookmark; var ADataPtr: Pointer): String;
    function Bookmark2Key(const ABookmark: TBookmark; APKOnly: Boolean = False): Variant;
    function InternalBookmarkValid(ABookmark: Pointer): Boolean;
    procedure ParseIndexFields(out AOrderFields, ADescFields, ANoCaseFields, AExpression: String);
    function GetActualIndexFields: String;
    function AllIndexFieldNull(const ARowIndex: Integer = 0): Boolean;
    procedure ClearTableButCurrent;
    function GetExists: Boolean;
    procedure UpdateLocalIndexName;
    procedure SetupTable;
    function GetWindowedRows: TADDatSRowListBase;
  protected
    FAdjustIndexes: Boolean;
    // TADDataSet
    function InternalCreateAdapter: TADCustomTableAdapter; override;
    procedure DoCachedUpdatesChanged; override;
    function DoIsSourceOpen: Boolean; override;
    procedure OpenCursor(AInfoQuery: Boolean); override;
    procedure ReleaseBase(AOffline: Boolean); override;
    function CalcBookmarkSize: LongWord; override;
    procedure GetBookmarkData(Buffer: PADBuffer; Data: PADBookmark); override;
    procedure InternalGotoBookmark(ABookmark: Pointer); overload; {$IFNDEF NEXTGEN} override; {$ENDIF}
{$IFDEF AnyDAC_D17}
    procedure InternalGotoBookmark(Bookmark: PADBookmark); overload; override;
{$ENDIF}
    function DoAdjustSortFields(const AFields, AExpression: String; var AIndexOptions: TADSortOptions): String; override;
    procedure DoSortOrderChanging; override;
    procedure DoSortOrderChanged; override;
    procedure UpdateIndexDefs; override;
    procedure DoFilteringUpdated(AResync: Boolean); override;
    function DoPurge(AView: TADDatSView; ADirection: TADFetchDirection = fdDown): Integer; override;
    function DoFetch(ATable: TADDatSTable; AAll: Boolean; ADirection: TADFetchDirection = fdDown): Integer; override;
    procedure InternalFirst; override;
    procedure InternalLast; override;
    function InternalDefaultKeyFieldCount(ABuffer: PADKeyBuffer; ADefault: Integer): Integer; override;
    function InternalGotoKey(ANearest: Boolean): Boolean; override;
    procedure InternalRefresh; override;
    procedure InternalDelete; override;
    procedure SetFieldData(AField: TField; ABuffer: PADValue); override;
    procedure InternalAddRecord(Buffer: {$IFDEF AnyDAC_D17} PADBuffer {$ELSE} Pointer {$ENDIF};
      Append: Boolean); override;
    procedure InternalPost; override;
    procedure InternalCancel; override;
    procedure InternalResetRange; override;
    function GetRecNo: Integer; override;
    procedure InternalSetRecNo(AValue: Integer); override;
    procedure SetRecNo(AValue: Integer); override;
    function GetRecordCount: Longint; override;
    procedure DoMasterDefined; override;
    procedure DoMasterReset; override;
    procedure MasterChanged(Sender: TObject); override;
    procedure CheckMasterRange; override;
    // TADTable
    function GetCustomWhere: String; virtual;
    procedure FetchWindow(out AFetched: Integer; APrepOnly: Boolean = False;
      AForceClear: Boolean = False; ATable: TADDatsTable = nil);
    function InternalSearch(ATable: TADDatSTable; const AKeyFields: String; const AKeyValues: Variant;
      const AExpression: String = ''; const AResultFields: String = '';
      AOptions: TADDataSetLocateOptions = []): Boolean;
    function InternalLocateEx(const AKeyFields: String; const AKeyValues: Variant;
      const AExpression: String = ''; AOptions: TADDataSetLocateOptions = [];
       ApRecordIndex: PInteger = nil): Boolean;
    function InternalLookupEx(const AKeyFields: String; const AKeyValues: Variant;
      const AExpression: String; const AResultFields: String; AOptions: TADDataSetLocateOptions = [];
      ApRecordIndex: PInteger = nil): Variant;
    // IProviderSupport
    function PSGetTableName: string; override;
{$IFDEF AnyDAC_FullIPS}
    function PSGetCommandText: string; override;
    function PSGetCommandType: TPSCommandType; override;
{$ENDIF}
    procedure PSSetCommandText(const ACommandText: string); override;
  public
    constructor Create(AOwner: TComponent); override;
    function IsSequenced: Boolean; override;
    procedure Open(const ATableName: String); overload;
    procedure Disconnect(AAbortJob: Boolean = False); override;
    function BookmarkValid(ABookmark: TBookmark): Boolean; override;
    function CompareBookmarks(Bookmark1: TBookmark; Bookmark2: TBookmark): Integer; override;
    function GenerateSQL: String;
    procedure RefireSQL;
    function LookupEx(const AExpression: String; const AResultFields: String;
      AOptions: TADDataSetLocateOptions = []; ApRecordIndex: PInteger = nil): Variant; override;
    function LookupEx(const AKeyFields: String; const AKeyValues: Variant;
      const AResultFields: String; AOptions: TADDataSetLocateOptions = [];
      ApRecordIndex: PInteger = nil): Variant; override;
    function LocateEx(const AExpression: String; AOptions: TADDataSetLocateOptions = [];
      ApRecordIndex: PInteger = nil): Boolean; override;
    function LocateEx(const AKeyFields: String; const AKeyValues: Variant;
      AOptions: TADDataSetLocateOptions = []; ApRecordIndex: PInteger = nil): Boolean; override;
    procedure RefreshMetadata;
    property Exists: Boolean read GetExists;
    property ActualIndexFieldNames: String read GetActualIndexFields;
  published
    property ActiveStoredUsage;
    { TDataSet }
    property Active;
    property AutoCalcFields;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;
    property Filtered;
    property FilterOptions;
    property Filter;
    property OnFilterRecord;
{$IFNDEF AnyDAC_FPC}
    property ObjectView default True;
    property Constraints;
{$ENDIF}
    { TADDataSet }
    property FilterChanges;
    property CachedUpdates;
    property IndexName;
    property IndexFieldNames;
    property Aggregates;
    property AggregatesActive;
    property ConstraintsEnabled;
    property MasterSource;
    property MasterFields;
    property DetailFields;
    property OnUpdateRecord;
    property OnUpdateError;
    property OnReconcileError;
    property BeforeApplyUpdates;
    property AfterApplyUpdates;
    property BeforeGetRecords;
    property AfterGetRecords;
    property AfterGetRecord;
    property BeforeRowRequest;
    property AfterRowRequest;
    { TADAdaptedDataSet }
    property LocalSQL;
    { TADRdbmsDataSet }
    property ConnectionName;
    property Connection;
    property Transaction;
    property UpdateTransaction;
    property SchemaAdapter;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property UpdateObject;
    property OnError;
    property OnExecuteError;
    property OnCommandChanged;
    { TADTable }
    property Exclusive: Boolean read FExclusive write FExclusive default False;
    property CatalogName: String read FCatalogName write SetCatalogName;
    property SchemaName: String read FSchemaName write SetSchemaName;
    property TableName: String read FTableName write SetTableName;
  end;

  TADCustomStoredProc = class(TADRdbmsDataSet)
  private
    procedure SetOverload(const AValue: Word);
    procedure SetProcName(const AValue: string);
    function GetOverload: Word;
    function GetProcName: string;
    function GetPackageName: String;
    function GetSchemaName: String;
    procedure SetPackageName(const AValue: String);
    procedure SetSchemaName(const AValue: String);
    procedure ProcNameChanged;
    function GetCatalogName: String;
    procedure SetCatalogName(const AValue: String);
    procedure ExecProcBase(const AProcName: String; AFunction: Boolean;
      const AParams: array of Variant; const ATypes: array of TFieldType);
  protected
    function InternalCreateAdapter: TADCustomTableAdapter; override;
  public
    function DescriptionsAvailable: Boolean;
    procedure ExecProc; overload;
    function ExecProc(const AProcName: String): LongInt; overload;
    function ExecProc(const AProcName: String; const AParams: array of Variant): LongInt; overload;
    function ExecProc(const AProcName: String; const AParams: array of Variant;
      const ATypes: array of TFieldType): LongInt; overload;
    function ExecFunc: Variant; overload;
    function ExecFunc(const AProcName: String): Variant; overload;
    function ExecFunc(const AProcName: String; const AParams: array of Variant): Variant; overload;
    function ExecFunc(const AProcName: String; const AParams: array of Variant;
      const ATypes: array of TFieldType): Variant; overload;
    property CatalogName: String read GetCatalogName write SetCatalogName;
    property SchemaName: String read GetSchemaName write SetSchemaName;
    property PackageName: String read GetPackageName write SetPackageName;
    property StoredProcName: string read GetProcName write SetProcName;
    property Overload: Word read GetOverload write SetOverload default 0;
    property ParamCount;
    property RowsAffected;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADStoredProc = class(TADCustomStoredProc)
  published
    property ActiveStoredUsage;
    { TDataSet }
    property Active;
    property AutoCalcFields;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;
    property Filtered;
    property FilterOptions;
    property Filter;
    property OnFilterRecord;
{$IFNDEF AnyDAC_FPC}
    property ObjectView default True;
    property Constraints;
{$ENDIF}
    { TADDataSet }
    property FilterChanges;
    property CachedUpdates;
    property Indexes;
    property IndexesActive;
    property IndexName;
    property IndexFieldNames;
    property Aggregates;
    property AggregatesActive;
    property ConstraintsEnabled;
    property MasterSource;
    property MasterFields;
    property DetailFields;
    property OnUpdateRecord;
    property OnUpdateError;
    property OnReconcileError;
    property BeforeExecute;
    property AfterExecute;
    property BeforeApplyUpdates;
    property AfterApplyUpdates;
    property BeforeGetRecords;
    property AfterGetRecords;
    property AfterGetRecord;
    property BeforeRowRequest;
    property AfterRowRequest;
    { TADAdaptedDataSet }
    property LocalSQL;
    { TADRdbmsDataSet }
    property ConnectionName;
    property Connection;
    property Transaction;
    property UpdateTransaction;
    property SchemaAdapter;
    property Params;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    property UpdateObject;
    property OnError;
    property OnExecuteError;
    property OnCommandChanged;
    property ParamBindMode;
    { TADCustomStoredProc }
    property CatalogName;
    property SchemaName;
    property PackageName;
    property StoredProcName;
    property Overload;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADMetaInfoQuery = class(TADRdbmsDataSet)
  private
    function GetMetaInfoKind: TADPhysMetaInfoKind;
    function GetObjectName: String;
    function GetTableKinds: TADPhysTableKinds;
    function GetWildcard: String;
    procedure SetMetaInfoKind(const AValue: TADPhysMetaInfoKind);
    procedure SetObjectName(const AValue: String);
    procedure SetTableKinds(const AValue: TADPhysTableKinds);
    procedure SetWildcard(const AValue: String);
    function GetOverload: Word;
    procedure SetOverload(const AValue: Word);
    procedure SetObjectScopes(const AValue: TADPhysObjectScopes);
    function GetObjectScopes: TADPhysObjectScopes;
    function GetBaseObjectName: String;
    function GetSchemaName: String;
    procedure SetBaseObjectName(const AValue: String);
    procedure SetSchemaName(const AValue: String);
    function GetCatalogName: String;
    procedure SetCatalogName(const AValue: String);
  protected
    function InternalCreateAdapter: TADCustomTableAdapter; override;
  published
    property ActiveStoredUsage;
    { TDataSet }
    property Active;
    property AutoCalcFields;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property Filtered;
    property FilterOptions;
    property Filter;
    property OnFilterRecord;
    { TADDataSet }
    property Indexes;
    property IndexesActive;
    property IndexName;
    property IndexFieldNames;
    property Aggregates;
    property AggregatesActive;
    property BeforeGetRecords;
    property AfterGetRecords;
    property AfterGetRecord;
    property BeforeRowRequest;
    property AfterRowRequest;
    { TADAdaptedDataSet }
    property LocalSQL;
    { TADRdbmsDataSet }
    property ConnectionName;
    property Connection;
    property Transaction;
    property UpdateTransaction;
    property SchemaAdapter;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property OnError;
    property OnCommandChanged;
    { Introduced }
    property MetaInfoKind: TADPhysMetaInfoKind read GetMetaInfoKind
      write SetMetaInfoKind default mkTables;
    property TableKinds: TADPhysTableKinds read GetTableKinds
      write SetTableKinds default [tkSynonym, tkTable, tkView];
    property Wildcard: String read GetWildcard write SetWildcard;
    property ObjectScopes: TADPhysObjectScopes read GetObjectScopes
      write SetObjectScopes default [osMy];
    property CatalogName: String read GetCatalogName write SetCatalogName;
    property SchemaName: String read GetSchemaName write SetSchemaName;
    property BaseObjectName: String read GetBaseObjectName write SetBaseObjectName;
    property Overload: Word read GetOverload write SetOverload default 0;
    property ObjectName: String read GetObjectName write SetObjectName;
  end;

function ADManager: TADCustomManager;
procedure ADSetManagerClass(AClass: TADCustomManagerClass);
procedure ADSetConnectionClass(AClass: TADCustomConnectionClass);
function ADFindDefaultConnection(AComp: TComponent): TADCustomConnection;
function ADIsDesigning(AComp: TComponent): Boolean;

{-------------------------------------------------------------------------------}
implementation

uses
{$IFDEF POSIX}
  Posix.Pthread,
{$ENDIF}
{$IFDEF AnyDAC_D6Base}
  Variants, FmtBcd,
  {$IFDEF AnyDAC_D6}
  SqlTimSt, uADStanSQLTimeInt,
  {$ENDIF}
{$ENDIF}
{$IFDEF AnyDAC_D17}
  System.Generics.Collections,
  System.Types,
{$ENDIF}
  TypInfo,
  uADStanConst, uADStanExpr, uADStanFactory, uADStanResStrs,
  uADPhysCmdPreprocessor
{$IFNDEF AnyDAC_D7}
  , uADStanDef, uADStanPool, uADStanAsync,
  uADDAptManager,
  uADPhysManager
{$ENDIF}
  ;

var
  FManagerSingletonClass: TADCustomManagerClass = TADManager;
  FManagerSingleton: TADCustomManager = nil;
  FManagerOptsIntf: IADStanOptions = nil;
  FConnectionClass: TADCustomConnectionClass = TADConnection;

{-------------------------------------------------------------------------------}
function ADManager: TADCustomManager;
begin
  if FManagerSingleton = nil then begin
    FManagerSingleton := FManagerSingletonClass.Create(nil);
    FManagerSingleton.FAutoCreated := True;
  end;
  Result := FManagerSingleton;
end;

{-------------------------------------------------------------------------------}
procedure ADSetManagerClass(AClass: TADCustomManagerClass);
begin
  FManagerSingletonClass := AClass;
end;

{-------------------------------------------------------------------------------}
procedure ADSetConnectionClass(AClass: TADCustomConnectionClass);
begin
  FConnectionClass := AClass;
end;

{-------------------------------------------------------------------------------}
function ADFindDefaultConnection(AComp: TComponent): TADCustomConnection;
var
  oRoot: TComponent;
  i: Integer;
begin
  Result := nil;
  oRoot := AComp;
  while (oRoot.Owner <> nil) and (Result = nil) do begin
    oRoot := oRoot.Owner;
    for i := 0 to oRoot.ComponentCount - 1 do
      if oRoot.Components[i] is TADCustomConnection then begin
        Result := TADCustomConnection(oRoot.Components[i]);
        Break;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function ADIsDesigning(AComp: TComponent): Boolean;
begin
  Result :=
    ([csDesigning, csLoading] * AComp.ComponentState = [csDesigning]) and
    ((AComp.Owner = nil) or
     ([csDesigning, csLoading] * AComp.Owner.ComponentState = [csDesigning]));
end;

{-------------------------------------------------------------------------------}
{ TADCustomManager                                                              }
{-------------------------------------------------------------------------------}
constructor TADCustomManager.Create(AOwner: TComponent);
var
  oPrevMgr: TADCustomManager;
  i: Integer;
begin
  if (FManagerSingleton <> nil) and not FManagerSingleton.FAutoCreated and
     ((AOwner = nil) or not (csDesigning in AOwner.ComponentState)) then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntSessMBSingle, []);
  FLock := TADMREWSynchronizer.Create;
  FLock.BeginWrite;
  try
    inherited Create(AOwner);
    SetOptionsIntf(nil);
    FConnections := TADObjList.Create;
    FActiveStoredUsage := [auDesignTime, auRunTime];
    if (FManagerSingleton = nil) or FManagerSingleton.FAutoCreated then begin
      oPrevMgr := FManagerSingleton;
      FManagerSingleton := Self;
      QueryInterface(IADStanOptions, FManagerOptsIntf);
      if oPrevMgr <> nil then begin
        FConnections.Clear;
        for i := 0 to oPrevMgr.FConnections.Count - 1 do
          FConnections.Add(oPrevMgr.FConnections[i]);
        oPrevMgr.FConnections.Clear;
        ADFree(oPrevMgr);
      end;
    end;
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
destructor TADCustomManager.Destroy;
begin
  if FLock <> nil then
    FLock.BeginWrite;
  Destroying;
  if FManagerSingleton = Self then begin
    Close;
    FManagerOptsIntf := nil;
    FManagerSingleton := nil;
  end;
  inherited Destroy;
  ADFreeAndNil(FConnections);
  if FOptionsIntf <> nil then begin
    FOptionsIntf.ObjectDestroyed(Self);
    FOptionsIntf := nil;
  end;
  ADFreeAndNil(FLock);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.Loaded;
begin
  inherited Loaded;
  try
    if FStreamedActive and ADCheckStoredUsage(ComponentState, ActiveStoredUsage) then
      SetActive(True);
  except
    if csDesigning in ComponentState then
      ADHandleException
    else
      raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.CheckInactive;
begin
  if Active then
    if (csDesigning in ComponentState) or ResourceOptions.AutoConnect then
      Close
    else
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntSessMBInactive, []);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.CheckActive;
begin
  if not Active then
    if ResourceOptions.AutoConnect then
      Open
    else
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntSessMBActive, []);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetSilentMode: Boolean;
begin
  Result := FADGUIxSilentMode;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetSilentMode(const AValue: Boolean);
begin
  FADGUIxSilentMode := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetWaitCursor: TADGUIxScreenCursor;
var
  oWait: IADGUIxWaitCursor;
begin
  ADCreateInterface(IADGUIxWaitCursor, oWait);
  Result := oWait.WaitCursor;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetWaitCursor(const AValue: TADGUIxScreenCursor);
var
  oWait: IADGUIxWaitCursor;
begin
  ADCreateInterface(IADGUIxWaitCursor, oWait);
  oWait.WaitCursor := AValue;
end;

{-------------------------------------------------------------------------------}
// IADStanObject

function TADCustomManager.GetName: TComponentName;
begin
  if Name = '' then
    Result := '$' + IntToHex(Integer(Self), 8)
  else
    Result := Name;
  Result := Result + ': ' + ClassName;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetParent: IADStanObject;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
// IADStanOptions

procedure TADCustomManager.SetOptionsIntf(const AValue: IADStanOptions);
begin
  if (FOptionsIntf <> AValue) or (FOptionsIntf = nil) and (AValue = nil) then begin
    FOptionsIntf := AValue;
    if FOptionsIntf = nil then begin
      FOptionsIntf := TADOptionsContainer.Create(Self, TADFetchOptions,
        TADUpdateOptions, TADTopResourceOptions, nil);
      FOptionsIntf.FormatOptions.OwnMapRules := True;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetFetchOptions: TADFetchOptions;
begin
  Result := FOptionsIntf.FetchOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetFetchOptions(const AValue: TADFetchOptions);
begin
  FOptionsIntf.FetchOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetFormatOptions: TADFormatOptions;
begin
  Result := FOptionsIntf.FormatOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetFormatOptions(const AValue: TADFormatOptions);
begin
  FOptionsIntf.FormatOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetUpdateOptions: TADUpdateOptions;
begin
  Result := FOptionsIntf.UpdateOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetUpdateOptions(const AValue: TADUpdateOptions);
begin
  FOptionsIntf.UpdateOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetResourceOptions: TADTopResourceOptions;
begin
  Result := TADTopResourceOptions(FOptionsIntf.ResourceOptions);
  ASSERT((Result <> nil) and (Result is TADTopResourceOptions));
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetResourceOptions(const AValue: TADTopResourceOptions);
begin
  FOptionsIntf.ResourceOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
// Phys Manager control

function TADCustomManager.GetActive: Boolean;
var
  oMgr: IADPhysManager;
begin
  ADCreateInterface(IADPhysManager, oMgr, False);
  Result := (oMgr <> nil) and (oMgr.State = dmsActive);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetState: TADPhysManagerState;
var
  oMgr: IADPhysManager;
begin
  ADCreateInterface(IADPhysManager, oMgr, False);
  if oMgr <> nil then
    Result := oMgr.State
  else
    Result := dmsInactive;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetActive(const AValue: Boolean);
var
  i, iAct: Integer;
  oConn: TADCustomConnection;
begin
  if csReading in ComponentState then
    FStreamedActive := AValue
  else begin
    iAct := 0;
    if Active <> AValue then
      if AValue then
        DoBeforeStartup
      else
        DoBeforeShutdown;
    FLock.BeginRead;
    try
      if Active <> AValue then
        if AValue then begin
          FLock.BeginWrite;
          try
            CheckInactive;
            // check that IADPhysManager implementation is linked
            ADPhysManager();
          finally
            FLock.EndWrite;
          end;
          iAct := 1;
        end
        else begin
          FLock.BeginWrite;
          try
            CheckActive;
            for i := FConnections.Count - 1 downto 0 do begin
              oConn := TADCustomConnection(FConnections[i]);
              if oConn.Temporary then
                ADFree(oConn)
              else
                oConn.Close;
            end;
          finally
            FLock.EndWrite;
          end;
          iAct := -1;
        end;
    finally
      FLock.EndRead;
    end;
    if iAct = 1 then begin
      InternalOpen;
      DoAfterStartup;
    end
    else if iAct = -1 then begin
      InternalClose;
      DoAfterShutdown;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.InternalOpen;
begin
  ADPhysManager.Open;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.DoBeforeStartup;
begin
  if Assigned(FBeforeStartup) then
    FBeforeStartup(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.DoAfterStartup;
begin
  if Assigned(FAfterStartup) then
    FAfterStartup(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.Open;
begin
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.InternalClose;
begin
  ADPhysManager.Close(True);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.DoBeforeShutdown;
begin
  if Assigned(FBeforeShutdown) then
    FBeforeShutdown(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.DoAfterShutdown;
begin
  if Assigned(FAfterShutdown) then
    FAfterShutdown(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.Close;
begin
  Active := False;
end;

{-------------------------------------------------------------------------------}
// Connection management

procedure TADCustomManager.AddConnection(AConn: TADCustomConnection);
begin
  FLock.BeginWrite;
  try
    if FConnections.IndexOf(AConn) = -1 then begin
      FConnections.Add(AConn);
      FreeNotification(AConn);
    end;
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.RemoveConnection(AConn: TADCustomConnection);
begin
  FLock.BeginWrite;
  try
    if FCachedConnection = AConn then
      FCachedConnection := nil;
    RemoveFreeNotification(AConn);
    FConnections.Remove(AConn);
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetConnectionCount: Integer;
begin
  FLock.BeginRead;
  try;
    Result := FConnections.Count;
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetConnection(AIndex: Integer): TADCustomConnection;
begin
  FLock.BeginRead;
  try;
    Result := TADCustomConnection(FConnections[AIndex]);
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.InternalAcquireConnection(AConnection: TADCustomConnection;
  const AConnectionName, AObjName: String): TADCustomConnection;
begin
  if (AConnection = nil) and (AConnectionName = '') then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbNotDefined, [AObjName]);
  FLock.BeginWrite;
  try
    if AConnection <> nil then
      Result := AConnection
    else begin
      Result := FindConnection(AConnectionName);
      if Result = nil then
        Result := InternalAcquireTemporaryConnection(AConnectionName);
    end;
    if Result.FRefCount >= 0 then
      Inc(Result.FRefCount);
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.InternalAcquireTemporaryConnection(
  const AConnectionName: string): TADCustomConnection;
begin
  Result := FConnectionClass.Create(Self);
  try
    Result.ConnectionName := AConnectionName;
    Result.Temporary := True;
  except
    ADFree(Result);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.AcquireConnection(const AConnectionName: string;
  const AObjName: String): TADCustomConnection;
begin
  Result := InternalAcquireConnection(nil, AConnectionName, AObjName);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.AcquireConnection(AConnection: TADCustomConnection;
  const AObjName: String): TADCustomConnection;
begin
  Result := InternalAcquireConnection(AConnection, '', AObjName);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.InternalReleaseConnection(var AConnection: TADCustomConnection);
begin
  FLock.BeginWrite;
  try
    AConnection.FLastUsed := Now();
    if AConnection.FRefCount > 0 then
      Dec(AConnection.FRefCount);
    if (AConnection.FRefCount = 0) and not AConnection.ResourceOptions.KeepConnection then
      if not AConnection.Temporary then
        AConnection.Close
      else if not (csDestroying in AConnection.ComponentState) then begin
        ADFree(AConnection);
        AConnection := nil;
      end;
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.ReleaseConnection(var AConnection: TADCustomConnection);
begin
  if AConnection = nil then
    Exit;
  InternalReleaseConnection(AConnection);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.DropConnections;
var
  i: Integer;
  oConn: TADCustomConnection;
begin
  FLock.BeginWrite;
  try
    for i := FConnections.Count - 1 downto 0 do begin
      oConn := TADCustomConnection(FConnections[i]);
      if oConn.RefCount = 0 then
        if oConn.Temporary then
          ADFree(oConn)
        else
          oConn.Connected := False;
    end;
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.FindConnection(const AConnectionName: string): TADCustomConnection;
begin
  if AConnectionName = '' then begin
    Result := nil;
    Exit;
  end;
  FLock.BeginRead;
  try
    if (FCachedConnection <> nil) and
       ({$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
         (FCachedConnection.ConnectionName, AConnectionName) = 0) then
      Result := FCachedConnection
    else begin
      Result := InternalFindConnection(AConnectionName);
      if Result <> nil then
        FCachedConnection := Result;
    end;
  finally
    FLock.EndRead;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.InternalFindConnection(const AConnectionName: string): TADCustomConnection;
var
  i: Integer;
  oConn: TADCustomConnection;
begin
  Result := nil;
  for i := 0 to FConnections.Count - 1 do begin
    oConn := TADCustomConnection(FConnections[i]);
    if {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
         (oConn.ConnectionName, AConnectionName) = 0 then begin
      Result := oConn;
      Break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
// Get XXX names

procedure TADCustomManager.GetConnectionNames(AList: TStrings);
var
  i: Integer;
  oNames: TADStringList;
  oConn: TADCustomConnection;
begin
  Active := True;
  oNames := TADStringList.Create;
  FLock.BeginRead;
  try
    oNames.Sorted := True;
    oNames.Duplicates := dupIgnore;
    oNames.BeginUpdate;
    for i := 0 to ConnectionDefs.Count - 1 do
      if ConnectionDefs[i].Name <> '' then
        oNames.Add(ConnectionDefs[i].Name);
    for i := 0 to FConnections.Count - 1 do begin
      oConn := TADCustomConnection(FConnections[I]);
      if oConn.ConnectionName <> '' then
        oNames.Add(oConn.ConnectionName);
    end;
    AList.Assign(oNames);
  finally
    FLock.EndRead;
    ADFree(oNames);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetConnectionDefNames(AList: TStrings);
var
  i: Integer;
  oNames: TADStringList;
begin
  Active := True;
  oNames := TADStringList.Create;
  FLock.BeginRead;
  try
    oNames.Sorted := True;
    oNames.Duplicates := dupIgnore;
    oNames.BeginUpdate;
    for i := 0 to ConnectionDefs.Count - 1 do
      if ConnectionDefs[i].Name <> '' then
        oNames.Add(ConnectionDefs[i].Name);
    AList.Assign(oNames);
  finally
    FLock.EndRead;
    ADFree(oNames);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetDriverNames(AList: TStrings;
  AValidate: Boolean = False; ABaseOnly: Boolean = False);
var
  oNames: TADStringList;
  i: Integer;
  oManMeta: IADPhysManagerMetadata;
  oDrv: IADPhysDriver;
begin
  Open;
  oNames := TADStringList.Create;
  try
    oNames.Sorted := True;
    oNames.Duplicates := dupIgnore;
    oNames.BeginUpdate;
    ADPhysManager.CreateMetadata(oManMeta);
    for i := 0 to oManMeta.DriverCount - 1 do
      if not ABaseOnly or (CompareText(oManMeta.DriverID[i], oManMeta.BaseDriverID[i]) = 0) then
        try
          if AValidate then
            ADPhysManager.CreateDriver(oManMeta.DriverID[i], oDrv);
          oNames.Add(oManMeta.DriverID[i]);
        except
          // silent
        end;
    AList.Assign(oNames);
  finally
    ADFree(oNames);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetCatalogNames(const AConnectionName,
  APattern: string; AList: TStrings);
var
  oConn: TADCustomConnection;
begin
  oConn := AcquireConnection(AConnectionName, Name);
  try
    oConn.GetCatalogNames(APattern, AList);
  finally
    ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetSchemaNames(const AConnectionName, ACatalogName,
  APattern: string; AList: TStrings);
var
  oConn: TADCustomConnection;
begin
  oConn := AcquireConnection(AConnectionName, Name);
  try
    oConn.GetSchemaNames(ACatalogName, APattern, AList);
  finally
    ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetTableNames(const AConnectionName, ACatalogName,
  ASchemaName, APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes;
  AFullName: Boolean);
var
  oConn: TADCustomConnection;
begin
  oConn := AcquireConnection(AConnectionName, Name);
  try
    oConn.GetTableNames(ACatalogName, ASchemaName, APattern, AList, AScopes,
      [tkSynonym, tkTable, tkView], AFullName);
  finally
    ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetFieldNames(const AConnectionName, ACatalogName,
  ASchemaName, ATableName, APattern: string; AList: TStrings);
var
  oConn: TADCustomConnection;
begin
  oConn := AcquireConnection(AConnectionName, Name);
  try
    oConn.GetFieldNames(ACatalogName, ASchemaName, ATableName, APattern, AList);
  finally
    ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetKeyFieldNames(const AConnectionName, ACatalogName,
  ASchemaName, ATableName, APattern: string; AList: TStrings);
var
  oConn: TADCustomConnection;
begin
  oConn := AcquireConnection(AConnectionName, Name);
  try
    oConn.GetKeyFieldNames(ACatalogName, ASchemaName, ATableName, APattern, AList);
  finally
    ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetPackageNames(const AConnectionName, ACatalogName,
  ASchemaName, APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes;
  AFullName: Boolean);
var
  oConn: TADCustomConnection;
begin
  oConn := AcquireConnection(AConnectionName, Name);
  try
    oConn.GetPackageNames(ACatalogName, ASchemaName, APattern, AList, AScopes,
      AFullName);
  finally
    ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetStoredProcNames(const AConnectionName, ACatalogName,
  ASchemaName, APackage, APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes;
  AFullName: Boolean);
var
  oConn: TADCustomConnection;
begin
  oConn := AcquireConnection(AConnectionName, Name);
  try
    oConn.GetStoredProcNames(ACatalogName, ASchemaName, APackage, APattern,
      AList, AScopes, AFullName);
  finally
    ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetGeneratorNames(const AConnectionName, ACatalogName,
  ASchemaName, APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes;
  AFullName: Boolean);
var
  oConn: TADCustomConnection;
begin
  oConn := AcquireConnection(AConnectionName, Name);
  try
    oConn.GetGeneratorNames(ACatalogName, ASchemaName, APattern, AList, AScopes,
      AFullName);
  finally
    ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
// Connection definitions

function TADCustomManager.GetConnectionDefs: IADStanConnectionDefs;
begin
  Result := ADPhysManager.ConnectionDefs;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetConnectionDefFileName: String;
begin
  Result := ConnectionDefs.Storage.FileName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetConnectionDefFileName(const AValue: String);
begin
  ConnectionDefs.Storage.FileName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetActualConnectionDefFileName: String;
begin
  Result := ConnectionDefs.Storage.ActualFileName;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetAfterLoadConnectionDefFile: TNotifyEvent;
begin
  Result := ConnectionDefs.AfterLoad;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetAfterLoadConnectionDefFile(const AValue: TNotifyEvent);
begin
  ConnectionDefs.AfterLoad := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetBeforeLoadConnectionDefFile: TNotifyEvent;
begin
  Result := ConnectionDefs.BeforeLoad;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetBeforeLoadConnectionDefFile(const AValue: TNotifyEvent);
begin
  ConnectionDefs.BeforeLoad := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetConnectionDefAutoLoad: Boolean;
begin
  Result := ConnectionDefs.AutoLoad;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetConnectionDefAutoLoad(const AValue: Boolean);
begin
  ConnectionDefs.AutoLoad := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetConnectionDefsLoaded: Boolean;
begin
  Result := ConnectionDefs.Loaded;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.IsConnectionDef(const AName: String): Boolean;
begin
  Result := (AName <> '') and (ConnectionDefs.FindConnectionDef(AName) <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.AddConnectionDef(const AName, ADriver: string; AList: TStrings;
  APersistent: Boolean = False);
var
  oDef: IADStanConnectionDef;
begin
  oDef := ConnectionDefs.AddConnectionDef;
  oDef.Params.BeginUpdate;
  try
    oDef.Params.Assign(AList);
    if AName <> '' then
      oDef.Name := AName;
    if ADriver <> '' then
      oDef.DriverID := ADriver;
  finally
    oDef.Params.EndUpdate;
  end;
  if APersistent then
    oDef.MarkPersistent;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.DeleteConnectionDef(const AName: string);
begin
  ConnectionDefs.ConnectionDefByName(AName).Delete;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.ModifyConnectionDef(const AName: string; AList: TStrings);
var
  i: Integer;
  sName, sValue: String;
  oDef: IADStanConnectionDef;
begin
  oDef := ConnectionDefs.ConnectionDefByName(AName);
  oDef.Params.BeginUpdate;
  try
    for i := 0 to AList.Count - 1 do begin
      sName := ADNameFromIndex(AList, i);
      sValue := ADValueFromIndex(AList, i);
      oDef.AsString[sName] := sValue;
    end;
  finally
    oDef.Params.EndUpdate;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.GetConnectionDefParams(const AName: string; AList: TStrings);
begin
  AList.Assign(ConnectionDefs.ConnectionDefByName(AName).Params);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.CloseConnectionDef(const AName: string);
var
  oDef: IADStanConnectionDef;
  i: Integer;
begin
  oDef := ConnectionDefs.FindConnectionDef(AName);
  if oDef = nil then
    Exit;
  FLock.BeginWrite;
  try
    for i := ConnectionCount - 1 downto 0 do
      if (CompareText(Connections[i].ConnectionDefName, AName) = 0) and
         not Connections[i].Offlined then
        Connections[i].Close;
    ADPhysManager.CloseConnectionDef(oDef);
  finally
    FLock.EndWrite;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SaveConnectionDefFile;
begin
  ConnectionDefs.Save;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.LoadConnectionDefFile;
begin
  ConnectionDefs.Load;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.RefreshMetadataCache;
begin
  if Active then
    ADPhysManager.RefreshMetadataCache;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.RefreshConnectionDefFile;
begin
  if ConnectionDefs.Loaded then begin
    ConnectionDefs.Clear;
    ConnectionDefs.Load;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetCanRefreshConnectionDefFile: Boolean;
begin
  Result := ConnectionDefs.Updatable;
end;

{-------------------------------------------------------------------------------}
// Driver configurations

function TADCustomManager.GetDriverDefs: IADStanDefinitions;
begin
  Result := ADPhysManager.DriverDefs;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetDriverDefAutoLoad: Boolean;
begin
  Result := ADPhysManager.DriverDefs.AutoLoad;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetDriverDefAutoLoad(const AValue: Boolean);
begin
  ADPhysManager.DriverDefs.AutoLoad := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetDriverDefFileName: String;
begin
  Result := ADPhysManager.DriverDefs.Storage.FileName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomManager.SetDriverDefFileName(const AValue: String);
begin
  ADPhysManager.DriverDefs.Storage.FileName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetActualDriverDefFileName: String;
begin
  Result := ADPhysManager.DriverDefs.Storage.ActualFileName;
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetBaseDriverID(const ADriverID: String): String;
var
  oManMeta: IADPhysManagerMetadata;
begin
  ADPhysManager.CreateMetadata(oManMeta);
  Result := oManMeta.GetBaseDriverID(ADriverID);
end;

{-------------------------------------------------------------------------------}
function TADCustomManager.GetRDBMSKind(const ADriverID: String): TADRDBMSKind;
var
  oManMeta: IADPhysManagerMetadata;
begin
  ADPhysManager.CreateMetadata(oManMeta);
  Result := oManMeta.GetRDBMSKind(ADriverID);
end;

{-------------------------------------------------------------------------------}
{ TADCustomConnection                                                           }
{-------------------------------------------------------------------------------}
constructor TADCustomConnection.Create(AOwner: TComponent);
var
  oOpts: IADStanOptions;
begin
  inherited Create(AOwner);
{$IFDEF AnyDAC_FPC}
  FDataSets := TADObjList.Create;
  FClients := TADObjList.Create;
  FConnectEvents := TADObjList.Create;
{$ENDIF}
  SetOptionsIntf(nil);
  ADCreateInterface(IADStanConnectionDef, FParams);
  FParams.OnChanging := ParamsChanging;
  FTxOptions := TADTxOptions.Create;
  FCommands := TADObjList.Create;
  LoginPrompt := True;
  oOpts := Self as IADStanOptions;
  FOptionsIntf := oOpts;
  FLastUsed := Now;
  FConnectedStoredUsage := [auDesignTime, auRunTime];
  FDeferredUnregs := TADObjList.Create;
  ADManager.AddConnection(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADCustomConnection.Destroy;
begin
  Destroying;
  Close;
  if FManagerSingleton <> nil then
    ADManager.RemoveConnection(Self);
  inherited Destroy;
  SetLoginDialog(nil);
  FParams := nil;
  if FOptionsIntf <> nil then begin
    FOptionsIntf.ObjectDestroyed(Self);
    FOptionsIntf := nil;
  end;
  ADFreeAndNil(FCommands);
  ADFreeAndNil(FTxOptions);
  ADFreeAndNil(FDeferredUnregs);
{$IFDEF AnyDAC_FPC}
  ADFreeAndNil(FConnectEvents);
  ADFreeAndNil(FClients);
  ADFreeAndNil(FDataSets);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Assign(Source: TPersistent);
var
  oSrc: TADCustomConnection;
begin
  if Source is TADCustomConnection then begin
    oSrc := Source as TADCustomConnection;
    Connected := False;
    Params := oSrc.Params;
    FetchOptions := oSrc.FetchOptions;
    FormatOptions := oSrc.FormatOptions;
    ResourceOptions := oSrc.ResourceOptions;
    UpdateOptions := oSrc.UpdateOptions;
    TxOptions := oSrc.TxOptions;
    SharedCliHandle := oSrc.SharedCliHandle;
    Temporary := oSrc.Temporary;
    ConnectedStoredUsage := oSrc.ConnectedStoredUsage;
    Offlined := oSrc.Offlined;
    LoginPrompt := oSrc.LoginPrompt;
    LoginDialog := oSrc.LoginDialog;
    AfterConnect := oSrc.AfterConnect;
    BeforeConnect := oSrc.BeforeConnect;
    AfterDisconnect := oSrc.AfterDisconnect;
    BeforeDisconnect := oSrc.BeforeDisconnect;
    OnLogin := oSrc.OnLogin;
    OnError := oSrc.OnError;
    OnLosted := oSrc.OnLosted;
    OnRestored := oSrc.OnRestored;
    OnRecover := oSrc.OnRecover;
    BeforeStartTransaction := oSrc.BeforeStartTransaction;
    AfterStartTransaction := oSrc.AfterStartTransaction;
    BeforeCommit := oSrc.BeforeCommit;
    AfterCommit := oSrc.AfterCommit;
    BeforeRollback := oSrc.BeforeRollback;
    AfterRollback := oSrc.AfterRollback;
  end
  else
    inherited Assign(Source);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Loaded;
begin
  StreamedConnected := StreamedConnected and
    ADCheckStoredUsage(ComponentState, ADManager.ActiveStoredUsage * ConnectedStoredUsage);
  inherited Loaded;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if AOperation = opRemove then
    if FLoginDialog = AComponent then
      SetLoginDialog(nil)
    else if Transaction = AComponent then
      Transaction := nil
    else if UpdateTransaction = AComponent then
      UpdateTransaction := nil;
  inherited Notification(AComponent, AOperation);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.CheckActive;
begin
  CheckOnline;
  if not Connected then
    if Temporary or ResourceOptions.AutoConnect then
      Open
    else
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbMBActive, [GetName]);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.CheckInactive;
begin
  if Connected then
    if (csDesigning in ComponentState) or Temporary or ResourceOptions.AutoConnect then
      Close
    else
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbMBInactive, [GetName]);
end;

{-------------------------------------------------------------------------------}
// IADStanOptions

procedure TADCustomConnection.GetParentOptions(out AOpts: IADStanOptions);
begin
  if FManagerOptsIntf = nil then
    ADManager();
  AOpts := FManagerOptsIntf;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetOptionsIntf(const AValue: IADStanOptions);
begin
  if (FOptionsIntf <> AValue) or (FOptionsIntf = nil) and (AValue = nil) then begin
    FOptionsIntf := AValue;
    if FOptionsIntf = nil then
      FOptionsIntf := TADOptionsContainer.Create(Self, TADFetchOptions,
        TADUpdateOptions, TADTopResourceOptions, GetParentOptions);
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetFetchOptions: TADFetchOptions;
begin
  Result := FOptionsIntf.FetchOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetFetchOptions(const AValue: TADFetchOptions);
begin
  FOptionsIntf.FetchOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetFormatOptions: TADFormatOptions;
begin
  Result := FOptionsIntf.FormatOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetFormatOptions(const AValue: TADFormatOptions);
begin
  FOptionsIntf.FormatOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetUpdateOptions: TADUpdateOptions;
begin
  Result := FOptionsIntf.UpdateOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetUpdateOptions(const AValue: TADUpdateOptions);
begin
  FOptionsIntf.UpdateOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetResourceOptions: TADTopResourceOptions;
begin
  Result := TADTopResourceOptions(FOptionsIntf.ResourceOptions);
  ASSERT((Result <> nil) and (Result is TADTopResourceOptions));
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetResourceOptions(const AValue: TADTopResourceOptions);
begin
  FOptionsIntf.ResourceOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
// Other

procedure TADCustomConnection.SetTxOptions(const AValue: TADTxOptions);
begin
  FTxOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
begin
  if Assigned(FOnError) then
    if AInitiator = nil then
      FOnError(Self, Self as IADStanObject, AException)
    else
      FOnError(Self, AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DoRecover(const AInitiator: IADStanObject;
  AException: Exception; var AAction: TADPhysConnectionRecoverAction);
begin
  if Assigned(FOnRecover) then
    FOnRecover(Self, AInitiator, AException, AAction);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.HandleConnectionRecover(const AInitiator: IADStanObject;
  AException: Exception; var AAction: TADPhysConnectionRecoverAction);
begin
  if csReading in ComponentState then
    AAction := faFail
  else if AInitiator = nil then
    DoRecover(Self as IADStanObject, AException, AAction)
  else
    DoRecover(AInitiator, AException, AAction);
  FTmpConnectionIntf := FConnectionIntf;
  case AAction of
  faCloseAbort:
    Connected := False;
  faOfflineAbort:
    Offlined := True;
  faFail:
    Connected := False;
  faDefault:
    if not GetResourceOptions.AutoReconnect then begin
      DoLosted;
      Connected := False;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DoLosted;
begin
  if Assigned(FOnLosted) then
    FOnLosted(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.HandleConnectionLosted;
begin
  ReleaseConnectionIntf(FTmpConnectionIntf);
  DoLosted;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DoRestored;
begin
  if Assigned(FOnRestored) then
    FOnRestored(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.HandleConnectionRestored;
begin
  if FTmpConnectionIntf = FConnectionIntf then
    FTmpConnectionIntf := nil
  else
    ReleaseConnectionIntf(FTmpConnectionIntf);
  DoRestored;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetSQLBased: Boolean;
begin
  Result := RDBMSKind in [mkOracle, mkMSSQL, mkMSAccess, mkMySQL, mkDB2, mkASA,
    mkADS, mkInterbase, mkSQLite, mkPostgreSQL, mkNexus, mkOther];
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetRDBMSKind: TADRDBMSKind;
var
  oConMeta: IADPhysConnectionMetadata;
begin
  if ConnectionIntf <> nil then begin
    ConnectionIntf.CreateMetadata(oConMeta);
    Result := oConMeta.Kind;
  end
  else begin
    PrepareConnectionDef;
    Result := ADManager.GetRDBMSKind(FParams.DriverID);
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetParams: TStrings;
begin
  Result := FParams.Params;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.ParamsChanging(ASender: TObject);
begin
  CheckInactive;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetParams(const AValue: TStrings);
begin
  CheckInactive;
  FParams.Params := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetConnectionDefName: string;
begin
  Result := FParams.AsString[S_AD_DefinitionParam_Common_ConnectionDef];
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetConnectionDefName(const AValue: string);
begin
  if GetConnectionDefName <> AValue then begin
    FParams.DriverID := '';
    FParams.AsString[S_AD_DefinitionParam_Common_ConnectionDef] := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetDriverName: string;
begin
  Result := FParams.DriverID;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetDriverName(const AValue: string);
begin
  if GetDriverName <> AValue then begin
    FParams.AsString[S_AD_DefinitionParam_Common_ConnectionDef] := '';
    FParams.DriverID := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DoValidateName(const AName: string);
var
  oConn: TADCustomConnection;
begin
  if AName <> '' then begin
    oConn := ADManager.FindConnection(AName);
    if (oConn <> nil) and (oConn <> Self) then begin
      if not oConn.Temporary or (oConn.FRefCount <> 0) then
        ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbDupName, [AName]);
      ADFree(oConn);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetConnectionName(const AValue: String);
begin
  if csReading in ComponentState then
    FConnectionName := AValue
  else if FConnectionName <> AValue then begin
    CheckInactive;
    DoValidateName(AValue);
    FConnectionName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetLoginDialog(const AValue: TADGUIxLoginDialog);
begin
  if FLoginDialog <> nil then begin
    FLoginDialog.RemoveFreeNotification(Self);
    FLoginDialog.ConnectionDef := nil;
  end;
  FLoginDialog := AValue;
  if FLoginDialog <> nil then begin
    FLoginDialog.FreeNotification(Self);
    FLoginDialog.ConnectionDef := ResultConnectionDef;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DoInternalLogin;
begin
  ConnectionIntf.LoginPrompt := False;
  ConnectionIntf.Open;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DoLogin(const AConnectionDef: IADStanConnectionDef);
  procedure ErrorLoginAborted;
  var
    s: String;
  begin
    s := ConnectionName;
    if s = '' then
      s := ConnectionDefName;
    if s = '' then
      s := ResultConnectionDef.Name;
    if s = '' then
      s := S_AD_Unnamed;
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbLoginAborted, [s]);
  end;
var
  oDlg: IADGUIxLoginDialog;
begin
  if Assigned(FOnLogin) then
    FOnLogin(Self, AConnectionDef)
  else begin
    if (Assigned(FLoginDialog) and not Assigned(FLoginDialog.LoginDialog)) or
        not Assigned(FLoginDialog) then begin
      ADCreateInterface(IADGUIxLoginDialog, oDlg, False);
      if oDlg = nil then begin
        DoInternalLogin;
        Exit;
      end;
      oDlg.ConnectionDef := ResultConnectionDef;
    end
    else
      oDlg := FLoginDialog as IADGUIxLoginDialog;
    try
      if not oDlg.Execute(DoInternalLogin) then
        ErrorLoginAborted;
    finally
      if not Assigned(FLoginDialog) then
        oDlg.ConnectionDef := nil;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.PrepareConnectionDef;
begin
  ADManager.CheckActive;
  if DriverName <> '' then
    // nothing
  else if ConnectionDefName <> '' then
    FParams.ParentDefinition := ADManager.ConnectionDefs.ConnectionDefByName(ConnectionDefName)
  else if ConnectionName <> '' then
    FParams.ParentDefinition := ADManager.ConnectionDefs.FindConnectionDef(ConnectionName);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.CheckConnectionDef;
begin
  PrepareConnectionDef;
  try
    if FParams.Pooled and
       not ((FParams.Params.Count = 0) or
            (FParams.Params.Count = 1) and
              (FParams.Params.Names[0] = S_AD_DefinitionParam_Common_ConnectionDef)) then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbCantConnPooled, [GetName]);
    if FParams.DriverID = '' then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_AccSrvNotDefined, []);
  except
    FParams.ParentDefinition := nil;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetConnectionMetadata(AOpen: Boolean): IADPhysConnectionMetadata;
begin
  if AOpen then
    CheckActive;
  if ConnectionIntf <> nil then
    ConnectionIntf.CreateMetadata(Result)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetConnectionMetadataIntf: IADPhysConnectionMetadata;
begin
  Result := GetConnectionMetadata(True);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.AcquireDefaultTransaction(const AConnIntf: IADPhysConnection);
var
  oTX: IADPhysTransaction;
begin
  if AConnIntf.Transaction = nil then begin
    AConnIntf.CreateTransaction(oTX);
    AConnIntf.Transaction := oTX;
  end;
  AConnIntf.Transaction.AddStateHandler(Self as IADPhysTransactionStateHandler);
  AConnIntf.Transaction.Options := FTxOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.AcquireConnectionIntf(out AConnIntf: IADPhysConnection);
var
  oObjIntf: IADStanObject;
begin
  CheckConnectionDef;
  if FParams.Pooled then
    ADPhysManager.CreateConnection(
      FParams.ParentDefinition as IADStanConnectionDef, AConnIntf)
  else begin
    ADPhysManager.CreateConnection(FParams, AConnIntf);
    if FSharedCliHandle <> nil then
      AConnIntf.SharedCliHandle := FSharedCliHandle;
  end;
  if Supports(AConnIntf, IADStanObject, oObjIntf) then begin
    oObjIntf.SetOwner(Self, '');
    oObjIntf := nil;
  end;
  AConnIntf.ErrorHandler := Self as IADStanErrorHandler;
  AConnIntf.RecoveryHandler := Self as IADPhysConnectionRecoveryHandler;
  AConnIntf.Options := Self as IADStanOptions;
  FParams.ReadOptions(FormatOptions, UpdateOptions, FetchOptions, ResourceOptions);
  AcquireDefaultTransaction(AConnIntf);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.ReleaseDefaultTransaction(const AConnIntf: IADPhysConnection);
begin
  if AConnIntf.Transaction <> nil then begin
    AConnIntf.Transaction.Options := nil;
    AConnIntf.Transaction.RemoveStateHandler(Self as IADPhysTransactionStateHandler);
    AConnIntf.Transaction := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.ReleaseConnectionIntf(var AConnIntf: IADPhysConnection);

  procedure DoCleanup;
  begin
    AConnIntf.ErrorHandler := nil;
    AConnIntf.RecoveryHandler := nil;
    ReleaseDefaultTransaction(AConnIntf);
    AConnIntf := nil;
  end;

begin
  if AConnIntf <> nil then
    DoCleanup;
  if AConnIntf = FConnectionIntf then
    FParams.ParentDefinition := nil;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetConnected: Boolean;
begin
  Result := (ConnectionIntf <> nil) and
    (ConnectionIntf.State in [csRecovering, csConnected]);
end;

{$IFDEF AnyDAC_FPC}
{-------------------------------------------------------------------------------}
function TADCustomConnection.GetDataSet(AIndex: Integer): TDataSet;
begin
  Result := TDataSet(FDataSets[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetDataSetCount: Integer;
begin
  Result := FDataSets.Count;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SendConnectEvent(AConnecting: Boolean);
var
  i: Integer;
  eConn: TADConnectChangeEvent;
begin
  for i := 0 to FClients.Count - 1 do begin
    if FConnectEvents[i] <> nil then begin
      TMethod(eConn).Code := FConnectEvents[i];
      TMethod(eConn).Data := FClients[i];
      eConn(Self, AConnecting);
    end;
    if TObject(FClients[i]) is TADAdaptedDataSet then
      TADAdaptedDataSet(FClients[i]).DataEvent(deConnectChange, Integer(AConnecting));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.RegisterClient(AClient: TObject; AEvent: TADConnectChangeEvent = nil);
begin
  FClients.Add(AClient);
  FConnectEvents.Add(TMethod(AEvent).Code);
  if AClient is TDataSet then
    FDataSets.Add(AClient);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.UnRegisterClient(AClient: TObject);
{$IFDEF AnyDAC_FPC}
var
  iIndex: Integer;
{$ENDIF}
begin
  if FDisconnecting then
    FDeferredUnregs.Add(AClient)
  else begin
{$IFNDEF AnyDAC_FPC}
    inherited UnRegisterClient(AClient);
{$ELSE}
    if AClient is TDataSet then
      FDataSets.Remove(AClient);
    iIndex := FClients.IndexOf(AClient);
    if iIndex <> -1 then begin
      FClients.Delete(iIndex);
      FConnectEvents.Delete(iIndex);
    end;
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetConnected(AValue: Boolean);
var
  i: Integer;
begin
  try
    try
      FDisconnecting := not AValue;
      inherited SetConnected(AValue);
    finally
      FDisconnecting := False;
      if FDeferredUnregs <> nil then
        for i := 0 to FDeferredUnregs.Count - 1 do
          UnRegisterClient(TObject(FDeferredUnregs[i]));
    end;
  finally
    if FDeferredUnregs <> nil then
      FDeferredUnregs.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DoConnect;
var
  lErasePassword: Boolean;
begin
  if not Connected then
  try
{$IFNDEF AnyDAC_FPC}
    inherited DoConnect;
{$ENDIF}
    lErasePassword := False;
    try
      AcquireConnectionIntf(FConnectionIntf);
      lErasePassword := not FParams.HasValue(S_AD_ConnParam_Common_Password) and
        not ResourceOptions.AutoReconnect and not FParams.Pooled;
      if LoginPrompt and not FParams.Pooled and not ADGUIxSilent() and
         (FSharedCliHandle = nil) then
        DoLogin(FParams);
      if ConnectionIntf.State = csDisconnected then
        DoInternalLogin;
      FOfflined := False;
    finally
      FParams.OnChanging := nil;
      if lErasePassword then
        FParams.Password := ''
      else if FParams.NewPassword <> '' then
        FParams.Password := FParams.NewPassword;
      FParams.NewPassword := '';
      FParams.OnChanging := ParamsChanging;
    end;
  except
    ReleaseConnectionIntf(FConnectionIntf);
    raise;
  end;
{$IFDEF AnyDAC_FPC}
  SendConnectEvent(True);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DoDisconnect;
begin
{$IFDEF AnyDAC_FPC}
  SendConnectEvent(False);
{$ENDIF}
  if not Connected then
    Exit;
  if FExecSQLCommand <> nil then begin
    FExecSQLCommand.ErrorHandler := nil;
    FExecSQLCommand := nil;
  end;
  ADFreeAndNil(FExecSQLTab);
  if ConnectionIntf <> nil then begin
    try
      FRefCount := -1;
      if FOfflined then
        ReleaseClients(rmOffline)
      else
        ReleaseClients(rmDisconnect);
      if not FParams.Pooled then
        ConnectionIntf.Close;
    finally
      FRefCount := 0;
    end;
  end;
  if FTmpConnectionIntf = FConnectionIntf then
    FConnectionIntf := nil
  else
    ReleaseConnectionIntf(FConnectionIntf);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetConnectionString: String;
var
  sName: String;
  sStr: String;
begin
  sName := ConnectionDefName;
  sStr := Trim(ResultConnectionDef.BuildString());
  if (sName <> '') and
     (CompareText(sStr, S_AD_DefinitionParam_Common_ConnectionDef + '=' + sName) = 0) then
    Result := sName
  else
    Result := sStr;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetConnectionString(const AConnectionString: String);
begin
  Connected := False;
  ResultConnectionDef.Clear;
  if Pos('=', AConnectionString) <> 0 then
    ResultConnectionDef.ParseString(AConnectionString)
  else
    ConnectionDefName := AConnectionString;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetUserNamePassword(const AUserName: String;
  const APassword: String);
begin
  Connected := False;
  if AUserName <> '' then
    ResultConnectionDef.UserName := AUserName;
  if APassword <> '' then
    ResultConnectionDef.Password := APassword;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Open(const AConnectionString: String);
begin
  if ConnectionString <> AConnectionString then
    SetConnectionString(AConnectionString);
  Connected := True;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Open(const AConnectionString: String;
  const AUserName: String; const APassword: String);
begin
  SetConnectionString(AConnectionString);
  SetUserNamePassword(AUserName, APassword);
  Connected := True;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Open(const AUserName: String; const APassword: String);
begin
  SetUserNamePassword(AUserName, APassword);
  Connected := True;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetOfflined(AValue: Boolean);
begin
  if Offlined <> AValue then begin
    FOfflined := AValue;
    Connected := not AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Offline;
begin
  Offlined := True;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Online;
begin
  Offlined := False;
  Connected := True;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.CheckOnline;
begin
  if Offlined then
    if Temporary or ResourceOptions.AutoConnect then
      Online
    else
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbMBOnline, [GetName]);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.Ping: Boolean;
begin
  if ConnectionIntf <> nil then
    Result := ConnectionIntf.Ping
  else
    try
      Connected := True;
      Result := True;
    except
      Result := False;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.AbortJob(AWait: Boolean = False);
var
  i: Integer;
begin
  i := DataSetCount - 1;
  while i >= 0 do begin
    if (i < DataSetCount) and (DataSets[i] is TADAdaptedDataSet) then
      try
        TADAdaptedDataSet(DataSets[i]).AbortJob(AWait);
      except
      end;
    Dec(i);
  end;
  i := CommandCount - 1;
  while i >= 0 do begin
    if i < CommandCount then
      try
        Commands[i].AbortJob(AWait);
      except
      end;
    Dec(i);
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR_Comp}
procedure TADCustomConnection.Trace(AStep: TADMoniEventStep; ASender: TObject;
  const AMsg: String; const AArgs: array of const);
begin
  if (ConnectionIntf <> nil) and ConnectionIntf.Tracing then
    ConnectionIntf.Monitor.Notify(ekComponent, AStep, ASender, AMsg, AArgs);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetInfoReport(AList: TStrings;
  AItems: TADInfoReportItems = [riConnDef .. riKeepConnected]): TADInfoReportStatus;
var
  oWait: IADGUIxWaitCursor;
  oMAIntf: IADMoniAdapter;
  i: Integer;
  sSessionMsg, sClientMsg, sMsg, sName, sVal: String;
  oDef: IADStanDefinition;
  oConnIntf: IADPhysConnection;
  lHasInfo, lDisconnect: Boolean;
  oMessages: TStrings;

  procedure Header(const ACaption: String);
  begin
    AList.Add('================================');
    AList.Add(ACaption);
    AList.Add('================================');
    lHasInfo := False;
  end;

  procedure CheckNA;
  begin
    if not lHasInfo then
      AList.Add('Not accessible.');
  end;

  procedure PutItems(AKind: TADMoniAdapterItemKind);
  var
    i: Integer;
    sName: String;
    vValue: Variant;
    eKind: TADMoniAdapterItemKind;
  begin
    if oMAIntf <> nil then
      for i := 0 to oMAIntf.ItemCount - 1 do begin
        oMAIntf.GetItem(i, sName, vValue, eKind);
        if eKind = AKind then begin
          AList.Add(sName + ' = ' + VarToStr(vValue));
          lHasInfo := True;
        end;
      end;
  end;

begin
  Result := [];
  oWait := nil;
  sSessionMsg := '';
  sClientMsg := '';
  sMsg := '';
  lDisconnect := False;
  AList.BeginUpdate;
  if not ResourceOptions.ActualSilentMode then begin
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.StartWait;
  end;
  try
    AList.Clear;
    if (riTryConnect in AItems) and not Connected then
      try
        Connected := True;
        lDisconnect := not (riKeepConnected in AItems);
      except
        on E: Exception do
          sSessionMsg := E.Message;
      end;
    try
      if ConnectionIntf = nil then
        AcquireConnectionIntf(oConnIntf)
      else
        oConnIntf := ConnectionIntf;
      if (oConnIntf <> nil) and (oConnIntf.Driver.State = drsRegistered) then
        oConnIntf.Driver.Load;
    except
      on E: Exception do
        sClientMsg := E.Message;
    end;

    if (oConnIntf = nil) or (oConnIntf.Driver.State = drsRegistered) then
      Include(Result, rsClientError)
    else if (oConnIntf.State <> csConnected) and (riTryConnect in AItems) then
      Include(Result, rsSessionError);

    try

      if riConnDef in AItems then begin
        Header('Connection definition parameters');
        oDef := ResultConnectionDef;
        while oDef <> nil do begin
          for i := 0 to oDef.Params.Count - 1 do begin
            sName := ADNameFromIndex(oDef.Params, i);
            sVal := ADValueFromIndex(oDef.Params, i);
            if (CompareText(sName, S_AD_ConnParam_Common_Password) = 0) or
               (CompareText(sName, S_AD_ConnParam_Common_NewPassword) = 0) then
              sVal := '*****';
            AList.Add(sName + '=' + sVal);
            lHasInfo := True;
          end;
          oDef := oDef.ParentDefinition;
        end;
        CheckNA;
      end;

      oMAIntf := oConnIntf as IADMoniAdapter;
      if riFireDAC in AItems then begin
        Header(C_AD_Product + ' info');
        PutItems(ikAnyDACInfo);
        CheckNA;
      end;

      if riClient in AItems then begin
        Header('Client info');
        if (riClientLog in AItems) and
           (oConnIntf <> nil) and (oConnIntf.Driver.Messages <> nil) then begin
          lHasInfo := True;
          for i := 0 to oConnIntf.Driver.Messages.Count - 1 do begin
            sMsg := oConnIntf.Driver.Messages[i];
            if (Pos('Warning:', sMsg) > 0) or (Pos('Error:', sMsg) > 0) then
              Include(Result, rsClientWarning);
            AList.Add(sMsg);
          end;
        end;
        if sClientMsg <> '' then begin
          AList.Add('Failed to load DBMS client !');
          if Pos(sClientMsg, sMsg) = 0 then begin
            AList.Add(sClientMsg);
            lHasInfo := True;
          end;
        end
        else
          PutItems(ikClientInfo);
        CheckNA;
      end;

      if riSession in AItems then begin
        Header('Session info');
        if (sSessionMsg <> '') and (not (riClient in AItems) or (sClientMsg <> sSessionMsg)) then begin
          AList.Add('Failed to connect to DBMS !');
          AList.Add(sSessionMsg);
          lHasInfo := True;
        end
        else if (oConnIntf = nil) or (oConnIntf.State <> csConnected) then begin
          AList.Add('Not connected to DBMS.');
          lHasInfo := True;
        end
        else begin
          if riSessionHints in AItems then begin
            oMessages := TADStringList.Create;
            try
              oConnIntf.AnalyzeSession(oMessages);
              if oMessages.Count > 0 then begin
                lHasInfo := True;
                AList.Add('Checking session ...');
                for i := 0 to oMessages.Count - 1 do begin
                  sMsg := oMessages[i];
                  if (Pos('Warning:', sMsg) > 0) or (Pos('Error:', sMsg) > 0) then
                    Include(Result, rsSessionWarning);
                  AList.Add('  ' + sMsg);
                end;
              end;
            finally
              ADFree(oMessages);
            end;
          end;
          PutItems(ikSessionInfo);
        end;
        CheckNA;
      end;

    finally
      if ConnectionIntf = nil then
        ReleaseConnectionIntf(oConnIntf);
    end;
  finally
    if lDisconnect then
      Connected := False;
    if oWait <> nil then
      oWait.StopWait;
    AList.EndUpdate;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetInTransaction: Boolean;
begin
  if Connected then
    Result := ConnectionIntf.Transaction.Active
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.StartTransaction;
begin
  CheckActive;
  ConnectionIntf.Transaction.StartTransaction;
  if (FUpdateTransaction <> nil) and
     (ConnectionIntf.Transaction <> FUpdateTransaction.TransactionIntf) then
    FUpdateTransaction.StartTransaction;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Commit;
begin
  CheckActive;
  ConnectionIntf.Transaction.Commit;
  if (FUpdateTransaction <> nil) and
     (ConnectionIntf.Transaction <> FUpdateTransaction.TransactionIntf) then
    FUpdateTransaction.Commit;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.CommitRetaining;
begin
  CheckActive;
  ConnectionIntf.Transaction.CommitRetaining;
  if (FUpdateTransaction <> nil) and
     (ConnectionIntf.Transaction <> FUpdateTransaction.TransactionIntf) then
    FUpdateTransaction.CommitRetaining;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.Rollback;
begin
  CheckActive;
  ConnectionIntf.Transaction.Rollback;
  if (FUpdateTransaction <> nil) and
     (ConnectionIntf.Transaction <> FUpdateTransaction.TransactionIntf) then
    FUpdateTransaction.Rollback;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.RollbackRetaining;
begin
  CheckActive;
  ConnectionIntf.Transaction.RollbackRetaining;
  if (FUpdateTransaction <> nil) and
     (ConnectionIntf.Transaction <> FUpdateTransaction.TransactionIntf) then
    FUpdateTransaction.RollbackRetaining;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.HandleDisconnectCommands(AFilter: TADPhysDisconnectFilter;
  AMode: TADPhysDisconnectMode);
var
  i: Integer;
  oDS: TADRdbmsDataSet;
begin
  for i := DataSetCount - 1 downto 0 do
    if DataSets[i] is TADRdbmsDataSet then begin
      oDS := TADRdbmsDataSet(DataSets[i]);
      if (oDS.Transaction = nil) and oDS.Prepared and
         (not Assigned(AFilter) or AFilter(oDS.Command.CommandIntf.CliObj)) then
        case AMode of
        dmOffline: oDS.Offline;
        dmRelease: oDS.Release;
        end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.HandleTxOperation(AOperation: TADPhysTransactionState;
  ABefore: Boolean);
begin
  case AOperation of
  tsActive:
    if ABefore then begin
      if Assigned(BeforeStartTransaction) then
        BeforeStartTransaction(Self);
    end
    else begin
      if Assigned(AfterStartTransaction) then
        AfterStartTransaction(Self);
    end;
  tsCommiting:
    if ABefore then begin
      if Assigned(BeforeCommit) then
        BeforeCommit(Self);
    end
    else begin
      if Assigned(AfterCommit) then
        AfterCommit(Self);
    end;
  tsRollingback:
    if ABefore then begin
      if Assigned(BeforeRollback) then
        BeforeRollback(Self);
    end
    else begin
      if Assigned(AfterRollback) then
        AfterRollback(Self);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.ReleaseClients(AMode: TADReleaseClientMode = rmDisconnect);
var
  n, i: Integer;
  oDS: TADAdaptedDataSet;
begin
  for i := DataSetCount - 1 downto 0 do
    case AMode of
    rmFetchAll:
      begin
        oDS := TADAdaptedDataSet(DataSets[i]);
        if oDS.Active and not oDS.SourceEOF and oDS.DoIsSourceOpen then
          if oDS.FetchOptions.Unidirectional then
            oDS.Close
          else
            oDS.FetchAll;
      end;
    rmClose:
      DataSets[i].Close;
    rmOffline:
      DataSets[i].Offline;
    rmDisconnect:
      begin
        n := DataSetCount;
        DataSets[i].Disconnect(True);
        if n = DataSetCount then
          DetachClient(DataSets[i]);
      end;
    end;
  for i := CommandCount - 1 downto 0 do begin
    case AMode of
    rmFetchAll,
    rmClose:
      Commands[i].Close;
    rmOffline,
    rmDisconnect:
      begin
        n := CommandCount;
        Commands[i].Disconnect(True);
        if n = CommandCount then
          DetachClient(Commands[i]);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetADDataSet(AIndex: Integer): TADDataSet;
begin
  Result := inherited DataSets[AIndex] as TADDataSet;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetCommandCount: Integer;
begin
  Result := FCommands.Count;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetCommands(AIndex: Integer): TADCustomCommand;
begin
  Result := TADCustomCommand(FCommands[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.AttachClient(AObj: TObject);
begin
  RegisterClient(AObj);
  if AObj is TADCustomCommand then
    FCommands.Add(AObj);
  if FRefCount = 0 then
    Open
  else if FRefCount > 0 then
    Inc(FRefCount);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DetachClient(AObj: TObject);
begin
  UnRegisterClient(AObj);
  if AObj is TADCustomCommand then
    FCommands.Remove(AObj);
  if FRefCount = 1 then begin
    if not ResourceOptions.KeepConnection then
      Close;
  end
  else if FRefCount > 0 then
    Dec(FRefCount);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetFieldNames(const ACatalogName, ASchemaName,
  ATableName, APattern: String; AList: TStrings);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
  oConn: TADCustomConnection;
begin
  oConn := ADManager.AcquireConnection(Self, Name);
  try
    oConnMeta := GetConnectionMetadata(True);
    oView := oConnMeta.GetTableFields(ACatalogName, ASchemaName, ATableName, APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do
        AList.Add(EncodeObjectName('*', '*', '*',
          CnvMetaValue(oView.Rows[i].GetData('COLUMN_NAME'))));
    finally
      AList.EndUpdate;
      ADClearMetaView(oView, FetchOptions);
    end;
  finally
    ADManager.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetKeyFieldNames(const ACatalogName,
  ASchemaName, ATableName, APattern: string; AList: TStrings);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
  oConn: TADCustomConnection;
begin
  oConn := ADManager.AcquireConnection(Self, Name);
  try
    oConnMeta := GetConnectionMetadata(True);
    oView := oConnMeta.GetTablePrimaryKeyFields(ACatalogName, ASchemaName, ATableName, APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do
        AList.Add(EncodeObjectName('*', '*', '*',
          CnvMetaValue(oView.Rows[i].GetData('COLUMN_NAME'))));
    finally
      AList.EndUpdate;
      ADClearMetaView(oView, FetchOptions);
    end;
  finally
    ADManager.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.EncodeObjectName(const ACatalogName, ASchemaName,
  ABaseObjectName, AObjectName: String): String;
var
  oConMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
begin
  CheckActive;
  rName.FCatalog := CnvMetaValue(ACatalogName);
  rName.FSchema := CnvMetaValue(ASchemaName);
  rName.FBaseObject := CnvMetaValue(ABaseObjectName);
  rName.FObject := CnvMetaValue(AObjectName);
  ConnectionIntf.CreateMetadata(oConMeta);
  Result := oConMeta.EncodeObjName(rName, nil, [eoBeautify]);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.DecodeObjectName(const AFullName: String;
  var ACatalogName, ASchemaName, ABaseObjectName, AObjectName: String);
var
  oConMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
begin
  CheckActive;
  ConnectionIntf.CreateMetadata(oConMeta);
  oConMeta.DecodeObjName(AFullName, rName, nil, [doUnquote, doNormalize]);
  ACatalogName := rName.FCatalog;
  ASchemaName := rName.FSchema;
  ABaseObjectName := rName.FBaseObject;
  AObjectName := rName.FObject;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.CnvMetaValue(const AStr: Variant; const ADefault: String = ''): String;
begin
{$IFDEF AnyDAC_D6Base}
  Result := VarToStrDef(AStr, '');
{$ELSE}
  Result := VarToStr(AStr);
{$ENDIF}
  if (CompareText(Result, '<NULL>') = 0) or
     (ADefault <> '') and (CompareText(Result, ADefault) = 0) then
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetCatalogNames(const APattern: string;
  AList: TStrings);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
  oConn: TADCustomConnection;
begin
  oConn := ADManager.AcquireConnection(Self, Name);
  try
    oConnMeta := GetConnectionMetadata(True);
    oView := oConnMeta.GetCatalogs(APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do
        AList.Add(CnvMetaValue(oView.Rows[i].GetData('CATALOG_NAME'), ''));
    finally
      AList.EndUpdate;
      ADFree(oView.Table);
    end;
  finally
    ADManager.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetSchemaNames(const ACatalogName,
  APattern: string; AList: TStrings);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
  oConn: TADCustomConnection;
begin
  oConn := ADManager.AcquireConnection(Self, Name);
  try
    oConnMeta := GetConnectionMetadata(True);
    oView := oConnMeta.GetSchemas(ACatalogName, APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do
        AList.Add(CnvMetaValue(oView.Rows[i].GetData('SCHEMA_NAME'), ''));
    finally
      AList.EndUpdate;
      ADFree(oView.Table);
    end;
  finally
    ADManager.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.EncodeListName(const ACatalogName, ASchemaName: String;
  const ABaseField, AObjField: String; ARow: TADDatSRow; AList: TStrings;
  AFullName: Boolean): String;
var
  sBase, sObj, sName: String;
begin
  Result := '';
  sBase := '';
  sObj := '';
  sName := '';
  if ABaseField <> '' then begin
    sBase := CnvMetaValue(ARow.GetData(ABaseField));
    sName := sBase;
  end;
  if AObjField <> '' then begin
    sObj := CnvMetaValue(ARow.GetData(AObjField));
    sName := sObj;
  end;
  if not AFullName then begin
    Result := EncodeObjectName('', '', '', sName);
    if AList.IndexOf(Result) >= 0 then
      Result := '';
  end;
  if Result = '' then
    Result := EncodeObjectName(
      CnvMetaValue(ARow.GetData('CATALOG_NAME'), ACatalogName),
      CnvMetaValue(ARow.GetData('SCHEMA_NAME'), ASchemaName),
      sBase, sObj);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetTableNames(const ACatalogName, ASchemaName,
  APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes;
  AKinds: TADPhysTableKinds; AFullName: Boolean);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
  oConn: TADCustomConnection;
begin
  oConn := ADManager.AcquireConnection(Self, Name);
  try
    oConnMeta := GetConnectionMetadata(True);
    oView := oConnMeta.GetTables(AScopes, AKinds, ACatalogName, ASchemaName, APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do
        AList.Add(EncodeListName(ACatalogName, ASchemaName, '', 'TABLE_NAME',
          oView.Rows[i], AList, AFullName));
    finally
      AList.EndUpdate;
      ADFree(oView.Table);
    end;
  finally
    ADManager.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetPackageNames(const ACatalogName, ASchemaName,
  APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes; AFullName: Boolean);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
  oConn: TADCustomConnection;
begin
  oConn := ADManager.AcquireConnection(Self, Name);
  try
    oConnMeta := GetConnectionMetadata(True);
    oView := oConnMeta.GetPackages(AScopes, ACatalogName, ASchemaName, APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do
        AList.Add(EncodeListName(ACatalogName, ASchemaName, 'PACKAGE_NAME', '',
          oView.Rows[i], AList, AFullName));
    finally
      AList.EndUpdate;
      ADFree(oView.Table);
    end;
  finally
    ADManager.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetStoredProcNames(const ACatalogName, ASchemaName,
  APackage, APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes;
  AFullName: Boolean);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
  s: String;
  oConn: TADCustomConnection;
begin
  oConn := ADManager.AcquireConnection(Self, Name);
  try
    oConnMeta := GetConnectionMetadata(True);
    if APackage = '' then
      oView := oConnMeta.GetProcs(AScopes, ACatalogName, ASchemaName, APattern)
    else
      oView := oConnMeta.GetPackageProcs(ACatalogName, ASchemaName, APackage, APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do begin
        if APackage <> '' then
          s := CnvMetaValue(oView.Rows[i].GetData('PROC_NAME'))
        else
          s := EncodeListName(ACatalogName, ASchemaName, '', 'PROC_NAME',
            oView.Rows[i], AList, AFullName);
        AList.Add(s);
      end;
    finally
      AList.EndUpdate;
      if APackage = '' then
        ADFree(oView.Table)
      else
        ADClearMetaView(oView, FetchOptions);
    end;
  finally
    ADManager.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.GetGeneratorNames(const ACatalogName, ASchemaName,
  APattern: string; AList: TStrings; AScopes: TADPhysObjectScopes; AFullName: Boolean);
var
  oConnMeta: IADPhysConnectionMetadata;
  oView: TADDatSView;
  i: Integer;
  oConn: TADCustomConnection;
begin
  oConn := ADManager.AcquireConnection(Self, Name);
  try
    oConnMeta := GetConnectionMetadata(True);
    oView := oConnMeta.GetGenerators(AScopes, ACatalogName, ASchemaName, APattern);
    AList.BeginUpdate;
    try
      AList.Clear;
      for i := 0 to oView.Rows.Count - 1 do
        AList.Add(EncodeListName(ACatalogName, ASchemaName, '', 'GENERATOR_NAME',
          oView.Rows[i], AList, AFullName));
    finally
      AList.EndUpdate;
      ADFree(oView.Table);
    end;
  finally
    ADManager.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.RefreshMetadataCache(const AObjName: String = '');
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  if Connected then begin
    oConnMeta := GetConnectionMetadata(False);
    oConnMeta.RefreshMetadataCache(AObjName);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.ApplyUpdates(const ADataSets: array of TADDataSet);
var
  i: Integer;
  oDS: TADDataSet;
  oConn: TADCustomConnection;
begin
  StartTransaction;
  try
    for i := Low(ADataSets) to High(ADataSets) do begin
      oDS := ADataSets[i];
      if oDS is TADAdaptedDataSet then begin
        oConn := TADAdaptedDataSet(oDS).GetConnection(False);
        if (oConn <> nil) and (oConn <> Self) then
          ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntConnNotMatch, []);
      end;
      oDS.ApplyUpdates;
    end;
    Commit;
  except
    Rollback;
    raise;
  end;
  for i := Low(ADataSets) to High(ADataSets) do
    ADataSets[i].CommitUpdates;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetName: TComponentName;
begin
  if Name = '' then
    Result := '$' + IntToHex(Integer(Self), 8)
  else
    Result := Name;
  Result := Result + ': ' + ClassName;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetParent: IADStanObject;
begin
  Result := ADManager as IADStanObject;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetLastAutoGenValue(const AName: String): Variant;
begin
  CheckActive;
  Result := ConnectionIntf.GetLastAutoGenValue(AName);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetMessages: EADDBEngineException;
begin
  if ConnectionIntf <> nil then
    Result := ConnectionIntf.Messages
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.BaseCreateSQL: IADPhysCommand;
var
  oFtch: TADFetchOptions;
  oRes: TADResourceOptions;
begin
  CheckActive;
  if FExecSQLCommand = nil then begin
    FConnectionIntf.CreateCommand(Result);

    oFtch := Result.Options.FetchOptions;
    oFtch.RowsetSize := 1;
    oFtch.Items := oFtch.Items - [fiMeta];
    oFtch.AutoClose := True;
    oFtch.AutoFetchAll := afAll;
    oFtch.RecordCountMode := cmVisible;
    oFtch.Mode := fmOnDemand;

    oRes := Result.Options.ResourceOptions;
    if oRes.CmdExecMode = amAsync then
      oRes.CmdExecMode := amBlocking;
    oRes.DirectExecute := True;
    oRes.ParamCreate := True;
    oRes.ParamExpand := True;
    oRes.Persistent := False;

    Result.ErrorHandler := Self as IADStanErrorHandler;
    if FExecSQLCommand = nil then
      FExecSQLCommand := Result;
  end
  else
    Result := FExecSQLCommand;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.BasePrepareSQL(const ACommand: IADPhysCommand; const ASQL: String;
  const AParams: array of Variant; const ATypes: array of TFieldType): Boolean;
var
  i: Integer;
begin
  Result := False;
  if High(AParams) >= Low(AParams) then begin
    if ASQL <> '' then begin
      ACommand.CommandKind := skUnknown;
      ACommand.CommandText := ASQL;
    end;
    for i := Low(ATypes) to High(ATypes) do
      if ATypes[i] <> ftUnknown then
        ACommand.Params[i].DataType := ATypes[i];
    for i := Low(AParams) to High(AParams) do
      ACommand.Params[i].Value := AParams[i];
    if ACommand.State = csInactive then begin
      Result := True;
      ACommand.Prepare();
    end;
  end
  else if (ACommand.CommandText <> ASQL) and (ASQL <> '') then begin
    Result := True;
    ACommand.CommandKind := skUnknown;
    ACommand.Prepare(ASQL);
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.ExecSQL(const ASQL: String; const AParams: array of Variant;
  const ATypes: array of TFieldType): LongInt;
var
  oCmd: IADPhysCommand;
begin
  oCmd := BaseCreateSQL;
  try
    BasePrepareSQL(oCmd, ASQL, AParams, ATypes);
    oCmd.Execute();
    Result := oCmd.RowsAffected;
  finally
    oCmd.AbortJob(True);
    oCmd.CloseAll;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.ExecSQL(const ASQL: String): LongInt;
begin
  Result := ExecSQL(ASQL, [], []);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.ExecSQL(const ASQL: String; const AParams: array of Variant): LongInt;
begin
  Result := ExecSQL(ASQL, AParams, []);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.ExecSQLScalar(const ASQL: String;
  const AParams: array of Variant; const ATypes: array of TFieldType): Variant;
var
  oCmd: IADPhysCommand;
begin
  oCmd := BaseCreateSQL;
  try
    if BasePrepareSQL(oCmd, ASQL, AParams, ATypes) or (FExecSQLTab = nil) then begin
      ADFree(FExecSQLTab);
      FExecSQLTab := oCmd.Define;
    end;
    oCmd.Open;
    oCmd.Fetch(FExecSQLTab);
    if (FExecSQLTab.Rows.Count > 0) and (FExecSQLTab.Columns.Count > 0) then
      Result := FExecSQLTab.Rows[0].GetData(0)
    else
      Result := Unassigned;
  finally
    if FExecSQLTab <> nil then
      FExecSQLTab.Clear;
    oCmd.AbortJob(True);
    oCmd.CloseAll;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.ExecSQLScalar(const ASQL: String): Variant;
begin
  Result := ExecSQLScalar(ASQL, [], []);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.ExecSQLScalar(const ASQL: String;
  const AParams: array of Variant): Variant;
begin
  Result := ExecSQLScalar(ASQL, AParams, []);
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetCliObj: Pointer;
begin
  CheckActive;
  Result := ConnectionIntf.CliObj;
end;

{-------------------------------------------------------------------------------}
function TADCustomConnection.GetCliHandle: Pointer;
begin
  CheckActive;
  Result := ConnectionIntf.CliHandle;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetSharedCliHandle(const AValue: Pointer);
begin
  if SharedCliHandle <> AValue then begin
    CheckInactive;
    FSharedCliHandle := AValue;
    DriverName := ADPhysManager.DriverIDFromSharedCliHandle(AValue);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetTransaction(const AValue: TADCustomTransaction);
begin
  if FTransaction <> AValue then begin
    FTransaction := AValue;
    if FTransaction <> nil then begin
      FTransaction.FreeNotification(Self);
      if ConnectionIntf <> nil then
        ConnectionIntf.Transaction := FTransaction.TransactionIntf;
    end
    else begin
      if ConnectionIntf <> nil then begin
        ConnectionIntf.Transaction := nil;
        AcquireDefaultTransaction(ConnectionIntf);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomConnection.SetUpdateTransaction(const AValue: TADCustomTransaction);
begin
  if FUpdateTransaction <> AValue then begin
    FUpdateTransaction := AValue;
    if FUpdateTransaction <> nil then
      FUpdateTransaction.FreeNotification(Self);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADCustomTransaction                                                          }
{-------------------------------------------------------------------------------}
constructor TADCustomTransaction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOptionsIntf := TADTxOptions.Create;
  FDataSets := TADObjList.Create;
  if ADIsDesigning(Self) then
    Connection := ADFindDefaultConnection(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADCustomTransaction.Destroy;
begin
  Destroying;
  Connection := nil;
  inherited Destroy;
  ADFreeAndNil(FOptionsIntf);
  ADFreeAndNil(FDataSets);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if AOperation = opRemove then
    if AComponent = Connection then
      Connection := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.SetConnection(const AValue: TADCustomConnection);
begin
  if FConnection <> AValue then begin
    if FConnection <> nil then begin
      InternalDeleteTxIntf;
      FConnection.UnRegisterClient(Self);
    end;
    FConnection := AValue;
    if FConnection <> nil then begin
      FConnection.RegisterClient(Self, DoConnectChanged);
      FConnection.FreeNotification(Self);
      if FConnection.Connected then
        InternalCreateTxIntf;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.DoConnectChanged(Sender: TObject; Connecting: Boolean);
begin
  if Connecting then
    InternalCreateTxIntf
  else
    InternalDeleteTxIntf;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.SetOptions(const AValue: TADTxOptions);
begin
  FOptionsIntf.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomTransaction.GetActive: Boolean;
begin
  Result := (FTransactionIntf <> nil) and FTransactionIntf.Active;
end;

{-------------------------------------------------------------------------------}
function TADCustomTransaction.GetDataSetCount: Integer;
begin
  Result := FDataSets.Count;
end;

{-------------------------------------------------------------------------------}
function TADCustomTransaction.GetDataSets(AIndex: Integer): TADDataSet;
begin
  Result := TADDataSet(FDataSets[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.InternalCreateTxIntf;
begin
  if FTransactionIntf = nil then begin
    Connection.ConnectionIntf.CreateTransaction(FTransactionIntf);
    FTransactionIntf.Options.Assign(FOptionsIntf);
    FTransactionIntf.AddStateHandler(Self);
    ADFree(FOptionsIntf);
    FOptionsIntf := FTransactionIntf.Options;
    if Connection.Transaction = Self then
      Connection.ConnectionIntf.Transaction := FTransactionIntf;
    FSerialID := 0;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.InternalDeleteTxIntf;
var
  i: Integer;
begin
  HandleDisconnectCommands(nil, dmRelease);
  if FTransactionIntf <> nil then begin
    if (FTransactionIntf.State = tsActive) and (FSerialID = FTransactionIntf.SerialID) then
      if FNestingLevel = FTransactionIntf.NestingLevel then
        FTransactionIntf.Disconnect
      else begin
        for i := FNestingLevel downto 1 do
          if Active then
            case Options.DisconnectAction of
            xdCommit:   Commit;
            xdRollback: Rollback;
            end;
      end;
    if (Connection <> nil) and (Connection.ConnectionIntf <> nil) and
       (Connection.ConnectionIntf.Transaction = FTransactionIntf) and
       Connection.ConnectionMetaDataIntf.TxMultiple then begin
      Connection.ConnectionIntf.Transaction := nil;
      Connection.AcquireDefaultTransaction(Connection.ConnectionIntf);
    end;
    FOptionsIntf := TADTxOptions.Create;
    FOptionsIntf.Assign(FTransactionIntf.Options);
    FTransactionIntf.RemoveStateHandler(Self);
    FTransactionIntf := nil;
    FSerialID := 0;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.StartTransaction;
begin
  if FNestingLevel = 0 then
    ADManager.AcquireConnection(FConnection, Name);
  try
    FConnection.CheckActive;
    ASSERT(FTransactionIntf <> nil);
    FTransactionIntf.StartTransaction;
  except
    if FNestingLevel = 0 then
      ADManager.ReleaseConnection(FConnection);
    raise;
  end;
  Inc(FNestingLevel);
  FSerialID := FTransactionIntf.SerialID;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.CheckConnected;
begin
  if Connection = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbNotDefined, [Name]);
  if not FConnection.Connected then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDbMBActive, [Name]);
  ASSERT(FTransactionIntf <> nil);
end;

{-------------------------------------------------------------------------------}
function TADCustomTransaction.CheckActive: Boolean;
begin
  CheckConnected;
  if not FTransactionIntf.Active then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntTxMBActive, [Name]);
  Result := FSerialID = FTransactionIntf.SerialID;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.CheckReleased(ARetaining, AMyTrans: Boolean);
begin
  // if retaining, then just sync local field to Phys Layer value
  if ARetaining then
    FNestingLevel := FTransactionIntf.NestingLevel
  // if finishing, then if Phys Layer TX finished or Comp Layer is finishing,
  // then release connection objects
  else if (FTransactionIntf = nil) or (FTransactionIntf.NestingLevel = 0) or
          (FNestingLevel = 1) then begin
    ADManager.ReleaseConnection(FConnection);
    FNestingLevel := 0;
  end
  // sync local field to Phys Layer value
  else if FNestingLevel > 0 then begin
    FNestingLevel := FTransactionIntf.NestingLevel;
    if FNestingLevel > 0 then
      Dec(FNestingLevel);
  end;
  if AMyTrans then
    FSerialID := FTransactionIntf.SerialID
  else
    FSerialID := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.Commit;
var
  lMyTrans: Boolean;
begin
  lMyTrans := CheckActive;
  try
    FTransactionIntf.Commit;
  finally
    CheckReleased(False, lMyTrans);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.CommitRetaining;
var
  lMyTrans: Boolean;
begin
  lMyTrans := CheckActive;
  try
    FTransactionIntf.CommitRetaining;
  finally
    CheckReleased(True, lMyTrans);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.Rollback;
var
  lMyTrans: Boolean;
begin
  lMyTrans := CheckActive;
  try
    FTransactionIntf.Rollback;
  finally
    CheckReleased(False, lMyTrans);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.RollbackRetaining;
var
  lMyTrans: Boolean;
begin
  lMyTrans := CheckActive;
  try
    FTransactionIntf.RollbackRetaining;
  finally
    CheckReleased(True, lMyTrans);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.HandleDisconnectCommands(AFilter: TADPhysDisconnectFilter;
  AMode: TADPhysDisconnectMode);
var
  i: Integer;
  oDS: TADRdbmsDataSet;
begin
  for i := DataSetCount - 1 downto 0 do
    if (i < DataSetCount) and (DataSets[i] is TADRdbmsDataSet) then begin
      oDS := TADRdbmsDataSet(DataSets[i]);
      if (oDS.Command.CommandIntf <> nil) and
         (not Assigned(AFilter) or AFilter(oDS.Command.CommandIntf.CliObj)) then
        case AMode of
        dmOffline: oDS.Offline;
        dmRelease: oDS.Release;
        end
      else
        if (AMode = dmRelease) and
           not ((TransactionIntf <> nil) and
                (TransactionIntf.State in [tsStarting, tsCommiting, tsRollingback])) then
          oDS.Cancel;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTransaction.HandleTxOperation(AOperation: TADPhysTransactionState;
  ABefore: Boolean);
begin
  case AOperation of
  tsActive:
    if ABefore then begin
      if Assigned(BeforeStartTransaction) then
        BeforeStartTransaction(Self);
    end
    else begin
      if Assigned(AfterStartTransaction) then
        AfterStartTransaction(Self);
    end;
  tsCommiting:
    if ABefore then begin
      if Assigned(BeforeCommit) then
        BeforeCommit(Self);
    end
    else begin
      if Assigned(AfterCommit) then
        AfterCommit(Self);
    end;
  tsRollingback:
    if ABefore then begin
      if Assigned(BeforeRollback) then
        BeforeRollback(Self);
    end
    else begin
      if Assigned(AfterRollback) then
        AfterRollback(Self);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADCustomEventAlerter                                                         }
{-------------------------------------------------------------------------------}
constructor TADCustomEventAlerter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FNames := TADStringList.Create;
  TADStringList(FNames).OnChange := DoNamesChanged;
  FOptionsIntf := TADEventAlerterOptions.Create;
  if ADIsDesigning(Self) then
    Connection := ADFindDefaultConnection(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADCustomEventAlerter.Destroy;
begin
  Destroying;
  Connection := nil;
  inherited Destroy;
  ADFreeAndNil(FOptionsIntf);
  ADFreeAndNil(FNames);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if AOperation = opRemove then
    if AComponent = Connection then
      Connection := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.Loaded;
begin
  inherited Loaded;
  try
    if FStreamedActive then
      SetActive(True);
  except
    if csDesigning in ComponentState then
      ADHandleException
    else
      raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.CheckAutoRegister;
begin
  if not (csDestroying in ComponentState) and
     Options.AutoRegister and (Names.Count > 0) and
     (Connection <> nil) and Connection.Connected then
    Register;
end;

{-------------------------------------------------------------------------------}
function TADCustomEventAlerter.GetActive: Boolean;
begin
  Result := (FEventAlerterIntf <> nil) and
    (FEventAlerterIntf.State in [esRegistered, esFiring]);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.SetActive(const AValue: Boolean);
begin
  if csReading in ComponentState then
    FStreamedActive := AValue
  else if Active <> AValue then
    if AValue then
      Register
    else
      Unregister;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.SetConnection(const AValue: TADCustomConnection);
begin
  if FConnection <> AValue then begin
    if FConnection <> nil then begin
      Unregister;
      FConnection.UnRegisterClient(Self);
    end;
    FConnection := AValue;
    if FConnection <> nil then begin
      FConnection.RegisterClient(Self, DoConnectChanged);
      FConnection.FreeNotification(Self);
      CheckAutoRegister;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.DoConnectChanged(Sender: TObject; Connecting: Boolean);
begin
  if Connecting then
    CheckAutoRegister
  else
    Unregister;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.DoNamesChanged(ASender: TObject);
begin
  Unregister;
  CheckAutoRegister;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.SetNames(const AValue: TStrings);
begin
  FNames.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.SetOptions(const AValue: TADEventAlerterOptions);
begin
  FOptionsIntf.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.HandleEvent(const AEventName: String;
  const AArgument: Variant);
begin
  if Assigned(FOnAlert) then
    FOnAlert(Self, AEventName, AArgument);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.HandleTimeout(var AContinue: Boolean);
begin
  if Assigned(FOnTimeout) then
    FOnTimeout(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.Register;
begin
  if Active then
    Exit;
  ADManager.AcquireConnection(FConnection, Name);
  try
    Connection.CheckActive;
    Connection.ConnectionIntf.CreateEvent(Options.Kind, FEventAlerterIntf);
    FEventAlerterIntf.Options := FOptionsIntf;
    FEventAlerterIntf.Names := FNames;
    FEventAlerterIntf.Handler := Self as IADPhysEventHandler;
    FEventAlerterIntf.Register;
  except
    ADManager.ReleaseConnection(FConnection);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.Unregister;
begin
  if not Active then
    Exit;
  FEventAlerterIntf.Options := nil;
  FEventAlerterIntf.Handler := nil;
  FEventAlerterIntf.Unregister;
  FEventAlerterIntf := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomEventAlerter.Signal(const AEvent: String;
  const AArgument: Variant);
begin
  Register;
  FEventAlerterIntf.Signal(AEvent, AArgument);
end;

{-------------------------------------------------------------------------------}
{ TADCustomCommand                                                              }
{-------------------------------------------------------------------------------}
constructor TADCustomCommand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnableParamsStorage := True;
  SetOptionsIntf(nil);
  FCommandText := TADStringList.Create;
  TADStringList(FCommandText).OnChanging := DoSQLChanging;
  TADStringList(FCommandText).OnChange := DoSQLChange;
  FMacros := TADMacros.CreateRefCounted(GetParamsOwner);
  FMacros.OnChanged := MacrosChanged;
  FParams := TADParams.CreateRefCounted(GetParamsOwner);
  FRowsAffected := -1;
  FActiveStoredUsage := [auDesignTime, auRunTime];
  if ADIsDesigning(Self) then
    Connection := ADFindDefaultConnection(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADCustomCommand.Destroy;
begin
  Destroying;
  Disconnect(True);
  Transaction := nil;
  inherited Destroy;
  FParams.RemRef;
  FParams := nil;
  FMacros.RemRef;
  FMacros := nil;
  if FOptionsIntf <> nil then begin
    FOptionsIntf.ObjectDestroyed(Self);
    FOptionsIntf := nil;
  end;
  ADFreeAndNil(FCommandText);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetParamsOwner: TPersistent;
begin
  if FOwner <> nil then
    Result := FOwner
  else
    Result := Self;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetDisplayName: String;
begin
  if FOwner <> nil then
    Result := FOwner.Name
  else
    Result := GetName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.PropertyChange;
begin
  if (FOwner <> nil) and (FOwner is TADAdaptedDataSet) and
     not (csDestroying in FOwner.ComponentState) then
    TADAdaptedDataSet(FOwner).DataEvent(dePropertyChange, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Loaded;
begin
  inherited Loaded;
  try
    if DoStoredActivation then begin
      if FStreamedPrepared then
        SetPrepared(True);
      if FStreamedActive then
        SetActive(True);
    end;
  except
    if csDesigning in ComponentState then
      ADHandleException
    else
      raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if AOperation = opRemove then
    if AComponent = FConnection then
      SetConnection(nil)
    else if AComponent = FTransaction then
      SetTransaction(nil);
  inherited Notification(AComponent, AOperation);
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR_Comp}
procedure TADCustomCommand.Trace(AStep: TADMoniEventStep;
  const AMsg: String; const AArgs: array of const);
begin
  if FConnection <> nil then
    FConnection.Trace(AStep, Self, AMsg, AArgs);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADCustomCommand.CheckComponentState(AState: TComponentState): Boolean;
begin
  Result := (AState * ComponentState <> []) or
    (FOwner <> nil) and (AState * FOwner.ComponentState <> []);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CheckInactive;
begin
  if Active then
    if CheckComponentState([csDesigning]) then
      CloseAll
    else
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntAdaptMBInactive,
        [GetDisplayName]);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CheckActive;
begin
  if not Active then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntAdaptMBActive,
      [GetDisplayName]);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CheckUnprepared;
begin
  CheckInactive;
  Prepared := False;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CheckAsyncProgress;
begin
  if CommandIntf <> nil then
    CommandIntf.CheckAsyncProgress;
  if (FOwner <> nil) and (FOwner.State = dsOpening) and
     ((FThreadID = TADThreadID(0)) or (FThreadID <> GetCurrentThreadId())) then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_AccAsyncOperInProgress, []);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CheckPrepared;
begin
  CheckAsyncProgress;
  Prepared := True;
end;

{-------------------------------------------------------------------------------}
// IADStanOptions

procedure TADCustomCommand.GetParentOptions(out AOpts: IADStanOptions);
var
  oConn: TADCustomConnection;
begin
  if FConnection <> nil then
    AOpts := FConnection.OptionsIntf
  else begin
    oConn := GetConnection(False);
    if oConn <> nil then
      AOpts := oConn.OptionsIntf;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetOptionsIntf(const AValue: IADStanOptions);
begin
  if (FOptionsIntf <> AValue) or (FOptionsIntf = nil) and (AValue = nil) then begin
    FOptionsIntf := AValue;
    if FOptionsIntf = nil then
      FOptionsIntf := TADOptionsContainer.Create(Self, TADFetchOptions,
        TADBottomUpdateOptions, TADBottomResourceOptions, GetParentOptions);
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetFetchOptions: TADFetchOptions;
begin
  Result := FOptionsIntf.FetchOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetFetchOptions(const AValue: TADFetchOptions);
begin
  FOptionsIntf.FetchOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetFormatOptions: TADFormatOptions;
begin
  Result := FOptionsIntf.FormatOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetFormatOptions(const AValue: TADFormatOptions);
begin
  FOptionsIntf.FormatOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetUpdateOptions: TADBottomUpdateOptions;
begin
  Result := TADBottomUpdateOptions(FOptionsIntf.UpdateOptions);
  ASSERT((Result <> nil) and (Result is TADBottomUpdateOptions));
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetUpdateOptions(const AValue: TADBottomUpdateOptions);
begin
  FOptionsIntf.UpdateOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetResourceOptions: TADBottomResourceOptions;
begin
  Result := TADBottomResourceOptions(FOptionsIntf.ResourceOptions);
  ASSERT((Result <> nil) and (Result is TADBottomResourceOptions));
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetResourceOptions(const AValue: TADBottomResourceOptions);
begin
  FOptionsIntf.ResourceOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
// Other

function TADCustomCommand.GetConnection(ACheck: Boolean): TADCustomConnection;
begin
  if FConnection <> nil then
    Result := FConnection
  else begin
    Result := ADManager.FindConnection(ConnectionName);
    if (Result = nil) and ACheck then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDBNotFound,
        [ConnectionName, GetDisplayName]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetConnection(const AValue: TADCustomConnection);
begin
  if FConnection <> AValue then begin
    CheckUnprepared;
    FConnection := AValue;
    if FConnection <> nil then begin
      FConnection.FreeNotification(Self);
      FConnectionName := FConnection.ConnectionName;
      FBindedBy := bbObject;
    end
    else begin
      FConnectionName := '';
      FBindedBy := bbNone;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetConnectionName(const AValue: String);
begin
  if FConnectionName <> AValue then begin
    CheckUnprepared;
    FConnectionName := AValue;
    FConnection := nil;
    FBindedBy := bbName;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.IsCNNS: Boolean;
begin
  Result := (FBindedBy = bbName);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.IsCNS: Boolean;
begin
  Result := (FBindedBy = bbObject);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetTransaction(const AValue: TADCustomTransaction);
begin
  if FTransaction <> AValue then begin
    CheckUnprepared;
    if FTransaction <> nil then
      if FOwner <> nil then
        FTransaction.FDataSets.Remove(FOwner);
    FTransaction := AValue;
    if FTransaction <> nil then begin
      FTransaction.FreeNotification(Self);
      if FOwner <> nil then
        FTransaction.FDataSets.Add(FOwner);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.AcquireConnection: TADCustomConnection;
begin
  if FBindedBy = bbObject then
    Result := ADManager.AcquireConnection(FConnection, GetDisplayName)
  else
    Result := ADManager.AcquireConnection(ConnectionName, GetDisplayName);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.ReleaseConnection(var AConnection: TADCustomConnection);
begin
  ADManager.ReleaseConnection(AConnection);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalCreateCommandIntf;
begin
  FConnection.ConnectionIntf.CreateCommand(FCommandIntf);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.HandleFinished(const AInitiator: IADStanObject;
  AState: TADStanAsyncState; AException: Exception);
var
  oFinished: TADOperationFinishedEvent;
begin
  if Assigned(FOperationFinished) then begin
    oFinished := FOperationFinished;
    FOperationFinished := nil;
    FThreadID := GetCurrentThreadId();
    try
      oFinished(Self, AState, AException);
    finally
      FThreadID := 0;
      // an interface releasing is deferred in the TADCustomCommand.SetPrepared
      // until an operation finish handler will fire
      if (FCommandIntf <> nil) and (FCommandIntf.State = csInactive) then begin
        FCommandIntf := nil;
        InternalCloseConnection;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.HandleUnprepare;
begin
  if ckPrepare in FFlags then
    Exit;
  if (CommandIntf <> nil) and (FRowsAffected = 0) and (CommandIntf.RowsAffected > 0) then
    FRowsAffected := CommandIntf.RowsAffected;
  Unprepare;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoBeforePrepare;
begin
  if Assigned(FBeforePrepare) then
    FBeforePrepare(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoAfterPrepare;
begin
  if Assigned(FAfterPrepare) then
    FAfterPrepare(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoBeforeUnprepare;
begin
  if Assigned(FBeforeUnprepare) then
    FBeforeUnprepare(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoAfterUnprepare;
begin
  if Assigned(FAfterUnprepare) then
    FAfterUnprepare(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalPrepare;
begin
  if Transaction <> nil then begin
    Transaction.CheckConnected;
    CommandIntf.Transaction := Transaction.TransactionIntf;
  end;
  CommandIntf.StateHandler := Self as IADPhysCommandStateHandler;
  CommandIntf.ErrorHandler := Self as IADStanErrorHandler;
  CommandIntf.Options := Self as IADStanOptions;
  if FFixedCommandKind then
    CommandIntf.CommandKind := FCommandKind;
  CommandIntf.CatalogName := FCatalogName;
  CommandIntf.SchemaName := FSchemaName;
  CommandIntf.BaseObjectName := FBaseObjectName;
  CommandIntf.Overload := FOverload;
  CommandIntf.Macros := FMacros;
  if (FCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs]) and
     (fiMeta in CommandIntf.Options.FetchOptions.Items) and not (ckCreateIntfDontPrepare in FFlags) then begin
    CommandIntf.Prepare(FCommandText.Text);
    if CommandIntf.Params <> FParams then begin
      CommandIntf.Params.AssignValues(FParams);
      FParams.Assign(CommandIntf.Params);
      CommandIntf.Params := FParams;
    end;
  end
  else begin
    CommandIntf.Params := FParams;
    if not (ckCreateIntfDontPrepare in FFlags) then
      CommandIntf.Prepare(FCommandText.Text, False)
    else
      CommandIntf.CommandText := FCommandText.Text;
  end;
  FRowsAffected := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalUnprepare;
begin
  if CommandIntf.State = csOpen then
    CommandIntf.CloseAll;
  if CommandIntf.State = csPrepared then
    CommandIntf.Unprepare;
  // Do not clear StateHandler, while we are inside of operation
  if not Assigned(FOperationFinished) then
    CommandIntf.StateHandler := nil;
  CommandIntf.ErrorHandler := nil;
  // Do not clear Options, it is refcounted now
  // CommandIntf.Options := nil;
  CommandIntf.Params := nil;
  CommandIntf.Macros := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalCloseConnection;
var
  oConn: TADCustomConnection;
begin
  oConn := FConnection;
  if FBindedBy <> bbObject then
    FConnection := nil;
  ReleaseConnection(oConn);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetPrepared: Boolean;
begin
  Result := (CommandIntf <> nil) and (CommandIntf.State <> csInactive);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.DoStoredActivation: Boolean;
var
  eUsage: TADStoredActivationUsage;
begin
  eUsage := ADManager.ActiveStoredUsage;
  if GetConnection(False) <> nil then
    eUsage := eUsage * GetConnection(False).ConnectedStoredUsage;
  Result := ADCheckStoredUsage(ComponentState, eUsage * ActiveStoredUsage);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetPrepared(const AValue: Boolean);
var
  oObjIntf: IADStanObject;
{$IFDEF AnyDAC_MONITOR_Comp}
  oConn: TADCustomConnection;
{$ENDIF}
begin
  if csReading in ComponentState then
    FStreamedPrepared := AValue
  else if not (ckPrepare in FFlags) and ((Prepared <> AValue) or
               not AValue and (CommandIntf <> nil) and (CommandIntf.Connection.State <> csRecovering)) then begin
    Include(FFlags, ckPrepare);
    try
      if AValue then begin
        DoBeforePrepare;
        FConnection := AcquireConnection;
{$IFDEF AnyDAC_MONITOR_Comp}
        Trace(esStart, 'TADCustomCommand.Prepare', ['Command', CommandText.Text]);
        try
          try
{$ENDIF}
            try
              FConnection.CheckActive;
              InternalCreateCommandIntf;
              try
                if Supports(CommandIntf, IADStanObject, oObjIntf) then begin
                  if FOwner <> nil then
                    oObjIntf.SetOwner(FOwner, '')
                  else
                    oObjIntf.SetOwner(Self, '');
                  oObjIntf := nil;
                end;
                InternalPrepare;
              except
                InternalUnprepare;
                FCommandIntf := nil;
                raise;
              end;
            except
              InternalCloseConnection;
              raise;
            end;
            FConnection.AttachClient(Self);
{$IFDEF AnyDAC_MONITOR_Comp}
          except
            on E: Exception do begin
              Trace(esProgress, 'TADCustomCommand.Prepare - Exception',
                ['Class', E.ClassName, 'Msg', E.Message]);
              raise;
            end;
          end;
        finally
          Trace(esEnd, 'TADCustomCommand.Prepare', ['Command', CommandText.Text]);
        end;
{$ENDIF}
        DoAfterPrepare;
      end
      else begin
        CheckAsyncProgress;
        DoBeforeUnprepare;
{$IFDEF AnyDAC_MONITOR_Comp}
        oConn := FConnection;
        Trace(esStart, 'TADCustomCommand.Unprepare', ['Command', CommandText.Text]);
        try
          try
{$ENDIF}
            if FConnection <> nil then
              FConnection.DetachClient(Self);
            try
              if FOwner <> nil then
                FOwner.Offline;
              InternalUnprepare;
            finally
              // defer interface releasing to the operation finish handler
              if not Assigned(FOperationFinished) then begin
                FCommandIntf := nil;
                InternalCloseConnection;
              end;
              if (FTableAdapter <> nil) and (FTableAdapter.SelectCommand = Self) then
                FTableAdapter.Reset;
            end;
{$IFDEF AnyDAC_MONITOR_Comp}
          except
            on E: Exception do begin
              if oConn <> nil then
                oConn.Trace(esProgress, Self, 'TADCustomCommand.Unprepare - Exception',
                  ['Class', E.ClassName, 'Msg', E.Message]);
              raise;
            end;
          end;
        finally
          if oConn <> nil then
            oConn.Trace(esEnd, Self, 'TADCustomCommand.Unprepare',
              ['Command', CommandText.Text]);
        end;
{$ENDIF}
        DoAfterUnprepare;
      end;
      PropertyChange;
    finally
      Exclude(FFlags, ckPrepare);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.IsPS: Boolean;
begin
  Result := Prepared and not Active;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Prepare(const ACommandText: String = '');
begin
  if ACommandText <> '' then
    SetCommandText(ACommandText, False);
  Prepared := True;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Unprepare;
begin
  Prepared := False;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoBeforeOpen;
begin
  if Assigned(FBeforeOpen) then
    FBeforeOpen(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoAfterOpen;
begin
  if Assigned(FAfterOpen) then
    FAfterOpen(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoBeforeClose;
begin
  if Assigned(FBeforeClose) then
    FBeforeClose(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoAfterClose;
begin
  if Assigned(FAfterClose) then
    FAfterClose(self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalClose(AAll: Boolean);
begin
  if not Active then
    Exit;
{$IFDEF AnyDAC_MONITOR_Comp}
  Trace(esStart, 'TADCustomCommand.InternalClose',
    ['Command', CommandText.Text, 'AAll', AAll]);
  try
    try
{$ENDIF}
      if AAll then
        CommandIntf.CloseAll
      else
        CommandIntf.Close;
{$IFDEF AnyDAC_MONITOR_Comp}
    except
      on E: Exception do begin
        Trace(esProgress, 'TADCustomCommand.InternalClose - Exception',
          ['Class', E.ClassName, 'Msg', E.Message]);
        raise;
      end;
    end;
  finally
    Trace(esEnd, 'TADCustomCommand.InternalClose',
      ['Command', CommandText.Text, 'AAll', AAll]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalOpenFinished(ASender: TObject;
  AState: TADStanAsyncState; AException: Exception);
begin
{$IFDEF AnyDAC_MONITOR_Comp}
  if AException <> nil then
    Trace(esProgress, 'TADCustomCommand.InternalOpenFinished - Exception',
      ['Class', AException.ClassName, 'Msg', AException.Message]);
  Trace(esProgress, 'TADCustomCommand.InternalOpenFinished',
    ['Command', CommandText.Text, 'AState', Integer(AState)]);
{$ENDIF}
  if AState = asFinished then begin
    DoAfterOpen;
    if FOwner <> nil then
      TADAdaptedDataSet(FOwner).CheckAsyncOpenComplete;
  end
  else if AState in [asFailed, asAborted, asExpired] then begin
    if FOwner <> nil then
      TADAdaptedDataSet(FOwner).CheckAsyncOpenFailed;
  end;
end;

procedure TADCustomCommand.InternalOpen(ABlocked: Boolean);
begin
  if Active then
    Exit;
{$IFDEF AnyDAC_MONITOR_Comp}
  Trace(esStart, 'TADCustomCommand.InternalOpen',
    ['Command', CommandText.Text, 'ABlocked', ABlocked]);
  try
    try
{$ENDIF}
      FOperationFinished := InternalOpenFinished;
      CommandIntf.Open(ABlocked);
{$IFDEF AnyDAC_MONITOR_Comp}
    except
      on E: Exception do begin
        Trace(esProgress, 'TADCustomCommand.InternalOpen - Exception',
          ['Class', E.ClassName, 'Msg', E.Message]);
        raise;
      end;
    end;
  finally
    Trace(esEnd, 'TADCustomCommand.InternalOpen',
      ['Command', CommandText.Text, 'ABlocked', ABlocked]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetActive: Boolean;
begin
  Result := Prepared and (CommandIntf.State = csOpen);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetActiveBase(const AValue, ABlocked: Boolean);
begin
  if csReading in ComponentState then
    FStreamedActive := AValue
  else if Active <> AValue then
    if AValue then begin
      CheckPrepared;
      DoBeforeOpen;
      InternalOpen(ABlocked);
    end
    else begin
      CheckAsyncProgress;
      DoBeforeClose;
      InternalClose(False);
      DoAfterClose;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetActive(const AValue: Boolean);
begin
  SetActiveBase(AValue, False);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Open(ABlocked: Boolean = False);
begin
  SetActiveBase(True, ABlocked);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.OpenOrExecute(ABlocked: Boolean = False): Boolean;
begin
  try
    Open(ABlocked);
  except
    on E: EADException do
      if E.ADCode <> er_AD_AccCmdMHRowSet then
        raise;
  end;
  Result := Active;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Close;
begin
  Active := False;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.CloseAll;
begin
  if Active then begin
    CheckAsyncProgress;
    DoBeforeClose;
    InternalClose(True);
    DoAfterClose;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.AbortJob(AWait: Boolean = False);
begin
  if GetState in [csExecuting, csFetching] then
    CommandIntf.AbortJob(AWait);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Disconnect(AAbortJob: Boolean = False);
begin
  if AAbortJob then
    AbortJob(True);
  Active := False;
  Prepared := False;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoBeforeExecute;
begin
  if Assigned(FBeforeExecute) then
    FBeforeExecute(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoAfterExecute;
begin
  if Assigned(FAfterExecute) then
    FAfterExecute(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.InternalExecuteFinished(ASender: TObject;
  AState: TADStanAsyncState; AException: Exception);
begin
  if CommandIntf <> nil then
    FRowsAffected := CommandIntf.RowsAffected;
{$IFDEF AnyDAC_MONITOR_Comp}
  if AException <> nil then
    Trace(esProgress, 'TADCustomCommand.InternalExecuteFinished - Exception',
      ['Class', AException.ClassName, 'Msg', AException.Message]);
  Trace(esProgress, 'TADCustomCommand.InternalExecuteFinished',
    ['Command', CommandText.Text, 'AState', Integer(AState),
     'FRowsAffected', FRowsAffected]);
{$ENDIF}
  if CommandKind in [skCreate, skAlter, skDrop,
                     skStartTransaction, skCommit, skRollback,
                     skSet, skSetSchema] then
    Unprepare;
  if AState = asFinished then begin
    DoAfterExecute;
    if FOwner <> nil then
      TADAdaptedDataSet(FOwner).CheckAsyncExecFinished;
  end;
end;

procedure TADCustomCommand.InternalExecute(ATimes: Integer; AOffset: Integer;
  ABlocked: Boolean);
begin
{$IFDEF AnyDAC_MONITOR_Comp}
  Trace(esStart, 'TADCustomCommand.InternalExecute',
    ['Command', CommandText.Text, 'ATimes', ATimes, 'AOffset', AOffset,
     'ABlocked', ABlocked]);
  try
    try
{$ENDIF}
      FRowsAffected := -1;
      FOperationFinished := InternalExecuteFinished;
      CommandIntf.Execute(ATimes, AOffset, ABlocked);
{$IFDEF AnyDAC_MONITOR_Comp}
    except
      on E: Exception do begin
        Trace(esProgress, 'TADCustomCommand.InternalExecute - Exception',
          ['Class', E.ClassName, 'Msg', E.Message]);
        raise;
      end;
    end;
  finally
    Trace(esEnd, 'TADCustomCommand.InternalExecute',
      ['Command', CommandText.Text, 'ATimes', ATimes, 'AOffset', AOffset,
       'ABlocked', ABlocked]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.Execute(ATimes: Integer = 0; AOffset: Integer = 0;
  ABlocked: Boolean = False);
begin
  CheckPrepared;
  DoBeforeExecute;
  InternalExecute(ATimes, AOffset, ABlocked);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.Execute(const ASQL: String;
  const AParams: array of Variant; const ATypes: array of TFieldType): LongInt;
var
  i: Integer;
begin
  Close;
  if ASQL <> '' then
    SetCommandText(ASQL, ResourceOptions.ParamCreate);
  if Params.BindMode = pbByNumber then
    for i := 0 to Params.Count - 1 do
      Params[i].Position := i + 1;
  for i := Low(ATypes) to High(ATypes) do
    if ATypes[i] <> ftUnknown then
      Params[i].DataType := ATypes[i];
  for i := Low(AParams) to High(AParams) do
    Params[i].Value := AParams[i];
  Prepare;
  Execute(1, 0);
  Result := RowsAffected;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.Execute(const ASQL: String): LongInt;
begin
  Result := Execute(ASQL, [], []);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.Execute(const ASQL: String;
  const AParams: array of Variant): LongInt;
begin
  Result := Execute(ASQL, AParams, []);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.NextRecordSet;
begin
  CheckPrepared;
  CommandIntf.NextRecordSet := True;
  try
    Close;
    PropertyChange;
    Open;
  finally
    CommandIntf.NextRecordSet := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetCommandKind: TADPhysCommandKind;
begin
  if (CommandIntf <> nil) and not FFixedCommandKind then
    Result := CommandIntf.CommandKind
  else
    Result := FCommandKind;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetCommandKind(const AValue: TADPhysCommandKind);
begin
  if FCommandKind <> AValue then begin
    CheckUnprepared;
    FCommandKind := AValue;
    FFixedCommandKind := (AValue <> skUnknown);
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.IsCKS: Boolean;
begin
  Result := FFixedCommandKind and (CommandKind <> skUnknown);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetState: TADPhysCommandState;
begin
  if CommandIntf <> nil then
    Result := CommandIntf.State
  else
    Result := csInactive;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetSQLText: String;
begin
  if CommandIntf <> nil then
    Result := CommandIntf.SQLText
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetOverload(const AValue: Word);
begin
  if FOverload <> AValue then begin
    CheckUnprepared;
    FOverload := AValue;
    if not CheckComponentState([csReading]) then
      FParams.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetBaseObjectName(const AValue: String);
begin
  if FBaseObjectName <> AValue then begin
    CheckUnprepared;
    FBaseObjectName := AValue;
    if not CheckComponentState([csReading]) then
      FParams.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetSchemaName(const AValue: String);
begin
  if FSchemaName <> AValue then begin
    CheckUnprepared;
    FSchemaName := AValue;
    if not CheckComponentState([csReading]) then
      FParams.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetCatalogName(const AValue: String);
begin
  if FCatalogName <> AValue then begin
    CheckUnprepared;
    FCatalogName := AValue;
    if not CheckComponentState([csReading]) then
      FParams.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetParamBindMode(const AValue: TADParamBindMode);
begin
  if FParams.BindMode <> AValue then begin
    CheckUnprepared;
    FParams.BindMode := AValue;
    if not CheckComponentState([csReading]) then
      FParams.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetParamBindMode: TADParamBindMode;
begin
  Result := FParams.BindMode;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.Define(ATable: TADDatSTable;
  AMetaInfoMergeMode: TADPhysMetaInfoMergeMode): TADDatSTable;
begin
  CheckPrepared;
  Result := CommandIntf.Define(ATable, AMetaInfoMergeMode);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.Define(ASchema: TADDatSManager;
  ATable: TADDatSTable; AMetaInfoMergeMode: TADPhysMetaInfoMergeMode): TADDatSTable;
begin
  CheckPrepared;
  if CommandKind = skStoredProc then begin
    FCommandKind := skStoredProcWithCrs;
    CommandIntf.CommandKind := skStoredProcWithCrs;
  end;
  Result := CommandIntf.Define(ASchema, ATable, AMetaInfoMergeMode);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoBeforeFetch;
begin
  if Assigned(FBeforeFetch) then
    FBeforeFetch(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoAfterFetch;
begin
  if Assigned(FAfterFetch) then
    FAfterFetch(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.FetchFinished(ASender: TObject;
  AState: TADStanAsyncState; AException: Exception);
begin
  if CommandIntf <> nil then
    FRowsAffected := CommandIntf.RowsAffected;
{$IFDEF AnyDAC_MONITOR_Comp}
  if AException <> nil then
    Trace(esProgress, 'TADCustomCommand.FetchFinished - Exception',
      ['Class', AException.ClassName, 'Msg', AException.Message]);
  Trace(esProgress, 'TADCustomCommand.FetchFinished',
    ['Command', CommandText.Text, 'AState', Integer(AState),
     'FRowsAffected', FRowsAffected]);
{$ENDIF}
  if AState = asFinished then
    DoAfterFetch;
end;

procedure TADCustomCommand.Fetch(ATable: TADDatSTable; AAll: Boolean = True;
  ABlocked: Boolean = False);
begin
  CheckActive;
  DoBeforeFetch;
{$IFDEF AnyDAC_MONITOR_Comp}
  Trace(esStart, 'TADCustomCommand.Fetch',
    ['Command', CommandText.Text, 'AAll', AAll, 'ABlocked', ABlocked]);
  try
    try
{$ENDIF}
      FRowsAffected := 0;
      FOperationFinished := FetchFinished;
      CommandIntf.Fetch(ATable, AAll, ABlocked);
{$IFDEF AnyDAC_MONITOR_Comp}
    except
      on E: Exception do begin
        Trace(esProgress, 'TADCustomCommand.Fetch - Exception',
          ['Class', E.ClassName, 'Msg', E.Message]);
        raise;
      end;
    end;
  finally
    Trace(esEnd, 'TADCustomCommand.Fetch',
      ['Command', CommandText.Text, 'AAll', AAll, 'ABlocked', ABlocked]);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetCommandTextStrs(const AValue: TStrings);
begin
  if FCommandText <> AValue then
    FCommandText.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetCommandText(const ASQL: String; AResetParams: Boolean);
begin
  if (CommandText.Count = 1) and (CommandText[0] = ASQL) then
    Exit;
  CommandText.BeginUpdate;
  try
    if AResetParams then
      Params.Clear;
    CommandText.Clear;
    CommandText.Add(ASQL);
  finally
    CommandText.EndUpdate;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetMacros(const AValue: TADMacros);
begin
  if AValue <> FMacros then
    FMacros.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetParams(const AValue: TADParams);
begin
  if AValue <> FParams then
    FParams.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.PreprocessSQL(const ASQL: String; AParams: TADParams;
  AMacrosUpd, AMacrosRead: TADMacros; ACreateParams, ACreateMacros, AExpandMacros,
  AExpandEscape, AParseSQL: Boolean; var ACommandKind: TADPhysCommandKind;
  var AFrom: String);
var
  oConMeta: IADPhysConnectionMetadata;
  oPrep: TADPhysPreprocessor;
begin
  if not ACreateParams and not ACreateMacros and not AParseSQL then
    Exit;
  oPrep := TADPhysPreprocessor.Create;
  try
    oPrep.Params := AParams;
    oPrep.MacrosUpd := AMacrosUpd;
    oPrep.MacrosRead := AMacrosRead;
    oPrep.Source := ASQL;
    oPrep.DesignMode := CheckComponentState([csDesigning]);
    oPrep.Instrs := [];
    oPrep.ConnMetadata := GetConnectionMetadata;
    if oPrep.ConnMetadata = nil then begin
      ADPhysManager.CreateDefaultConnectionMetadata(oConMeta);
      oPrep.ConnMetadata := oConMeta;
    end;
    if ACreateParams then
      oPrep.Instrs := oPrep.Instrs + [piCreateParams];
    if ACreateMacros then
      oPrep.Instrs := oPrep.Instrs + [piCreateMacros];
    if AExpandMacros then
      oPrep.Instrs := oPrep.Instrs + [piExpandMacros];
    if AExpandEscape then
      oPrep.Instrs := oPrep.Instrs + [piExpandEscapes];
    if AParseSQL then
      oPrep.Instrs := oPrep.Instrs + [piParseSQL];
    oPrep.Execute;
    ACommandKind := oPrep.SQLCommandKind;
    AFrom := oPrep.SQLFromValue;
  finally
    ADFree(oPrep);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.FillParams(AParams: TADParams; const ASQL: String = '');
var
  oConn: TADCustomConnection;
  oGen: IADPhysCommandGenerator;
  eCmdKind: TADPhysCommandKind;
  s: String;
  oRes: TADResourceOptions;
begin
  if ASQL = '' then
    s := Trim(CommandText.Text)
  else
    s := ASQL;
  if CommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
    oConn := AcquireConnection;
    try
      oConn.CheckActive;
      oConn.ConnectionIntf.CreateCommandGenerator(oGen, nil);
      oGen.Params := AParams;
      oGen.Options := Self as IADStanOptions;
      oGen.GenerateStoredProcParams(CatalogName, SchemaName, BaseObjectName, s);
    finally
      ReleaseConnection(oConn);
    end;
  end
  else begin
    eCmdKind := skUnknown;
    oRes := ResourceOptions;
    PreprocessSQL(s, AParams, nil, nil, True, False, oRes.MacroExpand,
      oRes.EscapeExpand, False, eCmdKind, s);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoSQLChanging(ASender: TObject);
begin
  CheckAsyncProgress;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DoSQLChange(ASender: TObject);
var
  oPList: TADParams;
  oMList: TADMacros;
  eCmdKind: TADPhysCommandKind;
  lPCreate, lMCreate, lMExpand, lEExpand: Boolean;
  sFrom: String;
  oRes: TADResourceOptions;
begin
  if CheckComponentState([csReading]) or (TADStringList(CommandText).UpdateCount > 0) or
     (ckLockParse in FFlags) then
    Exit;
  if FOwner <> nil then
    FOwner.Disconnect
  else
    Disconnect;
  oRes := GetResourceOptions;
  lPCreate := oRes.ParamCreate;
  lMCreate := oRes.MacroCreate and not (ckMacros in FFlags);
  lMExpand := oRes.MacroExpand;
  lEExpand := oRes.EscapeExpand;
  if lPCreate or lMCreate or CheckComponentState([csDesigning]) then begin
    oPList := nil;
    if lPCreate then begin
      oPList := TADParams.CreateRefCounted(GetParamsOwner);
      oPList.BindMode := FParams.BindMode;
    end;
    oMList := nil;
    if lMCreate then
      oMList := TADMacros.CreateRefCounted(GetParamsOwner);
    Include(FFlags, ckLockParse);
    try
      try
        eCmdKind := skUnknown;
        PreprocessSQL(FCommandText.Text, oPList, oMList, FMacros, lPCreate,
          lMCreate, lMExpand, lEExpand, False, eCmdKind, sFrom);
        if not FFixedCommandKind then
          FCommandKind := eCmdKind;
        if lPCreate then begin
          oPList.AssignValues(FParams);
          FParams.Assign(oPList);
        end;
        if lMCreate then begin
          oMList.AssignValues(FMacros);
          FMacros.Assign(oMList);
        end;
      finally
        if lPCreate then
          oPList.RemRef;
        if lMCreate then
          oMList.RemRef;
      end;
    finally
      Exclude(FFlags, ckLockParse);
    end;
  end;
  Include(FFlags, ckLockParse);
  try
    if Assigned(FOnCommandChanged) then
      FOnCommandChanged(Self);
  finally
    Exclude(FFlags, ckLockParse);
  end;
  PropertyChange;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.MacrosChanged(ASender: TObject);
begin
  if FCommandText.Count > 0 then
    try
      Include(FFlags, ckMacros);
      DoSQLChange(nil);
    finally
      Exclude(FFlags, ckMacros);
    end;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.FindParam(const AValue: string): TADParam;
begin
  Result := FParams.FindParam(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.ParamByName(const AValue: string): TADParam;
begin
  Result := FParams.ParamByName(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.FindMacro(const AValue: string): TADMacro;
begin
  Result := FMacros.FindMacro(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.MacroByName(const AValue: string): TADMacro;
begin
  Result := FMacros.MacroByName(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
var
  oInit: IADStanObject;
begin
  if AInitiator = nil then begin
    if (FOwner = nil) or not Supports(TObject(FOwner), IADStanObject, oInit) then
      Supports(TObject(Self), IADStanObject, oInit);
  end
  else
    oInit := AInitiator;
  if Assigned(FOnError) then
    FOnError(Self, oInit, AException);
  if (Connection <> nil) and (AException <> nil) then
    Connection.HandleException(oInit, AException);
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetConnectionMetadata: IADPhysConnectionMetadata;
var
  oConn: TADCustomConnection;
begin
  oConn := GetConnection(False);
  if oConn <> nil then
    Result := oConn.GetConnectionMetadata
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetName: TComponentName;
begin
  if Name = '' then
    Result := '$' + IntToHex(Integer(Self), 8)
  else
    Result := Name;
  Result := Result + ': ' + ClassName;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetParent: IADStanObject;
begin
  Result := GetConnection(False) as IADStanObject;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
  { TODO -cDAPT : Data adapters should call this method. Is "nothing" correct ? }
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.DefineProperties(AFiler: TFiler);

  function AreParamsStorable(AFiler: TFiler): Boolean;
  begin
    if not FEnableParamsStorage then
      Result := False
    else begin
      Result := Params.Count > 0;
      if AFiler.Ancestor <> nil then
        if AFiler.Ancestor is TADCustomCommand then
          Result := not Params.IsEqual(TADCustomCommand(AFiler.Ancestor).Params)
        else if AFiler.Ancestor is TADRdbmsDataSet then
          Result := not Params.IsEqual(TADRdbmsDataSet(AFiler.Ancestor).Params);
    end;
  end;

  function AreMacrosStorable(AFiler: TFiler): Boolean;
  begin
    if not FEnableParamsStorage then
      Result := False
    else begin
      Result := Macros.Count > 0;
      if AFiler.Ancestor <> nil then
        if AFiler.Ancestor is TADCustomCommand then
          Result := not Macros.IsEqual(TADCustomCommand(AFiler.Ancestor).Macros)
        else if AFiler.Ancestor is TADRdbmsDataSet then
          Result := not Macros.IsEqual(TADRdbmsDataSet(AFiler.Ancestor).Macros);
    end;
  end;

begin
  AFiler.DefineProperty('ParamData', ReadParams, WriteParams, AreParamsStorable(AFiler));
  AFiler.DefineProperty('MacroData', ReadMacros, WriteMacros, AreMacrosStorable(AFiler));
  AFiler.DefineProperty('Prepared', ReadPrepared, nil, False);
  if FOwner = nil then
    inherited DefineProperties(AFiler);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.ReadParams(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(Params);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.WriteParams(Writer: TWriter);
begin
  Writer.WriteCollection(Params);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.ReadMacros(Reader: TReader);
begin
  Reader.ReadValue;
  Reader.ReadCollection(Macros);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.WriteMacros(Writer: TWriter);
begin
  Writer.WriteCollection(Macros);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.ReadPrepared(Reader: TReader);
begin
  Reader.ReadBoolean;
end;

{-------------------------------------------------------------------------------}
function TADCustomCommand.GetValues(const AParamNames: String): Variant;
begin
  Result := Params.ParamValues[AParamNames];
end;

{-------------------------------------------------------------------------------}
procedure TADCustomCommand.SetValues(const AParamNames: String; const AValue: Variant);
begin
  Params.ParamValues[AParamNames] := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADMetaInfoCommand                                                            }
{-------------------------------------------------------------------------------}
constructor TADMetaInfoCommand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMetaInfoKind := mkTables;
  FTableKinds := [tkSynonym, tkTable, tkView];
  FObjectScopes := [osMy];
  UpdateOptions.ReadOnly := True;
  FEnableParamsStorage := False;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.InternalCreateCommandIntf;
var
  oMetaInfoCmd: IADPhysMetaInfoCommand;
begin
  FConnection.ConnectionIntf.CreateMetaInfoCommand(oMetaInfoCmd);
  FCommandIntf := oMetaInfoCmd as IADPhysCommand;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.InternalPrepare;
var
  oCmd: IADPhysMetaInfoCommand;
begin
  oCmd := CommandIntf as IADPhysMetaInfoCommand;
  oCmd.MetaInfoKind := FMetaInfoKind;
  oCmd.TableKinds := FTableKinds;
  oCmd.Wildcard := FWildcard;
  oCmd.ObjectScopes := FObjectScopes;
  inherited InternalPrepare;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.DoAfterClose;
begin
  try
    inherited DoAfterClose;
  finally
    Prepared := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoCommand.GetObjectName: String;
begin
  Result := Trim(CommandText.Text);
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.SetObjectName(const AValue: String);
begin
  SetCommandText(AValue, False);
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.SetMetaInfoKind(const AValue: TADPhysMetaInfoKind);
begin
  CheckUnprepared;
  FMetaInfoKind := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.SetTableKinds(const AValue: TADPhysTableKinds);
begin
  CheckUnprepared;
  FTableKinds := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.SetWildcard(const AValue: String);
begin
  CheckUnprepared;
  FWildcard := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoCommand.SetObjectScopes(const AValue: TADPhysObjectScopes);
begin
  CheckUnprepared;
  FObjectScopes := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADCustomTableAdapter                                                         }
{-------------------------------------------------------------------------------}
constructor TADCustomTableAdapter.Create(AOwner: TComponent);
var
  oAdapt: IADDAptTableAdapter;
begin
  inherited Create(AOwner);
  ADCreateInterface(IADDAptTableAdapter, oAdapt);
  SetTableAdapterIntf(oAdapt, True);
end;

{-------------------------------------------------------------------------------}
destructor TADCustomTableAdapter.Destroy;
begin
  Destroying;
  SelectCommand := nil;
  InsertCommand := nil;
  UpdateCommand := nil;
  DeleteCommand := nil;
  LockCommand := nil;
  UnLockCommand := nil;
  FetchRowCommand := nil;
  SchemaAdapter := nil;
  if FTableAdapterIntf <> nil then begin
    FTableAdapterIntf.DatSTable := nil;
    SetTableAdapterIntf(nil, True);
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetTableAdapterIntf(const AAdapter: IADDAptTableAdapter;
  AOwned: Boolean);
begin
  if FTableAdapterIntf <> nil then begin
    FTableAdapterIntf.ErrorHandler := nil;
    FTableAdapterIntf.UpdateHandler := nil;
    FTableAdapterIntf.ColumnMappings.SetOwner(nil);
  end;
  FTableAdapterIntf := AAdapter;
  FTableAdapterOwned := AOwned;
  if FTableAdapterIntf <> nil then begin
    FTableAdapterIntf.ErrorHandler := Self as IADStanErrorHandler;
    FTableAdapterIntf.UpdateHandler := Self as IADDAptUpdateHandler;
    FTableAdapterIntf.ColumnMappings.SetOwner(Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if AOperation = opRemove then
    if UpdateTransaction = AComponent then
      UpdateTransaction := nil
    else if SelectCommand = AComponent then
      SelectCommand := nil
    else if InsertCommand = AComponent then
      InsertCommand := nil
    else if UpdateCommand = AComponent then
      UpdateCommand := nil
    else if DeleteCommand = AComponent then
      DeleteCommand := nil
    else if LockCommand = AComponent then
      LockCommand := nil
    else if UnLockCommand = AComponent then
      UnLockCommand := nil
    else if FetchRowCommand = AComponent then
      FetchRowCommand := nil
    else if SchemaAdapter = AComponent then
      SchemaAdapter := nil;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetSender: TObject;
begin
  if Assigned(FAdaptedDataSet) then
    Result := FAdaptedDataSet
  else
    Result := Self;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.HandleException(
  const AInitiator: IADStanObject; var AException: Exception);
begin
  if Assigned(FAdaptedDataSet) then
    FAdaptedDataSet.InternalUpdateErrorHandler(GetSender, AInitiator, AException);
  if (AException <> nil) and Assigned(FOnError) then
    FOnError(GetSender, AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.ReconcileRow(ARow: TADDatSRow;
  var AAction: TADDAptReconcileAction);
begin
  if Assigned(FAdaptedDataSet) then
    FAdaptedDataSet.InternalReconcileErrorHandler(GetSender, ARow, AAction);
  if Assigned(FOnReconcileRow) then
    FOnReconcileRow(GetSender, ARow, AAction);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.UpdateRow(ARow: TADDatSRow;
  ARequest: TADUpdateRequest; AUpdRowOptions: TADUpdateRowOptions;
  var AAction: TADErrorAction);
begin
  if Assigned(FAdaptedDataSet) then
    FAdaptedDataSet.InternalUpdateRecordHandler(GetSender, ARow, ARequest,
      AUpdRowOptions, AAction);
  if Assigned(FOnUpdateRow) then
    FOnUpdateRow(GetSender, ARow, ARequest, AUpdRowOptions, AAction);
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetActualTransaction: TADCustomTransaction;
var
  oConn: TADCustomConnection;
begin
  if SelectCommand = nil then
    Result := nil
  else if SelectCommand.Transaction <> nil then
    Result := SelectCommand.Transaction
  else begin
    oConn := SelectCommand.GetConnection(False);
    Result := oConn.Transaction;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetActualUpdateTransaction: TADCustomTransaction;
var
  oConn: TADCustomConnection;
begin
  if UpdateTransaction <> nil then
    Result := UpdateTransaction
  else if SelectCommand = nil then
    Result := nil
  else begin
    oConn := SelectCommand.GetConnection(False);
    if oConn.UpdateTransaction <> nil then
      Result := oConn.UpdateTransaction
    else
      Result := GetActualTransaction;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.InternalUpdateTransaction;
var
  oUpdTX: TADCustomTransaction;
begin
  oUpdTX := GetActualUpdateTransaction;
  if oUpdTX <> nil then begin
    oUpdTX.CheckConnected;
    FTableAdapterIntf.UpdateTransaction := oUpdTX.TransactionIntf;
  end
  else
    FTableAdapterIntf.UpdateTransaction := nil;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.InternalUpdateAdapterCmd(ACmd: TADActionRequest): Boolean;
var
  oCmd: TADCustomCommand;
begin
  Result := True;
  oCmd := GetCommand(ACmd);
  if oCmd <> nil then begin
    if oCmd.CommandIntf = nil then begin
      if ACmd = arSelect then
        oCmd.Transaction := GetActualTransaction
      else
        oCmd.Transaction := GetActualUpdateTransaction;
      if oCmd.CommandText.Count > 0 then begin
        Include(oCmd.FFlags, ckCreateIntfDontPrepare);
        try
          oCmd.Prepare;
        finally
          Exclude(oCmd.FFlags, ckCreateIntfDontPrepare);
        end;
      end;
    end;
    if oCmd.CommandIntf <> nil then begin
      SetAdapterCmd(oCmd.CommandIntf, ACmd);
      Result := False;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.UpdateAdapterCmd(ACmd: TADActionRequest);
begin
  if InternalUpdateAdapterCmd(ACmd) then
    InternalUpdateTransaction;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.UpdateAdapterCmds(const ACmds: array of TADActionRequest);
var
  i: Integer;
  lUpdated, lUpdateTX: Boolean;
begin
  lUpdateTX := False;
  for i := Low(ACmds) to High(ACmds) do begin
    lUpdated := InternalUpdateAdapterCmd(ACmds[i]);
    lUpdateTX := lUpdateTX or lUpdated;
  end;
  if lUpdateTX then
    InternalUpdateTransaction;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetAdapterCmd(const ACmd: IADPhysCommand;
  ACmdKind: TADActionRequest);
begin
  case ACmdKind of
  arSelect:   FTableAdapterIntf.SelectCommand := ACmd;
  arInsert:   FTableAdapterIntf.InsertCommand := ACmd;
  arUpdate:   FTableAdapterIntf.UpdateCommand := ACmd;
  arDelete:   FTableAdapterIntf.DeleteCommand := ACmd;
  arLock:     FTableAdapterIntf.LockCommand := ACmd;
  arUnlock:   FTableAdapterIntf.UnLockCommand := ACmd;
  arFetchRow: FTableAdapterIntf.FetchRowCommand := ACmd;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetCommand(ACmdKind: TADActionRequest): TADCustomCommand;
begin
  case ACmdKind of
  arSelect:   Result := SelectCommand;
  arInsert:   Result := InsertCommand;
  arUpdate:   Result := UpdateCommand;
  arDelete:   Result := DeleteCommand;
  arLock:     Result := LockCommand;
  arUnlock:   Result := UnLockCommand;
  arFetchRow: Result := FetchRowCommand;
  else        Result := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetCommand(var AVar: TADCustomCommand;
  const AValue: TADCustomCommand; ACmdKind: TADActionRequest);
begin
  if AVar <> nil then begin
    AVar.FTableAdapter := nil;
    AVar.RemoveFreeNotification(Self);
    SetAdapterCmd(nil, ACmdKind);
  end;
  AVar := AValue;
  if AVar <> nil then begin
    AVar.FTableAdapter := Self;
    AVar.FreeNotification(Self);
    if AVar.CommandIntf <> nil then
      SetAdapterCmd(AVar.CommandIntf, ACmdKind);
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.Define: TADDatSTable;
begin
  UpdateAdapterCmd(arSelect);
  Result := FTableAdapterIntf.Define;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.Fetch(AAll: Boolean);
begin
  UpdateAdapterCmd(arSelect);
  // Call TADCustomCommand.Fetch here to properly handle async commands
  FSelectCommand.Fetch(FTableAdapterIntf.DatSTable, AAll, True);
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.ApplyUpdates(AMaxErrors: Integer): Integer;
begin
  UpdateAdapterCmds([arInsert, arUpdate, arDelete, arLock, arUnlock, arFetchRow]);
  Result := FTableAdapterIntf.Update(AMaxErrors);
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.Reconcile: Boolean;
begin
  Result := FTableAdapterIntf.Reconcile;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.Fetch(ARow: TADDatSRow;
  var AAction: TADErrorAction; AColumn: Integer;
  ARowOptions: TADPhysFillRowOptions);
begin
  UpdateAdapterCmd(arFetchRow);
  FTableAdapterIntf.Fetch(ARow, AAction, AColumn, ARowOptions);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.Update(ARow: TADDatSRow;
  var AAction: TADErrorAction; AUpdRowOptions: TADUpdateRowOptions;
  AForceRequest: TADActionRequest);
begin
  if AForceRequest = arFromRow then
    UpdateAdapterCmds([arInsert, arUpdate, arDelete, arLock, arUnlock, arFetchRow])
  else if AForceRequest in [arInsert, arUpdate] then
    UpdateAdapterCmds([AForceRequest, arFetchRow])
  else
    UpdateAdapterCmd(AForceRequest);
  FTableAdapterIntf.Update(ARow, AAction, AUpdRowOptions, AForceRequest);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.Lock(ARow: TADDatSRow;
  var AAction: TADErrorAction; AUpdRowOptions: TADUpdateRowOptions);
begin
  UpdateAdapterCmd(arLock);
  FTableAdapterIntf.Update(ARow, AAction, AUpdRowOptions, arLock);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.UnLock(ARow: TADDatSRow;
  var AAction: TADErrorAction; AUpdRowOptions: TADUpdateRowOptions);
begin
  UpdateAdapterCmd(arUnLock);
  FTableAdapterIntf.Update(ARow, AAction, AUpdRowOptions, arUnlock);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetUpdateTransaction(const AValue: TADCustomTransaction);
begin
  if FUpdateTransaction <> AValue then begin
    FUpdateTransaction := AValue;
    if FUpdateTransaction <> nil then
      FUpdateTransaction.FreeNotification(Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetDeleteCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FDeleteCommand, AValue, arDelete);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetFetchRowCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FFetchRowCommand, AValue, arFetchRow);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetInsertCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FInsertCommand, AValue, arInsert);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetLockCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FLockCommand, AValue, arLock);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetSelectCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FSelectCommand, AValue, arSelect);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetUnLockCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FUnLockCommand, AValue, arUnLock);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetUpdateCommand(const AValue: TADCustomCommand);
begin
  SetCommand(FUpdateCommand, AValue, arUpdate);
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetColumnMappings: TADDAptColumnMappings;
begin
  Result := FTableAdapterIntf.ColumnMappings;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetColumnMappings(const AValue: TADDAptColumnMappings);
begin
  FTableAdapterIntf.ColumnMappings.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.IsCMS: Boolean;
begin
  Result := ColumnMappings.Count > 0;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetSchemaAdapter(const AValue: TADCustomSchemaAdapter);
var
  oAdapt: IADDAptTableAdapter;
begin
  if FSchemaAdapter <> AValue then begin
    if FSchemaAdapter <> nil then begin
      FSchemaAdapter.FTableAdapters.Remove(Self);
      FSchemaAdapter.RemoveFreeNotification(Self);
      if FAdaptedDataSet <> nil then
        FAdaptedDataSet.DatSManager := nil;
      if FTableAdapterOwned then
        FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Remove(FTableAdapterIntf)
      else begin
        ADCreateInterface(IADDAptTableAdapter, oAdapt);
        SetTableAdapterIntf(oAdapt, True);
      end;
    end;
    FSchemaAdapter := AValue;
    if FSchemaAdapter <> nil then begin
      FSchemaAdapter.FTableAdapters.Add(Self);
      FSchemaAdapter.FreeNotification(Self);
      if FTableAdapterOwned then
        FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Add(FTableAdapterIntf);
      if FAdaptedDataSet <> nil then
        FAdaptedDataSet.DatSManager := FSchemaAdapter.DatSManager;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetDatSTable: TADDatSTable;
begin
  Result := FTableAdapterIntf.DatSTable;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetDatSTable(const AValue: TADDatSTable);
begin
  FTableAdapterIntf.DatSTable := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetDatSTableName: String;
begin
  Result := FTableAdapterIntf.DatSTableName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetDatSTableName(const AValue: String);
begin
  FTableAdapterIntf.DatSTableName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.IsDTNS: Boolean;
begin
  Result := DatSTableName <> SourceRecordSetName;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetMetaInfoMergeMode: TADPhysMetaInfoMergeMode;
begin
  Result := FTableAdapterIntf.MetaInfoMergeMode;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetMetaInfoMergeMode(const AValue: TADPhysMetaInfoMergeMode);
begin
  FTableAdapterIntf.MetaInfoMergeMode := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetSourceRecordSetID: Integer;
begin
  Result := FTableAdapterIntf.SourceRecordSetID;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetSourceRecordSetID(const AValue: Integer);
begin
  if FSchemaAdapter <> nil then begin
    if FTableAdapterOwned then
      FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Remove(FTableAdapterIntf);
    SetTableAdapterIntf(FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Lookup(AValue, nkID), False);
    if FTableAdapterIntf = nil then begin
      SetTableAdapterIntf(FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Add('', '', ''), True);
      FTableAdapterIntf.SourceRecordSetID := AValue;
    end;
  end
  else
    FTableAdapterIntf.SourceRecordSetID := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetSourceRecordSetName: String;
begin
  Result := FTableAdapterIntf.SourceRecordSetName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetSourceRecordSetName(const AValue: String);
begin
  if FSchemaAdapter <> nil then begin
    if FTableAdapterOwned then
      FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Remove(FTableAdapterIntf);
    SetTableAdapterIntf(FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Lookup(AValue, nkSource), False);
    if FTableAdapterIntf = nil then begin
      SetTableAdapterIntf(FSchemaAdapter.FDAptSchemaAdapter.TableAdapters.Add(AValue, '', ''), True);
      FTableAdapterIntf.SourceRecordSetName := AValue;
    end;
  end
  else
    FTableAdapterIntf.SourceRecordSetName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.IsSRSNS: Boolean;
begin
  if (SelectCommand <> nil) and (SelectCommand.CommandIntf <> nil) then
    Result := SourceRecordSetName <> SelectCommand.CommandIntf.SourceObjectName
  else
    Result := True;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetUpdateTableName: String;
begin
  Result := FTableAdapterIntf.UpdateTableName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetUpdateTableName(const AValue: String);
begin
  FTableAdapterIntf.UpdateTableName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.IsUTNS: Boolean;
begin
  Result := UpdateTableName <> SourceRecordSetName;
end;

{-------------------------------------------------------------------------------}
function TADCustomTableAdapter.GetDatSManager: TADDatSManager;
begin
  Result := FTableAdapterIntf.DatSManager;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.SetDatSManager(AValue: TADDatSManager);
begin
  ASSERT((csDestroying in ComponentState) or (FTableAdapterIntf <> nil));
  if FTableAdapterIntf <> nil then
    FTableAdapterIntf.DatSManager := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomTableAdapter.Reset;
var
  i: TADActionRequest;
  oCmd: TADCustomCommand;
begin
  for i := Low(TADActionRequest) to High(TADActionRequest) do begin
    oCmd := GetCommand(i);
    if oCmd <> nil then begin
      SetAdapterCmd(nil, i);
      oCmd.Prepared := False;
    end;
  end;
  FTableAdapterIntf.Reset;
end;

{-------------------------------------------------------------------------------}
{ TADCustomSchemaAdapter                                                        }
{-------------------------------------------------------------------------------}
constructor TADCustomSchemaAdapter.Create(AOwner: TComponent);
var
  oMgr: TADDatSManager;
begin
  inherited Create(AOwner);
  FTableAdapters := TADObjList.Create;
  ADCreateInterface(IADDAptSchemaAdapter, FDAptSchemaAdapter);
  oMgr := TADDatSManager.Create;
  oMgr.UpdatesRegistry := True;
  oMgr.CountRef(0);
  FDAptSchemaAdapter.DatSManager := oMgr;
  FDAptSchemaAdapter.ErrorHandler := Self as IADStanErrorHandler;
  FDAptSchemaAdapter.UpdateHandler := Self as IADDAptUpdateHandler;
end;

{-------------------------------------------------------------------------------}
destructor TADCustomSchemaAdapter.Destroy;
begin
  inherited Destroy;
  FDAptSchemaAdapter.DatSManager := nil;
  FDAptSchemaAdapter.ErrorHandler := nil;
  FDAptSchemaAdapter.UpdateHandler := nil;
  FDAptSchemaAdapter := nil;
  ADFreeAndNil(FTableAdapters);
end;

{-------------------------------------------------------------------------------}
function TADCustomSchemaAdapter.GetCount: Integer;
begin
  Result := FTableAdapters.Count;
end;

{-------------------------------------------------------------------------------}
function TADCustomSchemaAdapter.GetTableAdapters(AIndex: Integer): TADCustomTableAdapter;
begin
  Result := TADCustomTableAdapter(FTableAdapters[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADCustomSchemaAdapter.GetTableAdaptersIntf: IADDAptTableAdapters;
begin
  Result := FDAptSchemaAdapter.TableAdapters;
end;

{-------------------------------------------------------------------------------}
function TADCustomSchemaAdapter.GetDatSManager: TADDatSManager;
begin
  Result := FDAptSchemaAdapter.DatSManager;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomSchemaAdapter.SetDatSManager(const AValue: TADDatSManager);
begin
  FDAptSchemaAdapter.DatSManager := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomSchemaAdapter.HandleException(
  const AInitiator: IADStanObject; var AException: Exception);
begin
  if Assigned(FOnError) then
    FOnError(Self, AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomSchemaAdapter.ReconcileRow(ARow: TADDatSRow;
  var AAction: TADDAptReconcileAction);
begin
  if Assigned(FOnReconcileRow) then
    FOnReconcileRow(Self, ARow, AAction);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomSchemaAdapter.UpdateRow(ARow: TADDatSRow;
  ARequest: TADUpdateRequest; AUpdRowOptions: TADUpdateRowOptions;
  var AAction: TADErrorAction);
begin
  if Assigned(FOnUpdateRow) then
    FOnUpdateRow(Self, ARow, ARequest, AUpdRowOptions, AAction);
end;

{-------------------------------------------------------------------------------}
function TADCustomSchemaAdapter.Reconcile: Boolean;
begin
  Result := FDAptSchemaAdapter.Reconcile;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomSchemaAdapter.DoBeforeApplyUpdate;
begin
  if Assigned(FBeforeApplyUpdate) then
    FBeforeApplyUpdate(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomSchemaAdapter.DoAfterApplyUpdate(AErrors: Integer);
begin
  if Assigned(FAfterApplyUpdate) then
    FAfterApplyUpdate(Self);
end;

{-------------------------------------------------------------------------------}
function TADCustomSchemaAdapter.ApplyUpdates(AMaxErrors: Integer): Integer;
var
  i: Integer;
begin
  DoBeforeApplyUpdate;
  for i := 0 to Count - 1 do
    TableAdapters[i].UpdateAdapterCmds([arInsert, arUpdate, arDelete, arLock,
                                        arUnlock, arFetchRow]);
  Result := FDAptSchemaAdapter.Update(AMaxErrors);
  DoAfterApplyUpdate(Result);
  if FDAptSchemaAdapter.DatSManager.HasErrors then
    Reconcile;
end;

{-------------------------------------------------------------------------------}
{ TADCustomUpdateObject                                                         }
{-------------------------------------------------------------------------------}
procedure TADCustomUpdateObject.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = FDataSet) then
    DataSet := nil;
  inherited Notification(AComponent, AOperation);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomUpdateObject.SetDataSet(const AValue: TADAdaptedDataSet);
begin
  if FDataSet <> AValue then begin
    if FDataSet <> nil then
      FDataSet.UpdateObject := nil;
    FDataSet := AValue;
    if FDataSet <> nil then
      FDataSet.UpdateObject := Self;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADDefaultLocalSQLAdapter                                                     }
{-------------------------------------------------------------------------------}
type
  TADDefaultLocalSQLAdapter = class (TInterfacedObject, IADPhysLocalQueryAdapter)
  private
    FDataSet: TDataSet;
  protected
    // IADPhysLocalQueryAdapter
    function GetFeatures: TADPhysLocalQueryAdapterFeatures;
    function GetCachedUpdates: Boolean;
    procedure SetCachedUpdates(const AValue: Boolean);
    function GetSavePoint: Integer;
    procedure SetSavePoint(const AValue: Integer);
    function GetIndexFieldNames: String;
    procedure SetIndexFieldNames(const AValue: String);
    function GetDataSet: TObject;
    function ApplyUpdates(AMaxErrors: Integer = -1): Integer;
    procedure CommitUpdates;
    procedure SetRange(const AStartValues, AEndValues: array of const;
      AStartExclusive: Boolean = False; AEndExclusive: Boolean = False);
    procedure CancelRange;
    function IsPKViolation(AExc: Exception): Boolean;
  public
    constructor Create(ADataSet: TDataSet);
  end;

{-------------------------------------------------------------------------------}
constructor TADDefaultLocalSQLAdapter.Create(ADataSet: TDataSet);
begin
  inherited Create;
  FDataSet := ADataSet;
end;

{-------------------------------------------------------------------------------}
function TADDefaultLocalSQLAdapter.GetDataSet: TObject;
begin
  Result := FDataSet;
end;

{-------------------------------------------------------------------------------}
function TADDefaultLocalSQLAdapter.GetFeatures: TADPhysLocalQueryAdapterFeatures;
begin
  // nothing
  Result := [];
end;

{-------------------------------------------------------------------------------}
function TADDefaultLocalSQLAdapter.GetCachedUpdates: Boolean;
begin
  // nothing
  Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDefaultLocalSQLAdapter.SetCachedUpdates(const AValue: Boolean);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDefaultLocalSQLAdapter.GetSavePoint: Integer;
begin
  // nothing
  Result := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDefaultLocalSQLAdapter.SetSavePoint(const AValue: Integer);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDefaultLocalSQLAdapter.GetIndexFieldNames: String;
begin
  // nothing
  Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TADDefaultLocalSQLAdapter.SetIndexFieldNames(const AValue: String);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDefaultLocalSQLAdapter.SetRange(const AStartValues,
  AEndValues: array of const; AStartExclusive: Boolean = False;
  AEndExclusive: Boolean = False);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDefaultLocalSQLAdapter.CancelRange;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDefaultLocalSQLAdapter.ApplyUpdates(AMaxErrors: Integer): Integer;
begin
  // nothing
  Result := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDefaultLocalSQLAdapter.CommitUpdates;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDefaultLocalSQLAdapter.IsPKViolation(AExc: Exception): Boolean;
begin
  // nothing
  Result := False;
end;

{-------------------------------------------------------------------------------}
{ TADLocalSQLDataSet                                                            }
{-------------------------------------------------------------------------------}
destructor TADLocalSQLDataSet.Destroy;
begin
  DataSet := nil;
  Changing;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADLocalSQLDataSet.Assign(ASource: TPersistent);
begin
  if ASource is TADLocalSQLDataSet then begin
    Changing;
    FDataSet := TADLocalSQLDataSet(ASource).FDataSet;
    FName := TADLocalSQLDataSet(ASource).FName;
    FAdapter := TADLocalSQLDataSet(ASource).FAdapter;
    CheckDefaultAdapter;
    Changed;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
function TADLocalSQLDataSet.GetDisplayName: String;
begin
  if Name <> '' then
    Result := Name
  else if DataSet <> nil then
    Result := DataSet.Name
  else
    Result := inherited GetDisplayName;
end;

{-------------------------------------------------------------------------------}
function TADLocalSQLDataSet.GetActualName: String;
begin
  if Name <> '' then
    Result := Name
  else if DataSet <> nil then
    Result := DataSet.Name
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
function TADLocalSQLDataSet.GetIsValid: Boolean;
begin
  Result := (ActualName <> '') and (FAdapter <> nil) and
    (FDataSet <> nil) and (Collection <> nil) and
    (TADLocalSQLDataSets(Collection).FOwner <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADLocalSQLDataSet.Changing;
begin
  if IsValid then
    TADLocalSQLDataSets(Collection).FOwner.CheckDataSetRemoving(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADLocalSQLDataSet.Changed;
begin
  if IsValid and not (csDestroying in FDataSet.ComponentState) then
    TADLocalSQLDataSets(Collection).FOwner.CheckDataSetAdded(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADLocalSQLDataSet.CheckDefaultAdapter;
begin
  if (FAdapter = nil) and (FDataSet <> nil) then
    if not Supports(FDataSet, IADPhysLocalQueryAdapter, FAdapter) then
      FAdapter := IADPhysLocalQueryAdapter(TADDefaultLocalSQLAdapter.Create(FDataSet));
end;

{-------------------------------------------------------------------------------}
procedure TADLocalSQLDataSet.SetAdapter(const AValue: IADPhysLocalQueryAdapter);
begin
  if FAdapter <> AValue then begin
    Changing;
    FAdapter := AValue;
    if FAdapter <> nil then
      FDataSet := TDataSet(FAdapter.DataSet)
    else
      CheckDefaultAdapter;
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADLocalSQLDataSet.SetName(const AValue: String);
begin
  if FName <> AValue then begin
    Changing;
    FName := AValue;
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADLocalSQLDataSet.SetDataSet(const AValue: TDataSet);
begin
  if FDataSet <> AValue then begin
    Changing;
    if (FDataSet <> nil) and (TADLocalSQLDataSets(Collection).FOwner <> nil) then
      FDataSet.RemoveFreeNotification(TADLocalSQLDataSets(Collection).FOwner);
    FDataSet := AValue;
    FAdapter := nil;
    if (FDataSet <> nil) and (TADLocalSQLDataSets(Collection).FOwner <> nil) then
      FDataSet.FreeNotification(TADLocalSQLDataSets(Collection).FOwner);
    CheckDefaultAdapter;
    Changed;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADLocalSQLDataSets                                                           }
{-------------------------------------------------------------------------------}
constructor TADLocalSQLDataSets.Create(AOwner: TADCustomLocalSQL);
begin
  inherited Create(TADLocalSQLDataSet);
  FOwner := AOwner;
end;

{-------------------------------------------------------------------------------}
function TADLocalSQLDataSets.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

{-------------------------------------------------------------------------------}
function TADLocalSQLDataSets.GetItems(AIndex: Integer): TADLocalSQLDataSet;
begin
  Result := TADLocalSQLDataSet(inherited Items[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADLocalSQLDataSets.SetItems(AIndex: Integer; const AValue: TADLocalSQLDataSet);
begin
  inherited Items[AIndex] := AValue;
end;

{-------------------------------------------------------------------------------}
function TADLocalSQLDataSets.Add: TADLocalSQLDataSet;
begin
  Result := TADLocalSQLDataSet(inherited Add);
end;

{-------------------------------------------------------------------------------}
function TADLocalSQLDataSets.Add(ADataSet: TDataSet; const AName: String;
  const AAdapter: IADPhysLocalQueryAdapter): TADLocalSQLDataSet;
begin
  Result := Add;
  Result.FDataSet := ADataSet;
  Result.FName := AName;
  Result.FAdapter := AAdapter;
  if ADataSet <> nil then
    ADataSet.FreeNotification(FOwner);
  Result.CheckDefaultAdapter;
  Result.Changed;
end;

{-------------------------------------------------------------------------------}
procedure TADLocalSQLDataSets.Remove(ADataSet: TDataSet);
var
  i: Integer;
  oItem: TADLocalSQLDataSet;
begin
  for i := Count - 1 downto 0 do begin
    oItem := Items[i];
    if oItem.DataSet = ADataSet then
      if oItem.Temporary then
        ADFree(oItem)
      else
        oItem.DataSet := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADLocalSQLDataSets.CheckUnique(AItem: TADLocalSQLDataSet);
var
  i: Integer;
  sName: String;
begin
  if AItem.ActualName = '' then
    Exit;
  for i := 0 to Count - 1 do
    if (Items[i] <> AItem) and
       (CompareText(Items[i].ActualName, AItem.ActualName) = 0) then begin
      if FOwner <> nil then
        sName := FOwner.Name
      else
        sName := '';
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntDSNameNotUnique,
        [AItem.ActualName, sName]);
    end;
end;

{-------------------------------------------------------------------------------}
{ TADCustomLocalSQL                                                             }
{-------------------------------------------------------------------------------}
constructor TADCustomLocalSQL.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataSets := TADLocalSQLDataSets.Create(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADCustomLocalSQL.Destroy;
begin
  Destroying;
  Connection := nil;
  inherited Destroy;
  ADFreeAndNil(FDataSets);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if AOperation = opRemove then
    if AComponent = Connection then
      Connection := nil
    else if AComponent is TDataSet then
      DataSets.Remove(TDataSet(AComponent));
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.ReadDataSets(Reader: TReader);
begin
  Reader.ReadCollection(DataSets);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.WriteDataSets(Writer: TWriter);
var
  oCol: TADLocalSQLDataSets;
  i: Integer;
begin
  oCol := TADLocalSQLDataSets.Create(nil);
  try
    for i := 0 to DataSets.Count - 1 do
      if not DataSets[i].Temporary then
        oCol.Add.Assign(DataSets[i]);
    Writer.WriteCollection(oCol);
  finally
    ADFree(oCol);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.DefineProperties(AFiler: TFiler);

  function AreDataSetsStorable(AFiler: TFiler): Boolean;
  begin
    Result := DataSets.Count > 0;
    if AFiler.Ancestor <> nil then
      if AFiler.Ancestor is TADCustomLocalSQL then
        Result := not CollectionsEqual(DataSets, TADCustomLocalSQL(AFiler.Ancestor).DataSets
          {$IFDEF AnyDAC_D6}, Self, TADCustomLocalSQL(AFiler.Ancestor) {$ENDIF});
  end;

begin
  AFiler.DefineProperty('DataSets', ReadDataSets, WriteDataSets, AreDataSetsStorable(AFiler));
  inherited DefineProperties(AFiler);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.Loaded;
begin
  inherited Loaded;
  try
    if FStreamedActive then
      SetActive(True);
  except
    if csDesigning in ComponentState then
      ADHandleException
    else
      raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.SetDataSets(const AValue: TADLocalSQLDataSets);
begin
  FDataSets.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.SetActive(const AValue: Boolean);
begin
  if csReading in ComponentState then
    FStreamedActive := AValue
  else if FActive <> AValue then begin
    FActive := AValue;
    if Active then
      CheckActivate
    else
      CheckDeactivate;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomLocalSQL.GetActualActive: Boolean;
begin
  Result := Active and (Connection <> nil) and Connection.Connected;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.CheckActivate;
var
  i: Integer;
begin
  if GetActualActive and not FActivated then begin
    for i := 0 to DataSets.Count - 1 do
      DataSets.CheckUnique(DataSets[i]);
    FActivated := True;
    InternalAttachToSQL;
    for i := 0 to DataSets.Count - 1 do
      if DataSets[i].IsValid then
        InternalDataSetAdded(DataSets[i]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.CheckDeactivate;
var
  i: Integer;
begin
  if GetActualActive and FActivated then begin
    FActivated := False;
    for i := 0 to DataSets.Count - 1 do
      if DataSets[i].IsValid then
        InternalDataSetRemoving(DataSets[i]);
    InternalDetachFromSQL;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.CheckDataSetAdded(const AItem: TADLocalSQLDataSet);
begin
  if GetActualActive then begin
    DataSets.CheckUnique(AItem);
    InternalDataSetAdded(AItem);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.CheckDataSetRemoving(const AItem: TADLocalSQLDataSet);
begin
  if GetActualActive then
    InternalDataSetRemoving(AItem);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.DoConnectChanged(Sender: TObject; Connecting: Boolean);
begin
  if Connecting then
    CheckActivate
  else
    CheckDeactivate;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.SetConnection(const AValue: TADCustomConnection);
begin
  if FConnection <> AValue then begin
    if FConnection <> nil then begin
      CheckDeactivate;
      FConnection.UnRegisterClient(Self);
    end;
    FConnection := AValue;
    if FConnection <> nil then begin
      FConnection.RegisterClient(Self, DoConnectChanged);
      FConnection.FreeNotification(Self);
      CheckActivate;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomLocalSQL.FindDataSet(const ASchema, AName: String): IADPhysLocalQueryAdapter;
var
  i: Integer;
  oDS: TADLocalSQLDataSet;
begin
  Result := nil;
  if csDestroying in ComponentState then
    Exit;
  for i := 0 to DataSets.Count - 1 do begin
    oDS := DataSets[i];
    if oDS.IsValid and (CompareText(oDS.ActualName, AName) = 0) then begin
      Result := oDS.Adapter;
      Break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomLocalSQL.DataSetNotFound(const AName: String): Boolean;
var
  oDS: TDataSet;
  oAdapt: IADPhysLocalQueryAdapter;
begin
  Result := False;
  if csDestroying in ComponentState then
    Exit;
  if Assigned(OnGetDataSet) and (FindDataSet('', AName) = nil) then begin
    oDS := nil;
    oAdapt := nil;
    OnGetDataSet(Self, AName, oDS, oAdapt);
    if (oDS <> nil) or (oAdapt <> nil) then begin
      DataSets.Add(oDS, AName, oAdapt).Temporary := True;
      Result := True;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomLocalSQL.ReadDataSet(const ASchema, AName: String;
  ADataSet: TObject);
begin
  if csDestroying in ComponentState then
    Exit;
  if Assigned(OnReadDataSet) then
    OnReadDataSet(Self, AName, TDataSet(ADataSet));
end;

{-------------------------------------------------------------------------------}
{ TADAdaptedDataSet                                                             }
{-------------------------------------------------------------------------------}
constructor TADAdaptedDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFNDEF AnyDAC_FPC}
  NestedDataSetClass := TADCustomMemTable;
{$ENDIF}
  FDatSManager := TADDatSManager.Create;
  FDatSManager.UpdatesRegistry := True;
  FDatSManager.CountRef;
end;

{-------------------------------------------------------------------------------}
destructor TADAdaptedDataSet.Destroy;
begin
  LocalSQL := nil;
  ADFreeAndNil(FVclParams);
  SetDatSManager(nil);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.Notification(AComponent: TComponent;
  AOperation: TOperation);
begin
  inherited Notification(AComponent, AOperation);
  if AOperation = opRemove then
    if AComponent = UpdateObject then
      UpdateObject := nil
    else if AComponent = Adapter then begin
      Disconnect(True);
      SetAdapter(nil);
    end
    else if AComponent = Command then
      Disconnect(True)
    else if AComponent = LocalSQL then
      LocalSQL := nil;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetCommand: TADCustomCommand;
begin
  if Adapter <> nil then
    Result := Adapter.SelectCommand
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetParams: TADParams;
begin
  if Command <> nil then
    Result := Command.Params
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.SetLocalSQL(const AValue: TADCustomLocalSQL);
begin
  if FLocalSQL <> AValue then begin
    if FLocalSQL <> nil then
      FLocalSQL.DataSets.Remove(Self);
    FLocalSQL := AValue;
    if FLocalSQL <> nil then begin
      FLocalSQL.DataSets.Add(Self).Temporary := True;
      FLocalSQL.FreeNotification(Self);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.CheckOnline(APrepare: Boolean = True);
var
  oConn: TADCustomConnection;
begin
  if Command <> nil then begin
    oConn := Command.GetConnection(False);
    if oConn <> nil then
      oConn.CheckOnline;
    if not Command.Prepared and APrepare then
      DoPrepareSource;
    if (Command.CommandIntf = nil) or
       (Command.CommandIntf <> FAdapter.TableAdapterIntf.SelectCommand) then
      FAdapter.UpdateAdapterCmd(arSelect);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ReleaseBase(AOffline: Boolean);
var
  oConn: TADCustomConnection;
begin
  if Command <> nil then begin
    oConn := PointedConnection;
    if Active and (oConn <> nil) and
       ((oConn.ConnectionIntf = nil) or (oConn.ConnectionIntf.State = csRecovering)) then
      FSourceEOF := True;
  end;
  inherited ReleaseBase(AOffline);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.InternalUpdateErrorHandler(ASender: TObject;
  const AInitiator: IADStanObject; var AException: Exception);
var
  eAction: TADErrorAction;
  oConn: TADCustomConnection;
  oUpdExc: EADDAptRowUpdateException;
  oArrErr: EADDBArrayExecuteError;
begin
  if AException is EADDAptRowUpdateException then begin
    oUpdExc := EADDAptRowUpdateException(AException);
    eAction := oUpdExc.Action;
    DoUpdateErrorHandler(oUpdExc.Row, oUpdExc.Exception, oUpdExc.Request, eAction);
    oUpdExc.Action := eAction;
  end
  else if AException is EADDBArrayExecuteError then begin
    if Assigned(FOnExecuteError) then begin
      oArrErr := EADDBArrayExecuteError(AException);
      eAction := oArrErr.Action;
      FOnExecuteError(Self, oArrErr.Times, oArrErr.Offset, oArrErr.Exception, eAction);
      oArrErr.Action := eAction;
    end;
  end
  else begin
    if Assigned(FOnError) then
      FOnError(Self, AInitiator, AException);
    if (Command <> nil) and (AException <> nil) then begin
      oConn := Command.GetConnection(False);
      if oConn <> nil then
        oConn.HandleException(AInitiator, AException);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.InternalUpdateRecordHandler(ASender: TObject;
  ARow: TADDatSRow; ARequest: TADUpdateRequest; AOptions: TADUpdateRowOptions;
  var AAction: TADErrorAction);
begin
  DoUpdateRecordHandler(ARow, ARequest, AOptions, AAction);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.InternalReconcileErrorHandler(ASender: TObject;
  ARow: TADDatSRow; var AAction: TADDAptReconcileAction);
begin
  DoReconcileErrorHandler(ARow, ARow.RowError, ARow.RowState, AAction);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.SetAdapter(AAdapter: TADCustomTableAdapter);
begin
  if (AAdapter <> nil) and (AAdapter.FAdaptedDataSet <> nil) then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntCantShareAdapt,
      [AAdapter.Name, GetDisplayName, AAdapter.FAdaptedDataSet.GetDisplayName]);
  if FAdapter <> AAdapter then begin
    if FAdapter <> nil then begin
      FAdapter.RemoveFreeNotification(Self);
      if (FAdapter.SchemaAdapter <> nil) and
         (FAdapter.SchemaAdapter.DatSManager = DatSManager) then
        DatSManager := nil
      else
        FAdapter.DatSManager := nil;
      if FAdapter.SelectCommand <> nil then
        FAdapter.SelectCommand.RemoveFreeNotification(Self);
      FAdapter.FAdaptedDataSet := nil;
      if FUpdateObject <> nil then
        FUpdateObject.DetachFromAdapter;
    end;
    FAdapter := AAdapter;
    if FAdapter <> nil then begin
      FAdapter.FreeNotification(Self);
      if FAdapter.SchemaAdapter <> nil then
        DatSManager := FAdapter.SchemaAdapter.DatSManager
      else
        FAdapter.DatSManager := DatSManager;
      if FAdapter.SelectCommand <> nil then
        FAdapter.SelectCommand.FreeNotification(Self);
      FAdapter.FAdaptedDataSet := Self;
      if FUpdateObject <> nil then
        FUpdateObject.AttachToAdapter;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.SetDatSManager(AManager: TADDatSManager);
begin
  if FDatSManager <> AManager then begin
    if (AManager = nil) or
       (Table <> nil) and (AManager.Tables.IndexOf(Table) = -1) or
       (View <> nil) and (AManager.Tables.IndexOf(View.Table) = -1) then
      AttachTable(nil, nil);
    if Adapter <> nil then
      Adapter.DatSManager := nil;
    if FDatSManager <> nil then begin
      FDatSManager.RemRef;
      FDatSManager := nil;
    end;
    FDatSManager := AManager;
    if FDatSManager <> nil then
      FDatSManager.AddRef;
    if Adapter <> nil then
      Adapter.DatSManager := AManager;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.AttachTable(ATable: TADDatSTable; AView: TADDatSView);
begin
  inherited AttachTable(ATable, AView);
  if (Table <> nil) and (DatSManager <> nil) and
     (Adapter <> nil) and (Adapter.DatSManager = DatSManager) and
     (Adapter.DatSTable <> Table) then
    Adapter.DatSTable := Table;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoCloneCursor(AReset, AKeepSettings: Boolean);
begin
  DatSManager := CloneSource.DatSManager;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.SetUpdateObject(const AValue: TADCustomUpdateObject);
begin
  if FUpdateObject <> AValue then begin
    if (AValue <> nil) and (AValue.DataSet <> nil) then
      AValue.DataSet.UpdateObject := nil;
    if (FUpdateObject <> nil) and (FUpdateObject.DataSet = Self) then begin
      FUpdateObject.RemoveFreeNotification(Self);
      if Adapter <> nil then
        FUpdateObject.DetachFromAdapter;
      FUpdateObject.FDataSet := nil;
    end;
    FUpdateObject := AValue;
    if FUpdateObject <> nil then begin
      FUpdateObject.FDataSet := Self;
      if Adapter <> nil then
        FUpdateObject.AttachToAdapter;
      FUpdateObject.FreeNotification(Self);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.NextRecordSet;
begin
  if Command <> nil then begin
    CheckOnline;
    DisableControls;
    Command.CommandIntf.NextRecordSet := True;
    try
      Close;
      Command.PropertyChange;
      DoOpenSource(True, False, False);
      if Command.Active then begin
        Open;
        FForcePropertyChange := True;
      end
      else
        FForcePropertyChange := False;
    finally
      if Command.CommandIntf <> nil then
        Command.CommandIntf.NextRecordSet := False;
      EnableControls;
    end;
  end
  else
    Close;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.GetResults;
begin
  DisableControls;
  StartWait;
  try
    repeat
      NextRecordSet;
    until not Active;
  finally
    StopWait;
    EnableControls;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.AbortJob(AWait: Boolean = False);
begin
  if Command <> nil then
    Command.AbortJob(AWait);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.InternalClose;
begin
  ServerCancel;
  inherited InternalClose;
  if FForcePropertyChange then begin
    FForcePropertyChange := False;
    if Command <> nil then
      Command.PropertyChange;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.Disconnect(AAbortJob: Boolean = False);
begin
  if AAbortJob then
    AbortJob(True);
  inherited Disconnect(AAbortJob);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.InternalServerEdit(AServerEditRequest: TADUpdateRequest);
begin
  if (Adapter = nil) or (FServerEditRequest <> arNone) then
    Exit;
  CheckOnline;
  CheckBrowseMode;
  FServerEditRow := Table.NewRow(False);
  FServerEditRequest := AServerEditRequest;
  BeginForceRow(FServerEditRow, True, False);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerAppend;
begin
  if Adapter = nil then
    Append
  else
    InternalServerEdit(arInsert);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerDelete;
begin
  InternalServerEdit(arDelete);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerEdit;
begin
  InternalServerEdit(arUpdate);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerPerform;
var
  eAction: TADErrorAction;
begin
  if (Adapter = nil) and (State = dsInsert) then
    Post
  else begin
    CheckOnline;
    CheckBrowseMode;
    if FServerEditRequest <> arNone then begin
      StartWait;
      try
        if Adapter <> nil then begin
          eAction := eaApplied;
          Adapter.Update(FServerEditRow, eAction, [], FServerEditRequest);
        end;
      finally
        StopWait;
        ServerCancel;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerCancel;
begin
  if (Adapter = nil) and (State = dsInsert) then
    Cancel
  else if FServerEditRequest <> arNone then begin
    EndForceRow;
    ADFreeAndNil(FServerEditRow);
    FServerEditRequest := arNone;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerDeleteAll(ANoUndo: Boolean);
var
  oGen: IADPhysCommandGenerator;
  oCmd: IADPhysCommand;
  oConn: TADCustomConnection;
  oConnMeta: IADPhysConnectionMetadata;
begin
  CheckOnline;
  if Adapter <> nil then begin
    StartWait;
    try
      oConn := PointedConnection;
      oConn.ConnectionIntf.CreateMetadata(oConnMeta);
      if ANoUndo and oConnMeta.TruncateSupported then
        while oConn.InTransaction do
          oConn.Commit;
      oConn.ConnectionIntf.CreateCommandGenerator(oGen, nil);
      oGen.MappingHandler := Adapter.TableAdapterIntf as IADPhysMappingHandler;
      oConn.ConnectionIntf.CreateCommand(oCmd);
      oCmd.CommandText := oGen.GenerateDeleteAll(ANoUndo);
      oCmd.CommandKind := oGen.CommandKind;
      oCmd.Prepare;
      oCmd.Execute;
    finally
      StopWait;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.ServerSetKey;
begin
  { TODO -cCLNT : To implement ServerSetKey }
  raise Exception.Create('Not implemented');
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.ServerGotoKey: Boolean;
begin
  { TODO -cCLNT : To implement ServerGotoKey }
  raise Exception.Create('Not implemented');
  Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoMasterDefined;
begin
  if Command <> nil then
    inherited DoMasterDefined;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoMasterParamSetValues(AMasterFieldList: TADFieldList);
begin
  if Command <> nil then
    inherited DoMasterParamSetValues(AMasterFieldList);
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoMasterParamDependent(AMasterFieldList: TADFieldList): Boolean;
begin
  if Command <> nil then
    Result := inherited DoMasterParamDependent(AMasterFieldList)
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoPrepareSource;
var
  oConn: TADCustomConnection;
begin
  if (Command <> nil) and (Command.State = csInactive) then begin
    oConn := PointedConnection;
    if (LocalSQL <> nil) and (LocalSQL.Connection = oConn) and
       not oConn.Connected and oConn.ResourceOptions.AutoConnect then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntLocalSQLMisuse,
        [GetDisplayName]);
    FieldDefs.Updated := False;
    IndexDefs.Updated := False;
    DoMasterDefined;
    Command.Prepare;
    FAdapter.UpdateAdapterCmd(arSelect);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoUnprepareSource;
begin
  if FUnpreparing then
    Exit;
  FUnpreparing := True;
  try
    if Command <> nil then begin
      if Command.State <> csInactive then begin
        if not (dfOfflining in FFlags) then begin
          FieldDefs.Updated := False;
          IndexDefs.Updated := False;
        end
        else
          Command.AbortJob(False);
      end;
      if Command.CommandIntf <> nil then
        Command.Unprepare;
    end;
    if Adapter <> nil then
      Adapter.Reset;
  finally
    FUnpreparing := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoDefineDatSManager;
var
  oTab: TADDatSTable;
begin
  if Command <> nil then begin
    CheckOnline;
    oTab := Adapter.Define;
    AttachTable(oTab, nil);
    // if to call TADAdaptedDataSet.Open for command returning resultset without columns,
    // then it will be executed twice:
    // - here at Adapter.Define call -> state remains csPrepared, so second time ...
    // - at TADDataSet.InternalOpen.DoOpenSource
    if Command.State = csPrepared then
      FSourceEOF := True;
  end
  else
    inherited DoDefineDatSManager;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoOpenSource(ABlocked, AInfoQuery, AStructQuery: Boolean);
begin
  if Command <> nil then begin
    CheckOnline;
    if Command.State = csPrepared then
      Command.Open(ABlocked);
  end;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoIsSourceOpen: Boolean;
begin
  Result := (Command <> nil) and (Command.State = csOpen);
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoIsSourceAsync: Boolean;
begin
  Result := inherited DoIsSourceAsync and
    not ((Command <> nil) and (Command.CommandIntf <> nil) and
        Command.CommandIntf.NextRecordSet);
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoIsSourceOnline: Boolean;
var
  oConn: TADCustomConnection;
begin
  Result := inherited DoIsSourceOnline;
  if Command <> nil then begin
    oConn := Command.GetConnection(False);
    if oConn <> nil then
      Result := not oConn.Offlined and oConn.Connected;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoCloseSource;
begin
  if Command <> nil then begin
    if Command.State = csOpen then
      Command.Close;
  end
  else
    inherited DoCloseSource;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoResetDatSManager;
var
  oMgr: TADDatSManager;
begin
  inherited DoResetDatSManager;
  AttachTable(nil, nil);
  if DatSManager <> nil then begin
    if (Adapter <> nil) and (Adapter.DatSTable <> nil) and
       (Adapter.DatSTable.Manager = DatSManager) then
      Adapter.DatSTable := nil;
    if ((Adapter <> nil) and (Adapter.DatSManager = DatSManager) and (DatSManager.Refs > 2) or
        (Adapter = nil) and (DatSManager.Refs > 1)) then begin
      if not (csDestroying in ComponentState) then begin
        oMgr := TADDatSManager.Create;
        oMgr.UpdatesRegistry := True;
        oMgr.CountRef(0);
        DatSManager := oMgr;
      end;
    end
    else
      DatSManager.Reset;
  end;
  ASSERT(Table = nil); // else we need Table.Reset;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoGetDatSManager: TADDatSManager;
begin
  Result := FDatSManager;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoGetTableName: String;
var
  eCmdKind: TADPhysCommandKind;
  oCmd: TADCustomCommand;
  oRes: TADResourceOptions;
begin
  Result := '';
  oCmd := Command;
  if oCmd <> nil then begin
    if oCmd.CommandIntf <> nil then
      Result := oCmd.CommandIntf.SourceObjectName;
    if Result = '' then begin
      eCmdKind := skUnknown;
      oRes := ResourceOptions;
      oCmd.PreprocessSQL(oCmd.CommandText.Text, oCmd.Params, nil, oCmd.Macros,
        False, False, oRes.MacroExpand, oRes.EscapeExpand, True, eCmdKind, Result);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoFetch(ATable: TADDatSTable; AAll: Boolean;
  ADirection: TADFetchDirection = fdDown): Integer;
begin
  if (ADirection = fdDown) and (Command <> nil) and (Command.State = csOpen) then begin
    ASSERT(Adapter.DatSTable = ATable);
    Adapter.Fetch(AAll);
    Result := Command.RowsAffected;
  end
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoFetch(ARow: TADDatSRow; AColumn: Integer;
  ARowOptions: TADPhysFillRowOptions): Boolean;
var
  eAction: TADErrorAction;
begin
  eAction := eaDefault;
  if Adapter <> nil then
    Adapter.Fetch(ARow, eAction, AColumn, ARowOptions);
  Result := eAction in [eaApplied, eaExitSuccess];
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoClearBeforeRefetch;
var
  oFtch: TADFetchOptions;
begin
  if Command <> nil then
    inherited DoClearBeforeRefetch
  else begin
    oFtch := FetchOptions;
    if not (fiDetails in oFtch.Cache) then
      oFtch.Cache := oFtch.Cache + [fiDetails];
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoExecuteSource(ATimes, AOffset: Integer);
begin
  if Command <> nil then begin
    CheckOnline;
    Command.Execute(ATimes, AOffset);
  end;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoApplyUpdates(ATable: TADDatSTable; AMaxErrors: Integer): Integer;
begin
  if Adapter <> nil then begin
    CheckOnline(False);
    ASSERT(Adapter.DatSTable = ATable);
    Result := Adapter.ApplyUpdates(AMaxErrors);
  end
  else
    Result := inherited DoApplyUpdates(ATable, AMaxErrors);
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.DoProcessUpdateRequest(ARequest: TADUpdateRequest;
  AOptions: TADUpdateRowOptions);
var
  oConn: TADCustomConnection;
  oRow: TADDatSRow;
  eAction: TADErrorAction;
begin
  if ParentDataSet <> nil then
    TADAdaptedDataSet(ParentDataSet).DoProcessUpdateRequest(ARequest, AOptions)
  else if UpdateOptions.CheckRequest(ARequest, AOptions, CachedUpdates) then begin
    oConn := PointedConnection;
    oRow := GetRow(PADBuffer(ActiveBuffer));
    eAction := eaApplied;
    if not (csDestroying in ComponentState) and (Adapter <> nil) and
       ((oConn = nil) or (oConn.ConnectionIntf = nil) or
        (oConn.ConnectionIntf.State <> csRecovering)) then begin
      CheckOnline(False);
      case ARequest of
      arLock:   Adapter.Lock(oRow, eAction, AOptions);
      arUnLock: Adapter.UnLock(oRow, eAction, AOptions);
      arFetchGenerators,
      arInsert,
      arUpdate,
      arDelete: Adapter.Update(oRow, eAction, AOptions, ARequest);
      end;
    end
    else
      inherited DoProcessUpdateRequest(ARequest, AOptions);
  end;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetOptionsIntf: IADStanOptions;
begin
  Result := Command.OptionsIntf;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.SetOptionsIntf(const AValue: IADStanOptions);
begin
  Command.OptionsIntf := AValue;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetConnection(ACheck: Boolean): TADCustomConnection;
begin
  if Command <> nil then
    Result := Command.GetConnection(ACheck)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.GetPointedConnection: TADCustomConnection;
begin
  Result := GetConnection(False);
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.DoStoredActivation: Boolean;
var
  eUsage: TADStoredActivationUsage;
begin
  eUsage := ADManager.ActiveStoredUsage;
  if PointedConnection <> nil then
    eUsage := eUsage * PointedConnection.ConnectedStoredUsage;
  Result := ADCheckStoredUsage(ComponentState, eUsage * ActiveStoredUsage);
end;

{-------------------------------------------------------------------------------}
{ IProviderSupport }

function TADAdaptedDataSet.PSInTransaction: Boolean;
var
  oConn: TADCustomConnection;
begin
  oConn := GetConnection(False);
  Result := (oConn <> nil) and oConn.InTransaction;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.PSStartTransaction;
var
  oConn: TADCustomConnection;
begin
  oConn := GetConnection(False);
  if oConn <> nil then begin
    oConn.CheckOnline;
    oConn.StartTransaction;             
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.PSEndTransaction(Commit: Boolean);
var
  oConn: TADCustomConnection;
begin
  oConn := GetConnection(False);
  if oConn <> nil then begin
    oConn.CheckOnline;
    if Commit then
      oConn.Commit
    else
      oConn.Rollback;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSIsSQLBased: Boolean;
var
  oConn: TADCustomConnection;
begin
  oConn := GetConnection(False);
  Result := (oConn <> nil) and oConn.IsSQLBased;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSIsSQLSupported: Boolean;
begin
  Result := PSIsSQLBased;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSGetQuoteChar: string;
var
  oConn: TADCustomConnection;
  oConnMeta: IADPhysConnectionMetadata;
  eQuote: TADPhysNameQuoteLevel;
begin
  Result := '"';
  oConn := GetConnection(False);
  if oConn <> nil then begin
    oConn.CheckOnline;
    oConnMeta := oConn.GetConnectionMetadata;
    if oConnMeta <> nil then
      for eQuote := Low(TADPhysNameQuoteLevel) to High(TADPhysNameQuoteLevel) do
        // TSQLResolver supports only single quote char for both start and end
        if not ADInSet(oConnMeta.NameQuoteChar[eQuote, nsLeft], [#0, ' ']) and
           (oConnMeta.NameQuoteChar[eQuote, nsLeft] = oConnMeta.NameQuoteChar[eQuote, nsRight]) then begin
          Result := oConnMeta.NameQuoteChar[eQuote, nsLeft];
          Break;
        end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSGetParams: TParams;
begin
  if Command <> nil then begin
    if FVclParams = nil then
      FVclParams := TParams.Create;
    FVclParams.Assign(Params);
    Result := FVclParams;
  end
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.PSSetParams(AParams: TParams);
begin
  if Command <> nil then begin
    if AParams.Count <> 0 then
      Params.Assign(AParams);
    Close;
  end;
end;

{$IFDEF AnyDAC_FullIPS}
{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSGetCommandText: string;
begin
  if Command <> nil then
    Result := Command.CommandText.Text
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSGetCommandType: TPSCommandType;
begin
  Result := ctUnknown;
  if Command <> nil then
    case Command.CommandKind of
    skSelect,
    skSelectForLock,
    skSelectForUnLock: Result := ctSelect;
    skDelete:          Result := ctDelete;
    skInsert,
    skMerge:           Result := ctInsert;
    skUpdate:          Result := ctUpdate;
    skCreate,
    skAlter,
    skDrop:            Result := ctDDL;
    skStoredProc,
    skStoredProcWithCrs,
    skStoredProcNoCrs: Result := ctStoredProc;
    end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.PSSetCommandText(const CommandText: string);
begin
  if Command <> nil then
    Command.SetCommandText(CommandText, False);
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.InternalPSExecuteStatement(const ASQL: string;
  AParams: TParams; AMode: Integer; var AResultSet: TADQuery): Integer;
begin
  Result := 0;
  CheckOnline(False);
  AResultSet := TADQuery.Create(nil);
  try
    AResultSet.OptionsIntf.ParentOptions := OptionsIntf;
    AResultSet.FormatOptions.DataSnapCompatibility := True;
    AResultSet.ResourceOptions.ParamCreate := False;
    AResultSet.ResourceOptions.MacroCreate := False;
    AResultSet.ResourceOptions.MacroExpand := False;
    AResultSet.Connection := GetConnection(True);
    if Command <> nil then
      AResultSet.Transaction := Command.Transaction;
    AResultSet.Command.SetCommandText(ASQL, False);
    AResultSet.Params.Assign(AParams);
    case AMode of
    0:
      begin
        AResultSet.ExecSQL;
        Result := AResultSet.RowsAffected;
      end;
    1:
      begin
        AResultSet.Open;
        Result := AResultSet.RecordCount;
      end;
    2:
      if AResultSet.OpenOrExecute then
        Result := AResultSet.RecordCount
      else
        Result := AResultSet.RowsAffected;
    end;
  except
    ADFreeAndNil(AResultSet);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSExecuteStatement(const ASQL: string;
  AParams: TParams; AResultSet: Pointer = nil): Integer;
var
  oQry: TADQuery;
begin
  oQry := nil;
  try
    Result := InternalPSExecuteStatement(ASQL, AParams, Integer(Assigned(AResultSet)), oQry);
  finally
    if Assigned(AResultSet) then
      TADQuery(AResultSet^) := oQry
    else
      ADFree(oQry);
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D17}
function TADAdaptedDataSet.PSExecuteStatement(const ASQL: string;
  AParams: TParams; var AResultSet: TDataSet): Integer;
var
  oQry: TADQuery;
begin
  oQry := nil;
  try
    Result := InternalPSExecuteStatement(ASQL, AParams, 2, oQry);
  finally
    AResultSet := oQry;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAdaptedDataSet.PSExecuteStatement(const ASQL: string;
  AParams: TParams): Integer;
var
  oQry: TADQuery;
begin
  oQry := nil;
  try
    Result := InternalPSExecuteStatement(ASQL, AParams, 0, oQry);
  finally
    ADFree(oQry);
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADAdaptedDataSet.PSGetAttributes(AList:
  {$IFDEF AnyDAC_D18} TPacketAttributeList {$ELSE} TList {$ENDIF});
begin
{$IFNDEF AnyDAC_FPC}
  inherited PSGetAttributes(AList);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{ TADCustomMemTable                                                             }
{-------------------------------------------------------------------------------}
constructor TADCustomMemTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FetchOptions.Mode := fmAll;
  ResourceOptions.SilentMode := True;
  UpdateOptions.CheckRequired := False;
end;

{-------------------------------------------------------------------------------}
destructor TADCustomMemTable.Destroy;
begin
  Close;
  Destroying;
  inherited Destroy;
  Adapter := nil;
  if FOptionsIntf <> nil then begin
    FOptionsIntf.ObjectDestroyed(Self);
    FOptionsIntf := nil;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetOptionsIntf: IADStanOptions;
begin
  if Command = nil then begin
    if FOptionsIntf = nil then
      FOptionsIntf := TADOptionsContainer.Create(Self, TADFetchOptions,
        TADBottomUpdateOptions, TADBottomResourceOptions, GetParentOptions);
    Result := FOptionsIntf;
  end
  else begin
    if FOptionsIntf <> nil then begin
      // Override the command options by the ADMemTable options
      Command.FetchOptions := FOptionsIntf.FetchOptions;
      Command.FormatOptions := FOptionsIntf.FormatOptions;
      Command.UpdateOptions := FOptionsIntf.UpdateOptions as TADBottomUpdateOptions;
      Command.ResourceOptions := FOptionsIntf.ResourceOptions as TADBottomResourceOptions;
      // And switch to the command options usage
      FOptionsIntf := nil;
    end;
    Result := inherited GetOptionsIntf;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.GetParentOptions(out AOpts: IADStanOptions);
begin
  if Command <> nil then
    Command.GetParentOptions(AOpts)
  else begin
    if FManagerOptsIntf = nil then
      ADManager();
    AOpts := FManagerOptsIntf;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_FPC}
procedure TADCustomMemTable.DefChanged(ASender: TObject);
begin
  FStoreDefs := True;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADCustomMemTable.SaveToDFM: Boolean;
begin
  Result := (DataSetField = nil) and (ParentDataSet = nil) and (DoGetDatSManager <> nil) and
    Active and (FStorage = nil) and ResourceOptions.Persistent and (ResourceOptions.PersistentFileName = '');
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetCommandText: TADWideString;
begin
  if Command <> nil then
    Result := Command.CommandText.Text
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetDisableStringTrim: Boolean;
begin
  Result := not FormatOptions.StrsTrim;
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetFetchOnDemand: Boolean;
begin
  Result := FetchOptions.Mode = fmOnDemand;
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetIsClone: Boolean;
var
  oBaseDS: TADDataSet;
begin
  oBaseDS := Self;
{$IFNDEF AnyDAC_FPC}
  while Assigned(oBaseDS.DataSetField) do
    oBaseDS := oBaseDS.DataSetField.DataSet as TADDataSet;
{$ENDIF}
  Result := Assigned(oBaseDS.CloneSource);
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetLogChanges: Boolean;
begin
  Result := CachedUpdates;
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetProviderEOF: Boolean;
begin
  Result := SourceEOF;
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetReadOnly: Boolean;
begin
  Result := UpdateOptions.ReadOnly;
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetStatusFilter: TADUpdateRecordTypes;
begin
  Result := FilterChanges;
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetXMLData: string;
var
  oStr: TStringStream;
begin
  oStr := TStringStream.Create('');
  try
    SaveToStream(oStr, sfXML);
    Result := oStr.DataString;
  finally
    ADFree(oStr);
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetPacketRecords: Integer;
begin
  Result := FetchOptions.RowsetSize;
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetFileName: string;
begin
  Result := ResourceOptions.PersistentFileName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.SetCommandText(const AValue: TADWideString);
begin
  if Command <> nil then
    Command.CommandText.Text := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.SetDisableStringTrim(const AValue: Boolean);
begin
  FormatOptions.StrsTrim := not AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.SetFetchOnDemand(const AValue: Boolean);
begin
  if AValue then
    FetchOptions.Mode := fmOnDemand
  else
    FetchOptions.Mode := fmManual;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.SetLogChanges(const AValue: Boolean);
begin
  CachedUpdates := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.SetProviderEOF(const AValue: Boolean);
begin
  FSourceEOF := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.SetReadOnly(const AValue: Boolean);
begin
  UpdateOptions.ReadOnly := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.SetStatusFilter(const AValue: TADUpdateRecordTypes);
begin
  FilterChanges := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.SetXMLData(const AValue: string);
var
  oStr: TStringStream;
begin
  oStr := TStringStream.Create(AValue);
  try
    LoadFromStream(oStr, sfXML);
  finally
    ADFree(oStr);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.SetFileName(const AValue: string);
begin
  ResourceOptions.PersistentFileName := AValue
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.SetPacketRecords(const AValue: Integer);
begin
  FetchOptions.RowsetSize := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.AppendData(const AData: IADDataSetReference; AHitEOF: Boolean = True);
begin
  if Active then begin
    if (AData <> nil) and (AData.DataView <> nil) then begin
      Table.Import(AData.DataView);
      Resync([]);
    end;
  end
  else
    Data := AData;
  if AHitEOF then
    FSourceEOF := True;
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.ConstraintsDisabled: Boolean;
begin
  Result := not ConstraintsEnabled;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.MergeChangeLog;
begin
  CommitUpdates;
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetOptionalParamTab: TADDatSTable;
var
  i: Integer;
  sTabName: String;
begin
  sTabName := C_AD_SysNamePrefix + 'OPTIONAL_PARAMS';
  i := DatSManager.Tables.IndexOfName(sTabName);
  if i >= 0 then
    Result := DatSManager.Tables[i]
  else
    Result := DatSManager.Tables.Add(sTabName);
end;

{-------------------------------------------------------------------------------}
function TADCustomMemTable.GetOptionalParam(const AParamName: string): Variant;
var
  oTab: TADDatSTable;
  iCol: Integer;
begin
  oTab := GetOptionalParamTab;
  iCol := oTab.Columns.IndexOfName(AParamName);
  if (iCol = -1) or (oTab.Rows.Count <> 1) then
    Result := Unassigned
  else
    Result := oTab.Rows[0].GetData(iCol);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomMemTable.SetOptionalParam(const AParamName: string;
  const AValue: Variant; AIncludeInDelta: Boolean);

  function GetValueType: TADDataType;
  var
    tp: Word;
  begin
    tp := VarType(AValue);
    case tp of
{$IFDEF AnyDAC_D6Base}
      varShortInt:
        Result := dtSByte;
{$ENDIF}
      varByte:
        Result := dtByte;
      varSmallint:
        Result := dtInt16;
{$IFDEF AnyDAC_D6Base}
      varWord:
        Result := dtUInt16;
      varLongWord:
        Result := dtUInt32;
{$ENDIF}
      varInteger:
        Result := dtInt32;
      varCurrency:
        Result := dtCurrency;
      varSingle:
        Result := dtSingle;
      varDouble:
        Result := dtDouble;
      varDate:
        Result := dtDateTime;
      varBoolean:
        Result := dtBoolean;
{$IFDEF AnyDAC_D12}
      varUString,
{$ENDIF}
      varString,
      varOleStr:
        Result := dtWideMemo;
{$IFDEF AnyDAC_D12}
      varUInt64,
{$ENDIF}
{$IFDEF FPC}
      varqword,
{$ENDIF}
      varInt64:
        Result := dtInt64;
      varArray or varByte:
        Result := dtBlob;
    else
{$IFDEF AnyDAC_D6Base}
      if tp = VarFMTBcd then
        Result := dtFmtBCD
  {$IFDEF AnyDAC_D6}
      else if tp = VarSQLTimeStamp then
        Result := dtDateTimeStamp
      else if tp = ADVarSQLTimeInterval then
        Result := dtTimeIntervalFull
  {$ENDIF}
      else
{$ENDIF}
        Result := dtBlob;
      end;
    end;

var
  oTab, oTab2: TADDatSTable;
  iCol: Integer;
  oRow: TADDatSRow;
begin
  oTab := GetOptionalParamTab;
  iCol := oTab.Columns.IndexOfName(AParamName);
  if (oTab.Rows.Count > 0) and (iCol = -1) then begin
    oTab2 := TADDatSTable.Create;
    oTab2.Columns.Assign(oTab.Columns);
    iCol := oTab2.Columns.Add(AParamName, GetValueType).Index;
    oTab2.ImportRow(oTab.Rows[0]);
    ADFree(oTab);
    oTab2.Name := C_AD_SysNamePrefix + 'OPTIONAL_PARAMS';
    DatSManager.Tables.Add(oTab2);
    oTab := oTab2;
  end
  else if (oTab.Rows.Count = 0) and (iCol = -1) then begin
    iCol := oTab.Columns.Add(AParamName, GetValueType).Index;
    oTab.Rows.Add([]);
  end;
  oRow := oTab.Rows[0];
  oRow.BeginEdit;
  oRow.SetData(iCol, AValue);
  oRow.EndEdit(True);
end;

{-------------------------------------------------------------------------------}
{ TADRdbmsDataSet                                                               }
{-------------------------------------------------------------------------------}
constructor TADRdbmsDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetAdapter(InternalCreateAdapter);
  Command.FOwner := Self;
  FAutoCommitUpdates := False;
  if ADIsDesigning(Self) then
    Connection := ADFindDefaultConnection(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADRdbmsDataSet.Destroy;
begin
  Destroying;
  Disconnect(True);
  Connection := nil;
  ConnectionName := '';
  Transaction := nil;
  inherited Destroy;
  if Command <> nil then
    Command.FOwner := nil;
  ADFreeAndNil(FAdapter);
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.Loaded;
begin
  inherited Loaded;
  try
    if FStreamedPrepared and DoStoredActivation then
      SetPrepared(True);
  except
    if csDesigning in ComponentState then
      InternalHandleException
    else
      raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.DefineProperties(AFiler: TFiler);
begin
  inherited DefineProperties(AFiler);
  Command.DefineProperties(AFiler);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.InternalCreateAdapter: TADCustomTableAdapter;
begin
  Result := TADTableAdapter.Create(nil);
  Result.SelectCommand := TADCommand.Create(Result);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetConnection: TADCustomConnection;
begin
  if Command = nil then
    Result := nil
  else
    Result := Command.Connection;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetConnection(const AValue: TADCustomConnection);
begin
  if Connection <> AValue then begin
    Disconnect(True);
    Command.Connection := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetConnectionName: String;
begin
  if Command = nil then
    Result := ''
  else
    Result := Command.ConnectionName;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetConnectionName(const AValue: String);
begin
  if ConnectionName <> AValue then
    Command.ConnectionName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.IsCNNS: Boolean;
begin
  Result := not IsCNS;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.IsCNS: Boolean;
begin
  Result := (Connection <> nil) and
    (Connection.Name <> '') and (Connection.Owner <> nil) and
    (Connection.ConnectionName = ConnectionName);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetTransaction: TADCustomTransaction;
begin
  if Command = nil then
    Result := nil
  else
    Result := Command.Transaction;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetTransaction(const AValue: TADCustomTransaction);
begin
  if Transaction <> AValue then
    Command.Transaction := AValue;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetUpdateTransaction: TADCustomTransaction;
begin
  Result := Adapter.UpdateTransaction;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetUpdateTransaction(const AValue: TADCustomTransaction);
begin
  Adapter.UpdateTransaction := AValue;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetSchemaAdapter: TADCustomSchemaAdapter;
begin
  Result := Adapter.SchemaAdapter;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetSchemaAdapter(const AValue: TADCustomSchemaAdapter);
begin
  CheckInactive;
  Adapter.SchemaAdapter := AValue;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetPrepared: Boolean;
begin
  Result := Command.Prepared;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetPrepared(const AValue: Boolean);
begin
  if csReading in ComponentState then
    FStreamedPrepared := AValue
  else if (Command <> nil) and
    // The second OR part protects against the case, when the command interface was
    // created with ckCreateIntfDontPrepare in FFlags. Without it an app may run
    // into "ADPhysManager timeout". See AD-0250 for details.
          ((Command.Prepared <> AValue) or not AValue and (Command.CommandIntf <> nil)) then begin
    if AValue then
      DoPrepareSource
    else
      DoUnprepareSource;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.ReleaseBase(AOffline: Boolean);
var
  oAdapt: IADDAptTableAdapter;
begin
  inherited ReleaseBase(AOffline);
  if Adapter <> nil then begin
    oAdapt := Adapter.TableAdapterIntf;
    if oAdapt <> nil then begin
      oAdapt.Transaction := nil;
      oAdapt.UpdateTransaction := nil;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.IsPS: Boolean;
begin
  Result := Prepared and not Active;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.CheckCachedUpdatesMode;
begin
  if not CachedUpdates then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntNotCachedUpdates,
      [GetDisplayName]);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.FindMacro(const AValue: string): TADMacro;
begin
  Result := Command.Macros.FindMacro(AValue);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.MacroByName(const AValue: string): TADMacro;
begin
  Result := Command.Macros.MacroByName(AValue);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetMacrosCount: Word;
begin
  Result := Word(Command.Macros.Count);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetMacros: TADMacros;
begin
  Result := Command.Macros;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetMacros(const AValue: TADMacros);
begin
  Command.Macros := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.OpenCursor(InfoQuery: Boolean);
var
  oConn: TADCustomConnection;
begin
  oConn := Command.AcquireConnection;
  try
    oConn.AttachClient(Self);
    try
      inherited OpenCursor(InfoQuery);
    except
      oConn.DetachClient(Self);
      raise;
    end;
  finally
    Command.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.InternalClose;
var
  oConn: TADCustomConnection;
begin
  oConn := Command.GetConnection(False);
  try
    inherited InternalClose;
  finally
    if oConn <> nil then
      oConn.DetachClient(Self);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.Disconnect(AAbortJob: Boolean = False);
begin
  inherited Disconnect(AAbortJob);
  Prepared := False;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.Prepare;
begin
  Prepared := True;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.Unprepare;
begin
  Prepared := False;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D7}
procedure TADRdbmsDataSet.Open;
begin
  inherited Open;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.Open(const ASQL: String; const AParams: array of Variant;
  const ATypes: array of TFieldType);
var
  i: Integer;
begin
  Close;
  if ASQL <> '' then
    Command.SetCommandText(ASQL,
      not (Command.CommandKind in [skStoredProc, skStoredProcNoCrs, skStoredProcWithCrs]) and
      ResourceOptions.ParamCreate);
  if Command.CommandKind in [skStoredProc, skStoredProcNoCrs, skStoredProcWithCrs] then
    Prepare;
  if Params.BindMode = pbByNumber then
    for i := 0 to Params.Count - 1 do
      Params[i].Position := i + 1;
  for i := Low(ATypes) to High(ATypes) do
    if ATypes[i] <> ftUnknown then
      Params[i].DataType := ATypes[i];
  for i := Low(AParams) to High(AParams) do
    Params[i].Value := AParams[i];
  if not (Command.CommandKind in [skStoredProc, skStoredProcNoCrs, skStoredProcWithCrs]) then
    Prepare;
  Open;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.Open(const ASQL: String);
begin
  Open(ASQL, [], []);
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.Open(const ASQL: String; const AParams: array of Variant);
begin
  Open(ASQL, AParams, []);
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetOnError: TADErrorEvent;
begin
  Result := FAdapter.OnError;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetOnError(const AValue: TADErrorEvent);
begin
  FAdapter.OnError := AValue;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetOnCommandChanged: TNotifyEvent;
begin
  Result := Command.OnCommandChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetOnCommandChanged(const AValue: TNotifyEvent);
begin
  Command.OnCommandChanged := AValue;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetParamBindMode: TADParamBindMode;
begin
  Result := Command.ParamBindMode;
end;

{-------------------------------------------------------------------------------}
procedure TADRdbmsDataSet.SetParamBindMode(const AValue: TADParamBindMode);
begin
  Command.ParamBindMode := AValue;
end;

{-------------------------------------------------------------------------------}
function TADRdbmsDataSet.GetRowsAffected: TADCounter;
begin
  Result := Command.RowsAffected;
end;

{-------------------------------------------------------------------------------}
{ TADUpdateSQL                                                                  }
{-------------------------------------------------------------------------------}
constructor TADUpdateSQL.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);
  for i := 0 to 5 do
    FCommands[i] := TADCustomCommand.Create(nil);
  if ADIsDesigning(Self) then
    Connection := ADFindDefaultConnection(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADUpdateSQL.Destroy;
var
  i: Integer;
begin
  for i := 0 to 5 do
    if FCommands[i] <> nil then
      ADFreeAndNil(FCommands[i]);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.Notification(AComponent: TComponent; AOperation: TOperation);
begin
  if (AOperation = opRemove) and (AComponent = Connection) then
    Connection := nil;
  inherited Notification(AComponent, AOperation);
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.AttachToAdapter;
var
  oAdapt: TADCustomTableAdapter;
begin
  oAdapt := FDataSet.Adapter;
  oAdapt.InsertCommand := GetCommand(arInsert);
  oAdapt.UpdateCommand := GetCommand(arUpdate);
  oAdapt.DeleteCommand := GetCommand(arDelete);
  oAdapt.LockCommand := GetCommand(arLock);
  oAdapt.UnLockCommand := GetCommand(arUnlock);
  oAdapt.FetchRowCommand := GetCommand(arFetchRow);
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.DetachFromAdapter;
var
  i: Integer;
  oAdapt: TADCustomTableAdapter;
begin
  for i := 0 to 5 do
    if FCommands[i] <> nil then
      FCommands[i].OptionsIntf.ParentOptions := nil;
  oAdapt := FDataSet.Adapter;
  oAdapt.InsertCommand := nil;
  oAdapt.UpdateCommand := nil;
  oAdapt.DeleteCommand := nil;
  oAdapt.LockCommand := nil;
  oAdapt.UnLockCommand := nil;
  oAdapt.FetchRowCommand := nil;
end;

{-------------------------------------------------------------------------------}
function TADUpdateSQL.GetCommand(ARequest: TADUpdateRequest): TADCustomCommand;
var
  sConnName: String;
  oConn: TADCustomConnection;
  onErr: TADErrorEvent;
  oFtch: TADFetchOptions;
  oRes: TADResourceOptions;
begin
  Result := FCommands[Integer(ARequest) - Integer(Low(TADUpdateRequest))];
  sConnName := ConnectionName;
  oConn := Connection;
  onErr := nil;
  if DataSet is TADRdbmsDataSet then begin
    if (sConnName = '') and (oConn = nil) then begin
      oConn := TADRdbmsDataSet(DataSet).Connection;
      sConnName := TADRdbmsDataSet(DataSet).ConnectionName;
    end;
    onErr := TADRdbmsDataSet(DataSet).OnError;
  end;
  if (Result.ConnectionName <> sConnName) or (Result.Connection <> oConn) or
     not Result.Prepared then begin
    Result.Disconnect;
    Result.ConnectionName := sConnName;
    Result.Connection := oConn;
    if DataSet <> nil then
      Result.OptionsIntf.ParentOptions := DataSet.OptionsIntf
    else
      Result.OptionsIntf.ParentOptions := nil;

    oFtch := Result.FetchOptions;
    oFtch.Mode := fmExactRecsMax;
    oFtch.RecsMax := 1;
    oFtch.Items := oFtch.Items - [fiMeta];
    oFtch.Cache := [];
    oFtch.AutoClose := True;
    oFtch.AutoFetchAll := afAll;

    oRes := Result.ResourceOptions;
    if oRes.CmdExecMode = amAsync then
      oRes.CmdExecMode := amBlocking;
    oRes.Persistent := False;

    Result.OnError := onErr;
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateSQL.GetSQL(const AIndex: Integer): TStrings;
begin
  Result := FCommands[AIndex].CommandText;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.SetSQL(const AIndex: Integer; const AValue: TStrings);
begin
  FCommands[AIndex].CommandText := AValue;
end;

{-------------------------------------------------------------------------------}
function TADUpdateSQL.GetURSQL(ARequest: TADUpdateRequest): TStrings;
begin
  Result := FCommands[Integer(ARequest) - Integer(Low(TADUpdateRequest))].CommandText;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.SetURSQL(ARequest: TADUpdateRequest;
  const Value: TStrings);
begin
  FCommands[Integer(ARequest) - Integer(Low(TADUpdateRequest))].CommandText := Value;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.UpdateAdapter;
begin
  if (FDataSet <> nil) and (FDataSet.Adapter <> nil) then begin
    DetachFromAdapter;
    AttachToAdapter;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.SetConnection(const Value: TADCustomConnection);
begin
  if FConnection <> Value then begin
    FConnection := Value;
    if FConnection <> nil then
      FConnection.FreeNotification(Self);
    UpdateAdapter;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.SetConnectionName(const Value: String);
begin
  if FConnectionName <> Value then begin
    FConnectionName := Value;
    UpdateAdapter;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateSQL.Apply(ARequest: TADUpdateRequest;
  var AAction: TADErrorAction; AOptions: TADUpdateRowOptions);
var
  oCmd: TADCustomCommand;
begin
  oCmd := Commands[ARequest];
  if (oCmd.CommandText.Count > 0) and (DataSet <> nil) and (DataSet.Adapter <> nil) then begin
    DataSet.Adapter.Update(DataSet.GetRow(), AAction, AOptions, ARequest);
    if oCmd.CommandIntf <> nil then
      oCmd.FRowsAffected := oCmd.CommandIntf.RowsAffected;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADCustomQuery                                                                }
{-------------------------------------------------------------------------------}
constructor TADCustomQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // FetchOptions.Items := FetchOptions.Items - [fiMeta];
end;

{-------------------------------------------------------------------------------}
procedure TADCustomQuery.DefineProperties(AFiler: TFiler);
begin
  inherited DefineProperties(AFiler);
  AFiler.DefineProperty('DataSource', ReadDataSource, nil, False);
end;

{-------------------------------------------------------------------------------}
type
  __TReader = class(TReader)
  end;

procedure TADCustomQuery.ReadDataSource(AReader: TReader);
begin
  __TReader(AReader).ReadPropValue(Self, GetPropInfo(ClassInfo, 'MasterSource'));
end;

{-------------------------------------------------------------------------------}
function TADCustomQuery.GetSQL: TStrings;
begin
  Result := Command.CommandText;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomQuery.SetSQL(const AValue: TStrings);
begin
  Command.CommandText := AValue;
end;

{-------------------------------------------------------------------------------}
function TADCustomQuery.GetText: String;
begin
  Result := Command.SQLText;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomQuery.ExecSQL;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
function TADCustomQuery.ExecSQL(const ASQL: String; const AParams: array of Variant;
  const ATypes: array of TFieldType): LongInt;
var
  i: Integer;
begin
  Close;
  if ASQL <> '' then
    Command.SetCommandText(ASQL, ResourceOptions.ParamCreate);
  if Params.BindMode = pbByNumber then
    for i := 0 to Params.Count - 1 do
      Params[i].Position := i + 1;
  for i := Low(ATypes) to High(ATypes) do
    if ATypes[i] <> ftUnknown then
      Params[i].DataType := ATypes[i];
  for i := Low(AParams) to High(AParams) do
    Params[i].Value := AParams[i];
  Prepare;
  Execute;
  Result := RowsAffected;
end;

{-------------------------------------------------------------------------------}
function TADCustomQuery.ExecSQL(const ASQL: String): LongInt;
begin
  Result := ExecSQL(ASQL, [], []);
end;

{-------------------------------------------------------------------------------}
function TADCustomQuery.ExecSQL(const ASQL: String;
  const AParams: array of Variant): LongInt;
begin
  Result := ExecSQL(ASQL, AParams, []);
end;

{-------------------------------------------------------------------------------}
function TADCustomQuery.GetDS: TDataSource;
begin
  Result := MasterSource;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomQuery.SetDS(const AValue: TDataSource);
begin
  MasterSource := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomQuery.UpdateRecordCount;
var
  oQuery: TADQuery;
  oGen: IADPhysCommandGenerator;
  oFtch: TADFetchOptions;
  oRes: TADResourceOptions;
begin
  FRecordCount := 0;
  Prepared := True;
  oQuery := TADQuery.Create(nil);
  try
    oQuery.ConnectionName := ConnectionName;
    oQuery.Connection := Connection;
    oQuery.Transaction := Transaction;

    oFtch := oQuery.FetchOptions;
    oFtch.RecsMax := 1;
    oFtch.Items := [];
    oFtch.AutoClose := True;
    oFtch.AutoFetchAll := afAll;
    oFtch.RecordCountMode := cmVisible;
    oFtch.Mode := fmExactRecsMax;

    oRes := oQuery.ResourceOptions;
    if oRes.CmdExecMode = amAsync then
      oRes.CmdExecMode := amBlocking;
    oRes.DirectExecute := True;
    oRes.PreprocessCmdText := False;
    oRes.Persistent := False;

    PointedConnection.ConnectionIntf.CreateCommandGenerator(oGen, Command.CommandIntf);
    // Text has a SQL command with all limitations applied.
    oQuery.SQL.Text := oGen.GenerateCountSelect(Text);
    oQuery.Params.Assign(Params);
    oQuery.Open;
    FRecordCount := oQuery.Fields[0].AsInteger;
    // If RecsMax >= 0, then TADPhysCommand.GenerateLimitSelect always
    // asks for RecsMax + 1 records.
    oFtch := FetchOptions;
    if (oFtch.Mode = fmExactRecsMax) and (oFtch.RecsMax >= 0) and (FRecordCount > 0) then
      Dec(FRecordCount);
  finally
    ADFree(oQuery);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADTable                                                                      }
{-------------------------------------------------------------------------------}
{ TODO -cTable : Allow to set CachedUpdates=True when TADTable is active }
{ TODO -cTable : Aggregates }

constructor TADTable.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClientCursor := False;
  FWindowSize := 2;
  UpdateOptions.RequestLive := True;
end;

{-------------------------------------------------------------------------------}
function TADTable.InternalCreateAdapter: TADCustomTableAdapter;
begin
  Result := inherited InternalCreateAdapter;
  Result.SelectCommand.FEnableParamsStorage := False;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.DoCachedUpdatesChanged;
begin
  inherited DoCachedUpdatesChanged;
  FClientCursor := CachedUpdates;
  Unprepare;
  SQL.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.MoveData(ATableSrc, ATableDst: TADDatSTable);
var
  rState: TADDatSLoadState;
begin
  ATableDst.BeginLoadData(rState, lmHavyLoading);
  try
    ATableDst.Import(ATableSrc);
  finally
    ATableDst.EndLoadData(rState);
  end;
end;

{-------------------------------------------------------------------------------}
{ Get / set props }

function TADTable.GetCustomWhere: String;
begin
  // nothing
  Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TADTable.TableChanged;
begin
  Unprepare;
  FPrimaryKeyFields := '';
  if FResetIndexFieldNames then begin
    IndexFieldNames := '';
    FResetIndexFieldNames := False;
  end;
  SQL.Clear;
  Indexes.Clear;
  IndexDefs.Clear;
  IndexDefs.Updated := False;
  FieldDefs.Updated := False;
  DataEvent(dePropertyChange, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADTable.SetTableName(const AValue: String);
begin
  CheckInactive;
  if FTableName <> AValue then begin
    FTableName := AValue;
    UpdateOptions.UpdateTableName := AValue;
    TableChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.SetSchemaName(const AValue: String);
begin
  CheckInactive;
  if FSchemaName <> AValue then begin
    FSchemaName := AValue;
    TableChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.SetCatalogName(const AValue: String);
begin
  CheckInactive;
  if FCatalogName <> AValue then begin
    FCatalogName := AValue;
    TableChanged;
  end;
end;

{-------------------------------------------------------------------------------}
{ Open / close }

function TADTable.IsSequenced: Boolean;
begin
  Result := FClientCursor;
end;

{-------------------------------------------------------------------------------}
function TADTable.DoIsSourceOpen: Boolean;
begin
  if FClientCursor then
    Result := inherited DoIsSourceOpen
  else
    Result := Active;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.SetupTable;
var
  oView, oView2: TADDatSView;
  oConnMeta: IADPhysConnectionMetadata;
  oConn: TADCustomConnection;
  iVal, i: Integer;
begin
  oConn := Command.AcquireConnection;
  try
    oConnMeta := oConn.GetConnectionMetadataIntf;
    FServerCursor := oConnMeta.ServerCursorSupported;

    // Get unique identifying fields
    if FPrimaryKeyFields = '' then
      FPrimaryKeyFields := PSGetKeyFields;

    if (FPrimaryKeyFields = '') and (fiMeta in FetchOptions.Items) then begin
      oView := oConnMeta.GetTablePrimaryKeyFields(CatalogName, SchemaName, TableName, '');
      try
        FPrimaryKeyFields := oView.Rows.GetValuesList('COLUMN_NAME', ';');
      finally
        ADClearMetaView(oView, FetchOptions);
      end;
      if FPrimaryKeyFields = '' then begin
        oView := oConnMeta.GetTableIndexes(CatalogName, SchemaName, TableName, '');
        try
          for i := 0 to oView.Rows.Count - 1 do begin
            iVal := oView.Rows[i].GetData('INDEX_TYPE');
            if TADPhysIndexKind(iVal) = ikUnique then begin
              oView2 := oConnMeta.GetTableIndexFields(CatalogName, SchemaName,
                TableName, oView.Rows[i].GetData('INDEX_NAME'), '');
              try
                FPrimaryKeyFields := oView2.Rows.GetValuesList('COLUMN_NAME', ';');
              finally
                ADFree(oView2);
              end;
              Break;
            end;
          end;
        finally
          ADClearMetaView(oView, FetchOptions);
        end;
      end;
    end;

    // Setup cursor kind
    if CachedUpdates or FetchOptions.Unidirectional then
      FClientCursor := True
    else
      case FetchOptions.CursorKind of
      ckAutomatic:
        FClientCursor := FPrimaryKeyFields = '';
      ckDefault,
      ckStatic,
      ckForwardOnly:
        FClientCursor := True;
      ckDynamic:
        FClientCursor := False;
      end;

    // The table must have a primary key !
    // Without it the live data window will not work properly.
    if not FClientCursor and (FPrimaryKeyFields = '') then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntPKNotFound,
        [GetDisplayName]);

    // Save null location for window generation
    FTableParams.FNullLocation := oConnMeta.NullCollation;
  finally
    Command.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.OpenCursor(AInfoQuery: Boolean);
var
  iFetched: Integer;
  eOptions: TADSortOptions;
begin
  SetupTable;
  UpdateIndexDefs;
  eOptions := [];
  FResetIndexFieldNames := (IndexFieldNames = '') and (IndexName = '');
  if FResetIndexFieldNames then
    IndexFieldNames := DoAdjustSortFields('', '', eOptions);

  FTableParams.FTableCommand := tcBof;
  FTableParams.FLastTableCommand := tcUnknown;
  FetchWindow(iFetched, True);

  inherited OpenCursor(AInfoQuery);
  if not FClientCursor and (FRecordIndex > -1) then
    FRecordIndex := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.Open(const ATableName: String);
begin
  Close;
  if ATableName <> '' then
    TableName := ATableName;
  Open;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.ReleaseBase(AOffline: Boolean);
begin
  inherited ReleaseBase(AOffline);
  if FClientCursor then
    Exit;

  FSourceEOF := False;
  FTableParams.FLastTableCommand := tcUnknown;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.Disconnect(AAbortJob: Boolean);
begin
  if not FWindowOperation or FClientCursor then
    inherited Disconnect(AAbortJob);
  Prepared := False;
end;

{-------------------------------------------------------------------------------}
{ Bookmarks }

function TADTable.GetBookmarkColSize(ACol: TADDatSColumn): LongWord;
begin
  if caBlobData in ACol.Attributes then
    Result := SizeOf(Word) + FormatOptions.InlineDataSize
  else if ACol.DataType in C_AD_StrTypes then
    Result := ACol.StorageSize
  else
    Result := SizeOf(Word) + ACol.StorageSize;
end;

{-------------------------------------------------------------------------------}
function TADTable.CalcBookmarkSize: LongWord;
var
  i: Integer;
  sIndexFields: String;
  oCol: TADDatSColumn;
begin
  Result := inherited CalcBookmarkSize;
  if FClientCursor then
    Exit;

  i := 1;
  sIndexFields := ActualIndexFieldNames;
  while i <= Length(sIndexFields) do begin
    oCol := Table.Columns.ColumnByName(ADExtractFieldName(sIndexFields, i));
    Inc(Result, GetBookmarkColSize(oCol));
  end;
  Result := LongWord(SizeOf(LongWord) +    // Str length
    Length(sIndexFields) * SizeOf(Char)) + // str
    Result;                                // data buffer
end;

{-------------------------------------------------------------------------------}
procedure TADTable.GetBookmarkData(Buffer: PADBuffer; Data: PADBookmark);
var
  i: Integer;
  oCol: TADDatSColumn;
  iBuffLen,
  iDataLen: LongWord;
  pBuff,
  pData: Pointer;
  sIndexFields: String;
begin
  inherited GetBookmarkData(Buffer, Data);
  if FClientCursor then
    Exit;

  sIndexFields := ActualIndexFieldNames;
  // length of index fields
  pBuff := PADByteString(Data) + SizeOf(TADBookmarkData);
  PLongWord(pBuff)^ := Length(sIndexFields) * SizeOf(Char);
  // index fields
  pBuff := PADByteString(pBuff) + SizeOf(LongWord);
  Move(sIndexFields[1], pBuff^, Length(sIndexFields) * SizeOf(Char));
  pBuff := PADByteString(pBuff) + Length(sIndexFields) * SizeOf(Char);

  // fields data
  i := 1;
  while i <= Length(sIndexFields) do begin
    oCol := PADBookmarkData(Data)^.FRow.Table.Columns.ColumnByName(
      ADExtractFieldName(sIndexFields, i));
    iBuffLen := GetBookmarkColSize(oCol) - SizeOf(Word);
    pData := PADByteString(pBuff) + SizeOf(Word);
    if PADBookmarkData(Data)^.FRow.GetData(oCol.Index, rvDefault, pData,
                                           iBuffLen, iDataLen, True) then
      PWord(pBuff)^ := iDataLen
    else
      PWord(pBuff)^ := $FFFF;
    pBuff := PADByteString(pBuff) + SizeOf(Word) + iBuffLen;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTable.Bookmark2Fields(const ABookmark: TBookmark; var ADataPtr: Pointer): String;
var
  iDataLen: Integer;
  pBuff: Pointer;
begin
  Result := '';
  if ABookmark <> nil then begin
    pBuff := PADByteString(ABookmark) + SizeOf(TADBookmarkData);
    iDataLen := PLongWord(pBuff)^;
    pBuff := PADByteString(pBuff) + SizeOf(LongWord);
    SetString(Result, PChar(pBuff), iDataLen div SizeOf(Char));
    ADataPtr := PADByteString(pBuff) + iDataLen;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTable.Bookmark2Key(const ABookmark: TBookmark; APKOnly: Boolean = False): Variant;
var
  oRow: TADDatSRow;
  oCol: TADDatSColumn;
  i: Integer;
  iBuffLen,
  iDataLen: LongWord;
  pBuff: Pointer;
  sIndexFields: String;
begin
  oRow := Table.NewRow(False);
  try
    sIndexFields := Bookmark2Fields(ABookmark, pBuff);
    i := 1;
    while i <= Length(sIndexFields) do begin
      oCol := oRow.Table.Columns.ColumnByName(ADExtractFieldName(sIndexFields, i));
      iBuffLen := GetBookmarkColSize(oCol);
      iDataLen := PWord(pBuff)^;
      if iDataLen = $FFFF then
        oRow.SetData(oCol.Index, nil, 0)
      else
        oRow.SetData(oCol.Index, PADByteString(pBuff) + SizeOf(Word), iDataLen);
      pBuff := PADByteString(pBuff) + iBuffLen;
    end;
    if APKOnly then
      Result := oRow.GetValues(FPrimaryKeyFields, True)
    else
      Result := oRow.GetValues(sIndexFields, True);
  finally
    ADFree(oRow);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTable.InternalBookmarkValid(ABookmark: Pointer): Boolean;
var
  i: Integer;
  sBookmarFields: String;
  sField: String;
  pBuff: Pointer;
begin
  sBookmarFields := ';' + UpperCase(Bookmark2Fields(ABookmark, pBuff)) + ';';
  Result := True;
  i := 1;
  while i <= Length(FPrimaryKeyFields) do begin
    sField := ';' + UpperCase(ADExtractFieldName(FPrimaryKeyFields, i)) + ';';
    if Pos(sField, sBookmarFields) = 0 then begin
      Result := False;
      Break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTable.BookmarkValid(ABookmark: TBookmark): Boolean;
begin
  if FClientCursor then begin
    Result := inherited BookmarkValid(ABookmark);
    Exit;
  end;

  Result := (ABookmark <> nil) and InternalBookmarkValid(ABookmark);
end;

{-------------------------------------------------------------------------------}
procedure TADTable.InternalGotoBookmark(ABookmark: Pointer);

  procedure ErrorNoBmk;
  var
    pBuff: Pointer;
  begin
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSIncompatBmkFields,
      [Bookmark2Fields(ABookmark, pBuff), GetDisplayName, FPrimaryKeyFields]);
  end;

var
  vLocValue: Variant;
  oTable: TADDatSTable;
begin
  if FClientCursor then begin
    inherited InternalGotoBookmark(ABookmark);
    Exit;
  end;

  if not InternalBookmarkValid(ABookmark) then
    ErrorNoBmk;

  oTable := nil;
  try
    vLocValue := Bookmark2Key(ABookmark, True);
    if not inherited LocateRecord(FPrimaryKeyFields, vLocValue, [lxoCheckOnly], FRecordIndex) then begin
      oTable := TADDatSTable.Create;
      if InternalSearch(oTable, FPrimaryKeyFields, vLocValue) then begin
        Table.Clear;
        MoveData(oTable, Table);
        FRecordIndex := 0;
      end;
    end;
  finally
    ADFree(oTable);
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D17}
procedure TADTable.InternalGotoBookmark(Bookmark: PADBookmark);
begin
  InternalGotoBookmark(Pointer(Bookmark));
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADTable.CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer;
{$IFNDEF AnyDAC_D6Base}
type
  TVariantRelationship = (vrEqual, vrLessThan, vrGreaterThan, vrNotEqual);

  function VarCompareValue(const A, B: Variant): TVariantRelationship;
  const
    CTruth: array [Boolean] of TVariantRelationship = (vrNotEqual, vrEqual);
  begin
    if TVarData(A).VType = varEmpty then
      Result := CTruth[TVarData(B).VType = varEmpty]
    else if TVarData(A).VType = varNull then
      Result := CTruth[TVarData(B).VType = varNull]
    else if TVarData(B).VType in [varEmpty, varNull] then
      Result := vrNotEqual
    else if A = B then
      Result := vrEqual
    else if A < B then
      Result := vrLessThan
    else
      Result := vrGreaterThan;
  end;
{$ENDIF}

  procedure ErrorNoBmk(const AFields1, AFields2: String);
  begin
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSIncompatBmkFields,
      [AFields1, GetDisplayName, AFields2]);
  end;

var
  vValues1: Variant;
  vValues2: Variant;
  sFields1: String;
  sFields2: String;
  lPKOnly1: Boolean;
  lPKOnly2: Boolean;
  sIndexFields: String;
  lNullFirst: Boolean;
  sDescFields: String;
  sNoCaseFields: String;
  sTmp: String;
  sField: String;
  i: Integer;
  iVarIndex: Integer;
  pBuff: Pointer;

  function CompareVar(const AValue1, AValue2: Variant; const AField: String): Integer;
  var
    lDesc: Boolean;
    lNoCase: Boolean;
    eCmpResult: TVariantRelationship;
  begin
    ASSERT(not VarIsArray(AValue1) and not VarIsArray(AValue2));

    Result := 0;
    if ADSameVariants(AValue1, AValue2) or
       VarIsNull(AValue1) and VarIsNull(AValue2) then
      // nothing to do

    else if VarIsNull(AValue1) and not VarIsNull(AValue2) then
      if lNullFirst then
        Result := -1
      else
        Result := 1

    else if not VarIsNull(AValue1) and VarIsNull(AValue2) then
      if lNullFirst then
        Result := 1
      else
        Result := -1

    else begin
      lDesc := Pos(UpperCase(sDescFields), AField) > 0;
      lNoCase := Pos(UpperCase(sNoCaseFields), AField) > 0;

      // DescFields handling
      if lDesc and not lNoCase then begin
        eCmpResult := VarCompareValue(AValue1, AValue2);
        // invert result comparsion.
        if eCmpResult = vrLessThan then
          Result := 1
        else if eCmpResult = vrGreaterThan then
          Result := -1
        else
          // never happen unless varEmpty
          ASSERT(False);
      end

      // nocase field handling
      else if not lDesc and lNoCase then
        Result := CompareText(VarToStr(vValues1), VarToStr(vValues2))

      else if lDesc and lNoCase then begin
        Result := CompareText(VarToStr(vValues1), VarToStr(vValues2));
        // invert result
        Result := -Result;
      end

      // not lDesc and not lNoCase
      else begin
        eCmpResult := VarCompareValue(AValue1, AValue2);
        if eCmpResult = vrLessThan then
          Result := -1
        else if eCmpResult = vrGreaterThan then
          Result := 1
        else
          // never happens unless varEmpty
          ASSERT(False);
      end;
    end;
  end;

begin
  if FClientCursor then begin
    Result := inherited CompareBookmarks(Bookmark1, Bookmark2);
    Exit;
  end;

  lNullFirst := FTableParams.FNullLocation = [nlAscFirst, nlDescLast];
  if (Bookmark1 = nil) or (Bookmark2 = nil) then begin
    if (Bookmark1 <> nil) and (Bookmark2 = nil) then
      if lNullFirst then
        Result := 1
      else
        Result := -1
    else if (Bookmark1 = nil) and (Bookmark2 <> nil) then
      if lNullFirst then
        Result := -1
      else
        Result := 1
    else
      Result := 0;
    Exit;
  end;


  sIndexFields := ActualIndexFieldNames;
  ParseIndexFields(sTmp, sDescFields, sNoCaseFields, sTmp);
  sFields1 := Bookmark2Fields(Bookmark1, pBuff);
  sFields2 := Bookmark2Fields(Bookmark2, pBuff);
  lPKOnly1 := (sFields1 <> sIndexFields);
  lPKOnly2 := (sFields2 <> sIndexFields);

  if lPKOnly1 and (FPrimaryKeyFields = '') then
    ErrorNoBmk(sFields1, sIndexFields);
  try
    vValues1 := Bookmark2Key(Bookmark1, lPKOnly1 or lPKOnly2);
  except
    ErrorNoBmk(sFields1, sIndexFields);
  end;

  if lPKOnly2 and (FPrimaryKeyFields = '') then
    ErrorNoBmk(sFields2, sIndexFields);
  try
    vValues2 := Bookmark2Key(Bookmark2, lPKOnly1 or lPKOnly2);
  except
    ErrorNoBmk(sFields2, sIndexFields);
  end;

  if lPKOnly1 or lPKOnly2 then
    sIndexFields := FPrimaryKeyFields;

  if not VarIsArray(vValues1) then
    // for one field in bookmark
    Result := CompareVar(vValues1, vValues2, sIndexFields)

  else begin
    // compare values in index order
    i := 1;
    iVarIndex := 0;
    Result := 0;
    while i <= Length(sIndexFields) do begin
      sField := ADExtractFieldName(sIndexFields, i);
      Result := CompareVar(vValues1[iVarIndex], vValues2[iVarIndex], sField);
      if Result <> 0 then
        Break;
      Inc(iVarIndex);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{ Indexes / Filters }

procedure TADTable.ParseIndexFields(out AOrderFields, ADescFields, ANoCaseFields,
  AExpression: String);
var
  sOrdFields2, sField: String;
  i1, i2, iFrom: Integer;
  lNoCase, lDesc: Boolean;
  oIndDef: TIndexDef;

  procedure AddField(var AFields: String; const AName: String);
  begin
    if AFields <> '' then
      AFields := AFields + ';';
    AFields := AFields + AName;
  end;

begin
  ADescFields := '';
  ANoCaseFields := '';
  AExpression := '';

  // If IndexFieldNames is specified
  if IndexFieldNames <> '' then begin
    if SortView <> nil then
      AOrderFields := SortView.Sort
    else
      AOrderFields := IndexFieldNames;
    if Pos(':', AOrderFields) > 0 then begin
      sOrdFields2 := '';
      i1 := 1;
      while i1 <= Length(AOrderFields) do begin
        sField := ADExtractFieldName(AOrderFields, i1);
        i2 := Pos(':', sField);
        lNoCase := False;
        lDesc := False;
        if i2 <> 0 then begin
          iFrom := i2;
          while i2 <= Length(sField) do begin
            case sField[i2] of
            'n', 'N': lNoCase := True;
            'd', 'D': lDesc := True;
            'a', 'A': lDesc := False;
            end;
            Inc(i2);
          end;
          sField := Copy(sField, 1, iFrom - 1);
        end;
        AddField(sOrdFields2, sField);
        if lNoCase then
          AddField(ANocaseFields, sField);
        if lDesc then
          AddField(ADescFields, sField);
      end;
      AOrderFields := sOrdFields2;
    end;
  end

  // If IndexName is specified
  else if IndexName <> '' then begin
    IndexDefs.Update;
    UpdateLocalIndexName;
    oIndDef := IndexDefs.Find(LocalIndexName);

    if (oIndDef = nil) or (oIndDef.Expression <> '') or (ixExpression in oIndDef.Options) then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PClnt], er_AD_ClntWrongIndex,
        [GetDisplayName, IndexName]);

    AOrderFields := oIndDef.Fields;
{$IFNDEF AnyDAC_FPC}
    ADescFields := oIndDef.DescFields;
    ANocaseFields := oIndDef.CaseInsFields;
{$ENDIF}
    if ixCaseInsensitive in oIndDef.Options then
      ANocaseFields := AOrderFields;
    if ixDescending in oIndDef.Options then
      ADescFields := AOrderFields;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTable.GetActualIndexFields: String;
var
  sOrderFields, sDescFields, sNoCaseFields, sExpression: String;
begin
  ParseIndexFields(sOrderFields, sDescFields, sNoCaseFields, sExpression);
  Result := ADMergeFieldNames(sOrderFields, FPrimaryKeyFields);
end;

{-------------------------------------------------------------------------------}
function TADTable.DoAdjustSortFields(const AFields, AExpression: String;
  var AIndexOptions: TADSortOptions): String;
var
  oConnMeta: IADPhysConnectionMetadata;
  oConn: TADCustomConnection;
  eLoc: TADPhysNullLocations;
begin
  Result := AFields;
  oConn := Command.AcquireConnection;
  try
    if AExpression = '' then begin
      Result := ADMergeFieldNames(Result, FPrimaryKeyFields);

      // Set Null location. Null location on server and client MUST BE THE SAME.
      // Without it data window WILL NOT WORK PROPERLY
      oConnMeta := oConn.GetConnectionMetadataIntf;
      eLoc := oConnMeta.NullCollation;
      if nlAscFirst in eLoc then
        Include(AIndexOptions, soNullFirst)
      else if nlAscLast in eLoc then
        Exclude(AIndexOptions, soNullFirst);
      if nlDescLast in eLoc then
        Include(AIndexOptions, soDescNullLast)
      else if nlDescFirst in eLoc then
        Exclude(AIndexOptions, soDescNullLast);
    end;
  finally
    Command.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.UpdateLocalIndexName;
var
  oConn: TADCustomConnection;
  sTmp, sIndex: String;
begin
  if IndexName <> '' then begin
    oConn := GetPointedConnection;
    if (oConn <> nil) and oConn.Connected then begin
      oConn.DecodeObjectName(IndexName, sTmp, sTmp, sTmp, sIndex);
      FLocalIndexName := sIndex;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.DoSortOrderChanging;
begin
  FTableParams.FLastTableCommand := tcUnknown;
  UpdateLocalIndexName;
  inherited DoSortOrderChanging;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.DoSortOrderChanged;
begin
  if Active and not FClientCursor then begin
    // After changing the sort order the bookmark size may be changed
    BookmarkSize := CalcBookmarkSize;
    // Remove references (FRow) to existing records for 2 reasons:
    // 1) When BookmarkSize is changed, then "touching" to a buffer may lead to AV
    // 2) When dataset will be refreshed later, then record references are invalid
    ClearBuffers;
    if not IsLinkedDetail and not FWindowOperation then
      InternalRefresh;
  end;
  inherited DoSortOrderChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.DoFilteringUpdated(AResync: Boolean);
var
  oRow: TADDatSRow;
  vKeyValues: Variant;
begin
  if not FClientCursor and
     Active and not Assigned(OnFilterRecord) then begin
    FTableParams.FLastTableCommand := tcUnknown;
    inherited DoFilteringUpdated(False);
    UpdateCursorPos;
    oRow := GetRow();
    if oRow <> nil then
      vKeyValues := oRow.GetValues(FPrimaryKeyFields, True);
    Table.Clear;
    First;
    if (oRow <> nil) and AResync then
      inherited LocateEx(FPrimaryKeyFields, vKeyValues, []);
  end
  else
    inherited DoFilteringUpdated(AResync);
end;

{-------------------------------------------------------------------------------}
procedure TADTable.UpdateIndexDefs;
var
  i, j: Integer;
  oConn: TADCustomConnection;
  oConnMeta: IADPhysConnectionMetadata;
  oVInds, oVIndFlds: TADDatSView;
  oInd: TADIndex;
  sName: String;
  eOptions: TADSortOptions;
  oRow: TADDatSRow;
  lDesc: Boolean;

  function NormName(const AName: Variant): String;
  begin
    Result := oConnMeta.QuoteObjName(oConn.CnvMetaValue(AName));
  end;

begin
  if (csDesigning in ComponentState) and (IndexDefs.Count > 0) then
    Exit;
  // Really IndexDefs can be updated only for closed dataset
  if not IndexDefs.Updated then begin
    if fiMeta in FetchOptions.Items then begin
      oConn := Command.AcquireConnection;
      try
        oConnMeta := oConn.GetConnectionMetadata(True);
        oVInds := oConnMeta.GetTableIndexes(CatalogName, SchemaName, TableName, '');
        try
          for i := 0 to oVInds.Rows.Count - 1 do begin
            oRow := oVInds.Rows[i];
            oVIndFlds := oConnMeta.GetTableIndexFields(
              oConn.CnvMetaValue(oRow.GetData('CATALOG_NAME')),
              oConn.CnvMetaValue(oRow.GetData('SCHEMA_NAME')),
              NormName(oRow.GetData('TABLE_NAME')),
              NormName(oRow.GetData('INDEX_NAME')), '');
            try
              sName := oConn.CnvMetaValue(oRow.GetData('INDEX_NAME'));
              oInd := Indexes.FindIndex(sName);
              if oInd = nil then
                oInd := Indexes.Add;
              oInd.Name := sName;
              oInd.Fields := oVIndFlds.Rows.GetValuesList('COLUMN_NAME');
              oInd.Options := FormatOptions.SortOptions - [soUnique, soPrimary];
              case TADPhysIndexKind(oRow.GetData('INDEX_TYPE')) of
              ikNonUnique:  ;
              ikUnique:     oInd.Options := oInd.Options + [soUnique];
              ikPrimaryKey: oInd.Options := oInd.Options + [soPrimary];
              end;
              lDesc := True;
              for j := 0 to oVIndFlds.Rows.Count - 1 do
                if oVIndFlds.Rows[j].GetData('SORT_ORDER') <> 'D' then begin
                  lDesc := False;
                  Break;
                end;
              if lDesc then
                oInd.Options := oInd.Options + [soDescending];
              if FAdjustIndexes then begin
                eOptions := oInd.Options;
                oInd.Fields := DoAdjustSortFields(oInd.Fields, '', eOptions);
                oInd.Options := eOptions;
              end;
              oInd.Active := True;
            finally
              ADClearMetaView(oVIndFlds, FetchOptions);
            end;
          end;
        finally
          ADClearMetaView(oVInds, FetchOptions);
        end;
      finally
        Command.ReleaseConnection(oConn);
      end;
    end;
    inherited UpdateIndexDefs;
  end;
end;

{-------------------------------------------------------------------------------}
{ Data window SQL generation / fetching }

function TADTable.GetWindowedRows: TADDatSRowListBase;
begin
  if SourceView.SortingMechanism <> nil then
    Result := SourceView.SortingMechanism.SortedRows
  else
    Result := Table.Rows;
end;

{-------------------------------------------------------------------------------}
function TADTable.GenerateSQL: String;
var
  sCat, sSch, sBObj, sObj, sOrdFields, sDescFields,
    sNocaseFields, sExpression, sMastFields, sMastNullFields: String;
  oConn: TADCustomConnection;
  oGen: IADPhysCommandGenerator;
  oRows: TADDatSRowListBase;
  i: Integer;
  pKeyBuff: PADKeyBuffer;
begin
  ASSERT(not FClientCursor or (FTableParams.FTableCommand = tcBof));

  oConn := Command.AcquireConnection;
  try
    Command.Unprepare;
    oConn.CheckActive;
    oConn.ConnectionIntf.CreateCommandGenerator(oGen, nil);

    // Prepare table name
    oConn.DecodeObjectName(TableName, sCat, sSch, sBObj, sObj);
    if sCat = '' then
      sCat := CatalogName;
    if sSch = '' then
      sSch := SchemaName;
    if (sBObj <> '') and (sObj = '') then
      sObj := SBObj;
    FTableParams.FCatalog := sCat;
    FTableParams.FSchema := sSch;
    FTableParams.FTable := sObj;

    FTableParams.FPrimaryKeyFields := '';
    FTableParams.FRangeStartRow := nil;
    FTableParams.FRangeStartFieldCount := -1;
    FTableParams.FRangeEndRow := nil;
    FTableParams.FRangeEndFieldCount := -1;
    FTableParams.FLocateRow := nil;
    FTableParams.FIndexFields := '';
    FTableParams.FDescFields := '';
    FTableParams.FNoCaseFields := '';
    FTableParams.FIndexExpression := '';
    FTableParams.FMasterFields := '';
    FTableParams.FFilter := '';
    FTableParams.FFiltered := False;
    FTableParams.FFilterNoCase := False;
    FTableParams.FFilterPartial := False;
    FTableParams.FRanged := False;
    FTableParams.FExclusive := False;
    FTableParams.FCustomWhere := '';
    FTableParams.FKeyFieldCount := -1;

    sOrdFields := '';
    sDescFields := '';
    sNocaseFields := '';
    sExpression := '';
    sMastFields := '';
    sMastNullFields := '';

    if (FTableParams.FTableCommand <> tcGetRowCount) or
       (FetchOptions.RecordCountMode <> cmTotal) then begin
      // Prepare indexed field lists
      ParseIndexFields(sOrdFields, sDescFields, sNocaseFields, sExpression);

      // When sOrdFields does not contain PK fields, then add them
      FTableParams.FPrimaryKeyFields := FPrimaryKeyFields;

      if IsLinkedDetail then begin
        sMastFields := MasterFields;
        if not FClientCursor then
          for i := 0 to MasterLink.Fields.Count - 1 do
            if TField(MasterLink.Fields[i]).IsNull then
              sMastNullFields := sMastNullFields + ';' + TField(MasterLink.Fields[i]).FieldName;
      end;

      oGen.Params := Params;
      oGen.Options := Command;

      // Set range rows
      if IsRanged then begin
        pKeyBuff := GetKeyBuffer(kiRangeStart);
        if Assigned(pKeyBuff) then begin
          FTableParams.FRangeStartRow := GetKeyRow(pKeyBuff);
          FTableParams.FRangeStartFieldCount := FRangeFromFieldCount;
        end;
        pKeyBuff := GetKeyBuffer(kiRangeEnd);
        if Assigned(pKeyBuff) then begin
          FTableParams.FRangeEndRow := GetKeyRow(pKeyBuff);
          FTableParams.FRangeEndFieldCount := FRangeToFieldCount;
        end;
      end;
    end;

    // Set current and locate rows
    case FTableParams.FTableCommand of
    tcLocate:
      begin
        FTableParams.FLocateRow := GetLocateRow;
        if (FRecordIndex = -1) or (FRecordIndex > SourceView.Rows.Count - 1) then
          // no record
          oGen.Row := nil
        else
          // set current record
          oGen.Row := SourceView.Rows[FRecordIndex];
        FTableParams.FRecordCount := 1;
      end;

    tcGetRecNo:
      begin
        if SourceView.Rows.Count > 0 then begin
          if Bof then
            // special for bof
            oGen.Row := SourceView.Rows[0]
          else if Eof then
            // special for eof
            oGen.Row := SourceView.Rows[SourceView.Rows.Count - 1]
          else
            // in other cases
            oGen.Row := SourceView.Rows[FRecordIndex];
        end
        else
          oGen.Row := nil;
        FTableParams.FRecordCount := 1;
      end;


    tcFindKey,
    tcFindNearest:
      begin
        pKeyBuff := GetKeyBuffer(kiLookup);
        oGen.Row := GetKeyRow(pKeyBuff);
        FTableParams.FRecordCount := 1;
        if FKeyBuffer^.FFieldCount <= 0 then
          FTableParams.FKeyFieldCount := InternalDefaultKeyFieldCount(pKeyBuff,
            SortView.SortingMechanism.SortColumnList.Count)
        else
          FTableParams.FKeyFieldCount := pKeyBuff^.FFieldCount;
      end;

    tcPageDown:
      begin
        oRows := GetWindowedRows;
        oGen.Row := oRows[oRows.Count - 1];
        if FServerCursor and not (FetchOptions.LiveWindowFastFirst and not FClientCursor) then
          FTableParams.FRecordCount := -1
        else
          FTableParams.FRecordCount := FWindowSize * FetchOptions.RowsetSize;
      end;

    tcPageUp:
      begin
        oRows := GetWindowedRows;
        oGen.Row := oRows[0];
        if FServerCursor and not (FetchOptions.LiveWindowFastFirst and not FClientCursor) then
          FTableParams.FRecordCount := -1
        else
          FTableParams.FRecordCount := FWindowSize * FetchOptions.RowsetSize;
      end;

    tcBof,
    tcEof:
      if (FClientCursor or FServerCursor) and
         not (FetchOptions.LiveWindowFastFirst and not FClientCursor) then
        FTableParams.FRecordCount := -1
      else
        FTableParams.FRecordCount := FWindowSize * FetchOptions.RowsetSize;

    tcSetRecNo:
      FTableParams.FRecordCount := 1;

    tcCurrentRecord:
      begin
        oGen.Row := SourceView.Rows[FRecordIndex];
        FTableParams.FRecordCount := 1;
      end;
    end;

    if sExpression = '' then begin
      FTableParams.FIndexFields      := sOrdFields;
      FTableParams.FDescFields       := sDescFields;
      FTableParams.FNoCaseFields     := sNocaseFields;
    end
    else
      FTableParams.FIndexExpression  := sExpression;

    if (FTableParams.FTableCommand <> tcGetRowCount) or
       (FetchOptions.RecordCountMode <> cmTotal) then begin
      FTableParams.FMasterFields     := sMastFields;
      FTableParams.FMasterNullFields := sMastNullFields;
      FTableParams.FFilter           := Filter;
      FTableParams.FFiltered         := Filtered and not Assigned(OnFilterRecord);
      FTableParams.FFilterNoCase     := foCaseInsensitive in FilterOptions;
      FTableParams.FFilterPartial    := not (foNoPartialCompare in FilterOptions);
      FTableParams.FRanged           := IsRanged;
      FTableParams.FExclusive        := (FKeyBuffer <> nil) and FKeyBuffer^.FExclusive;
      FTableParams.FCustomWhere      := GetCustomWhere;
    end;

    Result := oGen.GenerateSelectTable(FTableParams);
  finally
    Command.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.FetchWindow(out AFetched: Integer; APrepOnly: Boolean = False;
  AForceClear: Boolean = False; ATable: TADDatsTable = nil);

  function IsPrefixed(const AName, APrefix: String; var AField: String): Boolean;
  begin
    Result := Pos(UpperCase(APrefix), UpperCase(AName)) = 1;
    if Result then
      AField := Copy(AName, Length(APrefix) + 1, Length(AName))
    else
      AField := '';
  end;

var
  i: Integer;
  oParam: TADParam;
  sField: String;
  oField: TField;
  iNullCount: Integer;
  lIndDefUpdated: Boolean;
  lFldDefUpdated: Boolean;
  oRows: TADDatSRowListBase;
  oFtch: TADFetchOptions;
begin
  ASSERT(not FClientCursor or (FTableParams.FTableCommand = tcBof));
  ASSERT(not FWindowOperation);

  FWindowOperation := True;
  try
    oFtch := FetchOptions;
    AFetched := 0;
    iNullCount := 0;
    if ATable = nil then
      ATable := Table;

    lIndDefUpdated := IndexDefs.Updated;
    lFldDefUpdated := FieldDefs.Updated;
    try
      // avoid repeatative, not needed window operations
      if FServerCursor and (ATable = Table) and (Table <> nil) and (Table.Columns.Count > 0) and
         not (oFtch.LiveWindowFastFirst and not FClientCursor) then
        case FTableParams.FTableCommand of
        tcBof:
          if (FTableParams.FLastTableCommand = tcBof) and
             not oFtch.LiveWindowParanoic then begin
            AFetched := Table.Rows.Count;
            Exit;
          end;
        tcPageUp:
          if FTableParams.FLastTableCommand in [tcPageUp, tcEof] then begin
            if Command.Active then begin
              Command.Fetch(ATable, False, True);
              AFetched := Command.RowsAffected;
            end;
            FTableParams.FLastTableCommand := FTableParams.FTableCommand;
            Exit;
          end;
        tcPageDown:
          if FTableParams.FLastTableCommand in [tcPageDown, tcBof] then begin
            if Command.Active then begin
              Command.Fetch(ATable, False, True);
              AFetched := Command.RowsAffected;
            end;
            FTableParams.FLastTableCommand := FTableParams.FTableCommand;
            Exit;
          end;
        tcEof:
          if (FTableParams.FLastTableCommand = tcEof) and
             not oFtch.LiveWindowParanoic then begin
            AFetched := Table.Rows.Count;
            Exit;
          end;
        end;

      Command.CommandText.Clear;
    finally
      IndexDefs.Updated := lIndDefUpdated;
      FieldDefs.Updated := lFldDefUpdated;
    end;
    Command.CommandText.Add(GenerateSQL);

    // Set master params
    DoMasterParamSetValues(MasterLink.Fields);
    // Set other params
    for i := 0 to Command.Params.Count - 1 do begin
      oParam := Command.Params[i];

      // check range params
      if IsPrefixed(oParam.Name, C_AD_CmdGenRangeStart, sField) then
        oParam.AssignFieldValue(FieldByName(sField),
          GetKeyRow(GetKeyBuffer(kiRangeStart)).ValueS[sField])
      else if IsPrefixed(oParam.Name, C_AD_CmdGenRangeFinish, sField) then
        oParam.AssignFieldValue(FieldByName(sField),
          GetKeyRow(GetKeyBuffer(kiRangeEnd)).ValueS[sField])

      // check locate params
      else if IsPrefixed(oParam.Name, C_AD_CmdGenLocate, sField) then begin
        oParam.AssignFieldValue(FieldByName(sField), GetLocateRow.ValueS[sField]);
        // made LIKE compatible String
        if FTableParams.FLocatePartial and
           (oParam.DataType in [ftString, ftWideString, ftFixedChar
                                {$IFDEF AnyDAC_WIDEMEMO}, ftFixedWideChar {$ENDIF}]) then
          oParam.Value := VarToStr(oParam.Value) + '%';
      end

      // all other params must have WINDOW_ prefix or does not have a prefix for master/detail
      else begin
        if not IsPrefixed(oParam.Name, C_AD_CmdGenWindow, sField) then
          Continue;
        oField := FieldByName(sField);
        case FTableParams.FTableCommand of
        tcBof,
        tcEof,
        tcFindKey,
        tcFindNearest:
          // use key buffer
          oParam.AssignFieldValue(oField, GetKeyRow(GetKeyBuffer(kiLookup)).ValueS[sField]);

        tcPageUp:
          begin
            // use first row
            oRows := GetWindowedRows;
            oParam.AssignFieldValue(oField, oRows[0].ValueS[sField]);
          end;

        tcPageDown:
          begin
            // use last row
            oRows := GetWindowedRows;
            oParam.AssignFieldValue(oField, oRows[oRows.Count - 1].ValueS[sField]);
          end;

        tcCurrentRecord,
        tcGetRecNo,
        tcLocate:
          // for locate (lxoCurrentRecord)
          if SourceView.Rows.Count > 0 then begin
            if Bof then
              // use first row
              oParam.AssignFieldValue(oField, SourceView.Rows[0].ValueS[sField])
            else if Eof then
              // use last row
              oParam.AssignFieldValue(oField, SourceView.Rows[SourceView.Rows.Count - 1].ValueS[sField])
            else if (FRecordIndex > -1) and (FRecordIndex < SourceView.Rows.Count) then
              // use current row
              oParam.AssignFieldValue(oField, SourceView.Rows[FRecordIndex].ValueS[sField]);
          end
          else
            oParam.Clear;
        end;
      end;

      if oParam.IsNull then
        Inc(iNullCount);
    end;

    // When all params are null's or just preparing a SQL - nothing to do
    if not ((Command.Params.Count > 0) and (Command.Params.Count = iNullCount)) and
       not APrepOnly then begin
      lIndDefUpdated := IndexDefs.Updated;
      lFldDefUpdated := FieldDefs.Updated;
      try
        // open and fetch data
        DoPrepareSource;
        DoOpenSource(True, False, False);

         // When paging then append fetched record to the existing ones, otherwise - replace
        if not (FTableParams.FTableCommand in [tcPageUp, tcPageDown]) or AForceClear then
          ATable.Clear;

        if ATable.Columns.Count = 0 then
          Command.Define(ATable);
        Command.Fetch(ATable, (oFtch.LiveWindowFastFirst and not FClientCursor) or
                              not FServerCursor or
                              not (FTableParams.FTableCommand in
                                   [tcBof, tcEof, tcPageUp, tcPageDown]), True);
        AFetched := Command.RowsAffected;
        FAdapter.DatSTableName := ATable.Name;
        FTableParams.FLastTableCommand := FTableParams.FTableCommand;
      finally
        IndexDefs.Updated := lIndDefUpdated;
        FieldDefs.Updated := lFldDefUpdated;
      end;
    end;
  finally
    FWindowOperation := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTable.DoPurge(AView: TADDatSView; ADirection: TADFetchDirection): Integer;
var
  rState: TADDatSLoadState;
  i: Integer;
  ircWindowSize: Integer;
begin
  Result := inherited DoPurge(AView, ADirection);
  if FClientCursor then
    Exit;

  // Calc window size
  ircWindowSize := FWindowSize * FetchOptions.RowsetSize;
  // ATable must be greater than buffer count
  Result := AView.Rows.Count - ircWindowSize - BufferCount;
  if Result <= 0 then begin
    Result := 0;
    Exit;
  end;

  AView.Table.BeginLoadData(rState, lmDestroying);
  try
    case ADirection of
    fdDown:
      // remove top records
      for i := 0 to Result - 1 do
        AView.Table.Rows.Remove(AView.Rows[i]);
    fdUp:
      // remove bottom records
      for i := AView.Rows.Count - 1 downto AView.Rows.Count - Result - 1 do
        AView.Table.Rows.Remove(AView.Rows[i]);
    end;
  finally
    AView.Table.EndLoadData(rState);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTable.DoFetch(ATable: TADDatSTable; AAll: Boolean;
  ADirection: TADFetchDirection): Integer;
begin
  if FClientCursor then begin
    Result := inherited DoFetch(ATable, AAll, ADirection);
    Exit;
  end;

  if AAll then
    ADCapabilityNotSupported(Self, [S_AD_LComp, S_AD_LComp_PClnt]);
  case ADirection of
  fdUp:
    begin
      if GetWindowedRows.Count = 0 then
        FTableParams.FTableCommand := tcEof
      else
        FTableParams.FTableCommand := tcPageUp;
      FetchWindow(Result);
    end;
  fdDown:
    begin
      if GetWindowedRows.Count = 0 then
        FTableParams.FTableCommand := tcBof
      else
        FTableParams.FTableCommand := tcPageDown;
      FetchWindow(Result);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTable.InternalSearch(ATable: TADDatSTable; const AKeyFields: String;
  const AKeyValues: Variant; const AExpression, AResultFields: String;
  AOptions: TADDataSetLocateOptions): Boolean;
var
  iFetched: Integer;
begin
  try
    if AKeyFields <> '' then
      InitLocateRow(AKeyFields, AKeyValues);

    FTableParams.FTableCommand := tcLocate;
    FTableParams.FSelectFields := AResultFields;
    FTableParams.FLocateIgnoreCase := lxoCaseInsensitive in AOptions;
    FTableParams.FLocatePartial := lxoPartialKey in AOptions;
    FTableParams.FLocateBackward := lxoBackward in AOptions;
    FTableParams.FLocateFromCurrent := lxoFromCurrent in AOptions;
    if AExpression = '' then
      FTableParams.FLocateFields := AKeyFields
    else
      FTableParams.FLocateExpression := AExpression;

    FetchWindow(iFetched, False, False, ATable);
    Result := iFetched > 0;
  finally
    FTableParams.FSelectFields := '';
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.RefireSQL;
begin
  if Active then begin
    DisableControls;
    try
      Disconnect;
      Open;
    finally
      EnableControls;
    end;
  end
  else
    SQL.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.InternalFirst;
var
  iFetched: Integer;
begin
  if not FClientCursor then begin
    FTableParams.FTableCommand := tcBof;
    FSourceEOF := False;
    FetchWindow(iFetched);
  end;
  inherited InternalFirst;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.InternalLast;
var
  iFetched: Integer;
begin
  if not FClientCursor then begin
    FTableParams.FTableCommand := tcEof;
    FSourceEOF := False;
    FetchWindow(iFetched);
  end;
  inherited InternalLast;
end;

{-------------------------------------------------------------------------------}
function TADTable.InternalDefaultKeyFieldCount(ABuffer: PADKeyBuffer; ADefault: Integer): Integer;
begin
  Result := ABuffer^.FAssignedFieldCount;
  if Result <= 0 then
    Result := ADefault;
end;

{-------------------------------------------------------------------------------}
function TADTable.InternalGotoKey(ANearest: Boolean): Boolean;
var
  iFetched: Integer;
  oTable: TADDatSTable;
begin
  Result := inherited InternalGotoKey(ANearest);
  if FClientCursor or
     Result and not FetchOptions.LiveWindowParanoic then
    Exit;

  BeginLocate([], nil);

  if ANearest then
    FTableParams.FTableCommand := tcFindNearest
  else
    FTableParams.FTableCommand := tcFindKey;

  oTable := TADDatSTable.Create;
  try
    oTable.Assign(Table);
    FetchWindow(iFetched, False, False, oTable);
    Result := iFetched > 0;
    if Result then begin
      Table.Clear;
      MoveData(oTable, Table);
      FRecordIndex := 0;
    end;
  finally
    ADFree(oTable);
  end;

  EndLocate(Result, 0, [], nil);
end;

{-------------------------------------------------------------------------------}
function TADTable.AllIndexFieldNull(const ARowIndex: Integer): Boolean;
var
  i: Integer;
  sField: String;
begin
  Result := False;
  if SourceView.Rows.Count = 0 then
    Exit;
  i := 1;
  while i <= Length(FTableParams.FIndexFields) do begin
    sField := ADExtractFieldName(FTableParams.FIndexFields, i);
    if not VarIsNull(SourceView.Rows[ARowIndex].ValueS[sField]) then
      Exit;
  end;
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.ClearTableButCurrent;
var
  i: Integer;
  rState: TADDatSLoadState;
  oRow: TADDatSRow;
begin
  // all clear
  if SourceView.Rows.Count <= 1 then
    Exit;
  Table.BeginLoadData(rState, lmDestroying);
  try
    oRow := SourceView.Rows[FRecordIndex];
    for i := Table.Rows.Count - 1 downto 0 do
      if Table.Rows[i] <> oRow then
        Table.Rows.RemoveAt(i);
  finally
    Table.EndLoadData(rState);
    ASSERT((Table.Rows.Count = 1) and (SourceView.Rows.Count <= 1));
  end;
  // set correct index
  FRecordIndex := 0;
  FTableParams.FLastTableCommand := tcUnknown;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.InternalRefresh;
var
  lHasRecs: Boolean;
  iFetched: Integer;
  iLastRecord: Integer;
  oTable: TADDatSTable;
begin
  if FClientCursor then begin
    inherited InternalRefresh;
    Exit;
  end;

  CheckBrowseMode;
  CheckBidirectional;
  if UpdatesPending then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSRefreshError,
      [GetDisplayName]);

  // check no records or stand on a "all null's record"
  lHasRecs := not (IsEmpty or AllIndexFieldNull) and
    (FRecordIndex > -1) and (FRecordIndex <= SourceView.Rows.Count - 1);
  iLastRecord := FRecordIndex;

  // make temporary row
  oTable := TADDatSTable.Create;
  try
    oTable.Assign(Table);
    FSourceEOF := False;

    // when records exist, then try refetch current record
    if lHasRecs then begin
      ClearTableButCurrent;
      lHasRecs := SourceView.Rows.Count > 0;
    end;

    if not lHasRecs then begin
      // when no records, then just fetch bof
      FTableParams.FTableCommand := tcBof;
      FetchWindow(iFetched);
      if iFetched > 0 then
        FRecordIndex := 0
      else
        // set to Bof
        FRecordIndex := -1;
    end

    else begin
      oTable.Clear;
      // backup current rows
      MoveData(Table, oTable);
      FTableParams.FTableCommand := tcCurrentRecord;
      FetchWindow(iFetched);
      if iFetched = 0 then begin
        // check page down
        // current record index
        iLastRecord := -1;
        Table.Clear;
        // restore current rows
        MoveData(oTable, Table);
        FTableParams.FTableCommand := tcPageDown;
        // force clear
        FetchWindow(iFetched, False, True);
        if iFetched = 0 then begin
          // check page up
          Table.Clear;
          // restore current row
          MoveData(oTable, Table);
          FTableParams.FTableCommand := tcPageUp;
          // force clear
          FetchWindow(iFetched, False, True);
          if iFetched = 0 then
            // nothing found
            FSourceEOF := True;
        end;
      end;
    end;

    // just stay on single row in buffer and let Resync refetch window
    FRecordIndex := iLastRecord;
    if FRecordIndex > SourceView.Rows.Count - 1 then
      FRecordIndex := SourceView.Rows.Count - 1;
  finally
    ADFree(oTable);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.InternalDelete;
var
  iFetched: Integer;
begin
  if not FClientCursor then begin
    // If to delete single cached record, then Resync([]) will jump to the
    // first record. Because DoFetch will perform tcBof.
    if SourceView.Rows.Count = 1 then begin
      FTableParams.FTableCommand := tcPageDown;
      FetchWindow(iFetched);
    end;
  end;
  inherited InternalDelete;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.SetFieldData(AField: TField; ABuffer: PADValue);
begin
  inherited SetFieldData(AField, ABuffer);
  if (State in [dsEdit, dsInsert]) and GetIsIndexField(AField) then
    FIndexFieldChanged := True;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.InternalAddRecord(
  Buffer: {$IFDEF AnyDAC_D17} PADBuffer {$ELSE} Pointer {$ENDIF}; Append: Boolean);
begin
  inherited InternalAddRecord(Buffer, Append);
  if not FClientCursor and FIndexFieldChanged then
    ClearTableButCurrent;
  FIndexFieldChanged := False;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.InternalPost;
begin
  inherited InternalPost;
  if not FClientCursor and FIndexFieldChanged then
    if State = dsEdit then begin
      ClearTableButCurrent;
      if IsRanged or Filtered then
        FTableParams.FLastTableCommand := tcUnknown;
    end;
  FIndexFieldChanged := False;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.InternalCancel;
begin
  inherited InternalCancel;
  FIndexFieldChanged := False;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.InternalResetRange;
var
  iFetched: Integer;
begin
  if FClientCursor then begin
    inherited InternalResetRange;
    Exit;
  end;

  if IsRanged then begin
    FTableParams.FLastTableCommand := tcUnknown;
    FTableParams.FTableCommand := tcBof;
    FetchWindow(iFetched);
    First;
  end
  else begin
    FTableParams.FRanged := False;
    FSourceEOF := False;
    Resync([]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.InternalSetRecNo(AValue: Integer);
var
  oTable: TADDatSTable;
  iFetched: Integer;
begin
  if FClientCursor then begin
    inherited InternalSetRecNo(AValue);
    Exit;
  end;

  if AValue < 1  then
    FRecordIndex := -1;

  FTableParams.FTableCommand := tcSetRecNo;
  FTableParams.FRecordNumber := AValue;
  oTable := TADDatSTable.Create;
  try
    oTable.Assign(Table);
    FetchWindow(iFetched, False, False, oTable);
    if iFetched > 0 then begin
      Table.Clear;
      MoveData(oTable, Table);
      FRecordIndex := 0;
    end;
  finally
    ADFree(oTable);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.SetRecNo(AValue: Integer);
begin
  if not FClientCursor then
    Include(FFlags, dfNoRecNoCmp)
  else
    Exclude(FFlags, dfNoRecNoCmp);
  inherited SetRecNo(AValue);
end;

{-------------------------------------------------------------------------------}
function TADTable.GetRecNo: Integer;
var
  oTable: TADDatSTable;
  iFetched: Integer;
begin
  if FClientCursor then begin
    Result := inherited GetRecNo;
    Exit;
  end;

  Result := -1;
  if not FetchOptions.LiveWindowParanoic or
     (SourceView = nil) or (SourceView.Rows.Count = 0) then
    Exit;

  FTableParams.FTableCommand := tcGetRecNo;
  oTable := TADDatSTable.Create;
  try
    FetchWindow(iFetched, False, False, oTable);
    ASSERT(oTable.Rows.Count > 0);
    Result := ADVar2Int(oTable.Rows[0].ValueI[0]);
  finally
    ADFree(oTable);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTable.GetRecordCount: Longint;
var
  oTable: TADDatSTable;
  iFetched: Integer;
begin
  if FClientCursor then begin
    Result := inherited GetRecordCount;
    Exit;
  end;

  Result := 0;
  if (SourceView = nil) or (SourceView.Rows.Count = 0) then
    Exit;

  FTableParams.FTableCommand := tcGetRowCount;
  FTableParams.FRecordCount := 0;
  oTable := TADDatSTable.Create;
  try
    FetchWindow(iFetched, False, False, oTable);
    ASSERT(oTable.Rows.Count > 0);
    Result := ADVar2Int(oTable.Rows[0].ValueI[0]);
  finally
    ADFree(oTable);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTable.InternalLookupEx(const AKeyFields: String; const AKeyValues: Variant;
  const AExpression: String; const AResultFields: String;
  AOptions: TADDataSetLocateOptions = []; ApRecordIndex: PInteger = nil): Variant;
var
  oTable: TADDatSTable;
  lResult: Boolean;
  i, iData, iCols: Integer;
  iPos: Integer;
begin
  // for data window table record index has no sense
  if ApRecordIndex <> nil then
    ApRecordIndex^ := -1;

  if AExpression = '' then
    Result := inherited LookupEx(AKeyFields, AKeyValues, AResultFields, AOptions, @iPos)
  else
    Result := inherited LookupEx(AExpression, AResultFields, AOptions, @iPos);

  if not VarIsNull(Result) and not FetchOptions.LiveWindowParanoic then
    Exit;

  Result := Null;
  oTable := TADDatSTable.Create;
  try
    lResult := InternalSearch(oTable, AKeyFields, AKeyValues, '', AResultFields, AOptions);
    if lResult and (oTable.Rows.Count > 0) then begin
      iCols := 0;
      iData := -1;
      for i := 0 to oTable.Columns.Count - 1 do
        if not (caInternal in oTable.Columns[i].Attributes) then begin
          iData := i;
          Inc(iCols);
        end;
      if iCols = 1 then
        Result := oTable.Rows[0].ValueI[iData]
      else if iCols > 1 then begin
        Result := VarArrayCreate([0, iCols - 1], varVariant);
        iData := 0;
        for i := 0 to oTable.Columns.Count - 1 do
          if not (caInternal in oTable.Columns[i].Attributes) then begin
            Result[iData] := oTable.Rows[0].ValueI[i];
            Inc(iData);
          end;
      end;
    end;
  finally
    ADFree(oTable);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTable.LookupEx(const AExpression, AResultFields: String;
  AOptions: TADDataSetLocateOptions; ApRecordIndex: PInteger): Variant;
begin
  if FClientCursor then
    Result := inherited LookupEx(AExpression, AResultFields, AOptions,
      ApRecordIndex)
  else
    Result := InternalLookupEx('', Null, AExpression, AResultFields, AOptions,
      ApRecordIndex);
end;

{-------------------------------------------------------------------------------}
function TADTable.LookupEx(const AKeyFields: String; const AKeyValues: Variant;
  const AResultFields: String; AOptions: TADDataSetLocateOptions;
  ApRecordIndex: PInteger): Variant;
begin
  if FClientCursor then
    Result := inherited LookupEx(AKeyFields, AKeyValues, AResultFields, AOptions,
      ApRecordIndex)
  else
    Result := InternalLookupEx(AKeyFields, AKeyValues, '', AResultFields, AOptions,
      ApRecordIndex);
end;

{-------------------------------------------------------------------------------}
function TADTable.InternalLocateEx(const AKeyFields: String;
  const AKeyValues: Variant; const AExpression: String;
  AOptions: TADDataSetLocateOptions; ApRecordIndex: PInteger): Boolean;
var
  oTable: TADDatSTable;
  iPos: Integer;
begin
  iPos := BeginLocate(AOptions, ApRecordIndex);

  // for data window table record index has no sense
  if ApRecordIndex <> nil then
    ApRecordIndex^ := -1;

  if AExpression = '' then
    Result := inherited LocateRecord(AKeyFields, AKeyValues, AOptions, iPos)
  else
    Result := inherited LocateRecord(AExpression, AOptions, iPos);

  if Result and not FetchOptions.LiveWindowParanoic and
     ((iPos > 0) or (iPos < SourceView.Rows.Count - 1)) then begin
    // when matching record exists in window and it is not FIRST
    // or LAST (for lxoBackward) matching record in index
    EndLocate(True, iPos, AOptions, nil);
    Exit;
  end;

  oTable := TADDatSTable.Create;
  try
    // for columns and others
    oTable.Assign(Table);
    Result := InternalSearch(oTable, AKeyFields, AKeyValues, AExpression, '', AOptions);
    if Result and not (lxoCheckOnly in AOptions) then begin
      Table.Clear;
      MoveData(oTable, Table);
      EndLocate(True, 0, AOptions, nil);
    end
    else
      EndLocate(False, -1, AOptions, nil);
  finally
    ADFree(oTable);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTable.LocateEx(const AKeyFields: String; const AKeyValues: Variant;
  AOptions: TADDataSetLocateOptions; ApRecordIndex: PInteger): Boolean;
begin
  if FClientCursor then
    Result := inherited LocateEx(AKeyFields, AKeyValues, AOptions, ApRecordIndex)
  else
    Result := InternalLocateEx(AKeyFields, AKeyValues, '', AOptions, ApRecordIndex);
end;

{-------------------------------------------------------------------------------}
function TADTable.LocateEx(const AExpression: String;
  AOptions: TADDataSetLocateOptions; ApRecordIndex: PInteger): Boolean;
begin
  if FClientCursor then
    Result := inherited LocateEx(AExpression, AOptions, ApRecordIndex)
  else
    Result := InternalLocateEx('', Null, AExpression, AOptions, ApRecordIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADTable.DoMasterDefined;
var
  sFields: String;
begin
  sFields := MasterFields;
  inherited DoMasterDefined;
  if sFields <> MasterFields then begin
    FTableParams.FLastTableCommand := tcUnknown;
    RefireSQL;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.DoMasterReset;
begin
  if not FClientCursor then begin
    FTableParams.FLastTableCommand := tcUnknown;
    InternalRefresh;
  end;
  inherited DoMasterReset;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.MasterChanged(Sender: TObject);
begin
  if FClientCursor or
     (IndexFieldNames <> '') or (IndexName <> '') then begin
    FTableParams.FLastTableCommand := tcUnknown;
    inherited MasterChanged(Sender);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.CheckMasterRange;
begin
  if FClientCursor then begin
    inherited CheckMasterRange;
    Exit;
  end;

  if IsLinkedDetail and ((IndexFieldCount = 0) or MasterRangeChanged()) then
    if Active then begin
      FRecordIndex := -1;
      Table.Clear;
      First;
    end;
end;

{$IFDEF AnyDAC_FullIPS}
{-------------------------------------------------------------------------------}
function TADTable.PSGetCommandText: String;
begin
  Result := TableName;
end;

{-------------------------------------------------------------------------------}
function TADTable.PSGetCommandType: TPSCommandType;
begin
  Result := ctTable;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADTable.PSGetTableName: String;
begin
  Result := TableName;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.PSSetCommandText(const ACommandText: String);
begin
  TableName := ACommandText;
end;

{-------------------------------------------------------------------------------}
function TADTable.GetExists: Boolean;
var
  oConn: TADCustomConnection;
  oList: TStrings;
begin
  oConn := Command.AcquireConnection;
  oList := TADStringList.Create;
  try
    try
      oConn.GetTableNames(CatalogName, SchemaName, TableName, oList,
        [osMy, osOther]);
      Result := (oList.Count > 0);
    except
      Result := False;
    end;
  finally
    ADFree(oList);
    Command.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTable.RefreshMetadata;
var
  oConn: TADCustomConnection;
begin
  if ((Connection = nil) and (ConnectionName = '')) or
     (TableName = '') then
    Exit;
  oConn := Command.AcquireConnection;
  try
    if not oConn.Connected then
      Exit;
    oConn.RefreshMetadataCache(TableName);
    IndexDefs.Updated := False;
    IndexDefs.Update;
  finally
    Command.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADCustomStoredProc                                                           }
{-------------------------------------------------------------------------------}
function TADCustomStoredProc.InternalCreateAdapter: TADCustomTableAdapter;
begin
  Result := inherited InternalCreateAdapter;
  Result.SelectCommand.CommandKind := skStoredProc;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.DescriptionsAvailable: Boolean;
var
  oConn: TADCustomConnection;
  oList: TStrings;
begin
  oConn := Command.AcquireConnection;
  oList := TADStringList.Create;
  try
    try
      oConn.GetStoredProcNames(CatalogName, SchemaName, PackageName, StoredProcName,
        oList, [osMy, osOther]);
      Result := (oList.Count > 0);
    except
      Result := False;
    end;
  finally
    ADFree(oList);
    Command.ReleaseConnection(oConn);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.ProcNameChanged;
begin
  Command.CommandKind := skStoredProc;
  if not (csReading in ComponentState) and (csDesigning in ComponentState) and
     (StoredProcName <> '') then
    Prepare;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.ExecProc;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.ExecProcBase(const AProcName: String;
  AFunction: Boolean; const AParams: array of Variant;
  const ATypes: array of TFieldType);
var
  i, j, iOver, iErr: Integer;
  s: String;
begin
  Close;
  if AProcName <> '' then begin
    s := AProcName;
    iOver := 0;
    i := Pos(';', s);
    if i <> 0 then begin
      Val(Copy(s, i + 1, MAXINT), iOver, iErr);
      if iErr = 0 then
        s := Copy(s, 1, i - 1);
    end;
    Overload := iOver;
    StoredProcName := s;
  end;
  if not (fiMeta in FetchOptions.Items) and (Params.Count = 0) then begin
    Params.BindMode := pbByNumber;
    if AFunction then
      Params.Add.ParamType := ptResult;
    for i := 0 to High(AParams) do
      Params.Add;
  end;
  if Params.BindMode = pbByNumber then
    for i := 0 to Params.Count - 1 do
      Params[i].Position := i + 1;
  for i := 0 to High(ATypes) do
    if ATypes[i] <> ftUnknown then
      Params[i].DataType := ATypes[i];
  if fiMeta in FetchOptions.Items then
    Prepare;
  j := 0;
  for i := 0 to High(AParams) do begin
    if Params[j].ParamType = ptResult then
      Inc(j);
    Params[j].Value := AParams[i];
    Inc(j);
  end;
  if not (fiMeta in FetchOptions.Items) then
    Prepare;
  Execute;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.ExecProc(const AProcName: String;
  const AParams: array of Variant; const ATypes: array of TFieldType): LongInt;
begin
  ExecProcBase(AProcName, False, AParams, ATypes);
  Result := RowsAffected;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.ExecProc(const AProcName: String): LongInt;
begin
  Result := ExecProc(AProcName, [], []);
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.ExecProc(const AProcName: String;
  const AParams: array of Variant): LongInt;
begin
  Result := ExecProc(AProcName, AParams, []);
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.ExecFunc: Variant;
begin
  Execute;
  Result := ParamByName('Result').Value;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.ExecFunc(const AProcName: String;
  const AParams: array of Variant; const ATypes: array of TFieldType): Variant;
begin
  ExecProcBase(AProcName, True, AParams, ATypes);
  Result := ParamByName('Result').Value;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.ExecFunc(const AProcName: String): Variant;
begin
  Result := ExecFunc(AProcName, [], []);
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.ExecFunc(const AProcName: String;
  const AParams: array of Variant): Variant;
begin
  Result := ExecFunc(AProcName, AParams, []);
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.GetOverload: Word;
begin
  Result := Command.Overload;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.SetOverload(const AValue: Word);
begin
  if Command.Overload <> AValue then begin
    Command.Overload := AValue;
    ProcNameChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.GetProcName: string;
begin
  Result := Trim(Command.CommandText.Text);
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.SetProcName(const AValue: string);
var
  s: String;
begin
  s := Trim(AValue);
  if Trim(Command.CommandText.Text) <> s then begin
    Command.SetCommandText(s, False);
    ProcNameChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.GetPackageName: String;
begin
  Result := Command.BaseObjectName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.SetPackageName(const AValue: String);
begin
  if Command.BaseObjectName <> AValue then begin
    Command.BaseObjectName := AValue;
    ProcNameChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.GetSchemaName: String;
begin
  Result := Command.SchemaName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.SetSchemaName(const AValue: String);
begin
  if Command.SchemaName <> AValue then begin
    Command.SchemaName := AValue;
    ProcNameChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADCustomStoredProc.GetCatalogName: String;
begin
  Result := Command.CatalogName;
end;

{-------------------------------------------------------------------------------}
procedure TADCustomStoredProc.SetCatalogName(const AValue: String);
begin
  if Command.CatalogName <> AValue then begin
    Command.CatalogName := AValue;
    ProcNameChanged;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADMetaInfoQuery                                                              }
{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.InternalCreateAdapter: TADCustomTableAdapter;
begin
  Result := TADTableAdapter.Create(nil);
  Result.SelectCommand := TADMetaInfoCommand.Create(Result);
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetMetaInfoKind: TADPhysMetaInfoKind;
begin
  Result := TADMetaInfoCommand(Command).MetaInfoKind;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetMetaInfoKind(
  const AValue: TADPhysMetaInfoKind);
begin
  TADMetaInfoCommand(Command).MetaInfoKind := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetObjectName: String;
begin
  Result := TADMetaInfoCommand(Command).ObjectName;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetObjectName(const AValue: String);
begin
  TADMetaInfoCommand(Command).ObjectName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetTableKinds: TADPhysTableKinds;
begin
  Result := TADMetaInfoCommand(Command).TableKinds;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetTableKinds(const AValue: TADPhysTableKinds);
begin
  TADMetaInfoCommand(Command).TableKinds := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetWildcard: String;
begin
  Result := TADMetaInfoCommand(Command).Wildcard;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetWildcard(const AValue: String);
begin
  TADMetaInfoCommand(Command).Wildcard := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetOverload: Word;
begin
  Result := TADMetaInfoCommand(Command).Overload;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetOverload(const AValue: Word);
begin
  TADMetaInfoCommand(Command).Overload := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetObjectScopes: TADPhysObjectScopes;
begin
  Result := TADMetaInfoCommand(Command).ObjectScopes;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetObjectScopes(const AValue: TADPhysObjectScopes);
begin
  TADMetaInfoCommand(Command).ObjectScopes := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetBaseObjectName: String;
begin
  Result := TADMetaInfoCommand(Command).BaseObjectName;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetBaseObjectName(const AValue: String);
begin
  TADMetaInfoCommand(Command).BaseObjectName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetSchemaName: String;
begin
  Result := TADMetaInfoCommand(Command).SchemaName;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetSchemaName(const AValue: String);
begin
  TADMetaInfoCommand(Command).SchemaName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADMetaInfoQuery.GetCatalogName: String;
begin
  Result := TADMetaInfoCommand(Command).CatalogName;
end;

{-------------------------------------------------------------------------------}
procedure TADMetaInfoQuery.SetCatalogName(const AValue: String);
begin
  TADMetaInfoCommand(Command).CatalogName := AValue;
end;

{-------------------------------------------------------------------------------}
initialization

finalization

  if (FManagerSingleton <> nil) and FManagerSingleton.FAutoCreated then begin
    ADFree(FManagerSingleton);
    FManagerSingleton := nil;
  end;

end.
