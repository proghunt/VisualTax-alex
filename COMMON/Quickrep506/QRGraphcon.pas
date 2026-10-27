{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 6.0 for Delphi and C++Builder               ::
  ::                                                         ::
  :: QRGraphcon   TQRGraphicCanvas                           ::
  ::                                                         ::
  :: Copyright (c) 2013 QBS Software                         ::
  :: All Rights Reserved                                     ::
 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::}

 unit QRGraphcon;

interface
uses Messages, Windows, Classes, Controls, StdCtrls, SysUtils, Graphics,
     Forms, ExtCtrls, Dialogs, Printers, ComCtrls,qrxdocument,
     QRPrntr, QuickRpt, Qr5Const, qrctrls;

type
TQRGraphicCanvas = class;
TQRGraphicOnPrintEvent = procedure (sender : TQRGraphicCanvas; grect : TRect) of object;
TQRGraphicOnCommandEvent = procedure (sender : TQRGraphicCanvas) of object;

TQRGraphicCanvas = class(TQRPrintable)
  private
    FBeforePrint : TQRGraphicOnPrintEvent;
    commlist : TStringList;
    procedure SetBeforePrint( value : TQRGraphicOnPrintEvent);
  protected
    procedure Paint; override;
    procedure Print(OfsX, OfsY : integer); override;
    procedure RenderComms( acanvas : TCanvas; OffX, OffY : extended);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetCanvas: TCanvas;
    // graphic methods
    procedure TextOut( x,y : integer; s : string);
    procedure MoveTo( x,y : integer);
    procedure LinetoTo( x,y : integer);
    procedure Ellipse( x,y,w,h : integer);
    procedure rectangle( x,y,w,h : integer);
    procedure setPenWidth(w : extended);
    procedure setPenColor( pencolor : TColor);
    procedure setBrushColor( brushcolor : TColor);
    procedure setPenStyle( pstyle : TPenstyle);
    procedure setBrushStyle( bstyle : TBrushstyle);
    procedure setFont( s : string);
    procedure setFontSize( h : integer);
  published
    property BeforePrint: TQRGraphicOnPrintEvent read FBeforePrint write SetBeforePrint;
    property Visible;
    property XLColumn;
    property Font;
    property Transparent;
    property color;
  end;

implementation
uses qrxmlsfilt;

constructor TQRGraphicCanvas.Create(AOwner: TComponent);
begin
      commlist := TStringList.create;
      inherited create(AOwner);
end;

destructor TQRGraphicCanvas.Destroy;
begin
     commlist.Free;
     inherited Destroy;
end;

procedure TQRGraphicCanvas.SetBeforePrint( value : TQRGraphicOnPrintEvent);
begin
     FBeforePrint := value;
end;

function TQRGraphicCanvas.GetCanvas: TCanvas;
begin
    result := TQuickrep(parentreport).QRPrinter.Canvas;
end;

    // graphic methods
procedure TQRGraphicCanvas.TextOut( x,y : integer; s : string);
begin
     commlist.Add(inttostr(integer(TVecComm.textout))+'?'+inttostr(x)+'?'+inttostr(y)+'?'''+ s + '''');
end;

procedure TQRGraphicCanvas.MoveTo( x,y : integer);
begin
     commlist.Add(inttostr(integer(TVecComm.moveto))+'?'+inttostr(x)+'?'+inttostr(y));
end;

procedure TQRGraphicCanvas.LinetoTo( x,y : integer);
begin
     commlist.Add(inttostr(integer(TVecComm.lineto))+'?'+inttostr(x)+'?'+inttostr(y));
end;

procedure TQRGraphicCanvas.Ellipse( x,y,w,h : integer);
begin
     commlist.Add(inttostr(integer(TVecComm.ellipse))+'?'+inttostr(x)+'?'+inttostr(y)+'?'+inttostr(w)+'?'+inttostr(h));
end;

procedure TQRGraphicCanvas.rectangle( x,y,w,h : integer);
begin
     commlist.Add(inttostr(integer(TVecComm.rectangle))+'?'+inttostr(x)+'?'+inttostr(y)+'?'+inttostr(w)+'?'+inttostr(h));
end;

procedure TQRGraphicCanvas.setPenWidth(w : extended);
begin
     commlist.Add(inttostr(integer(TVecComm.penwidth))+'?'+floattostr(w));
end;

procedure TQRGraphicCanvas.setPenColor( pencolor : TColor);
begin
     commlist.Add(inttostr(integer(TVecComm.pencolor))+'?'+inttostr(integer(pencolor)));
end;

procedure TQRGraphicCanvas.setBrushColor( brushcolor : TColor);
begin
     commlist.Add(inttostr(integer(TVecComm.brushcolor))+'?'+inttostr(integer(brushcolor)));
end;

procedure TQRGraphicCanvas.setPenStyle( pstyle : TPenstyle);
begin
     commlist.Add(inttostr(integer(TVecComm.penstyle))+'?'+inttostr(integer(pstyle)));
end;

procedure TQRGraphicCanvas.setBrushStyle( bstyle : TBrushstyle);
begin
     commlist.Add(inttostr(integer(TVecComm.brushstyle))+'?'+inttostr(integer(bstyle)));
end;

procedure TQRGraphicCanvas.setFont( s : string);
begin
     commlist.Add(inttostr(integer(TVecComm.setFont))+'?'+s+'''');
end;
procedure TQRGraphicCanvas.setFontSize( h : integer);
begin
     commlist.Add(inttostr(integer(TVecComm.setFontSize))+'?'+inttostr(h));
end;

procedure TQRGraphicCanvas.Paint;
begin
  if csDesigning in ComponentState then
    with inherited Canvas do
    begin
      Pen.Style := psSolid;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
end;

function randomName : string;
var
   k : integer;
begin
  result := '';
  for k := 1 to 10 do  result := result + chr(random(22)+ord('a'));
end;

procedure SplitString( ss : string; sep : char; var aList : TStringlist );
const
     MAX_STRING = 65000;
var
    k : integer;
    defstr : string;
begin
      defstr := ss;
      aList.Clear;
      while length( defstr) > 0 do
      begin
         k := pos( sep, defstr );
         if k = 0 then
         begin
               if length( defstr) > 0 then
                           alist.add(defstr);
               defstr := '';
         end
         else if trim(copy( defstr, 1, k-1)) <> '' then
              alist.add(trim(copy( defstr, 1, k-1)));
         defstr := trim(copy( defstr, k+1, MAX_STRING ));
      end;
end;

procedure TQRGraphicCanvas.RenderComms( acanvas : TCanvas; OffX, OffY : extended);
var
   combits : TStringlist;
   FZoomFactor : double;
   k : integer;

   function ScaleNumber( ns : string) : integer;
   begin
       result := round(FZoomFactor*strtoint(ns)/100.0);
   end;
   function ScaleXNumber( ns : string) : integer;
   begin
       result := round(FZoomFactor*(strtoint(ns)-OffX)/100.0);
   end;
   function ScaleYNumber( ns : string) : integer;
   begin
       result := round(FZoomFactor*(strtoint(ns)-OffY)/100.0);
   end;
begin
   combits := TStringlist.Create;
   FZoomFactor := 100.0;
   try
     for k := 0 to commlist.Count-1  do
     begin
       splitstring(commlist[k],'?',combits);
       if combits.Count=0 then continue;
       case TVecComm(strtoint(combits[0])) of
        TVecComm.moveto: acanvas.Moveto( ScalexNumber(combits[1]),ScaleyNumber(combits[2]));
        TVecComm.lineto: acanvas.Lineto( ScalexNumber(combits[1]),ScaleyNumber(combits[2]));
        TVecComm.rectangle: acanvas.rectangle( ScalexNumber(combits[1]),ScaleyNumber(combits[2]),ScalexNumber(combits[3]),ScaleyNumber(combits[4]));
        TVecComm.ellipse: acanvas.Ellipse( ScalexNumber(combits[1]),ScaleyNumber(combits[2]),ScalexNumber(combits[3]),ScaleyNumber(combits[4]));
        TVecComm.pencolor: acanvas.pen.Color := strtoint(combits[1]);
        TVecComm.brushcolor: acanvas.brush.Color := strtoint(combits[1]);
        TVecComm.penstyle: acanvas.pen.Style := TPenstyle(strtoint(combits[1]));
        TVecComm.brushstyle: acanvas.brush.Style := TBrushstyle(strtoint(combits[1]));
        TVecComm.penwidth: acanvas.pen.width := ScaleNumber(combits[1]);
        TVecComm.textout: acanvas.textout(ScaleNumber(combits[1]),ScaleNumber(combits[2]),combits[3]);
        TVecComm.setFont: acanvas.Font.Name := combits[1];
        TVecComm.setFontSize: acanvas.Font.Size := ScaleNumber(combits[1]);
        else ;
       end;
     end;
   finally
     combits.Free;
   end;

end;

procedure TQRGraphicCanvas.Print(OfsX, OfsY : integer);
var
   gcanvas : TCanvas;
   CanvasRect : TRect ;
   cRgn : HRGN ;
   expimg : TQRImage;
begin
     // determine the rectangle of the canvas of this control:
     CanvasRect.left   := QRPrinter.XPos(OfsX + Size.Left);
     CanvasRect.top    := QRPrinter.YPos(OfsY + Size.Top);
     CanvasRect.right  := QRPrinter.XPos(OfsX + Size.Left + Size.Width);
     CanvasRect.bottom := QRPrinter.YPos(OfsY + Size.Top + Size.Height);
     gcanvas := TQuickrep(parentreport).QRPrinter.Canvas;
     cRgn := CreateRectRgn(CanvasRect.left-1,CanvasRect.top-1,CanvasRect.right+1,CanvasRect.bottom+1);
     SelectClipRgn(QRPrinter.Canvas.Handle,cRgn);
     if gcanvas = nil then exit;
     commlist.Clear;
     if not transparent then
     begin
         // load up commlist with background painting instructions
         self.setPenStyle(psSolid);
         self.setBrushStyle(bsSolid);
         self.setBrushColor(color);
         self.setPenColor(color);
         self.Rectangle(CanvasRect.left, CanvasRect.top, CanvasRect.right, CanvasRect.bottom);
     end;
     gcanvas.Font.Assign(self.Font);
     if assigned( FBeforePrint) then
       FBeforePrint( self, canvasRect  );
     RenderComms( gcanvas,0,0);
     SelectClipRgn(QRPrinter.Canvas.Handle,0);
     deleteObject(cRgn);
     // exporting
     if not parentreport.Exporting then exit;
     if parentreport.ExportFilter is TQRXDocumentfilter then
     begin
          TQRXDocumentfilter( parentreport.ExportFilter).AcceptVector(commlist);
          exit;
     end;
     expimg := TQRImage.Create(parentreport);
     expimg.Top := top;
     expimg.Left := left;
     expimg.width := width;
     expimg.height := height;
     expimg.Name := randomName;
     expimg.Picture.Bitmap.Width := self.Width;
     expimg.Picture.Bitmap.Height := Height;
     expimg.Name := 'Graphcon';
     self.setPenStyle(psSolid);
     self.setPenColor(Font.Color);
     RenderComms( expimg.Picture.Bitmap.Canvas, CanvasRect.left, CanvasRect.top);
     parentreport.ExportFilter.AcceptGraphic(CanvasRect.left,CanvasRect.top, expimg);
     expimg.Free;
end;


end.
