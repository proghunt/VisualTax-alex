{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{              FireDAC physical layer API               }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADPhysIntf;

interface

uses
  Classes, SysUtils,
  uADStanIntf, uADStanOption, uADStanParam, uADStanError, uADStanConst,
  uADDatSManager,
  uADGUIxIntf;

type
  IADPhysManagerMetadata = interface;
  IADPhysManager = interface;
  IADPhysDriverMetadata = interface;
  IADPhysDriverConnectionWizard = interface;
  IADPhysDriver = interface;
  IADPhysConnectionMetadata = interface;
  IADPhysConnectionRecoveryHandler = interface;
  IADPhysConnection = interface;
  IADPhysTransactionStateHandler = interface;
  IADPhysTransaction = interface;
  IADPhysCommandStateHandler = interface;
  IADPhysCommandGenerator = interface;
  IADPhysMappingHandler = interface;
  IADPhysCommand = interface;
  IADPhysMetaInfoCommand = interface;
  IADPhysEventHandler = interface;
  IADPhysEventAlerter = interface;
  IADPhysLocalQueryAdapter = interface;

  TADPhysCommandKind = (skUnknown, skSelect, skSelectForLock, skSelectForUnLock,
    skDelete, skInsert, skMerge, skUpdate, skCreate, skAlter, skDrop, skStoredProc,
    skStoredProcWithCrs, skStoredProcNoCrs, skExecute, skStartTransaction,
    skCommit, skRollback, skSet, skSetSchema, skOther, skNotResolved);

  TADPhysEscapeKind = (eskText, eskString, eskFloat, eskDate, eskTime, eskDateTime,
    eskIdentifier, eskBoolean, eskFunction, eskIF, eskFI, eskElse, eskIIF, eskEscape,
    eskInto);
  TADPhysEscapeFunction = (efASCII, efLTRIM, efREPLACE, efRTRIM, efABS,
    efCOS, efEXP, efFLOOR, efMOD, efPOWER, efROUND, efSIGN, efSIN, efSQRT, efTAN,
    efDECODE, efBIT_LENGTH, efCHAR, efCHAR_LENGTH, efCONCAT, efINSERT,
    efLCASE, efLEFT, efLENGTH, efLOCATE, efOCTET_LENGTH, efPOSITION, efREPEAT, efRIGHT,
    efSPACE, efSUBSTRING, efUCASE, efACOS, efASIN, efATAN, efATAN2, efCOT, efCEILING,
    efDEGREES, efLOG, efLOG10, efPI, efRADIANS, efRANDOM, efTRUNCATE, efCURDATE,
    efCURTIME, efNOW, efDAYNAME, efDAYOFMONTH, efDAYOFWEEK, efDAYOFYEAR, efEXTRACT,
    efHOUR, efMINUTE, efMONTH, efMONTHNAME, efQUARTER, efSECOND, efTIMESTAMPADD,
    efTIMESTAMPDIFF, efWEEK, efYEAR, efCATALOG, efSCHEMA, efIFNULL, efIF, efCONVERT,
    efLIMIT, efNONE);
  TADPhysEscapeData = record
    FKind: TADPhysEscapeKind;
    FFunc: TADPhysEscapeFunction;
    FName: String;
    FArgs: array of String;
  end;

  TADPhysNamePart = (npCatalog, npSchema, npDBLink, npBaseObject, npObject);
  TADPhysNameParts = set of TADPhysNamePart;
  TADPhysParsedName = record
    FCatalog,
    FSchema,
    FBaseObject,
    FObject,
    FLink: String;
  end;

  TADPhysNameQuoteLevel = (ncDefault, ncSecond, ncThird);
  TADPhysNameQuoteLevels = set of TADPhysNameQuoteLevel;
  TADPhysNameQuoteSide = (nsLeft, nsRight);

  TADPhysDecodeOption = (doUnquote, doNormalize, doSubObj,
    doNotRaise, doMetaParams);
  TADPhysDecodeOptions = set of TADPhysDecodeOption;
  TADPhysEncodeOption = (eoQuote, eoNormalize, eoBeautify);
  TADPhysEncodeOptions = set of TADPhysEncodeOption;

  TADPhysParamMark = (prQMark, prName, prNumber, prDollar, prQNumber);
  TADPhysDefaultValues = (dvNone, dvDefVals, dvDef);
  TADPhysLimitOptions = set of (loSkip, loRows);

  TADPhysNullLocation = (nlAscFirst, nlAscLast, nlDescFirst, nlDescLast);
  TADPhysNullLocations = set of TADPhysNullLocation;

  TADPhysConnectionState = (csDisconnecting, csDisconnected,
    csConnecting, csConnected, csRecovering);

  TADPhysFillRowOption = (foBlobs, foDetails, foData,
    foAfterIns, foAfterUpd, foUpdatable, foClear, foUnkRec,
    foNoIdentity);
  TADPhysFillRowOptions = set of TADPhysFillRowOption;
  TADPhysCommandGeneratorOptions = set of (goForceQuoteTab, goForceNoQuoteTab,
    goForceQuoteCol, goForceNoQuoteCol, goBeautify);

  TADPhysMetaInfoKind = (
    mkNone,
    mkCatalogs, mkSchemas,
    mkTables, mkTableFields,
    mkIndexes, mkIndexFields,
    mkPrimaryKey, mkPrimaryKeyFields,
    mkForeignKeys, mkForeignKeyFields,
    mkPackages, mkProcs, mkProcArgs,
    mkGenerators,
    mkResultSetFields);
  TADPhysObjectScope = (osMy, osOther, osSystem);
  TADPhysObjectScopes = set of TADPhysObjectScope;
  TADPhysTableKind = (tkSynonym, tkTable, tkView, tkTempTable, tkLocalTable);
  TADPhysTableKinds = set of TADPhysTableKind;
  TADPhysProcedureKind = (pkProcedure, pkFunction);
  TADPhysIndexKind = (ikNonUnique, ikUnique, ikPrimaryKey);
  TADPhysCascadeRuleKind = (ckNone, ckCascade, ckRestrict, ckSetNull, ckSetDefault);

  TADPhysManagerState = (dmsInactive, dmsActive, dmsStoping, dmsTerminating);
  TADPhysDriverState = (drsUnknown, drsRegistered, drsLoading, drsLoaded,
    drsActive, drsStoping);
  TADPhysCommandState = (csInactive, csPrepared, csExecuting, csOpen,
    csFetching, csAborting);
  TADPhysCommandStates = set of TADPhysCommandState;
  TADPhysNameKind = (nkDefault, nkID, nkSource, nkDatS, nkObj);
  TADPhysMetaInfoMergeMode = (mmReset, mmOverride, mmRely);
  TADPhysMissingMetaInfoAction = (maAdd, maIgore, maError);

  TADPhysConnectionRecoverAction = (faDefault, faFail, faRetry, faCloseAbort,
    faOfflineAbort);
  TADPhysArrayExecMode = (aeNotSupported, aeOnErrorUndoAll, aeUpToFirstError,
    aeCollectAllErrors);

  TADPhysInsertHBlobMode = (hmInInsert, hmUpdateAfterInsert, hmSetAfterReturning);

  TADPhysTableCommand = (tcUnknown, tcPageUp, tcPageDown, tcBof, tcEof, tcLocate,
    tcFindKey, tcFindNearest, tcSetRecNo, tcGetRowCount, tcCurrentRecord, tcGetRecNo);

  TADPhysTableParams = record
    FTableCommand: TADPhysTableCommand;
    FLastTableCommand: TADPhysTableCommand;
    FCatalog: String;
    FSchema: String;
    FTable: String;
    FSelectFields: String;
    FPrimaryKeyFields: String;
    FIndexFields: String;
    FDescFields: String;
    FNoCaseFields: String;
    FIndexExpression: String;
    FMasterFields: String;
    FMasterNullFields: String;
    FFilter: String;
    FFilterNoCase: Boolean;
    FFilterPartial: Boolean;
    FRanged: Boolean;
    FRangeStartRow: TADDatSRow;
    FRangeStartFieldCount: Integer;
    FRangeEndRow: TADDatSRow;
    FRangeEndFieldCount: Integer;
    FExclusive: Boolean;
    FFiltered: Boolean;
    FLocateFields: String;
    FLocateExpression: String;
    FLocateIgnoreCase: Boolean;
    FLocatePartial: Boolean;
    FLocateBackward: Boolean;
    FLocateFromCurrent: Boolean;
    FLocateRow: TADDatSRow;
    FKeyFieldCount: Integer;
    FRecordCount: Integer;
    FRecordNumber: Integer;
    FNullLocation: TADPhysNullLocations;
    FCustomWhere: String;
  end;

  IADPhysManagerMetadata = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2100}']
    // private
    function GetDriverCount: Integer;
    function GetDriverID(AIndex: Integer): String;
    function GetBaseDriverID(AIndex: Integer): String; overload;
    // public
    procedure CreateDriverMetadata(const ADriverID: String; out ADrvMeta: IADPhysDriverMetadata);
    property DriverCount: Integer read GetDriverCount;
    property DriverID[AIndex: Integer]: String read GetDriverID;
    property BaseDriverID[AIndex: Integer]: String read GetBaseDriverID;
    function GetBaseDriverID(const ADriverID: String): String; overload;
    function GetRDBMSKind(const ADriverID: String): TADRDBMSKind;
  end;

  IADPhysManager = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2101}']
    // private
    function GetDriverDefs: IADStanDefinitions;
    function GetConnectionDefs: IADStanConnectionDefs;
    function GetOptions: IADStanOptions;
    function GetState: TADPhysManagerState;
    // public
    procedure CreateDriver(const ADriverID: String;
      out ADrv: IADPhysDriver; AIntfRequired: Boolean = True);
    procedure CreateConnection(const AConDef: IADStanConnectionDef;
      out AConn: IADPhysConnection; AIntfRequired: Boolean = True); overload;
    procedure CreateConnection(const AConDefName: String;
      out AConn: IADPhysConnection; AIntfRequired: Boolean = True); overload;
    procedure CreateMetadata(out AMeta: IADPhysManagerMetadata);
    procedure CreateDefaultConnectionMetadata(out AConn: IADPhysConnectionMetadata);
    procedure Open;
    procedure Close(AWait: Boolean = False);
    procedure CloseConnectionDef(const AConnectionDef: IADStanConnectionDef);
    procedure RefreshMetadataCache;
    function DriverIDFromSharedCliHandle(ASharedCliHandle: Pointer): String;
    property DriverDefs: IADStanDefinitions read GetDriverDefs;
    property ConnectionDefs: IADStanConnectionDefs read GetConnectionDefs;
    property Options: IADStanOptions read GetOptions;
    property State: TADPhysManagerState read GetState;
  end;

  IADPhysDriverMetadata = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2102}']
    // private
    function GetDriverID: String;
    // public
    function GetConnParamCount(AKeys: TStrings): Integer;
    procedure GetConnParams(AKeys: TStrings; Index: Integer; var
      AName, AType, ADefVal, ACaption: String; var ALoginIndex: Integer);
    property DriverID: String read GetDriverID;
  end;

  IADPhysDriverConnectionWizard = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2111}']
    function Run(const AConnDef: IADStanConnectionDef): Boolean;
  end;

  IADPhysDriver = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2103}']
    // private
    function GetDriverID: String;
    function GetConnectionCount: Integer;
    function GetConnections(AIndex: Integer): IADPhysConnection;
    function GetState: TADPhysDriverState;
    function GetCliObj: Pointer;
    function GetMessages: TStrings;
    // public
    procedure Load;
    procedure Unload;
    procedure Employ;
    procedure Vacate;
    procedure CreateConnection(const AConnectionDef: IADStanConnectionDef;
      out AConn: IADPhysConnection);
    procedure CloseConnectionDef(const AConnectionDef: IADStanConnectionDef);
    procedure CreateMetadata(out AMeta: IADPhysDriverMetadata);
    procedure CreateConnectionWizard(out AWizard: IADPhysDriverConnectionWizard);
    property DriverID: String read GetDriverID;
    property State: TADPhysDriverState read GetState;
    property CliObj: Pointer read GetCliObj;
    property ConnectionCount: Integer read GetConnectionCount;
    property Connections[AIndex: Integer]: IADPhysConnection read GetConnections;
    property Messages: TStrings read GetMessages;
  end;

  IADPhysConnectionMetadata = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2104}']
    // private
    function GetKind: TADRDBMSKind;
    function GetClientVersion: TADVersion;
    function GetServerVersion: TADVersion;
    function GetIsUnicode: Boolean;
    function GetIsFileBased: Boolean;
    function GetTxSupported: Boolean;
    function GetTxNested: Boolean;
    function GetTxMultiple: Boolean;
    function GetTxSavepoints: Boolean;
    function GetTxAutoCommit: Boolean;
    function GetTxAtomic: Boolean;
    function GetEventSupported: Boolean;
    function GetEventKinds: String;
    function GetGeneratorSupported: Boolean;
    function GetParamNameMaxLength: Integer;
    function GetNameParts: TADPhysNameParts;
    function GetNameQuotedCaseSensParts: TADPhysNameParts;
    function GetNameCaseSensParts: TADPhysNameParts;
    function GetNameDefLowCaseParts: TADPhysNameParts;
    function GetNameQuoteChar(AQuote: TADPhysNameQuoteLevel; ASide: TADPhysNameQuoteSide): Char;
    function GetCatalogSeparator: Char;
    function GetSchemaSeparator: Char;
    function GetInsertHBlobMode: TADPhysInsertHBlobMode;
    function GetIdentitySupported: Boolean;
    function GetIdentityInsertSupported: Boolean;
    function GetIdentityInWhere: Boolean;
    function GetNamedParamMark: TADPhysParamMark;
    function GetPositionedParamMark: TADPhysParamMark;
    function GetTruncateSupported: Boolean;
    function GetDefValuesSupported: TADPhysDefaultValues;
    function GetInlineRefresh: Boolean;
    function GetSelectWithoutFrom: Boolean;
    function GetLockNoWait: Boolean;
    function GetAsyncAbortSupported: Boolean;
    function GetCommandSeparator: String;
    function GetLineSeparator: TADTextEndOfLine;
    function GetArrayExecMode: TADPhysArrayExecMode;
    function GetLimitOptions: TADPhysLimitOptions;
    function GetNullLocation: TADPhysNullLocations;
    function GetServerCursorSupported: Boolean;
    function GetColumnOriginProvided: Boolean;
    // public
    function DecodeObjName(const AName: String; out AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand; AOpts: TADPhysDecodeOptions): Boolean;
    function EncodeObjName(const AParsedName: TADPhysParsedName;
      const ACommand: IADPhysCommand; AOpts: TADPhysEncodeOptions): String;
    function QuoteObjName(const AName: String): String;
    function UnQuoteObjName(const AName: String): String;
    function IsKeyword(const AName: String): Boolean;
    function GetNameQuotedCaseSens(const AName: String; APart: TADPhysNamePart): Boolean;
    function TranslateEscapeSequence(var ASeq: TADPhysEscapeData): String;
    function GetSQLCommandKind(const ATokens: TStrings): TADPhysCommandKind;
    function DefineMetadataTableName(AKind: TADPhysMetaInfoKind): String;
    procedure DefineMetadataStructure(ATable: TADDatSTable; AKind: TADPhysMetaInfoKind);
    // object lists
    function GetCatalogs(const AWildCard: String): TADDatSView;
    function GetSchemas(const ACatalog, AWildCard: String): TADDatSView;
    function GetTables(AScope: TADPhysObjectScopes; AKinds: TADPhysTableKinds;
      const ACatalog, ASchema, AWildCard: String): TADDatSView;
    function GetTableFields(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView;
    function GetTableIndexes(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView;
    function GetTableIndexFields(const ACatalog, ASchema, ATable, AIndex, AWildCard: String): TADDatSView;
    function GetTablePrimaryKey(const ACatalog, ASchema, ATable: String): TADDatSView;
    function GetTablePrimaryKeyFields(const ACatalog, ASchema, ATable, AWildCard: String): TADDatSView;
    function GetPackages(AScope: TADPhysObjectScopes; const ACatalog, ASchema, AWildCard: String): TADDatSView;
    function GetPackageProcs(const ACatalog, ASchema, APackage, AWildCard: String): TADDatSView;
    function GetProcs(AScope: TADPhysObjectScopes; const ACatalog, ASchema, AWildCard: String): TADDatSView;
    function GetProcArgs(const ACatalog, ASchema, APackage, AProc, AWildCard: String; AOverload: Word): TADDatSView;
    function GetGenerators(AScope: TADPhysObjectScopes; const ACatalog, ASchema, AWildCard: string): TADDatSView;
    function GetResultSetFields(const ASQLKey: String): TADDatSView;
    procedure RefreshMetadataCache(const AObjName: String = '');
    // props
    property Kind: TADRDBMSKind read GetKind;
    property ClientVersion: TADVersion read GetClientVersion;
    property ServerVersion: TADVersion read GetServerVersion;
    property IsUnicode: Boolean read GetIsUnicode;
    property IsFileBased: Boolean read GetIsFileBased;
    property TxSupported: Boolean read GetTxSupported;
    property TxNested: Boolean read GetTxNested;
    property TxMultiple: Boolean read GetTxMultiple;
    property TxSavepoints: Boolean read GetTxSavepoints;
    property TxAutoCommit: Boolean read GetTxAutoCommit;
    property TxAtomic: Boolean read GetTxAtomic;
    property EventSupported: Boolean read GetEventSupported;
    property EventKinds: String read GetEventKinds;
    property GeneratorSupported: Boolean read GetGeneratorSupported;
    property ParamNameMaxLength: Integer read GetParamNameMaxLength;
    property NameParts: TADPhysNameParts read GetNameParts;
    property NameQuotedCaseSensParts: TADPhysNameParts read GetNameQuotedCaseSensParts;
    property NameCaseSensParts: TADPhysNameParts read GetNameCaseSensParts;
    property NameDefLowCaseParts: TADPhysNameParts read GetNameDefLowCaseParts;
    property NameQuoteChar[AQuote: TADPhysNameQuoteLevel; ASide: TADPhysNameQuoteSide]: Char
      read GetNameQuoteChar;
    property CatalogSeparator: Char read GetCatalogSeparator;
    property SchemaSeparator: Char read GetSchemaSeparator;
    property InsertHBlobMode: TADPhysInsertHBlobMode read GetInsertHBlobMode;
    property IdentitySupported: Boolean read GetIdentitySupported;
    property IdentityInsertSupported: Boolean read GetIdentityInsertSupported;
    property IdentityInWhere: Boolean read GetIdentityInWhere;
    property NamedParamMark: TADPhysParamMark read GetNamedParamMark;
    property PositionedParamMark: TADPhysParamMark read GetPositionedParamMark;
    property TruncateSupported: Boolean read GetTruncateSupported;
    property DefValuesSupported: TADPhysDefaultValues read GetDefValuesSupported;
    property InlineRefresh: Boolean read GetInlineRefresh;
    property SelectWithoutFrom: Boolean read GetSelectWithoutFrom;
    property LockNoWait: Boolean read GetLockNoWait;
    property AsyncAbortSupported: Boolean read GetAsyncAbortSupported;
    property CommandSeparator: String read GetCommandSeparator;
    property LineSeparator: TADTextEndOfLine read GetLineSeparator;
    property ArrayExecMode: TADPhysArrayExecMode read GetArrayExecMode;
    property LimitOptions: TADPhysLimitOptions read GetLimitOptions;
    property NullCollation: TADPhysNullLocations read GetNullLocation;
    property ServerCursorSupported: Boolean read GetServerCursorSupported;
    property ColumnOriginProvided: Boolean read GetColumnOriginProvided;
  end;

  IADPhysConnectionRecoveryHandler = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2112}']
    // public
    procedure HandleConnectionRecover(const AInitiator: IADStanObject;
      AException: Exception; var AAction: TADPhysConnectionRecoverAction);
    procedure HandleConnectionRestored;
    procedure HandleConnectionLosted;
  end;

  TADPhysLocalQueryAdapterFeatures = set of (afCachedUpdates, afSavePoints,
    afIndexFieldNames, afRanges, afFilters, afPrimaryKey);
  IADPhysLocalQueryAdapter = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2118}']
    // private
    function GetFeatures: TADPhysLocalQueryAdapterFeatures;
    function GetCachedUpdates: Boolean;
    procedure SetCachedUpdates(const AValue: Boolean);
    function GetSavePoint: Integer;
    procedure SetSavePoint(const AValue: Integer);
    function GetIndexFieldNames: String;
    procedure SetIndexFieldNames(const AValue: String);
    function GetDataSet: TObject;
    // public
    function ApplyUpdates(AMaxErrors: Integer = -1): Integer;
    procedure CommitUpdates;
    procedure SetRange(const AStartValues, AEndValues: array of const;
      AStartExclusive: Boolean = False; AEndExclusive: Boolean = False);
    procedure CancelRange;
    function IsPKViolation(AExc: Exception): Boolean;
    property Features: TADPhysLocalQueryAdapterFeatures read GetFeatures;
    property CachedUpdates: Boolean read GetCachedUpdates write SetCachedUpdates;
    property SavePoint: Integer read GetSavePoint write SetSavePoint;
    property IndexFieldNames: String read GetIndexFieldNames write SetIndexFieldNames;
    property DataSet: TObject read GetDataSet;
  end;

  IADPhysSQLHandler = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2119}']
    function FindDataSet(const ASchema, AName: String): IADPhysLocalQueryAdapter;
    function DataSetNotFound(const AName: String): Boolean;
    procedure ReadDataSet(const ASchema, AName: String; ADataSet: TObject);
  end;

  IADPhysConnection = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2105}']
    // private
    function GetDriver: IADPhysDriver;
    function GetState: TADPhysConnectionState;
    function GetOptions: IADStanOptions;
    function GetCommandCount: Integer;
    function GetCommands(AIndex: Integer): IADPhysCommand;
    function GetErrorHandler: IADStanErrorHandler;
    function GetRecoveryHandler: IADPhysConnectionRecoveryHandler;
    function GetLogin: IADGUIxLoginDialog;
    function GetConnectionDef: IADStanConnectionDef;
    function GetLoginPrompt: Boolean;
    function GetMessages: EADDBEngineException;
    function GetCliObj: Pointer;
    function GetSharedCliHandle: Pointer;
    function GetCliHandle: Pointer;
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
    procedure SetCurrentCatalog(const AValue: String);
    procedure SetCurrentSchema(const AValue: String);
{$IFDEF AnyDAC_MONITOR}
    function GetMonitor: IADMoniClient;
    function GetTracing: Boolean;
    procedure SetTracing(AValue: Boolean);
{$ENDIF}
    procedure SetSharedCliHandle(AValue: Pointer);
    procedure SetTransaction(const AValue: IADPhysTransaction);
    // public
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
    function GetLastAutoGenValue(const AName: String): Variant;
    procedure SaveLastAutoGenValue(const AValue: Variant);
    function Clone: IADPhysConnection;
    procedure AnalyzeSession(AMessages: TStrings);
    // R/O
    property Driver: IADPhysDriver read GetDriver;
    property State: TADPhysConnectionState read GetState;
    property ConnectionDef: IADStanConnectionDef read GetConnectionDef;
    property CommandCount: Integer read GetCommandCount;
    property Commands[AIndex: Integer]: IADPhysCommand read GetCommands;
    property TransactionCount: Integer read GetTransactionCount;
    property Transactions[AIndex: Integer]: IADPhysTransaction read GetTransactions;
    property EventCount: Integer read GetEventCount;
    property Events[AIndex: Integer]: IADPhysEventAlerter read GetEvents;
    property Messages: EADDBEngineException read GetMessages;
    property CliObj: Pointer read GetCliObj;
    property CliHandle: Pointer read GetCliHandle;
    // R/W
    property Options: IADStanOptions read GetOptions write SetOptions;
    property ErrorHandler: IADStanErrorHandler read GetErrorHandler write SetErrorHandler;
    property RecoveryHandler: IADPhysConnectionRecoveryHandler
      read GetRecoveryHandler write SetRecoveryHandler;
    property Login: IADGUIxLoginDialog read GetLogin write SetLogin;
    property LoginPrompt: Boolean read GetLoginPrompt write SetLoginPrompt;
    property SharedCliHandle: Pointer read GetSharedCliHandle write SetSharedCliHandle;
    property Transaction: IADPhysTransaction read GetTransaction write SetTransaction;
    property CurrentCatalog: String read GetCurrentCatalog write SetCurrentCatalog;
    property CurrentSchema: String read GetCurrentSchema write SetCurrentSchema;
{$IFDEF AnyDAC_MONITOR}
    property Tracing: Boolean read GetTracing write SetTracing;
    property Monitor: IADMoniClient read GetMonitor;
{$ENDIF}
  end;

  TADPhysTransactionState = (tsInactive, tsActive, tsStarting, tsCommiting, tsRollingback);
  TADPhysDisconnectFilter = function (ACmdObj: TObject): Boolean;
  TADPhysDisconnectMode = (dmOffline, dmRelease);

  IADPhysTransactionStateHandler = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2115}']
    procedure HandleDisconnectCommands(AFilter: TADPhysDisconnectFilter;
      AMode: TADPhysDisconnectMode);
    procedure HandleTxOperation(AOperation: TADPhysTransactionState;
      ABefore: Boolean);
  end;

  IADPhysTransaction = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2113}']
    // private
    function GetOptions: TADTxOptions;
    function GetActive: Boolean;
    function GetSerialID: LongWord;
    function GetTopSerialID: LongWord;
    function GetNestingLevel: LongWord;
    function GetCliObj: Pointer;
    function GetConnection: IADPhysConnection;
    function GetState: TADPhysTransactionState;
    procedure SetOptions(const AValue: TADTxOptions);
    // public
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
    // R/O
    property Connection: IADPhysConnection read GetConnection;
    property Active: Boolean read GetActive;
    property State: TADPhysTransactionState read GetState;
    property TopSerialID: LongWord read GetTopSerialID;
    property SerialID: LongWord read GetSerialID;
    property NestingLevel: LongWord read GetNestingLevel;
    property CliObj: Pointer read GetCliObj;
    // R/W
    property Options: TADTxOptions read GetOptions write SetOptions;
  end;

  TADPhysMappingResult = (mrDefault, mrMapped, mrNotMapped);
  IADPhysMappingHandler = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2108}']
    function MapRecordSet(const ATable: Variant; ATabNameKind: TADPhysNameKind;
      var ASourceID: Integer; var ASourceName, ADatSName, AUpdateName: String;
      var ADatSTable: TADDatSTable): TADPhysMappingResult;
    function MapRecordSetColumn(const ATable: Variant; ATabNameKind: TADPhysNameKind;
      const AColumn: Variant; AColNameKind: TADPhysNameKind; var ASourceID: Integer;
      var ASourceName, ADatSName, AUpdateName: String;
      var ADatSColumn: TADDatSColumn): TADPhysMappingResult;
  end;

  IADPhysCommandStateHandler = interface(IADStanAsyncHandler)
    ['{3E9B315B-F456-4175-A864-B2573C4A2114}']
    procedure HandleUnprepare;
  end;

  TADPhysCommandGeneratorFlags = set of (gfHasHBlob, gfFetchGenerator,
    gfIdentityInsert);
  IADPhysCommandGenerator = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2107}']
    // private
    function GetFillRowOptions: TADPhysFillRowOptions;
    function GetGenOptions: TADPhysCommandGeneratorOptions;
    function GetFlags: TADPhysCommandGeneratorFlags;
    function GetParams: TADParams;
    function GetRow: TADDatSRow;
    function GetTable: TADDatSTable;
    function GetUpdateRowOptions: TADUpdateRowOptions;
    procedure SetParams(const AValue: TADParams);
    procedure SetRow(const AValue: TADDatSRow);
    procedure SetTable(const AValue: TADDatSTable);
    procedure SetUpdateRowOptions(const AValue: TADUpdateRowOptions);
    function GetCol: TADDatSColumn;
    procedure SetCol(const AValue: TADDatSColumn);
    procedure SetFillRowOptions(const AValue: TADPhysFillRowOptions);
    procedure SetGenOptions(const AValue: TADPhysCommandGeneratorOptions);
    function GetCommandKind: TADPhysCommandKind;
    function GetSQLOrderByPos: Integer;
    function GetOptions: IADStanOptions;
    procedure SetOptions(const AValue: IADStanOptions);
    function GetMappingHandler: IADPhysMappingHandler;
    procedure SetMappingHandler(const AValue: IADPhysMappingHandler);
    // public
    function GenerateDelete: String;
    function GenerateDeleteAll(ANoUndo: Boolean): String;
    function GenerateInsert: String;
    function GenerateLock: String;
    function GenerateSavepoint(const AName: String): String;
    function GenerateRollbackToSavepoint(const AName: String): String;
    function GenerateCommitSavepoint(const AName: String): String;
    function GenerateSelect(ARequired: Boolean): String;
    function GenerateUnLock: String;
    function GenerateUpdate: String;
    function GenerateUpdateHBlobs: String;
    function GenerateFetchGenerators: String;
    function GenerateReadGenerator(const AName, AAlias: String;
      ANextValue, AFullSelect: Boolean): String;
    function GenerateCall(const AName: String): String;
    function GenerateEval(const AExpr: String): String;
    function GeneratePing: String;
    function GenerateSelectTable(ATableParams: TADPhysTableParams): String;
    function GenerateStoredProcParams(const ACatalog, ASchema, APackage, AProc: String;
      AOverload: Word = 0): String;
    function GenerateStoredProcCall(const ACatalog, ASchema, APackage, AProc: String;
      ASPUsage: TADPhysCommandKind = skStoredProc): String;
    function GenerateSelectMetaInfo(AKind: TADPhysMetaInfoKind;
      const ACatalog, ASchema, ABaseObj, AObj, AWildcard: String;
      AScopes: TADPhysObjectScopes; ATableKinds: TADPhysTableKinds;
      AOverload: Word): String;
    function GenerateLimitSelect(const ASQL: String; ASkip, ARows: Integer;
      AOneMore: Boolean = False): String;
    function GenerateCountSelect(const ASQL: String): String;
    // R/O
    property Flags: TADPhysCommandGeneratorFlags read GetFlags;
    // R/W
    property CommandKind: TADPhysCommandKind read GetCommandKind;
    property SQLOrderByPos: Integer read GetSQLOrderByPos;
    property FillRowOptions: TADPhysFillRowOptions read GetFillRowOptions
      write SetFillRowOptions;
    property UpdateRowOptions: TADUpdateRowOptions read GetUpdateRowOptions
      write SetUpdateRowOptions;
    property GenOptions: TADPhysCommandGeneratorOptions read GetGenOptions
      write SetGenOptions;
    property Options: IADStanOptions read GetOptions write SetOptions;
    property Params: TADParams read GetParams write SetParams;
    property Column: TADDatSColumn read GetCol write SetCol;
    property Row: TADDatSRow read GetRow write SetRow;
    property Table: TADDatSTable read GetTable write SetTable;
    property MappingHandler: IADPhysMappingHandler read GetMappingHandler
      write SetMappingHandler;
  end;

  IADPhysCommand = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2109}']
    // private
    function GetSchemaName: String;
    function GetCatalogName: String;
    function GetBaseObjectName: String;
    function GetConnection: IADPhysConnection;
    function GetOptions: IADStanOptions;
    function GetState: TADPhysCommandState;
    function GetCommandText: String;
    function GetCommandKind: TADPhysCommandKind;
    function GetParams: TADParams;
    function GetMacros: TADMacros;
    function GetOverload: Word;
    function GetNextRecordSet: Boolean;
    function GetErrorHandler: IADStanErrorHandler;
    function GetSourceObjectName: String;
    function GetSourceRecordSetName: String;
    function GetRowsAffected: TADCounter;
    function GetRowsAffectedReal: Boolean;
    function GetErrorAction: TADErrorAction;
    function GetMappingHandler: IADPhysMappingHandler;
    function GetSQLOrderByPos: Integer;
    function GetCliObj: Pointer;
    function GetTransaction: IADPhysTransaction;
    function GetSQLText: String;
    function GetStateHandler: IADPhysCommandStateHandler;
    procedure SetSchemaName(const AValue: String);
    procedure SetCatalogName(const AValue: String);
    procedure SetBaseObjectName(const AValue: String);
    procedure SetOptions(const AValue: IADStanOptions);
    procedure SetCommandText(const AValue: String);
    procedure SetCommandKind(const AValue: TADPhysCommandKind);
    procedure SetSourceObjectName(const AValues: String);
    procedure SetSourceRecordSetName(const AValues: String);
    procedure SetNextRecordSet(const AValue: Boolean);
    procedure SetErrorHandler(const AValue: IADStanErrorHandler);
    procedure SetOverload(const AValue: Word);
    procedure SetMappingHandler(const AValue: IADPhysMappingHandler);
    procedure SetTransaction(const AValue: IADPhysTransaction);
    procedure SetStateHandler(const AValue: IADPhysCommandStateHandler);
    procedure SetMacros(AValue: TADMacros);
    procedure SetParams(AValue: TADParams);
    // public
    procedure AbortJob(const AWait: Boolean = False);
    procedure Close;
    procedure CloseAll;
    procedure CheckAsyncProgress;
    procedure Disconnect;
    function Define(ADatSManager: TADDatSManager; ATable: TADDatSTable = nil;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset): TADDatSTable; overload;
    function Define(ATable: TADDatSTable = nil;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset): TADDatSTable; overload;
    procedure Execute(ATimes: Integer = 0; AOffset: Integer = 0;
      ABlocked: Boolean = False);
    procedure Fetch(ATable: TADDatSTable; AAll: Boolean = True;
      ABlocked: Boolean = False); overload;
    procedure Fetch(ADatSManager: TADDatSManager;
      AMetaInfoMergeMode: TADPhysMetaInfoMergeMode = mmReset); overload;
    procedure Open(ABlocked: Boolean = False);
    procedure Preprocess;
    procedure Prepare(const ACommandText: String = ''; ACreateParams: Boolean = True);
    procedure Unprepare;
    // R/O
    property Connection: IADPhysConnection read GetConnection;
    property State: TADPhysCommandState read GetState;
    property RowsAffected: TADCounter read GetRowsAffected;
    property RowsAffectedReal: Boolean read GetRowsAffectedReal;
    property ErrorAction: TADErrorAction read GetErrorAction;
    property SQLOrderByPos: Integer read GetSQLOrderByPos;
    property SQLText: String read GetSQLText;
    property CliObj: Pointer read GetCliObj;
    // R/W
    property Transaction: IADPhysTransaction read GetTransaction write SetTransaction;
    property Options: IADStanOptions read GetOptions write SetOptions;
    property SchemaName: String read GetSchemaName write SetSchemaName;
    property CatalogName: String read GetCatalogName write SetCatalogName;
    property BaseObjectName: String read GetBaseObjectName write SetBaseObjectName;
    property CommandKind: TADPhysCommandKind read GetCommandKind write SetCommandKind;
    property CommandText: String read GetCommandText write SetCommandText;
    property Params: TADParams read GetParams write SetParams;
    property Macros: TADMacros read GetMacros write SetMacros;
    property Overload: Word read GetOverload write SetOverload;
    property NextRecordSet: Boolean read GetNextRecordSet write SetNextRecordSet;
    property SourceObjectName: String read GetSourceObjectName write SetSourceObjectName;
    property SourceRecordSetName: String read GetSourceRecordSetName write SetSourceRecordSetName;
    property ErrorHandler: IADStanErrorHandler read GetErrorHandler write SetErrorHandler;
    property MappingHandler: IADPhysMappingHandler read GetMappingHandler write SetMappingHandler;
    property StateHandler: IADPhysCommandStateHandler read GetStateHandler write SetStateHandler;
  end;

  IADPhysMetaInfoCommand = interface(IADPhysCommand)
    ['{3E9B315B-F456-4175-A864-B2573C4A2110}']
    // private
    function GetMetaInfoKind: TADPhysMetaInfoKind;
    procedure SetMetaInfoKind(AValue: TADPhysMetaInfoKind);
    function GetTableKinds: TADPhysTableKinds;
    procedure SetTableKinds(AValue: TADPhysTableKinds);
    function GetWildcard: String;
    procedure SetWildcard(const AValue: String);
    function GetObjectScopes: TADPhysObjectScopes;
    procedure SetObjectScopes(AValue: TADPhysObjectScopes);
    // public
    property MetaInfoKind: TADPhysMetaInfoKind read GetMetaInfoKind write SetMetaInfoKind;
    property TableKinds: TADPhysTableKinds read GetTableKinds write SetTableKinds;
    property Wildcard: String read GetWildcard write SetWildcard;
    property ObjectScopes: TADPhysObjectScopes read GetObjectScopes write SetObjectScopes;
  end;

  IADPhysEventHandler = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2116}']
    procedure HandleEvent(const AEventName: String; const AArgument: Variant);
    procedure HandleTimeout(var AContinue: Boolean);
  end;

  TADPhysEventAlerterState = (esInactive, esRegistering, esRegistered,
    esUnregistering, esFiring);
  IADPhysEventAlerter = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2117}']
    // private
    function GetConnection: IADPhysConnection;
    function GetState: TADPhysEventAlerterState;
    function GetKind: String;
    function GetOptions: TADEventAlerterOptions;
    function GetNames: TStrings;
    function GetHandler: IADPhysEventHandler;
    procedure SetOptions(const AValue: TADEventAlerterOptions);
    procedure SetNames(const AValue: TStrings);
    procedure SetHandler(const AValue: IADPhysEventHandler);
    // public
    procedure Register;
    procedure Unregister;
    procedure Signal(const AEvent: String; const AArgument: Variant);
    // R/O
    property Connection: IADPhysConnection read GetConnection;
    property State: TADPhysEventAlerterState read GetState;
    property Kind: String read GetKind;
    // R/W
    property Options: TADEventAlerterOptions read GetOptions write SetOptions;
    property Names: TStrings read GetNames write SetNames;
    property Handler: IADPhysEventHandler read GetHandler write SetHandler;
  end;

const
  C_AD_PhysRDBMSKinds: array[TADRDBMSKind] of String =
    ('', 'ORACLE', 'MSSQL', 'MSACCESS', 'MYSQL', 'DB2', 'ASA', 'ADS',
     'INTRBASE', 'SQLITE', 'POSTGRESQL', 'NEXUS', 'DATASNAP', 'OTHER');
  C_AD_PhysRDBMSIds: array[TADRDBMSKind] of String =
    ('', S_AD_OraId, S_AD_MSSQLId, S_AD_MSAccId, S_AD_MySQLId, S_AD_DB2Id,
     S_AD_ASAId, S_AD_ADSId, S_AD_IBId, S_AD_SQLiteId, S_AD_PGId, S_AD_NexusId,
     S_AD_DataSnapId, '');

function ADPhysManager: IADPhysManager;
function ADGetFillRowOptions(AFetchOptions: TADFetchOptions): TADPhysFillRowOptions;
procedure ADClearMetaView(var AView: TADDatSView; AOptions: TADFetchOptions);

implementation

uses
  uADStanFactory, uADStanUtil;

{-------------------------------------------------------------------------------}
function ADPhysManager: IADPhysManager;
begin
  ADCreateInterface(IADPhysManager, Result);
end;

{-------------------------------------------------------------------------------}
function ADGetFillRowOptions(AFetchOptions: TADFetchOptions): TADPhysFillRowOptions;
begin
  if AFetchOptions = nil then
    Result := [foData, foBlobs, foDetails]
  else begin
    Result := [foData];
    if fiBlobs in AFetchOptions.Items then
      Include(Result, foBlobs);
    if fiDetails in AFetchOptions.Items then
      Include(Result, foDetails);
  end;
end;

{-------------------------------------------------------------------------------}
procedure ADClearMetaView(var AView: TADDatSView; AOptions: TADFetchOptions);
begin
  if not (fiMeta in AOptions.Cache) then
    AView.DeleteAll(True);
  ADFreeAndNil(AView);
end;

end.
