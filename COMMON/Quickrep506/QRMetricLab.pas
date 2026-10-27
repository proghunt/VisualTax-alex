{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 6.0 for Delphi and C++Builder               ::
  ::                                                         ::
  :: QRMetricLab   TQRMetricLabel                             ::
  ::                                                         ::
  :: Copyright (c) 2013 QBS Software                         ::
  :: All Rights Reserved                                     ::
 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::}

 unit QRMetricLab;

interface
uses Messages, Windows, Classes, Controls, StdCtrls, SysUtils, Graphics,
     Forms, ExtCtrls, Dialogs, Printers, ComCtrls,
     QRPrntr, QuickRpt, Qr5Const, qrctrls;

type
TQRMetlabOnPrintEvent = procedure (sender : TObject; gcanvas : TCanvas; var printString : string) of object;
TSpacingMode = (Horiz, HorizAndVertical);

TQRMetricLabel = class(TQRCustomLabel)
  private
    FBeforePrint : TQRMetlabOnPrintEvent;
    FSpacingMode : TSpacingMode;
    FXlist : TStrings;
    FYList : TStrings;
    lzCaption : PChar;
    procedure SetBeforePrint( value : TQRMetlabOnPrintEvent);
    procedure SetXlist( value : TStrings);
    procedure SetYlist( value : TStrings);

  protected
    procedure Paint; override;
    procedure Print(OfsX, OfsY : integer); override;
  public
    FXValues : array[0..255] of integer;
    FYValues : array[0..255] of integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Prepare;override;
  published
    property BeforePrint: TQRMetlabOnPrintEvent read FBeforePrint write SetBeforePrint;
    property Autosize;
    property Visible;
    property XLColumn;
    property Font;
    property Transparent;
    property color;
    property Caption;
    property SpacingMode : TSpacingMode read FSpacingMode write FSpacingMode;
    property X_Spacing : TStrings read FXlist write SetXList;
    property Y_Spacing : TStrings read FYlist write SetYlist;
  end;

implementation

constructor TQRMetricLabel.Create(AOwner: TComponent);
begin
      inherited create(AOwner);
      FXList := TStringlist.Create;
      FYList := TStringlist.Create;
end;

destructor TQRMetricLabel.Destroy;
begin
     FXList.Free;
     FYList.Free;
     inherited Destroy;
end;

procedure TQRMetricLabel.SetBeforePrint( value : TQRMetlabOnPrintEvent);
begin
     FBeforePrint := value;
end;

procedure TQRMetricLabel.SetXList(Value : TStrings);
begin
  FXlist.Assign(Value);
end;

procedure TQRMetricLabel.SetYList(Value : TStrings);
begin
  FYlist.Assign(Value);
end;


procedure TQRMetricLabel.Paint;
begin
  inherited Paint;
end;

procedure TQRMetricLabel.Prepare;
var
    clen, k : integer;
    xscale : extended;
begin
  inherited Prepare;
  clen := length(caption);
  if clen > 256 then caption := copy(caption,1,256);
  if parentreport.QRPrinter.Destination = qrdPrinter then
  begin
       xscale := parentreport.QRPrinter.XFactor/(screen.PixelsPerInch/254);
  end
  else
      xscale := 1.0;

  for k := 0 to fxlist.Count-1 do FXValues[k] := round(strtoint(trim(FXList[k]))*xscale);
  if fxlist.Count<clen then
  begin
      // pad out FXValues
      for k := fxlist.Count to clen-1 do FXValues[k] := FXValues[fxlist.Count-1];
  end;
end;

procedure TQRMetricLabel.Print(OfsX, OfsY : integer);
var
   gcanvas : TCanvas;
   CanvasRect : TRect ;
   cRgn : HRGN ;
   printString : string;
   res, clen : integer;
   xp, yp : integer;
   ochar : char;
   expshp : TQRShape;
begin
     // determine the rectangle of the canvas of this control:
     printString := caption;
     CanvasRect.left   := QRPrinter.XPos(OfsX + Size.Left);
     CanvasRect.top    := QRPrinter.YPos(OfsY + Size.Top);
     CanvasRect.right  := QRPrinter.XPos(OfsX + Size.Left + Size.Width);
     CanvasRect.bottom := QRPrinter.YPos(OfsY + Size.Top + Size.Height);
     gcanvas := TQuickrep(parentreport).QRPrinter.Canvas;
     cRgn := CreateRectRgn(CanvasRect.left-1,CanvasRect.top-1,CanvasRect.right+1,CanvasRect.bottom+1);
     SelectClipRgn(QRPrinter.Canvas.Handle,cRgn);
     if gcanvas = nil then exit;
     if not transparent then
     begin
         gcanvas.Brush.Color := color;
         gcanvas.Brush.Style := bsSolid;
         gcanvas.Pen.Color := color;
         gcanvas.Pen.Style := psSolid;
         gcanvas.Rectangle(CanvasRect.left, CanvasRect.top, CanvasRect.right, CanvasRect.bottom);
         if parentreport.Exporting then
         begin
           expshp := TQRShape.Create(parentreport);
           expshp.Top := top;
           expshp.Left := left;
           expshp.Width := width;
           expshp.Height := height;
           expshp.Shape := qrsRectangle;
           expshp.Brush.Style := bsSolid;
           expshp.Brush.Color := self.color;
           expshp.Pen.Style := psClear;
           parentreport.ExportFilter.AcceptGraphic(CanvasRect.left,CanvasRect.top, expshp);
           expshp.Free;
         end;

     end;
     gcanvas.Font.Assign(self.Font);
     if assigned( FBeforePrint) and enabled then
       FBeforePrint( self, gCanvas, printString );
     caption := printString;
     clen := length(Caption);
     lzCaption := stralloc(clen+1);
     for res := 1 to clen do lzCaption[res-1] := Caption[res];
     lzCaption[clen] := chr(0);
     // print it
     ExtTextOutW(gcanvas.Handle, CanvasRect.left, CanvasRect.top,0, nil, lzCaption, clen, @FXValues);
     SelectClipRgn(QRPrinter.Canvas.Handle,0);
     deleteObject(cRgn);
     // export characters
     if not parentreport.Exporting then exit;
     xp := CanvasRect.left;
     yp := CanvasRect.Top;
     for res := 1 to clen do
     begin
       ochar := caption[res];
       parentreport.ExportFilter.TextOut(2.65*xp,2.65*yp, font, color,taLeftJustify,ochar);
       xp := xp + FXValues[res-1];
     end;
end;


end.
