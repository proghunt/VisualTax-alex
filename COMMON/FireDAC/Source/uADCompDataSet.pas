{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{     FireDAC TADDataSet (base TDataSet descendant)     }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADCompDataSet;

interface

uses
  SysUtils, Classes, DB,
{$IFDEF AnyDAC_D17}
  System.Generics.Collections,
{$ENDIF}
  uADStanUtil, uADStanIntf, uADStanSQLTimeInt, uADStanOption, uADStanError,
    uADStanParam, uADStanStorage,
  uADDatSManager,
  uADDAptIntf,
  uADPhysIntf;

const
  C_NIL = PADBuffer(nil);

type
{$IFDEF AnyDAC_FPC}
  TGroupPosInd = (gbFirst, gbMiddle, gbLast);
  TGroupPosInds = set of TGroupPosInd;

  TObjectField = class(TField)
  private
    FFields: TFields;
    FObjectType: String;
  public
    property Fields: TFields read FFields;
    property ObjectType: String read FObjectType write FObjectType;
  end;

  TDataSetField = class(TObjectField)
  private
    FNestedDataSet: TDataSet;
  public
    property NestedDataSet: TDataSet read FNestedDataSet;
  end;
{$ENDIF}

  TADColMapItem = class;
  TADDataSet = class;
  TADMasterDataLink = class;
  TADIndex = class;
  TADIndexes = class;
{$IFDEF AnyDAC_FPC}
  TCheckConstraint = class;
  TCheckConstraints = class;
{$ENDIF}
  TADAggregate = class;
  TADAggregates = class;
  TADWideMemoField = class;
  TADXMLField = class;
  TADAutoIncField = class;
  TADSQLTimeIntervalField = class;
  TADBlobStream = class;
  IADDataSetReference = interface;

  TADColMapItem = class(TObject)
  public
    FColumn: TADDatSColumn;
    FColumnIndex: Integer;
    FPath: array of Integer;
  end;

  TADKeyIndex = (kiLookup, kiRangeStart, kiRangeEnd, kiCurRangeStart,
    kiCurRangeEnd, kiSave);

  PADRecInfo = ^TADRecInfo;
  TADRecInfo = record
    FRow: TADDatSRow;
    FRowIndex: LongInt;
    FBookmarkFlag: TBookmarkFlag;
  end;

  PADBookmarkData = ^TADBookmarkData;
  TADBookmarkData = record
    FRow: TADDatSRow;
    FRowIndex: Integer;
    FResultSetNum: Integer;
  end;

  PADKeyBuffer = ^TADKeyBuffer;
  TADKeyBuffer = packed record
    FModified: Boolean;
    FExclusive: Boolean;
    FFieldCount: Integer;
    FAssignedFieldCount: Integer;
    FRecBuff: PADBuffer;
  end;

  IADDataSetReference = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2400}']
    function GetDataView: TADDatSView;
    property DataView: TADDatSView read GetDataView;
  end;

  IADDataSetListener = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2401}']
    procedure ResultsetDefined(ADataSet: TADDataSet);
    procedure ResultsetReleasing(ADataSet: TADDataSet);
    procedure ResultsetActivated(ADataSet: TADDataSet);
  end;

  TADUpdateRecordEvent = procedure (ASender: TDataSet; ARequest: TADUpdateRequest;
    var AAction: TADErrorAction; AOptions: TADUpdateRowOptions) of object;
  TADUpdateErrorEvent = procedure (ASender: TDataSet; AException: EADException;
    ARow: TADDatSRow; ARequest: TADUpdateRequest; var AAction: TADErrorAction) of object;
  TADAfterApplyUpdatesEvent = procedure (DataSet: TADDataSet; AErrors: Integer) of object;
  TADReconcileErrorEvent = procedure(DataSet: TADDataSet; E: EADException;
    UpdateKind: TADDatSRowState; var Action: TADDAptReconcileAction) of object;
  TADDataSetEvent = procedure(DataSet: TADDataSet) of object;
  TADDataSetFlags = set of (dfOpenBlob, dfOfflining, dfKeyBuffersAllocated,
    dfRangeFromExclusive, dfRangeToExclusive, dfLockNoBMK, dfClearIndexDefs,
    dfColumnAttributesUpdated, dfCalcFieldInIndex, dfStreamedActive,
    dfPreserveCurrentIndex, dfPostRow, dfDataSetOpened, dfUnidirectional,
    dfNoRecNoCmp, dfDataSetOpening, dfDeleting);
  TADFetchDirection = (fdUp, fdDown);
  TADDataSetLocateOption = (lxoCaseInsensitive, lxoPartialKey, lxoFromCurrent,
    lxoBackward, lxoCheckOnly, lxoNoFetchAll);
  TADDataSetLocateOptions = set of TADDataSetLocateOption;
  TADCopyDataSetOptions = set of (coStructure, coCalcFields,
    coIndexesReset, coIndexesCopy,
    coConstraintsReset, coConstraintsCopy,
    coAggregatesReset, coAggregatesCopy,
    coRestart, coAppend, coEdit, coRefresh);
  TADStoredActivationUsage = set of (auDesignTime, auRunTime);
  TADUpdateRecordTypes = set of (rtModified, rtInserted, rtDeleted,
    rtUnmodified, rtHasErrors);

{$IFDEF AnyDAC_D17}
  TADFieldList = TList<TField>;
  TADDataSetList = TList<TDataSet>;
{$ELSE}
  TADFieldList = TList;
  TADDataSetList = TList;
{$ENDIF}

  TADMasterDataLink = class(TMasterDataLink)
  private
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FDetailDataSet: TADDataSet;
    FOnMasterChange: TNotifyEvent;
    FOnMasterFieldsDefined: TNotifyEvent;
{$IFDEF AnyDAC_D7}
    FFireActiveChanged: Boolean;
{$ENDIF}
    FActiveChangedLocked: Boolean;
    FDelayedEvent: TDataEvent;
    FDelayedScrollDisabled: Integer;
    FTimer: TADTimer;
    FScrollDisabled: Integer;
    procedure StartDelayedScroll;
    procedure DoDelayedScroll;
    function GetDelayedScrollEnabled: Boolean;
    function GetActualDelayedScrollEnabled: Boolean;
    procedure DoMasterChanged(ASender: TObject);
  protected
    procedure ActiveChanged; override;
    procedure DataEvent(Event: TDataEvent;
      Info: {$IFDEF AnyDAC_XPLAT} TADNativeInt {$ELSE} Longint {$ENDIF}); override;
    procedure RecordChanged(Field: TField); override;
  public
    constructor Create(ADataSet: TDataSet); {$IFDEF AnyDAC_FPC} override; {$ENDIF}
    destructor Destroy; override;
    procedure Synchronize(AWithDetails: Boolean = True);
    procedure CancelSync(AWithDetails: Boolean = True);
    procedure DisableDelayedScroll;
    procedure EnableDelayedScroll;
    procedure DisableScroll;
    procedure EnableScroll;
    property DelayedScrollEnabled: Boolean read GetDelayedScrollEnabled;
    property ActualDelayedScrollEnabled: Boolean read GetActualDelayedScrollEnabled;
    property OnMasterChange: TNotifyEvent read FOnMasterChange
      write FOnMasterChange;
    property OnMasterFieldsDefined: TNotifyEvent read FOnMasterFieldsDefined
      write FOnMasterFieldsDefined;
  end;

  TADIndex = class (TCollectionItem)
  private
    FUpdateCount: Integer;
    FActive: Boolean;
    FFilter: String;
    FFields: String;
    FCaseInsFields: String;
    FExpression: String;
    FDescFields: String;
    FFilterOptions: TADExpressionOptions;
    FOptions: TADSortOptions;
    FView: TADDatSView;
    FName: String;
    FDistinct: Boolean;
    procedure SetCaseInsFields(const AValue: String);
    procedure SetDescFields(const AValue: String);
    procedure SetExpression(const AValue: String);
    procedure SetFields(const AValue: String);
    procedure SetFilter(const AValue: String);
    procedure SetFilterOptions(const AValue: TADExpressionOptions);
    procedure SetOptions(const AValue: TADSortOptions);
    procedure SetName(const AValue: String);
    procedure IndexChanged;
    procedure SetActive(const AValue: Boolean);
    function GetActualActive: Boolean;
    procedure CreateView;
    procedure DeleteView;
    function GetDataSet: TADDataSet;
    function GetSelected: Boolean;
    procedure SetSelected(const AValue: Boolean);
    procedure SetDistinct(const AValue: Boolean);
  protected
    function GetDisplayName: String; override;
    procedure AssignTo(ADest: TPersistent); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property ActualActive: Boolean read GetActualActive;
    property DataSet: TADDataSet read GetDataSet;
  published
    property Active: Boolean read FActive write SetActive default False;
    property Selected: Boolean read GetSelected write SetSelected default False;
    property Name: String read FName write SetName;
    property Fields: String read FFields write SetFields;
    property CaseInsFields: String read FCaseInsFields write SetCaseInsFields;
    property DescFields: String read FDescFields write SetDescFields;
    property Expression: String read FExpression write SetExpression;
    property Options: TADSortOptions read FOptions write SetOptions default [];
    property Distinct: Boolean read FDistinct write SetDistinct default False;
    property Filter: String read FFilter write SetFilter;
    property FilterOptions: TADExpressionOptions read FFilterOptions write SetFilterOptions default [];
  end;

  TADIndexes = class(TCollection)
  private
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FDataSet: TADDataSet;
    function GetItems(AIndex: Integer): TADIndex;
    procedure SetItems(AIndex: Integer; const AValue: TADIndex);
  protected
    function GetOwner: TPersistent; override;
    procedure Build;
    procedure Release;
  public
    constructor Create(ADataSet: TADDataSet);
    function Add: TADIndex;
    function FindIndex(const AName: String): TADIndex;
    function IndexByName(const AName: String): TADIndex;
    function FindIndexForFields(const AFields: String;
      ARequiredOptions: TADSortOptions = [];
      AProhibitedOptions: TADSortOptions = []): TADIndex;
    property Items[AIndex: Integer]: TADIndex read GetItems write SetItems; default;
  end;

{$IFDEF AnyDAC_FPC}
  TCheckConstraint = class(TCollectionItem)
  private
    FImportedConstraint: string;
    FCustomConstraint: string;
    FErrorMessage: string;
    FFromDictionary: Boolean;
    procedure SetImportedConstraint(const Value: string);
    procedure SetCustomConstraint(const Value: string);
    procedure SetErrorMessage(const Value: string);
  public
    procedure Assign(Source: TPersistent); override;
    function GetDisplayName: string; override;
  published
    property CustomConstraint: string read FCustomConstraint write SetCustomConstraint;
    property ErrorMessage: string read FErrorMessage write SetErrorMessage;
    property FromDictionary: Boolean read FFromDictionary write FFromDictionary;
    property ImportedConstraint: string read FImportedConstraint write SetImportedConstraint;
  end;

  TCheckConstraints = class(TCollection)
  private
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FOwner: TPersistent;
    function GetItem(Index: Integer): TCheckConstraint;
    procedure SetItem(Index: Integer; Value: TCheckConstraint);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(Owner: TPersistent); virtual;
    function Add: TCheckConstraint;
    property Items[Index: Integer]: TCheckConstraint read GetItem write SetItem; default;
  end;
{$ENDIF}

  TADAggregate = class(TCollectionItem)
  private
    FUpdateCount: Integer;
    FExpression: String;
    FGroupingLevel: Integer;
    FIndexName: String;
    FActive: Boolean;
    FAggregate: TADDatSAggregate;
    FName: String;
    function GetActualActive: Boolean;
    function GetDataSet: TADDataSet;
    procedure SetActive(const AValue: Boolean);
    procedure SetExpression(const AValue: String);
    procedure SetGroupingLevel(const AValue: Integer);
    procedure SetIndexName(const AValue: String);
    procedure AggregateChanged;
    procedure CreateAggregate;
    procedure DeleteAggregate;
    function GetValue: Variant;
    function InternalUse(var ARecordIndex: Integer): Boolean;
    function GetInUse: Boolean;
    function GetDataType: TADDataType;
  protected
    function GetDisplayName: String; override;
  public
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property ActualActive: Boolean read GetActualActive;
    property DataSet: TADDataSet read GetDataSet;
    property Value: Variant read GetValue;
    property InUse: Boolean read GetInUse;
    property DataType: TADDataType read GetDataType;
  published
    property Name: String read FName write FName;
    property Expression: String read FExpression write SetExpression;
    property GroupingLevel: Integer read FGroupingLevel write SetGroupingLevel default 0;
    property IndexName: String read FIndexName write SetIndexName;
    property Active: Boolean read FActive write SetActive default False;
  end;

  TADAggregates = class(TCollection)
  private
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FDataSet: TADDataSet;
    FGroupingLevel: Integer;
    function GetItems(AIndex: Integer): TADAggregate;
    procedure SetItems(AIndex: Integer; const AValue: TADAggregate);
  protected
    function GetOwner: TPersistent; override;
    property GroupingLevel: Integer read FGroupingLevel;
    procedure Build;
    procedure Release;
  public
    constructor Create(ADataSet: TADDataSet);
    function Add: TADAggregate;
    function FindAggregate(const AName: String): TADAggregate;
    function AggregateByName(const AName: String): TADAggregate;
    property Items[AIndex: Integer]: TADAggregate read GetItems write SetItems; default;
  end;

{$IFNDEF AnyDAC_FPC}
  TADDataSet = class (TDataSet, {$IFNDEF AnyDAC_D6} IUnknown, {$ENDIF}
    IADDataSetReference, IADStanOptions, IADPhysLocalQueryAdapter,
    IADDatSTableDataCallback)
{$ELSE}
  TADDataSet = class (TDBDataSet, IUnknown, IADDataSetReference,
    IADStanOptions, IADPhysLocalQueryAdapter, IADDatSTableDataCallback)
{$ENDIF}
  private
    FTable: TADDatSTable;
    FView: TADDatSView;
    FBufferSize: Word;
    FRecordIndexToInsert: Integer;
    FPrevRecordIndex: Integer;
    FColumns: array of TADColMapItem;
    FNewRow: TADDatSRow;
    FForceRecBuffer: PADBuffer;
    FIndexDefs: TIndexDefs;
    FIndexes: TADIndexes;
    FSortView: TADDatSView;
    FFilterView: TADDatSView;
    FSourceView: TADDatSView;
    FSourceViewLocator: TADDatSMechFilter;
    FKeyBuffers: array[TADKeyIndex] of PADKeyBuffer;
    FIndexName: String;
    FIndexFieldNames: String;
    FFilterChanges: TADUpdateRecordTypes;
    FParentDataSet: TADDataSet;
    FConstDisableCount: Integer;
    FCloneSource: TADDataSet;
    FCachedUpdates: Boolean;
    FOnReconcileError: TADReconcileErrorEvent;
    FOnUpdateRecord: TADUpdateRecordEvent;
    FOnUpdateError: TADUpdateErrorEvent;
    FUnidirRecsPurged: Integer;
    FMasterLink: TADMasterDataLink;
    FDetailFields: String;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FLastParentRow: TADDatSRow;
    FAfterRowRequest: TADDataSetEvent;
    FAfterExecute: TADDataSetEvent;
    FAfterApplyUpdates: TADAfterApplyUpdatesEvent;
    FAfterGetRecords: TADDataSetEvent;
    FAfterGetRecord: TADDataSetEvent;
    FBeforeRowRequest: TADDataSetEvent;
    FBeforeExecute: TADDataSetEvent;
    FBeforeApplyUpdates: TADDataSetEvent;
    FBeforeGetRecords: TADDataSetEvent;
    FAggregatesActive: Boolean;
    FIndexesActive: Boolean;
    FAggregates: TADAggregates;
    FFieldAggregates: TADAggregates;
    FDataLoadSave: Pointer;
    FCreatedConstraints: TADObjList;
    FLocateRow: TADDatSRow;
    FLocateColumns: TADDatSColumnSublist;
    FTempIndexViews: TADObjList;
{$IFDEF AnyDAC_FPC}
    FConstraints: TCheckConstraints;
    FDataSetField: TDataSetField;
    FSparseArrays: Boolean;
    FNestedDataSets: TList;
{$ENDIF}
    FLastSavePoint: LongWord;
    FActiveStoredUsage: TADStoredActivationUsage;
    FLastColumn: TADDatSColumn;
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FLastField: TField;
    FEventListeners: TInterfaceList;
    FOnMasterSetValues: TADDataSetEvent;
    FWaitCounter: Integer;
    FMasterRelation: TADDatSRelation;
    function AddFieldDesc(AFmtOpts: TADFormatOptions; ADefs: TFieldDefs;
      AColumn: TADDatSColumn; var AFieldId: Integer; APath: TADPtrList): TFieldDef;
    procedure AddTableDesc(AFmtOpts: TADFormatOptions; ADefs: TFieldDefs;
      ATable: TADDatSTable; var AFieldId: Integer; APath: TADPtrList);
    procedure SetIndexName(const AValue: String);
    function GetIndexFieldNames: String;
    procedure SetIndexFieldNames(const AValue: String);
    procedure RelinkViews;
    procedure ResyncViews;
    function GetIndexField(AIndex: Integer): TField;
    function GetIndexFieldCount: Integer;
    procedure AllocKeyBuffers;
    procedure CheckSetKeyMode;
    procedure CheckIndexed;
    procedure FreeKeyBuffers;
    function GetKeyExclusive: Boolean;
    function GetKeyFieldCount: Integer;
    function InitKeyBuffer(ABuffer: PADKeyBuffer): PADKeyBuffer;
    function ClearKeyBuffer(ABuffer: PADKeyBuffer): PADKeyBuffer;
    procedure SetKeyRow(ABuffer: PADKeyBuffer; ARow: TADDatSRow);
    procedure PostKeyBuffer(ACommit: Boolean);
    function ResetCursorRange: Boolean;
    procedure SetKeyExclusive(AValue: Boolean);
    procedure SetKeyFieldCount(AValue: Integer);
    procedure SetKeyFields(AKeyIndex: TADKeyIndex;
      const AValues: array of const; AExclusive: Boolean = False);
    procedure AssignKeyBuffer(ADest, ASrc: PADKeyBuffer);
    function CompareKeyBuffer(ABuff1, ABuff2: PADKeyBuffer): Boolean;
    procedure ResetViews;
    procedure SetSortView(AView: TADDatSView);
    procedure SwitchToIndex(const AFieldNames, AIndexName: String);
    procedure SetFilterChanges(const AValue: TADUpdateRecordTypes);
    procedure SafeFilteringUpdated;
    procedure ClearFColumns;
    function GetFieldColumn(ARecBuff: PADBuffer; AFieldNo: Integer;
      var AColumn: TADDatSColumn; var AColumnIndex: Integer;
      var ARow: TADDatSRow; AInitNested: Boolean = False): Boolean; overload;
    procedure SetFetchOptions(const AValue: TADFetchOptions);
    procedure SetFormatOptions(const AValue: TADFormatOptions);
    procedure SetUpdateOptions(const AValue: TADBottomUpdateOptions);
    procedure SetResourceOptions(const AValue: TADBottomResourceOptions);
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetUpdateOptions: TADBottomUpdateOptions;
    function GetResourceOptions: TADBottomResourceOptions;
    function GetData: IADDataSetReference;
    function GetDelta: IADDataSetReference;
    procedure SetData(const AValue: IADDataSetReference);
    procedure SetTableConstraints;
    procedure ResetTableConstraints;
    procedure SetInternalCalcs;
    procedure SetUpdateFieldAttributes;
    function GetConstraintsEnabled: Boolean;
    procedure SetConstraintsEnabled(const AValue: Boolean);
{$IFDEF AnyDAC_FPC}
    procedure SetConstraints(const AValue: TCheckConstraints);
{$ENDIF}
    function IsCS: Boolean;
    function GetCachedUpdates: Boolean;
    procedure SetCachedUpdates(const AValue: Boolean);
    function GetSavePoint: Integer;
    procedure SetSavePoint(const AValue: Integer);
    function GetUpdatesPending: Boolean;
    function GetChangeCount: Integer;
    function InternalFetchRows(AAll, AOnDemand: Boolean;
	    ADirection: TADFetchDirection = fdDown): Boolean;
    function InternalFetchNested(ANestedTable: TADDatSTable;
      ARowOptions: TADPhysFillRowOptions): Boolean;
    function RefreshRecordBase(ARowOptions: TADPhysFillRowOptions): Boolean;
    function GetMasterFields: String;
    procedure SetMasterFields(const AValue: String);
    procedure SetMasterSource(const AValue: TDataSource);
    function GetActualDetailFields: String;
    procedure CheckParentRow;
    procedure ResetIndexes;
    procedure OpenIndexes;
    procedure SetAggregatesActive(const AValue: Boolean);
    procedure SetIndexesActive(const AValue: Boolean);
    function GetGroupingLevel: Integer;
    procedure SetAggregates(const AValue: TADAggregates);
    procedure SetIndexes(const AValue: TADIndexes);
    function GetActiveRecBufRecordIndex(var AIndex: Integer): Boolean;
    procedure SetViewAggregates;
    procedure ResetViewAggregates;
    function IsA: Boolean;
    function IsIS: Boolean;
    function GetFilteredData: IADDataSetReference;
    function RenewColumnMap: Boolean;
    function RenewFieldDesc(AColumn: TADDatSColumn; var AFieldId: Integer): Boolean;
    function RenewTableDesc(ATable: TADDatSTable; var AFieldId: Integer): Boolean;
    function CreateChildMech: TADDatSMechChilds;
    function CreateFilterMech(AFilter: TADDatSMechFilter): TADDatSMechFilter;
    function CreateRangeMech: TADDatSMechRange;
    function CreateStateMech: TADDatSMechRowState;
    function IsIDS: Boolean;
    procedure SetIndexDefs(const AValue: TIndexDefs);
    procedure UpdateRecordIndex;
    procedure ClearRecordIndex;
    procedure SetParams(const AValue: TADParams);
    function GetParamsCount: Word;
    procedure LoadFromStorage(AStream: TStream; const AFileName: String;
      AFormat: TADStorageFormat);
    procedure SaveToStorage(const AFileName: String; AStream: TStream;
      AFormat: TADStorageFormat);
    procedure InternalLoadFromStorage;
    procedure InternalSaveToStorage;
    function InternalFieldByName(const AFieldName, APlace: String): TField;
    procedure SetBookmarkSize(AValue: Integer);
    function GetRowFromBookmark(ABookmark: TBookmark; out ARowIndex: Integer;
      out AResultSetNum: Integer): TADDatSRow;
    procedure ReadContent(AReader: TStream);
    procedure WriteContent(AWriter: TStream);
    procedure CopyRecordBase(ASource: TDataset; AExcludeNewEmptyValues: Boolean);
    function IsRowValid(ARow: TADDatSRow; AResultSetNum: Integer): Boolean;
    function GetRowError: EADException;
    function GetFeatures: TADPhysLocalQueryAdapterFeatures;
    procedure InternalClearNested(ADataTypes: TADDataTypes; AAttributes: TADDataAttributes);
    procedure BuildMasterRelation;
    procedure ResetMasterRelation;
    procedure DoAfterGetRecords2;
    function GetRecInfo(ABuffer: PADBuffer): PADRecInfo; overload;
  protected
    FRecordIndex: Integer;
    FClientCursor: Boolean;
    FKeyBuffer: PADKeyBuffer;
    FRangeFrom, FRangeTo: TADDatSRow;
    FRangeFromFieldCount, FRangeToFieldCount: Integer;
    FSetToRecBmk: PADBookmark;
    FLocalIndexName: String;
    // IProviderSupport
{$IFDEF AnyDAC_D6}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}
    procedure PSExecute; override;
    function PSGetDefaultOrder: TIndexDef; override;
    function PSGetKeyFields: string; override;
    function PSGetTableName: string; override;
    function PSGetIndexDefs(IndexTypes: TIndexOptions = [ixPrimary..ixNonMaintained]): TIndexDefs; override;
    function PSGetUpdateException(E: Exception; Prev: EUpdateError): EUpdateError; override;
    procedure PSReset; override;
    function PSUpdateRecord(AUpdateKind: TUpdateKind; ADelta: TDataSet): Boolean; override;
{$IFDEF AnyDAC_D6}
  {$WARN SYMBOL_DEPRECATED ON}
{$ENDIF}
    function InternalDefaultKeyFieldCount(ABuffer: PADKeyBuffer; ADefault: Integer): Integer; virtual;
    function InternalGotoKey(ANearest: Boolean): Boolean; virtual;
    function GetKeyRow(ABuffer: PADKeyBuffer): TADDatSRow;
    // IADDataSetReference
    function GetDataView: TADDatSView;
    // IADStanOptions
    function GetOptionsIntf: IADStanOptions; virtual; abstract;
    procedure SetOptionsIntf(const AValue: IADStanOptions); virtual; abstract;
    // IADPhysLocalQueryAdapter
    function GetDataSet: TObject;
    function IsPKViolation(AExc: Exception): Boolean;
    // IADDatSTableDataCallback
    procedure TableDataChanged(ARow: TADDatSRow; AChangeKind: TADDatSRowState);
  protected
    FAutoCommitUpdates: Boolean;
    FRecordCount: Integer;
    FSourceEOF: Boolean;
    FFlags: TADDataSetFlags;
    FStorage: TADStorage;
    FEncoder: TADEncoder;
    function AllocRecBuf: PADBuffer; {$IFDEF NEXTGEN} override; {$ENDIF}
    procedure FreeRecBuf(var Buffer: PADBuffer); {$IFDEF NEXTGEN} override; {$ENDIF}
    function AllocRecordBuffer: PADRawBuffer; {$IFNDEF NEXTGEN} override; {$ENDIF}
    procedure FreeRecordBuffer(var Buffer: PADRawBuffer); {$IFNDEF NEXTGEN} override; {$ENDIF}
    procedure CheckDeleting;
    procedure CheckEditing;
    procedure CheckInserting;
    procedure CreateFilterView; virtual;
    procedure ClearCalcFields(Buffer: PADBuffer); override;
    procedure CloseBlob(Field: TField); override;
    procedure DataConvert(AField: TField; ASource: PADValue;
      {$IFDEF AnyDAC_D18} var {$ENDIF} ADest: PADValue; AToNative: Boolean); override;
    procedure DataEvent(Event: TDataEvent;
      Info: {$IFDEF AnyDAC_XPLAT} TADNativeInt {$ELSE} Longint {$ENDIF}); override;
    procedure Loaded; override;
    procedure DefineProperties(AFiler: TFiler); override;
    procedure DoAfterRefresh; override;
    procedure DoBeforeInsert; override;
    procedure DoBeforeEdit; override;
    procedure DoBeforeDelete; override;
    procedure DoBeforeScroll; override;
    function GetActiveRecBuf(var RecBuf: PADBuffer): Boolean;
    procedure GetBookmarkData(Buffer: PADBuffer; Data: PADBookmark); override;
    function GetBookmarkFlag(Buffer: PADBuffer): TBookmarkFlag; override;
    function GetCanModify: Boolean; override;
    function GetDataSource: TDataSource; override;
    function GetRowIndex(ABuffer: PADBuffer = C_NIL): Integer;
    function GetRecNo: Integer; override;
    function GetRecord(Buffer: PADBuffer; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    function GetRecordCount: Integer; override;
    function GetRecordSize: Word; override;
    function GetKeyBuffer(AKeyIndex: TADKeyIndex; ACheckCreateRow: Boolean = True): PADKeyBuffer;
    function SetCursorRange: Boolean;
    procedure SetKeyBuffer(AKeyIndex: TADKeyIndex; AClear: Boolean);
    procedure InitRecord(Buffer: PADBuffer); override;
    procedure InitBufferPointers; virtual;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalOpen; override;
    procedure DoAfterOpen; override;
    procedure InternalClose; override;
    procedure InternalAddRecord(Buffer: {$IFDEF AnyDAC_D17} PADBuffer {$ELSE} Pointer {$ENDIF};
      Append: Boolean); override;
    procedure InternalCancel; override;
    procedure InternalDelete; override;
    procedure InternalEdit; override;
    procedure InternalFirst; override;
    procedure InternalGotoBookmark(Bookmark: Pointer); overload; {$IFNDEF NEXTGEN} override; {$ENDIF}
{$IFDEF AnyDAC_D17}
    procedure InternalGotoBookmark(Bookmark: PADBookmark); overload; override;
{$ENDIF}
    procedure InternalInitRecord(Buffer: PADBuffer); override;
    procedure DoOnNewRecord; override;
    procedure InternalInsert; override;
    procedure InternalLast; override;
    procedure InternalPost; override;
    procedure InternalRefresh; override;
    procedure InternalSetToRecord(Buffer: PADBuffer); override;
    function IsCursorOpen: Boolean; override;
    procedure OpenCursor(InfoQuery: Boolean); override;
    function RowState2UpdateStatus(ARowState: TADDatSRowState): TUpdateStatus;
    procedure SetActive(AValue: Boolean); override;
    procedure DoBeforeClose; override;
    procedure SetBookmarkData(Buffer: PADBuffer; Data: PADBookmark); override;
    procedure SetBookmarkFlag(Buffer: PADBuffer; AValue: TBookmarkFlag); override;
    procedure SetFieldData(AField: TField; ABuffer: PADValue); overload; override;
    procedure InternalSetRecNo(AValue: Integer); virtual;
    procedure SetRecNo(AValue: Integer); override;
    procedure SetFilterOptions(AValue: TFilterOptions); override;
    procedure SetFilterText(const AValue: string); override;
    procedure SetFiltered(AValue: Boolean); override;
    procedure SetOnFilterRecord(const AValue: TFilterRecordEvent); override;
    procedure InitLocateRow(const AKeyFields: String; const AKeyValues: Variant);
    function FindRecord(Restart, GoForward: Boolean): Boolean; override;
    function LocateRecord(const AKeyFields: string; const AKeyValues: Variant;
      AOptions: TADDataSetLocateOptions; var AIndex: Integer): Boolean; overload;
    function LocateRecord(const AExpression: string;
      AOptions: TADDataSetLocateOptions; var AIndex: Integer): Boolean; overload;
    procedure UpdateIndexDefs; override;
    function GetIsIndexField(AField: TField): Boolean; override;
{$IFNDEF AnyDAC_FPC}
    procedure ResetAggField(AField: TField); override;
    function GetAggregateValue(AField: TField): Variant; override;
{$ENDIF}
    function GetFieldClass(FieldType: TFieldType): TFieldClass; override;
    // introduced
    function CalcBookmarkSize: LongWord; virtual;
    procedure CheckBidirectional;
    procedure CheckTable;
    procedure CheckFetchedAll;
    procedure CheckAsyncOpenComplete;
    procedure CheckAsyncOpenFailed;
    procedure CheckAsyncExecFinished;
    procedure ReleaseBase(AOffline: Boolean); virtual;
    procedure CheckOnline(APrepare: Boolean = True); virtual;
    function MasterRangeChanged: Boolean;
    procedure CheckMasterRange; virtual;
    procedure CheckDetailRecords(AEnforce: Boolean);
    procedure MasterDisabled(Sender: TObject); virtual;
    procedure MasterChanged(Sender: TObject); virtual;
    procedure MasterDefined(Sender: TObject); virtual;
    procedure BeginForceRow(ARow: TADDatSRow; AReadWrite, AWithCalcFields: Boolean);
    procedure CheckCachedUpdatesMode; virtual;
    function DoApplyUpdates(ATable: TADDatSTable; AMaxErrors: Integer): Integer; virtual;
    procedure DoCachedUpdatesChanged; virtual;
    function DoFetch(ATable: TADDatSTable; AAll: Boolean;
      ADirection: TADFetchDirection = fdDown): Integer; overload; virtual;
    function DoFetch(ARow: TADDatSRow; AColumn: Integer;
      ARowOptions: TADPhysFillRowOptions): Boolean; overload; virtual;
    function DoPurge(AView: TADDatSView; ADirection: TADFetchDirection = fdDown): Integer; virtual;
    procedure DoClearBeforeRefetch; virtual;
    procedure DoCreateFields; virtual;
    procedure DoFilteringUpdated(AResync: Boolean); virtual;
    function DoFilterRow(AMech: TADDatSMechFilter;
      ARow: TADDatSRow; AVersion: TADDatSRowVersion): Boolean; virtual;
    function DoGetTableName: String; virtual;
    procedure DoMasterDefined; virtual;
    procedure DoMasterReset; virtual;
    function DoMasterParamChanged(AMasterFieldList: TADFieldList): Boolean; virtual;
    procedure DoMasterParamSetValues(AMasterFieldList: TADFieldList); virtual;
    function DoMasterParamDependent(AMasterFieldList: TADFieldList): Boolean; virtual;
    function DoAdjustSortFields(const AFields, AExpression: String;
	  var AIndexOptions: TADSortOptions): String; virtual;
    procedure DoSortOrderChanging; virtual;
    procedure DoSortOrderChanged; virtual;
    procedure DoDefineDatSManager; virtual;
    procedure DoResetDatSManager; virtual;
    procedure DoPrepareSource; virtual;
    procedure DoUnprepareSource; virtual;
    procedure DoOpenSource(ABlocked, AInfoQuery, AStructQuery: Boolean); virtual;
    function DoIsSourceOpen: Boolean; virtual;
    function DoIsSourceAsync: Boolean; virtual;
    function DoIsSourceOnline: Boolean; virtual;
    procedure DoCloseSource; virtual;
    function DoGetDatSManager: TADDatSManager; virtual;
    procedure DoProcessUpdateRequest(ARequest: TADUpdateRequest;
      AOptions: TADUpdateRowOptions); virtual;
    procedure DoExecuteSource(ATimes, AOffset: Integer); virtual;
    procedure DoUpdateErrorHandler(ARow: TADDatSRow; AException: Exception;
      ARequest: TADUpdateRequest; var AAction: TADErrorAction); virtual;
    procedure DoUpdateRecordHandler(ARow: TADDatSRow; ARequest: TADUpdateRequest;
      AOptions: TADUpdateRowOptions; var AAction: TADErrorAction); virtual;
    procedure DoReconcileErrorHandler(ARow: TADDatSRow; AException: EADException;
      AUpdateKind: TADDatSRowState; var AAction: TADDAptReconcileAction); virtual;
    procedure DoCloneCursor(AReset, AKeepSettings: Boolean); virtual;
    procedure InitColumnsFromFieldDefs(ADefs: TFieldDefs; ATable: TADDatSTable;
      ADatSManager: TADDatSManager);
    procedure InitTable(AWithFields: Boolean);
    procedure DoAfterApplyUpdate(AErrors: Integer); virtual;
    procedure ApplyUpdatesComplete(AErrors: Integer);
    procedure DoBeforeApplyUpdate; virtual;
    procedure DoBeforeGetRecords; virtual;
    procedure DoAfterGetRecords(AFromRecord, AToRecord: Integer); virtual;
    procedure DoBeforeRowRequest; virtual;
    procedure DoAfterRowRequest; virtual;
    procedure DoBeforeExecute; virtual;
    procedure DoAfterExecute; virtual;
    procedure EndForceRow;
    function GetRowVersion: TADDatSRowVersion;
    function IsForceRowMode: Boolean; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    function GetUpdates: TADDatSUpdatesJournal; virtual;
    function BuildViewForIndex(AIndex: TADIndex): TADDatSView;
    procedure CheckFetchedAllBeforeSorting;
    function GetParams: TADParams; virtual;
    procedure SetColumnAttributes;
    function SaveToDFM: Boolean; virtual;
    procedure StartWait;
    procedure StopWait;
    procedure UpdateRecordCount; virtual;
    function GetDisplayName: String;
    function DoStoredActivation: Boolean; virtual;
    procedure InternalResetRange; virtual;
    function BeginLocate(AOptions: TADDataSetLocateOptions;
      ApRecordIndex: PInteger): Integer;
    procedure EndLocate(AResult: Boolean; APos: Integer;
      AOptions: TADDataSetLocateOptions; ApRecordIndex: PInteger);
    function BeginLookup(AOptions: TADDataSetLocateOptions;
      ApRecordIndex: PInteger): Integer;
    function EndLookup(AResult: Boolean; APos: Integer;
      const AResultFields: string; ApRecordIndex: PInteger): Variant;
    property Updates: TADDatSUpdatesJournal read GetUpdates;
    property Params: TADParams read GetParams write SetParams stored False;
    property ParamCount: Word read GetParamsCount;
    property BookmarkSize write SetBookmarkSize;
    property SortView: TADDatSView read FSortView;

    // IADStanOptions
    property OptionsIntfImpl: IADStanOptions read GetOptionsIntf implements IADStanOptions;
    property FormatOptions: TADFormatOptions read GetFormatOptions write SetFormatOptions;
    property FetchOptions: TADFetchOptions read GetFetchOptions write SetFetchOptions;
    property UpdateOptions: TADBottomUpdateOptions read GetUpdateOptions write SetUpdateOptions;
    property ResourceOptions: TADBottomResourceOptions read GetResourceOptions write SetResourceOptions;

{$IFDEF AnyDAC_FPC}
    property DataSetField: TDataSetField read FDataSetField;
    property SparseArrays: Boolean read FSparseArrays;
    property NestedDataSets: TList read FNestedDataSets;
{$ENDIF}

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddIndex(const AName, AFields, AExpression: string; AOptions: TADSortOptions;
      const ADescFields: string = ''; const ACaseInsFields: string = ''; ADistinct: Boolean = False);
    procedure ApplyMaster;
    procedure ApplyRange;
    function ApplyUpdates(AMaxErrors: Integer = -1): Integer;
    procedure AttachTable(ATable: TADDatSTable; AView: TADDatSView); virtual;
    procedure BeginBatch(AWithDelete: Boolean = False);
    procedure EndBatch;
    function BookmarkValid(ABookmark: TBookmark): Boolean; override;
{$IFNDEF NEXTGEN}
    function BookmarkStrValid(ABookmarkStr: TBookmarkStr): Boolean;
{$ENDIF}
    procedure Cancel; override;
    procedure CancelRange;
    procedure CancelUpdates;
    procedure ClearBlobs;
    procedure ClearDetails;
    procedure CloneCursor(ASource: TADDataSet; AReset: Boolean = False;
      AKeepSettings: Boolean = False); virtual;
    procedure CommitUpdates;
    function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; override;
    procedure CopyRecord(ASource: TDataset);
    procedure CopyDataSet(ASource: TDataset; AOptions: TADCopyDataSetOptions = [coRestart, coAppend]);
    procedure CreateDataSet;
    function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;
    function CreateExpression(const AExpr: String;
      AOptions: TADExpressionOptions = []): IADStanExpressionEvaluator;
    procedure DeleteIndex(const AName: string);
    procedure DeleteIndexes;
    procedure DisableConstraints;
    procedure Disconnect(AAbortJob: Boolean = False); virtual;
    procedure EditKey;
    procedure EditRangeEnd;
    procedure EditRangeStart;
    procedure EmptyDataSet;
    procedure EmptyView;
    procedure EnableConstraints;
    procedure Execute(ATimes: Integer = 0; AOffset: Integer = 0); virtual;
    function OpenOrExecute: Boolean;
    procedure FetchAgain;
    procedure FetchAll;
    procedure FetchBlobs;
    procedure FetchDetails(ADataSetField: TDataSetField = nil);
    function FetchNext: Integer;
    function FindKey(const AKeyValues: array of const): Boolean;
    procedure FindNearest(const AKeyValues: array of const);
    function FindParam(const AValue: string): TADParam;
{$IFDEF AnyDAC_FPC}
    function FindFirst: Boolean;
    function FindLast: Boolean;
    function FindNext: Boolean;
    function FindPrior: Boolean;
{$ENDIF}
    function GetCurrentRecord(Buffer: PADBuffer): Boolean; override;
    procedure GetDetailLinkFields(AMasterFields, ADetailFields: TADFieldList); {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function GetColumnField(AColumn: TADDatSColumn): TField;
    function GetFieldColumn(AField: TField): TADDatSColumn; overload;
    function GetFieldData(AFieldNo: Integer; {$IFDEF AnyDAC_D18} var {$ENDIF} ABuffer: PADValue): Boolean; overload; {$IFNDEF AnyDAC_FPC} override; {$ENDIF}
    function GetFieldData(AField: TField; {$IFDEF AnyDAC_D18} var {$ENDIF} ABuffer: PADValue): Boolean; overload; override;
{$IFDEF VER240}
    function GetFieldData(AField: TField; Buffer: Pointer): Boolean; overload; override;
{$ENDIF}
{$IFNDEF AnyDAC_FPC}
    function GetStateFieldValue(AState: TDataSetState; AField: TField): Variant; override;
{$ENDIF}
    function GetGroupState(ALevel: Integer): TGroupPosInds;
    procedure GetIndexNames(AList: TStrings);
    function GetNextPacket: Integer;
    function GetRow(ABuffer: PADBuffer = C_NIL; AForceBufferRead: Boolean = False): TADDatSRow;
    function GetLocateRow: TADDatSRow;
    function GetParentRow: TADDatSRow;
    procedure GotoCurrent(ADataSet: TADDataSet);
    function GotoKey: Boolean;
    procedure GotoNearest;
    function IsLinkedNested: Boolean;
    function IsLinkedDetail: Boolean;
    function IsLinked: Boolean;
    function IsRanged: Boolean;
    function IsSequenced: Boolean; override;
    function IsIndexed: Boolean;
    function Locate(const AKeyFields: string; const AKeyValues: Variant;
      AOptions: TLocateOptions = []): Boolean; override;
    function LocateEx(const AKeyFields: string; const AKeyValues: Variant;
      AOptions: TADDataSetLocateOptions = []; ApRecordIndex: PInteger = nil): Boolean; overload; virtual;
    function LocateEx(const AExpression: string;
      AOptions: TADDataSetLocateOptions = []; ApRecordIndex: PInteger = nil): Boolean; overload; virtual;
    function Lookup(const AKeyFields: string; const AKeyValues: Variant;
      const AResultFields: string): Variant; override;
    function LookupEx(const AKeyFields: string; const AKeyValues: Variant;
      const AResultFields: string; AOptions: TADDataSetLocateOptions = [];
      ApRecordIndex: PInteger = nil): Variant; overload; virtual;
    function LookupEx(const AExpression, AResultFields: string;
      AOptions: TADDataSetLocateOptions = []; ApRecordIndex: PInteger = nil): Variant; overload; virtual;
    procedure Offline;
    procedure Release;
    procedure Resync(Mode: TResyncMode); override;
    function ParamByName(const AValue: string): TADParam;
    procedure Post; override;
    function Reconcile: Boolean;
    function RefreshRecord(AClearRow: Boolean = True): Boolean;
    procedure RefreshUnknownRecord(const AValues: array of Variant;
      AReread: Boolean = True; ASetPos: Boolean = True);
    procedure RevertRecord;
    procedure SetFieldAttributes(AField: TField; AColumn: TADDatSColumn); overload;
    procedure SetFieldAttributes(AFields: TFields); overload;
    procedure SetFieldAttributes; overload;
    procedure SetPersFieldAttributes;
{$IFNDEF AnyDAC_FPC}
    procedure SetFieldAutoGenerateValue(AField: TField; AValue: TAutoRefreshFlag);
{$ENDIF}
    procedure SetRangeEnd;
    procedure SetRangeStart;
    procedure SetRange(const AStartValues, AEndValues: array of const;
      AStartExclusive: Boolean = False; AEndExclusive: Boolean = False);
    procedure SetKey;
    function UndoLastChange(AFollowChange: Boolean): Boolean;
    function UpdateStatus: TUpdateStatus; override;
    procedure UpdateConstraints;
    procedure UpdateAttributes;
    procedure LoadFromStream(AStream: TStream; AFormat: TADStorageFormat = sfAuto);
    procedure LoadFromFile(const AFileName: String = ''; AFormat: TADStorageFormat = sfAuto);
    procedure SaveToStream(AStream: TStream; AFormat: TADStorageFormat = sfAuto);
    procedure SaveToFile(const AFileName: String = ''; AFormat: TADStorageFormat = sfAuto);
    function LoadFromFileAtOpen: Boolean;
    function SaveToFileAtClose: Boolean;

    procedure AddListener(const AListener: IADDataSetListener);
    procedure RemoveListener(const AListener: IADDataSetListener);

    property ActiveStoredUsage: TADStoredActivationUsage read FActiveStoredUsage
      write FActiveStoredUsage default [auDesignTime, auRunTime];
    property ActualDetailFields: String read GetActualDetailFields;
    property Aggregates: TADAggregates read FAggregates write SetAggregates stored IsA;
    property AggregatesActive: Boolean read FAggregatesActive write SetAggregatesActive default False;
    property CachedUpdates: Boolean read GetCachedUpdates write SetCachedUpdates default False;
    property ChangeCount: Integer read GetChangeCount;
    property ClientCursor: Boolean read FClientCursor;
    property CloneSource: TADDataSet read FCloneSource;
{$IFDEF AnyDAC_FPC}
    property Constraints: TCheckConstraints read FConstraints write SetConstraints stored IsCS;
{$ELSE}
    property Constraints stored IsCS;
{$ENDIF}
    property ConstraintsEnabled: Boolean read GetConstraintsEnabled
      write SetConstraintsEnabled default False;
    property Data: IADDataSetReference read GetData write SetData;
    property Delta: IADDataSetReference read GetDelta;
    property RowError: EADException read GetRowError;
    property FilteredData: IADDataSetReference read GetFilteredData;
    property DatSManager: TADDatSManager read DoGetDatSManager;
    property GroupingLevel: Integer read GetGroupingLevel;
    property UpdatesPending: Boolean read GetUpdatesPending;
    property IndexDefs: TIndexDefs read FIndexDefs write SetIndexDefs stored IsIDS;
    property Indexes: TADIndexes read FIndexes write SetIndexes stored IsIS;
    property IndexesActive: Boolean read FIndexesActive write SetIndexesActive default True;
    property IndexName: String read FIndexName write SetIndexName;
    property LocalIndexName: String read FLocalIndexName;
    property IndexFieldNames: String read GetIndexFieldNames write SetIndexFieldNames;
    property IndexFields[AIndex: Integer]: TField read GetIndexField;
    property IndexFieldCount: Integer read GetIndexFieldCount;
    property KeyExclusive: Boolean read GetKeyExclusive write SetKeyExclusive;
    property KeyFieldCount: Integer read GetKeyFieldCount write SetKeyFieldCount;
    property MasterLink: TADMasterDataLink read FMasterLink;
    property MasterSource: TDataSource read GetDataSource write SetMasterSource;
    property MasterFields: String read GetMasterFields write SetMasterFields;
    property DetailFields: String read FDetailFields write FDetailFields;
    property OptionsIntf: IADStanOptions read GetOptionsIntf write SetOptionsIntf;
    property ParentDataSet: TADDataSet read FParentDataSet;
    property SavePoint: Integer read GetSavePoint write SetSavePoint;
    property SourceEOF: Boolean read FSourceEOF;
    property SourceView: TADDatSView read FSourceView;
    property FilterChanges: TADUpdateRecordTypes read FFilterChanges write SetFilterChanges
      default [rtUnmodified, rtModified, rtInserted];
    property Table: TADDatSTable read FTable;
    property View: TADDatSView read FView;

    property AfterApplyUpdates: TADAfterApplyUpdatesEvent read FAfterApplyUpdates write FAfterApplyUpdates;
    property AfterExecute: TADDataSetEvent read FAfterExecute write FAfterExecute;
    property AfterGetRecords: TADDataSetEvent read FAfterGetRecords write FAfterGetRecords;
    property AfterGetRecord: TADDataSetEvent read FAfterGetRecord write FAfterGetRecord;
    property AfterRowRequest: TADDataSetEvent read FAfterRowRequest write FAfterRowRequest;
    property BeforeApplyUpdates: TADDataSetEvent read FBeforeApplyUpdates write FBeforeApplyUpdates;
    property BeforeExecute: TADDataSetEvent read FBeforeExecute write FBeforeExecute;
    property BeforeGetRecords: TADDataSetEvent read FBeforeGetRecords write FBeforeGetRecords;
    property BeforeRowRequest: TADDataSetEvent read FBeforeRowRequest write FBeforeRowRequest;
    property OnReconcileError: TADReconcileErrorEvent read FOnReconcileError
      write FOnReconcileError;
    property OnUpdateRecord: TADUpdateRecordEvent read FOnUpdateRecord
      write FOnUpdateRecord;
    property OnUpdateError: TADUpdateErrorEvent read FOnUpdateError
      write FOnUpdateError;
    property OnMasterSetValues: TADDataSetEvent read FOnMasterSetValues write FOnMasterSetValues;
  end;

  TADWideMemoField = class({$IFDEF AnyDAC_D10} TWideMemoField {$ELSE} TBlobField {$ENDIF})
  protected
    function GetAsWideString: TADWideString;
      {$IFDEF AnyDAC_D10} override; {$ENDIF} {$IFDEF AnyDAC_FPC} override; {$ENDIF}
    procedure SetAsWideString(const AValue: TADWideString);
      {$IFDEF AnyDAC_D10} override; {$ENDIF} {$IFDEF AnyDAC_FPC} override; {$ENDIF}
    function GetClassDesc: string; override;
    function GetAsString: String; override;
    procedure SetAsString(const AValue: String); override;
    function GetAsVariant: Variant; override;
    procedure SetVarValue(const AValue: Variant); override;
  public
    constructor Create(AOwner: TComponent); override;
    property Value: TADWideString read GetAsWideString write SetAsWideString;
  end;

  TADXMLField = class(TADWideMemoField)
  private
    function GetSchemaName: String;
  protected
    function GetClassDesc: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    property SchemaName: String read GetSchemaName;
  end;

  TADAutoIncField = class(TAutoIncField)
  private
    FAutoIncrementSeed: Integer;
    FAutoIncrementStep: Integer;
    FClientAutoIncrement: Boolean;
    FServerAutoIncrement: Boolean;
    FGeneratorName: String;
    procedure SetAutoIncrementSeed(const AValue: Integer);
    procedure SetAutoIncrementStep(const AValue: Integer);
    procedure SetClientAutoIncrement(const AValue: Boolean);
    procedure SetServerAutoIncrement(const AValue: Boolean);
    function GetIdentityInsert: Boolean;
    procedure SetIdentityInsert(const AValue: Boolean);
{$IFDEF AnyDAC_FPC}
  protected
    procedure SetAsLongInt(AValue: LongInt); override;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
  published
{$IFNDEF AnyDAC_FPC}
    property AutoGenerateValue default DB.arAutoInc;
{$ENDIF}
    {$IFDEF AnyDAC_D17} [Default(False)] {$ENDIF}
    property ReadOnly default True;
    property ProviderFlags default [pfInWhere];
    property ClientAutoIncrement: Boolean read FClientAutoIncrement
      write SetClientAutoIncrement default True;
    property ServerAutoIncrement: Boolean read FServerAutoIncrement
      write SetServerAutoIncrement default True;
    property AutoIncrementSeed: Integer read FAutoIncrementSeed
      write SetAutoIncrementSeed default -1;
    property AutoIncrementStep: Integer read FAutoIncrementStep
      write SetAutoIncrementStep default -1;
    property IdentityInsert: Boolean read GetIdentityInsert
      write SetIdentityInsert default False;
    property GeneratorName: String read FGeneratorName
      write FGeneratorName;
  end;

  TADSQLTimeIntervalField = class(TField)
  private
    function GetAsInterval: TADSQLTimeInterval;
    procedure SetAsInterval(AValue: TADSQLTimeInterval);
    function GetIntervalKind: TADSQLTimeIntervalKind;
    function GetIntRec(var ARec: TADSQLTimeInterval): Boolean;
    procedure SetIntRec(var ARec: TADSQLTimeInterval); {$IFDEF AnyDAC_D9} inline; {$ENDIF}
  protected
    function GetClassDesc: string; override;
    function GetAsString: String; override;
    procedure SetAsString(const AValue: String); override;
{$IFDEF AnyDAC_D6Base}
    function GetAsVariant: Variant; override;
    procedure SetVarValue(const AValue: Variant); override;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    property IntervalKind: TADSQLTimeIntervalKind read GetIntervalKind;
    property AsSQLTimeInterval: TADSQLTimeInterval read GetAsInterval write SetAsInterval;
  end;

  TADBlobStream = class(TMemoryStream)
  private
    FField: TField;
    FDataSet: TADDataSet;
    FBuffer: PADBuffer;
    FModified: Boolean;
    FWritten: Boolean;
    FMode: TBlobStreamMode;
    procedure ReadBlobData;
    procedure CheckWrite;
  protected
    function Realloc(var ANewCapacity: {$IFDEF AnyDAC_FPC} TADNativeInt {$ELSE}
                                                           LongInt {$ENDIF}): Pointer; override;
  public
    constructor Create(AField: TField; AMode: TBlobStreamMode);
    destructor Destroy; override;
    procedure Truncate;
    function Write(const ABuffer; ACount: Longint): Longint; override;
{$IFDEF AnyDAC_D17}
    function Write(const ABuffer: TBytes; AOffset, ACount: Longint): Longint; override;
{$ENDIF}
  end;

  function ADCheckStoredUsage(AComponentState: TComponentState;
    AUsage: TADStoredActivationUsage): Boolean;

implementation

uses
{$IFNDEF AnyDAC_FPC}
  DBConsts,
{$ELSE}
  dbconst,
{$ENDIF}
{$IFDEF AnyDAC_D6Base}
  Variants, FmtBcd,
  {$IFDEF AnyDAC_D6}
  SqlTimSt,
  {$ENDIF}
{$ELSE}
  ActiveX, ComObj,
{$ENDIF}
{$IFNDEF NEXTGEN}
  {$IFDEF AnyDAC_D10}
  WideStrUtils,
  {$ENDIF}
  {$IFDEF AnyDAC_D18}
  System.AnsiStrings,
  {$ENDIF}
{$ENDIF}
  uADStanConst, uADStanFactory,
  uADGUIxIntf, Math;

{ ----------------------------------------------------------------------------- }
type
{$IFNDEF AnyDAC_FPC}
  {$HINTS OFF}
  __TField = class(TComponent)
  private
    FAutoGenerateValue: TAutoRefreshFlag;
    FDataSet: TDataSet;
    FFieldName: string;
    FFields: TFields;
    FDataType: TFieldType;
    FReadOnly: Boolean;
    FFieldKind: TFieldKind;
    FAlignment: TAlignment;
    FVisible: Boolean;
    FRequired: Boolean;
    FValidating: Boolean;
  end;
  {$HINTS ON}
{$ELSE}
  __TFieldDef = class(TNamedItem)
  private
    FDataType : TFieldType;
    FFieldNo : Longint;
  end;
{$ENDIF}

{ ----------------------------------------------------------------------------- }
function ADCheckStoredUsage(AComponentState: TComponentState;
  AUsage: TADStoredActivationUsage): Boolean;
begin
  Result := not (csDesigning in AComponentState) and (auRunTime in AUsage) or
            (csDesigning in AComponentState) and (auDesignTime in AUsage);
end;

{-------------------------------------------------------------------------------}
{ TADMasterDataLink                                                             }
{-------------------------------------------------------------------------------}
constructor TADMasterDataLink.Create(ADataSet: TDataSet);
begin
  inherited Create(ADataSet);
  FDetailDataSet := ADataSet as TADDataSet;
  inherited OnMasterChange := DoMasterChanged;
end;

{-------------------------------------------------------------------------------}
destructor TADMasterDataLink.Destroy;
begin
  ADFreeAndNil(FTimer);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.ActiveChanged;
begin
  if FActiveChangedLocked then
    Exit;
  if (DataSet <> nil) and Active then
    if Assigned(FOnMasterFieldsDefined) then
      try
        FActiveChangedLocked := True;
        FOnMasterFieldsDefined(Self);
      finally
        FActiveChangedLocked := False;
      end;
  if (FTimer <> nil) and FTimer.Enabled and not Active then
    FTimer.Enabled := False;
  inherited ActiveChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.StartDelayedScroll;
begin
  if FDetailDataSet <> nil then begin
    if FTimer = nil then begin
      FTimer := TADTimer.Create(nil);
      FTimer.Options := [toSynchronized, toSingleFire];
      FTimer.OnTimer := DoDelayedScroll;
    end;
    FTimer.Schedule(FDetailDataSet.FetchOptions.DetailDelay);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.DoDelayedScroll;
begin
  if Active then
    try
      Inc(FDelayedScrollDisabled);
      inherited DataEvent(FDelayedEvent, 0);
    finally
      Dec(FDelayedScrollDisabled);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.DataEvent(Event: TDataEvent;
  Info: {$IFDEF AnyDAC_XPLAT} TADNativeInt {$ELSE} Longint {$ENDIF});
begin
{$IFDEF AnyDAC_D7}
  if (Event = deDataSetChange) and FFireActiveChanged then
    try
      ActiveChanged;
    finally
      FFireActiveChanged := False;
    end;
{$ENDIF}
  if Event in [deDataSetScroll, deDataSetChange] then
    if FScrollDisabled > 0 then begin
      FDelayedEvent := Event;
      Exit;
    end
    else if ActualDelayedScrollEnabled then begin
      FDelayedEvent := Event;
      StartDelayedScroll;
      Exit;
    end;
  inherited DataEvent(Event, Info);
{$IFDEF AnyDAC_D7}
  if Event = deDisabledStateChange then
    FFireActiveChanged := True;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.DoMasterChanged(ASender: TObject);
begin
  FDetailDataSet.ResetMasterRelation;
  if (FScrollDisabled = 0) and Assigned(OnMasterChange) then
    OnMasterChange(ASender);
end;

{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.RecordChanged(Field: TField);
begin
  if (FScrollDisabled = 0) and
     (DataSource.State <> dsSetKey) and FDetailDataSet.Active and
     ((Fields.Count > 0) or Assigned(FDetailDataSet.OnMasterSetValues)) and
     ((Field = nil) or (Fields.IndexOf(Field) >= 0)) and
     Assigned(OnMasterChange) then
    OnMasterChange(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.Synchronize(AWithDetails: Boolean = True);
{$IFNDEF AnyDAC_FPC}
var
  oList: TADDataSetList;
  i: Integer;
{$ENDIF}
begin
  FDetailDataSet.StartWait;
  try
    if FDetailDataSet.FetchOptions.DetailDelay = 0 then
      FDetailDataSet.ApplyMaster
    else if (FTimer <> nil) and FTimer.Enabled and Active then begin
      FTimer.Enabled := False;
      DoDelayedScroll();
    end;
{$IFNDEF AnyDAC_FPC}
    if AWithDetails then begin
      oList := TADDataSetList.Create;
      try
        FDetailDataSet.GetDetailDataSets(oList);
        for i := 0 to oList.Count - 1 do
          if TDataSet(oList[i]) is TADDataSet then
            TADDataSet(oList[i]).MasterLink.Synchronize(True);
      finally
        ADFree(oList);
      end;
    end;
{$ENDIF}
  finally
    FDetailDataSet.StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.CancelSync(AWithDetails: Boolean = True);
{$IFNDEF AnyDAC_FPC}
var
  oList: TADDataSetList;
  i: Integer;
{$ENDIF}
begin
  FTimer.Enabled := False;
{$IFNDEF AnyDAC_FPC}
  if AWithDetails then begin
    oList := TADDataSetList.Create;
    try
      FDetailDataSet.GetDetailDataSets(oList);
      for i := 0 to oList.Count - 1 do
        if TDataSet(oList[i]) is TADDataSet then
          TADDataSet(oList[i]).MasterLink.CancelSync(True);
    finally
      ADFree(oList);
    end;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.DisableDelayedScroll;
begin
  Inc(FDelayedScrollDisabled);
  if FDelayedScrollDisabled = 1 then
    Synchronize(True);
end;

{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.EnableDelayedScroll;
begin
  if FDelayedScrollDisabled > 0 then
    Dec(FDelayedScrollDisabled);
end;

{-------------------------------------------------------------------------------}
function TADMasterDataLink.GetDelayedScrollEnabled: Boolean;
begin
  Result := (FDelayedScrollDisabled = 0);
  if Result and (DataSet <> nil) and (DataSet is TADDataSet) then
    Result := TADDataSet(DataSet).MasterLink.DelayedScrollEnabled;
end;

{-------------------------------------------------------------------------------}
function TADMasterDataLink.GetActualDelayedScrollEnabled: Boolean;
begin
  Result := (DataSet <> nil) and (FDetailDataSet.FetchOptions.DetailDelay > 0) and
    DelayedScrollEnabled;
end;

{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.DisableScroll;
begin
  Inc(FScrollDisabled);
end;

{-------------------------------------------------------------------------------}
procedure TADMasterDataLink.EnableScroll;
begin
  if FScrollDisabled > 0 then begin
    Dec(FScrollDisabled);
    if FScrollDisabled = 0 then
      Synchronize(True);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADDatSTableMetadataCallback                                                  }
{-------------------------------------------------------------------------------}
type
  TADDatSTableMetadataCallback = class(TInterfacedObject, IADDatSTableMetadataCallback)
  private
    FDataSet: TADDataSet;
  protected
    // IADDatSTableMetadataCallback
    procedure GetColumnOptions(AColumn: TADDatSColumn; var AOptions: TADDataOptions);
    procedure GetColumnAttributes(AColumn: TADDatSColumn; var AAttributes: TADDataAttributes);
    procedure GetColumnOrigin(AColumn: TADDatSColumn; var AOrigin: String);
    procedure GetColumnGenerator(AColumn: TADDatSColumn; var AGenerator: String);
    procedure GetColumnCaption(AColumn: TADDatSColumn; var ACaption: String);
    procedure GetTableOrigin(var AOrigin: String);
    function GetOwner: TObject;
  public
    constructor Create(ADataSet: TADDataSet);
  end;

{-------------------------------------------------------------------------------}
constructor TADDatSTableMetadataCallback.Create(ADataSet: TADDataSet);
begin
  inherited Create;
  FDataSet := ADataSet;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableMetadataCallback.GetColumnOptions(AColumn: TADDatSColumn;
  var AOptions: TADDataOptions);
var
  oFld: TField;
begin
  oFld := FDataSet.GetColumnField(AColumn);
  if oFld <> nil then begin
    if oFld.Required then
      Exclude(AOptions, coAllowNull)
    else
      Include(AOptions, coAllowNull);
    if oFld.ReadOnly then
      Include(AOptions, coReadOnly)
    else
      Exclude(AOptions, coReadOnly);
    if pfInUpdate in oFld.ProviderFlags then
      Include(AOptions, coInUpdate)
    else
      Exclude(AOptions, coInUpdate);
    if pfInWhere in oFld.ProviderFlags then
      Include(AOptions, coInWhere)
    else
      Exclude(AOptions, coInWhere);
    if pfInKey in oFld.ProviderFlags then
      Include(AOptions, coInKey)
    else
      Exclude(AOptions, coInKey);
{$IFNDEF AnyDAC_FPC}
    if oFld.AutoGenerateValue <> DB.arNone then
      Include(AOptions, coAfterInsChanged)
    else
      Exclude(AOptions, coAfterInsChanged);
{$ENDIF}
  end
  else
    Include(AOptions, coAllowNull);
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableMetadataCallback.GetColumnAttributes(
  AColumn: TADDatSColumn; var AAttributes: TADDataAttributes);
var
  oFld: TField;
begin
  oFld := FDataSet.GetColumnField(AColumn);
  if oFld <> nil then begin
{$IFNDEF AnyDAC_FPC}
    if oFld.AutoGenerateValue <> DB.arNone then begin
      case oFld.AutoGenerateValue of
      DB.arAutoInc: Include(AAttributes, caAutoInc);
      DB.arDefault: Include(AAttributes, caDefault);
      end;
    end
    else begin
      Exclude(AAttributes, caAutoInc);
      Exclude(AAttributes, caDefault);
    end;
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableMetadataCallback.GetColumnOrigin(AColumn: TADDatSColumn;
  var AOrigin: String);
var
  oFld: TField;
begin
  oFld := FDataSet.GetColumnField(AColumn);
  if oFld <> nil then
    if oFld.Origin <> '' then
      AOrigin := oFld.Origin;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableMetadataCallback.GetColumnGenerator(
  AColumn: TADDatSColumn; var AGenerator: String);
var
  oFld: TField;
begin
  oFld := FDataSet.GetColumnField(AColumn);
  if (oFld <> nil) and (oFld is TADAutoIncField) and
     (TADAutoIncField(oFld).GeneratorName <> '') then
    AGenerator := TADAutoIncField(oFld).GeneratorName
  else if FDataSet.UpdateOptions.GeneratorName <> '' then
    AGenerator := FDataSet.UpdateOptions.GeneratorName;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableMetadataCallback.GetColumnCaption(AColumn: TADDatSColumn;
  var ACaption: String);
var
  oFld: TField;
begin
  oFld := FDataSet.GetColumnField(AColumn);
  if oFld <> nil then
    if (oFld.DisplayLabel <> '') and (oFld.DisplayLabel <> oFld.FieldName) then
      ACaption := oFld.DisplayLabel;
end;

{-------------------------------------------------------------------------------}
procedure TADDatSTableMetadataCallback.GetTableOrigin(var AOrigin: String);
begin
  if FDataSet.UpdateOptions.UpdateTableName <> '' then
    AOrigin := FDataSet.UpdateOptions.UpdateTableName;
end;

{-------------------------------------------------------------------------------}
function TADDatSTableMetadataCallback.GetOwner: TObject;
begin
  Result := FDataSet;
end;

{-------------------------------------------------------------------------------}
{ TADDataSet                                                                    }
{-------------------------------------------------------------------------------}
constructor TADDataSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIndexes := TADIndexes.Create(Self);
  FIndexesActive := True;
{$IFDEF AnyDAC_FPC}
  FConstraints := TCheckConstraints.Create(Self);
{$ENDIF}
  FAggregates := TADAggregates.Create(Self);
  FFieldAggregates := TADAggregates.Create(Self);
  FAggregatesActive := False;
  FIndexDefs := TIndexDefs.Create(Self);
  FFilterChanges := [rtUnmodified, rtModified, rtInserted];
  FClientCursor := True;
{$IFNDEF AnyDAC_FPC}
  ObjectView := True;
{$ENDIF}
  FSourceEOF := True;
  FMasterLink := TADMasterDataLink.Create(Self);
  FMasterLink.OnMasterChange := MasterChanged;
  FMasterLink.OnMasterDisable := MasterDisabled;
  FMasterLink.OnMasterFieldsDefined := MasterDefined;
  FAutoCommitUpdates := True;
  FCreatedConstraints := TADObjList.Create;
  FTempIndexViews := TADObjList.Create;
  FRecordCount := -1;
  FActiveStoredUsage := [auDesignTime, auRunTime];
  FEventListeners := TInterfaceList.Create;
  ConstraintsEnabled := False;
  FEncoder := TADEncoder.Create(nil);
  FEncoder.Encoding := ecANSI;
end;

{-------------------------------------------------------------------------------}
destructor TADDataSet.Destroy;
begin
  AttachTable(nil, nil);
  ADFreeAndNil(FEncoder);
  ADFreeAndNil(FIndexDefs);
  ADFreeAndNil(FAggregates);
  ADFreeAndNil(FFieldAggregates);
{$IFDEF AnyDAC_FPC}
  ADFreeAndNil(FConstraints);
{$ENDIF}
  ADFreeAndNil(FIndexes);
  ClearFColumns;
  SetLength(FColumns, 0);
  ADFreeAndNil(FMasterLink);
  ADFreeAndNil(FCreatedConstraints);
  ADFreeAndNil(FTempIndexViews);
  ADFreeAndNil(FEventListeners);
{$IFDEF AnyDAC_D17}
  SetLength(FSetToRecBmk, 0);
{$ELSE}
  FreeMem(FSetToRecBmk);
{$ENDIF}
  FSetToRecBmk := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetDataSet: TObject;
begin
  Result := Self;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsPKViolation(AExc: Exception): Boolean;
begin
  Result :=
    (AExc is EADDBEngineException) and (EADDBEngineException(AExc).Kind = ekUKViolated) or
    (AExc is EADException) and (EADException(AExc).ADCode = er_AD_DuplicateRows);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.AddListener(const AListener: IADDataSetListener);
begin
  FEventListeners.Add(AListener);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.RemoveListener(const AListener: IADDataSetListener);
begin
  FEventListeners.Remove(AListener);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoGetDatSManager: TADDatSManager;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.AttachTable(ATable: TADDatSTable; AView: TADDatSView);
var
  i: Integer;
begin
  // It is confusing when SetActive(True) calls AttachTable,
  // and it calls SetActive(False)
  if Active then
    Close;
  if FTable <> ATable then begin
    if FTable <> nil then begin
      for i:= 0 to FEventListeners.Count - 1 do
        IADDataSetListener(FEventListeners[i]).ResultsetReleasing(Self);
      FTable.RemRef;
    end;
    FTable := ATable;
    if FTable <> nil then begin
      FTable.AddRef;
      for i:= 0 to FEventListeners.Count - 1 do
        IADDataSetListener(FEventListeners[i]).ResultsetDefined(Self);
    end;
  end;
  if FView <> AView then begin
    if FView <> nil then
      FView.RemRef;
    FView := AView;
    if FView <> nil then
      FView.AddRef;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckTable;
  procedure ErrorNoTab;
  begin
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSNoDataTable, [GetDisplayName]);
  end;
begin
  if FTable = nil then
    if State in [dsInactive, dsOpening] then begin
      DoDefineDatSManager;
      if FTable = nil then
        ErrorNoTab;
      FTable.Setup(GetOptionsIntf);
    end
    else
      ErrorNoTab;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalHandleException;
var
  oWait: IADGUIxWaitCursor;
begin
  if not ResourceOptions.ActualSilentMode then begin
    ADCreateInterface(IADGUIxWaitCursor, oWait);
    oWait.PopWait;
  end;
  try
    ADHandleException;
  finally
    if not ResourceOptions.ActualSilentMode then
      oWait.PushWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DataEvent(Event: TDataEvent;
  Info: {$IFDEF AnyDAC_XPLAT} TADNativeInt {$ELSE} Longint {$ENDIF});
begin
  case Event of
  deParentScroll:   MasterChanged(Self);
{$IFDEF AnyDAC_FPC}
  dePropertyChange: FieldDefs.Updated := False;
{$ENDIF}
  end;
  inherited DataEvent(Event, Info);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFetchOptions: TADFetchOptions;
begin
  Result := OptionsIntf.FetchOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFetchOptions(const AValue: TADFetchOptions);
begin
  OptionsIntf.FetchOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFormatOptions: TADFormatOptions;
begin
  Result := OptionsIntf.FormatOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFormatOptions(const AValue: TADFormatOptions);
begin
  OptionsIntf.FormatOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetUpdateOptions: TADBottomUpdateOptions;
begin
  Result := TADBottomUpdateOptions(OptionsIntf.UpdateOptions);
  ASSERT((Result <> nil) and (Result is TADBottomUpdateOptions));
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetUpdateOptions(const AValue: TADBottomUpdateOptions);
begin
  OptionsIntf.UpdateOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetResourceOptions: TADBottomResourceOptions;
begin
  Result := TADBottomResourceOptions(OptionsIntf.ResourceOptions);
  ASSERT((Result <> nil) and (Result is TADBottomResourceOptions));
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetResourceOptions(const AValue: TADBottomResourceOptions);
begin
  OptionsIntf.ResourceOptions.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsSequenced: Boolean;
begin
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoStoredActivation: Boolean;
begin
  Result := ADCheckStoredUsage(ComponentState, ActiveStoredUsage);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetActive(AValue: Boolean);
begin
  if (State in [dsEdit, dsInsert, dsSetKey]) and not AValue and
     (csDestroying in ComponentState) then begin
    // Avoid event handler calls, when a dataset is destroying
    BeforeCancel := nil;
    AfterCancel := nil;
    BeforeScroll := nil;
    AfterScroll := nil;
    OnCalcFields := nil;
    Cancel;
  end;
  if csReading in ComponentState then
    if AValue then
      Include(FFlags, dfStreamedActive)
    else
      Exclude(FFlags, dfStreamedActive)
  else
    inherited SetActive(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeClose;
begin
  inherited DoBeforeClose;
  if not (csDestroying in ComponentState) then
    Cancel;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.StartWait;
var
  oWait: IADGUIxWaitCursor;
begin
  if not ResourceOptions.ActualSilentMode then begin
    Inc(FWaitCounter);
    if FWaitCounter = 1 then begin
      ADCreateInterface(IADGUIxWaitCursor, oWait);
      oWait.StartWait;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.StopWait;
var
  oWait: IADGUIxWaitCursor;
begin
  if FWaitCounter > 0 then begin
    Dec(FWaitCounter);
    if FWaitCounter = 0 then begin
      ADCreateInterface(IADGUIxWaitCursor, oWait);
      oWait.StopWait;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetParams: TADParams;
begin
  // nothing
  Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetParams(const AValue: TADParams);
begin
  GetParams.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.FindParam(const AValue: string): TADParam;
begin
  Result := Params.FindParam(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.ParamByName(const AValue: string): TADParam;
begin
  Result := Params.ParamByName(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetParamsCount: Word;
begin
  Result := Word(Params.Count);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetDisplayName: String;
begin
  if Name <> '' then
    Result := Name
  else
    Result := ClassName + '($' + IntToHex(Integer(Self), 8) + ')';
end;

{-------------------------------------------------------------------------------}
function TADDataSet.InternalFieldByName(const AFieldName, APlace: String): TField;
  procedure ErrorNoField;
  begin
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSFieldNotFound,
      [AFieldName, APlace, GetDisplayName]);
  end;
begin
  Result := FindField(AFieldName);
  if Result = nil then
    ErrorNoField;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFeatures: TADPhysLocalQueryAdapterFeatures;
begin
  Result := [afCachedUpdates, afSavePoints, afIndexFieldNames, afRanges,
    afFilters, afPrimaryKey];
end;

{-------------------------------------------------------------------------------}
{ Master/detail }

function TADDataSet.GetMasterFields: String;
begin
  Result := FMasterLink.FieldNames;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetMasterFields(const AValue: String);
begin
  FMasterLink.FieldNames := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetActualDetailFields: String;
var
  oIdx: TADIndex;
begin
  if fiDetails in FetchOptions.Cache then begin
    if LocalIndexName <> '' then begin
      oIdx := Indexes.FindIndex(LocalIndexName);
      if oIdx <> nil then
        Result := oIdx.Fields
      else
        Result := '';
    end
    else
      Result := IndexFieldNames;
  end
  else
    Result := DetailFields;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetDataSource: TDataSource;
begin
  if FMasterLink <> nil then
    Result := FMasterLink.DataSource
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetMasterSource(const AValue: TDataSource);
begin
  if MasterSource <> AValue then begin
    if (AValue <> nil) and (DataSetField <> nil) then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSNoNestedMasterSource, [GetDisplayName]);
    if IsLinkedTo(AValue) then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSCircularDataLink, [GetDisplayName]);
    if MasterSource <> nil then
      MasterSource.RemoveFreeNotification(Self);
    FMasterLink.DataSource := AValue;
    if MasterSource <> nil then
      MasterSource.FreeNotification(Self);
    if not (csLoading in ComponentState) and
       (Params <> nil) and (Params.Count > 0) then begin
      MasterFields := '';
      DetailFields := '';
    end;
    DoMasterDefined;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.GetDetailLinkFields(AMasterFields, ADetailFields: TADFieldList);
var
  sFields: String;
begin
  AMasterFields.Clear;
  ADetailFields.Clear;
  DoMasterDefined;
  if (MasterSource <> nil) and (MasterSource.DataSet <> nil) then begin
    sFields := MasterFields;
    if sFields <> '' then
      MasterSource.DataSet.GetFieldList(AMasterFields, sFields);
    sFields := ActualDetailFields;
    if sFields <> '' then
      GetFieldList(ADetailFields, sFields);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoMasterDefined;
var
  s: String;
  i: Integer;
  oParam: TADParam;
  oField: TField;
begin
  if (MasterSource <> nil) and (MasterSource.DataSet <> nil) and (Params <> nil) then begin
    if MasterFields = '' then begin
      s := '';
      for i := 0 to Params.Count - 1 do begin
        oParam := Params[i];
        oField := MasterSource.DataSet.FindField(oParam.Name);
        if oField <> nil then begin
          if s <> '' then
            s := s + ';';
          s := s + oField.FieldName;
          if oParam.DataType = ftUnknown then
            oParam.AssignFieldValue(oField, Null);
        end;
      end;
      if s <> '' then
        MasterFields := s;
    end;
    if (DetailFields = '') and not (fiDetails in FetchOptions.Cache) then begin
      s := '';
      for i := 0 to Params.Count - 1 do begin
        oParam := Params[i];
        oField := FindField(oParam.Name);
        if oField <> nil then begin
          if s <> '' then
            s := s + ';';
          s := s + oField.FieldName;
        end;
      end;
      if s <> '' then
        DetailFields := s;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.MasterDefined(Sender: TObject);
begin
  DoMasterDefined;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoMasterParamChanged(AMasterFieldList: TADFieldList): Boolean;
var
  i: Integer;
  oParam: TADParam;
  oField: TField;
begin
  if not FetchOptions.DetailOptimize or Assigned(OnMasterSetValues) or
     (FSourceView = nil) or (FSourceView.Rows.Count = 0) then begin
    Result := True;
    Exit;
  end;
  Result := False;
  if Params <> nil then
    for i := 0 to AMasterFieldList.Count - 1 do begin
      oField := TField(AMasterFieldList[i]);
      oParam := Params.FindParam(oField.FieldName);
      if oParam <> nil then begin
        Result := not ADSameVariants(oParam.Value, oField.Value);
        if Result then
          Break;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoMasterParamSetValues(AMasterFieldList: TADFieldList);
var
  i: Integer;
  oParam: TADParam;
  oField: TField;
begin
  if Params <> nil then
    for i := 0 to AMasterFieldList.Count - 1 do begin
      oField := TField(AMasterFieldList[i]);
      oParam := Params.FindParam(oField.FieldName);
      if oParam <> nil then
        oParam.AssignFieldValue(oField, oField.Value);
    end;
  if Assigned(OnMasterSetValues) then
    OnMasterSetValues(Self);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoMasterParamDependent(AMasterFieldList: TADFieldList): Boolean;
var
  i: Integer;
  oParam: TADParam;
  oField: TField;
begin
  if Assigned(OnMasterSetValues) then begin
    Result := True;
    Exit;
  end;
  Result := False;
  if Params <> nil then
    for i := 0 to AMasterFieldList.Count - 1 do begin
      oField := TField(AMasterFieldList[i]);
      oParam := Params.FindParam(oField.FieldName);
      if oParam <> nil then begin
        Result := True;
        Break;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoMasterReset;
begin
  ResetMasterRelation;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.MasterDisabled(Sender: TObject);
begin
  if fiDetails in FetchOptions.Cache then
    CancelRange;
  DoMasterReset;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckDetailRecords(AEnforce: Boolean);

  function FetchDetails(AAll: Boolean): Boolean;
  begin
    Result := False;
    if DoIsSourceOnline and (
         DoMasterParamDependent(FMasterLink.Fields) and
         DoMasterParamChanged(FMasterLink.Fields) or
         ((FTable = nil) or (FTable.Rows.Count = 0))
       ) then begin
      if not (fiDetails in FetchOptions.Cache) then
        DoClearBeforeRefetch;
      DoCloseSource;
      DoMasterParamSetValues(FMasterLink.Fields);
      FSourceEOF := False;
      FUnidirRecsPurged := 0;
      FRecordCount := -1;
      DoOpenSource(True, False, (FTable = nil) or (FTable.Columns.Count = 0));
      InternalFetchRows(AAll, False);
      Result := True;
    end;
  end;

var
  lChanged: Boolean;
begin
  lChanged := False;
  if DataSetField = nil then begin
    if AEnforce or
       not MasterSource.DataSet.IsEmpty and
       not (MasterSource.DataSet.State in [dsInsert, dsSetKey]) then begin
      if fiDetails in FetchOptions.Cache then begin
        if not Active or (FSourceView = nil) or (FSourceView.Rows.Count = 0) then
          lChanged := FetchDetails(True);
      end
      else if not DoIsSourceOpen or Active then
        lChanged := FetchDetails(False);
    end
    else if not (fiDetails in FetchOptions.Cache) then begin
      DoClearBeforeRefetch;
      lChanged := True;
    end;
    if Active and lChanged then
      First;
  end
  else begin
    if FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax] then
      FParentDataSet.FetchDetails;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.MasterRangeChanged: Boolean;
var
  i: Integer;
  iSaveState: TDataSetState;
  oDestFld, oSrcFld: TField;
begin
  iSaveState := SetTempState(dsSetKey);
  try
    FKeyBuffer := ClearKeyBuffer(GetKeyBuffer(kiRangeStart));
    for i := 0 to FMasterLink.Fields.Count - 1 do begin
      oDestFld := GetIndexField(i);
      oSrcFld := TField(FMasterLink.Fields[i]);
{$IFDEF AnyDAC_D6Base}
      if oDestFld is TLargeintField then
        if oSrcFld.IsNull then
          TLargeintField(oDestFld).Clear
        else
          TLargeintField(oDestFld).Value := oSrcFld.Value
      else
{$ENDIF}
        oDestFld.Assign(oSrcFld);
    end;
    FKeyBuffer^.FFieldCount := FMasterLink.Fields.Count;
    FKeyBuffer^.FModified := True;
  finally
    RestoreState(iSaveState);
  end;
  AssignKeyBuffer(FKeyBuffers[kiRangeEnd], FKeyBuffers[kiRangeStart]);
  Result := SetCursorRange;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckMasterRange;
begin
  if IsLinkedDetail then begin
    if (IndexFieldCount = 0) and (fiDetails in FetchOptions.Cache) then
      FetchOptions.Cache := FetchOptions.Cache - [fiDetails];
    if fiDetails in FetchOptions.Cache then begin
      if (FMasterRelation = nil) and (DatSManager <> nil) and
         FetchOptions.DetailCascade then
        BuildMasterRelation;
      if MasterRangeChanged() then begin
        CreateFilterView;
        RelinkViews;
        ResyncViews;
      end;
    end;
    if FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax] then
      CheckDetailRecords(False);
  end
  else begin
    if fiDetails in FetchOptions.Cache then
      CancelRange;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckParentRow;
begin
  if not Active then
    Exit;
  if GetParentRow <> FLastParentRow then begin
    if FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax] then
      CheckDetailRecords(False);
    DoFilteringUpdated(True);
    First;
  end
  else begin
    UpdateCursorPos;
    Resync([]);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.MasterChanged(Sender: TObject);
begin
  if MasterSource <> nil then
    CheckMasterRange
  else if DataSetField <> nil then
    CheckParentRow;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ApplyMaster;
begin
  MasterChanged(nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.BuildMasterRelation;

  procedure AddFld(var AFields: String; AField: TField);
  begin
    if AFields <> '' then
      AFields := AFields + ';';
    AFields := AFields + AField.FieldName;
  end;

var
  i: Integer;
  sMast, sDet: String;
  oMan: TADDatSManager;
  oFK: TADDatSForeignKeyConstraint;
begin
  if (FMasterRelation <> nil) or (DatSManager = nil) or not FClientCursor or
     (csDesigning in ComponentState) or not (MasterSource.DataSet is TADDataSet) or
     (TADDataSet(MasterSource.DataSet).Table = nil) or (Table = nil) or
     (TADDataSet(MasterSource.DataSet).Table.Manager <> Table.Manager) then
    Exit;
  oMan := DatSManager;
  FMasterRelation := oMan.Relations.FindRelation(TADDataSet(MasterSource.DataSet).Table,
    Table, False);
  if FMasterRelation = nil then begin
    sMast := '';
    sDet := '';
    for i := 0 to FMasterLink.Fields.Count - 1 do begin
      AddFld(sMast, TField(FMasterLink.Fields[i]));
      AddFld(sDet, GetIndexField(i));
    end;
    FMasterRelation := oMan.Relations.Add('', sMast, sDet, TADDataSet(MasterSource.DataSet).Table,
      Table, False, True);
    FMasterRelation.CountRef;
    oFK := FMasterRelation.ChildKeyConstraint;
    oFK.InsertRule := crCascade;
    oFK.UpdateRule := crCascade;
    oFK.DeleteRule := crCascade;
  end
  else
    FMasterRelation.AddRef;
  ConstraintsEnabled := True;
  TADDataSet(MasterSource.DataSet).ConstraintsEnabled := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ResetMasterRelation;
begin
  if FMasterRelation = nil then
    Exit;
  FMasterRelation.RemRef;
  FMasterRelation := nil;
end;

{-------------------------------------------------------------------------------}
{ Views management }

procedure TADDataSet.ResetViews;
begin
  if FSourceView <> nil then begin
    FSourceView.RemRef;
    FSourceView := nil;
    FSourceViewLocator := nil;
  end;
  if FFilterView <> nil then begin
    FFilterView.RemRef;
    FFilterView := nil;
  end;
  if FSortView <> nil then begin
    FSortView.RemRef;
    FSortView := nil;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CreateFilterMech(AFilter: TADDatSMechFilter): TADDatSMechFilter;
var
  expOpts: TADExpressionOptions;
  evt: TADFilterRowEvent;
begin
  expOpts := [];
  if foCaseInsensitive in FilterOptions then
    Include(expOpts, ekNoCase);
  if not (foNoPartialCompare in FilterOptions) then
    Include(expOpts, ekPartial);
  if Assigned(OnFilterRecord) then
    evt := DoFilterRow
  else
    evt := nil;
  if AFilter <> nil then
    Result := AFilter
  else
    Result := TADDatSMechFilter.Create;
  Result.Options := expOpts;
  Result.Expression := Filter;
  Result.OnFilterRow := evt;
  Result.Active := True;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CreateChildMech: TADDatSMechChilds;
begin
  Result := TADDatSMechChilds.Create(GetParentRow);
  FLastParentRow := Result.ParentRow;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CreateRangeMech: TADDatSMechRange;
begin
  Result := TADDatSMechRange.Create;
  Result.Bottom := FRangeFrom;
  Result.BottomExclusive := dfRangeFromExclusive in FFlags;
  Result.BottomColumnCount := FRangeFromFieldCount;
  Result.Top := FRangeTo;
  Result.TopExclusive := dfRangeToExclusive in FFlags;
  Result.TopColumnCount := FRangeToFieldCount;
  Result.Active := True;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CreateStateMech: TADDatSMechRowState;
var
  rowStates: TADDatSRowStates;
begin
  rowStates := [];
  if rtModified in FFilterChanges then
    Include(rowStates, rsModified);
  if rtInserted in FFilterChanges then
    Include(rowStates, rsInserted);
  if rtDeleted in FFilterChanges then
    Include(rowStates, rsDeleted);
  if rtUnmodified in FFilterChanges then
    Include(rowStates, rsUnchanged);
  Result := TADDatSMechRowState.Create(rowStates);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CreateFilterView;
var
  oView: TADDatSView;

  procedure CheckView;
  begin
    if oView <> nil then
      Exit;
    oView := TADDatSView.Create(FTable, C_AD_SysNamePrefix + 'FLT',
      vcDataSetFilter, True);
  end;

begin
  oView := nil;
  if FFilterView <> nil then begin
    FFilterView.RemRef;
    FFilterView := nil;
  end;
  try
    if (FParentDataSet <> nil) and (FTable.Manager <> nil) then begin
      CheckView;
      oView.Mechanisms.Add(CreateChildMech);
    end;
    // When range is part of WHERE then local filtering is not needed
    if IsRanged and FClientCursor then begin
      CheckView;
      oView.Mechanisms.Add(CreateRangeMech);
    end;
    if Filtered and ((Filter <> '') or Assigned(OnFilterRecord)) then begin
      CheckView;
      oView.Mechanisms.Add(CreateFilterMech(nil));
    end;
    if FFilterChanges - [rtHasErrors] <>
       [rtUnmodified, rtModified, rtInserted, rtDeleted] then begin
      CheckView;
      oView.Mechanisms.Add(CreateStateMech);
    end;
    if rtHasErrors in FFilterChanges then begin
      CheckView;
      oView.Mechanisms.Add(TADDatSMechError.Create);
    end;
  except
    if oView <> nil then
      oView.RemRef;
    raise;
  end;
  FFilterView := oView;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.RelinkViews;
begin
  FAggregates.Release;
  FFieldAggregates.Release;
  if FSourceView <> nil then begin
    FSourceView.RemRef;
    FSourceView := nil;
    FSourceViewLocator := nil;
  end;
  if FFilterView <> nil then begin
    if FSortView <> nil then
      FFilterView.SourceView := FSortView
    else
      FFilterView.SourceView := FView;
    FSourceView := FFilterView;
    FSourceView.AddRef;
  end;
  if FSortView <> nil then begin
    FSortView.SourceView := FView;
    FSortView.Active := True;
    if FSourceView = nil then begin
      FSourceView := FSortView;
      FSourceView.AddRef;
    end;
  end;
  if FFilterView <> nil then
    FFilterView.Active := True;
  if FSourceView = nil then begin
    if FView <> nil then
      FSourceView := FView
    else
      FSourceView := FTable.FullView;
    FSourceView.AddRef;
  end;
  FAggregates.Build;
  FFieldAggregates.Build;
  FSourceView.Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ResyncViews;
var
  oLastRow: TADDatSRow;
begin
  if Active then begin
    oLastRow := GetRow;
    if oLastRow <> nil then
      FRecordIndex := FSourceView.IndexOf(oLastRow);
    Include(FFlags, dfLockNoBMK);
    try
      UpdateCursorPos;
      Resync([]);
    finally
      Exclude(FFlags, dfLockNoBMK);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetTableConstraints;

  procedure ProcessFields(ATab: TADDatSTable; AConstraints: TCheckConstraints;
    AFields: TFields);
  var
    i: Integer;
    oCol: TADDatSColumn;
    oCons: TCheckConstraint;
    oFld: TField;
  begin
    if AConstraints <> nil then
      for i := 0 to AConstraints.Count - 1 do begin
        oCons := AConstraints[i];
        if oCons.ImportedConstraint <> '' then
          FCreatedConstraints.Add(ATab.Constraints.AddChk('', oCons.ImportedConstraint,
            oCons.ErrorMessage, ctAtEditEnd));
        if oCons.CustomConstraint <> '' then
          FCreatedConstraints.Add(ATab.Constraints.AddChk('', oCons.CustomConstraint,
            oCons.ErrorMessage, ctAtEditEnd));
      end;
    if AFields <> nil then
      for i := 0 to AFields.Count - 1 do begin
        oFld := AFields[i];
        if oFld.ImportedConstraint <> '' then
          FCreatedConstraints.Add(ATab.Constraints.AddChk('', oFld.ImportedConstraint,
            oFld.ConstraintErrorMessage, ctAtColumnChange));
        if oFld.CustomConstraint <> '' then
          FCreatedConstraints.Add(ATab.Constraints.AddChk('', oFld.CustomConstraint,
            oFld.ConstraintErrorMessage, ctAtColumnChange));
        if (oFld is TObjectField) and (oFld.DataType in [ftADT, ftArray]) then begin
          oCol := GetFieldColumn(oFld);
          if (oFld.DataType = ftArray) and SparseArrays and (TObjectField(oFld).Fields[0].DataType = ftADT) then
            ProcessFields(oCol.NestedTable, nil, TObjectField(TObjectField(oFld).Fields[0]).Fields)
          else
            ProcessFields(oCol.NestedTable, nil, TObjectField(oFld).Fields);
        end;
      end;
  end;

begin
  ProcessFields(FTable, Constraints, Fields);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ResetTableConstraints;
var
  i: Integer;
begin
  for i := 0 to FCreatedConstraints.Count - 1 do
    ADFree(TADDatSCheckConstraint(FCreatedConstraints[i]));
  FCreatedConstraints.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFieldAttributes(AField: TField; AColumn: TADDatSColumn);
var
  oObjFld: TObjectField;
  oFmt: TADFormatOptions;
begin
  if AField is TObjectField then begin
    oObjFld := TObjectField(AField);
    oObjFld.ObjectType := AColumn.SourceDataTypeName;
    if oObjFld.DataType in [ftADT, ftArray] then begin
      if (oObjFld.DataType = ftArray) and SparseArrays and (oObjFld.Fields[0].DataType = ftADT) then
        SetFieldAttributes(TObjectField(oObjFld.Fields[0]).Fields)
      else
        SetFieldAttributes(oObjFld.Fields);
    end;
  end;
  AField.Origin := AColumn.OriginColName;
  AField.DefaultExpression := AColumn.Expression;
  if AField is TADAutoIncField then
    TADAutoIncField(AField).GeneratorName := AColumn.SourceGenerator;
  AField.ProviderFlags := [];
  if coInUpdate in AColumn.Options then
    AField.ProviderFlags := AField.ProviderFlags + [pfInUpdate];
  if coInWhere in AColumn.Options then
    AField.ProviderFlags := AField.ProviderFlags + [pfInWhere];
{$IFNDEF AnyDAC_FPC}
  if __TField(AField).FAutoGenerateValue = DB.arNone then begin
    if caAutoInc in AColumn.Attributes then
      __TField(AField).FAutoGenerateValue := DB.arAutoInc;
    if ([caCalculated, caDefault, caROWID, caVolatile, caRowVersion, caExpr] * AColumn.Attributes <> []) or
       not (caBase in AColumn.Attributes) then
      __TField(AField).FAutoGenerateValue := DB.arDefault;
  end;
{$ENDIF}
  if coInKey in AColumn.Options then
    AField.ProviderFlags := AField.ProviderFlags + [pfInKey]
  else
    AField.ProviderFlags := AField.ProviderFlags - [pfInKey];
  AField.ReadOnly := UpdateOptions.CheckReadOnly and (coReadOnly in AColumn.Options);
  oFmt := FormatOptions;
  if AField is TDateField then
    TDateField(AField).DisplayFormat := oFmt.FmtDisplayDate
  else if AField is TTimeField then
    TTimeField(AField).DisplayFormat := oFmt.FmtDisplayTime
  else if AField is TDateTimeField then
    TDateTimeField(AField).DisplayFormat := oFmt.FmtDisplayDateTime
{$IFDEF AnyDAC_D6}
  else if AField is TSQLTimeStampField then
    TSQLTimeStampField(AField).DisplayFormat := oFmt.FmtDisplayDateTime
{$ENDIF}
  else if AField is TNumericField then begin
    TNumericField(AField).DisplayFormat := oFmt.FmtDisplayNumeric;
    TNumericField(AField).EditFormat := oFmt.FmtEditNumeric;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFieldAttributes(AFields: TFields);
var
  i: Integer;
  oFld: TField;
  oCol: TADDatSColumn;
begin
  for i := 0 to AFields.Count - 1 do begin
    oFld := AFields[i];
    if oFld.FieldNo >= 1 then begin
      oCol := GetFieldColumn(oFld);
      SetFieldAttributes(oFld, oCol);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFieldAttributes;
begin
  SetFieldAttributes(Fields);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetPersFieldAttributes;
var
  oUpdOpts: TADBottomUpdateOptions;
  i: Integer;
  oFld: TField;
begin
  oUpdOpts := UpdateOptions;
  if oUpdOpts.KeyFields <> '' then begin
    for i := 0 to FieldCount - 1 do begin
      oFld := Fields[i];
      oFld.ProviderFlags := oFld.ProviderFlags - [pfInKey];
    end;
    i := 1;
    while i <= Length(oUpdOpts.KeyFields) do begin
      oFld := InternalFieldByName(ADExtractFieldName(oUpdOpts.KeyFields, i),
                                  'UpdateOptions.KeyFields');
      oFld.ProviderFlags := oFld.ProviderFlags + [pfInKey];
    end;
  end;
{$IFNDEF AnyDAC_FPC}
  if oUpdOpts.AutoIncFields <> '' then begin
    for i := 0 to FieldCount - 1 do begin
      oFld := Fields[i];
      if __TField(oFld).FAutoGenerateValue = DB.arAutoInc then
        __TField(oFld).FAutoGenerateValue := DB.arNone;
    end;
    i := 1;
    while i <= Length(oUpdOpts.AutoIncFields) do begin
      oFld := InternalFieldByName(ADExtractFieldName(oUpdOpts.AutoIncFields, i),
                                  'UpdateOptions.AutoIncFields');
      __TField(oFld).FAutoGenerateValue := DB.arAutoInc;
      oFld.Required := False;
    end;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_FPC}
procedure TADDataSet.SetFieldAutoGenerateValue(AField: TField;
  AValue: TAutoRefreshFlag);
begin
  __TField(AField).FAutoGenerateValue := AValue;
  if AValue = DB.arAutoInc then begin
    AField.ProviderFlags := AField.ProviderFlags - [pfInUpdate] + [pfInWhere, pfInKey];
    AField.Required := False;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetColumnAttributes;
var
  i: Integer;
  oCol: TADDatSColumn;
  oFld: TField;
begin
  if dfColumnAttributesUpdated in FFlags then
    Exit;
  Include(FFlags, dfColumnAttributesUpdated);
  for i := 0 to Fields.Count - 1 do begin
    oFld := Fields[I];
    if oFld.FieldKind = fkData then begin
      oCol := GetFieldColumn(Fields[I]);
      if oFld.DefaultExpression <> '' then
        oCol.Expression := oFld.DefaultExpression;
      if not oFld.Required then
        oCol.Attributes := oCol.Attributes + [caAllowNull];
      if oFld is TADAutoIncField then begin
        oCol.AutoIncrement := TADAutoIncField(oFld).ClientAutoIncrement;
        oCol.ServerAutoIncrement := TADAutoIncField(oFld).ServerAutoIncrement;
        oCol.AutoIncrementSeed := TADAutoIncField(oFld).AutoIncrementSeed;
        oCol.AutoIncrementStep := TADAutoIncField(oFld).AutoIncrementStep;
        oCol.SourceGenerator := TADAutoIncField(oFld).GeneratorName;
      end
{$IFNDEF AnyDAC_FPC}
      else if oFld.AutoGenerateValue = arAutoInc then
        oCol.ServerAutoIncrement := True
{$ENDIF}
      ;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.UpdateAttributes;
begin
  Exclude(FFlags, dfColumnAttributesUpdated);
  SetColumnAttributes;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetInternalCalcs;
var
  oFmtOpts: TADFormatOptions;
  i, j: Integer;
  oCol: TADDatSColumn;
  oFld: TField;
  iDestPrec, iDestScale: Integer;
  iDestSize: LongWord;
  iDestDataType: TADDataType;
  iDestAttrs: TADDataAttributes;
begin
  oFmtOpts := FormatOptions;
  for i := 0 to Fields.Count - 1 do
    if Fields[i].FieldKind = fkInternalCalc then begin
      oFld := Fields[i];
      j := FTable.Columns.IndexOfName(oFld.FieldName);
      if j = -1 then
        oCol := TADDatSColumn.Create
      else
        oCol := FTable.Columns.ItemsI[j];
      oFmtOpts.FieldDef2ColumnDef(oFld, iDestDataType, iDestSize,
        iDestPrec, iDestScale, iDestAttrs);
      iDestAttrs := iDestAttrs + [caAllowNull, caCalculated];
      if not (iDestDataType in C_AD_NonSearchableDataTypes) then
        iDestAttrs := iDestAttrs + [caSearchable];

      oCol.Name := oFld.FieldName;
      oCol.Options := [coAllowNull];
      oCol.Attributes := iDestAttrs;
      oCol.Expression := oFld.DefaultExpression;
      if oFld.DataType = ftAutoInc then
        oCol.AutoIncrement := True;
      oCol.DataType := iDestDataType;
      oCol.Size := iDestSize;
      oCol.Precision := iDestPrec;
      oCol.Scale := iDestScale;

      if j = -1 then
        FTable.Columns.Add(oCol);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetUpdateFieldAttributes;
var
  oUpdOpts: TADBottomUpdateOptions;
begin
  oUpdOpts := UpdateOptions;
  Table.CheckNotNull := oUpdOpts.CheckRequired;
  Table.CheckReadOnly := oUpdOpts.CheckReadOnly;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetSortView(AView: TADDatSView);
var
  i: Integer;
  lRebuildFilter: Boolean;
begin
  if FSortView = AView then
    Exit;
  if Active then
    lRebuildFilter := ResetCursorRange
  else
    lRebuildFilter := False;
  Exclude(FFlags, dfCalcFieldInIndex);
  if FSortView <> nil then
    FSortView.RemRef;
  FSortView := AView;
  if FSortView <> nil then begin
    FSortView.AddRef;
    if State = dsBrowse then
      AllocKeyBuffers;
    if FSortView.SortingMechanism <> nil then
      for i := 0 to FSortView.SortingMechanism.SortColumnList.Count - 1 do
        if caCalculated in FSortView.SortingMechanism.SortColumnList.ItemsI[i].Attributes then begin
          Include(FFlags, dfCalcFieldInIndex);
          Break;
        end;
  end;
  if Active then begin
    if lRebuildFilter then
      CreateFilterView;
    RelinkViews;
    DoSortOrderChanged;
    ResyncViews;
    CheckMasterRange;
  end
  else
    DoSortOrderChanged;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.BuildViewForIndex(AIndex: TADIndex): TADDatSView;
var
  sFieldsOrExpr: String;
  eOptions: TADSortOptions;
begin
  Result := TADDatSView.Create(FTable, AIndex.Name, vcDataSetIndex, True);
  try
    eOptions := AIndex.Options;
    if AIndex.Fields <> '' then begin
      // make options as var parameter for NullLocation option
      sFieldsOrExpr := DoAdjustSortFields(AIndex.Fields, '', eOptions);
      Result.Mechanisms.AddSort(sFieldsOrExpr, AIndex.DescFields,
        AIndex.CaseInsFields, eOptions);
    end
    else if AIndex.Expression <> '' then begin
      sFieldsOrExpr := DoAdjustSortFields('', AIndex.Expression, eOptions);
      Result.Mechanisms.AddSort(sFieldsOrExpr, eOptions);
    end;
    if AIndex.Distinct then
      Result.Mechanisms.AddDistinct(-1);
    if AIndex.Filter <> '' then
      Result.Mechanisms.AddFilter(AIndex.Filter, AIndex.FilterOptions);
    Result.Active := AIndex.Active;
  except
    ADFree(Result);
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckFetchedAllBeforeSorting;
begin
  if FClientCursor and
     ((dfDataSetOpened in FFlags) and not (dfDataSetOpening in FFlags) and
     DoIsSourceOpen and (FTable <> nil)) and
     ((MasterSource = nil) or not (fiDetails in FetchOptions.Cache)) and
     (FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax]) then
    CheckFetchedAll;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SwitchToIndex(const AFieldNames, AIndexName: String);
var
  oView: TADDatSView;
  sFields: String;
  eOptions: TADSortOptions;
begin
  if Active then
    CheckBrowseMode;
  if (AFieldNames <> '') or (AIndexName <> '') then
    CheckFetchedAllBeforeSorting;
  if AFieldNames <> '' then begin
    oView := FTable.Views.FindSortedView(AFieldNames, [], [soNoCase, soDescending]);
    if oView = nil then begin
      oView := TADDatSView.Create(FTable, C_AD_SysNamePrefix + 'IND_' + AFieldNames,
        vcDataSetTempIndex, True);
      try
        eOptions := FormatOptions.SortOptions;
        sFields := DoAdjustSortFields(AFieldNames, '', eOptions);
        oView.Mechanisms.AddSort(sFields, '', '', eOptions);
        oView.Active := True;
      except
        ADFree(oView);
        raise;
      end;
      FTempIndexViews.Add(oView);
    end;
    SetSortView(oView);
  end
  else if AIndexName <> '' then begin
    oView := FTable.Views.ViewByName(AIndexName);
    if oView.SortingMechanism = nil then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSViewNotSorted, [AIndexName]);
    SetSortView(oView);
  end
  else
    SetSortView(nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.OpenIndexes;
var
  i: Integer;
begin
  if IndexDefs.Count > 0 then begin
    Include(FFlags, dfPreserveCurrentIndex);
    try
      Indexes.Clear;
      for i := 0 to IndexDefs.Count - 1 do
        Indexes.Add.Assign(IndexDefs[i]);
    finally
      Exclude(FFlags, dfPreserveCurrentIndex);
    end;
  end
  else begin
    IndexDefs.Updated := False;
    IndexDefs.Update;
  end;
  Indexes.Build;
  IndexDefs.Updated := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ResetIndexes;
var
  i: Integer;
begin
  if dfClearIndexDefs in FFlags then begin
    IndexDefs.Clear;
    Exclude(FFlags, dfClearIndexDefs);
  end
  else begin
    Include(FFlags, dfPreserveCurrentIndex);
    try
      Indexes.Clear;
    finally
      Exclude(FFlags, dfPreserveCurrentIndex);
    end;
  end;
  Indexes.Release;
  for i := 0 to FTempIndexViews.Count - 1 do
    TADDatSView(FTempIndexViews[i]).RemRef;
  FTempIndexViews.Clear;
  IndexDefs.Updated := dfClearIndexDefs in FFlags;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.UpdateIndexDefs;
var
  i: Integer;
begin
  if (csDesigning in ComponentState) and (IndexDefs.Count > 0) then
    Exit;
  if not IndexDefs.Updated then begin
    IndexDefs.Clear;
    for i := 0 to Indexes.Count - 1 do
      IndexDefs.AddIndexDef.Assign(Indexes[i]);
    IndexDefs.Updated := True;
    Include(FFlags, dfClearIndexDefs);
  end;
end;

{-------------------------------------------------------------------------------}
{ Open / close }

procedure TADDataSet.DoPrepareSource;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoUnprepareSource;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoDefineDatSManager;
begin
  if (Fields.Count > 0) or (FieldDefs.Count > 0) then
    InitTable(FStorage = nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoOpenSource(ABlocked, AInfoQuery, AStructQuery: Boolean);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoIsSourceOpen: Boolean;
begin
  Result := False;
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoIsSourceAsync: Boolean;
begin
  Result := GetResourceOptions.CmdExecMode = amAsync;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoIsSourceOnline: Boolean;
begin
  Result := True;
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoCloseSource;
begin
  if not DefaultFields and (ParentDataSet = nil) then begin
    FieldDefs.Clear;
    FieldDefs.Updated := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoResetDatSManager;
begin
  FAggregates.Release;
  FFieldAggregates.Release;
  FIndexes.Release;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoExecuteSource(ATimes, AOffset: Integer);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoClearBeforeRefetch;
begin
  ClearBuffers;
  if FTable <> nil then
    FTable.Clear;
  FSourceEOF := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoCreateFields;
begin
  if DefaultFields then
    CreateFields;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeExecute;
begin
  if Assigned(FBeforeExecute) then
    FBeforeExecute(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterExecute;
begin
  if Assigned(FAfterExecute) then
    FAfterExecute(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.OpenCursor(InfoQuery: Boolean);
begin
  StartWait;
  try
{$IFNDEF AnyDAC_FPC}
    if Designer <> nil then
      DoResetDatSManager;
{$ENDIF}
    FFlags := FFlags - [dfColumnAttributesUpdated, dfDataSetOpened,
      dfDataSetOpening, dfUnidirectional];
    if FetchOptions.Unidirectional then
      Include(FFlags, dfUnidirectional);
    FSourceEOF := False;
    FUnidirRecsPurged := 0;
    FRecordCount := -1;
    FLastSavePoint := 0;
    FLastColumn := nil;
    FLastField := nil;
    if DataSetField = nil then begin
      DoMasterDefined;
      if LoadFromFileAtOpen then begin
        FStorage := ADStorageManager().GetStorage(
          ResourceOptions.PersistentFileName, ResourceOptions.DefaultStoreFormat,
          ResourceOptions, FEncoder);
        try
          FStorage.Open(ResourceOptions.PersistentFileName, nil, smRead);
          InternalLoadFromStorage;
        finally
          ADFreeAndNil(FStorage);
        end;
      end
      else if FStorage <> nil then
        InternalLoadFromStorage
      else begin
        if IsLinked then
          DoMasterParamSetValues(FMasterLink.Fields);
        DoPrepareSource;
        if not DoIsSourceAsync or InfoQuery then begin
          CheckTable;
          if not DefaultFields then
            SetInternalCalcs;
        end;
      end;
    end
    else begin
      FParentDataSet := DataSetField.DataSet as TADDataSet;
{$IFNDEF AnyDAC_FPC}
      OpenParentDataSet(FParentDataSet);
{$ENDIF}
      if FieldDefs.HiddenFields <> FParentDataSet.FieldDefs.HiddenFields then
        FieldDefs.HiddenFields := FParentDataSet.FieldDefs.HiddenFields;
      AttachTable(FParentDataSet.GetFieldColumn(DataSetField).NestedTable, nil);
    end;
    if (DataSetField = nil) and InfoQuery then begin
      DoOpenSource(True, InfoQuery, True);
      inherited OpenCursor(InfoQuery);
    end
    else if (DataSetField = nil) and DoIsSourceAsync then begin
      DoOpenSource(False, InfoQuery, True);
      SetState(dsOpening);
    end
    else begin
      inherited OpenCursor(InfoQuery);
      if (DataSetField = nil) and (NestedDataSets <> nil) and (NestedDataSets.Count > 0) then
        DataEvent(deDataSetChange, 0);
    end;
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsLinkedNested: Boolean;
begin
  Result := (FParentDataSet <> nil);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsLinkedDetail: Boolean;
begin
  Result := FMasterLink.Active and
    ((FMasterLink.Fields.Count > 0) and
     (not (State in [dsInactive, dsOpening]) and (IndexFieldCount > 0) or
      (State in [dsInactive, dsOpening]) and ((IndexFieldNames <> '') or (LocalIndexName <> '')) or
      DoMasterParamDependent(FMasterLink.Fields)) or
     Assigned(OnMasterSetValues));
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsLinked: Boolean;
begin
  Result := IsLinkedNested or IsLinkedDetail;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalOpen;
var
  lDeferOpen, lLoadedFromStorage: Boolean;
begin
  FFlags := FFlags + [dfDataSetOpened, dfDataSetOpening];
  CheckTable;
  lLoadedFromStorage := LoadFromFileAtOpen or (FStorage <> nil);
  lDeferOpen := IsLinked and (Table.Columns.Count > 0);
  if not DefaultFields then
    if not lLoadedFromStorage then
      SetInternalCalcs
    else
      { TODO -cDATASET : Here must be checked, that fields matches to DatS table columns };
  if (FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax]) and
     (State <> dsOpening) and not lDeferOpen and not FSourceEOF then
    DoOpenSource(True, False, True);
  OpenIndexes;
  if (FIndexFieldNames <> '') or (FIndexName <> '') then begin
    DoSortOrderChanging;
    SwitchToIndex(FIndexFieldNames, FLocalIndexName);
  end;
  CreateFilterView;
  RelinkViews;
  FRecordIndex := -1;
  FPrevRecordIndex := -1;
  if not FieldDefs.Updated then
    FieldDefs.Update
  else if not RenewColumnMap then begin
    FieldDefs.Updated := False;
    FieldDefs.Update;
  end;
  DoCreateFields;
  BindFields(True);
  SetViewAggregates;
  SetTableConstraints;
  if DefaultFields then
    SetFieldAttributes
  else if not lLoadedFromStorage then begin
    SetPersFieldAttributes;
    SetColumnAttributes;
  end;
  SetUpdateFieldAttributes;
  if FTable.MetadataCallback = nil then
    FTable.MetadataCallback := TADDatSTableMetadataCallback.Create(Self);
  InitBufferPointers;
  if FSortView <> nil then
    AllocKeyBuffers;
  FTable.Constraints.Enforce := (FConstDisableCount = 0);
  FTable.UpdateLayout;
  if (FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax]) and
     (State <> dsOpening) and lDeferOpen then
    MasterChanged(Self);
  if Assigned(OnFilterRecord) and Filtered and (FFilterView <> nil) then
    FFilterView.Rebuild;
  Exclude(FFlags, dfDataSetOpening);
  if FSortView <> nil then
    CheckFetchedAllBeforeSorting;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterOpen;
var
  i: Integer;
begin
  if FetchOptions.RecordCountMode = cmTotal then
    GetRecordCount;
  for i := 0 to FEventListeners.Count - 1 do
    IADDataSetListener(FEventListeners[i]).ResultsetActivated(Self);
  inherited DoAfterOpen;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckAsyncOpenComplete;
begin
  if DoIsSourceAsync then
    try
      // Perform first fetch in background. This is at first required for the case
      // if FetchOptions.Mode = fmAll, then fetch all records in background.
      CheckTable;
      InternalFetchRows(False, True);
      TADThread.Synchronize(OpenCursorComplete);
    except
      CheckAsyncOpenFailed;
      raise;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckAsyncOpenFailed;
begin
  if DoIsSourceAsync then begin
    SetState(dsInactive);
    CloseCursor;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalClose;
begin
  if not (dfDataSetOpened in FFlags) then begin
    DoCloseSource;
    Exit;
  end;
  FFlags := FFlags - [dfDataSetOpened, dfDataSetOpening];
  if FDataLoadSave <> nil then
    EndBatch;
  if FTable <> nil then begin
    if (FTable.MetadataCallback <> nil) and (FTable.MetadataCallback.GetOwner = Self) then
      FTable.MetadataCallback := nil;
    FTable.RemoveDataCallback(Self, True);
  end;
  if IsForceRowMode then
    EndForceRow;
  ResetMasterRelation;
  ResetTableConstraints;
  ResetCursorRange;
  FreeKeyBuffers;
  FRecordCount := -1;
  BindFields(False);
  if DefaultFields then
    DestroyFields;
  ResetViewAggregates;
  ResetIndexes;
  ResetViews;
  FCloneSource := nil;
  FRecordIndex := -1;
  FPrevRecordIndex := -1;
  FSourceEOF := True;
  FUnidirRecsPurged := 0;
  FLastParentRow := nil;
  if FLocateRow <> nil then begin
    ADFreeAndNil(FLocateRow);
    ADFreeAndNil(FLocateColumns);
  end;
  if FParentDataSet = nil then
    DoCloseSource;
  if SaveToFileAtClose then begin
    FStorage := ADStorageManager().GetStorage(
      ResourceOptions.PersistentFileName, ResourceOptions.DefaultStoreFormat,
      ResourceOptions, FEncoder);
    try
      FStorage.Open(ResourceOptions.PersistentFileName, nil, smWrite);
      InternalSaveToStorage;
    finally
      ADFreeAndNil(FStorage);
    end;
  end;
{$IFNDEF AnyDAC_FPC}
  if Designer = nil then
{$ENDIF}
    DoResetDatSManager;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsCursorOpen: Boolean;
begin
  Result := (FSourceView <> nil) and FSourceView.ActualActive;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.Execute(ATimes: Integer = 0; AOffset: Integer = 0);
begin
  CheckInactive;
  StartWait;
  try
    DoBeforeExecute;
    if DoMasterParamDependent(FMasterLink.Fields) then
      DoMasterParamSetValues(FMasterLink.Fields);
    DoPrepareSource;
    DoExecuteSource(ATimes, AOffset);
    if not DoIsSourceAsync then
      DoAfterExecute;
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.OpenOrExecute: Boolean;
begin
  try
    Open;
  except
    on E: EADException do
      if E.ADCode <> er_AD_AccCmdMHRowSet then
        raise;
  end;
  Result := Active;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckAsyncExecFinished;
begin
  if DoIsSourceAsync then
    TADThread.Synchronize(DoAfterExecute);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.Disconnect(AAbortJob: Boolean = False);
begin
  if not (dfOfflining in FFlags) then begin
    Active := False;
    if FSourceView <> nil then
      InternalClose
    else if Table <> nil then
      DoResetDatSManager;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ReleaseBase(AOffline: Boolean);
begin
  if dfOfflining in FFlags then
    Exit;
  Include(FFlags, dfOfflining);
  try
    if Active and not SourceEOF and DoIsSourceOpen and not (dfUnidirectional in FFlags) then
      case FetchOptions.AutoFetchAll of
      afAll:      CheckFetchedAll;
      afTruncate: FSourceEOF := True;
      afDisable:  ADException(Self, [S_AD_LComp, S_AD_LComp_PDS],
                              er_AD_DSCantOffline, [GetDisplayName]);
      end;
    if AOffline then
      DoUnprepareSource
    else
      DoCloseSource;
  finally
    Exclude(FFlags, dfOfflining);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.Offline;
begin
  ReleaseBase(True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.Release;
begin
  ReleaseBase(False);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckOnline(APrepare: Boolean = True);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
{ Field defs }

procedure TADDataSet.ClearFColumns;
var
  i: Integer;
begin
  for i := 0 to Length(FColumns) - 1 do
    TADColMapItem(FColumns[i]).Free;
  SetLength(FColumns, 0);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.AddFieldDesc(AFmtOpts: TADFormatOptions; ADefs: TFieldDefs;
  AColumn: TADDatSColumn; var AFieldId: Integer; APath: TADPtrList): TFieldDef;
var
  i: Integer;
  iSize: LongWord;
  iPrecision, iScale: Integer;
  eType: TFieldType;
  sName: String;
  oChildTab: TADDatSTable;
  oColMapItem: TADColMapItem;
begin
  sName := AColumn.Name;
  i := 0;
  while ADefs.IndexOf(sName) >= 0 do begin
    Inc(i);
    sName := Format('%s_%d', [AColumn.Name, i]);
  end;
  AFmtOpts.ColumnDef2FieldDef(AColumn.DataType, AColumn.Size, AColumn.Precision,
    AColumn.Scale, AColumn.Attributes, eType, iSize, iPrecision, iScale);
  if AColumn.DataType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef] then begin
    oChildTab := AColumn.NestedTable;
    if AColumn.DataType in [dtRowRef, dtArrayRef] then begin
      iSize := 0;
      for i := 0 to oChildTab.Columns.Count - 1 do
        if not (caInternal in oChildTab.Columns.ItemsI[i].Attributes) then
          Inc(iSize);
    end;
  end
  else begin
    oChildTab := nil;
    if (eType in [ftBCD {$IFDEF AnyDAC_D6}, ftFMTBcd {$ENDIF}]) and
       (iSize = 0) and (iScale > 0) then
      iSize := iScale;
  end;
  // Without that code DataSnap converts ftMemo to ftString and writing
  // a MEMO with size more than 8K will fail.
  if AFmtOpts.DataSnapCompatibility and
     (eType in [ftBlob, ftGraphic, ftTypedBinary, ftMemo, ftFmtMemo, ftDBaseOle,
                ftOraBlob, ftOraClob {$IFDEF AnyDAC_WideMemo}, ftWideMemo {$ENDIF}]) then
    iSize := 0;

  Result := TFieldDef.Create(ADefs, sName, eType, iSize, False, AFieldId);
  Result.Precision := iPrecision;
  Result.InternalCalcField := (caCalculated in AColumn.Attributes) and (AColumn.SourceID <= 0);
  Result.Attributes := [];
  if not AColumn.AllowDBNull then begin
    Result.Attributes := Result.Attributes + [DB.faRequired];
{$IFDEF AnyDAC_FPC}
    Result.Required := True;
{$ENDIF}
  end;
  if AColumn.ReadOnly and UpdateOptions.CheckReadOnly then
    Result.Attributes := Result.Attributes + [DB.faReadOnly];
  if caInternal in AColumn.Attributes then
    Result.Attributes := Result.Attributes + [DB.faHiddenCol];
  if caUnnamed in AColumn.Attributes then
    Result.Attributes := Result.Attributes + [DB.faUnnamed];
  if caFixedLen in AColumn.Attributes then
    Result.Attributes := Result.Attributes + [DB.faFixed];

  oColMapItem := TADColMapItem.Create;
  oColMapItem.FColumn := AColumn;
  oColMapItem.FColumnIndex := AColumn.Index;
  SetLength(oColMapItem.FPath, APath.Count);
  for i := 0 to APath.Count - 1 do
    oColMapItem.FPath[i] := Integer(APath[i]);

  FColumns[AFieldID - 1] := oColMapItem;
  Inc(AFieldID);
{$IFNDEF AnyDAC_FPC}
  if (oChildTab <> nil) and not (AColumn.DataType in [dtRowSetRef, dtCursorRef]) then begin
    APath.Add(Pointer(AColumn.Index));
    try
      AddTableDesc(AFmtOpts, Result.ChildDefs, oChildTab, AFieldID, APath);
    finally
      APath.Delete(APath.Count - 1);
    end;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.AddTableDesc(AFmtOpts: TADFormatOptions; ADefs: TFieldDefs;
  ATable: TADDatSTable; var AFieldId: Integer; APath: TADPtrList);
var
  i: Integer;
  oCol: TADDatSColumn;
  oPrevCbk: IADDatSTableMetadataCallback;
begin
  // If do not clear callback here, then opened DataSet will give AV
  // on DataSet.FieldDefs.Update call. Because TADDatSTableCallback.DescribeColumn
  // calls TADDataSet.GetColumnField, and there items in FColumns are nil's.
  oPrevCbk := ATable.MetadataCallback;
  ATable.MetadataCallback := nil;
  try
    SetLength(FColumns, Length(FColumns) + ATable.Columns.Count);
    for i := 0 to ATable.Columns.Count - 1 do begin
      oCol := ATable.Columns.ItemsI[i];
      if not (caInternal in oCol.Attributes) then
        AddFieldDesc(AFmtOpts, ADefs, oCol, AFieldId, APath);
    end;
  finally
    ATable.MetadataCallback := oPrevCbk;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalInitFieldDefs;
var
  iFldId: Integer;
  oPath: TADPtrList;
begin
  iFldId := 1;
  ClearFColumns;
  FieldDefs.Clear;
  if FTable <> nil then begin
    oPath := TADPtrList.Create;
    try
      AddTableDesc(FormatOptions, FieldDefs, FTable, iFldId, oPath);
      if iFldId - 1 < Length(FColumns) then
        SetLength(FColumns, iFldId - 1);
    finally
      ADFree(oPath);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.RenewFieldDesc(AColumn: TADDatSColumn; var AFieldId: Integer): Boolean;
var
  oChildTab: TADDatSTable;
begin
  Result := (AFieldID - 1 < Length(FColumns)) and
            (FColumns[AFieldID - 1].FColumnIndex = AColumn.Index);
  if Result then begin
    FColumns[AFieldID - 1].FColumn := AColumn;
    Inc(AFieldID);
    if AColumn.DataType in [dtRowRef, dtArrayRef] then begin
      oChildTab := AColumn.NestedTable;
      if oChildTab <> nil then
        Result := RenewTableDesc(oChildTab, AFieldID);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.RenewTableDesc(ATable: TADDatSTable; var AFieldId: Integer): Boolean;
var
  i: Integer;
  oCol: TADDatSColumn;
begin
  Result := True;
  for i := 0 to ATable.Columns.Count - 1 do begin
    oCol := ATable.Columns.ItemsI[i];
    if not (caInternal in oCol.Attributes) then
      if not RenewFieldDesc(oCol, AFieldId) then begin
        Result := False;
        Exit;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.RenewColumnMap: Boolean;
var
  iFldId: Integer;
begin
  iFldId := 1;
  Result := RenewTableDesc(FTable, iFldId);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFieldClass(FieldType: TFieldType): TFieldClass;
begin
  case FieldType of
{$IFDEF AnyDAC_WideMemo}
  ftWideMemo,
{$ENDIF}
  ftFmtMemo:
    Result := TADWideMemoField;
  ftDBaseOle:
    Result := TADXMLField;
  ftAutoInc:
    Result := TADAutoIncField;
{$IFDEF AnyDAC_D10}
  ftOraInterval,
{$ENDIF}
  ftParadoxOle:
    Result := TADSQLTimeIntervalField;
  else
    Result := inherited GetFieldClass(FieldType);
  end;
end;

{-------------------------------------------------------------------------------}
{ Record Functions }

function TADDataSet.CalcBookmarkSize: LongWord;
begin
  Result := SizeOf(TADBookmarkData);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InitBufferPointers;
begin
  BookmarkSize := CalcBookmarkSize;
  FBufferSize := Word(CalcFieldsSize + SizeOf(TADRecInfo));
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRecordSize: Word;
begin
  ASSERT(FTable.Columns.DataOffsets[FTable.Columns.Count] <= $FFFF);
  Result := Word(FTable.Columns.DataOffsets[FTable.Columns.Count]);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.AllocRecBuf: PADBuffer;
begin
  Result := PADBuffer(AllocRecordBuffer);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FreeRecBuf(var Buffer: PADBuffer);
begin
  FreeRecordBuffer(PADRawBuffer(Buffer));
end;

{-------------------------------------------------------------------------------}
function TADDataSet.AllocRecordBuffer: PADRawBuffer;
begin
  Result := AllocMem(FBufferSize);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FreeRecordBuffer(var Buffer: PADRawBuffer);
begin
  FreeMem(Buffer);
  Buffer := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ClearCalcFields(Buffer: PADBuffer);
{$IFNDEF AnyDAC_FPC}
  {$IFNDEF AnyDAC_D10}
var
  i: Integer;
  oFld: TField;
  {$ENDIF}
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  {$IFNDEF AnyDAC_D10}
  for i := 0 to FieldCount - 1 do begin
    oFld := Fields[i];
    if (oFld.FieldKind in [fkCalculated, fkLookup]) and (oFld.DataType = ftWideString) then
      PWideString(Buffer + oFld.Offset + 1)^ := '';
  end;
  {$ENDIF}
{$ENDIF}
  ADFillChar(PADRawBuffer(Buffer)^, CalcFieldsSize, 0);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRecInfo(ABuffer: PADBuffer): PADRecInfo;
begin
{$IFDEF AnyDAC_D17}
  Result := PADRecInfo(PADRawBuffer(ABuffer) + CalcFieldsSize);
{$ELSE}
  Result := PADRecInfo(ABuffer + CalcFieldsSize);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRow(ABuffer: PADBuffer = C_NIL;
  AForceBufferRead: Boolean = False): TADDatSRow;
var
  pInfo: PADRecInfo;
begin
  if ABuffer = C_NIL then begin
    if FForceRecBuffer <> C_NIL then
      ABuffer := FForceRecBuffer
    else if not Active or IsEmpty then begin
      Result := nil;
      Exit;
    end
    else
      ABuffer := ActiveBuffer;
  end;
  pInfo := GetRecInfo(ABuffer);
  if (pInfo^.FBookmarkFlag in [bfBOF, bfEOF, bfInserted]) and
     not AForceBufferRead and (ABuffer <> FForceRecBuffer) and
     (FNewRow <> nil) then
    Result := FNewRow
  else
    Result := pInfo^.FRow;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetParentRow: TADDatSRow;
begin
  if FParentDataSet = nil then
    Result := nil
  else if (FParentDataSet.State <> dsInsert) and (FParentDataSet.FSourceView <> nil) and
          (FParentDataSet.FSourceView.Rows.Count > 0) then
    if FParentDataSet.Active then
      Result := FParentDataSet.GetRow
    else
      Result := FParentDataSet.FSourceView.Rows[0]
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.RowState2UpdateStatus(ARowState: TADDatSRowState): TUpdateStatus;
const
  rs2us: array [TADDatSRowState] of TUpdateStatus = (usUnmodified, usUnmodified,
    usInserted, usDeleted, usModified, usUnmodified, usUnmodified, usUnmodified,
    usUnmodified, usUnmodified, usUnmodified, usUnmodified, usUnmodified,
    usUnmodified);
begin
  Result := rs2us[ARowState];
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRecord(Buffer: PADBuffer; GetMode: TGetMode;
  DoCheck: Boolean): TGetResult;
var
  pInfo: PADRecInfo;
begin
  Result := grOK;
  case GetMode of
  gmCurrent:
    begin
      while (FSourceView <> nil) and
            (FRecordIndex >= FSourceView.Rows.Count) and
            InternalFetchRows(False, True) do
        ;
      if FSourceView = nil then begin
        Result := grError;
        Exit;
      end;
    end;
  gmNext:
    begin
      while (FSourceView <> nil) and
            ((FRecordIndex + 1) >= FSourceView.Rows.Count) and
            InternalFetchRows(False, True) do
        ;
      if FSourceView = nil then begin
        Result := grError;
        Exit;
      end;
      if (FRecordIndex + 1) >= FSourceView.Rows.Count then
        FRecordIndex := FSourceView.Rows.Count
      else
        Inc(FRecordIndex);
    end;
  gmPrior:
    begin
      while (FSourceView <> nil) and
            ((FRecordIndex - 1) < 0) and
            InternalFetchRows(False, True, fdUp) do
        ;
      if FSourceView = nil then begin
        Result := grError;
        Exit;
      end;
      if FRecordIndex >= 0 then
        Dec(FRecordIndex);
    end;
  end;
  if FRecordIndex >= FSourceView.Rows.Count then
    Result := grEOF
  else if FRecordIndex < 0 then
    Result := grBOF
  else if Buffer <> C_NIL then begin
    pInfo := GetRecInfo(Buffer);
    pInfo^.FRow := FSourceView.Rows.ItemsI[FRecordIndex];
    pInfo^.FRowIndex := FRecordIndex;
    pInfo^.FBookmarkFlag := bfCurrent;
    GetCalcFields(Buffer);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetActiveRecBufRecordIndex(var AIndex: Integer): Boolean;
var
  pRecBuf: PADBuffer;
begin
  Result := GetActiveRecBuf(pRecBuf) and (GetBookmarkFlag(pRecBuf) = bfCurrent);
  if Result then
    AIndex := GetRowIndex(pRecBuf)
  else
    AIndex := -1;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetCurrentRecord(Buffer: PADBuffer): Boolean;
begin
  if not IsEmpty and (GetBookmarkFlag(ActiveBuffer) = bfCurrent) then begin
    UpdateCursorPos;
    try
      GetRecInfo(Buffer)^.FRow := FSourceView.Rows.ItemsI[FRecordIndex];
      Result := True;
    except
      Result := False;
    end;
  end
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRecordCount: Integer;

  procedure UpdateParentCursorPos;
  begin
    if (FParentDataSet <> nil) and (FParentDataSet.State <> dsInsert) then
      FParentDataSet.UpdateCursorPos;
  end;

begin
  Result := 0;
  if not (State in [dsInactive, dsOpening]) then
    case FetchOptions.RecordCountMode of
    cmVisible:
      begin
        UpdateParentCursorPos;
        Result := FSourceView.Rows.Count;
      end;
    cmFetched:
      begin
        UpdateParentCursorPos;
        Result := FUnidirRecsPurged + FTable.Rows.Count;
      end;
    cmTotal:
      begin
        if FRecordCount = -1 then begin
          UpdateParentCursorPos;
          if (FParentDataSet <> nil) and (FTable.Manager <> nil) or
             (FRangeFrom <> nil) or (FRangeTo <> nil) or
             Filtered and ((Filter <> '') or Assigned(OnFilterRecord)) or
             not (rtUnmodified in FFilterChanges) then begin
            CheckFetchedAll;
            FRecordCount := FSourceView.Rows.Count;
          end
          else
            UpdateRecordCount;
        end;
        Result := FRecordCount;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.UpdateRecordCount;
begin
  CheckFetchedAll;
  FRecordCount := FSourceView.Rows.Count;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRowIndex(ABuffer: PADBuffer = C_NIL): Integer;
begin
  if ABuffer = C_NIL then
    if not Active or IsEmpty then
      // none
    else if State = dsCalcFields then
      ABuffer := CalcBuffer
    else
      ABuffer := ActiveBuffer;
  if ABuffer = C_NIL then
    Result := -1
  else
    Result := GetRecInfo(ABuffer)^.FRowIndex;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRecNo: Integer;
begin
  if State = dsInsert then
    if GetBookmarkFlag(ActiveBuffer) = bfEOF then
      Result := FSourceView.Rows.Count
    else
      Result := FRecordIndexToInsert
  else
    Result := GetRowIndex();
  Inc(Result, FUnidirRecsPurged + 1);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalSetRecNo(AValue: Integer);
begin
  Dec(AValue, FUnidirRecsPurged + 1);
  if AValue < 0 then
    FRecordIndex := 0
  else begin
    while (AValue >= FSourceView.Rows.Count) and
          InternalFetchRows(False, True) do
      ;
    if AValue >= FSourceView.Rows.Count then
      FRecordIndex := FSourceView.Rows.Count - 1
    else
      FRecordIndex := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetRecNo(AValue: Integer);
begin
  CheckBrowseMode;
  if (AValue <> RecNo) or (dfNoRecNoCmp in FFlags) then begin
    DoBeforeScroll;
    InternalSetRecNo(AValue);
    Resync([rmCenter]);
    DoAfterScroll;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetActiveRecBuf(var RecBuf: PADBuffer): Boolean;
begin
  if FForceRecBuffer <> C_NIL then
    RecBuf := FForceRecBuffer
  else if State = dsBrowse then
    if IsEmpty then
      RecBuf := C_NIL
    else
      RecBuf := ActiveBuffer
  else
    case State of
      dsBlockRead, dsNewValue, dsOldValue, dsCurValue:
        if IsEmpty then
          RecBuf := C_NIL
        else
          RecBuf := ActiveBuffer;
      dsEdit, dsInsert:
        RecBuf := ActiveBuffer;
      dsSetKey:
        RecBuf := FKeyBuffer^.FRecBuff;
      dsCalcFields:
        RecBuf := CalcBuffer;
      dsFilter:
        RecBuf := TempBuffer;
    else
      RecBuf := C_NIL;
    end;
  Result := RecBuf <> C_NIL;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.BeginForceRow(ARow: TADDatSRow; AReadWrite, AWithCalcFields: Boolean);
var
  pInfo: PADRecInfo;
begin
  FForceRecBuffer := AllocRecBuf;
  pInfo := GetRecInfo(FForceRecBuffer);
  pInfo^.FRow := ARow;
  pInfo^.FRowIndex := -1;
  pInfo^.FBookmarkFlag := bfBOF;
  if AReadWrite then
    ARow.BeginForceWrite;
  if AWithCalcFields then
    GetCalcFields(FForceRecBuffer);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EndForceRow;
var
  pInfo: PADRecInfo;
begin
  pInfo := GetRecInfo(FForceRecBuffer);
  if pInfo^.FRow.RowState = rsForceWrite then
    pInfo^.FRow.EndForceWrite;
  FreeRecBuf(FForceRecBuffer);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsForceRowMode: Boolean;
begin
  Result := FForceRecBuffer <> C_NIL;
end;

{-------------------------------------------------------------------------------}
{ Field get / set data }

function TADDataSet.GetRowVersion: TADDatSRowVersion;
begin
  if State = dsNewValue then
    Result := rvProposed
  else if State = dsOldValue then
    Result := rvOriginal
  else
    Result := rvDefault;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFieldColumn(ARecBuff: PADBuffer; AFieldNo: Integer;
  var AColumn: TADDatSColumn; var AColumnIndex: Integer;
  var ARow: TADDatSRow; AInitNested: Boolean): Boolean;
var
  oColMap: TADColMapItem;
  i: Integer;
  prevRow: TADDatSRow;
begin
  oColMap := TADColMapItem(FColumns[AFieldNo - 1]);
  if oColMap = nil then
    Result := False
  else begin
    ARow := GetRow(ARecBuff);
    AColumn := oColMap.FColumn;
    AColumnIndex := oColMap.FColumnIndex;
    prevRow := nil;
    if oColMap.FPath <> nil then
      for i := 0 to Length(oColMap.FPath) - 1 do begin
        if ARow = nil then
          if AInitNested and (prevRow <> nil) then begin
            ARow := AColumn.Table.NewRow(True);
            ARow.ParentRow := prevRow;
          end
          else
            Break;
        prevRow := ARow;
        ARow := ARow.NestedRow[oColMap.FPath[i]];
      end;
    Result := True;
    if ARow = nil then
      if AInitNested and (prevRow <> nil) then begin
        ARow := AColumn.Table.NewRow(True);
        ARow.ParentRow := prevRow;
      end
      else
        Result := False;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFieldColumn(AField: TField): TADDatSColumn;
var
  iFieldNo: Integer;
begin
  if FLastField = AField then begin
    Result := FLastColumn;
    Exit;
  end;
  iFieldNo := AField.FieldNo;
  if iFieldNo = 0 then
{$IFNDEF AnyDAC_FPC}
    iFieldNo := FieldDefList.FieldByName(AField.FieldName).FieldNo;
{$ELSE}
    iFieldNo := TFieldDef(FieldDefs.Find(AField.FieldName)).FieldNo;
{$ENDIF}
  Result := TADColMapItem(FColumns[iFieldNo - 1]).FColumn;
  FLastColumn := Result;
  FLastField := AField;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetColumnField(AColumn: TADDatSColumn): TField;
var
  i: Integer;
begin
  if FLastColumn = AColumn then begin
    Result := FLastField;
    Exit;
  end;
  Result := nil;
  for i := 0 to Length(FColumns) - 1 do
    if TADColMapItem(FColumns[i]).FColumn = AColumn then begin
      if (i < Fields.Count) and (Fields[i].FieldNo = i + 1) then
        Result := Fields[i]
      else
        Result := Fields.FieldByNumber(i + 1);
      Break;
    end;
  FLastColumn := AColumn;
  FLastField := Result;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFieldData(AFieldNo: Integer;
  {$IFDEF AnyDAC_D18} var {$ENDIF} ABuffer: PADValue): Boolean;
var
  pRecBuf: PADBuffer;
  oColumn: TADDatSColumn;
  iColIndex: Integer;
  oRow: TADDatSRow;
  pData: Pointer;
  iDataLen: LongWord;
  oRows: TADDatSNestedRowList;
{$IFNDEF AnyDAC_D6}
  E: Extended;
{$ENDIF}

  function AdjustSize(ADataLen: Integer; AFieldNo: Integer): Integer;
  var
    oFld: TField;
  begin
    Result := ADataLen;
    if not DefaultFields then begin
      oFld := FieldByNumber(AFieldNo);
      if (oFld <> nil) and (ADataLen > oFld.Size) then
        Result := oFld.Size;
    end;
  end;

  procedure ProcessGUID(ApGUID: PGUID; ABuffer: Pointer);
  var
    s: {$IFDEF NEXTGEN} String {$ELSE} AnsiString {$ENDIF} ;
  begin
  {$IFDEF NEXTGEN}
    s := GUIDToString(ApGUID^);
    FEncoder.Encode(PChar(s), Length(s), ABuffer,
      {$IFDEF ANYDAC_Unicode} ecUTF16 {$ELSE} ecANSI {$ENDIF}, ecANSI);
  {$ELSE}
    s := AnsiString(GUIDToString(ApGUID^));
    {$IFDEF AnyDAC_D18} System.AnsiStrings. {$ENDIF}
      StrCopy(PAnsiChar(ABuffer), PAnsiChar(s));
  {$ENDIF}
  end;

  function ProcessAnsiString(AData: Pointer; ADataLen: Integer; ABuffer: Pointer): Boolean;
  begin
    if (caFixedLen in oColumn.Attributes) and (ADataLen > 0) and
       (PADAnsiString(AData)[ADataLen - 1] = TADAnsiChar(' ')) and FormatOptions.StrsTrim then
      repeat
        Dec(ADataLen);
      until (ADataLen = 0) or (PADAnsiString(AData)[ADataLen - 1] <> TADAnsiChar(' '));
    if (ADataLen = 0) and FormatOptions.StrsEmpty2Null then
      Result := False
    else begin
      Result := True;
      Move(PADAnsiString(AData)^, PADAnsiString(ABuffer)^, ADataLen * SizeOf(TADAnsiChar));
      (PADAnsiString(ABuffer) + ADataLen * SizeOf(TADAnsiChar))^ := TADAnsiChar(#0);
    end;
  end;

  function ProcessWideString(AData: Pointer; ADataLen: Integer; ABuffer: Pointer): Boolean;
  var
    p: PADByteString;
  begin
    if (caFixedLen in oColumn.Attributes) and (ADataLen > 0) and
       (PWideChar(AData)[ADataLen - 1] = ' ') and FormatOptions.StrsTrim then
      repeat
        Dec(ADataLen);
      until (ADataLen = 0) or (PWideChar(AData)[ADataLen - 1] <> ' ');
    if (ADataLen = 0) and FormatOptions.StrsEmpty2Null then
      Result := False
    else begin
      Result := True;
      Move(PWideChar(AData)^, PWideChar(ABuffer)^, ADataLen * SizeOf(WideChar));
      p := PADByteString(ABuffer) + ADataLen * SizeOf(WideChar);
      p^ := TADByte(#0);
      (p + 1)^ := TADByte(#0);
    end;
  end;

  function ProcessByteString(AData: Pointer; ADataLen: Integer; ABuffer: Pointer): Boolean;
  begin
    Result := True;
    if caFixedLen in oColumn.Attributes then begin
      Move(PADByteString(AData)^, PADByteString(ABuffer)^, ADataLen);
      if Integer(oColumn.Size) > ADataLen then
        ADFillChar((PADByteString(ABuffer) + ADataLen)^, Integer(oColumn.Size) - ADataLen, 0);
    end
    else begin
      if (ADataLen = 0) and FormatOptions.StrsEmpty2Null then
        Result := False
      else begin
        PWord(ABuffer)^ := Word(ADataLen);
        Move(PADByteString(AData)^, (PADByteString(ABuffer) + SizeOf(Word))^, ADataLen);
      end;
    end;
  end;

begin
  Result := GetActiveRecBuf(pRecBuf);
  if not Result then
    Exit;
  oColumn := nil;
  iColIndex := -1;
  oRow := nil;
  if not GetFieldColumn(pRecBuf, AFieldNo, oColumn, iColIndex, oRow) then begin
    Result := False;
    Exit;
  end;
  case oColumn.DataType of
  dtRowSetRef, dtCursorRef:
    begin
      oRows := oRow.NestedRows[iColIndex];
      Result := (oRows <> nil) and (oRows.Count > 0);
    end;
  dtRowRef, dtArrayRef:
    Result := (oRow.NestedRow[iColIndex] <> nil);
  else
    pData := nil;
    iDataLen := 0;
    Result := oRow.GetData(iColIndex, GetRowVersion, pData, 0, iDataLen, False);
    if Result and (ABuffer <> nil) then
      case oColumn.DataType of
      dtBoolean:          PWordBool(ABuffer)^ := PWordBool(pData)^;
      dtSByte:            {$IFDEF AnyDAC_D12} PShortInt {$ELSE} PSmallInt {$ENDIF} (ABuffer)^ := PShortInt(pData)^;
      dtByte:             {$IFDEF AnyDAC_D12} PByte {$ELSE} PWord {$ENDIF} (ABuffer)^ := PByte(pData)^;
      dtInt16:            PSmallInt(ABuffer)^ := PSmallInt(pData)^;
      dtUInt16:           PWord(ABuffer)^ := PWord(pData)^;
      dtInt32:            PLongInt(ABuffer)^ := PInteger(pData)^;
      dtUInt32:           {$IFDEF AnyDAC_D12} PLongWord(ABuffer)^ := PLongWord(pData)^ {$ELSE}
                                              PLongInt(ABuffer)^ := PLongInt(pData)^ {$ENDIF};
      dtInt64:            PLargeInt(ABuffer)^ := PInt64(pData)^;
      dtUInt64:           PULargeInt(ABuffer)^ := PUInt64(pData)^;
      dtSingle:           {$IFDEF AnyDAC_D14} PSingle(ABuffer)^ := PSingle(pData)^ {$ELSE}
                          {$IFDEF AnyDAC_D6} PDouble(ABuffer)^ := RoundTo(PSingle(pData)^, -8) {$ELSE}
                                             PDouble(ABuffer)^ := PSingle(pData)^ {$ENDIF} {$ENDIF};
      dtDouble:           PDouble(ABuffer)^ := PDouble(pData)^;
      dtExtended:         {$IFDEF AnyDAC_D12} PExtended {$ELSE} PDouble {$ENDIF} (ABuffer)^ := PExtended(pData)^;
      dtCurrency:         PDouble(ABuffer)^ := PCurrency(pData)^;
      dtBCD:              {$IFNDEF AnyDAC_FPC} PADBcd(ABuffer)^ := PADBcd(pData)^; {$ELSE}
                                               BcdToCurr(PADBcd(pData)^, PCurrency(ABuffer)^); {$ENDIF}
      dtFmtBCD:           {$IFDEF AnyDAC_D6} PADBcd(ABuffer)^ := PADBcd(pData)^; {$ELSE}
                                             begin ADBCD2Double(PADBcd(pData)^, E); PDouble(ABuffer)^ := E; end; {$ENDIF}
      dtDateTimeStamp:    {$IFDEF AnyDAC_D6} PADSQLTimeStamp(ABuffer)^ := PADSQLTimeStamp(pData)^; {$ELSE}
                                             PADDateTimeData(ABuffer)^.DateTime := ADDateTime2MSecs(
                                               ADSQLTimeStamp2DateTime(PADSQLTimeStamp(pData)^)); {$ENDIF}
      dtTimeIntervalFull,
      dtTimeIntervalYM,
      dtTimeIntervalDS:   PADSQLTimeInterval(ABuffer)^ := PADSQLTimeInterval(pData)^;
      dtDateTime:         PADDateTimeData(ABuffer)^.DateTime := PADDateTimeData(pData)^.DateTime;
      dtTime:             PADDateTimeData(ABuffer)^.Time := PLongint(pData)^;
      dtDate:             PADDateTimeData(ABuffer)^.Date := PLongint(pData)^;
      dtAnsiString:       Result := ProcessAnsiString(pData, AdjustSize(iDataLen, AFieldNo), ABuffer);
      dtWideString:       Result := ProcessWideString(pData, AdjustSize(iDataLen, AFieldNo), ABuffer);
      dtByteString:       Result := ProcessByteString(pData, AdjustSize(iDataLen, AFieldNo), ABuffer);
      dtGUID:             ProcessGUID(PGUID(pData), ABuffer);
      dtObject:           PIUnknown(ABuffer)^ := PIUnknown(pData)^;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFieldData(AField: TField;
  {$IFDEF AnyDAC_D18} var {$ENDIF} ABuffer: PADValue): Boolean;
var
  pRecBuf: PADBuffer;
  pBuff: PADRawBuffer;
begin
  if AField.FieldNo > 0 then
    Result := GetFieldData(AField.FieldNo, ABuffer)
  else begin
    Result := GetActiveRecBuf(pRecBuf);
    if Result and (State in [dsBrowse, dsEdit, dsInsert, dsCalcFields, dsBlockRead, dsFilter]) then begin
      pBuff := PADRawBuffer(pRecBuf);
      Inc(pBuff, AField.Offset);
      Result := Boolean(pBuff[0]);
      if Result and (ABuffer <> nil) then
{$IFNDEF AnyDAC_FPC}
  {$IFNDEF AnyDAC_D10}
        if AField.DataType = ftWideString then
          PLongWord(ABuffer)^ := PLongWord(pBuff + 1)^
        else
  {$ENDIF}
        if AField.DataType = ftBCD then
          CurrToBCD(PCurrency(pBuff + 1)^, PADBcd(ABuffer)^)
        else
{$ENDIF}
        if AField.DataSize > 0 then
          Move(pBuff[1], PByte(ABuffer)^, AField.DataSize);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF VER240}
// Required as a possible workaround in DB.pas XE3 bug. There
// TBinaryField.GetAsString leads to a call of this GetFieldData
// version, instead of the above version.
function TADDataSet.GetFieldData(AField: TField; Buffer: Pointer): Boolean;
var
  iLen: Integer;
  aBuff: PADValue;
begin
  if AField.DataSize > dsMaxStringSize + 1 then
    iLen := AField.DataSize
  else
    iLen := dsMaxStringSize + 1;
  SetLength(aBuff, iLen);
  Result := GetFieldData(AField, aBuff);
  if iLen > 0 then
    Move(PByte(aBuff)^, Buffer^, iLen);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_FPC}
function TADDataSet.GetStateFieldValue(AState: TDataSetState; AField: TField): Variant;
var
  ePrevState: TDataSetState;
  lPrevModified: Boolean;
begin
  if (AState in [dsOldValue, dsCurValue]) and __TField(AField).FValidating then begin
    UpdateCursorPos;
    lPrevModified := Modified;
    ePrevState := SetTempState(AState);
    __TField(AField).FValidating := False;
    try
      Result := AField.Value;
    finally
      __TField(AField).FValidating := True;
      RestoreState(ePrevState);
      SetModified(lPrevModified);
    end;
  end
  else
    Result := inherited GetStateFieldValue(AState, AField);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{$IFNDEF AnyDAC_FPC}
procedure TADDataSet.DataConvert(AField: TField; ASource: PADValue;
  {$IFDEF AnyDAC_D18} var {$ENDIF} ADest: PADValue; AToNative: Boolean);
  {$IFNDEF AnyDAC_D10}
var
  l: Integer;
  p: PADByteString;
  {$ENDIF}
begin
  {$IFNDEF AnyDAC_D10}
  if AField.DataType = ftWideString then
    if AField.FieldKind in [fkCalculated, fkLookup] then
      PLongWord(ADest)^ := PLongWord(ASource)^
    else if AToNative then begin
      l := Length(TADWideString(ASource^)) * SizeOf(WideChar);
      if l > 0 then
        Move(TADWideString(ASource^)[1], PWideChar(ADest)^, l);
      p := PADByteString(ADest) + l;
      p^ := TADByte(#0);
      (p + 1)^ := TADByte(#0);
    end
    else
      SetString(TADWideString(ADest^), PWideChar(ASource), ADWideStrLen(PWideChar(ASource)))
  {$ELSE}
  if AField.DataType in [ftWideString, ftFixedWideChar] then
    {$IFDEF NEXTGEN} StrLCopy {$ELSE} WStrLCopy {$ENDIF}
      (PWideChar(ADest), PWideChar(ASource), AField.Size)
  {$ENDIF}
  else
    inherited DataConvert(AField, ASource, ADest, AToNative);
end;

{$ELSE}

procedure TADDataSet.DataConvert(AField: TField; ASource, ADest: PADValue; AToNative: Boolean);

  function WStrLCopy(Dest: PWideChar; const Source: PWideChar; MaxLen: Cardinal): PWideChar;
  var
    Src : PWideChar;
  begin
    Result := Dest;
    Src := Source;
    while (Src^ <> #$00) and (MaxLen > 0) do
    begin
      Dest^ := Src^;
      Inc(Src);
      Inc(Dest);
      Dec(MaxLen);
    end;
    Dest^ := #$00;
  end;

begin
  if AField.DataType = ftFixedWideChar then
    WStrLCopy(PWideChar(ADest), PWideChar(ASource), AField.Size)
  else
    inherited DataConvert(AField, ASource, ADest, AToNative);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFieldData(AField: TField; ABuffer: PADValue);
var
  pRecBuf: PADBuffer;
  pBuff: PADRawBuffer;
  oColumn: TADDatSColumn;
  oRow: TADDatSRow;
  iLen, iFieldNo: Integer;
  pData: Pointer;
{$IFNDEF AnyDAC_D12}
  shiVal: ShortInt;
  biVal: Byte;
  eVal: Extended;
{$ENDIF}
{$IFNDEF AnyDAC_D14}
  sVal: Single;
{$ENDIF}
  crVal: Currency;
  iColIndex: Integer;
  rGUID: TGUID;
{$IFNDEF AnyDAC_D6}
  rSTS: TADSQLTimeStamp;
  rBCD: TADBcd;
{$ENDIF}
  lEndEdit: Boolean;
  lCheckUpdatable: Boolean;

  procedure NotEditingError;
  begin
    DatabaseError(SNotEditing, Self);
  end;

  procedure FieldROError;
  begin
    DatabaseErrorFmt({$IFNDEF AnyDAC_FPC} SFieldReadOnly {$ELSE} SReadOnlyField {$ENDIF},
      [AField.DisplayName]);
  end;

  procedure NotIndexFieldError;
  begin
    DatabaseErrorFmt(SNotIndexField, [AField.DisplayName]);
  end;

  function ProcessGUID(ABuff: PADValue; var AGuid: TGUID): Boolean;
  var
    iLen: Integer;
    s: {$IFDEF NEXTGEN} String {$ELSE} AnsiString {$ENDIF};
  begin
{$IFDEF NEXTGEN}
    iLen := ADByteStrLength(ABuff);
    s := FEncoder.Decode(ABuff, iLen, ecANSI);
{$ELSE}
    iLen := {$IFDEF AnyDAC_D18} System.AnsiStrings. {$ENDIF}
      StrLen(PAnsiChar(ABuff));
    SetString(s, PAnsiChar(ABuff), iLen);
{$ENDIF}
    if iLen = 0 then
      Result := False
    else begin
      if (s[1] <> '{') and (s[Length(s)] <> '}') then
        s := '{' + s + '}';
      AGUID := StringToGUID(String(s));
      Result := True;
    end;
  end;

begin
  lCheckUpdatable := not IsForceRowMode and UpdateOptions.CheckUpdatable;
  if lCheckUpdatable then begin
    if not (State in dsWriteModes) then
      NotEditingError;
    if (State = dsSetKey) and not {$IFDEF AnyDAC_FPC} GetIsIndexField(AField) {$ELSE} AField.IsIndexField {$ENDIF} then
      NotIndexFieldError;
  end;
  iFieldNo := AField.FieldNo;
  GetActiveRecBuf(pRecBuf);
  pBuff := PADRawBuffer(pRecBuf);
  if iFieldNo > 0 then begin
    if lCheckUpdatable then begin
      if (State = dsCalcFields) and (AField.FieldKind <> fkInternalCalc) then
        NotEditingError;
      if AField.ReadOnly and not (State in [dsSetKey, dsFilter]) and UpdateOptions.CheckReadOnly then
        FieldROError;
      AField.Validate(ABuffer);
    end;
    oColumn := nil;
    iColIndex := -1;
    oRow := nil;
    if GetFieldColumn(pRecBuf, iFieldNo, oColumn, iColIndex, oRow, True) then begin
      iLen := 0;
      pData := nil;
      if ABuffer <> nil then
        case oColumn.DataType of
{$IFNDEF AnyDAC_D12}
        dtSByte:
          begin
            shiVal := ShortInt(PSmallInt(ABuffer)^);
            pData := @shiVal;
          end;
        dtByte:
          begin
            biVal := Byte(PWord(ABuffer)^);
            pData := @biVal;
          end;
        dtExtended:
          begin
            eVal := PDouble(ABuffer)^;
            pData := @eVal;
          end;
{$ENDIF}
{$IFNDEF AnyDAC_D14}
        dtSingle:
          begin
  {$IFDEF AnyDAC_D6}
            sVal := RoundTo(PDouble(ABuffer)^, -8);
  {$ELSE}
            sVal := PDouble(ABuffer)^;
  {$ENDIF}
            pData := @sVal;
          end;
{$ENDIF}
        dtCurrency:
          begin
            crVal := PDouble(ABuffer)^;
            pData := @crVal;
          end;
        dtAnsiString:
          begin
            iLen := ADAnsiStrLen(PADAnsiString(ABuffer));
            if (caFixedLen in oColumn.Attributes) and FormatOptions.StrsTrim then
              while (iLen > 0) and (PADAnsiString(ABuffer)[iLen - 1] = TADAnsiChar(' ')) do
                Dec(iLen);
            if (LongWord(iLen) > oColumn.Size) and FormatOptions.StrsTrim2Len then
              iLen := oColumn.Size;
            if (iLen = 0) and FormatOptions.StrsEmpty2Null then
              pData := nil
            else
              pData := ABuffer;
          end;
        dtWideString:
          begin
            iLen := ADWideStrLen(PWideChar(ABuffer));
            if (caFixedLen in oColumn.Attributes) and FormatOptions.StrsTrim then
              while (iLen > 0) and (PWideChar(ABuffer)[iLen - 1] = ' ') do
                Dec(iLen);
            if (LongWord(iLen) > oColumn.Size) and FormatOptions.StrsTrim2Len then
              iLen := oColumn.Size;
            if (iLen = 0) and FormatOptions.StrsEmpty2Null then
              pData := nil
            else
              pData := ABuffer;
          end;
        dtByteString:
          begin
            if caFixedLen in oColumn.Attributes then begin
              pData := ABuffer;
              iLen := oColumn.Size;
            end
            else begin
              iLen := PWord(ABuffer)^;
              if (LongWord(iLen) > oColumn.Size) and FormatOptions.StrsTrim2Len then
                iLen := oColumn.Size;
              if (iLen = 0) and FormatOptions.StrsEmpty2Null then
                pData := nil
              else
                pData := PADByteString(ABuffer) + SizeOf(Word);
            end;
          end;
        dtGUID:
          begin
            pData := @rGUID;
            if not ProcessGUID(ABuffer, rGUID) then
              if FormatOptions.StrsEmpty2Null then
                pData := nil
              else
                ADFillChar(rGUID, SizeOf(TGUID), 0);
          end;
        dtDateTimeStamp:
          begin
{$IFDEF AnyDAC_D6}
            pData := ABuffer;
{$ELSE}
  {$IFDEF AnyDAC_FPC}
            rSTS := ADDateTime2SQLTimeStamp(TimeStampToDateTime(MSecsToTimeStamp(
              Trunc(PADDateTimeData(ABuffer)^.DateTime))));
  {$ELSE}
            rSTS := ADDateTime2SQLTimeStamp(TimeStampToDateTime(MSecsToTimeStamp(
              PADDateTimeData(ABuffer)^.DateTime)));
  {$ENDIF}
            pData := @rSTS;
{$ENDIF}
          end;
        dtBCD:
          begin
{$IFNDEF AnyDAC_FPC}
            pData := ABuffer;
{$ELSE}
            CurrToBCD(PCurrency(ABuffer)^, rBCD);
            pData := @rBCD;
{$ENDIF}
          end;
        dtFmtBCD:
          begin
{$IFDEF AnyDAC_D6}
            pData := ABuffer;
{$ELSE}
            ADDouble2BCD(PDouble(ABuffer)^, rBCD);
            pData := @rBCD;
{$ENDIF}
          end;
        dtBoolean,
{$IFDEF AnyDAC_D12}
        dtSByte, dtByte,
{$ENDIF}
        dtInt16, dtInt32, dtInt64,
        dtUInt16, dtUInt32, dtUInt64,
        dtTime, dtDate, dtDateTime,
        dtTimeIntervalFull, dtTimeIntervalYM, dtTimeIntervalDS,
        dtDouble,
{$IFDEF AnyDAC_D12}
        dtExtended,
{$ENDIF}
{$IFDEF AnyDAC_D14}
        dtSingle,
{$ENDIF}
        dtObject:
          pData := ABuffer;
        end;
      if oRow.RowState in [rsInserted, rsModified, rsUnchanged] then begin
        lEndEdit := State in [dsCalcFields, dsInternalCalc];
        oRow.BeginEdit;
      end
      else
        lEndEdit := False;
      oRow.SetData(iColIndex, pData, iLen);
      if lEndEdit then
        oRow.EndEdit(True);
      if State = dsSetKey then begin
        iFieldNo := SourceView.SortingMechanism.SortColumnList.IndexOfName(AField.FieldName);
        if (iFieldNo >= 0) and (iFieldNo + 1 > FKeyBuffer^.FAssignedFieldCount) then
          FKeyBuffer^.FAssignedFieldCount := iFieldNo + 1;
      end;
    end;
  end
  else begin {fkCalculated, fkLookup}
    Inc(pBuff, AField.Offset);
    Boolean(pBuff[0]) := {$IFDEF AnyDAC_D17} LongBool(ABuffer <> nil) {$ELSE}
                                             LongBool(ABuffer) {$ENDIF};
    if Boolean(pBuff[0]) then
{$IFNDEF AnyDAC_FPC}
  {$IFNDEF AnyDAC_D10}
      if AField.DataType = ftWideString then
        PWideString(pBuff + 1)^ := PWideString(ABuffer)^
      else
  {$ENDIF}
      if AField.DataType = ftBCD then begin
  {$IFDEF CPUARM}
        BCDToCurr(PADBcd(ABuffer)^, crVal);
        PCurrency(pBuff + 1)^ := crVal;
  {$ELSE}
        BCDToCurr(PADBcd(ABuffer)^, PCurrency(pBuff + 1)^);
  {$ENDIF}
      end
      else
{$ENDIF}
      if AField.DataSize > 0 then
        Move(PByte(ABuffer)^, pBuff[1], AField.DataSize);
  end;
  if not IsForceRowMode and not (State in [dsCalcFields, dsFilter, dsNewValue]) then
    DataEvent(deFieldChange, TADNativeInt(AField));
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream;
begin
  Result := TADBlobStream.Create(Field, Mode);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CloseBlob(Field: TField);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetCanModify: Boolean;
begin
  Result := ((DataSetField = nil) or DataSetField.CanModify) and
    not UpdateOptions.ReadOnly;
end;

{-------------------------------------------------------------------------------}
{ Fetching }

procedure TADDataSet.CheckBidirectional;
  procedure ErrorUnidir;
  begin
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSCantUnidir, [GetDisplayName]);
  end;
begin
  if dfUnidirectional in FFlags then
    ErrorUnidir;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoFetch(ATable: TADDatSTable; AAll: Boolean;
  ADirection: TADFetchDirection = fdDown): Integer;
begin
  // nothing more
  Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoFetch(ARow: TADDatSRow; AColumn: Integer;
  ARowOptions: TADPhysFillRowOptions): Boolean;
begin
  // nothing more
  Result := False;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoPurge(AView: TADDatSView; ADirection:TADFetchDirection = fdDown): Integer;
begin
  // nothing more
  Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoAdjustSortFields(const AFields, AExpression: String;
  var AIndexOptions: TADSortOptions): String;
begin
  // nothing more
  if AFields <> '' then
    Result := AFields
  else
    Result := AExpression;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoSortOrderChanging;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoSortOrderChanged;
begin
  ResetMasterRelation;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeGetRecords;
begin
  if Assigned(FBeforeGetRecords) then
    FBeforeGetRecords(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterGetRecords(AFromRecord, AToRecord: Integer);
var
  i: Integer;
begin
  if Assigned(FAfterGetRecords) then
    FAfterGetRecords(Self);
  if Assigned(FAfterGetRecord) then
    for i := AFromRecord to AToRecord do begin
      BeginForceRow(FTable.Rows[i], False, True);
      try
        try
          AfterGetRecord(Self);
        except
          InternalHandleException;
        end;
      finally
        if IsForceRowMode then
          EndForceRow;
      end;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterGetRecords2;
begin
  DoAfterGetRecords(0, -1);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeRowRequest;
begin
  if Assigned(FBeforeRowRequest) then
    FBeforeRowRequest(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterRowRequest;
begin
  if Assigned(FAfterRowRequest) then
    FAfterRowRequest(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeScroll;
begin
  inherited DoBeforeScroll;
  if not (fiBlobs in FetchOptions.Cache) and (State in [dsBrowse, dsBlockRead]) then
    ClearBlobs;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckFetchedAll;
begin
  CheckBidirectional;
  if FClientCursor then
    InternalFetchRows(True, True);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.InternalFetchRows(AAll, AOnDemand: Boolean; ADirection: TADFetchDirection = fdDown): Boolean;
var
  lUnidir, lFetched: Boolean;
  iPurged, iFetched, iLastIndex: Integer;
  iFromRec, iToRec: Integer;
begin
  Result := False;
  if (ADirection = fdUp) and not FClientCursor then
    FSourceEOF := False;
  if ((FParentDataSet <> nil) or not SourceEOF) and
     (not AOnDemand or (FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax])) then begin
    if FParentDataSet <> nil then
      Result := FParentDataSet.InternalFetchNested(FTable, [foDetails])
    else if not SourceEOF then begin
      lUnidir := (dfUnidirectional in FFlags);
      StartWait;
      try
        if DoIsSourceAsync then
          TADThread.Synchronize(DoBeforeGetRecords)
        else
          DoBeforeGetRecords;
        iFromRec := FTable.Rows.Count;
        repeat
          if lUnidir then begin
            Inc(FUnidirRecsPurged, FTable.Rows.Count);
            FTable.Clear;
            FRecordIndex := -1;
            iFromRec := 0;
          end;
          iLastIndex := FRecordIndex;
          iFetched := DoFetch(FTable, AAll and not lUnidir, ADirection);
          if (FSourceView <> nil) and (FRecordIndex < FSourceView.Rows.Count) then
  		      // maintain specified number of records
            iPurged := DoPurge(FSourceView, ADirection)
		      else
            // if FRecordIndex point to last record purging is not needed
            iPurged := 0;
          case ADirection of
          fdUp:
            begin
              FRecordIndex := FRecordIndex + iFetched;
              if FRecordIndex >= FSourceView.Rows.Count then
                FRecordIndex := FSourceView.Rows.Count - 1;
            end;
          fdDown:
            begin
              if (FRecordIndex - iPurged < 0) and (iLastIndex <> -1) then
                // only for table make one record 1
                FRecordIndex := 0
              else
                Dec(FRecordIndex, iPurged);
              if iFromRec - iPurged < 0 then
                iFromRec := 0
              else
                Dec(iFromRec, iPurged);
            end;
          end;
          lFetched := (iFetched > 0);
          Result := Result or lFetched;
        until not AAll or not lFetched or (FTable = nil);
        if FTable <> nil then begin
          if not lFetched and (ADirection = fdDown) then
            FSourceEOF := True;
          if lUnidir and (FSourceView.Rows.Count = 0) then
            ClearBuffers;
          iToRec := FTable.Rows.Count - 1;
          if DoIsSourceAsync then
            TADThread.Synchronize(DoAfterGetRecords2)
          else
            DoAfterGetRecords(iFromRec, iToRec);
        end;
      finally
        StopWait;
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetNextPacket: Integer;
begin
  CheckActive;
  if SourceEOF then
    Result := 0
  else begin
    UpdateCursorPos;
    Result := FUnidirRecsPurged + FTable.Rows.Count;
    if IsLinkedDetail then
      CheckDetailRecords(False)
    else
      InternalFetchRows(False, False);
    Result := FUnidirRecsPurged + FTable.Rows.Count - Result;
    Resync([]);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.FetchNext: Integer;
begin
  Result := GetNextPacket;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FetchAgain;
begin
  CheckActive;
  FSourceEOF := False;
  FUnidirRecsPurged := 0;
  FRecordCount := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FetchAll;
begin
  CheckBrowseMode;
  UpdateCursorPos;
  if InternalFetchRows(True, False) then
    Resync([]);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.InternalFetchNested(ANestedTable: TADDatSTable;
  ARowOptions: TADPhysFillRowOptions): Boolean;
var
  iPrevRowCount: Integer;
  oRow: TADDatSRow;

  procedure CheckNeedFetch(ACheckOpt: TADPhysFillRowOption;
    var ARowOptions: TADPhysFillRowOptions; ADataTypes: TADDataTypes;
    AAttributes: TADDataAttributes);
  var
    lAllFetched: Boolean;
    i: Integer;
    oCol: TADDatSColumn;
  begin
    if ACheckOpt in ARowOptions then begin
      lAllFetched := True;
      for i := 0 to FTable.Columns.Count - 1 do begin
        oCol := FTable.Columns.ItemsI[i];
        if ((oCol.DataType in ADataTypes) or (oCol.Attributes * AAttributes <> [])) and
           not oRow.Fetched[i] then begin
          lAllFetched := False;
          Break;
        end;
      end;
      if lAllFetched then
        Exclude(ARowOptions, ACheckOpt);
    end;
  end;

begin
  UpdateCursorPos;
  oRow := GetRow;
  Result := False;
  if (oRow = nil) or (oRow.RowState in [rsInserted, rsDetached]) then
    Exit;
  if FParentDataSet <> nil then begin
    if ANestedTable = nil then
      Result := FParentDataSet.InternalFetchNested(FTable, ARowOptions + [foDetails])
    else begin
      if not oRow.Fetched[ANestedTable.Columns.ParentCol] then begin
        iPrevRowCount := ANestedTable.Rows.Count;
        FParentDataSet.InternalFetchNested(FTable, ARowOptions + [foDetails]);
        Result := ANestedTable.Rows.Count > iPrevRowCount;
      end;
    end;
  end
  else begin
    CheckOnline;
    DoBeforeRowRequest;
    if foClear in ARowOptions then
      oRow.RejectChanges;
    if ANestedTable = nil then begin
      // If there is foClear, then column values will be erased before fetching,
      // that is equivalent of the case when a column value was not fetched.
      if not (foClear in ARowOptions) then begin
        CheckNeedFetch(foBlobs, ARowOptions, [], [caBlobData]);
        CheckNeedFetch(foDetails, ARowOptions, [dtRowSetRef, dtCursorRef], []);
      end;
      if ARowOptions <> [] then begin
        StartWait;
        try
          Result := DoFetch(oRow, -1, ARowOptions);
        finally
          StopWait;
        end;
      end;
    end
    else begin
      if not oRow.Fetched[ANestedTable.Columns.ParentCol] then begin
        iPrevRowCount := ANestedTable.Rows.Count;
        StartWait;
        try
          DoFetch(oRow, ANestedTable.Columns.ParentCol, ARowOptions);
        finally
          StopWait;
        end;
        Result := ANestedTable.Rows.Count > iPrevRowCount;
      end;
    end;
    DoAfterRowRequest;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FetchDetails(ADataSetField: TDataSetField = nil);
var
  oTab: TADDatSTable;
begin
  if ADataSetField <> nil then
    oTab := (ADataSetField.NestedDataSet as TADDataSet).FTable
  else
    oTab := nil;
  if InternalFetchNested(oTab, [foDetails]) and not (dfOpenBlob in FFlags) then
    DataEvent(deDataSetChange, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FetchBlobs;
begin
  CheckActive;
  if InternalFetchNested(nil, [foBlobs]) and not (dfOpenBlob in FFlags) then
    DataEvent(deDataSetChange, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalClearNested(ADataTypes: TADDataTypes;
  AAttributes: TADDataAttributes);
var
  i: Integer;
  oRow: TADDatSRow;
  lEditing: Boolean;
  lErased: Boolean;
  lRefreshing: Boolean;
  oCol: TADDatSColumn;
begin
  oRow := GetRow;
  if (oRow = nil) or (oRow.RowState = rsDestroying) then
    Exit;
  lRefreshing := (oRow.RowState = rsUnchanged);
  lEditing := not (oRow.RowState in [rsDetached, rsForceWrite]);
  lErased := False;
  for i := 0 to FTable.Columns.Count - 1 do begin
    oCol := FTable.Columns.ItemsI[i];
    if ((oCol.DataType in ADataTypes) or (oCol.Attributes * AAttributes <> [])) and
       oRow.Fetched[i] then begin
      if lEditing and not lErased then
        oRow.BeginEdit;
      oRow.SetData(i, nil, 0);
      oRow.Fetched[i] := False;
      lErased := True;
    end;
  end;
  if lErased and lEditing then begin
    oRow.EndEdit;
    if lRefreshing then
      oRow.AcceptChanges(False);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ClearBlobs;
begin
  InternalClearNested([], [caBlobData]);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ClearDetails;
begin
  InternalClearNested([dtRowSetRef, dtCursorRef], []);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.RefreshRecordBase(ARowOptions: TADPhysFillRowOptions): Boolean;
begin
  CheckActive;
  Cancel;
  Result := InternalFetchNested(nil, ARowOptions + ADGetFillRowOptions(GetFetchOptions));
  if Result then begin
    if not (dfOpenBlob in FFlags) then
      DataEvent(deDataSetChange, 0);
  end
  else
    Resync([]);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.RefreshRecord(AClearRow: Boolean = True): Boolean;
var
  eOpts: TADPhysFillRowOptions;
begin
  eOpts := [];
  if AClearRow then
    Include(eOpts, foClear);
  Result := RefreshRecordBase(eOpts);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.RefreshUnknownRecord(const AValues: array of Variant;
  AReread: Boolean = True; ASetPos: Boolean = True);
var
  oRow: TADDatSRow;
  iPos: Integer;
begin
  CheckActive;
  oRow := Table.NewRow(False);
  try
    oRow.BeginForceWrite;
    oRow.SetValues(AValues);
    oRow.EndForceWrite;
    Table.Rows.Add(oRow);
    oRow.AcceptChanges();
  except
    ADFree(oRow);
    raise;
  end;
  if AReread then begin
    BeginForceRow(oRow, False, True);
    try
      RefreshRecordBase([foClear, foUnkRec]);
    finally
      EndForceRow;
    end;
  end;
  if ASetPos then begin
    iPos := SourceView.IndexOf(oRow);
    if iPos <> -1 then
      RecNo := iPos + FUnidirRecsPurged + 1;
  end;
end;

{-------------------------------------------------------------------------------}
// If to call Refresh and a connection is losted, then a dataset will be
// closed automatically and then Resync will be called. Resync for inactive
// dataset raises an AV.

procedure TADDataSet.Resync(Mode: TResyncMode);
begin
  if Active then
    inherited Resync(Mode);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterRefresh;
begin
  if Active then
    inherited DoAfterRefresh;
end;

{-------------------------------------------------------------------------------}
{ Data editing }

procedure TADDataSet.DoProcessUpdateRequest(ARequest: TADUpdateRequest;
  AOptions: TADUpdateRowOptions);
var
  oRow: TADDatSRow;
  eAction: TADErrorAction;
begin
  if UpdateOptions.CheckRequest(ARequest, AOptions, CachedUpdates) then begin
    oRow := GetRow(ActiveBuffer);
    eAction := eaApplied;
    DoUpdateRecordHandler(oRow, ARequest, AOptions, eAction);
    if eAction in [eaApplied, eaDefault] then
      case ARequest of
      arUnLock:
        if uoCancelUnlock in AOptions then
          oRow.RejectChanges
        else
          oRow.AcceptChanges;
      arInsert:
        oRow.AcceptChanges;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckInserting;
  procedure ErrorInsert;
  begin
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSCantInsert, [GetDisplayName]);
  end;
begin
  if not UpdateOptions.EnableInsert then
    ErrorInsert;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckEditing;
  procedure ErrorEdit;
  begin
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSCantEdit, [GetDisplayName]);
  end;
begin
  if not UpdateOptions.EnableUpdate then
    ErrorEdit;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckDeleting;
  procedure ErrorDelete;
  begin
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSCantDelete, [GetDisplayName]);
  end;
begin
  if not UpdateOptions.EnableDelete then
    ErrorDelete;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalFirst;
begin
  FRecordIndex := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalLast;
begin
  CheckFetchedAll;
  FRecordIndex := FSourceView.Rows.Count;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalEdit;
begin
  StartWait;
  try
    ClearRecordIndex;
    DoProcessUpdateRequest(arLock, [uoImmediateUpd]);
    inherited InternalEdit;
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalInsert;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeInsert;
begin
  inherited DoBeforeInsert;
  CheckInserting;
  if (FParentDataSet <> nil) and (FParentDataSet.State = dsInsert) then
    FParentDataSet.Post;
  ClearRecordIndex;
  FRecordIndexToInsert := GetRowIndex();
  if FRecordIndexToInsert < 0 then
    FRecordIndexToInsert := 0;
  SetUpdateFieldAttributes;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeEdit;
begin
  CheckEditing;
  SetUpdateFieldAttributes;
  inherited DoBeforeEdit;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeDelete;
begin
  CheckDeleting;
  inherited DoBeforeDelete;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.UpdateRecordIndex;
begin
  if dfCalcFieldInIndex in FFlags then
    GetCalcFields(ActiveBuffer);
  FPrevRecordIndex := FRecordIndex;
  if FSourceView.LastUpdatePosition <> -1 then
    FRecordIndex := FSourceView.LastUpdatePosition;
  ClearRecordIndex;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ClearRecordIndex;
begin
  FSourceView.LastUpdatePosition := -1;
  FSourceView.ProposedPosition := -1;
  FRecordIndexToInsert := -1;
  FPrevRecordIndex := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalPost;
var
  oRow: TADDatSRow;
begin
  Include(FFlags, dfPostRow);
  try
{$IFDEF AnyDAC_D6Base}
    if UpdateOptions.CheckRequired then
      inherited InternalPost;
{$ENDIF}
    if State = dsEdit then begin
      StartWait;
      try
        oRow := GetRow;
        if ctInvars in Table.Columns.HasThings then
          oRow.EndEditNested;
        if oRow.RowState = rsEditing then begin
          FSourceView.ProposedPosition := FRecordIndex;
          oRow.EndEdit;
          UpdateRecordIndex;
        end;
        DoProcessUpdateRequest(arLock,   [uoImmediateUpd, uoDeferredLock]);
        DoProcessUpdateRequest(arUpdate, [uoImmediateUpd]);
        DoProcessUpdateRequest(arUnLock, [uoImmediateUpd]);
        // after posting update the record position may be changed in case of
        // IDENTITY / TRIGGER / etc
        UpdateRecordIndex;
      finally
        StopWait;
      end;
    end
    else if State = dsInsert then
      InternalAddRecord(ActiveBuffer, GetBookmarkFlag(ActiveBuffer) = bfEOF);
  finally
    Exclude(FFlags, dfPostRow);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.Post;
begin
  if State = dsSetKey then begin
    DataEvent(deUpdateRecord, 0);
    PostKeyBuffer(True);
  end
  else
    inherited Post;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalDelete;
begin
  StartWait;
  Include(FFlags, dfDeleting);
  try
    ClearRecordIndex;
    DoProcessUpdateRequest(arLock, [uoImmediateUpd, uoOneMomLock]);
    FSourceView.ProposedPosition := FRecordIndex;
    GetRow.Delete;
    UpdateRecordIndex;
    try
      DoProcessUpdateRequest(arDelete, [uoImmediateUpd]);
    except
      on E: Exception do begin
        if not (E is EADDBEngineException) or
           (EADDBEngineException(E).Kind <> ekNoDataFound) then begin
          DoProcessUpdateRequest(arUnLock, [uoImmediateUpd, uoCancelUnlock]);
          raise;
        end;
      end;
    end;
    DoProcessUpdateRequest(arUnLock, [uoImmediateUpd, uoNoSrvRecord]);
  finally
    Exclude(FFlags, dfDeleting);
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalRefresh;
var
  iLastRecNo, iNewRecNo: Integer;
  sKeyFields: String;
  vLastKeyValue: Variant;
  lRecIndSet: Boolean;
begin
  CheckBrowseMode;
  CheckBidirectional;
  if UpdatesPending or (FDataLoadSave <> nil) then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSRefreshError, [GetDisplayName]);

  if not IsEmpty then begin
    iLastRecNo := GetRecNo;
    sKeyFields := PSGetKeyFields;
    if sKeyFields <> ''  then
      vLastKeyValue := FieldValues[sKeyFields];
  end
  else begin
    iLastRecNo := 0;
    sKeyFields := '';
  end;

  if IsLinked then begin
    DoClearBeforeRefetch;
    if FetchOptions.Mode in [fmOnDemand, fmAll, fmExactRecsMax] then
      CheckDetailRecords(True);
  end
  else begin
    DoCloseSource;
    DoOpenSource(True, False, False);
    if DoIsSourceOpen then begin
      FTable.Clear;
      FSourceEOF := False;
      FUnidirRecsPurged := 0;
      FRecordCount := -1;
    end
    else
      FTable.Views.Rebuild;
  end;

  iNewRecNo := -1;
  lRecIndSet := False;
  if sKeyFields <> '' then begin
    CheckFetchedAll;
    if LocateRecord(sKeyFields, vLastKeyValue, [], iNewRecNo) then begin
      FRecordIndex := iNewRecNo;
      lRecIndSet := True;
    end;
  end;
  if not lRecIndSet then
    InternalSetRecNo(iLastRecNo);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalCancel;
var
  oRow: TADDatSRow;
  pInfo: PADRecInfo;
begin
  if State = dsEdit then begin
    StartWait;
    try
      oRow := GetRow;
      if oRow.RowState = rsEditing then
        oRow.CancelEdit;
      DoProcessUpdateRequest(arUnLock, [uoImmediateUpd, uoCancelUnlock]);
    finally
      StopWait;
    end;
  end
  else begin
    pInfo := GetRecInfo(ActiveBuffer);
    if pInfo^.FRow = FNewRow then
      pInfo^.FRow := nil;
    ADFreeAndNil(FNewRow);
  end;
  if FPrevRecordIndex <> -1 then begin
    FRecordIndex := FPrevRecordIndex;
    FPrevRecordIndex := -1;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.Cancel;
begin
  inherited Cancel;
  if State = dsSetKey then
    PostKeyBuffer(False);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalAddRecord(
  Buffer: {$IFDEF AnyDAC_D17} PADBuffer {$ELSE} Pointer {$ENDIF}; Append: Boolean);
var
  iPrevRecIndToIns: Integer;
begin
  StartWait;
  try
    iPrevRecIndToIns := FRecordIndexToInsert;
    try
      if Append then begin
        if FClientCursor then
          InternalFetchRows(True, True);
        FSourceView.ProposedPosition := FSourceView.Rows.Count;
      end
      else
        FSourceView.ProposedPosition := FRecordIndexToInsert;
      FTable.Rows.Add(FNewRow);
      UpdateRecordIndex;
      DoProcessUpdateRequest(arInsert, [uoImmediateUpd]);
      FNewRow := nil;
      // after posting update the record position may be changed in case of
      // IDENTITY / TRIGGER / etc
      UpdateRecordIndex;
    except
      if FNewRow <> nil then begin
        if FNewRow.Owner = FTable.Rows then
          FNewRow.Delete(True);
        if not (dfPostRow in FFlags) then
          ADFreeAndNil(FNewRow);
      end;
      FRecordIndexToInsert := iPrevRecIndToIns;
      raise;
    end;
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalInitRecord(Buffer: PADBuffer);
begin
  if State in dsEditModes then
    GetRow(Buffer).Clear(True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InitRecord(Buffer: PADBuffer);
var
  oParentRow: TADDatSRow;
  oMasterSource: TDataSource;
  pInfo: PADRecInfo;
begin
  oMasterSource := MasterSource;
  if (oMasterSource <> nil) and (oMasterSource.DataSet <> nil) and
     (oMasterSource.DataSet is TADDataSet) then
    FNewRow := FTable.NewRow(True, [TADDataSet(oMasterSource.DataSet).GetRow])
  else
    FNewRow := FTable.NewRow(True);
  if FParentDataSet <> nil then begin
    oParentRow := GetParentRow;
    if oParentRow <> nil then
      try
        FNewRow.ParentRow := oParentRow;
      except
        ADFree(FNewRow);
        FNewRow := nil;
        raise;
      end;
  end;
  inherited InitRecord(Buffer);
  pInfo := GetRecInfo(Buffer);
  pInfo^.FBookmarkFlag := bfInserted;
  pInfo^.FRowIndex := -1;
  pInfo^.FRow := FNewRow;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoOnNewRecord;
var
  oMasters, oDetails: TADFieldList;
  i: Integer;
  iCount: Integer;
begin
  try
    DoProcessUpdateRequest(arFetchGenerators, [uoNoSrvRecord]);
    if (MasterSource <> nil) and (MasterSource.DataSet <> nil) then begin
      oMasters := TADFieldList.Create;
      oDetails := TADFieldList.Create;
      try
        GetDetailLinkFields(oMasters, oDetails);
        iCount := oMasters.Count;
        if iCount > oDetails.Count then
          iCount := oDetails.Count;
        for i := 0 to iCount - 1 do
          if TField(oDetails[i]).CanModify then
{$IFDEF AnyDAC_D6Base}
            if TField(oDetails[i]) is TLargeintField then
              if TField(oMasters[i]).IsNull then
                TLargeintField(oDetails[i]).Clear
              else
                TLargeintField(oDetails[i]).Value := TField(oMasters[i]).Value
            else
{$ENDIF}
              TField(oDetails[i]).Assign(TField(oMasters[i]));
      finally
        ADFree(oMasters);
        ADFree(oDetails);
      end;
    end;
    inherited DoOnNewRecord;
  except
    InternalCancel;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EmptyDataSet;
begin
  CheckBrowseMode;
  FTable.Clear;
  Resync([]);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EmptyView;
var
  i: Integer;
  rState: TADDatSLoadState;
begin
  CheckBrowseMode;
  Table.BeginLoadData(rState, lmHavyMove);
  try
    for i := SourceView.Rows.Count - 1 downto 0 do
      Table.Rows.Remove(SourceView.Rows[i]);
  finally
    Table.EndLoadData(rState);
  end;
  Resync([]);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CopyRecordBase(ASource: TDataset; AExcludeNewEmptyValues: Boolean);
var
  i: Integer;
  oSrcField: TField;
  oDestField: TField;
  oSrcStream: TStream;
  oDestStream: TStream;
begin
  for i := 0 to ASource.FieldCount - 1 do begin
    oSrcField := ASource.Fields[i];
    oDestField := FindField(oSrcField.FieldName);
    if (oDestField = nil) or not oDestField.CanModify or
       (AExcludeNewEmptyValues and VarIsEmpty(oSrcField.NewValue)) then
      // nothing
    else if oSrcField.IsNull then
      oDestField.Clear
    else
      case oDestField.DataType of
      ftLargeInt:
        if oSrcField.DataType = ftLargeInt then
          TLargeIntField(oDestField).AsLargeInt := TLargeIntField(oSrcField).AsLargeInt
        else
          oDestField.AsInteger := oSrcField.AsInteger;
      ftBlob,
      ftMemo,
      ftFmtMemo,
      ftOraBlob,
      ftOraClob,
{$IFDEF AnyDAC_WideMemo}
      ftWideMemo,
{$ENDIF}
      ftDBaseOle:
        begin
          oSrcStream := ASource.CreateBlobStream(oSrcField, bmRead);
          try
            oDestStream := CreateBlobStream(oDestField, bmWrite);
            try
              oDestStream.CopyFrom(oSrcStream, 0);
            finally
              ADFree(oDestStream);
            end;
          finally
            ADFree(oSrcStream);
          end;
        end;
      else
        oDestField.AsVariant := oSrcField.AsVariant;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CopyRecord(ASource: TDataset);
begin
  CopyRecordBase(ASource, False);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CopyDataSet(ASource: TDataset;
  AOptions: TADCopyDataSetOptions = [coRestart, coAppend]);
var
  bm: TBookmark;
  i: Integer;
  oKeyFields: TADFieldList;
  sKeyFields: String;
  vKeyValues: Variant;
  oFld, oSrcFld: TField;
  eStatus: TUpdateStatus;
  oSrcRow, oDestRow: TADDatSRow;
  aMap: TADArrayOfInteger;
begin
  if (ASource = nil) or (ASource = Self) then
    Exit;

  DisableControls;
  StartWait;
  oKeyFields := nil;
  try
    // Recreate this dataset using ASource structure.
    if coStructure in AOptions then begin
      Disconnect();
      if coIndexesReset in AOptions then begin
        IndexName := '';
        IndexFieldNames := '';
        IndexDefs.Clear;
        Indexes.Clear;
      end;
      if (coIndexesCopy in AOptions) and (ASource is TADDataSet) then begin
        IndexDefs := TADDataSet(ASource).IndexDefs;
        Indexes := TADDataSet(ASource).Indexes;
        IndexName := TADDataSet(ASource).IndexName;
        IndexFieldNames := TADDataSet(ASource).IndexFieldNames;
        IndexesActive := TADDataSet(ASource).IndexesActive;
      end;
      if coAggregatesReset in AOptions then
        Aggregates.Clear;
      if (coAggregatesCopy in AOptions) and (ASource is TADDataSet) then begin
        Aggregates := TADDataSet(ASource).Aggregates;
        AggregatesActive := TADDataSet(ASource).AggregatesActive;
      end;
      if coConstraintsReset in AOptions then
        Constraints.Clear;
      if (coConstraintsCopy in AOptions) and (ASource is TADDataSet) then begin
        Constraints := TADDataSet(ASource).Constraints;
        ConstraintsEnabled := TADDataSet(ASource).ConstraintsEnabled;
      end;
      try
        FormatOptions.MaxBcdPrecision := MaxInt;
        FormatOptions.MaxBcdScale := MaxInt;
        if ASource.Active then
          ASource.FieldDefs.Update;
        FieldDefs.Assign(ASource.FieldDefs);
        if coCalcFields in AOptions then
          for i := 0 to ASource.FieldCount - 1 do begin
            oSrcFld := ASource.Fields[i];
            if (oSrcFld.FieldKind <> fkData) and (FieldDefs.IndexOf(oSrcFld.FieldName) = -1) then
              FieldDefs.Add(oSrcFld.FieldName, oSrcFld.DataType, oSrcFld.Size);
          end;
{$IFNDEF AnyDAC_FPC}
        FieldDefList.Update;
{$ENDIF}
        FieldDefs.Updated := True;
        CreateFields;
        for i := 0 to FieldCount - 1 do begin
          oFld := Fields[i];
          oSrcFld := ASource.FindField(oFld.FieldName);
          if oSrcFld <> nil then begin
            oFld.Index := oSrcFld.Index;
{$IFNDEF AnyDAC_FPC}
            oFld.AutoGenerateValue := oSrcFld.AutoGenerateValue;
            oFld.EditMask := oSrcFld.EditMask;
{$ENDIF}
            oFld.Origin := oSrcFld.Origin;
            oFld.ProviderFlags := oSrcFld.ProviderFlags;
            oFld.DefaultExpression := oSrcFld.DefaultExpression;
            oFld.DisplayWidth := oSrcFld.DisplayWidth;
            oFld.DisplayLabel := oSrcFld.DisplayLabel;
            oFld.Required := oSrcFld.Required;
            oFld.ReadOnly := oSrcFld.ReadOnly;
            oFld.Visible := oSrcFld.Visible;
            oFld.Alignment := oSrcFld.Alignment;
            if coConstraintsCopy in AOptions then begin
              oFld.CustomConstraint := oSrcFld.CustomConstraint;
              oFld.ConstraintErrorMessage := oSrcFld.ConstraintErrorMessage;
              oFld.ImportedConstraint := oSrcFld.ImportedConstraint;
            end;
          end;
          if [coAppend, coEdit, coRefresh] * AOptions <> [] then begin
            if oFld is TADAutoIncField then
              TADAutoIncField(oFld).IdentityInsert := True;
            oFld.ReadOnly := False;
          end;
        end;
        for i := 0 to ASource.FieldCount - 1 do begin
          oSrcFld := ASource.Fields[i];
          oFld := FindField(oSrcFld.FieldName);
          if oFld <> nil then
            oFld.Index := oSrcFld.Index;
        end;
        Active := True;
{$IFNDEF AnyDAC_FPC}
        if not (ASource is TADDataSet) then begin
          sKeyFields := {$IFDEF AnyDAC_D17} IProviderSupportNG {$ELSE} IProviderSupport {$ENDIF}
            (ASource).PSGetKeyFields;
          i := 1;
          while i <= Length(sKeyFields) do begin
            oFld := FieldByName(ADExtractFieldName(sKeyFields, i));
            oFld.ProviderFlags := oFld.ProviderFlags + [pfInKey];
          end;
        end;
{$ENDIF}
      finally
        SetDefaultFields(True);
      end;
    end;

    // If do not process a data, then exit.
    if [coAppend, coEdit, coRefresh] * AOptions = [] then
      Exit;
    // Else, check that both datasets are active.
    CheckBrowseMode;
    ASource.CheckBrowseMode;

    if (coRefresh in AOptions) and not (ASource is TADDataSet) then
      AOptions := AOptions - [coRefresh] + [coEdit];

    // If requested to edit record with the existing key value, then
    // fill a list of the ASource key fields and prepare a key values array.
    if [coEdit, coRefresh] * AOptions <> [] then begin
      sKeyFields := PSGetKeyFields;
      oKeyFields := TADFieldList.Create;
      ASource.GetFieldList(oKeyFields, sKeyFields);
      if (oKeyFields.Count = 0) or (sKeyFields = '') then
        AOptions := AOptions - [coEdit, coRefresh];
      vKeyValues := VarArrayCreate([0, oKeyFields.Count - 1], varVariant);
    end;

    // Run batch update.
    BeginBatch;
    ASource.DisableControls;
    bm := ASource.GetBookmark;
    try
      if coRestart in AOptions then
        ASource.First;
      while not ASource.Eof do begin
        eStatus := usUnmodified;

        // If merge, then locate record using a ASource key values.
        if [coEdit, coRefresh] * AOptions <> [] then begin
          for i := 0 to oKeyFields.Count - 1 do begin
            oFld := TField(oKeyFields[i]);
            vKeyValues[i] := oFld.OldValue;
            if VarIsEmpty(vKeyValues[i]) then
              vKeyValues[i] := oFld.Value;
          end;
          if Locate(sKeyFields, vKeyValues, []) then
            eStatus := usModified
          else if coAppend in AOptions then
            eStatus := usInserted;
        end
        else if coAppend in AOptions then
          eStatus := usInserted;

        // Copy data
        if eStatus in [usInserted, usModified] then

          // Merge data into main table. Do not produce row version.
          if coRefresh in AOptions then begin
            if eStatus = usInserted then begin
              oDestRow := Table.NewRow(False);
              Table.Rows.Add(oDestRow);
            end
            else
              oDestRow := GetRow();
            oSrcRow := TADDataSet(ASource).GetRow();
            if Length(aMap) = 0 then
              Table.MakeColumnMap(oSrcRow, aMap);
            Table.Import(oSrcRow, oDestRow, aMap);
            oDestRow.AcceptChanges();
          end

          // Edit data. Produce row version and post changes to a DB
          else begin
            if eStatus = usInserted then
              Append
            else
              Edit;
            CopyRecordBase(ASource, False);
            Post;
          end;

        ASource.Next;
      end;

    finally
      if ASource.BookmarkValid(bm) then
        ASource.GotoBookmark(bm);
      ASource.FreeBookmark(bm);
      ASource.EnableControls;
      EndBatch;
    end;
  finally
    ADFree(oKeyFields);
    StopWait;
    EnableControls;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoUpdateErrorHandler(ARow: TADDatSRow; AException: Exception;
  ARequest: TADUpdateRequest; var AAction: TADErrorAction);
begin
  if (AException is EADException) and Assigned(FOnUpdateError) then begin
    if (ARow <> nil) and (GetRow <> ARow) then
      BeginForceRow(ARow, False, True);
    try
      try
        FOnUpdateError(Self, EADException(AException), ARow, ARequest, AAction);
      except
        InternalHandleException;
        AAction := eaFail;
      end;
    finally
      if (ARow <> nil) and IsForceRowMode then
        EndForceRow;
    end;
  end
  else
    AAction := eaDefault;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoUpdateRecordHandler(ARow: TADDatSRow;
  ARequest: TADUpdateRequest; AOptions: TADUpdateRowOptions;
  var AAction: TADErrorAction);
begin
  if Assigned(OnUpdateRecord) then begin
    if (ARow <> nil) and (GetRow <> ARow) then
      BeginForceRow(ARow, False, True);
    try
      try
        AAction := eaApplied;
        OnUpdateRecord(Self, ARequest, AAction, AOptions);
      except
        InternalHandleException;
        AAction := eaFail;
      end;
    finally
      if (ARow <> nil) and IsForceRowMode then
        EndForceRow;
    end;
  end
  else
    AAction := eaDefault;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoReconcileErrorHandler(ARow: TADDatSRow;
  AException: EADException; AUpdateKind: TADDatSRowState;
  var AAction: TADDAptReconcileAction);
begin
  if Assigned(OnReconcileError) then begin
    if (ARow <> nil) and (GetRow <> ARow) then
      BeginForceRow(ARow, False, True);
    try
      try
        OnReconcileError(Self, AException, AUpdateKind, AAction);
      except
        InternalHandleException;
        AAction := raSkip;
      end;
    finally
      if (ARow <> nil) and IsForceRowMode then
        EndForceRow;
    end;
  end
  else
    AAction := raMerge;
end;

{-------------------------------------------------------------------------------}
{ Bookmarks}

procedure TADDataSet.SetBookmarkSize(AValue: Integer);
begin
  if BookmarkSize <> AValue then begin
    inherited BookmarkSize := AValue;
{$IFDEF AnyDAC_D17}
    SetLength(FSetToRecBmk, AValue);
{$ELSE}
    ReallocMem(FSetToRecBmk, AValue);
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalGotoBookmark(Bookmark: Pointer);
  procedure ErrorNoBmk;
  begin
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSNoBookmark, [GetDisplayName]);
  end;
var
  i: Integer;
  pBmk: PADBookmarkData;
begin
  pBmk := PADBookmarkData(Bookmark);
  i := FSourceView.IndexOf(pBmk^.FRow, rvDefault, pBmk^.FRowIndex);
  if (i = -1) and not (dfLockNoBMK in FFlags) then
    ErrorNoBmk;
  FRecordIndex := i;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D17}
procedure TADDataSet.InternalGotoBookmark(Bookmark: PADBookmark);
begin
  InternalGotoBookmark(PADRawBuffer(Bookmark));
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalSetToRecord(Buffer: PADBuffer);
begin
  GetBookmarkData(Buffer, FSetToRecBmk);
  InternalGotoBookmark(FSetToRecBmk);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetBookmarkFlag(Buffer: PADBuffer): TBookmarkFlag;
begin
  Result := GetRecInfo(Buffer)^.FBookmarkFlag;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetBookmarkFlag(Buffer: PADBuffer; AValue: TBookmarkFlag);
begin
  GetRecInfo(Buffer)^.FBookmarkFlag := AValue;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.GetBookmarkData(Buffer: PADBuffer; Data: PADBookmark);
var
  pBmk: PADBookmarkData;
begin
  pBmk := PADBookmarkData(Data);
  pBmk^.FRow := GetRow(Buffer, True);
  pBmk^.FRowIndex := GetRowIndex(Buffer);
  pBmk^.FResultSetNum := Table.Rows.ResultSetNum;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetBookmarkData(Buffer: PADBuffer; Data: PADBookmark);
var
  pInfo: PADRecInfo;
  pBmk: PADBookmarkData;
begin
  pInfo := GetRecInfo(Buffer);
  pBmk := PADBookmarkData(Data);
  pInfo^.FRow := pBmk^.FRow;
  pInfo^.FRowIndex := pBmk^.FRowIndex;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRowFromBookmark(ABookmark: TBookmark; out ARowIndex: Integer;
  out AResultSetNum: Integer): TADDatSRow;
var
  pBmk: PADBookmarkData;
begin
  pBmk := PADBookmarkData({$IFDEF AnyDAC_D12} @ABookmark[0] {$ELSE} ABookmark {$ENDIF});
  Result := pBmk^.FRow;
  ARowIndex := pBmk^.FRowIndex;
  AResultSetNum := pBmk^.FResultSetNum;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsRowValid(ARow: TADDatSRow; AResultSetNum: Integer): Boolean;
begin
  Result := (ARow <> nil) and (Table <> nil) and
    ((ARow.Owner = Table.Rows) or (ARow.Owner = Table)) and
    (Table.Rows.ResultSetNum = AResultSetNum);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer;
const
  RetCodes: array[Boolean, Boolean] of ShortInt = ((2, -1), (1, 0));
var
  oRow1, oRow2: TADDatSRow;
  i1, i2, iRS1, iRS2: Integer;
begin
  Result := RetCodes[Bookmark1 = nil, Bookmark2 = nil];
  if Result = 2 then begin
    oRow1 := GetRowFromBookmark(Bookmark1, i1, iRS1);
    oRow2 := GetRowFromBookmark(Bookmark2, i2, iRS2);
    if not IsRowValid(oRow1, iRS1) or not IsRowValid(oRow2, iRS2) then
      Result := 0
    else begin
      i1 := FSourceView.IndexOf(oRow1, rvDefault, i1);
      i2 := FSourceView.IndexOf(oRow2, rvDefault, i2);
      if i1 < i2 then
        Result := -1
      else if i1 > i2 then
        Result := 1
      else
        Result := 0;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.BookmarkValid(ABookmark: TBookmark): Boolean;
var
  oRow: TADDatSRow;
  iRow, iRS: Integer;
begin
  Result := False;
  if ABookmark <> nil then begin
    oRow := GetRowFromBookmark(ABookmark, iRow, iRS);
    if IsRowValid(oRow, iRS) then begin
      iRow := FSourceView.IndexOf(oRow, rvDefault, iRow);
      if iRow <> -1 then
        Result := (oRow.RowID = FSourceView.Rows[iRow].RowID);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
{$IFNDEF NEXTGEN}
function TADDataSet.BookmarkStrValid(ABookmarkStr: TBookmarkStr): Boolean;
var
  pBmkData: PADBookmarkData;
  i: Integer;
begin
  Result := False;
  if Length(ABookmarkStr) > 0 then begin
    pBmkData := PADBookmarkData(@ABookmarkStr[1]);
    if IsRowValid(pBmkData^.FRow, pBmkData^.FResultsetNum) then begin
      i := FSourceView.IndexOf(pBmkData^.FRow, rvDefault, pBmkData^.FRowIndex);
      if i <> -1 then
        Result := (pBmkData^.FRow.RowID = FSourceView.Rows[i].RowID);
    end;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ Aggregates }

procedure TADDataSet.SetAggregates(const AValue: TADAggregates);
begin
  FAggregates.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsA: Boolean;
begin
  Result := FAggregates.Count > 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetAggregatesActive(const AValue: Boolean);
begin
  if FAggregatesActive <> AValue then begin
    FAggregatesActive := AValue;
    if FAggregatesActive and Active then begin
      FAggregates.Build;
      FFieldAggregates.Build;
    end
    else begin
      FAggregates.Release;
      FFieldAggregates.Release;
    end;
    DataEvent(deRecordChange, 0);
  end;
end;

{$IFNDEF AnyDAC_FPC}
{-------------------------------------------------------------------------------}
function TADDataSet.GetAggregateValue(AField: TField): Variant;
var
  oAgg: TADAggregate;
  oAggFld: TAggregateField;
begin
  oAggFld := AField as TAggregateField;
  oAgg := TADAggregate(oAggFld.Handle);
  if oAgg <> nil then
    Result := oAgg.Value;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ResetAggField(AField: TField);
var
  oAgg: TADAggregate;
  oAggFld: TAggregateField;
begin
  if AggFields.IndexOf(AField) <> -1 then begin
    oAggFld := AField as TAggregateField;
    oAgg := TADAggregate(oAggFld.Handle);
    if oAgg <> nil then begin
      oAgg.Active := False;
      oAgg.Assign(oAggFld);
    end;
  end;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetViewAggregates;
{$IFNDEF AnyDAC_FPC}
var
  i: Integer;
  oAggFld: TAggregateField;
  oAgg: TADAggregate;
  iSize: LongWord;
  iPrecision, iScale: Integer;
  eType: TFieldType;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  for i := 0 to AggFields.Count - 1 do begin
    oAggFld := AggFields[i] as TAggregateField;
    oAgg := FFieldAggregates.Add;
    oAggFld.Handle := oAgg;
    oAgg.Assign(oAggFld);
    FormatOptions.ColumnDef2FieldDef(oAgg.DataType, 0, 0, 0, [], eType, iSize,
      iPrecision, iScale);
    oAggFld.ResultType := eType;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ResetViewAggregates;
{$IFNDEF AnyDAC_FPC}
var
  i: Integer;
  oAggFld: TAggregateField;
  oAgg: TADAggregate;
{$ENDIF}
begin
{$IFNDEF AnyDAC_FPC}
  for i := 0 to AggFields.Count - 1 do begin
    oAggFld := AggFields[i] as TAggregateField;
    oAgg := TADAggregate(oAggFld.Handle);
    oAggFld.Handle := nil;
    ADFree(oAgg);
  end;
{$ENDIF}
  Aggregates.Release;
  FFieldAggregates.Release;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetGroupingLevel: Integer;
begin
  if FAggregates.GroupingLevel > FFieldAggregates.GroupingLevel then
    Result := FAggregates.GroupingLevel
  else
    Result := FFieldAggregates.GroupingLevel;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetGroupState(ALevel: Integer): TGroupPosInds;
begin
  if not (State in [dsInactive, dsOpening, dsInsert, dsSetKey]) and
     AggregatesActive and (LocalIndexName <> '') then begin
    UpdateCursorPos;
    Result := TGroupPosInds(FSourceView.GetGroupState(FRecordIndex, ALevel));
  end
  else
    Result := [];
end;

{-------------------------------------------------------------------------------}
{ Local indexes / keys / ranges }

function TADDataSet.IsIndexed: Boolean;
begin
  Result := (FSortView <> nil) and (FSortView.SortingMechanism <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetIndexes(const AValue: TADIndexes);
begin
  FIndexes.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsIS: Boolean;
begin
  Result := FIndexes.Count > 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetIndexDefs(const AValue: TIndexDefs);
begin
  FIndexDefs.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsIDS: Boolean;
begin
  Result := FIndexDefs.Count > 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetIndexesActive(const AValue: Boolean);
begin
  if FIndexesActive <> AValue then begin
    FIndexesActive := AValue;
    if FIndexesActive then
      FIndexes.Build
    else
      FIndexes.Release;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetIndexName(const AValue: String);
begin
  if IndexName <> AValue then begin
    FIndexName := AValue;
    FLocalIndexName := FIndexName;
    FIndexFieldNames := '';
    DoSortOrderChanging;
    if Active then
      try
        SwitchToIndex('', FLocalIndexName);
      except
        IndexName := '';
        raise;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetIndexFieldNames: String;
begin
  Result := FIndexFieldNames;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetIndexFieldNames(const AValue: String);
begin
  if IndexFieldNames <> AValue then begin
    FIndexName := '';
    FLocalIndexName := '';
    FIndexFieldNames := AValue;
    DoSortOrderChanging;
    if Active then
      try
        SwitchToIndex(FIndexFieldNames, '');
      except
        IndexFieldNames := '';
        raise;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetIndexFieldCount: Integer;
begin
  if IsIndexed then
    Result := FSortView.SortingMechanism.SortColumnList.Count
  else
    Result := 0;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetIndexField(AIndex: Integer): TField;
begin
  if IsIndexed then
    Result := InternalFieldByName(FSortView.SortingMechanism.SortColumnList.
      ItemsI[AIndex].Name, 'FSortView.SortingMechanism')
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetIsIndexField(AField: TField): Boolean;
begin
  if IsIndexed then
    Result := FSortView.SortingMechanism.SortColumnList.FindColumn(AField.FieldName) <> nil
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckSetKeyMode;
begin
  if State <> dsSetKey then
    DatabaseError(SNotEditing, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CheckIndexed;
begin
  if not IsIndexed then
    DatabaseError(SNoFieldIndexes, Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.AllocKeyBuffers;
var
  i: TADKeyIndex;
begin
  if dfKeyBuffersAllocated in FFlags then
    Exit;
  try
    Include(FFlags, dfKeyBuffersAllocated);
    for i := Low(TADKeyIndex) to High(TADKeyIndex) do begin
      GetMem(FKeyBuffers[i], SizeOf(TADKeyBuffer));
      ADFillChar(FKeyBuffers[i]^, SizeOf(TADKeyBuffer), 0);
      FKeyBuffers[i]^.FRecBuff := AllocRecBuf;
      InitKeyBuffer(FKeyBuffers[i]);
    end;
  except
    FreeKeyBuffers;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FreeKeyBuffers;
var
  i: TADKeyIndex;
  oRow: TADDatSRow;
  pBuff: PADKeyBuffer;
begin
  if not (dfKeyBuffersAllocated in FFlags) then
    Exit;
  Exclude(FFlags, dfKeyBuffersAllocated);
  for i := Low(TADKeyIndex) to High(TADKeyIndex) do begin
    pBuff := GetKeyBuffer(i, False);
    if pBuff <> nil then begin
      oRow := GetKeyRow(pBuff);
      if oRow <> nil then
        ADFree(oRow);
      FreeRecBuf(FKeyBuffers[i].FRecBuff);
      FreeMem(pBuff, SizeOf(TADKeyBuffer));
      FKeyBuffers[i] := nil;
    end;
  end;
  FKeyBuffer := nil;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetKeyRow(ABuffer: PADKeyBuffer): TADDatSRow;
begin
  Result := GetRow(ABuffer.FRecBuff, True);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetLocateRow: TADDatSRow;
begin
  Result := FLocateRow;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetKeyRow(ABuffer: PADKeyBuffer; ARow: TADDatSRow);
begin
  GetRecInfo(ABuffer.FRecBuff)^.FRow := ARow;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetKeyBuffer(AKeyIndex: TADKeyIndex; ACheckCreateRow: Boolean = True): PADKeyBuffer;
var
  oRow: TADDatSRow;
begin
  if ACheckCreateRow and (GetKeyRow(FKeyBuffers[AKeyIndex]) = nil) then begin
    oRow := FTable.NewRow(False);
    oRow.BeginForceWrite;
    SetKeyRow(FKeyBuffers[AKeyIndex], oRow);
  end;
  Result := FKeyBuffers[AKeyIndex];
end;

{-------------------------------------------------------------------------------}
function TADDataSet.InitKeyBuffer(ABuffer: PADKeyBuffer): PADKeyBuffer;
begin
  ABuffer^.FModified := False;
  ABuffer^.FExclusive := False;
  ABuffer^.FFieldCount := 0;
  ABuffer^.FAssignedFieldCount := 0;
  ADFillChar(PADRawBuffer(ABuffer^.FRecBuff)^, FBufferSize, 0);
  Result := ABuffer;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.ClearKeyBuffer(ABuffer: PADKeyBuffer): PADKeyBuffer;
var
  oRow: TADDatSRow;
begin
  oRow := GetKeyRow(ABuffer);
  Result := InitKeyBuffer(ABuffer);
  SetKeyRow(ABuffer, oRow);
  if oRow <> nil then
    oRow.Clear(False);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.AssignKeyBuffer(ADest, ASrc: PADKeyBuffer);
var
  oSrcRow: TADDatSRow;
  oDestRow: TADDatSRow;
  pSrcInfo: PADRecInfo;
  pDestInfo: PADRecInfo;
begin
  pSrcInfo := GetRecInfo(ASrc^.FRecBuff);
  pDestInfo := GetRecInfo(ADest^.FRecBuff);

  ADest^.FModified := ASrc^.FModified;
  ADest^.FExclusive := ASrc^.FExclusive;
  ADest^.FFieldCount := ASrc^.FFieldCount;
  ADest^.FAssignedFieldCount := ASrc^.FAssignedFieldCount;

  Move(PADRawBuffer(ASrc^.FRecBuff)^, PADRawBuffer(ADest^.FRecBuff)^, CalcFieldsSize);
  pDestInfo^.FRowIndex := pSrcInfo^.FRowIndex;
  pDestInfo^.FBookmarkFlag := pSrcInfo^.FBookmarkFlag;

  oSrcRow := GetKeyRow(ASrc);
  oDestRow := GetKeyRow(ADest);
  if oSrcRow = nil then
    SetKeyRow(ADest, nil)
  else begin
    if oDestRow = nil then begin
      oDestRow := FTable.NewRow(False);
      oDestRow.BeginForceWrite;
      SetKeyRow(ADest, oDestRow);
    end;
    FTable.Import(oSrcRow, oDestRow);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.CompareKeyBuffer(ABuff1, ABuff2: PADKeyBuffer): Boolean;
var
  oRow1, oRow2: TADDatSRow;
  oCache: TADDatSCompareRowsCache;
begin
  if (ABuff1^.FExclusive <> ABuff2^.FExclusive) or (ABuff1^.FFieldCount <> ABuff2^.FFieldCount) then
    Result := False
  else begin
    oRow1 := GetKeyRow(ABuff1);
    oRow2 := GetKeyRow(ABuff2);
    oCache := nil;
    Result := (oRow1.CompareRows(nil, nil, nil, -1, oRow2, nil, rvDefault, [], oCache) = 0);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetKeyBuffer(AKeyIndex: TADKeyIndex; AClear: Boolean);
begin
  CheckBrowseMode;
  CheckIndexed;
  FKeyBuffer := GetKeyBuffer(AKeyIndex);
  AssignKeyBuffer(GetKeyBuffer(kiSave), FKeyBuffer);
  if AClear then
    ClearKeyBuffer(FKeyBuffer);
  SetState(dsSetKey);
  SetModified(FKeyBuffer^.FModified);
  DataEvent(deDataSetChange, 0);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetKeyExclusive: Boolean;
begin
  CheckSetKeyMode;
  Result := FKeyBuffer^.FExclusive;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetKeyExclusive(AValue: Boolean);
begin
  CheckSetKeyMode;
  FKeyBuffer^.FExclusive := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetKeyFieldCount: Integer;
begin
  CheckSetKeyMode;
  Result := FKeyBuffer^.FFieldCount;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetKeyFieldCount(AValue: Integer);
begin
  CheckSetKeyMode;
  FKeyBuffer^.FFieldCount := AValue;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.InternalDefaultKeyFieldCount(ABuffer: PADKeyBuffer; ADefault: Integer): Integer;
begin
  Result := ADefault;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetKeyFields(AKeyIndex: TADKeyIndex; const AValues: array of const;
  AExclusive: Boolean = False);
var
  i: Integer;
  iSaveState: TDataSetState;
begin
  CheckIndexed;
  iSaveState := SetTempState(dsSetKey);
  try
    FKeyBuffer := ClearKeyBuffer(GetKeyBuffer(AKeyIndex));
    FKeyBuffer^.FExclusive := AExclusive;
    for i := 0 to High(AValues) do
      GetIndexField(i).AssignValue(AValues[i]);
    FKeyBuffer^.FFieldCount := High(AValues) + 1;
    FKeyBuffer^.FModified := Modified;
  finally
    RestoreState(iSaveState);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.PostKeyBuffer(ACommit: Boolean);
begin
  CheckIndexed;
  DataEvent(deCheckBrowseMode, 0);
  if ACommit then
    FKeyBuffer^.FModified := Modified
  else
    AssignKeyBuffer(FKeyBuffer, GetKeyBuffer(kiSave));
  SetState(dsBrowse);
  DataEvent(deDataSetChange, 0);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetKey;
begin
  SetKeyBuffer(kiLookup, True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EditKey;
begin
  SetKeyBuffer(kiLookup, False);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.FindKey(const AKeyValues: array of const): Boolean;
begin
  CheckBrowseMode;
  SetKeyFields(kiLookup, AKeyValues);
  Result := GotoKey;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.FindNearest(const AKeyValues: array of const);
begin
  CheckBrowseMode;
  SetKeyFields(kiLookup, AKeyValues);
  GotoNearest;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.InternalGotoKey(ANearest: Boolean): Boolean;
var
  iPos: Integer;
  oRow: TADDatSRow;
  keyBuff: PADKeyBuffer;
  opts: TADLocateOptions;
  iFldCnt: Integer;
begin
  CheckIndexed;
  iPos := BeginLocate([], nil);
  keyBuff := GetKeyBuffer(kiLookup);
  oRow := GetKeyRow(keyBuff);
  if FKeyBuffer^.FFieldCount <= 0 then
    iFldCnt := InternalDefaultKeyFieldCount(FKeyBuffer,
      FSortView.SortingMechanism.SortColumnList.Count)
  else
    iFldCnt := FKeyBuffer^.FFieldCount;
  if ANearest then
    opts := [loNearest, loPartial]
  else
    opts := [];
  if soNoCase in FSortView.SortingMechanism.SortOptions then
    Include(opts, loNoCase);
  Result := False;
  FSourceView.Search(oRow, FSortView.SortingMechanism.SortColumnList, nil,
    iFldCnt, opts, iPos, Result);
  if Result or ANearest then begin
    if iPos >= FSourceView.Rows.Count then
      iPos := FSourceView.Rows.Count - 1
    else if iPos < 0 then
      iPos := 0;
    EndLocate(True, iPos, [], nil);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalResetRange;
begin
  DoFilteringUpdated(True);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GotoKey: Boolean;
begin
  Result := InternalGotoKey(False);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.GotoNearest;
begin
  InternalGotoKey(True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ApplyRange;
begin
  CheckBrowseMode;
  if SetCursorRange then
    InternalResetRange;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CancelRange;
begin
  CheckBrowseMode;
  UpdateCursorPos;
  if ResetCursorRange then
    InternalResetRange;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EditRangeStart;
begin
  SetKeyBuffer(kiRangeStart, False);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EditRangeEnd;
begin
  SetKeyBuffer(kiRangeEnd, False);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetRangeStart;
begin
  SetKeyBuffer(kiRangeStart, True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetRangeEnd;
begin
  SetKeyBuffer(kiRangeEnd, True);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetRange(const AStartValues, AEndValues: array of const;
  AStartExclusive: Boolean = False; AEndExclusive: Boolean = False);
begin
  CheckBrowseMode;
  SetKeyFields(kiRangeStart, AStartValues, AStartExclusive);
  SetKeyFields(kiRangeEnd, AEndValues, AEndExclusive);
  ApplyRange;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.SetCursorRange: Boolean;
var
  keyBuff: PADKeyBuffer;
begin
  Result := False;
  if (dfKeyBuffersAllocated in FFlags) and not (
    CompareKeyBuffer(GetKeyBuffer(kiRangeStart), GetKeyBuffer(kiCurRangeStart)) and
    CompareKeyBuffer(GetKeyBuffer(kiRangeEnd), GetKeyBuffer(kiCurRangeEnd))) then
  begin
    keyBuff := GetKeyBuffer(kiRangeStart);
    if keyBuff^.FModified then begin
      FRangeFrom := GetKeyRow(keyBuff);
      if keyBuff^.FExclusive then
        Include(FFlags, dfRangeFromExclusive)
      else
        Exclude(FFlags, dfRangeFromExclusive);
      FRangeFromFieldCount := keyBuff^.FFieldCount;
      if FRangeFromFieldCount = 0 then
        FRangeFromFieldCount := InternalDefaultKeyFieldCount(keyBuff, -1);
    end
    else if FRangeFrom <> nil then
      FRangeFrom := nil;
    keyBuff := GetKeyBuffer(kiRangeEnd);
    if keyBuff^.FModified then begin
      FRangeTo := GetKeyRow(keyBuff);
      if keyBuff^.FExclusive then
        Include(FFlags, dfRangeToExclusive)
      else
        Exclude(FFlags, dfRangeToExclusive);
      FRangeToFieldCount := keyBuff^.FFieldCount;
      if FRangeToFieldCount = 0 then
        FRangeToFieldCount := InternalDefaultKeyFieldCount(keyBuff, -1);
    end
    else if FRangeTo <> nil then
      FRangeTo := nil;
    AssignKeyBuffer(GetKeyBuffer(kiCurRangeStart), GetKeyBuffer(kiRangeStart));
    AssignKeyBuffer(GetKeyBuffer(kiCurRangeEnd), GetKeyBuffer(kiRangeEnd));
    Result := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.ResetCursorRange: Boolean;
begin
  Result := False;
  if (dfKeyBuffersAllocated in FFlags) and (
     GetKeyBuffer(kiCurRangeStart, False)^.FModified or
     GetKeyBuffer(kiCurRangeEnd, False)^.FModified
    ) then
  begin
    if FRangeFrom <> nil then
      FRangeFrom := nil;
    if FRangeTo <> nil then
      FRangeTo := nil;
    ClearKeyBuffer(GetKeyBuffer(kiCurRangeStart));
    ClearKeyBuffer(GetKeyBuffer(kiCurRangeEnd));
    Result := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.IsRanged: Boolean;
begin
  Result := (FRangeFrom <> nil) or (FRangeTo <> nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.AddIndex(const AName, AFields, AExpression: string;
  AOptions: TADSortOptions; const ADescFields, ACaseInsFields: string;
  ADistinct: Boolean);
var
  oInd: TADIndex;
begin
  if Indexes.FindIndex(AName) = nil then begin
    oInd := Indexes.Add;
    oInd.Name := AName;
    if AFields <> '' then begin
      oInd.Fields := AFields;
      oInd.DescFields := ADescFields;
      oInd.CaseInsFields := ACaseInsFields;
    end
    else if AExpression <> '' then
      oInd.Expression := AExpression;
    oInd.Options := AOptions;
    oInd.Distinct := ADistinct;
    oInd.Active := True;
  end
  else
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DuplicatedName, [AName]);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DeleteIndex(const AName: string);
begin
  Indexes.Delete(Indexes.IndexByName(AName).Index);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DeleteIndexes;
begin
  Indexes.Clear;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.GetIndexNames(AList: TStrings);
{$IFDEF AnyDAC_FPC}
var
  I: Integer;
  oDef: TIndexDef;
{$ENDIF}
begin
  if not IndexDefs.Updated then
    IndexDefs.Update;
{$IFNDEF AnyDAC_FPC}
  IndexDefs.GetItemNames(AList);
{$ELSE}
  AList.BeginUpdate;
  try
    AList.Clear;
    for I := 0 to IndexDefs.Count - 1 do begin
      oDef := IndexDefs[i];
      if oDef.Name <> '' then
        AList.Add(oDef.Name);
    end;
  finally
    AList.EndUpdate;
  end;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{ Lookup & Locate }

function ConditionsToExpression(const AConditions: string;
  const AValues: Variant; APartial: Boolean): string;

  function SingleExpression(const ACondition: string; const AValue: Variant): String;
{$IFDEF AnyDAC_D6}
  var
    iLen: Integer;
{$ENDIF}
  begin
    case VarType(AValue) of
      varEmpty,
      varNull:
        Result := ' IS NULL';
      varSingle,
      varDouble,
      varCurrency:
        Result := ' = ' + ADFloat2Str(AValue, '.');
      varDate:
        Result := ' = CONVERT(''TIMESTAMP'', ''' + VarToStr(AValue) + ''')';
{$IFDEF AnyDAC_D12}
      varUString,
{$ENDIF}
      varOleStr,
      varString:
        begin
          Result := VarToStr(AValue);
          if APartial and (Result <> '') and (Result[Length(Result)] <> '*') then
            Result := Result + '*';
          Result := ' = ' + QuotedStr(VarToStr(Result));
        end;
      else
{$IFDEF AnyDAC_D6}
        if VarType(AValue) = VarSQLTimeStamp then
          Result := ' = CONVERT(''TIMESTAMP'', ''' + VarToStr(AValue) + ''')'
        else if VarType(AValue) = VarFMTBcd then begin
          SetLength(Result, 255);
          ADBCD2Str(PChar(Result), iLen, VarToBcd(AValue), '.');
          SetLength(Result, iLen);
          Result := ' = ' + Result;
        end
        else
{$ENDIF}
          Result := ' = ' + VarToStr(AValue);
    end;
    Result := ACondition + Result;
  end;

var
  iWord, iArray: Integer;
  sExpr: string;
begin
  if VarIsArray(AValues) then begin
    iWord := 1;
    iArray := 0;
    while iWord <= Length(AConditions) do begin
      sExpr := SingleExpression(ADExtractFieldName(AConditions, iWord), AValues[iArray]);
      if iArray = 0 then
        Result := sExpr
      else begin
        if iArray = 1 then
          Result := '(' + Result + ')';
        Result := Result + ' AND (' + sExpr + ')';
      end;
      Inc(iArray);
    end;
  end
  else
    Result := SingleExpression(AConditions, AValues);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InitLocateRow(const AKeyFields: String; const AKeyValues: Variant);
var
  V: Variant;
  oFld: TField;
begin
  if FLocateRow = nil then begin
    FLocateRow := FTable.NewRow(False);
    FLocateColumns := TADDatSColumnSublist.Create;
  end;
  if AKeyFields <> FLocateColumns.Names then
    FLocateColumns.Fill(FTable, AKeyFields);
  BeginForceRow(FLocateRow, True, False);
  try
    if FLocateColumns.Count = 1 then begin
      if VarIsArray(AKeyValues) then
        V := AKeyValues[0]
      else
        V := AKeyValues;
      oFld := InternalFieldByName(AKeyFields, 'LocateRecord(AKeyFields)');
      if VarIsNull(V) then
        oFld.Clear
      else
{$IFDEF AnyDAC_D6Base}
      if oFld.DataType = ftLargeInt then
        TLargeIntField(oFld).Value := V
{$ELSE}
      if (oFld.DataType = ftLargeInt) and (VarType(V) = varInt64) then
        TLargeIntField(oFld).Value := Decimal(V).lo64
{$ENDIF}
      else
        oFld.Value := V;
    end
    else
      FieldValues[AKeyFields] := AKeyValues;
  finally
    EndForceRow;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.LocateRecord(const AKeyFields: string;
  const AKeyValues: Variant; AOptions: TADDataSetLocateOptions;
  var AIndex: Integer): Boolean;
var
  opts: TADLocateOptions;
begin
  try
    InitLocateRow(AKeyFields, AKeyValues);
    FLocateColumns.Fill(FTable, AKeyFields);
  except
    on E: EADException do
      if E.ADCode = er_AD_NameNotFound then begin
        Result := LocateRecord(ConditionsToExpression(AKeyFields, AKeyValues,
          lxoPartialKey in AOptions), AOptions, AIndex);
        Exit;
      end
      else
        raise;
  end;

  opts := [];
  if lxoCaseInsensitive in AOptions then
    Include(opts, loNoCase);
  if lxoPartialKey in AOptions then
    Include(opts, loPartial);
  if lxoFromCurrent in AOptions then
    Include(opts, loFromCurrent);
  if lxoBackward in AOptions then
    Include(opts, loBackward);

  FSourceView.Search(FLocateRow, FLocateColumns, nil, -1, opts, AIndex, Result);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.LocateRecord(const AExpression: string;
  AOptions: TADDataSetLocateOptions; var AIndex: Integer): Boolean;
var
  expOpts: TADExpressionOptions;
begin
  expOpts := [];
  if lxoCaseInsensitive in AOptions then
    Include(expOpts, ekNoCase);
  if lxoPartialKey in AOptions then
    Include(expOpts, ekPartial);

  if FSourceViewLocator = nil then begin
    FSourceViewLocator := TADDatSMechFilter.Create;
    FSourceViewLocator.Locator := True;
    FSourceView.Mechanisms.Add(FSourceViewLocator);
  end;
  FSourceViewLocator.Expression := AExpression;
  FSourceViewLocator.OnFilterRow := nil;
  FSourceViewLocator.Options := expOpts;
  try
    FSourceViewLocator.Active := True;
  except
    ADFreeAndNil(FSourceViewLocator);
    raise;
  end;

  Result := FSourceView.Locate(AIndex, not (lxoBackward in AOptions),
    not (lxoFromCurrent in AOptions));
end;

{-------------------------------------------------------------------------------}
function TADDataSet.Locate(const AKeyFields: string; const AKeyValues: Variant;
  AOptions: TLocateOptions = []): Boolean;
var
  eOptions: TADDataSetLocateOptions;
begin
  eOptions := [];
  if loCaseInsensitive in AOptions then
    Include(eOptions, lxoCaseInsensitive);
  if loPartialKey in AOptions then
    Include(eOptions, lxoPartialKey);
  Result := LocateEx(AKeyFields, AKeyValues, eOptions);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.BeginLocate(AOptions: TADDataSetLocateOptions;
  ApRecordIndex: PInteger): Integer;
begin
  CheckActive;
  SetFound(False);
  if ApRecordIndex <> nil then begin
    if not (lxoFromCurrent in AOptions) then
      ApRecordIndex^ := -1;
    Result := ApRecordIndex^;
  end
  else begin
    if not (lxoCheckOnly in AOptions) then begin
      CheckBrowseMode;
      DoBeforeScroll;
    end;
    if not (lxoFromCurrent in AOptions) then
      Result := -1
    else begin
      UpdateCursorPos;
      Result := FRecordIndex;
    end;
    if not (lxoCheckOnly in AOptions) then
      CursorPosChanged;
  end;
  if not (lxoNoFetchAll in AOptions) then
    CheckFetchedAll;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EndLocate(AResult: Boolean; APos: Integer;
  AOptions: TADDataSetLocateOptions; ApRecordIndex: PInteger);
var
  eMode: TResyncMode;
begin
  SetFound(AResult);
  if AResult then
    if ApRecordIndex <> nil then
      ApRecordIndex^ := APos
    else
      if not (lxoCheckOnly in AOptions) then begin
        FRecordIndex := APos;
        eMode := [rmCenter];
        if APos <> -1 then
          Include(eMode, rmExact);
        Resync(eMode);
        DoAfterScroll;
      end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.LocateEx(const AKeyFields: string; const AKeyValues: Variant;
  AOptions: TADDataSetLocateOptions = []; ApRecordIndex: PInteger = nil): Boolean;
var
  iPos: Integer;
begin
  iPos := BeginLocate(AOptions, ApRecordIndex);
  Result := LocateRecord(AKeyFields, AKeyValues, AOptions, iPos);
  EndLocate(Result, iPos, AOptions, ApRecordIndex);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.LocateEx(const AExpression: string;
  AOptions: TADDataSetLocateOptions = []; ApRecordIndex: PInteger = nil): Boolean;
var
  iPos: Integer;
begin
  iPos := BeginLocate(AOptions, ApRecordIndex);
  Result := LocateRecord(AExpression, AOptions, iPos);
  EndLocate(Result, iPos, AOptions, ApRecordIndex);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.Lookup(const AKeyFields: string; const AKeyValues: Variant;
  const AResultFields: string): Variant;
begin
  Result := LookupEx(AKeyFields, AKeyValues, AResultFields, []);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.BeginLookup(AOptions: TADDataSetLocateOptions;
  ApRecordIndex: PInteger): Integer;
begin
  if ApRecordIndex <> nil then begin
    if not (lxoFromCurrent in AOptions) then
      ApRecordIndex^ := -1;
    Result := ApRecordIndex^;
  end
  else begin
    if not (lxoCheckOnly in AOptions) then begin
      CheckBrowseMode;
      CursorPosChanged;
    end;
    if lxoFromCurrent in AOptions then begin
      UpdateCursorPos;
      Result := FRecordIndex;
    end
    else
      Result := -1;
  end;
  if not (lxoNoFetchAll in AOptions) then
    CheckFetchedAll;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.EndLookup(AResult: Boolean; APos: Integer;
  const AResultFields: string; ApRecordIndex: PInteger): Variant;
begin
  if AResult then begin
    if ApRecordIndex <> nil then
      ApRecordIndex^ := APos;
    BeginForceRow(FSourceView.Rows.ItemsI[APos], False, True);
    try
      Result := FieldValues[AResultFields];
    finally
      EndForceRow;
    end;
  end
  else
    Result := Null;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.LookupEx(const AKeyFields: string; const AKeyValues: Variant;
  const AResultFields: string; AOptions: TADDataSetLocateOptions = [];
  ApRecordIndex: PInteger = nil): Variant;
var
  iPos: Integer;
begin
  iPos := BeginLookup(AOptions, ApRecordIndex);
  Result := EndLookup(LocateRecord(AKeyFields, AKeyValues, AOptions, iPos),
    iPos, AResultFields, ApRecordIndex);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.LookupEx(const AExpression, AResultFields: string;
  AOptions: TADDataSetLocateOptions; ApRecordIndex: PInteger): Variant;
var
  iPos: Integer;
begin
  iPos := BeginLookup(AOptions, ApRecordIndex);
  Result := EndLookup(LocateRecord(AExpression, AOptions, iPos),
    iPos, AResultFields, ApRecordIndex);
end;

{-------------------------------------------------------------------------------}
{ Filters }

procedure TADDataSet.DoFilteringUpdated(AResync: Boolean);
begin
  if Active then begin
    CheckBrowseMode;
    CreateFilterView;
    RelinkViews;
    if AResync then
      ResyncViews;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SafeFilteringUpdated;
begin
  try
    DoFilteringUpdated(True);
  except
    Filtered := False;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFilterOptions(AValue: TFilterOptions);
begin
  if AValue <> FilterOptions then begin
    inherited SetFilterOptions(AValue);
    if Filtered then
      SafeFilteringUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFilterText(const AValue: string);
begin
  if AValue <> Filter then begin
    inherited SetFilterText(AValue);
    if Filtered then
      SafeFilteringUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFiltered(AValue: Boolean);
begin
  if AValue <> Filtered then begin
    inherited SetFiltered(AValue);
    SafeFilteringUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetOnFilterRecord(const AValue: TFilterRecordEvent);
begin
  if (TMethod(AValue).Code <> TMethod(OnFilterRecord).Code) or
     (TMethod(AValue).Data <> TMethod(OnFilterRecord).Data) then begin
    inherited SetOnFilterRecord(AValue);
    if Filtered then
      SafeFilteringUpdated;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoFilterRow(AMech: TADDatSMechFilter;
  ARow: TADDatSRow; AVersion: TADDatSRowVersion): Boolean;
var
  iSaveState: TDataSetState;
begin
  if (FBufferSize = 0) or (Fields.Count = 0) then begin
    Result := True;
    Exit;
  end;
  iSaveState := SetTempState(dsFilter);
  BeginForceRow(ARow, False, True);
  try
    Result := True;
    OnFilterRecord(Self, Result);
  except
    InternalHandleException;
  end;
  EndForceRow;
  RestoreState(iSaveState);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetFilterChanges(const AValue: TADUpdateRecordTypes);
begin
  if FFilterChanges <> AValue then begin
    CheckCachedUpdatesMode;
    FFilterChanges := AValue;
    DoFilteringUpdated(True);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.FindRecord(Restart, GoForward: Boolean): Boolean;
var
  oLct: TADDatSMechFilter;
begin
  BeginLocate([lxoFromCurrent], nil);

  if not Filtered then
    try
      oLct := CreateFilterMech(FSourceViewLocator);
      if FSourceViewLocator = nil then begin
        FSourceViewLocator := oLct;
        FSourceViewLocator.Locator := True;
        FSourceView.Mechanisms.Add(FSourceViewLocator);
      end;
    except
      ADFreeAndNil(FSourceViewLocator);
      raise;
    end;

  Result := FSourceView.Locate(FRecordIndex, GoForward, Restart);
  EndLocate(Result, FRecordIndex, [], nil);
end;

{$IFDEF AnyDAC_FPC}
{-------------------------------------------------------------------------------}
function TADDataSet.FindFirst: Boolean;
begin
  Result := FindRecord(True, True);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.FindLast: Boolean;
begin
  Result := FindRecord(True, False);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.FindNext: Boolean;
begin
  Result := FindRecord(False, True);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.FindPrior: Boolean;
begin
  Result := FindRecord(False, False);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDataSet.CreateExpression(const AExpr: String;
  AOptions: TADExpressionOptions = []): IADStanExpressionEvaluator;
var
  oParser: IADStanExpressionParser;
begin
  ADCreateInterface(IADStanExpressionParser, oParser);
  Result := oParser.Prepare(TADDatSTableExpressionDS.Create(FTable),
    AExpr, AOptions, [poDefaultExpr], '');
  Result.DataSource.Position := GetRow;
end;

{-------------------------------------------------------------------------------}
{ Constraints }

{$IFDEF AnyDAC_FPC}
procedure TADDataSet.SetConstraints(const AValue: TCheckConstraints);
begin
  FConstraints.Assign(AValue);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDataSet.IsCS: Boolean;
begin
  Result := Constraints.Count > 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DisableConstraints;
begin
  if FConstDisableCount = 0 then
    if FTable <> nil then
      FTable.Constraints.Enforce := False;
  Inc(FConstDisableCount);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EnableConstraints;
begin
  if FConstDisableCount > 0 then begin
    Dec(FConstDisableCount);
    if FConstDisableCount = 0 then
      if FTable <> nil then
        FTable.Constraints.Enforce := True;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetConstraintsEnabled: Boolean;
begin
  Result := FConstDisableCount = 0;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetConstraintsEnabled(const AValue: Boolean);
begin
  if AValue <> ConstraintsEnabled then
    if AValue then
      while not ConstraintsEnabled do
        EnableConstraints
    else
      while ConstraintsEnabled do
        DisableConstraints;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.UpdateConstraints;
begin
  ResetTableConstraints;
  SetTableConstraints;
end;

{-------------------------------------------------------------------------------}
{ Cloning }

procedure TADDataSet.GotoCurrent(ADataSet: TADDataSet);
begin
  CheckBrowseMode;
  CheckFetchedAll;
  ADataSet.CheckActive;
  BookMark := ADataSet.BookMark;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoCloneCursor(AReset, AKeepSettings: Boolean);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CloneCursor(ASource: TADDataSet; AReset,
  AKeepSettings: Boolean);
begin
  DisableControls;
  try
    ASource.FetchAll;
    AttachTable(ASource.FTable, ASource.FView);
    FCloneSource := ASource;
    FParentDataSet := ASource.FParentDataSet;
    FieldDefs.Updated := False;
    OnFilterRecord := nil;
    if AReset then begin
      CachedUpdates := False;
      Filtered := False;
      Filter := '';
      FilterChanges := [rtUnmodified, rtModified, rtInserted];
      Indexes.Clear;
      IndexesActive := False;
      IndexName := '';
      Aggregates.Clear;
      AggregatesActive := False;
      Constraints.Clear;
      ConstraintsEnabled := True;
      MasterSource := nil;
      MasterFields := '';
      DetailFields := '';
      UpdateOptions.RestoreDefaults;
      FetchOptions.RestoreDefaults;
      ResourceOptions.RestoreDefaults;
      FormatOptions.RestoreDefaults;
    end
    else if not AKeepSettings then begin
      CachedUpdates := CachedUpdates or ASource.CachedUpdates;
      Filter := ASource.Filter;
      FilterOptions := ASource.FilterOptions;
      Filtered := ASource.Filtered;
      FilterChanges := ASource.FilterChanges;
      Indexes := ASource.Indexes;
      IndexesActive := ASource.IndexesActive;
      if ASource.IndexName <> '' then
        IndexName := ASource.IndexName
      else
        IndexFieldNames := ASource.IndexFieldNames;
      Aggregates := ASource.Aggregates;
      AggregatesActive := ASource.AggregatesActive;
      Constraints := ASource.Constraints;
      ConstraintsEnabled := ASource.ConstraintsEnabled;
      MasterSource := ASource.MasterSource;
      MasterFields := ASource.MasterFields;
      DetailFields := ASource.DetailFields;
      UpdateOptions := ASource.UpdateOptions;
      FetchOptions := ASource.FetchOptions;
      ResourceOptions := ASource.ResourceOptions;
      FormatOptions := ASource.FormatOptions;
    end;
    DoCloneCursor(AReset, AKeepSettings);
    Open;
    FTable.AddDataCallback(Self);
    ASource.FTable.AddDataCallback(ASource);
    // Set OnFilterRecord event handler after this dataset is open, otherwise
    // InternalOpen -> RelinkViews will activate FFilterView, it will call
    // OnFilterRecord and that may lead to AV, because there is no fields
    // and buffers.
    if not AReset and not AKeepSettings then
      OnFilterRecord := ASource.OnFilterRecord;
  finally
    EnableControls;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.TableDataChanged(ARow: TADDatSRow; AChangeKind: TADDatSRowState);
begin
  try
    // When this dataset was cloned, it has a callback. And GetRow.Delete
    // fires this handler. So, InternalDelete losts position and record
    // remains in change log. dfDeleting protects against that.
    if (State = dsBrowse) and not (dfDeleting in FFlags) then begin
      UpdateCursorPos;
      Resync([]);
      UpdateCursorPos;
    end;
  except
  end;
end;

{-------------------------------------------------------------------------------}
{ Dataset creating }

procedure TADDataSet.InitColumnsFromFieldDefs(ADefs: TFieldDefs; ATable: TADDatSTable;
  ADatSManager: TADDatSManager);
var
  oFmtOpts: TADFormatOptions;
  oUpdOpts: TADBottomUpdateOptions;
  i: Integer;
  oDef: TFieldDef;
  oCol: TADDatSColumn;
  eDestDataType: TADDataType;
  iDestScale, iDestPrec: Integer;
  iDestSize: LongWord;
  esDestAttrs: TADDataAttributes;
{$IFNDEF AnyDAC_FPC}
  oChildTab: TADDatSTable;
  oChildTabRelCol: TADDatSColumn;
  oRel: TADDatSRelation;
{$ENDIF}
begin
  ATable.Setup(GetOptionsIntf);
  oFmtOpts := FormatOptions;
  oUpdOpts := UpdateOptions;
  for i := 0 to ADefs.Count - 1 do begin
    oDef := ADefs[i];
    oFmtOpts.FieldDef2ColumnDef(oDef, eDestDataType, iDestSize, iDestPrec,
      iDestScale, esDestAttrs);
    oCol := TADDatSColumn.Create;
    oCol.Name := oDef.Name;
    oCol.DataType := eDestDataType;
    oCol.Size := iDestSize;
    oCol.Precision := iDestPrec;
    oCol.Scale := iDestScale;
    if not (faRequired in oDef.Attributes) {$IFDEF AnyDAC_FPC} and not oDef.Required {$ENDIF} then
      Include(esDestAttrs, caAllowNull);
    if faReadonly in oDef.Attributes then
      Include(esDestAttrs, caReadOnly);
    if faHiddenCol in oDef.Attributes then
      Include(esDestAttrs, caInternal);
    if faUnnamed in oDef.Attributes then
      Include(esDestAttrs, caUnnamed);
    if oDef.InternalCalcField then
      Include(esDestAttrs, caCalculated)
    else
      Include(esDestAttrs, caBase);
    if not (eDestDataType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef]) then
      Include(esDestAttrs, caSearchable);
    if (oDef.DataType = ftAutoInc) or
       (oUpdOpts.AutoIncFields <> '') and
       ADFieldInFieldNames(oUpdOpts.AutoIncFields, oCol.Name) then begin
      esDestAttrs := esDestAttrs + [caAutoInc, caAllowNull];
      oCol.AutoIncrement := True;
    end;
    oCol.Attributes := esDestAttrs;
    if (oUpdOpts.KeyFields <> '') and
       ADFieldInFieldNames(oUpdOpts.KeyFields, oCol.Name) then
      oCol.Options := oCol.Options + [coInKey];
    oCol.SourceID := oDef.FieldNo;
    ATable.Columns.Add(oCol);

{$IFNDEF AnyDAC_FPC}
    if (ADatSManager <> nil) and (eDestDataType in [dtRowSetRef, dtCursorRef, dtRowRef, dtArrayRef]) then begin
      oChildTab := TADDatSTable.Create;
      oChildTab.CountRef;
      oChildTab.Setup(GetOptionsIntf);
      oChildTab.Name := ADatSManager.Tables.BuildUniqueName(
        C_AD_SysNamePrefix + '#' + ATable.Name + '#' + oCol.Name);
      ADatSManager.Tables.Add(oChildTab);
      InitColumnsFromFieldDefs(oDef.ChildDefs, oChildTab, ADatSManager);

      oChildTabRelCol := TADDatSColumn.Create;
      oChildTabRelCol.Name := oChildTab.Columns.BuildUniqueName(
        C_AD_SysNamePrefix + '#' + oCol.Name);
      oChildTabRelCol.DataType := dtParentRowRef;
      oChildTabRelCol.Attributes := oCol.Attributes + [caInternal] - [caSearchable];
      oChildTab.Columns.Add(oChildTabRelCol);

      oRel := TADDatSRelation.Create;
      oRel.Name := ADatSManager.Relations.BuildUniqueName(
        C_AD_SysNamePrefix + '#' + ATable.Name + '#' + oCol.Name);
      oRel.Nested := True;
      oRel.ParentTable := ATable;
      oRel.ParentColumnNames := oCol.Name;
      oRel.ChildTable := oChildTab;
      oRel.ChildColumnNames := oChildTabRelCol.Name;
      ADatSManager.Relations.Add(oRel);
    end;
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InitTable(AWithFields: Boolean);
var
  oTab: TADDatSTable;
  oSch: TADDatSManager;
{$IFDEF AnyDAC_FPC}
  i: Integer;
{$ENDIF}
begin
  if AWithFields then begin
    if FieldDefs.Count = 0 then
      InitFieldDefsFromFields
{$IFDEF AnyDAC_FPC}
    else
      for i := 0 to FieldDefs.Count - 1 do
        __TFieldDef(FieldDefs[i]).FFieldNo := i + 1;
{$ENDIF}
  end;
  oTab := TADDatSTable.Create;
  oSch := DoGetDatSManager;
  try
    oTab.CountRef;
    oTab.Setup(GetOptionsIntf);
    if oSch <> nil then begin
      oTab.Name := oSch.Tables.BuildUniqueName(Name);
      oSch.Tables.Add(oTab);
    end
    else
      oTab.Name := Name;
    if AWithFields then
      InitColumnsFromFieldDefs(FieldDefs, oTab, oSch);
  except
    ADFree(oTab);
    raise;
  end;
  AttachTable(oTab, nil);
  oTab.RemRef;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CreateDataSet;
begin
  CheckInactive;
  Active := True;
end;

{-------------------------------------------------------------------------------}
{ Streaming }

procedure TADDataSet.LoadFromStorage(AStream: TStream; const AFileName: String;
  AFormat: TADStorageFormat);
begin
  ASSERT(DoGetDatSManager <> nil);
  DisableControls;
  try
    Close;
    FieldDefs.Updated := False;
    IndexDefs.Updated := False;
{$IFNDEF FPC}
    DataSetField := nil;
{$ENDIF}
    FStorage := ADStorageManager().GetStorage(AFileName, AFormat,
      ResourceOptions, FEncoder);
    try
      FStorage.Open(AFileName, AStream, smRead);
      Active := True;
    finally
      ADFreeAndNil(FStorage);
    end;
  finally
    EnableControls;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SaveToStorage(const AFileName: String; AStream: TStream;
  AFormat: TADStorageFormat);
begin
  ASSERT(DoGetDatSManager <> nil);
  if Active then begin
    CheckBrowseMode;
    CheckFetchedAll;
  end;
  FStorage := ADStorageManager().GetStorage(AFileName, AFormat,
    ResourceOptions, FEncoder);
  try
    FStorage.Open(AFileName, AStream, smWrite);
    InternalSaveToStorage;
  finally
    ADFreeAndNil(FStorage);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalLoadFromStorage;
var
  oTabs: TADDatSTableArray;
begin
  StartWait;
  try
    DoGetDatSManager.LoadFromStorage(FStorage);
    oTabs := DoGetDatSManager.RootTables;
    if Length(oTabs) > 0 then
      AttachTable(oTabs[0], nil);
    FLastSavePoint := DoGetDatSManager.Updates.SavePoint;
    FSourceEOF := True;
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.InternalSaveToStorage;
begin
  StartWait;
  try
    DoGetDatSManager.SaveToStorage(FStorage);
    FLastSavePoint := DoGetDatSManager.Updates.SavePoint;
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.LoadFromStream(AStream: TStream; AFormat: TADStorageFormat);
begin
  LoadFromStorage(AStream, '', AFormat);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.LoadFromFile(const AFileName: String; AFormat: TADStorageFormat);
begin
  LoadFromStorage(nil, AFileName, AFormat);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SaveToStream(AStream: TStream; AFormat: TADStorageFormat);
begin
  SaveToStorage('', AStream, AFormat);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SaveToFile(const AFileName: String; AFormat: TADStorageFormat);
begin
  SaveToStorage(AFileName, nil, AFormat);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.LoadFromFileAtOpen: Boolean;
begin
  Result := (DataSetField = nil) and (ParentDataSet = nil) and (DoGetDatSManager <> nil) and
    (FStorage = nil) and ResourceOptions.Persistent and FileExists(ResourceOptions.ResolveFileName());
end;

{-------------------------------------------------------------------------------}
function TADDataSet.SaveToFileAtClose: Boolean;
begin
  Result := (DataSetField = nil) and (ParentDataSet = nil) and (DoGetDatSManager <> nil) and
    (FStorage = nil) and ResourceOptions.Persistent and (ResourceOptions.ResolveFileName() <> '') and
    ((FLastSavePoint < DoGetDatSManager.Updates.SavePoint) or
     not FileExists(ResourceOptions.ResolveFileName()));
end;

{-------------------------------------------------------------------------------}
function TADDataSet.SaveToDFM: Boolean;
begin
  Result := False; // nothing more
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DefineProperties(AFiler: TFiler);
begin
  inherited DefineProperties(AFiler);
  AFiler.DefineBinaryProperty('Content', ReadContent, WriteContent, SaveToDFM);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ReadContent(AReader: TStream);
var
  oCont: TMemoryStream;
begin
  oCont := TMemoryStream.Create;
  oCont.CopyFrom(AReader, 0);
  oCont.Position := 0;
  FStorage := ADStorageManager().GetStorage('', sfBinary,
    ResourceOptions, FEncoder);
  FStorage.OwnStream := True;
  FStorage.Open('', oCont, smRead);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.WriteContent(AWriter: TStream);
begin
  SaveToStream(AWriter, sfBinary);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.Loaded;
begin
  try
    inherited Loaded;
    try
      if (dfStreamedActive in FFlags) and DoStoredActivation then
        Active := True;
    except
      if csDesigning in ComponentState then
        ADHandleException
      else
        raise;
    end;
  finally
    Exclude(FFlags, dfStreamedActive);
    ADFreeAndNil(FStorage);
  end;
end;

{-------------------------------------------------------------------------------}
{ Delta management }

type
  TADDataSetIntfImpl = class(TInterfacedObject, IADDataSetReference)
  private
    FView: TADDatSView;
    FOwnView: Boolean;
  protected
    { IADDataSetReference }
    function GetDataView: TADDatSView;
  public
    constructor Create(AView: TADDatSView; AOwnView: Boolean);
    destructor Destroy; override;
  end;

{-------------------------------------------------------------------------------}
constructor TADDataSetIntfImpl.Create(AView: TADDatSView; AOwnView: Boolean);
begin
  inherited Create;
  FView := AView;
  FOwnView := AOwnView;
end;

{-------------------------------------------------------------------------------}
destructor TADDataSetIntfImpl.Destroy;
begin
  if FOwnView and (FView <> nil) then
    ADFree(FView);
  FView := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADDataSetIntfImpl.GetDataView: TADDatSView;
begin
  Result := FView;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetData: IADDataSetReference;
begin
  CheckBrowseMode;
  if FView <> nil then
    Result := TADDataSetIntfImpl.Create(FView, False)
  else if FTable <> nil then
    Result := TADDataSetIntfImpl.Create(FTable.FullView, False)
  else
    Result := TADDataSetIntfImpl.Create(nil, False);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetFilteredData: IADDataSetReference;
begin
  CheckBrowseMode;
  if FSourceView <> nil then
    Result := TADDataSetIntfImpl.Create(FSourceView, False)
  else
    Result := GetData;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetDataView: TADDatSView;
begin
  Result := FilteredData.GetDataView;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetData(const AValue: IADDataSetReference);
var
  oView: TADDatSView;
begin
  CheckInactive;
  if (AValue <> nil) and (AValue.DataView <> nil) then begin
    InitTable(False);
    oView := AValue.DataView;
    if oView.Table.HasChanges([rsInserted, rsDeleted, rsModified]) then
      CachedUpdates := True;
    FTable.Columns.Assign(oView.Table.Columns);
    FTable.Import(oView);
    FieldDefs.Updated := False;
    Open;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetDelta: IADDataSetReference;
var
  oView: TADDatSView;
begin
  CheckBrowseMode;
  if FTable <> nil then begin
    oView := FTable.GetChangesView();
    oView.Creator := vsDataSetDelta;
    Result := TADDataSetIntfImpl.Create(oView, True);
  end
  else
    Result := TADDataSetIntfImpl.Create(nil, False);
end;

{-------------------------------------------------------------------------------}
{ Cached updates }

procedure TADDataSet.CheckCachedUpdatesMode;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADDataSet.DoApplyUpdates(ATable: TADDatSTable; AMaxErrors: Integer): Integer;
var
  eAction: TADErrorAction;
  oRow, oNextRow: TADDatSRow;
  oJournal: TADDatSUpdatesJournal;
begin
  Result := 0;
  oJournal := Updates;
  if oJournal = nil then
    Exit;
  oJournal.Lock;
  try
    oRow := oJournal.FirstChange(ATable);
    while oRow <> nil do begin
      oNextRow := oJournal.NextChange(oRow, ATable);
      try
        eAction := eaApplied;
        case oRow.RowState of
        rsInserted: DoUpdateRecordHandler(oRow, arInsert, [uoNoSrvRecord], eAction);
        rsDeleted:  DoUpdateRecordHandler(oRow, arDelete, [], eAction);
        rsModified: DoUpdateRecordHandler(oRow, arUpdate, [], eAction);
        else        eAction := eaSkip;
        end;
      except
        on E: Exception do begin
          if E is EADException then
            oRow.RowError := EADException(E);
          eAction := eaFail;
        end;
      end;
      if eAction = eaFail then begin
        Inc(Result);
        if (AMaxErrors <> -1) and (Result > AMaxErrors) then
          Exit;
      end;
      oRow := oNextRow;
    end;
  finally
    oJournal.Unlock;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoCachedUpdatesChanged;
var
  oFtch: TADFetchOptions;
begin
  oFtch := FetchOptions;
  if CachedUpdates and not (fiDetails in oFtch.Cache) then
    oFtch.Cache := oFtch.Cache + [fiDetails];
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetCachedUpdates: Boolean;
begin
  Result := FCachedUpdates;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetCachedUpdates(const AValue: Boolean);
begin
  if FCachedUpdates <> AValue then begin
    if not AValue and UpdatesPending then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSCantOffCachedUpdates,
        [GetDisplayName]);
    FCachedUpdates := AValue;
    DoCachedUpdatesChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetUpdates: TADDatSUpdatesJournal;
begin
  Result := nil;
  if FTable <> nil then begin
    if FTable.UpdatesRegistry then
      Result := FTable.Updates
    else if (FTable.Manager <> nil) and FTable.Manager.UpdatesRegistry then
      Result := FTable.Manager.Updates;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetSavePoint: Integer;
begin
  CheckBrowseMode;
  CheckCachedUpdatesMode;
  if Updates <> nil then
    Result := Updates.SavePoint
  else
    Result := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.SetSavePoint(const AValue: Integer);
begin
  Cancel;
  CheckBrowseMode;
  CheckCachedUpdatesMode;
  UpdateCursorPos;
  if (AValue <> -1) and (Updates <> nil) then begin
    Updates.SavePoint := AValue;
    CursorPosChanged;
    Resync([]);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetUpdatesPending: Boolean;
begin
  Result := False;
  if Active and (Updates <> nil) then
    Result := Updates.FirstChange(FTable) <> nil;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetChangeCount: Integer;
var
  oRow: TADDatSRow;
begin
  Result := 0;
  if Active and (Updates <> nil) then begin
    oRow := Updates.FirstChange(FTable);
    while oRow <> nil do begin
      Inc(Result);
      oRow := Updates.NextChange(oRow, FTable);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.RevertRecord;
var
  oRow: TADDatSRow;
begin
  Cancel;
  CheckBrowseMode;
  CheckCachedUpdatesMode;
  UpdateCursorPos;
  if (FRecordIndex >= 0) and (FRecordIndex < FSourceView.Rows.Count) then begin
    oRow := FSourceView.Rows.ItemsI[FRecordIndex];
    if oRow.RowState in [rsInserted, rsDeleted, rsModified] then begin
      oRow.RejectChanges;
      CursorPosChanged;
      Resync([]);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CommitUpdates;
begin
  CheckBrowseMode;
  CheckCachedUpdatesMode;
  if Updates <> nil then begin
    Updates.AcceptChanges(FTable);
    UpdateCursorPos;
    Resync([]);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.UndoLastChange(AFollowChange: Boolean): Boolean;
var
  oRow: TADDatSRow;
begin
  Cancel;
  CheckBrowseMode;
  CheckCachedUpdatesMode;
  UpdateCursorPos;
  Result := UpdatesPending;
  if Result then begin
    oRow := Updates.LastChange(FTable);
    if oRow.RowState = rsDeleted then begin
      oRow.RejectChanges;
      FRecordIndex := FSourceView.IndexOf(oRow);
    end
    else begin
      FRecordIndex := FSourceView.IndexOf(oRow);
      oRow.RejectChanges;
    end;
    if AFollowChange and (FRecordIndex <> -1) then begin
      CursorPosChanged;
      Resync([]);
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.CancelUpdates;
begin
  SetSavePoint(0);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoBeforeApplyUpdate;
begin
  if Assigned(FBeforeApplyUpdates) then
    FBeforeApplyUpdates(Self);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.DoAfterApplyUpdate(AErrors: Integer);
begin
  if Assigned(FAfterApplyUpdates) then
    FAfterApplyUpdates(Self, AErrors);
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.ApplyUpdatesComplete(AErrors: Integer);
begin
  DoAfterApplyUpdate(AErrors);
  if FParentDataSet = nil then
    if FTable.HasErrors then
      Reconcile
    else if FAutoCommitUpdates then
      CommitUpdates
    else
      Resync([]);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.ApplyUpdates(AMaxErrors: Integer = -1): Integer;
begin
  StartWait;
  try
    DoBeforeApplyUpdate;
    CheckBrowseMode;
    CheckCachedUpdatesMode;
    UpdateCursorPos;
    ClearRecordIndex;
    if FParentDataSet <> nil then
      Result := FParentDataSet.ApplyUpdates(AMaxErrors)
    else
      Result := DoApplyUpdates(FTable, AMaxErrors);
    if not DoIsSourceAsync then
      ApplyUpdatesComplete(Result);
  finally
    StopWait;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.Reconcile: Boolean;
var
  oRow, oNextRow: TADDatSRow;
  iAction: TADDAptReconcileAction;
  oWait: IADGUIxWaitCursor;
  oJournal: TADDatSUpdatesJournal;
begin
  CheckCachedUpdatesMode;
  oJournal := Updates;
  if (oJournal = nil) or not Assigned(OnReconcileError) then begin
    if FAutoCommitUpdates then
      CommitUpdates;
    Result := True;
    Exit;
  end;
  oJournal.Lock;
  try
    oRow := oJournal.FirstChange(FTable);
    while oRow <> nil do begin
      oNextRow := oJournal.NextChange(oRow, FTable);
      if oRow.HasErrors then begin
        if not ResourceOptions.ActualSilentMode then begin
          ADCreateInterface(IADGUIxWaitCursor, oWait);
          oWait.PushWait;
        end;
        try
          iAction := raMerge;
          DoReconcileErrorHandler(oRow, oRow.RowError, oRow.RowState, iAction);
        finally
          if not ResourceOptions.ActualSilentMode then
            oWait.PopWait;
        end;
        case iAction of
        raSkip:
          ;
        raAbort:
          Break;
        raMerge:
          begin
            oRow.ClearErrors;
            oRow.AcceptChanges;
          end;
        raCorrect:
          oRow.ClearErrors;
        raCancel:
          begin
            oRow.ClearErrors;
            oRow.RejectChanges;
          end;
        raRefresh:
          begin
            oRow.ClearErrors;
            BeginForceRow(oRow, False, True);
            try
              RefreshRecord;
            finally
              EndForceRow;
            end;
          end;
        end;
      end;
      oRow := oNextRow;
    end;
  finally
    oJournal.Unlock;
  end;
  Result := not oJournal.HasChanges(FTable);
  Resync([]);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.UpdateStatus: TUpdateStatus;
var
  pBuff: PADBuffer;
  oRow: TADDatSRow;
  iRowState: TADDatSRowState;
begin
  if not Active then
    Result := usUnmodified
  else if State = dsInternalCalc then
    Result := usUnmodified
  else begin
    if State = dsCalcFields then
      pBuff := CalcBuffer
    else
      pBuff := ActiveBuffer;
    oRow := GetRow(pBuff, False);
    if oRow = nil then
      Result := usUnmodified
    else begin
      if oRow.RowState in [rsEditing, rsCalculating, rsChecking] then
        iRowState := oRow.RowPriorState
      else
        iRowState := oRow.RowState;
      if iRowState = rsModified then
        Result := usModified
      else if (iRowState = rsDetached) and (State = dsInsert) then
        Result := usInserted
      else if iRowState in [rsDetached, rsDeleted] then
        Result := usDeleted
      else if iRowState = rsInserted then
        Result := usInserted
      else
        Result := usUnmodified;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.GetRowError: EADException;
var
  oRow: TADDatSRow;
  pBuff: PADBuffer;
begin
  Result := nil;
  if Active then begin
    if State in [dsCalcFields, dsInternalCalc] then
      pBuff := CalcBuffer
    else
      pBuff := ActiveBuffer;
    oRow := GetRow(pBuff, False);
    if oRow <> nil then
      Result := oRow.RowError;
  end;
end;

{-------------------------------------------------------------------------------}
{ Batch changes }
type
  TADDataSetDataLoadSave = record
    FIndActive: Boolean;
    FAggActive: Boolean;
    FSilentMode: Boolean;
    FRefreshMode: TADRefreshMode;
    FUpdateChangedFields: Boolean;
    FLockMode: TADLockMode;
    FUpdateMode: TUpdateMode;
    FCheckRequired: Boolean;
    FCheckReadOnly: Boolean;
    FCheckUpdatable: Boolean;
    FState: TADDatSLoadState;
  end;
  PADDataSetDataLoadSave = ^TADDataSetDataLoadSave;

procedure TADDataSet.BeginBatch(AWithDelete: Boolean = False);
var
  oUpdOpts: TADUpdateOptions;
  pState: PADDataSetDataLoadSave;
begin
  CheckBrowseMode;
  if FDataLoadSave <> nil then
    Exit;
  GetMem(FDataLoadSave, SizeOf(TADDataSetDataLoadSave));
  ADFillChar(FDataLoadSave^, SizeOf(TADDataSetDataLoadSave), 0);
  pState := PADDataSetDataLoadSave(FDataLoadSave);

  DisableControls;
  DisableConstraints;
  pState^.FIndActive := IndexesActive;
  IndexesActive := False;
  pState^.FAggActive := AggregatesActive;
  AggregatesActive := False;
  if AWithDelete then
    FTable.BeginLoadData(pState^.FState, lmMove)
  else
    FTable.BeginLoadData(pState^.FState);
  pState^.FSilentMode := ResourceOptions.SilentMode;
  ResourceOptions.SilentMode := True;
  oUpdOpts := GetUpdateOptions;
  if oUpdOpts <> nil then begin
    pState^.FRefreshMode := oUpdOpts.RefreshMode;
    pState^.FUpdateChangedFields := oUpdOpts.UpdateChangedFields;
    pState^.FLockMode := oUpdOpts.LockMode;
    pState^.FUpdateMode := oUpdOpts.UpdateMode;
    pState^.FCheckRequired := oUpdOpts.CheckRequired;
    pState^.FCheckReadOnly := oUpdOpts.CheckReadOnly;
    pState^.FCheckUpdatable := oUpdOpts.CheckUpdatable;
    oUpdOpts.FastUpdates := True;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.EndBatch;
var
  oUpdOpts: TADUpdateOptions;
  pState: PADDataSetDataLoadSave;
begin
  if FDataLoadSave = nil then
    Exit;
  try
    pState := PADDataSetDataLoadSave(FDataLoadSave);
    oUpdOpts := GetUpdateOptions;
    if oUpdOpts <> nil then begin
      oUpdOpts.RefreshMode := pState^.FRefreshMode;
      oUpdOpts.UpdateChangedFields := pState^.FUpdateChangedFields;
      oUpdOpts.LockMode := pState^.FLockMode;
      oUpdOpts.UpdateMode := pState^.FUpdateMode;
      oUpdOpts.CheckRequired := pState^.FCheckRequired;
      oUpdOpts.CheckReadOnly := pState^.FCheckReadOnly;
      oUpdOpts.CheckUpdatable := pState^.FCheckUpdatable;
    end;
    ResourceOptions.SilentMode := pState^.FSilentMode;
    if Active then begin
      FTable.EndLoadData(pState^.FState);
      IndexesActive := pState^.FIndActive;
      AggregatesActive := pState^.FAggActive;
    end
    else begin
      FIndexesActive := pState^.FIndActive;
      FAggregatesActive := pState^.FAggActive;
    end;
    EnableConstraints;
    if Active then
      Resync([]);
    EnableControls;
  finally
    FreeMem(FDataLoadSave, SizeOf(TADDataSetDataLoadSave));
    FDataLoadSave := nil;
  end;
end;

{-------------------------------------------------------------------------------}
{ IProviderSupport }

procedure TADDataSet.PSExecute;
begin
  Execute;
end;

{-------------------------------------------------------------------------------}
procedure TADDataSet.PSReset;
begin
{$IFNDEF AnyDAC_FPC}
  inherited PSReset;
{$ENDIF}  
  if Active and FetchOptions.AutoClose then begin
    Close;
    Open;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.PSGetDefaultOrder: TIndexDef;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.PSGetIndexDefs(IndexTypes: TIndexOptions): TIndexDefs;
begin
{$IFNDEF AnyDAC_FPC}
  Result := GetIndexDefs(IndexDefs, IndexTypes);
{$ELSE}
  Result := nil;
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D6}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}
function TADDataSet.PSGetKeyFields: String;
{$IFDEF AnyDAC_FPC}
var
  i: integer;
{$ENDIF}
begin
  if Fields.Count = 0 then begin
    Result := UpdateOptions.KeyFields;
    Exit;
  end;
{$IFNDEF AnyDAC_FPC}
  Result := inherited PSGetKeyFields;
{$ELSE}
  Result := '';
  for i := 0 to Fields.Count - 1 do
    if pfInKey in Fields[i].ProviderFlags then begin
      if Result <> '' then
        Result := Result + ';';
      Result := Result + Fields[i].FieldName;
    end;
{$ENDIF}
end;
{$IFDEF AnyDAC_D6}
  {$WARN SYMBOL_DEPRECATED ON}
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADDataSet.DoGetTableName: String;
begin
  // nothing
  Result := '';
end;

{-------------------------------------------------------------------------------}
function TADDataSet.PSGetTableName: String;
begin
  Result := UpdateOptions.UpdateTableName;
  if (Result = '') and (FTable <> nil) then
    Result := FTable.ActualOriginName;
  if Result = '' then
    Result := DoGetTableName;
  // Remove '[' and ']', because TSQLResolver.InitTreeData is not recognizing
  // them as the quote chars, and will enclose already quoted table name into '"'.
  if (Result <> '') and (Result[1] = '[') and (Result[Length(Result)] = ']') then
    Result := Copy(Result, 2, Length(Result) - 2);
end;

{-------------------------------------------------------------------------------}
function TADDataSet.PSGetUpdateException(E: Exception; Prev: EUpdateError): EUpdateError;
var
  PrevErr: Integer;
begin
  if Prev <> nil then
    PrevErr := Prev.ErrorCode
  else
    PrevErr := 0;
  if (E is EADDBEngineException) and (EADDBEngineException(E).ErrorCount > 0) then
    Result := EUpdateError.Create(E.Message, '',
      EADDBEngineException(E).Errors[0].ErrorCode, PrevErr, E)
  else begin
{$IFNDEF AnyDAC_FPC}
    Result := inherited PSGetUpdateException(E, Prev);
{$ELSE}
    if Prev <> nil then
      PrevErr := Prev.ErrorCode
    else
      PrevErr := 0;
    Result := EUpdateError.Create(E.Message, '', 1, PrevErr, E);
{$ENDIF}
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataSet.PSUpdateRecord(AUpdateKind: TUpdateKind; ADelta: TDataSet): Boolean;
var
  lPrevActive: Boolean;
  sPrevPos: {$IFDEF AnyDAC_D12} TBookmark {$ELSE} TBookmarkStr {$ENDIF};

  function LocateRecord: Boolean;
  var
    sField, sKeyFields: String;
    i, j: Integer;
    oFld: TField;
    vKeyValues: Variant;
  begin
    sKeyFields := PSGetKeyFields;
    if sKeyFields = '' then begin
      Result := False;
      Exit;
    end;

    i := 1;
    j := 0;
    vKeyValues := VarArrayCreate([0, 15], varVariant);
    while i <= Length(sKeyFields) do begin
      if j > 15 then begin
        Result := False;
        Exit;
      end;
      sField := ADExtractFieldName(sKeyFields, i);
      if ADelta is TADDataSet then
        oFld := TADDataSet(ADelta).InternalFieldByName(sField, 'PSGetKeyFields')
      else
        oFld := ADelta.FieldByName(sField);
      vKeyValues[j] := oFld.OldValue;
      if VarIsEmpty(vKeyValues[j]) then
        vKeyValues[j] := oFld.Value;
      Inc(j);
    end;
    VarArrayRedim(vKeyValues, j - 1);

    Result := Locate(sKeyFields, vKeyValues, []);
  end;

begin
  Result := False;
  lPrevActive := Active;
  DisableControls;
  try
    if not Active then
      Open
    else
      sPrevPos := Bookmark;
    try
      case AUpdateKind of
      ukModify:
        if LocateRecord then begin
          Edit;
          CopyRecordBase(ADelta, True);
          Post;
          Result := True;
        end;
      ukInsert:
        begin
          Append;
          CopyRecordBase(ADelta, True);
          Post;
          Result := True;
        end;
      ukDelete:
        if LocateRecord then begin
          Delete;
          Result := True;
        end;
      end;
    finally
      if not lPrevActive then
        Close
      else if {$IFDEF AnyDAC_D12} BookmarkValid {$ELSE} BookmarkStrValid {$ENDIF} (sPrevPos) then
        Bookmark := sPrevPos;
    end;
  finally
    EnableControls;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADBlobStream                                                                 }
{-------------------------------------------------------------------------------}
constructor TADBlobStream.Create(AField: TField; AMode: TBlobStreamMode);
var
  oFtch: TADFetchOptions;
begin
  inherited Create;
  FField := AField;
  FDataSet := FField.DataSet as TADDataSet;
  if not (FDataSet.State in [dsInsert, dsSetKey, dsFilter, dsNewValue]) then begin
    oFtch := FDataSet.FetchOptions;
    if (FField is TBlobField) and (oFtch.Mode <> fmManual) and
       (not (fiBlobs in oFtch.Items) or not (fiBlobs in oFtch.Cache)) then begin
      Include(FDataSet.FFlags, dfOpenBlob);
      try
        FDataSet.FetchBlobs;
      finally
        Exclude(FDataSet.FFlags, dfOpenBlob);
      end;
    end;
  end;
  if FDataSet.GetActiveRecBuf(FBuffer) then begin
    if (AMode <> bmRead) and not FDataSet.IsForceRowMode then begin
      if FField.ReadOnly and FDataSet.UpdateOptions.CheckReadOnly then
        DatabaseErrorFmt({$IFNDEF AnyDAC_FPC} SFieldReadOnly {$ELSE} SReadOnlyField {$ENDIF},
          [FField.DisplayName], FDataSet);
      if not (FDataSet.State in [dsEdit, dsInsert, dsNewValue]) then
        DatabaseError(SNotEditing, FDataSet);
    end;
    FMode := AMode;
    if AMode = bmWrite then
      Truncate
    else
      ReadBlobData;
  end;
  Position := 0;
  FWritten := False;
end;

{-------------------------------------------------------------------------------}
destructor TADBlobStream.Destroy;
var
  oRow: TADDatSRow;
  oCol: TADDatSColumn;
  iColIndex: Integer;
  iLen: LongWord;
  pBuff: Pointer;
begin
  if FModified then
    try
      oCol := nil;
      iColIndex := -1;
      oRow := nil;
      if FDataSet.GetFieldColumn(FBuffer, FField.FieldNo, oCol, iColIndex, oRow, True) then begin
        if oRow.RowState in [rsInserted, rsModified, rsUnchanged] then
          oRow.BeginEdit;
        iLen := LongWord(Size);
        if (FField is TADWideMemoField)
{$IFNDEF AnyDAC_FPC}
           or (FField is TWideStringField)
{$ENDIF}
{$IFDEF AnyDAC_D10}
           or (FField is TWideMemoField)
{$ENDIF}
           then
          iLen := iLen div SizeOf(WideChar);
        // Written zero-length value -> Write is called, Memory=nil, FWritten=True
        // Written NULL value -> Write is not called, Memory=nil, FWritten=False
        pBuff := Memory;
        if (pBuff = nil) and (iLen = 0) and FWritten then
          pBuff := Self;
        oRow.SetData(iColIndex, pBuff, iLen);
        if FField is TBlobField then
          TBlobField(FField).Modified := True;
        FDataSet.DataEvent(deFieldChange, TADNativeInt(FField));
      end;
    except
      FDataSet.InternalHandleException;
    end;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADBlobStream.Realloc(var ANewCapacity: {$IFDEF AnyDAC_FPC} TADNativeInt {$ELSE}
                                                                     LongInt {$ENDIF}): Pointer;
begin
  if FMode <> bmRead then
    Result := inherited Realloc(ANewCapacity)
  else
    Result := Memory;
end;

{-------------------------------------------------------------------------------}
procedure TADBlobStream.ReadBlobData;
var
  oRow: TADDatSRow;
  oCol: TADDatSColumn;
  pData: Pointer;
  iLen: LongWord;
  iColIndex: Integer;
begin
  oCol := nil;
  iColIndex := -1;
  oRow := nil;
  if FDataSet.GetFieldColumn(FBuffer, FField.FieldNo, oCol, iColIndex, oRow) then begin
    pData := nil;
    iLen := 0;
    if oRow.GetData(iColIndex, FDataSet.GetRowVersion, pData, 0, iLen, False) then begin
      if (FField is TADWideMemoField)
{$IFNDEF AnyDAC_FPC}
         or (FField is TWideStringField)
{$ENDIF}
{$IFDEF AnyDAC_D10}
         or (FField is TWideMemoField)
{$ENDIF}
         then
        iLen := iLen * SizeOf(WideChar);
      if FMode = bmRead then
        SetPointer(pData, iLen)
      else if iLen > 0 then begin
        SetSize(iLen);
        Move(pData^, Memory^, iLen);
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADBlobStream.Write(const ABuffer; ACount: Longint): Longint;
begin
  CheckWrite;
  Result := inherited Write(ABuffer, ACount);
  FModified := True;
  FWritten := True;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_D17}
function TADBlobStream.Write(const ABuffer: TBytes; AOffset, ACount: Integer): Longint;
begin
  CheckWrite;
  Result := inherited Write(ABuffer, AOffset, ACount);
  FModified := True;
  FWritten := True;
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
procedure TADBlobStream.Truncate;
begin
  CheckWrite;
  Clear;
  FModified := True;
end;

{-------------------------------------------------------------------------------}
procedure TADBlobStream.CheckWrite;
begin
  if not (FMode in [bmWrite, bmReadWrite]) then
    DatabaseErrorFmt({$IFNDEF AnyDAC_FPC} SFieldReadOnly {$ELSE} SReadOnlyField {$ENDIF},
      [FField.DisplayName], FDataSet);
end;

{-------------------------------------------------------------------------------}
{ TADWideMemoField                                                              }
{-------------------------------------------------------------------------------}
constructor TADWideMemoField.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetDataType({$IFDEF AnyDAC_WideMemo} ftWideMemo {$ELSE} ftFmtMemo {$ENDIF});
end;

{-------------------------------------------------------------------------------}
function TADWideMemoField.GetClassDesc: string;
begin
  Result := '(WideMemo)';
  if not IsNull then
    Result := AnsiUpperCase(Result);
end;

{-------------------------------------------------------------------------------}
function TADWideMemoField.GetAsString: String;
begin
  Result := GetAsWideString;
end;

{-------------------------------------------------------------------------------}
procedure TADWideMemoField.SetAsString(const AValue: String);
begin
  SetAsWideString(AValue);
end;

{-------------------------------------------------------------------------------}
function TADWideMemoField.GetAsWideString: TADWideString;
var
  iLen: Integer;
  oStr: TStream;
begin
  oStr := DataSet.CreateBlobStream(Self, bmRead);
  try
    iLen := Integer(oStr.Size);
    SetString(Result, nil, iLen div SizeOf(WideChar));
    oStr.ReadBuffer(PWideChar(Result)^, iLen);
  finally
    ADFree(oStr);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADWideMemoField.SetAsWideString(const AValue: TADWideString);
var
  oStr: TStream;
begin
  oStr := DataSet.CreateBlobStream(Self, bmWrite);
  try
    oStr.WriteBuffer(PWideChar(AValue)^, Length(AValue) * SizeOf(WideChar));
  finally
    ADFree(oStr);
  end;
end;

{-------------------------------------------------------------------------------}
function TADWideMemoField.GetAsVariant: Variant;
begin
  Result := GetAsWideString;
end;

{-------------------------------------------------------------------------------}
procedure TADWideMemoField.SetVarValue(const AValue: Variant);
begin
  SetAsWideString(AValue);
end;

{-------------------------------------------------------------------------------}
{ TADXMLField                                                                   }
{-------------------------------------------------------------------------------}
constructor TADXMLField.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetDataType(ftDBaseOle);
end;

{-------------------------------------------------------------------------------}
function TADXMLField.GetClassDesc: string;
begin
  Result := '(xml)';
  if not IsNull then
    Result := AnsiUpperCase(Result);
end;

{-------------------------------------------------------------------------------}
function TADXMLField.GetSchemaName: String;
begin
  if (DataSet <> nil) and DataSet.Active then
    Result := TADDataSet(DataSet).GetFieldColumn(Self).SourceDataTypeName
  else
    Result := '';
end;

{-------------------------------------------------------------------------------}
{ TADAutoIncField                                                               }
{-------------------------------------------------------------------------------}
constructor TADAutoIncField.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoIncrementSeed := -1;
  FAutoIncrementStep := -1;
  FClientAutoIncrement := True;
  FServerAutoIncrement := True;
  Required := False;
  ProviderFlags := [pfInWhere];
{$IFNDEF AnyDAC_FPC}
  AutoGenerateValue := DB.arAutoInc;
{$ENDIF}
  ReadOnly := True;
end;

{-------------------------------------------------------------------------------}
procedure TADAutoIncField.SetAutoIncrementSeed(const AValue: Integer);
begin
{$IFNDEF AnyDAC_FPC}
  if (DataSet <> nil) and (DataSet.Designer <> nil) then begin
    DataSet.Designer.BeginDesign;
    try
      FAutoIncrementSeed := AValue;
    finally
      DataSet.Designer.EndDesign;
    end;
  end
  else
{$ENDIF}
  begin
    CheckInactive;
    FAutoIncrementSeed := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAutoIncField.SetAutoIncrementStep(const AValue: Integer);
begin
{$IFNDEF AnyDAC_FPC}
  if (DataSet <> nil) and (DataSet.Designer <> nil) then begin
    DataSet.Designer.BeginDesign;
    try
      FAutoIncrementStep := AValue;
    finally
      DataSet.Designer.EndDesign;
    end;
  end
  else
{$ENDIF}
  begin
    CheckInactive;
    FAutoIncrementStep := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAutoIncField.SetClientAutoIncrement(const AValue: Boolean);
begin
{$IFNDEF AnyDAC_FPC}
  if (DataSet <> nil) and (DataSet.Designer <> nil) then begin
    DataSet.Designer.BeginDesign;
    try
      FClientAutoIncrement := AValue;
    finally
      DataSet.Designer.EndDesign;
    end;
  end
  else
{$ENDIF}
  begin
    CheckInactive;
    FClientAutoIncrement := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAutoIncField.SetServerAutoIncrement(const AValue: Boolean);

  procedure UpdateProps;
  begin
    if ServerAutoIncrement then begin
      Required := False;
      ProviderFlags := ProviderFlags - [pfInUpdate];
{$IFNDEF AnyDAC_FPC}
      AutoGenerateValue := DB.arAutoInc;
{$ENDIF}
      FAutoIncrementSeed := -1;
      FAutoIncrementStep := -1;
    end
    else begin
      ProviderFlags := ProviderFlags + [pfInUpdate];
{$IFNDEF AnyDAC_FPC}
      AutoGenerateValue := DB.arNone;
{$ENDIF}
      FAutoIncrementSeed := 1;
      FAutoIncrementStep := 1;
    end;
  end;

begin
  if ServerAutoIncrement <> AValue then
{$IFNDEF AnyDAC_FPC}
    if (DataSet <> nil) and (DataSet.Designer <> nil) then begin
      DataSet.Designer.BeginDesign;
      try
        FServerAutoIncrement := AValue;
        UpdateProps;
      finally
        DataSet.Designer.EndDesign;
      end;
    end
    else
{$ENDIF}
    begin
      CheckInactive;
      FServerAutoIncrement := AValue;
      UpdateProps;
    end;
end;

{-------------------------------------------------------------------------------}
function TADAutoIncField.GetIdentityInsert: Boolean;
begin
  Result := not ReadOnly and (pfInUpdate in ProviderFlags);
end;

{-------------------------------------------------------------------------------}
procedure TADAutoIncField.SetIdentityInsert(const AValue: Boolean);
begin
  if AValue then begin
    ReadOnly := False;
    ProviderFlags := ProviderFlags + [pfInUpdate];
  end
  else begin
    ReadOnly := True;
    ProviderFlags := ProviderFlags - [pfInUpdate];
  end;
end;

{-------------------------------------------------------------------------------}
{$IFDEF AnyDAC_FPC}
// FPC 2.2.2: any assigment ot TAutoIncField.AsVariant / AsLongInt
// fails with the "AutoInc Fields are read-only" exception
procedure TADAutoIncField.SetAsLongInt(AValue: Longint);
begin
  if CheckRange(AValue) then
    SetData(@AValue)
  else
    RangeError(AValue, Low(LongInt), High(LongInt));
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADSQLTimeIntervalField                                                       }
{-------------------------------------------------------------------------------}
constructor TADSQLTimeIntervalField.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetDataType({$IFDEF AnyDAC_D10} ftOraInterval {$ELSE} ftParadoxOle {$ENDIF});
end;

{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalField.GetIntervalKind: TADSQLTimeIntervalKind;
begin
  if (DataSet <> nil) and DataSet.Active then
    if TADDataSet(DataSet).GetFieldColumn(Self).DataType in [dtTimeIntervalFull, dtTimeIntervalDS] then
      Result := itDay2Second
    else
      Result := itYear2Month
  else
    Result := itUnknown;
end;

{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalField.GetClassDesc: string;
begin
  Result := '(SQLTimeInterval)';
  if not IsNull then
    Result := AnsiUpperCase(Result);
end;

{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalField.GetIntRec(var ARec: TADSQLTimeInterval): Boolean;
{$IFDEF AnyDAC_D17}
var
  aData: TValueBuffer;
{$ENDIF}
begin
{$IFDEF AnyDAC_D17}
  SetLength(aData, SizeOf(TADSQLTimeInterval));
  Result := GetData(aData, True);
  if Result then
    Move(aData[0], ARec, SizeOf(TADSQLTimeInterval))
{$ELSE}
  Result := GetData(@ARec, True);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalField.SetIntRec(var ARec: TADSQLTimeInterval);
begin
{$IFDEF AnyDAC_D17}
  SetData(BytesOf(@ARec, SizeOf(TADSQLTimeInterval)), True);
{$ELSE}
  SetData(@ARec, True);
{$ENDIF}
end;

{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalField.GetAsString: String;
var
  rInt: TADSQLTimeInterval;
begin
  if not GetIntRec(rInt) then
    Result := ''
  else
    Result := ADSQLTimeInterval2Str(rInt);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalField.SetAsString(const AValue: String);
var
  rInt: TADSQLTimeInterval;
begin
  if AValue = '' then
    Clear
  else begin
    rInt := ADStr2SQLTimeInterval(AValue);
    SetIntRec(rInt);
  end;
end;

{$IFDEF AnyDAC_D6Base}
{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalField.GetAsVariant: Variant;
var
  rInt: TADSQLTimeInterval;
begin
  if not GetIntRec(rInt) then
    Result := Null
  else
    Result := ADVarSQLTimeIntervalCreate(rInt);
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalField.SetVarValue(const AValue: Variant);
var
  rInt: TADSQLTimeInterval;
begin
  rInt := ADVar2SQLTimeInterval(AValue);
  SetIntRec(rInt);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
function TADSQLTimeIntervalField.GetAsInterval: TADSQLTimeInterval;
begin
  if not GetIntRec(Result) then
    Result := C_NullSQLTimeInterval;
end;

{-------------------------------------------------------------------------------}
procedure TADSQLTimeIntervalField.SetAsInterval(AValue: TADSQLTimeInterval);
begin
  SetIntRec(AValue);
end;

{-------------------------------------------------------------------------------}
{ TADIndex                                                                      }
{-------------------------------------------------------------------------------}
constructor TADIndex.Create(Collection: TCollection);
var
  oDS: TADDataSet;
begin
  inherited Create(Collection);
  oDS := DataSet;
  if oDS <> nil then
    FOptions := oDS.FormatOptions.SortOptions;
end;

{-------------------------------------------------------------------------------}
destructor TADIndex.Destroy;
begin
  Selected := False;
  DeleteView;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADIndex.GetDisplayName: string;
begin
  if Name = '' then
    Result := inherited GetDisplayName
  else
    Result := Name;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.Assign(ASource: TPersistent);
var
  opts: TADSortOptions;
  oDS: TADDataSet;
begin
  if ASource is TADIndex then begin
    FActive := TADIndex(ASource).Active;
    FName := TADIndex(ASource).Name;
    FFields := TADIndex(ASource).Fields;
    FCaseInsFields := TADIndex(ASource).CaseInsFields;
    FDescFields := TADIndex(ASource).DescFields;
    FExpression := TADIndex(ASource).Expression;
    FOptions := TADIndex(ASource).Options;
    FFilter := TADIndex(ASource).Filter;
    FFilterOptions := TADIndex(ASource).FilterOptions;
    FDistinct := TADIndex(ASource).Distinct;
    if DataSet = TADIndex(ASource).DataSet then
      FView := TADIndex(ASource).FView
    else
      FView := nil;
    if FView <> nil then
      FView.AddRef
    else
      IndexChanged;
  end
  else if ASource is TIndexDef then begin
    FName := TIndexDef(ASource).Name;
    oDS := DataSet;
    if oDS <> nil then
      opts := oDS.FormatOptions.SortOptions
    else
      opts := [];
    if (ixPrimary in TIndexDef(ASource).Options) or (ixUnique in TIndexDef(ASource).Options) then
      Include(opts, soUnique);
    if ixPrimary in TIndexDef(ASource).Options then
      Include(opts, soPrimary);
    if ixDescending in TIndexDef(ASource).Options then
      Include(opts, soDescending);
    if ixCaseInsensitive in TIndexDef(ASource).Options then
      Include(opts, soNoCase);
    FOptions := opts;
    FFields := TIndexDef(ASource).Fields;
{$IFNDEF AnyDAC_FPC}
    FDescFields := TIndexDef(ASource).DescFields;
    FCaseInsFields := TIndexDef(ASource).CaseInsFields;
{$ENDIF}
    FExpression := TIndexDef(ASource).Expression;
    FFilter := '';
    FFilterOptions := [];
    FDistinct := False;
    FActive := not (ixNonMaintained in TIndexDef(ASource).Options);
    IndexChanged;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.AssignTo(ADest: TPersistent);
var
  opts: TIndexOptions;
begin
  if ADest is TIndexDef then begin
    TIndexDef(ADest).Name := Name;
    if Fields <> '' then begin
      TIndexDef(ADest).Fields := Fields;
{$IFNDEF AnyDAC_FPC}
      TIndexDef(ADest).CaseInsFields := CaseInsFields;
      TIndexDef(ADest).DescFields := DescFields;
{$ENDIF}
    end
{$IFNDEF AnyDAC_FPC}
    else if Expression <> '' then
      TIndexDef(ADest).Expression := Expression
{$ENDIF}
    ;
    opts := [];
    if soPrimary in Options then
      Include(opts, ixPrimary);
    if soUnique in Options then
      Include(opts, ixUnique);
    if soDescending in Options then
      Include(opts, ixDescending);
    if soNoCase in Options then
      Include(opts, ixCaseInsensitive);
    if not Active then
      Include(opts, ixNonMaintained);
    TIndexDef(ADest).Options := opts;
  end
  else
    inherited AssignTo(ADest);
end;

{-------------------------------------------------------------------------------}
function TADIndex.GetDataSet: TADDataSet;
begin
  if Collection <> nil then
    Result := TADIndexes(Collection).FDataSet
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADIndex.GetActualActive: Boolean;
begin
  Result := Active and (FUpdateCount = 0) and
    (DataSet <> nil) and (DataSet.FTable <> nil) and DataSet.IndexesActive;
end;

{-------------------------------------------------------------------------------}
function TADIndex.GetSelected: Boolean;
var
  oDS: TADDataSet;
begin
  oDS := DataSet;
  Result := (oDS <> nil) and (
    (Name <> '') and ({$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
      (oDS.IndexName, Name) = 0) or
    (Fields <> '') and ({$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
      (oDS.IndexFieldNames, Fields) = 0));
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetSelected(const AValue: Boolean);
var
  oDS: TADDataSet;
begin
  oDS := DataSet;
  if (oDS <> nil) and (Selected <> AValue) and
     not (dfPreserveCurrentIndex in oDS.FFlags) then
    if not AValue then begin
      oDS.IndexName := '';
      oDS.IndexFieldNames := '';
    end
    else begin
      Active := True;
      oDS.IndexName := Name;
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.DeleteView;
begin
  if FView <> nil then begin
    FView.RemRef;
    FView := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.CreateView;
begin
  try
    FView := TADIndexes(Collection).FDataSet.BuildViewForIndex(Self);
  except
    Active := False;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.IndexChanged;
var
  oDS: TADDataSet;
  lReset: Boolean;

  procedure DeleteCreateView;
  begin
    if ActualActive then begin
      DeleteView;
      CreateView;
    end
    else
      DeleteView;
  end;

begin
  if FUpdateCount = 0 then begin
    oDS := DataSet;
    lReset := (oDS <> nil) and (FView <> nil) and (oDS.FSortView = FView);
    if lReset then begin
      oDS.DisableControls;
      try
        try
          oDS.SetSortView(nil);
          DeleteCreateView;
        finally
          if FView = nil then begin
            oDS.FIndexName := '';
            oDS.FLocalIndexName := '';
            oDS.FIndexFieldNames := '';
            oDS.SetSortView(nil);
          end
          else begin
            oDS.CheckFetchedAllBeforeSorting;
            if oDS.FIndexName <> '' then begin
              oDS.FIndexName := Name;
              oDS.FLocalIndexName := Name;
            end;
            if oDS.FIndexFieldNames <> '' then
              oDS.FIndexFieldNames := Fields;
            oDS.SetSortView(FView);
          end;
        end;
      finally
        oDS.EnableControls;
      end;
    end
    else
      DeleteCreateView;
    if oDS <> nil then
      oDS.IndexDefs.Updated := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.EndUpdate;
begin
  if FUpdateCount > 0 then begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetActive(const AValue: Boolean);
begin
  if FActive <> AValue then begin
    FActive := AValue;
    if FActive and
       ((Name = '') or (Fields = '') and (Expression = '') and (Filter = '')) and
       (DataSet <> nil) and not (csReading in DataSet.ComponentState) then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSIndNotComplete,
        [Name, DataSet.GetDisplayName]);
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetCaseInsFields(const AValue: string);
begin
  if FCaseInsFields <> AValue then begin
    FCaseInsFields := AValue;
    FExpression := '';
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetDescFields(const AValue: string);
begin
  if FDescFields <> AValue then begin
    FDescFields := AValue;
    FExpression := '';
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetExpression(const AValue: string);
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    FFields := '';
    FDescFields := '';
    FCaseInsFields := '';
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetFields(const AValue: string);
begin
  if FFields <> AValue then begin
    FFields := AValue;
    FExpression := '';
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetFilter(const AValue: String);
begin
  if FFilter <> AValue then begin
    FFilter := AValue;
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetFilterOptions(const AValue: TADExpressionOptions);
begin
  if FFilterOptions <> AValue then begin
    FFilterOptions := AValue;
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetName(const AValue: String);
begin
  if FName <> AValue then begin
    FName := AValue;
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetOptions(const AValue: TADSortOptions);
begin
  if FOptions <> AValue then begin
    FOptions := AValue;
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndex.SetDistinct(const AValue: Boolean);
begin
  if FDistinct <> AValue then begin
    FDistinct := AValue;
    IndexChanged;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADIndexes                                                                    }
{-------------------------------------------------------------------------------}
constructor TADIndexes.Create(ADataSet: TADDataSet);
begin
  ASSERT(ADataSet <> nil);
  inherited Create(TADIndex);
  FDataSet := ADataSet;
end;

{-------------------------------------------------------------------------------}
function TADIndexes.GetOwner: TPersistent;
begin
  Result := FDataSet;
end;

{-------------------------------------------------------------------------------}
function TADIndexes.Add: TADIndex;
begin
  Result := TADIndex(inherited Add);
end;

{-------------------------------------------------------------------------------}
function TADIndexes.FindIndex(const AName: String): TADIndex;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
       (Items[i].Name, AName) = 0 then begin
      Result := Items[i];
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADIndexes.IndexByName(const AName: String): TADIndex;
begin
  Result := FindIndex(AName);
  if Result = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSIndNotFound,
      [AName, FDataSet.GetDisplayName]);
end;

{-------------------------------------------------------------------------------}
function TADIndexes.GetItems(AIndex: Integer): TADIndex;
begin
  Result := TADIndex(inherited Items[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADIndexes.SetItems(AIndex: Integer; const AValue: TADIndex);
begin
  inherited Items[AIndex] := AValue;
end;

{-------------------------------------------------------------------------------}
function TADIndexes.FindIndexForFields(const AFields: String;
  ARequiredOptions: TADSortOptions = [];
  AProhibitedOptions: TADSortOptions = []): TADIndex;
var
  i: Integer;
  oInd: TADIndex;
begin
  Result := nil;
  for i := 0 to Count - 1 do begin
    oInd := Items[i];
    if (oInd.Expression = '') and ((oInd.Filter = '') or oInd.Selected) and
       (Pos(AFields, oInd.Fields) = 1) and (
          (Length(AFields) = Length(oInd.Fields)) or
          (oInd.Fields[Length(AFields) + 1] = ';')) and
       (oInd.Options * ARequiredOptions = ARequiredOptions) and
       (oInd.Options * AProhibitedOptions = []) and
       not oInd.Distinct then begin
      Result := oInd;
      Break;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADIndexes.Build;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].IndexChanged;
end;

{-------------------------------------------------------------------------------}
procedure TADIndexes.Release;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].DeleteView;
end;

{$IFDEF AnyDAC_FPC}
{-------------------------------------------------------------------------------}
{ TCheckConstraint                                                              }
{-------------------------------------------------------------------------------}
procedure TCheckConstraint.Assign(Source: TPersistent);
begin
  if Source is TCheckConstraint then
  begin
    ImportedConstraint := TCheckConstraint(Source).ImportedConstraint;
    CustomConstraint := TCheckConstraint(Source).CustomConstraint;
    ErrorMessage := TCheckConstraint(Source).ErrorMessage;
  end
  else inherited Assign(Source);
end;

{-------------------------------------------------------------------------------}
function TCheckConstraint.GetDisplayName: string;
begin
  Result := ImportedConstraint;
  if Result = '' then Result := CustomConstraint;
  if Result = '' then Result := inherited GetDisplayName;
end;

{-------------------------------------------------------------------------------}
procedure TCheckConstraint.SetImportedConstraint(const Value: string);
begin
  if ImportedConstraint <> Value then
  begin
    FImportedConstraint := Value;
    Changed(True);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TCheckConstraint.SetCustomConstraint(const Value: string);
begin
  if CustomConstraint <> Value then
  begin
    FCustomConstraint := Value;
    Changed(True);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TCheckConstraint.SetErrorMessage(const Value: string);
begin
  if ErrorMessage <> Value then
  begin
    FErrorMessage := Value;
    Changed(True);
  end;
end;

{-------------------------------------------------------------------------------}
{ TCheckConstraints                                                             }
{-------------------------------------------------------------------------------}
constructor TCheckConstraints.Create(Owner: TPersistent);
begin
  inherited Create(TCheckConstraint);
  FOwner := Owner;
end;

{-------------------------------------------------------------------------------}
function TCheckConstraints.Add: TCheckConstraint;
begin
  Result := TCheckConstraint(inherited Add);
end;

{-------------------------------------------------------------------------------}
function TCheckConstraints.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

{-------------------------------------------------------------------------------}
function TCheckConstraints.GetItem(Index: Integer): TCheckConstraint;
begin
  Result := TCheckConstraint(inherited GetItem(Index));
end;

{-------------------------------------------------------------------------------}
procedure TCheckConstraints.SetItem(Index: Integer; Value: TCheckConstraint);
begin
  inherited SetItem(Index, Value);
end;
{$ENDIF}

{-------------------------------------------------------------------------------}
{ TADAggregate                                                                  }
{-------------------------------------------------------------------------------}
destructor TADAggregate.Destroy;
begin
  DeleteAggregate;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADAggregate.GetDisplayName: String;
begin
  if Name = '' then
    Result := inherited GetDisplayName
  else
    Result := Name;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.Assign(ASource: TPersistent);
begin
  if ASource is TADAggregate then begin
    FExpression := TADAggregate(ASource).Expression;
    FGroupingLevel := TADAggregate(ASource).GroupingLevel;
    FIndexName := TADAggregate(ASource).IndexName;
    FActive := TADAggregate(ASource).Active;
    FName := TADAggregate(ASource).Name;
    AggregateChanged;
  end
{$IFNDEF AnyDAC_FPC}
  else if ASource is TAggregateField then begin
    FExpression := TAggregateField(ASource).Expression;
    FGroupingLevel := TAggregateField(ASource).GroupingLevel;
    FIndexName := TAggregateField(ASource).IndexName;
    FActive := TAggregateField(ASource).Active;
    FName := C_AD_SysNamePrefix + '#' + TAggregateField(ASource).FieldName;
    AggregateChanged;
  end
{$ENDIF}
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.EndUpdate;
begin
  if FUpdateCount > 0 then begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      AggregateChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAggregate.GetActualActive: Boolean;
begin
  Result := (FExpression <> '') and Active and (FUpdateCount = 0) and
    (DataSet <> nil) and (DataSet.FTable <> nil) and DataSet.AggregatesActive;
end;

{-------------------------------------------------------------------------------}
function TADAggregate.GetDataSet: TADDataSet;
begin
  if Collection <> nil then
    Result := TADAggregates(Collection).FDataSet
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.DeleteAggregate;
begin
  if FAggregate <> nil then begin
    FAggregate.RemRef;
    FAggregate := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.CreateAggregate;
var
  oDS: TADDataSet;
begin
  oDS := DataSet;
  if (oDS = nil) or        // When we modifying index props we set to nil index view,
                           // and then to some index view. There will be moment when
                           // oDS.IndexName not empty, but there are no FSortView
     (IndexName <> '') and {(IndexName <> oDS.IndexName) then}
     ((oDS.FSortView = nil) or
      ({$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
        (IndexName, oDS.FSortView.Name) <> 0)) then
    Exit;
  if TADAggregates(Collection).FGroupingLevel < GroupingLevel then
    TADAggregates(Collection).FGroupingLevel := GroupingLevel;
  FAggregate := oDS.FSourceView.Aggregates.Add(Name, Expression, GroupingLevel);
  FAggregate.CountRef;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.AggregateChanged;
begin
  if FUpdateCount = 0 then begin
    if ActualActive then begin
      DeleteAggregate;
      CreateAggregate;
    end
    else
      DeleteAggregate;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.SetActive(const AValue: Boolean);
begin
  if FActive <> AValue then begin
    FActive := AValue;
    if FActive and
       ((Name = '') or (Expression = '')) and
       (DataSet <> nil) and not (csReading in DataSet.ComponentState) then
      ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSAggNotComplete,
        [Name, DataSet.GetDisplayName]);
    AggregateChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.SetExpression(const AValue: String);
begin
  if FExpression <> AValue then begin
    FExpression := AValue;
    AggregateChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.SetGroupingLevel(const AValue: Integer);
begin
  if FGroupingLevel <> AValue then begin
    FGroupingLevel := AValue;
    AggregateChanged;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregate.SetIndexName(const AValue: String);
begin
  if FIndexName <> AValue then begin
    FIndexName := AValue;
    AggregateChanged;
  end;
end;

{-------------------------------------------------------------------------------}
function TADAggregate.InternalUse(var ARecordIndex: Integer): Boolean;
var
  oDS: TADDataSet;
begin
  oDS := DataSet;
  if (oDS <> nil) and oDS.GetActiveRecBufRecordIndex(ARecordIndex) and
     (FAggregate <> nil) and FAggregate.ActualActive then
    Result := True
  else
    Result := False;
end;

{-------------------------------------------------------------------------------}
function TADAggregate.GetInUse: Boolean;
var
  iRecInd: Integer;
begin
  iRecInd := -1;
  Result := InternalUse(iRecInd);
end;

{-------------------------------------------------------------------------------}
function TADAggregate.GetValue: Variant;
var
  iRecInd: Integer;
begin
  iRecInd := -1;
  if InternalUse(iRecInd) then
    Result := FAggregate.Value[iRecInd]
  else
    Result := Null;
end;

{-------------------------------------------------------------------------------}
function TADAggregate.GetDataType: TADDataType;
begin
  if ActualActive then
    Result := FAggregate.DataType
  else
    Result := dtUnknown;
end;

{-------------------------------------------------------------------------------}
{ TADAggregates                                                                 }
{-------------------------------------------------------------------------------}
constructor TADAggregates.Create(ADataSet: TADDataSet);
begin
  ASSERT(ADataSet <> nil);
  inherited Create(TADAggregate);
  FDataSet := ADataSet;
end;

{-------------------------------------------------------------------------------}
function TADAggregates.GetOwner: TPersistent;
begin
  Result := FDataSet;
end;

{-------------------------------------------------------------------------------}
function TADAggregates.Add: TADAggregate;
begin
  Result := TADAggregate(inherited Add);
end;

{-------------------------------------------------------------------------------}
function TADAggregates.GetItems(AIndex: Integer): TADAggregate;
begin
  Result := TADAggregate(inherited Items[AIndex]);
end;

{-------------------------------------------------------------------------------}
procedure TADAggregates.SetItems(AIndex: Integer; const AValue: TADAggregate);
begin
  inherited Items[AIndex] := AValue;
end;

{-------------------------------------------------------------------------------}
function TADAggregates.FindAggregate(const AName: String): TADAggregate;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
       (Items[i].Name, AName) = 0 then begin
      Result := Items[i];
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADAggregates.AggregateByName(const AName: String): TADAggregate;
begin
  Result := FindAggregate(AName);
  if Result = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDS], er_AD_DSAggNotFound,
      [AName, FDataSet.GetDisplayName]);
end;

{-------------------------------------------------------------------------------}
procedure TADAggregates.Build;
var
  i: Integer;
begin
  FGroupingLevel := -1;
  for i := 0 to Count - 1 do
    Items[i].AggregateChanged;
  if FGroupingLevel = -1 then
    if (FDataSet <> nil) and (FDataSet.IndexName <> '') then
      FGroupingLevel := FDataSet.FSourceView.GroupingLevel
    else
      FGroupingLevel := 0;
end;

{-------------------------------------------------------------------------------}
procedure TADAggregates.Release;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].DeleteAggregate;
end;

end.
