{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{            FireDAC option support classes             }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADStanOption;

interface

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
  SysUtils, Classes, DB,
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ENDIF}
  uADStanIntf, uADStanUtil, uADStanConst;

type
  IADStanOptions = interface;
  TADCustomOptions = class;
  TADMapRule = class;
  TADMapRules = class;
  TADFormatOptions = class;
  TADFetchOptions = class;
  TADFetchOptionsClass = class of TADFetchOptions;
  TADUpdateOptions = class;
  TADBottomUpdateOptions = class;
  TADUpdateOptionsClass = class of TADUpdateOptions;
  TADResourceOptions = class;
  TADTopResourceOptions = class;
  TADBottomResourceOptions = class;
  TADResourceOptionsClass = class of TADResourceOptions;
  TADTxOptions = class;
  TADOptionsContainer = class;
  TADEventAlerterOptions = class;

  TADOptionChangeEvent = procedure (AOptions: TADCustomOptions) of object;

  TADFormatOptionValue = (fvMapRules, fvSE2Null, fvStrsTrim, fvStrsDivLen2,
    fvMaxStringSize, fvMaxBcdPrecision, fvMaxBcdScale, fvInlineDataSize,
    fvDefaultParamDataType, fvRound2Scale, fvDataSnapCompatibility,
    fvFmtDisplayDateTime, fvFmtDisplayDate, fvFmtDisplayTime, fvFmtDisplayNumeric,
    fvFmtEditNumeric, fvQuoteIdentifiers, fvSortLocale, fvSortOptions,
    fvStrsTrim2Len);
  TADFormatOptionValues = set of TADFormatOptionValue;

  TADFetchOptionValue = (evMode, evItems, evRecsSkip, evRecsMax, evRowsetSize,
    evCache, evAutoClose, evRecordCountMode, evUnidirectional, evCursorKind,
    evAutoFetchAll, evLiveWindowParanoic, evDetailDelay, evDetailOptimize,
    evDetailCascade, evLiveWindowFastFirst);
  TADFetchOptionValues = set of TADFetchOptionValue;

  TADFetchMode = (fmManual, fmOnDemand, fmAll, fmExactRecsMax);
  TADFetchItem = (fiBlobs, fiDetails, fiMeta);
  TADFetchItems = set of TADFetchItem;
  TADCursorKind = (ckAutomatic, ckDefault, ckDynamic, ckStatic, ckForwardOnly);
  TADAutoFetchAll = (afAll, afTruncate, afDisable);
  TADRecordCountMode = (cmVisible, cmFetched, cmTotal);

  TADUpdateOptionValue = (uvEDelete, uvEInsert, uvEUpdate, uvUpdateChngFields,
    uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode,
    uvRefreshDelete, uvCountUpdatedRecords, uvFetchGeneratorsPoint,
    uvGeneratorName, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable,
    uvUpdateNonBaseFields);
  TADUpdateOptionValues = set of TADUpdateOptionValue;

  TADActionRequest = (arNone, arFromRow, arSelect, arInsert, arUpdate, arDelete,
    arLock, arUnlock, arFetchRow, arUpdateHBlobs, arDeleteAll, arFetchGenerators);
  TADActionRequests = set of TADActionRequest;
  TADUpdateRequest = arInsert .. arFetchGenerators;
  TADUpdateRequests = set of TADUpdateRequest;
  TADUpdateRowOption = (uoCancelUnlock, uoImmediateUpd, uoDeferredLock,
    uoOneMomLock, uoNoSrvRecord, uoDeferredGenGet);
  TADUpdateRowOptions = set of TADUpdateRowOption;

  TADLockMode = (lmNone, lmPessimistic, lmOptimistic);
  TADLockPoint = (lpImmediate, lpDeferred);

  TADRefreshMode = (rmManual, rmOnDemand, rmAll);

  TADFetchGeneratorsPoint = (gpNone, gpImmediate, gpDeferred);

  TADResourceOptionValue = (rvParamCreate, rvMacroCreate, rvMacroExpand,
    rvParamExpand, rvEscapeExpand, rvMaxCursors, rvCmdExecMode, rvCmdExecTimeout,
    rvDirectExecute, rvDefaultParamType, rvServerOutput, rvServerOutputSize,
    rvPersistent, rvBackup, rvDefaultStoreFolder, rvDefaultStoreFormat,
    rvStoreVersion, rvStoreItems, rvBackupFolder, rvDefaultStoreExt,
    rvBackupExt, rvAutoConnect, rvAutoReconnect, rvArrayDMLSize, rvSilentMode,
    rvUnifyParams, rvKeepConnection);
  TADResourceOptionValues = set of TADResourceOptionValue;

  TADTxIsolation = (xiUnspecified, xiDirtyRead, xiReadCommitted, xiRepeatableRead,
    xiSnapshot, xiSerializible);
  TADTxAction = (xdNone, xdCommit, xdRollback);
  TADTxStopOption = (xoIfCmdsInactive, xoIfAutoStarted, xoFinishRetaining);
  TADTxStopOptions = set of TADTxStopOption;
  TADTxValue = (xoIsolation, xoReadOnly, xoParams, xoAutoStart, xoAutoStop,
    xoStopOptions, xoAutoCommit);
  TADTxValues = set of TADTxValue;

  IADStanOptions = interface (IUnknown)
    ['{3E9B315B-F456-4175-A864-B2573C4A2018}']
    // private
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetUpdateOptions: TADUpdateOptions;
    function GetResourceOptions: TADResourceOptions;
    function GetParentOptions: IADStanOptions;
    procedure SetParentOptions(const AValue: IADStanOptions);
    // public
    procedure ObjectDestroyed(AObj: TPersistent);
    // R/O
    property FetchOptions: TADFetchOptions read GetFetchOptions;
    property FormatOptions: TADFormatOptions read GetFormatOptions;
    property UpdateOptions: TADUpdateOptions read GetUpdateOptions;
    property ResourceOptions: TADResourceOptions read GetResourceOptions;
    // R/W
    property ParentOptions: IADStanOptions read GetParentOptions write SetParentOptions;
  end;

  TADOptionsParentCallback = procedure (out AOpts: IADStanOptions) of object;
  TADOptionsContainer = class(TInterfacedObject, IADStanOptions)
  private
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FOwnerObj: TPersistent;
    FFormatOptions: TADFormatOptions;
    FFetchOptions: TADFetchOptions;
    FUpdateOptions: TADUpdateOptions;
    FResourceOptions: TADResourceOptions;
    FParentOptions: IADStanOptions;
    FParentOriginalCallback: TADOptionsParentCallback;
    FParentCallback: TADOptionsParentCallback;
    procedure InternalParentOptionsCallback(out AOpts: IADStanOptions);
  protected
    // IADStanOptions
    function GetFetchOptions: TADFetchOptions;
    function GetFormatOptions: TADFormatOptions;
    function GetUpdateOptions: TADUpdateOptions;
    function GetResourceOptions: TADResourceOptions;
    function GetParentOptions: IADStanOptions;
    procedure SetParentOptions(const AValue: IADStanOptions);
    procedure ObjectDestroyed(AObj: TPersistent);
  public
    constructor Create(AOwnerObj: TPersistent; AFetchClass: TADFetchOptionsClass;
      AUpdateClass: TADUpdateOptionsClass; AResourceClass: TADResourceOptionsClass;
      AParentCallback: TADOptionsParentCallback);
    destructor Destroy; override;
  end;

  TADCustomOptions = class (TPersistent)
  private
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FContainer: TADOptionsContainer;
    FVersion: Longword;
    function GetOwnerObj: TPersistent;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AContainer: TADOptionsContainer); virtual;
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; virtual;
    property Container: TADOptionsContainer read FContainer;
    property Version: Longword read FVersion;
    property OwnerObj: TPersistent read GetOwnerObj;
  end;

  TADMapRule = class (TCollectionItem)
  private
    FPrecMax: Integer;
    FPrecMin: Integer;
    FScaleMax: Integer;
    FScaleMin: Integer;
    FSizeMax: LongWord;
    FSizeMin: LongWord;
    FSourceDataType: TADDataType;
    FTargetDataType: TADDataType;
    FNameMask: String;
    procedure SetSourceDataType(AValue: TADDataType);
    procedure SetTargetDataType(AValue: TADDataType);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property PrecMax: Integer read FPrecMax write FPrecMax default C_AD_DefMapPrec;
    property PrecMin: Integer read FPrecMin write FPrecMin default C_AD_DefMapPrec;
    property ScaleMax: Integer read FScaleMax write FScaleMax default C_AD_DefMapScale;
    property ScaleMin: Integer read FScaleMin write FScaleMin default C_AD_DefMapScale;
    property SizeMax: LongWord read FSizeMax write FSizeMax default C_AD_DefMapSize;
    property SizeMin: LongWord read FSizeMin write FSizeMin default C_AD_DefMapSize;
    property NameMask: String read FNameMask write FNameMask;
    property SourceDataType: TADDataType read FSourceDataType write
      SetSourceDataType default dtUnknown;
    property TargetDataType: TADDataType read FTargetDataType write
      SetTargetDataType default dtUnknown;
  end;

  TADMapRules = class(TCollection)
  private
    {$IFDEF AUTOREFCOUNT} [Weak] {$ENDIF} FFormatOptions: TADFormatOptions;
    function GetItems(AIndex: Integer): TADMapRule;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(AFormatOptions: TADFormatOptions);
    function Add: TADMapRule; overload;
    procedure Add(APrecMin, APrecMax, AScaleMin, AScaleMax: Integer;
      ASourceDataType, ATargetDataType: TADDataType); overload;
    procedure Add(ASizeMin, ASizeMax: Integer;
      ASourceDataType, ATargetDataType: TADDataType); overload;
    procedure Add(ASourceDataType, ATargetDataType: TADDataType); overload;
    procedure RemoveForSourceDataType(ADataType: TADDataType);
    procedure RemoveForTargetDataType(ADataType: TADDataType);
    property Items[AIndex: Integer]: TADMapRule read GetItems; default;
  end;

  TADFormatOptions = class (TADCustomOptions)
  private
    function GetStrsEmpty2Null: Boolean;
    function GetStrsTrim: Boolean;
    procedure SetStrsEmpty2Null(AValue: Boolean);
    procedure SetStrsTrim(AValue: Boolean);
    function GetMapRules: TADMapRules;
    function IsMRS: Boolean;
    function IsSE2NS: Boolean;
    function IsSTS: Boolean;
    procedure SetMapRules(const AValue: TADMapRules);
    function GetMaxStringSize: LongWord;
    function IsMSSS: Boolean;
    procedure SetMaxStringSize(const AValue: LongWord);
    function GetMaxBcdPrecision: Integer;
    function GetMaxBcdScale: Integer;
    function IsMBPS: Boolean;
    function IsMBSS: Boolean;
    procedure SetMaxBcdPrecision(const AValue: Integer);
    procedure SetMaxBcdScale(const AValue: Integer);
    procedure SetOwnMapRules(const AValue: Boolean);
    function GetStrsDivLen2: Boolean;
    function IsSDL2S: Boolean;
    procedure SetStrsDivLen2(const AValue: Boolean);
    function GetInlineDataSize: Integer;
    function IsIDSS: Boolean;
    procedure SetInlineDataSize(const AValue: Integer);
    procedure SetDefaultParamDataType(const AValue: TFieldType);
    function GetDefaultParamDataType: TFieldType;
    function IsDPDTS: Boolean;
    function GetRound2Scale: Boolean;
    function IsRSS: Boolean;
    procedure SetRound2Scale(const AValue: Boolean);
    function GetDataSnapCompatibility: Boolean;
    function IsDSCS: Boolean;
    procedure SetDataSnapCompatibility(const AValue: Boolean);
    function GetFmtDisplayDate: String;
    function GetFmtDisplayDateTime: String;
    function GetFmtDisplayNumeric: String;
    function GetFmtDisplayTime: String;
    function GetFmtEditNumeric: String;
    function IsFDDS: Boolean;
    function IsFDDTS: Boolean;
    function IsFDNS: Boolean;
    function IsFDTS: Boolean;
    function IsFENS: Boolean;
    procedure SetFmtDisplayDate(const AValue: String);
    procedure SetFmtDisplayDateTime(const AValue: String);
    procedure SetFmtDisplayNumeric(const AValue: String);
    procedure SetFmtDisplayTime(const AValue: String);
    procedure SetFmtEditNumeric(const AValue: String);
    function GetSortLocale: TADLocalID;
    function IsSLS: Boolean;
    procedure SetSortLocale(const AValue: TADLocalID);
    function GetSortOptions: TADSortOptions;
    function IsSOS: Boolean;
    procedure SetSortOptions(const AValue: TADSortOptions);
    function GetStrsTrim2Len: Boolean;
    function IsSTTLS: Boolean;
    procedure SetStrsTrim2Len(const AValue: Boolean);
    function GetQuoteIdentifiers: Boolean;
    function IsQIDS: Boolean;
    procedure SetQuoteIdentifiers(const AValue: Boolean);
  protected
    FMapRules: TADMapRules;
    FStrsEmpty2Null: Boolean;
    FStrsTrim: Boolean;
    FStrsTrim2Len: Boolean;
    FStrsDivLen2: Boolean;
    FAssignedValues: TADFormatOptionValues;
    FMaxStringSize: LongWord;
    FMaxBcdPrecision: Integer;
    FMaxBcdScale: Integer;
    FInlineDataSize: Integer;
    FDefaultParamDataType: TFieldType;
    FRound2Scale: Boolean;
    FDataSnapCompatibility: Boolean;
    FFmtDisplayDateTime: String;
    FFmtDisplayDate: String;
    FFmtDisplayTime: String;
    FFmtDisplayNumeric: String;
    FFmtEditNumeric: String;
    FQuoteIdentifiers: Boolean;
    FSortLocale: TADLocalID;
    FSortOptions: TADSortOptions;
  public
    constructor Create(AContainer: TADOptionsContainer); override;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
    function IsValueOwned(AValue: TADFormatOptionValue; out AParentOpts: IADStanOptions): Boolean;
    procedure ResolveDataType(const ASrcName: String;
      ASrcDataType: TADDataType; ASrcSize: LongWord; ASrcPrec, ASrcScale: Integer;
      var ADestDataType: TADDataType; var ADestSize: LongWord; AForward: Boolean);
    procedure ResolveFieldType(const ASrcName: String; ASrcFieldType: TFieldType;
      ASrcADFieldType: TADDataType; ASrcSize: LongWord; ASrcPrecision, ASrcScale: Integer;
      var ADestFieldType: TFieldType; var ADestSize: LongWord; var ADestPrecision,
      ADestScale: Integer; var ASrcDataType, ADestDataType: TADDataType; AForward: Boolean);
    procedure ColumnDef2FieldDef(ASrcDataType: TADDataType; ASrcSize: LongWord;
      ASrcPrec, ASrcScale: Integer; ASrcAttrs: TADDataAttributes;
      var ADestFieldType: TFieldType; var ADestSize: LongWord; var ADestPrec, ADestScale: Integer);
    class procedure FieldDef2ColumnDef(ASrcFieldType: TFieldType; ASrcSize: LongWord;
      ASrcPrec, ASrcScale: Integer; var ADestDataType: TADDataType; var ADestSize: LongWord;
      var ADestPrec, ADestScale: Integer; var ADestAttrs: TADDataAttributes); overload;
    class procedure FieldDef2ColumnDef(AField: TField; var ADestDataType: TADDataType;
      var ADestSize: LongWord; var ADestPrec, ADestScale: Integer;
      var ADestAttrs: TADDataAttributes); overload;
    class procedure FieldDef2ColumnDef(AFieldDef: TFieldDef; var ADestDataType: TADDataType;
      var ADestSize: LongWord; var ADestPrec, ADestScale: Integer;
      var ADestAttrs: TADDataAttributes); overload;
    procedure CheckConversion(ASrc, ADest: TADDataType);
    procedure ConvertRawData(ASrcType, ADestType: TADDataType; ApSrc: Pointer;
      ASrcSize: LongWord; var ApDest: Pointer; ADestMaxSize: LongWord;
      var ADestSize: LongWord; AEncoder: TADEncoder);
    // It is for DBX bug workaround
    property StrsDivLen2: Boolean read GetStrsDivLen2 write SetStrsDivLen2
      stored IsSDL2S default False;
  published
    property AssignedValues: TADFormatOptionValues read FAssignedValues
      write FAssignedValues default [];
    property OwnMapRules: Boolean read IsMRS write SetOwnMapRules default False;
    property MapRules: TADMapRules read GetMapRules write SetMapRules
      stored IsMRS;
    property StrsEmpty2Null: Boolean read GetStrsEmpty2Null write SetStrsEmpty2Null
      stored IsSE2NS default False;
    property StrsTrim: Boolean read GetStrsTrim write SetStrsTrim
      stored IsSTS default True;
    property StrsTrim2Len: Boolean read GetStrsTrim2Len write SetStrsTrim2Len
      stored IsSTTLS default False;
    property MaxStringSize: LongWord read GetMaxStringSize write SetMaxStringSize
      stored IsMSSS default C_AD_DefMaxStrSize;
    property MaxBcdPrecision: Integer read GetMaxBcdPrecision write SetMaxBcdPrecision
      stored IsMBPS default 18;
    property MaxBcdScale: Integer read GetMaxBcdScale write SetMaxBcdScale
      stored IsMBSS default 4;
    property InlineDataSize: Integer read GetInlineDataSize write
      SetInlineDataSize stored IsIDSS default C_AD_DefInlineDataSize;
    property DefaultParamDataType: TFieldType read GetDefaultParamDataType write
      SetDefaultParamDataType stored IsDPDTS default ftUnknown;
    property Round2Scale: Boolean read GetRound2Scale write SetRound2Scale
      stored IsRSS default False;
    property DataSnapCompatibility: Boolean read GetDataSnapCompatibility
      write SetDataSnapCompatibility stored IsDSCS default False;
    property FmtDisplayDateTime: String read GetFmtDisplayDateTime
      write SetFmtDisplayDateTime stored IsFDDTS;
    property FmtDisplayDate: String read GetFmtDisplayDate
      write SetFmtDisplayDate stored IsFDDS;
    property FmtDisplayTime: String read GetFmtDisplayTime
      write SetFmtDisplayTime stored IsFDTS;
    property FmtDisplayNumeric: String read GetFmtDisplayNumeric
      write SetFmtDisplayNumeric stored IsFDNS;
    property FmtEditNumeric: String read GetFmtEditNumeric
      write SetFmtEditNumeric stored IsFENS;
    property QuoteIdentifiers: Boolean read GetQuoteIdentifiers
      write SetQuoteIdentifiers stored IsQIDS default False;
    property SortLocale: TADLocalID read GetSortLocale write SetSortLocale
      stored IsSLS default LOCALE_USER_DEFAULT;
    property SortOptions: TADSortOptions read GetSortOptions write SetSortOptions
      stored IsSOS default [];
  end;

  TADFetchOptions = class (TADCustomOptions)
  private
    function GetRecsMax: Integer;
    function GetRowsetSize: Integer;
    function GetItems: TADFetchItems;
    function GetMode: TADFetchMode;
    procedure SetRecsMax(const AValue: Integer);
    procedure SetRowsetSize(const AValue: Integer);
    procedure SetItems(const AValue: TADFetchItems);
    procedure SetMode(const AValue: TADFetchMode);
    function IsIS: Boolean;
    function IsMS: Boolean;
    function IsRMS: Boolean;
    function IsRSS: Boolean;
    function GetCache: TADFetchItems;
    function IsCS: Boolean;
    procedure SetCache(const AValue: TADFetchItems);
    function GetActualRowsetSize: Integer;
    function GetAutoClose: Boolean;
    function IsACS: Boolean;
    procedure SetAutoClose(const AValue: Boolean);
    function GetRecordcountMode: TADRecordCountMode;
    function IsRCMS: Boolean;
    procedure SetRecordCountMode(const AValue: TADRecordCountMode);
    function GetUnidirectional: Boolean;
    function IsUS: Boolean;
    procedure SetUnidirectional(const AValue: Boolean);
    function GetCursor: TADCursorKind;
    procedure SetCursor(const AValue: TADCursorKind);
    function IsCKS: Boolean;
    function GetRecsSkip: Integer;
    procedure SetRecsSkip(const AValue: Integer);
    function IsESS: Boolean;
    function GetAutoFetchAll: TADAutoFetchAll;
    procedure SetAutoFetchAll(const AValue: TADAutoFetchAll);
    function IsAFAS: Boolean;
    function GetLiveWindowParanoic: Boolean;
    procedure SetLiveWindowParanoic(const AValue: Boolean);
    function IsLWP: Boolean;
    function GetDetailDelay: Integer;
    function GetDetailOptimize: Boolean;
    function IsDDS: Boolean;
    function IsDOS: Boolean;
    procedure SetDetailDelay(const AValue: Integer);
    procedure SetDetailOptimize(const AValue: Boolean);
    function GetDetailCascade: Boolean;
    function IsDCS: Boolean;
    procedure SetDetailCascade(const AValue: Boolean);
    function GetLiveWindowFastFirst: Boolean;
    function IsLWFF: Boolean;
    procedure SetLiveWindowFastFirst(const AValue: Boolean);
  protected
    FRecsSkip,
    FRecsMax: Integer;
    FRowsetSize: Integer;
    FMode: TADFetchMode;
    FItems: TADFetchItems;
    FAssignedValues: TADFetchOptionValues;
    FCache: TADFetchItems;
    FAutoClose: Boolean;
    FAutoFetchAll: TADAutoFetchAll;
    FRecordCountMode: TADRecordCountMode;
    FUnidirectional: Boolean;
    FCursorKind: TADCursorKind;
    FLiveWindowParanoic: Boolean;
    FLiveWindowFastFirst: Boolean;
    FDetailDelay: Integer;
    FDetailOptimize: Boolean;
    FDetailCascade: Boolean;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
    function IsValueOwned(AValue: TADFetchOptionValue; out AParentOpts: IADStanOptions): Boolean;
    property ActualRowsetSize: Integer read GetActualRowsetSize;
  published
    property AssignedValues: TADFetchOptionValues read FAssignedValues
      write FAssignedValues default [];
    property Mode: TADFetchMode read GetMode write SetMode
      stored IsMS default fmOnDemand;
    property CursorKind: TADCursorKind read GetCursor write SetCursor
      stored IsCKS default ckAutomatic;
    property Unidirectional: Boolean read GetUnidirectional
      write SetUnidirectional stored IsUS default False;
    property RowsetSize: Integer read GetRowsetSize write SetRowsetSize
      stored IsRSS default C_AD_DefRowSetSize;
    property RecsSkip: Integer read GetRecsSkip write SetRecsSkip
      stored IsESS default -1;
    property RecsMax: Integer read GetRecsMax write SetRecsMax
      stored IsRMS default -1;
    property AutoClose: Boolean read GetAutoClose write SetAutoClose
      stored IsACS default True;
    property AutoFetchAll: TADAutoFetchAll read GetAutoFetchAll
      write SetAutoFetchAll stored IsAFAS default afAll;
    property RecordCountMode: TADRecordCountMode read GetRecordcountMode
      write SetRecordCountMode stored IsRCMS default cmVisible;
    property Items: TADFetchItems read GetItems write SetItems
      stored IsIS default [fiBlobs, fiDetails, fiMeta];
    property Cache: TADFetchItems read GetCache write SetCache
      stored IsCS default [fiBlobs, fiDetails, fiMeta];
    property LiveWindowParanoic: Boolean read GetLiveWindowParanoic
      write SetLiveWindowParanoic stored IsLWP default False;
    property LiveWindowFastFirst: Boolean read GetLiveWindowFastFirst
      write SetLiveWindowFastFirst stored IsLWFF default False;
    property DetailDelay: Integer read GetDetailDelay
      write SetDetailDelay stored IsDDS default 0;
    property DetailOptimize: Boolean read GetDetailOptimize
      write SetDetailOptimize stored IsDOS default True;
    property DetailCascade: Boolean read GetDetailCascade
      write SetDetailCascade stored IsDCS default False;
  end;

  TADUpdateOptions = class (TADCustomOptions)
  private
    function GetEnableDelete: Boolean;
    function GetEnableInsert: Boolean;
    function GetEnableUpdate: Boolean;
    procedure SetEnableDelete(AValue: Boolean);
    procedure SetEnableInsert(AValue: Boolean);
    procedure SetEnableUpdate(AValue: Boolean);
    function GetReadOnly: Boolean;
    procedure SetReadOnly(const AValue: Boolean);
    function IsEDS: Boolean;
    function IsEIS: Boolean;
    function IsEUS: Boolean;
    function GetUpdateChangedFields: Boolean;
    function GetUpdateMode: TUpdateMode;
    function IsUCFS: Boolean;
    function IsUMS: Boolean;
    procedure SetUpdateChangedFields(const AValue: Boolean);
    procedure SetUpdateMode(const AValue: TUpdateMode);
    function IsLMS: Boolean;
    function IsLPS: Boolean;
    procedure SetLockMode(const AValue: TADLockMode);
    procedure SetLockPoint(const AValue: TADLockPoint);
    function GetLockMode: TADLockMode;
    function GetLockPoint: TADLockPoint;
    function GetLockWait: Boolean;
    function IsLWS: Boolean;
    procedure SetLockWait(const AValue: Boolean);
    function GetRefreshMode: TADRefreshMode;
    function IsRMS: Boolean;
    procedure SetRefreshMode(const AValue: TADRefreshMode);
    function GetCountUpdatedRecords: Boolean;
    function IsCURS: Boolean;
    procedure SetCountUpdatedRecords(const AValue: Boolean);
    function GetFastUpdates: Boolean;
    procedure SetFastUpdates(const AValue: Boolean);
    function GetRequestLive: Boolean;
    procedure SetRequestLive(const AValue: Boolean);
    function GetFetchGeneratorsPoint: TADFetchGeneratorsPoint;
    function IsGGPS: Boolean;
    procedure SetFetchGeneratorsPoint(const AValue: TADFetchGeneratorsPoint);
    function GetGeneratorName: String;
    function IsGNS: Boolean;
    procedure SetGeneratorName(const AValue: String);
    function GetRefreshDelete: Boolean;
    function IsRDS: Boolean;
    procedure SetRefreshDelete(const AValue: Boolean);
    function GetCheckRequired: Boolean;
    function IsCRS: Boolean;
    procedure SetCheckRequired(const AValue: Boolean);
    function GetCheckReadOnly: Boolean;
    function IsCROS: Boolean;
    procedure SetCheckReadOnly(const AValue: Boolean);
    function GetCheckUpdatable: Boolean;
    function IsCUS: Boolean;
    procedure SetCheckUpdatable(const AValue: Boolean);
    function GetUpdateNonBaseFields: Boolean;
    function IsUNFS: Boolean;
    procedure SetUpdateNonBaseFields(const AValue: Boolean);
  protected
    FEnableDelete: Boolean;
    FEnableInsert: Boolean;
    FEnableUpdate: Boolean;
    FUpdateChangedFields: Boolean;
    FUpdateMode: TUpdateMode;
    FLockMode: TADLockMode;
    FLockPoint: TADLockPoint;
    FLockWait: Boolean;
    FRefreshMode: TADRefreshMode;
    FrefreshDelete: Boolean;
    FCountUpdatedRecords: Boolean;
    FFetchGeneratorsPoint: TADFetchGeneratorsPoint;
    FGeneratorName: String;
    FCheckRequired: Boolean;
    FCheckReadOnly: Boolean;
    FCheckUpdatable: Boolean;
    FUpdateNonBaseFields: Boolean;
    FAssignedValues: TADUpdateOptionValues;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
    function IsValueOwned(AValue: TADUpdateOptionValue; out AParentOpts: IADStanOptions): Boolean;
    function CheckRequest(ARequest: TADUpdateRequest; AOptions: TADUpdateRowOptions;
      ACachedUpdates: Boolean): Boolean;
  published
    property AssignedValues: TADUpdateOptionValues read FAssignedValues
      write FAssignedValues default [];
    property EnableDelete: Boolean read GetEnableDelete write SetEnableDelete
      stored IsEDS default True;
    property EnableInsert: Boolean read GetEnableInsert write SetEnableInsert
      stored IsEIS default True;
    property EnableUpdate: Boolean read GetEnableUpdate write SetEnableUpdate
      stored IsEUS default True;
    property UpdateChangedFields: Boolean read GetUpdateChangedFields
      write SetUpdateChangedFields stored IsUCFS default True;
    property UpdateNonBaseFields: Boolean read GetUpdateNonBaseFields
      write SetUpdateNonBaseFields stored IsUNFS default False;
    property UpdateMode: TUpdateMode read GetUpdateMode write SetUpdateMode
      stored IsUMS default upWhereKeyOnly;
    property LockMode: TADLockMode read GetLockMode write SetLockMode
      stored IsLMS default lmNone;
    property LockPoint: TADLockPoint read GetLockPoint write SetLockPoint
      stored IsLPS default lpDeferred;
    property LockWait: Boolean read GetLockWait write SetLockWait
      stored IsLWS default False;
    property RefreshMode: TADRefreshMode read GetRefreshMode write SetRefreshMode
      stored IsRMS default rmOnDemand;
    property RefreshDelete: Boolean read GetRefreshDelete write SetRefreshDelete
      stored IsRDS default True;
    property CountUpdatedRecords: Boolean read GetCountUpdatedRecords
      write SetCountUpdatedRecords stored IsCURS default True;
    property FetchGeneratorsPoint: TADFetchGeneratorsPoint read GetFetchGeneratorsPoint
      write SetFetchGeneratorsPoint stored IsGGPS default gpDeferred;
    property GeneratorName: String read GetGeneratorName write SetGeneratorName
      stored IsGNS;
    property CheckRequired: Boolean read GetCheckRequired write SetCheckRequired
      stored IsCRS default True;
    property CheckReadOnly: Boolean read GetCheckReadOnly write SetCheckReadOnly
      stored IsCROS default True;
    property CheckUpdatable: Boolean read GetCheckUpdatable write SetCheckUpdatable
      stored IsCUS default True;
    // short-cuts
    property ReadOnly: Boolean read GetReadOnly write SetReadOnly
      stored False default False;
    property FastUpdates: Boolean read GetFastUpdates write SetFastUpdates
      stored False default False;
    property RequestLive: Boolean read GetRequestLive write SetRequestLive
      stored False default False;
  end;

  TADBottomUpdateOptions = class(TADUpdateOptions)
  private
    procedure SetAutoIncFields(const AValue: String);
    procedure SetKeyFields(const AValue: String);
    procedure SetUpdateTableName(const AValue: String);
  protected
    FUpdateTableName: String;
    FKeyFields: String;
    FAutoIncFields: String;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
  published
    property UpdateTableName: String read FUpdateTableName write SetUpdateTableName;
    property KeyFields: String read FKeyFields write SetKeyFields;
    property AutoIncFields: String read FAutoIncFields write SetAutoIncFields;
  end;

  TADResourceOptions = class(TADCustomOptions)
  private
    function GetActualSilentMode: Boolean;
    function GetMacroCreate: Boolean;
    function GetParamCreate: Boolean;
    function IsMCS: Boolean;
    function IsPCS: Boolean;
    procedure SetMacroCreate(const AValue: Boolean);
    procedure SetParamCreate(const AValue: Boolean);
    function GetCmdExecMode: TADStanAsyncMode;
    function GetCmdExecTimeout: LongWord;
    function IsCEMS: Boolean;
    function IsCETS: Boolean;
    procedure SetCmdExecMode(const AValue: TADStanAsyncMode);
    procedure SetCmdExecTimeout(const AValue: LongWord);
    function GetDirectExecute: Boolean;
    function IsDES: Boolean;
    procedure SetDirectExecute(const AValue: Boolean);
    function GetEscapeExpand: Boolean;
    function GetMacroExpand: Boolean;
    function GetParamExpand: Boolean;
    function IsEPS: Boolean;
    function IsMES: Boolean;
    function IsPES: Boolean;
    procedure SetEscapeExpand(const AValue: Boolean);
    procedure SetMacroExpand(const AValue: Boolean);
    procedure SetParamExpand(const AValue: Boolean);
    function GetDefaultParamType: TParamType;
    function IsDPTS: Boolean;
    procedure SetDefaultParamType(const AValue: TParamType);
    function GetBackup: Boolean;
    function GetPersistent: Boolean;
    function IsBS: Boolean;
    function IsPS: Boolean;
    procedure SetBackup(const AValue: Boolean);
    procedure SetPersistent(const AValue: Boolean);
    function GetBackupExt: String;
    function GetBackupFolder: String;
    function GetDefaultStoreExt: String;
    function GetDefaultStoreFolder: String;
    function GetDefaultStoreFormat: TADStorageFormat;
    function GetStoreVersion: Integer;
    procedure SetStoreVersion(const AValue: Integer);
    function IsSTV: Boolean;
    function GetPreprocessCmdText: Boolean;
    procedure SetPreprocessCmdText(const AValue: Boolean);
    function GetArrayDMLSize: Integer;
    function IsADSS: Boolean;
    procedure SetArrayDMLSize(const AValue: Integer);
    function GetSilentMode: Boolean;
    function IsSMS: Boolean;
    procedure SetSilentMode(const AValue: Boolean);
    function GetUnifyParams: Boolean;
    procedure SetUnifyParams(const AValue: Boolean);
    function IsUPS: Boolean;
    function GetStoreItems: TADStoreItems;
    function IsSIS: Boolean;
    procedure SetStoreItems(const AValue: TADStoreItems);
  protected
    FParamCreate: Boolean;
    FMacroCreate: Boolean;
    FParamExpand: Boolean;
    FMacroExpand: Boolean;
    FEscapeExpand: Boolean;
    FCmdExecMode: TADStanAsyncMode;
    FCmdExecTimeout: LongWord;
    FDirectExecute: Boolean;
    FDefaultParamType: TParamType;
    FPersistent: Boolean;
    FBackup: Boolean;
    FStoreVersion: Integer;
    FStoreItems: TADStoreItems;
    FArrayDMLSize: Integer;
    FSilentMode: Boolean;
    FUnifyParams: Boolean;
    FAssignedValues: TADResourceOptionValues;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
    function IsValueOwned(AValue: TADResourceOptionValue; out AParentOpts: IADStanOptions): Boolean;
    property DefaultStoreFolder: String read GetDefaultStoreFolder;
    property DefaultStoreExt: String read GetDefaultStoreExt;
    property DefaultStoreFormat: TADStorageFormat read GetDefaultStoreFormat;
    property BackupFolder: String read GetBackupFolder;
    property BackupExt: String read GetBackupExt;
    property PreprocessCmdText: Boolean read GetPreprocessCmdText
      write SetPreprocessCmdText;
    property ActualSilentMode: Boolean read GetActualSilentMode;
  published
    property AssignedValues: TADResourceOptionValues read FAssignedValues
      write FAssignedValues default [];
    property ParamCreate: Boolean read GetParamCreate write SetParamCreate
      stored IsPCS default True;
    property MacroCreate: Boolean read GetMacroCreate write SetMacroCreate
      stored IsMCS default True;
    property ParamExpand: Boolean read GetParamExpand write SetParamExpand
      stored IsPES default True;
    property MacroExpand: Boolean read GetMacroExpand write SetMacroExpand
      stored IsMES default True;
    property EscapeExpand: Boolean read GetEscapeExpand write SetEscapeExpand
      stored IsEPS default True;
    property CmdExecMode: TADStanAsyncMode read GetCmdExecMode
      write SetCmdExecMode stored IsCEMS default amBlocking;
    property CmdExecTimeout: LongWord read GetCmdExecTimeout
      write SetCmdExecTimeout stored IsCETS default $FFFFFFFF;
    property DirectExecute: Boolean read GetDirectExecute
      write SetDirectExecute stored IsDES default False;
    property DefaultParamType: TParamType read GetDefaultParamType
      write SetDefaultParamType stored IsDPTS default ptInput;
    property Persistent: Boolean read GetPersistent write SetPersistent
      stored IsPS default False;
    property Backup: Boolean read GetBackup write SetBackup
      stored IsBS default False;
    property StoreVersion: Integer read GetStoreVersion write SetStoreVersion
      stored IsSTV default -1;
    property StoreItems: TADStoreItems read GetStoreItems
      write SetStoreItems stored IsSIS default [siData, siDelta, siMeta];
    property ArrayDMLSize: Integer read GetArrayDMLSize write SetArrayDMLSize
      stored IsADSS default $7FFFFFFF;
    property SilentMode: Boolean read GetSilentMode write SetSilentMode
      stored IsSMS default False;
    property UnifyParams: Boolean read GetUnifyParams
      write SetUnifyParams stored IsUPS default False;
  end;

  TADTopResourceOptions = class(TADResourceOptions)
  private
    function GetMaxCursors: Integer;
    procedure SetMaxCursors(const AValue: Integer);
    function IsMCS: Boolean;
    function GetServerOutput: Boolean;
    function IsSOS: Boolean;
    procedure SetServerOutput(const AValue: Boolean);
    function GetServerOutputSize: Integer;
    function IsSOSS: Boolean;
    procedure SetServerOutputSize(const AValue: Integer);
    function IsBES: Boolean;
    function IsBFS: Boolean;
    function IsDSES: Boolean;
    function IsDSFS: Boolean;
    function IsDSTS: Boolean;
    procedure SetBackupExt(const AValue: String);
    procedure SetBackupFolder(const AValue: String);
    procedure SetDefaultStoreExt(const AValue: String);
    procedure SetDefaultStoreFolder(const AValue: String);
    procedure SetDefaultStoreFormat(const AValue: TADStorageFormat);
    function GetAutoReconnect: Boolean;
    function IsARS: Boolean;
    procedure SetAutoReconnect(const AValue: Boolean);
    function GetKeepConnection: Boolean;
    function IsKCS: Boolean;
    procedure SetKeepConnection(const AValue: Boolean);
    function GetAutoConnect: Boolean;
    function IsACS: Boolean;
    procedure SetAutoConnect(const AValue: Boolean);
  protected
    FMaxCursors: Integer;
    FServerOutput: Boolean;
    FServerOutputSize: Integer;
    FDefaultStoreFolder: String;
    FBackupFolder: String;
    FDefaultStoreExt: String;
    FDefaultStoreFormat: TADStorageFormat;
    FBackupExt: String;
    FAutoConnect: Boolean;
    FAutoReconnect: Boolean;
    FKeepConnection: Boolean;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
  published
    property MaxCursors: Integer read GetMaxCursors write SetMaxCursors
      stored IsMCS default -1;
    property ServerOutput: Boolean read GetServerOutput
      write SetServerOutput stored IsSOS default False;
    property ServerOutputSize: Integer read GetServerOutputSize
      write SetServerOutputSize stored IsSOSS default 20000;
    property DefaultStoreFolder write SetDefaultStoreFolder stored IsDSFS;
    property BackupFolder write SetBackupFolder stored IsBFS;
    property DefaultStoreExt write SetDefaultStoreExt stored IsDSES;
    property DefaultStoreFormat write SetDefaultStoreFormat stored IsDSTS
      default sfAuto;
    property BackupExt write SetBackupExt stored IsBES;
    property AutoConnect: Boolean read GetAutoConnect write SetAutoConnect
      stored IsACS default True;
    property AutoReconnect: Boolean read GetAutoReconnect write SetAutoReconnect
      stored IsARS default False;
    property KeepConnection: Boolean read GetKeepConnection write SetKeepConnection
      stored IsKCS default True;
  end;

  TADBottomResourceOptions = class(TADResourceOptions)
  protected
    FPersistentFileName: String;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure RestoreDefaults; override;
    function ResolveFileName(const AFileName: String = ''): String;
  published
    property PersistentFileName: string read FPersistentFileName
      write FPersistentFileName;
  end;

  TADTxOptions = class (TPersistent)
  private
    procedure SetAutoCommit(const AValue: Boolean);
    procedure SetIsolation(const AValue: TADTxIsolation);
    procedure SetReadOnly(const AValue: Boolean);
    procedure SetParams(const AValue: TStrings);
    procedure DoParamsChanged(ASender: TObject);
    procedure SetAutoStart(const AValue: Boolean);
    procedure SetAutoStop(const AValue: Boolean);
    function GetAutoCommit: Boolean;
    procedure SetStopOptions(const AValue: TADTxStopOptions);
  protected
    FStopOptions: TADTxStopOptions;
    FIsolation: TADTxIsolation;
    FReadOnly: Boolean;
    FParams: TStrings;
    FAutoStart: Boolean;
    FAutoStop: Boolean;
    FDisconnectAction: TADTxAction;
    FEnableNested: Boolean;
    FChanged: TADTxValues;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure ClearChanged;
    procedure ResetChanged;
    property Changed: TADTxValues read FChanged write FChanged;
  published
    property Isolation: TADTxIsolation read FIsolation write SetIsolation
      default xiReadCommitted;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property Params: TStrings read FParams write SetParams;
    property AutoCommit: Boolean read GetAutoCommit write SetAutoCommit
      stored False default True;
    property AutoStart: Boolean read FAutoStart write SetAutoStart default True;
    property AutoStop: Boolean read FAutoStop write SetAutoStop default True;
    property StopOptions: TADTxStopOptions read FStopOptions write SetStopOptions
      default [xoIfAutoStarted, xoIfCmdsInactive];
    property DisconnectAction: TADTxAction read FDisconnectAction write FDisconnectAction
      default xdCommit;
    property EnableNested: Boolean read FEnableNested write FEnableNested default True;
  end;

  TADEventAlerterOptions = class (TPersistent)
  private
    FKind: String;
    FTimeout: Integer;
    FSynchronize: Boolean;
    FAutoRegister: Boolean;
  public
    constructor Create;
    procedure Assign(ASource: TPersistent); override;
  published
    property Kind: String read FKind write FKind;
    property Timeout: Integer read FTimeout write FTimeout default -1;
    property Synchronize: Boolean read FSynchronize write FSynchronize default True;
    property AutoRegister: Boolean read FAutoRegister write FAutoRegister default False;
  end;

implementation

uses
{$IFDEF AnyDAC_D6Base}
  {$IFDEF AnyDAC_D6}
  FmtBcd, SqlTimSt,
  {$ENDIF}
{$ELSE}
  ComObj,
{$ENDIF}
{$IFDEF AnyDAC_D18}
  {$IFNDEF NEXTGEN}
  System.AnsiStrings,
  {$ENDIF}
{$ENDIF}
  uADStanError, uADStanSQLTimeInt,
  uADGUIxIntf;

{-------------------------------------------------------------------------------}
const
  C_AD_AllowedConversions: array[TADDataType {src}, TADDataType {dest}] of Byte = (
    (1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0),
    (0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0),
    (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)
  );

{-------------------------------------------------------------------------------}
{ TADOptionsContainer                                                           }
{-------------------------------------------------------------------------------}
constructor TADOptionsContainer.Create(AOwnerObj: TPersistent;
  AFetchClass: TADFetchOptionsClass; AUpdateClass: TADUpdateOptionsClass;
  AResourceClass: TADResourceOptionsClass; AParentCallback: TADOptionsParentCallback);
begin
  inherited Create;
  FOwnerObj := AOwnerObj;
  FFormatOptions := TADFormatOptions.Create(Self);
  FFetchOptions := AFetchClass.Create(Self);
  FUpdateOptions := AUpdateClass.Create(Self);
  FResourceOptions := AResourceClass.Create(Self);
  FParentCallback := AParentCallback;
  FParentOriginalCallback := AParentCallback;
end;

{-------------------------------------------------------------------------------}
destructor TADOptionsContainer.Destroy;
begin
  ADFreeAndNil(FFormatOptions);
  ADFreeAndNil(FFetchOptions);
  ADFreeAndNil(FUpdateOptions);
  ADFreeAndNil(FResourceOptions);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADOptionsContainer.GetFetchOptions: TADFetchOptions;
begin
  Result := FFetchOptions;
end;

{-------------------------------------------------------------------------------}
function TADOptionsContainer.GetFormatOptions: TADFormatOptions;
begin
  Result := FFormatOptions;
end;

{-------------------------------------------------------------------------------}
function TADOptionsContainer.GetResourceOptions: TADResourceOptions;
begin
  Result := FResourceOptions;
end;

{-------------------------------------------------------------------------------}
function TADOptionsContainer.GetUpdateOptions: TADUpdateOptions;
begin
  Result := FUpdateOptions;
end;

{-------------------------------------------------------------------------------}
function TADOptionsContainer.GetParentOptions: IADStanOptions;
begin
  if Assigned(FParentCallback) then
    FParentCallback(Result)
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADOptionsContainer.InternalParentOptionsCallback(out AOpts: IADStanOptions);
begin
  AOpts := FParentOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADOptionsContainer.SetParentOptions(const AValue: IADStanOptions);
begin
  if FParentOptions <> AValue then begin
    FParentOptions := AValue;
    if FParentOptions = nil then
      FParentCallback := FParentOriginalCallback
    else
      FParentCallback := InternalParentOptionsCallback;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADOptionsContainer.ObjectDestroyed(AObj: TPersistent);
begin
  if AObj = FOwnerObj then
    FOwnerObj := nil;
end;

{-------------------------------------------------------------------------------}
{- TADCustomOptions                                                            -}
{-------------------------------------------------------------------------------}
{$HINTS OFF}
constructor TADCustomOptions.Create(AContainer: TADOptionsContainer);
begin
  inherited Create;
  FContainer := AContainer;
  RestoreDefaults;
end;
{$HINTS ON}

{-------------------------------------------------------------------------------}
procedure TADCustomOptions.Assign(ASource: TPersistent);
begin
  inherited Assign(ASource);
  // nothing
end;

{-------------------------------------------------------------------------------}
procedure TADCustomOptions.RestoreDefaults;
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADCustomOptions.GetOwner: TPersistent;
begin
  if FContainer <> nil then
    Result := FContainer.FOwnerObj
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
function TADCustomOptions.GetOwnerObj: TPersistent;
begin
  Result := GetOwner;
end;

{-------------------------------------------------------------------------------}
{- TADMapRule                                                                  -}
{-------------------------------------------------------------------------------}
constructor TADMapRule.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FPrecMax := C_AD_DefMapPrec;
  FPrecMin := C_AD_DefMapPrec;
  FScaleMax := C_AD_DefMapScale;
  FScaleMin := C_AD_DefMapScale;
  FSizeMax := C_AD_DefMapSize;
  FSizeMin := C_AD_DefMapSize;
  FSourceDataType := dtUnknown;
  FTargetDataType := dtUnknown;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.Assign(Source: TPersistent);
begin
  if Source is TADMapRule then begin
    FPrecMax := TADMapRule(Source).FPrecMax;
    FPrecMin := TADMapRule(Source).FPrecMin;
    FScaleMax := TADMapRule(Source).FScaleMax;
    FScaleMin := TADMapRule(Source).FScaleMin;
    FSizeMax := TADMapRule(Source).FSizeMax;
    FSizeMin := TADMapRule(Source).FSizeMin;
    FSourceDataType := TADMapRule(Source).FSourceDataType;
    FTargetDataType := TADMapRule(Source).FTargetDataType;
    FNameMask := TADMapRule(Source).FNameMask;
  end
  else
    inherited Assign(Source);
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.SetSourceDataType(AValue: TADDataType);
begin
  if FSourceDataType <> AValue then begin
    if (Collection <> nil) and (TADMapRules(Collection).FFormatOptions <> nil) and
       (AValue <> dtUnknown) and (FTargetDataType <> dtUnknown) then
      TADMapRules(Collection).FFormatOptions.CheckConversion(AValue, FTargetDataType);
    FSourceDataType := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRule.SetTargetDataType(AValue: TADDataType);
begin
  if FTargetDataType <> AValue then begin
    if (Collection <> nil) and (TADMapRules(Collection).FFormatOptions <> nil) and
       (AValue <> dtUnknown) and (FSourceDataType <> dtUnknown) then
      TADMapRules(Collection).FFormatOptions.CheckConversion(FSourceDataType, AValue);
    FTargetDataType := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMapRule.GetDisplayName: string;
begin
  if (SourceDataType = dtUnknown) and (TargetDataType = dtUnknown) then
    Result := inherited GetDisplayName
  else begin
    if (SourceDataType = dtUnknown) and (NameMask <> '') then
      Result := NameMask
    else
      Result := C_AD_DataTypeNames[SourceDataType];
    Result := Result + ' -> ' + C_AD_DataTypeNames[TargetDataType];
  end;
end;

{-------------------------------------------------------------------------------}
{- TADMapRules                                                                 -}
{-------------------------------------------------------------------------------}
constructor TADMapRules.Create(AFormatOptions: TADFormatOptions);
begin
  inherited Create(TADMapRule);
  FFormatOptions := AFormatOptions;
end;

{-------------------------------------------------------------------------------}
function TADMapRules.Add: TADMapRule;
begin
  Result := TADMapRule(inherited Add);
end;

{-------------------------------------------------------------------------------}
procedure TADMapRules.Add(APrecMin, APrecMax, AScaleMin,
  AScaleMax: Integer; ASourceDataType, ATargetDataType: TADDataType);
var
  oRule: TADMapRule;
begin
  oRule := Add;
  oRule.PrecMin := APrecMin;
  oRule.PrecMax := APrecMax;
  oRule.ScaleMin := AScaleMin;
  oRule.ScaleMax := AScaleMax;
  oRule.SourceDataType := ASourceDataType;
  oRule.TargetDataType := ATargetDataType;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRules.Add(ASizeMin, ASizeMax: Integer; ASourceDataType,
  ATargetDataType: TADDataType);
var
  oRule: TADMapRule;
begin
  oRule := Add;
  oRule.SizeMin := ASizeMin;
  oRule.SizeMax := ASizeMax;
  oRule.SourceDataType := ASourceDataType;
  oRule.TargetDataType := ATargetDataType;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRules.Add(ASourceDataType, ATargetDataType: TADDataType);
var
  oRule: TADMapRule;
begin
  oRule := Add;
  oRule.SourceDataType := ASourceDataType;
  oRule.TargetDataType := ATargetDataType;
end;

{-------------------------------------------------------------------------------}
procedure TADMapRules.RemoveForSourceDataType(ADataType: TADDataType);
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
    if Items[i].SourceDataType = ADataType then
      Delete(i);
end;

{-------------------------------------------------------------------------------}
procedure TADMapRules.RemoveForTargetDataType(ADataType: TADDataType);
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
    if Items[i].TargetDataType = ADataType then
      Delete(i);
end;

{-------------------------------------------------------------------------------}
function TADMapRules.GetItems(AIndex: Integer): TADMapRule;
begin
  Result := TADMapRule(inherited Items[AIndex]);
end;

{-------------------------------------------------------------------------------}
function TADMapRules.GetOwner: TPersistent;
begin
  Result := FFormatOptions;
end;

{-------------------------------------------------------------------------------}
{- TADFormatOptions                                                            -}
{-------------------------------------------------------------------------------}
constructor TADFormatOptions.Create(AContainer: TADOptionsContainer);
begin
  FMapRules := TADMapRules.Create(Self);
  inherited Create(AContainer);
end;

{-------------------------------------------------------------------------------}
destructor TADFormatOptions.Destroy;
begin
  ADFreeAndNil(FMapRules);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.Assign(ASource: TPersistent);
begin
  if (ASource = nil) or (ASource = Self) then
    Exit;
  if ASource is TADFormatOptions then begin
    if fvMapRules in TADFormatOptions(ASource).FAssignedValues then
      MapRules.Assign(TADFormatOptions(ASource).MapRules);
    if fvSE2Null in TADFormatOptions(ASource).FAssignedValues then
      StrsEmpty2Null := TADFormatOptions(ASource).StrsEmpty2Null;
    if fvStrsTrim in TADFormatOptions(ASource).FAssignedValues then
      StrsTrim := TADFormatOptions(ASource).StrsTrim;
    if fvStrsTrim2Len in TADFormatOptions(ASource).FAssignedValues then
      StrsTrim2Len := TADFormatOptions(ASource).StrsTrim2Len;
    if fvMaxStringSize in TADFormatOptions(ASource).FAssignedValues then
      MaxStringSize := TADFormatOptions(ASource).MaxStringSize;
    if fvMaxBcdPrecision in TADFormatOptions(ASource).FAssignedValues then
      MaxBcdPrecision := TADFormatOptions(ASource).MaxBcdPrecision;
    if fvMaxBcdScale in TADFormatOptions(ASource).FAssignedValues then
      MaxBcdScale := TADFormatOptions(ASource).MaxBcdScale;
    if fvInlineDataSize in TADFormatOptions(ASource).FAssignedValues then
      InlineDataSize := TADFormatOptions(ASource).InlineDataSize;
    if fvDefaultParamDataType in TADFormatOptions(ASource).FAssignedValues then
      DefaultParamDataType := TADFormatOptions(ASource).DefaultParamDataType;
    if fvRound2Scale in TADFormatOptions(ASource).FAssignedValues then
      Round2Scale := TADFormatOptions(ASource).Round2Scale;
    if fvDataSnapCompatibility in TADFormatOptions(ASource).FAssignedValues then
      DataSnapCompatibility := TADFormatOptions(ASource).DataSnapCompatibility;
    if fvFmtDisplayDateTime in TADFormatOptions(ASource).FAssignedValues then
      FmtDisplayDateTime := TADFormatOptions(ASource).FmtDisplayDateTime;
    if fvFmtDisplayDate in TADFormatOptions(ASource).FAssignedValues then
      FmtDisplayDate := TADFormatOptions(ASource).FmtDisplayDate;
    if fvFmtDisplayTime in TADFormatOptions(ASource).FAssignedValues then
      FmtDisplayTime := TADFormatOptions(ASource).FmtDisplayTime;
    if fvFmtDisplayNumeric in TADFormatOptions(ASource).FAssignedValues then
      FmtDisplayNumeric := TADFormatOptions(ASource).FmtDisplayNumeric;
    if fvFmtEditNumeric in TADFormatOptions(ASource).FAssignedValues then
      FmtEditNumeric := TADFormatOptions(ASource).FmtEditNumeric;
    if fvQuoteIdentifiers in TADFormatOptions(ASource).FAssignedValues then
      QuoteIdentifiers := TADFormatOptions(ASource).QuoteIdentifiers;
    if fvSortLocale in TADFormatOptions(ASource).FAssignedValues then
      SortLocale := TADFormatOptions(ASource).SortLocale;
    if fvSortOptions in TADFormatOptions(ASource).FAssignedValues then
      SortOptions := TADFormatOptions(ASource).SortOptions;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.RestoreDefaults;
begin
  inherited RestoreDefaults;
  FAssignedValues := [];
  FStrsEmpty2Null := False;
  FStrsTrim := True;
  FStrsTrim2Len := False;
  FMaxStringSize := C_AD_DefMaxStrSize;
  FMaxBcdPrecision := 18;
  FMaxBcdScale := 4;
  FMapRules.Clear;
  FInlineDataSize := C_AD_DefInlineDataSize;
  FDefaultParamDataType := ftUnknown;
  FRound2Scale := False;
  FDataSnapCompatibility := False;
  FFmtDisplayDateTime := '';
  FFmtDisplayDate := '';
  FFmtDisplayTime := '';
  FFmtDisplayNumeric := '';
  FFmtEditNumeric := '';
  FQuoteIdentifiers := False;
  FSortLocale := LOCALE_USER_DEFAULT;
  FSortOptions := [];
  Inc(FVersion);
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsValueOwned(AValue: TADFormatOptionValue;
  out AParentOpts: IADStanOptions): Boolean;
begin
  Result := not Assigned(Container.FParentCallback) or (AValue in FAssignedValues);
  if not Result then begin
    Container.FParentCallback(AParentOpts);
    Result := (AParentOpts = nil);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetMapRules: TADMapRules;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvMapRules, oParentOpts) then
    Result := FMapRules
  else
    Result := oParentOpts.FormatOptions.MapRules;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetMapRules(const AValue: TADMapRules);
begin
  FMapRules.Assign(AValue);
  Include(FAssignedValues, fvMapRules);
  Inc(FVersion);
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsMRS: Boolean;
begin
  Result := fvMapRules in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetOwnMapRules(const AValue: Boolean);
var
  oParentOpts: IADStanOptions;
begin
  if (fvMapRules in FAssignedValues) <> AValue then begin
    if AValue then begin
      if Assigned(Container.FParentCallback) then begin
        Container.FParentCallback(oParentOpts);
        if oParentOpts <> nil then
          FMapRules.Assign(oParentOpts.FormatOptions.MapRules);
      end;
      Include(FAssignedValues, fvMapRules);
    end
    else begin
      if Assigned(Container.FParentCallback) then begin
        Container.FParentCallback(oParentOpts);
        if oParentOpts <> nil then
          FMapRules.Clear;
      end;
      Exclude(FAssignedValues, fvMapRules);
    end;
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetStrsEmpty2Null: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvSE2Null, oParentOpts) then
    Result := FStrsEmpty2Null
  else
    Result := oParentOpts.FormatOptions.StrsEmpty2Null;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetStrsEmpty2Null(AValue: Boolean);
begin
  if not (fvSE2Null in FAssignedValues) or (FStrsEmpty2Null <> AValue) then begin
    FStrsEmpty2Null := AValue;
    Include(FAssignedValues, fvSE2Null);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsSE2NS: Boolean;
begin
  Result := fvSE2Null in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetStrsTrim: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvStrsTrim, oParentOpts) then
    Result := FStrsTrim
  else
    Result := oParentOpts.FormatOptions.StrsTrim;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetStrsTrim(AValue: Boolean);
begin
  if not (fvStrsTrim in FAssignedValues) or (FStrsTrim <> AValue) then begin
    FStrsTrim := AValue;
    Include(FAssignedValues, fvStrsTrim);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsSTS: Boolean;
begin
  Result := fvStrsTrim in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetStrsTrim2Len: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvStrsTrim2Len, oParentOpts) then
    Result := FStrsTrim2Len
  else
    Result := oParentOpts.FormatOptions.StrsTrim2Len;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetStrsTrim2Len(const AValue: Boolean);
begin
  if not (fvStrsTrim2Len in FAssignedValues) or (FStrsTrim2Len <> AValue) then begin
    FStrsTrim2Len := AValue;
    Include(FAssignedValues, fvStrsTrim2Len);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsSTTLS: Boolean;
begin
  Result := fvStrsTrim2Len in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetStrsDivLen2: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvStrsDivLen2, oParentOpts) then
    Result := FStrsDivLen2
  else
    Result := oParentOpts.FormatOptions.StrsDivLen2;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetStrsDivLen2(const AValue: Boolean);
begin
  if not (fvStrsDivLen2 in FAssignedValues) or (FStrsDivLen2 <> AValue) then begin
    FStrsDivLen2 := AValue;
    Include(FAssignedValues, fvStrsDivLen2);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsSDL2S: Boolean;
begin
  Result := fvStrsDivLen2 in AssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetMaxStringSize: LongWord;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvMaxStringSize, oParentOpts) then
    Result := FMaxStringSize
  else
    Result := oParentOpts.FormatOptions.MaxStringSize;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetQuoteIdentifiers: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvQuoteIdentifiers, oParentOpts) then
    Result := FQuoteIdentifiers
  else
    Result := oParentOpts.FormatOptions.QuoteIdentifiers;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetQuoteIdentifiers(const AValue: Boolean);
begin
  if not (fvQuoteIdentifiers in FAssignedValues) or (FQuoteIdentifiers <> AValue) then begin
    FQuoteIdentifiers := AValue;
    Include(FAssignedValues, fvQuoteIdentifiers);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsQIDS: Boolean;
begin
  Result := fvQuoteIdentifiers in AssignedValues;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetMaxStringSize(const AValue: LongWord);
begin
  if not (fvMaxStringSize in FAssignedValues) or (FMaxStringSize <> AValue) then begin
    FMaxStringSize := AValue;
    Include(FAssignedValues, fvMaxStringSize);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsMSSS: Boolean;
begin
  Result := fvMaxStringSize in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetMaxBcdPrecision: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvMaxBcdPrecision, oParentOpts) then
    Result := FMaxBcdPrecision
  else
    Result := oParentOpts.FormatOptions.MaxBcdPrecision;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetMaxBcdPrecision(const AValue: Integer);
begin
  if not (fvMaxBcdPrecision in FAssignedValues) or (FMaxBcdPrecision <> AValue) then begin
    FMaxBcdPrecision := AValue;
    Include(FAssignedValues, fvMaxBcdPrecision);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsMBPS: Boolean;
begin
  Result := fvMaxBcdPrecision in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetMaxBcdScale: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvMaxBcdScale, oParentOpts) then
    Result := FMaxBcdScale
  else
    Result := oParentOpts.FormatOptions.MaxBcdScale;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetMaxBcdScale(const AValue: Integer);
begin
  if not (fvMaxBcdScale in FAssignedValues) or (FMaxBcdScale <> AValue) then begin
    FMaxBcdScale := AValue;
    Include(FAssignedValues, fvMaxBcdScale);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsMBSS: Boolean;
begin
  Result := fvMaxBcdScale in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetInlineDataSize: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvInlineDataSize, oParentOpts) then
    Result := FInlineDataSize
  else
    Result := oParentOpts.FormatOptions.InlineDataSize;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetInlineDataSize(const AValue: Integer);
begin
  if not (fvInlineDataSize in FAssignedValues) or (FInlineDataSize <> AValue) then begin
    FInlineDataSize := AValue;
    Include(FAssignedValues, fvInlineDataSize);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsIDSS: Boolean;
begin
  Result := fvInlineDataSize in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetDefaultParamDataType: TFieldType;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvDefaultParamDataType, oParentOpts) then
    Result := FDefaultParamDataType
  else
    Result := oParentOpts.FormatOptions.DefaultParamDataType;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetDefaultParamDataType(const AValue: TFieldType);
begin
  if not (fvDefaultParamDataType in FAssignedValues) or (FDefaultParamDataType <> AValue) then begin
    FDefaultParamDataType := AValue;
    Include(FAssignedValues, fvDefaultParamDataType);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsDPDTS: Boolean;
begin
  Result := fvDefaultParamDataType in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetRound2Scale: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvRound2Scale, oParentOpts) then
    Result := FRound2Scale
  else
    Result := oParentOpts.FormatOptions.Round2Scale;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetRound2Scale(const AValue: Boolean);
begin
  if not (fvRound2Scale in FAssignedValues) or (FRound2Scale <> AValue) then begin
    FRound2Scale := AValue;
    Include(FAssignedValues, fvRound2Scale);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsRSS: Boolean;
begin
  Result := fvRound2Scale in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetDataSnapCompatibility: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvDataSnapCompatibility, oParentOpts) then
    Result := FDataSnapCompatibility
  else
    Result := oParentOpts.FormatOptions.DataSnapCompatibility;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetDataSnapCompatibility(const AValue: Boolean);
begin
  if not (fvDataSnapCompatibility in FAssignedValues) or (FDataSnapCompatibility <> AValue) then begin
    FDataSnapCompatibility := AValue;
    Include(FAssignedValues, fvDataSnapCompatibility);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsDSCS: Boolean;
begin
  Result := fvDataSnapCompatibility in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetFmtDisplayDateTime: String;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvFmtDisplayDateTime, oParentOpts) then
    Result := FFmtDisplayDateTime
  else
    Result := oParentOpts.FormatOptions.FmtDisplayDateTime;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetFmtDisplayDateTime(const AValue: String);
begin
  if not (fvFmtDisplayDateTime in FAssignedValues) or (FFmtDisplayDateTime <> AValue) then begin
    FFmtDisplayDateTime := AValue;
    Include(FAssignedValues, fvFmtDisplayDateTime);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsFDDTS: Boolean;
begin
  Result := fvFmtDisplayDateTime in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetFmtDisplayDate: String;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvFmtDisplayDate, oParentOpts) then
    Result := FFmtDisplayDate
  else
    Result := oParentOpts.FormatOptions.FmtDisplayDate;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetFmtDisplayDate(const AValue: String);
begin
  if not (fvFmtDisplayDate in FAssignedValues) or (FFmtDisplayDate <> AValue) then begin
    FFmtDisplayDate := AValue;
    Include(FAssignedValues, fvFmtDisplayDate);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsFDDS: Boolean;
begin
  Result := fvFmtDisplayDate in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetFmtDisplayTime: String;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvFmtDisplayTime, oParentOpts) then
    Result := FFmtDisplayTime
  else
    Result := oParentOpts.FormatOptions.FmtDisplayTime;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetFmtDisplayTime(const AValue: String);
begin
  if not (fvFmtDisplayTime in FAssignedValues) or (FFmtDisplayTime <> AValue) then begin
    FFmtDisplayTime := AValue;
    Include(FAssignedValues, fvFmtDisplayTime);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsFDTS: Boolean;
begin
  Result := fvFmtDisplayTime in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetFmtDisplayNumeric: String;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvFmtDisplayNumeric, oParentOpts) then
    Result := FFmtDisplayNumeric
  else
    Result := oParentOpts.FormatOptions.FmtDisplayNumeric;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetFmtDisplayNumeric(const AValue: String);
begin
  if not (fvFmtDisplayNumeric in FAssignedValues) or (FFmtDisplayNumeric <> AValue) then begin
    FFmtDisplayNumeric := AValue;
    Include(FAssignedValues, fvFmtDisplayNumeric);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsFDNS: Boolean;
begin
  Result := fvFmtDisplayNumeric in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetFmtEditNumeric: String;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvFmtEditNumeric, oParentOpts) then
    Result := FFmtEditNumeric
  else
    Result := oParentOpts.FormatOptions.FmtEditNumeric;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetFmtEditNumeric(const AValue: String);
begin
  if not (fvFmtEditNumeric in FAssignedValues) or (FFmtEditNumeric <> AValue) then begin
    FFmtEditNumeric := AValue;
    Include(FAssignedValues, fvFmtEditNumeric);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsFENS: Boolean;
begin
  Result := fvFmtEditNumeric in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetSortLocale: TADLocalID;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvSortLocale, oParentOpts) then
    Result := FSortLocale
  else
    Result := oParentOpts.FormatOptions.SortLocale;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetSortLocale(const AValue: TADLocalID);
begin
  if not (fvSortLocale in FAssignedValues) or (FSortLocale <> AValue) then begin
    FSortLocale := AValue;
    Include(FAssignedValues, fvSortLocale);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsSLS: Boolean;
begin
  Result := fvSortLocale in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.GetSortOptions: TADSortOptions;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(fvSortOptions, oParentOpts) then
    Result := FSortOptions
  else
    Result := oParentOpts.FormatOptions.SortOptions;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.SetSortOptions(const AValue: TADSortOptions);
begin
  if not (fvSortOptions in FAssignedValues) or (FSortOptions <> AValue) then begin
    FSortOptions := AValue;
    Include(FAssignedValues, fvSortOptions);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFormatOptions.IsSOS: Boolean;
begin
  Result := fvSortOptions in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.ResolveDataType(const ASrcName: String;
  ASrcDataType: TADDataType; ASrcSize: LongWord; ASrcPrec, ASrcScale: Integer;
  var ADestDataType: TADDataType; var ADestSize: LongWord; AForward: Boolean);
var
  i: Integer;
  oRules: TADMapRules;
  oRule: TADMapRule;
begin
  ADestDataType := ASrcDataType;
  oRules := MapRules;
  for i := 0 to oRules.Count - 1 do begin
    oRule := oRules[i];
    if (AForward and (
          ((oRule.SourceDataType = dtUnknown) or (oRule.SourceDataType = ASrcDataType)) and
          ((oRule.NameMask = '') or (ASrcName = '') or ADStrLike(ASrcName, oRule.NameMask, True))) and
          (oRule.TargetDataType <> dtUnknown) or
        not AForward and
          (oRule.TargetDataType = ASrcDataType) and (oRule.NameMask = '') and
          (oRule.SourceDataType <> dtUnknown)
       ) and
       ((oRule.SizeMin = C_AD_DefMapSize) or (ASrcSize <= 0) or (oRule.SizeMin <= ASrcSize)) and
       ((oRule.SizeMax = C_AD_DefMapSize) or (ASrcSize <= 0) or (oRule.SizeMax >= ASrcSize)) and
       ((oRule.PrecMin = C_AD_DefMapPrec) or (ASrcPrec <= 0) or (oRule.PrecMin <= ASrcPrec)) and
       ((oRule.PrecMax = C_AD_DefMapPrec) or (ASrcPrec <= 0) or (oRule.PrecMax >= ASrcPrec)) and
       ((oRule.ScaleMin = C_AD_DefMapScale) or (ASrcScale < 0) or (oRule.ScaleMin <= ASrcScale)) and
       ((oRule.ScaleMax = C_AD_DefMapScale) or (ASrcScale < 0) or (oRule.ScaleMax >= ASrcScale)) then begin
      if AForward then
        ADestDataType := oRule.TargetDataType
      else
        ADestDataType := oRule.SourceDataType;
      Break;
    end;
  end;
  if (ASrcDataType in [dtBlob, dtMemo, dtWideMemo, dtXML, dtHBlob,
                       dtHMemo, dtWideHMemo, dtHBFile]) and
     (ADestDataType in [dtAnsiString, dtWideString, dtByteString]) then
    ADestSize := MaxStringSize
  else
    ADestSize := ASrcSize;
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.ResolveFieldType(const ASrcName: String; ASrcFieldType: TFieldType;
  ASrcADFieldType: TADDataType; ASrcSize: LongWord; ASrcPrecision, ASrcScale: Integer;
  var ADestFieldType: TFieldType; var ADestSize: LongWord;
  var ADestPrecision, ADestScale: Integer; var ASrcDataType, ADestDataType: TADDataType;
  AForward: Boolean);
var
  iSrcScale, iSrcPrec: Integer;
  iSrcSize: LongWord;
  iSrcAttrs: TADDataAttributes;
begin
  iSrcAttrs := [];
  iSrcSize := 0;
  iSrcPrec := 0;
  iSrcScale := 0;
  FieldDef2ColumnDef(ASrcFieldType, ASrcSize, ASrcPrecision, ASrcScale,
    ASrcDataType, iSrcSize, iSrcPrec, iSrcScale, iSrcAttrs);
  case ASrcDataType of
  dtHMemo, dtWideMemo, dtMemo, dtXML:
    if ASrcADFieldType = dtWideHMemo then
      ASrcDataType := dtWideHMemo;
  dtHBlob:
    if ASrcADFieldType = dtHBFile then
      ASrcDataType := dtHBFile;
  dtDateTime:
    if ASrcADFieldType = dtDateTimeStamp then
      ASrcDataType := dtDateTimeStamp;
  dtTimeIntervalDS:
    if ASrcADFieldType in [dtTimeIntervalFull, dtTimeIntervalYM, dtTimeIntervalDS] then
      ASrcDataType := ASrcADFieldType;
  end;
  ResolveDataType(ASrcName, ASrcDataType, iSrcSize, iSrcPrec, iSrcScale,
    ADestDataType, iSrcSize, AForward);
  ColumnDef2FieldDef(ADestDataType, iSrcSize, iSrcPrec, iSrcScale, iSrcAttrs,
    ADestFieldType, ADestSize, ADestPrecision, ADestScale);
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.ColumnDef2FieldDef(ASrcDataType: TADDataType;
  ASrcSize: LongWord; ASrcPrec, ASrcScale: Integer; ASrcAttrs: TADDataAttributes;
  var ADestFieldType: TFieldType; var ADestSize: LongWord; var ADestPrec, ADestScale: Integer);
begin
  ADestFieldType := ftUnknown;
  ADestSize := 0;
  ADestPrec := 0;
  ADestScale := 0;
  case ASrcDataType of
    dtUnknown:
      ;
    dtBoolean:
      ADestFieldType := ftBoolean;
    dtSByte:
      ADestFieldType := {$IFDEF AnyDAC_D12} ftShortint {$ELSE} ftSmallint {$ENDIF};
    dtByte:
      ADestFieldType := {$IFDEF AnyDAC_D12} ftByte {$ELSE} ftWord {$ENDIF};
    dtInt16:
      ADestFieldType := ftSmallint;
    dtUInt16:
      ADestFieldType := ftWord;
    dtInt32:
      if caAutoInc in ASrcAttrs then
        ADestFieldType := ftAutoInc
      else
        ADestFieldType := ftInteger;
    dtUInt32:
      if caAutoInc in ASrcAttrs then
        ADestFieldType := ftAutoInc
      else
        ADestFieldType := {$IFDEF AnyDAC_D12} ftLongWord {$ELSE} ftInteger {$ENDIF};
    dtInt64, dtUInt64:
      ADestFieldType := ftLargeint;
    dtSingle:
      begin
        ADestFieldType := {$IFDEF AnyDAC_D14} ftSingle {$ELSE} ftFloat {$ENDIF};
        ADestPrec := ASrcPrec;
        ADestScale := ASrcScale;
      end;
    dtDouble:
      begin
        ADestFieldType := ftFloat;
        ADestPrec := ASrcPrec;
        ADestScale := ASrcScale;
      end;
    dtExtended:
      begin
        ADestFieldType := {$IFDEF AnyDAC_D12} ftExtended {$ELSE} ftFloat {$ENDIF};
        ADestPrec := ASrcPrec;
        ADestScale := ASrcScale;
      end;
    dtCurrency:
      begin
        ADestFieldType := ftCurrency;
        ADestPrec := ASrcPrec;
        ADestScale := ASrcScale;
      end;
    dtBCD, dtFmtBCD:
      begin
        if (ASrcDataType = dtFmtBCD) or
           (ASrcPrec > MaxBcdPrecision) or (ASrcScale > MaxBcdScale) then
{$IFDEF AnyDAC_D6}
          ADestFieldType := ftFMTBcd
{$ELSE}
          ADestFieldType := ftFloat
{$ENDIF}
        else
          ADestFieldType := ftBcd;
        ADestPrec := ASrcPrec;
        ADestScale := ASrcScale;
      end;
    dtDateTimeStamp:
      ADestFieldType := {$IFDEF AnyDAC_D6} ftTimeStamp {$ELSE} ftDateTime {$ENDIF};
    dtTimeIntervalFull,
    dtTimeIntervalYM,
    dtTimeIntervalDS:
      ADestFieldType := {$IFDEF AnyDAC_D10} ftOraInterval {$ELSE} ftParadoxOle {$ENDIF};
    dtDateTime:
      ADestFieldType := ftDateTime;
    dtTime:
      ADestFieldType := ftTime;
    dtDate:
      ADestFieldType := ftDate;
    dtAnsiString:
      begin
        ADestSize := ASrcSize;
        if ASrcSize > MaxStringSize then
          ADestFieldType := ftMemo
        else if caFixedLen in ASrcAttrs then
          ADestFieldType := ftFixedChar
        else
          ADestFieldType := ftString;
      end;
    dtWideString:
      begin
        ADestSize := ASrcSize;
        if ASrcSize > MaxStringSize then
          ADestFieldType := {$IFDEF AnyDAC_WideMemo} ftWideMemo {$ELSE} ftFmtMemo {$ENDIF}
        else
{$IFDEF AnyDAC_WIDEMEMO}
          if caFixedLen in ASrcAttrs then
            ADestFieldType := ftFixedWideChar
          else
{$ENDIF}
            ADestFieldType := ftWideString;
      end;
    dtByteString:
      begin
        ADestSize := ASrcSize;
        if ASrcSize > MaxStringSize then
          ADestFieldType := ftBlob
        else if caFixedLen in ASrcAttrs then
          ADestFieldType := ftBytes
        else
          ADestFieldType := ftVarBytes;
      end;
    dtBlob:
      ADestFieldType := ftBlob;
    dtMemo:
      ADestFieldType := ftMemo;
    dtWideMemo:
      ADestFieldType := {$IFDEF AnyDAC_WideMemo} ftWideMemo {$ELSE} ftFmtMemo {$ENDIF};
    dtXML:
      ADestFieldType := ftDBaseOle;
    dtHBlob:                                                            
      ADestFieldType := ftOraBlob;
    dtHBFile:
      ADestFieldType := ftOraBlob;
    dtHMemo:
      ADestFieldType := ftOraClob;
    dtWideHMemo:
      // Here was ftOraClob, but then will be created TMemoField,
      // which does not know anything about Unicode. So, I have
      // changed to ftFmtMemo. But probably may be problems ...
      ADestFieldType := {$IFDEF AnyDAC_WideMemo} ftWideMemo {$ELSE} ftFmtMemo {$ENDIF};
    dtObject:
      ADestFieldType := ftInterface;
    dtRowSetRef:
      ADestFieldType := ftDataSet;
    dtCursorRef:
      ADestFieldType := ftCursor;
    dtRowRef:
      ADestFieldType := ftAdt;
    dtArrayRef:
      ADestFieldType := ftArray;
    dtParentRowRef:
      ADestFieldType := ftReference;
    dtGUID:
      begin
        ADestFieldType := ftGUID;
        ADestSize := C_AD_GUIDStrLen;
      end;
  end;
end;

{-------------------------------------------------------------------------------}
class procedure TADFormatOptions.FieldDef2ColumnDef(ASrcFieldType: TFieldType;
  ASrcSize: LongWord; ASrcPrec, ASrcScale: Integer; var ADestDataType: TADDataType;
  var ADestSize: LongWord; var ADestPrec, ADestScale: Integer;
  var ADestAttrs: TADDataAttributes);
begin
  ADestDataType := dtUnknown;
  ADestSize := 0;
  ADestPrec := 0;
  ADestScale := 0;
  ADestAttrs := [];
  case ASrcFieldType of
    ftUnknown:
      ;
    ftBoolean:
      ADestDataType := dtBoolean;
{$IFDEF AnyDAC_D12}
    ftShortint:
      ADestDataType := dtSByte;
    ftByte:
      ADestDataType := dtByte;
{$ENDIF}
    ftSmallint:
      ADestDataType := dtInt16;
    ftWord:
      ADestDataType := dtUInt16;
    ftInteger:
      ADestDataType := dtInt32;
{$IFDEF AnyDAC_D12}
    ftLongWord:
      ADestDataType := dtUInt32;
{$ENDIF}
    ftAutoInc:
      begin
        ADestDataType := dtInt32;
        ADestAttrs := [caAutoInc];
      end;
    ftLargeint:
      ADestDataType := dtInt64;
{$IFDEF AnyDAC_D14}
    ftSingle:
      begin
        ADestDataType := dtSingle;
        ADestPrec := ASrcPrec;
        ADestScale := ASrcScale;
      end;
{$ENDIF}
    ftFloat:
      begin
        ADestDataType := dtDouble;
        ADestPrec := ASrcPrec;
        ADestScale := ASrcScale;
      end;
{$IFDEF AnyDAC_D12}
    ftExtended:
      begin
        ADestDataType := dtExtended;
        ADestPrec := ASrcPrec;
        ADestScale := ASrcScale;
      end;
 {$ENDIF}
    ftCurrency:
      begin
        ADestDataType := dtCurrency;
        if ASrcPrec = 0 then
          ADestPrec := 19
        else
          ADestPrec := ASrcPrec;
        if ASrcScale = 0 then
          ADestScale := 4
        else
          ADestScale := ASrcScale;
      end;
    ftBcd:
      begin
        ADestDataType := dtBCD;
        ADestPrec := ASrcPrec;
        ADestScale := ASrcScale;
      end;
{$IFDEF AnyDAC_D6Base}
    ftFmtBCD:
      begin
        ADestDataType := dtFmtBCD;
        ADestPrec := ASrcPrec;
        ADestScale := ASrcScale;
      end;
    ftTimeStamp:
      ADestDataType := dtDateTimeStamp;
{$ENDIF}
{$IFDEF AnyDAC_D10}
    ftOraInterval,
{$ENDIF}
    ftParadoxOle:
      ADestDataType := dtTimeIntervalDS;
    ftDateTime:
      ADestDataType := dtDateTime;
    ftTime:
      ADestDataType := dtTime;
    ftDate:
      ADestDataType := dtDate;
    ftFixedChar:
      begin
        ADestDataType := dtAnsiString;
        ADestSize := ASrcSize;
        ADestAttrs := [caFixedLen];
      end;
    ftString:
      begin
        ADestDataType := dtAnsiString;
        ADestSize := ASrcSize;
      end;
{$IFDEF AnyDAC_WIDEMEMO}
    ftFixedWideChar:
      begin
        ADestDataType := dtWideString;
        ADestSize := ASrcSize;
        ADestAttrs := [caFixedLen];
      end;
{$ENDIF}
    ftWideString:
      begin
        ADestDataType := dtWideString;
        ADestSize := ASrcSize;
      end;
    ftBytes:
      begin
        ADestDataType := dtByteString;
        ADestSize := ASrcSize;
        ADestAttrs := [caFixedLen];
      end;
    ftVarBytes:
      begin
        ADestDataType := dtByteString;
        ADestSize := ASrcSize;
        ADestAttrs := [];
      end;
    ftBlob,
    ftGraphic,
    ftTypedBinary:
      begin
        ADestDataType := dtBlob;
        ADestAttrs := [caBlobData];
      end;
    ftMemo:
      begin
        ADestDataType := dtMemo;
        ADestAttrs := [caBlobData];
      end;
{$IFDEF AnyDAC_WideMemo}
    ftWideMemo,
{$ENDIF}
    ftFmtMemo:
      begin
        ADestDataType := dtWideMemo;
        ADestAttrs := [caBlobData];
      end;
    ftDBaseOle:
      begin
        ADestDataType := dtXML;
        ADestAttrs := [caBlobData];
      end;
    ftOraBlob:
      begin
        ADestDataType := dtHBlob;
        ADestAttrs := [caBlobData];
      end;
    ftOraClob:
      begin
        ADestDataType := dtHMemo;
        ADestAttrs := [caBlobData];
      end;
    ftInterface, ftIDispatch:
      ADestDataType := dtObject;
    ftReference, ftVariant:
      ADestDataType := dtUnknown;
    ftCursor:
      ADestDataType := dtCursorRef;
    ftDataSet:
      ADestDataType := dtRowSetRef;
    ftAdt:
      ADestDataType := dtRowRef;
    ftArray:
      ADestDataType := dtArrayRef;
    ftGUID:
      ADestDataType := dtGUID;
  end;
end;

{-------------------------------------------------------------------------------}
class procedure TADFormatOptions.FieldDef2ColumnDef(AField: TField;
  var ADestDataType: TADDataType; var ADestSize: LongWord; var ADestPrec,
  ADestScale: Integer; var ADestAttrs: TADDataAttributes);
var
  iPrecision, iScale: Integer;
begin
  iPrecision := 0;
  iScale := 0;
  if AField is TFloatField then
    iPrecision := TFloatField(AField).Precision
{$IFDEF AnyDAC_12}
  else if AField is TExtendedField then
    iPrecision := TExtendedField(AField).Precision
{$ENDIF}
  else if AField is TBCDField then begin
    iPrecision := TBCDField(AField).Precision;
    iScale := TBCDField(AField).Size;
  end
{$IFDEF AnyDAC_D6}
  else if AField is TFMTBCDField then begin
    iPrecision := TFMTBCDField(AField).Precision;
    iScale := TFMTBCDField(AField).Size;
  end
{$ENDIF}
  else if AField is TCurrencyField then begin
    iPrecision := TCurrencyField(AField).Precision;
    iScale := 4;
  end;
  FieldDef2ColumnDef(AField.DataType, AField.Size, iPrecision, iScale,
    ADestDataType, ADestSize, ADestPrec, ADestScale, ADestAttrs);
end;

{-------------------------------------------------------------------------------}
class procedure TADFormatOptions.FieldDef2ColumnDef(AFieldDef: TFieldDef;
  var ADestDataType: TADDataType; var ADestSize: LongWord; var ADestPrec,
  ADestScale: Integer; var ADestAttrs: TADDataAttributes);
var
  iScale: Integer;
begin
  iScale := 0;
  if AFieldDef.DataType = ftBCD then
    iScale := AFieldDef.Size
{$IFDEF AnyDAC_D6Base}
  else if AFieldDef.DataType = ftFmtBCD then
    iScale := AFieldDef.Size
{$ENDIF}
  else if AFieldDef.DataType = ftCurrency then
    iScale := 4;
  FieldDef2ColumnDef(AFieldDef.DataType, AFieldDef.Size, AFieldDef.Precision,
    iScale, ADestDataType, ADestSize, ADestPrec, ADestScale, ADestAttrs);
end;

{-------------------------------------------------------------------------------}
procedure TADFormatOptions.CheckConversion(ASrc, ADest: TADDataType);
begin
  if C_AD_AllowedConversions[ASrc, ADest] = 0 then
    ADException(nil, [S_AD_LStan], er_AD_ConvIsNotSupported, []);
end;

{-------------------------------------------------------------------------------}
const
  SF_D: String = '%d';
  SF_U: String = '%u';
  SF_F: String = '%f';
  SF_S: String = '%s';
  SF_G: String = '{%.8x-%.4x-%.4x-%.2x%.2x-%.2x%.2x%.2x%.2x%.2x%.2x}';
  SWF_D: TADWideString = '%d';
  SWF_U: TADWideString = '%u';
  SWF_F: TADWideString = '%f';
  SWF_S: TADWideString = '%s';
  SWF_G: TADWideString = '{%.8x-%.4x-%.4x-%.2x%.2x-%.2x%.2x%.2x%.2x%.2x%.2x}';
  RLongDate: TADSQLTimeStamp = (Year: 2002; Month: 9; Day: 29; Hour: 23;
    Minute: 59; Second: 59; Fractions: 999);
  RLongInt: TADSQLTimeInterval = (Sign: -1; Kind: itDay2Second; Days: 29; Hours: 23;
    Minutes: 59; Seconds: 59; Fractions: 999);
var
  C_AD_MaxLenTimeStampStr: Integer = -1;
  C_AD_MaxLenTimeIntStr: Integer = -1;

procedure TADFormatOptions.ConvertRawData(ASrcType, ADestType: TADDataType;
  ApSrc: Pointer; ASrcSize: LongWord; var ApDest: Pointer; ADestMaxSize: LongWord;
  var ADestSize: LongWord; AEncoder: TADEncoder);
var
  lConverted: Boolean;
  rSTS: TADSQLTimeStamp;
  c: Currency;
  buff: array [0 .. 255] of Byte;

  function GetStorageSize: Integer;
  begin
    case ADestType of
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
    dtDateTime:         Result := Sizeof(TDateTimeRec);
    dtDateTimeStamp:    Result := Sizeof(TADSQLTimeStamp);
    dtTimeIntervalFull,
    dtTimeIntervalYM,
    dtTimeIntervalDS:   Result := SizeOf(TADSQLTimeInterval);
    dtTime:             Result := Sizeof(Longint);
    dtDate:             Result := Sizeof(Longint);
    dtGUID:             Result := Sizeof(TGUID);
    dtObject:           Result := Sizeof(IADDataStoredObject);
    else                Result := 0;
    end;
  end;

  procedure Val2WStr(const AFmt: TADWideString; const AValues: array of const);
  var
    pBuff: Pointer;
    iLen: Integer;
{$IFNDEF AnyDAC_D6}
    s: String;
{$ENDIF}
  begin
    if ApDest = nil then begin
      pBuff := Pointer(@buff[0]);
      iLen := SizeOf(buff);
    end
    else begin
      pBuff := ApDest;
      iLen := ADestMaxSize;
    end;
{$IFDEF AnyDAC_D6}
    ADestSize := WideFormatBuf(pBuff^, iLen div SizeOf(WideChar),
      PWideChar(AFmt)^, Length(AFmt), AValues);
{$ELSE}
    s := Format(AFmt, AValues);
    ADestSize := AEncoder.Encode(PChar(s), Length(s), pBuff, ecANSI, ecUTF16);
{$ENDIF}
    PWideChar(pBuff)[ADestSize] := #0;
  end;

  procedure Val2AStr(const AFmt: String; const AValues: array of const);
  var
    pBuff: Pointer;
{$IFNDEF NEXTGEN}
    iLen: Integer;
    sFmt: AnsiString;
{$ENDIF}
  begin
{$IFNDEF NEXTGEN}
    if ApDest = nil then begin
      pBuff := Pointer(@buff[0]);
      iLen := SizeOf(buff);
    end
    else begin
      pBuff := ApDest;
      iLen := ADestMaxSize;
    end;
    sFmt := AnsiString(AFmt);
    ADestSize := {$IFDEF AnyDAC_D18} System.AnsiStrings. {$ENDIF}
      FormatBuf(pBuff^, iLen, PAnsiChar(sFmt)^, Length(sFmt), AValues);
    PAnsiChar(pBuff)[ADestSize] := #0;
{$ELSE}
    pBuff := ApDest;
    ApDest := Pointer(@buff[0]);
    Val2WStr(AFmt, AValues);
    ADestSize := AEncoder.Encode(ApDest, ADestSize, pBuff, ecUTF16, ecANSI);
    ApDest := pBuff;
{$ENDIF}
  end;

  procedure Str2Dest;
  var
    s: String;
    e: Extended;

    procedure GetStr;
    begin
      SetString(s, PChar(ApSrc), ASrcSize);
    end;

  begin
    case ADestType of
    dtBoolean:          PWordBool(ApDest)^ := (PChar(ApSrc)^ = 'T') or (PChar(ApSrc)^ =  't') or
                                              (PChar(ApSrc)^ = 'Y') or (PChar(ApSrc)^ =  'y');
    dtSByte:            ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(ShortInt), False);
    dtInt16:            ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(SmallInt), False);
    dtInt32:            ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(Integer), False);
    dtInt64:            ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(Int64), False);
    dtByte:             ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(Byte), True);
    dtUInt16:           ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(Word), True);
    dtUInt32:           ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(LongWord), True);
    dtUInt64:           ADStr2Int(PChar(ApSrc), ASrcSize, ApDest, SizeOf(UInt64), True);
    dtSingle:           begin ADStr2Float(PChar(ApSrc), ASrcSize, e, Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator)); PSingle(ApDest)^ := e; end;
    dtDouble:           begin ADStr2Float(PChar(ApSrc), ASrcSize, e, Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator)); PDouble(ApDest)^ := e; end;
    dtExtended:         ADStr2Float(PChar(ApSrc), ASrcSize, PExtended(ApDest)^, Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator));
    dtCurrency:         ADStr2Curr(PChar(ApSrc), ASrcSize, PCurrency(ApDest)^, Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator));
    dtBCD,
    dtFmtBCD:           ADStr2BCD(PChar(ApSrc), ASrcSize, PADBcd(ApDest)^, Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator));
    dtDateTime:         begin GetStr; PADDateTimeData(ApDest)^.DateTime := ADDateTime2MSecs(StrToDateTime(s)); end;
    dtTime:             begin GetStr; PLongword(ApDest)^ := ADDateTime2Time(StrToDateTime(s)); end;
    dtDate:             begin GetStr; PLongword(ApDest)^ := ADDateTime2Date(StrToDateTime(s)); end;
    dtDateTimeStamp:    begin GetStr; PADSQLTimeStamp(ApDest)^ := ADDateTime2SQLTimeStamp(StrToDateTime(s)); end;
    dtTimeIntervalFull,
    dtTimeIntervalYM,
    dtTimeIntervalDS:   begin GetStr; PADSQLTimeInterval(ApDest)^ := ADStr2SQLTimeInterval(s); end;
    dtGUID:             begin GetStr; PGUID(ApDest)^ := StringToGUID(s); end;
    else                lConverted := False;
    end;
  end;

  procedure AStr2Dest;
  var
    pPrevSrc, pDest: Pointer;
    iPrevLen: LongWord;
  begin
    pPrevSrc := ApSrc;
    iPrevLen := ASrcSize;
    try
      pDest := @buff[0];
      ASrcSize := AEncoder.Decode(ApSrc, ASrcSize, pDest, ecDefault, ecANSI);
      ApSrc := pDest;
      Str2Dest;
    finally
      ApSrc := pPrevSrc;
      ASrcSize := iPrevLen;
    end;
  end;

  procedure WStr2Dest;
  var
    pPrevSrc, pDest: Pointer;
    iPrevLen: LongWord;
  begin
    pPrevSrc := ApSrc;
    iPrevLen := ASrcSize;
    try
      pDest := @buff[0];
      ASrcSize := AEncoder.Decode(ApSrc, ASrcSize, pDest, ecDefault, ecUTF16);
      ApSrc := pDest;
      Str2Dest;
    finally
      ApSrc := pPrevSrc;
      ASrcSize := iPrevLen;
    end;
  end;

  procedure BCD2Str(ApValue: PADBcd; AEncoding: TADEncoding);
  begin
    ADBCD2Str(PChar(@buff[0]), Integer(ADestSize), ApValue^, Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator));
    if ADestSize >= ADestMaxSize then
      ADestSize := ADestMaxSize
    else
      Inc(ADestSize);
    AEncoder.Encode(PChar(@buff[0]), Integer(ADestSize), ApDest, ecDefault, AEncoding);
  end;

  procedure Int2BCD(ApValue: Pointer; ASize: Integer);
  var
    pBuff: PChar;
    iLen: Integer;
  begin
    pBuff := PChar(@buff[0]);
    iLen := (SizeOf(buff) - SizeOf(Char)) div SizeOf(Char);
    ADInt2Str(ApValue, ASize, pBuff, iLen, 0);
    ADStr2BCD(pBuff, iLen, PADBcd(ApDest)^, Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator));
  end;

  procedure BCD2Int(ADestLen: Integer; ANoSign: Boolean);
  var
    iLen: Integer;
    pBuff: PChar;
  begin
    pBuff := PChar(@buff[0]);
    iLen := 0;
    ADBCD2Str(pBuff, iLen, PADBcd(ApSrc)^, Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator));
    ADStr2Int(pBuff, iLen, ApDest, ADestLen, ANoSign);
  end;

  procedure BCD2Dbl(ADestLen: Integer);
  var
    E: Extended;
  begin
    ADBCD2Double(PADBcd(ApSrc)^, E);
    case ADestLen of
    SizeOf(Single):   PSingle(ApDest)^ := E;
    SizeOf(Double):   PDouble(ApDest)^ := E;
{$IFDEF CPU386}
    SizeOf(Extended): PExtended(ApDest)^ := E;
{$ENDIF}
    end;
  end;

  procedure STS2AStr(ApValue: PADSQLTimeStamp; AKind: TADDataType);
  var
    sFmt, sVal: String;
  begin
    case AKind of
    dtDateTime,
    dtDateTimeStamp: sFmt := '';
    dtTime:          sFmt := {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} ShortTimeFormat;
    dtDate:          sFmt := {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} ShortDateFormat;
    end;
    sVal := '';
    DateTimeToString(sVal, sFmt, ADSQLTimeStamp2DateTime(ApValue^));
    Val2AStr(SF_S, [sVal]);
  end;

  procedure STS2WStr(ApValue: PADSQLTimeStamp; AKind: TADDataType);
  var
    sFmt, sVal: String;
  begin
    case AKind of
    dtDateTime,
    dtDateTimeStamp: sFmt := '';
    dtTime:          sFmt := {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} ShortTimeFormat;
    dtDate:          sFmt := {$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} ShortDateFormat;
    end;
    sVal := '';
    DateTimeToString(sVal, sFmt, ADSQLTimeStamp2DateTime(ApValue^));
    Val2WStr(SWF_S, [sVal]);
  end;

  procedure AStr2WStr;
  var
    sb: TADByteString;
  begin
    if ApSrc = ApDest then begin
      SetLength(sb, ASrcSize * SizeOf(TADAnsiChar));
      Move(PADAnsiString(ApSrc)^, PADByteString(sb)^, ASrcSize * SizeOf(TADAnsiChar));
      ApSrc := PADByteString(sb);
    end;
    AEncoder.Encode(ApSrc, ASrcSize, ApDest, ecANSI, ecUTF16);
  end;

  procedure WStr2AStr;
  var
    sw: TADWideString;
  begin
    if ApSrc = ApDest then begin
      SetString(sw, PWideChar(ApSrc), ASrcSize);
      ApSrc := PWideChar(sw);
    end;
    AEncoder.Encode(ApSrc, ASrcSize, ApDest, ecUTF16, ecANSI);
  end;

begin
  if ASrcType = ADestType then begin
    ADestSize := ASrcSize;
    if ApSrc <> nil then
      ApDest := ApSrc;
    Exit;
  end;
  CheckConversion(ASrcType, ADestType);
  ADestSize := GetStorageSize();
  lConverted := True;
  case ASrcType of
  dtBoolean:
    if ADestType = dtAnsiString then begin
      if (ApSrc <> nil) and (ApDest <> nil) then begin
        if PWordBool(ApSrc)^ then
          PChar(ApDest)[0] := 'T'
        else
          PChar(ApDest)[0] := 'F';
        PChar(ApDest)[1] := #0;
      end;
      ADestSize := 1;
    end
    else if ADestType = dtWideString then begin
      if (ApSrc <> nil) and (ApDest <> nil) then begin
        if PWordBool(ApSrc)^ then
          PWideChar(ApDest)[0] := 'T'
        else
          PWideChar(ApDest)[0] := 'F';
        PWideChar(ApDest)[1] := #0;
      end;
      ADestSize := 1;
    end
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtSByte:      PShortInt(ApDest)^ := ShortInt(PWordBool(ApSrc)^);
      dtInt16:      PSmallInt(ApDest)^ := SmallInt(PWordBool(ApSrc)^);
      dtInt32:      PInteger(ApDest)^ := Integer(PWordBool(ApSrc)^);
      dtInt64:      PInt64(ApDest)^ := Int64(PWordBool(ApSrc)^);
      dtByte:       PByte(ApDest)^ := Byte(PWordBool(ApSrc)^);
      dtUInt16:     PWord(ApDest)^ := Word(PWordBool(ApSrc)^);
      dtUInt32:     PLongWord(ApDest)^ := LongWord(PWordBool(ApSrc)^);
      dtUInt64:     PUInt64(ApDest)^ := UInt64(PWordBool(ApSrc)^);
      dtBCD,
      dtFmtBCD:     Int2BCD(PWordBool(ApSrc), SizeOf(WordBool));
      else lConverted := False;
      end;
  dtSByte:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_D, [PShortInt(ApSrc)^])
      else
        ADestSize := 5
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_D, [PShortInt(ApSrc)^])
      else
        ADestSize := 5
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:    PWordBool(ApDest)^ := WordBool(PShortInt(ApSrc)^);
      dtInt16:      PSmallInt(ApDest)^ := PShortInt(ApSrc)^;
      dtInt32:      PInteger(ApDest)^ := PShortInt(ApSrc)^;
      dtInt64:      PInt64(ApDest)^ := PShortInt(ApSrc)^;
      dtByte:       PByte(ApDest)^ := PShortInt(ApSrc)^;
      dtUInt16:     PWord(ApDest)^ := PShortInt(ApSrc)^;
      dtUInt32:     PLongWord(ApDest)^ := PShortInt(ApSrc)^;
      dtUInt64:     PUInt64(ApDest)^ := Word(PShortInt(ApSrc)^);
      dtSingle:     PSingle(ApDest)^ := PShortInt(ApSrc)^;
      dtDouble:     PDouble(ApDest)^ := PShortInt(ApSrc)^;
      dtExtended:   PExtended(ApDest)^ := PShortInt(ApSrc)^;
      dtCurrency:   PCurrency(ApDest)^ := PShortInt(ApSrc)^;
      dtBCD,
      dtFmtBCD:     Int2BCD(PShortInt(ApSrc), SizeOf(ShortInt));
      else lConverted := False;
      end;
  dtInt16:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_D, [PSmallInt(ApSrc)^])
      else
        ADestSize := 7
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_D, [PSmallInt(ApSrc)^])
      else
        ADestSize := 7
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PSmallInt(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := ShortInt(PSmallInt(ApSrc)^);
      dtInt32:    PInteger(ApDest)^ := PSmallInt(ApSrc)^;
      dtInt64:    PInt64(ApDest)^ := PSmallInt(ApSrc)^;
      dtByte:     PByte(ApDest)^ := Byte(PSmallInt(ApSrc)^);
      dtUInt16:   PWord(ApDest)^ := PSmallInt(ApSrc)^;
      dtUInt32:   PLongWord(ApDest)^ := PSmallInt(ApSrc)^;
      dtUInt64:   PUInt64(ApDest)^ := LongWord(PSmallInt(ApSrc)^);
      dtSingle:   PSingle(ApDest)^ := PSmallInt(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PSmallInt(ApSrc)^;
      dtExtended: PExtended(ApDest)^ := PSmallInt(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PSmallInt(ApSrc)^;
      dtBCD,
      dtFmtBCD:   Int2BCD(PSmallInt(ApSrc), SizeOf(Smallint));
      else lConverted := False;
      end;
  dtInt32:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_D, [PInteger(ApSrc)^])
      else
        ADestSize := 12
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_D, [PInteger(ApSrc)^])
      else
        ADestSize := 12
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PInteger(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := ShortInt(PInteger(ApSrc)^);
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(PInteger(ApSrc)^);
      dtInt64:    PInt64(ApDest)^ := PInteger(ApSrc)^;
      dtByte:     PByte(ApDest)^ := Byte(PInteger(ApSrc)^);
      dtUInt16:   PWord(ApDest)^ := Word(PInteger(ApSrc)^);
      dtUInt32:   PLongWord(ApDest)^ := PInteger(ApSrc)^;
      dtUInt64:   PUInt64(ApDest)^ := Int64(PInteger(ApSrc)^);
      dtSingle:   PSingle(ApDest)^ := PInteger(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PInteger(ApSrc)^;
      dtExtended: PExtended(ApDest)^ := PInteger(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PInteger(ApSrc)^;
      dtBCD,
      dtFmtBCD:   Int2BCD(PInteger(ApSrc), SizeOf(Integer));
      else lConverted := False;
      end;
  dtInt64:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_D, [PInt64(ApSrc)^])
      else
        ADestSize := 22
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_D, [PInt64(ApSrc)^])
      else
        ADestSize := 22
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PInt64(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := ShortInt(PInt64(ApSrc)^);
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(PInt64(ApSrc)^);
      dtInt32:    PInteger(ApDest)^ := Integer(PInt64(ApSrc)^);
      dtByte:     PByte(ApDest)^ := Byte(PInt64(ApSrc)^);
      dtUInt16:   PWord(ApDest)^ := Word(PInt64(ApSrc)^);
      dtUInt32:   PLongWord(ApDest)^ := LongWord(PInt64(ApSrc)^);
      dtUInt64:   PUInt64(ApDest)^ := PInt64(ApSrc)^;
      dtSingle:   PSingle(ApDest)^ := PInt64(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PInt64(ApSrc)^;
      dtExtended: PExtended(ApDest)^ := PInt64(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PInt64(ApSrc)^;
      dtBCD,
      dtFmtBCD:   Int2BCD(PInt64(ApSrc), SizeOf(Int64));
      else lConverted := False;
      end;
  dtByte:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_U, [PByte(ApSrc)^])
      else
        ADestSize := 4
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_U, [PByte(ApSrc)^])
      else
        ADestSize := 4
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PByte(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := PByte(ApSrc)^;
      dtInt16:    PSmallInt(ApDest)^ := PByte(ApSrc)^;
      dtInt32:    PInteger(ApDest)^ := PByte(ApSrc)^;
      dtInt64:    PInt64(ApDest)^ := PByte(ApSrc)^;
      dtUInt16:   PWord(ApDest)^ := PByte(ApSrc)^;
      dtUInt32:   PLongWord(ApDest)^ := PByte(ApSrc)^;
      dtUInt64:   PUInt64(ApDest)^ := PByte(ApSrc)^;
      dtSingle:   PSingle(ApDest)^ := PByte(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PByte(ApSrc)^;
      dtExtended: PExtended(ApDest)^ := PByte(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PByte(ApSrc)^;
      dtBCD,
      dtFmtBCD:   Int2BCD(PByte(ApSrc), SizeOf(Byte));
      else lConverted := False;
      end;
  dtUInt16:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_U, [PWord(ApSrc)^])
      else
        ADestSize := 6
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_U, [PWord(ApSrc)^])
      else
        ADestSize := 6
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PWord(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := ShortInt(PWord(ApSrc)^);
      dtInt16:    PSmallInt(ApDest)^ := PWord(ApSrc)^;
      dtInt32:    PInteger(ApDest)^ := PWord(ApSrc)^;
      dtInt64:    PInt64(ApDest)^ := PWord(ApSrc)^;
      dtByte:     PByte(ApDest)^ := Byte(PWord(ApSrc)^);
      dtUInt32:   PLongWord(ApDest)^ := PWord(ApSrc)^;
      dtUInt64:   PUInt64(ApDest)^ := PWord(ApSrc)^;
      dtSingle:   PSingle(ApDest)^ := PWord(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PWord(ApSrc)^;
      dtExtended: PExtended(ApDest)^ := PWord(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PWord(ApSrc)^;
      dtBCD,
      dtFmtBCD:   Int2BCD(PWord(ApSrc), SizeOf(Word));
      else lConverted := False;
      end;
  dtUInt32:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_U, [PLongWord(ApSrc)^])
      else
        ADestSize := 11
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_U, [PLongWord(ApSrc)^])
      else
        ADestSize := 11
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PLongWord(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := ShortInt(PLongWord(ApSrc)^);
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(PLongWord(ApSrc)^);
      dtInt32:    PInteger(ApDest)^ := PLongWord(ApSrc)^;
      dtInt64:    PInt64(ApDest)^ := PLongWord(ApSrc)^;
      dtByte:     PByte(ApDest)^ := Byte(PLongWord(ApSrc)^);
      dtUInt16:   PWord(ApDest)^ := Word(PLongWord(ApSrc)^);
      dtUInt64:   PUInt64(ApDest)^ := PLongWord(ApSrc)^;
      dtSingle:   PSingle(ApDest)^ := PLongWord(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PLongWord(ApSrc)^;
      dtExtended: PExtended(ApDest)^ := PLongWord(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PLongWord(ApSrc)^;
      dtBCD,
      dtFmtBCD:   Int2BCD(PLongWord(ApSrc), SizeOf(LongWord));
      else lConverted := False;
      end;
  dtUInt64:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_D, [PUInt64(ApSrc)^])
      else
        ADestSize := 22
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_D, [PUInt64(ApSrc)^])
      else
        ADestSize := 22
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  PWordBool(ApDest)^ := WordBool(PUInt64(ApSrc)^);
      dtSByte:    PShortInt(ApDest)^ := ShortInt(PUInt64(ApSrc)^);
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(PUInt64(ApSrc)^);
      dtInt32:    PInteger(ApDest)^ := Integer(PUInt64(ApSrc)^);
      dtInt64:    PInt64(ApDest)^ := PUInt64(ApSrc)^;
      dtByte:     PByte(ApDest)^ := Byte(PUInt64(ApSrc)^);
      dtUInt16:   PWord(ApDest)^ := Word(PUInt64(ApSrc)^);
      dtUInt32:   PLongWord(ApDest)^ := LongWord(PUInt64(ApSrc)^);
      dtSingle:   PSingle(ApDest)^ := PUInt64(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PUInt64(ApSrc)^;
      dtExtended: PExtended(ApDest)^ := PUInt64(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PUInt64(ApSrc)^;
      dtBCD,
      dtFmtBCD:   Int2BCD(PUInt64(ApSrc), SizeOf(UInt64));
      else lConverted := False;
      end;
  dtSingle:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_F, [PSingle(ApSrc)^])
      else
        ADestSize := 11
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_F, [PSingle(ApSrc)^])
      else
        ADestSize := 11
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtSByte:    PShortInt(ApDest)^ := ShortInt(Trunc(PSingle(ApSrc)^));
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(Trunc(PSingle(ApSrc)^));
      dtInt32:    PInteger(ApDest)^ := Integer(Trunc(PSingle(ApSrc)^));
      dtInt64:    PInt64(ApDest)^ := Trunc(PSingle(ApSrc)^);
      dtByte:     PByte(ApDest)^ := Byte(Trunc(PSingle(ApSrc)^));
      dtUInt16:   PWord(ApDest)^ := Word(Trunc(PSingle(ApSrc)^));
      dtUInt32:   PLongWord(ApDest)^ := LongWord(Trunc(PSingle(ApSrc)^));
      dtUInt64:   PUInt64(ApDest)^ := Trunc(PSingle(ApSrc)^);
      dtDouble:   PDouble(ApDest)^ := PSingle(ApSrc)^;
      dtExtended: PExtended(ApDest)^ := PSingle(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PSingle(ApSrc)^;
      dtBCD,
      dtFmtBCD:   ADDouble2BCD(PSingle(ApSrc)^, PADBcd(ApDest)^);
      else lConverted := False;
      end;
  dtDouble:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_F, [PDouble(ApSrc)^])
      else
        ADestSize := 19
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_F, [PDouble(ApSrc)^])
      else
        ADestSize := 19
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtSByte:    PShortInt(ApDest)^ := ShortInt(Trunc(PDouble(ApSrc)^));
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(Trunc(PDouble(ApSrc)^));
      dtInt32:    PInteger(ApDest)^ := Integer(Trunc(PDouble(ApSrc)^));
      dtInt64:    PInt64(ApDest)^ := Trunc(PDouble(ApSrc)^);
      dtByte:     PByte(ApDest)^ := Byte(Trunc(PDouble(ApSrc)^));
      dtUInt16:   PWord(ApDest)^ := Word(Trunc(PDouble(ApSrc)^));
      dtUInt32:   PLongWord(ApDest)^ := LongWord(Trunc(PDouble(ApSrc)^));
      dtUInt64:   PUInt64(ApDest)^ := Trunc(PDouble(ApSrc)^);
      dtSingle:   PSingle(ApDest)^ := PDouble(ApSrc)^;
      dtExtended: PExtended(ApDest)^ := PDouble(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PDouble(ApSrc)^;
      dtBCD,
      dtFmtBCD:   ADDouble2BCD(PDouble(ApSrc)^, PADBcd(ApDest)^);
      else lConverted := False;
      end;
  dtExtended:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_F, [PExtended(ApSrc)^])
      else
        ADestSize := 23
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_F, [PExtended(ApSrc)^])
      else
        ADestSize := 23
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtSByte:    PShortInt(ApDest)^ := ShortInt(Trunc(PExtended(ApSrc)^));
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(Trunc(PExtended(ApSrc)^));
      dtInt32:    PInteger(ApDest)^ := Integer(Trunc(PExtended(ApSrc)^));
      dtInt64:    PInt64(ApDest)^ := Trunc(PExtended(ApSrc)^);
      dtByte:     PByte(ApDest)^ := Byte(Trunc(PExtended(ApSrc)^));
      dtUInt16:   PWord(ApDest)^ := Word(Trunc(PExtended(ApSrc)^));
      dtUInt32:   PLongWord(ApDest)^ := LongWord(Trunc(PExtended(ApSrc)^));
      dtUInt64:   PUInt64(ApDest)^ := Trunc(PExtended(ApSrc)^);
      dtSingle:   PSingle(ApDest)^ := PExtended(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PExtended(ApSrc)^;
      dtCurrency: PCurrency(ApDest)^ := PExtended(ApSrc)^;
      dtBCD,
      dtFmtBCD:   ADDouble2BCD(PExtended(ApSrc)^, PADBcd(ApDest)^);
      else lConverted := False;
      end;
  dtCurrency:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_F, [PCurrency(ApSrc)^])
      else
        ADestSize := 22
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_F, [PCurrency(ApSrc)^])
      else
        ADestSize := 22
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtSByte:    PShortInt(ApDest)^ := ShortInt(Trunc(PCurrency(ApSrc)^));
      dtInt16:    PSmallInt(ApDest)^ := SmallInt(Trunc(PCurrency(ApSrc)^));
      dtInt32:    PInteger(ApDest)^ := Integer(Trunc(PCurrency(ApSrc)^));
      dtInt64:    PInt64(ApDest)^ := Trunc(PCurrency(ApSrc)^);
      dtByte:     PByte(ApDest)^ := Byte(Trunc(PCurrency(ApSrc)^));
      dtUInt16:   PWord(ApDest)^ := Word(Trunc(PCurrency(ApSrc)^));
      dtUInt32:   PLongWord(ApDest)^ := LongWord(Trunc(PCurrency(ApSrc)^));
      dtUInt64:   PUInt64(ApDest)^ := Trunc(PCurrency(ApSrc)^);
      dtSingle:   PSingle(ApDest)^ := PCurrency(ApSrc)^;
      dtDouble:   PDouble(ApDest)^ := PCurrency(ApSrc)^;
      dtExtended: PExtended(ApDest)^ := PCurrency(ApSrc)^;
      dtBCD,
      dtFmtBCD:   CurrToBCD(PCurrency(ApSrc)^, PADBcd(ApDest)^, 20);
      else lConverted := False;
      end;
  dtBCD,
  dtFmtBCD:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        BCD2Str(PADBcd(ApSrc), ecANSI)
      else
        ADestSize := 67
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        BCD2Str(PADBcd(ApSrc), ecUTF16)
      else
        ADestSize := 67
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtBoolean:  BCD2Int(SizeOf(WordBool), True);
      dtSByte:    BCD2Int(SizeOf(ShortInt), False);
      dtInt16:    BCD2Int(SizeOf(SmallInt), False);
      dtInt32:    BCD2Int(SizeOf(Integer), False);
      dtInt64:    BCD2Int(SizeOf(Int64), False);
      dtByte:     BCD2Int(SizeOf(Byte), True);
      dtUInt16:   BCD2Int(SizeOf(Word), True);
      dtUInt32:   BCD2Int(SizeOf(LongWord), True);
      dtUInt64:   BCD2Int(SizeOf(UInt64), True);
      dtSingle:   BCD2Dbl(SizeOf(Single));
      dtDouble:   BCD2Dbl(SizeOf(Double));
      dtExtended: BCD2Dbl(SizeOf(Extended));
      dtCurrency: begin BCDToCurr(PADBcd(ApSrc)^, c); PCurrency(ApDest)^ := c; end;
      dtFmtBCD,
      dtBCD:      ApDest := ApSrc;
      else lConverted := False;
      end;
  dtDateTime:
    begin
      if ApSrc <> nil then
        rSTS := ADDateTime2SQLTimeStamp(ADMSecs2DateTime(PADDateTimeData(ApSrc)^.DateTime));
      if ADestType = dtAnsiString then
        if ApSrc <> nil then
          STS2AStr(@rSTS, dtDateTime)
        else
          ADestSize := C_AD_MaxLenTimeStampStr
      else if ADestType = dtWideString then
        if ApSrc <> nil then
          STS2WStr(@rSTS, dtDateTime)
        else
          ADestSize := C_AD_MaxLenTimeStampStr
      else if (ApSrc <> nil) and (ApDest <> nil) then
        case ADestType of
        dtTime:          PLongword(ApDest)^ := ADSQLTimeStamp2Time(rSTS);
        dtDate:          PLongword(ApDest)^ := ADSQLTimeStamp2Date(rSTS);
        dtDateTimeStamp: PADSQLTimeStamp(ApDest)^ := rSTS;
        else lConverted := False;
        end;
    end;
  dtDateTimeStamp:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        STS2AStr(PADSQLTimeStamp(ApSrc), dtDateTimeStamp)
      else
        ADestSize := C_AD_MaxLenTimeStampStr
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        STS2WStr(PADSQLTimeStamp(ApSrc), dtDateTimeStamp)
      else
        ADestSize := C_AD_MaxLenTimeStampStr
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtTime:     PLongword(ApDest)^ := ADSQLTimeStamp2Time(PADSQLTimeStamp(ApSrc)^);
      dtDate:     PLongword(ApDest)^ := ADSQLTimeStamp2Date(PADSQLTimeStamp(ApSrc)^);
      dtDateTime: PADDateTimeData(ApDest)^.DateTime := ADDateTime2MSecs(
        ADSQLTimeStamp2DateTime(PADSQLTimeStamp(ApSrc)^));
      else lConverted := False;
      end;
  dtTimeIntervalFull,
  dtTimeIntervalYM,
  dtTimeIntervalDS:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_S, [ADSQLTimeInterval2Str(PADSQLTimeInterval(ApSrc)^)])
      else
        ADestSize := C_AD_MaxLenTimeIntStr
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_S, [ADSQLTimeInterval2Str(PADSQLTimeInterval(ApSrc)^)])
      else
        ADestSize := C_AD_MaxLenTimeIntStr
    else if ADestType in [dtTimeIntervalFull, dtTimeIntervalYM, dtTimeIntervalDS] then
      ApDest := ApSrc
    else
      lConverted := False;
  dtTime:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then begin
        rSTS := ADTime2SQLTimeStamp(PLongword(ApSrc)^);
        STS2AStr(@rSTS, dtTime);
      end
      else
        ADestSize := C_AD_MaxLenTimeStampStr
    else if ADestType = dtWideString then
      if ApSrc <> nil then begin
        rSTS := ADTime2SQLTimeStamp(PLongword(ApSrc)^);
        STS2WStr(@rSTS, dtTime);
      end
      else
        ADestSize := C_AD_MaxLenTimeStampStr
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtDateTime:      PADDateTimeData(ApDest)^.DateTime := ADDateTime2MSecs(
        ADSQLTimeStamp2DateTime(ADTime2SQLTimeStamp(PLongword(ApSrc)^)));
      dtDateTimeStamp: PADSQLTimeStamp(ApDest)^ := ADTime2SQLTimeStamp(PLongword(ApSrc)^)
      else lConverted := False;
      end;
  dtDate:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then begin
        rSTS := ADDate2SQLTimeStamp(PLongword(ApSrc)^);
        STS2AStr(@rSTS, dtDate);
      end
      else
        ADestSize := C_AD_MaxLenTimeStampStr
    else if ADestType = dtWideString then
      if ApSrc <> nil then begin
        rSTS := ADDate2SQLTimeStamp(PLongword(ApSrc)^);
        STS2WStr(@rSTS, dtDate);
      end
      else
        ADestSize := C_AD_MaxLenTimeStampStr
    else if (ApSrc <> nil) and (ApDest <> nil) then
      case ADestType of
      dtDateTime:      PADDateTimeData(ApDest)^.DateTime := ADDateTime2MSecs(
        ADSQLTimeStamp2DateTime(ADDate2SQLTimeStamp(PLongword(ApSrc)^)));
      dtDateTimeStamp: PADSQLTimeStamp(ApDest)^ := ADDate2SQLTimeStamp(PLongword(ApSrc)^)
      else lConverted := False;
      end;
  dtAnsiString:
    if ADestType in [dtWideString, dtWideMemo, dtXML, dtWideHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize div SizeOf(WideChar) then
        ADestSize := ADestMaxSize div SizeOf(WideChar);
      if ApSrc <> nil then
        AStr2WStr;
    end
    else if ADestType in [dtByteString, dtBlob, dtMemo, dtHBlob, dtHBFile, dtHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else if (ApSrc <> nil) and (ApDest <> nil) then
      AStr2Dest;
  dtWideString:
    if ADestType in [dtAnsiString, dtMemo, dtHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        WStr2AStr;
    end
    else if ADestType in [dtWideMemo, dtXML, dtWideHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else if ADestType in [dtByteString, dtBlob, dtHBlob, dtHBFile] then begin
      ADestSize := ASrcSize;
      ADestSize := ADestSize * SizeOf(WideChar);
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else if (ApSrc <> nil) and (ApDest <> nil) then
      WStr2Dest;
  dtByteString:
    case ADestType of
    dtAnsiString,
    dtBlob,
    dtMemo,
    dtHBlob,
    dtHBFile,
    dtHMemo,
    dtGUID:
      begin
        ADestSize := ASrcSize;
        if ADestSize > ADestMaxSize then
          ADestSize := ADestMaxSize;
        if ApSrc <> nil then
          ApDest := ApSrc;
      end;
    dtWideString,
    dtWideMemo,
    dtXML,
    dtWideHMemo:
      begin
        ADestSize := ASrcSize div SizeOf(WideChar);
        if ADestSize > ADestMaxSize div SizeOf(WideChar) then
          ADestSize := ADestMaxSize div SizeOf(WideChar);
        if ApSrc <> nil then
          ApDest := ApSrc;
      end;
    else lConverted := False;
    end;
  dtBlob,
  dtHBlob,
  dtHBFile:
    if ADestType in [dtBlob, dtMemo, dtHBlob, dtHBFile, dtHMemo, dtAnsiString, dtByteString] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else if ADestType in [dtWideMemo, dtXML, dtWideHMemo] then begin
      ADestSize := ASrcSize div SizeOf(WideChar);
      if ADestSize > ADestMaxSize div SizeOf(WideChar) then
        ADestSize := ADestMaxSize div SizeOf(WideChar);
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else lConverted := False;
  dtMemo,
  dtHMemo:
    if ADestType in [dtBlob, dtMemo, dtHBlob, dtHBFile, dtHMemo, dtAnsiString, dtByteString] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else if ADestType in [dtWideMemo, dtXML, dtWideHMemo, dtWideString] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize div SizeOf(WideChar) then
        ADestSize := ADestMaxSize div SizeOf(WideChar);
      if ApSrc <> nil then
        AStr2WStr;
    end
    else lConverted := False;
  dtWideMemo,
  dtXML,
  dtWideHMemo:
    if ADestType in [dtAnsiString, dtMemo, dtHMemo] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        WStr2AStr;
    end
    else if ADestType in [dtWideMemo, dtXML, dtWideHMemo, dtWideString] then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else if ADestType in [dtByteString, dtBlob, dtHBlob, dtHBFile] then begin
      ADestSize := ASrcSize * SizeOf(WideChar);
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end
    else lConverted := False;
  dtGUID:
    if ADestType = dtAnsiString then
      if ApSrc <> nil then
        Val2AStr(SF_G, [PGUID(ApSrc)^.D1, PGUID(ApSrc)^.D2, PGUID(ApSrc)^.D3,
                        PGUID(ApSrc)^.D4[0], PGUID(ApSrc)^.D4[1], PGUID(ApSrc)^.D4[2],
                        PGUID(ApSrc)^.D4[3], PGUID(ApSrc)^.D4[4], PGUID(ApSrc)^.D4[5],
                        PGUID(ApSrc)^.D4[6], PGUID(ApSrc)^.D4[7]])
      else
        ADestSize := C_AD_GUIDStrLen
    else if ADestType = dtWideString then
      if ApSrc <> nil then
        Val2WStr(SWF_G, [PGUID(ApSrc)^.D1, PGUID(ApSrc)^.D2, PGUID(ApSrc)^.D3,
                         PGUID(ApSrc)^.D4[0], PGUID(ApSrc)^.D4[1], PGUID(ApSrc)^.D4[2],
                         PGUID(ApSrc)^.D4[3], PGUID(ApSrc)^.D4[4], PGUID(ApSrc)^.D4[5],
                         PGUID(ApSrc)^.D4[6], PGUID(ApSrc)^.D4[7]])
      else
        ADestSize := C_AD_GUIDStrLen
    else if ADestType = dtByteString then begin
      ADestSize := ASrcSize;
      if ADestSize > ADestMaxSize then
        ADestSize := ADestMaxSize;
      if ApSrc <> nil then
        ApDest := ApSrc;
    end;
  else
    lConverted := False;
  end;
  ASSERT(lConverted);
end;

{-------------------------------------------------------------------------------}
{- TADFetchOptions                                                             -}
{-------------------------------------------------------------------------------}
procedure TADFetchOptions.Assign(ASource: TPersistent);
begin
  if (ASource = nil) or (ASource = Self) then
    Exit;
  if ASource is TADFetchOptions then begin
    if evMode in TADFetchOptions(ASource).FAssignedValues then
      Mode := TADFetchOptions(ASource).Mode;
    if evItems in TADFetchOptions(ASource).FAssignedValues then
      Items := TADFetchOptions(ASource).Items;
    if evRecsSkip in TADFetchOptions(ASource).FAssignedValues then
      RecsSkip := TADFetchOptions(ASource).RecsSkip;
    if evRecsMax in TADFetchOptions(ASource).FAssignedValues then
      RecsMax := TADFetchOptions(ASource).RecsMax;
    if evRowsetSize in TADFetchOptions(ASource).FAssignedValues then
      RowsetSize := TADFetchOptions(ASource).RowsetSize;
    if evCache in TADFetchOptions(ASource).FAssignedValues then
      Cache := TADFetchOptions(ASource).Cache;
    if evAutoClose in TADFetchOptions(ASource).FAssignedValues then
      AutoClose := TADFetchOptions(ASource).AutoClose;
    if evAutoFetchAll in TADFetchOptions(ASource).FAssignedValues then
      AutoFetchAll := TADFetchOptions(ASource).AutoFetchAll;
    if evRecordCountMode in TADFetchOptions(ASource).FAssignedValues then
      RecordCountMode := TADFetchOptions(ASource).RecordCountMode;
    if evUnidirectional in TADFetchOptions(ASource).FAssignedValues then
      Unidirectional := TADFetchOptions(ASource).Unidirectional;
    if evCursorKind in TADFetchOptions(ASource).FAssignedValues then
      CursorKind := TADFetchOptions(ASource).CursorKind;
    if evLiveWindowParanoic in TADFetchOptions(ASource).FAssignedValues then
      LiveWindowParanoic := TADFetchOptions(ASource).LiveWindowParanoic;
    if evLiveWindowFastFirst in TADFetchOptions(ASource).FAssignedValues then
      LiveWindowFastFirst := TADFetchOptions(ASource).LiveWindowFastFirst;
    if evDetailDelay in TADFetchOptions(ASource).FAssignedValues then
      DetailDelay := TADFetchOptions(ASource).DetailDelay;
    if evDetailOptimize in TADFetchOptions(ASource).FAssignedValues then
      DetailOptimize := TADFetchOptions(ASource).DetailOptimize;
    if evDetailCascade in TADFetchOptions(ASource).FAssignedValues then
      DetailCascade := TADFetchOptions(ASource).DetailCascade;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.RestoreDefaults;
begin
  inherited RestoreDefaults;
  FAssignedValues := [];
  FMode := fmOnDemand;
  FRecsSkip := -1;
  FRecsMax := -1;
  FRowsetSize := C_AD_DefRowSetSize;
  FItems := [fiBlobs, fiDetails, fiMeta];
  FCache := [fiBlobs, fiDetails, fiMeta];
  FAutoClose := True;
  FAutoFetchAll := afAll;
  FRecordCountMode := cmVisible;
  FUnidirectional := False;
  FCursorKind := ckAutomatic;
  FLiveWindowParanoic := False;
  FLiveWindowFastFirst := False;
  FDetailDelay := 0;
  FDetailOptimize := True;
  FDetailCascade := False;
  Inc(FVersion);
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsValueOwned(AValue: TADFetchOptionValue;
  out AParentOpts: IADStanOptions): Boolean;
begin
  Result := not Assigned(Container.FParentCallback) or (AValue in FAssignedValues);
  if not Result then begin
    Container.FParentCallback(AParentOpts);
    Result := (AParentOpts = nil);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetRecsSkip: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evRecsSkip, oParentOpts) then
    Result := FRecsSkip
  else
    Result := oParentOpts.FetchOptions.RecsSkip;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetRecsSkip(const AValue: Integer);
begin
  if not (evRecsSkip in FAssignedValues) or (FRecsSkip <> AValue) then begin
    FRecsSkip := AValue;
    Include(FAssignedValues, evRecsSkip);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsESS: Boolean;
begin
  Result := evRecsSkip in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetRecsMax: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evRecsMax, oParentOpts) then
    Result := FRecsMax
  else
    Result := oParentOpts.FetchOptions.RecsMax;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetRecsMax(const AValue: Integer);
begin
  if not (evRecsMax in FAssignedValues) or (FRecsMax <> AValue) then begin
    FRecsMax := AValue;
    Include(FAssignedValues, evRecsMax);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsRMS: Boolean;
begin
  Result := evRecsMax in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetRowsetSize: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evRowsetSize, oParentOpts) then
    Result := FRowsetSize
  else
    Result := oParentOpts.FetchOptions.RowsetSize;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetRowsetSize(const AValue: Integer);
begin
  if not (evRowsetSize in FAssignedValues) or (FRowsetSize <> AValue) then begin
    FRowsetSize := AValue;
    Include(FAssignedValues, evRowsetSize);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetActualRowsetSize: Integer;
var
  iRecsMax: Integer;
begin
  Result := RowsetSize;
  iRecsMax := RecsMax;
  if Mode = fmExactRecsMax then begin
    if iRecsMax > 0 then
      Result := iRecsMax;
  end
  else begin
    if (iRecsMax > 0) and (Result > iRecsMax) then
      Result := iRecsMax;
  end;
  if Result <= 0 then
    Result := 1;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsRSS: Boolean;
begin
  Result := evRowsetSize in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetItems: TADFetchItems;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evItems, oParentOpts) then
    Result := FItems
  else
    Result := oParentOpts.FetchOptions.Items;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetItems(const AValue: TADFetchItems);
begin
  if not (evItems in FAssignedValues) or (FItems <> AValue) then begin
    FItems := AValue;
    Include(FAssignedValues, evItems);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsIS: Boolean;
begin
  Result := evItems in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetMode: TADFetchMode;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evMode, oParentOpts) then
    Result := FMode
  else
    Result := oParentOpts.FetchOptions.Mode;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetMode(const AValue: TADFetchMode);
begin
  if not (evMode in FAssignedValues) or (FMode <> AValue) then begin
    FMode := AValue;
    Include(FAssignedValues, evMode);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsMS: Boolean;
begin
  Result := evMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetCache: TADFetchItems;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evCache, oParentOpts) then
    Result := FCache
  else
    Result := oParentOpts.FetchOptions.Cache;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetCache(const AValue: TADFetchItems);
begin
  if not (evCache in FAssignedValues) or (FCache <> AValue) then begin
    FCache := AValue;
    Include(FAssignedValues, evCache);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsCS: Boolean;
begin
  Result := evCache in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetAutoClose: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evAutoClose, oParentOpts) then
    Result := FAutoClose
  else
    Result := oParentOpts.FetchOptions.AutoClose;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetAutoClose(const AValue: Boolean);
begin
  if not (evAutoClose in FAssignedValues) or (FAutoClose <> AValue) then begin
    FAutoClose := AValue;
    Include(FAssignedValues, evAutoClose);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsACS: Boolean;
begin
  Result := evAutoClose in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetAutoFetchAll: TADAutoFetchAll;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evAutoFetchAll, oParentOpts) then
    Result := FAutoFetchAll
  else
    Result := oParentOpts.FetchOptions.AutoFetchAll;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetAutoFetchAll(const AValue: TADAutoFetchAll);
begin
  if not (evAutoFetchAll in FAssignedValues) or (FAutoFetchAll <> AValue) then begin
    FAutoFetchAll := AValue;
    Include(FAssignedValues, evAutoFetchAll);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsAFAS: Boolean;
begin
  Result := evAutoFetchAll in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetRecordcountMode: TADRecordCountMode;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evRecordcountMode, oParentOpts) then
    Result := FRecordcountMode
  else
    Result := oParentOpts.FetchOptions.RecordcountMode;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetRecordCountMode(const AValue: TADRecordCountMode);
begin
  if not (evRecordCountMode in FAssignedValues) or (FRecordCountMode <> AValue) then begin
    FRecordCountMode := AValue;
    Include(FAssignedValues, evRecordCountMode);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsRCMS: Boolean;
begin
  Result := evRecordCountMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetUnidirectional: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evUnidirectional, oParentOpts) then
    Result := FUnidirectional
  else
    Result := oParentOpts.FetchOptions.Unidirectional;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetUnidirectional(const AValue: Boolean);
begin
  if not (evUnidirectional in FAssignedValues) or (FUnidirectional <> AValue) then begin
    FUnidirectional := AValue;
    Include(FAssignedValues, evUnidirectional);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsUS: Boolean;
begin
  Result := evUnidirectional in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetCursor: TADCursorKind;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evCursorKind, oParentOpts) then
    Result := FCursorKind
  else
    Result := oParentOpts.FetchOptions.CursorKind;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetCursor(const AValue: TADCursorKind);
begin
  if not (evCursorKind in FAssignedValues) or (FCursorKind <> AValue) then begin
    FCursorKind := AValue;
    Include(FAssignedValues, evCursorKind);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsCKS: Boolean;
begin
  Result := evCursorKind in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetLiveWindowParanoic: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evLiveWindowParanoic, oParentOpts) then
    Result := FLiveWindowParanoic
  else
    Result := oParentOpts.FetchOptions.LiveWindowParanoic;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetLiveWindowParanoic(const AValue: Boolean);
begin
  if not (evLiveWindowParanoic in FAssignedValues) or (FLiveWindowParanoic <> AValue) then begin
    FLiveWindowParanoic := AValue;
    Include(FAssignedValues, evLiveWindowParanoic);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsLWP: Boolean;
begin
  Result := evLiveWindowParanoic in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetLiveWindowFastFirst: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evLiveWindowFastFirst, oParentOpts) then
    Result := FLiveWindowFastFirst
  else
    Result := oParentOpts.FetchOptions.LiveWindowFastFirst;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetLiveWindowFastFirst(const AValue: Boolean);
begin
  if not (evLiveWindowFastFirst in FAssignedValues) or (FLiveWindowFastFirst <> AValue) then begin
    FLiveWindowFastFirst := AValue;
    Include(FAssignedValues, evLiveWindowFastFirst);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsLWFF: Boolean;
begin
  Result := evLiveWindowFastFirst in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetDetailDelay: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evDetailDelay, oParentOpts) then
    Result := FDetailDelay
  else
    Result := oParentOpts.FetchOptions.DetailDelay;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetDetailDelay(const AValue: Integer);
begin
  if not (evDetailDelay in FAssignedValues) or (FDetailDelay <> AValue) then begin
    FDetailDelay := AValue;
    Include(FAssignedValues, evDetailDelay);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsDDS: Boolean;
begin
  Result := evDetailDelay in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetDetailOptimize: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evDetailOptimize, oParentOpts) then
    Result := FDetailOptimize
  else
    Result := oParentOpts.FetchOptions.DetailOptimize;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetDetailOptimize(const AValue: Boolean);
begin
  if not (evDetailOptimize in FAssignedValues) or (FDetailOptimize <> AValue) then begin
    FDetailOptimize := AValue;
    Include(FAssignedValues, evDetailOptimize);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsDOS: Boolean;
begin
  Result := evDetailOptimize in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.GetDetailCascade: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(evDetailCascade, oParentOpts) then
    Result := FDetailCascade
  else
    Result := oParentOpts.FetchOptions.DetailCascade;
end;

{-------------------------------------------------------------------------------}
procedure TADFetchOptions.SetDetailCascade(const AValue: Boolean);
begin
  if not (evDetailCascade in FAssignedValues) or (FDetailCascade <> AValue) then begin
    FDetailCascade := AValue;
    Include(FAssignedValues, evDetailCascade);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADFetchOptions.IsDCS: Boolean;
begin
  Result := evDetailCascade in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
{- TADUpdateOptions                                                            -}
{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.RestoreDefaults;
begin
  inherited RestoreDefaults;
  FAssignedValues := [];
  FEnableDelete := True;
  FEnableInsert := True;
  FEnableUpdate := True;
  FUpdateChangedFields := True;
  FUpdateMode := upWhereKeyOnly;
  FLockMode := lmNone;
  FLockPoint := lpDeferred;
  FLockWait := False;
  FRefreshMode := rmOnDemand;
  FrefreshDelete := True;
  FCountUpdatedRecords := True;
  FFetchGeneratorsPoint := gpDeferred;
  FGeneratorName := '';
  FCheckRequired := True;
  FCheckReadOnly := True;
  FCheckUpdatable := True;
  FUpdateNonBaseFields := False;
  Inc(FVersion);
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.Assign(ASource: TPersistent);
begin
  if (ASource = nil) or (ASource = Self) then
    Exit;
  if ASource is TADUpdateOptions then begin
    if uvEDelete in TADUpdateOptions(ASource).FAssignedValues then
      EnableDelete := TADUpdateOptions(ASource).EnableDelete;
    if uvEInsert in TADUpdateOptions(ASource).FAssignedValues then
      EnableInsert := TADUpdateOptions(ASource).EnableInsert;
    if uvEUpdate in TADUpdateOptions(ASource).FAssignedValues then
      EnableUpdate := TADUpdateOptions(ASource).EnableUpdate;
    if uvUpdateChngFields in TADUpdateOptions(ASource).FAssignedValues then
      UpdateChangedFields := TADUpdateOptions(ASource).UpdateChangedFields;
    if uvUpdateMode in TADUpdateOptions(ASource).FAssignedValues then
      UpdateMode := TADUpdateOptions(ASource).UpdateMode;
    if uvLockMode in TADUpdateOptions(ASource).FAssignedValues then
      LockMode := TADUpdateOptions(ASource).LockMode;
    if uvLockPoint in TADUpdateOptions(ASource).FAssignedValues then
      LockPoint := TADUpdateOptions(ASource).LockPoint;
    if uvLockWait in TADUpdateOptions(ASource).FAssignedValues then
      LockWait := TADUpdateOptions(ASource).LockWait;
    if uvRefreshMode in TADUpdateOptions(ASource).FAssignedValues then
      RefreshMode := TADUpdateOptions(ASource).RefreshMode;
    if uvRefreshDelete in TADUpdateOptions(ASource).FAssignedValues then
      RefreshDelete := TADUpdateOptions(ASource).RefreshDelete;
    if uvCountUpdatedRecords in TADUpdateOptions(ASource).FAssignedValues then
      CountUpdatedRecords := TADUpdateOptions(ASource).CountUpdatedRecords;
    if uvFetchGeneratorsPoint in TADUpdateOptions(ASource).FAssignedValues then
      FetchGeneratorsPoint := TADUpdateOptions(ASource).FetchGeneratorsPoint;
    if uvGeneratorName in TADUpdateOptions(ASource).FAssignedValues then
      GeneratorName := TADUpdateOptions(ASource).GeneratorName;
    if uvCheckRequired in TADUpdateOptions(ASource).FAssignedValues then
      CheckRequired := TADUpdateOptions(ASource).CheckRequired;
    if uvCheckReadOnly in TADUpdateOptions(ASource).FAssignedValues then
      CheckReadOnly := TADUpdateOptions(ASource).CheckReadOnly;
    if uvCheckUpdatable in TADUpdateOptions(ASource).FAssignedValues then
      CheckUpdatable := TADUpdateOptions(ASource).CheckUpdatable;
    if uvUpdateNonBaseFields in TADUpdateOptions(ASource).FAssignedValues then
      UpdateNonBaseFields := TADUpdateOptions(ASource).UpdateNonBaseFields;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.CheckRequest(ARequest: TADUpdateRequest;
  AOptions: TADUpdateRowOptions; ACachedUpdates: Boolean): Boolean;
begin
  Result := False;
  if ACachedUpdates and (uoImmediateUpd in AOptions) and
     ((ARequest <> arLock) or (uoDeferredLock in AOptions)) then
    Exit;
  case ARequest of
  arLock:
    case LockPoint of
    lpImmediate:
      if (uoDeferredLock in AOptions) and
         not (uoOneMomLock in AOptions) then
        Exit;
    lpDeferred:
      if not (uoDeferredLock in AOptions) or
         (uoOneMomLock in AOptions) then
        Exit;
    end;
  arFetchGenerators:
    case FetchGeneratorsPoint of
    gpNone:
      Exit;
    gpImmediate:
      if (uoDeferredGenGet in AOptions) then
        Exit;
    gpDeferred:
      if not (uoDeferredGenGet in AOptions) then
        Exit;
    end;
  end;
  Result := True;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsValueOwned(AValue: TADUpdateOptionValue;
  out AParentOpts: IADStanOptions): Boolean;
begin
  Result := not Assigned(Container.FParentCallback) or (AValue in FAssignedValues);
  if not Result then begin
    Container.FParentCallback(AParentOpts);
    Result := (AParentOpts = nil);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetEnableDelete: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvEDelete, oParentOpts) then
    Result := FEnableDelete
  else
    Result := oParentOpts.UpdateOptions.EnableDelete;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetEnableDelete(AValue: Boolean);
begin
  if not (uvEDelete in FAssignedValues) or (FEnableDelete <> AValue) then begin
    FEnableDelete := AValue;
    Include(FAssignedValues, uvEDelete);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsEDS: Boolean;
begin
  Result := uvEDelete in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetEnableInsert: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvEInsert, oParentOpts) then
    Result := FEnableInsert
  else
    Result := oParentOpts.UpdateOptions.EnableInsert;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetEnableInsert(AValue: Boolean);
begin
  if not (uvEInsert in FAssignedValues) or (FEnableInsert <> AValue) then begin
    FEnableInsert := AValue;
    Include(FAssignedValues, uvEInsert);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsEIS: Boolean;
begin
  Result := uvEInsert in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetEnableUpdate: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvEUpdate, oParentOpts) then
    Result := FEnableUpdate
  else
    Result := oParentOpts.UpdateOptions.EnableUpdate;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetEnableUpdate(AValue: Boolean);
begin
  if not (uvEUpdate in FAssignedValues) or (FEnableUpdate <> AValue) then begin
    FEnableUpdate := AValue;
    Include(FAssignedValues, uvEUpdate);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsEUS: Boolean;
begin
  Result := uvEUpdate in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetReadOnly: Boolean;
begin
  Result := not EnableDelete and not EnableInsert and not EnableUpdate;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetReadOnly(const AValue: Boolean);
begin
  EnableDelete := not AValue;
  EnableInsert := not AValue;
  EnableUpdate := not AValue;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetUpdateChangedFields: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvUpdateChngFields, oParentOpts) then
    Result := FUpdateChangedFields
  else
    Result := oParentOpts.UpdateOptions.UpdateChangedFields;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetUpdateChangedFields(const AValue: Boolean);
begin
  if not (uvUpdateChngFields in FAssignedValues) or (FUpdateChangedFields <> AValue) then begin
    FUpdateChangedFields := AValue;
    Include(FAssignedValues, uvUpdateChngFields);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsUCFS: Boolean;
begin
  Result := uvUpdateChngFields in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetUpdateMode: TUpdateMode;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvUpdateMode, oParentOpts) then
    Result := FUpdateMode
  else
    Result := oParentOpts.UpdateOptions.UpdateMode;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetUpdateMode(const AValue: TUpdateMode);
begin
  if not (uvUpdateMode in FAssignedValues) or (FUpdateMode <> AValue) then begin
    FUpdateMode := AValue;
    Include(FAssignedValues, uvUpdateMode);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsUMS: Boolean;
begin
  Result := uvUpdateMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetLockMode: TADLockMode;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvLockMode, oParentOpts) then
    Result := FLockMode
  else
    Result := oParentOpts.UpdateOptions.LockMode;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetLockMode(const AValue: TADLockMode);
begin
  if not (uvLockMode in FAssignedValues) or (FLockMode <> AValue) then begin
    FLockMode := AValue;
    Include(FAssignedValues, uvLockMode);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsLMS: Boolean;
begin
  Result := uvLockMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetLockPoint: TADLockPoint;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvLockPoint, oParentOpts) then
    Result := FLockPoint
  else
    Result := oParentOpts.UpdateOptions.LockPoint;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetLockPoint(const AValue: TADLockPoint);
begin
  if not (uvLockPoint in FAssignedValues) or (FLockPoint <> AValue) then begin
    FLockPoint := AValue;
    Include(FAssignedValues, uvLockPoint);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsLPS: Boolean;
begin
  Result := uvLockPoint in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetLockWait: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvLockWait, oParentOpts) then
    Result := FLockWait
  else
    Result := oParentOpts.UpdateOptions.LockWait;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetLockWait(const AValue: Boolean);
begin
  if not (uvLockWait in FAssignedValues) or (FLockWait <> AValue) then begin
    FLockWait := AValue;
    Include(FAssignedValues, uvLockWait);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsLWS: Boolean;
begin
  Result := uvLockWait in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetRefreshMode: TADRefreshMode;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvRefreshMode, oParentOpts) then
    Result := FRefreshMode
  else
    Result := oParentOpts.UpdateOptions.RefreshMode;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetRefreshMode(const AValue: TADRefreshMode);
begin
  if not (uvRefreshMode in FAssignedValues) or (FRefreshMode <> AValue) then begin
    FRefreshMode := AValue;
    Include(FAssignedValues, uvRefreshMode);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsRMS: Boolean;
begin
  Result := uvRefreshMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetRefreshDelete: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvRefreshDelete, oParentOpts) then
    Result := FRefreshDelete
  else
    Result := oParentOpts.UpdateOptions.RefreshDelete;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetRefreshDelete(const AValue: Boolean);
begin
  if not (uvRefreshDelete in FAssignedValues) or (FRefreshDelete <> AValue) then begin
    FRefreshDelete := AValue;
    Include(FAssignedValues, uvRefreshDelete);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsRDS: Boolean;
begin
  Result := uvRefreshDelete in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetCountUpdatedRecords: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvCountUpdatedRecords, oParentOpts) then
    Result := FCountUpdatedRecords
  else
    Result := oParentOpts.UpdateOptions.CountUpdatedRecords;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetCountUpdatedRecords(const AValue: Boolean);
begin
  if not (uvCountUpdatedRecords in FAssignedValues) or (FCountUpdatedRecords <> AValue) then begin
    FCountUpdatedRecords := AValue;
    Include(FAssignedValues, uvCountUpdatedRecords);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsCURS: Boolean;
begin
  Result := uvCountUpdatedRecords in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetFastUpdates: Boolean;
begin
  Result := not UpdateChangedFields and (UpdateMode = upWhereKeyOnly) and
    (LockMode = lmNone) and (RefreshMode = rmManual) and not CheckRequired and
    not CheckReadOnly and not CheckUpdatable;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetFastUpdates(const AValue: Boolean);
begin
  if AValue then begin
    UpdateChangedFields := False;
    UpdateMode := upWhereKeyOnly;
    LockMode := lmNone;
    RefreshMode := rmManual;
    CheckRequired := False;
    CheckReadOnly := False;
    CheckUpdatable := False;
  end
  else begin
    FUpdateChangedFields := True;
    FUpdateMode := upWhereKeyOnly;
    FLockMode := lmNone;
    FRefreshMode := rmOnDemand;
    FCheckRequired := True;
    FCheckReadOnly := True;
    FCheckUpdatable := True;
    FAssignedValues := FAssignedValues - [uvUpdateChngFields, uvUpdateMode,
      uvLockMode, uvRefreshMode, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable];
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetRequestLive: Boolean;
begin
  Result := (fiMeta in Container.FFetchOptions.Items) and not ReadOnly;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetRequestLive(const AValue: Boolean);
begin
  if RequestLive <> AValue then
    if AValue then begin
      Container.FFetchOptions.Items := Container.FFetchOptions.Items + [fiMeta];
      ReadOnly := False;
    end
    else begin
      Container.FFetchOptions.Items := Container.FFetchOptions.Items - [fiMeta];
      ReadOnly := True;
    end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetFetchGeneratorsPoint: TADFetchGeneratorsPoint;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvFetchGeneratorsPoint, oParentOpts) then
    Result := FFetchGeneratorsPoint
  else
    Result := oParentOpts.UpdateOptions.FetchGeneratorsPoint;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetFetchGeneratorsPoint(const AValue: TADFetchGeneratorsPoint);
begin
  if not (uvFetchGeneratorsPoint in FAssignedValues) or (FFetchGeneratorsPoint <> AValue) then begin
    FFetchGeneratorsPoint := AValue;
    Include(FAssignedValues, uvFetchGeneratorsPoint);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsGGPS: Boolean;
begin
  Result := uvFetchGeneratorsPoint in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetGeneratorName: String;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvGeneratorName, oParentOpts) then
    Result := FGeneratorName
  else
    Result := oParentOpts.UpdateOptions.GeneratorName;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetGeneratorName(const AValue: String);
begin
  if not (uvGeneratorName in FAssignedValues) or (FGeneratorName <> AValue) then begin
    FGeneratorName := AValue;
    Include(FAssignedValues, uvGeneratorName);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsGNS: Boolean;
begin
  Result := uvGeneratorName in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetCheckRequired: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvCheckRequired, oParentOpts) then
    Result := FCheckRequired
  else
    Result := oParentOpts.UpdateOptions.CheckRequired;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetCheckRequired(const AValue: Boolean);
begin
  if not (uvCheckRequired in FAssignedValues) or (FCheckRequired <> AValue) then begin
    FCheckRequired := AValue;
    Include(FAssignedValues, uvCheckRequired);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsCRS: Boolean;
begin
  Result := uvCheckRequired in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetCheckReadOnly: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvCheckReadOnly, oParentOpts) then
    Result := FCheckReadOnly
  else
    Result := oParentOpts.UpdateOptions.CheckReadOnly;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetCheckReadOnly(const AValue: Boolean);
begin
  if not (uvCheckReadOnly in FAssignedValues) or (FCheckReadOnly <> AValue) then begin
    FCheckReadOnly := AValue;
    Include(FAssignedValues, uvCheckReadOnly);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsCROS: Boolean;
begin
  Result := uvCheckReadOnly in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetCheckUpdatable: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvCheckUpdatable, oParentOpts) then
    Result := FCheckUpdatable
  else
    Result := oParentOpts.UpdateOptions.CheckUpdatable;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetCheckUpdatable(const AValue: Boolean);
begin
  if not (uvCheckUpdatable in FAssignedValues) or (FCheckUpdatable <> AValue) then begin
    FCheckUpdatable := AValue;
    Include(FAssignedValues, uvCheckUpdatable);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsCUS: Boolean;
begin
  Result := uvCheckUpdatable in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.GetUpdateNonBaseFields: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(uvUpdateNonBaseFields, oParentOpts) then
    Result := FUpdateNonBaseFields
  else
    Result := oParentOpts.UpdateOptions.UpdateNonBaseFields;
end;

{-------------------------------------------------------------------------------}
procedure TADUpdateOptions.SetUpdateNonBaseFields(const AValue: Boolean);
begin
  if not (uvUpdateNonBaseFields in FAssignedValues) or (FUpdateNonBaseFields <> AValue) then begin
    FUpdateNonBaseFields := AValue;
    Include(FAssignedValues, uvUpdateNonBaseFields);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADUpdateOptions.IsUNFS: Boolean;
begin
  Result := uvUpdateNonBaseFields in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
{ TADBottomUpdateOptions                                                        }
{-------------------------------------------------------------------------------}
procedure TADBottomUpdateOptions.Assign(ASource: TPersistent);
begin
  inherited Assign(ASource);
  if ASource is TADBottomUpdateOptions then begin
    UpdateTableName := TADBottomUpdateOptions(ASource).UpdateTableName;
    KeyFields := TADBottomUpdateOptions(ASource).KeyFields;
    AutoIncFields := TADBottomUpdateOptions(ASource).AutoIncFields;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBottomUpdateOptions.RestoreDefaults;
begin
  inherited RestoreDefaults;
  FUpdateTableName := '';
  FKeyFields := '';
  FAutoIncFields := '';
end;

{-------------------------------------------------------------------------------}
procedure TADBottomUpdateOptions.SetAutoIncFields(const AValue: String);
begin
  if FAutoIncFields <> AValue then begin
    FAutoIncFields := AValue;
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBottomUpdateOptions.SetKeyFields(const AValue: String);
begin
  if FKeyFields <> AValue then begin
    FKeyFields := AValue;
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADBottomUpdateOptions.SetUpdateTableName(const AValue: String);
begin
  if FUpdateTableName <> AValue then begin
    FUpdateTableName := AValue;
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
{ TADResourceOptions                                                            }
{-------------------------------------------------------------------------------}
procedure TADResourceOptions.RestoreDefaults;
begin
  inherited RestoreDefaults;
  FAssignedValues := [];
  FParamCreate := True;
  FMacroCreate := True;
  FParamExpand := True;
  FMacroExpand := True;
  FEscapeExpand := True;
  FCmdExecMode := amBlocking;
  FCmdExecTimeout := $FFFFFFFF;
  FDirectExecute := False;
  FDefaultParamType := ptInput;
  FPersistent := False;
  FBackup := False;
  FStoreVersion := -1;
  FStoreItems := [siData, siDelta, siMeta];
  FArrayDMLSize := $7FFFFFFF;
  FSilentMode := False;
  FUnifyParams := False;
  Inc(FVersion);
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.Assign(ASource: TPersistent);
begin
  if (ASource = nil) or (ASource = Self) then
    Exit;
  if ASource is TADResourceOptions then begin
    if rvParamCreate in TADResourceOptions(ASource).FAssignedValues then
      ParamCreate := TADResourceOptions(ASource).ParamCreate;
    if rvMacroCreate in TADResourceOptions(ASource).FAssignedValues then
      MacroCreate := TADResourceOptions(ASource).MacroCreate;
    if rvParamExpand in TADResourceOptions(ASource).FAssignedValues then
      ParamExpand := TADResourceOptions(ASource).ParamExpand;
    if rvMacroExpand in TADResourceOptions(ASource).FAssignedValues then
      MacroExpand := TADResourceOptions(ASource).MacroExpand;
    if rvEscapeExpand in TADResourceOptions(ASource).FAssignedValues then
      EscapeExpand := TADResourceOptions(ASource).EscapeExpand;
    if rvCmdExecMode in TADResourceOptions(ASource).FAssignedValues then
      CmdExecMode := TADResourceOptions(ASource).CmdExecMode;
    if rvCmdExecTimeout in TADResourceOptions(ASource).FAssignedValues then
      CmdExecTimeout := TADResourceOptions(ASource).CmdExecTimeout;
    if rvDirectExecute in TADResourceOptions(ASource).FAssignedValues then
      DirectExecute := TADResourceOptions(ASource).DirectExecute;
    if rvDefaultParamType in TADResourceOptions(ASource).FAssignedValues then
      DefaultParamType := TADResourceOptions(ASource).DefaultParamType;
    if rvPersistent in TADResourceOptions(ASource).FAssignedValues then
      Persistent := TADResourceOptions(ASource).Persistent;
    if rvBackup in TADResourceOptions(ASource).FAssignedValues then
      Backup := TADResourceOptions(ASource).Backup;
    if rvStoreVersion in TADResourceOptions(ASource).FAssignedValues then
      StoreVersion := TADResourceOptions(ASource).StoreVersion;
    if rvStoreItems in TADResourceOptions(ASource).FAssignedValues then
      StoreItems := TADResourceOptions(ASource).StoreItems;
    if rvArrayDMLSize in TADResourceOptions(ASource).FAssignedValues then
      ArrayDMLSize := TADResourceOptions(ASource).ArrayDMLSize;
    if rvSilentMode in TADResourceOptions(ASource).FAssignedValues then
      SilentMode := TADResourceOptions(ASource).SilentMode;
    if rvUnifyParams in TADResourceOptions(ASource).FAssignedValues then
      UnifyParams := TADResourceOptions(ASource).UnifyParams;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsValueOwned(AValue: TADResourceOptionValue;
  out AParentOpts: IADStanOptions): Boolean;
begin
  Result := not Assigned(Container.FParentCallback) or (AValue in FAssignedValues);
  if not Result then begin
    Container.FParentCallback(AParentOpts);
    Result := (AParentOpts = nil);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetMacroCreate: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvMacroCreate, oParentOpts) then
    Result := FMacroCreate
  else
    Result := oParentOpts.ResourceOptions.MacroCreate;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetMacroCreate(const AValue: Boolean);
begin
  if not (rvMacroCreate in FAssignedValues) or (FMacroCreate <> AValue) then begin
    FMacroCreate := AValue;
    Include(FAssignedValues, rvMacroCreate);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsMCS: Boolean;
begin
  Result := rvMacroCreate in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetParamCreate: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvParamCreate, oParentOpts) then
    Result := FParamCreate
  else
    Result := oParentOpts.ResourceOptions.ParamCreate;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetParamCreate(const AValue: Boolean);
begin
  if not (rvParamCreate in FAssignedValues) or (FParamCreate <> AValue) then begin
    FParamCreate := AValue;
    Include(FAssignedValues, rvParamCreate);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsPCS: Boolean;
begin
  Result := rvParamCreate in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetParamExpand: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvParamExpand, oParentOpts) then
    Result := FParamExpand
  else
    Result := oParentOpts.ResourceOptions.ParamExpand;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetParamExpand(const AValue: Boolean);
begin
  if not (rvParamExpand in FAssignedValues) or (FParamExpand <> AValue) then begin
    FParamExpand := AValue;
    Include(FAssignedValues, rvParamExpand);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsPES: Boolean;
begin
  Result := rvParamExpand in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetMacroExpand: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvMacroExpand, oParentOpts) then
    Result := FMacroExpand
  else
    Result := oParentOpts.ResourceOptions.MacroExpand;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetMacroExpand(const AValue: Boolean);
begin
  if not (rvMacroExpand in FAssignedValues) or (FMacroExpand <> AValue) then begin
    FMacroExpand := AValue;
    Include(FAssignedValues, rvMacroExpand);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsMES: Boolean;
begin
  Result := rvMacroExpand in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetEscapeExpand: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvEscapeExpand, oParentOpts) then
    Result := FEscapeExpand
  else
    Result := oParentOpts.ResourceOptions.EscapeExpand;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetEscapeExpand(const AValue: Boolean);
begin
  if not (rvEscapeExpand in FAssignedValues) or (FEscapeExpand <> AValue) then begin
    FEscapeExpand := AValue;
    Include(FAssignedValues, rvEscapeExpand);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetPreprocessCmdText: Boolean;
begin
  Result := ParamCreate or MacroCreate or ParamExpand or MacroExpand or EscapeExpand;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetPreprocessCmdText(const AValue: Boolean);
begin
  ParamCreate := AValue;
  MacroCreate := AValue;
  ParamExpand := AValue;
  MacroExpand := AValue;
  EscapeExpand := AValue;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsEPS: Boolean;
begin
  Result := rvEscapeExpand in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetCmdExecMode: TADStanAsyncMode;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvCmdExecMode, oParentOpts) then
    Result := FCmdExecMode
  else
    Result := oParentOpts.ResourceOptions.CmdExecMode;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetCmdExecMode(const AValue: TADStanAsyncMode);
begin
  if not (rvCmdExecMode in FAssignedValues) or (FCmdExecMode <> AValue) then begin
    FCmdExecMode := AValue;
    Include(FAssignedValues, rvCmdExecMode);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsCEMS: Boolean;
begin
  Result := rvCmdExecMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetCmdExecTimeout: LongWord;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvCmdExecTimeout, oParentOpts) then
    Result := FCmdExecTimeout
  else
    Result := oParentOpts.ResourceOptions.CmdExecTimeout;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetCmdExecTimeout(const AValue: LongWord);
begin
  if not (rvCmdExecTimeout in FAssignedValues) or (FCmdExecTimeout <> AValue) then begin
    FCmdExecTimeout := AValue;
    Include(FAssignedValues, rvCmdExecTimeout);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsCETS: Boolean;
begin
  Result := rvCmdExecTimeout in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetDirectExecute: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvDirectExecute, oParentOpts) then
    Result := FDirectExecute
  else
    Result := oParentOpts.ResourceOptions.DirectExecute;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetDirectExecute(const AValue: Boolean);
begin
  if not (rvDirectExecute in FAssignedValues) or (FDirectExecute <> AValue) then begin
    FDirectExecute := AValue;
    Include(FAssignedValues, rvDirectExecute);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsDES: Boolean;
begin
  Result := rvDirectExecute in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetDefaultParamType: TParamType;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvDefaultParamType, oParentOpts) then
    Result := FDefaultParamType
  else
    Result := oParentOpts.ResourceOptions.DefaultParamType;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetDefaultParamType(const AValue: TParamType);
begin
  if not (rvDefaultParamType in FAssignedValues) or (FDefaultParamType <> AValue) then begin
    FDefaultParamType := AValue;
    Include(FAssignedValues, rvDefaultParamType);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsDPTS: Boolean;
begin
  Result := rvDefaultParamType in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetBackup: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvBackup, oParentOpts) then
    Result := FBackup
  else
    Result := oParentOpts.ResourceOptions.Backup;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetBackup(const AValue: Boolean);
begin
  if not (rvBackup in FAssignedValues) or (FBackup <> AValue) then begin
    FBackup := AValue;
    Include(FAssignedValues, rvBackup);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsBS: Boolean;
begin
  Result := rvBackup in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetPersistent: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvPersistent, oParentOpts) then
    Result := FPersistent
  else
    Result := oParentOpts.ResourceOptions.Persistent;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetPersistent(const AValue: Boolean);
begin
  if not (rvPersistent in FAssignedValues) or (FPersistent <> AValue) then begin
    FPersistent := AValue;
    Include(FAssignedValues, rvPersistent);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsPS: Boolean;
begin
  Result := rvPersistent in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetBackupExt: String;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvBackupExt, oParentOpts) then
    if Self is TADTopResourceOptions then
      Result := TADTopResourceOptions(Self).FBackupExt
    else
      Result := '.BAK'
  else
    Result := oParentOpts.ResourceOptions.BackupExt;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetBackupFolder: String;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvBackupFolder, oParentOpts) then
    if Self is TADTopResourceOptions then
      Result := TADTopResourceOptions(Self).FBackupFolder
    else
      Result := ''
  else
    Result := oParentOpts.ResourceOptions.BackupFolder;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetDefaultStoreExt: String;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvDefaultStoreExt, oParentOpts) then
    if Self is TADTopResourceOptions then
      Result := TADTopResourceOptions(Self).FDefaultStoreExt
    else
      Result := ''
  else
    Result := oParentOpts.ResourceOptions.DefaultStoreExt;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetDefaultStoreFolder: String;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvDefaultStoreFolder, oParentOpts) then
    if Self is TADTopResourceOptions then
      Result := TADTopResourceOptions(Self).FDefaultStoreFolder
    else
      Result := ''
  else
    Result := oParentOpts.ResourceOptions.DefaultStoreFolder;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetDefaultStoreFormat: TADStorageFormat;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvDefaultStoreFormat, oParentOpts) then
    if Self is TADTopResourceOptions then
      Result := TADTopResourceOptions(Self).FDefaultStoreFormat
    else
      Result := sfAuto
  else
    Result := oParentOpts.ResourceOptions.DefaultStoreFormat;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetStoreVersion: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvStoreVersion, oParentOpts) then
    Result := FStoreVersion
  else
    Result := oParentOpts.ResourceOptions.StoreVersion;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetStoreVersion(const AValue: Integer);
begin
  if not (rvStoreVersion in FAssignedValues) or (FStoreVersion <> AValue) then begin
    FStoreVersion := AValue;
    Include(FAssignedValues, rvStoreVersion);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsSTV: Boolean;
begin
  Result := rvStoreVersion in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetStoreItems: TADStoreItems;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvStoreItems, oParentOpts) then
    Result := FStoreItems
  else
    Result := oParentOpts.ResourceOptions.StoreItems;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetStoreItems(const AValue: TADStoreItems);
begin
  if not (rvStoreItems in FAssignedValues) or (FStoreItems <> AValue) then begin
    FStoreItems := AValue;
    Include(FAssignedValues, rvStoreItems);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsSIS: Boolean;
begin
  Result := rvStoreItems in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetArrayDMLSize: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvArrayDMLSize, oParentOpts) then
    Result := FArrayDMLSize
  else
    Result := oParentOpts.ResourceOptions.ArrayDMLSize;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetArrayDMLSize(const AValue: Integer);
begin
  if not (rvArrayDMLSize in FAssignedValues) or (FArrayDMLSize <> AValue) then begin
    FArrayDMLSize := AValue;
    Include(FAssignedValues, rvArrayDMLSize);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsADSS: Boolean;
begin
  Result := rvArrayDMLSize in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetSilentMode: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvSilentMode, oParentOpts) then
    Result := FSilentMode
  else
    Result := oParentOpts.ResourceOptions.SilentMode;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetSilentMode(const AValue: Boolean);
begin
  if not (rvSilentMode in FAssignedValues) or (FSilentMode <> AValue) then begin
    FSilentMode := AValue;
    Include(FAssignedValues, rvSilentMode);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsSMS: Boolean;
begin
  Result := rvSilentMode in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetActualSilentMode: Boolean;
begin
  Result := SilentMode or ADGUIxSilent;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.GetUnifyParams: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvUnifyParams, oParentOpts) then
    Result := FUnifyParams
  else
    Result := oParentOpts.ResourceOptions.UnifyParams;
end;

{-------------------------------------------------------------------------------}
procedure TADResourceOptions.SetUnifyParams(const AValue: Boolean);
begin
  if not (rvUnifyParams in FAssignedValues) or (FUnifyParams <> AValue) then begin
    FUnifyParams := AValue;
    Include(FAssignedValues, rvUnifyParams);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADResourceOptions.IsUPS: Boolean;
begin
  Result := rvUnifyParams in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
{ TADTopResourceOptions                                                         }
{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.RestoreDefaults;
begin
  inherited RestoreDefaults;
  FMaxCursors := -1;
  FServerOutput := False;
  FServerOutputSize := 20000;
  FDefaultStoreFolder := '';
  FBackupFolder := '';
  FDefaultStoreExt := '';
  FDefaultStoreFormat := sfAuto;
  FBackupExt := '.BAK';
  FAutoConnect := True;
  FAutoReconnect := False;
  FKeepConnection := True;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.Assign(ASource: TPersistent);
begin
  if (ASource = nil) or (ASource = Self) then
    Exit;
  inherited Assign(ASource);
  if ASource is TADTopResourceOptions then begin
    if rvMaxCursors in TADTopResourceOptions(ASource).FAssignedValues then
      MaxCursors := TADTopResourceOptions(ASource).MaxCursors;
    if rvServerOutput in TADTopResourceOptions(ASource).FAssignedValues then
      ServerOutput := TADTopResourceOptions(ASource).ServerOutput;
    if rvServerOutputSize in TADTopResourceOptions(ASource).FAssignedValues then
      ServerOutputSize := TADTopResourceOptions(ASource).ServerOutputSize;
    if rvDefaultStoreFolder in TADTopResourceOptions(ASource).FAssignedValues then
      DefaultStoreFolder := TADTopResourceOptions(ASource).DefaultStoreFolder;
    if rvBackupFolder in TADTopResourceOptions(ASource).FAssignedValues then
      BackupFolder := TADTopResourceOptions(ASource).BackupFolder;
    if rvDefaultStoreExt in TADTopResourceOptions(ASource).FAssignedValues then
      DefaultStoreExt := TADTopResourceOptions(ASource).DefaultStoreExt;
    if rvDefaultStoreFormat in TADTopResourceOptions(ASource).FAssignedValues then
      DefaultStoreFormat := TADTopResourceOptions(ASource).DefaultStoreFormat;
    if rvBackupExt in TADTopResourceOptions(ASource).FAssignedValues then
      BackupExt := TADTopResourceOptions(ASource).BackupExt;
    if rvAutoConnect in TADTopResourceOptions(ASource).FAssignedValues then
      AutoConnect := TADTopResourceOptions(ASource).AutoConnect;
    if rvAutoReconnect in TADTopResourceOptions(ASource).FAssignedValues then
      AutoReconnect := TADTopResourceOptions(ASource).AutoReconnect;
    if rvKeepConnection in TADTopResourceOptions(ASource).FAssignedValues then
      KeepConnection := TADTopResourceOptions(ASource).KeepConnection;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.GetMaxCursors: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvMaxCursors, oParentOpts) then
    Result := FMaxCursors
  else
    Result := (oParentOpts.ResourceOptions as TADTopResourceOptions).MaxCursors;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetMaxCursors(const AValue: Integer);
begin
  if not (rvMaxCursors in FAssignedValues) or (FMaxCursors <> AValue) then begin
    FMaxCursors := AValue;
    Include(FAssignedValues, rvMaxCursors);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsMCS: Boolean;
begin
  Result := rvMaxCursors in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.GetServerOutput: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvServerOutput, oParentOpts) then
    Result := FServerOutput
  else
    Result := (oParentOpts.ResourceOptions as TADTopResourceOptions).ServerOutput;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetServerOutput(const AValue: Boolean);
begin
  if not (rvServerOutput in FAssignedValues) or (FServerOutput <> AValue) then begin
    FServerOutput := AValue;
    Include(FAssignedValues, rvServerOutput);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsSOS: Boolean;
begin
  Result := rvServerOutput in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.GetServerOutputSize: Integer;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvServerOutputSize, oParentOpts) then
    Result := FServerOutputSize
  else
    Result := (oParentOpts.ResourceOptions as TADTopResourceOptions).ServerOutputSize;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetServerOutputSize(const AValue: Integer);
begin
  if not (rvServerOutputSize in FAssignedValues) or (FServerOutputSize <> AValue) then begin
    FServerOutputSize := AValue;
    Include(FAssignedValues, rvServerOutputSize);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsSOSS: Boolean;
begin
  Result := rvServerOutputSize in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetBackupExt(const AValue: String);
begin
  if not (rvBackupExt in FAssignedValues) or (FBackupExt <> AValue) then begin
    FBackupExt := AValue;
    Include(FAssignedValues, rvBackupExt);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsBES: Boolean;
begin
  Result := rvBackupExt in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetBackupFolder(const AValue: String);
begin
  if not (rvBackupFolder in FAssignedValues) or (FBackupFolder <> AValue) then begin
    FBackupFolder := AValue;
    Include(FAssignedValues, rvBackupFolder);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsBFS: Boolean;
begin
  Result := rvBackupFolder in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetDefaultStoreExt(const AValue: String);
begin
  if not (rvDefaultStoreExt in FAssignedValues) or (FDefaultStoreExt <> AValue) then begin
    FDefaultStoreExt := AValue;
    Include(FAssignedValues, rvDefaultStoreExt);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsDSES: Boolean;
begin
  Result := rvDefaultStoreExt in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetDefaultStoreFolder(const AValue: String);
begin
  if not (rvDefaultStoreFolder in FAssignedValues) or (FDefaultStoreFolder <> AValue) then begin
    FDefaultStoreFolder := AValue;
    Include(FAssignedValues, rvDefaultStoreFolder);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsDSFS: Boolean;
begin
  Result := rvDefaultStoreFolder in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetDefaultStoreFormat(
  const AValue: TADStorageFormat);
begin
  if not (rvDefaultStoreFormat in FAssignedValues) or (FDefaultStoreFormat <> AValue) then begin
    FDefaultStoreFormat := AValue;
    Include(FAssignedValues, rvDefaultStoreFormat);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsDSTS: Boolean;
begin
  Result := rvDefaultStoreFormat in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.GetAutoConnect: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvAutoConnect, oParentOpts) then
    Result := FAutoConnect
  else
    Result := (oParentOpts.ResourceOptions as TADTopResourceOptions).AutoConnect;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetAutoConnect(const AValue: Boolean);
begin
  if not (rvAutoConnect in FAssignedValues) or (FAutoConnect <> AValue) then begin
    FAutoConnect := AValue;
    Include(FAssignedValues, rvAutoConnect);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsACS: Boolean;
begin
  Result := rvAutoConnect in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.GetAutoReconnect: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvAutoReconnect, oParentOpts) then
    Result := FAutoReconnect
  else
    Result := (oParentOpts.ResourceOptions as TADTopResourceOptions).AutoReconnect;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetAutoReconnect(const AValue: Boolean);
begin
  if not (rvAutoReconnect in FAssignedValues) or (FAutoReconnect <> AValue) then begin
    FAutoReconnect := AValue;
    Include(FAssignedValues, rvAutoReconnect);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsARS: Boolean;
begin
  Result := rvAutoReconnect in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.GetKeepConnection: Boolean;
var
  oParentOpts: IADStanOptions;
begin
  if IsValueOwned(rvKeepConnection, oParentOpts) then
    Result := FKeepConnection
  else
    Result := (oParentOpts.ResourceOptions as TADTopResourceOptions).KeepConnection;
end;

{-------------------------------------------------------------------------------}
procedure TADTopResourceOptions.SetKeepConnection(const AValue: Boolean);
begin
  if not (rvKeepConnection in FAssignedValues) or (FKeepConnection <> AValue) then begin
    FKeepConnection := AValue;
    Include(FAssignedValues, rvKeepConnection);
    Inc(FVersion);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTopResourceOptions.IsKCS: Boolean;
begin
  Result := rvKeepConnection in FAssignedValues;
end;

{-------------------------------------------------------------------------------}
{ TADBottomResourceOptions                                                      }
{-------------------------------------------------------------------------------}
procedure TADBottomResourceOptions.Assign(ASource: TPersistent);
begin
  inherited Assign(ASource);
  if ASource is TADBottomResourceOptions then
    PersistentFileName := TADBottomResourceOptions(ASource).PersistentFileName;
end;

{-------------------------------------------------------------------------------}
procedure TADBottomResourceOptions.RestoreDefaults;
begin
  inherited RestoreDefaults;
  FPersistentFileName := '';
end;

{-------------------------------------------------------------------------------}
function TADBottomResourceOptions.ResolveFileName(const AFileName: String = ''): String;
begin
  Result := ADExpandStr(AFileName);
  if Result = '' then
    Result := ADExpandStr(PersistentFileName);
  if Result <> '' then begin
    if ExtractFileExt(Result) = '' then
      if DefaultStoreExt = '' then
        case DefaultStoreFormat of
        sfXML:    Result := ChangeFileExt(Result, '.XML');
        sfAuto,
        sfBinary: Result := ChangeFileExt(Result, '.ADB');
        end
      else
        Result := ChangeFileExt(Result, DefaultStoreExt);
    if ExtractFilePath(Result) = '' then
      Result := ADNormPath(ADExpandStr(DefaultStoreFolder)) + Result;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADTxOptions                                                                  }
{-------------------------------------------------------------------------------}
constructor TADTxOptions.Create;
begin
  inherited Create;
  FIsolation := xiReadCommitted;
  FParams := TADStringList.Create;
  TADStringList(FParams).OnChange := DoParamsChanged;
  FAutoStart := True;
  FAutoStop := True;
  FStopOptions := [xoIfAutoStarted, xoIfCmdsInactive];
  FDisconnectAction := xdCommit;
  FEnableNested := True;
  ClearChanged;
end;

{-------------------------------------------------------------------------------}
destructor TADTxOptions.Destroy;
begin
  ADFreeAndNil(FParams);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.Assign(ASource: TPersistent);
begin
  if (ASource = nil) or (ASource = Self) then
    Exit;
  if ASource is TADTxOptions then begin
    FStopOptions := TADTxOptions(ASource).FStopOptions;
    FIsolation := TADTxOptions(ASource).FIsolation;
    FReadOnly := TADTxOptions(ASource).FReadOnly;
    TADStringList(FParams).OnChange := nil;
    try
      FParams.Assign(TADTxOptions(ASource).FParams);
    finally
      TADStringList(FParams).OnChange := DoParamsChanged;
    end;
    FAutoStart := TADTxOptions(ASource).FAutoStart;
    FAutoStop := TADTxOptions(ASource).FAutoStop;
    FDisconnectAction := TADTxOptions(ASource).FDisconnectAction;
    FChanged := TADTxOptions(ASource).FChanged;
    FEnableNested := TADTxOptions(ASource).FEnableNested;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.ClearChanged;
begin
  FChanged := [];
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.ResetChanged;
begin
  FChanged := [];
  if Isolation <> xiReadCommitted then
    Include(FChanged, xoIsolation);
  if ReadOnly then
    Include(FChanged, xoReadOnly);
  if Params.Count > 0 then
    Include(FChanged, xoParams);
  if not AutoCommit then
    Include(FChanged, xoAutoCommit);
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.SetIsolation(const AValue: TADTxIsolation);
begin
  if FIsolation <> AValue then begin
    FIsolation := AValue;
    Include(FChanged, xoIsolation);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.SetReadOnly(const AValue: Boolean);
begin
  if FReadOnly <> AValue then begin
    FReadOnly := AValue;
    Include(FChanged, xoReadOnly);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.DoParamsChanged(ASender: TObject);
begin
  Include(FChanged, xoParams);
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.SetParams(const AValue: TStrings);
begin
  FParams.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.SetAutoStart(const AValue: Boolean);
begin
  if FAutoStart <> AValue then begin
    FAutoStart := AValue;
    Include(FChanged, xoAutoStart);
    Include(FChanged, xoAutoCommit);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.SetAutoStop(const AValue: Boolean);
begin
  if FAutoStop <> AValue then begin
    FAutoStop := AValue;
    Include(FChanged, xoAutoStop);
    Include(FChanged, xoAutoCommit);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.SetStopOptions(const AValue: TADTxStopOptions);
begin
  if FStopOptions <> AValue then begin
    FStopOptions := AValue;
    Include(FChanged, xoStopOptions);
    Include(FChanged, xoAutoCommit);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTxOptions.SetAutoCommit(const AValue: Boolean);
begin
  if AValue then begin
    AutoStart := True;
    AutoStop := True;
    StopOptions := StopOptions + [xoIfAutoStarted, xoIfCmdsInactive];
  end
  else
    AutoStop := False;
end;

{-------------------------------------------------------------------------------}
function TADTxOptions.GetAutoCommit: Boolean;
begin
  Result := AutoStart and AutoStop and (xoIfAutoStarted in StopOptions) and
    (xoIfCmdsInactive in StopOptions);
end;

{-------------------------------------------------------------------------------}
{ TADEventAlerterOptions                                                        }
{-------------------------------------------------------------------------------}
constructor TADEventAlerterOptions.Create;
begin
  inherited Create;
  FTimeout := -1;
  FSynchronize := True;
end;

{-------------------------------------------------------------------------------}
procedure TADEventAlerterOptions.Assign(ASource: TPersistent);
begin
  if ASource is TADEventAlerterOptions then begin
    Kind := TADEventAlerterOptions(ASource).Kind;
    Timeout := TADEventAlerterOptions(ASource).Timeout;
    Synchronize := TADEventAlerterOptions(ASource).Synchronize;
    AutoRegister := TADEventAlerterOptions(ASource).AutoRegister;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
initialization

  C_AD_MaxLenTimeStampStr := Length(DateTimeToStr(ADSQLTimeStamp2DateTime(RLongDate)));
  C_AD_MaxLenTimeIntStr := Length(ADSQLTimeInterval2Str(RLongInt));

end.
