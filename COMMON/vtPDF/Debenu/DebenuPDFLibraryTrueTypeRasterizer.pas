{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryTrueTypeRasterizer.pas                 }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryTrueTypeRasterizer;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryTrueTypeParser, DebenuPDFLibraryFontRasterizer, DebenuPDFLibraryGenericCanvas,
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  DebenuPDFLibraryMatrix, DebenuPDFLibraryExtra,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  DebenuPDFLibraryFontConst,
  DebenuPDFLibraryTypes,
  DebenuPDFLibraryPicasso,
  DebenuPDFLibraryGDIPlus;

type
  TPDFTrueTypeRasterizer2 = class(TPDFFontRasterizer)
  private
    FSymbolic: Boolean;
    FParser: TPDFTrueTypeParser;
    FCharShapes: TQuickPDFCaseSensitiveStringList;
    FFontBitmap: TBitmap;
    FHasCFFTable: Boolean;
    FFontData: AnsiString;
    FIsZapfDingbats: Boolean;
    function GetFont: TFont;
  public
    constructor Create;
    destructor Destroy; override;
    function RenderToCanvas(var RX, RY: Double; Canvas: TPDFGenericCanvas; Mat: TPDFXForm;
      const CharName: AnsiString; Enc: TPDFEncodingVector): Boolean; override;
    function FontMatrixScaling: Double; override;
    procedure GetWidths(CharSet: TPDFCharsetNames; var Widths: TPDFCharsetWidths);
    procedure SetFlags(Flags: Integer);
    procedure LoadFromFont;
    property Parser: TPDFTrueTypeParser read FParser;
    property Symbolic: Boolean read FSymbolic;
    property Font: TFont read GetFont;
    property HasCFFTable: Boolean read FHasCFFTable;
    property FontData: AnsiString read FFontData;
    property IsZapfDingbats: Boolean read FIsZapfDingbats write FIsZapfDingbats;
  end;

  TPDFSimpleTrueTypeRasterizer = class(TPDFFontRasterizer)
  private
    FFontBitmap: TBitmap;
    FScreenDPI: Integer;
    DirectFontHandle: TQPLIntPtr;
    DirectFontGDIPlus: TDQPLGDIPlus;
    DirectFontDC: HDC;
    function GetFont: TFont;
  public
    constructor Create;
    destructor Destroy; override;
    function FontMatrixScaling: Double; override;
    function RenderToCanvas(var RX, RY: Double; Canvas: TPDFGenericCanvas; Mat: TPDFXForm;
      const CharName: AnsiString; Enc: TPDFEncodingVector): Boolean; override;
    property Font: TFont read GetFont;
    procedure SetupDirectFont(Canvas: TPDFGenericCanvas); override;
  end;

implementation

uses
  Classes, SysUtils,
{$IFNDEF VER120}
  contnrs,
{$ENDIF}
{$IFDEF QPL_OS_WINDOWS}
{$IFDEF QPL_XE2_HIGHER}
  System.UITypes,
{$ENDIF}
{$ENDIF}
  DebenuPDFLibraryTTFVector;

{ TPDFTrueTypeRasterizer2 }

constructor TPDFTrueTypeRasterizer2.Create;
begin
  FFontBitmap := TBitmap.Create;
  FFontBitmap.PixelFormat := pf24bit;
  FFontBitmap.Width := 10;
  FFontBitmap.Height := 10;
  FParser := TPDFTrueTypeParser.Create;
  FCharShapes := TQuickPDFCaseSensitiveStringList.Create;
  FHasCFFTable := False;
  FIsZapfDingbats := False;
end;

destructor TPDFTrueTypeRasterizer2.Destroy;
var
  X: Integer;
begin
  FParser.Free;
  for X := 0 to FCharShapes.Count - 1 do
    FCharShapes.Objects[X].Free;
  FCharShapes.Free;
  FFontBitmap.Free;
  inherited;
end;

function TPDFTrueTypeRasterizer2.FontMatrixScaling: Double;
begin
  Result := 1;
end;

function TPDFTrueTypeRasterizer2.GetFont: TFont;
begin
  Result := FFontBitmap.Canvas.Font;
end;

procedure TPDFTrueTypeRasterizer2.GetWidths(CharSet: TPDFCharsetNames;
  var Widths: TPDFCharsetWidths);
var
  X: Integer;
  I: Integer;
begin
  for X := 0 to 255 do
  begin
    I := FParser.HasPostName(CharSet[X]);
    if I >= 0 then
      Widths[X] := FParser.GetWidth(I)
    else
      if (I = -1) and (X >= 2) then
        Widths[X] := FParser.GetWidth(AdobeGIDToUnicode[X]-2);
  end;
end;

{$IFNDEF QPL_OS_WINDOWS}
procedure TPDFTrueTypeRasterizer2.LoadFromFont;
begin

end;
{$ELSE}
procedure TPDFTrueTypeRasterizer2.LoadFromFont;
var
  Len: Cardinal;
  TTCLen: Cardinal;
begin
  FFontBitmap.Canvas.Lock;
  try
    // Check for a TrueType Collection
    TTCLen := GetFontData(FFontBitmap.Canvas.Handle, $66637474, 0, nil, 0);

    Len := GetFontData(FFontBitmap.Canvas.Handle, 0, 0, nil, 0);
    if Len > (100 * 1024 * 1024) then
    begin
      FFontBitmap.Canvas.Font.Name := 'Arial';
      Len := GetFontData(FFontBitmap.Canvas.Handle, 0, 0, nil, 0);
      TTCLen := 0;
    end;
    if (Len > 0) and (Len < (100 * 1024 * 1024)) then
    begin
      if (TTCLen > 0) and (TTCLen <> GDI_ERROR) then
      begin
        FParser.TableOffset := TTCLen - Len;
      end else
        FParser.TableOffset := 0;
      SetLength(FFontData, Len);
      GetFontData(FFontBitmap.Canvas.Handle, 0, 0, @FFontData[1], Len);
    end else
      FFontData := '';
    FParser.LoadFromString(FFontData);
    FHasCFFTable := (FParser.GetCFFDataPosition > 0) and (Length(FFontData) > 0);
    if (not FHasCFFTable) then
    begin
      FFontData := '';
    end;
  finally
    FFontBitmap.Canvas.Unlock;
  end;
end;
{$ENDIF}

function TPDFTrueTypeRasterizer2.RenderToCanvas(var RX, RY: Double;
  Canvas: TPDFGenericCanvas; Mat: TPDFXForm; const CharName: AnsiString;
  Enc: TPDFEncodingVector): Boolean;
var
  GI: Integer;
  GITest: Integer;
  GT: TPDFTTglyfTable;
  CI: Integer;
  CX: Integer;
  TX, TY: Double;
  PL: Integer;
  ER: TPDFTTEncodingRecord;
  HeadTable: TPDFTTheadTable;
  GlyphMat: TPDFXForm;
  Shape: TPDFGenericShape;
  Found: Boolean;

  procedure Translate(var Mat: TPDFXForm; var _TX, _TY, X, Y: Double); {$IFNDEF QPL_NOINLINE}inline;{$ENDIF}
  begin
    _TX := Mat.eM11 * X + Mat.eM21 * Y + Mat.eDx;
    _TY := Mat.eM12 * X + Mat.eM22 * Y + Mat.eDy;
  end;

  procedure Translate2(var Mat: TPDFXForm; var _TX, _TY:Double; var X, Y: Integer); {$IFNDEF QPL_NOINLINE}inline;{$ENDIF}
  begin
    _TX := Mat.eM11 * X + Mat.eM21 * Y + Mat.eDx;
    _TY := Mat.eM12 * X + Mat.eM22 * Y + Mat.eDy;
  end;

  procedure DrawGlyph;
  var
    PC: Integer;
    Start: Boolean;
    StartX: Double;
    StartY: Double;
    C1X, C2X: Double;
    C1Y, C2Y: Double;
    ControlPointsX: array of Double;
    ControlPointsY: array of Double;
    ControlPointsSize: Integer;
    ControlPointsCount: Integer;
    CPI: Integer;
  begin
    ControlPointsSize := 20;
    SetLength(ControlPointsX, ControlPointsSize);
    SetLength(ControlPointsY, ControlPointsSize);
    ControlPointsCount := 0;
    CX := 0;
    Start := True;
    StartX := 0;
    StartY := 0;
    PL := Length(GT.Points);

    if ((GT.Flags[0] and 1) = 0) then
    begin
      // Starting point is an "off the contour" point so we need to set the start point to
      // the last point in the glyph so we can draw the bezier correctly.
      // This will only fix the first contour but I have only seen problems with the first contour.

      if (CX < Length(GT.endPtsOfContours)) then
      begin
        if (GT.endPtsOfContours[CX] < Length(GT.Points)) then
        begin
          Translate2(GlyphMat, TX, TY, GT.Points[GT.endPtsOfContours[CX]].X, GT.Points[GT.endPtsOfContours[CX]].Y);
          StartX := TX;
          StartY := TY;
          Shape.MoveTo(TX, TY);
          Start := False;
        end;
      end;
    end;

    for PC := 0 to PL - 1 do
    begin
      if Start then
      begin
        Translate2(GlyphMat, TX, TY, GT.Points[PC].X, GT.Points[PC].Y);
        StartX := TX;
        StartY := TY;
        Shape.MoveTo(TX, TY);
        Start := False;
      end else
      begin
        if GT.Flags[PC] and 1 = 0 then
        begin
          Translate2(GlyphMat, TX, TY, GT.Points[PC].X, GT.Points[PC].Y);
          ControlPointsX[ControlPointsCount] := TX;
          ControlPointsY[ControlPointsCount] := TY;
          Inc(ControlPointsCount);
          if ControlPointsCount = ControlPointsSize then
          begin
            Inc(ControlPointsSize, 20);
            SetLength(ControlPointsX, ControlPointsSize);
            SetLength(ControlPointsY, ControlPointsSize);
          end;
        end else
        begin
          Translate2(GlyphMat, TX, TY, GT.Points[PC].X, GT.Points[PC].Y);
          if ControlPointsCount > 0 then
          begin
            for CPI := 0 to ControlPointsCount - 2 do
            begin
              C1X := ControlPointsX[CPI];
              C1Y := ControlPointsY[CPI];
              C2X := ControlPointsX[CPI + 1];
              C2Y := ControlPointsY[CPI + 1];
              Shape.AddQBezierToPath(C1X, C1Y, C1X + (C2X - C1X) * 0.5, C1Y + (C2Y - C1Y) * 0.5);;
            end;
            CPI := ControlPointsCount - 1;
            Shape.AddQBezierToPath(ControlPointsX[CPI], ControlPointsY[CPI], TX, TY);
            ControlPointsCount := 0;
          end else
            Shape.AddLineToPath(TX, TY);
        end;
      end;
      if PC = GT.endPtsOfContours[CX] then
      begin
        Inc(CX);
        if ControlPointsCount > 0 then
        begin
          for CPI := 0 to ControlPointsCount - 2 do
          begin
            C1X := ControlPointsX[CPI];
            C1Y := ControlPointsY[CPI];
            C2X := ControlPointsX[CPI + 1];
            C2Y := ControlPointsY[CPI + 1];
            Shape.AddQBezierToPath(C1X, C1Y, C1X + (C2X - C1X) / 2, C1Y + (C2Y - C1Y) / 2);
          end;
          CPI := ControlPointsCount - 1;
          Shape.AddQBezierToPath(ControlPointsX[CPI], ControlPointsY[CPI], StartX, StartY);
          ControlPointsCount := 0;
        end else
          Shape.AddLineToPath(TX, TY);

        Shape.ClosePath;
        Start := True;
      end;
    end;
  end;

  procedure DrawComposite;
  var
    CompX: Integer;
    CGT: TPDFTTglyfTable;
    C: TPDFTTComposite;
    OldRX, OldRY: Double;
    OldMat: TPDFXForm;
    TM: TPDFXForm;
  const
    // https://www.microsoft.com/typography/otspec/glyf.htm
    ARG_1_AND_2_ARE_WORDS = 1;
    ARGS_ARE_XY_VALUES = 2;
    ROUND_XY_TO_GRID = 4;
    WE_HAVE_A_SCALE = 8;
    WE_HAVE_AN_X_AND_Y_SCALE = 64;
    WE_HAVE_A_TWO_BY_TWO = 128;
  begin
    OldRX := RX;
    OldRY := RY;
    OldMat := GlyphMat;
    CGT := GT;
    for CompX := 0 to Length(CGT.Composites) - 1 do
    begin
      RX := OldRX;
      RY := OldRY;
      GlyphMat := OldMat;
      C := CGT.Composites[CompX];
      GT := FParser.GetGlyphData(C.glyphIndex);

      if (C.flags and WE_HAVE_A_TWO_BY_TWO = WE_HAVE_A_TWO_BY_TWO)
        or (C.Flags = 15) then  // malformed ??
      begin
        TM.eDx := C.argument1;
        TM.eDy := C.argument2;
        TM.eM11 := C.xscale;
        TM.eM12 := C.scale01;
        TM.eM21 := C.scale10;
        TM.eM22 := C.yscale;
      end else
      begin
        Move(TPDFXFormIdentity, TM, SizeOf(TM));
        if C.flags and ARGS_ARE_XY_VALUES = ARGS_ARE_XY_VALUES then
        begin
          TM.eDx := C.argument1;
          TM.eDy := C.argument2;
        end;
        if C.flags and WE_HAVE_AN_X_AND_Y_SCALE = WE_HAVE_AN_X_AND_Y_SCALE then
        begin
          TM.eM11 := C.xscale;
          TM.eM22 := C.yscale;
        end;
      end;

      CombinePDFXForm(GlyphMat, TM, GlyphMat);

    	if GT.numberOfContours = 0 then
        DrawComposite
      else
        DrawGlyph;
    end;
  end;

begin
  HeadTable := FParser.GetHeadTable;
  if FParser.GlyphCount > 0 then
  begin
    {GlyphMat.eM11 := 1;
    GlyphMat.eM12 := 0;
    GlyphMat.eM21 := 0;
    GlyphMat.eM22 := 1;
    GlyphMat.eDx := 0;
    GlyphMat.eDy := 0;

    SM.eM11 := 1000 / HeadTable.unitsPerEm;
    SM.eM12 := 0;
    SM.eM21 := 0;
    SM.eM22 := 1000 / HeadTable.unitsPerEm;
    SM.eDx := 0;
    SM.eDy := 0;
    CombinePDFXForm(GlyphMat, SM, GlyphMat);}
    Result := True;

    GI := FCharShapes.IndexOf(CharName);
    if GI >= 0 then
    begin
      Shape := TPDFGenericShape(FCharShapes.Objects[GI]);

      Move(TPDFXFormIdentity, GlyphMat, TPDFXFormEMSize);
      GlyphMat.eDx := RX;
      GlyphMat.eDy := RY;

      CombinePDFXForm(Mat, GlyphMat, Mat);

      Canvas.DrawShape(Shape, Mat);
    end else
    begin
      Move(TPDFXFormIdentity, GlyphMat, SizeOf(GlyphMat));
      GlyphMat.eM11 := 1000 / HeadTable.unitsPerEm;
      GlyphMat.eM22 := GlyphMat.eM11;

      Shape := TPDFGenericShape.Create;
      FCharShapes.AddObject(CharName, Shape);
      GI := -1;

      if QPLStartsWith(CharName, 'U+') then
      begin
        GITest := QPLStrToIntDef('$' + Copy(CharName, 3, 4), 0);

        // We have a Unicode character value, search for a Unicode "cmap"
        CI := FParser.Findcmap(3, 1);
        if CI >= 0 then
        begin
          ER := FParser.Getcmap(CI);
          CI := 0;
          Found := False;
          while (not Found) and (CI < Length(ER.Codes)) do
          begin
            if ER.Codes[CI] = GITest then
            begin
              Found := True;
              GI := ER.GlyfID[CI];
            end else
              Inc(CI);
          end;
        end else
        begin
          // The font does not have a Unicode cmap, convert the character
          // to a PostScript name and search the "post" table
          if (FParser.PostCount > 0) then
          begin
            GITest := FParser.HasPostName(GetUnicodeGlyph(WideChar(GITest)));
            if GITest >= 0 then
              GI := GITest;
          end;
        end;
      end;

      if QPLStartsWith(CharName, 'PS:') then
      begin
        if (FParser.PostCount > 0) then
        begin
          GITest := FParser.HasPostName(QPLCopy(CharName, 4, MaxInt));
          if GITest >= 0 then
            GI := GITest;
        end;
      end;

      if QPLStartsWith(CharName, 'GID:') then
      begin
        GI := QPLStrToIntDef(QPLCopy(CharName, 5, MaxInt), 0);
      end;

      if ((GI = -1) and FSymbolic) then
      begin
        CI := FParser.Findcmap(3, 0);
        if CI >= 0 then
        begin
          ER := FParser.Getcmap(CI);
          GITest := QPLStrToIntDef(QPLCopy(CharName, 5, MaxInt), 0);
          for CI := 0 to Length(ER.Codes) - 1 do
          begin
            if (GI = -1) and ((ER.Codes[CI] and $FF) = GITest) then
              GI := ER.GlyfID[CI];
          end;
        end;
        if GI = -1 then
        begin
          CI := FParser.Findcmap(1, 0);
          if CI >= 0 then
          begin
            ER := FParser.Getcmap(CI);
            GITest := QPLStrToIntDef(QPLCopy(CharName, 5, MaxInt), 0);
            for CI := 0 to Length(ER.Codes) - 1 do
            begin
              if (GI = -1) and ((ER.Codes[CI] and $FF) = GITest) then
                GI := ER.GlyfID[CI];
            end;
          end;
        end;
        if GI = -1 then
        begin
          CI := FParser.Findcmap(3, 1);
          if CI >= 0 then
          begin
            ER := FParser.Getcmap(CI);
            GITest := QPLStrToIntDef(QPLCopy(CharName, 5, MaxInt), 0);
            for CI := 0 to Length(ER.Codes) - 1 do
            begin
              if (GI = -1) and ((ER.Codes[CI] and $FF) = GITest) then
                GI := ER.GlyfID[CI];
            end;
          end;
        end;
      end;
      if (GI = -1) then
      begin
        CI := FParser.Findcmap(3, 1);
        if (CI < 0) then
          CI := FParser.FindUnicodecmap;  // D14241 : Search for a Unicode CMap entry

        if CI >= 0 then
        begin
          ER := FParser.Getcmap(CI);
          GITest := GetGlyphUnicode(CharName);
          CI := 0;
          Found := False;
          while (not Found) and (CI < Length(ER.Codes)) do
          begin
            if ER.Codes[CI] = GITest then
            begin
              Found := True;
              GI := ER.GlyfID[CI];
            end else
              Inc(CI);
          end;
        end;
      end;
      if (GI = -1) then
      begin
        CI := FParser.Findcmap(1, 0);
        if CI >= 0 then
        begin
          ER := FParser.Getcmap(CI);
          CI := GetCharID(CharName);
          if CI >= 1 then
          begin
            CI := MacRomanEncodingVector[CI];
            if (CI >= 1) and (Length(ER.Codes) = 256) and (CI <= 255) then
              GI := ER.GlyfID[CI];
          end;
        end;
      end;

      if (GI = -1) and (FParser.PostCount > 0) then
      begin
        GITest := FParser.HasPostName(CharName);
        if GITest >= 0 then
          GI := GITest;
      end;

      if (GI = -1) and (QPLStartsWith(CharName, 'uni') or QPLStartsWith(CharName, 'a')) then
      begin
        GITest := 0;
        if (CharName[1] = 'a') then
        begin
          if (CharName = 'a1') then GITest := $2701;
          if (CharName = 'a2') then GITest := $2702;
          if (CharName = 'a202') then GITest := $2703;
          if (CharName = 'a3') then GITest := $2704;
          if (CharName = 'a4') then GITest := $260E;
          if (CharName = 'a5') then GITest := $2706;
          if (CharName = 'a119') then GITest := $2707;
          if (CharName = 'a118') then GITest := $2708;
          if (CharName = 'a117') then GITest := $2709;
          if (CharName = 'a11') then GITest := $261B;
          if (CharName = 'a12') then GITest := $261E;
          if (CharName = 'a13') then GITest := $270C;
          if (CharName = 'a14') then GITest := $270D;
          if (CharName = 'a15') then GITest := $270E;
          if (CharName = 'a16') then GITest := $270F;
          if (CharName = 'a105') then GITest := $2710;
          if (CharName = 'a17') then GITest := $2711;
          if (CharName = 'a18') then GITest := $2712;
          if (CharName = 'a19') then GITest := $2713;
          if (CharName = 'a20') then GITest := $2714;
          if (CharName = 'a21') then GITest := $2715;
          if (CharName = 'a22') then GITest := $2716;
          if (CharName = 'a23') then GITest := $2717;
          if (CharName = 'a24') then GITest := $2718;
          if (CharName = 'a25') then GITest := $2719;
          if (CharName = 'a26') then GITest := $271A;
          if (CharName = 'a27') then GITest := $271B;
          if (CharName = 'a28') then GITest := $271C;
          if (CharName = 'a6') then GITest := $271D;
          if (CharName = 'a7') then GITest := $271E;
          if (CharName = 'a8') then GITest := $271F;
          if (CharName = 'a9') then GITest := $2720;
          if (CharName = 'a10') then GITest := $2721;
          if (CharName = 'a29') then GITest := $2722;
          if (CharName = 'a30') then GITest := $2723;
          if (CharName = 'a31') then GITest := $2724;
          if (CharName = 'a32') then GITest := $2725;
          if (CharName = 'a33') then GITest := $2726;
          if (CharName = 'a34') then GITest := $2727;
          if (CharName = 'a35') then GITest := $2605;
          if (CharName = 'a36') then GITest := $2729;
          if (CharName = 'a37') then GITest := $272A;
          if (CharName = 'a38') then GITest := $272B;
          if (CharName = 'a39') then GITest := $272C;
          if (CharName = 'a40') then GITest := $272D;
          if (CharName = 'a41') then GITest := $272E;
          if (CharName = 'a42') then GITest := $272F;
          if (CharName = 'a43') then GITest := $2730;
          if (CharName = 'a44') then GITest := $2731;
          if (CharName = 'a45') then GITest := $2732;
          if (CharName = 'a46') then GITest := $2733;
          if (CharName = 'a47') then GITest := $2734;
          if (CharName = 'a48') then GITest := $2735;
          if (CharName = 'a49') then GITest := $2736;
          if (CharName = 'a50') then GITest := $2737;
          if (CharName = 'a51') then GITest := $2738;
          if (CharName = 'a52') then GITest := $2739;
          if (CharName = 'a53') then GITest := $273A;
          if (CharName = 'a54') then GITest := $273B;
          if (CharName = 'a55') then GITest := $273C;
          if (CharName = 'a56') then GITest := $273D;
          if (CharName = 'a57') then GITest := $273E;
          if (CharName = 'a58') then GITest := $273F;
          if (CharName = 'a59') then GITest := $2740;
          if (CharName = 'a60') then GITest := $2741;
          if (CharName = 'a61') then GITest := $2742;
          if (CharName = 'a62') then GITest := $2743;
          if (CharName = 'a63') then GITest := $2744;
          if (CharName = 'a64') then GITest := $2745;
          if (CharName = 'a65') then GITest := $2746;
          if (CharName = 'a66') then GITest := $2747;
          if (CharName = 'a67') then GITest := $2748;
          if (CharName = 'a68') then GITest := $2749;
          if (CharName = 'a69') then GITest := $274A;
          if (CharName = 'a70') then GITest := $274B;
          if (CharName = 'a71') then GITest := $25CF;
          if (CharName = 'a72') then GITest := $274D;
          if (CharName = 'a73') then GITest := $25A0;
          if (CharName = 'a74') then GITest := $274F;
          if (CharName = 'a203') then GITest := $2750;
          if (CharName = 'a75') then GITest := $2751;
          if (CharName = 'a204') then GITest := $2752;
          if (CharName = 'a76') then GITest := $25B2;
          if (CharName = 'a77') then GITest := $25BC;
          if (CharName = 'a78') then GITest := $25C6;
          if (CharName = 'a79') then GITest := $2756;
          if (CharName = 'a81') then GITest := $25D7;
          if (CharName = 'a82') then GITest := $2758;
          if (CharName = 'a83') then GITest := $2759;
          if (CharName = 'a84') then GITest := $275A;
          if (CharName = 'a97') then GITest := $275B;
          if (CharName = 'a98') then GITest := $275C;
          if (CharName = 'a99') then GITest := $275D;
          if (CharName = 'a100') then GITest := $275E;
          if (CharName = 'a101') then GITest := $2761;
          if (CharName = 'a102') then GITest := $2762;
          if (CharName = 'a103') then GITest := $2763;
          if (CharName = 'a104') then GITest := $2764;
          if (CharName = 'a106') then GITest := $2765;
          if (CharName = 'a107') then GITest := $2766;
          if (CharName = 'a108') then GITest := $2767;
          if (CharName = 'a112') then GITest := $2663;
          if (CharName = 'a111') then GITest := $2666;
          if (CharName = 'a110') then GITest := $2665;
          if (CharName = 'a109') then GITest := $2660;
          if (CharName = 'a120') then GITest := $2460;
          if (CharName = 'a121') then GITest := $2461;
          if (CharName = 'a122') then GITest := $2462;
          if (CharName = 'a123') then GITest := $2463;
          if (CharName = 'a124') then GITest := $2464;
          if (CharName = 'a125') then GITest := $2465;
          if (CharName = 'a126') then GITest := $2466;
          if (CharName = 'a127') then GITest := $2467;
          if (CharName = 'a128') then GITest := $2468;
          if (CharName = 'a129') then GITest := $2469;
          if (CharName = 'a130') then GITest := $2776;
          if (CharName = 'a131') then GITest := $2777;
          if (CharName = 'a132') then GITest := $2778;
          if (CharName = 'a133') then GITest := $2779;
          if (CharName = 'a134') then GITest := $277A;
          if (CharName = 'a135') then GITest := $277B;
          if (CharName = 'a136') then GITest := $277C;
          if (CharName = 'a137') then GITest := $277D;
          if (CharName = 'a138') then GITest := $277E;
          if (CharName = 'a139') then GITest := $277F;
          if (CharName = 'a140') then GITest := $2780;
          if (CharName = 'a141') then GITest := $2781;
          if (CharName = 'a142') then GITest := $2782;
          if (CharName = 'a143') then GITest := $2783;
          if (CharName = 'a144') then GITest := $2784;
          if (CharName = 'a145') then GITest := $2785;
          if (CharName = 'a146') then GITest := $2786;
          if (CharName = 'a147') then GITest := $2787;
          if (CharName = 'a148') then GITest := $2788;
          if (CharName = 'a149') then GITest := $2789;
          if (CharName = 'a150') then GITest := $278A;
          if (CharName = 'a151') then GITest := $278B;
          if (CharName = 'a152') then GITest := $278C;
          if (CharName = 'a153') then GITest := $278D;
          if (CharName = 'a154') then GITest := $278E;
          if (CharName = 'a155') then GITest := $278F;
          if (CharName = 'a156') then GITest := $2790;
          if (CharName = 'a157') then GITest := $2791;
          if (CharName = 'a158') then GITest := $2792;
          if (CharName = 'a160') then GITest := $2794;
          if (CharName = 'a161') then GITest := $2192;
          if (CharName = 'a163') then GITest := $2194;
          if (CharName = 'a164') then GITest := $2195;
          if (CharName = 'a196') then GITest := $2798;
          if (CharName = 'a165') then GITest := $2799;
          if (CharName = 'a192') then GITest := $279A;
          if (CharName = 'a166') then GITest := $279B;
          if (CharName = 'a167') then GITest := $279C;
          if (CharName = 'a168') then GITest := $279D;
          if (CharName = 'a169') then GITest := $279E;
          if (CharName = 'a170') then GITest := $279F;
          if (CharName = 'a171') then GITest := $27A0;
          if (CharName = 'a172') then GITest := $27A1;
          if (CharName = 'a173') then GITest := $27A2;
          if (CharName = 'a162') then GITest := $27A3;
          if (CharName = 'a174') then GITest := $27A4;
          if (CharName = 'a175') then GITest := $27A5;
          if (CharName = 'a176') then GITest := $27A6;
          if (CharName = 'a177') then GITest := $27A7;
          if (CharName = 'a178') then GITest := $27A8;
          if (CharName = 'a179') then GITest := $27A9;
          if (CharName = 'a193') then GITest := $27AA;
          if (CharName = 'a180') then GITest := $27AB;
          if (CharName = 'a199') then GITest := $27AC;
          if (CharName = 'a181') then GITest := $27AD;
          if (CharName = 'a200') then GITest := $27AE;
          if (CharName = 'a182') then GITest := $27AF;
          if (CharName = 'a201') then GITest := $27B1;
          if (CharName = 'a183') then GITest := $27B2;
          if (CharName = 'a184') then GITest := $27B3;
          if (CharName = 'a197') then GITest := $27B4;
          if (CharName = 'a185') then GITest := $27B5;
          if (CharName = 'a194') then GITest := $27B6;
          if (CharName = 'a198') then GITest := $27B7;
          if (CharName = 'a186') then GITest := $27B8;
          if (CharName = 'a195') then GITest := $27B9;
          if (CharName = 'a187') then GITest := $27BA;
          if (CharName = 'a188') then GITest := $27BB;
          if (CharName = 'a189') then GITest := $27BC;
          if (CharName = 'a190') then GITest := $27BD;
          if (CharName = 'a191') then GITest := $27BE;
          if (CharName = 'a89') then GITest := $F8D7;
          if (CharName = 'a90') then GITest := $F8D8;
          if (CharName = 'a93') then GITest := $F8D9;
          if (CharName = 'a94') then GITest := $F8DA;
          if (CharName = 'a91') then GITest := $F8DB;
          if (CharName = 'a92') then GITest := $F8DC;
          if (CharName = 'a205') then GITest := $F8DD;
          if (CharName = 'a85') then GITest := $F8DE;
          if (CharName = 'a206') then GITest := $F8DF;
          if (CharName = 'a86') then GITest := $F8E0;
          if (CharName = 'a87') then GITest := $F8E1;
          if (CharName = 'a88') then GITest := $F8E2;
          if (CharName = 'a95') then GITest := $F8E3;
          if (CharName = 'a96') then GITest := $F8E4;
          if (CharName = 'a95') then GITest := $F8E3;
          if (CharName = 'a96') then GITest := $F8E4;
        end else
        begin
          GITest := QPLStrToIntDef('$' + Copy(CharName, 4, Maxint), 0);
        end;

        // We have a Unicode character value, search for a Unicode "cmap"
        CI := FParser.Findcmap(3, 1);
        if CI >= 0 then
        begin
          ER := FParser.Getcmap(CI);
          CI := 0;
          Found := False;
          while (not Found) and (CI < Length(ER.Codes)) do
          begin
            if ER.Codes[CI] = GITest then
            begin
              Found := True;
              GI := ER.GlyfID[CI];
            end else
              Inc(CI);
          end;
        end else
        begin
          // The font does not have a Unicode cmap, convert the character
          // to a PostScript name and search the "post" table
          if (FParser.PostCount > 0) then
          begin
            GITest := FParser.HasPostName(GetUnicodeGlyph(WideChar(GITest)));
            if GITest >= 0 then
              GI := GITest;
          end;
        end;
      end;

      if (GI <> -1) then
      begin
        GT := FParser.GetGlyphData(GI);
      	if GT.numberOfContours = 0 then
      	begin
          DrawComposite;
        end else
        begin
          DrawGlyph;
        end;
      end;

      Move(TPDFXFormIdentity, GlyphMat, TPDFXFormEMSize);
      GlyphMat.eDx := RX;
      GlyphMat.eDy := RY;

      CombinePDFXForm(Mat, GlyphMat, Mat);

      Canvas.DrawShape(Shape, Mat);
    end;
  end else
    Result := False;
end;

procedure TPDFTrueTypeRasterizer2.SetFlags(Flags: Integer);
begin
  FSymbolic := Flags and 4 = 4;
end;

{ TPDFSimpleTrueTypeRasterizer }

constructor TPDFSimpleTrueTypeRasterizer.Create;
{$IFDEF QPL_OS_WINDOWS}
var
  ScreenDC: HDC;
{$ENDIF}
begin
  FFontBitmap := TBitmap.Create;
  FFontBitmap.PixelFormat := pf24bit;
  FFontBitmap.Width := 10;
  FFontBitmap.Height := 10;
{$IFNDEF QPL_OS_WINDOWS}
  FScreenDPI := 96;
{$ELSE}
  ScreenDC := GetDC(0);
  try
    FScreenDPI := GetDeviceCaps(ScreenDC, LOGPIXELSX);
  finally
    ReleaseDC(0, ScreenDC);
  end;
{$ENDIF}
  DirectFontHandle := 0;
end;

destructor TPDFSimpleTrueTypeRasterizer.Destroy;
begin
  FFontBitmap.Free;
  if (DirectFontHandle > 0) then
  begin
    // DirectFontGDIPlus.GdipDeleteFont(DirectFontHandle);
  end;
  inherited;
end;

function TPDFSimpleTrueTypeRasterizer.FontMatrixScaling: Double;
begin
  Result := 1;
end;

function TPDFSimpleTrueTypeRasterizer.GetFont: TFont;
begin
  Result := FFontBitmap.Canvas.Font;
end;

function TPDFSimpleTrueTypeRasterizer.RenderToCanvas(var RX, RY: Double;
  Canvas: TPDFGenericCanvas; Mat: TPDFXForm;
  const CharName: AnsiString; Enc: TPDFEncodingVector): Boolean;
var
  GlyphBBox: array[1..4] of Integer;
  VC: TTTFToVectorConverter;
  X: Integer;
  CX, CY: Double;
  Parts: TObjectList;
  ThisChar: Integer;
  PX: Integer;
  CtAX, CtAY, CtBX, CtBY: Double;
  GlyphMat: TPDFXForm;

  procedure Translate(var Mat: TPDFXForm; var TX, TY, X, Y: Double);
  begin
    TX := Mat.eM11 * X + Mat.eM21 * Y + Mat.eDx;
    TY := Mat.eM12 * X + Mat.eM22 * Y + Mat.eDy;
  end;

begin
  if (DirectFontHandle > 0) then
  begin
    if (Canvas is TPDFPicasso) then
    begin
      if (Length(CharName) = 1) then
      begin
        TPDFPicasso(Canvas).DrawDirectString(DirectFontHandle, WideChar(CharName[1]), Mat);
      end;
    end;
    Result := True;
    Exit;
  end;

  GlyphBBox[1] := 1000;
  GlyphBBox[2] := 1000;
  GlyphBBox[3] := 0;
  GlyphBBox[4] := 0;

  Move(TPDFXFormIdentity, GlyphMat, TPDFXFormEMSize);
  GlyphMat.eDx := RX;
  GlyphMat.eDy := RY;

  CombinePDFXForm(Mat, GlyphMat, Mat);

  VC := TTTFToVectorConverter.Create;
  try
    VC.Font.Name := Font.Name;
    VC.Font.Style := Font.Style;
    if FScreenDPI > 0 then
      VC.Font.Size := Round(72000 / FScreenDPI)
    else
      VC.Font.Size := 750;
    VC.Font.Charset := Font.Charset;

    if (QPLStartsWith(CharName, 'CID:') or QPLStartsWith(CharName, 'GID:')) then
      ThisChar := QPLStrToIntDef(QPLCopy(CharName, 5, MaxInt), 0)
    else
      ThisChar := 0;
    VC.GetCharacterGlyphs(ThisChar);
    for X := 0 to Length(VC.CurveCollection.StartPoints) - 1 do
    begin
      Translate(Mat, CX, CY,
        VC.CurveCollection.StartPoints[X].X,
        VC.CurveCollection.StartPoints[X].Y);

      if Round(CX) < GlyphBBox[1] then GlyphBBox[1] := Round(CX);
      if Round(CX) > GlyphBBox[3] then GlyphBBox[3] := Round(CX);
      if Round(CY) < GlyphBBox[2] then GlyphBBox[2] := Round(CY);
      if Round(CY) > GlyphBBox[4] then GlyphBBox[4] := Round(CY);
      if X = 0 then
      begin
//        Canvas.BeginPath;
        Canvas.MoveTo(CX, CY);
      end else
        Canvas.MoveTo(CX, CY);

      Parts := VC.CurveCollection.Parts[X];
      for PX := 0 to Parts.Count - 1 do
      begin
        if Parts.Items[PX] is TFontLine then
        begin
          Translate(Mat, CX, CY,
            TFontLine(Parts.Items[PX]).EndPoint.X,
            TFontLine(Parts.Items[PX]).EndPoint.Y);
          if Round(CX) < GlyphBBox[1] then GlyphBBox[1] := Round(CX);
          if Round(CX) > GlyphBBox[3] then GlyphBBox[3] := Round(CX);
          if Round(CY) < GlyphBBox[2] then GlyphBBox[2] := Round(CY);
          if Round(CY) > GlyphBBox[4] then GlyphBBox[4] := Round(CY);
          Canvas.AddLineToPath(CX, CY);
        end;
        if Parts.Items[PX] is TFontSpline then
        begin
          Translate(Mat, CtAX, CtAY,
            TFontSpline(Parts.Items[PX]).ControlA.X,
            TFontSpline(Parts.Items[PX]).ControlA.Y);

          Translate(Mat, CtBX, CtBY,
            TFontSpline(Parts.Items[PX]).ControlB.X,
            TFontSpline(Parts.Items[PX]).ControlB.Y);

          Translate(Mat, CX, CY,
            TFontSpline(Parts.Items[PX]).EndPoint.X,
            TFontSpline(Parts.Items[PX]).EndPoint.Y);
          if Round(CX) < GlyphBBox[1] then GlyphBBox[1] := Round(CX);
          if Round(CX) > GlyphBBox[3] then GlyphBBox[3] := Round(CX);
          if Round(CY) < GlyphBBox[2] then GlyphBBox[2] := Round(CY);
          if Round(CY) > GlyphBBox[4] then GlyphBBox[4] := Round(CY);
          Canvas.AddBezierToPath(CtAX, CtAY, CtBX, CtBY, CX, CY);
        end;
      end;
      Canvas.ClosePath;
    end;
  finally
    VC.Free;
  end;
  Result := ThisChar > 0;
end;

procedure TPDFSimpleTrueTypeRasterizer.SetupDirectFont(Canvas: TPDFGenericCanvas);
begin
  inherited;
  if (Canvas is TPDFPicasso) then
  begin
    if (TPDFPicasso(Canvas).Model = pmGDIPlus) then
    begin
      DirectFontGDIPlus := TPDFPicasso(Canvas).GDIPlus;
      // DirectFontDC := TPDFPicasso(Canvas).GetDeviceContext;
      DirectFontDC := FFontBitmap.Canvas.Handle;
      DirectFontGDIPlus.GdipCreateFontFromDC(DirectFontDC, DirectFontHandle);
    end;
  end;
end;

end.
