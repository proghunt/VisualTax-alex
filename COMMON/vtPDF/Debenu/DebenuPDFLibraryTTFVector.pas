{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryTTFVector.pas                          }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryTTFVector;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  Classes,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
{$IFNDEF VER120}
  contnrs,
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  Types,
{$ENDIF}
  DebenuPDFLibraryExtra, SysUtils;

type
  TDPoint = record
    X: Double;
    Y: Double;
  end;

  TFontLine = class
  public
    EndPoint: TDPoint;
  end;

  TFontSpline = class
  public
    ControlA: TDPoint;
    ControlB: TDPoint;
    EndPoint: TDPoint;
  end;

  TFontCurveCollection = class
  public
    StartPoints: array of TDPoint;
    Parts: array of TObjectList;
    constructor Create;
    destructor Destroy; override;
    procedure NewPart(StartX, StartY: Double);
    procedure AddLine(EndX, EndY: Double);
    procedure AddCurve(CtAX, CtAY, CtBX, CtBY, EndX, EndY: Double);
    procedure Clear;
  end;

  PFontStroke = ^TFontStroke;
  TFontStroke = record
    GlyphNumber: Integer;
    Pt1, Pt2: TPoint;
  end;

  TTTFToVectorConverter = class
  private
    FFont: TFont;
    FCurveCollection: TFontCurveCollection;
    FCharWidth: Integer;
  protected
    procedure SetFont(Value: TFont); virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetCharacterGlyphs(CharCode: Integer);
    procedure Clear;
    property Font: TFont read FFont write SetFont;
    property CurveCollection: TFontCurveCollection read FCurveCollection;
    property CharWidth: Integer read FCharWidth;
  end;

implementation

(*{$IFNDEF WIN32}
type
  DWORD = LongInt;
  PTTPolygonHeader = ^TTTPolygonHeader;
  TTTPolygonHeader = packed record
    cb: DWORD;
    dwType: DWORD;
    pfxStart: TPointFX;
  end;
const
  GDI_ERROR = -1;
{$ENDIF}*)

constructor TTTFToVectorConverter.Create;
begin
  FFont := TFont.Create;
  FFont.Name := 'Arial';
  FFont.Size := 28;
  FCurveCollection := TFontCurveCollection.Create;
end;

destructor TTTFToVectorConverter.Destroy;
begin
  FFont.Free;
  FCurveCollection.Free;
  inherited Destroy;
end;

procedure TTTFToVectorConverter.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

type
  TFXPArray = array[0..MaxInt div SizeOf(TPOINTFX) - 1] of TPOINTFX;
  PFXPArray = ^TFXPArray;

{$IFNDEF QPL_OS_WINDOWS}
procedure TTTFToVectorConverter.GetCharacterGlyphs(CharCode: Integer);
begin

end;
{$ELSE}
procedure TTTFToVectorConverter.GetCharacterGlyphs(CharCode: Integer);
var
  res, bufSize: Cardinal;
  bufPtr, buf: PTTPolygonHeader;
  pc: PTTPolyCurve;
  dc, mdc: HDC;
  ofont: HFONT;
  gm: TGLYPHMETRICS;
  m2: TMAT2;
  ps, p1, p2: TDPoint;
  ofs, ofs2, pcSize: Cardinal;
  done: Boolean;
  i: Integer;
  pfxA, pfxB, pfXC: TDPoint;
  lpAPFX: PFXPArray;
  polyN: Integer;
  pcType: Integer;
  LastPoly: Integer;
  CtAX, CtAY, CtBX, CtBY: Double;

  function Fix2Double(AFix: TFixed): Double;
  begin
    Result := AFix.fract / 65536.0 + AFix.value;
  end;

begin
  if Font.Handle = 0 then
    Exit;

  dc := GetDC(0);
  mdc := CreateCompatibleDC(dc);
  ReleaseDC(0, dc);
  ofont := SelectObject(mdc, FFont.Handle);

  // Identity matrix
  m2.eM11.value := 1; m2.eM11.fract := 1;
  m2.eM12.value := 0; m2.eM12.fract := 1;
  m2.eM21.value := 0; m2.eM21.fract := 1;
  m2.eM22.value := 1; m2.eM22.fract := 1;

  bufSize := GetGlyphOutlineW(mdc, CharCode, GGO_NATIVE, gm, 0, nil, m2);
  FCharWidth := gm.gmCellIncX;

  if (bufSize = Cardinal(GDI_ERROR)) or (bufSize = 0) then
  begin
    SelectObject(mdc, ofont);
    DeleteDC(mdc);
    Exit;
  end;

  bufPtr := AllocMem(bufSize);
  buf := bufPtr;

  res := GetGlyphOutlineW(mdc, CharCode, GGO_NATIVE, gm, bufSize, PAnsiChar(buf), m2);

  SelectObject(mdc, ofont);
  DeleteDC(mdc);
  if (res = Cardinal(GDI_ERROR)) or (buf^.dwType <> TT_POLYGON_TYPE) then
  begin
    FreeMem(bufPtr);
    Exit;
  end;

  Done := False;
  ofs := 0;
  polyN := 0;
  LastPoly := -1;
  while not Done do
  begin
    ps.X := Fix2Double(buf^.pfxStart.X);
    ps.Y := Fix2Double(buf^.pfxStart.Y);
    if LastPoly <> polyN then
    begin
      LastPoly := polyN;
      FCurveCollection.NewPart(ps.X, ps.Y);
    end;
    pcSize := buf^.cb - SizeOf(TTTPOLYGONHEADER);
    PAnsiChar(pc) := PAnsiChar(buf) + SizeOf(TTTPOLYGONHEADER);
    ofs2 := 0;
    p2 := ps;
    while not Done and (ofs2 < pcSize) do
    begin
      pcType := pc^.wType;
      case pcType of
        TT_PRIM_LINE:
          begin
            lpAPFX := @pc^.apfx[0];
            for i := 0 to pc^.cpfx-1 do
            begin
              p1 := p2;
              p2.X := Fix2Double(lpAPFX^[i].X);
              p2.Y := Fix2Double(lpAPFX^[i].Y);
              FCurveCollection.AddLine(p2.X, p2.Y);
            end;
          end;
        TT_PRIM_QSPLINE:
          begin
            lpAPFX := @pc^.apfx[0];
            pfxA := p2;
            for i := 0 to pc^.cpfx-2 do
            begin
              pfxB.X := Fix2Double(lpAPFX^[i].X);
              pfxB.Y := Fix2Double(lpAPFX^[i].Y);
              if i < pc^.cpfx-2 then
              begin
                pfxC.X := Fix2Double(lpAPFX^[i+1].X);
                pfxC.Y := Fix2Double(lpAPFX^[i+1].Y);
                pfxC.X := (pfxC.X + pfxB.X) / 2;
                pfxC.Y := (pfxC.Y + pfxB.Y) / 2;
              end
              else
              begin
                pfxC.X := Fix2Double(lpAPFX^[i+1].X);
                pfxC.Y := Fix2Double(lpAPFX^[i+1].Y);
              end;

              CtAX := (pfxA.X + 2 * pfxB.X) / 3;
              CtAY := (pfxA.Y + 2 * pfxB.Y) / 3;
              CtBX := (2 * pfxB.X + pfxC.X) / 3;
              CtBY := (2 * pfxB.Y + pfxC.Y) / 3;
              CurveCollection.AddCurve(CtAX, CtAY, CtBX, CtBY, pfXC.X, pfXC.Y);

              pfxA := pfxC;
            end;
            p2 := pfxC;
          end;
      end;
      ofs2 := ofs2 + SizeOf(TTTPOLYCURVE);
      Inc(ofs2, (pc^.cpfx-1) * SizeOf(TPOINTFX));
      PAnsiChar(pc) := PAnsiChar(pc) + SizeOf(TTTPOLYCURVE) + (pc^.cpfx - 1) * SizeOf(TPOINTFX);
    end;
    if not Done then
    begin
      p1 := p2;
      p2 := ps;
      ofs := ofs + pcSize + SizeOf(TTTPOLYGONHEADER);
      Done := ofs >= bufSize - SizeOf(TTTPolygonHeader);
      PAnsiChar(buf) := PAnsiChar(pc);
      Inc(polyN);
    end;
  end;
  FreeMem(bufPtr);
end;
{$ENDIF}

{ TFontCurveCollection }

procedure TFontCurveCollection.AddCurve(CtAX, CtAY, CtBX, CtBY, EndX,
  EndY: Double);
var
  Spline: TFontSpline;
begin
  Spline := TFontSpline.Create;
  Spline.ControlA.X := CtAX;
  Spline.ControlA.Y := CtAY;
  Spline.ControlB.X := CtBX;
  Spline.ControlB.Y := CtBY;
  Spline.EndPoint.X := EndX;
  Spline.EndPoint.Y := EndY;  
  Parts[Length(Parts) - 1].Add(Spline);
end;

procedure TFontCurveCollection.AddLine(EndX, EndY: Double);
var
  Line: TFontLine;
begin
  Line := TFontLine.Create;
  Line.EndPoint.X := EndX;
  Line.EndPoint.Y := EndY;
  Parts[Length(Parts) - 1].Add(Line);
end;

procedure TFontCurveCollection.Clear;
var
  X: Integer;
begin
  for X := 0 to Length(Parts) - 1 do
    Parts[X].Free;
  SetLength(Parts, 0);
  SetLength(StartPoints, 0);
end;

constructor TFontCurveCollection.Create;
begin
  SetLength(StartPoints, 0);
  SetLength(Parts, 0);
end;

destructor TFontCurveCollection.Destroy;
var
  X: Integer;
begin
  for X := 0 to Length(Parts) - 1 do
    Parts[X].Free;
  inherited;
end;

procedure TFontCurveCollection.NewPart(StartX, StartY: Double);
var
  L: Integer;
begin
  L := Length(StartPoints);
  SetLength(StartPoints, L + 1);
  StartPoints[L].X := StartX;
  StartPoints[L].Y := StartY;
  SetLength(Parts, L + 1);
  Parts[L] := TObjectList.Create(True);
end;

procedure TTTFToVectorConverter.Clear;
begin
  FCurveCollection.Clear;
end;

end.
