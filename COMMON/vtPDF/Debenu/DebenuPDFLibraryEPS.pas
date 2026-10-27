{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryEPS.pas                                }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryEPS;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, DebenuPDFLibraryMatrix, DebenuPDFLibraryGenericCanvas,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  DebenuPDFLibraryExtra;

type
  TPDFEPSLineCap = (epsLineCapButt, epsLineCapRound, epsLineCapSquare);

  TPDFEPSLineJoin = (epsLineJoinMiter, epsLineJoinRound, epsLineJoinBevel);

  TPDFEPSFillMode = (epsFillModeNonZeroWinding, epsFillModeEvenOdd);

  TPDFEPSExport = class(TPDFGenericCanvas)
  private
    FBuffer: TQuickPDFStringList;
    FImages: TQuickPDFStringList;
    FCustomColors: TQuickPDFStringList;
    FColorStack: TQuickPDFStringList;    
    FLastColor: AnsiString;
    FX: Double;
    FY: Double;
    procedure Add(const S: AnsiString);
    function F(F: Double): AnsiString;
    function I(I: Integer): AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    procedure StartDocument(Left, Bottom, Right, Top: Double);
    procedure FinishDocument;
    procedure SaveToFile(const FileName: WideString);
    procedure SaveToStream(Target: TStream);

    // GenericCanvas methods
    procedure BeginPath; override;
    procedure MoveTo(NewX, NewY: Double); override;
    procedure AddLineToPath(EndX, EndY: Double); override;
    procedure AddBezierToPath(CtAX, CtAY, CtBX, CtBY, EndX, EndY: Double); override;
    procedure AddQBezierToPath(QX, QY, EndX, EndY: Double); override;
    procedure ClosePath; override;
    procedure StrokePath; override;
    procedure FillPath; override;
    procedure StrokeAndFillPath; override;

    // Graphics state
    procedure PSSaveGraphicsState;
    procedure PSRestoreGraphicsState;
    procedure PSConcat(Mat: TPDFXForm);
    procedure PSSetColor(const NewColor: AnsiString);

    // Line properties
    procedure PSSetLineWidth(Width: Double);
    procedure PSSetLineCap(Cap: TPDFEPSLineCap);
    procedure PSSetLineJoin(Join: TPDFEPSLineJoin);
    procedure PSSetMiterLimit(MiterLimit: Double);

    // Path construction
    procedure PSNewPath;
    procedure PSMoveTo(X, Y: Double);
    procedure PSLineTo(X, Y: Double);
    procedure PSCurveTo(X1, Y1, X2, Y2, X3, Y3: Double);
    procedure PSCurveToV(X2, Y2, X3, Y3: Double);
    procedure PSCurveToY(X1, Y1, X3, Y3: Double);
    procedure PSClosePath;
    procedure PSClip(Mode: TPDFEPSFillMode = epsFillModeNonZeroWinding);

    // Path painting
    procedure PSStroke;
    procedure PSFill(Mode: TPDFEPSFillMode = epsFillModeNonZeroWinding);

    // Images
    procedure PSImageFromBitmap(BM, Mask: TBitmap; const ResName: AnsiString; IsMask: Boolean);
    procedure DrawBitmap(BM: TBitmap; var ULX, ULY, URX, URY, LLX, LLY: Double); override;

  end;

implementation

uses
  SysUtils,
{$IFDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryDither,
{$ENDIF}
  DebenuPDFLibraryFlate, DebenuPDFLibraryAscii85;

{ TPDFEPSExport }

constructor TPDFEPSExport.Create;
begin
  FBuffer := TQuickPDFStringList.Create;
  FImages := TQuickPDFStringList.Create;
  FCustomColors := TQuickPDFStringList.Create;
  FColorStack := TQuickPDFStringList.Create;
end;

destructor TPDFEPSExport.Destroy;
begin
  FBuffer.Free;
  FImages.Free;
  FCustomColors.Free;
  FColorStack.Free;
  inherited;
end;

procedure TPDFEPSExport.Add(const S: AnsiString);
var
  D: AnsiString;
begin
  if QPLCopy(S, Length(S), 1) = ' ' then
    D := QPLCopy(S, 1, Length(S) - 1)
  else
    D := S;
  FBuffer.Add(D);
end;

procedure TPDFEPSExport.FinishDocument;
var
  I: Integer;
  X: Integer;
  S: AnsiString;
  C: AnsiString;
begin
  I := FBuffer.IndexOf('%%EndComments');
  if I >= 0 then
  begin
    for X := 0 to FCustomColors.Count - 1 do
    begin
      C := FCustomColors[X];
      if X = 0 then
        S := '%%DocumentCustomColors: '
      else
        S := '%%+ ';
      S := S + QPLCopy(C, QPLPos('(', C), QPLPos(')', C) - QPLPos('(', C) + 1);
      FBuffer.Insert(I + X, S);
    end;
    I := FBuffer.IndexOf('%%EndComments');
    for X := 0 to FCustomColors.Count - 1 do
    begin
      C := FCustomColors[X];
      if X = 0 then
        S := '%%CMYKCustomColor: '
      else
        S := '%%+ ';
      S := S + QPLCopy(C, 1, QPLPos(')', C));
      FBuffer.Insert(I + X, S);
    end;
  end;
  Add('%%EOF');
end;

{$IFDEF QPL_DPLR}
//function TPDFEPSExport.GetCurrentMatrix: TPDFXForm;
//begin
  //
//end;
{$ENDIF}

procedure TPDFEPSExport.SaveToFile(const FileName: WideString);
begin
  FBuffer.SaveToFile(FileName);
end;

procedure TPDFEPSExport.StartDocument(Left, Bottom, Right, Top: Double);
begin
  FBuffer.Clear;
  FLastColor := '0 1 0 setrgbcolor';
  Add('%!PS-Adobe-3.0 EPSF-3.0');
  Add('%%BoundingBox: ' + I(Round(Left)) + I(Round(Bottom)) + I(Round(Right)) + I(Round(Top)));
  Add('%%Creator: (Quick PDF Library DVer)');
  Add('%%DocumentProcessColors: (Cyan) (Magenta) (Yellow) (Black)');
  Add('%%EndComments');
  Add('%%DebenuPDFLibrary-Start');
  Add('/c { curveto } def');
  Add('/cm { concat } def');
  Add('/cp { currentpoint } def');
  Add('/f { fill } def');
  Add('/f* { eofill } def');
  Add('/h { closepath } def');
  Add('/j { setlinejoin } def');
  Add('/J { setlinecap } def');
  Add('/l { lineto } def');
  Add('/m { moveto } def');
  Add('/M { setmiterlimit } def');
  Add('/n { newpath } def');
  Add('/q { gsave } def');
  Add('/Q { grestore } def');
  Add('/s { stroke } def');
  Add('/w { setlinewidth } def');
  Add('/W { clip } def');
  Add('/W* { eoclip } def');
  Add('%%DebenuPDFLibrary-End');

  FImages.Clear;
end;

function TPDFEPSExport.F(F: Double): AnsiString;
begin
  Result := QPLDoubleToStr(F, 4) + ' ';
end;

procedure TPDFEPSExport.PSConcat(Mat: TPDFXForm);
begin
  Add('[ ' + F(Mat.eM11) + F(Mat.eM12) + F(Mat.eM21) + F(Mat.eM22) +
    F(Mat.eDx) + F(Mat.eDy) + '] cm');
end;

procedure TPDFEPSExport.PSFill(Mode: TPDFEPSFillMode);
begin
  if Mode = epsFillModeNonZeroWinding then
    Add('f')
  else
    Add('f*');
end;

procedure TPDFEPSExport.PSRestoreGraphicsState;
begin
  Add('Q');
  if FColorStack.Count > 0 then
  begin
    FLastColor := FColorStack[FColorStack.Count - 1];
    FColorStack.Delete(FColorStack.Count - 1);
  end;
end;

procedure TPDFEPSExport.PSSaveGraphicsState;
begin
  Add('q');
  FColorStack.Add(FLastColor);
end;

procedure TPDFEPSExport.PSSetLineCap(Cap: TPDFEPSLineCap);
begin
  Add(I(Ord(Cap)) + 'J');
end;

procedure TPDFEPSExport.PSSetLineJoin(Join: TPDFEPSLineJoin);
begin
  Add(I(Ord(Join)) + 'j');
end;

procedure TPDFEPSExport.PSSetLineWidth(Width: Double);
begin
  if (Width > 1000) then
    Width := 1.0;

  Add(F(Width) + 'w');
end;

procedure TPDFEPSExport.PSStroke;
begin
  Add('s');
end;

function TPDFEPSExport.I(I: Integer): AnsiString;
begin
  Result := QPLIntToStr(I) + ' ';
end;

procedure TPDFEPSExport.PSLineTo(X, Y: Double);
begin
  Add(F(X) + F(Y) + 'l');
end;

procedure TPDFEPSExport.PSMoveTo(X, Y: Double);
begin
  Add(F(X) + F(Y) + 'm');
end;

procedure TPDFEPSExport.PSNewPath;
begin
  Add('n');
end;

procedure TPDFEPSExport.PSClosePath;
begin
  Add('h');
end;

procedure TPDFEPSExport.PSSetColor(const NewColor: AnsiString);
begin
  if QPLPos('findcmykcustomcolor', NewColor) > 0 then
  begin
    if FCustomColors.IndexOf(NewColor) < 0 then
      FCustomColors.Add(NewColor);
  end;
  if NewColor <> FLastColor then
  begin
    Add(NewColor);
    FLastColor := NewColor;
  end;
end;

procedure TPDFEPSExport.PSCurveTo(X1, Y1, X2, Y2, X3, Y3: Double);
begin
  Add(F(X1) + F(Y1) + F(X2) + F(Y2) + F(X3) + F(Y3) + 'c');
end;

procedure TPDFEPSExport.PSCurveToV(X2, Y2, X3, Y3: Double);
begin
  Add('cp ' + F(X2) + F(Y2) + F(X3) + F(Y3) + 'c');
end;

procedure TPDFEPSExport.PSCurveToY(X1, Y1, X3, Y3: Double);
begin
  Add(F(X1) + F(Y1) + F(X3) + F(Y3) + F(X3) + F(Y3) + 'c');
end;

procedure TPDFEPSExport.AddBezierToPath(CtAX, CtAY, CtBX, CtBY, EndX,
  EndY: Double);
begin
  PSCurveTo(CtAX, CtAY, CtBX, CtBY, EndX, EndY);
  FX := EndX;
  FY := EndY;
end;

procedure TPDFEPSExport.AddLineToPath(EndX, EndY: Double);
begin
  PSLineTo(EndX, EndY);
  FX := EndX;
  FY := EndY;
end;

procedure TPDFEPSExport.AddQBezierToPath(QX, QY, EndX, EndY: Double);
var
  CtAX: Double;
  CtAY: Double;
  CtBX: Double;
  CtBY: Double;
begin
  CtAX := FX + 2/3 * (QX - FX);
  CtAY := FY + 2/3 * (QY - FY);
  CtBX := QX + 1/3 * (EndX - QX);
  CtBY := QY + 1/3 * (EndY - QY);
  PSCurveTo(CtAX, CtAY, CtBX, CtBY, EndX, EndY);
  FX := EndX;
  FY := EndY;
end;

procedure TPDFEPSExport.BeginPath;
begin
  PSNewPath;
end;

procedure TPDFEPSExport.ClosePath;
begin
  PSClosePath;
end;

procedure TPDFEPSExport.FillPath;
begin
  PSFill;
end;

procedure TPDFEPSExport.MoveTo(NewX, NewY: Double);
begin
  PSMoveTo(NewX, NewY);
  FX := NewX;
  FY := NewY;
end;

procedure TPDFEPSExport.StrokeAndFillPath;
begin
  PSFill;
  PSStroke;
end;

procedure TPDFEPSExport.StrokePath;
begin
  PSStroke;
end;

procedure TPDFEPSExport.PSClip(Mode: TPDFEPSFillMode);
begin
  if Mode = epsFillModeNonZeroWinding then
    Add('W')
  else
    Add('W*');
end;

procedure TPDFEPSExport.PSImageFromBitmap(BM, Mask: TBitmap; const ResName: AnsiString; IsMask: Boolean);
var
  Row: Integer;
  Output: AnsiString;
  ScanLine: AnsiString;
  X: Integer;
  C: Integer;
  T: AnsiChar;
  MonoMask: TBitmap;
  BigMask: TBitmap;
  Stride: Integer;
//  BPC: Integer;
begin
  if FImages.IndexOf(ResName) < 0 then
  begin
    // Don't use shared image resources
    //FImages.Add(ResName);

    if Assigned(Mask) then
    begin
      MonoMask := TBitmap.Create;
      MonoMask.Width := Mask.Width * 2;
      MonoMask.Height := Mask.Height * 2;
      MonoMask.PixelFormat := pf8bit;

      Mask.PixelFormat := pf24bit;
      BigMask := TBitmap.Create;
      try
        BigMask.PixelFormat := pf24bit;
        BigMask.Width := Mask.Width * 2;
        BigMask.Height := Mask.Height * 2;
        BigMask.Canvas.Lock;
{$IFNDEF QPL_CPP}
        BigMask.Canvas.CopyRect(Rect(0, 0, BigMask.Width, BigMask.Height),
          Mask.Canvas, Rect(0, 0, Mask.Width, Mask.Height));
{$ENDIF}
{$IFDEF QPL_OS_WINDOWS}
        Dither(BigMask, MonoMask, 2);
{$ENDIF}
      finally
        BigMask.Free;
      end;

      MonoMask.PixelFormat := pf1bit;
    end else
      MonoMask := nil;

    if Assigned(MonoMask) then
    begin
      Add('currentfile /ASCII85Decode filter /FlateDecode filter');
      Add('/ReusableStreamDecode filter');
      Output := '';
      C := MonoMask.Width div 8;
      if C * 8 < MonoMask.Width then Inc(C);
      SetLength(ScanLine, C);
      for Row := 0 to MonoMask.Height - 1 do
      begin
        Move(MonoMask.ScanLine[Row]^, ScanLine[1], Length(ScanLine));
        Output := Output + ScanLine;
      end;
      Output := Ascii85EncodeStr(DeflateStr(Output));
      Add(Output);
      Add('/maskstreamfor' + ResName + ' exch def');
    end;

    Add('currentfile /ASCII85Decode filter /FlateDecode filter');
    Add('/ReusableStreamDecode filter');
    Output := '';

//    BPC := -1;
    Stride := -1;

    if (BM.PixelFormat = pf1Bit) then
    begin
      Stride := (BM.Width + 7) div 8;
//      BPC := 1;
    end else
    if (BM.PixelFormat = pf8Bit) then
    begin
      Stride := BM.Width;
//      BPC := 8;
    end else
    if (BM.PixelFormat = pf24Bit) then
    begin
      Stride := BM.Width * 3;
//      BPC := 8;
    end else
    if (BM.PixelFormat = pf32Bit) then
    begin
      Stride := BM.Width * 4;
//      BPC := 8;
    end;

    SetLength(ScanLine, Stride);
    for Row := 0 to BM.Height - 1 do
    begin
      Move(BM.ScanLine[Row]^, ScanLine[1], Length(ScanLine));

      // This code swaps the Red and Blue components.
      if (BM.PixelFormat = pf24Bit) then
        for X := 0 to BM.Width - 1 do
        begin
          T := ScanLine[X * 3 + 1];
          ScanLine[X * 3 + 1] := ScanLine[X * 3 + 3];
          ScanLine[X * 3 + 3] := T;
        end;

      Output := Output + ScanLine;
    end;
    Output := Ascii85EncodeStr(DeflateStr(Output));
    Add(Output);

    Add('/datastreamfor' + ResName + ' exch def');

    case BM.PixelFormat of
      pf1Bit: Add('/DeviceGray setcolorspace');
      pf8Bit: Add('/DeviceGray setcolorspace');
      pf24bit: Add('/DeviceRGB setcolorspace');
      pf32bit: Add('/DeviceCMYK setcolorspace');
    end;

    Add('/ImageDataDictionaryfor' + ResName + ' 8 dict def');
    Add('ImageDataDictionaryfor' + ResName + ' begin');
    Add('/ImageType 1 def');
    Add('/Width ' + I(BM.Width) + 'def');
    Add('/Height ' + I(BM.Height) + 'def');

    case BM.PixelFormat of
      pf1Bit: Add('/BitsPerComponent 1 def');
      pf8Bit: Add('/BitsPerComponent 8 def');
      pf32Bit: Add('/BitsPerComponent 8 def');
      pf24Bit: Add('/BitsPerComponent 8 def');
    end;

    Add('/DataSource datastreamfor' + ResName + ' def');
    Add('/MultipleDataSources false def');
    Add('/ImageMatrix [ ' + I(BM.Width) + '0 0 ' + I(-BM.Height) + '0 ' + I(BM.Height) + '] def');

    case BM.PixelFormat of
      pf1Bit: if (IsMask) then
              begin
                Add('/Decode [ 0 1 ] def')
              end else
              begin
                Add('/Decode [ 1 0 ] def');
              end;
      pf8Bit:  Add('/Decode [ 0 1 ] def');
      pf24Bit: Add('/Decode [ 0 1 0 1 0 1 ] def');
      pf32Bit: Add('/Decode [ 0 1 0 1 0 1 0 1 ] def');
    end;    
    Add('end');

    if Assigned(MonoMask) then
    begin
      Add('/ImageMaskDictionaryfor' + ResName + ' 8 dict def');
      Add('ImageMaskDictionaryfor' + ResName + ' begin');
      Add('/ImageType 1 def');
      Add('/Width ' + I(MonoMask.Width) + 'def');
      Add('/Height ' + I(MonoMask.Height) + 'def');
      Add('/BitsPerComponent 1 def');
      Add('/DataSource maskstreamfor' + ResName + ' def');
      Add('/MultipleDataSources false def');
      Add('/ImageMatrix [ ' + I(MonoMask.Width) + '0 0 ' + I(-MonoMask.Height) + '0 ' + I(MonoMask.Height) + '] def');
      Add('/Decode [ 1 0 ] def');
      Add('end');
      Add('/MaskedImageDictionaryfor' + ResName + ' 7 dict def');
      Add('MaskedImageDictionaryfor' + ResName + ' begin');
      Add('/ImageType 3 def');
      Add('/InterleaveType 3 def');
      Add('/MaskDict ImageMaskDictionaryfor' + ResName + ' def');
      Add('/DataDict ImageDataDictionaryfor' + ResName + ' def');
      Add('end');
    end;
    if Assigned(MonoMask) then MonoMask.Free;
  end;

  if Assigned(Mask) then
  begin
    Add('maskstreamfor' + ResName + ' resetfile');
    Add('datastreamfor' + ResName + ' resetfile');
    Add('MaskedImageDictionaryfor' + ResName + ' image');
  end else
  begin
    Add('datastreamfor' + ResName + ' resetfile');
    Add('ImageDataDictionaryfor' + ResName + ' image');
  end;
end;

procedure TPDFEPSExport.SaveToStream(Target: TStream);
begin
  FBuffer.SaveToStream(Target);
end;

procedure TPDFEPSExport.DrawBitmap(BM: TBitmap; var ULX, ULY, URX, URY, LLX, LLY: Double);
begin
//
end;

procedure TPDFEPSExport.PSSetMiterLimit(MiterLimit: Double);
begin
  Add(F(MiterLimit) + 'M');
end;

end.
