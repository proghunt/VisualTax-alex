{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{          FireDAC Local Data Storage classes           }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADDatSManager;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  Classes,
  uADStanIntf, uADStanError, uADStanUtil, uADStanStorage, uADStanConst,
    uADStanOption;

type
  TADDatSObject = class;
  TADDatSObjectClass = class of TADDatSObject;
  TADDatSNamedObject = class;
  TADDatSList = class;
  TADDatSNamedList = class;
  TADDatSColumn = class;
  TADDatSColumnList = class;
  TADDatSColumnSublist = class;
  TADDatSConstraintBase = class;
  TADDatSConstraintList = class;
  TADDatSUniqueConstraint = class;
  TADDatSForeignKeyConstraint = class;
  TADDatSCheckConstraint = class;
  TADDatSRelation = class;
  TADDatSRelationList = class;
  TADDatSMechBase = class;
  TADDatSViewMechList = class;
  TADDatSMechSort = class;
  TADDatSMechRowState = class;
  TADDatSMechRange = class;
  TADDatSMechDistinct = class;
  TADDatSMechFilter = class;
  TADDatSMechError = class;
  TADDatSMechDetails = class;
  TADDatSMechChilds = class;
  TADDatSMechMaster = class;
  TADDatSMechParent = class;
  TADDatSRow = class;
  TADDatSRowListBase = class;
  TADDatSNestedRowList = class;
  TADDatSTableRowList = class;
  TADDatSViewRowList = class;
  TADDatSView = class;
  TADDatSViewList = class;
  TADDatSAggregateValue = class;
  TADDatSAggregate = class;
  TADDatSAggregateList = class;
  TADDatSTable = class;
  TADDatSTableList = class;
  TADDatSUpdatesJournal = class;
  TADDatSManager = class;

  IADDatSMechSort = interface;
  IADDatSTableMetadataCallback = interface;
  IADDatSTableDataCallback = interface;

  TADDatSNotificationKind = (
    snObjectInserting, snObjectInserted, snObjectRemoving, snObjectRemoved,
    snColumnDefChanged, snObjectNameChanged, snMechanismStateChanged,
    snViewUpdated, snRowStateChanged, snRowErrorStateChanged, snRowDataChanged);
  TADDatSNotificationReason = (srMetaChange, srDataChange);

  TADDatSColumnThings = set of (ctCalcs, ctExps, ctDefs, ctInvars, ctComp,
    ctAutoIncs, ctSerializing);

  TADDatSColumnsCalculateEvent = procedure (ARow: TADDatSRow) of object;

  TADDatSMechanismKind = (mkFilter, mkSort, mkHasList, mkHasRow, mkPost);
  TADDatSMechanismKinds = set of TADDatSMechanismKind;

  TADDatSRowVersion = (rvDefault, rvCurrent, rvOriginal, rvPrevious, rvProposed);
  TADDatSRowState = (
    rsInitializing,
    rsDetached, rsInserted, rsDeleted, rsModified, rsUnchanged,
    rsEditing, rsCalculating, rsChecking, rsDestroying, rsForceWrite,
    rsImportingCurent, rsImportingOriginal, rsImportingProposed);
  TADDatSRowStates = set of TADDatSRowState;

  TADDatSProcessNestedRowsMethod = procedure (ARow: TADDatSRow) of object;

  TADDatSConstraintRule = (crCascade, crRestrict, crNullify);
  TADDatSConstraintARRule = (arNone, arCascade);

  TADDatSMergeOption = (goNone);
  TADDatSMergeOptions = set of TADDatSMergeOption;

  TADDatSViewState = (vsOutdated);
  TADDatSViewStates = set of TADDatSViewState;

  TADDatSViewCreator = (
    vcUser,
    vcUniqueConstraint, vcForeignKeyConstraint, vcChildRelation,
      vcDefaultView, vcErrorView, vcChangesView, vcSelectView,
    vcDataSetIndex, vcDataSetTempIndex, vcDataSetFilter, vsDataSetDelta);
  TADDatSViewProcessRowStatus = (psAccepted, psRejected, psUnchanged);

  TADDatSGroupPosition = (gpFirst, gpMiddle, gpLast);
  TADDatSGroupPositions = set of TADDatSGroupPosition;

  TADCompareRowsProc = function (ARow1, ARow2: TADDatSRow;
    AColumnCount: Integer; AOptions: TADCompareDataOptions): Integer of object;

  TADFilterRowEvent = function (AMech: TADDatSMechFilter; ARow: TADDatSRow;
    AVersion: TADDatSRowVersion): Boolean of object;

  TADDatSHandleMode = (lmStandard, lmMove, lmHavyMove, lmFetching,
    lmHavyFetching, lmDestroying, lmRefreshing, lmHavyLoading);
  PADDatSLoadState = ^TADDatSLoadState;
  TADDatSLoadState = record
    FRestoreState: Boolean;
    FPrevMode: TADDatSHandleMode;
    FViewsActive: Boolean;
    FConstraintsEnforce: Boolean;
    FSubStates: array of PADDatSLoadState;
  end;
  TADDatSLoadStates = array of TADDatSLoadState;

  TADDatSCheckTime = (ctAtEditEnd, ctAtColumnChange);

  TADDatSNotifyParam = record
    FKind: TADDatSNotificationKind;
    FReason: TADDatSNotificationReason;
    FParam1, FParam2: TADNativeInt;
  end;
  PADDatSNotifyParam = ^TADDatSNotifyParam;

  PADDataObject = ^TADDatSObject;
  TADDatSObject = class (TADStorableObject)
  private
    {$IFDEF AUTOREFCOUNT} [weak] {$ENDIF} FOwner: TADDatSObject;
    FLockNotificationCount: Word;
    // following fields must be in TADDatSRow, but moved
    // here to pack FLockNotificationCount, FRowPriorState and
    // FRowState into double word
    FRowPriorState: TADDatSRowState;
    FRowState: TADDatSRowState;
  protected
    function GetList: TADDatSList; virtual;
    function GetOwnerByClass(AClass: TADDatSObjectClass): TADDatSObject;
    function GetManager: TADDatSManager; virtual;
    function GetTable: TADDatSTable; virtual;
    procedure HandleNotification(AParam: PADDatSNotifyParam); virtual;
    procedure Notify(AParam: PADDatSNotifyParam); overload; virtual;
    procedure Notify(AKind: TADDatSNotificationKind;
      AReason: TADDatSNotificationReason; AParam1, AParam2: TADNativeInt); overload;
    procedure LockNotification;
    procedure UnlockNotification;
    procedure DoListInserted; virtual;
    procedure DoListInserting; virtual;
    procedure DoListRemoved(ANewOwner: TADDatSObject); virtual;
    procedure DoListRemoving; virtual;
    function GetIndex: Integer; virtual;
    class function GetClassPrefix: String; override;
  public
    constructor Create; overload; override;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); virtual;
    function IsEqualTo(AObj: TADDatSObject): Boolean; virtual;
    function IndexOf(AObj: TADDatSObject): Integer; overload; virtual;
    property Index: Integer read GetIndex;
    property Owner: TADDatSObject read FOwner;
    property List: TADDatSList read GetList;
    property Manager: TADDatSManager read GetManager;
    property Table: TADDatSTable read GetTable;
  end;

  TADDatSNamedObject = class (TADDatSObject)
  private
    FName: String;
    FPrevName: String;
    function GetNamedList: TADDatSNamedList;
    procedure SetName(const AValue: String);
    function GetDefaultName: String;
    function GetIsDefaultName: Boolean;
  protected
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
    property PrevName: String read FPrevName;
    property DefaultName: String read GetDefaultName;
    property IsDefaultName: Boolean read GetIsDefaultName;
  public
    constructor Create; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property Name: String read FName write SetName;
    property NamedList: TADDatSNamedList read GetNamedList;
  end;

  TADDatSBindedObject = class (TADDatSNamedObject)
  private
    FSourceName: String;
    FSourceID: Integer;
  protected
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; override;
    procedure Assign(AObj: TADDatSObject); override;
    property SourceName: String read FSourceName write FSourceName;
    property SourceID: Integer read FSourceID write FSourceID;
  end;

  TADDatSList = class (TADDatSObject)
  private
    FArray: array of TADDatSObject;
    FCapacity, FCount: Integer;
    FOwnObjects: Boolean;
    FMinimumCapacity: Integer;
    function GetItemsI(AIndex: Integer): TADDatSObject; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    procedure SetCapacity(const AValue: Integer);
    procedure SetMinimumCapacity(const AValue: Integer);
  protected
    FDefaultReason: TADDatSNotificationReason;
    procedure AddEx(AObj: TADDatSObject);
    function AddObject(AObj: TADDatSObject): Integer; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    procedure AddObjectAt(AObj: TADDatSObject; AIndex: Integer); virtual;
    procedure Notify(AParam: PADDatSNotifyParam); override;
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
    procedure Copy(ASource: TADDatSList);
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
    property Capacity: Integer read FCapacity write SetCapacity;
  public
    constructor Create; overload; override;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    procedure Clear; virtual;
    function ContainsObj(AObj: TADDatSObject): Boolean;
    function IndexOf(AObj: TADDatSObject): Integer; override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    function Remove(AObj: TADDatSObject; ANotDestroy: Boolean = False): Integer;
    procedure RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False); virtual;
    procedure MoveTo(AFromIndex, AToIndex: Integer);
    property Count: Integer read FCount;
    property ItemsI[AIndex: Integer]: TADDatSObject read GetItemsI; default;
    property OwnObjects: Boolean read FOwnObjects write FOwnObjects default False;
    property MinimumCapacity: Integer read FMinimumCapacity write SetMinimumCapacity default 0;
  end;

  TADDatSNamedList = class (TADDatSList)
  private
    FNamesIndex: TADStringList;
    function GetItemsI(AIndex: Integer): TADDatSNamedObject; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    function Find(const AName: String; out AIndex: Integer): Boolean;
    function FindRealIndex(const AName: String; out AIndex: Integer): Boolean;
    procedure ErrorNameNotFound(const AName: String);
  protected
    procedure CheckUniqueName(const AName: String; ASelf: TADDatSNamedObject);
    procedure Notify(AParam: PADDatSNotifyParam); override;
    procedure AddObjectAt(AObj: TADDatSObject; AIndex: Integer); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; overload; override;
    destructor Destroy; override;
    function ContainsName(const AName: String): Boolean;
    function IndexOfName(const AName: String): Integer;
    function ItemByName(const AName: String): TADDatSNamedObject;
    procedure RemoveByName(const AName: String);
    function BuildUniqueName(const AName: String): String;
    property ItemsI[AIndex: Integer]: TADDatSNamedObject read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSNamedObject read ItemByName;
  end;

  TADDatSBindedList = class (TADDatSNamedList)
  private
    function GetItemsI(AIndex: Integer): TADDatSBindedObject; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
  public
    function ItemByName(const AName: String): TADDatSBindedObject;
    function IndexOfSourceID(AID: Integer): Integer;
    function IndexOfSourceName(const AName: String): Integer;
    property ItemsI[AIndex: Integer]: TADDatSBindedObject read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSBindedObject read ItemByName;
  end;

  TADDatSColumn = class (TADDatSBindedObject)
  private
    FIndex: Integer;
    FAttributes: TADDataAttributes;
    FAutoIncrement: Boolean;
    FAutoIncrementSeed: Integer;
    FAutoIncrementStep: Integer;
    FCaption: String;
    FDataType: TADDataType;
    FExpression: String;
    FOptions: TADDataOptions;
    FPrecision: Integer;
    FSize: LongWord;
    FEvaluator: IADStanExpressionEvaluator;
    FScale: Integer;
    FSourceDataType: TADDataType;
    FSourcePrecision: Integer;
    FSourceScale: Integer;
    FSourceSize: LongWord;
    FSourceDataTypeName: String;
    FOriginTabName: String;
    FOriginColName: String;
    FSourceGenerator: String;
    function GetCaption: String;
    function GetColumnList: TADDatSColumnList;
    function GetReadOnly: Boolean;
    procedure SetAttributes(const AValue: TADDataAttributes);
    procedure SetAutoIncrement(const AValue: Boolean);
    procedure SetAutoIncrementSeed(const AValue: Integer);
    procedure SetAutoIncrementStep(const AValue: Integer);
    procedure SetCaption(const AValue: String);
    procedure SetDataType(const AValue: TADDataType);
    procedure SetExpression(const AValue: String);
    procedure SetEvaluator(const AValue: IADStanExpressionEvaluator);
    procedure SetOptions(const AValue: TADDataOptions);
    procedure SetPrecision(const AValue: Integer);
    procedure SetSize(const AValue: LongWord);
    procedure SetScale(const AValue: Integer);
    function GetNestedTable: TADDatSTable;
    function GetParentColumn: TADDatSColumn;
    function GetAllowDBNull: Boolean;
    procedure SetAllowDBNull(const AValue: Boolean);
    function GetUnique: Boolean;
    procedure SetUnique(const AValue: Boolean);
    procedure UpdateUniqueKey(AUnique: Boolean);
    procedure SetReadOnly(const AValue: Boolean);
    procedure DefinitionChanging(ALayoutChanging: Boolean);
    procedure SetServerAutoIncrement(const Value: Boolean);
    function GetDisplayWidth: Integer;
    function GetStorageSize: Integer;
    function GetServerAutoIncrement: Boolean;
    procedure SetSourceGenerator(const AValue: String);
    function GetActualCaption: String;
    function GetActualAttributes: TADDataAttributes;
    function GetActualOptions: TADDataOptions;
    function GetActualOriginColName: String;
    function GetActualGenerator: String;
  protected
    procedure DefinitionChanged(ALayoutChanged: Boolean);
    procedure Notify(AParam: PADDatSNotifyParam); override;
    procedure DoListInserting; override;
    procedure DoListInserted; override;
    procedure DoListRemoving; override;
    function GetIndex: Integer; override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; overload; override;
    constructor Create(const AName: String; AType: TADDataType = dtAnsiString;
      const AExpression: String = ''); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsAutoIncrementType(const AValue: TADDataType): Boolean;
    // ro
    property ColumnList: TADDatSColumnList read GetColumnList;
    property DisplayWidth: Integer read GetDisplayWidth;
    property Index: Integer read GetIndex;
    property NestedTable: TADDatSTable read GetNestedTable;
    property ParentColumn: TADDatSColumn read GetParentColumn;
    property StorageSize: Integer read GetStorageSize;
    property ActualCaption: String read GetActualCaption;
    property ActualOptions: TADDataOptions read GetActualOptions;
    property ActualAttributes: TADDataAttributes read GetActualAttributes;
    property ActualOriginTabName: String read FOriginTabName;
    property ActualOriginColName: String read GetActualOriginColName;
    property ActualGenerator: String read GetActualGenerator;
    // rw
    property AllowDBNull: Boolean read GetAllowDBNull write SetAllowDBNull
      default True;
    property Attributes: TADDataAttributes read FAttributes write
      SetAttributes default [caAllowNull];
    property AutoIncrement: Boolean read FAutoIncrement write SetAutoIncrement
      default False;
    property ServerAutoIncrement: Boolean read GetServerAutoIncrement
      write SetServerAutoIncrement default False;
    property AutoIncrementSeed: Integer read FAutoIncrementSeed write
      SetAutoIncrementSeed default 1;
    property AutoIncrementStep: Integer read FAutoIncrementStep write
      SetAutoIncrementStep default 1;
    property Caption: String read GetCaption write SetCaption;
    property DataType: TADDataType read FDataType write SetDataType
      default dtUnknown;
    property Expression: String read FExpression write SetExpression;
    property Evaluator: IADStanExpressionEvaluator read FEvaluator write SetEvaluator;
    property Options: TADDataOptions read FOptions write SetOptions
      default [coAllowNull, coInUpdate, coInWhere];
    property Precision: Integer read FPrecision write SetPrecision default 0;
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly default False;
    property Scale: Integer read FScale write SetScale default 0;
    property Size: LongWord read FSize write SetSize default 50;
    property SourceDataType: TADDataType read FSourceDataType write FSourceDataType;
    property SourcePrecision: Integer read FSourcePrecision write FSourcePrecision;
    property SourceScale: Integer read FSourceScale write FSourceScale;
    property SourceSize: LongWord read FSourceSize write FSourceSize;
    property SourceDataTypeName: String read FSourceDataTypeName
      write FSourceDataTypeName;
    property SourceDirectory: String read FSourceDataTypeName
      write FSourceDataTypeName;
    property SourceGenerator: String read FSourceGenerator
      write SetSourceGenerator;
    property OriginTabName: String read FOriginTabName write FOriginTabName;
    property OriginColName: String read FOriginColName write FOriginColName;
    property Unique: Boolean read GetUnique write SetUnique default False;
  end;

  TADDatSTableExpressionDS = class(TInterfacedObject, IADStanExpressionDataSource)
  private
    FTable: TADDatSTable;
    FRow: TADDatSRow;
  protected
    // IADStanExpressionDataSource
    function GetVarIndex(const AName: String): Integer; virtual;
    function GetVarType(AIndex: Integer): TADDataType; virtual;
    function GetVarScope(AIndex: Integer): TADExpressionScopeKind; virtual;
    function GetVarData(AIndex: Integer): Variant; virtual;
    procedure SetVarData(AIndex: Integer; const AValue: Variant); virtual;
    function GetSubAggregateValue(AIndex: Integer): Variant; virtual;
    function GetPosition: Pointer; virtual;
    procedure SetPosition(AValue: Pointer); virtual;
    function GetRowNum: Integer; virtual;
    function GetDatabase: String; virtual;
    function GetUser: String; virtual;
  public
    constructor Create(ATable: TADDatSTable);
  end;

  TADArrayOfInteger = array of Integer;
  TADArrayOfLongWord = array of LongWord;
  TADArrayOfByte = array of Byte;
  TADDatSColumnList = class (TADDatSBindedList)
  private
    FAutoIncs: TADArrayOfInteger;
    FDataOffsets: TADArrayOfLongWord;
    FNullOffsets: TADArrayOfLongWord;
    FNullMasks: TADArrayOfByte;
    FFetchedOffset: Integer;
    FFetchedSize: Integer;
    FInvariantMap: TADArrayOfInteger;
    FInvariantOffset: Integer;
    FInvariantSize: Integer;
    FInvariants: Integer;
    FParentRowRefCol: Integer;
    FParentCol: Integer;
    FHasThings: TADDatSColumnThings;
    FOnCalcColumns: TADDatSColumnsCalculateEvent;
    FInlineDataSize: Word;
    FRowsInstSize: LongWord;
    function GetCurrValues(AIndex: Integer): Variant;
    function GetItemsI(AIndex: Integer): TADDatSColumn; {$IFDEF AnyDAC_D12} inline; {$ENDIF}
    procedure UpdateLayout(ARowInstanceSize: Integer);
    procedure SetInlineDataSize(const AValue: Word);
    function GetStorageSize: LongWord;
  protected
    procedure CheckUpdateLayout(ARowInstanceSize: Integer);
    procedure TerminateLayout;
    procedure Notify(AParam: PADDatSNotifyParam); override;
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
    procedure AddObjectAt(AObj: TADDatSObject; AIndex: Integer); override;
    procedure FixAutoIncs(ARow: TADDatSRow);
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor CreateForTable(ATable: TADDatSTable);
    procedure Assign(AObj: TADDatSObject); override;
    function Add(AObj: TADDatSColumn): Integer; overload;
    function Add(const AName: String; AType: TADDataType = dtAnsiString;
      const AExpression: String = ''): TADDatSColumn; overload;
    procedure RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False); override;
    function ColumnByName(const AName: String): TADDatSColumn;
    property CurrValues[AIndex: Integer]: Variant read GetCurrValues;
    property ItemsI[AIndex: Integer]: TADDatSColumn read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSColumn read ColumnByName;
    property DataOffsets: TADArrayOfLongWord read FDataOffsets;
    property NullOffsets: TADArrayOfLongWord read FNullOffsets;
    property NullMasks: TADArrayOfByte read FNullMasks;
    property ParentRowRefCol: Integer read FParentRowRefCol;
    property ParentCol: Integer read FParentCol;
    property StorageSize: LongWord read GetStorageSize;
    property RowsInstSize: LongWord read FRowsInstSize;
    property HasThings: TADDatSColumnThings read FHasThings;
    property OnCalcColumns: TADDatSColumnsCalculateEvent read FOnCalcColumns
      write FOnCalcColumns;
    property InlineDataSize: Word read FInlineDataSize write SetInlineDataSize
      default C_AD_DefInlineDataSize;
  end;

  TADDatSColumnSublist = class (TObject)
  private
    FArray: array of TADDatSColumn;
    FNames: String;
    function GetCount: Integer; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    // "inlined" in D < 12 gives warning
    function GetItemsI(AIndex: Integer): TADDatSColumn; {$IFDEF AnyDAC_D12} inline; {$ENDIF}
    procedure Add(ACol: TADDatSColumn);
  public
    function HandleNotification(AParam: PADDatSNotifyParam): Boolean;
    procedure Clear;
    procedure Fill(AObject: TADDatSObject; const AFields: String;
      ACaseInsensitiveColumnList: TADDatSColumnSublist = nil;
      ADescendingColumnList: TADDatSColumnSublist = nil);
    function IndexOf(AColumn: TADDatSColumn): Integer;
    function IndexOfName(const AName: String): Integer;
    function FindColumn(const AName: String): TADDatSColumn;
    function Matches(AList: TADDatSColumnSublist; ACount: Integer = -1): Boolean;
    property Count: Integer read GetCount;
    property ItemsI[AIndex: Integer]: TADDatSColumn read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSColumn read FindColumn;
    property Names: String read FNames;
  end;

  TADDatSConstraintBase = class (TADDatSNamedObject)
  private
    FEnforce: Boolean;
    FLastActualEnforce: Boolean;
    FMessage: String;
    FCheckTime: TADDatSCheckTime;
    FRely: Boolean;
    function GetActualEnforce: Boolean;
    function GetConstraintList: TADDatSConstraintList;
    procedure SetEnforce(const AValue: Boolean);
    procedure ResolveEnforce(const AName, AValue: String);
  protected
    procedure DoCheck(ARow: TADDatSRow; AProposedState:
      TADDatSRowState); virtual;
    procedure DoListInserted; override;
    procedure DoListRemoved(ANewOwner: TADDatSObject); override;
    procedure DoEnforceUpdated; virtual;
    procedure EnforceUpdated;
    function CheckRow(ARow: TADDatSRow): Boolean; virtual;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; overload; override;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    procedure Check(ARow: TADDatSRow; AProposedState: TADDatSRowState;
      ATime: TADDatSCheckTime);
    procedure CheckAll;
    property ActualEnforce: Boolean read GetActualEnforce;
    property ConstraintList: TADDatSConstraintList read GetConstraintList;
    property Enforce: Boolean read FEnforce write SetEnforce default True;
    property Rely: Boolean read FRely write FRely default True;
    property CheckTime: TADDatSCheckTime read FCheckTime write FCheckTime default ctAtEditEnd;
    property Message: String read FMessage write FMessage;
  end;

  TADDatSConstraintList = class (TADDatSNamedList)
  private
    FEnforce: Boolean;
    function GetItemsI(AIndex: Integer): TADDatSConstraintBase; {$IFDEF AnyDAC_D12} inline; {$ENDIF}
    procedure SetEnforce(const AValue: Boolean);
    procedure ResolveEnforce(const AName, AValue: String);
  protected
    procedure EnforceUpdated;
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor CreateForTable(ATable: TADDatSTable);
    procedure Assign(AObj: TADDatSObject); override;
    function Add(AObj: TADDatSConstraintBase): Integer; overload;
    // UK
    function AddUK(const AName: String; AColumn: TADDatSColumn;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSUniqueConstraint; overload;
    function AddUK(const AName: String; const AColumns: array of TADDatSColumn;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSUniqueConstraint; overload;
    function AddUK(const AName: String; const AColumnNames: String;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSUniqueConstraint; overload;
    // FK
    function AddFK(const AName: String; APrimaryKeyColumn,
      AForeignKeyColumn: TADDatSColumn): TADDatSForeignKeyConstraint; overload;
    function AddFK(const AName: String; const APrimaryKeyColumns,
      AForeignKeyColumns: array of TADDatSColumn): TADDatSForeignKeyConstraint; overload;
    function AddFK(const AName: String; const AParentTableName, APrimaryKeyColumns,
      AForeignKeyColumns: String): TADDatSForeignKeyConstraint; overload;
    function AddFK(const AName: String; AParentTable: TADDatSTable;
      const APrimaryKeyColumns, AForeignKeyColumns: String): TADDatSForeignKeyConstraint; overload;
    // CHK
    function AddChk(const AName, AExpression: String; const AMessage: String = '';
      ACheckTime: TADDatSCheckTime = ctAtEditEnd): TADDatSCheckConstraint; overload;
    procedure Check(ARow: TADDatSRow; AProposedState: TADDatSRowState;
      ATime: TADDatSCheckTime);
    function ConstraintByName(const AName: String): TADDatSConstraintBase;
    function FindUnique(const AFields: String): TADDatSUniqueConstraint;
    function FindPrimaryKey: TADDatSUniqueConstraint;
    procedure CheckAll;
    property Enforce: Boolean read FEnforce write SetEnforce default True;
    property ItemsI[AIndex: Integer]: TADDatSConstraintBase read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSConstraintBase read ConstraintByName;
  end;

  TADDatSUniqueConstraint = class (TADDatSConstraintBase)
  private
    FColumnNames: String;
    FColumns: TADDatSColumnSublist;
    FOptions: TADSortOptions;
    function GetColumnCount: Integer;
    function GetColumns(AIndex: Integer): TADDatSColumn;
    procedure SetColumnNames(const AValue: String);
    procedure SetOptions(const AValue: TADSortOptions);
    function GetIsPrimaryKey: Boolean;
    procedure SetIsPrimaryKey(const AValue: Boolean);
    function GetUniqueSortedView: TADDatSView;
  protected
    procedure DoCheck(ARow: TADDatSRow;
      AProposedState: TADDatSRowState); override;
    procedure DoEnforceUpdated; override;
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; overload; override;
    constructor Create(AColumn: TADDatSColumn;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF}); overload;
    constructor Create(const AColumns: array of TADDatSColumn;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF}); overload;
    constructor Create(const AName: String; AColumn: TADDatSColumn;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF}); overload;
    constructor Create(const AName: String; const AColumns: array of TADDatSColumn;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF}); overload;
    constructor Create(const AName, AColumnNames: String;
      APrimaryKey: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF}); overload;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property ColumnNames: String read FColumnNames write SetColumnNames;
    property ColumnCount: Integer read GetColumnCount;
    property Columns[AIndex: Integer]: TADDatSColumn read GetColumns;
    property Options: TADSortOptions read FOptions write SetOptions default [soUnique];
    property IsPrimaryKey: Boolean read GetIsPrimaryKey write SetIsPrimaryKey;
  end;

  TADDatSForeignKeyConstraint = class (TADDatSConstraintBase)
  private
    FColumnNames: String;
    FColumns: TADDatSColumnSublist;
    FDeleteRule: TADDatSConstraintRule;
    FRelatedColumnNames: String;
    FRelatedColumns: TADDatSColumnSublist;
    FRelatedTable: TADDatSTable;
    FUpdateRule: TADDatSConstraintRule;
    FParentMessage: String;
    FRelatedTableName: String;
    FCascadingRows: TADObjList;
    FAcceptRejectRule: TADDatSConstraintARRule;
    FFieldValueRequired: Boolean;
    FInsertRule: TADDatSConstraintRule;
    function GetColumnCount: Integer;
    function GetColumns(AIndex: Integer): TADDatSColumn;
    function GetRelatedColumnCount: Integer;
    function GetRelatedColumns(AIndex: Integer): TADDatSColumn;
    procedure SetColumnNames(const AValue: String);
    procedure SetRelatedColumnNames(const AValue: String);
    function GetChildSortedView: TADDatSView;
    function GetMasterSortedView: TADDatSView;
    procedure SetRelatedTableName(const AValue: String);
  protected
    function CheckRow(ARow: TADDatSRow): Boolean; override;
    procedure DoCheck(ARow: TADDatSRow; AProposedState:
      TADDatSRowState); override;
    procedure DoInsertAssignParentValues(AParentRow, AChildRow: TADDatSRow);
    procedure DoEnforceUpdated; override;
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; override;
    constructor Create(AParentColumn, AChildColumn: TADDatSColumn;
      ADeleteRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crCascade {$ENDIF};
      AUpdateRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crRestrict {$ENDIF}); overload;
    constructor Create(const AParentColumns, AChildColumns: array of TADDatSColumn;
      ADeleteRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crCascade {$ENDIF};
      AUpdateRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crRestrict {$ENDIF}); overload;
    constructor Create(const AName: String; AParentColumn, AChildColumn: TADDatSColumn;
      ADeleteRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crCascade {$ENDIF};
      AUpdateRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crRestrict {$ENDIF}); overload;
    constructor Create(const AName: String; const AParentColumns, AChildColumns: array of TADDatSColumn;
      ADeleteRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crCascade {$ENDIF};
      AUpdateRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crRestrict {$ENDIF}); overload;
    constructor Create(const AName, AParentTableName, AParentColumnNames,
      AChildColumnNames: String;
      ADeleteRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crCascade {$ENDIF};
      AUpdateRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crRestrict {$ENDIF}); overload;
    constructor Create(const AName: String; AParentTable: TADDatSTable;
      const AParentColumnNames, AChildColumnNames: String;
      ADeleteRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crCascade {$ENDIF};
      AUpdateRule: TADDatSConstraintRule {$IFDEF AnyDAC_D6Base} = crRestrict {$ENDIF}); overload;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    // ro
    property ColumnCount: Integer read GetColumnCount;
    property Columns[AIndex: Integer]: TADDatSColumn read GetColumns;
    property RelatedColumnCount: Integer read GetRelatedColumnCount;
    property RelatedColumns[AIndex: Integer]: TADDatSColumn read GetRelatedColumns;
    property RelatedTable: TADDatSTable read FRelatedTable;
    // rw
    property ColumnNames: String read FColumnNames write SetColumnNames;
    property DeleteRule: TADDatSConstraintRule read FDeleteRule
      write FDeleteRule default crCascade;
    property InsertRule: TADDatSConstraintRule read FInsertRule
      write FInsertRule default crCascade;
    property ParentMessage: String read FParentMessage write FParentMessage;
    property RelatedTableName: String read FRelatedTableName
      write SetRelatedTableName;
    property RelatedColumnNames: String read FRelatedColumnNames
      write SetRelatedColumnNames;
    property UpdateRule: TADDatSConstraintRule read FUpdateRule
      write FUpdateRule default crCascade;
    property AcceptRejectRule: TADDatSConstraintARRule read FAcceptRejectRule
      write FAcceptRejectRule default arCascade;
    property FieldValueRequired: Boolean read FFieldValueRequired write
      FFieldValueRequired default False;
  end;

  TADDatSCheckConstraint = class (TADDatSConstraintBase)
  private
    FEvaluator: IADStanExpressionEvaluator;
    FExpression: String;
    procedure SetExpression(const AValue: String);
  protected
    procedure DoCheck(ARow: TADDatSRow; AProposedState:
      TADDatSRowState); override;
    procedure DoEnforceUpdated; override;
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create(const AExpression: string); overload;
    constructor Create(const AName, AExpression: string; const AMessage: String = '';
      ACheckTime: TADDatSCheckTime = ctAtEditEnd); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property Expression: String read FExpression write SetExpression;
  end;

  TADDatSRelation = class (TADDatSNamedObject)
  private
    FChildColumnNames: String;
    FChildColumns: TADDatSColumnSublist;
    FChildKeyConstraint: TADDatSForeignKeyConstraint;
    FChildTable: TADDatSTable;
    FNested: Boolean;
    FParentColumnNames: String;
    FParentColumns: TADDatSColumnSublist;
    FParentKeyConstraint: TADDatSUniqueConstraint;
    FParentTable: TADDatSTable;
    FRefs: TADRefCounter;
    FOwnConstraints: Boolean;
    function GetChildColumnCount: Integer;
    function GetChildColumns(AIndex: Integer): TADDatSColumn;
    function GetIsDefined: Boolean;
    function GetParentColumnCount: Integer;
    function GetParentColumns(AIndex: Integer): TADDatSColumn;
    function GetRelationList: TADDatSRelationList;
    procedure SetChildColumnNames(const AValue: String);
    procedure SetChildKeyConstraint(const AValue: TADDatSForeignKeyConstraint);
    procedure SetChildTable(const AValue: TADDatSTable);
    procedure SetNested(const AValue: Boolean);
    procedure SetParentColumnNames(const AValue: String);
    procedure SetParentKeyConstraint(const AValue: TADDatSUniqueConstraint);
    procedure SetParentTable(const AValue: TADDatSTable);
    procedure Check;
    procedure ResolveReferences(const AName, AValue: String);
    function GetIsRefCounted: Boolean;
  protected
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; override;
    constructor Create(const ARelName: String; AParentColumn,
      AChildColumn: TADDatSColumn; ANested: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF};
      ACreateConstraints: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}); overload;
    constructor Create(const ARelName: String; const AParentColumns,
      AChildColumns: array of TADDatSColumn; ANested: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF};
      ACreateConstraints: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}); overload;
    constructor Create(const ARelName: String; const AParentColumnNames,
      AChildColumnNames: String; AParentTable, AChildTable: TADDatSTable;
      ANested: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF};
      ACreateConstraints: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}); overload;
    constructor Create(const ARelName: String; APK: TADDatSUniqueConstraint;
      AFK: TADDatSForeignKeyConstraint); overload;
    destructor Destroy; override;
    function BuildChildKeyConstraint: TADDatSForeignKeyConstraint;
    function BuildParentKeyConstraint: TADDatSUniqueConstraint;
    procedure Assign(AObj: TADDatSObject); override;
    procedure CountRef(AInit: Integer = 1);
    procedure AddRef;
    procedure RemRef;
    property IsRefCounted: Boolean read GetIsRefCounted;
    property ChildColumnCount: Integer read GetChildColumnCount;
    property ChildColumnNames: String read FChildColumnNames write
      SetChildColumnNames;
    property ChildColumns[AIndex: Integer]: TADDatSColumn read
      GetChildColumns;
    property ChildKeyConstraint: TADDatSForeignKeyConstraint read
      FChildKeyConstraint write SetChildKeyConstraint;
    property ChildTable: TADDatSTable read FChildTable write SetChildTable;
    property IsDefined: Boolean read GetIsDefined;
    property Nested: Boolean read FNested write SetNested default False;
    property ParentColumnCount: Integer read GetParentColumnCount;
    property ParentColumnNames: String read FParentColumnNames write
      SetParentColumnNames;
    property ParentColumns[AIndex: Integer]: TADDatSColumn read
      GetParentColumns;
    property ParentKeyConstraint: TADDatSUniqueConstraint read
      FParentKeyConstraint write SetParentKeyConstraint;
    property ParentTable: TADDatSTable read FParentTable write SetParentTable;
    property RelationList: TADDatSRelationList read GetRelationList;
  end;

  TADDatSRelationArray = array of TADDatSRelation;

  TADDatSRelationList = class (TADDatSNamedList)
  private
    function GetItemsI(AIndex: Integer): TADDatSRelation; {$IFDEF AnyDAC_D12} inline; {$ENDIF}
  protected
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
  public
    constructor CreateForManager(AManager: TADDatSManager);
    function Add(AObj: TADDatSRelation): Integer; overload;
    function Add(const ARelName: String; AParentColumn, AChildColumn:
      TADDatSColumn; ANested: Boolean = False;
      ACreateConstraints: Boolean = True): TADDatSRelation; overload;
    function Add(AParentColumn, AChildColumn: TADDatSColumn;
      ANested: Boolean = False; ACreateConstraints: Boolean = True):
      TADDatSRelation; overload;
    function Add(const ARelName: String; const AParentColumns, AChildColumns:
      array of TADDatSColumn; ANested: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF};
      ACreateConstraints: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSRelation; overload;
    function Add(const ARelName: String; const AParentColumnNames,
      AChildColumnNames: String; AParentTable, AChildTable: TADDatSTable;
      ANested: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF};
      ACreateConstraints: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSRelation; overload;
    function Add(const AParentColumns, AChildColumns: array of TADDatSColumn;
      ANested: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF};
      ACreateConstraints: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSRelation; overload;
    function Add(const ARelName: String; APK: TADDatSUniqueConstraint;
      AFK: TADDatSForeignKeyConstraint): TADDatSRelation; overload;
    function FindRelation(AParentTable, AChildTable: TADDatSTable;
      AMBNested: Boolean): TADDatSRelation; overload;
    function FindRelation(AParentTable: TADDatSTable;
      AObjColumn: TADDatSColumn): TADDatSRelation; overload;
    function FindRelation(ANestedTable: TADDatSTable): TADDatSRelation; overload;
    function RelationByName(const AName: String): TADDatSRelation;
    function GetRelationsForTable(AParentRelations: Boolean;
      ATable: TADDatSTable): TADDatSRelationArray;
    property ItemsI[AIndex: Integer]: TADDatSRelation read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSRelation read RelationByName;
  end;

  TADDatSMechSortSource = (ssColumns, ssExpression, ssRowId);
  IADDatSMechSort = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2019}']
    // private
    function GetSortOptions: TADSortOptions;
    function GetSortColumnList: TADDatSColumnSublist;
    function GetSortDescendingColumnList: TADDatSColumnSublist;
    function GetSortCaseInsensitiveColumnList: TADDatSColumnSublist;
    function GetSortSource: TADDatSMechSortSource;
    function GetSortedRows: TADDatSRowListBase;
    // public
    procedure Sort(AList: TADDatSRowListBase);
    function SortingOn(const AColumnNames: String;
      ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean; overload;
    function SortingOn(AKeyColumnList: TADDatSColumnSublist; AKeyColumnCount: Integer;
      ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean; overload;
    function CompareRows(ARow1, ARow2: TADDatSRow;
      AColumnCount: Integer; AOptions: TADCompareDataOptions): Integer; overload;
    function CompareRows(ARow1, ARow2: TADDatSRow;
      AColumnCount: Integer): Integer; overload;
    function Search(ARowList: TADDatSRowListBase; AKeyRow: TADDatSRow;
      AKeyColumnList, AKeyColumnList2: TADDatSColumnSublist; AKeyColumnCount: Integer;
      AOptions: TADLocateOptions; out AIndex: Integer; out AFound: Boolean;
      ARowVersion: TADDatSRowVersion = rvDefault): Integer;
    procedure RemoveDuplicates(AList: TADDatSRowListBase; AColumnCount: Integer);
    property SortOptions: TADSortOptions read GetSortOptions;
    property SortColumnList: TADDatSColumnSublist read GetSortColumnList;
    property SortDescendingColumnList: TADDatSColumnSublist read GetSortDescendingColumnList;
    property SortCaseInsensitiveColumnList: TADDatSColumnSublist read GetSortCaseInsensitiveColumnList;
    property SortSource: TADDatSMechSortSource read GetSortSource;
    property SortedRows: TADDatSRowListBase read GetSortedRows;
  end;

  TADDatSMechBase = class (TADDatSObject)
  private
    FPrevActualActive, FActive: Boolean;
    FLocator: Boolean;
    procedure SetActive(const AValue: Boolean);
    function GetView: TADDatSView;
    function GetViewList: TADDatSViewList;
    procedure ResolveActive(const AName, AValue: String);
  protected
    FKinds: TADDatSMechanismKinds;
    function GetActualActive: Boolean; virtual;
    procedure DoListInserted; override;
    procedure DoListRemoving; override;
    procedure DoListRemoved(ANewOwner: TADDatSObject); override;
    procedure DoActiveChanged; virtual;
    procedure CheckActiveChanged;
    function GetTable: TADDatSTable; override;
    function GetRowsRange(var ARowList: TADDatSRowListBase; out ABeginInd,
      AEndInd: Integer): Boolean; virtual;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; virtual;
    procedure PostProcess(AList: TADDatSRowListBase); virtual;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    procedure Assign(AObj: TADDatSObject); override;
    // ro
    property Table: TADDatSTable read GetTable;
    property View: TADDatSView read GetView;
    property ViewList: TADDatSViewList read GetViewList;
    property ActualActive: Boolean read GetActualActive;
    property Kinds: TADDatSMechanismKinds read FKinds;
    // rw
    property Active: Boolean read FActive write SetActive default False;
    property Locator: Boolean read FLocator write FLocator default False;
  end;
  TADDatSMechBaseClass = class of TADDatSMechBase;

  TADDatSViewMechList = class (TADDatSList)
  private
    function GetItemsI(AIndex: Integer): TADDatSMechBase; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
  protected
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
  public
    constructor CreateForView(AView: TADDatSView);
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean;
    function Add(AObj: TADDatSMechBase): Integer;
    function AddSort(const AColumns: String; const ADescColumns: String = '';
      const ACaseInsColumns: String = ''; AOptions: TADSortOptions = []): TADDatSMechSort; overload;
    function AddSort(const AExpression: String; AOptions: TADSortOptions): TADDatSMechSort; overload;
    function AddDistinct(AColumnCount: Integer): TADDatSMechDistinct; {$IFDEF AnyDAC_D12} inline; {$ENDIF}
    function AddStates(AStates: TADDatSRowStates = [rsInitializing, rsInserted,
      rsModified, rsUnchanged, rsEditing, rsCalculating, rsChecking]): TADDatSMechRowState;
    function AddFilter(const AExpression: String; AOptions:
      TADExpressionOptions = []; AEvent: TADFilterRowEvent = nil): TADDatSMechFilter;
    function AddError: TADDatSMechError;
    function AddDetail(AParentRel: TADDatSRelation;
      AParentRow: TADDatSRow): TADDatSMechDetails;
    procedure Clear; override;
    property ItemsI[AIndex: Integer]: TADDatSMechBase read GetItemsI; default;
  end;

  TADDatSMechSort = class (TADDatSMechBase, IUnknown, IADDatSMechSort)
  private
    FCaseInsensitiveColumnList: TADDatSColumnSublist;
    FCaseInsensitiveColumns: String;
    FColumnList: TADDatSColumnSublist;
    FColumns: String;
    FDescendingColumnList: TADDatSColumnSublist;
    FDescendingColumns: String;
    FSortOptions: TADSortOptions;
    FExpression: String;
    FEvaluator: IADStanExpressionEvaluator;
    FSortSource: TADDatSMechSortSource;
    FSortOptionsChanged: Boolean;
    FUniqueKey: TADDatSUniqueConstraint;
    procedure SetCaseInsensitiveColumns(const AValue: String);
    procedure SetColumns(const AValue: String);
    procedure SetDescendingColumns(const AValue: String);
    procedure SetSortOptions(const AValue: TADSortOptions);
    procedure SetExpression(const AValue: String);
    function CreateUniqueConstraint: TADDatSUniqueConstraint;
    function MatchOptions(ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean;
    function GetCompareDataOptions: TADCompareDataOptions;
  protected
    procedure DoActiveChanged; override;
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
    // IUnknown
{$IFDEF AnyDAC_FPC}
    function QueryInterface({$IFDEF FPC_HAS_CONSTREF} constref {$ELSE} const {$ENDIF}
      iid: tguid; out obj): longint; {$IFNDEF WINDOWS} cdecl {$ELSE} stdcall {$ENDIF};
{$ELSE}
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
{$ENDIF}
    function _AddRef: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
    function _Release: Integer; {$IFDEF AnyDAC_INTF_CDECL} cdecl {$ELSE} stdcall {$ENDIF};
    // IADDatSMechSortGS
    function GetSortOptions: TADSortOptions;
    function GetSortColumnList: TADDatSColumnSublist;
    function GetSortDescendingColumnList: TADDatSColumnSublist;
    function GetSortCaseInsensitiveColumnList: TADDatSColumnSublist;
    function GetSortSource: TADDatSMechSortSource;
    function GetSortedRows: TADDatSRowListBase;
    procedure Sort(AList: TADDatSRowListBase);
    function SortingOn(const AColumnNames: String; ARequiredOptions,
      AProhibitedOptions: TADSortOptions): Boolean; overload;
    function SortingOn(AKeyColumnList: TADDatSColumnSublist; AKeyColumnCount: Integer;
      ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean; overload;
    function CompareRows(ARow1, ARow2: TADDatSRow;
      AColumnCount: Integer; AOptions: TADCompareDataOptions): Integer; overload;
    function CompareRows(ARow1, ARow2: TADDatSRow;
      AColumnCount: Integer): Integer; overload;
    function Search(ARowList: TADDatSRowListBase; AKeyRow: TADDatSRow;
      AKeyColumnList, AKeyColumnList2: TADDatSColumnSublist; AKeyColumnCount: Integer;
      AOptions: TADLocateOptions; out AIndex: Integer; out AFound: Boolean;
      ARowVersion: TADDatSRowVersion = rvDefault): Integer;
    procedure RemoveDuplicates(AList: TADDatSRowListBase; AColumnCount: Integer);
  public
    constructor Create; overload; override;
    constructor Create(const AColumns: String; const ADescColumns: String = '';
      const ACaseInsColumns: String = ''; AOptions: TADSortOptions = []); overload;
    constructor Create(const AExpression: String; AOptions: TADSortOptions); overload;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property Expression: String read FExpression write SetExpression;
    property Columns: String read FColumns write SetColumns;
    property DescendingColumns: String read FDescendingColumns write SetDescendingColumns;
    property CaseInsensitiveColumns: String read FCaseInsensitiveColumns
      write SetCaseInsensitiveColumns;
    property SortOptions: TADSortOptions read GetSortOptions write SetSortOptions default [];
    property SortColumnList: TADDatSColumnSublist read GetSortColumnList;
    property SortDescendingColumnList: TADDatSColumnSublist read GetSortDescendingColumnList;
    property SortCaseInsensitiveColumnList: TADDatSColumnSublist read GetSortCaseInsensitiveColumnList;
    property SortSource: TADDatSMechSortSource read FSortSource;
    property UniqueKey: TADDatSUniqueConstraint read FUniqueKey;
  end;

  TADDatSMechRowState = class (TADDatSMechBase)
  private
    FRowStates: TADDatSRowStates;
    procedure SetRowStates(const AValue: TADDatSRowStates);
  protected
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
  public
    constructor Create; overload; override;
    constructor Create(AStates: TADDatSRowStates); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property RowStates: TADDatSRowStates read FRowStates write SetRowStates;
  end;

  TADDatSMechRange = class (TADDatSMechBase)
  private
    FBottom: TADDatSRow;
    FTop: TADDatSRow;
    FBottomExclusive: Boolean;
    FTopExclusive: Boolean;
    FSortMech: IADDatSMechSort;
    FBottomColumnCount, FTopColumnCount: Integer;
    procedure SetBottom(const AValue: TADDatSRow);
    procedure SetTop(const AValue: TADDatSRow);
    procedure SetBottomExclusive(const AValue: Boolean);
    procedure SetTopExclusive(const AValue: Boolean);
    procedure SetSortMech(const AValue: IADDatSMechSort);
    procedure SetBottomColumnCount(const AValue: Integer);
    procedure SetTopColumnCount(const AValue: Integer);
  protected
    FTopColumnList: TADDatSColumnSublist;
    FBottomColumnList: TADDatSColumnSublist;
    procedure DoActiveChanged; override;
    function NoRangeNoRecords: Boolean; virtual;
    function GetRowsRange(var ARowList: TADDatSRowListBase; out ABeginInd,
      AEndInd: Integer): Boolean; override;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; overload; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property Bottom: TADDatSRow read FBottom write SetBottom;
    property Top: TADDatSRow read FTop write SetTop;
    property BottomExclusive: Boolean read FBottomExclusive write SetBottomExclusive default False;
    property TopExclusive: Boolean read FTopExclusive write SetTopExclusive default False;
    property SortMech: IADDatSMechSort read FSortMech write SetSortMech;
    property BottomColumnCount: Integer read FBottomColumnCount write SetBottomColumnCount default -1;
    property TopColumnCount: Integer read FTopColumnCount write SetTopColumnCount default -1;
  end;

  TADDatSMechDistinct = class (TADDatSMechBase)
  private
    FSortMech: IADDatSMechSort;
    FColumnCount: Integer;
    procedure SetSortMech(const AValue: IADDatSMechSort);
    procedure SetColumnCount(const AValue: Integer);
  protected
    procedure DoActiveChanged; override;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
    procedure PostProcess(AList: TADDatSRowListBase); override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; overload; override;
    constructor Create(AColumnCount: Integer); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property SortMech: IADDatSMechSort read FSortMech write SetSortMech;
    property ColumnCount: Integer read FColumnCount write SetColumnCount default -1;
  end;

  TADDatSMechFilter = class (TADDatSMechBase)
  private
    FExpression: String;
    FOptions: TADExpressionOptions;
    FEvaluator: IADStanExpressionEvaluator;
    FOnFilterRow: TADFilterRowEvent;
    procedure SetExpression(const AValue: String);
    procedure SetOptions(const AValue: TADExpressionOptions);
    procedure SetOnFilterRow(const AValue: TADFilterRowEvent);
  protected
    procedure DoActiveChanged; override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
  public
    constructor Create; overload; override;
    constructor Create(const AExpression: String;
      AOptions: TADExpressionOptions = []; AEvent: TADFilterRowEvent = nil); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property Expression: String read FExpression write SetExpression;
    property Options: TADExpressionOptions read FOptions write SetOptions default [];
    property OnFilterRow: TADFilterRowEvent read FOnFilterRow write SetOnFilterRow;
  end;

  TADDatSMechError = class (TADDatSMechBase)
  protected
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
  public
    constructor Create; overload; override;
    constructor CreateErr(ADummy: Integer = 0);
  end;

  TADDatSMechDetails = class (TADDatSMechRange)
  private
    FParentRelation: TADDatSRelation;
    FParentRow: TADDatSRow;
    procedure SetParentRelation(const AValue: TADDatSRelation);
    procedure SetParentRow(const AValue: TADDatSRow);
    procedure ResolveReferences(const AName, AValue: String);
  protected
    function GetActualActive: Boolean; override;
    procedure DoActiveChanged; override;
    function NoRangeNoRecords: Boolean; override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create(AParentRel: TADDatSRelation;
      AParentRow: TADDatSRow); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property ParentRelation: TADDatSRelation read FParentRelation
      write SetParentRelation;
    property ParentRow: TADDatSRow read FParentRow write SetParentRow;
  end;

  TADDatSMechChilds = class (TADDatSMechBase)
  private
    FParentRow: TADDatSRow;
    FRefCol: Integer;
    FRefColType: TADDataType;
    FRefRow: TADDatSNestedRowList;
    procedure SetParentRow(const AValue: TADDatSRow);
  protected
    procedure DoActiveChanged; override;
    function GetRowsRange(var ARowList: TADDatSRowListBase; out ABeginInd,
      AEndInd: Integer): Boolean; override;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
  public
    constructor Create; overload; override;
    constructor Create(AParentRow: TADDatSRow); overload;
    procedure Assign(AObj: TADDatSObject); override;
    property ParentRow: TADDatSRow read FParentRow write SetParentRow;
  end;

  TADDatSMechMaster = class (TADDatSMechRange)
  private
    FChildRelation: TADDatSRelation;
    FChildRow: TADDatSRow;
    procedure SetChildRelation(const AValue: TADDatSRelation);
    procedure SetChildRow(const AValue: TADDatSRow);
    procedure ResolveReferences(const AName, AValue: String);
  protected
    function GetActualActive: Boolean; override;
    procedure DoActiveChanged; override;
    function NoRangeNoRecords: Boolean; override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create(AChildRel: TADDatSRelation;
      AChildRow: TADDatSRow); overload;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    property ChildRelation: TADDatSRelation read FChildRelation
      write SetChildRelation;
    property ChildRow: TADDatSRow read FChildRow write SetChildRow;
  end;

  TADDatSMechParent = class (TADDatSMechBase)
  private
    FChildRow: TADDatSRow;
    FParentRow: TADDatSRowListBase;
    procedure SetChildRow(const AValue: TADDatSRow);
  protected
    procedure DoActiveChanged; override;
    function GetActualActive: Boolean; override;
    function GetRowsRange(var ARowList: TADDatSRowListBase;
      out ABeginInd, AEndInd: Integer): Boolean; override;
    function AcceptRow(ARow: TADDatSRow; AVersion: TADDatSRowVersion):
      Boolean; override;
  public
    constructor Create; overload; override;
    constructor Create(AChildRow: TADDatSRow); overload;
    procedure Assign(AObj: TADDatSObject); override;
    property ChildRow: TADDatSRow read FChildRow write SetChildRow;
  end;

  PADDataRowExtraInfo = ^TADDatSRowExtraInfo;
  TADDatSRowExtraInfo = packed record
    FCheckColumn: Integer;
    FCheckValue: PADByteString;
    FCheckLen: LongWord;
    FRowException: EADException;
    FLockID: LongWord;
  end;

  PADDatSCompareRowsCacheItem = ^TADDatSCompareRowsCacheItem;
  TADDatSCompareRowsCacheItem = record
    FpBuff: PByte;
    FLen: Integer;
    FOpts: TADCompareDataOptions;
    FIsNull: Boolean;
    FInit: Boolean;
  end;
  TADDatSCompareRowsCache = array of TADDatSCompareRowsCacheItem;

  TADDatSRow = class (TADDatSObject)
  private
    FTable: TADDatSTable;
    FpOriginal: PByte;
    FpCurrent: PByte;
    FpProposed: PByte;
    // following fields must be here, but moved to TADDatSObject to pack
    // FLockNotificationCount, FRowPriorState and FRowState into double word
    // FRowPriorState: TADDatSRowState;
    // RowState: TADDatSRowState;
    FNextChange, FPriorChange: TADDatSRow;
    FRowID, FChangeNumber: LongWord;
    FExtraInfo: PADDataRowExtraInfo;
    function GetHasErrors: Boolean;
    function GetRowList: TADDatSTableRowList;
    procedure CalculateColumns(ADefaults: Boolean);
    function CheckWrite(AColumn: Integer): PByte;
    procedure InternalInitComplexData(ABuffer: PByte);
    procedure AllocInvariants;
    procedure FreeInvariants;
    function GetInvariantObject(AColumn: Integer): TADDatSObject;
    procedure SetInvariantObject(AColumn: Integer; AObj: TADDatSObject);
    function GetParentRow: TADDatSRow;
    procedure SetParentRow(const ARow: TADDatSRow);
    function GetNestedRow(const AColumn: Integer): TADDatSRow;
    procedure SetNestedRow(const AColumn: Integer; const ARow: TADDatSRow);
    function GetNestedRows(const AColumn: Integer): TADDatSNestedRowList;
    procedure ConstrainChildRow(AProposedState: TADDatSRowState);
    procedure ConstrainParentRow(AProposedState: TADDatSRowState);
    procedure CancelNestedRows;
    procedure ClearNestedRows;
    procedure AcceptNestedChanges;
    procedure ClearNestedErrors;
    procedure ProcessNestedRows(AMethod: TADDatSProcessNestedRowsMethod);
    procedure RejectNestedChanges;
    procedure SetFetchedMarks(AOn: Boolean);
    function GetRowError: EADException;
    function SetRowError(const AValue: EADException): Boolean;
    procedure SetRowErrorPrc(const AValue: EADException);
    procedure DoNRDelete(ARow: TADDatSRow);
    procedure DoNREndModify(ARow: TADDatSRow);
    procedure DoNRCancel(ARow: TADDatSRow);
    procedure DoNRFree(ARow: TADDatSRow);
    procedure DoNRAcceptChanges(ARow: TADDatSRow);
    procedure DoNRClearErrors(ARow: TADDatSRow);
    procedure DoNRRejectChanges(ARow: TADDatSRow);
    procedure DoNRDetache(ARow: TADDatSRow);
    function GetDataI(const AColumn: Integer): Variant;
    function GetDataO(AColumn: TADDatSColumn): Variant;
    procedure CheckNoInfo;
    function GetRowInfo(AForce: Boolean): Pointer;
    function GetCheckInfo(ACheckColumn: Integer; out ACheckValue: PADByteString;
      out ACheckLen: LongWord): Boolean;
    procedure SetCheckInfo(ACheckColumn: Integer; ACheckValue: PADByteString;
      ACheckLen: Integer);
    function SkipConstraintCheck: Boolean;
    procedure CascadeAcceptReject(AAccept: Boolean);
    function GetDBLockID: LongWord;
    procedure InternalCalculateColumns(ADefaults: Boolean; ACols: TADDatSColumnList);
    procedure InternalAssignDefaults(ACols: TADDatSColumnList);
    procedure SaveRowVersion(AStorage: TADStorage; const AName: String;
      ABuff: PByte; ABuffKind: TADDatSRowState);
    procedure LoadRowVersion(AStorage: TADStorage; const AName: String;
      var ABuff: PByte; ABuffKind: TADDatSRowState);
    function GetDataS(const AColumn: String): Variant;
    function GetDataV(const AColumn: Variant): Variant;
    procedure SetDataI(const AColumn: Integer; const Value: Variant);
    procedure SetDataO(AColumn: TADDatSColumn; const Value: Variant);
    procedure SetDataS(const AColumn: String; const Value: Variant);
    procedure SetDataV(const AColumn: Variant; const Value: Variant);
    function GetAsString(const AColumn: String): String;
    procedure SetAsString(const AColumn, AValue: String);
    procedure DoNREndEdit(ARow: TADDatSRow);
    procedure DoNREndEditNoVer(ARow: TADDatSRow);
    function CompareNulls(AIsNull1, AIsNull2: Boolean;
      AOptions: TADCompareDataOptions): Integer;
  protected
    class function CreateInstance(ATable: TADDatSTable;
      ASetToDefaults: Boolean): TADDatSRow {$IFDEF AUTOREFCOUNT} unsafe {$ENDIF};
    procedure DoListInserted; override;
    procedure DoListInserting; override;
    procedure DoListRemoved(ANewOwner: TADDatSObject); override;
    procedure DoListRemoving; override;
    function AllocBuffer: PByte;
    procedure CleanupBuffer(ABuffer: PByte);
    procedure CopyBuffer(ADestination, ASource: PByte);
    procedure FreeBuffer(var ApBuffer: PByte);
    function GetBlobData(ABuffer: PByte; AColumn: Integer; var ApData: PADByteString;
      var ALen: Integer): Boolean;
    function GetBuffer(AVersion: TADDatSRowVersion): PByte;
    function GetIsNull(ABuffer: PByte; AColumn: Integer): Boolean;
    function GetTable: TADDatSTable; override;
    function GetManager: TADDatSManager; override;
    function SetBlobLength(ABuffer: PByte; AColumn: Integer;
      ApData: PADByteString; ALength: Integer; out AZeroAddOn, AUnitSize: Integer;
      AForceNotNull: Boolean = False): PADByteString;
    function SetBlobData(ABuffer: PByte; AColumn: Integer; ApData: PADByteString;
      ALength: Integer; AForceNotNull: Boolean = False): PADByteString;
    procedure SetIsNull(ABuffer: PByte; AColumn: Integer; AValue: Boolean);
    procedure SetFetched(const AColumn: Integer; const AValue: Boolean);
    function GetFetched(const AColumn: Integer): Boolean;
    procedure RegisterChange;
    procedure UnregisterChange;
    class function GetStreamingName(AStorage: TADStorage): String; override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor CreateForTable(ATable: TADDatSTable; ASetToDefaults: Boolean);
    destructor Destroy; override;
    procedure AcceptChanges(AUseCascade: Boolean = True);
    procedure AssignDefaults;
    procedure BeginEdit;
    procedure CancelEdit;
    procedure CheckRowConstraints(AProposedState: TADDatSRowState);
    procedure CheckColumnConstraints;
    procedure Clear(ASetColsToDefaults: Boolean);
    procedure ClearErrors;
    function CompareColumnVersions(AColumn: Integer;
      AVersion1, AVersion2: TADDatSRowVersion): Boolean;
    function CompareColumnsVersions(AColumns: TADDatSColumnSublist;
      AVersion1, AVersion2: TADDatSRowVersion): Boolean;
    function CompareData(AColumn: Integer; ABuff1: Pointer; ADataLen1: Integer;
      ABuff2: Pointer; ADataLen2: Integer; AOptions: TADCompareDataOptions):
      Integer;
    function CompareRows(AColumns, ADescendingColumns,
      ACaseInsensitiveColumns: TADDatSColumnSublist; AColumnCount: Integer;
      ARow2: TADDatSRow; AColumns2: TADDatSColumnSublist;
      AVersion: TADDatSRowVersion; AOptions: TADCompareDataOptions;
      var ACache: TADDatSCompareRowsCache): Integer; overload;
    function CompareRows(ARow2: TADDatSRow; AVersion: TADDatSRowVersion;
      AOptions: TADCompareDataOptions): Integer; overload;
    function CompareRowsExp(const AEvaluator: IADStanExpressionEvaluator;
      ARow2: TADDatSRow; AVersion: TADDatSRowVersion;
      AOptions: TADCompareDataOptions): Integer;
    procedure Delete(ANotDestroy: Boolean = False);
    procedure EndEdit(ANoVersion: Boolean = False);
    procedure EndEditNested(ANoVersion: Boolean = False);
    procedure Erase;
    function GetChildRows(const AChildRelationName: String): TADDatSView; overload;
    function GetChildRows(AChildTable: TADDatSTable): TADDatSView; overload;
    function GetChildRows(AChildRelation: TADDatSRelation): TADDatSView; overload;
    function GetParentRows(const AParentRelationName: String): TADDatSView; overload;
    function GetParentRows(AParentTable: TADDatSTable): TADDatSView; overload;
    function GetParentRows(AParentRelation: TADDatSRelation): TADDatSView; overload;
    function GetData(const AColumnName: String;
      AVersion: TADDatSRowVersion = rvDefault): Variant; overload;
    function GetData(const AColumn: Integer;
      AVersion: TADDatSRowVersion = rvDefault): Variant; overload;
    function GetData(const AColumn: TADDatSColumn;
      AVersion: TADDatSRowVersion = rvDefault): Variant; overload;
    function GetData(const AColumn: Integer; AVersion: TADDatSRowVersion; var
      ABuff: Pointer; ABuffLen: LongWord; var ADataLen: LongWord; AByVal:
      Boolean): Boolean; overload;
    function GetValues(const ANames: String; ADataSetNative: Boolean): Variant;
    function HasVersion(AVersion: TADDatSRowVersion): Boolean;
    procedure RejectChanges(AUseCascade: Boolean = True);
    procedure SetData(AColumn: Integer; const AValue: Variant); overload;
    procedure SetData(AColumn: TADDatSColumn; const AValue: Variant); overload;
    procedure SetData(AColumn: Integer; ABuff: Pointer; ADataLen: LongWord); overload;
    procedure SetValues(const AValues: array of Variant); overload;
    procedure SetValues(const ANames: String; const AValue: Variant); overload;
    function BeginDirectWriteBlob(AColumn, ABlobLen: Integer): PADByteString;
    procedure EndDirectWriteBlob(AColumn: Integer; AFinalBlobLen: Integer = -1);
    procedure BeginForceWrite;
    procedure EndForceWrite;
    procedure DBLock(ALockID: LongWord = $FFFFFFFF);
    procedure DBUnlock;
    function DumpCol(AColumn: Integer; AWithColNames: Boolean = False;
      AVersion: TADDatSRowVersion = rvDefault): String;
    function DumpRow(AWithColNames: Boolean = False;
      AVersion: TADDatSRowVersion = rvDefault): String; virtual;
    // R/O
    property DBLockID: LongWord read GetDBLockID;
    property NestedRows[const AColumn: Integer]: TADDatSNestedRowList read GetNestedRows;
    property HasErrors: Boolean read GetHasErrors;
    property RowList: TADDatSTableRowList read GetRowList;
{$WARNINGS OFF}
    property RowState: TADDatSRowState read FRowState;
    property RowPriorState: TADDatSRowState read FRowPriorState;
{$WARNINGS ON}
    property RowID: LongWord read FRowID;
    property ChangeNumber: LongWord read FChangeNumber;
    property Table: TADDatSTable read FTable;
    // R/W
    property ParentRow: TADDatSRow read GetParentRow write SetParentRow;
    property NestedRow[const AColumn: Integer]: TADDatSRow read GetNestedRow write SetNestedRow;
    property Fetched[const AColumn: Integer]: Boolean read GetFetched write SetFetched;
    property RowError: EADException read GetRowError write SetRowErrorPrc;
    property ValueI[const AColumn: Integer]: Variant read GetDataI write SetDataI;
    // The 'const' here gives error on C++Builder 2006
    property ValueO[{const} AColumn: TADDatSColumn]: Variant read GetDataO write SetDataO;
    property ValueS[const AColumn: String]: Variant read GetDataS write SetDataS;
    property Value[const AColumn: Variant]: Variant read GetDataV write SetDataV; default;
    property AsString[const AColumn: String]: String read GetAsString write SetAsString;
  end;
  PADDatSRow = ^TADDatSRow;

  TADDatSRowListBase = class (TADDatSList)
  private
    function GetItemsI(AIndex: Integer): TADDatSRow; {$IFDEF AnyDAC_D12} inline; {$ENDIF}
    function GetLast: TADDatSRow; {$IFDEF AnyDAC_D12} inline; {$ENDIF}
    procedure InternalSort1(L, R: Integer; ACompareRowsProc: TADCompareRowsProc;
      AOpts: TADCompareDataOptions);
    procedure InternalSort2(L, H: Integer; ACompareRowsProc: TADCompareRowsProc;
      AOpts: TADCompareDataOptions);
    procedure InternalSort(L, R: Integer; ACompareRowsProc: TADCompareRowsProc;
      AOpts: TADCompareDataOptions);
  protected
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
  public
    constructor Create; override;
    function Add(ARow: TADDatSRow): Integer; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    procedure AddAt(ARow: TADDatSRow; AIndex: Integer);
    procedure Sort(ACompareRowsProc: TADCompareRowsProc; AOpts: TADCompareDataOptions);
    procedure CheckDuplicates(ACompareRowsProc: TADCompareRowsProc; AOpts: TADCompareDataOptions);
    procedure RemoveDuplicates(ACompareRowsProc: TADCompareRowsProc; AColumnCount: Integer;
      AOpts: TADCompareDataOptions);
    function GetValuesList(const AColumnName: String; const ADelimiter: String = ';';
      const ANullName: String = ''): String;
    function DumpCol(ACol: Integer; AWithColNames: Boolean = False): String; virtual;
    property ItemsI[AIndex: Integer]: TADDatSRow read GetItemsI; default;
    property Last: TADDatSRow read GetLast;
  end;

  TADDatSNestedRowList = class (TADDatSRowListBase)
  protected
    procedure AddObjectAt(AObj: TADDatSObject; AIndex: Integer); override;
  public
    procedure RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False); override;
    constructor CreateForRow(ARow: TADDatSRow);
  end;

  TADDatSRowListWithAggregates = class (TADDatSRowListBase)
  private
    FAggregateValues: TADPtrList;
    FAggregateSlots: TBits;
    FAggregateSlotAllocated: Integer;
    FAggregateSlotUsed: Integer;
  protected
    procedure RemoveAggregatesRow(ARowIndex: Integer);
    procedure AddAggregatesRow(ARowIndex: Integer);
    procedure DeleteAggregates;
    procedure ClearAggregate(AIndex: Integer);
    procedure DeleteAggregate(var AIndex: Integer);
    function AllocateAggregate: Integer;
    procedure AttachAggregate(ARowIndex, AValIndex: Integer; AObj: TADDatSAggregateValue);
    function FetchAggregate(ARowIndex, AValIndex: Integer): TADDatSAggregateValue;
    procedure DetachAggregate(ARowIndex, AValIndex: Integer);
    procedure AddObjectAt(AObj: TADDatSObject; AIndex: Integer); override;
  public
    procedure RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False); override;
    constructor Create; overload; override;
    destructor Destroy; override;
  end;

  TADDatSAggregateValue = class (TObject)
  private
    FRefs: TADRefCounter;
    FValue: Variant;
    FSubValues: TADVariantArray;
    function GetRefs: Integer;
  protected
    procedure AddRef;
    procedure RemRef;
  public
    constructor Create(ASubAggregateCnt: Integer);
    constructor CreateCopy(AValue: TADDatSAggregateValue);
    destructor Destroy; override;
    procedure Clear;
    property Value: Variant read FValue;
    property Refs: Integer read GetRefs;
  end;

  TADDatSAggregateState = (agActual, agMinMax, agPrepared);
  TADDatSAggregateStates = set of TADDatSAggregateState;

  PADDatSSubAggregate = ^TADDatSSubAggregate;
  TADDatSSubAggregate = record
    FKind: TADAggregateKind;
    FValueIndex: Integer;
    FCountIndex: Integer;
  end;

  TADDatSAggregate = class (TADDatSNamedObject)
  private
    FExpression: String;
    FEvaluator: IADStanExpressionEvaluator;
    FActive: Boolean;
    FGroupingLevel: Integer;
    FValueIndex: Integer;
    FState: TADDatSAggregateStates;
    FSubAggregates: array of TADDatSSubAggregate;
    FSubAggregateValues: Integer;
    FCurrentRow: Integer;
    FRefs: TADRefCounter;
    FPrevActualActive: Boolean;
    function GetActualActive: Boolean;
    procedure SetActive(const AValue: Boolean);
    procedure SetExpression(const AValue: String);
    procedure SetGroupingLevel(const AValue: Integer);
    procedure IncAggVals(AKind: TADAggregateKind;
      const AVal: Variant; var AAggVal, AAggCnt: Variant);
    procedure DecAggVals(AKind: TADAggregateKind;
      const AVal: Variant; var AAggVal, AAggCnt: Variant);
    function GetSubAggregateValue(ASubAggregateIndex: Integer): Variant;
    function GetRows: TADDatSRowListWithAggregates;
    function GetValue(ARowIndex: Integer): Variant;
    procedure SetEvaluatorToRow(ARows: TADDatSRowListWithAggregates; ARowIndex: Integer);
    procedure ClearGroup(ARowIndex: Integer; var AGroupFrom, AGroupTo: Integer);
    procedure CalcGroup(AGroupFrom, AGroupTo, AExclude: Integer);
    procedure CalcAll;
    function GetSortMech: IADDatSMechSort;
    function GetView: TADDatSView;
    procedure CheckActiveChanged;
    procedure IncRow(ARows: TADDatSRowListWithAggregates;
      ARowIndex: Integer; AVal: TADDatSAggregateValue);
    procedure DecRow(ARows: TADDatSRowListWithAggregates;
      ARowIndex: Integer; AVal: TADDatSAggregateValue);
    function GetIsRefCounted: Boolean;
    function GetDataType: TADDataType;
    procedure ResolveActive(const AName, AValue: String);
  protected
    procedure Prepare;
    procedure Unprepare;
    procedure RowInserted(ARowIndex: Integer);
    procedure RowDeleted(ARowIndex: Integer);
    procedure RowUpdated(ARowIndex, AOldRowIndex: Integer);
    procedure DoListInserted; override;
    procedure DoListRemoving; override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; overload; override;
    constructor Create(const AName, AExpression: String;
      AGroupingLevel: Integer = 0); overload;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    procedure CountRef(AInit: Integer = 1);
    procedure AddRef;
    procedure RemRef;
    procedure Recalc;
    procedure Update;
    // ro
    property ActualActive: Boolean read GetActualActive;
    property SortMech: IADDatSMechSort read GetSortMech;
    property Rows: TADDatSRowListWithAggregates read GetRows;
    property View: TADDatSView read GetView;
    property State: TADDatSAggregateStates read FState;
    property DataType: TADDataType read GetDataType;
    property Value[ARowIndex: Integer]: Variant read GetValue;
    property IsRefCounted: Boolean read GetIsRefCounted;
    // rw
    property Expression: String read FExpression write SetExpression;
    property GroupingLevel: Integer read FGroupingLevel write SetGroupingLevel default 0;
    property Active: Boolean read FActive write SetActive default False;
  end;

  TADDatSAggregateList = class (TADDatSNamedList)
  private
    function GetItemsI(AIndex: Integer): TADDatSAggregate; {$IFDEF AnyDAC_D12} inline; {$ENDIF}
  protected
    procedure RowInserted(ARowIndex: Integer);
    procedure RowDeleted(ARowIndex: Integer);
    procedure RowUpdated(ARowIndex, AOldRowIndex: Integer);
  public
    constructor CreateForView(AOwner: TADDatSView);
    function Add(AObj: TADDatSAggregate): Integer; overload;
    function Add(const AName, AExpression: String;
      AGroupingLevel: Integer = 0): TADDatSAggregate; overload;
    function AggregateByName(const AName: String): TADDatSAggregate;
    procedure Update;
    procedure Recalc;
    property ItemsI[AIndex: Integer]: TADDatSAggregate read GetItemsI;
    property ItemsS[const AName: String]: TADDatSAggregate read AggregateByName;
  end;

  TADDatSViewRowList = class (TADDatSRowListWithAggregates)
  public
    constructor CreateForView(AView: TADDatSView);
  end;

  TADDatSView = class (TADDatSNamedObject)
  private
    FActive: Boolean;
    FPrevActualActive: Boolean;
    FMechanisms: TADDatSViewMechList;
    FRows: TADDatSRowListBase;
    FSourceView: TADDatSView;
    FState: TADDatSViewStates;
    FCreator: TADDatSViewCreator;
    FRefs: TADRefCounter;
    FAggregates: TADDatSAggregateList;
    FSortingMechanism: IADDatSMechSort;
    FProposedPosition: Integer;
    FLastUpdatePosition: Integer;
    FFindRow: TADDatSRow;
    procedure CheckRebuild;
    procedure InvalidateRebuild;
    function GetActual: Boolean;
    function GetViewList: TADDatSViewList;
    function ProcessRow(ARow: TADDatSRow; var ANewPos, AOldPos: Integer;
      AAdding: Boolean): TADDatSViewProcessRowStatus;
    procedure SetActive(const AValue: Boolean);
    procedure SetSourceView(const AValue: TADDatSView);
    procedure UpdateSortingMechanism(AExcludeView: TADDatSView);
    function GetGroupingLevel: Integer;
    function GetRowFilter: String;
    function GetRowStateFilter: TADDatSRowStates;
    function GetSort: String;
    procedure SetRowFilter(const AValue: String);
    procedure SetRowStateFilter(const AValue: TADDatSRowStates);
    procedure SetSort(const AValue: String);
    function GetMechanismByClass(AClass: TADDatSMechBaseClass;
      AKind: TADDatSMechanismKind): TADDatSMechBase;
    procedure CheckActiveChanged;
    function GetIsRefCounted: Boolean;
    function GetActualActive: Boolean;
    procedure DoRowAdded(ARow: TADDatSRow);
    procedure DoRowChanged(ARow: TADDatSRow);
    procedure DoRowDeleted(ARow: TADDatSRow);
    procedure ResolveActive(const AName, AValue: String);
    function GetFindRow: TADDatSRow;
  protected
    procedure DoListInserted; override;
    procedure DoListRemoving; override;
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
    function GetTable: TADDatSTable; override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; overload; override;
    constructor Create(ATable: TADDatSTable; const AFilter: String = '';
      const ASort: String = ''; AStates: TADDatSRowStates = []); overload;
    constructor Create(ATable: TADDatSTable; const ABaseName: String;
      ACreator: TADDatSViewCreator; ACountRef: Boolean = True); overload;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    procedure CountRef(AInit: Integer = 1);
    procedure AddRef;
    procedure RemRef;
    procedure Clear;
    procedure Rebuild;
    function Search(AKeyRow: TADDatSRow; AKeyColumnList,
      AKeyColumnList2: TADDatSColumnSublist; AKeyColumnCount: Integer;
      AOptions: TADLocateOptions; out AIndex: Integer; out AFound: Boolean;
      ARowVersion: TADDatSRowVersion = rvDefault): Integer;
    function IndexOf(AKeyRow: TADDatSRow; ARowVersion: TADDatSRowVersion = rvDefault;
      APossibleIndex: Integer = -1): Integer; overload;
    function Find(const AValues: array of Variant;
      AOptions: TADLocateOptions {$IFDEF AnyDAC_D6Base} = [] {$ENDIF}): Integer; overload;
    function Find(ARow: TADDatSRow;
      AOptions: TADLocateOptions {$IFDEF AnyDAC_D6Base} = [] {$ENDIF}): Integer; overload;
    function Find(const AValues: array of Variant; const AColumns: String;
      AOptions: TADLocateOptions {$IFDEF AnyDAC_D6Base} = [] {$ENDIF}): Integer; overload;
    function Find(ARow: TADDatSRow; const AColumns: String;
      AOptions: TADLocateOptions {$IFDEF AnyDAC_D6Base} = [] {$ENDIF}): Integer; overload;
    function Locate(var ARowIndex: Integer; AGoForward: Boolean = True;
      ARestart: Boolean = False): Boolean;
    function GetGroupState(ARecordIndex, AGroupingLevel: Integer): TADDatSGroupPositions;
    procedure DeleteAll(AAcceptChanges: Boolean = False);
    // ro
    property ActualActive: Boolean read GetActualActive;
    property Actual: Boolean read GetActual;
    property SortingMechanism: IADDatSMechSort read FSortingMechanism;
    property GroupingLevel: Integer read GetGroupingLevel;
    property Mechanisms: TADDatSViewMechList read FMechanisms;
    property Rows: TADDatSRowListBase read FRows;
    property ViewList: TADDatSViewList read GetViewList;
    property Aggregates: TADDatSAggregateList read FAggregates;
    property IsRefCounted: Boolean read GetIsRefCounted;
    // rw
    property Active: Boolean read FActive write SetActive;
    property Creator: TADDatSViewCreator read FCreator write FCreator;
    property SourceView: TADDatSView read FSourceView write SetSourceView;
    property RowFilter: String read GetRowFilter write SetRowFilter;
    property RowStateFilter: TADDatSRowStates read GetRowStateFilter
      write SetRowStateFilter default [];
    property Sort: String read GetSort write SetSort;
    property ProposedPosition: Integer read FProposedPosition
      write FProposedPosition;
    property LastUpdatePosition: Integer read FLastUpdatePosition
      write FLastUpdatePosition;
  end;

  TADDatSViewList = class (TADDatSNamedList)
  private
    FActive: Boolean;
    function GetItemsI(AIndex: Integer): TADDatSView; {$IFDEF AnyDAC_D12} inline; {$ENDIF}
    procedure SetActive(const AValue: Boolean);
  protected
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
  public
    constructor CreateForTable(ATable: TADDatSTable);
    procedure Assign(AObj: TADDatSObject); override;
    function Add(AObj: TADDatSView): Integer; overload;
    function Add(const AName: String): TADDatSView; overload;
    procedure Clear; override;
    function ViewByName(const AName: String): TADDatSView;
    function FindSortedView(const AColumns: String;
      ARequiredOptions, AProhibitedOptions: TADSortOptions): TADDatSView;
    procedure Rebuild;
    property ItemsI[AIndex: Integer]: TADDatSView read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSView read ViewByName;
    property Active: Boolean read FActive write SetActive;
  end;

  TADDatSTableRowList = class (TADDatSRowListWithAggregates)
  private
    FLastRowID: LongWord;
    FLastRowCount: Integer;
    FRowIDOrdered: Boolean;
    FResultSetNum: Integer;
  protected
    procedure AddObjectAt(AObj: TADDatSObject; AIndex: Integer); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor CreateForTable(ATable: TADDatSTable);
    function Add(const AValues: array of Variant): TADDatSRow; overload;
    procedure RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False); override;
    function IndexOf(AObj: TADDatSObject): Integer; override;
    procedure Clear; override;
    property Capacity;
    property ResultSetNum: Integer read FResultSetNum;
  end;

  IADDatSTableMetadataCallback = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2020}']
    procedure GetColumnOptions(AColumn: TADDatSColumn; var AOptions: TADDataOptions);
    procedure GetColumnAttributes(AColumn: TADDatSColumn; var AAttributes: TADDataAttributes);
    procedure GetColumnOrigin(AColumn: TADDatSColumn; var AOrigin: String);
    procedure GetColumnGenerator(AColumn: TADDatSColumn; var AGenerator: String);
    procedure GetColumnCaption(AColumn: TADDatSColumn; var ACaption: String);
    procedure GetTableOrigin(var AOrigin: String);
    function GetOwner: TObject;
end;

  IADDatSTableDataCallback = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2021}']
    procedure TableDataChanged(ARow: TADDatSRow; AChangeKind: TADDatSRowState);
  end;

  TADDatSTable = class (TADDatSBindedObject)
  private
    FColumns: TADDatSColumnList;
    FConstraints: TADDatSConstraintList;
    FDefaultView: TADDatSView;
    FErrors: TADDatSView;
    FChanges: TADDatSView;
    FRows: TADDatSTableRowList;
    FViews: TADDatSViewList;
    FUpdates: TADDatSUpdatesJournal;
    FUpdatesRegistry: Boolean;
    FDataHandleMode: TADDatSHandleMode;
    FRefs: TADRefCounter;
    FManager: TADDatSManager;
    FLocale: TADLocalID;
    FCaseSensitive: Boolean;
    FNested: Boolean;
    FMetadataCallback: IADDatSTableMetadataCallback;
    FDataCallbacks: TInterfaceList;
    FRound2Scale: Boolean;
    FStrsTrim2Len: Boolean;
    FCheckNotNull: Boolean;
    FCheckReadOnly: Boolean;
    function GetBaseView(AStates: TADDatSRowStates): TADDatSView;
    function GetDefaultView: TADDatSView;
    function GetFullView: TADDatSView;
    function GetEnforceConstraints: Boolean; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    function GetHasErrors: Boolean;
    function GetTableList: TADDatSTableList;
    procedure SetEnforceConstraints(const AValue: Boolean);
    procedure SetMinimumCapacity(const AValue: Integer);
    function GetChanges2: TADDatSView;
    function GetChildRelations: TADDatSRelationArray;
    function GetParentRelations: TADDatSRelationArray;
    procedure SetLocale(const AValue: TADLocalID);
    procedure SetCaseSensitive(const AValue: Boolean);
    function GetPrimaryKey: String;
    procedure SetPrimaryKey(const AValue: String);
    function GetMinimumCapacity: Integer;
    function GetIsRefCounted: Boolean;
    procedure NotifyDataChanged(ARow: TADDatSRow; AChangeKind: TADDatSRowState);
    function GetActualOriginName: String;
    function GetRefCount: Integer;
  protected
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
    function GetTable: TADDatSTable; override;
    function GetManager: TADDatSManager; override;
    procedure DoListInserted; override;
    procedure DoListRemoving; override;
    procedure DoListRemoved(ANewOwner: TADDatSObject); override;
    function FindRowByPK(ARow: TADDatSRow): Integer;
    procedure CheckLayoutChanging;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; overload; override;
    constructor Create(const AName: String); overload;
    destructor Destroy; override;
    procedure AddRef;
    procedure CountRef(AInit: Integer = 1);
    procedure RemRef;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    procedure AcceptChanges;
    procedure BeginLoadData(var AState: TADDatSLoadState; ADataHandleMode: TADDatSHandleMode = lmHavyMove);
    procedure Clear;
    function Compute(const AExpression, AFilter: String): Variant;
    function Copy: TADDatSTable;
    procedure EndLoadData(const AState: TADDatSLoadState);
    function GetChangesView(ARowStates: TADDatSRowStates =
      [rsInserted, rsDeleted, rsModified]): TADDatSView;
    function GetChanges(ARowStates: TADDatSRowStates =
      [rsInserted, rsDeleted, rsModified]): TADDatSTable;
    function GetErrors: TADDatSView;
    function HasChanges(ARowStates: TADDatSRowStates): Boolean;
    procedure ImportRow(ASrcRow: TADDatSRow);
    procedure Import(ASrcRow, ADestRow: TADDatSRow; const AColumnMap: TADArrayOfInteger); overload;
    procedure Import(ASrcRow: TADDatSRow; ADestRow: TADDatSRow = nil); overload;
    procedure Import(ARowList: TADDatSRowListBase); overload;
    procedure Import(AView: TADDatSView); overload;
    procedure Import(ATable: TADDatSTable); overload;
    function LoadDataRow(const AValues: array of Variant; AAcceptChanges: Boolean = False): TADDatSRow;
    procedure MakeColumnMap(ASrcRow: TADDatSRow; out AColumnMap: TADArrayOfInteger);
    function NewRow(ASetToDefaults: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSRow; overload;
    function NewRow(ASetToDefaults: Boolean; const AParentRows: array of TADDatSRow): TADDatSRow; overload;
    function NewRow(const AValues: array of Variant; ASetToDefaults: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSRow; overload;
    procedure RejectChanges;
    procedure Reset;
    function Select(const AFilter: String = ''; const ASort: String = '';
      AStates: TADDatSRowStates = []): TADDatSView;
    procedure AddDataCallback(const ACallback: IADDatSTableDataCallback);
    procedure RemoveDataCallback(const ACallback: IADDatSTableDataCallback;
      ARemoveLastOne: Boolean);
    procedure UpdateLayout;
    procedure Setup(const AOptions: IADStanOptions);
    // ro
    property Changes: TADDatSView read GetChanges2;
    property ChildRelations: TADDatSRelationArray read GetChildRelations;
    property Columns: TADDatSColumnList read FColumns;
    property Constraints: TADDatSConstraintList read FConstraints;
    property DataHandleMode: TADDatSHandleMode read FDataHandleMode;
    property DefaultView: TADDatSView read GetDefaultView;
    property FullView: TADDatSView read GetFullView;
    property Errors: TADDatSView read GetErrors;
    property HasErrors: Boolean read GetHasErrors;
    property ParentRelations: TADDatSRelationArray read GetParentRelations;
    property Rows: TADDatSTableRowList read FRows;
    property Manager: TADDatSManager read FManager;
    property TableList: TADDatSTableList read GetTableList;
    property Views: TADDatSViewList read FViews;
    property Updates: TADDatSUpdatesJournal read FUpdates;
    property UpdatesRegistry: Boolean read FUpdatesRegistry;
    property IsRefCounted: Boolean read GetIsRefCounted;
    property RefCount: Integer read GetRefCount;
    property ActualOriginName: String read GetActualOriginName;
    // rw
    property MetadataCallback: IADDatSTableMetadataCallback read FMetadataCallback
      write FMetadataCallback;
    property CaseSensitive: Boolean read FCaseSensitive write SetCaseSensitive
      default True;
    property EnforceConstraints: Boolean read GetEnforceConstraints write
      SetEnforceConstraints default True;
    property Locale: TADLocalID read FLocale write SetLocale default LOCALE_USER_DEFAULT;
    property MinimumCapacity: Integer read GetMinimumCapacity write SetMinimumCapacity
      default 0;
    property Nested: Boolean read FNested write FNested default False;
    property PrimaryKey: String read GetPrimaryKey write SetPrimaryKey;
    property Round2Scale: Boolean read FRound2Scale write FRound2Scale default False;
    property StrsTrim2Len: Boolean read FStrsTrim2Len write FStrsTrim2Len default False;
    property CheckNotNull: Boolean read FCheckNotNull write FCheckNotNull default True;
    property CheckReadOnly: Boolean read FCheckReadOnly write FCheckReadOnly default True;
  end;

  TADDatSTableList = class (TADDatSBindedList)
  private
    // "inlined" in D < 12 gives warning
    function GetItemsI(AIndex: Integer): TADDatSTable; {$IFDEF AnyDAC_D12} inline; {$ENDIF}
  public
    constructor CreateForManager(AManager: TADDatSManager);
    function Add(AObj: TADDatSTable): Integer; overload;
    function Add(const AName: String = ''): TADDatSTable; overload;
    function TableByName(const AName: String): TADDatSTable;
    property ItemsI[AIndex: Integer]: TADDatSTable read GetItemsI; default;
    property ItemsS[const AName: String]: TADDatSTable read TableByName;
  end;

  TADDatSUpdatesJournal = class (TADStorableObject)
  private
    FLocked: Integer;
    FChangeNumber: LongWord;
    {$IFDEF AUTOREFCOUNT} [weak] {$ENDIF} FOwner: TADDatSObject;
    FFirstChange, FLastChange, FTmpNextRow: TADDatSRow;
    procedure SetSavePoint(const AValue: LongWord);
    procedure AppendRow(ARow: TADDatSRow);
    function GetLocked: Boolean;
  protected
    class function GetClassPrefix: String; override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    procedure Lock;
    procedure Unlock;
    constructor Create(AOwner: TADDatSObject); overload;
    function RegisterRow(ARow: TADDatSRow): Integer;
    procedure UnregisterRow(ARow: TADDatSRow);
    procedure AcceptChanges(AOwner: TADDatSObject = nil);
    procedure RejectChanges(AOwner: TADDatSObject = nil);
    function HasChanges(AOwner: TADDatSObject = nil): Boolean;
    function FirstChange(AOwner: TADDatSObject = nil): TADDatSRow;
    function NextChange(ACurRow: TADDatSRow; AOwner: TADDatSObject = nil): TADDatSRow;
    function LastChange(AOwner: TADDatSObject = nil): TADDatSRow;
    function GetCount(AOwner: TADDatSObject = nil): Integer;
    procedure Clear;
    property SavePoint: LongWord read FChangeNumber write SetSavePoint;
    property IsLocked: Boolean read GetLocked;
  end;

  TADDatSTableArray = array of TADDatSTable;

  TADDatSManager = class (TADDatSNamedObject)
  private
    FEnforceConstraints: Boolean;
    FRelations: TADDatSRelationList;
    FTables: TADDatSTableList;
    FUpdates: TADDatSUpdatesJournal;
    FUpdatesRegistry: Boolean;
    FRefs: TADRefCounter;
    FCaseSensitive: Boolean;
    FLocale: TADLocalID;
    FRound2Scale: Boolean;
    FStrsTrim2Len: Boolean;
    FCheckNotNull: Boolean;
    FCheckReadOnly: Boolean;
    function GetHasErrors: Boolean;
    procedure SetEnforceConstraints(const AValue: Boolean);
    function GetRootTables: TADDatSTableArray;
    procedure SetUpdatesRegistry(const AValue: Boolean);
    procedure SetCaseSensitive(const AValue: Boolean);
    procedure SetLocale(const AValue: TADLocalID);
    procedure SetRound2Scale(const AValue: Boolean);
    procedure SetStrsTrim2Len(const AValue: Boolean);
    function GetIsRefCounted: Boolean;
    function GetRefs: Integer;
    procedure SetCheckNotNull(const AValue: Boolean);
    procedure SetCheckReadOnly(const AValue: Boolean);
  protected
    procedure HandleNotification(AParam: PADDatSNotifyParam); override;
    function GetManager: TADDatSManager; override;
    procedure InternalSaveToStorage(AStorage: TADStorage); override;
    procedure InternalLoadFromStorage(AStorage: TADStorage); override;
  public
    constructor Create; overload; override;
    destructor Destroy; override;
    procedure Assign(AObj: TADDatSObject); override;
    function IsEqualTo(AObj: TADDatSObject): Boolean; override;
    procedure CountRef(AInit: Integer = 1);
    procedure AddRef;
    procedure RemRef;
    procedure AcceptChanges;
    procedure BeginLoadData(var AStates: TADDatSLoadStates; ADataHandleMode: TADDatSHandleMode = lmHavyMove);
    procedure Clear;
    function Copy: TADDatSManager;
    procedure EndLoadData(const AStates: TADDatSLoadStates);
    function HasChanges(ARowStates: TADDatSRowStates): Boolean;
    procedure Merge(ARow: TADDatSRow; AOptions: TADDatSMergeOptions); overload;
    procedure Merge(AManager: TADDatSManager; AOptions: TADDatSMergeOptions); overload;
    procedure Merge(ATable: TADDatSTable; AOptions: TADDatSMergeOptions); overload;
    procedure RejectChanges;
    procedure Reset;
    procedure Setup(const AOptions: IADStanOptions);
    // ro
    property HasErrors: Boolean read GetHasErrors;
    property Relations: TADDatSRelationList read FRelations;
    property Tables: TADDatSTableList read FTables;
    property Updates: TADDatSUpdatesJournal read FUpdates;
    property RootTables: TADDatSTableArray read GetRootTables;
    property IsRefCounted: Boolean read GetIsRefCounted;
    property Refs: Integer read GetRefs;
    // rw
    property CaseSensitive: Boolean read FCaseSensitive write SetCaseSensitive
      default True;
    property EnforceConstraints: Boolean read FEnforceConstraints
      write SetEnforceConstraints default True;
    property Locale: TADLocalID read FLocale write SetLocale default LOCALE_USER_DEFAULT;
    property UpdatesRegistry: Boolean read FUpdatesRegistry
      write SetUpdatesRegistry default False;
    property Round2Scale: Boolean read FRound2Scale write SetRound2Scale default False;
    property StrsTrim2Len: Boolean read FStrsTrim2Len write SetStrsTrim2Len default False;
    property CheckNotNull: Boolean read FCheckNotNull write SetCheckNotNull default True;
    property CheckReadOnly: Boolean read FCheckReadOnly write SetCheckReadOnly default True;
  end;

var
  ADEmptyCC: TADDatSCompareRowsCache;

implementation

uses
  SysUtils, TypInfo,
{$IFDEF AnyDAC_D6Base}
  Variants, FmtBcd,
  {$IFDEF AnyDAC_D6}
  SqlTimSt,
  {$ENDIF}
{$ELSE}
  ActiveX, ComObj, DB,
{$ENDIF}
{$IFDEF AnyDAC_D17}
  System.Generics.Defaults,
  System.Generics.Collections,
  System.Types,
{$ENDIF}
  uADStanSQLTimeInt, uADStanFactory, uADStanResStrs;

type
  TADBlobData = record
    FData: PADByteString;
    FLength: Integer;
  end;
  PADBlobData = ^TADBlobData;

const
  C_AllViewRows = [rsInserted, rsModified, rsUnchanged,
    rsInitializing, rsEditing, rsCalculating, rsChecking];

{-------------------------------------------------------------------------------}
{- TADDatSObject                                                               -}
{-------------------------------------------------------------------------------}
constructor TADDatSObject.Create;
begin
  inherited Create;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSObject.Destroy;
begin
  if (FOwner <> nil) and (FOwner is TADDatSList) then
    TADDatSList(FOwner).Remove(Self, True);
  FOwner := nil;
  FLockNotificationCount := 0;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.Assign(AObj: TADDatSObject);
begin
  // nothing
  ASSERT(False);
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.IndexOf(AObj: TADDatSObject): Integer;
begin
  Result := -1;
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.GetIndex: Integer;
begin
  if FOwner <> nil then
    Result := FOwner.IndexOf(Self)
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.GetList: TADDatSList;
begin
  Result := TADDatSList(GetOwnerByClass(TADDatSList));
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.GetOwnerByClass(AClass: TADDatSObjectClass): TADDatSObject;
begin
  ASSERT(AClass <> nil);
  Result := Owner;
  while (Result <> nil) and not Result.ClassType.InheritsFrom(AClass) do
    Result := Result.Owner;
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.GetManager: TADDatSManager;
begin
  Result := TADDatSManager(GetOwnerByClass(TADDatSManager));
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.GetTable: TADDatSTable;
begin
  Result := TADDatSTable(GetOwnerByClass(TADDatSTable));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.HandleNotification(AParam: PADDatSNotifyParam);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDatSObject.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := ((Self = nil) and (AObj = nil) or
    (Self <> nil) and (AObj <> nil) and (Self.ClassType = AObj.ClassType));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.LockNotification;
begin
  ASSERT(FLockNotificationCount < $FFFF);
  Inc(FLockNotificationCount);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.Notify(AKind: TADDatSNotificationKind;
  AReason: TADDatSNotificationReason; AParam1, AParam2: TADNativeInt);
var
  rParam: TADDatSNotifyParam;
begin
  rParam.FKind := AKind;
  rParam.FReason := AReason;
  rParam.FParam1 := AParam1;
  rParam.FParam2 := AParam2;
  Notify(@rParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.Notify(AParam: PADDatSNotifyParam);
begin
  if FLockNotificationCount = 0 then
    // MSGOPT second condition is only for optimization
    if (Owner <> nil) and (AParam^.FKind <> snObjectInserting) then
      Owner.Notify(AParam)
    else
      HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.UnlockNotification;
begin
  if FLockNotificationCount > 0 then
    Dec(FLockNotificationCount);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.DoListInserted;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.DoListInserting;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.DoListRemoved(ANewOwner: TADDatSObject);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDatSObject.DoListRemoving;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
class function TADDatSObject.GetClassPrefix: String;
begin
  Result := 'TADDatS';
end;

{-------------------------------------------------------------------------------}
{- TADDatSList                                                                 -}
{-------------------------------------------------------------------------------}
constructor TADDatSList.Create;
begin
  inherited Create;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSList.Destroy;
begin
  LockNotification;
  Clear;
  SetLength(FArray, 0);
  FCount := 0;
  FCapacity := 0;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDatSList.AddObject(AObj: TADDatSObject): Integer;
begin
  Result := Count;
  AddObjectAt(AObj, -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.AddEx(AObj: TADDatSObject);
begin
  try
    AddObjectAt(AObj, -1);
  except
    ADFree(AObj);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.AddObjectAt(AObj: TADDatSObject; AIndex: Integer);
var
  oList: TADDatSList;
  prevOwnObjects: Boolean;
begin
  ASSERT((AObj <> nil) and (
    not OwnObjects or
    (AObj.Owner = nil) or
    (AObj.Owner = Owner)
  ));
  ASSERT((AIndex >= -1) and (AIndex <= FCount));
  if OwnObjects then begin
    Notify(snObjectInserting, FDefaultReason, TADNativeInt(Self), TADNativeInt(AObj));
    if (AObj.Owner <> nil) and (AObj.Owner is TADDatSList) then begin
      oList := TADDatSList(AObj.Owner);
      prevOwnObjects := oList.OwnObjects;
      oList.OwnObjects := False;
      try
        oList.Remove(AObj);
      finally
        oList.OwnObjects := prevOwnObjects;
      end;
    end;
  end;
  if FCapacity = FCount then begin
    if FCapacity > 64 then
      Inc(FCapacity, FCapacity div 4)
    else if FCapacity > 8 then
      Inc(FCapacity, 16)
    else
      Inc(FCapacity, 4);
    SetLength(FArray, FCapacity);
  end;
  if (AIndex = -1) or (AIndex = FCount) then
    FArray[FCount] := AObj
  else begin
    Move(FArray[AIndex], FArray[AIndex + 1], (FCount - AIndex) * SizeOf(TADDatSObject));
{$IFDEF AUTOREFCOUNT}
    Pointer(FArray[AIndex]) := nil;
{$ENDIF}
    FArray[AIndex] := AObj;
  end;
  Inc(FCount);
  if OwnObjects then begin
    AObj.FOwner := Self;
    Notify(snObjectInserted, FDefaultReason, TADNativeInt(Self), TADNativeInt(AObj));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.Copy(ASource: TADDatSList);
begin
  FArray := System.Copy(ASource.FArray);
  FCount := ASource.FCount;
  FCapacity := ASource.FCapacity;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.Assign(AObj: TADDatSObject);
var
  i: Integer;
  oObj: TADDatSObject;
begin
  ASSERT(FOwnObjects);
  Clear;
  if AObj is TADDatSList then begin
    MinimumCapacity := TADDatSList(AObj).MinimumCapacity;
    Capacity := TADDatSList(AObj).Capacity;
    for i := 0 to TADDatSList(AObj).Count - 1 do begin
      oObj := TADDatSObjectClass(TADDatSList(AObj).ItemsI[i].ClassType).Create;
      AddObject(oObj);
      oObj.Assign(TADDatSList(AObj).ItemsI[i]);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.Clear;
begin
  if OwnObjects then
    while Count > 0 do
      RemoveAt(Count - 1)
  else
    FCount := 0;
  Capacity := MinimumCapacity;
end;

{-------------------------------------------------------------------------------}
function TADDatSList.ContainsObj(AObj: TADDatSObject): Boolean;
begin
  Result := IndexOf(AObj) <> -1;
end;

{-------------------------------------------------------------------------------}
function TADDatSList.GetItemsI(AIndex: Integer): TADDatSObject;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := FArray[AIndex];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.Notify(AParam: PADDatSNotifyParam);
begin
  if AParam^.FParam1 = TADNativeInt(Self) then
    case AParam^.FKind of
    snObjectRemoving:
      TADDatSObject(AParam^.FParam2).DoListRemoving;
    snObjectRemoved:
      TADDatSObject(AParam^.FParam2).DoListRemoved(Owner);
    snObjectInserting:
      TADDatSObject(AParam^.FParam2).DoListInserting;
    snObjectInserted:
      TADDatSObject(AParam^.FParam2).DoListInserted;
    end;
  inherited Notify(AParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.HandleNotification(AParam: PADDatSNotifyParam);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    FArray[i].HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
function TADDatSList.IndexOf(AObj: TADDatSObject): Integer;
begin
  ASSERT(AObj <> nil);
  Result := ADIndexOf(FArray, FCount, AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSList.IsEqualTo(AObj: TADDatSObject): Boolean;
var
  i: Integer;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := (Count = TADDatSList(AObj).Count);
    if Result then begin
      for i := 0 to Count - 1 do
        if not ItemsI[i].IsEqualTo(TADDatSList(AObj).ItemsI[i]) then begin
          Result := False;
          Exit;
       end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSList.Remove(AObj: TADDatSObject; ANotDestroy: Boolean = False): Integer;
begin
  Result := IndexOf(AObj);
  if Result <> -1 then
    RemoveAt(Result, ANotDestroy);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False);
var
  oObj: TADDatSObject;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  oObj := FArray[AIndex];
  if OwnObjects then
    Notify(snObjectRemoving, FDefaultReason, TADNativeInt(Self), TADNativeInt(oObj));
{$IFDEF AUTOREFCOUNT}
  FArray[AIndex] := nil;
{$ENDIF}
  if FCount - AIndex - 1 > 0 then begin
    Move(FArray[AIndex + 1], FArray[AIndex], (FCount - AIndex - 1) * SizeOf(TADDatSObject));
{$IFDEF AUTOREFCOUNT}
    Pointer(FArray[FCount - 1]) := nil;
{$ENDIF}
  end;
  Dec(FCount);
  if OwnObjects then begin
    oObj.FOwner := nil;
    try
      Notify(snObjectRemoved, FDefaultReason, TADNativeInt(Self), TADNativeInt(oObj));
    finally
      if not ANotDestroy then
        ADFree(oObj);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.SetCapacity(const AValue: Integer);
begin
  ASSERT((AValue <= MAXINT div SizeOf(Pointer)) and (AValue >= 0));
  if FCapacity <> AValue then begin
    SetLength(FArray, AValue);
    FCapacity := AValue;
    if FCount > FCapacity then
      FCount := FCapacity;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.SetMinimumCapacity(const AValue: Integer);
begin
  ASSERT((AValue <= MAXINT div SizeOf(Pointer)) and (AValue >= 0));
  if FMinimumCapacity <> AValue then begin
    FMinimumCapacity := AValue;
    if FMinimumCapacity > Capacity then
      Capacity := FMinimumCapacity;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.MoveTo(AFromIndex, AToIndex: Integer);
var
  oObj: TADDatSObject;
begin
  ASSERT((AFromIndex >= 0) and (AFromIndex < FCount));
  ASSERT((AToIndex >= 0) and (AToIndex < FCount));
  oObj := FArray[AFromIndex];
  if AFromIndex < AToIndex then
    Move(FArray[AFromIndex + 1], FArray[AFromIndex], (AToIndex - AFromIndex) * SizeOf(TADDatSObject))
  else if AFromIndex > AToIndex then
    Move(FArray[AToIndex], FArray[AToIndex + 1], (AFromIndex - AToIndex) * SizeOf(TADDatSObject));
{$IFDEF AUTOREFCOUNT}
  Pointer(FArray[AToIndex]) := nil;
{$ENDIF}
  FArray[AToIndex] := oObj;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.InternalLoadFromStorage(AStorage: TADStorage);
var
  sName: String;
begin
  sName := GetStreamingName(AStorage);
  while not AStorage.IsObjectEnd(sName) do
    AddEx(AStorage.LoadObject as TADDatSObject);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSList.InternalSaveToStorage(AStorage: TADStorage);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    AStorage.SaveObject(ItemsI[i]);
end;

{-------------------------------------------------------------------------------}
{- TADDatSNamedObject                                                          -}
{-------------------------------------------------------------------------------}
type
  TADDatSNamedObjectUpdateInfo = record
    FPrevName: String;
  end;
  PADDatSNamedObjectUpdateInfo = ^TADDatSNamedObjectUpdateInfo;

{-------------------------------------------------------------------------------}
constructor TADDatSNamedObject.Create;
begin
  inherited Create;
  FName := GetDefaultName;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedObject.Assign(AObj: TADDatSObject);
var
  oList: TADDatSNamedList;
begin
  if AObj is TADDatSNamedObject then begin
    oList := NamedList;
    if oList <> nil then
      Name := oList.BuildUniqueName(TADDatSNamedObject(AObj).Name)
    else
      Name := TADDatSNamedObject(AObj).Name;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedObject.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := TADDatSNamedObject(AObj).Name = Name;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedObject.GetNamedList: TADDatSNamedList;
begin
  Result := TADDatSNamedList(GetOwnerByClass(TADDatSNamedList));
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedObject.GetDefaultName: String;
begin
  Result := UpperCase(ClassName);
  if (Length(Result) > 9) and (Copy(Result, 1, 7) = 'TADDATS') then
    Result := Copy(ClassName, 8, Length(Result) - 7)
  else
    Result := ClassName;
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedObject.GetIsDefaultName: Boolean;
begin
  Result := Pos(DefaultName, Name) = 1;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedObject.SetName(const AValue: String);
var
  oList: TADDatSNamedList;
  rInfo: TADDatSNamedObjectUpdateInfo;
begin
  if FName <> AValue then begin
    oList := NamedList;
    if oList <> nil then
      oList.CheckUniqueName(AValue, Self);
    FPrevName := FName;
    FName := AValue;
    try
      if FPrevName <> '' then begin
        rInfo.FPrevName := PrevName;
        Notify(snObjectNameChanged, srMetaChange, TADNativeInt(Self), TADNativeInt(@rInfo));
      end;
      FPrevName := FName;
    except
      FName := FPrevName;
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedObject.InternalLoadFromStorage(AStorage: TADStorage);
begin
  Name := AStorage.ReadString('Name', Name);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedObject.InternalSaveToStorage(AStorage: TADStorage);
begin
  if (Name <> '') and (Name <> DefaultName) then
    AStorage.WriteString('Name', Name, '');
end;

{-------------------------------------------------------------------------------}
{- TADDatSNamedList                                                            -}
{-------------------------------------------------------------------------------}
constructor TADDatSNamedList.Create;
begin
  inherited Create;
  FNamesIndex := TADStringList.Create;
  FNamesIndex.Duplicates := dupAccept;
  FNamesIndex.Sorted := True;
{$IFDEF AnyDAC_D6}
  {$IFDEF AnyDAC_NOLOCALE_META}
  FNamesIndex.CaseSensitive := False;
  {$ENDIF}
{$ENDIF}
  FDefaultReason := srMetaChange;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSNamedList.Destroy;
begin
  inherited Destroy;
  ADFreeAndNil(FNamesIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedList.AddObjectAt(AObj: TADDatSObject; AIndex: Integer);
begin
  ASSERT(AObj <> nil);
  if TADDatSNamedObject(AObj).FPrevName = '' then
    TADDatSNamedObject(AObj).Name := BuildUniqueName(TADDatSNamedObject(AObj).Name);
  inherited AddObjectAt(AObj, AIndex);
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.Find(const AName: String; out AIndex: Integer): Boolean;
begin
  Result := FNamesIndex.Find({$IFNDEF AnyDAC_D6}
    {$IFDEF AnyDAC_NOLOCALE_META} UpperCase {$ELSE} AnsiUpperCase {$ENDIF}{$ENDIF}
    (AName), AIndex);
  if not Result then
    AIndex := -1;
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.FindRealIndex(const AName: String; out AIndex: Integer): Boolean;
begin
  Result := Find(AName, AIndex);
  if Result then
    AIndex := TADDatSNamedObject(FNamesIndex.Objects[AIndex]).Index;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedList.CheckUniqueName(const AName: String; ASelf: TADDatSNamedObject);
  procedure ErrorDubName;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_DuplicatedName, [AName]);
  end;
var
  i: Integer;
begin
  i := -1;
  if (AName <> '') and FindRealIndex(AName, i) and (ASelf <> ItemsI[i]) then
    ErrorDubName;
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.ContainsName(const AName: String): Boolean;
var
  i: Integer;
begin
  Result := Find(AName, i);
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.GetItemsI(AIndex: Integer): TADDatSNamedObject;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSNamedObject(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.IndexOfName(const AName: String): Integer;
begin
  Result := -1;
  FindRealIndex(AName, Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedList.ErrorNameNotFound(const AName: String);
begin
  ADException(Self, [S_AD_LDatS], er_AD_NameNotFound, [AName]);
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.ItemByName(const AName: String): TADDatSNamedObject;
var
  i: Integer;
begin
  i := -1;
  if not Find(AName, i) then
    ErrorNameNotFound(AName);
  Result := TADDatSNamedObject(FNamesIndex.Objects[i]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedList.Notify(AParam: PADDatSNotifyParam);

  procedure DoObjectChanged;
  var
    sName: String;
    i: Integer;
  begin
    if AParam^.FKind = snObjectInserting then begin
      sName := TADDatSNamedObject(AParam^.FParam2).Name;
      if sName <> '' then
        CheckUniqueName(sName, TADDatSNamedObject(AParam^.FParam2));
    end
    else if AParam^.FKind = snObjectRemoved then begin
      sName := TADDatSNamedObject(AParam^.FParam2).Name;
      i := -1;
      if (sName <> '') and FNamesIndex.Find(
         {$IFNDEF AnyDAC_D6}{$IFDEF AnyDAC_NOLOCALE_META} UpperCase {$ELSE} AnsiUpperCase {$ENDIF}{$ENDIF}(sName), i) then
        FNamesIndex.Delete(i);
    end
    else if AParam^.FKind = snObjectInserted then begin
      sName := TADDatSNamedObject(AParam^.FParam2).Name;
      if sName <> '' then
        FNamesIndex.AddObject(
          {$IFNDEF AnyDAC_D6}{$IFDEF AnyDAC_NOLOCALE_META} UpperCase {$ELSE} AnsiUpperCase {$ENDIF}{$ENDIF}(sName),
          TADDatSNamedObject(AParam^.FParam2));
    end;
  end;

  procedure DoObjectRenamed;
  var
    oObj: TADDatSNamedObject;
    sPrevName: String;
    i: Integer;
  begin
    oObj := TADDatSNamedObject(AParam^.FParam1);
    if oObj.List = Self then begin
      sPrevName := PADDatSNamedObjectUpdateInfo(AParam^.FParam2)^.FPrevName;
      if sPrevName <> '' then begin
        i := -1;
        if FNamesIndex.Find(
           {$IFNDEF AnyDAC_D6}{$IFDEF AnyDAC_NOLOCALE_META} UpperCase {$ELSE} AnsiUpperCase {$ENDIF}{$ENDIF}(sPrevName), i) then
          FNamesIndex.Delete(i);
      end;
      if oObj.Name <> '' then
        FNamesIndex.AddObject(
          {$IFNDEF AnyDAC_D6}{$IFDEF AnyDAC_NOLOCALE_META} UpperCase {$ELSE} AnsiUpperCase {$ENDIF}{$ENDIF}(oObj.Name), oObj);
    end;
  end;

begin
  if AParam^.FParam1 = TADNativeInt(Self) then
    DoObjectChanged
  else if AParam^.FKind = snObjectNameChanged then
    DoObjectRenamed;
  inherited Notify(AParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedList.RemoveByName(const AName: String);
var
  i: Integer;
begin
  i := IndexOfName(AName);
  if i = -1 then
    ErrorNameNotFound(AName);
  RemoveAt(i);
end;

{-------------------------------------------------------------------------------}
function TADDatSNamedList.BuildUniqueName(const AName: String): String;
var
  i: Integer;
begin
  Result := AName;
  i := 0;
  while ContainsName(Result) do begin
    Inc(i);
    Result := AName + '_' + IntToStr(i);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNamedList.InternalLoadFromStorage(AStorage: TADStorage);
var
  sStrName, sObj, sName: String;
  i: Integer;
  oBmk: TObject;
begin
  sStrName := GetStreamingName(AStorage);
  while not AStorage.IsObjectEnd(sStrName) do begin
    oBmk := AStorage.GetBookmark;
    try
      sObj := AStorage.ReadObjectBegin('');
      sName := AStorage.ReadString('Name', '');
      AStorage.SetBookmark(oBmk);
    finally
      ADFree(oBmk);
    end;
    i := IndexOfName(sName);
    if (i <> -1) and (CompareText(ItemsI[i].GetStreamingName(AStorage), sObj) = 0) then
      ItemsI[i].LoadFromStorage(AStorage)
    else
      AddEx(AStorage.LoadObject as TADDatSObject);
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSBindedObject                                                         -}
{-------------------------------------------------------------------------------}
constructor TADDatSBindedObject.Create;
begin
  inherited Create;
  FSourceName := Name;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSBindedObject.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSBindedObject then begin
    FSourceName := TADDatSBindedObject(AObj).FSourceName;
    FSourceID := TADDatSBindedObject(AObj).FSourceID;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSBindedObject.InternalLoadFromStorage(AStorage: TADStorage);
begin
  inherited InternalLoadFromStorage(AStorage);
  SourceName := AStorage.ReadString('SourceName', Name);
  SourceID := AStorage.ReadInteger('SourceID', 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSBindedObject.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  if (SourceName <> '') and (SourceName <> DefaultName) and
     (SourceName <> Name) then
    AStorage.WriteString('SourceName', SourceName, '');
  AStorage.WriteInteger('SourceID', SourceID, 0);
end;

{-------------------------------------------------------------------------------}
{- TADDatSBindedList                                                           -}
{-------------------------------------------------------------------------------}
function TADDatSBindedList.ItemByName(const AName: String): TADDatSBindedObject;
begin
  Result := TADDatSBindedObject(inherited ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
function TADDatSBindedList.GetItemsI(AIndex: Integer): TADDatSBindedObject;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSBindedObject(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSBindedList.IndexOfSourceName(const AName: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
       (ItemsI[i].SourceName, AName) = 0 then begin
      Result := i;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSBindedList.IndexOfSourceID(AID: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if ItemsI[i].SourceID = AID then begin
      Result := i;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSColumn                                                               -}
{-------------------------------------------------------------------------------}
constructor TADDatSColumn.Create;
begin
  inherited Create;
  FAttributes := [caAllowNull];
  FOptions := [coAllowNull, coInUpdate, coInWhere];
  FAutoIncrementSeed := 1;
  FAutoIncrementStep := 1;
  FIndex := -1;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSColumn.Create(const AName: String;
  AType: TADDataType = dtAnsiString; const AExpression: String = '');
begin
  Create;
  if AName <> '' then
    Name := AName;
  DataType := AType;
  Expression := AExpression;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.Assign(AObj: TADDatSObject);
begin
  DefinitionChanging(True);
  inherited Assign(AObj);
  if AObj is TADDatSColumn then begin
    FAttributes := TADDatSColumn(AObj).FAttributes;
    FAutoIncrement := TADDatSColumn(AObj).FAutoIncrement;
    FAutoIncrementSeed := TADDatSColumn(AObj).FAutoIncrementSeed;
    FAutoIncrementStep := TADDatSColumn(AObj).FAutoIncrementStep;
    FCaption := TADDatSColumn(AObj).FCaption;
    FDataType := TADDatSColumn(AObj).FDataType;
    FExpression := TADDatSColumn(AObj).FExpression;
    if FExpression <> '' then
      FEvaluator := nil
    else
      FEvaluator := TADDatSColumn(AObj).FEvaluator;
    FOptions := TADDatSColumn(AObj).FOptions;
    FPrecision := TADDatSColumn(AObj).FPrecision;
    FSize := TADDatSColumn(AObj).FSize;
    FScale := TADDatSColumn(AObj).FScale;
    FSourceDataType := TADDatSColumn(AObj).FSourceDataType;
    FSourcePrecision := TADDatSColumn(AObj).FSourcePrecision;
    FSourceScale := TADDatSColumn(AObj).FSourceScale;
    FSourceSize := TADDatSColumn(AObj).FSourceSize;
    FSourceDataTypeName := TADDatSColumn(AObj).FSourceDataTypeName;
    FOriginTabName := TADDatSColumn(AObj).FOriginTabName;
    FOriginColName := TADDatSColumn(AObj).FOriginColName;
    FSourceGenerator := TADDatSColumn(AObj).FSourceGenerator;
    DefinitionChanged(True);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.DefinitionChanged(ALayoutChanged: Boolean);
begin
  Notify(snColumnDefChanged, srMetaChange, TADNativeInt(Self), TADNativeInt(ALayoutChanged));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.DefinitionChanging(ALayoutChanging: Boolean);
var
  oTab: TADDatSTable;
begin
  if ALayoutChanging then begin
    oTab := Table;
    if oTab <> nil then
      oTab.CheckLayoutChanging;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.Notify(AParam: PADDatSNotifyParam);
begin
  inherited Notify(AParam);
  if (AParam^.FKind = snObjectNameChanged) and (AParam^.FParam1 = TADNativeInt(Self)) then begin
    if FSourceName = PADDatSNamedObjectUpdateInfo(AParam^.FParam2)^.FPrevName then
      FSourceName := Name;
    if FOriginColName = PADDatSNamedObjectUpdateInfo(AParam^.FParam2)^.FPrevName then
      FOriginColName := Name;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetCaption: String;
begin
  if FCaption = '' then
    Result := Name
  else
    Result := FCaption;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetNestedTable: TADDatSTable;
var
  oManager: TADDatSManager;
  oRel: TADDatSRelation;
begin
  Result := nil;
  oManager := Manager;
  if oManager <> nil then begin
    oRel := oManager.Relations.FindRelation(Table, Self);
    if oRel <> nil then
      Result := oRel.ChildTable;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetParentColumn: TADDatSColumn;
var
  oManager: TADDatSManager;
  oRel: TADDatSRelation;
begin
  Result := nil;
  oManager := Manager;
  if oManager <> nil then begin
    oRel := oManager.Relations.FindRelation(Table);
    if oRel <> nil then
      Result := oRel.ParentColumns[0];
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetColumnList: TADDatSColumnList;
begin
  Result := List as TADDatSColumnList;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetReadOnly: Boolean;
begin
  Result := coReadOnly in ActualOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetReadOnly(const AValue: Boolean);
begin
  if AValue then
    Options := Options + [coReadOnly]
  else
    Options := Options - [coReadOnly];
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetStorageSize: Integer;
  procedure ErrorColTypeUndef;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColTypeUndefined, [Name]);
  end;
begin
  Result := 0;
  if caBlobData in Attributes then
    Result := Sizeof(TADBlobData)
  else if not (DataType in C_AD_InvariantDataTypes) then
    case DataType of
    dtUnknown:          ErrorColTypeUndef;
    dtBoolean:          Result := Sizeof(WordBool);
    dtSByte:            Result := Sizeof(ShortInt);
    dtInt16:            Result := Sizeof(SmallInt);
    dtInt32:            Result := Sizeof(Integer);
    dtInt64:            Result := Sizeof(Int64);
    dtByte:             Result := Sizeof(Byte);
    dtUInt16:           Result := Sizeof(Word);
    dtUInt32:           Result := Sizeof(LongWord);
    dtUInt64:           Result := Sizeof(UInt64);
    dtSingle:           Result := Sizeof(Single);
    dtDouble:           Result := Sizeof(Double);
    dtExtended:         Result := Sizeof(Extended);
    dtCurrency:         Result := Sizeof(Currency);
    dtBCD,
    dtFmtBCD:           Result := Sizeof(TADBcd);
    dtDateTime:         Result := Sizeof(TADDateTimeData);
    dtDateTimeStamp:    Result := Sizeof(TADSQLTimeStamp);
    dtTimeIntervalFull,
    dtTimeIntervalYM,
    dtTimeIntervalDS:   Result := SizeOf(TADSQLTimeInterval);
    dtTime:             Result := Sizeof(Longint);
    dtDate:             Result := Sizeof(Longint);
    dtAnsiString:       Result := SizeOf(Word) + Size * SizeOf(TADAnsiChar) + SizeOf(TADAnsiChar);
    dtByteString:       Result := SizeOf(Word) + Size;
    dtWideString:       Result := SizeOf(Word) + Size * SizeOf(WideChar) + SizeOf(WideChar);
    dtGUID:             Result := Sizeof(TGUID);
    dtObject:           Result := Sizeof(IADDataStoredObject);
    else                ASSERT(False);
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetDisplayWidth: Integer;
begin
  case DataType of
  dtBoolean:          Result := 5;
  dtSByte:            if Precision > 0 then Result := Precision + 1 else Result := 4;
  dtInt16:            if Precision > 0 then Result := Precision + 1 else Result := 6;
  dtInt32:            if Precision > 0 then Result := Precision + 1 else Result := 11;
  dtInt64:            if Precision > 0 then Result := Precision + 1 else Result := 21;
  dtByte:             if Precision > 0 then Result := Precision + 1 else Result := 3;
  dtUInt16:           if Precision > 0 then Result := Precision + 1 else Result := 5;
  dtUInt32:           if Precision > 0 then Result := Precision + 1 else Result := 10;
  dtUInt64:           if Precision > 0 then Result := Precision + 1 else Result := 20;
  dtSingle:           if Precision > 0 then Result := Precision + 2 else Result := 10;
  dtDouble:           if Precision > 0 then Result := Precision + 2 else Result := 18;
  dtExtended:         if Precision > 0 then Result := Precision + 2 else Result := 22;
  dtCurrency:         if Precision > 0 then Result := Precision + 2 else Result := 22;
  dtBCD:              if Precision > 0 then Result := Precision + 2 else Result := 22;
  dtFmtBCD:           if Precision > 0 then Result := Precision + 2 else Result := 38;
  dtDateTime:         Result := 27;
  dtDateTimeStamp:    Result := 27;
  dtTimeIntervalFull: if Precision > 0 then Result := Precision + 26 else Result := 35;
  dtTimeIntervalYM:   if Precision > 0 then Result := Precision + 4 else Result := 13;
  dtTimeIntervalDS:   if Precision > 0 then Result := Precision + 14 else Result := 23;
  dtTime:             Result := 11;
  dtDate:             Result := 16;
  dtAnsiString:       Result := Size;
  dtByteString:       Result := Size * 2;
  dtWideString:       Result := Size;
  dtGUID:             Result := C_AD_GUIDStrLen;
  else                Result := 20;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetAttributes(const AValue: TADDataAttributes);
var
  ePrevAttrs: TADDataAttributes;
  lLayout: Boolean;
begin
  if FAttributes <> AValue then begin
    lLayout :=
      ([caBlobData, caAutoInc, caCalculated, caVirtual] * FAttributes) <>
      ([caBlobData, caAutoInc, caCalculated, caVirtual] * AValue);
    DefinitionChanging(lLayout);
    ePrevAttrs := FAttributes;
    FAttributes := AValue;
    if (caCalculated in ePrevAttrs) and not (caCalculated in FAttributes) then
      Expression := '';
    if FDataType in C_AD_NonSearchableDataTypes then
      Exclude(FAttributes, caSearchable);
    if not (caAllowNull in ePrevAttrs) and (caAllowNull in FAttributes) then
      Include(FOptions, coAllowNull)
    else if (caAllowNull in ePrevAttrs) and not (caAllowNull in FAttributes) then
      Exclude(FOptions, coAllowNull);
    if not (caReadOnly in ePrevAttrs) and (caReadOnly in FAttributes) then
      Include(FOptions, coReadOnly)
    else if (caReadOnly in ePrevAttrs) and not (caReadOnly in FAttributes) then
      Exclude(FOptions, coReadOnly);
    DefinitionChanged(lLayout);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetAutoIncrement(const AValue: Boolean);
begin
  if FAutoIncrement <> AValue then begin
    DefinitionChanging(True);
    FAutoIncrement := AValue;
    if FAutoIncrement and not IsAutoIncrementType(FDataType) then
      FDataType := dtUInt32;
    DefinitionChanged(True);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetServerAutoIncrement: Boolean;
begin
  Result := AutoIncrement and
    (Attributes * [caAutoInc, caAllowNull] = [caAutoInc, caAllowNull]) and
    (Options * [coAfterInsChanged, coInUpdate] = [coAfterInsChanged]) and
    (AutoIncrementSeed = -1) and (AutoIncrementStep = -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetServerAutoIncrement(const Value: Boolean);
begin
  SetAutoIncrement(Value);
  if Value then begin
    Attributes := Attributes + [caAutoInc, caAllowNull];
    Options := Options + [coAfterInsChanged] - [coInUpdate];
    AutoIncrementSeed := -1;
    AutoIncrementStep := -1;
  end
  else begin
    Attributes := Attributes - [caAutoInc];
    Options := Options - [coAfterInsChanged] + [coInUpdate];
    AutoIncrementSeed := 1;
    AutoIncrementStep := 1;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetAutoIncrementSeed(const AValue: Integer);
begin
  if FAutoIncrementSeed <> AValue then begin
    DefinitionChanging(False);
    FAutoIncrementSeed := AValue;
    DefinitionChanged(False);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetAutoIncrementStep(const AValue: Integer);
begin
  if FAutoIncrementStep <> AValue then begin
    DefinitionChanging(False);
    FAutoIncrementStep := AValue;
    DefinitionChanged(False);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetSourceGenerator(const AValue: String);
begin
  if FSourceGenerator <> AValue then begin
    FSourceGenerator := AValue;
    Include(FOptions, coInUpdate);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetCaption(const AValue: String);
begin
  if FCaption <> AValue then begin
    if AValue = Name then
      FCaption := ''
    else
      FCaption := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.IsAutoIncrementType(const AValue: TADDataType): Boolean;
begin
  Result := AValue in [dtSByte, dtInt16, dtInt32, dtInt64,
                       dtByte, dtUInt16, dtUInt32, dtUInt64,
                       dtSingle, dtDouble, dtExtended, dtBCD, dtFmtBCD];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetDataType(const AValue: TADDataType);
  procedure CantChangeDataType;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantChngColType, [Name]);
  end;
var
  ePrevDataType: TADDataType;
  iPrevSize: LongWord;
  iPrevPrec: Integer;
begin
  if FDataType <> AValue then begin
    DefinitionChanging(True);
    if Table <> nil then begin
      if Table.Rows.Count > 0 then
        CantChangeDataType;
    end;
    iPrevSize := FSize;
    iPrevPrec := FPrecision;
    ePrevDataType := FDataType;
    FDataType := AValue;
    if not IsAutoIncrementType(FDataType) then
      FAutoIncrement := False;
    if FDataType in [dtAnsiString, dtWideString, dtByteString] then
      if ColumnList <> nil then
        if ColumnList.InlineDataSize = 0 then
          FSize := MAXINT
        else
          FSize := ColumnList.InlineDataSize
      else
        FSize := 50
    else
      FSize := 0;
    if FDataType in C_AD_NonSearchableDataTypes then
      Exclude(FAttributes, caSearchable);
    if FDataType in C_AD_BlobTypes then
      Include(FAttributes, caBlobData)
    else
      Exclude(FAttributes, caBlobData);
    case FDataType of
    dtSingle:   FPrecision := 8;
    dtDouble:   FPrecision := 16;
    dtExtended: FPrecision := 20;
    dtCurrency: FPrecision := 20;
    dtBCD,
    dtFmtBCD:   FPrecision := 64;
    else        FPrecision := 0;
    end;
    if FSourceDataType = ePrevDataType then
      FSourceDataType := AValue;
    if FSourceSize = iPrevSize then
      FSourceSize := FSize;
    if FSourcePrecision = iPrevPrec then
      FSourcePrecision := FPrecision;
    DefinitionChanged(True);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetExpression(const AValue: String);
var
  oCols: TADDatSColumnList;
  oParser: IADStanExpressionParser;
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    FEvaluator := nil;
    if SourceID <= 0 then
      if AValue <> '' then begin
        FAttributes := FAttributes + [caReadOnly, caCalculated];
        FOptions := FOptions + [coReadOnly];
      end
      else
        FAttributes := FAttributes - [caCalculated];
    oCols := GetColumnList;
    if (FExpression = '') or (oCols = nil) or (Length(oCols.FDataOffsets) = 0) then
      DefinitionChanged(True)
    else begin
      oCols.FHasThings := oCols.FHasThings + [ctExps, ctDefs, ctCalcs];
      ADCreateInterface(IADStanExpressionParser, oParser);
      FEvaluator := oParser.Prepare(TADDatSTableExpressionDS.Create(Table),
        Expression, [], [poDefaultExpr], Name);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetEvaluator(const AValue: IADStanExpressionEvaluator);
begin
  if FEvaluator <> AValue then begin
    Expression := '';
    FEvaluator := AValue;
    if FEvaluator <> nil then begin
      FAttributes := FAttributes + [caReadOnly, caCalculated];
      FOptions := FOptions + [coReadOnly];
    end;
    DefinitionChanged(False);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetOptions(const AValue: TADDataOptions);
var
  lUKChng: Boolean;
begin
  if FOptions <> AValue then begin
    lUKChng := (coUnique in Options) <> (coUnique in AValue);
    FOptions := AValue;
    if lUKChng and (Table <> nil) then
      UpdateUniqueKey(coUnique in AValue);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetPrecision(const AValue: Integer);
begin
  if FPrecision <> AValue then begin
    DefinitionChanging(False);
    if FPrecision = FSourcePrecision then begin
      FPrecision := AValue;
      FSourcePrecision := AValue;
    end
    else
      FPrecision := AValue;
    DefinitionChanged(False);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetScale(const AValue: Integer);
begin
  if FScale <> AValue then begin
    DefinitionChanging(False);
    if FScale = FSourceScale then begin
      FScale := AValue;
      FSourceScale := AValue;
    end
    else
      FScale := AValue;
    DefinitionChanged(False);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetSize(const AValue: LongWord);
begin
  if FSize <> AValue then begin
    DefinitionChanging(True);
    if FSize = FSourceSize then begin
      FSize := AValue;
      FSourceSize := AValue;
    end
    else
      FSize := AValue;
    DefinitionChanged(True);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetAllowDBNull: Boolean;
begin
  Result := coAllowNull in ActualOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetAllowDBNull(const AValue: Boolean);
begin
  if AValue then
    Options := Options + [coAllowNull]
  else
    Options := Options - [coAllowNull];
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetUnique: Boolean;
begin
  Result := coUnique in ActualOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.SetUnique(const AValue: Boolean);
begin
  if AValue then
    Options := Options + [coUnique]
  else
    Options := Options - [coUnique];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.UpdateUniqueKey(AUnique: Boolean);
var
  oCons: TADDatSConstraintList;
  oCon: TADDatSConstraintBase;
  i: Integer;
  oList: TADDatSColumnList;
begin
  oCons := Table.Constraints;
  if oCons = nil then
    Exit;
  oCon := nil;
  for i := 0 to oCons.Count - 1 do begin
    oCon := oCons.ItemsI[i];
    if (oCon is TADDatSUniqueConstraint) and
       (TADDatSUniqueConstraint(oCon).ColumnCount = 1) and
       (TADDatSUniqueConstraint(oCon).Columns[0] = Self) then
      Break
    else
      oCon := nil;
  end;
  if AUnique then begin
    try
      oList := GetColumnList;
      if (oCon = nil) then begin
        if (oList = nil) or not (ctSerializing in oList.HasThings) then
          oCons.AddUK('', Self, False);
      end
      else
        oCon.Enforce := True;
    except
      Exclude(FOptions, coUnique);
      raise;
    end;
  end
  else begin
    if oCon <> nil then
      ADFree(oCon);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.DoListInserting;
begin
  DefinitionChanging(True);
  inherited DoListInserting;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.DoListInserted;
begin
  inherited DoListInserted;
  if Unique then
    UpdateUniqueKey(True);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.DoListRemoving;
begin
  DefinitionChanging(True);
  inherited DoListRemoving;
  if Unique then
    UpdateUniqueKey(False);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetIndex: Integer;
begin
  Result := FIndex;
  if Result = -1 then
    Result := inherited GetIndex;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetActualCaption: String;
begin
  Result := Caption;
  if Assigned(Table.MetadataCallback) then
    Table.MetadataCallback.GetColumnCaption(Self, Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetActualAttributes: TADDataAttributes;
begin
  Result := Attributes;
  if Assigned(Table.MetadataCallback) then
    Table.MetadataCallback.GetColumnAttributes(Self, Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetActualOptions: TADDataOptions;
begin
  Result := Options;
  if Assigned(Table.MetadataCallback) then
    Table.MetadataCallback.GetColumnOptions(Self, Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetActualOriginColName: String;
begin
  Result := OriginColName;
  if Result = '' then
    Result := SourceName;
  if Assigned(Table.MetadataCallback) then
    Table.MetadataCallback.GetColumnOrigin(Self, Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumn.GetActualGenerator: String;
begin
  Result := SourceGenerator;
  if Assigned(Table.MetadataCallback) then
    Table.MetadataCallback.GetColumnGenerator(Self, Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.InternalLoadFromStorage(AStorage: TADStorage);
var
  eAttrs: TADDataAttributes;
  eAttr: TADDataAttribute;
  eOpts: TADDataOptions;
  eOpt: TADDataOption;
begin
  inherited InternalLoadFromStorage(AStorage);
  DataType := TADDataType(AStorage.ReadEnum('DataType',
    TypeInfo(TADDataType), Integer(dtUnknown)));
  Precision := AStorage.ReadInteger('Precision', 0);
  Scale := AStorage.ReadInteger('Scale', 0);
  Size := AStorage.ReadInteger('Size', 0);
  eAttrs := [];
  for eAttr := Low(TADDataAttribute) to High(TADDataAttribute) do
    if AStorage.ReadBoolean(Copy(GetEnumName(TypeInfo(TADDataAttribute),
                            Integer(eAttr)), 3, MAXINT), False) then
      Include(eAttrs, eAttr);
  Attributes := eAttrs;
  AutoIncrement := AStorage.ReadBoolean('AutoIncrement', caAutoInc in Attributes);
  AutoIncrementSeed := AStorage.ReadInteger('AutoIncrementSeed', 1);
  AutoIncrementStep := AStorage.ReadInteger('AutoIncrementStep', 1);
  Caption := AStorage.ReadString('Caption', Caption);
  Expression := AStorage.ReadString('Expression', '');
  eOpts := [];
  for eOpt := Low(TADDataOption) to High(TADDataOption) do
    if AStorage.ReadBoolean('O' + Copy(GetEnumName(TypeInfo(TADDataOption),
                            Integer(eOpt)), 3, MAXINT), False) then
      Include(eOpts, eOpt);
  Options := eOpts;
  if AStorage.TestProperty('OriginName') then begin
    OriginTabName := '';
    OriginColName := AStorage.ReadString('OriginName', '');
  end
  else begin
    OriginTabName := AStorage.ReadString('OriginTabName', '');
    OriginColName := AStorage.ReadString('OriginColName', '');
  end;
  if AStorage.TestProperty('SourceDataType') then
    SourceDataType := TADDataType(AStorage.ReadEnum('SourceDataType',
      TypeInfo(TADDataType), Integer(dtUnknown)));
  SourcePrecision := AStorage.ReadInteger('SourcePrecision', 0);
  SourceScale := AStorage.ReadInteger('SourceScale', 0);
  SourceSize := AStorage.ReadInteger('SourceSize', 0);
  SourceDataTypeName := AStorage.ReadString('SourceDataTypeName', '');
  SourceDirectory := AStorage.ReadString('SourceDirectory', '');
  SourceGenerator := AStorage.ReadString('SourceGenerator', '');
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumn.InternalSaveToStorage(AStorage: TADStorage);
var
  eAttr: TADDataAttribute;
  eAttrs: TADDataAttributes;
  eOpt: TADDataOption;
  eOpts: TADDataOptions;
begin
  inherited InternalSaveToStorage(AStorage);
  AStorage.WriteEnum('DataType', TypeInfo(TADDataType), Integer(DataType),
    Integer(dtUnknown));
  AStorage.WriteInteger('Precision', Precision, 0);
  AStorage.WriteInteger('Scale', Scale, 0);
  AStorage.WriteInteger('Size', Size, 0);
  eAttrs := ActualAttributes;
  for eAttr := Low(TADDataAttribute) to High(TADDataAttribute) do
    if (eAttr in eAttrs) and
       ((AStorage.StreamVersion >= 7) or (eAttr <> caBase) and (eAttr <> caExpr)) then
      AStorage.WriteBoolean(Copy(GetEnumName(TypeInfo(TADDataAttribute),
        Integer(eAttr)), 3, MAXINT), True, False);
  AStorage.WriteBoolean('AutoIncrement', AutoIncrement, caAutoInc in Attributes);
  AStorage.WriteInteger('AutoIncrementSeed', AutoIncrementSeed, 1);
  AStorage.WriteInteger('AutoIncrementStep', AutoIncrementStep, 1);
  if (ActualCaption <> '') and (ActualCaption <> Name) then
    AStorage.WriteString('Caption', ActualCaption, '');
  AStorage.WriteString('Expression', Expression, '');
  eOpts := ActualOptions;
  for eOpt := Low(TADDataOption) to High(TADDataOption) do
    if eOpt in eOpts then
      AStorage.WriteBoolean('O' + Copy(GetEnumName(TypeInfo(TADDataOption),
        Integer(eOpt)), 3, MAXINT), True, False);
  if AStorage.StreamVersion >= 2 then begin
    AStorage.WriteString('OriginTabName', ActualOriginTabName, '');
    AStorage.WriteString('OriginColName', ActualOriginColName, '');
  end
  else
    AStorage.WriteString('OriginName', ActualOriginColName, '');
  if (SourceDataType <> dtUnknown) and (SourceDataType <> DataType) then
    AStorage.WriteEnum('SourceDataType', TypeInfo(TADDataType),
      Integer(SourceDataType), Integer(dtUnknown));
  AStorage.WriteInteger('SourcePrecision', SourcePrecision, 0);
  AStorage.WriteInteger('SourceScale', SourceScale, 0);
  AStorage.WriteInteger('SourceSize', SourceSize, 0);
  AStorage.WriteString('SourceDataTypeName', SourceDataTypeName, '');
  AStorage.WriteString('SourceDirectory', SourceDirectory, '');
  AStorage.WriteString('SourceGenerator', ActualGenerator, '');
end;

{-------------------------------------------------------------------------------}
{- TADDatSTableExpressionDS                                                    -}
{-------------------------------------------------------------------------------}
constructor TADDatSTableExpressionDS.Create(ATable: TADDatSTable);
begin
  ASSERT(ATable <> nil);
  inherited Create;
  FTable := ATable;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetPosition: Pointer;
begin
  Result := FRow;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableExpressionDS.SetPosition(AValue: Pointer);
begin
  FRow := TADDatSRow(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetRowNum: Integer;
begin
  ASSERT(FRow <> nil);
  Result := FRow.Index + 1;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetDatabase: String;
begin
  Result := '';
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetUser: String;
begin
  Result := '';
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetSubAggregateValue(AIndex: Integer): Variant;
begin
  Result := Unassigned;
  ASSERT(False);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetVarIndex(const AName: String): Integer;
begin
  Result := FTable.Columns.IndexOfName(AName);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetVarType(AIndex: Integer): TADDataType;
begin
  Result := FTable.Columns[AIndex].DataType;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetVarScope(AIndex: Integer): TADExpressionScopeKind;
begin
  Result := ckField;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableExpressionDS.GetVarData(AIndex: Integer): Variant;
begin
  ASSERT(FRow <> nil);
  Result := FRow.GetData(AIndex, rvDefault);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableExpressionDS.SetVarData(AIndex: Integer;
  const AValue: Variant);
begin
  ASSERT(FRow <> nil);
  FRow.SetData(AIndex, AValue);
end;

{-------------------------------------------------------------------------------}
{- TADDatSColumnList                                                           -}
{-------------------------------------------------------------------------------}
constructor TADDatSColumnList.CreateForTable(ATable: TADDatSTable);
begin
  ASSERT(ATable <> nil);
  inherited Create;
  FOwner := ATable;
  OwnObjects := True;
  FInlineDataSize := C_AD_DefInlineDataSize;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSColumnList then begin
    OnCalcColumns := TADDatSColumnList(AObj).OnCalcColumns;
    InlineDataSize := TADDatSColumnList(AObj).InlineDataSize;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnList.Add(AObj: TADDatSColumn): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnList.Add(const AName: String;
  AType: TADDataType = dtAnsiString; const AExpression: String = ''): TADDatSColumn;
begin
  Result := TADDatSColumn.Create(AName, AType, AExpression);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.AddObjectAt(AObj: TADDatSObject; AIndex: Integer);
var
  oTab: TADDatSTable;
begin
  oTab := Table;
  if oTab <> nil then
    oTab.CheckLayoutChanging;
  inherited AddObjectAt(AObj, AIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.RemoveAt(AIndex: Integer; ANotDestroy: Boolean = False);
var
  oTab: TADDatSTable;
begin
  oTab := Table;
  if oTab <> nil then
    oTab.CheckLayoutChanging;
  inherited RemoveAt(AIndex, ANotDestroy);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnList.ColumnByName(const AName: String): TADDatSColumn;
begin
  Result := TADDatSColumn(inherited ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnList.GetCurrValues(AIndex: Integer): Variant;
var
  oCol: TADDatSColumn;
  iVal: Integer;
  sVal: Single;
  dVal: Double;
  eVal: Extended;
{$IFNDEF AnyDAC_D6Base}
  cVal: Currency;
{$ENDIF}
begin
  Result := Null;
  oCol := ItemsI[AIndex];
  if oCol.AutoIncrement then begin
    iVal := FAutoIncs[AIndex];
    case oCol.DataType of
    dtByte:
      Result := Byte(iVal);
    dtSByte:
      Result := ShortInt(iVal);
    dtUInt16:
      Result := Word(iVal);
    dtInt16:
      Result := SmallInt(iVal);
    dtUInt32:
      Result := LongWord(iVal);
    dtInt32:
      Result := iVal;
    dtUInt64:
{$IFDEF AnyDAC_D6Base}
      Result := UInt64(iVal);
{$ELSE}
      begin
        TVarData(Result).VType := varInt64;
        Decimal(Result).lo64 := UInt64(iVal);
      end;
{$ENDIF}
    dtInt64:
{$IFDEF AnyDAC_D6Base}
      Result := Int64(iVal);
{$ELSE}
      begin
        TVarData(Result).VType := varInt64;
        Decimal(Result).lo64 := Int64(iVal);
      end;
{$ENDIF}
    dtSingle:
      begin
        sVal := iVal;
        Result := sVal;
      end;
    dtDouble:
      begin
        dVal := iVal;
        Result := dVal;
      end;
    dtExtended:
      begin
        eVal := iVal;
        Result := eVal;
      end;
    dtBCD,
    dtFmtBCD:
{$IFDEF AnyDAC_D6Base}
      Result := VarFMTBcdCreate(iVal);
{$ELSE}
      begin
        cVal := iVal;
        Result := cVal;
      end;
{$ENDIF}
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnList.GetItemsI(AIndex: Integer): TADDatSColumn;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSColumn(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.Notify(AParam: PADDatSNotifyParam);
begin
  if (AParam^.FKind = snColumnDefChanged) and
       (TADDatSColumn(TADDatSObject(AParam^.FParam1)).List = Self) and (AParam^.FParam2 <> 0) or
     (AParam^.FKind = snObjectInserted) and (TADDatSObject(AParam^.FParam1) = Self) or
     (AParam^.FKind = snObjectRemoved) and (TADDatSObject(AParam^.FParam1) = Self) then
    TerminateLayout;
  // MSGOPT this condition is only for optimization
  if AParam^.FKind <> snColumnDefChanged then
    inherited Notify(AParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.HandleNotification(AParam: PADDatSNotifyParam);
begin
  // MSGOPT nothing - just exit
  // if AParam^.FReason = srDataChange then
  //   Exit;
  // inherited HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.SetInlineDataSize(const AValue: Word);
begin
  if FInlineDataSize <> AValue then begin
    FInlineDataSize := AValue;
    TerminateLayout;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.CheckUpdateLayout(ARowInstanceSize: Integer);
begin
  if Length(FDataOffsets) = 0 then
    UpdateLayout(ARowInstanceSize);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.UpdateLayout(ARowInstanceSize: Integer);
  procedure ErrorNoCols;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_NoColsDefined, []);
  end;
  procedure ErrorRowSinglePar;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowMayHaveSingleParent, []);
  end;
const
  C_Alignment = {$IFDEF CPUARM} 4 {$ELSE} 2 {$ENDIF};
var
  iOffset: Integer;
  i: Integer;
  oParentCol: TADDatSColumn;
  oParser: IADStanExpressionParser;
  oCol: TADDatSColumn;
begin
  if Count = 0 then
    ErrorNoCols;
  try
    SetLength(FDataOffsets, Count + 1);
    SetLength(FNullOffsets, Count);
    SetLength(FNullMasks, Count);
    iOffset := 0;
    FInvariants := 0;
    FParentRowRefCol := -1;
    FParentCol := -1;
    FHasThings := [];
    oParser := nil;
    for i := 0 to Count - 1 do begin
      oCol := ItemsI[i];
      oCol.FIndex := i;
      if oCol.DataType in C_AD_StrTypes then
        if oCol.Size > InlineDataSize then
          Include(oCol.FAttributes, caBlobData);
      FDataOffsets[i] := iOffset;
      Inc(iOffset, (oCol.StorageSize + C_Alignment - 1) and not (C_Alignment - 1));
      if oCol.AutoIncrement then
        Include(FHasThings, ctAutoIncs);
      if oCol.DataType = dtParentRowRef then begin
        if FParentRowRefCol <> -1 then
          ErrorRowSinglePar
        else
          FParentRowRefCol := i;
        oParentCol := oCol.ParentColumn;
        if oParentCol <> nil then
          FParentCol := oParentCol.Index;
      end;
      if oCol.DataType in C_AD_InvariantDataTypes then begin
        Inc(FInvariants);
        Include(FHasThings, ctInvars);
      end;
      if caCalculated in oCol.Attributes then
        Include(FHasThings, ctCalcs)
      else if oCol.Expression <> '' then
        Include(FHasThings, ctExps);
      if (oCol.Expression <> '') or oCol.AutoIncrement then
        Include(FHasThings, ctDefs);
      if (caBlobData in oCol.FAttributes) or (oCol.DataType = dtObject) then
        Include(FHasThings, ctComp);
    end;
    FDataOffsets[Count] := iOffset;
    for i := 0 to Count - 1 do begin
      FNullOffsets[i] := iOffset + i div 8;
      FNullMasks[i] := Byte(1 shl (i mod 8));
    end;
    if ctAutoIncs in FHasThings then begin
      SetLength(FAutoIncs, Count);
      for i := 0 to Count - 1 do begin
        oCol := ItemsI[i];
        if oCol.AutoIncrement then
          FAutoIncs[i] := oCol.AutoIncrementSeed - oCol.AutoIncrementStep;
      end;
    end;
    if FInvariants <> 0 then begin
      SetLength(FInvariantMap, Count);
      FInvariants := 0;
      for i := 0 to Count - 1 do begin
        oCol := ItemsI[i];
        if oCol.DataType in C_AD_InvariantDataTypes then begin
          FInvariantMap[i] := FInvariants;
          Inc(FInvariants);
        end;
      end;
    end;
    for i := 0 to Count - 1 do begin
      oCol := ItemsI[i];
      if oCol.Expression <> '' then begin
        if oParser = nil then
          ADCreateInterface(IADStanExpressionParser, oParser);
        oCol.FEvaluator := oParser.Prepare(TADDatSTableExpressionDS.Create(Table),
          oCol.Expression, [], [poDefaultExpr], oCol.Name);
      end;
    end;
    FFetchedOffset := ARowInstanceSize;
    FFetchedSize := (Count + 7) div 8;
    if FInvariants <> 0 then begin
      FInvariantOffset := FFetchedOffset + FFetchedSize;
      FInvariantSize := FInvariants * SizeOf(LongWord);
    end
    else begin
      FInvariantOffset := -1;
      FInvariantSize := 0;
    end;
    FRowsInstSize := ARowInstanceSize + FFetchedSize + FInvariantSize;
  except
    TerminateLayout;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.TerminateLayout;
var
  i: Integer;
  oCol: TADDatSColumn;
begin
  if Length(FDataOffsets) <> 0 then begin
    FParentRowRefCol := -1;
    FParentCol := -1;
    FFetchedOffset := 0;
    FFetchedSize := 0;
    FInvariantOffset := -1;
    FInvariantSize := 0;
    FInvariants := 0;
    FHasThings := [];
    SetLength(FDataOffsets, 0);
    SetLength(FNullOffsets, 0);
    SetLength(FNullMasks, 0);
    SetLength(FAutoIncs, 0);
    SetLength(FInvariantMap, 0);
    for i := 0 to Count - 1 do begin
      oCol := ItemsI[i];
      oCol.FIndex := -1;
      if oCol.Expression <> '' then
        oCol.FEvaluator := nil;
    end;
    FRowsInstSize := 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnList.GetStorageSize: LongWord;
begin
  Result := DataOffsets[Count] + LongWord((Count + 7) div 8);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.FixAutoIncs(ARow: TADDatSRow);
var
  i: Integer;
begin
  if ctAutoIncs in FHasThings then
    for i := 0 to Count - 1 do
      if ItemsI[i].AutoIncrement then
        if ItemsI[i].AutoIncrementStep > 0 then begin
          if FAutoIncs[i] < ARow.GetData(i) then
            FAutoIncs[i] := ARow.GetData(i);
        end
        else begin
          if FAutoIncs[i] > ARow.GetData(i) then
            FAutoIncs[i] := ARow.GetData(i);
        end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.InternalLoadFromStorage(AStorage: TADStorage);
begin
  Include(FHasThings, ctSerializing);
  try
    InlineDataSize := Word(AStorage.ReadInteger('InlineDataSize', C_AD_DefInlineDataSize));
    inherited InternalLoadFromStorage(AStorage);
  finally
    Exclude(FHasThings, ctSerializing);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnList.InternalSaveToStorage(AStorage: TADStorage);
begin
  Include(FHasThings, ctSerializing);
  try
    AStorage.WriteInteger('InlineDataSize', InlineDataSize, C_AD_DefInlineDataSize);
    inherited InternalSaveToStorage(AStorage);
  finally
    Exclude(FHasThings, ctSerializing);
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSColumnSublist                                                        -}
{-------------------------------------------------------------------------------}
procedure TADDatSColumnSublist.Clear;
begin
  SetLength(FArray, 0);
  FNames := '';
end;

{-------------------------------------------------------------------------------}
procedure TADDatSColumnSublist.Add(ACol: TADDatSColumn);
begin
  SetLength(FArray, Length(FArray) + 1);
  FArray[Length(FArray) - 1] := ACol;
end;

{-------------------------------------------------------------------------------}
// field[:[D][A][N]];
procedure TADDatSColumnSublist.Fill(AObject: TADDatSObject;
  const AFields: String; ACaseInsensitiveColumnList: TADDatSColumnSublist = nil;
  ADescendingColumnList: TADDatSColumnSublist = nil);
var
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  i, j, jFrom: Integer;
  lNoCase, lDesc, lInvalid: Boolean;
  sItem: String;
begin
  ASSERT((AObject <> nil) and (AObject.Table <> nil));
  Clear;
  oCols := AObject.Table.Columns;
  if AFields = '*' then begin
    SetLength(FArray, oCols.Count);
    for i := 0 to oCols.Count - 1 do begin
      FArray[i] := oCols.ItemsI[i];
      if FNames <> '' then
        FNames := FNames + ';';
      FNames := FNames + FArray[i].Name;
    end;
  end
  else begin
    i := 1;
    while i <= Length(AFields) do begin
      sItem := ADExtractFieldName(AFields, i);
      j := Pos(':', sItem);
      lNoCase := False;
      lDesc := False;
      lInvalid := j <= 1;
      if not lInvalid then begin
        jFrom := j;
        while j < Length(sItem) do begin
          Inc(j);
          case sItem[j] of
          'n', 'N': lNoCase := True;
          'd', 'D': lDesc := True;
          'a', 'A': lDesc := False;
          else      lInvalid := True; Break;
          end;
        end;
        if not lInvalid then
          sItem := Copy(sItem, 1, jFrom - 1);
      end;
      oCol := oCols.ColumnByName(sItem);
      Add(oCol);
      if lNoCase and (ACaseInsensitiveColumnList <> nil) then
        ACaseInsensitiveColumnList.Add(oCol);
      if lDesc and (ADescendingColumnList <> nil) then
        ADescendingColumnList.Add(oCol);
    end;
    FNames := AFields;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.GetCount: Integer;
begin
  Result := Length(FArray);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.GetItemsI(AIndex: Integer): TADDatSColumn;
begin
  ASSERT((AIndex >= 0) and (AIndex < Length(FArray)));
  Result := TADDatSColumn(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.HandleNotification(AParam: PADDatSNotifyParam): Boolean;
begin
  if (AParam^.FReason = srMetaChange) and (
       (AParam^.FKind = snObjectNameChanged) and (IndexOf(TADDatSColumn(AParam^.FParam1)) <> -1) or
// MSGOPT (AParam^.FKind = snObjectInserted) and (IndexOf(TADDatSColumn(AParam^.FParam2)) <> -1) or
       (AParam^.FKind = snObjectRemoved) and (IndexOf(TADDatSColumn(AParam^.FParam2)) <> -1)
     ) then
    Result := True
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.IndexOf(AColumn: TADDatSColumn): Integer;
begin
  ASSERT(AColumn <> nil);
  Result := ADIndexOf(FArray, -1, AColumn);
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.IndexOfName(const AName: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
       (FArray[i].Name, AName) = 0 then begin
      Result := i;
      Exit;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.FindColumn(const AName: String): TADDatSColumn;
var
  i: Integer;
begin
  i := IndexOfName(AName);
  if i <> -1 then
    Result := FArray[i]
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDatSColumnSublist.Matches(AList: TADDatSColumnSublist;
  ACount: Integer): Boolean;
var
  iCnt, i: Integer;
begin
  if AList = nil then
    iCnt := -1
  else if ACount = -1 then
    iCnt := AList.Count
  else if ACount = -2 then begin
    iCnt := AList.Count;
    if iCnt <> Count then begin
      Result := False;
      Exit;
    end;
  end
  else
    iCnt := ACount;
  if iCnt > Count then
    Result := False
  else begin
    Result := True;
    for i := 0 to iCnt - 1 do
      if FArray[i] <> AList.FArray[i] then begin
        Result := False;
        Break;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSConstraintBase                                                       -}
{-------------------------------------------------------------------------------}
constructor TADDatSConstraintBase.Create;
begin
  inherited Create;
  FEnforce := True;
  FRely := True;
  FLastActualEnforce := ActualEnforce;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSConstraintBase.Destroy;
begin
  Enforce := False;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSConstraintBase then begin
    Rely := TADDatSConstraintBase(AObj).Rely;
    Enforce := TADDatSConstraintBase(AObj).Enforce;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintBase.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then
    Result := (Rely = TADDatSConstraintBase(AObj).Rely);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.Check(ARow: TADDatSRow; AProposedState:
  TADDatSRowState; ATime: TADDatSCheckTime);
begin
  ASSERT(ARow <> nil);
  if ActualEnforce and (ATime = CheckTime) and CheckRow(ARow) then
    DoCheck(ARow, AProposedState);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintBase.CheckRow(ARow: TADDatSRow): Boolean;
begin
  // nothing
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.DoCheck(ARow: TADDatSRow;
  AProposedState: TADDatSRowState);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.CheckAll;
var
  oRows: TADDatSTableRowList;
  i: Integer;
begin
  oRows := Table.Rows;
  for i := 0 to oRows.Count - 1 do
    DoCheck(oRows[i], rsChecking);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.DoEnforceUpdated;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.EnforceUpdated;
begin
  if FLastActualEnforce <> ActualEnforce then begin
    FLastActualEnforce := ActualEnforce;
    try
      DoEnforceUpdated;
      if ActualEnforce and not Rely then
        CheckAll;
    except
      Enforce := False;
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.SetEnforce(const AValue: Boolean);
begin
  if FEnforce <> AValue then begin
    FEnforce := AValue;
    EnforceUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.DoListInserted;
begin
  EnforceUpdated;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.DoListRemoved(ANewOwner: TADDatSObject);
begin
  EnforceUpdated;
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintBase.GetActualEnforce: Boolean;
begin
  Result := Enforce and (ConstraintList <> nil);
  if Result then begin
    Result := ConstraintList.Enforce;
    if Result and (Manager <> nil) then
      Result := Manager.EnforceConstraints;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintBase.GetConstraintList: TADDatSConstraintList;
begin
  Result := List as TADDatSConstraintList;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.ResolveEnforce(const AName, AValue: String);
begin
  if SameText(AName, 'Enforce') and SameText(AValue, S_AD_True) then
    Enforce := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.InternalLoadFromStorage(AStorage: TADStorage);
var
  lEnforce: Boolean;
begin
  Enforce := False;
  inherited InternalLoadFromStorage(AStorage);
  lEnforce := AStorage.ReadBoolean('Enforce', True);
  if lEnforce then
    AStorage.DeferAction('Enforce', S_AD_True, ResolveEnforce);
  Rely := AStorage.ReadBoolean('Rely', True);
  CheckTime := TADDatSCheckTime(AStorage.ReadEnum('CheckTime',
    TypeInfo(TADDatSCheckTime), Integer(ctAtEditEnd)));
  Message := AStorage.ReadString('Message', '');
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintBase.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  AStorage.WriteBoolean('Enforce', Enforce, True);
  AStorage.WriteBoolean('Rely', Rely, True);
  AStorage.WriteEnum('CheckTime', TypeInfo(TADDatSCheckTime),
    Integer(CheckTime), Integer(ctAtEditEnd));
  AStorage.WriteString('Message', Message, '');
end;

{-------------------------------------------------------------------------------}
{- TADDatSConstraintList                                                       -}
{-------------------------------------------------------------------------------}
constructor TADDatSConstraintList.CreateForTable(ATable: TADDatSTable);
begin
  ASSERT(ATable <> nil);
  inherited Create;
  FOwner := ATable;
  OwnObjects := True;
  FEnforce := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.Assign(AObj: TADDatSObject);
begin
  Clear;
  if AObj is TADDatSConstraintList then
    Enforce := False;
  inherited Assign(AObj);
  if AObj is TADDatSConstraintList then
    Enforce := TADDatSConstraintList(AObj).Enforce;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.HandleNotification(AParam: PADDatSNotifyParam);
begin
  if AParam^.FReason = srDataChange then
    Exit;
  inherited HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.Add(AObj: TADDatSConstraintBase): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddUK(const AName: String; AColumn: TADDatSColumn;
  APrimaryKey: Boolean): TADDatSUniqueConstraint;
begin
  Result := AddUK(AName, [AColumn], APrimaryKey);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddUK(const AName: String;
  const AColumns: array of TADDatSColumn; APrimaryKey: Boolean): TADDatSUniqueConstraint;
begin
  Result := TADDatSUniqueConstraint.Create(AName, AColumns, APrimaryKey);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddUK(const AName, AColumnNames: String;
  APrimaryKey: Boolean): TADDatSUniqueConstraint;
begin
  Result := TADDatSUniqueConstraint.Create(AName, AColumnNames, APrimaryKey);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddFK(const AName: String;
  APrimaryKeyColumn, AForeignKeyColumn: TADDatSColumn): TADDatSForeignKeyConstraint;
begin
  Result := AddFK(AName, [APrimaryKeyColumn], [AForeignKeyColumn]);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddFK(const AName: String;
  const APrimaryKeyColumns, AForeignKeyColumns: array of TADDatSColumn): TADDatSForeignKeyConstraint;
begin
  Result := TADDatSForeignKeyConstraint.Create(AName, APrimaryKeyColumns,
    AForeignKeyColumns, crCascade, crRestrict);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddFK(const AName, AParentTableName, APrimaryKeyColumns,
  AForeignKeyColumns: String): TADDatSForeignKeyConstraint;
begin
  Result := TADDatSForeignKeyConstraint.Create(AName, AParentTableName,
    APrimaryKeyColumns, AForeignKeyColumns, crCascade, crRestrict);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddFK(const AName: String; AParentTable: TADDatSTable;
  const APrimaryKeyColumns, AForeignKeyColumns: String): TADDatSForeignKeyConstraint;
begin
  Result := TADDatSForeignKeyConstraint.Create(AName, AParentTable,
    APrimaryKeyColumns, AForeignKeyColumns, crCascade, crRestrict);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.AddChk(const AName, AExpression: String;
  const AMessage: String = ''; ACheckTime: TADDatSCheckTime = ctAtEditEnd): TADDatSCheckConstraint;
begin
  Result := TADDatSCheckConstraint.Create(AName, AExpression, AMessage, ACheckTime);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.Check(ARow: TADDatSRow; AProposedState:
  TADDatSRowState; ATime: TADDatSCheckTime);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].Check(ARow, AProposedState, ATime);
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.ConstraintByName(const AName: String):
  TADDatSConstraintBase;
begin
  Result := TADDatSConstraintBase(inherited ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.EnforceUpdated;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].EnforceUpdated;
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.GetItemsI(AIndex: Integer): TADDatSConstraintBase;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSConstraintBase(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.SetEnforce(const AValue: Boolean);
begin
  if FEnforce <> AValue then begin
    FEnforce := AValue;
    EnforceUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.FindUnique(
  const AFields: String): TADDatSUniqueConstraint;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if ItemsI[i] is TADDatSUniqueConstraint then
      if {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
         (AFields, TADDatSUniqueConstraint(ItemsI[i]).ColumnNames) = 0 then begin
        Result := TADDatSUniqueConstraint(ItemsI[i]);
        Break;
      end;
end;

{-------------------------------------------------------------------------------}
function TADDatSConstraintList.FindPrimaryKey: TADDatSUniqueConstraint;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if ItemsI[i] is TADDatSUniqueConstraint then
      if TADDatSUniqueConstraint(ItemsI[i]).IsPrimaryKey then begin
        Result := TADDatSUniqueConstraint(ItemsI[i]);
        Break;
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.CheckAll;
var
  i: Integer;
  oCons: TADDatSConstraintBase;
begin
  for i := 0 to Count - 1 do begin
    oCons := ItemsI[i];
    if oCons.ActualEnforce and not oCons.Rely then
      try
        oCons.CheckAll;
      except
        oCons.Enforce := False;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.ResolveEnforce(const AName, AValue: String);
begin
  if SameText(AName, 'Enforce') and SameText(AValue, S_AD_True) then
    Enforce := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.InternalLoadFromStorage(AStorage: TADStorage);
var
  lEnforce: Boolean;
begin
  Enforce := False;
  lEnforce := AStorage.ReadBoolean('Enforce', True);
  if lEnforce then
    AStorage.DeferAction('Enforce', S_AD_True, ResolveEnforce);
  inherited InternalLoadFromStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSConstraintList.InternalSaveToStorage(AStorage: TADStorage);
begin
  AStorage.WriteBoolean('Enforce', Enforce, True);
  inherited InternalSaveToStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
{- TADDatSUniqueConstraint                                                     -}
{-------------------------------------------------------------------------------}
constructor TADDatSUniqueConstraint.Create;
begin
  inherited Create;
  FColumns := TADDatSColumnSublist.Create;
  FOptions := [soUnique];
end;

{-------------------------------------------------------------------------------}
constructor TADDatSUniqueConstraint.Create(AColumn: TADDatSColumn;
  APrimaryKey: Boolean);
begin
  Create('', [AColumn], APrimaryKey);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSUniqueConstraint.Create(
  const AColumns: array of TADDatSColumn; APrimaryKey: Boolean);
begin
  Create('', AColumns, APrimaryKey);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSUniqueConstraint.Create(const AName: String;
  AColumn: TADDatSColumn; APrimaryKey: Boolean);
begin
  Create(AName, [AColumn], APrimaryKey);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSUniqueConstraint.Create(const AName: String;
  const AColumns: array of TADDatSColumn; APrimaryKey: Boolean);
var
  s: String;
  i: Integer;
begin
  ASSERT(AColumns[Low(AColumns)] <> nil);
  s := AColumns[Low(AColumns)].Name;
  for i := Low(AColumns) + 1 to High(AColumns) do begin
    ASSERT(AColumns[i] <> nil);
    s := s + ';' + AColumns[i].Name;
  end;
  Create(AName, s, APrimaryKey);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSUniqueConstraint.Create(const AName,
  AColumnNames: String; APrimaryKey: Boolean);
begin
  Create;
  if AName <> '' then
    Name := AName;
  ColumnNames := AColumnNames;
  if APrimaryKey then
    Options := Options + [soPrimary];
  Enforce := True;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSUniqueConstraint.Destroy;
begin
  Enforce := False;
  ADFreeAndNil(FColumns);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSUniqueConstraint then begin
    ColumnNames := TADDatSUniqueConstraint(AObj).ColumnNames;
    Options := TADDatSUniqueConstraint(AObj).Options;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUniqueConstraint.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := (ColumnNames = TADDatSUniqueConstraint(AObj).ColumnNames) and
              (Options = TADDatSUniqueConstraint(AObj).Options);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUniqueConstraint.GetUniqueSortedView: TADDatSView;
begin
  Result := Table.Views.FindSortedView(ColumnNames, Options -
    [soNullFirst, soDescending], []);
  if Result = nil then begin
    Result := TADDatSView.Create(Table, C_AD_SysNamePrefix + 'UC_' + Name,
      vcUniqueConstraint, False);
    try
      Result.Mechanisms.AddSort(ColumnNames, '', '', Options);
      Result.Active := True;
    except
      ADFree(Result);
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.DoCheck(ARow: TADDatSRow; AProposedState: TADDatSRowState);
  procedure ErrorViolated;
  begin
    if Message <> '' then
      ADException(Self, [S_AD_LDatS], er_AD_DuplicateRows, [Message, 0])
    else
      ADException(Self, [S_AD_LDatS], er_AD_DuplicateRows, [Name, 1]);
  end;
var
  oView: TADDatSView;
  iPos: Integer;
  lFound: Boolean;
  eOpts: TADLocateOptions;
begin
  if AProposedState in [rsInserted, rsModified] then begin
    oView := GetUniqueSortedView;
    eOpts := [loExcludeKeyRow];
    if soNoCase in Options then
      Include(eOpts, loNoCase);
    lFound := False;
    iPos := -1;
    oView.Search(ARow, nil, nil, -1, eOpts, iPos, lFound);
    if lFound then
      ErrorViolated;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.DoEnforceUpdated;
  procedure InvalidUniqueKey;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_BadUniqueKey, [Name]);
  end;
var
  i: Integer;
  oCol: TADDatSColumn;
begin
  if not ActualEnforce then begin
    if soPrimary in Options then
      for i := 0 to FColumns.Count - 1 do begin
        oCol := FColumns[i];
        if not (caAutoInc in oCol.FAttributes) then
          Include(oCol.FAttributes, caAllowNull);
        Exclude(oCol.FOptions, coInKey);
      end;
    FColumns.Clear;
  end
  else begin
    FColumns.Fill(Self, FColumnNames);
    if FColumns.Count = 0 then
      InvalidUniqueKey;
    if soPrimary in Options then
      for i := 0 to FColumns.Count - 1 do begin
        oCol := FColumns[i];
        if not (caAutoInc in oCol.FAttributes) then
          Exclude(oCol.FAttributes, caAllowNull);
        Include(oCol.FOptions, coInKey);
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUniqueConstraint.GetColumnCount: Integer;
begin
  Result := FColumns.Count;
end;

{-------------------------------------------------------------------------------}
function TADDatSUniqueConstraint.GetColumns(AIndex: Integer):
  TADDatSColumn;
begin
  Result := FColumns.ItemsI[AIndex];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.HandleNotification(AParam: PADDatSNotifyParam);
begin
  if (FColumns <> nil) and FColumns.HandleNotification(AParam) then
    Enforce := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.SetColumnNames(const AValue: String);
begin
  if FColumnNames <> AValue then begin
    FColumnNames := AValue;
    Enforce := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.SetOptions(const AValue: TADSortOptions);
begin
  if FOptions <> AValue then begin
    FOptions := AValue;
    Enforce := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUniqueConstraint.GetIsPrimaryKey: Boolean;
begin
  Result := soPrimary in Options;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.SetIsPrimaryKey(const AValue: Boolean);
begin
  if AValue then
    Options := Options + [soPrimary]
  else
    Options := Options - [soPrimary];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.InternalLoadFromStorage(AStorage: TADStorage);
var
  eOpt: TADSortOption;
  eOpts: TADSortOptions;
begin
  inherited InternalLoadFromStorage(AStorage);
  ColumnNames := AStorage.ReadString('ColumnNames', '');
  eOpts := [];
  for eOpt := Low(TADSortOption) to High(TADSortOption) do
    if AStorage.ReadBoolean(Copy(GetEnumName(TypeInfo(TADSortOption),
                            Integer(eOpt)), 3, MAXINT), False) then
      Include(eOpts, eOpt);
  Options := eOpts;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUniqueConstraint.InternalSaveToStorage(AStorage: TADStorage);
var
  eOpt: TADSortOption;
begin
  inherited InternalSaveToStorage(AStorage);
  AStorage.WriteString('ColumnNames', ColumnNames, '');
  for eOpt := Low(TADSortOption) to High(TADSortOption) do
    if eOpt in Options then
      AStorage.WriteBoolean(Copy(GetEnumName(TypeInfo(TADSortOption),
        Integer(eOpt)), 3, MAXINT), True, False);
end;

{-------------------------------------------------------------------------------}
{- TADDatSForeignKeyConstraint                                                 -}
{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create;
begin
  inherited Create;
  FDeleteRule := crCascade;
  FUpdateRule := crCascade;
  FInsertRule := crCascade;
  FAcceptRejectRule := arCascade;
  FColumns := TADDatSColumnSublist.Create;
  FRelatedColumns := TADDatSColumnSublist.Create;
  FCascadingRows := TADObjList.Create;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create(const AName: String;
  AParentColumn, AChildColumn: TADDatSColumn; ADeleteRule,
  AUpdateRule: TADDatSConstraintRule);
begin
  Create(AName, [AParentColumn], [AChildColumn], ADeleteRule, AUpdateRule);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create(AParentColumn,
  AChildColumn: TADDatSColumn; ADeleteRule,
  AUpdateRule: TADDatSConstraintRule);
begin
  Create('', [AParentColumn], [AChildColumn], ADeleteRule, AUpdateRule);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create(const AParentColumns,
  AChildColumns: array of TADDatSColumn; ADeleteRule,
  AUpdateRule: TADDatSConstraintRule);
begin
  Create('', AParentColumns, AChildColumns, ADeleteRule, AUpdateRule);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create(const AName: String;
  const AParentColumns, AChildColumns: array of TADDatSColumn; ADeleteRule,
  AUpdateRule: TADDatSConstraintRule);
var
  s: String;
  i: Integer;
begin
  Create;
  if AName <> '' then
    Name := AName;
  ASSERT(AParentColumns[Low(AParentColumns)] <> nil);
  RelatedTableName := AParentColumns[Low(AParentColumns)].Table.Name;
  s := AParentColumns[Low(AParentColumns)].Name;
  for i := Low(AParentColumns) + 1 to High(AParentColumns) do begin
    ASSERT(AParentColumns[i] <> nil);
    s := s + ';' + AParentColumns[i].Name;
  end;
  RelatedColumnNames := s;
  ASSERT(AChildColumns[Low(AChildColumns)] <> nil);
  s := AChildColumns[Low(AChildColumns)].Name;
  for i := Low(AChildColumns) + 1 to High(AChildColumns) do begin
    ASSERT(AChildColumns[i] <> nil);
    s := s + ';' + AChildColumns[i].Name;
  end;
  ColumnNames := s;
  DeleteRule := ADeleteRule;
  UpdateRule := AUpdateRule;
  Enforce := True;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create(const AName,
  AParentTableName, AParentColumnNames, AChildColumnNames: String;
  ADeleteRule, AUpdateRule: TADDatSConstraintRule);
begin
  Create;
  if AName <> '' then
    Name := AName;
  RelatedTableName := AParentTableName;
  RelatedColumnNames := AParentColumnNames;
  ColumnNames := AChildColumnNames;
  DeleteRule := ADeleteRule;
  UpdateRule := AUpdateRule;
  Enforce := True;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSForeignKeyConstraint.Create(const AName: String;
  AParentTable: TADDatSTable; const AParentColumnNames, AChildColumnNames: String;
  ADeleteRule, AUpdateRule: TADDatSConstraintRule);
begin
  Create;
  if AName <> '' then
    Name := AName;
  RelatedTableName := AParentTable.Name;
  RelatedColumnNames := AParentColumnNames;
  ColumnNames := AChildColumnNames;
  DeleteRule := ADeleteRule;
  UpdateRule := AUpdateRule;
  Enforce := True;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSForeignKeyConstraint.Destroy;
begin
  Enforce := False;
  ADFreeAndNil(FColumns);
  ADFreeAndNil(FRelatedColumns);
  ADFreeAndNil(FCascadingRows);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSForeignKeyConstraint then begin
    ColumnNames := TADDatSForeignKeyConstraint(AObj).ColumnNames;
    RelatedColumnNames := TADDatSForeignKeyConstraint(AObj).RelatedColumnNames;
    RelatedTableName := TADDatSForeignKeyConstraint(AObj).RelatedTableName;
    DeleteRule := TADDatSForeignKeyConstraint(AObj).DeleteRule;
    UpdateRule := TADDatSForeignKeyConstraint(AObj).UpdateRule;
    ParentMessage := TADDatSForeignKeyConstraint(AObj).ParentMessage;
    AcceptRejectRule := TADDatSForeignKeyConstraint(AObj).AcceptRejectRule;
    FieldValueRequired := TADDatSForeignKeyConstraint(AObj).FieldValueRequired;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.IsEqualTo(AObj: TADDatSObject):
  Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then
    Result := (ColumnNames = TADDatSForeignKeyConstraint(AObj).ColumnNames) and
              (RelatedColumnNames = TADDatSForeignKeyConstraint(AObj).RelatedColumnNames) and
              (RelatedTableName = TADDatSForeignKeyConstraint(AObj).RelatedTableName) and
              (DeleteRule = TADDatSForeignKeyConstraint(AObj).DeleteRule) and
              (UpdateRule = TADDatSForeignKeyConstraint(AObj).UpdateRule) and
              (ParentMessage = TADDatSForeignKeyConstraint(AObj).ParentMessage) and
              (AcceptRejectRule = TADDatSForeignKeyConstraint(AObj).AcceptRejectRule) and
              (FieldValueRequired = TADDatSForeignKeyConstraint(AObj).FieldValueRequired);
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.GetChildSortedView: TADDatSView;
begin
  Result := Table.Views.FindSortedView(ColumnNames, [], [soNoCase]);
  if Result = nil then begin
    Result := TADDatSView.Create(Table, C_AD_SysNamePrefix + 'FKC_' + Name,
      vcForeignKeyConstraint, False);
    try
      Result.Mechanisms.AddSort(ColumnNames);
      Result.Active := True;
    except
      ADFree(Result);
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.GetMasterSortedView: TADDatSView;
begin
  Result := RelatedTable.Views.FindSortedView(RelatedColumnNames, [], [soNoCase]);
  if Result = nil then begin
    Result := TADDatSView.Create(RelatedTable, C_AD_SysNamePrefix + 'FKM_' + Name,
      vcForeignKeyConstraint, False);
    try
      Result.Mechanisms.AddSort(RelatedColumnNames);
      Result.Active := True;
    except
      ADFree(Result);
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.CheckRow(ARow: TADDatSRow): Boolean;
begin
  Result := (FCascadingRows.IndexOf(ARow) = -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.DoCheck(ARow: TADDatSRow;
  AProposedState: TADDatSRowState);
var
  oMasterView, oChildView: TADDatSView;
  iPos: Integer;
  lFound: Boolean;
  oRowList: TADObjList;

  procedure SelectChildRows;
  var
    oRow: TADDatSRow;
  begin
    oRowList := TADObjList.Create;
    repeat
      oRow := oChildView.Rows.ItemsI[iPos];
      if oRow.RowState = rsChecking then
        ADException(Self, [S_AD_LDatS], er_AD_FoundCascadeLoop, [Name]);
      oRowList.Add(oRow);
      Inc(iPos);
    until (iPos >= oChildView.Rows.Count) or
          (ARow.CompareRows(FRelatedColumns, nil, nil, -1, oChildView.Rows.ItemsI[iPos],
                            FColumns, rvPrevious, [], ADEmptyCC) <> 0);
  end;

  procedure DeleteChildRows;
  var
    i: Integer;
    oCurRow: TADDatSRow;
  begin
    for i := 0 to oRowList.Count - 1 do begin
      oCurRow := TADDatSRow(oRowList[i]);
      if not (oCurRow.RowState in [rsDeleted, rsDetached, rsInitializing]) then begin
        FCascadingRows.Add(oCurRow);
        try
          oCurRow.Delete;
        finally
          FCascadingRows.Remove(oCurRow);
        end;
      end;
    end;
  end;

  procedure NullifyChildRows;
  var
    i, j: Integer;
    oCurRow: TADDatSRow;
    lNeedEndEdit: Boolean;
    pBuff: Pointer;
    iLen: LongWord;
  begin
    iLen := 0;
    pBuff := nil;
    for i := 0 to oRowList.Count - 1 do begin
      oCurRow := TADDatSRow(oRowList[i]);
      if not (oCurRow.RowState in [rsDeleted, rsDetached, rsInitializing]) then begin
        FCascadingRows.Add(oCurRow);
        try
          lNeedEndEdit := False;
          try
            for j := 0 to FColumns.Count - 1 do begin
              if oCurRow.GetData(FColumns.ItemsI[j].Index, rvDefault, pBuff, 0, iLen, False) then begin
                if oCurRow.RowState <> rsEditing then begin
                  oCurRow.BeginEdit;
                  lNeedEndEdit := True;
                end;
                oCurRow.SetData(FColumns.ItemsI[j].Index, nil, 0);
              end;
            end;
            if lNeedEndEdit then
              oCurRow.EndEdit;
          except
            if lNeedEndEdit then
              oCurRow.CancelEdit;
            raise;
          end;
        finally
          FCascadingRows.Remove(oCurRow);
        end;
      end;
    end;
  end;

  procedure UpdateChildRows;
  var
    i, j: Integer;
    iLen: LongWord;
    pData: Pointer;
    oCurRow: TADDatSRow;
    lNeedEndEdit: Boolean;
  begin
    iLen := 0;
    pData := nil;
    for i := 0 to oRowList.Count - 1 do begin
      oCurRow := TADDatSRow(oRowList[i]);
      if not (oCurRow.RowState in [rsDeleted, rsDetached, rsInitializing]) then begin
        FCascadingRows.Add(oCurRow);
        try
          lNeedEndEdit := False;
          try
            if ARow.CompareRows(FRelatedColumns, nil, nil, -1, oCurRow,
                                FColumns, rvDefault, [], ADEmptyCC) <> 0 then
              for j := 0 to FColumns.Count - 1 do begin
                if oCurRow.RowState <> rsEditing then begin
                  oCurRow.BeginEdit;
                  lNeedEndEdit := True;
                end;
                ARow.GetData(FRelatedColumns.ItemsI[j].Index, rvDefault, pData, 0, iLen, False);
                oCurRow.SetData(FColumns.ItemsI[j].Index, pData, iLen);
              end;
            if lNeedEndEdit then
              oCurRow.EndEdit;
          except
            if lNeedEndEdit then
              oCurRow.CancelEdit;
            raise;
          end;
        finally
          FCascadingRows.Remove(oCurRow);
        end;
      end;
    end;
  end;

  procedure AcceptChildRows(AAccept: Boolean);
  var
    i: Integer;
    oCurRow: TADDatSRow;
  begin
    for i := 0 to oRowList.Count - 1 do begin
      oCurRow := TADDatSRow(oRowList[i]);
      if AAccept then
        oCurRow.AcceptChanges
      else
        oCurRow.RejectChanges;
    end;
  end;

  function CheckNotNull(AColumns: TADDatSColumnSublist): Boolean;
  var
    i: Integer;
    pBuff: Pointer;
    iLen: LongWord;
  begin
    Result := True;
    if FFieldValueRequired then begin
      iLen := 0;
      pBuff := nil;
      for i := 0 to AColumns.Count - 1 do
        if not ARow.GetData(AColumns.ItemsI[i].Index, rvDefault, pBuff, 0, iLen, False) then begin
          Result := False;
          Break;
        end;
    end;
  end;

  procedure ErrorHasChildRows;
  begin
    if ParentMessage <> '' then
      ADException(Self, [S_AD_LDatS], er_AD_HasChildRows, [ParentMessage, 0])
    else
      ADException(Self, [S_AD_LDatS], er_AD_HasChildRows, [Name, 1]);
  end;

  procedure ErrorNoMasterRow;
  begin
    if Message <> '' then
      ADException(Self, [S_AD_LDatS], er_AD_NoMasterRow, [Message, 0])
    else
      ADException(Self, [S_AD_LDatS], er_AD_NoMasterRow, [Name, 1]);
  end;

begin
  if RelatedTable = nil then
    Exit;
  oRowList := nil;
  iPos := -1;
  lFound := False;
  try
    // --- master table
    if ARow.Table = RelatedTable then begin
      oChildView := GetChildSortedView;
      case AProposedState of
      rsInitializing,
      rsDetached,
      rsDeleted:
        case DeleteRule of
        crRestrict:
          if CheckNotNull(FRelatedColumns) then begin
            oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvDefault);
            if lFound then
              ErrorHasChildRows;
          end;
        crCascade:
          begin
            oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvPrevious);
            if lFound then begin
              SelectChildRows;
              DeleteChildRows;
            end;
          end;
        crNullify:
          begin
            oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvPrevious);
            if lFound then begin
              SelectChildRows;
              NullifyChildRows;
            end;
          end;
        end;
      rsModified:
        case UpdateRule of
        crRestrict:
          if CheckNotNull(FRelatedColumns) then begin
            oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvPrevious);
            if lFound and not ARow.CompareColumnsVersions(FRelatedColumns, rvPrevious, rvDefault) then
              ErrorHasChildRows;
          end;
        crCascade:
          begin
            oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvPrevious);
            if lFound then begin
              SelectChildRows;
              UpdateChildRows;
            end;
          end;
        crNullify:
          begin
            oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvPrevious);
            if lFound then begin
              SelectChildRows;
              NullifyChildRows;
            end;
          end;
        end;
      rsUnchanged,
      rsDestroying:
        if AcceptRejectRule = arCascade then begin
          oChildView.Search(ARow, nil, FRelatedColumns, -1, [], iPos, lFound, rvDefault);
          if lFound then begin
            SelectChildRows;
            AcceptChildRows(AProposedState = rsUnchanged);
          end;
        end;
      end;
    end
    // --- child table
    else if ARow.Table = Table then begin
      if (AProposedState in [rsInserted, rsModified]) and CheckNotNull(FColumns) then begin
        oMasterView := GetMasterSortedView;
        oMasterView.Search(ARow, nil, FColumns, -1, [], iPos, lFound);
        if not lFound then
          ErrorNoMasterRow;
      end;
    end;
  finally
    ADFreeAndNil(oRowList);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.DoInsertAssignParentValues(AParentRow,
  AChildRow: TADDatSRow);
var
  i: Integer;
  iLen: LongWord;
  pData: Pointer;
begin
  iLen := 0;
  pData := nil;
  for i := 0 to FColumns.Count - 1 do begin
    AParentRow.GetData(FRelatedColumns.ItemsI[i].Index, rvDefault, pData, 0, iLen, False);
    AChildRow.SetData(FColumns.ItemsI[i].Index, pData, iLen);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.DoEnforceUpdated;
  procedure InvalidForeignKey;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_BadForeignKey, [Name]);
  end;
var
  i: Integer;
begin
  if not ActualEnforce then begin
    FColumns.Clear;
    FRelatedColumns.Clear;
    FRelatedTable := nil;
  end
  else begin
    if (FRelatedTableName <> '') and (Manager <> nil) then
      FRelatedTable := Manager.Tables.TableByName(FRelatedTableName);
    FColumns.Fill(Self, FColumnNames);
    if FRelatedTable <> nil then
      FRelatedColumns.Fill(FRelatedTable, FRelatedColumnNames);
    if (FRelatedTable = nil) or (FRelatedTable.Manager <> Manager) or
       (FColumns.Count = 0) or (FColumns.Count <> FRelatedColumns.Count) or
       FColumns.Matches(FRelatedColumns) then
      InvalidForeignKey;
    for i := 0 to FColumns.Count - 1 do
      if FColumns[i].DataType <> FRelatedColumns[i].DataType then
        InvalidForeignKey;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.GetColumnCount: Integer;
begin
  Result := FColumns.Count;
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.GetColumns(AIndex: Integer): TADDatSColumn;
begin
  Result := FColumns.ItemsI[AIndex];
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.GetRelatedColumnCount: Integer;
begin
  Result := FRelatedColumns.Count;
end;

{-------------------------------------------------------------------------------}
function TADDatSForeignKeyConstraint.GetRelatedColumns(AIndex: Integer): TADDatSColumn;
begin
  Result := FRelatedColumns.ItemsI[AIndex];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.HandleNotification(AParam: PADDatSNotifyParam);
begin
  if (FColumns <> nil) and FColumns.HandleNotification(AParam) or
     (FRelatedColumns <> nil) and FRelatedColumns.HandleNotification(AParam) then
    Enforce := False
  else
    if (AParam^.FKind = snObjectRemoved) and (AParam^.FParam2 = TADNativeInt(RelatedTable)) then
      Enforce := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.SetColumnNames(const AValue: String);
begin
  if FColumnNames <> AValue then begin
    FColumnNames := AValue;
    Enforce := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.SetRelatedColumnNames(const AValue: String);
begin
  if FRelatedColumnNames <> AValue then begin
    FRelatedColumnNames := AValue;
    Enforce := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.SetRelatedTableName(const AValue: String);
begin
  if FRelatedTableName <> AValue then begin
    FRelatedTableName := AValue;
    Enforce := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.InternalLoadFromStorage(AStorage: TADStorage);
begin
  inherited InternalLoadFromStorage(AStorage);
  ColumnNames := AStorage.ReadString('ColumnNames', '');
  RelatedColumnNames := AStorage.ReadString('RelatedColumnNames', '');
  RelatedTableName := AStorage.ReadString('RelatedTableName', '');
  DeleteRule := TADDatSConstraintRule(AStorage.ReadEnum('DeleteRule',
    TypeInfo(TADDatSConstraintRule), Integer(crCascade)));
  InsertRule := TADDatSConstraintRule(AStorage.ReadEnum('InsertRule',
    TypeInfo(TADDatSConstraintRule), Integer(crCascade)));
  UpdateRule := TADDatSConstraintRule(AStorage.ReadEnum('UpdateRule',
    TypeInfo(TADDatSConstraintRule), Integer(crCascade)));
  AcceptRejectRule := TADDatSConstraintARRule(AStorage.ReadEnum('AcceptRejectRule',
    TypeInfo(TADDatSConstraintARRule), Integer(arCascade)));
  FieldValueRequired := AStorage.ReadBoolean('FieldValueRequired', False);
  ParentMessage := AStorage.ReadString('ParentMessage', '');
end;

{-------------------------------------------------------------------------------}
procedure TADDatSForeignKeyConstraint.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  AStorage.WriteString('ColumnNames', ColumnNames, '');
  AStorage.WriteString('RelatedColumnNames', RelatedColumnNames, '');
  AStorage.WriteString('RelatedTableName', RelatedTableName, '');
  AStorage.WriteEnum('DeleteRule', TypeInfo(TADDatSConstraintRule),
    Integer(DeleteRule), Integer(crCascade));
  AStorage.WriteEnum('InsertRule', TypeInfo(TADDatSConstraintRule),
    Integer(InsertRule), Integer(crCascade));
  AStorage.WriteEnum('UpdateRule', TypeInfo(TADDatSConstraintRule),
    Integer(UpdateRule), Integer(crCascade));
  AStorage.WriteEnum('AcceptRejectRule', TypeInfo(TADDatSConstraintARRule),
    Integer(AcceptRejectRule), Integer(arCascade));
  AStorage.WriteBoolean('FieldValueRequired', FieldValueRequired, False);
  AStorage.WriteString('ParentMessage', ParentMessage, '');
end;

{-------------------------------------------------------------------------------}
{- TADDatSCheckConstraint                                                      -}
{-------------------------------------------------------------------------------}
constructor TADDatSCheckConstraint.Create(const AExpression: string);
begin
  Create('', AExpression);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSCheckConstraint.Create(const AName, AExpression: string;
  const AMessage: String = ''; ACheckTime: TADDatSCheckTime = ctAtEditEnd);
begin
  Create;
  if AName <> '' then
    Name := AName;
  Expression := AExpression;
  Message := AMessage;
  CheckTime := ACheckTime;
  Enforce := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSCheckConstraint.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSCheckConstraint then
    Expression := TADDatSCheckConstraint(AObj).Expression;
end;

{-------------------------------------------------------------------------------}
function TADDatSCheckConstraint.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then
    Result := (Expression = TADDatSCheckConstraint(AObj).Expression);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSCheckConstraint.DoCheck(ARow: TADDatSRow; AProposedState: TADDatSRowState);
  procedure ErrorCheckViolated;
  begin
    if Message <> '' then
      ADException(Self, [S_AD_LDatS], er_AD_CheckViolated, [Message, 0])
    else if IsDefaultName then
      ADException(Self, [S_AD_LDatS], er_AD_CheckViolated, [Expression, 1])
    else
      ADException(Self, [S_AD_LDatS], er_AD_CheckViolated, [Name, 1]);
  end;
begin
  if (AProposedState in [rsInserted, rsModified]) and (CheckTime = ctAtEditEnd) or
     (AProposedState in [rsEditing, rsImportingCurent, rsImportingOriginal,
      rsImportingProposed]) and (CheckTime = ctAtColumnChange) then begin
    FEvaluator.DataSource.Position := ARow;
    try
      if not FEvaluator.Evaluate then
        ErrorCheckViolated;
    finally
      FEvaluator.DataSource.Position := nil;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSCheckConstraint.DoEnforceUpdated;
var
  oParser: IADStanExpressionParser;
begin
  if ActualEnforce then begin
    ADCreateInterface(IADStanExpressionParser, oParser);
    FEvaluator := oParser.Prepare(TADDatSTableExpressionDS.Create(Table),
      Expression, [],  [poCheck], '');
  end
  else
    FEvaluator := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSCheckConstraint.HandleNotification(AParam: PADDatSNotifyParam);
begin
  if (FEvaluator <> nil) and
     FEvaluator.HandleNotification(Word(AParam^.FKind), Word(AParam^.FReason),
                                   AParam^.FParam1, AParam^.FParam2) then
    Enforce := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSCheckConstraint.SetExpression(const AValue: String);
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    Enforce := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSCheckConstraint.InternalLoadFromStorage(AStorage: TADStorage);
begin
  inherited InternalLoadFromStorage(AStorage);
  Expression := AStorage.ReadString('Expression', '');
end;

{-------------------------------------------------------------------------------}
procedure TADDatSCheckConstraint.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  AStorage.WriteString('Expression', Expression, '');
end;

{-------------------------------------------------------------------------------}
{- TADDatSRelation                                                             -}
{-------------------------------------------------------------------------------}
constructor TADDatSRelation.Create;
begin
  inherited Create;
  FChildColumns := TADDatSColumnSublist.Create;
  FParentColumns := TADDatSColumnSublist.Create;
  FRefs := TADRefCounter.Create(Self);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSRelation.Create(const ARelName: String;
  AParentColumn, AChildColumn: TADDatSColumn; ANested: Boolean;
  ACreateConstraints: Boolean);
begin
  Create(ARelName, [AParentColumn], [AChildColumn], ANested, ACreateConstraints);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSRelation.Create(const ARelName: String;
  const AParentColumns, AChildColumns: array of TADDatSColumn; ANested: Boolean;
  ACreateConstraints: Boolean);
var
  sPar, sChild: String;
  i: Integer;
begin
  ASSERT(AParentColumns[Low(AParentColumns)] <> nil);
  sPar := AParentColumns[Low(AParentColumns)].Name;
  for i := Low(AParentColumns) + 1 to High(AParentColumns) do begin
    ASSERT(AParentColumns[i] <> nil);
    sPar := sPar + ';' + AParentColumns[i].Name;
  end;
  ASSERT(AChildColumns[Low(AChildColumns)] <> nil);
  sChild := AChildColumns[Low(AChildColumns)].Name;
  for i := Low(AChildColumns) + 1 to High(AChildColumns) do begin
    ASSERT(AChildColumns[i] <> nil);
    sChild := sChild + ';' + AChildColumns[i].Name;
  end;
  Create(ARelName, sPar, sChild,
    AParentColumns[Low(AParentColumns)].Table,
    AChildColumns[Low(AChildColumns)].Table,
    ANested, ACreateConstraints);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSRelation.Create(const ARelName: String; const AParentColumnNames,
  AChildColumnNames: String; AParentTable, AChildTable: TADDatSTable;
  ANested: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF};
  ACreateConstraints: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF});
begin
  Create;
  if ARelName <> '' then
    Name := ARelName;
  ParentTable := AParentTable;
  ParentColumnNames := AParentColumnNames;
  ChildTable := AChildTable;
  ChildColumnNames := AChildColumnNames;
  Nested := ANested;
  if ACreateConstraints then begin
    FOwnConstraints := True;
    FParentKeyConstraint := BuildParentKeyConstraint;
    FChildKeyConstraint := BuildChildKeyConstraint;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.BuildChildKeyConstraint: TADDatSForeignKeyConstraint;
begin
  ASSERT((ChildColumnNames <> '') and (ParentColumnNames <> '') and
    (ParentTable <> nil) and (ChildTable <> nil));
  Result := ChildTable.Constraints.AddFK('', ParentTable, ParentColumnNames,
    ChildColumnNames);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.BuildParentKeyConstraint: TADDatSUniqueConstraint;
begin
  ASSERT((ParentColumnNames <> '') and (ParentTable <> nil));
  Result := ParentTable.Constraints.AddUK('', ParentColumnNames, True);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSRelation.Create(const ARelName: String;
  APK: TADDatSUniqueConstraint; AFK: TADDatSForeignKeyConstraint);
begin
  Create;
  if ARelName <> '' then
    Name := ARelName;
  ParentKeyConstraint := APK;
  ChildKeyConstraint := AFK;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSRelation.Destroy;
begin
  ADFreeAndNil(FParentColumns);
  FParentTable := nil;
  if FOwnConstraints then
    ADFree(FParentKeyConstraint);
  FParentKeyConstraint := nil;
  ADFreeAndNil(FChildColumns);
  FChildTable := nil;
  if FOwnConstraints then
    ADFree(FChildKeyConstraint);
  FChildKeyConstraint := nil;
  ADFreeAndNil(FRefs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.Assign(AObj: TADDatSObject);
var
  srcManager: TADDatSManager;
  destManager: TADDatSManager;
begin
  inherited Assign(AObj);
  if AObj is TADDatSRelation then begin
    ChildColumnNames := TADDatSRelation(AObj).ChildColumnNames;
    ParentColumnNames := TADDatSRelation(AObj).ParentColumnNames;
    Nested := TADDatSRelation(AObj).Nested;
    srcManager := TADDatSRelation(AObj).Manager;
    destManager := Manager;
    if srcManager = destManager then begin
      ChildTable := TADDatSRelation(AObj).ChildTable;
      ChildKeyConstraint := TADDatSRelation(AObj).ChildKeyConstraint;
      ParentTable := TADDatSRelation(AObj).ParentTable;
      ParentKeyConstraint := TADDatSRelation(AObj).ParentKeyConstraint;
    end
    else if destManager <> nil then begin
      { TODO -cDATS : destManager most probably here is NIL }
      ChildTable := destManager.Tables.TableByName(TADDatSRelation(AObj).ChildTable.Name);
      ChildKeyConstraint := ChildTable.Constraints.ConstraintByName(
        TADDatSRelation(AObj).ChildKeyConstraint.Name) as TADDatSForeignKeyConstraint;
      ParentTable := destManager.Tables.TableByName(TADDatSRelation(AObj).ParentTable.Name);
      ParentKeyConstraint := ChildTable.Constraints.ConstraintByName(
        TADDatSRelation(AObj).ParentKeyConstraint.Name) as TADDatSUniqueConstraint;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.Check;
  procedure ErrorBadRelation;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_BadRelation, [Name]);
  end;
var
  i: Integer;
begin
  if Nested then begin
    if (FChildTable <> nil) and (FChildTable = FParentTable) then
      ErrorBadRelation;
    if (FChildColumns.Count > 1) or
       (FChildColumns.Count = 1) and (FChildColumns.ItemsI[0].DataType <> dtParentRowRef) then
      ErrorBadRelation;
    if (FParentColumns.Count > 1) or
       (FParentColumns.Count = 1) and not (FParentColumns.ItemsI[0].DataType in
        [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef]) then
      ErrorBadRelation;
  end
  else begin
    for i := 0 to FChildColumns.Count - 1 do
      if FChildColumns.ItemsI[i].DataType = dtParentRowRef then
        ErrorBadRelation;
    for i := 0 to FParentColumns.Count - 1 do
      if FParentColumns.ItemsI[i].DataType in
         [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef] then
        ErrorBadRelation;
    if (FChildTable <> nil) and (FParentTable <> nil) and
       (FChildColumns.Count > 0) and (FParentColumns.Count > 0) and
       (FChildTable = FParentTable) and FChildColumns.Matches(FParentColumns) then
      ErrorBadRelation;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetChildColumnCount: Integer;
begin
  Result := FChildColumns.Count;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetChildColumns(AIndex: Integer): TADDatSColumn;
begin
  Result := FChildColumns.ItemsI[AIndex];
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetIsDefined: Boolean;
begin
  Result := (FParentTable <> nil) and (FChildTable <> nil) and
    (FParentColumnNames <> '') and (FParentColumns.Count > 0) and
    (FChildColumnNames <> '') and (FChildColumns.Count > 0);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetParentColumnCount: Integer;
begin
  Result := FParentColumns.Count;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetParentColumns(AIndex: Integer): TADDatSColumn;
begin
  Result := FParentColumns.ItemsI[AIndex];
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetRelationList: TADDatSRelationList;
begin
  Result := List as TADDatSRelationList;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.HandleNotification(AParam: PADDatSNotifyParam);
begin
  if (FChildColumns <> nil) and FChildColumns.HandleNotification(AParam) then
    ChildColumnNames := '';
  if (FParentColumns <> nil) and FParentColumns.HandleNotification(AParam) then
    ParentColumnNames := '';
  if AParam^.FKind = snObjectRemoved then
    if TADDatSObject(AParam^.FParam2) = ParentTable then
      ParentTable := nil
    else if TADDatSObject(AParam^.FParam2) = ParentKeyConstraint then
      ParentKeyConstraint := nil
    else if TADDatSObject(AParam^.FParam2) = ChildTable then
      ChildTable := nil
    else if TADDatSObject(AParam^.FParam2) = ChildKeyConstraint then
      ChildKeyConstraint := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetChildColumnNames(const AValue: String);
begin
  if FChildColumnNames <> AValue then begin
    FChildColumnNames := AValue;
    FChildColumns.Fill(FChildTable, FChildColumnNames);
    try
      Check;
    except
      ChildColumnNames := '';
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetChildKeyConstraint(const AValue:
  TADDatSForeignKeyConstraint);
begin
  if FChildKeyConstraint <> AValue then begin
    FChildKeyConstraint := AValue;
    if FChildKeyConstraint <> nil then begin
      Nested := False;
      ChildTable := FChildKeyConstraint.Table;
      ChildColumnNames := FChildKeyConstraint.ColumnNames;
      if FChildKeyConstraint.RelatedTable <> nil then
        ParentTable := FChildKeyConstraint.RelatedTable
      else if (Manager <> nil) and (FChildKeyConstraint.RelatedTableName <> '') then
        ParentTable := Manager.Tables.TableByName(FChildKeyConstraint.RelatedTableName);
      ParentColumnNames := FChildKeyConstraint.RelatedColumnNames;
      Nested := False;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetChildTable(const AValue: TADDatSTable);
begin
  if FChildTable <> AValue then begin
    FChildTable := AValue;
    if FChildTable <> nil then begin
      FChildColumns.Fill(FChildTable, FChildColumnNames);
      try
        Check;
      except
        ChildTable := nil;
        raise;
      end;
    end
    else
      FChildColumns.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetNested(const AValue: Boolean);
begin
  if FNested <> AValue then begin
    FNested := AValue;
    try
      Check;
    except
      FNested := not FNested;
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetParentColumnNames(const AValue: String);
begin
  if FParentColumnNames <> AValue then begin
    FParentColumnNames := AValue;
    FParentColumns.Fill(FParentTable, FParentColumnNames);
    try
      Check;
    except
      ParentColumnNames := '';
      raise;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetParentKeyConstraint(const AValue: TADDatSUniqueConstraint);
begin
  if FParentKeyConstraint <> AValue then begin
    FParentKeyConstraint := AValue;
    if FParentKeyConstraint <> nil then begin
      Nested := False;
      ParentTable := FParentKeyConstraint.Table;
      ParentColumnNames := FParentKeyConstraint.ColumnNames;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.SetParentTable(const AValue: TADDatSTable);
begin
  if FParentTable <> AValue then begin
    FParentTable := AValue;
    if FParentTable <> nil then begin
      FParentColumns.Fill(FParentTable, FParentColumnNames);
      try
        Check;
      except
        ParentTable := nil;
        raise;
      end;
    end
    else
      FParentColumns.Clear;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.ResolveReferences(const AName, AValue: String);
begin
  if SameText(AName, 'ChildTable') then
    ChildTable := Manager.Tables.TableByName(AValue)
  else if SameText(AName, 'ChildKeyConstraint') then begin
    if ChildTable <> nil then
      ChildKeyConstraint := TADDatSForeignKeyConstraint(ChildTable.Constraints.ConstraintByName(AValue));
  end
  else if SameText(AName, 'ChildColumnNames') then
    ChildColumnNames := AValue
  else if SameText(AName, 'ParentTable') then
    ParentTable := Manager.Tables.TableByName(AValue)
  else if SameText(AName, 'ParentKeyConstraint') then begin
    if ParentTable <> nil then
      ParentKeyConstraint := TADDatSUniqueConstraint(ParentTable.Constraints.ConstraintByName(AValue));
  end
  else if SameText(AName, 'ParentColumnNames') then
    ParentColumnNames := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.InternalLoadFromStorage(AStorage: TADStorage);
begin
  inherited InternalLoadFromStorage(AStorage);
  AStorage.DeferAction('ChildTable', AStorage.ReadString('ChildTable', ''), ResolveReferences);
  AStorage.DeferAction('ChildKeyConstraint', AStorage.ReadString('ChildKeyConstraint', ''), ResolveReferences);
  AStorage.DeferAction('ChildColumnNames', AStorage.ReadString('ChildColumnNames', ''), ResolveReferences);
  Nested := AStorage.ReadBoolean('Nested', False);
  AStorage.DeferAction('ParentTable', AStorage.ReadString('ParentTable', ''), ResolveReferences);
  AStorage.DeferAction('ParentKeyConstraint', AStorage.ReadString('ParentKeyConstraint', ''), ResolveReferences);
  AStorage.DeferAction('ParentColumnNames', AStorage.ReadString('ParentColumnNames', ''), ResolveReferences);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  if ChildTable <> nil then
    AStorage.WriteString('ChildTable', ChildTable.Name, '');
  if ChildKeyConstraint <> nil then
    AStorage.WriteString('ChildKeyConstraint', ChildKeyConstraint.Name, '');
  AStorage.WriteString('ChildColumnNames', ChildColumnNames, '');
  AStorage.WriteBoolean('Nested', Nested, False);
  if ParentTable <> nil then
    AStorage.WriteString('ParentTable', ParentTable.Name, '');
  if ParentKeyConstraint <> nil then
    AStorage.WriteString('ParentKeyConstraint', ParentKeyConstraint.Name, '');
  AStorage.WriteString('ParentColumnNames', ParentColumnNames, '');
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.CountRef(AInit: Integer = 1);
begin
  FRefs.CountRef(AInit);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.AddRef;
begin
  FRefs.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelation.RemRef;
begin
  FRefs.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelation.GetIsRefCounted: Boolean;
begin
  Result := FRefs.Refs >= 0;
end;

{-------------------------------------------------------------------------------}
{- TADDatSRelationList                                                         -}
{-------------------------------------------------------------------------------}
constructor TADDatSRelationList.CreateForManager(AManager: TADDatSManager);
begin
  ASSERT(AManager <> nil);
  inherited Create;
  FOwner := AManager;
  OwnObjects := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRelationList.HandleNotification(AParam: PADDatSNotifyParam);
begin
  if AParam^.FReason = srDataChange then
    Exit;
  inherited HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(AObj: TADDatSRelation): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(AParentColumn, AChildColumn: TADDatSColumn;
  ANested, ACreateConstraints: Boolean): TADDatSRelation;
begin
  Result := TADDatSRelation.Create('', AParentColumn, AChildColumn, ANested,
    ACreateConstraints);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(const ARelName: String;
  AParentColumn, AChildColumn: TADDatSColumn; ANested,
  ACreateConstraints: Boolean): TADDatSRelation;
begin
  Result := TADDatSRelation.Create(ARelName, AParentColumn, AChildColumn,
    ANested, ACreateConstraints);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(const AParentColumns, AChildColumns: array of TADDatSColumn;
  ANested, ACreateConstraints: Boolean): TADDatSRelation;
begin
  Result := TADDatSRelation.Create('', AParentColumns, AChildColumns, ANested,
    ACreateConstraints);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(const ARelName: String;
  const AParentColumns, AChildColumns: array of TADDatSColumn;
  ANested, ACreateConstraints: Boolean): TADDatSRelation;
begin
  Result := TADDatSRelation.Create(ARelName, AParentColumns, AChildColumns,
    ANested, ACreateConstraints);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(const ARelName: String; const AParentColumnNames,
  AChildColumnNames: String; AParentTable, AChildTable: TADDatSTable;
  ANested: Boolean {$IFDEF AnyDAC_D6Base} = False {$ENDIF};
  ACreateConstraints: Boolean {$IFDEF AnyDAC_D6Base} = True {$ENDIF}): TADDatSRelation;
begin
  Result := TADDatSRelation.Create(ARelName, AParentColumnNames, AChildColumnNames,
    AParentTable, AChildTable, ANested, ACreateConstraints);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.Add(const ARelName: String;
  APK: TADDatSUniqueConstraint;
  AFK: TADDatSForeignKeyConstraint): TADDatSRelation;
begin
  Result := TADDatSRelation.Create(ARelName, APK, AFK);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.FindRelation(AParentTable, AChildTable:
  TADDatSTable; AMBNested: Boolean): TADDatSRelation;
var
  i: Integer;
  oRel: TADDatSRelation;
begin
  Result := nil;
  for i := 0 to Count - 1 do begin
    oRel := ItemsI[i];
    if (oRel.ParentTable = AParentTable) and (oRel.ChildTable = AChildTable) and
       (not AMBNested or AMBNested and oRel.Nested) then begin
      if oRel.IsDefined then begin
        Result := ItemsI[i];
        Break;
      end
      else if Result = nil then
        Result := ItemsI[i];
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.FindRelation(AParentTable: TADDatSTable;
  AObjColumn: TADDatSColumn): TADDatSRelation;
var
  i: Integer;
  oRel: TADDatSRelation;
begin
  Result := nil;
  for i := 0 to Count - 1 do begin
    oRel := ItemsI[i];
    if (oRel.ParentTable = AParentTable) and (oRel.ParentColumnCount = 1) and
       (oRel.ChildColumnCount = 1) and (oRel.ParentColumns[0] = AObjColumn) and oRel.Nested then begin
      if oRel.IsDefined then begin
        Result := ItemsI[i];
        Break;
      end
      else if Result = nil then
        Result := ItemsI[i];
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.FindRelation(ANestedTable: TADDatSTable): TADDatSRelation;
var
  i: Integer;
  oRel: TADDatSRelation;
begin
  Result := nil;
  for i := 0 to Count - 1 do begin
    oRel := ItemsI[i];
    if (oRel.ChildTable = ANestedTable) and (oRel.ParentColumnCount = 1) and
       (oRel.ChildColumnCount = 1) and oRel.Nested then begin
      if oRel.IsDefined then begin
        Result := ItemsI[i];
        Break;
      end
      else if Result = nil then
        Result := ItemsI[i];
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.GetItemsI(AIndex: Integer): TADDatSRelation;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSRelation(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.RelationByName(const AName: String):
  TADDatSRelation;
begin
  Result := TADDatSRelation(inherited ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
function TADDatSRelationList.GetRelationsForTable(AParentRelations: Boolean;
  ATable: TADDatSTable): TADDatSRelationArray;
var
  iCount, i: Integer;
begin
  SetLength(Result, 32);
  iCount := 0;
  for i := 0 to Count - 1 do
    if AParentRelations and (ItemsI[i].ChildTable = ATable) or
       not AParentRelations and (ItemsI[i].ParentTable = ATable) then begin
      if Length(Result) = iCount then
        SetLength(Result, Length(Result) + 32);
      Result[iCount] := ItemsI[i];
      Inc(iCount);
    end;
  SetLength(Result, iCount);
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechBase                                                             -}
{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechBase then
    Active := TADDatSMechBase(AObj).Active;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechBase.GetRowsRange(var ARowList: TADDatSRowListBase;
  out ABeginInd, AEndInd: Integer): Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechBase.AcceptRow(ARow: TADDatSRow; AVersion:
  TADDatSRowVersion): Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.PostProcess(AList: TADDatSRowListBase);
begin
  // none
end;

{-------------------------------------------------------------------------------}
function TADDatSMechBase.GetActualActive: Boolean;
begin
  Result := Active and (View <> nil) and View.ActualActive;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.CheckActiveChanged;
begin
  if FPrevActualActive <> ActualActive then begin
    DoActiveChanged;
    FPrevActualActive := ActualActive;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.DoActiveChanged;
begin
  if not Locator then
    Notify(snMechanismStateChanged, srMetaChange, TADNativeInt(Self), 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.SetActive(const AValue: Boolean);
begin
  if FActive <> AValue then begin
    FActive := AValue;
    CheckActiveChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.DoListInserted;
begin
  CheckActiveChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.DoListRemoving;
begin
  Active := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.DoListRemoved(ANewOwner: TADDatSObject);
begin
  CheckActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechBase.GetTable: TADDatSTable;
var
  oView: TADDatSView;
begin
  oView := View;
  if oView <> nil then
    Result := oView.Table
  else
    Result := nil;
  ASSERT((Result = nil) or (Result is TADDatSTable));
end;

{-------------------------------------------------------------------------------}
function TADDatSMechBase.GetView: TADDatSView;
begin
  if Owner <> nil then
    Result := TADDatSView(Owner.Owner)
  else
    Result := nil;
  ASSERT((Result = nil) or (Result is TADDatSView));
end;

{-------------------------------------------------------------------------------}
function TADDatSMechBase.GetViewList: TADDatSViewList;
var
  oView: TADDatSView;
begin
  oView := View;
  if oView <> nil then
    Result := oView.ViewList
  else
    Result := nil;
  ASSERT((Result = nil) or (Result is TADDatSViewList));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.ResolveActive(const AName, AValue: String);
begin
  if SameText(AName, 'Active') and SameText(AValue, S_AD_True) then
    Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.InternalLoadFromStorage(AStorage: TADStorage);
var
  lActive: Boolean;
begin
  Active := False;
  inherited InternalLoadFromStorage(AStorage);
  lActive := AStorage.ReadBoolean('Active', False);
  if lActive then
    AStorage.DeferAction('Active', S_AD_True, ResolveActive);
  Active := AStorage.ReadBoolean('Active', False);
  Locator := AStorage.ReadBoolean('Locator', False);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechBase.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  AStorage.WriteBoolean('Active', Active, False);
  AStorage.WriteBoolean('Locator', Locator, False);
end;

{-------------------------------------------------------------------------------}
{- TADDatSViewMechList                                                         -}
{-------------------------------------------------------------------------------}
constructor TADDatSViewMechList.CreateForView(AView: TADDatSView);
begin
  ASSERT(AView <> nil);
  inherited Create;
  FOwner := AView;
  OwnObjects := True;
  FDefaultReason := srMetaChange;
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AcceptRow(ARow: TADDatSRow; AVersion:
  TADDatSRowVersion): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to Count - 1 do
    if not ItemsI[i].AcceptRow(ARow, AVersion) then begin
      Result := False;
      Exit;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.Add(AObj: TADDatSMechBase): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddFilter(const AExpression: String;
  AOptions: TADExpressionOptions; AEvent: TADFilterRowEvent): TADDatSMechFilter;
begin
  Result := TADDatSMechFilter.Create(AExpression, AOptions, AEvent);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddSort(const AColumns, ADescColumns,
  ACaseInsColumns: String; AOptions: TADSortOptions): TADDatSMechSort;
begin
  Result := TADDatSMechSort.Create(AColumns, ADescColumns,
    ACaseInsColumns, AOptions);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddSort(const AExpression: String;
  AOptions: TADSortOptions): TADDatSMechSort;
begin
  Result := TADDatSMechSort.Create(AExpression, AOptions);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddDistinct(AColumnCount: Integer): TADDatSMechDistinct;
begin
  Result := TADDatSMechDistinct.Create(AColumnCount);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddStates(
  AStates: TADDatSRowStates): TADDatSMechRowState;
begin
  Result := TADDatSMechRowState.Create(AStates);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddError: TADDatSMechError;
begin
  Result := TADDatSMechError.CreateErr;
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.AddDetail(AParentRel: TADDatSRelation;
  AParentRow: TADDatSRow): TADDatSMechDetails;
begin
  Result := TADDatSMechDetails.Create(AParentRel, AParentRow);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewMechList.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].Active := False;
  inherited Clear;
end;

{-------------------------------------------------------------------------------}
function TADDatSViewMechList.GetItemsI(AIndex: Integer): TADDatSMechBase;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSMechBase(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewMechList.HandleNotification(AParam: PADDatSNotifyParam);
begin
  if AParam^.FReason = srDataChange then
    Exit;
  inherited HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechSort                                                             -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechSort.Create;
begin
  inherited Create;
  FKinds := [mkSort];
  FColumnList := TADDatSColumnSublist.Create;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechSort.Create(const AColumns, ADescColumns,
  ACaseInsColumns: String; AOptions: TADSortOptions);
begin
  Create;
  Columns := AColumns;
  DescendingColumns := ADescColumns;
  CaseInsensitiveColumns := ACaseInsColumns;
  SortOptions := AOptions;
  Active := True;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechSort.Create(const AExpression: String;
  AOptions: TADSortOptions);
begin
  Create;
  Expression := AExpression;
  SortOptions := AOptions;
  Active := True;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSMechSort.Destroy;
begin
  ADFreeAndNil(FColumnList);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechSort then begin
    Columns := TADDatSMechSort(AObj).Columns;
    DescendingColumns := TADDatSMechSort(AObj).DescendingColumns;
    CaseInsensitiveColumns := TADDatSMechSort(AObj).CaseInsensitiveColumns;
    SortOptions := TADDatSMechSort(AObj).SortOptions;
    Expression := TADDatSMechSort(AObj).Expression;
  end;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := (Columns = TADDatSMechSort(AObj).Columns) and
      (DescendingColumns = TADDatSMechSort(AObj).DescendingColumns) and
      (CaseInsensitiveColumns = TADDatSMechSort(AObj).CaseInsensitiveColumns) and
      (SortOptions = TADDatSMechSort(AObj).SortOptions) and
      (Expression = TADDatSMechSort(AObj).Expression);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort._AddRef: Integer;
begin
  Result := 1;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort._Release: Integer;
begin
  Result := 1;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_FPC}
function TADDatSMechSort.QueryInterface({$IFDEF FPC_HAS_CONSTREF} constref {$ELSE} const {$ENDIF}
  iid: tguid; out obj): longint;
{$ELSE}
function TADDatSMechSort.QueryInterface(const IID: TGUID; out Obj): HResult;
{$ENDIF}
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.CreateUniqueConstraint: TADDatSUniqueConstraint;
begin
  Result := TADDatSUniqueConstraint.Create;
  Result.Rely := True;
  Result.Name := Table.Constraints.BuildUniqueName(C_AD_SysNamePrefix + 'UC_' + View.Name);
  Result.ColumnNames := Columns;
  Result.Options := SortOptions;
  Table.Constraints.Add(Result);
  Result.Enforce := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.DoActiveChanged;
var
  oParser: IADStanExpressionParser;
begin
  if ActualActive then begin
    FUniqueKey := nil;
    if FExpression <> '' then
      FSortSource := ssExpression
    else if (FColumns <> '') and (FColumns <> '#') then
      FSortSource := ssColumns
    else
      FSortSource := ssRowId;
    if not FSortOptionsChanged then
      if not Table.CaseSensitive then
        FSortOptions := FSortOptions + [soNoCase];
    case FSortSource of
    ssColumns:
      begin
        FCaseInsensitiveColumnList := TADDatSColumnSublist.Create;
        FDescendingColumnList := TADDatSColumnSublist.Create;
        try
          if FCaseInsensitiveColumns <> '' then
            FCaseInsensitiveColumnList.Fill(Self, FCaseInsensitiveColumns);
          if FDescendingColumns <> '' then
            FDescendingColumnList.Fill(Self, FDescendingColumns);
          FColumnList.Fill(Self, FColumns, FCaseInsensitiveColumnList,
            FDescendingColumnList);
        finally
          if FCaseInsensitiveColumnList.Count = 0 then
            ADFreeAndNil(FCaseInsensitiveColumnList);
          if FDescendingColumnList.Count = 0 then
            ADFreeAndNil(FDescendingColumnList);
        end;
        if [soUnique, soPrimary] * SortOptions <> [] then
          if Table.Constraints.FindUnique(FColumns) = nil then
            FUniqueKey := CreateUniqueConstraint;
      end;
    ssExpression:
      begin
        ADCreateInterface(IADStanExpressionParser, oParser);
        FEvaluator := oParser.Prepare(TADDatSTableExpressionDS.Create(Table),
          Expression, [], [poDefaultExpr], '');
      end;
    end;
  end
  else begin
    if FColumnList <> nil then
      FColumnList.Clear;
    ADFreeAndNil(FCaseInsensitiveColumnList);
    ADFreeAndNil(FDescendingColumnList);
    FEvaluator := nil;
    ADFreeAndNil(FUniqueKey);
  end;
  inherited DoActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.Search(ARowList: TADDatSRowListBase;
  AKeyRow: TADDatSRow; AKeyColumnList, AKeyColumnList2: TADDatSColumnSublist;
  AKeyColumnCount: Integer; AOptions: TADLocateOptions; out AIndex: Integer;
  out AFound: Boolean; ARowVersion: TADDatSRowVersion): Integer;
var
  iMid: Integer;
  iFirstNo, iLastNo: Integer;
  oRow: TADDatSRow;
  eOpts: TADCompareDataOptions;
  oKeyColumns: TADDatSColumnSublist;
  oCache: TADDatSCompareRowsCache;
  lOnKeyRow, lUseRowId: Boolean;

  function CompareRows(ARow1, ARow2: TADDatSRow): Integer;
  begin
    case FSortSource of
    ssColumns:
      Result := ARow1.CompareRows(oKeyColumns, FDescendingColumnList,
        FCaseInsensitiveColumnList, AKeyColumnCount, ARow2, AKeyColumnList2,
        ARowVersion, eOpts, oCache);
    ssExpression:
      Result := ARow1.CompareRowsExp(FEvaluator, ARow2, ARowVersion, eOpts);
    else
      Result := 0;
    end;
    if lUseRowId and (Result = 0) then
      if ARow1.FRowID < ARow2.FRowID then
        Result := -1
      else if ARow1.FRowID > ARow2.FRowID then
        Result := 1
      else
        Result := 0;
  end;

begin
  ASSERT((ARowList <> nil) and (AKeyRow <> nil));
  Result := 0;
  AIndex := -1;
  AFound := False;
  iFirstNo := 0;
  iLastNo := ARowList.Count - 1;
  eOpts := [coCache];
  iMid := -1;
  lOnKeyRow := False;
  lUseRowId := (loUseRowID in AOptions) and ([soUnique, soPrimary] * FSortOptions = []) or
    (FSortSource = ssRowID);
  if AKeyColumnList = nil then
    oKeyColumns := FColumnList
  else
    oKeyColumns := AKeyColumnList;
  if loNoCase in AOptions then
    Include(eOpts, coNoCase);
  if soNullFirst in SortOptions then
    Include(eOpts, coNullFirst);
  if soDescNullLast in SortOptions then
    Include(eOpts, coDescNullLast);
  if soDescending in SortOptions then
    Include(eOpts, coDescending);
  if soNoSymbols in SortOptions then
    Include(eOpts, coNoSymbols);
  if loPartial in AOptions then
    Include(eOpts, coPartial);
  while iFirstNo <= iLastNo do begin
    iMid := (iFirstNo + iLastNo) div 2;
    oRow := ARowList.ItemsI[iMid];
    if (loExcludeKeyRow in AOptions) and (oRow = AKeyRow) then begin
      if iMid < iLastNo then begin
        Inc(iMid);
        oRow := ARowList.ItemsI[iMid];
      end
      else if iMid > iFirstNo then begin
        Dec(iMid);
        oRow := ARowList.ItemsI[iMid];
      end
      else begin
        lOnKeyRow := True;
        Result := -1;
        Dec(iMid);
        Break;
      end;
    end;
    if oRow <> nil then
      Result := CompareRows(oRow, AKeyRow);
    if Result > 0 then
      iLastNo := iMid - 1
    else if Result < 0 then
      iFirstNo := iMid + 1
    else begin
      if (loLast in AOptions) xor (loBackward in AOptions) then
        while iMid < ARowList.Count - 1 do begin
          Inc(iMid);
          oRow := ARowList.ItemsI[iMid];
          Result := CompareRows(oRow, AKeyRow);
          if Result <> 0 then begin
            Dec(iMid);
            Break;
          end;
        end
      else
        while iMid > 0 do begin
          Dec(iMid);
          oRow := ARowList.ItemsI[iMid];
          Result := CompareRows(oRow, AKeyRow);
          if Result <> 0 then begin
            Inc(iMid);
            Break;
          end;
        end;
      Result := 0;
      AFound := True;
      Break;
    end;
  end;
  if iFirstNo >= ARowList.Count then
    AIndex := ARowList.Count
  else if iLastNo < 0 then
    AIndex := -1
  else if iMid < 0 then
    AIndex := iFirstNo
  else if iMid >= ARowList.Count then
    AIndex := iLastNo
  else if ARowList.Count <> 0 then begin
    AIndex := iMid;
    if (lOnKeyRow or (Result = -1)) and ([loLast, loNearest] * AOptions <> []) then begin
      if Result = -1 then
        Inc(AIndex)
      else if Result = 1 then
        Dec(AIndex);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.HandleNotification(AParam: PADDatSNotifyParam);
begin
  if (FColumnList <> nil) and
       FColumnList.HandleNotification(AParam) or
     (FDescendingColumnList <> nil) and
       FDescendingColumnList.HandleNotification(AParam) or
     (FCaseInsensitiveColumnList <> nil) and
       FCaseInsensitiveColumnList.HandleNotification(AParam) or
     (FEvaluator <> nil) and
       FEvaluator.HandleNotification(Word(AParam^.FKind), Word(AParam^.FReason),
                                     AParam^.FParam1, AParam^.FParam2) then
    Active := False
  else if AParam^.FKind = snObjectRemoved then
    if AParam^.FParam2 = TADNativeInt(FUniqueKey) then
      FUniqueKey := nil
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.SetCaseInsensitiveColumns(const AValue: String);
begin
  if FCaseInsensitiveColumns <> AValue then begin
    FCaseInsensitiveColumns := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.SetColumns(const AValue: String);
begin
  if FColumns <> AValue then begin
    FColumns := AValue;
    FExpression := '';
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.SetExpression(const AValue: String);
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    FColumns := '';
    FCaseInsensitiveColumns := '';
    FDescendingColumns := '';
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.SetDescendingColumns(const AValue: String);
begin
  if FDescendingColumns <> AValue then begin
    FDescendingColumns := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.GetSortOptions: TADSortOptions;
begin
  Result := FSortOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.SetSortOptions(const AValue: TADSortOptions);
begin
  if FSortOptions <> AValue then begin
    FSortOptions := AValue;
    FSortOptionsChanged := True;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.CompareRows(ARow1, ARow2: TADDatSRow;
  AColumnCount: Integer; AOptions: TADCompareDataOptions): Integer;
begin
  case FSortSource of
  ssColumns:
    Result := ARow1.CompareRows(FColumnList, FDescendingColumnList,
      FCaseInsensitiveColumnList, AColumnCount, ARow2, nil, rvDefault,
      AOptions, ADEmptyCC);
  ssExpression:
    Result := ARow1.CompareRowsExp(FEvaluator, ARow2, rvDefault, AOptions);
  else
    Result := 0;
  end;
  // take into account original sort order
  if (FSortSource = ssRowId) or ((Result = 0) and
     (AColumnCount < 0) and ([soUnique, soPrimary] * FSortOptions = [])) then
    if ARow1.FRowID < ARow2.FRowID then
      Result := -1
    else if ARow1.FRowID > ARow2.FRowID then
      Result := 1
    else
      Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.GetCompareDataOptions: TADCompareDataOptions;
begin
  Result := [];
  if soNoCase in SortOptions then
    Include(Result, coNoCase);
  if soNullFirst in SortOptions then
    Include(Result, coNullFirst);
  if soDescNullLast in SortOptions then
    Include(Result, coDescNullLast);
  if soDescending in SortOptions then
    Include(Result, coDescending);
  if soNoSymbols in SortOptions then
    Include(Result, coNoSymbols);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.CompareRows(ARow1, ARow2: TADDatSRow;
  AColumnCount: Integer): Integer;
begin
  Result := CompareRows(ARow1, ARow2, AColumnCount, GetCompareDataOptions);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.Sort(AList: TADDatSRowListBase);
var
  eOpts: TADCompareDataOptions;
begin
  eOpts := GetCompareDataOptions;
  AList.Sort(CompareRows, eOpts);
  if ([soUnique, soPrimary] * SortOptions <> []) and (GetSortSource <> ssRowId) then
    AList.CheckDuplicates(CompareRows, eOpts);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.RemoveDuplicates(AList: TADDatSRowListBase; AColumnCount: Integer);
begin
  AList.RemoveDuplicates(CompareRows, AColumnCount, GetCompareDataOptions);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.MatchOptions(ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean;

  function NormOpts(AOpts: TADSortOptions): TADSortOptions;
  begin
    if [soUnique, soPrimary] * AOpts <> [] then
      Result := AOpts + [soUnique, soPrimary]
    else
      Result := AOpts;
  end;

var
  eSortOpts, eReqOpts, eProhOpts: TADSortOptions;
begin
  eSortOpts := NormOpts(SortOptions);
  eReqOpts := NormOpts(ARequiredOptions);
  eProhOpts := NormOpts(AProhibitedOptions);
  Result := (eSortOpts * eReqOpts = eReqOpts) and (eSortOpts * eProhOpts = []);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.SortingOn(const AColumnNames: String;
  ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean;
var
  oCols, oDescs, oNoCases: TADDatSColumnSublist;
begin
  if SortSource = ssColumns then begin
    oCols := TADDatSColumnSublist.Create;
    oDescs := TADDatSColumnSublist.Create;
    oNoCases := TADDatSColumnSublist.Create;
    try
      oCols.Fill(Self, AColumnNames, oNoCases, oDescs);
      Result := SortColumnList.Matches(oCols, oCols.Count) and
        ((SortDescendingColumnList = nil) and (oDescs.Count = 0) or
         (SortDescendingColumnList <> nil) and SortDescendingColumnList.Matches(oDescs, -2)) and
        ((SortCaseInsensitiveColumnList = nil) and (oNoCases.Count = 0) or
         (SortCaseInsensitiveColumnList <> nil) and SortCaseInsensitiveColumnList.Matches(oNoCases, -2));
    finally
      ADFree(oCols);
      ADFree(oDescs);
      ADFree(oNoCases);
    end;
  end
  else
    Result := (SortSource = ssRowId) and (AColumnNames = '#');
  Result := Result and MatchOptions(ARequiredOptions, AProhibitedOptions);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.SortingOn(AKeyColumnList: TADDatSColumnSublist;
  AKeyColumnCount: Integer; ARequiredOptions, AProhibitedOptions: TADSortOptions): Boolean;
begin
  Result := (SortSource = ssColumns) and
    SortColumnList.Matches(AKeyColumnList, AKeyColumnCount) and
    MatchOptions(ARequiredOptions, AProhibitedOptions);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.GetSortCaseInsensitiveColumnList: TADDatSColumnSublist;
begin
  Result := FCaseInsensitiveColumnList;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.GetSortColumnList: TADDatSColumnSublist;
begin
  Result := FColumnList;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.GetSortDescendingColumnList: TADDatSColumnSublist;
begin
  Result := FDescendingColumnList;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.GetSortSource: TADDatSMechSortSource;
begin
  Result := FSortSource;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechSort.GetSortedRows: TADDatSRowListBase;
begin
  Result := View.Rows;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.InternalLoadFromStorage(AStorage: TADStorage);
var
  eOpt: TADSortOption;
  eOpts: TADSortOptions;
begin
  inherited InternalLoadFromStorage(AStorage);
  Expression := AStorage.ReadString('Expression', '');
  Columns := AStorage.ReadString('Columns', '');
  DescendingColumns := AStorage.ReadString('DescendingColumns', '');
  CaseInsensitiveColumns := AStorage.ReadString('CaseInsensitiveColumns', '');
  eOpts := [];
  for eOpt := Low(TADSortOption) to High(TADSortOption) do
    if AStorage.ReadBoolean(Copy(GetEnumName(TypeInfo(TADSortOption),
                            Integer(eOpt)), 3, MAXINT), False) then
      Include(eOpts, eOpt);
  SortOptions := eOpts;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechSort.InternalSaveToStorage(AStorage: TADStorage);
var
  eOpt: TADSortOption;
begin
  inherited InternalSaveToStorage(AStorage);
  AStorage.WriteString('Expression', Expression, '');
  AStorage.WriteString('Columns', Columns, '');
  AStorage.WriteString('DescendingColumns', DescendingColumns, '');
  AStorage.WriteString('CaseInsensitiveColumns', CaseInsensitiveColumns, '');
  for eOpt := Low(TADSortOption) to High(TADSortOption) do
    if eOpt in SortOptions then
      AStorage.WriteBoolean(Copy(GetEnumName(TypeInfo(TADSortOption),
        Integer(eOpt)), 3, MAXINT), True, False);
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechRowState                                                         -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechRowState.Create;
begin
  inherited Create;
  FKinds := [mkFilter];
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechRowState.Create(AStates: TADDatSRowStates);
begin
  Create;
  RowStates := AStates;
  Active := True;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechRowState.AcceptRow(ARow: TADDatSRow; AVersion:
  TADDatSRowVersion): Boolean;
begin
  ASSERT(ARow <> nil);
  Result := ARow.RowState in RowStates;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRowState.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechRowState then
    RowStates := TADDatSMechRowState(AObj).RowStates;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechRowState.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := RowStates = TADDatSMechRowState(AObj).RowStates;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRowState.SetRowStates(const AValue: TADDatSRowStates);
begin
  if FRowStates <> AValue then begin
    FRowStates := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRowState.InternalLoadFromStorage(AStorage: TADStorage);
var
  eState: TADDatSRowState;
  eStates: TADDatSRowStates;
begin
  inherited InternalLoadFromStorage(AStorage);
  eStates := [];
  for eState := Low(TADDatSRowState) to High(TADDatSRowState) do
    if AStorage.ReadBoolean(Copy(GetEnumName(TypeInfo(TADDatSRowState),
                            Integer(eState)), 3, MAXINT), False) then
      Include(eStates, eState);
  RowStates := eStates;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRowState.InternalSaveToStorage(AStorage: TADStorage);
var
  eState: TADDatSRowState;
begin
  inherited InternalSaveToStorage(AStorage);
  for eState := Low(TADDatSRowState) to High(TADDatSRowState) do
    if eState in RowStates then
      AStorage.WriteBoolean(Copy(GetEnumName(TypeInfo(TADDatSRowState),
        Integer(eState)), 3, MAXINT), True, False);
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechRange                                                            -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechRange.Create;
begin
  inherited Create;
  FKinds := [mkFilter];
  BottomColumnCount := -1;
  BottomExclusive := False;
  TopColumnCount := -1;
  TopExclusive := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechRange then begin
    SortMech := TADDatSMechRange(AObj).SortMech;
    BottomExclusive := TADDatSMechRange(AObj).BottomExclusive;
    TopExclusive := TADDatSMechRange(AObj).TopExclusive;
    BottomColumnCount := TADDatSMechRange(AObj).BottomColumnCount;
    TopColumnCount := TADDatSMechRange(AObj).TopColumnCount;
    if (TADDatSMechRange(AObj).Top <> nil) and
       (TADDatSMechRange(AObj).Top.Table <> Table) then
      Top := TADDatSMechRange(AObj).Top
    else
      Top := nil;
    if (TADDatSMechRange(AObj).Bottom <> nil) and
       (TADDatSMechRange(AObj).Bottom.Table <> Table) then
      Bottom := TADDatSMechRange(AObj).Bottom
    else
      Bottom := nil;
  end;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechRange.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result :=
      (SortMech = TADDatSMechRange(AObj).SortMech) and
      (BottomExclusive = TADDatSMechRange(AObj).BottomExclusive) and
      (TopExclusive = TADDatSMechRange(AObj).TopExclusive) and
      (BottomColumnCount = TADDatSMechRange(AObj).BottomColumnCount) and
      (TopColumnCount = TADDatSMechRange(AObj).TopColumnCount);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.DoActiveChanged;
var
  oView: TADDatSView;
begin
  if ActualActive then
    if SortMech = nil then begin
      oView := View;
      if oView <> nil then
        FSortMech := oView.SortingMechanism;
    end;
  inherited DoActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechRange.NoRangeNoRecords: Boolean;
begin
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechRange.GetRowsRange(var ARowList: TADDatSRowListBase;
  out ABeginInd, AEndInd: Integer): Boolean;
var
  eOpts: TADLocateOptions;
  iRes: Integer;
  lTemp: Boolean;
begin
  if (SortMech <> nil) and ((Top <> nil) or (Bottom <> nil)) then begin
    eOpts := [loNearest];
    if soNoCase in SortMech.SortOptions then
      Include(eOpts, loNoCase);
    if Bottom <> nil then begin
      lTemp := False;
      iRes := SortMech.Search(ARowList, Bottom, nil, FBottomColumnList,
        FBottomColumnCount, eOpts, ABeginInd, lTemp);
      if iRes > 0 then
        Dec(ABeginInd);
    end;
    if Top <> nil then
      SortMech.Search(ARowList, Top, nil, FTopColumnList,
        FTopColumnCount, eOpts + [loLast], AEndInd, lTemp);
    Result := True;
  end
  else begin
    if NoRangeNoRecords then begin
      Result := True;
      ABeginInd := 0;
      AEndInd := -1;
    end
    else
      Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechRange.AcceptRow(ARow: TADDatSRow; AVersion:
  TADDatSRowVersion): Boolean;
var
  eOpts: TADCompareDataOptions;
  iRes: Integer;
begin
  Result := not NoRangeNoRecords;
  if SortMech <> nil then begin
    eOpts := [];
    if soNoCase in SortMech.SortOptions then
      Include(eOpts, coNoCase);
    if soNullFirst in SortMech.SortOptions then
      Include(eOpts, coNullFirst);
    if soDescNullLast in SortMech.SortOptions then
      Include(eOpts, coDescNullLast);
    if soDescending in SortMech.SortOptions then
      Include(eOpts, coDescending);
    if soNoSymbols in SortMech.SortOptions then
      Include(eOpts, coNoSymbols);
    if Bottom <> nil then begin
      iRes := ARow.CompareRows(SortMech.SortColumnList, SortMech.SortDescendingColumnList,
        SortMech.SortCaseInsensitiveColumnList, FBottomColumnCount, Bottom, FBottomColumnList,
        rvDefault, eOpts, ADEmptyCC);
      Result := (iRes > 0) or (iRes = 0) and not BottomExclusive;
    end;
    if Result and (Top <> nil) then begin
      iRes := ARow.CompareRows(SortMech.SortColumnList, SortMech.SortDescendingColumnList,
        SortMech.SortCaseInsensitiveColumnList, FTopColumnCount, Top, FTopColumnList,
        rvDefault, eOpts, ADEmptyCC);
      Result := (iRes < 0) or (iRes = 0) and not TopExclusive;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetBottom(const AValue: TADDatSRow);
begin
  if FBottom <> AValue then begin
    FBottom := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetTop(const AValue: TADDatSRow);
begin
  if FTop <> AValue then begin
    FTop := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetBottomExclusive(const AValue: Boolean);
begin
  if FBottomExclusive <> AValue then begin
    FBottomExclusive := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetTopExclusive(const AValue: Boolean);
begin
  if FTopExclusive <> AValue then begin
    FTopExclusive := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetSortMech(const AValue: IADDatSMechSort);
begin
  FSortMech := AValue;
  Active := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetBottomColumnCount(const AValue: Integer);
begin
  if FBottomColumnCount <> AValue then begin
    FBottomColumnCount := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.SetTopColumnCount(const AValue: Integer);
begin
  if FTopColumnCount <> AValue then begin
    FTopColumnCount := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.InternalLoadFromStorage(AStorage: TADStorage);
begin
  inherited InternalLoadFromStorage(AStorage);
  BottomExclusive := AStorage.ReadBoolean('BottomExclusive', False);
  TopExclusive := AStorage.ReadBoolean('TopExclusive', False);
  BottomColumnCount := AStorage.ReadInteger('BottomColumnCount', -1);
  TopColumnCount := AStorage.ReadInteger('TopColumnCount', -1);
{ TODO -cDATS : How to load the rest ? }
{
    property Bottom: TADDatSRow read FBottom write SetBottom;
    property Top: TADDatSRow read FTop write SetTop;
    property SortMech: IADDatSMechSort read FSortMech write SetSortMech;
}
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechRange.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  AStorage.WriteBoolean('BottomExclusive', BottomExclusive, False);
  AStorage.WriteBoolean('TopExclusive', TopExclusive, False);
  AStorage.WriteInteger('BottomColumnCount', BottomColumnCount, -1);
  AStorage.WriteInteger('TopColumnCount', TopColumnCount, -1);
{ TODO -cDATS : How to store the rest ? }
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechDistinct                                                         -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechDistinct.Create;
begin
  inherited Create;
  FKinds := [mkFilter, mkPost];
  FColumnCount := -1;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechDistinct.Create(AColumnCount: Integer);
begin
  Create;
  ColumnCount := AColumnCount;
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDistinct.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechDistinct then begin
    SortMech := TADDatSMechDistinct(AObj).SortMech;
    ColumnCount := TADDatSMechDistinct(AObj).ColumnCount;
  end;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechDistinct.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result :=
      (SortMech = TADDatSMechDistinct(AObj).SortMech) and
      (ColumnCount = TADDatSMechDistinct(AObj).ColumnCount);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDistinct.DoActiveChanged;
var
  oView: TADDatSView;
begin
  if ActualActive then begin
    if SortMech = nil then begin
      oView := View;
      if oView <> nil then
        FSortMech := oView.SortingMechanism;
    end;
    // ColumnCount must be <> -1, otherwise SortMech.CompareRows will
    // always return non-zero
    if (ColumnCount = -1) and (FSortMech <> nil) then
      FColumnCount := FSortMech.SortColumnList.Count;
  end;
  inherited DoActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechDistinct.AcceptRow(ARow: TADDatSRow;
  AVersion: TADDatSRowVersion): Boolean;
var
  eOpts: TADLocateOptions;
  iPos: Integer;
begin
  if SortMech <> nil then begin
    eOpts := [];
    if soNoCase in SortMech.SortOptions then
      Include(eOpts, loNoCase);
    SortMech.Search(View.Rows, ARow, nil, nil, ColumnCount, eOpts, iPos, Result, AVersion);
    Result := not Result;
  end
  else
    Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDistinct.PostProcess(AList: TADDatSRowListBase);
begin
  if SortMech <> nil then
    SortMech.RemoveDuplicates(AList, ColumnCount);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDistinct.SetColumnCount(const AValue: Integer);
begin
  if FColumnCount <> AValue then begin
    FColumnCount := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDistinct.SetSortMech(const AValue: IADDatSMechSort);
begin
  FSortMech := AValue;
  Active := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDistinct.InternalLoadFromStorage(AStorage: TADStorage);
begin
  inherited InternalLoadFromStorage(AStorage);
  ColumnCount := AStorage.ReadInteger('ColumnCount', -1);
{ TODO -cDATS : How to load the rest ? }
{
    property SortMech: IADDatSMechSort read FSortMech write SetSortMech;
}
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDistinct.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  AStorage.WriteInteger('ColumnCount', ColumnCount, -1);
{ TODO -cDATS : How to store the rest ? }
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechFilter                                                           -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechFilter.Create;
begin
  inherited Create;
  FKinds := [mkFilter];
  FOptions := [];
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechFilter.Create(const AExpression: String;
  AOptions: TADExpressionOptions; AEvent: TADFilterRowEvent);
begin
  Create;
  Options := AOptions;
  Expression := AExpression;
  OnFilterRow := AEvent;
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechFilter.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechFilter then begin
    Options := TADDatSMechFilter(AObj).Options;
    Expression := TADDatSMechFilter(AObj).Expression;
    OnFilterRow := TADDatSMechFilter(AObj).OnFilterRow;
  end;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechFilter.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := (Expression = TADDatSMechFilter(AObj).Expression) and
      (Options = TADDatSMechFilter(AObj).Options) and
      (TMethod(OnFilterRow).Code <> TMethod(OnFilterRow).Code) and
      (TMethod(OnFilterRow).Data <> TMethod(OnFilterRow).Data);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechFilter.DoActiveChanged;
var
  oParser: IADStanExpressionParser;
begin
  if ActualActive and (Expression <> '') then begin
    ADCreateInterface(IADStanExpressionParser, oParser);
    FEvaluator := oParser.Prepare(TADDatSTableExpressionDS.Create(Table),
      Expression, FOptions, [poCheck], '');
  end
  else
    FEvaluator := nil;
  inherited DoActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechFilter.AcceptRow(ARow: TADDatSRow; AVersion:
  TADDatSRowVersion): Boolean;
begin
  Result := True;
  if FEvaluator <> nil then begin
    FEvaluator.DataSource.Position := ARow;
    try
      Result := FEvaluator.Evaluate;
    finally
      FEvaluator.DataSource.Position := nil;
    end;
  end;
  if Result and Assigned(FOnFilterRow) then
    Result := FOnFilterRow(Self, ARow, AVersion);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechFilter.SetExpression(const AValue: String);
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechFilter.SetOptions(const AValue: TADExpressionOptions);
begin
  if FOptions <> AValue then begin
    FOptions := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechFilter.SetOnFilterRow(const AValue: TADFilterRowEvent);
begin
  if (TMethod(AValue).Code <> TMethod(FOnFilterRow).Code) or
     (TMethod(AValue).Data <> TMethod(FOnFilterRow).Data) then begin
    FOnFilterRow := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechFilter.InternalLoadFromStorage(AStorage: TADStorage);
var
  eOpt: TADExpressionOption;
  eOpts: TADExpressionOptions;
begin
  inherited InternalLoadFromStorage(AStorage);
  Expression := AStorage.ReadString('Expression', '');
  eOpts := [];
  for eOpt := Low(TADExpressionOption) to High(TADExpressionOption) do
    if AStorage.ReadBoolean(Copy(GetEnumName(TypeInfo(TADExpressionOption),
                            Integer(eOpt)), 3, MAXINT), False) then
      Include(eOpts, eOpt);
  Options := eOpts;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechFilter.InternalSaveToStorage(AStorage: TADStorage);
var
  eOpt: TADExpressionOption;
begin
  inherited InternalLoadFromStorage(AStorage);
  AStorage.WriteString('Expression', Expression, '');
  for eOpt := Low(TADExpressionOption) to High(TADExpressionOption) do
    if eOpt in Options then
      AStorage.WriteBoolean(Copy(GetEnumName(TypeInfo(TADExpressionOption),
        Integer(eOpt)), 3, MAXINT), True, False);
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechError                                                            -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechError.Create;
begin
  inherited Create;
  FKinds := [mkFilter];
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechError.CreateErr(ADummy: Integer);
begin
  Create;
  Active := True;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechError.AcceptRow(ARow: TADDatSRow; AVersion:
  TADDatSRowVersion): Boolean;
begin
  Result := ARow.HasErrors;
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechDetails                                                          -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechDetails.Create(
  AParentRel: TADDatSRelation; AParentRow: TADDatSRow);
begin
  Create;
  ParentRelation := AParentRel;
  ParentRow := AParentRow;
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDetails.Assign(AObj: TADDatSObject);
var
  oManager: TADDatSManager;
begin
  if AObj is TADDatSMechDetails then begin
    oManager := Manager;
    if oManager = TADDatSMechDetails(AObj).Manager then
      ParentRelation := TADDatSMechDetails(AObj).ParentRelation
    else
      ParentRelation := oManager.Relations.RelationByName(
        TADDatSMechDetails(AObj).ParentRelation.Name);
    if (TADDatSMechDetails(AObj).ParentRow <> nil) and
       (TADDatSMechDetails(AObj).ParentRow.Table <> Table) then
      ParentRow := TADDatSMechDetails(AObj).ParentRow
    else
      ParentRow := nil;
  end;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechDetails.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := ParentRelation = TADDatSMechDetails(AObj).ParentRelation;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechDetails.GetActualActive: Boolean;
begin
  Result := inherited GetActualActive and
    (ParentRelation <> nil);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechDetails.NoRangeNoRecords: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDetails.DoActiveChanged;
var
  i: Integer;
begin
  if ActualActive then begin
    FBottom := ParentRow;
    FTop := ParentRow;
    FTopColumnList := ParentRelation.FParentColumns;
    FBottomColumnList := ParentRelation.FParentColumns;
    FSortMech := nil;
  end
  else begin
    FBottom := nil;
    FTop := nil;
    FTopColumnList := nil;
    FBottomColumnList := nil;
    FSortMech := nil;
  end;
  inherited DoActiveChanged;
  if ActualActive and (SortMech <> nil) then
    if SortMech.GetSortColumnList.Count <> ParentRelation.FChildColumns.Count then
      FSortMech := nil
    else
      for i := 0 to SortMech.GetSortColumnList.Count - 1 do
        if SortMech.GetSortColumnList.ItemsI[i] <> ParentRelation.FChildColumns.ItemsI[i] then begin
          FSortMech := nil;
          Break;
        end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDetails.SetParentRelation(const AValue: TADDatSRelation);
begin
  if FParentRelation <> AValue then begin
    FParentRelation := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDetails.SetParentRow(const AValue: TADDatSRow);
begin
  if FParentRow <> AValue then begin
    FParentRow := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDetails.ResolveReferences(const AName, AValue: String);
begin
  if SameText(AName, 'ParentRelation') then
    ParentRelation := Manager.Relations.RelationByName(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDetails.InternalLoadFromStorage(AStorage: TADStorage);
begin
  inherited InternalLoadFromStorage(AStorage);
  AStorage.DeferAction('ParentRelation',
    AStorage.ReadString('ParentRelation', ''), ResolveReferences);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechDetails.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  if ParentRelation <> nil then
    AStorage.WriteString('ParentRelation', ParentRelation.Name, '');
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechChilds                                                           -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechChilds.Create;
begin
  inherited Create;
  FKinds := [mkFilter, mkHasList];
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechChilds.Create(AParentRow: TADDatSRow);
begin
  Create;
  ParentRow := AParentRow;
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechChilds.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechChilds then
    if (TADDatSMechChilds(AObj).ParentRow <> nil) and
       (TADDatSMechChilds(AObj).ParentRow.Table <> Table) then
      ParentRow := TADDatSMechChilds(AObj).ParentRow
    else
      ParentRow := nil;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechChilds.SetParentRow(const AValue: TADDatSRow);
begin
  if FParentRow <> AValue then begin
    FParentRow := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechChilds.DoActiveChanged;
var
  oRel: TADDatSRelation;
begin
  if ActualActive and (ParentRow <> nil) then begin
    oRel := Manager.Relations.FindRelation(ParentRow.Table, Table, True);
    if oRel = nil then
      Active := False
    else begin
      FRefCol := oRel.FParentColumns.ItemsI[0].Index;
      FRefColType := oRel.ParentTable.Columns.ItemsI[FRefCol].DataType;
    end;
  end
  else begin
    FRefCol := -1;
    FRefColType := dtUnknown;
  end;
  if ActualActive and (FRefColType in [dtRowRef, dtArrayRef]) then
    FRefRow := TADDatSNestedRowList.CreateForRow(nil)
  else
    ADFreeAndNil(FRefRow);
  inherited DoActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechChilds.GetRowsRange(var ARowList: TADDatSRowListBase;
  out ABeginInd, AEndInd: Integer): Boolean;
var
  oRow: TADDatSRow;
begin
  if ParentRow = nil then
    AEndInd := -1
  else begin
    case FRefColType of
    dtRowSetRef, dtCursorRef:
      ARowList := ParentRow.NestedRows[FRefCol];
    dtRowRef, dtArrayRef:
      begin
        FRefRow.Clear;
        oRow := ParentRow.NestedRow[FRefCol];
        if oRow <> nil then
          FRefRow.Add(oRow);
        ARowList := FRefRow;
      end;
    end;
    AEndInd := ARowList.Count - 1;
  end;
  ABeginInd := 0;
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechChilds.AcceptRow(ARow: TADDatSRow;
  AVersion: TADDatSRowVersion): Boolean;
begin
  Result := False;
  if ParentRow <> nil then
    case FRefColType of
    dtRowSetRef, dtCursorRef:
      Result := (ParentRow.NestedRows[FRefCol].ContainsObj(ARow));
    dtRowRef, dtArrayRef:
      Result := (ParentRow.NestedRow[FRefCol] = ARow);
    end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechMaster                                                           -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechMaster.Create(AChildRel: TADDatSRelation;
  AChildRow: TADDatSRow);
begin
  inherited Create;
  ChildRelation := AChildRel;
  ChildRow := AChildRow;
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechMaster.Assign(AObj: TADDatSObject);
var
  oManager: TADDatSManager;
begin
  if AObj is TADDatSMechMaster then begin
    oManager := Manager;
    if oManager = TADDatSMechMaster(AObj).Manager then
      ChildRelation := TADDatSMechMaster(AObj).ChildRelation
    else
      ChildRelation := oManager.Relations.RelationByName(
        TADDatSMechMaster(AObj).ChildRelation.Name);
    if (TADDatSMechMaster(AObj).ChildRow <> nil) and
       (TADDatSMechMaster(AObj).ChildRow.Table <> Table) then
      ChildRow := TADDatSMechMaster(AObj).ChildRow
    else
      ChildRow := nil;
  end;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechMaster.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := ChildRelation = TADDatSMechMaster(AObj).ChildRelation;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechMaster.GetActualActive: Boolean;
begin
  Result := inherited GetActualActive and
    (ChildRelation <> nil);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechMaster.NoRangeNoRecords: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechMaster.DoActiveChanged;
var
  i: Integer;
begin
  if ActualActive then begin
    FBottom := ChildRow;
    FTop := ChildRow;
    FTopColumnList := ChildRelation.FChildColumns;
    FBottomColumnList := ChildRelation.FChildColumns;
    FSortMech := nil;
  end
  else begin
    FBottom := nil;
    FTop := nil;
    FTopColumnList := nil;
    FBottomColumnList := nil;
    FSortMech := nil;
  end;
  inherited DoActiveChanged;
  if ActualActive and (SortMech <> nil) then
    if SortMech.GetSortColumnList.Count <> ChildRelation.FParentColumns.Count then
      FSortMech := nil
    else
      for i := 0 to SortMech.GetSortColumnList.Count - 1 do
        if SortMech.GetSortColumnList.ItemsI[i] <> ChildRelation.FParentColumns.ItemsI[i] then begin
          FSortMech := nil;
          Break;
        end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechMaster.SetChildRelation(const AValue: TADDatSRelation);
begin
  if FChildRelation <> AValue then begin
    FChildRelation := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechMaster.SetChildRow(const AValue: TADDatSRow);
begin
  if FChildRow <> AValue then begin
    FChildRow := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechMaster.ResolveReferences(const AName, AValue: String);
begin
  if SameText(AName, 'ChildRelation') then
    ChildRelation := Manager.Relations.RelationByName(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechMaster.InternalLoadFromStorage(AStorage: TADStorage);
begin
  inherited InternalLoadFromStorage(AStorage);
  AStorage.DeferAction('ChildRelation',
    AStorage.ReadString('ChildRelation', ''), ResolveReferences);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechMaster.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  if ChildRelation <> nil then
    AStorage.WriteString('ChildRelation', ChildRelation.Name, '');
end;

{-------------------------------------------------------------------------------}
{- TADDatSMechParent                                                           -}
{-------------------------------------------------------------------------------}
constructor TADDatSMechParent.Create;
begin
  inherited Create;
  FKinds := [mkFilter, mkHasRow];
end;

{-------------------------------------------------------------------------------}
constructor TADDatSMechParent.Create(AChildRow: TADDatSRow);
begin
  Create;
  ChildRow := AChildRow;
  Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechParent.Assign(AObj: TADDatSObject);
begin
  if AObj is TADDatSMechParent then
    if (TADDatSMechParent(AObj).ChildRow <> nil) and
       (TADDatSMechParent(AObj).ChildRow.Table <> Table) then
      ChildRow := TADDatSMechParent(AObj).ChildRow
    else
      ChildRow := nil;
  inherited Assign(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSMechParent.GetActualActive: Boolean;
begin
  Result := inherited GetActualActive and (ChildRow <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechParent.SetChildRow(const AValue: TADDatSRow);
begin
  if FChildRow <> AValue then begin
    FChildRow := AValue;
    Active := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSMechParent.DoActiveChanged;
begin
  if ActualActive then begin
    FParentRow := TADDatSRowListBase.Create;
    FParentRow.Add(ChildRow.ParentRow);
  end
  else
    ADFreeAndNil(FParentRow);
  inherited DoActiveChanged;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechParent.GetRowsRange(var ARowList: TADDatSRowListBase;
  out ABeginInd, AEndInd: Integer): Boolean;
begin
  ARowList := FParentRow;
  AEndInd := 0;
  ABeginInd := 0;
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADDatSMechParent.AcceptRow(ARow: TADDatSRow;
  AVersion: TADDatSRowVersion): Boolean;
begin
  Result := (ARow = FParentRow.ItemsI[0]);
end;

{-------------------------------------------------------------------------------}
{- TADDatSRow                                                                  -}
{-------------------------------------------------------------------------------}
constructor TADDatSRow.CreateForTable(ATable: TADDatSTable; ASetToDefaults: Boolean);
begin
  ASSERT(ATable <> nil);
  inherited Create;
  FOwner := ATable;
  FTable := ATable;
  FRowID := $FFFFFFFF;
  FChangeNumber := $FFFFFFFF;
  FRowState := rsDetached;
  FRowPriorState := rsDetached;
  FpProposed := AllocBuffer;
  SetFetchedMarks(not (FTable.DataHandleMode in [lmHavyFetching, lmFetching, lmRefreshing]));
  AllocInvariants;
  if ASetToDefaults then
    AssignDefaults;
end;

{-------------------------------------------------------------------------------}
class function TADDatSRow.CreateInstance(ATable: TADDatSTable;
  ASetToDefaults: Boolean): TADDatSRow;
var
  p: Pointer;
  oCols: TADDatSColumnList;
begin
  ASSERT(ATable <> nil);
  oCols := ATable.Columns;
  oCols.CheckUpdateLayout(InstanceSize);
  GetMem(p, oCols.RowsInstSize);
  Result := TADDatSRow(InitInstance(p));
{$IFDEF AUTOREFCOUNT}
  Result.FRefCount := 1;
{$ENDIF}
  Result.CreateForTable(ATable, ASetToDefaults);
end;

{-------------------------------------------------------------------------------}
destructor TADDatSRow.Destroy;
begin
  CancelEdit;
  FRowPriorState := RowState;
  FRowState := rsDestroying;
  if Table.Columns.ParentRowRefCol <> -1 then
    ParentRow := nil;
  ClearNestedErrors;
  SetRowError(nil);
  DBUnlock;
  FreeInvariants;
  inherited Destroy;
  // If to move following lines before inherited Destroy, then
  // if table has sorted views and user is doing oRow.Free, then
  // binary search to delete row from view will fail, because row
  // already does not have the values
  FreeBuffer(FpCurrent);
  FreeBuffer(FpOriginal);
  FreeBuffer(FpProposed);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CheckNoInfo;
begin
  if (FExtraInfo^.FRowException = nil) and (FExtraInfo^.FCheckColumn = -1) and
     (FExtraInfo^.FLockID = 0) then begin
    FreeMem(FExtraInfo);
    FExtraInfo := nil;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetRowInfo(AForce: Boolean): Pointer;
begin
  if (FExtraInfo = nil) and AForce then begin
    GetMem(FExtraInfo, SizeOf(TADDatSRowExtraInfo));
    ADFillChar(FExtraInfo^, SizeOf(TADDatSRowExtraInfo), 0);
    FExtraInfo^.FCheckColumn := -1;
  end;
  Result := FExtraInfo;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.AllocBuffer: PByte;
begin
  ASSERT(Table.Columns.StorageSize <> 0);
  GetMem(Result, Table.Columns.StorageSize);
  ADFillChar(Result^, Table.Columns.StorageSize, 0);
  // We does't need the following call, if to follow the rule - memory area
  // filled by the zero's is an empty value of any data type.
  // InternalInitComplexData(Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.FreeBuffer(var ApBuffer: PByte);
begin
  if ApBuffer <> nil then begin
    InternalInitComplexData(ApBuffer);
    FreeMem(ApBuffer);
    ApBuffer := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.AllocInvariants;
var
  oCols: TADDatSColumnList;
  i: Integer;
begin
  oCols := Table.Columns;
  if oCols.FInvariants <> 0 then
    for i := 0 to oCols.Count - 1 do
      case oCols.ItemsI[i].DataType of
      dtRowSetRef,
      dtCursorRef:     SetInvariantObject(i, TADDatSNestedRowList.CreateForRow(Self));
      dtRowRef,
      dtArrayRef,
      dtParentRowRef:  SetInvariantObject(i, nil);
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.FreeInvariants;
var
  oCols: TADDatSColumnList;
  oNestedRowList: TADDatSNestedRowList;
  oNestedRow: TADDatSRow;
  i, j: Integer;
begin
  oCols := Table.Columns;
  if oCols.FInvariants <> 0 then
    for i := 0 to oCols.Count - 1 do
      case oCols.ItemsI[i].DataType of
      dtRowSetRef, dtCursorRef:
        begin
          oNestedRowList := NestedRows[i];
          for j := oNestedRowList.Count - 1 downto 0 do begin
            oNestedRow := oNestedRowList.ItemsI[j];
            if oNestedRow <> nil then begin
              oNestedRow.ParentRow := nil;
              ADFree(oNestedRow);
            end;
          end;
          ADFree(oNestedRowList);
          SetInvariantObject(i, nil);
        end;
      dtRowRef, dtArrayRef:
        begin
          oNestedRow := NestedRow[i];
          if oNestedRow <> nil then begin
            oNestedRow.ParentRow := nil;
            ADFree(oNestedRow);
          end;
          SetInvariantObject(i, nil);
        end;
      dtParentRowRef:
        SetInvariantObject(i, nil);
      end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetInvariantObject(AColumn: Integer): TADDatSObject;
var
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  ASSERT((oCols.ItemsI[AColumn].DataType in C_AD_InvariantDataTypes) and
         (oCols.FInvariantOffset <> -1));
  Result := TADDatSObject(PLongWord(PADByteString(Self) + oCols.FInvariantOffset +
    SizeOf(LongWord) * oCols.FInvariantMap[AColumn])^);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetInvariantObject(AColumn: Integer; AObj: TADDatSObject);
var
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  ASSERT((oCols.ItemsI[AColumn].DataType in C_AD_InvariantDataTypes) and
         ((oCols.FInvariantOffset <> -1)));
  PLongWord(PADByteString(Self) + oCols.FInvariantOffset +
    SizeOf(LongWord) * oCols.FInvariantMap[AColumn])^ := LongWord(AObj);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetFetchedMarks(AOn: Boolean);
var
  C: Byte;
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  if AOn then
    C := $FF
  else
    C := 0;
  ADFillChar((PADByteString(Self) + oCols.FFetchedOffset)^, oCols.FFetchedSize, C);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.InternalAssignDefaults(ACols: TADDatSColumnList);
var
  i: Integer;
  pVal: Pointer;
  i8Val: Shortint;
  i16Val: Smallint;
  i32Val: Integer;
  i64Val: Int64;
  sVal: Single;
  dVal: Double;
  eVal: Extended;
  bcdVal: TADBcd;
{$IFNDEF AnyDAC_D6Base}
  cVal: Currency;
{$ENDIF}
  eTmpPriorRowState: TADDatSRowState;
  oCol: TADDatSColumn;
begin
  eTmpPriorRowState := FRowPriorState;
  FRowPriorState := RowState;
  FRowState := rsInitializing;
  try
    for i := 0 to ACols.Count - 1 do begin
      oCol := ACols.ItemsI[i];
      if oCol.AutoIncrement then begin
        ACols.FAutoIncs[i] := ACols.FAutoIncs[i] + oCol.AutoIncrementStep;
        case oCol.DataType of
        dtByte,
        dtSByte:
          begin
            i8Val := ShortInt(ACols.FAutoIncs[i]);
            pVal := @i8Val;
          end;
        dtUInt16,
        dtInt16:
          begin
            i16Val := SmallInt(ACols.FAutoIncs[i]);
            pVal := @i16Val;
          end;
        dtUInt32,
        dtInt32:
          begin
            i32Val := ACols.FAutoIncs[i];
            pVal := @i32Val;
          end;
        dtUInt64,
        dtInt64:
          begin
            i64Val := ACols.FAutoIncs[i];
            pVal := @i64Val;
          end;
        dtSingle:
          begin
            sVal := ACols.FAutoIncs[i];
            pVal := @sVal;
          end;
        dtDouble:
          begin
            dVal := ACols.FAutoIncs[i];
            pVal := @dVal;
          end;
        dtExtended:
          begin
            eVal := ACols.FAutoIncs[i];
            pVal := @eVal;
          end;
        dtBCD,
        dtFmtBCD:
          begin
{$IFDEF AnyDAC_D6Base}
            bcdVal := VarToBcd(ACols.FAutoIncs[i]);
            pVal := @bcdVal;
{$ELSE}
            cVal := ACols.FAutoIncs[i];
            CurrToBCD(cVal, bcdVal);
            pVal := @bcdVal;
{$ENDIF}
          end;
        else
          pVal := nil;
        end;
        SetData(i, pVal, 0);
      end;
    end;
  finally
    FRowState := RowPriorState;
    FRowPriorState := eTmpPriorRowState;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.AssignDefaults;
var
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  if not (ctDefs in oCols.FHasThings) or
     (Table.DataHandleMode in [lmHavyFetching, lmFetching, lmRefreshing]) then
    Exit;
  InternalAssignDefaults(oCols);
  if ctExps in oCols.FHasThings then
    InternalCalculateColumns(True, oCols);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.BeginEdit;

  procedure ErrorCantEdit;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantBeginEdit, []);
  end;

var
  oList: TADDatSTableRowList;
  pCurBuff: PByte;
begin
  if not (RowState in [rsInserted, rsModified, rsUnchanged]) then
    ErrorCantEdit;
  oList := RowList;
  if oList <> nil then begin
    FpProposed := AllocBuffer;
    pCurBuff := GetBuffer(rvCurrent);
    if pCurBuff <> nil then
      CopyBuffer(FpProposed, pCurBuff);
    FRowPriorState := RowState;
    FRowState := rsEditing;
    Notify(snRowStateChanged, srDataChange, TADNativeInt(Self), 0);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CancelEdit;
begin
  if RowState = rsEditing then begin
    CancelNestedRows;
    FreeBuffer(FpProposed);
    FRowState := RowPriorState;
    Notify(snRowStateChanged, srDataChange, TADNativeInt(Self), 0);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.SkipConstraintCheck: Boolean;
var
  oManager: TADDatSManager;
begin
  Result := not Table.EnforceConstraints or (Owner = nil) or
    not (Table.DataHandleMode in [lmStandard, lmRefreshing]) or
    (RowState = rsChecking);
  if not Result then begin
    oManager := Manager;
    Result := (oManager <> nil) and not oManager.EnforceConstraints;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CascadeAcceptReject(AAccept: Boolean);
var
  oTab, oPKTab: TADDatSTable;
  oManager: TADDatSManager;
  oCons: TADDatSConstraintBase;
  i, j: Integer;
  eProposedState: TADDatSRowState;
begin
  if SkipConstraintCheck then
    Exit;
  oTab := Table;
  oManager := Manager;
  if AAccept then
    eProposedState := rsUnchanged
  else
    eProposedState := rsDestroying;
  if (oManager <> nil) and oManager.EnforceConstraints then
    for i := 0 to oManager.Tables.Count - 1 do begin
      oPKTab := oManager.Tables.ItemsI[i];
      if oPKTab.EnforceConstraints then
        for j := 0 to oPKTab.Constraints.Count - 1 do begin
          oCons := oPKTab.Constraints.ItemsI[j];
          if (oCons is TADDatSForeignKeyConstraint) and
             (TADDatSForeignKeyConstraint(oCons).RelatedTable = oTab) then
            oCons.Check(Self, eProposedState, ctAtEditEnd);
        end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CheckRowConstraints(AProposedState: TADDatSRowState);
var
  oTab, oPKTab: TADDatSTable;
  oManager: TADDatSManager;
  oCons: TADDatSConstraintBase;
  oCol: TADDatSColumn;
  i, j: Integer;
  pBuff: PByte;
  eTempState, eTempPriorState: TADDatSRowState;

  procedure ErrorNotNull;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowColMBNotNull, [oCol.Name]);
  end;

begin
  if SkipConstraintCheck then
    Exit;
  eTempState := RowState;
  eTempPriorState := RowPriorState;
  FRowPriorState := FRowState;
  FRowState := rsChecking;
  try
    ConstrainChildRow(AProposedState);
    ConstrainParentRow(AProposedState);
    oTab := Table;
    oManager := Manager;
    if oTab.EnforceConstraints and ((oManager = nil) or oManager.EnforceConstraints) then begin
      if oTab.CheckNotNull and (AProposedState in [rsInserted, rsModified]) then begin
        pBuff := GetBuffer(rvDefault);
        for i := 0 to oTab.Columns.Count - 1 do begin
          oCol := oTab.Columns.ItemsI[i];
          if not oCol.AllowDBNull and not oCol.ReadOnly and GetIsNull(pBuff, i) then
            ErrorNotNull;
        end;
      end;
      oTab.Constraints.Check(Self, AProposedState, ctAtEditEnd);
    end;
    if (oManager <> nil) and oManager.EnforceConstraints then
      for i := 0 to oManager.Tables.Count - 1 do begin
        oPKTab := oManager.Tables.ItemsI[i];
        if oPKTab.EnforceConstraints then
          for j := 0 to oPKTab.Constraints.Count - 1 do begin
            oCons := oPKTab.Constraints.ItemsI[j];
            if (oCons is TADDatSForeignKeyConstraint) and
               (TADDatSForeignKeyConstraint(oCons).RelatedTable = oTab) then
              oCons.Check(Self, AProposedState, ctAtEditEnd);
          end;
      end;
  finally
    FRowState := eTempState;
    FRowPriorState := eTempPriorState;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CheckColumnConstraints;
var
  oTab: TADDatSTable;
  oManager: TADDatSManager;
  eTempState, eTempPriorState: TADDatSRowState;
begin
  if SkipConstraintCheck then
    Exit;
  eTempState := RowState;
  eTempPriorState := RowPriorState;
  FRowPriorState := FRowState;
  FRowState := rsChecking;
  try
    oTab := Table;
    oManager := Manager;
    if oTab.EnforceConstraints and ((oManager = nil) or oManager.EnforceConstraints) then
      oTab.Constraints.Check(Self, rsEditing, ctAtColumnChange);
  finally
    FRowState := eTempState;
    FRowPriorState := eTempPriorState;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.InternalInitComplexData(ABuffer: PByte);
var
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  i: Integer;
begin
  oCols := Table.Columns;
  if ctComp in oCols.FHasThings then
    for i := 0 to oCols.Count - 1 do begin
      oCol := oCols.ItemsI[i];
      if caBlobData in oCol.Attributes then
        SetBlobData(ABuffer, i, nil, 0)
      else if oCol.DataType = dtObject then
        PADDataStoredObject(PADByteString(ABuffer) + oCols.DataOffsets[i])^ := nil;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CleanupBuffer(ABuffer: PByte);
begin
  InternalInitComplexData(ABuffer);
  ADFillChar(ABuffer^, Table.Columns.StorageSize, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.Clear(ASetColsToDefaults: Boolean);
var
  lWasDetached: Boolean;
begin
  lWasDetached := (RowState in [rsDetached, rsInitializing]) or
    (RowState in [rsForceWrite, rsDestroying]) and (RowPriorState = rsDetached);
  LockNotification;
  try
    if RowState = rsEditing then
      CancelEdit;
    UnregisterChange;
    if RowState <> rsForceWrite then
      FRowPriorState := rsDetached;
    if Owner is TADDatSTable then begin
      if RowState <> rsForceWrite then
        FRowState := rsDetached;
      FreeBuffer(FpCurrent);
      if FpProposed <> nil then
        CleanupBuffer(FpProposed)
      else
        FpProposed := AllocBuffer;
    end
    else begin
      if RowState <> rsForceWrite then
        FRowState := rsInserted;
      FreeBuffer(FpProposed);
      if FpCurrent <> nil then
        CleanupBuffer(FpCurrent)
      else
        FpCurrent := AllocBuffer;
    end;
    FreeBuffer(FpOriginal);
    ClearNestedRows;
    ClearErrors;
    SetFetchedMarks(True);
    if ASetColsToDefaults then
      AssignDefaults;
  finally
    UnlockNotification;
    if not lWasDetached then
      Notify(snRowStateChanged, srDataChange, TADNativeInt(Self), 0);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.ClearErrors;
begin
  ClearNestedErrors;
  if SetRowError(nil) then
    Notify(snRowErrorStateChanged, srDataChange, TADNativeInt(Self), 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.Erase;
var
  i: Integer;
  lFetching: Boolean;
begin
  lFetching := Table.DataHandleMode in [lmHavyFetching, lmFetching, lmRefreshing];
  for i := 0 to Table.Columns.Count - 1 do
    if not lFetching or Fetched[i] then
      SetData(i, nil, 0);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CompareColumnVersions(AColumn: Integer;
  AVersion1, AVersion2: TADDatSRowVersion): Boolean;
var
  pBuff1, pBuff2: Pointer;
  iLen1, iLen2: LongWord;
  lIsNull1, lIsNull2: Boolean;
  lIsEmpty1, lIsEmpty2: Boolean;
begin
  iLen1 := 0;
  iLen2 := 0;
  pBuff1 := nil;
  pBuff2 := nil;
  lIsNull1 := not GetData(AColumn, AVersion1, pBuff1, 0, iLen1, False);
  lIsNull2 := not GetData(AColumn, AVersion2, pBuff2, 0, iLen2, False);
  lIsEmpty1 := (pBuff1 = nil) and (iLen1 = 0);
  lIsEmpty2 := (pBuff2 = nil) and (iLen2 = 0);
  if lIsNull1 and lIsNull2 or lIsEmpty1 and lIsEmpty2 then
    Result := True
  else if not lIsNull1 and not lIsNull2 and not lIsEmpty1 and not lIsEmpty2 then
    Result := (CompareData(AColumn, pBuff1, iLen1, pBuff2, iLen2, []) = 0)
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CompareColumnsVersions(AColumns: TADDatSColumnSublist;
  AVersion1, AVersion2: TADDatSRowVersion): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 0 to AColumns.Count - 1 do
    if not CompareColumnVersions(AColumns.ItemsI[i].Index, AVersion1, AVersion2) then begin
      Result := False;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CompareData(AColumn: Integer; ABuff1: Pointer;
  ADataLen1: Integer; ABuff2: Pointer; ADataLen2: Integer;
  AOptions: TADCompareDataOptions): Integer;

  procedure ErrorColIsNotSearch;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColIsNotSearchable,
      [Table.Columns.ItemsI[AColumn].Name]);
  end;

  function GetBCDDiff(ABuff1, ABuff2: Pointer): Extended;
  var
    buff: array[0 .. 100] of Char;
    iSz: Integer;
    s1, s2: String;
  begin
    iSz := 0;
    ADBCD2Str(buff, iSz, PADBcd(ABuff1)^, {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator);
    SetString(s1, buff, iSz);
    ADBCD2Str(buff, iSz, PADBcd(ABuff2)^, {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator);
    SetString(s2, buff, iSz);
    Result := ADStr2Float(s1, {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator) - ADStr2Float(s2, {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator);
  end;

var
  i: Integer;
  sDiff: Single;
  dDiff, dPrec: Double;
  eDiff: Extended;
  iDiff, iPrec: Integer;
{$IFNDEF AnyDAC_D6Base}
  crVal1, crVal2: Currency;
{$ENDIF}
  E: Extended;
  oCol: TADDatSColumn;
begin
  ASSERT((Self <> nil) and (ABuff1 <> nil) and (ABuff2 <> nil));
  oCol := Table.Columns.ItemsI[AColumn];
  case oCol.DataType of
  dtBoolean:
    if PWordBool(ABuff1)^ then
      if PWordBool(ABuff2)^ then
        Result := 0
      else
        Result := 1
    else
      if PWordBool(ABuff2)^ then
        Result := -1
      else
        Result := 0;
  dtSByte:
    if PShortInt(ABuff1)^ > PShortInt(ABuff2)^ then
      Result := 1
    else if PShortInt(ABuff1)^ < PShortInt(ABuff2)^ then
      Result := -1
    else
      Result := 0;
  dtInt16:
    if PSmallInt(ABuff1)^ > PSmallInt(ABuff2)^ then
      Result := 1
    else if PSmallInt(ABuff1)^ < PSmallInt(ABuff2)^ then
      Result := -1
    else
      Result := 0;
  dtInt32:
    if PInteger(ABuff1)^ > PInteger(ABuff2)^ then
      Result := 1
    else if PInteger(ABuff1)^ < PInteger(ABuff2)^ then
      Result := -1
    else
      Result := 0;
  dtInt64:
    if PInt64(ABuff1)^ > PInt64(ABuff2)^ then
      Result := 1
    else if PInt64(ABuff1)^ < PInt64(ABuff2)^ then
      Result := -1
    else
      Result := 0;
  dtByte:
    if PByte(ABuff1)^ > PByte(ABuff2)^ then
      Result := 1
    else if PByte(ABuff1)^ < PByte(ABuff2)^ then
      Result := -1
    else
      Result := 0;
  dtUInt16:
    if PWord(ABuff1)^ > PWord(ABuff2)^ then
      Result := 1
    else if PWord(ABuff1)^ < PWord(ABuff2)^ then
      Result := -1
    else
      Result := 0;
  dtUInt32:
    begin
      if PLongWord(ABuff1)^ > PLongWord(ABuff2)^ then
        Result := 1
      else if PLongWord(ABuff1)^ < PLongWord(ABuff2)^ then
        Result := -1
      else
        Result := 0;
    end;
  dtUInt64:
    Result := ADCompareUInt64(PUInt64(ABuff1)^, PUInt64(ABuff2)^);
  dtSingle:
    begin
      sDiff := PSingle(ABuff1)^ - PSingle(ABuff2)^;
      if sDiff > 0.00001 then
        Result := 1
      else if sDiff < -0.00001 then
        Result := -1
      else
        Result := 0;
    end;
  dtDouble:
    begin
      dDiff := PDouble(ABuff1)^ - PDouble(ABuff2)^;
      if dDiff > 0.0000000000001 then
        Result := 1
      else if dDiff < -0.0000000000001 then
        Result := -1
      else
        Result := 0;
    end;
  dtExtended:
    begin
      eDiff := PExtended(ABuff1)^ - PExtended(ABuff2)^;
      if eDiff > 0.0000000000001 then
        Result := 1
      else if eDiff < -0.0000000000001 then
        Result := -1
      else
        Result := 0;
    end;
  dtCurrency:
    if PCurrency(ABuff1)^ > PCurrency(ABuff2)^ then
      Result := 1
    else if PCurrency(ABuff1)^ < PCurrency(ABuff2)^ then
      Result := -1
    else
      Result := 0;
  dtBCD,
  dtFmtBCD:
    begin
{$IFNDEF AnyDAC_FPC}
      // FPC BcdCompare fails when one TBcd is zero with SignSpecialPlaces=4
{$IFDEF AnyDAC_D6Base}
      Result := BcdCompare(PADBcd(ABuff1)^, PADBcd(ABuff2)^);
      if Result > 0 then
        Result := 1
      else if Result < 0 then
        Result := -1
{$ELSE}
      crVal1 := 0.0;
      crVal2 := 0.0;
      if BCDToCurr(PADBcd(ABuff1)^, crVal1) and BCDToCurr(PADBcd(ABuff2)^, crVal2) then
        if crVal1 > crVal2 then
          Result := 1
        else if crVal1 < crVal2 then
          Result := -1
        else
          Result := 0
{$ENDIF}
      else
{$ENDIF}
      begin
        E := GetBCDDiff(ABuff1, ABuff2);
        if E > 0.0000000000001 then
          Result := 1
        else if E < -0.0000000000001 then
          Result := -1
        else
          Result := 0;
      end;
    end;
  dtDate,
  dtTime:
    begin
      iDiff := PLongint(ABuff1)^ - PLongint(ABuff2)^;
      if oCol.Scale > 0 then
        iPrec := oCol.Scale
      else
        iPrec := 0;
      if iDiff = 0 then
        Result := 0
      else if iDiff >= iPrec then
        Result := 1
      else if iDiff <= -iPrec then
        Result := -1
      else
        Result := 0;
    end;
  dtDateTime:
    begin
      dDiff := PADDateTimeData(ABuff1)^.DateTime - PADDateTimeData(ABuff2)^.DateTime;
      if oCol.Scale > 0 then
        dPrec := oCol.Scale
      else
        dPrec := 0.1;
      if dDiff = 0 then
        Result := 0
      else if dDiff >= dPrec then
        Result := 1
      else if dDiff <= -dPrec then
        Result := -1
      else
        Result := 0;
    end;
  dtDateTimeStamp:
    if PADSQLTimeStamp(ABuff1)^.Year > PADSQLTimeStamp(ABuff2)^.Year then
      Result := 1
    else if PADSQLTimeStamp(ABuff1)^.Year < PADSQLTimeStamp(ABuff2)^.Year then
      Result := -1
    else if PADSQLTimeStamp(ABuff1)^.Month > PADSQLTimeStamp(ABuff2)^.Month then
      Result := 1
    else if PADSQLTimeStamp(ABuff1)^.Month < PADSQLTimeStamp(ABuff2)^.Month then
      Result := -1
    else if PADSQLTimeStamp(ABuff1)^.Day > PADSQLTimeStamp(ABuff2)^.Day then
      Result := 1
    else if PADSQLTimeStamp(ABuff1)^.Day < PADSQLTimeStamp(ABuff2)^.Day then
      Result := -1
    else if PADSQLTimeStamp(ABuff1)^.Hour > PADSQLTimeStamp(ABuff2)^.Hour then
      Result := 1
    else if PADSQLTimeStamp(ABuff1)^.Hour < PADSQLTimeStamp(ABuff2)^.Hour then
      Result := -1
    else if PADSQLTimeStamp(ABuff1)^.Minute > PADSQLTimeStamp(ABuff2)^.Minute then
      Result := 1
    else if PADSQLTimeStamp(ABuff1)^.Minute < PADSQLTimeStamp(ABuff2)^.Minute then
      Result := -1
    else if (oCol.Scale <= 60000) and (PADSQLTimeStamp(ABuff1)^.Second > PADSQLTimeStamp(ABuff2)^.Second) then
      Result := 1
    else if (oCol.Scale <= 60000) and (PADSQLTimeStamp(ABuff1)^.Second < PADSQLTimeStamp(ABuff2)^.Second) then
      Result := -1
    else if (oCol.Scale <= 1000) and (PADSQLTimeStamp(ABuff1)^.Fractions > PADSQLTimeStamp(ABuff2)^.Fractions) then
      Result := 1
    else if (oCol.Scale <= 1000) and (PADSQLTimeStamp(ABuff1)^.Fractions < PADSQLTimeStamp(ABuff2)^.Fractions) then
      Result := -1
    else
      Result := 0;
  dtTimeIntervalFull,
  dtTimeIntervalYM,
  dtTimeIntervalDS:
    Result := ADSQLTimeIntervalCompare(PADSQLTimeInterval(ABuff1)^, PADSQLTimeInterval(ABuff2)^);
  dtAnsiString,
  dtMemo,
  dtHMemo:
    Result := ADCompareAnsiStr(PADAnsiString(ABuff1), PADAnsiString(ABuff2),
      ADataLen1, ADataLen2, Self.Table.Locale, coNoCase in AOptions,
      coPartial in AOptions, coNoSymbols in AOptions);
  dtWideString,
  dtWideMemo,
  dtWideHMemo,
  dtXML:
    Result := ADCompareWideStr(PWideChar(ABuff1), PWideChar(ABuff2),
      ADataLen1, ADataLen2, Self.Table.Locale, coNoCase in AOptions,
      coPartial in AOptions, coNoSymbols in AOptions);
  dtByteString,
  dtBlob,
  dtHBlob,
  dtHBFile:
    Result := ADCompareByteStr(PADByteString(ABuff1), PADByteString(ABuff2),
      ADataLen1, ADataLen2);
  dtGUID:
    begin
      if PGUID(ABuff1)^.D1 < PGUID(ABuff2)^.D1 then
        Result := -1
      else if PGUID(ABuff1)^.D1 > PGUID(ABuff2)^.D1 then
        Result := 1
      else if PGUID(ABuff1)^.D2 < PGUID(ABuff2)^.D2 then
        Result := -1
      else if PGUID(ABuff1)^.D2 > PGUID(ABuff2)^.D2 then
        Result := 1
      else if PGUID(ABuff1)^.D3 < PGUID(ABuff2)^.D3 then
        Result := -1
      else if PGUID(ABuff1)^.D3 > PGUID(ABuff2)^.D3 then
        Result := 1
      else begin
        Result := 0;
        for i := 0 to 7 do begin
          if PGUID(ABuff1)^.D4[i] < PGUID(ABuff2)^.D4[i] then begin
            Result := -1;
            Break;
          end
          else if PGUID(ABuff1)^.D4[i] > PGUID(ABuff2)^.D4[i] then begin
            Result := 1;
            Break;
          end;
        end;
      end;
    end;
  dtObject:
    Result := PADDataStoredObject(ABuff1)^.Compare(PADDataStoredObject(ABuff2)^, AOptions);
  else
    if not (caSearchable in oCol.Attributes) then
      ErrorColIsNotSearch;
    Result := 0;
  end;
  if coDescending in AOptions then
    Result := - Result;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CompareNulls(AIsNull1, AIsNull2: Boolean; AOptions: TADCompareDataOptions): Integer;
begin
  if not AIsNull1 and AIsNull2 then
    if not (coDescending in AOptions) then
      if coNullFirst in AOptions then
        Result := 1
      else
        Result := -1
    else
      if coDescNullLast in AOptions then
        Result := -1
      else
        Result := 1
  else if AIsNull1 and not AIsNull2 then
    if not (coDescending in AOptions) then
      if coNullFirst in AOptions then
        Result := -1
      else
        Result := 1
    else
      if coDescNullLast in AOptions then
        Result := 1
      else
        Result := -1
  else if coNullsNotEqual in AOptions then
    Result := -1
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
(*
type
  TADDatSRowComparision = class(TObject)
  private
    FRow1, FRow2: TADDatSRow;
    FColumns1, FColumns2: TADDatSColumnSublist;
    FVersion1, FVersion2: TADDatSRowVersion;
    FColumnCount: Integer;
    FDescendingColumns,
    FCaseInsensitiveColumns: TADDatSColumnSublist;
    FOptions: TADCompareDataOptions;
    FCache: TADDatSCompareRowsCache;
  public
    procedure Setup(ARow1: TADDatSRow; AColumns, ADescendingColumns,
      ACaseInsensitiveColumns: TADDatSColumnSublist; AColumnCount: Integer;
      ARow2: TADDatSRow; AColumns2: TADDatSColumnSublist; AVersion: TADDatSRowVersion;
      AOptions: TADCompareDataOptions);
  end;

{ TADDatSRowComparision }

procedure TADDatSRowComparision.Setup(ARow1: TADDatSRow; AColumns, ADescendingColumns,
  ACaseInsensitiveColumns: TADDatSColumnSublist; AColumnCount: Integer;
  ARow2: TADDatSRow; AColumns2: TADDatSColumnSublist;
  AVersion: TADDatSRowVersion; AOptions: TADCompareDataOptions);
begin
  inherited Create;
  FRow1 := ARow1;
  FRow2 := ARow2;
end;
*)

function TADDatSRow.CompareRows(AColumns, ADescendingColumns,
    ACaseInsensitiveColumns: TADDatSColumnSublist; AColumnCount: Integer;
    ARow2: TADDatSRow; AColumns2: TADDatSColumnSublist;
    AVersion: TADDatSRowVersion; AOptions: TADCompareDataOptions;
    var ACache: TADDatSCompareRowsCache): Integer;
  procedure ErrorCantCompareRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCompareRows, []);
  end;
var
  pBuff1, pBuff2: Pointer;
  iLen1, iLen2: LongWord;
  lIsNull1, lIsNull2: Boolean;
  i, iCol1, iCol2: Integer;
  iColCount: Integer;
  eOpts: TADCompareDataOptions;
  oCol1, oCol2: TADDatSColumn;
  pItem: PADDatSCompareRowsCacheItem;
begin
  if (Self = nil) or (ARow2 = nil) or
     (AColumns2 <> nil) and (AColumns = nil) then
    ErrorCantCompareRows;

  Result := 0;
  if AColumnCount = -1 then
    if AColumns = nil then
      iColCount := Table.Columns.Count
    else
      iColCount := AColumns.Count
  else
    iColCount := AColumnCount;
  if AColumns2 <> nil then begin
    if AColumns2.Count < iColCount then
      iColCount := AColumns2.Count;
  end
  else if ARow2.Table.Columns.Count < iColCount then
    iColCount := ARow2.Table.Columns.Count;

  if (coCache in AOptions) and (Length(ACache) = 0) then
    SetLength(ACache, iColCount);

  for i := 0 to iColCount - 1 do begin
    if AColumns = nil then begin
      oCol1 := Table.Columns.ItemsI[i];
      iCol1 := i;
    end
    else begin
      oCol1 := AColumns.ItemsI[i];
      iCol1 := oCol1.Index;
    end;
    if AColumns2 = nil then begin
      oCol2 := ARow2.Table.Columns.ItemsI[iCol1];
      iCol2 := iCol1;
    end
    else begin
      oCol2 := AColumns2.ItemsI[i];
      iCol2 := oCol2.Index;
    end;
    if oCol1.DataType <> oCol2.DataType then
      ErrorCantCompareRows;
    if oCol1.DataType in C_AD_InvariantDataTypes then
      Result := 0
    else begin
      iLen1 := 0;
      pBuff1 := nil;
      iLen2 := 0;
      pBuff2 := nil;
      lIsNull1 := not GetData(iCol1, AVersion, pBuff1, 0, iLen1, False);
      if not (coCache in AOptions) or not ACache[i].FInit then begin
        lIsNull2 := not ARow2.GetData(iCol2, AVersion, pBuff2, 0, iLen2, False);
        eOpts := AOptions;
        if (ADescendingColumns <> nil) and (ADescendingColumns.IndexOf(oCol1) <> -1) then
          Include(eOpts, coDescending);
        if (ACaseInsensitiveColumns <> nil) and (ACaseInsensitiveColumns.IndexOf(oCol1) <> -1) then
          Include(eOpts, coNoCase);
        if (coCache in AOptions) and not ACache[i].FInit then begin
          pItem := @ACache[i];
          pItem^.FIsNull := lIsNull2;
          pItem^.FpBuff := pBuff2;
          pItem^.FLen := iLen2;
          pItem^.FOpts := eOpts;
          pItem^.FInit := True;
        end;
      end
      else begin
        pItem := @ACache[i];
        lIsNull2 := pItem^.FIsNull;
        pBuff2 := pItem^.FpBuff;
        iLen2 := pItem^.FLen;
        eOpts := pItem^.FOpts;
      end;
      if not lIsNull1 and not lIsNull2 then
        Result := CompareData(iCol1, pBuff1, iLen1, pBuff2, iLen2, eOpts)
      else
        Result := CompareNulls(lIsNull1, lIsNull2, eOpts);
    end;
    if Result <> 0 then
      Break;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CompareRows(ARow2: TADDatSRow;
  AVersion: TADDatSRowVersion; AOptions: TADCompareDataOptions): Integer;
begin
  Result := CompareRows(nil, nil, nil, -1, ARow2, nil, AVersion, AOptions, ADEmptyCC);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CompareRowsExp(const AEvaluator: IADStanExpressionEvaluator;
  ARow2: TADDatSRow; AVersion: TADDatSRowVersion; AOptions: TADCompareDataOptions): Integer;
var
  V1, V2: Variant;
  lIsNull1, lIsNull2: Boolean;
  iType1, iType2: Integer;
begin
  ASSERT((Self <> nil) and (AEvaluator <> nil));
  AEvaluator.DataSource.Position := Self;
  V1 := AEvaluator.Evaluate;
  lIsNull1 := VarIsNull(V1) or VarIsEmpty(V1);
  AEvaluator.DataSource.Position := ARow2;
  V2 := AEvaluator.Evaluate;
  lIsNull2 := VarIsNull(V1) or VarIsEmpty(V1);
  if not lIsNull1 and not lIsNull2 then begin
    iType1 := VarType(V1);
    iType2 := VarType(V2);
    Result := 0;
    if (iType1 = iType2) and
       ({$IFDEF AnyDAC_D12} (iType1 = varUString) or {$ENDIF}
        (iType1 = varOleStr) or (iType1 = varString)) then
      case iType1 of
{$IFDEF AnyDAC_D12}
      varUString:
        Result := ADCompareWideStr(
          PWideChar(UnicodeString(TVarData(V1).VUString)), PWideChar(UnicodeString(TVarData(V2).VUString)),
          Length(UnicodeString(TVarData(V1).VUString)), Length(UnicodeString(TVarData(V2).VUString)),
          Table.Locale, coNoCase in AOptions, coPartial in AOptions, coNoSymbols in AOptions);
{$ENDIF}
      varOleStr:
        Result := ADCompareWideStr(
          TVarData(V1).VOleStr, TVarData(V2).VOleStr,
          ADWideStrLen(TVarData(V1).VOleStr), ADWideStrLen(TVarData(V2).VOleStr),
          Table.Locale, coNoCase in AOptions, coPartial in AOptions, coNoSymbols in AOptions);
{$IFNDEF NEXTGEN}
      varString:
        Result := ADCompareAnsiStr(
          PADAnsiString(AnsiString(TVarData(V1).VString)), PADAnsiString(AnsiString(TVarData(V2).VString)),
          Length(AnsiString(TVarData(V1).VString)), Length(AnsiString(TVarData(V2).VString)),
          Table.Locale, coNoCase in AOptions, coPartial in AOptions, coNoSymbols in AOptions);
{$ENDIF}
      else
        ASSERT(False);
      end
    else
      if V1 > V2 then
        Result := 1
      else if V1 < V2 then
        Result := -1
      else
        Result := 0;
  end
  else
    Result := CompareNulls(lIsNull1, lIsNull2, AOptions);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CopyBuffer(ADestination, ASource: PByte);
var
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  i: Integer;
  pSrc: PADByteString;
  pDest: PADByteString;
  iLen: Integer;
begin
  if ADestination <> nil then begin
    CleanupBuffer(ADestination);
    if ASource <> nil then begin
      oCols := Table.Columns;
      for i := 0 to oCols.Count - 1 do begin
        if GetIsNull(ASource, i) then
          SetIsNull(ADestination, i, True)
        else begin
          SetIsNull(ADestination, i, False);
          pSrc := PADByteString(ASource) + oCols.DataOffsets[i];
          pDest := PADByteString(ADestination) + oCols.DataOffsets[i];
          oCol := oCols.ItemsI[i];
          if caBlobData in oCol.Attributes then begin
            iLen := 0;
            GetBlobData(ASource, i, pSrc, iLen);
            SetBlobData(ADestination, i, pSrc, iLen, True);
          end
          else
            case oCol.DataType of
            dtBoolean:          PWordBool(pDest)^ := PWordBool(pSrc)^;
            dtSByte:            PShortInt(pDest)^ := PShortInt(pSrc)^;
            dtInt16:            PSmallInt(pDest)^ := PSmallInt(pSrc)^;
            dtInt32:            PInteger(pDest)^ := PInteger(pSrc)^;
            dtInt64:            PInt64(pDest)^ := PInt64(pSrc)^;
            dtByte:             PByte(pDest)^ := PByte(pSrc)^;
            dtUInt16:           PWord(pDest)^ := PWord(pSrc)^;
            dtUInt32:           PLongWord(pDest)^ := PLongWord(pSrc)^;
            dtUInt64:           PUInt64(pDest)^ := PUInt64(pSrc)^;
            dtSingle:           PSingle(pDest)^ := PSingle(pSrc)^;
            dtDouble:           PDouble(pDest)^ := PDouble(pSrc)^;
            dtExtended:         PExtended(pDest)^ := PExtended(pSrc)^;
            dtCurrency:         PCurrency(pDest)^ := PCurrency(pSrc)^;
            dtBCD,
            dtFmtBCD:           PADBcd(pDest)^ := PADBcd(pSrc)^;
            dtDateTime:         PADDateTimeData(pDest)^ := PADDateTimeData(pSrc)^;
            dtDateTimeStamp:    PADSQLTimeStamp(pDest)^ := PADSQLTimeStamp(pSrc)^;
            dtTimeIntervalFull,
            dtTimeIntervalYM,
            dtTimeIntervalDS:   PADSQLTimeInterval(pDest)^ := PADSQLTimeInterval(pSrc)^;
            dtTime:             PLongint(pDest)^ := PLongint(pSrc)^;
            dtDate:             PLongint(pDest)^ := PLongint(pSrc)^;
            dtAnsiString:       Move(pSrc^, pDest^, PWord(pSrc)^ * SizeOf(TADAnsiChar) + SizeOf(Word) + SizeOf(TADAnsiChar));
            dtByteString:       Move(pSrc^, pDest^, PWord(pSrc)^ + SizeOf(Word));
            dtWideString:       Move(pSrc^, pDest^, PWord(pSrc)^ * SizeOf(WideChar) + SizeOf(Word) + SizeOf(WideChar));
            dtGUID:             PGUID(pDest)^ := PGUID(pSrc)^;
            dtObject:           PADDataStoredObject(pDest)^ := PADDataStoredObject(pSrc)^;
            end;
        end;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetChildRows(const AChildRelationName: String): TADDatSView;
  procedure ErrorCantGetChildRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCreateChildView, [AChildRelationName]);
  end;
var
  oManager: TADDatSManager;
begin
  oManager := Manager;
  if oManager = nil then
    ErrorCantGetChildRows;
  Result := GetChildRows(Manager.Relations.RelationByName(AChildRelationName));
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetChildRows(AChildTable: TADDatSTable): TADDatSView;
  procedure ErrorCantGetChildRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCreateChildView, [S_AD_NotFound]);
  end;
var
  oRel: TADDatSRelation;
begin
  ASSERT(AChildTable <> nil);
  if (Manager = nil) or (AChildTable.Manager <> Manager) then
    ErrorCantGetChildRows;
  oRel := Manager.Relations.FindRelation(Table, AChildTable, False);
  if (oRel = nil) or (not oRel.Nested and (oRel.ChildKeyConstraint = nil)) then
    ErrorCantGetChildRows;
  Result := GetChildRows(oRel);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetChildRows(AChildRelation: TADDatSRelation): TADDatSView;
  procedure ErrorCantGetChildRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCreateChildView, [AChildRelation.Name]);
  end;
var
  oChildTab: TADDatSTable;
  oSrtView: TADDatSView;
begin
  ASSERT(AChildRelation <> nil);
  if (AChildRelation.ChildKeyConstraint = nil) or
     (AChildRelation.ParentTable <> Table) or
     not AChildRelation.IsDefined then
    ErrorCantGetChildRows;
  oChildTab := AChildRelation.ChildTable;
  Result := TADDatSView.Create(oChildTab, C_AD_SysNamePrefix + 'CHLD',
    vcChildRelation, False);
  try
    if AChildRelation.Nested then
      Result.Mechanisms.AddEx(TADDatSMechChilds.Create(Self))
    else begin
      oSrtView := oChildTab.Views.FindSortedView(AChildRelation.ChildColumnNames, [], []);
      if oSrtView <> nil then
        Result.SourceView := oSrtView
      else
        Result.SourceView := AChildRelation.ChildKeyConstraint.GetChildSortedView;
      Result.Mechanisms.AddEx(TADDatSMechDetails.Create(AChildRelation, Self));
    end;
    Result.Active := True;
  except
    ADFree(Result);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetParentRows(const AParentRelationName: String): TADDatSView;
  procedure ErrorCantGetParentRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCreateParentView, [AParentRelationName]);
  end;
var
  oManager: TADDatSManager;
begin
  oManager := Manager;
  if oManager = nil then
    ErrorCantGetParentRows;
  Result := GetParentRows(Manager.Relations.RelationByName(AParentRelationName));
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetParentRows(AParentTable: TADDatSTable): TADDatSView;
  procedure ErrorCantGetParentRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCreateParentView, [S_AD_NotFound]);
  end;
var
  oRel: TADDatSRelation;
begin
  ASSERT(AParentTable <> nil);
  if (Manager = nil) or (AParentTable.Manager <> Manager) then
    ErrorCantGetParentRows;
  oRel := Manager.Relations.FindRelation(AParentTable, Table, False);
  if (oRel = nil) or (not oRel.Nested and (oRel.ParentKeyConstraint = nil)) then
    ErrorCantGetParentRows;
  Result := GetParentRows(oRel);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetParentRows(AParentRelation: TADDatSRelation): TADDatSView;
  procedure ErrorCantGetParentRows;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantCreateParentView, [AParentRelation.Name]);
  end;
var
  oParentTab: TADDatSTable;
  oSrtView: TADDatSView;
begin
  ASSERT(AParentRelation <> nil);
  if (AParentRelation.ParentKeyConstraint = nil) or
     (AParentRelation.ChildTable <> Table) or
     not AParentRelation.IsDefined then
    ErrorCantGetParentRows;
  oParentTab := AParentRelation.ParentTable;
  Result := TADDatSView.Create(oParentTab, C_AD_SysNamePrefix + 'PRNT',
    vcChildRelation, False);
  try
    if AParentRelation.Nested then
      Result.Mechanisms.AddEx(TADDatSMechParent.Create(Self))
    else begin
      oSrtView := oParentTab.Views.FindSortedView(AParentRelation.ParentColumnNames, [], []);
      if oSrtView <> nil then
        Result.SourceView := oSrtView
      else
        Result.SourceView := AParentRelation.ParentKeyConstraint.GetUniqueSortedView;
      Result.Mechanisms.AddEx(TADDatSMechMaster.Create(AParentRelation, Self));
    end;
    Result.Active := True;
  except
    ADFree(Result);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.InternalCalculateColumns(ADefaults: Boolean; ACols: TADDatSColumnList);
var
  i: Integer;
  eTmpPriorRowState: TADDatSRowState;
  oCol: TADDatSColumn;
begin
  eTmpPriorRowState := FRowPriorState;
  FRowPriorState := RowState;
  FRowState := rsCalculating;
  try
    for i := 0 to ACols.Count - 1 do begin
      oCol := ACols.ItemsI[i];
      if (([caCalculated, caVirtual] * oCol.Attributes <> []) or ADefaults) and
         (oCol.FEvaluator <> nil) then begin
        oCol.FEvaluator.DataSource.Position := Self;
        try
          oCol.FEvaluator.Evaluate;
        finally
          oCol.FEvaluator.DataSource.Position := nil;
        end;
      end;
    end;
    if not ADefaults then
      if Assigned(ACols.OnCalcColumns) then
        ACols.OnCalcColumns(Self);
  finally
    FRowState := RowPriorState;
    FRowPriorState := eTmpPriorRowState;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.CalculateColumns(ADefaults: Boolean);
var
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  if not ADefaults and not (ctCalcs in oCols.FHasThings) or
     ADefaults and not (ctExps in oCols.FHasThings) then
    Exit;
  InternalCalculateColumns(ADefaults, oCols);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.Delete(ANotDestroy: Boolean = False);
  procedure ErrorRowCantBeDeleted;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowCantBeDeleted, []);
  end;
var
  oList: TADDatSTableRowList;
  oTab: TADDatSTable;
begin
  oTab := Table;
  if RowState in [rsDeleted, rsInitializing, rsDetached, rsCalculating,
                  rsChecking, rsForceWrite] then
    ErrorRowCantBeDeleted
  else if RowState = rsInserted then begin
    UnregisterChange;
    oList := RowList;
    if oList <> nil then
      oList.Remove(Self, ANotDestroy);
  end
  else begin
    CheckRowConstraints(rsDeleted);
    LockNotification;
    try
      CancelEdit;
      FRowState := rsDeleted;
    finally
      UnlockNotification;
    end;
    Notify(snRowStateChanged, srDataChange, TADNativeInt(Self), 0);
    RegisterChange;
  end;
  oTab.NotifyDataChanged(Self, rsDeleted);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoListInserting;
  procedure ErrorRowCantBeInserted;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowCantBeInserted, []);
  end;
begin
  if not (RowState in [rsInitializing, rsDetached, rsInserted,
                       rsImportingCurent, rsImportingOriginal, rsImportingProposed]) then
    ErrorRowCantBeInserted;
  CheckRowConstraints(rsInserted);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoListInserted;
begin
  FTable := GetTable;
  if FRowID = $FFFFFFFF then begin
    FRowID := FTable.Rows.FLastRowID;
    ASSERT(FTable.Rows.FLastRowID <> $FFFFFFFF);
    Inc(FTable.Rows.FLastRowID);
  end;
  if FTable.DataHandleMode in [lmHavyFetching, lmFetching, lmRefreshing] then begin
    FRowState := rsUnchanged;
    FpOriginal := FpProposed;
    FpProposed := nil;
  end
  else if not (RowState in [rsImportingCurent, rsImportingOriginal, rsImportingProposed]) then begin
    FRowState := rsInserted;
    FpCurrent := FpProposed;
    FpProposed := nil;
    RegisterChange;
  end
  else
    RegisterChange;
  CalculateColumns(False);
  Table.NotifyDataChanged(Self, rsInserted);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoListRemoving;
  procedure ErrorRowCantBeDeleted;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowCantBeDeleted, []);
  end;
begin
  if RowState = rsDestroying then
    Exit;
  if RowState = rsEditing then
    CancelEdit;
  if not (Table.DataHandleMode in [lmDestroying, lmHavyMove, lmHavyFetching]) and
     not (RowState in [rsInserted, rsDeleted]) then
    ErrorRowCantBeDeleted;
  CheckRowConstraints(rsDetached);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoListRemoved(ANewOwner: TADDatSObject);
begin
  if RowState <> rsDestroying then begin
    ASSERT(FpProposed = nil);
    FRowState := rsDetached;
    FpProposed := FpCurrent;
    FpCurrent := nil;
  end;
  FOwner := ANewOwner;
  FTable := GetTable;
  UnregisterChange;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNREndEditNoVer(ARow: TADDatSRow);
begin
  ARow.EndEditNested(True);
  ARow.EndEdit(True);
end;

procedure TADDatSRow.DoNREndEdit(ARow: TADDatSRow);
begin
  ARow.EndEditNested(False);
  ARow.EndEdit(False);
end;

procedure TADDatSRow.EndEditNested(ANoVersion: Boolean = False);
begin
  if ANoVersion then
    ProcessNestedRows(DoNREndEditNoVer)
  else
    ProcessNestedRows(DoNREndEdit);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.EndEdit(ANoVersion: Boolean = False);
var
  pOrig: PByte;
begin
  if RowState = rsEditing then begin
    if (RowPriorState = rsInserted) or (RowPriorState = rsModified) then begin
      CheckRowConstraints(rsModified);
      pOrig := FpOriginal;
      FpOriginal := FpCurrent;
      try
        FpCurrent := FpProposed;
        FpProposed := nil;
        FRowState := RowPriorState;
        if FRowState = rsInserted then
          FRowPriorState := rsDetached
        else if FRowState = rsModified then
          FRowPriorState := rsUnchanged;
        Notify(snRowStateChanged, srDataChange, TADNativeInt(Self), 0);
      finally
        FreeBuffer(FpOriginal);
        FpOriginal := pOrig;
      end;
      if not ANoVersion then
        RegisterChange;
    end
    else if RowPriorState = rsUnchanged then begin
      CheckRowConstraints(rsModified);
      FpCurrent := FpProposed;
      FpProposed := nil;
      FRowState := rsModified;
      Notify(snRowStateChanged, srDataChange, TADNativeInt(Self), 0);
      if not ANoVersion then
        RegisterChange;
    end;
    CalculateColumns(False);
    Table.NotifyDataChanged(Self, rsModified);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.RegisterChange;
var
  oManager: TADDatSManager;
begin
  if Table.DataHandleMode = lmHavyLoading then
    Exit;
  oManager := Manager;
  if (oManager <> nil) and oManager.UpdatesRegistry then begin
    if oManager.Updates <> nil then
      oManager.Updates.RegisterRow(Self);
  end
  else
    if Table.Updates <> nil then
      Table.Updates.RegisterRow(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.UnregisterChange;
var
  oManager: TADDatSManager;
begin
  oManager := Manager;
  if (oManager <> nil) and oManager.UpdatesRegistry then begin
    if oManager.Updates <> nil then
      oManager.Updates.UnregisterRow(Self);
  end
  else begin
    if (Table.DataHandleMode <> lmDestroying) and (Table.Updates <> nil) then
      Table.Updates.UnregisterRow(Self);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetBlobData(ABuffer: PByte; AColumn: Integer; var
  ApData: PADByteString; var ALen: Integer): Boolean;
var
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  pBlobData: PADBlobData;

  procedure ErrorColMBBlob;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColMBBlob, [oCol.Name]);
  end;

begin
  Result := False;
  if ABuffer <> nil then begin
    oCols := Table.Columns;
    oCol := oCols.ItemsI[AColumn];
    if not (caBlobData in oCol.Attributes) then
      ErrorColMBBlob;
    if GetIsNull(ABuffer, AColumn) then begin
      if @ApData <> nil then
        ApData := nil;
      if @ALen <> nil then
        ALen := 0;
    end
    else begin
      Result := True;
      pBlobData := PADBlobData(PADByteString(ABuffer) + oCols.DataOffsets[AColumn]);
      if @ApData <> nil then
        ApData := pBlobData^.FData;
      if @ALen <> nil then
        ALen := pBlobData^.FLength;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetBuffer(AVersion: TADDatSRowVersion): PByte;
var
  iRowState: TADDatSRowState;
begin
  if RowState in [rsInitializing, rsCalculating, rsChecking, rsForceWrite, rsDestroying] then
    iRowState := RowPriorState
  else
    iRowState := RowState;
  case iRowState of
  rsImportingCurent:
    Result := FpCurrent;
  rsImportingOriginal:
    Result := FpOriginal;
  rsImportingProposed:
    Result := FpProposed;
  rsDetached:
    if FpProposed <> nil then
      // new row, not yet inserted into the rows list
      case AVersion of
      rvDefault:  Result := FpProposed;
      rvCurrent:  Result := FpProposed;
      rvOriginal: Result := nil;
      rvPrevious: Result := FpProposed;
      rvProposed: Result := FpProposed;
      else        Result := nil;
      end
    else
      // deleted row, was deleted from the rows list
      case AVersion of
      rvDefault:  Result := FpOriginal;
      rvCurrent:  Result := nil;
      rvOriginal: Result := FpOriginal;
      rvPrevious: if FpCurrent <> nil then
                    Result := FpCurrent
                  else
                    Result := FpOriginal;
      rvProposed: Result := nil;
      else        Result := nil;
      end;
  rsInserted:
    case AVersion of
    rvDefault:  Result := FpCurrent;
    rvCurrent:  Result := FpCurrent;
    rvOriginal: Result := nil;
    rvPrevious: if FpOriginal <> nil then
                  Result := FpOriginal
                else
                  Result := FpCurrent;
    rvProposed: Result := nil;
    else        Result := nil;
    end;
  rsDeleted:
    case AVersion of
    rvDefault:  Result := FpOriginal;
    rvCurrent:  Result := nil;
    rvOriginal: Result := FpOriginal;
    rvPrevious: if FpCurrent <> nil then
                  Result := FpCurrent
                else
                  Result := FpOriginal;
    rvProposed: Result := nil;
    else        Result := nil;
    end;
  rsModified:
    case AVersion of
    rvDefault:  Result := FpCurrent;
    rvCurrent:  Result := FpCurrent;
    rvOriginal: Result := FpOriginal;
    rvPrevious: Result := FpOriginal;
    rvProposed: Result := nil;
    else        Result := nil;
    end;
  rsUnchanged:
    case AVersion of
    rvDefault:  Result := FpOriginal;
    rvCurrent:  Result := FpOriginal;
    rvOriginal: Result := FpOriginal;
    rvPrevious: Result := FpOriginal;
    rvProposed: Result := nil;
    else        Result := nil;
    end;
  rsEditing:
    case AVersion of
    rvDefault:  Result := FpProposed;
    rvCurrent:  Result := FpProposed;
    rvOriginal: if (RowPriorState = rsDeleted) or (RowPriorState = rsModified) or
                   (RowPriorState = rsUnchanged) then
                  Result := FpOriginal
                else
                  Result := nil;
    rvPrevious: if FpCurrent <> nil then
                  Result := FpCurrent
                else
                  Result := FpOriginal;
    rvProposed: Result := FpProposed;
    else        Result := nil;
    end;
  else
    Result := nil;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetCheckInfo(ACheckColumn: Integer; out ACheckValue: PADByteString;
  out ACheckLen: LongWord): Boolean;
var
  pInfo: PADDataRowExtraInfo;
begin
  pInfo := GetRowInfo(False);
  Result := False;
  if pInfo <> nil then
    if pInfo^.FCheckColumn = ACheckColumn then begin
      ACheckValue := pInfo^.FCheckValue;
      ACheckLen := pInfo^.FCheckLen;
      Result := True;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetCheckInfo(ACheckColumn: Integer; ACheckValue: PADByteString;
  ACheckLen: Integer);
var
  pInfo: PADDataRowExtraInfo;
begin
  pInfo := GetRowInfo(ACheckColumn <> -1);
  if pInfo <> nil then begin
    pInfo^.FCheckColumn := ACheckColumn;
    pInfo^.FCheckValue := ACheckValue;
    pInfo^.FCheckLen := ACheckLen;
    if ACheckColumn = -1 then
      CheckNoInfo;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetDataI(const AColumn: Integer): Variant;
begin
  Result := GetData(AColumn, rvDefault);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetDataO(AColumn: TADDatSColumn): Variant;
begin
  Result := GetData(AColumn, rvDefault);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetDataS(const AColumn: String): Variant;
begin
  Result := GetData(AColumn, rvDefault);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetDataV(const AColumn: Variant): Variant;
var
  i: Integer;
  s: String;
begin
  case VarType(AColumn) of
  varSmallint,
  varInteger,
  varSingle,
  varDouble,
  varCurrency,
  varByte,
{$IFDEF AnyDAC_D6Base}
  varShortInt,
  varWord,
  varLongWord,
{$ENDIF}
{$IFDEF AnyDAC_D12}
  varUInt64,
{$ENDIF}
  varInt64:
    begin
      i := AColumn;
      Result := GetData(i, rvDefault);
    end;
{$IFDEF AnyDAC_D12}
  varUString,
{$ENDIF}
  varOleStr,
  varString:
    begin
      s := AColumn;
      Result := GetData(s, rvDefault);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetDataI(const AColumn: Integer; const Value: Variant);
begin
  SetData(AColumn, Value);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetDataO(AColumn: TADDatSColumn; const Value: Variant);
begin
  SetData(AColumn.Index, Value);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetDataS(const AColumn: String; const Value: Variant);
begin
  SetData(Table.Columns.ColumnByName(AColumn).Index, Value);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetDataV(const AColumn: Variant; const Value: Variant);
var
  i: Integer;
  s: String;
begin
  case VarType(AColumn) of
  varSmallint,
  varInteger,
  varSingle,
  varDouble,
  varCurrency,
  varByte,
{$IFDEF AnyDAC_D6Base}
  varShortInt,
  varWord,
  varLongWord,
{$ENDIF}  
{$IFDEF AnyDAC_D12}
  varUInt64,
{$ENDIF}
  varInt64:
    begin
      i := AColumn;
      SetData(i, rvDefault);
    end;
{$IFDEF AnyDAC_D12}
  varUString,
{$ENDIF}
  varOleStr,
  varString:
    begin
      s := AColumn;
      SetDataS(s, rvDefault);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetData(const AColumn: TADDatSColumn;
  AVersion: TADDatSRowVersion = rvDefault): Variant;
begin
  Result := GetData(AColumn.Index, AVersion);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetData(const AColumn: Integer;
  AVersion: TADDatSRowVersion = rvDefault): Variant;
var
  pBuff, p: Pointer;
  iLen: LongWord;
{$IFNDEF NEXTGEN}
  SA: AnsiString;
{$ENDIF}
  SW: TADWideString;
{$IFNDEF AnyDAC_D6Base}
  crVal: Currency;
{$ENDIF}
begin
  pBuff := nil;
  iLen := 0;
  if not GetData(AColumn, AVersion, pBuff, 0, iLen, False) then
    Result := Null
  else
    case Table.Columns.ItemsI[AColumn].DataType of
    dtBoolean:
      Result := PWordBool(pBuff)^;
    dtSByte:
      Result := PShortInt(pBuff)^;
    dtInt16:
      Result := PSmallInt(pBuff)^;
    dtInt32:
      Result := PInteger(pBuff)^;
    dtInt64:
{$IFDEF AnyDAC_D6Base}
      Result := PInt64(pBuff)^;
{$ELSE}
      begin
        TVarData(Result).VType := varInt64;
        Decimal(Result).lo64 := PInt64(pBuff)^;
      end;
{$ENDIF}
    dtByte:
      Result := PByte(pBuff)^;
    dtUInt16:
      Result := PWord(pBuff)^;
    dtUInt32:
{$IFDEF AnyDAC_D6Base}
      Result := PLongWord(pBuff)^;
{$ELSE}
      Result := PInteger(pBuff)^;
{$ENDIF}
    dtUInt64:
{$IFDEF AnyDAC_D6Base}
      Result := PUInt64(pBuff)^;
{$ELSE}
      begin
        TVarData(Result).VType := varInt64;
        Decimal(Result).lo64 := PUInt64(pBuff)^;
      end;
{$ENDIF}
    dtSingle:
      Result := PSingle(pBuff)^;
    dtDouble:
      Result := PDouble(pBuff)^;
    dtExtended:
      Result := PExtended(pBuff)^;
    dtCurrency:
      Result := PCurrency(pBuff)^;
    dtBCD,
    dtFmtBCD:
{$IFDEF AnyDAC_D6Base}
      Result := VarFMTBcdCreate(PADBcd(pBuff)^);
{$ELSE}
      begin
        crVal := 0.0;
        BCDToCurr(PADBcd(pBuff)^, crVal);
        Result := crVal;
      end;
{$ENDIF}
    dtDateTime:
      Result := ADMSecs2DateTime(PADDateTimeData(pBuff)^.DateTime);
    dtDateTimeStamp:
{$IFDEF AnyDAC_D6}
      Result := VarSQLTimeStampCreate(PADSQLTimeStamp(pBuff)^);
{$ELSE}
      Result := ADSQLTimeStamp2DateTime(PADSQLTimeStamp(pBuff)^);
{$ENDIF}
    dtTimeIntervalFull,
    dtTimeIntervalYM,
    dtTimeIntervalDS:
{$IFDEF AnyDAC_D6}
      Result := ADVarSQLTimeIntervalCreate(PADSQLTimeInterval(pBuff)^);
{$ELSE}
      Result := ADSQLTimeInterval2Str(PADSQLTimeInterval(pBuff)^);
{$ENDIF}
    dtTime:
{$IFDEF AnyDAC_D6}
      // Delphi does not support negative time value
      if PLongint(pBuff)^ < 0 then
        Result := ADTime2DateTime(PLongint(pBuff)^)
      else
        Result := VarSQLTimeStampCreate(ADTime2SQLTimeStamp(PLongint(pBuff)^));
{$ELSE}
      Result := ADTime2DateTime(PLongint(pBuff)^);
{$ENDIF}
    dtDate:
{$IFDEF AnyDAC_D6}
      Result := VarSQLTimeStampCreate(ADDate2SQLTimeStamp(PLongint(pBuff)^));
{$ELSE}
      Result := ADDate2DateTime(PLongint(pBuff)^);
{$ENDIF}
    dtByteString:
      begin
        if iLen = 0 then
          Result := VarArrayCreate([0, -1], varByte)
        else
          Result := VarArrayCreate([0, iLen - 1], varByte);
        p := VarArrayLock(Result);
        try
          Move(pBuff^, p^, iLen);
        finally
          VarArrayUnlock(Result);
        end;
      end;
    dtAnsiString, dtMemo, dtHMemo, dtBlob, dtHBlob, dtHBFile:
      begin
{$IFDEF NEXTGEN}
        Result := TADEncoder.Deco(pBuff, iLen, ecANSI);
{$ELSE}
        SetString(SA, PAnsiChar(pBuff), iLen);
        Result := SA;
{$ENDIF}
      end;
    dtWideString, dtWideMemo, dtWideHMemo, dtXML:
      begin
        SetString(SW, PWideChar(pBuff), iLen);
        Result := SW;
      end;
    dtGUID:
      Result := GUIDToString(PGUID(pBuff)^);
    dtObject:
      Result := PADDataStoredObject(pBuff)^;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetData(const AColumnName: String;
  AVersion: TADDatSRowVersion = rvDefault): Variant;
begin
  Result := GetData(Table.Columns.ColumnByName(AColumnName).Index, AVersion);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetData(const AColumn: Integer; AVersion:
  TADDatSRowVersion; var ABuff: Pointer; ABuffLen: LongWord; var ADataLen:
  LongWord; AByVal: Boolean): Boolean;
var
  iLen: LongWord;
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  pSrc: PADByteString;
  pBuff: PByte;
  lColumnChecking: Boolean;

  procedure ErrorFixedLenDataMismatch;
  begin
    ADataLen := 0;
    ADException(Self, [S_AD_LDatS], er_AD_FixedLenDataMismatch, [oCol.Name]);
  end;

  procedure ProcessVariableDataByVal(AActualLength, AItemLength, AZeros: LongWord; AActualData: PADByteString);
  begin
    if ABuffLen = 0 then
      iLen := AActualLength
    else begin
      iLen := ABuffLen div AItemLength - AZeros;
      if iLen > AActualLength then
        iLen := AActualLength;
    end;
    ADataLen := iLen;
    if ABuff <> nil then begin
      Move(AActualData^, ABuff^, iLen * AItemLength);
      if AZeros = 1 then
        (PADByteString(ABuff) + iLen * AItemLength)^ := TADByte(#0)
      else if AZeros = 2 then begin
        (PADByteString(ABuff) + iLen * AItemLength)^ := TADByte(#0);
        (PADByteString(ABuff) + iLen * AItemLength + 1)^ := TADByte(#0);
      end;
    end;
  end;

  procedure ProcessVariableDataByRef(AActualLength, AItemLength, AZeros: LongWord;
    AActualData: PADByteString);
  begin
    if ABuffLen = 0 then
      iLen := AActualLength
    else begin
      iLen := ABuffLen div AItemLength - AZeros;
      if iLen > AActualLength then
        iLen := AActualLength;
    end;
    ADataLen := iLen;
    ABuff := AActualData;
    // ABuff=nil and ADataLen=0 means NULL, but it is not
    if (ABuff = nil) and (ADataLen = 0) and Result then
      ABuff := Self;
  end;

  procedure ErrorCantOperateInvObj;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantOperateInvObj, [oCol.Name]);
  end;

begin
  ASSERT(Self <> nil);
  oCols := Table.Columns;
  ASSERT(Length(oCols.FDataOffsets) <> 0);
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  oCol := TADDatSColumn(oCols.FArray[AColumn]);

  pSrc := nil;
  iLen := 0;
  lColumnChecking := (RowState = rsChecking) and GetCheckInfo(AColumn, pSrc, iLen);
  if lColumnChecking then begin
    if pSrc = nil then begin
      ADataLen := 0;
      if not AByVal then
        ABuff := nil;
      Result := False;
      Exit;
    end;
  end
  else begin
    pBuff := GetBuffer(AVersion);
    if (pBuff = nil) or
       ((PByte(PADByteString(pBuff) + oCols.NullOffsets[AColumn])^ and oCols.NullMasks[AColumn]) = 0) then begin
      ADataLen := 0;
      if not AByVal then
        ABuff := nil;
      Result := False;
      Exit;
    end;
    pSrc := PADByteString(pBuff) + oCols.DataOffsets[AColumn];
  end;

  Result := True;
  if AByVal then
    if caBlobData in oCol.Attributes then
      if oCol.DataType in [dtWideString, dtWideMemo, dtWideHMemo, dtXML] then
        ProcessVariableDataByVal(PADBlobData(pSrc)^.FLength, SizeOf(WideChar), 0,
          PADBlobData(pSrc)^.FData)
      else
        ProcessVariableDataByVal(PADBlobData(pSrc)^.FLength, SizeOf(TADAnsiChar), 0,
          PADBlobData(pSrc)^.FData)
    else
      case oCol.DataType of
      dtBoolean:
        begin
          ADataLen := SizeOf(WordBool);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PWordBool(ABuff)^ := PWordBool(pSrc)^;
        end;
      dtSByte:
        begin
          ADataLen := SizeOf(ShortInt);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PShortInt(ABuff)^ := PShortInt(pSrc)^;
        end;
      dtInt16:
        begin
          ADataLen := SizeOf(SmallInt);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PSmallInt(ABuff)^ := PSmallInt(pSrc)^;
        end;
      dtInt32:
        begin
          ADataLen := SizeOf(Integer);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PInteger(ABuff)^ := PInteger(pSrc)^;
        end;
      dtInt64:
        begin
          ADataLen := SizeOf(Int64);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PInt64(ABuff)^ := PInt64(pSrc)^;
        end;
      dtByte:
        begin
          ADataLen := SizeOf(Byte);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PByte(ABuff)^ := PByte(pSrc)^;
        end;
      dtUInt16:
        begin
          ADataLen := SizeOf(Word);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PWord(ABuff)^ := PWord(pSrc)^;
        end;
      dtUInt32:
        begin
          ADataLen := SizeOf(LongWord);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PLongWord(ABuff)^ := PLongWord(pSrc)^;
        end;
      dtUInt64:
        begin
          ADataLen := SizeOf(UInt64);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PUInt64(ABuff)^ := PUInt64(pSrc)^;
        end;
      dtSingle:
        begin
          ADataLen := SizeOf(Single);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PSingle(ABuff)^ := PSingle(pSrc)^;
        end;
      dtDouble:
        begin
          ADataLen := SizeOf(Double);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PDouble(ABuff)^ := PDouble(pSrc)^;
        end;
      dtExtended:
        begin
          ADataLen := SizeOf(Extended);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PExtended(ABuff)^ := PExtended(pSrc)^;
        end;
      dtCurrency:
        begin
          ADataLen := SizeOf(Currency);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PCurrency(ABuff)^ := PCurrency(pSrc)^;
        end;
      dtBCD,
      dtFmtBCD:
        begin
          ADataLen := SizeOf(TADBcd);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PADBcd(ABuff)^ := PADBcd(pSrc)^;
        end;
      dtDateTime:
        begin
          ADataLen := SizeOf(TADDateTimeData);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PADDateTimeData(ABuff)^ := PADDateTimeData(pSrc)^;
        end;
      dtDateTimeStamp:
        begin
          ADataLen := SizeOf(TADSQLTimeStamp);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PADSQLTimeStamp(ABuff)^ := PADSQLTimeStamp(pSrc)^;
        end;
      dtTimeIntervalFull,
      dtTimeIntervalYM,
      dtTimeIntervalDS:
        begin
          ADataLen := SizeOf(TADSQLTimeInterval);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PADSQLTimeInterval(ABuff)^ := PADSQLTimeInterval(pSrc)^;
        end;
      dtTime,
      dtDate:
        begin
          ADataLen := SizeOf(Longint);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PLongint(ABuff)^ := PLongint(pSrc)^;
        end;
      dtAnsiString:
        if lColumnChecking then
          ProcessVariableDataByVal(iLen, SizeOf(TADAnsiChar), 1, pSrc)
        else
          ProcessVariableDataByVal(PWord(pSrc)^, SizeOf(TADAnsiChar), 1, PADByteString(pSrc) + SizeOf(Word));
      dtByteString:
        if lColumnChecking then
          ProcessVariableDataByVal(iLen, SizeOf(Byte), 1, pSrc)
        else
          ProcessVariableDataByVal(PWord(pSrc)^, SizeOf(Byte), 0, PADByteString(pSrc) + SizeOf(Word));
      dtWideString:
        if lColumnChecking then
          ProcessVariableDataByVal(iLen, SizeOf(WideChar), 1, pSrc)
        else
          ProcessVariableDataByVal(PWord(pSrc)^, SizeOf(WideChar), 1, PADByteString(pSrc) + SizeOf(Word));
      dtGUID:
        begin
          ADataLen := SizeOf(TGUID);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PGUID(ABuff)^ := PGUID(pSrc)^;
        end;
      dtObject:
        begin
          ADataLen := SizeOf(IADDataStoredObject);
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch
          else if ABuff <> nil then
            PADDataStoredObject(ABuff)^ := PADDataStoredObject(pSrc)^;
        end;
      dtRowSetRef,
      dtCursorRef,
      dtRowRef,
      dtArrayRef,
      dtParentRowRef:
        ErrorCantOperateInvObj;
      end
  else
    if caBlobData in oCol.Attributes then
      if oCol.DataType in [dtWideString, dtWideMemo, dtWideHMemo, dtXML] then
        ProcessVariableDataByRef(PADBlobData(pSrc)^.FLength, SizeOf(WideChar), 0,
          PADBlobData(pSrc)^.FData)
      else
        ProcessVariableDataByRef(PADBlobData(pSrc)^.FLength, SizeOf(TADAnsiChar), 0,
          PADBlobData(pSrc)^.FData)
    else
      case oCol.DataType of
      dtAnsiString:
        if lColumnChecking then
          ProcessVariableDataByRef(iLen, SizeOf(TADAnsiChar), 1, pSrc)
        else
          ProcessVariableDataByRef(PWord(pSrc)^, SizeOf(TADAnsiChar), 1, PADByteString(pSrc) + SizeOf(Word));
      dtByteString:
        if lColumnChecking then
          ProcessVariableDataByRef(iLen, SizeOf(Byte), 1, pSrc)
        else
          ProcessVariableDataByRef(PWord(pSrc)^, SizeOf(Byte), 0, PADByteString(pSrc) + SizeOf(Word));
      dtWideString:
        if lColumnChecking then
          ProcessVariableDataByRef(iLen, SizeOf(WideChar), 1, pSrc)
        else
          ProcessVariableDataByRef(PWord(pSrc)^, SizeOf(WideChar), 1, PADByteString(pSrc) + SizeOf(Word));
      dtRowSetRef,
      dtCursorRef,
      dtRowRef,
      dtArrayRef,
      dtParentRowRef:
        ErrorCantOperateInvObj;
      else
        begin
          ADataLen := oCol.StorageSize;
          if (ABuffLen <> ADataLen) and (ABuffLen <> 0) then
            ErrorFixedLenDataMismatch;
          ABuff := pSrc;
        end;
      end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetValues(const ANames: String; ADataSetNative: Boolean): Variant;
var
  iFields, i, j: Integer;

  function Cnv2Dataset(const AValue: Variant): Variant;
  begin
{$IFDEF AnyDAC_FPC}
    if ADataSetNative and VarIsFmtBCD(AValue) then
      Result := BCDToDouble(VarToBCD(AValue))
    else
{$ENDIF}
      Result := AValue;
  end;

begin
  iFields := ADCountFieldNames(ANames);
  if iFields <= 1 then
    Result := Cnv2Dataset(GetData(ANames))
  else begin
    Result := VarArrayCreate([0, iFields - 1], varVariant);
    i := 1;
    for j := 0 to iFields - 1 do
      Result[j] := Cnv2Dataset(GetData(ADExtractFieldName(ANames, i)));
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetHasErrors: Boolean;
begin
  Result := GetRowError <> nil;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetIsNull(ABuffer: PByte; AColumn: Integer): Boolean;
var
  oCols: TADDatSColumnList;
  oObj: TADDatSObject;
begin
  oCols := Table.Columns;
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  case oCols.ItemsI[AColumn].DataType of
  dtRowSetRef,
  dtCursorRef,
  dtRowRef,
  dtParentRowRef:
    Result := GetInvariantObject(AColumn) = nil;
  dtArrayRef:
    begin
      oObj := GetInvariantObject(AColumn);
      Result := oObj = nil;
      if not Result then
        Result := (oObj as TADDatSNestedRowList).Count = 0;
    end;
  else
    Result := (PByte(PADByteString(ABuffer) + oCols.NullOffsets[AColumn])^ and oCols.NullMasks[AColumn]) = 0;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetRowList: TADDatSTableRowList;
begin
  if (Owner <> nil) and (Owner.ClassType = TADDatSTableRowList) then
    Result := TADDatSTableRowList(Owner)
  else
    Result := nil;
  ASSERT((Result = nil) or (Owner <> nil) and (Owner is TADDatSTableRowList));
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetTable: TADDatSTable;
begin
  if FOwner.ClassType = TADDatSTable then
    Result := TADDatSTable(FOwner)
  else
    Result := TADDatSTable(FOwner.FOwner);
  ASSERT((Result <> nil) and (Result is TADDatSTable));
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetManager: TADDatSManager;
begin
  Result := Table.Manager;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.HasVersion(AVersion: TADDatSRowVersion): Boolean;
begin
  Result := (GetBuffer(AVersion) <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.AcceptChanges(AUseCascade: Boolean = True);
  procedure ErrorCantPerform;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_OperCNBPerfInState, []);
  end;
var
  oList: TADDatSTableRowList;
  lRowExists: Boolean;
begin
  AcceptNestedChanges;
  if RowState = rsEditing then
    EndEdit;
  if RowState in [rsInitializing, rsCalculating, rsChecking, rsForceWrite] then
    ErrorCantPerform;
  UnregisterChange;
  if AUseCascade then
    CascadeAcceptReject(True);
  lRowExists := True;
  case RowState of
  rsInserted:
    begin
      FpOriginal := FpCurrent;
      FpCurrent := nil;
      FRowState := rsUnchanged;
      Notify(snRowStateChanged, srDataChange, TADNativeInt(Self), 0);
    end;
  rsDeleted:
    begin
      oList := RowList;
      if oList <> nil then begin
        oList.Remove(Self);
        lRowExists := False;
      end;
    end;
  rsModified:
    begin
      FreeBuffer(FpOriginal);
      FpOriginal := FpCurrent;
      FpCurrent := nil;
      FRowState := rsUnchanged;
      Notify(snRowStateChanged, srDataChange, TADNativeInt(Self), 0);
    end;
  end;
  if lRowExists and (DBLockID <> 0) then
    DBUnlock;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.RejectChanges(AUseCascade: Boolean = True);
  procedure ErrorCantPerform;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_OperCNBPerfInState, []);
  end;
var
  oList: TADDatSTableRowList;
begin
  RejectNestedChanges;
  if RowState = rsEditing then
    CancelEdit;
  if RowState in [rsInitializing, rsCalculating, rsChecking, rsForceWrite] then
    ErrorCantPerform;
  UnregisterChange;
  if AUseCascade then
    CascadeAcceptReject(False);
  case RowState of
  rsInserted:
    begin
      oList := RowList;
      if oList <> nil then
        oList.Remove(Self)
      else
        Destroy;
      // at this point row does not exist, so exit from here
      Exit;
    end;
  rsDeleted:
    begin
      FreeBuffer(FpCurrent);
      FRowState := rsUnchanged;
      Notify(snRowStateChanged, srDataChange, TADNativeInt(Self), 0);
    end;
  rsModified:
    begin
      FreeBuffer(FpCurrent);
      FRowState := rsUnchanged;
      Notify(snRowStateChanged, srDataChange, TADNativeInt(Self), 0);
    end;
  end;
  if DBLockID <> 0 then
    DBUnlock;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.SetBlobLength(ABuffer: PByte; AColumn: Integer;
  ApData: PADByteString; ALength: Integer; out AZeroAddOn, AUnitSize: Integer;
  AForceNotNull: Boolean = False): PADByteString;
var
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  pBlobData: PADBlobData;

  procedure ErrorColMBBlob;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColMBBLob, [oCol.Name]);
  end;

begin
  Result := nil;
  if ABuffer = nil then
    Exit;
  oCols := Table.Columns;
  oCol := oCols.ItemsI[AColumn];
  if not (caBlobData in oCol.Attributes) then
    ErrorColMBBlob;
  pBlobData := PADBlobData(PADByteString(ABuffer) + oCols.DataOffsets[AColumn]);
  case oCol.DataType of
  dtAnsiString:
    begin
      AUnitSize := SizeOf(TADAnsiChar);
      AZeroAddOn := SizeOf(TADAnsiChar);
    end;
  dtWideString:
    begin
      AUnitSize := SizeOf(WideChar);
      AZeroAddOn := SizeOf(WideChar);
    end;
  dtWideMemo, dtWideHMemo, dtXML:
    begin
      AUnitSize := SizeOf(WideChar);
      AZeroAddOn := 0;
    end;
  dtMemo, dtHMemo:
    begin
      AUnitSize := SizeOf(TADAnsiChar);
      AZeroAddOn := 0;
    end;
  else // dtBlob, dtHBlob, dtHBFile, dtByteString:
    begin
      AUnitSize := SizeOf(Byte);
      AZeroAddOn := 0;
    end;
  end;
  if (pBlobData^.FData <> nil) and (ALength = 0) then begin
    FreeMem(pBlobData^.FData, pBlobData^.FLength * AUnitSize + AZeroAddOn);
    pBlobData^.FData := nil;
  end
  else if (pBlobData^.FData = nil) and (ALength > 0) then
    GetMem(pBlobData^.FData, ALength * AUnitSize + AZeroAddOn)
  else if (pBlobData^.FData <> nil) and (ALength > 0) and (pBlobData^.FLength <> ALength) then
    ReallocMem(pBlobData^.FData, ALength * AUnitSize + AZeroAddOn);
  pBlobData^.FLength := ALength;
  Result := pBlobData^.FData;
  SetIsNull(ABuffer, AColumn, not AForceNotNull and (ALength = 0) and (ApData = nil));
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.SetBlobData(ABuffer: PByte; AColumn: Integer;
  ApData: PADByteString; ALength: Integer; AForceNotNull: Boolean = False): PADByteString;
var
  iZeroAddOn, iUnitSize: Integer;
  p: PADByteString;
begin
  Result := SetBlobLength(ABuffer, AColumn, ApData, ALength, iZeroAddOn,
    iUnitSize, AForceNotNull);
  if (Result <> nil) and (ApData <> nil) and (ALength <> 0) then begin
    Move(ApData^, Result^, ALength * iUnitSize);
    if iZeroAddOn > 0 then begin
      p := PADByteString(Result) + ALength * iUnitSize;
      if iZeroAddOn = 1 then
        p^ := TADByte(#0)
      else
        while iZeroAddOn > 0 do begin
          p^ := TADByte(#0);
          Inc(p);
          Dec(iZeroAddOn);
        end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.BeginForceWrite;
begin
  ASSERT(RowState in [rsDetached, rsInitializing]);
  FRowState := rsForceWrite;
  FRowPriorState := rsDetached;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.EndForceWrite;
begin
  ASSERT(RowState = rsForceWrite);
  FRowState := rsDetached;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.CheckWrite(AColumn: Integer): PByte;
  procedure CheckUpdatable;
  var
    oCol: TADDatSColumn;
  begin
    oCol := Table.Columns.ItemsI[AColumn];
    if not (oCol.DataType in C_AD_InvariantDataTypes) and
       not (RowState in [rsCalculating, rsInitializing, rsDetached, rsEditing, rsForceWrite,
                         rsImportingCurent, rsImportingOriginal, rsImportingProposed]) then
      ADException(Self, [S_AD_LDatS], er_AD_RowNotInEditableState, []);
    if Table.EnforceConstraints and Table.CheckReadOnly and oCol.ReadOnly and
       not (RowState in [rsCalculating, rsInitializing, rsForceWrite,
                         rsImportingCurent, rsImportingOriginal, rsImportingProposed]) then
      ADException(Self, [S_AD_LDatS], er_AD_ColIsReadOnly, [oCol.Name]);
  end;
begin
  if Table.DataHandleMode = lmStandard then
    CheckUpdatable;
  Result := GetBuffer(rvDefault);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetData(AColumn: Integer; ABuff: Pointer; ADataLen: LongWord);
const
  GUID_NULL: TGUID = '{00000000-0000-0000-0000-000000000000}';
var
  oCols: TADDatSColumnList;
  oCol: TADDatSColumn;
  pBuff: PByte;
  pSrc: PADByteString;
  pCh: PADByteString;
  lIsNull, lFetching: Boolean;

  procedure ErrorCantOperateInvObj;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantOperateInvObj, [oCol.Name]);
  end;

  procedure ErrorFixedLenDataMismatch(ATypeLen: LongWord);
  begin
    ADException(Self, [S_AD_LDatS], er_AD_FixedLenDataMismatch, [oCol.Name, ADataLen, ATypeLen]);
  end;

  procedure ErrorVarLenDataMismatch;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_VarLenDataMismatch, [oCol.Name, ADataLen, oCol.Size]);
  end;

  procedure ValidateValue;
  var
    rBlob: TADBlobData;
  begin
    if SkipConstraintCheck then
      Exit;
    if caBlobData in oCol.Attributes then begin
      rBlob.FData := PADByteString(ABuff);
      rBlob.FLength := ADataLen;
      SetCheckInfo(AColumn, PADByteString(@rBlob), SizeOf(rBlob));
    end
    else
      SetCheckInfo(AColumn, PADByteString(ABuff), ADataLen);
    try
      CheckColumnConstraints;
    finally
      SetCheckInfo(-1, nil, 0);
    end;
  end;

  procedure ProcessFixedLength(ATypeLen: LongWord);
  begin
    if (ADataLen <> 0) and (ADataLen <> ATypeLen) then
      ErrorFixedLenDataMismatch(ATypeLen);
    if not lFetching then
      ValidateValue;
  end;

  procedure ProcessVarLength;
  begin
    if ADataLen > oCol.Size then
      if Table.StrsTrim2Len then
        ADataLen := oCol.Size
      else
        ErrorVarLenDataMismatch;
    if not lFetching then
      ValidateValue;
  end;

  function RoundTime(AValue: LongInt; AScale: Integer): LongInt;
  var
    iRem: LongInt;
  begin
    // Special case - MSSQL scale for DATETIME
    if AScale = 3 then begin
      iRem := AValue mod 10;
      case iRem of
      1:       Result := AValue - iRem;
      2, 4:    Result := AValue - iRem + 3;
      5, 6, 8: Result := AValue - iRem + 7;
      9:       Result := AValue + 1;
      else     Result := AValue; // 0, 3, 7
      end;
    end
    // Special case - MSSQL scale for SMALLDATETIME
    else if AScale = 60000 then begin
      iRem := AValue mod AScale;
      if iRem < AScale div 2 - 1 then
        Result := AValue - iRem
      else
        Result := AValue - iRem + AScale;
    end
    // Else just truncate value
    else
      Result := AValue - AValue mod AScale;
  end;

  function RoundDateTime(AValue: TADDateTimeAlias; AScale: Integer): TADDateTimeAlias;
  var
    dRem: Double;
  begin
    if AScale = 3 then begin
      dRem := AValue - Trunc(AValue / 10.0) * 10.0;
      case Trunc(dRem) of
      1:       Result := AValue - dRem;
      2, 4:    Result := AValue - dRem + 3.0;
      5, 6, 8: Result := AValue - dRem + 7.0;
      9:       Result := AValue + 1.0;
      else     Result := AValue; // 0, 3, 7
      end;
    end
    // Special case - MSSQL scale for SMALLDATETIME
    else if AScale = 60000 then begin
      dRem := AValue - Trunc(AValue / AScale) * AScale;
      if dRem < AScale / 2.0 - 1 then
        Result := AValue - dRem
      else
        Result := AValue - dRem + AScale;
    end
    // Else just truncate value
    else
      Result := Trunc(AValue / AScale) * AScale;
  end;

  procedure RoundTimeStamp(var AValue: TADSQLTimeStamp; AScale: Integer);
  var
    iTime: LongInt;
  begin
    if AScale = 1000 then
      AValue.Fractions := 0
    // Special case - MSSQL scale for DATETIME or SMALLDATETIME
    else if (AScale = 3) or (AScale = 60000) then begin
      iTime := RoundTime(ADSQLTimeStamp2Time(AValue), AScale);
      AValue.Fractions := iTime mod 1000;
      AValue.Second := (iTime div 1000) mod 60;
      AValue.Minute := (iTime div (1000 * 60)) mod 60;
      AValue.Hour := iTime div (1000 * 60 * 60);
      { TODO -cDATS : normalize a time stamp }
    end
    else if AScale < 1000 then
      AValue.Fractions := AValue.Fractions - AValue.Fractions mod LongWord(AScale)
    else if AScale < 60000 then begin
      AValue.Fractions := 0;
      AValue.Second := AValue.Second - AValue.Second mod (AScale div 1000);
    end;
  end;

  procedure RoundTimeInterval(var AValue: TADSQLTimeInterval; AScale: Integer);
  begin
    if AScale = 1000 then
      AValue.Fractions := 0
    else if AScale < 1000 then
      AValue.Fractions := AValue.Fractions - AValue.Fractions mod LongWord(AScale)
    else if AScale < 60000 then begin
      AValue.Fractions := 0;
      AValue.Seconds := AValue.Seconds - AValue.Seconds mod LongWord(AScale div 1000);
    end;
  end;

begin
  ASSERT(Self <> nil);
  oCols := Table.Columns;
  ASSERT(Length(oCols.FDataOffsets) <> 0);
  oCol := oCols.ItemsI[AColumn];

  pBuff := CheckWrite(AColumn);
  if pBuff = nil then
    Exit;
  pSrc := PADByteString(pBuff) + oCols.DataOffsets[AColumn];
  lIsNull := (ABuff = nil);
  lFetching := Table.DataHandleMode in [lmHavyFetching, lmFetching, lmRefreshing];

  if caBlobData in oCol.Attributes then begin
    if not lFetching then
      ValidateValue;
    SetBlobData(pBuff, AColumn, ABuff, ADataLen);
    if lFetching then
      SetFetched(AColumn, True);
  end
  else begin
    case oCol.DataType of
    dtBoolean:
      begin
        ProcessFixedLength(SizeOf(WordBool));
        if ABuff <> nil then
          PWordBool(pSrc)^ := PWordBool(ABuff)^
        else
          PWordBool(pSrc)^ := False;
      end;
    dtSByte:
      begin
        ProcessFixedLength(SizeOf(ShortInt));
        if ABuff <> nil then
          PShortInt(pSrc)^ := PShortInt(ABuff)^
        else
          PShortInt(pSrc)^ := 0;
      end;
    dtInt16:
      begin
        ProcessFixedLength(SizeOf(SmallInt));
        if ABuff <> nil then
          PSmallInt(pSrc)^ := PSmallInt(ABuff)^
        else
          PSmallInt(pSrc)^ := 0;
      end;
    dtInt32:
      begin
        ProcessFixedLength(SizeOf(Integer));
        if ABuff <> nil then
          PInteger(pSrc)^ := PInteger(ABuff)^
        else
          PInteger(pSrc)^ := 0;
      end;
    dtInt64:
      begin
        ProcessFixedLength(SizeOf(Int64));
        if ABuff <> nil then
          PInt64(pSrc)^ := PInt64(ABuff)^
        else
          PInt64(pSrc)^ := 0;
      end;
    dtByte:
      begin
        ProcessFixedLength(SizeOf(Byte));
        if ABuff <> nil then
          PByte(pSrc)^ := PByte(ABuff)^
        else
          PByte(pSrc)^ := 0;
      end;
    dtUInt16:
      begin
        ProcessFixedLength(SizeOf(Word));
        if ABuff <> nil then
          PWord(pSrc)^ := PWord(ABuff)^
        else
          PWord(pSrc)^ := 0;
      end;
    dtUInt32:
      begin
        ProcessFixedLength(SizeOf(Integer));
        if ABuff <> nil then
          PLongWord(pSrc)^ := PLongWord(ABuff)^
        else
          PLongWord(pSrc)^ := 0;
      end;
    dtUInt64:
      begin
        ProcessFixedLength(SizeOf(UInt64));
        if ABuff <> nil then
          PUInt64(pSrc)^ := PUInt64(ABuff)^
        else
          PUInt64(pSrc)^ := 0;
      end;
    dtSingle:
      begin
        ProcessFixedLength(SizeOf(Single));
        if ABuff <> nil then
          PSingle(pSrc)^ := PSingle(ABuff)^
        else
          PSingle(pSrc)^ := 0.0;
      end;
    dtDouble:
      begin
        ProcessFixedLength(SizeOf(Double));
        if ABuff <> nil then
          PDouble(pSrc)^ := PDouble(ABuff)^
        else
          PDouble(pSrc)^ := 0.0;
      end;
    dtExtended:
      begin
        ProcessFixedLength(SizeOf(Extended));
        if ABuff <> nil then
          PExtended(pSrc)^ := PExtended(ABuff)^
        else
          PExtended(pSrc)^ := 0.0;
      end;
    dtCurrency:
      begin
        ProcessFixedLength(SizeOf(Currency));
        if ABuff <> nil then
          PCurrency(pSrc)^ := PCurrency(ABuff)^
        else
          PCurrency(pSrc)^ := 0.0;
      end;
    dtBCD,
    dtFmtBCD:
      begin
        ProcessFixedLength(SizeOf(TADBcd));
        if ABuff <> nil then
          PADBcd(pSrc)^ := PADBcd(ABuff)^
        else
{$IFDEF AnyDAC_D6}
          PADBcd(pSrc)^ := NullBcd;
{$ELSE}
          ADFillChar(PADBcd(pSrc)^, SizeOf(TADBcd), 0);
{$ENDIF}
      end;
    dtDateTime:
      begin
        ProcessFixedLength(SizeOf(TADDateTimeData));
        if ABuff <> nil then
          if not lFetching and Table.Round2Scale and (oCol.Scale > 0) then
            PADDateTimeData(pSrc)^.DateTime := RoundDateTime(PADDateTimeData(ABuff)^.DateTime, oCol.Scale)
          else
            PADDateTimeData(pSrc)^ := PADDateTimeData(ABuff)^
        else
          PADDateTimeData(pSrc)^.DateTime := 0.0;
      end;
    dtDateTimeStamp:
      begin
        ProcessFixedLength(SizeOf(TADSQLTimeStamp));
        if ABuff <> nil then begin
          PADSQLTimeStamp(pSrc)^ := PADSQLTimeStamp(ABuff)^;
          if not lFetching and Table.Round2Scale and (oCol.Scale > 0) then
            RoundTimeStamp(PADSQLTimeStamp(pSrc)^, oCol.Scale);
        end
        else
{$IFDEF AnyDAC_D6}
          PADSQLTimeStamp(pSrc)^ := NullSQLTimeStamp;
{$ELSE}
          ADFillChar(PADSQLTimeStamp(pSrc)^, SizeOf(TADSQLTimeStamp), 0);
{$ENDIF}
      end;
    dtTimeIntervalFull,
    dtTimeIntervalYM,
    dtTimeIntervalDS:
      begin
        ProcessFixedLength(SizeOf(TADSQLTimeInterval));
        if ABuff <> nil then begin
          PADSQLTimeInterval(pSrc)^ := PADSQLTimeInterval(ABuff)^;
          if not lFetching and Table.Round2Scale and (oCol.Scale > 0) then
            RoundTimeInterval(PADSQLTimeInterval(pSrc)^, oCol.Scale);
        end
        else
          ADFillChar(PADSQLTimeInterval(pSrc)^, SizeOf(TADSQLTimeInterval), 0);
      end;
    dtTime:
      begin
        ProcessFixedLength(SizeOf(Longint));
        if ABuff <> nil then
          if not lFetching and Table.Round2Scale and (oCol.Scale > 0) then
            PLongint(pSrc)^ := RoundTime(PLongint(ABuff)^, oCol.Scale)
          else
            PLongint(pSrc)^ := PLongint(ABuff)^
        else
          PLongint(pSrc)^ := 0;
      end;
    dtDate:
      begin
        ProcessFixedLength(SizeOf(Longint));
        if ABuff <> nil then
          PLongint(pSrc)^ := PLongint(ABuff)^
        else
          PLongint(pSrc)^ := 0;
      end;
    dtAnsiString:
      begin
        ProcessVarLength;
        if ABuff <> nil then begin
          PWord(pSrc)^ := Word(ADataLen);
          Move(ABuff^, (pSrc + SizeOf(Word))^, ADataLen * SizeOf(TADAnsiChar));
          (pSrc + SizeOf(Word) + ADataLen * SizeOf(TADAnsiChar))^ := TADByte(#0);
        end
        else begin
          PWord(pSrc)^ := 0;
          (pSrc + SizeOf(Word))^ := TADByte(#0);
        end;
      end;
    dtByteString:
      begin
        ProcessVarLength;
        if ABuff <> nil then begin
          PWord(pSrc)^ := Word(ADataLen);
          Move(ABuff^, (pSrc + SizeOf(Word))^, ADataLen);
        end
        else
          PWord(pSrc)^ := 0;
      end;
    dtWideString:
      begin
        ProcessVarLength;
        if ABuff <> nil then begin
          PWord(pSrc)^ := Word(ADataLen);
          Move(ABuff^, (pSrc + SizeOf(Word))^, ADataLen * SizeOf(WideChar));
          pCh := pSrc + SizeOf(Word) + ADataLen * SizeOf(WideChar);
          pCh^ := TADByte(#0);
          (pCh + 1)^ := TADByte(#0);
        end
        else begin
          PWord(pSrc)^ := 0;
          pCh := PADByteString(pSrc) + SizeOf(Word);
          pCh^ := TADByte(#0);
          (pCh + 1)^ := TADByte(#0);
        end;
      end;
    dtGUID:
      begin
        ProcessFixedLength(SizeOf(TGUID));
        if ABuff <> nil then
          PGUID(pSrc)^ := PGUID(ABuff)^
        else
          PGUID(pSrc)^ := GUID_NULL;
      end;
    dtObject:
      begin
        ProcessFixedLength(SizeOf(IADDataStoredObject));
        if ABuff <> nil then
          PADDataStoredObject(pSrc)^ := PADDataStoredObject(ABuff)^
        else
          PADDataStoredObject(pSrc)^ := nil;
      end;
    dtRowSetRef,
    dtCursorRef,
    dtRowRef,
    dtArrayRef,
    dtParentRowRef:
      if ABuff <> nil then
        ErrorCantOperateInvObj;
    end;
    SetIsNull(pBuff, AColumn, lIsNull);
    if lFetching then
      SetFetched(AColumn, True);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.BeginDirectWriteBlob(AColumn: Integer; ABlobLen: Integer): PADByteString;
var
  pBuff: PByte;
  oCol: TADDatSColumn;

  procedure ErrorColMBBlob;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColMBBLob, [oCol.Name]);
  end;

begin
  ASSERT(Self <> nil);
  oCol := Table.Columns.ItemsI[AColumn];
  if not (caBlobData in oCol.Attributes) then
    ErrorColMBBlob;
  pBuff := CheckWrite(AColumn);
  Result := SetBlobData(pBuff, AColumn, nil, ABlobLen);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.EndDirectWriteBlob(AColumn: Integer; AFinalBlobLen: Integer = -1);
var
  pBuff: PByte;
begin
  if AFinalBlobLen <> -1 then begin
    pBuff := CheckWrite(AColumn);
    SetBlobData(pBuff, AColumn, nil, AFinalBlobLen);
  end;
  if Table.DataHandleMode in [lmHavyFetching, lmFetching, lmRefreshing] then
    SetFetched(AColumn, True);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetData(AColumn: TADDatSColumn; const AValue: Variant);
begin
  SetData(AColumn.Index, AValue);
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D6Base}
type
  EVariantTypeCastError = EVariantError;
{$ENDIF}

procedure TADDatSRow.SetData(AColumn: Integer; const AValue: Variant);
{$IFDEF AnyDAC_D6Base}
const
  SFloatFmt = '0.##################';
{$ENDIF}
var
  iLen: Integer;
  pData: Pointer;
  L: WordBool;
  iSB: ShortInt;
  i16: SmallInt;
  i32: Integer;
  i64: Int64;
  iB: Byte;
  iU16: Word;
  iU32: LongWord;
  iU64: UInt64;
  F: Single;
  D: Double;
  E: Extended;
  C: Currency;
  rBCD: TADBcd;
  T: TADSQLTimeStamp;
  TI: TADSQLTimeInterval;
  DT: TDateTime;
  MS: TADDateTimeData;
  SB: TADByteString;
  SW: TADWideString;
  S: String;
  lUnlock: Boolean;
  rGUID: TGUID;

{$IFDEF AnyDAC_FPC}
  // FPC fails to convert Variant TBcd to any of integer data types,
  // because system variant -> int does not handle custom variants
  function VBCD2Int: Int64;
  begin
    if VarIsFmtBCD(AValue) then
      Result := BCDToInteger(VarToBCD(AValue), True)
    else
      Result := AValue;
  end;
{$ENDIF}

  procedure TypeIncompatError(E: EVariantTypeCastError);
  var
    s: String;
  begin
    try
      s := AValue;
    except
      s := '<unknown>';
    end;
    ADException(Self, [S_AD_LDatS], er_AD_TypeIncompat,
      [s, Table.Columns.ItemsI[AColumn].Name, E.Message]);
  end;

begin
  iLen := 0;
  pData := nil;
  lUnlock := False;
  try
    try
      if not VarIsNull(AValue) and not VarIsEmpty(AValue) then
        case Table.Columns.ItemsI[AColumn].DataType of
        dtBoolean:
          begin
            L := AValue;
            pData := @L;
          end;
        dtSByte:
          begin
            iSB := {$IFDEF AnyDAC_FPC} VBCD2Int() {$ELSE} AValue {$ENDIF};
            pData := @iSB;
          end;
        dtInt16:
          begin
            i16 := {$IFDEF AnyDAC_FPC} VBCD2Int() {$ELSE} AValue {$ENDIF};
            pData := @i16;
          end;
        dtInt32:
          begin
            i32 := {$IFDEF AnyDAC_FPC} VBCD2Int() {$ELSE} AValue {$ENDIF};
            pData := @i32;
          end;
        dtInt64:
          begin
{$IFDEF AnyDAC_D6Base}
            i64 := {$IFDEF AnyDAC_FPC} VBCD2Int() {$ELSE} AValue {$ENDIF};
{$ELSE}
            if TVarData(AValue).VType = varInt64 then
              i64 := Decimal(AValue).lo64
            else begin
              i32 := AValue;
              i64 := i32;
            end;
{$ENDIF}
            pData := @i64;
          end;
        dtByte:
          begin
            iB := {$IFDEF AnyDAC_FPC} VBCD2Int() {$ELSE} AValue {$ENDIF};
            pData := @iB;
          end;
        dtUInt16:
          begin
            iU16 := {$IFDEF AnyDAC_FPC} VBCD2Int() {$ELSE} AValue {$ENDIF};
            pData := @iU16;
          end;
        dtUInt32:
          begin
            iU32 := {$IFDEF AnyDAC_FPC} VBCD2Int() {$ELSE} AValue {$ENDIF};
            pData := @iU32;
          end;
        dtUInt64:
          begin
{$IFDEF AnyDAC_D6Base}
            iU64 := {$IFDEF AnyDAC_FPC} VBCD2Int() {$ELSE} AValue {$ENDIF};
{$ELSE}
            if TVarData(AValue).VType = varInt64 then
              iU64 := Decimal(AValue).lo64
            else begin
              iU32 := AValue;
              iU64 := iU32;
            end;
{$ENDIF}
            pData := @iU64;
          end;
        dtSingle:
          begin
            F := AValue;
            pData := @F;
          end;
        dtDouble:
          begin
            D := AValue;
            pData := @D;
          end;
        dtExtended:
          begin
            E := AValue;
            pData := @E;
          end;
        dtCurrency:
          begin
            C := AValue;
            pData := @C;
          end;
        dtBCD,
        dtFmtBCD:
          begin
{$IFDEF AnyDAC_D6Base}
            case TVarData(AValue).VType of
              varSingle:
                rBCD := StrToBcd(FormatFloat(SFloatFmt, TVarData(AValue).VSingle));
              varDouble:
                rBCD := StrToBcd(FormatFloat(SFloatFmt, TVarData(AValue).VDouble));
              else
                rBCD := VarToBcd(AValue);
            end;
{$ELSE}
            CurrToBCD(AValue, rBCD);
{$ENDIF}
            pData := @rBCD;
          end;
        dtDateTime:
          begin
            DT := VarAsType(AValue, varDate);
            MS.DateTime := ADDateTime2MSecs(DT);
            pData := @MS;
          end;
        dtDateTimeStamp:
          begin
{$IFDEF AnyDAC_D6}
            T := ADVar2SQLTimeStamp(AValue);
{$ELSE}
            T := ADDateTime2SQLTimeStamp(AValue);
{$ENDIF}
            pData := @T;
          end;
        dtTimeIntervalFull,
        dtTimeIntervalYM,
        dtTimeIntervalDS:
          begin
{$IFDEF AnyDAC_D6}
            TI := ADVar2SQLTimeInterval(AValue);
{$ELSE}
            TI := ADStr2SQLTimeInterval(AValue);
{$ENDIF}
            pData := @TI;
          end;
        dtTime:
          begin
{$IFDEF AnyDAC_D6}
            i32 := ADSQLTimeStamp2Time(ADVar2SQLTimeStamp(AValue));
{$ELSE}
            i32 := ADDateTime2Time(AValue);
{$ENDIF}
            pData := @i32;
          end;
        dtDate:
          begin
{$IFDEF AnyDAC_D6}
            i32 := ADSQLTimeStamp2Date(ADVar2SQLTimeStamp(AValue));
{$ELSE}
            i32 := ADDateTime2Date(AValue);
{$ENDIF}
            pData := @i32;
          end;
        dtByteString,
        dtAnsiString,
        dtMemo,
        dtHMemo,
        dtBlob,
        dtHBlob,
        dtHBFile:
          if VarIsArray(AValue) then begin
            pData := VarArrayLock(AValue);
            lUnlock := True;
            iLen := VarArrayHighBound(AValue, 1) + 1;
          end
          else begin
            SB := TADEncoder.Enco({$IFNDEF AnyDAC_D6} VarToStr(AValue) {$ELSE} AValue {$ENDIF}, ecANSI);
            pData := PADByteString(SB);
            iLen := ADByteStrLength(SB);
          end;
        dtWideString,
        dtWideMemo,
        dtWideHMemo,
        dtXML:
          begin
            SW := AValue;
            pData := PWideChar(SW);
            iLen := Length(SW);
          end;
        dtRowSetRef,
        dtCursorRef,
        dtRowRef,
        dtArrayRef,
        dtParentRowRef:
          pData := nil;
        dtGUID:
          if VarIsArray(AValue) then begin
            pData := VarArrayLock(AValue);
            lUnlock := True;
            iLen := VarArrayHighBound(AValue, 1) + 1;
          end
          else begin
            S := AValue;
            rGUID := StringToGUID(S);
            pData := @rGUID;
            iLen := SizeOf(rGUID);
          end;
        dtObject:
          if VarType(AValue) = varUnknown then
            pData := @(TVarData(AValue).VUnknown);
        end;
      SetData(AColumn, pData, iLen);
    except
      on E: EVariantTypeCastError do
        TypeIncompatError(E);
    end;
  finally
    if lUnlock then
      VarArrayUnlock(AValue);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetValues(const AValues: array of Variant);
var
  i: Integer;
begin
  for i := Low(AValues) to High(AValues) do
    if not VarIsEmpty(AValues[i]) then
      SetData(i, AValues[i]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetValues(const ANames: String; const AValue: Variant);
var
  i, j: Integer;
begin
  if Pos(';', ANames) = 0 then
    SetData(Table.Columns.ItemsS[ANames], AValue)
  else begin
    i := 1;
    j := 0;
    while i <= Length(ANames) do begin
      SetData(Table.Columns.ItemsS[ADExtractFieldName(ANames, i)], AValue[j]);
      Inc(j);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetIsNull(ABuffer: PByte; AColumn: Integer; AValue: Boolean);
var
  oCols: TADDatSColumnList;
  pNullsByte: PByte;
begin
  oCols := Table.Columns;
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  pNullsByte := PByte(PADByteString(ABuffer) + oCols.NullOffsets[AColumn]);
  if AValue then
    pNullsByte^ := pNullsByte^ and not oCols.NullMasks[AColumn]
  else
    pNullsByte^ := pNullsByte^ or oCols.NullMasks[AColumn];
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetAsString(const AColumn: String): String;
begin
  Result := VarToStr(GetDataS(AColumn));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetAsString(const AColumn, AValue: String);
begin
  SetDataS(AColumn, AValue);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetFetched(const AColumn: Integer): Boolean;
var
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  Result := (PByte(PADByteString(Self) + oCols.FFetchedOffset + AColumn div 8)^
    and (1 shl (AColumn mod 8))) <> 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetFetched(const AColumn: Integer; const AValue: Boolean);
var
  oCols: TADDatSColumnList;
  pFetchedByte: PByte;
begin
  oCols := Table.Columns;
  ASSERT((AColumn >= 0) and (AColumn < oCols.Count));
  pFetchedByte := PByte(PADByteString(Self) + oCols.FFetchedOffset + AColumn div 8);
  if AValue then
    pFetchedByte^ := pFetchedByte^ or Byte(1 shl (AColumn mod 8))
  else
    pFetchedByte^ := pFetchedByte^ and not Byte(1 shl (AColumn mod 8));
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetRowError: EADException;
var
  pInfo: PADDataRowExtraInfo;
begin
  pInfo := GetRowInfo(False);
  if pInfo <> nil then
    Result := pInfo^.FRowException
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.SetRowError(const AValue: EADException): Boolean;
var
  pInfo: PADDataRowExtraInfo;
begin
  Result := False;
  pInfo := GetRowInfo(AValue <> nil);
  if pInfo <> nil then begin
    if pInfo^.FRowException <> nil then begin
      Result := True;
      ADFreeAndNil(pInfo^.FRowException);
    end;
    if AValue <> nil then
      AValue.Duplicate(pInfo^.FRowException)
    else
      CheckNoInfo;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetRowErrorPrc(const AValue: EADException);
begin
  SetRowError(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DBLock(ALockID: LongWord = $FFFFFFFF);
var
  pInfo: PADDataRowExtraInfo;
begin
  pInfo := GetRowInfo(True);
  if pInfo^.FLockID <> 0 then
    ADException(Self, [S_AD_LDatS], er_AD_RecLocked, []);
  pInfo^.FLockID := ALockID;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DBUnlock;
var
  pInfo: PADDataRowExtraInfo;
begin
  pInfo := GetRowInfo(False);
  if pInfo <> nil then begin
    if pInfo^.FLockID = 0 then
      ADException(Self, [S_AD_LDatS], er_AD_RecNotLocked, []);
    pInfo^.FLockID := 0;
    CheckNoInfo;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetDBLockID: LongWord;
var
  pInfo: PADDataRowExtraInfo;
begin
  pInfo := GetRowInfo(False);
  if pInfo <> nil then
    Result := pInfo^.FLockID
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetParentRow: TADDatSRow;
  procedure ErrorRowIsNotNested;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowIsNotNested, []);
  end;
var
  oCols: TADDatSColumnList;
begin
  oCols := Table.Columns;
  if oCols.ParentRowRefCol = -1 then
    ErrorRowIsNotNested;
  Result := GetInvariantObject(oCols.ParentRowRefCol) as TADDatSRow;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetParentRow(const ARow: TADDatSRow);
  procedure ErrorRowIsNotNested;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowIsNotNested, []);
  end;
  procedure ErrorCantSetParentRow;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantSetParentRow, []);
  end;
var
  oCols: TADDatSColumnList;
  oManager: TADDatSManager;
  oRel: TADDatSRelation;
  oParentCol: TADDatSColumn;
  oParentRow: TADDatSRow;
begin
  oCols := Table.Columns;
  oManager := Table.Manager;
  if (oCols.ParentRowRefCol = -1) or (oManager = nil) then
    ErrorRowIsNotNested;
  if ARow = nil then begin
    oParentRow := TADDatSRow(GetInvariantObject(oCols.ParentRowRefCol));
    if oParentRow = nil then
      Exit;
    oRel := oManager.Relations.FindRelation(oParentRow.Table, Table, True);
  end
  else begin
    oParentRow := TADDatSRow(GetInvariantObject(oCols.ParentRowRefCol));
    if oParentRow = ARow then
      Exit;
    oRel := oManager.Relations.FindRelation(ARow.Table, Table, True);
  end;
  if (oParentRow <> nil) and (ARow <> nil) or
     (oRel = nil) or
     (ARow <> nil) and (oRel.ParentTable <> ARow.Table) then
    ErrorCantSetParentRow;
  oParentCol := oRel.ParentColumns[0];
  if (RowState <> rsDestroying) and ((oParentRow = nil) or (oParentRow.RowState <> rsDestroying)) then begin
    CheckWrite(oCols.ParentRowRefCol);
    if ARow = nil then
      oParentRow.CheckWrite(oParentCol.Index)
    else
      ARow.CheckWrite(oParentCol.Index);
  end;
  SetInvariantObject(oCols.ParentRowRefCol, ARow);
  case oParentCol.DataType of
  dtRowSetRef,
  dtCursorRef:
    if ARow = nil then
      TADDatSNestedRowList(oParentRow.GetInvariantObject(oParentCol.Index)).Remove(Self)
    else
      TADDatSNestedRowList(ARow.GetInvariantObject(oParentCol.Index)).Add(Self);
  dtRowRef,
  dtArrayRef:
    if ARow = nil then
      oParentRow.SetInvariantObject(oParentCol.Index, nil)
    else
      ARow.SetInvariantObject(oParentCol.Index, Self);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetNestedRow(const AColumn: Integer): TADDatSRow;
var
  oCol: TADDatSColumn;

  procedure ErrorColIsNotRef;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColumnIsNotRef, [oCol.Name]);
  end;

begin
  oCol := Table.Columns.ItemsI[AColumn];
  if not (oCol.DataType in [dtRowRef, dtArrayRef]) then
    ErrorColIsNotRef;
  Result := GetInvariantObject(AColumn) as TADDatSRow;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SetNestedRow(const AColumn: Integer; const ARow: TADDatSRow);
var
  oCol: TADDatSColumn;

  procedure ErrorColIsNotRef;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColumnIsNotRef, [oCol.Name]);
  end;

begin
  oCol := Table.Columns.ItemsI[AColumn];
  if not (oCol.DataType in [dtRowRef, dtArrayRef]) then
    ErrorColIsNotRef;
  ARow.SetParentRow(Self);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.GetNestedRows(const AColumn: Integer): TADDatSNestedRowList;
var
  oCol: TADDatSColumn;

  procedure ErrorColIsNotSetRef;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_ColumnIsNotSetRef, [oCol.Name]);
  end;

begin
  oCol := Table.Columns.ItemsI[AColumn];
  if not (oCol.DataType in [dtRowSetRef, dtCursorRef]) then
    ErrorColIsNotSetRef;
  Result := GetInvariantObject(AColumn) as TADDatSNestedRowList;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.ConstrainChildRow(AProposedState: TADDatSRowState);
  procedure ErrorRowCantInsert;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_RowCantBeInserted, []);
  end;
var
  oParentRow: TADDatSRow;
begin
  if not (Table.DataHandleMode in [lmStandard, lmRefreshing]) or
     (Table.Columns.ParentRowRefCol = -1) then
    Exit;
  oParentRow := ParentRow;
  if AProposedState = rsInserted then
    if (oParentRow = nil) or (oParentRow.RowState in [rsInitializing, rsDetached, rsDeleted]) then
      ErrorRowCantInsert;
  if (oParentRow <> nil) and (oParentRow.RowState = rsUnchanged) then
    oParentRow.BeginEdit;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.ProcessNestedRows(AMethod: TADDatSProcessNestedRowsMethod);
var
  oCols: TADDatSColumnList;
  oNestedRows: TADDatSNestedRowList;
  oNestedRow: TADDatSRow;
  i, j: Integer;
begin
  oCols := Table.Columns;
  if ctInvars in oCols.FHasThings then
    for i := 0 to oCols.Count - 1 do
      case oCols.ItemsI[i].DataType of
      dtRowSetRef, dtCursorRef:
        begin
          oNestedRows := NestedRows[i];
          for j := oNestedRows.Count - 1 downto 0 do begin
            oNestedRow := oNestedRows.ItemsI[j];
            if oNestedRow <> nil then
              AMethod(oNestedRow);
          end;
        end;
      dtRowRef, dtArrayRef:
        begin
          oNestedRow := NestedRow[i];
          if oNestedRow <> nil then
            AMethod(oNestedRow);
        end;
      end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNRDelete(ARow: TADDatSRow);
begin
  ARow.Delete;
end;

procedure TADDatSRow.DoNRDetache(ARow: TADDatSRow);
begin
  ARow.Delete(True);
end;

procedure TADDatSRow.DoNREndModify(ARow: TADDatSRow);
begin
  case ARow.RowState of
  rsEditing:  ARow.EndEdit;
  rsInitializing,
  rsDetached: ARow.Table.Rows.Add(ARow);
  end;
end;

procedure TADDatSRow.ConstrainParentRow(AProposedState: TADDatSRowState);
begin
  if not (Table.DataHandleMode in [lmStandard, lmRefreshing]) then
    Exit;
  case AProposedState of
  rsInitializing,
  rsDetached:             ProcessNestedRows(DoNRDetache);
  rsDeleted:              ProcessNestedRows(DoNRDelete);
  rsInserted, rsModified: ProcessNestedRows(DoNREndModify);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNRCancel(ARow: TADDatSRow);
begin
  if ARow.RowState = rsEditing then
    ARow.CancelEdit;
end;

procedure TADDatSRow.CancelNestedRows;
begin
  ProcessNestedRows(DoNRCancel);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNRFree(ARow: TADDatSRow);
begin
  ADFree(ARow);
end;

procedure TADDatSRow.ClearNestedRows;
begin
  ProcessNestedRows(DoNRFree);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNRAcceptChanges(ARow: TADDatSRow);
begin
  ARow.AcceptChanges;
end;

procedure TADDatSRow.AcceptNestedChanges;
begin
  ProcessNestedRows(DoNRAcceptChanges);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNRClearErrors(ARow: TADDatSRow);
begin
  ARow.ClearErrors;
end;

procedure TADDatSRow.ClearNestedErrors;
begin
  ProcessNestedRows(DoNRClearErrors);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.DoNRRejectChanges(ARow: TADDatSRow);
begin
  ARow.RejectChanges;
end;

procedure TADDatSRow.RejectNestedChanges;
begin
  ProcessNestedRows(DoNRRejectChanges);
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.DumpCol(AColumn: Integer; AWithColNames: Boolean;
  AVersion: TADDatSRowVersion): String;
var
  V: Variant;
begin
  case Table.Columns[AColumn].DataType of
  dtRowSetRef:
    Result := '<rowset>';
  dtCursorRef:
    Result := '<cursor>';
  dtRowRef:
    Result := '(' + NestedRow[AColumn].DumpRow(AWithColNames, AVersion) + ')';
  dtArrayRef:
    Result := '(' + NestedRow[AColumn].DumpRow(False, AVersion) + ')';
  dtParentRowRef:
    Result := '<parent>';
  else
    V := GetData(AColumn, AVersion);
    if VarIsNull(V) then
      Result := '<null>'
{$IFDEF AnyDAC_D6}
    else if Table.Columns[AColumn].DataType in [dtDateTime, dtDateTimeStamp] then
      Result := SQLTimeStampToStr('yyyy-mm-dd hh:nn:ss.zzz', VarToSQLTimeStamp(V))
{$ENDIF}
    else if Table.Columns[AColumn].DataType <> dtTime then
      Result := VarToStr(V)
    else
      Result := TimeToStr(VarAsType(V, varDate));
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRow.DumpRow(AWithColNames: Boolean; AVersion: TADDatSRowVersion): String;
var
  i: Integer;
begin
  if AWithColNames then
    Result := Table.Name + ': '
  else
    Result := '';
  for i := 0 to Table.Columns.Count - 1 do begin
    if i > 0 then
      Result := Result + '; ';
    if AWithColNames then
      Result := Result + Table.Columns[i].Name + ': ';
    Result := Result + DumpCol(i, AWithColNames, AVersion);
  end;
end;

{-------------------------------------------------------------------------------}
class function TADDatSRow.GetStreamingName(AStorage: TADStorage): String;
begin
  if (AStorage <> nil) and
     (AStorage.StreamVersion <= 4) and (AStorage.StreamVersion > 2) then
    Result := 'DatSRow'
  else
    Result := 'Row';
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.LoadRowVersion(AStorage: TADStorage; const AName: String;
  var ABuff: PByte; ABuffKind: TADDatSRowState);
var
  iPriorRowState: TADDatSRowState;

  procedure LoadTypes(ATypes: TADDataTypes);
  var
    i: Integer;
    pBuff: Pointer;
    iLen: LongWord;
    oCols: TADDatSColumnList;
    oCol: TADDatSColumn;
  begin
    oCols := Table.Columns;
    for i := 0 to oCols.Count - 1 do begin
      oCol := oCols.ItemsI[i];
      if oCol.DataType in ATypes then
        if AStorage.ReadValue(oCol.Name, i, oCol.DataType, pBuff, iLen) then
          SetData(i, pBuff, iLen);
    end;
  end;

begin
  if not AStorage.TestObject(AName) then begin
    if ABuff <> nil then
      FreeBuffer(ABuff);
    Exit;
  end;
  AStorage.ReadObjectBegin(AName);
  iPriorRowState := RowState;
  FRowState := ABuffKind;
  try
    if ABuff <> nil then
      CleanupBuffer(ABuff)
    else
      ABuff := AllocBuffer;
    LoadTypes(C_AD_AllTypes - C_AD_BlobTypes - [dtByteString]);
    LoadTypes(C_AD_BlobTypes + [dtByteString]);
  finally
    FRowState := iPriorRowState;
    AStorage.ReadObjectEnd(AName);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.InternalLoadFromStorage(AStorage: TADStorage);
begin
  inherited InternalLoadFromStorage(AStorage);
  FRowID := AStorage.ReadLongWord('RowID', $FFFFFFFF);
  FRowState := TADDatSRowState(AStorage.ReadEnum('RowState',
    TypeInfo(TADDatSRowState), Integer(rsDetached)));
  FRowPriorState := TADDatSRowState(AStorage.ReadEnum('RowPriorState',
    TypeInfo(TADDatSRowState), Integer(rsDetached)));
  if AStorage.TestObject('Exception') then begin
    AStorage.ReadObjectBegin('Exception');
    try
      RowError := AStorage.LoadObject as EADException;
    finally
      AStorage.ReadObjectEnd('Exception');
    end;
  end;
  LoadRowVersion(AStorage, 'Original', FpOriginal, rsImportingOriginal);
  LoadRowVersion(AStorage, 'Current', FpCurrent, rsImportingCurent);
  LoadRowVersion(AStorage, 'Proposed', FpProposed, rsImportingProposed);
  { TODO -cDATS : Nested columns }
  { TODO -cDATS : Columns Fetched flag }
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.SaveRowVersion(AStorage: TADStorage; const AName: String;
  ABuff: PByte; ABuffKind: TADDatSRowState);
var
  iPriorRowState: TADDatSRowState;

  procedure WriteTypes(ATypes: TADDataTypes);
  var
    i: Integer;
    pBuff: Pointer;
    iLen: LongWord;
    oCols: TADDatSColumnList;
    oCol: TADDatSColumn;
  begin
    oCols := Table.Columns;
    for i := 0 to oCols.Count - 1 do begin
      pBuff := nil;
      iLen := 0;
      oCol := oCols.ItemsI[i];
      if (oCol.DataType in ATypes) and GetData(i, rvDefault, pBuff, 0, iLen, False) then
        AStorage.WriteValue(oCol.Name, i, oCol.DataType, pBuff, iLen);
    end;
  end;

begin
  if ABuff = nil then
    Exit;
  AStorage.WriteObjectBegin(AName);
  iPriorRowState := RowState;
  FRowState := ABuffKind;
  try
    WriteTypes(C_AD_AllTypes - C_AD_BlobTypes - [dtByteString]);
    WriteTypes(C_AD_BlobTypes + [dtByteString]);
  finally
    FRowState := iPriorRowState;
    AStorage.WriteObjectEnd(AName);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRow.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  AStorage.WriteLongWord('RowID', Integer(RowID), $FFFFFFFF);
  AStorage.WriteEnum('RowState', TypeInfo(TADDatSRowState),
    Integer(RowState), Integer(rsDetached));
  AStorage.WriteEnum('RowPriorState', TypeInfo(TADDatSRowState),
    Integer(RowPriorState), Integer(rsDetached));
  if FExtraInfo <> nil then begin
    AStorage.WriteObjectBegin('Exception');
    try
      AStorage.SaveObject(FExtraInfo^.FRowException);
    finally
      AStorage.WriteObjectEnd('Exception');
    end;
  end;
  SaveRowVersion(AStorage, 'Original', FpOriginal, rsImportingOriginal);
  SaveRowVersion(AStorage, 'Current', FpCurrent, rsImportingCurent);
  SaveRowVersion(AStorage, 'Proposed', FpProposed, rsImportingProposed);
  { TODO -cDATS : Nested columns }
  { TODO -cDATS : Columns Fetched flag }
end;

{-------------------------------------------------------------------------------}
{- TADDatSRowListBase                                                          -}
{-------------------------------------------------------------------------------}
constructor TADDatSRowListBase.Create;
begin
  inherited Create;
  FDefaultReason := srDataChange;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.HandleNotification(AParam: PADDatSNotifyParam);
begin
  // MSGOPT nothing - just exit
  // inherited HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListBase.Add(ARow: TADDatSRow): Integer;
begin
  Result := AddObject(ARow);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.AddAt(ARow: TADDatSRow; AIndex: Integer);
begin
  AddObjectAt(ARow, AIndex);
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListBase.GetItemsI(AIndex: Integer): TADDatSRow;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSRow(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListBase.GetLast: TADDatSRow;
begin
  ASSERT(FCount > 0);
  Result := TADDatSRow(FArray[FCount - 1]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.InternalSort1(L, R: Integer;
  ACompareRowsProc: TADCompareRowsProc; AOpts: TADCompareDataOptions);
var
  I, J: Integer;
  P, T: TADDatSRow;
begin
  if R - L > 4 then begin
    I := (R + L) div 2;
    if ACompareRowsProc(TADDatSRow(FArray[L]), TADDatSRow(FArray[I]), -1, AOpts) > 0 then begin
      T := TADDatSRow(FArray[I]);
      FArray[I] := FArray[L];
      FArray[L] := T;
    end;
    if ACompareRowsProc(TADDatSRow(FArray[L]), TADDatSRow(FArray[R]), -1, AOpts) > 0 then begin
      T := TADDatSRow(FArray[R]);
      FArray[R] := FArray[L];
      FArray[L] := T;
    end;
    if ACompareRowsProc(TADDatSRow(FArray[I]), TADDatSRow(FArray[R]), -1, AOpts) > 0 then begin
      T := TADDatSRow(FArray[R]);
      FArray[R] := FArray[I];
      FArray[I] := T;
    end;
    J := R - 1;
    T := TADDatSRow(FArray[J]);
    FArray[J] := FArray[I];
    FArray[I] := T;
    I := L;
    P := TADDatSRow(FArray[J]);
    while True do begin
      Inc(I);
      Dec(J);
      while (I <= R) and (ACompareRowsProc(TADDatSRow(FArray[I]), P, -1, AOpts) < 0) do
        Inc(I);
      while (J >= L) and (ACompareRowsProc(TADDatSRow(FArray[J]), P, -1, AOpts) > 0) do
        Dec(J);
      if J < I then
        Break;
      T := TADDatSRow(FArray[J]);
      FArray[J] := FArray[I];
      FArray[I] := T;
    end;
    if I <= R then begin
      T := TADDatSRow(FArray[R - 1]);
      FArray[R - 1] := FArray[I];
      FArray[I] := T;
    end;
    InternalSort1(L, J, ACompareRowsProc, AOpts);
    InternalSort1(I + 1, R, ACompareRowsProc, AOpts);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.InternalSort2(L, H: Integer;
  ACompareRowsProc: TADCompareRowsProc; AOpts: TADCompareDataOptions);
var
  I, J: Integer;
  P: TADDatSRow;
begin
  for I := L + 1 to H do begin
    P := TADDatSRow(FArray[I]);
    J := I;
    while (J > L) and (ACompareRowsProc(TADDatSRow(FArray[J - 1]), P, -1, AOpts) > 0) do begin
      FArray[J] := FArray[J - 1];
      Dec(J);
    end;
    FArray[J] := P;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.InternalSort(L, R: Integer;
  ACompareRowsProc: TADCompareRowsProc; AOpts: TADCompareDataOptions);
begin
  InternalSort1(L, R, ACompareRowsProc, AOpts);
  InternalSort2(L, R, ACompareRowsProc, AOpts);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.Sort(ACompareRowsProc: TADCompareRowsProc;
  AOpts: TADCompareDataOptions);
begin
  if Count > 1 then
    InternalSort(0, Count - 1, ACompareRowsProc, AOpts);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.CheckDuplicates(ACompareRowsProc:
  TADCompareRowsProc; AOpts: TADCompareDataOptions);
  procedure ErrorDubRows;
  var
    sName: String;
  begin
    if (Owner <> nil) and (Owner is TADDatSNamedObject) then
      sName := TADDatSNamedObject(Owner).Name
    else
      sName := '';
    ADException(Self, [S_AD_LDatS], er_AD_DuplicateRows, [sName, 1]);
  end;
var
  i: Integer;
begin
  ASSERT(Assigned(ACompareRowsProc));
  AOpts := AOpts + [coNullsNotEqual] - [coNoSymbols];
  for i := 1 to Count - 1 do
    if ACompareRowsProc(ItemsI[i - 1], ItemsI[i], -1, AOpts) = 0 then
      ErrorDubRows;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListBase.RemoveDuplicates(ACompareRowsProc:
  TADCompareRowsProc; AColumnCount: Integer; AOpts: TADCompareDataOptions);
var
  i: Integer;
begin
  ASSERT(Assigned(ACompareRowsProc));
  for i := Count - 1 downto 1 do
    if ACompareRowsProc(ItemsI[i - 1], ItemsI[i], AColumnCount, AOpts) = 0 then
      RemoveAt(i);
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListBase.GetValuesList(const AColumnName, ADelimiter, ANullName: String): String;
var
  i: Integer;
  v: Variant;
  s: String;
begin
  Result := '';
  for i := 0 to Count - 1 do begin
    if i > 0 then
      Result := Result + ADelimiter;
    v := ItemsI[i].GetData(AColumnName);
    if VarIsNull(v) then
      s := ANullName
    else
      s := v;
    Result := Result + s;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListBase.DumpCol(ACol: Integer; AWithColNames: Boolean): String;
var
  s: String;
begin
  s := Table.Columns.ItemsI[ACol].Name;
  if AWithColNames then
    Result := s + ': ';
  Result := Result + GetValuesList(s, '; ', '<null>');
end;

{-------------------------------------------------------------------------------}
{ TADDatSRowListWithAggregates                                                  }
{-------------------------------------------------------------------------------}
type
  TADAggVals = array [0 .. 1023] of TADDatSAggregateValue;
  PADAggVals = ^TADAggVals;

constructor TADDatSRowListWithAggregates.Create;
begin
  inherited Create;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSRowListWithAggregates.Destroy;
begin
  if FAggregateValues <> nil then begin
    DeleteAggregates;
    ADFreeAndNil(FAggregateValues);
    ADFreeAndNil(FAggregateSlots);
  end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.RemoveAggregatesRow(ARowIndex: Integer);
var
  j: Integer;
  pAggs: PADAggVals;
begin
  ASSERT(FAggregateValues <> nil);
  pAggs := PADAggVals(FAggregateValues[ARowIndex]);
  if pAggs <> nil then begin
    for j := 0 to FAggregateSlotUsed - 1 do
      if pAggs^[j] <> nil then begin
        pAggs^[j].RemRef;
        pAggs^[j] := nil;
      end;
    FreeMem(pAggs, FAggregateSlotAllocated * SizeOf(TADDatSAggregateValue));
    FAggregateValues[ARowIndex] := nil;
  end;
  FAggregateValues.Delete(ARowIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.AddAggregatesRow(ARowIndex: Integer);
var
  pAggs: PADAggVals;
begin
  ASSERT(FAggregateValues <> nil);
  if ARowIndex = -1 then
    ARowIndex := FAggregateValues.Count;
  GetMem(pAggs, FAggregateSlotAllocated * SizeOf(TADDatSAggregateValue));
  ADFillChar(pAggs^, FAggregateSlotAllocated * SizeOf(TADDatSAggregateValue), 0);
  FAggregateValues.Insert(ARowIndex, pAggs);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.AddObjectAt(AObj: TADDatSObject;
  AIndex: Integer);
begin
  inherited AddObjectAt(AObj, AIndex);
  if FAggregateSlotAllocated > 0 then
    AddAggregatesRow(AIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.RemoveAt(AIndex: Integer;
  ANotDestroy: Boolean);
begin
  inherited RemoveAt(AIndex, ANotDestroy);
  if FAggregateSlotAllocated > 0 then
    RemoveAggregatesRow(AIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.DeleteAggregates;
var
  i: Integer;
begin
  if FAggregateValues <> nil then begin
    for i := FAggregateValues.Count - 1 downto 0 do
      RemoveAggregatesRow(i);
    for i := 0 to FAggregateSlots.Size - 1 do
      FAggregateSlots.Bits[i] := False;
    FAggregateSlotAllocated := 0;
    FAggregateSlotUsed := 0;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.ClearAggregate(AIndex: Integer);
var
  i: Integer;
  pAggs: PADAggVals;
begin
  ASSERT(FAggregateValues <> nil);
  for i := 0 to FAggregateValues.Count - 1 do begin
    pAggs := PADAggVals(FAggregateValues[i]);
    if (pAggs <> nil) and (pAggs^[AIndex] <> nil) then begin
      pAggs^[AIndex].RemRef;
      pAggs^[AIndex] := nil;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.DeleteAggregate(var AIndex: Integer);
begin
  try
    ClearAggregate(AIndex);
  finally
    FAggregateSlots.Bits[AIndex] := False;
    if AIndex = FAggregateSlotUsed - 1 then
      Dec(FAggregateSlotUsed);
    AIndex := -1;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListWithAggregates.AllocateAggregate: Integer;
var
  i, j: Integer;
  pAggs: PADAggVals;

  procedure ErrorTooManyAggs;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_TooManyAggs, []);
  end;

begin
  if FAggregateSlots = nil then begin
    FAggregateSlots := TBits.Create;
    FAggregateSlots.Size := C_AD_MaxAggsPerView;
    FAggregateValues := TADPtrList.Create;
  end;
  Result := FAggregateSlots.OpenBit;
  if Result = FAggregateSlots.Size then
    ErrorTooManyAggs;
  FAggregateSlots.Bits[Result] := True;
  while FAggregateValues.Count < Count do
    FAggregateValues.Add(nil);
  if Result >= FAggregateSlotAllocated then begin
    for i := 0 to Count - 1 do begin
      pAggs := PADAggVals(FAggregateValues[i]);
      ReallocMem(pAggs, (Result + 4) * SizeOf(TADDatSAggregateValue));
      FAggregateValues[i] := pAggs;
      for j := FAggregateSlotAllocated to Result + 4 - 1 do
        Pointer(pAggs^[j]) := nil;
    end;
    FAggregateSlotAllocated := Result + 4;
  end;
  for i := 0 to Count - 1 do
    PADAggVals(FAggregateValues[i])^[Result] := nil;
  if Result >= FAggregateSlotUsed then
    FAggregateSlotUsed := Result + 1;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.AttachAggregate(ARowIndex,
  AValIndex: Integer; AObj: TADDatSAggregateValue);
begin
  ASSERT(FAggregateValues <> nil);
  AObj.AddRef;
  PADAggVals(FAggregateValues[ARowIndex])^[AValIndex] := AObj;
end;

{-------------------------------------------------------------------------------}
function TADDatSRowListWithAggregates.FetchAggregate(ARowIndex,
  AValIndex: Integer): TADDatSAggregateValue;
begin
  ASSERT(FAggregateValues <> nil);
  Result := PADAggVals(FAggregateValues[ARowIndex])^[AValIndex];
end;

{-------------------------------------------------------------------------------}
procedure TADDatSRowListWithAggregates.DetachAggregate(ARowIndex,
  AValIndex: Integer);
var
  oObj: TADDatSAggregateValue;
begin
  ASSERT(FAggregateValues <> nil);
  oObj := FetchAggregate(ARowIndex, AValIndex);
  oObj.RemRef;
  PADAggVals(FAggregateValues[ARowIndex])^[AValIndex] := nil;
end;

{-------------------------------------------------------------------------------}
{ TADDatSAggregateValue                                                         }
{-------------------------------------------------------------------------------}
constructor TADDatSAggregateValue.Create(ASubAggregateCnt: Integer);
begin
  inherited Create;
  FRefs := TADRefCounter.Create(Self);
  FRefs.CountRef;
  SetLength(FSubValues, ASubAggregateCnt);
  Clear;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSAggregateValue.CreateCopy(AValue: TADDatSAggregateValue);
var
  i: Integer;
begin
  Create(Length(AValue.FSubValues));
  FValue := AValue.Value;
  for i := 0 to Length(AValue.FSubValues) - 1 do
    FSubValues[i] := AValue.FSubValues[i];
end;

{-------------------------------------------------------------------------------}
destructor TADDatSAggregateValue.Destroy;
begin
  ADFreeAndNil(FRefs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateValue.Clear;
var
  i: Integer;
begin
  for i := 0 to Length(FSubValues) - 1 do
    FSubValues[i] := Null;
  FValue := Null;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateValue.AddRef;
begin
  FRefs.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateValue.RemRef;
begin
  FRefs.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateValue.GetRefs: Integer;
begin
  Result := FRefs.Refs;
end;

{-------------------------------------------------------------------------------}
{ TADDatSAggregateExpressionDS                                                  }
{-------------------------------------------------------------------------------}
type
  TADDatSAggregateExpressionDS = class(TADDatSTableExpressionDS)
  private
    FView: TADDatSView;
    FAggregate: TADDatSAggregate;
  protected
    function GetVarIndex(const AName: String): Integer; override;
    function GetVarType(AIndex: Integer): TADDataType; override;
    function GetVarScope(AIndex: Integer): TADExpressionScopeKind; override;
    function GetVarData(AIndex: Integer): Variant; override;
    function GetSubAggregateValue(AIndex: Integer): Variant; override;
    function GetRowNum: Integer; override;
  public
    constructor Create(AView: TADDatSView; AAggregate: TADDatSAggregate);
  end;

{-------------------------------------------------------------------------------}
constructor TADDatSAggregateExpressionDS.Create(AView: TADDatSView; AAggregate: TADDatSAggregate);
begin
  inherited Create(AView.Table);
  FView := AView;
  FAggregate := AAggregate;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateExpressionDS.GetRowNum: Integer;
begin
  Result := FView.Rows.IndexOf(FRow) + 1;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateExpressionDS.GetSubAggregateValue(AIndex: Integer): Variant;
begin
  Result := FAggregate.GetSubAggregateValue(AIndex);
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateExpressionDS.GetVarIndex(const AName: String): Integer;
begin
  Result := inherited GetVarIndex(AName);
  if Result = -1 then begin
    Result := FView.Aggregates.IndexOfName(AName);
    if Result <> -1 then
      Result := FTable.Columns.Count + Result;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateExpressionDS.GetVarType(AIndex: Integer): TADDataType;
begin
  if AIndex < FTable.Columns.Count then
    Result := inherited GetVarType(AIndex)
  else
    Result := FView.Aggregates.ItemsI[AIndex - FTable.Columns.Count].DataType;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateExpressionDS.GetVarScope(AIndex: Integer): TADExpressionScopeKind;
begin
  if AIndex < FTable.Columns.Count then
    Result := inherited GetVarScope(AIndex)
  else
    Result := ckAgg;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateExpressionDS.GetVarData(AIndex: Integer): Variant;
begin
  if AIndex < FTable.Columns.Count then
    Result := inherited GetVarData(AIndex)
  else
    Result := FView.Aggregates.ItemsI[AIndex - FTable.Columns.Count].Value[FView.Rows.IndexOf(FRow)];
end;

{-------------------------------------------------------------------------------}
{ TADDatSAggregate                                                              }
{-------------------------------------------------------------------------------}
constructor TADDatSAggregate.Create;
begin
  inherited Create;
  FValueIndex := -1;
  FRefs := TADRefCounter.Create(Self);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSAggregate.Create(const AName, AExpression: String;
  AGroupingLevel: Integer);
begin
  Create;
  if AName <> '' then
    Name := AName;
  Expression := AExpression;
  GroupingLevel := AGroupingLevel;
  Active := True;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSAggregate.Destroy;
begin
  Unprepare;
  ADFreeAndNil(FRefs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.Assign(AObj: TADDatSObject);
begin
  inherited Assign(AObj);
  if AObj is TADDatSAggregate then begin
    Expression := TADDatSAggregate(AObj).Expression;
    GroupingLevel := TADDatSAggregate(AObj).GroupingLevel;
    Active := TADDatSAggregate(AObj).Active;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := (Expression = TADDatSAggregate(AObj).Expression) and
      (GroupingLevel = TADDatSAggregate(AObj).GroupingLevel) and
      (Active = TADDatSAggregate(AObj).Active);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.CountRef(AInit: Integer = 1);
begin
  FRefs.CountRef(AInit);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.AddRef;
begin
  FRefs.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.RemRef;
begin
  FRefs.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetIsRefCounted: Boolean;
begin
  Result := FRefs.Refs >= 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.CheckActiveChanged;
begin
  if FPrevActualActive <> ActualActive then begin
    Unprepare;
    FPrevActualActive := ActualActive;
    if FPrevActualActive then
      Update;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.SetActive(const AValue: Boolean);
begin
  if FActive <> AValue then begin
    FActive := AValue;
    CheckActiveChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.DoListInserted;
begin
  CheckActiveChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.DoListRemoving;
begin
  Active := False;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetActualActive: Boolean;
var
  oView: TADDatSView;
begin
  oView := View;
  Result := Active and (oView <> nil) and oView.ActualActive;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetView: TADDatSView;
begin
  Result := TADDatSView(GetOwnerByClass(TADDatSView));
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetRows: TADDatSRowListWithAggregates;
var
  oView: TADDatSView;
begin
  oView := View;
  if oView <> nil then
    Result := TADDatSViewRowList(oView.Rows)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetSortMech: IADDatSMechSort;
var
  oView: TADDatSView;
begin
  oView := View;
  if oView <> nil then
    Result := oView.SortingMechanism
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.SetExpression(const AValue: String);
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    FActive := False;
    CheckActiveChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.SetGroupingLevel(const AValue: Integer);
begin
  ASSERT(AValue >= 0);
  if FGroupingLevel <> AValue then begin
    FGroupingLevel := AValue;
    FActive := False;
    CheckActiveChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.Unprepare;
var
  oRows: TADDatSRowListWithAggregates;
begin
  if agPrepared in FState then
    try
      oRows := Rows;
      if oRows <> nil then
        oRows.DeleteAggregate(FValueIndex);
      SetLength(FSubAggregates, 0);
      FEvaluator := nil;
    finally
      FState := [];
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.Prepare;
  procedure TooMuchGrouping;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_GrpLvlExceeds, [Name]);
  end;
var
  i: Integer;
  oRows: TADDatSRowListWithAggregates;
  oSortMech: IADDatSMechSort;
  oParser: IADStanExpressionParser;
begin
  if not (agPrepared in FState) then begin
    FState := [];
    oRows := Rows;
    oSortMech := SortMech;
    if oSortMech <> nil then
      case oSortMech.SortSource of
      ssExpression:
        if 1 < FGroupingLevel then
          TooMuchGrouping;
      ssRowId:
        if 0 < FGroupingLevel then
          TooMuchGrouping;
      ssColumns:
        if oSortMech.SortColumnList.Count < FGroupingLevel then
          TooMuchGrouping;
      end
    else if FGroupingLevel > 0 then
      TooMuchGrouping;
    try
      ADCreateInterface(IADStanExpressionParser, oParser);
      FEvaluator := oParser.Prepare(TADDatSAggregateExpressionDS.Create(View, Self),
        Expression, [], [poAggregate, poDefaultExpr], '');
      SetLength(FSubAggregates, FEvaluator.SubAggregateCount);
      FSubAggregateValues := 0;
      for i := 0 to FEvaluator.SubAggregateCount - 1 do begin
        FSubAggregates[i].FKind := FEvaluator.SubAggregateKind[i];
        FSubAggregates[i].FValueIndex := FSubAggregateValues;
        Inc(FSubAggregateValues);
        case FSubAggregates[i].FKind of
        akAvg:
          begin
            FSubAggregates[i].FCountIndex := FSubAggregateValues;
            Inc(FSubAggregateValues);
          end;
        akMin, akMax:
          begin
            FSubAggregates[i].FCountIndex := -1;
            Include(FState, agMinMax);
          end;
        else
          FSubAggregates[i].FCountIndex := -1;
        end;
      end;
      FValueIndex := oRows.AllocateAggregate;
    except
      FEvaluator := nil;
      SetLength(FSubAggregates, 0);
      if FValueIndex <> -1 then
        oRows.DeleteAggregate(FValueIndex);
      raise;
    end;
    Include(FState, agPrepared);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.Recalc;
begin
  if ActualActive then
    CalcAll
  else
    Exclude(FState, agActual);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.Update;
begin
  if not (agActual in FState) and ActualActive then
    CalcAll;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.IncAggVals(AKind: TADAggregateKind;
  const AVal: Variant; var AAggVal, AAggCnt: Variant);
begin
  case AKind of
  akSum:
    if VarIsNull(AAggVal) then
      AAggVal := AVal
    else if not VarIsNull(AVal) then
      AAggVal := ADFixFMTBcdAdd(AAggVal, AVal);
  akAvg:
    begin
      if VarIsNull(AAggVal) then
        AAggVal := AVal
      else if not VarIsNull(AVal) then
        AAggVal := ADFixFMTBcdAdd(AAggVal, AVal);
      if not VarIsNull(AVal) then
        if VarIsNull(AAggCnt) then
          AAggCnt := 1
        else
          AAggCnt := AAggCnt + 1;
    end;
  akCount:
    if not VarIsNull(AVal) then
      if VarIsNull(AAggVal) then
        AAggVal := 1
      else
        AAggVal := AAggVal + 1;
  akMin:
    if VarIsNull(AAggVal) then
      AAggVal := AVal
    else if not VarIsNull(AVal) and (AAggVal > AVal) then
      AAggVal := AVal;
  akMax:
    if VarIsNull(AAggVal) then
      AAggVal := AVal
    else if not VarIsNull(AVal) and (AAggVal < AVal) then
      AAggVal := AVal;
  akFirst:
    if VarIsNull(AAggVal) then
      if not VarIsNull(AVal) then
        AAggVal := AVal;
  akLast:
    if not VarIsNull(AVal) then
      AAggVal := AVal;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.DecAggVals(AKind: TADAggregateKind;
  const AVal: Variant; var AAggVal, AAggCnt: Variant);
begin
  if VarIsNull(AAggVal) or VarIsNull(AVal) then
    Exit;
  case AKind of
  akSum:
    AAggVal := ADFixFMTBcdSub(AAggVal, AVal);
  akAvg:
    begin
      AAggVal := ADFixFMTBcdSub(AAggVal, AVal);
      AAggCnt := AAggCnt - 1;
      if AAggCnt = 0 then begin
        AAggVal := Null;
        AAggCnt := Null;
      end;
    end;
  akCount:
    begin
      AAggVal := AAggVal - 1;
      if AAggVal = 0 then
        AAggVal := Null;
    end;
  akMin:
    ;
  akMax:
    ;
  akFirst:
    ;
  akLast:
    ;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.SetEvaluatorToRow(ARows: TADDatSRowListWithAggregates;
  ARowIndex: Integer);
begin
  FCurrentRow := ARowIndex;
  FEvaluator.DataSource.Position := ARows.ItemsI[ARowIndex];
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetSubAggregateValue(ASubAggregateIndex: Integer): Variant;
var
  oVal: TADDatSAggregateValue;
  vCnt, vVal: Variant;
  pAgg: PADDatSSubAggregate;
begin
  Result := Null;
  oVal := Rows.FetchAggregate(FCurrentRow, FValueIndex);
  pAgg := @FSubAggregates[ASubAggregateIndex];
  vVal := oVal.FSubValues[pAgg^.FValueIndex];
  if not VarIsNull(vVal) and not VarIsEmpty(vVal) then
    if pAgg^.FKind = akAvg then begin
      vCnt := oVal.FSubValues[pAgg^.FCountIndex];
      if not VarIsNull(vCnt) then
        Result := ADFixFMTBcdDiv(vVal, vCnt);
    end
    else
      Result := vVal;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.ClearGroup(ARowIndex: Integer; var AGroupFrom, AGroupTo: Integer);
var
  oRows: TADDatSRowListWithAggregates;
  oSortMech: IADDatSMechSort;
  i, j: Integer;
  oVal, oLastVal: TADDatSAggregateValue;
begin
  oRows := Rows;
  oSortMech := SortMech;
  if (GroupingLevel > 0) and (oSortMech <> nil) then begin
    AGroupFrom := ARowIndex;
    while (AGroupFrom > 0) and
          (oSortMech.CompareRows(oRows.ItemsI[AGroupFrom], oRows.ItemsI[AGroupFrom - 1], GroupingLevel) = 0) do
      Dec(AGroupFrom);
    AGroupTo := ARowIndex;
    while (AGroupTo < oRows.Count - 1) and
          (oSortMech.CompareRows(oRows.ItemsI[AGroupTo], oRows.ItemsI[AGroupTo + 1], GroupingLevel) = 0) do
      Inc(AGroupTo);
  end
  else begin
    AGroupFrom := 0;
    AGroupTo := oRows.Count - 1;
  end;
  oLastVal := nil;
  for i := AGroupFrom to AGroupTo do begin
    oVal := oRows.FetchAggregate(i, FValueIndex);
    if oVal = nil then begin
      if oLastVal = nil then
        for j := i + 1 to AGroupTo do begin
          oLastVal := oRows.FetchAggregate(j, FValueIndex);
          if oLastVal <> nil then
            Break;
        end;
      if oLastVal = nil then
        oVal := TADDatSAggregateValue.Create(FSubAggregateValues)
      else
        oVal := oLastVal;
      oRows.AttachAggregate(i, FValueIndex, oVal);
    end;
    if oLastVal <> oVal then begin
      ASSERT(oLastVal = nil);
      oVal.Clear;
      oLastVal := oVal;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.CalcGroup(AGroupFrom, AGroupTo, AExclude: Integer);
var
  oRows: TADDatSRowListWithAggregates;
  oVal, oLastVal: TADDatSAggregateValue;
  j, i: Integer;
  V, vTmp: Variant;
  pAgg: PADDatSSubAggregate;
begin
  oRows := Rows;
  for j := 0 to Length(FSubAggregates) - 1 do
    for i := AGroupFrom to AGroupTo do
      if i <> AExclude then begin
        oVal := oRows.FetchAggregate(i, FValueIndex);
        SetEvaluatorToRow(oRows, i);
        V := FEvaluator.EvaluateSubAggregateArg(j);
        pAgg := @FSubAggregates[j];
        if pAgg^.FKind = akAvg then
          IncAggVals(pAgg^.FKind, V, oVal.FSubValues[pAgg^.FValueIndex], oVal.FSubValues[pAgg^.FCountIndex])
        else begin
          vTmp := Unassigned;
          IncAggVals(pAgg^.FKind, V, oVal.FSubValues[pAgg^.FValueIndex], vTmp);
        end;
      end;
  oLastVal := nil;
  for i := AGroupFrom to AGroupTo do
    if i <> AExclude then begin
      oVal := oRows.FetchAggregate(i, FValueIndex);
      if oLastVal <> oVal then begin
        SetEvaluatorToRow(oRows, i);
        oVal.FValue := FEvaluator.Evaluate;
        oLastVal := oVal;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.CalcAll;
var
  oRows: TADDatSRowListWithAggregates;
  oVal: TADDatSAggregateValue;
  i, iLevel: Integer;
  oSortMech: IADDatSMechSort;
  lBreak: Boolean;
begin
  oRows := Rows;
  if agPrepared in FState then
    oRows.ClearAggregate(FValueIndex)
  else
    Prepare;
  oSortMech := SortMech;
  iLevel := GroupingLevel;
  oVal := nil;
  for i := 0 to oRows.Count - 1 do begin
    lBreak := False;
    if oVal = nil then
      lBreak := True
    else if (iLevel > 0) and (oSortMech <> nil) then
      lBreak := (oSortMech.CompareRows(oRows.ItemsI[i], oRows.ItemsI[i - 1], iLevel) <> 0);
    if lBreak then
      oVal := TADDatSAggregateValue.Create(FSubAggregateValues);
    oRows.AttachAggregate(i, FValueIndex, oVal);
    if lBreak then
      oVal.RemRef;
  end;
  CalcGroup(0, oRows.Count - 1, -1);
  Include(FState, agActual);
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetDataType: TADDataType;
begin
  if FEvaluator = nil then
    Result := dtUnknown
  else
    Result := FEvaluator.DataType;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregate.GetValue(ARowIndex: Integer): Variant;
begin
  if agPrepared in FState then
    Result := Rows.FetchAggregate(ARowIndex, FValueIndex).Value
  else
    Result := Unassigned;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.IncRow(ARows: TADDatSRowListWithAggregates;
  ARowIndex: Integer; AVal: TADDatSAggregateValue);
var
  i: Integer;
  V, vTmp: Variant;
  pAgg: PADDatSSubAggregate;
begin
  SetEvaluatorToRow(ARows, ARowIndex);
  for i := 0 to Length(FSubAggregates) - 1 do begin
    V := FEvaluator.EvaluateSubAggregateArg(i);
    pAgg := @FSubAggregates[i];
    if pAgg^.FKind = akAvg then
      IncAggVals(pAgg^.FKind, V, AVal.FSubValues[pAgg^.FValueIndex],
        AVal.FSubValues[pAgg^.FCountIndex])
    else begin
      vTmp := Unassigned;
      IncAggVals(pAgg^.FKind, V, AVal.FSubValues[pAgg^.FValueIndex], vTmp);
    end;
  end;
  AVal.FValue := FEvaluator.Evaluate;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.DecRow(ARows: TADDatSRowListWithAggregates;
  ARowIndex: Integer; AVal: TADDatSAggregateValue);
var
  i: Integer;
  V, vTmp: Variant;
  pAgg: PADDatSSubAggregate;
begin
  SetEvaluatorToRow(ARows, ARowIndex);
  for i := 0 to Length(FSubAggregates) - 1 do begin
    V := FEvaluator.EvaluateSubAggregateArg(i);
    pAgg := @FSubAggregates[i];
    if pAgg^.FKind = akAvg then
      DecAggVals(pAgg^.FKind, V, AVal.FSubValues[pAgg^.FValueIndex],
        AVal.FSubValues[pAgg^.FCountIndex])
    else begin
      vTmp := Unassigned;
      DecAggVals(pAgg^.FKind, V, AVal.FSubValues[pAgg^.FValueIndex], vTmp);
    end;
  end;
  AVal.FValue := FEvaluator.Evaluate;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.RowInserted(ARowIndex: Integer);
var
  oRows: TADDatSRowListWithAggregates;
  oSortMech: IADDatSMechSort;
  i: Integer;
  oVal: TADDatSAggregateValue;
begin
  if ActualActive then begin
    oRows := Rows;
    oSortMech := SortMech;
    if (GroupingLevel > 0) and (oSortMech <> nil) then begin
      if (ARowIndex > 0) and
         (oSortMech.CompareRows(oRows.ItemsI[ARowIndex], oRows.ItemsI[ARowIndex - 1], GroupingLevel) = 0) then
        i := ARowIndex - 1
      else if (ARowIndex < oRows.Count - 1) and
              (oSortMech.CompareRows(oRows.ItemsI[ARowIndex], oRows.ItemsI[ARowIndex + 1], GroupingLevel) = 0) then
        i := ARowIndex + 1
      else
        i := -1;
    end
    else
      if ARowIndex > 0 then
        i := ARowIndex - 1
      else if ARowIndex < oRows.Count - 1 then
        i := ARowIndex + 1
      else
        i := -1;
    if i = -1 then
      oVal := TADDatSAggregateValue.Create(FSubAggregateValues)
    else
      oVal := oRows.FetchAggregate(i, FValueIndex);
    oRows.AttachAggregate(ARowIndex, FValueIndex, oVal);
    if i = -1 then
      oVal.RemRef;
    IncRow(oRows, ARowIndex, oVal);
  end
  else
    Exclude(FState, agActual);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.RowDeleted(ARowIndex: Integer);
var
  oVal: TADDatSAggregateValue;
  oRows: TADDatSRowListWithAggregates;
  iFrom, iTo: Integer;
begin
  if ActualActive then begin
    oRows := Rows;
    oVal := oRows.FetchAggregate(ARowIndex, FValueIndex);
    if oVal.Refs > 1 then
      if agMinMax in FState then begin
        iFrom := -1;
        iTo := -1;
        ClearGroup(ARowIndex, iFrom, iTo);
        CalcGroup(iFrom, iTo, ARowIndex);
      end
      else
        DecRow(oRows, ARowIndex, oVal);
    oRows.DetachAggregate(ARowIndex, FValueIndex);
  end
  else
    Exclude(FState, agActual);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.RowUpdated(ARowIndex, AOldRowIndex: Integer);
var
//  oRows: TADDatSRowListWithAggregates;
  iFrom, iTo: Integer;
//  oVal: TADDatSAggregateValue;
begin
  if ActualActive then begin
{ TODO -cDATS :
If after EndEdit we can remember row data before edit, then we
can incrementally update aggregates. Now code is commented out. }
//    if agMinMax in FState then begin
      iFrom := -1;
      iTo := -1;
      ClearGroup(AOldRowIndex, iFrom, iTo);
      CalcGroup(iFrom, iTo, -1);
      if (ARowIndex < iFrom) or (ARowIndex > iTo) then begin
        ClearGroup(ARowIndex, iFrom, iTo);
        CalcGroup(iFrom, iTo, -1);
      end;
//    end
//    else begin
//      oRows := Rows;
//      oVal := oRows.FetchAggregate(AOldRowIndex, FValueIndex);
//      DecRow(oRows, AOldRowIndex, oVal);
//      oVal := oRows.FetchAggregate(ARowIndex, FValueIndex);
//      IncRow(oRows, ARowIndex, oVal);
//    end;
  end
  else
    Exclude(FState, agActual);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.ResolveActive(const AName, AValue: String);
begin
  if SameText(AName, 'Active') and SameText(AValue, S_AD_True) then
    Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.InternalLoadFromStorage(AStorage: TADStorage);
var
  lActive: Boolean;
begin
  Active := False;
  inherited InternalLoadFromStorage(AStorage);
  lActive := AStorage.ReadBoolean('Active', False);
  if lActive then
    AStorage.DeferAction('Active', S_AD_True, ResolveActive);
  Expression := AStorage.ReadString('Expression', '');
  GroupingLevel := AStorage.ReadInteger('GroupingLevel', 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregate.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  AStorage.WriteBoolean('Active', Active, False);
  AStorage.WriteString('Expression', Expression, '');
  AStorage.WriteInteger('GroupingLevel', GroupingLevel, 0);
end;

{-------------------------------------------------------------------------------}
{ TADDatSAggregateList                                                          }
{-------------------------------------------------------------------------------}
constructor TADDatSAggregateList.CreateForView(AOwner: TADDatSView);
begin
  ASSERT(AOwner <> nil);
  inherited Create;
  OwnObjects := True;
  FOwner := AOwner;
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateList.Add(AObj: TADDatSAggregate): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateList.Add(const AName, AExpression: String;
  AGroupingLevel: Integer): TADDatSAggregate;
begin
  Result := TADDatSAggregate.Create(AName, AExpression, AGroupingLevel);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateList.GetItemsI(AIndex: Integer): TADDatSAggregate;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSAggregate(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSAggregateList.AggregateByName(const AName: String): TADDatSAggregate;
begin
  Result := TADDatSAggregate(ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateList.RowInserted(ARowIndex: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].RowInserted(ARowIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateList.RowUpdated(ARowIndex, AOldRowIndex: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].RowUpdated(ARowIndex, AOldRowIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateList.RowDeleted(ARowIndex: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].RowDeleted(ARowIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateList.Update;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].Update;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSAggregateList.Recalc;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].Recalc;
end;

{-------------------------------------------------------------------------------}
{- TADDatSTableRowList                                                         -}
{-------------------------------------------------------------------------------}
constructor TADDatSTableRowList.CreateForTable(ATable: TADDatSTable);
begin
  ASSERT(ATable <> nil);
  inherited Create;
  FOwner := ATable;
  OwnObjects := True;
  FRowIDOrdered := True;
  FLastRowCount := -1;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableRowList.Add(const AValues: array of Variant): TADDatSRow;
begin
  Result := Table.NewRow(AValues, True);
  Add(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableRowList.IndexOf(AObj: TADDatSObject): Integer;
var
  iFirstNo, iLastNo: Integer;
  iObjRowId: LongWord;
  oRow: TADDatSRow;
begin
  ASSERT(AObj <> nil);
  if FRowIDOrdered then begin
    iFirstNo := 0;
    iLastNo := FCount - 1;
    iObjRowId := TADDatSRow(AObj).FRowID;
    if iObjRowId = $FFFFFFFF then begin
      Result := -1;
      Exit;
    end;
    while iFirstNo <= iLastNo do begin
      Result := (iFirstNo + iLastNo) div 2;
      oRow := TADDatSRow(FArray[Result]);
      if oRow.FRowID > iObjRowId then
        iLastNo := Result - 1
      else if oRow.FRowID < iObjRowId then
        iFirstNo := Result + 1
      else
        Exit;
    end;
    Result := -1;
  end
  else
    Result := inherited IndexOf(AObj);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableRowList.Clear;
begin
  inherited Clear;
  FLastRowID := 0;
  FLastRowCount := -1;
  FRowIDOrdered := True;
  Inc(FResultSetNum);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableRowList.AddObjectAt(AObj: TADDatSObject; AIndex: Integer);
begin
  inherited AddObjectAt(AObj, AIndex);
  if not ((AIndex = -1) or (AIndex = Count - 1)) then
    FRowIDOrdered := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableRowList.RemoveAt(AIndex: Integer; ANotDestroy: Boolean);
begin
  inherited RemoveAt(AIndex, ANotDestroy);
  if Count = 0 then
    FRowIDOrdered := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableRowList.InternalLoadFromStorage(AStorage: TADStorage);
var
  oRow: TADDatSRow;
  sName: String;
begin
  sName := GetStreamingName(AStorage);
  while not AStorage.IsObjectEnd(sName) do begin
    oRow := Table.NewRow(False);
    Add(oRow);
    oRow.LoadFromStorage(AStorage);
    Table.Columns.FixAutoIncs(oRow);
    if FLastRowID <= oRow.RowID then
      FLastRowID := oRow.RowID + 1;
    if (Count >= 2) and (ItemsI[Count - 2].RowID >= oRow.RowID) then
      FRowIDOrdered := False;
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSViewRowList                                                          -}
{-------------------------------------------------------------------------------}
constructor TADDatSViewRowList.CreateForView(AView: TADDatSView);
begin
  ASSERT(AView <> nil);
  inherited Create;
  FOwner := AView;
  OwnObjects := False;
  LockNotification;
end;

{-------------------------------------------------------------------------------}
{- TADDatSNestedRowList                                                        -}
{-------------------------------------------------------------------------------}
constructor TADDatSNestedRowList.CreateForRow(ARow: TADDatSRow);
begin
  ASSERT(ARow <> nil);
  inherited Create;
  FOwner := ARow;
  OwnObjects := False;
  LockNotification;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNestedRowList.AddObjectAt(AObj: TADDatSObject; AIndex: Integer);
begin
  ASSERT(AObj <> nil);
  TADDatSRow(AObj).ParentRow := TADDatSRow(FOwner);
  inherited AddObjectAt(AObj, AIndex);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSNestedRowList.RemoveAt(AIndex: Integer; ANotDestroy: Boolean);
begin
  ItemsI[AIndex].ParentRow := nil;
  inherited RemoveAt(AIndex, ANotDestroy);
end;

{-------------------------------------------------------------------------------}
{- TADDatSView                                                                 -}
{-------------------------------------------------------------------------------}
type
  TADDatSViewUpdateInfoKind = (vuRowAdded, vuRowChanged, vuRowDeleted);
  PADDataViewUpdateInfo = ^TADDatSViewUpdateInfo;
  TADDatSViewUpdateInfo = record
    FKind: TADDatSViewUpdateInfoKind;
    FIndex: Integer;
    FOldIndex: Integer;
    FRow: TADDatSRow;
  end;

{-------------------------------------------------------------------------------}
constructor TADDatSView.Create;
begin
  inherited Create;
  FRows := TADDatSViewRowList.CreateForView(Self);
  FMechanisms := TADDatSViewMechList.CreateForView(Self);
  FAggregates := TADDatSAggregateList.CreateForView(Self);
  FState := [vsOutdated];
  FRefs := TADRefCounter.Create(Self);
  FProposedPosition := -1;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSView.Create(ATable: TADDatSTable; const AFilter, ASort: String;
  AStates: TADDatSRowStates);
begin
  ASSERT(ATable <> nil);
  Create;
  if ASort <> '' then
    Mechanisms.AddSort(ASort);
  if AFilter <> '' then
    Mechanisms.AddFilter(AFilter);
  if AStates <> [] then
    Mechanisms.AddStates(AStates)
  else
    // filter out deleted rows
    Mechanisms.AddStates(C_AllViewRows);
  Active := True;
  ATable.Views.AddObjectAt(Self, -1);
end;

{-------------------------------------------------------------------------------}
constructor TADDatSView.Create(ATable: TADDatSTable;
  const ABaseName: String; ACreator: TADDatSViewCreator;
  ACountRef: Boolean);
begin
  ASSERT(ATable <> nil);
  Create;
  if ABaseName <> '' then
    Name := ATable.Views.BuildUniqueName(ABaseName);
  Creator := ACreator;
  ATable.Views.AddEx(Self);
  if ACountRef then
    CountRef;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSView.Destroy;
begin
  Active := False;
  ADFreeAndNil(FRows);
  ADFreeAndNil(FMechanisms);
  ADFreeAndNil(FAggregates);
  ADFreeAndNil(FRefs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.Assign(AObj: TADDatSObject);
begin
  Active := False;
  inherited Assign(AObj);
  if AObj is TADDatSView then begin
    Creator := TADDatSView(AObj).Creator;
    SourceView := TADDatSView(AObj).SourceView;
    Mechanisms.Assign(TADDatSView(AObj).Mechanisms);
    Active := TADDatSView(AObj).Active;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then begin
    ASSERT(AObj <> nil);
    Result := (SourceView = TADDatSView(AObj).SourceView) and
      Mechanisms.IsEqualTo(TADDatSView(AObj).Mechanisms);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.CountRef(AInit: Integer = 1);
begin
  FRefs.CountRef(AInit);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.AddRef;
begin
  FRefs.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.RemRef;
begin
  FRefs.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetIsRefCounted: Boolean;
begin
  Result := FRefs.Refs >= 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.CheckRebuild;
begin
  if ActualActive and (vsOutdated in FState) then
    Rebuild;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.InvalidateRebuild;
begin
  FState := FState + [vsOutdated];
  CheckRebuild;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.Clear;
begin
  try
    Rows.Clear;
    ProposedPosition := -1;
    FLastUpdatePosition := -1;
  finally
    FState := FState + [vsOutdated];
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.DoRowAdded(ARow: TADDatSRow);
var
  iNewPos, iOldPos: Integer;
  info: TADDatSViewUpdateInfo;
begin
  if not ActualActive then begin
    FState := FState + [vsOutdated];
    ProposedPosition := -1;
    FLastUpdatePosition := -1;
    Exit;
  end;
  iNewPos := -1;
  iOldPos := -1;
  if ProcessRow(ARow, iNewPos, iOldPos, True) = psAccepted then begin
    info.FRow := ARow;
    info.FIndex := iNewPos;
    info.FKind := vuRowAdded;
    Notify(snViewUpdated, srDataChange, TADNativeInt(Self), TADNativeInt(@info));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.DoRowChanged(ARow: TADDatSRow);
var
  iNewPos, iOldPos: Integer;
  info: TADDatSViewUpdateInfo;
  ePS: TADDatSViewProcessRowStatus;
begin
  if not ActualActive then begin
    FState := FState + [vsOutdated];
    ProposedPosition := -1;
    FLastUpdatePosition := -1;
    Exit;
  end;
  iNewPos := -1;
  iOldPos := -1;
  ePS := ProcessRow(ARow, iNewPos, iOldPos, False);
  if ePS = psAccepted then begin
    info.FRow := ARow;
    info.FIndex := iNewPos;
    if iOldPos <> -1 then begin
      info.FKind := vuRowChanged;
      info.FOldIndex := iOldPos;
    end
    else
      info.FKind := vuRowAdded;
    Notify(snViewUpdated, srDataChange, TADNativeInt(Self), TADNativeInt(@info));
  end
  else if (ePS = psRejected) and (iOldPos <> -1) then begin
    info.FRow := ARow;
    info.FIndex := iOldPos;
    info.FKind := vuRowDeleted;
    Notify(snViewUpdated, srDataChange, TADNativeInt(Self), TADNativeInt(@info));
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.DoRowDeleted(ARow: TADDatSRow);
var
  i: Integer;
  info: TADDatSViewUpdateInfo;
begin
  if not ActualActive then begin
    FState := FState + [vsOutdated];
    ProposedPosition := -1;
    FLastUpdatePosition := -1;
    Exit;
  end;
  i := ProposedPosition;
  ProposedPosition := -1;
  FLastUpdatePosition := -1;
  if (i < 0) or (i >= Rows.Count) or (Rows.ItemsI[i] <> ARow) then
    i := IndexOf(ARow, rvPrevious);
  if i <> -1 then begin
    Aggregates.RowDeleted(i);
    Rows.RemoveAt(i);
    info.FRow := ARow;
    info.FIndex := i;
    info.FKind := vuRowDeleted;
    Notify(snViewUpdated, srDataChange, TADNativeInt(Self), TADNativeInt(@info));
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetActual: Boolean;
begin
  Result := not (vsOutdated in FState);
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetViewList: TADDatSViewList;
begin
  if Owner <> nil then
    Result := TADDatSViewList(Owner)
  else
    Result := nil;
  ASSERT((Result = nil) or (Result is TADDatSViewList));
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetTable: TADDatSTable;
begin
  if (Owner <> nil) and (Owner.Owner <> nil) then
    Result := TADDatSTable(Owner.Owner)
  else
    Result := nil;
  ASSERT((Result = nil) or (Result is TADDatSTable));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.HandleNotification(AParam: PADDatSNotifyParam);
var
  pInfo: PADDataViewUpdateInfo;
  oTab: TADDatSTable;
  oView, oViewMsg: TADDatSView;
begin
  if Mechanisms <> nil then
    Mechanisms.HandleNotification(AParam);
  if Aggregates <> nil then
    Aggregates.HandleNotification(AParam);
  if AParam^.FKind = snMechanismStateChanged then begin
    oViewMsg := TADDatSMechBase(AParam^.FParam1).View;
    oView := Self;
    while (oView <> nil) and (oView <> oViewMsg) do
      oView := oView.SourceView;
    if oView <> nil then begin
      UpdateSortingMechanism(nil);
      InvalidateRebuild;
    end;
  end
  else if (AParam^.FKind = snObjectRemoving) and (TADDatSObject(AParam^.FParam2) is TADDatSView) then begin
    oViewMsg := TADDatSView(AParam^.FParam2);
    if SourceView = oViewMsg then
      SourceView := nil
    else if oViewMsg <> Self then begin
      oView := Self;
      while (oView <> nil) and (oView <> oViewMsg) do
        oView := oView.SourceView;
      if oView <> nil then
        UpdateSortingMechanism(oViewMsg);
    end;
  end
  else begin
    oTab := Table;
    if oTab <> nil then
      if SourceView = nil then
        case AParam^.FKind of
        snObjectInserted:
          if (TADDatSList(AParam^.FParam1) is TADDatSTableRowList) and
             (TADDatSTableRowList(AParam^.FParam1) = oTab.Rows) then
            DoRowAdded(TADDatSRow(AParam^.FParam2));
        snObjectRemoved:
          if (TADDatSList(AParam^.FParam1) is TADDatSTableRowList) and
             (TADDatSTableRowList(AParam^.FParam1) = oTab.Rows) then
            DoRowDeleted(TADDatSRow(AParam^.FParam2));
        snRowStateChanged, snRowErrorStateChanged, snRowDataChanged:
          if (TADDatSRow(AParam^.FParam1).Table = oTab) and
             ((AParam^.FKind <> snRowStateChanged) or
               not (TADDatSRow(AParam^.FParam1).RowState in
                    [rsEditing,
                     rsImportingCurent, rsImportingOriginal, rsImportingProposed])) then
            DoRowChanged(TADDatSRow(AParam^.FParam1));
        end
      else
        if (AParam^.FKind = snViewUpdated) and (TADDatSView(AParam^.FParam1) = SourceView) then begin
          pInfo := PADDataViewUpdateInfo(AParam^.FParam2);
          case pInfo^.FKind of
          vuRowAdded:
            DoRowAdded(pInfo^.FRow);
          vuRowDeleted:
            DoRowDeleted(pInfo^.FRow);
          vuRowChanged:
            DoRowChanged(pInfo^.FRow);
          end;
        end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.ProcessRow(ARow: TADDatSRow; var ANewPos, AOldPos: Integer;
  AAdding: Boolean): TADDatSViewProcessRowStatus;
var
  i: Integer;
  lFound: Boolean;
  oMech: TADDatSMechBase;
begin
  Result := psAccepted;
  FLastUpdatePosition := -1;
  if AAdding then begin
    AOldPos := -1;
    ANewPos := ProposedPosition;
  end
  else begin
    AOldPos := ProposedPosition;
    ProposedPosition := -1;
    if (AOldPos < 0) or (AOldPos >= Rows.Count) or (Rows.ItemsI[AOldPos] <> ARow) then
      AOldPos := IndexOf(ARow, rvPrevious);
    ANewPos := AOldPos;
  end;
  for i := 0 to Mechanisms.Count - 1 do begin
    oMech := Mechanisms.ItemsI[i];
    if oMech.ActualActive and (mkFilter in oMech.Kinds) and not oMech.Locator then
      if not oMech.AcceptRow(ARow, rvDefault) then begin
        Result := psRejected;
        Break;
      end;
  end;
  if Result = psAccepted then begin
    if ((SortingMechanism = nil) or (SortingMechanism.SortSource = ssRowId))
       and not AAdding and (AOldPos <> -1) then
      Result := psUnchanged
    else begin
      if (SortingMechanism = nil) and AAdding then begin
        lFound := True;
        if ANewPos = -1 then
          ANewPos := Rows.Count;
      end
      else begin
        Search(ARow, nil, nil, -1, [loNearest, loLast, loExcludeKeyRow, loUseRowID],
          ANewPos, lFound, rvDefault);
        if ANewPos = -1 then
          ANewPos := 0
        else if lFound then
          Inc(ANewPos);
      end;
      if AOldPos <> ANewPos then begin
        if AOldPos <> -1 then begin
          Rows.RemoveAt(AOldPos);
          if ANewPos > AOldPos then
            Dec(ANewPos);
        end;
        Rows.AddAt(ARow, ANewPos);
      end;
    end;
    if AOldPos = -1 then
      Aggregates.RowInserted(ANewPos)
    else
      Aggregates.RowUpdated(ANewPos, AOldPos);
    FLastUpdatePosition := ANewPos;
  end
  else if (Result = psRejected) and (AOldPos <> -1) then begin
    Aggregates.RowDeleted(AOldPos);
    Rows.RemoveAt(AOldPos);
  end;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D12}
  {$WARNINGS OFF}
{$ENDIF}
procedure TADDatSView.Rebuild;
var
  i: Integer;
  j: Integer;
  lAccepted, lFilters: Boolean;
  oMech: TADDatSMechBase;
  oRows: TADDatSRowListBase;
  iNewBegin, iBegin, iNewEnd, iEnd: Integer;
  oSortMech: IADDatSMechSort;
  oRow: TADDatSRow;
  pRow: PADDatSRow;
  aMechMap: array of Boolean;
begin
  if SourceView <> nil then begin
    oRows := SourceView.Rows;
    iBegin := 0;
    iEnd := oRows.Count - 1;
    Clear;
  end
  else if Table <> nil then begin
    oRows := Table.Rows;
    if (Table.Rows.FLastRowCount > 0) and (Table.Rows.FLastRowCount <= oRows.Count) and
       (SortingMechanism = nil) then begin
      iBegin := Table.Rows.FLastRowCount;
      iEnd := oRows.Count - 1;
    end
    else begin
      iBegin := 0;
      iEnd := oRows.Count - 1;
      Clear;
    end;
  end
  else begin
    Clear;
    Exit;
  end;
  try
    if iEnd >= 0 then begin
      lFilters := False;
      SetLength(aMechMap, Mechanisms.Count);
      // restrict rows by a range
      for j := 0 to Mechanisms.Count - 1 do begin
        oMech := Mechanisms.ItemsI[j];
        aMechMap[j] := oMech.ActualActive and
          ([mkFilter, mkPost] * oMech.Kinds = [mkFilter]) and not oMech.Locator;
        if aMechMap[j] then begin
          lFilters := True;
          if mkHasList in oMech.Kinds then begin
            // expecting, here oRows will set to nested rows list
            if oMech.GetRowsRange(oRows, iBegin, iEnd) then
              Break;
          end
          else begin
            iNewBegin := iBegin;
            iNewEnd := iEnd;
            if oMech.GetRowsRange(oRows, iNewBegin, iNewEnd) then begin
              if iNewBegin > iBegin then
                iBegin := iNewBegin;
              if iNewEnd < iEnd then
                iEnd := iNewEnd;
            end;
          end;
        end;
      end;
      // filter rows
      if iBegin <= iEnd then begin
        if oRows.Count = 0 then
          oRows.Capacity := iEnd - iBegin + 1;
        pRow := @oRows.FArray[iBegin];
        for i := iBegin to iEnd do begin
          oRow := pRow^;
          if not (oRow.RowState in [rsEditing, rsChecking]) then begin
            if not lFilters then
              Rows.Add(oRow)
            else begin
              lAccepted := True;
              for j := 0 to Mechanisms.Count - 1 do begin
                oMech := Mechanisms.ItemsI[j];
                if aMechMap[j] then
                  if not oMech.AcceptRow(oRow, rvDefault) then begin
                    lAccepted := False;
                    Break;
                  end;
              end;
              if lAccepted then
                Rows.Add(oRow);
            end;
          end;
          pRow := PADDatSRow(TADNativeInt(pRow) + SizeOf(TADDatSRow));
        end;
      end;
      // sort rows
      for j := 0 to Mechanisms.Count - 1 do begin
        oMech := Mechanisms.ItemsI[j];
        if oMech.ActualActive and (mkSort in oMech.Kinds) and
           Supports(oMech, IADDatSMechSort, oSortMech) then
          oSortMech.Sort(Rows);
      end;
      // post filter rows
      for j := 0 to Mechanisms.Count - 1 do begin
        oMech := Mechanisms.ItemsI[j];
        if oMech.ActualActive and
           ([mkFilter, mkPost] * oMech.Kinds = [mkFilter, mkPost]) and not oMech.Locator then
          oMech.PostProcess(Rows);
      end;
    end;
    FState := FState - [vsOutdated];
    Aggregates.Recalc;
  except
    Clear;
    raise;
  end;
end;
{$IFNDEF AnyDAC_D12}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDatSView.GetActualActive: Boolean;
var
  oViewList: TADDatSViewList;
begin
  oViewList := ViewList;
  Result := Active and (Table <> nil) and
    ((oViewList = nil) or oViewList.Active) and
    ((SourceView = nil) or SourceView.Active and (SourceView.Table = Table));
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.CheckActiveChanged;
var
  i: Integer;
begin
  if FPrevActualActive <> ActualActive then begin
    FPrevActualActive := ActualActive;
    LockNotification;
    try
      ADFreeAndNil(FFindRow);
      for i := 0 to Mechanisms.Count - 1 do
        if mkSort in Mechanisms.ItemsI[i].Kinds then
          Mechanisms.ItemsI[i].CheckActiveChanged;
      UpdateSortingMechanism(nil);
      for i := 0 to Mechanisms.Count - 1 do
        if not (mkSort in Mechanisms.ItemsI[i].Kinds) then
          Mechanisms.ItemsI[i].CheckActiveChanged;
    finally
      UnlockNotification;
    end;
    if FPrevActualActive then
      CheckRebuild
    else
      FState := FState + [vsOutdated];
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.DoListInserted;
begin
  CheckActiveChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.DoListRemoving;
begin
  Active := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.SetActive(const AValue: Boolean);
begin
  if FActive <> AValue then begin
    FActive := AValue;
    CheckActiveChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.SetSourceView(const AValue: TADDatSView);
begin
  ASSERT(AValue <> Self);
  if FSourceView <> AValue then begin
    Active := False;
    FSourceView := AValue;
    if (AValue <> nil) and (AValue.Index > Index) then
      Table.Views.MoveTo(AValue.Index, Index);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.UpdateSortingMechanism(AExcludeView: TADDatSView);
var
  i: Integer;
begin
  if Mechanisms = nil then
    Exit;
  PPointer(@FSortingMechanism)^ := nil;
  i := Mechanisms.Count - 1;
  while (i >= 0) and not (Mechanisms.ItemsI[i].ActualActive and
        (mkSort in Mechanisms.ItemsI[i].Kinds) and
        Supports(Mechanisms.ItemsI[i], IADDatSMechSort, FSortingMechanism)) do
    Dec(i);
  if i = -1 then
    if (SourceView <> nil) and (SourceView <> AExcludeView) then begin
      SourceView.UpdateSortingMechanism(AExcludeView);
      FSortingMechanism := SourceView.SortingMechanism;
    end;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D12}
  {$WARNINGS OFF}
{$ENDIF}
function TADDatSView.Search(AKeyRow: TADDatSRow;
  AKeyColumnList, AKeyColumnList2: TADDatSColumnSublist; AKeyColumnCount: Integer;
  AOptions: TADLocateOptions; out AIndex: Integer; out AFound: Boolean;
  ARowVersion: TADDatSRowVersion = rvDefault): Integer;
var
  i: Integer;
  eProhibitSortOpts: TADSortOptions;
  eCompOpts: TADCompareDataOptions;
  oRow: TADDatSRow;
  oCache: TADDatSCompareRowsCache;
  iFrom, iTo: Integer;
  bIndexSearch: Boolean;
begin
  ASSERT(AKeyRow <> nil);
  Result := -1;
  AFound := False;
  oCache := nil;
(*
  Ind Src	Ok
  S	  S	  +	  Src
  S	  I	  +	  Src
  I	  S	  -	  -
  I	  I	  +	  Src

  loNoCase -> [], []
           -> [], [soNoCase]
*)
  eCompOpts := [coCache];
  if loPartial in AOptions then
    Include(eCompOpts, coPartial);
  if loNoCase in AOptions then
    Include(eCompOpts, coNoCase);

  eProhibitSortOpts := [];
  if not (loNoCase in AOptions) then
    Include(eProhibitSortOpts, soNoCase);

  if (AIndex < 0) or (AIndex >= Rows.Count) then
    Exclude(AOptions, loFromCurrent);

  if (SortingMechanism <> nil) and (
      (AKeyColumnList = nil) or
      SortingMechanism.SortingOn(AKeyColumnList, AKeyColumnCount, [], eProhibitSortOpts)
     ) then begin
    bIndexSearch := True;
    if loFromCurrent in AOptions then begin
      Result := Rows[AIndex].CompareRows(AKeyColumnList, nil, nil, AKeyColumnCount,
        AKeyRow, AKeyColumnList2, ARowVersion, eCompOpts, oCache);
      if Result = 0 then begin
        // current record matches, so check next or previous record
        bIndexSearch := False;
        if loBackward in AOptions then
          Dec(AIndex)
        else
          Inc(AIndex);
        AFound := (AIndex >= 0) and (AIndex < Rows.Count) and
          (Rows[AIndex].CompareRows(AKeyColumnList, nil, nil, AKeyColumnCount,
           AKeyRow, AKeyColumnList2, ARowVersion, eCompOpts, oCache) = 0);
      end
      else if ((Result > 0) and not (loBackward in AOptions)) or
              ((Result < 0) and (loBackward in AOptions)) then
        // no desired records in given direction
        bIndexSearch := False;
    end;
    if bIndexSearch then
      Result := SortingMechanism.Search(Rows, AKeyRow, AKeyColumnList,
        AKeyColumnList2, AKeyColumnCount, AOptions, AIndex, AFound, ARowVersion)
    else if not AFound then begin
      Result := -1;
      AIndex := -1;
    end;
  end
  else begin
    if (AKeyRow.RowState = rsUnchanged) and
       (AKeyRow.RowPriorState in [rsInitializing, rsDetached]) and
       (Table.DataHandleMode in [lmHavyFetching, lmFetching]) then begin
      // fetching - not in a list yet
    end
    else if AKeyRow.Owner = Table.Rows then begin
      AIndex := IndexOf(AKeyRow, ARowVersion);
      if AIndex <> -1 then begin
        Result := 0;
        AFound := True;
      end;
    end
    else begin
      if loFromCurrent in AOptions then begin
        if loBackward in AOptions then begin
          iFrom := 0;
          iTo := AIndex - 1;
        end
        else begin
          iFrom := AIndex + 1;
          iTo := Rows.Count - 1;
        end;
      end
      else begin
        iFrom := 0;
        iTo := Rows.Count - 1;
      end;
      if loBackward in AOptions then
        i := iTo
      else
        i := iFrom;
      while (i >= iFrom) and (i <= iTo) do begin
        oRow := Rows.ItemsI[i];
        if (oRow <> AKeyRow) or not (loExcludeKeyRow in AOptions) then
          if (oRow = AKeyRow) or
             (oRow.CompareRows(AKeyColumnList, nil, nil, AKeyColumnCount,
                               AKeyRow, AKeyColumnList2, ARowVersion, eCompOpts,
                               oCache) = 0) then begin
            AIndex := i;
            AFound := True;
            Result := 0;
            Break;
          end;
        if loBackward in AOptions then
          Dec(i)
        else
          Inc(i);
      end;
    end;
    if not AFound and (loNearest in AOptions) then begin
      AIndex := Rows.Count;
      Result := 1;
      AFound := False;
    end;
  end;
end;
{$IFNDEF AnyDAC_D12}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDatSView.GetFindRow: TADDatSRow;
begin
  if FFindRow = nil then
    FFindRow := Table.NewRow(False)
  else begin
    if FFindRow.FpCurrent <> nil then
      FFindRow.CleanupBuffer(FFindRow.FpCurrent);
    if FFindRow.FpProposed <> nil then
      FFindRow.CleanupBuffer(FFindRow.FpProposed);
  end;
  Result := FFindRow;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.Find(const AValues: array of Variant;
  AOptions: TADLocateOptions): Integer;
var
  oRow: TADDatSRow;
  i: Integer;
begin
  ASSERT(Table <> nil);
  if SortingMechanism = nil then begin
    Result := -1;
    Exit;
  end;
  oRow := GetFindRow;
  if SortingMechanism.SortSource = ssRowId then
    oRow.FRowID := AValues[0]
  else begin
    oRow.BeginForceWrite;
    for i := Low(AValues) to High(AValues) do
      oRow.SetData(SortingMechanism.SortColumnList[i - Low(AValues)], AValues[i]);
    oRow.EndForceWrite;
  end;
  Result := Find(oRow, AOptions);
end;

{-------------------------------------------------------------------------------}
function TADDatSView.Find(ARow: TADDatSRow; AOptions: TADLocateOptions): Integer;
var
  lFound: Boolean;
begin
  ASSERT(Table <> nil);
  if SortingMechanism = nil then begin
    Result := -1;
    Exit;
  end;
  lFound := False;
  Search(ARow, nil, nil, -1, AOptions, Result, lFound);
  if not lFound then
    Result := -1;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.Find(const AValues: array of Variant; const AColumns: String;
  AOptions: TADLocateOptions): Integer;
var
  oRow: TADDatSRow;
  i: Integer;
  lFound: Boolean;
  oKeyCols: TADDatSColumnSublist;
begin
  ASSERT(Table <> nil);
  oKeyCols := TADDatSColumnSublist.Create;
  try
    oKeyCols.Fill(Self, AColumns);
    oRow := GetFindRow;
    if (SortingMechanism <> nil) and (SortingMechanism.SortSource = ssRowId) then
      oRow.FRowID := AValues[0]
    else begin
      oRow.BeginForceWrite;
      for i := 0 to oKeyCols.Count - 1 do
        oRow.SetData(oKeyCols.ItemsI[i], AValues[i]);
      oRow.EndForceWrite;
    end;
    lFound := False;
    Result := -1;
    Search(oRow, oKeyCols, nil, -1, AOptions, Result, lFound);
    if not lFound then
      Result := -1;
  finally
    ADFree(oKeyCols);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.Find(ARow: TADDatSRow; const AColumns: String;
  AOptions: TADLocateOptions): Integer;
var
  lFound: Boolean;
  oKeyCols: TADDatSColumnSublist;
begin
  ASSERT(Table <> nil);
  oKeyCols := TADDatSColumnSublist.Create;
  try
    oKeyCols.Fill(Self, AColumns);
    lFound := False;
    Result := -1;
    Search(ARow, oKeyCols, nil, -1, AOptions, Result, lFound);
    if not lFound then
      Result := -1;
  finally
    ADFree(oKeyCols);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.IndexOf(AKeyRow: TADDatSRow; ARowVersion: TADDatSRowVersion;
  APossibleIndex: Integer): Integer;
var
  iIndex: Integer;
  lFound: Boolean;
begin
  ASSERT(AKeyRow <> nil);
  if (AKeyRow.FRowID < LongWord(Rows.Count)) and (Rows.ItemsI[AKeyRow.FRowID] = AKeyRow) then
    Result := AKeyRow.FRowID
  else if (APossibleIndex >= 0) and (APossibleIndex < Rows.Count) and
          (Rows.ItemsI[APossibleIndex] = AKeyRow) then
    Result := APossibleIndex
  else if (SortingMechanism <> nil) and
          (SortingMechanism.SortOptions * [soUnique, soPrimary] <> []) then begin
    lFound := False;
    iIndex := -1;
    SortingMechanism.Search(Rows, AKeyRow, nil, nil, -1, [], iIndex, lFound, ARowVersion);
    if lFound then
      Result := iIndex
    else
      Result := -1;
  end
  else
    Result := Rows.IndexOf(AKeyRow);
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetGroupState(ARecordIndex, AGroupingLevel: Integer): TADDatSGroupPositions;
var
  lMiddle: Boolean;
begin
  Result := [];
  lMiddle := True;
  if (ARecordIndex <= 0) or (AGroupingLevel <> 0) and (SortingMechanism <> nil) and (ARecordIndex < Rows.Count) and
     (SortingMechanism.CompareRows(Rows[ARecordIndex - 1], Rows[ARecordIndex], AGroupingLevel) <> 0) then begin
    Include(Result, gpFirst);
    lMiddle := False;
  end;
  if (ARecordIndex >= Rows.Count - 1) or (AGroupingLevel <> 0) and (SortingMechanism <> nil) and (ARecordIndex >= 0) and
     (SortingMechanism.CompareRows(Rows[ARecordIndex], Rows[ARecordIndex + 1], AGroupingLevel) <> 0) then begin
    Include(Result, gpLast);
    lMiddle := False;
  end;
  if lMiddle then
    Include(Result, gpMiddle);
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetGroupingLevel: Integer;
begin
  Result := 0;
  if SortingMechanism <> nil then
    case SortingMechanism.SortSource of
    ssColumns:    Result := SortingMechanism.SortColumnList.Count;
    ssExpression: Result := 1;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetMechanismByClass(AClass: TADDatSMechBaseClass;
  AKind: TADDatSMechanismKind): TADDatSMechBase;
var
  i: Integer;
  oMech: TADDatSMechBase;
begin
  Result := nil;
  for i := 0 to Mechanisms.Count - 1 do begin
    oMech := Mechanisms[i];
    if (AKind in oMech.Kinds) and (oMech is AClass) then begin
      Result := oMech;
      Exit;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetRowFilter: String;
var
  oFlt: TADDatSMechFilter;
begin
  oFlt := TADDatSMechFilter(GetMechanismByClass(TADDatSMechFilter, mkFilter));
  if oFlt = nil then
    Result := ''
  else
    Result := oFlt.Expression;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.SetRowFilter(const AValue: String);
var
  oFlt: TADDatSMechFilter;
begin
  oFlt := TADDatSMechFilter(GetMechanismByClass(TADDatSMechFilter, mkFilter));
  if oFlt = nil then
    Mechanisms.AddFilter(AValue)
  else begin
    oFlt.Expression := AValue;
    oFlt.Active := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetRowStateFilter: TADDatSRowStates;
var
  oState: TADDatSMechRowState;
begin
  oState := TADDatSMechRowState(GetMechanismByClass(TADDatSMechRowState, mkFilter));
  if oState = nil then
    Result := [rsInitializing .. rsImportingProposed]
  else
    Result := oState.RowStates;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.SetRowStateFilter(const AValue: TADDatSRowStates);
var
  oState: TADDatSMechRowState;
begin
  oState := TADDatSMechRowState(GetMechanismByClass(TADDatSMechRowState, mkFilter));
  if oState = nil then
    Mechanisms.AddStates(AValue)
  else begin
    oState.RowStates := AValue;
    oState.Active := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSView.GetSort: String;
var
  oSort: TADDatSMechSort;
begin
  oSort := TADDatSMechSort(GetMechanismByClass(TADDatSMechSort, mkSort));
  if oSort = nil then
    Result := ''
  else
    Result := oSort.Columns;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.SetSort(const AValue: String);
var
  oSort: TADDatSMechSort;
begin
  oSort := TADDatSMechSort(GetMechanismByClass(TADDatSMechSort, mkSort));
  if oSort = nil then
    Mechanisms.AddSort(AValue)
  else begin
    oSort.Columns := AValue;
    oSort.Active := True;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D12}
  {$WARNINGS OFF}
{$ENDIF}
function TADDatSView.Locate(var ARowIndex: Integer; AGoForward, ARestart: Boolean): Boolean;
var
  i, iMechs: Integer;
  oRow: TADDatSRow;
  oMech: TADDatSMechBase;
begin
  if ARestart then
    if AGoForward then
      ARowIndex := 0
    else
      ARowIndex := Rows.Count - 1
  else
    if AGoForward then
      Inc(ARowIndex)
    else
      Dec(ARowIndex);
  Result := False;
  iMechs := Mechanisms.Count - 1;
  while (ARowIndex < Rows.Count) and (ARowIndex >= 0) do begin
    oRow := Rows.ItemsI[ARowIndex];
    i := 0;
    while i <= iMechs do begin
      oMech := Mechanisms.ItemsI[i];
      if oMech.Locator and oMech.ActualActive and
         not oMech.AcceptRow(oRow, rvDefault) then
        Break;
      Inc(i);
    end;
    if i = iMechs + 1 then begin
      Result := True;
      Exit;
    end;
    if AGoForward then
      Inc(ARowIndex)
    else
      Dec(ARowIndex);
  end;
end;
{$IFNDEF AnyDAC_D12}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADDatSView.DeleteAll(AAcceptChanges: Boolean = False);
var
  i: Integer;
  oRow: TADDatSRow;
begin
  for i := Rows.Count - 1 downto 0 do begin
    oRow := Rows.ItemsI[i];
    oRow.Delete;
    if AAcceptChanges then
      oRow.AcceptChanges();
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.ResolveActive(const AName, AValue: String);
begin
  if SameText(AName, 'Active') and SameText(AValue, S_AD_True) then
    Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.InternalLoadFromStorage(AStorage: TADStorage);
var
  sName: String;
  lActive: Boolean;
begin
  Active := False;
  inherited InternalLoadFromStorage(AStorage);
  lActive := AStorage.ReadBoolean('Active', False);
  if lActive then
    AStorage.DeferAction('Active', S_AD_True, ResolveActive);
  sName := AStorage.ReadString('SourceView', '');
  if sName <> '' then
    SourceView := ViewList.ViewByName(sName);
  Mechanisms.LoadFromStorage(AStorage);
  Aggregates.LoadFromStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSView.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  AStorage.WriteBoolean('Active', Active, False);
  if SourceView <> nil then
    AStorage.WriteString('SourceView', SourceView.Name, '');
  Mechanisms.SaveToStorage(AStorage);
  Aggregates.SaveToStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
{- TADDatSViewList                                                             -}
{-------------------------------------------------------------------------------}
constructor TADDatSViewList.CreateForTable(ATable: TADDatSTable);
begin
  ASSERT(ATable <> nil);
  inherited Create;
  FActive := True;
  FOwner := ATable;
  OwnObjects := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewList.Assign(AObj: TADDatSObject);
begin
  Active := False;
  inherited Assign(AObj);
  if AObj is TADDatSViewList then
    Active := TADDatSViewList(AObj).Active;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewList.HandleNotification(AParam: PADDatSNotifyParam);
begin
  if (AParam^.FReason = srDataChange) and
     (TADDatSTable(Owner).DataHandleMode in [lmHavyMove, lmHavyFetching,
                                             lmHavyLoading]) then
    Exit;
  inherited HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewList.SetActive(const AValue: Boolean);
var
  i: Integer;
begin
  if FActive <> AValue then begin
    FActive := AValue;
    if FActive then
      for i := 0 to Count - 1 do
        ItemsI[i].CheckActiveChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSViewList.Add(AObj: TADDatSView): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewList.Add(const AName: String): TADDatSView;
begin
  Result := TADDatSView.Create;
  Result.Name := AName;
  Result.Active := True;
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewList.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].Active := False;
  inherited Clear;
end;

{-------------------------------------------------------------------------------}
function TADDatSViewList.GetItemsI(AIndex: Integer): TADDatSView;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSView(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSViewList.ViewByName(const AName: String): TADDatSView;
begin
  Result := TADDatSView(inherited ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
function TADDatSViewList.FindSortedView(const AColumns: String;
  ARequiredOptions, AProhibitedOptions: TADSortOptions): TADDatSView;
var
  i: Integer;
  oView: TADDatSView;
  oSortMech: IADDatSMechSort;
begin
  Result := nil;
  for i := 0 to Count - 1 do begin
    oView := ItemsI[i];
    if oView.Actual and (oView.Mechanisms.Count = 1) and
       (oView.Mechanisms.ItemsI[0].Kinds = [mkSort]) and
       Supports(oView.Mechanisms.ItemsI[0], IADDatSMechSort, oSortMech) and
       oSortMech.SortingOn(AColumns, ARequiredOptions, AProhibitedOptions) then begin
      Result := oView;
      Break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewList.Rebuild;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    ItemsI[i].Rebuild;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSViewList.InternalSaveToStorage(AStorage: TADStorage);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if ItemsI[i].Creator = vcUser then
      AStorage.SaveObject(ItemsI[i]);
end;

{-------------------------------------------------------------------------------}
{- TADDatSTable                                                                -}
{-------------------------------------------------------------------------------}
constructor TADDatSTable.Create;
begin
  inherited Create;
  FColumns := TADDatSColumnList.CreateForTable(Self);
  FConstraints := TADDatSConstraintList.CreateForTable(Self);
  FRows := TADDatSTableRowList.CreateForTable(Self);
  FViews := TADDatSViewList.CreateForTable(Self);
  FUpdates := TADDatSUpdatesJournal.Create(Self);
  FUpdatesRegistry := True;
  FRefs := TADRefCounter.Create(Self);
  FLocale := LOCALE_USER_DEFAULT;
  FCaseSensitive := True;
  FCheckNotNull := True;
  FCheckReadOnly := True;
end;

{-------------------------------------------------------------------------------}
constructor TADDatSTable.Create(const AName: String);
begin
  Create;
  if AName <> '' then
    Name := AName;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSTable.Destroy;
begin
  FViews.Clear;
  FConstraints.Clear;
  FDataHandleMode := lmDestroying;
  ADFreeAndNil(FUpdates);
  ADFreeAndNil(FViews);
  ADFreeAndNil(FRows);
  ADFreeAndNil(FConstraints);
  ADFreeAndNil(FColumns);
  FDefaultView := nil;
  FErrors := nil;
  ADFreeAndNil(FRefs);
  ADFreeAndNil(FDataCallbacks);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Assign(AObj: TADDatSObject);
begin
  Reset;
  inherited Assign(AObj);
  if AObj is TADDatSTable then begin
    Rows.MinimumCapacity := TADDatSTable(AObj).Rows.MinimumCapacity;
    FCaseSensitive := TADDatSTable(AObj).CaseSensitive;
    FLocale := TADDatSTable(AObj).Locale;
    FUpdatesRegistry := TADDatSTable(AObj).FUpdatesRegistry;
    FRound2Scale := TADDatSTable(AObj).UpdatesRegistry;
    FStrsTrim2Len := TADDatSTable(AObj).StrsTrim2Len;
    FCheckNotNull := TADDatSTable(AObj).CheckNotNull;
    FCheckReadOnly := TADDatSTable(AObj).CheckReadOnly;
    Columns.Assign(TADDatSTable(AObj).Columns);
    Views.Assign(TADDatSTable(AObj).Views);
    if TADDatSTable(AObj).FDefaultView <> nil then
      FDefaultView := Views.ViewByName(TADDatSTable(AObj).FDefaultView.Name);
    if TADDatSTable(AObj).FErrors <> nil then
      FErrors := Views.ViewByName(TADDatSTable(AObj).FErrors.Name);
    if TADDatSTable(AObj).FChanges <> nil then
      FDefaultView := Views.ViewByName(TADDatSTable(AObj).FChanges.Name);
    Constraints.Assign(TADDatSTable(AObj).Constraints);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then
    Result := (MinimumCapacity = TADDatSTable(AObj).MinimumCapacity) and
      (CaseSensitive = TADDatSTable(AObj).CaseSensitive) and
      (Locale = TADDatSTable(AObj).Locale) and
      (Round2Scale = TADDatSTable(AObj).UpdatesRegistry) and
      (StrsTrim2Len = TADDatSTable(AObj).StrsTrim2Len) and
      (CheckNotNull = TADDatSTable(AObj).CheckNotNull) and
      (CheckReadOnly = TADDatSTable(AObj).CheckReadOnly) and
      (EnforceConstraints = TADDatSTable(AObj).EnforceConstraints) and
      Columns.IsEqualTo(TADDatSTable(AObj).Columns) and
      Constraints.IsEqualTo(TADDatSTable(AObj).Constraints) and
      (UpdatesRegistry = TADDatSTable(AObj).FUpdatesRegistry);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.CountRef(AInit: Integer = 1);
begin
  FRefs.CountRef(AInit);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.AddRef;
begin
  FRefs.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.RemRef;
begin
  FRefs.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetIsRefCounted: Boolean;
begin
  Result := FRefs.Refs >= 0;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetRefCount: Integer;
begin
  Result := FRefs.Refs;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetTable: TADDatSTable;
begin
  Result := Self;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetManager: TADDatSManager;
begin
  Result := FManager;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.CheckLayoutChanging;
begin
  if (DataHandleMode <> lmDestroying) and (Rows.Count > 0) then
    ADException(Self, [S_AD_LDatS], er_AD_CantChangeTableStruct, [Name]);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.DoListRemoving;
begin
  if FDataHandleMode = lmDestroying then
    Exit;
  Views.Active := False;
  Reset;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.DoListRemoved(ANewOwner: TADDatSObject);
begin
  FManager := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.DoListInserted;
begin
  inherited DoListInserted;
  FManager := inherited GetManager;
  if Manager <> nil then
    FUpdatesRegistry := not Manager.UpdatesRegistry;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D12}
  {$WARNINGS OFF}
{$ENDIF}
procedure TADDatSTable.AcceptChanges;
var
  i: Integer;
  lastState: TADDatSRowState;
begin
  if UpdatesRegistry then
    Updates.AcceptChanges(Self)
  else begin
    i := 0;
    while i < Rows.Count do begin
      lastState := Rows.ItemsI[i].RowState;
      Rows.ItemsI[i].AcceptChanges;
      if lastState <> rsDeleted then
        Inc(i);
    end;
  end;
end;
{$IFNDEF AnyDAC_D12}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADDatSTable.UpdateLayout;
begin
  Columns.CheckUpdateLayout(TADDatSRow.InstanceSize);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.BeginLoadData(var AState: TADDatSLoadState; ADataHandleMode: TADDatSHandleMode = lmHavyMove);
var
  i: Integer;
  oChildTab: TADDatSTable;
  pChildState: PADDatSLoadState;
  oCol: TADDatSColumn;
begin
  if FDataHandleMode <> lmStandard then begin
    AState.FRestoreState := False;
    Exit;
  end;
  AState.FRestoreState := True;
  UpdateLayout;
  if ADataHandleMode in [lmHavyFetching, lmHavyMove, lmDestroying, lmHavyLoading] then
    LockNotification;
  if ADataHandleMode <> lmRefreshing then begin
    AState.FConstraintsEnforce := Constraints.Enforce;
    Constraints.Enforce := False;
  end;
  if ADataHandleMode in [lmHavyFetching, lmHavyMove, lmDestroying, lmHavyLoading] then begin
    AState.FViewsActive := Views.Active;
    Views.Active := False;
  end;
  AState.FPrevMode := FDataHandleMode;
  FDataHandleMode := ADataHandleMode;
  if ADataHandleMode in [lmHavyFetching, lmFetching] then
    Rows.FLastRowCount := Rows.Count;
  SetLength(AState.FSubStates, 0);
  if ctInvars in Columns.FHasThings then
    for i := 0 to Columns.Count - 1 do begin
      oCol := Columns.ItemsI[i];
      if oCol.DataType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef] then begin
        oChildTab := oCol.NestedTable;
        if oChildTab <> nil then begin
          New(pChildState);
          SetLength(AState.FSubStates, Length(AState.FSubStates) + 1);
          AState.FSubStates[Length(AState.FSubStates) - 1] := pChildState;
          oChildTab.BeginLoadData(pChildState^, ADataHandleMode);
        end;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.EndLoadData(const AState: TADDatSLoadState);
var
  i, j: Integer;
  oChildTab: TADDatSTable;
  lGlobalChanges, lRefreshing: Boolean;
  oCol: TADDatSColumn;
begin
  if (FDataHandleMode = lmStandard) or not AState.FRestoreState then
    Exit;
  if ctInvars in Columns.FHasThings then
    try
      j := 0;
      for i := 0 to Columns.Count - 1 do begin
        oCol := Columns.ItemsI[i];
        if oCol.DataType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef] then begin
          oChildTab := oCol.NestedTable;
          if oChildTab <> nil then begin
            oChildTab.EndLoadData(AState.FSubStates[j]^);
            Inc(j);
          end;
        end;
      end;
    finally
      for i := 0 to Length(AState.FSubStates) - 1 do
        Dispose(AState.FSubStates[i]);
    end;
  lGlobalChanges := (FDataHandleMode in [lmHavyFetching, lmHavyMove, lmDestroying,
                                         lmHavyLoading]);
  lRefreshing := (FDataHandleMode = lmRefreshing);
  FDataHandleMode := AState.FPrevMode;
  try
    if lGlobalChanges and AState.FViewsActive then begin
      Views.Active := True;
      Views.Rebuild;
    end;
    if not lRefreshing and AState.FConstraintsEnforce then
      Constraints.Enforce := True;
    if lGlobalChanges then
      UnlockNotification;
  finally
    Rows.FLastRowCount := -1;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Clear;
var
  rState: TADDatSLoadState;
begin
  if (FDataHandleMode = lmDestroying) or (Rows.Count = 0) then
    Exit;
  BeginLoadData(rState, lmDestroying);
  try
    Rows.Clear;
    if Updates <> nil then
      Updates.Clear;
  finally
    EndLoadData(rState);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.Copy: TADDatSTable;
var
  i: Integer;
  rState: TADDatSLoadState;
begin
  Result := TADDatSTable.Create;
  try
    Result.Assign(Self);
    Result.BeginLoadData(rState);
    try
      for i := 0 to Rows.Count - 1 do
        Result.Import(Rows.ItemsI[i]);
    finally
      Result.EndLoadData(rState);
    end;
  except
    ADFree(Result);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetBaseView(AStates: TADDatSRowStates): TADDatSView;
begin
  if FDefaultView = nil then begin
    FDefaultView := TADDatSView.Create(Self, '', '', AStates);
    try
      FDefaultView.Creator := vcDefaultView;
      FDefaultView.Name := Views.BuildUniqueName(C_AD_SysNamePrefix + 'ADF');
    except
      ADFreeAndNil(FDefaultView);
      raise;
    end;
  end;
  Result := FDefaultView;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetDefaultView: TADDatSView;
begin
  Result := GetBaseView(C_AllViewRows);
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetFullView: TADDatSView;
begin
  Result := GetBaseView(C_AllViewRows + [rsDeleted]);
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetEnforceConstraints: Boolean;
begin
  Result := Constraints.Enforce;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetErrors: TADDatSView;
begin
  if FErrors = nil then begin
    FErrors := TADDatSView.Create(Self, C_AD_SysNamePrefix + 'ERR',
      vcErrorView, False);
    try
      FErrors.Mechanisms.AddError;
      FErrors.Active := True;
    except
      ADFreeAndNil(FErrors);
      raise;
    end;
  end;
  Result := FErrors;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetHasErrors: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Rows.Count - 1 do
    if Rows.ItemsI[i].HasErrors then begin
      Result := True;
      Exit;
    end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetTableList: TADDatSTableList;
begin
  Result := List as TADDatSTableList;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.HandleNotification(AParam: PADDatSNotifyParam);
begin
  if (AParam^.FReason = srDataChange) and
     (DataHandleMode in [lmHavyMove, lmHavyFetching, lmHavyLoading]) then
    Exit;
  if Columns <> nil then
    Columns.HandleNotification(AParam);
  if Constraints <> nil then
    Constraints.HandleNotification(AParam);
  if Rows <> nil then
    Rows.HandleNotification(AParam);
  if Views <> nil then
    Views.HandleNotification(AParam);
  if AParam^.FKind = snObjectRemoved then
    if AParam^.FParam2 = TADNativeInt(FDefaultView) then
      FDefaultView := nil
    else if AParam^.FParam2 = TADNativeInt(FErrors) then
      FErrors := nil
    else if AParam^.FParam2 = TADNativeInt(FChanges) then
      FChanges := nil;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.HasChanges(ARowStates: TADDatSRowStates): Boolean;
var
  i: Integer;
begin
  if UpdatesRegistry then
    Result := Updates.HasChanges(Self)
  else begin
    Result := False;
    for i := 0 to Rows.Count - 1 do
      if Rows.ItemsI[i].RowState in ARowStates then begin
        Result := True;
        Break;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetChangesView(ARowStates: TADDatSRowStates): TADDatSView;
begin
  if FChanges = nil then begin
    FChanges := TADDatSView.Create(Self, C_AD_SysNamePrefix + 'CHV',
      vcChangesView, False);
    try
      FChanges.Mechanisms.AddStates(ARowStates);
      FChanges.Active := True;
    except
      ADFreeAndNil(FChanges);
      raise;
    end;
  end;
  Result := FChanges;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetChanges2: TADDatSView;
begin
  Result := GetChangesView;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetChanges(ARowStates: TADDatSRowStates): TADDatSTable;
begin
  Result := TADDatSTable.Create;
  Result.Assign(Self);
  Result.Import(GetChangesView(ARowStates));
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.Select(const AFilter, ASort: String;
  AStates: TADDatSRowStates): TADDatSView;
begin
  Result := TADDatSView.Create(Self, AFilter, ASort, AStates);
  Result.Name := Views.BuildUniqueName(C_AD_SysNamePrefix + 'SEL');
  Result.Creator := vcSelectView;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.ImportRow(ASrcRow: TADDatSRow);
begin
  Import(ASrcRow, nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.MakeColumnMap(ASrcRow: TADDatSRow; out AColumnMap: TADArrayOfInteger);
var
  i: Integer;
  oSrcTab: TADDatSTable;
begin
  ASSERT(ASrcRow <> nil);
  SetLength(AColumnMap, Columns.Count);
  oSrcTab := ASrcRow.Table;
  for i := 0 to Columns.Count - 1 do
    if oSrcTab = Self then
      AColumnMap[i] := i
    else begin
      AColumnMap[i] := oSrcTab.Columns.IndexOfName(Columns[i].Name);
      if (AColumnMap[i] >= 0) and
         (Columns[i].DataType in [dtRowSetRef, dtCursorRef, dtRowRef,
                                  dtArrayRef, dtParentRowRef]) and
         (Columns[i].DataType <> oSrcTab.Columns[AColumnMap[i]].DataType) then
        AColumnMap[i] := -1;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Import(ASrcRow, ADestRow: TADDatSRow;
  const AColumnMap: TADArrayOfInteger);
var
  oSrcTab: TADDatSTable;
  iDestColInd, iSrcColInd: Integer;
  i, iAssignMode: Integer;

  procedure AssignColData(ABuffKind: TADDatSRowState);
  var
    iPriorSrcRowState, iPriorDestRowState: TADDatSRowState;
    iLen: LongWord;
    pBuff: Pointer;
  begin
    iPriorSrcRowState := ASrcRow.RowState;
    iPriorDestRowState := ADestRow.RowState;
    ASrcRow.FRowState := ABuffKind;
    ADestRow.FRowState := ABuffKind;
    try
      if ASrcRow.GetBuffer(rvDefault) <> nil then begin
        if ADestRow.GetBuffer(rvDefault) = nil then
          case ABuffKind of
          rsImportingCurent:
            begin
              ASSERT(ADestRow.FpCurrent = nil);
              ADestRow.FpCurrent := ADestRow.AllocBuffer;
            end;
          rsImportingOriginal:
            begin
              ASSERT(ADestRow.FpOriginal = nil);
              ADestRow.FpOriginal := ADestRow.AllocBuffer;
            end;
          rsImportingProposed:
            begin
              ASSERT(ADestRow.FpProposed = nil);
              ADestRow.FpProposed := ADestRow.AllocBuffer;
            end;
          end;
        if iAssignMode = 1 then
          ADestRow.SetData(iDestColInd, ASrcRow.GetData(iSrcColInd, rvDefault))
        else if iAssignMode = 2 then begin
          iLen := 0;
          pBuff := nil;
          ASrcRow.GetData(iSrcColInd, rvDefault, pBuff, 0, iLen, False);
          ADestRow.SetData(iDestColInd, pBuff, iLen);
        end;
      end;
    finally
      ASrcRow.FRowState := iPriorSrcRowState;
      ADestRow.FRowState := iPriorDestRowState;
    end;
  end;

  procedure ImportNestedRows;
  var
    oSrcNestedRow, oDestNestedRow: TADDatSRow;
    oDestNestedTab: TADDatSTable;
    oSrcNestedRows: TADDatSNestedRowList;
    j: Integer;
    aMap: TADArrayOfInteger;
  begin
    if iAssignMode = 2 then begin
      case oSrcTab.Columns.ItemsI[iSrcColInd].DataType of
      dtRowRef, dtArrayRef:
        begin
          oSrcNestedRow := ASrcRow.NestedRow[iSrcColInd];
          if oSrcNestedRow <> nil then begin
            oDestNestedTab := Columns.ItemsI[iDestColInd].NestedTable;
            oDestNestedTab.MakeColumnMap(oSrcNestedRow, aMap);
            oDestNestedRow := oDestNestedTab.NewRow(True);
            try
              oDestNestedRow.ParentRow := ADestRow;
              oDestNestedTab.Import(oSrcNestedRow, oDestNestedRow, aMap);
            except
              ADFree(oDestNestedRow);
              raise;
            end;
          end;
        end;
      dtRowSetRef, dtCursorRef:
        begin
          oSrcNestedRows := ASrcRow.NestedRows[iSrcColInd];
          if oSrcNestedRows.Count <> 0 then begin
            oDestNestedTab := Columns.ItemsI[iDestColInd].NestedTable;
            oDestNestedTab.MakeColumnMap(oSrcNestedRows[0], aMap);
            for j := 0 to oSrcNestedRows.Count - 1 do begin
              oDestNestedRow := oDestNestedTab.NewRow(True);
              try
                oDestNestedRow.ParentRow := ADestRow;
                oDestNestedTab.Import(oSrcNestedRows.ItemsI[j], oDestNestedRow, aMap);
              except
                ADFree(oDestNestedRow);
                raise;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

begin
  ASSERT((ASrcRow <> nil) and (ASrcRow <> ADestRow) and
         ((ADestRow = nil) or (ADestRow.Table = Self)));
  oSrcTab := ASrcRow.Table;
  if ADestRow = nil then
    ADestRow := NewRow(True)
  else begin
    if ASrcRow.FpOriginal = nil then
      ADestRow.FreeBuffer(ADestRow.FpOriginal);
    if ASrcRow.FpCurrent = nil then
      ADestRow.FreeBuffer(ADestRow.FpCurrent);
    if ASrcRow.FpProposed = nil then
      ADestRow.FreeBuffer(ADestRow.FpProposed);
  end;
  try
    for i := 0 to Columns.Count - 1 do begin
      iDestColInd := i;
      iSrcColInd := AColumnMap[i];
      if iSrcColInd < 0 then
        iAssignMode := 0
      else if Columns[i].DataType <> oSrcTab.Columns[iSrcColInd].DataType then
        iAssignMode := 1
      else
        iAssignMode := 2;

      if Columns[i].DataType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef, dtParentRowRef] then
        ImportNestedRows
      else begin
        AssignColData(rsImportingCurent);
        AssignColData(rsImportingOriginal);
        AssignColData(rsImportingProposed);
      end;
    end;
    if not ((ASrcRow.RowState in [rsInitializing, rsDetached]) or
            (ASrcRow.RowState = rsForceWrite) and (ASrcRow.RowPriorState = rsDetached)) and
       ((ADestRow.RowState in [rsInitializing, rsDetached]) or
        (ADestRow.RowState = rsForceWrite) and (ADestRow.RowPriorState = rsDetached)) then begin
      // sign, that we are importing row, not a real rowstate
      if ASrcRow.RowState in [rsUnchanged, rsDeleted] then
        ADestRow.FRowState := rsImportingOriginal
      else
        ADestRow.FRowState := rsImportingCurent;
      Rows.Add(ADestRow);
    end;
    ADestRow.FRowState := ASrcRow.RowState;
    ADestRow.FRowPriorState := ASrcRow.RowPriorState;
    ADestRow.RowError := ASrcRow.RowError;
    if not ((ADestRow.RowState in [rsInitializing, rsDetached]) or
            (ADestRow.RowState = rsForceWrite) and (ADestRow.RowPriorState = rsDetached)) then begin
      if ADestRow.RowState <> rsInserted then
        ADestRow.Notify(snRowStateChanged, srDataChange, TADNativeInt(ADestRow), 0);
      if ADestRow.RowError <> nil then
        ADestRow.Notify(snRowErrorStateChanged, srDataChange, TADNativeInt(ADestRow), 0);
      if ADestRow.RowState in [rsInserted, rsDeleted, rsModified] then
        ADestRow.RegisterChange;
    end;
    if not ((ADestRow.RowState in [rsEditing, rsInitializing, rsDetached]) or
            (ADestRow.RowState = rsForceWrite) and (ADestRow.RowPriorState = rsDetached)) and
       (ADestRow.FpProposed <> nil) then
      ADestRow.FreeBuffer(ADestRow.FpProposed);
  except
    ADFree(ADestRow);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Import(ASrcRow: TADDatSRow; ADestRow: TADDatSRow = nil);
var
  aMap: TADArrayOfInteger;
begin
  ASSERT(ASrcRow <> nil);
  MakeColumnMap(ASrcRow, aMap);
  Import(ASrcRow, ADestRow, aMap);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Import(ARowList: TADDatSRowListBase);
var
  i: Integer;
  aMap: TADArrayOfInteger;
  rState: TADDatSLoadState;
begin
  ASSERT(ARowList <> nil);
  if ARowList.Count > 0 then begin
    MakeColumnMap(ARowList[0], aMap);
    BeginLoadData(rState);
    try
      for i := 0 to ARowList.Count - 1 do
        Import(ARowList.ItemsI[i], nil, aMap);
    finally
      EndLoadData(rState);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Import(AView: TADDatSView);
begin
  ASSERT(AView <> nil);
  Import(AView.Rows);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Import(ATable: TADDatSTable);
begin
  ASSERT(ATable <> nil);
  Import(ATable.Rows);
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.NewRow(ASetToDefaults: Boolean): TADDatSRow;
begin
  Result := TADDatSRow.CreateInstance(Self, ASetToDefaults);
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.NewRow(const AValues: array of Variant;
  ASetToDefaults: Boolean): TADDatSRow;
begin
  Result := NewRow(ASetToDefaults);
  Result.SetValues(AValues);
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.NewRow(ASetToDefaults: Boolean;
  const AParentRows: array of TADDatSRow): TADDatSRow;
var
  oCons: TADDatSConstraintBase;
  i, j: Integer;
begin
  Result := NewRow(ASetToDefaults);
  for i := Low(AParentRows) to High(AParentRows) do
    if AParentRows[i] <> nil then
      for j := 0 to Constraints.Count - 1 do begin
        oCons := Constraints.ItemsI[j];
        if (oCons is TADDatSForeignKeyConstraint) and oCons.ActualEnforce and
           (TADDatSForeignKeyConstraint(oCons).InsertRule = crCascade) and
           (TADDatSForeignKeyConstraint(oCons).RelatedTable = AParentRows[i].Table) then
          TADDatSForeignKeyConstraint(oCons).DoInsertAssignParentValues(AParentRows[i], Result);
      end;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D12}
  {$WARNINGS OFF}
{$ENDIF}
procedure TADDatSTable.RejectChanges;
var
  i: Integer;
  lastState: TADDatSRowState;
begin
  if UpdatesRegistry then
    Updates.RejectChanges(Self)
  else begin
    i := 0;
    while i < Rows.Count do begin
      lastState := Rows.ItemsI[i].RowState;
      Rows.ItemsI[i].RejectChanges;
      if lastState <> rsInserted then
        Inc(i);
    end;
  end;
end;
{$IFNDEF AnyDAC_D12}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDatSTable.GetChildRelations: TADDatSRelationArray;
var
  oManager: TADDatSManager;
begin
  oManager := Manager;
  if oManager <> nil then
    Result := oManager.Relations.GetRelationsForTable(False, Self);
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetParentRelations: TADDatSRelationArray;
var
  oManager: TADDatSManager;
begin
  oManager := Manager;
  if oManager <> nil then
    Result := oManager.Relations.GetRelationsForTable(True, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Reset;
var
  i: Integer;
  oRels: TADDatSRelationArray;
begin
  oRels := nil;
  if FDataHandleMode = lmDestroying then
    Exit;
  FDataHandleMode := lmDestroying;
  try
    Constraints.Clear;
    Views.Clear;
    Updates.Clear;
    Rows.Clear;
    oRels := ParentRelations;
    for i := 0 to Length(oRels) - 1 do
      ADFree(oRels[i]);
    oRels := ChildRelations;
    for i := 0 to Length(oRels) - 1 do
      ADFree(oRels[i]);
    Columns.Clear;
  finally
    FDataHandleMode := lmStandard;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.SetEnforceConstraints(const AValue: Boolean);
begin
  Constraints.Enforce := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetMinimumCapacity: Integer;
begin
  Result := Rows.MinimumCapacity;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.SetMinimumCapacity(const AValue: Integer);
begin
  Rows.MinimumCapacity := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.LoadDataRow(const AValues: array of Variant;
  AAcceptChanges: Boolean): TADDatSRow;
var
  oNewRow, oTrgRow: TADDatSRow;
  i: Integer;
begin
  i := -1;
  Result := nil;
  oNewRow := NewRow(AValues, True);
  try
    i := FindRowByPK(oNewRow);
    if i = -1 then begin
      Rows.Add(oNewRow);
      if AAcceptChanges then
        oNewRow.AcceptChanges;
      Result := oNewRow;
    end
    else begin
      oTrgRow := Rows[i];
      oTrgRow.CancelEdit;
      oTrgRow.BeginEdit;
      try
        oTrgRow.SetValues(AValues);
        oTrgRow.EndEdit;
      except
        oTrgRow.CancelEdit;
        raise;
      end;
      if AAcceptChanges then
        oTrgRow.AcceptChanges;
      Result := oTrgRow;
    end;
  finally
    if i <> -1 then
      ADFree(oNewRow);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.FindRowByPK(ARow: TADDatSRow): Integer;
var
  oKey: TADDatSUniqueConstraint;
  oView: TADDatSView;
begin
  oKey := Constraints.FindPrimaryKey();
  if oKey = nil then
    Result := -1
  else begin
    oView := oKey.GetUniqueSortedView();
    Result := oView.Find(ARow, []);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.Compute(const AExpression, AFilter: String): Variant;
var
  oView: TADDatSView;
begin
  oView := Select(AFilter);
  try
    if oView.Rows.Count = 0 then
      Result := Null
    else
      Result := oView.Aggregates.Add('', AExpression).Value[0];
  finally
    ADFree(oView);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.SetLocale(const AValue: TADLocalID);
begin
  if FLocale <> AValue then begin
    FLocale := AValue;
    Views.Rebuild;
    Constraints.CheckAll;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.SetCaseSensitive(const AValue: Boolean);
begin
  if FCaseSensitive <> AValue then begin
    FCaseSensitive := AValue;
    Views.Rebuild;
    Constraints.CheckAll;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetPrimaryKey: String;
var
  oKey: TADDatSUniqueConstraint;
begin
  oKey := Constraints.FindPrimaryKey();
  if oKey <> nil then
    Result := oKey.ColumnNames
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.SetPrimaryKey(const AValue: String);
var
  oKey: TADDatSUniqueConstraint;
begin
  if PrimaryKey <> AValue then begin
    oKey := Constraints.FindPrimaryKey();
    if AValue = '' then begin
      if oKey <> nil then
        ADFree(oKey);
    end
    else if oKey <> nil then begin
      oKey.ColumnNames := AValue;
      oKey.Enforce := True;
    end
    else
      Constraints.AddUK(Constraints.BuildUniqueName(C_AD_SysNamePrefix + 'PK'), AValue, True);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSTable.GetActualOriginName: String;
begin
  Result := SourceName;
  if Assigned(MetadataCallback) then
    MetadataCallback.GetTableOrigin(Result);
end;

{-------------------------------------------------------------------------------}
{$HINTS OFF}
procedure TADDatSTable.InternalLoadFromStorage(AStorage: TADStorage);
var
  iIndex: Integer;
  rState: TADDatSLoadState;
begin
  inherited InternalLoadFromStorage(AStorage);
  if AStorage.IsStored(siMeta) then begin
    iIndex := AStorage.ReadInteger('TabID', -1);
    ASSERT((Owner = nil) or (iIndex = Index));
    CaseSensitive := AStorage.ReadBoolean('CaseSensitive', True);
    EnforceConstraints := AStorage.ReadBoolean('EnforceConstraints', True);
    Locale := AStorage.ReadLongWord('Locale', LOCALE_USER_DEFAULT);
    MinimumCapacity := AStorage.ReadInteger('MinimumCapacity', 0);
    Nested := AStorage.ReadBoolean('Nested', False);
    Round2Scale := AStorage.ReadBoolean('Round2Scale', False);
    if AStorage.StreamVersion >= 7 then
      StrsTrim2Len := AStorage.ReadBoolean('StrsTrim2Len', False);
    CheckNotNull := AStorage.ReadBoolean('CheckNotNull', True);
    if AStorage.StreamVersion >= 6 then
      CheckReadOnly := AStorage.ReadBoolean('CheckReadOnly', True);
    Columns.LoadFromStorage(AStorage);
    Constraints.LoadFromStorage(AStorage);
    Views.LoadFromStorage(AStorage);
  end;
  if AStorage.IsStored(siData) then begin
    BeginLoadData(rState, lmHavyLoading);
    try
      Rows.LoadFromStorage(AStorage);
    finally
      EndLoadData(rState);
    end;
  end;
  if UpdatesRegistry and AStorage.TestObject(Updates.GetStreamingName(AStorage)) and
     AStorage.IsStored(siDelta) then
    Updates.LoadFromStorage(AStorage);
end;
{$HINTS ON}

{-------------------------------------------------------------------------------}
procedure TADDatSTable.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  if AStorage.IsStored(siMeta) then begin
    AStorage.WriteInteger('TabID', Index, -1);
    AStorage.WriteBoolean('CaseSensitive', CaseSensitive, True);
    AStorage.WriteBoolean('EnforceConstraints', EnforceConstraints, True);
    AStorage.WriteLongWord('Locale', Locale, LOCALE_USER_DEFAULT);
    AStorage.WriteInteger('MinimumCapacity', MinimumCapacity, 0);
    AStorage.WriteBoolean('Nested', Nested, False);
    AStorage.WriteBoolean('Round2Scale', Round2Scale, False);
    if AStorage.StreamVersion >= 7 then
      AStorage.WriteBoolean('StrsTrim2Len', StrsTrim2Len, False);
    AStorage.WriteBoolean('CheckNotNull', CheckNotNull, True);
    if AStorage.StreamVersion >= 6 then
      AStorage.WriteBoolean('CheckReadOnly', CheckReadOnly, True);
    Columns.SaveToStorage(AStorage);
    Constraints.SaveToStorage(AStorage);
    Views.SaveToStorage(AStorage);
  end;
  if AStorage.IsStored(siData) then
    Rows.SaveToStorage(AStorage);
  if UpdatesRegistry and AStorage.IsStored(siDelta) then
    Updates.SaveToStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.AddDataCallback(const ACallback: IADDatSTableDataCallback);
begin
  if FDataCallbacks = nil then
    FDataCallbacks := TInterfaceList.Create;
  if FDataCallbacks.IndexOf(ACallback) = -1 then
    FDataCallbacks.Add(ACallback);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.RemoveDataCallback(const ACallback: IADDatSTableDataCallback;
  ARemoveLastOne: Boolean);
begin
  if FDataCallbacks = nil then
    Exit;
  FDataCallbacks.Remove(ACallback);
  if ARemoveLastOne and (FDataCallbacks.Count = 1) then
    FDataCallbacks.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.NotifyDataChanged(ARow: TADDatSRow; AChangeKind: TADDatSRowState);
var
  i: Integer;
begin
  if (FDataCallbacks = nil) or
     (DataHandleMode in [lmHavyMove, lmHavyLoading, lmHavyFetching, lmFetching, lmRefreshing]) then
    Exit;
  for i := 0 to FDataCallbacks.Count - 1 do
    IADDatSTableDataCallback(FDataCallbacks[i]).TableDataChanged(ARow, AChangeKind);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTable.Setup(const AOptions: IADStanOptions);
begin
  ASSERT(AOptions <> nil);
  MinimumCapacity := AOptions.FetchOptions.ActualRowsetSize;

  Columns.InlineDataSize := AOptions.FormatOptions.InlineDataSize;
  Round2Scale := AOptions.FormatOptions.Round2Scale;
  StrsTrim2Len := AOptions.FormatOptions.StrsTrim2Len;
  Locale := AOptions.FormatOptions.SortLocale;

  CheckNotNull := AOptions.UpdateOptions.CheckRequired;
  CheckReadOnly := AOptions.UpdateOptions.CheckReadOnly;
end;

{-------------------------------------------------------------------------------}
{- TADDatSTableList                                                            -}
{-------------------------------------------------------------------------------}
constructor TADDatSTableList.CreateForManager(AManager: TADDatSManager);
begin
  ASSERT(AManager <> nil);
  inherited Create;
  FOwner := AManager;
  OwnObjects := True;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableList.Add(AObj: TADDatSTable): Integer;
begin
  Result := AddObject(AObj);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableList.Add(const AName: String): TADDatSTable;
begin
  Result := TADDatSTable.Create(AName);
  AddEx(Result);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableList.GetItemsI(AIndex: Integer): TADDatSTable;
begin
  ASSERT((AIndex >= 0) and (AIndex < FCount));
  Result := TADDatSTable(FArray[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADDatSTableList.TableByName(const AName: String): TADDatSTable;
begin
  Result := TADDatSTable(inherited ItemByName(AName));
end;

{-------------------------------------------------------------------------------}
{- TADDatSUpdatesJournal                                                       -}
{-------------------------------------------------------------------------------}
constructor TADDatSUpdatesJournal.Create(AOwner: TADDatSObject);
begin
  ASSERT(AOwner <> nil);
  inherited Create;
  FOwner := AOwner;
  Clear;
end;

{-------------------------------------------------------------------------------}
class function TADDatSUpdatesJournal.GetClassPrefix: String;
begin
  Result := 'TADDatS';
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.Lock;
begin
  Inc(FLocked);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.Unlock;
begin
  Dec(FLocked);
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.GetLocked: Boolean;
begin
  Result := FLocked > 0;
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.HasChanges(AOwner: TADDatSObject): Boolean;
begin
  Result := FirstChange(AOwner) <> nil;
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.FirstChange(AOwner: TADDatSObject): TADDatSRow;
var
  iMode: Integer;
  lFound: Boolean;
begin
  Result := FFirstChange;
  if AOwner = nil then
    iMode := 0
  else if AOwner is TADDatSTable then
    iMode := 1
  else
    iMode := 2;
  lFound := False;
  while (Result <> nil) and not lFound do begin
    case iMode of
    0: lFound := True;
    1: lFound := (Result.Table = AOwner);
    2: lFound := (Result.Manager = AOwner);
    end;
    if not lFound then
      Result := Result.FNextChange;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.NextChange(ACurRow: TADDatSRow;
  AOwner: TADDatSObject): TADDatSRow;
var
  iMode: Integer;
  lFound: Boolean;
begin
  if ACurRow = nil then begin
    Result := nil;
    Exit;
  end;
  Result := ACurRow.FNextChange;
  if AOwner = nil then
    iMode := 0
  else if AOwner is TADDatSTable then
    iMode := 1
  else
    iMode := 2;
  lFound := False;
  while (Result <> nil) and not lFound do begin
    case iMode of
    0: lFound := True;
    1: lFound := (Result.Table = AOwner);
    2: lFound := (Result.Manager = AOwner);
    end;
    if not lFound then
      Result := Result.FNextChange;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.LastChange(AOwner: TADDatSObject): TADDatSRow;
var
  iMode: Integer;
  lFound: Boolean;
begin
  Result := FLastChange;
  if AOwner = nil then
    iMode := 0
  else if AOwner is TADDatSTable then
    iMode := 1
  else
    iMode := 2;
  lFound := False;
  while (Result <> nil) and not lFound do begin
    case iMode of
    0: lFound := True;
    1: lFound := (Result.Table = AOwner);
    2: lFound := (Result.Manager = AOwner);
    end;
    if not lFound then
      Result := Result.FPriorChange;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.AppendRow(ARow: TADDatSRow);
begin
  if FFirstChange = nil then begin
    FLastChange := ARow;
    FFirstChange := ARow;
    ARow.FNextChange := nil;
    ARow.FPriorChange := nil;
  end
  else begin
    FLastChange.FNextChange := ARow;
    ARow.FPriorChange := FLastChange;
    ARow.FNextChange := nil;
    FLastChange := ARow;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.RegisterRow(ARow: TADDatSRow): Integer;
begin
  ASSERT(ARow <> nil);
  if ARow.FChangeNumber <> $FFFFFFFF then
    if (FLocked > 0) or (ARow.RowState = rsInserted) then begin
      Result := ARow.FChangeNumber;
      Exit;
    end
    else
      UnregisterRow(ARow);
  ARow.FChangeNumber := FChangeNumber;
  AppendRow(ARow);
  Result := FChangeNumber;
  ASSERT(FChangeNumber <> $FFFFFFFF);
  Inc(FChangeNumber);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.UnregisterRow(ARow: TADDatSRow);
begin
  ASSERT(ARow <> nil);
  if ARow.FNextChange <> nil then
    ARow.FNextChange.FPriorChange := ARow.FPriorChange;
  if ARow.FPriorChange <> nil then
    ARow.FPriorChange.FNextChange := ARow.FNextChange;
  if FFirstChange = ARow then
    FFirstChange := ARow.FNextChange;
  if FLastChange = ARow then
    FLastChange := ARow.FPriorChange;
  if FTmpNextRow = ARow then
    FTmpNextRow := ARow.FNextChange;
  ARow.FChangeNumber := $FFFFFFFF;
  ARow.FPriorChange := nil;
  ARow.FNextChange := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.SetSavePoint(const AValue: LongWord);
var
  oRow, oPriorRow: TADDatSRow;
begin
  oRow := FLastChange;
  while (oRow <> nil) and (oRow.FChangeNumber >= AValue) do begin
    oPriorRow := oRow.FPriorChange;
    oRow.RejectChanges;
    oRow := oPriorRow;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.AcceptChanges(AOwner: TADDatSObject);
var
  oRow: TADDatSRow;
  iMode: Integer;
begin
  ASSERT(FTmpNextRow = nil);
  if AOwner = nil then
    iMode := 0
  else if AOwner is TADDatSTable then
    iMode := 1
  else
    iMode := 2;
  oRow := FFirstChange;
  try
    while oRow <> nil do begin
      FTmpNextRow := oRow.FNextChange;
      case iMode of
      0:
        oRow.AcceptChanges;
      1:
        if oRow.Table = AOwner then
          oRow.AcceptChanges;
      2:
        if oRow.Manager = AOwner then
          oRow.AcceptChanges;
      end;
      oRow := FTmpNextRow;
    end;
  finally
    FTmpNextRow := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.RejectChanges(AOwner: TADDatSObject);
begin
  SetSavePoint(0);
end;

{-------------------------------------------------------------------------------}
function TADDatSUpdatesJournal.GetCount(AOwner: TADDatSObject = nil): Integer;
var
  oRow, oNextRow: TADDatSRow;
  iMode: Integer;
begin
  if AOwner = nil then
    iMode := 0
  else if AOwner is TADDatSTable then
    iMode := 1
  else
    iMode := 2;
  oRow := FFirstChange;
  Result := 0;
  while oRow <> nil do begin
    oNextRow := oRow.FNextChange;
    case iMode of
    0:
      Inc(Result);
    1:
      if oRow.Table = AOwner then
        Inc(Result);
    2:
      if oRow.Manager = AOwner then
        Inc(Result);
    end;
    oRow := oNextRow;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.Clear;
begin
  FChangeNumber := 0;
  FFirstChange := nil;
  FLastChange := nil;
  FTmpNextRow := nil;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_D12}
  {$WARNINGS OFF}
{$ENDIF}
procedure TADDatSUpdatesJournal.InternalLoadFromStorage(AStorage: TADStorage);
var
  sName: String;
  oRow: TADDatSRow;
  oTab: TADDatSTable;
  oView: TADDatSView;
  oList: TADObjList;
  iTID: Integer;
  iRID: LongWord;
  iChangeNumber: LongWord;
  i: Integer;
begin
  if not AStorage.IsStored(siDelta) then
    Exit;
  oList := TADObjList.Create;
  try
    FChangeNumber := AStorage.ReadLongWord('SavePoint', 0);
    sName := GetStreamingName(AStorage);
    while not AStorage.IsObjectEnd(sName) do begin
      AStorage.ReadObjectBegin('Change');
      if FOwner is TADDatSManager then begin
        iTID := AStorage.ReadInteger('TabID', -1);
        oTab := TADDatSManager(FOwner).Tables[iTID];
      end
      else
        oTab := TADDatSTable(FOwner);
      iRID := AStorage.ReadLongWord('RowID', $FFFFFFFF);
      iChangeNumber := AStorage.ReadLongWord('ChangeNumber', $FFFFFFFF);
      oView := oTab.Views.FindSortedView('#', [], []);
      if oView = nil then begin
        oView := oTab.Views.Add('');
        oView.Mechanisms.AddSort('#');
        oList.Add(oView);
      end;
      i := oView.Find([{$IFDEF AnyDAC_D5} Integer(iRID) {$ELSE} iRID {$ENDIF}], []);
      if i <> -1 then begin
        oRow := oView.Rows.ItemsI[i];
        oRow.FChangeNumber := iChangeNumber;
        AppendRow(oRow);
      end;
      AStorage.ReadObjectEnd('Change');
    end;
  finally
    for i := 0 to oList.Count - 1 do
      ADFree(TADDatSView(oList[i]));
    ADFree(oList);
  end;
end;
{$IFNDEF AnyDAC_D12}
  {$WARNINGS ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADDatSUpdatesJournal.InternalSaveToStorage(AStorage: TADStorage);
var
  oRow: TADDatSRow;
begin
  if not AStorage.IsStored(siDelta) then
    Exit;
  AStorage.WriteLongWord('SavePoint', SavePoint, 0);
  oRow := FirstChange(nil);
  while oRow <> nil do begin
    AStorage.WriteObjectBegin('Change');
    if FOwner is TADDatSManager then
      AStorage.WriteInteger('TabID', oRow.Table.Index, -1);
    AStorage.WriteLongWord('RowID', oRow.RowID, $FFFFFFFF);
    AStorage.WriteLongWord('ChangeNumber', oRow.ChangeNumber, $FFFFFFFF);
    AStorage.WriteObjectEnd('Change');
    oRow := NextChange(oRow, nil);
  end;
end;

{-------------------------------------------------------------------------------}
{- TADDatSManager                                                              -}
{-------------------------------------------------------------------------------}
constructor TADDatSManager.Create;
begin
  inherited Create;
  FUpdates := TADDatSUpdatesJournal.Create(Self);
  FTables := TADDatSTableList.CreateForManager(Self);
  FRelations := TADDatSRelationList.CreateForManager(Self);
  FEnforceConstraints := True;
  FUpdatesRegistry := False;
  FRefs := TADRefCounter.Create(Self);
  FCaseSensitive := True;
  FLocale := LOCALE_USER_DEFAULT;
  FCheckNotNull := True;
  FCheckReadOnly := True;
end;

{-------------------------------------------------------------------------------}
destructor TADDatSManager.Destroy;
begin
  ADFreeAndNil(FUpdates);
  ADFreeAndNil(FTables);
  ADFreeAndNil(FRelations);
  ADFreeAndNil(FRefs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Assign(AObj: TADDatSObject);
begin
  Reset;
  inherited Assign(AObj);
  if AObj is TADDatSManager then begin
    CaseSensitive := TADDatSManager(AObj).CaseSensitive;
    Locale := TADDatSManager(AObj).Locale;
    Round2Scale := TADDatSManager(AObj).Round2Scale;
    StrsTrim2Len := TADDatSManager(AObj).StrsTrim2Len;
    CheckNotNull := TADDatSManager(AObj).CheckNotNull;
    CheckReadOnly := TADDatSManager(AObj).CheckReadOnly;
    EnforceConstraints := TADDatSManager(AObj).EnforceConstraints;
    UpdatesRegistry := TADDatSManager(AObj).UpdatesRegistry;
    Tables.Assign(TADDatSManager(AObj).Tables);
    Relations.Assign(TADDatSManager(AObj).Relations);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.IsEqualTo(AObj: TADDatSObject): Boolean;
begin
  Result := inherited IsEqualTo(AObj);
  if Result then
    Result := (CaseSensitive = TADDatSManager(AObj).CaseSensitive) and
      (Locale = TADDatSManager(AObj).Locale) and
      (Round2Scale = TADDatSManager(AObj).Round2Scale) and
      (StrsTrim2Len = TADDatSManager(AObj).StrsTrim2Len) and
      (CheckNotNull = TADDatSManager(AObj).CheckNotNull) and
      (CheckReadOnly = TADDatSManager(AObj).CheckReadOnly) and
      (EnforceConstraints = TADDatSManager(AObj).EnforceConstraints) and
      (UpdatesRegistry = TADDatSManager(AObj).UpdatesRegistry) and
      Tables.IsEqualTo(TADDatSManager(AObj).Tables) and
      Relations.IsEqualTo(TADDatSManager(AObj).Relations);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.CountRef(AInit: Integer = 1);
begin
  FRefs.CountRef(AInit);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.AddRef;
begin
  FRefs.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.RemRef;
begin
  FRefs.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.GetIsRefCounted: Boolean;
begin
  Result := FRefs.Refs >= 0;
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.GetRefs: Integer;
begin
  Result := FRefs.Refs;
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.GetManager: TADDatSManager;
begin
  Result := Self;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.AcceptChanges;
var
  i: Integer;
begin
  if UpdatesRegistry then
    Updates.AcceptChanges(Self)
  else
    for i := 0 to Tables.Count - 1 do
      Tables.ItemsI[i].AcceptChanges;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Clear;
var
  i: Integer;
begin
  for i := 0 to Tables.Count - 1 do
    Tables.ItemsI[i].Clear;
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.Copy: TADDatSManager;
var
  i: Integer;
  j: Integer;
  oSrcTab: TADDatSTable;
  oDestTab: TADDatSTable;
  rState: TADDatSLoadState;
begin
  Result := TADDatSManager.Create;
  try
    Result.Assign(Self);
    for i := 0 to Tables.Count - 1 do begin
      oSrcTab := Tables.ItemsI[i];
      oDestTab := Result.Tables.ItemsI[i];
      oDestTab.BeginLoadData(rState);
      try
        for j := 0 to oSrcTab.Rows.Count - 1 do
          oDestTab.Import(oSrcTab.Rows.ItemsI[j]);
      finally
        oDestTab.EndLoadData(rState);
      end;
    end;
  except
    ADFree(Result);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.BeginLoadData(var AStates: TADDatSLoadStates; ADataHandleMode: TADDatSHandleMode);
var
  i: Integer;
begin
  SetLength(AStates, Tables.Count);
  for i := 0 to Tables.Count - 1 do
    Tables.ItemsI[i].BeginLoadData(AStates[i], ADataHandleMode);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.EndLoadData(const AStates: TADDatSLoadStates);
var
  i: Integer;
begin
  for i := 0 to Tables.Count - 1 do
    Tables.ItemsI[i].EndLoadData(AStates[i]);
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.GetHasErrors: Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to Tables.Count - 1 do
    if Tables.ItemsI[i].HasErrors then begin
      Result := True;
      Exit;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.HandleNotification(AParam: PADDatSNotifyParam);
begin
  if Relations <> nil then
    Relations.HandleNotification(AParam);
  if Tables <> nil then
    Tables.HandleNotification(AParam);
end;

{-------------------------------------------------------------------------------}
function TADDatSManager.HasChanges(ARowStates: TADDatSRowStates): Boolean;
var
  i: Integer;
begin
  if UpdatesRegistry then
    Result := Updates.HasChanges(Self)
  else begin
    Result := False;
    for i := 0 to Tables.Count - 1 do
      if Tables.ItemsI[i].HasChanges(ARowStates) then begin
        Result := True;
        Exit;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Merge(ARow: TADDatSRow; AOptions:
  TADDatSMergeOptions);
begin
  { TODO -cDATS : Implement DataManager.Merge (1) }
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Merge(AManager: TADDatSManager; AOptions:
  TADDatSMergeOptions);
begin
  { TODO -cDATS : Implement DataManager.Merge (2) }
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Merge(ATable: TADDatSTable; AOptions:
  TADDatSMergeOptions);
begin
  { TODO -cDATS : Implement DataManager.Merge (3) }
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.RejectChanges;
var
  i: Integer;
begin
  if UpdatesRegistry then
    Updates.RejectChanges(Self)
  else
    for i := 0 to Tables.Count - 1 do
      Tables.ItemsI[i].RejectChanges;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Reset;
begin
  Tables.Clear;
  Relations.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SetEnforceConstraints(const AValue: Boolean);
var
  i: Integer;
begin
  if FEnforceConstraints <> AValue then begin
    FEnforceConstraints := AValue;
    for i := 0 to Tables.Count - 1 do
      Tables.ItemsI[i].Constraints.EnforceUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SetUpdatesRegistry(const AValue: Boolean);
  procedure ErrorCantSetUpdReg;
  begin
    ADException(Self, [S_AD_LDatS], er_AD_CantSetUpdReg, [Name]);
  end;
var
  i: Integer;
begin
  if UpdatesRegistry <> AValue then begin
    for i := 0 to Tables.Count - 1 do
      if Tables.ItemsI[i].HasChanges([rsInserted, rsDeleted, rsModified]) then
        ErrorCantSetUpdReg;
    for i := 0 to Tables.Count - 1 do
      Tables.ItemsI[i].FUpdatesRegistry := not AValue;
    FUpdatesRegistry := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function DoCompRootTabs(Item1, Item2: Pointer): Integer;
var
  iID1, iID2: Integer;
begin
  if TADDatSTable(Item1).SourceID > 0 then
    iID1 := TADDatSTable(Item1).SourceID
  else
    iID1 := 1000 + TADDatSTable(Item1).Index;
  if TADDatSTable(Item2).SourceID > 0 then
    iID2 := TADDatSTable(Item2).SourceID
  else
    iID2 := 1000 + TADDatSTable(Item2).Index;
  Result := iID1 - iID2;
end;

{$IFDEF AUTOREFCOUNT}
type
  TADDatSTableComparer = class(TInterfacedObject, IComparer<TObject>)
    function Compare(const Left, Right: TObject): Integer;
  end;

function TADDatSTableComparer.Compare(const Left, Right: TObject): Integer;
begin
  Result := DoCompRootTabs(Left, Right);
end;
{$ENDIF}

function TADDatSManager.GetRootTables: TADDatSTableArray;
var
  i, j: Integer;
  lInRoot: Boolean;
  oList: TADObjList;
begin
  if Tables.Count = 1 then begin
    SetLength(Result, 1);
    Result[0] := Tables.ItemsI[0];
    Exit;
  end;
  oList := TADObjList.Create;
  try
    for i := 0 to Tables.Count - 1 do begin
      lInRoot := True;
      for j := 0 to Relations.Count - 1 do
        if Relations.ItemsI[j].ChildTable = Tables.ItemsI[i] then begin
          lInRoot := False;
          Break;
        end;
      if lInRoot then
        oList.Add(Tables.ItemsI[i]);
    end;
    if oList.Count > 1 then
      oList.Sort({$IFDEF AUTOREFCOUNT} TADDatSTableComparer.Create {$ELSE} DoCompRootTabs {$ENDIF});
    SetLength(Result, oList.Count);
    for i := 0 to oList.Count - 1 do
      Result[i] := TADDatSTable(oList[i]);
  finally
    ADFree(oList);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SetCaseSensitive(const AValue: Boolean);
var
  i: Integer;
begin
  if FCaseSensitive <> AValue then begin
    FCaseSensitive := AValue;
    for i := 0 to Tables.Count - 1 do
      Tables[i].CaseSensitive := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SetLocale(const AValue: TADLocalID);
var
  i: Integer;
begin
  if FLocale <> AValue then begin
    FLocale := AValue;
    for i := 0 to Tables.Count - 1 do
      Tables[i].Locale := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SetRound2Scale(const AValue: Boolean);
var
  i: Integer;
begin
  if FRound2Scale <> AValue then begin
    FRound2Scale := AValue;
    for i := 0 to Tables.Count - 1 do
      Tables[i].Round2Scale := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SetStrsTrim2Len(const AValue: Boolean);
var
  i: Integer;
begin
  if FStrsTrim2Len <> AValue then begin
    FStrsTrim2Len := AValue;
    for i := 0 to Tables.Count - 1 do
      Tables[i].StrsTrim2Len := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SetCheckNotNull(const AValue: Boolean);
var
  i: Integer;
begin
  if FCheckNotNull <> AValue then begin
    FCheckNotNull := AValue;
    for i := 0 to Tables.Count - 1 do
      Tables[i].CheckNotNull := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.SetCheckReadOnly(const AValue: Boolean);
var
  i: Integer;
begin
  if FCheckReadOnly <> AValue then begin
    FCheckReadOnly := AValue;
    for i := 0 to Tables.Count - 1 do
      Tables[i].CheckReadOnly := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.InternalLoadFromStorage(AStorage: TADStorage);
begin
  inherited InternalLoadFromStorage(AStorage);
  if AStorage.IsStored(siMeta) then begin
    CaseSensitive := AStorage.ReadBoolean('CaseSensitive', True);
    EnforceConstraints := AStorage.ReadBoolean('EnforceConstraints', True);
    Locale := AStorage.ReadLongWord('Locale', LOCALE_USER_DEFAULT);
    UpdatesRegistry := AStorage.ReadBoolean('UpdatesRegistry', False);
    Round2Scale := AStorage.ReadBoolean('Round2Scale', False);
    if AStorage.StreamVersion >= 7 then
      StrsTrim2Len := AStorage.ReadBoolean('StrsTrim2Len', False);
    CheckNotNull := AStorage.ReadBoolean('CheckNotNull', True);
    if AStorage.StreamVersion >= 6 then
      CheckReadOnly := AStorage.ReadBoolean('CheckReadOnly', True);
  end;
  Tables.LoadFromStorage(AStorage);
  if AStorage.IsStored(siMeta) then
    Relations.LoadFromStorage(AStorage);
  if UpdatesRegistry and AStorage.TestObject(Updates.GetStreamingName(AStorage)) and
     AStorage.IsStored(siDelta) then
    Updates.LoadFromStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.InternalSaveToStorage(AStorage: TADStorage);
begin
  inherited InternalSaveToStorage(AStorage);
  if AStorage.IsStored(siMeta) then begin
    AStorage.WriteBoolean('CaseSensitive', CaseSensitive, True);
    AStorage.WriteBoolean('EnforceConstraints', EnforceConstraints, True);
    AStorage.WriteLongWord('Locale', Locale, LOCALE_USER_DEFAULT);
    AStorage.WriteBoolean('UpdatesRegistry', UpdatesRegistry, False);
    AStorage.WriteBoolean('Round2Scale', Round2Scale, False);
    if AStorage.StreamVersion >= 7 then
      AStorage.WriteBoolean('StrsTrim2Len', StrsTrim2Len, False);
    AStorage.WriteBoolean('CheckNotNull', CheckNotNull, True);
    if AStorage.StreamVersion >= 6 then
      AStorage.WriteBoolean('CheckReadOnly', CheckReadOnly, True);
  end;
  Tables.SaveToStorage(AStorage);
  if AStorage.IsStored(siMeta) then
    Relations.SaveToStorage(AStorage);
  if UpdatesRegistry and AStorage.IsStored(siDelta) then
    Updates.SaveToStorage(AStorage);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSManager.Setup(const AOptions: IADStanOptions);
var
  i: Integer;
begin
  for i := 0 to Tables.Count - 1 do begin
    Tables[i].Columns.InlineDataSize := AOptions.FormatOptions.InlineDataSize;
    Tables[i].MinimumCapacity := AOptions.FetchOptions.ActualRowsetSize;
  end;
  Round2Scale := AOptions.FormatOptions.Round2Scale;
  StrsTrim2Len := AOptions.FormatOptions.StrsTrim2Len;
  Locale := AOptions.FormatOptions.SortLocale;
  CheckNotNull := AOptions.UpdateOptions.CheckRequired;
  CheckReadOnly := AOptions.UpdateOptions.CheckReadOnly;
end;

{-------------------------------------------------------------------------------}
var
  oMan: TADStorageManager;

initialization
  oMan := ADStorageManager();
  oMan.RegisterClass(TADDatSObject);
  oMan.RegisterClass(TADDatSNamedObject);
  oMan.RegisterClass(TADDatSList);
  oMan.RegisterClass(TADDatSNamedList);
  oMan.RegisterClass(TADDatSColumn);
  oMan.RegisterClass(TADDatSColumnList);
  oMan.RegisterClass(TADDatSConstraintBase);
  oMan.RegisterClass(TADDatSConstraintList);
  oMan.RegisterClass(TADDatSUniqueConstraint);
  oMan.RegisterClass(TADDatSForeignKeyConstraint);
  oMan.RegisterClass(TADDatSCheckConstraint);
  oMan.RegisterClass(TADDatSRelation);
  oMan.RegisterClass(TADDatSRelationList);
  oMan.RegisterClass(TADDatSMechBase);
  oMan.RegisterClass(TADDatSViewMechList);
  oMan.RegisterClass(TADDatSMechSort);
  oMan.RegisterClass(TADDatSMechRowState);
  oMan.RegisterClass(TADDatSMechRange);
  oMan.RegisterClass(TADDatSMechFilter);
  oMan.RegisterClass(TADDatSMechError);
  oMan.RegisterClass(TADDatSMechDetails);
  oMan.RegisterClass(TADDatSMechChilds);
  oMan.RegisterClass(TADDatSMechMaster);
  oMan.RegisterClass(TADDatSMechParent);
  oMan.RegisterClass(TADDatSRow);
  oMan.RegisterClassAlias('DatSRow', TADDatSRow);
  oMan.RegisterClass(TADDatSRowListBase);
  oMan.RegisterClass(TADDatSNestedRowList);
  oMan.RegisterClass(TADDatSTableRowList);
  oMan.RegisterClass(TADDatSViewRowList);
  oMan.RegisterClass(TADDatSView);
  oMan.RegisterClass(TADDatSViewList);
  oMan.RegisterClass(TADDatSAggregate);
  oMan.RegisterClass(TADDatSAggregateList);
  oMan.RegisterClass(TADDatSTable);
  oMan.RegisterClass(TADDatSTableList);
  oMan.RegisterClass(TADDatSManager);

end.
