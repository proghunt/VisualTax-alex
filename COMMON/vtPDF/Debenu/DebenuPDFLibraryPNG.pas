{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryPNG.pas                                }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryPNG;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  SysUtils,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  Classes;

type
  TPNGReader = class
  private
    FWidth: Cardinal;
    FHeight: Cardinal;
    FSourceBitDepth: Cardinal;
    FImageBitDepth: Cardinal;
    FAlphaBitDepth: Cardinal;
    FColorType: Byte;
    FCompressionMethod: Byte;
    FFilterMethod: Byte;
    FInterlaceMethod: Byte;
    FPaletteSize: Integer;
    FPaletteData: AnsiString;
    FTransparencyData: AnsiString;
    FSourceData: AnsiString;
    FImageData: AnsiString;
    FAlphaData: AnsiString;
    FHorizontalDPI: Cardinal;
    FVerticalDPI: Cardinal;
    FEmbeddedPredictor: Boolean;
    FDownSampleImage: Boolean;
    FDownSampleAlpha: Boolean;
    FSkipImageData: Boolean;
    FPalettePosition: Integer;
    FTransparencyPosition: Integer;
    FFirstDataPosition: Integer;
    FICCData: AnsiString;
    procedure FilterData;
  public
    AlwaysUnfilter: Boolean;
    constructor Create; virtual;
    procedure LoadFromFile(const FileName: WideString);
    procedure LoadFromStream(InStream: TStream);
    function SaveToBitmap: TBitmap;
    function MakePDFPalette: AnsiString;
    property Width: Cardinal read FWidth;
    property Height: Cardinal read FHeight;
    property SourceBitDepth: Cardinal read FSourceBitDepth;
    property ImageBitDepth: Cardinal read FImageBitDepth;
    property AlphaBitDepth: Cardinal read FAlphaBitDepth;
    property ColorType: Byte read FColorType;
    property CompressionMethod: Byte read FCompressionMethod;
    property FilterMethod: Byte read FFilterMethod;
    property InterlaceMethod: Byte read FInterlaceMethod;
    property PaletteSize: Integer read FPaletteSize;
    property PaletteData: AnsiString read FPaletteData;
    property ImageData: AnsiString read FImageData;
    property AlphaData: AnsiString read FAlphaData;
    property HorizontalDPI: Cardinal read FHorizontalDPI;
    property VerticalDPI: Cardinal read FVerticalDPI;
    property EmbeddedPredictor: Boolean read FEmbeddedPredictor;
    property DownSampleImage: Boolean read FDownSampleImage write FDownSampleImage;
    property DownSampleAlpha: Boolean read FDownSampleAlpha write FDownSampleAlpha;
    property SkipImageData: Boolean read FSkipImageData write FSkipImageData;
    property PalettePosition: Integer read FPalettePosition;
    property TransparencyPosition: Integer read FTransparencyPosition;
    property FirstDataPosition: Integer read FFirstDataPosition;
    property ICCData: AnsiString read FICCData;
  end;

  TPNGWriter = class
  private
    FDPI: Integer;
    FBitmap: TBitmap;
    FHasMask: Boolean;
    FMask: array of array of Byte;
    FHasTransparencyColor: Boolean;
    FTransparencyColor: TColor;
    FCompressedColorProfileData: AnsiString;
    FBitmapAllocated: Boolean;
    procedure WriteChunk(const ChunkType, ChunkData: AnsiString; Stream: TStream);
    function C2S(C: Cardinal): AnsiString;
    function MakeHeaderChunk: AnsiString;
    function MakeIDATChunk: AnsiString;
    function MakepHYsChunk: AnsiString;
    function MaketRNSChunk: AnsiString;
    function MakeiCCPChunk: AnsiString;
  public
    constructor Create(FromBitmap: TBitmap); overload;
    destructor Destroy; override;
    procedure SetDPI(DPI: Integer);
    procedure SetTransparencyColor(Color: TColor);
    procedure SetAlphaChannel(Mask: TBitmap; Reverse: Boolean);
    procedure AddColorProfile(const ProfileData: AnsiString);
    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(const FileName: WideString);    
  end;

implementation

uses
  DebenuPDFLibraryFlate, DebenuPDFLibraryExtra;

const
  PNGHeader: AnsiString = #137#80#78#71#13#10#26#10;

  { PNG filters }
  FILTER_NONE = 0;
  FILTER_SUB = 1;
  FILTER_UP = 2;
  FILTER_AVERAGE = 3;
  FILTER_PAETH = 4;

  { PNG color modes }
  COLOR_GRAYSCALE = 0;
  COLOR_RGB = 2;
  COLOR_PALETTE = 3;
  COLOR_GRAYSCALEALPHA = 4;
  COLOR_RGBALPHA = 6;

  { PNG interlace methods }
  INTERLACE_NULL = 0;
  INTERLACE_ADAM7 = 1;

  { PNG filter methods }
  FILTERMETHOD_STANDARD = 0;

  { PNG compression methods }
  COMPRESSION_ZLIB = 0;

  PNGCRCTable: array[0..255] of Cardinal = (
             $0, $77073096, $EE0E612C, $990951BA,
       $76DC419, $706AF48F, $E963A535, $9E6495A3,
       $EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
       $9B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
      $1DB71064, $6AB020F2, $F3B97148, $84BE41DE,
      $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
      $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
      $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
      $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
      $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
      $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940,
      $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
      $26D930AC, $51DE003A, $C8D75180, $BFD06116,
      $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
      $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
      $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,
      $76DC4190,  $1DB7106, $98D220BC, $EFD5102A,
      $71B18589,  $6B6B51F, $9FBFE4A5, $E8B8D433,
      $7807C9A2,  $F00F934, $9609A88E, $E10E9818,
      $7F6A0DBB,  $86D3D2D, $91646C97, $E6635C01,
      $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
      $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
      $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
      $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
      $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2,
      $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
      $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
      $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
      $5005713C, $270241AA, $BE0B1010, $C90C2086,
      $5768B525, $206F85B3, $B966D409, $CE61E49F,
      $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4,
      $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,
      $EDB88320, $9ABFB3B6,  $3B6E20C, $74B1D29A,
      $EAD54739, $9DD277AF,  $4DB2615, $73DC1683,
      $E3630B12, $94643B84,  $D6D6A3E, $7A6A5AA8,
      $E40ECF0B, $9309FF9D,  $A00AE27, $7D079EB1,
      $F00F9344, $8708A3D2, $1E01F268, $6906C2FE,
      $F762575D, $806567CB, $196C3671, $6E6B06E7,
      $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
      $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
      $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
      $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
      $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
      $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
      $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
      $CC0C7795, $BB0B4703, $220216B9, $5505262F,
      $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04,
      $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
      $9B64C2B0, $EC63F226, $756AA39C,  $26D930A,
      $9C0906A9, $EB0E363F, $72076785,  $5005713,
      $95BF4A82, $E2B87A14, $7BB12BAE,  $CB61B38,
      $92D28E9B, $E5D5BE0D, $7CDCEFB7,  $BDBDF21,
      $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E,
      $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
      $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
      $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
      $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
      $A7672661, $D06016F7, $4969474D, $3E6E77DB,
      $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0,
      $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
      $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6,
      $BAD03605, $CDD70693, $54DE5729, $23D967BF,
      $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
      $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D
   );

{$IFDEF WIN64}
function ByteSwap(const B: Cardinal): Cardinal;
begin
  Result := ((B and $000000FF) shl 24) +
    ((B and $0000FF00) shl 8) +
    ((B and $00FF0000) shr 8) +
    ((B and $FF000000) shr 24);
end;
{$ELSE}
function ByteSwap(const B: Cardinal): Cardinal;
asm
  bswap EAX
end;
{$ENDIF}

function CalculateCRC(const Source: AnsiString): Cardinal;
var
  X: Integer;
begin
  Result := $FFFFFFFF;
  for X := 1 to Length(Source) do
    Result := PNGCRCTable[(Result xor Ord(Source[X])) and $ff] xor (Result shr 8);
  Result := Result xor $ffffffff;
end;

function PaethPredictor(A, B, C: Byte): Byte;
var
  PA, PB, PC: Integer;
begin
  PA := Abs(B - C);
  PB := Abs(A - C);
  PC := Abs(A + B - C * 2);

  if (PA <= PB) and (PA <= PC) then
  begin
    Result := A
  end else
  begin
    if PB <= PC then
      Result := B
    else
      Result := C;
  end;
end;

{ TPNGReader }

constructor TPNGReader.Create;
begin
  inherited Create;
  AlwaysUnfilter := False;
  FWidth := 0;
  FHeight := 0;
  FSourceBitDepth := 0;
  FImageBitDepth := 0;
  FAlphaBitDepth := 0;
  FPaletteSize := 0;
  FPaletteData := '';
  FTransparencyData := '';
  FImageData := '';
  FSourceData := '';
  FAlphaData := '';
  FHorizontalDPI := 96;
  FVerticalDPI := 96;
  FEmbeddedPredictor := False;
  FDownSampleImage := False;
  FDownSampleAlpha := False;
  FSkipImageData := False;
  FPalettePosition := 0;
  FTransparencyPosition := 0;
  FFirstDataPosition := 0;
  FICCData := '';
end;

procedure ByteInc(var B: Byte; I: Byte);
var
  Int32: Integer;
begin
  Int32 := B + I;
  B := Int32 and $FF;
end;

procedure TPNGReader.FilterData;
var
  DataPos: Integer;
  Pass: Integer;
  StartPass: Integer;
  EndPass: Integer;
  PassWidth: Cardinal;
  PassHeight: Cardinal;
  ThisScanline: array of Byte;
  PreviousScanline: array of Byte;
  FilterX: Cardinal;
  X, Y, P, T, SourceDataLength: Integer;
  ImgData: AnsiString;

  Above: Byte;
  Left: Byte;
  AboveLeft: Byte;

  SourceComponents: Cardinal;
  ScanlineBitCount: Cardinal;
  ScanlineByteCount: Cardinal;

  ImageDataBitCount: Cardinal;
  ImageDataByteCount: Cardinal;
  ImageDataComponents: Cardinal;
  AlphaDataByteCount: Cardinal;
  AlphaDataComponents: Cardinal;

  FilterType: Byte;
  PassRow: Cardinal;
  Row: Cardinal;
  PassCol: Cardinal;
  Col: Cardinal;
  StartingRow: Cardinal;
  StartingCol: Cardinal;
  RowIncrement: Cardinal;
  ColIncrement: Cardinal;
  FilterOffset: Cardinal;

  SourcePixelBytes: Cardinal;
  ImagePixelBytes: Cardinal;
  AlphaPixelBytes: Cardinal;
  ScanlinePosition: Cardinal;

  ImageRowStart: Cardinal;
  AlphaRowStart: Cardinal;

  ColumnMapping: array of Byte;
  ShiftMapping: array of Byte;
  SourceByte: Cardinal;
  SourceMask: Byte;
  MaskedValue: Byte;

  DSX: Integer;
const
  Adam7StartingRow: array[1..7] of Cardinal = (0, 0, 4, 0, 2, 0, 1);
  Adam7StartingCol: array[1..7] of Cardinal = (0, 4, 0, 2, 0, 1, 0);
  Adam7RowIncrement: array[1..7] of Cardinal = (8, 8, 8, 4, 4, 2, 2);
  Adam7ColIncrement: array[1..7] of Cardinal = (8, 8, 4, 4, 2, 2, 1);
begin
  // Start with the assumption that the image is in a suitable format
  // for adding directly to the PDF with the Predictor 15 decode parameter
  FEmbeddedPredictor := True;

  if (AlwaysUnfilter) then
  begin
    FEmbeddedPredictor := False;
  end;

  if ((FColorType = COLOR_RGBALPHA) or (FColorType = COLOR_GRAYSCALEALPHA)) then
  begin
    // PDF does not support alpha channel
    FEmbeddedPredictor := False;
  end;

  if (FInterlaceMethod = INTERLACE_ADAM7) then
  begin
    // PDF does not support interlaced PNG data
    FEmbeddedPredictor := False;
  end;

  if (FDownSampleImage and (FSourceBitDepth = 16)) then
  begin
    // Downsampling of the image data from 16-bit to 8-bit has been
    // requested and the data is in 16-bit format
    FEmbeddedPredictor := False;
  end;

  if (FEmbeddedPredictor) then
  begin
    FImageBitDepth := FSourceBitDepth;
    FEmbeddedPredictor := True;
    FImageData := FSourceData;
  end else
  begin
    case FColorType of
      COLOR_GRAYSCALE:
      begin
        SourceComponents := 1;
        ImageDataComponents := 1;
        AlphaDataComponents := 0;
        if FSourceBitDepth = 16 then
        begin
          FilterOffset := 2;
        end else
        begin
          FilterOffset := 1;
        end;
      end;
      COLOR_RGB:
      begin
        SourceComponents := 3;
        ImageDataComponents := 3;
        AlphaDataComponents := 0;
        if FSourceBitDepth = 16 then
        begin
          FilterOffset := 6;
        end else
        begin
          FilterOffset := 3;
        end;
      end;
      COLOR_PALETTE:
      begin
        SourceComponents := 1;
        ImageDataComponents := 1;
        AlphaDataComponents := 0;
        FilterOffset := 1;
      end;
      COLOR_GRAYSCALEALPHA:
      begin
        SourceComponents := 2;
        ImageDataComponents := 1;
        AlphaDataComponents := 1;
        if FSourceBitDepth = 16 then
        begin
          FilterOffset := 4;
        end else
        begin
          FilterOffset := 2;
        end;
      end;
      COLOR_RGBALPHA:
      begin
        SourceComponents := 4;
        ImageDataComponents := 3;
        AlphaDataComponents := 1;
        if FSourceBitDepth = 16 then
        begin
          FilterOffset := 8;
        end else
        begin
          FilterOffset := 4;
        end;
      end;
    else
      SourceComponents := 0;
      ImageDataComponents := 0;
      AlphaDataComponents := 0;
      FilterOffset := 0;
    end;

    FSourceData := InflateStr(FSourceData);
    SourceDataLength := Length(FSourceData);
    DataPos := 1;

    SourcePixelBytes := (SourceComponents * FSourceBitDepth) div 8;

    FImageBitDepth := FSourceBitDepth;
    ImagePixelBytes := (ImageDataComponents * FImageBitDepth) div 8;
    ImageDataBitCount := FWidth * ImageDataComponents * FImageBitDepth;
    ImageDataByteCount := ImageDataBitCount div 8;
    if (ImageDataByteCount * 8) < ImageDataBitCount then
    begin
      Inc(ImageDataByteCount);
    end;
    SetLength(FImageData, ImageDataByteCount * FHeight);
    if Length(FImageData) > 0 then
    begin
      FillChar(FImageData[1], Length(FImageData), 0);
    end;

    FAlphaBitDepth := FSourceBitDepth;
    AlphaPixelBytes := (AlphaDataComponents * FAlphaBitDepth) div 8;
    AlphaDataByteCount := (FWidth * AlphaDataComponents * FAlphaBitDepth) div 8;
    SetLength(FAlphaData, AlphaDataByteCount * FHeight);
    if Length(FImageData) > 0 then
    begin
      FillChar(FAlphaData[1], Length(FAlphaData), 0);
    end;

    if FSourceBitDepth < 8 then
    begin
      SetLength(ColumnMapping, FWidth);
      SetLength(ShiftMapping, FWidth);

      if FSourceBitDepth = 1 then
      begin
        for Col := 0 to FWidth - 1 do
        begin
          ColumnMapping[Col] := Col div 8;
          ShiftMapping[Col] := 7 - Col mod 8;
        end;
      end else
      if FSourceBitDepth = 2 then
      begin
        for Col := 0 to FWidth - 1 do
        begin
          ColumnMapping[Col] := Col div 4;
          ShiftMapping[Col] := (3 - (Col mod 4)) * 2;
        end;
      end else
      if FSourceBitDepth = 4 then
      begin
        for Col := 0 to FWidth - 1 do
        begin
          ColumnMapping[Col] := Col div 2;
          ShiftMapping[Col] := (1 - (Col mod 2)) * 4;
        end;
      end;
    end;

    if FInterlaceMethod = INTERLACE_ADAM7 then
    begin
      StartPass := 1;
      EndPass := 7;
    end else
    begin
      StartPass := 0;
      EndPass := 0;
    end;

    for Pass := StartPass to EndPass do
    begin
      if Pass = 0 then
      begin
        // The data is not interlaced so the entire image is
        // contained in a single pass, starting at the first pixel
        PassWidth := FWidth;
        PassHeight := FHeight;
        StartingRow := 0;
        StartingCol := 0;
        RowIncrement := 1;
        ColIncrement := 1;
      end else
      begin
        // The data is interlaced, calculate the width and height
        // for this pass as well as the starting pixel and pattern
        if ((Adam7StartingCol[Pass] + 1) > FWidth) then
        begin
          PassWidth := 0;
        end else
        begin
          PassWidth := ((FWidth - Adam7StartingCol[Pass] - 1) div
            Adam7ColIncrement[Pass]) + 1;
        end;
        if ((Adam7StartingRow[Pass] + 1) > FHeight) then
        begin
          PassHeight := 0;
        end else
        begin
          PassHeight := ((FHeight - Adam7StartingRow[Pass] - 1) div
            Adam7RowIncrement[Pass]) + 1;
        end;
        StartingRow := Adam7StartingRow[Pass];
        StartingCol := Adam7StartingCol[Pass];
        RowIncrement := Adam7RowIncrement[Pass];
        ColIncrement := Adam7ColIncrement[Pass];
      end;

      if (PassHeight > 0) and (PassWidth > 0) then
      begin
        ScanlineBitCount := PassWidth * SourceComponents * FSourceBitDepth;
        ScanlineByteCount := ScanlineBitCount div 8;
        if (ScanlineByteCount * 8) < ScanlineBitCount then
        begin
          Inc(ScanlineByteCount);
        end;

        SetLength(ThisScanline, ScanlineByteCount);
        SetLength(PreviousScanline, ScanlineByteCount);
        FillChar(PreviousScanline[0], ScanlineByteCount, 0);

        Row := StartingRow;
        for PassRow := 0 to PassHeight - 1 do
        begin
          if ((DataPos + Integer(ScanlineByteCount)) > SourceDataLength) then
          begin
            // Not enough data, set the both the filter type to 0
            // and the image data to "white" (all bits set)
            FilterType := 0;
            FillChar(ThisScanline[0], ScanlineByteCount, 255);
          end else
          begin
            FilterType := Ord(FSourceData[DataPos]);
            Move(FSourceData[DataPos + 1], ThisScanline[0], ScanlineByteCount);
          end;

          Inc(DataPos, ScanlineByteCount + 1);

          if FilterType = FILTER_SUB then
          begin
            for FilterX := FilterOffset to ScanlineByteCount - 1 do
            begin
              ByteInc(ThisScanline[FilterX], ThisScanline[FilterX - FilterOffset]);
            end;
          end;

          if FilterType = FILTER_UP then
          begin
            for FilterX := 0 to ScanlineByteCount - 1 do
              ByteInc(ThisScanline[FilterX], PreviousScanline[FilterX]);
          end;

          if FilterType = FILTER_AVERAGE then
          begin
            Left := 0;
            for FilterX := 0 to ScanlineByteCount - 1 do
            begin
              Above := PreviousScanline[FilterX];
              if (FilterX >= FilterOffset) then
              begin
                Left := ThisScanline[FilterX - FilterOffset];
              end;
              ByteInc(ThisScanline[FilterX], (Left + Above) div 2);
            end;
          end;

          if FilterType = FILTER_PAETH then
          begin
            Left := 0;
            AboveLeft := 0;

            for FilterX := 0 to ScanlineByteCount - 1 do
            begin
              Above := PreviousScanline[FilterX];
              if (FilterX >= FilterOffset) then
              begin
                Left := ThisScanline[FilterX - FilterOffset];
                AboveLeft := PreviousScanline[FilterX - FilterOffset];
              end;

              ByteInc(ThisScanline[FilterX],
                PaethPredictor(Left, Above, AboveLeft));
            end;
          end;

          // Put the filtered data into the image data array
          // according to the current interlace pass pattern
          if ((AlphaDataComponents = 0) and (FSourceBitDepth < 8)) then
          begin
            SourceByte := 0;
            case FSourceBitDepth of
              1: SourceMask := 128;
              2: SourceMask := 192;
            else
              SourceMask := 240;
            end;
            Col := StartingCol;
            ImageRowStart := Row * ImageDataByteCount + 1;
            for PassCol := 0 to PassWidth - 1 do
            begin
              MaskedValue := (ThisScanline[SourceByte] and SourceMask) shr
                ShiftMapping[PassCol];
              Inc(Byte(FImageData[ImageRowStart + ColumnMapping[Col]]),
                MaskedValue shl ShiftMapping[Col]);
              SourceMask := SourceMask shr FSourceBitDepth;
              if (SourceMask = 0) then
              begin
                Inc(SourceByte);
                case FSourceBitDepth of
                  1: SourceMask := 128;
                  2: SourceMask := 192;
                  4: SourceMask := 240;
                end;
              end;
              Inc(Col, ColIncrement);
            end;
          end else
          if ((AlphaDataComponents = 0) and (FSourceBitDepth >= 8)) then
          begin
            Col := StartingCol;
            ScanlinePosition := 0;
            ImageRowStart := Row * ImageDataByteCount + 1;
            for PassCol := 0 to PassWidth - 1 do
            begin
              Move(ThisScanline[ScanlinePosition],
                FImageData[ImageRowStart + Col * ImagePixelBytes],
                ImagePixelBytes);
              Inc(ScanlinePosition, SourcePixelBytes);
              Inc(Col, ColIncrement);
            end;
          end else
          begin
            Col := StartingCol;
            ScanlinePosition := 0;
            ImageRowStart := Row * ImageDataByteCount + 1;
            AlphaRowStart := Row * AlphaDataByteCount + 1;
            for PassCol := 0 to PassWidth - 1 do
            begin
              Move(ThisScanline[ScanlinePosition],
                FImageData[ImageRowStart + Col * ImagePixelBytes],
                ImagePixelBytes);
              Inc(ScanlinePosition, SourcePixelBytes);
              Move(ThisScanline[ScanlinePosition - AlphaPixelBytes],
                FAlphaData[AlphaRowStart + Col * AlphaPixelBytes],
                AlphaPixelBytes);
              Inc(Col, ColIncrement);
            end;
          end;
          Inc(Row, RowIncrement);

          // Keep a copy of this scanline
          Move(ThisScanline[0], PreviousScanline[0], ScanlineByteCount);
        end;
      end;
    end;

    if (FDownSampleImage and (FImageBitDepth = 16)) then
    begin
      for DSX := 1 to Length(FImageData) div 2 do
      begin
        FImageData[DSX] := FImageData[DSX * 2 - 1];
      end;
      SetLength(FImageData, Length(FImageData) div 2);
      FImageBitDepth := 8;
    end;
    FImageData := DeflateStr(FImageData);

    if (FDownSampleAlpha and (FAlphaBitDepth = 16)) then
    begin
      for DSX := 1 to Length(FAlphaData) div 2 do
      begin
        FAlphaData[DSX] := FAlphaData[DSX * 2 - 1];
      end;
      SetLength(FAlphaData, Length(FAlphaData) div 2);
      FAlphaBitDepth := 8;
    end;
    FAlphaData := DeflateStr(FAlphaData);
  end;

  if (FColorType = COLOR_PALETTE) and (Length(FAlphaData) = 0) and
     (Length(FTransparencyData) <> 0) and (FSourceBitDepth = 8) then
  begin
    ImgData := InflateStr(FImageData);

    FAlphaBitDepth := FSourceBitDepth;
    //AlphaDataComponents := 1;
    //AlphaDataByteCount := (FWidth * AlphaDataComponents * FAlphaBitDepth) div 8;

    if FSourceBitDepth = 16 then
      FilterOffset := 4
    else
      FilterOffset := 2;

    SetLength(FAlphaData, FWidth * FHeight);

    if Length(ImgData) > 0 then
    begin
      FillChar(FAlphaData[1], Length(FAlphaData), 0);

      // There is an extra byte at the start of each scanline. 1 byte for 8bit, 2 for 16bit.
      // This code works for 8 bit data only
      P := FilterOffset;
      T := 1;
      for Y := 1 to FHeight do
      begin
        for X := 1 to FWidth do
        begin
          FAlphaData[T] := FTransparencyData[Ord(ImgData[P]) + 1];
          Inc(P);
          Inc(T);
        end;
        Inc(P);  // Skip the first scanline byte.
      end;
      FAlphaData := DeflateStr(FAlphaData);
    end;
  end;
end;

procedure TPNGReader.LoadFromFile(const FileName: WideString);
var
  FS: TQuickPDFWideFileStream;
begin
  try
    FS := QPLCreateFileStream(FileName, fmOpenRead);
    try
      LoadFromStream(FS);
    finally
      FS.Free;
    end;
  except
  end;
end;

procedure TPNGReader.LoadFromStream(InStream: TStream);
var
  S: AnsiString;
  AtEnd: Boolean;
  ChunkCount: Cardinal;
  ChunkLength: Cardinal;
  ChunkName: AnsiString;
  ChunkCRC: Cardinal;
  Processed: Boolean;
  B: Byte;
  ValidImage: Boolean;
  ChunkPosition: Cardinal;
  ICCProfileNameLength: Integer;
begin
  SetLength(S, 8);
  InStream.Read(S[1], 8);
  if S = PNGHeader then
  begin
    AtEnd := False;
    ChunkCount := 0;
    SetLength(ChunkName, 4);
    repeat
      Inc(ChunkCount);
      ChunkPosition := InStream.Position;
      if InStream.Read(ChunkLength, 4) < 4 then AtEnd := True;
      if not AtEnd then
      begin
        ChunkLength := ByteSwap(ChunkLength);
        InStream.Read(ChunkName[1], 4);
      end;
      if (ChunkCount = 1) and (ChunkName <> 'IHDR') then AtEnd := True;
      if ChunkName = 'IEND' then AtEnd := True;
      if not AtEnd then
      begin
        Processed := False;

        if ChunkName = 'IHDR' then
        begin
          InStream.Read(FWidth, 4);
          FWidth := ByteSwap(FWidth);
          InStream.Read(FHeight, 4);
          FHeight := ByteSwap(FHeight);

          InStream.Read(B, 1);
          FSourceBitDepth := B;
          InStream.Read(FColorType, 1);
          InStream.Read(FCompressionMethod, 1);
          InStream.Read(FFilterMethod, 1);
          InStream.Read(FInterlaceMethod, 1);

          Processed := True;
          if ChunkLength > 13 then
          begin
            SetLength(S, ChunkLength - 13);
            InStream.Read(S[1], Length(S));
          end;
        end;

        if ChunkName = 'PLTE' then
        begin
          SetLength(FPaletteData, ChunkLength);
          FPalettePosition := InStream.Position;
          if Cardinal(InStream.Read(FPaletteData[1], ChunkLength)) <>
            ChunkLength then AtEnd := True;
          FPaletteSize := ChunkLength div 3;
          Processed := True;
        end;

        if ChunkName = 'tRNS' then
        begin
          if (ChunkLength < 256) then
          begin
            SetLength(FTransparencyData, 256);
            FillChar(FTransparencyData[1], Length(FTransparencyData), 0);
          end
          else
            SetLength(FTransparencyData, ChunkLength);

          FTransparencyPosition := InStream.Position - 8;
          if (ChunkLength > 0) then
          begin
            if Cardinal(InStream.Read(FTransparencyData[1], ChunkLength)) <>
              ChunkLength then AtEnd := True;
          end;
          Processed := True;
        end;

        if ChunkName = 'IDAT' then
        begin
          if FFirstDataPosition = 0 then
          begin
            FFirstDataPosition := ChunkPosition;
          end;
          SetLength(S, ChunkLength);
          if Cardinal(InStream.Read(S[1], ChunkLength)) <> ChunkLength then
            AtEnd := True;
          if not FSkipImageData then
          begin
            FSourceData := FSourceData + S;
          end;
          Processed := True;
        end;

        if ChunkName = 'pHYs' then
        begin
          SetLength(S, ChunkLength);
          if Cardinal(InStream.Read(S[1], ChunkLength)) = ChunkLength then
          begin
            FHorizontalDPI := Ord(S[1]) shl 24 + Ord(S[2]) shl 16 +
              Ord(S[3]) shl 8 + Ord(S[4]);
            FVerticalDPI := Ord(S[5]) shl 24 + Ord(S[6]) shl 16 +
              Ord(S[7]) shl 8 + Ord(S[8]);

            if ((FHorizontalDPI = 0) or (FVerticalDPI = 0)) then
            begin
              FHorizontalDPI := 96;
              FVerticalDPI := 96;
            end;

            if S[9] = #1 then
            begin
              FHorizontalDPI := FHorizontalDPI * 254 div 10000;
              FVerticalDPI := FVerticalDPI * 254 div 10000;
            end else
            begin
              FVerticalDPI := FVerticalDPI * 96 div FHorizontalDPI;
              FHorizontalDPI := 96;
            end;
          end else
            AtEnd := True;

          Processed := True;
        end;

        if ChunkName = 'iCCP' then
        begin
          SetLength(FICCData, ChunkLength);
          if (ChunkLength > 0) then
          begin
            if Cardinal(InStream.Read(FICCData[1], ChunkLength)) <>
              ChunkLength then AtEnd := True;
            ICCProfileNameLength := QPLPos(#0, FICCData) - 1;
            if (ICCProfileNameLength < 80) then
            begin
              Delete(FICCData, 1, ICCProfileNameLength);
              if (QPLStartsWith(FICCData, #0#0)) then
              begin
                // Flate compressed ICC data
                Delete(FICCData, 1, 2);
              end else
              begin
                FICCData := '';
              end;
            end;
          end;
          Processed := True;
        end;

        if not Processed then
        begin
          if (Integer(InStream.Position) + Integer(ChunkLength)) > Integer(InStream.Size) then
          begin
            AtEnd := True;
          end else
          begin
            InStream.Seek(ChunkLength, soCurrent);
          end;
        end;

        if InStream.Read(ChunkCRC, 4) < 4 then AtEnd := True;
      end;
    until AtEnd;
  end;

  ValidImage := True;
  if (FFilterMethod <> FILTERMETHOD_STANDARD) then
  begin
    ValidImage := False;
  end;

  if (FCompressionMethod <> COMPRESSION_ZLIB) then
  begin
    ValidImage := False;
  end;

  if ((FWidth = 0) or (FHeight = 0)) then
  begin
    ValidImage := False;
  end;

  if ((not SkipImageData) and (Length(FSourceData) = 0)) then
  begin
    ValidImage := False;
  end;

  if ((not SkipImageData) and ValidImage) then
  begin
    FilterData;
  end;
end;

function TPNGReader.MakePDFPalette: AnsiString;
var
  X: Integer;
begin
  Result := '/DeviceRGB ' + QPLIntToStr(PaletteSize - 1) + '<';
  for X := 1 to Length(PaletteData) do
    Result := Result + QPLIntToHex(Ord(PaletteData[X]), 2);
  Result := Result + '>';
end;

function TPNGReader.SaveToBitmap: TBitmap;
var
  Row: Integer;
  Col: Integer;
  RowData: AnsiString;
  CopyFromPos: Integer;
  CopyToPos: Integer;
begin
  Result := nil;
  if (FAlphaData <> '') and (FImageBitDepth = 8) and (FAlphaBitDepth = 8) then
  begin
    if (QPLStartsWith(FAlphaData, #$78)) then
    begin
      FAlphaData := InflateStr(FAlphaData);
    end;
    if (QPLStartsWith(FImageData, #$78)) then
    begin
      FImageData := InflateStr(FImageData);
    end;
    Result := TBitmap.Create;
    Result.PixelFormat := pf32bit;
    Result.Width := FWidth;
    Result.Height := FHeight;
    for Row := 0 to FHeight - 1 do
    begin
      RowData := QPLCopy(FImageData, Row * Integer(FWidth) * 3 + 1, Integer(FWidth) * 3);
      if (Length(RowData) = Integer(FWidth * 3)) then
      begin
        SetLength(RowData, FWidth * 4);
        CopyFromPos := FWidth * 3 - 2;
        CopyToPos := FWidth * 4 - 3;
        for Col := 1 to FWidth do
        begin
          Move(RowData[CopyFromPos], RowData[CopyToPos], 3);
          Dec(CopyFromPos, 3);
          Dec(CopyToPos, 4);
        end;
        for Col := 0 to FWidth - 1 do
        begin
          RowData[Col * 4 + 3] := FAlphaData[Row * Integer(FWidth) + Col + 1];
        end;
      end;
    end;
  end else
  if (FImageBitDepth = 8) then
  begin
    Result := TBitmap.Create;
    Result.PixelFormat := pf24bit;
    Result.Width := FWidth;
    Result.Height := FHeight;
    for Row := 0 to FHeight - 1 do
    begin
      RowData := QPLCopy(FImageData, Row * Integer(FWidth) * 3 + 1, FWidth * 3);
      if (Length(RowData) = Integer(FWidth) * 3) then
      begin
        Move(RowData[1], Result.ScanLine[Row]^, FWidth * 3);
      end;
    end;
  end;
end;

{ TPNGWriter }

constructor TPNGWriter.Create(FromBitmap: TBitmap);
begin
  FBitmapAllocated := False;

  if (FromBitmap.PixelFormat = pf24bit) then
    FBitmap := FromBitmap
  else
  begin
    FBitmapAllocated := True;
    FBitmap := TBitmap.Create;
    FBitmap.Assign(FromBitmap);
    FBitmap.PixelFormat := pf24bit;
    FHasMask := False;
    FHasTransparencyColor := False;
  end;
end;

function TPNGWriter.C2S(C: Cardinal): AnsiString;
begin
  C := ByteSwap(C);
  Result := '';
  Result := Result + AnsiChar(C and $FF);
  Result := Result + AnsiChar((C and $FF00) shr 8);
  Result := Result + AnsiChar((C and $FF0000) shr 16);
  Result := Result + AnsiChar((C and $FF000000) shr 24);
end;

function TPNGWriter.MakeHeaderChunk: AnsiString;
begin
  Result := C2S(FBitmap.Width);
  Result := Result + C2S(FBitmap.Height);
  Result := Result + #8;
  if FHasMask then
    Result := Result + #6
  else
    Result := Result + #2;
  Result := Result + #0;
  Result := Result + #0;
  Result := Result + #0;
end;

procedure TPNGWriter.SaveToFile(const FileName: WideString);
var
  FS: TQuickPDFWideFileStream;
begin
  FS := QPLCreateFileStream(FileName, fmCreate);
  try
    SaveToStream(FS);
  finally
    FS.Free;
  end;
end;

procedure TPNGWriter.SaveToStream(Stream: TStream);
begin
  Stream.Write(PNGHeader[1], 8);
  WriteChunk('IHDR', MakeHeaderChunk, Stream);
  WriteChunk('pHYs', MakepHYsChunk, Stream);
  if FHasTransparencyColor then
    WriteChunk('tRNS', MaketRNSChunk, Stream);
  if Length(FCompressedColorProfileData) > 0 then
    WriteChunk('iCCP', MakeiCCPChunk, Stream);
  WriteChunk('IDAT', MakeIDATChunk, Stream);
  WriteChunk('IEND', '', Stream);
end;

procedure TPNGWriter.SetAlphaChannel(Mask: TBitmap; Reverse: Boolean);
var
  Row: Integer;
  Col: Integer;
  ScanLine: array of Byte;
  PrivateMask: TBitmap;
begin
  if Assigned(Mask) and (Mask.Width > 0) and (Mask.Height > 0) then
  begin
    PrivateMask := TBitmap.Create;
    try
      PrivateMask.Assign(Mask);
      PrivateMask.PixelFormat := pf24bit;
      SetLength(FMask, PrivateMask.Height);
      SetLength(ScanLine, PrivateMask.Width * 3);
      for Row := 0 to PrivateMask.Height - 1 do
      begin
        Move(PrivateMask.ScanLine[Row]^, ScanLine[0], Length(ScanLine));
        SetLength(FMask[Row], PrivateMask.Width);
        if Reverse then
        begin
          for Col := 0 to PrivateMask.Width - 1 do
            FMask[Row][Col] := 255 - ScanLine[Col * 3];
        end else
        begin
          for Col := 0 to PrivateMask.Width - 1 do
            FMask[Row][Col] := ScanLine[Col * 3];
        end;
      end;
      FHasMask := True;
    finally
      PrivateMask.Free;
    end;
  end;
end;

procedure TPNGWriter.WriteChunk(const ChunkType, ChunkData: AnsiString;
  Stream: TStream);
var
  ChunkLength: Cardinal;
  CD: AnsiString;
  CRC: Cardinal;
begin
  ChunkLength := Length(ChunkData);
  ChunkLength := ByteSwap(ChunkLength);
  Stream.Write(ChunkLength, 4);
  CD := QPLCopy(ChunkType + '    ', 1, 4);
  Stream.Write(CD[1], 4);
  if Length(ChunkData) > 0 then
    Stream.Write(ChunkData[1], Length(ChunkData));
  CRC := CalculateCRC(ChunkType + ChunkData);
  CRC := ByteSwap(CRC);
  Stream.Write(CRC, 4);
end;

function TPNGWriter.MakeIDATChunk: AnsiString;
var
  Row: Integer;
  RowData: AnsiString;
  ScanLine: AnsiString;
  Col: Integer;
  RDW: Integer;
  RM, RD: Integer;
  CM, CD: Integer;
  MX, MY: Integer;
  Offset: Integer;
  ColRDW: Integer;
  Col3: Integer;
begin
  Offset := 1;

  try
    if FHasMask then
    begin
      RDW := 4;
      CM := Length(FMask[0]) - 1;
      CD := FBitmap.Width - 1;
      RM := Length(FMask) - 1;
      RD := FBitmap.Height - 1;
    end else
    begin
      RDW := 3;
      CM := 0;
      CD := 0;
      RM := 0;
      RD := 0;
    end;
    SetLength(RowData, FBitmap.Width * RDW + 1);
    SetLength(Result, FBitmap.Height * Length(RowData));

    RowData[1] := #0;
    SetLength(ScanLine, FBitmap.Width * 3);
    for Row := 0 to FBitmap.Height - 1 do
    begin
      Move(FBitmap.ScanLine[Row]^, ScanLine[1], FBitmap.Width * 3);
      for Col := 0 to FBitmap.Width - 1 do
      begin
        ColRDW := Col * RDW;
        Col3 := Col * 3;
        RowData[ColRDW + 2] := ScanLine[Col3 + 3];
        RowData[ColRDW + 3] := ScanLine[Col3 + 2];
        RowData[ColRDW + 4] := ScanLine[Col3 + 1];
        if FHasMask then
        begin
          if (RD = 0) and (RM = 0) then
          begin
            MY := Row
          end else
          if (RD = 0) then
          begin
            MY := 0;
          end else
            MY := Row * RM div RD;

          if (CM = 0) and (CD = 0) then
          begin
            MX := Col
          end else
          if (CD = 0) then
          begin
            MX := 0;
          end else
            MX := Col * CM div CD;

          RowData[ColRDW + 5] := AnsiChar(FMask[MY][MX]);
        end;
      end;

      Move(RowData[1], Result[Offset], Length(RowData));
      Inc(Offset, Length(RowData));
    end;

    Result := DeflateStr(Result);
  finally
  end;
end;

destructor TPNGWriter.Destroy;
begin
  if (FBitmapAllocated) then
    FBitmap.Free;
  inherited;
end;

procedure TPNGWriter.SetDPI(DPI: Integer);
begin
  FDPI := DPI;
end;

function TPNGWriter.MakepHYsChunk: AnsiString;
var
  DPIM: Cardinal;
begin
  if (FDPI = 0) then
  begin
    FDPI := 96;
  end;
  DPIM := (FDPI * 10000) div 254 + 1;
  Result := AnsiChar((DPIM and $FF000000) shr 24) +
    AnsiChar((DPIM and $FF0000) shr 16) +
    AnsiChar((DPIM and $FF00) shr 8) +
    AnsiChar(DPIM and $FF);
  Result := Result + Result;
  Result := Result + #1;
end;

procedure TPNGWriter.SetTransparencyColor(Color: TColor);
begin
  FHasTransparencyColor := True;
  FTransparencyColor := Color;
end;

function TPNGWriter.MaketRNSChunk: AnsiString;
begin
  Result := AnsiChar(0) + AnsiChar(FTransparencyColor and $FF);
  Result := Result + AnsiChar(0) + AnsiChar((FTransparencyColor and $FF00) shr 8);
  Result := Result + AnsiChar(0) + AnsiChar((FTransparencyColor and $FF0000) shr 16);
end;

procedure TPNGWriter.AddColorProfile(const ProfileData: AnsiString);
begin
  FCompressedColorProfileData := DeflateStr(ProfileData);
end;

function TPNGWriter.MakeiCCPChunk: AnsiString;
var
  HeaderLength: Integer;
  ProfileLength: Integer;
begin
  ProfileLength := Length(FCompressedColorProfileData);

  // Profile name, null separator, compression type = 0
  Result := 'QPLProfile'#0#0;
  HeaderLength := Length(Result);

  SetLength(Result, HeaderLength + ProfileLength);
  if ProfileLength > 0 then
  begin
    Move(FCompressedColorProfileData[1], Result[HeaderLength + 1], ProfileLength);
  end;
end;

end.
