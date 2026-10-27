{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{                  FireDAC TADDataMove                  }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

unit uADCompDataMove;

interface

uses
  SysUtils, Classes, DB,
  uADStanIntf, uADStanUtil,
  uADCompClient;

type
  TADTextField = class;
  TADTextFields = class;
  TADTextDataDef = class;
  TADMappingItem = class;
  TADMappings = class;
  TADDataMove = class;

  TADTextDataType = (atOther, atString, atFloat, atNumber, atBool, atLongInt,
    atDate, atTime, atDateTime, atBlob, atMemo);
  TADTextRecordFormat = (rfFixedLength, rfCommaDoubleQuote, rfFieldPerLine,
    rfTabDoubleQuote, rfCustom);
  TADTextAnalyze = set of (taDelimSep, taHeader, taFields);

  TADDataSourceKind = (skDataSet, skText);
  TADDataMoveMode = (dmAlwaysInsert, dmAppend, dmUpdate, dmAppendUpdate, dmDelete);
  TADLogFileAction = (laNone, laCreate, laAppend);
  TADDataMovePhase = (psPreparing, psStarting, psProgress, psFinishing, psUnpreparing);
  TADDataMoveProgressEvent = procedure (ASender: TObject; APhase: TADDataMovePhase) of object;
  TADDataMoveFindDestRecordEvent = procedure (ASender: TObject; var AFound: Boolean) of object;
  TADDataMoveOption = (poOptimiseDest, poOptimiseSrc, poClearDest, poClearDestNoUndo,
    poAbortOnExc, poSrcFromCurRec, poIdentityInsert);
  TADDataMoveOptions = set of TADDataMoveOption;

  // eaFail: write error to log, go to next record, if poAbortOnExc, then eaExitFailure
  // eaSkip: write error to log, go to next record
  // eaRetry: retry record
  // eaApplied: go to next record
  // eaDefault: ->> eaFail
  // eaExitSuccess: stop moving and exit
  // eaExitFailure: stop moving and reraise
  TADDataMoveErrorEvent = procedure (ASender: TObject; var AAction: TADErrorAction) of object;

  TADTextField = class(TCollectionItem)
  private
    FDataType: TADTextDataType;
    FFieldName: String;
    FFieldSize: Integer;
    FPrecision: Integer;
    procedure SetFieldName(const AValue: String);
  protected
    function GetDisplayName: String; override;
  public
    procedure Assign(ASource: TPersistent); override;
    procedure DefineAsField(AFld: TField);
    procedure DefineFieldDef(AFld: TFieldDef);
  published
    property DataType: TADTextDataType read FDataType write FDataType;
    property FieldName: String read FFieldName write SetFieldName;
    property FieldSize: Integer read FFieldSize write FFieldSize;
    property Precision: Integer read FPrecision write FPrecision;
  end;

  TADTextFields = class(TCollection)
  private
    FDef: TADTextDataDef;
    function GetItem(AIndex: Integer): TADTextField;
    procedure SetItem(AIndex: Integer; const AValue: TADTextField);
    procedure CheckFieldName(AField: TADTextField; const ANewName: String);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(ADef: TADTextDataDef);
    function Add: TADTextField;
    procedure AddAll;
    function FindField(const AName: String): TADTextField;
    function FieldByName(const AName: String): TADTextField;
    property Items[Index: Integer]: TADTextField read GetItem write SetItem; default;
  end;

  TADTextFormatSettingsValue = (
    fsCurrencyFormat, fsNegCurrFormat, fsThousandSeparator, fsDecimalSeparator,
    fsCurrencyDecimals, fsDateSeparator, fsTimeSeparator, fsCurrencyString,
    fsShortDateFormat, fsTimeAMString, fsTimePMString, fsShortTimeFormat,
    fsTwoDigitYearCenturyWindow);
  TADTextFormatSettingsValueSet = set of TADTextFormatSettingsValue;

{$IFNDEF AnyDAC_D7}
  {$IFNDEF AnyDAC_FPC}
  TFormatSettings = record
    CurrencyFormat: Byte;
    NegCurrFormat: Byte;
    ThousandSeparator: Char;
    DecimalSeparator: Char;
    CurrencyDecimals: Byte;
    DateSeparator: Char;
    TimeSeparator: Char;
    ListSeparator: Char;
    CurrencyString: string;
    ShortDateFormat: string;
    LongDateFormat: string;
    TimeAMString: string;
    TimePMString: string;
    ShortTimeFormat: string;
    LongTimeFormat: string;
    ShortMonthNames: array[1..12] of string;
    LongMonthNames: array[1..12] of string;
    ShortDayNames: array[1..7] of string;
    LongDayNames: array[1..7] of string;
    TwoDigitYearCenturyWindow: Word;
  end;
  {$ENDIF}
{$ENDIF}

  TADTextFormatSettings = class(TPersistent)
  private
    FFS: TFormatSettings;
    FDataDef: TADTextDataDef;
    FValues: TADTextFormatSettingsValueSet;
    procedure SetCurrencyDecimals(const AValue: Byte);
    procedure SetCurrencyFormat(const AValue: Byte);
    procedure SetCurrencyString(const AValue: string);
    procedure SetDateSeparator(const AValue: Char);
    procedure SetDecimalSeparator(const AValue: Char);
    procedure SetNegCurrFormat(const AValue: Byte);
    procedure SetShortDateFormat(const AValue: string);
    procedure SetShortTimeFormat(const AValue: string);
    procedure SetThousandSeparator(const AValue: Char);
    procedure SetTimeAMString(const AValue: string);
    procedure SetTimePMString(const AValue: string);
    procedure SetTimeSeparator(const AValue: Char);
    procedure SetTwoDigitYearCenturyWindow(const AValue: Word);
    function IsCDS: Boolean;
    function IsCFS: Boolean;
    function IsCSS: Boolean;
    function IsDSS: Boolean;
    function IsDTSS: Boolean;
    function IsNCFS: Boolean;
    function IsSDFS: Boolean;
    function IsSTFS: Boolean;
    function IsTAMSS: Boolean;
    function IsTDYCWS: Boolean;
    function IsTMSS: Boolean;
    function IsTPMSS: Boolean;
    function IsTSS: Boolean;
    function GetCurrencyDecimals: Byte;
    function GetCurrencyFormat: Byte;
    function GetCurrencyString: string;
    function GetDateSeparator: Char;
    function GetDecimalSeparator: Char;
    function GetNegCurrFormat: Byte;
    function GetShortDateFormat: string;
    function GetShortTimeFormat: string;
    function GetThousandSeparator: Char;
    function GetTimeAMString: string;
    function GetTimePMString: string;
    function GetTimeSeparator: Char;
    function GetTwoDigitYearCenturyWindow: Word;
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(ADef: TADTextDataDef);
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    property DataDef: TADTextDataDef read FDataDef;
  published
    property CurrencyFormat: Byte read GetCurrencyFormat write SetCurrencyFormat stored IsCFS;
    property NegCurrFormat: Byte read GetNegCurrFormat write SetNegCurrFormat stored IsNCFS;
    property ThousandSeparator: Char read GetThousandSeparator write SetThousandSeparator stored IsTSS;
    property DecimalSeparator: Char read GetDecimalSeparator write SetDecimalSeparator stored IsDSS;
    property CurrencyDecimals: Byte read GetCurrencyDecimals write SetCurrencyDecimals stored IsCDS;
    property DateSeparator: Char read GetDateSeparator write SetDateSeparator stored IsDTSS;
    property TimeSeparator: Char read GetTimeSeparator write SetTimeSeparator stored IsTMSS;
    property CurrencyString: string read GetCurrencyString write SetCurrencyString stored IsCSS;
    property ShortDateFormat: string read GetShortDateFormat write SetShortDateFormat stored IsSDFS;
    property TimeAMString: string read GetTimeAMString write SetTimeAMString stored IsTAMSS;
    property TimePMString: string read GetTimePMString write SetTimePMString stored IsTPMSS;
    property ShortTimeFormat: string read GetShortTimeFormat write SetShortTimeFormat stored IsSTFS;
    property TwoDigitYearCenturyWindow: Word read GetTwoDigitYearCenturyWindow
      write SetTwoDigitYearCenturyWindow stored IsTDYCWS;
  end;

  TADTextDataDef = class(TPersistent)
  private
    FDataMove: TADDataMove;
    FFields: TADTextFields;
    FDelimiter: Char;
    FRecordDelimiter: TADTextEndOfLine;
    FRecordFormat: TADTextRecordFormat;
    FSeparator: Char;
    FWithFieldNames: Boolean;
    FFormatSettings: TADTextFormatSettings;
    FStrsEmpty2Null: Boolean;
    FTrimLeft: Boolean;
    FTrimRight: Boolean;
    procedure SetFields(const AValue: TADTextFields);
    procedure SetDelimiter(AValue: Char);
    procedure SetRecordFormat(AValue: TADTextRecordFormat);
    procedure SetSeparator(AValue: Char);
    function IsADDS: Boolean;
    procedure SetWithFieldNames(const AValue: Boolean);
    procedure SetFormatSettings(const AValue: TADTextFormatSettings);
  protected
    function GetOwner: TPersistent; override;
  public
    constructor Create(ADataMove: TADDataMove);
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    property DataMove: TADDataMove read FDataMove;
  published
    property Fields: TADTextFields read FFields write SetFields;
    property Delimiter: Char read FDelimiter write SetDelimiter stored IsADDS;
    property Separator: Char read FSeparator write SetSeparator stored IsADDS;
    property EndOfLine: TADTextEndOfLine read FRecordDelimiter write FRecordDelimiter default elDefault;
    property RecordFormat: TADTextRecordFormat read FRecordFormat write SetRecordFormat default rfCommaDoubleQuote;
    property WithFieldNames: Boolean read FWithFieldNames write SetWithFieldNames default False;
    property TrimLeft: Boolean read FTrimLeft write FTrimLeft default True;
    property TrimRight: Boolean read FTrimRight write FTrimRight default True;
    property StrsEmpty2Null: Boolean read FStrsEmpty2Null write FStrsEmpty2Null default True;
    property FormatSettings: TADTextFormatSettings read FFormatSettings write SetFormatSettings;
  end;

  TADMappingItem = class(TCollectionItem)
  private
    FSourceExpression: String;
    FSourceFieldName: String;
    FSourceField: TField;
    FSourceTextField: TADTextField;
    FSourceEvaluator: IADStanExpressionEvaluator;
    FSourceValue: Variant;
    FDestinationFieldName: String;
    FDestField: TField;
    FDestTextField: TADTextField;
    FDestValue: Variant;
    FInKey: Boolean;
    FIsIdentity: Boolean;
    function GetAsText: String;
    procedure SetAsText(const AValue: String);
    function GetItemBaseValue: Variant;
    function GetItemValue: Variant;
  protected
    function GetDisplayName: String; override;
    procedure Prepare;
    procedure Unprepare;
  public
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure Move;
    property DestField: TField read FDestField;
    property DestTextField: TADTextField read FDestTextField;
    property DestValue: Variant read FDestValue write FDestValue;
    property SourceField: TField read FSourceField;
    property SourceTextField: TADTextField read FSourceTextField;
    property SourceEvaluator: IADStanExpressionEvaluator read FSourceEvaluator;
    property SourceValue: Variant read FSourceValue write FSourceValue;
    property ItemValue: Variant read GetItemValue;
    property InKey: Boolean read FInKey;
    property IsIdentity: Boolean read FIsIdentity;
    property AsText: String read GetAsText write SetAsText;
  published
    property SourceFieldName: String read FSourceFieldName write FSourceFieldName;
    property SourceExpression: String read FSourceExpression write FSourceExpression;
    property DestinationFieldName: String read FDestinationFieldName write FDestinationFieldName;
  end;

  TADMappings = class(TCollection)
  private
    FDataMove: TADDataMove;
    FMappingsAdded: Boolean;
    FTextFieldsAdded: Boolean;
    function GetItem(AIndex: Integer): TADMappingItem;
    procedure SetItem(AIndex: Integer; const AValue: TADMappingItem);
  protected
    function GetOwner: TPersistent; override;
    procedure Prepare;
    procedure Unprepare;
  public
    constructor Create(ADataMove: TADDataMove);
    procedure Assign(ASource: TPersistent); override;
    function Add: TADMappingItem; overload;
    procedure Add(const AMapItem: String); overload;
    procedure AddAll;
    procedure Move(AKeysOnly: Boolean);
    function IndexOfName(const AName: String): Integer;
    property Items[Index: Integer]: TADMappingItem read GetItem write SetItem; default;
    property DataMove: TADDataMove read FDataMove;
  end;

{$IFDEF AnyDAC_D16}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32
    {$IFDEF AnyDAC_D17} or pidiOSSimulator or pidiOSDevice {$ENDIF})]
{$ENDIF}
  TADDataMove = class(TADComponent)
  private
    FTextDataDef: TADTextDataDef;
    FTextFileName: String;
    FMappings: TADMappings;
    FLogFileAction: TADLogFileAction;
    FLogFileName: String;
    FSourceKind: TADDataSourceKind;
    FDestinationKind: TADDataSourceKind;
    FMode: TADDataMoveMode;
    FStatisticsInterval: LongInt;
    FCommitCount: LongInt;
    FDeleteCount: LongInt;
    FInsertCount: LongInt;
    FUpdateCount: LongInt;
    FReadCount: LongInt;
    FExceptionCount: LongInt;
    FSource: TDataSet;
    FDestination: TADAdaptedDataSet;
    FOnProgress: TADDataMoveProgressEvent;
    FOnFindDestRecord: TADDataMoveFindDestRecordEvent;
    FOptions: TADDataMoveOptions;
    FAborting: Boolean;
    FOnError: TADDataMoveErrorEvent;
    FTextFileEncoding: TADEncoding;
    FLogFileEncoding: TADEncoding;
    FTextAnalyze: TADTextAnalyze;
    FTextAnalyzeSample: Integer;
    FTextStream: TStream;
    FLogStream: TStream;
    function FindDestRecord: Boolean;
    procedure SetMappings(const AValue: TADMappings);
    function GetWriteCount: LongInt;
    function ExecuteTableToTable: LongInt;
    function ExecuteTableToText: LongInt;
    function ExecuteTextToTable: LongInt;
    procedure SetTextDataDef(const AValue: TADTextDataDef);
    procedure SetDestination(const AValue: TADAdaptedDataSet);
    procedure SetSource(const AValue: TDataSet);
    procedure SetTextFileName(const AValue: String);
    procedure DoStatistic(APhase: TADDataMovePhase);
    function InitLogFile: TADTextFile;
    procedure ProcessException(E: Exception; ALog: TADTextFile;
      out AAction: TADErrorAction);
    procedure DeleteExceptionFile(ALog: TADTextFile);
    procedure SetupDestination;
    procedure SetupSource;
    procedure SetDestinationKind(const AValue: TADDataSourceKind);
    procedure SetSourceKind(const AValue: TADDataSourceKind);
    procedure SetMode(const AValue: TADDataMoveMode);
    procedure CheckTextSetup;
    procedure GuessTextFormat(AText: TADTextFile; AAnalyze: TADTextAnalyze); overload;
    procedure SetTextStream(const AValue: TStream);
    procedure TextDataAssigned;
    function IsSrcMemTable: Boolean;
    function IsDestMemTable: Boolean;
    function TrimText(const AStr: String; AHeader: Boolean): String;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ReadCount: LongInt read FReadCount;
    property InsertCount: LongInt read FInsertCount;
    property UpdateCount: LongInt read FUpdateCount;
    property DeleteCount: LongInt read FDeleteCount;
    property WriteCount: LongInt read GetWriteCount;
    property ExceptionCount: LongInt read FExceptionCount;
    function Execute: LongInt;
    procedure AbortJob;
    procedure GuessTextFormat(AAnalyze: TADTextAnalyze = [taDelimSep, taHeader, taFields]); overload;
    procedure CreateDestinationDataSet;
    property TextStream: TStream read FTextStream write SetTextStream;
    property LogStream: TStream read FLogStream write FLogStream;
  published
    property TextDataDef: TADTextDataDef read FTextDataDef write SetTextDataDef;
    property TextFileName: String read FTextFileName write SetTextFileName;
    property TextFileEncoding: TADEncoding read FTextFileEncoding write FTextFileEncoding default ecANSI;
    property TextAnalyze: TADTextAnalyze read FTextAnalyze write FTextAnalyze default [];
    property TextAnalyzeSample: Integer read FTextAnalyzeSample write FTextAnalyzeSample default 10;
    property Mappings: TADMappings read FMappings write SetMappings;
    property Options: TADDataMoveOptions read FOptions write FOptions
      default [poOptimiseDest, poOptimiseSrc, poAbortOnExc, poIdentityInsert];
    property LogFileAction: TADLogFileAction read FLogFileAction write FLogFileAction default laNone;
    property LogFileName: String read FLogFileName write FLogFileName;
    property LogFileEncoding: TADEncoding read FLogFileEncoding write FLogFileEncoding default ecANSI;
    property CommitCount: LongInt read FCommitCount write FCommitCount default 100;
    property Mode: TADDataMoveMode read FMode write SetMode default dmAlwaysInsert;
    property StatisticsInterval: LongInt read FStatisticsInterval write FStatisticsInterval default 100;
    property SourceKind: TADDataSourceKind read FSourceKind write SetSourceKind default skDataSet;
    property DestinationKind: TADDataSourceKind read FDestinationKind write SetDestinationKind default skDataSet;
    property Source: TDataSet read FSource write SetSource;
    property Destination: TADAdaptedDataSet read FDestination write SetDestination;
    property OnProgress: TADDataMoveProgressEvent read FOnProgress write FOnProgress;
    property OnFindDestRecord: TADDataMoveFindDestRecordEvent read FOnFindDestRecord write FOnFindDestRecord;
    property OnError: TADDataMoveErrorEvent read FOnError write FOnError;
  end;

implementation

uses
{$IFDEF MSWINDOWS}
  Windows,
{$ENDIF}
{$IFDEF AnyDAC_D6Base}
  Variants,
{$ELSE}
  ActiveX, ComObj,
{$ENDIF}
  uADStanOption, uADStanError, uADStanConst, uADStanFactory, uADStanResStrs,
  uADGUIxIntf, uADCompDataSet;

type
  TADDataMoveAction = (paSkip, paInsert, paUpdate, paDelete, paAlwaysInsert);

{-------------------------------------------------------------------------------}
{ TADTextField                                                                  }
{-------------------------------------------------------------------------------}
procedure TADTextField.Assign(ASource: TPersistent);
begin
  if ASource is TADTextField then begin
    DataType := TADTextField(ASource).DataType;
    FieldName := TADTextField(ASource).FieldName;
    FieldSize := TADTextField(ASource).FieldSize;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADTextField.SetFieldName(const AValue: String);
begin
  if FFieldName <> AValue then begin
    TADTextFields(Collection).CheckFieldName(Self, AValue);
    FFieldName := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTextField.GetDisplayName: string;
begin
  Result := FieldName;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

{-------------------------------------------------------------------------------}
procedure TADTextField.DefineAsField(AFld: TField);
begin
  case AFld.DataType of
  ftBoolean:
    begin
      DataType := atBool;
      FieldSize := 1;
    end;
{$IFDEF AnyDAC_WIDEMEMO}
  ftFixedWideChar,
{$ENDIF}
  ftString,
  ftFixedChar,
  ftWideString:
    begin
      DataType := atString;
      FieldSize := AFld.Size;
    end;
{$IFDEF AnyDAC_D12}
  ftShortint:
    begin
      DataType := atNumber;
      FieldSize := 4;
    end;
  ftByte:
    begin
      DataType := atNumber;
      FieldSize := 3;
    end;
{$ENDIF}
  ftSmallint:
    begin
      DataType := atNumber;
      FieldSize := 6;
    end;
  ftWord:
    begin
      DataType := atNumber;
      FieldSize := 5;
    end;
  ftInteger:
    begin
      DataType := atLongInt;
      FieldSize := 11;
    end;
{$IFDEF AnyDAC_D12}
  ftLongWord:
    begin
      DataType := atLongInt;
      FieldSize := 10;
    end;
{$ENDIF}
  ftFloat:
    begin
      DataType := atFloat;
      Precision := TFloatField(AFld).Precision;
      if Precision > 0 then
        FieldSize := Precision + 2
      else
        FieldSize := 18;
    end;
{$IFDEF AnyDAC_D12}
  ftExtended:
    begin
      DataType := atFloat;
      Precision := TExtendedField(AFld).Precision;
      if Precision > 0 then
        FieldSize := Precision + 2
      else
        FieldSize := 21;
    end;
{$ENDIF}
{$IFDEF AnyDAC_D14}
  ftSingle:
    begin
      DataType := atFloat;
      Precision := TSingleField(AFld).Precision;
      if Precision > 0 then
        FieldSize := Precision + 2
      else
        FieldSize := 9;
    end;
{$ENDIF}
  ftCurrency:
    begin
      DataType := atFloat;
      Precision := TCurrencyField(AFld).Precision;
      if Precision > 0 then
        FieldSize := Precision + 2
      else
        FieldSize := 22;
    end;
  ftAutoInc:
    begin
      DataType := atLongInt;
      FieldSize := 11;
    end;
  ftLargeint:
    begin
      DataType := atLongInt;
      FieldSize := 21;
    end;
  ftBCD:
    begin
      DataType := atFloat;
      Precision := TBCDField(AFld).Precision;
      if Precision > 0 then
        FieldSize := Precision + 2
      else
        FieldSize := 18;
    end;
{$IFDEF AnyDAC_D6}
  ftFMTBcd:
    begin
      DataType := atFloat;
      Precision := TFMTBCDField(AFld).Precision;
      if Precision > 0 then
        FieldSize := Precision + 2
      else
        FieldSize := 38;
    end;
{$ENDIF}
  ftDate:
    begin
      DataType := atDate;
      FieldSize := 16;
    end;
  ftTime:
    begin
      DataType := atTime;
      FieldSize := 11;
    end;
{$IFDEF AnyDAC_D6}
  ftTimeStamp,
{$ENDIF}
{$IFDEF AnyDAC_D10}
  ftOraTimeStamp,
{$ENDIF}
  ftDateTime:
    begin
      DataType := atDateTime;
      FieldSize := 27;
    end;
{$IFDEF AnyDAC_D10}
  ftOraInterval,
{$ENDIF}
  ftParadoxOle:
    begin
      DataType := atString;
      FieldSize := 35;
    end;
{$IFDEF AnyDAC_WideMemo}
  ftWideMemo,
{$ENDIF}
  ftMemo,
  ftOraClob,
  ftFmtMemo,
  ftDBaseOle:
    begin
      DataType := atMemo;
      FieldSize := -1;
    end;
  ftBlob,
  ftOraBlob:
    begin
      DataType := atBlob;
      FieldSize := -1;
    end;
  ftBytes,
  ftVarBytes:
    begin
      DataType := atBlob;
      FieldSize := AFld.Size;
    end;
  else
    DataType := atOther;
    FieldSize := 100;
  end;
  FieldName := AFld.FieldName;
end;

{-------------------------------------------------------------------------------}
procedure TADTextField.DefineFieldDef(AFld: TFieldDef);
begin
  AFld.Name := FieldName;
  if AFld.Name = '' then
    AFld.Attributes := AFld.Attributes + [faUnNamed];
  case DataType of
  atOther,
  atString:
    begin
{$IFDEF AnyDAC_Unicode}
      if TADTextFields(Collection).FDef.FDataMove.TextFileEncoding in [ecUTF8, ecUTF16] then
        AFld.DataType := ftWideString
      else
{$ENDIF}
        AFld.DataType := ftString;
      AFld.Size := FieldSize;
      if AFld.Size = 0 then
        AFld.Size := C_AD_DefStrSize;
    end;
  atFloat:
    begin
      AFld.DataType := ftFloat;
      AFld.Precision := Precision;
    end;
  atNumber:
    AFld.DataType := ftWord;
  atBool:
    AFld.DataType := ftBoolean;
  atLongInt:
    AFld.DataType := ftInteger;
  atDate:
    AFld.DataType := ftDate;
  atTime:
    AFld.DataType := ftTime;
  atDateTime:
    AFld.DataType := ftDateTime;
  atBlob:
    AFld.DataType := ftBlob;
  atMemo:
{$IFDEF AnyDAC_Unicode}
    if TADTextFields(Collection).FDef.FDataMove.TextFileEncoding in [ecUTF8, ecUTF16] then
      AFld.DataType := {$IFDEF AnyDAC_WideMemo} ftWideMemo {$ELSE} ftFmtMemo {$ENDIF}
    else
{$ENDIF}
      AFld.DataType := ftMemo;
  end;
end;

{-------------------------------------------------------------------------------}
{ TADTextFields                                                                 }
{-------------------------------------------------------------------------------}
constructor TADTextFields.Create(ADef: TADTextDataDef);
begin
  inherited Create(TADTextField);
  FDef := ADef;
end;

{-------------------------------------------------------------------------------}
function TADTextFields.GetItem(AIndex: Integer): TADTextField;
begin
  Result := TADTextField(inherited GetItem(AIndex));
end;

{-------------------------------------------------------------------------------}
procedure TADTextFields.SetItem(AIndex: Integer; const AValue: TADTextField);
begin
  inherited SetItem(AIndex, AValue);
end;

{-------------------------------------------------------------------------------}
function TADTextFields.GetOwner: TPersistent;
begin
  Result := FDef;
end;

{-------------------------------------------------------------------------------}
function TADTextFields.Add: TADTextField;
begin
  Result := TADTextField(inherited Add);
end;

{-------------------------------------------------------------------------------}
procedure TADTextFields.AddAll;
var
  oDS: TDataSet;
  i: Integer;
begin
  if FDef.FDataMove.SourceKind = skDataSet then
    oDS := FDef.FDataMove.Source
  else if FDef.FDataMove.DestinationKind = skDataSet then
    oDS := FDef.FDataMove.Destination
  else
    oDS := nil;
  if oDS = nil then
    Exit;
  oDS.Active := True;
  Clear;
  for i := 0 to oDS.Fields.Count - 1 do
    Add.DefineAsField(oDS.Fields[i]);
end;

{-------------------------------------------------------------------------------}
function TADTextFields.FindField(const AName: String): TADTextField;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
    if AnsiCompareText(AName, Items[i].FieldName) = 0 then begin
      Result := Items[i];
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
function TADTextFields.FieldByName(const AName: String): TADTextField;
begin
  Result := FindField(AName);
  if Result = nil then
    ADException(FDef.FDataMove, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoTxtFld, [AName]);
end;

{-------------------------------------------------------------------------------}
procedure TADTextFields.CheckFieldName(AField: TADTextField; const ANewName: String);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if (Items[i] <> AField) and (AnsiCompareText(Items[i].FieldName, ANewName) = 0) then
      ADException(FDef.FDataMove, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPTxtFldDup, [ANewName]);
end;

{-------------------------------------------------------------------------------}
{ TADTextFormatSettings                                                         }
{-------------------------------------------------------------------------------}
constructor TADTextFormatSettings.Create(ADef: TADTextDataDef);
{$IFNDEF AnyDAC_D7}
var
  i: Integer;
{$ENDIF}
begin
  inherited Create;
  FDataDef := ADef;
{$IFDEF AnyDAC_D15}
  FFS := TFormatSettings.Create;
{$ELSE}
  {$IFDEF AnyDAC_D7}
  GetLocaleFormatSettings({$IFDEF MSWINDOWS} GetThreadLocale {$ENDIF}
                          {$IFDEF AnyDAC_POSIX} LOCALE_USER_DEFAULT {$ENDIF}, FFS);
  {$ELSE}
  FFS.CurrencyFormat := SysUtils.CurrencyFormat;
  FFS.NegCurrFormat := SysUtils.NegCurrFormat;
  FFS.ThousandSeparator := SysUtils.ThousandSeparator;
  FFS.DecimalSeparator := SysUtils.DecimalSeparator;
  FFS.CurrencyDecimals := SysUtils.CurrencyDecimals;
  FFS.DateSeparator := SysUtils.DateSeparator;
  FFS.TimeSeparator := SysUtils.TimeSeparator;
  FFS.ListSeparator := SysUtils.ListSeparator;
  FFS.CurrencyString := SysUtils.CurrencyString;
  FFS.ShortDateFormat := SysUtils.ShortDateFormat;
  FFS.LongDateFormat := SysUtils.LongDateFormat;
  FFS.TimeAMString := SysUtils.TimeAMString;
  FFS.TimePMString := SysUtils.TimePMString;
  FFS.ShortTimeFormat := SysUtils.ShortTimeFormat;
  FFS.LongTimeFormat := SysUtils.LongTimeFormat;
  for i := 1 to 12 do
    FFS.ShortMonthNames[i] := SysUtils.ShortMonthNames[i];
  for i := 1 to 12 do
    FFS.LongMonthNames[i] := SysUtils.LongMonthNames[i];
  for i := 1 to 7 do
    FFS.ShortDayNames[i] := SysUtils.ShortDayNames[i];
  for i := 1 to 7 do
    FFS.LongDayNames[i] := SysUtils.LongDayNames[i];
  FFS.TwoDigitYearCenturyWindow := SysUtils.TwoDigitYearCenturyWindow;
  {$ENDIF}
{$ENDIF}
  FValues := [];
end;

{-------------------------------------------------------------------------------}
destructor TADTextFormatSettings.Destroy;
begin
  FDataDef := nil;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetOwner: TPersistent;
begin
  Result := FDataDef;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetCurrencyDecimals: Byte;
begin
  Result := FFS.CurrencyDecimals;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetCurrencyFormat: Byte;
begin
  Result := FFS.CurrencyFormat;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetCurrencyString: string;
begin
  Result := FFS.CurrencyString;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetDateSeparator: Char;
begin
  Result := FFS.DateSeparator;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetDecimalSeparator: Char;
begin
  Result := FFS.DecimalSeparator;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetNegCurrFormat: Byte;
begin
  Result := FFS.NegCurrFormat;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetShortDateFormat: string;
begin
  Result := FFS.ShortDateFormat;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetShortTimeFormat: string;
begin
  Result := FFS.ShortTimeFormat;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetThousandSeparator: Char;
begin
  Result := FFS.ThousandSeparator;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetTimeAMString: string;
begin
  Result := FFS.TimeAMString;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetTimePMString: string;
begin
  Result := FFS.TimePMString;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetTimeSeparator: Char;
begin
  Result := FFS.TimeSeparator;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.GetTwoDigitYearCenturyWindow: Word;
begin
  Result := FFS.TwoDigitYearCenturyWindow;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.Assign(ASource: TPersistent);
begin
  if ASource is TADTextFormatSettings then begin
    FFS := TADTextFormatSettings(ASource).FFS;
    FValues := TADTextFormatSettings(ASource).FValues;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetCurrencyDecimals(const AValue: Byte);
begin
  if FFS.CurrencyDecimals <> AValue then begin
    FFS.CurrencyDecimals := AValue;
    Include(FValues, fsCurrencyDecimals);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetCurrencyFormat(const AValue: Byte);
begin
  if FFS.CurrencyFormat <> AValue then begin
    FFS.CurrencyFormat := AValue;
    Include(FValues, fsCurrencyFormat);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetCurrencyString(const AValue: string);
begin
  if FFS.CurrencyString <> AValue then begin
    FFS.CurrencyString := AValue;
    Include(FValues, fsCurrencyString);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetDateSeparator(const AValue: Char);
begin
  if FFS.DateSeparator <> AValue then begin
    FFS.DateSeparator := AValue;
    Include(FValues, fsDateSeparator);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetDecimalSeparator(const AValue: Char);
begin
  if FFS.DecimalSeparator <> AValue then begin
    FFS.DecimalSeparator := AValue;
    Include(FValues, fsDecimalSeparator);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetNegCurrFormat(const AValue: Byte);
begin
  if FFS.NegCurrFormat <> AValue then begin
    FFS.NegCurrFormat := AValue;
    Include(FValues, fsNegCurrFormat);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetShortDateFormat(const AValue: string);
begin
  if FFS.ShortDateFormat <> AValue then begin
    FFS.ShortDateFormat := AValue;
    Include(FValues, fsShortDateFormat);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetShortTimeFormat(const AValue: string);
begin
  if FFS.ShortTimeFormat <> AValue then begin
    FFS.ShortTimeFormat := AValue;
    Include(FValues, fsShortTimeFormat);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetThousandSeparator(const AValue: Char);
begin
  if FFS.ThousandSeparator <> AValue then begin
    FFS.ThousandSeparator := AValue;
    Include(FValues, fsThousandSeparator);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetTimeAMString(const AValue: string);
begin
  if FFS.TimeAMString <> AValue then begin
    FFS.TimeAMString := AValue;
    Include(FValues, fsTimeAMString);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetTimePMString(const AValue: string);
begin
  if FFS.TimePMString <> AValue then begin
    FFS.TimePMString := AValue;
    Include(FValues, fsTimePMString);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetTimeSeparator(const AValue: Char);
begin
  if FFS.TimeSeparator <> AValue then begin
    FFS.TimeSeparator := AValue;
    Include(FValues, fsTimeSeparator);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextFormatSettings.SetTwoDigitYearCenturyWindow(
  const AValue: Word);
begin
  if FFS.TwoDigitYearCenturyWindow <> AValue then begin
    FFS.TwoDigitYearCenturyWindow := AValue;
    Include(FValues, fsTwoDigitYearCenturyWindow);
  end;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsCDS: Boolean;
begin
  Result := fsCurrencyDecimals in FValues;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsCFS: Boolean;
begin
  Result := fsCurrencyFormat in FValues;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsCSS: Boolean;
begin
  Result := fsCurrencyString in FValues;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsDSS: Boolean;
begin
  Result := fsDecimalSeparator in FValues;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsDTSS: Boolean;
begin
  Result := fsDateSeparator in FValues;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsNCFS: Boolean;
begin
  Result := fsNegCurrFormat in FValues;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsSDFS: Boolean;
begin
  Result := fsShortDateFormat in FValues;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsSTFS: Boolean;
begin
  Result := fsShortTimeFormat in FValues;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsTAMSS: Boolean;
begin
  Result := fsTimeAMString in FValues;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsTDYCWS: Boolean;
begin
  Result := fsTwoDigitYearCenturyWindow in FValues;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsTMSS: Boolean;
begin
  Result := fsTimeSeparator in FValues;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsTPMSS: Boolean;
begin
  Result := fsTimePMString in FValues;
end;

{-------------------------------------------------------------------------------}
function TADTextFormatSettings.IsTSS: Boolean;
begin
  Result := fsThousandSeparator in FValues;
end;

{-------------------------------------------------------------------------------}
{ TADTextDataDef                                                                }
{-------------------------------------------------------------------------------}
constructor TADTextDataDef.Create(ADataMove: TADDataMove);
begin
  inherited Create;
  FDataMove := ADataMove;
  FFields := TADTextFields.Create(Self);
  FDelimiter := #34;
  FSeparator := #59;
  FRecordFormat := rfCommaDoubleQuote;
  FRecordDelimiter := elDefault;
  FWithFieldNames := False;
  FStrsEmpty2Null := True;
  FTrimLeft := True;
  FTrimRight := True;
  FFormatSettings := TADTextFormatSettings.Create(Self);
end;

{-------------------------------------------------------------------------------}
destructor TADTextDataDef.Destroy;
begin
  ADFreeAndNil(FFields);
  ADFreeAndNil(FFormatSettings);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
function TADTextDataDef.GetOwner: TPersistent;
begin
  Result := FDataMove;
end;

{-------------------------------------------------------------------------------}
procedure TADTextDataDef.Assign(ASource: TPersistent);
begin
  if ASource is TADTextDataDef then begin
    EndOfLine := TADTextDataDef(ASource).EndOfLine;
    Delimiter := TADTextDataDef(ASource).Delimiter;
    Separator := TADTextDataDef(ASource).Separator;
    RecordFormat := TADTextDataDef(ASource).RecordFormat;
    Fields := TADTextDataDef(ASource).Fields;
    WithFieldNames := TADTextDataDef(ASource).WithFieldNames;
    StrsEmpty2Null := TADTextDataDef(ASource).StrsEmpty2Null;
    TrimLeft := TADTextDataDef(ASource).TrimLeft;
    TrimRight := TADTextDataDef(ASource).TrimRight;
    FormatSettings.Assign(TADTextDataDef(ASource).FormatSettings);
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
procedure TADTextDataDef.SetFields(const AValue: TADTextFields);
begin
  FFields.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADTextDataDef.SetDelimiter(AValue: Char);
begin
  if FDelimiter <> AValue then begin
    RecordFormat := rfCustom;
    FDelimiter := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextDataDef.SetSeparator(AValue: Char);
begin
  if FSeparator <> AValue then begin
    RecordFormat := rfCustom;
    FSeparator := AValue;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextDataDef.SetRecordFormat(AValue: TADTextRecordFormat);
begin
  if FRecordFormat <> AValue then begin
    FRecordFormat := AValue;
    case AValue of
    rfCommaDoubleQuote:
      begin
        FDelimiter := #34;
        FSeparator := #59;
      end;
    rfTabDoubleQuote:
      begin
        FDelimiter := #34;
        FSeparator := #9;
      end;
    rfFixedLength:
      begin
        FDelimiter := #34;
        FSeparator := #0;
        FWithFieldNames := False;
      end;
    rfFieldPerLine:
      begin
        FDelimiter := #0;
        FSeparator := #0;
        FWithFieldNames := False;
      end;
    else
      FDelimiter := #34;
      FSeparator := #59;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADTextDataDef.IsADDS: Boolean;
begin
  Result := (FRecordFormat = rfCustom);
end;

{-------------------------------------------------------------------------------}
procedure TADTextDataDef.SetWithFieldNames(const AValue: Boolean);
begin
  if FWithFieldNames <> AValue then begin
    FWithFieldNames := AValue;
    if FWithFieldNames and (RecordFormat in [rfFixedLength, rfFieldPerLine]) then
      RecordFormat := rfCommaDoubleQuote;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADTextDataDef.SetFormatSettings(const AValue: TADTextFormatSettings);
begin
  FFormatSettings.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
{ TADMappingItemExpressionDS                                                    }
{-------------------------------------------------------------------------------}
type
  TADMappingItemExpressionDS = class(TInterfacedObject, IADStanExpressionDataSource)
  private
    FMappings: TADMappings;
    FDataMove: TADDataMove;
    FThisIndex: Integer;
  protected
    // IADStanExpressionDataSource
    function GetVarIndex(const AName: String): Integer;
    function GetVarType(AIndex: Integer): TADDataType;
    function GetVarScope(AIndex: Integer): TADExpressionScopeKind;
    function GetVarData(AIndex: Integer): Variant;
    procedure SetVarData(AIndex: Integer; const AValue: Variant);
    function GetSubAggregateValue(AIndex: Integer): Variant; virtual;
    function GetPosition: Pointer;
    procedure SetPosition(AValue: Pointer);
    function GetRowNum: Integer;
    function GetDatabase: String;
    function GetUser: String;
  public
    constructor Create(AMappings: TADMappings; AThisIndex: Integer);
  end;

{-------------------------------------------------------------------------------}
constructor TADMappingItemExpressionDS.Create(AMappings: TADMappings;
  AThisIndex: Integer);
begin
  inherited Create;
  FMappings := AMappings;
  FDataMove := AMappings.DataMove;
  FThisIndex := AThisIndex;
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetPosition: Pointer;
begin
  Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItemExpressionDS.SetPosition(AValue: Pointer);
begin
  // nothing
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetRowNum: Integer;
begin
  Result := FDataMove.ReadCount;
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetDatabase: String;
begin
  Result := '';
  if FDataMove.SourceKind = skDataSet then begin
    if (FDataMove.Source is TADAdaptedDataSet) and
       (TADAdaptedDataSet(FDataMove.Source).PointedConnection <> nil) and
       (TADAdaptedDataSet(FDataMove.Source).PointedConnection.ConnectionIntf <> nil) then
      Result := TADAdaptedDataSet(FDataMove.Source).PointedConnection.ConnectionIntf.CurrentCatalog;
  end
  else
    Result := FDataMove.TextFileName;
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetUser: String;
begin
  Result := '';
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetSubAggregateValue(AIndex: Integer): Variant;
begin
  Result := Unassigned;
  ADCapabilityNotSupported(Self, [S_AD_LComp, S_AD_LComp_PDM]);
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetVarIndex(const AName: String): Integer;
begin
  Result := FMappings.IndexOfName(AName);
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetVarType(AIndex: Integer): TADDataType;
const
  ADT2ADDT: array[TADTextDataType] of TADDataType = (dtAnsiString, dtAnsiString,
    dtDouble, dtFmtBCD, dtBoolean, dtInt32, dtDate, dtTime, dtDateTime, dtBlob, dtMemo);
var
  iScale, iPrec: Integer;
  iSize: LongWord;
  eAttrs: TADDataAttributes;
  oItem: TADMappingItem;
begin
  oItem := FMappings.Items[AIndex];
  if oItem.SourceExpression <> '' then
    if FDataMove.DestinationKind = skText then
      Result := ADT2ADDT[FDataMove.TextDataDef.Fields.FieldByName(oItem.DestinationFieldName).DataType]
    else begin
      Result := dtUnknown;
      iScale := 0;
      iPrec := 0;
      iSize := 0;
      eAttrs := [];
      TADFormatOptions.FieldDef2ColumnDef(FDataMove.Destination.FieldByName(oItem.DestinationFieldName),
        Result, iSize, iPrec, iScale, eAttrs);
    end
  else if oItem.SourceFieldName <> '' then
    if FDataMove.SourceKind = skText then
      Result := ADT2ADDT[FDataMove.TextDataDef.Fields.FieldByName(oItem.SourceFieldName).DataType]
    else begin
      Result := dtUnknown;
      iScale := 0;
      iPrec := 0;
      iSize := 0;
      eAttrs := [];
      TADFormatOptions.FieldDef2ColumnDef(FDataMove.Source.FieldByName(oItem.SourceFieldName),
        Result, iSize, iPrec, iScale, eAttrs);
    end;
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetVarScope(AIndex: Integer): TADExpressionScopeKind;
begin
  Result := ckField;
end;

{-------------------------------------------------------------------------------}
function TADMappingItemExpressionDS.GetVarData(AIndex: Integer): Variant;
var
  oItem: TADMappingItem;
begin
  oItem := FMappings.Items[AIndex];
  if AIndex = FThisIndex then
    Result := oItem.GetItemBaseValue
  else
    Result := oItem.ItemValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItemExpressionDS.SetVarData(AIndex: Integer; const AValue: Variant);
begin
  FMappings.Items[AIndex].SourceValue := AValue;
end;

{-------------------------------------------------------------------------------}
{ TADMappingItem                                                                }
{-------------------------------------------------------------------------------}
destructor TADMappingItem.Destroy;
begin
  Unprepare;
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItem.Assign(ASource: TPersistent);
begin
  if ASource is TADMappingItem then begin
    SourceFieldName := TADMappingItem(ASource).SourceFieldName;
    SourceExpression := TADMappingItem(ASource).SourceExpression;
    DestinationFieldName := TADMappingItem(ASource).DestinationFieldName;
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
function TADMappingItem.GetDisplayName: string;
begin
  Result := SourceFieldName;
  if Result = '' then
    Result := SourceExpression;
  if (Result <> '') or (DestinationFieldName <> '') then
    Result := Result + '->';
  Result := Result + DestinationFieldName;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItem.Prepare;
var
  oParser: IADStanExpressionParser;
  iDestInd: Integer;
  oDM: TADDataMove;
begin
  oDM := TADMappings(Collection).FDataMove;
  if oDM.DestinationKind = skText then begin
    if DestinationFieldName <> '' then
      FDestTextField := oDM.TextDataDef.Fields.FieldByName(DestinationFieldName)
    else
      FDestTextField := oDM.TextDataDef.Fields[Index];
    iDestInd := FDestTextField.Index;
  end
  else begin
    if DestinationFieldName <> '' then
      FDestField := oDM.Destination.FieldByName(DestinationFieldName)
    else
      FDestField := oDM.Destination.Fields[Index];
    iDestInd := FDestField.Index;
    FInKey := pfInKey in FDestField.ProviderFlags;
    FIsIdentity := ((FDestField is TADAutoIncField) or
      (caAutoInc in oDM.Destination.GetFieldColumn(FDestField).ActualAttributes)) and
      (poIdentityInsert in TADMappings(Collection).FDataMove.Options);
  end;
  if SourceExpression <> '' then begin
    ADCreateInterface(IADStanExpressionParser, oParser);
    FSourceEvaluator := oParser.Prepare(
      TADMappingItemExpressionDS.Create(TADMappings(Collection), iDestInd),
      SourceExpression, [], [poDefaultExpr], '');
  end;
  if SourceFieldName <> '' then
    if oDM.SourceKind = skText then
      FSourceTextField := oDM.TextDataDef.Fields.FieldByName(SourceFieldName)
    else
      FSourceField := oDM.Source.FieldByName(SourceFieldName)
  else
    try
      if oDM.SourceKind = skText then
        FSourceTextField := oDM.TextDataDef.Fields[iDestInd]
      else
        FSourceField := oDM.Source.Fields[iDestInd];
    except
      ADException(TADMappings(Collection).FDataMove, [S_AD_LComp, S_AD_LComp_PDM],
        er_AD_DPSrcUndefined, [DestinationFieldName]);
    end;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItem.Unprepare;
begin
  FDestField := nil;
  FDestTextField := nil;
  FDestValue := Unassigned;
  FSourceField := nil;
  FSourceTextField := nil;
  FSourceEvaluator := nil;
  FSourceValue := Unassigned;
end;

{-------------------------------------------------------------------------------}
function TADMappingItem.GetItemBaseValue: Variant;
begin
  if FSourceTextField <> nil then
    Result := FSourceValue
  else if FSourceField <> nil then
    Result := FSourceField.Value
  else
    Result := Null;
end;

{-------------------------------------------------------------------------------}
function TADMappingItem.GetItemValue: Variant;
begin
  if FSourceEvaluator <> nil then
    Result := FSourceEvaluator.Evaluate
  else
    Result := GetItemBaseValue;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItem.Move;

  procedure SetupIdentityInsertion;
  begin
    if FDestField is TADAutoIncField then
      TADAutoIncField(FDestField).IdentityInsert := True
    else begin
      FDestField.ReadOnly := False;
      FDestField.ProviderFlags := FDestField.ProviderFlags + [pfInUpdate];
    end;
  end;

var
  V: Variant;
begin
  if FDestTextField <> nil then
    FDestValue := ItemValue
  else if (FSourceField <> nil) and (FSourceEvaluator = nil) then begin
    if FIsIdentity and not FSourceField.IsNull then
      SetupIdentityInsertion;
    FDestField.Assign(FSourceField);
  end
  else begin
    V := ItemValue;
    if VarIsNull(V) then
      FDestField.Clear
    else begin
      if FIsIdentity then
        SetupIdentityInsertion;
      if FDestField is TBinaryField then
{$IFNDEF AnyDAC_D12}
        FDestField.AsString := V
{$ELSE}
        if (TADMappings(Collection).FDataMove.SourceKind = skText) and
           (TADMappings(Collection).FDataMove.TextFileEncoding = ecANSI) then
{$IFDEF AnyDAC_UseAsAnsiString}
          FDestField.AsAnsiString := AnsiString(V)
{$ELSE}
          FDestField.AsString := String(V)
{$ENDIF}
        else
          FDestField.AsWideString := V
{$ENDIF}
      else if FDestField is TLargeintField then begin
{$IFDEF AnyDAC_D6Base}
        TLargeintField(FDestField).AsLargeInt := V;
{$ELSE}
        if TVarData(V).VType = varInt64 then
          TLargeintField(FDestField).AsLargeInt := Decimal(V).lo64
        else
          TLargeintField(FDestField).AsFloat := V;
{$ENDIF}
      end
      else begin
{$IFDEF AnyDAC_D6Base}
        FDestField.Value := V;
{$ELSE}
        if TVarData(V).VType = varInt64 then
          if Decimal(V).lo64 <= MAXINT then
            FDestField.AsInteger := Decimal(V).lo64
          else
            FDestField.AsFloat := Decimal(V).lo64
        else
          FDestField.Value := V;
{$ENDIF}
      end;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMappingItem.GetAsText: String;
begin
  if DestinationFieldName = SourceFieldName then
    Result := DestinationFieldName
  else
    Result := DestinationFieldName + '=' + SourceFieldName;
end;

{-------------------------------------------------------------------------------}
procedure TADMappingItem.SetAsText(const AValue: String);
var
  i: Integer;
begin
  i := Pos('=', AValue);
  if i <> 0 then begin
    DestinationFieldName := Copy(AValue, 1, i - 1);
    SourceFieldName := Copy(AValue, i + 1, Length(AValue));
  end
  else begin
    DestinationFieldName := AValue;
    SourceFieldName := AValue;
  end;
  for i := 1 to Length(SourceFieldName) do
    if not ADInSet(SourceFieldName[i], ['A'..'Z', 'a'..'z', '0'..'9', '_', '$', '#']) then begin
      SourceExpression := SourceFieldName;
      SourceFieldName := '';
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADMappings                                                                   }
{-------------------------------------------------------------------------------}
constructor TADMappings.Create(ADataMove: TADDataMove);
begin
  inherited Create(TADMappingItem);
  FDataMove := ADataMove;
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.Assign(ASource: TPersistent);
var
  i: Integer;
begin
  if ASource is TStrings then begin
    Clear;
    for i := 0 to TStrings(ASource).Count - 1 do
      Add(TStrings(ASource).Strings[i]);
  end
  else
    inherited Assign(ASource);
end;

{-------------------------------------------------------------------------------}
function TADMappings.GetItem(AIndex: Integer): TADMappingItem;
begin
  Result := TADMappingItem(inherited GetItem(AIndex));
end;

{-------------------------------------------------------------------------------}
function TADMappings.GetOwner: TPersistent;
begin
  Result := FDataMove;
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.SetItem(AIndex: Integer; const AValue: TADMappingItem);
begin
  inherited SetItem(AIndex, AValue);
end;

{-------------------------------------------------------------------------------}
function TADMappings.Add: TADMappingItem;
begin
  Result := TADMappingItem(inherited Add);
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.Add(const AMapItem: String);
begin
  Add.AsText := AMapItem;
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.AddAll;
var
  oDestDS, oSrcDS: TDataSet;
  oItem: TADMappingItem;
  oDestFld, oSrcFld: TField;
  oDestTxtFld, oSrcTxtFld: TADTextField;
  i: Integer;
begin
  Clear;
  if (FDataMove.SourceKind = skDataSet) and
     (FDataMove.DestinationKind = skDataSet) then begin
    oSrcDS := FDataMove.Source;
    oDestDS := FDataMove.Destination;
    if (oSrcDS = nil) or (oDestDS = nil) then
      Exit;
    oSrcDS.Active := True;
    oDestDS.Active := True;
    for i := 0 to oDestDS.Fields.Count - 1 do begin
      oDestFld := oDestDS.Fields[i];
      oSrcFld := oSrcDS.FindField(oDestFld.FieldName);
      if oSrcFld <> nil then begin
        oItem := Add;
        oItem.DestinationFieldName := oDestFld.FieldName;
        oItem.SourceFieldName := oSrcFld.FieldName;
      end;
    end;
  end
  else if (FDataMove.SourceKind = skDataSet) and
          (FDataMove.DestinationKind = skText) then begin
    oSrcDS := FDataMove.Source;
    if oSrcDS = nil then
      Exit;
    oSrcDS.Active := True;
    for i := 0 to FDataMove.TextDataDef.Fields.Count - 1 do begin
      oDestTxtFld := FDataMove.TextDataDef.Fields[i];
      oSrcFld := oSrcDS.FindField(oDestTxtFld.FieldName);
      oItem := Add;
      oItem.DestinationFieldName := oDestTxtFld.FieldName;
      if oSrcFld <> nil then
        oItem.SourceFieldName := oSrcFld.FieldName;
    end;
  end
  else if (FDataMove.SourceKind = skText) and
          (FDataMove.DestinationKind = skDataSet) then begin
    oDestDS := FDataMove.Destination;
    if oDestDS = nil then
      Exit;
    oDestDS.Active := True;
    for i := 0 to oDestDS.Fields.Count - 1 do begin
      oDestFld := oDestDS.Fields[i];
      oSrcTxtFld := FDataMove.TextDataDef.Fields.FindField(oDestFld.FieldName);
      oItem := Add;
      oItem.DestinationFieldName := oDestFld.FieldName;
      if oSrcTxtFld <> nil then
        oItem.SourceFieldName := oSrcTxtFld.FieldName;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.Prepare;
var
  i: Integer;
begin
  try
    if FDataMove.TextDataDef.Fields.Count = 0 then begin
      FTextFieldsAdded := True;
      FDataMove.TextDataDef.Fields.AddAll;
    end;
    if Count = 0 then begin
      FMappingsAdded := True;
      AddAll;
    end;
    for i := 0 to Count - 1 do
      Items[i].Prepare;
  except
    Unprepare;
    raise;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.Unprepare;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Unprepare;
  if FMappingsAdded then begin
    Clear;
    FMappingsAdded := False;
  end;
  if FTextFieldsAdded then begin
    FDataMove.TextDataDef.Fields.Clear;
    FTextFieldsAdded := False;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADMappings.Move(AKeysOnly: Boolean);
var
  i: Integer;
  oItem: TADMappingItem;
begin
  for i := 0 to Count - 1 do begin
    oItem := Items[i];
    if not AKeysOnly or oItem.InKey then
      oItem.Move;
  end;
end;

{-------------------------------------------------------------------------------}
function TADMappings.IndexOfName(const AName: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].DestinationFieldName, AName) = 0 then begin
      Result := i;
      Break;
    end;
end;

{-------------------------------------------------------------------------------}
{ TADDataMove                                                                   }
{-------------------------------------------------------------------------------}
constructor TADDataMove.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTextDataDef := TADTextDataDef.Create(Self);
  FMappings := TADMappings.Create(Self);
  FOptions := [poOptimiseDest, poOptimiseSrc, poAbortOnExc, poIdentityInsert];
  FCommitCount := 100;
  FMode := dmAlwaysInsert;
  FTextFileName := 'Data.txt';
  FTextFileEncoding := ecANSI;
  FTextAnalyzeSample := 10;
  FLogFileAction := laNone;
  FLogFileName := 'Data.log';
  FLogFileEncoding := ecANSI;
  FSourceKind := skDataSet;
  FDestinationKind := skDataSet;
  FStatisticsInterval := 100;
end;

{-------------------------------------------------------------------------------}
destructor TADDataMove.Destroy;
begin
  ADFreeAndNil(FTextDataDef);
  ADFreeAndNil(FMappings);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then begin
    if AComponent = FSource then
      Source := nil
    else if AComponent = FDestination then
      Destination := nil;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetTextDataDef(const AValue: TADTextDataDef);
begin
  FTextDataDef.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetMappings(const AValue: TADMappings);
begin
  FMappings.Assign(AValue);
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetDestinationKind(const AValue: TADDataSourceKind);
begin
  if FDestinationKind <> AValue then begin
    FDestinationKind := AValue;
    if DestinationKind = skText then begin
      Mode := dmAlwaysInsert;
      Destination := nil;
      if SourceKind = skText then
        SourceKind := skDataSet;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetSourceKind(const AValue: TADDataSourceKind);
begin
  if FSourceKind <> AValue then begin
    FSourceKind := AValue;
    if SourceKind = skText then begin
      Source := nil;
      if DestinationKind = skText then
        DestinationKind := skDataSet;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetDestination(const AValue: TADAdaptedDataSet);
begin
  if FDestination <> AValue then begin
    if FDestination <> nil then
      FDestination.RemoveFreeNotification(Self);
    FDestination := AValue;
    if AValue = Source then
      Source := nil;
    if FDestination <> nil then begin
      FDestination.FreeNotification(Self);
      DestinationKind := skDataSet;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetSource(const AValue: TDataSet);
begin
  if FSource <> AValue then begin
    if FSource <> nil then
      FSource.RemoveFreeNotification(Self);
    FSource := AValue;
    if AValue = Destination then
      Destination := nil;
    if FSource <> nil then begin
      FSource.FreeNotification(Self);
      SourceKind := skDataSet;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.TextDataAssigned;
begin
  if FSource = nil then
    SourceKind := skText
  else if FDestination = nil then
    DestinationKind := skText;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetTextFileName(const AValue: String);
begin
  if FTextFileName <> AValue then begin
    FTextFileName := AValue;
    TextDataAssigned;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetTextStream(const AValue: TStream);
begin
  if FTextStream <> AValue then begin
    FTextStream := AValue;
    TextDataAssigned;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetMode(const AValue: TADDataMoveMode);
begin
  if FMode <> AValue then begin
    FMode := AValue;
    if DestinationKind = skText then
      FMode := dmAlwaysInsert;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.GetWriteCount: LongInt;
begin
  Result := FInsertCount + FUpdateCount + FDeleteCount;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.Execute: LongInt;
begin
  if (SourceKind = skDataSet) and (DestinationKind = skDataSet) then
    Result := ExecuteTableToTable
  else if (SourceKind = skDataSet) and (DestinationKind = skText) then
    Result := ExecuteTableToText
  else if (SourceKind = skText) and (DestinationKind = skDataSet) then
    Result := ExecuteTextToTable
  else
    Result := -1;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.DoStatistic(APhase: TADDataMovePhase);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, APhase);
end;

{-------------------------------------------------------------------------------}
function TADDataMove.InitLogFile: TADTextFile;
var
  S: String;
begin
  if ((LogFileName > #32) or (LogStream <> nil)) and (LogFileAction <> laNone) then begin
    if LogStream <> nil then
      Result := TADTextFile.Create(LogStream, False, False, LogFileAction = laCreate,
        LogFileEncoding, elDefault)
    else
      Result := TADTextFile.Create(LogFileName, False, LogFileAction = laCreate,
        LogFileEncoding, elDefault);
    S := C_AD_EOL + C_AD_EOL + '*************** ' + S_AD_StartLog + ' ' +
      DateTimeToStr(Now) + ' ***************';
    Result.WriteLine(S);
  end
  else
    Result := nil;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.ProcessException(E: Exception; ALog: TADTextFile;
  out AAction: TADErrorAction);
var
  sSQL, S: String;
begin
  AAction := eaFail;
  if E is EDatabaseError then begin
    if Assigned(FOnError) then begin
      FOnError(Self, AAction);
      if AAction = eaDefault then
        AAction := eaFail;
    end;
    if AAction in [eaFail, eaSkip] then begin
      Inc(FExceptionCount);
      if ALog <> nil then begin
        if E is EADDBEngineException then
          sSQL := EADDBEngineException(E).SQL
        else
          sSQL := '';
        S := C_AD_EOL + E.Message + C_AD_EOL + C_AD_EOL + sSQL;
        ALog.WriteLine(S);
      end;
    end;
    if (AAction = eaFail) and (poAbortOnExc in Options) then
      AAction := eaExitFailure;
  end
  else
    AAction := eaExitFailure;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.DeleteExceptionFile(ALog: TADTextFile);
var
  S: String;
begin
  if ALog <> nil then
    try
      if FExceptionCount = 0 then begin
        S := C_AD_EOL + '          **********  ' + S_AD_NoErrorsLogged + ' ' +
          '**********';
        ALog.WriteLine(S);
      end;
      S := C_AD_EOL + '*************** ' + S_AD_EndLog + ' ' +
        DateTimeToStr(Now) + ' ***************';
      ALog.WriteLine(S);
    finally
      ADFree(ALog);
    end;
end;

{-------------------------------------------------------------------------------}
type
  __TADAdaptedDataSet = class(TADAdaptedDataSet)
  end;

procedure TADDataMove.SetupSource;
var
  oFO: TADFetchOptions;
begin
  Source.DisableControls;
  if (poOptimiseSrc in Options) and (Source is TADAdaptedDataSet) and
     __TADAdaptedDataSet(Source).FClientCursor then begin
    oFO := __TADAdaptedDataSet(Source).FetchOptions;
    oFO.Items := [fiBlobs, fiDetails];
    oFO.Mode := fmOnDemand;
    if oFO.RowsetSize < CommitCount then
      oFO.RowsetSize := CommitCount;
    oFO.Cache := [];
    oFO.Unidirectional := True;
  end;
  if not (poSrcFromCurRec in Options) and Source.Active and not Source.Bof then
    try
      Source.First;
    except
      if not IsSrcMemTable then begin
        Source.Close;
        Source.Open;
      end;
    end
  else
    Source.Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.SetupDestination;
var
  oDS: __TADAdaptedDataSet;
begin
  Destination.DisableControls;
  if poOptimiseDest in Options then begin
    oDS := __TADAdaptedDataSet(Destination);
    oDS.FetchOptions.Items := [fiMeta];
    oDS.FetchOptions.Mode := fmManual;
    oDS.UpdateOptions.FastUpdates := True;
  end;
  oDS := __TADAdaptedDataSet(Destination);
  if (oDS.Command <> nil) and (oDS.Command.CommandText.Count > 0) then
    oDS.CheckOnline;
  Destination.Active := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.CheckTextSetup;
var
  i: Integer;
begin
  if TextDataDef.RecordFormat = rfFixedLength then
    for i := 0 to TextDataDef.Fields.Count - 1 do
      if TextDataDef.Fields[i].FieldSize < 0 then
        ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPBadFixedSize,
          [TextDataDef.Fields[i].FieldName]);
end;

{-------------------------------------------------------------------------------}
function TADDataMove.TrimText(const AStr: String; AHeader: Boolean): String;
begin
  if not ((Length(AStr) <> 0) and ((AStr[Length(AStr)] <= ' ') or (AStr[1] <= ' '))) then
    Result := AStr
  else if AHeader or TextDataDef.TrimLeft and TextDataDef.TrimRight then
    Result := Trim(AStr)
  else begin
    Result := AStr;
    if TextDataDef.TrimLeft then
      Result := TrimLeft(Result);
    if TextDataDef.TrimRight then
      Result := TrimRight(Result);
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.GuessTextFormat(AText: TADTextFile; AAnalyze: TADTextAnalyze);
var
  sLine1, sLine2, sItem: String;
  i, j, n, iLen: Integer;
  iBmk: Int64;
  rFmt: TADParseFmtSettings;
  lFieldNames, lAllStrings: Boolean;
  oField: TADTextField;
  eType: TADTextDataType;

  function Unquote(const AStr: String; AHeader: Boolean): String;
  begin
    Result := TrimText(AStr, AHeader);
    if (Result <> '') and (Result[1] = rFmt.FQuote) and (Result[Length(Result)] = rFmt.FQuote) then
      Result := Copy(Result, 2, Length(Result) - 2);
  end;

  function CheckSet(const AStr: String; ASet1, ASet2: TADCharSet): Boolean;
  var
    i: Integer;
  begin
    Result := ADInSet(AStr[1], ASet1);
    if Result then
      for i := 2 to Length(AStr) do begin
        if not ADInSet(AStr[i], ASet2) then begin
          Result := False;
          Exit;
        end;
      end;
  end;

  function GetType(AItem: String; AHeader: Boolean): TADTextDataType;
  begin
    AItem := UpperCase(Unquote(AItem, AHeader));
    if AItem = '' then begin
      Result := atString;
      Exit;
    end;
    if CheckSet(AItem, ['0'..'9', '+', '-'], ['0'..'9']) then
      Result := atLongInt
    else if CheckSet(AItem, ['0'..'9', '+', '-', '.', ','], ['0'..'9', '.', ',']) then
      Result := atFloat
    else if CheckSet(AItem, ['0'..'9'], ['0'..'9', '-', '.']) then
      Result := atDate
    else if CheckSet(AItem, ['0'..'9'], ['0'..'9', ':']) then
      Result := atTime
    else if CheckSet(AItem, ['0'..'9'], ['0'..'9', ':', '-', '.', ' ']) then
      Result := atDateTime
    else if AHeader and CheckSet(AItem, ['A'..'Z', '_'], ['0'.. '9', 'A'..'Z', '_']) then
      Result := atString
    else if (Length(AItem) >= 32) and CheckSet(AItem, ['0'.. '9', 'A'..'F'], ['0'.. '9', 'A'..'F']) then
      Result := atBlob
    else if (AItem = 'T') or (AItem = 'F') or (AItem = 'TRUE') or (AItem = 'FALSE') or
            (AItem = 'Y') or (AItem = 'N') or (AItem = 'YES') or (AItem = 'NO') then
      Result := atBool
    else
      Result := atString;
  end;

begin
  sLine1 := AText.ReadLine;
  if taDelimSep in AAnalyze then begin
    TextDataDef.RecordFormat := rfCustom;
    if Pos(#9, sLine1) <> 0 then
      TextDataDef.Separator := #9
    else if Pos(';', sLine1) <> 0 then
      TextDataDef.Separator := ';';
    TextDataDef.Delimiter := '"';
    TextDataDef.FormatSettings.DecimalSeparator := '.';
    TextDataDef.FormatSettings.DateSeparator := '-';
    TextDataDef.FormatSettings.ShortDateFormat := 'yyyy/MM/dd';
  end;
  rFmt.FDelimiter := TextDataDef.Separator;
  rFmt.FQuote := TextDataDef.Delimiter;
  rFmt.FQuote1 := #0;
  rFmt.FQuote2 := #0;

  if taHeader in AAnalyze then begin
    lFieldNames := True;
    lAllStrings := True;
    i := 1;
    while i <= Length(sLine1) do begin
      sItem := Trim(ADExtractFieldName(sLine1, i, rFmt));
      if (sItem = '') or (GetType(sItem, True) <> atString) then begin
        lFieldNames := False;
        Break;
      end;
    end;
    if lFieldNames then begin
      iBmk := AText.Stream.Position;
      for j := 1 to TextAnalyzeSample do begin
        sLine2 := AText.ReadLine;
        if sLine2 = '' then
          Break;
        i := 1;
        while i <= Length(sLine2) do begin
          sItem := Trim(ADExtractFieldName(sLine2, i, rFmt));
          if GetType(sItem, False) <> atString then begin
            lAllStrings := False;
            Break;
          end;
        end;
        if not lAllStrings then
          Break;
      end;
      AText.Stream.Position := iBmk;
    end;
    TextDataDef.WithFieldNames := lFieldNames and not lAllStrings;
  end;

  if taFields in AAnalyze then begin
    TextDataDef.Fields.Clear;
    if TextDataDef.WithFieldNames then begin
      i := 1;
      while i <= Length(sLine1) do
        TextDataDef.Fields.Add.FieldName := Unquote(ADExtractFieldName(sLine1, i, rFmt), True);
      sLine2 := AText.ReadLine;
    end
    else
      sLine2 := sLine1;
    n := 0;
    repeat
      i := 1;
      j := 0;
      while i <= Length(sLine2) do begin
        sItem := ADExtractFieldName(sLine2, i, rFmt);
        if not TextDataDef.WithFieldNames then
          oField := TextDataDef.Fields.Add
        else
          oField := TextDataDef.Fields[j];
        Inc(j);
        eType := GetType(sItem, False);
        case oField.DataType of
        atLongInt:
          if eType = atFloat then
            oField.DataType := atFloat
          else if eType <> atLongInt then
            oField.DataType := atMemo;
        atDate,
        atTime:
          if eType = atDateTime then
            oField.DataType := eType
          else if not (eType in [atDate, atTime]) then
            oField.DataType := atMemo;
        atOther,
        atString:
          oField.DataType := eType;
        end;
        if oField.DataType in [atString, atMemo] then begin
          iLen := Length(Unquote(sItem, False));
          if iLen > oField.FieldSize then
            oField.FieldSize := iLen;
        end;
      end;
      if n < TextAnalyzeSample then
        sLine2 := AText.ReadLine;
      Inc(n);
    until (sLine2 = '') or (n = TextAnalyzeSample);
    for i := 0 to TextDataDef.Fields.Count - 1 do begin
      oField := TextDataDef.Fields[i];
      if oField.DataType = atMemo then
        oField.DataType := atString;
    end;
  end;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.AbortJob;
begin
  if (Source <> nil) and (Source is TADAdaptedDataSet) then
    TADAdaptedDataSet(Source).AbortJob(True);
  if Destination <> nil then
    Destination.AbortJob(True);
  FAborting := True;
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.GuessTextFormat(
  AAnalyze: TADTextAnalyze = [taDelimSep, taHeader, taFields]);
var
  oText: TADTextFile;
  iBmk: Int64;
begin
  if TextStream <> nil then begin
    iBmk := TextStream.Position;
    oText := TADTextFile.Create(TextStream, False, True, False,
      TextFileEncoding, TextDataDef.EndOfLine);
  end
  else begin
    iBmk := -1;
    oText := TADTextFile.Create(TextFileName, True, False,
      TextFileEncoding, TextDataDef.EndOfLine);
  end;
  try
    GuessTextFormat(oText, AAnalyze);
  finally
    if TextStream <> nil then
      TextStream.Position := iBmk;
    ADFree(oText);
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.IsSrcMemTable: Boolean;
begin
  Result := (SourceKind = skDataSet) and (Source <> nil) and
    (Source is TADCustomMemTable) and (TADCustomMemTable(Source).Command = nil);
end;

{-------------------------------------------------------------------------------}
function TADDataMove.IsDestMemTable: Boolean;
begin
  Result := (DestinationKind = skDataSet) and (Destination <> nil) and
    (Destination is TADCustomMemTable) and (TADCustomMemTable(Destination).Command = nil);
end;

{-------------------------------------------------------------------------------}
procedure TADDataMove.CreateDestinationDataSet;
var
  oDS: TDataSet;
  i: Integer;
begin
  oDS := Destination;
  if not IsDestMemTable or oDS.Active then
    Exit;
  if SourceKind = skText then begin
    oDS.FieldDefs.Clear;
    for i := 0 to TextDataDef.Fields.Count - 1 do
      TextDataDef.Fields[i].DefineFieldDef(oDS.FieldDefs.AddFieldDef);
  end
  else if SourceKind = skDataSet then begin
    if not Source.FieldDefs.Updated then
      Source.FieldDefs.Update;
    oDS.FieldDefs.Assign(Source.FieldDefs);
  end;
  oDS.Active := True;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.FindDestRecord: Boolean;
begin
  if Assigned(FOnFindDestRecord) then begin
    Result := False;
    FOnFindDestRecord(Self, Result);
  end
  else begin
    Destination.ServerSetKey;
    Mappings.Move(True);
    Result := Destination.ServerGotoKey;
  end;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.ExecuteTableToTable: LongInt;
var
  oLog: TADTextFile;
  iAction: TADDataMoveAction;
  oDestConn: TADCustomConnection;
  lExcLogged: Boolean;
  oWait: IADGUIxWaitCursor;
  lDestDisconnected, lSrcActive, lDestActive, lRetry: Boolean;
  eErrorAction: TADErrorAction;
begin
  if Source = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoSrcDS, []);
  if Destination = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoDestDS, []);

  FReadCount := 0;
  FInsertCount := 0;
  FUpdateCount := 0;
  FDeleteCount := 0;
  FExceptionCount := 0;
  FAborting := False;
  lExcLogged := False;
  lDestDisconnected := False;
  oLog := nil;
  oDestConn := nil;
  oWait := nil;

  DoStatistic(psPreparing);
  if not FAborting then
  try
    if not ADGUIxSilent then begin
      ADCreateInterface(IADGUIxWaitCursor, oWait);
      oWait.StartWait;
    end;
    oLog := InitLogFile;

    try
      oDestConn := Destination.PointedConnection;
      if oDestConn <> nil then begin
        lDestDisconnected := not oDestConn.Connected;
        oDestConn.Connected := True;
        if (CommitCount > 0) and not oDestConn.InTransaction then
          oDestConn.StartTransaction;
      end;
      lSrcActive := Source.Active;
      lDestActive := Destination.Active;
      try

        SetupSource;
        CreateDestinationDataSet;
        lDestActive := Destination.Active;
        SetupDestination;
        Mappings.Prepare;

        if [poClearDest, poClearDestNoUndo] * Options <> [] then
          iAction := paAlwaysInsert
        else if Mode = dmAlwaysInsert then
          iAction := paAlwaysInsert
        else if Mode = dmDelete then
          iAction := paDelete
        else
          iAction := paSkip;

        if [poClearDest, poClearDestNoUndo] * Options <> [] then
          Destination.ServerDeleteAll(poClearDestNoUndo in Options);

        DoStatistic(psStarting);

        while not FSource.Eof and not FAborting do begin
          if oWait <> nil then
            oWait.StartWait;
          try
            Inc(FReadCount);

            if not (iAction in [paDelete, paAlwaysInsert]) then begin
              iAction := paSkip;
              if FindDestRecord then begin
                if (Mode = dmUpdate) or (Mode = dmAppendUpdate) then
                  iAction := paUpdate;
              end
              else begin
                if (Mode = dmAppend) or (Mode = dmAppendUpdate) then
                  iAction := paInsert;
              end;
            end;

            if (oDestConn <> nil) and (CommitCount > 0) and not oDestConn.InTransaction then
              oDestConn.StartTransaction;

            repeat
              lRetry := False;
              try
                case iAction of
                paInsert, paAlwaysInsert:
                  begin
                    Destination.ServerAppend;
                    Mappings.Move(False);
                    Destination.ServerPerform;
                    Inc(FInsertCount);
                  end;
                paUpdate:
                  begin
                    Destination.ServerEdit;
                    Mappings.Move(False);
                    Destination.ServerPerform;
                    Inc(FUpdateCount);
                  end;
                paDelete:
                  begin
                    Destination.ServerDelete;
                    Mappings.Move(True);
                    Destination.ServerPerform;
                    Inc(FDeleteCount);
                  end;
                end;
              except
                on E: Exception do begin
                  if (oDestConn <> nil) and (CommitCount > 0) and oDestConn.InTransaction then
                    oDestConn.Rollback;
                  lExcLogged := True;
                  ProcessException(E, oLog, eErrorAction);
                  case eErrorAction of
                  eaFail:        lRetry := False;
                  eaSkip:        lRetry := False;
                  eaRetry:       lRetry := True;
                  eaApplied:     lRetry := False;
                  eaExitSuccess: FAborting := True;
                  eaExitFailure: raise;
                  end;
                  lExcLogged := False;
                end;
              end;
            until not lRetry;

            try
              Source.Next;
            except
              Source.UpdateCursorPos;
            end;

            if (oDestConn <> nil) and (CommitCount > 0) and oDestConn.InTransaction then
              if WriteCount mod CommitCount = 0 then
                oDestConn.Commit;

            if StatisticsInterval > 0 then
              if FReadCount mod StatisticsInterval = 0 then
                DoStatistic(psProgress);
          finally
            if oWait <> nil then
              oWait.StopWait;
          end;
        end;

        DoStatistic(psFinishing);
        if not IsSrcMemTable then
          Source.Close;
        if not IsDestMemTable then
          Destination.Disconnect;

      finally
        Source.Active := lSrcActive;
        Destination.Active := lDestActive;
        Source.EnableControls;
        Destination.EnableControls;
      end;

      if (oDestConn <> nil) and (CommitCount > 0) and oDestConn.InTransaction then
        oDestConn.Commit;

    except
      on E: Exception do begin
        if (oDestConn <> nil) and (CommitCount > 0) and oDestConn.InTransaction then
          oDestConn.Rollback;
        if not lExcLogged then
          ProcessException(E, oLog, eErrorAction);
        if eErrorAction = eaExitFailure then
          raise;
      end;
    end;

  finally
    if (oDestConn <> nil) and lDestDisconnected then
      oDestConn.Connected := False;
    Mappings.Unprepare;
    DeleteExceptionFile(oLog);
    if oWait <> nil then
      oWait.StopWait;
  end;
  DoStatistic(psUnpreparing);
  Result := WriteCount;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.ExecuteTableToText: LongInt;
var
  oLog: TADTextFile;
  oText: TADTextFile;
  oTextField: TADTextField;
  sVal: String;
  lNeedDelim: Boolean;
  i: Integer;
  oWait: IADGUIxWaitCursor;
  lSrcActive: Boolean;
  eErrorAction: TADErrorAction;

  function GetStr(ATxtFld: TADTextField): String;
  var
    i: Integer;
    v: Variant;
    oItem: TADMappingItem;
    sb: TADByteString;
    iLen: Integer;
    pData: Pointer;
{$IFNDEF AnyDAC_D7}
    prevShortDateFormat: String;
    prevDateSep: Char;
    prevShortTimeFormat: String;
    prevTimeSep: Char;
{$ENDIF}
  begin
    Result := '';
    for i := 0 to Mappings.Count - 1 do begin
      oItem := Mappings[i];
      if oItem.DestTextField = ATxtFld then begin
        v := oItem.DestValue;
        if not VarIsEmpty(v) and not VarIsNull(v) then begin
          { TODO -cPUMP : Here we should format values }
          case ATxtFld.DataType of
          atOther:
            Result := v;
          atString:
            Result := v;
          atFloat:
            Result := ADFloat2Str(v, TextDataDef.FormatSettings.DecimalSeparator,
              ATxtFld.Precision);
          atNumber:
            Result := v;
          atBool:
            if (v) then
              Result := 'T'
            else
              Result := 'F';
          atLongInt:
            Result := v;
          atDate:
{$IFDEF AnyDAC_D7}
            Result := DateToStr(v, TextDataDef.FormatSettings.FFS);
{$ELSE}
            begin
              prevShortDateFormat := ShortDateFormat;
              prevDateSep := DateSeparator;
              ShortDateFormat := TextDataDef.FormatSettings.ShortDateFormat;
              DateSeparator := TextDataDef.FormatSettings.DateSeparator;
              try
                Result := DateToStr(v);
              finally
                ShortDateFormat := prevShortDateFormat;
                DateSeparator := prevDateSep;
              end;
            end;
{$ENDIF}
          atTime:
{$IFDEF AnyDAC_D7}
            Result := TimeToStr(v, TextDataDef.FormatSettings.FFS);
{$ELSE}
            begin
              prevShortTimeFormat := ShortTimeFormat;
              prevTimeSep := TimeSeparator;
              ShortTimeFormat := TextDataDef.FormatSettings.ShortTimeFormat;
              TimeSeparator := TextDataDef.FormatSettings.TimeSeparator;
              try
                Result := TimeToStr(v);
              finally
                ShortTimeFormat := prevShortTimeFormat;
                TimeSeparator := prevTimeSep;
              end;
            end;
{$ENDIF}
          atDateTime:
{$IFDEF AnyDAC_D7}
            Result := DateTimeToStr(v, TextDataDef.FormatSettings.FFS);
{$ELSE}
            begin
              prevShortTimeFormat := ShortTimeFormat;
              prevTimeSep := TimeSeparator;
              ShortTimeFormat := TextDataDef.FormatSettings.ShortTimeFormat;
              TimeSeparator := TextDataDef.FormatSettings.TimeSeparator;
              prevShortDateFormat := ShortDateFormat;
              prevDateSep := DateSeparator;
              ShortDateFormat := TextDataDef.FormatSettings.ShortDateFormat;
              DateSeparator := TextDataDef.FormatSettings.DateSeparator;
              try
                Result := DateTimeToStr(v);
              finally
                ShortTimeFormat := prevShortTimeFormat;
                TimeSeparator := prevTimeSep;
                ShortDateFormat := prevShortDateFormat;
                DateSeparator := prevDateSep;
              end;
            end;
{$ENDIF}
          atBlob:
            if VarIsArray(v) then begin
              iLen := VarArrayHighBound(v, 1) + 1;
              pData := VarArrayLock(v);
              try
                Result := ADBin2Hex(pData, iLen);
              finally
                VarArrayUnlock(v);
              end;
            end
            else begin
              sb := TADEncoder.Enco({$IFNDEF AnyDAC_D6} VarToStr(v) {$ELSE} v {$ENDIF}, ecANSI);
              Result := ADBin2Hex(PADByteString(sb), ADByteStrLength(sb));
            end;
          atMemo:
            Result := v;
          end;
        end;
        Break;
      end;
    end;
  end;

  procedure DoubleChar(ACh: Char; var AStr: String);
  var
    j: Integer;
  begin
    j := 1;
    repeat
      j := ADPosEx(ACh, AStr, j);
      if j > 0 then begin
        Insert(ACh, AStr, j);
        Inc(j, 2);
      end;
    until j = 0;
  end;

begin
  if Source = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoSrcDS, []);
  if (TextFileName = '') and (TextStream = nil) then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoTxtDest, []);

  FReadCount := 0;
  FInsertCount := 0;
  FUpdateCount := 0;
  FDeleteCount := 0;
  FExceptionCount := 0;
  FAborting := False;
  oText := nil;
  oLog := nil;
  oWait := nil;

  DoStatistic(psPreparing);
  if not FAborting then
  try
    if not ADGUIxSilent then begin
      ADCreateInterface(IADGUIxWaitCursor, oWait);
      oWait.StartWait;
    end;
    oLog := InitLogFile;

    lSrcActive := Source.Active;
    try

      if TextStream <> nil then
        oText := TADTextFile.Create(TextStream, False, False,
          [poClearDest, poClearDestNoUndo] * Options = [],
          TextFileEncoding, TextDataDef.EndOfLine)
      else
        oText := TADTextFile.Create(TextFileName, False,
          [poClearDest, poClearDestNoUndo] * Options = [],
          TextFileEncoding, TextDataDef.EndOfLine);
      SetupSource;
      Mappings.Prepare;
      CheckTextSetup;

      try
        DoStatistic(psStarting);

        if TextDataDef.WithFieldNames then begin
          for i := 0 to TextDataDef.Fields.Count - 1 do begin
            if i > 0 then
              oText.WriteChar(TextDataDef.FSeparator);
            if TextDataDef.Delimiter <> #0 then
              oText.WriteChar(TextDataDef.FDelimiter);
            oText.WriteText(TextDataDef.Fields[i].FFieldName);
            if TextDataDef.Delimiter <> #0 then
              oText.WriteChar(TextDataDef.FDelimiter);
          end;
          oText.WriteLine('');
        end;

        while not Source.Eof and not FAborting do begin
          if oWait <> nil then
            oWait.StartWait;
          try
            Inc(FReadCount);

            Mappings.Move(False);
            for i := 0 to TextDataDef.Fields.Count - 1 do begin
              oTextField := TextDataDef.Fields[i];
              sVal := GetStr(oTextField);
              if TextDataDef.Delimiter <> #0 then
                DoubleChar(TextDataDef.Delimiter, sVal);
              if TextDataDef.Separator <> #0 then
                DoubleChar(TextDataDef.Separator, sVal);
              lNeedDelim := oTextField.DataType in [atMemo, atString, atOther];
              if (TextDataDef.RecordFormat in [rfCommaDoubleQuote, rfTabDoubleQuote, rfCustom]) and
                 lNeedDelim and (TextDataDef.Delimiter <> #0) then
                oText.WriteChar(TextDataDef.FDelimiter);
              if TextDataDef.RecordFormat = rfFixedLength then
                if oTextField.DataType in [atMemo, atString, atOther] then
                  sVal := ADPadR(sVal, oTextField.FieldSize)
                else
                  sVal := ADPadL(sVal, oTextField.FieldSize);
              if Length(sVal) > 0 then
                oText.WriteText(sVal);
              if (TextDataDef.RecordFormat in [rfCommaDoubleQuote, rfTabDoubleQuote, rfCustom]) then begin
                if lNeedDelim and (TextDataDef.Delimiter <> #0) then
                  oText.WriteChar(TextDataDef.FDelimiter);
                if i < Source.Fields.Count - 1 then
                  if TextDataDef.Separator <> #0 then
                    oText.WriteChar(TextDataDef.FSeparator);
              end;
              if TextDataDef.RecordFormat = rfFieldPerLine then
                oText.WriteLine('');
            end;
            if TextDataDef.RecordFormat <> rfFieldPerLine then
              oText.WriteLine('');

            Inc(FInsertCount);
            Source.Next;

            if StatisticsInterval > 0 then
              if FReadCount mod StatisticsInterval = 0 then
                DoStatistic(psProgress);
          finally
            if oWait <> nil then
              oWait.StopWait;
          end;
        end;

        DoStatistic(psFinishing);
        if not IsSrcMemTable then
          Source.Close;

      except
        on E: Exception do begin
          ProcessException(E, oLog, eErrorAction);
          if eErrorAction = eaExitFailure then
            raise;
        end;
      end;

    finally
      Source.Active := lSrcActive;
      Source.EnableControls;
    end;

  finally
    Mappings.Unprepare;
    if oText <> nil then
      ADFree(oText);
    DeleteExceptionFile(oLog);
    if oWait <> nil then
      oWait.StopWait;
  end;

  DoStatistic(psUnpreparing);
  Result := WriteCount;
end;

{-------------------------------------------------------------------------------}
function TADDataMove.ExecuteTextToTable: LongInt;
var
  oText: TADTextFile;
  oLog: TADTextFile;
  iAction: TADDataMoveAction;
  oDestConn: TADCustomConnection;
  oTxtFld: TADTextField;
  i, iFldLen, iFrom, iTo: Integer;
  sBuff: String;
  lEOF, lEOL, lExcLogged, lInDelim: Boolean;
  C: Char;
  oWait: IADGUIxWaitCursor;
  lDestDisconnected, lDestActive, lRetry: Boolean;
  eErrorAction: TADErrorAction;

  function StrAndBoolToInt(const AStr: String): Variant;
  begin
    if ADInSet(AStr[1], ['T', 't', 'Y', 'y']) then
      Result := 1
    else if ADInSet(AStr[1], ['F', 'f', 'N', 'n']) then
      Result := 0
    else if Length(AStr) >= 10 then begin
{$IFDEF AnyDAC_D6Base}
      Result := StrToInt64(AStr);
{$ELSE}
      TVarData(Result).VType := varInt64;
      Decimal(Result).lo64 := StrToInt64(AStr);
{$ENDIF}
    end
    else
      Result := StrToInt(AStr);
  end;

  function StrAndBoolToFloat(const AStr: String; const AFS: TFormatSettings): Extended;
  begin
    if ADInSet(AStr[1], ['T', 't', 'Y', 'y']) then
      Result := 1.0
    else if ADInSet(AStr[1], ['F', 'f', 'N', 'n']) then
      Result := 0.0
    else
      Result := ADStr2Float(AStr, AFS.DecimalSeparator);
  end;

  function CheckDateNotEmpty(const AStr: String): Boolean;
  var
    pCh: PChar;
    oFS: TADTextFormatSettings;
  begin
    pCh := PChar(AStr);
    oFS := TextDataDef.FormatSettings;
    while pCh^ <> #0 do
      if not ((pCh^ = ' ') or (pCh^ = '0') or (pCh^ = oFS.DateSeparator) or (pCh^ = oFS.TimeSeparator)) then
        Break
      else
        Inc(pCh);
    Result := pCh^ <> #0;
  end;

  procedure SetStr(ATxtFld: TADTextField; const AStr: String);
  var
    i: Integer;
    oItem: TADMappingItem;
    S: String;
{$IFNDEF AnyDAC_D7}
    prevShortDateFormat: String;
    prevDateSep: Char;
    prevShortTimeFormat: String;
    prevTimeSep: Char;
{$ENDIF}
  begin
    for i := 0 to Mappings.Count - 1 do begin
      oItem := Mappings[i];
      if oItem.SourceTextField = ATxtFld then begin
        { TODO -cPUMP : Here we should remove format from values }
        S := TrimText(AStr, False);
        if (S = '') and ((oTxtFld.DataType <> atString) or TextDataDef.StrsEmpty2Null) then
          oItem.SourceValue := Null
        else
          try
            case oTxtFld.DataType of
            atOther:
              oItem.SourceValue := S;
            atString:
              oItem.SourceValue := S;
            atFloat:
              oItem.SourceValue := StrAndBoolToFloat(S, TextDataDef.FormatSettings.FFS);
            atNumber:
              oItem.SourceValue := StrAndBoolToInt(S);
            atBool:
              oItem.SourceValue := StrAndBoolToInt(S) <> 0;
            atLongInt:
              oItem.SourceValue := StrAndBoolToInt(S);
            atDate:
              if CheckDateNotEmpty(S) then
{$IFDEF AnyDAC_D7}
                oItem.SourceValue := StrToDate(S, TextDataDef.FormatSettings.FFS)
{$ELSE}
                begin
                  prevShortDateFormat := ShortDateFormat;
                  prevDateSep := DateSeparator;
                  ShortDateFormat := TextDataDef.FormatSettings.ShortDateFormat;
                  DateSeparator := TextDataDef.FormatSettings.DateSeparator;
                  try
                    oItem.SourceValue := StrToDate(S);
                  finally
                    ShortDateFormat := prevShortDateFormat;
                    DateSeparator := prevDateSep;
                  end;
                end
{$ENDIF}
              else
                oItem.SourceValue := Null;
            atTime:
              if CheckDateNotEmpty(S) then
{$IFDEF AnyDAC_D7}
                oItem.SourceValue := StrToTime(S, TextDataDef.FormatSettings.FFS)
{$ELSE}
                begin
                  prevShortTimeFormat := ShortTimeFormat;
                  prevTimeSep := TimeSeparator;
                  ShortTimeFormat := TextDataDef.FormatSettings.ShortTimeFormat;
                  TimeSeparator := TextDataDef.FormatSettings.TimeSeparator;
                  try
                    oItem.SourceValue := StrToTime(S);
                  finally
                    ShortTimeFormat := prevShortTimeFormat;
                    TimeSeparator := prevTimeSep;
                  end;
                end
{$ENDIF}
              else
                oItem.SourceValue := Null;
            atDateTime:
              if CheckDateNotEmpty(S) then
{$IFDEF AnyDAC_D7}
                oItem.SourceValue := StrToDateTime(S, TextDataDef.FormatSettings.FFS)
{$ELSE}
                begin
                  prevShortTimeFormat := ShortTimeFormat;
                  prevTimeSep := TimeSeparator;
                  ShortTimeFormat := TextDataDef.FormatSettings.ShortTimeFormat;
                  TimeSeparator := TextDataDef.FormatSettings.TimeSeparator;
                  prevShortDateFormat := ShortDateFormat;
                  prevDateSep := DateSeparator;
                  ShortDateFormat := TextDataDef.FormatSettings.ShortDateFormat;
                  DateSeparator := TextDataDef.FormatSettings.DateSeparator;
                  try
                    oItem.SourceValue := StrToDateTime(S);
                  finally
                    ShortTimeFormat := prevShortTimeFormat;
                    TimeSeparator := prevTimeSep;
                    ShortDateFormat := prevShortDateFormat;
                    DateSeparator := prevDateSep;
                  end;
                end
{$ENDIF}
              else
                oItem.SourceValue := Null;
            atBlob:
              oItem.SourceValue := ADHex2Bin(S);
            atMemo:
              oItem.SourceValue := S;
            end;
          except
            on E: EConvertError do
              ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPBadTextFmt,
                [AStr, oItem.DisplayName, E.Message]);
          end;
        Break;
      end;
    end;
  end;

begin
  if (TextFileName = '') and (TextStream = nil) then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoTxtDest, []);
  if Destination = nil then
    ADException(Self, [S_AD_LComp, S_AD_LComp_PDM], er_AD_DPNoDestDS, []);

  FReadCount := 0;
  FInsertCount := 0;
  FUpdateCount := 0;
  FDeleteCount := 0;
  FExceptionCount := 0;
  oText := nil;
  oLog := nil;
  lEOF := False;
  FAborting := False;
  lExcLogged := False;
  lDestDisconnected := False;
  oDestConn := nil;
  oWait := nil;
  SetLength(sBuff, 1024);

  DoStatistic(psPreparing);
  if not FAborting then
  try
    if not ADGUIxSilent then begin
      ADCreateInterface(IADGUIxWaitCursor, oWait);
      oWait.StartWait;
    end;
    oLog := InitLogFile;

    try
      oDestConn := Destination.PointedConnection;
      if oDestConn <> nil then begin
        lDestDisconnected := not oDestConn.Connected;
        oDestConn.Connected := True;
        if (CommitCount > 0) and not oDestConn.InTransaction then
          oDestConn.StartTransaction;
      end;
      lDestActive := Destination.Active;
      try

        if TextStream <> nil then
          oText := TADTextFile.Create(TextStream, False, True, False,
            TextFileEncoding, TextDataDef.EndOfLine)
        else
          oText := TADTextFile.Create(TextFileName, True, False,
            TextFileEncoding, TextDataDef.EndOfLine);
        if TextAnalyze <> [] then begin
          GuessTextFormat(oText, TextAnalyze);
          oText.Stream.Position := 0;
        end;
        CreateDestinationDataSet;
        lDestActive := Destination.Active;
        SetupDestination;
        Mappings.Prepare;
        CheckTextSetup;

        if [poClearDest, poClearDestNoUndo] * Options <> [] then
          iAction := paAlwaysInsert
        else if Mode = dmAlwaysInsert then
          iAction := paAlwaysInsert
        else if Mode = dmDelete then
          iAction := paDelete
        else
          iAction := paSkip;

        if [poClearDest, poClearDestNoUndo] * Options <> [] then
          Destination.ServerDeleteAll(poClearDestNoUndo in Options);

        DoStatistic(psStarting);

        if TextDataDef.WithFieldNames then begin
          repeat
            lEOF := not oText.ReadChar(sBuff[1]);
          until lEOF or (sBuff[1] = #13) or (sBuff[1] = #10);
          repeat
            lEOF := not oText.ReadChar(sBuff[1]);
          until lEOF or not ((sBuff[1] = #13) or (sBuff[1] = #10));
          if not lEOF then
            oText.Stream.Position := oText.Stream.Position - 1;
        end;

        while not lEOF and not FAborting do begin
          if oWait <> nil then
            oWait.StartWait;
          try
            lEOL := False;
            for i := 0 to TextDataDef.Fields.Count - 1 do begin
              oTxtFld := TextDataDef.Fields[i];
              iFldLen := 0;

              if not lEOF and not lEOL then
                case TextDataDef.RecordFormat of
                rfFixedLength:
                  begin
                    iFldLen := oTxtFld.FieldSize;
                    if Length(sBuff) < iFldLen then
                      SetLength(sBuff, iFldLen);
                    lEOF := oText.ReadChars(sBuff[1], iFldLen) = 0;
                  end;
                rfFieldPerLine:
                  begin
                    repeat
                      Inc(iFldLen);
                      if iFldLen > Length(sBuff) then
                        SetLength(sBuff, iFldLen + iFldLen div 2);
                      lEOF := not oText.ReadChar(sBuff[iFldLen]);
                    until lEOF or ((sBuff[iFldLen] = #13) or (sBuff[iFldLen] = #10));
                    if not lEOF then begin
                      if (TextDataDef.EndOfLine in [elWindows {$IFDEF MSWINDOWS}, elDefault {$ENDIF}]) and
                         (sBuff[iFldLen] = #13) then
                        lEOF := not oText.ReadChar(sBuff[iFldLen]);
                      Dec(iFldLen);
                    end;
                  end;
                else
                  iFldLen := 0;
                  lInDelim := False;
                  repeat
                    Inc(iFldLen);
                    if iFldLen > Length(sBuff) then
                      SetLength(sBuff, iFldLen + iFldLen div 2);
                    lEOF := not oText.ReadChar(sBuff[iFldLen]);
                    if not lEOF then
                      if sBuff[iFldLen] = TextDataDef.Delimiter then begin
                        C := #0;
                        lEOF := not oText.ReadChar(C);
                        if lEOF or (C <> TextDataDef.Delimiter) then
                          lInDelim := not lInDelim;
                        if not lEOF and (C <> TextDataDef.Delimiter) then
                          oText.Stream.Position := oText.Stream.Position - 1;
                      end;
                    lEOL := not lEOF and not lInDelim and ((sBuff[iFldLen] = #13) or (sBuff[iFldLen] = #10));
                  until lEOF or lEOL or not lInDelim and (sBuff[iFldLen] = TextDataDef.Separator);
                  if not lEOF then
                    Dec(iFldLen);
                end;

              if iFldLen > 0 then begin
                iFrom := 1;
                iTo := iFldLen;
                if (iFrom > 0) and (iFrom <= Length(sBuff)) and (sBuff[iFrom] = TextDataDef.Delimiter) then
                  Inc(iFrom);
                if (iTo > 0) and (iTo <= Length(sBuff)) and (
                     (sBuff[iTo] = TextDataDef.Separator) or (sBuff[iTo] = TextDataDef.Delimiter)) then
                  Dec(iTo);
                SetStr(oTxtFld, Copy(sBuff, iFrom, iTo - iFrom + 1));
              end
              else
                SetStr(oTxtFld, '');
            end;

            Inc(FReadCount);

            if TextDataDef.RecordFormat <> rfFieldPerLine then begin
              repeat
                lEOF := not oText.ReadChar(sBuff[1]);
              until lEOF or not ((sBuff[1] = #13) or (sBuff[1] = #10));
              if not lEOF then
                oText.Stream.Position := oText.Stream.Position - 1;
            end;

            if not (iAction in [paDelete, paAlwaysInsert]) then begin
              iAction := paSkip;
              if FindDestRecord then begin
                if (Mode = dmUpdate) or (Mode = dmAppendUpdate) then
                  iAction := paUpdate;
              end
              else begin
                if (Mode = dmAppend) or (Mode = dmAppendUpdate) then
                  iAction := paInsert;
              end;
            end;

            if (oDestConn <> nil) and (CommitCount > 0) and not oDestConn.InTransaction then
              oDestConn.StartTransaction;

            repeat
              lRetry := False;
              try
                case iAction of
                paInsert, paAlwaysInsert:
                  begin
                    Destination.ServerAppend;
                    Mappings.Move(False);
                    Destination.ServerPerform;
                    Inc(FInsertCount);
                  end;
                paUpdate:
                  begin
                    Destination.ServerEdit;
                    Mappings.Move(False);
                    Destination.ServerPerform;
                    Inc(FUpdateCount);
                  end;
                paDelete:
                  begin
                    Destination.ServerDelete;
                    Mappings.Move(True);
                    Destination.ServerPerform;
                    Inc(FDeleteCount);
                  end;
                end;
              except
                on E: Exception do begin
                  if (oDestConn <> nil) and (CommitCount > 0) and oDestConn.InTransaction then
                    oDestConn.Rollback;
                  lExcLogged := True;
                  ProcessException(E, oLog, eErrorAction);
                  case eErrorAction of
                  eaFail:        lRetry := False;
                  eaSkip:        lRetry := False;
                  eaRetry:       lRetry := True;
                  eaApplied:     lRetry := False;
                  eaExitSuccess: FAborting := True;
                  eaExitFailure: raise;
                  end;
                  lExcLogged := False;
                end;
              end;
            until not lRetry;

            if (oDestConn <> nil) and (CommitCount > 0) and oDestConn.InTransaction then
              if WriteCount mod CommitCount = 0 then
                oDestConn.Commit;

            if StatisticsInterval > 0 then
              if FReadCount mod StatisticsInterval = 0 then
                DoStatistic(psProgress);

          finally
            if oWait <> nil then
              oWait.StopWait;
          end;
        end;

        DoStatistic(psFinishing);
        if not IsDestMemTable then
          Destination.Disconnect;

      finally
        Destination.Active := lDestActive;
        Destination.EnableControls;
      end;

      if (oDestConn <> nil) and (CommitCount > 0) and oDestConn.InTransaction then
        oDestConn.Commit;

    except
      on E: Exception do begin
        if (oDestConn <> nil) and oDestConn.InTransaction then
          oDestConn.Rollback;
        if not lExcLogged then
          ProcessException(E, oLog, eErrorAction);
        if eErrorAction = eaExitFailure then
          raise;
      end;
    end;

  finally
    if (oDestConn <> nil) and lDestDisconnected then
      oDestConn.Connected := False;
    Mappings.Unprepare;
    if oText <> nil then
      ADFree(oText);
    DeleteExceptionFile(oLog);
    if oWait <> nil then
      oWait.StopWait;
  end;
  DoStatistic(psUnpreparing);
  Result := WriteCount;
end;

end.
