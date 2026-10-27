{*******************************************************}
{                                                       }
{       QR PDF filter core                              }
{                                                       }
{       Copyright (C) 2007 QBS Software                 }
{       All Rights Reserved                             }
{                                                       }
{*******************************************************}

unit QRPDFFilt;
{////////////////////////////////////////////////////////////////////////////
   Copyright (c) 2007 QBS Software
   All Rights Reserved

   http://www.quickreport.co.uk                            

//  Unit : QRPDFFilt.pas
//
//  TQRGAbstractExportFilter -> TQRPDFDocumentFilter
//
//  The new PDF Export document filter class -                                      
//
//  (c) 2001 QBS Software
//      created 28th September 2001
//   17/11 fix stretch ug with TQRGRImage - now stretchraw in control rect
//   25/11 Added proprtional control to PDF
//   11/01/02 added Inside proportional mode
//   14/02/02 add top margin adjust and left m adjust
//
//   REVISION to V2.0 - 21-06-02
//   QRDBImage, QRImage and QRShape now supported.
//   9/9/02 SetTempPath added.
//   22/01/03 fixed Nil db image bug.
//   15/01/03 added compression
//   15/03/03 added DocumentInfo
//   6/08/03  MSL added SetConatenating
//   30/10/03 fixed path on temp image file
//   28/12/2003 added TrueType embedding
//   19/02/04 Image stretch bug fix
//   2004-06-22 portions by Sch
//              New:     FontHandling property
//                       Ascii85Filter
//                       pdfobjs completely merged into QRPDFFilt
//                       proper value for /Flags
//                       bugfixes/comments
//              Removed: non-working SetCharset property
//                       external DLL functionality
//              Changed: Compression is ON by default
//                       No need to convert spaces to dashes in Font names for substitutions
//                       Win9X unsupported function GetCharWidth32 replaced with GetCharABCWidths
//   2004-06-23 portions by Sch
//              Changed: New code for RunLengthDecodeFilter
//                       Corrected /Basename for TrueType fonts
//                       Concatenation works again
//                       Can concatenate reports with different paper sizes/orientation
//   2004-09-28 DLM      Must call init before AcceptGraphic or TextOut
//                       RGB colour extract fixed.
//
//   2005-06-06          Tried Czech encoding vector
//   2005-06-24          fix memory leaks with GetText
//   2005-06-25          Stream re-instated
//   22/11/2005          High res graphics for RTF export accepted
//   10/07/06            Added more Hi-res stuff
//   14/10/2006          stream was being closed improperly
//   11/12/2006          Autoembed=all TTF fonts+embedded, NoEmbed=all TF/no embedding
//                       except for fonts added with AddTTFont.
//   13/03/2007          Conditional CW32 for charwidths calls
//   09/09/2007          Added diagonal line shapes and filled circles for QR5
//   06/Jan/2009         Added euro symbol -> \200
//   22/Jul/2009         fixed top and left margins and SetPageParams
//   12/May/2010         output now in Ansi encoding - accented chars good now
//   7/July/2010         xref byte count fixed.
//   20/July/2010        field BGHFact extended added to fudge background widths.
//   10/01/2011          add Codepage property
//   06/01/2012          -jb change Default code page at initialization
//   09/01/2012          -jb partially reformat source code for better reading
//   19/01/2012          -jb repair pdf overlap character for nondefault codepage
//   04/04/2012          dlm fix image and graphic export when hires metafile is in use
//   05/04/2012          dlm fix right/center justified text when hires metafile is in use
//   05/04/2012          dlm add underline and strikeout font styles
//   30/07/2012          procedure procedure WriteStrNoCRLF(S: string); add 2 bytes to length
//   13/09/2012          bugs in xref table and stream length fixed. PDF looks good now.
////////////////////////////////////////////////////////////////////////////}
{$define VER20}
{$I QRDEFS.INC}
interface

uses
  Windows, Classes, Controls, StdCtrls, SysUtils, Graphics, Buttons, Forms, ExtCtrls, Dialogs, Printers, Db,
  {$IFDEF QRBDE} DBTables, {$ENDIF}
  ComCtrls, qrexport, QRPrntr, QuickRpt, QR5Const, QRCtrls, grimgctrl, pdfconst{$ifndef DXE}, system.UITypes{$endif};

const
  cFontMapSeparator = ':';
  cCourier = 'Courier';
  cHelvetica = 'Helvetica';
  cTimes = 'Times';
  cSymbol = 'Symbol';
  cZapfDingbats = 'ZapfDingbats';
  BaseFamilies : array [0..4] of string = (cCourier, cHelvetica, cTimes, cSymbol, cZapfDingbats );
  // ascii
  CRLF = #$D#$A;
  CR = $D;
  LF = $A;
  TAB = #$9;
  CZECH_ENC =
    '2 /space/space/space/space/space/space'+
    '/space/space/space/space/space/space/space/space'+
    '/space/space/space/space/space/space/space/space'+
    '/space/space/space/space/space/space/space/space'+
    '/space/exclam/quotedbl/numbersign/dollar/percent/ampersand/quoteright'+
    '/parenleft/parenright/asterisk/plus/comma/minus/period/slash/zero/one'+
    '/two/three/four/five/six/seven/eight/nine/colon/semicolon/less/equal/greater'+
    '/question/at/A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P/Q/R/S/T/U/V/W/X/Y/Z'+
    '/bracketleft/backslash/bracketright/asciicircum/underscore/quoteleft'+
    '/a/b/c/d/e/f/g/h/i/j/k/l/m/n/o/p/q/r/s/t/u/v/w/x/y/z/braceleft/bar'+
    '/braceright/tilde/space/space/space/quotesinglbase/space/quotedblbase'+
    '/ellipsis/dagger/daggerdbl/space/perthousand/Scaron/guilsinglleft/Sacute'+
    '/Tcaron/Zcaron/Zacute/space/quoteleft/quoteright/quotedblleft'+
    '/quotedblright/bullet/endash/emdash/space/trademark/scaron'+
    '/guilsinglright/sacute/tcaron/zcaron/zacute/space/caron/breve/Lslash'+
    '/currency/Aogonek/brokenbar/section/dieresis/copyright/Scedilla'+
    '/guillemotleft/logicalnot/hyphen/registered/Zdotaccent'+
    '/degree/plusminus/ogonek/lslash/acute/mu/paragraph/bullet'+
    '/cedilla/aogonek/scedilla/guillemotright/Ydieresis/hungarumlaut/Lcaron'+
    '/zdotaccent/Racute/Aacute/Acircumflex/Abreve/Adieresis/Lacute/Cacute'+
    '/Ccedilla/Ccaron/Eacute/Eogonek/Edieresis/Ecaron/Iacute/Icircumflex'+
    '/Dcaron/Eth/Nacute/Ncaron/Oacute/Ocircumflex/Ohungarumlaut/Odieresis'+
    '/multiply/Rcaron/Uring/Uacute/Uhungarumlaut/Udieresis/Yacute/Tcedilla'+
    '/germandbls/racute/aacute/acircumflex/abreve/adieresis/lacute/cacute'+
    '/ccedilla/ccaron/eacute/eogonek/edieresis/ecaron/iacute/icircumflexv'+
    '/dcaron/dbar/nacute/ncaron/oacute/ocircumflex/ohungarumlaut/odieresis'+
    '/divide/rcaron/uring/uacute/uhungarumlaut/udieresis/yacute/tcedilla/dotaccent';

type
  TFontHandling = (fhSubstitute, fhAutoEmbed, fhNoEmbedding );
  //
  //fhSubstitute:
  //   Substitute every font with pre-defined ones. (See BaseFamilies array)
  //   Possible to embed fonts manually via AddTTFont.
  //   Encoding is WinAnsiEncoding.
  //   Custom encoding can result in wrong/missing characters.
  //
  //fhAutoEmbed:
  //   Embed all fonts appearing in report automatically.
  //   No need to use AddTTFont.
  //
  //fhNoEmbedding:
  //   To keep PDF size small, font data (TTF file) will be not included
  //   All the required fonts and Acrobat Reader 6.0 or better must be
  //   installed on target platform. Almost perfectly displays in Reader 5.0 too.
  //

  {  TQRPAbstractExportFilter  }

  TQRPAbstractExportFilter = class(TQRExportFilter)
  private
    FStream: TStream;
    FCharWidth,
    FCharHeight,
    FPaperWidth,
    FPaperHeight: Extended;
    FLineCount,
    FColCount: Integer;
    FPageProcessed: Boolean;
  protected
    function GetCodepage : string;
    procedure SetSuppressDatetime( value : boolean);
    function getSuppressDatetime : boolean;
    procedure SetCodepage( value : string);
    function GetEncoding : TTextEncoding;
    procedure SetEncoding( value : TTextEncoding);
    function GetText(X, Y: Extended; var Font: TFont) : string;
    function GetFilterName : string; override;
    function GetDescription : string; override;
    function GetExtension : string; override;
    procedure WriteToStream(const AText: string);
    procedure WriteLnToStream(const AText: string);
    procedure CreateStream(FileName: string); virtual;
    procedure CloseStream; virtual;
    procedure ProcessPage; virtual;
    procedure StorePage; virtual;
    property Stream : TStream read FStream write FStream;
    property PageProcessed : Boolean read FPageProcessed write FPageProcessed;
    property CharWidth : Extended read FCharWidth write FCharWidth;
    property CharHeight : Extended read FCharHeight write FCharHeight;
    property PaperWidth : Extended read FPaperWidth write FPaperWidth;
    property PaperHeight : Extended read FPaperHeight write FPaperHeight;
    property LineCount : Integer read FLineCount write FLineCount;
    property ColCount : Integer read FColCount write FColCount;
  public
    BGHFactor : extended;
    constructor Create(FileName: string); override;
    procedure Start(PaperWidth, PaperHeight: Integer; Font: TFont); override;
    procedure Finish; override;
    procedure EndPage; override;
    procedure NewPage; override;
    procedure AcceptGraphic(Xoff, Yoff: Extended; GControl: TControl); override;
    procedure TextOut(X, Y: Extended; Font: TFont; bgColor: TColor; Alignment: TAlignment; Text: string);
              override;
    property TextEncoding : TTextencoding read GetEncoding write setEncoding;
    property Codepage : string read GetCodepage write setCodepage;
    property SuppressDateTime : Boolean read getSuppressDateTime write setSuppressDateTime;
  end;

  {  TPDFPages  }

  TPDFPages = record
    PageWidth, PageHeight: Extended;
  end;

  {  TPDFNote  }

  TPDFNote = record
    //NOTE: best practice will should be create class for freeing kept resources
    //-JB this constuct under record is little bit dangerous
    pages: array of TPDFPages;
    pagetextfiles,
    pagegraphicsfiles,
    textlengths,
    graphicslengths,
    XRefBytes: TStringList;
  end;

  {  TQRPDFDocumentFilter  }

  TQRPDFDocumentFilter = class(TQRPAbstractExportFilter)
  private
    FFreeStream: Boolean;
    FBodyColor: TColor;
    FFirstPage: Boolean;
    FPageLength: Integer;
    FPageNumber: Longint;
    //    FNextPicnum: Longint;
    //    FReportnum: Integer;
    FLeftMargin: Integer;
    FTopMargin: Integer;
    FPDFConcatenating: Boolean;
    FPDFTextOnTop: Boolean;
    FFontHandling: TFontHandling;
    FBiDiMode : TBiDiMode;
    FMadeFirstPageFiles: Boolean;
    FTextFirst: Boolean;
    FDocSubject,
    FDocCreator,
    FDocTitle,
    FDocAuthor: string;
    FOldSeparator: Char;
    FCustomWidths,
    FCustomEncodings: TDictionary;
    FPDFCompressionOn: Boolean;
    FGraphicsLength,
    FTextLength: Integer;
    FPDF: TPDFNote;
    FReportFonts, // all the fonts in report
    FEmbedFonts, //fonts that should not be substituted
    FSubstitutedFonts: TStringList; // substitutions
    FPageWidth,
    FPageHeight,
    FExtTopMargin,
    FAdjustTM,
    FAdjustLM: Extended;
    FVertAdjust: Integer;
    procedure SetTextOnTop(bVal: Boolean);
    procedure SetConcatenating(p_Value: Boolean);
    function getConcatenating : Boolean;
    function getTextOnTop : Boolean;
    procedure StartPage;
    procedure FinishPage;
    procedure ProcessItem(ir: TPDFItemRec);
    procedure AddImageItem(ItemRec: TPDFItemRec; imgdata: Pointer);
    procedure AddPDFItem(ItemRec: TPDFItemRec);
    procedure PTWrite(ob: string);
    procedure GRWrite(ob: string);
    procedure GRWriteBlob(Idata : TMemorystream);
  protected
    function GetFilterName : string; override;
    function GetDescription : string; override;
    function GetExtension : string; override;
    function GetStreaming : Boolean; override;
    procedure CreateStream(FileName: string); override;
    procedure CloseStream; override;
  public
    constructor Create(FileName: string); override;
    destructor Destroy; override;
    procedure StorePage; override;
    procedure TextOut(X, Y: Extended; Font: TFont; bgColor: TColor; Alignment: TAlignment; Text: string);
              override;
    procedure ProcessPage; override;
    procedure Start(PaperWidth, PaperHeight: Integer; Font: TFont); override;
    procedure Finish; override;
    procedure SetMargins(TopMarg, Leftmarg: Integer);
    procedure NewPage; override;
    procedure EndPage; override;
    procedure EndConcat;
    procedure AcceptGraphic(Xoff, Yoff: Extended; GControl: TControl); override;
    procedure SetDocumentInfo(Creator, author, Title, Subject: string);
    procedure AddFontMap(ssmap: string);
    procedure SetPageParams( w, h, tm, tma, lma : extended );
    procedure AddTTFont(FontName: string);
    procedure AddCustomWidths(FontName, widthstr: string);
    procedure AddCustomEncoding(FontName, encodingstr: string);
    property PageLength : Integer read FPageLength write FPageLength;
    property Stream;

    property FreeStream : Boolean read FFreeStream write FFreeStream;
    property TextOnTop : Boolean read getTextOnTop write SetTextOnTop;
    property Concatenating : Boolean read getConcatenating write SetConcatenating;
    //    property Reportnum : Integer read FReportnum write FReportnum;
    property TopMargin : Integer read FTopMargin write FTopMargin;
    property leftMargin : Integer read FLeftMargin write FLeftMargin;
    property CompressionOn : Boolean read FPDFCompressionOn write FPDFCompressionOn;
    property FontHandling : TFontHandling read FFontHandling write FFontHandling;
    property BiDiMode : TBiDiMode read FBiDiMode write FBiDiMode;
    property TextEncoding;
    property Codepage;
  end;

  {  TQRPDFFilter  }

  TQRPDFFilter = class(TComponent)
  private
   FCompressionOn : boolean;
  protected
     function GetCodepage : string;
     procedure SetCodepage( value : string);
     function GetEncoding : TTextEncoding;
     procedure SetEncoding( value : TTextEncoding);
     procedure SetSuppressDatetime( value : boolean);
     function getSuppressDatetime : boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property CompressionOn : Boolean read FCompressionOn write FCompressionOn;
    property TextEncoding : TTextencoding read GetEncoding write SetEncoding;
    property Codepage : string read GetCodepage write setCodepage;
    property SuppressDateTime : Boolean read getSuppressDateTime write setSuppressDateTime;
  end;

  procedure AsciiHexEncodeFilter(sFrom, sTo: TMemoryStream);
  //procedure Ascii85EncodeFilter(sFrom, sTo: TMemoryStream);

implementation

uses jpeg, lzw;

const
  PointsPerMM = 72.0/25.4;

var
  MMperpixelX,
  MMperpixelY: Extended;
  PointsPerPixelX,
  PointsPerPixelY: Extended;
  CurrPageFile,
  CurrImageFile: TStringList;
  PDFEncoding : TTextencoding;
  PDFCodepage : string;
  PDFSuppressDateTime : boolean;

//old PDFobjs starts here
type
  {CH TBuffer = array of Byte; }
  {CH TPDFPageObj = class(TObject)
  private
  public


    textlen
: Longint;
  end; }
  UShort = Word;
  longDateTime = Int64;
  THeadTable = Packed record
    TableVersionNumber: FIXED;
    fontRevision: FIXED;
    checkSumAdjustment: ULong;
    magicNumber: ULong;
    Flags: UShort;
    unitsPerEm: UShort;
    Created: longDateTime;
    Modified: longDateTime;
    xMin: Short;
    yMin: Short;
    XMax: Short;
    yMax: Short;
    macStyle: UShort;
    lowestRecPPEM: UShort;
    fontDirectionHint: Short;
    indexToLocFormat: Short;
    glyphDataFormat: Short;
  end;
  TOS2table = packed record
    Version: UShort;
    xAvgCharWidth: Short;
    usWeightClass: UShort;
    usWidthClass: UShort;
    fsType: UShort;
    ySubscriptXSize: Short;
    ySubscriptYSize: Short;
    ySubscriptXOffset: Short;
    ySubscriptYOffset: Short;
    ySuperscriptXSize: Short;
    ySuperscriptYSize: Short;
    ySuperscriptXOffset: Short;
    ySuperscriptYOffset: Short;
    yStrikeoutSize: Short;
    yStrikeoutPosition: Short;
    sFamilyClass: Short;
    PANOSE: array [1..10] of Byte;
    ulUnicodeRange1: ULong;
    ulUnicodeRange2: ULong;
    ulUnicodeRange3: ULong;
    ulUnicodeRange4: ULong;
    achVendID: array [1..4] of Char;
    fsSelection: UShort;
    usFirstCharIndex: UShort;
    usLastCharIndex: UShort;
    sTypoAscender: Short;
    sTypoDescender: Short;
    sTypoLineGap: Short;
    usWinAscent: UShort;
    usWinDescent: UShort;
    ulCodePageRange1: ULong;
    ulCodePageRange2: ULong;
    sxHeight: Short;
    sCapHeight: Short;
    usDefaultChar: UShort;
    usBreakChar: UShort;
    usMaxContext: UShort;
  end;

{CH procedure Bmp2Jpeg(const BmpFileName, JpgFileName: string);
var
  Bmp: TBitmap;
  Jpg: TJPEGImage;
begin
  Bmp := TBitmap.Create;
  Jpg := TJPEGImage.Create;
  try
    Bmp.LoadFromFile(BmpFileName);
    Jpg.Assign(Bmp);
    Jpg.SaveToFile(JpgFileName);
  finally
    Jpg.Free;
    Bmp.Free;
  end;
end; }

{CH procedure Jpeg2Bmp(const BmpFileName, JpgFileName: string);
var
  Bmp: TBitmap;
  Jpg: TJPEGImage;
begin
  Bmp := TBitmap.Create;
  Jpg := TJPEGImage.Create;
  try
    Jpg.LoadFromFile(JpgFileName);
    Bmp.Assign(Jpg);
    Bmp.SaveToFile(BmpFileName);
  finally
    Jpg.Free;
    Bmp.Free;
  end;
end; }

{  TQRPDFFilter  }

constructor TQRPDFFilter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  QRExportFilterLibrary.AddFilter(TQRPDFDocumentFilter);
end;

destructor TQRPDFFilter.Destroy;
begin
  QRExportFilterLibrary.removeFilter(TQRPDFDocumentFilter);
  inherited Destroy;
end;

function TQRPDFFilter.GetCodepage : string;
begin
  result := PDFCodepage;
end;

procedure TQRPDFFilter.SetCodepage( value : string);
begin
  PDFCodepage := value;
end;

function TQRPDFFilter.GetEncoding : TTextEncoding;
begin
  result := PDFEncoding;
end;

procedure TQRPDFFilter.SetEncoding( value : TTextEncoding);
begin
  PDFEncoding := value;
end;

procedure TQRPDFFilter.SetSuppressDateTime( value : boolean);
begin
  PDFSuppressDateTime := value;
end;

function TQRPDFFilter.getSuppressDateTime: boolean;
begin
  result := PDFSuppressDateTime
end;

procedure Color2RGB(C: TColor; var RGB: TRGBColor);
begin
  RGB.red := getRvalue( ColorToRGB(C));
  RGB.green := getGvalue( ColorToRGB(C));
  RGB.blue := getBvalue( ColorToRGB(C));
end;

{CH function cvtDWord(Buf: array of byte; P: Integer) : DWORD;
begin
  Result:=(256*256*256*Buf[P])+(256*256*Buf[P+1])+(256*Buf[P+2])+Buf[P+3];
end; }

{TQRPDFDocumentFilter}

procedure TQRPDFDocumentFilter.PTWrite(ob: string);
begin
  CurrPageFile.Add(ob);
  Inc(FTextLength, Length(ob)+2);
end;

procedure TQRPDFDocumentFilter.GRWriteBlob(Idata : TMemorystream);
var
   k : dword;
   bb : byte;
   istr : string;
begin
  // make this look like unicode by converting to chars
  istr := '';
  idata.Position := 0;
  for k := 0 to Idata.Size - 1 do
  begin
       idata.ReadBuffer( bb, 1);
       istr := istr + chr(bb);
  end;
  CurrImageFile.Add(istr);
  Inc(FGraphicsLength, idata.Size);
  idata.Free;
end;

procedure TQRPDFDocumentFilter.GRWrite(ob: string);
begin
  CurrImageFile.Add(ob);
  Inc(FGraphicsLength, Length(ob)+2);
end;

procedure TQRPDFDocumentFilter.StartPage;
var
  QR: TQuickRep;
  screenYFactor : extended;
begin
  MMperpixelX := 1.0 / (10 * TQuickRep(Self.Owner).QRPrinter.xfactor);
  MMperpixelY := 1.0 / (10 * TQuickRep(Self.Owner).QRPrinter.yfactor);
  PointsPerPixelX := PointsPerMM * MMperpixelX;
  PointsPerPixelY := PointsPerMM * MMperpixelY;
  FExtTopMargin := TQuickRep(Self.Owner).Page.TopMargin * 0.1;
  FExtTopMargin := FExtTopMargin * PointsPerMM;
  screenYFactor := forms.Screen.PixelsPerInch / 254;
  FExtTopMargin := FExtTopMargin*( TQuickRep(Self.Owner).QRPrinter.yfactor/ screenYFactor);
  FAdjustTM := 0; // added to the y of every incoming item
  FAdjustLM := 0;
  Inc(FPageNumber);
  QR := TQuickRep(Self.Owner);
  SetLength(FPDF.pages, FPageNumber);
  FPageWidth := 0.1 * Round(QR.Page.Width) * PointsPerMM;
  FPageHeight := 0.1 * Round(QR.Page.Length) * PointsPerMM;
  FPDF.pages[FPageNumber - 1].PageWidth := FPageWidth;
  FPDF.pages[FPageNumber - 1].PageHeight := FPageHeight;
  CurrPageFile := TStringList.Create;
  FPDF.pagetextfiles.AddObject(IntToStr(FPageNumber), CurrPageFile);
  CurrImageFile := TStringList.Create;
  // CurrImageFile.

  FPDF.pagegraphicsfiles.AddObject(IntToStr(FPageNumber), CurrImageFile);
  FTextLength := 0;
  FGraphicsLength := 0;
  FMadeFirstPageFiles := True;
end;

procedure TQRPDFDocumentFilter.SetPageParams( w, h, tm, tma, lma : extended );
begin
  FPageWidth := w;
  FPageHeight := h;
  Ftopmargin := round(tm);
  fadjusttm := tma;
  fadjustlm := lma;
end;

procedure TQRPDFDocumentFilter.FinishPage;
begin
  PTWrite('ET');
  FPDF.textlengths.Add(Format('%d', [FTextLength]));
  FPDF.graphicslengths.Add(Format('%d', [FGraphicsLength]));
end;

{CH function StreamToString(sFrom: TMemoryStream) : string;
var
  Len: Integer;
  S: string;
begin
  sFrom.Position:=0;
  Len:=sFrom.Size;
  SetLength(S, Len);
  if Len>0 then sFrom.ReadBuffer(S[1], Len);
  Result:=S;
end; }

function sParam(var S: string; Delimiter: string) : string;
var
  I: Integer;
begin
  I:=Pos(Delimiter, S);
  if I=0 then I:=Length(S)+1;
  Result:=Copy(S, 1, I-1);
  S:=Copy(S, I+Length(Delimiter), Length(S));
end;

procedure TQRPDFDocumentFilter.ProcessItem(ir: TPDFItemRec);
var
  fontnum: Integer;
  XRadius,
  YRadius: Extended;
  PDFFontName,
  currfont,
  tstr,
  tfname: string;

  function RGBString(ACol: TRGBColor): string;
  begin
    result := Trim(Format('%4.2f %4.2f %4.2f', [ACol.red / 255.0, ACol.green / 255.0, ACol.blue / 255.0]));
  end;

  // see AD chapter 10. 'Bezier curves'
  function PDFArcTo(X1, Y1, X2, Y2, XRadius, YRadius: Extended): string;
  var
    C: array [1 .. 6] of Extended;
    I: Integer;
    w, Y: Extended;
  begin
    result := '';
    C[5] := X2;
    C[6] := Y2;
    w := XRadius * 0.55229;
    Y := YRadius * 0.55229;
    if X2 > X1 then
    begin
      if Y2 > Y1 then
      begin
        C[1] := X1;
        C[2] := Y1 + Y;
        C[3] := X2 - w;
        C[4] := Y2;
      end
      else
      begin
        C[1] := X1 + w;
        C[2] := Y1;
        C[3] := X2;
        C[4] := Y2 + Y;
      end;
    end
    else
    begin
      if Y2 > Y1 then
      begin
        C[1] := X1 - w;
        C[2] := Y1;
        C[3] := X2;
        C[4] := Y2 - Y;
      end
      else
      begin
        C[1] := X1;
        C[2] := Y1 - Y;
        C[3] := X2 + w;
        C[4] := Y2;
      end;
    end;
    for I := 1 to 6 do
    begin
      result := result + Format(' %6.1f', [C[I]]) + ' ';
    end;
    result := Trim(result) + ' c';
  end;
begin
  if ir.ItemType=IT_INVALID then raise EQRError.Create('Internal error: IT_INVALID'); //just to be sure
  {$IF CompilerVersion >=22.0}FormatSettings.{$IFEND}DecimalSeparator:='.';
  ir.YPos:=ir.YPos+FVertAdjust;
  // transform upside-down
  ir.YPos:=FPageHeight-ir.YPos;
  if ir.ItemType=IT_NEWPAGE then
  begin
    FinishPage;
    StartPage;
    Exit;
  end;
  if ir.ItemType=IT_TEXT then
  begin
    // stuff escapes THEN brackets
    tstr:=ir.FText;
    tstr:=StringReplace(tstr, '\', '\\', [rfReplaceAll]);
    tstr:=StringReplace(tstr, '(', '\(', [rfReplaceAll]);
    tstr:=StringReplace(tstr, ')', '\)', [rfReplaceAll]);
    // stuff euro
    tstr := stringReplace( tstr, '€', '\200', [rfReplaceAll]);
    // FReportFonts format:  [Windows font name]TAB[font style]TAB[charset]TAB[PDFFontName]
    PDFFontName:=Trim(ir.FontName);
    //if FontHandling in [fhAutoEmbed] then AddTTFont(PDFFontName);
    tfname:=PDFFontName+TAB;
    PDFFontName:=StringReplace(PDFFontName, ' ', '', [rfReplaceAll]);
    if ir.fbold or ir.fItalic then PDFFontName:=PDFFontName+',';
    if ir.fbold then
    begin
      tfname:=tfname+'B';
      PDFFontName:=PDFFontName+'Bold';
    end;
    if ir.fItalic then
    begin
      tfname:=tfname+'I';
      PDFFontName:=PDFFontName+'Italic';
    end;
    tfname:=tfname+TAB+IntToStr(ir.FontCharset)+TAB+PDFFontName;
    fontnum:=FReportFonts.IndexOf(tfname);
    if fontnum<0 then
    begin
      FReportFonts.Add(tfname);
      fontnum:=FReportFonts.Count-1;
    end;
    // set the color r g b rg
    PTWrite(RGBString(ir.RGBFColor)+' rg');
    currfont:=Format('F%-2.2d', [fontnum]);
    // output the text rendering instructions
    // try Tm instead of Td
    PTWrite('/'+currfont+Format(' %d Tf', [ir.FontSize]));
    PTWrite(Format(' 1 0 0 1 %d %d Tm (%s) Tj', [trunc(ir.XPos), trunc(ir.YPos), tstr]));
  end; // text items
  if ir.ItemType=IT_GRAPHIC then
  begin
    case ir.Shape of
            S_BOX: begin
                     GRWrite(Format('%f w', [ir.thickness]));
                     tstr:=Format('%d %d %d %d re ', [trunc(ir.XPos), trunc(ir.YPos-ir.Height), trunc(ir.Width),
                                  trunc(ir.Height)]);
                     if ir.Filled then begin
                       GRWrite(RGBString(ir.RGBFColor)+' rg');
                       tstr:=tstr+'f'
                     end else begin
                       GRWrite(RGBString(ir.RGBStrokeColor)+' RG');
                       tstr:=tstr+'s'
                     end;
                     GRWrite(tstr);
                   end;
         S_CIRCLE: begin
                     GRWrite(Format('%2.0f w', [ir.thickness]));
                     if ir.Filled then begin
                       GRWrite(RGBString(ir.RGBFColor)+' rg');
                     end else begin
                       GRWrite(RGBString(ir.RGBStrokeColor)+' RG');
                     end;
                     XRadius:=ir.Width/2;
                     YRadius:=ir.Height/2;
                     GRWrite(Format('%6.1f ', [ir.XPos+XRadius])+Format('%6.1f', [ir.YPos])+
                             ' m');
                     GRWrite(PDFArcTo(ir.XPos+XRadius, ir.YPos, ir.XPos+ir.Width, ir.YPos-YRadius, XRadius,
                                      YRadius));
                     GRWrite(PDFArcTo(ir.XPos+ir.Width, ir.YPos-YRadius, ir.XPos+XRadius, ir.YPos-ir.Height,
                                      XRadius, YRadius));
                     GRWrite(PDFArcTo(ir.XPos+XRadius, ir.YPos-ir.Height, ir.XPos, ir.YPos-YRadius, XRadius,
                                      YRadius));
                     if ir.Filled then
                          GRWrite(PDFArcTo(ir.XPos, ir.YPos-YRadius, ir.XPos+XRadius, ir.YPos, XRadius, YRadius)+
                             ' f')
                     else
                          GRWrite(PDFArcTo(ir.XPos, ir.YPos-YRadius, ir.XPos+XRadius, ir.YPos, XRadius, YRadius)+
                             ' s');
                   end;
          S_HLINE: begin
                     GRWrite(Format('%2.0f w', [ir.thickness]));
                     GRWrite(RGBString(ir.RGBStrokeColor)+' RG');
                     tstr:=Format('%d %d m %d %d l s', [trunc(ir.XPos), trunc(ir.YPos-(ir.Height/
                                        2)), trunc(ir.XPos+ir.Width), trunc(ir.YPos-(ir.Height/
                                       2))]);
                     GRWrite(tstr);
                   end;
          S_VLINE: begin
                     GRWrite(Format('%2.0f w', [ir.thickness]));
                     GRWrite(RGBString(ir.RGBStrokeColor)+' RG');
                     tstr:=Format('%d %d m %d %d l s', [trunc(ir.XPos+(ir.Width/2)), trunc(ir.YPos-ir.Height),
                                  trunc(ir.XPos+(ir.Width/2)), trunc(ir.YPos)]);
                     GRWrite(Trim(tstr));
                   end;
      S_TOPBOTTOM: begin
                     GRWrite(Format('%2.0f w', [ir.thickness]));
                     GRWrite(RGBString(ir.RGBStrokeColor)+' RG');
                     tstr:=Format('%d %d m %d %d l s', [trunc(ir.XPos), trunc(ir.YPos), trunc(ir.XPos+ir.Width),
                                  trunc(ir.YPos)]);
                     GRWrite(tstr);
                     tstr:=Format('%d %d m %d %d l s', [trunc(ir.XPos), trunc(ir.YPos-ir.Height), trunc(ir.XPos
                                                +ir.Width), trunc(ir.YPos-ir.Height)]);
                     GRWrite(tstr);
                   end;
      S_LEFTRIGHT: begin
                     GRWrite(Format('%2.0f w', [ir.thickness]));
                     GRWrite(RGBString(ir.RGBStrokeColor)+' RG');
                     tstr:=Format('%d %d m %d %d l s', [trunc(ir.XPos), trunc(ir.YPos-ir.Height), trunc(ir.XPos),
                                  trunc(ir.YPos)]);
                     GRWrite(Trim(tstr));
                     tstr:=Format('%d %d m %d %d l s', [trunc(ir.XPos+ir.Width), trunc(ir.YPos-ir.Height),
                                  trunc(ir.XPos+ir.Width), trunc(ir.YPos)]);
                     GRWrite(Trim(tstr));
                   end;
      S_LEFTDIAG: begin
                     GRWrite(Format('%2.0f w', [ir.thickness]));
                     GRWrite(RGBString(ir.RGBStrokeColor)+' RG');
                     tstr:=Format('%d %d m %d %d l s', [trunc(ir.XPos), trunc(ir.YPos-ir.Height), trunc(ir.XPos+ir.Width),
                                  trunc(ir.YPos)]);
                     GRWrite(Trim(tstr));
                   end;
      S_RIGHTDIAG: begin // old oblique line
                     GRWrite(Format('%2.0f w', [ir.thickness]));
                     GRWrite(RGBString(ir.RGBStrokeColor)+' RG');
                     tstr:=Format('%d %d m %d %d l s', [trunc(ir.XPos), trunc(ir.YPos), trunc(ir.XPos+ir.Width),
                                  trunc(ir.YPos-ir.Height)]);
                     GRWrite(Trim(tstr));
                   end;
    end;
  end;
  if ir.ItemType=IT_IMAGE then
  begin
    GRWrite(Format('q %d 0 0 %d %d %d cm', [trunc(ir.Width*ir.xscale), trunc(ir.Height*ir.yscale), trunc(ir.XPos),
                   trunc(ir.YPos)]));
    GRWrite('BI');
    GRWrite(Format('/Width %d', [ir.pixelWidth]));
    GRWrite(Format('/Height %d', [ir.pixelHeight]));
    GRWrite('/BitsPerComponent 8');
    GRWrite('/ColorSpace /DeviceRGB');
    GRWrite('/Filter ['+ir.ImageFilter+']');
    GRWrite('ID');
    //GRWrite(ir.ImageData); // the encoded image
    GRWriteBlob(ir.imgstr); // the encoded image
    GRWrite('EI');
    GRWrite('Q');
  end;
  {$IF CompilerVersion >=22.0}FormatSettings.{$IFEND}DecimalSeparator:=FOldSeparator;
end;

// Exported : add image
procedure TQRPDFDocumentFilter.AddImageItem(ItemRec: TPDFItemRec; imgdata: Pointer);
begin
  if not FMadeFirstPageFiles then StartPage;
  ItemRec.YPos:=ItemRec.YPos+FAdjustTM;
  ItemRec.XPos:=ItemRec.XPos+FAdjustLM;
  ProcessItem(ItemRec);
end;

procedure ReverseText(var ItemRec: TPDFItemRec);
var
  tstr: string;
  k: Integer;
begin
  tstr := '';
  for k := Length(ItemRec.FText) downto 1 do
  begin
    tstr := tstr + ItemRec.FText[k];
  end;
  ItemRec.FText := tstr;
end;

// Exported procedure - receive item data
procedure TQRPDFDocumentFilter.AddPDFItem(ItemRec: TPDFItemRec);
begin
  if not FMadeFirstPageFiles then
                           StartPage;
  ItemRec.YPos:=ItemRec.YPos+FAdjustTM;
  ItemRec.XPos:=ItemRec.XPos+FAdjustLM;
  if FBiDiMode = bdRightToLeft then
       ReverseText( ItemRec);
  ProcessItem(ItemRec);
end;

//======================= Filters ===========================
// Fixed for Tiburon. Uses no char or string types
procedure Ascii85EncodeFilter(sFrom, sTo: TMemoryStream);
const
  cBreakAtEvery = 200;
var
  I: Integer;
  InBuffer: array [0..3] of Byte;
  InDW: Cardinal;
  OutBuffer: array [0..4] of AnsiChar;
  WasRead: Integer;
  cntBreak: Integer;
begin
  cntBreak:=0;
  sTo.Position:=0;
  sTo.Size:=0;
  sFrom.Position:=0;
  while sFrom.Position<sFrom.Size do 
  begin
    for I := 0 to 3 do InBuffer[I]:=0;
    WasRead:=sFrom.Read(InBuffer, 4);
    InDW:=0;
    for I := 0 to 3 do InDW:=InDW shl 8+InBuffer[I];
    for I := 4 downto 0 do 
    begin
      OutBuffer[I]:=AnsiChar(InDW mod 85+$21);
      InDW:=InDW div 85;
    end;
    if (WasRead=4) and (OutBuffer='!!!!!') then 
    begin
      OutBuffer[0]:='z';
      sTo.Write(OutBuffer, 1);
    end 
    else 
      sTo.Write(OutBuffer, WasRead+1);
    cntBreak:=cntBreak+WasRead+1;
    if cntBreak>cBreakAtEvery then 
    begin
      cntBreak:=0;
      OutBuffer:=CRLF;
      sTo.Write(OutBuffer, 2);
    end;
  end;
  //end marker
  OutBuffer:='~>'; 
  sTo.Write(OutBuffer, 2);
end;

{  TQRPAbstractExportFilter  }

constructor TQRPAbstractExportFilter.Create(FileName: string);
begin
  inherited Create(FileName);
end;

procedure TQRPAbstractExportFilter.AcceptGraphic(Xoff, Yoff: Extended; GControl: TControl);
begin
  //placeholder
end;

function TQRPAbstractExportFilter.GetCodepage : string;
begin
  Result := PDFCodepage;
end;

procedure TQRPAbstractExportFilter.SetCodepage( value : string);
begin
  PDFCodepage := value;
end;

function TQRPAbstractExportFilter.GetEncoding : TTextEncoding;
begin
  Result := PDFEncoding;
end;

procedure TQRPAbstractExportFilter.SetEncoding( value : TTextEncoding);
begin
  PDFEncoding := value;
end;

procedure TQRPAbstractExportFilter.SetSuppressDatetime( value : boolean);
begin
    PDFSuppressDatetime := value;
end;
function TQRPAbstractExportFilter.getSuppressDatetime : boolean;
begin
   result := PDFSuppressDatetime;
end;

function TQRPAbstractExportFilter.GetFilterName : string;
begin
  Result:='QRAbstract'; // Do not translate
end;

function TQRPAbstractExportFilter.GetDescription : string;
begin
  Result:='';
end;

function TQRPAbstractExportFilter.GetExtension : string;
begin
  Result:='';
end;

procedure TQRPAbstractExportFilter.Start(PaperWidth, PaperHeight: Integer; Font: TFont);
begin
  // see override
  inherited Start(PaperWidth, PaperHeight, Font);
end;

procedure TQRPAbstractExportFilter.CreateStream(FileName: string);
begin
  //FStream:=TFileStream.Create(FileName, fmCreate);
end;

procedure TQRPAbstractExportFilter.CloseStream;
begin
  //FStream.Free;
end;

procedure TQRPAbstractExportFilter.WriteToStream(const AText: string);
begin
  Stream.Write(AText[1], Length(AText));
end;

procedure TQRPAbstractExportFilter.WriteLnToStream(const AText: string);
begin
  WriteToStream(AText+#13+#10);
end;

procedure TQRPAbstractExportFilter.Finish;
begin
  // all in override
  inherited;
end;

procedure TQRPAbstractExportFilter.NewPage;
begin
  // all in override
end;

procedure TQRPAbstractExportFilter.EndPage;
begin
  // all in override
end;

procedure TQRPAbstractExportFilter.ProcessPage;
begin
  FPageProcessed:=True;
end;

procedure TQRPAbstractExportFilter.StorePage;
begin
end;

procedure TQRPAbstractExportFilter.TextOut(X, Y: Extended; Font: TFont;
  bgColor: TColor; Alignment: TAlignment; Text: string);
begin
end;

function TQRPAbstractExportFilter.GetText(X, Y: Extended; var Font: TFont): string;
begin
end;

{  TQRPDFDocumentFilter  }

function TQRPDFDocumentFilter.getConcatenating : Boolean;
begin
  Result:=FPDFConcatenating;
end;

function TQRPDFDocumentFilter.getTextOnTop : Boolean;
begin
  Result:=FPDFTextOnTop;
end;

procedure TQRPDFDocumentFilter.SetConcatenating(p_Value: Boolean);
begin
  FPDFConcatenating:=p_Value;
end;

procedure TQRPDFDocumentFilter.AddFontMap(ssmap: string);
var
  K: Integer;
  S: string;
begin
  // expecting [Windows font name]:[predefined font name]
  // see TQRPDFDocumentFilter.Create for example
  S:=sParam(ssmap, cFontMapSeparator);
  ssmap:=Trim(S)+cFontMapSeparator+Trim(ssmap);
  K:=FSubstitutedFonts.IndexOf(ssmap);
  if K<>-1 then FSubstitutedFonts[K]:=ssmap else FSubstitutedFonts.Add(ssmap);
end;

procedure TQRPDFDocumentFilter.SetDocumentInfo(Creator, author, Title, Subject: string);

  procedure SetDocProperties(Creator, author, Title, Subject: string);
  begin
    FDocAuthor:=author;
    FDocTitle:=Title;
    FDocSubject:=Subject;
    FDocCreator:=Creator;
  end;
begin
  SetDocProperties(Creator, author, Title, Subject);
end;

procedure TQRPDFDocumentFilter.AddTTFont(FontName: string);
begin
  if FEmbedFonts.IndexOf(FontName)<0 then FEmbedFonts.Add(FontName);
end;

procedure TQRPDFDocumentFilter.AddCustomWidths(FontName, widthstr: string);
begin
  FCustomWidths.Add(FontName, widthstr);
end;

procedure TQRPDFDocumentFilter.AddCustomEncoding(FontName, encodingstr: string);
begin
  FCustomEncodings.Add(FontName, encodingstr);
end;

function TQRPDFDocumentFilter.GetFilterName : string;
begin
  Result:='PDF document';
end;

function TQRPDFDocumentFilter.GetDescription : string;
begin
  Result:='PDF document filter';
end;

function TQRPDFDocumentFilter.GetExtension : string;
begin
  Result:='PDF'; // Do not translate
end;

function TQRPDFDocumentFilter.GetStreaming : Boolean;
begin
  Result:=False;
end;

procedure TQRPDFDocumentFilter.CreateStream(FileName: string);
begin
  if FileName='' then
  begin
    FStream:=TMemoryStream.Create;
    FreeStream:=False;
  end {else begin
    FreeStream:=True;
    inherited CreateStream(FileName);
  end};
end;

procedure TQRPDFDocumentFilter.CloseStream;
begin
  if FreeStream then inherited CloseStream;
end;

destructor TQRPDFDocumentFilter.Destroy;
var
  K: Integer;
begin
  {$IF CompilerVersion >=22.0}FormatSettings.{$IFEND}DecimalSeparator:=FOldSeparator;
  FCustomWidths.Free;
  FCustomEncodings.Free;
  FReportFonts.Free;
  FSubstitutedFonts.Free;
  FEmbedFonts.Free;
  FPDF.XRefBytes.Free;
  FPDF.textlengths.Free;
  FPDF.graphicslengths.Free;
  for K := 0 to FPDF.pagegraphicsfiles.Count-1 do
          TStringList(FPDF.pagegraphicsfiles.Objects[K]).Free;
  FPDF.pagegraphicsfiles.Free;
  for K := 0 to FPDF.pagetextfiles.Count-1 do
              TStringList(FPDF.pagetextfiles.Objects[K]).Free;
  FPDF.pagetextfiles.Free;
  inherited;
end;

constructor TQRPDFDocumentFilter.Create(FileName: string);

  procedure InitLib(Mother: Pointer);
  begin
    // global creations
    FPDF.XRefBytes:=TStringList.Create;
    FPDF.textlengths:=TStringList.Create;
    FPDF.graphicslengths:=TStringList.Create;
    FPDF.pagetextfiles:=TStringList.Create;
    FPDF.pagegraphicsfiles:=TStringList.Create;
    FReportFonts:=TStringList.Create;
    FEmbedFonts:=TStringList.Create;
    // start a new page
    FPageNumber:=0;
    FMadeFirstPageFiles:=False;
    // load default font subs
    FSubstitutedFonts:=TStringList.Create;
    FSubstitutedFonts.Add('Arial'+cFontMapSeparator+'Helvetica');
    FSubstitutedFonts.Add('Times New Roman'+cFontMapSeparator+'Times');
    FSubstitutedFonts.Add('Courier New'+cFontMapSeparator+'Courier');
    FCustomWidths:=TDictionary.Create;
    FCustomEncodings:=TDictionary.Create;
    FVertAdjust:=0; // points
    FPageWidth:=595;
    FPageHeight:=840;
    FOldSeparator:={$IF CompilerVersion >=22.0}FormatSettings.{$IFEND}DecimalSeparator; // ensure decimal separator
  end;
begin
  inherited Create(FileName);
  InitLib(Self.Owner);
  FBodyColor:=clWhite;
  FFirstPage:=True;
  FPageLength:=2500;
  //  FNextPicnum:=0;
  FPDFConcatenating:=False;
  //  FReportnum:=0;
  FLeftMargin:=0;
  FTopMargin:=0;
  FPDFCompressionOn:=True; //compression is on by default because of TQRPDFFilter
  FFontHandling:=fhNoEmbedding;
  SetDocumentInfo('QuickReports', '', '', '');
  BGHFactor := 1.0;
end;

procedure TQRPDFDocumentFilter.SetTextOnTop(bVal: Boolean);

  Procedure SetTextFirst(bVal: Boolean);
  begin
    FTextFirst:=bVal;
  end;
begin
  SetTextFirst(not bVal);
end;

procedure TQRPDFDocumentFilter.SetMargins(TopMarg, Leftmarg: Integer);
begin
  FTopMargin:=TopMarg;
  FLeftMargin:=Leftmarg;
end;

// QBSS : override method
procedure TQRPDFDocumentFilter.ProcessPage;
begin
  FPageProcessed:=True;
  StorePage;
end;

// Overridden Start
procedure TQRPDFDocumentFilter.Start(PaperWidth, PaperHeight: Integer; Font: TFont);
{var
  MMperpixelX,
  MMperpixelY,
  TM: Extended;}
begin
  inherited Start(PaperWidth, PaperHeight, Font); // sets active true
{$ifndef DOCSTREAM}
  CreateStream( Filename);
{$endif}
end;

// overridden Finish
procedure TQRPDFDocumentFilter.Finish;
var
  CurrObject: Longint;
  DocStream: TStream;
  DocStreamLen: Longint;
  AnsiEnc: TEncoding;
  iCodepage : integer;

  procedure SaveOffset;
  begin
    FPDF.XRefBytes.Add(Format('%-10.10d', [DocStreamLen]));
  end;
 /// TIBURON *******************************
  procedure WriteStrNoCRLF(S: string);
  var
    Len: Integer;
  begin
    Len := Length(S);
    if Len>0 then
    begin
      finaldoc.Add(S);
      //Inc(DocStreamLen, Len);
      Inc(DocStreamLen, Len + 2);
    end;
  end;

  procedure WriteStr(S: string);
  begin
    WriteStrNoCRLF(S);
  end;

  procedure WriteByte(ob: Byte);
  var
    B: Integer;
  begin
    B:=ob;
    DocStream.WriteBuffer(B, 1);
    Inc(DocStreamLen);
  end;

  procedure MakeXRef;
  var
    K,
    ByteCount: Longint;
  begin
    ByteCount:=DocStreamLen;
    WriteStr('xref');
    WriteStr(Format('0 %d', [FPDF.XRefBytes.Count+1]));
    WriteStr('0000000000 65535 f');
    for K := 0 to FPDF.XRefBytes.Count-1 do WriteStr(FPDF.XRefBytes[K]+' 00000 n');
    // trailer
    WriteStr('trailer');
    WriteStr('<<');
    WriteStr(Format('/Size %d', [FPDF.XRefBytes.Count+1]));
    WriteStr('/Root 1 0 R');
    WriteStr(Format('/Info %d 0 R', [FPDF.XRefBytes.Count-1]));
    WriteStr('>>');
    WriteStr('startxref');
    WriteStr(Format('%d', [ByteCount]));
    WriteStr('%%EOF');
  end;

  procedure MakeTTFont(const FontName: string; const idxFReportFonts: Integer);
  type
    TTFontrec = record
      FirstChar, LastChar, CapHeight, ItalicA, StemV, StemH, XHeight: Integer;
      Flags, NumMetrics, MapMode: Integer;
      Ascent, Descent: Short;
      FileLength: DWORD;
      BBox: array [0..3] of Integer;
      Metrics: array of Integer;
    end;
  var
    PDFFont: TTFontrec;
    K: Integer;
    MStr,
    PDFFontName,
    LocalName,
    encoding: string;
    Buff: array of AnsiChar;

    procedure AnalyseTTFont(var encoding: string);
    const
      // TT font files
      TTFheader = 12;
      TABDIR = 16;
    var
      FSize,
      res,
      Offset,
      {$ifdef OTM}
      hmtxOff,
      {$endif}
      headOff,
      OS2Off: DWORD;
      CodePage: Word;
      K,
      ntabs,
      toff,
      tlen: Integer;
      widthstr: string;
      tabTag: AnsiString;
      charString: RawByteString;
      TmpImage: TImage;
      TmpCanvas: TCanvas;
      Found: Boolean;
      otmetric: OUTLINETEXTMETRIC;
      charCodes: array [0..255] of Word;
      wResult: Boolean;
      pOS2: ^ TOS2table;
      pHead: ^ THeadTable;
      {$define notOTM}
      {$ifdef OTM}
      procedure GetOTMMetrics(Buff: array of byte; Offset: DWORD);
        function QRcvtInt(Buf: array of byte; P: Integer) : Integer;
        var
           pp, bb : integer;
        begin
          pp := p+1;
          bb := (256*Buf[P]);
          Result:= (Buf[pp]) + bb;
        end;
      var
        K: Word;
      begin
        SetLength(PDFFont.Metrics, PDFFont.NumMetrics);
        // each element is a USHORT and a SHORT
        for K := 0 to PDFFont.NumMetrics-1 do
        begin
          PDFFont.Metrics[K]:=qrcvtInt(Buff, Offset+(K*4));
          //TTFtestfrm.memo1.lines.add( inttostr( metrics[k]));
        end;
      end;
      {$endif}
      procedure GetNonOTMMetrics;
      {CH type
        TABCWidths = array [0..66000] of TABC; }
        var
        K: Integer;
        widlist: TStringList;
        {$define CW32}
        {$ifdef CW32}
        Widths: array [0..66000] of Integer;
        {$else}
        ABCWidths: ^ TABCWidths;
        Buf: string;
        {$endif}

        // only suitable for numbers because of the Trims
        procedure SplitString(ss: string; sep: Char; var AList: TStringList);
        var
          defstr: string;
        begin
          AList.Clear;
          repeat
            defstr:=Trim(sParam(ss, sep));
            if defstr<>'' then AList.Add(defstr);
          until ss='';
        end;
      begin
        PDFFont.FirstChar:=0;
         //// override the lastchar of 65553 !
        PDFFont.LastChar := 255;
        PDFFont.NumMetrics:=PDFFont.LastChar-PDFFont.FirstChar+1;
        // custom widths
        widthstr := FCustomWidths.Value(PDFFontName);
        if widthstr<>'' then
        begin
          widlist:=TStringList.Create;
          try
            SplitString(widthstr, ' ', widlist);
            if widlist.Count<256 then
            begin
              raise ERangeError.CreateFmt('Not enough Custom widths (%d < 256) for font "%s"  ', [widlist.Count,
                                          FReportFonts[idxFReportFonts]]);
            end;
            SetLength(PDFFont.Metrics, PDFFont.NumMetrics);
            for K := 0 to PDFFont.NumMetrics-1 do
                   if K<widlist.Count then PDFFont.Metrics[K]:=StrToInt(widlist[K]);
          finally
            widlist.Free;
          end;
        end
        else
        begin
         {$ifdef CW32}
           //GetCharWidth32 is unsupported in Win9X according to Microsoft!!! Tough
          // -jb 19.01.2012
          // fix font size error
          // in unicode code must be used ansi version of GetCharWidth32
          // because first and last char must be defined by different way.
          // this is only functionality fix
          wResult:=GetCharWidth32A(TmpCanvas.Handle, PDFFont.FirstChar, PDFFont.LastChar, Widths);
          if not wResult then
          begin
            raise ERangeError.CreateFmt('Font widths for "%s" not obtainable (%s)', [FontName, SysErrorMessage(GetLastError)]);
          end;
          SetLength(PDFFont.Metrics, PDFFont.NumMetrics);
          for K := 0 to PDFFont.NumMetrics-1 do PDFFont.Metrics[K]:=Widths[K];
         {$else}
          SetLength(Buf, SizeOf(TABCWidths));
          ABCWidths:=@Buf[1];
          wResult:=GetCharABCWidths(TmpCanvas.Handle, PDFFont.FirstChar, PDFFont.LastChar, ABCWidths^);
          if not wResult then
          begin
            raise ERangeError.CreateFmt('Font widths for "%s" not obtainable (%s)', [FontName, SysErrorMessage(GetLastError)]);
          end;
          SetLength(PDFFont.Metrics, 256);
          for K := 0 to 255 do with ABCWidths^[K] do PDFFont.Metrics[K]:=abcA+Integer(abcB)+abcC;
         {$endif}
        end;
      end;

      procedure SetEncoding;
      var
        encodestr: string;
        I,
        K: Integer;
      begin
        // custom encoding
        //encodestr := CZECH_ENC;
        encodestr:=FCustomEncodings.Value(PDFFontName);
        if encodestr<>'' then
        begin
          encoding:=' <</Type/Encoding /Differences [ '+encodestr+' ]>>';
          Exit;
        end;
        // get the encoding string
        case TmpCanvas.Font.Charset of
               BALTIC_CHARSET: CodePage:=1257;
          CHINESEBIG5_CHARSET: CodePage:=950;
           EASTEUROPE_CHARSET: CodePage:=1250;
               GB2312_CHARSET: CodePage:=936;
                GREEK_CHARSET: CodePage:=1253;
                  OEM_CHARSET: CodePage:=CP_OEMCP;
              RUSSIAN_CHARSET: CodePage:=1251;
             SHIFTJIS_CHARSET: CodePage:=932;
              TURKISH_CHARSET: CodePage:=1254;
               HEBREW_CHARSET: CodePage:=1255;
               ARABIC_CHARSET: CodePage:=1256;
                 THAI_CHARSET: CodePage:=874;
           VIETNAMESE_CHARSET: CodePage:=1258;
        else
            CodePage:=1252;
        end;
        charString:='';
        System.SetCodePage(charString, CodePage, False);
        for I := 1 to 255 do charString:= charString + AnsiChar(Chr(I));  // TF
        K:=MultiByteToWideChar(CodePage, 0, PansiChar(charString), 255, @charCodes, 255);
        if K<>0 then
        begin
          encoding:=' <</Type/Encoding /Differences [ '+IntToStr(PDFFont.FirstChar+2)+' ';
          for I := 1 to 254 do // loop in charcodes ***** was 255 but getting one too many ????
          begin
            if I<PDFFont.FirstChar then Continue;
            Found:=False;
            for K := 0 to High(UniGlyphs) do
            begin
              if charCodes[I]=UniGlyphs[K].ID then
              begin
                encoding:=encoding+'/'+UniGlyphs[K].Name;
                Found:=True;
                Break;
              end;
            end;
            if not Found then
            begin
                encoding:=encoding+'/space'
            {
              if charCodes[I]<256 then
                encoding:=encoding+'/space'
              else
                encoding := encoding + '/uni' + WordToHex(charCodes[I]);
                }
            end;
          end;
          encoding:=encoding+']';
        end
        else
        begin
          encoding:=encoding+'/BaseEncoding /WinAnsiEncoding';
        end;
        encoding:=encoding+'>>';
      end;

      procedure SetPboxFont;
      var
        S,
        S2: string;
      begin
        S2:=FReportFonts[idxFReportFonts];
        S:=sParam(S2, TAB);
        TmpCanvas.Font.Name:=S;
        TmpCanvas.Font.Style:=[];
        S:=sParam(S2, TAB);
        if Pos('B', S)>0 then TmpCanvas.Font.Style:=TmpCanvas.Font.Style+[fsBold];
        if Pos('I', S)>0 then TmpCanvas.Font.Style:=TmpCanvas.Font.Style+[fsItalic];
        S:=sParam(S2, TAB);
        TmpCanvas.Font.Charset:=StrToInt(S);
        PDFFontName:=sParam(S2, TAB);
        PDFFont.Ascent:=TmpCanvas.Font.Height;
        TmpCanvas.Font.Height:=-1024;
        PDFFont.MapMode:=GetMapMode(TmpCanvas.Handle);
      end;

    var
      P: Integer;
    begin
      TmpImage:=TImage.Create(nil);
      TmpCanvas:=TmpImage.Canvas;
      try
        headOff:=0;
        {$ifdef OTM}
        hmtxOff:=0;
        {$endif}
        OS2Off:=0;
        FSize:=0;
        SetPboxFont;
        res:=GetFontData(TmpCanvas.Handle, 0, 0, nil, FSize);
        if res=GDI_ERROR then raise EQRError.Create('GetFontData error');
        FSize:=res;
        PDFFont.FileLength:=res;
        SetLength(Buff, FSize);
        res:=GetFontData(TmpCanvas.Handle, 0, 0, Buff, FSize);
        if res=GDI_ERROR then
          raise EQRError.Create('GetFontData error');

        P := 4;
        ntabs:= 256*Byte(Buff[P])+Byte(Buff[P+1]);//cvtInt(Buff, 4);
        for K := 0 to ntabs-1 do
        begin
          Offset:=(K*TABDIR)+TTFheader;
          // four 4-byte fields
          tabTag:=Buff[Offset]+Buff[Offset+1]+Buff[Offset+2]+Buff[Offset+ 3];
          P := Offset+8;
          toff:=256*256*256*Byte(Buff[P])+256*256*Byte(Buff[P+1])+256*Byte(Buff[P+2])+Byte(Buff[P+3]);//cvtDWord(Buff, Offset+8);
          P := Offset+12;
          tlen:=256*256*256*Byte(Buff[P])+256*256*Byte(Buff[P+1])+256*Byte(Buff[P+2])+Byte(Buff[P+3]);//cvtDWord(Buff, Offset+12);
          {$ifdef OTM}
          if tabTag='hmtx' then hmtxOff:=toff;
          {$endif}
          if tabTag='OS/2' then OS2Off:=toff;
          if tabTag='head' then headOff:=toff;
          if tabTag='hhea' then
          begin
            // get num metrics, Ascender, Descender.
            P := toff+tlen-2;
            PDFFont.NumMetrics:=256*Byte(Buff[P])+Byte(Buff[P+1]);//cvtInt(Buff, toff+tlen-2);
          end;
        end;
        GetOutlineTextMetrics(TmpCanvas.Handle, SizeOf(otmetric), @otmetric);
        PDFFont.FirstChar:=Ord(otmetric.otmTextMetrics.tmFirstChar);
        PDFFont.LastChar:=Ord(otmetric.otmTextMetrics.tmLastChar);
        PDFFont.Ascent:=otmetric.otmAscent;
        PDFFont.Descent:=otmetric.otmDescent;
        PDFFont.ItalicA:=otmetric.otmItalicAngle;
        {$ifdef OTM}
        SetLength(fontrec.metrics, fontrec.NumMetrics);
        GetOTMMetrics( buff, hmtxOff);
        {$else}
        GetNonOTMMetrics;
        {$endif}
        pOS2:=@Buff[OS2Off];
        case Byte(pOS2^.sFamilyClass) of

              //non-symbolic,sans serif
              8: PDFFont.Flags:=$20;

              //non-symbolic,scripted
              10: PDFFont.Flags:=$28;

              //symbolic
              12: PDFFont.Flags:=$4;

              //no classification: forcing to symbolic (Wingdings,WebDings)
              0: PDFFont.Flags:=$4;
        else PDFFont.Flags:=$22; //default: non-symbolic, serif
        end;
        pHead:=@Buff[headOff];
        PDFFont.BBox[0]:=swap(pHead^.xMin);
        PDFFont.BBox[1]:=swap(pHead^.yMin);
        PDFFont.BBox[2]:=swap(pHead^.XMax);
        PDFFont.BBox[3]:=swap(pHead^.yMax);
        SetEncoding;
      finally
        TmpImage.Free;
      end;
    end;
  begin
    encoding:='';
    AnalyseTTFont(encoding);
    WriteStr(Trim(Format('%d 0 obj', [CurrObject])));
    WriteStr('<<');
    WriteStr('/Type /Font');
    WriteStr('/Subtype /TrueType');
    LocalName:=Trim(Format('F%-2.2d', [idxFReportFonts]));
    WriteStr(Trim(Format('/Name /F%-2.2d', [idxFReportFonts])));
    WriteStr('/BaseFont /'+PDFFontName);
    WriteStr('/FirstChar '+IntToStr(PDFFont.FirstChar));
    WriteStr('/LastChar '+IntToStr(PDFFont.LastChar));
    // output the width array
    WriteStr('/Widths [ ');
    MStr:='';
    for K := 0 to High(PDFFont.Metrics) do MStr:=MStr+Format('%-d ', [PDFFont.Metrics[K]]);
    WriteStr(MStr+' ]');
    WriteStr('/Encoding '+encoding);
    WriteStr('/FontDescriptor '+IntToStr(CurrObject+1)+' 0 R');
    WriteStr('>>');
    WriteStr('endobj');
    SaveOffset;
    Inc(CurrObject);
    WriteStr(Trim(Format('%d 0 obj', [CurrObject])));
    WriteStr('<<');
    WriteStr('/Type /FontDescriptor');
    WriteStr('/Ascent '+IntToStr(PDFFont.Ascent));
    WriteStr('/Descent '+IntToStr(PDFFont.Descent));
    WriteStr('/Flags '+IntToStr(PDFFont.Flags));
    WriteStr(Format('/FontBBox [ %-d %-d %-d %-d ]', [PDFFont.BBox[0], PDFFont.BBox[1], PDFFont.BBox[
                    2], PDFFont.BBox[3]]));
    WriteStr('/FontName /'+LocalName);
    WriteStr('/ItalicAngle '+IntToStr(PDFFont.ItalicA));
    //CapHeight and StemV would be required fields!
    //WriteStr( '/CapHeight 700' );
    //WriteStr( '/StemV ' + inttostr(fontrec.descent) );
    if (FEmbedfonts.indexof(PDFFontName ) > -1) or (FFonthandling = fhAutoembed) then
    begin
      WriteStr('/FontFile2 '+IntToStr(CurrObject+1)+' 0 R');
    end;
    WriteStr('>>');
    WriteStr('endobj');
    SaveOffset;
    Inc(CurrObject);
    if (FEmbedfonts.indexof(PDFFontName ) > -1) or (FFonthandling = fhAutoembed) then
    begin
      // now the actual font file
      WriteStr(Trim(Format('%d 0 obj', [CurrObject])));
      WriteStr('<<');
      WriteStr('/Length '+IntToStr(CurrObject+1)+' 0 R /Length1 '+IntToStr(CurrObject+1)+' 0 R ');
      // compressing font file
      WriteStr('>>');
      WriteStr('stream');
      MStr:='';
      for K := 0 to PDFFont.FileLength-1 do
        WriteByte(Byte(Buff[K]));
      WriteStr(CRLF+'endstream');
      WriteStr('endobj');
      SaveOffset;
      Inc(CurrObject);
      WriteStr(Trim(Format('%d 0 obj', [CurrObject])));
      WriteStr('   '+IntToStr(PDFFont.FileLength));
      WriteStr('endobj');
      SaveOffset;
      Inc(CurrObject);
    end;
  end;

  procedure MakeResourceDict;
  var
    K,
    foff,
    numfontobjs: Integer;
    FontName: string;
  begin
    WriteStr('/Resources << ');
    WriteStr('/Font << ');
    foff:=0;
    numfontobjs:=0;
    for K := 0 to FReportFonts.Count-1 do begin
      WriteStr(Format('  /F%-2.2d %d 0 R ', [K, foff+4+(2*FPageNumber)]));
      FontName:=FReportFonts[K];
      FontName:=sParam(FontName, TAB);
      Inc(foff); //a Font object always will be added
      Inc(numfontobjs);
      // all are ttf fonts unless it's fhSubstitute
      if (FEmbedFonts.IndexOf(FontName)>=0) or (FFontHandling=fhAutoEmbed) then
      begin
          Inc(foff, 3); //FontDescriptor, Font data and its length
          Inc(numfontobjs, 3);
      end
      else if (FFontHandling=fhNoEmbedding) or (FFontHandling=fhSubstitute) then
      begin
          Inc(foff); //FontDescriptor only, no embedding
          Inc(numfontobjs);
      end;
    end;
    WriteStr('  >>');
    WriteStr(Format('/ProcSet %d 0 R', [5+(2*FPageNumber)+numfontobjs]));
    WriteStr('>>');
  end;

  function MapFontName(idxFReportFonts: Integer) : string;
  var
    I: Integer;
    WinName,
    S: string;
    IsBold,
    IsItalic,
    Found: Boolean;

    function PreDefined : Boolean;
    var
      I: Integer;
    begin
      Result:=False;
      for I := 0 to High(BaseFamilies) do if AnsiSameText(BaseFamilies[I], WinName) then begin
        WinName:=BaseFamilies[I];
        Result:=True;
        Break;
      end;
    end;

    function ExpandFull(sBold, sItalic: string) : string;
    begin
      Result:=WinName;
      if IsBold or IsItalic then Result:=Result+'-';
      if IsBold then Result:=Result+sBold;
      if IsItalic then Result:=Result+sItalic;
    end;
  begin
    S:=FReportFonts[idxFReportFonts];
    WinName:=sParam(S, TAB);
    S:=sParam(S, TAB);
    IsBold:=Pos('B', S)>0;
    IsItalic:=Pos('I', S)>0;
    // Is it mapped ?
    Found:=False;
    for I := 0 to FSubstitutedFonts.Count-1 do begin
      S:=FSubstitutedFonts[I];
      if AnsiPos(AnsiLowerCase(WinName), AnsiLowerCase(S))=1 then begin
        sParam(S, cFontMapSeparator);
        if S='' then S:=cCourier; // if bad mapping -> Courier
        //deleting possible font style from substitution
        WinName:=sParam(S, '-');
        if not PreDefined then WinName:=cCourier;
        Found:=True;
        Break;
      end;
    end;
    if not Found then begin
      //Must be substituted to a font,
      //even when not listed in FSubstitutedFonts
      WinName:=cCourier;
    end;
    // now amend the name to the full name
    if (WinName=cHelvetica) or (WinName=cCourier) then begin
      Result:=ExpandFull('Bold', 'Oblique');
    end else begin
      Result:=ExpandFull('Bold', 'Italic');
    end;
  end;

  procedure RemoveTrailingCRLF( var SS : string);
  begin
       if length(SS) > 1 then
           if (SS[length(SS)-1]=chr($0A)) or (SS[length(SS)-1]=chr($0D)) then
           begin
              SS := copy(SS, 1, length(SS)-2);
           end;
  end;

  procedure FinishDoc(FOutFile: string);
  var
    J,
    K: Integer;
    FontName,
    kidstring,
    S, Stext, Sgraphics: string;
    StreamLen: Longint;
  begin
    FinishPage;
    DocStreamLen:=0;
    //DocStream:=FStream;
    try
      // Root catalog
      WriteStr('%PDF-1.3'); // possible acrobat 7 bug fix.
      // length is returning 1, not 5. so add directly
      S := '%'+Chr(197)+Chr(173)+Chr(111)+Chr(129);
      finaldoc.Add(S);
      Inc(DocStreamLen, 7); // 2 more for the cr/lf in the stringlist

      //header and a binary comment what is recommended by specification
      SaveOffset;
      WriteStr('1 0 obj');
      WriteStr('<<');
      WriteStr('/Type /Catalog');
      WriteStr('/Pages 3 0 R');
      WriteStr('/Outlines 2 0 R');
      WriteStr('/ViewerPreferences << /HideToolbar false /FitWindow true >>');
      WriteStr('>>');
      WriteStr('endobj');
      // empty outlines ( for the moment )
      SaveOffset;
      WriteStr('2 0 obj');
      WriteStr('<<');
      WriteStr('/Type /Outlines');
      WriteStr('/Count 0');
      WriteStr('>>');
      WriteStr('endobj');
      // Pages object
      SaveOffset;
      WriteStr('3 0 obj');
      WriteStr('<<');
      WriteStr('/Type /Pages');
      WriteStr(Format('/Count %d', [FPageNumber]));
      kidstring:='/Kids [';
      for K := 0 to FPDF.pagetextfiles.Count-1 do
                 kidstring:=kidstring+Format('%d 0 R ', [4+( 2*K)]);
      kidstring:=Trim(kidstring)+']';
      WriteStr(kidstring);
      // global stuff inherited by page objs
      WriteStr(Format('/MediaBox [0 0 %d %d]', [trunc(FPDF.pages[0].PageWidth), trunc(FPDF.pages[
                                0].PageHeight)]));
      MakeResourceDict;
      WriteStr('>>');
      WriteStr('endobj');
      CurrObject:=3;
      SaveOffset;
      for J := 0 to FPDF.pagetextfiles.Count-1 do
      begin
        //StreamLen:=StrToInt(FPDF.textlengths[J])+StrToInt(FPDF.graphicslengths[J])+4;
        Stext := TStringList(FPDF.pagetextfiles.Objects[J]).Text;
        RemoveTrailingCRLF(Stext);
        StreamLen := length(Stext);
        Sgraphics := TStringList(FPDF.pagegraphicsfiles.Objects[J]).Text;
        RemoveTrailingCRLF(Sgraphics);
        StreamLen := Streamlen + length(Sgraphics) + 8;

        WriteStr(Trim(Format('%d 0 obj', [CurrObject+1])));
        WriteStr('<<');
        WriteStr('/Type /Page');
        WriteStr('/Parent 3 0 R');
        WriteStr(Format('/Contents %d 0 R', [CurrObject+2]));
        WriteStr(Format('/MediaBox [0 0 %d %d]', [trunc(FPDF.pages[J].PageWidth), trunc(FPDF.pages[J].PageHeight)]));
        WriteStr('>>');
        WriteStr('endobj');
        // Page contents object
        SaveOffset;
        WriteStr(Trim(Format('%d 0 obj', [CurrObject+2])));
        WriteStr(Format('<< /Length %d >>', [StreamLen]));
        WriteStr('stream');
        // optional order of printing.
       if FTextFirst then
       begin
          WriteStr('BT');
          WriteStrNoCRLF(Stext);
          WriteStrNoCRLF(Sgraphics);
        end
        else
        begin
          // graphics first
          WriteStrNoCRLF(Sgraphics);
          WriteStr('BT');
          WriteStrNoCRLF(Stext);
        end;
        WriteStr('endstream');
        WriteStr('endobj');
        Inc(CurrObject, 2);
        SaveOffset;
      end;
      CurrObject:=4+(2*FPageNumber);
      for K := 0 to FReportFonts.Count-1 do
      begin
        S:=FReportFonts[K];
        FontName:=sParam(S, TAB);
        if (FFonthandling <> fhSubstitute) then
        begin
           MakeTTFont(FontName, K);
        end
        else
        begin //substituting
          FontName:=MapFontName(K);
          WriteStr(Trim(Format('%d 0 obj', [CurrObject])));
          WriteStr('<<');
          WriteStr('/Type /Font');
          WriteStr('/Subtype /Type1');
          WriteStr(Trim(Format('/Name /F%-2.2d', [K])));
          WriteStr('/BaseFont /'+FontName);
          WriteStr('/Encoding /WinAnsiEncoding');
          WriteStr('>>');
          WriteStr('endobj');
          Inc(CurrObject);
          SaveOffset;
        end;
      end;
      // add an object with the doc properties
      WriteStr(Format('%d 0 obj', [CurrObject]));
      WriteStr('<<');
      if not PDFSuppressDateTime then
          WriteStr('/CreationDate ('+DateTimeToStr(Now)+')');
      WriteStr('/Producer (QuickReports PDF Export)');
      WriteStr('/Subject ('+FDocSubject+' )');
      WriteStr('/Creator ('+FDocCreator+')');
      WriteStr('/Title ('+FDocTitle+')');
      WriteStr('/Author ('+FDocAuthor+')');
      WriteStr('>>');
      WriteStr('endobj');
      Inc(CurrObject);
      SaveOffset;
      WriteStr(Format('%d 0 obj', [CurrObject]));
      WriteStr('[/PDF /Text]');
      WriteStr('endobj');
      Inc(CurrObject);
      MakeXRef;
    finally
{$ifndef DOCSTREAM}
      if freestream then CloseStream;
{$endif}
    end;
  end;
begin
  if FPDFConcatenating then Exit;
  // process the list of textitems and graphic items
  if not FMadeFirstPageFiles then StartPage;
  // TIBURON
  FinishDoc(FileName);

  if not TryStrToInt(Trim(PDFCodepage), iCodepage) then
    iCodepage := 1252;

  AnsiEnc := TMBCSEncoding.Create(iCodepage, 0, 0);
  try
    if filename <> '' then
      finaldoc.SaveToFile(filename, AnsiEnc)
    else
      finaldoc.SaveToStream(FStream, AnsiEnc);
  finally
    AnsiEnc.Free;
  end;
  inherited; // sets active false
end;

procedure TQRPDFDocumentFilter.EndConcat;
begin
  FPDFConcatenating:=False;
  Finish;
end;

procedure TQRPDFDocumentFilter.StorePage;
begin
  // do nothing.
end;

procedure InitPDFItem(var I: TPDFItemRec);
begin
  I.ItemType:=IT_INVALID;
  I.XPos:=0;
  I.YPos:=0;
end;

// add a text item to the list
procedure TQRPDFDocumentFilter.TextOut(X, Y: Extended; Font: TFont; bgColor: TColor; Alignment: TAlignment;
                                       Text: string);
var
  xp,
  yp,
  TextSize: Integer;
  TextHeight: Integer;
  parentrep: TQuickRep;
  tmap: TBitmap;
  PDFItem: TPDFItemRec;
  screenYFactor, resfactor : extended;
  underline : TQRShape;
  penwidth : Extended;

begin
  if not FMadeFirstPageFiles then
                           StartPage;
  InitPDFItem(PDFItem);
  tmap:=TBitmap.Create;
  screenYFactor := forms.Screen.PixelsPerInch / 254;
  resfactor := TQuickRep(Self.Owner).QRPrinter.xfactor/screenYFactor;
  try
    // make a pdf textitem
    PDFItem.ItemType:=IT_TEXT;
    parentrep:=TQuickRep(Self.Owner);
    // text pos is in 1/10 mm
    // map the same as graphic elements
    xp:=parentrep.QRPrinter.XPos(X);
    yp:=parentrep.QRPrinter.YPos(Y);
    tmap.Canvas.Font.Assign(Font);
    TextSize:=tmap.Canvas.TextWidth(Text);
    textsize := trunc(textsize*resfactor);
    //Alignment - recalculate positions
    case Alignment of
       taLeftJustify: begin
                        // do nothing
                      end;
      taRightJustify: begin
                        // the xpos is the right of the text pos
                        xp:=xp-TextSize;
                      end;
            taCenter: begin
                        // the xpos is the center of the text pos
                        xp:=xp-(TextSize div 2);
                      end;
    end;
    // underline and Strikeout
    if (fsUnderline in Font.Style) or (fsStrikeout in Font.Style) then
    begin
        underline := TQRShape.create(parentrep);
        underline.shape := qrsHorLine;
        underline.left := xp;
        TextHeight := tmap.Canvas.TextHeight(Text);
        underline.Top := yp;
        underline.Width := trunc(TextSize*1.05);
        underline.Height := 2;
        penwidth := font.Size div 12;
        if penwidth< 1 then penwidth := 1;
        underline.pen.Width := trunc(penwidth);
        underline.pen.color := font.color;
        if fsUnderline in Font.Style then
             AcceptGraphic(xp, yp + TextHeight, underline)
        else
             AcceptGraphic(xp, yp + (TextHeight div 2 ), underline);
    end;
    PDFItem.XPos:=xp*PointsPerPixelX;
    PDFItem.YPos:=yp*PointsPerPixelY+Font.Size;
    // replace euro symbol
    PDFItem.FText:=Text;
    PDFItem.FontName:=Font.Name;
    PDFItem.FontCharset:=Font.Charset;
    PDFItem.FontSize:=Font.Size;
    Color2RGB(Font.Color, PDFItem.RGBFColor);
    PDFItem.fbold:=fsBold in Font.Style;
    PDFItem.fItalic:=fsItalic in Font.Style;
    AddPDFItem(PDFItem);
  finally
    tmap.Free;
  end;
end;

procedure TQRPDFDocumentFilter.AcceptGraphic(Xoff, Yoff: Extended; GControl: TControl);
var
  conwidth,
  conheight,
  coffset: Integer;
  logX : integer;
  isHires : boolean;
  tempmap: TBitmap;
  PShCont: TQRPDFShape;
  ShCont: TQRShape;
  QRDBCont: TQRDBImage;
  HCont: TQRHRule;
  DrawPict: TPicture;
  AspectRatio: Double;
  dbcont: TQRGrDBImage;
  PDFItem: TPDFItemRec;
  screenYFactor : extended;
  resfactor : extended;

  // compression and UTF85 filters must be applied here ...
  procedure CaptureImageBytes(srcmap: TBitmap);
  const
    BufSize = 30000;
  var
    K,
    J: Longint;
    PColor: TColor;
    RGBColor: ^ TRGBColor;
    Str1,
    Str2: TMemoryStream;
    bbuff: array [0..BufSize] of Byte;
    BP: Integer;
    //OutBuff: string;
    xdim,
    ydim: Longint;
    //psrc : PInt;
 begin
    xdim:=srcmap.Width;
    ydim:=srcmap.Height;
    Str1:=TMemoryStream.Create;
    Str2:=TMemoryStream.Create;

    BP:=0;
    RGBColor:=@PColor;
 {.$define SCANLINES}
 {$ifndef SCANLINES}
    for J := 0 to ydim-1 do begin
         for K := 0 to xdim-1 do begin
           PColor:=srcmap.Canvas.Pixels[K, J];
           bbuff[BP]:=RGBColor^.Red;
           bbuff[BP+1]:=RGBColor^.Green;
           bbuff[BP+2]:=RGBColor^.Blue;
           Inc(BP, 3);
           if BP>=BufSize then begin
             Str1.WriteBuffer(bbuff, BP);
             BP:=0;
           end;
         end;
    end;
{$else}
   for J := 0 to ydim - 1 do
   begin
         pSrc  := srcmap.ScanLine[ J ];
         for K := 0 to xdim - 1 do
         begin
              PColor := TColor(pSrc^);
              Inc( pSrc );
              bbuff[BP]:=RGBColor^.Red;
              bbuff[BP+1]:=RGBColor^.Green;
              bbuff[BP+2]:=RGBColor^.Blue;
              Inc(BP, 3);
              if BP>=BufSize then begin
                 Str1.WriteBuffer(bbuff, BP);
                 BP:=0;
              end;
         end;
   end;
{$endif}
    if BP>0 then Str1.WriteBuffer(bbuff, BP);
    if CompressionOn then
    begin
      str2.Clear;
      //pdfitem.xscale := str1.Size;
      LZWEncode(Str1, Str2);
      //pdfitem.xscale := str2.Size;
      str1.Clear;
      Ascii85EncodeFilter(Str2, Str1);
      PDFItem.ImageFilter:='/ASCII85Decode /LZWDecode';
      PDFItem.imgstr := str1;
      //pdfitem.xscale := str1.Size;
      Str2.Free;
    end
    else
    begin
        {
        AsciiHexEncodeFilter(str1, str2);
        PDFItem.ImageFilter:='/ASCIIHexDecode ';
        }
        Ascii85EncodeFilter(Str1, Str2);
        PDFItem.ImageFilter:='/ASCII85Decode';
        PDFItem.imgstr := str2;
        Str1.Free;
   end;
    //    Inc(FNextPicnum);
  end;
begin
  if not FMadeFirstPageFiles then
                           StartPage;
  InitPDFItem(PDFItem);
  tempmap:=TBitmap.Create;
  DrawPict:=TPicture.Create;
  PDFItem.xscale:=1.0;
  PDFItem.yscale:=1.0;
  // resfactor is the ratio of the screen res to the printer res.
  screenYFactor := forms.Screen.PixelsPerInch / 254;
  resfactor := TQuickRep(Self.Owner).QRPrinter.xfactor/screenYFactor;
  try
    if (GControl is TQRHRule) then begin
      HCont:=(GControl as TQRHRule);
      PDFItem.ItemType:=IT_GRAPHIC;
      PDFItem.Shape:=S_HLINE;
      PDFItem.XPos:=Xoff*PointsPerPixelX;
      PDFItem.YPos:=Yoff*PointsPerPixelY;
      PDFItem.thickness:=HCont.Pen.Width*PointsPerPixelX;
      Color2RGB(HCont.Pen.Color, PDFItem.RGBStrokeColor);
      PDFItem.Width:=HCont.Width*PointsPerPixelX;
      PDFItem.Height:=HCont.Height*PointsPerPixelX;
      PDFItem.Filled:=False;
      PDFItem.FontName:='';
      PDFItem.FText:='';
      AddPDFItem(PDFItem);
      Exit;
    end;
    if (GControl is TQRPDFShape) then begin
      PShCont:=(GControl as TQRPDFShape);
      PDFItem.ItemType:=IT_GRAPHIC;
      case PShCont.shapetype of
           qrsRectangle: PDFItem.Shape:=S_BOX;
              qrsCircle: PDFItem.Shape:=S_CIRCLE;
            qrsVertLine: PDFItem.Shape:=S_VLINE;
             qrsHorLine: PDFItem.Shape:=S_HLINE;
        qrsTopAndBottom: PDFItem.Shape:=S_TOPBOTTOM;
        qrsRightAndLeft: PDFItem.Shape:=S_LEFTRIGHT;
        qrsRightDiagonal: PDFItem.Shape:=S_RIGHTDIAG;
        qrsLeftDiagonal: PDFItem.Shape:=S_LEFTDIAG;
      end;
      PDFItem.XPos:=Xoff*PointsPerPixelX;
      PDFItem.YPos:=Yoff*PointsPerPixelY;
      PDFItem.thickness:=PShCont.Pen.Width*PointsPerPixelX;
      Color2RGB(PShCont.Pen.Color, PDFItem.RGBStrokeColor);
      Color2RGB(PShCont.Brush.Color, PDFItem.RGBFColor);
      PDFItem.Width:=PShCont.Width*PointsPerPixelX*BGHFactor*resfactor;
      PDFItem.Height:=PShCont.Height*PointsPerPixelX*resfactor;
      PDFItem.Filled:=bsClear<>PShCont.Brush.Style;
      PDFItem.FontName:='';
      PDFItem.FText:='';
      AddPDFItem(PDFItem); //for brush
      if PShCont.Pen.Style<>psClear then begin
        //there must be a rectangle around
        PDFItem.Filled:=False;
        AddPDFItem(PDFItem);
      end;
      Exit;
    end;
    if (GControl is TQRShape) then
    begin
      ShCont:=(GControl as TQRShape);
      PDFItem.ItemType:=IT_GRAPHIC;
      PDFItem.Shape:=S_HLINE; // default ??
      case ShCont.Shape of
           qrsRectangle: PDFItem.Shape:=S_BOX;
              qrsCircle: PDFItem.Shape:=S_CIRCLE;
            qrsVertLine: PDFItem.Shape:=S_VLINE;
             qrsHorLine: PDFItem.Shape:=S_HLINE;
        qrsTopAndBottom: PDFItem.Shape:=S_TOPBOTTOM;
        qrsRightAndLeft: PDFItem.Shape:=S_LEFTRIGHT;
           qrsRoundrect: PDFItem.Shape:=S_OBLIQUE;
        qrsRightDiagonal: PDFItem.Shape:=S_RIGHTDIAG;
        qrsLeftDiagonal: PDFItem.Shape:=S_LEFTDIAG;
      end;
      PDFItem.XPos:=Xoff*PointsPerPixelX;
      PDFItem.YPos:=Yoff*PointsPerPixelY;
      PDFItem.thickness:= ShCont.Pen.Width*PointsPerPixelX;
      //if PDFItem.thickness<1.0 then PDFItem.thickness := 1.0;
      Color2RGB(ShCont.Pen.Color, PDFItem.RGBStrokeColor);
      Color2RGB(ShCont.Brush.Color, PDFItem.RGBFColor);
      PDFItem.Width:=ShCont.Width*PointsPerPixelX*BGHFactor*resfactor;
      PDFItem.Height:=ShCont.Height*PointsPerPixelX*resfactor;
      PDFItem.Filled:=bsClear<>ShCont.Brush.Style;
      PDFItem.FontName:='';
      PDFItem.FText:='';
      AddPDFItem(PDFItem); //for brush
      if ShCont.Pen.Style<>psClear then begin
        //there must be a rectangle around
        PDFItem.Filled:=False;
        AddPDFItem(PDFItem);
      end;
      Exit;
    end;
    //-------------------------------------------------------
    // It's a picture
    ishires := false;
    tempmap.Width:=GControl.Width;
    tempmap.Height:=GControl.Height;
    conwidth:=GControl.Width;
    conheight:=GControl.Height;
    PDFItem.xscale:=1.0;
    PDFItem.yscale:=1.0;
    if (GControl is TQRGrImage) then
    begin
      if not TQRGrImage(GControl).ClipImage
      then
        tempmap.Canvas.StretchDraw(Rect(0, 0, tempmap.Width, tempmap.Height), TQRGrImage(GControl).Picture.Graphic)
      else
      begin
        tempmap.Canvas.Draw(0, 0, TQRGrImage(GControl).Picture.Graphic)
      end;
      CaptureImageBytes(tempmap);
    end
    else if (GControl is TQRImage) then
    begin
      if TQRImage(GControl).Stretch then
      begin 
        if TQRImage(GControl).Tag = 999 then // try saving full res
        begin
             ishires := true;
             tempmap.Width := TQRImage(GControl).Picture.Graphic.Width;
             tempmap.Height := TQRImage(GControl).Picture.Graphic.Height;
             tempmap.Canvas.Draw(0, 0, TQRImage(GControl).Picture.Graphic);
             PDFItem.xscale := 1.0*TQRImage(GControl).Width/tempmap.Width;
             PDFItem.yscale := 1.0*TQRImage(GControl).Height/tempmap.Height;
        end
        else
           tempmap.Canvas.StretchDraw(Rect(0, 0, tempmap.Width, tempmap.Height), TQRImage(GControl).Picture.Graphic)
      end
      else
      begin
        if TQRImage(GControl).Tag = 12345 then // exported RTF is hi-res
        begin
             printer.BeginDoc;
             LogX := GetDeviceCaps(printer.Canvas.handle, LOGPIXELSX);
             printer.abort;
             PDFItem.xscale := 1.0*screen.PixelsPerInch/LogX;
             PDFItem.yscale := PDFItem.xscale;
             ishires := true;
             conheight := round(conheight * PDFItem.xscale);
             tempmap.Canvas.Draw(0, 0, TQRImage(GControl).Picture.Graphic)
        end
        else if TQRImage(GControl).Tag = 999 then // try saving full res
        begin
             ishires := true;
             tempmap.Width := TQRImage(GControl).Picture.Graphic.Width;
             tempmap.Height := TQRImage(GControl).Picture.Graphic.Height;
             tempmap.Canvas.Draw(0, 0, TQRImage(GControl).Picture.Graphic);
             PDFItem.xscale := 1.0*TQRImage(GControl).Width/tempmap.Width;
             PDFItem.yscale := 1.0*TQRImage(GControl).Height/tempmap.Height;
        end
        else // not an RTF or hires image
             tempmap.Canvas.Draw(0, 0, TQRImage(GControl).Picture.Graphic)
      end;
      CaptureImageBytes(tempmap);
    end
    else if (GControl is TQRDBImage) then
    begin
      QRDBCont:=GControl as TQRDBImage;
      if QRDBCont.Field=nil then Exit else
      begin
        DrawPict.Assign(QRDBCont.Field);
        //AspectRatio := 1.0 * drawpict.Width / drawpict.height;
        if not QRDBCont.Stretch then
        begin
          // the picture shrinks or grows to fit the control
          // this tiresome code is a mirror of that in the DBImage print
          if (DrawPict.Width/conwidth)<(DrawPict.Height/conheight) then
          begin
            // the height ratio is greater so shrink the width and center horiz
            coffset:=conwidth; // save the current width
            conwidth:=Round(DrawPict.Width/(DrawPict.Height/conheight));
            coffset:=(coffset-conwidth) div 2;
            Xoff:=Xoff+coffset;
          end
          else
          begin
            coffset:=conheight;
            conheight:=Round(DrawPict.Height/(DrawPict.Width/conwidth));
            coffset:=(coffset-conheight) div 2;
            Yoff:=Yoff+coffset;
          end;
        end;
        //--------
        if QRDBCont.Stretch then tempmap.Assign(QRDBCont.Field) else begin
          tempmap.Canvas.Draw(0, 0, DrawPict.Graphic);
        end;
        CaptureImageBytes(tempmap);
      end;
    end
    else if (GControl is TQRGrDBImage) then
    begin
      dbcont:=GControl as TQRGrDBImage;
      if dbcont.Field=nil then Exit
      else
      begin
        DrawPict.Assign(dbcont.Field);
        AspectRatio:=1.0*DrawPict.Width/DrawPict.Height;
        if not dbcont.Stretch then begin
          if dbcont.FitMode=fmInsideProp then begin
            // the picture shrinks or grows to fit the control
            // this tiresome code is a mirror of that in the DBImage print
            if (DrawPict.Width/conwidth)<(DrawPict.Height/conheight) then begin
              // the height ratio is greater so shrink the width and center horiz
              coffset:=conwidth; // save the current width
              conwidth:=Round(DrawPict.Width/(DrawPict.Height/conheight));
              coffset:=(coffset-conwidth) div 2;
              Xoff:=Xoff+coffset;
            end
            else
            begin
              coffset:=conheight;
              conheight:=Round(DrawPict.Height/(DrawPict.Width/conwidth));
              coffset:=(coffset-conheight) div 2;
              Yoff:=Yoff+coffset;
            end;
          end
          else
          if dbcont.FitMode=fmProportional then
          begin
            if (DrawPict.Width/conwidth)<(DrawPict.Height/conheight) then
              conheight:=trunc(conwidth/AspectRatio)
            else
              conwidth:=trunc(conheight*AspectRatio);
          end
          else
          if dbcont.FitMode=fmKeepWidth then
             conheight:=trunc(conwidth/AspectRatio)
          else if dbcont.FitMode =fmKeepHeight then
             conwidth:=trunc(conheight*AspectRatio);
        end;
        //--------
        if not dbcont.ClipImage then tempmap.Assign(dbcont.Field)
        else
        begin
          tempmap.Canvas.Draw(0, 0, DrawPict.Graphic);
        end;
        CaptureImageBytes(tempmap);
      end;
    end;
    if (tempmap.Width<1) or (tempmap.Height<1) then Exit; // through 'finally'
    PDFItem.ItemType:=IT_IMAGE;
    PDFItem.XPos:=Xoff*PointsPerPixelX;
    PDFItem.YPos:=((resFactor*conheight)+Yoff)*PointsPerPixelY;
    PDFItem.Width:=tempmap.Width*PointsPerPixelX;
    PDFItem.Height:=tempmap.Height*PointsPerPixelX;
    if not ishires then // for hires images
    begin
       PDFItem.xscale:=conwidth/tempmap.Width*resfactor;
       PDFItem.yscale:=conheight/tempmap.Height*resfactor;
    end;
    PDFItem.pixelWidth:=tempmap.Width;
    PDFItem.pixelHeight:=tempmap.Height;
    AddImageItem(PDFItem, nil);
  finally
    tempmap.Free;
    DrawPict.Free;
  end;
end;

procedure TQRPDFDocumentFilter.EndPage;
begin
  // do nothing
end;

// Override method
procedure TQRPDFDocumentFilter.NewPage;
var
  PDFItem: TPDFItemRec;
begin
  InitPDFItem(PDFItem);
  // add a newpage item
  if FFirstPage then begin
    FFirstPage:=False;
    Exit;
  end;
  PDFItem.ItemType:=IT_NEWPAGE;
  AddPDFItem(PDFItem);
end;

{$ifdef RLE}
procedure RunLengthEncodeFilter(sFrom, sTo: TMemoryStream);
// as defined in PDF specification
//   3.3.4 RunLengthDecode Filter
//   The RunLengthDecode filter decodes data that has been encoded in a simple
//   byte-oriented format based on run length. The encoded data is a sequence of
//   runs, where each run consists of a length byte followed by 1 to 128 bytes of data. If
//   the length byte is in the range 0 to 127, the following length + 1 (1 to 128) bytes
//   are copied literally during decompression. If length is in the range 129 to 255, the
//   following single byte is to be copied 257 - length (2 to 128) times during decompression.
//   A length value of 128 denotes EOD.
var
  C: Char;
  LastC,
  sDiff: string;
  Cnt: Integer;
  Counting: Boolean;

  procedure FlushDiff;
  begin
    if Length(sDiff)<>0 then
    begin
      sDiff:=Chr(Length(sDiff)-1)+sDiff;
      sTo.Write(sDiff[1], Length(sDiff));
    end;
    sDiff:='';
  end;

  procedure FlushSame;
  var
    S: string;
  begin
    if Cnt>0 then
    begin
      S:=Chr(257-Cnt)+LastC;
      sTo.Write(S[1], Length(S));
      sDiff:=C;
      LastC:=C;
    end;
    Counting:=False;
  end;
begin
  sTo.Position:=0;
  sTo.Size:=0;
  sFrom.Position:=0;
  sDiff:='';
  LastC:='';
  Counting:=False;
  while sFrom.Position<sFrom.Size do
  begin
    sFrom.Read(C, 1);
    if not Counting then
    begin
      sDiff:=sDiff+C;
      Cnt:=Length(sDiff);
      if (Length(sDiff)>2) and (sDiff[Cnt-1]=C) and (sDiff[Cnt-2]=C)
      then
      begin
        Counting:=True;
        SetLength(sDiff, Cnt-3);
        FlushDiff;
        Cnt:=3;
        LastC:=C;
      end;
      if Length(sDiff)>127 then FlushDiff;
    end
    else
    begin
      if C=LastC then
      begin
        Inc(Cnt);
        if Cnt>127 then
        begin
          FlushSame;
          sDiff:='';
        end;
      end
      else
      begin
        FlushSame;
        sDiff:=C;
      end;
    end;
  end;
  //flush remaining data
  if Counting then FlushSame else FlushDiff;
  sDiff:=Chr(128)+'>';
  sTo.Write(sDiff[1], 2);
end;
{$endif}

{ asciiHex fixed for unicode D2009 compatible}
function hx(B: Byte) : Char;
begin
  if B>9 then Result:=Chr(B+Ord('A')-10) else Result:=Chr(B+Ord('0'));
end;

function BToHex(B: Byte) : utf8String;
begin
    Result:= utf8String(hx(B shr 4)+hx(B and $f));
end;

procedure AsciiHexEncodeFilter(sFrom, sTo: TMemoryStream);
const
  REC_SIZE = 2048;
var
  CC: array [0..REC_SIZE] of Byte;
  WasRead: Integer;
  lineout: utf8String;
  I: Integer;
begin
  sTo.Position:=0;
  sTo.Size:=0;
  sFrom.Position:=0;
  WasRead:=sFrom.Read(CC, REC_SIZE);
  while (WasRead>0) do
  begin
    lineout:='';
    for I := 0 to WasRead-1 do
      lineout:=lineout+BToHex(CC[I]);
    sTo.Write(lineout[1], Length(lineout));
    WasRead:=sFrom.Read(CC, REC_SIZE);
  end;
  lineout:='>'; //EOD
  sTo.Write(lineout[1], Length(lineout));
end;

initialization
  PDFCodepage := IntToStr(DefaultSystemCodePage){'1252'}; //or GetACP()  --jb
end.
