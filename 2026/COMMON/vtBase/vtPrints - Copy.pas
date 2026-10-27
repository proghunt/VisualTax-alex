unit vtPrints;
(* Improve:
Use printer class, let AppIds override component settings before printing.
Print by page: check every component in page, adjust&scale coords.
Insert EndDoc/EndPage as required (configurable!)
*)

interface

uses
  Classes, Windows, Graphics, Controls, StdCtrls, ExtCtrls, RichEdit, Printers,
  ComCtrls, //TRichEdit
  vtMulti, vtChild,
  vtLabel, vtEditBox, vtShape,
  vtGroupBox, //20160407 Igor
  SynPDF,
  RxRichEd; //20160819 Igor (It must be the last)

type
  TMargins = TRect;

{$IFDEF printer}
  TvtPrinter = class(TPrinter)
  protected
    DocStarted: boolean;
    function PrepareForm(FRec: TFRec): boolean; virtual; //load, split pages...
    procedure PrintHeader(pgNum: integer); virtual;
    procedure PrintPage(pgNum: integer);
  public
    AbortFlag: boolean; //in case of any errors
    pgBreaks: array of integer;
    RetNo, pgCount: integer;
    FRec: TFRec; //of current form
    DfmName: string;
    //FList: TFList;
    R: TRect; //adjusted within page, scaled
    Margins: TRect;
    AForm: TvtScrollBox; //used for printing
    constructor Create(RNo: integer; JobName: string);
    destructor Destroy; override;
    function PrintForms(FormsList: TStrings): boolean;
    function PrintFormPage(FRc: TFRec; pgNum: integer = -1): boolean;
  end;
var
  MyPrinter: TvtPrinter;
{$ELSE}
{$ENDIF}

var
  ScaleX, ScaleY: integer;
const
  DesignPixelsPerInch = 96; //96;
  ScMult = 100; {Scale Multiplier to get accuracy}
  //DefFontName =  'Arial';

procedure DrawShape(TopLeft, BottomRight: TPoint; PenWidth: Integer; ACanvas: TCanvas);
procedure PrintAtAngle(AText: string; ACanvas: TCanvas; Xpos: Integer; YPos: Integer; FontSize: Integer; AtAngle: Integer);
procedure PrintBitmap(Canvas: TCanvas; DestRect: TRect; Bitmap: TBitmap);
procedure PrintImage(RetNo: Integer; AImage: TImage; hdc: THandle; ACanvas: TCanvas;
  ADTop: Integer = 0; ADLeft: Integer = 0); //20160407 Igor
procedure PrintLabel(MyLabel: TvtLabel; ACanvas: TCanvas; DefFontName: string = '';
  ADTop: Integer = 0; ADLeft: Integer = 0; AisSynPDF: Boolean = False); //20160407 Igor //20161103 Igor
procedure PrintMemo(RetNo: Integer; AMemo: TMemo; ACanvas: TCanvas;
  ADTop: Integer = 0; ADLeft: Integer = 0); //20160407 Igor
procedure PrintRichEdit(RetNo: Integer; ARichEdit: TRichEdit; ACanvas: TCanvas;
  ADTop: Integer = 0; ADLeft: Integer = 0; AIsLetter: Boolean = False); //20170109 Igor
procedure PrintVtShape(MyVtShape: TVtShape; ACanvas: TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0;
  AIsSynPDF: Boolean = False); //20160407 Igor //20161104Igor
procedure PrintvtGroupBox(AGroupBox: TvtGroupBox; ACanvas: TCanvas; ADTop, ADLeft: Integer); //20160407 Igor
procedure PrintSomeFile(FileNm: string);

procedure PausePrinting;
function ScalePrBox(R: TRect; pgTop: integer): TRect;
function ScalePrX(X: Longint): LongInt;
function ScalePrY(Y: Longint): LongInt;
procedure IncRichEditFontSize(ARichEdit: TRichEdit; AInc: Integer;
  AIsLetter: Boolean); //20160903 igor //20170204 Igor

//to be dropped
procedure GetPrinterMargins(var Margins: TRect);
function CurrentPageIsLanscape(AForm: TWinControl; AFormLanscape: Boolean;
  AMxFrmWidth, AStartPageY, AEndPageY: Integer): Boolean; //20170127 Igor

implementation

uses
  SysUtils, Forms,
  vtCommon,
  vtTrimStr, vtShared,
  RegularExpressions, //20160903 igor
  vtControlIntf; //20170127 Igor
procedure PrintSomeFile(FileNm: string);
var
  i: integer;
  PrnFile: TextFile;
  TempList: TstringList;
begin
  TempList := TstringList.Create;
  TempList.LoadFromFile(FileNm);
  AssignPrn(PrnFile);
  Rewrite(PrnFile);
  for i := 0 to TempList.Count - 1 do
    Writeln(PrnFile, TempList[i]);
  System.CloseFile(PrnFile);
  //Added March 8th 2006 ???????
  TempList.Free;
end;

function ScalePrX(X: Longint): LongInt;
begin
  Result := (X * ScaleX) div ScMult;
end;

function ScalePrY(Y: Longint): LongInt;
begin
  Result := (Y * ScaleY) div ScMult;
end;

function ScalePrBox(R: TRect; pgTop: integer): TRect;
begin
  (* move R to pgTop, return scaled rectangle
  *)
  R.Left := (R.Left * ScaleX) div ScMult;
  R.Top := ((R.Top - pgTop) * ScaleY) div ScMult;
  R.Right := (R.Right * ScaleX) div ScMult;
  R.Bottom := (R.Bottom * ScaleY) div ScMult;
  Result := R;
end;

{$IFDEF unused}

procedure CreatePrinterFont;
var
  LogFont: TLogFont;
begin
  with Printer.Canvas do
  begin
    with LogFont do
    begin
      lfHeight := Font.Height * ScaleY div ScMult;
      lfWidth := 0; {Font.Width * ScaleX Div ScMult;0;}
      lfEscapement := 0;
      lfOrientation := 0;
      lfWeight := FW_NORMAL;
      lfItalic := 0;
      lfUnderline := 0;
      lfStrikeOut := 0;
      lfCharSet := ANSI_CHARSET;
      lfOutPrecision := OUT_TT_ONLY_PRECIS;
      lfClipPrecision := CLIP_DEFAULT_PRECIS;
      lfQuality := PROOF_QUALITY;
      lfPitchAndFamily := VARIABLE_PITCH;
      {lfFaceName: array[0..lf_FaceSize - 1] of Char;}
    end;
  end;
  Printer.Canvas.Font.Handle := CreateFontIndirect(LogFont);
  {Printer.Canvas.Font.Size :=
    -Printer.Canvas.Font.Height * Printer.Canvas.Font.PixelsPerInch div 72;}
end;
{$ELSE}
{$ENDIF}

procedure PrintAtAngle(AText: string; ACanvas: TCanvas; Xpos: Integer; YPos: Integer; FontSize: Integer; AtAngle: Integer);
var
  lf: TLogfont;
begin
  //begindoc;
  Acanvas.font.Name := 'Times New Roman'; //'Arial';
  Acanvas.font.Size := FontSize;
  //Acanvas.font.Color := RGB(230, 230, 230); //clSilver;
  Acanvas.font.Color := RGB(200, 200, 200); //clSilver;   //20160706
  Acanvas.font.Style := [fsBold];
  GetObject(Acanvas.font.handle, Sizeof(lf), @lf);
  lf.lfescapement := AtAngle; //450;
  lf.lforientation := AtAngle; //450;
  ACanvas.Font.handle := CreateFontIndirect(lf);
  Acanvas.TextOut(XPos, YPos, AText);
  ACanvas.Font.Handle := 0;
  //EndDoc;
end;

procedure PrintBitmap(Canvas: TCanvas; DestRect: TRect; Bitmap: TBitmap);
var
  BitmapHeader: pBitmapInfo;
  BitmapImage: POINTER;
  HeaderSize: DWORD; // Use DWORD for D3-D5 compatibility
  ImageSize: DWORD;
begin
  GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
  GetMem(BitmapHeader, HeaderSize);
  GetMem(BitmapImage, ImageSize);
  try
    GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
    StretchDIBits(Canvas.Handle,
      DestRect.Left, DestRect.Top, // Destination Origin
      DestRect.Right - DestRect.Left, // Destination Width
      DestRect.Bottom - DestRect.Top, // Destination Height
      0, 0, // Source Origin
      Bitmap.Width, Bitmap.Height, // Source Width & Height
      BitmapImage,
      TBitmapInfo(BitmapHeader^),
      DIB_RGB_COLORS,
      SRCCOPY)
  finally
    FreeMem(BitmapHeader);
    FreeMem(BitmapImage)
  end
end {PrintBitmap};

procedure PausePrinting;
begin
  UserMsg('Temporary pause..' + Chr(13) +
    'When ready, press any key to resume printing...');
  PauseSw := False;
end;

procedure DrawALine(x1, y1, w, h, PenWidth: Integer; ACanvas: TCanvas);
begin
  with ACanvas do
  begin
    Pen.Width := PenWidth;
    MoveTo(x1 * ScaleX div ScMult, y1 * ScaleY div ScMult);
    if h = 1 then
      LineTo((x1 + w) * ScaleX div ScMult, Y1 * ScaleY div ScMult)
    else
      LineTo(x1 * ScaleX div ScMult, (y1 + h) * ScaleY div ScMult);
  end;
end;

procedure DrawShape(TopLeft, BottomRight: TPoint; PenWidth: Integer; ACanvas: TCanvas);
begin
  with ACanvas do
  begin
    {Pen.Mode := AMode;}
    Pen.Width := PenWidth;
    case DrawingTool of
      dtLine:
        begin
          MoveTo(TopLeft.X, TopLeft.Y);
          LineTo(BottomRight.X, BottomRight.Y);
        end;
      dtRectangle: Rectangle(TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y);
      dtEllipse: Ellipse(TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y);
      dtRoundRect: RoundRect(TopLeft.X, TopLeft.Y, BottomRight.X, BottomRight.Y,
          (TopLeft.X - BottomRight.X) div 2, (TopLeft.Y - BottomRight.Y) div 2);
    end;
  end;
  ACanvas.Pen.Width := 1; {back to Default}
end;

procedure DrawATriangle(R: Trect; BrushColor: Integer; PenWidth: Integer; Side: Integer; ACanvas: TCanvas);
begin
  if BrushColor = 1 then
    ACanvas.Brush.Color := RGB(236, 236, 236) //RGB(247,247,247) {clBtnFace}
  else if BrushColor = 2 then
    ACanvas.Brush.Color := clBlack;
  ACanvas.Pen.Width := PenWidth;
  case side of
    2: {Triagle: points right ->}
      ACanvas.Polygon([Point(R.Left, R.Top), Point(R.Left, R.Bottom),
        Point(R.Right, R.Top + (R.Bottom - R.Top) div 2)]);

    3: {Triagle: points left <-}
      ACanvas.Polygon([Point(R.Right, R.Top), Point(R.Right, R.Bottom),
        Point(R.Left, R.Top + (R.Bottom - R.Top) div 2)]);
    4: {Triagle: points down}
      ACanvas.Polygon([Point(R.Left, R.Top), Point(R.Right, R.Top),
        Point(R.Left + (R.Right - R.Left) div 2, R.Bottom)]);

    5: {Triagle: points up}
      ACanvas.Polygon([Point(R.Left, R.Bottom), Point(R.Right, R.Bottom),
        Point(R.Left + (R.Right - R.Left) div 2, R.Top)]);
  end; {Case}
end;

procedure DrawACircle(R: Trect; BrushColor: Integer; PenWidth: Integer; ACanvas: TCanvas);
begin
  if BrushColor = 1 then
    ACanvas.Brush.Color := RGB(236, 236, 236) //RGB(247,247,247) {clBtnFace}
  else if BrushColor = 2 then
    ACanvas.Brush.Color := clBlack;
  ACanvas.Pen.Width := PenWidth;
  ACanvas.Ellipse(R.Left, R.Top, R.Right, R.Bottom);
end;

procedure DrawARectangle(R: Trect; BrushColor: Integer; PenWidth: Integer; ACanvas: TCanvas);
begin
  ACanvas.Pen.Width := PenWidth;
  ACanvas.Brush.Color := clWhite;
  if BrushColor = 1 then
  begin
    ACanvas.Brush.Color := clWhite;
  end
  else if BrushColor = 2 then
    ACanvas.Brush.Color := clBlack;

  ACanvas.Rectangle(R.Left, R.Top, R.Right, R.Bottom)
end;

procedure GetPrinterMargins(var Margins: TRect);
var
  PixelsPerInch: TPoint;
  PhysPageSize: TPoint;
  OffsetStart: TPoint;
  PageRes: TPoint;
begin
  //DPI
  PixelsPerInch.y := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  PixelsPerInch.x := GetDeviceCaps(Printer.Handle, LOGPIXELSX);

  Escape(Printer.Handle, GETPHYSPAGESIZE, 0, nil, @PhysPageSize);
  Escape(Printer.Handle, GETPRINTINGOFFSET, 0, nil, @OffsetStart);
  //extent in pixels
  PageRes.y := GetDeviceCaps(Printer.Handle, VERTRES);
  PageRes.x := GetDeviceCaps(Printer.Handle, HORZRES);
  // Top Margin
  Margins.Top := OffsetStart.y div PixelsPerInch.y;
  // Left Margin
  Margins.Left := OffsetStart.x div PixelsPerInch.x;
  // Bottom Margin
  Margins.Bottom := Trunc(((PhysPageSize.y - PageRes.y) / PixelsPerInch.y) -
    (OffsetStart.y / PixelsPerInch.y));
  // Right Margin
  Margins.Right := Trunc(((PhysPageSize.x - PageRes.x) / PixelsPerInch.x) -
    (OffsetStart.x / PixelsPerInch.x));
end;

procedure DrawTriangle(MyVtShape: TVtShape; ACanvas: TCanvas; R: TRect);
var
  poly: array[0..2] of TPoint;
  rpoly: array[0..2] of TPoint;
  i: integer;
  w2, w3, w4, w8, w16, h2, h3, h4, h8, h16, xw, yh: integer;
begin
  w2 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 2;
  w3 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 3;
  w4 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 4;
  w8 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 8;
  w16 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 16;
  h2 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
  h3 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 3;
  h4 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 4;
  h8 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 8;
  h16 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 16;
  xw := ScalePrX(R.Left) + (ScalePrX(R.Right) - ScalePrx(R.Left)) - 1;
  yh := ScalePrY(R.Top) + (ScalePrY(R.Bottom) - ScalePrY(R.Top)) - 1;

  case MyVtShape.Shape of
    vtTriangleRight:
      begin
        poly[0] := point(ScalePrX(R.Left), ScalePrY(R.Top));
        poly[1] := point(xw, ScalePrY(R.Top) + h2);
        poly[2] := point(ScalePrX(R.Left), yh);
      end;
    vtTriangleUp:
      begin
        poly[0] := point(ScalePrX(R.Left) + w2, ScalePrY(R.Top));
        poly[1] := point(xw, yh);
        poly[2] := point(ScalePrX(R.Left), yh);
      end;
    vtTriangleLeft:
      begin
        poly[0] := point(xw, ScalePrY(R.Top));
        poly[1] := point(xw, yh);
        poly[2] := point(ScalePrX(R.Left), ScalePrY(R.Top) + h2);
      end;
    vtTriangleDown:
      begin
        poly[0] := point(ScalePrX(R.Left), ScalePrY(R.Top));
        poly[1] := point(xw, ScalePrY(R.Top));
        poly[2] := point(ScalePrX(R.Left) + w2, yh);
      end;
  end;
  for i := 0 to 2 do
  begin
    rpoly[i].x := R.Left + poly[i].x;
    rpoly[i].y := R.Top + poly[i].y;
  end;
  ACanvas.polygon(slice(poly, 3));
end;

procedure DrawArrow(MyVtShape: TVtShape; ACanvas: TCanvas; R: TRect);
var
  poly: array[0..6] of TPoint;
  rpoly: array[0..6] of TPoint;
  i: integer;
  w, w2, w3, w4, w8, w16, h, h2, h3, h4, h8, h16, xw, yh: integer;
begin
  w := (ScalePrX(R.Right) - ScalePrX(R.Left));
  w2 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 2;
  w3 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 3;
  w4 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 4;
  w8 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 8;
  w16 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 16;
  h := (ScalePrY(R.Bottom) - ScalePrY(R.Top));
  h2 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
  h3 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 3;
  h4 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 4;
  h8 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 8;
  h16 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 16;
  xw := ScalePrX(R.Left) + (ScalePrX(R.Right) - ScalePrx(R.Left)) - 1;
  yh := ScalePrY(R.Top) + (ScalePrY(R.Bottom) - ScalePrY(R.Top)) - 1;

  case MyVtShape.Shape of
    vtArrowRight:
      begin
        poly[0] := point(ScalePrX(R.Left), ScalePrY(R.Top) + (h div 2) - (h div 16));
        poly[1] := point(ScalePrX(R.Left) + w - 1 - (w div 4), ScalePrY(R.Top) + (h div 2) - (h div 16));
        poly[2] := point(ScalePrX(R.Left) + w - 1 - (w div 4), ScalePrY(R.Top));
        poly[3] := point(ScalePrX(R.Left) + w - 1, ScalePrY(R.Top) + (h div 2));
        poly[4] := point(ScalePrX(R.Left) + w - 1 - (w div 4), ScalePrY(R.Top) + h - 1);
        poly[5] := point(ScalePrX(R.Left) + w - 1 - (w div 4), ScalePrY(R.Top) + (h div 2) + (h div 16));
        poly[6] := point(ScalePrX(R.Left), ScalePrY(R.Top) + (h div 2) + (h div 16));
      end;
    vtArrowLeft:
      begin
        poly[0] := point(ScalePrX(R.Left) + w - 1, ScalePrY(R.Top) + (h div 2) - (h div 16));
        poly[1] := point(ScalePrX(R.Left) + (w div 4), ScalePrY(R.Top) + (h div 2) - (h div 16));
        poly[2] := point(ScalePrX(R.Left) + (w div 4), ScalePrY(R.Top));
        poly[3] := point(ScalePrX(R.Left), ScalePrY(R.Top) + (h div 2));
        poly[4] := point(ScalePrX(R.Left) + (w div 4), ScalePrY(R.Top) + h - 1);
        poly[5] := point(ScalePrX(R.Left) + (w div 4), ScalePrY(R.Top) + (h div 2) + (h div 16));
        poly[6] := point(ScalePrX(R.Left) + w - 1, ScalePrY(R.Top) + (h div 2) + (h div 16));
      end;
    vtArrowUp:
      begin
        poly[0] := point(ScalePrX(R.Left) + (w div 2) - (w div 16), ScalePrY(R.Top) + h - 1);
        poly[1] := point(ScalePrX(R.Left) + (w div 2) - (w div 16), ScalePrY(R.Top) + (h div 4));
        poly[2] := point(ScalePrX(R.Left), ScalePrY(R.Top) + (h div 4));
        poly[3] := point(ScalePrX(R.Left) + (w div 2), ScalePrY(R.Top));
        poly[4] := point(ScalePrX(R.Left) + w - 1, ScalePrY(R.Top) + (h div 4));
        poly[5] := point(ScalePrX(R.Left) + (w div 2) + (w div 16), ScalePrY(R.Top) + (h div 4));
        poly[6] := point(ScalePrX(R.Left) + (w div 2) + (w div 16), ScalePrY(R.Top) + h - 1);
      end;
    vtArrowDown:
      begin
        poly[0] := point(ScalePrX(R.Left) + (w div 2) - (w div 16), ScalePrY(R.Top));
        poly[1] := point(ScalePrX(R.Left) + (w div 2) - (w div 16), ScalePrY(R.Top) + h - 1 - (h div 4));
        poly[2] := point(ScalePrX(R.Left), ScalePrY(R.Top) + h - 1 - (h div 4));
        poly[3] := point(ScalePrX(R.Left) + (w div 2), ScalePrY(R.Top) + h - 1);
        poly[4] := point(ScalePrX(R.Left) + w - 1, ScalePrY(R.Top) + h - 1 - (h div 4));
        poly[5] := point(ScalePrX(R.Left) + (w div 2) + (w div 16), ScalePrY(R.Top) + h - 1 - (h div 4));
        poly[6] := point(ScalePrX(R.Left) + (w div 2) + (w div 16), ScalePrY(R.Top));
      end;
  end;
  for i := 0 to 6 do
  begin
    rpoly[i].x := R.Left + poly[i].x;
    rpoly[i].y := R.Right + poly[i].y;
  end;
  ACanvas.polygon(poly);
end;

procedure DrawOthers(MyVtShape: TVtShape; ACanvas: TCanvas; R: TRect);
var
  poly: array[0..15] of TPoint;
  rpoly: array[0..15] of TPoint;
  i: integer;
  StartPos, EndPos: Integer;
  w, w2, w3, w4, w8, w16, h, h2, h3, h4, h8, h16, x, y, xw, yh: integer;
begin
  w := (ScalePrX(R.Right) - ScalePrX(R.Left));
  w2 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 2;
  w3 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 3;
  w4 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 4;
  w8 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 8;
  w16 := (ScalePrX(R.Right) - ScalePrX(R.Left)) div 16;
  h := (ScalePrY(R.Bottom) - ScalePrY(R.Top));
  h2 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
  h3 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 3;
  h4 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 4;
  h8 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 8;
  h16 := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 16;

  x := ScalePrX(R.Left);
  y := ScalePrY(R.Top);
  xw := ScalePrX(R.Left) + (ScalePrX(R.Right) - ScalePrx(R.Left)) - 1;
  yh := ScalePrY(R.Top) + (ScalePrY(R.Bottom) - ScalePrY(R.Top)) - 1;

  StartPos := 0;
  EndPos := 0;
  case MyVtShape.Shape of
    vtDiamond:
      begin
        poly[0] := point(x + (w div 2), y);
        poly[1] := point(x + w - 1, y + (h div 2));
        poly[2] := point(x + (w div 2), y + h - 1);
        poly[3] := point(x, y + (h div 2));
        EndPos := 3;
      end;
    vtOctagon:
      begin
        poly[0] := point(x + (w div 3), y);
        poly[1] := point(x + w - 1 - (w div 3), y);
        poly[2] := point(x + w - 1, y + (h div 3));
        poly[3] := point(x + w - 1, y + h - 1 - (h div 3));
        poly[4] := point(x + w - 1 - (w div 3), y + h - 1);
        poly[5] := point(x + (w div 3), y + h - 1);
        poly[6] := point(x, y + h - 1 - (h div 3));
        poly[7] := point(x, y + (h div 3));
        EndPos := 7;
      end;
    vtHexagon:
      begin
        poly[0] := point(x + w2, y);
        poly[1] := point(xw, y + h4);
        poly[2] := point(xw, yh - h4);
        poly[3] := point(x + w2, yh);
        poly[4] := point(x, yh - h4);
        poly[5] := point(x, y + h4);
        EndPos := 5;
      end;
    vtHexagonFlat:
      begin
        poly[0] := point(x + w4, y);
        poly[1] := point(xw - w4, y);
        poly[2] := point(xw, y + h2);
        poly[3] := point(xw - w4, yh);
        poly[4] := point(x + w4, yh);
        poly[5] := point(x, y + h2);
        EndPos := 5;
      end;
    vtUBarUp:
      begin
        poly[0] := point(x, y);
        poly[1] := point(x, yh);
        poly[2] := point(xw, yh);
        poly[3] := point(xw, y);
        poly[4] := point(xw - w4, y);
        poly[5] := point(xw - w4, yh - h4);
        poly[6] := point(x + w4, yh - h4);
        poly[7] := point(x + w4, y);
        EndPos := 7;
      end;
    vtUBarLeft:
      begin
        poly[0] := point(x, y);
        poly[1] := point(xw, y);
        poly[2] := point(xw, yh);
        poly[3] := point(x, yh);
        poly[4] := point(x, yh - h4);
        poly[5] := point(xw - w4, yh - h4);
        poly[6] := point(xw - w4, y + h4);
        poly[7] := point(x, y + h4);
        EndPos := 7;
      end;
    vtUBarDown:
      begin
        poly[0] := point(x, y);
        poly[1] := point(x, yh);
        poly[2] := point(x + w4, yh);
        poly[3] := point(x + w4, y + h4);
        poly[4] := point(xw - w4, y + h4);
        poly[5] := point(xw - w4, yh);
        poly[6] := point(xw, yh);
        poly[7] := point(xw, y);
        EndPos := 7;
      end;
    vtUBarRight:
      begin
        poly[0] := point(x, y);
        poly[1] := point(x, yh);
        poly[2] := point(xw, yh);
        poly[3] := point(xw, yh - h4);
        poly[4] := point(x + w4, yh - h4);
        poly[5] := point(x + w4, y + h4);
        poly[6] := point(xw, y + h4);
        poly[7] := point(xw, y);
        EndPos := 7;
      end;
    vtWaggle:
      begin
        poly[0] := point(x, y);
        poly[1] := point(x + w4, y + h8);
        poly[2] := point(x + w2, y);
        poly[3] := point(xw - w4, y + h8);
        poly[4] := point(xw, y);
        poly[5] := point(xw - w8, y + h4);
        poly[6] := point(xw, y + h2);
        poly[7] := point(xw - w8, yh - h4);
        poly[8] := point(xw, yh);
        poly[9] := point(xw - w4, yh - h8);
        poly[10] := point(x + w2, yh);
        poly[11] := point(x + w4, yh - h8);
        poly[12] := point(x, yh);
        poly[13] := point(x + w8, yh - h4);
        poly[14] := point(x, y + h2);
        poly[15] := point(x + w8, y + h4);
        EndPos := 15;
      end;
    vtCloudLeft:
      begin
        ACanvas.ellipse(x, y, xw - w4, yh - h4);
        ACanvas.ellipse(x + w4, y + h4, xw, yh);
        EndPos := 0;
      end;
    vtCloudRight:
      begin
        ACanvas.ellipse(x + w4, y, xw, yh - h4);
        ACanvas.ellipse(x, y + h4, xw - w4, yh);
        EndPos := 0;
      end;
  end;

  for i := StartPos to EndPos do
  begin
    rpoly[i].x := R.left + poly[i].x;
    rpoly[i].y := R.top + poly[i].y;
  end;
  ACanvas.polygon(slice(poly, EndPos + 1));
end;

//20110106 new procedure

procedure PrintVtShape(MyVtShape: TVtShape; ACanvas: TCanvas; ADTop: Integer = 0; ADLeft: Integer = 0;
  AIsSynPDF: Boolean = False); //20160407 Igor  //20161104 Igor

procedure DrawVTRect(MyVtShape: TVtShape; ACanvas: TCanvas; R: TRect);
  var
    pWidth, pWidthH: Integer;
  begin
    ACanvas.Pen.Width := MyVtShape.Pen.Width;
    ACanvas.Pen.Color := MyVtShape.Pen.Color; //20170104 Igor;

    if AisSynPDF then
      ACanvas.Pen.Width := ACanvas.Pen.Width - 1;
    if MyVtShape.Height = 1 then
    begin
      ACanvas.MoveTo(ScalePrX(R.Left), ScalePrY(R.Top));
      ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Top));
    end
    else if MyVtShape.Width = 1 then
    begin
      ACanvas.MoveTo(ScalePrX(R.Left), ScalePrY(R.Top));
      ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Bottom));
    end
    else
    begin
      if not aIsSynPDF then
        ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right), ScalePrY(R.Bottom))
      else
      begin
        if ACanvas.Brush.Style <> bsClear then //20161115 Igor
          ACanvas.FillRect(Rect(ScalePrX(R.Left), ScalePrY(R.Top),
            ScalePrX(R.Right),ScalePrY(R.Bottom)));                 //20161115 Igor
        ACanvas.MoveTo(ScalePrX(R.Left), ScalePrY(R.Top));
        ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Bottom));
        ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Bottom));
        ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Top));
        ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Top));
      end;
    end;
  end;

var
  FieldId: Integer;
  R: TRect;
  aString, s: string;
  FormattedAmount: string;
  x, y: LongInt;
  PenWidth, Edge: Integer;

  poly: array[0..2] of TPoint;
  i: integer;
  w2, w3, w4, w8, w16, h2, h3, h4, h8, h16, xw, yh: integer;
begin
  if PauseSw then
    PausePrinting;
  ACanvas.Pen.Style := MyVtShape.Pen.Style;

  ACanvas.Pen.Width := MyVtShape.Pen.Width;
  if AisSynPDF then
    ACanvas.Pen.Width := ACanvas.Pen.Width - 1;

  //if ACanvas.Pen.Width = 2 then showmessage('stop');
  //if ACanvas.Pen.style = psDot then showmessage('stop');

  ACanvas.Brush.Color := MyVtShape.Brush.color; //clWhite; {Self.Color;}
  ACanvas.Brush.Style := MyVtShape.Brush.Style; //bsClear;
  ACanvas.Pen.Color := MyVtShape.Pen.Color; //20170104 Igor;
  R.Left := MyVtShape.Left + ADLeft; //20160407 Igor
  R.Top := MyVtShape.Top + ADTop;    //20160407 Igor
  R.Right := MyVtShape.Left + ADLeft + MyVtShape.Width; //20160407 Igor
  R.Bottom := MyVtShape.Top + ADTop + MyVtShape.Height; //20160407 Igor
  //R := ScalePrBox(R);

  if MyVtShape.Brush.Style = bsSolid then
  begin
    if MyVtShape.Brush.Color = clWhite then
    begin
      ACanvas.Font.Color := clBlack;
      ACanvas.Brush.Style := bsClear;
    end
    else if MyVtShape.Brush.Color = clBlack then
    begin
      ACanvas.Font.Color := clWhite;
      ACanvas.Brush.Style := bsSolid;
      ACanvas.Brush.Color := clBlack;
    end
    else
    begin
      ACanvas.Font.Color := clBlack;
      ACanvas.Brush.Style := bsSolid;
      ACanvas.Brush.Color := RGB(242, 242, 242); //PrintShade; //RGB(245,245,245); //20100103
    end;
  end
  else
  begin
    ACanvas.Font.Color := clBlack;
    ACanvas.Brush.Style := bsClear;
  end;

  if MyVtShape.Width < MyVtShape.Height then
    Edge := MyVtShape.Width
  else
    Edge := MyVtShape.Height;
//20160903 Igor >>>(Duplicate)
//  if MyVtShape.Brush.Style = bsSolid then
//  begin
//    if MyVtShape.Brush.Color = clWhite then
//    begin
//      ACanvas.Font.Color := clBlack;
//      ACanvas.Brush.Style := bsClear;
//    end
//    else if MyVtShape.Brush.Color = clBlack then
//    begin
//      ACanvas.Font.Color := clWhite;
//      ACanvas.Brush.Style := bsSolid;
//      ACanvas.Brush.Color := clBlack;
//    end
//    else
//    begin
//      ACanvas.Font.Color := clBlack;
//      ACanvas.Brush.Style := bsSolid;
//      ACanvas.Brush.Color := RGB(236, 236, 236); //RGB(245,245,245); //clSilver;  //20110103
//    end;
//  end
//  else
//  begin
//    ACanvas.Font.Color := clBlack;
//    ACanvas.Brush.Style := bsClear;
//  end;

  //for over blackbox
  if MyVtShape.Pen.Color = clWhite then
  begin
    ACanvas.Brush.Style := bsSolid;
    ACanvas.Brush.Color := clWhite;
    ACanvas.Pen.Color := clWhite;
  end;
//20160903 igor <<<
  case MyVtShape.Shape of
    vtRectangle, vtSquare: DrawVTRect(MyVtShape, ACanvas, R); //ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right), ScalePrY(R.Bottom));
    vtRoundRect, vtRoundSquare: ACanvas.RoundRect(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right), ScalePrY(R.Bottom), Edge div 4, Edge div 4);
    vtCircle, vtEllipse: ACanvas.Ellipse(ScalePrX(R.Left), ScalePrY(R.Top), ScalePrX(R.Right), ScalePrY(R.Bottom));
    vtTriangleRight, vtTriangleleft, vtTriangleUp, vtTriangleDown: DrawTriangle(MyVtShape, ACanvas, R);
    vtArrowRight, vtArrowLeft, vtArrowDown, vtArrowUp: DrawArrow(MyVtShape, ACanvas, R);
    vtDiamond: DrawOthers(MyVtShape, ACanvas, R);
    vtOctagon: DrawOthers(MyVtShape, ACanvas, R);
    vtHexagon, vtHexagonFlat: DrawOthers(MyVtShape, ACanvas, R); //DrawHexagon;
    vtUBarUp, vtUBarDown, vtUBarRight, vtUBarLeft: DrawOthers(MyVtShape, ACanvas, R); //DrawUBar;
    vtWaggle: DrawOthers(MyVtShape, ACanvas, R); //DrawWaggle;
    vtCloudLeft, vtCloudRight: DrawOthers(MyVtShape, ACanvas, R); //DrawCloud;
  end;

end;

procedure PrintvtGroupBox(AGroupBox: TvtGroupBox; ACanvas: TCanvas; ADTop, ADLeft: Integer); //20160407 Igor
var
  R: TRect;
  I: Integer;
Begin
  if PauseSw then
    PausePrinting;
  R.Left := AGroupBox.Left + ADLeft;
  R.Top := AGroupBox.Top + ADTop;
  R.Right := R.Left + AGroupBox.Width;
  R.Bottom := R.Top + AGroupBox.Height;
  ADTop := AGroupBox.Top + ADTop;
  ADLeft := AGroupBox.Left + ADLeft;
  AGroupBox.Draw(ACanvas, R, ScaleX, ScaleY, ScMult);
End;

procedure PrintRichEdit(RetNo: Integer; ARichEdit: TRichEdit; ACanvas: TCanvas;
  ADTop: Integer = 0; ADLeft: Integer = 0; AIsLetter: Boolean = False);  //20170109 Igor
// 1440 = 1 inch
 //keeps track of each page where to start, end and rect of printing
type
  TPageOffset = record
    mStart: LongInt;
    mEnd: LongInt;
    rendRect: TRECT;
  end;

var
  wPage, hPage, xPPI, yPPI, wTwips, hTwips: integer;
  pageRect, rendRect: TRect;
  po: TPageOffset;
  fr: TFormatRange;
  lastOffset, currPage, pageCount: integer;
  xOffset, yOffset: integer;
  FPageOffsets: array of TPageOffset;
  TextLenEx: TGetTextLengthEx;
  firstPage: boolean;

  //Mine
  XPos, YPos: Integer; //rich edit position
  ImageCanvas: TCanvas;

  dpiPercent, dpiAdjust: integer;
begin

  //First, get the size of a printed page in printer device units
  wPage := GetDeviceCaps(ACanvas.Handle, PHYSICALWIDTH);
  hPage := GetDeviceCaps(ACanvas.Handle, PHYSICALHEIGHT);

  //adjust for dpi //20130315
  dpiPercent := (GetWindowsFontSize(Application.MainForm.Handle) * 100) div DesignPixelsPerInch; //GetWindowsFontSize in trimstr, was comment, uncommented
  if dpiPercent >= 150 then
    dpiAdjust := 122
  else if dpiPercent >= 125 then
    dpiAdjust := 121
  else if dpiPercent >= 104 then
    dpiAdjust := (4 * dpiPercent) - 377
  else
    dpiAdjust := 0;


  //Next, get the device units per inch for the printer
  xPPI := GetDeviceCaps(ACanvas.Handle, LOGPIXELSX){ - dpiAdjust}; //20160331 Igor
  yPPI := GetDeviceCaps(ACanvas.Handle, LOGPIXELSY);

  //mine
  XPos := ScalePrX(ARichEdit.Left + ADLeft); //x whre to start the richedit  //20160407 Igor
  YPos := ScalePrY(ARichEdit.Top + ADTop); //y whre to top richedit          //20160407 Igor
  ImageCanvas := ACanvas; //Printer.Canvas;
  //Convert the page size from device units to twips
  wTwips := {Trunc(WPage * 1440 div xPPI); //} MulDiv(wPage, 1440, xPPI);
  hTwips := {Trunc(HPage * 1440 div yPPI); //} MulDiv(hPage, 1440, yPPI);
  //Save the page size in twips
  with pageRect do
  begin
    Left := 0;
    Top := 0;
    Right := wTwips;
    Bottom := hTwips;
  end;
  //Next, calculate the size of the rendering rectangle in twips
  with rendRect do //tpoint
  begin
    // mine
    //Left:=Trunc(XPos * 1440 div xPPI)+(1440 div 2); //add half inch
    Left := Trunc(XPos * 1440 div xPPI);// + Round(1440 * MainOptions.Prn_LMargin); //add full inch //20160204 Igor
    Top := Trunc(YPos * 1440 div yPPI);
    //Right:=Trunc((XPos+(ScalePrX(ARichEdit.Width))) * 1440 div xPPI)-(1440 div 2); //less half inch
    Right := Trunc((XPos + (ScalePrX(ARichEdit.Width))) * 1440 div xPPI);// - Round(1440 * MainOptions.Prn_RMargin); //less full inch //20160204 Igor
    Bottom := PageRect.Bottom - Round(1440 * 0.50);
    // ---
    //Rememeber - two inch margins are hardcoded, so the below code
    //reduces the width of the output by four inches
    //Top := 0;
    //Left := 0;
    //Right := pageRect.Right - (1440 * 4);
    //Bottom := pageRect.Bottom - (1440 * 4);
  end;
  //Define a single page and set starting offset to zero
  po.mStart := 0;
  //Define and initialize a TFormatRange structure. This structure is passed
  //to the TRichEdit with a request to format as much text as will fit on a
  //page starting with the chrg.cpMin offset and ending with the chrg.cpMax.
  //Initially, we tell the RichEdit control to start at the beginning
  //(cpMin = 0) and print as much as possible (cpMax = -1). We also tell it
  //to render to the printer
  with fr do
  begin
    hdc := ACanvas.Handle;
    hdcTarget := ACanvas.Handle;
    chrg.cpMin := po.mStart;
    chrg.cpMax := -1;
  end;
  //In order to recognize when the last page is rendered, we need to know how
  //much text is in the control.

  with TextLenEx do
  begin
    flags := GTL_DEFAULT;
    codepage := CP_ACP;
  end;
  lastOffset := SendMessage(ARichEdit.Handle, EM_GETTEXTLENGTHEX, wParam(@TextLenEx), 0);
  //As a precaution, clear the formatting buffer
  SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, 0);
  //Printers frequently cannot print at the absolute top-left position on the
  //page. In other words, there is usually a minimum margin on each edge of the
  //page. When rendering to the printer, RichEdit controls adjust the top-left
  //corner of the rendering rectangle for the amount of the page that is
  //unprintable. Since we are printing with two-inch margins, we are presumably
  //already within the printable portion of the physical page.
  SaveDC(fr.hdc);
  SetMapMode(fr.hdc, MM_TEXT);

  { me
  xOffset := GetDeviceCaps(ACanvas.Handle, PHYSICALOFFSETX);
  yOffset := GetDeviceCaps(ACanvas.Handle, PHYSICALOFFSETY);
  xOffset := MulDiv(1440 + 1440, xPPI, 1440);
  yOffset := MulDiv(1440 + 1440, yPPI, 1440);
  SetViewportOrgEx(fr.hdc, xOffset, yOffset, nil);
  }
  //build a table of page entries, one entry for each page that would be printed.
  while ((fr.chrg.cpMin <> -1) and (fr.chrg.cpMin < lastOffset)) do
  begin
    if High(FPageOffsets) <> -1 then //not first page  MINE
      RendRect.Top := 0; //causes second page to start from top
    fr.rc := rendRect;
    fr.rcPage := pageRect;
    po.mStart := fr.chrg.cpMin;
    fr.chrg.cpMin := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, Longint(@fr));
    po.mEnd := fr.chrg.cpMin - 1;
    po.rendRect := fr.rc;
    if High(FPageOffsets) = -1 then
      SetLength(FPageOffsets, 1)
    else
      SetLength(FPageOffsets, Length(FPageOffsets) + 1); //dynamic array
    FPageOffsets[High(FPageOffsets)] := po; //po is the page offset record
  end;

  pageCount := Length(FPageOffsets);
  SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, 0);
  //ME
 // RestoreDC(fr.hdc, - 1);
 //Now, we are almost ready to actually print.
 // Printer.BeginDoc;

  fr.hdc := ACanvas.Handle;
  fr.hdcTarget := ACanvas.Handle;
  //ME
  // SaveDC(fr.hdc);
  //SetViewportOrgEx(fr.hdc, xOffset, yOffset, nil);

  //here we print
  firstPage := True;
  CurrPage := 0;
  while (currPage < pageCount) do
  begin
    if FirstPage then
      FirstPage := False
    else
      Printer.NewPage;
    // SetViewportOrgEx(fr.hdc, xOffset, yOffset, nil);  //me
    fr.rc := FPageOffsets[currPage].rendRect;
    fr.rcPage := pageRect;
    fr.chrg.cpMin := FPageOffsets[currPage].mStart;
    fr.chrg.cpMax := FPageOffsets[currPage].mEnd;
    fr.chrg.cpMin := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 1, Longint(@fr));
    Inc(currPage);
  end;

  //At this point, we have finished rendering the contents of the RichEdit
  //control. Now we restore the printer's HDC settings and tell Windows that
  //we are through printing this document
  RestoreDC(fr.hdc, - 1); //restore 20151014 Igor //me
//  Printer.EndDoc;
  //Finally, we clear the RichEdit control's formatting buffer and delete
  //the saved page table information
 // fr.chrg.cpMin := SendMessage(ARichEdit.Handle, EM_FORMATRANGE, 0, 0);
  Finalize(FPageOffsets); //de-allocates memory
end;

procedure PrintMemo(RetNo: Integer; AMemo: TMemo; ACanvas: TCanvas;
  ADTop: Integer = 0; ADLeft: Integer = 0);  //20160407 Igor
var
  i: Integer;
  ARichEdit: TRichEdit;
begin
  { TODO : print single lines? }
  ARichEdit := TRichEdit.Create(Application);
  ARichEdit.Parent := Application.MainForm;
  ARichEdit.Top := AMemo.Top + ADTop;     //20160407 Igor
  ARichEdit.Left := AMemo.Left + ADLeft;  //20160407 Igor
  ARichEdit.PlainText := True;
  ARichEdit.Text := AMemo.Text;
  PrintRichEdit(RetNo, ARichEdit, ACanvas);
  ARichEdit.Free;
end;

procedure PrintLabel(MyLabel: TvtLabel; ACanvas: TCanvas; DefFontName: string = '';
  ADTop: Integer = 0; ADLeft: Integer = 0; AisSynPDF: Boolean = False);  //20160407 Igor   //20161103 Igor
var
  R: TRect;
  tempPos, AlignTopBottomVar: integer;
  thisCaption: string;
  Stream, Stream_save: TStringStream;// 20151008 Igor
begin
  if DefFontName = '' then
    DefFontName := 'Arial';
  ACanvas.Font.Name := DefFontName;
  //20161103 Igor >>>
  if not AisSynPDF then
    ACanvas.Font.Size := MyLabel.Font.Size + MainOptions.Prn_FontIncr
  else
  //20161103 Igor <<<
    ACanvas.Font.Size := MyLabel.Font.Size;
  ACanvas.Font.Style := MyLabel.Font.Style;

  R.Left := MyLabel.Left + ADLeft;  //20160407 Igor
  R.Top := MyLabel.Top + ADTop;    //20160407 Igor
  R.Right := MyLabel.Left + ADLeft + MyLabel.Width;    //20160407 Igor
  R.Bottom := MyLabel.Top + ADTop + MyLabel.Height;     //20160407 Igor
  //20170109 Igor >>>
  if (not MyLabel.Transparent or (MyLabel.vtBorderType <> vtlblNoBorder)) then
  begin
    while (ScalePrX(R.Bottom - R.Top - 2) < (ACanvas.TextHeight(MyLabel.Caption))) do
      R.Bottom := R.Bottom + 1;
  end;
  //20170109 Igor <<<


  //R := ScalePrBox(R);

  {rem 20151014 Igor
  if MyLabel.RichText <> ''
  then try
          // 20151008 Igor
          Stream_save := TStringStream.Create('');
          Stream := TStringStream.Create('');

          MyLabel.RTF.Lines.SaveToStream(Stream_save);

          Stream.WriteString(MyLabel.RichText);
          Stream.Position := 0;
          //MyLabel.RTF.Lines.Clear;
          MyLabel.RTF.Lines.LoadFromStream(Stream);
          thisCaption := MyLabel.RTF.Lines.Text;

          Stream_save.Position := 0;
          //MyLabel.RTF.Lines.Clear;
          MyLabel.RTF.Lines.LoadFromStream(Stream_save);

       finally
          Stream.Free;
          Stream_save.Free;
       end
  else}
      thisCaption := MyLabel.Caption;

  if MyLabel.Transparent = false then
  begin
    case MyLabel.Color of
      clWhite:
        begin
          ACanvas.Font.Color := clBlack;
          ACanvas.Brush.Style := bsClear;
        end;
      clBlack:
        begin
          ACanvas.Font.Color := clWhite;
          ACanvas.Brush.Style := bsSolid;
          ACanvas.Brush.Color := clBlack;
        end;
    else //case
      ACanvas.Font.Color := clBlack;
      ACanvas.Brush.Style := bsSolid;
      ACanvas.Brush.Color := PrintShade; //RGB(245,245,245);//clSilver;
    end;
  end
  else
  begin
    ACanvas.Font.Color := clBlack;
    ACanvas.Brush.Style := bsClear;
  end;

  //20161115 Igor >>>
  if AisSynPDF then
  begin
    if ACanvas.Brush.Style <> bsClear then
      ACanvas.FillRect(Rect(ScalePrX(R.Left + 1), ScalePrY(R.Top + 1), ScalePrX(R.Right), ScalePrY(R.Bottom + 1)));
  end;
  //20161115 Igor <<<

  if MyLabel.vtBorderType = vtlblUnderline then
  begin
    ACanvas.Pen.Width := 1;
    ACanvas.Pen.Color := clBlack;
    //20161103 Igor >>>
    if not AisSynPDF then
      ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom) - 1, ScalePrX(R.Right), ScalePrY(R.Bottom))
    else
    begin
      ACanvas.MoveTo(ScalePrX(R.Left), ScalePrY(R.Bottom));
      ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Bottom));
    end;
    //20161103 Igor<<<
  end
  else if MyLabel.vtBorderType = vtlblFull then
  begin
    ACanvas.Pen.Width := 1;
    ACanvas.Pen.Color := clBlack;
    if not AisSynPDF then
      ACanvas.Rectangle(ScalePrX(R.Left), ScalePrY(R.Bottom), ScalePrX(R.Right), ScalePrY(R.Top))
    else
    begin
      ACanvas.MoveTo(ScalePrX(R.Left), ScalePrY(R.Top));
      ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Bottom));
      ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Bottom));
      ACanvas.LineTo(ScalePrX(R.Right), ScalePrY(R.Top));
      ACanvas.LineTo(ScalePrX(R.Left), ScalePrY(R.Top));
    end;
  end;

  case MyLabel.Layout of
    tlTop:
      AlignTopBottomVar := ScalePrY(R.Top + 1);
    tlBottom:
      AlignTopBottomVar := ScalePrY(R.Bottom) - ACanvas.TextHeight(thisCaption);
  else //tlCenter
    tempPos := (ScalePrY(R.Bottom) - ScalePrY(R.Top)) div 2;
    AlignTopBottomVar := ScalePrY(R.Top) + tempPos - (ACanvas.TextHeight(thisCaption) div 2);
  end; //case

  case MyLabel.Alignment of
    taLeftJustify:
      ACanvas.Textout(ScalePrX(R.Left), AlignTopBottomVar, thisCaption);
    taRightJustify:
      ACanvas.Textout(ScalePrX(R.Right) - ACanvas.TextWidth(thisCaption), AlignTopBottomVar, thisCaption)
  else //if MyLabel.Alignment = taCenter then
    tempPos := ((ScalePrX(R.Right) - ScalePrX(R.Left)) - ACanvas.TextWidth(thisCaption)) div 2;
    if AisSynPDF then                //20161115 Igor
      ACanvas.Brush.Style := bsClear;//20161115 Igor
    ACanvas.Textout(ScalePrX(R.Left) + tempPos, AlignTopBottomVar, thisCaption)
  end; //case
end;

procedure PrintImage(RetNo: Integer; AImage: TImage; hdc: THandle; ACanvas: TCanvas;
  ADTop: Integer = 0; ADLeft: Integer = 0); //20160407 Igor
var
  R: TRect;
begin
  if PauseSw then
    PausePrinting;
  R.Left := ScalePrX(AImage.Left + ADLeft);  //20160407 Igor
  R.Top := ScalePrY(AImage.Top + ADTop);      //20160407 Igor
  R.Right := ScalePrX(AImage.Left + ADLeft + AImage.Width);
  R.Bottom := ScalePrY(AImage.Top + ADTop + AImage.Height);

//  if UpperCase(AImage.Name) = 'LOGOIMAGE' then //20160413 Igor
  begin
    //AImage.Picture.Tranparent:=False;
    //AImage.Autosize:=True;
    //AImage.Stretch:=False;
 //20160413 Igor>>>
//    R.Left := ScalePrX(AImage.Left + ADLeft);  //20160407 Igor
//    R.Top := ScalePrY(AImage.Top + ADTop);      //20160407 Igor
//    R.Right := ScalePrx(AImage.Left + ADLeft + AImage.Picture.Width);
//    R.Bottom := ScalePrY(AImage.Top + ADTop + AImage.Picture.Height);
 //20160413 Igor<<<
    ACanvas.StretchDraw(R, AImage.Picture.Graphic);
    //ACanvas.Draw(R.Left,R.Top,AImage.Picture.Graphic);
  end;
  //else //not need and causes double logo printing???
  // ACanvas.StretchDraw(R,AImage.Picture.Graphic);
end;

{$IFDEF printer}

{ TvtPrinter }

constructor TvtPrinter.Create(RNo: integer; JobName: string);
begin
  inherited Create;
  RetNo := RNo;
  //Job := JobName; //transfer to printer how?
  Title := JobName;
end;

destructor TvtPrinter.Destroy;
begin
  AForm.Free;
  inherited;
end;

function TvtPrinter.PrepareForm(FRec: TFRec): boolean;
var
  i: integer;
begin
  (* Override to load the form resource etc.
    Set printer orientation.
    Here: detect pages
  *)
  AForm := TvtScrollBox.Create(nil, RetNo, FRec.FormNo);

  if DfmName = '' then
  begin //get default DFM name
    DfmName := RetList[RetNo].GetDfmFileName(FRec.FormName);
    Result := DfmName <> '';
    if not Result then
      exit; //no such form
  end; //else DFMName preset by override

  if FRec.Landscape then
    Orientation := poLandscape
  else
    Orientation := poPortrait;
  GetPrinterMargins(Margins);

  Result := ReadComponentResFile(DfmName, AForm) <> nil;
  if not Result then
    exit; //DFM read error
  AForm.AfterOpenForm;

  pgCount := AForm.pgBreaks.Count;
  SetLength(pgBreaks, pgCount);
  for i := 0 to pgCount - 1 do
    pgBreaks[i] := TControl(AForm.pgBreaks.Objects[i]).Top;
end;

function TvtPrinter.PrintFormPage(FRc: TFRec; pgNum: integer): boolean;
var
  i: integer;
begin
  (* Print all or selected page
  *)
  if not PrepareForm(FRc) then
    exit;
  FRec := FRc;

  if not FastPrint then
  begin
    Printer.BeginDoc;
    DocStarted := True;
  end;

  if pgNum > 0 then
    PrintPage(pgNum)
  else
  begin
    for i := 0 to pgCount - 1 do
    begin
      PrintPage(i);
      if AbortFlag then
        break;
    end;
  end;

  if DocStarted then
    Printer.EndDoc;
  FreeAndNil(AForm);
  Result := AbortFlag;
end;

function TvtPrinter.PrintForms(FormsList: TStrings): boolean;
var
  i: integer;
begin
  (* Print list of forms.
  *)
  if not FastPrint then
  begin
    Printer.BeginDoc;
    DocStarted := True;
  end;
  for i := 0 to FormsList.Count - 1 do
  begin
    FRec := RetList[retNo].MyApp.FList.ByFormName(FormsList[i]);
    PrintFormPage(FRec);
  end;

  //in destructor?
  if DocStarted then
    Printer.EndDoc;
end;

procedure TvtPrinter.PrintHeader(pgNum: integer);
begin
  (* Override for printing the page header.
    Adjust RPage.Top to the top of the remaining printing area.
  *)
    //NOP
end;

procedure TvtPrinter.PrintPage(pgNum: integer);
var
  i, pgTop, pgBottom: integer;
  cmp: TComponent;
  ctl: TControl absolute cmp;
begin
  pgTop := pgBreaks[pgNum - 1]; //zero based?
  pgBottom := pgBreaks[pgNum];
  if RetList[RetNo].MyApp.LicenseLevel = llDemo then {demo}
    PrintAtAngle('For Demo Purposes Only', Canvas, 200, PageHeight div 2 - 100, 30, 100);

  //init page size
  //header
  if FRec.ShowHdr then //?
    PrintHeader(pgNum); //adjust top margin!
  for i := 0 to AForm.ComponentCount - 1 do
  begin
    cmp := AForm.Components[i];
    if (ctl.Top < pgTop) or (ctl.Top >= pgBottom) then
      continue; //not in page
    if (ctl.BoundsRect.Bottom > pgBottom) then
    begin
      NotImp('insert pagebreak');
    end;
    ScalePrBox(R, pgTop);
    if cmp is TLabel then
    begin
      PrintLabel(TvtLabel(ctl), printer.Canvas);
    end
    else if cmp is TvtEdit then
    begin
    end;
    //etc...
  end;
  Printer.NewPage; //no problem before EndDoc?
end;
{$ELSE}
{$ENDIF}

procedure IncRichEditFontSize(ARichEdit: TRichEdit; AInc: Integer;
  AIsLetter: Boolean); //20160903 igor //20170204 Igor
var
  Match: TMatch;
  strem: TStringStream;
  newRichText: AnsiString;
  rOptions: TRegExOptions; //20170203 Igor

  r: TRegEx;
  StartPos: Integer;
  NewFontSize: String;
Begin
  if ARichEdit.Text <> '' then
  begin
    strem:=TStringStream.Create;
    ARichEdit.Lines.SaveToStream(strem);
    newRichText:=strem.DataString;

    StartPos := 0;
    r := TRegEx.Create('\\fs\d{1,}', [roIgnoreCase, roMultiLine]);
    repeat
      Match := r.Match(newRichText, StartPos);
      if Match.Success then
      begin
        NewFontSize := IncRTFFontSize(Match.Value, AInc);
        newRichText := StuffString(newRichText, Match.Index, Match.Length,
          NewFontSize);
        StartPos := Match.Index+ length(NewFontSize);
      end;
    until not Match.Success;

    if not AIsLetter then
    begin
      StartPos := 0;
      r := TRegEx.Create('\{\\fonttbl(\{[^}]{1,}\}){1,}?\}', [roIgnoreCase, roMultiLine]);
      repeat
        Match := r.Match(newRichText, StartPos);
        if Match.Success then
        begin
          newRichText := StuffString(newRichText, Match.Index, Match.Length,
            '{\fonttbl{\f0\fnil\fcharset0 Arial;}}');
          StartPos := Match.Index+ length('{\fonttbl{\f0\fnil\fcharset0 Arial;}}');
        end;
      until not Match.Success;
      StartPos := 0;
      r := TRegEx.Create('\\f[\d]{1,}', [roIgnoreCase, roMultiLine]);
      repeat
        Match := r.Match(newRichText, StartPos);
        if Match.Success then
        begin
          newRichText := StuffString(newRichText, Match.Index, Match.Length,
            '\f0');
          StartPos := Match.Index + length('\f0');
        end;
      until not Match.Success;
    end;

//    for Match in TRegEx.Matches(newRichText,'[\\][f][s]\d{1,}') do
//       newRichText:= StuffString(newRichText, Match.Index, Match.Length,
//         IncRTFFontSize(Match.Value, AInc));
//    //20170203 Igor >>> change font name to arial
//    rOptions := [roIgnoreCase, roMultiLine];
//    for Match in TRegEx.Matches(newRichText,'\{\\fonttbl(\{[^}]{1,}\}){1,}?\}', rOptions) do
//       newRichText:= StuffString(newRichText, Match.Index, Match.Length, '{\fonttbl{\f0\fnil\fcharset0 Arial;}}');
//    //20170203 Igor <<<
    strem.Seek(0, soFromBeginning);
    strem.WriteString(newRichText);
    strem.Seek(0, soFromBeginning);
    ARichEdit.Lines.LoadFromStream(strem);


  end;
End;

function CurrentPageIsLanscape(AForm: TWinControl; AFormLanscape: Boolean;
  AMxFrmWidth, AStartPageY, AEndPageY: Integer): Boolean; //20170127 Igor
var
  c: Integer;
  H, W, PH, PW, FormHeight: Integer;
  vtControl: IvtControl;
begin
  H := 0;
  W := 0;
  for c := 0 to AForm.ControlCount - 1 do
  begin
    if AForm.Controls[c].GetInterface(IvtControl, vtControl) and
       not vtControl.GetvtIsPrintable then
      Continue;
    if (AForm.Controls[c].Top >= AStartPageY) AND (AForm.Controls[c].Top < AEndPageY) then
    begin
      if H < AForm.Controls[c].Top + AForm.Controls[c].Height then
        H := AForm.Controls[c].Top + AForm.Controls[c].Height;
      if W < AForm.Controls[c].Left + AForm.Controls[c].Width then
        W := AForm.Controls[c].Left + AForm.Controls[c].Width;
    end;
  end;
  PW := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
  PH := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);
  if PW > PH then
  begin
    C := PW;
    PH := PW;
    PW := C;
  end;
  if AFormLanscape then
  begin
    if (W <= AMxFrmWidth) and
       (H > AMxFrmWidth) then
      Result := False
    else
      Result := True;
  end
  else
  begin
    if (W > AMxFrmWidth) and
       (H <= AMxFrmWidth) then
      Result := True
    else
      Result := False;
  end;
end;
end.

