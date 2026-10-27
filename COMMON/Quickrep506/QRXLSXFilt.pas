unit QRXLSXFilt;
////////////////////////////////////////////////////////////////////////////
//  Unit : QRXLSXFilt
//
//  TQRXMLSSAbstractExportFilter -> TQRXMLSSDocumentFilter
//
//  The XMLSS Export document for XL spreadsheet -
//
//  (c) 2010 QBS Software
//
//  22/08/2012 changed FItems to dynamic array
////////////////////////////////////////////////////////////////////////////
{$include QRDefs.inc}
interface
uses windows, classes, controls, stdctrls, sysutils, graphics, buttons,
     forms, extctrls, dialogs, printers, db, ComCtrls, 
     QRPrntr, Quickrpt, QR5Const, qrctrls, grids{$ifndef DXE}, system.UITypes{$endif};

const
     CRLF = chr($0D) + chr($0A);
     // ascii
     ORD0 = ord('0');
     ORDA = ord('A');
type
   XLXSTextItem = record
       row, col : integer;
       X,Y : extended;
       text, fontname : string;
       exportAs : TExporttype;
       fontbold, fontitalic, fontstrike : boolean;
       fontsize : integer;
       fontcolor : TColor;
       controlName : string;
   end;

  TQRXMLSSAbstractExportFilter = class(TQRExportFilter)
  private
    FStream : TStream;
    FLineCount,
    FColCount : integer;
    FPageProcessed : boolean;
    dlist : TStringlist;
  protected
    function GetText(X, Y : extended; var Font : TFont) : string;
    function GetFilterName : string; override;
    function GetDescription : string; override;
    function GetExtension : string; override;
    procedure WriteToStream(const AText : string);
    procedure WriteLnToStream(const AText : string);
    procedure CreateStream(Filename : string); virtual;
    procedure CloseStream; virtual;
    procedure ProcessPage; virtual;
    procedure StorePage; virtual;
    property Stream : TStream read FStream write FStream;
    property PageProcessed : boolean read FPageProcessed write FPageProcessed;
    property LineCount : integer read FLineCount write FLineCount;
    property ColCount : integer read FColCount write FColCount;
  public
    constructor Create( filename : string );override;
    procedure Start(PaperWidth, PaperHeight : integer; Font : TFont); override;
    procedure Finish; override;
    procedure EndPage; override;
    procedure NewPage; override;
    //procedure TextOut(X, Y : extended; Text : string; exportAs : TExportType; xlColumn : integer);virtual;
  end;

  TQRXMLSSDocumentFilter = class(TQRXMLSSAbstractExportFilter)
  private
    FFreeStream : boolean;
    // doc filter properties
    FLastRecordNum : longint;
    FPagenumber : longint;
    //FDocType : string;
    //FCreator : string;
    FTitle : string;
    //FAuthor,
    FLastAuthor,
    FCreated,
    FLastSaved,
    //FCompany,
    //FWorkSheetname,
    FXLStyleURL : string;
    FConcatenating : boolean;
    FXLEncoding: string;
    FItems : array of XLXSTextItem;
    FSortList : TStringlist;
    FStylenames : TStringlist;
    FFontTags : TStringlist;
    FItemcount : integer;
    //FOpenHeight : integer;
    //FOpenWidth : integer;
    FPageYOffset : extended;
    FMaxYValue : extended;
    rowno, colno, maxcols, fixline1, styleinsert : integer;
    procedure SetCreator( value : string);
    function getCreator: string;
    function getAuthor: string;
    procedure SetAuthor( value : string);
    procedure SetCompany( value : string);
    function getCompany: string;
    procedure SetWorkSheetName( value : string);
    function getWorkSheetName: string;
    procedure SetOpenWidth( value : integer);
    function getOpenWidth: integer;
    function getOpenHeight: integer;
    procedure SetOpenHeight( value : integer);

  protected
    function GetFilterName : string; override;
    function GetDescription : string; override;
    function GetExtension : string; override;
    function GetStreaming : boolean; override;
    procedure CreateStream(Filename : string); override;
    procedure CloseStream; override;
    procedure ProcessItems;
 public
    constructor Create( filename : string );override;
    destructor Destroy; override;
    procedure TextOutRec( ExportInfo : TExportInfoRec); override;
    procedure NewDocument( doclist : TStringlist; PaperWidth, PaperHeight : double;
              Papername, orient : string);
    //procedure TextOut(X, Y : extended; Text : string; exportAs : TExportType; xlColumn : integer);override;
    procedure LoadProlog;
    procedure ProcessPage; override;
    procedure Start(PaperWidth, PaperHeight : integer; Font : TFont); override;
    procedure EndConcat;
    procedure Finish; override;
    procedure NewPage; override;
    procedure EndPage; override;
    procedure SetDocumentProperties( author, title, company : string );
    property Stream;
    property FreeStream : boolean read FFreeStream write FFreeStream;
    property Title : string read FTitle write FTitle;
    property LastAuthor : string read FLastAuthor write FLastAuthor;
    property Created : string read FCreated write FCreated;
    property LastSaved : string read FLastSaved write FLastSaved;
    property XLEncoding: string read FXLEncoding write FXLEncoding;
    property XLStyleURL : string read FXLStyleURL write FXLStyleURL;
    property Concatenating : boolean read FConcatenating write FConcatenating;
    property OpenWidth : integer read getOpenWidth  write setOpenWidth;
    property OpenHeight : integer read getOpenHeight  write setOpenHeight;
    property Creator : string read getCreator write setCreator;
    property Author : string read getAuthor write setAuthor;
    property Company : string read getCompany write setCompany;
    property WorkSheetname : string read getWorkSheetname write setWorkSheetname;
  end;

  TQRXMLSSFilter = class(TComponent)
  private
    procedure SetCreator( value : string);
    function getCreator: string;
    function getAuthor: string;
    procedure SetAuthor( value : string);
    procedure SetCompany( value : string);
    function getCompany: string;
    procedure SetWorkSheetName( value : string);
    function getWorkSheetName: string;
    procedure SetOpenWidth( value : integer);
    function getOpenWidth: integer;
    function getOpenHeight: integer;
    procedure SetOpenHeight( value : integer);
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
  published
    property OpenWidth : integer read getOpenWidth  write setOpenWidth;
    property OpenHeight : integer read getOpenHeight  write setOpenHeight;
    property Creator : string read getCreator write setCreator;
    property Author : string read getAuthor write setAuthor;
    property Company : string read getCompany write setCompany;
    property WorkSheetname : string read getWorkSheetname write setWorkSheetname;
  end;

  function EntityReplace( var ctext : string ) : string;
  function ColTrans( ct : TColor ) : string;

implementation
uses grimgctrl;

var
   xmlCreator, xmlAuthor, xmlCompany, xmlWorkSheetname : string;
   xmlOpenWidth, xmlOpenHeight : integer;

//-------------------------------------------
function TQRXMLSSDocumentFilter.getCreator: string;
begin
      result := xmlCreator;
end;

procedure TQRXMLSSDocumentFilter.SetCreator( value : string);
begin
     xmlCreator := value;
end;

function TQRXMLSSDocumentFilter.getAuthor: string;
begin
      result := xmlAuthor;
end;

procedure TQRXMLSSDocumentFilter.SetAuthor( value : string);
begin
     xmlCreator := value;
end;

procedure TQRXMLSSDocumentFilter.SetCompany( value : string);
begin
     xmlCompany := value;
end;

function TQRXMLSSDocumentFilter.getCompany: string;
begin
      result := xmlCompany;
end;

procedure TQRXMLSSDocumentFilter.SetWorkSheetName( value : string);
begin
     xmlWorkSheetName := value;
end;

function TQRXMLSSDocumentFilter.getWorkSheetName: string;
begin
      result := xmlWorkSheetName;
end;

procedure TQRXMLSSDocumentFilter.SetOpenWidth( value : integer);
begin
     xmlOpenWidth := value;
end;

function TQRXMLSSDocumentFilter.getOpenWidth: integer;
begin
      result := xmlOpenWidth;
end;

procedure TQRXMLSSDocumentFilter.SetOpenHeight( value : integer);
begin
     xmlOpenHeight := value;
end;

function TQRXMLSSDocumentFilter.getOpenHeight: integer;
begin
      result := xmlOpenHeight;
end;
//---------------------------------------------


constructor TQRXMLSSFilter.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  QRExportFilterLibrary.AddFilter(TQRXMLSSDocumentFilter);
end;

destructor TQRXMLSSFilter.Destroy;
begin
  QRExportFilterLibrary.RemoveFilter(TQRXMLSSDocumentFilter);
  inherited Destroy;
end;
 //-------------------------------------------
function TQRXMLSSFilter.getCreator: string;
begin
      result := xmlCreator;
end;

procedure TQRXMLSSFilter.SetCreator( value : string);
begin
     xmlCreator := value;
end;

function TQRXMLSSFilter.getAuthor: string;
begin
      result := xmlAuthor;
end;

procedure TQRXMLSSFilter.SetAuthor( value : string);
begin
     xmlCreator := value;
end;

procedure TQRXMLSSFilter.SetCompany( value : string);
begin
     xmlCompany := value;
end;

function TQRXMLSSFilter.getCompany: string;
begin
      result := xmlCompany;
end;

procedure TQRXMLSSFilter.SetWorkSheetName( value : string);
begin
     xmlWorkSheetName := value;
end;

function TQRXMLSSFilter.getWorkSheetName: string;
begin
      result := xmlWorkSheetName;
end;

procedure TQRXMLSSFilter.SetOpenWidth( value : integer);
begin
     xmlOpenWidth := value;
end;

function TQRXMLSSFilter.getOpenWidth: integer;
begin
      result := xmlOpenWidth;
end;

procedure TQRXMLSSFilter.SetOpenHeight( value : integer);
begin
     xmlOpenHeight := value;
end;

function TQRXMLSSFilter.getOpenHeight: integer;
begin
      result := xmlOpenHeight;
end;
//---------------------------------------------


{TQRXMLSSAbstractExportFilter}
constructor TQRXMLSSAbstractExportFilter.Create( filename : string);
begin
     inherited Create(filename);
end;

function TQRXMLSSAbstractExportFilter.GetFilterName : string;
begin
  result := 'QRAbstract'; // Do not translate
end;

function TQRXMLSSAbstractExportFilter.GetDescription : string;
begin
  Result := '';
end;

function TQRXMLSSAbstractExportFilter.GetExtension : string;
begin
  Result := '';
end;

procedure TQRXMLSSAbstractExportFilter.Start(PaperWidth, PaperHeight : integer; Font : TFont);
begin
    CreateStream(Filename);
    Active := true;
end;

procedure TQRXMLSSAbstractExportFilter.CreateStream(Filename : string);
begin
  FStream := TFileStream.Create(Filename, fmCreate);
end;

procedure TQRXMLSSAbstractExportFilter.CloseStream;
begin
  FStream.Free;
end;

procedure TQRXMLSSAbstractExportFilter.WriteToStream(const AText : string);
begin
  if length(AText)>0 then
    Stream.Write(AText[1], length(AText));
end;

procedure TQRXMLSSAbstractExportFilter.WriteLnToStream(const AText : string);
begin
  WriteToStream(AText + #13 + #10);
end;

procedure TQRXMLSSAbstractExportFilter.Finish;
begin
  CloseStream;
  inherited Finish;
end;

procedure TQRXMLSSAbstractExportFilter.NewPage;
begin
  FPageProcessed := False;
  inherited NewPage;
end;

procedure TQRXMLSSAbstractExportFilter.EndPage;
begin
  //EndPage;??
  ProcessPage;
  inherited EndPage;
end;

procedure TQRXMLSSAbstractExportFilter.ProcessPage;
begin
  FPageProcessed := True;
end;

procedure TQRXMLSSAbstractExportFilter.StorePage;
begin
end;

function TQRXMLSSAbstractExportFilter.GetText(X, Y : extended; var Font : TFont) : string;
begin
end;

{TQRXMLSSDocumentFilter}
function TQRXMLSSDocumentFilter.GetFilterName : string;
begin
  Result := SqrQRXDocument;
end;

function TQRXMLSSDocumentFilter.GetDescription : string;
begin
  Result := SqrExcelX;
end;

function TQRXMLSSDocumentFilter.GetExtension : string;
begin
  Result := 'xml'; // Do not translate
end;

function TQRXMLSSDocumentFilter.GetStreaming : boolean;
begin
  Result := false;// stream multipage report mode
end;

procedure TQRXMLSSDocumentFilter.CreateStream(Filename : string);
begin
  if Filename = '' then
  begin
    FStream := TMemoryStream.Create;
    FreeStream := false;
  end else
  begin
    FreeStream := true;
    inherited CreateStream(Filename);
  end;
end;

procedure TQRXMLSSDocumentFilter.CloseStream;
begin
  // the stream is not freed if it's a memory stream
  if FreeStream then
    inherited CloseStream;
end;

constructor TQRXMLSSDocumentFilter.Create( filename : string );
begin
   inherited Create( filename);
   FItemcount := 0;
   FSortList := TStringlist.Create;
   FSortlist.Sorted := true;
   FSortlist.Duplicates := dupAccept;
   FStylenames := TStringlist.Create;
   FFontTags := TStringlist.Create;
   xmlWorkSheetname := 'Sheet 1';
   FMaxYValue := 0.0;
   xmlOpenWidth := 1000;
   xmlOpenHeight := 600;
   FLastRecordNum := 0;
   FPagenumber := 1;
   xmlCreator := 'QRXLSXDocumentFilter';
   FCreated := datetostr( date );
   FLastsaved := FCreated;
   FXLEncoding := 'UTF-8';// west europe latin, 1250 is east europe.
end;

destructor TQRXMLSSDocumentFilter.Destroy;
begin
   FSortList.Free;
   FStylenames.Free;
   FFonttags.Free;
   inherited Destroy;
end;

procedure TQRXMLSSDocumentFilter.ProcessPage;
begin
  FPageProcessed := True;
  StorePage;
end;

procedure TQRXMLSSDocumentFilter.SetDocumentProperties( author, title, company : string );
begin
      xmlAuthor := author;
      FTitle := title;
      xmlCompany := company;
end;

procedure TQRXMLSSDocumentFilter.LoadProlog;
var
    astr, bstr : string;
begin
    dlist.add('<?xml version="1.0" encoding="UTF-8"?>');

    astr := '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:html="http://www.w3.org/TR/REC-html40" ';
    bstr := 'xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet" xmlns:x="urn:schemas-microsoft-com:office:excel">';
    dlist.add(astr+bstr);
    dlist.add('<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">');
    dlist.add('<Author xmlns="urn:schemas-microsoft-com:office:office">'+Author+'</Author>');
    dlist.add('<Company xmlns="urn:schemas-microsoft-com:office:office">'+Company+'</Company>');
    dlist.add('<Version xmlns="urn:schemas-microsoft-com:office:office">10.4219</Version>');
    dlist.add('</DocumentProperties>');
    dlist.add('<OfficeDocumentSettings xmlns="urn:schemas-microsoft-com:office:office">');
    dlist.add('<DownloadComponents xmlns="urn:schemas-microsoft-com:office:office" />');
    dlist.add('<LocationOfComponents xmlns="urn:schemas-microsoft-com:office:office" HRef="file:///\\phlfsnt01\DOWNLOAD\OfficeXPSrc\" />');
    dlist.add('</OfficeDocumentSettings>');
    dlist.add('<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">');
    dlist.add('<WindowHeight xmlns="urn:schemas-microsoft-com:office:excel">'+inttostr(Openheight*10)+'</WindowHeight>');
    dlist.add('<WindowWidth xmlns="urn:schemas-microsoft-com:office:excel">'+inttostr(Openwidth*10)+'</WindowWidth>');
    dlist.add('<WindowTopX xmlns="urn:schemas-microsoft-com:office:excel">0</WindowTopX>');
    dlist.add('<WindowTopY xmlns="urn:schemas-microsoft-com:office:excel">60</WindowTopY>');
    dlist.add('<ProtectStructure xmlns="urn:schemas-microsoft-com:office:excel">False</ProtectStructure>');
    dlist.add('<ProtectWindows xmlns="urn:schemas-microsoft-com:office:excel">False</ProtectWindows>');
    dlist.add('</ExcelWorkbook>');
    dlist.add('<Styles>');
    dlist.add('<Style ss:ID="Default" ss:Name="Normal">');
    dlist.add('<Alignment ss:Vertical="Bottom" />');
    dlist.add('<Borders />');
    dlist.add('<Font />');
    dlist.add('<Interior />');
    dlist.add('<NumberFormat />');
    dlist.add('<Protection />');
    dlist.add('</Style>');
    styleinsert := dlist.count-1;
    dlist.add('</Styles>');
    dlist.add('<Worksheet ss:Name="'+WorkSheetName+'">');
    dlist.add('<Table ss:ExpandedColumnCount="%cols%" ss:ExpandedRowCount="%rows%" x:FullColumns="1" x:FullRows="1">');
    fixline1 := dlist.Count-1;
end;


// places a blank document in the stringlist
procedure TQRXMLSSDocumentFilter.NewDocument( doclist : TStringlist; PaperWidth, PaperHeight : double;
              Papername, orient : string);
begin
//Title*, DocType*, Creator*, Author*, Date*, Copyright*, Orientation*
    LoadProlog;
end;

// Overridden Start
procedure TQRXMLSSDocumentFilter.Start(PaperWidth, PaperHeight : integer; Font : TFont);
//var
//    k : integer;
begin
    inherited;  // creates a stream
    // output the prolog
    dlist := TStringlist.create;
    LoadProlog;
end;

function GetY( pstr : string ) : integer;
var
    tstr : string;
    p, ec : integer;
begin
    p := pos(':', pstr);
    tstr := copy( pstr,1,p-1);
    val( tstr, p, ec);
    result := p;
end;

// CAUTION : these routines are sensitive to the layout of FSortlist.
function GetItem( pstr : string ) : integer;
var
    tstr : string;
    p, ec : integer;
begin
    //p := pos(':', pstr);
    tstr := copy( pstr,13,5);
    val( tstr, p, ec);
    result := p;
end;

procedure TQRXMLSSDocumentFilter.ProcessItems;
var
    currY, currItem, k, p : integer;
    currText, typestr : string;
    currExpType : TExportType;
    reqCol : integer;
begin
    //FSortList.SaveToFile('sortlist.txt'); // debugging
    if FSortList.count = 0 then exit;
    rowno := 1;
    colno := 0;
    k := 0;
    maxcols := 0;
    currY := getY( FSortList[0]);
    dlist.add('   <Row>');
    while k < FSortlist.count do
    begin
        currItem := GetItem( FSortList[k]);
        currText := FItems[currItem].text;
        currExpType := FItems[currItem].exportAs;
        reqCol := FItems[currItem].col;
        if reqCol > colno then
          for p := 1 to (reqCol-colno-1) do
          begin
              dlist.add('    <Cell><Data ss:Type="String">  </Data></Cell>');
              inc(colno);
          end;
        typestr := 'String';
        if currExpType = exptNumeric then typestr := 'Number';
        dlist.add('    <Cell ss:StyleID="'+FItems[currItem].controlName+'" ><Data ss:Type="'+typestr+'">'+currText+'</Data></Cell>');
        inc(colno);
        if colno > maxcols then maxcols := colno;
        inc(k);
        if k = FSortlist.Count then break;
        if currY <> getY( FSortList[k]) then
        begin
            currY := getY( FSortList[k]);
            dlist.add('   </Row>');
            dlist.add('   <Row>');
            inc(rowno);
            colno := 0;
        end;
    end;
    dlist.add('   </Row>');
end;

// overridden Finish
procedure TQRXMLSSDocumentFilter.Finish;
var
   tstr : string;
   k : integer;
begin
    if fconcatenating then exit;
    ProcessItems;
    dlist.add('</Table>');
    dlist.add('<WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">');
    dlist.add('<Print xmlns="urn:schemas-microsoft-com:office:excel">');
    dlist.add('<ValidPrinterInfo xmlns="urn:schemas-microsoft-com:office:excel" />');
    dlist.add('<HorizontalResolution xmlns="urn:schemas-microsoft-com:office:excel">1200</HorizontalResolution>');
    dlist.add('<VerticalResolution xmlns="urn:schemas-microsoft-com:office:excel">1200</VerticalResolution>');
    dlist.add('</Print>');
    dlist.add('<ProtectObjects xmlns="urn:schemas-microsoft-com:office:excel">False</ProtectObjects>');
    dlist.add('<ProtectScenarios xmlns="urn:schemas-microsoft-com:office:excel">False</ProtectScenarios>');
    dlist.add('</WorksheetOptions>');
    dlist.add('</Worksheet>');
    dlist.add('</Workbook>');
    // fix the table params
    tstr := dlist[fixline1];
    tstr := stringreplace( tstr, '%cols%', inttostr(maxcols), [rfReplaceall]);
    tstr := stringreplace( tstr, '%rows%', inttostr(rowno), [rfReplaceall]);
    dlist[fixline1] := tstr;
    // insert Styles
    for k := FFonttags.Count-1 downto 0 do
       dlist.Insert(styleinsert+1, FFonttags[k]);
    dlist.SaveToStream(FStream, TEncoding.UTF8);
    dlist.Free;
    inherited;
end;

procedure TQRXMLSSDocumentFilter.EndConcat;
begin
     fconcatenating := false;
     Finish;
end;

procedure TQRXMLSSDocumentFilter.TextOutRec( ExportInfo : TExportInfoRec);
var
  //I  : integer;
  nItem : XLXSTextItem;
  sortstr, fontstr, colorstr : string;
begin
       nItem.col := ExportInfo.Column;
       nItem.X := ExportInfo.Xpos;
       nItem.Y := ExportInfo.Ypos + FPageYOffset;
       if nItem.Y > FMaxYValue then FMaxYValue := nItem.Y;
       nItem.text := EntityReplace(ExportInfo.Text);
       nItem.exportAs := ExportInfo.exportAs;
       // style stuff
       nItem.fontname := ExportInfo.Font.Name;
       nItem.fontsize := ExportInfo.Font.Size;
       nItem.fontbold := fsBold in ExportInfo.Font.Style;
       nItem.fontitalic := fsItalic in ExportInfo.Font.Style;
       nItem.fontstrike := fsStrikeout in ExportInfo.Font.Style;
       nItem.fontcolor := ExportInfo.Font.Color;
       if nItem.fontcolor<0 then nItem.fontcolor := 0;
       nItem.controlName := ExportInfo.controlName;
       if trim(nItem.controlName)='' then
              nItem.controlName := 'noname';

       if FStylenames.IndexOf(Nitem.controlName) = -1 then
       begin
           colorstr := colTrans(Nitem.fontcolor);
           fontstr := '<ss:Font ss:FontName="'+nItem.fontname+'" ss:Size="'
                  + inttostr(nItem.fontsize) + '" ss:Color="'+colorstr+'" ';
           if nItem.fontbold then fontstr := fontstr + 'ss:Bold="1" ';
           if nItem.fontitalic then fontstr := fontstr + 'ss:Italic="1" ';
           fontstr := fontstr + '/>';
           FStylenames.Add(nItem.controlName);
           FFontTags.Add('<Style ss:ID="'+nItem.controlName+'" >');
           FFontTags.Add(fontstr);
           FFontTags.Add('</Style>');
       end;
       setlength(FItems,FItemcount+1);
       FItems[FItemcount] := nItem;
       sortstr := format( '%5d:%5d:%5d',[trunc(nItem.Y), nItem.col, FItemcount]);
       sortstr := stringreplace( sortstr, ' ','0',[rfReplaceall]);
       sortstr := sortstr+':'+nItem.text;
       FSortList.Add(sortstr);
       inc(FItemcount);
end;

procedure TQRXMLSSDocumentFilter.EndPage;
begin
     //do nothing;
end;

procedure TQRXMLSSDocumentFilter.NewPage;
begin
     inc(FPagenumber);
     FPageYoffset := FMaxYvalue;
end;

function EntityReplace( var ctext : string ) : string;
begin
     ctext :=  stringreplace( ctext, '&', '&amp;', [rfReplaceAll] ); // must be first
     ctext :=  stringreplace( ctext, '<', '&lt;', [rfReplaceAll] );
     ctext :=  stringreplace( ctext, '>', '&gt;', [rfReplaceAll] );
     ctext :=  stringreplace( ctext, '''', '&apos;', [rfReplaceAll] );
     ctext :=  stringreplace( ctext, '"', '&quot;', [rfReplaceAll] );
     result := ctext;
end;

function ColTrans( ct : TColor ) : string;
var
   tempstr : string;
begin
    if ct < 0 then
    begin
        ct := ct and $FFFFFF;
    end;
    tempstr := format ( '%6.6x', [longint(ct)]);
    result := '#' + copy( tempstr, 5, 2 ) +copy( tempstr, 3, 2 )  +copy( tempstr, 1, 2 ) ;
end;
{#ifdef STUFF}
// turns a byte into 2 hex digits
{CH procedure Hexit( var c1 : char; var c2 : char; b : byte );
var
       b1, b2 : byte;
begin
      b1 := b shr 4;
      b2 := b and $0F;
      if b1 < 10 then
          c1 := chr( b1 + ORD0 )
      else
          c1 := chr( (b1-10) + ORDA );
      if b2 < 10 then
          c2 := chr( b2 + ORD0 )
      else
          c2 := chr( (b2-10) + ORDA );
end; }

// strip off file extension
{CH function basename( fname : string ) : string;
var
   p : integer;
   ps,fs : string;
begin
    basename := fname;
    ps:=sysutils.ExtractFilePath(fname);
    fs:=sysutils.ExtractFileName(fname);
    p := pos( '.', fs );
    if p = 0 then exit;
    basename := ps + copy( fs, 1, p - 1 );
end; }
{#endif}

end.

