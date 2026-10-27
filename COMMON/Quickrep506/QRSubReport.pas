{ :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  :: QuickReport 6.0 for Delphi and C++Builder               ::
  ::                                                         ::
  :: QRSubReport   TQRSubReport control                      ::
  ::                                                         ::
  :: Copyright (c) 2013 QBS Software                         ::
  :: All Rights Reserved                                     ::
 ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::}

unit QRSubReport;

interface
uses Messages, Windows, Classes, Controls, StdCtrls, SysUtils, Graphics,
     Forms, ExtCtrls, Dialogs, Printers, ComCtrls, QRPrntr, QuickRpt, Qr5Const, qrctrls;

type

TQRDisplayMode = (executeOnPrint, executeOnce);
TQRSubRepImageMode = ( storeMetafile, storeXML);
TQRGetSubRepEvent = procedure (sender : TObject; var subrep : TCustomQuickrep) of object;

TQRSubReport = class(TQRPrintable)
  private
    FPicture: TPicture;
    //FUseXML : boolean;
    FDisplayMode : TQRDisplayMode;
    FImageMode : TQRSubRepImageMode;
    FReportControl : TCustomQuickrep;
    FReportPagecount : integer;
    FGetSubRep : TQRGetSubRepEvent;
    FBeforePrint : TQRGetSubRepEvent;
    FPagelist : TStringlist;
    FXMLStream : TMemorystream;
    procedure GetXMLPageItems( inxml : TMemoryStream; outList : TStringlist; pagenum, OfsX, OfsY  : integer);
    Procedure FillPagelist;
  protected
    procedure Prepare; override;
    procedure Paint; override;
    procedure Print(OfsX, OfsY : integer); override;
  public
     currentPage : integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetCanvas: TCanvas;
  published
    //property UseXML : boolean read FUseXML write FUseXML;
    property GetSubRep : TQRGetSubRepEvent read FGetSubRep write FGetSubRep;
    property BeforePrint : TQRGetSubRepEvent read FBeforePrint write FBeforePrint;
    property DisplayMode : TQRDisplayMode read FDisplayMode write FDisplayMode;
    property Visible;
    property XLColumn;
    property Transparent;
    property Color;
  end;

  function copyBackToChar( s : string; start : integer; ToChar : char; var lastPos : integer ): string;
  function copyToChar( s : string; start : integer; ToChar : char; var lastPos : integer ): string;


implementation
uses QRXMLSFilt;
var
  subxmlfilt : TQRXDocumentFilter;

constructor TQRSubReport.Create(AOwner: TComponent);
begin
      inherited create(AOwner);
      FReportControl := nil;
      FPicture := TPicture.Create;
      subxmlfilt := nil;
      FPagelist := TStringlist.Create;
      FXMLStream := TMemorystream.Create;
end;

destructor TQRSubReport.Destroy;
var
    k : integer;
begin
     FPicture.Free;
     //if subxmlfilt <> nil then subxmlfilt.Free;
     for k:=0 to FPagelist.Count-1 do
        TMetafile(FPagelist.Objects[k]).Free;
     FPagelist.Free;
     FXMLStream.Free;
     inherited Destroy;
end;

function TQRSubReport.GetCanvas: TCanvas;
begin
    result := TQuickrep(parentreport).QRPrinter.Canvas;
end;

Procedure TQRSubReport.FillPagelist;
var
   k : integer;
begin
     for k := 1 to FReportControl.QRPrinter.Pagecount do
         FPagelist.AddObject(inttostr(k),FReportControl.QRPrinter.PageList.GetPage(k));
end;

procedure TQRSubReport.Prepare;
begin
  inherited Prepare;
  if assigned(GetSubRep) then
      GetSubRep(self,FReportControl);
  if FReportControl= nil then exit;
  FReportControl.ShowProgress := false;
  if FDisplayMode=executeOnce then
  begin
      FReportControl.Prepare;
      FillPagelist;
      FReportPagecount := FPagelist.Count;
      FReportControl.QRPrinter.Free;
      FReportControl.QRPrinter := nil;
      if parentreport.Exporting and ( parentreport.ExportFilter is TQRXDocumentFilter) then
      begin
           subxmlfilt := TQRXDocumentFilter.Create('');
           FReportControl.ExportToFilter(subxmlfilt);
           subxmlfilt.stream.Position := 0;
           FXMLStream.LoadFromStream(subxmlfilt.stream);
           subxmlfilt.Free;
      end;
  end;
end;

procedure TQRSubReport.Paint;
begin
  if csDesigning in ComponentState then
    with inherited Canvas do
    begin
      Pen.Style := psSolid;
      Brush.Style := bsClear;
      Rectangle(0, 0, Width, Height);
    end;
end;

procedure TQRSubReport.GetXMLPageItems( inxml : TMemoryStream; outList : TStringlist; pagenum, OfsX, OfsY  : integer);
const
    inItem = 0;
    inOther = 1;
var
   inlist : TStringlist;
   k ,p, cp, cstate : integer;
   np : double;
   tstr, tstr2, intext : string;
   pixTomm : extended;
begin
   pixTomm := 25.4/screen.PixelsPerInch;
   inlist := TStringlist.Create;
   inlist.LoadFromStream(inXml);
   outlist.Clear;
   // find the page
   k := 0;
   p := 0;
   while (k<inlist.Count) and (p<pagenum) do
   begin
       if pos('<Page',inlist[k])>0  then inc(p);
       inc(k);
   end;
   if p<>pagenum then  exit;
   // look for '<item'
   p := inlist.Count-1;
   cstate := InOther;
   while (k<inlist.Count)  do
   begin
       if pos('<Item',inlist[k])>0  then
       begin
            if pos('</Item',inlist[k])=0  then cstate := inItem;
            intext := inlist[k];
            cp := pos(' X=',intext);
            if cp >0 then
            begin
                 tstr := copyToChar(inlist[k], cp+1, ' ', p);
                 tstr2 := copyToChar(inlist[k], cp+3, ' ', p);
                 tstr2 := copy(tstr2,2,length(tstr2)-2);
                 np := strtofloat(trim(tstr2));
                 np := np + (Ofsx/10.0) + (Left*pixTomm);
                 tstr2 := ' X="'+trim(format('%-5.2f',[np]))+'"';
                 intext := stringreplace(intext,tstr,tstr2,[rfReplaceAll]);
            end;
            cp := pos(' Y=',inlist[k]);
            if cp >0 then
            begin
                 tstr := copyToChar(inlist[k], cp+1, ' ', p);
                 tstr2 := copyToChar(inlist[k], cp+3, ' ', p);
                 tstr2 := copy(tstr2,2,length(tstr2)-2);
                 np := strtofloat(trim(tstr2));
                 np := np + (OfsY/10) + (Top*pixTomm);;
                 tstr2 := ' Y="'+trim(format('%-5.2f',[np]))+'"';
                 intext := stringreplace(intext,tstr,tstr2,[rfReplaceAll]);
            end;
            cp := pos(' CID=',inlist[k]);
            if cp >0 then
            begin
                 tstr := copyToChar(inlist[k], cp+1, ' ', p);
                 tstr2 := copyToChar(inlist[k], cp+5, ' ', p);
                 tstr2 := copy(tstr2,2,length(tstr2)-2);
                 tstr2 := ' CID="'+self.Name+'.'+tstr2+'"';
                 intext := stringreplace(intext,tstr,tstr2,[rfReplaceAll]);
            end;
            outlist.Add(intext);
            inc(k);
            continue;
       end;
       if (pos('</Item',inlist[k])>0) and (cstate=inItem)  then
       begin
          outlist.Add(inlist[k]);
          cstate := inOther;
       end
       else if cstate=inItem then
          outlist.Add(inlist[k]);
       inc(k);
   end;
   //outlist.SaveToFile('xmlout.txt');
   inlist.Free;
end;

procedure TQRSubReport.Print(OfsX, OfsY : integer);
var
   gcanvas : TCanvas;
   CanvasRect : TRect ;
   cRgn : HRGN ;
   expimg : TQRImage;
   expshp : TQRShape;
   pageMetafile : TMetafile;
   xmlItems : TStringlist;
   //xmlStream : TMemoryStream;
begin
     if parentreport.Exporting and ( parentreport.ExportFilter is TQRXDocumentFilter) then
         self.FImageMode := storeXml
     else
         FImagemode := TQRSubRepImagemode.storeMetafile;
    // determine the rectangle of the canvas of this control:
     CanvasRect.left   := QRPrinter.XPos(OfsX + Size.Left);
     CanvasRect.top    := QRPrinter.YPos(OfsY + Size.Top);
     CanvasRect.right  := QRPrinter.XPos(OfsX + Size.Left + Size.Width);
     CanvasRect.bottom := QRPrinter.YPos(OfsY + Size.Top + Size.Height);
     gcanvas := TQuickrep(parentreport).QRPrinter.Canvas;
     if FReportControl = nil  then
     begin
       gcanvas.TextOut( canvasrect.left + 10,canvasrect.Top+20,'No QuickRep assigned');
       exit;
     end;
     cRgn := CreateRectRgn(CanvasRect.left-1,CanvasRect.top-1,CanvasRect.right+1,CanvasRect.bottom+1);
     SelectClipRgn(QRPrinter.Canvas.Handle,cRgn);
     if gcanvas = nil then exit;
     if assigned(FBeforePrint)  then
           BeforePrint( self,FReportControl);

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
     if FDisplaymode = TQRDisplaymode.executeOnPrint then
     begin
           FReportControl.Prepare;
           FReportPagecount := FReportControl.QRPrinter.PageCount;
           if FImageMode=storeXML then
           begin
              subxmlfilt := TQRXDocumentFilter.Create('');
              FReportControl.ExportToFilter(subxmlfilt);
              subxmlfilt.stream.Position := 0;
              FXMLStream.LoadFromStream(subxmlfilt.stream);
              subxmlfilt.Free;
           end;
     end;
     pagemetafile := nil;
     if (currentPage > 0) and (currentPage<=FReportPagecount) then
     begin
           if FDisplaymode = TQRDisplaymode.executeOnPrint then
                pagemetafile := FReportControl.QRPrinter.PageList.GetPage(CurrentPage)
           else if FDisplaymode = TQRDisplaymode.executeOnce then
           begin
                pagemetafile := TMetafile.Create;
                pagemetafile.Assign(TMetafile(FPagelist.Objects[CurrentPage-1]));
           end;
           if pagemetafile <> nil then
           begin
               gcanvas.Draw(canvasrect.Left,canvasrect.Top, pagemetafile);
               if not parentreport.Exporting then pagemetafile.Free;
           end;
     end;
     if FDisplaymode = TQRDisplaymode.executeOnPrint then
     begin
       FReportControl.QRPrinter.Free;
       FReportControl.QRPrinter := nil;
     end;
     SelectClipRgn(QRPrinter.Canvas.Handle,0);
     deleteObject(cRgn);
     // exporting
     if not parentreport.Exporting then exit;
     if (FImageMode=storeXML) and (parentreport.ExportFilter is TQRXDocumentfilter) then
     begin
           xmlItems := TStringlist.Create;
           FXMLStream.Position := 0;
           GetXMLPageItems( FXMLStream , xmlItems, currentPage, OfsX, OfsY );
           TQRXDocumentfilter(parentreport.ExportFilter).AddToStream(xmlItems);
           if pagemetafile <> nil then pagemetafile.Free;
           xmlitems.Free;
           exit;
     end;
     expimg := TQRImage.Create(parentreport);
     expimg.Top := top;
     expimg.Left := left;
     expimg.width := width;
     expimg.height := height;
     expimg.Picture.Bitmap.Width := self.Width;
     expimg.Picture.Bitmap.Height := Height;
     if not transparent then
     begin
          expimg.Picture.Bitmap.Canvas.Pen.Style := psClear;
          expimg.Picture.Bitmap.Canvas.brush.Style := bsSolid;
          expimg.Picture.Bitmap.Canvas.brush.Color := color;
          expimg.Picture.Bitmap.Canvas.Rectangle(0,0,width+1, height+1);
     end;
     if pagemetafile <> nil then
     begin
                expimg.Picture.Bitmap.Canvas.Draw(0,0,pagemetafile);
                pagemetafile.Free;
     end;
     parentreport.ExportFilter.AcceptGraphic(CanvasRect.left,CanvasRect.top, expimg);
     expimg.Free;
end;

{-------------------------------- utilities -----------------------------}
function copyToChar( s : string; start : integer; ToChar : char; var lastPos : integer ): string;
var
   k : integer;
begin
   result := '';
   lastPos := -1;
   for k := start to length(s) do
   begin
       lastPos := k;
       if s[k]='>' then break;
       if s[k]=''+ ToChar then break;
       result := result + s[k];
   end;
   result := trim(result);
end;

function copyBackToChar( s : string; start : integer; ToChar : char; var lastPos : integer ): string;
var
   k : integer;
begin
   result := '';
   lastPos := -1;
   for k := start downto 1 do
   begin
       lastPos := k;
       if s[k]=''+ ToChar then break;
       result := s[k] + result;
   end;
   result := trim(result);
end;

end.
