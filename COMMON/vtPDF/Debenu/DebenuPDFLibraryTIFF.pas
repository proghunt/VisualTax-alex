{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryTIFF.pas                               }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryTIFF;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  Classes, DebenuPDFLibraryExtra, DebenuPDFLibraryPicasso, DebenuPDFLibraryTypes;

type
  TTIFFCompression = (ttUnknown, ttCCITT4, ttNone, ttComp, ttCCITT31d, ttCCITT32d, ttPackbits, ttJPEG, ttDeflate);
  TTIFFPhotometricInterpretation = (piWhiteIsZero, piBlackIsZero, piRGB,
    piRGBPalette, piTransparencyMask, piCMYK, piYCbCr, piCIELab);
  TTIFFPlanarConfiguration = (pcChunky, pcPlanar);

  PTIFFPage = ^TTIFFPage;
  TTIFFPage = record
    Width: Integer;
    Height: Integer;
    Compression: TTIFFCompression;
    PhotometricInterpretation: TTIFFPhotometricInterpretation;
    XRes: Integer;
    YRes: Integer;
    RowsPerStrip: Integer;
    Reversed: Boolean;
    BitsPerSample: Integer;
    SamplesPerPixel: Integer;
    ExtraSamples: Integer;
    Predictor: Integer;
    FillOrder: Integer;
    StripsAreTiles: Boolean;
    ColumnsPerTile: Integer;
    RowsPerTile: Integer;
    Strips: array of AnsiString;
    EncodedByteAlign: Boolean;
    PaletteValues: TQPLIntegerArray;
    PlanarConfiguration: TTIFFPlanarConfiguration;
  end;

  TTIFFEntry = record
    Tag: Word;
    TagType: Word;
    Length: Cardinal;
    Offset: Cardinal;
    StringValue: AnsiString;
    IntegerValues: TQPLIntegerArray;
    DoubleValues: TQPLDoubleArray;
  end;

  TPDFTIFF = class
  private
    FValidTIFF: Boolean;
    FPageCount: Word;
    FPages: array of TTIFFPage;
    FBitmap: TBitmap;
    FFirstIFDPosition: Integer;
    FIFDPointers: array of AnsiString;
    FHasJPEGTags: Boolean;
    function GetPageInfo(Index: Integer): TTIFFPage;
  public
    constructor Create; overload;
    constructor Create(Page: TTIFFPage); overload;
    destructor Destroy; override;
    procedure LoadFromFile(const FileName: WideString);
    procedure LoadFromString(const Source: AnsiString; ReqPageNo: Integer = -1);
    procedure LoadFromStream(InStream: TStream; ReqPageNo: Integer = -1);
    function SaveToString: AnsiString;
    procedure SaveToStream(OutStream: TStream);
    property PageInfo[Index: Integer]: TTIFFPage read GetPageInfo;
    procedure SimpleExtract(Page: Integer);
    procedure CompDecode(Page: Integer);
    function GetIFDPointer(Page: Integer): AnsiString;
    property ValidTIFF: Boolean read FValidTIFF;
    property PageCount: Word read FPageCount;
    property Bitmap: TBitmap read FBitmap;
    property FirstIFDPosition: Integer read FFirstIFDPosition;
    property HasJPEGTags: Boolean read FHasJPEGTags;
  end;

  TPDFTIFFMaker = class
  private
    FSource: AnsiString;
    FWidth: Integer;
    FHeight: Integer;
    FCompression: TTIFFCompression;
    FReversed: Boolean;
    FTags: array of TTIFFEntry;
    FHorizontalDPI: Integer;
    FVerticalDPI: Integer;
    FEncodedByteAlign: Boolean;
  public
    constructor Create;
    procedure WriteTIFFToStream(FStream: TStream);
    property Source: AnsiString read FSource write FSource;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    property Compression: TTIFFCompression read FCompression write FCompression;
    property Reversed: Boolean read FReversed write FReversed;
    property HorizontalDPI: Integer read FHorizontalDPI write FHorizontalDPI;
    property VerticalDPI: Integer read FVerticalDPI write FVerticalDPI;
    property EncodedByteAlign: Boolean read FEncodedByteAlign write FEncodedByteAlign;
  end;

  TDPLTIFFScissors = class
  private
    FValidTIFF: Boolean;
    FIntelBytes: Boolean;
    FSource: TStream;
    FIFDList: array of Cardinal;
    FIFDCount: Integer;
    function PopWord: Word;
    function PopCardinal: Cardinal;
  public
    constructor Create(ASource: TStream);
    procedure ShiftOffsets(Offset: Integer);
    function FirstIFDPos: Cardinal;
    procedure SetLastIFD(NextPos: Cardinal);
  end;

  function FixG4EOL(const Source: AnsiString; Rows, Columns: Integer): AnsiString;

  procedure ConvertBitmapToTIFF(BM: TBitmap; OutStream: TStream; Settings: TGDIPlusSettings; DPI: Double);
  procedure ConvertBitmapToG4TIFF(BM: TBitmap; OutStream: TStream; Settings: TGDIPlusSettings; DPI: Double);
  procedure ConcatenateTIFFStream(OriginalStream, NewStream: TStream);

implementation

uses
  SysUtils, DebenuPDFLibraryLZW, DebenuPDFLibraryGDIPlus;

const
  FillSwapped: array[0..255] of Byte = (0, 128, 64, 192, 32, 160, 96, 224, 16,
    144, 80, 208, 48, 176, 112, 240, 8, 136, 72, 200, 40, 168, 104, 232, 24,
    152, 88, 216, 56, 184, 120, 248, 4, 132, 68, 196, 36, 164, 100, 228, 20,
    148, 84, 212, 52, 180, 116, 244, 12, 140, 76, 204, 44, 172, 108, 236, 28,
    156, 92, 220, 60, 188, 124, 252, 2, 130, 66, 194, 34, 162, 98, 226, 18,
    146, 82, 210, 50, 178, 114, 242, 10, 138, 74, 202, 42, 170, 106, 234, 26,
    154, 90, 218, 58, 186, 122, 250, 6, 134, 70, 198, 38, 166, 102, 230, 22,
    150, 86, 214, 54, 182, 118, 246, 14, 142, 78, 206, 46, 174, 110, 238, 30,
    158, 94, 222, 62, 190, 126, 254, 1, 129, 65, 193, 33, 161, 97, 225, 17,
    145, 81, 209, 49, 177, 113, 241, 9, 137, 73, 201, 41, 169, 105, 233, 25,
    153, 89, 217, 57, 185, 121, 249, 5, 133, 69, 197, 37, 165, 101, 229, 21,
    149, 85, 213, 53, 181, 117, 245, 13, 141, 77, 205, 45, 173, 109, 237, 29,
    157, 93, 221, 61, 189, 125, 253, 3, 131, 67, 195, 35, 163, 99, 227, 19,
    147, 83, 211, 51, 179, 115, 243, 11, 139, 75, 203, 43, 171, 107, 235, 27,
    155, 91, 219, 59, 187, 123, 251, 7, 135, 71, 199, 39, 167, 103, 231, 23,
    151, 87, 215, 55, 183, 119, 247, 15, 143, 79, 207, 47, 175, 111, 239, 31,
    159, 95, 223, 63, 191, 127, 255);

{ TPDFTIFF }

constructor TPDFTIFF.Create;
begin
  inherited Create;
  FHasJPEGTags := False;
  FValidTIFF := False;
  FPageCount := 0;
  SetLength(FPages, 0);
  FBitmap := TBitmap.Create;
end;

procedure FixFillOrder(var S: AnsiString);
var
  X: Integer;
begin
  for X := 1 to Length(S) do
    S[X] := AnsiChar(FillSwapped[Ord(S[X])]);
end;

destructor TPDFTIFF.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

function TPDFTIFF.GetPageInfo(Index: Integer): TTIFFPage;
begin
  if (Index >= 1) and (Index <= FPageCount) then
    Result := FPages[Index - 1];
end;

procedure TPDFTIFF.LoadFromFile(const FileName: WideString);
var
  FS: TQuickPDFWideFileStream;
  Data: AnsiString;
begin
  FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
  try
    SetLength(Data, FS.Size);
    FS.Read(Data[1], Length(Data));
  finally
    FS.Free;
  end;
  LoadFromString(Data);
end;

const
  TagTypeSizes: array[1..12] of Cardinal = (1, 1, 2, 4, 8, 1, 1, 2, 4, 8, 4, 8);

procedure TPDFTIFF.LoadFromString(const Source: AnsiString; ReqPageNo: Integer = -1);
var
  S: AnsiString;
  P: Integer;
  X: Integer;
  Y: Integer;
  IntelBytes: Boolean;
  IFDOffset: Cardinal;
  DECount: Word;
  E: TTIFFEntry;
  Temp: Cardinal;
  Page: Integer;
  StripOffsets: array of Cardinal;
  StripLengths: array of Cardinal;
  XResDouble: Double;
  YResDouble: Double;
  ResolutionUnits: Cardinal;
  CS, CE: Integer;
  JpegModifier: AnsiString;

  function PopByte: Byte;
  begin
    Result := Ord(Source[P]);
    Inc(P);
  end;

  function PopWord: Word;
  begin
    if IntelBytes then
      Result := Ord(Source[P]) + Ord(Source[P + 1]) shl 8
    else
      Result := Ord(Source[P + 1]) + Ord(Source[P]) shl 8;
    Inc(P, 2);
  end;

  function PopCardinal: Cardinal;
  begin
    if IntelBytes then
      Result := Ord(Source[P]) + Ord(Source[P + 1]) shl 8 +
        Ord(Source[P + 2]) shl 16 + Ord(Source[P + 3]) shl 24
    else
      Result := Ord(Source[P + 3]) + Ord(Source[P + 2]) shl 8 +
        Ord(Source[P + 1]) shl 16 + Ord(Source[P + 0]) shl 24;
    Inc(P, 4);
  end;

  function PopDE: TTIFFEntry;
  var
    TypeSize: Cardinal;
    ValueOffset: Integer;
    LastPosition: Integer;
    ValueIndex: Integer;
    Numerator: Double;
    Denominator: Double;
    SingleValue: Single;
    DoubleValue: Double;
  begin
    Result.StringValue := '';
    SetLength(Result.IntegerValues, 0);
    SetLength(Result.DoubleValues, 0);

    Result.Tag := PopWord;
    Result.TagType := PopWord;
    Result.Length := PopCardinal;
    ValueOffset := P - 1;
    Result.Offset := PopCardinal;
    LastPosition := P;

    if (Result.Length > 0) and (Result.TagType >= 1) and (Result.TagType <= 12) then
    begin
      TypeSize := TagTypeSizes[Result.TagType];
      if (TypeSize * Result.Length) > 4 then
      begin
        ValueOffset := Result.Offset;
      end;

      SetLength(Result.IntegerValues, Result.Length);
      SetLength(Result.DoubleValues, Result.Length);

      P := ValueOffset + 1;

      if (Result.TagType = 2) then
      begin
        // ASCII
        if (Result.Length > 1) then
        begin
          SetLength(Result.StringValue, Result.Length - 1);
          Move(Source[P], Result.StringValue[1], Result.Length);
        end;
      end else
      if (Result.TagType = 7) then
      begin
        // UNDEFINED
        if (Result.Length > 0) then
        begin
          SetLength(Result.StringValue, Result.Length);
          Move(Source[P], Result.StringValue[1], Result.Length);
        end;
      end else
      begin
        for ValueIndex := 0 to Result.Length - 1 do
        begin
          case Result.TagType of
            1: // BYTE
            begin
              Result.IntegerValues[ValueIndex] := PopByte;
            end;
            3: // SHORT
            begin
              Result.IntegerValues[ValueIndex] := PopWord;
            end;
            4: // LONG
            begin
              Result.IntegerValues[ValueIndex] := PopCardinal;
            end;
            5: // RATIONAL
            begin
              Numerator := PopCardinal;
              Denominator := PopCardinal;
              if (Denominator <> 0) then
              begin
                Result.DoubleValues[ValueIndex] := Numerator / Denominator;
              end else
              begin
                Result.DoubleValues[ValueIndex] := 0;
              end;
            end;
            6: // SBYTE
            begin
              Result.IntegerValues[ValueIndex] := ShortInt(PopByte);
            end;
            8: // SSHORT
            begin
              Result.IntegerValues[ValueIndex] := SmallInt(PopWord);
            end;
            9: // SLONG
            begin
              Result.IntegerValues[ValueIndex] := Integer(PopCardinal);
            end;
            10: // SRATIONAL
            begin
              Numerator := Integer(PopCardinal);
              Denominator := Integer(PopCardinal);
              if (Denominator <> 0) then
              begin
                Result.DoubleValues[ValueIndex] := Numerator / Denominator;
              end else
              begin
                Result.DoubleValues[ValueIndex] := 0;
              end;
            end;
            11: // FLOAT
            begin
              Move(Source[P], SingleValue, 4);
              Inc(P, 4);
              Result.DoubleValues[ValueIndex] := SingleValue;
            end;
            12: // DOUBLE
            begin
              Move(Source[P], DoubleValue, 8);
              Inc(P, 8);
              Result.DoubleValues[ValueIndex] := DoubleValue;
            end;
          end;
        end;
      end;

      P := LastPosition;
    end;

    if (Result.Length = 0) then
    begin
      SetLength(Result.IntegerValues, 1);
      Result.IntegerValues[0] := 0;
      SetLength(Result.DoubleValues, 1);
      Result.DoubleValues[0] := 0;
    end;
  end;

begin
  FValidTIFF := False;
  S := QPLCopy(Source, 1, 2);
  if (S = 'II') or (S = 'MM') then
  begin
    IntelBytes := S = 'II';
    P := 3;
    FValidTIFF := PopWord = 42;
  end;

  if FValidTIFF then
  begin
    FFirstIFDPosition := P - 1;
    SetLength(FIFDPointers, Length(FIFDPointers) + 1);
    FIFDPointers[Length(FIFDPointers) - 1] := QPLCopy(Source, P, 4);
    IFDOffset := PopCardinal;
    Temp := IFDOffset;
    FPageCount := 0;
    Inc(ReqPageNo);

    repeat
      Inc(FPageCount);
      if (FPageCount = ReqPageNo) then
      begin
        IFDOffset := Temp;
      end else
      begin
        P := Temp + 1;
        DECount := PopWord;
        Inc(P, 12 * DECount);
        Temp := PopCardinal;
      end;
    until (Temp = 0) or (FPageCount = ReqPageNo);

    if (ReqPageNo > 0) then
    begin
      FPageCount := 1;
    end;

    SetLength(FPages, FPageCount);
    Page := 0;

    repeat
      Inc(Page);

      JpegModifier := '';
      XResDouble := 0;
      YResDouble := 0;

      ResolutionUnits := 2;

      FPages[Page - 1].Width := 0;
      FPages[Page - 1].Height := 0;
      FPages[Page - 1].BitsPerSample := 0;
      FPages[Page - 1].Compression := ttUnknown;
      FPages[Page - 1].SamplesPerPixel := 1;
      FPages[Page - 1].ExtraSamples := 0;
      FPages[Page - 1].Predictor := 1;
      FPages[Page - 1].EncodedByteAlign := False;
      FPages[Page - 1].PlanarConfiguration := pcChunky;
      FPages[Page - 1].StripsAreTiles := False;
      SetLength(StripOffsets, 0);
      SetLength(StripLengths, 0);

      P := IFDOffset + 1;
      DECount := PopWord;
      for X := 1 to DECount do
      begin
        E := PopDE;
        case E.Tag of

          256: FPages[Page - 1].Width := E.IntegerValues[0];

          257: FPages[Page - 1].Height := E.IntegerValues[0];

          258: FPages[Page - 1].BitsPerSample := E.IntegerValues[0];

          259:
          begin
            case (E.IntegerValues[0]) of
              1: FPages[Page - 1].Compression := ttNone;
              3: FPages[Page - 1].Compression := ttCCITT31d;
              4: FPages[Page - 1].Compression := ttCCITT4;
              5: FPages[Page - 1].Compression := ttComp;
              6: FPages[Page - 1].Compression := ttJPEG;
              7: FPages[Page - 1].Compression := ttJPEG;
              8: FPages[Page - 1].Compression := ttDeflate;
              32773: FPages[Page - 1].Compression := ttPackbits;
              32946: FPages[Page - 1].Compression := ttDeflate;
            end;
          end;

          262:
          begin
            if (E.IntegerValues[0] >= 0) and (E.IntegerValues[0] <= 7) then
            begin
              FPages[Page - 1].Reversed := (E.IntegerValues[0] = 1);
              FPages[Page - 1].PhotometricInterpretation :=
                TTIFFPhotometricInterpretation(E.IntegerValues[0]);
            end;
          end;

          266: FPages[Page - 1].FillOrder := E.IntegerValues[0];

          273:
          if (FPages[Page - 1].StripsAreTiles) then
          begin
            FValidTIFF := False;
          end else
          begin
            SetLength(StripOffsets, E.Length);
            Move(E.IntegerValues[0], StripOffsets[0], E.Length * 4);
          end;

          277: FPages[Page - 1].SamplesPerPixel := E.IntegerValues[0];

          278:
          if (FPages[Page - 1].StripsAreTiles) then
          begin
            FValidTIFF := False;
          end else
          begin
            FPages[Page - 1].RowsPerStrip := E.IntegerValues[0];
            if ((Length(StripOffsets) = 1) and (FPages[Page - 1].RowsPerStrip <= 1)) then
            begin
              FPages[Page - 1].RowsPerStrip := FPages[Page - 1].Height;
            end;
          end;

          279:
          if (FPages[Page - 1].StripsAreTiles) then
          begin
            FValidTIFF := False;
          end else
          begin
            SetLength(StripLengths, E.Length);
            Move(E.IntegerValues[0], StripLengths[0], E.Length * 4);
          end;

          282: XResDouble := E.DoubleValues[0];

          283: YResDouble := E.DoubleValues[0];

          284:
          begin
            if (E.IntegerValues[0] = 2) then
            begin
              FPages[Page - 1].PlanarConfiguration := pcPlanar;
            end;
          end;

          292:
          begin
            if (FPages[Page - 1].Compression = ttCCITT31d) then
            begin
              if (E.IntegerValues[0] and 1 = 1) then
              begin
                FPages[Page - 1].Compression := ttCCITT32d;
              end;
              FPages[Page - 1].EncodedByteAlign := (E.IntegerValues[0] and 4 = 4);
            end;
          end;

          296: ResolutionUnits := E.IntegerValues[0];

          317: FPages[Page - 1].Predictor := E.IntegerValues[0];

          320:
          begin
            SetLength(FPages[Page - 1].PaletteValues, E.Length);
            Move(E.IntegerValues[0], FPages[Page - 1].PaletteValues[0],
              E.Length * 4);
          end;

          322: FPages[Page - 1].ColumnsPerTile := E.IntegerValues[0];

          323: FPages[Page - 1].RowsPerTile := E.IntegerValues[0];

          324:
          if (Length(StripOffsets) > 0) then
          begin
            FValidTIFF := False;
          end else
          begin
            FPages[Page - 1].StripsAreTiles := True;
            SetLength(StripOffsets, E.Length);
            Move(E.IntegerValues[0], StripOffsets[0], E.Length * 4);
          end;

          325:
          if (Length(StripLengths) > 0) then
          begin
            FValidTIFF := False;
          end else
          begin
            FPages[Page - 1].StripsAreTiles := True;
            SetLength(StripLengths, E.Length);
            Move(E.IntegerValues[0], StripLengths[0], E.Length * 4);
          end;

          338: FPages[Page - 1].ExtraSamples := E.IntegerValues[0];

          347:
          if (E.Length > 2) then
          begin
            // Merge the tables
            CS := 1;
            CE := Length(E.StringValue);
            if (E.StringValue[1] = #$FF) and (E.StringValue[2] = #$D8) then
            begin
              // Skip SOI
              CS := 3;
            end;

            if (E.StringValue[CE-1] = #$FF) and (E.StringValue[CE] = #$D9) then
            begin
              // Skip EOI
              CE := CE - 2;
            end;

            JpegModifier := JpegModifier + QPLCopy(E.StringValue, CS, CE - CS + 1);
          end else
            FHasJPEGTags := True;

          519: FHasJPEGTags := True;
          520: FHasJPEGTags := True;
          521: FHasJPEGTags := True;

          529:
          begin
            FHasJPEGTags := not ((E.Length=3)
                 and QPLSameValue(E.DoubleValues[0], 0.2989)
                 and QPLSameValue(E.DoubleValues[1], 0.5867)
                 and QPLSameValue(E.DoubleValues[2], 0.1144));
          end;

          530:
          begin
            if (E.Length = 2) and (E.IntegerValues[0] in [1, 2]) and (E.IntegerValues[1] in [1, 2]) then
            begin
              //[2,1]    YCbCr4:2:2
              //[2,2]    YCbCr4:2:0
            end else
              FHasJPEGTags := True;
          end;
        end;
      end;

      if (FPages[Page - 1].Compression = ttJPEG) and (FPages[Page - 1].PhotometricInterpretation = piRGB) then
      begin
        // APP14, RGB space transform
        JpegModifier := JpegModifier +
          #$FF#$EE#$00#$0E#$41#$64#$6F#$62#$65#$00#$64#$80#$00#$00#$00#$00;
      end;

      if DECount > 0 then
      begin
        SetLength(FIFDPointers, Length(FIFDPointers) + 1);
        FIFDPointers[Length(FIFDPointers) - 1] := QPLCopy(Source, P, 4);
        IFDOffset := PopCardinal;

        if (Length(StripLengths) < Length(StripOffsets)) then
        begin
          SetLength(StripLengths, Length(StripOffsets));
          for Y := 0 to Length(StripLengths) - 1 do
          begin
            StripLengths[Y] := 0;
          end;
        end;

        SetLength(FPages[Page - 1].Strips, Length(StripOffsets));
        for Y := 0 to Length(StripOffsets) - 1 do
        begin
          P := StripOffsets[Y] + 1;
          if (Length(JpegModifier) > 0) and (FPages[Page - 1].Compression = ttJPEG) then
          begin
            if (Source[P] = #$FF) and (Source[P + 1] = #$D8) then
            begin
              SetLength(FPages[Page - 1].Strips[Y], StripLengths[Y] + Cardinal(Length(JpegModifier)));
              FPages[Page - 1].Strips[Y] := #$FF#$D8 + JpegModifier + QPLCopy(Source, P + 2, StripLengths[Y] - 2);
            end else
            begin
              SetLength(FPages[Page - 1].Strips[Y], StripLengths[Y] + Cardinal(Length(JpegModifier)) + 2);
              FPages[Page - 1].Strips[Y] := #$FF#$D8 + JpegModifier + QPLCopy(Source, P, StripLengths[Y]);
            end;
          end else
          begin
            SetLength(FPages[Page - 1].Strips[Y], StripLengths[Y]);
            FPages[Page - 1].Strips[Y] := QPLCopy(Source, P, StripLengths[Y]);
          end;
        end;

        if ResolutionUnits = 3 then
        begin
          FPages[Page - 1].XRes := Round(XResDouble * 2.54);
          FPages[Page - 1].YRes := Round(YResDouble * 2.54);
        end else
        begin
          FPages[Page - 1].XRes := Round(XResDouble);
          FPages[Page - 1].YRes := Round(YResDouble);
        end;

        // Check for missing 258 tag (BitsPerSample)
        if (FPages[Page - 1].BitsPerSample = 0) then
        begin
          if ((FPages[Page - 1].Compression = ttCCITT31d) or (FPages[Page - 1].Compression = ttCCITT4)) then
          begin
            FPages[Page - 1].BitsPerSample := 1;
          end else
          begin
            FPages[Page - 1].BitsPerSample := 8;
          end;
        end;

        if (Length(StripOffsets) = 1) then
        begin
          if (FPages[Page - 1].StripsAreTiles) then
          begin
            if (FPages[Page - 1].RowsPerTile <= 1) then
            begin
              FPages[Page - 1].RowsPerTile := FPages[Page - 1].Height;
            end;
            if (FPages[Page - 1].ColumnsPerTile <= 1) then
            begin
              FPages[Page - 1].ColumnsPerTile := FPages[Page - 1].Width;
            end;
          end else
          begin
            if (FPages[Page - 1].RowsPerStrip <= 1) then
            begin
              FPages[Page - 1].RowsPerStrip := FPages[Page - 1].Height;
            end;
          end;
        end;

        if (FPages[Page - 1].BitsPerSample > 32) then
        begin
          FPages[Page - 1].BitsPerSample := 0;
        end;
        if ((FPages[Page - 1].BitsPerSample = 0) and
          (FPages[Page - 1].Compression = ttPackbits)) then
        begin
          FPages[Page - 1].BitsPerSample := 1;
        end;
      end else
      begin
        IFDOffset := 0;
      end;
    until (IFDOffset = 0) or (not FValidTIFF) or (Page = FPageCount);
  end;
end;

procedure TPDFTIFF.SimpleExtract(Page: Integer);
var
  S: AnsiString;
  Y: Integer;
  X: Integer;
  Strip: Integer;
  ScanLine: PByteArray;
  RPS: Integer;
  W: Integer;
  PadBytes: AnsiString;
  Offset, SOffset: Integer;
begin
  W := 0;
  FBitmap.Width := PageInfo[Page].Width;
  FBitmap.Height := PageInfo[Page].Height;
  if (PageInfo[Page].BitsPerSample = 1) and (PageInfo[Page].SamplesPerPixel = 1) then
  begin
    FBitmap.PixelFormat := pf1bit;
    W := FBitmap.Width div 8;
    if FBitmap.Width - (W * 8) > 0 then Inc(W);
  end;
  if (PageInfo[Page].BitsPerSample = 8) and (PageInfo[Page].SamplesPerPixel = 3) then
  begin
    FBitmap.PixelFormat := pf24bit;
    W := FBitmap.Width * 3;
  end;
  if (PageInfo[Page].BitsPerSample = 8) and (PageInfo[Page].SamplesPerPixel >= 4) then
  begin
    FBitmap.PixelFormat := pf32bit;
    W := FBitmap.Width * PageInfo[Page].SamplesPerPixel;
  end;
  if (PageInfo[Page].BitsPerSample = 8) and (PageInfo[Page].SamplesPerPixel = 1) then
  begin
    FBitmap.PixelFormat := pf8bit;
    W := FBitmap.Width;
  end;

  RPS := PageInfo[Page].RowsPerStrip;
  if RPS = 0 then RPS := FBitmap.Height;

  if W > 0 then
  for Strip := 0 to Length(PageInfo[Page].Strips) - 1 do
  begin
    S := PageInfo[Page].Strips[Strip];
    if Length(S) < (RPS * W) then
    begin
      SetLength(PadBytes, RPS * W);
      if Length(PadBytes) > 0 then
        FillChar(PadBytes[1], Length(PadBytes), #255);
      S := S + PadBytes;
    end;
    for Y := RPS * Strip to RPS * (Strip + 1) - 1 do
    begin
      if Y < FBitmap.Height then
      begin
        ScanLine := FBitmap.ScanLine[Y];

        if FBitmap.PixelFormat = pf24bit then
        begin
          Offset := 0;
          for X := 0 to FBitmap.Width - 1 do
          begin
            ScanLine[Offset] := Ord(S[Offset + 3]);
            ScanLine[Offset + 1] := Ord(S[Offset + 2]);
            ScanLine[Offset + 2] := Ord(S[Offset + 1]);

            Inc(Offset, 3);
          end;
        end;

        if (FBitmap.PixelFormat = pf32bit) then
        begin
          Offset := 0;
          SOffset := 0;
          for X := 0 to FBitmap.Width - 1 do
          begin
            ScanLine[Offset] := Ord(S[SOffset + 4]);
            ScanLine[Offset + 1] := Ord(S[SOffset + 3]);
            ScanLine[Offset + 2] := Ord(S[SOffset + 2]);
            ScanLine[Offset + 3] := Ord(S[SOffset + 1]);

            Inc(SOffset, PageInfo[Page].SamplesPerPixel);
            Inc(Offset, 4);
          end;
        end;

        if (FBitmap.PixelFormat = pf1bit) or (FBitmap.PixelFormat = pf8bit) then
          Move(S[1], ScanLine[0], W);

        Delete(S, 1, W);
      end;
    end;
  end;
end;

procedure TPDFTIFF.CompDecode(Page: Integer);
var
  S: AnsiString;
  Y: Integer;
  X: Integer;
  Strip: Integer;
  ScanLine: PByteArray;
  RPS: Integer;
  Predictor: Integer;
  Grey8: Boolean;
  Binary: Boolean;
  LZWDecompressor: TPDFLZWDecompressor;
  PadBytes: AnsiString;
  ByteWid: Integer;
  SPP, Src, Dst: Integer;
begin
  FBitmap.Width := PageInfo[Page].Width;
  FBitmap.Height := PageInfo[Page].Height;

  SPP := PageInfo[Page].SamplesPerPixel;

  if (PageInfo[Page].PhotometricInterpretation = piRGB)  or (PageInfo[Page].PhotometricInterpretation = piRGBPalette) then
    FBitmap.PixelFormat := pf24bit;
  if PageInfo[Page].PhotometricInterpretation = piCMYK then
    FBitmap.PixelFormat := pf32bit;
  {
  if PageInfo[Page].SamplesPerPixel = 3 then
    FBitmap.PixelFormat := pf24bit;
  if PageInfo[Page].SamplesPerPixel = 4 then
    FBitmap.PixelFormat := pf32bit;
  }


  Grey8 := False;
  if (PageInfo[Page].SamplesPerPixel = 1) and (PageInfo[Page].BitsPerSample = 8) then
  begin
    FBitmap.PixelFormat := pf8bit;
    Grey8 := True;
  end;

  Binary := False;
  ByteWid := (FBitmap.Width + 7) div 8;
  if (PageInfo[Page].SamplesPerPixel = 1) and (PageInfo[Page].BitsPerSample = 1) then
  begin
    FBitmap.PixelFormat := pf1bit;
    Binary := True;
  end;

  RPS := PageInfo[Page].RowsPerStrip;
  Predictor := PageInfo[Page].Predictor;

  LZWDecompressor := TPDFLZWDecompressor.Create;
  try
    LZWDecompressor.FillOrder := foTop;
    LZWDecompressor.EarlyChange := True;
    LZWDecompressor.InitialCodeSize := 9;
    for Strip := 0 to Length(PageInfo[Page].Strips) - 1 do
    begin
      S := LZWDecompressor.Decompress(PageInfo[Page].Strips[Strip]);
      if Binary then
      begin
        if Length(S) < (RPS * ByteWid) then
        begin
          SetLength(PadBytes, RPS * ByteWid);
          if Length(PadBytes) > 0 then
          begin
            FillChar(PadBytes[1], Length(PadBytes), #255);
          end;
          S := S + PadBytes;
        end;
        S := S + #0;
      end else
      if Grey8 then
      begin
        if Length(S) < (RPS * FBitmap.Width) then
        begin
          SetLength(PadBytes, RPS * FBitmap.Width);
          if Length(PadBytes) > 0 then
            FillChar(PadBytes[1], Length(PadBytes), #255);
          S := S + PadBytes;
        end;
        S := S + #0;
      end else
      begin
//        if PageInfo[Page].SamplesPerPixel = 3 then
		if FBitmap.PixelFormat = pf24bit then
        begin
          if Length(S) < (3 * RPS * FBitmap.Width) then
          begin
            SetLength(PadBytes, 3 * RPS * FBitmap.Width);
            if Length(PadBytes) > 0 then
              FillChar(PadBytes[1], Length(PadBytes), #255);
            S := S + PadBytes;
          end;
          S := S + #0#0#0;
        end else
        begin
          if Length(S) < (4 * RPS * FBitmap.Width) then
          begin
            SetLength(PadBytes, 4 * RPS * FBitmap.Width);
            if Length(PadBytes) > 0 then
              FillChar(PadBytes[1], Length(PadBytes), #255);
            S := S + PadBytes;
          end;
          S := S + #0#0#0#0;
        end;
      end;
      for Y := RPS * Strip to RPS * (Strip + 1) - 1 do
      begin
        if Y < FBitmap.Height then
        begin
          ScanLine := FBitmap.ScanLine[Y];
          if Binary then
          begin
            if Predictor = 1 then
            begin
              for X := 0 to ByteWid - 1 do
                ScanLine[X] := Ord(S[X + 1]);
            end;
            if Predictor = 2 then
            begin
              ScanLine[0] := Ord(S[1]);
              for X := 1 to ByteWid - 1 do
                ScanLine[X] := (ShortInt(Ord(S[X + 1])) + ScanLine[X - 1]) and $FF;
            end;
          end else
          if Grey8 then
          begin
            if Predictor = 1 then
            begin
              for X := 0 to FBitmap.Width - 1 do
                ScanLine[X] := Ord(S[X + 1]);
            end;
            if Predictor = 2 then
            begin
              ScanLine[0] := Ord(S[1]);
              for X := 1 to FBitmap.Width - 1 do
                ScanLine[X] := (ShortInt(Ord(S[X + 1])) + ScanLine[X - 1]) and $FF;
            end;
          end else
          begin
            //if PageInfo[Page].SamplesPerPixel = 3 then
			if FBitmap.PixelFormat = pf24bit then
            begin
              if Predictor = 1 then
              begin
                Src := 0;
                Dst := 0;
                for X := 0 to FBitmap.Width - 1 do
                begin
//                  ScanLine[X * 3 + 0] := Ord(S[X * 3 + 3]);
//                  ScanLine[X * 3 + 1] := Ord(S[X * 3 + 2]);
//                  ScanLine[X * 3 + 2] := Ord(S[X * 3 + 1]);
                  ScanLine[Dst + 0] := Ord(S[Src + 3]);
                  ScanLine[Dst + 1] := Ord(S[Src + 2]);
                  ScanLine[Dst + 2] := Ord(S[Src + 1]);
                  Inc(Src, SPP);
                  Inc(Dst, 3);
                end;
              end;
              if Predictor = 2 then
              begin
                ScanLine[0] := Ord(S[3]);
                ScanLine[1] := Ord(S[2]);
                ScanLine[2] := Ord(S[1]);
                Src := SPP;
                Dst := 3;
                for X := 1 to FBitmap.Width - 1 do
                begin
//                  ScanLine[X * 3 + 0] := (ShortInt(Ord(S[X * 3 + 3])) + ScanLine[X * 3 - 3]) and $FF;
//                  ScanLine[X * 3 + 1] := (ShortInt(Ord(S[X * 3 + 2])) + ScanLine[X * 3 - 2]) and $FF;
//                  ScanLine[X * 3 + 2] := (ShortInt(Ord(S[X * 3 + 1])) + ScanLine[X * 3 - 1]) and $FF;
                  ScanLine[Dst + 0] := (ShortInt(Ord(S[Src + 3])) + ScanLine[Dst - 3]) and $FF;
                  ScanLine[Dst + 1] := (ShortInt(Ord(S[Src + 2])) + ScanLine[Dst - 2]) and $FF;
                  ScanLine[Dst + 2] := (ShortInt(Ord(S[Src + 1])) + ScanLine[Dst - 1]) and $FF;
                  Inc(Src, SPP);
                  Inc(Dst, 3);
                end;
              end;
            end else
            begin
              if Predictor = 1 then
              begin
                if PageInfo[Page].PhotometricInterpretation = piCMYK then
                begin
                  Src := 0;
                  Dst := 0;
                  for X := 0 to FBitmap.Width - 1 do
                  begin
//                    ScanLine[X * 4 + 0] := Ord(S[X * 4 + 4]);
//                    ScanLine[X * 4 + 1] := Ord(S[X * 4 + 3]);
//                    ScanLine[X * 4 + 2] := Ord(S[X * 4 + 2]);
//                    ScanLine[X * 4 + 3] := Ord(S[X * 4 + 1]);
                    ScanLine[Dst + 0] := Ord(S[Src + 4]);
                    ScanLine[Dst + 1] := Ord(S[Src + 3]);
                    ScanLine[Dst + 2] := Ord(S[Src + 2]);
                    ScanLine[Dst + 3] := Ord(S[Src + 1]);
                    Inc(Src, SPP);
                    Inc(Dst, 4);
                  end;
                end else
                begin
                  Src := 0;
                  Dst := 0;
                  for X := 0 to FBitmap.Width - 1 do
                  begin
//                    ScanLine[X * 4 + 0] := Ord(S[X * 4 + 3]);
//                    ScanLine[X * 4 + 1] := Ord(S[X * 4 + 2]);
//                    ScanLine[X * 4 + 2] := Ord(S[X * 4 + 1]);
//                    ScanLine[X * 4 + 3] := Ord(S[X * 4 + 4]);
                    ScanLine[Dst + 0] := Ord(S[Src + 3]);
                    ScanLine[Dst + 1] := Ord(S[Src + 2]);
                    ScanLine[Dst + 2] := Ord(S[Src + 1]);
                    ScanLine[Dst + 3] := Ord(S[Src + 4]);
                    Inc(Src, SPP);
                    Inc(Dst, 4);
                  end;
                end;
              end;
              if Predictor = 2 then
              begin
                ScanLine[0] := Ord(S[4]);
                ScanLine[1] := Ord(S[3]);
                ScanLine[2] := Ord(S[2]);
                ScanLine[3] := Ord(S[1]);

                Src := SPP;
                Dst := 4;
                for X := 1 to FBitmap.Width - 1 do
                begin
//                  ScanLine[X * 4 + 0] := (ShortInt(Ord(S[X * 4 + 4])) + ScanLine[X * 4 - 4]) and $FF;
//                  ScanLine[X * 4 + 1] := (ShortInt(Ord(S[X * 4 + 3])) + ScanLine[X * 4 - 3]) and $FF;
//                  ScanLine[X * 4 + 2] := (ShortInt(Ord(S[X * 4 + 2])) + ScanLine[X * 4 - 2]) and $FF;
//                  ScanLine[X * 4 + 3] := (ShortInt(Ord(S[X * 4 + 1])) + ScanLine[X * 4 - 1]) and $FF;
                  ScanLine[Dst + 0] := (ShortInt(Ord(S[Src + 4])) + ScanLine[Dst - 4]) and $FF;
                  ScanLine[Dst + 1] := (ShortInt(Ord(S[Src + 3])) + ScanLine[Dst - 3]) and $FF;
                  ScanLine[Dst + 2] := (ShortInt(Ord(S[Src + 2])) + ScanLine[Dst - 2]) and $FF;
                  ScanLine[Dst + 3] := (ShortInt(Ord(S[Src + 1])) + ScanLine[Dst - 1]) and $FF;
                  Inc(Src, SPP);
                  Inc(Dst, 4);
                end;
              end;
            end;
          end;
          if Binary then
          begin
            Delete(S, 1, ByteWid);
          end else
          if Grey8 then
          begin
            Delete(S, 1, FBitmap.Width)
          end else
          begin
            Delete(S, 1, FBitmap.Width * PageInfo[Page].SamplesPerPixel);
          end;
        end;
      end;
    end;
  finally
    LZWDecompressor.Free;
  end;
end;

procedure TPDFTIFF.LoadFromStream(InStream: TStream; ReqPageNo: Integer = -1);
var
  Source: AnsiString;
begin
  InStream.Seek(0, soFromBeginning);
  SetLength(Source, InStream.Size);
  InStream.Read(Source[1], InStream.Size);
  LoadFromString(Source, ReqPageNo);
end;

constructor TPDFTIFF.Create(Page: TTIFFPage);
begin
  FHasJPEGTags := False;
  FValidTIFF := True;
  FPageCount := 1;
  SetLength(FPages, 1);
  FPages[0] := Page;
end;

function TPDFTIFF.SaveToString: AnsiString;
var
  S: AnsiString;
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    SaveToStream(MS);
    MS.Seek(0, soFromBeginning);
    SetLength(S, MS.Size);
    MS.Read(S[1], Length(S));
    Result := S;
  finally
    MS.Free;
  end;
end;

type
  TQuadInt = array[0..3] of AnsiChar;

procedure TPDFTIFF.SaveToStream(OutStream: TStream);
var
  S: AnsiString;
  W: Word;
  L: Integer;
  IFD: array of TTIFFEntry;
  DEX: Integer;
  Data: TQuickPDFStringList;
  DataOffset: Integer;

  procedure AddDirectoryEntry(Tag, TagType: Word; Len, Offset: Cardinal);
  var
    X: Integer;
    P: Integer;
  begin
    SetLength(IFD, Length(IFD) + 1);
    IFD[Length(IFD) - 1].Tag := Tag;
    if Length(IFD) = 1 then
    begin
      IFD[0].Tag := Tag;
      IFD[0].TagType := TagType;
      IFD[0].Length := Len;
      IFD[0].Offset := Offset;
    end else
    begin
      P := 0;
      while (P < Length(IFD)) and (IFD[P].Tag < Tag) do
        Inc(P);
      for X := (Length(IFD) - 1) downto (P + 1) do
        IFD[X] := IFD[X - 1];
      IFD[P].Tag := Tag;
      IFD[P].TagType := TagType;
      IFD[P].Length := Len;
      IFD[P].Offset := Offset;
    end;
  end;

  function AddData(const NewData: AnsiString): Integer;
  var
    X: Integer;
  begin
    Result := DataOffset;
    for X := 0 to Data.Count - 1 do
    begin
      Result := Result + Length(Data[X]);
      while (Result mod 4) > 0 do
        Inc(Result);
    end;
    Data.AddObject(NewData, TObject(Result));
  end;

  function AddRational(Numerator, Denominator: Integer): Cardinal;
  var
    S: AnsiString;
    Q: TQuadInt;
  begin
    SetLength(S, 8);
    Q := TQuadInt(Numerator);
    S[1] := Q[0];
    S[2] := Q[1];
    S[3] := Q[2];
    S[4] := Q[3];
    Q := TQuadInt(Denominator);
    S[5] := Q[0];
    S[6] := Q[1];
    S[7] := Q[2];
    S[8] := Q[3];
    Result := AddData(S);
  end;

begin
  Data := TQuickPDFStringList.Create;
  try
    S := 'II';
    OutStream.Write(S[1], 2);
    W := 42;
    OutStream.Write(W, 2);
    L := OutStream.Position + 4;
    repeat
      Inc(L);
    until (L mod 4) = 0;
    OutStream.Write(L, 4);

    // Only works for CCITT Group 4 images
    DataOffset := 14 * 12 + L + 8;
    AddDirectoryEntry(256, 4, 1, FPages[0].Width);
    AddDirectoryEntry(257, 4, 1, FPages[0].Height);
    AddDirectoryEntry(279, 4, 1, Length(FPages[0].Strips[0]));
    AddDirectoryEntry(273, 4, 1, AddData(FPages[0].Strips[0]));
    AddDirectoryEntry(259, 3, 1, 4);
    AddDirectoryEntry(258, 3, 1, FPages[0].BitsPerSample);
    AddDirectoryEntry(277, 3, 1, FPages[0].SamplesPerPixel);
    S := 'Debenu Quick PDF Library www.debenu.com';
    AddDirectoryEntry(305, 2, Length(S), AddData(S + #0));
    AddDirectoryEntry(278, 4, 1, FPages[0].RowsPerStrip);
    AddDirectoryEntry(279, 4, 1, FPages[0].Width * FPages[0].Height div 8);
    AddDirectoryEntry(296, 3, 1, 2);
    AddDirectoryEntry(282, 5, 1, AddRational(96, 1));
    AddDirectoryEntry(283, 5, 1, AddRational(96, 1));
    AddDirectoryEntry(262, 3, 1, 0);    

    OutStream.Seek(L, soFromBeginning);
    W := Length(IFD);
    OutStream.Write(W, 2);
    for DEX := 0 to Length(IFD) - 1 do
    begin
      OutStream.Write(IFD[DEX].Tag, 2);
      OutStream.Write(IFD[DEX].TagType, 2);
      OutStream.Write(IFD[DEX].Length, 4);
      OutStream.Write(IFD[DEX].Offset, 4);
    end;
    L := 0;
    OutStream.Write(L, 4);

    for DEX := 0 to Data.Count - 1 do
    begin
      L := Integer(Data.Objects[DEX]);
      OutStream.Seek(L, soFromBeginning);
      OutStream.Write(Data[DEX][1], Length(Data[DEX]));
    end;
  finally
    Data.Free;
  end;
end;

function TPDFTIFF.GetIFDPointer(Page: Integer): AnsiString;
begin
  if (Page >= 1) and (Page <= FPageCount) then
    Result := FIFDPointers[Page - 1]
  else
    Result := #0#0#0#0;
end;

{ TPDFTIFFMaker }

constructor TPDFTIFFMaker.Create;
begin
  FHorizontalDPI := 96;
  FVerticalDPI := 96;
  FEncodedByteAlign := False;
end;

procedure TPDFTIFFMaker.WriteTIFFToStream(FStream: TStream);
var
  W: Word;
  X: Integer;
  IFDPos: Cardinal;
  NextOffset: Cardinal;
  SourcePos: Cardinal;
  Flags: Cardinal;
  Padding: array of Byte;

  procedure AddTag(ATag, ATagType: Word; ALength, AOffset: Cardinal);
  begin
    SetLength(FTags, Length(FTags) + 1);
    FTags[Length(FTags) - 1].Tag := ATag;
    FTags[Length(FTags) - 1].TagType := ATagType;
    FTags[Length(FTags) - 1].Length := ALength;
    FTags[Length(FTags) - 1].Offset := AOffset;
  end;

  procedure AddLongTag(ATag: Word; Value: Cardinal);
  begin
    AddTag(ATag, 4, 1, Value);
  end;

  procedure AddByteTag(ATag: Word; Value: Byte);
  begin
    AddTag(ATag, 1, 1, Value);
  end;

  procedure AddShortTag(ATag: Word; Value: Word);
  begin
    AddTag(ATag, 3, 1, Value);
  end;

  procedure AddRationalTag(ATag: Word; Numerator, Denominator: Cardinal);
  begin
    FStream.Seek(NextOffset, soBeginning);
    FStream.Write(Numerator, 4);
    FStream.Write(Denominator, 4);
    AddTag(ATag, 5, 1, NextOffset);
    Inc(NextOffset, 8);
  end;

begin
  NextOffset := 128;
  SetLength(FTags, 0);
  AddLongTag(256, FWidth);   // ImageWidth
  AddLongTag(257, FHeight);    // ImageLength
  AddShortTag(258, 1);        // BitsPerSample

  case FCompression of
    ttCCITT4: AddShortTag(259, 4);
    ttCCITT31d: AddShortTag(259, 3);
    ttCCITT32d: AddShortTag(259, 3);
    ttComp: AddShortTag(259, 5);
  end;

  if FReversed then
    AddShortTag(262, 1)
  else
    AddShortTag(262, 0);       // PhotometricInterpretation

  AddShortTag(266, 1);         // FillOrder
  SourcePos := NextOffset;

  // Pad with 0x00 bytes
  SetLength(Padding, NextOffset);
  FillChar(Padding[0], Length(Padding), 0);
  FStream.Seek(0, soFromBeginning);
  FStream.Write(Padding[0], Length(Padding));

  FStream.Seek(NextOffset, soBeginning);
  FStream.Write(FSource[1], Length(FSource));
  Inc(NextOffset, Length(FSource));
  while NextOffset mod 32 <> 0 do Inc(NextOffset);
  AddLongTag(273, SourcePos);        // StripOffsets
  AddShortTag(277, 1);               // SamplesPerPixel
  AddLongTag(278, FHeight);          // RowsPerStrip
  AddLongTag(279, Length(FSource));  // StripByteCounts

  if ((FHorizontalDPI > 0) and (FVerticalDPI > 0)) then
  begin
    AddRationalTag(282, FHorizontalDPI, 1);        // XRes
    AddRationalTag(283, FVerticalDPI, 1);          // YRes
  end;

  if (FCompression = ttCCITT31d) or (FCompression = ttCCITT32d) then
  begin
    Flags := 0;
    if FCompression = ttCCITT32d then Flags := Flags + 1;
    if FEncodedByteAlign then Flags := Flags + 4;
    AddLongTag(292, Flags);             // T4 Options
  end;

  if (FCompression = ttCCITT4) then
  begin
    Flags := 0;
    AddLongTag(293, Flags);             // T6 Options
  end;

  if ((FHorizontalDPI > 0) and (FVerticalDPI > 0)) then
  begin
    AddShortTag(296, 2);              // Resolution unit
  end;

  IFDPos := NextOffset + 32;
  while IFDPos mod 32 <> 0 do Inc(IFDPos);

  // Pad with 0x00 bytes
  SetLength(Padding, Integer(IFDPos) - FStream.Position);
  if (Length(Padding) > 0) then
  begin
    FillChar(Padding[0], Length(Padding), 0);
    FStream.Write(Padding[0], Length(Padding));
  end;

  FStream.Seek(0, soBeginning);
  W := $4949;
  FStream.Write(W, 2);
  W := 42;
  FStream.Write(W, 2);
  FStream.Write(IFDPos, 4);

  FStream.Seek(IFDPos, soBeginning);
  W := Length(FTags);
  FStream.Write(W, 2);
  for X := 0 to Length(FTags) - 1 do
  begin
    FStream.Write(FTags[X].Tag, 2);
    FStream.Write(FTags[X].TagType, 2);
    FStream.Write(FTags[X].Length, 4);
    FStream.Write(FTags[X].Offset, 4);
  end;
  W := 0;
  FStream.Write(W, 2);
  FStream.Write(W, 2);
end;

function FixG4EOL(const Source: AnsiString; Rows, Columns: Integer): AnsiString;
begin
  SetLength(Result, Rows div 8 + 1);
  FillChar(Result[1], Length(Result), 255);
end;

procedure ConvertBitmapToTIFF(BM: TBitmap; OutStream: TStream; Settings: TGDIPlusSettings; DPI: Double);
var
  MS: TMemoryStream;
  Picasso: TPDFPicasso;
  TE: TGUID;
  PPM: Integer;
begin
  MS := TMemoryStream.Create;
  try
    BM.Canvas.Lock;
    try
      BM.SaveToStream(MS);

      if (DPI > 0) then
      begin
        MS.Seek($26, soFromBeginning);
        PPM := Trunc((DPI * 1000) / 25.4);
        MS.Write(PPM, 4);
        MS.Write(PPM, 4);
      end;

      MS.Seek(0, soFromBeginning);
      Picasso := TPDFPicasso.Create;
      try
        Picasso.UseGDIPlusModel(BM.Canvas, Settings);
        if Picasso.GDIPlus.GetEncoderClsid('image/tiff', TE) then
          Picasso.ConvertStream(MS, OutStream, TE);
      finally
        Picasso.Free;
      end;
    finally
      BM.Canvas.Unlock;
    end;
  finally
    MS.Free;
  end;
end;

procedure ConvertBitmapToG4TIFF(BM: TBitmap; OutStream: TStream; Settings: TGDIPlusSettings; DPI: Double);
var
  MS: TMemoryStream;
  Picasso: TPDFPicasso;
  PPM: Integer;
  X, Y: Integer;
  ScanLine: PByteArray;
  Offset: Integer;
begin
  if (Settings.MonoThreshold > 0) then
  begin
    for Y := 0 to BM.Height - 1 do
    begin
      ScanLine := BM.ScanLine[Y];

      if (BM.PixelFormat = pf24bit) then
      begin
        Offset := 0;
        for X := 0 to BM.Width - 1 do
        begin
          if ((ScanLine[Offset] + ScanLine[Offset + 1] + ScanLine[Offset + 2]) < (Settings.MonoThreshold * 3)) then
          begin
            ScanLine[Offset] := 0;
            ScanLine[Offset + 1] := 0;
            ScanLine[Offset + 2] := 0;
          end;
          Inc(Offset, 3);
        end;
      end;
    end;
  end;

  MS := TMemoryStream.Create;
  try
    BM.Canvas.Lock;
    try
      BM.SaveToStream(MS);

      if (DPI > 0) then
      begin
        MS.Seek($26, soFromBeginning);
        PPM := Trunc((DPI * 1000) / 25.4);
        MS.Write(PPM, 4);
        MS.Write(PPM, 4);
      end;

      MS.Seek(0, soFromBeginning);
      Picasso := TPDFPicasso.Create;
      try
        Picasso.UseGDIPlusModel(BM.Canvas, Settings);
        Picasso.ConvertStreamToG4(MS, OutStream);
      finally
        Picasso.Free;
      end;
    finally
      BM.Canvas.Unlock;
    end;
  finally
    MS.Free;
  end;
end;

procedure ConcatenateTIFFStream(OriginalStream, NewStream: TStream);
var
  Scissors: TDPLTIFFScissors;
  NextPos: Cardinal;
begin
  Scissors := TDPLTIFFScissors.Create(NewStream);
  try
    Scissors.ShiftOffsets(OriginalStream.Size);
    NextPos := Scissors.FirstIFDPos;
  finally
    Scissors.Free;
  end;
  OriginalStream.Seek(OriginalStream.Size, soBeginning);
  NewStream.Seek(0, soBeginning);
  OriginalStream.CopyFrom(NewStream, NewStream.Size);
  Scissors := TDPLTIFFScissors.Create(OriginalStream);
  try
    Scissors.SetLastIFD(NextPos);
  finally
    Scissors.Free;
  end;
end;

{ TDPLTIFFScissors }

constructor TDPLTIFFScissors.Create(ASource: TStream);
var
  Buffer: AnsiString;
  TagCount: Integer;
begin
  FSource := ASource;

  FSource.Seek(0, soBeginning);
  SetLength(Buffer, 2);
  FSource.Read(Buffer[1], 2);

  if ((Buffer = 'II') or (Buffer = 'MM')) then
  begin
    FIntelBytes := Buffer = 'II';
    FSource.Position := 2;
    FValidTIFF := PopWord = 42;
  end;

  if (FValidTIFF) then
  begin
    SetLength(FIFDList, 16);
    FIFDCount := 0;
    FIFDList[0] := PopCardinal;
    if (FIFDList[0] > 0) then
    begin
      repeat
        Inc(FIFDCount);
        if (FIFDCount >= Length(FIFDList)) then
        begin
          SetLength(FIFDList, Length(FIFDList) * 2);
        end;
        FSource.Seek(FIFDList[FIFDCount - 1], soBeginning);
        TagCount := PopWord;
        FSource.Seek(TagCount * 12, soCurrent);
        FIFDList[FIFDCount] := PopCardinal;
      until FIFDList[FIFDCount] = 0;
    end;
    SetLength(FIFDList, FIFDCount);
  end;
end;

function TDPLTIFFScissors.FirstIFDPos: Cardinal;
begin
  if (Length(FIFDList) > 0) then
  begin
    Result := FIFDList[0];
  end else
  begin
    Result := 0;
  end;
end;

function TDPLTIFFScissors.PopCardinal: Cardinal;
begin
  FSource.Read(Result, 4);
  if (not FIntelBytes) then
  begin
    Result := ((Result and $FF) shl 24) + ((Result and $FF00) shl 8) +
      ((Result and $FF0000) shr 16) + ((Result and $FF000000) shr 24);
  end;
end;

function TDPLTIFFScissors.PopWord: Word;
begin
  FSource.Read(Result, 2);
  if (not FIntelBytes) then
  begin
    Result := ((Result and $FF) shl 8) + ((Result and $FF00) shr 8);
  end;
end;

procedure TDPLTIFFScissors.SetLastIFD(NextPos: Cardinal);
var
  TagCount: Integer;
  TargetPos: Cardinal;
  Temp: Cardinal;
begin
  FSource.Seek(FIFDList[Length(FIFDList) - 1], soBeginning);
  TagCount := PopWord;

  TargetPos := FIFDList[Length(FIFDList) - 1] + Cardinal(TagCount * 12) + 2;
  FSource.Seek(TargetPos, soBeginning);
  FSource.Read(Temp, 4);

  if (Temp <> TargetPos) then
  begin
    FIFDList[0] := FIFDList[0];
  end;

  FSource.Seek(TargetPos, soBeginning);
  if (not FIntelBytes) then
  begin
    NextPos := ((NextPos and $FF) shl 24) + ((NextPos and $FF00) shl 8) +
      ((NextPos and $FF0000) shr 16) + ((NextPos and $FF000000) shr 24);
  end;
  FSource.Write(NextPos, 4);
end;

procedure TDPLTIFFScissors.ShiftOffsets(Offset: Integer);
var
  IFDNumber: Integer;
  TagCount: Integer;
  TagNumber: Integer;
  TagCode: Word;
  DataType: Word;
  DataSize: Integer;
  ValueCount: Cardinal;
  TagData: Cardinal;
  NewTagData: Cardinal;
  NewPos: Cardinal;
  StripPos: array of Cardinal;
  StripX: Integer;
  Temp: Cardinal;
begin
  for IFDNumber := 0 to Length(FIFDList) - 1 do
  begin
    FSource.Seek(FIFDList[IFDNumber], soBeginning);
    TagCount := PopWord;
    for TagNumber := 0 to TagCount - 1 do
    begin
      FSource.Seek(FIFDList[IFDNumber] + Cardinal(TagNumber * 12) + 2, soBeginning);
      TagCode := PopWord;
      DataType := PopWord;
      case DataType of
        1: DataSize := 1; // BYTE
        3: DataSize := 2; // SHORT
        4: DataSize := 4; // LONG
        5: DataSize := 8; // RATIONAL
        6: DataSize := 1; // SBYTE
        8: DataSize := 2; // SSHORT
        9: DataSize := 4; // SLONG
        10: DataSize := 8; // SRATIONAL
        11: DataSize := 4; // FLOAT
        12: DataSize := 8; // DOUBLE
      else
        DataSize := 1;
      end;
      ValueCount := PopCardinal;
      TagData := PopCardinal;
      NewTagData := TagData;
      if (TagCode = 273) then
      begin
        if (DataType = 3) then
        begin
          // To do
        end else
        if (DataType = 4) then
        begin
          if (ValueCount > 1) then
          begin
            SetLength(StripPos, ValueCount);
            FSource.Seek(TagData, soBeginning);
            FSource.Read(StripPos[0], ValueCount * 4);
            for StripX := 0 to Length(StripPos) - 1 do
            begin
              if (not FIntelBytes) then
              begin
                Temp := StripPos[StripX];
                Temp := ((Temp and $FF) shl 24) + ((Temp and $FF00) shl 8) +
                  ((Temp and $FF0000) shr 16) + ((Temp and $FF000000) shr 24);
                StripPos[StripX] := Temp;
              end;

              if (Offset > 0) then
              begin
                StripPos[StripX] := StripPos[StripX] + Cardinal(Offset);
              end else
              begin
                StripPos[StripX] := Cardinal(Int64(StripPos[StripX]) + Offset);
              end;

              if (not FIntelBytes) then
              begin
                Temp := StripPos[StripX];
                Temp := ((Temp and $FF) shl 24) + ((Temp and $FF00) shl 8) +
                  ((Temp and $FF0000) shr 16) + ((Temp and $FF000000) shr 24);
                StripPos[StripX] := Temp;
              end;
            end;
            FSource.Seek(TagData, soBeginning);
            FSource.Write(StripPos[0], ValueCount * 4);
          end else
          begin
            if (Offset > 0) then
            begin
              NewTagData := Cardinal(TagData + Cardinal(Offset));
            end else
            begin
              NewTagData := Cardinal(Int64(TagData) + Offset);
            end;
          end;
        end;
      end;

      if (DataSize * Integer(ValueCount)) > 4 then
      begin
        if (Offset > 0) then
        begin
          NewTagData := Cardinal(TagData + Cardinal(Offset));
        end else
        begin
          NewTagData := Cardinal(Int64(TagData) + Offset);
        end;
      end;

      if (NewTagData <> TagData) then
      begin
        if (not FIntelBytes) then
        begin
          NewTagData := ((NewTagData and $FF) shl 24) + ((NewTagData and $FF00) shl 8) +
            ((NewTagData and $FF0000) shr 16) + ((NewTagData and $FF000000) shr 24);
        end;
        FSource.Seek(FIFDList[IFDNumber] + Cardinal(TagNumber * 12) + 2 + 8, soBeginning);
        FSource.Write(NewTagData, 4);
      end;
    end;
    if (IFDNumber < (Length(FIFDList) - 1)) then
    begin
      FSource.Seek(FIFDList[IFDNumber] + Cardinal(TagCount * 12) + 2, soBeginning);
      if (Offset > 0) then
      begin
        NewPos := Cardinal(FIFDList[IFDNumber + 1] + Cardinal(Offset));
      end else
      begin
        NewPos := Cardinal(Int64(FIFDList[IFDNumber + 1]) + Offset);
      end;
      if (not FIntelBytes) then
      begin
        NewPos := ((NewPos and $FF) shl 24) + ((NewPos and $FF00) shl 8) +
          ((NewPos and $FF0000) shr 16) + ((NewPos and $FF000000) shr 24);
      end;
      FSource.Write(NewPos, 4);
    end;

    if (Offset > 0) then
    begin
      FIFDList[IFDNumber] := Cardinal(FIFDList[IFDNumber] + Cardinal(Offset));
    end else
    begin
      FIFDList[IFDNumber] := Cardinal(Int64(FIFDList[IFDNumber]) + Offset);
    end;
  end;
end;

end.
