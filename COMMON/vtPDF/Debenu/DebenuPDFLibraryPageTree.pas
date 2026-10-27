{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryPageTree.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryPageTree;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  Classes, DebenuPDFLibraryRenderer, DebenuPDFLibraryStructure, DebenuPDFLibraryImage,
  DebenuPDFLibraryFont, DebenuPDFLibraryPainter, DebenuPDFLibraryAnnots, DebenuPDFLibrarySmartAccess,
{$IFNDEF VER120}
  contnrs,
{$ENDIF}
{$IFNDEF QPL_CPP}
{$IFDEF QPL_DPLR}
  Vcl.Graphics, // TODO temporary solution
{$ENDIF}
{$ENDIF}
  DebenuPDFLibraryExtra, DebenuPDFLibraryExtractor, DebenuPDFLibraryFontRasterizer, DebenuPDFLibraryForm,
  DebenuPDFLibraryDigest, DebenuPDFLibraryTextFunnel, DebenuPDFLibraryPicasso, DebenuPDFLibraryPrinting,
  DebenuPDFLibraryPatterns, DebenuPDFLibraryImageList, DebenuPDFLibraryTextList;

type
  TPDFPageAccessEvent = procedure (Page: TPDFDictionary) of object;
  TPDFDecryptEvent = procedure (ObjNum, GenNum: Integer) of object;
  TPDFDeleteObjEvent = procedure (ObjNum, GenNum: Integer) of object;

  TPDFPageTree = class
  private
    PageObjNum: Integer;
    PageGenNum: Integer;

    DefaultPageWidth: Double;
    DefaultPageHeight: Double;

    FPagePointer: TPDFIndRef;
    FPagePointerArray: TPDFArray;
    FLayer: Integer;
    FStructure: TPDFStructure;
    FPagesDict: TPDFDictionary;
    FPage: Integer;
    FParentNode: TPDFDictionary;
    FPageDict: TPDFDictionary;
    FPageContent: array of TPDFStream;
    FPainter: TPDFPainter;
    FOnPageAccess: TPDFPageAccessEvent;
    FOnDecrypt: TPDFDecryptEvent;
    FOnDeleteObj: TPDFDeleteObjEvent;
    FCanDraw: Boolean;
    FImages: TObjectList;
    FImageLists: TObjectList;
    FTextLists: TObjectList;
    FIncludedFonts: TObjectList;
    FPageWidth: Double;
    FPageHeight: Double;
    FUserUnit: Double;
    FUseUnsafeLayers: Boolean;
    FAnnots: TPDFAnnots;

    LayersCombined: Boolean;
    GotPageWidth: Boolean;
    GotPageHeight: Boolean;

    FKnownPages: array of TPDFDictionary;
    FOnFindPage: TFindPageEvent;
    RenderFontCol: TPDFFontCollection;
    TextExtractFontCol: TPDFFontCollection;

    FRenderer: TPDFRenderer;
  protected
    function GetPageCount: Integer;
    procedure SetPage(NewPage: Integer);
    function GetPageWidth: Double;
    procedure SetPageWidth(NewPageWidth: Double);
    function GetPageHeight: Double;
    procedure SetPageHeight(NewPageHeight: Double);
    function GetUserUnit: Double;
    procedure SetUserUnit(Value: Double);
    function GetInheritedValue(Dict: TPDFDictionary; const Key: AnsiString): TPDFObject;
    function ResourcesDict: TPDFDictionary;
    procedure PainterChange(Sender: TObject);
    procedure GetDefaultPageSize;
    procedure ClonePage(SourcePage: Integer);
    function GetLayerCount: Integer;
    procedure SetLayer(NewLayer: Integer);
    procedure FindKidsArray(PageNum: Integer; var GetKids: TPDFArray;
      var Index: Integer; var GetParent: TPDFDictionary);
    procedure AdjustCount(Start: TPDFDictionary; Adjustment: Integer);
    function FindColorSpacesInResource(ResourceDict: TPDFDictionary): AnsiString;
    function FindColorSpaceInArray(CSName: AnsiString; CSArray: TPDFArray): AnsiString;
   public
    constructor Create(APages: TPDFDictionary; AImages, AImageLists, ATextLists, AIncludedFonts: TObjectList);
    destructor Destroy; override;
    function GetPage(PageNum: Integer): TPDFDictionary;
    function CreatePageRef(PageNum: Integer): TPDFIndRef;
    procedure UseImage(Image: TPDFImage);
    function ReplaceImage(OriginalImage, NewImage: TPDFImage): Boolean;
    procedure UseFont(Font: TPDFFont);
    procedure UseField(Field: TPDFField);
    procedure UseColorSpace(const CSName: AnsiString; CS: TPDFIndRef);
    procedure UsePattern(const CSName: AnsiString; CS: TPDFIndRef);
    procedure UseShading(const CSName: AnsiString; CS: TPDFIndRef);
    function UseOCG(OCGRef: TPDFIndRef): AnsiString;
    procedure ReleaseField(Field: TPDFField);
    procedure ReleaseFieldFromPage(Field: TPDFField; PageRef: TPDFIndRef);
    procedure UseGS(const GSName: AnsiString; GS: TPDFIndRef; Resources: TPDFDictionary = nil);
    procedure UseXObject(const XOName: AnsiString; XObjectRef: TPDFIndRef);
    function ExtractText(ExtractOptions: Integer; Funnel: TPDFTextFunnel): WideString;
    function GetTextList(ExtractOptions: Integer; Funnel: TPDFTextFunnel): TPDFTextList;
    function ExtractContent: AnsiString;
{$IFDEF QPL_D4_TO_D6}
    procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
{$ELSE}
    procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
{$ENDIF}
   function RenderPageToFile(DPI: Double; StartPage, EndPage, Options, JPEGQuality: Integer;
      const FileName: WideString; GDIPlusSettings: TGDIPlusSettings;
      HasPNGTransparency: Boolean; PNGTransparencyColor: Cardinal;
      var RenderError: AnsiString; OCGStateList: TQPLOCGStateList;
      const CairoFileName: WideString = ''; const DPLRFileName: WideString = ''): Boolean;
    function RenderPageToStream(DPI: Double; Page, Options, JPEGQuality: Integer;
      GDIPlusSettings: TGDIPlusSettings; Target: TStream; var RenderError: AnsiString;
      RenderCropType: Integer; OCGStateList: TQPLOCGStateList): Boolean;
    function RenderPageToDC(DPI: Double; Page, JPEGQuality: Integer;
      GDIPlusSettings: TGDIPlusSettings; TargetDC: HDC;
      var RenderError: AnsiString; RenderCropType, OffsetX, OffsetY: Integer;
      ErasePage: Boolean; OCGStateList: TQPLOCGStateList; Clip: AnsiString): Boolean;
{$IFDEF QPL_CAIRO}
    function RenderPageToCairoStream(DPI: Double; Page, Options, JPEGQuality: Integer;
      const CairoFileName: WideString; Target: TStream; var RenderError: AnsiString;
      RenderCropType: Integer; OCGStateList: TQPLOCGStateList): Boolean;
    function RenderPageToCairoDC(DPI: Double; Page, JPEGQuality: Integer;
      const CairoFileName: WideString; TargetDC: HDC;
      var RenderError: AnsiString; RenderCropType, OffsetX, OffsetY: Integer;
      ErasePage: Boolean; OCGStateList: TQPLOCGStateList): Boolean;
    function RenderPageToCairoFile(DPI: Double; StartPage, EndPage, Options, JPEGQuality: Integer;
      const CairoFileName, FileName: WideString;
      HasPNGTransparency: Boolean; PNGTransparencyColor: Cardinal;
      var RenderError: AnsiString; OCGStateList: TQPLOCGStateList): Boolean;
{$ENDIF}
{$IFDEF QPL_DPLR}
    function RenderPageToDPLRStream(DPI: Double; Page, Options, JPEGQuality: Integer;
      GDIPlusSettings: TGDIPlusSettings;
      const DPLRFileName: WideString; Target: TStream; var RenderError: AnsiString;
      RenderCropType: Integer; OCGStateList: TQPLOCGStateList): Boolean;
    function RenderPageToDPLRMemory(DPI: Double; Page, JPEGQuality: Integer;
      GDIPlusSettings: TGDIPlusSettings;
      const DPLRFileName: WideString; Target: Pointer; Width, Height, BitsPerPixel: Integer;
      var RenderError: AnsiString; RenderCropType: Integer; OCGStateList: TQPLOCGStateList): Boolean;
    function RenderPageToDPLRDC(DPI: Double; Page, JPEGQuality: Integer;
      GDIPlusSettings: TGDIPlusSettings;
      const DPLRFileName: WideString; TargetDC: HDC;
      var RenderError: AnsiString; RenderCropType, OffsetX, OffsetY: Integer;
      ErasePage: Boolean; OCGStateList: TQPLOCGStateList;
      Clip: AnsiString): Boolean;
    function RenderPageToDPLRFile(DPI: Double; StartPage, EndPage, Options, JPEGQuality: Integer;
      const DPLRFileName, FileName: WideString; GDIPlusSettings: TGDIPlusSettings;
      HasPNGTransparency: Boolean; PNGTransparencyColor: Cardinal;
      var RenderError: AnsiString; OCGStateList: TQPLOCGStateList): Boolean;
{$ENDIF}
    function RenderPageToPrinter(QPLPrinter: TQPLPrinter; StartPage, EndPage, Options: Integer; GDIPlusSettings: TGDIPlusSettings; OCGStateList: TQPLOCGStateList): Boolean; overload;
    function RenderPageToPrinter(QPLPrinter: TQPLPrinter; StartPage, EndPage, Options: Integer; GDIPlusSettings: TGDIPlusSettings; OCGStateList: TQPLOCGStateList; const DPLRFileName: WideString): Boolean; overload;
    function RenderPageToPrinter(QPLPrinter: TQPLPrinter; const PageRanges: WideString; Options: Integer; GDIPlusSettings: TGDIPlusSettings; OCGStateList: TQPLOCGStateList): Boolean; overload;
    function RenderPageToPrinter(QPLPrinter: TQPLPrinter; const PageRanges: WideString; Options: Integer; GDIPlusSettings: TGDIPlusSettings; OCGStateList: TQPLOCGStateList; const DPLRFileName: WideString): Boolean; overload;
    procedure SplitPageText(Options: Integer);
    procedure Decrypt;
    function PageRef: TPDFIndRef;
    procedure NewPages(StartPos, PageCount: Integer; NewPageWidth, NewPageHeight: Double);
    procedure SetContent(S: AnsiString);
    procedure AddLinkToWeb(X, Y, W, H: Double; const Link: AnsiString;
      Options: Integer);
    procedure AddLinkToPage(X, Y, W, H: Double; Page: Integer; Position: Double;
      Options: Integer);
    procedure AddLinkToJavaScript(X, Y, W, H: Double; const JavaScript: WideString;
      Options: Integer; AsString, Compress: Boolean);
    procedure AddLinkToFile(X, Y, W, H: Double; const FileName: WideString;
      Page: Integer; Position: Double; NewWindow: Boolean; Options: Integer);
    procedure AddLinkToFileEx(X, Y, W, H: Double; const FileName: WideString;
      DestPage, Zoom, DestType: Integer; DestLeft, DestTop, DestRight, DestBottom: Double;
      NewWindow: Boolean; Options: Integer);
    function ConvertToFileSpecString(FileName: WideString; AbsolutePath: WideString=''): WideString;
    procedure AddLinkToFileDest(X, Y, W, H: Double; const FileName: WideString;
      NamedDest: WideString; Position: Double; NewWindow: Boolean; Options: Integer);
    procedure AddLinkToEmbeddedFile(X, Y, W, H: Double; EFS: TPDFIndRef;
      const Title, Contents: WideString; IconType, Transparency: Integer);
    procedure AddLinkToLocalFile(X, Y, W, H: Double; const FileName: WideString;
      Options: Integer);
    procedure AddLinkToDestination(X, Y, W, H: Double; Dest: TPDFArray; Options: Integer);
    procedure PageActionJavaScript(const ActionType: AnsiString;
      const JavaScript: WideString; AsString, Compress: Boolean);
    function GetPageJavaScript(const ActionType: AnsiString): WideString;
    procedure ClonePages(StartPage, EndPage, RepeatCount: Integer);
    function CombineLayers: Boolean;
    function NewLayer: Integer;
    function QuickPDFLayer: Boolean;
    function MoveLayer(FromPos, ToPos: Integer): Boolean;
    function DeleteLayer: Boolean;
    procedure ForgetPages;
    procedure CloneResources(AllBoxes: Boolean = False);
    procedure AddNoteAnnotation(X, Y: Double; AnnotType:Integer; PopupX, PopupY,
      PopupWidth, PopupHeight: Double; const Title, Contents: WideString;  ColorR, ColorG,
      ColorB: Double; Open: Boolean);
    //procedure AddLineAnnotation(startX, startY, endX, EndY: Double; Transparency: Integer = 0);
    procedure AddFreeTextAnnotationEx(X, Y: Double;
      Width, Height: Double; const Text: WideString; Options: Integer; Angle: Integer = 0; Transparency: Integer = 0);
    procedure AddFreeTextAnnotation(X, Y: Double;
      Width, Height: Double; const Text: WideString; Options: Integer; Angle: Integer = 0);
    function AddStampAnnotation(X, Y, Width, Height: Double; StampType:Integer;
      const Title, Contents: WideString; ColorR, ColorG, ColorB: Double; Options: Integer): Boolean;
    function AddStampAnnotationFromImage(X, Y, Width, Height: Double;
      ImageData: AnsiString; ImageOptions: Integer; const Title: WideString; const Contents: WideString;
      ColorR: Double; ColorG: Double; ColorB: Double; Options: Integer): Boolean;
    function AddStampAnnotationFromImageID(X, Y, Width, Height: Double;
      PDFImage: TPDFImage; ImageOptions: Integer; const Title: WideString; const Contents: WideString;
      ColorR: Double; ColorG: Double; ColorB: Double; Options: Integer): Boolean;
    procedure AddSVGAnnotation(X, Y, W, H: Double; Source: TStream;
      const Title: AnsiString; Options: Integer);
    procedure AddSWFAnnotation(X, Y, W, H: Double; Source: TStream;
      const Title: WideString; const FileNameString: AnsiString; Options: Integer);
    procedure AddU3DAnnotation(X, Y, W, H: Double; Source: TStream;
      const Title: AnsiString; Options: Integer);
    procedure AddTextMarkupAnnotation(X, Y, W, H: Double; MarkupType: Integer);
    function PageBoxProperties(const BoxName: AnsiString; Dimension: TPDFDimension): Double;
    procedure SetPageBoxProperties(const BoxName: AnsiString; Left, Top, Width, Height: Double);
    function RemovePageBox(const BoxName:AnsiString): Integer;
    function HasPageBox(const BoxName: AnsiString): Integer;
    function DeleteAnnotation(Index: Integer): Boolean;

    function KidsArray: TPDFArray;
    procedure SetPageCount(NewPageCount: Integer);

    procedure Compress;
    procedure DeletePages(StartPage, PageCount: Integer);
    procedure RemoveUnsharedResources(StartPage, PageCount: Integer);
    procedure MovePage(OldPosition, NewPosition: Integer);
    procedure HidePage;
    procedure SetCropBox(Left, Top, Width, Height: Double);
    procedure SetThumb(ImageRef: TPDFIndRef);
    procedure SetPageTransparencyGroup(const CS: AnsiString; IsolateFlag, KnockoutFlag: Boolean);
    function FindPage(PageRef: TPDFIndRef): Integer;
    function CheckPageAnnots: Boolean;
    function GetPageRef(PageNumber: Integer): TPDFIndRef;

    function GetLGIDictCount: Integer;
    function GetLGIDictContent(Index: Integer): AnsiString;
    function AddLGIDict(const DictContent: AnsiString): Boolean;
    function DeleteLGIDict(Index: Integer): Boolean;
    function GetImageList: TPDFImageList;

    function GetViewPortCount: Integer;
    function GetViewPort(Index: Integer): TPDFDictionary;

    function FindColorSpaces(Options: Integer): AnsiString;

    property Resources: TPDFDictionary read ResourcesDict;
    property Painter: TPDFPainter read FPainter;
    property PageCount: Integer read GetPageCount;
    property Page: Integer read FPage write SetPage;
    property PageWidth: Double read GetPageWidth write SetPageWidth;
    property PageHeight: Double read GetPageHeight write SetPageHeight;
    property UserUnit: Double read GetUserUnit write SetUserUnit;
    property ThisPage: TPDFDictionary read FPageDict;
    property LayerCount: Integer read GetLayerCount;
    property Layer: Integer read FLayer write SetLayer;
    property CanDraw: Boolean read FCanDraw;
    property UseUnsafeLayers: Boolean read FUseUnsafeLayers write FUseUnsafeLayers;
    property Annots: TPDFAnnots read FAnnots;

    property OnPageAccess: TPDFPageAccessEvent read FOnPageAccess write FOnPageAccess;
    property OnDecrypt: TPDFDecryptEvent read FOnDecrypt write FOnDecrypt;
    property OnDeleteObj: TPDFDeleteObjEvent read FOnDeleteObj write FOnDeleteObj;
    property OnFindPage: TFindPageEvent read FOnFindPage write FOnFindPage;

    property Renderer: TPDFRenderer read FRenderer write FRenderer;
    property RRenderFontCol:TPDFFontCollection read RenderFontCol;
  end;

implementation

uses
  SysUtils, DebenuPDFLibraryFlate, DebenuPDFLibraryAscii85, Math,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryPrinters,
{$ELSE}
  Vcl.Printers,
{$ENDIF}
{$IFDEF WIN64}
  DebenuPDFLibraryJPEGWin64,
{$ELSE}
  DebenuPDFLibraryJPEG,
{$ENDIF}
  DebenuPDFLibraryFontConst, DebenuPDFLibraryPNG, DebenuPDFLibraryGIF, DebenuPDFLibraryTIFF,
  DebenuPDFLibraryContentStreamProcessor, DebenuPDFLibraryStampAnnots;

{ TPDFPageTree }

constructor TPDFPageTree.Create(APages: TPDFDictionary; AImages,
  AImageLists, ATextLists, AIncludedFonts: TObjectList);
begin
  LayersCombined := False;
  GotPageWidth := False;
  GotPageHeight := False;
  RenderFontCol := TPDFFontCollection.Create;
  RenderFontCol.InstallFonts := True;
  FRenderer := nil;
  TextExtractFontCol := TPDFFontCollection.Create;
  TextExtractFontCol.InstallFonts := True;
  FPageWidth := 0;
  FPageHeight := 0;
  FUserUnit := 1.0;

  FImages := AImages;
  FImageLists := AImageLists;
  FTextLists := ATextLists;
  FIncludedFonts := AIncludedFonts;
  FPainter := TPDFPainter.Create(Self);
  FPainter.OnChange := PainterChange;
  FUseUnsafeLayers := False;
  FAnnots := TPDFAnnots.Create;
  FAnnots.OnFindPage := FindPage;
  SetLength(FKnownPages, 0);

  if APages = nil then
  begin
    FPage := 0;
    FStructure := nil;
    FPagesDict := nil;
  end else
  begin
    FStructure := APages.Owner;
    FPagesDict := APages;
    Page := 1;
  end;

  if Assigned(FStructure) then
    FPainter.PDFPrecNum := FStructure.PDFPrecNum
  else
    FPainter.PDFPrecNum := 4;
end;

function TPDFPageTree.GetPageCount: Integer;
begin
  if Assigned(FPagesDict) then
    Result := FPagesDict.IntValue('Count')
  else
    Result := 0;
  if Result < 0 then Result := 0;
  SetLength(FKnownPages, Result);
end;

function TPDFPageTree.GetPage(PageNum: Integer): TPDFDictionary;
var
  Obj: TPDFObject;
  LastObj: TPDFObject;
  PP: Integer;

  function SearchPage(Kids: TPDFArray; var PagePass: Integer): TPDFDictionary;
  var
    X: Integer;
    Obj: TPDFObject;
    Peek: TPDFDictionary;
    DictType: AnsiString;
    CountObj: TPDFObject;
    PeekCount: Integer;
    PeekKids: TPDFObject;
    TempObjNum: Integer;
    TempGenNum: Integer;
  begin
    Result := nil;
    for X := 0 to Kids.Count - 1 do
    begin
      if Kids.Item[X] is TPDFIndRef then
      begin
        FPagePointerArray := Kids;
        FPagePointer := TPDFIndRef(Kids.Item[X]);
        PageObjNum := TPDFIndRef(Kids.Item[X]).ObjNum;
        PageGenNum := TPDFIndRef(Kids.Item[X]).GenNum;
        Obj := FPagePointer.Obj;
        if Obj is TPDFDictionary then
        begin
          Peek := TPDFDictionary(Obj);
          DictType := Peek.DictType;

          if (DictType = '') then
          begin
            if (Assigned(Peek.FindValueByKeyName('Kids'))) then
            begin
              DictType := 'Pages';
            end;
          end;

          if DictType = 'Pages' then
          begin
            CountObj := Peek.FindValueByKeyName('Count', True);
            if CountObj is TPDFNumeric then
              PeekCount := TPDFNumeric(CountObj).AsInteger
            else
              PeekCount := 0;
            if (PageNum <= (PagePass + PeekCount)) then
            begin
              PeekKids := Peek.FindValueByKeyName('Kids', True);
              if PeekKids is TPDFArray then
              begin
                FParentNode := Peek;
                Result := SearchPage(TPDFArray(PeekKids), PagePass);
                Break;
              end;
            end else
              Inc(PagePass, PeekCount);
          end else
          if DictType = 'Page' then
            if PagePass + 1 = PageNum then
            begin
              Result := Peek;
              Break;
            end else
              Inc(PagePass);
        end else
        begin
          Result := FStructure.NewDictionary;
          Result.Add('Type', FStructure.NewCommonName('Page'));
          Result.Add('Parent', FStructure.NewIndirectRef(FParentNode.IndObjNum, FParentNode.IndGenNum));
          Result.Add('Resources', FStructure.NewDictionary);
          Result.Add('MediaBox', FStructure.NewDoubleArray([0, 0, 612, 792]));
          Result.Add('CropBox', FStructure.NewDoubleArray([0, 0, 612, 792]));
          Result.Add('Rotate', FStructure.NewNumeric(0));
          FStructure.OnNewIndObj(Self, TempObjNum, TempGenNum, Result);
          Kids.Replace(X, FStructure.NewIndirectRef(TempObjNum, TempGenNum));
          PageObjNum := TempObjNum;
          PageGenNum := TempGenNum;
        end;
      end;
    end;
  end;

begin
  Result := nil;
  if (PageNum > 0) and (PageNum <= GetPageCount) then
  begin
    FParentNode := FPagesDict;
    Obj := FPagesDict.FindValueByKeyName('Kids', True);
    PP := 0;
    if Obj is TPDFArray then
    begin
      if TPDFArray(Obj).Count = GetPageCount then
      begin
        LastObj := Obj;
        FPagePointerArray := TPDFArray(Obj);
        FPagePointer := TPDFIndRef(TPDFArray(Obj).Item[PageNum - 1]);
        PageObjNum := FPagePointer.ObjNum;
        PageGenNum := FPagePointer.GenNum;
        Obj := FPagePointer.Obj;
        if Obj is TPDFDictionary then
        begin
          Result := TPDFDictionary(Obj);
          if Result.DictType <> 'Page' then
          begin
            if (not Assigned(Result.FindValueByKeyName('Contents'))) then
            begin
              Obj := LastObj;
              Result := nil;
            end;
          end;
        end;
      end;
      if not Assigned(Result) then
        if (Obj is TPDFArray) then
          Result := SearchPage(TPDFArray(Obj), PP);
    end;
    FKnownPages[PageNum - 1] := Result;
  end;
end;

function TPDFPageTree.GetPageWidth: Double;
var
  L: Double;
  R: Double;
  Obj: TPDFObject;  
  MediaBox: TPDFArray;
  ThisDict: TPDFDictionary;
begin
  if ((not GotPageWidth) and Assigned(FPageDict)) then
  begin
    ThisDict := FPageDict;
    MediaBox := nil;
    repeat
      Obj := ThisDict.FindValueByKeyName('MediaBox');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if Obj is TPDFArray then
      begin
        MediaBox := TPDFArray(Obj);
      end else
      begin
        Obj := ThisDict.FindValueByKeyName('Parent');
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFDictionary then ThisDict := TPDFDictionary(Obj)
          else ThisDict := nil;
      end;
    until (MediaBox is TPDFArray) or (ThisDict = nil);
    if Assigned(MediaBox) then
    begin
      L := 0;
      R := 0;
      Obj := MediaBox.Item[0];
      if Obj is TPDFNumeric then
        L := TPDFNumeric(Obj).AsDouble;
      Obj := MediaBox.Item[2];
      if Obj is TPDFNumeric then
        R := TPDFNumeric(Obj).AsDouble;
      if R >= L then Result := (R - L) else Result := (L - R);
    end else
    begin
      GetDefaultPageSize;
      FPageDict.PurgeKey('MediaBox');
      Result := DefaultPageWidth;
      FPageDict.Add('MediaBox', FStructure.NewDoubleArray([0, 0,
        DefaultPageWidth, DefaultPageHeight]));
    end;
    GotPageWidth := True;
    FPageWidth := Result;
  end else
    Result := FPageWidth;
end;

function TPDFPageTree.GetTextList(ExtractOptions: Integer;
  Funnel: TPDFTextFunnel): TPDFTextList;
var
  Renderer: TPDFRenderer;
begin
  Result := nil;

  if (ExtractOptions >= 3) and (ExtractOptions <= 4) then
  begin
    Renderer := TPDFRenderer.Create(TextExtractFontCol);
    try
      Renderer.Destination := rdTextFunnel;
      Renderer.PageDict := FPageDict;
      if Assigned(Funnel) then
        Renderer.TextFunnel := Funnel;
      Renderer.Render;
      Result := Renderer.TextFunnel.GetTextList;
      FTextLists.Add(Result);
    finally
      Renderer.Free;
    end;
  end;
end;

procedure TPDFPageTree.SetPage(NewPage: Integer);
var
  Contents: TPDFObject;
  Content: TPDFObject;
  CX: Integer;
  ObjNum, GenNum: Integer;
  ContentDict: TPDFDictionary;
  Obj: TPDFObject;
  APage: Integer;
  AddNew: Boolean;
  FilterText: AnsiString;
begin
  FilterText := '';
  GotPageWidth := False;
  FPageWidth := 0;
  GotPageHeight := False;
  FPageHeight := 0;

  if (NewPage > 0) and (NewPage <= GetPageCount) then
    APage := NewPage
  else
    APage := FPage;

  FCanDraw := False;
  if APage < Length(FKnownPages) then
    FPageDict := FKnownPages[APage - 1]
  else
    FPageDict := nil;
  if FPageDict = nil then
    FPageDict := GetPage(APage);

  if Assigned(FPageDict) then
  begin
    FPage := APage;
    SetLength(FPageContent, 0);
    Contents := FPageDict.FindValueByKeyName('Contents');
    Obj := FPageDict.FindValueByKeyName('Annots', True);
    if Obj is TPDFArray then
      FAnnots.Attach(TPDFArray(Obj))
    else
      FAnnots.Clear;

    // If the Contents key doesn't exist make one
    if not Assigned(Contents) then
    begin
      Content := FStructure.NewStream('');
      TPDFStream(Content).Dictionary.Add('LC', FStructure.NewCommonName('iSQP'));
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, Content);
      Contents := FStructure.NewArray;
      FPageDict.Add('Contents', Contents);
      TPDFArray(Contents).Add(FStructure.NewIndirectRef(ObjNum, GenNum));
    end;

    // If the contents key is a single indirect reference then make it
    // a single element array
    if Contents is TPDFIndRef then
    begin
      if TPDFIndRef(Contents).Obj is TPDFArray then
        Contents := TPDFIndRef(Contents).Obj
      else
      begin
        Contents := FStructure.NewArray([Contents]);
        FPageDict.DeleteEntryByKeyName('Contents');
        FPageDict.Add('Contents', Contents);
      end;
    end;

    // At this point, Contents should always be an array containing at
    // least one indirect reference
    if Contents is TPDFArray then
    begin
      // Get the last content stream
      Content := TPDFArray(Contents).Item[TPDFArray(Contents).Count - 1];

      // It should always be an indirect reference
      if Content is TPDFIndRef then
        Content := TPDFIndRef(Content).Obj;

      AddNew := False;

      // It should always be a stream
      if Content is TPDFStream then
      begin
        ContentDict := TPDFStream(Content).Dictionary;
        if not FUseUnsafeLayers then
        begin
          Obj := ContentDict.FindValueByKeyName('LC');
          if not (Obj is TPDFName) or (TPDFName(Obj).Name <> 'iSQP') then
            AddNew := True;
        end;

        if not AddNew then
        begin
          if (Length(TPDFStream(Content).Stream) > 500000) and (not LayersCombined) then
            AddNew := True;
        end;

      end else
        AddNew := True;

      if AddNew then
      begin
        Content := FStructure.NewStream('');
        TPDFStream(Content).Dictionary.Add('LC', FStructure.NewCommonName('iSQP'));
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, Content);
        TPDFArray(Contents).Add(FStructure.NewIndirectRef(ObjNum, GenNum));
        FilterText := '';
      end;

      SetLength(FPageContent, TPDFArray(Contents).Count);
      for CX := 0 to TPDFArray(Contents).Count - 1 do
      begin
        Content := TPDFArray(Contents).Item[CX];
        if Content is TPDFIndRef then
          Content := TPDFIndRef(Content).Obj;
        if Content is TPDFStream then
        begin
          FPageContent[CX] := TPDFStream(Content);
        end else
        begin
          Obj := FStructure.NewStream('');
          FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
          TPDFArray(Contents).Replace(CX, FStructure.NewIndirectRef(ObjNum, GenNum));
          FPageContent[CX] := TPDFStream(Obj);
        end;
      end;

      Content := FPageContent[Length(FPageContent) - 1];
      FPainter.PDFPrecNum := FStructure.PDFPrecNum;

      FPainter.OnChange := nil;
      FPainter.Clear;
      FPainter.OnChange := PainterChange;
      FPainter.SetSource(TPDFStream(Content).GetDecodedStream);

      FLayer := Length(FPageContent);
      FCanDraw := True;
    end;
  end;

  if Assigned(FOnPageAccess) then
    FOnPageAccess(FPageDict);
end;

procedure TPDFPageTree.SetPageWidth(NewPageWidth: Double);
var
  H: Double;
begin
  H := GetPageHeight;
  GotPageWidth := True;
  FPageWidth := NewPageWidth;
  FPageDict.PurgeKey('MediaBox');
  FPageDict.PurgeKey('CropBox');
  FPageDict.Add('MediaBox', FStructure.NewDoubleArray([0, 0, NewPageWidth, H]));
  FPageDict.Add('CropBox', FStructure.NewDoubleArray([0, 0, NewPageWidth, H]));
end;

function TPDFPageTree.GetPageHeight: Double;
var
  T: Double;
  B: Double;
  Obj: TPDFObject;
  MediaBox: TPDFArray;
  ThisDict: TPDFDictionary;
begin
  if ((not GotPageHeight) and Assigned(FPageDict)) then
  begin
    ThisDict := FPageDict;
    MediaBox := nil;
    repeat
      Obj := ThisDict.FindValueByKeyName('MediaBox');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if Obj is TPDFArray then
      begin
        MediaBox := TPDFArray(Obj);
      end else
      begin
        Obj := ThisDict.FindValueByKeyName('Parent');
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFDictionary then ThisDict := TPDFDictionary(Obj)
          else ThisDict := nil;
      end;
    until (MediaBox is TPDFArray) or (ThisDict = nil);
    if Assigned(MediaBox) then
    begin
      T := 0;
      B := 0;
      Obj := MediaBox.Item[1];
      if Obj is TPDFNumeric then
        T := TPDFNumeric(Obj).AsDouble;
      Obj := MediaBox.Item[3];
      if Obj is TPDFNumeric then
        B := TPDFNumeric(Obj).AsDouble;
      if T >= B then Result := (T - B) else Result := (B - T);
    end else
    begin
      GetDefaultPageSize;
      FPageDict.PurgeKey('MediaBox');
      Result := DefaultPageHeight;
      FPageDict.Add('MediaBox', FStructure.NewDoubleArray([0, 0,
        DefaultPageWidth, DefaultPageHeight]));
    end;
    GotPageHeight := True;
    FPageHeight := Result;
  end else
    Result := FPageHeight;
end;

procedure TPDFPageTree.SetPageHeight(NewPageHeight: Double);
var
  W: Double;
begin
  W := GetPageWidth;
  GotPageHeight := True;
  FPageHeight := NewPageHeight;
  FPageDict.PurgeKey('MediaBox');
  FPageDict.PurgeKey('CropBox');
  FPageDict.Add('MediaBox', FStructure.NewDoubleArray([0, 0, W, NewPageHeight]));
  FPageDict.Add('CropBox', FStructure.NewDoubleArray([0, 0, W, NewPageHeight]));
end;

procedure TPDFPageTree.UseImage(Image: TPDFImage);
var
  Obj: TPDFObject;
  XObject: TPDFDictionary;
  Resources: TPDFDictionary;
  Pnt: Integer;
  Fnt: TPDFFont;
  Img: TPDFImage;
  GState: TEMFGraphicState;
  Pattern: TPDFPattern;
  I: Integer;
begin

  //if (Image.IncludedFonts.Count > 0) then
  if (FIncludedFonts.Count > 0) then
  begin
    //for Pnt := 0 to Image.IncludedFonts.Count - 1 do
    for Pnt := 0 to FIncludedFonts.Count - 1 do
    begin
      //Fnt := TPDFFont(Image.IncludedFonts[Pnt]);
      Fnt := TPDFFont(FIncludedFonts[Pnt]);
      UseFont(Fnt);
    end;
  end;

  if (Image.IncludedBitmaps.Count > 0) then
  begin
    for Pnt := 0 to Image.IncludedBitmaps.Count - 1 do
    begin
      Img := TPDFImage(Image.IncludedBitmaps[Pnt]);
      UseImage(Img);
    end;
  end;

  if (Image.IncludedGS.Count > 0) then
  begin
    for Pnt := 0 to Image.IncludedGS.Count - 1 do
    begin
      GState := TEMFGraphicState(Image.IncludedGS[Pnt]);
      UseGS(GState.GSName, GState.GS);
    end;
  end;

  if (Image.IncludedPatterns.Count > 0) then
  begin
    for Pnt := 0 to Image.IncludedPatterns.Count - 1 do
    begin
      Pattern := TPDFPattern(Image.IncludedPatterns[Pnt]);

      for I := 0 to Pattern.Colors.Count - 1 do
      begin
        Pattern.NewPatternBitmap(Pattern.Bitmap, Pattern.Colors[I]);
        UsePattern(Pattern.Name + '_' + QPLIntToStr(I), Pattern.IndRef);
      end;
    end;
  end;

  Resources := ResourcesDict;
  if Assigned(Resources) then
  begin
    Obj := Resources.FindValueByKeyName('XObject');

    // No XObject dictionary, add one
    if not Assigned(Obj) then
    begin
      Obj := FStructure.NewDictionary;
      Resources.Add('XObject', Obj);
    end;

    // XObject key is indirect
    if Obj is TPDFIndRef then
      Obj := TPDFIndRef(Obj).Obj;

    // XObject key is not a dictionary
    if not (Obj is TPDFDictionary) then
    begin
      Resources.DeleteEntryByKeyName('XObject');
      Obj := FStructure.NewDictionary;
      Resources.Add('XObject', Obj);
    end;

    if Obj is TPDFDictionary then
    begin
      XObject := TPDFDictionary(Obj);
      Obj := XObject.FindValueByKeyName(Image.Name);

      if not Assigned(Obj) then
        XObject.Add(Image.Name, Image.IndRef);

      if Obj is TPDFIndRef then
      begin
        if (Image.IndRef.ObjNum <> TPDFIndRef(Obj).ObjNum) or
          (Image.IndRef.GenNum <> TPDFIndRef(Obj).GenNum) then
        begin
          XObject.DeleteEntryByKeyName(Image.Name);
          XObject.Add(Image.Name, Image.IndRef);
        end;
      end;
    end;
  end;
end;

function TPDFPageTree.ResourcesDict: TPDFDictionary;
var
  Obj: TPDFObject;
begin
  Obj := FPageDict.FindValueByKeyName('Resources');

  // No resources dictionary, try get one from the parent node
  if not Assigned(Obj) then
  begin
    GetPage(FPage);
    if Assigned(FParentNode) then
      Obj := FParentNode.FindValueByKeyName('Resources');
  end;

  // Still no resources dictionary, add one
  if not Assigned(Obj) then
  begin
    Obj := FStructure.NewDictionary;
    FPageDict.Add('Resources', Obj);
  end;

  // Resources key is indirect
  if Obj is TPDFIndRef then
    Obj := TPDFIndRef(Obj).Obj;

  // Resources key (or indirect) is not a dictionary
  if not (Obj is TPDFDictionary) then
  begin
    FPageDict.DeleteEntryByKeyName('Resources');
    Obj := FStructure.NewDictionary;
    FPageDict.Add('Resources', Obj);
  end;

  if Obj is TPDFDictionary then
    Result := TPDFDictionary(Obj)
  else
    Result := nil;
end;

destructor TPDFPageTree.Destroy;
begin
  FPainter.Free;
  FAnnots.Free;
  RenderFontCol.Free;
  TextExtractFontCol.Free;
  inherited Destroy;
end;

procedure TPDFPageTree.PainterChange(Sender: TObject);
begin
  if (FLayer > 0) and (FLayer <= Length(FPageContent)) then
    FPageContent[FLayer - 1].SetTo(FPainter.Source, False);
end;

procedure TPDFPageTree.UseFont(Font: TPDFFont);
var
  Obj: TPDFObject;
  Fonts: TPDFDictionary;
  Resources: TPDFDictionary;
begin
  Resources := ResourcesDict;
  if Assigned(Resources) then
  begin
    Obj := Resources.FindValueByKeyName('Font');

    // No Font dictionary, add one
    if not Assigned(Obj) then
    begin
      Obj := FStructure.NewDictionary;
      Resources.Add('Font', Obj);
    end;

    // Font key is indirect
    if Obj is TPDFIndRef then
      Obj := TPDFIndRef(Obj).Obj;

    // Font key is not a dictionary
    if not (Obj is TPDFDictionary) then
    begin
      Resources.DeleteEntryByKeyName('Font');
      Obj := FStructure.NewDictionary;
      Resources.Add('Font', Obj);
    end;

    if Obj is TPDFDictionary then
    begin
      Fonts := TPDFDictionary(Obj);
      Obj := Fonts.FindValueByKeyName(Font.Name);

      if not Assigned(Obj) then
        Fonts.Add(Font.Name, Font.IndRef);

      if Obj is TPDFIndRef then
      begin
        if (Font.IndRef.ObjNum <> TPDFIndRef(Obj).ObjNum) or
          (Font.IndRef.GenNum <> TPDFIndRef(Obj).GenNum) then
        begin
          Fonts.DeleteEntryByKeyName(Font.Name);
          Fonts.Add(Font.Name, Font.IndRef);
        end;
      end;
    end;
  end;
end;

function TPDFPageTree.ExtractText(ExtractOptions: Integer; Funnel: TPDFTextFunnel): WideString;
var
  CX: Integer;
  S: AnsiString;
  Extractor: TPDFExtractor;
  Renderer: TPDFRenderer;
begin
  Result := '';

  if ExtractOptions < 3 then
  begin
    S := '';
    for CX := 0 to Length(FPageContent) - 1 do
    begin
      FLayer := CX + 1;
      S := S + ' ' + ExtractContent;
    end;
    if ExtractOptions = 1 then ExtractOptions := 0;
  end;

  if (ExtractOptions >= 3) and (ExtractOptions <= 8) then
  begin
    Renderer := TPDFRenderer.Create(TextExtractFontCol);
    try
      Renderer.Destination := rdTextFunnel;
      Renderer.PageDict := FPageDict;
      if Assigned(Funnel) then
        Renderer.TextFunnel := Funnel;
      Renderer.Render;
      if (ExtractOptions <= 6) then
      begin
        Result := Renderer.TextFunnel.GetCSV;
      end else
      if (ExtractOptions = 7) then
      begin
        Renderer.TextFunnel.SetTokenAdjacency;
        Result := Renderer.TextFunnel.CreateTextLines;
      end else
      if (ExtractOptions = 8) then
      begin
        Result := Renderer.TextFunnel.GetRawText;
      end;
    finally
      Renderer.Free;
    end;
  end else
  begin
    Extractor := TPDFExtractor.Create(ResourcesDict, TextExtractFontCol);
    try
      Result := Extractor.ExtractTextW(S, ExtractOptions);
    finally
      Extractor.Free;
    end;
  end;
end;

procedure TPDFPageTree.Decrypt;
begin
  if Assigned(FOnDecrypt) then
    FOnDecrypt(PageObjNum, PageGenNum);
end;

function TPDFPageTree.ExtractContent: AnsiString;
var
  Stream: TPDFStream;
begin
  Stream := FPageContent[FLayer - 1];
  if Assigned(Stream) then
    Result := Stream.GetDecodedStream
  else
    Result := '';  
end;

procedure TPDFPageTree.SetContent(S: AnsiString);
begin
  FPageContent[FLayer - 1].SetTo(S, False);
end;

procedure TPDFPageTree.GetDefaultPageSize;
var
  L: Double;
  R: Double;
  T: Double;
  B: Double;
  MediaBox: TPDFObject;
  Obj: TPDFObject;
begin
  DefaultPageWidth := 612;
  DefaultPageHeight := 792;
  if Assigned(FPagesDict) then
  begin
    MediaBox := FPagesDict.FindValueByKeyName('MediaBox');
    if MediaBox is TPDFArray then
    begin
      L := 0;
      R := 0;
      Obj := TPDFArray(MediaBox).Item[0];
      if Obj is TPDFNumeric then
        L := TPDFNumeric(Obj).AsDouble;
      Obj := TPDFArray(MediaBox).Item[2];
      if Obj is TPDFNumeric then
        R := TPDFNumeric(Obj).AsDouble;
      if R >= L then DefaultPageWidth := (R - L) else DefaultPageWidth := (L - R);

      T := 0;
      B := 0;
      Obj := TPDFArray(MediaBox).Item[1];
      if Obj is TPDFNumeric then
        T := TPDFNumeric(Obj).AsDouble;
      Obj := TPDFArray(MediaBox).Item[3];
      if Obj is TPDFNumeric then
        B := TPDFNumeric(Obj).AsDouble;
      if B >= T then DefaultPageHeight := (B - T) else DefaultPageHeight := (T - B);
    end;
  end;
end;

procedure TPDFPageTree.AddLinkToWeb(X, Y, W, H: Double; const Link: AnsiString;
  Options: Integer);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  BorderWidth: Integer;
begin
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;    
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);      
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('Link'));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + W, Y - H]));

    if (Options and 1) = 1 then
      BorderWidth := 1
    else
      BorderWidth := 0;
    AnnotDict.Add('Border', FStructure.NewDoubleArray([0, 0, BorderWidth]));

    ActionDict := FStructure.NewDictionary;
    ActionDict.Add('Type', FStructure.NewName('Action'));
    ActionDict.Add('S', FStructure.NewName('URI'));
    ActionDict.Add('URI', FStructure.NewString(Link));
    AnnotDict.Add('A', ActionDict);

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

procedure TPDFPageTree.AddLinkToPage(X, Y, W, H: Double; Page: Integer;
  Position: Double; Options: Integer);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  BorderWidth: Integer;
  Dest: TPDFArray;
  DestPage: TPDFDictionary;
begin
  try
    DestPage := GetPage(Page);
  except
    DestPage := nil;
  end;

  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj)
    and Assigned(DestPage) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('Link'));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + W, Y - H]));

    if (Options and 1) = 1 then
      BorderWidth := 1
    else
      BorderWidth := 0;
    AnnotDict.Add('Border', FStructure.NewDoubleArray([0, 0, BorderWidth]));

    ActionDict := FStructure.NewDictionary;
    ActionDict.Add('Type', FStructure.NewName('Action'));
    ActionDict.Add('S', FStructure.NewName('GoTo'));

    Dest := FStructure.NewArray;
    Dest.Add(FStructure.NewIndirectRef(DestPage.IndObjNum, DestPage.IndGenNum));
    Dest.Add(FStructure.NewName('XYZ'));
    Dest.Add(FStructure.NewNumeric(0));
    Dest.Add(FStructure.NewNumeric(Position));
    Dest.Add(FStructure.NewNumeric(0));

    ActionDict.Add('D', Dest);
    AnnotDict.Add('A', ActionDict);

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

procedure TPDFPageTree.ClonePages(StartPage, EndPage,
  RepeatCount: Integer);
var
  R: Integer;
  P: Integer;
  OldPageCount: Integer;
begin
  OldPageCount := GetPageCount;
  for R := 1 to RepeatCount do
    for P := StartPage to EndPage do
      ClonePage(P);
  for P := OldPageCount + 1 to GetPageCount do
  begin
    SetPage(P);
    NewLayer;
  end;
  SetPage(OldPageCount + 1);
end;

procedure TPDFPageTree.ClonePage(SourcePage: Integer);
var
  Obj: TPDFObject;
  Kids: TPDFArray;
  Page: TPDFDictionary;
  GenNum: Integer;
  ObjNum: Integer;
  Count: TPDFNumeric;
  X: Integer;
begin
  if Assigned(FPagesDict) then
  begin
    Obj := FPagesDict.FindValueByKeyName('Kids', True);
    if Obj is TPDFArray then
    begin
      Kids := TPDFArray(Obj);
      Obj := FPagesDict.FindValueByKeyName('Count', True);
      if Obj is TPDFNumeric then
      begin
        Count := TPDFNumeric(Obj);
        if Assigned(FStructure.OnNewIndObj) then
        begin
          Obj := FStructure.Decode(GetPage(SourcePage).Output);
          if Obj is TPDFDictionary then
          begin
            Page := Obj as TPDFDictionary;
            FStructure.OnNewIndObj(Self, ObjNum, GenNum, Page);
            Kids.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
            Count.SetTo(Count.AsInteger + 1);
            Page.Add('Parent', FStructure.NewIndirectRef(FPagesDict.IndObjNum, FPagesDict.IndGenNum));
            Obj := Page.FindValueByKeyName('Contents', True);
            if Obj is TPDFArray then
            begin
              for X := 1 to TPDFArray(Obj).Count - 1 do
                TPDFArray(Obj).Delete(1);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TPDFPageTree.NewPages(StartPos, PageCount: Integer; NewPageWidth, NewPageHeight: Double);
var
  Obj: TPDFObject;
  Kids: TPDFArray;
  Page: TPDFDictionary;
  Resources: TPDFDictionary;
  Content: TPDFStream;
  Contents: TPDFArray;
  GenNum: Integer;
  ObjNum: Integer;
  X: Integer;
  PageIndex: Integer;
  Parent: TPDFDictionary;

begin
  if Assigned(FPagesDict) then
  begin
    Parent := FPagesDict;
    Kids := nil;
    if (StartPos = 1) or (StartPos = GetPageCount + 1) then
    begin
      Parent := FPagesDict;
      Obj := FPagesDict.FindValueByKeyName('Kids', True);
      if Obj is TPDFArray then Kids := TPDFArray(Obj);
      PageIndex := 0;
      if StartPos = GetPageCount + 1 then
        if Assigned(Kids) then PageIndex := Kids.Count;
    end else
      FindKidsArray(StartPos - 1, Kids, PageIndex, Parent);
    if Assigned(Kids) then
    begin
      Kids.ReserveItems(PageCount);
      SetLength(FKnownPages, Length(FKnownPages) + PageCount);
      if Assigned(FStructure.OnNewIndObj) then
      begin
        AdjustCount(Parent, PageCount);
        FStructure.ReserveObjects(PageCount * 26);
        for X := 1 to PageCount do
        begin
          Page := FStructure.NewDictionary;
          FKnownPages[X + StartPos - 2] := Page;
          Resources := TPDFDictionary(FStructure.Decode('<< /ProcSet [ /PDF /Text /ImageB /ImageC /ImageI ] >>'));
          Page.Add('Type', FStructure.NewCommonName('Page'));
          if Parent.IsIndirect then
            Page.Add('Parent', FStructure.NewIndirectRef(Parent.IndObjNum,
              Parent.IndGenNum));
          Page.Add('MediaBox', FStructure.NewDoubleArray([0, 0, NewPageWidth, NewPageHeight]));
          Page.Add('CropBox', FStructure.NewDoubleArray([0, 0, NewPageWidth, NewPageHeight]));
          Page.Add('Rotate', FStructure.NewNumeric(0));          
          Page.Add('Resources', Resources);
          FStructure.OnNewIndObj(Self, ObjNum, GenNum, Page);
          Kids.Insert(PageIndex, FStructure.NewIndirectRef(ObjNum, GenNum));
          Inc(PageIndex);

          Content := FStructure.NewStream('');
          Content.Dictionary.Add('LC', FStructure.NewCommonName('iSQP'));
          FStructure.OnNewIndObj(Self, ObjNum, GenNum, Content);
          Contents := FStructure.NewArray;
          Page.Add('Contents', Contents);
          Contents.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
        end;

      end;
    end;
  end;
  SetPage(StartPos);
end;

function TPDFPageTree.GetLayerCount: Integer;
begin
  Result := Length(FPageContent);
end;

function TPDFPageTree.CombineLayers: Boolean;
var
  Combined: AnsiString;
  X: Integer;
  Obj: TPDFObject;
begin
  Combined := '';
  LayersCombined := True;
  Result := False;
  Obj := FPageDict.FindValueByKeyName('Contents');
  if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
  if Obj is TPDFArray then
  begin
    for X := 1 to GetLayerCount do
    begin
      FLayer := X;
      Combined := Combined + ' ' + ExtractContent;
    end;
    FLayer := 1;

    for X := 0 to Length(FPageContent) - 1 do
      FPageContent[X].Stream := '';
    FPageContent[0].SetTo('q'#10 + Combined + #10'Q'#10, False);
    FPageContent[0].Dictionary.Add('LC', FStructure.NewCommonName('iSQP'));
    SetLength(FPageContent, 1);
    for X := 1 to TPDFArray(Obj).Count - 1 do
      TPDFArray(Obj).Delete(1);
    Result := True;
  end;
end;

procedure TPDFPageTree.SetLayer(NewLayer: Integer);
var
  Content: TPDFStream;
  Obj: TPDFObject;
begin
  if NewLayer < 1 then NewLayer := 1;
  if NewLayer > GetLayerCount then NewLayer := GetLayerCount;
  FLayer := NewLayer;

  FCanDraw := False;
  Content := FPageContent[FLayer - 1];
  Obj := Content.Dictionary.FindValueByKeyName('Filter');
  if Assigned(Obj) then
  begin
    if ((Obj is TPDFArray) and (TPDFArray(Obj).Count = 1)) or (Obj is TPDFName) then
    begin
      if Obj is TPDFArray then Obj := TPDFArray(Obj).Item[0];
      if (Obj is TPDFName) and (TPDFName(Obj).Name = 'FlateDecode') then
      begin
        FCanDraw := True;
        FPainter.OnChange := nil;
        FPainter.Clear;
        FPainter.OnChange := PainterChange;
        FPainter.SetSource(InflateStr(Content.Stream));
      end;
    end;
  end else
  begin
    FCanDraw := True;
    FPainter.OnChange := nil;
    FPainter.Clear;
    FPainter.OnChange := PainterChange;
    FPainter.SetSource(Content.Stream);
  end;
end;

function TPDFPageTree.NewLayer: Integer;
var
  ObjNum: Integer;
  GenNum: Integer;
  Content: TPDFStream;
  Contents: TPDFObject;
begin
  Contents := FPageDict.FindValueByKeyName('Contents');
  if Contents is TPDFIndRef then Contents := TPDFIndRef(Contents).Obj;
  if Contents is TPDFArray then
  begin
    Content := FStructure.NewStream('');
    Content.Dictionary.Add('LC', FStructure.NewCommonName('iSQP'));
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, Content);
    TPDFArray(Contents).Add(FStructure.NewIndirectRef(ObjNum, GenNum));
    SetLength(FPageContent, Length(FPageContent) + 1);
    FPageContent[Length(FPageContent) - 1] := Content;
    SetLayer(Length(FPageContent));
    Result := FLayer;
  end else
    Result := 0;
end;

function TPDFPageTree.MoveLayer(FromPos, ToPos: Integer): Boolean;
var
  Contents: TPDFObject;
begin
  Contents := FPageDict.FindValueByKeyName('Contents', True);
  if (FromPos >= 1) and (FromPos <= GetLayerCount) and
    (ToPos >= 1) and (ToPos <= GetLayerCount) and (Contents is TPDFArray) then
  begin
    TPDFArray(Contents).Move(FromPos - 1, ToPos - 1);
    SetPage(FPage);
    Result := True;
  end else
    Result := False;
end;

procedure TPDFPageTree.Compress;
var
  X: Integer;
  Obj: TPDFObject;
  Filter: AnsiString;
  DoCompress: Boolean;
begin
  for X := 0 to Length(FPageContent) - 1 do
  begin
    DoCompress := True;
    Obj := FPageContent[X].Dictionary.FindValueByKeyName('Filter');
    if Assigned(Obj) then
    begin
      Filter := Obj.Output;
      if Filter = '/FlateDecode' then DoCompress := False;
      if Filter = '[ /FlateDecode ]' then DoCompress := False;
    end;
    if DoCompress then
      FPageContent[X].SetTo(FPageContent[X].GetDecodedStream, True);
  end;
end;

function TPDFPageTree.FindColorSpaces(Options: Integer): AnsiString;
var
  Resources: TPDFDictionary;
begin
  Result := '';

  Resources := ResourcesDict;
  if Assigned(Resources) then
  begin
    Result := FindColorSpacesInResource(Resources);
  end;
end;

function TPDFPageTree.FindColorSpacesInResource(
  ResourceDict: TPDFDictionary): AnsiString;
var
  Obj: TPDFObject;
  ColorSpaces: TPDFDictionary;
  XObjects: TPDFDictionary;
  StreamObj: TPDFStream;
  I: Integer;
  SubType: AnsiString;
begin

  if Assigned(ResourceDict) then
  begin
    Obj := ResourceDict.FindValueByKeyName('ColorSpace', True);

    if Assigned(Obj) then
    begin
      if Obj is TPDFDictionary then
      begin
        ColorSpaces := TPDFDictionary(Obj);

        for I := 0 to ColorSpaces.Count - 1 do
        begin
          Obj := ColorSpaces.Entry[I].Value;
          if Obj is TPDFIndRef then
            Obj := TPDFIndRef(Obj).Obj;

          if Obj is TPDFArray then
            Result := Result +  FindColorSpaceInArray('Resource,\"' + ColorSpaces.Entry[i].Key.Name + '\"', TPDfArray(Obj));
        end;
      end;
    end;

    Obj := ResourceDict.FindValueByKeyName('XObject', True);
    if Assigned(Obj) then
    begin
      if (Obj is TPDFDictionary) then
      begin
        XObjects := TPDFDictionary(Obj);

        for I := 0 to XObjects.Count - 1 do
        begin
          Obj := XObjects.Entry[I].Value;
          if Obj is TPDFIndRef then
            Obj := TPDFIndRef(Obj).Obj;

          if (Obj is TPDFStream) then
          begin
            StreamObj := TPDFStream(Obj);

            SubType := 'Unknown';
            Obj := StreamObj.Dictionary.FindValueByKeyName('Subtype', True);
            if (Obj is TPDFName) then
              SubType := TPDFName(Obj).Name;

            Obj := StreamObj.Dictionary.FindValueByKeyName('Resources', True);
            if (Obj is TPDFDictionary) then
              Result := Result + FindColorSpacesInResource(TPDFDictionary(Obj));

            Obj := StreamObj.Dictionary.FindValueByKeyName('ColorSpace', True);
            if (Obj is TPDFArray) then
              Result := Result + FindColorSpaceInArray('XObject,\"' + XObjects.Entry[I].Key.Name + '\"', TPDFArray(Obj))
            else if (Obj is TPDFName) then
            begin
              Result := Result + 'XObject,\"' +  XObjects.Entry[I].Key.Name + '\",' + SubType + ',,' +  '\"' + TPDFName(Obj).Name + '\"' + ',-1,-1,-1,-1' + #13#10;
            end;

            Obj := StreamObj.Dictionary.FindValueByKeyName('SMask', True);
            if (Obj is TPDFStream) then
            begin
              StreamObj := TPDFStream(Obj);
              Obj := StreamObj.Dictionary.FindValueByKeyName('ColorSpace', True);
              if (Obj is TPDFArray) then
                Result := Result +  FindColorSpaceInArray('XObject,\"' + XObjects.Entry[I].Key.Name + '\"', TPDFArray(Obj))
              else if (Obj is TPDFName) then
              begin
                Result := Result + 'XObject,\"' +  XObjects.Entry[I].Key.Name + '\",' + SubType + 'SMask,,' +  '\"' + TPDFName(Obj).Name + '\"' + ',-1,-1,-1,-1' + #13#10;
              end;
            end;

          end;
        end;
      end;
    end;
  end;
end;

function TPDFPageTree.ConvertToFileSpecString(FileName: WideString; AbsolutePath: WideString=''): WideString;
var
  lTempString: WideString;
  lWideChar: WideChar;
  Index: Integer;
  i: Integer;
  Count: Integer;
begin
  if AbsolutePath = '' then
  begin
    lTempString := FileName;
    lWideChar := lTempString[2];
    if lWideChar = ':' then
    begin
      Delete(lTempString, 2, 1);
      lTempString := StringReplace(lTempString, '\', '/', [rfReplaceAll]);
      Insert('/', lTempString, 1);
    end;
    Result := lTempString;
  end
  else
  begin
    FileName := StringReplace(FileName, '\', '/', [rfReplaceAll]);
    AbsolutePath := StringReplace(AbsolutePath, '\', '/', [rfReplaceAll]);
    while (AbsolutePath[length(AbsolutePath)]<>'/') do
      Delete(AbsolutePath, length(AbsolutePath), 1);
    lWideChar := FileName[2];
    if lWideChar = ':' then
    begin
      FileName := WideString(QPLUpperCase(AnsiChar(FileName[1]))) + Copy(FileName, 2, MaxInt);
    end;
    Index := 0;
    while ((FileName[Index + 1] = AbsolutePath[Index +1]) and (length(FileName)>(Index+1)) and (length(AbsolutePath)>(Index+1)) ) do
    begin
      inc(Index);
    end;
    if (Index>0) then
    begin
      i:=1;
      while i<=Index do
      begin
        Delete(FileName, 1, 1);
        inc(i);
      end;
      i := length(AbsolutePath);
      Count := 0;
      while (i>0) do
      begin
        if (AbsolutePath[i] = '/') then
          inc(Count);
        dec(i);
      end;
      i := length(FileName);
      while (i>0) do
      begin
        if (FileName[i] = '/') then
          dec(Count);
        dec(i);
      end;
      if Count>1 then
        for i := 2 to Count do
          Insert('../', FileName,1);
      if (FileName[1]='/') then
        Delete(FileName, 1, 1);
      Result := FileName;
    end
    else
    begin
      lTempString := Filename;
      lWideChar := lTempString[2];
      if lWideChar = ':' then
      begin
        Delete(lTempString, 2, 1);
        lTempString := StringReplace(lTempString, '\', '/', [rfReplaceAll]);
        Insert('/', lTempString, 1);
      end;
      Result := lTempString;
    end;


  end;
end;

function TPDFPageTree.FindColorSpaceInArray(CSName: AnsiString; CSArray: TPDFArray): AnsiString;
var
  A: TPDFArray;
  N: TPDFName;
  Obj: TPDFObject;
  OutString: AnsiString;
  ColorSpace: TPDFDictionary;
  I, J: Integer;

begin
  Result := '';

  N := TPDFName(CSArray.Item[0]);
  OutString := CSName + ',' + N.Name + ',';

  if (N.Name = 'ICCBased') then
  begin
    OutString := OutString + ',,0,0,0';
    Result := Result + OutString + #13#10;
  end
  else if (N.Name = 'DeviceN') then
  begin
    for I := 1 to CSArray.Count - 1 do
    begin
      Obj := CSArray.Item[I];
      if Obj is TPDFIndRef then
        Obj := TPDFIndRef(Obj).Obj;

      if (Obj is TPDFArray) then
      begin
        for J := 0 to TPDFArray(Obj).Count - 1 do
        begin
          if (TPDFArray(Obj).Item[J] is TPDFName) then
          begin
            N := TPDFName(TPDFArray(Obj).Item[J]);

            if (N.Name <> 'None') then
              Result := Result + OutString + N.Name + ',Colorant,-1,-1,-1,-1' + #13#10;
          end;
        end;
      end
      else if (Obj is TPDFDictionary) then
      begin
        Obj := TPDFDictionary(Obj).FindValueByKeyName('Colorants', True);
        if (Obj is TPDFDictionary) then
        begin
          ColorSpace := TPDFDictionary(Obj);
          for j := 0 to ColorSpace.Count - 1 do
          begin
            Obj := ColorSpace.Entry[J].Value;
            if Obj is TPDFIndRef then
              Obj := TPDFIndRef(Obj).Obj;

            if (Obj is TPDFArray) then
              Result := Result + FindColorSpaceInArray(CSName, TPDFArray(Obj));
          end;
        end;
      end;
    end;
  end
  else if (N.Name = 'Separation') or (N.Name = 'Indexed') then
  begin
    N := TPDFName(CSArray.Item[1]);
    OutString := OutString + '\"' + N.Name + '\",';

    if (CSArray.Item[2] is TPDFName) then
    begin
      N := TPDFName(CSArray.Item[2]);
      OutString := OutString + N.Name + ',';
    end
    else if (CSArray.Item[2] is TPDFArray) then
    begin
      N := TPDFName(TPDFArray(CSArray.Item[2]).Item[0]);
      OutString := OutString + N.Name + ',';
    end
    else if (CSArray.Item[2] is TPDFIndRef) then
    begin
      Obj := TPDFObject(CSArray.Item[2]);
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;

      if (Obj is TPDFArray) then
      begin
        Obj := TPDFArray(Obj).Item[0];

        if (Obj is TPDFName) then
        begin
          N := TPDFName(Obj);
          OutString := OutString + N.Name + ',';
        end
        else
          OutString := OutString + ',';
      end
      else
        OutString := OutString + ',';
    end
    else
      OutString := OutString + ',';

    Obj := CSArray.Item[3];
    if Obj is TPDFIndRef then
      Obj := TPDFIndRef(Obj).Obj;

    if Obj is TPDFDictionary then
    begin
      ColorSpace := TPDFDictionary(Obj);

      Obj := ColorSpace.FindValueByKeyName('C1');
      if Obj is TPDFArray then
      begin
        A := TPDFArray(Obj);

        if (A.Count = 1) then
        begin
          OutString := OutString + A.Item[0].Output + ',,,';
          Result := Result + OutString + #13#10;
        end
        else if (A.Count = 3) then
        begin
          OutString := OutString + A.Item[0].Output + ',';
          OutString := OutString + A.Item[1].Output + ',';
          OutString := OutString + A.Item[2].Output + ',';
          Result := Result + OutString + #13#10;
        end
        else if (A.Count = 4) then
        begin
          OutString := OutString + A.Item[0].Output + ',';
          OutString := OutString + A.Item[1].Output + ',';
          OutString := OutString + A.Item[2].Output + ',';
          OutString := OutString + A.Item[3].Output;

          Result := Result + OutString + #13#10;
        end;
      end;
    end;

    if Obj is TPDFStream then
      Result := Result + OutString + '-1,-1,-1,-1' + #13#10;
  end;
end;

procedure TPDFPageTree.FindKidsArray(PageNum: Integer; var GetKids: TPDFArray;
  var Index: Integer; var GetParent: TPDFDictionary);
var
  Obj: TPDFObject;
  PP: Integer;

  function SearchPage(Kids: TPDFArray; var PagePass: Integer): TPDFArray;
  var
    X: Integer;
    Obj: TPDFObject;
    Peek: TPDFDictionary;
    DictType: AnsiString;
    CountObj: TPDFObject;
    PeekCount: Integer;
    PeekKids: TPDFObject;
  begin
    Result := nil;
    for X := 0 to Kids.Count - 1 do
    begin
      if Kids.Item[X] is TPDFIndRef then
      begin
        PageObjNum := TPDFIndRef(Kids.Item[X]).ObjNum;
        PageGenNum := TPDFIndRef(Kids.Item[X]).GenNum;
        Obj := TPDFIndRef(Kids.Item[X]).Obj;
        if Obj is TPDFDictionary then
        begin
          Peek := TPDFDictionary(Obj);
          DictType := Peek.DictType;
          if DictType = 'Pages' then
          begin
            GetParent := Peek;          
            CountObj := Peek.FindValueByKeyName('Count', True);
            if CountObj is TPDFNumeric then
              PeekCount := TPDFNumeric(CountObj).AsInteger
            else
              PeekCount := 0;
            if (PageNum <= (PagePass + PeekCount)) then
            begin
              PeekKids := Peek.FindValueByKeyName('Kids', True);
              if PeekKids is TPDFArray then
              begin
                Result := SearchPage(TPDFArray(PeekKids), PagePass);
                Break;
              end;
            end else
              Inc(PagePass, PeekCount);
          end else
          if DictType = 'Page' then
            if PagePass + 1 = PageNum then
            begin
              Obj := Peek.FindValueByKeyName('Parent');
              if Obj is TPDFIndRef then
              begin
                Obj := TPDFIndRef(Obj).Obj;
                if Obj is TPDFDictionary then
                  GetParent := TPDFDictionary(Obj);
              end;
              Result := Kids;
              Index := X + 1;
              Break;
            end else
              Inc(PagePass);
        end;
      end;
    end;
  end;

begin
  GetKids := nil;
  if (PageNum > 0) and (PageNum <= GetPageCount) then
  begin
    Obj := FPagesDict.FindValueByKeyName('Kids', True);
    PP := 0;
    if Obj is TPDFArray then
      GetKids := SearchPage(TPDFArray(Obj), PP);
  end;
end;

type
  TPageNode = record
    Page: TPDFIndRef;
    Parent: TPDFDictionary;
  end;

procedure TPDFPageTree.DeletePages(StartPage, PageCount: Integer);
var
  Page: Integer;
  TotalPages: Integer;
  Pages: array of TPageNode;

  procedure ProcessNode(Obj: TPDFObject; Parent: TPDFDictionary);
  var
    X: Integer;
    IndRef: TPDFIndRef;
    Kids: TPDFArray;
    ThisDict: TPDFDictionary;
    DictType: AnsiString;
  begin
    if Obj is TPDFIndRef then
    begin
      IndRef := TPDFIndRef(Obj);
      Obj := IndRef.Obj;
    end else
      IndRef := nil;

    if Obj is TPDFDictionary then
    begin
      ThisDict := TPDFDictionary(Obj);
      DictType := ThisDict.DictType;
      if DictType = 'Pages' then
      begin
        Obj := ThisDict.FindValueByKeyName('Kids', True);
        if Obj is TPDFArray then Kids := TPDFArray(Obj) else Kids := nil;
        if Assigned(Kids) then
        begin
          for X := 0 to Kids.Count - 1 do
            ProcessNode(Kids.Item[X], ThisDict);
        end;
      end;
      if DictType = 'Page' then
      begin
        Inc(Page);
        if Page <= TotalPages then
        begin
          Pages[Page - 1].Page := IndRef;
          Pages[Page - 1].Parent := Parent;
        end;
      end;
    end;
  end;

  procedure SetCount(PagesDict: TPDFDictionary);
  var
    Count: TPDFNumeric;
    Parent: TPDFIndRef;
    Obj: TPDFObject;
  begin
    Obj := PagesDict.FindValueByKeyName('Count', True);
    if Obj is TPDFNumeric then
      Count := TPDFNumeric(Obj)
    else
      Count := nil;
    Obj := PagesDict.FindValueByKeyName('Parent');
    if Obj is TPDFIndRef then
      Parent := TPDFIndRef(Obj)
    else
      Parent := nil;
    if Assigned(Count) and (Count.AsInteger > 0) then
      Count.SetTo(Count.AsInteger - 1);
    if Assigned(Parent) then SetCount(TPDFDictionary(Parent.Obj));
  end;

begin
  Page := 0;
  try
    TotalPages := TPDFNumeric(FPagesDict.FindValueByKeyName('Count', True)).AsInteger;
  except
    TotalPages := 0;
  end;
  SetLength(Pages, TotalPages);
  ProcessNode(FPagesDict, nil);

  RemoveUnsharedResources(StartPage, PageCount);

  for Page := StartPage to StartPage + PageCount - 1 do
  begin
    SetPage(Page);
    CombineLayers;
    if Length(FPageContent) > 0 then
      FPageContent[0].SetTo('', False);
  end;

  for Page := StartPage - 1 to StartPage + PageCount - 2 do
  begin
    if Assigned(Pages[Page].Parent) and Assigned(Pages[Page].Page) then
    begin
      TPDFArray(Pages[Page].Parent.FindValueByKeyName('Kids', True)).DeleteObj(Pages[Page].Page);
      SetCount(Pages[Page].Parent);
    end;
  end;
end;

function TPDFPageTree.KidsArray: TPDFArray;
var
  Obj: TPDFObject;
begin
  Result := nil;
  if Assigned(FPagesDict) then
  begin
    Obj := FPagesDict.FindValueByKeyName('Kids', True);
    if Obj is TPDFArray then
      Result := TPDFArray(Obj);
  end;
end;

procedure TPDFPageTree.SetPageCount(NewPageCount: Integer);
var
  Obj: TPDFObject;
  Count: TPDFNumeric;
begin
  if Assigned(FPagesDict) then
  begin
    Obj := FPagesDict.FindValueByKeyName('Count', True);
    if Obj is TPDFNumeric then
    begin
      Count := TPDFNumeric(Obj);
      Count.SetTo(NewPageCount);
    end;
  end;
end;

function TPDFPageTree.DeleteLayer: Boolean;
var
  X: Integer;
  Contents: TPDFObject;
begin
  Contents := FPageDict.FindValueByKeyName('Contents', True);
  if (Contents is TPDFArray) then
  begin
    FPageContent[FLayer - 1].SetTo('', False);
    FPageContent[FLayer - 1].Dictionary.Clear;
    TPDFArray(Contents).Delete(FLayer - 1);
    for X := FLayer - 1 to Length(FPageContent) - 2 do
      FPageContent[X] := FPageContent[X + 1];
    SetLength(FPageContent, Length(FPageContent) - 1);
    if FLayer >= TPDFArray(Contents).Count then Dec(FLayer);
    if FLayer < 1 then FLayer := 1;
    Result := True;
  end else
    Result := False;
end;

procedure TPDFPageTree.UseGS(const GSName: AnsiString; GS: TPDFIndRef; Resources: TPDFDictionary = nil);
var
  Obj: TPDFObject;
  ExtGStates: TPDFDictionary;
begin
  if (not Assigned(Resources)) then Resources := ResourcesDict;
  if Assigned(Resources) then
  begin
    Obj := Resources.FindValueByKeyName('ExtGState');

    // No ExtGState dictionary, add one
    if not Assigned(Obj) then
    begin
      Obj := FStructure.NewDictionary;
      Resources.Add('ExtGState', Obj);
    end;

    // ExtGState key is indirect
    if Obj is TPDFIndRef then
      Obj := TPDFIndRef(Obj).Obj;

    // ExtGState key is not a dictionary
    if not (Obj is TPDFDictionary) then
    begin
      Resources.DeleteEntryByKeyName('ExtGState');
      Obj := FStructure.NewDictionary;
      Resources.Add('ExtGState', Obj);
    end;

    if Obj is TPDFDictionary then
    begin
      ExtGStates := TPDFDictionary(Obj);
      Obj := ExtGStates.FindValueByKeyName(GSName);

      if not Assigned(Obj) then
        ExtGStates.Add(GSName, GS);

      if Obj is TPDFIndRef then
      begin
        if (GS.ObjNum <> TPDFIndRef(Obj).ObjNum) or
          (GS.GenNum <> TPDFIndRef(Obj).GenNum) then
        begin
          ExtGStates.DeleteEntryByKeyName(GSName);
          ExtGStates.Add(GSName, GS);
        end;
      end;
    end;
  end;
end;

procedure TPDFPageTree.RemoveUnsharedResources(StartPage,
  PageCount: Integer);
var
  PX: Integer;
  List: TObjectList;
  ResDict: TPDFDictionary;
  KillList: TObjectList;

  procedure ProcessKey(const KeyName: AnsiString);
  var
    X: Integer;
    Obj: TPDFObject;
    FontDescriptor: TPDFDictionary;
    KeyDict: TPDFDictionary;
  begin
    Obj := ResDict.FindValueByKeyName(KeyName);
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
    begin
      KeyDict := TPDFDictionary(Obj);
      for X := 0 to KeyDict.Count - 1 do
      begin
        Obj := KeyDict.Entry[X].Value;
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if List.IndexOf(Obj) < 0 then
        begin
          List.Add(Obj);
          if (Obj is TPDFDictionary) and (TPDFDictionary(Obj).DictType = 'Font') then
          begin
            Obj := TPDFDictionary(Obj).FindValueByKeyName('FontDescriptor');
            if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
            if Obj is TPDFDictionary then
            begin
              FontDescriptor := TPDFDictionary(Obj);
              List.Add(FontDescriptor);
              Obj := FontDescriptor.FindValueByKeyName('FontFile');
              if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
              if Obj is TPDFDictionary then List.Add(Obj);
              Obj := FontDescriptor.FindValueByKeyName('FontFile2');
              if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
              if Obj is TPDFDictionary then List.Add(Obj);
              Obj := FontDescriptor.FindValueByKeyName('FontFile3');
              if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
              if Obj is TPDFDictionary then List.Add(Obj);
            end;
          end;
        end;
      end;
    end;
  end;

  procedure KillKey(const KeyName: AnsiString);
  var
    X: Integer;
    Obj: TPDFObject;
    KeyDict: TPDFDictionary;
    FontDescriptor: TPDFDictionary;
  begin
    Obj := ResDict.FindValueByKeyName(KeyName);
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
    begin
      KeyDict := TPDFDictionary(Obj);
      for X := 0 to KeyDict.Count - 1 do
      begin
        Obj := KeyDict.Entry[X].Value;
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if (List.IndexOf(Obj) < 0) and (KillList.IndexOf(Obj) < 0) then
        begin
          KillList.Add(Obj);
          if (Obj is TPDFDictionary) and (TPDFDictionary(Obj).DictType = 'Font') then
          begin
            Obj := TPDFDictionary(Obj).FindValueByKeyName('FontDescriptor');
            if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
            if Obj is TPDFDictionary then
            begin
              FontDescriptor := TPDFDictionary(Obj);
              List.Add(FontDescriptor);
              Obj := FontDescriptor.FindValueByKeyName('FontFile');
              if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
              if Obj is TPDFDictionary then List.Add(Obj);
              Obj := FontDescriptor.FindValueByKeyName('FontFile2');
              if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
              if Obj is TPDFDictionary then List.Add(Obj);
              Obj := FontDescriptor.FindValueByKeyName('FontFile3');
              if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
              if Obj is TPDFDictionary then List.Add(Obj);
            end;
          end;
        end;
      end;
    end;
  end;

begin
  List := TObjectList.Create(False);
  KillList := TObjectList.Create(False);
  try
    for PX := 1 to StartPage - 1 do
    begin
      SetPage(PX);
      ResDict := ResourcesDict;
      ProcessKey('Font');
      ProcessKey('XObject');
      ProcessKey('Properties');
      ProcessKey('ExtGState');
      ProcessKey('Shading');
      ProcessKey('ColorSpace');
    end;
    for PX := StartPage + PageCount to GetPageCount do
    begin
      SetPage(PX);
      ResDict := ResourcesDict;
      ProcessKey('Font');
      ProcessKey('XObject');
      ProcessKey('Properties');
      ProcessKey('ExtGState');
      ProcessKey('Shading');
      ProcessKey('ColorSpace');
    end;
    for PX := StartPage to StartPage + PageCount - 1 do
    begin
      SetPage(PX);
      ResDict := ResourcesDict;
      KillKey('Font');
      KillKey('XObject');
      KillKey('Properties');
      KillKey('ExtGState');
      KillKey('Shading');
      KillKey('ColorSpace');
    end;
    for PX := 0 to KillList.Count - 1 do
    begin
      if KillList.Items[PX] is TPDFStream then
      try
        TPDFStream(KillList.Items[PX]).SetTo('123', False);
      except
      end;
    end;
  finally
    List.Free;
    KillList.Free;
  end;
end;

procedure TPDFPageTree.UseField(Field: TPDFField);
var
  Obj: TPDFObject;
begin
  Obj := FPageDict.FindValueByKeyName('Annots');
  if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
  if Assigned(Obj) and not (Obj is TPDFArray) then
  begin
    Obj := nil;
    FPageDict.PurgeKey('Annots');
  end;
  if not Assigned(Obj) then
  begin
    Obj := FStructure.NewArray;
    FPageDict.Add('Annots', Obj);
    FAnnots.Attach(TPDFArray(Obj));    
  end;
  if Obj is TPDFArray then
  begin
    if not TPDFArray(Obj).HasMatchingChild(Field.FieldRef.Output) then
      TPDFArray(Obj).Add(Field.FieldRef);
  end;
end;

procedure TPDFPageTree.MovePage(OldPosition, NewPosition: Integer);
var
  Obj: TPDFObject;
  Count: Integer;
  CountObj: TPDFNumeric;
  OldKids: TPDFArray;
  OldParent: TPDFDictionary;
  OldPageIndex: Integer;
  OldRef: TPDFIndRef;
  NewKids: TPDFArray;
  NewParent: TPDFDictionary;
  NewPageIndex: Integer;
  PageDict: TPDFDictionary;

  function GetPageInheritedValue(Start: TPDFDictionary;
    const Key: AnsiString): TPDFObject;
  var
    O: TPDFObject;
  begin
    Result := nil;
    if Assigned(Start) then
    begin
      O := Start.FindValueByKeyName(Key, True);
      if Assigned(O) then
      begin
        Result := O;
      end else
      begin
        O := Start.FindValueByKeyName('Parent', True);
        if O is TPDFDictionary then
        begin
          Result := GetPageInheritedValue(TPDFDictionary(O), Key);
        end;
      end;
    end;
  end;

  procedure InheritProperties(ChildNode: TPDFDictionary);
  var
    NodeList: array of AnsiString;
    NodeIndex: Integer;
    Obj: TPDFObject;
  begin
    SetLength(NodeList, 4);
    NodeList[0] := 'Resources';
    NodeList[1] := 'MediaBox';
    NodeList[2] := 'CropBox';
    NodeList[3] := 'Rotate';
    for NodeIndex := 0 to Length(NodeList) - 1 do
    begin
      if (not Assigned(ChildNode.FindValueByKeyName('Resources'))) then
      begin
        Obj := GetPageInheritedValue(ChildNode, 'Resources');
        if (Assigned(Obj)) then
        begin
          ChildNode.Add('Resources', Obj);
        end;
      end;
    end;
  end;

begin
  Obj := FPagesDict.FindValueByKeyName('Count', True);
  if Obj is TPDFNumeric then
  begin
    CountObj := TPDFNumeric(Obj);
    Count := CountObj.AsInteger;
    if (OldPosition >= 1) and (OldPosition <= Count) then
    begin
      InheritProperties(GetPage(OldPosition));

      if NewPosition < 1 then NewPosition := 1;
      if NewPosition > Count then NewPosition := Count;
      FindKidsArray(OldPosition, OldKids, OldPageIndex, OldParent);
      Obj := OldKids.Item[OldPageIndex - 1];
      if Obj is TPDFIndRef then
      begin
        OldRef := TPDFIndRef(Obj);
        OldKids.DeleteObj(OldRef, True);
        AdjustCount(OldParent, -1);

        Count := CountObj.AsInteger;
        if NewPosition = Count + 1 then
        begin
          FindKidsArray(NewPosition - 1, NewKids, NewPageIndex, NewParent);
          Inc(NewPageIndex);
        end else
        begin
          FindKidsArray(NewPosition, NewKids, NewPageIndex, NewParent);
        end;
        NewKids.Insert(NewPageIndex - 1, OldRef);
        AdjustCount(NewParent, 1);

        Obj := OldRef.Obj;
        if Obj is TPDFDictionary then
        begin
          PageDict := TPDFDictionary(Obj);
          Obj := PageDict.FindValueByKeyName('Parent', False);
          if Obj is TPDFIndRef then
          begin
            TPDFIndRef(Obj).ObjNum := NewParent.IndObjNum;
            TPDFIndRef(Obj).GenNum := NewParent.IndGenNum;
          end;
        end;
      end;
    end;
  end;
end;

procedure TPDFPageTree.HidePage;
var
  Kids: TPDFArray;
  Index: Integer;
  Parent: TPDFDictionary;
begin
  Kids := nil;
  Parent := nil;
  Index := -1;

  FindKidsArray(FPage, Kids, Index, Parent);

  if Assigned(Kids) then
  begin
    Kids.Delete(Index - 1);
    if Assigned(Parent) then
      AdjustCount(Parent, -1);
  end;
end;

procedure TPDFPageTree.AddLinkToJavaScript(X, Y, W, H: Double;
  const JavaScript: WideString; Options: Integer; AsString, Compress: Boolean);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  BorderWidth: Integer;
  JS: TPDFStream;
  DestPage: TPDFDictionary;
begin
  try
    DestPage := GetPage(Page);
  except
    DestPage := nil;
  end;

  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj)
    and Assigned(DestPage) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;

    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('Link'));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + W, Y - H]));

    if (Options and 1) = 1 then
      BorderWidth := 1
    else
      BorderWidth := 0;
    AnnotDict.Add('Border', FStructure.NewDoubleArray([0, 0, BorderWidth]));

    ActionDict := FStructure.NewDictionary;
    ActionDict.Add('Type', FStructure.NewName('Action'));
    ActionDict.Add('S', FStructure.NewName('JavaScript'));

    if AsString then
    begin
      ActionDict.Add('JS', FStructure.NewTextString(JavaScript));
    end else
    begin
      JS := FStructure.NewTextStream(JavaScript, Compress);

      FStructure.OnNewIndObj(Self, ObjNum, GenNum, JS);
      ActionDict.Add('JS', FStructure.NewIndirectRef(ObjNum, GenNum));
    end;
    AnnotDict.Add('A', ActionDict);

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

procedure TPDFPageTree.UseXObject(const XOName: AnsiString;
  XObjectRef: TPDFIndRef);
var
  Obj: TPDFObject;
  XObject: TPDFDictionary;
  Resources: TPDFDictionary;
begin
  Resources := ResourcesDict;
  if Assigned(Resources) then
  begin
    Obj := Resources.FindValueByKeyName('XObject');

    // No XObject dictionary, add one
    if not Assigned(Obj) then
    begin
      Obj := FStructure.NewDictionary;
      Resources.Add('XObject', Obj);
    end;

    // XObject key is indirect
    if Obj is TPDFIndRef then
      Obj := TPDFIndRef(Obj).Obj;

    // XObject key is not a dictionary
    if not (Obj is TPDFDictionary) then
    begin
      Resources.DeleteEntryByKeyName('XObject');
      Obj := FStructure.NewDictionary;
      Resources.Add('XObject', Obj);
    end;

    if Obj is TPDFDictionary then
    begin
      XObject := TPDFDictionary(Obj);
      Obj := XObject.FindValueByKeyName(XOName);

      if not Assigned(Obj) then
        XObject.Add(XOName, XObjectRef);

      if Obj is TPDFIndRef then
      begin
        if (XObjectRef.ObjNum <> TPDFIndRef(Obj).ObjNum) or
          (XObjectRef.GenNum <> TPDFIndRef(Obj).GenNum) then
        begin
          XObject.DeleteEntryByKeyName(XOName);
          XObject.Add(XOName, XObjectRef);
        end;
      end;
    end;
  end;
end;

procedure TPDFPageTree.ForgetPages;
begin
  SetLength(FKnownPages, 0);
end;

procedure TPDFPageTree.ReleaseField(Field: TPDFField);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  Kids: TPDFArray;
  X: Integer;
begin
  Obj := FPageDict.FindValueByKeyName('Annots');
  if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
  if Obj is TPDFArray then
  begin
    Annots := TPDFArray(Obj);
    Annots.DeleteObj(Field.FieldRef, True);
    Obj := Field.SourceDict.FindValueByKeyName('Kids', True);
    if Obj is TPDFArray then
    begin
      Kids := TPDFArray(Obj);
      for X := 0 to Kids.Count - 1 do
      begin
        Obj := Kids.Item[X];
        if Obj is TPDFIndRef then
          Annots.DeleteObj(TPDFIndRef(Obj), True);
      end;
    end;
  end;
end;

procedure TPDFPageTree.ReleaseFieldFromPage(Field: TPDFField;
  PageRef: TPDFIndRef);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  Kids: TPDFArray;
  X: Integer;
  LocalPageDict: TPDFDictionary;
begin
  if (Assigned(PageRef)) then
  begin
    Obj := PageRef.Obj;
    if (Obj is TPDFDictionary) then
    begin
      LocalPageDict := TPDFDictionary(Obj);
      Obj := LocalPageDict.FindValueByKeyName('Annots');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if Obj is TPDFArray then
      begin
        Annots := TPDFArray(Obj);
        Annots.DeleteObj(Field.FieldRef, True);
        Obj := Field.SourceDict.FindValueByKeyName('Kids', True);
        if Obj is TPDFArray then
        begin
          Kids := TPDFArray(Obj);
          for X := 0 to Kids.Count - 1 do
          begin
            Obj := Kids.Item[X];
            if Obj is TPDFIndRef then
              Annots.DeleteObj(TPDFIndRef(Obj), True);
          end;
        end;
      end;
    end;
  end;
end;

procedure TPDFPageTree.CloneResources(AllBoxes: Boolean);

  function GetInheritedItem(Dict: TPDFDictionary; const Name: AnsiString): TPDFObject;
  var
    Obj: TPDFObject;
  begin
    Result := nil;
    Obj := Dict.FindValueByKeyName(Name);
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) then Result := Obj else
    begin
      Obj := Dict.FindValueByKeyName('Parent');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if Obj is TPDFDictionary then
        Result := GetInheritedItem(TPDFDictionary(Obj), Name);
    end;
  end;

  procedure Clone(const Name: AnsiString);
  var
    Obj: TPDFObject;
  begin
    Obj := FPageDict.FindValueByKeyName(Name);
    if not Assigned(Obj) then
    begin
      Obj := GetInheritedItem(FPageDict, Name);
      if (Obj is TPDFIndRef) then
      begin
        Obj := TPDFIndRef(Obj).Obj;
      end;
      if Assigned(Obj) then
      begin
        FPageDict.Add(Name, FStructure.Decode(Obj.Output));
      end else
      begin
        if (Name = 'MediaBox') then
        begin
          FPageDict.Add('MediaBox', FStructure.NewDoubleArray([0, 0, 612, 792]));
        end else
        if Name = 'CropBox' then
        begin
          FPageDict.Add('CropBox', FPageDict.FindValueByKeyName('MediaBox'));
        end else
        if ((Name = 'BleedBox') or (Name = 'TrimBox') or (Name = 'ArtBox')) then
        begin
          FPageDict.Add(Name, FPageDict.FindValueByKeyName('MediaBox'));
        end else
        if Name = 'Rotate' then
        begin
          FPageDict.Add('Rotate', FStructure.NewNumeric(0));
        end;
      end;
    end;
  end;

begin
  Clone('Resources');
  Clone('MediaBox');
  Clone('CropBox');
  Clone('Rotate');
  if (AllBoxes) then
  begin
    Clone('BleedBox');
    Clone('TrimBox');
    Clone('ArtBox');
  end;
end;

procedure TPDFPageTree.PageActionJavaScript(const ActionType: AnsiString;
  const JavaScript: WideString; AsString, Compress: Boolean);
var
  Obj: TPDFObject;
  AADict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  JS: TPDFStream;
  DestPage: TPDFDictionary;
begin
  ActionDict := nil;
  try
    DestPage := GetPage(Page);
  except
    DestPage := nil;
  end;

  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj)
    and Assigned(DestPage) then
  begin
    Obj := FPageDict.FindValueByKeyName('AA');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
    begin
      AADict := TPDFDictionary(Obj);
    end else
    begin
      AADict := FStructure.NewDictionary;
      FPageDict.Add('AA', AADict);
    end;

    if Assigned(AADict) then
    begin
      Obj := AADict.FindValueByKeyName(ActionType);
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if Obj is TPDFDictionary then ActionDict := TPDFDictionary(Obj);

      if not Assigned(ActionDict) then
      begin
        ActionDict := FStructure.NewDictionary;
        AADict.Add(ActionType, ActionDict);
      end;
    end;

    if Assigned(ActionDict) then
    begin
      ActionDict.Add('Type', FStructure.NewName('Action'));
      ActionDict.Add('S', FStructure.NewName('JavaScript'));

      if AsString then
      begin
        ActionDict.Add('JS', FStructure.NewTextString(JavaScript));
      end else
      begin
        JS := FStructure.NewTextStream(JavaScript, True);

        FStructure.OnNewIndObj(Self, ObjNum, GenNum, JS);
        ActionDict.Add('JS', FStructure.NewIndirectRef(ObjNum, GenNum));
      end;
    end;
  end;
end;

function TPDFPageTree.GetPageJavaScript(const ActionType: AnsiString): WideString;
var
  Obj: TPDFObject;
  AADict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  DestPage: TPDFDictionary;
begin
  Result := '';
  try
    DestPage := GetPage(Page);
  except
    DestPage := nil;
  end;

  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj)
    and Assigned(DestPage) then
  begin
    Obj := FPageDict.FindValueByKeyName('AA');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
    begin
      AADict := TPDFDictionary(Obj);
      Obj := AADict.FindValueByKeyName(ActionType);
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if Obj is TPDFDictionary then
      begin
        ActionDict := TPDFDictionary(Obj);
        Obj := ActionDict.FindValueByKeyName('JS');
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFString then Result := TPDFString(Obj).AsTextString;
        if Obj is TPDFStream then Result := TPDFStream(Obj).GetDecodedTextStream;
      end;
    end;
  end;
end;

procedure TPDFPageTree.AddNoteAnnotation(X, Y: Double; AnnotType: Integer;
  PopupX, PopupY, PopupWidth, PopupHeight: Double; const Title, Contents: WideString;
  ColorR, ColorG, ColorB: Double; Open: Boolean);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  PopupDict: TPDFDictionary;
  ObjNumPopup: Integer;
  GenNumPopup: Integer;
  ShowDate: Boolean;
  APDict: TPDFDictionary;
  AppearanceStream: TPDFStream;
  GSName: AnsiString;
  FormRef: TPDFIndRef;
const
  Widths: array[0..6] of Integer = (20, 22, 22, 14, 26, 22, 22);
  Heights: array[0..6] of Integer = (24, 24, 24, 14, 16, 24, 24);
  Names: array[0..6] of AnsiString = ('Note', 'Comment', 'Help', 'Insert', 'Key',
    'NewParagraph', 'Paragraph');
begin
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('Text'));
    ShowDate := True;
    if AnnotType >= 100 then
    begin
      ShowDate := False;
      AnnotType := AnnotType - 100;
    end;
    if AnnotType < 0 then AnnotType := 0;
    if AnnotType > 6 then AnnotType := 0;
    if ShowDate then
      AnnotDict.Add('M', FStructure.NewString(GetPDFDateTime));
    AnnotDict.Add('Name', FStructure.NewName(Names[AnnotType]));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y - Heights[AnnotType], X + Widths[AnnotType], Y]));

    AnnotDict.Add('C', FStructure.NewDoubleArray([ColorR, ColorG, ColorB]));
    AnnotDict.Add('T', FStructure.NewTextString(Title));
    AnnotDict.Add('Contents', FStructure.NewTextString(Contents));

    // F = 28, No Rotate, No Zoom, Print
    AnnotDict.Add('F', FStructure.NewNumeric(28));

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);

    // Create Popup Object
    PopupDict := FStructure.NewDictionary;
    PopupDict.Add('Type', FStructure.NewName('Annot'));
    PopupDict.Add('Subtype', FStructure.NewName('Popup'));
    PopupDict.Add('Parent', FStructure.NewIndirectRef(ObjNum, GenNum));
    PopupDict.Add('Rect', FStructure.NewDoubleArray([PopupX, PopupY - PopupHeight, PopupX + PopupWidth, PopupY]));

    // F = 25, No Rotate, No Zoom, Invisible if nonstandard handler
    PopupDict.Add('F', FStructure.NewNumeric(25));
    PopupDict.Add('Open', FStructure.NewBoolean(Open));
    FStructure.OnNewIndObj(Self, ObjNumPopup, GenNumPopup, PopupDict);

    AnnotDict.Add('Popup', FStructure.NewIndirectRef(ObjNumPopup, GenNumPopup));
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
    Annots.Add(FStructure.NewIndirectRef(ObjNumPopup, GenNumPopup));

    APDict := FStructure.NewDictionary;
    GSName := 'GS0';
    UseGS(GSName, FStructure.NewIndirectRef(ObjNum, GenNum), ResourcesDict);

    AppearanceStream := FStructure.NewStream(DeflateStr(
      'q 1 1 1 rg 0 i 1 w 4 M 1 j 0 J []0 d /GS0 gs 1 0 0 1 9 5.0908 cm 7.74 12.616 m' +
      ' -7.74 12.616 l -8.274 12.616 -8.707 12.184 -8.707 11.649 c -8.707 -3.831 l -8.707' +
      ' -4.365 -8.274 -4.798 -7.74 -4.798 c 7.74 -4.798 l 8.274 -4.798 8.707 -4.365 8.707' +
      ' -3.831 c 8.707 11.649 l 8.707 12.184 8.274 12.616 7.74 12.616 c h f Q 0 G 1 1 0 rg' +
      ' 0 i 0.60 w 4 M 1 j 0 J []0 d  1 0 0 rg 0 G 0 i 0.59 w 4 M 1 j 0 J []0 d  1 0 0 1 9' +
      ' 5.0908 cm 0 0 m -0.142 0 -0.28 0.008 -0.418 0.015 c -2.199 -1.969 -5.555 -2.242 -4.642' +
      ' -1.42 c -4.024 -0.862 -3.916 0.111 -3.954 0.916 c -5.658 1.795 -6.772 3.222 -6.772 4.839' +
      ' c -6.772 7.509 -3.74 9.674 0 9.674 c 3.74 9.674 6.772 7.509 6.772 4.839 c 6.772 2.167 3.74' +
      ' 0 0 0 c 7.74 12.616 m -7.74 12.616 l -8.274 12.616 -8.707 12.184 -8.707 11.649 c -8.707' +
      ' -3.831 l -8.707 -4.365 -8.274 -4.798 -7.74 -4.798 c 7.74 -4.798 l 8.274 -4.798 8.707 -4.365' +
      ' 8.707 -3.831 c 8.707 11.649 l 8.707 12.184 8.274 12.616 7.74 12.616 c b '
      ));

    AppearanceStream.Dictionary.Add('Filter', FStructure.NewCommonName('FlateDecode'));
    AppearanceStream.Dictionary.Add('Subtype', FStructure.NewCommonName('Form'));
    AppearanceStream.Dictionary.Add('Type', Fstructure.NewCommonName('XObject'));
    AppearanceStream.Dictionary.Add('Resources', ResourcesDict);
    AppearanceStream.Dictionary.Add('BBox', FStructure.NewIntArray([0, 0, 18, 18]));
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AppearanceStream);
    FormRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    AnnotDict.Add('AP', APDict);
    APDict.Add('N', FormRef);
    AnnotDict.Add('P', PageRef);
    AnnotDict.Add('Subj', FStructure.NewString('Sticky Note'));
    AnnotDict.Add('NM', FStructure.NewString(GetPDFDateTime));
    AnnotDict.Add('CreationDate', FStructure.NewString(GetPDFDateTime));
  end;
end;

procedure TPDFPageTree.SetCropBox(Left, Top, Width, Height: Double);
begin
  FPageDict.Add('CropBox', FStructure.NewDoubleArray([Left, Top - Height, Left + Width, Top]));
end;

procedure TPDFPageTree.AdjustCount(Start: TPDFDictionary;
  Adjustment: Integer);
var
  Obj: TPDFObject;
begin
  repeat
    Obj := Start.FindValueByKeyName('Count', True);
    if Obj is TPDFNumeric then
      TPDFNumeric(Obj).SetTo(TPDFNumeric(Obj).AsInteger + Adjustment);
    Obj := Start.FindValueByKeyName('Parent');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
      Start := TPDFDictionary(Obj)
    else
      Start := nil;
  until not Assigned(Start);
end;

procedure TPDFPageTree.SetThumb(ImageRef: TPDFIndRef);
begin
  FPageDict.PurgeKey('Thumb');
  FPageDict.Add('Thumb', ImageRef);
end;

function TPDFPageTree.PageRef: TPDFIndRef;
var
  D: TPDFDictionary;
begin
  Result := nil;
  D := ThisPage;
  if Assigned(D) and D.IsIndirect then
    Result := FStructure.NewIndirectRef(D.IndObjNum, D.IndGenNum);
end;

function TPDFPageTree.QuickPDFLayer: Boolean;
var
  Obj: TPDFObject;
begin
  Obj := FPageContent[FLayer - 1].Dictionary.FindValueByKeyName('LC');
  Result := (Obj is TPDFName) and (TPDFName(Obj).Name = 'iSQP');
end;

procedure TPDFPageTree.SetPageTransparencyGroup(const CS: AnsiString;
  IsolateFlag, KnockoutFlag: Boolean);
var
  GroupDict: TPDFDictionary;
begin
  GroupDict := FStructure.NewDictionary;
  GroupDict.Add('Type', FStructure.NewName('Group'));
  GroupDict.Add('S', FStructure.NewName('Transparency'));
  GroupDict.Add('CS', FStructure.NewName(CS));
  GroupDict.Add('I', FStructure.NewBoolean(IsolateFlag));
  GroupDict.Add('K', FStructure.NewBoolean(KnockoutFlag));
  FPageDict.Add('Group', GroupDict);
end;

{$IFDEF QPL_CAIRO}
function TPDFPageTree.RenderPageToCairoFile(DPI: Double; StartPage, EndPage, Options,
  JPEGQuality: Integer; const CairoFileName, FileName: WideString;
  HasPNGTransparency: Boolean;
  PNGTransparencyColor: Cardinal; var RenderError: AnsiString;
  OCGStateList: TQPLOCGStateList): Boolean;
var
  TempSettings: TGDIPlusSettings;
begin
  Result := RenderPageToFile(DPI, StartPage, EndPage, Options, JPEGQuality,
    FileName, TempSettings, HasPNGTransparency, PNGTransparencyColor, RenderError,
    OCGStateList, CairoFileName, '');
end;
{$ENDIF}

{$IFDEF QPL_DPLR}
function TPDFPageTree.RenderPageToDPLRFile(DPI: Double; StartPage, EndPage, Options,
  JPEGQuality: Integer; const DPLRFileName, FileName: WideString;
  GDIPlusSettings: TGDIPlusSettings;
  HasPNGTransparency: Boolean;
  PNGTransparencyColor: Cardinal; var RenderError: AnsiString;
  OCGStateList: TQPLOCGStateList): Boolean;
begin
  Result := RenderPageToFile(DPI, StartPage, EndPage, Options, JPEGQuality,
    FileName, GDIPlusSettings, HasPNGTransparency, PNGTransparencyColor, RenderError,
    OCGStateList, '', DPLRFileName);
end;
{$ENDIF}

function TPDFPageTree.RenderPageToFile(DPI: Double; StartPage, EndPage, Options,
  JPEGQuality: Integer; const FileName: WideString;
  GDIPlusSettings: TGDIPlusSettings;
  HasPNGTransparency: Boolean;
  PNGTransparencyColor: Cardinal; var RenderError: AnsiString;
  OCGStateList: TQPLOCGStateList; const CairoFileName: WideString = '';
  const DPLRFileName: WideString = ''): Boolean;
var
  Renderer: TPDFRenderer;
  PN: Integer;
  FN: WideString;
  JI: TPDFJPEGImage;
  PW: TPNGWriter;
  GW: TPDFGIFWriter;
  FS: TQuickPDFWideFileStream;
  PPM: Integer;
begin
  Renderer := TPDFRenderer.Create(RenderFontCol);
  try
    if ((DPLRFileName <> '') and (CairoFileName <> '')) then
    begin
      Renderer.GDIPlusSettings := GDIPlusSettings;
    end;
    Renderer.DPI := DPI;
    Renderer.OCGStateList := OCGStateList;

{$IFDEF QPL_CAIRO}
    if (CairoFileName <> '') then
    begin
      Renderer.Destination := rdCairoBitmap;
      Renderer.SetCairoTarget(CairoFileName, 0, True, 0, 0);
    end;
{$ENDIF}

{$IFDEF QPL_DPLR}
    if (DPLRFileName <> '') then
    begin
      Renderer.Destination := rdDPLRBitmap;
      Renderer.SetDPLRTarget(DPLRFileName, 0, True, 0, 0);
    end;
{$ENDIF}

    //if ((DPLRFileName <> '') and (CairoFileName <> '')) then
    begin
      case Options of
        2: Renderer.Destination := rdWMF;
        3: Renderer.Destination := rdEMF;
        4: Renderer.Destination := rdEPS;
        8: Renderer.Destination := rdEMFPlus;
        9: Renderer.Destination := rdHTML5;
      else
        if ((DPLRFileName <> '') and (CairoFileName <> '')) then
          Renderer.Destination := rdBitmap;
      end;
    end;

    for PN := StartPage to EndPage do
    begin
      if QPLWideStringPos(WideString('%p'), FileName) > 0 then
        FN := QPLWideStringReplace(FileName, '%p', WideString(IntToStr(PN)), [rfReplaceAll])
      else
      begin
        FN := FileName;
        QPLWideStringInsert(WideString(IntToStr(PN)),
          FN, QPLWideStringPos(QPLExtractFileExt(FileName), FN));
      end;

      FS := QPLCreateFileStream(FN, fmCreate);
      try
        Renderer.ClearCachedResources;
        Renderer.PageDict := GetPage(PN);

        if Options = 8 then
        begin
          Renderer.SetEMFPlusTarget(FS);
        end;

        if Options = 9 then
        begin
          Renderer.SetHTML5Target(FS);
        end;

        Renderer.Render;
        RenderError := Renderer.ErrorDesc;

        if Options = 0 then
        begin
          try
            Renderer.Bitmap.Canvas.Lock;
            try
              Renderer.Bitmap.SaveToStream(FS);
            finally
              Renderer.Bitmap.Canvas.Unlock;
            end;
          except
            FS.Seek(0, soFromBeginning);
          end;
          if (FS.Size >= 48)  then
          begin
            FS.Seek($26, soFromBeginning);
            PPM := Trunc((DPI * 1000) / 25.4);
            FS.Write(PPM, 4);
            FS.Write(PPM, 4);
          end;
        end else
        if Options = 1 then
        begin
          JI := TPDFJPEGImage.Create;
          try
            JI.LoadFromBitmap(Renderer.Bitmap);
            JI.CompressionQuality := JPEGQuality;
            JI.DPI := Round(DPI);
            JI.SaveToStream(FS);
          finally
            JI.Free;
          end;
        end else
        if Options = 2 then
        begin
          Renderer.Metafile.SaveToStream(FS);
        end else
        if Options = 3 then
        begin
          Renderer.Metafile.SaveToStream(FS);
        end else
        if Options = 4 then
        begin
          Renderer.EPS.SaveToStream(FS);
        end else
        if Options = 5 then
        begin
          PW := TPNGWriter.Create(Renderer.Bitmap);
          try
            if HasPNGTransparency then
              PW.SetTransparencyColor(PNGTransparencyColor);
            PW.SetDPI(Round(DPI));
            PW.SaveToStream(FS);
          finally
            PW.Free;
          end;
        end else
        if Options = 6 then
        begin
          GW := TPDFGIFWriter.Create;
          try
            GW.Assign(Renderer.Bitmap);
            GW.SaveToStream(FS);
          finally
            GW.Free;
          end;
        end else
        if Options = 7 then
        begin
          ConvertBitmapToTIFF(Renderer.Bitmap, FS, GDIPlusSettings, DPI);
        end else
        if Options = 8 then
        begin
          // EMFPlus written directly to the file stream
        end else
        if Options = 9 then
        begin
          // HTML5 written directly to the stream
        end else
        if Options = 10 then
        begin
          ConvertBitmapToG4TIFF(Renderer.Bitmap, FS, GDIPlusSettings, DPI);
        end;
      finally
        FS.Free;
      end;
    end;
  finally
    Renderer.Free;
  end;
  Result := True;
end;

function TPDFPageTree.RenderPageToPrinter(QPLPrinter: TQPLPrinter;
  StartPage, EndPage, Options: Integer;
  GDIPlusSettings: TGDIPlusSettings; OCGStateList: TQPLOCGStateList): Boolean;
begin
  Result := RenderPageToPrinter(QPLPrinter,
    WideString(QPLIntToStr(StartPage) + '-' + QPLIntToStr(EndPage)),
    Options, GDIPlusSettings, OCGStateList, '');
end;

function TPDFPageTree.RenderPageToPrinter(QPLPrinter: TQPLPrinter;
  StartPage, EndPage, Options: Integer;
  GDIPlusSettings: TGDIPlusSettings; OCGStateList: TQPLOCGStateList;
  const DPLRFileName: WideString): Boolean;
begin
  Result := RenderPageToPrinter(QPLPrinter,
    WideString(QPLIntToStr(StartPage) + '-' + QPLIntToStr(EndPage)),
    Options, GDIPlusSettings, OCGStateList, DPLRFileName);
end;

function TPDFPageTree.RenderPageToPrinter(QPLPrinter: TQPLPrinter;
  const PageRanges: WideString; Options: Integer;
  GDIPlusSettings: TGDIPlusSettings; OCGStateList: TQPLOCGStateList): Boolean;
begin
  Result := RenderPageToPrinter(QPLPrinter, PageRanges, Options, GDIPlusSettings,
    OCGStateList, '');
end;

function TPDFPageTree.RenderPageToPrinter(QPLPrinter: TQPLPrinter;
  const PageRanges: WideString; Options: Integer;
  GDIPlusSettings: TGDIPlusSettings; OCGStateList: TQPLOCGStateList;
  const DPLRFileName: WideString): Boolean;
var
  Renderer: TPDFRenderer;
  PO: TPDFPrintOptions;
  DPI: Integer;
  PageList: TQuickPDFPageList;
  TempPageList: TQuickPDFPageList;
  PX: Integer;
  PageCount: Integer;
  TempPageCount: Integer;
  Progress: Integer;

  procedure ReportProgress(Code: Integer);
  begin
{$IFDEF QPL_OS_WINDOWS}
    if (GDIPlusSettings.ProgressWindow > 0) then
    begin
      SendMessage(GDIPlusSettings.ProgressWindow, GDIPlusSettings.ProgressMessage,
        GDIPlusSettings.ProgressData, Code);
    end;
{$ENDIF}
  end;

begin
  PageCount := GetPageCount;
  SetLength(PageList, 0);
  SetLength(TempPageList, 0);

  if (PageRanges = 'All') then
  begin
    SetLength(PageList, PageCount);
    for PX := 0 to Length(PageList) - 1 do
    begin
      PageList[PX] := PX + 1;
    end;
  end else
  if (PageRanges = 'Odd') then
  begin
    if (PageCount mod 2 = 0) then
    begin
      // Even number of pages
      SetLength(PageList, PageCount div 2);
    end else
    begin
      // Odd number of pages
      SetLength(PageList, (PageCount + 1) div 2);
    end;
    for PX := 0 to Length(PageList) - 1 do
    begin
      PageList[PX] := PX * 2 + 1;
    end;
  end else
  if (PageRanges = 'Even') then
  begin
    if (PageCount mod 2 = 0) then
    begin
      // Even number of pages
      SetLength(PageList, PageCount div 2);
    end else
    begin
      // Odd number of pages
      SetLength(PageList, (PageCount - 1) div 2);
    end;
    for PX := 0 to Length(PageList) - 1 do
    begin
      PageList[PX] := (PX + 1) * 2;
    end;
  end else
  begin
    if (QPLStartsWith(AnsiString(PageRanges), 'Odd')) then
    begin
      TempPageList := QPLParsePageRangeList(
        QPLCopy(AnsiString(PageRanges), 4, MaxInt),
        1, PageCount,  // Valid page range
        False,  // Silently ignore invalid pages
        False,  // Silently ignore invalid characters
        False,  // Silently ignore duplicate pages
        True,  // Allow/don't add duplicate pages to the returned page list
        False);  // Sort/don't sort the returned page list

      SetLength(PageList, Length(TempPageList));
      TempPageCount := 0;
      for PX := 0 to Length(TempPageList) - 1 do
      begin
        if ((TempPageList[PX] mod 2) = 1) then
        begin
          PageList[TempPageCount] := TempPageList[PX];
          Inc(TempPageCount);
        end;
      end;
      SetLength(PageList, TempPageCount);
    end else
    if (QPLStartsWith(AnsiString(PageRanges), 'Even')) then
    begin
      TempPageList := QPLParsePageRangeList(
        QPLCopy(AnsiString(PageRanges), 5, MaxInt),
        1, PageCount,  // Valid page range
        False,  // Silently ignore invalid pages
        False,  // Silently ignore invalid characters
        False,  // Silently ignore duplicate pages
        True,  // Allow/don't add duplicate pages to the returned page list
        False);  // Sort/don't sort the returned page list

      SetLength(PageList, Length(TempPageList));
      TempPageCount := 0;
      for PX := 0 to Length(TempPageList) - 1 do
      begin
        if ((TempPageList[PX] mod 2) = 0) then
        begin
          PageList[TempPageCount] := TempPageList[PX];
          Inc(TempPageCount);
        end;
      end;
      SetLength(PageList, TempPageCount);
    end else
    begin
      PageList := QPLParsePageRangeList(
        AnsiString(PageRanges),
        1, PageCount,  // Valid page range
          False,  // Silently ignore invalid pages
        False,  // Silently ignore invalid characters
        False,  // Silently ignore duplicate pages
        True,  // Allow/don't add duplicate pages to the returned page list
        False);  // Sort/don't sort the returned page list
    end;
  end;

  DPI := QPLPrinter.GetDPI;
  Renderer := TPDFRenderer.Create(RenderFontCol);
  try
    Renderer.GDIPlusSettings := GDIPlusSettings;
    PO.PageScaling := psNone;
    if Options and $F = 1 then PO.PageScaling := psFitToPaper;
    if Options and $F = 2 then PO.PageScaling := psShrinkLargePages;
    PO.AutoRotateCenter := Options and $10 = $10;

    Renderer.PrintOptions := PO;
    Renderer.DPI := DPI;
{$IFDEF QPL_DPLR}
    if (DPLRFileName <> '') then
    begin
      Renderer.Destination := rdDPLRPrinter;
      Renderer.DPLRFileName := DPLRFileName;
    end else
{$ENDIF}
    begin
      Renderer.Destination := rdPrinter;
    end;
    Renderer.QPLPrinter := QPLPrinter;
    Renderer.OCGStateList := OCGStateList;
    ReportProgress(1050);
    for PX := 0 to Length(PageList) - 1 do
    begin
      if PX > 0 then QPLPrinter.NewPage;
      Renderer.ClearCachedResources;
      Renderer.PageDict := GetPage(PageList[PX]);
      Renderer.Render;
      Progress := ((PX + 1) * 100) div Length(PageList);
      ReportProgress(Progress);
    end;
  finally
    Renderer.Free;
  end;

  Result := True;
end;

procedure TPDFPageTree.UseColorSpace(const CSName: AnsiString; CS: TPDFIndRef);
var
  Obj: TPDFObject;
  ColorSpaces: TPDFDictionary;
  Resources: TPDFDictionary;
begin
  Resources := ResourcesDict;
  if Assigned(Resources) then
  begin
    Obj := Resources.FindValueByKeyName('ColorSpace');

    // No ColorSpace dictionary, add one
    if not Assigned(Obj) then
    begin
      Obj := FStructure.NewDictionary;
      Resources.Add('ColorSpace', Obj);
    end;

    // ColorSpace key is indirect
    if Obj is TPDFIndRef then
      Obj := TPDFIndRef(Obj).Obj;

    // ColorSpace key is not a dictionary
    if not (Obj is TPDFDictionary) then
    begin
      Resources.DeleteEntryByKeyName('ColorSpace');
      Obj := FStructure.NewDictionary;
      Resources.Add('ColorSpace', Obj);
    end;

    if Obj is TPDFDictionary then
    begin
      ColorSpaces := TPDFDictionary(Obj);
      Obj := ColorSpaces.FindValueByKeyName(CSName);

      if not Assigned(Obj) then
        ColorSpaces.Add(CSName, CS);

      if Obj is TPDFIndRef then
      begin
        if (CS.ObjNum <> TPDFIndRef(Obj).ObjNum) or
          (CS.GenNum <> TPDFIndRef(Obj).GenNum) then
        begin
          ColorSpaces.DeleteEntryByKeyName(CSName);
          ColorSpaces.Add(CSName, CS);
        end;
      end;
    end;
  end;
end;

function TPDFPageTree.AddStampAnnotation(X, Y, Width, Height: Double;
  StampType: Integer; const Title, Contents: WideString; ColorR, ColorG,
  ColorB: Double; Options: Integer): Boolean;
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict, APDict: TPDFDictionary;
  AppearanceStream: TPDFStream;
  IndRef: TPDFIndRef;
  ObjNum: Integer;
  GenNum: Integer;
const
  Names: array[0..13] of AnsiString = ('Approved', 'Experimental', 'NotApproved',
    'AsIs', 'Expired', 'NotForPublicRelease', 'Confidential', 'Final', 'Sold',
    'Departmental', 'ForComment', 'TopSecret', 'Draft', 'ForPublicRelease');
begin
  Result := False;
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Result := True;
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('Stamp'));
    if StampType < 0 then StampType := 0;
    if StampType > 13 then StampType := 0;
    AnnotDict.Add('Name', FStructure.NewName(Names[StampType]));
    // AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + Width, Y - Height]));
    // Adjust height to be in the ratio of the predefined stamp streams.
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + Width, Y - Width / 120 * 33]));

    AnnotDict.Add('C', FStructure.NewDoubleArray([ColorR, ColorG, ColorB]));
    AnnotDict.Add('T', FStructure.NewTextString(Title));
    AnnotDict.Add('Contents', FStructure.NewTextString(Contents));

    AnnotDict.Add('F', FStructure.NewNumeric(4));

    // Add the appearance stream dict.
    APDict := FStructure.NewDictionary;
    AppearanceStream := FStructure.NewStream(GetStampStream(Names[StampType]), True);

    AppearanceStream.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, 120, 33]));

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AppearanceStream);
    IndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    APDict.Add('N', IndRef);
    AnnotDict.Add('AP', APDict);

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

function TPDFPageTree.AddStampAnnotationFromImage(X, Y, Width, Height: Double;
 ImageData: AnsiString; ImageOptions: Integer; const Title: WideString; const Contents: WideString;
 ColorR: Double; ColorG: Double; ColorB: Double; Options: Integer): Boolean;
var

    NewRef: TPDFIndRef;
    AnnotDict, APDict: TPDFDictionary;
    NStream: TPDFStream;
    XObjectDict: TPDFDictionary;
    ResourcesDict: TPDFDictionary;
    FRMStream: TPDFStream;
    AnnotWidth: Double;
    AnnotHeight: Double;
    PDFImage: TPDFImage;
    ImageDataStream: TMemoryStream;
    OldEvent: TNewIndObjEvent;
    Obj: TPDFObject;
    ObjNum: Integer;
    GenNum: Integer;
    Annots: TPDFArray;

  begin
    AnnotWidth:=Width;
    AnnotHeight:=Height;
    Result := False;
    if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
    begin
      Result := True;
      Obj := FPageDict.FindValueByKeyName('Annots');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if Assigned(Obj) and (Obj is TPDFArray) then
      begin
        Annots := Obj as TPDFArray;
      end else
      begin
        FPageDict.PurgeKey('Annots');
        Annots := FStructure.NewArray;
        FPageDict.Add('Annots', Annots);
        FAnnots.Attach(Annots);
      end;
      AnnotDict := FStructure.NewDictionary;
      AnnotDict.Add('Type', FStructure.NewName('Annot'));
      AnnotDict.Add('Subtype', FStructure.NewName('Stamp'));
      AnnotDict.Add('Name', FStructure.NewName('Draft'));
      AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + Width, Y - Height]));
      AnnotDict.Add('C', FStructure.NewDoubleArray([ColorR, ColorG, ColorB]));
      AnnotDict.Add('T', FStructure.NewTextString(Title));
      AnnotDict.Add('Contents', FStructure.NewTextString(Contents));
      AnnotDict.Add('F', FStructure.NewNumeric(4));
      APDict := FStructure.NewDictionary;
      AnnotDict.Add('AP', APDict);
      NStream := FStructure.NewStream('/F Do', False);
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, NStream);
      NewRef := FStructure.NewIndirectRef(ObjNum, GenNum);
      APDict.Add('N', NewRef);
      NStream.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, AnnotWidth, AnnotHeight]));
      ResourcesDict := FStructure.NewDictionary;
      NStream.Dictionary.Add('Resources', ResourcesDict);
      NStream.Dictionary.Add('FormType', FStructure.NewNumeric(1));
      NStream.Dictionary.Add('Name', FStructure.NewName('FRM'));
      NStream.Dictionary.Add('Type', FStructure.NewName('XObject'));
      NStream.Dictionary.Add('Subtype', FStructure.NewName('Form'));
      XObjectDict := FStructure.NewDictionary;
      ResourcesDict.Add('XObject', XObjectDict);
      FRMStream := FStructure.NewStream('q ' + QPLDoubleToStrConst(AnnotWidth, 5) + ' 0 0 ' +
        QPLDoubleToStrConst(AnnotHeight, 5) + ' 0 0 cm /Im1 Do Q', False);
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, FRMStream);
      NewRef := FStructure.NewIndirectRef(ObjNum, GenNum);
      XObjectDict.Add('F', NewRef);
      FRMStream.Dictionary.Add('Type', FStructure.NewName('XObject'));
      FRMStream.Dictionary.Add('Subtype', FStructure.NewName('Form'));
      ResourcesDict := FStructure.NewDictionary;
      FRMStream.Dictionary.Add('Resources', ResourcesDict);
      XObjectDict := FStructure.NewDictionary;
      ResourcesDict.Add('XObject', XObjectDict);

      PDFImage := TPDFImage.Create(FStructure, 'Im1', FIncludedFonts);

        try
          PDFImage.Compress := 1;
          ImageDataStream := TMemoryStream.Create;
          try
            ImageDataStream.Write(ImageData[1], Length(ImageData));
            ImageDataStream.Seek(0, soBeginning);
            OldEvent := FStructure.OnNewIndObj;
            PDFImage.NewImageFromStream(ImageDataStream, ImageOptions);
            FStructure.OnNewIndObj := OldEvent;
            XObjectDict.Add('Im1', PDFImage.IndRef);
          finally
            ImageDataStream.Free;
          end;
        finally
          PDFImage.Free;
        end;

      FRMStream.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, AnnotWidth, AnnotHeight]));
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
      Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
    end;

end;

function TPDFPageTree.AddStampAnnotationFromImageID(X, Y, Width, Height: Double;
 PDFImage: TPDFImage; ImageOptions: Integer; const Title: WideString; const Contents: WideString;
 ColorR: Double; ColorG: Double; ColorB: Double; Options: Integer): Boolean;
var

    NewRef: TPDFIndRef;
    AnnotDict, APDict: TPDFDictionary;
    NStream: TPDFStream;
    XObjectDict: TPDFDictionary;
    ResourcesDict: TPDFDictionary;
    FRMStream: TPDFStream;
    AnnotWidth: Double;
    AnnotHeight: Double;
    //PDFImage: TPDFImage;
    //ImageDataStream: TMemoryStream;
    //OldEvent: TNewIndObjEvent;
    Obj: TPDFObject;
    ObjNum: Integer;
    GenNum: Integer;
    Annots: TPDFArray;

  begin
    AnnotWidth:=Width;
    AnnotHeight:=Height;
    Result := False;
    if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
    begin
      Result := True;
      Obj := FPageDict.FindValueByKeyName('Annots');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if Assigned(Obj) and (Obj is TPDFArray) then
      begin
        Annots := Obj as TPDFArray;
      end else
      begin
        FPageDict.PurgeKey('Annots');
        Annots := FStructure.NewArray;
        FPageDict.Add('Annots', Annots);
        FAnnots.Attach(Annots);
      end;
      AnnotDict := FStructure.NewDictionary;
      AnnotDict.Add('Type', FStructure.NewName('Annot'));
      AnnotDict.Add('Subtype', FStructure.NewName('Stamp'));
      AnnotDict.Add('Name', FStructure.NewName('Draft'));
      AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + Width, Y - Height]));
      AnnotDict.Add('C', FStructure.NewDoubleArray([ColorR, ColorG, ColorB]));
      AnnotDict.Add('T', FStructure.NewTextString(Title));
      AnnotDict.Add('Contents', FStructure.NewTextString(Contents));
      AnnotDict.Add('F', FStructure.NewNumeric(4));
      APDict := FStructure.NewDictionary;
      AnnotDict.Add('AP', APDict);
      NStream := FStructure.NewStream('/F Do', False);
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, NStream);
      NewRef := FStructure.NewIndirectRef(ObjNum, GenNum);
      APDict.Add('N', NewRef);
      NStream.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, AnnotWidth, AnnotHeight]));
      ResourcesDict := FStructure.NewDictionary;
      NStream.Dictionary.Add('Resources', ResourcesDict);
      NStream.Dictionary.Add('FormType', FStructure.NewNumeric(1));
      NStream.Dictionary.Add('Name', FStructure.NewName('FRM'));
      NStream.Dictionary.Add('Type', FStructure.NewName('XObject'));
      NStream.Dictionary.Add('Subtype', FStructure.NewName('Form'));
      XObjectDict := FStructure.NewDictionary;
      ResourcesDict.Add('XObject', XObjectDict);
      FRMStream := FStructure.NewStream('q ' + QPLDoubleToStrConst(AnnotWidth, 5) + ' 0 0 ' +
        QPLDoubleToStrConst(AnnotHeight, 5) + ' 0 0 cm /Im1 Do Q', False);
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, FRMStream);
      NewRef := FStructure.NewIndirectRef(ObjNum, GenNum);
      XObjectDict.Add('F', NewRef);
      FRMStream.Dictionary.Add('Type', FStructure.NewName('XObject'));
      FRMStream.Dictionary.Add('Subtype', FStructure.NewName('Form'));
      ResourcesDict := FStructure.NewDictionary;
      FRMStream.Dictionary.Add('Resources', ResourcesDict);
      XObjectDict := FStructure.NewDictionary;
      ResourcesDict.Add('XObject', XObjectDict);
      XObjectDict.Add('Im1', PDFImage.IndRef);
      FRMStream.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, AnnotWidth, AnnotHeight]));
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
      Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
    end;

end;

procedure TPDFPageTree.AddSVGAnnotation(X, Y, W, H: Double;
  Source: TStream; const Title: AnsiString; Options: Integer);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  Resources: TPDFDictionary;
  Names: TPDFArray;
  FileSpecDict: TPDFDictionary;
  EFDict: TPDFDictionary;
  EFStream: TPDFStream;
  SS: AnsiString;
  TitleString: TPDFString;
  TitleStringPDFDoc: TPDFString;
begin
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('SVG'));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y - H, X + W, Y]));
    TitleString := FStructure.NewString(Title);
    TitleStringPDFDoc := FStructure.NewString(GetPDFDocFromWinAnsi(Title));
    AnnotDict.Add('T', TitleStringPDFDoc);
    AnnotDict.Add('TU', TitleStringPDFDoc);
    AnnotDict.Add('StartResource', TitleString);
    Resources := FStructure.NewDictionary;
    Names := FStructure.NewArray;
    Resources.Add('Names', Names);
    AnnotDict.Add('Resources', Resources);
    Names.Add(TitleString);
    FileSpecDict := FStructure.NewDictionary;
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, FileSpecDict);
    Names.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
    FileSpecDict.Add('Type', FStructure.NewCommonName('Filespec'));
    FileSpecDict.Add('F', TitleString);
    EFDict := FStructure.NewDictionary;
    FileSpecDict.Add('EF', EFDict);
    EFStream := FStructure.NewStream('');
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, EFStream);
    EFDict.Add('F', FStructure.NewIndirectRef(ObjNum, GenNum));
    SetLength(SS, Source.Size);
    Source.Read(SS[1], Length(SS));
    EFStream.SetTo(SS, True);
    EFStream.Dictionary.Add('Type', FStructure.NewName('EmbeddedFile'));
    EFStream.Dictionary.Add('Subtype', FStructure.NewName('image/svg+xml'));
    AnnotDict.Add('F', FStructure.NewNumeric(4));
    AnnotDict.Add('H', FStructure.NewName('P'));
    AnnotDict.Add('FT', FStructure.NewName('Btn'));
    AnnotDict.Add('Ff', FStructure.NewNumeric(65536));

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

procedure TPDFPageTree.AddSWFAnnotation(X, Y, W, H: Double; Source: TStream;
  const Title: WideString; const FileNameString: AnsiString; Options: Integer);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  AnnotRef: TPDFIndRef;
  ObjNum: Integer;
  GenNum: Integer;
  ActionDict: TPDFDictionary;
  ActionRef: TPDFIndRef;
  AdditionalActionsDict: TPDFDictionary;
  RenditionDict: TPDFDictionary;
  MediaCriteriaDict: TPDFDictionary;
  MediaPermissionsDict: TPDFDictionary;
  FileSpecRef: TPDFIndRef;
  FileParameterDict: TPDFDictionary;
  FileSpecDict: TPDFDictionary;
  EFDict: TPDFDictionary;
  EFStream: TPDFStream;
  SS: AnsiString;
begin
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('Screen'));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y - H, X + W, Y]));
    AnnotDict.Add('T', FStructure.NewTextString(Title));
    AnnotDict.Add('F', FStructure.NewNumeric(4));
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    AnnotRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    Annots.Add(AnnotRef);

    ActionDict := FStructure.NewDictionary;
    ActionDict.Add('S', FStructure.NewName('Rendition'));
    ActionDict.Add('OP', FStructure.NewNumeric(0));
    ActionDict.Add('AN', AnnotRef);
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, ActionDict);
    ActionRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    AnnotDict.Add('A', ActionRef);
    AnnotDict.Add('P', PageRef);

    MediaCriteriaDict := FStructure.NewDictionary;
    MediaCriteriaDict.Add('Type', FStructure.NewName('MediaClip'));
    MediaCriteriaDict.Add('S', FStructure.NewName('MCD'));
    MediaCriteriaDict.Add('N', FStructure.NewString('Media clip for Flash Insert'));
    MediaCriteriaDict.Add('CT', FStructure.NewString('application/x-shockwave-flash'));
    MediaPermissionsDict := FStructure.NewDictionary;
    MediaPermissionsDict.Add('TF', FStructure.NewString('TEMPACCESS'));
    MediaCriteriaDict.Add('P', MediaPermissionsDict);

    RenditionDict := FStructure.NewDictionary;
    RenditionDict.Add('S', FStructure.NewName('MR'));
    RenditionDict.Add('N', FStructure.NewString('Rendition for Flash Insert'));
    RenditionDict.Add('C', MediaCriteriaDict);

    ActionDict.Add('R', RenditionDict);

    AdditionalActionsDict := FStructure.NewDictionary;
    if (Options = 1) then
    begin
      AdditionalActionsDict.Add('E', ActionRef);
    end else
    if (Options = 2) then
    begin
      AdditionalActionsDict.Add('D', ActionRef);
    end else
    begin
      AdditionalActionsDict.Add('PV', ActionRef);
    end;
    AnnotDict.Add('AA', AdditionalActionsDict);

    FileSpecDict := FStructure.NewDictionary;
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, FileSpecDict);
    FileSpecRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    FileSpecDict.Add('Type', FStructure.NewCommonName('Filespec'));
    FileSpecDict.Add('F', FStructure.NewString(FileNameString));
    EFDict := FStructure.NewDictionary;
    FileSpecDict.Add('EF', EFDict);
    EFStream := FStructure.NewStream('');
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, EFStream);
    EFDict.Add('F', FStructure.NewIndirectRef(ObjNum, GenNum));
    SetLength(SS, Source.Size);
    Source.Read(SS[1], Length(SS));
    EFStream.SetTo(SS, True);
    EFStream.Dictionary.Add('Type', FStructure.NewName('EmbeddedFile'));
    FileParameterDict := FStructure.NewDictionary;
    FileParameterDict.Add('Size', FStructure.NewNumeric(Source.Size));
    EFStream.Dictionary.Add('Params', FileParameterDict);
    EFStream.Dictionary.Add('Subtype', FStructure.NewName('application/x-shockwave-flash'));

    MediaCriteriaDict.Add('D', FileSpecRef);
  end;
end;

function TPDFPageTree.RemovePageBox(const BoxName: AnsiString): Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  Obj := FPageDict.FindValueByKeyName(BoxName, True);
  if Obj is TPDFArray then
  begin
    FPageDict.DeleteEntryByKeyName(BoxName);
    Result := 1;
  end;
end;

function TPDFPageTree.HasPageBox(const BoxName: AnsiString): Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  Obj := FPageDict.FindValueByKeyName(BoxName, True);
  if Obj is TPDFArray then Result := 1;
  if not Assigned(Obj) then
  begin
    Obj := GetInheritedValue(FPageDict, BoxName);
    if Obj is TPDFIndRef then
    begin
      Obj := TPDFIndRef(Obj).Obj;
      if Obj is TPDFArray then Result := 2;
    end;
  end;
end;

function TPDFPageTree.PageBoxProperties(const BoxName: AnsiString;
  Dimension: TPDFDimension): Double;
var
  Obj: TPDFObject;
  R: TPDFRectangle;
begin
  Result := 0;
  if BoxName = 'MediaBox' then
  begin
    Obj := GetInheritedValue(FPageDict, 'MediaBox');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
  end else
  if BoxName = 'CropBox' then
  begin
    Obj := GetInheritedValue(FPageDict, 'CropBox');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if not Assigned(Obj) then
    begin
      Obj := GetInheritedValue(FPageDict, 'MediaBox');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    end;
  end else
  begin
    Obj := GetInheritedValue(FPageDict, BoxName);
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if not Assigned(Obj) then
    begin
      Obj := GetInheritedValue(FPageDict, 'CropBox');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    end;
    if not Assigned(Obj) then
    begin
      Obj := GetInheritedValue(FPageDict, 'MediaBox');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    end;
  end;
  if Obj is TPDFArray then
  begin
    R := TPDFRectangle.Create(TPDFArray(Obj));
    try
      if R.IsRectangle then
      begin
        Result := R.GetDimension(Dimension);
      end;
    finally
      R.Free;
    end;
  end;
end;

function TPDFPageTree.GetImageList: TPDFImageList;
var
  Renderer: TPDFRenderer;
  FontCol: TPDFFontCollection;
begin
  Result := TPDFImageList.Create;
  FImageLists.Add(Result);

  FontCol := TPDFFontCollection.Create;
  try
    FontCol.InstallFonts := True;
    Renderer := TPDFRenderer.Create(FontCol);
    try
      Renderer.DPI := 72;
      Renderer.Destination := rdImageList;
      Renderer.ImageList := Result;
      Renderer.PageDict := FPageDict;
      Renderer.Render;
    finally
      Renderer.Free;
    end;
  finally
    FontCol.Free;
  end;
end;

function TPDFPageTree.GetInheritedValue(Dict: TPDFDictionary;
  const Key: AnsiString): TPDFObject;
var
  Obj: TPDFObject;
  HasParent: Boolean;
  IR: TPDFIndRef;
begin
  Result := nil;
  HasParent := False;
  if Assigned(Dict) then
  begin
    repeat
      Result := Dict.FindValueByKeyName(Key);
      if not Assigned(Result) then
      begin
        HasParent := False;
        Obj := Dict.FindValueByKeyName('Parent');
        if Obj is TPDFIndRef then
        begin
          IR := TPDFIndRef(Obj);
          HasParent := True;
          Obj := IR.Obj;
          if Obj is TPDFDictionary then
            Dict := TPDFDictionary(Obj)
          else
            HasParent := False;
        end;
      end;
    until Assigned(Result) or (not HasParent);
  end;
end;

procedure TPDFPageTree.AddLinkToFile(X, Y, W, H: Double;
  const FileName: WideString; Page: Integer; Position: Double;
  NewWindow: Boolean; Options: Integer);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  BorderWidth: Integer;
  Dest: TPDFArray;
  AnsiFileName: AnsiString;
  FDict: TPDFDictionary;
begin
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('Link'));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + W, Y - H]));

    if (Options and 1) = 1 then
      BorderWidth := 1
    else
      BorderWidth := 0;
    AnnotDict.Add('Border', FStructure.NewDoubleArray([0, 0, BorderWidth]));

    ActionDict := FStructure.NewDictionary;
    ActionDict.Add('Type', FStructure.NewName('Action'));
    ActionDict.Add('S', FStructure.NewName('GoToR'));

    FDict := FStructure.NewDictionary;
    ActionDict.Add('F', FDict);

    AnsiFileName := QPLWideStringToAnsiString(FileName);
    FDict.Add('UF', FStructure.NewTextString(FileName));
    FDict.Add('F', FStructure.NewString(AnsiFileName));

    ActionDict.Add('NewWindow', FStructure.NewBoolean(NewWindow));

    Dest := FStructure.NewArray;
    Dest.Add(FStructure.NewNumeric(Page -1));
    Dest.Add(FStructure.NewName('XYZ'));
    Dest.Add(FStructure.NewNumeric(0));
    Dest.Add(FStructure.NewNumeric(Position));
    Dest.Add(FStructure.NewNumeric(0));

    ActionDict.Add('D', Dest);
    AnnotDict.Add('A', ActionDict);

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

procedure TPDFPageTree.AddLinkToFileEx(X, Y, W, H: Double;
  const FileName: WideString; DestPage, Zoom, DestType: Integer; DestLeft,
  DestTop, DestRight, DestBottom: Double; NewWindow: Boolean; Options: Integer);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  BorderWidth: Integer;
  Dest: TPDFArray;
  AnsiFileName: AnsiString;
  FDict: TPDFDictionary;
begin
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('Link'));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + W, Y - H]));

    if (Options and 1) = 1 then
      BorderWidth := 1
    else
      BorderWidth := 0;
    AnnotDict.Add('Border', FStructure.NewDoubleArray([0, 0, BorderWidth]));

    ActionDict := FStructure.NewDictionary;
    ActionDict.Add('Type', FStructure.NewName('Action'));
    ActionDict.Add('S', FStructure.NewName('GoToR'));

    FDict := FStructure.NewDictionary;
    ActionDict.Add('F', FDict);

    AnsiFileName := QPLWideStringToAnsiString(FileName);
    FDict.Add('UF', FStructure.NewTextString(FileName));
    FDict.Add('F', FStructure.NewString(AnsiFileName));

    ActionDict.Add('NewWindow', FStructure.NewBoolean(NewWindow));

    Dest := FStructure.NewArray;
    Dest.Add(FStructure.NewNumeric(Page - 1));

    case DestType of
      1:
      begin
        Dest.Add(FStructure.NewName('XYZ'));
        Dest.Add(FStructure.NewNumeric(DestLeft));
        Dest.Add(FStructure.NewNumeric(DestTop));
        Dest.Add(FStructure.NewNumeric(Zoom / 100));
       end;
      2: Dest.Add(FStructure.NewName('Fit'));
      3:
      begin
        Dest.Add(FStructure.NewName('FitH'));
        Dest.Add(FStructure.NewNumeric(DestTop));
      end;
      4:
      begin
        Dest.Add(FStructure.NewName('FitV'));
        Dest.Add(FStructure.NewNumeric(DestLeft));
      end;
      5:
      begin
        Dest.Add(FStructure.NewName('FitR'));
        Dest.Add(FStructure.NewNumeric(DestLeft));
        Dest.Add(FStructure.NewNumeric(DestBottom));
        Dest.Add(FStructure.NewNumeric(DestRight));
        Dest.Add(FStructure.NewNumeric(DestTop));
      end;
      6: Dest.Add(FStructure.NewName('FitB'));
      7:
      begin
        Dest.Add(FStructure.NewName('FitBH'));
        Dest.Add(FStructure.NewNumeric(DestTop));
      end;
      8:
      begin
        Dest.Add(FStructure.NewName('FitBV'));
        Dest.Add(FStructure.NewNumeric(DestLeft));
      end;
    end;

    ActionDict.Add('D', Dest);
    AnnotDict.Add('A', ActionDict);

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

procedure TPDFPageTree.AddLinkToFileDest(X, Y, W, H: Double;
  const FileName: WideString; NamedDest: WideString; Position: Double;
  NewWindow: Boolean; Options: Integer);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  BorderWidth: Integer;
  Dest: TPDFObject;
  AnsiFileName: AnsiString;
  FDict: TPDFDictionary;
begin
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('Link'));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + W, Y - H]));

    if (Options and 1) = 1 then
      BorderWidth := 1
    else
      BorderWidth := 0;
    AnnotDict.Add('Border', FStructure.NewDoubleArray([0, 0, BorderWidth]));

    ActionDict := FStructure.NewDictionary;
    ActionDict.Add('Type', FStructure.NewName('Action'));
    ActionDict.Add('S', FStructure.NewName('GoToR'));

    FDict := FStructure.NewDictionary;
    ActionDict.Add('F', FDict);

    AnsiFileName := QPLWideStringToAnsiString(FileName);
    FDict.Add('UF', FStructure.NewTextString(FileName));
    FDict.Add('F', FStructure.NewString(AnsiFileName));

    ActionDict.Add('NewWindow', FStructure.NewBoolean(NewWindow));

    Dest := FStructure.NewTextString(NamedDest);

    ActionDict.Add('D', Dest);
    AnnotDict.Add('A', ActionDict);

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

function TPDFPageTree.CheckPageAnnots: Boolean;
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  X: Integer;
  AnnotDict: TPDFDictionary;
  AnnotRef: TPDFIndRef;
  KillList: array of TPDFIndRef;

  procedure AddToList;
  begin
    SetLength(KillList, Length(KillList) + 1);
    KillList[Length(KillList) - 1] := AnnotRef;
  end;

begin
  Result := False;
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots', True);
    if Obj is TPDFArray then
    begin
      Annots := TPDFArray(Obj);
      for X := 0 to Annots.Count - 1 do
      begin
        Obj := Annots.Item[X];
        if Obj is TPDFIndRef then
        begin
          AnnotRef := TPDFIndRef(Obj);
          Obj := AnnotRef.Obj;
          if Obj is TPDFDictionary then
          begin
            AnnotDict := TPDFDictionary(Obj);
            if (AnnotDict.DictType = '') or (AnnotDict.DictType = 'Annot') then
            begin
              Obj := AnnotDict.FindValueByKeyName('Rect', True);
              if not (Obj is TPDFArray) then
                AddToList;
            end else
              AddToList;
          end;
        end;
      end;
      for X := 0 to Length(KillList) - 1 do
        Annots.DeleteObj(KillList[X], True);
    end;
  end;
end;

function TPDFPageTree.UseOCG(OCGRef: TPDFIndRef): AnsiString;
var
  Obj: TPDFObject;
  Properties: TPDFDictionary;
  Resources: TPDFDictionary;
  OCGName: AnsiString;
  OCG: TPDFDictionary;
begin
  OCGName := '';
  Resources := ResourcesDict;
  if Assigned(Resources) then
  begin
    Obj := OCGRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OCG := TPDFDictionary(Obj);
      Obj := OCG.FindValueByKeyName('Name', True);
      if Obj is TPDFString then
        OCGName := TPDFString(Obj).AsString;
    end;

    OCGName := 'QuickPDFOCG' + QPLCopy(MD5Print(MD5String(OCGName + OCGRef.Output)), 1, 8);

    Obj := Resources.FindValueByKeyName('Properties');

    // No Properties dictionary, add one
    if not Assigned(Obj) then
    begin
      Obj := FStructure.NewDictionary;
      Resources.Add('Properties', Obj);
    end;

    // Properties key is indirect
    if Obj is TPDFIndRef then
      Obj := TPDFIndRef(Obj).Obj;

    // Properties key is not a dictionary
    if not (Obj is TPDFDictionary) then
    begin
      Resources.DeleteEntryByKeyName('Properties');
      Obj := FStructure.NewDictionary;
      Resources.Add('Properties', Obj);
    end;

    if Obj is TPDFDictionary then
    begin
      Properties := TPDFDictionary(Obj);
      Obj := Properties.FindValueByKeyName(OCGName);

      if not Assigned(Obj) then
        Properties.Add(OCGName, OCGRef);

      if Obj is TPDFIndRef then
      begin
        if (OCGRef.ObjNum <> TPDFIndRef(Obj).ObjNum) or
          (OCGRef.GenNum <> TPDFIndRef(Obj).GenNum) then
        begin
          Properties.DeleteEntryByKeyName(OCGName);
          Properties.Add(OCGName, OCGRef);
        end;
      end;
    end;
  end;
  Result := OCGName;
end;

function TPDFPageTree.ReplaceImage(OriginalImage, NewImage: TPDFImage): Boolean;
var
  Resources: TPDFDictionary;
  NewName: AnsiString;
  OrigTest: AnsiString;

  function FindXObject(Resources: TPDFDictionary): Boolean;
  var
    X: Integer;
    XObject: TPDFDictionary;
    Obj: TPDFObject;
    Found: Integer;

  begin
    Found := -1;
    Result := False;
    begin
      Obj := Resources.FindValueByKeyName('XObject', True);
      if (Obj is TPDFDictionary) then
      begin
        XObject := TPDFDictionary(Obj);

        X := 0;
        while (X < XObject.Count) and (Found = -1) and (not Result) do
        begin
          begin
            if XObject.Entry[X].Value.Output = OrigTest then
              Found := X
            else
            begin
              Obj := XObject.Entry[X].Value;
              if Obj is TPDFIndRef then
                Obj := TPDFIndRef(Obj).Obj;

              if (Obj is TPDFStream) then
              begin
                Obj := TPDFStream(Obj).Dictionary;

                if Obj is TPDFDictionary then
                  Obj := TPDFDictionary(Obj).FindValueByKeyName('Resources', True);

                if (Obj is TPDFDictionary) then
                  Result := FindXObject(TPDFDictionary(Obj));
              end;
            end;
          end;
          Inc(X);
        end;

        if (Found >= 0) then
        begin
          NewName := XObject.Entry[Found].Key.Name;
          XObject.DeleteEntryByKeyName(NewName);
          XObject.Add(NewName, NewImage.IndRef);
          NewImage.SetName(NewName);
          UseImage(NewImage);
          Result := True;
        end;
      end;
    end;
  end;

begin
  Result := False;
  Resources := ResourcesDict;
  OrigTest := OriginalImage.IndRef.Output;

  if Assigned(Resources) then
    Result := FindXObject(Resources);
end;

function TPDFPageTree.RenderPageToStream(DPI: Double; Page, Options,
  JPEGQuality: Integer; GDIPlusSettings: TGDIPlusSettings;
  Target: TStream; var RenderError: AnsiString; RenderCropType: Integer;
  OCGStateList: TQPLOCGStateList): Boolean;
var
  Renderer: TPDFRenderer;
  JI: TPDFJPEGImage;
  PW: TPNGWriter;
  GW: TPDFGIFWriter;
  PPM: Integer;
begin
  Renderer := TPDFRenderer.Create(RenderFontCol);
  try
    Renderer.GDIPlusSettings := GDIPlusSettings;
    Renderer.DPI := DPI;
    Renderer.CropType := RenderCropType;
    Renderer.OCGStateList := OCGStateList;

    case Options of
      2: Renderer.Destination := rdWMF;
      3: Renderer.Destination := rdEMF;
      4: Renderer.Destination := rdEPS;
      8: Renderer.Destination := rdEMFPlus;
      9: Renderer.Destination := rdHTML5;
    else
      Renderer.Destination := rdBitmap;
    end;

    Renderer.PageDict := GetPage(Page);

    if Options = 8 then
    begin
      Renderer.SetEMFPlusTarget(Target);
    end;

    if Options = 9 then
    begin
      Renderer.SetHTML5Target(Target);
    end;

    Renderer.Render;
    RenderError := Renderer.ErrorDesc;
    if Options = 0 then
    begin
      try
        Renderer.Bitmap.Canvas.Lock;
        try
          Renderer.Bitmap.SaveToStream(Target);
        finally
          Renderer.Bitmap.Canvas.Unlock;
        end;
      except
        Target.Seek(0, soFromBeginning);
      end;
      if (Target.Size >= 48)  then
      begin
        Target.Seek($26, soFromBeginning);
        PPM := Trunc((DPI * 1000) / 25.4);
        Target.Write(PPM, 4);
        Target.Write(PPM, 4);
      end;
    end else
    if Options = 1 then
    begin
      JI := TPDFJPEGImage.Create;
      try
        JI.LoadFromBitmap(Renderer.Bitmap);
        JI.CompressionQuality := JPEGQuality;
        JI.DPI := Round(DPI);
        JI.SaveToStream(Target);
      finally
        JI.Free;
      end;
    end else
    if Options = 2 then
    begin
      Renderer.Metafile.SaveToStream(Target);
    end else
    if Options = 3 then
    begin
      Renderer.Metafile.SaveToStream(Target);
    end else
    if Options = 4 then
    begin
      Renderer.EPS.SaveToStream(Target);
    end else
    if Options = 5 then
    begin
      PW := TPNGWriter.Create(Renderer.Bitmap);
      try
        PW.SetDPI(Round(DPI));
        PW.SaveToStream(Target);
      finally
        PW.Free;
      end;
    end else
    if Options = 6 then
    begin
      GW := TPDFGIFWriter.Create;
      try
        GW.Assign(Renderer.Bitmap);
        GW.SaveToStream(Target);
      finally
        GW.Free;
      end;
    end else
    if Options = 7 then
    begin
      ConvertBitmapToTIFF(Renderer.Bitmap, Target, GDIPlusSettings, DPI);
    end else
    if Options = 8 then
    begin
      // EMFPlus written directly to the stream
    end else
    if Options = 9 then
    begin
      // HTML5 written directly to the stream
    end else
    if Options = 10 then
    begin
      ConvertBitmapToG4TIFF(Renderer.Bitmap, Target, GDIPlusSettings, DPI);
    end;
  finally
    Renderer.Free;
  end;
  Result := True;
end;

{$IFDEF QPL_CAIRO}
function TPDFPageTree.RenderPageToCairoStream(DPI: Double; Page, Options,
  JPEGQuality: Integer; const CairoFileName: WideString;
  Target: TStream; var RenderError: AnsiString; RenderCropType: Integer;
  OCGStateList: TQPLOCGStateList): Boolean;
var
  Renderer: TPDFRenderer;
  JI: TPDFJPEGImage;
  PW: TPNGWriter;
  GW: TPDFGIFWriter;
  PPM: Integer;
begin
  Renderer := TPDFRenderer.Create(RenderFontCol);
  try
    Renderer.DPI := DPI;
    Renderer.CropType := RenderCropType;
    Renderer.OCGStateList := OCGStateList;

    Renderer.Destination := rdCairoBitmap;
    Renderer.SetCairoTarget(CairoFileName, 0, True, 0, 0);

    Renderer.PageDict := GetPage(Page);

    if Options = 8 then
    begin
      Renderer.SetEMFPlusTarget(Target);
    end;

    if Options = 9 then
    begin
      Renderer.SetHTML5Target(Target);
    end;

    Renderer.Render;
    RenderError := Renderer.ErrorDesc;
    if Options = 0 then
    begin
      try
        Renderer.Bitmap.Canvas.Lock;
        try
          Renderer.Bitmap.SaveToStream(Target);
        finally
          Renderer.Bitmap.Canvas.Unlock;
        end;
      except
        Target.Seek(0, soFromBeginning);
      end;
      if (Target.Size >= 48)  then
      begin
        Target.Seek($26, soFromBeginning);
        PPM := Trunc((DPI * 1000) / 25.4);
        Target.Write(PPM, 4);
        Target.Write(PPM, 4);
      end;
    end else
    if Options = 1 then
    begin
      JI := TPDFJPEGImage.Create;
      try
        JI.LoadFromBitmap(Renderer.Bitmap);
        JI.CompressionQuality := JPEGQuality;
        JI.DPI := Round(DPI);
        JI.SaveToStream(Target);
      finally
        JI.Free;
      end;
    end else
    if Options = 2 then
    begin
      Renderer.Metafile.SaveToStream(Target);
    end else
    if Options = 3 then
    begin
      Renderer.Metafile.SaveToStream(Target);
    end else
    if Options = 4 then
    begin
      Renderer.EPS.SaveToStream(Target);
    end else
    if Options = 5 then
    begin
      PW := TPNGWriter.Create(Renderer.Bitmap);
      try
        PW.SetDPI(Round(DPI));
        PW.SaveToStream(Target);
      finally
        PW.Free;
      end;
    end else
    if Options = 6 then
    begin
      GW := TPDFGIFWriter.Create;
      try
        GW.Assign(Renderer.Bitmap);
        GW.SaveToStream(Target);
      finally
        GW.Free;
      end;
    end else
    if Options = 7 then
    begin
      // Using Cairo, so can't use GDI+ to convert to TIFF
      { ConvertBitmapToTIFF(Renderer.Bitmap, Target, GDIPlusSettings, DPI); }
    end else
    if Options = 8 then
    begin
      // EMFPlus written directly to the stream
    end else
    if Options = 9 then
    begin
      // HTML5 written directly to the stream
    end else
    if Options = 10 then
    begin
      // Using Cairo, so can't use GDI+ to convert to TIFF
      { ConvertBitmapToG4TIFF(Renderer.Bitmap, Target, GDIPlusSettings, DPI); }
    end;
  finally
    Renderer.Free;
  end;
  Result := True;
end;
{$ENDIF}

{$IFDEF QPL_DPLR}
function TPDFPageTree.RenderPageToDPLRStream(DPI: Double; Page, Options,
  JPEGQuality: Integer; GDIPlusSettings: TGDIPlusSettings; const DPLRFileName: WideString;
  Target: TStream; var RenderError: AnsiString; RenderCropType: Integer;
  OCGStateList: TQPLOCGStateList): Boolean;
var
  Renderer: TPDFRenderer;
  JI: TPDFJPEGImage;
  PW: TPNGWriter;
  GW: TPDFGIFWriter;
  PPM: Integer;
  TempGDIPlusSettings: TGDIPlusSettings;
begin
  Renderer := TPDFRenderer.Create(RenderFontCol);
  try
    Renderer.GDIPlusSettings := GDIPlusSettings;
    Renderer.DPI := DPI;
    Renderer.CropType := RenderCropType;
    Renderer.OCGStateList := OCGStateList;

    Renderer.Destination := rdDPLRBitmap;
    Renderer.SetDPLRTarget(DPLRFileName, 0, True, 0, 0);

    Renderer.PageDict := GetPage(Page);

    if Options = 8 then
    begin
      Renderer.SetEMFPlusTarget(Target);
    end;

    if Options = 9 then
    begin
      Renderer.SetHTML5Target(Target);
    end;

    Renderer.Render;
    RenderError := Renderer.ErrorDesc;
    if Options = 0 then
    begin
      try
        Renderer.Bitmap.Canvas.Lock;
        try
          Renderer.Bitmap.SaveToStream(Target);
        finally
          Renderer.Bitmap.Canvas.Unlock;
        end;
      except
        Target.Seek(0, soFromBeginning);
      end;
      if (Target.Size >= 48)  then
      begin
        Target.Seek($26, soFromBeginning);
        PPM := Trunc((DPI * 1000) / 25.4);
        Target.Write(PPM, 4);
        Target.Write(PPM, 4);
      end;
    end else
    if Options = 1 then
    begin
      JI := TPDFJPEGImage.Create;
      try
        JI.LoadFromBitmap(Renderer.Bitmap);
        JI.CompressionQuality := JPEGQuality;
        JI.SaveToStream(Target);
      finally
        JI.Free;
      end;
    end else
    if Options = 2 then
    begin
      Renderer.Metafile.SaveToStream(Target);
    end else
    if Options = 3 then
    begin
      Renderer.Metafile.SaveToStream(Target);
    end else
    if Options = 4 then
    begin
      Renderer.EPS.SaveToStream(Target);
    end else
    if Options = 5 then
    begin
      PW := TPNGWriter.Create(Renderer.Bitmap);
      try
        PW.SetDPI(Round(DPI));
        PW.SaveToStream(Target);
      finally
        PW.Free;
      end;
    end else
    if Options = 6 then
    begin
      GW := TPDFGIFWriter.Create;
      try
        GW.Assign(Renderer.Bitmap);
        GW.SaveToStream(Target);
      finally
        GW.Free;
      end;
    end else
    if Options = 7 then
    begin
      // Use GDI+ to convert to TIFF
      DefaultGDIPlusSettings(TempGDIPlusSettings);
      ConvertBitmapToTIFF(Renderer.Bitmap, Target, TempGDIPlusSettings, DPI);
    end else
    if Options = 8 then
    begin
      // EMFPlus written directly to the stream
    end else
    if Options = 9 then
    begin
      // HTML5 written directly to the stream
    end else
    if Options = 10 then
    begin
      // Use GDI+ to convert to TIFF
      DefaultGDIPlusSettings(TempGDIPlusSettings);
      ConvertBitmapToG4TIFF(Renderer.Bitmap, Target, TempGDIPlusSettings, DPI);
    end;
  finally
    Renderer.Free;
  end;
  Result := True;
end;

function TPDFPageTree.RenderPageToDPLRMemory(DPI: Double; Page, JPEGQuality: Integer;
  GDIPlusSettings: TGDIPlusSettings;
  const DPLRFileName: WideString; Target: Pointer; Width, Height, BitsPerPixel: Integer;
  var RenderError: AnsiString; RenderCropType: Integer; OCGStateList: TQPLOCGStateList): Boolean;
var
  Renderer: TPDFRenderer;
begin
  Renderer := TPDFRenderer.Create(RenderFontCol);
  try
    Renderer.GDIPlusSettings := GDIPlusSettings;
    Renderer.DPI := DPI;
    Renderer.CropType := RenderCropType;
    Renderer.OCGStateList := OCGStateList;

    Renderer.Destination := rdDPLRMemory;
    Renderer.SetDPLRMemoryTarget(DPLRFileName, Target, Width, Height, BitsPerPixel, True, 0, 0);
    Renderer.PageDict := GetPage(Page);

    Renderer.Render;
    RenderError := Renderer.ErrorDesc;
  finally
    Renderer.Free;
  end;
  Result := True;
end;
{$ENDIF}

procedure TPDFPageTree.SplitPageText(Options: Integer);
var
  Splitter: TPDFContentStreamTextSplitter;
begin
  Splitter := TPDFContentStreamTextSplitter.Create(Options);
  try
    CombineLayers;
    Splitter.Process(ExtractContent);
    SetContent(Splitter.GraphicsStream);
    NewLayer;
    SetContent(Splitter.TextStream);
    Compress;
  finally
    Splitter.Free;
  end;
end;

procedure TPDFPageTree.AddLinkToEmbeddedFile(X, Y, W, H: Double;
  EFS: TPDFIndRef; const Title, Contents: WideString; IconType,
  Transparency: Integer);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  APDict: TPDFDictionary;
  AppearanceStream: TPDFStream;
  FormRef: TPDFIndRef;
  GSName: AnsiString;
  ResourcesDict: TPDFDictionary;
  StandardIcon: Boolean;
  TransparencyPrefix: AnsiString;
  TransparencyPercent: AnsiString;
begin
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;

    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('FileAttachment'));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + W, Y - H]));
    AnnotDict.Add('FS', EFS);
    AnnotDict.Add('Contents', FStructure.NewTextString(Contents));
    AnnotDict.Add('T', FStructure.NewTextString(Title));

    StandardIcon := (IconType = 0) or ((IconType >= 3) and (IconType <= 5));

    if (StandardIcon) then
    begin
      AnnotDict.Add('CA', FStructure.NewNumeric(1 - (Transparency / 100)));
    end;
    if (not StandardIcon) then
    begin
      ResourcesDict := FStructure.NewDictionary;
      APDict := FStructure.NewDictionary;

      TransparencyPercent := QPLDoubleToStrConst(1 - (Transparency / 100), 3);

      FStructure.OnNewIndObj(Self, ObjNum, GenNum, FStructure.Decode(
        '<</Type/ExtGState/SMask/None/ca ' + TransparencyPercent +
        '/CA ' + TransparencyPercent + '>>'));
      GSName := 'QuickPDFGS' + QPLRandomID;
      UseGS(GSName, FStructure.NewIndirectRef(ObjNum, GenNum), ResourcesDict);

      TransparencyPrefix := 'q /' + GSName + ' gs ';

      if (IconType = 1) then
      begin
        AppearanceStream := FStructure.NewStream(DeflateStr(
          TransparencyPrefix +
          '10 0 0 10 0 0 cm ' +
          'BI /W 28 /H 28 /CS /RGB /BPC 8 /F [ /AHx /Fl ] ID ' +
          '789C85967950535714C609B6CEB4D3FE63B59DAA052920A2428B4C6BA742155954686DEB804A51EC28' +
          '9B9625205682500644B4A50865158B1B0444160D9B615F840021266549D864139445A1D6B60E1592D0' +
          'EFBD1B1E0146BD73E6CDCDC9BDBF7CE7DC73CF4B1EBF65F9722D166B8906353435160D168BA5C15AE4' +
          'A4FC4BC88C5A405C1A9A5ADA26BDFD8FDF59A163B6DDED5C14DF3F28CBFE4064467663364F92C313E7' +
          'E6FF71AB40C22B543D798562FAA9323873F224589375EB2E267E9CEB9CE0ACA898120BEB1FB43F34C5' +
          'AF78B0AF49DB1F9655B787FF5AD0D3F7C82F209377BB79E6A543A954E299CD13FB9CCC1C79F4B4B44A' +
          '565ADD2E69198C882C22F13ABB5F16DEED07E7A733798DA23EC7EFE3E393ABE4F47811737A7A5AA150' +
          '9C8F2BB33FF00BF494544AA3624B8D4C6C03427249720833BFB839F45CBE5832E074383131A51A1BC1' +
          'C446C5F442327C64129B58EEE01429EB1CE197B78269BAD93E20249B300FBA5D1236F5214BD049315D' +
          '2F4227B64C4D4D41CFF8C4DF22497F5DFDBDAABA4E4143CFD0D0C4E4E4731242EC85F27D8762DABA46' +
          '1023725B2BE8E684E5324C844C9877C5FDDFB92413A65C3E35AD90230443632B734BF72FACDCD66EB0' +
          '08FBB980E8C782B8A48ABDCED160E6F1A983C32F069DCE25A5A2CE844E3013682644E22910DD435038' +
          '38CFE3D72D6C3C03C378242D2AE6C1DFDA3B299DA804C4826F496931CCD033F93433093A71B2845955' +
          'D3F9F1277B502DEEDEDCED3BBCA09349696C5285BD7334F299C76F6198E4DC17E94C8A9FD5898188D6' +
          'E87F666EE18232D6D5370B3C7D53AE54A8745EA8DC4B9845CDF39994CE86A65E304322E674CE28A933' +
          '9A9A92FFF9E4DF1B39A26B19F599B9A2AC9BC2EE9E51526608648EF92A9DCCB943E47FCFA74998A4C8' +
          '49D464CC9EFB7959D743F57CAA9F7B7EA178967921FE6225B31D9240460D90B9AA6869664C4219554B' +
          'ED2F64C2094F73DB83436E2997B9F50BAE21732E4AE6F3CC4CF2955AA723F13D038FC1BC992F467DAA' +
          'CE5D9375C035A541D807FFA9305E77CF98B46314291A1A7E3236F694B67F662773363AFAD7FD071368' +
          '41ADD2A1C1C1F1F4AC46A46E712DDD2E6DBB922E8065640B2FA50960507B29ADF677AE807C640CFEAB' +
          'DC0688E4DE10528BAFD6C053C06F458570426FA9C7CE2F931657B4815C54D20AC39C18FA4369B96A8E' +
          '7BCD38E72F6EC1F69AFA6E553E59734C18595659D78D2B091349EE2F36F871B99AC40330B402B4B846' +
          'F100BF4276A7AE6BC1191126ACE24E67624AA5CDEE1396BBBC54B6D37BD6D8785AEDF4C685B2FD9A63' +
          '63779CEE031EB6DF9ECACC6D42911326528A335267D6097B3C7CD25E7FE32DF44398F1A6AF8C4C6176' +
          'E8242A33B2F9C8C476E99B6F6BEB6DFEC621C4DAD66FC96B4BE3922B207BC119314C41532F98EB8C2C' +
          'CF46DFB6B6656BE96C5AB5DA78DD7ACB63BEE9FE41D96826B090089EBE81D97EE718B43EEC5DF9C146' +
          'D42AD23217BB7B0A38743265C5E5328AC9BEA667688EABAAB776CB8E2FFD31797FD57AB48BA36CAE8B' +
          '77DA11AFABC0EA40E4FE08DC91C2E2167C1B93584A7412268A9C61129D477DD2C00C0EE78189EDD28E' +
          '6103C36DFB9C22A1DFD533F58857AA8AE918CE30A3124AD475324CAA9C689D734C43739F13E912E903' +
          '4C1C682680305FCE3C9D2B576F884A98A7136B501EEAF944AB0404D75F57FFF33D8E675352EB905230' +
          '8FB2331038A4B2036E68D34CBC178ACA64B44E8A19749AAAF935BA9FA2E582891A43B6EB45FD1D5DC3' +
          'FE8159EBD65B844716A16CB00064838DDB9164DF93D7F1F2F5FE311D7B9196BDCE517D03E3B892F845' +
          '5CA5BE81094E700E98CF9E4DA2C0B66C3D8CE423093088B4B03EF6EECAB596741D9282B4DAE5B3CDE6' +
          'D8564B0F2C86C1B9E23DBD4D9BED3DFDD3B165D9B2D5D0ECEAC3DD68B21BAF5D3499CEEE11D5FF9357' +
          '0FCDC57366AFA606CB6E376746A1FC1FD8AE4FC8' +
        '> EI Q')
        );
      end else
      if (IconType = 6) then
      begin
        AppearanceStream := FStructure.NewStream(
          DeflateStr(TransparencyPrefix + '1 1 1 rg 0 0 10 10 re f Q'));
      end else
      begin
        AppearanceStream := FStructure.NewStream('');
      end;
      AppearanceStream.Dictionary.Add('Filter', FStructure.NewCommonName('FlateDecode'));
      AppearanceStream.Dictionary.Add('Subtype', FStructure.NewCommonName('Form'));
      AppearanceStream.Dictionary.Add('Resources', ResourcesDict);
      AppearanceStream.Dictionary.Add('BBox', FStructure.NewIntArray([0, 0, 10, 10]));
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, AppearanceStream);
      FormRef := FStructure.NewIndirectRef(ObjNum, GenNum);
      AnnotDict.Add('AP', APDict);
      APDict.Add('N', FormRef);
    end else
    if ((IconType >= 3) and (IconType <= 5)) then
    begin
      case IconType of
        3: AnnotDict.Add('Name', FStructure.NewName('Graph'));
        4: AnnotDict.Add('Name', FStructure.NewName('Paperclip'));
        5: AnnotDict.Add('Name', FStructure.NewName('Tag'));
      end;
    end;
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

procedure TPDFPageTree.UsePattern(const CSName: AnsiString;
  CS: TPDFIndRef);
var
  Obj: TPDFObject;
  Patterns: TPDFDictionary;
  Resources: TPDFDictionary;
begin
  Resources := ResourcesDict;
  if Assigned(Resources) then
  begin
    Obj := Resources.FindValueByKeyName('Pattern');

    // No Pattern dictionary, add one
    if not Assigned(Obj) then
    begin
      Obj := FStructure.NewDictionary;
      Resources.Add('Pattern', Obj);
    end;

    // Pattern key is indirect
    if Obj is TPDFIndRef then
      Obj := TPDFIndRef(Obj).Obj;

    // Pattern key is not a dictionary
    if not (Obj is TPDFDictionary) then
    begin
      Resources.DeleteEntryByKeyName('Pattern');
      Obj := FStructure.NewDictionary;
      Resources.Add('Pattern', Obj);
    end;

    if Obj is TPDFDictionary then
    begin
      Patterns := TPDFDictionary(Obj);
      Obj := Patterns.FindValueByKeyName(CSName);

      if not Assigned(Obj) then
        Patterns.Add(CSName, CS);

      if Obj is TPDFIndRef then
      begin
        if (CS.ObjNum <> TPDFIndRef(Obj).ObjNum) or
          (CS.GenNum <> TPDFIndRef(Obj).GenNum) then
        begin
          Patterns.DeleteEntryByKeyName(CSName);
          Patterns.Add(CSName, CS);
        end;
      end;
    end;
  end;
end;

procedure TPDFPageTree.UseShading(const CSName: AnsiString;
  CS: TPDFIndRef);
var
  Obj: TPDFObject;
  Shadings: TPDFDictionary;
  Resources: TPDFDictionary;
begin
  Resources := ResourcesDict;
  if Assigned(Resources) then
  begin
    Obj := Resources.FindValueByKeyName('Shading');

    // No Shading dictionary, add one
    if not Assigned(Obj) then
    begin
      Obj := FStructure.NewDictionary;
      Resources.Add('Shading', Obj);
    end;

    // Shading key is indirect
    if Obj is TPDFIndRef then
      Obj := TPDFIndRef(Obj).Obj;

    // Shading key is not a dictionary
    if not (Obj is TPDFDictionary) then
    begin
      Resources.DeleteEntryByKeyName('Shading');
      Obj := FStructure.NewDictionary;
      Resources.Add('Shading', Obj);
    end;

    if Obj is TPDFDictionary then
    begin
      Shadings := TPDFDictionary(Obj);
      Obj := Shadings.FindValueByKeyName(CSName);

      if not Assigned(Obj) then
        Shadings.Add(CSName, CS);

      if Obj is TPDFIndRef then
      begin
        if (CS.ObjNum <> TPDFIndRef(Obj).ObjNum) or
          (CS.GenNum <> TPDFIndRef(Obj).GenNum) then
        begin
          Shadings.DeleteEntryByKeyName(CSName);
          Shadings.Add(CSName, CS);
        end;
      end;
    end;
  end;
end;

{$IFDEF QPL_D4_TO_D6}
procedure TPDFPageTree.Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
  Strings.Clear;
  while (Pos(Delimiter, Input) > 0) do
  begin
    Strings.Add(Copy(Input, 1, Pos(Delimiter, Input) - 1));
    Delete(Input, 1, Pos(Delimiter, Input));
  end;
  if (Input <> '') then
  begin
    Strings.Add(Input);
  end;
end;
{$ELSE}
procedure TPDFPageTree.Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
   Strings.Clear;
   Strings.Delimiter := Delimiter;
   Strings.DelimitedText := Input;
end;
{$ENDIF}

function TPDFPageTree.RenderPageToDC(DPI: Double; Page, JPEGQuality: Integer;
  GDIPlusSettings: TGDIPlusSettings; TargetDC: HDC;
  var RenderError: AnsiString; RenderCropType, OffsetX, OffsetY: Integer;
  ErasePage: Boolean; OCGStateList: TQPLOCGStateList; Clip: AnsiString): Boolean;
var
  Renderer: TPDFRenderer;
  StrLen: Integer;
  StrList: TStringList;
  I: Integer;
begin
  Renderer := TPDFRenderer.Create(RenderFontCol);
  try
    Renderer.GDIPlusSettings := GDIPlusSettings;
    Renderer.DPI := DPI;
    Renderer.CropType := RenderCropType;
    Renderer.OCGStateList := OCGStateList;
    Renderer.Destination := rdDeviceContext;
    Renderer.SetDeviceContextTarget(TargetDC, ErasePage, OffsetX, OffsetY);
    Renderer.PageDict := GetPage(Page);

    Renderer.ClearInitialClip();

    StrLen := Length(Clip);
    if StrLen > 0 then
    begin
      StrList := TStringList.Create;
      try
        Split(' ', QPLAnsiToNative(Clip), StrList);
        I := 0;
        while I+3 < StrList.Count do
        begin
          Renderer.AddToInitialClip(StrToInt(StrList[I]),
            StrToInt(StrList[I+1]),
            StrToInt(StrList[I+2]),
            StrToInt(StrList[I+3]));
          Inc(I,4);
        end;
      finally
        StrList.Free();
      end;
    end;

    Renderer.Render;
    RenderError := Renderer.ErrorDesc;
  finally
    Renderer.Free;
  end;
  Result := True;
end;

{$IFDEF QPL_CAIRO}
function TPDFPageTree.RenderPageToCairoDC(DPI: Double; Page, JPEGQuality: Integer;
  const CairoFileName: WideString; TargetDC: HDC;
  var RenderError: AnsiString; RenderCropType, OffsetX, OffsetY: Integer;
  ErasePage: Boolean; OCGStateList: TQPLOCGStateList): Boolean;
var
  Renderer: TPDFRenderer;
begin
  Renderer := TPDFRenderer.Create(RenderFontCol);
  try
    Renderer.DPI := DPI;
    Renderer.CropType := RenderCropType;
    Renderer.Destination := rdCairo;
    Renderer.OCGStateList := OCGStateList;

    Renderer.SetCairoTarget(CairoFileName, TargetDC, ErasePage, OffsetX, OffsetY);
    Renderer.PageDict := GetPage(Page);
    Renderer.Render;
    RenderError := Renderer.ErrorDesc;
  finally
    Renderer.Free;
  end;
  Result := True;
end;
{$ENDIF}

{$IFDEF QPL_DPLR}
function TPDFPageTree.RenderPageToDPLRDC(DPI: Double; Page, JPEGQuality: Integer;
  GDIPlusSettings: TGDIPlusSettings;
  const DPLRFileName: WideString; TargetDC: HDC;
  var RenderError: AnsiString; RenderCropType, OffsetX, OffsetY: Integer;
  ErasePage: Boolean; OCGStateList: TQPLOCGStateList; Clip: AnsiString): Boolean;
var
  Renderer: TPDFRenderer;
  UseRenderer : Boolean;
  StrLen: Integer;
  StrList: TStringList;
  I: Integer;
begin
  UseRenderer := False;
  if (Assigned(FRenderer)) then
  begin
    if(FRenderer.DPI = -1) then
    begin
      FRenderer.GDIPlusSettings := GDIPlusSettings;
      FRenderer.DPI := DPI;
      FRenderer.Destination := rdDPLR;
      FRenderer.OCGStateList := OCGStateList;
      FRenderer.SetDPLRTarget(DPLRFileName, TargetDC, ErasePage, OffsetX, OffsetY);
      FRenderer.PageDict := GetPage(Page);
      UseRenderer := True;
    end else
    begin
      if  (FRenderer.Destination = rdDPLR ) and
          (FRenderer.DPI = DPI) and
          (FRenderer.PageDict = GetPage(Page)) and
          (FRenderer.DPLRFileName = DPLRFileName) then
      begin
          FRenderer.SetDPLRTarget(DPLRFileName, TargetDC, ErasePage, OffsetX, OffsetY);
          UseRenderer := True;
      end;
    end;
  end;

  if (UseRenderer) then
  begin
    FRenderer.ClearInitialClip();
    StrLen := Length(Clip);
    if StrLen > 0 then
    begin
      StrList := TStringList.Create;
      try
        Split(' ', QPLAnsiToNative(Clip), StrList);
        I := 0;
        while I+3 < StrList.Count do
        begin
          FRenderer.AddToInitialClip( StrToInt(StrList[I]),
                                      StrToInt(StrList[I+1]),
                                      StrToInt(StrList[I+2]),
                                      StrToInt(StrList[I+3]));
          Inc(I,4);
        end;
      finally
        StrList.Free();
      end;
    end;
    FRenderer.Render;
    RenderError := FRenderer.ErrorDesc;
  end else
  begin
    Renderer := TPDFRenderer.Create(RenderFontCol);
    try
      Renderer.GDIPlusSettings := GDIPlusSettings;
      Renderer.DPI := DPI;
      Renderer.Destination := rdDPLR;
      Renderer.OCGStateList := OCGStateList;
      Renderer.SetDPLRTarget(DPLRFileName, TargetDC, ErasePage, OffsetX, OffsetY);
      Renderer.PageDict := GetPage(Page);

      Renderer.ClearInitialClip();

      StrLen := Length(Clip);
      if StrLen > 0 then
      begin
        StrList := TStringList.Create;
        try
          Split(' ', QPLAnsiToNative(Clip), StrList);
          I := 0;
          while I+3 < StrList.Count do
          begin
            Renderer.AddToInitialClip(StrToInt(StrList[I]),
              StrToInt(StrList[I+1]),
              StrToInt(StrList[I+2]),
              StrToInt(StrList[I+3]));
            Inc(I,4);
          end;
        finally
          StrList.Free();
        end;
      end;

      Renderer.Render;
      RenderError := Renderer.ErrorDesc;
    finally
      Renderer.Free;
    end;
  end;
  Result := True;
end;
{$ENDIF}

procedure TPDFPageTree.AddU3DAnnotation(X, Y, W, H: Double;
  Source: TStream; const Title: AnsiString; Options: Integer);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  SS: AnsiString;
  Stream3D: TPDFStream;
  APDict: TPDFDictionary;
  NStream: TPDFStream;
begin
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('3D'));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y - H, X + W, Y]));
    AnnotDict.Add('Border', FStructure.NewIntArray([0, 0, 0]));
    AnnotDict.Add('F', FStructure.NewNumeric(4));
    AnnotDict.Add('3DA', FStructure.Decode('<</A/PO/DIS/I>>'));
    AnnotDict.Add('3DI', FStructure.NewBoolean((Options and 1) = 1));
    Stream3D := FStructure.NewStream('');
    SetLength(SS, Source.Size);
    Source.Read(SS[1], Length(SS));
    Stream3D.SetTo(SS, True);
    Stream3D.Dictionary.Add('Type', FStructure.NewName('3D'));
    Stream3D.Dictionary.Add('Subtype', FStructure.NewName('U3D'));
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, Stream3D);
    AnnotDict.Add('3DD', FStructure.NewIndirectRef(ObjNum, GenNum));
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
    APDict := FStructure.NewDictionary;
    AnnotDict.Add('AP', APDict);
    NStream := FStructure.NewStream('');
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, NStream);
    APDict.Add('N', FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

function TPDFPageTree.AddLGIDict(const DictContent: AnsiString): Boolean;
var
  FirstObj: TPDFObject;
  NextObj: TPDFObject;
  DictObj: TPDFObject;

  LGIDict: TPDFDictionary;
  Ref: TPDFIndRef;
  FirstRef: TPDFIndRef;
  ObjNum, GenNum: Integer;

  MoveRef: TPDFIndRef;

  X: Integer;
begin
  Result := False;

  LGIDict := nil;
  try
    DictObj := FStructure.Decode(DictContent);
    if DictObj is TPDFDictionary then
      LGIDict := TPDFDictionary(DictObj);
  except
  end;

  if Assigned(LGIDict) then
  begin
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, LGIDict);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);

    FirstObj := FPageDict.FindValueByKeyName('LGIDict');
    if FirstObj is TPDFIndRef then
      NextObj := TPDFIndRef(FirstObj).Obj
    else
      NextObj := FirstObj;

    if NextObj is TPDFArray then
    begin
      // If dictionaries are directly in the array then move them out
      for X := 0 to TPDFArray(NextObj).Count - 1 do
      begin
        if TPDFArray(NextObj).Item[X] is TPDFDictionary then
        begin
          FStructure.OnNewIndObj(Self, ObjNum, GenNum, TPDFArray(NextObj).Item[X]);
          MoveRef := FStructure.NewIndirectRef(ObjNum, GenNum);
          TPDFArray(NextObj).ReplaceNoKill(X, MoveRef);
        end;
      end;

      // Add the new dictionary ref to the existing array
      TPDFArray(NextObj).Add(Ref);
      Result := True;
    end else
    if NextObj is TPDFDictionary then
    begin
      if FirstObj is TPDFDictionary then
      begin
        // Create a ref for the existing dict then
        // create an array holding the ref to the existing
        // dict as well as the ref to the new dict
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, LGIDict);
        FirstRef := FStructure.NewIndirectRef(ObjNum, GenNum);
        FPageDict.DeleteEntryByKeyName('LGIDict');
        FPageDict.Add('LGIDict', FStructure.NewArray([FirstRef, Ref]));
        Result := True;
      end else
      if FirstObj is TPDFIndRef then
      begin
        // Create an array holding the existing ref as
        // well as the ref to the new dict
        FPageDict.DeleteEntryByKeyName('LGIDict');
        FPageDict.Add('LGIDict', FStructure.NewArray([FirstObj, Ref]));
        Result := True;
      end;
    end else
    begin
      FPageDict.DeleteEntryByKeyName('LGIDict');
      FPageDict.Add('LGIDict', FStructure.NewArray([Ref]));
      Result := True;
    end;
  end;
end;

function TPDFPageTree.DeleteLGIDict(Index: Integer): Boolean;
var
  FirstObj: TPDFObject;
  NextObj: TPDFObject;
begin
  Result := False;
  FirstObj := FPageDict.FindValueByKeyName('LGIDict');
  if FirstObj is TPDFIndRef then
    NextObj := TPDFIndRef(FirstObj).Obj
  else
    NextObj := FirstObj;

  if NextObj is TPDFArray then
  begin
    if (Index = 0) and (TPDFArray(NextObj).Count = 1) then
    begin
      FPageDict.DeleteEntryByKeyName('LGIDict');
      Result := True;
    end else
    if (Index >= 0) and (Index < TPDFArray(NextObj).Count) then
    begin
      TPDFArray(NextObj).Delete(Index);
      Result := True;
    end;
  end else
  if ((Index = 0) and (NextObj is TPDFDictionary)) then
  begin
    FPageDict.DeleteEntryByKeyName('LGIDict');
    Result := True;
  end;
end;

function TPDFPageTree.GetLGIDictContent(Index: Integer): AnsiString;
var
  FirstObj: TPDFObject;
  NextObj: TPDFObject;
  DictObj: TPDFObject;
begin
  Result := '';
  FirstObj := FPageDict.FindValueByKeyName('LGIDict');
  if FirstObj is TPDFIndRef then
    NextObj := TPDFIndRef(FirstObj).Obj
  else
    NextObj := FirstObj;

  DictObj := nil;
  if NextObj is TPDFArray then
  begin
    if (Index >= 0) and (Index < TPDFArray(NextObj).Count) then
    begin
      if TPDFArray(NextObj).Item[Index] is TPDFIndRef then
      begin
        DictObj := TPDFIndRef(TPDFArray(NextObj).Item[Index]).Obj;
      end else
      if TPDFArray(NextObj).Item[Index] is TPDFDictionary then
      begin
        DictObj := TPDFDictionary(TPDFArray(NextObj).Item[Index]);
      end;
    end;
  end else
  if NextObj is TPDFDictionary then
  begin
    DictObj := NextObj;
  end;

  if Assigned(DictObj) then
    Result := DictObj.Output;
end;

function TPDFPageTree.GetLGIDictCount: Integer;
var
  FirstObj: TPDFObject;
  NextObj: TPDFObject;
begin
  Result := 0;
  FirstObj := FPageDict.FindValueByKeyName('LGIDict');
  if FirstObj is TPDFIndRef then
    NextObj := TPDFIndRef(FirstObj).Obj
  else
    NextObj := FirstObj;

  if NextObj is TPDFArray then
  begin
    Result := TPDFArray(NextObj).Count;
  end else
  if NextObj is TPDFDictionary then
  begin
    Result := 1;
  end;
end;

function TPDFPageTree.DeleteAnnotation(Index: Integer): Boolean;
var
  Obj: TPDFObject;
begin
  Result := False;
  if Assigned(FPageDict) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots', True);
    if Obj is TPDFArray then
    begin
      if TPDFArray(Obj).Count = 1 then
      begin
        FPageDict.DeleteEntryByKeyName('Annots');
        Result := True;
        FAnnots.Clear;
      end else
      begin
        if (Index >= 0) and (Index < TPDFArray(Obj).Count) then
          TPDFArray(Obj).Delete(Index);
        Result := True;
        FAnnots.Attach(TPDFArray(Obj));
      end;
    end else
      FAnnots.Clear;
  end;
end;

function TPDFPageTree.FindPage(PageRef: TPDFIndRef): Integer;
var
  Obj: TPDFObject;
  PP: Integer;
  PagesArray: TPDFArray;
  TestRef: TPDFIndRef;
begin
  Result := 0;
  Obj := FPagesDict.FindValueByKeyName('Kids', True);
  if Obj is TPDFArray then
  begin
    PagesArray := TPDFArray(Obj);
    if PagesArray.Count = GetPageCount then
    begin
      for PP := 1 to PagesArray.Count do
      begin
        if (PagesArray.Item[PP - 1] is TPDFIndRef) then
        begin
          TestRef := TPDFIndRef(PagesArray.Item[PP - 1]);
          if (TestRef.ObjNum = PageRef.ObjNum) and (TestRef.GenNum = PageRef.GenNum) then
          begin
            Result := PP;
            Break;
          end;
        end;
      end;
    end;

    if Result = 0 then
    begin
      if Assigned(FOnFindPage) then
      begin
        Result := FOnFindPage(PageRef);
      end;
    end;
  end;
end;

procedure TPDFPageTree.SetPageBoxProperties(const BoxName: AnsiString;
  Left, Top, Width, Height: Double);
var
  Obj: TPDFObject;
  R: TPDFRectangle;
  A: TPDFArray;
begin
  Obj := FPageDict.FindValueByKeyName(BoxName, True);

  if Assigned(Obj) and (Obj is TPDFArray) then
  begin
    A := TPDFArray(Obj);
    R := TPDFRectangle.Create(A);
    try
      if not R.IsRectangle then
      begin
        A := FStructure.NewDoubleArray([0, 0, 0, 0]);
        FPageDict.Add(BoxName, A);
      end;
    finally
      R.Free;
    end;
  end else
  begin
    A := FStructure.NewDoubleArray([0, 0, 0, 0]);
    FPageDict.Add(BoxName, A);
  end;

  R := TPDFRectangle.Create(A);
  try
    R.Left := Left;
    R.Top := Top;
    R.Right := Left + Width;
    R.Bottom := Top - Height;
  finally
    R.Free;
  end;
end;

function TPDFPageTree.GetPageRef(PageNumber: Integer): TPDFIndRef;
var
  OldPage: Integer;
begin
  OldPage := Page;
  GetPage(PageNumber);
  Result := FPagePointer;
  GetPage(OldPage);
end;

function TPDFPageTree.GetViewPort(Index: Integer): TPDFDictionary;
var
  Obj: TPDFObject;
begin
  Result := nil;
  if (Assigned(FPageDict)) then
  begin
    Obj := FPageDict.FindValueByKeyName('VP', True);
    if (Obj is TPDFArray) then
    begin
      if ((Index >= 0) and (Index < TPDFArray(Obj).Count)) then
      begin
        Obj := TPDFArray(Obj).Item[Index];
        if (Obj is TPDFDictionary) then
        begin
          Result := TPDFDictionary(Obj);
        end else
        if (Obj is TPDFIndRef) then
        begin
          Obj := TPDFIndRef(Obj).Obj;
          if (Obj is TPDFDictionary) then
          begin
            Result := TPDFDictionary(Obj);
          end;
        end;
      end;
    end;
  end;
end;

function TPDFPageTree.GetViewPortCount: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  if (Assigned(FPageDict)) then
  begin
    Obj := FPageDict.FindValueByKeyName('VP', True);
    if (Obj is TPDFArray) then
    begin
      Result := TPDFArray(Obj).Count;
    end;
  end;
end;

procedure TPDFPageTree.AddLinkToLocalFile(X, Y, W, H: Double;
  const FileName: WideString; Options: Integer);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  BorderWidth: Integer;
  AnsiFileName: AnsiString;
  FDict: TPDFDictionary;
begin
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('Link'));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + W, Y - H]));

    if (Options and 1) = 1 then
      BorderWidth := 1
    else
      BorderWidth := 0;

    AnnotDict.Add('Border', FStructure.NewDoubleArray([0, 0, BorderWidth]));

    ActionDict := FStructure.NewDictionary;
    ActionDict.Add('Type', FStructure.NewName('Action'));
    ActionDict.Add('S', FStructure.NewName('Launch'));

    if (Options and 2) = 2 then
    begin
      ActionDict.Add('NewWindow', FStructure.NewBoolean(True));
    end else
    begin
      ActionDict.Add('NewWindow', FStructure.NewBoolean(False));
    end;

    FDict := FStructure.NewDictionary;
    ActionDict.Add('F', FDict);

    AnsiFileName := QPLWideStringToAnsiString(FileName);
    FDict.Add('UF', FStructure.NewTextString(FileName));
    FDict.Add('F', FStructure.NewString(AnsiFileName));

    AnnotDict.Add('A', ActionDict);

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

procedure TPDFPageTree.AddTextMarkupAnnotation(X, Y, W, H: Double;
  MarkupType: Integer);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
begin
  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    case MarkupType of
      1: AnnotDict.Add('Subtype', FStructure.NewName('Highlight'));
      2: AnnotDict.Add('Subtype', FStructure.NewName('Underline'));
      3: AnnotDict.Add('Subtype', FStructure.NewName('Squiggly'));
      4: AnnotDict.Add('Subtype', FStructure.NewName('StrikeOut'));
    end;
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y - H, X + W, Y]));
    AnnotDict.Add('QuadPoints', FStructure.NewDoubleArray(
      [X, Y, X + W, Y, X, Y - H, X + W, Y - H]));
    AnnotDict.Add('C', FStructure.NewDoubleArray([1, 1, 0.22]));
    AnnotDict.Add('Border', FStructure.NewDoubleArray([0, 0, 1]));
    AnnotDict.Add('CA', FStructure.NewNumeric(0.8));
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

function TPDFPageTree.CreatePageRef(PageNum: Integer): TPDFIndRef;
var
  DestPage: TPDFDictionary;
begin
  try
    DestPage := GetPage(PageNum);
  except
    DestPage := nil;
  end;
  if (Assigned(DestPage)) then
  begin
    Result := FStructure.NewIndirectRef(DestPage.IndObjNum, DestPage.IndGenNum);
  end else
  begin
    Result := nil;
  end;
end;

procedure TPDFPageTree.AddLinkToDestination(X, Y, W, H: Double;
  Dest: TPDFArray; Options: Integer);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  BorderWidth: Integer;
begin
  if Assigned(FStructure.OnNewIndObj) and Assigned(Dest) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;
    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('Link'));
    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y, X + W, Y - H]));

    if (Options and 1) = 1 then
      BorderWidth := 1
    else
      BorderWidth := 0;
    AnnotDict.Add('Border', FStructure.NewDoubleArray([0, 0, BorderWidth]));

    if (Dest.IndObjNum > 0) then
    begin
      AnnotDict.Add('Dest', FStructure.NewIndirectRef(Dest.IndObjNum,
        Dest.IndGenNum));
    end else
    begin
      AnnotDict.Add('Dest', FStructure.Decode(Dest.Output));
    end;

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

procedure TPDFPageTree.AddFreeTextAnnotationEx(X, Y: Double;
  Width, Height: Double; const Text: WideString; Options: Integer; Angle: Integer = 0; Transparency: Integer = 0);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict, BSDict, APDict, ResDict, R0Dict, ExtGStateDict, Temp: TPDFDictionary;
  //FontListDict: TPDFDictionary;
  FontDict, HelvDict: TPDFDictionary;
  ProcArray: TPDFArray;
  Ref: TPDFIndRef;
  N, MWFOFormStream, FormStream: TPDFStream;
  DA: array of Double;
  ObjNum: Integer;
  GenNum: Integer;
  S, S1: AnsiString;
  C1, C2, C3, C4: Double;
  I, P1, P2: Integer;
  DAString, DSString: AnsiString;
  TempPainter: TPDFPainter;
  TempContent: AnsiString;
  BorderWidth: Double;
  BoxWidth, BoxHeight: Double;
  Extra: Double;
  TranspPer: Integer;
begin
  TranspPer := Transparency;
  if (TranspPer > 100) then
    TranspPer := 100;
  if (TranspPer < 0) then
    TranspPer := 0;

  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;

    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('FreeText'));
    AnnotDict.Add('Subj', FStructure.NewName('Text Box'));
    AnnotDict.Add('F', FStructure.NewNumeric(4));
    AnnotDict.Add('Rotate', FStructure.NewNumeric(Angle));
    AnnotDict.Add('CA', FStructure.NewNumeric((100-TranspPer)/100));

    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y- Height, X + Width , Y]));
    AnnotDict.Add('CreationDate', FStructure.NewString(GetPDFDateTime));

    // Now extract the current drawing styles from Painter.
    S := FPainter.FillColor;
    if (GetTokCount(S, ' ') = 2) then  // DeviceGray: 0.5 g
    begin
      C1 := TazzToFloat(GetTok(S, ' ' , 1));
      AnnotDict.Add('C', FStructure.NewDoubleArray([C1]));
    end
    else
    if (GetTokCount(S, ' ') = 4) then  // RGB: 1 1 1 RG
    begin
      C1 := TazzToFloat(GetTok(S, ' ' , 1));
      C2 := TazzToFloat(GetTok(S, ' ' , 2));
      C3 := TazzToFloat(GetTok(S, ' ' , 3));
      AnnotDict.Add('C', FStructure.NewDoubleArray([C1, C2, C3]));
    end
    else
    if (GetTokCount(S, ' ') = 5) then  // CMYK: 0 0 0 1 K
    begin
      C1 := TazzToFloat(GetTok(S, ' ' , 1));
      C2 := TazzToFloat(GetTok(S, ' ' , 2));
      C3 := TazzToFloat(GetTok(S, ' ' , 3));
      C4 := TazzToFloat(GetTok(S, ' ' , 4));
      AnnotDict.Add('C', FStructure.NewDoubleArray([C1, C2, C3, C4]));
    end;

    BSDict := FStructure.NewDictionary;

    S := FPainter.LineDash;
    P1 := QPLPos('[', S);
    P2 := QPLPos(']', S);
    S1 := QPLCopy(S, P1 + 1, P2 - 2);
    S1 := QPLTrim(S1);

    if (Length(S1) > 0) then
    begin
      SetLength(DA, GetTokCount(S1, ' '));
      for I := 1 to GetTokCount(S1, ' ') do
        DA[I-1] := TazzToFloat(GetTok(S1, ' ' , I));
      BSDict.Add('D', FStructure.NewDoubleArray(DA));
      BSDict.Add('S', FStructure.NewName('D'));
    end
    else
      BSDict.Add('S', FStructure.NewName('S'));

    if ((Options = 0) or (Options = 2)) then
    begin
      BorderWidth := Painter.GetLineWidth;
      BSDict.Add('W', FStructure.NewNumeric(Painter.GetLineWidth));
      AnnotDict.Add('BS', BSDict);
    end else
    begin
      BorderWidth := 0;
      BSDict.Add('W', FStructure.NewNumeric(0));
      AnnotDict.Add('BS', BSDict);
    end;

    AnnotDict.Add('Contents', FStructure.NewTextString(Text));

    case (Painter.TextAlign) of
      paCenter:    AnnotDict.Add('Q', FStructure.NewNumeric(1));
      paRight:     AnnotDict.Add('Q', FStructure.NewNumeric(2));
      else
        AnnotDict.Add('Q', FStructure.NewNumeric(0));
    end;

    // ADC : Hardcoding to Helvetica.
    DAString := FPainter.LineColor + ' ' + FPainter.TextColor + ' 0 Tc 0 Tw 0 TL /' + FPainter.SelFont.Name + ' ' + QPLDoubleToStrConst(FPainter.TextSize, 2) + ' Tf';
    AnnotDict.Add('DA', FStructure.NewString(DAString));

    //font: Helvetica,sans-serif 12.0pt; text-align:left; color:#FF0000
    DSString := 'font: ' + 'Helvetica' + ',sans-serif ' + QPLDoubleToStrConst(FPainter.TextSize, 1) + 'pt; text-align:';
    case (Painter.TextAlign) of
      paCenter:    DSString := DSString + 'center; ';
      paRight:     DSString := DSString + 'right; ';
      else
        DSString := DSString + 'left; ';
    end;
    DSString := DSString + 'color:' + FPainter.HexColorLine;
    AnnotDict.Add('DS', FStructure.NewString(DSString));

    APDict := FStructure.NewDictionary;

    N := FStructure.NewStream('');
    N.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, Width , Height]));
    N.Dictionary.Add('FormType', FStructure.NewNumeric(1));
    N.Dictionary.Add('Matrix', FStructure.NewDoubleArray([1.0, 0, 0, 1.0, 0, 0]));
    N.Dictionary.Add('Subtype', FStructure.NewName('Form'));
    N.Dictionary.Add('Type', FStructure.NewName('XObject'));

    TempPainter := TPDFPainter.Create(nil);
    try
      TempPainter.SetState(FPainter.GetState);

      // Now extract the current drawing styles from Painter.
      S := FPainter.TextColor;
      if (GetTokCount(S, ' ') = 2) then  // DeviceGray: 0.5 g
      begin
        C1 := TazzToFloat(GetTok(S, ' ' , 1));
        TempPainter.SetLineColor(C1, C1, C1);
      end
      else
      if (GetTokCount(S, ' ') = 4) then  // RGB: 1 1 1 RG
      begin
        C1 := TazzToFloat(GetTok(S, ' ' , 1));
        C2 := TazzToFloat(GetTok(S, ' ' , 2));
        C3 := TazzToFloat(GetTok(S, ' ' , 3));
        TempPainter.SetLineColor(C1, C2, C3);
      end
      else
      if (GetTokCount(S, ' ') = 5) then  // CMYK: 0 0 0 1 K
      begin
        C1 := TazzToFloat(GetTok(S, ' ' , 1));
        C2 := TazzToFloat(GetTok(S, ' ' , 2));
        C3 := TazzToFloat(GetTok(S, ' ' , 3));
        C4 := TazzToFloat(GetTok(S, ' ' , 4));
        TempPainter.SetLineColor(C1, C2, C3, C4);
      end;

      if ((Angle div 90) mod 2 = 0) then
      begin
        BoxWidth := Width;
        BoxHeight := Height;
      end
      else
      begin
        BoxWidth := Height;
        BoxHeight := Width;
      end;

      TempPainter.SaveState();
      if Angle = 90 then TempPainter.Rotate(Width, 0, 90);
      if Angle = 180 then TempPainter.Rotate(Width, Height, 180);
      if Angle = 270 then TempPainter.Rotate(0, Height, 270);

      if (BorderWidth = 0) then
        BorderWidth := 2;

      // Doesn't match up with  TPDFPainter.DrawWrappedText but it works much better.
      Extra := TempPainter.TextAscent + TempPainter.TextDescent + 2;

      TempPainter.DrawWrappedWideText(
                 BorderWidth * 2,
                 BoxHeight - BorderWidth * 2 - Extra,
                 BoxWidth - BorderWidth * 4,
                 Text, #13#10);

      TempContent := TempPainter.Source;
      TempPainter.LoadState();

      TempPainter.SetSource('');
      TempPainter.Add(Painter.FillColor);
      TempPainter.Add(Painter.LineColor);
      TempPainter.Add(Painter.TheLineWidthLine);
      if (Options = 1) then
      begin
        TempPainter.Rectangle(BorderWidth / 2, Height - BorderWidth / 2, Width - BorderWidth, Height - BorderWidth, True, False);
      end else
      if (Options = 2) then
      begin
        TempPainter.Rectangle(BorderWidth / 2, Height - BorderWidth / 2 , Width - BorderWidth, Height - BorderWidth, True, True);
      end;

      //N.SetTo('/Tx BMC q ' + TempPainter.Source + DAString + ' ' + TempContent + ' Q EMC', False);
      N.SetTo('/R0 gs ' + '/MWFOForm Do ', false);
    //finally
    //  TempPainter.Free;
    //end;

    //N-Resources
    ResDict := FStructure.NewDictionary;
    ProcArray := FStructure.NewArray;
    ProcArray.Add(FStructure.NewName('PDF'));
    ResDict.Add('ProcSet', ProcArray);

    ExtGStateDict:= FStructure.NewDictionary;
    R0Dict := FStructure.NewDictionary;
    R0Dict.Add('AIS', FStructure.NewBoolean(false));
    R0Dict.Add('CA', FStructure.NewNumeric((100-TranspPer)/100));
    R0Dict.Add('ca', FStructure.NewNumeric((100-TranspPer)/100));
    R0Dict.Add('Type', FStructure.NewName('ExtGState'));

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, R0Dict);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);
    ExtGStateDict.Add('R0', Ref);

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, ExtGStateDict);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);
    ResDict.Add('ExtGState', Ref);

    MWFOFormStream := FStructure.NewStream('');
    MWFOFormStream.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, Width , Height]));
    MWFOFormStream.Dictionary.Add('FormType', FStructure.NewNumeric(1));
    Temp := FStructure.NewDictionary;
    Temp.Add('S', FStructure.NewName('Transparency'));
    MWFOFormStream.Dictionary.Add('Group', Temp);
    MWFOFormStream.Dictionary.Add('Matrix', FStructure.NewDoubleArray([1.0, 0, 0, 1.0, 0, 0]));
    MWFOFormStream.Dictionary.Add('Subtype', FStructure.NewName('Form'));
    MWFOFormStream.Dictionary.Add('Type', FStructure.NewName('XObject'));
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, MWFOFormStream);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);
    Temp := FStructure.NewDictionary;
    Temp.Add('MWFOForm', Ref);
    ResDict.Add('XObject', Temp);

    N.Dictionary.Add('Resources', ResDict);
    //end N-Resources

    //MWFOForm-Resources
    MWFOFormStream.SetTo('/Form Do ', false);
    ResDict := FStructure.NewDictionary;
    ProcArray := FStructure.NewArray;
    ProcArray.Add(FStructure.NewName('PDF'));
    ResDict.Add('ProcSet', ProcArray);

    FormStream := FStructure.NewStream('');
    FormStream.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, Width , Height]));
    FormStream.Dictionary.Add('FormType', FStructure.NewNumeric(1));
    FormStream.Dictionary.Add('Matrix', FStructure.NewDoubleArray([1.0, 0, 0, 1.0, 0, 0]));
    FormStream.Dictionary.Add('Subtype', FStructure.NewName('Form'));
    FormStream.Dictionary.Add('Type', FStructure.NewName('XObject'));
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, FormStream);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);
    Temp := FStructure.NewDictionary;
    Temp.Add('Form', Ref);
    ResDict.Add('XObject', Temp);

    MWFOFormStream.Dictionary.Add('Resources', ResDict);
    FormStream.SetTo('/Tx BMC q ' + TempPainter.Source + DAString + ' ' + TempContent + ' Q EMC', False);
    ResDict := FStructure.NewDictionary;
    ProcArray := FStructure.NewArray;
    ProcArray.Add(FStructure.NewName('PDF'));
    ProcArray.Add(FStructure.NewName('Text'));
    ResDict.Add('ProcSet', ProcArray);

    FontDict := FStructure.NewDictionary;
    ResDict.Add('Font', FontDict);

    HelvDict := FStructure.NewDictionary;
    HelvDict.Add('BaseFont', FStructure.NewName('Helvetica'));
    HelvDict.Add('Name', FStructure.NewName('Helv'));
    HelvDict.Add('Encoding', FStructure.NewName('WinAnsiEncoding'));
    HelvDict.Add('Subtype', FStructure.NewName('Type1'));
    HelvDict.Add('Type', FStructure.NewName('Font'));

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, HelvDict);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);
    FontDict.Add('Helv', Ref);

    FormStream.Dictionary.Add('Resources', ResDict);
    //end Form-Resources

    finally
      TempPainter.Free;
    end;


    FStructure.OnNewIndObj(Self, ObjNum, GenNum, N);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);

    AnnotDict.Add('AP', APDict);
    APDict.Add('N', Ref);

    // '<?xml version="1.0" encoding="UTF-8"?><body xfa:APIVersion="Acrobat:9.0.0" xmlns="http://www.w3.org/1999/xhtml" style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right" xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/" xfa:spec="2.0.2"><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right">This is a</span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right"> line of text</span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right">.&#13;</span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right">This is the </span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right">2nd line</span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right"> of text.</span></p></body>'
    {
    AnnotDict.Add('T', FStructure.NewTextString(Title));
    }

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;
{
procedure TPDFPageTree.AddLineAnnotation(startX, startY, endX, EndY: Double; Transparency: Integer = 0);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict, BSDict, APDict, ResDict, R0Dict, ExtGStateDict, Temp: TPDFDictionary;
  //FontListDict: TPDFDictionary;
  FontDict, HelvDict: TPDFDictionary;
  ProcArray: TPDFArray;
  Ref: TPDFIndRef;
  N, MWFOFormStream, FormStream: TPDFStream;
  DA: array of Double;
  ObjNum: Integer;
  GenNum: Integer;
  S, S1: AnsiString;
  C1, C2, C3, C4: Double;
  I, P1, P2: Integer;
  DAString, DSString: AnsiString;
  TempPainter: TPDFPainter;
  TempContent: AnsiString;
  BorderWidth: Double;
  BoxWidth, BoxHeight: Double;
  Extra: Double;
  TranspPer: Integer;
begin
  TranspPer := Transparency;
  if (TranspPer > 100) then
    TranspPer := 100;
  if (TranspPer < 0) then
    TranspPer := 0;

  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;

    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('FreeText'));
    AnnotDict.Add('Subj', FStructure.NewName('Text Box'));
    AnnotDict.Add('F', FStructure.NewNumeric(4));
    AnnotDict.Add('Rotate', FStructure.NewNumeric(Angle));
    AnnotDict.Add('CA', FStructure.NewNumeric((100-TranspPer)/100));

    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y- Height, X + Width , Y]));
    AnnotDict.Add('CreationDate', FStructure.NewString(GetPDFDateTime));

    // Now extract the current drawing styles from Painter.
    S := FPainter.FillColor;
    if (GetTokCount(S, ' ') = 2) then  // DeviceGray: 0.5 g
    begin
      C1 := TazzToFloat(GetTok(S, ' ' , 1));
      AnnotDict.Add('C', FStructure.NewDoubleArray([C1]));
    end
    else
    if (GetTokCount(S, ' ') = 4) then  // RGB: 1 1 1 RG
    begin
      C1 := TazzToFloat(GetTok(S, ' ' , 1));
      C2 := TazzToFloat(GetTok(S, ' ' , 2));
      C3 := TazzToFloat(GetTok(S, ' ' , 3));
      AnnotDict.Add('C', FStructure.NewDoubleArray([C1, C2, C3]));
    end
    else
    if (GetTokCount(S, ' ') = 5) then  // CMYK: 0 0 0 1 K
    begin
      C1 := TazzToFloat(GetTok(S, ' ' , 1));
      C2 := TazzToFloat(GetTok(S, ' ' , 2));
      C3 := TazzToFloat(GetTok(S, ' ' , 3));
      C4 := TazzToFloat(GetTok(S, ' ' , 4));
      AnnotDict.Add('C', FStructure.NewDoubleArray([C1, C2, C3, C4]));
    end;

    BSDict := FStructure.NewDictionary;

    S := FPainter.LineDash;
    P1 := QPLPos('[', S);
    P2 := QPLPos(']', S);
    S1 := QPLCopy(S, P1 + 1, P2 - 2);
    S1 := QPLTrim(S1);

    if (Length(S1) > 0) then
    begin
      SetLength(DA, GetTokCount(S1, ' '));
      for I := 1 to GetTokCount(S1, ' ') do
        DA[I-1] := TazzToFloat(GetTok(S1, ' ' , I));
      BSDict.Add('D', FStructure.NewDoubleArray(DA));
      BSDict.Add('S', FStructure.NewName('D'));
    end
    else
      BSDict.Add('S', FStructure.NewName('S'));

    if ((Options = 0) or (Options = 2)) then
    begin
      BorderWidth := Painter.GetLineWidth;
      BSDict.Add('W', FStructure.NewNumeric(Painter.GetLineWidth));
      AnnotDict.Add('BS', BSDict);
    end else
    begin
      BorderWidth := 0;
      BSDict.Add('W', FStructure.NewNumeric(0));
      AnnotDict.Add('BS', BSDict);
    end;

    AnnotDict.Add('Contents', FStructure.NewTextString(Text));

    case (Painter.TextAlign) of
      paCenter:    AnnotDict.Add('Q', FStructure.NewNumeric(1));
      paRight:     AnnotDict.Add('Q', FStructure.NewNumeric(2));
      else
        AnnotDict.Add('Q', FStructure.NewNumeric(0));
    end;

    // ADC : Hardcoding to Helvetica.
    DAString := FPainter.LineColor + ' ' + FPainter.TextColor + ' 0 Tc 0 Tw 0 TL /' + FPainter.SelFont.Name + ' ' + QPLDoubleToStrConst(FPainter.TextSize, 2) + ' Tf';
    AnnotDict.Add('DA', FStructure.NewString(DAString));

    //font: Helvetica,sans-serif 12.0pt; text-align:left; color:#FF0000
    DSString := 'font: ' + 'Helvetica' + ',sans-serif ' + QPLDoubleToStrConst(FPainter.TextSize, 1) + 'pt; text-align:';
    case (Painter.TextAlign) of
      paCenter:    DSString := DSString + 'center; ';
      paRight:     DSString := DSString + 'right; ';
      else
        DSString := DSString + 'left; ';
    end;
    DSString := DSString + 'color:' + FPainter.HexColorLine;
    AnnotDict.Add('DS', FStructure.NewString(DSString));

    APDict := FStructure.NewDictionary;

    N := FStructure.NewStream('');
    N.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, Width , Height]));
    N.Dictionary.Add('FormType', FStructure.NewNumeric(1));
    N.Dictionary.Add('Matrix', FStructure.NewDoubleArray([1.0, 0, 0, 1.0, 0, 0]));
    N.Dictionary.Add('Subtype', FStructure.NewName('Form'));
    N.Dictionary.Add('Type', FStructure.NewName('XObject'));

    TempPainter := TPDFPainter.Create(nil);
    try
      TempPainter.SetState(FPainter.GetState);

      // Now extract the current drawing styles from Painter.
      S := FPainter.TextColor;
      if (GetTokCount(S, ' ') = 2) then  // DeviceGray: 0.5 g
      begin
        C1 := TazzToFloat(GetTok(S, ' ' , 1));
        TempPainter.SetLineColor(C1, C1, C1);
      end
      else
      if (GetTokCount(S, ' ') = 4) then  // RGB: 1 1 1 RG
      begin
        C1 := TazzToFloat(GetTok(S, ' ' , 1));
        C2 := TazzToFloat(GetTok(S, ' ' , 2));
        C3 := TazzToFloat(GetTok(S, ' ' , 3));
        TempPainter.SetLineColor(C1, C2, C3);
      end
      else
      if (GetTokCount(S, ' ') = 5) then  // CMYK: 0 0 0 1 K
      begin
        C1 := TazzToFloat(GetTok(S, ' ' , 1));
        C2 := TazzToFloat(GetTok(S, ' ' , 2));
        C3 := TazzToFloat(GetTok(S, ' ' , 3));
        C4 := TazzToFloat(GetTok(S, ' ' , 4));
        TempPainter.SetLineColor(C1, C2, C3, C4);
      end;

      if ((Angle div 90) mod 2 = 0) then
      begin
        BoxWidth := Width;
        BoxHeight := Height;
      end
      else
      begin
        BoxWidth := Height;
        BoxHeight := Width;
      end;

      TempPainter.SaveState();
      if Angle = 90 then TempPainter.Rotate(Width, 0, 90);
      if Angle = 180 then TempPainter.Rotate(Width, Height, 180);
      if Angle = 270 then TempPainter.Rotate(0, Height, 270);

      if (BorderWidth = 0) then
        BorderWidth := 2;

      // Doesn't match up with  TPDFPainter.DrawWrappedText but it works much better.
      Extra := TempPainter.TextAscent + TempPainter.TextDescent + 2;

      TempPainter.DrawWrappedWideText(
                 BorderWidth * 2,
                 BoxHeight - BorderWidth * 2 - Extra,
                 BoxWidth - BorderWidth * 4,
                 Text, #13#10);

      TempContent := TempPainter.Source;
      TempPainter.LoadState();

      TempPainter.SetSource('');
      TempPainter.Add(Painter.FillColor);
      TempPainter.Add(Painter.LineColor);
      TempPainter.Add(Painter.TheLineWidthLine);
      if (Options = 1) then
      begin
        TempPainter.Rectangle(BorderWidth / 2, Height - BorderWidth / 2, Width - BorderWidth, Height - BorderWidth, True, False);
      end else
      if (Options = 2) then
      begin
        TempPainter.Rectangle(BorderWidth / 2, Height - BorderWidth / 2 , Width - BorderWidth, Height - BorderWidth, True, True);
      end;

      //N.SetTo('/Tx BMC q ' + TempPainter.Source + DAString + ' ' + TempContent + ' Q EMC', False);
      N.SetTo('/R0 gs ' + '/MWFOForm Do ', false);
    //finally
    //  TempPainter.Free;
    //end;

    //N-Resources
    ResDict := FStructure.NewDictionary;
    ProcArray := FStructure.NewArray;
    ProcArray.Add(FStructure.NewName('PDF'));
    ResDict.Add('ProcSet', ProcArray);

    ExtGStateDict:= FStructure.NewDictionary;
    R0Dict := FStructure.NewDictionary;
    R0Dict.Add('AIS', FStructure.NewBoolean(false));
    R0Dict.Add('CA', FStructure.NewNumeric((100-TranspPer)/100));
    R0Dict.Add('ca', FStructure.NewNumeric((100-TranspPer)/100));
    R0Dict.Add('Type', FStructure.NewName('ExtGState'));

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, R0Dict);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);
    ExtGStateDict.Add('R0', Ref);

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, ExtGStateDict);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);
    ResDict.Add('ExtGState', Ref);

    MWFOFormStream := FStructure.NewStream('');
    MWFOFormStream.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, Width , Height]));
    MWFOFormStream.Dictionary.Add('FormType', FStructure.NewNumeric(1));
    Temp := FStructure.NewDictionary;
    Temp.Add('S', FStructure.NewName('Transparency'));
    MWFOFormStream.Dictionary.Add('Group', Temp);
    MWFOFormStream.Dictionary.Add('Matrix', FStructure.NewDoubleArray([1.0, 0, 0, 1.0, 0, 0]));
    MWFOFormStream.Dictionary.Add('Subtype', FStructure.NewName('Form'));
    MWFOFormStream.Dictionary.Add('Type', FStructure.NewName('XObject'));
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, MWFOFormStream);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);
    Temp := FStructure.NewDictionary;
    Temp.Add('MWFOForm', Ref);
    ResDict.Add('XObject', Temp);

    N.Dictionary.Add('Resources', ResDict);
    //end N-Resources

    //MWFOForm-Resources
    MWFOFormStream.SetTo('/Form Do ', false);
    ResDict := FStructure.NewDictionary;
    ProcArray := FStructure.NewArray;
    ProcArray.Add(FStructure.NewName('PDF'));
    ResDict.Add('ProcSet', ProcArray);

    FormStream := FStructure.NewStream('');
    FormStream.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, Width , Height]));
    FormStream.Dictionary.Add('FormType', FStructure.NewNumeric(1));
    FormStream.Dictionary.Add('Matrix', FStructure.NewDoubleArray([1.0, 0, 0, 1.0, 0, 0]));
    FormStream.Dictionary.Add('Subtype', FStructure.NewName('Form'));
    FormStream.Dictionary.Add('Type', FStructure.NewName('XObject'));
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, FormStream);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);
    Temp := FStructure.NewDictionary;
    Temp.Add('Form', Ref);
    ResDict.Add('XObject', Temp);

    MWFOFormStream.Dictionary.Add('Resources', ResDict);
    FormStream.SetTo('/Tx BMC q ' + TempPainter.Source + DAString + ' ' + TempContent + ' Q EMC', False);
    ResDict := FStructure.NewDictionary;
    ProcArray := FStructure.NewArray;
    ProcArray.Add(FStructure.NewName('PDF'));
    ProcArray.Add(FStructure.NewName('Text'));
    ResDict.Add('ProcSet', ProcArray);

    FontDict := FStructure.NewDictionary;
    ResDict.Add('Font', FontDict);

    HelvDict := FStructure.NewDictionary;
    HelvDict.Add('BaseFont', FStructure.NewName('Helvetica'));
    HelvDict.Add('Name', FStructure.NewName('Helv'));
    HelvDict.Add('Encoding', FStructure.NewName('WinAnsiEncoding'));
    HelvDict.Add('Subtype', FStructure.NewName('Type1'));
    HelvDict.Add('Type', FStructure.NewName('Font'));

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, HelvDict);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);
    FontDict.Add('Helv', Ref);

    FormStream.Dictionary.Add('Resources', ResDict);
    //end Form-Resources

    finally
      TempPainter.Free;
    end;


    FStructure.OnNewIndObj(Self, ObjNum, GenNum, N);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);

    AnnotDict.Add('AP', APDict);
    APDict.Add('N', Ref);

    // '<?xml version="1.0" encoding="UTF-8"?><body xfa:APIVersion="Acrobat:9.0.0" xmlns="http://www.w3.org/1999/xhtml" style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right" xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/" xfa:spec="2.0.2"><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right">This is a</span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right"> line of text</span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right">.&#13;</span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right">This is the </span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right">2nd line</span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right"> of text.</span></p></body>'
    {
    AnnotDict.Add('T', FStructure.NewTextString(Title));
    }
{
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;   }

procedure TPDFPageTree.AddFreeTextAnnotation(X, Y: Double;
  Width, Height: Double; const Text: WideString; Options: Integer; Angle: Integer = 0);
var
  Obj: TPDFObject;
  Annots: TPDFArray;
  AnnotDict, BSDict, APDict, ResDict: TPDFDictionary;
  //FontListDict: TPDFDictionary;
  FontDict, HelvDict: TPDFDictionary;
  ProcArray: TPDFArray;
  Ref: TPDFIndRef;
  N: TPDFStream;
  DA: array of Double;
  ObjNum: Integer;
  GenNum: Integer;
  S, S1: AnsiString;
  C1, C2, C3, C4: Double;
  I, P1, P2: Integer;
  DAString, DSString: AnsiString;
  TempPainter: TPDFPainter;
  TempContent: AnsiString;
  BorderWidth: Double;
  BoxWidth, BoxHeight: Double;
  Extra: Double;
begin

  if Assigned(FPageDict) and Assigned(FStructure.OnNewIndObj) then
  begin
    Obj := FPageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Assigned(Obj) and (Obj is TPDFArray) then
    begin
      Annots := Obj as TPDFArray;
    end else
    begin
      FPageDict.PurgeKey('Annots');
      Annots := FStructure.NewArray;
      FPageDict.Add('Annots', Annots);
      FAnnots.Attach(Annots);
    end;

    AnnotDict := FStructure.NewDictionary;
    AnnotDict.Add('Type', FStructure.NewName('Annot'));
    AnnotDict.Add('Subtype', FStructure.NewName('FreeText'));
    AnnotDict.Add('Subj', FStructure.NewName('Text Box'));
    AnnotDict.Add('F', FStructure.NewNumeric(4));
    AnnotDict.Add('Rotate', FStructure.NewNumeric(Angle));

    AnnotDict.Add('Rect', FStructure.NewDoubleArray([X, Y- Height, X + Width , Y]));
    AnnotDict.Add('CreationDate', FStructure.NewString(GetPDFDateTime));

    // Now extract the current drawing styles from Painter.
    S := FPainter.FillColor;
    if (GetTokCount(S, ' ') = 2) then  // DeviceGray: 0.5 g
    begin
      C1 := TazzToFloat(GetTok(S, ' ' , 1));
      AnnotDict.Add('C', FStructure.NewDoubleArray([C1]));
    end
    else
    if (GetTokCount(S, ' ') = 4) then  // RGB: 1 1 1 RG
    begin
      C1 := TazzToFloat(GetTok(S, ' ' , 1));
      C2 := TazzToFloat(GetTok(S, ' ' , 2));
      C3 := TazzToFloat(GetTok(S, ' ' , 3));
      AnnotDict.Add('C', FStructure.NewDoubleArray([C1, C2, C3]));
    end
    else
    if (GetTokCount(S, ' ') = 5) then  // CMYK: 0 0 0 1 K
    begin
      C1 := TazzToFloat(GetTok(S, ' ' , 1));
      C2 := TazzToFloat(GetTok(S, ' ' , 2));
      C3 := TazzToFloat(GetTok(S, ' ' , 3));
      C4 := TazzToFloat(GetTok(S, ' ' , 4));
      AnnotDict.Add('C', FStructure.NewDoubleArray([C1, C2, C3, C4]));
    end;

    BSDict := FStructure.NewDictionary;

    S := FPainter.LineDash;
    P1 := QPLPos('[', S);
    P2 := QPLPos(']', S);
    S1 := QPLCopy(S, P1 + 1, P2 - 2);
    S1 := QPLTrim(S1);

    if (Length(S1) > 0) then
    begin
      SetLength(DA, GetTokCount(S1, ' '));
      for I := 1 to GetTokCount(S1, ' ') do
        DA[I-1] := TazzToFloat(GetTok(S1, ' ' , I));
      BSDict.Add('D', FStructure.NewDoubleArray(DA));
      BSDict.Add('S', FStructure.NewName('D'));
    end
    else
      BSDict.Add('S', FStructure.NewName('S'));

    if ((Options = 0) or (Options = 2)) then
    begin
      BorderWidth := Painter.GetLineWidth;
      BSDict.Add('W', FStructure.NewNumeric(Painter.GetLineWidth));
      AnnotDict.Add('BS', BSDict);
    end else
    begin
      BorderWidth := 0;
      BSDict.Add('W', FStructure.NewNumeric(0));
      AnnotDict.Add('BS', BSDict);
    end;

    AnnotDict.Add('Contents', FStructure.NewTextString(Text));

    case (Painter.TextAlign) of
      paCenter:    AnnotDict.Add('Q', FStructure.NewNumeric(1));
      paRight:     AnnotDict.Add('Q', FStructure.NewNumeric(2));
      else
        AnnotDict.Add('Q', FStructure.NewNumeric(0));
    end;

    // ADC : Hardcoding to Helvetica.
    DAString := FPainter.LineColor + ' ' + FPainter.TextColor + ' 0 Tc 0 Tw 0 TL /' + FPainter.SelFont.Name + ' ' + QPLDoubleToStrConst(FPainter.TextSize, 2) + ' Tf';
    AnnotDict.Add('DA', FStructure.NewString(DAString));

    //font: Helvetica,sans-serif 12.0pt; text-align:left; color:#FF0000
    DSString := 'font: ' + 'Helvetica' + ',sans-serif ' + QPLDoubleToStrConst(FPainter.TextSize, 1) + 'pt; text-align:';
    case (Painter.TextAlign) of
      paCenter:    DSString := DSString + 'center; ';
      paRight:     DSString := DSString + 'right; ';
      else
        DSString := DSString + 'left; ';
    end;
    DSString := DSString + 'color:' + FPainter.HexColorLine;
    AnnotDict.Add('DS', FStructure.NewString(DSString));

    APDict := FStructure.NewDictionary;

    N := FStructure.NewStream('');
    N.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, Width , Height]));
    N.Dictionary.Add('FormType', FStructure.NewNumeric(1));
    N.Dictionary.Add('Matrix', FStructure.NewDoubleArray([1.0, 0, 0, 1.0, 0, 0]));
    N.Dictionary.Add('Subtype', FStructure.NewName('Form'));
    N.Dictionary.Add('Type', FStructure.NewName('XObject'));

    TempPainter := TPDFPainter.Create(nil);
    try
      TempPainter.SetState(FPainter.GetState);

      // Now extract the current drawing styles from Painter.
      S := FPainter.TextColor;
      if (GetTokCount(S, ' ') = 2) then  // DeviceGray: 0.5 g
      begin
        C1 := TazzToFloat(GetTok(S, ' ' , 1));
        TempPainter.SetLineColor(C1, C1, C1);
      end
      else
      if (GetTokCount(S, ' ') = 4) then  // RGB: 1 1 1 RG
      begin
        C1 := TazzToFloat(GetTok(S, ' ' , 1));
        C2 := TazzToFloat(GetTok(S, ' ' , 2));
        C3 := TazzToFloat(GetTok(S, ' ' , 3));
        TempPainter.SetLineColor(C1, C2, C3);
      end
      else
      if (GetTokCount(S, ' ') = 5) then  // CMYK: 0 0 0 1 K
      begin
        C1 := TazzToFloat(GetTok(S, ' ' , 1));
        C2 := TazzToFloat(GetTok(S, ' ' , 2));
        C3 := TazzToFloat(GetTok(S, ' ' , 3));
        C4 := TazzToFloat(GetTok(S, ' ' , 4));
        TempPainter.SetLineColor(C1, C2, C3, C4);
      end;

      if ((Angle div 90) mod 2 = 0) then
      begin
        BoxWidth := Width;
        BoxHeight := Height;
      end
      else
      begin
        BoxWidth := Height;
        BoxHeight := Width;
      end;

      TempPainter.SaveState();
      if Angle = 90 then TempPainter.Rotate(Width, 0, 90);
      if Angle = 180 then TempPainter.Rotate(Width, Height, 180);
      if Angle = 270 then TempPainter.Rotate(0, Height, 270);

      if (BorderWidth = 0) then
        BorderWidth := 2;

      // Doesn't match up with  TPDFPainter.DrawWrappedText but it works much better.
      Extra := TempPainter.TextAscent + TempPainter.TextDescent + 2;

      TempPainter.DrawWrappedWideText(
                 BorderWidth * 2,
                 BoxHeight - BorderWidth * 2 - Extra,
                 BoxWidth - BorderWidth * 4,
                 Text, #13#10);

      TempContent := TempPainter.Source;
      TempPainter.LoadState();

      TempPainter.SetSource('');
      TempPainter.Add(Painter.FillColor);
      TempPainter.Add(Painter.LineColor);
      TempPainter.Add(Painter.TheLineWidthLine);
      if (Options = 1) then
      begin
        TempPainter.Rectangle(BorderWidth / 2, Height - BorderWidth / 2, Width - BorderWidth, Height - BorderWidth, True, False);
      end else
      if (Options = 2) then
      begin
        TempPainter.Rectangle(BorderWidth / 2, Height - BorderWidth / 2 , Width - BorderWidth, Height - BorderWidth, True, True);
      end;

      N.SetTo('/Tx BMC q ' + TempPainter.Source + DAString + ' ' + TempContent + ' Q EMC', False);

    finally
      TempPainter.Free;
    end;

    ResDict := FStructure.NewDictionary;
    ProcArray := FStructure.NewArray;
    ProcArray.Add(FStructure.NewName('PDF'));
    ResDict.Add('ProcSet', ProcArray);

    FontDict := FStructure.NewDictionary;
    ResDict.Add('Font', FontDict);

    HelvDict := FStructure.NewDictionary;
    HelvDict.Add('BaseFont', FStructure.NewName('Helvetica'));
    HelvDict.Add('Name', FStructure.NewName('Helv'));
    HelvDict.Add('Encoding', FStructure.NewName('WinAnsiEncoding'));
    HelvDict.Add('Subtype', FStructure.NewName('Type1'));
    HelvDict.Add('Type', FStructure.NewName('Font'));

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, HelvDict);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);
    FontDict.Add('Helv', Ref);

    N.Dictionary.Add('Resources', ResDict);

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, N);
    Ref := FStructure.NewIndirectRef(ObjNum, GenNum);

    AnnotDict.Add('AP', APDict);
    APDict.Add('N', Ref);

    // '<?xml version="1.0" encoding="UTF-8"?><body xfa:APIVersion="Acrobat:9.0.0" xmlns="http://www.w3.org/1999/xhtml" style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right" xmlns:xfa="http://www.xfa.org/schema/xfa-data/1.0/" xfa:spec="2.0.2"><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right">This is a</span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right"> line of text</span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right">.&#13;</span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right">This is the </span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right">2nd line</span></p><p><span style="font-family:Helvetica;font-size:12.0pt;color:#FF0000;text-align:right"> of text.</span></p></body>'
    {
    AnnotDict.Add('T', FStructure.NewTextString(Title));
    }

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, AnnotDict);
    Annots.Add(FStructure.NewIndirectRef(ObjNum, GenNum));
  end;
end;

function TPDFPageTree.GetUserUnit: Double;
var
  Obj: TPDFObject;
begin
  Result := 1.0;
  if (Assigned(FPageDict)) then
  begin
    Obj := FPageDict.FindValueByKeyName('UserUnit', True);
    if Obj is TPDFNumeric then
        Result := TPDFNumeric(Obj).AsDouble;
  end;
end;

procedure TPDFPageTree.SetUserUnit(Value: Double);
begin
  FPageDict.PurgeKey('UserUnit');
  FPageDict.Add('UserUnit', FStructure.NewNumeric(Value));
end;

end.
