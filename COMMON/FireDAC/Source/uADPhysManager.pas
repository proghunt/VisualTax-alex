{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{          FireDAC physical layer base classes          }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}
{$HPPEMIT '#pragma link "uADPhysManager"'}

unit uADPhysManager;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Classes, SysUtils, SyncObjs, DB,
  uADStanIntf, uADStanOption, uADStanParam, uADStanUtil, uADStanError,
    uADStanFactory,
  uADDatSManager,
  uADPhysIntf, uADPhysCmdGenerator,
  uADGUIxIntf;

type
  TADPhysManager = class;
  TADPhysDriver = class;
  TADPhysDriverLink = class;
  TADPhysDriverService = class;
  TADPhysConnectionHost = class;
  TADPhysConnection = class;
  TADPhysTransaction = class;
  TADPhysEventThread = class;
  TADPhysEventMessage = class;
  TADPhysEventStartMessage = class;
  TADPhysEventStopMessage = class;
  TADPhysEventAlerter = class;
  TADPhysCommand = class;
  TADPhysDriverClass = class of TADPhysDriver;
  TADPhysConnectionClass = class of TADPhysConnection;

(*$HPPEMIT 'namespace Uadphysmanager { __interface IADPhysTransaction2Obj; };'*)

  TADPhysCliHandles = record
    FDriverCliHandles: Pointer;
    FTxSerialID: LongWord;
    FDriverID: array [0 .. 10] of Char;
  end;
  PADPhysCliHandles = ^TADPhysCliHandles;

  TADPhysFindObjMode = (fomNone, fomMBActive, fomMBNotInactive, fomIfActive);

  TADPhysManager = class(TADObject,
    {$IFNDEF AnyDAC_SkipIUnk} IUnknown, {$ENDIF}
    IADStanObject, IADStanOptions, IADPhysManager, IADPhysManagerMetadata)
  private
    FLock: TCriticalSection;
    FDriverDefs: IADStanDefinitions;
    FDriverIDs: TADStringList;
    FDriverClasses: TADClassList;
    FDriverList: TADPtrList;
    FDriverLinkList: TADObjList;
    FState: TADPhysManagerState;
    FConnectionDefs: IADStanConnectionDefs;
    procedure CheckActive;
    procedure CheckActiveOrStoping;
    procedure CleanupDrivers;
    procedure CleanupManager;
    function DriverByID(const ADriverID: String;
      AMode: TADPhysFindObjMode; ARequired: Boolean): TADPhysDriver;
    function FindDriverLink(const ADriverID: String): TADPhysDriverLink;
    procedure InternalClose(ATerminate, AWaitForClose: Boolean);
    procedure Shutdown;
    procedure ErrorDriverNotReg(const ADriverID, ABaseDriverID: String);
    procedure UpdateDriverIDs;
  protected
    FOptions: IADStanOptions;
    // IUnknown
    function _Release: Integer; stdcall;
{$IFNDEF AnyDAC_FPC}
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
{$ENDIF}
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    // IADStanOptions
    property Options: IADStanOptions read FOptions implements IADStanOptions;
    // IADPhysManager
    procedure CreateDriver(const ADriverID: String;
      out ADrv: IADPhysDriver; AIntfRequired: Boolean = True);
    procedure CreateConnection(const AConnectionDef: IADStanConnectionDef;
      out AConn: IADPhysConnection; AIntfRequired: Boolean = True); overload;
    procedure CreateConnection(const AConDefName: String;
      out AConn: IADPhysConnection; AIntfRequired: Boolean = True); overload;
    procedure CreateMetadata(out AMeta: IADPhysManagerMetadata);
    procedure CreateDefaultConnectionMetadata(out AConMeta: IADPhysConnectionMetadata);
    procedure Open;
    procedure Close(AWait: Boolean = False);
    procedure CloseConnectionDef(const AConnectionDef: IADStanConnectionDef);
    procedure RefreshMetadataCache;
    function DriverIDFromSharedCliHandle(ASharedCliHandle: Pointer): String;
    function GetDriverDefs: IADStanDefinitions;
    function GetConnectionDefs: IADStanConnectionDefs;
    function GetOptions: IADStanOptions;
    function GetState: TADPhysManagerState;
    // IADPhysManagerMetadata
    function GetDriverCount: Integer;
    function GetDriverID(AIndex: Integer): String;
    function GetBaseDriverID(AIndex: Integer): String; overload;
    function GetBaseDriverID(const ADriverID: String): String; overload;
    function GetRDBMSKind(const ADriverID: String): TADRDBMSKind;
    procedure CreateDriverMetadata(const ADriverID: String; out AMeta: IADPhysDriverMetadata);
  public
    procedure Initialize; override;
    destructor Destroy; override;
    procedure RegisterDriverClass(ADriverClass: TADPhysDriverClass);
    procedure UnRegisterDriverClass(ADriverClass: TADPhysDriverClass);
  end;

  TADPhysDriver = class(TInterfacedObject,
    IADStanObject, IADPhysDriver, IADPhysDriverMetadata)
  private
    FLock: TCriticalSection;
    FDriverID: String;
    FParams: IADStanDefinition;
    FState: TADPhysDriverState;
    FManager: TADPhysManager;
    FConnHostList: TADPtrList;
    FConnectionList: TADPtrList;
    FMessages: TADLog;
    FUsageCount: Integer;
    procedure Stop;
    procedure Shutdown;
    function GetBaseDrvID: String;
    function FindConnectionHost(
      const AConnectionDef: IADStanConnectionDef): TADPhysConnectionHost;
  protected
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    // IADPhysDriver
    function GetDriverID: String;
    function GetCliObj: Pointer; virtual;
    function GetMessages: TStrings;
    procedure Load;
    procedure Unload;
    procedure Employ;
    procedure Vacate;
    procedure CreateConnection(const AConnectionDef: IADStanConnectionDef;
      out AConn: IADPhysConnection);
    procedure CloseConnectionDef(const AConnectionDef: IADStanConnectionDef);
    procedure CreateMetadata(out ADrvMeta: IADPhysDriverMetadata);
    procedure CreateConnectionWizard(out AWizard: IADPhysDriverConnectionWizard);
    function GetConnectionCount: Integer;
    function GetConnections(AIndex: Integer): IADPhysConnection;
    function GetState: TADPhysDriverState;
    // IADPhysDriverMetadata
    function GetConnParamCount(AKeys: TStrings): Integer; virtual;
    procedure GetConnParams(AKeys: TStrings; Index: Integer; var
      AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer); virtual;
    // overridable by descendants
    class function GetBaseDriverID: String; virtual;
    procedure InternalLoad; virtual; abstract;
    procedure InternalUnload; virtual; abstract;
    function InternalCreateConnection(AConnHost: TADPhysConnectionHost): TADPhysConnection; virtual; abstract;
    procedure GetVendorParams(out AHome, ALib: String);
  public
    constructor Create(AManager: TADPhysManager; const ADriverDef: IADStanDefinition); virtual;
    destructor Destroy; override;
    property DriverID: String read FDriverID;
    property BaseDriverID: String read GetBaseDrvID;
    property State: TADPhysDriverState read FState;
    property Manager: TADPhysManager read FManager;
    property Params: IADStanDefinition read FParams;
    property Messages: TADLog read FMessages;
  end;

  TADPhysDriverLink = class(TADComponent)
  private
    FDriverID: String;
    FVendorHome: String;
    FVendorLib: String;
    FOnDriverDestroying: TNotifyEvent;
    FOnDriverCreated: TNotifyEvent;
    FServiceList: TADObjList;
    function GetDriverIntf: IADPhysDriver;
    function GetDriverState: TADPhysDriverState;
    function GetServices(AIndex: Integer): TADPhysDriverService;
    function GetServicesCount: Integer;
    procedure SetupDef(const AParams: IADStanDefinition);
  protected
    function GetActualDriverID: String; virtual;
    function GetBaseDriverID: String; virtual;
    function IsConfigured: Boolean; virtual;
    procedure ApplyTo(const AParams: IADStanDefinition); virtual;
    procedure DoDriverCreated; virtual;
    procedure DoDriverDestroying; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Release;
    property DriverState: TADPhysDriverState read GetDriverState;
    property DriverIntf: IADPhysDriver read GetDriverIntf;
    property ActualDriverID: String read GetActualDriverID;
    property ServicesCount: Integer read GetServicesCount;
    property Services[AIndex: Integer]: TADPhysDriverService read GetServices;
  published
    property BaseDriverID: String read GetBaseDriverID;
    property DriverID: String read FDriverID write FDriverID;
    property VendorHome: String read FVendorHome write FVendorHome;
    property VendorLib: String read FVendorLib write FVendorLib;
    property OnDriverCreated: TNotifyEvent read FOnDriverCreated write FOnDriverCreated;
    property OnDriverDestroying: TNotifyEvent read FOnDriverDestroying write FOnDriverDestroying;
  end;

  TADPhysServiceProgressEvent = procedure (ASender: TADPhysDriverService; const AMessage: String) of object;
  TADPhysDriverService = class (TADComponent, IADStanErrorHandler)
  private
    FDriverLink: TADPhysDriverLink;
    FActive: Boolean;
    FOnError: TADErrorEvent;
    FStreamingActive: Boolean;
    FBeforeExecute: TNotifyEvent;
    FAfterExecute: TNotifyEvent;
    procedure SetActive(const AValue: Boolean);
    procedure SetDriverLink(const AValue: TADPhysDriverLink);
    function GetCliObj: TObject;
  protected
    // TComponent
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    // introduced
    function GetActualActive: Boolean; virtual;
    procedure CheckActive(AAutoActivate, ANeedActivation: Boolean); virtual;
    procedure InternalUninstall; virtual;
    procedure InternalInstall; virtual;
    procedure InternalExecute; virtual;
    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception);
    // must be strong-type by descendants
    property DriverLink: TADPhysDriverLink read FDriverLink write SetDriverLink;
    // for static services
    property ActualActive: Boolean read GetActualActive;
    property Active: Boolean read FActive write SetActive default False;
    // for dynamic services
    procedure Execute;
  public
    destructor Destroy; override;
    property CliObj: TObject read GetCliObj;
  published
    property OnError: TADErrorEvent read FOnError write FOnError;
    property BeforeExecute: TNotifyEvent read FBeforeExecute write FBeforeExecute;
    property AfterExecute: TNotifyEvent read FAfterExecute write FAfterExecute;
  end;

  TADPhysConnectionHost = class(TInterfacedObject,
    {$IFNDEF AnyDAC_SkipIUnk} IUnknown, {$ENDIF}
    IADStanObjectHost)
  private
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FDriverObj: TADPhysDriver;
    FConnectionDef: IADStanConnectionDef;
    FConnectionCount: Integer;
    FPool: IADStanObjectFactory;
    FPassCode: LongWord;
{$IFDEF AnyDAC_MONITOR}
    FMonitor: IADMoniClient;
    FInitialTracing: Boolean;
    procedure AddMoniClient;
{$ENDIF}
    procedure Employ;
    procedure Vacate;
  protected
    // IUnknown
    function _AddRef: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
    function _Release: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
    // IADStanObjectHost
    function GetObjectKindName: TComponentName;
    procedure CreateObject(out AObject: IADStanObject);
    // other
  public
    constructor Create(ADriver: TADPhysDriver; const AConnectionDef: IADStanConnectionDef);
    destructor Destroy; override;
    procedure CreateConnection(out AConn: IADPhysConnection);
    property ConnectionDef: IADStanConnectionDef read FConnectionDef;
  end;

  TADPhysConnection = class(TInterfacedObject,
    {$IFNDEF AnyDAC_SkipIUnk} IUnknown, {$ENDIF}
    IADMoniAdapter, IADStanObject, IADStanOptions, IADStanErrorHandler,
    IADPhysConnection)
  private
    FDriver: IADPhysDriver;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FDriverObj: TADPhysDriver;
    FConnHost: TADPhysConnectionHost;
    FLock: TCriticalSection;
    FErrorHandler: IADStanErrorHandler;
    FRecoveryHandler: IADPhysConnectionRecoveryHandler;
    FMetadata: TObject;
    FLogin: IADGUIxLoginDialog;
    FLoginPrompt: Boolean;
    FPreparedCommands: Integer;
    FInternalConnectionDef: IADStanConnectionDef;
    FPoolManaged: Boolean;
    FMoniAdapterHelper: TADMoniAdapterHelper;
    FSharedHandle: PADPhysCliHandles;
    FTransaction: IADPhysTransaction;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FTransactionObj: TADPhysTransaction;
    FDontCallStateHandler: Boolean;
    FCliHandles: TADPhysCliHandles;
{$IFDEF AnyDAC_MONITOR}
    procedure UpdateMonitor;
{$ENDIF}
    procedure CheckInactive;
    procedure CheckActive(ADisconnectingAllowed: Boolean = False);
    procedure IncPrepared(ACommand: TADPhysCommand);
    procedure DecPrepared;
    procedure ConnectBase;
    procedure DoConnect;
    procedure DoLogin;
    procedure CheckTransaction;
    procedure AllocTransactionHandles;
    procedure ReleaseTransactionHandles;
    procedure DisconnectTransactions;
    procedure DisconnectCommands;
    function GetDriverID: String;
    procedure DisconnectEvents;
    procedure RecoverConnection(const AInitiator: IADStanObject; AOnLogin: Boolean);
  public
    // IUnknown
    function _AddRef: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
    function _Release: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
  protected
    FOptions: IADStanOptions;
{$IFDEF AnyDAC_MONITOR}
    FMonitor: IADMoniClient;
    FTracing: Boolean;
{$ENDIF}
    // IADMoniAdapter
    function GetHandle: LongWord;
    function GetItemCount: Integer; virtual;
    procedure GetItem(AIndex: Integer; out AName: String; out AValue: Variant;
      out AKind: TADMoniAdapterItemKind); virtual;
    function GetSupportItems: TADMoniAdapterItemKinds; virtual;
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    // IADStanOptions
    property Options: IADStanOptions read FOptions implements IADStanOptions;
    procedure GetParentOptions(out AOpts: IADStanOptions);
    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception);
    // IADPhysConnection
    function GetDriver: IADPhysDriver;
    function GetState: TADPhysConnectionState;
    function GetOptions: IADStanOptions;
    function GetCommandCount: Integer;
    function GetCommands(AIndex: Integer): IADPhysCommand;
    function GetErrorHandler: IADStanErrorHandler;
    function GetRecoveryHandler: IADPhysConnectionRecoveryHandler;
    function GetLogin: IADGUIxLoginDialog;
    function GetLoginPrompt: Boolean;
    function GetConnectionDef: IADStanConnectionDef;
    function GetMessages: EADDBEngineException; virtual;
    function GetCliObj: Pointer; virtual;
    function GetCliHandle: Pointer;
    function GetSharedCliHandle: Pointer;
    function GetTransaction: IADPhysTransaction;
    function GetTransactionCount: Integer;
    function GetTransactions(AIndex: Integer): IADPhysTransaction;
    function GetCurrentCatalog: String;
    function GetCurrentSchema: String;
    function GetEventCount: Integer;
    function GetEvents(AIndex: Integer): IADPhysEventAlerter;
    procedure SetOptions(const AValue: IADStanOptions);
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    procedure SetRecoveryHandler(const AValue: IADPhysConnectionRecoveryHandler);
    procedure SetLogin(const AValue: IADGUIxLoginDialog);
    procedure SetLoginPrompt(const AValue: Boolean);
    procedure SetSharedCliHandle(AValue: Pointer);
    procedure SetTransaction(const AValue: IADPhysTransaction);
    procedure SetCurrentCatalog(const AValue: String);
    procedure SetCurrentSchema(const AValue: String);
    procedure CreateMetadata(out AConnMeta: IADPhysConnectionMetadata);
    procedure CreateCommandGenerator(out AGen: IADPhysCommandGenerator;
      const ACommand: IADPhysCommand);
    procedure CreateCommand(out ACmd: IADPhysCommand);
    procedure CreateMetaInfoCommand(out AMetaCmd: IADPhysMetaInfoCommand);
    procedure CreateTransaction(out ATx: IADPhysTransaction);
    procedure CreateEvent(const AEventKind: String; out AEvent: IADPhysEventAlerter);
    procedure Open;
    procedure Close;
    procedure ForceDisconnect;
    function Ping: Boolean;
    procedure ChangePassword(const ANewPassword: String);
    function GetLastAutoGenValue(const AName: String = ''): Variant; virtual;
    procedure SaveLastAutoGenValue(const AValue: Variant);
    function Clone: IADPhysConnection;
    procedure AnalyzeSession(AMessages: TStrings); virtual;
{$IFDEF AnyDAC_MONITOR}
    procedure TracingChanged;
    function GetTracing: Boolean;
    procedure SetTracing(AValue: Boolean);
    function GetMonitor: IADMoniClient;
    procedure TraceList(AList: TStrings; const AName: String);
    procedure TraceConnInfo(AKind: TADMoniAdapterItemKind; const AName: String);
{$ENDIF}
  protected
    // overridable by descendants
    procedure InternalConnect; virtual; abstract;
    procedure InternalSetMeta; virtual;
    procedure InternalDisconnect; virtual; abstract;
    procedure InternalPing; virtual;
    function InternalCreateMetadata: TObject; virtual; abstract;
    function InternalCreateTransaction: TADPhysTransaction; virtual; abstract;
    function InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter; virtual;
    function InternalCreateCommand: TADPhysCommand; virtual; abstract;
    function InternalCreateMetaInfoCommand: TADPhysCommand; virtual;
    function InternalCreateCommandGenerator(
      const ACommand: IADPhysCommand): TADPhysCommandGenerator; virtual; abstract;
    procedure InternalChangePassword(
      const AUserName, AOldPassword, ANewPassword: String); virtual;
{$IFDEF AnyDAC_MONITOR}
    procedure InternalTracingChanged; virtual;
{$ENDIF}
    procedure InternalOverrideNameByCommand(
      var AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand); virtual;
    procedure InternalExecuteDirect(
      const ASQL: String; ATransaction: TADPhysTransaction); virtual; abstract;
    function InternalGetCurrentCatalog: String; virtual;
    function InternalGetCurrentSchema: String; virtual;
    function InternalGetCliHandle: Pointer; virtual;
    function InternalGetSharedCliHandle: Pointer; virtual;
    procedure InternalAnalyzeSession(AMessages: TStrings); virtual;
  protected
    FState: TADPhysConnectionState;
    FCommandList: TADPtrList;
    FTransactionList: TADPtrList;
    FEventList: TADPtrList;
    FDefaultSchema,
    FDefaultCatalog,
    FCurrentCatalog,
    FCurrentSchema: String;
    FAvoidImplicitMeta,
    FRemoveDefaultMeta: TADPhysNameParts;
    FLastAutoGenValue: Variant;
{$IFDEF AnyDAC_MONITOR}
    procedure Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      const AMsg: String; const AArgs: array of const);
{$ENDIF}
  public
    constructor Create(ADriverObj: TADPhysDriver; AConnHost: TADPhysConnectionHost); virtual;
    destructor Destroy; override;
    procedure Lock;
    procedure Unlock;
    property DriverObj: TADPhysDriver read FDriverObj;
    property TransactionObj: TADPhysTransaction read FTransactionObj;
    property ConnectionDef: IADStanConnectionDef read GetConnectionDef;
    property CliObj: Pointer read GetCliObj;
    property DefaultSchema: String read FDefaultSchema;
    property DefaultCatalog: String read FDefaultCatalog;
    property AvoidImplicitMeta: TADPhysNameParts read FAvoidImplicitMeta;
    property RemoveDefaultMeta: TADPhysNameParts read FRemoveDefaultMeta;
    property DriverID: String read GetDriverID;
  end;

  IADPhysTransaction2Obj = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2170}']
    function GetObj: TADPhysTransaction;
    property Obj: TADPhysTransaction read GetObj;
  end;

  TADPhysTxNotification = (
    cpBeforeCmdPrepare, cpAfterCmdPrepareSuccess, cpAfterCmdPrepareFailure,
    cpAfterCmdUnprepare,
    cpBeforeCmdExecute, cpAfterCmdExecuteSuccess, cpAfterCmdExecuteFailure);

  TADPhysTransaction = class(TInterfacedObject,
    IADMoniAdapter, IADStanObject, IADStanErrorHandler,
    IADPhysTransaction, IADPhysTransaction2Obj)
  private
    FConnection: IADPhysConnection;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FConnectionObj: TADPhysConnection;
    FOptions,
    FExternalOptions: TADTxOptions;
    FSavepoints: TADStringList;
    FSerialID: LongWord;
    FMoniAdapterHelper: TADMoniAdapterHelper;
    FRetaining: Boolean;
    FCommandList: TADPtrList;
    FState: TADPhysTransactionState;
    FStateHandlerList: TInterfaceList;
    FPrevAutoStop: Boolean;
    FExplicitActive: Boolean;
    FLockAutoStopCount: Integer;
    FNotifyCount: Integer;
    FSharedActive: Boolean;
{$IFDEF AnyDAC_MONITOR}
    procedure UpdateMonitor;
{$ENDIF}
    function GetCLIAutoCommit: Boolean;
    function GetDriverID: String;
    procedure TxOperation(AOperation: TADPhysTransactionState;
      ABefore: Boolean);
  protected
    // IADMoniAdapter
    function GetHandle: LongWord;
    function GetItemCount: Integer; virtual;
    procedure GetItem(AIndex: Integer; out AName: String; out AValue: Variant;
      out AKind: TADMoniAdapterItemKind); virtual;
    function GetSupportItems: TADMoniAdapterItemKinds; virtual;
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception);
    // IADPhysTransaction
    function GetOptions: TADTxOptions;
    function GetActive: Boolean;
    function GetTopSerialID: LongWord;
    function GetSerialID: LongWord;
    function GetNestingLevel: LongWord;
    function GetConnection: IADPhysConnection;
    function GetCliObj: Pointer; virtual;
    function GetState: TADPhysTransactionState;
    procedure SetOptions(const AValue: TADTxOptions);
    function StartTransaction: LongWord;
    procedure Commit;
    procedure CommitRetaining;
    procedure Rollback;
    procedure RollbackRetaining;
    procedure LockAutoStop;
    procedure UnlockAutoStop(ASuccess, AAllowStop: Boolean);
    procedure AddStateHandler(const AHandler: IADPhysTransactionStateHandler);
    procedure RemoveStateHandler(const AHandler: IADPhysTransactionStateHandler);
    procedure Disconnect;
    // IADPhysTransaction2Obj
    function GetObj: TADPhysTransaction;
  protected
    FIDAutoCommit: LongWord;
    // overridable by descendants
    procedure InternalStartTransaction(AID: LongWord); virtual; abstract;
    procedure InternalCommit(AID: LongWord); virtual; abstract;
    procedure InternalRollback(AID: LongWord); virtual; abstract;
    procedure InternalSetSavepoint(const AName: String); virtual;
    procedure InternalRollbackToSavepoint(const AName: String); virtual;
    procedure InternalCommitSavepoint(const AName: String); virtual;
    procedure InternalChanged; virtual;
    procedure InternalAllocHandle; virtual;
    procedure InternalReleaseHandle; virtual;
    procedure InternalSelect; virtual;
    procedure InternalUnSelect; virtual;
    procedure InternalNotify(ANotification: TADPhysTxNotification;
      ACommandObj: TADPhysCommand); virtual;
    procedure InternalCheckState(ACommandObj: TADPhysCommand; ASuccess: Boolean); virtual;
    // other
    procedure Update;
    procedure DisconnectCommands(AFilter: TADPhysDisconnectFilter;
      AMode: TADPhysDisconnectMode);
    procedure Stop(ASuccess: Boolean);
    procedure CheckStoping(AAllowUnprepare, AForce, ASuccess: Boolean;
      ACommandObj: TADPhysCommand);
    procedure Notify(ANotification: TADPhysTxNotification;
      ACommandObj: TADPhysCommand);
    procedure TransactionFinished;
    procedure TransactionStarted;
    procedure ReleaseHandleBase;
  public
    constructor Create(AConnection: TADPhysConnection); virtual;
    destructor Destroy; override;
    property ConnectionObj: TADPhysConnection read FConnectionObj;
    property Retaining: Boolean read FRetaining;
    property CLIAutoCommit: Boolean read GetCLIAutoCommit;
    property DriverID: String read GetDriverID;
  end;

  TADPhysEventThread = class(TADThread)
  private
    FAlerter: TADPhysEventAlerter;
  protected
    procedure DoTimeout; override;
    class function GetStartMsgClass: TADThreadMsgClass; override;
    class function GetStopMsgClass: TADThreadMsgClass; override;
  public
    constructor Create(AAlerter: TADPhysEventAlerter);
  end;

  TADPhysEventMessage = class(TADThreadMsgBase)
  private
    FMsgThread: TADPhysEventThread;
    procedure BasePerform;
  public
    function Perform(AThread: TADThread): Boolean; override;
  end;

  TADPhysEventStartMessage = class(TADThreadStartMsg)
  public
    function Perform(AThread: TADThread): Boolean; override;
  end;

  TADPhysEventStopMessage = class(TADThreadStopMsg)
  public
    function Perform(AThread: TADThread): Boolean; override;
  end;

  TADPhysEventAlerter = class(TInterfacedObject,
    IADMoniAdapter, IADStanObject, IADStanErrorHandler,
    IADPhysEventAlerter)
  private
    FConnection: IADPhysConnection;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FConnectionObj: TADPhysConnection;
    FKind: String;
    FState: TADPhysEventAlerterState;
    FNames: TADStringList;
    FHandler: IADPhysEventHandler;
    FOptions,
    FExternalOptions: TADEventAlerterOptions;
    FMoniAdapterHelper: TADMoniAdapterHelper;
    function GetDriverID: String;
    procedure DoNamesChanging(ASender: TObject);
{$IFDEF AnyDAC_MONITOR}
    procedure UpdateMonitor;
{$ENDIF}
  protected
    FMsgThread: TADThread;
    function IsRunning: Boolean;
    procedure SetupCommand(const ACmd: IADPhysCommand);
    // IADMoniAdapter
    function GetHandle: LongWord;
    function GetItemCount: Integer; virtual;
    procedure GetItem(AIndex: Integer; out AName: String; out AValue: Variant;
      out AKind: TADMoniAdapterItemKind); virtual;
    function GetSupportItems: TADMoniAdapterItemKinds; virtual;
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception);
    // IADPhysEventAlerter
    function GetConnection: IADPhysConnection;
    function GetState: TADPhysEventAlerterState;
    function GetKind: String;
    function GetOptions: TADEventAlerterOptions;
    function GetNames: TStrings;
    function GetHandler: IADPhysEventHandler;
    procedure SetOptions(const AValue: TADEventAlerterOptions);
    procedure SetNames(const AValue: TStrings);
    procedure SetHandler(const AValue: IADPhysEventHandler);
    procedure Register;
    procedure Unregister;
    procedure Signal(const AEvent: String; const AArgument: Variant);
    procedure AbortJob;
    // overridable by descendants
    procedure InternalAllocHandle; virtual;
    procedure InternalReleaseHandle; virtual;
    procedure InternalTimeout; virtual;
    procedure InternalHandle(AEventMessage: TADPhysEventMessage); virtual; abstract;
    procedure InternalAbortJob; virtual;
    procedure InternalRegister; virtual;
    procedure InternalUnregister; virtual;
    procedure InternalSignal(const AEvent: String; const AArgument: Variant); virtual; abstract;
  public
    constructor Create(AConnection: TADPhysConnection; const AKind: String); virtual;
    destructor Destroy; override;
    property ConnectionObj: TADPhysConnection read FConnectionObj;
    property DriverID: String read GetDriverID;
  end;

  TADPhysDataTableInfo = record
    FSourceName: String;
    FSourceID: Integer;
    FOriginName: String;
  end;

  TADPhysDataColumnInfo = record
    FParentTableSourceID: Integer;
    FTableSourceID: Integer;
    FSourceName: String;
    FSourceID: Integer;
    FSourceTypeName: String;
    FSourceType: TADDataType;
    FOriginTabName: TADPhysParsedName;
    FOriginColName: String;
    FType: TADDataType;
    FLen: LongWord;
    FPrec: Integer;
    FScale: Integer;
    FAttrs: TADDataAttributes;
    FForceAddOpts,
    FForceRemOpts: TADDataOptions;
  end;

  TADPhysCommand = class(TInterfacedObject,
    {$IFNDEF AnyDAC_SkipIUnk} IUnknown, {$ENDIF}
    IADMoniAdapter, IADStanObject, IADStanOptions, IADStanErrorHandler,
    IADPhysCommand, IADPhysMetaInfoCommand)
  private
    FBaseObjectName: String;
    FSchemaName: String;
    FCatalogName: string;
    FCommandText: String;
    FCommandKind: TADPhysCommandKind;
    FFixedCommandKind: Boolean;
    FMacros: TADMacros;
    FParams: TADParams;
    FMetaInfoKind: TADPhysMetaInfoKind;
    FObjectScopes: TADPhysObjectScopes;
    FTableKinds: TADPhysTableKinds;
    FWildcard: String;
    FExecutor: IADStanAsyncExecutor;
    FState: TADPhysCommandState;
    FThreadID: TADThreadID;
    FSourceObjectName: String;
    FSourceRecordSetName: String;
    FRecordSetIndex: Integer;
    FOverload: Word;
    FEof: Boolean;
    FFirstFetch: Boolean;
    FNextRecordSet: Boolean;
    FErrorHandler: IADStanErrorHandler;
    FExecuteCount: Integer;
    FStateHandler: IADPhysCommandStateHandler;
    FRowsAffected: TADCounter;
    FRowsAffectedReal: Boolean;
    FErrorAction: TADErrorAction;
    FMappingHandler: IADPhysMappingHandler;
    FMoniAdapterHelper: TADMoniAdapterHelper;
{$IFDEF AnyDAC_MONITOR}
    procedure UpdateMonitor;
{$ENDIF}
    procedure CheckState(ARequiredState: TADPhysCommandState);
    function DoDefineDataTable(ADatSManager: TADDatSManager; ATable: TADDatSTable;
      ARootID: Integer; const ARootName: String; AMetaInfoMergeMode: TADPhysMetaInfoMergeMode): TADDatSTable;
    procedure PreprocessCommand(ACreateParams, ACreateMacros,
      AExpandParams, AExpandMacros, AExpandEscapes, AParseSQL: Boolean);
    procedure OpenBase;
    procedure FetchBase(ATable: TADDatSTable; AAll: Boolean);
    procedure ExecuteBase(ATimes, AOffset: LongInt);
    procedure BeginDefine;
    function GetParamsOwner: TPersistent;
    function GetDriverID: String;
    procedure CheckPreprocessCommand(ACreateParams: Boolean);
    procedure ExecuteTask(const AOperation: IADStanAsyncOperation;
      const AHandler: IADStanAsyncHandler; ABlocked: Boolean);
  protected
    FOptions: IADStanOptions;
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    // IADStanErrorHandler
    procedure HandleException(const AInitiator: IADStanObject;
      var AException: Exception);
    // IADStanOptions
    property Options: IADStanOptions read FOptions implements IADStanOptions;
    procedure GetParentOptions(out AOpts: IADStanOptions);
    // IADMoniAdapter
    function GetHandle: LongWord;
    function GetItemCount: Integer; virtual;
    procedure GetItem(AIndex: Integer; out AName: String; out AValue: Variant;
      out AKind: TADMoniAdapterItemKind); virtual;
    function GetSupportItems: TADMoniAdapterItemKinds; virtual;
    // IADPhysCommand
    function GetSchemaName: String;
    function GetCatalogName: String;
    function GetBaseObjectName: String;
    function GetConnection: IADPhysConnection;
    function GetOptions: IADStanOptions;
    function GetState: TADPhysCommandState;
    function GetCommandText: String;
    function GetCommandKind: TADPhysCommandKind;
    function GetParams: TADParams;
    function GetOverload: Word;
    function GetNextRecordSet: Boolean;
    function GetErrorHandler: IADStanErrorHandler;
    function GetSourceObjectName: String;
    function GetSourceRecordSetName: String;
    function GetMacros: TADMacros;
    function GetRowsAffected: TADCounter;
    function GetRowsAffectedReal: Boolean;
    function GetErrorAction: TADErrorAction;
    function GetMappingHandler: IADPhysMappingHandler;
    function GetSQLOrderByPos: Integer;
    function GetCliObj: Pointer; virtual;
    function GetTransaction: IADPhysTransaction;
    function GetSQLText: String;
    function GetStateHandler: IADPhysCommandStateHandler;
    procedure SetSchemaName(const AValue: String);
    procedure SetCatalogName(const AValue: String);
    procedure SetBaseObjectName(const AValue: String);
    procedure SetOptions(const AValue: IADStanOptions);
    procedure SetCommandText(const AValue: String);
    procedure SetCommandKind(const AValue: TADPhysCommandKind);
    procedure SetSourceObjectName(const AValue: String);
    procedure SetSourceRecordSetName(const AValue: String);
    procedure SetNextRecordSet(const AValue: Boolean);
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    procedure SetOverload(const AValue: Word);
    procedure SetMappingHandler(const AValue: IADPhysMappingHandler);
    procedure SetState(const AValue: TADPhysCommandState);
    procedure SetTransaction(const AValue: IADPhysTransaction);
    procedure SetStateHandler(const AValue: IADPhysCommandStateHandler);
    procedure SetMacros(AValue: TADMacros);
    procedure SetParams(AValue: TADParams);
    procedure AbortJob(const AWait: Boolean = False);
    function Define(ADatSManager: TADDatSManager; ATable: TADDatSTable = nil;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset): TADDatSTable; overload;
    function Define(ATable: TADDatSTable;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset): TADDatSTable; overload;
    procedure Execute(ATimes: Integer = 0; AOffset: Integer = 0;
      ABlocked: Boolean = False);
    procedure Fetch(ATable: TADDatSTable; AAll: Boolean = True;
      ABlocked: Boolean = False); overload;
    procedure Fetch(ADatSManager: TADDatSManager;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset); overload;
    procedure Preprocess;
    procedure Prepare(const ACommandText: String = ''; ACreateParams: Boolean = True);
    procedure Unprepare;
    procedure Open(ABlocked: Boolean = False);
    procedure Close;
    procedure CloseAll;
    procedure Disconnect;
    procedure CheckAsyncProgress;
    // IADPhysMetaInfoCommand
    function GetMetaInfoKind: TADPhysMetaInfoKind;
    procedure SetMetaInfoKind(AValue: TADPhysMetaInfoKind);
    function GetTableKinds: TADPhysTableKinds;
    procedure SetTableKinds(AValue: TADPhysTableKinds);
    function GetWildcard: String;
    procedure SetWildcard(const AValue: String);
    function GetObjectScopes: TADPhysObjectScopes;
    procedure SetObjectScopes(AValue: TADPhysObjectScopes);
  protected
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FConnectionObj: TADPhysConnection;
    FConnection: IADPhysConnection;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FTransactionObj: TADPhysTransaction;
    FTransaction: IADPhysTransaction;
    FDbCommandText: String;
    FBuffer: TADBuffer;
    FSQLValuesPos: Integer;
    FSQLValuesPosEnd: Integer;
    FSQLOrderByPos: Integer;
    FSQLLimitSkip,
    FSQLLimitRows: Integer;
    FRecordsFetched: Integer;
    // utils
    function GetTraceCommandText(const ACmd: String = ''): String;
{$IFDEF AnyDAC_MONITOR}
    procedure Trace(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      const AMsg: String; const AArgs: array of const);
    function EnterTrace(AConnObj: TADPhysConnection): Boolean;
    function ExitTrace(AConnObj: TADPhysConnection; var AUpdateMonitor: Boolean): Boolean;
{$ENDIF}
    function CheckFetchColumn(ADataType: TADDataType; AAttributes: TADDataAttributes): Boolean; overload;
    procedure CheckParamMatching(AParam: TADParam;
      ADataType: TFieldType; AParamType: TParamType; APrec: Integer);
    procedure CreateCommandGenerator(out AGen: IADPhysCommandGenerator);
    function OpenBlocked: Boolean;
    procedure GenerateStoredProcParams(const AName: TADPhysParsedName;
      AOverload: Word = 0);
    procedure GenerateStoredProcCall(const AName: TADPhysParsedName;
      ASPUsage: TADPhysCommandKind = skStoredProc);
    procedure GetSelectMetaInfoParams(out AName: TADPhysParsedName);
    procedure GenerateSelectMetaInfo(const AName: TADPhysParsedName);
    procedure GenerateLimitSelect();
    procedure GenerateParamMarkers();
    procedure ColTypeMapError(AColumn: TADDatSColumn);
    procedure ParTypeMapError(AParam: TADParam);
    procedure ParTypeUnknownError(AParam: TADParam);
    procedure ParDefChangedError(ADataType: TFieldType; AParam: TADParam);
    procedure ParSetChangedError(AExpected, AActual: Integer);
    procedure CheckMetaInfoParams(const AName: TADPhysParsedName);
    procedure CheckExact(AUseRecsMax: Boolean; ATimes, AOffset: Integer;
      AValue: TADCounter; AFetch: Boolean);
    // overridables
    procedure InternalAbort; virtual;
    procedure InternalPrepare; virtual; abstract;
    procedure InternalUnprepare; virtual; abstract;
    function InternalOpen: Boolean; virtual; abstract;
    function InternalNextRecordSet: Boolean; virtual; abstract;
    procedure InternalClose; virtual; abstract;
    procedure InternalExecute(ATimes: LongInt; AOffset: LongInt; var ACount: TADCounter); virtual; abstract;
    function InternalUseStandardMetadata: Boolean; virtual;
    function InternalColInfoStart(var ATabInfo: TADPhysDataTableInfo): Boolean; virtual; abstract;
    function InternalColInfoGet(var AColInfo: TADPhysDataColumnInfo): Boolean; virtual; abstract;
    function InternalFetchRowSet(ATable: TADDatSTable; AParentRow: TADDatSRow;
      ARowsetSize: LongWord): LongWord; virtual; abstract;
  public
    constructor Create(AConnection: TADPhysConnection);
    destructor Destroy; override;
    property DriverID: String read GetDriverID;
  end;

var
  ADPhysManagerObj: TADPhysManager;

implementation

uses
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ELSE}
  ActiveX,
{$ENDIF}
{$IFDEF POSIX}
  Posix.Pthread,
{$ENDIF}
{$IFDEF AnyDAC_D17}
  System.Generics.Defaults,
  System.Generics.Collections,
  System.Types,
{$ENDIF}
  uADStanConst, uADStanResStrs,
  uADPhysCmdPreprocessor, uADPhysConnMeta;

const
  CFOMs: array[Boolean] of TADPhysFindObjMode = (fomIfActive, fomMBActive);

{ ----------------------------------------------------------------------------- }
{ TADPhysManager                                                                }
{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.Initialize;
begin
  inherited Initialize;
  FLock := TCriticalSection.Create;
  ADPhysManagerObj := Self;
  FOptions := TADOptionsContainer.Create(nil, TADFetchOptions,
    TADUpdateOptions, TADTopResourceOptions, nil);
  FDriverIDs := TADStringList.Create;
  FDriverClasses := TADClassList.Create;
  FDriverList := TADPtrList.Create;
  FDriverLinkList := TADObjList.Create;
end;

{ ----------------------------------------------------------------------------- }
destructor TADPhysManager.Destroy;
begin
  CleanupManager;
  FDriverDefs := nil;
  FConnectionDefs := nil;
  ADFreeAndNil(FDriverList);
  ADFreeAndNil(FDriverLinkList);
  ADFreeAndNil(FDriverClasses);
  ADFreeAndNil(FDriverIDs);
  _AddRef;
  FOptions := nil;
  inherited Destroy;
  ADPhysManagerObj := nil;
  ADFreeAndNil(FLock);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager._Release: Integer;
begin
  Result := ADDecRef;
  if Result = 0 then
    Shutdown;
end;

{ ----------------------------------------------------------------------------- }
{$IFNDEF AnyDAC_FPC}
function TADPhysManager.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Result := inherited QueryInterface(IID, Obj);
  if IsEqualGUID(IID, IADPhysManagerMetadata) then
    UpdateDriverIDs;
end;
{$ENDIF}

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetOptions: IADStanOptions;
begin
  Result := Self as IADStanOptions;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetConnectionDefs: IADStanConnectionDefs;
begin
  if FConnectionDefs = nil then
    ADCreateInterface(IADStanConnectionDefs, FConnectionDefs);
  Result := FConnectionDefs;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetDriverDefs: IADStanDefinitions;
begin
  if FDriverDefs = nil then begin
    ADCreateInterface(IADStanDefinitions, FDriverDefs);
    FDriverDefs.Name := S_AD_DefDrvFileName;
    FDriverDefs.Storage.DefaultFileName := S_AD_DefDrvFileName;
    FDriverDefs.Storage.GlobalFileName := ADReadRegValue(S_AD_DrvValName);
  end;
  Result := FDriverDefs;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetState: TADPhysManagerState;
begin
  Result := FState;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CheckActive;
begin
  if FState <> dmsActive then
    ADException(Self, [S_AD_LPhys], er_AD_AccDrvMngrMB, ['Active']);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CheckActiveOrStoping;
begin
  if not (FState in [dmsActive, dmsStoping, dmsTerminating]) then
    ADException(Self, [S_AD_LPhys], er_AD_AccDrvMngrMB, ['Active or Stoping']);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.RegisterDriverClass(ADriverClass: TADPhysDriverClass);
begin
  FDriverClasses.Add(ADriverClass);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.UnRegisterDriverClass(ADriverClass: TADPhysDriverClass);
begin
  FDriverClasses.Remove(ADriverClass);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.Open;
begin
  GetConnectionDefs;
  GetDriverDefs;
  FState := dmsActive;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CleanupDrivers;
var
  i: Integer;
  {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} oDrv: TADPhysDriver;
begin
  FLock.Enter;
  try
    for i := FDriverList.Count - 1 downto 0 do begin
      oDrv := TADPhysDriver(FDriverList[i]);
      if oDrv.FState in [drsRegistered, drsLoaded, drsActive] then
        oDrv.Shutdown;
    end;
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CleanupManager;
begin
  FLock.Enter;
  try
    if FDriverDefs <> nil then
      FDriverDefs.Clear;
    if FConnectionDefs <> nil then
      FConnectionDefs.Clear;
    FState := dmsInactive;
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.InternalClose(ATerminate, AWaitForClose: Boolean);
var
  i: Integer;
  lStop, lTimeOut, lFree: Boolean;
  dwStartTime: LongWord;
begin
  lStop := False;
  lFree := False;
  lTimeOut := False;
  try
    FLock.Enter;
    try
      if (FState = dmsInactive) and not ATerminate then
        Exit;
      if ATerminate and (FState in [dmsStoping, dmsInactive]) then begin
        lFree := (FState = dmsInactive) and (RefCount = 0);
        FState := dmsTerminating;
      end
      else begin
        if FState <> dmsInactive then begin
          CheckActive;
          lStop := True;
        end;
        if ATerminate then
          FState := dmsTerminating
        else
          FState := dmsStoping;
      end;
      if lStop then
        for i := 0 to FDriverList.Count - 1 do
          TADPhysDriver(FDriverList[i]).Stop;
    finally
      FLock.Leave;
    end;
  finally
    dwStartTime := ADGetTickCount();
    while not lTimeOut and (FDriverList.Count > 0) do begin
      lTimeOut := ADTimeout(dwStartTime, C_AD_PhysManagerShutdownTimeout);
      CleanupDrivers;
      Sleep(1);
    end;
    if FDriverList.Count = 0 then
      if FState = dmsTerminating then
        lFree := True
      else if FState = dmsStoping then
        CleanupManager;
    if lTimeOut then
      ADException(nil, [S_AD_LPhys], er_AD_AccShutdownTO, []);
    if lFree then
      ADFree(Self);
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.Close(AWait: Boolean);
begin
  InternalClose(False, AWait);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.Shutdown;
begin
  InternalClose(True, True);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.ErrorDriverNotReg(const ADriverID, ABaseDriverID: String);
var
  sDrvID, s: String;
begin
  if ABaseDriverID <> '' then
    sDrvID := ABaseDriverID
  else
    sDrvID := ADriverID;
  if (CompareText(sDrvID, S_AD_DBXId) = 0) or
     (CompareText(sDrvID, S_AD_TDBXId) = 0) or
     (CompareText(sDrvID, S_AD_ODBCId) = 0) or
     (CompareText(sDrvID, S_AD_MSSQLId) = 0) or
     (CompareText(sDrvID, S_AD_MSAccId) = 0) or
     (CompareText(sDrvID, S_AD_DB2Id) = 0) or
     (CompareText(sDrvID, S_AD_MySQLId) = 0) or
     (CompareText(sDrvID, S_AD_OraId) = 0) or
     (CompareText(sDrvID, S_AD_ASAId) = 0) or
     (CompareText(sDrvID, S_AD_ADSId) = 0) or
     (CompareText(sDrvID, S_AD_IBId) = 0) or
     (CompareText(sDrvID, S_AD_PGId) = 0) or
     (CompareText(sDrvID, S_AD_SQLiteId) = 0) or
     (CompareText(sDrvID, S_AD_DataSnapId) = 0) then
    s := Format(S_AD_AccSrcNotFoundExists, [UpperCase(ABaseDriverID)])
  else
    s := Format(S_AD_AccSrcNotFoundNotExists, [UpperCase(ADriverID), S_AD_DefDrvFileName]);
  ADException(Self, [S_AD_LPhys], er_AD_AccSrvNotFound, [ADriverID, s]);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.DriverByID(const ADriverID: String;
  AMode: TADPhysFindObjMode; ARequired: Boolean): TADPhysDriver;
var
  oDef: IADStanDefinition;
  oDrvClass: TADPhysDriverClass;
  oLink: TADPhysDriverLink;
  sBaseDriverID: String;
  i: Integer;
begin
  if ADriverID = '' then
    ADException(Self, [S_AD_LPhys], er_AD_AccSrvNotDefined, []);

  sBaseDriverID := '';
  FLock.Enter;
  try
    case AMode of
    fomNone:
      ;
    fomMBActive:
      CheckActive;
    fomMBNotInactive:
      CheckActiveOrStoping;
    fomIfActive:
      if FState <> dmsActive then begin
        Result := nil;
        Exit;
      end;
    end;

    Result := nil;
    for i := 0 to FDriverList.Count - 1 do
      if CompareText(TADPhysDriver(FDriverList[i]).FDriverID, ADriverID) = 0 then begin
        Result := TADPhysDriver(FDriverList[i]);
        Break;
      end;

    if (Result = nil) and ARequired then begin
      oDef := GetDriverDefs.FindDefinition(ADriverID);
      if oDef = nil then begin
        oDef := GetDriverDefs.Add;
        oDef.Name := ADriverID;
      end;

      oLink := FindDriverLink(ADriverID);
      if oLink <> nil then
        oLink.SetupDef(oDef);

      sBaseDriverID := oDef.AsString[C_AD_DrvBaseId];
      if sBaseDriverID = '' then
        sBaseDriverID := oDef.Name;
      oDrvClass := nil;
      for i := 0 to FDriverClasses.Count - 1 do
        if CompareText(TADPhysDriverClass(FDriverClasses[i]).GetBaseDriverID, sBaseDriverID) = 0 then begin
          oDrvClass := TADPhysDriverClass(FDriverClasses[i]);
          Break;
        end;

      if oDrvClass <> nil then
        Result := oDrvClass.Create(Self, oDef);
    end;

  finally
    FLock.Leave;
  end;

  if Result = nil then begin
    if ARequired then
      ErrorDriverNotReg(ADriverID, sBaseDriverID);
  end
  else
    Result.FLock.Enter;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.FindDriverLink(const ADriverID: String): TADPhysDriverLink;
var
  i: Integer;
begin
  Result := nil;
  FLock.Enter;
  try
    for i := 0 to FDriverLinkList.Count - 1 do
      if CompareText(TADPhysDriverLink(FDriverLinkList[i]).ActualDriverID, ADriverID) = 0 then begin
        Result := TADPhysDriverLink(FDriverLinkList[i]);
        Exit;
      end;
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CreateDriver(const ADriverID: String;
  out ADrv: IADPhysDriver; AIntfRequired: Boolean);
var
  oDrv: TADPhysDriver;
begin
  ADrv := nil;
  oDrv := DriverByID(ADriverID, CFOMs[AIntfRequired], True);
  if oDrv <> nil then begin
    ADrv := oDrv as IADPhysDriver;
    oDrv.FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CreateConnection(const AConnectionDef: IADStanConnectionDef;
  out AConn: IADPhysConnection; AIntfRequired: Boolean);
var
  oDrv: TADPhysDriver;
begin
  ASSERT(AConnectionDef <> nil);
  AConn := nil;
  GetConnectionDefs.BeginRead;
  try
    oDrv := DriverByID(AConnectionDef.DriverID, CFOMs[AIntfRequired], True);
    if oDrv <> nil then
      try
        oDrv.CreateConnection(AConnectionDef, AConn);
      finally
        oDrv.FLock.Leave;
      end;
  finally
    GetConnectionDefs.EndRead;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CreateConnection(const AConDefName: String;
  out AConn: IADPhysConnection; AIntfRequired: Boolean);
var
  oDef: IADStanConnectionDef;
begin
  if Pos('=', AConDefName) <> 0 then begin
    oDef := GetConnectionDefs.AddTemporary as IADStanConnectionDef;
    oDef.ParseString(AConDefName);
  end
  else
    oDef := GetConnectionDefs.ConnectionDefByName(AConDefName);
  CreateConnection(oDef, AConn, AIntfRequired);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CreateMetadata(out AMeta: IADPhysManagerMetadata);
begin
  Supports(TObject(Self), IADPhysManagerMetadata, AMeta);
  ASSERT(Assigned(AMeta));
{$IFDEF AnyDAC_FPC}
  UpdateDriverIDs;
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CreateDefaultConnectionMetadata(
  out AConMeta: IADPhysConnectionMetadata);
begin
  AConMeta := TADPhysConnectionMetadata.Create(nil, 0, 0, False) as IADPhysConnectionMetadata;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CreateDriverMetadata(const ADriverID: String;
  out AMeta: IADPhysDriverMetadata);
var
  oDrv: IADPhysDriver;
begin
  CreateDriver(ADriverID, oDrv);
  oDrv.CreateMetadata(AMeta);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.RefreshMetadataCache;
var
  i, j: Integer;
  oDrv: TADPhysDriver;
  oConnMeta: IADPhysConnectionMetadata;
begin
  FLock.Enter;
  try
    for i := 0 to FDriverList.Count - 1 do begin
      oDrv := TADPhysDriver(FDriverList[i]);
      for j := 0 to oDrv.GetConnectionCount - 1 do
        if Supports(oDrv.GetConnections(j), IADPhysConnectionMetadata, oConnMeta) then
          oConnMeta.RefreshMetadataCache;
    end;
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.DriverIDFromSharedCliHandle(ASharedCliHandle: Pointer): String;
begin
  if ASharedCliHandle = nil then
    Result := ''
  else
    Result := String(PADPhysCliHandles(ASharedCliHandle)^.FDriverID);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.CloseConnectionDef(const AConnectionDef: IADStanConnectionDef);
var
  oDrv: TADPhysDriver;
begin
  ASSERT(AConnectionDef <> nil);
  oDrv := DriverByID(AConnectionDef.DriverID, fomIfActive, False);
  if oDrv <> nil then
    try
      oDrv.CloseConnectionDef(AConnectionDef);
    finally
      oDrv.FLock.Leave;
    end;
end;

{ ----------------------------------------------------------------------------- }
// IADPhysManagerMetadata

procedure TADPhysManager.UpdateDriverIDs;
var
  i, j: Integer;
  oDef: IADStanDefinition;
  oLink: TADPhysDriverLink;
  sID, sBaseID: String;
  lHasImpl: Boolean;
begin
  FLock.Enter;
  try
    FDriverIDs.Clear;
    FDriverIDs.Sorted := True;
    FDriverIDs.Duplicates := dupIgnore;
    for i := 0 to GetDriverDefs.Count - 1 do
      FDriverIDs.Add(GetDriverDefs[i].Name);
    for i := 0 to FDriverLinkList.Count - 1 do
      FDriverIDs.Add(TADPhysDriverLink(FDriverLinkList[i]).ActualDriverID);
    for i := 0 to FDriverClasses.Count - 1 do
      FDriverIDs.Add(TADPhysDriverClass(FDriverClasses[i]).GetBaseDriverID);
    FDriverIDs.Sorted := False;
    for i := FDriverIDs.Count - 1 downto 0 do begin
      sID := FDriverIDs[i];
      sBaseID := '';
      oDef := GetDriverDefs.FindDefinition(sID);
      if oDef <> nil then
        sBaseID := oDef.AsString[C_AD_DrvBaseId]
      else begin
        oLink := FindDriverLink(sID);
        if oLink <> nil then
          sBaseID := oLink.BaseDriverID;
      end;
      if sBaseID = '' then
        sBaseID := sID;
      lHasImpl := False;
      for j := 0 to FDriverClasses.Count - 1 do
        if CompareText(TADPhysDriverClass(FDriverClasses[j]).GetBaseDriverID, sBaseID) = 0 then begin
          lHasImpl := True;
          Break;
        end;
      if not lHasImpl then
        FDriverIDs.Delete(i)
      else
        FDriverIDs[i] := sID + '=' + sBaseID;
    end;
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetDriverCount: Integer;
begin
  Result := FDriverIDs.Count;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetDriverID(AIndex: Integer): String;
begin
  Result := ADNameFromIndex(FDriverIDs, AIndex);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetBaseDriverID(AIndex: Integer): String;
begin
  Result := ADValueFromIndex(FDriverIDs, AIndex);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetBaseDriverID(const ADriverID: String): String;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to FDriverIDs.Count - 1 do
    if CompareText(GetDriverID(i), ADriverID) = 0 then begin
      Result := GetBaseDriverID(i);
      Break;
    end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetRDBMSKind(const ADriverID: String): TADRDBMSKind;
var
  sId: String;
  i: TADRDBMSKind;
begin
  Result := mkUnknown;
  sId := GetBaseDriverID(ADriverID);
  for i := Low(TADRDBMSKind) to High(TADRDBMSKind) do
    if CompareText(sId, C_AD_PhysRDBMSIds[i]) = 0 then begin
      Result := i;
      Break;
    end;
end;

{ ----------------------------------------------------------------------------- }
// IADStanObject

function TADPhysManager.GetName: TComponentName;
begin
  Result := ClassName;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysManager.GetParent: IADStanObject;
begin
  Result := nil;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.AfterReuse;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.BeforeReuse;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysManager.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
{ TADPhysDriver                                                                 }
{ ----------------------------------------------------------------------------- }
constructor TADPhysDriver.Create(AManager: TADPhysManager; const ADriverDef: IADStanDefinition);
var
  oParentDef: IADStanDefinition;
  sBaseDriverID: String;
begin
  inherited Create;
  // Pins the driver in the manager
  _AddRef;
  FState := drsUnknown;
  FManager := AManager;
  FManager.FLock.Enter;
  FManager.FDriverList.Add(Self);
  FManager.FLock.Leave;
  FLock := TCriticalSection.Create;
  FDriverID := ADriverDef.Name;
  sBaseDriverID := ADriverDef.AsString[C_AD_DrvBaseId];
  if (sBaseDriverID <> '') and (sBaseDriverID <> FDriverID) then begin
    if ADriverDef.ParentDefinition = nil then begin
      oParentDef := AManager.GetDriverDefs.FindDefinition(sBaseDriverID);
      if (oParentDef <> nil) and (ADriverDef <> oParentDef) then
        ADriverDef.ParentDefinition := oParentDef;
    end;
  end;
  FParams := ADriverDef;
  FState := drsRegistered;
  FConnHostList := TADPtrList.Create;
  FConnectionList := TADPtrList.Create;
  FMessages := TADLog.Create;
end;

{ ----------------------------------------------------------------------------- }
destructor TADPhysDriver.Destroy;
var
  i: Integer;
begin
  Shutdown;
  for i := FConnHostList.Count - 1 downto 0 do
    ADFree(TADPhysConnectionHost(FConnHostList[i]));
  ADFreeAndNil(FConnHostList);
  ADFreeAndNil(FConnectionList);
  FManager.FLock.Enter;
  FManager.FDriverList.Remove(Self);
  FManager.FLock.Leave;
  FState := drsUnknown;
  FParams := nil;
  FManager := nil;
  ADFreeAndNil(FLock);
  ADFreeAndNil(FMessages);
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetDriverID: String;
begin
  Result := FDriverID;
end;

{ ----------------------------------------------------------------------------- }
class function TADPhysDriver.GetBaseDriverID: String;
begin
  Result := '';
  ASSERT(False);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetBaseDrvID: String;
begin
  Result := GetBaseDriverID;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetState: TADPhysDriverState;
begin
  Result := FState;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetCliObj: Pointer;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysDriver.GetMessages: TStrings;
begin
  Result := Messages;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetConnectionCount: Integer;
begin
  Result := FConnectionList.Count;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetConnections(AIndex: Integer): IADPhysConnection;
begin
  FLock.Enter;
  try
    Result := TADPhysConnection(FConnectionList[AIndex]) as IADPhysConnection;
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.Stop;
var
  i: Integer;
  oConnHost: TADPhysConnectionHost;
begin
  FLock.Enter;
  try
    for i := 0 to FConnHostList.Count - 1 do begin
      oConnHost := TADPhysConnectionHost(FConnHostList[i]);
      if oConnHost.FPool <> nil then
        oConnHost.FPool.Close;
    end;
    if FState <> drsActive then
      Exit;
    if FRefCount <= 1 then begin
      FState := drsLoaded;
      Exit;
    end;
    FState := drsStoping;
    for i := FConnectionList.Count - 1 downto 0 do
      TADPhysConnection(FConnectionList[i]).ForceDisconnect;
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.Unload;
var
  oLink: TADPhysDriverLink;
begin
  FLock.Enter;
  try
    if FState <> drsLoaded then
      Exit;
    oLink := FManager.FindDriverLink(FDriverID);
    if oLink <> nil then
      oLink.DoDriverDestroying;
    try
      InternalUnload;
    except
      // not visible
    end;
    FState := drsRegistered;
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.Shutdown;
var
  lLeave: Boolean;
begin
  lLeave := True;
  FLock.Enter;
  try
    Stop;
    Unload;
    if (FState = drsRegistered) and (FRefCount = 1) then
      lLeave := _Release > 0;
  finally
    if lLeave then
      FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.Load;
var
  oLink: TADPhysDriverLink;
begin
  FLock.Enter;
  try
    if FState <> drsRegistered then
      Exit;
    oLink := FManager.FindDriverLink(FDriverID);
    FMessages.Clear;
    FMessages.Start('Loading driver ' + FDriverID);
    try
      try
        FState := drsLoading;
        if oLink <> nil then
          oLink.SetupDef(FParams);
        InternalLoad;
        FState := drsLoaded;
      except
        on E: Exception do begin
          FState := drsRegistered;
          FMessages.Msg('Error: ' + E.Message);
          raise;
        end;
      end;
    finally
      FMessages.Stop;
    end;
    if oLink <> nil then
      oLink.DoDriverCreated;
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.Employ;
begin
  FLock.Enter;
  try
    Load;
    if ADInterlockedIncrement(FUsageCount) = 1 then
      if FState = drsLoaded then
        FState := drsActive;
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.Vacate;
begin
  FLock.Enter;
  try
    if ADInterlockedDecrement(FUsageCount) = 0 then
      if FState in [drsActive, drsStoping] then
        FState := drsLoaded;
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.GetVendorParams(out AHome, ALib: String);
begin
  if Params <> nil then begin
    AHome := Params.AsXString[S_AD_DrvVendorHome];
    ALib := Params.AsXString[S_AD_DrvVendorLib];
  end
  else begin
    AHome := '';
    ALib := '';
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.FindConnectionHost(
  const AConnectionDef: IADStanConnectionDef): TADPhysConnectionHost;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to FConnHostList.Count - 1 do
    if TADPhysConnectionHost(FConnHostList[i]).FConnectionDef = AConnectionDef then begin
      Result := TADPhysConnectionHost(FConnHostList[i]);
      Break;
    end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.CreateConnection(const AConnectionDef: IADStanConnectionDef;
  out AConn: IADPhysConnection);
var
  oConnHost: TADPhysConnectionHost;
begin
  ASSERT(AConnectionDef <> nil);
  FLock.Enter;
  try
    oConnHost := FindConnectionHost(AConnectionDef);
    if oConnHost = nil then
      oConnHost := TADPhysConnectionHost.Create(Self, AConnectionDef);
    oConnHost.CreateConnection(AConn);
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.CloseConnectionDef(const AConnectionDef: IADStanConnectionDef);
var
  oConnHost: TADPhysConnectionHost;
begin
  ASSERT(AConnectionDef <> nil);
  FLock.Enter;
  try
    oConnHost := FindConnectionHost(AConnectionDef);
    if oConnHost <> nil then begin
      if oConnHost.FPool <> nil then
        oConnHost.FPool.Close;
      ADFree(oConnHost);
    end;
  finally
    FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.CreateMetadata(out ADrvMeta: IADPhysDriverMetadata);
begin
  Supports(TObject(Self), IADPhysDriverMetadata, ADrvMeta);
  ASSERT(Assigned(ADrvMeta));
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.CreateConnectionWizard(
  out AWizard: IADPhysDriverConnectionWizard);
begin
  Supports(TObject(Self), IADPhysDriverConnectionWizard, AWizard);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetConnParamCount(AKeys: TStrings): Integer;
begin
  Result := 6;
  if (AKeys <> nil) and
     (CompareText(AKeys.Values[S_AD_ConnParam_Common_Pooled], S_AD_True) = 0) then
    Result := Result + 3;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.GetConnParams(AKeys: TStrings; Index: Integer;
  var AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
var
  i: Integer;
begin
  ALoginIndex := -1;
  ADefVal := '';
  case Index of
  0:
    begin
      AName := S_AD_ConnParam_Common_DriverID;
      AType := '';
      for i := 0 to FManager.FDriverList.Count - 1 do begin
        if AType <> '' then
          AType := AType + ';';
        AType := AType + TADPhysDriver(FManager.FDriverList[i]).DriverID;
      end;
      ADefVal := GetDriverID;
      ACaption := AName;
    end;
  1:
    begin
      AName := S_AD_ConnParam_Common_Pooled;
      AType := '@L';
      ADefVal := S_AD_False;
      ACaption := AName;
    end;
  2:
    begin
      AName := S_AD_ConnParam_Common_Database;
      AType := '@S';
      ACaption := AName;
    end;
  3:
    begin
      AName := S_AD_ConnParam_Common_UserName;
      AType := '@S';
      ALoginIndex := 0;
      ACaption := S_AD_ConnParam_Common_BDEStyleUserName;
    end;
  4:
    begin
      AName := S_AD_ConnParam_Common_Password;
      AType := '@S';
      ALoginIndex := 1;
      ACaption := AName;
    end;
  5:
    begin
      AName := S_AD_ConnParam_Common_MonitorBy;
      AType := S_AD_MoniFlatFile + ';' + S_AD_MoniRemote + ';' + S_AD_MoniCustom;
      ADefVal := '';
      ACaption := AName;
    end;
  else
    if (AKeys <> nil) and
       (CompareText(AKeys.Values[S_AD_ConnParam_Common_Pooled], S_AD_True) = 0) then begin
      AType := '@I';
      case Index of
      6:
        begin
          AName := S_AD_PoolParam_CleanupTimeout;
          ADefVal := IntToStr(C_AD_PoolCleanupTimeout);
        end;
      7:
        begin
          AName := S_AD_PoolParam_ExpireTimeout;
          ADefVal := IntToStr(C_AD_PoolExpireTimeout);
        end;
      8:
        begin
          AName := S_AD_PoolParam_MaximumItems;
          ADefVal := IntToStr(C_AD_PoolMaximumItems);
        end;
      end;
      ACaption := AName;
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
// IADStanObject

function TADPhysDriver.GetName: TComponentName;
begin
  Result := GetDriverID;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriver.GetParent: IADStanObject;
begin
  Supports(ADPhysManager, IADStanObject, Result);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.AfterReuse;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.BeforeReuse;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriver.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
{ TADPhysDriverLink                                                             }
{ ----------------------------------------------------------------------------- }
constructor TADPhysDriverLink.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ADPhysManager();
  ADPhysManagerObj.FLock.Enter;
  ADPhysManagerObj.FDriverLinkList.Add(Self);
  ADPhysManagerObj.FLock.Leave;
  FServiceList := TADObjList.Create;
end;

{ ----------------------------------------------------------------------------- }
destructor TADPhysDriverLink.Destroy;
var
  i: Integer;
begin
  for i := FServiceList.Count - 1 downto 0 do
    TADPhysDriverService(FServiceList[i]).DriverLink := nil;
  if ADPhysManagerObj <> nil then begin
    ADPhysManagerObj.FLock.Enter;
    ADPhysManagerObj.FDriverLinkList.Remove(Self);
    ADPhysManagerObj.FLock.Leave;
  end;
  ADFreeAndNil(FServiceList);
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriverLink.GetBaseDriverID: String;
begin
  ASSERT(False);
  Result := '';
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriverLink.GetActualDriverID: String;
begin
  if DriverID = '' then
    Result := BaseDriverID
  else
    Result := DriverID;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriverLink.GetDriverIntf: IADPhysDriver;
begin
  ADPhysManager.CreateDriver(ActualDriverID, Result, True);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriverLink.GetDriverState: TADPhysDriverState;
var
  oDrv: TADPhysDriver;
begin
  Result := drsUnknown;
  if ADPhysManagerObj <> nil then begin
    oDrv := ADPhysManagerObj.DriverByID(ActualDriverID, fomIfActive, False);
    if oDrv <> nil then begin
      Result := oDrv.State;
      oDrv.FLock.Leave;
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverLink.Release;
var
  oDrv: TADPhysDriver;
begin
  if ADPhysManagerObj <> nil then begin
    oDrv := ADPhysManagerObj.DriverByID(ActualDriverID, fomIfActive, False);
    if oDrv <> nil then
      try
        if oDrv.GetConnectionCount > 0 then
          ADException(Self, [S_AD_LPhys], er_AD_AccCannotReleaseDrv, [ActualDriverID]);
      finally
        if oDrv._Release > 0 then
          oDrv.FLock.Leave;
      end;
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriverLink.IsConfigured: Boolean;
begin
  Result := (FVendorHome <> '') or (FVendorLib <> '') or (FDriverID <> '');
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverLink.ApplyTo(const AParams: IADStanDefinition);
begin
  if FVendorHome <> '' then
    AParams.AsString[S_AD_DrvVendorHome] := FVendorHome;
  if FVendorLib <> '' then
    AParams.AsString[S_AD_DrvVendorLib] := FVendorLib;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverLink.SetupDef(const AParams: IADStanDefinition);
begin
  AParams.AsString[C_AD_DrvBaseId] := BaseDriverID;
  if IsConfigured then
    ApplyTo(AParams);
  AParams.MarkUnchanged;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriverLink.GetServices(AIndex: Integer): TADPhysDriverService;
begin
  Result := TADPhysDriverService(FServiceList[AIndex]);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriverLink.GetServicesCount: Integer;
begin
  Result := FServiceList.Count;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverLink.DoDriverCreated;
var
  i: Integer;
  oSvc: TADPhysDriverService;
begin
  if Assigned(FOnDriverCreated) then
    FOnDriverCreated(Self);
  for i := 0 to FServiceList.Count - 1 do begin
    oSvc := TADPhysDriverService(FServiceList[i]);
    if oSvc.ActualActive then
      oSvc.InternalInstall;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverLink.DoDriverDestroying;
var
  i: Integer;
  oSvc: TADPhysDriverService;
begin
  for i := 0 to FServiceList.Count - 1 do begin
    oSvc := TADPhysDriverService(FServiceList[i]);
    if oSvc.ActualActive then
      oSvc.InternalUnInstall;
  end;
  if Assigned(FOnDriverDestroying) then
    FOnDriverDestroying(Self);
end;

{ ----------------------------------------------------------------------------- }
{ TADPhysDriverService                                                          }
{ ----------------------------------------------------------------------------- }
destructor TADPhysDriverService.Destroy;
begin
  Active := False;
  DriverLink := nil;
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverService.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
    if AComponent = DriverLink then
      DriverLink := nil;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriverService.GetActualActive: Boolean;
begin
  Result := (DriverLink <> nil) and Active;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverService.CheckActive(AAutoActivate, ANeedActivation: Boolean);
begin
  if DriverLink = nil then
    ADException(Self, [S_AD_LPhys], er_AD_SvcLinkMBSet, []);
  if AAutoActivate and not Active then
    Active := True;
  if ANeedActivation and not Active then
    ADException(Self, [S_AD_LPhys, DriverLink.ActualDriverID], er_AD_SvcMBActive, []);
  if ADPhysManager().State = dmsInactive then
    ADPhysManager().Open;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverService.SetActive(const AValue: Boolean);
begin
  if FActive <> AValue then
    if csReading in ComponentState then
      FStreamingActive := AValue
    else begin
      FActive := AValue;
      if AValue then begin
        if (DriverLink <> nil) and (DriverLink.DriverState in [drsLoaded, drsActive]) then
          InternalInstall;
      end
      else
        InternalUninstall;
    end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverService.Loaded;
begin
  inherited Loaded;
  if FStreamingActive then
    Active := True;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverService.SetDriverLink(const AValue: TADPhysDriverLink);
begin
  if FDriverLink <> AValue then begin
    Active := False;
    if FDriverLink <> nil then
      FDriverLink.FServiceList.Remove(Self);
    FDriverLink := AValue;
    if FDriverLink <> nil then
      FDriverLink.FServiceList.Add(Self);
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysDriverService.GetCliObj: TObject;
begin
  Result := DriverLink.DriverIntf.CliObj;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverService.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
begin
  if Assigned(FOnError) then
    FOnError(Self, AInitiator, AException);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverService.Execute;
var
  oDrv: IADPhysDriver;
begin
  if Assigned(BeforeExecute) then
    BeforeExecute(Self);
  CheckActive(False, False);
  oDrv := DriverLink.DriverIntf;
  try
    oDrv.Employ;
    try
      InternalExecute;
    finally
      oDrv.Vacate;
    end;
  finally
    oDrv := nil;
  end;
  if Assigned(AfterExecute) then
    AfterExecute(Self);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverService.InternalInstall;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverService.InternalUninstall;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysDriverService.InternalExecute;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
{ TADPhysConnectionHost                                                         }
{ ----------------------------------------------------------------------------- }
constructor TADPhysConnectionHost.Create(ADriver: TADPhysDriver;
  const AConnectionDef: IADStanConnectionDef);
begin
  inherited Create;
  FDriverObj := ADriver;
  FDriverObj.FLock.Enter;
  FDriverObj.FConnHostList.Add(Self);
  FDriverObj.FLock.Leave;
  FPassCode := Random($7FFFFFFF);
  FConnectionDef := AConnectionDef;
{$IFDEF AnyDAC_MONITOR}
  FInitialTracing := True;
  if FConnectionDef.MonitorBy <> '' then
    AddMoniClient;
{$ENDIF}
  if FConnectionDef.Pooled and not ADIsDesignTime then begin
    if FConnectionDef.Style <> atTemporary then
      FConnectionDef.ToggleUpdates(FPassCode, True, True);
    ADCreateInterface(IADStanObjectFactory, FPool);
    FPool.Open(Self, FConnectionDef);
  end
  else
    if FConnectionDef.Style <> atTemporary then
      FConnectionDef.ToggleUpdates(FPassCode, True, False);
end;

{ ----------------------------------------------------------------------------- }
destructor TADPhysConnectionHost.Destroy;
begin
  ASSERT(FConnectionCount = 0);
  FDriverObj.FLock.Enter;
  FDriverObj.FConnHostList.Remove(Self);
  FDriverObj.FLock.Leave;
  if FConnectionDef.Style = atTemporary then begin
    if FConnectionDef.ParentDefinition <> nil then
      FConnectionDef.ParentDefinition := nil;
  end
  else
    FConnectionDef.ToggleUpdates(FPassCode, False, False);
  FPassCode := 0;
  FDriverObj := nil;
  FConnectionDef := nil;
  FPool := nil;
{$IFDEF AnyDAC_MONITOR}
  FMonitor := nil;
{$ENDIF}  
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnectionHost._AddRef: Integer;
begin
  Result := -1;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnectionHost._Release: Integer;
begin
  Result := -1;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnectionHost.Employ;
begin
  if ADInterlockedIncrement(FConnectionCount) = 1 then
    if FConnectionDef.Style <> atTemporary then
      FConnectionDef.ToggleUpdates(FPassCode, True, True);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnectionHost.Vacate;
begin
  if ADInterlockedDecrement(FConnectionCount) = 0 then
    if FConnectionDef.Style <> atTemporary then
      FConnectionDef.ToggleUpdates(FPassCode, True, False)
    else if not FConnectionDef.Pooled then
      ADFree(Self);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnectionHost.GetObjectKindName: TComponentName;
begin
  Result := 'connection';
  if (FConnectionDef <> nil) and (FConnectionDef.Name <> '') then
    Result := Result + ' ' + FConnectionDef.Name;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnectionHost.CreateObject(out AObject: IADStanObject);
begin
  AObject := FDriverObj.InternalCreateConnection(Self) as IADStanObject;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnectionHost.CreateConnection(out AConn: IADPhysConnection);
var
  oObj: IADStanObject;
begin
  if FConnectionDef.Pooled and not ADIsDesignTime then begin
    FPool.Acquire(oObj);
    Supports(oObj, IADPhysConnection, AConn);
  end
  else
    AConn := FDriverObj.InternalCreateConnection(Self) as IADPhysConnection;
end;

{ ----------------------------------------------------------------------------- }
{$IFDEF AnyDAC_MONITOR}
procedure TADPhysConnectionHost.AddMoniClient;
var
  s: String;
  rGUID: TGUID;
  oClnt: IUnknown;
begin
  FMonitor := nil;
  s := Trim(FConnectionDef.MonitorBy);
  if s = '' then
    Exit;
  if ADInSet(s[Length(s)], ['-', '+']) then begin
    FInitialTracing := s[Length(s)] = '+';
    s := Copy(s, 1, Length(s) - 1);
  end;
  if CompareText(s, S_AD_MoniRemote) = 0 then
    rGUID := IADMoniRemoteClient
  else if CompareText(s, S_AD_MoniFlatFile) = 0 then
    rGUID := IADMoniFlatFileClient
  else if CompareText(s, S_AD_MoniCustom) = 0 then
    rGUID := IADMoniCustomClient
  else
    Exit;
  ADCreateInterface(rGUID, oClnt);
  FMonitor := oClnt as IADMoniClient;
end;
{$ENDIF}

{ ----------------------------------------------------------------------------- }
{ TADPhysConnection                                                             }
{ ----------------------------------------------------------------------------- }
constructor TADPhysConnection.Create(ADriverObj: TADPhysDriver;
  AConnHost: TADPhysConnectionHost);
begin
  FDriver := ADriverObj as IADPhysDriver;
  FDriverObj := ADriverObj;
  FDriverObj.FLock.Enter;
  try
    FMoniAdapterHelper := TADMoniAdapterHelper.Create(Self, FDriverObj);
{$IFDEF AnyDAC_MONITOR}
    FMonitor := AConnHost.FMonitor;
    if FMonitor <> nil then begin
      FTracing := AConnHost.FInitialTracing;
      TracingChanged;
    end;
    if GetTracing then
      FMonitor.Notify(ekLiveCycle, esProgress, Self, 'CreateConnection',
        ['ConnectionDef', AConnHost.ConnectionDef.Name]);
{$ENDIF}
    inherited Create;
    FState := csDisconnected;
    FPoolManaged := (AConnHost.FPool <> nil);
    FLoginPrompt := False;
    FDriverObj.FConnectionList.Add(Self);
    FConnHost := AConnHost;
    FConnHost.Employ;
    if FConnHost.FConnectionDef.Style <> atTemporary then begin
      ADCreateInterface(IADStanConnectionDef, FInternalConnectionDef);
      FInternalConnectionDef.ParentDefinition := FConnHost.ConnectionDef;
    end;
    FLock := TCriticalSection.Create;
    FCommandList := TADPtrList.Create;
    FTransactionList := TADPtrList.Create;
    FEventList := TADPtrList.Create;
    SetOptions(nil);
    GetConnectionDef.ReadOptions(FOptions.FormatOptions, FOptions.UpdateOptions,
      FOptions.FetchOptions, FOptions.ResourceOptions);
    CheckTransaction;
  finally
    FDriverObj.FLock.Leave;
  end;
end;

{ ----------------------------------------------------------------------------- }
destructor TADPhysConnection.Destroy;
begin
  ADHighRefCounter(FRefCount);
  FDriverObj.FLock.Enter;
  try
{$IFDEF AnyDAC_MONITOR}
    if GetTracing then
      FMonitor.Notify(ekLiveCycle, esProgress, Self, 'DestroyConnection',
        ['ConnectionDef', GetConnectionDef.Name]);
{$ENDIF}
    try
      if FCommandList <> nil then
        ForceDisconnect;
      FDriverObj.FConnectionList.Remove(Self);
      FTransactionObj := nil;
      FTransaction := nil;
      SetErrorHandler(nil);
      SetLogin(nil);
      ADFreeAndNil(FMetadata);
      ADFreeAndNil(FCommandList);
      ADFreeAndNil(FTransactionList);
      ADFreeAndNil(FEventList);
      FOptions := nil;
      ADFreeAndNil(FLock);
      inherited Destroy;
    finally
      ADFree(FMoniAdapterHelper);
      FMoniAdapterHelper := nil;
{$IFDEF AnyDAC_MONITOR}
      SetTracing(False);
      FMonitor := nil;
{$ENDIF}
    end;
  finally
    FDriverObj.FLock.Leave;
    if FConnHost <> nil then
      FConnHost.Vacate;
    FConnHost := nil;
    FInternalConnectionDef := nil;
    FDriverObj := nil;
    FDriver := nil;
    FRefCount := 0;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.Lock;
begin
  FLock.Enter;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.Unlock;
begin
  FLock.Leave;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection._AddRef: Integer;
begin
  Result := inherited _AddRef;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection._Release: Integer;

  procedure ReleaseToPool;
  var
    oPoolItem: IADStanObject;
  begin
    Lock;
    try
      if not FPoolManaged then begin
        Supports(TObject(Self), IADStanObject, oPoolItem);
        FConnHost.FPool.Release(oPoolItem);
        ADInterlockedDecrement(FRefCount);
        Pointer(oPoolItem) := nil;
      end;
    finally
      UnLock;
    end;
  end;

begin
  Result := ADInterlockedDecrement(FRefCount);
  if Result <= 1 then
    if (Result = 1) and (FConnHost <> nil) and (FConnHost.FPool <> nil) then
      ReleaseToPool
    else if Result = 0 then
      ADFree(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetState: TADPhysConnectionState;
begin
  Result := FState;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetDriverID: String;
begin
  if FDriverObj <> nil then
    Result := FDriverObj.FDriverID
  else
    Result := '';
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
// Tracing

procedure TADPhysConnection.Trace(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; const AMsg: String; const AArgs: array of const);
begin
  if GetTracing then
    FMonitor.Notify(AKind, AStep, Self, AMsg, AArgs);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetTracing: Boolean;
begin
  Result := FTracing and (FMonitor <> nil) and FMonitor.Tracing;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.SetTracing(AValue: Boolean);
var
  lPrevTracing: Boolean;
begin
  lPrevTracing := GetTracing;
  if AValue <> FTracing then begin
    FTracing := AValue;
    if lPrevTracing <> GetTracing then
      TracingChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.TracingChanged;
begin
  InternalTracingChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.InternalTracingChanged;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetMonitor: IADMoniClient;
begin
  Result := FMonitor;
end;
{$ENDIF}

{ ----------------------------------------------------------------------------- }
// Get interfaces

function TADPhysConnection.GetDriver: IADPhysDriver;
begin
  Result := FDriver;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.CreateCommandGenerator(out AGen: IADPhysCommandGenerator;
  const ACommand: IADPhysCommand);
begin
  AGen := InternalCreateCommandGenerator(ACommand) as IADPhysCommandGenerator;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.CreateMetadata(out AConnMeta: IADPhysConnectionMetadata);
begin
  if FMetadata = nil then
    FMetadata := InternalCreateMetadata;
  Supports(FMetadata, IADPhysConnectionMetadata, AConnMeta);
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetCliObj: Pointer;
begin
  Result := nil;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.InternalGetCliHandle: Pointer;
begin
  Result := nil;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetCliHandle: Pointer;
begin
  FCliHandles.FDriverCliHandles := InternalGetCliHandle;
  if (GetTransaction <> nil) and GetTransaction.Active then
    FCliHandles.FTxSerialID := TADNativeUInt(GetTransaction.SerialID)
  else
    FCliHandles.FTxSerialID := 0;
  StrCopy(@FCliHandles.FDriverID, PChar(GetDriverID));
  Result := @FCliHandles;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.InternalGetSharedCliHandle: Pointer;
begin
  if FSharedHandle <> nil then
    Result := FSharedHandle^.FDriverCliHandles
  else
    Result := nil;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetSharedCliHandle: Pointer;
begin
  Result := FSharedHandle;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.SetSharedCliHandle(AValue: Pointer);
begin
  CheckInactive;
  FSharedHandle := PADPhysCliHandles(AValue);
end;

{ ----------------------------------------------------------------------------- }
// Options interface

procedure TADPhysConnection.GetParentOptions(out AOpts: IADStanOptions);
begin
  AOpts := FDriverObj.FManager.GetOptions;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetOptions: IADStanOptions;
begin
  Result := Self as IADStanOptions;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.SetOptions(const AValue: IADStanOptions);
begin
  if (FOptions <> AValue) or (FMetadata = nil) then begin
    FOptions := AValue;
    if FOptions = nil then
      FOptions := TADOptionsContainer.Create(nil, TADFetchOptions,
        TADUpdateOptions, TADTopResourceOptions, GetParentOptions);
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetConnectionDef: IADStanConnectionDef;
begin
  if FInternalConnectionDef <> nil then
    Result := FInternalConnectionDef
  else
    Result := FConnHost.ConnectionDef;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetMessages: EADDBEngineException;
begin
  Result := nil;
end;

{ ----------------------------------------------------------------------------- }
// Transactions

function GetTxObj(const AIntf: IADPhysTransaction): TADPhysTransaction;
var
  oIntf: IADPhysTransaction2Obj;
begin
  Supports(AIntf, IADPhysTransaction2Obj, oIntf);
  ASSERT((oIntf <> nil) and (oIntf.Obj <> nil));
  Result := oIntf.Obj;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetTransactionCount: Integer;
begin
  Result := FTransactionList.Count;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetTransactions(AIndex: Integer): IADPhysTransaction;
begin
  Lock;
  try
    Result := TADPhysTransaction(FTransactionList[AIndex]) as IADPhysTransaction;
  finally
    Unlock;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.CreateTransaction(out ATx: IADPhysTransaction);

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekLiveCycle, esProgress, 'CreateTransaction', ['ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}

var
  oTxObj: TADPhysTransaction;
  oConnMeta: IADPhysConnectionMetadata;
  lCreate: Boolean;
begin
{$IFDEF AnyDAC_MONITOR}
  if GetTracing then Trace1;
{$ENDIF}
  lCreate := FTransactionList.Count = 0;
  if not lCreate then begin
    CreateMetadata(oConnMeta);
    lCreate := oConnMeta.TxMultiple;
  end;
  if lCreate then begin
    oTxObj := InternalCreateTransaction;
    if GetState = csConnected then
      oTxObj.InternalAllocHandle;
  end
  else
    oTxObj := TADPhysTransaction(FTransactionList[0]);
  ATx := oTxObj as IADPhysTransaction;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetTransaction: IADPhysTransaction;
begin
  Result := FTransaction;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.SetTransaction(const AValue: IADPhysTransaction);
var
  oTxObj: TADPhysTransaction;
begin
  if AValue <> FTransaction then begin
    if FTransactionObj <> nil then begin
      if GetState in [csConnecting, csConnected] then
        FTransactionObj.InternalUnselect;
      FTransactionObj.FConnection := FTransactionObj.FConnectionObj as IADPhysConnection;
    end;
    FTransaction := nil;
    FTransactionObj := nil;
    if AValue <> nil then begin
      oTxObj := GetTxObj(AValue);
      if oTxObj.FConnectionObj <> Self then
        ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccCantAssignTxIntf, []);
      FTransaction := AValue;
      FTransactionObj := oTxObj;
      if GetState in [csConnecting, csConnected] then
        FTransactionObj.InternalSelect;
      FTransactionObj.FConnection := nil;
    end;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.CheckTransaction;
var
  oTx: IADPhysTransaction;
begin
  if FTransaction = nil then begin
    CreateTransaction(oTx);
    SetTransaction(oTx);
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.AllocTransactionHandles;
var
  i: Integer;
  oTran: TADPhysTransaction;
begin
  if (FTransactionList.Count > 0) and
     (GetSharedCliHandle() <> nil) and (FSharedHandle^.FTxSerialID > 0) then begin
    oTran := TADPhysTransaction(FTransactionList[0]);
    oTran.FSerialID := FSharedHandle^.FTxSerialID;
    FSharedHandle^.FTxSerialID := 0;
    oTran.FSharedActive := True;
    oTran.TransactionStarted;
  end;
  for i := 0 to FTransactionList.Count - 1 do
    TADPhysTransaction(FTransactionList[i]).InternalAllocHandle;
  if (GetState in [csConnecting, csConnected]) and (FTransactionObj <> nil) then
    FTransactionObj.InternalSelect;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.ReleaseTransactionHandles;
var
  i: Integer;
begin
  if (GetState in [csConnecting, csConnected]) and (FTransactionObj <> nil) then
    FTransactionObj.InternalUnSelect;
  for i := 0 to FTransactionList.Count - 1 do
    TADPhysTransaction(FTransactionList[i]).ReleaseHandleBase;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.DisconnectTransactions;
var
  i: Integer;
begin
  for i := 0 to FTransactionList.Count - 1 do
    TADPhysTransaction(FTransactionList[i]).Disconnect;
end;

{ ----------------------------------------------------------------------------- }
// Events

function TADPhysConnection.GetEventCount: Integer;
begin
  Result := FEventList.Count;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetEvents(AIndex: Integer): IADPhysEventAlerter;
begin
  Lock;
  try
    Result := TADPhysEventAlerter(FEventList[AIndex]) as IADPhysEventAlerter;
  finally
    Unlock;
  end;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.InternalCreateEvent(const AEventKind: String): TADPhysEventAlerter;
begin
  Result := nil;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.CreateEvent(const AEventKind: String; out AEvent: IADPhysEventAlerter);

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekLiveCycle, esProgress, 'CreateEvent', ['EventKind', AEventKind,
      'ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}

var
  oEventObj: TADPhysEventAlerter;
  oMeta: IADPhysConnectionMetadata;
  sEvent: String;
  i: Integer;
begin
{$IFDEF AnyDAC_MONITOR}
  if GetTracing then Trace1;
{$ENDIF}
  CreateMetadata(oMeta);
  if not oMeta.EventSupported then
    ADCapabilityNotSupported(Self, [S_AD_LPhys, DriverID]);
  if AEventKind <> '' then
    sEvent := AEventKind
  else begin
    i := 1;
    sEvent := ADExtractFieldName(oMeta.EventKinds, i);
  end;
  oEventObj := InternalCreateEvent(sEvent);
  if oEventObj = nil then
    ADCapabilityNotSupported(Self, [S_AD_LPhys, DriverID]);
  AEvent := oEventObj as IADPhysEventAlerter;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.DisconnectEvents;
var
  i: Integer;
begin
  for i := 0 to FEventList.Count - 1 do
    TADPhysEventAlerter(FEventList[i]).Unregister;
end;

{ ----------------------------------------------------------------------------- }
// Commands

function TADPhysConnection.GetCommandCount: Integer;
begin
  Result := FCommandList.Count;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetCommands(AIndex: Integer): IADPhysCommand;
begin
  Lock;
  try
    Result := TADPhysCommand(FCommandList[AIndex]) as IADPhysCommand;
  finally
    UnLock;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.CreateCommand(out ACmd: IADPhysCommand);

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekLiveCycle, esProgress, 'CreateCommand', ['ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}

begin
{$IFDEF AnyDAC_MONITOR}
  if GetTracing then Trace1;
{$ENDIF}
  ACmd := InternalCreateCommand as IADPhysCommand;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.InternalCreateMetaInfoCommand: TADPhysCommand;
begin
  Result := InternalCreateCommand;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.CreateMetaInfoCommand(out AMetaCmd: IADPhysMetaInfoCommand);

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekLiveCycle, esProgress, 'CreateMetaInfoCommand', ['ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}

begin
{$IFDEF AnyDAC_MONITOR}
  if GetTracing then Trace1;
{$ENDIF}
  AMetaCmd := InternalCreateMetaInfoCommand as IADPhysMetaInfoCommand;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.InternalOverrideNameByCommand(
  var AParsedName: TADPhysParsedName; const ACommand: IADPhysCommand);
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  CreateMetadata(oConnMeta);
  if (AParsedName.FCatalog = '') and (npCatalog in oConnMeta.NameParts) and
     not (npCatalog in FAvoidImplicitMeta) then
    AParsedName.FCatalog := GetCurrentCatalog;
  if (AParsedName.FSchema = '') and (npSchema in oConnMeta.NameParts) and
     not (npSchema in FAvoidImplicitMeta) then
    AParsedName.FSchema := GetCurrentSchema;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.DisconnectCommands;
var
  i: Integer;
  oCmd: TADPhysCommand;
begin
  for i := FCommandList.Count - 1 downto 0 do begin
    oCmd := TADPhysCommand(FCommandList[i]);
    if GetState = csRecovering then
      oCmd.AbortJob(True);
    oCmd.Disconnect;
  end;
end;

{ ----------------------------------------------------------------------------- }
// Exception handling

function TADPhysConnection.GetErrorHandler: IADStanErrorHandler;
begin
  Result := FErrorHandler;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.SetErrorHandler(const AValue: IADStanErrorHandler);
begin
  FErrorHandler := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
begin
{$IFDEF AnyDAC_MONITOR}
  if not (AException is EADDBEngineException) and GetTracing then
    Trace(ekError, esProgress, AException.Message, []);
{$ENDIF}
  if Assigned(GetErrorHandler()) then
    GetErrorHandler().HandleException(AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
// Connection management

procedure TADPhysConnection.CheckActive(ADisconnectingAllowed: Boolean = False);
begin
  if not ADisconnectingAllowed and not (FState in [csConnected, csRecovering]) or
         ADisconnectingAllowed and not (FState in [csConnected, csDisconnecting, csRecovering]) then
    ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccSrvMBConnected, []);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.CheckInactive;
begin
  if FState <> csDisconnected then
    ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccSrvMBDisConnected, []);
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetLogin: IADGUIxLoginDialog;
begin
  Result := FLogin;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.SetLogin(const AValue: IADGUIxLoginDialog);
begin
  if FLogin <> nil then
    FLogin.ConnectionDef := nil;
  FLogin := AValue;
  if FLogin <> nil then
    FLogin.ConnectionDef := GetConnectionDef;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysConnection.GetLoginPrompt: Boolean;
begin
  Result := FLoginPrompt;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.SetLoginPrompt(const AValue: Boolean);
begin
  FLoginPrompt := AValue;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.BeforeReuse;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekLiveCycle, esProgress, 'BeforeReuse', ['ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}

begin
{$IFDEF AnyDAC_MONITOR}
  if GetTracing then Trace1;
{$ENDIF}
  FPoolManaged := False;
  // The connecting / pinging moved out of here to Open. This enables
  // automatic connection recovery for pooled connections. Because at this
  // moment TADConnection recovery handler and options are not yet set.
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.AfterReuse;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekLiveCycle, esProgress, 'AfterReuse', ['ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}

var
  i: Integer;
begin
{$IFDEF AnyDAC_MONITOR}
  if GetTracing then Trace1;
{$ENDIF}
  FPoolManaged := True;
  DisconnectCommands;
  DisconnectEvents;
  DisconnectTransactions;
  for i := 0 to FTransactionList.Count - 1 do
    TADPhysTransaction(FTransactionList[i]).SetOptions(nil);
  SetOptions(nil);
  SetErrorHandler(nil);
  SetOwner(nil, '');
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.ForceDisconnect;
var
  i: Integer;
  oCmd: TADPhysCommand;
begin
  Lock;
  try
    for i := FCommandList.Count - 1 downto 0 do
      try
        oCmd := TADPhysCommand(FCommandList[i]);
        if oCmd.GetState in [csExecuting, csFetching] then
          oCmd.AbortJob(True);
        oCmd.Disconnect;
      except
        // hide exceptions
      end;
    if GetState = csConnected then
      Close;
  finally
    UnLock;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.ConnectBase;
begin
  FDriver.Employ;
  try
    InternalConnect;
    try
      AllocTransactionHandles;
      InternalSetMeta;
    except
      ReleaseTransactionHandles;
      raise;
    end;
  except
    try
      InternalDisconnect;
    finally
      FDriver.Vacate;
    end;
    raise;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.DoConnect;
var
  lConnected: Boolean;
begin
  lConnected := False;
  repeat
    try
      ConnectBase;
      lConnected := True;
    except
      on E: EADDBEngineException do
        if E.Kind = ekServerGone then
          RecoverConnection(Self, True)
        else
          raise;
    end;
  until lConnected;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.DoLogin;
  procedure LoginAborted;
  var
    s: String;
  begin
    s := GetConnectionDef.Name;
    if s = '' then
      s := S_AD_Unnamed;
    ADException(Self, [S_AD_LPhys, DriverID], er_AD_ClntDbLoginAborted, [s]);
  end;
var
  oDlg: IADGUIxLoginDialog;
begin
  if not Assigned(FLogin) then begin
    ADCreateInterface(IADGUIxLoginDialog, oDlg, False);
    if oDlg = nil then begin
      DoConnect;
      Exit;
    end;
    oDlg.ConnectionDef := GetConnectionDef;
  end
  else
    oDlg := FLogin;
  try
    if not oDlg.Execute(DoConnect) then
      LoginAborted;
  finally
    if not Assigned(FLogin) then
      oDlg.ConnectionDef := nil;
  end;
end;

{ ----------------------------------------------------------------------------- }
{$IFDEF AnyDAC_MONITOR}
procedure TADPhysConnection.TraceList(AList: TStrings; const AName: String);
var
  i: Integer;
begin
  if AList.Count > 0 then begin
    Trace(ekConnConnect, esStart, AName, []);
    for i := 0 to AList.Count - 1 do
      Trace(ekConnConnect, esProgress, AList[i], []);
    Trace(ekConnConnect, esEnd, AName, []);
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.TraceConnInfo(AKind: TADMoniAdapterItemKind;
  const AName: String);
var
  i: Integer;
  sName: String;
  vVal: Variant;
  eKind: TADMoniAdapterItemKind;
  oList: TADStringList;
begin
  oList := TADStringList.Create;
  try
    FTracing := False;
    try
      for i := 0 to GetItemCount - 1 do begin
        sName := '';
        vVal := Unassigned;
        eKind := ikStat;
        GetItem(i, sName, vVal, eKind);
        if eKind = AKind then
          oList.Add(sName + '=' + VarToStr(vVal));
      end;
    finally
      FTracing := True;
    end;
    TraceList(oList, AName);
  finally
    ADFree(oList);
  end;
end;
{$ENDIF}

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.InternalSetMeta;
var
  oConnDef: IADStanConnectionDef;

  procedure SetParam(var AParam: String; const AName: String;
    var AFlags: TADPhysNameParts; AFlag: TADPhysNamePart);
  begin
    if oConnDef.HasValue(AName) then
      AParam := oConnDef.AsString[AName];
    if AParam = '*' then begin
      Include(AFlags, AFlag);
      AParam := '';
    end;
  end;

begin
  oConnDef := GetConnectionDef;
  // get user specified default schema and catalog names
  SetParam(FDefaultCatalog, S_AD_ConnParam_Common_MetaDefCatalog, FRemoveDefaultMeta, npCatalog);
  SetParam(FDefaultSchema, S_AD_ConnParam_Common_MetaDefSchema, FRemoveDefaultMeta, npSchema);
  // get user specified current schema and catalog names
  SetParam(FCurrentCatalog, S_AD_ConnParam_Common_MetaCurCatalog, FAvoidImplicitMeta, npCatalog);
  SetParam(FCurrentSchema, S_AD_ConnParam_Common_MetaCurSchema, FAvoidImplicitMeta, npSchema);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.Open;
var
  oConnDef: IADStanConnectionDef;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    if not FMoniAdapterHelper.IsRegistered then
      FMoniAdapterHelper.RegisterClient(GetMonitor);
    Trace(ekConnConnect, esStart, 'Open', ['ConnectionDef', oConnDef.Name]);
    oConnDef.Trace(FMonitor);
    TraceConnInfo(ikAnyDACInfo, C_AD_Product + ' info');
  end;

  procedure Trace2;
  begin
    if FDriver.Messages <> nil then
      TraceList(FDriver.Messages, 'Driver log');
    TraceConnInfo(ikClientInfo, 'Client info');
    if FState = csConnected then begin
      UpdateMonitor;
      TraceConnInfo(ikSessionInfo, 'Session info');
    end;
    Trace(ekConnConnect, esEnd, 'Open', ['ConnectionDef', oConnDef.Name]);
  end;
{$ENDIF}

begin
  oConnDef := GetConnectionDef;
  if oConnDef.Pooled and (GetState = csConnected) then begin
    if (GetOptions.ResourceOptions as TADTopResourceOptions).AutoReconnect then
      Ping;
    Exit;
  end;
{$IFDEF AnyDAC_MONITOR}
  if GetTracing then Trace1;
  try
{$ENDIF}
    Lock;
    try
      CheckInactive;
      FState := csConnecting;
      FDefaultCatalog := '';
      FDefaultSchema := '';
      FCurrentCatalog := '';
      FCurrentSchema := '';
      FRemoveDefaultMeta := [];
      FAvoidImplicitMeta := [];
      try
{$IFDEF AnyDAC_MONITOR}
        SetTracing((oConnDef.MonitorBy <> '') and FConnHost.FInitialTracing);
{$ENDIF}
        if GetLoginPrompt and not oConnDef.Pooled and not ADGUIxSilent() and
           (GetSharedCliHandle() = nil) then
          DoLogin
        else
          DoConnect;
        // following is required to "refresh" metadata after connecting server
        ADFreeAndNil(FMetadata);
        FState := csConnected;
      except
        FState := csDisconnected;
        raise;
      end;
    finally
      UnLock;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if GetTracing then Trace2;
  end;
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.Close;
var
  oConnDef: IADStanConnectionDef;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekConnConnect, esStart, 'Close', ['ConnectionDef', oConnDef.Name]);
  end;

  procedure Trace2;
  begin
    Trace(ekConnConnect, esEnd, 'Close', ['ConnectionDef', oConnDef.Name]);
  end;
{$ENDIF}

begin
  oConnDef := GetConnectionDef;
{$IFDEF AnyDAC_MONITOR}
  if GetTracing then Trace1;
  try
{$ENDIF}
    Lock;
    try
      CheckActive;
      // If the state will be csDisconnecting, but the connection is broken
      // and there were active transactions, then DisconnectTransactions will
      // rollback them. That will lead to errors. So, leave csRecovering -
      // means the connection is broken.
      if FState <> csRecovering then
        FState := csDisconnecting;
      DisconnectCommands;
      DisconnectEvents;
      DisconnectTransactions;
      ReleaseTransactionHandles;
      InternalDisconnect;
      // TADPhysCommand.DoDefineDataTable, etc keep a reference to a metadata.
      // If connection is failed and closed then AV will be raised at exiting
      // from DoDefineDataTable, etc, because metadata reference is invalid.
      // ADFreeAndNil(FMetadata);
    finally
      FDriver.Vacate;
      FState := csDisconnected;
      UnLock;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if GetTracing then Trace2;
  end;
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.ChangePassword(const ANewPassword: String);
begin
  FDriver.Employ;
  try
    InternalChangePassword(GetConnectionDef.UserName, GetConnectionDef.Password,
      ANewPassword);
  finally
    FDriver.Vacate;
  end;
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.InternalChangePassword(const AUserName,
  AOldPassword, ANewPassword: String);
begin
  ADCapabilityNotSupported(Self, [S_AD_LPhys, DriverID]);
end;

{ ----------------------------------------------------------------------------- }
procedure TADPhysConnection.DecPrepared;
begin
  Lock;
  Dec(FPreparedCommands);
  UnLock;
end;

{ ----------------------------------------------------------------------------- }
function SortOnUsage(Item1, Item2: Pointer): Integer;
var
  oCmdObj1, oCmdObj2: TADPhysCommand;
begin
  oCmdObj1 := TADPhysCommand(Item1);
  oCmdObj2 := TADPhysCommand(Item2);
  if oCmdObj1.FExecuteCount > oCmdObj2.FExecuteCount then
    Result := -1
  else if oCmdObj1.FExecuteCount < oCmdObj2.FExecuteCount then
    Result := 1
  else
    Result := 0;
end;

{$IFDEF AUTOREFCOUNT}
type
  TADPhysCommandComparer = class(TInterfacedObject, IComparer<Pointer>)
    function Compare(const Left, Right: Pointer): Integer;
  end;

function TADPhysCommandComparer.Compare(const Left, Right: Pointer): Integer;
begin
  Result := SortOnUsage(Left, Right);
end;
{$ENDIF}

procedure TADPhysConnection.IncPrepared(ACommand: TADPhysCommand);
var
  j, i, n: Integer;
  oCmdObj: TADPhysCommand;
  oResOpts: TADTopResourceOptions;
begin
  Lock;
  try
    oResOpts := FOptions.ResourceOptions as TADTopResourceOptions;
    if (oResOpts.MaxCursors > 0) and
       (FPreparedCommands + 1 > oResOpts.MaxCursors) then begin
      FCommandList.Sort({$IFDEF AUTOREFCOUNT} TADPhysCommandComparer.Create {$ELSE} SortOnUsage {$ENDIF});
      n := (oResOpts.MaxCursors * C_AD_CrsPctClose) div 100;
      i := 0;
      for j := FCommandList.Count - 1 downto 0 do begin
        oCmdObj := TADPhysCommand(FCommandList[j]);
        if oCmdObj <> ACommand then begin
          oCmdObj.Disconnect;
          Inc(i);
          if i >= n then
            Break;
        end;
      end;
    end;
    Inc(FPreparedCommands);
  finally
    UnLock;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetLastAutoGenValue(const AName: String = ''): Variant;
var
  oCmd: IADPhysCommand;
  oGen: IADPhysCommandGenerator;
  oTab: TADDatSTable;
  oFtch: TADFetchOptions;
  oRes: TADResourceOptions;
begin
  if not VarIsNull(FLastAutoGenValue) and not VarIsEmpty(FLastAutoGenValue) then begin
    Result := FLastAutoGenValue;
    Exit;
  end;
  CreateCommand(oCmd);
  CreateCommandGenerator(oGen, nil);

  oFtch := oCmd.Options.FetchOptions;
  oFtch.RowsetSize := 1;
  oFtch.Items := oFtch.Items - [fiMeta];
  oFtch.RecordCountMode := cmVisible;
  oFtch.Mode := fmOnDemand;
  oFtch.AutoFetchAll := afAll;

  oRes := oCmd.Options.ResourceOptions;
  if oRes.CmdExecMode = amAsync then
    oRes.CmdExecMode := amBlocking;
  oRes.DirectExecute := True;
  oRes.Persistent := False;

  oCmd.CommandText := oGen.GenerateReadGenerator(AName, '', False, True);
  oCmd.CommandKind := oGen.CommandKind;

  oTab := TADDatSTable.Create;
  try
    oCmd.Define(oTab);
    oCmd.Open;
    oCmd.Fetch(oTab);
    if oTab.Rows.Count > 0 then
      Result := oTab.Rows[0].GetData(0)
    else
      Result := Null;
  finally
    ADFree(oTab);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.SaveLastAutoGenValue(const AValue: Variant);
begin
  FLastAutoGenValue := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.Clone: IADPhysConnection;
begin
  FDriverObj.FManager.CreateConnection(GetConnectionDef, Result);
  Result.Options := GetOptions;
  Result.ErrorHandler := GetErrorHandler;
  Result.RecoveryHandler := GetRecoveryHandler;
  Result.CurrentCatalog := GetCurrentCatalog;
  Result.CurrentSchema := GetCurrentSchema;
  if GetSharedCliHandle <> nil then begin
    if Result.State in [csConnected, csRecovering] then
      Result.Close;
    Result.SharedCliHandle := GetSharedCliHandle;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.InternalAnalyzeSession(AMessages: TStrings);
var
  oConnMeta: IADPhysConnectionMetadata;
  iVer: TADVersion;
begin
  CreateMetadata(oConnMeta);

  // 1. Diff between clnt and srv versions must be <= 1 major version
  iVer := oConnMeta.ServerVersion div 100000000 - oConnMeta.ClientVersion div 100000000;
  if iVer < 0 then
    iVer := -iVer;
  if iVer > 1 then
    AMessages.Add(Format('Warning: The client [%s] and server [%s] major versions difference > 1.',
      [ADVerInt2Str(oConnMeta.ClientVersion), ADVerInt2Str(oConnMeta.ServerVersion)]));
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.AnalyzeSession(AMessages: TStrings);
begin
  CheckActive(False);
  AMessages.BeginUpdate;
  try
    AMessages.Clear;
    InternalAnalyzeSession(AMessages);
  finally
    AMessages.EndUpdate;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.InternalGetCurrentCatalog: String;
begin
  Result := GetConnectionDef.ExpandedDatabase;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetCurrentCatalog: String;
var
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
begin
  CreateMetadata(oConnMeta);
  if npCatalog in oConnMeta.NameParts then begin
    if FCurrentCatalog <> '' then
      rName.FCatalog := FCurrentCatalog
    else
      rName.FCatalog := InternalGetCurrentCatalog;
    Result := oConnMeta.EncodeObjName(rName, nil, [eoNormalize]);
  end
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.SetCurrentCatalog(const AValue: String);
begin
  FCurrentCatalog := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.InternalGetCurrentSchema: String;
begin
  Result := GetConnectionDef.AsString[S_AD_ConnParam_Common_UserName];
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetCurrentSchema: String;
var
  oConnMeta: IADPhysConnectionMetadata;
  rName: TADPhysParsedName;
begin
  CreateMetadata(oConnMeta);
  if npSchema in oConnMeta.NameParts then begin
    if FCurrentSchema <> '' then
      rName.FSchema := FCurrentSchema
    else
      rName.FSchema := InternalGetCurrentSchema;
    Result := oConnMeta.EncodeObjName(rName, nil, [eoNormalize]);
  end
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.SetCurrentSchema(const AValue: String);
begin
  FCurrentSchema := AValue;
end;

{-------------------------------------------------------------------------------}
// Connection recovery

function TADPhysConnection.GetRecoveryHandler: IADPhysConnectionRecoveryHandler;
begin
  Result := FRecoveryHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.SetRecoveryHandler(const AValue: IADPhysConnectionRecoveryHandler);
begin
  FRecoveryHandler := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.RecoverConnection(const AInitiator: IADStanObject; AOnLogin: Boolean);
var
  oExc: Exception;
  eAction: TADPhysConnectionRecoverAction;
  lDone, lAutoRetry, lRaised: Boolean;
  i, iTrials: Integer;
  oCmdList: TADObjList;
  oEvtList: TADObjList;
  oPrevMeta: TObject;
{$IFDEF AnyDAC_MONITOR}
  sDefName: String;
{$ENDIF}

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekConnConnect, esStart, 'RecoverConnection', ['ConnectionDef', sDefName]);
  end;

  procedure Trace2;
  begin
    Trace(ekConnConnect, esEnd, 'RecoverConnection', ['ConnectionDef', sDefName]);
  end;

  procedure Trace3;
  begin
    Trace(ekConnConnect, esProgress, 'HandleConnectionRecover', ['ConnectionDef', sDefName]);
  end;

  procedure Trace4;
  begin
    Trace(ekConnConnect, esProgress, 'HandleConnectionRestored', ['ConnectionDef', sDefName]);
  end;

  procedure Trace5;
  begin
    Trace(ekConnConnect, esProgress, 'HandleConnectionLosted', ['ConnectionDef', sDefName]);
  end;
{$ENDIF}

  procedure ConnectionRecover;
  begin
    if Assigned(GetRecoveryHandler()) then begin
{$IFDEF AnyDAC_MONITOR}
      if GetTracing then Trace3;
{$ENDIF}
      GetRecoveryHandler().HandleConnectionRecover(AInitiator, oExc, eAction);
    end;
  end;

  procedure ConnectionRestored;
  begin
    if Assigned(GetRecoveryHandler()) then begin
{$IFDEF AnyDAC_MONITOR}
      if GetTracing then Trace4;
{$ENDIF}
      GetRecoveryHandler().HandleConnectionRestored();
    end;
  end;

  procedure ConnectionLosted;
  begin
    if Assigned(GetRecoveryHandler()) then begin
{$IFDEF AnyDAC_MONITOR}
      if GetTracing then Trace4;
{$ENDIF}
      GetRecoveryHandler().HandleConnectionLosted();
    end;
  end;

begin
  oExc := ADAcquireExceptionObject();
  lRaised := False;
  try
    if (oExc is EADDBEngineException) and (EADDBEngineException(oExc).Kind = ekServerGone) and
       (AOnLogin or (GetState = csConnected)) then begin
{$IFDEF AnyDAC_MONITOR}
      sDefName := GetConnectionDef.Name;
      if GetTracing then Trace1;
      try
{$ENDIF}
        Lock;
        try
          lDone := False;
          lAutoRetry := False;
          iTrials := 1;
          eAction := faDefault;
          if Assigned(GetRecoveryHandler()) then begin
            if not AOnLogin then
              FState := csRecovering;
            try
              ConnectionRecover;
            finally
              if not AOnLogin and (FState = csRecovering) then
                FState := csConnected;
            end;
          end;
          oCmdList := TADObjList.Create;
          oEvtList := TADObjList.Create;
          if not AOnLogin then begin
            // TADPhysCommand.DoDefineDataTable, etc keep a reference to a metadata.
            // If connection is failed and restored then AV will be raised at exiting
            // from DoDefineDataTable, etc, because metadata reference is invalid.
            oPrevMeta := FMetadata;
            FMetadata := nil;
          end
          else
            oPrevMeta := nil;
          try
            for i := 0 to FCommandList.Count - 1 do
              if TADPhysCommand(FCommandList[i]).GetState <> csInactive then
                oCmdList.Add(FCommandList[i]);
            for i := 0 to FEventList.Count - 1 do
              if TADPhysEventAlerter(FEventList[i]).GetState <> esInactive then
                oEvtList.Add(FEventList[i]);
            // Prohibit to call state handlers, otherwise datasets will be disconnected.
            // But only Phys commands must be reprepared.
            FDontCallStateHandler := True;
            try
              ForceDisconnect;
            finally
              FDontCallStateHandler := False;
            end;
            if (eAction = faDefault) then
              if (FOptions.ResourceOptions as TADTopResourceOptions).AutoReconnect then begin
                eAction := faRetry;
                lAutoRetry := True;
              end
              else
                eAction := faFail;
            repeat
              case eAction of
              faFail:
                begin
                  ConnectionLosted;
                  lRaised := True;
                  raise oExc;
                end;
              faRetry:
                begin
                  // if first trial, do not wait, may be DBMS is already available
                  if lAutoRetry and (iTrials > 1) then
                    Sleep(C_AD_PhysConnRetryDelay);
                  FState := csConnecting;
                  try
                    ConnectBase;
                    FState := csConnected;
                    ConnectionRestored;
                    lDone := True;
                  except
                    on EADDBEngineException do begin
                      FState := csDisconnected;
                      ADFree(oExc);
                      oExc := ADAcquireExceptionObject();
                      if Assigned(GetRecoveryHandler()) then begin
                        if not AOnLogin then
                          FState := csRecovering;
                        try
                          ConnectionRecover;
                        finally
                          if not AOnLogin then
                            FState := csDisconnected;
                        end;
                      end;
                    end;
                  end;
                end;
              faCloseAbort,
              faOfflineAbort:
                begin
                  ConnectionLosted;
                  Abort;
                end;
              end;
              Inc(iTrials);
              if (eAction = faRetry) and lAutoRetry and (iTrials > C_AD_PhysConnRetryCount) then begin
                ConnectionLosted;
                lRaised := True;
                raise oExc;
              end;
            until lDone;
          finally
            if not AOnLogin then begin
              ADFreeAndNil(FMetadata);
              FMetadata := oPrevMeta;
            end;
            if GetState = csConnected then begin
              for i := 0 to oCmdList.Count - 1 do
                TADPhysCommand(oCmdList[i]).Prepare();
              for i := 0 to oEvtList.Count - 1 do
                TADPhysEventAlerter(oEvtList[i]).Register();
            end;
            ADFree(oCmdList);
            ADFree(oEvtList);
          end;
        finally
          UnLock;
        end;
{$IFDEF AnyDAC_MONITOR}
      finally
        if GetTracing then Trace2;
      end;
{$ENDIF}
    end
    else begin
      lRaised := True;
      raise oExc;
    end;
  finally
    if not lRaised then
      ADFree(oExc);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.Ping: Boolean;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekConnConnect, esStart, 'Ping', ['ConnectionDef', GetConnectionDef.Name]);
  end;

  procedure Trace2;
  begin
    Trace(ekConnConnect, esEnd, 'Ping', ['ConnectionDef', GetConnectionDef.Name]);
  end;
{$ENDIF}

begin
  Result := False;
  if GetState in [csDisconnecting, csConnecting, csRecovering] then
    Exit;
  _AddRef;
  try
{$IFDEF AnyDAC_MONITOR}
    if GetTracing then Trace1;
    try
{$ENDIF}
      case GetState of
      csConnected:
        try
          InternalPing;
          Result := True;
        except
          on E: EADDBEngineException do
            if E.Kind = ekServerGone then begin
              RecoverConnection(Self, False);
              Result := GetState = csConnected;
            end;
        end;
      csDisconnected:
        Open;
      end;
{$IFDEF AnyDAC_MONITOR}
    finally
      if GetTracing then Trace2;
    end;
{$ENDIF}
  finally
    _Release;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.InternalPing;
var
  oGen: IADPhysCommandGenerator;
  s: String;
begin
  CreateCommandGenerator(oGen, nil);
  s := oGen.GeneratePing;
  if s <> '' then
    InternalExecuteDirect(s, TransactionObj);
end;

{-------------------------------------------------------------------------------}
// IADStanObject

function TADPhysConnection.GetName: TComponentName;
begin
  if FMoniAdapterHelper <> nil then
    Result := FMoniAdapterHelper.Name
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetParent: IADStanObject;
begin
  if FMoniAdapterHelper <> nil then
    Result := FMoniAdapterHelper.Parent
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  FMoniAdapterHelper.SetOwner(AOwner, ARole);
{$IFDEF AnyDAC_MONITOR}
  FMoniAdapterHelper.UnRegisterClient;
  FMoniAdapterHelper.RegisterClient(GetMonitor);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
// IADMoniAdapter

function TADPhysConnection.GetHandle: LongWord;
begin
  if FMoniAdapterHelper = nil then
    Result := 0
  else
    Result := FMoniAdapterHelper.Handle;
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetSupportItems: TADMoniAdapterItemKinds;
begin
  Result := [ikStat, ikAnyDACInfo, ikClientInfo, ikSessionInfo];
end;

{-------------------------------------------------------------------------------}
function TADPhysConnection.GetItemCount: Integer;
begin
  Result := 6;
  if GetState <> csDisconnected then
    Inc(Result, 2);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysConnection.GetItem(AIndex: Integer; out AName: String;
  out AValue: Variant; out AKind: TADMoniAdapterItemKind);
var
  s: String;
  iLen: Integer;

  procedure Add(const AStr: String);
  begin
    if iLen + Length(AStr) + 1 > 50 then begin
      s := s + C_AD_EOL + '  ';
      iLen := 0;
    end;
    s := s + AStr + ';';
    Inc(iLen, Length(AStr) + 1);
  end;

begin
  case AIndex of
  0:
    begin
      AName := 'Commands';
      AValue := FCommandList.Count;
      AKind := ikStat;
    end;
  1:
    begin
      AName := 'Transactions';
      AValue := FTransactionList.Count;
      AKind := ikStat;
    end;
  2:
    begin
      AName := 'Tool';
      AValue := ADToolName {$IFDEF AnyDAC_ProSKU} + ' Professional' {$ENDIF}
                           {$IFDEF AnyDAC_EntSKU} + ' Enterprise' {$ENDIF}
                           {$IFDEF AnyDAC_ArchSKU} + ' Architect' {$ENDIF};
      AKind := ikAnyDACInfo;
    end;
  3:
    begin
      AName := C_AD_Product;
      AValue := C_AD_Version {$IFNDEF AnyDAC_Release} + ' (internal)' {$ENDIF};
      AKind := ikAnyDACInfo;
    end;
  4:
    begin
      AName := 'Platform';
      AValue :=
{$IFDEF MSWINDOWS}
        'Windows'
{$ELSE}
  {$IFDEF IOS}
    {$IFDEF CPUARM}
        'iOS Device'
    {$ELSE}
        'iOS Emulator'
    {$ENDIF}
  {$ELSE}
    {$IFDEF MACOS}
        'Mac OS X'
    {$ELSE}
        'Linux'
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
{$IFDEF AnyDAC_64}
      + ' 64 bit'
{$ENDIF}
{$IFDEF AnyDAC_32}
      + ' 32 bit'
{$ENDIF}
      ;
      AKind := ikAnyDACInfo;
    end;
  5:
    begin
      AName := 'Defines';
      s := '';
      iLen := 0;
{$IFDEF AnyDAC_Unicode}
      Add('AnyDAC_Unicode');
{$ENDIF}
{$IFDEF AnyDAC_DBX}
      Add('AnyDAC_DBX');
{$ENDIF}
{$IFDEF AnyDAC_NOLOCALE_DATA}
      Add('AnyDAC_NOLOCALE_DATA');
{$ENDIF}
{$IFDEF AnyDAC_NOLOCALE_META}
      Add('AnyDAC_NOLOCALE_META');
{$ENDIF}
{$IFDEF AnyDAC_MONITOR}
      Add('AnyDAC_MONITOR');
{$ENDIF}
{$IFDEF AnyDAC_DEBUG}
      Add('AnyDAC_DEBUG');
{$ENDIF}
{$IFDEF AnyDAC_SynEdit}
      Add('AnyDAC_SynEdit');
{$ENDIF}
{$IFDEF AnyDAC_MOBILE}
      Add('AnyDAC_MOBILE');
{$ENDIF}
      AValue := Copy(s, 1, Length(s) - 1);
      AKind := ikAnyDACInfo;
    end;
  6:
    begin
      AName := 'Current catalog';
      AValue := FCurrentCatalog;
      AKind := ikSessionInfo;
    end;
  7:
    begin
      AName := 'Current schema';
      AValue := FCurrentSchema;
      AKind := ikSessionInfo;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
procedure TADPhysConnection.UpdateMonitor;
begin
  if GetTracing then
    FMonitor.AdapterChanged(Self as IADMoniAdapter);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADPhysTransaction                                                            }
{-------------------------------------------------------------------------------}
constructor TADPhysTransaction.Create(AConnection: TADPhysConnection);
begin
  inherited Create;
  FState := tsInactive;
  FConnection := AConnection as IADPhysConnection;
  FConnectionObj := AConnection;
  FConnectionObj.Lock;
  FConnectionObj.FTransactionList.Add(Self);
  FConnectionObj.UnLock;
  FSavepoints := TADStringList.Create;
  SetOptions(nil);
  FMoniAdapterHelper := TADMoniAdapterHelper.Create(Self, AConnection);
  FCommandList := TADPtrList.Create;
  FStateHandlerList := TInterfaceList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADPhysTransaction.Destroy;
begin
  Disconnect;
  ADHighRefCounter(FRefCount);
  try
    if FConnectionObj.FTransactionObj = Self then
      FConnectionObj.SetTransaction(nil);
    FConnectionObj.Lock;
    FConnectionObj.FTransactionList.Remove(Self);
    FConnectionObj.UnLock;
    InternalReleaseHandle;
    ADFreeAndNil(FSavepoints);
    FExternalOptions := nil;
    ADFreeAndNil(FOptions);
    ADFree(FMoniAdapterHelper);
    FMoniAdapterHelper := nil;
    ADFreeAndNil(FCommandList);
    ADFreeAndNil(FStateHandlerList);
    inherited Destroy;
  finally
    FRefCount := 0;
    FConnectionObj := nil;
    FConnection := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.Disconnect;
begin
  if not (GetState in [tsCommiting, tsRollingback]) and
     (FConnectionObj.FState <> csRecovering) and
     not FSharedActive then
    case GetOptions.DisconnectAction of
    xdCommit:
      while GetActive do
        Commit;
    xdRollback:
      while GetActive do
        Rollback;
    end;
  TransactionFinished;
end;

{-------------------------------------------------------------------------------}
// Get/Set

function TADPhysTransaction.GetObj: TADPhysTransaction;
begin
  Result := Self;
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetActive: Boolean;
begin
  Result := FSavepoints.Count > 0;
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetOptions: TADTxOptions;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions
  else
    Result := FOptions;
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetSerialID: LongWord;
begin
  if FSavepoints.Count > 0 then
    Result := FSavepoints.Ints[FSavepoints.Count - 1]
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetTopSerialID: LongWord;
begin
  if FSavepoints.Count > 0 then
    Result := FSavepoints.Ints[0]
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetNestingLevel: LongWord;
begin
  Result := FSavepoints.Count;
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetConnection: IADPhysConnection;
begin
  Result := FConnectionObj as IADPhysConnection;
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetCliObj: Pointer;
begin
  // nothing
  Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.SetOptions(const AValue: TADTxOptions);
begin
  if (FExternalOptions <> AValue) or (FCommandList = nil) then begin
    FExternalOptions := AValue;
    if FExternalOptions = nil then
      FOptions := TADTxOptions.Create
    else
      ADFreeAndNil(FOptions);
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetState: TADPhysTransactionState;
begin
  Result := FState;
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetDriverID: String;
begin
  if FConnectionObj <> nil then
    Result := FConnectionObj.DriverID
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
// Commands management

procedure TADPhysTransaction.DisconnectCommands(AFilter: TADPhysDisconnectFilter;
  AMode: TADPhysDisconnectMode);
var
  i: Integer;
  oCmd: TADPhysCommand;
begin
  if not FConnectionObj.FDontCallStateHandler then
    for i := FStateHandlerList.Count - 1 downto 0 do
      IADPhysTransactionStateHandler(FStateHandlerList[i]).HandleDisconnectCommands(AFilter, AMode);
  for i := FCommandList.Count - 1 downto 0 do
    if i < FCommandList.Count then begin
      oCmd := TADPhysCommand(FCommandList[i]);
      if (oCmd.GetState <> csInactive) and (not Assigned(AFilter) or AFilter(oCmd.GetCliObj)) then begin
        if oCmd.GetState in [csExecuting, csFetching, csAborting] then
          oCmd.AbortJob(True);
        case AMode of
        dmOffline: oCmd.Disconnect;
        dmRelease: oCmd.CloseAll;
        end;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.Stop(ASuccess: Boolean);
begin
  if not (GetState in [tsCommiting, tsRollingback]) then
    while GetActive do
      try
        if xoFinishRetaining in GetOptions.StopOptions then
          if ASuccess then
            CommitRetaining
          else
            RollbackRetaining
        else
          if ASuccess then
            Commit
          else
            Rollback;
      except
        on E: EADDBEngineException do
          if ASuccess and (E.Kind <> ekServerGone) then
            ASuccess := False
          else
            raise;
      end;
  TransactionFinished;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.CheckStoping(AAllowUnprepare, AForce, ASuccess: Boolean;
  ACommandObj: TADPhysCommand);
var
  i: Integer;
  oCmd: TADPhysCommand;
  lStop: Boolean;
begin
  lStop := True;
  if not AForce then
    for i := FCommandList.Count - 1 downto 0 do begin
      oCmd := TADPhysCommand(FCommandList[i]);
      case oCmd.GetState of
      csInactive:
        ;
      csPrepared:
        if not AAllowUnprepare or
           (oCmd.GetOptions.FetchOptions.AutoFetchAll = afDisable) then begin
          lStop := False;
          Break;
        end;
      csExecuting,
      csOpen,
      csFetching,
      csAborting:
        if ASuccess or (oCmd <> ACommandObj) then begin
          lStop := False;
          Break;
        end;
      end;
    end;
  if lStop then
    Stop(ASuccess);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.InternalCheckState(ACommandObj: TADPhysCommand;
  ASuccess: Boolean);
begin
  if ASuccess then
    case ACommandObj.GetCommandKind of
    skStartTransaction: TransactionStarted;
    skCommit:           TransactionFinished;
    skRollback:         TransactionFinished;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.Notify(ANotification: TADPhysTxNotification;
  ACommandObj: TADPhysCommand);
begin
  if not (FState in [tsInactive, tsActive]) then
    Exit;
  // As result of InternalNotify, a transaction may be marked as finished,
  // then the associated commands belonging to components will be destroyed,
  // and Self may be destroyed (FRefCount = 0) earlier, then all processing
  // will be finished. So, temporary increment a reference.
  _AddRef;
  Inc(FNotifyCount);
  try
    InternalNotify(ANotification, ACommandObj);
  finally
    Dec(FNotifyCount);
    _Release;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.InternalNotify(ANotification: TADPhysTxNotification;
  ACommandObj: TADPhysCommand);
var
  oMeta: IADPhysConnectionMetadata;
begin
  if ANotification in [cpBeforeCmdPrepare, cpAfterCmdPrepareSuccess,
                       cpAfterCmdPrepareFailure, cpAfterCmdUnprepare] then
    Exit;
  FConnectionObj.CreateMetadata(oMeta);
  if oMeta.TxSupported then begin
    FConnectionObj.Lock;
    try
      if oMeta.TxAutoCommit then
        case ANotification of
        cpBeforeCmdExecute:
          if not GetActive then
            Update;
        cpAfterCmdExecuteSuccess,
        cpAfterCmdExecuteFailure:
          InternalCheckState(ACommandObj, ANotification = cpAfterCmdExecuteSuccess);
        end
      else
        case ANotification of
        cpBeforeCmdExecute:
          if not (ACommandObj.GetCommandKind in [skStartTransaction, skCommit, skRollback]) then
            if GetOptions.AutoStart and not GetActive then begin
              StartTransaction;
              FIDAutoCommit := GetSerialID;
            end;
        cpAfterCmdExecuteSuccess,
        cpAfterCmdExecuteFailure:
          if not (ACommandObj.GetCommandKind in [skStartTransaction, skCommit, skRollback]) then begin
            if GetOptions.AutoStop and GetActive and
               (not (xoIfAutoStarted in GetOptions.StopOptions) or
                (FIDAutoCommit <> 0) and (FIDAutoCommit = GetSerialID)) then
              CheckStoping(True, True, ANotification <> cpAfterCmdExecuteFailure,
                ACommandObj);
          end
          else
            InternalCheckState(ACommandObj, ANotification = cpAfterCmdExecuteSuccess);
        end;
    finally
      FConnectionObj.UnLock;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
// TX management

procedure TADPhysTransaction.TxOperation(AOperation: TADPhysTransactionState;
  ABefore: Boolean);
var
  i: Integer;
begin
  for i := FStateHandlerList.Count - 1 downto 0 do
    IADPhysTransactionStateHandler(FStateHandlerList[i]).
      HandleTxOperation(AOperation, ABefore);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.TransactionStarted;
begin
  FSavepoints.Clear;
  FIDAutoCommit := 0;
  Inc(FSerialID);
  FSavepoints.AddInt(IntToStr(FSerialID), FSerialID);
  FState := tsActive;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.TransactionFinished;
begin
  FSavepoints.Clear;
  FIDAutoCommit := 0;
  FState := tsInactive;
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.StartTransaction: LongWord;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    if not FMoniAdapterHelper.IsRegistered then
      FMoniAdapterHelper.RegisterClient(FConnectionObj.GetMonitor);
    FConnectionObj.Trace(ekConnTransact, esStart, 'StartTransaction',
      ['ConnectionDef', FConnectionObj.GetConnectionDef.Name]);
  end;

  procedure Trace2;
  begin
    UpdateMonitor;
    FConnectionObj.Trace(ekConnTransact, esEnd, 'StartTransaction',
      ['ConnectionDef', FConnectionObj.GetConnectionDef.Name]);
  end;
{$ENDIF}

var
  s: String;
  oMeta: IADPhysConnectionMetadata;
  lExecuted: Boolean;
begin
  TxOperation(tsActive, True);
{$IFDEF AnyDAC_MONITOR}
  if FConnectionObj.GetTracing then Trace1;
  try
{$ENDIF}
    Result := 0;
    FConnectionObj.CheckActive;
    FConnectionObj.CreateMetadata(oMeta);
    if not oMeta.TxSupported then
      ADCapabilityNotSupported(Self, [S_AD_LPhys, DriverID]);
    FConnectionObj.Lock;
    if FSavepoints.Count = 0 then
      FState := tsStarting;
    try
      lExecuted := False;
      repeat
        try
          Result := FSerialID + 1;
          if (FSavepoints.Count > 0) and not GetOptions.EnableNested then
            ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccTxMBInActive, [ClassName]);
          if (FSavepoints.Count = 0) or oMeta.TxNested then begin
            Update;
            s := IntToStr(Result);
            InternalStartTransaction(Result);
          end
          else begin
            if not oMeta.TxSavepoints then
              ADCapabilityNotSupported(Self, [S_AD_LPhys, DriverID]);
            s := C_AD_SysSavepointPrefix + IntToStr(Result);
            InternalSetSavepoint(s);
          end;
          Inc(FSerialID);
          FSavepoints.AddInt(s, FSerialID);
          FState := tsActive;
          lExecuted := True;
          if (FNotifyCount = 0) and (FSavepoints.Count = 1) then
            FExplicitActive := True;
        except
          on E: EADDBEngineException do
            if E.Kind = ekServerGone then begin
              FConnectionObj.RecoverConnection(Self, False);
              TransactionFinished;
            end
            else
              raise;
        end;
      until lExecuted;
    finally
      // FConnectionObj is nil when connection recovery is aborted
      if FConnectionObj <> nil then begin
        if FSavepoints.Count = 0 then
          FState := tsInactive
        else
          FState := tsActive;
        FConnectionObj.UnLock;
      end;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if (FConnectionObj <> nil) and FConnectionObj.GetTracing then Trace2;
  end;
{$ENDIF}
  TxOperation(tsActive, False);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.InternalSetSavepoint(const AName: String);
var
  oGen: IADPhysCommandGenerator;
  s: String;
begin
  ConnectionObj.CreateCommandGenerator(oGen, nil);
  s := oGen.GenerateSavepoint(AName);
  if s <> '' then
    ConnectionObj.InternalExecuteDirect(s, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.InternalRollbackToSavepoint(const AName: String);
var
  oGen: IADPhysCommandGenerator;
  s: String;
begin
  ConnectionObj.CreateCommandGenerator(oGen, nil);
  s := oGen.GenerateRollbackToSavepoint(AName);
  if s <> '' then
    ConnectionObj.InternalExecuteDirect(s, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.InternalCommitSavepoint(const AName: String);
var
  oGen: IADPhysCommandGenerator;
  s: String;
begin
  ConnectionObj.CreateCommandGenerator(oGen, nil);
  s := oGen.GenerateCommitSavepoint(AName);
  if s <> '' then
    ConnectionObj.InternalExecuteDirect(s, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.Commit;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    FConnectionObj.Trace(ekConnTransact, esStart, 'Commit',
      ['ConnectionDef', FConnectionObj.GetConnectionDef.Name,
       'Retaining', FRetaining]);
  end;

  procedure Trace2;
  begin
    UpdateMonitor;
    FConnectionObj.Trace(ekConnTransact, esEnd, 'Commit',
      ['ConnectionDef', FConnectionObj.GetConnectionDef.Name,
       'Retaining', FRetaining]);
  end;
{$ENDIF}

var
  oMeta: IADPhysConnectionMetadata;
  s: String;
begin
  if not ((FState = tsActive) or not GetOptions.AutoStop) then
    Exit;
  TxOperation(tsCommiting, True);
{$IFDEF AnyDAC_MONITOR}
  if FConnectionObj.GetTracing then Trace1;
{$ENDIF}
  FConnectionObj.Lock;
  FState := tsCommiting;
  try
    FConnectionObj.CheckActive(True);
    FConnectionObj.CreateMetadata(oMeta);
    if not oMeta.TxSupported then
      ADCapabilityNotSupported(Self, [S_AD_LPhys, DriverID]);
    if not (GetActive or not GetOptions.AutoStop) then
      ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccTxMBActive, [ClassName]);
    try
      if (FSavepoints.Count <= 1) or
         (FSavepoints.Count > 1) and oMeta.TxNested then
        InternalCommit(GetSerialID)
      else begin
        s := FSavepoints[FSavepoints.Count - 1];
        InternalCommitSavepoint(s);
        if FRetaining then
          InternalSetSavepoint(s);
      end;
      if not FRetaining and (FSavepoints.Count > 0) then
        FSavepoints.Delete(FSavepoints.Count - 1);
    except
      on E: EADDBEngineException do
        if E.Kind = ekServerGone then begin
          FConnectionObj.RecoverConnection(Self, False);
          TransactionFinished;
        end
        else
          raise;
    end;
  finally
    // FConnectionObj is nil when connection recovery is aborted
    if FConnectionObj <> nil then begin
      if FSavepoints.Count = 0 then begin
        FState := tsInactive;
        FExplicitActive := False;
      end
      else
        FState := tsActive;
      FConnectionObj.UnLock;
{$IFDEF AnyDAC_MONITOR}
      if FConnectionObj.GetTracing then Trace2;
{$ENDIF}
    end;
  end;
  TxOperation(tsCommiting, False);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.CommitRetaining;
begin
  FRetaining := True;
  try
    Commit;
  finally
    FRetaining := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.Rollback;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    FConnectionObj.Trace(ekConnTransact, esStart, 'Rollback',
      ['ConnectionDef', FConnectionObj.GetConnectionDef.Name,
       'Retaining', FRetaining]);
  end;

  procedure Trace2;
  begin
    UpdateMonitor;
    FConnectionObj.Trace(ekConnTransact, esEnd, 'Rollback',
      ['ConnectionDef', FConnectionObj.GetConnectionDef.Name,
       'Retaining', FRetaining]);
  end;
{$ENDIF}

var
  oMeta: IADPhysConnectionMetadata;
  s: String;
begin
  if not ((FState = tsActive) or not GetOptions.AutoStop) then
    Exit;
  TxOperation(tsRollingback, True);
{$IFDEF AnyDAC_MONITOR}
  if FConnectionObj.GetTracing then Trace1;
{$ENDIF}
  FConnectionObj.Lock;
  FState := tsRollingback;
  try
    FConnectionObj.CheckActive(True);
    FConnectionObj.CreateMetadata(oMeta);
    if not oMeta.TxSupported then
      ADCapabilityNotSupported(Self, [S_AD_LPhys, DriverID]);
    if not (GetActive or not GetOptions.AutoStop) then
      ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccTxMBActive, []);
    try
      if (FSavepoints.Count <= 1) or
         (FSavepoints.Count > 1) and oMeta.TxNested then
        InternalRollback(GetSerialID)
      else begin
        s := FSavepoints[FSavepoints.Count - 1];
        InternalRollbackToSavepoint(s);
        if FRetaining then
          InternalSetSavepoint(s);
      end;
      if not FRetaining and (FSavepoints.Count > 0) then
        FSavepoints.Delete(FSavepoints.Count - 1);
    except
      on E: EADDBEngineException do
        if E.Kind = ekServerGone then begin
          FConnectionObj.RecoverConnection(Self, False);
          TransactionFinished;
        end
        else
          raise;
    end;
  finally
    // FConnectionObj is nil when connection recovery is aborted
    if FConnectionObj <> nil then begin
      if FSavepoints.Count = 0 then begin
        FState := tsInactive;
        FExplicitActive := False;
      end
      else
        FState := tsActive;
      FConnectionObj.UnLock;
{$IFDEF AnyDAC_MONITOR}
      if FConnectionObj.GetTracing then Trace2;
{$ENDIF}
    end;
  end;
  TxOperation(tsRollingback, False);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.RollbackRetaining;
begin
  FRetaining := True;
  try
    Rollback;
  finally
    FRetaining := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.LockAutoStop;
var
  oTx: TADTxOptions;
begin
  if FLockAutoStopCount = 0 then begin
    oTx := GetOptions;
    FPrevAutoStop := oTx.AutoStop;
    oTx.AutoStop := False;
    // Driver should not update CLI autocommit mode, so just clear xoAutoCommit.
    oTx.Changed := oTx.Changed - [xoAutoCommit];
  end;
  Inc(FLockAutoStopCount);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.UnlockAutoStop(ASuccess, AAllowStop: Boolean);
var
  oTx: TADTxOptions;
begin
  if FLockAutoStopCount > 0 then begin
    Dec(FLockAutoStopCount);
    if FLockAutoStopCount = 0 then begin
      oTx := GetOptions;
      oTx.AutoStop := FPrevAutoStop;
      // Driver should not update CLI autocommit mode, so just clear xoAutoCommit.
      oTx.Changed := oTx.Changed - [xoAutoCommit];
      if not FExplicitActive and FPrevAutoStop and AAllowStop then
        Stop(ASuccess);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.AddStateHandler(const AHandler: IADPhysTransactionStateHandler);
begin
  FStateHandlerList.Add(AHandler);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.RemoveStateHandler(const AHandler: IADPhysTransactionStateHandler);
begin
  FStateHandlerList.Remove(AHandler);
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetCLIAutoCommit: Boolean;
var
  oTx: TADTxOptions;
begin
  oTx := GetOptions;
  if FLockAutoStopCount = 0 then
    Result := oTx.AutoCommit
  else
    Result := oTx.AutoStart and FPrevAutoStop and
      (xoIfAutoStarted in oTx.StopOptions) and (xoIfCmdsInactive in oTx.StopOptions);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.InternalChanged;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.Update;
var
  lExecuted: Boolean;
begin
  if GetOptions.Changed <> [] then begin
    FConnectionObj.Lock;
    try
      lExecuted := False;
      repeat
        try
          InternalChanged;
          lExecuted := True;
        except
          on E: EADDBEngineException do
            if E.Kind = ekServerGone then
              FConnectionObj.RecoverConnection(Self, False)
            else
              raise;
        end;
      until lExecuted;
      GetOptions.ClearChanged;
    finally
      FConnectionObj.UnLock;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.ReleaseHandleBase;
begin
  GetOptions.ResetChanged;
  InternalReleaseHandle;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.InternalAllocHandle;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.InternalReleaseHandle;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.InternalSelect;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.InternalUnSelect;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
// IADStanErrorHandler

procedure TADPhysTransaction.HandleException(
  const AInitiator: IADStanObject; var AException: Exception);
begin
  FConnectionObj.HandleException(AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
// IADStanObject

function TADPhysTransaction.GetName: TComponentName;
begin
  Result := FMoniAdapterHelper.Name;
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetParent: IADStanObject;
begin
  Result := FMoniAdapterHelper.Parent;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  FMoniAdapterHelper.SetOwner(AOwner, ARole);
{$IFDEF AnyDAC_MONITOR}
  FMoniAdapterHelper.UnRegisterClient;
  FMoniAdapterHelper.RegisterClient(FConnectionObj.GetMonitor);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
// IADMoniAdapter

function TADPhysTransaction.GetHandle: LongWord;
begin
  if FMoniAdapterHelper = nil then
    Result := 0
  else
    Result := FMoniAdapterHelper.Handle;
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetSupportItems: TADMoniAdapterItemKinds;
begin
  Result := [ikStat];
end;

{-------------------------------------------------------------------------------}
function TADPhysTransaction.GetItemCount: Integer;
begin
  Result := 3;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysTransaction.GetItem(AIndex: Integer; out AName: String;
  out AValue: Variant; out AKind: TADMoniAdapterItemKind);
const
  C_States: array [TADPhysTransactionState] of String = ('Inactive', 'Active',
    'Starting', 'Commiting', 'Rolling back');
begin
  case AIndex of
  0:
    begin
      AName := 'Commands';
      AValue := FCommandList.Count;
      AKind := ikStat;
    end;
  1:
    begin
      AName := 'Start count';
      AValue := {$IFDEF AnyDAC_D6Base} FSerialID {$ELSE} Integer(FSerialID) {$ENDIF};
      AKind := ikStat;
    end;
  2:
    begin
      AName := 'State';
      AValue := C_States[FState];
      AKind := ikStat;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
procedure TADPhysTransaction.UpdateMonitor;
begin
  if FConnectionObj.GetTracing then
    FConnectionObj.FMonitor.AdapterChanged(Self as IADMoniAdapter);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADPhysEventThread                                                            }
{-------------------------------------------------------------------------------}
constructor TADPhysEventThread.Create(AAlerter: TADPhysEventAlerter);
begin
  inherited Create;
  FAlerter := AAlerter;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventThread.DoTimeout;
begin
  if Active and (FAlerter.GetOptions.Timeout > -1) then
    if FAlerter.GetOptions.Synchronize then
      TADThread.Synchronize(FAlerter.InternalTimeout)
    else
      FAlerter.InternalTimeout;
end;

{-------------------------------------------------------------------------------}
class function TADPhysEventThread.GetStartMsgClass: TADThreadMsgClass;
begin
  Result := TADPhysEventStartMessage;
end;

{-------------------------------------------------------------------------------}
class function TADPhysEventThread.GetStopMsgClass: TADThreadMsgClass;
begin
  Result := TADPhysEventStopMessage;
end;

{-------------------------------------------------------------------------------}
function TADPhysEventStartMessage.Perform(AThread: TADThread): Boolean;
begin
  (AThread as TADPhysEventThread).FAlerter.InternalRegister;
  Result := inherited Perform(AThread);
end;

{-------------------------------------------------------------------------------}
function TADPhysEventStopMessage.Perform(AThread: TADThread): Boolean;
begin
  (AThread as TADPhysEventThread).FAlerter.InternalUnregister;
  Result := inherited Perform(AThread);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventMessage.BasePerform;
begin
  FMsgThread.FAlerter.InternalHandle(Self);
end;

{-------------------------------------------------------------------------------}
function TADPhysEventMessage.Perform(AThread: TADThread): Boolean;
begin
  FMsgThread := AThread as TADPhysEventThread;
  if FMsgThread.Active then begin
    if FMsgThread.FAlerter.GetOptions.Synchronize then
      TADThread.Synchronize(BasePerform)
    else
      BasePerform;
  end;
  Result := True;
end;

{-------------------------------------------------------------------------------}
{ TADPhysEventAlerter                                                           }
{-------------------------------------------------------------------------------}
constructor TADPhysEventAlerter.Create(AConnection: TADPhysConnection;
  const AKind: String);
begin
  inherited Create;
  FConnection := AConnection as IADPhysConnection;
  FConnectionObj := AConnection;
  FConnectionObj.Lock;
  FConnectionObj.FEventList.Add(Self);
  FConnectionObj.UnLock;
  FKind := AKind;
  FState := esInactive;
  FNames := TADStringList.Create;
  FNames.OnChanging := DoNamesChanging;
{$IFDEF AnyDAC_D6}
  FNames.CaseSensitive := False;
{$ENDIF}
  SetOptions(nil);
  FMoniAdapterHelper := TADMoniAdapterHelper.Create(Self, AConnection);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysEventAlerter.Destroy;
begin
  Unregister;
  ADHighRefCounter(FRefCount);
  try
    FConnectionObj.Lock;
    FConnectionObj.FEventList.Remove(Self);
    FConnectionObj.UnLock;
    FExternalOptions := nil;
    ADFreeAndNil(FNames);
    ADFreeAndNil(FOptions);
    ADFree(FMoniAdapterHelper);
    FMoniAdapterHelper := nil;
    inherited Destroy;
  finally
    FRefCount := 0;
    FConnectionObj := nil;
    FConnection := nil;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysEventAlerter.GetConnection: IADPhysConnection;
begin
  Result := FConnectionObj as IADPhysConnection;
end;

{-------------------------------------------------------------------------------}
function TADPhysEventAlerter.GetHandler: IADPhysEventHandler;
begin
  Result := FHandler;
end;

{-------------------------------------------------------------------------------}
function TADPhysEventAlerter.GetNames: TStrings;
begin
  Result := FNames;
end;

{-------------------------------------------------------------------------------}
function TADPhysEventAlerter.GetOptions: TADEventAlerterOptions;
begin
  if FExternalOptions <> nil then
    Result := FExternalOptions
  else
    Result := FOptions;
end;

{-------------------------------------------------------------------------------}
function TADPhysEventAlerter.GetState: TADPhysEventAlerterState;
begin
  Result := FState;
end;

{-------------------------------------------------------------------------------}
function TADPhysEventAlerter.GetKind: String;
begin
  Result := FKind;
end;

{-------------------------------------------------------------------------------}
function TADPhysEventAlerter.GetDriverID: String;
begin
  if FConnectionObj <> nil then
    Result := FConnectionObj.DriverID
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.SetHandler(const AValue: IADPhysEventHandler);
begin
  FHandler := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.SetNames(const AValue: TStrings);
begin
  if FNames <> AValue then begin
    Unregister;
    FNames.Assign(AValue);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.SetOptions(const AValue: TADEventAlerterOptions);
begin
  if (FExternalOptions <> AValue) or (FMoniAdapterHelper = nil) then begin
    FExternalOptions := AValue;
    if FExternalOptions = nil then
      FOptions := TADEventAlerterOptions.Create
    else
      ADFreeAndNil(FOptions);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.Register;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    if not FMoniAdapterHelper.IsRegistered then
      FMoniAdapterHelper.RegisterClient(FConnectionObj.GetMonitor);
    FConnectionObj.Trace(ekConnService, esStart, 'RegisterEvent',
      ['ConnectionDef', FConnectionObj.GetConnectionDef.Name,
       'Kind', GetKind]);
  end;

  procedure Trace2;
  begin
    UpdateMonitor;
    FConnectionObj.Trace(ekConnService, esEnd, 'RegisterEvent',
      ['ConnectionDef', FConnectionObj.GetConnectionDef.Name,
       'Kind', GetKind]);
  end;
{$ENDIF}

begin
  if FState = esRegistered then
    Exit;
{$IFDEF AnyDAC_MONITOR}
  if FConnectionObj.GetTracing then Trace1;
  try
{$ENDIF}
    FConnectionObj.CheckActive;
    FConnectionObj.Lock;
    FState := esRegistering;
    try
      try
        InternalAllocHandle;
        FMsgThread := TADPhysEventThread.Create(Self);
        if GetOptions.Timeout > 0 then
          FMsgThread.IdleTimeout := GetOptions.Timeout;
        FMsgThread.Active := True;
        FState := esRegistered;
      except
        InternalReleaseHandle;
        if FMsgThread <> nil then begin
          FMsgThread.Shutdown(True);
          FMsgThread := nil;
        end;
        FState := esInactive;
        raise;
      end;
    finally
      FConnectionObj.UnLock;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if FConnectionObj.GetTracing then Trace2;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.DoNamesChanging(ASender: TObject);
begin
  Unregister;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.Unregister;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    FConnectionObj.Trace(ekConnService, esStart, 'UnregisterEvent',
      ['ConnectionDef', FConnectionObj.GetConnectionDef.Name,
       'Kind', GetKind]);
  end;

  procedure Trace2;
  begin
    UpdateMonitor;
    FConnectionObj.Trace(ekConnService, esEnd, 'UnregisterEvent',
      ['ConnectionDef', FConnectionObj.GetConnectionDef.Name,
       'Kind', GetKind]);
  end;
{$ENDIF}

begin
  if FState = esInactive then
    Exit;
{$IFDEF AnyDAC_MONITOR}
  if FConnectionObj.GetTracing then Trace1;
  try
{$ENDIF}
    FConnectionObj.CheckActive(True);
    FConnectionObj.Lock;
    FState := esUnregistering;
    try
      AbortJob;
      FMsgThread.Shutdown(True);
      InternalReleaseHandle;
    finally
      FMsgThread := nil;
      FState := esInactive;
      FConnectionObj.UnLock;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if FConnectionObj.GetTracing then Trace2;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.Signal(const AEvent: String;
  const AArgument: Variant);

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    FConnectionObj.Trace(ekConnService, esStart, 'SignalEvent',
      ['ConnectionDef', FConnectionObj.GetConnectionDef.Name,
       'Event', AEvent]);
  end;

  procedure Trace2;
  begin
    FConnectionObj.Trace(ekConnService, esEnd, 'SignalEvent',
      ['ConnectionDef', FConnectionObj.GetConnectionDef.Name,
       'Event', AEvent]);
  end;
{$ENDIF}

begin
{$IFDEF AnyDAC_MONITOR}
  if FConnectionObj.GetTracing then Trace1;
  try
{$ENDIF}
    FConnectionObj.CheckActive;
    InternalSignal(AEvent, AArgument);
{$IFDEF AnyDAC_MONITOR}
  finally
    if FConnectionObj.GetTracing then Trace2;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.InternalTimeout;
var
  lContinue: Boolean;
begin
  if (GetHandler <> nil) and (GetOptions.Timeout > 0) then begin
    lContinue := True;
    GetHandler.HandleTimeout(lContinue);
    if not lContinue then
      AbortJob;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.InternalAllocHandle;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.InternalRegister;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.InternalUnregister;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.InternalReleaseHandle;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.InternalAbortJob;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.AbortJob;
begin
  try
    InternalAbortJob;
    FMsgThread.Active := False;
  except
    // not visible
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysEventAlerter.IsRunning: Boolean;
begin
  Result := (FMsgThread <> nil) and FMsgThread.Active and not FMsgThread.Finished and
    (FState <> esInactive);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.SetupCommand(const ACmd: IADPhysCommand);
var
  oRes: TADResourceOptions;
  oFtch: TADFetchOptions;
begin
  oRes := ACmd.Options.ResourceOptions;
  oRes.PreprocessCmdText := True;
  oRes.CmdExecMode := amBlocking;
  oRes.CmdExecTimeout := $FFFFFFFF;
  oRes.DirectExecute := True;

  oFtch := ACmd.Options.FetchOptions;
  oFtch.AutoClose := True;
  oFtch.RecsSkip := -1;
  oFtch.RecsMax := -1;
  oFtch.Items := oFtch.Items - [fiMeta];
end;

{-------------------------------------------------------------------------------}
// IADStanErrorHandler

procedure TADPhysEventAlerter.HandleException(
  const AInitiator: IADStanObject; var AException: Exception);
begin
  FConnectionObj.HandleException(AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
// IADStanObject

function TADPhysEventAlerter.GetName: TComponentName;
begin
  Result := FMoniAdapterHelper.Name;
end;

{-------------------------------------------------------------------------------}
function TADPhysEventAlerter.GetParent: IADStanObject;
begin
  Result := FMoniAdapterHelper.Parent;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  FMoniAdapterHelper.SetOwner(AOwner, ARole);
{$IFDEF AnyDAC_MONITOR}
  FMoniAdapterHelper.UnRegisterClient;
  FMoniAdapterHelper.RegisterClient(FConnectionObj.GetMonitor);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
// IADMoniAdapter

function TADPhysEventAlerter.GetHandle: LongWord;
begin
  if FMoniAdapterHelper = nil then
    Result := 0
  else
    Result := FMoniAdapterHelper.Handle;
end;

{-------------------------------------------------------------------------------}
function TADPhysEventAlerter.GetSupportItems: TADMoniAdapterItemKinds;
begin
  Result := [ikStat];
end;

{-------------------------------------------------------------------------------}
function TADPhysEventAlerter.GetItemCount: Integer;
begin
  Result := 1;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysEventAlerter.GetItem(AIndex: Integer; out AName: String;
  out AValue: Variant; out AKind: TADMoniAdapterItemKind);
const
  C_States: array [TADPhysEventAlerterState] of String = ('Inactive', 'Registering',
    'Registered', 'Unregistering', 'Fired');
begin
  case AIndex of
  0:
    begin
      AName := 'State';
      AValue := C_States[FState];
      AKind := ikStat;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
procedure TADPhysEventAlerter.UpdateMonitor;
begin
  if FConnectionObj.GetTracing then
    FConnectionObj.FMonitor.AdapterChanged(Self as IADMoniAdapter);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADPhysCommandAsyncOperation                                                  }
{-------------------------------------------------------------------------------}
type
  TADPhysCommandAsyncOperation = class(TInterfacedObject, IADStanAsyncOperation)
  protected
    FCommand: TADPhysCommand;
    // IADStanAsyncOperation
    procedure Execute; virtual; abstract;
    procedure AbortJob;
    function AbortSupported: Boolean;
  public
    constructor Create(ACmd: TADPhysCommand);
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysCommandAsyncOperation.Create(ACmd: TADPhysCommand);
begin
  inherited Create;
  FCommand := ACmd;
{$IFNDEF NEXTGEN}
  FCommand._AddRef;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
destructor TADPhysCommandAsyncOperation.Destroy;
begin
{$IFNDEF NEXTGEN}
  FCommand._Release;
{$ENDIF}
  FCommand := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandAsyncOperation.AbortJob;
begin
  FCommand.AbortJob;
  while FCommand.GetState = csAborting do
    Sleep(1);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommandAsyncOperation.AbortSupported: Boolean;
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  FCommand.GetConnection.CreateMetadata(oConnMeta);
  Result := oConnMeta.AsyncAbortSupported;
end;

{ ----------------------------------------------------------------------------- }
{ TADPhysCommand                                                                }
{ ----------------------------------------------------------------------------- }
// Constructors

constructor TADPhysCommand.Create(AConnection: TADPhysConnection);
begin
  inherited Create;
  FConnection := AConnection as IADPhysConnection;
  FConnectionObj := AConnection;
  FConnectionObj.Lock;
  FConnectionObj.FCommandList.Add(Self);
  FConnectionObj.UnLock;
  FParams := TADParams.CreateRefCounted(GetParamsOwner);
  FMacros := TADMacros.CreateRefCounted(GetParamsOwner);
  SetOptions(nil);
  FObjectScopes := [osMy];
  FTableKinds := [tkSynonym, tkTable, tkView];
  FBuffer := TADBuffer.Create;
  FMoniAdapterHelper := TADMoniAdapterHelper.Create(Self, FConnectionObj);
end;

{-------------------------------------------------------------------------------}
destructor TADPhysCommand.Destroy;
begin
  ADHighRefCounter(FRefCount);
  Disconnect;
{$IFDEF AnyDAC_MONITOR}
  if FConnectionObj.GetTracing then
    FConnectionObj.FMonitor.Notify(ekLiveCycle, esProgress, Self, 'Destroy',
      ['Command', GetTraceCommandText]);
{$ENDIF}
  try
    SetTransaction(nil);
    FConnectionObj.Lock;
    FConnectionObj.FCommandList.Remove(Self);
    FConnectionObj.UnLock;
    FParams.RemRef;
    FParams := nil;
    FMacros.RemRef;
    FMacros := nil;
    FOptions := nil;
    ADFreeAndNil(FBuffer);
    inherited Destroy;
  finally
    ADFree(FMoniAdapterHelper);
    FMoniAdapterHelper := nil;
    FTransactionObj := nil;
    FTransaction := nil;
    FConnectionObj := nil;
    FConnection := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CreateCommandGenerator(out AGen: IADPhysCommandGenerator);
begin
  FConnection.CreateCommandGenerator(AGen, Self);
  AGen.Params := GetParams;
  AGen.Options := Self as IADStanOptions;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetParamsOwner: TPersistent;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetDriverID: String;
begin
  if FConnectionObj <> nil then
    Result := FConnectionObj.DriverID
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
// Tracing

function TADPhysCommand.GetTraceCommandText(const ACmd: String): String;

  function GetLoc: String;
  begin
    Result := '';
    if GetCatalogName <> '' then
      Result := Result + GetCatalogName + '.';
    if GetSchemaName <> '' then
      Result := Result + GetSchemaName + '.';
    if GetBaseObjectName <> '' then
      Result := Result + GetBaseObjectName + '.';
  end;

var
  sCmd: String;
begin
  if ACmd <> '' then
    sCmd := ACmd
  else
    sCmd := FCommandText;
  if FMetaInfoKind = mkNone then begin
    if FCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs] then begin
      Result := GetLoc + sCmd;
      if FOverload <> 0 then
        Result := Result + ';' + IntTostr(FOverload);
    end
    else
      Result := sCmd;
  end
  else begin
    sCmd := TrimRight(sCmd);
    case FMetaInfoKind of
    mkCatalogs:         Result := 'Catalog List';
    mkSchemas:          Result := 'Schemas List';
    mkTables:           Result := 'Table List';
    mkTableFields:      Result := 'Table Fields (' + GetLoc + sCmd + ')';
    mkIndexes:          Result := 'Table Indexes (' + GetLoc + sCmd + ')';
    mkIndexFields:      Result := 'Table Index Fields (' + GetLoc + FBaseObjectName + ', ' + sCmd + ')';
    mkPrimaryKey:       Result := 'Table PKeys (' + GetLoc + sCmd + ')';
    mkPrimaryKeyFields: Result := 'Table PKey Fields (' + GetLoc + FBaseObjectName + ')';
    mkForeignKeys:      Result := 'Table FKeys (' + GetLoc + sCmd + ')';
    mkForeignKeyFields: Result := 'Table FKey Fields (' + GetLoc + FBaseObjectName + ', ' + sCmd + ')';
    mkPackages:         Result := 'Packages(' + GetLoc + ')';
    mkProcs:            Result := 'Procedures (' + GetLoc + FBaseObjectName  + ')';
    mkProcArgs:         Result := 'Procedure Args (' + GetLoc + FBaseObjectName + ', ' + sCmd + ')';
    mkGenerators:       Result := 'Generator List';
    mkResultSetFields:  Result := 'ResultSet Fields (' + sCmd + ')';
    end;
  end;
end;

{$IFDEF AnyDAC_MONITOR}
{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Trace(AKind: TADMoniEventKind;
  AStep: TADMoniEventStep; const AMsg: String; const AArgs: array of const);
begin
  if FConnectionObj.GetTracing then
    FConnectionObj.FMonitor.Notify(AKind, AStep, Self, AMsg, AArgs);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.EnterTrace(AConnObj: TADPhysConnection): Boolean;
begin
  // _AddRef / _Release will preserve command from distruction before esEnd
  // trace call: esStart try ... finally esEnd end. Otherwise to many times
  // will be required to handle this situation.
  _AddRef;
  Result := AConnObj.GetTracing;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.ExitTrace(AConnObj: TADPhysConnection; var AUpdateMonitor: Boolean): Boolean;
begin
  Result := AConnObj.GetTracing;
  AUpdateMonitor := _Release > 0;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
// Options

function TADPhysCommand.GetOptions: IADStanOptions;
begin
  Result := Self as IADStanOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.GetParentOptions(out AOpts: IADStanOptions);
begin
  AOpts := FConnectionObj as IADStanOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetOptions(const AValue: IADStanOptions);
begin
  if (FOptions <> AValue) or (FBuffer = nil) then begin
    FOptions := AValue;
    if FOptions = nil then
      FOptions := TADOptionsContainer.Create(nil, TADFetchOptions,
        TADBottomUpdateOptions, TADBottomResourceOptions, GetParentOptions);
  end;
end;

{-------------------------------------------------------------------------------}
// Exception handling

function TADPhysCommand.GetErrorHandler: IADStanErrorHandler;
begin
  Result := FErrorHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetErrorHandler(const AValue: IADStanErrorHandler);
begin
  FErrorHandler := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.HandleException(const AInitiator: IADStanObject;
  var AException: Exception);
begin
{$IFDEF AnyDAC_MONITOR}
  if not (AException is EADDBEngineException) and FConnectionObj.GetTracing then
    Trace(ekError, esProgress, AException.Message, []);
{$ENDIF}
  if Assigned(GetErrorHandler()) then
    GetErrorHandler().HandleException(AInitiator, AException);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ParTypeUnknownError(AParam: TADParam);
begin
  ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccParTypeUnknown, [AParam.Name]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ParTypeMapError(AParam: TADParam);
begin
  ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccParDataMapNotSup, [AParam.Name]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ParDefChangedError(ADataType: TFieldType; AParam: TADParam);
begin
  ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccParDefChanged,
    [AParam.Name, FieldTypeNames[ADataType], FieldTypeNames[AParam.DataType]]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ParSetChangedError(AExpected, AActual: Integer);
begin
  ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccParSetChanged, [AExpected, AActual]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ColTypeMapError(AColumn: TADDatSColumn);
begin
  ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccColDataMapNotSup, [AColumn.SourceName]);
end;

{-------------------------------------------------------------------------------}
// Get/set props

function TADPhysCommand.GetState: TADPhysCommandState;
begin
  Result := FState;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetState(const AValue: TADPhysCommandState);
begin
  FState := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetConnection: IADPhysConnection;
begin
  Result := FConnection;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetCommandText: String;
begin
  Result := FCommandText;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetCommandText(const AValue: String);
begin
  if FCommandText <> AValue then begin
    Disconnect;
    FCommandText := AValue;
    Preprocess;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetParams: TADParams;
begin
  Result := FParams;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetMacros: TADMacros;
begin
  Result := FMacros;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetParams(AValue: TADParams);
begin
  if AValue = FParams then
    Exit;
  if FParams <> nil then
    if FParams.IsRefCounted then
      FParams.RemRef
    else
      ADFree(FParams);
  FParams := AValue;
  if FParams <> nil then begin
    if FParams.IsRefCounted then
      FParams.AddRef;
  end
  else
    FParams := TADParams.CreateRefCounted(GetParamsOwner);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetMacros(AValue: TADMacros);
begin
  if AValue = FMacros then
    Exit;
  if FMacros <> nil then
    if FMacros.IsRefCounted then
      FMacros.RemRef
    else
      ADFree(FMacros);
  FMacros := AValue;
  if FMacros <> nil then begin
    if FMacros.IsRefCounted then
      FMacros.AddRef;
  end
  else
    FMacros := TADMacros.CreateRefCounted(GetParamsOwner);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetCommandKind: TADPhysCommandKind;
begin
  Result := FCommandKind;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetCommandKind(const AValue: TADPhysCommandKind);
begin
  FCommandKind := AValue;
  FFixedCommandKind := (AValue <> skUnknown);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetSourceObjectName: String;
begin
  Result := FSourceObjectName;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetSourceObjectName(const AValue: String);
begin
  FSourceObjectName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetSourceRecordSetName: String;
begin
  Result := FSourceRecordSetName;
  if Result = '' then
    Result := GetSourceObjectName
  else if FRecordSetIndex > 0 then
    Result := Result + '#' + IntToStr(FRecordSetIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetSourceRecordSetName(const AValue: String);
begin
  FSourceRecordSetName := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetOverload: Word;
begin
  Result := FOverload;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetOverload(const AValue: Word);
begin
  if AValue <> FOverload then begin
    Disconnect;
    FOverload := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetBaseObjectName: String;
begin
  Result := FBaseObjectName;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetBaseObjectName(const AValue: String);
begin
  if AValue <> FBaseObjectName then begin
    Disconnect;
    FBaseObjectName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetSchemaName: String;
begin
  Result := FSchemaName;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetSchemaName(const AValue: String);
begin
  if AValue <> FSchemaName then begin
    Disconnect;
    FSchemaName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetCatalogName: String;
begin
  Result := FCatalogName;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetCatalogName(const AValue: String);
begin
  if AValue <> FCatalogName then begin
    Disconnect;
    FCatalogName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetNextRecordSet: Boolean;
begin
  Result := FNextRecordSet;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetNextRecordSet(const AValue: Boolean);
begin
  FNextRecordSet := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetMappingHandler: IADPhysMappingHandler;
begin
  Result := FMappingHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetMappingHandler(const AValue: IADPhysMappingHandler);
begin
  FMappingHandler := AValue;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetSQLOrderByPos: Integer;
begin
  Result := FSQLOrderByPos;
end;

{ ----------------------------------------------------------------------------- }
function TADPhysCommand.GetCliObj: Pointer;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetSQLText: String;
begin
  Result := FDbCommandText;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetTransaction: IADPhysTransaction;
begin
  Result := FTransaction;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetTransaction(const AValue: IADPhysTransaction);
var
  oTxObj: TADPhysTransaction;
begin
  CheckState(csInactive);
  if AValue <> FTransaction then begin
    if FTransactionObj <> nil then begin
{$IFDEF AnyDAC_MONITOR}
      if FMoniAdapterHelper.IsRegistered and
         (FMoniAdapterHelper.Parent = IADStanObject(FTransactionObj)) then begin
        FMoniAdapterHelper.UnRegisterClient;
        FMoniAdapterHelper.SetOwner(FConnectionObj, '');
      end;
{$ENDIF}
      FConnectionObj.Lock;
      FTransactionObj.FCommandList.Remove(Self);
      FConnectionObj.UnLock;
      FTransaction := nil;
      FTransactionObj := nil;
    end;
    if AValue <> nil then begin
      oTxObj := GetTxObj(AValue);
      if oTxObj.FConnectionObj <> FConnectionObj then
        ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccCantAssignTxIntf, []);
      FTransaction := AValue;
      FTransactionObj := oTxObj;
      FConnectionObj.Lock;
      FTransactionObj.FCommandList.Add(Self);
      FConnectionObj.UnLock;
{$IFDEF AnyDAC_MONITOR}
      if FMoniAdapterHelper.Parent = IADStanObject(FConnectionObj) then begin
        if FMoniAdapterHelper.IsRegistered then
          FMoniAdapterHelper.UnRegisterClient;
        FMoniAdapterHelper.SetOwner(FTransactionObj, '');
      end;
{$ENDIF}
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetStateHandler: IADPhysCommandStateHandler;
begin
  Result := FStateHandler;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetStateHandler(const AValue: IADPhysCommandStateHandler);
begin
  FStateHandler := AValue;
end;

{-------------------------------------------------------------------------------}
// Metainfo get/set

function TADPhysCommand.GetMetaInfoKind: TADPhysMetaInfoKind;
begin
  Result := FMetaInfoKind;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetMetaInfoKind(AValue: TADPhysMetaInfoKind);
begin
  if AValue <> FMetaInfoKind then begin
    Disconnect;
    FMetaInfoKind := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetTableKinds: TADPhysTableKinds;
begin
  Result := FTableKinds;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetTableKinds(AValue: TADPhysTableKinds);
begin
  if AValue <> FTableKinds then begin
    Disconnect;
    FTableKinds := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetWildcard: String;
begin
  Result := FWildcard;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetWildcard(const AValue: String);
begin
  if AValue <> FWildcard then begin
    Disconnect;
    FWildcard := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetObjectScopes: TADPhysObjectScopes;
begin
  Result := FObjectScopes;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetObjectScopes(AValue: TADPhysObjectScopes);
begin
  if AValue <> FObjectScopes then begin
    Disconnect;
    FObjectScopes := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
// Runtime cycle

procedure TADPhysCommand.ExecuteTask(const AOperation: IADStanAsyncOperation;
  const AHandler: IADStanAsyncHandler; ABlocked: Boolean);
var
  eMode: TADStanAsyncMode;
  oRes: TADResourceOptions;
begin
  oRes := FOptions.ResourceOptions;
  eMode := oRes.CmdExecMode;
  if ABlocked and (eMode = amAsync) then
    eMode := amBlocking;
  try
    if FExecutor = nil then
      ADCreateInterface(IADStanAsyncExecutor, FExecutor);
    FExecutor.Setup(AOperation, eMode, oRes.CmdExecTimeout, AHandler,
      oRes.ActualSilentMode);
  except
    on E: Exception do begin
      if AHandler <> nil then
        AHandler.HandleFinished(Self, asFailed, E);
      raise;
    end;
  end;
  FExecutor.Run;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Disconnect;
begin
  CheckAsyncProgress;
  if GetState = csOpen then
    CloseAll;
  if GetState = csPrepared then
    Unprepare;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CheckAsyncProgress;
begin
  if GetState in [csExecuting, csFetching] then
    ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccAsyncOperInProgress, []);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CheckState(ARequiredState: TADPhysCommandState);
begin
  if GetState <> ARequiredState then
    ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccCantChngCommandState, []);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.AbortJob(const AWait: Boolean = False);
var
  oConnMeta: IADPhysConnectionMetadata;
begin
  if (FThreadID <> TADThreadID(0)) and (FThreadID = GetCurrentThreadId()) then begin
    if FState = csFetching then
      FState := csOpen
    else if FState = csExecuting then
      FState := csPrepared;
    Exit;
  end;
  FConnection.CreateMetadata(oConnMeta);
  if oConnMeta.AsyncAbortSupported and (GetState in [csExecuting, csFetching]) then
    try
      FState := csAborting;
      InternalAbort;
    except
      on E: EADDBEngineException do
        if (E.Kind = ekServerGone) and (GetState = csAborting) then
          FState := csPrepared;
    end;
  if AWait then begin
    while GetState in [csExecuting, csFetching, csAborting] do
      Sleep(1);
{$IFDEF AnyDAC_D6}
    if (FExecutor <> nil) and (FExecutor.Operation <> nil) then begin
      Sleep(1);
      if GetCurrentThreadID = MainThreadID then
        CheckSynchronize();
    end;
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.InternalAbort;
begin
  ADCapabilityNotSupported(Self, [S_AD_LPhys, DriverID]);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.PreprocessCommand(ACreateParams, ACreateMacros,
  AExpandParams, AExpandMacros, AExpandEscapes, AParseSQL: Boolean);
var
  oPP: TADPhysPreprocessor;
  oPList: TADParams;
  oMList: TADMacros;
  oConnMeta: IADPhysConnectionMetadata;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekCmdPrepare, esProgress, 'Preprocessed', ['CMD', FDbCommandText,
      'FROM', oPP.SQLFromValue, 'VP', oPP.SQLValuesPos, 'VPE', oPP.SQLValuesPosEnd,
      'OBP', oPP.SQLOrderByPos, 'CK', Integer(oPP.SQLCommandKind)]);
  end;
{$ENDIF}

begin
  if not (ACreateParams or ACreateMacros or AExpandParams or AExpandMacros or
          AExpandEscapes or AParseSQL) then
    Exit;
  oPList := nil;
  oMList := nil;
  oPP := TADPhysPreprocessor.Create;
  oPP.Instrs := [];
  if AExpandParams then begin
    oPP.Instrs := oPP.Instrs + [piExpandParams];
    oPList := GetParams;
  end;
  if AExpandMacros then begin
    oPP.Instrs := oPP.Instrs + [piExpandMacros];
    oMList := GetMacros;
  end;
  if AExpandEscapes then
    oPP.Instrs := oPP.Instrs + [piExpandEscapes];
  if AParseSQL then
    oPP.Instrs := oPP.Instrs + [piParseSQL, piTransformEOLs];
  if ACreateParams then begin
    oPList := TADParams.CreateRefCounted(GetParamsOwner);
    oPList.BindMode := GetParams.BindMode;
    oPP.Instrs := oPP.Instrs + [piCreateParams];
  end;
  if ACreateMacros then begin
    oMList := TADMacros.CreateRefCounted(GetParamsOwner);
    oPP.Instrs := oPP.Instrs + [piCreateMacros];
  end;
  try
    FConnection.CreateMetadata(oConnMeta);
    oPP.ConnMetadata := oConnMeta;
    oPP.Source := FCommandText;
    oPP.Params := oPList;
    oPP.MacrosRead := GetMacros;
    oPP.MacrosUpd := oMList;
    oPP.Execute;
    if AParseSQL then begin
      FDbCommandText := oPP.Destination;
{$IFDEF AnyDAC_MONITOR}
      if FConnectionObj.GetTracing then Trace1;
{$ENDIF}
      if not FFixedCommandKind and (GetCommandKind = skUnknown) then begin
        SetCommandKind(oPP.SQLCommandKind);
        FFixedCommandKind := False;
      end;
      SetSourceObjectName(oPP.SQLFromValue);
      FSQLValuesPos := oPP.SQLValuesPos;
      FSQLValuesPosEnd := oPP.SQLValuesPosEnd;
      FSQLOrderByPos := oPP.SQLOrderByPos;
      FSQLLimitSkip := oPP.SQLLimitSkip;
      FSQLLimitRows := oPP.SQLLimitRows;
    end;
    if ACreateParams then begin
      oPList.AssignValues(GetParams);
      GetParams.Assign(oPList);
    end;
    if ACreateMacros then begin
      oMList.AssignValues(GetMacros);
      GetMacros.TempLockUpdate;
      GetMacros.Assign(oMList);
    end;
  finally
    if ACreateParams then
      oPList.RemRef;
    if ACreateMacros then
      oMList.RemRef;
    ADFree(oPP);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CheckPreprocessCommand(ACreateParams: Boolean);
var
  oRes: TADResourceOptions;
begin
  if not (GetCommandKind in [skStoredProc, skStoredProcWithCrs, skStoredProcNoCrs]) and
     (GetMetaInfoKind = mkNone) then begin
    oRes := FOptions.ResourceOptions;
    PreprocessCommand(oRes.ParamCreate and ACreateParams, oRes.MacroCreate and ACreateParams,
      oRes.ParamExpand, oRes.MacroExpand, oRes.EscapeExpand, True);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Preprocess;
begin
  CheckPreprocessCommand(True);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Prepare(const ACommandText: String = ''; ACreateParams: Boolean = True);

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    if not FMoniAdapterHelper.IsRegistered then
      FMoniAdapterHelper.RegisterClient(FConnectionObj.GetMonitor);
    Trace(ekCmdPrepare, esStart, 'Prepare', ['Command', GetTraceCommandText(ACommandText)]);
  end;

  procedure Trace2(AUpdateMonitor: Boolean);
  begin
    if AUpdateMonitor then UpdateMonitor;
    Trace(ekCmdPrepare, esEnd, 'Prepare', ['Command', GetTraceCommandText]);
  end;
{$ENDIF}

var
  lPrepared: Boolean;
{$IFDEF AnyDAC_MONITOR}
  lUpdateMonitor: Boolean;
{$ENDIF}
begin
  if (GetState <> csInactive) and (ACommandText = '') then
    Exit;
{$IFDEF AnyDAC_MONITOR}
  if EnterTrace(FConnectionObj) then Trace1;
  try
{$ENDIF}
    Disconnect;
    ASSERT(FConnection <> nil);
    if FTransaction = nil then begin
      SetTransaction(FConnection.Transaction);
      ASSERT(FTransaction <> nil);
    end;
    FConnectionObj.CheckActive(True);
    if ACommandText <> '' then
      FCommandText := ACommandText;
    if (GetMetaInfoKind = mkNone) and (GetCommandText = '') then
      ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccCommandMBFilled, []);
    FSQLLimitSkip := -1;
    FSQLLimitRows := -1;
    CheckPreprocessCommand((ACommandText <> '') and ACreateParams);
    GetParams.Prepare(GetOptions.FormatOptions.DefaultParamDataType,
                      GetOptions.ResourceOptions.DefaultParamType);
    FBuffer.Release;
    FRecordSetIndex := -1;
    FConnectionObj.IncPrepared(Self);
    try
      lPrepared := False;
      repeat
        try
          FTransactionObj.Notify(cpBeforeCmdPrepare, Self);
          InternalPrepare;
          lPrepared := True;
        except
          on E: Exception do begin
            InternalUnprepare;
            if (E is EADDBEngineException) and (EADDBEngineException(E).Kind = ekServerGone) then
              FConnectionObj.RecoverConnection(Self, False)
            else
              raise;
          end;
        end;
      until lPrepared;
      FTransactionObj.Notify(cpAfterCmdPrepareSuccess, Self);
    except
      GetParams.Markers.Clear;
      FConnectionObj.DecPrepared;
      FTransactionObj.Notify(cpAfterCmdPrepareFailure, Self);
      raise;
    end;
    FState := csPrepared;
{$IFDEF AnyDAC_MONITOR}
  finally
    if ExitTrace(FConnectionObj, lUpdateMonitor) then Trace2(lUpdateMonitor);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Unprepare;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekCmdPrepare, esStart, 'Unprepare', ['Command', GetTraceCommandText]);
  end;

  procedure Trace2(AUpdateMonitor: Boolean);
  begin
    if AUpdateMonitor then UpdateMonitor;
    Trace(ekCmdPrepare, esEnd, 'Unprepare', ['Command', GetTraceCommandText]);
  end;
{$ENDIF}

var
  lDestroyed: Boolean;
{$IFDEF AnyDAC_MONITOR}
  oConn: TADPhysConnection;
  lUpdateMonitor: Boolean;
{$ENDIF}
begin
  if GetState = csInactive then
    Exit;
  if (GetStateHandler <> nil) and not FConnectionObj.FDontCallStateHandler then begin
    CheckAsyncProgress;
    _AddRef;
    try
      GetStateHandler.HandleUnprepare;
    finally
      lDestroyed := _Release = 0;
    end;
    if lDestroyed or (GetState = csInactive) then
      Exit;
  end;
{$IFDEF AnyDAC_MONITOR}
  oConn := FConnectionObj;
  if EnterTrace(oConn) then Trace1;
  try
{$ENDIF}
    CheckAsyncProgress;
    if GetState = csOpen then
      CloseAll;
    if GetState = csInactive then
      Exit;
    CheckState(csPrepared);
    FBuffer.Release;
    InternalUnprepare;
    GetParams.Markers.Clear;
    FConnectionObj.DecPrepared;
    FExecuteCount := 0;
    FRecordsFetched := 0;
    if not FFixedCommandKind then
      SetCommandKind(skUnknown);
    SetSourceObjectName('');
    FExecutor := nil;
    FState := csInactive;
    FTransactionObj.Notify(cpAfterCmdUnprepare, Self);
{$IFDEF AnyDAC_MONITOR}
  finally
    if ExitTrace(oConn, lUpdateMonitor) then Trace2(lUpdateMonitor);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.GenerateStoredProcParams(const AName: TADPhysParsedName;
  AOverload: Word = 0);
var
  oGen: IADPhysCommandGenerator;
begin
  CreateCommandGenerator(oGen);
  FDbCommandText := oGen.GenerateStoredProcParams(AName.FCatalog, AName.FSchema,
    AName.FBaseObject, AName.FObject, AOverload);
  if GetCommandKind = skStoredProc then
    SetCommandKind(oGen.CommandKind);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.GenerateStoredProcCall(const AName: TADPhysParsedName;
  ASPUsage: TADPhysCommandKind = skStoredProc);
var
  oGen: IADPhysCommandGenerator;
begin
  CreateCommandGenerator(oGen);
  FDbCommandText := oGen.GenerateStoredProcCall(AName.FCatalog, AName.FSchema,
    AName.FBaseObject, AName.FObject, ASPUsage);
  SetCommandKind(oGen.CommandKind);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.GetSelectMetaInfoParams(out AName: TADPhysParsedName);
var
  sCmd: String;
  oConnMeta: IADPhysConnectionMetadata;
begin
  sCmd := Trim(GetCommandText());
  if GetMetaInfoKind() <> mkResultSetFields then begin
    FConnection.CreateMetadata(oConnMeta);
    oConnMeta.DecodeObjName(sCmd, AName, Self, [doNormalize, doUnquote, doMetaParams]);
    CheckMetaInfoParams(AName);
  end
  else
    AName.FObject := sCmd;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.GenerateSelectMetaInfo(const AName: TADPhysParsedName);
var
  oGen: IADPhysCommandGenerator;
  i: Integer;
  oPar: TADParam;
begin
  GetMacros.Clear;
  GetParams.Clear;
  CreateCommandGenerator(oGen);
  FDbCommandText := oGen.GenerateSelectMetaInfo(GetMetaInfoKind(),
    AName.FCatalog, AName.FSchema, AName.FBaseObject, AName.FObject,
    GetWildcard(), GetObjectScopes(), GetTableKinds(), GetOverload());
  SetCommandKind(oGen.CommandKind);
  for i := 0 to GetParams.Count - 1 do begin
    oPar := GetParams[i];
    if CompareText(oPar.Name, 'CAT') = 0 then
      oPar.Value := AName.FCatalog
    else if CompareText(oPar.Name, 'SCH') = 0 then
      oPar.Value := AName.FSchema
    else if CompareText(oPar.Name, 'BAS') = 0 then
      oPar.Value := AName.FBaseObject
    else if CompareText(oPar.Name, 'OBJ') = 0 then
      oPar.Value := AName.FObject
    else if CompareText(oPar.Name, 'WIL') = 0 then
      oPar.Value := GetWildcard()
    else if CompareText(oPar.Name, 'OVE') = 0 then
      oPar.Value := GetOverload();
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.GenerateLimitSelect();
var
  oFtchOpts: TADFetchOptions;

  procedure DoGenerate(ASkip, ARows: Integer);
  var
    oGen: IADPhysCommandGenerator;
  begin
    CreateCommandGenerator(oGen);
    FDbCommandText := oGen.GenerateLimitSelect(FDbCommandText, ASkip, ARows,
      (oFtchOpts.Mode = fmExactRecsMax) and (ARows >= 0));
    FSQLOrderByPos := oGen.SQLOrderByPos;
  end;

begin
  oFtchOpts := FOptions.FetchOptions;
  if (FSQLLimitSkip <> -1) or (FSQLLimitRows <> -1) then
    DoGenerate(FSQLLimitSkip, FSQLLimitRows)
  else if (oFtchOpts.RecsSkip <> -1) or
          (oFtchOpts.RecsMax <> -1) and (oFtchOpts.Mode <> fmExactRecsMax) then
    DoGenerate(oFtchOpts.RecsSkip, oFtchOpts.RecsMax);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.GenerateParamMarkers();
var
  i: Integer;
  oPars: TADParams;
begin
  oPars := GetParams();
  if (oPars.Markers.Count = 0) and (oPars.Count > 0) then
    for i := 0 to oPars.Count - 1 do
      oPars.Markers.Add(oPars[i].Name);
end;

{-------------------------------------------------------------------------------}
// Query open / close

type
  TADPhysCommandAsyncOpen = class(TADPhysCommandAsyncOperation)
  protected
    procedure Execute; override;
  end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandAsyncOpen.Execute;
begin
  FCommand.OpenBase;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CheckMetaInfoParams(const AName: TADPhysParsedName);

  procedure CheckRequired(const AValue, ASubMsg: String);
  begin
    if AValue = '' then
      ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccMetaInfoNotDefined, [ASubMsg]);
  end;

const
  STabName: String = 'table name';
  SProcName: String = 'procedure name';
  SIndexName: String = 'index name';
  SFKName: String = 'foreign key name';
begin
  case GetMetaInfoKind of
  mkCatalogs:
    ;
  mkSchemas:
    ;
  mkTables:
    ;
  mkTableFields:
    CheckRequired(AName.FObject, STabName);
  mkIndexes:
    CheckRequired(AName.FObject, STabName);
  mkIndexFields:
    begin
      CheckRequired(AName.FBaseObject, STabName);
      CheckRequired(AName.FObject, SIndexName);
    end;
  mkPrimaryKey:
    CheckRequired(AName.FObject, STabName);
  mkPrimaryKeyFields:
    CheckRequired(AName.FBaseObject, STabName);
  mkForeignKeys:
    CheckRequired(AName.FObject, STabName);
  mkForeignKeyFields:
    begin
      CheckRequired(AName.FBaseObject, STabName);
      CheckRequired(AName.FObject, SFKName);
    end;
  mkPackages:
    ;
  mkProcs:
    ;
  mkProcArgs:
    CheckRequired(AName.FObject, SProcName);
  mkGenerators:
    ;
  mkResultSetFields:
    ;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.OpenBase;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekCmdExecute, esStart, 'Open', ['Command', GetTraceCommandText]);
  end;

  procedure Trace2(AUpdateMonitor: Boolean);
  begin
    if AUpdateMonitor then UpdateMonitor;
    Trace(ekCmdExecute, esEnd, 'Open', ['Command', GetTraceCommandText]);
  end;
{$ENDIF}

var
  lOpened: Boolean;
  lExecuted: Boolean;
{$IFDEF AnyDAC_MONITOR}
  lUpdateMonitor: Boolean;
{$ENDIF}
begin
  if GetState = csOpen then
    Exit
  else if GetState = csAborting then begin
    FState := csPrepared;
    Exit;
  end;

{$IFDEF AnyDAC_MONITOR}
  if EnterTrace(FConnectionObj) then Trace1;
  try
{$ENDIF}
    if not GetNextRecordSet then
      FConnectionObj.SaveLastAutoGenValue(Null);

    CheckAsyncProgress;
    if GetState = csInactive then
      Prepare;
    CheckState(csPrepared);

    FState := csExecuting;
    FThreadID := GetCurrentThreadId();
    FExecutor.Launched;
    lOpened := False;
    try

      try
        lExecuted := False;
        repeat
          if not GetNextRecordSet then
            FTransactionObj.Notify(cpBeforeCmdExecute, Self);
          try
            if not GetNextRecordSet then
              lOpened := InternalOpen
            else
              lOpened := InternalNextRecordSet;
            lExecuted := True;
          except
            on E: EADDBEngineException do begin
              if E.Kind = ekServerGone then begin
                FConnectionObj.RecoverConnection(Self, False);
                if GetNextRecordSet then begin
                  lOpened := False;
                  lExecuted := True;
                end
              end
              else
                raise;
            end;
          end;
        until lExecuted;

      except
        if not GetNextRecordSet then
          FTransactionObj.Notify(cpAfterCmdExecuteFailure, Self);
        raise;
      end;
      if not lOpened then
        FTransactionObj.Notify(cpAfterCmdExecuteSuccess, Self);

    finally
      if FState = csAborting then begin
        lOpened := False;
        InternalClose;
      end;
      if lOpened then begin
        FState := csOpen;
        FBuffer.Check;
        FEof := False;
        FFirstFetch := True;
        FRecordsFetched := 0;
        Inc(FExecuteCount);
        Inc(FRecordSetIndex);
      end
      else if FState <> csInactive then
        FState := csPrepared;
      FThreadID := 0;
    end;

{$IFDEF AnyDAC_MONITOR}
  finally
    if ExitTrace(FConnectionObj, lUpdateMonitor) then Trace2(lUpdateMonitor);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.OpenBlocked: Boolean;
begin
  if GetState <> csOpen then
    Open(True);
  Result := (GetState = csOpen);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Open(ABlocked: Boolean = False);
var
  oOper: IADStanAsyncOperation;
begin
  oOper := TADPhysCommandAsyncOpen.Create(Self) as IADStanAsyncOperation;
  ExecuteTask(oOper, GetStateHandler, ABlocked);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Close;

{$IFDEF AnyDAC_MONITOR}
var
  oConn: TADPhysConnection;
  lUpdateMonitor: Boolean;
  sCmdText: String;
  procedure Trace1;
  begin
    sCmdText := GetTraceCommandText;
    Trace(ekCmdExecute, esStart, 'Close', ['Command', sCmdText]);
  end;

  procedure Trace2(AUpdateMonitor: Boolean);
  begin
    if AUpdateMonitor then UpdateMonitor;
    oConn.Trace(ekCmdExecute, esEnd, 'Close', ['Command', sCmdText]);
  end;
{$ENDIF}

begin
  if GetState in [csInactive, csPrepared] then
    Exit;
{$IFDEF AnyDAC_MONITOR}
  oConn := FConnectionObj;
  if EnterTrace(oConn) then Trace1;
  try
{$ENDIF}
    CheckAsyncProgress;
    if GetState = csOpen then
      try
        InternalClose;
      finally
        if GetState <> csInactive then
          FState := csPrepared;
        FRecordSetIndex := -1;
        if not GetNextRecordSet then
          FTransactionObj.Notify(cpAfterCmdExecuteSuccess, Self);
      end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if ExitTrace(oConn, lUpdateMonitor) then Trace2(lUpdateMonitor);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CloseAll;
begin
  SetNextRecordSet(False);
  Close;
end;

{-------------------------------------------------------------------------------}
// Defining

function TADPhysCommand.InternalUseStandardMetadata: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D12}
  {$WARNINGS OFF}
{$ENDIF}
function TADPhysCommand.DoDefineDataTable(ADatSManager: TADDatSManager;
  ATable: TADDatSTable; ARootID: Integer; const ARootName: String;
  AMetaInfoMergeMode: TADPhysMetaInfoMergeMode): TADDatSTable;
var
  i, j: Integer;
  oFmtOpts: TADFormatOptions;
  oUpdOpts: TADBottomUpdateOptions;
  rTabInfo: TADPhysDataTableInfo;
  rColInfo: TADPhysDataColumnInfo;
  oChildTab: TADDatSTable;
  oCol, oChildTabRelCol, oROWIDCol: TADDatSColumn;
  oRel: TADDatSRelation;
  lTabCreated, lColCreated, lInUpdate: Boolean;
  oCreatedList: TADObjList;
  oOriginCols: TADStringList;
  sName, sTabName, sFirstOriginTabName: String;
  lDefPK, lPKDefined, lNoRowSet, lExtAttrs: Boolean;
  oConnMeta: IADPhysConnectionMetadata;
  oPKFieldsView: TADDatSView;
  pMappedTabId: Variant;
  eMappedTabKind: TADPhysNameKind;
  eLocalMetaInfoMergeMode: TADPhysMetaInfoMergeMode;
  rName, rName1, rName2: TADPhysParsedName;
  lOriginProvided, lUpdBaseFieldsOnly, lOriginUseful: Boolean;

  function EnsureTabExistance(ADatSManager: TADDatSManager; var ASourceID: Integer;
    var ASourceName, ADatSName: String; var ATabCreated: Boolean): TADDatSTable;
  var
    i: Integer;
    eMapResult: TADPhysMappingResult;
    sTmp: String;
    oTab: TADDatSTable;
  begin
    if ATable <> nil then
      Result := ATable
    else
      Result := nil;
    ATabCreated := False;
    ADatSName := '';
    eMapResult := mrDefault;
    sTmp := '';
    oTab := nil;
    pMappedTabId := 0;
    eMappedTabKind := nkDefault;
    if GetMappingHandler <> nil then begin
      if ASourceID >= 0 then
        eMapResult := GetMappingHandler.MapRecordSet(ASourceID, nkID,
          ASourceID, ASourceName, ADatSName, sTmp, oTab);
      if eMapResult = mrMapped then begin
        pMappedTabId := ASourceID;
        eMappedTabKind := nkId;
      end
      else begin
        eMapResult := GetMappingHandler.MapRecordSet(ASourceName, nkSource,
          ASourceID, ASourceName, ADatSName, sTmp, oTab);
        if eMapResult = mrMapped then begin
          pMappedTabId := ASourceName;
          eMappedTabKind := nkSource;
        end;
      end;
      if (eMapResult = mrMapped) and (ATable = nil) then
        Result := oTab
    end;
    if eMapResult = mrDefault then
      if (ADatSManager <> nil) and (ATable = nil) then begin
        if eLocalMetaInfoMergeMode <> mmReset then begin
          if ASourceName <> '' then
            i := ADatSManager.Tables.IndexOfSourceName(ASourceName)
          else
            i := -1;
          if (i = -1) and (ASourceID >= 0) then
            i := ADatSManager.Tables.IndexOfSourceID(ASourceID);
          if i <> -1 then
            Result := ADatSManager.Tables[i];
        end;
      end;
    if Result = nil then begin
      if (eLocalMetaInfoMergeMode <> mmRely) and ((ARootID <> -1) or (eMapResult <> mrNotMapped)) then begin
        Result := TADDatSTable.Create;
        Result.CountRef(0);
        oCreatedList.Add(Result);
        ATabCreated := True;
      end;
    end
    else
      if (eLocalMetaInfoMergeMode = mmRely) and (ATable <> Result) then
        ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccMetaInfoMismatch, []);
    if Result <> nil then
      Result.Setup(FOptions);
  end;

  function EnsureColExistance(ATable: TADDatSTable; var ASourceID: Integer;
    var ASourceName, ADatSName: String; var AColCreated: Boolean): TADDatSColumn;
  var
    i: Integer;
    eMapResult: TADPhysMappingResult;
    sTmp: String;
    oCol: TADDatSColumn;
  begin
    Result := nil;
    AColCreated := False;
    ADatSName := '';
    sTmp := '';
    oCol := nil;
    eMapResult := mrDefault;
    if (GetMappingHandler <> nil) and (eMappedTabKind <> nkDefault) then begin
      if ASourceID >= 0 then
        eMapResult := GetMappingHandler.MapRecordSetColumn(pMappedTabId, eMappedTabKind,
          ASourceID, nkID, ASourceID, ASourceName, ADatSName, sTmp, oCol);
      if eMapResult <> mrMapped then
        eMapResult := GetMappingHandler.MapRecordSetColumn(pMappedTabId, eMappedTabKind,
          ASourceName, nkSource, ASourceID, ASourceName, ADatSName, sTmp, oCol);
      if (oCol <> nil) and (oCol.Table = ATable) and (eMapResult = mrMapped) then
        Result := oCol;
    end;
    if eMapResult = mrDefault then
      if eLocalMetaInfoMergeMode <> mmReset then begin
        if ASourceName <> '' then
          i := ATable.Columns.IndexOfSourceName(ASourceName)
        else
          i := -1;
        if (i = -1) and (ASourceID >= 0) then
          i := ATable.Columns.IndexOfSourceID(ASourceID);
        if i <> -1 then
          Result := ATable.Columns[i];
      end;
    if Result = nil then
      if (eLocalMetaInfoMergeMode <> mmRely) and (eMapResult <> mrNotMapped) then begin
        Result := TADDatSColumn.Create;
        oCreatedList.Add(Result);
        AColCreated := True;
      end;
  end;

  procedure CheckColMatching(AColumn: TADDatSColumn; const AInfo: TADPhysDataColumnInfo);
  begin
    if not ((AColumn.SourceDataType = AInfo.FSourceType) and
            (AnsiCompareText(AColumn.SourceName, AInfo.FSourceName) = 0) and
            (AColumn.SourceID = AInfo.FSourceID)) then
      ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccMetaInfoMismatch, []);
  end;

  function GetDatSManager: TADDatSManager;
  begin
    if ADatSManager <> nil then
      Result := ADatSManager
    else if ATable <> nil then
      Result := ATable.Manager
    else
      Result := nil;
  end;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekCmdPrepare, esProgress, 'Col add (ref)',
      ['Index', ATable.Columns.Count, 'Name', oCol.SourceName,
       '@Type', C_AD_DataTypeNames[oCol.SourceDataType], 'TypeName',
       oCol.SourceDataTypeName]);
  end;

  procedure Trace2;
  begin
    Trace(ekCmdPrepare, esProgress, 'Col add',
      ['Index', ATable.Columns.Count, 'SrcName', oCol.SourceName,
       '@SrcType', C_AD_DataTypeNames[oCol.SourceDataType],
       'SrcSize', oCol.SourceSize, 'SrcPrec', oCol.SourcePrecision,
       'SrcScale', oCol.SourceScale, '@Type', C_AD_DataTypeNames[oCol.DataType],
       'Size', oCol.Size, 'Prec', oCol.Precision, 'Scale', oCol.Scale,
       'OrigTabName', oCol.OriginTabName, 'OrigColName', oCol.OriginColName]);
  end;

  procedure Trace3;
  begin
    Trace(ekCmdPrepare, esProgress, 'Primary key',
      ['Cols', oPKFieldsView.Rows.GetValuesList('COLUMN_NAME', ';', '')]);
  end;      
{$ENDIF}

begin
  FConnection.CreateMetadata(oConnMeta);
  rName.FCatalog := '';
  rName.FSchema := '';
  rName.FBaseObject := '';
  rName.FLink := '';
  
  eLocalMetaInfoMergeMode := AMetaInfoMergeMode;
  if GetMetaInfoKind <> mkNone then begin
    if eLocalMetaInfoMergeMode <> mmReset then
      ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccMetaInfoReset, []);
    Result := ATable;
    if Result = nil then begin
      Result := TADDatSTable.Create;
      Result.CountRef(0);
      Result.Setup(FOptions);
      Result.Name := oConnMeta.DefineMetadataTableName(GetMetaInfoKind);
      if GetDatSManager <> nil then
        GetDatSManager.Tables.Add(Result);
    end
    else
      Result.Reset;
    oConnMeta.DefineMetadataStructure(Result, GetMetaInfoKind);
    Exit;
  end;

  oFmtOpts := FOptions.FormatOptions;
  oUpdOpts := FOptions.UpdateOptions as TADBottomUpdateOptions;
  if oUpdOpts.UpdateTableName <> '' then
    sTabName := oUpdOpts.UpdateTableName
  else
    sTabName := GetSourceObjectName;
  oROWIDCol := nil;
  oPKFieldsView := nil;
  if (oUpdOpts.KeyFields <> '') or not InternalUseStandardMetadata then begin
    lDefPK := False;
    lPKDefined := False;
  end
  else begin
    lDefPK := (ARootID = -1) and (fiMeta in FOptions.FetchOptions.Items) and (sTabName <> '') and
      not ((sTabName[1] = '(') and (sTabName[Length(sTabName)] = ')')) and
      (Pos('''', sTabName) = 0);
    lPKDefined := False;
  end;
  lNoRowSet := False;
  lTabCreated := False;
  lExtAttrs := False;
  sName := '';
  sFirstOriginTabName := '';
  lOriginUseful := True;
  oCreatedList := TADObjList.Create;
  oOriginCols := TADStringList.Create;
  oOriginCols.Sorted := True;
{$IFDEF AnyDAC_D6}
  oOriginCols.CaseSensitive := False;
{$ENDIF}
  try
    try
      if lDefPK then
        oPKFieldsView := oConnMeta.GetTablePrimaryKeyFields(GetCatalogName,
          GetSchemaName, sTabName, '');
      rTabInfo.FSourceID := ARootID;
      if not InternalColInfoStart(rTabInfo) then begin
        lNoRowSet := True;
        ATable := nil;
      end
      else begin
        if ARootID = -1 then
          rTabInfo.FSourceName := GetSourceRecordSetName
        else
          rTabInfo.FSourceName := ARootName + '.' + rTabInfo.FOriginName;
        ATable := EnsureTabExistance(ADatSManager, rTabInfo.FSourceID,
          rTabInfo.FSourceName, sName, lTabCreated);
        if ATable <> nil then begin
          if (eLocalMetaInfoMergeMode = mmOverride) and lTabCreated then
            eLocalMetaInfoMergeMode := mmReset
          else if (eLocalMetaInfoMergeMode = mmReset) and not lTabCreated then
            ATable.Reset;
          if (eLocalMetaInfoMergeMode <> mmRely) or lTabCreated then begin
            if sName <> '' then
              ATable.Name := sName
            else if GetDatSManager <> nil then
              ATable.Name := GetDatSManager.Tables.BuildUniqueName(rTabInfo.FSourceName)
            else
              ATable.Name := rTabInfo.FSourceName;
            ATable.SourceName := rTabInfo.FSourceName;
            ATable.SourceID := rTabInfo.FSourceID;
            ATable.MinimumCapacity := FOptions.FetchOptions.ActualRowsetSize;
            if (GetDatSManager <> nil) and (ATable.Manager <> GetDatSManager) then begin
              if ATable.Manager <> nil then
                ATable.Manager.Tables.Remove(ATable, True);
              GetDatSManager.Tables.Add(ATable);
            end;
          end;
        end;
      end;
      if ATable <> nil then begin
        ADFillChar(rColInfo, SizeOf(TADPhysDataColumnInfo), 0);
        rColInfo.FParentTableSourceID := ARootID;
        rColInfo.FTableSourceID := rTabInfo.FSourceID;
        while InternalColInfoGet(rColInfo) do begin
          if rColInfo.FSourceName = '' then begin
            Include(rColInfo.FAttrs, caUnnamed);
            rColInfo.FSourceName := S_AD_Unnamed + IntToStr(rColInfo.FSourceID);
          end
          else if StrLIComp(PChar(rColInfo.FSourceName),
                            PChar(C_AD_SysColumnPrefix),
                            Length(C_AD_SysColumnPrefix)) = 0 then begin
            Include(rColInfo.FAttrs, caInternal);
            if not (caROWID in rColInfo.FAttrs) then
              Include(rColInfo.FAttrs, caReadOnly);
            rColInfo.FSourceName := Copy(rColInfo.FSourceName,
              Length(C_AD_SysColumnPrefix) + 1, MAXINT);
            if rColInfo.FOriginColName = '' then
              rColInfo.FOriginColName := rColInfo.FSourceName;
          end;

          lColCreated := False;
          if rColInfo.FType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef] then begin
            if GetDatSManager <> nil then begin
              oChildTab := DoDefineDataTable(GetDatSManager, nil, rColInfo.FSourceID,
                rTabInfo.FSourceName, AMetaInfoMergeMode);
              if oChildTab <> nil then begin
                oCol := EnsureColExistance(ATable, rColInfo.FSourceID,
                  rColInfo.FSourceName, sName, lColCreated);
                if (oCol <> nil) and (eLocalMetaInfoMergeMode <> mmRely) or lColCreated then begin
                  if lColCreated or (oCol.Name = '') then
                    if sName <> '' then
                      oCol.Name := sName
                    else
                      oCol.Name := ATable.Columns.BuildUniqueName(rColInfo.FSourceName);
                  oCol.DataType := rColInfo.FType;
                  oCol.SourceName := rColInfo.FSourceName;
                  oCol.SourceID := rColInfo.FSourceID;
                  oCol.SourceDataType := rColInfo.FSourceType;
                  oCol.SourceDataTypeName := rColInfo.FSourceTypeName;
                  oCol.OriginTabName := oConnMeta.EncodeObjName(rColInfo.FOriginTabName, nil, [eoBeautify]);
                  rName.FObject := rColInfo.FOriginColName;
                  oCol.OriginColName := oConnMeta.EncodeObjName(rName, nil, [eoBeautify]);
                  oCol.Attributes := rColInfo.FAttrs - [caSearchable];
                  oCol.Options := oCol.Options + rColInfo.FForceAddOpts - rColInfo.FForceRemOpts;
                  if lColCreated then
                    ATable.Columns.Add(oCol);
{$IFDEF AnyDAC_MONITOR}
                  if FConnectionObj.GetTracing then Trace1;
{$ENDIF}
                  if lColCreated then begin
                    oChildTabRelCol := TADDatSColumn.Create;
                    oCreatedList.Add(oChildTabRelCol);
                    oChildTabRelCol.Name := oChildTab.Columns.BuildUniqueName(
                      C_AD_SysNamePrefix + '#' + ATable.Name);
                    oChildTabRelCol.DataType := dtParentRowRef;
                    oChildTabRelCol.SourceDataType := dtUnknown;
                    oChildTabRelCol.SourceID := -1;
                    oChildTabRelCol.Attributes := oCol.Attributes + [caInternal] - [caSearchable];
                    oChildTab.Columns.Add(oChildTabRelCol);

                    oRel := TADDatSRelation.Create;
                    oCreatedList.Add(oRel);
                    oRel.Nested := True;
                    oRel.Name := GetDatSManager.Relations.BuildUniqueName(
                      C_AD_SysNamePrefix + '#' + ATable.Name + '#' + oChildTab.Name);
                    oRel.ParentTable := ATable;
                    oRel.ParentColumnNames := oCol.Name;
                    oRel.ChildTable := oChildTab;
                    oRel.ChildColumnNames := oChildTabRelCol.Name;
                    GetDatSManager.Relations.Add(oRel);
                  end;
                end;
              end;
            end;
          end

          else begin
            oCol := EnsureColExistance(ATable, rColInfo.FSourceID,
              rColInfo.FSourceName, sName, lColCreated);
            if (oCol <> nil) and (eLocalMetaInfoMergeMode <> mmRely) or lColCreated then begin
              if lColCreated or (oCol.Name = '') then
                if sName <> '' then
                  oCol.Name := sName
                else
                  oCol.Name := ATable.Columns.BuildUniqueName(rColInfo.FSourceName);
              oCol.SourceName := rColInfo.FSourceName;
              oCol.SourceID := rColInfo.FSourceID;
              oCol.SourceDataType := rColInfo.FSourceType;
              oCol.SourceDataTypeName := rColInfo.FSourceTypeName;
              oCol.SourcePrecision := rColInfo.FPrec;
              oCol.SourceScale := rColInfo.FScale;
              oCol.SourceSize := rColInfo.FLen;
              oCol.OriginTabName := oConnMeta.EncodeObjName(rColInfo.FOriginTabName, nil, [eoBeautify]);
              if sFirstOriginTabName = '' then begin
                sFirstOriginTabName := oCol.OriginTabName;
                if (GetSourceObjectName <> '') and (sFirstOriginTabName <> '') and
                   (oUpdOpts.UpdateTableName = '') then begin
                  oConnMeta.DecodeObjName(GetSourceObjectName, rName1, nil, [doUnquote]);
                  oConnMeta.DecodeObjName(sFirstOriginTabName, rName2, nil, [doUnquote]);
                  if CompareText(rName1.FObject, rName2.FObject) <> 0 then
                    lOriginUseful := False;
                end;
              end;
              rName.FObject := rColInfo.FOriginColName;
              oCol.OriginColName := oConnMeta.EncodeObjName(rName, nil, [eoBeautify]);
              oCol.Attributes := rColInfo.FAttrs;
              if caROWID in oCol.Attributes then
                oROWIDCol := oCol;
              oCol.DataType := rColInfo.FType;
              case oCol.DataType of
              dtAnsiString,
              dtWideString,
              dtByteString:
                if rColInfo.FLen <> LongWord(-1) then
                  oCol.Size := rColInfo.FLen;
              dtSByte,
              dtInt16,
              dtInt32,
              dtInt64,
              dtByte,
              dtUInt16,
              dtUInt32,
              dtUInt64:
                oCol.Precision := rColInfo.FPrec;
              dtSingle,
              dtDouble,
              dtExtended,
              dtCurrency,
              dtBCD,
              dtFmtBCD:
                begin
                  if oFmtOpts.DataSnapCompatibility and (rColInfo.FPrec > 32) then begin
                    if rColInfo.FPrec = rColInfo.FScale then
                      rColInfo.FScale := rColInfo.FPrec div 3;
                    rColInfo.FPrec := 32;
                  end;
                  oCol.Precision := rColInfo.FPrec;
                  oCol.Scale := rColInfo.FScale;
                end;
              dtDateTime,
              dtDateTimeStamp,
              dtTime:
                oCol.Scale := rColInfo.FScale;
              dtTimeIntervalFull,
              dtTimeIntervalYM,
              dtTimeIntervalDS:
                begin
                  oCol.Precision := rColInfo.FPrec;
                  oCol.Scale := rColInfo.FScale;
                end;
              dtUnknown:
                begin
                  oCol.DataType := dtAnsiString;
                  oCol.Size := 1;
                  oCol.Attributes := oCol.Attributes + [caAllowNull, caReadOnly];
                  rColInfo.FForceAddOpts := [coAllowNull, coReadOnly];
                  rColInfo.FForceRemOpts := [coInUpdate, coInWhere, coInKey, coAfterInsChanged, coAfterUpdChanged];
                end;
              end;
              if caDefault in oCol.Attributes then
                Include(rColInfo.FForceAddOpts, coAllowNull);
              oCol.Options := oCol.Options + rColInfo.FForceAddOpts - rColInfo.FForceRemOpts;
              lExtAttrs := lExtAttrs or (oCol.Attributes * [caBase, caExpr] <> []);
              if lColCreated then
                ATable.Columns.Add(oCol);
{$IFDEF AnyDAC_MONITOR}
              if FConnectionObj.GetTracing then Trace2;
{$ENDIF}
            end;
          end;
        end;

        lOriginProvided := lOriginUseful and (oConnMeta.ColumnOriginProvided or (sFirstOriginTabName <> ''));
        lUpdBaseFieldsOnly := lOriginProvided and not oUpdOpts.UpdateNonBaseFields;
        for i := 0 to ATable.Columns.Count - 1 do begin
          oCol := ATable.Columns.ItemsI[i];
          if not lOriginUseful or (oCol.OriginColName = '') then begin
            oCol.OriginTabName := '';
            rName.FObject := oCol.SourceName;
            oCol.OriginColName := oConnMeta.EncodeObjName(rName, nil, [eoBeautify]);
          end;
          if not lExtAttrs then
            if not lOriginProvided then
              oCol.Attributes := oCol.Attributes + [caBase]
            else if (oCol.OriginTabName = '') and not (caBase in oCol.Attributes) then
              oCol.Attributes := oCol.Attributes + [caExpr, caReadOnly]
            else if (oCol.OriginTabName <> '') and (CompareText(sFirstOriginTabName, oCol.OriginTabName) = 0) then
              oCol.Attributes := oCol.Attributes + [caBase];

          // SELECT F1 AS A, F1 AS B -> excluded extra occurences of F1 from updates
          // to avoid "Column Xxx cannot be repeated in UPDATE statement"
          if lUpdBaseFieldsOnly and (caBase in oCol.Attributes) then begin
            if oCol.OriginTabName <> '' then
              sName := oCol.OriginTabName + '.'
            else
              sName := '';
            sName := sName + oCol.OriginColName;
            if sName <> '' then begin
              if oOriginCols.IndexOf(sName) >= 0 then
                oCol.Options := oCol.Options - [coInUpdate, coInWhere, coInKey] +
                  [coAfterInsChanged, coAfterUpdChanged];
              oOriginCols.Add(sName);
            end;
          end;

          // Server side calculated fields has to be excluded from updates
          if [caCalculated, caReadOnly] * oCol.Attributes = [caCalculated, caReadOnly] then
            oCol.Options := oCol.Options - [coInUpdate, coInWhere, coInKey] +
              [coReadOnly, coAfterInsChanged, coAfterUpdChanged];

          // Set key fields and auto-inc fields only for base fields
          if not lUpdBaseFieldsOnly or (caBase in oCol.Attributes) then begin
            if oUpdOpts.KeyFields <> '' then
              if ADFieldInFieldNames(oUpdOpts.KeyFields, oCol.SourceName) then
                oCol.Options := oCol.Options + [coInKey]
              else
                oCol.Options := oCol.Options - [coInKey];
            if coInKey in oCol.Options then
              lPKDefined := True;

            if caAutoInc in oCol.Attributes then
              oCol.ServerAutoIncrement := True
            else if (oUpdOpts.AutoIncFields <> '') and
                    ADFieldInFieldNames(oUpdOpts.AutoIncFields, oCol.SourceName) then begin
              lInUpdate := coInUpdate in oCol.Options;
              oCol.ServerAutoIncrement := True;
              if oConnMeta.GeneratorSupported and lInUpdate then
                oCol.Options := oCol.Options + [coInUpdate];
            end;
          end;

          // Exclude non-base fields from editing
          if [caROWID, caRowVersion, caInternal, caCalculated, caBase] * oCol.Attributes = [] then begin
            if lUpdBaseFieldsOnly then begin
              oCol.Attributes := oCol.Attributes - [caAutoInc];
              oCol.Options := oCol.Options - [coInUpdate, coInWhere, coInKey] +
                [coReadOnly, coAllowNull];
            end
            else if not lExtAttrs and (caExpr in oCol.Attributes) then
              oCol.Options := oCol.Options - [coReadOnly];

            if lOriginProvided then
              oCol.Options := oCol.Options - [coInKey];
            oCol.Options := oCol.Options + [coAfterInsChanged, coAfterUpdChanged];
          end;
        end;

        if lDefPK and not lPKDefined then begin
{$IFDEF AnyDAC_MONITOR}
          if FConnectionObj.GetTracing then Trace3;
{$ENDIF}
          for i := 0 to oPKFieldsView.Rows.Count - 1 do begin
            j := ATable.Columns.IndexOfName(oPKFieldsView.Rows.ItemsI[i].GetData('COLUMN_NAME'));
            if j <> -1 then begin
              oCol := ATable.Columns.ItemsI[j];
              oCol.Options := oCol.Options + [coInKey];
              lPKDefined := True;
            end;
          end;
        end;
        if not lPKDefined and (oROWIDCol <> nil) then
          oROWIDCol.Options := oROWIDCol.Options + [coInKey];

      end;
    except
      for i := oCreatedList.Count - 1 downto 0 do
        ADFree(TObject(oCreatedList[i]));
      raise;
    end;
  finally
    if (oPKFieldsView <> nil) and (FConnection.State <> csDisconnected) then
      ADClearMetaView(oPKFieldsView, FOptions.FetchOptions);
    ADFree(oCreatedList);
    ADFree(oOriginCols);
  end;
  Result := ATable;
  if lNoRowSet then
    ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccCmdMHRowSet, []);
end;
{$IFNDEF AnyDAC_D12}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.BeginDefine;
begin
  CheckAsyncProgress;
  if GetState = csInactive then
    Prepare;
  if GetState = csInactive then
    ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccCmdMBPrepared, []);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.Define(ADatSManager: TADDatSManager;
  ATable: TADDatSTable; AMetaInfoMergeMode: TADPhysMetaInfoMergeMode): TADDatSTable;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  var
    sTabName: String;
  begin
    if ATable <> nil then sTabName := ATable.Name else sTabName := '<nil>';
    Trace(ekCmdPrepare, esStart, 'Define(TADDatSManager)',
      ['ADatSManager', ADatSManager.Name, 'ATable', sTabName, 'Command', GetTraceCommandText]);
  end;

  procedure Trace2;
  var
    sTabName: String;
  begin
    if ATable <> nil then sTabName := ATable.Name else sTabName := '<nil>';
    Trace(ekCmdPrepare, esEnd, 'Define(TADDatSManager)',
      ['ADatSManager', ADatSManager.Name, 'ATable', sTabName, 'Command', GetTraceCommandText]);
  end;
var
  lUpdateMonitor: Boolean;
{$ENDIF}

begin
{$IFDEF AnyDAC_MONITOR}
  if EnterTrace(FConnectionObj) then Trace1;
  try
{$ENDIF}
    BeginDefine;
    if AMetaInfoMergeMode = mmReset then begin
      if GetMetaInfoKind = mkNone then begin
        if ATable <> nil then
          ATable.Reset;
        AMetaInfoMergeMode := mmOverride;
      end
      else if ADatSManager <> nil then
        ADatSManager.Reset;
    end;
    Result := DoDefineDataTable(ADatSManager, ATable, -1, '', AMetaInfoMergeMode);
{$IFDEF AnyDAC_MONITOR}
  finally
    if ExitTrace(FConnectionObj, lUpdateMonitor) then Trace2;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.Define(ATable: TADDatSTable;
  AMetaInfoMergeMode: TADPhysMetaInfoMergeMode): TADDatSTable;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  var
    sTabName: String;
  begin
    if ATable <> nil then sTabName := ATable.Name else sTabName := '<nil>';
    Trace(ekCmdPrepare, esStart, 'Define(TADDatSTable)',
      ['ATable', sTabName, 'Command', GetTraceCommandText]);
  end;

  procedure Trace2;
  var
    sTabName: String;
  begin
    if ATable <> nil then sTabName := ATable.Name else sTabName := '<nil>';
    Trace(ekCmdPrepare, esEnd, 'Define(TADDatSTable)',
      ['ATable', sTabName, 'Command', GetTraceCommandText]);
  end;
var
  lUpdateMonitor: Boolean;
{$ENDIF}

begin
{$IFDEF AnyDAC_MONITOR}
  if EnterTrace(FConnectionObj) then Trace1;
  try
{$ENDIF}
    BeginDefine;
    Result := DoDefineDataTable(nil, ATable, -1, '', AMetaInfoMergeMode);
{$IFDEF AnyDAC_MONITOR}
  finally
    if ExitTrace(FConnectionObj, lUpdateMonitor) then Trace2;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
// Executing

type
  TADPhysCommandAsyncExecute = class(TADPhysCommandAsyncOperation)
  private
    FTimes: Integer;
    FOffset: Integer;
  protected
    // IADStanAsyncOperation
    procedure Execute; override;
  public
    constructor Create(ACmd: TADPhysCommand; ATimes: Integer; AOffset: Integer);
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysCommandAsyncExecute.Create(ACmd: TADPhysCommand;
  ATimes: Integer; AOffset: Integer);
begin
  inherited Create(ACmd);
  FTimes := ATimes;
  FOffset := AOffset;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandAsyncExecute.Execute;
begin
  FCommand.ExecuteBase(FTimes, FOffset);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CheckExact(AUseRecsMax: Boolean; ATimes, AOffset: LongInt;
  AValue: TADCounter; AFetch: Boolean);

  procedure Error;
  var
    sPref, sMsg, sOper: String;
    eKind: TADCommandExceptionKind;
    oExc: EADDBEngineException;
  begin
    if AFetch then
      sOper := 'fetch returned'
    else
      sOper := 'update affected';
    sPref := ADExceptionLayers([S_AD_LPhys, DriverID]) + '-' +
      IntToStr(er_AD_AccExactMismatch) + '. ';
    sMsg := Format(ADGetErrorMessage(er_AD_AccExactMismatch, []),
      [sOper, AValue, ATimes - AOffset]);
    if AValue < ATimes - AOffset then
      eKind := ekNoDataFound
    else
      eKind := ekTooManyRows;
    oExc := EADDBEngineException.Create(er_AD_AccExactMismatch, sPref + sMsg);
    oExc.AppendError(1, er_AD_AccExactMismatch, sMsg, '', eKind, -1, -1);
    ADException(Self, oExc {$IFDEF AnyDAC_Monitor}, FConnectionObj.GetTracing {$ENDIF});
  end;

var
  oFO: TADFetchOptions;
begin
  oFO := FOptions.FetchOptions;
  if oFO.Mode = fmExactRecsMax then begin
    if AUseRecsMax then begin
      AOffset := 0;
      ATimes := oFO.RecsMax;
    end;
    if (AValue <> ATimes - AOffset) and
       (AValue >= 0) and (ATimes - AOffset >= 0) then
      Error;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.ExecuteBase(ATimes, AOffset: LongInt);
var
  eMode: TADPhysArrayExecMode;
  lSavepoint: Boolean;
  i: Integer;
{$IFDEF AnyDAC_MONITOR}
  lUpdateMonitor: Boolean;
{$ENDIF}

  procedure SetMeta;
  var
    oConnMeta: IADPhysConnectionMetadata;
  begin
    FConnection.CreateMetadata(oConnMeta);
    eMode := oConnMeta.ArrayExecMode;
    lSavepoint := (FTransactionObj <> nil) and FTransactionObj.GetActive and
      oConnMeta.TxAtomic and (oConnMeta.TxNested or oConnMeta.TxSavepoints);
    oConnMeta := nil;
  end;

  procedure UpdRes(AValue: TADCounter);
  begin
    if AValue <= -1 then
      FRowsAffected := -1
    else if FRowsAffected >= 0 then begin
      Inc(FRowsAffected, AValue);
      Inc(FExecuteCount, AValue);
    end;
  end;

  function Process_HandleSystemFailure(ATimes, AOffset: LongInt; out ACount: TADCounter;
    AArrayDML: Boolean): Boolean;
  var
    lExecuted: Boolean;
  begin
    Result := True;
    FErrorAction := eaExitSuccess;
    lExecuted := False;
    repeat
      ACount := 0;
      if lSavepoint then
        FTransactionObj.StartTransaction;
      try
        InternalExecute(ATimes, AOffset, ACount);
        CheckExact(not AArrayDML, ATimes, AOffset, ACount, False);
        lExecuted := True;
        if lSavepoint then
          FTransactionObj.Commit;
      except
        on E: EADDBEngineException do begin
          if lSavepoint then
            FTransactionObj.Rollback;
          case E.Kind of
          ekServerGone:
            begin
              lSavepoint := False;
              FConnectionObj.RecoverConnection(Self, False);
            end;
          ekArrExecMalfunc:
            begin
              Result := False;
              Exit;
            end;
          else
            raise;
          end;
        end;
      end;
    until lExecuted;
    UpdRes(ACount);
  end;

  procedure Process_SingleRow;
  var
    iCount: TADCounter;
    iRetryLevel: LongInt;
    oErr: Exception;
  begin
    iRetryLevel := 0;
    repeat
      try
        Process_HandleSystemFailure(1, 0, iCount, False);
      except
        on E: EADDBEngineException do begin
          UpdRes(iCount);
          FErrorAction := eaFail;
          if Assigned(GetErrorHandler()) then begin
            Inc(iRetryLevel);
            oErr := EADDBArrayExecuteError.Create(1, 0, E, iRetryLevel);
            try
              GetErrorHandler().HandleException(nil, oErr);
              if oErr <> nil then
                FErrorAction := EADDBArrayExecuteError(oErr).Action;
            finally
              ADFree(oErr);
            end;
          end;
          case FErrorAction of
          eaApplied,
          eaSkip:
            FErrorAction := eaExitSuccess;
          eaRetry:
            ;
          eaFail,
          eaDefault:
            raise;
          end;
        end;
      end;
    until FErrorAction in [eaExitSuccess, eaExitFailure];
  end;

  procedure Process_UntilFirstError(AUndoAll: Boolean);
  var
    iCount: TADCounter;
    iLastTimes, iLastOffset, iRetryLevel: LongInt;
    iCurTimes, iCurOffset, iArraySize: LongInt;
    oErr: Exception;
  begin
    iLastTimes := 0;
    iLastOffset := 0;
    iRetryLevel := 0;
    iArraySize := FOptions.ResourceOptions.ArrayDMLSize;
    if iArraySize > ATimes - AOffset then
      iArraySize := ATimes - AOffset;
    iCurOffset := AOffset;
    iCurTimes := AOffset + iArraySize;
    repeat
      try
        while iCurOffset < ATimes do begin
          if iCurTimes > ATimes then
            iCurTimes := ATimes;
          if not Process_HandleSystemFailure(iCurTimes, iCurOffset, iCount, True) then begin
            iArraySize := 1;
            iCurTimes := iCurOffset + 1;
            FErrorAction := eaRetry;
            Continue;
          end;
          Inc(iCurOffset, iArraySize);
          Inc(iCurTimes, iArraySize);
        end;
      except
        on E: EADDBEngineException do begin
          UpdRes(iCount);
          iCurOffset := iCurOffset + Integer(iCount);
          if AUndoAll and (iArraySize > 1) then begin
            iArraySize := 1;
            iCurTimes := iCurOffset + 1;
            FErrorAction := eaRetry;
            Continue;
          end;
          FErrorAction := eaFail;
          if Assigned(GetErrorHandler()) then begin
            if (iLastTimes = iCurTimes) and (iLastOffset = iCurOffset) then
              Inc(iRetryLevel)
            else begin
              iLastTimes := iCurTimes;
              iLastOffset := iCurOffset;
              iRetryLevel := 0;
            end;
            oErr := EADDBArrayExecuteError.Create(iCurTimes, iCurOffset, E, iRetryLevel);
            try
              GetErrorHandler().HandleException(nil, oErr);
              if oErr <> nil then
                FErrorAction := EADDBArrayExecuteError(oErr).Action;
            finally
              ADFree(oErr);
            end;
          end;
          case FErrorAction of
          eaApplied,
          eaSkip:
            begin
              Inc(iCurOffset);
              if iCurOffset >= iCurTimes then
                Inc(iCurTimes, iArraySize);
              if FErrorAction = eaApplied then
                if FRowsAffected >= 0 then
                  Inc(FRowsAffected);
            end;
          eaRetry:
            ;
          eaFail,
          eaDefault:
            raise;
          end;
        end;
      end;
      if (iCurOffset >= ATimes) and (FErrorAction <> eaExitFailure) then
        FErrorAction := eaExitSuccess;
    until FErrorAction in [eaExitSuccess, eaExitFailure];
  end;

  procedure RemoveCurrentRowErrors(E: EADDBEngineException; ACurRow: Integer);
  begin
    repeat
      ADFree(E[0]);
      E.Remove(E[0]);
    until (E.ErrorCount = 0) or (ACurRow <> E[0].RowIndex);
  end;

  procedure Process_CollectErrors;
  var
    iCount: TADCounter;
    iLastTimes, iLastOffset, iRetryLevel: LongInt;
    iCurTimes, iCurOffset, iArraySize: LongInt;
    oErr: Exception;
  begin
    iLastTimes := 0;
    iLastOffset := 0;
    iRetryLevel := 0;
    iArraySize := FOptions.ResourceOptions.ArrayDMLSize;
    if iArraySize > ATimes - AOffset then
      iArraySize := ATimes - AOffset;
    iCurOffset := AOffset;
    iCurTimes := AOffset + iArraySize;
    while iCurOffset < ATimes do begin
      if iCurTimes > ATimes then
        iCurTimes := ATimes;
      try
        if not Process_HandleSystemFailure(iCurTimes, iCurOffset, iCount, True) then begin
          iArraySize := 1;
          iCurTimes := iCurOffset + 1;
          FErrorAction := eaRetry;
          Continue;
        end;
      except
        on E: EADDBEngineException do begin
          UpdRes(iCount);
          repeat
            FErrorAction := eaFail;
            AOffset := E[0].RowIndex;
            if Assigned(GetErrorHandler()) then begin
              if (iLastTimes = ATimes) and (iLastOffset = AOffset) then
                Inc(iRetryLevel)
              else begin
                iLastTimes := ATimes;
                iLastOffset := AOffset;
                iRetryLevel := 0;
              end;
              oErr := EADDBArrayExecuteError.Create(ATimes, AOffset, E, iRetryLevel);
              try
                GetErrorHandler().HandleException(nil, oErr);
                if oErr <> nil then
                  FErrorAction := EADDBArrayExecuteError(oErr).Action;
              finally
                ADFree(oErr);
              end;
            end;
            case FErrorAction of
            eaApplied,
            eaSkip:
              begin
                RemoveCurrentRowErrors(E, AOffset);
                if FErrorAction = eaApplied then
                  if FRowsAffected >= 0 then
                    Inc(FRowsAffected);
              end;
            eaRetry:
              try
                try
                  InternalExecute(AOffset + 1, AOffset, iCount);
                  CheckExact(False, AOffset + 1, AOffset, iCount, False);
                finally
                  UpdRes(iCount);
                  RemoveCurrentRowErrors(E, AOffset);
                end;
              except
                on E2: EADDBEngineException do begin
                  E.Merge(E2, 0);
                  FErrorAction := eaRetry;
                end;
              end;
            eaFail,
            eaDefault:
              raise;
            end;
            if (E.ErrorCount = 0) and (FErrorAction <> eaExitFailure) then
              FErrorAction := eaExitSuccess;
          until (E.ErrorCount = 0) or (FErrorAction in [eaExitSuccess, eaExitFailure]);
        end;
      end;
      Inc(iCurOffset, iArraySize);
      Inc(iCurTimes, iArraySize);
    end;
  end;

  procedure MBPrepared;
  begin
    ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccCmdMBPrepared, []);
  end;

  procedure CantExec;
  begin
    ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccCantExecCmdWithRowSet, []);
  end;

  procedure ParamArrMismatch(AParam: TADParam);
  begin
    ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccParamArrayMismatch,
      [AParam.Name, AParam.ArraySize, ATimes]);
  end;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekCmdExecute, esStart, 'Execute', ['Command', GetTraceCommandText,
      'ATimes', ATimes, 'AOffset', AOffset]);
  end;

  procedure Trace2(AUpdateMonitor: Boolean);
  begin
    if AUpdateMonitor then UpdateMonitor;
    Trace(ekCmdExecute, esEnd, 'Execute', ['Command', GetTraceCommandText,
      'ATimes', ATimes, 'AOffset', AOffset, 'RowsAffected', FRowsAffected,
      'RowsAffectedReal', FRowsAffectedReal, 'ErrorAction', Integer(FErrorAction)]);
  end;
{$ENDIF}

begin
  if GetState = csAborting then begin
    FState := csPrepared;
    Exit;
  end;

{$IFDEF AnyDAC_MONITOR}
  if EnterTrace(FConnectionObj) then Trace1;
  try
{$ENDIF}
    FRowsAffected := 0;
    FRowsAffectedReal := True;
    FErrorAction := eaExitFailure;
    if not GetNextRecordSet then
      FConnectionObj.SaveLastAutoGenValue(Null);

    CheckAsyncProgress;
    if GetState = csInactive then
      Prepare;
    if GetState <> csPrepared then
      MBPrepared;
    if (GetCommandKind in [skSelect, skSelectForLock, skSelectForUnLock]) or
       (GetMetaInfoKind <> mkNone) then
      CantExec;
    for i := 0 to GetParams.Count - 1 do
      if GetParams[i].ArraySize < ATimes then
        ParamArrMismatch(GetParams[i]);

    FErrorAction := eaExitSuccess;
    if ATimes <= 0 then
      ATimes := 1;
    if AOffset < 0 then
      AOffset := 0;
    if AOffset >= ATimes then
      Exit;
    lSavepoint := False;
    FState := csExecuting;
    FThreadID := GetCurrentThreadId();
    FExecutor.Launched;
    try

      try
        FTransactionObj.Notify(cpBeforeCmdExecute, Self);
        if (ATimes = 1) and (AOffset = 0) then
          Process_SingleRow
        else begin
          SetMeta;
          case eMode of
          aeOnErrorUndoAll:
            Process_UntilFirstError(True);
          aeUpToFirstError:
            Process_UntilFirstError(False);
          aeCollectAllErrors:
            Process_CollectErrors;
          aeNotSupported:
            if (ATimes <> 1) or (AOffset <> 0) then
              ADCapabilityNotSupported(Self, [S_AD_LPhys, DriverID])
            else
              Process_UntilFirstError(False);
          end;
        end;

      except
        FTransactionObj.Notify(cpAfterCmdExecuteFailure, Self);
        raise;
      end;
      case FErrorAction of
      eaExitSuccess:
        FTransactionObj.Notify(cpAfterCmdExecuteSuccess, Self);
      eaExitFailure:
        FTransactionObj.Notify(cpAfterCmdExecuteFailure, Self);
      else
        ASSERT(False);
      end;

    finally
      if GetState <> csInactive then
        FState := csPrepared;
      if FRowsAffected = -1 then begin
        FRowsAffectedReal := False;
        FRowsAffected := 0;
      end;
      FThreadID := 0;
    end;

{$IFDEF AnyDAC_MONITOR}
  finally
    if ExitTrace(FConnectionObj, lUpdateMonitor) then Trace2(lUpdateMonitor);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Execute(ATimes: Integer = 0; AOffset: Integer = 0;
  ABlocked: Boolean = False);
var
  oOper: IADStanAsyncOperation;
begin
  oOper := TADPhysCommandAsyncExecute.Create(Self, ATimes, AOffset) as IADStanAsyncOperation;
  ExecuteTask(oOper, GetStateHandler, ABlocked);
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetErrorAction: TADErrorAction;
begin
  Result := FErrorAction;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetRowsAffected: TADCounter;
begin
  Result := FRowsAffected;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetRowsAffectedReal: Boolean;
begin
  Result := FRowsAffectedReal;
end;

{-------------------------------------------------------------------------------}
// Fetching

type
  TADPhysCommandAsyncFetch = class(TADPhysCommandAsyncOperation, IADStanAsyncHandler)
  private
    FTable: TADDatSTable;
    FAll: Boolean;
  protected
    // IADStanAsyncOperation
    procedure Execute; override;
    // IADStanAsyncHandler
    procedure HandleFinished(const AInitiator: IADStanObject;
      AState: TADStanAsyncState; AException: Exception);
  public
    constructor Create(ACmd: TADPhysCommand; ATable: TADDatSTable; AAll: Boolean);
  end;

{-------------------------------------------------------------------------------}
constructor TADPhysCommandAsyncFetch.Create(ACmd: TADPhysCommand;
  ATable: TADDatSTable; AAll: Boolean);
begin
  inherited Create(ACmd);
  FTable := ATable;
  FAll := AAll;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandAsyncFetch.Execute;
begin
  FCommand.FetchBase(FTable, FAll);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommandAsyncFetch.HandleFinished(const AInitiator: IADStanObject;
  AState: TADStanAsyncState; AException: Exception);

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    FCommand.Trace(ekCmdExecute, esProgress, 'Eof reached',
      ['ATable', FTable.SourceName, 'Command', FCommand.GetTraceCommandText]);
  end;
{$ENDIF}

var
  oHnlr: IADPhysCommandStateHandler;
begin
  // StartTransaction calls FConnectionObj.Lock and on MSSQL calls Fetch(True).
  // On Eof the command is closing. That calls TADPhysTransaction.InternalNotify,
  // which is calling FConnectionObj.Lock. With async fetching that leads to
  // deadlock, so call Close in the calling thread.
  oHnlr := FCommand.GetStateHandler;
  if FCommand.FEof then begin
{$IFDEF AnyDAC_MONITOR}
    if FCommand.FConnectionObj.GetTracing then Trace1;
{$ENDIF}
    if FCommand.FOptions.FetchOptions.AutoClose then
      FCommand.Close;
  end;
  if oHnlr <> nil then
    oHnlr.HandleFinished(AInitiator, AState, AException);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.FetchBase(ATable: TADDatSTable; AAll: Boolean);

  function DoFetch(ARowsSkip, ARowsCount, ARowsetSize: Integer; AMaxLimited: Boolean): Integer;
  var
    iLastFetch, iThrowRows: Integer;
  begin
    Result := 0;
    repeat
      iLastFetch := 0;
      if FRecordsFetched + ARowsetSize > ARowsCount then
        ARowsetSize := ARowsCount - FRecordsFetched;
      if ARowsetSize > 0 then begin
        try
          iLastFetch := InternalFetchRowSet(ATable, nil, ARowsetSize);
        except
          on E: EADDBEngineException do
            if E.Kind = ekServerGone then
              FConnectionObj.RecoverConnection(Self, False)
            else
              raise;
        end;
        if ARowsSkip > 0 then begin
          if ARowsSkip >= iLastFetch then
            iThrowRows := iLastFetch
          else
            iThrowRows := ARowsSkip;
          Inc(FRecordsFetched, iLastFetch - iThrowRows);
          Inc(Result, iLastFetch - iThrowRows);
          Dec(ARowsSkip, iThrowRows);
          while iThrowRows > 0 do begin
            ATable.Rows.RemoveAt(0);
            Dec(iThrowRows);
          end;
        end
        else begin
          Inc(FRecordsFetched, iLastFetch);
          Inc(Result, iLastFetch);
        end;
      end;
    until (FState <> csFetching) or (iLastFetch <> ARowsetSize) or (FRecordsFetched >= ARowsCount);
    FEof := (iLastFetch <> ARowsetSize) or AMaxLimited and (FRecordsFetched >= ARowsCount);
  end;

{$IFDEF AnyDAC_MONITOR}
  procedure Trace1;
  begin
    Trace(ekCmdExecute, esStart, 'Fetch',
      ['ATable', ATable.SourceName, 'Command', GetTraceCommandText]);
  end;

  procedure Trace2(AUpdateMonitor: Boolean);
  begin
    if AUpdateMonitor then UpdateMonitor;
    Trace(ekCmdExecute, esEnd, 'Fetch',
      ['ATable', ATable.SourceName, 'Command', GetTraceCommandText,
       'RowsAffected', FRowsAffected]);
  end;
{$ENDIF}

var
  oFO: TADFetchOptions;
  eMode: TADFetchMode;
  iRowsetSize, iRecsSkip, iRecsMax: Integer;
  rState: TADDatSLoadState;
  lErase: Boolean;
  oConnMeta: IADPhysConnectionMetadata;
{$IFDEF AnyDAC_MONITOR}
  lUpdateMonitor: Boolean;
{$ENDIF}
begin
  if GetState = csAborting then begin
    FState := csOpen;
    Exit;
  end;

{$IFDEF AnyDAC_MONITOR}
  if EnterTrace(FConnectionObj) then Trace1;
  try
{$ENDIF}
    FRowsAffected := 0;
    if FEof then
      Exit;

    ASSERT(ATable <> nil);
    CheckAsyncProgress;
    if GetState <> csOpen then
      ADException(Self, [S_AD_LPhys, DriverID], er_AD_AccCmdMBOpen4Fetch, []);

    FState := csFetching;
    FThreadID := GetCurrentThreadId();
    FExecutor.Launched;

    oFO := FOptions.FetchOptions;
    if not FFirstFetch and not AAll then
      eMode := fmOnDemand
    else if AAll then
      eMode := fmAll
    else
      eMode := oFO.Mode;
    iRowsetSize := oFO.ActualRowsetSize;
    iRecsSkip := 0;
    if FFirstFetch then begin
      FConnection.CreateMetadata(oConnMeta);
      if not (loSkip in oConnMeta.LimitOptions) or (GetCommandKind <> skSelect) then
        if FSQLLimitSkip >= 0 then
          iRecsSkip := FSQLLimitSkip
        else
          iRecsSkip := oFO.RecsSkip;
    end;
    iRecsMax := oFO.RecsMax;
    lErase := False;

    if eMode in [fmAll, fmExactRecsMax] then
      ATable.BeginLoadData(rState, lmHavyFetching)
    else
      ATable.BeginLoadData(rState, lmFetching);
    try
      try
        case eMode of
        fmAll:
          if iRecsMax > 0 then
            FRowsAffected := DoFetch(iRecsSkip, iRecsMax, iRowsetSize, True)
          else
            FRowsAffected := DoFetch(iRecsSkip, MAXINT, iRowsetSize, False);
        fmExactRecsMax:
          begin
            FRowsAffected := DoFetch(iRecsSkip, iRowsetSize + 1, iRowsetSize, True);
            if FRowsAffected <> iRowsetSize then begin
              lErase := (FRowsAffected = ATable.Rows.Count);
              CheckExact(False, iRowsetSize, 0, FRowsAffected, True);
            end;
          end;
        fmManual, fmOnDemand:
          if (iRecsMax > 0) and (FRecordsFetched + iRowsetSize > iRecsMax) then
            FRowsAffected := DoFetch(iRecsSkip, iRecsMax, iRowsetSize, True)
          else
            FRowsAffected := DoFetch(iRecsSkip, FRecordsFetched + iRowsetSize, iRowsetSize, False);
        end;
      finally
        // If command is part of TADQuery, the connection is lost,
        // then query will be closed and ATable destroyed.
        if ATable.DataHandleMode <> lmDestroying then
          ATable.EndLoadData(rState);
      end;
    finally
      FThreadID := 0;
      FFirstFetch := False;
      if GetState <> csInactive then
        case FState of
        csFetching:
          FState := csOpen;
        csAborting:
          begin
            FState := csOpen;
            FEof := True;
          end;
        end;
      if lErase then begin
        FRowsAffected := 0;
        ATable.Clear;
      end;
    end;
{$IFDEF AnyDAC_MONITOR}
  finally
    if ExitTrace(FConnectionObj, lUpdateMonitor) then Trace2(lUpdateMonitor);
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Fetch(ATable: TADDatSTable; AAll: Boolean = True;
  ABlocked: Boolean = False);
var
  oFetch: TADPhysCommandAsyncFetch;
begin
  oFetch := TADPhysCommandAsyncFetch.Create(Self, ATable, AAll);
  ExecuteTask(oFetch as IADStanAsyncOperation, oFetch as IADStanAsyncHandler, ABlocked);
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.Fetch(ADatSManager: TADDatSManager;
  AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset);
var
  eMode: TADPhysMetaInfoMergeMode;
  oTab: TADDatSTable;
  iRows: Integer;
begin
  iRows := 0;
  try
    CheckAsyncProgress;
    if GetState = csInactive then
      Prepare;
    eMode := AMetaInfoMergeMode;
    if eMode = mmReset then begin
      ADatSManager.Reset;
      eMode := mmOverride;
    end;
    while True do begin
      if GetState = csPrepared then
        OpenBlocked;
      if GetState <> csOpen then
        Break;
      oTab := Define(ADatSManager, nil, eMode);
      Fetch(oTab, True, True);
      Inc(iRows, FRowsAffected);
      SetNextRecordSet(True);
    end;
    if (GetState = csOpen) and FOptions.FetchOptions.AutoClose then
      Close;
  finally
    FRowsAffected := iRows;
  end;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.CheckFetchColumn(ADataType: TADDataType;
  AAttributes: TADDataAttributes): Boolean;
begin
  Result := (ADataType <> dtUnknown) and not (
   (ADataType in [dtRowSetRef, dtCursorRef]) and
    not (fiDetails in FOptions.FetchOptions.Items) or
   (caBlobData in AAttributes) and
    not (fiBlobs in FOptions.FetchOptions.Items)
  );
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.CheckParamMatching(AParam: TADParam;
  ADataType: TFieldType; AParamType: TParamType; APrec: Integer);
begin
  if not ((AParamType = AParam.ParamType) or
          (ptUnknown = AParam.ParamType) and (AParamType = ptInput)) or
     not ((ADataType = AParam.DataType) or
          (ADataType in [ftFmtMemo {$IFDEF AnyDAC_WideMemo}, ftWideMemo {$ENDIF}]) and
            (AParam.DataType in [ftFmtMemo {$IFDEF AnyDAC_WideMemo}, ftWideMemo {$ENDIF}]) or
          (ADataType in [ftInteger, ftAutoInc {$IFDEF AnyDAC_D12}, ftLongWord {$ENDIF}]) and
            (AParam.DataType in [ftInteger, ftAutoInc {$IFDEF AnyDAC_D12}, ftLongWord {$ENDIF}]) or
          (ADataType in [ftParadoxOle {$IFDEF AnyDAC_D10}, ftOraInterval {$ENDIF}]) and
            (AParam.DataType in [ftParadoxOle {$IFDEF AnyDAC_D10}, ftOraInterval {$ENDIF}])) or
     not ((APrec = 0) or (APrec = AParam.Precision)) then
    ParDefChangedError(ADataType, AParam);
end;

{-------------------------------------------------------------------------------}
// IADStanObject

function TADPhysCommand.GetName: TComponentName;
begin
  Result := FMoniAdapterHelper.Name;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetParent: IADStanObject;
begin
  Result := FMoniAdapterHelper.Parent;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  FMoniAdapterHelper.SetOwner(AOwner, ARole);
{$IFDEF AnyDAC_MONITOR}
  FMoniAdapterHelper.UnRegisterClient;
  FMoniAdapterHelper.RegisterClient(FConnectionObj.GetMonitor);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.AfterReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.BeforeReuse;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
// IADMoniAdapter

function TADPhysCommand.GetHandle: LongWord;
begin
  if FMoniAdapterHelper = nil then
    Result := 0
  else
    Result := FMoniAdapterHelper.Handle;
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetSupportItems: TADMoniAdapterItemKinds;
begin
  Result := [ikStat, ikSQL, ikParam];
end;

{-------------------------------------------------------------------------------}
function TADPhysCommand.GetItemCount: Integer;
begin
  Result := 5 + GetParams.Count + GetMacros.Count;
end;

{-------------------------------------------------------------------------------}
procedure TADPhysCommand.GetItem(AIndex: Integer; out AName: String;
  out AValue: Variant; out AKind: TADMoniAdapterItemKind);
const
  C_States: array [TADPhysCommandState] of String = ('Inactive', 'Prepared',
    'Executing', 'Open', 'Fetching', 'Aborting');
var
  oPar: TADParam;
  oMac: TADMacro;
begin
  case AIndex of
  0:
    begin
      AName := 'ExecuteCount';
      AValue := FExecuteCount;
      AKind := ikStat;
    end;
  1:
    begin
      AName := 'RowsAffected';
      AValue := FRowsAffected;
      AKind := ikStat;
    end;
  2:
    begin
      AName := 'RecordsFetched';
      AValue := FRecordsFetched;
      AKind := ikStat;
    end;
  3:
    begin
      AName := 'Status';
      AValue := C_States[GetState];
      if (GetState = csOpen) and FEof then
        AValue := AValue + ', Eof';
      AKind := ikStat;
    end;
  4:
    begin
      AName := '@CommandText';
      AValue := GetTraceCommandText;
      AKind := ikSQL;
    end;
  else
    if AIndex - 5 < GetParams.Count then begin
      oPar := GetParams[AIndex - 5];
      AName := oPar.Name;
      if (oPar.ArrayType <> atScalar) then
        AValue := '<array>'
      else
        AValue := oPar.Value;
      AKind := ikParam;
    end
    else begin
      oMac := GetMacros[AIndex - 5 - GetParams.Count];
      AName := oMac.Name;
      AValue := oMac.Value;
      AKind := ikParam;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
procedure TADPhysCommand.UpdateMonitor;
begin
  if FConnection.Tracing then
    FConnection.Monitor.AdapterChanged(Self);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
initialization
  TADSingletonFactory.Create(TADPhysManager, IADPhysManager);

end.
