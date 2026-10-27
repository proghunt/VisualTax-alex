{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{              FireDAC standard layer API               }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADStanIntf;

interface

uses
  SysUtils, Classes, IniFiles
{$IFDEF AnyDAC_D6Base}
  , Variants, FmtBcd
  {$IFDEF AnyDAC_D6}
  , SqlTimSt
  {$ENDIF}
{$ELSE}
  {$IFNDEF NEXTGEN}
  , ActiveX
  {$ENDIF}
  , DB
{$ENDIF}
{$IFDEF NEXTGEN}
  , System.Generics.Collections
{$ENDIF}
  ;

type
{$IFNDEF AnyDAC_D6Base}
  IInterfaceComponentReference = interface;
{$ENDIF}
  IADStanComponentReference = interface;
  TADComponent = class;
  IADStanObject = interface;
  IADStanObjectHost = interface;
  IADStanObjectFactory = interface;
  IADStanErrorHandler = interface;
  IADStanExpressionDataSource = interface;
  IADStanExpressionParser = interface;
  IADStanExpressionEvaluator = interface;
  IADStanDefinitionStorage = interface;
  IADStanDefinition = interface;
  IADStanDefinitions = interface;
  IADStanConnectionDef = interface;
  IADStanConnectionDefs = interface;
  IADStanAsyncOperation = interface;
  IADStanAsyncExecutor = interface;
  TADMoniAdapterHelper = class;
{$IFDEF AnyDAC_MONITOR}
  IADMoniClientOutputHandler = interface;
  IADMoniClient = interface;
  IADMoniRemoteClient = interface;
  IADMoniFlatFileClient = interface;
  IADMoniCustomClient = interface;
{$ENDIF}
  IADMoniAdapter = interface;

  { --------------------------------------------------------------------------}
  { Supported DBMS kinds                                                      }
  { --------------------------------------------------------------------------}
  TADRDBMSKind = (mkUnknown, mkOracle, mkMSSQL, mkMSAccess, mkMySQL,
    mkDB2, mkASA, mkADS, mkInterbase, mkSQLite, mkPostgreSQL, mkNexus,
    mkDataSnap, mkOther);

  { --------------------------------------------------------------------------}
  { Data types                                                                }
  { --------------------------------------------------------------------------}
  TADDataType = (dtUnknown,                                 // unknown
    dtBoolean,                                              // Boolean
    dtSByte, dtInt16, dtInt32, dtInt64,                     // signed int
    dtByte, dtUInt16, dtUInt32, dtUInt64,                   // unsinged int
    dtSingle, dtDouble, dtExtended,                         // float point numbers
    dtCurrency, dtBCD, dtFmtBCD,                            // high-precision numbers
    dtDateTime, dtTime, dtDate, dtDateTimeStamp,            // date and time
    dtTimeIntervalFull, dtTimeIntervalYM, dtTimeIntervalDS, // time interval
    dtAnsiString, dtWideString, dtByteString,               // string
    dtBlob, dtMemo, dtWideMemo, dtXML,                      // value blobs
    dtHBlob, dtHMemo, dtWideHMemo,                          // handle blobs
    dtHBFile,                                               // external files
    dtRowSetRef, dtCursorRef, dtRowRef,
      dtArrayRef, dtParentRowRef,                           // adt -> ftDataSet, ftCursor, ftADT, ftArray
    dtGUID, dtObject);                                      // adt -> IADDataStoredObject
  TADDataTypes = set of TADDataType;

  TADDataAttribute = (caSearchable, caAllowNull, caFixedLen,
    caBlobData, caReadOnly, caAutoInc, caROWID, caDefault,
    caRowVersion, caInternal, caCalculated, caVolatile, caUnnamed,
    caVirtual, caBase, caExpr);
  TADDataAttributes = set of TADDataAttribute;
  TADDataOption = (coAllowNull, coUnique, coReadOnly, coInUpdate,
    coInWhere, coInKey, coAfterInsChanged, coAfterUpdChanged);
  TADDataOptions = set of TADDataOption;

  TADCompareDataOption = (coNoCase, coPartial, coNullFirst, coDescNullLast,
    coDescending, coCache, coNullsNotEqual, coNoSymbols);
  TADCompareDataOptions = set of TADCompareDataOption;

  TADSortOption = (soNoCase, soNullFirst, soDescNullLast, soDescending,
    soUnique, soPrimary, soNoSymbols);
  TADSortOptions = set of TADSortOption;

  TADLocateOption = (loPartial, loNearest, loNoCase, loLast, loExcludeKeyRow,
    loUseRowID, loFromCurrent, loBackward);
  TADLocateOptions = set of TADLocateOption;

  PADDataStoredObject = ^IADDataStoredObject;
  IADDataStoredObject = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2000}']
    function Compare(const AOtherObjInt: IADDataStoredObject;
      AOptions: TADCompareDataOptions): Integer;
  end;

  TADStorageFormat = (sfAuto, sfXML, sfBinary);
  TADStoreItem = (siData, siDelta, siMeta);
  TADStoreItems = set of TADStoreItem;

  { --------------------------------------------------------------------------}
  { Other                                                                     }
  { --------------------------------------------------------------------------}
{$IFNDEF AnyDAC_FPC}
  {$IFNDEF AnyDAC_D15}
  UInt64 = Int64;
  PUInt64 = ^uADStanIntf.UInt64;
  {$ENDIF}
{$ELSE}
  PUInt64 = ^UInt64;
{$ENDIF}
  PIUnknown = ^IUnknown;
  PLargeInt = ^Int64;
  PULargeInt = ^UInt64;
  TADVariantArray = array of Variant;
{$IFNDEF AnyDAC_D6Base}
  PBoolean = ^Boolean;
  PWordBool = ^WordBool;
  PByte = ^Byte;
  PSmallInt = ^SmallInt;
  PShortInt = ^ShortInt;
  PWord = ^Word;
  PInteger = ^Integer;
  PLongInt = ^LongInt;
  PLongWord = ^LongWord;
  PDouble = ^Double;
  PPointer = ^Pointer;
  PPChar = ^PChar;
  PInt64 = ^Int64;
  PSingle = ^Single;
{$ENDIF}
{$IFNDEF AnyDAC_D15}
  PLongBool = ^LongBool;
{$ENDIF}
{$IFDEF AnyDAC_BCB}
  {$IFDEF AnyDAC_D6}
    {$IFNDEF AnyDAC_D7}
  PInt64 = ^Int64;
  PPointer = ^Pointer;
  PWord = ^Word;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
{$IFNDEF AnyDAC_FPC}
  PPByte = ^PByte;
{$ENDIF}
{$IFNDEF AnyDAC_FPC}
  PDateTime = ^TDateTime;
{$ENDIF}

{$IFDEF AnyDAC_D12}
  TADNativeInt = NativeInt;
  TADNativeUInt = NativeUInt;
{$ELSE}
  // Before D7 - NativeInt / NativeUInt are not defined
  // Before D2009 - NativeInt / NativeUInt are defined, but are 64 bits or
  // lead to compiler internal errors.
  {$IFDEF AnyDAC_64}
  TADNativeInt = Int64;
  TADNativeUInt = UInt64;
  {$ELSE}
  TADNativeInt = Integer;
  TADNativeUInt = Cardinal;
  {$ENDIF}
{$ENDIF}
{$IFNDEF AnyDAC_FPC}
  TADThreadID = LongWord;
{$ELSE}
  TADThreadID = TThreadID;
{$ENDIF}
{$IFDEF AnyDAC_64}
  {$IFDEF AnyDAC_POSIX}
  TADLongInt = Int64;
  TADULongInt = UInt64;
  {$ELSE}
  TADLongInt = Integer;
  TADULongInt = LongWord;
  {$ENDIF}
{$ELSE}
  TADLongInt = Integer;
  TADULongInt = LongWord;
{$ENDIF}

{$IFNDEF AnyDAC_D12}
  // D5 - D2007
  TADByteString = AnsiString;
  TADByte = AnsiChar;
  TADWideString = WideString;
  TADAnsiString = AnsiString;
  PADByteString = PAnsiChar;
  PADAnsiString = PAnsiChar;
  TADAnsiChar = AnsiChar;
  PADBuffer = PAnsiChar;
  PADRawBuffer = PADBuffer;
  PADValue = Pointer;
  PADBookmark = Pointer;
{$ELSE}
  {$IFNDEF AnyDAC_D17}
  // D2009 - XE2
  TADByteString = RawByteString;
  TADByte = Byte;
  TADWideString = UnicodeString;
  TADAnsiString = AnsiString;
  PADByteString = PByte;
  PADAnsiString = PAnsiChar;
  TADAnsiChar = AnsiChar;
  PADBuffer = PByte;
  PADRawBuffer = PADBuffer;
  PADValue = Pointer;
  PADBookmark = Pointer;
  {$ELSE}
    {$IFNDEF NEXTGEN}
      {$IFNDEF AnyDAC_D18}
  // XE3
  TADByteString = RawByteString;
  TADByte = Byte;
  TADWideString = UnicodeString;
  TADAnsiString = AnsiString;
  PADByteString = PByte;
  PADAnsiString = PAnsiChar;
  TADAnsiChar = AnsiChar;
  PADBuffer = PByte;
  PADRawBuffer = PADBuffer;
  PADValue = TArray<Byte>;
  PADBookmark = TArray<Byte>;
      {$ELSE}
  // XE 4
  TADByteString = RawByteString;
  TADByte = Byte;
  TADWideString = UnicodeString;
  TADAnsiString = AnsiString;
  PADByteString = PByte;
  PADAnsiString = PAnsiChar;
  TADAnsiChar = AnsiChar;
  PADBuffer = NativeInt;
  PADRawBuffer = PByte;
  PADValue = TArray<Byte>;
  PADBookmark = TArray<Byte>;
      {$ENDIF}
    {$ELSE}
  // iOS (NextGen)
  TADByteString = TBytes;
  TADByte = Byte;
  TADWideString = UnicodeString;
  TADAnsiString = String;
  PADByteString = PByte;
  PADAnsiString = PByte;
  TADAnsiChar = Byte;
  PADBuffer = NativeInt;
  PADRawBuffer = PByte;
  PADValue = TArray<Byte>;
  PADBookmark = TArray<Byte>;
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
  PPADByteString = ^PADByteString;

  TADCharSet = {$IFDEF NEXTGEN} TSysCharSet {$ELSE} set of AnsiChar {$ENDIF};
  TADByteSet = set of Byte;
  TADStringArray = array of String;

{$IFNDEF AnyDAC_D6}
  TADSQLTimeStamp = packed record
    Year: SmallInt;
    Month: Word;
    Day: Word;
    Hour: Word;
    Minute: Word;
    Second: Word;
    Fractions: LongWord;
  end;
{$ELSE}
  TADSQLTimeStamp = TSQLTimeStamp;
{$ENDIF}
  PADSQLTimeStamp = ^TADSQLTimeStamp;

  TADBcd = TBcd;
  PADBcd = ^TADBcd;

  TADCounter = {$IFDEF AnyDAC_64} Int64 {$ELSE} LongInt {$ENDIF};
  TADVersion = Int64;

  TADDateTimeAlias = type TDateTime;
  {$NODEFINE TADDateTimeAlias}
  (*$HPPEMIT 'namespace Uadstanintf'*)
  (*$HPPEMIT '{'*)
  (*$HPPEMIT '    typedef TDateTimeBase TADDateTimeAlias;'*)
  (*$HPPEMIT '}'*)
  TADDateTimeData = record
  case Integer of
    0 {dtDate}: (Date: Longint);
    1 {dtTime}: (Time: Longint);
    2 {dtDateTime}: (DateTime: TADDateTimeAlias);
  end;
  PADDateTimeData = ^TADDateTimeData;

  TADParseFmtSettings = record
    FDelimiter: Char;
    FQuote: Char;
    FQuote1: Char;
    FQuote2: Char;
  end;

{$IFDEF AnyDAC_D7}
  PADFormatSettings = ^TFormatSettings;
{$ENDIF}

  TADEncoding = (ecANSI, ecUTF8, ecUTF16, ecDefault);
  TADTextEndOfLine = (elDefault, elWindows, elUnix, elMac);
  TADLocalID = LongWord;

  TADPtrList = {$IFDEF AUTOREFCOUNT} TList<Pointer> {$ELSE} TList {$ENDIF};
  TADObjList = {$IFDEF AUTOREFCOUNT} TList<TObject> {$ELSE} TList {$ENDIF};
  TADClassList = {$IFDEF AUTOREFCOUNT} TList<TClass> {$ELSE} TList {$ENDIF};
  TADThreadObjList = {$IFDEF AUTOREFCOUNT} TThreadList<TObject> {$ELSE} TThreadList {$ENDIF};

  TADValWrapper = class (TObject)
  private
    FVal: TADNativeUInt;
    function GetInt: Integer; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    function GetPtr: Pointer; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
  public
    constructor Create(APtr: Pointer); overload;
    constructor Create(AVal: LongWord); overload;
    property AsPtr: Pointer read GetPtr;
    property AsInt: Integer read GetInt;
  end;

  TADStringList = class (TStringList)
  private
    function GetPtrs(AIndex: Integer): Pointer;
    procedure SetPtrs(AIndex: Integer; const AValue: Pointer);
    function GetInts(AIndex: Integer): LongWord;
    procedure SetInts(AIndex: Integer; const AValue: LongWord);
  protected
{$IFDEF AnyDAC_NOLOCALE_META}
  {$IFDEF AnyDAC_D6}
    function CompareStrings(const S1, S2: string): Integer; override;
  {$ENDIF}
{$ENDIF}
  public
    procedure AddPtr(const AStr: String; APtr: Pointer);
    procedure AddInt(const AStr: String; AInt: LongWord);
    property Ptrs[AIndex: Integer]: Pointer read GetPtrs write SetPtrs;
    property Ints[AIndex: Integer]: LongWord read GetInts write SetInts;
{$IFDEF AnyDAC_D6}
  public
    property UpdateCount;
{$ELSE}
  private
    function GetUpdateCount: Integer;
  public
    property UpdateCount: Integer read GetUpdateCount;
{$ENDIF}
  end;

  { --------------------------------------------------------------------------}
  { Definition, connection definition                                         }
  { --------------------------------------------------------------------------}
  TADDefinitionState = (asAdded, asModified, asDeleted, asLoading, asLoaded);
  TADDefinitionStyle = (atPersistent, atPrivate, atTemporary);

  IADStanDefinitionStorage = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2012}']
    // private
    function GetFileName: String;
    procedure SetFileName(const AValue: String);
    function GetGlobalFileName: String;
    procedure SetGlobalFileName(const AValue: String);
    function GetDefaultFileName: String;
    procedure SetDefaultFileName(const AValue: String);
    // public
    function CreateIniFile: TCustomIniFile;
    // R/O
    function ActualFileName: String;
    // R/W
    property FileName: String read GetFileName write SetFileName;
    property GlobalFileName: String read GetGlobalFileName write SetGlobalFileName;
    property DefaultFileName: String read GetDefaultFileName write SetDefaultFileName;
  end;

  IADStanDefinition = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2013}']
    // private
    function GetName: String;
    function GetState: TADDefinitionState;
    function GetStyle: TADDefinitionStyle;
    function GetAsBoolean(const AName: String): LongBool;
    function GetAsInteger(const AName: String): LongInt;
    function GetAsString(const AName: String): String;
    function GetAsXString(const AName: String): String;
    function GetParentDefinition: IADStanDefinition;
    function GetParams: TStrings;
    function GetOnChanging: TNotifyEvent;
    function GetOnChanged: TNotifyEvent;
    function GetUpdatable: Boolean;
    procedure SetName(const AValue: string);
    procedure SetParams(const AValue: TStrings);
    procedure SetAsBoolean(const AName: String; const AValue: LongBool);
    procedure SetAsYesNo(const AName: String; const AValue: LongBool);
    procedure SetAsInteger(const AName: String; const AValue: LongInt);
    procedure SetAsString(const AName, AValue: String);
    procedure SetParentDefinition(const AValue: IADStanDefinition);
    procedure SetOnChanging(AValue: TNotifyEvent);
    procedure SetOnChanged(AValue: TNotifyEvent);
    // public
    procedure Apply;
    procedure Clear;
    procedure Cancel;
    procedure Delete;
    procedure MarkPersistent;
    procedure MarkUnchanged;
    procedure OverrideBy(const ADefinition: IADStanDefinition; AAll: Boolean);
    function ParseString(const AStr: String; AKeywords: TStrings = nil): String; overload;
    function ParseString(const AStr: String; AKeywords: TStrings; const AFmt: TADParseFmtSettings): String; overload;
    function BuildString(AKeywords: TStrings = nil): String; overload;
    function BuildString(AKeywords: TStrings; const AFmt: TADParseFmtSettings): String; overload;
    function HasValue(const AName: String): Boolean; overload;
    function HasValue(const AName: String; var ALevel: Integer): Boolean; overload;
    function OwnValue(const AName: String): Boolean;
    function IsSpecified(const AName: String): Boolean;
    procedure ToggleUpdates(APassCode: LongWord; ADisableDelete, ADisableModify: Boolean);
{$IFDEF AnyDAC_MONITOR}
    procedure BaseTrace(const AMonitor: IADMoniClient);
    procedure Trace(const AMonitor: IADMoniClient);
{$ENDIF}
    property State: TADDefinitionState read GetState;
    property Style: TADDefinitionStyle read GetStyle;
    property Updatable: Boolean read GetUpdatable;
    property AsXString[const AName: String]: String read GetAsXString;
    property AsString[const AName: String]: String read GetAsString write SetAsString;
    property AsBoolean[const AName: String]: LongBool read GetAsBoolean write SetAsBoolean;
    property AsYesNo[const AName: String]: LongBool read GetAsBoolean write SetAsYesNo;
    property AsInteger[const AName: String]: LongInt read GetAsInteger write SetAsInteger;
    property ParentDefinition: IADStanDefinition read GetParentDefinition write SetParentDefinition;
    // published
    property Params: TStrings read GetParams write SetParams;
    property Name: String read GetName write SetName;
    property OnChanging: TNotifyEvent read GetOnChanging write SetOnChanging;
    property OnChanged: TNotifyEvent read GetOnChanged write SetOnChanged;
  end;

  IADStanDefinitions = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2014}']
    // private
    function GetCount: Integer;
    function GetItems(AIndex: Integer): IADStanDefinition;
    function GetAutoLoad: Boolean;
    function GetStorage: IADStanDefinitionStorage;
    function GetLoaded: Boolean;
    function GetBeforeLoad: TNotifyEvent;
    function GetAfterLoad: TNotifyEvent;
    function GetUpdatable: Boolean;
    function GetName: String;
    procedure SetAutoLoad(AValue: Boolean);
    procedure SetBeforeLoad(AValue: TNotifyEvent);
    procedure SetAfterLoad(AValue: TNotifyEvent);
    procedure SetName(const AValue: String);
    // public
    function Add: IADStanDefinition;
    function AddTemporary: IADStanDefinition;
    function FindDefinition(const AName: String): IADStanDefinition;
    function DefinitionByName(const AName: String): IADStanDefinition;
    procedure Cancel;
    procedure Save(AIfModified: Boolean = True);
    function Load: Boolean;
    procedure Clear;
    procedure BeginRead;
    procedure EndRead;
    procedure BeginWrite;
    procedure EndWrite;
    property Count: Integer read GetCount;
    property Items[AIndex: Integer]: IADStanDefinition read GetItems; default;
    property Loaded: Boolean read GetLoaded;
    property Updatable: Boolean read GetUpdatable;
    // published
    property Name: String read GetName write SetName;
    property AutoLoad: Boolean read GetAutoLoad write SetAutoLoad;
    property Storage: IADStanDefinitionStorage read GetStorage;
    property BeforeLoad: TNotifyEvent read GetBeforeLoad write SetBeforeLoad;
    property AfterLoad: TNotifyEvent read GetAfterLoad write SetAfterLoad;
  end;

  IADStanConnectionDef = interface(IADStanDefinition)
    ['{3E9B315B-F456-4175-A864-B2573C4A2015}']
    // private
    function GetPooled: Boolean;
    function GetDriverID: String;
    function GetPassword: String;
    function GetUserName: String;
    function GetDatabase: String;
    function GetNewPassword: String;
    function GetExpandedDatabase: String;
    function GetMonitorBy: String;
    function GetServer: String;
    function GetPort: Integer;
    function GetOSAuthent: Boolean;
    function GetMetaDefSchema: String;
    function GetMetaDefCatalog: String;
    procedure SetPooled(AValue: Boolean);
    procedure SetDriverID(const AValue: String);
    procedure SetPassword(const AValue: String);
    procedure SetUserName(const AValue: String);
    procedure SetDatabase(const AValue: String);
    procedure SetNewPassword(const AValue: String);
    procedure SetMonitorBy(const AValue: String);
    procedure SetServer(const AValue: String);
    procedure SetPortI(const AValue: Integer);
    procedure SetOSAuthent(const AValue: Boolean);
    procedure SetMetaDefSchema(const AValue: String);
    procedure SetMetaDefCatalog(const AValue: String);
    // public
    procedure WriteOptions(AFormatOptions: TObject; AUpdateOptions: TObject;
      AFetchOptions: TObject; AResourceOptions: TObject);
    procedure ReadOptions(AFormatOptions: TObject; AUpdateOptions: TObject;
      AFetchOptions: TObject; AResourceOptions: TObject);
    property UserName: String read GetUserName write SetUserName;
    property Password: String read GetPassword write SetPassword;
    property NewPassword: String read GetNewPassword write SetNewPassword;
    property OSAuthent: Boolean read GetOSAuthent write SetOSAuthent;
    property Server: String read GetServer write SetServer;
    property Port: Integer read GetPort write SetPortI;
    property Database: String read GetDatabase write SetDatabase;
    property ExpandedDatabase: String read GetExpandedDatabase;
    property Pooled: Boolean read GetPooled write SetPooled;
    property DriverID: String read GetDriverID write SetDriverID;
    property MonitorBy: String read GetMonitorBy write SetMonitorBy;
    property MetaDefSchema: String read GetMetaDefSchema write SetMetaDefSchema;
    property MetaDefCatalog: String read GetMetaDefCatalog write SetMetaDefCatalog;
  end;

  IADStanConnectionDefs = interface(IADStanDefinitions)
    ['{3E9B315B-F456-4175-A864-B2573C4A2016}']
    // private
    function GetConnectionDefs(AIndex: Integer): IADStanConnectionDef;
    // public
    function AddConnectionDef: IADStanConnectionDef;
    function FindConnectionDef(const AName: String): IADStanConnectionDef;
    function ConnectionDefByName(const AName: String): IADStanConnectionDef;
    property Items[AIndex: Integer]: IADStanConnectionDef read GetConnectionDefs; default;
  end;

  { --------------------------------------------------------------------------}
  { Objects and factories                                                     }
  { --------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D6Base}
  IInterfaceComponentReference = interface
    ['{E28B1858-EC86-4559-8FCD-6B4F824151ED}']
    function GetComponent: TComponent;
  end;
{$ENDIF}

  IADStanComponentReference = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2029}']
    procedure SetComponentReference(const AValue: IInterfaceComponentReference);
  end;

  TADComponent = class(TComponent
    {$IFNDEF AnyDAC_D6}, IUnknown, IInterfaceComponentReference{$ENDIF})
{$IFNDEF AnyDAC_D6}
  protected
    // IInterfaceComponentReference
    function GetComponent: TComponent;
{$ENDIF}
  end;

  IADStanObject = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2001}']
    // private
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    // public
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
    property Name: TComponentName read GetName;
    property Parent: IADStanObject read GetParent;
  end;

  IADStanObjectHost = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2002}']
    // private
    function GetObjectKindName: TComponentName;
    // public
    procedure CreateObject(out AObject: IADStanObject);
    property ObjectKindName: TComponentName read GetObjectKindName;
  end;

  IADStanObjectFactory = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2003}']
    procedure Open(const AHost: IADStanObjectHost; const ADef: IADStanDefinition);
    procedure Close;
    procedure Acquire(out AObject: IADStanObject);
    procedure Release(const AObject: IADStanObject);
  end;

  { --------------------------------------------------------------------------}
  { Error handling interfaces                                                 }
  { --------------------------------------------------------------------------}
  TADErrorAction = (eaFail, eaSkip, eaRetry, eaApplied, eaDefault,
    eaExitSuccess, eaExitFailure);

  IADStanErrorHandler = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2007}']
    procedure HandleException(const AInitiator: IADStanObject; var AException: Exception);
  end;

  { --------------------------------------------------------------------------}
  { Expression evaluation                                                     }
  { --------------------------------------------------------------------------}
  TADParserOption = (poCheck, poAggregate, poDefaultExpr, poFieldNameGiven);
  TADParserOptions = set of TADParserOption;

  TADExpressionOption = (ekNoCase, ekPartial);
  TADExpressionOptions = set of TADExpressionOption;
  TADExpressionScopeKind = (ckUnknown, ckField, ckAgg, ckConst);

  TADAggregateKind = (akSum, akAvg, akCount, akMin, akMax, akFirst, akLast);

  IADStanExpressionDataSource = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2008}']
    // private
    function GetVarIndex(const AName: String): Integer;
    function GetVarType(AIndex: Integer): TADDataType;
    function GetVarScope(AIndex: Integer): TADExpressionScopeKind;
    function GetVarData(AIndex: Integer): Variant;
    procedure SetVarData(AIndex: Integer; const AValue: Variant);
    function GetSubAggregateValue(AIndex: Integer): Variant;
    function GetPosition: Pointer;
    procedure SetPosition(AValue: Pointer);
    function GetRowNum: Integer;
    function GetDatabase: String;
    function GetUser: String;
    // public
    property VarIndex[const AName: String]: Integer read GetVarIndex;
    property VarType[AIndex: Integer]: TADDataType read GetVarType;
    property VarScope[AIndex: Integer]: TADExpressionScopeKind read GetVarScope;
    property VarData[AIndex: Integer]: Variant read GetVarData write SetVarData;
    property SubAggregateValue[AIndex: Integer]: Variant read GetSubAggregateValue;
    property Position: Pointer read GetPosition write SetPosition;
    property RowNum: Integer read GetRowNum;
    property Database: String read GetDatabase;
    property User: String read GetUser;
  end;

  IADStanExpressionEvaluator = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2010}']
    // private
    function GetSubAggregateCount: Integer;
    function GetSubAggregateKind(AIndex: Integer): TADAggregateKind;
    function GetDataSource: IADStanExpressionDataSource;
    function GetDataType: TADDataType;
    // public
    function HandleNotification(AKind: Word; AReason: Word;
      AParam1, AParam2: LongWord): Boolean;
    function Evaluate: Variant;
    // support for aggregates
    function EvaluateSubAggregateArg(AIndex: Integer): Variant;
    property SubAggregateCount: Integer read GetSubAggregateCount;
    property SubAggregateKind[AIndex: Integer]: TADAggregateKind read GetSubAggregateKind;
    property DataSource: IADStanExpressionDataSource read GetDataSource;
    property DataType: TADDataType read GetDataType;
  end;

  IADStanExpressionParser = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2009}']
    // private
    function GetDataSource: IADStanExpressionDataSource;
    // public
    function Prepare(const ADataSource: IADStanExpressionDataSource;
      const AExpression: String; AOptions: TADExpressionOptions;
      AParserOptions: TADParserOptions; const AFixedVarName: String): IADStanExpressionEvaluator;
    property DataSource: IADStanExpressionDataSource read GetDataSource;
  end;

  { --------------------------------------------------------------------------}
  { Async execute                                                             }
  { --------------------------------------------------------------------------}
  TADStanAsyncMode = (amBlocking, amNonBlocking, amCancelDialog, amAsync);
  TADStanAsyncState = (asInactive, asExecuting, asFinished, asFailed, asAborted, asExpired);

  IADStanAsyncHandler = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2025}']
    procedure HandleFinished(const AInitiator: IADStanObject;
      AState: TADStanAsyncState; AException: Exception);
  end;

  IADStanAsyncOperation = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2022}']
    procedure Execute;
    procedure AbortJob;
    function AbortSupported: Boolean;
  end;

  IADStanAsyncExecutor = interface(IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2023}']
    // private
    function GetState: TADStanAsyncState;
    function GetMode: TADStanAsyncMode;
    function GetTimeout: LongWord;
    function GetOperation: IADStanAsyncOperation;
    function GetHandler: IADStanAsyncHandler;
    // public
    procedure Setup(const AOperation: IADStanAsyncOperation;
      const AMode: TADStanAsyncMode; const ATimeout: LongWord;
      const AHandler: IADStanAsyncHandler; ASilentMode: Boolean);
    procedure Run;
    procedure AbortJob;
    procedure Launched;
    // R/O
    property State: TADStanAsyncState read GetState;
    property Mode: TADStanAsyncMode read GetMode;
    property Timeout: LongWord read GetTimeout;
    property Operation: IADStanAsyncOperation read GetOperation;
    property Handler: IADStanAsyncHandler read GetHandler;
  end;

  { --------------------------------------------------------------------------}
  { Debug monitor interfaces                                                  }
  { --------------------------------------------------------------------------}
  TADMoniEventKind = (ekLiveCycle, ekError,
    ekConnConnect, ekConnTransact, ekConnService,
    ekCmdPrepare, ekCmdExecute, ekCmdDataIn, ekCmdDataOut,
    ekAdaptUpdate,
    ekVendor,
    ekComponent);
  TADMoniEventKinds = set of TADMoniEventKind;
  PADMoniEventKinds = ^TADMoniEventKinds;
  TADMoniEventStep = (esStart, esProgress, esEnd);
  TADMoniTracing = (eaAuto, eaTrue, eaFalse);
  TADTraceFileColumns = set of (tiRefNo, tiTime, tiThreadID, tiClassName,
    tiObjID, tiMsgText);

{$IFDEF AnyDAC_MONITOR}
  IADMoniClientOutputHandler = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2028}']
    procedure HandleOutput(const AClassName, AObjName, AMessage: String);
  end;

  IADMoniClient = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2005}']
    // private
    function GetTracing: Boolean;
    procedure SetTracing(const AValue: Boolean);
    function GetName: TComponentName;
    procedure SetName(const AValue: TComponentName);
    function GetEventKinds: TADMoniEventKinds;
    procedure SetEventKinds(const AValue: TADMoniEventKinds);
    function GetOutputHandler: IADMoniClientOutputHandler;
    procedure SetOutputHandler(const AValue: IADMoniClientOutputHandler);
    // public
    procedure Notify(AKind: TADMoniEventKind; AStep: TADMoniEventStep;
      ASender: TObject; const AMsg: String; const AArgs: array of const);
    function RegisterAdapter(const AAdapter: IADMoniAdapter): LongWord;
    procedure UnregisterAdapter(const AAdapter: IADMoniAdapter);
    procedure AdapterChanged(const AAdapter: IADMoniAdapter);
    procedure ResetFailure;
    property Tracing: Boolean read GetTracing write SetTracing;
    property Name: TComponentName read GetName write SetName;
    property EventKinds: TADMoniEventKinds read GetEventKinds write SetEventKinds;
    property OutputHandler: IADMoniClientOutputHandler read GetOutputHandler
      write SetOutputHandler;
  end;

  IADMoniRemoteClient = interface (IADMoniClient)
    ['{3E9B315B-F456-4175-A864-B2573C4A2026}']
    // private
    function GetHost: String;
    procedure SetHost(const AValue: String);
    function GetPort: Integer;
    procedure SetPortI(const AValue: Integer);
    function GetTimeout: Integer;
    procedure SetTimeout(const AValue: Integer);
    // public
    property Host: String read GetHost write SetHost;
    property Port: Integer read GetPort write SetPortI;
    property Timeout: Integer read GetTimeout write SetTimeout;
  end;

  IADMoniCustomClient = interface (IADMoniClient)
    ['{3E9B315B-F456-4175-A864-B2573C4A2030}']
    // private
    function GetSynchronize: Boolean;
    procedure SetSynchronize(AValue: Boolean);
    // public
    property Synchronize: Boolean read GetSynchronize write SetSynchronize;
  end;

  IADMoniFlatFileClient = interface (IADMoniCustomClient)
    ['{3E9B315B-F456-4175-A864-B2573C4A2027}']
    // private
    function GetFileName: String;
    procedure SetFileName(const Value: String);
    function GetFileAppend: Boolean;
    procedure SetFileAppend(const Value: Boolean);
    function GetFileColumns: TADTraceFileColumns;
    procedure SetFileColumns(const Value: TADTraceFileColumns);
    function GetFileEncoding: TADEncoding;
    procedure SetFileEncoding(const AValue: TADEncoding);
    // public
    property FileName: String read GetFileName write SetFileName;
    property FileAppend: Boolean read GetFileAppend write SetFileAppend;
    property FileColumns: TADTraceFileColumns read GetFileColumns write SetFileColumns;
    property FileEncoding: TADEncoding read GetFileEncoding write SetFileEncoding;
  end;
{$ENDIF}

  TADMoniAdapterItemKind = (ikSQL, ikParam, ikStat, ikClientInfo, ikSessionInfo,
    ikAnyDACInfo);
  TADMoniAdapterItemKinds = set of TADMoniAdapterItemKind;
  TADMoniAdapterHelper = class(TObject)
  private
    FProxy: IADStanObject;
    FRole: TComponentName;
    FHandle: LongWord;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FAdaptedObj: TObject;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FParentObj: TObject;
{$IFDEF AnyDAC_MONITOR}
    FMoniClient: IADMoniClient;
{$ENDIF}
    function GetIsRegistered: Boolean;
    function GetName: TComponentName;
    function GetParent: IADStanObject;
  public
    constructor Create(const AAdapterObj, AParentObj: TObject);
    destructor Destroy; override;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
{$IFDEF AnyDAC_MONITOR}
    procedure RegisterClient(const AMoniClient: IADMoniClient);
    procedure UnRegisterClient;
{$ENDIF}
    property IsRegistered: Boolean read GetIsRegistered;
    property Name: TComponentName read GetName;
    property Parent: IADStanObject read GetParent;
    property Handle: LongWord read FHandle;
  end;

  IADMoniAdapter = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2006}']
    // private
    function GetHandle: LongWord;
    function GetItemCount: Integer;
    function GetSupportItems: TADMoniAdapterItemKinds;
    // public
    procedure GetItem(AIndex: Integer; out AName: String; out AValue: Variant;
      out AKind: TADMoniAdapterItemKind);
    property Handle: LongWord read GetHandle;
    property ItemCount: Integer read GetItemCount;
    property SupportItems: TADMoniAdapterItemKinds read GetSupportItems;
  end;

  // next GUID -> xxx031

const
{$IFNDEF AnyDAC_D6Base}
  varInt64 = VT_DECIMAL;
{$ENDIF}
{$IFNDEF AnyDAC_D12}
  varADString = varString;
  varADAString = varString;
  varADWString = varOleStr;
{$ELSE}
  varADString = varUString;
  varADAString = {$IFDEF NEXTGEN} varUString {$ELSE} varString {$ENDIF};
  varADWString = varUString;
{$ENDIF}
{$IFNDEF AnyDAC_D11}
  SizeOfFraction = 32;
{$ENDIF}  
{$IFNDEF AnyDAC_D7}
  MinsPerHour = 60;
  SecsPerMin = 60;
  MSecsPerSec = 1000;
{$ENDIF}
{$IFNDEF AnyDAC_D6}
  HoursPerDay = 24;
  MinsPerDay = HoursPerDay * MinsPerHour;
{$ENDIF}
{$IFNDEF AnyDAC_D12}
  SecsPerHour = SecsPerMin * MinsPerHour;
{$ENDIF}
{$IFNDEF AnyDAC_D6Base}
  MaxFMTBcdFractionSize = 32;
{$ENDIF}
  C_AD_MaxInt64: Int64 = 9223372036854775807;
  C_AD_MinInt64: Int64 = -9223372036854775807;
  C_AD_MaxUTF8Len = 3;

implementation

{ ----------------------------------------------------------------------------- }
{ TADValWrapper                                                                 }
{ ----------------------------------------------------------------------------- }
constructor TADValWrapper.Create(APtr: Pointer);
begin
  inherited Create;
  FVal := TADNativeUInt(APtr);
end;

{ ----------------------------------------------------------------------------- }
constructor TADValWrapper.Create(AVal: LongWord);
begin
  inherited Create;
  FVal := TADNativeUInt(AVal);
end;

{ ----------------------------------------------------------------------------- }
function TADValWrapper.GetInt: Integer;
begin
  Result := Integer(FVal);
end;

{ ----------------------------------------------------------------------------- }
function TADValWrapper.GetPtr: Pointer;
begin
  Result := Pointer(FVal);
end;

{ ----------------------------------------------------------------------------- }
{ TADStringList                                                                 }
{ ----------------------------------------------------------------------------- }
procedure TADStringList.AddPtr(const AStr: String; APtr: Pointer);
begin
{$IFDEF AUTOREFCOUNT}
  AddObject(AStr, TADValWrapper.Create(APtr));
{$ELSE}
  AddObject(AStr, TObject(APtr));
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
procedure TADStringList.AddInt(const AStr: String; AInt: LongWord);
begin
{$IFDEF AUTOREFCOUNT}
  AddObject(AStr, TADValWrapper.Create(AInt));
{$ELSE}
  AddObject(AStr, TObject(AInt));
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
function TADStringList.GetPtrs(AIndex: Integer): Pointer;
begin
{$IFDEF AUTOREFCOUNT}
  Result := Pointer(TADValWrapper(inherited Objects[AIndex]).FVal);
{$ELSE}
  Result := Pointer(inherited Objects[AIndex]);
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
procedure TADStringList.SetPtrs(AIndex: Integer; const AValue: Pointer);
begin
{$IFDEF AUTOREFCOUNT}
  inherited Objects[AIndex] := TADValWrapper.Create(AValue);
{$ELSE}
  inherited Objects[AIndex] := TObject(AValue);
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
function TADStringList.GetInts(AIndex: Integer): LongWord;
begin
{$IFDEF AUTOREFCOUNT}
  Result := LongWord(TADValWrapper(inherited Objects[AIndex]).FVal);
{$ELSE}
  Result := LongWord(Pointer(inherited Objects[AIndex]));
{$ENDIF}
end;

{ ----------------------------------------------------------------------------- }
procedure TADStringList.SetInts(AIndex: Integer; const AValue: LongWord);
begin
{$IFDEF AUTOREFCOUNT}
  inherited Objects[AIndex] := TADValWrapper.Create(AValue);
{$ELSE}
  inherited Objects[AIndex] := TObject(AValue);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_NOLOCALE_META}
  {$IFDEF AnyDAC_D6}
function TADStringList.CompareStrings(const S1, S2: string): Integer;
begin
  if CaseSensitive then
    Result := CompareStr(S1, S2)
  else
    Result := CompareText(S1, S2);
end;
  {$ENDIF}
{$ENDIF}

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D6}
type
  __TStrings = class(TPersistent)
  private
  {$IFDEF AnyDAC_FPC}
    FSpecialCharsInited : boolean;
    FQuoteChar : Char;
    FDelimiter : Char;
    FNameValueSeparator : Char;
  {$ENDIF}
    FUpdateCount: Integer;
  end;

function TADStringList.GetUpdateCount: Integer;
begin
  Result := __TStrings(Self).FUpdateCount;
end;
{$ENDIF}

{ ----------------------------------------------------------------------------- }
{ TADComponent                                                                  }
{ ----------------------------------------------------------------------------- }
{$IFNDEF AnyDAC_D6}
function TADComponent.GetComponent: TComponent;
begin
  Result := Self;
end;
{$ENDIF}

{ ----------------------------------------------------------------------------- }
{ TADPhysMoniAdapterComponentProxy                                              }
{ ----------------------------------------------------------------------------- }
type
  TADMoniAdapterComponentProxy = class(TInterfacedObject, IADStanObject)
  private
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FComp: TComponent;
  protected
    // IADStanObject
    function GetName: TComponentName;
    function GetParent: IADStanObject;
    procedure BeforeReuse;
    procedure AfterReuse;
    procedure SetOwner(const AOwner: TObject; const ARole: TComponentName);
  public
    constructor Create(AComp: TComponent);
    destructor Destroy; override;
  end;

{ ----------------------------------------------------------------------------- }
constructor TADMoniAdapterComponentProxy.Create(AComp: TComponent);
begin
  inherited Create;
  FComp := AComp;
end;

{ ----------------------------------------------------------------------------- }
destructor TADMoniAdapterComponentProxy.Destroy;
begin
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniAdapterComponentProxy.GetName: TComponentName;
begin
  if FComp.GetNamePath = '' then
    Result := FComp.ClassName + '($' + IntToHex(Integer(FComp), 8) + ')'
  else
    Result := FComp.GetNamePath;
end;

{ ----------------------------------------------------------------------------- }
function TADMoniAdapterComponentProxy.GetParent: IADStanObject;

  function IsApp(AComp: TComponent): Boolean;
  var
    oClass: TClass;
  begin
    oClass := AComp.ClassType;
    while (oClass <> nil) and not oClass.ClassNameIs('TApplication') do
      oClass := oClass.ClassParent;
    Result := (oClass <> nil);
  end;

begin
  Result := nil;
  if (FComp.Owner <> nil) and not IsApp(FComp.Owner) then
    if FComp.Owner.GetInterfaceEntry(IADStanObject) = nil then
      Result := TADMoniAdapterComponentProxy.Create(FComp.Owner) as IADStanObject
    else
      Supports(FComp.Owner, IADStanObject, Result);
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniAdapterComponentProxy.BeforeReuse;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniAdapterComponentProxy.AfterReuse;
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniAdapterComponentProxy.SetOwner(
  const AOwner: TObject; const ARole: TComponentName);
begin
  // nothing
end;

{ ----------------------------------------------------------------------------- }
{ TADMoniAdapterHelper                                                          }
{ ----------------------------------------------------------------------------- }
constructor TADMoniAdapterHelper.Create(const AAdapterObj, AParentObj: TObject);
begin
  inherited Create;
  FAdaptedObj := AAdapterObj;
  FParentObj := AParentObj;
end;

{ ----------------------------------------------------------------------------- }
destructor TADMoniAdapterHelper.Destroy;
{$IFDEF AnyDAC_MONITOR}
var
  oIntf: IADMoniAdapter;
{$ENDIF}
begin
{$IFDEF AnyDAC_MONITOR}
  if (FMoniClient <> nil) and (FHandle <> 0) then begin
    if Supports(FAdaptedObj, IADMoniAdapter, oIntf) then
      FMoniClient.UnregisterAdapter(oIntf);
  end;
  FProxy := nil;
{$ENDIF}
  inherited Destroy;
end;

{ ----------------------------------------------------------------------------- }
procedure TADMoniAdapterHelper.SetOwner(const AOwner: TObject;
  const ARole: TComponentName);
begin
  if AOwner is TComponent then begin
    FProxy := TADMoniAdapterComponentProxy.Create(TComponent(AOwner));
    FParentObj := nil;
  end
  else begin
    FProxy := nil;
    FParentObj := AOwner;
  end;
  FRole := ARole;
end;

{-------------------------------------------------------------------------------}
function TADMoniAdapterHelper.GetIsRegistered: Boolean;
begin
{$IFDEF AnyDAC_MONITOR}
  Result := FHandle <> 0;
{$ELSE}
  Result := False;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_MONITOR}
procedure TADMoniAdapterHelper.RegisterClient(const AMoniClient: IADMoniClient);
var
  oIntf: IADMoniAdapter;
begin
  if not IsRegistered and (AMoniClient <> nil) and AMoniClient.Tracing then begin
    FMoniClient := AMoniClient;
    if Supports(FAdaptedObj, IADMoniAdapter, oIntf) then begin
      FHandle := FMoniClient.RegisterAdapter(oIntf);
      FMoniClient.AdapterChanged(oIntf);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMoniAdapterHelper.UnRegisterClient;
var
  oIntf: IADMoniAdapter;
begin
  if IsRegistered and (FMoniClient <> nil) then
    try
      if Supports(FAdaptedObj, IADMoniAdapter, oIntf) then
        FMoniClient.UnregisterAdapter(oIntf);
    finally
      FHandle := 0;
    end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADMoniAdapterHelper.GetName: TComponentName;
begin
  if FProxy <> nil then
    Result := FProxy.Name
  else
    Result := FAdaptedObj.ClassName + '($' + IntToHex(Integer(FAdaptedObj), 8) + ')';
  if FRole <> '' then
    Result := FRole + ': ' + Result;
end;

{-------------------------------------------------------------------------------}
function TADMoniAdapterHelper.GetParent: IADStanObject;
begin
  if FProxy <> nil then
    Result := FProxy.Parent
  else
    Supports(FParentObj, IADStanObject, Result);
end;

end.

