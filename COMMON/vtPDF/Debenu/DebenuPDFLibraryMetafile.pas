{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryMetafile.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryMetafile;

{$I DebenuPDFLibraryDefines.inc}

interface

{$IFDEF QPL_NOVCL}
uses
  Contnrs, DebenuPDFLibraryStructure, DebenuPDFLibraryGraphics, DebenuPDFLibraryExtra;

type
  TPDFMetafile = class
  private
    FEnhanced: Boolean;
    FEmbedFonts: Boolean;
    FCompressFonts: Boolean;
    FRecompressImages: Boolean;
    FNoEmbedFontList: AnsiString;
  public
    constructor Create(AStructure: TPDFStructure; AFonts: TObjectList;
      ABitmaps: TObjectList; AGSs: TObjectList; APatterns: TObjectList);
    procedure Process(MF: TMetafile; OutStream: TPDFStream);
    property Enhanced: Boolean read FEnhanced write FEnhanced;
    property EmbedFonts: Boolean read FEmbedFonts write FEmbedFonts;
    property CompressFonts: Boolean read FCompressFonts write FCompressFonts;
    property RecompressImages: Boolean read FRecompressImages write FRecompressImages;
    property NoEmbedFontList: AnsiString read FNoEmbedFontList write FNoEmbedFontList;
  end;

implementation

constructor TPDFMetafile.Create(AStructure: TPDFStructure; AFonts: TObjectList;
  ABitmaps: TObjectList; AGSs: TObjectList; APatterns: TObjectList);
begin

end;

procedure TPDFMetafile.Process(MF: TMetafile; OutStream: TPDFStream);
begin

end;

{$ELSE}

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  Classes,
{$IFNDEF VER120}
  Contnrs,
{$ENDIF}
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  Math,
  DebenuPDFLibraryStructure, DebenuPDFLibraryPainter, DebenuPDFLibraryFont, DebenuPDFLibraryImage,
  DebenuPDFLibraryDigest, DebenuPDFLibraryExtra,
{$IFDEF WIN64}
  DebenuPDFLibraryJPEGWin64,
{$ELSE}
  DebenuPDFLibraryJPEG,
{$ENDIF}
  DebenuPDFLibraryPatterns;

type
  PEMRSmallTextOut = record
    emr: tagEMR;
    x: Integer;
    y: Integer;
    cChars: Cardinal;
    fuOptions: Cardinal;
    iGraphicsMode: Cardinal;
    exScale: Single;
    eyScale: Single;
  end;

  PEMRSmallTextOut2 = record
    emrSmallTextOut: PEMRSmallTextOut;
    Bounds: TRect;
  end;

  PEMRGradientFill = record
    emr: tagEMR;
    Bounds: TRect;
    nVer: Cardinal;
    nTri: Cardinal;
    ulMode: Cardinal;
  end;

  PersTrivertex = record
    X: Double;
    Y: Double;
    R: Double;
    G: Double;
    B: Double;
  end;

{$IFDEF QPL_NOVCL}
  tagBITMAPINFO = packed record
    bmiHeader: TBitmapInfoHeader;
    bmiColors: array[0..0] of TRGBQuad;
  end;
{$ENDIF}

  PersBitmapInfo = record
    BitmapInfo: tagBitmapInfo;
    Colors: array[0..254] of RGBQUAD;
  end;

  EmfTransform = record
    Mode: Integer;
    InitXform: XForm;
    TransXForm: XForm;
    PdfXForm: XForm;
    WinOrgX, WinOrgY: Integer;
    WinExtX, WinExtY: Integer;
    PortOrgX, PortOrgY: Integer;
    PortExtX, PortExtY: Integer;
  end;

type
  TIntegerArray = array of Integer;
  TPointArray = array of TPoint;
  TPointArrayArray = array of TPointArray;
  TSmallPointArray = array of TSmallPoint;
  TSmallPointArrayArray = array of TSmallPointArray;

  TPDFMetafile = class
  private
    FEnhanced: Boolean;
    FStructure: TPDFStructure;
    FIncludedFonts: TObjectList;
    FIncludedBitmaps: TObjectList;
    FIncludedGS: TObjectList;
    FIncludedPatterns: TObjectList;
    FFonts: TQuickPDFStringList;
    FBrushes: TQuickPDFStringList;
    FPens: TQuickPDFStringList;
    WorldTransformStack: TQuickPDFStringList;
    GSStack: TQuickPDFStringList;
    FWinFonts: TQuickPDFStringList;
    FMetafile: TMetafile;
    FPainter: TPDFPainter;
    FFillMode: Integer;
    FFillColor: TColor;
    FTextMode: Integer;
    FHasFill: Boolean;
    FHasPen: Boolean;
    FPenColor: TColor;
    FPenDash: AnsiString;
    FInPath: Boolean;
    FPathStarted: Boolean;
    FXPos: Double;
    FYPos: Double;
    WFXPos: Integer;
    WFYPos: Integer;
    FArcDirection: Integer;
    FBkMode: Integer;
    FBkColor: Integer;
    FTextColor: Integer;
    FTextAlign: Integer;
    FStateCounter: Integer;
    FIcmMode: Integer;
    FSelFont: TPDFFont;
    FFntUnderLine: Boolean;
    FFntStrikeOut: Boolean;
    FFntCharSet: AnsiString;
    FFntSize: Double;
    FFntAngle: Integer;
    FFntTextScaling: Double;
    FHorzRes, FVertRes: Integer;
    FHorzSize, FVertSize: Integer;
    FXRes, FYRes: Double;
    FTrans: EmfTransform;
    FOrientation: Integer;
    FMiterLimit: Double;
    FEmbedFonts: Boolean;
    FCompressFonts: Boolean;
    FRecompressImages: Boolean;
    FNoEmbedFontList: AnsiString;
    FForceUFI: Boolean;

    FWinAnsiCharList: WideString;
    FPatternBrushName : AnsiString;

    FSelectedPenHandle: Cardinal;
    FSelectedBrushHandle: Cardinal;
    FSelectedFontHandle: Cardinal;

    eM11, eM12, eM21, eM22, eDx, eDy: Single;
    eM11b, eM12b, eM21b, eM22b, eDxb, eDyb: Single;
    OrigSW : Single;
    function Sx(X, Y: Double): Double;
    function Sy(X, Y: Double): Double;
    function Sw(X: Double): Double;
    function Sh(Y: Double): Double;
    function Sxb(X, Y: Double): Double;
    function Syb(X, Y: Double): Double;
  protected
    // Bitmaps
    procedure EmfAlphaBlend(Pnt: PEnhMetaRecord);
    procedure EmfBitBLT(Pnt: PEnhMetaRecord);
    procedure EmfMaskBlt(Pnt: PEnhMetaRecord);
    procedure EmfPlgBlt(Pnt: PEnhMetaRecord);
    procedure EmfSetBitToDevice(Pnt: PEnhMetaRecord);
    procedure EmfStretchBLT(Pnt: PEnhMetaRecord);
    procedure EmfStretchDiBits(Pnt: PEnhMetaRecord);
    procedure EmfTransparentBlt(Pnt: PEnhMetaRecord);

    // Clipping
    procedure EmfExcludeClipRect(Pnt: PEnhMetaRecord);
    procedure EmfExtSelectClipRgn(Pnt: PEnhMetaRecord);
    procedure EmfIntersectClipRect(Pnt: PEnhMetaRecord);
    procedure EmfOffsetClipRgn(Pnt: PEnhMetaRecord);
    procedure EmfSelectClipPath(Pnt: PEnhMetaRecord);
    procedure EmfSetMetaRgn(Pnt: PEnhMetaRecord);

    // Comments
    procedure EmfGdiComment(Pnt: PEnhMetaRecord);

    // Control
    procedure ProcessHeader(Header: PEnhMetaHeader);

    // Drawing
    procedure EmfAngleArc(Pnt: PenhMetaRecord);
    procedure EmfArc(Pnt: PenhMetaRecord);
    procedure EmfArcTo(Pnt: PenhMetaRecord);
    procedure EmfChord(Pnt: PenhMetaRecord);
    procedure EmfEllipse(Pnt: PEnhMetaRecord);
    procedure EmfExtFloodFill(Pnt: PEnhMetaRecord);
    procedure EmfExtTextOutA(Pnt: PEnhMetaRecord);
    procedure EmfExtTextOutW(Pnt: PEnhMetaRecord);
    procedure EmfFillPath(Pnt: PEnhMetaRecord);
    procedure EmfFillRgn(Pnt: PEnhMetaRecord);
    procedure EmfFrameRgn(Pnt: PEnhMetaRecord);
    procedure EmfGradientFill(Pnt: PEnhMetaRecord);
    procedure EmfLineTo(Pnt: PEnhMetaRecord);
    procedure EmfPaintRgn(Pnt: PEnhMetaRecord);
    procedure EmfPie(Pnt: PEnhMetaRecord);
    procedure EmfPolyBezier(Pnt: PEnhMetaRecord);
    procedure EmfPolyBezier16(Pnt: PEnhMetaRecord);
    procedure EmfPolyBezierTo16(Pnt: PEnhMetaRecord);
    procedure EmfPolyBezierTo(Pnt: PEnhMetaRecord);
    procedure EmfPolyDraw(Pnt: PEnhMetaRecord);
    procedure EmfPolyDraw16(Pnt: PEnhMetaRecord);
    procedure EmfPolygon(Pnt: PEnhMetaRecord);
    procedure EmfPolygon16(Pnt: PEnhMetaRecord);
    procedure EmfPolyLine(Pnt: PEnhMetaRecord);
    procedure EmfPolyLine16(Pnt: PEnhMetaRecord);
    procedure EmfPolyLineTo(Pnt: PEnhMetaRecord);
    procedure EmfPolyLineTo16(Pnt: PEnhMetaRecord);
    procedure EmfPolyPolygon(Pnt: PEnhMetaRecord);
    procedure EmfPolyPolyLine(Pnt: PEnhMetaRecord);
    procedure EmfPolyPolyLine16(Pnt: PEnhMetaRecord);
    procedure EmfPolyTextOutA(Pnt: PEnhMetaRecord);
    procedure EmfPolyTextOutW(Pnt: PEnhMetaRecord);
    procedure EmfRectangle(Pnt: PEnhMetaRecord);
    procedure EmfRoundRect(Pnt: PEnhMetaRecord);
    procedure EmfSetPixelV(Pnt: PEnhMetaRecord);
    procedure EmfSmallTextOut(Pnt: PEnhMetaRecord);
    procedure EmfStrokeAndFillPath(Pnt: PEnhMetaRecord);
    procedure EmfStrokePath(Pnt: PEnhMetaRecord);
    procedure EmfPolyPolygon16(Pnt: PEnhMetaRecord);

    // Escape
    procedure EmfDrawEscape(Pnt: PEnhMetaRecord);
    procedure EmfExtEscape(Pnt: PEnhMetaRecord);
    procedure EmfNamedEscape(Pnt: PEnhMetaRecord);

    // Object creation
    procedure EmfCreateBrushIndirect(Pnt: PEnhMetaRecord);
    procedure EmfCreateColorSpace(Pnt: PEnhMetaRecord);
    procedure EmfCreateColorSpaceW(Pnt: PEnhMetaRecord);
    procedure EmfCreateDibPatternBrushPT(Pnt: PEnhMetaRecord);
    procedure EmfCreateMonoBrush(Pnt: PEnhMetaRecord);
    procedure EmfCreatepalette(Pnt: PEnhMetaRecord);
    procedure EmfCreatePen(Pnt: PEnhMetaRecord);
    procedure EmfExtCreateFontIndirectW(Pnt: PEnhMetaRecord);
    procedure EmfExtCreatePen(Pnt: PEnhMetaRecord);

    // Object manipulation
    procedure EmfColorCorrectPalette(Pnt: PEnhMetaRecord);
    procedure EmfDeleteColorSpace(Pnt: PEnhMetaRecord);
    procedure EmfDeleteObject(Pnt: PEnhMetaRecord);
    procedure EmfResizePalette(Pnt: PEnhMetaRecord);
    procedure EmfSelectObject(Pnt: PEnhMetaRecord);
    procedure EmfSelectpalette(Pnt: PEnhMetaRecord);
    procedure EmfSetColorSpace(Pnt: PEnhMetaRecord);
    procedure EmfSetPaletteEntries(Pnt: PEnhMetaRecord);

    // OpenGL
    procedure EmfGlsBoundedRecord(Pnt: PEnhMetaRecord);
    procedure EmfGlsRecord(Pnt: PEnhMetaRecord);

    //Paths
    procedure EmfAbortPath(Pnt: PEnhMetaRecord);
    procedure EmfBeginPath(Pnt: PEnhMetaRecord);
    procedure EmfClosePath(Pnt: PEnhMetaRecord);
    procedure EmfEndPath(Pnt: PEnhMetaRecord);
    procedure EmfFlattenPath(Pnt: PEnhMetaRecord);
    procedure EmfWidenPath(Pnt: PEnhMetaRecord);

    // State
    procedure EmfColorMatchToTargetW(Pnt: PEnhMetaRecord);
    procedure EmfForceUfiMapping(Pnt: PEnhMetaRecord);
    procedure EmfInvertRgn(Pnt: PEnhMetaRecord);
    procedure EmfMoveToEx(Pnt: PEnhMetaRecord);
    procedure EmfPixelFormat(Pnt: PEnhMetaRecord);
    procedure EmfRealizePalette(Pnt: PEnhMetaRecord);
    procedure EmfRestoreDC(Pnt: PEnhMetaRecord);
    procedure EmfSaveDC(Pnt: PEnhMetaRecord);
    procedure EmfScaleViewPortExtEx(Pnt: PEnhMetaRecord);
    procedure EmfScaleWindowExtEx(Pnt: PEnhMetaRecord);
    procedure EmfSetArcDirection(Pnt: PEnhMetaRecord);
    procedure EmfSetBkColor(Pnt: PEnhMetaRecord);
    procedure EmfSetBkMode(Pnt: PEnhMetaRecord);
    procedure EmfSetBrushOrgEx(Pnt: PEnhMetaRecord);
    procedure EmfSetColorAdjustment(Pnt: PEnhMetaRecord);
    procedure EmfSetIcmProfileA(Pnt: PEnhMetaRecord);
    procedure EmfSetIcmMode(Pnt: PEnhMetaRecord);
    procedure EmfSetIcmProfileW(Pnt: PEnhMetaRecord);
    procedure EmfSetLayout(Pnt: PEnhMetaRecord);
    procedure EmfSetLinkedUfis(Pnt: PEnhMetaRecord);
    procedure EmfSetMapMode(Pnt: PEnhMetaRecord);
    procedure EmfSetMapperFlags(Pnt: PEnhMetaRecord);
    procedure EmfSetMiterLimit(Pnt: PEnhMetaRecord);
    procedure EmfSetPolyFillMode(Pnt: PEnhMetaRecord);
    procedure EmfSetRop2(Pnt: PEnhMetaRecord);
    procedure EmfSetStretchBltMode(Pnt: PEnhMetaRecord);
    procedure EmfSetTextAlign(Pnt: PEnhMetaRecord);
    procedure EmfSetTextColor(Pnt: PEnhMetaRecord);
    procedure EmfSetTextJustification(Pnt: PEnhMetaRecord);
    procedure EmfSetViewPortExtEx(Pnt: PEnhMetaRecord);
    procedure EmfSetViewPortOrgEx(Pnt: PEnhMetaRecord);
    procedure EmfSetWindowExtEx(Pnt: PEnhMetaRecord);
    procedure EmfSetWindowOrgEx(Pnt: PEnhMetaRecord);

    // Transformations
    procedure EmfModifyWorldTransform(Pnt: PEnhMetaRecord);
    procedure EmfSetWorldTransform(Pnt: PEnhMetaRecord);

    // Service functions
    procedure SetMapMode(Mode: Integer);
    procedure UpdateXForm;
    function GetTrans: AnsiString;
    procedure SetTrans(Source: AnsiString);
    procedure SelectStockObject(Index: Integer; Handle: Cardinal);
    procedure TextOut(X, Y: Integer; const Text: WideString;
      Offsets: array of Double; HasBounds: Boolean; Scale: Integer = 1);
    function CreateStockFont(FontName: AnsiString; FontBold: Boolean;
      FontItalic: Boolean; Size: Double) : TPDFFont;
    procedure SelectObject(Handle: Integer);
    function GetBitmap(Pnt: PEnhMetaRecord; X, Y, W, H, offBmi, offBits,
      cbBmi, Rop: Integer; CompressJPG: Boolean): TMemoryStream;
    function GetBitmap2(Pnt: PEnhMetaRecord; offBmi, offBits,
      cbBmi: Integer): TBitmap;
    function GetBitmap3(Hatch: Integer): TBitmap;

    procedure SetupWinAnsiCharList;
  public
    RecordCounter: Integer;
    constructor Create(AStructure: TPDFStructure; AFonts: TObjectList;
      ABitmaps: TObjectList; AGSs: TObjectList; APatterns: TObjectList);
    destructor Destroy; override;
    procedure Process(MF: TMetafile; OutStream: TPDFStream);
    property Enhanced: Boolean read FEnhanced write FEnhanced;
    property EmbedFonts: Boolean read FEmbedFonts write FEmbedFonts;
    property CompressFonts: Boolean read FCompressFonts write FCompressFonts;
    property RecompressImages: Boolean read FRecompressImages write FRecompressImages;
    property NoEmbedFontList: AnsiString read FNoEmbedFontList write FNoEmbedFontList;
    property PatternBrushName: AnsiString read FPatternBrushName write FPatternBrushName;
  end;

  TCharData = class
    private
      WC: WideChar;
      LTR: AnsiChar;
      CharIndex: Integer;
      CharWidth: Double;
    public
      constructor Create(WC: WideChar; CharIndex: Integer; CharWidth: Double);
  end;

implementation

uses
  SysUtils, DebenuPDFLibraryFontConst, DebenuPDFLibraryTypes;

const
  WinAnsiCharTable: array[128..255] of Word = (
    $00C4, $00C5, $00C7, $00C9, $00D1, $00D6, $00DC, $00E1,
    $00E0, $00E2, $00E4, $00E3, $00E5, $00E7, $00E9, $00E8,
    $00EA, $00EB, $00ED, $00EC, $00EE, $00EF, $00F1, $00F3,
    $00F2, $00F4, $00F6, $00F5, $00FA, $00F9, $00FB, $00FC,
    $0020, $00A1, $00A2, $00A3, $00A4, $00A5, $00A6, $00A7,
    $00A8, $00A9, $00AA, $00AB, $00AC, $00AD, $00AE, $00AF,
    $00B0, $00B1, $00B2, $00B3, $00B4, $00B5, $00B6, $00B7,
    $00B8, $00B9, $00BA, $00BB, $00BC, $00BD, $00BE, $00BF,
    $00C0, $00C1, $00C2, $00C3, $00C4, $00C5, $00C6, $00C7,
    $00C8, $00C9, $00CA, $00CB, $00CC, $00CD, $00CE, $00CF,
    $00D0, $00D1, $00D2, $00D3, $00D4, $00D5, $00D6, $00D7,
    $00D8, $00D9, $00DA, $00DB, $00DC, $00DD, $00DE, $00DF,
    $00E0, $00E1, $00E2, $00E3, $00E4, $00E5, $00E6, $00E7,
    $00E8, $00E9, $00EA, $00EB, $00EC, $00ED, $00EE, $00EF,
    $00F0, $00F1, $00F2, $00F3, $00F4, $00F5, $00F6, $00F7,
    $00F8, $00F9, $00FA, $00FB, $00FC, $00FD, $00FE, $00FF
  );

{ TPDFMetafile }

// Internal functions
function CalcColor(Color: Cardinal): Integer;
var
 Reserved: Integer;
 Entry: Integer;
begin
  Result := Color and $FFFFFF;
  Reserved := (Color and $FF000000) shr 24;
  if (Reserved = 1) then
  begin
    Entry := (Color and $FF);
    case Entry of
      0: Result := RGB(0, 0, 0);          //    black
      1: Result := RGB(128, 0, 0);        //    dark red
      2: Result := RGB(0, 128, 0);        //    dark green
      3: Result := RGB(128, 128, 0);      //    brown (dark yellow/pea green)
      4: Result := RGB(0, 0, 128);        //    dark blue
      5: Result := RGB(128, 0, 128);      //    dark magenta (lavender)
      6: Result := RGB(0, 128, 128);      //    dark cyan
      7: Result := RGB(192, 192, 192);    //    light grey
      8: Result := RGB(192, 220, 192);    //    pastel green
      9: Result := RGB(166, 202, 240);    //    pastel blue

      10: Result := RGB(255, 251, 240);   //    soft white
      11: Result := RGB(160, 160, 164);   //    medium grey
      12: Result := RGB(128, 128, 128);   //    dark grey
      13: Result := RGB(255, 0, 0);       //    bright red
      14: Result := RGB(0, 255, 0);       //    bright green
      15: Result := RGB(255, 255, 0);     //    yellow
      16: Result := RGB(0, 0, 255);       //    bright blue
      17: Result := RGB(255, 0, 255);     //    magenta
      18: Result := RGB(0, 255, 255);     //    cyan
      19: Result := RGB(255, 255, 255);   //    white

      246: Result := RGB(255, 251, 240);  //    soft white
      247: Result := RGB(160, 160, 164);  //    medium grey
      248: Result := RGB(128, 128, 128);  //    dark grey
      249: Result := RGB(255, 0, 0);      //    bright red
      250: Result := RGB(0, 255, 0);      //    bright green
      251: Result := RGB(255, 255, 0);    //    yellow
      252: Result := RGB(0, 0, 255);      //    bright blue
      253: Result := RGB(255, 0, 255);    //    magenta
      254: Result := RGB(0, 255, 255);    //    cyan
      255: Result := RGB(255, 255, 255);  //    white
    end;
  end;
end;

// http://www.i-logic.com/utilities/trig.htm

// if Angle is outside of 0-360 then put it within 0-360
function FixAngle(Angle:Double):Double;
begin
  while Angle >= 360.0 do
    Angle  :=  Angle - 360.0;
  while Angle < 0 do
    Angle  :=  Angle + 360.0;
  result := Angle;
end;

function CalcAngle(x1,y1,x2,y2:Double):Double;
const
  RADIANS = 57.29577951;
var
  Part1, Part2: Double;
  Angle: Double;
begin
  if (x1 = x2) and (y1 = y2) then
  begin
    result := 0.0;
    Exit;
  end;

  Part1 := Abs(y2 - y1);
  if (Part1 = 0) then
  begin
    Part1 := 0.0000001;
    y1 := y1 + 0.0000001;
  end;

  Part2 := Abs(x2-x1);
  if (Part2 = 0) then
  begin
    Part2 := 0.0000001;
    x1 := x1 + 0.0000001;
  end;

  Angle := ArcTan(Part1 / Part2) * RADIANS;
  if ((x1 > x2) and (y1 < y2)) then
    Angle := 180 - Angle;
  if ((x1 > x2) and (y1 > y2)) then
    Angle := Angle + 180;
  if ((x1 < x2) and (y1 > y2)) then
    Angle := 360 - Angle;
  Angle := FixAngle(Angle);
  Result := Angle;
end;

function SetBWToColor(Bitmap: TBitmap; BColor, WColor: TColor): TBitmap;
var
  X, Y: Integer;
  P: PRGBTriple;
begin
  Bitmap.PixelFormat := pf24bit;
  begin
    for Y := 0 to Bitmap.Height - 1 do
    begin
      P := Bitmap.ScanLine[Y];
      for X := 0 to Bitmap.Width - 1 do
      begin
        if (P^.rgbtRed = 0) and (P^.rgbtGreen = 0) and (P^.rgbtBlue = 0) then
        begin
          P^.rgbtRed := (BColor and $FF);
          P^.rgbtGreen := (BColor and $FF00) shr 8;
          P^.rgbtBlue := (BColor and $FF0000) shr 16;
        end else
        if (P^.rgbtRed = 255) and (P^.rgbtGreen = 255) and (P^.rgbtBlue = 255) then
        begin
          P^.rgbtRed := (WColor and $FF);
          P^.rgbtGreen := (WColor and $FF00) shr 8;
          P^.rgbtBlue := (WColor and $FF0000) shr 16;
        end;
        Inc(P);
      end;
    end;
  end;
  Result := Bitmap;
end;

function InvCol(Color: TColor): TColor;
begin
  Result := $FFFFFF - Color
end;

function ChangeBWColor(Bitmap: TBitmap; ROP: Integer; FillColor: TColor): TBitmap;
begin
  if FillColor = clWhite then FillColor := RGB(254, 255, 255);
  if FillColor = clBlack then FillColor := RGB(1, 0, 0);
  Result := Bitmap;
  case ROP of
    0: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    1: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    2: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    3: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    4: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    5: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    6: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    7: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    8: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    9: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    10: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    11: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    12: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    13: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    14: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    15: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    16: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    17: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    18: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    19: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    20: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    21: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    22: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    23: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    24: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    25: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    26: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    27: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    28: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    29: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    30: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    31: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    32: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    33: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    34: Result := SetBWToColor(Bitmap, clBlack, RGB(1, 0, 0));
    35: Result := SetBWToColor(Bitmap, clWhite, clBlack);
    36: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    37: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    38: Result := SetBWToColor(Bitmap, clBlack, RGB(1, 0, 0));
//   39: Result := SetBWToColor(Bitmap, clBlack, clWhite);
    40: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillCOlor));
    41: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    42: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillCOlor));
    43: Result := SetBWToColor(Bitmap, clWhite, InvCol(FillCOlor));
    44: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    45: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    46: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    47: Result := SetBWToColor(Bitmap, clWhite, InvCol(FillColor));
    48: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    49: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    50: Result := SetBWToColor(Bitmap, clWhite, clBlack);
    51: Result := SetBWToColor(Bitmap, clWhite, clBlack);
    52: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    53: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    54: Result := SetBWToColor(Bitmap, clWhite, clBlack);
    55: Result := SetBWToColor(Bitmap, clWhite, clBlack);
    56: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    57: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    58: Result := SetBWToColor(Bitmap, clWhite, InvCol(FillColor));
    59: Result := SetBWToColor(Bitmap, clWhite, InvCol(FillColor));
    60: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    61: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    62: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    63: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    64: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    65: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    66: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    67: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    68: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    69: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    70: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    71: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    72: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    73: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    74: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    75: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    76: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    77: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    78: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    79: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    80: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    81: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    82: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    83: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    84: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    85: Result := SetBWToColor(Bitmap, clBlack, clBlack);
    86: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    87: Result := SetBWToColor(Bitmap, InvCol(FillColor), clBlack);
    88: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    89: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    90: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    91: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    92: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    93: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    94: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    95: Result := SetBWToColor(Bitmap, InvCol(FillColor), InvCol(FillColor));
    96: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    97: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    98: Result := SetBWToColor(Bitmap, clBlack, RGB(1, 0, 0));
    99: Result := SetBWToColor(Bitmap, clWhite, clBlack);
    100: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    101: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    102: Result := SetBWToColor(Bitmap, clBlack, RGB(1, 0, 0));
    103: Result := SetBWToColor(Bitmap, clWhite, clBlack);
    104: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    105: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    106: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    107: Result := SetBWToColor(Bitmap, clWhite, InvCol(FillColor));
    108: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    109: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    110: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    111: Result := SetBWToColor(Bitmap, clWhite, InvCol(FillColor));
    112: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    113: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    114: Result := SetBWToColor(Bitmap, clWhite, clBlack);
    115: Result := SetBWToColor(Bitmap, clWhite, clBlack);
    116: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    117: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    118: Result := SetBWToColor(Bitmap, clWhite, clBlack);
    119: Result := SetBWToColor(Bitmap, clWhite, clBlack);
    120: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    121: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    122: Result := SetBWToColor(Bitmap, clWhite, InvCol(FillColor));
    123: Result := SetBWToColor(Bitmap, clWhite, InvCol(FillColor));
    124: Result := SetBWToColor(Bitmap, FillCOlor, InvCol(FillColor));
    125: Result := SetBWToColor(Bitmap, FillColor, InvCol(FillColor));
    126: Result := SetBWToColor(Bitmap, clWhite, InvCol(FillColor));
    127: Result := SetBWToColor(Bitmap, clWhite, InvCol(FillColor));
    128: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    129: Result := SetBWToColor(Bitmap, clBlack, InvCol(FillColor));
    130: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    131: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    132: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    133: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    134: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    135: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);

   //136: Result := SetBWToColor(Bitmap, clBlack, clWhite);
   //137: Result := SetBWToColor(Bitmap, clBlack, clWhite);
    136: Result := SetBWToColor(Bitmap, clWhite, ClBlack);  // 9.15B4

    138: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    139: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
//   140: Result := SetBWToColor(Bitmap, clBlack, clWhite);
//   141: Result := SetBWToColor(Bitmap, clBlack, clWhite);
    142: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    143: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    144: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    145: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    146: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    147: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    148: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    149: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    150: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    151: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    152: Result := SetBWToColor(Bitmap, RGB(1, 0, 0), clWhite);
//   153: Result := SetBWToColor(Bitmap, clBlack, clWhite);
    154: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    155: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
//   156: Result := SetBWToColor(Bitmap, clBlack, clWhite);
//   157: Result := SetBWToColor(Bitmap, clBlack, clWhite);
    158: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    159: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    160: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    161: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    162: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    163: Result := SetBWToColor(Bitmap, clWhite, FillColor);
    164: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    165: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    166: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    167: Result := SetBWToColor(Bitmap, clWhite, FillColor);
    168: Result := SetBWToColor(Bitmap, FillColor, clWhite);
    169: Result := SetBWToColor(Bitmap, FillCOlor, clWhite);
//   170: Result := SetBWToColor(Bitmap, clBlack, clWhite);
    171: Result := SetBWToColor(Bitmap, RGB(254, 255, 255), clWhite);
    172: Result := SetBWToColor(Bitmap, FillColor, clWhite);
    173: Result := SetBWToColor(Bitmap, FillColor, clBlack);
    174: Result := SetBWToColor(Bitmap, clBlack, RGB(254, 255, 255));
    175: Result := SetBWToColor(Bitmap, clWhite, clWhite);
    176: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    177: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    178: Result := SetBWToColor(Bitmap, clWhite, FillColor);
    179: Result := SetBWToColor(Bitmap, clWhite, FillCOlor);
    180: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    181: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    182: Result := SetBWToColor(Bitmap, clWhite, FillColor);
    183: Result := SetBWToColor(Bitmap, clWhite, FillColor);
    184: Result := SetBWToColor(Bitmap, FillColor, clWhite);
    185: Result := SetBWToColor(Bitmap, FillColor, clWhite);
    186: Result := SetBWToColor(Bitmap, RGB(254, 255, 255), clWhite);
    187: Result := SetBWToColor(Bitmap, RGB(254, 255, 255), clWhite);
    188: Result := SetBWToColor(Bitmap, FillColor, clWhite);
    189: Result := SetBWToColor(Bitmap, FillColor, clWhite);
    190: Result := SetBWToColor(Bitmap, clWhite, clWhite);
    191: Result := SetBWToColor(Bitmap, clWhite, clWhite);
    192: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    193: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    194: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    195: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    196: Result := SetBWToColor(Bitmap, clBlack, FillCOlor);
    197: Result := SetBWToColor(Bitmap, clBlack, FillCOlor);
    198: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    199: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
//   200: Result := SetBWToColor(Bitmap, clBlack, clWhite);
//   201: Result := SetBWToColor(Bitmap, clBlack, clWhite);
    202: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    203: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
//   204: Result := SetBWToColor(Bitmap, clBlack, clWhite);
//   205: Result := SetBWToColor(Bitmap, clBlack, clWhite);
    206: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    207: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    208: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    209: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    210: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    211: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    212: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    213: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    214: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
    215: Result := SetBWToColor(Bitmap, InvCol(FillColor), FillColor);
//   216: Result := SetBWToColor(Bitmap, clBlack, clWhite);
//   217: Result := SetBWToColor(Bitmap, clBlack, clWhite);
    218: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    219: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
//   220: Result := SetBWToColor(Bitmap, clBlack, clWhite);
//   221: Result := SetBWToColor(Bitmap, clBlack, clWhite);
    222: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    223: Result := SetBWToColor(Bitmap, InvCol(FillColor), clWhite);
    224: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    225: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    226: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    227: Result := SetBWToColor(Bitmap, clWhite, FillColor);
    228: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    229: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    230: Result := SetBWToColor(Bitmap, clBlack, FillColor);
    231: Result := SetBWToColor(Bitmap, clWhite, FillColor);
    232: Result := SetBWToColor(Bitmap, FillColor, clWhite);
    233: Result := SetBWToColor(Bitmap, FillColor, clWhite);
//   234: Result := SetBWToColor(Bitmap, clBlack, clWhite);
    235: Result := SetBWToColor(Bitmap, clWhite, clWhite);
    236: Result := SetBWToColor(Bitmap, FillColor, clWhite);
    237: Result := SetBWToColor(Bitmap, FillColor, clWhite);
//   238: Result := SetBWToColor(Bitmap, clBlack, clWhite);
    239: Result := SetBWToColor(Bitmap, clWhite, clWhite);
    240: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    241: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    242: Result := SetBWToColor(Bitmap, clWhite, FillColor);
    243: Result := SetBWToColor(Bitmap, clWhite, FillColor);
    244: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    245: Result := SetBWToColor(Bitmap, FillColor, FillColor);
    246: Result := SetBWToColor(Bitmap, clWhite, FillColor);
    247: Result := SetBWToColor(Bitmap, clWhite, FillColor);
    248: Result := SetBWToColor(Bitmap, FillColor, clWhite);
    249: Result := SetBWToColor(Bitmap, FillColor, clWhite);
    250: Result := SetBWToColor(Bitmap, clWhite, clWhite);
    251: Result := SetBWToColor(Bitmap, clWhite, clWhite);
    252: Result := SetBWToColor(Bitmap, FillColor, clWhite);
    253: Result := SetBWToColor(Bitmap, FillColor, clWhite);
    254: Result := SetBWToColor(Bitmap, clWhite, clWhite);
    255: Result := SetBWToColor(Bitmap, clWhite, clWhite);
  end;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  TQuickPDFStringList(Data).Add(QPLNativeToAnsi(LogFont.lfFaceName));
  Result := 1;
end;

function EnumEnhFunc(DC: HDC; lpHTable: PHandleTable; lpEMFR: PEnhMetaRecord;
  nObj: Integer; lpData: LParam): Bool; stdcall;
var
  SelectedPMF: TPDFMetafile;
begin
  SelectedPMF := TPDFMetafile(lpData);
  try
    if Assigned(SelectedPMF) then
    begin
      Inc(SelectedPMF.RecordCounter);

      case lpEMFR^.iType of

        // Bitmap records
        EMR_ALPHABLEND:
          SelectedPMF.EmfAlphaBlend(lpEMFR);
        EMR_BITBLT:
          SelectedPMF.EmfBitBLT(lpEMFR);
        EMR_MASKBLT:
          SelectedPMF.EmfMaskBlt(lpEMFR);
        EMR_PLGBLT:
          SelectedPMF.EmfPlgBlt(lpEMFR);
        EMR_SETDIBITSTODEVICE:
          SelectedPMF.EmfSetBitToDevice(lpEMFR);
        EMR_STRETCHBLT:
         SelectedPMF.EmfStretchBlt(lpEMFR);
        EMR_STRETCHDIBITS:
          SelectedPMF.EmfStretchDiBits(lpEMFR);
        EMR_TRANSPARENTBLT:
          SelectedPMF.EmfTransparentblt(lpEMFR);

        // Clipping records
        EMR_EXCLUDECLIPRECT:
          SelectedPMF.EmfExcludeClipRect(lpEMFR);
        EMR_EXTSELECTCLIPRGN:
          SelectedPMF.EmfExtSelectClipRgn(lpEMFR);
        EMR_INTERSECTCLIPRECT:
          SelectedPMF.EmfIntersectClipRect(lpEMFR);
        EMR_OFFSETCLIPRGN:
          SelectedPMF.EmfOffsetClipRgn(lpEMFR);
        EMR_SELECTCLIPPATH:
          SelectedPMF.EmfSelectClipPath(lpEMFR);
        EMR_SETMETARGN:
          SelectedPMF.EmfSetMetaRGN(lpEMFR);

        // Comment records
        EMR_GDICOMMENT:
          SelectedPMF.EmfGdiComment(lpEMFR);

        // Control records
        EMR_HEADER:
        begin
          SelectedPMF.RecordCounter := 0;
          SelectedPMF.ProcessHeader(PEnhMetaHeader(lpEMFR));
        end;

        // EMR_EOF not used

        // Drawing records
        EMR_ANGLEARC:
          SelectedPMF.EmfAngleArc(lpEMFR);
        EMR_ARC:
          SelectedPMF.EmfArc(lpEMFR);
        EMR_ARCTO:
          SelectedPMF.EmfArcTo(lpEMFR);
        EMR_CHORD:
          SelectedPMF.EmfChord(lpEMFR);
        EMR_ELLIPSE:
          SelectedPMF.EmfEllipse(lpEMFR);
        EMR_EXTFLOODFILL:
          SelectedPMF.EmfExtFloodFill(lpEMFR);
        EMR_EXTTEXTOUTA:
          SelectedPMF.EmfExtTextOutA(lpEMFR);
        EMR_EXTTEXTOUTW:
          SelectedPMF.EmfExtTextOutW(lpEMFR);
        EMR_FILLPATH:
          SelectedPMF.EmfFillPath(lpEMFR);
        EMR_FILLRGN:
          SelectedPMF.EmfFillRgn(lpEMFR);
        EMR_FRAMERGN:
          SelectedPMF.EmfFrameRgn(lpEMFR);
        EMR_GRADIENTFILL:
          SelectedPMF.EmfGradientFill(lpEMFR);
        EMR_LINETO:
          SelectedPMF.EmfLineTo(lpEMFR);
        EMR_PAINTRGN:
          SelectedPMF.EmfPaintRgn(lpEMFR);
        EMR_PIE:
          SelectedPMF.EmfPie(lpEMFR);
        EMR_POLYBEZIER:
          SelectedPMF.EmfPolyBezier(lpEMFR);
        EMR_POLYBEZIER16:
          SelectedPMF.EmfPolyBezier16(lpEMFR);
        EMR_POLYBEZIERTO16:
          SelectedPMF.EmfPolyBezierTo16(lpEMFR);
        EMR_POLYBEZIERTO:
         SelectedPMF.EmfPolyBezierTo(lpEMFR);
        EMR_POLYDRAW:
          SelectedPMF.EmfPolyDraw(lpEMFR);
        EMR_POLYDRAW16:
          SelectedPMF.EmfPolyDraw16(lpEMFR);
        EMR_POLYGON:
          SelectedPMF.EmfPolygon(lpEMFR);
        EMR_POLYGON16:
          SelectedPMF.EmfPolygon16(lpEMFR);
        EMR_POLYLINE:
          SelectedPMF.EmfPolyLine(lpEMFR);
        EMR_POLYLINE16:
          SelectedPMF.EmfPolyLine16(lpEMFR);
        EMR_POLYLINETO:
          SelectedPMF.EmfPolyLineTo(lpEMFR);
        EMR_POLYLINETO16:
          SelectedPMF.EmfPolyLineTo16(lpEMFR);
        EMR_POLYPOLYGON:
          SelectedPMF.EmfPolyPolygon(lpEMFR);
        EMR_POLYPOLYLINE:
          SelectedPMF.EmfPolyPolyLine(lpEMFR);
        EMR_POLYPOLYLINE16:
          SelectedPMF.EmfPolyPolyLine16(lpEMFR);
        EMR_POLYTEXTOUTA:
          SelectedPMF.EmfPolyTextOutA(lpEMFR);
        EMR_POLYTEXTOUTW:
          SelectedPMF.EmfPolyTextOutW(lpEMFR);
        EMR_RECTANGLE:
          SelectedPMF.EmfRectangle(lpEMFR);
        EMR_ROUNDRECT:
          SelectedPMF.EmfRoundRect(lpEMFR);
        EMR_SETPIXELV:
          SelectedPMF.EmfSetPixelV(lpEMFR);
        EMR_SMALLTEXTOUT:
          SelectedPMF.EmfSmallTextOut(lpEMFR);
        EMR_STROKEANDFILLPATH:
          SelectedPMF.EmfStrokeAndFillPath(lpEMFR);
        EMR_STROKEPATH:
          SelectedPMF.EmfStrokePath(lpEMFR);
        EMR_POLYPOLYGON16:
          SelectedPMF.EmfPolyPolygon16(lpEMFR);

        // Escape records
        EMR_DRAWESCAPE:
          SelectedPMF.EmfDrawEscape(lpEMFR);
        EMR_EXTESCAPE:
          SelectedPMF.EmfExtEscape(lpEMFR);
        EMR_NAMEDESCAPE:
          SelectedPMF.EmfNamedEscape(lpEMFR);

        // Object creation records
        EMR_CREATEBRUSHINDIRECT:
          SelectedPMF.EmfCreateBrushIndirect(lpEMFR);
        EMR_CREATECOLORSPACE:
          SelectedPMF.EmfCreateColorSpace(lpEMFR);
        122: // 122 = EMR_CREATECOLORSPACEW
          SelectedPMF.EmfCreateColorSpaceW(lpEMFR);
        EMR_CREATEDIBPATTERNBRUSHPT:
          SelectedPMF.EmfCreateDibPatternBrushPT(lpEMFR);
        EMR_CREATEMONOBRUSH:
          SelectedPMF.EmfCreateMonoBrush(lpEMFR);
        EMR_CREATEPALETTE:
          SelectedPMF.EmfCreatePalette(lpEMFR);
        EMR_CREATEPEN:
          SelectedPMF.EmfCreatePen(lpEMFR);
        EMR_EXTCREATEFONTINDIRECTW:
          SelectedPMF.EmfExtCreateFontIndirectW(lpEMFR);
        EMR_EXTCREATEPEN:
          SelectedPMF.EmfExtCreatePen(lpEMFR);

        // Object manipulation records
        EMR_COLORCORRECTPALETTE:
          SelectedPMF.EmfColorCorrectPalette(lpEMFR);
        EMR_DELETECOLORSPACE:
          SelectedPMF.EmfDeleteColorSpace(lpEMFR);
        EMR_DELETEOBJECT:
          SelectedPMF.EmfDeleteObject(lpEMFR);
        EMR_RESIZEPALETTE:
          SelectedPMF.EmfResizePalette(lpEMFR);
        EMR_SELECTOBJECT:
          SelectedPMF.EmfSelectObject(lpEMFR);
        EMR_SELECTPALETTE:
          SelectedPMF.EmfSelectPalette(lpEMFR);
        EMR_SETCOLORSPACE:
          SelectedPMF.EmfSetColorSpace(lpEMFR);
        EMR_SETPALETTEENTRIES:
          SelectedPMF.EmfSetPaletteEntries(lpEMFR);

        // OpenGL records
        EMR_GLSBOUNDEDRECORD:
          SelectedPMF.EmfGlsBoundedRecord(lpEMFR);
        EMR_GLSRECORD:
          SelectedPMF.EmfGlsRecord(lpEMFR);

        // Path records
        EMR_ABORTPATH:
          SelectedPMF.EmfAbortPath(lpEMFR);
        EMR_BEGINPATH:
          SelectedPMF.EmfBeginPath(lpEMFR);
        EMR_CLOSEFIGURE:
          SelectedPMF.EmfClosePath(lpEMFR);
        EMR_ENDPATH:
          SelectedPMF.EmfEndPath(lpEMFR);
        EMR_FLATTENPATH:
          SelectedPMF.EmfFlattenPath(lpEMFR);
        EMR_WIDENPATH:
          SelectedPMF.EmfWidenPath(lpEMFR);

        // State records
        121: // EMR_COLORMATCHTOTARGETW
          SelectedPMF.EmfColorMatchToTargetW(lpEMFR);
        EMR_FORCEUFIMAPPING:
          SelectedPMF.EmfForceUfiMapping(lpEMFR);
        EMR_INVERTRGN:
          SelectedPMF.EmfInvertRgn(lpEMFR);
        EMR_MOVETOEX:
          SelectedPMF.EmfMoveToEx(lpEMFR);
        EMR_PIXELFORMAT:
          SelectedPMF.EmfPixelFormat(lpEMFR);
        EMR_REALIZEPALETTE:
          SelectedPMF.EmfRealizePalette(lpEMFR);
        EMR_RESTOREDC:
          SelectedPMF.EmfRestoreDC(lpEMFR);
        EMR_SAVEDC:
          SelectedPMF.EmfSaveDC(lpEMFR);
        EMR_SCALEVIEWPORTEXTEX:
          SelectedPMF.EmfScaleViewPortExtEx(lpEMFR);
        EMR_SCALEWINDOWEXTEX:
          SelectedPMF.EmfScaleWindowExtEx(lpEMFR);
        EMR_SETARCDIRECTION:
          SelectedPMF.EmfSetArcDirection(lpEMFR);
        EMR_SETBKCOLOR:
          SelectedPMF.EmfSetBkColor(lpEMFR);
        EMR_SETBKMODE:
          SelectedPMF.EmfSetBkMode(lpEMFR);
        EMR_SETBRUSHORGEX:
          SelectedPMF.EmfSetBrushOrgEx(lpEMFR);
        EMR_SETCOLORADJUSTMENT:
          SelectedPMF.EmfSetColorAdjustment(lpEMFR);
        EMR_SETICMMODE:
          SelectedPMF.EmfSetIcmMode(lpEMFR);
        EMR_SETICMPROFILEA:
          SelectedPMF.EmfSetIcmProfileA(lpEMFR);
        EMR_SETICMPROFILEW:
          SelectedPMF.EmfSetIcmProfileW(lpEMFR);
        115: // EMR_SETLAYOUT
          SelectedPMF.EmfSetLayout(lpEMFR);
        EMR_SETLINKEDUFIS:
          SelectedPMF.EmfSetLinkedUfis(lpEMFR);
        EMR_SETMAPMODE:
          SelectedPMF.EmfSetMapMode(lpEMFR);
        EMR_SETMAPPERFLAGS:
          SelectedPMF.EmfSetMapperFlags(lpEMFR);
        EMR_SETMITERLIMIT:
          SelectedPMF.EmfSetMiterLimit(lpEMFR);
        EMR_SETPOLYFILLMODE:
          SelectedPMF.EmfSetPolyFillMode(lpEMFR);
        EMR_SETROP2:
          SelectedPMF.EmfSetRop2(lpEMFR);
        EMR_SETSTRETCHBLTMODE:
          SelectedPMF.EmfSetStretchBltMode(lpEMFR);
        EMR_SETTEXTALIGN:
          SelectedPMF.EmfSetTextAlign(lpEMFR);
        EMR_SETTEXTCOLOR:
          SelectedPMF.EmfSetTextColor(lpEMFR);
        EMR_SETTEXTJUSTIFICATION:
          SelectedPMF.EmfSetTextJustification(lpEMFR);
        EMR_SETVIEWPORTEXTEX:
          SelectedPMF.EmfSetViewPortExtEx(lpEMFR);
        EMR_SETVIEWPORTORGEX:
          SelectedPMF.EmfSetViewPortOrgEx(lpEMFR);
        EMR_SETWINDOWEXTEX:
          SelectedPMF.EmfSetWindowExtEx(lpEMFR);
        EMR_SETWINDOWORGEX:
          SelectedPMF.EmfSetWindowOrgEx(lpEMFR);

        // Transformation records
        EMR_MODIFYWORLDTRANSFORM:
          SelectedPMF.EmfModifyWorldTransform(lpEMFR);
        EMR_SETWORLDTRANSFORM:
          SelectedPMF.EmfSetWorldTransform(lpEMFR);
      end;
      Result := True;
    end else
    begin
      Result := False;
    end;
  except
    Result := True;
  end;
end;

// Bitmap records
procedure TPDFMetafile.EmfAlphaBlend(Pnt: PEnhMetaRecord);
var
  PEnhAlphaBlend: PEMRAlphaBlend;
  X1, Y1, W1, H1, X2, Y2, W2, H2: Integer;
  ImgName: AnsiString;
  Img: TPDFImage;
  MS: TMemoryStream;
  offBmi: Integer;
  offBits: Integer;
  cbBmi: Integer;
  Rop: Integer;
  Alpha: Double;
  GSName: AnsiString;
  GSIndRef: TPDFIndRef;
  TransDict: TPDFDictionary;
  ObjNum, GenNum: Integer;
  GState: TEMFGraphicState;
  X: Integer;
  GSFound: Boolean;
begin
  PEnhAlphaBlend := PEMRAlphaBlend(Pnt);
  X1 := PEnhAlphaBlend.xDest;
  Y1 := PEnhAlphaBlend.yDest;
  W1 := PEnhAlphaBlend.cxDest;
  H1 := PEnhAlphaBlend.cyDest;
  X2 := PEnhAlphaBlend.xSrc;
  Y2 := PEnhAlphaBlend.ySrc;
  W2 := PEnhAlphaBlend.cxSrc;
  H2 := PEnhAlphaBlend.cySrc;
  offBmi := Integer(PEnhAlphaBlend.offBmiSrc);
  offBits := Integer(PEnhAlphaBlend.offBitsSrc);
  cbBmi := Integer(PEnhAlphaBlend.cbBmiSrc);
  if cbBmi > 1064 then cbBmi := 1064;

  Rop := PEnhAlphaBlend.dwRop;
  Alpha := (Rop and $FF0000) shr 16;
  Alpha := Alpha / 255;

  FPainter.SaveState;
  GSFound := False;
  for X := 0 to FIncludedGS.Count - 1 do
  begin
    GState := TEMFGraphicState(FIncludedGS[X]);
    if (GState.FuncName = 'AlphaBlend') and (GState.Transparency = Alpha) then
    begin
      GSFound := True;
      GSName := GState.GSName;
    end;
  end;

  if not GSFound then
  begin
    GSName := 'QuickPDFGS' + QPLRandomID;
    TransDict := FStructure.NewDictionary;
    TransDict.Add('Type', FStructure.NewName('ExtGState'));
    TransDict.Add('SMask', FStructure.NewName('None'));
    TransDict.Add('ca', FStructure.NewNumeric(Alpha));
    TransDict.Add('CA', FStructure.NewNumeric(Alpha));
    if Assigned(FStructure.OnNewIndObj) then
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, TransDict);
    GSIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    GState := TEMFGraphicState.Create;
    GState.GSName := GSName;
    GState.Transparency := Alpha;
    GState.GS := GSIndRef;
    GState.FuncName := 'AlphaBlend';
    FIncludedGS.Add(GState);
  end;
  FPainter.SetGS(GSName);

  MS := GetBitmap(Pnt, X2, Y2, W2, H2, offBmi, offBits, cbBmi, Rop, False);
  if not Assigned(MS) then
  begin
    FPainter.Rectangle(Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1), True, False);
  end else
  begin
    ImgName := 'QuickPDFI' + QPLRandomID;
    Img := TPDFImage.Create(FStructure, ImgName, FIncludedFonts);
    Img.Compress := 1;
    Img.RecompressImage := True;
    Img.EMFImageType := 1;  // EMF without Mask

    if Img.NewImageFromStream(MS, 0) then
    begin
      FIncludedBitmaps.Add(Img);
      FPainter.DrawImage(Img, Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1));
    end;
    MS.Free;
  end;
  FPainter.LoadState;
end;

procedure TPDFMetafile.EmfBitBLT(Pnt: PEnhMetaRecord);
var
  PEnhBitBLT: PEMRBitBLT;
  X1, Y1, W1, H1, X2, Y2, W2, H2: Integer;
  ImgName: AnsiString;
  Img: TPDFImage;
  MS: TMemoryStream;
  offBmi: Integer;
  offBits: Integer;
  cbBmi: Integer;
  Rop: Integer;
begin
  PEnhBitBLT := PEMRBitBLT(Pnt);
  X1 := PEnhBitBLT.xDest;
  Y1 := PEnhBitBLT.yDest;
  W1 := PEnhBitBLT.cxDest;
  H1 := PEnhBitBLT.cyDest;
  X2 := PEnhBitBLT.xSrc;
  Y2 := PEnhBitBLT.ySrc;
  W2 := W1;
  H2 := H1;
  offBmi := Integer(PEnhBitBLT.offBmiSrc);
  offBits := Integer(PEnhBitBLT.offBitsSrc);
  cbBmi := Integer(PEnhBitBLT.cbBmiSrc);
  if cbBmi > 1064 then cbBmi := 1064;

  if (PEnhBitBlt.dwRop = PATINVERT) then
    exit;

  Rop := (PEnhBitBlt.dwRop and $FF0000) shr 16;

  MS := GetBitmap(Pnt, X2, Y2, W2, H2, offBmi, offBits, cbBmi, Rop, False);
  if not Assigned(MS) then
  begin
    if FFillColor = clWhite then
    begin
      case Rop of
        136, 137, 138, 139, 152, 153, 154, 155, 166, 168, 169, 171, 184, 185,
        186, 187, 170:
        begin
          // White is transparent, don't draw anything
        end;
      else
        if (FHasFill) then
        begin
          FPainter.SetFillColor((FFillColor and $FF) / 255,
                               ((FFillColor and $FF00) shr 8) / 255,
                               ((FFillColor and $FF0000) shr 16) / 255);

          FPainter.Rectangle(Sx(X1,Y1), Sy(X1,Y1), Sw(W1), Sh(H1), True, False);

          FPainter.SetFillColor((FBkColor and $FF) / 255,
                               ((FBkColor and $FF00) shr 8) / 255,
                               ((FBkColor and $FF0000) shr 16) / 255);
        end;
      end;
    end else
    if FFillColor = clBlack then
    begin
      case Rop of
        34, 38, 42, 46, 90, 98, 102, 106, 110, 145, 162, 174, 226, 230, 234,
        238, 170:
        begin
          // Black is transparent, don't draw anything
        end;
      else
        if (FHasFill) then
        begin
          FPainter.SetFillColor((FFillColor and $FF) / 255,
                               ((FFillColor and $FF00) shr 8) / 255,
                               ((FFillColor and $FF0000) shr 16) / 255);

          FPainter.Rectangle(Sx(X1,Y1), Sy(X1,Y1), Sw(W1), Sh(H1), True, False);

          FPainter.SetFillColor((FBkColor and $FF) / 255,
                               ((FBkColor and $FF00) shr 8) / 255,
                               ((FBkColor and $FF0000) shr 16) / 255);
        end;
      end;
    end else
    begin
      FPainter.Rectangle(Sx(X1, Y1), Sy(X1, Y1),
        Sw(W1), Sh(H1), True, False);
    end;
  end else
  begin
    ImgName := 'QuickPDFI' + QPLRandomID;
    Img := TPDFImage.Create(FStructure, ImgName, FIncludedFonts);
    Img.Compress := 1;
    Img.RecompressImage := True;
    Img.EMFImageType := 2;  // EMF without Mask

    if Img.NewImageFromStream(MS, 0) then
    begin
      {
      case Rop of
        34, 38, 42, 46, 98, 102, 106, 110, 145, 162, 174, 226, 230, 234, 238:
        begin
          // Black is transparent
          Img.SetImageMask(0, 0, 0, 0, 0, 0);
        end;
        136, 137, 138, 139, 152, 153, 154, 155, 166, 168, 169, 171, 184, 185,
        186, 187:
        begin
          // White is transparent
          Img.SetImageMask(1, 1, 1, 1, 1, 1);
        end;
        170:
        begin
          // White and black are transparent
          Img.SetImageMask(0, 0, 0, 1, 1, 1);
        end;
      end;
      }
      FIncludedBitmaps.Add(Img);
      FPainter.DrawImage(Img, Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1));
    end;
    MS.Free;
  end;
end;

procedure TPDFMetafile.EmfMaskBlt(Pnt: PEnhMetaRecord);
var
  PEnhMaskBlt: PEMRMaskBlt;
  PBitsMem: Pointer;
  PrsBitmapInfo: PersBitmapInfo;
  PBitmapInfo: Pointer;
  Bitmap: TBitmap;
  DC: HDC;
  TmpDC: HDC;
  X1, Y1, W1, H1, X2, Y2, W2, H2: Integer;
  offBmi: Integer;
  offBits: Integer;
  cbBmi: Integer;
  ImgName: AnsiString;
  Img: TPDFImage;
  ImgMsk: TPDFImage;
  MS: TMemoryStream;
  MSMsk: TMemoryStream;
  Rop: Integer;
begin
  PEnhMaskBlt := PEMRMaskBlt(Pnt);
  X1 := PEnhMaskBlt.xDest;
  Y1 := PEnhMaskBlt.yDest;
  W1 := PEnhMaskBlt.cxDest;
  H1 := PEnhMaskBlt.cyDest;
  X2 := PEnhMaskBlt.xSrc;
  Y2 := PEnhMaskBlt.ySrc;
  W2 := W1;
  H2 := W2;
  offBmi := Integer(PEnhMaskBlt.offBmiSrc);
  offBits := Integer(PEnhMaskBlt.offBitsSrc);
  cbBmi := Integer(PEnhMaskBlt.cbBmiSrc);
  if cbBmi > 1064 then cbBmi := 1064;
  //Rop := PEnhMaskBlt.dwRop;
  Rop := (PEnhMaskBlt.dwRop and $FF0000) shr 16;
  MS := GetBitmap(Pnt, X2, Y2, W2, H2, offBmi, offBits, cbBmi, Rop, False);
  if not Assigned(MS) then
  begin
    FPainter.Rectangle(Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1), True, False);
  end else
  begin
    ImgName := 'QuickPDFI' + QPLRandomID;
    Img := TPDFImage.Create(FStructure, ImgName, FIncludedFonts);
    Img.Compress := 1;
    Img.RecompressImage := True;
    Img.EMFImageType := 2;  // EMF with Mask

    if Img.NewImageFromStream(MS, 0) then
    begin
      FIncludedBitmaps.Add(Img);

      // Now extract the mask
      PBitmapInfo := Pointer(Integer(Pnt) + Integer(PEnhMaskBlt.offBmiMask));
      Move(PBitmapInfo^, PrsBitmapInfo, Integer(PEnhMaskBlt.cbBmiMask));
      PBitsMem := Pointer(Integer(Pnt) + Integer(PEnhMaskBlt.offBitsMask));
      TmpDC := CreateDC('Display', nil, nil, nil);
      DC := CreateDIBitmap(TmpDC, PrsBitmapInfo.BitmapInfo.bmiHeader,
        CBM_INIT, PBitsMem, PrsBitmapInfo.BitmapInfo, DIB_RGB_COLORS);
      DeleteDC(TmpDC);
      if (DC <> 0) and (PrsBitmapInfo.BitmapInfo.bmiHeader.biBitCount * PrsBitmapInfo.BitmapInfo.bmiHeader.biPlanes = 1)
      then
      begin
        MSMsk := TMemoryStream.Create;
        try
          Bitmap := TBitmap.Create;
          try
            Bitmap.Handle := DC;

            case PrsBitmapInfo.BitmapInfo.bmiHeader.biBitCount * PrsBitmapInfo.BitmapInfo.bmiHeader.biPlanes of
              1:  Bitmap.PixelFormat := pf1Bit;
              8:  Bitmap.PixelFormat := pf8Bit;
              //24: Bitmap.PixelFormat := pf24Bit;  // Not supportted in PDF masking
              //32: Bitmap.PixelFormat := pf8Bit;   // Not supportted in PDF masking
            end;

            Bitmap.Canvas.Lock;
            Bitmap.SaveToStream(MSMsk);
          finally
            Bitmap.Free;
          end;
          ImgName := 'QuickPDFI' + QPLRandomID;
          ImgMsk := TPDFImage.Create(FStructure, ImgName, FIncludedFonts);
          ImgMsk.Compress := 1;
          ImgMsk.RecompressImage := True;
          ImgMsk.EMFImageType := 1;  // EMF without Mask

          if ImgMsk.NewImageFromStream(MSMsk, 0) then
          begin
            FIncludedBitmaps.Add(ImgMsk);
            Img.SetImageMaskFromImage(ImgMsk.IndRef.ObjNum, ImgMsk.IndRef.GenNum, mtSoftMask);
          end;
        finally
          MSMsk.free;
        end;
      end;

      FPainter.DrawImage(Img, Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1));
    end;
    MS.free;
  end;
end;

procedure TPDFMetafile.EmfPlgBlt(Pnt: PEnhMetaRecord);
var
  PEnhPlgBlt: PEMRPlgBlt;
  PBitsMem: Pointer;
  PrsBitmapInfo: PersBitmapInfo;
  PBitmapInfo: Pointer;
  Bitmap: TBitmap;
  DC: HDC;
  TmpDC: HDC;
  X1, Y1, W1, H1, X2, Y2, W2, H2: Integer;
  P1, P2, P3: TPoint;
  ImgName: AnsiString;
  Img: TPDFImage;
  MS: TMemoryStream;
  offBmi: Integer;
  offBits: Integer;
  cbBmi: Integer;
  ImgMsk: TPDFImage;
  MSMsk: TMemoryStream;
  Rop: Integer;
  ShearX, ShearY: Double;
begin
  PEnhPlgBlt := PEMRPlgBlt(Pnt);
  X2 := PEnhPlgBlt.xSrc;
  Y2 := PEnhPlgBlt.ySrc;
  W2 := PEnhPlgBlt.cxSrc;
  H2 := PEnhPlgBlt.cySrc;

  P1.X := PEnhPlgBlt.aptlDest[0].X;
  P1.Y := PEnhPlgBlt.aptlDest[0].Y;
  P2.X := PEnhPlgBlt.aptlDest[1].X;
  P2.Y := PEnhPlgBlt.aptlDest[1].Y;
  P3.X := PEnhPlgBlt.aptlDest[2].X;
  P3.Y := PEnhPlgBlt.aptlDest[2].Y;
  X1 := Min(P1.X, P3.X);
  Y1 := Max(P1.Y, P2.Y);
  W1 := Round(Sqrt(Sqr(P2.X - P1.X) + Sqr(P2.Y - P1.Y)));
  H1 := Round(Sqrt(Sqr(P3.X - P1.X) + Sqr(P3.Y - P1.Y)));
  if (P2.x - P1.x) <> 0 then
  begin
    ShearX := (P2.y - P1.y) / (P2.x - P1.x);
  end else
  begin
    ShearX := 0;
  end;
  if (P3.x - P1.x) <> 0 then
  begin
    ShearY := (P3.x - P1.x) / (P3.y - P1.y);
  end else
  begin
    ShearY := 0;
  end;
  offBmi := Integer(PEnhPlgBlt.offBmiSrc);
  offBits := Integer(PEnhPlgBlt.offBitsSrc);
  cbBmi := Integer(PEnhPlgBlt.cbBmiSrc);
  if cbBmi > 1064 then cbBmi := 1064;
  Rop := -1;
  MS := GetBitmap(Pnt, X2, Y2, W2, H2, offBmi, offBits, cbBmi, Rop, False);
  if not Assigned(MS) then
  begin
    FPainter.Rectangle(Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1), True, False);
  end else
  begin
    ImgName := 'QuickPDFI' + QPLRandomID;
    Img := TPDFImage.Create(FStructure, ImgName, FIncludedFonts);
    Img.Compress := 1;
    Img.EMFImageType := 2;  // EMF with Mask

    if Img.NewImageFromStream(MS, 0) then
    begin
      FIncludedBitmaps.Add(Img);
      // Now extract the mask
      if PEnhPlgBlt.offBmiMask <> 0 then
      begin
        PBitmapInfo := Pointer(Integer(Pnt) + Integer(PEnhPlgBlt.offBmiMask));
        Move(PBitmapInfo^, PrsBitmapInfo, Integer(PEnhPlgBlt.cbBmiMask));
        PBitsMem := Pointer(Integer(Pnt) + Integer(PEnhPlgBlt.offBitsMask));
        TmpDC := CreateDC('Display', nil, nil, nil);
        DC := CreateDIBitmap(TmpDC, PrsBitmapInfo.BitmapInfo.bmiHeader,
          CBM_INIT, PBitsMem, PrsBitmapInfo.BitmapInfo, DIB_RGB_COLORS);
        DeleteDC(TmpDC);
        if DC <> 0 then
        begin
          MSMsk := TMemoryStream.Create;
          try
            Bitmap := TBitmap.Create;
            try
              Bitmap.Handle := DC;
              Bitmap.Canvas.Lock;
              Bitmap.SaveToStream(MSMsk);
            finally
              Bitmap.Free;
            end;
            ImgName := 'QuickPDFI' + QPLRandomID;
            ImgMsk := TPDFImage.Create(FStructure, ImgName, FIncludedFonts);
            ImgMsk.Compress := 1;
            ImgMsk.EMFImageType := 1;  // EMF with Mask  // ADC
            if ImgMsk.NewImageFromStream(MSMsk, 0) then
            begin
                FIncludedBitmaps.Add(ImgMsk);
                Img.SetImageMaskFromImage(ImgMsk.IndRef.ObjNum,
                  ImgMsk.IndRef.GenNum, mtSoftMask);
            end;
          finally
            MSMsk.free;
          end;
        end;
      end;
      FPainter.DrawShearedImage(Img, Sx(P3.X, P3.Y), Sy(P1.X, P1.Y), Sw(W1),
        Sh(H1), ShearX, ShearY);
      MS.free;
    end;
  end;
end;

procedure TPDFMetafile.EmfSetBitToDevice(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfStretchBLT(Pnt: PEnhMetaRecord);
var
  PEnhStrecthBlt: PEMRStretchBLT;
  X1, Y1, W1, H1, X2, Y2, W2, H2: Integer;
  ImgName: AnsiString;
  Img: TPDFImage;
  MS: TMemoryStream;
  offBmi: Integer;
  offBits: Integer;
  cbBmi: Integer;
  Rop: Integer;

  function XFormSx(X, Y: Integer): Double;
  begin
    Result := X * PEnhStrecthBlt.xformSrc.eM11 + Y * PEnhStrecthBlt.xformSrc.eM21 + PEnhStrecthBlt.xformSrc.eDx;
  end;

  function XFormSy(X, Y: Integer): Double;
  begin
    Result := X * PEnhStrecthBlt.xformSrc.eM12 + Y * PEnhStrecthBlt.xformSrc.eM22 + PEnhStrecthBlt.xformSrc.eDy;
  end;

  function XFormSw(X: Integer): Double;
  begin
    Result := X * PEnhStrecthBlt.xformSrc.eM11;
  end;

  function XFormSh(Y: Integer): Double;
  begin
    Result := Y * PEnhStrecthBlt.xformSrc.eM22;
  end;

begin
  PEnhStrecthBlt := PEMRStretchBlt(Pnt);
  X1 := PEnhStrecthBlt.xDest;
  Y1 := PEnhStrecthBlt.yDest;
  W1 := PEnhStrecthBlt.cxDest;
  H1 := PEnhStrecthBlt.cyDest;
  X2 := PEnhStrecthBlt.xSrc;
  Y2 := PEnhStrecthBlt.ySrc;
  W2 := PEnhStrecthBlt.cxSrc;
  H2 := PEnhStrecthBlt.cySrc;

  if (PEnhStrecthBlt.xformSrc.eM11 <> 0) and (PEnhStrecthBlt.xformSrc.eM22 <> 0) then
  begin
    X2 := Round(XFormSx(PEnhStrecthBlt.xSrc, PEnhStrecthBlt.ySrc));
    Y2 := Round(XFormSy(PEnhStrecthBlt.xSrc, PEnhStrecthBlt.ySrc));
    W2 := Round(XFormSw(W2));
    H2 := Round(XFormSh(H2));
  end;

  offBmi := Integer(PEnhStrecthBlt.offBmiSrc);
  offBits := Integer(PEnhStrecthBlt.offBitsSrc);
  cbBmi := Integer(PEnhStrecthBlt.cbBmiSrc);
  if cbBmi > 1064 then cbBmi := 1064;
  Rop := PEnhStrecthBlt.dwRop;
  Rop := (Rop and $FF0000) shr 16;
  MS := GetBitmap(Pnt, X2, Y2, W2 + 1, H2 + 1, offBmi, offBits, cbBmi, Rop, False);
  if not Assigned(MS) then
  begin
    if FFillColor = clWhite then
    begin
      case Rop of
        136, 137, 138, 139, 152, 153, 154, 155, 166, 168, 169, 171, 184, 185,
        186, 187, 170:
        begin
          // White is transparent, don't draw anything
        end;
      else
        FPainter.Rectangle(Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1), True, False);
      end;
    end else
    if FFillColor = clBlack then
    begin
      case Rop of
        34, 38, 42, 46, 98, 102, 106, 110, 145, 162, 174, 226, 230, 234,
        238, 170:
        begin
          // Black is transparent, don't draw anything
        end;
      else
        FPainter.Rectangle(Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1), True, False);
      end;
    end else
    begin
      FPainter.Rectangle(Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1), True, False);
    end;
  end else
  begin
    ImgName := 'QuickPDFI' + QPLRandomID;
    Img := TPDFImage.Create(FStructure, ImgName, FIncludedFonts);
    Img.Compress := 1;
    Img.RecompressImage := True;
    Img.EMFImageType := 2;  // EMF with Mask

    if Img.NewImageFromStream(MS, 0) then
    begin
      case Rop of
        34, 38, 42, 46, 98, 102, 106, 110, 145, 162, 174, 226, 230, 234, 238:
          //black is transparent
          Img.SetImageMask(0, 0, 0, 0, 0, 0);
        136, 137, 138, 139, 152, 153, 154, 155, 166, 168, 169, 171, 184, 185,
        186, 187:
          //white is transparent
          Img.SetImageMask(1, 1, 1, 1, 1, 1);
        170:
          //white & black transparent
          Img.SetImageMask(0, 0, 0, 1, 1, 1);
      end;
      FIncludedBitmaps.Add(Img);
      FPainter.DrawImage(Img, Sx(X1 + 1, Y1 + 1), Sy(X1 + 1, Y1 + 1), Sw(W1 + 1) , Sh(H1 + 1));
    end;
    MS.Free;
  end;
end;

procedure TPDFMetafile.EmfStretchDiBits(Pnt: PEnhMetaRecord);
var
  PEnhStrecthDiBits: PEMRStretchDiBits;
  X1, Y1, W1, H1, X2, Y2, W2, H2: Integer;
  offBmi: Integer;
  offBits: Integer;
  cbBmi: Integer;
  Rop: Integer;
  ImgName: AnsiString;
  Img: TPDFImage;
  MS: TMemoryStream;
begin
  PEnhStrecthDiBits := PEMRStretchDiBits(Pnt);
  X1 := PEnhStrecthDiBits.xDest;
  Y1 := PEnhStrecthDiBits.yDest;
  W1 := PEnhStrecthDiBits.cxDest;
  H1 := PEnhStrecthDiBits.cyDest;
  X2 := PEnhStrecthDiBits.xSrc;
  Y2 := PEnhStrecthDiBits.ySrc;
  W2 := PEnhStrecthDiBits.cxSrc;
  H2 := PEnhStrecthDiBits.cySrc;
  offBmi := Integer(PEnhStrecthDiBits.offBmiSrc);
  offBits := Integer(PEnhStrecthDiBits.offBitsSrc);
  cbBmi := Integer(PEnhStrecthDiBits.cbBmiSrc);
  if cbBmi > 1064 then cbBmi := 1064;
  Rop := (PEnhStrecthDiBits.dwRop and $FF0000) shr 16;

  MS := GetBitmap(Pnt, X2, Y2, W2, H2, offBmi, offBits, cbBmi, Rop, False);
  if not Assigned(MS) then
  begin
    if FFillColor = clWhite then
    begin
      case Rop of
        136, 137, 138, 139, 152, 153, 154, 155, 166, 168, 169, 171, 184, 185,
        186, 187, 170, 90, 238:
        begin
          // White is transparent, don't draw anything
        end;
      else
        FPainter.Rectangle(Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1), True, False);
      end;
    end else
    if FFillColor = clBlack then
    begin
      case Rop of
        34, 38, 42, 46, 98, 102, 106, 110, 145, 162, 174, 226, 230, 234,
        238, 170:
        begin
          // black is transparent, don't draw anything
        end;
      else
        FPainter.Rectangle(Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1), True, False);
      end;
    end else
    begin
      FPainter.Rectangle(Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1), True, False);
    end;
  end else
  begin
    ImgName := 'QuickPDFI' + QPLRandomID;
    Img := TPDFImage.Create(FStructure, ImgName, FIncludedFonts);
    Img.Compress := 1;
    Img.RecompressImage := True;
    Img.EMFImageType := 1;  // EMF without Mask

    if Img.NewImageFromStream(MS, 0) then
    begin  // ADC Readded 11/4/14
      {
      case Rop of
        34, 38, 42, 46, 98, 102, 106, 110, 145, 162, 174, 226, 230, 234, 238:
          // black is transparent
          Img.SetImageMask(0, 0, 0, 0, 0, 0);
        136, 137, 138, 139, 152, 153, 154, 155, 166, 168, 169, 171, 184, 185,
        186, 187:
          // white is transparent
          Img.SetImageMask(1, 1, 1, 1, 1, 1);
        170:
          // white & black transparent
          Img.SetImageMask(0, 0, 0, 1, 1, 1);
      end;
      }
      FIncludedBitmaps.Add(Img);
      FPainter.DrawImage(Img, Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1));
    end;
    MS.Free;
  end;
end;

procedure TPDFMetafile.EmfTransparentBlt(Pnt: PEnhMetaRecord);
var
  PEnhTransparentBlt: PEMRTransparentBlt;
  X1, Y1, W1, H1, X2, Y2, W2, H2: Integer;
  offBmi: Integer;
  offBits: Integer;
  cbBmi: Integer;
  ImgName: AnsiString;
  Img: TPDFImage;
  MS: TMemoryStream;
  R, G, B: Double;
  Rop: Integer;
begin
  PEnhTransparentBlt := PEMRTransparentBlt(Pnt);
  X1 := PEnhTransparentBlt.xDest;
  Y1 := PEnhTransparentBlt.yDest;
  W1 := PEnhTransparentBlt.cxDest;
  H1 := PEnhTransparentBlt.cyDest;
  X2 := PEnhTransparentBlt.xSrc;
  Y2 := PEnhTransparentBlt.ySrc;
  W2 := PEnhTransparentBlt.cxSrc;
  H2 := PEnhTransparentBlt.cySrc;
  offBmi := Integer(PEnhTransparentBlt.offBmiSrc);
  offBits := Integer(PEnhTransparentBlt.offBitsSrc);
  cbBmi := Integer(PEnhTransparentBlt.cbBmiSrc);
  Rop := -1;
  R := (PEnhTransparentBlt.dwRop and $FF) / 255;
  G := ((PEnhTransparentBlt.dwRop and $FF00) shr 8) / 255;
  B := ((PEnhTransparentBlt.dwRop and $FF0000) shr 16) / 255;
  MS := GetBitmap(Pnt, X2, Y2, W2, H2, offBmi, offBits, cbBmi, Rop, False);
  if not Assigned(MS) then
  begin
    FPainter.Rectangle(Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1), True, False);
  end else
  begin
    ImgName := 'QuickPDFI' + QPLRandomID;
    Img := TPDFImage.Create(FStructure, ImgName, FIncludedFonts);
    Img.Compress := 1;
    Img.RecompressImage := True;
    Img.EMFImageType := 1;  // EMF without Mask

    if Img.NewImageFromStream(MS, 0) then
    begin
      Img.SetImageMask(R, G, B, R, G, B);
      FIncludedBitmaps.Add(Img);
      FPainter.DrawImage(Img, Sx(X1, Y1), Sy(X1, Y1), Sw(W1), Sh(H1));
    end;
    MS.free;
  end;
end;

// Clipping records

procedure TPDFMetafile.EmfExcludeClipRect(Pnt: PEnhMetaRecord);
begin
  // Not yet supported
end;

procedure TPDFMetafile.EmfExtSelectClipRgn(Pnt: PEnhMetaRecord);
var
 PenhExtSelectClipRgn: PEMRExtSelectClipRgn;
 Mode: Integer;
 ExtSelectClipRgnSize: Integer;
 PRegionData: Pointer;
 NbRects: Integer;
 RegionData: RgnData;
 RegionDataHeader: RGNDATAHEADER;
 Rect: TRect;
 PRect: Pointer;
 Nr: Integer;
 X1, Y1, X2, Y2: Integer;
 GS: AnsiString;
begin
 PenhExtSelectClipRgn := PEMRExtSelectClipRgn(Pnt);
 Mode := PenhExtSelectClipRgn.iMode;

 if Mode = RGN_COPY then
 begin
   GS := FPainter.GetState;
   while FStateCounter > 0 do
   begin
     FStateCounter := FStateCounter - 1;
     FPainter.LoadState;
   end;
   FPainter.SetState(Gs);
 end;

 if (Mode = RGN_COPY) or (Mode = RGN_AND) or (Mode = RGN_OR) then
 begin
   if PenhExtSelectClipRgn.cbRgnData > 0 then
   begin
     ExtSelectClipRgnSize := 16;
     PRegionData := Pointer(TQPLIntPtr(Pnt) + ExtSelectClipRgnSize);
     Move(PRegionData^, RegionData, Sizeof(RegionDataHeader));
     RegionDataHeader := RegionData.rdh;
     NbRects := RegionDataHeader.nCount;
     if NbRects > 0 then
     begin
       FStateCounter := FStateCounter + 1;
       FPainter.SaveState;
       FPathStarted := False;
       for Nr := 0 to NbRects - 1 do
       begin
        //draw rectangle in the path
         PRect := Pointer(TQPLIntPtr(Pnt) + 48 + SizeOf(Rect) * Nr);
         Move(PRect^, Rect, SizeOf(Rect));
         X1 := Rect.Left + FTrans.WinOrgX;
         Y1 := Rect.Top + FTrans.WinOrgY;
         X2 := Rect.Right + FTrans.WinOrgX;
         Y2 := Rect.Bottom + FTrans.WinOrgY;
         if (X1 <> 0) or (Y1 <> 0) or (X2 <> 0) or (Y2 <> 0) then
         begin
           if not FPathStarted then
           begin
             FPathStarted := True;
             FPainter.StartPath(Sxb(X1, Y1), Syb(X1, Y1));
           end else
           begin
             FPainter.MovePath(Sxb(X1, Y1), Syb(X1, Y1));
           end;
           FPainter.AddLineToPath(Sxb(X2, Y1), Syb(X2, Y1));
           FPainter.AddLineToPath(Sxb(X2, Y2), Syb(X2, Y2));
           FPainter.AddLineToPath(Sxb(X1, Y2), Syb(X1, Y2));
           FPainter.ClosePath;
         end;
       end;
       if FPathStarted then
       begin
         if (Mode = RGN_COPY) or (Mode = RGN_AND) then
         begin
           FPainter.SetClippingPath;
         end else
         begin
           FPainter.SetClippingPathEvenOdd;
         end;
       end;
     end;
   end;
 end;
end;

procedure TPDFMetafile.EmfIntersectClipRect(Pnt: PEnhMetaRecord);
var
  PenhIntersectClipRect: PEMRIntersectClipRect;
  Rect: TRect;
  X1, Y1, X2, Y2: Integer;
  GS: AnsiString;
begin
  PenhIntersectClipRect := PEMRIntersectClipRect(Pnt);
  Rect := PenhIntersectClipRect.rclClip;
  X1 := Rect.Left;
  Y1 := Rect.Top;
  X2 := Rect.Right;
  Y2 := Rect.Bottom;
  while FStateCounter > 0 do
  begin
       GS := FPainter.GetState;
       FStateCounter := FStateCounter - 1;
       FPainter.LoadState;
       FPainter.SetState(GS);
  end;
  if (X1 <> 0) or (Y1 <> 0) or (X2 <> 0) or (Y2 <> 0) then
  begin
    FStateCounter := 1;
    FPainter.SaveState;
    FPainter.StartPath(Sx(X1, Y1), Sy(X1, Y1));
    FPainter.AddLineToPath(Sx(X2, Y1), Sy(X2, Y1));
    FPainter.AddLineToPath(Sx(X2, Y2), Sy(X2, Y2));
    FPainter.AddLineToPath(Sx(X1, Y2), Sy(X1, Y2));
    FPainter.ClosePath;
    FPainter.SetClippingPath();
  end;
end;

procedure TPDFMetafile.EmfOffsetClipRgn(Pnt: PEnhMetaRecord);
begin
  // Not yet supported
end;

procedure TPDFMetafile.EmfSelectClipPath(Pnt: PEnhMetaRecord);
var
  PenhSelectClipPath: PEMRSelectClipPath;
  Mode: Integer;
  GS: AnsiString;
begin
  PenhSelectClipPath := PEMRSelectClipPath(Pnt);
  Mode  := PenhSelectClipPath.iMode;
  if Mode = RGN_COPY then
  begin
    GS := FPainter.GetState;
    while FStateCounter > 0 do
    begin
      FStateCounter := FStateCounter - 1;
      FPainter.LoadState;
    end;
    FPainter.SetState(GS);
    FStateCounter := FStateCounter + 1;
    FPainter.SaveState;
    FPainter.SetClippingPath;
  end else
  if Mode = RGN_AND then
  begin
      FStateCounter := FStateCounter + 1;
      FPainter.SaveState;
      FPainter.SetClippingPathEvenOdd();
  end else
  if Mode = RGN_OR then
  begin
      FStateCounter := FStateCounter + 1;
      FPainter.SaveState;
      FPainter.SetClippingPath();
  end;
end;

procedure TPDFMetafile.EmfSetMetaRgn(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

// Comment records
procedure TPDFMetafile.EmfGdiComment(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

// Control records
procedure TPDFMetafile.ProcessHeader(Header: PEnhMetaHeader);
var
  SrcPixSizeX: Double;
  SrcPixSizeY: Double;
  SrcMilWidthX: Double;
  SrcMilHeightY: Double;
  ScaleX: Double;
  ScaleY: Double;
  X, Y: Double;
  //Ratio: Double;
begin
  FXRes := Header.szlDevice.cx / Header.szlMillimeters.cx * 25.4;
  FYRes := Header.szlDevice.cy / Header.szlMillimeters.cy * 25.4;
  FHorzRes := Header.szlDevice.cx;
  FVertRes := Header.szlDevice.cy;
  FHorzSize := Header.szlMillimeters.cx;
  FVertSize := Header.szlMillimeters.cy;

  OrigSw :=  Header.szlDevice.cx / Header.szlDevice.cy;

  SrcPixSizeX := Header.szlMillimeters.cx/Header.szlDevice.cx;
  SrcPixSizeY := Header.szlMillimeters.cy/Header.szlDevice.cy;
  SrcMilWidthX := Header.rclFrame.Right - Header.rclFrame.Left;
  SrcMilHeightY := Header.rclFrame.Bottom - Header.rclFrame.Top;

  ScaleX := 200 / SrcMilWidthX * SrcPixSizeX;
  ScaleY := 200 / SrcMilHeightY * SrcPixSizeY;
  FTrans.InitXform.eM11 := ScaleX;
  FTrans.InitXform.eM12 := 0;
  FTrans.InitXform.eM21 := 0;
  FTrans.InitXform.eM22 := ScaleX;

  if Header.rclFrame.Left <> 0 then
  begin
    X := Header.rclBounds.Left / Header.rclFrame.Left;
    FTrans.InitXform.eDx := -Header.rclFrame.Left * X * ScaleX;
    if QPLIsNan(FTrans.InitXform.eDx) then
    begin
      FTrans.InitXForm.eDx := 0;
    end;
  end else
  begin
    FTrans.InitXform.eDx := 0;
  end;

  if Header.rclFrame.Top <> 0 then
  begin
    Y := Header.rclBounds.Top / Header.rclFrame.Top;
    FTrans.InitXform.eDy := -Header.rclFrame.Top * Y * ScaleY;
    if QPLIsNan(FTrans.InitXform.eDy) then
    begin
      FTrans.InitXform.eDy := 0;
    end;
  end else
  begin
    FTrans.InitXform.eDy := 0;
  end;

  UpdateXForm;
end;

// Drawing records
procedure TPDFMetafile.EmfAngleArc(Pnt: PenhMetaRecord);
var
  PenhAngleArc: PEMRAngleArc;
  CenterX, CenterY: Integer;
  Radius: Integer;
  StartAngle, SweepAngle: Single;
  Angle1: Double;
  Angle2: Double;
begin
  PenhAngleArc := PEMRAngleArc(Pnt);
  CenterX      := PenhAngleArc.ptlCenter.X;
  CenterY      := PenhAngleArc.ptlCenter.Y;
  Radius       := PenhAngleArc.nRadius;
  StartAngle   := PenhAngleArc.eStartAngle;
  SweepAngle   := PenhAngleArc.eSweepAngle;
  Angle1 := StartAngle;
  Angle2 := StartAngle + SweepAngle;
  if FArcDirection = 1 then
  begin
    FPainter.Arc(Sx(CenterX, CenterY), Sy(CenterX, CenterY), Sw(Radius),
      Angle2, Angle1, False, FHasFill, FHasPen, False);
  end else
  begin
    FPainter.Arc(Sx(CenterX, CenterY), Sy(CenterX, CenterY), Sw(Radius),
      Angle1, Angle2, False, FHasFill, FHasPen, False);
  end;
end;

procedure TPDFMetafile.EmfArc(Pnt: PenhMetaRecord);
var
  PEnhArc: PEMRArc;
  Width: Integer;
  Height: Integer;
  Angle1: Double;
  Angle2: Double;
  X1, Y1, X2, Y2, W, H, CX, CY: Double;
begin
  PEnhArc := PEMRArc(Pnt);

  Width := PEnhArc.rclBox.Right - PEnhArc.rclBox.Left + 1;
  Height := (PEnhArc.rclBox.Bottom - PEnhArc.rclBox.Top + 1);

  CX := PEnhArc.rclBox.Left + Ceil(Width div 2);  // + RadiusX
  CY := PEnhArc.rclBox.Top + Ceil(Height div 2);  // + RadiusY

  X1 := PEnhArc.ptlStart.X;
  Y1 := PEnhArc.ptlStart.Y;
  X2 := PEnhArc.ptlEnd.X;
  Y2 := PEnhArc.ptlEnd.Y;

  CX := Sx(CX, CY);
  CY := Sy(CX, CY);
  X1 := Sx(X1, Y1);
  Y1 := Sy(X1, Y1);
  X2 := Sx(X2, Y2);
  Y2 := Sy(X2, Y2);
  H := Sh(Height);
  W := Sw(Width);

  Angle1 := CalcAngle(CX, CY, X1, Y1);
  Angle2 := CalcAngle(CX, CY, X2, Y2);

  {
  while (Angle1 > 360) do Angle1 := Angle1 - 360;
  while (Angle2 > 360) do Angle2 := Angle2 - 360;
  if (Angle1 < 0) then Angle1 := Angle1 + 360;
  if (Angle2 < 0) then Angle2 := Angle2 + 360;
  }

  if FArcDirection = 1 then
  begin
    FPainter.EllipticArc(Cx, Cy, W, H, Angle1, Angle2, False, FHasFill,
      FHasPen, False);
  end else
  begin
    FPainter.EllipticArc(Cx, Cy, W, H, Angle2, Angle1, False, FHasFill,
      FHasPen, False);
  end;
end;

procedure TPDFMetafile.EmfArcTo(Pnt: PenhMetaRecord);
var
  PEnhArcTo: PEMRArcTo;
  CenterX: Integer;
  CenterY: Integer;
  RadiusX: Integer;
  RadiusY: Integer;
  Width: Integer;
  Height: Integer;
  Angle1: Double;
  Angle2: Double;
  X1, Y1, X2, Y2, W, H: Double;
  CX, CY: Double;
begin
  PEnhArcTo := PEMRArcTo(Pnt);
  Width := PEnhArcTo.rclBox.Right - PEnhArcTo.rclBox.Left;
  Height := PEnhArcTo.rclBox.Bottom - PEnhArcTo.rclBox.Top;
  RadiusX := Round(Width div 2);
  RadiusY := Round(Height div 2);
  CenterX := PEnhArcTo.rclBox.Left + RadiusX;
  CenterY := PEnhArcTo.rclBox.Top + RadiusY;
  CX := Sx(CenterX, CenterY);
  CY := Sy(CenterX, CenterY);
  X1 := Sx(PEnhArcTo.ptlStart.X, PEnhArcTo.ptlStart.Y);
  Y1 := Sy(PEnhArcTo.ptlStart.X, PEnhArcTo.ptlStart.Y);
  X2 := Sx(PEnhArcTo.ptlEnd.X, PEnhArcTo.ptlEnd.Y);
  Y2 := Sy(PEnhArcTo.ptlEnd.X, PEnhArcTo.ptlEnd.Y);
  H := Sh(Height);
  W := Sw(Width);
  Angle1 := CalcAngle(CX, CY, X1, Y1);
  Angle2 := CalcAngle(CX, CY, X2, Y2);

  Angle1 := 90 - Angle1 + 180;   // ADC - allow for Origin change.
  Angle2 := 90 - Angle2 + 180;

  while (Angle1 > 360) do Angle1 := Angle1 - 360;
  while (Angle2 > 360) do Angle2 := Angle2 - 360;
  if (Angle1 < 0) then Angle1 := Angle1 + 360;
  if (Angle2 < 0) then Angle2 := Angle2 + 360;

  if FArcDirection = 1 then
  begin
    FPainter.EllipticArc(Cx, Cy, W, H, Angle2, Angle1, False, FHasFill,
      FHasPen, False);
  end else
  begin
    FPainter.EllipticArc(Cx, Cy, W, H, Angle1, Angle2, False, FHasFill,
      FHasPen, False);
  end;

  FXPos := X2;
  FYPos := Y2;
  WFXPos := PEnhArcTo.ptlEnd.X;
  WFYPos := PEnhArcTo.ptlEnd.Y;
end;

procedure TPDFMetafile.EmfChord(Pnt: PenhMetaRecord);
var
  PEnhChord: PEMRChord;
  CenterX: Integer;
  CenterY: Integer;
  RadiusX: Integer;
  RadiusY: Integer;
  Width: Integer;
  Height: Integer;
  Angle1: Double;
  Angle2: Double;
  X1, Y1, X2, Y2, W, H: Double;
  CX, CY: Double;
begin
  PEnhChord := PEMRChord(Pnt);
  Width := PEnhChord.rclBox.Right - PEnhChord.rclBox.Left;
  Height := PEnhChord.rclBox.Bottom - PEnhChord.rclBox.Top;
  RadiusX := Round(Width div 2);
  RadiusY := Round(Height div 2);
  CenterX := PEnhChord.rclBox.Left + RadiusX;
  CenterY := PEnhChord.rclBox.Top + RadiusY;
  CX := Sx(CenterX, CenterY);
  CY := Sy(CenterX, CenterY);
  X1 := Sx(PEnhChord.ptlStart.X, PEnhChord.ptlStart.Y);
  Y1 := Sy(PEnhChord.ptlStart.X, PEnhChord.ptlStart.Y);
  X2 := Sx(PEnhChord.ptlEnd.X, PEnhChord.ptlEnd.Y);
  Y2 := Sy(PEnhChord.ptlEnd.X, PEnhChord.ptlEnd.Y);
  H := Sh(Height);
  W := Sw(Width);
  Angle1 := CalcAngle(CX, CY, X1, Y1);
  Angle2 := CalcAngle(CX, CY, X2, Y2);
  if FArcDirection = 1 then
  begin
    FPainter.EllipticArc(Cx, Cy, W, H, Angle2, Angle1, False, FHasFill,
      FHasPen, True);
  end else
  begin
    FPainter.EllipticArc(Cx, Cy, W, H, Angle1, Angle2, False, FHasFill,
      FHasPen, True);
  end;
end;

procedure TPDFMetafile.EmfEllipse(Pnt: PEnhMetaRecord);
var
  PEnhEllipse: PEMREllipse;
  X, Y, H, W: Integer;
  dX, dY: Double;
begin
  PEnhEllipse := PEMREllipse(Pnt);
  X := PEnhEllipse.rclBox.Left;
  Y := PEnhEllipse.rclBox.Top;
  W := PEnhEllipse.rclBox.Right - X;
  H := PEnhEllipse.rclBox.Bottom - Y;
  dX := X + W / 2;
  dY := Y + H / 2;
  FPainter.Ellipse(Sx(dX, dY), Sy(dX, dY), Sw(W), Sh(H), FHasFill, FHasPen);
end;

procedure TPDFMetafile.EmfExtFloodFill(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfExtTextOutA(Pnt: PEnhMetaRecord);
var
  PEnhExtTextOutA: PEMRExtTextOut;
  OffString: Integer;
  OffDx: Integer;
  TextP: Pointer;
  TextA: AnsiString;
  CharsCount: Integer;
  X, Y: Integer;
  OutputFlag: Cardinal;
  I, J: Integer;
  S: AnsiString;
  C: Word;
  Offsets: array of Double;
  OffsetsP: Pointer;
  Rect: TRect;
  HasBounds: Boolean;
  X1, Y1, X2, Y2: Integer;
begin
  SetLength(Offsets, 0);

  FPainter.SelectFont(FSelFont, Abs(Sw(Round(FFntSize))));

  PEnhExtTextOutA := PEMRExtTextOut(Pnt);
  X := PEnhExtTextOutA.emrtext.ptlReference.X;
  Y := PEnhExtTextOutA.emrtext.ptlReference.Y;

  Rect := PEnhExtTextOutA.emrtext.rcl;

  HasBounds := (X = Rect.Left) and (Y = Rect.Top);

  OffString := PEnhExtTextOutA.emrtext.offString;
  OffDx := PEnhExtTextOutA.emrtext.Offdx;
  OutputFlag := PEnhExtTextOutA.emrtext.fOptions;

  if (OutputFlag and ETO_OPAQUE) = ETO_OPAQUE then
  begin
    FPainter.SetFillColor((FBkColor and $FF) / 255,
                         ((FBkColor and $FF00) shr 8) / 255,
                         ((FBkColor and $FF0000) shr 16) / 255);

    FPainter.Rectangle(SX(Rect.Left, Rect.Top), SY(Rect.Left, Rect.Top),
      Sw(Rect.Right - Rect.Left), Sh(Rect.Bottom - Rect.Top),
      True, False);

    FPainter.SetFillColor((FFillColor and $FF) / 255,
                         ((FFillColor and $FF00) shr 8) / 255,
                         ((FFillColor and $FF0000) shr 16) / 255);
  end;

  if (OutputFlag and ETO_CLIPPED) = ETO_CLIPPED then
  begin
    FPainter.SaveState;
    X1 := Rect.Left;
    Y1 := Rect.Top;
    X2 := Rect.Right + 1;
    Y2 := Rect.Bottom + 1;
    FPainter.StartPath(Sx(X1, Y1), Sy(X1, Y1));
    FPainter.AddLineToPath(Sx(X2, Y1), Sy(X2, Y1));
    FPainter.AddLineToPath(Sx(X2, Y2), Sy(X2, Y2));
    FPainter.AddLineToPath(Sx(X1, Y2), Sy(X1, Y2));
    FPainter.ClosePath;
    FPainter.SetClippingPath();
  end;

  TextP := Pointer(TQPLIntPtr(Pnt) + OffString);
  CharsCount := PEnhExtTextOutA.emrtext.nChars;
  if not Assigned(FSelFont) then
  begin
    FSelFont := CreateStockFont('MS Sans Serif', False, False, 10);
  end;
  if CharsCount > 0 then
  begin
    if (OffDx <> 0) and Enhanced then
    begin
      SetLength(Offsets, CharsCount);
      if (OutputFlag and ETO_PDY) = ETO_PDY then
      begin
        for I := 0 to CharsCount - 1 do
        begin
          OffsetsP := Pointer(Integer(Pnt) + OffDx + ((I) * 2 * 4));
          Move(OffsetsP^, J, 4);
          Offsets[I] := Sw(J);
        end;
      end else
      begin
        for I := 0 to CharsCount - 1 do
        begin
          OffsetsP := Pointer(TQPLIntPtr(Pnt) + OffDx + (I * 4));
          Move(OffsetsP^, J, 4);
          Offsets[I] := Sw(J);
        end;
      end;
    end else
    begin
      SetLength(Offsets, 0);
    end;
    SetLength(TextA, CharsCount);
    Move(TextP^, TextA[1], Length(TextA));

    if (OutputFlag and ETO_GLYPH_INDEX) = ETO_GLYPH_INDEX then
    begin
      for I := 1 to Length(TextA) do
      begin
        C := FSelFont.GetGIDToCID(Ord(TextA[I]));
        if (C <> 65535) then
          S := S + AnsiChar(C);
      end;
      TextOut(X, Y, WideString(S), Offsets, HasBounds);
    end else
    begin
      TextOut(X, Y, WideString(TextA), Offsets, HasBounds);
    end;
  end;

  if (OutputFlag and ETO_CLIPPED) = ETO_CLIPPED then
  begin
    FPainter.LoadState;
  end;
end;

constructor TCharData.Create(WC: WideChar; CharIndex: Integer; CharWidth: Double);
begin
  self.WC := WC;
  self.CharIndex := CharIndex;
  self.CharWidth := CharWidth;
end;

{$IFDEF HEBREW_DEBUG}
function DebugCList(CList: TList; var A1:array of WideChar; var A2:array of AnsiChar): WideString;
var
  I: Integer;
begin

  for I := 0 to CList.Count - 1 do
  begin
    A1[I] := TCharData(CList[I]).WC;
    A2[I] := TCharData(CList[I]).LTR;
  end;
end;
{$ENDIF}

procedure HewbrewSwap(var WS: WideString; var Offsets: Array of Double);
var
  CList: TList;
  C: TCharData;
  I: Integer;
  WC: WideChar;
  CurrLTR: AnsiChar;
  P1, P2: Integer;
  RFound: Boolean;
  Separators: AnsiString;
  A1 : array of WideChar;
  A2 : array of AnsiChar;

  function SwapMirroredChar(WC: WideChar): WideChar; {$IFNDEF QPL_NOINLINE}inline;{$ENDIF}
  begin
    Result := WC;
    if Result = '(' then
      Result := ')'
    else if Result = ')' then
      Result := '(';
  end;

begin

  // Check to see if we have any Hebrew characters.
  RFound := False;
  for I := 1 to Length(WS) do
    if ((WS[I] >= #$0591) and (WS[I] <= #$05F4)) then
      RFound := True;

  if (not RFound) then  // No hebrew - exit now.
    Exit;

  Separators := ',/.';
  CList := TList.Create();

  SetLength(A1, Length(WS));
  SetLength(A2, Length(WS));

  for I := 1 to Length(WS) do
  begin
    C := TCharData.Create(WS[I], I, Offsets[I-1]);
    CList.Add(C);
  end;

  // Determine the type of English and Hebrew characters.
  // ' ' = undefined separator
  // 'N' = English - needs reversing
  // 'R' = Hebrew - needs reversing
  // 'L' = English - doesn't need rotating

  RFound := False;
  for I := 0 to CList.Count - 1 do
  begin
    WC := TCharData(CList[I]).WC;

    if ((WC >= #$0591) and (WC <= #$05F4)) then
    begin
      CurrLTR := 'R';
      RFound := True;
    end
    else if (WC = ' ') then
      CurrLTR := ' '
    else if (not RFound) then
      CurrLTR := 'L'
    else if (WC >= '0') and (WC <= '9') then
      CurrLTR := 'N'
    else if (WC >= '!') and (WC <= '@') then
      CurrLTR := ' '
    else
      CurrLTR := 'N';

    TCharData(CList[I]).LTR := CurrLTR;
  end;

  // Check the separators to see if they are part of a larger english word.
  for I := 0 to CList.Count - 2 do
    if (QPLPos(AnsiString(TCharData(CList[I]).WC), Separators) >= 1) and (TCharData(CList[I+1]).LTR = 'N') then  // ADC - Direct use of PosEx
      TCharData(CList[I]).LTR := 'N';

{$IFDEF HEBREW_DEBUG}
  DebugCList(CList, A1, A2);
{$ENDIF}

  // Swap the English parts only and only if there is Hebrew text in the first place.
  I := 0;

  while (RFound) and (I < CList.Count) do
  begin
    P1 := I;
    if (TCharData(CList[I]).LTR = 'N') then
    begin
      P2 := I;
      while (I < CList.Count) and (TCharData(CList[I]).LTR = 'N') do
      begin
        P2 := I;
        Inc(I);
      end;

      while (P1 < P2) do
      begin
        CList.Exchange(P1, P2);
        Inc(P1);
        Dec(P2);
      end;
    end
    else
      Inc(I);
  end;

{$IFDEF HEBREW_DEBUG}
  DebugCList(CList, A1, A2);
{$ENDIF}

  // Expand the Hebrew sections that need rotating.
  RFound := False;
  for I := 0 to CList.Count - 1 do
  begin
    if TCharData(CList[I]).LTR = 'R' then
      RFound := True;
    if TCharData(CList[I]).LTR = 'L' then
      RFound := False;

    if RFound then
      TCharData(CList[I]).LTR := 'R';
  end;

{$IFDEF HEBREW_DEBUG}
  DebugCList(CList, A1, A2);
{$ENDIF}

  I := 0;
  while (I < CList.Count) do
  begin

    if (I < CList.Count) and (TCharData(CList[I]).LTR = 'R') then
    begin
      P1 := I;
      P2 := I;
      while (I < CList.Count) and (TCharData(CList[I]).LTR = 'R') do
      begin
        P2 := I;
        Inc(I);
      end;

      while (P1 < P2) do
      begin
        CList.Exchange(P1, P2);

        TCharData(CList[P1]).WC := SwapMirroredChar(TCharData(CList[P1]).WC);
        TCharData(CList[P2]).WC := SwapMirroredChar(TCharData(CList[P2]).WC);

        Inc(P1);
        Dec(P2);
      end;
    end
    else
      Inc(I);
  end;

{$IFDEF HEBREW_DEBUG}
  DebugCList(CList, A1, A2);
{$ENDIF}

  // Update the var parameters with the processed string and widths.
  for I := 0 to CList.Count - 1 do
  begin
    WS[I+1] := TCharData(CList[I]).WC;
    Offsets[I] := TCharData(CList[I]).CharWidth;
  end;

  CList.Free();
end;

procedure TPDFMetafile.EmfExtTextOutW(Pnt: PEnhMetaRecord);
var
  PEnhExtTextOutW: PEMRExtTextOut;
  OffString: Integer;
  OffDx: Integer;
  TextP: PAnsiChar;
  //TextP: Pointer;
  TextW: WideString;
  CharsCount: Integer;
  X, Y: Integer;
  OutputFlag: Cardinal;
  I, J: Integer;
  S: WideString;
  Offsets: array of Double;
  OffsetsP: Pointer;
  Rect: TRect;
  HasBounds: Boolean;
  WC: Integer;
  X1, Y1, X2, Y2: Integer;
begin
  PEnhExtTextOutW := PEMRExttextOut(Pnt);
  X := PEnhExtTextOutW.emrtext.ptlReference.X;
  Y := PEnhExtTextOutW.emrtext.ptlReference.Y;

  if not Assigned(FSelFont) then
    FSelFont := CreateStockFont('MS Sans Serif', False, False, 10);

  FPainter.SelectFont(FSelFont, Abs(Sw(Round(FFntSize))));

  Rect := PEnhExtTextOutW.emrtext.rcl;

  HasBounds := (X = Rect.Left) and (Y = Rect.Top) and (X <> 0) and (Y <> 0);
  OutputFlag := PEnhExtTextOutW.emrtext.fOptions;

  if (OutputFlag and ETO_OPAQUE) = ETO_OPAQUE then
  begin
    FPainter.SetFillColor((FBkColor and $FF) / 255,
                         ((FBkColor and $FF00) shr 8) / 255,
                         ((FBkColor and $FF0000) shr 16) / 255);

    FPainter.Rectangle(SX(Rect.Left, Rect.Top), SY(Rect.Left, Rect.Top),
      Sw(Rect.Right - Rect.Left), Sh(Rect.Bottom - Rect.Top),
      True, False);

    FPainter.SetFillColor((FFillColor and $FF) / 255,
                         ((FFillColor and $FF00) shr 8) / 255,
                         ((FFillColor and $FF0000) shr 16) / 255);
  end;

  if (OutputFlag and ETO_IGNORELANGUAGE) = ETO_IGNORELANGUAGE then
  begin
  end;

  if (OutputFlag and ETO_CLIPPED) = ETO_CLIPPED then
  begin
    FPainter.SaveState;
    X1 := Rect.Left;
    Y1 := Rect.Top;
    X2 := Rect.Right + 1;
    Y2 := Rect.Bottom + 1;
    FPainter.StartPath(Sx(X1, Y1), Sy(X1, Y1));
    FPainter.AddLineToPath(Sx(X2, Y1), Sy(X2, Y1));
    FPainter.AddLineToPath(Sx(X2, Y2), Sy(X2, Y2));
    FPainter.AddLineToPath(Sx(X1, Y2), Sy(X1, Y2));
    FPainter.ClosePath;
    FPainter.SetClippingPath();
  end;

  OffString := PEnhExtTextOutW.emrtext.offString;
  OffDx := PEnhExtTextOutW.emrtext.OffDx;
  TextP := Pointer(TQPLIntPtr(Pnt) + OffString);
  CharsCount := PEnhExtTextOutW.emrtext.nChars;

  if CharsCount > 0 then
  begin
    if not Assigned(FSelFont) then
    begin
      FSelFont := CreateStockFont('MS Sans Serif', False, False, 10);
    end;

    if (OffDx <> 0) then // and Enhanced then
    begin
      SetLength(Offsets, CharsCount);
      if (OutputFlag and ETO_PDY) = ETO_PDY then
      begin
        for I := 0 to CharsCount - 1 do
        begin
          OffsetsP := Pointer(TQPLIntPtr(Pnt) + OffDx + ((I) * 2 * 4));
          Move(OffSetsP^, J, 4);
          Offsets[I] := Sw(J);
        end;
      end else
      begin
        for I := 0 to CharsCount - 1 do
        begin
          OffsetsP := Pointer(TQPLIntPtr(Pnt) + OffDx + (I * 4));
          Move(OffsetsP^, J, 4);

          Offsets[I] := Sw(J);
        end;
      end;
    end else
    begin
      SetLength(Offsets, 0);
    end;

    SetLength(TextW, CharsCount);
    Move(TextP^, TextW[1], Length(TextW) * 2);

    HewbrewSwap(TextW, Offsets);

    if (OutputFlag and ETO_GLYPH_INDEX) = ETO_GLYPH_INDEX then
    begin
      if (not FForceUFI) then
      begin
        for I := 1 to CharsCount do
        begin
          WC := Ord(TextP^);
          Inc(TextP);
          WC := Ord(TextP^) * 256 + WC;
          Inc(TextP);
          TextW[I] := WideChar(WC);
        end;
        TextOut(X, Y, TextW, OffSets, HasBounds);
      end
      else
      begin
        for I := 1 to CharsCount do
        begin
          WC := FSelFont.GetGIDToCID(Ord(TextW[I]));
          if (WC <> 65535) then
            S := S + WideChar(WC);
        end;
        TextOut(X, Y, S, Offsets, HasBounds);
      end;
    end else
      TextOut(X, Y, TextW, OffSets, HasBounds);
  end;

  if (OutputFlag and ETO_CLIPPED) = ETO_CLIPPED then
  begin
    FPainter.LoadState;
  end;
end;

procedure TPDFMetafile.EmfFillPath(Pnt: PEnhMetaRecord);
begin
  if FFillMode = ALTERNATE then
  begin
    FPainter.DrawPathEvenOdd(FHasFill, False);
  end else
  begin
    FPainter.DrawPath(FHasFill, False);
  end;
  FInPath := False;
  FPathStarted := False;
end;

procedure TPDFMetafile.EmfFillRgn(Pnt: PEnhMetaRecord);
var
  PEnhFillRgn: PEMRFillRgn;
  PRegionData: Pointer;
  NbRects: Integer;
  RegionData: RgnData;
  RegionDataHeader: RGNDATAHEADER;
  Rect: TRect;
  PRect: Pointer;
  Nr: Integer;
  I: Cardinal;
  X: Integer;
  SaveColor: AnsiString;
begin
  PEnhFillRgn := PEMRFillRgn(Pnt);
  SaveColor := FPainter.FillColor;
  //select brush
  if PEnhFillRgn.cbRgnData > 0 then
  begin
    I := PEnhFillRgn.ihBrush;
    if (I and 2147483648) = 2147483648 then
    begin
      X := I and 2147483647;
      SelectStockObject(X, I);
    end else
    begin
      X := I;
      Self.SelectObject(X);
    end;

    FPainter.SetFillColor((FFillColor and $FF) / 255,
                         ((FFillColor and $FF00) shr 8) / 255,
                         ((FFillColor and $FF0000) shr 16) / 255);

    PRegionData := Pointer(TQPLIntPtr(Pnt) + 32);
    Move(PRegionData^, RegionData, Sizeof(RegionDataHeader));
    RegionDataHeader := RegionData.rdh;
    NbRects := RegionDataHeader.nCount;
    for Nr := 0 to NbRects - 1 do
    begin
      PRect := Pointer(TQPLIntPtr(Pnt) + 32 + SizeOf(RegionDataHeader) +
        SizeOf(Rect) * Nr);
      Move(PRect^, Rect, SizeOf(Rect));

      FPainter.Rectangle(SX(Rect.Left, Rect.Top), SY(Rect.Left, Rect.Top),
        Sw(Rect.Right - Rect.Left), Sh(Rect.Bottom - Rect.Top),
        FHasFill, False);
    end;
  end;
  FPainter.SetFillColor(SaveColor);
end;

procedure TPDFMetafile.EmfFrameRgn(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfGradientFill(Pnt: PEnhMetaRecord);
var
  PEnhGradientFill: PEMRGradientFill;
  VertexCount: Integer;
  TriVertexCount: Integer;
  iMode: Integer;
  Pointer1: Pointer;
  Pointer2: Pointer;
  PVertex: Pointer;
  PTriVert: Pointer;
  X, Y: Integer;
  Verts: array of TTRIVERTEX;
  GradRect: array of TGRADIENTRECT;
  GradTri: array of TGRADIENTTRIANGLE;

  RStep, GStep, BStep: Double;
  Red, Green, Blue: Double;
  Red1, Green1, Blue1: Integer;
  Red2, Green2, Blue2: Integer;
  Mini, Maxi: Integer;
  LineCounter: Integer;
  IncLineCounter: Integer;
  StartX, StartY: Integer;
  EndX, EndY: Integer;
  SavLineColor: AnsiString;
  SavFillColor: AnsiString;

  Vert1, Vert2, Vert3: PersTrivertex;

  procedure PutPixel(P: PersTrivertex);
  var
    Color: Integer;
    Width, Height: Integer;
    X, Y: Integer;
  begin
    X := Round(P.X);
    Y := Round(P.Y);
    Color := CalcColor(RGB(Round(P.R), Round(P.G), Round(P.B)));
    Width := 3;
    Height := 3;
    FPainter.SetFillColor((Color and $FF) / 255,
                         ((Color and $FF00) shr 8) / 255,
                         ((Color and $FF0000) shr 16) / 255);
    FPainter.Rectangle(Sx(X - 1, Y - 1), Sy(X - 1, Y - 1),
                       Sw(Width), Sh(Height),
                       True, False);
  end;

  function SetVertex(P: PersTrivertex): PersTrivertex;
  begin
    Result.X := P.X;
    Result.Y := P.Y;
    Result.R := P.R;
    Result.G := P.G;
    Result.B := P.B;
  end;

  procedure DrawTriangle(VertA, VertB, VertC: PersTrivertex);
  var
    dRed, dRed1, dRed2, dRed3: Double;
    dGreen, dGreen1, dGreen2, dGreen3: Double;
    dBlue, dBlue1, dBlue2, dBlue3: Double;

    dX1, dX2, dX3: Double;

    VertT: PersTriVertex; // temp
    VertL: PersTriVertex; // left
    VertR: PersTriVertex; // right
  begin
    //sort in the y axis
    if VertA.Y > VertB.Y then
    begin
      VertT := SetVertex(VertA);
      VertA := SetVertex(VertB);
      VertB := SetVertex(VertT);
    end;

    if VertA.Y > VertC.Y then
    begin
      VertT := SetVertex(VertA);
      VertA := SetVertex(VertC);
      VertC := SetVertex(VertT);
    end;

    if VertB.Y > VertC.Y then
    begin
      VertT := SetVertex(VertB);
      VertB := SetVertex(VertC);
      VertC := SetVertex(VertT);
    end;

    if (VertB.Y - VertA.Y > 0) then
    begin
      dX1 := (VertB.X - VertA.X) / (VertB.Y - VertA.Y);
      dRed1 := (VertB.R - VertA.R) / (VertB.Y - VertA.Y);
      dGreen1 := (VertB.G - VertA.G) / (VertB.Y - VertA.Y);
      dBlue1 := (VertB.B - VertA.B) / (VertB.Y - VertA.Y);
    end else
    begin
      dX1 := VertB.X - VertA.X;
      dRed1 := VertB.R - VertA.R;
      dGreen1 := VertB.G - VertA.G;
      dBlue1 := VertB.B - VertA.B;
    end;

    if (VertC.Y - VertA.Y > 0) then
    begin
      dX2 := (VertC.X - VertA.X) / (VertC.Y - VertA.Y);
      dRed2 := (VertC.R - VertA.R) / (VertC.Y - VertA.Y);
      dGreen2 := (VertC.G - VertA.G) / (VertC.Y - VertA.Y);
      dBlue2 := (VertC.B - VertA.B) / (VertC.Y - VertA.Y);
    end else
    begin
      dX2 := 0;
      dRed2 := 0;
      dGreen2 := 0;
      dBlue2 := 0;
    end;

    if (VertC.Y - VertB.Y > 0) then
    begin
      dX3 := (VertC.X - VertB.X) / (VertC.Y - VertB.Y);
      dRed3 := (VertC.R - VertB.R) / (VertC.Y - VertB.Y);
      dGreen3 := (VertC.G - VertB.G) / (VertC.Y - VertB.Y);
      dBlue3 := (VertC.B - VertB.B) / (VertC.Y - VertB.Y);
    end else
    begin
      dX3 := 0;
      dRed3 := 0;
      dGreen3 := 0;
      dBlue3 := 0;
    end;

    VertL := SetVertex(VertA);
    VertR := SetVertex(VertA);

    if (dX1 > dX2) then
    begin
      while VertL.Y <= VertB.Y do
      begin
        if (VertR.X - VertL.X > 0) then
        begin
          dRed := (VertR.R - VertL.R) / (VertR.X - VertL.X);
          dGreen := (VertR.G - VertL.G) / (VertR.X - VertL.X);
          dBlue := (VertR.B - VertL.B) / (VertR.X - VertL.X);
        end else
        begin
          dRed := 0;
          dGreen := 0;
          dBlue := 0;
        end;
        VertT := SetVertex(VertL);
        while Round(VertT.X) < VertR.X do
        begin
          PutPixel(VertT);
          VertT.R := VertT.R + dRed;
          VertT.G := VertT.G + dGreen;
          VertT.B := VertT.B + dBlue;
          VertT.X := VertT.X + 1;
        end;
        VertL.X := VertL.X + dX2;
        VertL.Y := VertL.Y + 1;
        VertL.R := VertL.R + dRed2;
        VertL.G := VertL.G + dGreen2;
        VertL.B := VertL.B + dBlue2;
        VertR.X := VertR.X + dX1;
        VertR.Y := VertR.Y + 1;
        VertR.R := VertR.R + dRed1;
        VertR.G := VertR.G + dGreen1;
        VertR.B := VertR.B + dBlue1;
      end;

      VertR := SetVertex(VertB);
      while VertL.Y < VertC.Y do
      begin
        if (VertR.X - VertL.X > 0) then
        begin
          dRed := (VertR.R - VertL.R) / (VertR.X - VertL.X);
          dGreen := (VertR.G - VertL.G) / (VertR.X - VertL.X);
          dBlue := (VertR.B - VertL.B) / (VertR.X - VertL.X);
        end else
        begin
          dRed := 0;
          dGreen := 0;
          dBlue := 0;
        end;
        VertT := SetVertex(VertL);
        while Round(VertT.X) < VertR.X do
        begin
          PutPixel(VertT);
          VertT.R := VertT.R + dRed;
          VertT.G := VertT.G + dGreen;
          VertT.B := VertT.B + dBlue;
          VertT.X := VertT.X + 1;
        end;
        VertL.X := VertL.X + dX2;
        VertL.Y := VertL.Y + 1;
        VertL.R := VertL.R + dRed2;
        VertL.G := VertL.G + dGreen2;
        VertL.B := VertL.B + dBlue2;
        VertR.X := VertR.X + dX3;
        VertR.Y := VertR.Y + 1;
        VertR.R := VertR.R + dRed3;
        VertR.G := VertR.G + dGreen3;
        VertR.B := VertR.B + dBlue3;
      end;
    end else
    begin
      while VertL.Y <= VertB.Y do
      begin
        if (VertR.X - VertL.X > 0) then
        begin
          dRed := (VertR.R - VertL.R) / (VertR.X - VertL.X);
          dGreen := (VertR.G - VertL.G) / (VertR.X - VertL.X);
          dBlue := (VertR.B - VertL.B) / (VertR.X - VertL.X);
        end else
        begin
          dRed := 0;
          dGreen := 0;
          dBlue := 0;
        end;
        VertT := SetVertex(VertL);
        while Round(VertT.X) < VertR.X do
        begin
          PutPixel(VertT);
          VertT.R := VertT.R + dRed;
          VertT.G := VertT.G + dGreen;
          VertT.B := VertT.B + dBlue;
          VertT.X := VertT.X + 1;
        end;
        VertL.X := VertL.X + dX1;
        VertL.Y := VertL.Y + 1;
        VertL.R := VertL.R + dRed1;
        VertL.G := VertL.G + dGreen1;
        VertL.B := VertL.B + dBlue1;
        VertR.X := VertR.X + dX2;
        VertR.Y := VertR.Y + 1;
        VertR.R := VertR.R + dRed2;
        VertR.G := VertR.G + dGreen2;
        VertR.B := VertR.B + dBlue2;
      end;
      VertL := SetVertex(VertB);
      while Round(VertL.Y) <= VertC.Y do
      begin
        if (VertR.X - VertL.X > 0) then
        begin
          dRed := (VertR.R - VertL.R) / (VertR.X - VertL.X);
          dGreen := (VertR.G - VertL.G) / (VertR.X - VertL.X);
          dBlue := (VertR.B - VertL.B) / (VertR.X - VertL.X);
        end else
        begin
          dRed := 0;
          dGreen := 0;
          dBlue := 0;
        end;
        VertT := SetVertex(VertL);
        while Round(VertT.X) < VertR.X do
        begin
          PutPixel(VertT);
          VertT.R := VertT.R + dRed;
          VertT.G := VertT.G + dGreen;
          VertT.B := VertT.B + dBlue;
          VertT.X := VertT.X + 1;
        end;
        VertL.X := VertL.X + dX3;
        VertL.Y := VertL.Y + 1;
        VertL.R := VertL.R + dRed3;
        VertL.G := VertL.G + dGreen3;
        VertL.B := VertL.B + dBlue3;
        VertR.X := VertR.X + dX2;
        VertR.Y := VertR.Y + 1;
        VertR.R := VertR.R + dRed2;
        VertR.G := VertR.G + dGreen2;
        VertR.B := VertR.B + dBlue2;
      end;
    end;
  end;

begin
  SavLineColor := FPainter.LineColor;
  SavFillColor := FPainter.FillColor;

  Pointer1 := Pointer(Pnt);
  Pointer2 := @PEnhGradientFill;
  X := SizeOf(PEMRGradientFill);
  Move(Pointer1^, Pointer2^, X);

  VertexCount := PEnhGradientFill.nVer;
  TriVertexCount := PEnhGradientFill.nTri;
  iMode := PEnhGradientFill.ulMode;

  Y := SizeOf(TTRIVERTEX) * VertexCount;

  SetLength(Verts, VertexCount);
  PVertex := Pointer(TQPLIntPtr(Pnt) + X);
  Move(PVertex^, Verts[0], Y);

  case iMode of
    GRADIENT_FILL_RECT_H:
    begin
      SetLength(GradRect, TriVertexCount);
      PTriVert := Pointer(TQPLIntPtr(Pnt) + X + Y);
      Move(PTriVert^, GradRect[0], Sizeof(TGRADIENTRECT) * TriVertexCount);

      for X := 0 to TriVertexCount - 1 do
      begin
        StartX := Verts[GradRect[X].UpperLeft].x;
        StartY := Verts[GradRect[X].UpperLeft].Y;
        EndX := Verts[GradRect[X].LowerRight].x;
        EndY := Verts[GradRect[X].LowerRight].Y;
        Red1 := Verts[GradRect[X].UpperLeft].Red div 256;
        Green1 := Verts[GradRect[X].UpperLeft].Green div 256;
        Blue1 := Verts[GradRect[X].UpperLeft].Blue div 256;
        Red2 := Verts[GradRect[X].LowerRight].Red div 256;
        Green2 := Verts[GradRect[X].LowerRight].Green div 256;
        Blue2 := Verts[GradRect[X].LowerRight].Blue div 256;
        if RGB(Red1, Green1, Blue1) = RGB(Red2, Green2, Blue2) then
        begin
          FPainter.SetFillColor(Red1 / 256, Green1 / 256, Blue1 / 256);
          FPainter.Rectangle(Sx(StartX, StartY), Sy(StartX, StartY),
            Sw(EndX - StartX), Sh(EndY - StartY), True, False);
        end else
        begin
          Mini := Min(StartX, EndX);
          Maxi := Max(StartX, EndX);
          RStep := (Red2 - Red1) / (Maxi - Mini);
          GStep := (Green2 - Green1) / (Maxi - Mini);
          BStep := (Blue2 - Blue1) / (Maxi - Mini);
          Red := Red1;
          Green := Green1;
          Blue := Blue1;
          if StartX > EndX then
          begin
            IncLineCounter := -1;
          end else
          begin
            IncLineCounter := 1;
          end;

          FPainter.SetLineWidth(Abs(Sh(2)));

          LineCounter := StartX;
          while LineCounter <> EndX do
          begin
            FPainter.SetLineColor(Red / 256, Green / 256, Blue / 256);
            FPainter.DrawLine(Sx(LineCounter, StartY), Sy(LineCounter, StartY),
                              Sx(LineCounter, EndY), Sy(LineCounter, EndY));
           Red := Red + RStep;
           Green := Green + GStep;
           Blue := Blue + BStep;
           LineCounter := LineCounter + IncLineCounter;
          end;
        end;
      end;
    end;

    GRADIENT_FILL_RECT_V:
    begin
      SetLength(GradRect, TriVertexCount);
      PTriVert := Pointer(TQPLIntPtr(Pnt) + X + Y);
      Move(PTriVert^, GradRect[0], SizeOf(TGRADIENTRECT) * TriVertexCount);
      for X := 0 to TriVertexCount - 1 do
      begin
        StartX := Verts[GradRect[X].UpperLeft].x;
        StartY := Verts[GradRect[X].UpperLeft].y;
        EndX := Verts[GradRect[X].LowerRight].x;
        EndY := Verts[GradRect[X].LowerRight].Y;
        Red1 := Verts[GradRect[X].UpperLeft].Red div 256;
        Red2 := Verts[GradRect[X].LowerRight].Red div 256;
        Green1 := Verts[GradRect[X].UpperLeft].Green div 256;
        Green2 := Verts[GradRect[X].LowerRight].Green div 256;
        Blue1 := Verts[GradRect[X].UpperLeft].Blue div 256;
        Blue2 := Verts[GradRect[X].LowerRight].Blue div 256;
        if RGB(Red1, Green1, Blue1) = RGB(Red2, Green2, Blue2) then
        begin
          FPainter.SetFillColor(Red1 / 256, Green1 / 256, Blue1 / 256);
          FPainter.Rectangle(Sx(StartX, StartY), Sy(StartX, StartY),
            Sw(EndX - StartX), Sh(EndY - StartY), True, False);
        end else
        begin
          Mini := Min(StartY, EndY);
          Maxi := Max(StartY, EndY);
          RStep := (Red2 - Red1) / (Maxi - Mini);
          GStep := (Green2 - Green1) / (Maxi - Mini);
          BStep := (Blue2 - Blue1) / (Maxi - Mini);
          Red := Red1;
          Green := Green1;
          Blue := Blue1;
          if StartY > EndY then
          begin
            IncLineCounter := -1;
          end else
          begin
            IncLineCounter := 1;
          end;

          FPainter.SetLineWidth(Abs(Sh(2)));

          LineCounter := StartY;
          while LineCounter <> EndY do
          begin
            FPainter.SetLineColor(Red / 256, Green / 256, Blue / 256);
            FPainter.DrawLine(Sx(StartX, LineCounter), Sy(StartX, LineCounter),
              Sx(EndX, LineCounter), Sy(EndX, LineCounter));
            Red := Red + RStep;
            Green := Green + GStep;
            Blue := Blue + BStep;
            LineCounter := LineCounter + IncLineCounter;
          end;
        end;
      end;
    end;

    GRADIENT_FILL_TRIANGLE:
    begin
      SetLength(GradTri, TriVertexCount);
      PTriVert := Pointer(TQPLIntPtr(Pnt) + X + Y);
      Move(PTriVert^, GradTri[0], Sizeof(TGRADIENTTRIANGLE) * TriVertexCount);
      for X := 0 to TriVertexCount - 1 do
      begin
        Vert1.X := Verts[GradTri[X].Vertex1].x;
        Vert1.Y := Verts[GradTri[X].Vertex1].y;
        Vert1.R := Verts[GradTri[X].Vertex1].Red div 256;
        Vert1.G := Verts[GradTri[X].Vertex1].Green div 256;
        Vert1.B := Verts[GradTri[X].Vertex1].Blue div 256;
        Vert2.X := Verts[GradTri[X].Vertex2].x;
        Vert2.Y := Verts[GradTri[X].Vertex2].y;
        Vert2.R := Verts[GradTri[X].Vertex2].Red div 256;
        Vert2.G := Verts[GradTri[X].Vertex2].Green div 256;
        Vert2.B := Verts[GradTri[X].Vertex2].Blue div 256;
        Vert3.X := Verts[GradTri[X].Vertex3].x;
        Vert3.Y := Verts[GradTri[X].Vertex3].y;
        Vert3.R := Verts[GradTri[X].Vertex3].Red div 256;
        Vert3.G := Verts[GradTri[X].Vertex3].Green div 256;
        Vert3.B := Verts[GradTri[X].Vertex3].Blue div 256;
        DrawTriangle(Vert1, Vert2, Vert3);
      end;
    end;
  end;
  FPainter.SetLineColor(SavLineColor);
  FPainter.SetFillColor(SavFillColor);
end;

procedure TPDFMetafile.EmfLineTo(Pnt: PEnhMetaRecord);
var
  PEnhLineTo: PEMRLineTo;
  P: TPoint;
begin
  PEnhLineTo := PEMRLineTo(Pnt);
  P := PEnhLineTo.ptl;
  if FInPath then
  begin
    FPainter.AddLineToPath(SX(P.x, P.y), SY(P.x, P.y));
  end else
  begin
    if FHasPen then
    begin
      FPainter.DrawLine(FXPos, FYPos, SX(P.x, P.y), SY(P.X, P.Y));
    end;
    FXPos := SX(P.x, P.y);
    FYPos := SY(P.x, P.y);
    WFXPos := P.x;
    WFYPos := P.y;
  end;
end;

procedure TPDFMetafile.EmfPaintRgn(Pnt: PEnhMetaRecord);
begin
  // Not yet supported
end;

procedure TPDFMetafile.EmfPie(Pnt: PEnhMetaRecord);
var
  PEnhPie: PEMRPie;
  Width: Integer;
  Height: Integer;
  Angle1: Double;
  Angle2: Double;
  X1, Y1, X2, Y2, W, H: Double;
  CX, CY: Double;
begin
  PEnhPie := PEMRPie(Pnt);

  Width := PEnhPie.rclBox.Right - PEnhPie.rclBox.Left + 1;
  Height := (PEnhPie.rclBox.Bottom - PEnhPie.rclBox.Top + 1);

  CX := PEnhPie.rclBox.Left + Ceil(Width div 2);  // + RadiusX
  CY := PEnhPie.rclBox.Top + Ceil(Height div 2);  // + RadiusY

  X1 := PEnhPie.ptlStart.X;
  Y1 := PEnhPie.ptlStart.Y;
  X2 := PEnhPie.ptlEnd.X;
  Y2 := PEnhPie.ptlEnd.Y;

  CX := Sx(CX, CY);
  CY := Sy(CX, CY);
  X1 := Sx(X1, Y1);
  Y1 := Sy(X1, Y1);
  X2 := Sx(X2, Y2);
  Y2 := Sy(X2, Y2);
  H := Sh(Height);
  W := Sw(Width);

  Angle1 := CalcAngle(CX, CY, X1, Y1);
  Angle2 := CalcAngle(CX, CY, X2, Y2);

  if FArcDirection = 1 then
  begin
    FPainter.EllipticArc(Cx, Cy, W, H, Angle1, Angle2, True, FHasFill,
      FHasPen, False);
  end else
  begin
    FPainter.EllipticArc(Cx, Cy, W, H, Angle2, Angle1, True, FHasFill,
      FHasPen, False);
  end;
end;


procedure TPDFMetafile.EmfPolyBezier(Pnt: PEnhMetaRecord);
var
  PEnhPolyBezier: PEMRPolyBezier;
  PAL: TPointArray;
  Curv: TPointArray;
  CurvCount: Integer;
  X: Integer;
  NbPoints: Integer;
begin
  PEnhPolyBezier := PEMRPolyBezier(Pnt);
  CurvCount := 0;
  SetLength(Curv, 3);
  NbPoints := PEnhPolyBezier.cptl;
  if NbPoints > 0 then
  begin

    SetLength(PAL, NbPoints);
    Move(PEnhPolyBezier.aptl[0],
         PAL[0],
         PEnhPolyBezier.cptl * SizeOf(TPoint));
    if not FInPath then
    begin
      FPainter.StartPath(SX(PAL[0].x, PAL[0].y), SY(PAL[0].x, PAL[0].y));
    end else
    begin
      FPainter.MovePath(SX(PAL[0].x, PAL[0].y), SY(PAL[0].x, PAL[0].y));
    end;

    for x := 0 to Nbpoints - 1 do
    begin
      Curv[CurvCount] := PAL[X];
      CurvCount := CurvCount + 1;
      if CurvCount > 2 then
      begin
        CurvCount := 0;
        FPainter.AddCurveToPath(SX(Curv[0].x, Curv[0].y),
          SY(Curv[0].x, Curv[0].y), SX(Curv[1].x, Curv[1].y),
          SY(Curv[1].x, Curv[1].y), SX(Curv[2].x, Curv[2].y),
          SY(Curv[2].x, Curv[2].y));
      end;
    end;
    if not FInPath then
    begin
      if FFillMode = ALTERNATE then
      begin
        FPainter.DrawPathEvenOdd(FHasFill, FHasPen);
      end else
      begin
        FPainter.DrawPath(FHasFill, FHasPen);
      end;
    end;
  end;
end;

procedure TPDFMetafile.EmfPolyBezier16(Pnt: PEnhMetaRecord);
var
  PEnhPolyBezier16: PEMRPolyBezier16;
  PAS: TSmallPointArray;
  Curv: TSmallPointArray;
  CurvCount: Integer;
  X: Integer;
  NbPoints: Integer;
begin
  PEnhPolyBezier16 := PEMRPolyBezier16(Pnt);
  CurvCount := 0;
  SetLength(Curv, 3);
  NbPoints := PEnhPolyBezier16.cpts;
  if NbPoints > 0 then
  begin
    SetLength(PAS, NbPoints);
    Move(PEnhPolyBezier16.apts[0],
         PAS[0],
         NbPoints * SizeOf(TSmallPoint));
    if not FInPath then
    begin
      FPainter.StartPath(SX(PAS[0].x, PAS[0].y), SY(PAS[0].x, PAS[0].y));
    end else
    begin
      FPainter.MovePath(SX(PAS[0].x, PAS[0].y), SY(PAS[0].x, PAS[0].y));
    end;

    for x := 1 to Nbpoints - 1 do
    begin
      Curv[CurvCount] := PAS[X];
      CurvCount := CurvCount + 1;
      if CurvCount > 2 then
      begin
        CurvCount := 0;
        FPainter.AddCurveToPath(SX(Curv[0].x, Curv[0].y),
          SY(Curv[0].x, Curv[0].y), SX(Curv[1].x, Curv[1].y),
          SY(Curv[1].x, Curv[1].y), SX(Curv[2].x, Curv[2].y),
          SY(Curv[2].x, Curv[2].y));
      end;
    end;
    if not FInPath then
    begin
      if FFillMode = ALTERNATE then
      begin
        FPainter.DrawPathEvenOdd(FHasFill, FHasPen);
      end else
      begin
        FPainter.DrawPath(FHasFill, FHasPen);
      end;
    end;
  end;
end;

procedure TPDFMetafile.EmfPolyBezierTo16(Pnt: PEnhMetaRecord);
var
  PEnhPolyBezierTo16: PEMRPolyBezierTo16;
  SPA: TSmallPointArray;
  Curv: TSmallPointArray;
  CurvCount: Integer;
  X: Integer;
  NbPoints: Integer;
begin
  PEnhPolyBezierTo16 := PEMRPolyBezierTo16(Pnt);
  CurvCount := 0;
  SetLength(Curv, 3);
  NbPoints := PEnhPolyBezierTo16.cpts;
  if NbPoints > 0 then
  begin
    SetLength(SPA, PEnhPolyBezierTo16.cpts);
    Move(PEnhPolyBezierTo16.apts[0], SPA[0],
      PEnhPolyBezierTo16.cpts * SizeOf(TSmallPoint));

    if not FInPath then
    begin
      FPainter.StartPath(FXPos, FyPos);
    end;

    for X := 0 to Nbpoints - 1 do
    begin
      Curv[CurvCount] := SPA[X];
      CurvCount := CurvCount + 1;
      if CurvCount > 2 then
      begin
        CurvCount := 0;
        FPainter.AddCurveToPath(SX(Curv[0].x, Curv[0].y),
          SY(Curv[0].x, Curv[0].y), SX(Curv[1].x, Curv[1].y),
          SY(Curv[1].x, Curv[1].y), SX(Curv[2].x, Curv[2].y),
          SY(Curv[2].x, Curv[2].y));
      end;
    end;
    if not FInPath then
    begin
      if FFillMode = ALTERNATE then
      begin
        FPainter.DrawPathEvenOdd(FHasFill, FHasPen);
      end else
      begin
        FPainter.DrawPath(FHasFill, FHasPen);
      end;
    end;
    FXPos := SX(SPA[NbPoints - 1].x, SPA[NbPoints - 1].y);
    FYPos := SY(SPA[NbPoints - 1].x, SPA[NbPoints - 1].y);
    WFXPos := SPA[NbPoints - 1].x;
    WFYPos := SPA[NbPoints - 1].y;
  end;
end;

procedure TPDFMetafile.EmfPolyBezierTo(Pnt: PEnhMetaRecord);
var
  PEnhPolyBezierTo: PEMRPolyBezierTo;
  PAL: TPointArray;
  Curv: TPointArray;
  CurvCount: Integer;
  X: Integer;
  NbPoints: Integer;
begin
  PEnhPolyBezierTo := PEMRPolyBezierTo(Pnt);
  CurvCount := 0;
  SetLength(Curv, 3);
  NbPoints := PEnhPolyBezierTo.cptl;
  if NbPoints > 0 then
  begin
    SetLength(PAL, NbPoints);
    Move(PEnhPolyBezierTo.aptl[0], PAL[0],
      PEnhPolyBezierTo.cptl * SizeOf(TPoint));
    if not FInPath then
    begin
      FPainter.StartPath(FXPos, FyPos);
    end;
    for x := 0 to Nbpoints - 1 do
    begin
      Curv[CurvCount] := PAL[X];
      CurvCount := CurvCount + 1;
      if CurvCount > 2 then
      begin
        CurvCount := 0;
        FPainter.AddCurveToPath(SX(Curv[0].x, Curv[0].y),
          SY(Curv[0].x, Curv[0].y), SX(Curv[1].x, Curv[1].y),
          SY(Curv[1].x, Curv[1].y), SX(Curv[2].x, Curv[2].y),
          SY(Curv[2].x, Curv[2].y));
      end;
    end;
    if not FInPath then
    begin
      if FFillMode = ALTERNATE then
      begin
        FPainter.DrawPathEvenOdd(FHasFill, FHasPen);
      end else
      begin
        FPainter.DrawPath(FHasFill, FHasPen);
      end;
    end;
    FXPos := SX(PAL[NbPoints - 1].x, PAL[NbPoints - 1].y);
    FYPos := SY(PAL[NbPoints - 1].x, PAL[NbPoints - 1].y);
    WFXPos := PAL[NbPoints - 1].x;
    WFYPos := PAL[NbPoints - 1].y;
  end;
end;

procedure TPDFMetafile.EmfPolyDraw(Pnt: PEnhMetaRecord);
var
  PEnhPolyDraw: PEMRPolyDraw;
  NbPoints: Integer;
  PAL: TPointArray;
  TPA: array of Byte;
  X: Integer;
  Curv: TPointArray;
  CurvCount: Integer;
  PTPA: Pointer;
begin
  PEnhPolyDraw := PEMRPolyDraw(Pnt);
  NbPoints := PEnhPolyDraw.cptl;
  SetLength(Curv, 3);
  CurvCount := 0;
  SetLength(PAL, NbPoints);
  SetLength(TPA, NbPoints);
  Move(PEnhPolyDraw.aptl[0], PAL[0], NbPoints * SizeOf(TPoint));
  PTPA := Pointer(TQPLIntPtr(Pnt) + 28 + NbPoints * SizeOf(TSmallPoint));
  Move(PTPA^, TPA[0], NbPoints * SizeOf(Byte));
  for X := 0 to NbPoints - 1 do
  begin
    case TPA[X] of
      PT_MOVETO:
      begin
        if not FPathStarted then
        begin
          FPainter.StartPath(SX(PAL[X].x, PAL[X].y), SY(PAL[X].x, PAL[X].y));
          FPathStarted := True;
        end else
        begin
          FPainter.MovePath(SX(PAL[X].x, PAL[X].y), SY(PAL[X].x, PAL[X].y));
        end;
      end;

      PT_LINETO:
      begin
        FPainter.AddLineToPath(SX(PAL[X].x, PAL[X].y), SY(PAL[X].x, PAL[X].y));
      end;

      PT_BEZIERTO:
      begin
        Curv[CurvCount] := PAL[X];
        CurvCount := CurvCount + 1;
        if CurvCount > 2 then
        begin
          CurvCount := 0;
          FPainter.AddCurveToPath(SX(Curv[0].x, Curv[0].y),
            SY(Curv[0].x, Curv[0].y), SX(Curv[1].x, Curv[1].y),
            SY(Curv[1].x, Curv[1].y), SX(Curv[2].x, Curv[2].y),
            SY(Curv[2].x, Curv[2].y));
        end;
      end;

      PT_CLOSEFIGURE:
      begin
        FPainter.ClosePath;
      end;
    end;
  end;
  if not FInPath then
  begin
    if FFillMode = ALTERNATE then
    begin
      FPainter.DrawPathEvenOdd(FHasFill, FHasPen);
    end else
    begin
      FPainter.DrawPath(FHasFill, FHasPen);
    end;
  end;
end;

procedure TPDFMetafile.EmfPolyDraw16(Pnt: PEnhMetaRecord);
var
  PEnhPolyDraw16: PEMRPolyDraw16;
  NbPoints: Integer;
  SPA: TSmallPointArray;
  TPA: array of Byte;
  X: Integer;
  Curv: TSmallPointArray;
  CurvCount: Integer;
  PTPA: Pointer;
begin
  PEnhPolyDraw16 := PEMRPolyDraw16(Pnt);
  CurvCount := 0;
  NbPoints := PEnhPolyDraw16.cpts;
  SetLength(Curv, 3);
  SetLength(SPA, NbPoints);
  SetLength(TPA, NbPoints);
  Move(PEnhPolyDraw16.apts[0], SPA[0], NbPoints * SizeOf(TSmallPoint));
  PTPA := Pointer(TQPLIntPtr(Pnt) + 28 + NbPoints * SizeOf(TSmallPoint));
  Move(PTPA^, TPA[0], NbPoints  * SizeOf(Byte));

  for X := 0 to NbPoints - 1 do
  begin
    case TPA[X] of
      PT_MOVETO:
      begin
        if not FInPath then
        begin
          FPainter.StartPath(SX(SPA[X].x, SPA[X].y), SY(SPA[X].x, SPA[X].y));
        end else
        begin
          FPainter.MovePath(SX(SPA[X].x, SPA[X].y), SY(SPA[X].x, SPA[X].y));
        end;
      end;

      PT_LINETO:
      begin
        FPainter.AddLineToPath(SX(SPA[X].x, SPA[X].y), SY(SPA[X].x, SPA[X].y));
      end;

      PT_BEZIERTO:
      begin
        Curv[CurvCount] := SPA[X];
        CurvCount := CurvCount + 1;
        if CurvCount > 2 then
        begin
          CurvCount := 0;
          FPainter.AddCurveToPath(SX(Curv[0].x, Curv[0].y),
            SY(Curv[0].x, Curv[0].y), SX(Curv[1].x, Curv[1].y),
            SY(Curv[1].x, Curv[1].y), SX(Curv[2].x, Curv[2].y),
            SY(Curv[2].x, Curv[2].y));
        end;
      end;

      PT_CLOSEFIGURE:
      begin
        FPainter.ClosePath;
      end;

      PT_MOVETO + 1:
      begin
        if not FInPath then
        begin
          FPainter.StartPath(SX(SPA[X].x, SPA[X].y), SY(SPA[X].x, SPA[X].y));
        end else
        begin
          FPainter.MovePath(SX(SPA[X].x, SPA[X].y), SY(SPA[X].x, SPA[X].y));
        end;
        FPainter.ClosePath;
      end;

      PT_LINETO + 1:
      begin
        FPainter.AddLineToPath(SX(SPA[X].x, SPA[X].y), SY(SPA[X].x, SPA[X].y));
        FPainter.ClosePath;
      end;

      PT_BEZIERTO + 1:
      begin
        Curv[CurvCount] := SPA[X];
        CurvCount := CurvCount + 1;
        if CurvCount > 2 then
        begin
          CurvCount := 0;
          FPainter.AddCurveToPath(SX(Curv[0].x, Curv[0].y),
            SY(Curv[0].x, Curv[0].y), SX(Curv[1].x, Curv[1].y),
            SY(Curv[1].x, Curv[1].y), SX(Curv[2].x, Curv[2].y),
            SY(Curv[2].x, Curv[2].y));
        end;
        FPainter.ClosePath;
      end;
    end;
  end;

  if not FInPath then
  begin
    if FFillMode = ALTERNATE then
    begin
      FPainter.DrawPathEvenOdd(FHasFill, FHasPen);
    end else
    begin
      FPainter.DrawPath(FHasFill, FHasPen);
    end;
  end;
end;

procedure TPDFMetafile.EmfPolygon(Pnt: PEnhMetaRecord);
var
  PEnhPolygon: PEMRPolygon;
  PAL: TPointArray;
  X: Integer;
begin
  PEnhPolygon := PEMRPolygon(Pnt);
  SetLength(PAL, PEnhPolygon.cptl);
  if Length(PAL) > 0 then
  begin
    Move(PEnhPolygon.aptl[0],
         PAL[0],
         PEnhPolygon.cptl * SizeOf(TPoint));
    if FInPath then
    begin
      for X := 0 to Length(PAL) - 1 do
      begin
        if (not FPathStarted) then
        begin
          FPainter.StartPath(SX(PAL[0].x, PAL[0].y), SY(PAL[0].x, PAL[0].y));
          FPathStarted := True;
        end
        else
          FPainter.AddLineToPath(SX(PAL[X].x, PAL[X].y), SY(PAL[X].x, PAL[X].y));
      end;
    end else
    begin
      FPainter.StartPath(SX(PAL[0].x, PAL[0].y), SY(PAL[0].x, PAL[0].y));
      for X := 1 to Length(PAL) - 1 do
      begin
        FPainter.AddLineToPath(SX(PAL[X].x, PAL[X].y), SY(PAL[X].x, PAL[X].y));
      end;
      FPainter.ClosePath;
      if FFillMode = ALTERNATE then
      begin
        FPainter.DrawPathEvenOdd(FHasFill, FHasPen);
      end else
      begin
        FPainter.DrawPath(FHasFill, FHasPen);
      end;
    end;
  end;
end;

procedure TPDFMetafile.EmfPolygon16(Pnt: PEnhMetaRecord);
var
  PEnhPolygon16: PEMRPolygon16;
  SPA: TSmallPointArray;
  X: Integer;
begin
  PEnhPolygon16 := PEMRPolygon16(Pnt);
  SetLength(SPA, PEnhPolygon16.cpts);
  if Length(SPA) > 0 then
  begin
    Move(PEnhPolygon16.apts[0], SPA[0],
      PEnhPolygon16.cpts * SizeOf(TSmallPoint));

    if FInPath then
    begin
      if (not FPathStarted) then
      begin
        FPainter.StartPath(SX(SPA[0].x, SPA[0].y), SY(SPA[0].x, SPA[0].y));
        FPathStarted := True;
      end;

      for X := 0 to Length(SPA) - 1 do
      begin
        FPainter.AddLineToPath(SX(SPA[X].x, SPA[X].y), SY(SPA[X].x, SPA[X].y));
      end;
    end else
    begin
      FPainter.StartPath(SX(SPA[0].x, SPA[0].y), SY(SPA[0].x, SPA[0].y));
      for X := 1 to Length(SPA) - 1 do
      begin
        FPainter.AddLineToPath(SX(SPA[X].x, SPA[X].y), SY(SPA[X].x, SPA[X].y));
      end;
      FPainter.ClosePath;
      if FFillMode = ALTERNATE then
      begin
        FPainter.DrawPathEvenOdd(FHasFill, FHasPen);
      end else
      begin
        FPainter.DrawPath(FHasFill, FHasPen);
      end;
    end;
  end;
end;

procedure TPDFMetafile.EmfPolyLine(Pnt: PEnhMetaRecord);
var
  PEnhPolyLine: PEMRPolyLine;
  PAL: TPointArray;
  X: Integer;
  NbPoints: Integer;
begin
  PEnhPolyLine := PEMRPolyLine(Pnt);
  NbPoints := PEnhPolyLine.cptl;
  if NbPoints > 0 then
  begin
    SetLength(PAL, NbPoints);
    Move(PEnhPolyLine.aptl[0], PAL[0], PEnhPolyLine.cptl * SizeOf(TPoint));

    if FInPath then
    begin
      for X := 0 to NbPoints - 1 do
      begin
        FPainter.AddLineToPath(SX(PAL[X].x, PAL[X].y), SY(PAL[X].x, PAL[X].y));
      end;
    end else
    begin
      FPainter.StartPath(SX(PAL[0].x, PAL[0].y), SY(PAL[0].x, PAL[0].y));
      for X := 1 to NbPoints - 1 do
      begin
        FPainter.AddLineToPath(SX(PAL[X].x, PAL[X].y), SY(PAL[X].x, PAL[X].y));
      end;
      FPainter.ClosePath;
      FPainter.DrawPath(FHasFill, FHasPen);
    end;
  end;
end;

procedure TPDFMetafile.EmfPolyLine16(Pnt: PEnhMetaRecord);
var
  PEnhPolyLine16: PEMRPolyLine16;
  SPA: TSmallPointArray;
  X: Integer;
  NbPoints: Integer;
begin
  PEnhPolyLine16 := PEMRPolyLine16(Pnt);
  NbPoints := PEnhPolyLine16.cpts;
  if NbPoints > 0 then
  begin
    SetLength(SPA, NbPoints);
    Move(PEnhPolyLine16.apts[0], SPA[0], PEnhPolyLine16.cpts *
      SizeOf(TSmallPoint));

    if FInPath and FPathStarted then
    begin
      for X := 0 to NbPoints - 1 do
      begin
        FPainter.AddLineToPath(SX(SPA[X].x, SPA[X].y), SY(SPA[X].x, SPA[X].y));
      end;
    end else
    begin
      FPainter.StartPath(SX(SPA[0].x, SPA[0].y), SY(SPA[0].x, SPA[0].y));
      for X := 1 to NbPoints - 1 do
        FPainter.AddLineToPath(SX(SPA[X].x, SPA[X].y), SY(SPA[X].x, SPA[X].y));
      FPainter.DrawPath(FHasFill, FHasPen);
    end;
  end;
end;

procedure TPDFMetafile.EmfPolyLineTo(Pnt: PEnhMetaRecord);
var
  PEnhPolyLineTo: PEMRPolyLineTo;
  PAL: TPointArray;
  X: Integer;
  NbPoints: Integer;
begin
  PEnhPolyLineTo := PEMRPolyLineTo(Pnt);
  NbPoints := PEnhPolyLineTo.cptl;
  if NbPoints > 0 then
  begin
    SetLength(PAL, NbPoints);
    Move(PEnhPolyLineTo.aptl[0], PAL[0], PEnhPolyLineTo.cptl * SizeOf(TPoint));
    if FInPath then
    begin
      for X := 0 to NbPoints - 1 do
      begin
        FPainter.AddLineToPath(SX(PAL[X].x, PAL[X].y), SY(PAL[X].x, PAL[X].y));
      end;
    end else
    begin

      if (PAL[0].y = PAL[1].y) then
        FHasPen := False;


      FPainter.StartPath(SX(PAL[0].x, PAL[0].y), SY(PAL[0].x, PAL[0].y));
      for X := 1 to NbPoints do
        FPainter.AddLineToPath(SX(PAL[X].x, PAL[X].y), SY(PAL[X].x, PAL[X].y));
      FPainter.ClosePath;
      FPainter.DrawPath(False, True);
    end;
    FXPos := SX(PAL[NbPoints - 1].x, PAL[NbPoints - 1].y);
    FYPos := SY(PAL[NbPoints - 1].x, PAL[NbPoints - 1].y);
    WFXPos := PAL[NbPoints - 1].x;
    WFYPos := PAL[NbPoints - 1].y;
  end;
end;

procedure TPDFMetafile.EmfPolyLineTo16(Pnt: PEnhMetaRecord);
var
  PEnhPolyLineTo16: PEMRPolyLineTo16;
  SPA: TSmallPointArray;
  X: Integer;
  NbPoints: Integer;
begin
  PEnhPolyLineTo16 := PEMRPolyLineTo16(Pnt);
  NbPoints := PEnhPolyLineTo16.cpts;
  if NbPoints > 0 then
  begin
    SetLength(SPA, NbPoints);
    Move(PEnhPolyLineTo16.apts[0], SPA[0],
      PEnhPolyLineTo16.cpts * SizeOf(TSmallPoint));
    if FInPath then
    begin
      for X := 0 to NbPoints - 1 do
      begin
        FPainter.AddLineToPath(SX(SPA[X].x, SPA[X].y), SY(SPA[X].x, SPA[X].y));
      end;
    end else
    begin
      FPainter.StartPath(SX(SPA[0].x, SPA[0].y), SY(SPA[0].x, SPA[0].y));
      for X := 1 to NbPoints - 1 do
      begin
        FPainter.AddLineToPath(SX(SPA[X].x, SPA[X].y), SY(SPA[X].x, SPA[X].y));
      end;
      FPainter.ClosePath;
      FPainter.DrawPath(False, True);
    end;
    FXPos := SX(SPA[NbPoints - 1].x, SPA[NbPoints - 1].y);
    FYPos := SY(SPA[NbPoints - 1].x, SPA[NbPoints - 1].y);
    WFXPos := SPA[NbPoints - 1].x;
    WFYPos := SPA[NbPoints - 1].y;
  end;
end;

procedure TPDFMetafile.EmfPolyPolygon(Pnt: PEnhMetaRecord);
var
  PEnhPolyPolygon: PEMRPolyPolygon;
  X: Integer;
  Y: Integer;
  Z: Integer;
  PAL: TPointArray;
  PALA: TPointArrayArray;
  NbPoints: Integer;
  NbPolys: Integer;
  Offset: Integer;
  Counts: array of Cardinal;
  PPnt: Pointer;
begin
  PEnhPolyPolygon := PEMRPolyPolygon(Pnt);
  NbPoints := PEnhPolyPolygon.cptl;
  NbPolys := PEnhPolyPolygon.nPolys;
  if NbPolys > 0 then
  begin
    SetLength(Counts, NbPolys);
    Move(PEnhPolyPolygon.aPolyCounts[0], Counts[0], NbPolys * SizeOf(Cardinal));
    SetLength(PAL, NbPoints);

    PPnt := Pointer(TQPLIntPtr(Pnt) + 32 + NbPolys * SizeOf(Cardinal));
    Move(PPnt^, PAL[0], NbPoints * SizeOf(TPoint));

    SetLength(PALA, NbPolys);
    Offset := 0;
    for Z := 0 to NbPolys - 1 do
    begin
      SetLength(PALA[Z], Counts[Z]);
      if Length(PALA[Z]) > 0 then
      begin
        Move(PAL[Offset], PALA[Z, 0], Counts[Z] * SizeOf(TPoint));
      end;
      Inc(Offset, Counts[Z]);
    end;

    FPathStarted := False;
    for X := 0 to NbPolys - 1 do
    begin
      if (not FPathStarted) then
      begin
        FPainter.StartPath(SX(PALA[X, 0].x, PALA[X, 0].y), SY(PALA[X, 0].x,
          PALA[X, 0].y));
        FPathStarted := True;
      end
      else
        FPainter.MovePath(SX(PALA[X, 0].x, PALA[X, 0].y), SY(PALA[X, 0].x,
          PALA[X, 0].y));

      for Y := 0 to Length(PALA[X]) - 1 do
      begin
        FPainter.AddLineToPath(SX(PALA[X, Y].x, PALA[X, Y].y),
          SY(PALA[X, Y].x, PALA[X, Y].y));
      end;
    end;

    FPainter.ClosePath;
    if FFillMode = ALTERNATE then
    begin
      FPainter.DrawPathEvenOdd(FHasFill, FHasPen);
    end else
    begin
      FPainter.DrawPath(FHasFill, FHasPen);
    end;
    FInPath := False;
  end;
end;

procedure TPDFMetafile.EmfPolyPolyLine(Pnt: PEnhMetaRecord);
var
  PEnhPolyPolyLine: PEMRPolyPolyLine;
  X: Integer;
  Z: Integer;
  PAL: TPointArray;
  PALA: TPointArrayArray;
  NbPoints: Integer;
  NbPolys: Integer;
  Offset: Integer;
  Counts: array of Cardinal;
  PosX, PosY: Integer;
begin
  PEnhPolyPolyLine := PEMRPolyPolyLine(Pnt);
  NbPoints := PEnhPolyPolyLine.cptl +
             PEnhPolyPolyLine.nPolys - 1;
  NbPolys := PEnhPolyPolyLine.nPolys;
  PosX := 0;
  PosY := 0;
  if NbPoints > 0 then
  begin
    SetLength(PAL, NbPoints);
    Move(PEnhPolyPolyLine.aptl[0],
         PAL[0],
         NbPoints * SizeOf(TPoint));
    SetLength(PALA, NbPolys);
    Offset := NbPolys - 1;
    SetLength(Counts, NbPolys);
    if Length(Counts) > 0 then
    begin
      Move(PEnhPolyPolyLine.aPolyCounts[0], Counts[0],
        NbPolys * SizeOf(Cardinal));
    end;

    for Z := 0 to NbPolys - 1 do
    begin
      SetLength(PALA[Z], Counts[Z]);
      if Length(PALA[Z]) > 0 then
      begin
        Move(PAL[Offset], PALA[Z, 0], Counts[Z] * SizeOf(TPoint));
      end;
      Inc(Offset, Counts[Z]);
      begin
        for X := 0 to Length(PALA) - 1 do
        begin
          if (X mod 2) = 0 then
          begin
            PosX := PALA[X, 0].x;
            PosY := PALA[X, 1].y;
          end else
          begin
            FPainter.DrawLine(Sx(PosX, PosY), Sy(PosX, PosY), Sx(PALA[X, 0].x,
              PALA[X, 0].y), Sy(PALA[X, 0].x, PALA[X, 0].y));
          end
        end;
      end;
    end;
  end;
end;

procedure TPDFMetafile.EmfPolyPolyLine16(Pnt: PEnhMetaRecord);
var
  PEnhPolyPolyLine16: PEMRPolyPolyLine16;
  X: Integer;
  Z: Integer;
  SPA: TSmallPointArray;
  SPAA: TSmallPointArrayArray;
  NbPoints: Integer;
  NbPolys: Integer;
  Offset: Integer;
  Counts: array of Cardinal;
begin
  PEnhPolyPolyLine16 := PEMRPolyPolyLine16(Pnt);
  NbPoints := PEnhPolyPolyLine16.cpts + PEnhPolyPolyLine16.nPolys - 1;
  NbPolys := PEnhPolyPolyLine16.nPolys;
  if NbPoints > 0 then
  begin
    SetLength(SPA, NbPoints);
    Move(PEnhPolyPolyLine16.apts[0], SPA[0], NbPoints * SizeOf(TSmallPoint));
    SetLength(SPAA, NbPolys);
    Offset := NbPolys - 1;
    SetLength(Counts, NbPolys);
    if Length(Counts) > 0 then
    begin
      Move(PEnhPolyPolyLine16.aPolyCounts[0], Counts[0],
        NbPolys * SizeOf(Cardinal));
    end;
    for Z := 0 to NbPolys - 1 do
    begin
      SetLength(SPAA[Z], Counts[Z]);
      if Length(SPAA[Z]) > 0 then
      begin
        Move(SPA[Offset], SPAA[Z, 0], Counts[Z] * SizeOf(TSmallPoint));
      end;
      Inc(Offset, Counts[Z]);
      begin
        for X := 0 to Counts[Z] - 2 do  
          FPainter.DrawLine(Sx(SPAA[Z, X].x,   SPAA[Z, X].y),
                            Sy(SPAA[Z, X].x,   SPAA[Z, X].y),
                            Sx(SPAA[Z, X+1].x, SPAA[Z, X+1].y),
                            Sy(SPAA[Z, X+1].x, SPAA[Z, X+1].y));
      end;
    end;
  end;
end;

procedure TPDFMetafile.EmfPolyTextOutA(Pnt: PEnhMetaRecord);
var
  PEnhPolyTextOutA: PEMRPolyTextOut;
  NbTexts: Integer;
  AEmrTexts: array of tagEmrText;
  Z: Integer;
  OffString: Integer;
  OffDx: Integer;
  TextP: Pointer;
  TextA: AnsiString;
  CharsCount: Integer;
  X, Y: Integer;
  Offsets: array of Double;
  OffsetsP: Pointer;
  I, J: Integer;
begin
  PEnhPolyTextOutA := PEMRPolyTextOut(Pnt);
  NbTexts := PEnhPolyTextOutA.cStrings;
  if NbTexts > 0 then
  begin
    SetLength(AEmrTexts, NbTexts);
    Move(PEnhPolyTextOutA.aemrtext[0], AEmrTexts[0],
      NbTexts * SizeOf(tagEmrText));
    if not Assigned(FSelFont) then
    begin
      FSelFont := CreateStockFont('MS Sans Serif', False, False, 10);
    end;
    for Z := 0 to NbTexts - 1 do
    begin
      CharsCount := AEmrTexts[Z].nChars;
      if CharsCount > 0  then
      begin
        OffDx := AEmrTexts[Z].offDx;
        if (OffDx <> 0) and Enhanced then
        begin
          SetLength(Offsets, CharsCount);
          for I := 0 to CharsCount - 1 do
          begin
            OffsetsP := Pointer(TQPLIntPtr(Pnt) + OffDx + (I * 4));
            Move(OffsetsP^, J, 4);
            Offsets[I] := Sw(J);
          end;
        end else
        begin
          SetLength(Offsets, 0);
        end;

        X := AEmrTexts[Z].ptlReference.X;
        Y := AEmrTexts[Z].ptlReference.Y;
        OffString := AEmrTexts[Z].offString;
        SetLength(TextA, CharsCount);
        TextP := Pointer(TQPLIntPtr(Pnt) + OffString);
        Move(TextP^, TextA[1], Length(TextA));
        TextOut(X, Y, WideString(TextA), Offsets, False);
      end;
    end;
  end;
end;

procedure TPDFMetafile.EmfPolyTextOutW(Pnt: PEnhMetaRecord);
var
  PEnhPolyTextOutW: PEMRPolyTextOut;
  NbTexts: Integer;
  AEmrTexts: array of tagEmrText;
  Z: Integer;
  OffString: Integer;
  OffDx: Integer;
  TextP: Pointer;
  TextW: WideString;
  Text: AnsiString;
  CharsCount: Integer;
  X, Y: Integer;
  Offsets: array of Double;
  OffsetsP: Pointer;
  I, J: Integer;
  OutputFlag: Cardinal;
  S: WideString;
  C: Word;
begin
  PEnhPolyTextOutW := PEMRPolyTextOut(Pnt);

  J := FSelFont.InitChar - 1;

  NbTexts := PEnhPolyTextOutW.cStrings;
  if NbTexts > 0 then
  begin
    if not Assigned(FSelFont) then
    begin
      FSelFont := CreateStockFont('MS Sans Serif', False, False, 10);
    end;
    SetLength(AEmrTexts, NbTexts);
    Move(PEnhPolyTextOutW.aemrtext[0], AEmrTexts[0],
      NbTexts * SizeOf(tagEmrText));
    for Z := 0 to NbTexts - 1  do
    begin
      CharsCount := AEmrTexts[Z].nChars;
      if CharsCount > 0  then
      begin
        OutputFlag := AEmrTexts[Z].fOptions;
        OffDx := AEmrTexts[Z].offDx;
        if (OffDx <> 0) and Enhanced then
        begin
          SetLength(Offsets, CharsCount);
          if (OutputFlag and ETO_PDY) = ETO_PDY then
          begin
            for I := 0 to CharsCount - 1 do
            begin
              OffsetsP := Pointer(TQPLIntPtr(Pnt) + OffDx + (I * 2 * 4));
              Move(OffsetsP^, J, 4);
              Offsets[I] := Sw(J);
            end;
          end else
          begin
            for I := 0 to CharsCount - 1 do
            begin
              OffsetsP := Pointer(TQPLIntPtr(Pnt) + OffDx + (I * 4));
              Move(OffsetsP^, J, 4);
              Offsets[I] := Sw(J);
            end;
          end;
        end else
        begin
          SetLength(Offsets, 0);
        end;
        
        X := AEmrTexts[Z].ptlReference.X;
        Y := AEmrTexts[Z].ptlReference.Y;
        OffString := AEmrTexts[Z].offString;
        TextP := Pointer(TQPLIntPtr(Pnt) + OffString);
        if FFntCharSet = '1' then
        begin
          SetLength(TextW, CharsCount);
          Move(TextP^, TextW[1], Length(TextW) * 2);
          if (OutputFlag and ETO_GLYPH_INDEX) = ETO_GLYPH_INDEX then
          begin
            for I := 1 to CharsCount do
            begin
              C := FSelFont.GetGIDToCID(Ord(TextW[I]));
              if (C <> 65535) then
                S := S + WideChar(C);
            end;
            TextOut(X, Y, S, Offsets, False);
          end else
          begin
            TextOut(X, Y, TextW, Offsets, False);
          end;
        end else
        begin
          SetLength(Text, CharsCount);
          Move(TextP^, Text[1], Length(Text));
          if (OutputFlag and ETO_GLYPH_INDEX) = ETO_GLYPH_INDEX then
          begin
            for I := 1 to CharsCount do
            begin
              C := FSelFont.GetGIDToCID(Ord(Text[I]));
              if (C <> 65535) then
                S := S + WideChar(C);
            end;
            TextOut(X, Y, S, Offsets, False);
          end else
          begin
            TextOut(X, Y, TextW, Offsets, False);
          end;
        end;
      end;
    end;
  end;
end;

procedure TPDFMetafile.EmfRectangle(Pnt: PEnhMetaRecord);
var
  PEnhRectangle: PEMRRectangle;
  Rect: TRect;
begin
  PEnhRectangle := PEMRRectangle(Pnt);
  Rect := PEnhRectangle.rclBox;
  if FHasFill or FHasPen then
  begin
    FPainter.Rectangle(SX(Rect.Left, Rect.Top), SY(Rect.Left, Rect.Top),
      Sw(Rect.Right - Rect.Left), Sh(Rect.Bottom - Rect.Top),
      FHasFill, FHasPen);
  end;
end;

procedure TPDFMetafile.EmfRoundRect(Pnt: PEnhMetaRecord);
var
  PEnhRoundRect: PEMRRoundRect;
  Rect: TRect;
  RadiusX: Integer;
  RadiusY: Integer;
begin
  PEnhRoundRect := PEMRRoundRect(Pnt);
  Rect := PEnhRoundRect.rclBox;
  RadiusX := Round(PEnhRoundRect.szlCorner.cX/2);
  RadiusY := Round(PEnhRoundRect.szlCorner.cy/2);
  if FHasFill or FHasPen then
   FPainter.RoundedRect(Sx(Rect.Left, Rect.Top),
                             Sy(Rect.Left, Rect.Top),
                             Sw(Rect.Right - Rect.Left),
                             Sh(Rect.Bottom - Rect.Top),
                             Sw(RadiusX),
                             Sh(RadiusY),
                             FHasFill,
                             FHasPen);
end;

procedure TPDFMetafile.EmfSetPixelV(Pnt: PEnhMetaRecord);
var
  PEnSetPixelV: PEMRSetPixelV;
  Pt: TPoint;
  Color: Integer;
  SavFillColor: AnsiString;
  Width, Height: Integer;
begin
  PEnSetPixelV := PEMRSetPixelV(Pnt);
  Pt := PEnSetPixelV.ptlPixel;
  Color := PEnSetPixelV.crColor;
  SavFillColor := FPainter.FillColor;
  Color := CalcColor(Color);
  Width := 3;
  Height := 3;
  FPainter.SetFillColor((Color and $FF) / 255,
                        ((Color and $FF00) shr 8) / 255,
                        ((Color and $FF0000) shr 16) / 255);
  FPainter.Rectangle(sx(Pt.X - 1, Pt.Y - 1), sy(Pt.X - 1, Pt.Y - 1),
                     sw(Width), sh(Height),
                     True, False);
  FPainter.SetFillColor(SavFillColor);
end;

procedure TPDFMetafile.EmfSmallTextOut(Pnt: PEnhMetaRecord);
const
  ETO_NO_RECT = $100;
  ETO_SMALL_CHARS = $200;

var
  Pointer1: Pointer;
  Pointer2: Pointer;
  X: Integer;
  PEnhSmallTextOut: PEMRSmallTextOut;
  PEnhSmallTextOut2: PEMRSmallTextOut2;
  TextP: Pointer;
  TextW: WideString;
  TextA: AnsiString;
  Offsets: array of Double;
  I: Integer;
  OutputFlag: Cardinal;
  C: Word;

begin
  SetLength(Offsets, 0);
  Pointer1 := Pointer(Pnt);
  Pointer2 := @PEnhSmallTextOut;
  X := SizeOf(PEnhSmallTextOut);
  Move(Pointer1^, Pointer2^, X);

  OutputFlag := PEnhSmallTextOut.fuOptions;

  FPainter.SelectFont(FSelFont, Abs(Sw(Round(FFntSize))));

  if (PEnhSmallTextOut.fuOptions and ETO_NO_RECT) <> ETO_NO_RECT then
  begin
    X := SizeOf(PEnhSmallTextOut2);
    Pointer2 := @PEnhSmallTextOut2;
    Move(Pointer1^, Pointer2^, X);
  end;
  TextP := Pointer(TQPLIntPtr(Pnt) + X);
  if (PEnhSmallTextOut.fuOptions and ETO_SMALL_CHARS) = ETO_SMALL_CHARS then
  begin
    if PEnhSmallTextOut.cChars > 0 then
    begin
      SetLength(TextA, PEnhSmallTextOut.cChars);
      SetLength(TextW, PEnhSmallTextOut.cChars);
      Move(TextP^, TextA[1], Length(TextA));

      if (OutputFlag and ETO_GLYPH_INDEX) = ETO_GLYPH_INDEX then
      begin
        for I := 1 to PEnhSmallTextOut.cChars do
        begin
          C := FSelFont.GetGIDToCID(Ord(TextA[I]));
          if (C <> 65535) then
            TextW[I] := WideChar(C);
        end;
      end
      else
        TextW := WideString(TextA);

      TextOut(PEnhSmallTextOut.x, PEnhSmallTextOut.y, TextW, Offsets, False);
    end;
  end else
  begin
    if PEnhSmallTextOut.cChars > 0 then
    begin
      SetLength(TextW, PEnhSmallTextOut.cChars);
      Move(TextP^, TextW[1], Length(TextW) * 2);

      if (OutputFlag and ETO_GLYPH_INDEX) = ETO_GLYPH_INDEX then
      begin
        for I := 1 to PEnhSmallTextOut.cChars do
        begin
          C := FSelFont.GetGIDToCID(Ord(TextW[I]));
          if (C <> 65535) then
            TextW := WideChar(C);
        end;
      end;
      TextOut(PEnhSmallTextOut.x, PEnhSmallTextOut.y, TextW, Offsets, False);
      end;
  end;
end;

procedure TPDFMetafile.EmfStrokeAndFillPath(Pnt: PEnhMetaRecord);
begin
  FPainter.DrawPath(True, True);
end;

procedure TPDFMetafile.EmfStrokePath(Pnt: PEnhMetaRecord);
begin
 FPainter.DrawPath(False, True);
end;

procedure TPDFMetafile.EmfPolyPolygon16(Pnt: PEnhMetaRecord);
var
  PEnhPolyPolygon16: PEMRPolyPolygon16;
  X, Y, Z: Integer;
  SPA: TSmallPointArray;
  SPAA: TSmallPointArrayArray;
  NbPoints: Integer;
  NbPolys: Integer;
  Offset: Integer;
  Counts: array of Cardinal;
  PPnt: Pointer;
begin
  PEnhPolyPolygon16 := PEMRPolyPolygon16(Pnt);
  NbPoints := PEnhPolyPolygon16.cpts;
  NbPolys := PEnhPolyPolygon16.nPolys;

  if NbPolys > 0 then
  begin
    SetLength(Counts, NbPolys);
    Move(PEnhPolyPolygon16.aPolyCounts[0], Counts[0],
      NbPolys * SizeOf(Cardinal));
    SetLength(SPA, NbPoints);

    PPnt := Pointer(TQPLIntPtr(Pnt) + 32 + NbPolys * SizeOf(Cardinal));
    Move(PPnt^, SPA[0], NbPoints * SizeOf(TSmallPoint));

    SetLength(SPAA, NbPolys);
    Offset := 0;
    for Z := 0 to NbPolys - 1 do
    begin
      SetLength(SPAA[Z], Counts[Z]);
      if Length(SPAA[Z]) > 0 then
      begin
        Move(SPA[Offset], SPAA[Z, 0], Counts[Z] * SizeOf(TSmallPoint));
      end;
      Inc(Offset, Counts[Z]);
    end;

    FPathStarted := False;
    for X := 0 to NbPolys - 1 do
    begin
      if (not FPathStarted) then
      begin
        FPainter.StartPath(SX(SPAA[X, 0].x, SPAA[X, 0].y), SY(SPAA[X, 0].x,
          SPAA[X, 0].y));
        FPathStarted := True;
      end
      else
        FPainter.MovePath(SX(SPAA[X, 0].x, SPAA[X, 0].y), SY(SPAA[X, 0].x,
          SPAA[X, 0].y));

      for Y := 0 to Length(SPAA[X]) - 1 do
      begin
        FPainter.AddLineToPath(SX(SPAA[X, Y].x, SPAA[X, Y].y),
          SY(SPAA[X, Y].x, SPAA[X, Y].y));
      end;
    end;

    FPainter.ClosePath;
    if FFillMode = ALTERNATE then
    begin
      FPainter.DrawPathEvenOdd(FHasFill, FHasPen);
    end else
    begin
      FPainter.DrawPath(FHasFill, FHasPen);
    end;
    FInPath := False;
   end;
end;

// Escape functions

procedure TPDFMetafile.EmfDrawEscape(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfExtEscape(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfNamedEscape(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

// Object creation functions

procedure TPDFMetafile.EmfCreateBrushIndirect(Pnt: PEnhMetaRecord);
var
  PEnhCreateBrushIndirect: PEMRCreateBrushIndirect;
  S: AnsiString;
  Handle: Cardinal;
  PatternName: AnsiString;
  Pattern: TPDFPattern;
{$IFDEF QPL_XE2_HIGHER}
  LogBrush: TLogBrush32;
{$ELSE}
  LogBrush: TLogBrush;
{$ENDIF}
  Color: Integer;
begin
  PEnhCreateBrushIndirect := PEMRCreateBrushIndirect(Pnt);
  Handle := PEnhCreateBrushIndirect.ihBrush;
  LogBrush := PEnhCreateBrushIndirect.lb;

  Color := LogBrush.lbColor;
  if (LogBrush.lbStyle = BS_HATCHED) then
  begin
    PatternName := 'QPLP' + QPLRandomID;
    Pattern := TPDFPattern.Create(FStructure, PatternName);
    Pattern.Handle := Handle;
    Pattern.Bitmap := GetBitmap3(LogBrush.lbHatch);
    FIncludedPatterns.Add(Pattern);

    S := 'ImgPtn|' + PatternName;
    FBrushes.AddObject(S, TObject(Handle));
  end else
  begin
    Color := CalcColor(Color);
    FPainter.SetFillColor((Color and $FF) / 255, ((Color and $FF00) shr 8) / 255,
      ((Color and $FF0000) shr 16) / 255);
    if LogBrush.lbStyle = BS_NULL then
    begin
      S := 'None';
    end else
    begin
      S := 'Plain|' + FPainter.FillColor + '|' + QPLIntToStr(Color);
    end;
  end;
  FBrushes.AddObject(S, TObject(Handle));
end;

procedure TPDFMetafile.EmfCreateColorSpace(Pnt: PEnhMetaRecord);
begin
  // Not yet supported
end;

procedure TPDFMetafile.EmfCreateColorSpaceW(Pnt: PEnhMetaRecord);
begin
  // Not yet supported
end;

procedure TPDFMetafile.EmfCreateDibPatternBrushPT(Pnt: PEnhMetaRecord);
var
  PEnhCreateDibPatternBrushPT: PEMRCreateDibPatternBrushPT;
  S: AnsiString;
  Handle: Cardinal;
  offBmi: Integer;
  offBits: Integer;
  cbBmi: Integer;
  PatternName: AnsiString;
  Pattern: TPDFPattern;
begin
  PEnhCreateDibPatternBrushPT := PEMRCreateDibPatternBrushPT(Pnt);
  Handle := PEnhCreateDibPatternBrushPT.ihBrush;
  offBmi := Integer(PEnhCreateDibPatternBrushPT.offBmi);
  offBits := Integer(PEnhCreateDibPatternBrushPT.offBits);
  cbBmi := Integer(PEnhCreateDibPatternBrushPT.cbBmi);

  if cbBmi > 1064 then
  begin
    cbBmi := 1064;
  end;

  try
    PatternName := 'QPLP' + QPLRandomID;
    Pattern := TPDFPattern.Create(FStructure, PatternName);
    Pattern.Handle := Handle;
    Pattern.Bitmap := GetBitmap2(Pnt, offBmi, offBits, cbBmi);
    FIncludedPatterns.Add(Pattern);
  finally
  end;

  S := 'ImgPtn|' + PatternName;
  FBrushes.AddObject(S, TObject(Handle));
end;

procedure TPDFMetafile.EmfCreateMonoBrush(Pnt: PEnhMetaRecord);
var
  PEnhCreateMonoBrush: PEMRCreateMonoBrush;
  S: AnsiString;
  Handle: Cardinal;
  offBmi: Integer;
  offBits: Integer;
  cbBmi: Integer;
  PatternName: AnsiString;
  Pattern: TPDFPattern;
begin
  PEnhCreateMonoBrush := PEMRCreateMonoBrush(Pnt);
  Handle := PEnhCreateMonoBrush.ihBrush;
  offBmi := Integer(PEnhCreateMonoBrush.offBmi);
  offBits := Integer(PEnhCreateMonoBrush.offBits);
  cbBmi := Integer(PEnhCreateMonoBrush.cbBmi);
  if cbBmi > 1064 then
  begin
    cbBmi := 1064;
  end;

  try
    PatternName := 'QPLP' + QPLRandomID;
    Pattern := TPDFPattern.Create(FStructure, PatternName);
    Pattern.Handle := Handle;
    Pattern.Bitmap := GetBitmap2(Pnt, offBmi, offBits, cbBmi);
    FIncludedPatterns.Add(Pattern);
  finally
  end;

  S := 'ImgPtn|' + PatternName;
  FBrushes.AddObject(S, TObject(Handle));
end;

procedure TPDFMetafile.EmfCreatepalette(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfCreatePen(Pnt: PEnhMetaRecord);
var
  PEnhCreatePen: PEMRCreatePen;
  LogPen: TLogPen;
  Color: Integer;
  Handle: Cardinal;
  S: AnsiString;
begin
  PEnhCreatePen := PEMRCreatePen(Pnt);
  LogPen := PEnhCreatePen.lopn;
  Color := CalcColor(LogPen.lopnColor);
  Handle := PEnhCreatePen.ihPen;
  FPainter.SetLineColor((Color and $FF) / 255, ((Color and $FF00) shr 8) / 255,
    ((Color and $FF0000) shr 16) / 255);

  FPainter.SetLineWidth(Abs(Sh(LogPen.lopnWidth.X)));

  FPainter.SetMiterLimit(FMiterLimit);
  FPainter.SetLineCap(1);
  FPainter.SetLineJoin(1);

  S := 'None';
  if ((LogPen.lopnStyle and $FF) <> PS_NULL) then
  begin
    S := 'Simple|' + FPainter.LineColor + '|' +
                     QPLFloatToStr(FPainter.GetLineWidth) + '|' +
                     QPLIntToStr(Color);

    case (LogPen.lopnStyle and $FF) of
      PS_SOLID:         S := S + '||1|1';
      PS_DASH:          S := S + '|3 3|1|1';
      PS_DASHDOT:       S := S + '|3 1 1 1|1|1';
      PS_DOT:           S := S + '|1|1|1';
      PS_DASHDOTDOT:    S := S + '|3 1 1 1 1 1|1|1';
      $08:              S := S + '|1 1|0|0';  {PS_ALTERNAME}
    else
      S := S + '||1|1';  // PS_SOLID | PS_ENDCAP_ROUND | PS_LINEJOIN_ROUND
    end;
  end;

  FPens.AddObject(S, TObject(Handle));
end;

procedure TPDFMetafile.EmfExtCreateFontIndirectW(Pnt: PEnhMetaRecord);
var
  PEnhExtCreateFontIndirect: PEMRExtCreateFontIndirect;
  Handle: Cardinal;
  FontName: AnsiString;
  FontBold: Boolean;
  FontItalic: Boolean;
  FontUnderLine: Boolean;
  FontStrikeOut: Boolean;
  Size: Double;
  TextScaling: Double;
  Fnt: TPDFFont;
  AName: AnsiString;
  FntName: AnsiString;
  FontFound: Boolean;
  iPnt: Integer;
  CharSet: AnsiString;
  Angle: Double;
  Found: Boolean;
  PitchAndFamily: Byte;
  EmbedThisFont: Boolean;
begin
  PEnhExtCreateFontIndirect := PEMRExtCreateFontIndirect(Pnt);
  Handle := PEnhExtCreateFontIndirect.ihFont;
  FontName := QPLNativeToAnsi(PEnhExtCreateFontIndirect.elfw.elfLogFont.lfFaceName);
  FontBold := PEnhExtCreateFontIndirect.elfw.elfLogFont.lfWeight >= 600;
  FontItalic := PEnhExtCreateFontIndirect.elfw.elfLogFont.lfItalic <> 0;
  FontUnderLine := PEnhExtCreateFontIndirect.elfw.elfLogFont.lfUnderline <> 0;
  FontStrikeOut := PEnhExtCreateFontIndirect.elfw.elfLogFont.lfStrikeOut <> 0;
  Size := PEnhExtCreateFontIndirect.elfw.elfLogFont.lfHeight;
  Angle := Abs(PEnhExtCreateFontIndirect.elfw.elfLogFont.lfEscapement);
  CharSet := QPLIntToStr(PEnhExtCreateFontIndirect.elfw.elfLogFont.lfCharSet);
  PitchAndFamily := PEnhExtCreateFontIndirect.elfw.elfLogFont.lfPitchAndFamily;

  FForceUFI := False;

  // More fonts needed here....
  if (QPLStartsWith(FontName, '‘vé“')) then
     FontName := 'SimSun';
  if (QPLEndsWith(FontName, 'GB2312')) then
     FontName := 'SimSun';

  if (FontName = '') then
  begin
    if (PitchAndFamily = 0) then
      FontName := 'Arial'
    else if (PitchAndFamily and FF_SWISS <> 0) then
      FontName := 'Arial'
    else if (PitchAndFamily and FF_ROMAN <> 0) then
      FontName := 'Times New Roman'
    else if (PitchAndFamily and FF_MODERN <> 0) then
      FontName := 'Courier New'
    else if (PitchAndFamily and FF_SCRIPT <> 0) then
      FontName := 'Times New Roman';
  end;

  AName := FontName;
  Found := False;
  Fnt := nil;

  if (FontName = 'Modern') then
    AName := 'Arial';

  if (FontName = 'System') then
    AName := 'Courier';

  if (FontBold and FontItalic) then
  begin
    if (FWinFonts.IndexOf(AName + ' BoldItalic') >= 0) then
    begin
      AName := AName + ' Bold';
      Found := True;
    end;
  end;

  if (FontBold and not Found) then
  begin
    if (FWinFonts.IndexOf(AName + ' Bold') >= 0) then
    begin
      AName := AName + ' Bold';
      Found := True;
    end;
  end;

  if (FontItalic and not Found) then
  begin
    if (FWinFonts.IndexOf(AName + ' Italic') >= 0) then
    begin
      AName := AName + ' Italic';
      Found := True;
    end;
  end;

  if (FontItalic and not Found) then
  begin
    if (FWinFonts.IndexOf(AName + ' Oblique') >= 0) then
    begin
      AName := AName + ' Oblique';
//      Found := True;
    end;
  end;

  if FWinFonts.IndexOf(AName) < 0 then
  begin
    AName := 'Arial';
  end;

  if (EmbedFonts) then
  begin
    if (FontBold and FontItalic) then
    begin
      AName := AName + ' [BoldItalic]';
    end else
    begin
      if FontBold then
      begin
        AName := AName + ' [Bold]';
      end else
      if FontItalic then
      begin
        AName := AName + ' [Italic]';
      end;
    end;
  end
  else
  begin
    if (FontBold and FontItalic) then
    begin
      AName := AName + ',BoldItalic';
    end else
    begin
      if FontBold then
      begin
        AName := AName + ',Bold';
      end else
      if FontItalic then
      begin
        AName := AName + ',Italic';
      end;
    end;
  end;

  FontFound := False;
  for iPnt := 0 to FIncludedFonts.Count - 1 do
  begin
    Fnt := TPDFFont(FIncludedFonts[iPnt]);
    if Fnt.FontName = AName then
    begin
      FontFound := True;
      Break;
    end
    else if (Fnt.FontFamily = AName) then
    begin
      FontFound := True;
      Break;
    end;
  end;

  if not FontFound then
  begin
    // Create a subsetted font
    FntName := 'QuickPDFF' + QPLRandomID;
    Fnt := TPDFFont.Create(FStructure, FntName);
    Fnt.Compress := FCompressFonts;
    Fnt.OriginalCharset := QPLStrToInt(Charset);
    EmbedThisFont := FEmbedFonts;
    FontName := AName;

    if (QPLPos('<QPLNoEmbedFont>' + AName + '</QPLNoEmbedFont>',
      FNoEmbedFontList) > 0) then
    begin
      EmbedThisFont := False;
    end;

{
TTFCFP_SUBSET   - Create a standalone Subset font that cannot be merged with later.
TTFCFP_SUBSET1  - Create a Subset font package that can be merged with later.
TTFCFP_DELTA    - Create a Delta font package that can merge with a previous subset font.

2 in funtion Fnt.NewSubsettedTrueTypeFont works best.  3 doesn't seem to work correctly.
}

    if (EmbedThisFont) then
    begin
      if Fnt.NewSubsettedTrueTypeFont(FontName, ' ', 2, false,
        PEnhExtCreateFontIndirect.elfw.elfLogFont.lfCharSet, EmbedThisFont) then
      begin
        FIncludedFonts.Add(Fnt);
      end else
      begin
        Fnt.Free;
      end;
    end
    else
    begin
      //if Fnt.NewTrueTypeFont(AName, EmbedThisFont, False, True) then
      if Fnt.NewSubsettedTrueTypeFont(AName, ' ', 2, false,
        PEnhExtCreateFontIndirect.elfw.elfLogFont.lfCharSet, EmbedThisFont) then
      begin
        FIncludedFonts.Add(Fnt);
      end else
      begin
        Fnt.Free;
      end;
    end;
  end;

  TextScaling := 100;
  if (PEnhExtCreateFontIndirect.elfw.elfLogFont.lfWidth <> 0) then
    if (Fnt <> nil) and (Fnt.Height <> 0) and (Fnt.AveCharWidth <> 0) then
    begin
      if (PEnhExtCreateFontIndirect.elfw.elfLogFont.lfHeight > 0) then
        TextScaling := Abs((PEnhExtCreateFontIndirect.elfw.elfLogFont.lfWidth /
                       PEnhExtCreateFontIndirect.elfw.elfLogFont.lfHeight) /
                       (Fnt.AveCharWidth / (Fnt.Height - Fnt.InternalLeading)) * 100)
      else
        TextScaling := Abs(PEnhExtCreateFontIndirect.elfw.elfLogFont.lfWidth /
                       PEnhExtCreateFontIndirect.elfw.elfLogFont.lfHeight /
                       (Fnt.AveCharWidth / Fnt.Height) * 100)
    end;

  FFonts.AddObject(AnsiString(AName) + '|' +
    QPLBoolToStr(FontUnderLine) + '|' +
    QPLBoolToStr(FontStrikeOut) + '|' +
    QPLFloatToStr(Size) + '|' +
    CharSet + '|' +
    QPLFloatToStr(Angle) + '|' +
    QPLFloatToStr(TextScaling),
    TObject(Handle));
end;

procedure TPDFMetafile.EmfExtCreatePen(Pnt: PEnhMetaRecord);
var
  PEnhExtCreatePen: PEMRExtCreatePen;
  Handle: Integer;
{$IFDEF QPL_XE2_HIGHER}
  LgPen: ExtLogPen32;
{$ELSE}
  LgPen: ExtLogPen;
{$ENDIF}
  Color: Integer;
  S: AnsiString;
  I, X: Integer;
  Last: TQPLIntPtr;
  P: Pointer;
  offBmi: Integer;
  offBits: Integer;
  cbBmi: Integer;
  PatternName: AnsiString;
  Pattern: TPDFPattern;

begin
  PEnhExtCreatePen := PEMRExtCreatePen(Pnt);
  Handle := PEnhExtCreatePen.ihPen;
  LgPen := PEnhExtCreatePen.elp;
  Color := CalcColor(LgPen.elpColor);

  offBmi := Integer(PEnhExtCreatePen.offBmi);
  offBits := Integer(PEnhExtCreatePen.offBits);
  cbBmi := Integer(PEnhExtCreatePen.cbBmi);
  if cbBmi > 1064 then
  begin
    cbBmi := 1064;
  end;

  if (offBmi <> 0) and (cbBmi <> 0) then
  begin
    try
      PatternName := 'QPLP' + QPLRandomID;
      Pattern := TPDFPattern.Create(FStructure, PatternName);
      Pattern.Handle := Handle;
      Pattern.Bitmap := GetBitmap2(Pnt, offBmi, offBits, cbBmi);
      FIncludedPatterns.Add(Pattern);
    finally
    end;

    S := 'ImgPtn|' + PatternName;
    FPens.AddObject(S, TObject(Handle));
  end
  else
  if (LgPen.elpBrushStyle = BS_HATCHED) then
  begin
    PatternName := 'QPLP' + QPLRandomID;
    Pattern := TPDFPattern.Create(FStructure, PatternName);
    Pattern.Handle := Handle;
    Pattern.Bitmap := GetBitmap3(LgPen.elpHatch);
    FIncludedPatterns.Add(Pattern);

    S := 'ImgPtn|' + PatternName;
    FPens.AddObject(S, TObject(Handle));
  end else
  begin
    FPainter.SetLineColor((Color and $FF) / 255, ((Color and $FF00) shr 8) / 255,
      ((Color and $FF0000) shr 16) / 255);

    if (LgPen.elpPenStyle and PS_GEOMETRIC = PS_GEOMETRIC) then
      FPainter.SetLineWidth(Abs(Sh(LgPen.elpWidth)))
    else
      FPainter.SetLineWidth(0.1);

    FPainter.SetMiterLimit(FMiterLimit);
    FPainter.SetLineCap(1);
    FPainter.SetLineJoin(1);

    S := 'None';
    if ((LgPen.elpBrushStyle and $FF) <> PS_NULL)  then
    begin
      S := 'Simple|' + FPainter.LineColor + '|' +
                       QPLFloatToStr(FPainter.GetLineWidth) + '|' +
                       QPLIntToStr(LgPen.elpColor);
    end;


    case (LgPen.elpPenStyle and $FF) of
      PS_SOLID:         S := S + '|';
      PS_DASH:          S := S + '|3 3';
      PS_DASHDOT:       S := S + '|3 1 1 1';
      PS_DOT:           S := S + '|1';
      PS_DASHDOTDOT:    S := S + '|3 1 1 1 1 1';
      $08:              S := S + '|1 1';  {PS_ALTERNAME}
      PS_USERSTYLE:
      begin
        S := S + '|';
        Last := 0;
        for I := 0 to LGPen.elpNumEntries - 1 do
        begin
          P := Pointer(TQPLIntPtr(LGPen.elpStyleEntry[0]) + I * SizeOf(TQPLIntPtr));
          X := Round(Sh(TQPLIntPtr(P)));

          if (X - Last = 0) then
          begin
            S := S + '1 ';
          end else
          begin
            S := S + QPLIntToStr(X - Last) + ' ';
          end;
          //Last := TQPLIntPtr(P);
        end;
      end;
    end;

    case (LgPen.elpPenStyle and $0F00) of
      PS_ENDCAP_ROUND:  S := S + '|1';  // = 0x00000000,
      PS_ENDCAP_SQUARE: S := S + '|2';  // = 0x00000100,
      PS_ENDCAP_FLAT:   S := S + '|0';  // = 0x00000200,
    else
      S := S + '|1';
    end;

    case (LgPen.elpPenStyle and $F000) of
      PS_JOIN_ROUND:    S := S + '|1';  // = 0x00000000,
      PS_JOIN_BEVEL:    S := S + '|2';// = 0x00001000,
      PS_JOIN_MITER:    S := S + '|0';// = 0x00002000,
    else
      S := S + '|1';
    end;

    FPens.AddObject(S, TObject(Handle));
  end;
end;

// Object manipulation functions

procedure TPDFMetafile.EmfColorCorrectPalette(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfDeleteColorSpace(Pnt: PEnhMetaRecord);
begin
  // Not yet supported
end;

procedure TPDFMetafile.EmfDeleteObject(Pnt: PEnhMetaRecord);
var
  PEnhDeleteObject: PEMRDeleteObject;
  Handle: Cardinal;
  I: Integer;
begin
  PEnhDeleteObject := PEMRDeleteObject(Pnt);
  Handle := PEnhDeleteObject.ihObject;
  I := FBrushes.IndexOfObject(TPDFObject(Handle));
  if I >= 0 then
  begin
    FBrushes.Delete(I);

    if (FSelectedBrushHandle = Handle) then  // Delete currently selected brush so we must set defaults
    begin
      FHasFill := False;
    end;

  end else
  begin
    I := FPens.IndexOfObject(TPDFObject(Handle));
    if I >= 0 then
    begin
      FPens.Delete(I);

      if (FSelectedPenHandle = Handle) then  // Delete currently selected pen so we must set defaults
      begin
        FPainter.SetLineCap(0);      // Default is Flat/Butt
        FPainter.SetLineJoin(0);     // Linejoin is Mitre
        FPainter.SetLineWidth(0);    // Default is 1 unit
        FPainter.SetLineDashEx('');
        FPainter.SetMiterLimit(10);
        FHasPen := False;
      end;

    end else
    begin
      I := FFonts.IndexOfObject(TPDFObject(Handle));
      if I >= 0 then
      begin
        FFonts.Delete(I);
      end;
    end;
  end;
end;

procedure TPDFMetafile.EmfResizePalette(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfSelectObject(Pnt: PEnhMetaRecord);
var
  PEnhSelectObject: PEMRSelectObject;
  I: Cardinal;
  X: Integer;
begin
  PatternBrushName := '';
  PEnhSelectObject := PEMRSelectObject(Pnt);
  I := PEnhSelectObject.ihObject;
  if (I and 2147483648) = 2147483648 then
  begin
    X := I and 2147483647;
    SelectStockObject(X, I);
  end else
  begin
    X := I;
    Self.SelectObject(X);
  end;
end;

procedure TPDFMetafile.EmfSelectpalette(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfSetColorSpace(Pnt: PEnhMetaRecord);
begin
  // Not yet supported
end;

procedure TPDFMetafile.EmfSetPaletteEntries(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

// OpenGL functions

procedure TPDFMetafile.EmfGlsBoundedRecord(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfGlsRecord(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

// Path functions

procedure TPDFMetafile.EmfAbortPath(Pnt: PEnhMetaRecord);
begin
 FPainter.AbortPath;
end;

procedure TPDFMetafile.EmfBeginPath(Pnt: PEnhMetaRecord);
begin
  FInPath := True;
  FPathStarted := False;
  // FPainter.StartPath(FXPos, FYPos);
end;

procedure TPDFMetafile.EmfClosePath(Pnt: PEnhMetaRecord);
begin
  FPainter.ClosePath;
end;

procedure TPDFMetafile.EmfEndPath(Pnt: PEnhMetaRecord);
begin
 FInPath := False;
 FPathStarted := False;
end;

procedure TPDFMetafile.EmfFlattenPath(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfWidenPath(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

// State records

procedure TPDFMetafile.EmfColorMatchToTargetW(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfForceUfiMapping(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
  FForceUFI := True;
end;

procedure TPDFMetafile.EmfInvertRgn(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfMoveToEx(Pnt: PEnhMetaRecord);
var
  PEnhMoveToEx: PEMRMoveToEx;
  Pt: TPoint;
begin
  PEnhMoveToEx := PEMRMoveToEx(Pnt);
  Pt := PEnhMoveToEx.ptl;
  if FInPath then
  begin
    FPainter.MovePath(SX(Pt.x, Pt.y), SY(Pt.x, Pt.y));
  end else
  begin
    FXPos := Sx(Pt.x, Pt.y);
    FYPos := Sy(Pt.x, Pt.y);
    WFXPos := Pt.X;
    WFYPos := Pt.Y;
  end;
end;

procedure TPDFMetafile.EmfPixelFormat(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfRealizePalette(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfRestoreDC(Pnt: PEnhMetaRecord);
var
  I: Integer;
  DCCounter: Integer;
  StateCounter: Integer;
  PEnhRestoreDC: PEMRRestoreDC;
begin
  PEnhRestoreDC := PEMRRestoreDC(Pnt);
  DCCounter := Abs(PEnhRestoreDC.iRelative);
  for I := 1 to DCCounter do
  begin
    if WorldTransformStack.Count > 0 then
    begin
      StateCounter := QPLStrToInt(
        WorldTransformStack[WorldTransformStack.Count - 1]);
      WorldTransformStack.Delete(WorldTransformStack.Count - 1);
      while FStateCounter > StateCounter do
      begin
        FStateCounter := FStateCounter - 1;
        FPainter.LoadState;
      end;
      FPainter.LoadState;
      SetTrans(WorldTransformStack[WorldTransformStack.Count - 1]);
      WorldTransformStack.Delete(WorldTransformStack.Count - 1);

      FPainter.SetState(GSStack[GSStack.Count - 1]);
      FTextAlign := FPainter.MetaTextAlign;
      FFillMode := FPainter.FillMode;
      FFntAngle := FPainter.TextAngle;
      FFntTextScaling := FPainter.TextScaling;
      FFntSize := FPainter.TextSize;
      FSelFont := FPainter.SelFont;

      GSStack.Delete(GSStack.Count - 1);
    end;
  end;
end;

procedure TPDFMetafile.EmfSaveDC(Pnt: PEnhMetaRecord);
begin
  FPainter.TextSize := FFntSize;

  FPainter.SaveState;
  WorldTransformStack.Add(GetTrans);

  FPainter.MetaTextAlign := FTextAlign;
  FPainter.FillMode := FFillMode;
  GSStack.Add(FPainter.GetState);

  WorldTransformStack.Add(QPLIntToStr(FStateCounter));
end;

procedure TPDFMetafile.EmfScaleViewPortExtEx(Pnt: PEnhMetaRecord);
var
  PEnhScaleViewPortExtEx: PEMRScaleViewPortExtEx;
begin
  PEnhScaleViewPortExtEx := PEMRScaleViewPortExtEx(Pnt);
  if (Ftrans.Mode <> MM_ISOTROPIC) and (FTrans.Mode <> MM_ANISOTROPIC) then
  begin
    FTrans.PortExtX := Round((FTrans.PortExtX * PEnhScaleViewPortExtEx.xNum) /
      PEnhScaleViewPortExtEx.xDenom);
    FTrans.PortExtY := Round((FTrans.PortExtY * PEnhScaleViewPortExtEx.yNum) /
      PEnhScaleViewPortExtEx.yDenom);
    if FTrans.PortExtX = 0 then FTrans.PortExtX := 1;
    if FTrans.PortExtY = 0 then FTrans.PortExtY := 1;
  end;
  UpdateXForm;
end;

procedure TPDFMetafile.EmfScaleWindowExtEx(Pnt: PEnhMetaRecord);
var
  PEnhSScaleWindowExtEx: PEMRScaleWindowExtEx;
begin
  PEnhSScaleWindowExtEx := PEMRScaleWindowExtEx(Pnt);
  if (Ftrans.Mode <> MM_ISOTROPIC) and (FTrans.Mode <> MM_ANISOTROPIC) then
  begin
    FTrans.WinExtX := Round((FTrans.PortExtX * PEnhSScaleWindowExtEx.xNum) /
      PEnhSScaleWindowExtEx.xDenom);
    FTrans.WinExtY := Round((FTrans.PortExtY * PEnhSScaleWindowExtEx.yNum) /
      PEnhSScaleWindowExtEx.yDenom);
    if FTrans.WinExtX = 0 then FTrans.WinExtX := 1;
    if FTrans.WinExtY = 0 then FTrans.WinExtY := 1;
  end;
  UpdateXForm;
end;

procedure TPDFMetafile.EmfSetArcDirection(Pnt: PEnhMetaRecord);
var
  PEnhSetArcDirection: PEMRSetArcDirection;
begin
  PEnhSetArcDirection := PEMRSetArcDirection(Pnt);
  FArcDirection := PEnhSetArcDirection.iArcDirection
end;

procedure TPDFMetafile.EmfSetBkColor(Pnt: PEnhMetaRecord);
var
  PEnhSetBkColor: PEMRSetBkColor;
  Color: Integer;
begin
  PEnhSetBkColor := PEMRSetBkColor(Pnt);
  Color := CalcColor(PEnhSetBkColor.crColor);
  FBkColor := Color;
end;

procedure TPDFMetafile.EmfSetBkMode(Pnt: PEnhMetaRecord);
var
  PEnhSetBkMode: PEMRSetBkMode;
begin
  PEnhSetBkMode := PEMRSetBkMode(Pnt);

  //  TRANSPARENT = 0x0001, OPAQUE = 0x0002
  if (PEnhSetBkMode.iMode = 1) or (PEnhSetBkMode.iMode = 2) then
  begin
    FBkMode := PEnhSetBkMode.iMode;
  end;
end;

procedure TPDFMetafile.EmfSetBrushOrgEx(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfSetColorAdjustment(Pnt: PEnhMetaRecord);
begin
  // Not yet supported
end;

procedure TPDFMetafile.EmfSetIcmProfileA(Pnt: PEnhMetaRecord);
begin
  // Not yet supported
end;

procedure TPDFMetafile.EmfSetIcmMode(Pnt: PEnhMetaRecord);
var
  PEnhSetIcmMode: PEMRSetIcmMode;
begin
  PEnhSetIcmMode := PEMRSetIcmMode(Pnt);
  FIcmMode := PEnhSetIcmMode.iMode;
end;

procedure TPDFMetafile.EmfSetIcmProfileW(Pnt: PEnhMetaRecord);
begin
  // Not yet supported
end;

procedure TPDFMetafile.EmfSetLayout(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfSetLinkedUfis(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfSetMapMode(Pnt: PEnhMetaRecord);
var
  PEnhSetMapMode: PEMRSetMapMode;
begin
  PEnhSetMapMode := PEMRSetMapMode(Pnt);
  SetMapMode(PEnhSetMapMode.iMode);
  UpdateXForm;
end;

procedure TPDFMetafile.EmfSetMapperFlags(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfSetMiterLimit(Pnt: PEnhMetaRecord);
var
  PEnhSetMiterLimit: PEMRSetMiterLimit;
begin
  PEnhSetMiterLimit := PEMRSetMiterLimit(Pnt);
  FMiterLimit := PEnhSetMiterLimit.eMiterLimit;
  if (FMiterLimit < 1.4) then FMiterLimit := 1.4;
end;

procedure TPDFMetafile.EmfSetPolyFillMode(Pnt: PEnhMetaRecord);
var
  PEnhSetPolyFillMode: PEMRSetPolyFillMode;
begin
  PEnhSetPolyFillMode := PEMRSetPolyFillMode(Pnt);
  FFillMode := PEnhSetPolyFillMode.iMode;

  FPainter.FillMode := FFillMode;
end;

procedure TPDFMetafile.EmfSetRop2(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfSetStretchBltMode(Pnt: PEnhMetaRecord);
begin
  // Not applicable to PDF
end;

procedure TPDFMetafile.EmfSetTextAlign(Pnt: PEnhMetaRecord);
var
  PEnhSetTextAlign: PEMRSetTextAlign;
begin
  PEnhSetTextAlign := PEMRSetTextAlign(Pnt);
  FTextAlign := PEnhSetTextAlign.iMode;
end;

procedure TPDFMetafile.EmfSetTextColor(Pnt: PEnhMetaRecord);
var
  PEnhSetTextColor: PEMRSetTextColor;
  Color: TColor;
  I: Integer;
begin
  PEnhSetTextColor := PEMRSetTextColor(Pnt);
  Color := CalcColor(PEnhSetTextColor.crColor);
  FPainter.SetTextColor((Color and $FF) / 255, ((Color and $FF00) shr 8) / 255,
    ((Color and $FF0000) shr 16) / 255);
  FTextColor := Color;

  if (PatternBrushName <> '') then
  begin
    for I := 0 to FIncludedPatterns.Count - 1 do
    begin
      if (PatternBrushName = TPDFPattern(FIncludedPatterns[I]).Name) then
      begin
        if not (TPDFPattern(FIncludedPatterns[I]).Colors.Find(FTextColor)) then
          TPDFPattern(FIncludedPatterns[I]).Colors.Add(FTextColor);
      end;
    end;
  end;
end;

procedure TPDFMetafile.EmfSetTextJustification(Pnt: PEnhMetaRecord);
begin
  // Not yet supported
end;

procedure TPDFMetafile.EmfSetViewPortExtEx(Pnt: PEnhMetaRecord);
var
  PEnhSetViewPortExtEx: PEMRSetViewPortExtEx;
  X, Y: Integer;
begin
  PEnhSetViewPortExtEx := PEMRSetViewPortExtEx(Pnt);
  X := PEnhSetViewPortExtEx.szlExtent.cx;
  Y := PEnhSetViewPortExtEx.szlExtent.cy;

  FTrans.PortExtX := X;
  FTrans.PortExtY := Y;
  UpdateXForm;
end;

procedure TPDFMetafile.EmfSetViewPortOrgEx(Pnt: PEnhMetaRecord);
var
  PEnhSetViewPortOrgEx: PEMRSetViewPortOrgEx;
  X, Y: Integer;
begin
  PEnhSetViewPortOrgEx := PEMRSetViewPortOrgEx(Pnt);
  X := PEnhSetViewPortOrgEx.ptlOrigin.X;
  Y := PEnhSetViewPortOrgEx.ptlOrigin.Y;

  FTrans.PortOrgX := X;
  FTrans.PortOrgY := Y;
  UpdateXForm;
end;

procedure TPDFMetafile.EmfSetWindowExtEx(Pnt: PEnhMetaRecord);
var
  PEnhSetWindowExtEx: PEMRSetWindowExtEx;
  X, Y: Integer;
begin
  PEnhSetWindowExtEx := PEMRSetWindowExtEx(Pnt);
  X := PEnhSetWindowExtEx.szlExtent.cx;
  Y := PEnhSetWindowExtEx.szlExtent.cy;

  FTrans.WinExtX := X;
  FTrans.WinExtY := Y;
  UpdateXForm;
end;

procedure TPDFMetafile.EmfSetWindowOrgEx(Pnt: PEnhMetaRecord);
var
  PEnhSetWindowOrgEx: PEMRSetWindowOrgEx;
  X, Y: Integer;
begin
  PEnhSetWindowOrgEx := PEMRSetWindowOrgEx(Pnt);
  X := PEnhSetWindowOrgEx.ptlOrigin.x;
  Y := PEnhSetWindowOrgEx.ptlOrigin.y;

  FTrans.WinOrgX := X;
  FTrans.WinOrgY := Y;
  UpdateXForm;
end;

// Transformation records

procedure TPDFMetafile.EmfModifyWorldTransform(Pnt: PEnhMetaRecord);
var
  PEnhModifyWorldTransform: PEMRModifyWorldTransform;
  TmpXForm: XForm;
begin
  PEnhModifyWorldTransform := PEMRModifyWorldTransform(Pnt);
  case PEnhModifyWorldTransform.iMode of
    MWT_IDENTITY:
    begin
      Ftrans.TransXForm.eM11 := 1;
      Ftrans.TransXForm.eM12 := 0;
      Ftrans.TransXForm.eM21 := 0;
      Ftrans.TransXForm.eM22 := 1;
      Ftrans.TransXForm.eDx := 0;
      Ftrans.TransXForm.eDy := 0;
      UpdateXForm;
    end;

    MWT_LEFTMULTIPLY:
    begin
      TmpXForm.eM11 := PEnhModifyWorldTransform.xform.eM11;
      TmpXForm.eM12 := PEnhModifyWorldTransform.xform.eM12;
      TmpXForm.eM21 := PEnhModifyWorldTransform.xform.eM21;
      TmpXForm.eM22 := PEnhModifyWorldTransform.xform.eM22;
      TmpXForm.eDx := PEnhModifyWorldTransform.xform.eDx;
      TmpXForm.eDy := PEnhModifyWorldTransform.xform.eDy;
      CombineTransform(FTRans.TransXForm, TmpXForm, FTrans.TransXForm);
      UpdateXForm;
    end;

    MWT_RIGHTMULTIPLY:
    begin
      TmpXForm.eM11 := PEnhModifyWorldTransform.xform.eM11;
      TmpXForm.eM12 := PEnhModifyWorldTransform.xform.eM12;
      TmpXForm.eM21 := PEnhModifyWorldTransform.xform.eM21;
      TmpXForm.eM22 := PEnhModifyWorldTransform.xform.eM22;
      TmpXForm.eDx := PEnhModifyWorldTransform.xform.eDx;
      TmpXForm.eDy := PEnhModifyWorldTransform.xform.eDy;
      CombineTransform(FTrans.TransXForm, FTrans.TransXForm, TmpXForm);
      UpdateXForm;
    end;

    4: // MWT_SET:
    begin
      FTrans.TransXForm.eM11 := PEnhModifyWorldTransform.xform.eM11;
      FTrans.TransXForm.eM12 := PEnhModifyWorldTransform.xform.eM12;
      FTrans.TransXForm.eM21 := PEnhModifyWorldTransform.xform.eM21;
      FTrans.TransXForm.eM22 := PEnhModifyWorldTransform.xform.eM22;
      FTrans.TransXForm.eDx := PEnhModifyWorldTransform.xform.eDx;
      FTrans.TransXForm.eDy := PEnhModifyWorldTransform.xform.eDy;
      UpdateXForm;
    end;

  end;
end;

procedure TPDFMetafile.EmfSetWorldTransform(Pnt: PEnhMetaRecord);
var
  PEnhSetWorldTransform: PEMRSetWorldTransform;
begin
  PEnhSetWorldTransform := PEMRSetWorldTransform(Pnt);
  Ftrans.TransXForm.eM11 := PEnhSetWorldTransform.xform.eM11;
  Ftrans.TransXForm.eM12 := PEnhSetWorldTransform.xform.eM12;
  Ftrans.TransXForm.eM21 := PEnhSetWorldTransform.xform.eM21;
  Ftrans.TransXForm.eM22 := PEnhSetWorldTransform.xform.eM22;
  Ftrans.TransXForm.eDx := PEnhSetWorldTransform.xform.eDx;
  Ftrans.TransXForm.eDy := PEnhSetWorldTransform.xform.eDy;
  UpdateXForm;
end;

// Service functions

function TPDFMetafile.GetBitmap(Pnt: PEnhMetaRecord; X, Y, W, H, offBmi,
  offBits, cbBmi, Rop: Integer; CompressJPG: Boolean): TMemoryStream;
var
  PrsBitmapInfo: PersBitmapInfo;
  PBitmapInfo: Pointer;
  PBitsMem: Pointer;
  TmpDC, DC: HDC;
  Bitmap: TBitmap;
  Jpg: TPDFJPEGImage;
  CropBitmap: TBitmap;
  RctSource: TRect;
  RctDest: TRect;
  MS: TMemoryStream;
  JPEGSuccess: Boolean;
begin
  if (offBmi = 0) or (offBits = 0) then
  begin
    Result := nil;
  end else
  begin
    PBitmapInfo := Pointer(TQPLIntPtr(Pnt) + offBmi);
    PBitsMem := Pointer(TQPLIntPtr(Pnt) + offBits);
    Move(PBitmapInfo^, PrsBitmapInfo, cbBmi);

    if PrsBitmapInfo.BitmapInfo.bmiHeader.biBitCount = 1 then
    begin
      PrsBitmapInfo.BitmapInfo.bmiColors[0].rgbBlue := 0;
      PrsBitmapInfo.BitmapInfo.bmiColors[0].rgbRed := 0;
      PrsBitmapInfo.BitmapInfo.bmiColors[0].rgbGreen := 0;
      PrsBitmapInfo.BitmapInfo.bmiColors[0].rgbReserved := 0;
      PrsBitmapInfo.Colors[0].rgbBlue := 1;
      PrsBitmapInfo.Colors[0].rgbRed := 1;
      PrsBitmapInfo.Colors[0].rgbGreen := 1;
      TmpDC := CreateCompatibleDC(0);
    end else
    begin
      TmpDC := CreateDC('Display', nil, nil, nil);
    end;
    
    SetIcmMode(TmpDC, FIcmMode);
    DC := CreateDIBitmap(TmpDC, PrsBitmapInfo.BitmapInfo.bmiHeader,
      CBM_INIT, PBitsMem, PrsBitmapInfo.BitmapInfo, DIB_RGB_COLORS);
    DeleteDC(TmpDC);
    if DC = 0 then
    begin
      Result := nil;
    end else
    begin

      W := PrsBitmapInfo.BitmapInfo.bmiHeader.biWidth;
      H := Abs(PrsBitmapInfo.BitmapInfo.bmiHeader.biHeight);

      Bitmap := TBitmap.Create;
      CropBitmap := TBitmap.Create;

      Jpg := TPDFJPEGImage.Create;
      try
        Bitmap.Handle := DC;
        Bitmap.PixelFormat := pf24bit;
        Bitmap.Canvas.Lock;
        CropBitmap.Width := W;
        CropBitmap.Height := H;
        RctSource.Left := X;
        RctSource.Top := Y;
        RctSource.Right := X + W;
        RctSource.Bottom := Y + H;
        RctDest.Left := 0;
        RctDest.Top := 0;
        RctDest.Right := W;
        RctDest.Bottom := H;
        CropBitmap.Canvas.Lock;
        CropBitmap.Canvas.CopyRect(RctDest, Bitmap.Canvas, RctSource);
        Bitmap.Assign(CropBitmap);
        if PrsBitmapInfo.BitmapInfo.bmiHeader.biBitCount = 1 then
        begin
          //Bitmap := ChangeBWColor(Bitmap, Rop, FFillColor);  // ADC
        end;

        MS := TMemoryStream.Create;

        {  // Need to review this code for masked images.
        case Rop of
          34, 38, 42, 46, 98, 102, 106, 110, 145, 162, 174, 226, 230, 234, 238,
          136, 137, 138, 139, 152, 153, 154, 155, 166, 168, 169, 171, 184, 185,
          186, 187, 170,
          204:  // ADC
            begin
              Bitmap.SaveToStream(MS);
            end;
        }

        {
          FSmoothing: Boolean;
          FGrayScale: Boolean;
          FPixelFormat: TJPEGPixelFormat;
          FQuality: TJPEGQualityRange;
          FDPI: Integer;
          FProgressiveEncoding: Boolean;
          FPerformance: TJPEGPerformance;
        }

        //if (FRecompressImages) then
        if (CompressJPG) then
        begin
          JPEGSuccess := False;
          if (Bitmap.Width > 64) and (Bitmap.Height > 64) then
          begin
            Jpg.LoadFromBitmap(Bitmap);
            try
              Jpg.CompressionQuality := 50;     // ADC Quality.
              Jpg.SaveToStream(MS);
              JPEGSuccess := True;
            except
            end;
          end;
          if not JPEGSuccess then
          begin
            Bitmap.SaveToStream(MS);
          end;
        end
        else
          Bitmap.SaveToStream(MS);  // Save it as a bitmap.

      finally
        Bitmap.Free;
        CropBitmap.Free;
        Jpg.Free;
      end;
      Result := MS;
    end;
  end;
end;

procedure TPDFMetafile.TextOut(X, Y: Integer; const Text: WideString;
  Offsets: array of Double; HasBounds: Boolean; Scale: Integer);
var
  dX, dY: Double;
  Align: Integer;
  TextMode: Integer;
  SavFontColor: AnsiString;
  SinA, CosA: Double;
  I: Integer;
  W: Double;
begin
  TextMode := 0;
  SavFontColor := FPainter.TextColor;
  if Length(Text) > 0 then
  begin
    if FInPath then
    begin
      if FHasPen and FhasFill then
      begin
        TextMode := 2;
        FPainter.SetTextColor((FFillColor and $FF) / 255,
          ((FFillColor and $FF00) shr 8) / 255,
          ((FFillColor and $FF0000) shr 16) / 255);
      end else
      begin
        if FHasPen then
        begin
          TextMode := 1;
        end else
        begin
          TextMode := 0;
        end;
      end;
    end;
    if FTextMode <> TextMode then
    begin
      FTextMode := TextMode;
      FPainter.SetTextMode(TextMode);
    end;
    if Assigned(FPainter.SelFont) then
    begin
      if FBkMode = 2 then
      begin
        FPainter.TextHighlight := hsSquare;
        FPainter.SetHighlightColor((FbkColor and $FF) / 255,
          ((FbkColor and $FF00) shr 8) / 255,
          ((FbkColor and $FF0000) shr 16) / 255);
      end else
      begin
        FPainter.SetFillColor((FFillcolor and $FF) / 255,
          ((FFillcolor and $FF00) shr 8) / 255,
          ((FFillcolor and $FF0000) shr 16) / 255);
        FPainter.TextHighlight := hsNone;
      end;
    end;
    FPainter.TextUnderline := usNone;
    if FFntUnderLine then
    begin
      FPainter.TextUnderline := usSingle;
    end;
    if FFntStrikeOut then
    begin
      FPainter.TextUnderline := usStrikeout;
    end;
    Align := FTextAlign;
    if (Align and TA_UPDATECP) = TA_UPDATECP then
    begin
      X := WFXPos;
      Y := WFYPos;
    end;

    if (Align and TA_CENTER) = TA_CENTER then
    begin
      Align := Align - TA_CENTER;
      FPainter.TextAlign := paCenter
    end else
    begin
      if (Align and TA_RIGHT) = TA_RIGHT then
      begin
        Align := Align - TA_RIGHT;
        FPainter.TextAlign := paRight
      end else
      begin
        FPainter.TextAlign := paLeft;
      end;
    end;

    dX := Sx(X, Y);
    dY := Sy(X, Y);

    if (HasBounds) then
    begin
      dX := Sxb(X, Y);
      dY := Syb(X, Y);
      //dY := dY - Trunc(FPainter.TextSize);  // Old code
    end;

    if (Align and TA_BASELINE) = TA_BASELINE then
    begin
      Align := Align - TA_BASELINE;
    end else
    begin
      if (Align and TA_BOTTOM) = TA_BOTTOM then
      begin
        Align := Align - TA_BOTTOM;

        SinA := Sin(FFntAngle / 10 * 3.1415926536 / 180);
        CosA := Cos(FFntAngle / 10 * 3.1415926536 / 180);

        dX := Sx(X, Y) + FPainter.TextBound(4) * Scale * SinA;
        dY := Sy(X, Y) - FPainter.TextBound(4) * Scale * CosA;
      end else
      begin
        Align := Align - TA_TOP;

        SinA := Sin(FFntAngle / 10 * 3.1415926536 / 180);
        CosA := Cos(FFntAngle / 10 * 3.1415926536 / 180);

        dX := Sx(X, Y) + FPainter.TextAscentTM * Scale * SinA;
        dY := Sy(X, Y) - FPainter.TextAscentTM * Scale * CosA;
      end;
    end;

    FPainter.SetTextScaling(FFntTextScaling);

    FPainter.DrawSpacedText(dx, dy, FFntAngle, Text, Offsets);

    if (FPainter.SelFont.CanUpdate) then
        FPainter.Selfont.AddToSubset(Text, False);

    if (Align and TA_UPDATECP) = TA_UPDATECP then
    begin
      if (Length(Offsets) > 0) then
      begin
        W := 0;
        for I := 0 to Length(Offsets) - 1  do
          W := W + Offsets[I] / EM11;
        WFXPos := WFxPos + Round(W);
      end
      else
        WFXPos := X + Round((FPainter.WideTextWidth(Text) / (1)));

      WFYPos := Y;
      FXPos := SX(X, Y);
      FYPos := SY(X, Y);
    end;
  end;
  
  FPainter.SetTextColor(SavFontColor);
end;

procedure TPDFMetafile.SelectObject(Handle: Integer);
var
  I, X: Integer;
  S: AnsiString;
  Size: Double;
  FntName: AnsiString;
  FntSize: AnsiString;
  FontFound: Boolean;
begin
  I := FBrushes.IndexOfObject(TObject(Handle));
  if I >= 0 then
  begin
    // Object is a brush
    S := FBrushes[I];
    FSelectedBrushHandle := Handle;
    FHasFill := S <> 'None';
    if FHasFill then
    begin
      if GetTok(S, '|', 1) = 'Plain' then
      begin
        FPainter.SetFillColor(GetTok(S, '|', 2));
        FFillColor := QPLStrToInt(GetTok(S, '|', 3));
      end else
      begin
        PatternBrushName := GetTok(S, '|', 2);

        for I := 0 to FIncludedPatterns.Count - 1 do
        begin
          if (PatternBrushName = TPDFPattern(FIncludedPatterns[I]).Name) then
          begin
            X := TPDFPattern(FIncludedPatterns[I]).Colors.IndexOf(FTextColor);
            if (X < 0) then
              TPDFPattern(FIncludedPatterns[I]).Colors.Add(FTextColor);

            X := TPDFPattern(FIncludedPatterns[I]).Colors.IndexOf(FTextColor);
            FPainter.SetFillPattern(PatternBrushName + '_' + QPLIntToStr(X));
          end;
        end;
      end;
    end else
    begin
      FFillColor := RGB(255, 255, 255)
    end;
  end else
  begin
    I := FPens.IndexOfObject(TObject(Handle));
    if I >= 0 then
    begin
      // Object is a pen
      S := FPens[I];
      FSelectedPenHandle := Handle;
      //FHasFill := False;  // Selecting a Pen doesn't reset the brush.
      FHasPen := S <> 'None';
      if GetTok(S, '|', 1) = 'ImgPtn' then
      begin
        PatternBrushName := GetTok(S, '|', 2);

        for I := 0 to FIncludedPatterns.Count - 1 do
        begin
          if (PatternBrushName = TPDFPattern(FIncludedPatterns[I]).Name) then
          begin
            X := TPDFPattern(FIncludedPatterns[I]).Colors.IndexOf(FTextColor);
            if (X < 0) then
              TPDFPattern(FIncludedPatterns[I]).Colors.Add(FTextColor);

            X := TPDFPattern(FIncludedPatterns[I]).Colors.IndexOf(FTextColor);
            S := S + '_' + QPLIntToStr(X);
          end;
        end;
        FPainter.SetLineShader(S);
      end
      else if GetTok(S, '|', 1) = 'Simple' then
      begin
        FPainter.SetLineColor(GetTok(S, '|', 2));
        FPainter.SetLineWidth(Abs(QPLStrToFloat(GetTok(S, '|', 3))));
        FPainter.SetMiterLimit(FMiterLimit);
        FPenColor := QPLStrToInt(GetTok(S, '|', 4));
        FPainter.SetLineDashEx(GetTok(S, '|', 5));
        FPainter.SetLineCap(QPLStrToInt(GetTok(S, '|', 6)));
        FPainter.SetLineJoin(QPLStrToInt(GetTok(S, '|', 7)));
      end;
    end else
    begin
      I := FFonts.IndexOfObject(TObject(Handle));
      if I >= 0 then
      begin
        // Object is a font
        S := FFonts[I];
        FSelectedFontHandle := Handle;
        FntName := GetTok(S, '|', 1);
        FFntUnderline := QPLStrToBool(GetTok(S, '|', 2));
        FFntStrikeOut := QPLStrToBool(GetTok(S, '|', 3));
        FntSize := GetTok(S, '|', 4);
        FFntCharSet := GetTok(S, '|', 5);
        FFntAngle := QPLStrToInt(GetTok(S, '|', 6));
        FFntTextScaling := QPLStrToFloat(GetTok(S, '|', 7));

        FontFound := False;
        Size := Abs(QPLStrToFloat(FntSize));

        for I := 0 to FIncludedFonts.Count - 1 do
        begin
          if TPDFFont(FIncludedFonts[I]).FontName = FntName then
          begin
            FSelFont := TPDFFont(FIncludedFonts[I]);
            FontFound := True;
          end
          else if TPDFFont(FIncludedFonts[I]).FontFamily = FntName  then
          begin
            FSelFont := TPDFFont(FIncludedFonts[I]);
            FontFound := True;
          end
        end;
        if (not FontFound) and (FIncludedFonts.Count > 0) then
        begin
          FSelFont := TPDFFont(FIncludedFonts[0]);
        end;

        FFntSize := Size;  // Don't call FPainter.SelectFont here anymore.

      end else
      begin
        // Bitmap, region or palette, not yet supported
      end;
    end;
  end;
end;

procedure TPDFMetafile.SelectStockObject(Index: Integer; Handle: Cardinal);
begin
  case Index of
    BLACK_BRUSH:
    begin
      FHasFill := True;
      FPainter.SetFillColor(0, 0, 0);
      FFillColor := RGB(0, 0, 0);
      FSelectedBrushHandle := Handle;
    end;

    DKGRAY_BRUSH:
    begin
      FHasFill := True;
      FPainter.SetFillColor(0.25, 0.25, 0.25);
      FFillColor := RGB(64, 64, 64);
      FSelectedBrushHandle := Handle;
    end;

    GRAY_BRUSH:
    begin
      FHasFill := True;
      FPainter.SetFillColor(0.5, 0.5, 0.5);
      FFillCOlor := RGB(128, 128, 128);
      FSelectedBrushHandle := Handle;
    end;

    NULL_BRUSH:
    begin
      FHasFill := False;
      FFillColor := RGB(255, 255, 255);
      FSelectedBrushHandle := Handle;
    end;

    LTGRAY_BRUSH:
    begin
      FHasFill := True;
      FPainter.SetFillColor(0.75, 0.75, 0.75);
      FFillColor := RGB(192, 192, 192);
      FSelectedBrushHandle := Handle;
    end;

    WHITE_BRUSH:
    begin
      FHasFill := True;
      FPainter.SetFillColor(1, 1, 1);
      FFillColor := RGB(255, 255, 255);
      FSelectedBrushHandle := Handle;
    end;

    BLACK_PEN:
    begin
      FHasPen := True;
      FPenColor := RGB(255, 255, 255);
      FPenDash := '';
      FPainter.SetLineColor(0, 0, 0);
      FPainter.SetLineWidth(1 / 1000);
      FPainter.SetMiterLimit(FMiterLimit);
      FPainter.SetLineJoin(1);
      FPainter.SetLineCap(1);
      //FHasFill := False;
      FSelectedPenHandle := Handle;
    end;

    NULL_PEN:
    begin
      FHasPen := False;
      FPenColor := RGB(0, 0, 0);
      FPenDash := '';
      FSelectedPenHandle := Handle;
    end;

    WHITE_PEN:
    begin
      FHasPen := True;
      FPenColor := RGB(255, 255, 255);
      FPenDash := '';
      FPainter.SetLineColor(1, 1, 1);
      FPainter.SetLineWidth(1 / 1000);
      FPainter.SetMiterLimit(FMiterLimit);
      FPainter.SetLineJoin(1);
      FPainter.SetLineCap(1);
      //FHasFill := False;
      FSelectedPenHandle := Handle;
    end;

    ANSI_FIXED_FONT:
    begin
      //CreateStockFont('Arial', False, False, 8);
      CreateStockFont('Helvetica', False, False, 8);
      FSelectedFontHandle := Handle;
    end;

    ANSI_VAR_FONT:
    begin
      // CreateStockFont('Times New Roman', False, False, 8);
      CreateStockFont('Times-Roman', False, False, 8);
      FSelectedFontHandle := Handle;
    end;

    DEVICE_DEFAULT_FONT:
    begin
      //CreateStockFont('Times New Roman', False, False, 8);
      CreateStockFont('Times-Roman', False, False, 8);
      FSelectedFontHandle := Handle;
    end;

    DEFAULT_GUI_FONT:
    begin
      //CreateStockFont('Times New Roman', False, False, 8);
      CreateStockFont('Times-Roman', False, False, 8);
      FSelectedFontHandle := Handle;
    end;

    OEM_FIXED_FONT:
    begin
      CreateStockFont('MS Sans Serif', false, false, 8);
      FSelectedFontHandle := Handle;
    end;

    SYSTEM_FONT:
    begin
      //CreateStockFont('System', false, false, 8);
      CreateStockFont('Courier', False, False, 8);
      FSelectedFontHandle := Handle;
    end;

    SYSTEM_FIXED_FONT:
    begin
      //CreateStockFont('System', false, false, 8);
      CreateStockFont('Courier', False, False, 8);
      FSelectedFontHandle := Handle;
    end;

    DEFAULT_PALETTE:
    begin
      // Not used
    end;
  end;
end;

function TPDFMetafile.CreateStockFont(FontName: AnsiString; FontBold: Boolean;
  FontItalic: Boolean; Size: Double) : TPDFFont;
const
  StandardFontNames: array[1..14] of AnsiString =
   ('Courier', 'Courier-Bold', 'Courier-BoldOblique', 'Courier-Oblique',
    'Helvetica', 'Helvetica-Bold', 'Helvetica-BoldOblique', 'Helvetica-Oblique',
    'Times-Roman', 'Times-Bold', 'Times-Italic', 'Times-BoldItalic',
    'Symbol', 'ZapfDingbats');
var
  Fnt: TPDFFont;
  AName: AnsiString;
  FntName: AnsiString;
  Pnt: Integer;
  FontFound: Boolean;
  EmbedThisFont: Boolean;
  I: Integer;
begin
  Fnt := Nil;
  AName := FontName;

  if (FontBold and FontItalic) then
  begin
    AName := AName + ' [BoldItalic]';
  end else
  begin
    if FontBold then
    begin
      AName := AName + ' [Bold]';
    end else
    if FontItalic then
    begin
      AName := AName + ' [Italic]';
    end;
  end;

  FontFound := False;
  for Pnt := 0 to FIncludedFonts.Count - 1 do
  begin
    Fnt := TPDFFont(FIncludedFonts[Pnt]);
    if Fnt.FontName = AName then
    begin
      FontFound := True;
      Break;
    end;
  end;

  if not FontFound then
  begin
    FntName := 'QuickPDFF' + QPLRandomID;
    Fnt := TPDFFont.Create(FStructure, FntName);
    Fnt.Compress := FCompressFonts;
    EmbedThisFont := FEmbedFonts;

    if (QPLPos('<QPLNoEmbedFont>' + AName + '</QPLNoEmbedFont>',
      FNoEmbedFontList) > 0) then
    begin
      EmbedThisFont := False;
    end;

    for I := 1 to 14 do
    if (AName = StandardFontNames[I]) then
    begin
      FontFound := True;
      Fnt.NewStandardFont(StandardFontNames[I], I);
      FIncludedFonts.Add(Fnt);
    end;

    if not FontFound then
    begin
      if Fnt.NewTrueTypeFont(AName, EmbedThisFont, False, True) then
      begin
        FIncludedFonts.Add(Fnt);
      end else
      begin
        Fnt.Free;
      end;
    end;

    FFonts.AddObject(AName + '|0|0|' + QPLFloatToStr(Size) + '|0|0', nil)
  end;

  FFntSize := Size;    // Don't call FPainter.SelectFont here anymore.
  Result := Fnt;
end;

// Coordinate conversions (world transformation)

function TPDFMetafile.Sx(X, Y: Double): Double;
begin
  Result := X * eM11 + Y * eM21 + edx;
end;

function TPDFMetafile.Sy(X, Y: Double): Double;
begin
  Result := X * eM12 + Y * eM22 + eDy;
end;

function TPDFMetafile.Sw(X: Double): Double;
begin
  Result := X * eM11;
end;

function TPDFMetafile.Sh(Y: Double): Double;
begin
  Result := -Y * eM22;
end;

// Coordinate conversion (without world transformation)

function TPDFMetafile.Sxb(X, Y: Double): Double;
begin
  Result := X * eM11b + Y * eM21b + edxb;
end;

function TPDFMetafile.Syb(X, Y: Double): Double;
begin
  Result := X * eM12b + Y * eM22b + eDyb;
end;

procedure TPDFMetafile.UpdateXForm;
var
  TmpXForm: XForm;
  FinalXForm: XForm;
  FinalXForm2: XForm;
  ScaleX, ScaleY: Double;
begin
  ScaleX := FTrans.PortExtX / FTrans.WinExtX;
  ScaleY := FTrans.PortExtY / FTrans.WinExtY;

  TmpXForm.eM11 := ScaleX;
  TmpXForm.eM12 := 0;
  TmpXForm.eM21 := 0;
  TmpXForm.eM22 := ScaleY;
  TmpXForm.eDx := FTrans.PortOrgX - ScaleX * FTrans.WinOrgX;
  TmpXForm.eDy := FTrans.PortOrgY - ScaleY * FTrans.WinOrgY;

  CombineTransform(FinalXForm, FTrans.TransXForm, TmpXForm);
  CombineTransform(FinalXForm, FinalXForm, FTrans.InitXform);
  CombineTransform(FinalXForm, FinalXForm, FTrans.PdfXform);

  eM11 := FinalXForm.eM11;
  eM12 := FinalXForm.eM12;
  eM21 := FinalXForm.eM21;
  eM22 := FinalXForm.eM22;
  eDx := FinalXForm.eDx;
  eDy := FinalXForm.eDy;

  CombineTransform(FinalXForm2, TmpXForm, FTrans.InitXform);
  CombineTransform(FinalXForm2, FinalXForm2, FTrans.PdfXform);

  eM11b := FinalXForm2.eM11 * 1 / ScaleX;
  eM12b := FinalXForm2.eM12;
  eM21b := FinalXForm2.eM21;
  eM22b := FinalXForm2.eM22 * 1 / ScaleY;
  eDxb := FinalXForm2.eDx;
  eDyb := FinalXForm2.eDy;
end;

// Public functions

procedure TPDFMetafile.Process(MF: TMetafile; OutStream: TPDFStream);
var
  Rect: TRect;
  I: Integer;
  Fnt: TPDFFont;
begin
  FMetaFile := MF;
  Rect.Left := 0;
  Rect.Top := 0;
  Rect.Right := MF.Width;
  Rect.Bottom := MF.Height;
  if MF.Width > MF.Height then
  begin
    FOrientation := 2;
  end else
  begin
    FOrientation := 1;
  end;

  FFillMode := ALTERNATE;
  FHasFill := False;
  FHasPen := False;
  FInPath := False;
  FXPos := 0;
  FYPos := 0;
  WFXPos := 0;
  WFYPos := 0;
  FArcDirection := 1;
  FBkMode := 1;
  FBkColor := RGB(255, 255, 255);
  FTextAlign := TA_TOP + TA_LEFT;
  FStateCounter := 0;
  FIcmMode := ICM_ON;
  FFntUnderLine := False;
  FFntStrikeOut := False;
  FFntAngle := 0;
  FFntCharSet := '1';
  FFillColor := RGB(255, 255, 255);
  FPenDash := '';
  FTextMode := 0;
  FPenColor := RGB(0, 0, 0);
  FMiterLimit := 10;
  FPainter.SetFillColor(1, 1, 1);
  FPainter.SetLineColor(0, 0, 0);
  FPainter.SetLineWidth(1 / 1000);
  FPainter.SetMiterLimit(FMiterLimit);
  FTrans.Mode := MM_Text;
  FTrans.WinOrgX := 0;
  FTrans.WinOrgY := 0;
  FTrans.WinExtX := 1;
  FTrans.WinExtY := 1;
  FTrans.PortOrgX := 0;
  FTrans.PortOrgY := 0;
  FTrans.PortExtX := 1;
  FTrans.PortExtY := 1;
  FTrans.InitXform.eM11 := 1;
  FTrans.InitXform.eM12 := 0;
  FTrans.InitXform.eM21 := 0;
  FTrans.InitXform.eM22 := 1;
  FTrans.InitXform.eDx := 0;
  FTrans.InitXform.eDy := 0;
  FTrans.TransXForm.eM11 := 1;
  FTrans.TransXForm.eM12 := 0;
  FTrans.TransXForm.eM21 := 0;
  FTrans.TransXForm.eM22 := 1;
  FTrans.TransXForm.eDx := 0;
  FTrans.TransXForm.eDy := 0;

  if (MF.Height > MF.Width) then
  begin
    // Portrait
    FTrans.PdfXForm.eM11 := 500;
    FTrans.PdfXForm.eM12 := 0;
    FTrans.PdfXForm.eM21 := 0;
    FTrans.PdfXForm.eM22 := -500;
    FTrans.PdfXForm.eDx := 0;
    FTrans.PdfXForm.eDy := 1000 * MF.Height / MF.Width;
  end else
  begin
    // Landscape
    FTrans.PdfXForm.eM11 := 500 * MF.Width / MF.Height;
    FTrans.PdfXForm.eM12 := 0;
    FTrans.PdfXForm.eM21 := 0;
    FTrans.PdfXForm.eM22 := -500 * MF.Width / MF.Height;
    FTrans.PdfXForm.eDx := 0;
    FTrans.PdfXForm.eDy := 1000;
  end;

  SetMapmode(MM_TEXT);
  UpdateXForm;

  FPainter.Scale(0.001);

  EnumEnhMetaFile(0, MF.Handle, @EnumEnhFunc, Self, Rect);

  // Update all the fonts as they only have a space character defined initially.
  for I := 0 to FIncludedFonts.Count - 1 do
  begin
    Fnt := TPDFFont(FIncludedFonts[I]);
    Fnt.UpdateSubsettedFont;
  end;

  OutStream.SetTo(FPainter.Source, True);
end;

constructor TPDFMetafile.Create(AStructure: TPDFStructure; AFonts: TObjectList;
  ABitmaps: TObjectList; AGSs: TObjectList; APatterns: TObjectList);
var
  DC: HDC;
begin
  inherited Create;
  RecordCounter := 0;
  FPatternBrushName := '';
  FPainter := TPDFPainter.Create;
  FPainter.PDFPrecNum := 4;
  FFonts := TQuickPDFStringList.Create;
  FBrushes := TQuickPDFStringList.Create;
  FPens := TQuickPDFStringList.Create;
  FNoEmbedFontList := '';
  WorldTransformStack := TQuickPDFStringList.Create;
  GSStack := TQuickPDFStringList.Create;
  DC := GetDC(0);
  FWinFonts := TQuickPDFStringList.Create;
  EnumFonts(DC, nil, @EnumFontsProc, Pointer(FWinFonts));
  ReleaseDC(0, DC);
  FStructure := AStructure;
  FIncludedFonts := AFonts;
  FIncludedBitmaps := ABitmaps;
  FIncludedGs := AGSs;
  FIncludedPatterns := APatterns;
  FSelFont := nil;
  FEmbedFonts := False;
  FCompressFonts := False;
  FForceUFI := False;

  SetupWinAnsiCharList;
end;

destructor TPDFMetafile.Destroy;
begin
  FPainter.Free;
  FFonts.Free;
  FBrushes.Free;
  FPens.Free;
  WorldTransformStack.Free;
  GSStack.Free;
  FWinFonts.Free;
  inherited;
end;

function TPDFMetafile.GetTrans: AnsiString;
var
  S: AnsiString;
begin
  S := QPLIntToStr(FTrans.Mode) + '|';

  S := S +
    QPLFloatToStr(FTrans.InitXform.eM11) + '|' +
    QPLFloatToStr(FTrans.InitXform.eM12) + '|' +
    QPLFloatToStr(FTrans.InitXform.eM21) + '|' +
    QPLFloatToStr(FTrans.InitXform.eM22) + '|' +
    QPLFloatToStr(FTrans.InitXform.eDx) + '|' +
    QPLFloatToStr(FTrans.InitXform.edY) + '|';

  S := S +
    QPLFloatToStr(FTrans.TransXForm.eM11) + '|' +
    QPLFloatToStr(FTrans.TransXForm.eM12) + '|' +
    QPLFloatToStr(FTrans.TransXForm.eM21) + '|' +
    QPLFloatToStr(FTrans.TransXForm.eM22) + '|' +
    QPLFloatToStr(FTrans.TransXForm.eDx) + '|' +
    QPLFloatToStr(FTrans.TransXForm.edY) + '|';

  S := S +
    QPLFloatToStr(FTrans.PdfXForm.eM11) + '|' +
    QPLFloatToStr(FTrans.PdfXForm.eM12) + '|' +
    QPLFloatToStr(FTrans.PdfXForm.eM21) + '|' +
    QPLFloatToStr(FTrans.PdfXForm.eM22) + '|' +
    QPLFloatToStr(FTrans.PdfXForm.eDx) + '|' +
    QPLFloatToStr(FTrans.PdfXForm.edY) + '|';

  S := S +
     QPLIntToStr(FTrans.WinOrgX) + '|' +
     QPLIntToStr(FTrans.WinOrgY) + '|' +
     QPLIntToStr(FTrans.WinExtX) + '|' +
     QPLIntToStr(FTrans.WinExtY) + '|' +
     QPLIntToStr(FTrans.PortOrgX) + '|' +
     QPLIntToStr(FTrans.PortOrgY) + '|' +
     QPLIntToStr(FTrans.PortExtX) + '|' +
     QPLIntToStr(FTrans.PortExtY) + '|';

  S := S +
    QPLFloatToStr(FXPos) + '|' +
    QPLFloatToStr(FYPos) + '|' +
    QPLIntToStr(WFXPos) + '|' +
    QPLIntToStr(WFYPos) + '|';

  Result := S;
end;

procedure TPDFMetafile.SetMapMode(Mode: Integer);
begin
  FTrans.Mode := Mode;
  case Mode of
    MM_TEXT:
    begin
      FTrans.WinExtX := 1;
      FTrans.WinExtY := 1;
      FTrans.PortExtX := 1;
      FTrans.PortExtY := 1;
    end;

    MM_LOMETRIC:
    begin
      FTrans.WinExtX := FHorzSize;
      FTrans.WinExtY := FVertSize;
      FTrans.PortExtX := FHorzRes;
      FTrans.PortExtY := -FVertRes;
    end;

    MM_ISOTROPIC:
    begin
      FTrans.WinExtX := FHorzSize;
      FTrans.WinExtY := FVertSize;
      FTrans.PortExtX := FHorzRes div 10;
      FTrans.PortExtY := FVertRes div -10;
    end;

    MM_HIMETRIC:
    begin
      FTrans.WinExtX := FHorzSize * 10;
      FTrans.WinExtY := FVertSize * 10;
      FTrans.PortExtX := FHorzRes div 10;
      FTrans.PortExtY := FVertRes div -10;
    end;

    MM_LOENGLISH:
    begin
      FTrans.WinExtX := FHorzSize;
      FTrans.WinExtY := FVertSize;
      FTrans.PortExtX := 254 * FHorzRes div 1000;
      FTrans.PortExtY := -254 * FVertRes div 1000;
    end;

    MM_HIENGLISH:
    begin
      FTrans.WinExtX := FHorzSize * 10;
      FTrans.WinExtY := FVertSize * 10;
      FTrans.PortExtX := FHorzRes div 10;
      FTrans.PortExtY := FVertRes div -10;
    end;

    MM_TWIPS:
    begin
      FTrans.WinExtX := 1440 * FHorzSize div 100;
      FTrans.WinExtY := 1440 * FVertSize div 100;
      FTrans.PortExtX := 254 * FHorzRes div 1000;
      FTrans.PortExtY := -254 * FVertRes div 1000;
    end;

    MM_ANISOTROPIC:
    begin
      FTrans.Mode := Mode; // ADC
    end;
  end;
end;

procedure TPDFMetafile.SetTrans(Source: AnsiString);

  function GetItem(var S: AnsiString): AnsiString;
  var
    Pnt: Integer;
  begin
    Pnt := QPLPos('|', S);
    Result := QPLCopy(S, 1, Pnt - 1);
    S := QPLCopy(S, Pnt + 1, Length(S) - Pnt);
  end;

begin
  FTrans.Mode := QPLStrToInt(GetItem(Source));
  FTrans.InitXform.eM11 := QPLStrToFloat(GetItem(Source));
  FTrans.InitXform.eM12 := QPLStrToFloat(GetItem(Source));
  FTrans.InitXform.eM21 := QPLStrToFloat(GetItem(Source));
  FTrans.InitXform.eM22 := QPLStrToFloat(GetItem(Source));
  FTrans.InitXform.eDx := QPLStrToFloat(GetItem(Source));
  FTrans.InitXform.eDy := QPLStrToFloat(GetItem(Source));
  FTrans.TransXForm.eM11 := QPLStrToFloat(GetItem(Source));
  FTrans.TransXForm.eM12 := QPLStrToFloat(GetItem(Source));
  FTrans.TransXForm.eM21 := QPLStrToFloat(GetItem(Source));
  FTrans.TransXForm.eM22 := QPLStrToFloat(GetItem(Source));
  FTrans.TransXForm.eDx := QPLStrToFloat(GetItem(Source));
  FTrans.TransXForm.eDy := QPLStrToFloat(GetItem(Source));
  FTrans.PdfXForm.eM11 := QPLStrToFloat(GetItem(Source));
  FTrans.PdfXForm.eM12 := QPLStrToFloat(GetItem(Source));
  FTrans.PdfXForm.eM21 := QPLStrToFloat(GetItem(Source));
  FTrans.PdfXForm.eM22 := QPLStrToFloat(GetItem(Source));
  FTrans.PdfXForm.eDx := QPLStrToFloat(GetItem(Source));
  FTrans.PdfXForm.eDy := QPLStrToFloat(GetItem(Source));
  FTrans.WinOrgX := QPLStrToInt(GetItem(Source));
  FTrans.WinOrgY := QPLStrToInt(GetItem(Source));
  FTrans.WinExtX := QPLStrToInt(GetItem(Source));
  FTrans.WinExtY := QPLStrToInt(GetItem(Source));
  FTrans.PortOrgX := QPLStrToInt(GetItem(Source));
  FTrans.PortOrgy := QPLStrToInt(GetItem(Source));
  FTrans.PortExtX := QPLStrToInt(GetItem(Source));
  FTrans.PortExtY := QPLStrToInt(GetItem(Source));
  UpdateXForm;

  FXPos := QPLStrToFloat(GetItem(Source));
  FYPos := QPLStrToFloat(GetItem(Source));
  WFXPos := QPLStrToInt(GetItem(Source));
  WFYPos := QPLStrToInt(GetItem(Source));
end;

procedure TPDFMetafile.SetupWinAnsiCharList;
var
  CharIndex: Integer;
begin
  SetLength(FWinAnsiCharList, 256);
  for CharIndex := 1 to 256 do
  begin
    FWinAnsiCharList[CharIndex] := WideChar($0000);
  end;
  for CharIndex := 1 to 229 do
  begin
    if (WinAnsiEncodingVector[CharIndex] >= 0) then
    begin
      FWinAnsiCharList[WinAnsiEncodingVector[CharIndex] + 1] :=
        WideChar(UnicodeValues[CharIndex]);
    end;
  end;
end;

function TPDFMetafile.GetBitmap2(Pnt: PEnhMetaRecord; offBmi, offBits,
  cbBmi: Integer): TBitmap;
var
  PrsBitmapInfo: PersBitmapInfo;
  PBitmapInfo: Pointer;
  PBitsMem: Pointer;
  TmpDC, DC: HDC;
  Bitmap: TBitmap;
begin
  if (offBmi = 0) or (offBits = 0) then
  begin
    Result := nil;
  end else
  begin
    PBitmapInfo := Pointer(TQPLIntPtr(Pnt) + offBmi);
    PBitsMem := Pointer(TQPLIntPtr(Pnt) + offBits);
    Move(PBitmapInfo^, PrsBitmapInfo, cbBmi);

    if PrsBitmapInfo.BitmapInfo.bmiHeader.biBitCount = 1 then
    begin
      PrsBitmapInfo.BitmapInfo.bmiColors[0].rgbBlue := 0;
      PrsBitmapInfo.BitmapInfo.bmiColors[0].rgbRed := 0;
      PrsBitmapInfo.BitmapInfo.bmiColors[0].rgbGreen := 0;
      PrsBitmapInfo.BitmapInfo.bmiColors[0].rgbReserved := 0;
      PrsBitmapInfo.Colors[0].rgbBlue := 1;
      PrsBitmapInfo.Colors[0].rgbRed := 1;
      PrsBitmapInfo.Colors[0].rgbGreen := 1;
      TmpDC := CreateCompatibleDC(0);
    end else
    begin
      TmpDC := CreateDC('Display', nil, nil, nil);
    end;

    DC := CreateDIBitmap(TmpDC, PrsBitmapInfo.BitmapInfo.bmiHeader,
      CBM_INIT, PBitsMem, PrsBitmapInfo.BitmapInfo, DIB_RGB_COLORS);
    DeleteDC(TmpDC);

    if DC = 0 then
    begin
      Result := nil;
    end else
    begin
      Bitmap := TBitmap.Create;
      Bitmap.Handle := DC;
      DeleteDC(DC);
      Result := Bitmap;
    end;
  end;
end;

function TPDFMetafile.GetBitmap3(Hatch: Integer): TBitmap;
const
  Patterns: array[0..6, 0..7] of Byte = (
  (*Horizontal: array[0..7] of Byte =*) ( $FF, $00, $00, $00, $00, $00, $00, $00 ),
  (*Vertical:   array[0..7] of Byte =*) ( $80, $80, $80, $80, $80, $80, $80, $80 ),
  (*FDiagonal:  array[0..7] of Byte =*) ( $80, $40, $20, $10, $08, $04, $02, $01 ),
  (*BDiagonal:  array[0..7] of Byte =*) ( $01, $02, $04, $08, $10, $20, $40, $80 ),
  (*Cross:      array[0..7] of Byte =*) ( $FF, $80, $80, $80, $80, $80, $80, $80 ),
  (*DiagCross:  array[0..7] of Byte =*) ( $82, $44, $28, $10, $28, $44, $82, $01 ),
  (*Blank:      array[0..7] of Byte =*) ( $00, $00, $00, $00, $00, $00, $00, $00 ));
var
  P: PByte;
  PNot: Byte;
  I: Integer;
begin
  Result := TBitmap.Create;
  Result.PixelFormat := pf1Bit;
  Result.Width := 8;
  Result.Height := 8;

  if ((Hatch < 0) or (Hatch > 5)) then
  begin
    Hatch := 6;
  end;

(*  case Hatch of
    HS_BDIAGONAL:	 P2 := @BDiagonal;  // A 45-degree upward, left-to-right hatch
    HS_CROSS:	     P2 := @Cross;  // Horizontal and vertical cross-hatch
    HS_DIAGCROSS:	 P2 := @DiagCross;  // 45-degree crosshatch
    HS_FDIAGONAL:	 P2 := @FDiagonal;  // A 45-degree downward, left-to-right hatch
    HS_HORIZONTAL: P2 := @Horizontal;	// Horizontal hatch
    HS_VERTICAL:	 P2 := @Vertical;  // Vertical hatch
    else
      P2 := @Blank;
  end;
*)
  for I := 0 to 7 do
  begin
    P := Result.ScanLine[I];
    PNot := not Patterns[Hatch, I];
    Move(PNot, P^, 1);
  end;
end;

{$ENDIF}

end.
