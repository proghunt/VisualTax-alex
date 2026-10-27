{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryExtra.pas                              }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryExtra;

{$I DebenuPDFLibraryDefines.inc}

interface

{$IFDEF VER120}
  {$DEFINE D4ORD5}
  {$DEFINE D4ORD5ORD6}
{$ENDIF}

{$IFDEF VER130}
  {$DEFINE D4ORD5}
  {$DEFINE D4ORD5ORD6}
{$ENDIF}

{$IFDEF VER140}
  {$DEFINE D4ORD5ORD6}
{$ENDIF}

{$IFDEF VER320}
  {$DEFINE QPL_NOVCL}
{$ENDIF}

{$IFDEF VER330}
  {$DEFINE QPL_NOVCL}
{$ENDIF}

uses
  Classes,
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  Macapi.Foundation,
  Posix.String_,
  Posix.Unistd,
{$ENDIF}
  SysUtils, DebenuPDFLibraryUnicode, DebenuPDFLibraryTypes;

{$IFDEF QPL_OS_MAC}
type
  TQuickPDFStringList = class(TStringList)
  protected
    FCaseSensitive: Boolean;
    function QGet(Index: Integer): AnsiString;
    procedure QPut(Index: Integer; const S: AnsiString);
    function QGetValue(const Name: AnsiString): AnsiString;
    procedure QSetValue(const Name, Value: AnsiString);
    procedure QSetTextStr(const Value: AnsiString);
    function QGetTextStr: AnsiString;
  public
    constructor Create; virtual;
    function Add(const S: AnsiString): Integer; reintroduce;
    function IndexOf(const S: AnsiString): Integer; reintroduce;
    procedure AddObject(const S: AnsiString; O: TObject); reintroduce;
    procedure Insert(Index: Integer; const S: AnsiString); reintroduce;
    property Text: AnsiString read QGetTextStr write QSetTextStr;
    property Strings[Index: Integer]: AnsiString read QGet write QPut; default;
    property Values[const Name: AnsiString]: AnsiString read QGetValue write QSetValue;
  end;

  TQuickPDFCaseSensitiveStringList = class(TQuickPDFStringList)
  protected
    function CompareStrings(const S1, S2: string): Integer; override;
  public
    constructor Create; override;
  end;

{$ENDIF}

{$IFNDEF QPL_OS_MAC}
type
  PQuickPDFStringItem = ^TQuickPDFStringItem;
  TQuickPDFStringItem = record
    FString: AnsiString;
    FObject: TObject;
  end;

  PQuickPDFStringItemList = ^TQuickPDFStringItemList;
  TQuickPDFStringItemList = array[0..0] of TQuickPDFStringItem;

  TQuickPDFStringList = class
  private
    FList: PQuickPDFStringItemList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FCaseSensitive: Boolean;
    FDuplicates: TDuplicates;
    function GetObject(Index: Integer): TObject;
    procedure PutObject(Index: Integer; AObject: TObject);
    function Get(Index: Integer): AnsiString;
    procedure Put(Index: Integer; const S: AnsiString);
    procedure SetSorted(Value: Boolean);
    function GetValue(const Name: AnsiString): AnsiString;
    procedure SetValue(const Name, Value: AnsiString);
    function GetTextStr: AnsiString;
    procedure SetTextStr(const Text: AnsiString);
    function GetCapacity: Integer;
    procedure SetCapacity(NewCapacity: Integer);
    function GetCount: Integer;
    procedure Grow;
    procedure InsertItem(Index: Integer; const S: AnsiString; AObject: TObject);
    function CompareStrings(const S1, S2: AnsiString): Integer;
    procedure QuickSort(L, R: Integer);
    procedure ExchangeItems(Index1, Index2: Integer);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function Add(const S: AnsiString): Integer;
    function IndexOf(const S: AnsiString): Integer;
    function IndexOfObject(AObject: TObject): Integer;
    function IndexOfName(const Name: AnsiString): Integer;
    procedure InsertObject(Index: Integer; const S: AnsiString; AObject: TObject);
    function AddObject(const S: AnsiString; AObject: TObject): Integer;
    procedure Clear;
    procedure AddStrings(Strings: TQuickPDFStringList);
    procedure Delete(Index: Integer);
    procedure Insert(Index: Integer; const S: AnsiString);
    procedure SaveToFile(const FileName: WideString);
    procedure SaveToStream(Stream: TStream);
    procedure Sort;
    function Find(const S: AnsiString; var Index: Integer): Boolean;
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
    property Count: Integer read GetCount;
    property Capacity: Integer read GetCapacity write SetCapacity;
    property Text: AnsiString read GetTextStr write SetTextStr;
    property Sorted: Boolean read FSorted write SetSorted;
    property Objects[Index: Integer]: TObject read GetObject write PutObject;
    property Strings[Index: Integer]: AnsiString read Get write Put; default;
    property Values[const Name: AnsiString]: AnsiString read GetValue write SetValue;
  end;
{$ENDIF}

  TQuickPDFIntegerList = class(TList)
  protected
    procedure Put(Index: Integer; Value: Integer);
    function Get(Index: Integer): Integer;
  public
    procedure Add(Value: Integer);
    function Find(Value: Integer): Boolean;
    function IndexOf(Value: Integer): Integer;
    procedure Insert(Index, Item: Integer);
    procedure SortList;
    procedure SortListReverse;
    property Items[Index: Integer]: Integer read Get write Put; default;
  end;

  TQuickPDFIntegerList2 = class
  private
    FValues: array of Integer;
    FValueCount: Integer;
    FContains: array of array[0..$FFFF] of Byte;
  public
    constructor Create;
    procedure Add(Value: Integer);
    function Contains(Value: Integer): Boolean;
    function GetValue(Index: Integer): Integer;
    property Count: Integer read FValueCount;
  end;

  TSortedNumberList = class
  private
    FNums: TQuickPDFIntegerList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Add(Num: Integer);
    procedure Sort;
    procedure SetCapacity(Capacity: Integer);
    function GetNextNum(Num: Integer): Integer;
    function Count: Integer;
    function GetItem(Index: Integer): Integer;
    procedure Clear;
    property Item[Index: Integer]: Integer read GetItem; default;
  end;

  TQPLSortedNumberList = class
  private
    FValues: array of Integer;
    FValueCount: Integer;
  public
    constructor Create;
    function GetNextNum(Value: Integer): Integer;
    function GetNumAt(Index: Integer): Integer;
    function Count: Integer;
    procedure Sort;
    procedure Add(Value: Integer);
  end;

  TQPLSortedInt64List = class
  private
    FValues: array of Int64;
    FValueCount: Integer;
  public
    constructor Create;
    function GetNextNum(Value: Int64): Int64;
    procedure Sort;
    procedure Add(Value: Int64);
  end;

  TQPLIntegerPairList = class
  private
    FKeys: array of Integer;
    FValues: array of Integer;
    FPairCount: Integer;
  public
    constructor Create;
    procedure Add(Key, Value: Integer);
    procedure Sort;
    function GetValue(Key: Integer): Integer;
  end;

  TQPLInt64PairList = class
  private
    FKeys: array of Int64;
    FValues: array of Int64;
    FPairCount: Integer;
  public
    constructor Create;
    procedure Add(Key, Value: Int64);
    procedure Sort;
    function GetValue(Key: Int64): Int64;
  end;

  TQPLWordPairList = class
  private
    FKeys: array of Word;
    FValues: array of Word;
    FPairCount: Integer;
    FFound: Boolean;
  public
    constructor Create;
    procedure Add(Key, Value: Word);
    procedure Sort;
    function GetValue(Key: Word): Word;
    property Count: Integer read FPairCount;
    property Found: Boolean read FFound;
  end;

  TQPLSortedUniqueIntegerList = class
  private
    FList: array of array of Boolean;
  public
    constructor Create;
    procedure Clear;
    function AddUnique(New: Integer): Boolean;
    function Contains(Number: Integer): Boolean;
  end;

{$IFDEF QPL_OS_MAC}
  TQuickPDFWideFileStream = class(TFileStream);
{$ELSE}
  TQuickPDFWideFileStream = class(TStream)
  protected
    FHandle: TQPLIntPtr;
    procedure SetSize(NewSize: Longint); override;
{$IFNDEF D4ORD5}
    procedure SetSize(const NewSize: Int64); override;
{$ENDIF}
  public
    constructor Create(const FileName: WideString; Mode: Word); overload;
    constructor Create(const FileName: WideString; Mode: Word; Rights: Cardinal); overload;
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
{$IFDEF D4ORD5}
    function Seek(Offset: Longint; Origin: Word): Longint; override;
{$ELSE}
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
{$ENDIF}
    property Handle: TQPLIntPtr read FHandle;
  end;
{$ENDIF}

  TQuickPDFCodeList = array of Word;
  TQuickPDFPageList = array of Integer;

function TazzToFloat(const S: AnsiString): Double;
procedure TazzToFloatVar(const S: AnsiString; var Result: Double);
function TazzIsFloat(S: AnsiString): Boolean;
function ExpToFloatVar(const S: AnsiString): Double;
function QPLDoubleToStrConst(Value: Double; Decimal: Integer): AnsiString;
function QPLDoubleToStr(var Value: Double; Decimal: Integer): AnsiString;
function QPLPaddedInt(Value, Digits: Integer): AnsiString;
function QPLPaddedInt64(Value: Int64; Digits: Integer): AnsiString;
function QPLPaddedDouble(var Value: Double; Digits, Decimal: Integer): AnsiString;
function GetPDFDateTime: AnsiString;
function MakePDFDateTime(D: TDateTime; UTC: Boolean = False): AnsiString;
function QPLPos(const Substr, S: AnsiString): Integer;
function QPLWideStringPos(const Substr, S: WideString): Integer;
function QPLTrim(const S: AnsiString): AnsiString;
function QPLWideStringTrim(const S: WideString): WideString;
function QPLStrToInt(const S: AnsiString): Integer;
function QPLIntToStr(Value: Integer): AnsiString;
function QPLInt64ToStr(Value: Int64): AnsiString;
function QPLStrToInt64Def(const S: AnsiString; Default: Int64): Int64;
function QPLStrToIntDef(const S: AnsiString; Default: Integer): Integer;
function QPLCopy(const S: AnsiString; Index, Count: Integer): AnsiString;
function QPLCopyW(const S: WideString; Index, Count: Integer): WideString;
function QPLEndsWith(const S1, S2: AnsiString): Boolean;
function QPLStartsWith(const S1, S2: AnsiString): Boolean;
function QPLEndsWithW(const S1, S2: WideString): Boolean;
function QPLStartsWithW(const S1, S2: WideString): Boolean;
function QPLFloatToStr(const Value: Extended): AnsiString;
function QPLFormatFloat(const Format: AnsiString; Value: Extended): AnsiString;
function QPLStrToFloat(const S: AnsiString): Extended;
function QPLFormatDateTime(const Format: AnsiString; Value: TDateTime): AnsiString;
function QPLUpperCase(const S: AnsiString): AnsiString;
function QPLLowerCase(const S: AnsiString): AnsiString;
function QPLIntToHex(Value, Digits: Integer): AnsiString;
function QPLStringReplace(const S, OldPattern, NewPattern: AnsiString; Flags: TReplaceFlags): AnsiString;
function QPLWideStringReplace(const S, OldPattern, NewPattern: WideString; Flags: TReplaceFlags): WideString;
function QPLFileExists(const FileName: WideString): Boolean;
function QPLDeleteFile(const FileName: WideString): Boolean;
function QPLExtractFileName(const FileName: WideString): WideString;
function QPLExtractFilePath(const FileName: WideString): WideString;
function QPLExtractFileExt(const FileName: WideString): WideString;
function QPLExpandFileName(const FileName: WideString): WideString;
function QPLChangeFileExt(const FileName, Extension: WideString): WideString;
function QPLCreateFileStream(const FileName: WideString; Mode: Word): TQuickPDFWideFileStream;
function QPLCanCreateFileStream(const FileName: WideString; Mode: Word): Boolean;
function QPLDirectoryExists(const Directory: WideString): Boolean;
function QPLWideStringToAnsiString(const WS: WideString): AnsiString;
function QPLAnsiStringToWideString(const S: AnsiString): WideString;
function QPLAnsiCompareStr(const S1, S2: AnsiString): Integer;
function QPLAnsiCompareText(const S1, S2: AnsiString): Integer;
procedure QPLWideStringInsert(Source: WideString; var S: WideString; Index: Integer);
function QPLAnsiToNative(const S: AnsiString): string;
function QPLNativeToAnsi(const S: string): AnsiString;
function QPLBoolToStr(B: Boolean): AnsiString;
function QPLStrToBool(const S: AnsiString): Boolean;
function QPLIsNan(const V: Single): Boolean; overload;
function QPLIsNan(const V: Double): Boolean; overload;
function QPLIsNan(const V: Extended): Boolean; overload;
function QPLSameValue(const A, B: Double): Boolean;
function QPLRandomID: AnsiString;
function QPLParsePageRangeList(const RangeList: AnsiString; FirstValidPage,
  LastValidPage: Integer; FailInvalidPages, FailInvalidChars,
  FailDuplicatePages, AllowDuplicatePages, SortList: Boolean): TQuickPDFPageList;
function QPLGetTempFolder: WideString;
function QPLMillisecondsSinceSystemTime(const EarlierSystemTime: TSystemTime;
  UTC: Boolean): Integer;
function DPLDivideWithRemainder(const A, B: Cardinal; var Remainder: Cardinal): Cardinal;
function DPLInt128Mod(Int128: TQuickPDFInt128; AValue: Cardinal): Cardinal;
function DPLXMPToWideString(const Input: AnsiString): WideString;
function GetTokCount(const Line: AnsiString; const Delim: AnsiChar): Integer;
function GetTok(const Line: AnsiString; const Delim: AnsiChar; const TokenNum: Byte): AnsiString;
function GetWideTokCount(const Line: WideString; const Delim: WideChar): Integer;
function GetWideTok(const Line: WideString; const Delim: WideChar; const TokenNum: Byte): WideString;
function DPLClassExists(const ClassName: WideString): Boolean;

{$IFNDEF QPL_OS_MAC}
type
  TQuickPDFCaseSensitiveStringList = class(TQuickPDFStringList)
  public
    constructor Create; override;
  end;
{$ENDIF}

{$IFDEF VER120}
type
  TObjectList = class(TList)
  private
    FOwnsObjects: Boolean;
  protected
    function GetItem(Index: Integer): TObject;
    procedure SetItem(Index: Integer; AObject: TObject);
  public
    constructor Create; overload;
    constructor Create(AOwnsObjects: Boolean); overload;

    function Add(AObject: TObject): Integer;
    function Remove(AObject: TObject): Integer;
    function IndexOf(AObject: TObject): Integer;
    function FindInstanceOf(AClass: TClass; AExact: Boolean = True; AStartAt: Integer = 0): Integer;
    procedure Insert(Index: Integer; AObject: TObject);
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
    property Items[Index: Integer]: TObject read GetItem write SetItem; default;
  end;
{$ENDIF}

type
  TPDFTextColor = record
    HexColor: AnsiString;
    Color: array of Double;
  end;

const
  PaperNames: array[1..49] of AnsiString = ('LETTER', 'LEGAL', 'STATEMENT',
    'TABLOID', 'LEDGER', 'EXECUTIVE', 'FOLIO', 'A0', 'A1', 'A2', 'A3', 'A4',
    'A5', 'A6', 'A7', 'A8', 'A9', 'A10', 'B0', 'B1', 'B2', 'B3', 'B4',
    'B5', 'B6', 'B7', 'B8', 'B9', 'B10', 'ISOB0', 'ISOB1', 'ISOB2', 'ISOB3',
    'ISOB4', 'ISOB5', 'ISOB6', 'ISOB7', 'ISOB8', 'ISOB9', 'ISOB10', 'C0',
    'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'DL');

  PaperWidths: array[1..49] of Double = (215.9, 215.9, 139.7, 279.4, 431.8,
    190.5, 210, 841, 594, 420, 297, 210, 148, 105, 74, 52, 37, 26,
    1030, 728, 515, 364, 257, 182, 128, 91, 64, 45, 32, 1000, 707, 500,
    353, 250, 176, 125, 88, 62, 44, 31, 917, 648, 458, 324, 229, 162, 114,
    81, 110);

  PaperHeights: array[1..49] of Double = (279.4, 355.6, 215.9, 431.8,
    279.4, 254, 330, 1189, 841, 594, 420, 297, 210, 148, 105, 74, 52, 37,
    1456, 1030, 728, 515, 364, 257, 182, 128, 91, 64, 45, 1414, 1000, 707, 500,
    353, 250, 176, 125, 88, 62, 44, 1297, 917, 648, 458, 324, 229, 162, 114,
    220);

function QPLUTF8Encode(const WS: WideString): AnsiString;
function QPLUTF8Decode(const S: AnsiString): WideString;
function QPLUTF8DecodeIgnore(const S: AnsiString): WideString;
function QPLUnicodeParm(const S: AnsiString): WideString;
function QPLLengthAdjustment(const WS: WideString): WideString;
procedure QPLStreamInsert(TargetStream: TStream; const NewData: AnsiString; Position: Integer);
function QPLValidUTF8(const S: AnsiString): Boolean;

{$IFDEF D4ORD5}
const
  soBeginning = soFromBeginning;
  soCurrent = soFromCurrent;
{$ENDIF}

implementation

uses
{$IFDEF UNICODE}
  {$IFNDEF QPL_CPP}
  AnsiStrings,
  {$ENDIF}
{$ENDIF}
{$IFDEF QPL_OS_WINDOWS}
  ActiveX,
{$ENDIF}
  Math, DebenuPDFLibraryFontConst, DebenuPDFLibraryDigest, DebenuPDFLibraryEncoding;


// Check if the string is in UTF-16BE with BOM format. If not
// then assume it is in UTF-8 format. Convert both to
// UTF-16LE without BOM
function QPLUnicodeParm(const S: AnsiString): WideString;
var
  IsUTF16BE: Boolean;
  UTF16BE: WideString;
begin
  IsUTF16BE := False;
  if (Length(S) >= 2) then
  begin
    // UTF-16BE with BOM starts with <FE> <FF>
    if (Byte(S[1]) = 254) and (Byte(S[2]) = 255) then
    begin
      IsUTF16BE := True;
    end;
  end;

  if IsUTF16BE then
  begin
    if Length(S) mod 2 = 1 then
    begin
      // There isn't a muliple of two bytes
      SetLength(UTF16BE, Length(S) div 2 + 1);
      FillChar(UTF16BE[1], Length(UTF16BE) * 2, 0);
    end else
    begin
      // Input is a multiple of two bytes
      SetLength(UTF16BE, Length(S) div 2);
    end;
    Move(S[1], UTF16BE[1], Length(S));
    QPLUnicodeConvert16To16(
      UTF16BE,             // Input buffer
      Result,              // Output buffer
      QPLUnicodeUTF16BE,   // Input is in UTF-16BE format
      QPLUnicodeUTF16LE,   // Output should be in UTF-16LE format
      QPLUnicodeStrip,     // Strip any BOM and don't add one to the output
      QPLUnicodeMark);     // Use U+FFFD for invalid sequences
  end else
  begin
    // Input isn't UTF-16BE with BOM, assume it is UTF-8
    Result := QPLUTF8Decode(S);
  end;
end;

// Convert a UTF-8 encoded string to UTF-16LE
//   - without a byte order marker
//   - with U+FFFD for invalid characters
function QPLUTF8Decode(const S: AnsiString): WideString;
begin
  QPLUnicodeConvert8To16(
    S,                   // Input buffer
    Result,              // Output buffer
    QPLUnicodeUTF8,      // Input is in UTF-8 format
    QPLUnicodeUTF16LE,   // Output should be in UTF-16LE format
    QPLUnicodeStrip,     // Strip any BOM and don't add one to the output
    QPLUnicodeMark);     // Use U+FFFD for invalid sequences
end;

// Convert a UTF-8 encoded string to UTF-16LE
//   - without a byte order marker
//   - with U+FFFD for invalid characters
function QPLUTF8DecodeIgnore(const S: AnsiString): WideString;
begin
  QPLUnicodeConvert8To16(
    S,                   // Input buffer
    Result,              // Output buffer
    QPLUnicodeUTF8,      // Input is in UTF-8 format
    QPLUnicodeUTF16LE,   // Output should be in UTF-16LE format
    QPLUnicodeStrip,     // Strip any BOM and don't add one to the output
    QPLUnicodeIgnore);     // Use U+FFFD for invalid sequences
end;


function QPLValidUTF8(const S: AnsiString): Boolean;
var
  Temp: WideString;
begin
  Result := QPLUnicodeConvert8To16(
    S,                   // Input buffer
    Temp,                // Output buffer
    QPLUnicodeUTF8,      // Input is in UTF-8 format
    QPLUnicodeUTF16LE,   // Output should be in UTF-16LE format
    QPLUnicodeStrip,     // Strip any BOM and don't add one to the output
    QPLUnicodeEmpty);    // Empty result
end;

function QPLUTF8Encode(const WS: WideString): AnsiString;
begin
  QPLUnicodeConvert16To8(QPLLengthAdjustment(WS), Result, QPLUnicodeUTF16LE,
    QPLUnicodeUTF8, QPLUnicodeStrip, QPLUnicodeMark);
end;

function TazzQPLAnsiCompareStr(const S1, S2: AnsiString): Integer;
begin
{$IFNDEF QPL_OS_WINDOWS}
{$IFDEF QPL_CPP}
  Result := 0;
{$ELSE}
  Result := AnsiCompareStr(S1, S2);
{$ENDIF}
{$ELSE}
  Result := CompareStringA(LOCALE_USER_DEFAULT, 0, PAnsiChar(S1), Length(S1),
    PAnsiChar(S2), Length(S2)) - 2;
{$ENDIF}
end;

function TazzQPLAnsiCompareText(const S1, S2: AnsiString): Integer;
begin
{$IFNDEF QPL_OS_WINDOWS}
{$IFDEF QPL_CPP}
  Result := 0;
{$ELSE}
  Result := AnsiCompareText(S1, S2);
{$ENDIF}
{$ELSE}
  Result := CompareStringA(LOCALE_USER_DEFAULT, NORM_IGNORECASE, PAnsiChar(S1),
    Length(S1), PAnsiChar(S2), Length(S2)) - 2;
{$ENDIF}
end;

function TazzToFloat(const S: AnsiString): Double;
begin
  TazzToFloatVar(S, Result);
end;

procedure TazzToFloatVar(const S: AnsiString; var Result: Double);
var
  Neg: Boolean;
  P, N, L: Integer;
  F: Double;
begin
  P := 1;
  Result := 0.0;
  Neg := false;
  F:= 0;
  N := 0;
  L := Length(S);

  if (L > 0) then
  begin
    while (S[P] = ' ') do     // D13732 - FontRasterizer passes in ' 89'.
      Inc(P);

    while (S[P] = '-') do     // D13861 : Oracle '--180.32'
    begin
      Neg := True;
      Inc(P);
    end;

    while (P <= L) and (S[P] >= '0') and (S[P] <= '9') do
    begin
      Result := (Result * 10.0) + (Ord(S[P]) - Ord('0'));
      Inc(P);
    end;

    if (P <= L) and (S[P] = '.') then
    begin
      Inc(P);
      while (P <= L) and (S[P] >= '0') and (S[P] <= '9') do
      begin
        F := (F*10.0) + (Ord(S[P]) - Ord('0'));
        Inc(P);
        Inc(N);
      end;
      Result := Result + F / Power(10.0, N);
    end;
    if (Neg) then
      Result := -Result;
    end;
end;

{
procedure TazzToFloatVar(const S: AnsiString; var Result: Double);
var
  P: Integer;
  R: AnsiString;
begin
  if TazzIsFloat(S) then
  begin
    P := QPLPos('.', S);
    if P > 0 then
    begin
      R := QPLCopy(S, P + 1, 9);

      if (Length(S) >= 2) and (S[1] = '-') and (S[2] = '-') then
        Result := QPLStrToInt64Def(QPLCopy(S, 2, P - 2), 0)   // D13861 : Oracle '--180.32'
      else
        Result := QPLStrToInt64Def(QPLCopy(S, 1, P - 1), 0);

      if Result < 0 then Result := -Result;
      Result := Result + QPLStrToInt64Def(R, 0) / Power(10, Length(R));
      if QPLPos('-', S) > 0 then Result := -Result;
    end else
    begin
      Result := QPLStrToInt64Def(S, 0);
    end;
  end else
    Result := 0;
end;
}

function TazzIsFloat(S: AnsiString): Boolean;
var
  X: Integer;
  P: Integer;
  GotDot: Boolean;
const
  Valid: AnsiString = '0123456789.-';
begin
  Result := True;
  GotDot := False;
  S := QPLTrim(S);
  P := QPLPos('-', S);
  if (P > 1) then
  begin
    Result := False;
  end else
  begin
    for X := 1 to Length(S) do
    begin
      P := QPLPos(S[X], Valid);
      if GotDot and (P = 11) then Result := False;
      if P = 11 then GotDot := True;
      if P < 1 then Result := False;
    end;
  end;
end;

function ExpToFloatVar(const S: AnsiString): Double;
var
  P: Integer;
  S1, S2: AnsiString;
  V2: Integer;
begin
  Result := 0.0;

  P := QPLPos('E', S);
  if (P  > 0) then
  begin

    S1 := QPLCopy(S, 1, P -1);
    S2 := QPLCopy(S, P+1, Length(S) - P);

    Result := TazzToFloat(S1);
    V2 := QPLStrToInt64Def(S2, 0);

    if (V2 <> 0) then
      Result := Result * Power(10, V2);
  end;
end;

{$IFDEF VER120}
function TObjectList.Add(AObject: TObject): Integer;
begin
  Result := inherited Add(AObject);
end;

constructor TObjectList.Create;
begin
  inherited Create;
  FOwnsObjects := True;
end;

constructor TObjectList.Create(AOwnsObjects: Boolean);
begin
  inherited Create;
  FOwnsObjects := AOwnsObjects;
end;

function TObjectList.FindInstanceOf(AClass: TClass; AExact: Boolean;
  AStartAt: Integer): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := AStartAt to Count - 1 do
    if (AExact and
        (Items[I].ClassType = AClass)) or
       (not AExact and
        Items[I].InheritsFrom(AClass)) then
    begin
      Result := I;
      break;
    end;
end;

function TObjectList.GetItem(Index: Integer): TObject;
begin
  Result := inherited Items[Index];
end;

function TObjectList.IndexOf(AObject: TObject): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

procedure TObjectList.Insert(Index: Integer; AObject: TObject);
begin
  inherited Insert(Index, AObject);
end;

function TObjectList.Remove(AObject: TObject): Integer;
begin
  Result := inherited Remove(AObject);
end;

procedure TObjectList.SetItem(Index: Integer; AObject: TObject);
begin
  inherited Items[Index] := AObject;
end;
{$ENDIF}

function MakePDFDateTime(D: TDateTime; UTC: Boolean): AnsiString;
var
  TZ: TTimeZoneInformation;
  BiasMins: Integer;
begin
  BiasMins := 0;
  case GetTimeZoneInformation(TZ) of
    TIME_ZONE_ID_UNKNOWN: BiasMins := -TZ.Bias;
    TIME_ZONE_ID_STANDARD: BiasMins := -TZ.Bias;
    TIME_ZONE_ID_DAYLIGHT: BiasMins := -(TZ.Bias + TZ.StandardBias + TZ.DaylightBias);
  end;
  if BiasMins = 0 then Result := 'Z' else
  begin
    if UTC then D := D + BiasMins / 1440;
    if BiasMins < 0 then
    begin
      Result := '-';
      BiasMins := -BiasMins;
    end;
    if BiasMins > 0 then Result := '+';
    Result := Result + QPLFormatFloat('00', (BiasMins div 60)) + #39;
    Result := Result + QPLFormatFloat('00', (BiasMins mod 60)) + #39;
  end;
  Result := 'D:' + QPLFormatDateTime('yyyymmdd', D) +
    QPLFormatDateTime('hhmmss', D) + Result;
end;

function GetPDFDateTime: AnsiString;
var
  TZ: TTimeZoneInformation;
  BiasMins: Integer;
begin
  BiasMins := 0;
  case GetTimeZoneInformation(TZ) of
    TIME_ZONE_ID_UNKNOWN: BiasMins := -TZ.Bias;
    TIME_ZONE_ID_STANDARD: BiasMins := -(TZ.Bias + TZ.StandardBias);
    TIME_ZONE_ID_DAYLIGHT: BiasMins := -(TZ.Bias + TZ.DaylightBias);        
  end;
  if BiasMins = 0 then Result := 'Z' else
  begin
    if BiasMins < 0 then
    begin
      Result := '-';
      BiasMins := -BiasMins;
    end;
    if BiasMins > 0 then Result := '+';
    Result := Result + QPLFormatFloat('00', (BiasMins div 60)) + #39;
    Result := Result + QPLFormatFloat('00', (BiasMins mod 60)) + #39;
  end;
  Result := 'D:' + QPLFormatDateTime('yyyymmdd', Now) +
    QPLFormatDateTime('hhmmss', Now) + Result;
end;

{$IFNDEF QPL_OS_MAC}
{ TQuickPDFCaseSensitiveStringList }

constructor TQuickPDFCaseSensitiveStringList.Create;
begin
  FCaseSensitive := True;
end;
{$ENDIF}

{ TQuickPDFIntegerList }

procedure TQuickPDFIntegerList.Put(Index: Integer; Value: Integer);
begin
  inherited Put(Index, Pointer(Value));
end;

function TQuickPDFIntegerList.Get(Index: Integer): Integer;
begin
  Result := Integer(inherited Get(Index));
end;

procedure TQuickPDFIntegerList.Add(Value: Integer);
begin
  inherited Add(Pointer(Value));
end;

function SortIntegers(i1, i2: Pointer): Integer;
begin
  Result := Integer(i1) - Integer(i2);
end;

procedure TQuickPDFIntegerList.SortList;
begin
  Sort(SortIntegers);
end;

function SortIntegersReverse(i1, i2: Pointer): Integer;
begin
  Result := Integer(i2) - Integer(i1);
end;

procedure TQuickPDFIntegerList.SortListReverse;
begin
  Sort(SortIntegersReverse);
end;

function TQuickPDFIntegerList.IndexOf( Value: Integer ): Integer;
begin
  Result := inherited IndexOf(Pointer(Value));
end;

function TQuickPDFIntegerList.Find( Value: Integer ): Boolean;
begin
  Result := (IndexOf(Value) >= 0);
end;

procedure TQuickPDFIntegerList.Insert(Index, Item: Integer);
begin
  inherited Insert(Index, Pointer(Item));
end;

{ TQuickPDFIntegerList2 }

constructor TQuickPDFIntegerList2.Create;
begin
  SetLength(FValues, 1000);
  FValueCount := 0;
  SetLength(FContains, 1);
  FillChar(FContains[0][0], 256, 0);
end;

procedure TQuickPDFIntegerList2.Add(Value: Integer);
var
  Key: Word;
  Offset: Word;
  OldSize: Integer;
  X: Integer;
begin
  if (FValueCount >= Length(FValues)) then
  begin
    SetLength(FValues, Length(FValues) * 2);
  end;
  FValues[FValueCount] := Value;
  Inc(FValueCount);
  Key := (Cardinal(Value) and $FFFF0000) shr 16;
  if ((Key + 1) > Length(FContains)) then
  begin
    OldSize := Length(FContains);
    SetLength(FContains, Key + 1);
    for X := OldSize to Key do
    begin
      FillChar(FContains[X][0], 256, 0);
    end;
  end;
  Offset := Value and $FFFF;
  FContains[Key][Offset] := 1;
end;

function TQuickPDFIntegerList2.Contains(Value: Integer): Boolean;
var
  Key: Word;
  Offset: Word;
begin
  Result := False;
  Key := (Cardinal(Value) and $FFFF0000) shr 16;
  if (Key < Length(FContains)) then
  begin
    Offset := Value and $FFFF;
    Result := FContains[Key][Offset] > 0;
  end;
end;

function TQuickPDFIntegerList2.GetValue(Index: Integer): Integer;
begin
  if ((Index >= 0) and (Index < FValueCount)) then
  begin
    Result := FValues[Index];
  end else
  begin
    Result := 0;
  end;
end;

{ TSortedNumberList }

procedure TSortedNumberList.Add(Num: Integer);
begin
  FNums.Add(Num);
end;

procedure TSortedNumberList.Clear;
begin
  FNums.Clear;
end;

function TSortedNumberList.Count: Integer;
begin
  Result := FNums.Count;
end;

constructor TSortedNumberList.Create;
begin
  FNums := TQuickPDFIntegerList.Create;
end;

destructor TSortedNumberList.Destroy;
begin
  FNums.Free;
  inherited;
end;

function TSortedNumberList.GetItem(Index: Integer): Integer;
begin
  Result := FNums[Index];
end;

function TSortedNumberList.GetNextNum(Num: Integer): Integer;
var
  X: Integer;
  Val1Third: Integer;
  X1Third: Integer;
  Val2Third: Integer;
  X2Third: Integer;
begin
  if FNums.Count > 0 then
  begin
    X1Third := FNums.Count div 2;
    X2Third := X1Third * 2;
    if X1Third >= FNums.Count then X1Third := FNums.Count - 1;
    if X2Third >= FNums.Count then X2Third := FNums.Count - 1;
    Val1Third := FNums[X1Third];
    Val2Third := FNums[X2Third];
    X := -1;
    if Num > Val1Third then X := X1Third - 1;
    if Num > Val2Third then X := X2Third - 1;
    repeat
      Inc(X);
      Result := FNums[X];
    until (FNums[X] > Num) or (X = FNums.Count - 1);
  end else
    Result := 0;
end;

procedure TSortedNumberList.SetCapacity(Capacity: Integer);
begin
  FNums.SetCapacity(Capacity);
end;

procedure TSortedNumberList.Sort;
begin
  FNums.SortList;
end;

{ TQPLSortedNumberList }

procedure TQPLSortedNumberList.Add(Value: Integer);
begin
  if (FValueCount >= Length(FValues)) then
  begin
    SetLength(FValues, Length(FValues) * 2);
  end;
  FValues[FValueCount] := Value;
  Inc(FValueCount);
end;

function TQPLSortedNumberList.Count: Integer;
begin
  Result := FValueCount;
end;

constructor TQPLSortedNumberList.Create;
begin
  SetLength(FValues, 1024);
  FValueCount := 0;
end;

function TQPLSortedNumberList.GetNextNum(Value: Integer): Integer;
var
  Min, Max: Integer;
  Mid: Integer;
begin
  Min := 0;
  Max := FValueCount;
  while (Min < Max) do
  begin
    Mid := Min + ((Max - Min) div 2);
    if (FValues[Mid] < Value) then
    begin
      Min := Mid + 1;
    end else
    begin
      Max := Mid;
    end;
  end;
  if (Min < (FValueCount - 1)) then
  begin
    if (FValues[Min] = Value) then
    begin
      repeat
        Inc(Min);
        Result := FValues[Min];
      until (Result <> Value) or (Min >= (FValueCount - 1));
    end else
    begin
      Result := FValues[Min];
    end;
  end else
  begin
    Result := FValues[FValueCount - 1];
  end;
end;

function TQPLSortedNumberList.GetNumAt(Index: Integer): Integer;
begin
  if (Index >= 0) and (Index < FValueCount) then
  begin
    Result := FValues[Index];
  end else
  begin
    Result := 0;
  end;
end;

procedure TQPLSortedNumberList.Sort;
var
  K: Integer;
  I: Integer;
  J: Integer;
  N: Integer;
  Temp: Integer;
begin
  N := FValueCount;
  K := N div 2;
  while K > 0 do
  begin
    for I := K to N - 1 do
    begin
      Temp := FValues[I];
      J := I;
      while (J >= K) and (FValues[J - K] > Temp) do
      begin
        FValues[J] := FValues[J - K];
        J := J - K;
      end;
      FValues[J] := Temp;
    end;
    K := Round(K / 2.2);
  end;
end;

{ TQPLSortedInt64List }

procedure TQPLSortedInt64List.Add(Value: Int64);
begin
  if (FValueCount >= Length(FValues)) then
  begin
    SetLength(FValues, Length(FValues) * 2);
  end;
  FValues[FValueCount] := Value;
  Inc(FValueCount);
end;

constructor TQPLSortedInt64List.Create;
begin
  SetLength(FValues, 1000);
  FValueCount := 0;
end;

function TQPLSortedInt64List.GetNextNum(Value: Int64): Int64;
var
  Min, Max: Integer;
  Mid: Integer;
begin
  Min := 0;
  Max := FValueCount;
  while (Min < Max) do
  begin
    Mid := Min + ((Max - Min) div 2);
    if (FValues[Mid] < Value) then
    begin
      Min := Mid + 1;
    end else
    begin
      Max := Mid;
    end;
  end;
  if (Min < (FValueCount - 1)) then
  begin
    if (FValues[Min] = Value) then
    begin
      repeat
        Inc(Min);
        Result := FValues[Min];
      until (Result <> Value) or (Min >= (FValueCount - 1));
    end else
    begin
      Result := FValues[Min];
    end;
  end else
  begin
    Result := FValues[FValueCount - 1];
  end;
end;

procedure TQPLSortedInt64List.Sort;
var
  K: Integer;
  I: Integer;
  J: Integer;
  N: Integer;
  Temp: Int64;
begin
  N := FValueCount;
  K := N div 2;
  while K > 0 do
  begin
    for I := K to N - 1 do
    begin
      Temp := FValues[I];
      J := I;
      while (J >= K) and (FValues[J - K] > Temp) do
      begin
        FValues[J] := FValues[J - K];
        J := J - K;
      end;
      FValues[J] := Temp;
    end;
    K := Round(K / 2.2);
  end;
end;

{ TQPLIntegerPairList }

procedure TQPLIntegerPairList.Add(Key, Value: Integer);
begin
  if (FPairCount >= Length(FValues)) then
  begin
    SetLength(FKeys, Length(FKeys) * 2);
    SetLength(FValues, Length(FValues) * 2);
  end;
  FKeys[FPairCount] := Key;
  FValues[FPairCount] := Value;
  Inc(FPairCount);
end;

constructor TQPLIntegerPairList.Create;
begin
  SetLength(FKeys, 1000);
  SetLength(FValues, 1000);
  FPairCount := 0;
end;

function TQPLIntegerPairList.GetValue(Key: Integer): Integer;
var
  Min, Max: Integer;
  Mid: Integer;
begin
  Min := 0;
  Max := FPairCount;
  while (Min < Max) do
  begin
    Mid := Min + ((Max - Min) div 2);
    if (FKeys[Mid] < Key) then
    begin
      Min := Mid + 1;
    end else
    begin
      Max := Mid;
    end;
  end;
  if ((Min < FPairCount) and (FKeys[Min] = Key)) then
  begin
    Result := FValues[Min];
  end else
  begin
    Result := 0;
  end;
end;

procedure TQPLIntegerPairList.Sort;
var
  K: Integer;
  I: Integer;
  J: Integer;
  N: Integer;
  TempKey: Integer;
  TempValue: Integer;
begin
  N := FPairCount;
  K := N div 2;
  while K > 0 do
  begin
    for I := K to N - 1 do
    begin
      TempKey := FKeys[I];
      TempValue := FValues[I];
      J := I;
      while (J >= K) and (FKeys[J - K] > TempKey) do
      begin
        FKeys[J] := FKeys[J - K];
        FValues[J] := FValues[J - K];
        J := J - K;
      end;
      FKeys[J] := TempKey;
      FValues[J] := TempValue;
    end;
    K := Round(K / 2.2);
  end;
end;

{ TQPLInt64PairList }

procedure TQPLInt64PairList.Add(Key, Value: Int64);
begin
  if (FPairCount >= Length(FValues)) then
  begin
    SetLength(FKeys, Length(FKeys) * 2);
    SetLength(FValues, Length(FValues) * 2);
  end;
  FKeys[FPairCount] := Key;
  FValues[FPairCount] := Value;
  Inc(FPairCount);
end;

constructor TQPLInt64PairList.Create;
begin
  SetLength(FKeys, 1000);
  SetLength(FValues, 1000);
  FPairCount := 0;
end;

function TQPLInt64PairList.GetValue(Key: Int64): Int64;
var
  Min, Max: Integer;
  Mid: Integer;
begin
  Min := 0;
  Max := FPairCount;
  while (Min < Max) do
  begin
    Mid := Min + ((Max - Min) div 2);
    if (FKeys[Mid] < Key) then
    begin
      Min := Mid + 1;
    end else
    begin
      Max := Mid;
    end;
  end;
  if ((Min < FPairCount) and (FKeys[Min] = Key)) then
  begin
    Result := FValues[Min];
  end else
  begin
    Result := 0;
  end;
end;

procedure TQPLInt64PairList.Sort;
var
  K: Integer;
  I: Integer;
  J: Integer;
  N: Integer;
  TempKey: Int64;
  TempValue: Int64;
begin
  N := FPairCount;
  K := N div 2;
  while K > 0 do
  begin
    for I := K to N - 1 do
    begin
      TempKey := FKeys[I];
      TempValue := FValues[I];
      J := I;
      while (J >= K) and (FKeys[J - K] > TempKey) do
      begin
        FKeys[J] := FKeys[J - K];
        FValues[J] := FValues[J - K];
        J := J - K;
      end;
      FKeys[J] := TempKey;
      FValues[J] := TempValue;
    end;
    K := Round(K / 2.2);
  end;
end;

{ TQPLWordPairList }

procedure TQPLWordPairList.Add(Key, Value: Word);
begin
  if (FPairCount >= Length(FValues)) then
  begin
    SetLength(FKeys, Length(FKeys) * 2);
    SetLength(FValues, Length(FValues) * 2);
  end;
  FKeys[FPairCount] := Key;
  FValues[FPairCount] := Value;
  Inc(FPairCount);
end;

constructor TQPLWordPairList.Create;
begin
  SetLength(FKeys, 1000);
  SetLength(FValues, 1000);
  FPairCount := 0;
end;

function TQPLWordPairList.GetValue(Key: Word): Word;
var
  Min, Max: Integer;
  Mid: Integer;
begin
  FFound := True;
  Min := 0;
  Max := FPairCount;
  while (Min < Max) do
  begin
    Mid := Min + ((Max - Min) div 2);
    if (FKeys[Mid] < Key) then
    begin
      Min := Mid + 1;
    end else
    begin
      Max := Mid;
    end;
  end;
  if ((Min < FPairCount) and (FKeys[Min] = Key)) then
  begin
    Result := FValues[Min];
  end else
  begin
    Result := 0;
    FFound := False;
  end;
end;

procedure TQPLWordPairList.Sort;
var
  K: Integer;
  I: Integer;
  J: Integer;
  N: Integer;
  TempKey: Word;
  TempValue: Word;
begin
  N := FPairCount;
  K := N div 2;
  while K > 0 do
  begin
    for I := K to N - 1 do
    begin
      TempKey := FKeys[I];
      TempValue := FValues[I];
      J := I;
      while (J >= K) and (FKeys[J - K] > TempKey) do
      begin
        FKeys[J] := FKeys[J - K];
        FValues[J] := FValues[J - K];
        J := J - K;
      end;
      FKeys[J] := TempKey;
      FValues[J] := TempValue;
    end;
    K := Round(K / 2.2);
  end;
end;

{$IFNDEF QPL_OS_MAC}
{ TQuickPDFStringList }

function TQuickPDFStringList.Add(const S: AnsiString): Integer;
begin
  Result := AddObject(S, nil);
end;

function TQuickPDFStringList.AddObject(const S: AnsiString;
  AObject: TObject): Integer;
var
  CanAdd: Boolean;
begin
  if Sorted then
  begin
    CanAdd := True;
    if Find(S, Result) then
    begin
      if Duplicates = dupIgnore then CanAdd := False;
    end;
  end else
  begin
    Result := FCount;
    CanAdd := True;
  end;
  if CanAdd then
    InsertItem(Result, S, AObject);
end;

procedure TQuickPDFStringList.AddStrings(Strings: TQuickPDFStringList);
var
  X: Integer;
begin
  for X := 0 to Strings.FCount - 1 do
    AddObject(Strings[X], Strings.Objects[X]);
end;

procedure TQuickPDFStringList.Clear;
begin
{$R-}
  if FCount <> 0 then
  begin
    Finalize(FList^[0], FCount);
    FCount := 0;
    SetCapacity(0);
  end;
end;

function TQuickPDFStringList.CompareStrings(const S1, S2: AnsiString): Integer;
begin
  if FCaseSensitive then
    Result := QPLAnsiCompareStr(S1, S2)
  else
    Result := QPLAnsiCompareText(S1, S2);
end;

constructor TQuickPDFStringList.Create;
begin
  inherited;
  FCaseSensitive := False;
end;

procedure TQuickPDFStringList.Delete(Index: Integer);
begin
{$R-}
  if (Index >= 0) and (Index < FCount) then
  begin
    Finalize(FList^[Index]);
    Dec(FCount);
    if Index < FCount then
      System.Move(FList^[Index + 1], FList^[Index],
        (FCount - Index) * SizeOf(TQuickPDFStringItem));
  end;
end;

destructor TQuickPDFStringList.Destroy;
begin
{$R-}
  inherited Destroy;
  if FCount <> 0 then Finalize(FList^[0], FCount);
  FCount := 0;
  SetCapacity(0);
end;

{$IFDEF WIN64}
procedure TQuickPDFStringList.ExchangeItems(Index1, Index2: Integer);
var
  TempS: AnsiString;
  TempO: TObject;
  Item1, Item2: PQuickPDFStringItem;
begin
{$R-}
  Item1 := @FList^[Index1];
  Item2 := @FList^[Index2];
  TempS := Item1^.FString;
  TempO := Item1^.FObject;
  Item1^.FString := Item2^.FString;
  Item1^.FObject := Item2^.FObject;
  Item2^.FString := TempS;
  Item2^.FObject := TempO;
end;
{$ELSE}
procedure TQuickPDFStringList.ExchangeItems(Index1, Index2: Integer);
var
  Temp: TQPLIntPtr;
  Item1, Item2: PQuickPDFStringItem;
begin
{$R-}
  Item1 := @FList^[Index1];
  Item2 := @FList^[Index2];
  Temp := TQPLIntPtr(Item1^.FString);
  TQPLIntPtr(Item1^.FString) := TQPLIntPtr(Item2^.FString);
  TQPLIntPtr(Item2^.FString) := Temp;
  Temp := TQPLIntPtr(Item1^.FObject);
  TQPLIntPtr(Item1^.FObject) := TQPLIntPtr(Item2^.FObject);
  TQPLIntPtr(Item2^.FObject) := Temp;
end;
{$ENDIF}

function TQuickPDFStringList.Find(const S: AnsiString;
  var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
{$R-}
  Result := False;
  L := 0;
  H := FCount - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := CompareStrings(FList^[I].FString, S);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;        
      end;
    end;
  end;
  Index := L;
end;

function TQuickPDFStringList.Get(Index: Integer): AnsiString;
begin
{$R-}
  Result := FList^[Index].FString;
end;

function TQuickPDFStringList.GetCapacity: Integer;
begin
  Result := FCapacity;
end;

function TQuickPDFStringList.GetCount: Integer;
begin
  Result := FCount;
end;

function TQuickPDFStringList.GetObject(Index: Integer): TObject;
begin
{$R-}
  if (Index >= 0) and (Index < FCount) then
    Result := FList^[Index].FObject
  else
    Result := nil;
end;

function TQuickPDFStringList.GetTextStr: AnsiString;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    SaveToStream(MS);
    SetLength(Result, MS.Size);
    MS.Seek(0, soFromBeginning);
    if Length(Result) > 0 then
      MS.Read(Result[1], Length(Result));
  finally
    MS.Free;
  end;
end;

function TQuickPDFStringList.GetValue(const Name: AnsiString): AnsiString;
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if I >= 0 then
    Result := QPLCopy(Get(I), Length(Name) + 2, MaxInt) else
    Result := '';
end;

procedure TQuickPDFStringList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then Delta := FCapacity div 4 else
    if FCapacity > 8 then Delta := 16 else
      Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TQuickPDFStringList.IndexOf(const S: AnsiString): Integer;
begin
  if Sorted then
  begin
    if not Find(S, Result) then Result := -1;
  end else
  begin
    if (FCaseSensitive and (Length(S) > 0)) then
    begin
      for Result := 0 to GetCount - 1 do
        if (Length(FList^[Result].FString) = 0) then
        begin
          if CompareStrings(Get(Result), S) = 0 then Exit;
        end else
        begin
          if (FList^[Result].FString[1] = S[1]) then
            if CompareStrings(Get(Result), S) = 0 then Exit;
        end;
    end else
    begin
      for Result := 0 to GetCount - 1 do
      begin
        if CompareStrings(Get(Result), S) = 0 then Exit;
      end;
    end;

    Result := -1;
  end;
end;

function TQuickPDFStringList.IndexOfName(const Name: AnsiString): Integer;
var
  P: Integer;
  S: AnsiString;
begin
  for Result := 0 to GetCount - 1 do
  begin
    S := Get(Result);
    P := QPLPos('=', S);
    if (P <> 0) and (CompareStrings(QPLCopy(S, 1, P - 1), Name) = 0) then Exit;
  end;
  Result := -1;
end;

function TQuickPDFStringList.IndexOfObject(AObject: TObject): Integer;
begin
{$R-}
  for Result := 0 to GetCount - 1 do
    if FList^[Result].FObject = AObject then Exit;
  Result := -1;
end;

procedure TQuickPDFStringList.Insert(Index: Integer; const S: AnsiString);
begin
  InsertObject(Index, S, nil);
end;

procedure TQuickPDFStringList.InsertItem(Index: Integer; const S: AnsiString; AObject: TObject);
begin
{$R-}
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TQuickPDFStringItem));
  with FList^[Index] do
  begin
    Pointer(FString) := nil;
    FObject := AObject;
    FString := S;
  end;
  Inc(FCount);
end;

procedure TQuickPDFStringList.InsertObject(Index: Integer; const S: AnsiString;
  AObject: TObject);
begin
  if (Index >= 0) and (Index <= FCount) then
    InsertItem(Index, S, AObject);
end;

procedure TQuickPDFStringList.Put(Index: Integer; const S: AnsiString);
begin
{$R-}
  if (Index >= 0) and (Index < FCount) then
    FList^[Index].FString := S;
end;

procedure TQuickPDFStringList.PutObject(Index: Integer; AObject: TObject);
begin
{$R-}
  if (Index >= 0) and (Index < FCount) then
    FList^[Index].FObject := AObject;
end;

procedure TQuickPDFStringList.QuickSort(L, R: Integer);
var
  I, J, P: Integer;
begin
{$R-}
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while CompareStrings(FList^[I].FString, FList^[P].FString) < 0 do Inc(I);
      while CompareStrings(FList^[J].FString, FList^[P].FString) > 0 do Dec(J);
      if I <= J then
      begin
        ExchangeItems(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    L := I;
  until I >= R;
end;

procedure TQuickPDFStringList.SaveToFile(const FileName: WideString);
var
  Stream: TStream;
begin
  Stream := QPLCreateFileStream(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TQuickPDFStringList.SaveToStream(Stream: TStream);
var
  X: Integer;
  S: AnsiString;
  CRLF: AnsiString;
begin
{$R-}
  CRLF := #13#10;
  for X := 0 to FCount - 1 do
  begin
    S := FList^[X].FString;
    Stream.WriteBuffer(Pointer(S)^, Length(S));
    Stream.WriteBuffer(Pointer(CRLF)^, 2);
  end;
end;

procedure TQuickPDFStringList.SetCapacity(NewCapacity: Integer);
begin
  ReallocMem(FList, NewCapacity * SizeOf(TQuickPDFStringItem));
  FCapacity := NewCapacity;
end;

procedure TQuickPDFStringList.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then Sort;
    FSorted := Value;
  end;
end;

procedure TQuickPDFStringList.SetTextStr(const Text: AnsiString);
var
  P, Start: Integer;
  S: AnsiString;
begin

  // Note : This function is desgined to add items to a stringList
  // that are delimited by CR or LF characters
  // This function is also called by TPDFXrefReader.FindXRefPos
  // so be very careful making any changes here.
  // It is also called by SetFormFieldValue for choice fields
  // to select multiple items
  // TEST1 : 'Text #$D#$A'237533'#$D#$A' -> '237533'
  // TEST2 : "1\n13\n\n26\n2\n3\n4")   -> '1','13','26','2','3','4'
  // TEST3 : "1\n13\n\n26\n2\n3\n4\n") -> '1','13','26','2','3','4'

  Clear;
  Start := 1;
  if Length(Text) > 0 then
  begin

    while (Start <= Length(Text)) do
    begin
      while (Text[Start] in [#0, #10, #13]) and (Start < Length(Text)) do Inc(Start);

      P := Start;
      while (not (Text[P] in [#0, #10, #13]) and (P <= Length(Text))) do Inc(P);

      S := QPLCopy(Text, Start, P - Start);

      if (P > Start) then   // make sure we don't add an empty string.
        Add(S);

      Start := P + 1;
    end;
  end
  else
    Add('');
end;

procedure TQuickPDFStringList.SetValue(const Name, Value: AnsiString);
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if Value <> '' then
  begin
    if I < 0 then I := Add('');
    Put(I, Name + '=' + Value);
  end else
  begin
    if I >= 0 then Delete(I);
  end;
end;

procedure TQuickPDFStringList.Sort;
begin
  if FCount > 1 then
    QuickSort(0, FCount - 1);  
end;
{$ENDIF}


{$IFDEF QPL_CPP}
const
  MAX_PATH: Integer = 4096;
{$ENDIF}

// Wide file name functions

function WideExpandFileName(const FileName: WideString): WideString;
var
  FName: PWideChar;
begin
  SetLength(Result, MAX_PATH);
  SetLength(Result, GetFullPathNameW(PWideChar(FileName), MAX_PATH, @Result[1], FName));
end;

function WideFileOpen(const FileName: WideString; Mode: LongWord): Integer;
const
  AccessMode: array[0..2] of LongWord = (
    GENERIC_READ,
    GENERIC_WRITE,
    GENERIC_READ or GENERIC_WRITE);
  ShareMode: array[0..4] of LongWord = (
    0,
    0,
    FILE_SHARE_READ,
    FILE_SHARE_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE);
begin
  Result := -1;
  if ((Mode and 3) <= fmOpenReadWrite) and
    ((Mode and $F0) <= fmShareDenyNone) then
  begin
    Result := TQPLIntPtr(CreateFileW(PWideChar(FileName), AccessMode[Mode and 3],
      ShareMode[(Mode and $F0) shr 4], nil, OPEN_EXISTING,
      FILE_ATTRIBUTE_NORMAL, 0));
  end;
end;

function WideFileCreate(const FileName: WideString): TQPLIntPtr; overload;
begin
  Result := TQPLIntPtr(CreateFileW(PWideChar(FileName), GENERIC_READ or GENERIC_WRITE,
    0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0));
end;

function WideFileCreate(const FileName: WideString; Rights: Integer): TQPLIntPtr; overload;
begin
  Result := WideFileCreate(FileName);
end;

function WideFileAge(const FileName: WideString): Integer;
{$IFNDEF QPL_OS_WINDOWS}
begin
  Result := 0;
end;
{$ELSE}
var
  Handle: THandle;
  FindData: TWin32FindDataW;
  LocalFileTime: TFileTime;
begin
  Handle := FindFirstFileW(PWideChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
      if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi,
        LongRec(Result).Lo) then Exit;
    end;
  end;
  Result := -1;
end;
{$ENDIF}

function WideFileExists(const FileName: WideString): Boolean;
{$IFNDEF QPL_OS_WINDOWS}
{$IFDEF QPL_OS_MAC}
begin
  Result := FileExists(FileName);
end;
{$ELSE}
begin
  Result := True;
end;
{$ENDIF}
{$ELSE}
var
  Handle: THandle;
  FindData: TWin32FindDataW;
begin
  Result := False;
  Handle := FindFirstFileW(PWideChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      Result := True;
    end;
  end;
end;
{$ENDIF}

function WideDirectoryExists(const Directory: WideString): Boolean;
{$IFNDEF QPL_OS_WINDOWS}
begin
  Result := True;
end;
{$ELSE}
var
  Code: Integer;
begin
  Code := GetFileAttributesW(PWideChar(Directory));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;
{$ENDIF}

// Compatibility functions

function QPLPos(const Substr, S: AnsiString): Integer;
begin
{$IFDEF UNICODE}
{$IFDEF QPL_CPP}
  Result := 0;
{$ELSE}
  Result := AnsiStrings.PosEx(SubStr, S);
{$ENDIF}
{$ELSE}
  Result := Pos(Substr, S);
{$ENDIF}
end;

function QPLTrim(const S: AnsiString): AnsiString;
begin
{$IFDEF UNICODE}
{$IFDEF QPL_CPP}
  Result := '';
{$ELSE}
  Result := AnsiStrings.Trim(S);
{$ENDIF}
{$ELSE}
  Result := Trim(S);
{$ENDIF}
end;

function QPLWideStringTrim(const S: WideString): WideString;
begin
  Result := S;
  while (Length(Result) > 0) and (Result[1] = WideChar(32)) do
    Delete(Result, 1, 1);
  while (Length(Result) > 0) and (Result[Length(Result)] = WideChar(32)) do
    Delete(Result, Length(Result), 1);
end;

function QPLCopy(const S: AnsiString; Index, Count: Integer): AnsiString;
begin
  Result := Copy(S, Index, Count);
end;

function QPLCopyW(const S: WideString; Index, Count: Integer): WideString;
begin
  Result := Copy(S, Index, Count);
end;

function QPLEndsWith(const S1, S2: AnsiString): Boolean;
var
  I: Integer;
  L1: Integer;
  L2: Integer;
begin
  L1 := Length(S1);
  L2 := Length(S2);

  if (L2 > L1) then
  begin
    Result := False;
  end else
  begin
    Result := True;
    I := 1;
    while (I <= L2) and Result do
    begin
      if (S1[L1 - L2 + I] <> S2[I]) then
      begin
        Result := False;
      end else
      begin
        Inc(I);
      end;
    end;
  end;
end;

function QPLStartsWith(const S1, S2: AnsiString): Boolean;
var
  I: Integer;
  L1: Integer;
  L2: Integer;
begin
  L1 := Length(S1);
  L2 := Length(S2);

  if (L2 > L1) then
  begin
    Result := False;
  end else
  begin
    Result := True;
    I := 1;
    while (I <= L2) and Result do
    begin
      if (S1[I] <> S2[I]) then
      begin
        Result := False;
      end else
      begin
        Inc(I);
      end;
    end;
  end;
end;

function QPLEndsWithW(const S1, S2: WideString): Boolean;
var
  I: Integer;
  L1: Integer;
  L2: Integer;
begin
  L1 := Length(S1);
  L2 := Length(S2);

  if (L2 > L1) then
  begin
    Result := False;
  end else
  begin
    Result := True;
    I := 1;
    while (I <= L2) and Result do
    begin
      if (S1[L1 - L2 + I] <> S2[I]) then
      begin
        Result := False;
      end else
      begin
        Inc(I);
      end;
    end;
  end;
end;

function QPLStartsWithW(const S1, S2: WideString): Boolean;
var
  I: Integer;
  L1: Integer;
  L2: Integer;
begin
  L1 := Length(S1);
  L2 := Length(S2);

  if (L2 > L1) then
  begin
    Result := False;
  end else
  begin
    Result := True;
    I := 1;
    while (I <= L2) and Result do
    begin
      if (S1[I] <> S2[I]) then
      begin
        Result := False;
      end else
      begin
        Inc(I);
      end;
    end;
  end;
end;


function QPLStrToInt(const S: AnsiString): Integer;
begin
  Result := StrToInt(QPLAnsiToNative(S));
end;

function QPLStrToInt64Def(const S: AnsiString; Default: Int64): Int64;
begin
  Result := StrToInt64Def(QPLAnsiToNative(S), Default);
end;

function QPLStrToIntDef(const S: AnsiString; Default: Integer): Integer;
begin
  Result := StrToIntDef(QPLAnsiToNative(S), Default);
end;

function QPLIntToHex(Value, Digits: Integer): AnsiString;
begin
  Result := AnsiString(IntToHex(Value, Digits));
end;

function QPLUpperCase(const S: AnsiString): AnsiString;
begin
  {$IFDEF UNICODE}
  Result := AnsiString(UpperCase(QPLAnsiToNative(S)));
  {$ELSE}
  Result := UpperCase(S);
  {$ENDIF}
end;

function QPLLowerCase(const S: AnsiString): AnsiString;
begin
  {$IFDEF UNICODE}
  Result := AnsiString(LowerCase(QPLAnsiToNative(S)));
  {$ELSE}
  Result := LowerCase(S);
  {$ENDIF}
end;

function QPLIntToStr(Value: Integer): AnsiString;
begin
  Result := AnsiString(IntToStr(Value));
end;

function QPLInt64ToStr(Value: Int64): AnsiString;
begin
  Result := AnsiString(IntToStr(Value));
end;

{$IFDEF UNICODE}
{$IFNDEF QPL_CPP}
function SearchAndReplace(sSrc, sLookFor, sReplaceWith: AnsiString): AnsiString;
var
  nPos, nLenLookFor: Integer;
begin
  nPos := PosEx(sLookFor, sSrc);
  nLenLookFor := Length(sLookFor);
  while (nPos > 0) do
  begin
    Delete(sSrc, nPos, nLenLookFor);
    Insert(sReplaceWith, sSrc, nPos);
    nPos := PosEx(sLookFor, sSrc, nPos + 1);
  end;
  Result := sSrc;
end;
{$ELSE}
function SearchAndReplace(sSrc, sLookFor, sReplaceWith: AnsiString): AnsiString;
begin

end;
{$ENDIF}
{$ENDIF}

function QPLStringReplace(const S, OldPattern, NewPattern: AnsiString; Flags: TReplaceFlags): AnsiString;
begin
  {$IFDEF UNICODE}
  Result := SearchAndReplace(S, OldPattern, NewPattern);
  {$ELSE}
  Result := StringReplace(S, OldPattern, NewPattern, Flags);
  {$ENDIF}
end;

{$IFDEF D4ORD5}
function WideUpperCase(const S: WideString): WideString;
var
  Len: Integer;
begin
  Len := Length(S);
  SetString(Result, PWideChar(S), Len);
  if Len > 0 then CharUpperBuffW(Pointer(Result), Len);
end;
{$ENDIF}

{$IFDEF QPL_CPP}
function WideUpperCase(const S: WideString): WideString;
begin
  Result := '';
end;
{$ENDIF}

function QPLWideStringReplace(const S, OldPattern, NewPattern: WideString; Flags: TReplaceFlags): WideString;
var
  SearchStr, Patt, NewStr: Widestring;
  Offset: Integer;
begin
  if rfIgnoreCase in Flags then
  begin
    SearchStr := WideUpperCase(S);
    Patt := WideUpperCase(OldPattern);
  end else
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := Pos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

function QPLFloatToStr(const Value: Extended): AnsiString;
begin
  Result := AnsiString(FloatToStr(Value));
end;

function QPLFormatFloat(const Format: AnsiString; Value: Extended): AnsiString;
begin
  Result := AnsiString(FormatFloat(QPLAnsiToNative(Format), Value));
end;

function QPLStrToFloat(const S: AnsiString): Extended;
begin
  Result := StrToFloat(QPLAnsiToNative(S));
end;

function QPLFormatDateTime(const Format: AnsiString; Value: TDateTime): AnsiString;
begin
  Result := AnsiString(FormatDateTime(QPLAnsiToNative(Format), Value));
end;

function QPLFileExists(const FileName: WideString): Boolean;
begin
  Result := WideFileExists(FileName);
end;

function QPLDeleteFile(const FileName: WideString): Boolean;
{$IFNDEF QPL_OS_WINDOWS}
{$IFDEF QPL_OS_MAC}
begin
  Result := DeleteFile(FileName);
end;
{$ELSE}
begin
  Result := False;
end;
{$ENDIF}
{$ELSE}
begin
  Result := DeleteFileW(PWideChar(FileName));
end;
{$ENDIF}

function QPLExtractFileName(const FileName: WideString): WideString;
var
  I: Integer;
begin
  Result := FileName;
  if FileName <> '' then
  begin
    if (Pos('\', FileName) > 0) or (Pos(':', FileName) > 0) then
    begin
      I := Length(FileName);
      while (FileName[I] <> '\') and (FileName[I] <> ':') do
        Dec(I);
      Result := Copy(FileName, I + 1, MaxInt);
    end;
  end else
    Result := '';
end;

function QPLExtractFilePath(const FileName: WideString): WideString;
var
  FileNamePart: WideString;
begin
  FileNamePart := QPLExtractFileName(FileName);
  Result := Copy(FileName, 1, Length(FileName) - Length(FileNamePart));
end;

function QPLExtractFileExt(const FileName: WideString): WideString;
var
  FileNamePart: WideString;
  I: Integer;
begin
  Result := '';
  FileNamePart := QPLExtractFileName(FileName);
  I := Length(FileNamePart);
  if Pos('.', FileNamePart) > 0 then
  begin
    I := Length(FileNamePart);
    while (FileNamePart[I] <> '.') do
      Dec(I);
    Result := Copy(FileNamePart, I, MaxInt);
  end
  else
    Result := Copy(FileNamePart, I+1, MaxInt);
end;

function QPLExpandFileName(const FileName: WideString): WideString;
begin
  Result := WideExpandFileName(FileName);
end;

function QPLChangeFileExt(const FileName, Extension: WideString): WideString;
var
  OldExtension: WideString;
begin
  OldExtension := QPLExtractFileExt(FileName);
  Result := Copy(FileName, 1, Length(FileName) - Length(OldExtension)) + Extension;
end;

function QPLAnsiStringToWideString(const S: AnsiString): WideString;
var
  X: Integer;
begin
  SetLength(Result, Length(S));
  for X := 1 to Length(S) do
  begin
    Result[X] := WideChar(Byte(S[X]));
  end;
end;

function QPLWideStringToAnsiString(const WS: WideString): AnsiString;
begin
  Result := AnsiString(WS);
end;

function QPLCreateFileStream(const FileName: WideString; Mode: Word): TQuickPDFWideFileStream;
begin
  Result := TQuickPDFWideFileStream.Create(FileName, Mode);
end;

function QPLCanCreateFileStream(const FileName: WideString; Mode: Word): Boolean;
var
  TestHandle: Integer;
begin
  if (Mode and fmCreate) = fmCreate then
  begin
    TestHandle := WideFileCreate(FileName, 0);
    Result := (TestHandle >= 0);
    if (Result) then
    begin
      FileClose(TestHandle);
    end;
  end else
  begin
    TestHandle := WideFileOpen(FileName, Mode);
    Result := (TestHandle >= 0);
    if (Result) then
    begin
      FileClose(TestHandle);
    end;
  end;
end;

function QPLDirectoryExists(const Directory: WideString): Boolean;
{$IFNDEF QPL_OS_WINDOWS}
begin
  Result := DirectoryExists(Directory);
end;
{$ELSE}
var
  Code: Integer;
begin
  Code := GetFileAttributesW(PWideChar(Directory));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;
{$ENDIF}

function QPLAnsiCompareStr(const S1, S2: AnsiString): Integer;
begin
{$IFDEF UNICODE}
{$IFDEF QPL_CPP}
  Result := 0;
{$ELSE}
  Result := AnsiStrings.AnsiCompareStr(S1, S2);
{$ENDIF}
{$ELSE}
  Result := AnsiCompareStr(S1, S2);
{$ENDIF}
end;

function QPLAnsiCompareText(const S1, S2: AnsiString): Integer;
begin
{$IFDEF UNICODE}
{$IFDEF QPL_CPP}
  Result := 0;
{$ELSE}
  Result := AnsiStrings.AnsiCompareText(S1, S2);
{$ENDIF}
{$ELSE}
  Result := AnsiCompareText(S1, S2);
{$ENDIF}
end;

{$IFNDEF QPL_OS_MAC}
{ TQuickPDFWideFileStream }

constructor TQuickPDFWideFileStream.Create(const FileName: WideString; Mode: Word);
begin
  Create(Filename, Mode, 0);
end;

constructor TQuickPDFWideFileStream.Create(const FileName: WideString; Mode: Word; Rights: Cardinal);
begin
  inherited Create;
  if (Mode and fmCreate) = fmCreate then
  begin
    FHandle := WideFileCreate(FileName, Rights);
    if (FHandle = TQPLIntPtr(INVALID_HANDLE_VALUE)) then
      raise EFCreateError.CreateFmt('Error', []);
  end else
  begin
    FHandle := WideFileOpen(FileName, Mode);
    if (FHandle = TQPLIntPtr(INVALID_HANDLE_VALUE)) then
      raise EFCreateError.CreateFmt('Error', []);
  end;
end;

destructor TQuickPDFWideFileStream.Destroy;
begin
  if (FHandle <> TQPLIntPtr(INVALID_HANDLE_VALUE)) then
  begin
    FileClose(FHandle);
  end;
  inherited Destroy;
end;

function TQuickPDFWideFileStream.Read(var Buffer; Count: Integer): Longint;
begin
  Result := FileRead(FHandle, Buffer, Count);
  if Result = -1 then Result := 0;
end;

{$IFDEF D4ORD5}
function TQuickPDFWideFileStream.Seek(Offset: Longint;
  Origin: Word): Longint;
begin
  Result := FileSeek(FHandle, Offset, Ord(Origin));
end;
{$ELSE}
function TQuickPDFWideFileStream.Seek(const Offset: Int64;
  Origin: TSeekOrigin): Int64;
begin
  Result := FileSeek(FHandle, Offset, Ord(Origin));
end;
{$ENDIF}

procedure TQuickPDFWideFileStream.SetSize(NewSize: Integer);
begin
{$IFDEF D4ORD5}
  Seek(NewSize, 0);
{$WARNINGS OFF}
  Win32Check(SetEndOfFile(FHandle));
{$WARNINGS ON}
{$ELSE}
  SetSize(Int64(NewSize));
{$ENDIF}
end;

{$IFNDEF D4ORD5}
procedure TQuickPDFWideFileStream.SetSize(const NewSize: Int64);
begin
{$WARNINGS OFF}
  Win32Check(SetEndOfFile(FHandle));
{$WARNINGS ON}
end;
{$ENDIF}

function TQuickPDFWideFileStream.Write(const Buffer;
  Count: Integer): Longint;
begin
  Result := FileWrite(FHandle, Buffer, Count);
  if Result = -1 then Result := 0;
end;
{$ENDIF}

procedure QPLWideStringInsert(Source: WideString; var S: WideString; Index: Integer);
begin
  S := Copy(S, 1, Index - 1) + Source + Copy(S, Index, MaxInt);
end;

function QPLWideStringPos(const Substr, S: WideString): Integer;
var
  X: Integer;
  L: Integer;
begin
  Result := 0;
  X := 0;
  L := Length(Substr);
  while (Result = 0) and (X < Length(S)) do
  begin
    Inc(X);
    if Copy(S, X, L) = Substr then
      Result := X;
  end;
end;

function QPLAnsiToNative(const S: AnsiString): string;
var
  X: Integer;
begin
  SetLength(Result, Length(S));
  for X := 1 to Length(S) do
  begin
    Result[X] := Char(S[X]);
  end;
end;

function QPLNativeToAnsi(const S: string): AnsiString;
var
  X: Integer;
begin
  SetLength(Result, Length(S));
  for X := 1 to Length(S) do
  begin
    Result[X] := AnsiChar(S[X]);
  end;
end;

function QPLBoolToStr(B: Boolean): AnsiString;
begin
  if B then Result := 'T' else Result := 'F';
end;

function QPLStrToBool(const S: AnsiString): Boolean;
begin
  Result := S = 'T';
end;

function QPLIsNan(const V: Single): Boolean;
begin
  Result := ((PLongWord(@V)^ and $7F800000)  = $7F800000) and
    ((PLongWord(@V)^ and $007FFFFF) <> $00000000);
end;

function QPLIsNan(const V: Double): Boolean;
begin
  Result := ((PInt64(@V)^ and $7FF0000000000000)  = $7FF0000000000000) and
    ((PInt64(@V)^ and $000FFFFFFFFFFFFF) <> $0000000000000000);
end;

function QPLIsNan(const V: Extended): Boolean;
type
  TExt = packed record
    Mantissa: Int64;
    Exponent: Word;
  end;
  PExt = ^TExt;
begin
  Result := ((PExt(@V)^.Exponent and $7FFF)  = $7FFF) and
    ((PExt(@V)^.Mantissa and $7FFFFFFFFFFFFFFF) <> 0);
end;

{$IFNDEF QPL_OS_WINDOWS}
function Ole32CoCreateGuid(out G: TGUID): HResult; stdcall;
begin
  Result := 0;
end;
{$ELSE}
function Ole32CoCreateGuid(out G: TGUID): HResult; stdcall; external 'ole32.dll' name 'CoCreateGuid';
{$ENDIF}

function QPLRandomID: AnsiString;
var
  G: TGUID;
  S: AnsiString;
begin
  Ole32CoCreateGuid(G);
  SetLength(S, 16);
  Move(G, S[1], 16);
  Result := QPLCopy(MD5Print(MD5String(S + QPLFloatToStr(Now))), 1, 8);
end;

function QPLLengthAdjustment(const WS: WideString): WideString;
var
  MustAdjust: Boolean;
  AdjustedLength: Word;
begin
  MustAdjust := False;
  if (Length(WS) >= 2) then
  begin
    if ((Word(WS[1]) and $FF00) = $E700) and ((Word(WS[2]) and $FF00) = $F800) then
    begin
      AdjustedLength := (Word(WS[1]) and $00FF) + (Word(WS[2]) and $00FF) * 256;
      if AdjustedLength > (Length(WS) - 2) then
      begin
        AdjustedLength := Length(WS) - 2;
      end;
      MustAdjust := True;
      SetLength(Result, AdjustedLength);
      Move(WS[3], Result[1], AdjustedLength * 2);
    end;
  end;
  if not MustAdjust then
  begin
    Result := WS;
  end;
end;

{$IFDEF QPL_NOVCL}
type
  TFPCULargeInteger = record
    case Integer of
    0: (
      LowPart: DWORD;
      HighPart: DWORD);
    1: (
      QuadPart: ULONGLONG);
  end;
{$ENDIF
}

// Returns the amount of time that has elapsed since the
// specified system time. If the UTC parameter is True then
// EarlierSystemTime is presumed to be UTC-based otherwise
// it is in the current time zone.
// Result is rounded down to the nearest number of whole milliseconds.
function QPLMillisecondsSinceSystemTime(const EarlierSystemTime: TSystemTime;
  UTC: Boolean): Integer;
var
  EarlierFileTime: TFileTime;
  CurrentFileTime: TFileTime;
{$IFDEF QPL_NOVCL OR}
  EarlierOffset: TFPCULargeInteger;
  CurrentOffset: TFPCULargeInteger;
{$ELSE}
  EarlierOffset: TULargeInteger;
  CurrentOffset: TULargeInteger;
{$ENDIF}
  EarlierSeconds: Extended;
  CurrentSeconds: Extended;  
begin
  // Get the current UTC-based time as a TFileTime
  GetSystemTimeAsFileTime(CurrentFileTime);

  // Convert the supplied EarlierSystemTime to a TFileTime
  SystemTimeToFileTime(EarlierSystemTime, EarlierFileTime);
  if not UTC then
  begin
    // Convert the supplied time to UTC-based
    LocalFileTimeToFileTime(EarlierFileTime, EarlierFileTime);
  end;

  // Both times are now UTC-based, convert them to seconds
  EarlierOffset.HighPart := EarlierFileTime.dwHighDateTime;
  EarlierOffset.LowPart := EarlierFileTime.dwLowDateTime;
  EarlierSeconds := EarlierOffset.QuadPart / 10000;
  CurrentOffset.HighPart := CurrentFileTime.dwHighDateTime;
  CurrentOffset.LowPart := CurrentFileTime.dwLowDateTime;
  CurrentSeconds := CurrentOffset.QuadPart / 10000;

  // Result is the difference
  Result := Floor(CurrentSeconds - EarlierSeconds);
end;

procedure QPLStreamInsert(TargetStream: TStream; const NewData: AnsiString; Position: Integer);
var
  Buffer: array of Byte;
  BufferSize: Integer;
  BytesLeft: Integer;
  ThisSize: Integer;
  ThisPosition: Integer;
  Offset: Integer;
  OriginalSize: Integer;
  OriginalPosition: Integer;
begin
  Offset := Length(NewData);
  if (Offset > 0) then
  begin
    OriginalPosition := TargetStream.Position;
    
    BufferSize := 64 * 1024;
    SetLength(Buffer, BufferSize);
    OriginalSize := TargetStream.Size;
    BytesLeft := OriginalSize - Position;
    ThisPosition := -1;

    TargetStream.Seek(0, soFromEnd);
    TargetStream.Write(NewData[1], Offset);

    while (BytesLeft > 0) do
    begin
      ThisSize := BufferSize;
      if ThisSize > BytesLeft then
      begin
        ThisSize := BytesLeft;
      end;
      if ThisPosition < 0 then
      begin
        ThisPosition := OriginalSize - ThisSize;
      end;

      TargetStream.Seek(ThisPosition, soFromBeginning);
      TargetStream.Read(Buffer[0], ThisSize);
      TargetStream.Seek(ThisPosition + Offset, soFromBeginning);
      TargetStream.Write(Buffer[0], ThisSize);

      Dec(BytesLeft, ThisSize);
      if (BytesLeft < ThisSize) then
      begin
        Dec(ThisPosition, BytesLeft);
      end else
      begin
        Dec(ThisPosition, ThisSize);
      end;
    end;
    TargetStream.Seek(Position, soFromBeginning);
    TargetStream.Write(NewData[1], Offset);

    if OriginalPosition >= Position then
    begin
      Inc(OriginalPosition, Offset);
    end;
    TargetStream.Seek(OriginalPosition, soFromBeginning);
  end;
end;

function TQPLSortedUniqueIntegerList.AddUnique(New: Integer): Boolean;
var
  A, B: Integer;
  X: Integer;
begin
  A := New shr 16;
  B := New and $FFFF;
  if (A >= 0) and (B >= 0) then
  begin
    if A >= Length(FList) then
    begin
      SetLength(FList, A + 1);
    end;
    if Length(FList[A]) = 0 then
    begin
      SetLength(FList[A], 65536);
      for X := 0 to 65535 do
      begin
        FList[A][X] := True;
      end;
    end;
    Result := FList[A][B];
    FList[A][B] := False;
  end else
  begin
    Result := True;
  end;
end;

constructor TQPLSortedUniqueIntegerList.Create;
begin
  SetLength(FList, 0);
end;

procedure TQPLSortedUniqueIntegerList.Clear;
begin
  SetLength(FList, 0);
end;

function TQPLSortedUniqueIntegerList.Contains(Number: Integer): Boolean;
var
  A, B: Integer;
  X: Integer;
begin
  A := Number shr 16;
  B := Number and $FFFF;
  if (A >= 0) and (B >= 0) then
  begin
    if A >= Length(FList) then
    begin
      SetLength(FList, A + 1);
    end;
    if Length(FList[A]) = 0 then
    begin
      SetLength(FList[A], 65536);
      for X := 0 to 65535 do
      begin
        FList[A][X] := True;
      end;
    end;
    Result := not FList[A][B];
  end else
  begin
    Result := True;
  end;
end;

function QPLParsePageRangeList(const RangeList: AnsiString; FirstValidPage,
  LastValidPage: Integer; FailInvalidPages, FailInvalidChars,
  FailDuplicatePages, AllowDuplicatePages, SortList: Boolean): TQuickPDFPageList;
var
  X: Integer;
  S: AnsiString;
  Success: Boolean;
  CommaPos: Integer;
  DashPos: Integer;
  ThisItem: AnsiString;
  FirstPage: Integer;
  LastPage: Integer;
  ThisPage: Integer;
  DuplicateIndex: Integer;
  DuplicatePage: Boolean;
  Swapped: Boolean;
  Done: Boolean;
const
  ValidChars = '0123456789,-';
begin
  SetLength(Result, 0);
  Success := True;
  S := '';

  // Remove invalid characters from the page range. If invalid characters are
  // found then continue only if FailInvalidChars is False
  X := 1;
  while (Success and (X <= Length(RangeList))) do
   begin
    if (QPLPos(RangeList[X], ValidChars) > 0) then
    begin
      S := S + RangeList[X];
    end else
    begin
      if (FailInvalidChars) then
      begin
        Success := False;
      end;
    end;
    Inc(X);
  end;

  if (Length(S) = 0) then
  begin
    Success := False;
  end;

  if (Success) then
  begin
    repeat
      CommaPos := QPLPos(',', S);
      if (CommaPos > 0) then
      begin
        ThisItem := QPLCopy(S, 1, CommaPos - 1);
        Delete(S, 1, CommaPos);
      end else
      begin
        ThisItem := S;
        S := '';
      end;

      DashPos := QPLPos('-', ThisItem);
      if (DashPos > 0) then
      begin
        // This item is a range
        FirstPage := QPLStrToIntDef(QPLCopy(ThisItem, 1, DashPos - 1), -1);
        LastPage := QPLStrToIntDef(QPLCopy(ThisItem, DashPos + 1, MaxInt), -1);
      end else
      begin
        // This is a single item
        FirstPage := QPLStrToIntDef(ThisItem, -1);
        LastPage := FirstPage;
      end;

      if ((FirstPage >= 0) and (LastPage >= 0)) then
      begin
        Done := False;
        ThisPage := FirstPage;
        while (Success and (not Done)) do
        begin
          if ((ThisPage < FirstValidPage) or (ThisPage > LastValidPage)) then
          begin
            // The page is out of range
            if (FailInvalidPages) then
            begin
              Success := False;
            end;
          end else
          begin
            // The page is in range, check for duplicate
            DuplicatePage := False;
            DuplicateIndex := 0;
            while ((not DuplicatePage) and (DuplicateIndex < Length(Result))) do
            begin
              if (Result[DuplicateIndex] = ThisPage) then
              begin
                DuplicatePage := True;
              end else
              begin
                Inc(DuplicateIndex);
              end;
            end;

            if (DuplicatePage) then
            begin
              if (FailDuplicatePages) then
              begin
                Success := False;
              end;
            end;

            if ((not DuplicatePage) or (DuplicatePage and AllowDuplicatePages)) then
            begin
              SetLength(Result, Length(Result) + 1);
              Result[Length(Result) - 1] := ThisPage;
            end;
          end;

          Done := ThisPage = LastPage;
          if (FirstPage > LastPage) then
          begin
            Dec(ThisPage);
          end else
          begin
            Inc(ThisPage);
          end;
        end;
      end;
    until ((not Success) or (S = ''));
  end;

  if (not Success) then
  begin
    SetLength(Result, 0);
  end;

  if (SortList) then
  begin
    Swapped := True;
    while (Swapped) do
    begin
      Swapped := False;
      for X := 0 to Length(Result) - 2 do
      begin
        if (Result[X] > Result[X + 1]) then
        begin
          ThisPage := Result[X];
          Result[X] := Result[X + 1];
          Result[X + 1] := ThisPage;
          Swapped := True;
        end;
      end;
    end;
  end;
end;

function QPLDoubleToStrConst(Value: Double; Decimal: Integer): AnsiString;
begin
  Result := QPLDoubleToStr(Value, Decimal);
end;

function QPLDoubleToStr(var Value: Double; Decimal: Integer): AnsiString;
var
  I1: Int64;
  DecPos: Integer;
begin

  if (Decimal > 0)  then
  begin
    I1 := Round(Value * Power(10, Decimal));

    if (I1 = 0) then
      Result := '0'
    else
    begin
      Result := AnsiString(IntToStr(I1));

      if Result[1] = '-' then
        for DecPos := 0 to Decimal - (Length(Result) - 1) do
          Insert('0', Result, 2)
      else
        for DecPos := 0 to Decimal - Length(Result) do
          Insert('0', Result, 1);

      DecPos := Length(Result) - Decimal + 1;
      Insert('.', Result, DecPos);

      Decimal := Length(Result);
      if (Result[Decimal] = '0') then
      begin
        while (Result[Decimal] = '0') do
          Dec(Decimal);

        if (Result[Decimal] = '.') then
          SetLength(Result, Decimal - 1)
        else
          SetLength(Result, Decimal);
      end;
    end;
  end
  else
    Result := AnsiString(IntToStr(Round(Value)));
end;

function QPLPaddedInt(Value, Digits: Integer): AnsiString;
var
  StrValue: AnsiString;
  StrValueLen: Integer;
begin
  if (Value >= 0) then
  begin
    StrValue := AnsiString(IntToStr(Value));
    StrValueLen := Length(StrValue);
    if (StrValueLen >= Digits) then
    begin
      Result := StrValue;
    end else
    begin
      Result := AnsiString(StringOfChar('0', Digits));
      Move(StrValue[1], Result[Digits - StrValueLen + 1], StrValueLen);
    end;
  end else
  begin
    Result := AnsiString(StringOfChar('0', Digits));
  end;
end;

function QPLPaddedInt64(Value: Int64; Digits: Integer): AnsiString;
var
  StrValue: AnsiString;
  StrValueLen: Integer;
begin
  if (Value >= 0) then
  begin
    StrValue := AnsiString(IntToStr(Value));
    StrValueLen := Length(StrValue);
    if (StrValueLen >= Digits) then
    begin
      Result := StrValue;
    end else
    begin
      Result := AnsiString(StringOfChar('0', Digits));
      Move(StrValue[1], Result[Digits - StrValueLen + 1], StrValueLen);
    end;
  end else
  begin
    Result := AnsiString(StringOfChar('0', Digits));
  end;
end;

function QPLPaddedDouble(var Value: Double; Digits, Decimal: Integer): AnsiString;
var
  Neg: Double;
begin
  if (Value >= 0) then
  begin
    Result := QPLDoubleToStr(Value, Decimal);
    if (Length(Result) < Digits) then
    begin
      Result := AnsiString(StringOfChar('0', Digits - Length(Result))) + Result;
    end;
  end else
  begin
    Neg := -Value;
    Result := '-' + QPLPaddedDouble(Neg, Digits - 1, Decimal);
  end;
end;

{$IFDEF QPL_OS_MAC}

{ TQuickPDFStringList }

constructor TQuickPDFStringList.Create;
begin
  inherited Create;
end;

function TQuickPDFStringList.Add(const S: AnsiString): Integer;
var
  W: WideString;
  X: Integer;
begin
  SetLength(W, Length(S));
  for X := 1 to Length(S) do
  begin
    W[X] := WideChar(Byte(S[X]));
  end;
  Result := inherited Add(W);
end;

function TQuickPDFStringList.IndexOf(const S: AnsiString): Integer;
var
  W: WideString;
  X: Integer;
begin
  SetLength(W, Length(S));
  for X := 1 to Length(S) do
  begin
    W[X] := WideChar(Byte(S[X]));
  end;
  Result := inherited IndexOf(W);
end;

procedure TQuickPDFStringList.AddObject(const S: AnsiString; O: TObject);
var
  W: WideString;
  X: Integer;
begin
  SetLength(W, Length(S));
  for X := 1 to Length(S) do
  begin
    W[X] := WideChar(Byte(S[X]));
  end;
  inherited AddObject(W, O);
end;

procedure TQuickPDFStringList.Insert(Index: Integer; const S: AnsiString);
begin
  inherited Insert(Index, WideString(S));
end;

function TQuickPDFStringList.QGet(Index: Integer): AnsiString;
var
  W: WideString;
  X: Integer;
begin
  W := Get(Index);
  SetLength(Result, Length(W));
  for X := 1 to Length(W) do
  begin
    Result[X] := AnsiChar(Word(W[X]) and $FF);
  end;
end;

procedure TQuickPDFStringList.QPut(Index: Integer; const S: AnsiString);
var
  W: WideString;
  X: Integer;
begin
  SetLength(W, Length(S));
  for X := 1 to Length(S) do
  begin
    W[X] := WideChar(Byte(S[X]));
  end;
  Put(Index, W);
end;

function TQuickPDFStringList.QGetValue(const Name: AnsiString): AnsiString;
var
  I: Integer;
begin
  I := IndexOfName(WideString(Name));
  if I >= 0 then
    Result := QPLCopy(QGet(I), Length(Name) + 2, MaxInt) else
    Result := '';
end;

procedure TQuickPDFStringList.QSetValue(const Name, Value: AnsiString);
var
  I: Integer;
begin
  I := IndexOfName(WideString(Name));
  if Value <> '' then
  begin
    if I < 0 then I := Add('');
    QPut(I, Name + '=' + Value);
  end else
  begin
    if I >= 0 then Delete(I);
  end;
end;

procedure TQuickPDFStringList.QSetTextStr(const Value: AnsiString);
begin
  inherited Text := WideString(Value);
end;

function TQuickPDFStringList.QGetTextStr: AnsiString;
begin
  Result := AnsiString(inherited Text);
end;


{ TQuickPDFCaseSensitiveStringList }

constructor TQuickPDFCaseSensitiveStringList.Create;
begin
  FCaseSensitive := True;
end;

function TQuickPDFCaseSensitiveStringList.CompareStrings(const S1, S2: string): Integer;
begin
  Result := CompareStr(S1, S2, loInvariantLocale);
end;
{$ENDIF}

{$IFDEF QPL_OS_WINDOWS}
function QPLGetTempFolder: WideString;
begin
  SetLength(Result, 1024);
  SetLength(Result, Windows.GetTempPathW(1024, @Result[1]));
  if Copy(Result, Length(Result), 1) <> '\' then
    Result := Result + WideString('\');
end;
{$ENDIF}

{$IFDEF QPL_OS_MAC}
function QPLGetTempFolder: WideString;
begin
  Result := '/tmp/';
end;
{$ENDIF}

{$IFDEF QPL_CPP}
function QPLGetTempFolder: WideString;
begin
  Result := '.';
end;
{$ENDIF}

{$IFDEF QPL_NOSAMEVALUE}
function QPLSameValue(const A, B: Double): Boolean;
begin
  Result := Abs(A - B) <= 0.0000001;
end;
{$ELSE}
function QPLSameValue(const A, B: Double): Boolean;
begin
  Result := Math.SameValue(A, B, 0);
end;
{$ENDIF}

function DPLDivideWithRemainder(const A, B: Cardinal; var Remainder: Cardinal): Cardinal;
var
  A64: Int64;
begin
  A64 := (Int64(Remainder) shl 32 or A);
  Remainder := A64 mod B;
  Result := A64 div B;
end;

function DPLInt128Mod(Int128: TQuickPDFInt128; AValue: Cardinal): Cardinal;
begin
  Result := 0;
  DPLDivideWithRemainder(Int128[3], AValue, Result);
  DPLDivideWithRemainder(Int128[2], AValue, Result);
  DPLDivideWithRemainder(Int128[1], AValue, Result);
  DPLDivideWithRemainder(Int128[0], AValue, Result);
end;

// Looks for <?xpacket begin="[U+FEFF]" id="W5M0MpCehiHzreSzNTczkc9d"?>
function DPLXMPToWideString(const Input: AnsiString): WideString;
var
  TokenPos: Integer;
  InputLength: Integer;
  Temp: WideString;
begin
  Result := '';
  TokenPos := QPLPos('<?xpacket', Input);
  if (TokenPos > 0) then
  begin
    Result := QPLUTF8Decode(Input);
  end else
  begin
    TokenPos := QPLPos('<'#0'?'#0'x'#0'p'#0'a'#0'c'#0'k'#0'e'#0't', Input);
    if (TokenPos > 0) then
    begin
      InputLength := Length(Input);
      if (InputLength mod 2) = 1 then
      begin
        Dec(InputLength);
      end;
      SetLength(Result, InputLength div 2);
      Move(Input[1], Result[1], InputLength);
      if (TokenPos mod 2) = 0 then
      begin
        Temp := Result;
        QPLUnicodeConvert16To16(Temp, Result, QPLUnicodeUTF16BE, QPLUnicodeUTF16LE, QPLUnicodeStrip, QPLUnicodeMark);
      end;
    end;
  end;
end;

function GetTokCount(const Line: AnsiString; const Delim: AnsiChar): Integer;
var
 I: integer;
begin
  Result := 1;
  for I := 1 to Length(Line) do
    if (Line[I] = Delim) then
      Inc(Result);
end;

function GetTok(const Line: AnsiString; const Delim: AnsiChar; const TokenNum: Byte): AnsiString;
{ LK Feb 12, 2007 - This function has been optimized as best as possible }
{ LK Nov 7, 2009 - Reoptimized using PChars instead of calls to Pos and PosEx }
{ See; http://stackoverflow.com/questions/1694001/is-there-a-fast-gettoken-routine-for-delphi }
var
 I: integer;
 PLine, PStart: PAnsiChar;
begin
  PLine := PAnsiChar(Line);
  PStart := PLine;
  inc(PLine);
  for I := 1 to TokenNum do begin
    while (PLine^ <> #0) and (PLine^ <> Delim) do
      inc(PLine);
    if I = TokenNum then begin
      SetString(Result, PStart, PLine - PStart);
      break;
    end;
    if PLine^ = #0 then begin
      Result := '';
      break;
    end;
    inc(PLine);
    PStart := PLine;
  end;
end;

function GetWideTokCount(const Line: WideString; const Delim: WideChar): Integer;
var
 I: integer;
begin
  Result := 1;
  for I := 1 to Length(Line) do
    if (Line[I] = Delim) then
      Inc(Result);
end;

function GetWideTok(const Line: WideString; const Delim: WideChar; const TokenNum: Byte): WideString;
var
 I: integer;
 PLine, PStart: PWideChar;
begin
  PLine := PWideChar(Line);
  PStart := PLine;
  inc(PLine);
  for I := 1 to TokenNum do begin
    while (PLine^ <> #0) and (PLine^ <> Delim) do
      inc(PLine);
    if I = TokenNum then begin
      SetString(Result, PStart, PLine - PStart);
      break;
    end;
    if PLine^ = #0 then begin
      Result := '';
      break;
    end;
    inc(PLine);
    PStart := PLine;
  end;
end;

function DPLClassExists(const ClassName: WideString): Boolean;
{$IFDEF QPL_OS_WINDOWS}
var
  ClassID: TCLSID;
begin
  Result := Succeeded(CLSIDFromProgID(PWideChar(ClassName),
    ClassID));
{$ELSE}
begin
  Result := False;
{$ENDIF}
end;

initialization
  Randomize;
end.
