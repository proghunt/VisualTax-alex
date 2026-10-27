{*******************************************************}
{                                                       }
{               Delphi FireDAC Framework                }
{           FireDAC db parameters and macros            }
{                                                       }
{ Copyright(c) 2004-2013 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}
{$I uAD.inc}

{ TODO -cNEXTGEN : Replace TADEncoder.Enco / Deco with FEncoder }

unit uADStanParam;

interface

uses
  Classes, DB,
{$IFDEF AnyDAC_D6Base}
  Variants, FmtBcd,
  {$IFDEF AnyDAC_D6}
  SqlTimSt,
  {$ENDIF}
{$ENDIF}
  uADStanIntf, uADStanSQLTimeInt, uADStanUtil;

type
  TADMacro = class;
  TADMacros = class;
  TADParam = class;
  TADParams = class;

  TADGetOwner = function: TPersistent of object;

  TADMacroDataType = (mdUnknown, mdString, mdIdentifier, mdInteger,
    mdBoolean, mdFloat, mdDate, mdTime, mdDateTime, mdRaw);

  TADMacro = class(TCollectionItem)
  private
    FName: String;
    FValue: Variant;
    FDataType: TADMacroDataType;
    procedure SetValue(const AValue: Variant);
    function GetAsDateTime: TDateTime;
    function GetAsInteger: Integer;
    function GetAsString: String;
    function GetSQL: String;
    procedure SetAsDateTime(const AValue: TDateTime);
    procedure SetAsInteger(const AValue: Integer);
    procedure SetAsString(const AValue: String);
    function GetIsNull: Boolean;
    function GetAsFloat: Double;
    procedure SetAsFloat(const AValue: Double);
    function GetAsDate: TDateTime;
    procedure SetAsDate(const AValue: TDateTime);
    procedure SetDataType(const AValue: TADMacroDataType);
    procedure SetData(const AValue: Variant; AType: TADMacroDataType);
    procedure Changed;
    procedure SetAsIdentifier(const AValue: String);
    function GetAsTime: TDateTime;
    procedure SetAsTime(const AValue: TDateTime);
    function GetAsRaw: String;
    procedure SetAsRaw(const AValue: String);
  protected
    function GetDisplayName: String; override;
    function GetCollectionOwner: TPersistent;
  public
    constructor Create(Collection: TCollection); override;
    procedure Clear;
    procedure Assign(AValue: TPersistent); override;
    function IsEqual(AValue: TADMacro): Boolean;
    property CollectionOwner: TPersistent read GetCollectionOwner;
    property AsString: String read GetAsString write SetAsString;
    property AsIdentifier: String read GetAsString write SetAsIdentifier;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsDate: TDateTime read GetAsDate write SetAsDate;
    property AsTime: TDateTime read GetAsTime write SetAsTime;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsRaw: String read GetAsRaw write SetAsRaw;
    property IsNull: Boolean read GetIsNull;
    property SQL: String read GetSQL;
  published
    property Value: Variant read FValue write SetValue;
    property Name: String read FName write FName;
    property DataType: TADMacroDataType read FDataType write SetDataType default mdRaw;
  end;

  TADMacros = class(TCollection)
  private
    FGetOwner: TADGetOwner;
    FOnChanged: TNotifyEvent;
    FRefs: TADRefCounter;
    FTempLockUpdate: Boolean;
    function GetDataSet: TDataSet;
    function GetItem(AIndex: Integer): TADMacro; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    procedure SetItem(AIndex: Integer; AValue: TADMacro);
    procedure DoChanged;
    function GetIsRefCounted: Boolean;
  protected
    function GetOwner: TPersistent; override;
    procedure AssignTo(ADest: TPersistent); override;
  public
    constructor Create; overload;
    constructor CreateRefCounted(AGetOwner: TADGetOwner);
    destructor Destroy; override;
    procedure AddRef;
    procedure RemRef;
    procedure Assign(AValue: TPersistent); override;
    procedure EndUpdate; override;
    procedure TempLockUpdate;
    procedure AssignValues(AValue: TADMacros);
    function Add: TADMacro;
    function IsEqual(AValue: TADMacros): Boolean;
    function MacroByName(const AValue: String): TADMacro;
    function FindMacro(const AValue: String): TADMacro;
    property IsRefCounted: Boolean read GetIsRefCounted;
    property Command: TDataSet read GetDataSet;
    property Items[AIndex: Integer]: TADMacro read GetItem write SetItem; default;
    property UpdateCount;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnGetOwner: TADGetOwner read FGetOwner write FGetOwner;
  end;

  TADParamArrayType = (atScalar, atArray, atPLSQLTable);
  TADParamBindMode = (pbByName, pbByNumber);

  TADParam = class(TCollectionItem)
  private
    FName: String;
    FDataType: TFieldType;
    FADDataType: TADDataType;
    FParamType: TParamType;
    FSize: Integer;
    FPrecision: Integer;
    FNumericScale: Integer;
    FBound: Boolean;
    FPosition: Integer;
    FIsCaseSensitive: Boolean;
    FArrayType: TADParamArrayType;
    FValue: TADVariantArray;
    procedure InternalSetValue(AIndex: Integer; const AValue: Variant);
    function GetDataSet: TDataSet;
    function IsParamStored: Boolean;
    function GetAsBCDs(AIndex: Integer): Currency;
    function GetAsBooleans(AIndex: Integer): Boolean;
    function GetAsByteStrs(AIndex: Integer): TADByteString;
    function GetAsCurrencys(AIndex: Integer): Currency;
    function GetAsDateTimes(AIndex: Integer): TDateTime;
    function GetAsFloats(AIndex: Integer): Double;
    function GetAsFMTBCDs(AIndex: Integer): TADBcd;
    function GetAsIntegers(AIndex: Integer): LongInt;
    function GetAsSQLTimeStamps(AIndex: Integer): TADSQLTimeStamp;
    function GetAsStrings(AIndex: Integer): String;
    function GetAsVariants(AIndex: Integer): Variant;
    function GetIsNulls(AIndex: Integer): Boolean;
    function GetAsWideStrings(AIndex: Integer): TADWideString;
    procedure SetAsBCDs(AIndex: Integer; const AValue: Currency);
    procedure SetAsBlobs(AIndex: Integer; const AValue: TADByteString);
    procedure SetAsBooleans(AIndex: Integer; const AValue: Boolean);
    procedure SetAsByteStrs(AIndex: Integer; const AValue: TADByteString);
    procedure SetAsVarByteStrs(AIndex: Integer; const AValue: TADByteString);
    procedure SetAsCurrencys(AIndex: Integer; const AValue: Currency);
    procedure SetAsDates(AIndex: Integer; const AValue: TDateTime);
    procedure SetAsDateTimes(AIndex: Integer; const AValue: TDateTime);
    procedure SetAsFloats(AIndex: Integer; const AValue: Double);
    procedure SetAsFMTBCDs(AIndex: Integer; const AValue: TADBcd);
    procedure SetAsIntegers(AIndex: Integer; const AValue: LongInt);
    procedure SetAsMemos(AIndex: Integer; const AValue: TADAnsiString);
    procedure SetAsSmallInts(AIndex: Integer; const AValue: LongInt);
    procedure SetAsSQLTimeStamps(AIndex: Integer; const AValue: TADSQLTimeStamp);
    procedure SetAsStrings(AIndex: Integer; const AValue: String);
    procedure SetAsTimes(AIndex: Integer; const AValue: TDateTime);
    procedure SetAsVariants(AIndex: Integer; const AValue: Variant);
    procedure SetAsWords(AIndex: Integer; AValue: LongWord);
    procedure SetBytesValue(AIndex: Integer; ABuff: PADByteString; ASize: LongWord);
    procedure GetBytesValue(AIndex: Integer; ABuff: PADByteString);
    procedure SetTexts(AIndex: Integer; const AValue: String);
    procedure SetAsWideStrings(AIndex: Integer; const AValue: TADWideString);
    procedure ErrIndex(AIndex: Integer);
    procedure CheckIndex(var AIndex: Integer);
    function GetArraySize: Integer;
    procedure SetArraySize(AValue: Integer);
    procedure SetArrayType(AValue: TADParamArrayType);
    procedure UpdateData(ADim: Integer);
    function GetAsLargeInt: LargeInt;
    function GetAsLargeInts(AIndex: Integer): LargeInt;
    procedure SetAsLargeInt(const AValue: LargeInt);
    procedure SetAsLargeInts(AIndex: Integer; const AValue: LargeInt);
    procedure GetVarData(out AVar: PVariant; AIndex: Integer = -1);
    procedure ErrBadFieldType;
    procedure ErrUnknownFieldType;
    function GetAsGUID: TGUID;
    function GetAsGUIDs(AIndex: Integer): TGUID;
    procedure SetAsGUID(const AValue: TGUID);
    procedure SetAsGUIDs(AIndex: Integer; const AValue: TGUID);
    procedure SetAsWideMemo(const AValue: TADWideString);
    procedure SetAsWideMemos(AIndex: Integer; const AValue: TADWideString);
    procedure SetAsFixedChar(const AValue: String);
    procedure SetAsFixedChars(AIndex: Integer; const AValue: String);
    function GetAsAnsiString: TADAnsiString;
    function GetAsAnsiStrings(AIndex: Integer): TADAnsiString;
    function GetAsExtended: Extended;
    function GetAsExtendeds(AIndex: Integer): Extended;
    function GetAsLongWord: LongWord;
    function GetAsLongWords(AIndex: Integer): LongWord;
    procedure SetAsAnsiString(const AValue: TADAnsiString);
    procedure SetAsAnsiStrings(AIndex: Integer; const AValue: TADAnsiString);
    procedure SetAsByte(const AValue: LongWord);
    procedure SetAsBytes(AIndex: Integer; const AValue: LongWord);
    procedure SetAsExtended(const AValue: Extended);
    procedure SetAsExtendeds(AIndex: Integer; const AValue: Extended);
    procedure SetAsLongWord(const AValue: LongWord);
    procedure SetAsLongWords(AIndex: Integer; const AValue: LongWord);
    procedure SetAsShortInt(const AValue: LongInt);
    procedure SetAsShortInts(AIndex: Integer; const AValue: LongInt);
    function GetAsFMTBCD: TADBcd;
    function GetAsBCD: Currency;
    function GetAsBoolean: Boolean;
    function GetAsByteStr: TADByteString;
    function GetAsDateTime: TDateTime;
    function GetAsSQLTimeStamp: TADSQLTimeStamp;
    function GetAsCurrency: Currency;
    function GetAsFloat: Double;
    function GetAsInteger: Longint;
    function GetAsString: String;
    function GetAsWideString: TADWideString;
    function GetAsVariant: Variant;
    function GetIsNull: Boolean;
    procedure SetAsBCD(const AValue: Currency);
    procedure SetAsFMTBCD(const AValue: TADBcd);
    procedure SetAsBlob(const AValue: TADByteString);
    procedure SetAsByteStr(const AValue: TADByteString);
    procedure SetAsVarByteStr(const AValue: TADByteString);
    procedure SetAsBoolean(const AValue: Boolean);
    procedure SetAsCurrency(const AValue: Currency);
    procedure SetAsDate(const AValue: TDateTime);
    procedure SetAsDateTime(const AValue: TDateTime);
    procedure SetAsSQLTimeStamp(const AValue: TADSQLTimeStamp);
    procedure SetAsFloat(const AValue: Double);
    procedure SetAsInteger(const AValue: Longint);
    procedure SetAsMemo(const AValue: TADAnsiString);
    procedure SetAsString(const AValue: String);
    procedure SetAsWideString(const AValue: TADWideString);
    procedure SetAsSmallInt(const AValue: LongInt);
    procedure SetAsTime(const AValue: TDateTime);
    procedure SetAsVariant(const AValue: Variant);
    procedure SetAsWord(const AValue: LongWord);
    procedure SetDataType(AValue: TFieldType);
    procedure SetText(const AValue: String);
    function GetAsSQLTimeInterval: TADSQLTimeInterval;
    function GetAsSQLTimeIntervals(AIndex: Integer): TADSQLTimeInterval;
    procedure SetAsSQLTimeInterval(const AValue: TADSQLTimeInterval);
    procedure SetAsSQLTimeIntervals(AIndex: Integer; const AValue: TADSQLTimeInterval);
    procedure SetAsXML(const AValue: TADWideString);
    procedure SetAsXMLs(AIndex: Integer; const AValue: TADWideString);
    function GetAsSingle: Single;
    function GetAsSingles(AIndex: Integer): Single;
    procedure SetAsSingle(const AValue: Single);
    procedure SetAsSingles(AIndex: Integer; const AValue: Single);
    function GetSQLName: String;
    procedure BeginSetBlobRawData(var AIndex: Integer);
    function EndSetBlobRawData(ALen: LongWord; APtr: PADByteString;
      AIndex: Integer): PADByteString;
  protected
    procedure AssignParam(AParam: TADParam);
    procedure AssignDlpParam(AParam: TParam);
    procedure AssignToDlpParam(AParam: TParam);
    procedure AssignTo(ADest: TPersistent); override;
    function IsEqual(AValue: TADParam): Boolean;
    function GetDisplayName: String; override;
    property DataSet: TDataSet read GetDataSet;
  public
    constructor Create(Collection: TCollection); overload; override;
    constructor Create(AParams: TADParams; AParamType: TParamType); reintroduce; overload;

    // value manipulations
    procedure Assign(ASource: TPersistent); override;
    procedure AssignField(AField: TField);
    procedure AssignFieldValue(AField: TField; const AValue: Variant); overload;
    procedure AssignFieldValue(AField: TField); overload;
    procedure Clear(AIndex: Integer = -1);
    procedure AssignVarRec(const AVarRec: TVarRec; AIndex: Integer = -1);

    // raw data methods
    function GetBlobRawData(var ALen: LongWord; var APtr: PADByteString; AIndex: Integer = -1): Boolean;
    function SetBlobRawData(ALen: LongWord; APtr: PADByteString; AIndex: Integer = -1): PADByteString;
    procedure GetData(ABuffer: PADByteString; AIndex: Integer = -1);
    procedure SetData(ABuffer: PADByteString; ALen: LongWord = $FFFFFFFF; AIndex: Integer = -1);
    function GetDataLength(AIndex: Integer = -1): Integer;
    function GetDataSize(AIndex: Integer = -1): Integer;
    procedure LoadFromFile(const FileName: String; BlobType: TBlobType; AIndex: Integer = -1);
    procedure LoadFromStream(Stream: TStream; BlobType: TBlobType; AIndex: Integer = -1);

    // value properties
    property AsSingle: Single read GetAsSingle write SetAsSingle;
    property AsFloat: Double read GetAsFloat write SetAsFloat;
    property AsExtended: Extended read GetAsExtended write SetAsExtended;
    property AsCurrency: Currency read GetAsCurrency write SetAsCurrency;
    property AsBCD: Currency read GetAsBCD write SetAsBCD;
    property AsFMTBCD: TADBcd read GetAsFMTBCD write SetAsFMTBCD;

    property AsShortInt: LongInt read GetAsInteger write SetAsShortInt;
    property AsByte: LongWord read GetAsLongWord write SetAsByte;
    property AsSmallInt: LongInt read GetAsInteger write SetAsSmallInt;
    property AsWord: LongWord read GetAsLongWord write SetAsWord;
    property AsInteger: LongInt read GetAsInteger write SetAsInteger;
    property AsLongword: LongWord read GetAsLongWord write SetAsLongWord;
    property AsLargeInt: LargeInt read GetAsLargeInt write SetAsLargeInt;

    property AsBoolean: Boolean read GetAsBoolean write SetAsBoolean;

    property AsByteStr: TADByteString read GetAsByteStr write SetAsByteStr;
    property AsVarByteStr: TADByteString read GetAsByteStr write SetAsVarByteStr;
    property AsString: String read GetAsString write SetAsString;
    property AsFixedChar: String read GetAsString write SetAsFixedChar;
    property AsWideString: TADWideString read GetAsWideString write SetAsWideString;
    property AsAnsiString: TADAnsiString read GetAsAnsiString write SetAsAnsiString;

    property AsBlob: TADByteString read GetAsByteStr write SetAsBlob;
    property AsMemo: TADAnsiString read GetAsAnsiString write SetAsMemo;
    property AsWideMemo: TADWideString read GetAsWideString write SetAsWideMemo;
    property AsXML: TADWideString read GetAsWideString write SetAsXML;

    property AsDate: TDateTime read GetAsDateTime write SetAsDate;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsSQLTimeStamp: TADSQLTimeStamp read GetAsSQLTimeStamp write SetAsSQLTimeStamp;
    property AsTime: TDateTime read GetAsDateTime write SetAsTime;
    property AsSQLTimeInterval: TADSQLTimeInterval read GetAsSQLTimeInterval write SetAsSQLTimeInterval;

    property AsGUID: TGUID read GetAsGUID write SetAsGUID;

    // array value properties
    property AsSingles[AIndex: Integer]: Single read GetAsSingles write SetAsSingles;
    property AsFloats[AIndex: Integer]: Double read GetAsFloats write SetAsFloats;
    property AsExtendeds[AIndex: Integer]: Extended read GetAsExtendeds write SetAsExtendeds;
    property AsCurrencys[AIndex: Integer]: Currency read GetAsCurrencys write SetAsCurrencys;
    property AsBCDs[AIndex: Integer]: Currency read GetAsBCDs write SetAsBCDs;
    property AsFMTBCDs[AIndex: Integer]: TADBcd read GetAsFMTBCDs write SetAsFMTBCDs;

    property AsShortInts[AIndex: Integer]: LongInt read GetAsIntegers write SetAsShortInts;
    property AsBytes[AIndex: Integer]: LongWord read GetAsLongWords write SetAsBytes;
    property AsSmallInts[AIndex: Integer]: LongInt read GetAsIntegers write SetAsSmallInts;
    property AsWords[AIndex: Integer]: LongWord read GetAsLongWords write SetAsWords;
    property AsIntegers[AIndex: Integer]: LongInt read GetAsIntegers write SetAsIntegers;
    property AsLongwords[AIndex: Integer]: LongWord read GetAsLongWords write SetAsLongWords;
    property AsLargeInts[AIndex: Integer]: LargeInt read GetAsLargeInts write SetAsLargeInts;

    property AsBooleans[AIndex: Integer]: Boolean read GetAsBooleans write SetAsBooleans;

    property AsByteStrs[AIndex: Integer]: TADByteString read GetAsByteStrs write SetAsByteStrs;
    property AsVarByteStrs[AIndex: Integer]: TADByteString read GetAsByteStrs write SetAsVarByteStrs;
    property AsStrings[AIndex: Integer]: String read GetAsStrings write SetAsStrings;
    property AsFixedChars[AIndex: Integer]: String read GetAsStrings write SetAsFixedChars;
    property AsWideStrings[AIndex: Integer]: TADWideString read GetAsWideStrings write SetAsWideStrings;
    property AsAnsiStrings[AIndex: Integer]: TADAnsiString read GetAsAnsiStrings write SetAsAnsiStrings;

    property AsBlobs[AIndex: Integer]: TADByteString read GetAsByteStrs write SetAsBlobs;
    property AsMemos[AIndex: Integer]: TADAnsiString read GetAsAnsiStrings write SetAsMemos;
    property AsWideMemos[AIndex: Integer]: TADWideString read GetAsWideStrings write SetAsWideMemos;
    property AsXMLs[AIndex: Integer]: TADWideString read GetAsWideStrings write SetAsXMLs;

    property AsDates[AIndex: Integer]: TDateTime read GetAsDateTimes write SetAsDates;
    property AsDateTimes[AIndex: Integer]: TDateTime read GetAsDateTimes write SetAsDateTimes;
    property AsSQLTimeStamps[AIndex: Integer]: TADSQLTimeStamp read GetAsSQLTimeStamps write SetAsSQLTimeStamps;
    property AsTimes[AIndex: Integer]: TDateTime read GetAsDateTimes write SetAsTimes;
    property AsSQLTimeIntervals[AIndex: Integer]: TADSQLTimeInterval read GetAsSQLTimeIntervals write SetAsSQLTimeIntervals;

    property AsGUIDs[AIndex: Integer]: TGUID read GetAsGUIDs write SetAsGUIDs;

    property Values[AIndex: Integer]: Variant read GetAsVariants write SetAsVariants;
    property IsNulls[AIndex: Integer]: Boolean read GetIsNulls;

    // attributes
    property SQLName: String read GetSQLName;
    property Bound: Boolean read FBound write FBound;
    property IsNull: Boolean read GetIsNull;
    property Text: String read GetAsString write SetText;
    property Texts[AIndex: Integer]: String read GetAsStrings write SetTexts;

  published
    property Position: Integer read FPosition write FPosition default 0;
    property Name: String read FName write FName;
    property IsCaseSensitive: Boolean read FIsCaseSensitive write FIsCaseSensitive default False;
    property ArrayType: TADParamArrayType read FArrayType write SetArrayType default atScalar;
    property ArraySize: Integer read GetArraySize write SetArraySize default 1;
    property DataType: TFieldType read FDataType write SetDataType default ftUnknown;
    property ADDataType: TADDataType read FADDataType write FADDataType default dtUnknown;
    property Precision: Integer read FPrecision write FPrecision default 0;
    property NumericScale: Integer read FNumericScale write FNumericScale default 0;
    property ParamType: TParamType read FParamType write FParamType default ptUnknown;
    property Size: Integer read FSize write FSize default 0;
    property Value: Variant read GetAsVariant write SetAsVariant stored IsParamStored;
  end;

  TADParams = class(TCollection)
  private
    FGetOwner: TADGetOwner;
    FBindMode: TADParamBindMode;
    FRefs: TADRefCounter;
    FMarkers: TStrings;
    function GetItem(Index: Integer): TADParam; {$IFDEF AnyDAC_D9} inline; {$ENDIF}
    procedure SetItem(Index: Integer; const AValue: TADParam);
    function GetArraySize: Integer;
    procedure SetArraySize(const AValue: Integer);
    function GetParamValues(const AParamName: TADWideString): Variant;
    procedure SetParamValues(const AParamName: TADWideString; const AValue: Variant);
    function GetIsRefCounted: Boolean;
    procedure ReadBinaryData(Stream: TStream);
    procedure SetMarkers(const AValue: TStrings);
  protected
    function GetDataSet: TDataSet;
    function GetOwner: TPersistent; override;
    procedure DefineProperties(Filer: TFiler); override;
    property DataSet: TDataSet read GetDataSet;
  public
    constructor Create; overload;
    constructor CreateRefCounted(AGetOwner: TADGetOwner); overload;
    destructor Destroy; override;
    procedure AddRef;
    procedure RemRef;
    procedure AssignValues(AValue: TADParams;
      AParamTypes: TParamTypes = [ptUnknown .. ptResult]);
    procedure Prepare(ADefaultDataType: TFieldType;
      ADefaultParamType: TParamType);
    procedure Assign(AValue: TPersistent); override;
    function Add: TADParam; overload;
    function Add(const AName: String; const AValue: Variant;
      AParamType: TParamType = ptUnknown): TADParam; overload;
    function Add(const AName: String; AType: TFieldType; ASize: Integer = -1;
      AParamType: TParamType = ptUnknown): TADParam; overload;
    function CreateParam(AFldType: TFieldType; const AParamName: String;
      AParamType: TParamType): TADParam;
    procedure GetParamList(AList: TADObjList; const AParamNames: String);
    function IsEqual(AValue: TADParams): Boolean;
    function ParamByName(const AValue: String): TADParam;
    function FindParam(const AValue: String): TADParam; overload;
    function ParamByPosition(const AValue: Integer): TADParam;
    function FindParam(const AValue: Integer): TADParam; overload;
    procedure ClearValues(AIndex: Integer = -1);
    property IsRefCounted: Boolean read GetIsRefCounted;
    property Items[Index: Integer]: TADParam read GetItem write SetItem; default;
    property ParamValues[const AParamName: TADWideString]: Variant read GetParamValues write SetParamValues;
    property ArraySize: Integer read GetArraySize write SetArraySize;
    property BindMode: TADParamBindMode read FBindMode write FBindMode;
    property Markers: TStrings read FMarkers write SetMarkers;
    property OnGetOwner: TADGetOwner read FGetOwner write FGetOwner;
  end;

function ADVarType2FieldType(const AValue: Variant): TADMacroDataType;
function ADVar2SQLTyped(const AValue: Variant; AFieldType: TADMacroDataType): String;
function ADVar2SQL(const AValue: Variant): String;

var
  C_FieldType2VarType: array[TFieldType] of Integer = (
    varError, varString, varSmallint, varInteger, varSmallint,
    varBoolean, varDouble, varCurrency, varCurrency, varDate, varDate, varDate,
    varString, varString, varInteger, varString, varString, varString, varOleStr,
    varError, varError, varString, varError, varString, varOleStr,
    varInt64, varError, varError, varError, varError, varString, varString,
    varVariant, varUnknown, varDispatch, varString
{$IFDEF AnyDAC_D6Base}
    , varDate, varCurrency
{$ENDIF}
{$IFDEF AnyDAC_FPC}
    , varOleStr, varOleStr
{$ENDIF}
{$IFDEF AnyDAC_D10}
    , varOleStr, varOleStr, varDate, varString
{$ENDIF}
{$IFDEF AnyDAC_D12}
    , varLongWord, varShortInt, varByte, varDouble, varError, varError, varError
{$ENDIF}
{$IFDEF AnyDAC_D14}
    , varString, varError, varSingle
{$ENDIF}
    );

const    
  C_MacroDataType2VarType: array[TADMacroDataType] of Integer = (
    varError, varADString, varADString, varInteger, varBoolean, varDouble, varDate,
    varDate, varDate, varADString);

  C_ParamTypeNames: array [TParamType] of string =
    ('ptUnknown', 'ptInput', 'ptOutput', 'ptInputOutput', 'ptResult');

  C_ADDataAttributeNames: array[TADDataAttribute] of string =
    ('Searchable', 'AllowNull', 'FixedLen', 'BlobData', 'ReadOnly', 'AutoInc',
     'ROWID', 'Default', 'RowVersion', 'Internal', 'Calculated', 'Volatile',
     'Unnamed', 'Virtual', 'Base', 'Expression');

  C_ADDataOptionNames: array[TADDataOption] of string =
    ('AllowNull', 'Unique', 'ReadOnly', 'InUpdate',
     'InWhere', 'InKey', 'AfterInsChanged', 'AfterUpdChanged');

  C_ADParamArrayTypeNames: array[TADParamArrayType] of string =
    ('atScalar', 'atArray', 'atPLSQLTable');

  C_MacroTypeNames: array [TADMacroDataType] of string =
    ('mdUnknown', 'mdString', 'mdIdentifier', 'mdInteger',
     'mdBoolean', 'mdFloat', 'mdDate', 'mdTime', 'mdDateTime', 'mdRaw');

implementation

uses
{$IFDEF AnyDAC_D6Base}
  {$IFDEF AnyDAC_D6}
  VarUtils,
  {$ENDIF}
{$ELSE}
  ActiveX, ComObj,
{$ENDIF}
  SysUtils,
{$IFNDEF AnyDAC_FPC}
  DBConsts,
{$ELSE}
  dbconst,
{$ENDIF}
  uADStanError, uADStanConst;

{$IFDEF AnyDAC_FPC}
const
  SBadFieldType = 'Field ''%s'' is of an unsupported type';
  SFieldOutOfRange = 'Value of field ''%s'' is out of range';
  SInvalidVersion = 'Invalid params stream data version';
{$ENDIF}

{ ---------------------------------------------------------------------------- }
function ADVarType2FieldType(const AValue: Variant): TADMacroDataType;
begin
  case VarType(AValue) of
  varEmpty,
  varNull     : Result := mdUnknown;
  varByte,
{$IFDEF AnyDAC_D6Base}
  varShortInt,
  varWord,
{$ENDIF}
  varSmallint,
{$IFDEF AnyDAC_D6Base}
  varLongWord,
{$ENDIF}
  varInteger,
{$IFDEF AnyDAC_D12}
  varUInt64,
{$ENDIF}
  varInt64    : Result := mdInteger;
  varSingle,
  varDouble,
  varCurrency : Result := mdFloat;
  varDate     : Result := mdDateTime;
{$IFDEF AnyDAC_D12}
  varUString,
{$ENDIF}
  varByte or varArray,
  varString,
  varOleStr   : Result := mdString;
  varBoolean  : Result := mdBoolean;
  else
{$IFDEF AnyDAC_D6Base}
  {$IFDEF AnyDAC_D6}
    if VarIsSQLTimeStamp(AValue) then
      Result := mdDateTime
    else
  {$ENDIF}
    if VarIsFMTBcd(AValue) then
      Result := mdFloat
    else
{$ENDIF}    
      Result := mdUnknown;
  end;
end;

{ ---------------------------------------------------------------------------- }
function ADVar2SQLTyped(const AValue: Variant; AFieldType: TADMacroDataType): String;
var
  l: Boolean;
  dt: TDateTime;
{$IFDEF AnyDAC_D7}
  rFS: TFormatSettings;
{$ELSE}
  cPrevDateSep: Char;
  cPrevTimeSep: Char;
{$ENDIF}
begin
  Result := '';
  if (VarType(AValue) and varTypeMask) in [varEmpty, varNull] then begin
    if not (AFieldType in [mdRaw, mdIdentifier]) then
      Result := 'NULL';
  end
  else begin
    case AFieldType of
    mdRaw:
      Result := AValue;
    mdInteger:
{$IFDEF AnyDAC_FPC}
      // FPC fails to cast TBcd variant to Integer
      if VarIsFmtBCD(AValue) then
        Result := IntToStr(Trunc(BCDToDouble(VarToBCD(AValue))))
      else
{$ENDIF}
        Result := VarAsType(AValue, varInteger);
    mdFloat:
      Result := '{e ' + ADFloat2Str(VarAsType(AValue, varDouble), '.', 15) + '}';
    mdDate:
      begin
        dt := VarAsType(AValue, varDate);
{$IFDEF AnyDAC_D7}
        rFS.DateSeparator := '-';
        Result := FormatDateTime('yyyy/mm/dd', dt, rFS);
{$ELSE}
        cPrevDateSep := DateSeparator;
        DateSeparator := '-';
        try
          Result := FormatDateTime('yyyy/mm/dd', dt);
        finally
          DateSeparator := cPrevDateSep;
        end;
{$ENDIF}
        Result := '{d ''' + Result + '''}';
      end;
    mdTime:
      begin
        dt := VarAsType(AValue, varDate);
{$IFDEF AnyDAC_D7}
        rFS.TimeSeparator := ':';
        Result := FormatDateTime('hh:nn:ss', dt);
{$ELSE}
        cPrevTimeSep := TimeSeparator;
        TimeSeparator := '-';
        try
          Result := FormatDateTime('hh:nn:ss', dt);
        finally
          TimeSeparator := cPrevTimeSep;
        end;
{$ENDIF}
        Result := '{t ''' + Result + '''}';
      end;
    mdDateTime:
      begin
        dt := VarAsType(AValue, varDate);
{$IFDEF AnyDAC_D7}
        rFS.DateSeparator := '-';
        rFS.TimeSeparator := ':';
        Result := FormatDateTime('yyyy/mm/dd hh:nn:ss', dt, rFS);
{$ELSE}
        cPrevTimeSep := TimeSeparator;
        cPrevDateSep := DateSeparator;
        DateSeparator := '-';
        TimeSeparator := ':';
        try
          Result := FormatDateTime('yyyy/mm/dd hh:nn:ss', dt);
        finally
          TimeSeparator := cPrevTimeSep;
          DateSeparator := cPrevDateSep;
        end;
{$ENDIF}
        Result := '{dt ''' + Result + '''}';
      end;
    mdUnknown,
    mdString:
      Result := '{s ''' + VarAsType(AValue, varADWString) + '''}';
    mdIdentifier:
      Result := '{id ''' + VarAsType(AValue, varADWString) + '''}';
    mdBoolean:
      begin
        l := VarAsType(AValue, varBoolean);
        if l then
          Result := '{l True}'
        else
          Result := '{l False}';
      end;
    end;
  end;
end;

{ ---------------------------------------------------------------------------- }
function ADVar2SQL(const AValue: Variant): String;
begin
  Result := ADVar2SQLTyped(AValue, ADVarType2FieldType(AValue));
end;

{ ---------------------------------------------------------------------------- }
{$IFNDEF AnyDAC_D6Base}
function FindVarData(const AVariant): PVarData;
begin
  Result := @TVarData(AVariant);
  while Result.VType = varByRef or varVariant do
    Result := PVarData(Result.VPointer);
end;
{$ENDIF}

{ ---------------------------------------------------------------------------- }
{ TADMacro                                                                     }
{ ---------------------------------------------------------------------------- }
constructor TADMacro.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FValue := Null;
  FDataType := mdRaw;
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetSQL: String;
begin
  Result := ADVar2SQLTyped(FValue, DataType);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetDisplayName: String;
begin
  if Name <> '' then
    Result := Name
  else
    Result := inherited GetDisplayName;
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetCollectionOwner: TPersistent;
begin
  if not Assigned(Collection) then
    Result := nil
  else
    Result := TADMacros(Collection).GetOwner;
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.IsEqual(AValue: TADMacro): Boolean;
begin
  Result := (Name = AValue.Name) and (DataType = AValue.DataType);
  if Result then
    try
      Result := Value = AValue.Value;
    except
      Result := False;
    end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.Assign(AValue: TPersistent);
begin
  if AValue is TADMacro then
    try
      if Collection <> nil then
        Collection.BeginUpdate;
      FDataType := TADMacro(AValue).DataType;
      FName := TADMacro(AValue).Name;
      FValue := TADMacro(AValue).Value;
    finally
      if Collection <> nil then
        Collection.EndUpdate;
    end
  else
    inherited Assign(AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.Changed;
begin
  TADMacros(Collection).DoChanged;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetDataType(const AValue: TADMacroDataType);
begin
  if FDataType <> AValue then begin
    FDataType := AValue;
    Changed;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetData(const AValue: Variant; AType: TADMacroDataType);
var
  lEQ: Boolean;
begin
  try
    lEQ := Value = AValue;
  except
    lEQ := False;
  end;
  if not lEQ then begin
    FValue := AValue;
    if AType <> mdUnknown then
      FDataType := AType
    else
      if FDataType = mdUnknown then
        FDataType := ADVarType2FieldType(AValue);
    Changed;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetIsNull: Boolean;
var
  pData: PVarData;
begin
  pData := FindVarData(FValue);
  Result := (pData^.VType = varNull) or (pData^.VType = varEmpty);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.Clear;
begin
  SetData(Null, mdUnknown);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetValue(const AValue: Variant);
begin
  SetData(AValue, mdUnknown);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsString: String;
begin
  if IsNull then
    Result := ''
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsString(const AValue: String);
begin
  SetData(AValue, mdString);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsIdentifier(const AValue: String);
begin
  SetData(AValue, mdIdentifier);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsInteger: Integer;
begin
  if IsNull then
    Result := 0
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsInteger(const AValue: Integer);
begin
  SetData(AValue, mdInteger);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsDateTime: TDateTime;
begin
  if IsNull then
    Result := 0.0
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsDateTime(const AValue: TDateTime);
begin
  SetData(AValue, mdDateTime);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsFloat: Double;
begin
  if IsNull then
    Result := 0.0
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsFloat(const AValue: Double);
begin
  SetData(AValue, mdFloat);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsDate: TDateTime;
begin
  if IsNull then
    Result := 0.0
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsDate(const AValue: TDateTime);
var
  dt: TDateTime;
begin
  dt := Trunc(AValue);
  SetData(dt, mdDate);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsTime: TDateTime;
begin
  if IsNull then
    Result := 0.0
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsTime(const AValue: TDateTime);
var
  dt: TDateTime;
begin
  dt := AValue - Trunc(AValue);
  SetData(dt, mdTime);
end;

{ ---------------------------------------------------------------------------- }
function TADMacro.GetAsRaw: String;
begin
  if IsNull then
    Result := ''
  else
    Result := FValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacro.SetAsRaw(const AValue: String);
begin
  SetData(AValue, mdRaw);
end;

{ ---------------------------------------------------------------------------- }
{ TADMacros                                                                    }
{ ---------------------------------------------------------------------------- }
constructor TADMacros.Create;
begin
  inherited Create(TADMacro);
end;

{ ---------------------------------------------------------------------------- }
constructor TADMacros.CreateRefCounted(AGetOwner: TADGetOwner);
begin
  FGetOwner := AGetOwner;
  inherited Create(TADMacro);
  FRefs := TADRefCounter.Create(Self);
  FRefs.CountRef(1);
end;

{-------------------------------------------------------------------------------}
destructor TADMacros.Destroy;
begin
  ADFreeAndNil(FRefs);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADMacros.AddRef;
begin
  if FRefs <> nil then
    FRefs.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADMacros.RemRef;
begin
  if FRefs <> nil then
    FRefs.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADMacros.GetIsRefCounted: Boolean;
begin
  Result := (FRefs <> nil) and (FRefs.Refs >= 0);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.Assign(AValue: TPersistent);
var
  i, j: Integer;
  s: String;
  oMac: TADMacro;
begin
  if AValue is TStrings then begin
    BeginUpdate;
    try
      Clear;
      for i := 0 to TStrings(AValue).Count - 1 do begin
        oMac := TADMacro(Add);
        s := TStrings(AValue)[i];
        j := Pos('=', s);
        oMac.Name := Copy(s, 1, j - 1);
        oMac.AsRaw := Copy(s, j + 1, Length(s));
      end;
    finally
      EndUpdate;
    end;
  end
  else
    inherited Assign(AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.AssignTo(ADest: TPersistent);
var
  i: Integer;
begin
  if ADest is TStrings then begin
    TStrings(ADest).Clear;
    for i := 0 to Count - 1 do
      TStrings(ADest).Add(Items[i].Name + '=' + Items[i].Value);
  end
  else
    inherited AssignTo(ADest);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.AssignValues(AValue: TADMacros);
var
  i: Integer;
  oMacro: TADMacro;
begin
  BeginUpdate;
  try
    for i := 0 to AValue.Count - 1 do begin
      oMacro := FindMacro(AValue[i].Name);
      if oMacro <> nil then
        oMacro.Assign(AValue[i]);
    end;
  finally
    EndUpdate;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.Add: TADMacro;
begin
  Result := TADMacro(inherited Add);
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.IsEqual(AValue: TADMacros): Boolean;
var
  i: Integer;
begin
  Result := Count = AValue.Count;
  if Result then                                                               
    for i := 0 to Count - 1 do begin
      Result := Items[i].IsEqual(AValue.Items[i]);
      if not Result then
        Break;
    end
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.FindMacro(const AValue: String): TADMacro;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    Result := Items[i];
    if {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
       (Result.Name, AValue) = 0 then
      Exit;
  end;
  Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.MacroByName(const AValue: String): TADMacro;
begin
  Result := FindMacro(AValue);
  if Result = nil then
    ADException(Self, [S_AD_LStan], er_AD_StanMacroNotFound, [AValue]);
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.GetDataSet: TDataSet;
begin
  if Assigned(FGetOwner) and (FGetOwner() <> nil) and (FGetOwner() is TDataSet) then
    Result := TDataSet(FGetOwner())
  else
    Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.GetItem(AIndex: Integer): TADMacro;
begin
  Result := TADMacro(inherited Items[AIndex]);
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.SetItem(AIndex: Integer; AValue: TADMacro);
begin
  inherited Items[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADMacros.GetOwner: TPersistent;
begin
  if Assigned(FGetOwner) then
    Result := FGetOwner()
  else
    Result := nil;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.DoChanged;
begin
  if UpdateCount = 0 then
    try
      if Assigned(FOnChanged) and not FTempLockUpdate then
        FOnChanged(Self);
    finally
      FTempLockUpdate := False;
    end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.EndUpdate;
begin
  inherited EndUpdate;
  DoChanged;
end;

{ ---------------------------------------------------------------------------- }
procedure TADMacros.TempLockUpdate;
begin
  FTempLockUpdate := True;
end;

{ ---------------------------------------------------------------------------- }
{ TADParams                                                                    }
{ ---------------------------------------------------------------------------- }
constructor TADParams.Create;
begin
  inherited Create(TADParam);
  FMarkers := TADStringList.Create;
end;

{ ---------------------------------------------------------------------------- }
constructor TADParams.CreateRefCounted(AGetOwner: TADGetOwner);
begin
  FGetOwner := AGetOwner;
  inherited Create(TADParam);
  FRefs := TADRefCounter.Create(Self);
  FRefs.CountRef(1);
  FMarkers := TADStringList.Create;
end;

{-------------------------------------------------------------------------------}
destructor TADParams.Destroy;
begin
  ADFreeAndNil(FRefs);
  ADFreeAndNil(FMarkers);
  inherited Destroy;
end;

{-------------------------------------------------------------------------------}
procedure TADParams.AddRef;
begin
  if FRefs <> nil then
    FRefs.AddRef;
end;

{-------------------------------------------------------------------------------}
procedure TADParams.RemRef;
begin
  if FRefs <> nil then
    FRefs.RemRef;
end;

{-------------------------------------------------------------------------------}
function TADParams.GetIsRefCounted: Boolean;
begin
  Result := (FRefs <> nil) and (FRefs.Refs >= 0);
end;

{ ---------------------------------------------------------------------------- }
function TADParams.GetDataSet: TDataSet;
begin
  if Assigned(FGetOwner) and (FGetOwner() <> nil) and (FGetOwner() is TDataSet) then
    Result := TDataSet(FGetOwner())
  else
    Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.GetOwner: TPersistent;
begin
  if Assigned(FGetOwner) then
    Result := FGetOwner()
  else
    Result := nil;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.SetMarkers(const AValue: TStrings);
begin
  FMarkers.Assign(AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParams.Add: TADParam;
begin
  Result := TADParam(inherited Add);
  if (Count > 1) and (Items[0].ArrayType = atArray) then
    Result.ArraySize := Items[0].ArraySize;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.Add(const AName: String;
  const AValue: Variant; AParamType: TParamType = ptUnknown): TADParam;
begin
  Result := Add;
  Result.Name := AName;
  Result.Value := AValue;
  if AParamType <> ptUnknown then
    Result.ParamType := AParamType;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.Add(const AName: String; AType: TFieldType;
  ASize: Integer = -1; AParamType: TParamType = ptUnknown): TADParam;
begin
  Result := Add;
  Result.Name := AName;
  Result.DataType := AType;
  if ASize <> -1 then
    Result.Size := ASize;
  if AParamType <> ptUnknown then
    Result.ParamType := AParamType;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.CreateParam(AFldType: TFieldType;
  const AParamName: String; AParamType: TParamType): TADParam;
begin
  Result := Add(AParamName, AFldType, -1, AParamType);
end;

{ ---------------------------------------------------------------------------- }
function TADParams.FindParam(const AValue: String): TADParam;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    Result := Items[i];
    if {$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
       (Result.Name, AValue) = 0 then
      Exit;
  end;
  Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.ParamByName(const AValue: String): TADParam;
begin
  Result := FindParam(AValue);
  if Result = nil then
    DatabaseErrorFmt(SParameterNotFound, [AValue], GetDataSet);
end;

{ ---------------------------------------------------------------------------- }
function TADParams.FindParam(const AValue: Integer): TADParam;
var
  i: Integer;
begin
  if (AValue >= 1) and (AValue <= Count) then begin
    Result := Items[AValue - 1];
    if Result.Position = AValue then
      Exit;
  end;
  for i := 0 to Count - 1 do begin
    Result := Items[i];
    if Result.Position = AValue then
      Exit;
  end;
  Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.ParamByPosition(const AValue: Integer): TADParam;
begin
  Result := FindParam(AValue);
  if Result = nil then
    DatabaseErrorFmt(SParameterNotFound, ['#' + IntToStr(AValue)], GetDataSet);
end;

{ ---------------------------------------------------------------------------- }
function TADParams.GetItem(Index: Integer): TADParam;
begin
  Result := TADParam(inherited Items[Index]);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.SetItem(Index: Integer; const AValue: TADParam);
begin
  inherited Items[Index] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.Assign(AValue: TPersistent);
begin
  if AValue = Self then
    Exit;
  if AValue is TADParams then begin
    FBindMode := TADParams(AValue).BindMode;
    FMarkers.Assign(TADParams(AValue).Markers);
  end;
  inherited Assign(AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.AssignValues(AValue: TADParams;
  AParamTypes: TParamTypes = [ptUnknown .. ptResult]);
var
  i, j, n: Integer;
  oPar1, oPar2: TADParam;
begin
  if AValue = Self then
    Exit;
  if BindMode = pbByName then
    for i := AValue.Count - 1 downto 0 do begin
      oPar1 := AValue[i];
      for j := 0 to Count - 1 do begin
        oPar2 := Items[j];
        if ({$IFDEF AnyDAC_NOLOCALE_META} CompareText {$ELSE} AnsiCompareText {$ENDIF}
            (oPar1.Name, oPar2.Name) = 0) and
           (not (Assigned(DataSet) and (csDesigning in DataSet.ComponentState)) or
            (oPar2.DataType = ftUnknown) or (oPar2.DataType = oPar1.DataType)) and
           (oPar2.ParamType in AParamTypes) then
          oPar2.AssignParam(oPar1);
      end;
    end
  else begin
    n := AValue.Count;
    if n > Count then
      n := Count;
    for i := 0 to n - 1 do begin
      oPar2 := Items[i];
      if oPar2.ParamType in AParamTypes then
        oPar2.AssignParam(AValue[i]);
    end;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.Prepare(ADefaultDataType: TFieldType;
  ADefaultParamType: TParamType);
var
  i: Integer;
  oPar: TADParam;
  lNoName, lNoPos: Boolean;
begin
  if Count = 0 then
    Exit;
  lNoName := True;
  lNoPos := True;
  for i := 0 to Count - 1 do begin
    oPar := Items[i];
    if oPar.DataType = ftUnknown then
      oPar.DataType := ADefaultDataType;
    if oPar.ParamType = ptUnknown then
      oPar.ParamType := ADefaultParamType;
    if oPar.Size < 0 then
      oPar.Size := 0;
    lNoName := lNoName and (oPar.Name = '');
    lNoPos := lNoPos and (oPar.Position <= 0);
  end;
  if lNoPos and ((BindMode = pbByNumber) or lNoName) then begin
    BindMode := pbByNumber;
    for i := 0 to Count - 1 do
      Items[i].Position := i + 1;
  end
  else if lNoName and not lNoPos then
    BindMode := pbByNumber;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.GetParamList(AList: TADObjList; const AParamNames: String);
var
  iPos: Integer;
begin
  iPos := 1;
  while iPos <= Length(AParamNames) do
    AList.Add(ParamByName(ADExtractFieldName(AParamNames, iPos)));
end;

{ ---------------------------------------------------------------------------- }
function TADParams.IsEqual(AValue: TADParams): Boolean;
var
  i: Integer;
begin
  Result := (Count = AValue.Count);
  if Result then
    for i := 0 to Count - 1 do begin
      Result := Items[i].IsEqual(AValue.Items[i]);
      if not Result then
        Break;
    end
end;

{ ---------------------------------------------------------------------------- }
function TADParams.GetArraySize: Integer;
begin
  if (Count = 0) or (Items[0].ArrayType <> atArray) then
    Result := 1
  else
    Result := Items[0].ArraySize;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.SetArraySize(const AValue: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].ArraySize := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParams.GetParamValues(const AParamName: TADWideString): Variant;
var
  i: Integer;
  oParams: TADObjList;
begin
  if Pos(';', AParamName) <> 0 then begin
    oParams := TADObjList.Create;
    try
      GetParamList(oParams, AParamName);
      Result := VarArrayCreate([0, oParams.Count - 1], varVariant);
      for I := 0 to oParams.Count - 1 do
        Result[I] := TADParam(oParams[I]).Value;
    finally
      ADFree(oParams);
    end;
  end
  else
    Result := ParamByName(AParamName).Value;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.SetParamValues(const AParamName: TADWideString; const AValue: Variant);
var
  i: Integer;
  oParams: TADObjList;
begin
  if Pos(';', AParamName) <> 0 then begin
    oParams := TADObjList.Create;
    try
      GetParamList(oParams, AParamName);
      for i := 0 to oParams.Count - 1 do
        TADParam(oParams[I]).Value := AValue[I];
    finally
      ADFree(oParams);
    end;
  end
  else
    ParamByName(AParamName).Value := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.ClearValues(AIndex: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Clear(AIndex);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data', ReadBinaryData, nil, False);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParams.ReadBinaryData(Stream: TStream);
var
  I, Temp, NumItems: Integer;
  Buffer: array[0..2047] of Byte;
  Version: Word;
  Bool: Boolean;
  oParam: TADParam;
begin
  Clear;
  Stream.ReadBuffer(Version, SizeOf(Version));
  if Version > 2 then
    DatabaseError(SInvalidVersion);
  NumItems := 0;
  if Version = 2 then
    Stream.ReadBuffer(NumItems, SizeOf(NumItems))
  else
    Stream.ReadBuffer(NumItems, 2);
  for I := 0 to NumItems - 1 do begin
    oParam := TADParam(Add);
    Temp := 0;
    if Version = 2 then
      Stream.ReadBuffer(Temp, SizeOf(Temp))
    else
      Stream.ReadBuffer(Temp, 1);
    Stream.ReadBuffer(Buffer, Temp);
    oParam.Name := TADEncoder.Deco(@Buffer, Temp, ecANSI);
    Stream.ReadBuffer(oParam.FParamType, SizeOf(oParam.FParamType));
    Stream.ReadBuffer(oParam.FDataType, SizeOf(oParam.FDataType));
    if oParam.DataType <> ftUnknown then
    begin
      Temp := 0;
      if Version = 2 then
        Stream.ReadBuffer(Temp, SizeOf(Temp))
      else
        Stream.ReadBuffer(Temp, 2);
      Stream.ReadBuffer(Buffer, Temp);
      if oParam.DataType in [ftBlob, ftGraphic..ftTypedBinary, ftOraBlob, ftOraClob] then
        oParam.SetBlobRawData(Temp, @Buffer)
      else
        oParam.SetData(@Buffer);
    end;
    Stream.ReadBuffer(Bool, SizeOf(Bool));
    if Bool then
      oParam.FValue[0] := Null;
    Stream.ReadBuffer(oParam.FBound, SizeOf(oParam.FBound));
  end;
end;

{ ---------------------------------------------------------------------------- }
{ TADParam                                                                     }
{ ---------------------------------------------------------------------------- }
constructor TADParam.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  UpdateData(TADParams(Collection).ArraySize);
end;

{ ---------------------------------------------------------------------------- }
constructor TADParam.Create(AParams: TADParams; AParamType: TParamType);
begin
  Create(AParams);
  ParamType := AParamType;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.IsEqual(AValue: TADParam): Boolean;

  function CompareValues(const V1, V2: TADVariantArray): Boolean;
  var
    i: Integer;
  begin
    Result := Length(V1) = Length(V2);
    if Result then
      for i := 0 to Length(V1) - 1 do
{$IFDEF AnyDAC_D6Base}
        if VarCompareValue(V1[i], V2[i]) <> vrEqual then begin
{$ELSE}
        if not (
            (VarType(V1[i]) = VarType(V2[i])) and
            (VarIsEmpty(V1[i]) or (V1[i] = V2[i]))) then begin
{$ENDIF}
          Result := False;
          Break;
        end;
  end;

begin
  Result :=
    (Position = AValue.Position) and (IsCaseSensitive = AValue.IsCaseSensitive) and
    (ArrayType = AValue.ArrayType) and (ArraySize = AValue.ArraySize) and
    (DataType = AValue.DataType) and (ADDataType = AValue.ADDataType) and
    (Precision = AValue.Precision) and (NumericScale = AValue.NumericScale) and
    (Name = AValue.Name) and (ParamType = AValue.ParamType) and
    (Size = AValue.Size) and (IsNull = AValue.IsNull) and (Bound = AValue.Bound) and
    CompareValues(FValue, AValue.FValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.IsParamStored: Boolean;
begin
  Result := Bound and (ArrayType = atScalar);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetSQLName: String;
begin
  Result := Name;
  if (Result = '') and (Collection <> nil) and
     (TADParams(Collection).BindMode = pbByNumber) then
    if ParamType <> ptResult then
      Result := 'P' + IntToStr(Position)
    else
      Result := 'RESULT';
  if IsCaseSensitive then
    Result := '"' + Result + '"';
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.ErrIndex(AIndex: Integer);
begin
  if AIndex <= 0 then
    AIndex := 0;
  ADException(Self, [S_AD_LStan], er_AD_StanBadParRowIndex,
    [Name, AIndex, Length(FValue) - 1]);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.CheckIndex(var AIndex: Integer);
begin
  if FValue = nil then
    ErrIndex(AIndex)
  else if AIndex <= 0 then
    AIndex := 0
  else if Length(FValue) <= AIndex then
    ErrIndex(AIndex);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.UpdateData(ADim: Integer);
var
  i, iLen: Integer;
begin
  iLen := Length(FValue);
  if iLen <> ADim then begin
    SetLength(FValue, ADim);
    for i := iLen to ADim - 1 do
      FValue[i] := Null;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetArraySize: Integer;
begin
  Result := Length(FValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetArraySize(AValue: Integer);
begin
  if ArraySize <> AValue then begin
    if AValue = 1 then begin
      if FArrayType = atArray then
        FArrayType := atScalar;
    end
    else if AValue >= 0 then begin
      if FArrayType = atScalar then
        FArrayType := atArray;
    end;
    UpdateData(AValue);
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetArrayType(AValue: TADParamArrayType);
begin
  if ArrayType <> AValue then begin
    FArrayType := AValue;
    if (ArrayType = atScalar) and (ArraySize <> 1) then
      ArraySize := 1;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetIsNull: Boolean;
begin
  Result := GetIsNulls(0);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetIsNulls(AIndex: Integer): Boolean;
var
  pData: PVarData;
begin
  CheckIndex(AIndex);
  pData := FindVarData(FValue[AIndex]);
  Result := (pData^.VType = varNull) or (pData^.VType = varEmpty);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetDataType(AValue: TFieldType);
var
  vType, i: Integer;
begin
  if FDataType <> AValue then begin
    FDataType := AValue;
    if Assigned(DataSet) and (csDesigning in DataSet.ComponentState) and
       not GetIsNulls(-1) then begin
      vType := C_FieldType2VarType[AValue];
      if vType <> varError then
        try
          for i := 0 to Length(FValue) - 1 do
            VarCast(FValue[i], FValue[i], vType);
        except
          Clear;
        end
      else
        Clear;
    end
    else
      Clear;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.ErrUnknownFieldType;
begin
  DatabaseErrorFmt(SUnknownFieldType, [Name], DataSet);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.ErrBadFieldType;
begin
  DatabaseErrorFmt(SBadFieldType, [Name], DataSet);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetDataLength(AIndex: Integer): Integer; 
var
  pVar: PVariant;

  function GetStrVarLen(out AResult: Integer): Boolean;
  begin
    case VarType(pVar^) of
{$IFNDEF NEXTGEN}
    varString:
      begin
        AResult := Length(AnsiString(TVarData(pVar^).VString));
        Result := True;
      end;
{$ENDIF}
    varOleStr:
      begin
        AResult := ADWideStrLen(TVarData(pVar^).VOleStr);
        Result := True;
      end;
{$IFDEF AnyDAC_D12}
    varUString:
      begin
        AResult := Length(UnicodeString(TVarData(pVar^).VUString));
        Result := True;
      end;
{$ENDIF}
    varByte or varArray:
      begin
        AResult := TVarData(pVar^).VArray^.Bounds[0].ElementCount;
        Result := True;
      end;
    else
      Result := False;
    end;
  end;

  procedure GetVarLen(out AResult: Integer);
  var
    s: String;
  begin
    if not VarIsNull(pVar^) then begin
      s := pVar^;
      AResult := Length(s);
    end;
  end;

  procedure GetVar2Len(out AResult: Integer);
  var
    s: String;
  begin
    if not VarIsNull(pVar^) then begin
      s := VarToStr(pVar^);
      AResult := Length(s);
    end;
  end;

  procedure GetVarWideLen(out AResult: Integer);
  var
    ws: TADWideString;
  begin
    if not VarIsNull(pVar^) then begin
      ws := pVar^;
      Result := Length(ws);
    end;
  end;

begin
  case DataType of
    ftUnknown:
      begin
        Result := 0;
        ErrUnknownFieldType;
      end;
    ftString, ftFixedChar, ftADT:
      begin
        Result := 0;
        GetVarData(pVar, AIndex);
        if not GetStrVarLen(Result) then
          GetVarLen(Result);
      end;
    ftWideString {$IFDEF AnyDAC_WideMemo}, ftFixedWideChar {$ENDIF}:
      begin
        Result := 0;
        GetVarData(pVar, AIndex);
        if not GetStrVarLen(Result) then
          GetVarWideLen(Result);
      end;
    ftBoolean:
      Result := SizeOf(WordBool);
{$IFDEF AnyDAC_D6Base}
    ftFMTBcd,
{$ENDIF}
    ftBCD:
      Result := SizeOf(TADBcd);
    ftCurrency:
      Result := SizeOf(Currency);
{$IFDEF AnyDAC_D14}
    ftSingle:
      Result := SizeOf(Single);
{$ENDIF}
    ftFloat:
      Result := SizeOf(Double);
{$IFDEF AnyDAC_D12}
    ftExtended:
      Result := SizeOf(Extended);
{$ENDIF}
{$IFDEF AnyDAC_D6Base}
    ftTimeStamp {$IFDEF AnyDAC_D10}, ftOraTimeStamp {$ENDIF}:
      Result := SizeOf(TADSQLTimeStamp);
{$ENDIF}
    ftParadoxOle {$IFDEF AnyDAC_D10}, ftOraInterval {$ENDIF}:
      Result := SizeOf(TADSQLTimeInterval);
    ftDateTime:
      Result := SizeOf(TDateTime);
    ftTime, ftDate:
      Result := SizeOf(Integer);
    ftAutoInc, ftInteger:
      Result := SizeOf(Integer);
{$IFDEF AnyDAC_D12}
    ftLongWord:
      Result := SizeOf(LongWord);
    ftShortint:
      Result := SizeOf(ShortInt);
    ftByte:
      Result := SizeOf(Byte);
{$ENDIF}
    ftSmallint:
      Result := SizeOf(SmallInt);
    ftWord:
      Result := SizeOf(Word);
    ftLargeint:
      Result := SizeOf(Largeint);
    ftBytes, ftVarBytes:
      begin
        Result := 0;
        GetVarData(pVar, AIndex);
        if VarIsArray(pVar^) then
          Result := VarArrayHighBound(pVar^, 1) + 1
        else if not GetStrVarLen(Result) then
          Result := 0;
      end;
    ftBlob, ftGraphic, ftTypedBinary, ftOraBlob:
      begin
        Result := 0;
        GetVarData(pVar, AIndex);
        if VarIsArray(pVar^) then
          Result := VarArrayHighBound(pVar^, 1) + 1
        else if not GetStrVarLen(Result) then
          GetVar2Len(Result);
      end;
    ftMemo, ftFmtMemo, ftDBaseOle, ftOraClob
    {$IFDEF AnyDAC_WideMemo}, ftWideMemo {$ENDIF}:
      begin
        Result := 0;
        GetVarData(pVar, AIndex);
        if not GetStrVarLen(Result) then
          GetVar2Len(Result);
      end;
    ftArray, ftDataSet, ftReference, ftCursor:
      Result := 0;
    ftGUID:
      Result := SizeOf(TGUID);
  else
    Result := 0;
    ErrBadFieldType;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetDataSize(AIndex: Integer): Integer;
begin
  Result := GetDataLength(AIndex);
  case DataType of
  {$IFDEF AnyDAC_WideMemo}
    ftFixedWideChar,
  {$ENDIF}
    ftWideString:
      Result := (Result + 1) * SizeOf(WideChar);
  {$IFDEF AnyDAC_WideMemo}
    ftWideMemo,
  {$ENDIF}
    ftFmtMemo,
    ftDBaseOle:
      Result := Result * SizeOf(WideChar);
    ftFixedChar,
    ftString,
    ftAdt:
      Result := (Result + 1) * SizeOf(TADAnsiChar);
    ftMemo:
      Result := Result * SizeOf(TADAnsiChar);
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.GetData(ABuffer: PADByteString; AIndex: Integer);
var
  pVar: PVariant;
  cr: Currency;
  buff: array[0 .. 63] of Char;
  iSize: Integer;

  procedure GetAnsiString(AAddOn: Integer);
  var
    SA: TADAnsiString;
{$IFDEF NEXTGEN}
    SB: TADByteString;
{$ENDIF}
  begin
    SA := AsAnsiStrings[AIndex];
{$IFDEF NEXTGEN}
    SB := TADEncoder.Enco(SA, ecANSI);
    Move(PADByteString(SB)^, ABuffer^, (Length(SA) + AAddOn) * SizeOf(TADAnsiChar));
{$ELSE}
    Move(PAnsiChar(SA)^, ABuffer^, (Length(SA) + AAddOn) * SizeOf(AnsiChar));
{$ENDIF}
  end;

  procedure GetWideString(AAddOn: Integer);
  var
    SW: TADWideString;
  begin
    SW := AsWideStrings[AIndex];
    Move(PWideChar(SW)^, ABuffer^, (Length(SW) + AAddOn) * SizeOf(WideChar));
  end;

  procedure GetByteString;
  var
    SB: TADByteString;
  begin
    SB := AsByteStrs[AIndex];
    Move(PADByteString(SB)^, ABuffer^, Length(SB) * SizeOf(Byte));
  end;

begin
  CheckIndex(AIndex);
  case DataType of
    ftUnknown:
      ErrUnknownFieldType;
    ftString, ftFixedChar, ftAdt:
      GetAnsiString(1);
    ftMemo:
      GetAnsiString(0);
    ftWideString {$IFDEF AnyDAC_WideMemo}, ftFixedWideChar {$ENDIF}:
      GetWideString(1);
    ftFmtMemo {$IFDEF AnyDAC_WideMemo}, ftWideMemo {$ENDIF}, ftDBaseOle:
      GetWideString(0);
{$IFDEF AnyDAC_D12}
    ftShortint:
      PShortInt(ABuffer)^ := ShortInt(AsShortInts[AIndex]);
    ftByte:
      PByte(ABuffer)^ := Byte(AsBytes[AIndex]);
{$ENDIF}
    ftSmallint:
      PSmallInt(ABuffer)^ := SmallInt(AsSmallInts[AIndex]);
    ftWord:
      PWord(ABuffer)^ := Word(AsWords[AIndex]);
    ftAutoInc, ftInteger:
      PInteger(ABuffer)^ := AsIntegers[AIndex];
{$IFDEF AnyDAC_D12}
    ftLongWord:
      PLongWord(ABuffer)^ := AsLongWords[AIndex];
{$ENDIF}
    ftLargeint:
      PInt64(ABuffer)^ := AsLargeInts[AIndex];
    ftTime:
      PADDateTimeData(ABuffer)^.Time := DateTimeToTimeStamp(AsDateTimes[AIndex]).Time;
    ftDate:
      PADDateTimeData(ABuffer)^.Date := DateTimeToTimeStamp(AsDateTimes[AIndex]).Date;
    ftDateTime:
      if ADDataType = dtDateTimeStamp then
        PADSQLTimeStamp(ABuffer)^ := AsSQLTimeStamps[AIndex]
      else
        PADDateTimeData(ABuffer)^.DateTime := ADDateTime2MSecs(AsDateTimes[AIndex]);
{$IFDEF AnyDAC_D6Base}
    ftTimeStamp {$IFDEF AnyDAC_D10}, ftOraTimeStamp {$ENDIF}:
      PADSQLTimeStamp(ABuffer)^ := AsSQLTimeStamps[AIndex];
{$ENDIF}
    ftParadoxOle {$IFDEF AnyDAC_D10}, ftOraInterval {$ENDIF}:
      PADSQLTimeInterval(ABuffer)^ := AsSQLTimeIntervals[AIndex];
    ftBCD:
      begin
        GetVarData(pVar, AIndex);
{$IFDEF AnyDAC_D6Base}
        if VarIsFmtBCD(pVar^) then
          PADBcd(ABuffer)^ := VarToBCD(pVar^)
        else 
{$ENDIF}
        begin
          cr := pVar^;
          ADCurr2Str(buff, iSize, cr, Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator));
          ADStr2BCD(buff, iSize, PADBcd(ABuffer)^, Char({$IFDEF AnyDAC_D15} FormatSettings. {$ENDIF} DecimalSeparator));
        end;
      end;
{$IFDEF AnyDAC_D6Base}
    ftFMTBCD:
      PADBcd(ABuffer)^ := AsFMTBCDs[AIndex];
{$ENDIF}
{$IFDEF AnyDAC_D14}
    ftSingle:
      PSingle(ABuffer)^ := AsSingles[AIndex];
{$ENDIF}
    ftFloat:
      PDouble(ABuffer)^ := AsFloats[AIndex];
{$IFDEF AnyDAC_D12}
    ftExtended:
      PExtended(ABuffer)^ := AsExtendeds[AIndex];
{$ENDIF}
    ftCurrency:
      PCurrency(ABuffer)^ := AsCurrencys[AIndex];
    ftBoolean:
      PWord(ABuffer)^ := Ord(AsBooleans[AIndex]);
    ftBytes, ftVarBytes:
      GetBytesValue(AIndex, ABuffer);
    ftBlob, ftGraphic, ftTypedBinary, ftOraBlob, ftOraClob:
      GetByteString;
    ftArray, ftDataSet, ftReference, ftCursor:
      {Nothing};
    ftGUID:
      PGUID(ABuffer)^ := AsGUIDs[AIndex];
  else
    ErrBadFieldType;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetData(ABuffer: PADByteString; ALen: LongWord; AIndex: Integer);
var
  crValue: Currency;
  TimeStamp: TTimeStamp;
{$IFNDEF NEXTGEN}
  SA: AnsiString;
{$ENDIF}
  SW: TADWideString;
begin
  if DataType = ftUnknown then
    ErrUnknownFieldType
  else if ABuffer = nil then
    Clear(AIndex)
  else
    case DataType of
      ftString, ftFixedChar, ftADT:
        begin
          if ALen = $FFFFFFFF then
            if (DataType = ftFixedChar) and (Size > 0) then
              ALen := Size
            else
              ALen := ADAnsiStrLen(PADAnsiString(ABuffer));
{$IFDEF NEXTGEN}
          Values[AIndex] := TADEncoder.Deco(ABuffer, ALen, ecANSI);
{$ELSE}
          SetString(SA, PAnsiChar(ABuffer), ALen);
          Values[AIndex] := SA;
{$ENDIF}
        end;
      ftWideString, ftFmtMemo {$IFDEF AnyDAC_WideMemo}, ftWideMemo, ftFixedWideChar {$ENDIF}, ftDBaseOle:
        begin
          if ALen = $FFFFFFFF then
{$IFDEF AnyDAC_WideMemo}
            if (DataType = ftFixedWideChar) and (Size > 0) then
              ALen := Size
            else
{$ENDIF}
              ALen := ADWideStrLen(PWideChar(ABuffer));
          SetString(SW, PWideChar(ABuffer), ALen);
          Values[AIndex] := SW;
        end;
{$IFDEF AnyDAC_D12}
      ftShortint:
        AsShortInts[AIndex] := PShortInt(ABuffer)^;
      ftByte:
        AsBytes[AIndex] := PByte(ABuffer)^;
{$ENDIF}
      ftSmallint:
        if ADDataType = dtSByte then
          AsSmallInts[AIndex] := PShortint(ABuffer)^
        else if ADDataType = dtByte then
          AsSmallInts[AIndex] := PByte(ABuffer)^
        else
          AsSmallInts[AIndex] := PSmallint(ABuffer)^;
      ftWord:
        if ADDataType = dtByte then
          AsWords[AIndex] := PByte(ABuffer)^
        else
          AsWords[AIndex] := PWord(ABuffer)^;
      ftInteger, ftAutoInc:
        AsIntegers[AIndex] := PInteger(ABuffer)^;
{$IFDEF AnyDAC_D12}
      ftLongWord:
        AsLongWords[AIndex] := PLongWord(ABuffer)^;
{$ENDIF}
      ftLargeint:
        AsLargeInts[AIndex] := PInt64(ABuffer)^;
      ftTime:
        begin
          TimeStamp.Time := PLongInt(ABuffer)^;
          TimeStamp.Date := DateDelta;
          AsTimes[AIndex] := TimeStampToDateTime(TimeStamp);
        end;
      ftDate:
        begin
          TimeStamp.Time := 0;
          TimeStamp.Date := PInteger(ABuffer)^;
          AsDates[AIndex] := TimeStampToDateTime(TimeStamp);
        end;
      ftDateTime:
        if ADDataType = dtDateTimeStamp then
          AsSQLTimeStamps[AIndex] := PADSQLTimeStamp(ABuffer)^
        else
          AsDateTimes[AIndex] := ADMSecs2DateTime(PDouble(ABuffer)^);
{$IFDEF AnyDAC_D6Base}
      ftTimeStamp {$IFDEF AnyDAC_D10}, ftOraTimeStamp {$ENDIF}:
        AsSQLTimeStamps[AIndex] := PADSQLTimeStamp(ABuffer)^;
{$ENDIF}
      ftParadoxOle {$IFDEF AnyDAC_D10}, ftOraInterval {$ENDIF}:
        AsSQLTimeIntervals[AIndex] := PADSQLTimeInterval(ABuffer)^;
      ftBCD:
        begin
          crValue := 0.0;
          if BCDToCurr(PADBcd(ABuffer)^, crValue) then
            AsBCDs[AIndex] := crValue
          else
            raise EOverFlow.CreateFmt(SFieldOutOfRange, [Name]);
        end;
{$IFDEF AnyDAC_D6Base}
      ftFMTBcd:
        AsFMTBCDs[AIndex] := PADBcd(ABuffer)^;
{$ENDIF}
      ftCurrency:
        AsCurrencys[AIndex] := PCurrency(ABuffer)^;
{$IFDEF AnyDAC_D14}
      ftSingle:
        AsSingles[AIndex] := PSingle(ABuffer)^;
{$ENDIF}
      ftFloat:
        case ADDataType of
        dtFmtBCD:   AsFMTBCDs[AIndex] := PADBcd(ABuffer)^;
        dtSingle:   AsSingles[AIndex] := PSingle(ABuffer)^;
        else        AsFloats[AIndex] := PDouble(ABuffer)^;
        end;
{$IFDEF AnyDAC_D12}
      ftExtended:
        AsExtendeds[AIndex] := PExtended(ABuffer)^;
{$ENDIF}
      ftBoolean:
        AsBooleans[AIndex] := PWordBool(ABuffer)^;
      ftCursor:
        begin
          if AIndex < 0 then
            AIndex := 0;
          FValue[AIndex] := 0;
        end;
      ftBytes, ftVarBytes:
        begin
          if ALen = $FFFFFFFF then
            if (DataType = ftBytes) and (Size > 0) then
              ALen := Size
            else
              ALen := ADAnsiStrLen(PADAnsiString(ABuffer));
          SetBytesValue(AIndex, ABuffer, ALen);
        end;
      ftBlob, ftMemo, ftGraphic, ftTypedBinary, ftOraBlob, ftOraClob:
        begin
          if ALen = $FFFFFFFF then
            ALen := ADAnsiStrLen(PADAnsiString(ABuffer));
          SetBlobRawData(ALen, ABuffer, AIndex);
        end;
      ftGUID:
        AsGUIDs[AIndex] := PGUID(ABuffer)^;
    else
      ErrBadFieldType;
    end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.BeginSetBlobRawData(var AIndex: Integer);
begin
  CheckIndex(AIndex);
  if not (DataType in [ftString, ftWideString, ftFixedChar,
                       ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftDBaseOle, ftTypedBinary, ftOraBlob, ftOraClob
                       {$IFDEF AnyDAC_WideMemo}, ftWideMemo, ftFixedWideChar {$ENDIF}]) then
    FDataType := ftBlob;
  FBound := True;
  FValue[AIndex] := Null;
end;

{ ---------------------------------------------------------------------------- }
{$IFDEF AnyDAC_D6}
  {$IFNDEF AnyDAC_D12}
    {$IFNDEF AnyDAC_FPC}
function SysAllocStringLen(P: PWideChar; Len: Integer): PWideChar; stdcall;
  external 'oleaut32.dll' name 'SysAllocStringLen';
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

function TADParam.EndSetBlobRawData(ALen: LongWord; APtr: PADByteString; AIndex: Integer): PADByteString;
var
  pData: PVarData;
begin
  if ALen > 0 then begin
    pData := @TVarData(FValue[AIndex]);
    if (DataType in [ftWideString, ftFmtMemo {$IFDEF AnyDAC_WideMemo}, ftWideMemo, ftFixedWideChar {$ENDIF}, ftDBaseOle]) or
       (DataType = ftOraClob) and (FADDataType in [dtWideHMemo, dtWideMemo, dtXML]) then begin
{$IFDEF AnyDAC_D12}
      pData^.VType := varUString;
      if APtr <> nil then
        SetString(UnicodeString(pData^.VUString), PWideChar(APtr), ALen)
      else
        SetLength(UnicodeString(pData^.VUString), ALen);
      Result := PADByteString(PWideChar(UnicodeString(pData^.VUString)));
{$ELSE}
      pData^.VType := varOleStr;
  {$IFNDEF AnyDAC_FPC}
      if APtr <> nil then
        pData^.VOleStr := SysAllocStringLen(PWideChar(APtr), ALen)
      else
        pData^.VOleStr := SysAllocStringLen(nil, ALen);
  {$ELSE}
      if APtr <> nil then
        SetString(WideString(Pointer(pData^.VOleStr)), PWideChar(APtr), ALen)
      else
        SetLength(WideString(Pointer(pData^.VOleStr)), ALen);
  {$ENDIF}
      Result := PADByteString(pData^.VOleStr);
{$ENDIF}
    end
    else begin
{$IFDEF NEXTGEN}
      FValue[AIndex] := VarArrayCreate([0, ALen - 1], varByte);
      Result := PADByteString(pData^.VArray^.Data);
      if APtr <> nil then
        Move(APtr^, Result^, ALen);
{$ELSE}
      pData^.VType := varString;
      if APtr <> nil then
        SetString(AnsiString(pData^.VString), PAnsiChar(APtr), ALen)
      else
        SetLength(AnsiString(pData^.VString), ALen);
      Result := PADByteString(PAnsiChar(AnsiString(pData^.VString)));
{$ENDIF}
    end;
  end
  else
    Result := nil;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.SetBlobRawData(ALen: LongWord; APtr: PADByteString; AIndex: Integer): PADByteString;
begin
  BeginSetBlobRawData(AIndex);
  Result := EndSetBlobRawData(ALen, APtr, AIndex);
end;

{ ---------------------------------------------------------------------------- }
{ TODO -cNEXTGEN : On NextGen for ftString, ftFixedChar, ftMemo, ftOraClob
  returns PWideChar instead of PAnsiChar. Similar with SetBlobRawData. }
function TADParam.GetBlobRawData(var ALen: LongWord; var APtr: PADByteString; AIndex: Integer): Boolean;
  procedure ErrorCantGet;
  begin
    ADException(Self, [S_AD_LStan], er_AD_StanCantGetBlob, []);
  end;
begin
  if not (DataType in [ftString, ftWideString, ftFixedChar,
                       ftBytes, ftVarBytes,
                       ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftDBaseOle, ftTypedBinary, ftOraBlob, ftOraClob
                       {$IFDEF AnyDAC_WideMemo}, ftWideMemo, ftFixedWideChar {$ENDIF}]) then
    ErrorCantGet;
  Result := not IsNulls[AIndex];
  if not Result then begin
    ALen := 0;
    APtr := nil;
  end
  else begin
    if AIndex < 0 then
      AIndex := 0;
    case VarType(FValue[AIndex]) of
{$IFNDEF NEXTGEN}
    varString:
      begin
        APtr := PADByteString(AnsiString(TVarData(FValue[AIndex]).VString));
        ALen := Length(AnsiString(TVarData(FValue[AIndex]).VString));
      end;
{$ENDIF}
    varOleStr:
      begin
        APtr := PADByteString(TVarData(FValue[AIndex]).VOleStr);
        ALen := ADWideStrLen(TVarData(FValue[AIndex]).VOleStr);
      end;
{$IFDEF AnyDAC_D12}
    varUString:
      begin
        APtr := PADByteString(PWideChar(UnicodeString(TVarData(FValue[AIndex]).VUString)));
        ALen := Length(UnicodeString(TVarData(FValue[AIndex]).VUString));
      end;
{$ENDIF}
    varArray or varByte:
      begin
        APtr := PADByteString(TVarData(FValue[AIndex]).VArray^.Data);
        ALen := TVarData(FValue[AIndex]).VArray^.Bounds[0].ElementCount;
      end;
    else
      if DataType in [ftWideString, ftFmtMemo
                      {$IFDEF AnyDAC_WideMemo}, ftWideMemo, ftFixedWideChar {$ENDIF}] then
        VarCast(FValue[AIndex], FValue[AIndex], {$IFDEF AnyDAC_D12} varUString {$ELSE}
                                                                    varOleStr {$ENDIF})
      else
        VarCast(FValue[AIndex], FValue[AIndex], varString);
      Result := GetBlobRawData(ALen, APtr, AIndex);
    end;
    if (ALen = 0) and (APtr = nil) then
      APtr := PADByteString(Self);
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetBytesValue(AIndex: Integer; ABuff: PADByteString; ASize: LongWord);
var
  V: Variant;
  pDest: Pointer;
begin
  if not (DataType in [ftVarBytes, ftBytes]) then
    DataType := ftBytes;
  V := VarArrayCreate([0, ASize - 1], varByte);
  pDest := VarArrayLock(V);
  try
    Move(ABuff^, pDest^, ASize);
  finally
    VarArrayUnlock(V);
  end;
  Values[AIndex] := V;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.GetBytesValue(AIndex: Integer; ABuff: PADByteString);
var
  V: Variant;
  P: Pointer;
  sb: TADByteString;
  pData: PVarData;
begin
  V := Values[AIndex];
  if VarIsArray(V) then begin
    P := VarArrayLock(V);
    try
      Move(P^, ABuff^, VarArrayHighBound(V, 1) + 1);
    finally
      VarArrayUnlock(V);
    end;
  end
  else begin
    pData := FindVarData(V);
    if (pData^.VType <> varNull) and (pData^.VType <> varEmpty) then begin
      sb := TADEncoder.Enco({$IFNDEF AnyDAC_D6} VarToStr(V) {$ELSE} V {$ENDIF}, ecANSI);
      Move(PADByteString(sb)^, ABuff^, Length(sb) * SizeOf(Byte));
    end;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.Assign(ASource: TPersistent);

{$IFDEF AnyDAC_D6Base}
  procedure LoadFromStreamPersist(const StreamPersist: IStreamPersist);
  var
    MS: TMemoryStream;
  begin
    MS := TMemoryStream.Create;
    try
      StreamPersist.SaveToStream(MS);
      LoadFromStream(MS, ftGraphic);
    finally
      ADFree(MS);
    end;
  end;
{$ENDIF}

  procedure LoadFromStrings(ASource: TStrings);
  begin
{$IFDEF AnyDAC_Unicode}
    AsWideMemo := ASource.Text;
{$ELSE}
    AsMemo := ASource.Text;
{$ENDIF}
  end;

{$IFDEF AnyDAC_D6Base}
var
  StreamPersist: IStreamPersist;
{$ENDIF}
begin
  if ASource is TADParam then
    AssignParam(TADParam(ASource))
  else if ASource is TParam then
    AssignDlpParam(TParam(ASource))
  else if ASource is TField then
    AssignField(TField(ASource))
  else if ASource is TStrings then
    LoadFromStrings(TStrings(ASource))
{$IFDEF AnyDAC_D6Base}
  else if Supports(ASource, IStreamPersist, StreamPersist) then
    LoadFromStreamPersist(StreamPersist)
{$ENDIF}
  else
    inherited Assign(ASource);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignTo(ADest: TPersistent);
begin
  if ADest is TField then
    TField(ADest).Value := FValue[0]
  else if ADest is TParam then
    AssignToDlpParam(TParam(ADest))
  else
    inherited AssignTo(ADest);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignParam(AParam: TADParam);
begin
  if AParam <> nil then begin
    FDataType := AParam.DataType;
    FADDataType := AParam.ADDataType;
    FBound := AParam.Bound;
    FName := AParam.Name;
    if FParamType = ptUnknown then
      FParamType := AParam.ParamType;
    FSize := AParam.Size;
    FPrecision := AParam.Precision;
    FNumericScale := AParam.NumericScale;
    FPosition := AParam.Position;
    FIsCaseSensitive := AParam.IsCaseSensitive;
    ArraySize := AParam.ArraySize;
    ArrayType := AParam.ArrayType;
    FValue := Copy(AParam.FValue);
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignDlpParam(AParam: TParam);
begin
  if AParam <> nil then begin
    FDataType := AParam.DataType;
    FADDataType := dtUnknown;
    FBound := AParam.Bound;
    FName := AParam.Name;
    if FParamType = ptUnknown then
      FParamType := AParam.ParamType;
{$IFDEF AnyDAC_D6Base}
  {$IFNDEF AnyDAC_D10}
    if FDataType = ftWideString then
      FSize := 0
    else
  {$ENDIF}
      FSize := AParam.Size;
    FPrecision := AParam.Precision;
    FNumericScale := SmallInt(AParam.NumericScale);
{$ELSE}
    FSize := 0;
    FPrecision := 0;
    FNumericScale := 0;
{$ENDIF}
    FPosition := AParam.Index + 1;
    FIsCaseSensitive := False;
    ArraySize := 1;
    ArrayType := atScalar;
    case FDataType of
    ftString, ftFixedChar, ftMemo:
      if AParam.IsNull then
        FValue[0] := Null
      else
        FValue[0] := VarAsType(AParam.Value,
          {$IFDEF NEXTGEN} varUString {$ELSE} varString {$ENDIF});
    ftBytes, ftVarBytes, ftBlob, ftGraphic, ftTypedBinary, ftOraBlob:
      if AParam.IsNull then
        FValue[0] := Null
      else if VarType(AParam.Value) = varOleStr then
        FValue[0] := VarAsType(AParam.Value, varADString)
      else
        FValue[0] := AParam.Value;
    else
      FValue[0] := AParam.Value;
    end;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignToDlpParam(AParam: TParam);
begin
  if AParam <> nil then begin
    AParam.DataType := FDataType;
    AParam.Bound := FBound;
    AParam.Name := FName;
    if AParam.ParamType = ptUnknown then
      AParam.ParamType := FParamType;
{$IFDEF AnyDAC_D6Base}
    AParam.Size := FSize;
    AParam.Precision := FPrecision;
    AParam.NumericScale := FNumericScale;
{$ENDIF}
    if Length(FValue) > 0 then
      AParam.Value := FValue[0]
    else
      AParam.Value := Null;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignFieldValue(AField: TField; const AValue: Variant);
begin
  if AField <> nil then begin
    if (AField.DataType = ftString) and TStringField(AField).FixedChar then
      DataType := ftFixedChar
    else if (AField.DataType = ftMemo) and (AField.Size > 255) then
      DataType := ftString
    else if (AField.DataType = ftFmtMemo) and (AField.Size > 255) then
      DataType := ftWideString
{$IFDEF AnyDAC_WideMemo}
    else if (AField.DataType = ftWideString) and TWideStringField(AField).FixedChar then
      DataType := ftFixedWideChar
    else if (AField.DataType = ftWideMemo) and (AField.Size > 255) then
      DataType := ftWideString
{$ENDIF}
    else
      DataType := AField.DataType;
    FADDataType := dtUnknown;
    if DataType = ftWideString then
      Size := AField.Size
    else
      Size := AField.DataSize;
    if AField.DataType in [ftBcd {$IFDEF AnyDAC_D6Base}, ftFMTBcd {$ENDIF}] then
      NumericScale := AField.Size;
    ArraySize := 1;
    ArrayType := atScalar;
    FBound := True;
    if VarIsNull(AValue) then
      Clear
    else
      Value := AValue;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignFieldValue(AField: TField);
begin
  if AField <> nil then
    AssignFieldValue(AField, AField.Value);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignField(AField: TField);
begin
  if AField <> nil then begin
    AssignFieldValue(AField, AField.Value);
    Name := AField.FieldName;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.Clear(AIndex: Integer);
var
  i: Integer;
begin
  if (ArrayType = atScalar) then
    FValue[0] := Null
  else if AIndex = -1 then
    for i := 0 to Length(FValue) - 1 do
      FValue[i] := Null
  else begin
    CheckIndex(AIndex);
    FValue[AIndex] := Null;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.AssignVarRec(const AVarRec: TVarRec; AIndex: Integer = -1);
begin
  case AVarRec.VType of
  vtInteger:       AsIntegers[AIndex] := AVarRec.VInteger;
  vtBoolean:       AsBooleans[AIndex] := AVarRec.VBoolean;
  vtChar:          AsAnsiStrings[AIndex] := {$IFDEF NEXTGEN} String(AVarRec.VChar) {$ELSE}
                                                             AVarRec.VChar {$ENDIF};
  vtExtended:      AsFloats[AIndex] := AVarRec.VExtended^;
  vtString:        AsAnsiStrings[AIndex] := {$IFDEF NEXTGEN} String(AVarRec.VString^) {$ELSE}
                                                             AVarRec.VString^ {$ENDIF};
  vtPointer:       {$IFDEF AnyDAC_32} AsIntegers {$ELSE} AsLargeInts {$ENDIF}
                     [AIndex] := TADNativeInt(AVarRec.VPointer);
  vtPChar:         AsAnsiStrings[AIndex] := {$IFDEF NEXTGEN} String(AVarRec.VPChar) {$ELSE}
                                                             AVarRec.VPChar {$ENDIF};
  vtWideChar:      AsWideStrings[AIndex] := AVarRec.VWideChar;
  vtPWideChar:     AsWideStrings[AIndex] := AVarRec.VPWideChar;
  vtAnsiString:    AsAnsiStrings[AIndex] := TADAnsiString(AVarRec.VAnsiString);
  vtCurrency:      AsCurrencys[AIndex] := AVarRec.VCurrency^;
  vtVariant:       Values[AIndex] := AVarRec.VVariant^;
  vtWideString:    AsWideStrings[AIndex] := WideString(AVarRec.VWideString);
  vtInt64:         AsLargeInts[AIndex] := AVarRec.VInt64^;
{$IFDEF FPC}
  vtQWord:         AsLargeInts[AIndex] := AVarRec.VQWord^;
{$ENDIF}
{$IFDEF AnyDAC_D12}
  vtUnicodeString: AsStrings[AIndex] := UnicodeString(AVarRec.VUnicodeString);
{$ENDIF}
  else             ASSERT(False);
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetDataSet: TDataSet;
begin
  if not Assigned(Collection) then
    Result := nil
  else
    Result := TADParams(Collection).GetDataSet;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetDisplayName: String;
begin
  if FName = '' then
    Result := inherited GetDisplayName
  else
    Result := FName;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBoolean(const AValue: Boolean);
begin
  SetAsBooleans(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsBoolean: Boolean;
begin
  Result := GetAsBooleans(-1);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsByteStr: TADByteString;
begin
  Result := GetAsByteStrs(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsByteStr(const AValue: TADByteString);
begin
  SetAsByteStrs(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsVarByteStr(const AValue: TADByteString);
begin
  SetAsVarByteStrs(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBooleans(AIndex: Integer; const AValue: Boolean);
begin
  FDataType := ftBoolean;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsBooleans(AIndex: Integer): Boolean;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := False
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsByteStrs(AIndex: Integer): TADByteString;
begin
  if IsNulls[AIndex] then
    SetLength(Result, 0)
  else begin
    SetLength(Result, GetDataSize(AIndex));
    GetBytesValue(AIndex, PADByteString(Result));
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsByteStrs(AIndex: Integer; const AValue: TADByteString);
begin
  FDataType := ftBytes;
  SetBytesValue(AIndex, PADByteString(AValue), Length(AValue) * SizeOf(Byte));
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsVarByteStrs(AIndex: Integer; const AValue: TADByteString);
begin
  FDataType := ftVarBytes;
  SetBytesValue(AIndex, PADByteString(AValue), Length(AValue) * SizeOf(Byte));
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsSingle(const AValue: Single);
begin
  SetAsSingles(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsSingle: Single;
begin
  Result := GetAsSingles(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsSingles(AIndex: Integer; const AValue: Single);
begin
{$IFDEF AnyDAC_D14}
  FDataType := ftSingle;
{$ELSE}
  FDataType := ftFloat;
{$ENDIF}
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsSingles(AIndex: Integer): Single;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0.0
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsFloat(const AValue: Double);
begin
  SetAsFloats(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsFloat: Double;
begin
  Result := GetAsFloats(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsFloats(AIndex: Integer; const AValue: Double);
begin
  FDataType := ftFloat;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsFloats(AIndex: Integer): Double;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0.0
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsExtended(const AValue: Extended);
begin
  SetAsExtendeds(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsExtended: Extended;
begin
  Result := GetAsExtendeds(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsExtendeds(AIndex: Integer; const AValue: Extended);
begin
{$IFDEF AnyDAC_D12}
  FDataType := ftExtended;
{$ELSE}
  FDataType := ftFloat;
{$ENDIF}
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsExtendeds(AIndex: Integer): Extended;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0.0
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsCurrency(const AValue: Currency);
begin
  SetAsCurrencys(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsCurrency: Currency;
begin
  Result := GetAsCurrencys(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsCurrencys(AIndex: Integer; const AValue: Currency);
begin
  FDataType := ftCurrency;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsCurrencys(AIndex: Integer): Currency;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0.0
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBCD(const AValue: Currency);
begin
  SetAsBCDs(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsBCD: Currency;
begin
  Result := GetAsBCDs(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBCDs(AIndex: Integer; const AValue: Currency);
begin
  FDataType := ftBCD;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsBCDs(AIndex: Integer): Currency;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0.0
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsFMTBCD(const AValue: TADBcd);
begin
  SetAsFMTBCDs(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsFMTBCD: TADBcd;
begin
  Result := GetAsFMTBCDs(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsFMTBCDs(AIndex: Integer; const AValue: TADBcd);
{$IFNDEF AnyDAC_D6Base}
var
  crVal: Currency;
{$ENDIF}
begin
{$IFDEF AnyDAC_D6Base}
  FDataType := ftFMTBCD;
  Values[AIndex] := VarFMTBcdCreate(AValue);
{$ELSE}
  crVal := 0.0;
  BCDToCurr(AValue, crVal);
  SetAsBCDs(AIndex, crVal);
{$ENDIF}
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsFMTBCDs(AIndex: Integer): TADBcd;
var
  pVar: PVariant;
{$IFNDEF AnyDAC_D6Base}
  crVal: Currency;
{$ENDIF}
begin
{$IFDEF AnyDAC_D6Base}
  if IsNulls[AIndex] then
    Result := NullBcd
  else begin
    GetVarData(pVar, AIndex);
    Result := VarToBcd(pVar^);
  end;
{$ELSE}
  if IsNulls[AIndex] then
    ADFillChar(Result, SizeOf(Result), 0)
  else begin
    GetVarData(pVar, AIndex);
    crVal := pVar^;
    CurrToBCD(crVal, Result);
  end;
{$ENDIF}
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsSQLTimeStamp(const AValue: TADSQLTimeStamp);
begin
  SetAsSQLTimeStamps(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsSQLTimeStamp: TADSQLTimeStamp;
begin
  Result := GetAsSQLTimeStamps(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsSQLTimeStamps(AIndex: Integer; const AValue: TADSQLTimeStamp);
begin
{$IFDEF AnyDAC_D6}
  {$IFDEF AnyDAC_D10}
  if FDataType <> ftOraTimeStamp then
  {$ENDIF}
    FDataType := ftTimeStamp;
  Values[AIndex] := VarSQLTimeStampCreate(AValue);
{$ELSE}
  SetAsDateTimes(AIndex, ADSQLTimeStamp2DateTime(AValue));
{$ENDIF}
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsSQLTimeStamps(AIndex: Integer): TADSQLTimeStamp;
var
  pVar: PVariant;
begin
{$IFDEF AnyDAC_D6}
  if IsNulls[AIndex] then
    Result := NullSQLTimeStamp
  else begin
    GetVarData(pVar, AIndex);
    Result := ADVar2SQLTimeStamp(pVar^);
  end;
{$ELSE}
  if IsNulls[AIndex] then
    ADFillChar(Result, SizeOf(Result), 0)
  else begin
    GetVarData(pVar, AIndex);
    Result := ADDateTime2SQLTimeStamp(pVar^);
  end;
{$ENDIF}
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsSQLTimeInterval(const AValue: TADSQLTimeInterval);
begin
  SetAsSQLTimeIntervals(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsSQLTimeInterval: TADSQLTimeInterval;
begin
  Result := GetAsSQLTimeIntervals(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsSQLTimeIntervals(AIndex: Integer; const AValue: TADSQLTimeInterval);
begin
{$IFDEF AnyDAC_D6}
  {$IFDEF AnyDAC_D10}
  FDataType := ftOraInterval;
  {$ELSE}
  FDataType := ftParadoxOle;
  {$ENDIF}
  Values[AIndex] := ADVarSQLTimeIntervalCreate(AValue);
{$ELSE}
  SetAsStrings(AIndex, ADSQLTimeInterval2Str(AValue));
{$ENDIF}
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsSQLTimeIntervals(AIndex: Integer): TADSQLTimeInterval;
var
  pVar: PVariant;
begin
{$IFDEF AnyDAC_D6}
  if IsNulls[AIndex] then
    Result := C_NullSQLTimeInterval
  else begin
    GetVarData(pVar, AIndex);
    Result := ADVar2SQLTimeInterval(pVar^);
  end;
{$ELSE}
  if IsNulls[AIndex] then
    ADFillChar(Result, SizeOf(Result), 0)
  else begin
    GetVarData(pVar, AIndex);
    Result := ADStr2SQLTimeInterval(pVar^);
  end;
{$ENDIF}
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsShortInt(const AValue: LongInt);
begin
  SetAsShortInts(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsShortInts(AIndex: Integer; const AValue: LongInt);
begin
  FDataType := {$IFDEF AnyDAC_D12} ftShortint {$ELSE} ftSmallInt {$ENDIF};
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsByte(const AValue: LongWord);
begin
  SetAsBytes(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBytes(AIndex: Integer; const AValue: LongWord);
begin
  FDataType := {$IFDEF AnyDAC_D12} ftByte {$ELSE} ftWord {$ENDIF};
  Values[AIndex] := {$IFDEF AnyDAC_D5} Integer(AValue) {$ELSE} AValue {$ENDIF};
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsSmallInt(const AValue: LongInt);
begin
  SetAsSmallInts(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsSmallInts(AIndex: Integer; const AValue: LongInt);
begin
  FDataType := ftSmallint;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsWord(const AValue: LongWord);
begin
  SetAsWords(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsWords(AIndex: Integer; AValue: LongWord);
begin
  FDataType := ftWord;
  Values[AIndex] := {$IFDEF AnyDAC_D5} Integer(AValue) {$ELSE} AValue {$ENDIF};
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsInteger(const AValue: Longint);
begin
  SetAsIntegers(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsInteger: Longint;
begin
  Result := GetAsIntegers(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsIntegers(AIndex: Integer; const AValue: Longint);
begin
  FDataType := ftInteger;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsIntegers(AIndex: Integer): Longint;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsLongWord: LongWord;
begin
  Result := GetAsLongWords(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsLongWord(const AValue: LongWord);
begin
  SetAsLongWords(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsLongWords(AIndex: Integer): LongWord;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsLongWords(AIndex: Integer; const AValue: LongWord);
begin
  FDataType := {$IFDEF AnyDAC_D12} ftLongWord {$ELSE} ftInteger {$ENDIF};
  Values[AIndex] := {$IFDEF AnyDAC_D5} Integer(AValue) {$ELSE} AValue {$ENDIF};
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsLargeInt: LargeInt;
begin
  Result := GetAsLargeInts(-1);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsLargeInts(AIndex: Integer): LargeInt;
var
  pVar: PVariant;
{$IFNDEF AnyDAC_D6Base}
  iVal: Integer;
{$ENDIF}
begin
  if IsNulls[AIndex] then
    Result := 0
  else begin
    GetVarData(pVar, AIndex);
{$IFDEF AnyDAC_D6Base}
    Result := pVar^;
{$ELSE}
    if TVarData(pVar^).VType = varInt64 then
      Result := Decimal(pVar^).lo64
    else begin
      iVal := pVar^;
      Result := iVal;
    end;
{$ENDIF}
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsLargeInt(const AValue: LargeInt);
begin
  SetAsLargeInts(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsLargeInts(AIndex: Integer; const AValue: LargeInt);
{$IFNDEF AnyDAC_D6Base}
var
  v64: Variant;
{$ENDIF}
begin
  FDataType := ftLargeint;
{$IFDEF AnyDAC_D6Base}
  Values[AIndex] := AValue;
{$ELSE}
  TVarData(v64).VType := varInt64;
  Decimal(v64).lo64 := AValue;
  Values[AIndex] := v64;
{$ENDIF}
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsString(const AValue: String);
begin
  SetAsStrings(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsString: String;
begin
  Result := GetAsStrings(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsStrings(AIndex: Integer; const AValue: String);
begin
  if not (FDataType in [ftString, ftFixedChar
                        {$IFDEF AnyDAC_Unicode}, ftWideString
                        {$IFDEF AnyDAC_WideMemo}, ftFixedWideChar {$ENDIF} {$ENDIF}]) then
    FDataType := ftString;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsStrings(AIndex: Integer): String;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := ''
  else if DataType = ftBoolean then begin
    if Values[AIndex] then
      Result := S_AD_True
    else
      Result := S_AD_False;
  end
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsFixedChar(const AValue: String);
begin
  SetAsFixedChars(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsFixedChars(AIndex: Integer; const AValue: String);
begin
  if not (FDataType in [ftString, ftFixedChar
                        {$IFDEF AnyDAC_Unicode}, ftWideString
                        {$IFDEF AnyDAC_WideMemo}, ftFixedWideChar {$ENDIF} {$ENDIF}]) then
    FDataType := ftFixedChar;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsAnsiString: TADAnsiString;
begin
  Result := GetAsAnsiStrings(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsAnsiString(const AValue: TADAnsiString);
begin
  SetAsAnsiStrings(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsAnsiStrings(AIndex: Integer): TADAnsiString;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := ''
  else if DataType = ftBoolean then begin
    if Values[AIndex] then
      Result := S_AD_True
    else
      Result := S_AD_False;
  end
  else begin
    GetVarData(pVar, AIndex);
    Result := TADAnsiString(pVar^);
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsAnsiStrings(AIndex: Integer; const AValue: TADAnsiString);
begin
  if not (FDataType in [ftString, ftFixedChar]) then
    FDataType := ftString;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsWideString: TADWideString;
begin
  Result := GetAsWideStrings(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsWideString(const AValue: TADWideString);
begin
  SetAsWideStrings(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsWideStrings(AIndex: Integer): TADWideString;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := ''
  else begin
    GetVarData(pVar, AIndex);
    Result := pVar^;
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsWideStrings(AIndex: Integer; const AValue: TADWideString);
begin
  if not (DataType in [ftWideString {$IFDEF AnyDAC_WideMemo}, ftFixedWideChar {$ENDIF}]) then
    DataType := ftWideString;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsXML(const AValue: TADWideString);
begin
  SetAsXMLs(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsXMLs(AIndex: Integer; const AValue: TADWideString);
begin
  DataType := ftDBaseOle;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsDate(const AValue: TDateTime);
begin
  SetAsDates(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsDates(AIndex: Integer; const AValue: TDateTime);
begin
  FDataType := ftDate;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsTime(const AValue: TDateTime);
begin
  SetAsTimes(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsTimes(AIndex: Integer; const AValue: TDateTime);
begin
  FDataType := ftTime;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsDateTime(const AValue: TDateTime);
begin
  SetAsDateTimes(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsDateTime: TDateTime;
begin
  Result := GetAsDateTimes(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsDateTimes(AIndex: Integer; const AValue: TDateTime);
begin
  FDataType := ftDateTime;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsDateTimes(AIndex: Integer): TDateTime;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    Result := 0.0
  else begin
    GetVarData(pVar, AIndex);
    Result := VarToDateTime(pVar^);
  end;
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsGUID: TGUID;
begin
  Result := GetAsGUIDs(-1);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsGUIDs(AIndex: Integer): TGUID;
var
  pVar: PVariant;
begin
  if IsNulls[AIndex] then
    ADFillChar(Result, SizeOf(TGUID), 0)
  else begin
    GetVarData(pVar, AIndex);
    Result := StringToGUID(VarToStr(pVar^));
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsGUID(const AValue: TGUID);
begin
  SetAsGUIDs(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsGUIDs(AIndex: Integer; const AValue: TGUID);
begin
  DataType := ftGuid;
  Values[AIndex] := GUIDToString(AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsVariant(const AValue: Variant);
begin
  SetAsVariants(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.InternalSetValue(AIndex: Integer; const AValue: Variant);
var
  iLen: Integer;
  pData: PVarData;

  procedure ErrorValueToLong;
  begin
    ADException(Self, [S_AD_LStan], er_AD_StanParamOverflow, [DisplayName, iLen, Size]);
  end;

begin
  if (Size > 0) and
     (DataType in [ftWideString, ftFmtMemo, ftString, ftFixedChar, ftMemo,
                   ftOraClob, ftADT, ftBytes, ftVarBytes, ftBlob, ftOraBlob
                   {$IFDEF AnyDAC_WideMemo}, ftWideMemo, ftFixedWideChar {$ENDIF},
                   ftDBaseOle]) then begin
    pData := FindVarData(AValue);
    case pData^.VType of
{$IFNDEF NEXTGEN}
    varString:
      begin
        iLen := Length(AnsiString(pData^.VString));
        if iLen > Size then
          ErrorValueToLong;
      end;
{$ENDIF}
    varOleStr:
      begin
        iLen := ADWideStrLen(pData^.VOleStr);
        if iLen > Size then
          ErrorValueToLong;
      end;
{$IFDEF AnyDAC_D12}
    varUString:
      begin
        iLen := Length(UnicodeString(pData^.VUString));
        if iLen > Size then
          ErrorValueToLong;
      end;
{$ENDIF}
    varArray or varByte:
      begin
        iLen := VarArrayHighBound(AValue, 1) + 1;
        if iLen > Size then
          ErrorValueToLong;
      end;
    end;
  end;
  FValue[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsVariants(AIndex: Integer; const AValue: Variant);
var
  tp: TVarType;
begin
  CheckIndex(AIndex);
  if ArrayType = atScalar then
    FBound := not VarIsEmpty(AValue)
  else
    FBound := True;
  tp := FindVarData(AValue)^.VType;
  if FDataType = ftUnknown then
    case tp of
{$IFDEF AnyDAC_D6Base}
      varShortInt:
        FDataType := {$IFDEF AnyDAC_D12} ftShortint {$ELSE} ftSmallInt {$ENDIF};
{$ENDIF}
      varByte:
        FDataType := {$IFDEF AnyDAC_D12} ftByte {$ELSE} ftSmallInt {$ENDIF};
      varSmallint:
        FDataType := ftSmallInt;
{$IFDEF AnyDAC_D6Base}
      varWord:
        FDataType := ftWord;
      varLongWord:
        FDataType := {$IFDEF AnyDAC_D12} ftLongWord {$ELSE} ftInteger {$ENDIF};
{$ENDIF}
      varInteger:
        FDataType := ftInteger;
      varCurrency:
        FDataType := ftCurrency;
      varSingle:
        FDataType := {$IFDEF AnyDAC_D14} ftSingle {$ELSE} ftFloat {$ENDIF};
      varDouble:
        FDataType := ftFloat;
      varDate:
        FDataType := ftDateTime;
      varBoolean:
        FDataType := ftBoolean;
{$IFDEF NEXTGEN}
      varArray or varByte,
{$ENDIF}
{$IFDEF AnyDAC_D12}
      varUString,
{$ENDIF}
      varString,
      varOleStr:
        if not (FDataType in [ftString, ftFixedChar
                              {$IFDEF AnyDAC_Unicode}, ftWideString
                              {$IFDEF AnyDAC_WideMemo}, ftFixedWideChar {$ENDIF} {$ENDIF}]) then
          FDataType := ftString;
{$IFNDEF NEXTGEN}
      varArray or varByte:
        FDataType := ftBlob;
{$ENDIF}
{$IFDEF AnyDAC_D12}
      varUInt64,
{$ENDIF}
{$IFDEF FPC}
      varqword,
{$ENDIF}
      varInt64:
        FDataType := ftLargeInt;
    else
{$IFDEF AnyDAC_D6Base}
      if tp = VarFMTBcd then
        FDataType := ftFMTBcd
      else
  {$IFDEF AnyDAC_D6}
      if tp = VarSQLTimeStamp then
        FDataType := ftTimeStamp
      else if tp = ADVarSQLTimeInterval then
        FDataType := {$IFDEF AnyDAC_D10} ftOraInterval {$ELSE} ftParadoxOle {$ENDIF}
      else
  {$ENDIF}
{$ENDIF}
        FDataType := ftUnknown;
    end;
  if not ((FDataType in [ftWideString, ftFmtMemo {$IFDEF AnyDAC_WideMemo}, ftWideMemo, ftFixedWideChar {$ENDIF}, ftDBaseOle]) or
          (FDataType = ftOraClob) and (FADDataType in [dtWideHMemo, dtWideMemo, dtXML])) and
         ((tp = varOleStr) {$IFDEF AnyDAC_D12} or (tp = varUString) {$ENDIF}) then
    InternalSetValue(AIndex, VarAsType(AValue, varADAString))
  else if ((FDataType in [ftWideString, ftFmtMemo {$IFDEF AnyDAC_WideMemo}, ftWideMemo, ftFixedWideChar {$ENDIF}, ftDBaseOle]) or
           (FDataType = ftOraClob) and (FADDataType in [dtWideHMemo, dtWideMemo, dtXML])) and
          (tp = varString) then
    InternalSetValue(AIndex, VarAsType(AValue, varADWString))
  else
    InternalSetValue(AIndex, AValue);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsVariant: Variant;
begin
  Result := GetAsVariants(-1);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.GetVarData(out AVar: PVariant; AIndex: Integer = -1);
begin
  CheckIndex(AIndex);
  AVar := @(FValue[AIndex]);
end;

{ ---------------------------------------------------------------------------- }
function TADParam.GetAsVariants(AIndex: Integer): Variant;
var
  pVar: PVariant;
  iLen: Integer;
  pRes, pSrc: Pointer;
begin
  GetVarData(pVar, AIndex);
  if VarType(pVar^) = (varArray or varByte) then begin
    iLen := VarArrayHighBound(pVar^, 1);
    Result := VarArrayCreate([0, iLen], varByte);
    pRes := VarArrayLock(Result);
    pSrc := VarArrayLock(pVar^);
    try
      Move(pSrc^, pRes^, iLen + 1);
    finally
      VarArrayUnlock(Result);
      VarArrayUnlock(pVar^);
    end;
  end
  else
    Result := pVar^;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsMemo(const AValue: TADAnsiString);
begin
  SetAsMemos(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsMemos(AIndex: Integer; const AValue: TADAnsiString);
begin
  if not (FDataType in [ftMemo, ftBlob, ftOraBlob, ftOraClob
                        {$IFDEF AnyDAC_WideMemo}, ftWideMemo {$ENDIF}]) then
    FDataType := ftMemo;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBlob(const AValue: TADByteString);
begin
  SetAsBlobs(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsBlobs(AIndex: Integer; const AValue: TADByteString);
begin
  if not (FDataType in [ftBlob, ftMemo, ftGraphic, ftFmtMemo, ftDBaseOle,
                        ftTypedBinary, ftOraBlob, ftOraClob
                        {$IFDEF AnyDAC_WideMemo}, ftWideMemo {$ENDIF}]) then
    FDataType := ftBlob;
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsWideMemo(const AValue: TADWideString);
begin
  SetAsWideMemos(-1, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetAsWideMemos(AIndex: Integer; const AValue: TADWideString);
begin
  FDataType := {$IFDEF AnyDAC_WideMemo} ftWideMemo {$ELSE} ftFmtMemo {$ENDIF};
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetText(const AValue: String);
begin
  SetTexts(0, AValue);
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.SetTexts(AIndex: Integer; const AValue: String);
begin
  Values[AIndex] := AValue;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.LoadFromFile(const FileName: String; BlobType: TBlobType;
  AIndex: Integer);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead);
  try
    LoadFromStream(Stream, BlobType, AIndex);
  finally
    ADFree(Stream);
  end;
end;

{ ---------------------------------------------------------------------------- }
procedure TADParam.LoadFromStream(Stream: TStream; BlobType: TBlobType;
  AIndex: Integer);
const
  CBufSize = $7FFF;
var
  iLen: LongInt;
  iRead: Integer;
begin
  BeginSetBlobRawData(AIndex);
  FDataType := BlobType;
  Stream.Position := 0;
  iLen := Stream.Size;
  if iLen < 0 then begin
    iLen := 0;
    repeat
      iRead := Stream.Read((EndSetBlobRawData(iLen + CBufSize, nil, AIndex) + iLen)^, CBufSize);
      Inc(iLen, iRead);
    until iRead < CBufSize;
    EndSetBlobRawData(iLen, nil, AIndex);
  end
  else
    Stream.ReadBuffer(EndSetBlobRawData(iLen, nil, AIndex)^, iLen);
end;

{ ---------------------------------------------------------------------------- }
{$IFDEF AnyDAC_D6Base}
initialization

  C_FieldType2VarType[ftFMTBcd] := VarFMTBcd;
  {$IFDEF AnyDAC_D6}
  C_FieldType2VarType[ftTimeStamp] := VarSQLTimeStamp;
  C_FieldType2VarType[{$IFDEF AnyDAC_D10} ftOraInterval {$ELSE} ftParadoxOle {$ENDIF}] := ADVarSQLTimeInterval;
  {$ENDIF}

{$ENDIF}

end.
