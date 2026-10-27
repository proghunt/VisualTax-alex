{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryBarcode.pas                            }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryBarcode;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, Math;

type
  TBarcodeBar = record
    Width: Integer;
    Filled: Boolean;
  end;

  TBarArray = array of TBarcodeBar;

  TPDF2DBarcode = class
  protected
    FPattern: array of array of Boolean;
    FRows: Integer;
    FCols: Integer;
  public
    function GetModule(Row, Col: Integer): Boolean;
    property Rows: Integer read FRows;
    property Cols: Integer read FCols;
  end;

  TPDFDataMatrixSymbolSize = (ssAuto, ss10x10, ss12x12, ss8x18, ss14x14, ss8x32,
    ss16x16, ss12x26, ss18x18, ss20x20, ss12x36, ss22x22, ss16x36, ss24x24,
    ss26x26, ss16x48, ss32x32, ss36x36, ss40x40, ss44x44, ss48x48, ss52x52,
    ss64x64, ss72x72, ss80x80, ss88x88, ss96x96, ss104x104, ss120x120,
    ss132x132, ss144x144);

  TPDFDataMatrixEncoding = (deASCII);

const
  PDFDataMatrixData: array[TPDFDataMatrixSymbolSize] of Integer = (
    1558, 3, 5, 5, 8, 10, 12, 16, 18, 22, 22, 30, 32, 36, 44, 49, 62, 86, 114,
    144, 174, 204, 280, 368, 456, 576, 696, 816, 1050, 1304, 1558);
  PDFDataMatrixError: array[TPDFDataMatrixSymbolSize] of Integer = (
    0, 5, 7, 7, 10, 11, 12, 14, 14, 18, 18, 20, 24, 24, 28, 28, 36, 42, 48, 56,
    68, 84, 112, 144, 192, 224, 272, 336, 408, 496, 620);
  PDFDataMatrixInterleave: array[TPDFDataMatrixSymbolSize] of Integer = (
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 4, 4,
    4, 4, 6, 6, 8, 10);
  PDFDataMatrixMapRows: array[TPDFDataMatrixSymbolSize] of Integer = (
    0, 8, 10, 6, 12, 6, 14, 10, 16, 18, 10, 20, 14, 22, 24, 14, 28, 32, 36, 40,
    44, 48, 56, 64, 72, 80, 88, 96, 108, 120, 132);
  PDFDataMatrixMapCols: array[TPDFDataMatrixSymbolSize] of Integer = (
    0, 8, 10, 16, 12, 28, 14, 24, 16, 18, 32, 20, 32, 22, 24, 44, 28, 32, 36,
    40, 44, 48, 56, 64, 72, 80, 88, 96, 108, 120, 132);
  PDFDataMatrixRegions: array[TPDFDataMatrixSymbolSize] of Integer = (
    1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 2, 1, 2, 1, 1, 2, 4, 4, 4, 4, 4, 4, 16, 16,
    16, 16, 16, 16, 36, 36, 36);

  C40Mapping: array[0..90] of Integer = (
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    3,                                                    // Space
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    4, 5, 6, 7, 8, 9, 10, 11, 12, 13,                     // '0' - '9'
    -1,-1, -1, -1, -1, -1, -1,
    14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26,  // 'A' - 'M'
    27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39); // 'N' - 'Z'

type
  TPDFDataMatrix = class(TPDF2DBarcode)
  private
    IsAuto: Boolean;
    FData: AnsiString;
    FDataCount: Integer;
    FErrorCount: Integer;
    FEncoding: TPDFDataMatrixEncoding;
    FSymbolSize: TPDFDataMatrixSymbolSize;
    FInterleave: Integer;
    FMapRows: Integer;
    FMapCols: Integer;
    FRegions: Integer;
    procedure EncodeASCII;
    procedure SetSize;
    procedure GenerateMappingMatrix;
  public
    constructor Create;
    procedure Encode(const Data: AnsiString);
    property SymbolSize: TPDFDataMatrixSymbolSize read FSymbolSize write FSymbolSize;
  end;

  TReedSolomon = class
  private
    FErrorCount: Integer;
    FDataCount: Integer;
    FLog: array[0..255] of Integer;
    FALog: array[0..255] of Integer;
    FGenPoly: array of Integer;
    function GFMultiply(A, B: Byte): Byte;
    procedure GenerateGF;
    procedure GenerateGenPoly;
  public
    constructor Create(DataCount, ErrorCount: Integer);
    function GenerateECCCodes(const Source: AnsiString): AnsiString;
  end;

  TECC200MappingMatrix = class
  private
    NRow: Integer;
    NCol: Integer;
    MM: array of Integer;
    FSource: AnsiString;
    FBits: array of array of Boolean;
    procedure Corner1(C: Integer);
    procedure Corner2(C: Integer);
    procedure Corner3(C: Integer);
    procedure Corner4(C: Integer);
    procedure ECC200;
    procedure Module(Row, Col, C, Bit: Integer);
    procedure Utah(Row, Col, C: Integer);
  public
    procedure CreateMatrix(Rows, Cols: Integer; const Source: AnsiString);
    function GetBit(Row, Col: Integer): Boolean;
  end;

  function Code39(Text: AnsiString; var Bars: TBarArray): Integer;
  function EAN13(Text: AnsiString; var Bars: TBarArray): Integer;
  function Code128(Text: AnsiString; var Bars: TBarArray): Integer;
  function PostNet(Text: AnsiString; var Bars: TBarArray): Integer;
  function Interleaved2of5(Text: AnsiString; var Bars: TBarArray): Integer;

implementation

uses
  SysUtils, DebenuPDFLibraryExtra;

const
  Code39Data: array[1..44, 1..2] of AnsiString = (
('0', 'nnnwwnwnn'), ('C', 'wnwnnwnnn'), ('O', 'wnnnwnnwn'), ('-', 'nwnnnnwnw'),
('1', 'wnnwnnnnw'), ('D', 'nnnnwwnnw'), ('P', 'nnwnwnnwn'), ('.', 'wwnnnnwnn'),
('2', 'nnwwnnnnw'), ('E', 'wnnnwwnnn'), ('Q', 'nnnnnnwww'), (' ', 'nwwnnnwnn'),
('3', 'wnwwnnnnn'), ('F', 'nnwnwwnnn'), ('R', 'wnnnnnwwn'), ('*', 'nwnnwnwnn'),
('4', 'nnnwwnnnw'), ('G', 'nnnnnwwnw'), ('S', 'nnwnnnwwn'), ('$', 'nwnwnwnnn'),
('5', 'wnnwwnnnn'), ('H', 'wnnnnwwnn'), ('T', 'nnnnwnwwn'), ('/', 'nwnwnnnwn'),
('6', 'nnwwwnnnn'), ('I', 'nnwnnwwnn'), ('U', 'wwnnnnnnw'), ('+', 'nwnnnwnwn'),
('7', 'nnnwnnwnw'), ('J', 'nnnnwwwnn'), ('V', 'nwwnnnnnw'), ('%', 'nnnwnwnwn'),
('8', 'wnnwnnwnn'), ('K', 'wnnnnnnww'), ('W', 'wwwnnnnnn'),
('9', 'nnwwnnwnn'), ('L', 'nnwnnnnww'), ('X', 'nwnnwnnnw'),
('A', 'wnnnnwnnw'), ('M', 'wnwnnnnwn'), ('Y', 'wwnnwnnnn'),
('B', 'nnwnnwnnw'), ('N', 'nnnnwnnww'), ('Z', 'nwwnwnnnn'));

function Code39(Text: AnsiString; var Bars: TBarArray): Integer;
var
  Bar: Integer;
  CharX: Integer;
  CharI: Integer;
  BarX: Integer;
begin
  Text := QPLUpperCase(Text);
  if QPLCopy(Text, 1, 1) + QPLCopy(Text, Length(Text), 1) <> '**' then
    Text := '*' + Text + '*';

  SetLength(Bars, 0);
  for CharX := 1 to Length(Text) do
  begin
    for CharI := 1 to 44 do
      if Code39Data[CharI, 1] = Text[CharX] then
      begin
        for BarX := 1 to 9 do
        begin
          SetLength(Bars, Length(Bars) + 1);
          if Code39Data[CharI, 2][BarX] = 'w' then
            Bars[Length(Bars) - 1].Width := 12
          else
            Bars[Length(Bars) - 1].Width := 4;
          Bars[Length(Bars) - 1].Filled := BarX mod 2 <> 0;
        end;
        SetLength(Bars, Length(Bars) + 1);
        Bars[Length(Bars) - 1].Width := 5;
        Bars[Length(Bars) - 1].Filled := False;
      end;
  end;

  Result := 0;
  for Bar := 0 to Length(Bars) - 1 do
    Result := Result + Bars[Bar].Width;
end;

const
  Interleaved2of5Data: array['0'..'9'] of AnsiString =
    ('NNWWN', 'WNNNW', 'NWNNW', 'WWNNN', 'NNWNW', 'WNWNN',
     'NWWNN', 'NNNWW', 'WNNWN', 'NWNWN');

function Interleaved2of5(Text: AnsiString; var Bars: TBarArray): Integer;
var
  Bar: Integer;
  CharX: Integer;
  BarX: Integer;
  Code1: AnsiString;
  Code2: AnsiString;
  Code: AnsiString;
  Pair: AnsiString;
begin
  if Length(Text) mod 2 = 1 then Text := '0' + Text;

  SetLength(Bars, 4);
  Bars[0].Width := 2;
  Bars[0].Filled := True;
  Bars[1].Width := 2;
  Bars[1].Filled := False;
  Bars[2].Width := 2;
  Bars[2].Filled := True;
  Bars[3].Width := 2;
  Bars[3].Filled := False;

  for CharX := 1 to Length(Text) div 2 do
  begin
    Pair := QPLCopy(Text, CharX * 2 - 1, 2);
    Code1 := Interleaved2of5Data[Pair[1]];
    Code2 := Interleaved2of5Data[Pair[2]];
    SetLength(Code, 10);
    for BarX := 0 to 4 do
    begin
      Code[BarX * 2 + 1] := Code1[BarX + 1];
      Code[BarX * 2 + 2] := Code2[BarX + 1];
    end;
    for BarX := 1 to 10 do
    begin
      SetLength(Bars, Length(Bars) + 1);
      if Code[BarX] = 'W' then
        Bars[Length(Bars) - 1].Width := 5
      else
        Bars[Length(Bars) - 1].Width := 2;
      Bars[Length(Bars) - 1].Filled := BarX mod 2 = 1;
    end;
  end;

  BarX := Length(Bars);
  SetLength(Bars, BarX + 3);
  Bars[BarX].Width := 5;
  Bars[BarX].Filled := True;
  Bars[BarX + 1].Width := 2;
  Bars[BarX + 1].Filled := False;
  Bars[BarX + 2].Width := 2;
  Bars[BarX + 2].Filled := True;

  Result := 0;
  for Bar := 0 to Length(Bars) - 1 do
    Result := Result + Bars[Bar].Width;
end;

const
  EANEncoding: array['0'..'9', 'A'..'C'] of AnsiString =
((('3S2B1S1B'), ('1S1B2S3B'), ('3B2S1B1S')),
 (('2S2B2S1B'), ('1S2B2S2B'), ('2B2S2B1S')),
 (('2S1B2S2B'), ('2S2B1S2B'), ('2B1S2B2S')),
 (('1S4B1S1B'), ('1S1B4S1B'), ('1B4S1B1S')),
 (('1S1B3S2B'), ('2S3B1S1B'), ('1B1S3B2S')),
 (('1S2B3S1B'), ('1S3B2S1B'), ('1B2S3B1S')),
 (('1S1B1S4B'), ('4S1B1S1B'), ('1B1S1B4S')),
 (('1S3B1S2B'), ('2S1B3S1B'), ('1B3S1B2S')),
 (('1S2B1S3B'), ('3S1B2S1B'), ('1B2S1B3S')),
 (('3S1B1S2B'), ('2S1B1S3B'), ('3B1S1B2S')));
  EANNormalGuard = '1B1S1B';
  EANCentreGuard = '1S1B1S1B1S';
  EANCodeSelect: array['0'..'9'] of AnsiString =
('AAAAAA', 'AABABB', 'AABBAB', 'AABBBA', 'ABAABB',
 'ABBAAB', 'ABBBAA', 'ABABAB', 'ABABBA', 'ABBABA');

function EAN13(Text: AnsiString; var Bars: TBarArray): Integer;
var
  CodeSelect: AnsiChar;
  BarSpace: AnsiString;
  X: Integer;
  Bar: Integer;
  C: Integer;
begin
  BarSpace := EANNormalGuard;
  for X := 2 to 7 do
  begin
    CodeSelect := EANCodeSelect[Text[1]][X - 1];
    BarSpace := BarSpace + EANEncoding[Text[X], CodeSelect];
  end;
  BarSpace := BarSpace + EANCentreGuard;
  for X := 8 to 13 do
    BarSpace := BarSpace + EANEncoding[Text[X], 'C'];
  BarSpace := BarSpace + EANNormalGuard;

  SetLength(Bars, 0);
  repeat
    C := QPLStrToIntDef(QPLCopy(BarSpace, 1, 1), 0);
    if C > 0 then
    begin
      SetLength(Bars, Length(Bars) + 1);
      Bars[Length(Bars) - 1].Width := C;
      Bars[Length(Bars) - 1].Filled := QPLCopy(BarSpace, 2, 1) = 'B';
    end;
    Delete(BarSpace, 1, 2);
  until Length(BarSpace) = 0;

  Result := 0;
  for Bar := 0 to Length(Bars) - 1 do
    Result := Result + Bars[Bar].Width;
end;

const
  Code128Codes: array[0..106] of AnsiString = ('212222', '222122', '222221',
    '121223', '121322', '131222', '122213', '122312', '132212', '221213',
    '221312', '231212', '112232', '122132', '122231', '113222', '123122',
    '123221', '223211', '221132', '221231', '213212', '223112', '312131',
    '311222', '321122', '321221', '312212', '322112', '322211', '212123',
    '212321', '232121', '111323', '131123', '131321', '112313', '132113',
    '132311', '211313', '231113', '231311', '112133', '112331', '132131',
    '113123', '113321', '133121', '313121', '211331', '231131', '213113',
    '213311', '213131', '311123', '311321', '331121', '312113', '312311',
    '332111', '314111', '221411', '431111', '111224', '111422', '121124',
    '121421', '141122', '141221', '112214', '112412', '122114', '122411',
    '142112', '142211', '241211', '221114', '413111', '241112', '134111',
    '111242', '121142', '121241', '114212', '124112', '124211', '411212',
    '421112', '421211', '212141', '214121', '412121', '111143', '111341',
    '131141', '114113', '114311', '411113', '411311', '113141', '114131',
    '311141', '411131', '211412', '211214', '211232', '2331112');

function Code128(Text: AnsiString; var Bars: TBarArray): Integer;
var
  CD: Integer;
  CP: Integer;
  CS: Integer;
  Bar: Integer;
  Subset: AnsiChar;
const
  FNC1Char: AnsiChar = AnsiChar(134);

  procedure AddCode(C: Integer);
  var
    S: AnsiString;
    CX: Integer;
  begin
    if CP = 0 then CS := CS + C else CS := CS + C * CP;
    S := Code128Codes[C];
    for CX := 1 to Length(S) do
    begin
      SetLength(Bars, Length(Bars) + 1);
      with Bars[Length(Bars) - 1] do
      begin
        Width := QPLStrToInt(S[CX]);
        Filled := CX mod 2 = 1;
      end;
    end;
    Inc(CP);
  end;

  function CountDigits(SkipFNC1: Boolean): Integer;
  var
    Index: Integer;
  begin
    Result := 0;
    Index := 0;

    // Skip over any FNC1 characters
    if (SkipFNC1) then
    begin
      while ((Index < Length(Text)) and (Text[Index + 1] = FNC1Char)) do
      begin
        Inc(Index);
      end;
    end;

    // Count the digits
    while ((Index < Length(Text)) and (Text[Index + 1] >= '0')
      and (Text[Index + 1] <= '9')) do
    begin
      Inc(Result);
      Inc(Index);
    end;
  end;

begin
  CP := 0;
  CS := 0;

  Text := QPLStringReplace(Text, '[FNC1]', FNC1Char, [rfReplaceAll]);

  if CountDigits(True) >= 4 then
  begin
    AddCode(105);
    Subset := 'C';
  end else
  begin
    AddCode(104);  
    Subset := 'B';
  end;

  if Length(Text) > 0 then
  repeat
    if (Subset = 'C') then
    begin
      if (QPLCopy(Text, 1, 1) = FNC1Char) then
      begin
        AddCode(102);
        Delete(Text, 1, 1);
      end else
      if (CountDigits(False) >= 2) then
      begin
        AddCode(QPLStrToInt(QPLCopy(Text, 1, 2)));
        Delete(Text, 1, 2);
      end else
      begin
        AddCode(100);
        Subset := 'B';
        AddCode(Ord(Text[1]) - 32);
        Delete(Text, 1, 1);
      end;
    end else
    if (Subset = 'B') then
    begin
      CD := CountDigits(False);
      if CD >= 4 then
      begin
        if CD mod 2 = 1 then
        begin
          AddCode(Ord(Text[1]) - 32);
          Delete(Text, 1, 1);
        end;
        AddCode(99);
        SubSet := 'C';
      end else
      begin
        AddCode(Ord(Text[1]) - 32);
        Delete(Text, 1, 1);
      end;
    end;
  until Length(Text) = 0;

  AddCode(CS mod 103);
  AddCode(106);

  Result := 0;
  for Bar := 0 to Length(Bars) - 1 do
    Result := Result + Bars[Bar].Width;
end;

function PostNet(Text: AnsiString; var Bars: TBarArray): Integer;
var
  X: Integer;
  T: Integer;
  C: Integer;
  B: AnsiString;
const
  PostNetBars: array[0..9] of AnsiString = ('11000', '00011', '00101',
    '00110', '01001', '01010', '01100', '10001', '10010', '10100');
begin
  SetLength(Bars, 1);
  Bars[0].Filled := True;
  T := 0;
  for X := 1 to Length(Text) do
    T := T + Ord(Text[X]) - 48;
  C := 0;
  while (T + C) mod 10 > 0 do
    Inc(C);
  Text := Text + AnsiChar(C + 48);
  for X := 1 to Length(Text) do
  begin
    B := PostNetBars[Ord(Text[X]) - 48];
    while Length(B) > 0 do
    begin
      SetLength(Bars, Length(Bars) + 1);
      Bars[Length(Bars) - 1].Filled := B[1] = '1';
      Delete(B, 1, 1);
    end;
  end;

  SetLength(Bars, Length(Bars) + 1);
  Bars[Length(Bars) - 1].Filled := True;
  Result := Length(Bars);
end;

{ TPDFDataMatrix }

constructor TPDFDataMatrix.Create;
begin
  FEncoding := deASCII;
  FSymbolSize := ssAuto;
end;

procedure TPDFDataMatrix.Encode(const Data: AnsiString);
var
  Row: Integer;
  Col: Integer;
begin
  FData := Data;
  EncodeASCII;
  SetSize;
  SetLength(FPattern, FRows);
  for Row := 1 to FRows do
  begin
    SetLength(FPattern[Row - 1], FCols);
    for Col := 1 to FCols do
      FPattern[Row - 1][Col - 1] := False;
  end;
  for Row := 2 to FRows - 1 do
  begin
    FPattern[Row - 1][1] := True;
    if Row mod 2 = 1 then
      FPattern[Row - 1][FCols - 2] := True;
  end;
  for Col := 2 to FCols - 1 do
  begin
    FPattern[FRows - 2][Col - 1] := True;
    if Col mod 2 = 0 then
      FPattern[1][Col - 1] := True;
  end;
  GenerateMappingMatrix;
  if IsAuto then FSymbolSize := ssAuto;
end;

procedure TPDFDataMatrix.EncodeASCII;
var
  X: Integer;
  S: AnsiString;
  DoubleNum: Boolean;
  ASCII: Boolean;

  AllC40: Boolean;
  NewFData: AnsiString;
  P, V: Integer;
begin
  NewFData := '';

  // From http://en.wikipedia.org/wiki/Data_Matrix
  AllC40 := True;
  for X := 1 to Length(FData) do
    if QPLPos(FData[X], ' 01234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ') = 0 then
      AllC40 := False;

  if (AllC40) then
  begin
    NewFData := #230;   // Begin C40 encoding
    P := 1;             // FData Pos

    while (P <= Length(FData) - 2) do
    begin
      V := C40Mapping[Ord(FData[P])] * 1600 +
           C40Mapping[Ord(FData[P+1])] * 40 +
           C40Mapping[Ord(FData[P+2])] + 1;

      NewFData := NewFData + AnsiChar(V div 256);
      NewFData := NewFData + AnsiChar(V mod 256);
      Inc(P, 3);
    end;

    if (P <= Length(FData)) then
    begin
      NewFData := NewFData + #254; // Begin ASCII encoding
      NewFData := NewFData + AnsiChar(Ord(FData[P]) + 1);
      Inc(P);
      if (P < Length(FData)) then
        NewFData := NewFData + AnsiChar(Ord(FData[P]) + 1);
    end;

    NewFData := NewFData + #254 + #129;  // Switch to ASCII + End of Message
  end
  else
    NewFData := NewFData + #254 + #129;  // Switch to ASCII + End of Message

  S := FData;
  FData := '';
  X := 0;
  while X < Length(S) do
  begin
    Inc(X);
    DoubleNum := False;
    ASCII := False;
    if (X < Length(S)) then
    begin
      if (S[X] >= '0') and (S[X] <= '9') and
        (S[X + 1] >= '0') and (S[X + 1] <= '9') then
          DoubleNum := True;
    end;
    if not DoubleNum then
    begin
      if Ord(S[X]) <= 127 then
        ASCII := True;
    end;
    if ASCII then
    begin
      FData := FData + AnsiChar(Ord(S[X]) + 1);
    end else
    if DoubleNum then
    begin
      FData := FData + AnsiChar(QPLStrToIntDef(S[X] + S[X + 1], 0) + 130);
      Inc(X);
    end else
      FData := FData + #235 + AnsiChar(Ord(S[X]) - 127);
  end;

  // Use the shortest length to allow for longest possible data length.
  if AllC40 and (Length(NewFData) < Length(FData)) then
    FData := NewFData;
end;

procedure TPDFDataMatrix.GenerateMappingMatrix;
var
  RS: TReedSolomon;
  ECC: AnsiString;
  X: Integer;
  DC: Integer;
  Blocks: array of AnsiString;
  ECCBlocks: array of AnsiString;
  Offset: Integer;
  Combined: AnsiString;
  Matrix: TECC200MappingMatrix;
  Row, Col: Integer;
  NR, NC: Integer;
begin
  ECC := '';
  Combined := '';
  SetLength(Blocks, FInterleave);
  SetLength(ECCBlocks, FInterleave);
  for X := 0 to FInterleave - 1 do
  begin
    Blocks[X] := '';
    ECCBlocks[X] := '';
  end;
  if FSymbolSize = ss144x144 then
  begin
    DC := 156;
    Offset := 1;
    repeat
      for X := 0 to FInterleave - 1 do
      begin
        if Offset <= 1558 then
          Blocks[X] := Blocks[X] + FData[Offset];
        Inc(Offset);
      end;
    until Length(Blocks[0]) = DC;

    for X := 0 to FInterleave - 1 do
    begin
      RS := TReedSolomon.Create(Length(Blocks[X]), FErrorCount div FInterleave);
      try
        ECCBlocks[X] := RS.GenerateECCCodes(Blocks[X]);
      finally
        RS.Free;
      end;
    end;
  end else
  begin
    DC := FDataCount div FInterleave;
    Offset := 1;
    repeat
      for X := 0 to FInterleave - 1 do
      begin
        Blocks[X] := Blocks[X] + FData[Offset];
        Inc(Offset);
      end;
    until Length(Blocks[0]) = DC;
    RS := TReedSolomon.Create(DC, FErrorCount div FInterleave);
    try
      for X := 0 to FInterleave - 1 do
        ECCBlocks[X] := RS.GenerateECCCodes(Blocks[X]);
    finally
      RS.Free;
    end;
  end;
  ECC := '';
  Offset := 1;
  repeat
    for X := 0 to FInterleave - 1 do
      ECC := ECC + ECCBlocks[X][Offset];
    Inc(Offset);
  until Length(ECC) = FErrorCount;
  FData := FData + ECC;
  Matrix := TECC200MappingMatrix.Create;
  try
    Matrix.CreateMatrix(FMapRows, FMapCols, FData);
    case FRegions of
      1:
      begin
        for Row := 0 to FMapRows - 1 do
          for Col := 0 to FMapCols - 1 do
            FPattern[Row + 2][Col + 2] := Matrix.GetBit(Row, Col);
      end;
      2:
      begin
        for Row := 0 to FMapRows - 1 do
        begin
          for Col := 0 to FMapCols - 1 do
          begin
            if Col < (FMapCols div 2) then
              FPattern[Row + 2][Col + 2] := Matrix.GetBit(Row, Col)
            else
              FPattern[Row + 2][Col + 4] := Matrix.GetBit(Row, Col);
          end;
          FPattern[Row + 2][FMapCols div 2 + 2] := Row mod 2 = 0;
          FPattern[Row + 2][FMapCols div 2 + 3] := True;
        end;
      end;
      4:
      begin
        NR := 2;
        for Row := 0 to FMapRows - 1 do
        begin
          if Row = (FMapRows div 2) then Inc(NR, 2);
          NC := 2;
          for Col := 0 to FMapCols - 1 do
          begin
            if Col = (FMapCols div 2) then Inc(NC, 2);
            FPattern[NR][NC] := Matrix.GetBit(Row, Col);
            Inc(NC);
          end;
          Inc(NR);
        end;
        for Row := 0 to FMapRows + 2 do
        begin
          FPattern[Row + 2][FMapCols div 2 + 2] := Row mod 2 = 0;
          FPattern[Row + 2][FMapCols div 2 + 3] := True;
        end;
        for Col := 0 to FMapCols + 2 do
        begin
          FPattern[FMapRows div 2 + 3][Col + 2] := Col mod 2 = 1;
          FPattern[FMapRows div 2 + 2][Col + 2] := True;
        end;
      end;
      16:
      begin
        NR := 2;
        for Row := 0 to FMapRows - 1 do
        begin
          if Row = (FMapRows div 4) then Inc(NR, 2);
          if Row = (FMapRows div 4 * 2) then Inc(NR, 2);
          if Row = (FMapRows div 4 * 3) then Inc(NR, 2);
          NC := 2;
          for Col := 0 to FMapCols - 1 do
          begin
            if Col = (FMapCols div 4) then Inc(NC, 2);
            if Col = (FMapCols div 4 * 2) then Inc(NC, 2);
            if Col = (FMapCols div 4 * 3) then Inc(NC, 2);
            FPattern[NR][NC] := Matrix.GetBit(Row, Col);
            Inc(NC);
          end;
          Inc(NR);
        end;
        for Row := 0 to FMapRows + 6 do
        begin
          FPattern[Row + 2][FMapCols div 4 + 2] := Row mod 2 = 0;
          FPattern[Row + 2][FMapCols div 4 + 3] := True;
          FPattern[Row + 2][FMapCols div 4 * 2 + 4] := Row mod 2 = 0;
          FPattern[Row + 2][FMapCols div 4 * 2 + 5] := True;
          FPattern[Row + 2][FMapCols div 4 * 3 + 6] := Row mod 2 = 0;
          FPattern[Row + 2][FMapCols div 4 * 3 + 7] := True;
        end;
        for Col := 0 to FMapCols + 6 do
        begin
          FPattern[FMapRows div 4 + 3][Col + 2] := Col mod 2 = 1;
          FPattern[FMapRows div 4 + 2][Col + 2] := True;
          FPattern[FMapRows div 4 * 2 + 5][Col + 2] := Col mod 2 = 1;
          FPattern[FMapRows div 4 * 2 + 4][Col + 2] := True;
          FPattern[FMapRows div 4 * 3 + 7][Col + 2] := Col mod 2 = 1;
          FPattern[FMapRows div 4 * 3 + 6][Col + 2] := True;
        end;
      end;
      36:
      begin
        NR := 2;
        for Row := 0 to FMapRows - 1 do
        begin
          if Row = (FMapRows div 6) then Inc(NR, 2);
          if Row = (FMapRows div 6 * 2) then Inc(NR, 2);
          if Row = (FMapRows div 6 * 3) then Inc(NR, 2);
          if Row = (FMapRows div 6 * 4) then Inc(NR, 2);
          if Row = (FMapRows div 6 * 5) then Inc(NR, 2);
          NC := 2;
          for Col := 0 to FMapCols - 1 do
          begin
            if Col = (FMapCols div 6) then Inc(NC, 2);
            if Col = (FMapCols div 6 * 2) then Inc(NC, 2);
            if Col = (FMapCols div 6 * 3) then Inc(NC, 2);
            if Col = (FMapCols div 6 * 4) then Inc(NC, 2);
            if Col = (FMapCols div 6 * 5) then Inc(NC, 2);
            FPattern[NR][NC] := Matrix.GetBit(Row, Col);
            Inc(NC);
          end;
          Inc(NR);
        end;
        for Row := 0 to FMapRows + 10 do
        begin
          FPattern[Row + 2][FMapCols div 6 + 2] := Row mod 2 = 0;
          FPattern[Row + 2][FMapCols div 6 + 3] := True;
          FPattern[Row + 2][FMapCols div 6 * 2 + 4] := Row mod 2 = 0;
          FPattern[Row + 2][FMapCols div 6 * 2 + 5] := True;
          FPattern[Row + 2][FMapCols div 6 * 3 + 6] := Row mod 2 = 0;
          FPattern[Row + 2][FMapCols div 6 * 3 + 7] := True;
          FPattern[Row + 2][FMapCols div 6 * 4 + 8] := Row mod 2 = 0;
          FPattern[Row + 2][FMapCols div 6 * 4 + 9] := True;
          FPattern[Row + 2][FMapCols div 6 * 5 + 10] := Row mod 2 = 0;
          FPattern[Row + 2][FMapCols div 6 * 5 + 11] := True;
        end;
        for Col := 0 to FMapCols + 10 do
        begin
          FPattern[FMapRows div 6 + 3][Col + 2] := Col mod 2 = 1;
          FPattern[FMapRows div 6 + 2][Col + 2] := True;
          FPattern[FMapRows div 6 * 2 + 5][Col + 2] := Col mod 2 = 1;
          FPattern[FMapRows div 6 * 2 + 4][Col + 2] := True;
          FPattern[FMapRows div 6 * 3 + 7][Col + 2] := Col mod 2 = 1;
          FPattern[FMapRows div 6 * 3 + 6][Col + 2] := True;
          FPattern[FMapRows div 6 * 4 + 9][Col + 2] := Col mod 2 = 1;
          FPattern[FMapRows div 6 * 4 + 8][Col + 2] := True;
          FPattern[FMapRows div 6 * 5 + 11][Col + 2] := Col mod 2 = 1;
          FPattern[FMapRows div 6 * 5 + 10][Col + 2] := True;
        end;
      end;
    end;
  finally
    Matrix.Free;
  end;
end;

procedure TPDFDataMatrix.SetSize;
var
  PseudoRandom: Integer;
  Temp: Integer;
  X: Integer;
begin

  if FSymbolSize = ssAuto then
  begin
    IsAuto := True;
    FSymbolSize := ss10x10;
    while (PDFDataMatrixData[FSymbolSize] < Length(FData)) and
      (FSymbolSize < ss144x144) do
        Inc(FSymbolSize);
  end;

  case FSymbolSize of
    ss10x10: begin FRows := 10; FCols := 10; end;
    ss12x12: begin FRows := 12; FCols := 12; end;
    ss8x18: begin FRows := 8; FCols := 18; end;
    ss14x14: begin FRows := 14; FCols := 14; end;
    ss8x32: begin FRows := 8; FCols := 32; end;
    ss16x16: begin FRows := 16; FCols := 16; end;
    ss12x26: begin FRows := 12; FCols := 26; end;
    ss18x18: begin FRows := 18; FCols := 18; end;
    ss12x36: begin FRows := 12; FCols := 36; end;
    ss20x20: begin FRows := 20; FCols := 20; end;
    ss22x22: begin FRows := 22; FCols := 22; end;
    ss16x36: begin FRows := 16; FCols := 36; end;
    ss24x24: begin FRows := 24; FCols := 24; end;
    ss26x26: begin FRows := 26; FCols := 26; end;
    ss16x48: begin FRows := 16; FCols := 48; end;
    ss32x32: begin FRows := 32; FCols := 32; end;
    ss36x36: begin FRows := 36; FCols := 36; end;
    ss40x40: begin FRows := 40; FCols := 40; end;
    ss44x44: begin FRows := 44; FCols := 44; end;
    ss48x48: begin FRows := 48; FCols := 48; end;
    ss52x52: begin FRows := 52; FCols := 52; end;
    ss64x64: begin FRows := 64; FCols := 64; end;
    ss72x72: begin FRows := 72; FCols := 72; end;
    ss80x80: begin FRows := 80; FCols := 80; end;
    ss88x88: begin FRows := 88; FCols := 88; end;
    ss96x96: begin FRows := 96; FCols := 96; end;
    ss104x104: begin FRows := 104; FCols := 104; end;
    ss120x120: begin FRows := 120; FCols := 120; end;
    ss132x132: begin FRows := 132; FCols := 132; end;
    ss144x144: begin FRows := 144; FCols := 144; end;
  end;
  FRows := FRows + 2;
  FCols := FCols + 2;

  FData := QPLCopy(FData, 1, PDFDataMatrixData[FSymbolSize]);
  FDataCount := PDFDataMatrixData[FSymbolSize];
  FErrorCount := PDFDataMatrixError[FSymbolSize];
  FMapRows := PDFDataMatrixMapRows[FSymbolSize];
  FMapCols := PDFDataMatrixMapCols[FSymbolSize];
  FInterleave := PDFDataMatrixInterleave[FSymbolSize];
  FRegions := PDFDataMatrixRegions[FSymbolSize];

  if Length(FData) < FDataCount then
    FData := FData + #129;

  X := Length(FData) + 1;
  while Length(FData) < FDataCount do
  begin
    PseudoRandom := ((149 * X) mod 253) + 1;
    Temp := 129 + PseudoRandom;
    if Temp <= 254 then FData := FData + AnsiChar(Temp) else
      FData := FData + AnsiChar(Temp - 254);
    Inc(X);
  end;
end;

{ TPDF2DBarcode }

function TPDF2DBarcode.GetModule(Row, Col: Integer): Boolean;
begin
  Result := False;
  if (Row > 0) and (Col > 0) then
  begin
    if Row <= Length(FPattern) then
    begin
      if Col <= Length(FPattern[Row - 1]) then
        Result := FPattern[Row - 1][Col - 1];
    end;
  end;
end;

{ TReedSolomon }

constructor TReedSolomon.Create(DataCount, ErrorCount: Integer);
begin
  FDataCount := DataCount;
  FErrorCount := ErrorCount;
  GenerateGF;
  GenerateGenPoly;
end;

function TReedSolomon.GenerateECCCodes(const Source: AnsiString): AnsiString;
var
  I: Integer;
  LFSR: array of Integer;
  DByte: Integer;
  J: Integer;
begin
  Result := '';
  SetLength(LFSR, FErrorCount + 1);
  for I := 0 to FErrorCount do
    LFSR[I] := 0;
  for I := 0 to FDataCount - 1 do
  begin
    DByte := Ord(Source[I + 1]) xor LFSR[FErrorCount - 1];
    for J := (FErrorCount - 1) downto 1 do
      LFSR[J] := LFSR[J - 1] xor GFMultiply(FGenPoly[J], dByte);
    LFSR[0] := GFMultiply(FGenPoly[0], DByte);
  end;
  SetLength(Result, FErrorCount);
  for J := 0 to FErrorCount - 1 do
    Result[FErrorCount - J] := AnsiChar(LFSR[J]);
end;

procedure TReedSolomon.GenerateGenPoly;
var
  S: AnsiString;
  X: Integer;
begin
  S := '';
  case FErrorCount of
    5: S := #62#111#15#48#228;
    7: S := #254#92#240#134#144#68#23;
    10: S := #61#110#255#116#248#223#166#185#24#28;
    11: S := #120#97#60#245#39#168#194#12#205#138#175;
    12: S := #242#100#178#97#213#142#42#61#91#158#153#41;
    14: S := #185#83#186#18#45#138#119#157#9#95#252#192#97#156;
    18: S := #188#90#48#225#254#94#129#109#213#241#61#66#75#188#39#100#195#83;
    20: S := #172#186#174#27#82#108#79#253#145#153#160#188#2#168#71#233#9#244 +
        #195#15;
    24: S := #193#50#96#184#181#12#124#254#172#5#21#155#223#251#197#155#21#176 +
        #39#109#205#88#190#52;
    28: S := #255#93#168#233#151#120#136#141#213#110#138#17#121#249#34#75#53 +
        #170#151#37#174#103#96#71#97#43#231#211;
    36: S := #112#81#98#225#25#59#184#175#44#115#119#95#137#101#33#68#4#2#18 +
        #229#182#80#251#220#179#84#120#102#181#162#250#130#218#242#127#245;
    42: S := #5#9#5#226#177#150#50#69#202#248#101#54#57#253#1#21#121#57#111#214 +
        #105#167#9#100#95#175#8#242#133#245#2#122#105#247#153#22#38#19#31#137 +
        #193#77;
    48: S := #19#225#253#92#213#69#175#160#147#187#87#176#44#82#240#186#138#66 +
        #100#120#88#131#205#170#90#37#23#118#147#16#106#191#87#237#188 +
        #205#231#238#133#238#22#117#32#96#223#172#132#245;
    56: S := #46#143#53#233#107#203#43#155#28#247#67#127#245#137#13#164#207#62 +
        #117#201#150#22#238#144#232#29#203#117#234#218#146#228#54#132#200 +
        #38#223#36#159#150#235#215#192#230#170#175#29#100#208#220#17#12 +
        #238#223#9#175;
    62: S := #204#11#47#86#124#224#166#94#7#232#107#4#170#176#31#163#17#188 +
        #130#40#10#87#63#51#218#27#6#147#44#161#71#114#64#175#221#185#106#250 +
        #190#197#63#245#230#134#112#185#37#196#108#143#189#201#188#202#118 +
        #39#210#144#50#169#93#242;
    68: S := #186#82#103#96#63#132#153#108#54#64#189#211#232#49#25#172#52#59 +
        #241#181#239#223#136#231#210#96#232#220#25#179#167#202#185#153#139#66 +
        #236#227#160#15#213#93#122#68#177#158#197#234#180#248#136#213#127 +
        #73#36#154#244#147#33#89#56#159#149#251#89#173#228#220;
  end;
  SetLength(FGenPoly, Length(S) + 1);
  for X := 0 to Length(S) - 1 do
    FGenPoly[X] := Ord(S[Length(S) - X]);
  FGenPoly[Length(FGenPoly) - 1] := 1;
end;

procedure TReedSolomon.GenerateGF;
var
  I: Cardinal;
begin
  FLog[0] := 1 - 256;
  FALog[0] := 1;
  for I := 1 to 255 do
  begin
    FALog[I] := FALog[I - 1] * 2;
    if (FALog[I] >= 256) then FALog[I] := FALog[I] xor 301;
    FLog[FALog[I]] := I;
  end;
end;

function TReedSolomon.GFMultiply(A, B: Byte): Byte;
begin
  if (A > 0) and (B > 0) then
  begin
    Result := FALog[(FLog[A] + FLog[B]) mod 255];
  end else
    Result := 0;
end;

{ TECC200MappingMatrix }

procedure TECC200MappingMatrix.Module(Row, Col, C, Bit: Integer);
var
  B: Byte;
  M: Byte;
begin
  if (Row < 0) then
  begin
    Row := Row + NRow;
    Col := Col + 4 - ((NRow + 4) mod 8);
  end;
  if (Col < 0) then
  begin
    Col := Col + NCol;
    Row := Row + 4 - ((NCol + 4) mod 8);
  end;
  MM[Row * NCol + Col] := 10 * C + Bit;
  M := (1 shl (8 - Bit));
  B := Ord(FSource[C]);
  FBits[Row, Col] := B and M = M;
end;

procedure TECC200MappingMatrix.Utah(Row, Col, C: Integer);
begin
  Module(Row - 2, Col - 2, C, 1);
  Module(Row - 2, Col-1, C, 2);
  Module(Row - 1, Col-2, C, 3);
  Module(Row - 1, Col-1, C, 4);
  Module(Row - 1, Col, C, 5);
  Module(Row, Col - 2, C, 6);
  Module(Row, Col - 1, C, 7);
  Module(Row, Col, C, 8);
end;

procedure TECC200MappingMatrix.Corner1(C: Integer);
begin
  Module(NRow - 1, 0, C, 1);
  Module(NRow - 1, 1, C, 2);
  Module(NRow - 1, 2, C, 3);
  Module(0, NCol - 2, C, 4);
  Module(0, NCol - 1, C, 5);
  Module(1, NCol - 1, C, 6);
  Module(2, NCol - 1, C, 7);
  Module(3, NCol - 1, C, 8);
end;

procedure TECC200MappingMatrix.Corner2(C: Integer);
begin
  Module(NRow - 3, 0, C, 1);
  Module(NRow - 2, 0, C, 2);
  Module(NRow - 1, 0, C, 3);
  Module(0, NCol - 4, C, 4);
  Module(0, NCol - 3, C, 5);
  Module(0, NCol - 2, C, 6);
  Module(0, NCol - 1, C, 7);
  Module(1, NCol - 1, C, 8);
end;

procedure TECC200MappingMatrix.Corner3(C: Integer);
begin
  Module(NRow - 3, 0, C, 1);
  Module(NRow - 2, 0, C, 2);
  Module(NRow - 1, 0, C, 3);
  Module(0, NCol - 2, C, 4);
  Module(0, NCol - 1, C, 5);
  Module(1, NCol - 1, C, 6);
  Module(2, NCol - 1, C, 7);
  Module(3, NCol - 1, C, 8);
end;

procedure TECC200MappingMatrix.Corner4(C: Integer);
begin
  Module(NRow - 1, 0, C, 1);
  Module(NRow - 1, NCol - 1, C, 2);
  Module(0, NCol - 3, C, 3);
  Module(0, NCol - 2, C, 4);
  Module(0, NCol - 1, C, 5);
  Module(1, NCol - 3, C, 6);
  Module(1, NCol - 2, C, 7);
  Module(1, NCol - 1, C, 8);
end;

procedure TECC200MappingMatrix.ECC200;
var
  Row, Col, C: Integer;
begin
  for Row := 0 to NRow - 1 do
    for Col := 0 to NCol - 1 do
      MM[Row * NCol + Col] := 0;
  C := 1;
  Row := 4;
  Col := 0;
  repeat
    if ((Row = NRow) and (Col = 0)) then
    begin
      Corner1(C);
      C := C + 1;
    end;
    if ((Row = NRow - 2) and (Col = 0) and (NCol mod 4 > 0)) then
    begin
      Corner2(C);
      C := C + 1;
    end;
    if ((Row = NRow - 2) and (Col = 0) and (NCol mod 8 = 4)) then
    begin
      Corner3(C);
      C := C + 1;
    end;
    if ((Row = NRow + 4) and (Col = 2) and ((NCol mod 8) = 0)) then
    begin
      Corner4(C);
      C := C + 1;
    end;
    repeat
      if ((Row < NRow) and (Col >= 0) and (MM[Row * NCol + Col] = 0)) then
      begin
        Utah(Row, Col, C);
        C := C + 1;
      end;
      Row := Row - 2;
      Col := Col + 2;
    until not ((Row >= 0) and (Col < NCol));
    Row := Row + 1;
    Col := Col + 3;
    repeat
      if ((Row >= 0) and (Col < NCol) and (MM[Row * NCol + Col] = 0)) then
      begin
        Utah(Row, Col, C);
        C := C + 1;
      end;
      Row := Row + 2;
      Col := Col - 2;
    until not ((Row < NRow) and (Col >= 0));
    Row := Row + 3;
    Col := Col + 1;
  until not ((Row < NRow) or (Col < NCol));
  if (MM[NRow * NCol - 1] = 0) then
  begin
    FBits[NRow - 1][NCol - 1] := True;
    FBits[NRow - 2][NCol - 2] := True;
  end;
end;

procedure TECC200MappingMatrix.CreateMatrix(Rows, Cols: Integer;
  const Source: AnsiString);
var
  I: Integer;
  J: Integer;
  D: Integer;
begin
  NRow := Rows;
  NCol := Cols;
  SetLength(MM, NRow * NCol);
  SetLength(FBits, NRow);
  for I := 0 to NRow - 1 do
  begin
    SetLength(FBits[I], NCol);
    for J := 0 to NCol - 1 do
      FBits[I][J] := False;
  end;
  D := NRow * NCol div 8;
  if D * 8 < (NRow * NCol) then Inc(D); 
  FSource := QPLCopy(Source, 1, D);
  while Length(FSource) < D do
    FSource := FSource + #0;
  ECC200;
end;

function TECC200MappingMatrix.GetBit(Row, Col: Integer): Boolean;
begin
  if (Row >= 0) and (Col >= 0) and (Row < NRow) and (Col < NCol) then
    Result := FBits[Row][Col]
  else
    Result := False;
end;

end.
