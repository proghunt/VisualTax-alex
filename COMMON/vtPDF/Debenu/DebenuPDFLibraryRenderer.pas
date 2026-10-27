{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryRenderer.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryRenderer;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
  DebenuPDFLibraryPrinters,
{$ELSE}
  Vcl.Graphics,
  Vcl.Printers,
{$ENDIF}
{$IFNDEF VER120}
  contnrs,
{$ENDIF}
  DebenuPDFLibraryStructure,
  DebenuPDFLibraryFontRasterizer,
  DebenuPDFLibraryFontConst, DebenuPDFLibraryPicasso, Classes, DebenuPDFLibraryMatrix,
  DebenuPDFLibraryColorManagement, DebenuPDFLibraryEPS, DebenuPDFLibraryTextFunnel, DebenuPDFLibraryImageDecoder,
  DebenuPDFLibraryImageList, DebenuPDFLibraryPrinting, DebenuPDFLibraryTypes, DebenuPDFLibraryPatterns,
{$IFDEF QPL_DPLR}
  DebenuPDFLibrarySoftmask,
{$ENDIF}
 DebenuPDFLibraryExtra, DebenuPDFLibraryCMap, DebenuPDFLibraryGDIPlus;

type
  TPDFRenderDest = (rdBitmap, rdWMF, rdEMF, rdEPS, rdPrinter, rdTextFunnel,
    rdImageList, rdEMFPlus, rdDeviceContext, rdHTML5
{$IFDEF QPL_CAIRO}
    , rdCairo, rdCairoBitmap
{$ENDIF}
{$IFDEF QPL_DPLR}
    , rdDPLR, rdDPLRBitmap, rdDPLRPrinter, rdDPLRMemory
{$ENDIF}
    );

  TPDFGraphicsState = record
    XPos: Double;
    YPos: Double;
    FillColor: TColor;
    FillColorEPS: AnsiString;
    FillColorCMYK: TPDFCMYKColor;
    FillPattern: TQPLPattern;
    StrokeColor: TColor;
    StrokeColorEPS: AnsiString;
    FillColorSpace: AnsiString;
    StrokeColorSpace: AnsiString;
    StrokePattern: TQPLPattern;
    AlternateFillCS: AnsiString;
    LineWidth: Double;
    LineCap: Integer;
    LineJoin: Integer;
    MiterLimit: Double;
    CTM: TPDFXForm;
    TM: TPDFXForm;
    TLM: TPDFXForm;
    TextScaling: Double;
    TextSize: Double;
    TextFont: AnsiString;
    TextLeading: Double;
    CharSpacing: Double;
    WordSpacing: Double;
    TextRise: Double;
    TextRenderingMode: Integer;
    StrokeAlpha: Double;
    FillAlpha: Double;
    BlendMode: TPDFBlendMode;
    ClipRegion: TQPLIntPtr;
    DashPhase: Double;
    DashArray: array of Double;
    Knockout: Boolean;
{$IFDEF QPL_DPLR}
    Softmask: Boolean;
{$ENDIF}
  end;

  TPDFPageScaling = (psNone, psFitToPaper, psShrinkLargePages);

  TPDFPrintOptions = record
    PageScaling: TPDFPageScaling;
    AutoRotateCenter: Boolean;
    AutoRotateCenter180: Boolean;
  end;

  TPDFDecodedImage = record
    Hash: Int64;
    Ref: TPDFIndRef;
    ID: TPDFImageDecoder;
  end;

  TPDFImageCollection = array of TPDFDecodedImage;

  TQPLOCGState = record
    OCGIndRef: TPDFIndRef;
    Show: Boolean;
  end;

  TQPLOCGStateList = array of TQPLOCGState;

{$IFDEF QPL_DPLR}
  TDPLRPrinterBBox = record
    Left: Integer;
    Top: Integer;
    Right: Integer;
    Bottom: Integer;
  end;

  TPrinterBBoxArray = array of TDPLRPrinterBBox;
{$ENDIF}

  TPDFRenderer = class
  private
    FBitmap: TBitmap;
    FMetafile: TMetafile;
    FEPS: TPDFEPSExport;
    FDPI: Double;
    FPageDict: TPDFDictionary;
    FDestination: TPDFRenderDest;
    FStructure: TPDFStructure;
    FFontCol: TPDFFontCollection;
    FSeparationColors: array of TPDFSeparationColorSpace;
    FLabColors: array of TPDFLabColorSpace;
    FDeviceNColors: array of TPDFDeviceNColorSpace;
    FIndexedColors: array of TPDFIndexedColorSpace;
    FPatterns: array of TQPLPattern;
    FOnFindObject: TPDFFindObjectEvent;
    FOnDecrypt: TPDFCryptStreamEvent;
    FOnEncrypt: TPDFCryptStreamEvent;
    FGDIPlusSettings: TGDIPlusSettings;
    FFunnel: TPDFTextFunnel;
    FExternalFunnel: Boolean;
    FPrintOptions: TPDFPrintOptions;
    FColorManager: TPDFColorManager;
    FImageCollection: TPDFImageCollection;
    FTotalImageCollectionSize: Cardinal;
    FImageList: TPDFImageList;
    FMaxX: Integer;
    FMaxY: Integer;
    CanvasMat: TPDFXForm;
    StartMatrix: TPDFXForm;
    Picasso: TPDFPicasso;
    ParentResources: TPDFDictionary;
    FErrorDesc: AnsiString;
    FQPLPrinter: TQPLPrinter;
    FEMFPlusTarget: TStream;
    FDeviceContextTarget: HDC;
    FDeviceContextErasePage: Boolean;
    FDeviceContextOffsetX: Integer;
    FDeviceContextOffsetY: Integer;
{$IFDEF QPL_CAIRO}
    FCairoTarget: HDC;
    FCairoFileName: WideString;
    FCairoErasePage: Boolean;
    FCairoOffsetX: Integer;
    FCairoOffsetY: Integer;
{$ENDIF}
{$IFDEF QPL_DPLR}
    FDPLRTarget: HDC;
    FDPLRMemoryTarget: Pointer;
    FDPLRMemoryWidth: Integer;
    FDPLRMemoryHeight: Integer;
    FDPLRMemoryBitsPerPixel: Integer;
    FDPLRFileName: WideString;
    FDPLRErasePage: Boolean;
    FDPLROffsetX: Integer;
    FDPLROffsetY: Integer;
    FPageMatrix: TPDFXForm;
    FUTSPattern :TQPLPattern;
    FUTFPattern :TQPLPattern;
    FPrinterBBoxArray: TPrinterBBoxArray;
    IdentityMatrix: TPDFXForm;
{$ENDIF}
    FInitialState: TPDFGraphicsState;
    FUseInitialState: Boolean;
    FCropType: Integer;
    FHTML5Target: TStream;
    FOCGStateList: TQPLOCGStateList;
    FIntCasts: TObjectList;
    FDrawingAnnot: Boolean;
{$IFDEF QPL_DPLR}
    FClipBBoxArray: TPrinterBBoxArray;
{$ENDIF}

    function Translate(P1: TPDFDoublePoint): TPDFDoublePoint;
    function TranslateUsing(P1: TPDFDoublePoint; Mat: TPDFXForm): TPDFDoublePoint;
    function DoublePoint(X, Y: Double): TPDFDoublePoint;
    function GetInheritedValue(Dict: TPDFDictionary; const Key: AnsiString): TPDFObject;
    function FindObject(Ref: TPDFIndRef): TPDFObject;
    procedure SetFunnel(NewFunnel: TPDFTextFunnel);
    function GetPageBox(const BoxString: AnsiString; var Left, Bottom, Right, Top: Double): Boolean;
    function IntCast(VCLObj: TObject): Integer;
    function IntUncast(IntCast: Integer): TObject;
  protected
    procedure SubRender(Picasso: TPDFPicasso; Source: TPDFObject;
      ContainerIR: TPDFIndRef = nil; const Type3CharProc: AnsiString = '');
    procedure RenderToImageStream(Source: TPDFObject; ContainerIR: TPDFIndRef; Target: TStream; Left, Bottom, Width, Height: Double; var Scale: Double);
  public
    constructor Create(FontCollection: TPDFFontCollection); virtual;
    destructor Destroy; override;
    procedure AddToInitialClip(ClipLeft, ClipTo, ClipWidth, ClipHeight: Integer);
    procedure ClearInitialClip();
    procedure Render;
    procedure RenderSource(Source: TPDFObject; ContainerIR: TPDFIndRef;
      PageLeft, PageBottom, PageWidth, PageHeight: Double);
    procedure ClearCachedResources;
    procedure SetEMFPlusTarget(Target: TStream);
    procedure SetDeviceContextTarget(Target: HDC; ErasePage: Boolean; OffsetX, OffsetY: Integer);
    procedure SetHTML5Target(Target: TStream);
{$IFDEF QPL_CAIRO}
    procedure SetCairoTarget(const CairoFileName: WideString; Target: HDC; ErasePage: Boolean; OffsetX, OffsetY: Integer);
{$ENDIF}
{$IFDEF QPL_DPLR}
    procedure SetDPLRTarget(const DPLRFileName: WideString; Target: HDC; ErasePage: Boolean; OffsetX, OffsetY: Integer);
    procedure SetDPLRMemoryTarget(const DPLRFileName: WideString; Target: Pointer; Width, Height, BitsPerPixel: Integer; ErasePage: Boolean; OffsetX, OffsetY: Integer);
    procedure AddToPrinterBBoxArray(Left, Top, Right, Bottom: Double);
    property PrinterBBoxArray: TPrinterBBoxArray read FPrinterBBoxArray write FPrinterBBoxArray;
    function IsBBoxInPrinterArray(Left, Top, Right, Bottom: Double): Boolean;
    function AdjustBBox(Left, Top, Right, Bottom: PDouble): Boolean;
    property DPLRFileName: WideString read FDPLRFileName write FDPLRFileName;
{$ENDIF}
    property DPI: Double read FDPI write FDPI;
    property PageDict: TPDFDictionary read FPageDict write FPageDict;
    property Destination: TPDFRenderDest read FDestination write FDestination;
    property Bitmap: TBitmap read FBitmap;
    property Metafile: TMetafile read FMetafile;
    property EPS: TPDFEPSExport read FEPS;
    property GDIPlusSettings: TGDIPlusSettings read FGDIPlusSettings write FGDIPlusSettings;
    property TextFunnel: TPDFTextFunnel read FFunnel write SetFunnel;
    property OnFindObject: TPDFFindObjectEvent read FOnFindObject write FOnFindObject;
    property PrintOptions: TPDFPrintOptions read FPrintOptions write FPrintOptions;
    property ImageList: TPDFImageList read FImageList write FImageList;
    property OnDecrypt: TPDFCryptStreamEvent read FOnDecrypt write FOnDecrypt;
    property OnEncrypt: TPDFCryptStreamEvent read FOnEncrypt write FOnEncrypt;
    property ErrorDesc: AnsiString read FErrorDesc;
    property QPLPrinter: TQPLPrinter read FQPLPrinter write FQPLPrinter;
    property CropType: Integer read FCropType write FCropType;
    property OCGStateList: TQPLOCGStateList read FOCGStateList write FOCGStateList;

  end;

implementation

uses
  DebenuPDFLibraryFont, Math, SysUtils, DebenuPDFLibraryType1,
{$IFDEF QPL_CAIRO}
  DebenuPDFLibraryCairo,
{$ENDIF}
{$IFDEF QPL_DPLR}
  DebenuPDFLibraryDPLR,
{$ENDIF}
  DebenuPDFLibraryGenericCanvas, DebenuPDFLibraryStampAnnots, DebenuPDFLibraryEncoding,
  DebenuPDFLibraryTrueTypeRasterizer;

function F(D: Double): AnsiString;
begin
  Result := QPLDoubleToStr(D, 3) + ' ';
end;

{ TPDFRenderer }

procedure Mat(var Matrix: TPDFXForm; eM11, eM12, eM21, eM22, eDx, eDy: Double);
begin
  Matrix.eM11 := eM11;
  Matrix.eM12 := eM12;
  Matrix.eM21 := eM21;
  Matrix.eM22 := eM22;
  Matrix.eDx := eDx;
  Matrix.eDy := eDy;
end;

procedure TPDFRenderer.ClearCachedResources;
var
  X: Integer;
begin
  for X := 0 to Length(FSeparationColors) - 1 do
  begin
    FSeparationColors[X].Free;
  end;
  for X := 0 to Length(FLabColors) - 1 do
  begin
    FLabColors[X].Free;
  end;
  for X := 0 to Length(FDeviceNColors) - 1 do
  begin
    FDeviceNColors[X].Free;
  end;
  for X := 0 to Length(FIndexedColors) - 1 do
  begin
    FIndexedColors[X].Free;
  end;
  for X := 0 to Length(FImageCollection) - 1 do
  begin
    FImageCollection[X].ID.Free;
  end;
  for X := 0 to Length(FPatterns) - 1 do
  begin
    FPatterns[X].Free;
  end;

  SetLength(FSeparationColors, 0);
  SetLength(FLabColors, 0);
  SetLength(FDeviceNColors, 0);
  SetLength(FIndexedColors, 0);
  SetLength(FPatterns, 0);
  SetLength(FImageCollection, 0);
end;

constructor TPDFRenderer.Create(FontCollection: TPDFFontCollection);
begin
  FErrorDesc := '';
  FFontCol := FontCollection;
  FBitmap := TBitmap.Create;
  FBitmap.PixelFormat := pf24bit;
  FMetafile := TMetafile.Create;
  FEPS := TPDFEPSExport.Create;
  FFunnel := TPDFTextFunnel.Create;
  FExternalFunnel := False;
  FColorManager := TPDFSimpleColorManager.Create;
  DefaultGDIPlusSettings(FGDIPlusSettings);
  FCropType := 2; // CropBox
  FIntCasts := TObjectList.Create(False);
  FDrawingAnnot := False;
{$IFDEF QPL_DPLR}
  FUTFPattern := nil;
  FUTSPattern := nil;
  SetLength(FPrinterBBoxArray, 0);
{$ENDIF}
end;

destructor TPDFRenderer.Destroy;
begin
  FMetafile.Free;
  FIntCasts.Free;

  ClearCachedResources;

{$IFDEF QPL_DPLR}
  if Assigned(FUTFPattern) then
    FUTFPattern.Free;
  if Assigned(FUTSPattern) then
    FUTSPattern.Free;
{$ENDIF}

  FTotalImageCollectionSize := 0;
  FEPS.Free;
  if not FExternalFunnel then FFunnel.Free;
  FBitmap.Free;
  FColorManager.Free;
  inherited;
end;

function TPDFRenderer.DoublePoint(X, Y: Double): TPDFDoublePoint;
begin
  Result.X := X;
  Result.Y := Y;
end;

function TPDFRenderer.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

function TPDFRenderer.GetInheritedValue(Dict: TPDFDictionary;
  const Key: AnsiString): TPDFObject;
var
  Obj: TPDFObject;
begin
  Result := nil;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName(Key, False);
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Assigned(Obj) then Result := Obj else
    begin
      Obj := Dict.FindValueByKeyName('Parent', False);
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then
        Result := GetInheritedValue(TPDFDictionary(Obj), Key);
    end;
  end;
end;

function TPDFRenderer.GetPageBox(const BoxString: AnsiString; var Left, Bottom,
  Right, Top: Double): Boolean;
var
  Obj: TPDFObject;
  Temp: Double;
begin
  Result := False;
  Obj := GetInheritedValue(FPageDict, BoxString);
  if (not Assigned(Obj)) then
  begin
    if (BoxString = 'CropBox') then
    begin
      Obj := GetInheritedValue(FPageDict, 'MediaBox');
    end else
    if (BoxString <> 'MediaBox') then
    begin
      Obj := GetInheritedValue(FPageDict, 'CropBox');
      if (not Assigned(Obj)) then
      begin
        Obj := GetInheritedValue(FPageDict, 'MediaBox');
      end;
    end;
  end;
  if Obj is TPDFArray then
  begin
    if (TPDFArray(Obj).AllItemsNumeric) then
    begin
      Left := TPDFNumeric(TPDFArray(Obj).Item[0]).AsDouble;
      Bottom := TPDFNumeric(TPDFArray(Obj).Item[1]).AsDouble;
      Right := TPDFNumeric(TPDFArray(Obj).Item[2]).AsDouble;
      Top := TPDFNumeric(TPDFArray(Obj).Item[3]).AsDouble;

      if (Left > Right) then
      begin
        Temp := Left;
        Left := Right;
        Right := temp;
      end;

      if (Bottom > Top) then
      begin
        Temp := Top;
        Top := Bottom;
        Bottom := Temp;
      end;

      Result := True;
    end;
  end;
end;

function TPDFRenderer.IntCast(VCLObj: TObject): Integer;
var
  I: Integer;
  X: Integer;
begin
  if (Assigned(VCLObj)) then
  begin
    I := -1;
    X := 0;
    while ((I < 0) and (X < FIntCasts.Count)) do
    begin
      if (FIntCasts[X] = VCLObj) then
      begin
        I := X;
      end else
      begin
        Inc(X);
      end;
    end;
    if (I < 0) then
    begin
      FIntCasts.Add(VCLObj);
      I := FIntCasts.Count - 1;
    end;
    Result := $58000000 + I;
  end else
  begin
    Result := 0;
  end;
end;

function TPDFRenderer.IntUncast(IntCast: Integer): TObject;
begin
  Result := nil;
  if (IntCast and $58000000 = $58000000) then
  begin
    IntCast := IntCast and $07FFFFFF;
    if ((IntCast >= 0) and (IntCast < FIntCasts.Count)) then
    begin
      Result := FIntCasts[IntCast];
    end;
  end;
end;

procedure TPDFRenderer.AddToInitialClip(ClipLeft, ClipTo, ClipWidth, ClipHeight: Integer);
begin
{$IFDEF QPL_DPLR}
  SetLength(FClipBBoxArray, Length(FClipBBoxArray)+1);
  FClipBBoxArray[Length(FClipBBoxArray) - 1].Left := ClipLeft;
  FClipBBoxArray[Length(FClipBBoxArray) - 1].Top := ClipTo;
  FClipBBoxArray[Length(FClipBBoxArray) - 1].Right := ClipLeft + ClipWidth;
  FClipBBoxArray[Length(FClipBBoxArray) - 1].Bottom := ClipTo + ClipHeight;
{$ENDIF}
end;

procedure TPDFRenderer.ClearInitialClip();
begin
{$IFDEF QPL_DPLR}
  SetLength(FClipBBoxArray, 0);
{$ENDIF}
end;

procedure TPDFRenderer.Render;
var
  Obj: TPDFObject;
  PageWidth: Double;
  PageHeight: Double;
  PageLeft: Double;
  PageRight: Double;
  PageTop: Double;
  PageBottom: Double;
  TempEdge: Double;
  CanvasWidth: Integer;
  CanvasHeight: Integer;
  FCanvas: TCanvas;
  Matrix: TPDFXForm;
  HDifference: Double;
  VDifference: Double;
  HScale: Double;
  VScale: Double;
  FinalScale: Double;
  Rotate: Integer;
  PrintOffsetX: Double;
  PrintOffsetY: Double;
  FullPrinterWidth: Integer;
  FullPrinterHeight: Integer;
  FloatCompare1: Double;
  FloatCompare2: Double;
  MediaBoxLeft: Double;
  MediaBoxRight: Double;
  MediaBoxTop: Double;
  MediaBoxBottom: Double;
{$IFDEF QPL_DPLR}
  R: Integer;
  DPLRPrintData: PByte;
  DPLRPrintWidth:Integer;
  DPLRPrintHeight:Integer;
  DPLRPrintMatrix: TPDFXForm;
{$ENDIF}
const
  BoxNames: array[1..5] of AnsiString = ('MediaBox', 'CropBox', 'BleedBox',
    'TrimBox', 'ArtBox');
begin
{$IFDEF QPL_DPLR}
  // Check that the DPLR file name is set
  if ((FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or
    (FDestination = rdDPLRPrinter) or (FDestination = rdDPLRMemory)) then
  begin
    if (FDPLRFileName = '') then
    begin
      Exit;
    end;
  end;
{$ENDIF}
{$IFNDEF QPL_NOVCL}
  FBitmap.Canvas.Lock;
  try
{$ENDIF}

  FUseInitialState := False;
  FFontCol.UsingTextFunnel := (FDestination = rdTextFunnel);
  FColorManager.FixedGamma := FGDIPlusSettings.UseGammaCorrection;

  if (FGDIPlusSettings.DirectFonts) then
  begin
    FFontCol.DirectFonts := True;
  end;

  if (FDPI = 0) then
  begin
    FDPI := 1;
  end;

  Rotate := 0;
  PageLeft := 0;
  PageBottom := 0;
  PageRight := 612;
  PageTop := 792;
  MediaBoxLeft := 0;
  MediaBoxRight := 612;
  MediaBoxTop := 792;
  MediaBoxBottom := 0;

  GetPageBox(BoxNames[FCropType], PageLeft, PageBottom, PageRight, PageTop);
  GetPageBox('MediaBox', MediaBoxLeft, MediaBoxBottom, MediaBoxRight, MediaBoxTop);

  PageLeft := Max(MediaBoxLeft, PageLeft);
  PageBottom := Max(MediaBoxBottom, PageBottom);
  PageRight := Min(MediaBoxRight, PageRight);
  PageTop := Min(MediaBoxTop, PageTop);

  PageWidth := PageRight - PageLeft;
  if (PageWidth = 0) then
  begin
    PageWidth := 1;
  end;
  PageHeight := PageTop - PageBottom;
  if (PageHeight = 0) then
  begin
    PageHeight := 1;
  end;

  Obj := GetInheritedValue(FPageDict, 'Rotate');
  if Obj is TPDFNumeric then
    Rotate := TPDFNumeric(Obj).AsInteger;
  Rotate := ((Rotate div 90) mod 4) * 90;
  if (Rotate < 0) then Rotate := 360 + Rotate;

  // Start with the identity matrix
  Mat(CanvasMat, 1, 0, 0, 1, 0, 0);

  // If the page is rotated 90 degrees to the left or right then
  // the width and height must be swapped
  if ((Rotate = 90) or (Rotate = 270)) then
  begin
    TempEdge := PageHeight;
    PageHeight := PageWidth;
    PageWidth := TempEdge;
  end;

  CanvasWidth := 10;
  CanvasHeight := 10;
  FullPrinterWidth := 10;
  FullPrinterHeight := 10;
  PrintOffsetX := 0;
  PrintOffsetY := 0;
  FCanvas := nil;

  case FDestination of
    rdBitmap
{$IFDEF QPL_CAIRO}
    , rdCairoBitmap
{$ENDIF}
{$IFDEF QPL_DPLR}
    , rdDPLRBitmap
{$ENDIF}
    :
    begin
      FCanvas := FBitmap.Canvas;
      FBitmap.Width := Round(PageWidth * FDPI / 72);
      FBitmap.Height := Round(PageHeight * FDPI / 72);

      FloatCompare1 := FBitmap.Width * 72;
      FloatCompare2 := PageWidth * FDPI;
      if FloatCompare1 < FloatCompare2 then
        FBitmap.Width := FBitmap.Width + 1;

      FloatCompare1 := FBitmap.Height * 72;
      FloatCompare2 := PageHeight * FDPI;
      if FloatCompare1 < FloatCompare2 then
        FBitmap.Height := FBitmap.Height + 1;

      CanvasWidth := FBitmap.Width;
      CanvasHeight := FBitmap.Height;
    end;
    rdEMFPlus, rdDeviceContext, rdHTML5
{$IFDEF QPL_CAIRO}
    , rdCairo
{$ENDIF}
{$IFDEF QPL_DPLR}
    , rdDPLR
{$ENDIF}
    :
    begin
      CanvasWidth := Round(PageWidth * FDPI / 72);
      CanvasHeight := Round(PageHeight * FDPI / 72);

      FloatCompare1 := CanvasWidth * 72;
      FloatCompare2 := PageWidth * FDPI;
      if FloatCompare1 < FloatCompare2 then
        CanvasWidth := CanvasWidth + 1;

      FloatCompare1 := CanvasHeight * 72;
      FloatCompare2 := PageHeight * FDPI;
      if FloatCompare1 < FloatCompare2 then
        CanvasHeight := CanvasHeight + 1;
    end;
{$IFDEF QPL_DPLR}
    rdDPLRMemory:
    begin
      // Create a 1x1 pixel image so that we have a device context
      FBitmap.Width := 1;
      FBitmap.Height := 1;
      CanvasWidth := FDPLRMemoryWidth;
      CanvasHeight := FDPLRMemoryHeight;
    end;
{$ENDIF}
    rdWMF:
    begin
      FMetafile.Clear;
      FMetafile.Enhanced := False;
      FMetafile.Width := Round(PageWidth * FDPI / 72);
      FMetafile.Height := Round(PageHeight * FDPI / 72);
      CanvasWidth := FMetafile.Width;
      CanvasHeight := FMetafile.Height;
      FCanvas := TMetafileCanvas.Create(FMetafile, FBitmap.Canvas.Handle);
    end;
    rdEMF:
    begin
      FMetafile.Clear;
      FMetafile.Enhanced := True;
      FMetafile.Width := Round(PageWidth * FDPI / 72);
      FMetafile.Height := Round(PageHeight * FDPI / 72);
      CanvasWidth := FMetafile.Width;
      CanvasHeight := FMetafile.Height;
      FCanvas := TMetafileCanvas.Create(FMetafile, FBitmap.Canvas.Handle);
    end;
    rdEPS:
    begin
    end;
    rdPrinter:
    begin
      FCanvas := FQPLPrinter.Canvas;
      CanvasWidth := FQPLPrinter.PageWidth;
      CanvasHeight := FQPLPrinter.PageHeight;
      FGDIPlusSettings.IsPrinting := True;
      FullPrinterWidth := FQPLPrinter.FullPageWidth;
      FullPrinterHeight := FQPLPrinter.FullPageHeight;
      PrintOffsetX := FQPLPrinter.PrintOffsetX;
      PrintOffsetY := FQPLPrinter.PrintOffsetY;
    end;
{$IFDEF QPL_DPLR}
    rdDPLRPrinter:
    begin
      FCanvas := FQPLPrinter.Canvas;
      CanvasWidth := FQPLPrinter.PageWidth;
      CanvasHeight := FQPLPrinter.PageHeight;
      FGDIPlusSettings.IsPrinting := True;
      FullPrinterWidth := FQPLPrinter.FullPageWidth;
      FullPrinterHeight := FQPLPrinter.FullPageHeight;
      PrintOffsetX := FQPLPrinter.PrintOffsetX;
      PrintOffsetY := FQPLPrinter.PrintOffsetY;
    end;
{$ENDIF}
    rdTextFunnel:
    begin
      FFunnel.Clear;
      FDPI := 72;
    end;
  end;

  FMaxX := CanvasWidth;
  FMaxY := CanvasHeight;

  if ((FDestination = rdEMFPlus) or (FDestination = rdDeviceContext) or
{$IFDEF QPL_CAIRO}
    (FDestination = rdCairo) or (FDestination = rdCairoBitmap) or
{$ENDIF}
{$IFDEF QPL_DPLR}
    (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) or
{$ENDIF}
    (FDestination = rdHTML5) or (Assigned(FCanvas))) then
  begin
{$IFNDEF QPL_NOVCL}
    // Need to lock FCanvas here since it can be FQPLPrinter.FPreviewBitmap.Canvas
    if Assigned(FCanvas) then
      FCanvas.Lock;
    try
{$ENDIF}

    if (Assigned(FCanvas)) then
    begin
      FCanvas.Brush.Color := clWhite;
      FCanvas.Brush.Style := bsSolid;
{$IFNDEF QPL_CPP}
      FCanvas.FillRect(Rect(0, 0, CanvasWidth, CanvasHeight));
{$ENDIF}
    end else
    begin
      if (FDestination = rdDeviceContext) then
      begin
        // Set the intial clipping path
{$IFDEF QPL_OS_WINDOWS}
        IntersectClipRect(FDeviceContextTarget, FDeviceContextOffsetX,
          FDeviceContextOffsetY, FDeviceContextOffsetX + CanvasWidth,
          FDeviceContextOffsetY + CanvasHeight);
{$ENDIF}
        if (FDeviceContextErasePage)  then
        begin
{$IFDEF QPL_OS_WINDOWS}
          PatBlt(FDeviceContextTarget, FDeviceContextOffsetX,
            FDeviceContextOffsetY, CanvasWidth,
            CanvasHeight, WHITENESS);
{$ENDIF}
        end;
        Mat(Matrix, 1, 0, 0, 1, FDeviceContextOffsetX, FDeviceContextOffsetY);
        CombinePDFXForm(CanvasMat, Matrix, CanvasMat);
      end;
    end;

    if (FDestination = rdPrinter)
{$IFDEF QPL_DPLR}
    or (FDestination = rdDPLRPrinter)
{$ENDIF}
    then
    begin
      if (FQPLPrinter.HasPreview) then
      begin
        Mat(Matrix, 1, 0, 0, 1, PrintOffsetX, PrintOffsetY);
        CombinePDFXForm(CanvasMat, Matrix, CanvasMat);
      end;

      // Use the full page by default, but only the printable area
      // if scaling the page
      if (FPrintOptions.PageScaling = psNone) then
      begin
        // Shift the page by the print offset
        //Mat(Matrix, 1, 0, 0, 1, -PrintOffsetX, -(FullPrinterHeight - CanvasHeight - PrintOffsetY));
        //CombinePDFXForm(CanvasMat, Matrix, CanvasMat);
        CanvasWidth := FullPrinterWidth;
        CanvasHeight := FullPrinterHeight;
      end else
      begin
        PrintOffsetX := 0;
        PrintOffsetY := 0;
      end;

      if FPrintOptions.AutoRotateCenter and
        (((PageWidth > PageHeight) and (CanvasWidth < CanvasHeight)) or
        ((PageWidth < PageHeight) and (CanvasWidth > CanvasHeight))) then
      begin
        // Page orientation doesn't match paper orientation

        if (FPrintOptions.AutoRotateCenter180 = false) then
          Rotate := (Rotate + 90) mod 360
        else
          Rotate := (Rotate - 90) mod 360;

        if (Rotate < 0) then Rotate := Rotate + 360;

        // Swap page width and height
        TempEdge := PageHeight;
        PageHeight := PageWidth;
        PageWidth := TempEdge;
      end;

      Mat(Matrix, 1, 0, 0, 1, -PrintOffsetX, -PrintOffsetY);
      CombinePDFXForm(CanvasMat, Matrix, CanvasMat);
      Mat(Matrix, FDPI / 72, 0, 0, -FDPI / 72, 0, 0);
      CombinePDFXForm(CanvasMat, Matrix, CanvasMat);

      FinalScale := 1;

      if (FPrintOptions.PageScaling = psFitToPaper) or
        (FPrintOptions.PageScaling = psShrinkLargePages) then
      begin
        // Calculate the required scaling
        HScale := (CanvasWidth * 72 / FDPI) / PageWidth;
        VScale := (CanvasHeight * 72 / FDPI) / PageHeight;
        if (HScale < VScale) then
        begin
          FinalScale := HScale;
        end else
        begin
          FinalScale := VScale;
        end;

        // If ShrinkLargePages is selected and the page is
        // small enough then don't scale it
        if (FPrintOptions.PageScaling = psShrinkLargePages) and
          (FinalScale > 1) then
        begin
          FinalScale := 1;
        end;

        // Apply the scaling tranformation matrix if it isn't unity
        if (FinalScale <> 1) then
        begin
          Mat(Matrix, FinalScale, 0, 0, FinalScale, 0, 0);
          CombinePDFXForm(CanvasMat, Matrix, CanvasMat);
        end;
      end;

      Mat(Matrix, 1, 0, 0, 1, 0, -PageHeight);
      CombinePDFXForm(CanvasMat, Matrix, CanvasMat);

      if (FPrintOptions.AutoRotateCenter) then
      begin
        HDifference := ((PageWidth * FinalScale) - (CanvasWidth * 72 / FDPI)) / 2;
        VDifference := ((PageHeight * FinalScale) - (CanvasHeight * 72 / FDPI)) / 2;
        Mat(Matrix, 1, 0, 0, 1, -HDifference / FinalScale, VDifference / FinalScale);
        CombinePDFXForm(CanvasMat, Matrix, CanvasMat);
      end;
    end else
    begin
      Mat(Matrix, FDPI / 72, 0, 0, -FDPI / 72, 0, CanvasHeight);
      CombinePDFXForm(CanvasMat, Matrix, CanvasMat);
    end;

    case Rotate of
      0: Mat(Matrix, 1, 0, 0, 1, 0, 0);
      90: Mat(Matrix, 0, -1, 1, 0, 0, PageHeight);
      180: Mat(Matrix, -1, 0, 0, -1, PageWidth, PageHeight);
      270: Mat(Matrix, 0, 1, -1, 0, PageWidth, 0);
    end;
    CombinePDFXForm(CanvasMat, Matrix, CanvasMat);

    // Shift the output by the page boundary (CropBox or MediaBox)
    Mat(Matrix, 1, 0, 0, 1, -PageLeft, -PageBottom);
    CombinePDFXForm(CanvasMat, Matrix, CanvasMat);

    Picasso := TPDFPicasso.Create;
    try
      if (FDestination = rdPrinter)
{$IFDEF QPL_DPLR}
      or (FDestination = rdDPLRPrinter)
{$ENDIF}
      then
      begin
        if (PrinterJPEGCaps(FCanvas.Handle) or PrinterPNGCaps(FCanvas.Handle)) then
        begin
          Picasso.ImagePrintMode := pmOptimizeImages;
        end;
      end;

      Picasso.PathCombineMode := FGDIPlusSettings.PathCombineMode;

      Picasso.PageHeight := PageHeight;
      //Picasso.RenderOffsetX := FDeviceContextOffsetX;
      //Picasso.RenderOffsetY := FDeviceContextOffsetY;

      if FDestination = rdEMFPlus then
      begin
        Picasso.SetupMetafile(CanvasWidth, CanvasHeight, FEMFPlusTarget);
      end;
      if FDestination = rdDeviceContext then
      begin
        Picasso.SetupDeviceContext(CanvasWidth, CanvasHeight, FDeviceContextTarget);
      end;
      if FDestination = rdHTML5 then
      begin
        Picasso.UseHTML5Model(FHTML5Target);
      end else
{$IFDEF QPL_CAIRO}
      if FDestination = rdCairo then
      begin
        Picasso.UseCairoModel(FCairoTarget, FCairoFileName, FCairoErasePage);
      end else
      if FDestination = rdCairoBitmap then
      begin
        Picasso.UseCairoModel(FBitmap.Canvas.Handle, FCairoFileName, FCairoErasePage);
      end else
{$ENDIF}
{$IFDEF QPL_DPLR}
      if FDestination = rdDPLR then
      begin
        Picasso.UseRendererModel(FDPLRTarget, FDPLRFileName, FDPLRErasePage);
      end else
      if FDestination = rdDPLRBitmap then
      begin
        Picasso.UseRendererModel(FBitmap.Canvas.Handle, FDPLRFileName, FDPLRErasePage);
      end else
      if FDestination = rdDPLRMemory then
      begin
        Picasso.UseRendererModelMemory(FDPLRMemoryWidth, FDPLRMemoryHeight, FDPLRFileName);
      end else
{$ENDIF}
      begin
        if FGDIPlusSettings.UseGDIPlus then
          Picasso.UseGDIPlusModel(FCanvas, FGDIPlusSettings)
        else
          Picasso.UseGDIModel(FCanvas);
      end;

{$IFDEF QPL_DPLR}
      if (FDestination = rdDeviceContext) then
      begin
        // Set the intial clipping path
        if (Length(FClipBBoxArray) > 0) then
        begin
          Picasso.BeginPath;
          for R := 0 to Length(FClipBBoxArray) - 1 do
          begin
            // clipping path
            Picasso.MoveTo(FClipBBoxArray[R].Left, FClipBBoxArray[R].Top);
            Picasso.AddLineToPath(FClipBBoxArray[R].Left, FClipBBoxArray[R].Bottom);
            Picasso.AddLineToPath(FClipBBoxArray[R].Right, FClipBBoxArray[R].Bottom);
            Picasso.AddLineToPath(FClipBBoxArray[R].Right, FClipBBoxArray[R].Top);
          end;
          Picasso.ClosePath;
          Picasso.SetClippingPath(pfWinding);
          Picasso.NullPath;
        end;
      end
      else if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
      begin
        Mat(IdentityMatrix, 1, 0, 0, 1, 0, 0);
        Picasso.SetCurrentXForm(IdentityMatrix);
        Picasso.SetPageMatrix(IdentityMatrix);
        // Set the intial clipping path
        if (Length(FClipBBoxArray) > 0) and Assigned(Picasso.RendererDLL) then
        begin
          Picasso.RendererDLL.DPLR_set_fill_rule(Picasso.RendererHandle, DPLR_FILL_RULE_WINDING);
          Picasso.RendererDLL.DPLR_new_path(Picasso.RendererHandle);
          for R := 0 to Length(FClipBBoxArray) - 1 do
          begin
            // clipping path
            Picasso.RendererDLL.DPLR_move_to(Picasso.RendererHandle, FClipBBoxArray[R].Left, FClipBBoxArray[R].Top);
            Picasso.RendererDLL.DPLR_line_to(Picasso.RendererHandle, FClipBBoxArray[R].Right, FClipBBoxArray[R].Top);
            Picasso.RendererDLL.DPLR_line_to(Picasso.RendererHandle, FClipBBoxArray[R].Right, FClipBBoxArray[R].Bottom);
            Picasso.RendererDLL.DPLR_line_to(Picasso.RendererHandle, FClipBBoxArray[R].Left, FClipBBoxArray[R].Bottom);
            Picasso.RendererDLL.DPLR_close_path(Picasso.RendererHandle);
          end;
          Picasso.RendererDLL.DPLR_set_bin_clip(Picasso.RendererHandle);
          Picasso.NullPath;
        end else
        begin
          Picasso.BeginPath;
          Picasso.MoveTo(0, 0);
          Picasso.AddLineToPath(0, CanvasHeight);
          Picasso.AddLineToPath(CanvasWidth, CanvasHeight);
          Picasso.AddLineToPath(CanvasWidth, 0);
          Picasso.ClosePath;
          Picasso.SetClippingPath(pfWinding);
          Picasso.NullPath;
        end;

        CanvasMat.eDx := CanvasMat.eDx - FDPLROffsetX;
        CanvasMat.eDy := CanvasMat.eDy - FDPLROffsetY;
        Picasso.SetCurrentXForm(CanvasMat);
        Picasso.SetPageMatrix(CanvasMat);
        FPageMatrix := CanvasMat;
      end;
 {$ENDIF}

      StartMatrix := CanvasMat;
      SubRender(Picasso, FPageDict);

{$IFDEF QPL_DPLR}
      if (FDestination = rdDPLR) then
      begin
        Picasso.FinishDPLR(FDPLRTarget);
      end else
      if (FDestination = rdDPLRBitmap) then
      begin
        Picasso.FinishDPLR(FBitmap.Canvas.Handle);
      end else
      if (FDestination = rdDPLRMemory) then
      begin
        Picasso.FinishDPLRMemory(FDPLRMemoryTarget, FDPLRMemoryWidth, FDPLRMemoryHeight, FDPLRMemoryBitsPerPixel);
      end;
{$ENDIF}
      if FDestination = rdHTML5 then
      begin
        Picasso.FinishHTML5(CanvasWidth, CanvasHeight);
      end;
    finally
      Picasso.Free;
    end;

    if (FDestination = rdWMF) or (FDestination = rdEMF) then
    begin
      FCanvas.Free;
      FCanvas := Nil;
    end;

{$IFNDEF QPL_NOVCL}
    finally
      if Assigned(FCanvas) then
        FCanvas.Unlock;
    end;
{$ENDIF}
  end;

  if FDestination = rdEPS then
  begin
    Mat(Matrix, 1, 0, 0, 1, 0, 0);
    FMaxX := Round(PageRight) + 1;
    FMaxY := Round(PageTop) + 1;
    CanvasMat := Matrix;
    FEPS.StartDocument(PageLeft, PageBottom, PageRight, PageTop);
    Picasso := TPDFPicasso.Create;
    try
      StartMatrix := CanvasMat;
      SubRender(Picasso, FPageDict);
    finally
      Picasso.Free;
    end;
    FEPS.FinishDocument;
  end;

  if FDestination = rdTextFunnel then
  begin
    Mat(Matrix, 1, 0, 0, 1, 0, 0);
    FMaxX := Round(PageRight) + 1;
    FMaxY := Round(PageTop) + 1;
    CanvasMat := Matrix;
    Picasso := TPDFPicasso.Create;
    try
      StartMatrix := CanvasMat;
      SubRender(Picasso, FPageDict);
    finally
      Picasso.Free;
    end;
  end;

  if FDestination = rdImageList then
  begin
    Mat(Matrix, 1, 0, 0, 1, 0, 0);
    FMaxX := Round(PageRight) + 1;
    FMaxY := Round(PageTop) + 1;
    CanvasMat := Matrix;
    Picasso := TPDFPicasso.Create;
    try
      StartMatrix := CanvasMat;
      SubRender(Picasso, FPageDict);
    finally
      Picasso.Free;
    end;
  end;

{$IFDEF QPL_DPLR}
  if ((FDestination = rdDPLRPrinter) and (Length(FPrinterBBoxArray) > 0)) then
  begin
    DPLRPrintMatrix := CanvasMat;

    PageLeft := FPrinterBBoxArray[0].Left;
    PageRight := FPrinterBBoxArray[0].Right;
    PageTop := FPrinterBBoxArray[0].Top;
    PageBottom := FPrinterBBoxArray[0].Bottom;
    for R := 1 to Length(FPrinterBBoxArray) - 1 do
    begin
      PageLeft := Math.Min(PageLeft, FPrinterBBoxArray[R].Left);
      PageTop := Math.Min(PageTop, FPrinterBBoxArray[R].Top);
      PageRight := Math.Max(PageRight, FPrinterBBoxArray[R].Right);
      PageBottom := Math.Max(PageBottom, FPrinterBBoxArray[R].Bottom);
    end;

    // temporary render only 1 bitmap (TODO - split to strips)
    DPLRPrintWidth := Abs(Round(PageRight - PageLeft));
    DPLRPrintHeight := Abs(Round(PageBottom - PageTop));

    if ((DPLRPrintWidth > 0) and (DPLRPrintHeight > 0)) then
    begin
      GetMem(DPLRPrintData, DPLRPrintWidth * DPLRPrintHeight * 3);
      if (Assigned(DPLRPrintData)) then
      try
        ClearCachedResources;

        FDestination := rdDPLRMemory;
        FDPLRMemoryTarget := DPLRPrintData;
        FDPLRMemoryWidth := DPLRPrintWidth;
        FDPLRMemoryHeight := DPLRPrintHeight;
        FDPLRMemoryBitsPerPixel := 24;
        FDPLRErasePage := False;
        FDPLROffsetX := Round(PageLeft);
        FDPLROffsetY := Round(PageTop);
        CanvasMat := DPLRPrintMatrix;
        CanvasMat.eDx := CanvasMat.eDx - FDPLROffsetX;
        CanvasMat.eDy := CanvasMat.eDy - FDPLROffsetY;

        Picasso := TPDFPicasso.Create;
        try
          Picasso.PageHeight := PageHeight;
          //Picasso.RenderOffsetX := FDeviceContextOffsetX;
          //Picasso.RenderOffsetY := FDeviceContextOffsetY;
          Picasso.UseRendererModelMemory(DPLRPrintWidth, DPLRPrintHeight, FDPLRFileName);

          Picasso.RendererDLL.DPLR_set_matrix(Picasso.RendererHandle, 1, 0, 0, 1, -FDPLROffsetX, -FDPLROffsetY);
          Picasso.RendererDLL.DPLR_set_fill_rule(Picasso.RendererHandle, DPLR_FILL_RULE_WINDING);
          Picasso.RendererDLL.DPLR_new_path(Picasso.RendererHandle);
          for R := 0 to Length(FPrinterBBoxArray) - 1 do
          begin
            // clipping path
            Picasso.RendererDLL.DPLR_move_to(Picasso.RendererHandle, FPrinterBBoxArray[R].Left, FPrinterBBoxArray[R].Top);
            Picasso.RendererDLL.DPLR_line_to(Picasso.RendererHandle, FPrinterBBoxArray[R].Right, FPrinterBBoxArray[R].Top);
            Picasso.RendererDLL.DPLR_line_to(Picasso.RendererHandle, FPrinterBBoxArray[R].Right, FPrinterBBoxArray[R].Bottom);
            Picasso.RendererDLL.DPLR_line_to(Picasso.RendererHandle, FPrinterBBoxArray[R].Left, FPrinterBBoxArray[R].Bottom);
            Picasso.RendererDLL.DPLR_close_path(Picasso.RendererHandle);
          end;
          Picasso.RendererDLL.DPLR_set_bin_clip(Picasso.RendererHandle);

          Picasso.SetCurrentXForm(CanvasMat);
          Picasso.SetPageMatrix(CanvasMat);
          FPageMatrix := CanvasMat;
          StartMatrix := CanvasMat;

          SubRender(Picasso, FPageDict);
          Picasso.FinishDPLRMemory(FDPLRMemoryTarget, DPLRPrintWidth, DPLRPrintHeight, 24);
        finally
          Picasso.Free;
        end;

        for R := 0 to Length(FPrinterBBoxArray) - 1 do
        begin
          PrintRaw24BitBGRRect(FQPLPrinter.Canvas.Handle, FDPLRMemoryTarget,
            FDPLROffsetX, FDPLROffsetY, DPLRPrintWidth, DPLRPrintHeight,
            Round(FPrinterBBoxArray[R].Left - FDPLROffsetX), Round(FPrinterBBoxArray[R].Top - FDPLROffsetY),
            Round(FPrinterBBoxArray[R].Right - FPrinterBBoxArray[R].Left),
            Round(FPrinterBBoxArray[R].Bottom - FPrinterBBoxArray[R].Top),
            FGDIPlusSettings.PrintMode);
        end;
      finally
        if Assigned(DPLRPrintData) then
          FreeMem(DPLRPrintData);
        FDestination := rdDPLRPrinter;  // return the destination flag for next page
      end;
    end;
  end;
{$ENDIF}

{$IFNDEF QPL_NOVCL}
  finally
    FBitmap.Canvas.Unlock;
  end;
{$ENDIF}
end;

procedure TPDFRenderer.RenderSource(Source: TPDFObject;
  ContainerIR: TPDFIndRef; PageLeft, PageBottom, PageWidth, PageHeight: Double);
var
  CanvasWidth: Integer;
  CanvasHeight: Integer;
  FCanvas: TCanvas;
  Matrix: TPDFXForm;
  FloatCompare1: Double;
  FloatCompare2: Double;
const
  BoxNames: array[1..5] of AnsiString = ('MediaBox', 'CropBox', 'BleedBox',
    'TrimBox', 'ArtBox');
begin
{$IFNDEF QPL_NOVCL}
  FBitmap.Canvas.Lock;
{$ENDIF}

  FUseInitialState := False;
  FFontCol.UsingTextFunnel := (FDestination = rdTextFunnel);

  if (FDPI = 0) then
  begin
    FDPI := 1;
  end;

  // Start with the identity matrix
  Mat(CanvasMat, 1, 0, 0, 1, 0, 0);

  CanvasWidth := 10;
  CanvasHeight := 10;
  FCanvas := nil;

  if (Destination = rdBitmap) then
  begin
    FCanvas := FBitmap.Canvas;
    FBitmap.Width := Round(PageWidth * FDPI / 72);
    FBitmap.Height := Round(PageHeight * FDPI / 72);

    FloatCompare1 := FBitmap.Width * 72;
    FloatCompare2 := PageWidth * FDPI;
    if FloatCompare1 < FloatCompare2 then
      FBitmap.Width := FBitmap.Width + 1;

    FloatCompare1 := FBitmap.Height * 72;
    FloatCompare2 := PageHeight * FDPI;
    if FloatCompare1 < FloatCompare2 then
      FBitmap.Height := FBitmap.Height + 1;

    CanvasWidth := FBitmap.Width;
    CanvasHeight := FBitmap.Height;
  end else
  if (Destination = rdEMFPlus) then
  begin
    CanvasWidth := Round(PageWidth * FDPI / 72);
    CanvasHeight := Round(PageHeight * FDPI / 72);

    FloatCompare1 := CanvasWidth * 72;
    FloatCompare2 := PageWidth * FDPI;
    if FloatCompare1 < FloatCompare2 then
      CanvasWidth := CanvasWidth + 1;

    FloatCompare1 := CanvasHeight * 72;
    FloatCompare2 := PageHeight * FDPI;
    if FloatCompare1 < FloatCompare2 then
      CanvasHeight := CanvasHeight + 1;
  end;

  FMaxX := CanvasWidth;
  FMaxY := CanvasHeight;

  // Scale the output using the FDPI value
  Mat(Matrix, CanvasWidth / PageWidth, 0, 0, -CanvasHeight / PageHeight, 0, CanvasHeight);
  CombinePDFXForm(CanvasMat, Matrix, CanvasMat);

  // Shift the output by the page boundary (CropBox or MediaBox)
  Mat(Matrix, 1, 0, 0, 1, -PageLeft, -PageBottom);
  CombinePDFXForm(CanvasMat, Matrix, CanvasMat);

  Picasso := TPDFPicasso.Create;
  try
    Picasso.PageHeight := PageHeight;

    if FDestination = rdEMFPlus then
    begin
      Picasso.SetupMetafile(CanvasWidth, CanvasHeight, FEMFPlusTarget);
    end;

    if FGDIPlusSettings.UseGDIPlus then
    begin
      Picasso.UseGDIPlusModel(FCanvas, FGDIPlusSettings);
    end else
    begin
      Picasso.UseGDIModel(FCanvas);
    end;

    StartMatrix := CanvasMat;
    SubRender(Picasso, Source, ContainerIR);
  finally
    Picasso.Free;
  end;

{$IFNDEF QPL_NOVCL}
  FBitmap.Canvas.Unlock;
{$ENDIF}
end;

procedure TPDFRenderer.RenderToImageStream(Source: TPDFObject;
  ContainerIR: TPDFIndRef; Target: TStream; Left, Bottom, Width, Height: Double; var Scale: Double);
var
  ChildRenderer: TPDFRenderer;
  UseEMFPlus: Boolean;
  ChildDPI: Double;
  ChildDPIX, ChildDPIY: Double;
  MaxDimension: Double;
begin
  UseEMFPlus := False;
  ChildRenderer := TPDFRenderer.Create(FFontCol);
  try
    ChildRenderer.GDIPlusSettings := FGDIPlusSettings;
    ChildRenderer.OnFindObject := FOnFindObject;
    ChildRenderer.OnDecrypt := FOnDecrypt;
    ChildRenderer.OnEncrypt := FOnEncrypt;

    ChildDPI := FDPI;

    if ((ChildDPI * Width / 72) < 10) and ((ChildDPI * Height / 72) < 10) then
    begin
      ChildDPI := FDPI * 10;
    end;

    // Limit the texture size to max 3000x3000 pixels

    ChildDPIX := ChildDPI;
    ChildDPIY := ChildDPI;

    MaxDimension := 3000;
    if ((ChildDPI * Width / 72) > MaxDimension) then
    begin
      ChildDPIX := FDPI * (MaxDimension / (ChildDPI * Width / 72));
    end;

    if ((ChildDPI * Height / 72) > MaxDimension) then
    begin
      ChildDPIY := FDPI * (MaxDimension / (ChildDPI * Height / 72));
    end;
    ChildDPI := Min(ChildDPIX, ChildDPIY);
    // =====================

    Scale := FDPI / ChildDPI;
    ChildRenderer.DPI := ChildDPI;

    if (UseEMFPlus) then
    begin
      ChildRenderer.Destination := rdEMFPlus;
      ChildRenderer.SetEMFPlusTarget(Target);
    end else
    begin
      ChildRenderer.Destination := rdBitmap;
    end;

    ChildRenderer.PageDict := FPageDict;
    ChildRenderer.RenderSource(Source, ContainerIR, Left, Bottom, Width, Height);

    if (not UseEMFPlus) then
    begin
      ChildRenderer.Bitmap.Canvas.Lock;
      try
        ChildRenderer.Bitmap.SaveToStream(Target);
      finally
        ChildRenderer.Bitmap.Canvas.Unlock;
      end;
    end;

    Target.Seek(0, soFromBeginning);
  finally
    ChildRenderer.Free;
  end;
end;

{$IFDEF QPL_CAIRO}
procedure TPDFRenderer.SetCairoTarget(const CairoFileName: WideString; Target: HDC; ErasePage: Boolean; OffsetX, OffsetY: Integer);
begin
  FCairoTarget := Target;
  FCairoFileName := CairoFileName;
  FCairoErasePage := ErasePage;
  FCairoOffsetX := OffsetX;
  FCairoOffsetY := OffsetY;
end;
{$ENDIF}

{$IFDEF QPL_DPLR}
procedure TPDFRenderer.SetDPLRTarget(const DPLRFileName: WideString; Target: HDC; ErasePage: Boolean; OffsetX, OffsetY: Integer);
begin
  FDPLRTarget := Target;
  FDPLRFileName := DPLRFileName;
  FDPLRErasePage := ErasePage;
  FDPLROffsetX := OffsetX;
  FDPLROffsetY := OffsetY;
end;

procedure TPDFRenderer.SetDPLRMemoryTarget(const DPLRFileName: WideString; Target: Pointer; Width, Height, BitsPerPixel: Integer; ErasePage: Boolean; OffsetX, OffsetY: Integer);
begin
  FDPLRMemoryTarget := Target;
  FDPLRMemoryWidth := Width;
  FDPLRMemoryHeight := Height;
  FDPLRMemoryBitsPerPixel := BitsPerPixel;
  FDPLRFileName := DPLRFileName;
  FDPLRErasePage := ErasePage;
  FDPLROffsetX := OffsetX;
  FDPLROffsetY := OffsetY;
end;

function TPDFRenderer.AdjustBBox(Left, Top, Right, Bottom: PDouble): Boolean;
var
  LT: Double;
  TT: Double;
begin
  Result := False;

  LT := Left^;
  Left^ := Math.Min(Left^, Right^);
  Right^ := Math.Max(LT, Right^);
  TT := Top^;
  Top^ := Math.Min(Top^, Bottom^);
  Bottom^ := Math.Max(TT, Bottom^);
  if (Right^ - Left^ <= 0) then Exit;
  if (Bottom^ - Top^ <= 0) then Exit;

  Left^ := Floor(Left^);
  Right^ := Ceil(Right^);
  //TT := Top^;
  Top^ := Floor(Top^);
  Bottom^ := Ceil(Bottom^);
  if (Right^ - Left^ <= 0) then Exit;
  if (Bottom^ - Top^ <= 0) then Exit;

  if (Right^ < 0) then Exit;
  if (Right^ > FMaxX) then Right^ := FMaxX;
  if (Left^ < 0) then Left^ := 0;
  if (Left^ > FMaxX) then Exit;
  if (Top^ < 0) then Top^ := 0;
  if (Top^ > FMaxY) then Exit;
  if (Bottom^ < 0) then Exit;
  if (Bottom^ > FMaxY) then Bottom^ := FMaxY;
  if (Right^ - Left^ <= 0) then Exit;
  if (Bottom^ - Top^ <= 0) then Exit;

  Result := True;
end;

function TPDFRenderer.IsBBoxInPrinterArray(Left, Top, Right, Bottom: Double): Boolean;
var
  R: Integer;
begin
  if (AdjustBBox(@Left, @Top, @Right, @Bottom) = False) then
  begin
    Result := True;  // zero rect, we don't need to print it
    exit;
  end;
  for R := 0 to Length(FPrinterBBoxArray) - 1 do
  begin
    if (Left >= FPrinterBBoxArray[R].Left) and
      (Right <= FPrinterBBoxArray[R].Right) and
      (Top >= FPrinterBBoxArray[R].Top) and
      (Bottom <= FPrinterBBoxArray[R].Bottom) then
      begin
        Result := True;
        Exit;
      end;
  end;
  Result := False;
end;

procedure TPDFRenderer.AddToPrinterBBoxArray(Left, Top, Right, Bottom: Double);
var
  ILeft: Integer;
  ITop: Integer;
  IRight: Integer;
  IBottom: Integer;

  procedure DeleteBBox(const Index: Integer);
  var
    I: Integer;
  begin
    for I := Index to Length(FPrinterBBoxArray) - 2 do
    begin
      FPrinterBBoxArray[I].Left := FPrinterBBoxArray[I+1].Left;
      FPrinterBBoxArray[I].Right := FPrinterBBoxArray[I+1].Right;
      FPrinterBBoxArray[I].Top := FPrinterBBoxArray[I+1].Top;
      FPrinterBBoxArray[I].Bottom := FPrinterBBoxArray[I+1].Bottom;
    end;
    SetLength(FPrinterBBoxArray, Length(FPrinterBBoxArray) - 1);
  end;

  procedure AddBBox(Left, Top, Right, Bottom: Double);
  var
    R: Integer;
    TempArray: TPrinterBBoxArray;
  begin
    if (AdjustBBox(@Left, @Top, @Right, @Bottom) = False) then
      Exit;

    SetLength(TempArray, 1);
    TempArray[Length(TempArray) - 1].Left := Floor(Left);
    TempArray[Length(TempArray) - 1].Top := Floor(Top);
    TempArray[Length(TempArray) - 1].Right := Floor(Right);
    TempArray[Length(TempArray) - 1].Bottom := Floor(Bottom);

    for R := 0 to Length(FPrinterBBoxArray) - 1 do
    begin
      // intersection
      ILeft := Math.Max(FPrinterBBoxArray[R].Left, Floor(Left));
      IRight := Math.Min(FPrinterBBoxArray[R].Right, Floor(Right));
      ITop := Math.Max(FPrinterBBoxArray[R].Top, Floor(Top));
      IBottom := Math.Min(FPrinterBBoxArray[R].Bottom, Floor(Bottom));
      if (IBottom - ITop > 0) and (IRight - ILeft > 0) then
      begin
        if (FPrinterBBoxArray[R].Top < ITop) then
        begin
          if (ITop - 1 - FPrinterBBoxArray[R].Top > 0) then
          begin
            SetLength(TempArray, Length(TempArray) + 1);
            TempArray[Length(TempArray) - 1].Left := FPrinterBBoxArray[R].Left;
            TempArray[Length(TempArray) - 1].Right := FPrinterBBoxArray[R].Right;
            TempArray[Length(TempArray) - 1].Top := FPrinterBBoxArray[R].Top;
            TempArray[Length(TempArray) - 1].Bottom := ITop - 1;
          end;
        end;
        if (FPrinterBBoxArray[R].Left < ILeft)then
        begin
          if (IRight - 1 - FPrinterBBoxArray[R].Left > 0) then
          begin
            SetLength(TempArray, Length(TempArray) + 1);
            TempArray[Length(TempArray) - 1].Left := FPrinterBBoxArray[R].Left;
            TempArray[Length(TempArray) - 1].Right := IRight - 1;
            TempArray[Length(TempArray) - 1].Top := ITop;
            TempArray[Length(TempArray) - 1].Bottom := IBottom;
          end;
        end;
        if (FPrinterBBoxArray[R].Right > IRight) then
        begin
          if (FPrinterBBoxArray[R].Right - IRight - 1 > 0) then
          begin
            SetLength(TempArray, Length(TempArray) + 1);
            TempArray[Length(TempArray) - 1].Left := IRight + 1;
            TempArray[Length(TempArray) - 1].Right := FPrinterBBoxArray[R].Right;
            TempArray[Length(TempArray) - 1].Top := ITop;
            TempArray[Length(TempArray) - 1].Bottom := IBottom;
          end;
        end;
        if (FPrinterBBoxArray[R].Bottom > IBottom) then
        begin
          if (FPrinterBBoxArray[R].Bottom - IBottom - 1 > 0) then
          begin
            SetLength(TempArray, Length(TempArray) + 1);
            TempArray[Length(TempArray) - 1].Left := FPrinterBBoxArray[R].Left;
            TempArray[Length(TempArray) - 1].Right := FPrinterBBoxArray[R].Right;
            TempArray[Length(TempArray) - 1].Top := IBottom + 1;
            TempArray[Length(TempArray) - 1].Bottom := FPrinterBBoxArray[R].Bottom;
          end;
        end;
      end else
      begin
        SetLength(TempArray, Length(TempArray) + 1);
        TempArray[Length(TempArray) - 1].Left := FPrinterBBoxArray[R].Left;
        TempArray[Length(TempArray) - 1].Right := FPrinterBBoxArray[R].Right;
        TempArray[Length(TempArray) - 1].Top := FPrinterBBoxArray[R].Top;
        TempArray[Length(TempArray) - 1].Bottom := FPrinterBBoxArray[R].Bottom;
      end;
    end;

    SetLength(FPrinterBBoxArray, Length(TempArray));
    for R := 0 to Length(TempArray) - 1 do
    begin
      FPrinterBBoxArray[R].Left := TempArray[R].Left;
      FPrinterBBoxArray[R].Top := TempArray[R].Top;
      FPrinterBBoxArray[R].Right := TempArray[R].Right;
      FPrinterBBoxArray[R].Bottom := TempArray[R].Bottom;
    end;
  end;

  procedure OptimizePrinterBBoxArray();
  var
    R,P, It, TotalIt: Integer;
    Area, AreaR, AreaP: Double;
    Optimize: Boolean;
  begin
    It := 0;
    TotalIt := Length(FPrinterBBoxArray) * Length(FPrinterBBoxArray);
    Optimize := True;
    while Optimize and (It < TotalIt) do
    begin
      Optimize := False;
      Inc(It);
      for R := Length(FPrinterBBoxArray) - 1 downto 0 do
      begin
        AreaR := (FPrinterBBoxArray[R].Right - FPrinterBBoxArray[R].Left) *
          (FPrinterBBoxArray[R].Bottom - FPrinterBBoxArray[R].Top);

        for P := R - 1 downto 0 do
        begin
          AreaP := (FPrinterBBoxArray[P].Right - FPrinterBBoxArray[P].Left) *
            (FPrinterBBoxArray[P].Bottom - FPrinterBBoxArray[P].Top);

          // union
          ILeft := Math.Min(FPrinterBBoxArray[R].Left, FPrinterBBoxArray[P].Left);
          IRight := Math.Max(FPrinterBBoxArray[R].Right, FPrinterBBoxArray[P].Right);
          ITop := Math.Min(FPrinterBBoxArray[R].Top, FPrinterBBoxArray[P].Top);
          IBottom := Math.Max(FPrinterBBoxArray[R].Bottom, FPrinterBBoxArray[P].Bottom);
          Area := (IRight - ILeft) * (IBottom - ITop);

          AreaP := (AreaR + AreaP) / Area;
          if AreaP > 0.8 then
          //if ((AreaR + AreaP) / Area) > 0.8 then
          begin
            DeleteBBox(R);
            DeleteBBox(P);
            AddBBox(ILeft, ITop, IRight, IBottom);
            Optimize := True;
            break;
          end;
        end;

        if Optimize then
          break;
      end;
    end;
  end;

begin
  AddBBox(Left, Top, Right, Bottom);
  OptimizePrinterBBoxArray();
end;
{$ENDIF}

procedure TPDFRenderer.SetDeviceContextTarget(Target: HDC; ErasePage: Boolean; OffsetX, OffsetY: Integer);
begin
  FDeviceContextTarget := Target;
  FDeviceContextErasePage := ErasePage;
  FDeviceContextOffsetX := OffsetX;
  FDeviceContextOffsetY := OffsetY;
end;

procedure TPDFRenderer.SetEMFPlusTarget(Target: TStream);
begin
  FEMFPlusTarget := Target;
end;

procedure TPDFRenderer.SetFunnel(NewFunnel: TPDFTextFunnel);
begin
  if Assigned(FFunnel) then
  begin
    if not FExternalFunnel then FFunnel.Free;
    FFunnel := NewFunnel;
    FExternalFunnel := True;
  end;
end;

procedure TPDFRenderer.SetHTML5Target(Target: TStream);
begin
  FHTML5Target := Target;
end;

procedure TPDFRenderer.SubRender(Picasso: TPDFPicasso; Source: TPDFObject;
  ContainerIR: TPDFIndRef; const Type3CharProc: AnsiString);
var
  Obj: TPDFObject;
  S: AnsiString;
  TokPos: Integer;
  MaxLen: Integer;
  Tok: AnsiString;
  GS: TPDFGraphicsState;
  Stack: array of TPDFGraphicsState;
  StackSize: Integer;
  OperandList: array of AnsiString;
  OperandCount: Integer;
  ArrayCount: Integer;
  D: array[1..10] of Double;
  DP: TPDFDoublePoint;
  DP2: TPDFDoublePoint;
  DP3: TPDFDoublePoint;
  InPath: Boolean;
  Resources: TPDFDictionary;
  Annots: TPDFArray;
  AX: Integer;
  Str: AnsiString;
  NewMatrix: TPDFXForm;
  InlineImage: TPDFInlineImage;
  AnnotDict: TPDFDictionary;
  AnnotFlags: Integer;
  InlineID: TPDFImageDecoder;
  MCTag: AnsiString;
  MCProp: AnsiString;
  MCStack: TQuickPDFStringList;
  MCVisible: Boolean;
  IgnoreColorCommands: Boolean;
  RenderFlag: Boolean;
  LastFICCProfile: AnsiString;
  LastFICCProfileIndObj: Integer;
{$IFDEF QPL_OS_WINDOWS}
  LastProgress: Integer;
  NewProgress: Integer;
{$ENDIF}
{$IFDEF QPL_DPLR}
  GDIPlusRect: TGPRectF;
{$ENDIF}
  ImageListItem: TPDFImageListItem;
  TP1: TPDFDoublePoint;
  TP2: TPDFDoublePoint;
  TP3: TPDFDoublePoint;
  TP4: TPDFDoublePoint;

  procedure AddOperand(const Tok: AnsiString);
  begin
    if Length(Tok) > 0 then
    begin
      Inc(OperandCount);
      if OperandCount >= Length(OperandList) then
      begin
        SetLength(OperandList, Length(OperandList) + 100);
      end;
      OperandList[OperandCount - 1] := Tok;
    end;
  end;

  function PopDouble: Double;
  begin
    if OperandCount > 0 then
    begin
      Dec(OperandCount);
      TazzToFloatVar(OperandList[OperandCount], Result);
    end else
      Result := 0;
  end;

  function PopString: AnsiString;
  begin
    if OperandCount > 0 then
    begin
      Dec(OperandCount);
      Result := OperandList[OperandCount];
    end else
      Result := '';
  end;

  function GetPattern(const ResourceName: AnsiString): TQPLPattern;
  var
    O: TPDFObject;
    ResourcePatternDict: TPDFDictionary;
    ResourceShadingDict: TPDFDictionary;
    PatternDict: TPDFDictionary;
    PatternStream: TPDFStream;
    PatternIndex: Integer;
    PatternRef: TPDFIndRef;
    TileScale: Double;
  begin
    Result := nil;
    if (Assigned(Resources)) then
    begin
      // Look for the /Pattern dictionary in the resource dictionary
      O := Resources.FindValueByKeyName('Pattern', False);
      if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
      if O is TPDFDictionary then
      begin
        ResourcePatternDict := TPDFDictionary(O);

        // Look for the resource name in the pattern dictionary
        O := ResourcePatternDict.FindValueByKeyName(QPLCopy(ResourceName, 2, MaxInt));
      end else
      begin
        O := nil;
      end;

      if (not Assigned(O)) then
      begin
        // Look for the /Shading dictionary in the resource dictionary
        O := Resources.FindValueByKeyName('Shading', False);
        if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
        if O is TPDFDictionary then
        begin
          ResourceShadingDict := TPDFDictionary(O);

          // Look for the resource name in the shading dictionary
          O := ResourceShadingDict.FindValueByKeyName(QPLCopy(ResourceName, 2, MaxInt));
        end else
        begin
          O := nil;
        end;
      end;

      PatternDict := nil;
      PatternStream := nil;
      if (O is TPDFIndRef) then
      begin
        PatternRef := TPDFIndRef(O);
        O := FindObject(PatternRef);
      end else
      begin
        PatternRef := nil;
      end;
      if (O is TPDFDictionary) then PatternDict := TPDFDictionary(O);
      if (O is TPDFStream) then
      begin
        PatternStream := TPDFStream(O);
        PatternDict := PatternStream.Dictionary;
      end;

      if (Assigned(PatternDict)) then
      begin
        // Look for an existing pattern
        for PatternIndex := 0 to Length(FPatterns) - 1 do

        begin
          if (FPatterns[PatternIndex].SourceDict = PatternDict) then
          begin
            Result := FPatterns[PatternIndex];
          end;
        end;

        if (not Assigned(Result)) then
        begin
          // Populate the new pattern
          Result := TQPLPattern.Create(FColorManager);
          Result.OnFindObject := FOnFindObject;
          Result.OnEncrypt := FOnEncrypt;
          Result.OnDecrypt := FOnDecrypt;
{$IFDEF QPL_DPLR}
          if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
          begin
            Result.UseRendererModel();
          end;
{$ENDIF}
          Result.Populate(PatternDict, PatternStream, PatternRef);

          if (Picasso.Model = pmGDIPlus) then
          begin
            if (Assigned(PatternStream) and (Result.PatternType = ptColorTile)) then
            begin
              TileScale := 1;
              RenderToImageStream(PatternStream, PatternRef, Result.TileImageData,
                Result.GetBBox(0),
                Result.GetBBox(1),
                Min(Result.GetBBox(2) - Result.GetBBox(0), Result.GetStep(0)),
                Min(Result.GetBBox(3) - Result.GetBBox(1), Result.GetStep(1)),
                TileScale);
              Result.TileScale := TileScale;
            end;
          end;

{$IFDEF QPL_DPLR}
          if not (((FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory)) and (Result.PatternType = ptColorTile) and (Result.GetPaintType = 2)) then
          begin
            // Add the new pattern to the list of patterns
            SetLength(FPatterns, Length(FPatterns) + 1);
            FPatterns[Length(FPatterns) - 1] := Result;
          end;
{$ELSE}
          // Add the new pattern to the list of patterns
          SetLength(FPatterns, Length(FPatterns) + 1);
          FPatterns[Length(FPatterns) - 1] := Result;
{$ENDIF}
        end;
      end;
    end;
  end;

{$IFDEF QPL_DPLR}
  procedure RenderPatternTileDPLR(Pattern: TQPLPattern; const ResourceName: AnsiString);
  var
    O: TPDFObject;
    ResourcePatternDict: TPDFDictionary;
    PatternDict: TPDFDictionary;
    PatternStream: TPDFStream;
    PatternRef: TPDFIndRef;
    ParentRendererHandle: PDPLR_renderer_t;
    TileRendererHandle: PDPLR_renderer_t;
    TileBuffer: PByte;
    MOld: TPDFXForm;
    MNew: TPDFXForm;
    BBox: array[0..3] of Double;
    PointRect: array[0..3] of TPDFDoublePoint;
    Point : TPDFDoublePoint;
    i: Integer;
  begin
    if (Assigned(Resources)) then
    begin
      // Look for the /Pattern dictionary in the resource dictionary
      O := Resources.FindValueByKeyName('Pattern', False);
      if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
      if O is TPDFDictionary then
      begin
        ResourcePatternDict := TPDFDictionary(O);

        // Look for the resource name in the pattern dictionary
        O := ResourcePatternDict.FindValueByKeyName(QPLCopy(ResourceName, 2, MaxInt));
      end else
      begin
        O := nil;
      end;

      PatternDict := nil;
      PatternStream := nil;
      if (O is TPDFIndRef) then
      begin
        PatternRef := TPDFIndRef(O);
        O := FindObject(PatternRef);
      end else
      begin
        PatternRef := nil;
      end;
      if (O is TPDFDictionary) then PatternDict := TPDFDictionary(O);
      if (O is TPDFStream) then
      begin
        PatternStream := TPDFStream(O);
        PatternDict := PatternStream.Dictionary;
      end;

      if (Assigned(PatternDict)) then
      begin
        if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
        begin
          if (Assigned(PatternStream) and (Pattern.PatternType = ptColorTile)) then
          begin
            //Savestate workaround
            Inc(StackSize);
            if StackSize >= Length(Stack) then
            begin
              SetLength(Stack, Length(Stack) + 100);
            end;
            GS.ClipRegion := Picasso.GetCurrentClipRegion;
            Stack[StackSize - 1] := GS;
            //SaveState workaround END
            ParentRendererHandle := Picasso.RendererHandle;
            TileRendererHandle := nil;
            try
              Point.X := Min(Pattern.GetBBox(2), Pattern.GetBBox(0));
              Point.Y := Min(Pattern.GetBBox(1), Pattern.GetBBox(3));
              PointRect[0] := Point;
              Point.X := Max(Pattern.GetBBox(2), Pattern.GetBBox(0));
              PointRect[1] := Point;
              Point.Y := Max(Pattern.GetBBox(1), Pattern.GetBBox(3));
              PointRect[2] := Point;
              Point.X := PointRect[0].X;
              PointRect[3] := Point;

              MNew.eM11 := Pattern.GetMatrix(0);
              MNew.eM12 := Pattern.GetMatrix(1);
              MNew.eM21 := Pattern.GetMatrix(2);
              MNew.eM22 := Pattern.GetMatrix(3);
              MNew.eDx := Pattern.GetMatrix(4);
              MNew.eDy := Pattern.GetMatrix(5);
              MOld := CanvasMat;
              CombinePDFXForm(MNew, MNew , FPageMatrix);
              for i := 0 to 3 do
                  PointRect[i] :=DoPDFXForm(MNew, PointRect[i]);

              BBox[0]:= Min(Min(PointRect[0].X,PointRect[1].X),Min(PointRect[2].X,PointRect[3].X));
              BBox[1]:= Max(Max(PointRect[0].Y,PointRect[1].Y),Max(PointRect[2].Y,PointRect[3].Y));
              BBox[2]:= Max(Max(PointRect[0].X,PointRect[1].X),Max(PointRect[2].X,PointRect[3].X));
              BBox[3]:= Min(Min(PointRect[0].Y,PointRect[1].Y),Min(PointRect[2].Y,PointRect[3].Y));
              MNew.eDx := MNew.eDx-BBox[0];
              MNew.eDy := MNew.eDy-BBox[3];

              BBox[2] := BBox[2]-BBox[0];
              BBox[0] := 0;
              BBox[1] := BBox[1]-BBox[3];
              BBox[3] := 0;

              GetMem(TileBuffer,  Ceil(BBox[2])*Ceil(BBox[1])*4);
              if Assigned(TileBuffer) then
              //if (Ceil(BBox[2])*Ceil(BBox[1]) < 9000000) then
              begin
                TileRendererHandle := Picasso.RendererDLL.DPLR_renderer_tile_create(
                  Ceil(BBox[2]), Ceil(BBox[1]));
                if Assigned(TileRendererHandle) then
                begin
                  Picasso.RendererHandle := TileRendererHandle;
                  FUseInitialState := true;
                  //Set init state for tile rendering
                  FInitialState.XPos := 110;
                  FInitialState.YPos := 700;
                  FInitialState.FillColor := Pattern.UncoloredPatternColor;
                  FInitialState.StrokeColor := Pattern.UncoloredPatternColor;
                  FInitialState.FillColorSpace := Pattern.UncoloredPatternCS;
                  FInitialState.StrokeColorSpace := Pattern.UncoloredPatternCS;
                  FInitialState.FillColorEPS := '0 setgray';
                  FInitialState.StrokeColorEPS := '0 setgray';
                  FInitialState.LineWidth := 1;
                  FInitialState.LineCap := 0;
                  FInitialState.LineJoin := 0;
                  FInitialState.MiterLimit := 10;
                  FInitialState.TextScaling := 100;
                  FInitialState.TextRise := 0;
                  FInitialState.TextSize := 12;
                  FInitialState.TextFont := '';
                  FInitialState.TextLeading := 0;
                  FInitialState.TextRenderingMode := 0;
                  FInitialState.StrokeAlpha := 1;
                  FInitialState.FillAlpha := 1;
                  FInitialState.BlendMode := bmNormal;
                  FInitialState.CharSpacing := 0;
                  FInitialState.WordSpacing := 0;
                  FInitialState.Knockout := False;
                  FInitialState.Softmask := False;
                  FInitialState.FillPattern := nil;
                  FInitialState.StrokePattern := nil;

                  CanvasMat := MNew;
                  SubRender(Picasso, O, PatternRef);

                  Picasso.RendererDLL.DPLR_renderer_tile_copy_buffer(TileRendererHandle, TileBuffer);
                  Pattern.TileRenderBuf := TileBuffer;
                  Pattern.TileWidth := Ceil(BBox[2]);
                  Pattern.TileHeight := Ceil(BBox[1]);
                end else
                begin
                  FreeMem(TileBuffer);
                  Pattern.PDFPatternType := ptNone;
                end;
              end else
                Pattern.PDFPatternType := ptNone;
            finally
              Picasso.RendererHandle := ParentRendererHandle;
              //Restore State workaround
               if StackSize > 0 then
              begin
                Dec(StackSize);
                GS := Stack[StackSize];
              end;
              CanvasMat := GS.CTM;
              Picasso.SetCurrentXForm(CanvasMat);
              //Restore State workaround END
              if(Assigned(TileRendererHandle)) then
              begin
                Picasso.RendererDLL.DPLR_renderer_destroy(TileRendererHandle);
              end;
            end;
          end;
        end;

      end;
    end;
  end;

{$ENDIF}

  procedure SetFillColor;
  var
    K: Double;
    RGB: TPDFRGBColor;
    CMYK: TPDFCMYKColor;
    Sep: TPDFSeparationColorSpace;
    LabColor: TPDFLabColorSpace;
    Lab: TPDFLabColor;
    DeviceNCS: TPDFDeviceNColorSpace;
    DeviceNInput: TPDFDeviceNColor;
    DeviceNIndex: Integer;
    IndexedCS: TPDFIndexedColorSpace;
    ReadTransparency : Boolean;
    PatternAltCS: AnsiString;
    PatternColors: array of Double;
  begin
    ReadTransparency := not GS.Knockout;
{$IFDEF QPL_DPLR}
    if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
    begin
      ReadTransparency := True;
    end;
{$ENDIF}
    if (not IgnoreColorCommands) and ReadTransparency then
    begin
      Picasso.SetBlendMode(GS.BlendMode); // Code review

      GS.FillPattern := nil;
      GS.AlternateFillCS := '';

      if GS.FillColorSpace = 'DeviceRGB' then
      begin
        RGB.Blue := PopDouble;
        RGB.Green := PopDouble;
        RGB.Red := PopDouble;
        GS.FillColor := FColorManager.RGB2Color(RGB);
        GS.FillColorEPS := F(RGB.Red) + F(RGB.Green) + F(RGB.Blue) + 'setrgbcolor';
      end else
      if GS.FillColorSpace = 'DeviceCMYK' then
      begin
        CMYK.Black := PopDouble;
        CMYK.Yellow := PopDouble;
        CMYK.Magenta := PopDouble;
        CMYK.Cyan := PopDouble;
        RGB := FColorManager.CMYK2RGB(CMYK);
        GS.FillColor := FColorManager.RGB2Color(RGB);
        GS.FillColorEPS := F(CMYK.Cyan) + F(CMYK.Magenta) + F(CMYK.Yellow) +
          F(CMYK.Black) + 'setcmykcolor';
        GS.FillColorCMYK := CMYK;
      end else
      if GS.FillColorSpace = 'DeviceGray' then
      begin
        K := PopDouble;
        GS.FillColor := Round(K * 255) shl 16 +
          Round(K * 255) shl 8 + Round(K * 255);
        GS.FillColorEPS := F(K) + 'setgray';
      end else
      if QPLStartsWith(GS.FillColorSpace, 'Separation') then
      begin
        Sep := TPDFSeparationColorSpace(IntUncast(QPLStrToIntDef(QPLCopy(GS.FillColorSpace, 11, MaxInt), 0)));
        if Assigned(Sep) then
        begin
          K := PopDouble;
          Sep.GetColor(K);
          GS.FillColor := Sep.ResultColor;
          GS.FillColorEPS := Sep.ResultName;
          GS.AlternateFillCS := Sep.Alternate;

          if (Sep.Alternate = 'DeviceCMYK') then
          begin
            GS.FillColorCMYK := Sep.CMYKColor;
          end;
        end;
      end else
      if QPLStartsWith(GS.FillColorSpace, 'DeviceN') then
      begin
        DeviceNCS := TPDFDeviceNColorSpace(IntUncast(QPLStrToIntDef(QPLCopy(GS.FillColorSpace, 8, MaxInt), 0)));
        if Assigned(DeviceNCS) then
        begin
          SetLength(DeviceNInput, DeviceNCS.ComponentCount);
          for DeviceNIndex := DeviceNCS.ComponentCount - 1 downto 0 do
          begin
            DeviceNInput[DeviceNIndex] := PopDouble;
          end;
          DeviceNCS.GetColor(DeviceNInput);
          GS.FillColor := DeviceNCS.ResultColor;
          GS.FillColorEPS := DeviceNCS.ResultName;
        end;
      end else
      if QPLStartsWith(GS.FillColorSpace, 'Indexed') then
      begin
        IndexedCS := TPDFIndexedColorSpace(IntUncast(QPLStrToIntDef(QPLCopy(GS.FillColorSpace, 8, MaxInt), 0)));
        if Assigned(IndexedCS) then
        begin
          GS.FillColor := IndexedCS.GetColor(Trunc(PopDouble), FColorManager);
        end;
      end else
      if QPLStartsWith(GS.FillColorSpace, 'Lab') then
      begin
        LabColor := TPDFLabColorSpace(IntUncast(QPLStrToIntDef(QPLCopy(GS.FillColorSpace, 4, MaxInt), 0)));
        if Assigned(LabColor) then
        begin
          Lab.b := PopDouble;
          Lab.a := PopDouble;
          Lab.L := PopDouble;
          GS.FillColor := LabColor.GetColor(Lab, FColorManager);
        end;
      end else
      if QPLStartsWith(GS.FillColorSpace, 'Pattern') then
      begin
        if (QPLPos(':', GS.FillColorSpace) > 0) then
        begin
          GS.FillPattern := GetPattern(QPLCopy(GS.FillColorSpace, QPLPos(':', GS.FillColorSpace) + 1, MaxInt));
        end else
        begin
          GS.FillPattern := nil;
        end;
        if (not Assigned(GS.FillPattern)) then
        begin
          GS.FillColor := clWhite;
        end else
        begin
          if ((QPLPos('[', GS.FillColorSpace) > 0) and (QPLPos(']', GS.FillColorSpace) > 0)) then
          begin
            PatternAltCS := QPLCopy(GS.FillColorSpace, QPLPos('[', GS.FillColorSpace) + 1, MaxInt);
            Delete(PatternAltCS, QPLPos(']', PatternAltCS), MaxInt);
          end;
          if (GS.FillPattern.PDFPatternType = ptTiling) then
          begin
{$IFDEF QPL_DPLR}
            if (GS.FillPattern.GetPaintType = 2) and ((FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory)) then
            begin
              if (PatternAltCS = 'DeviceCMYK') then
              begin
                SetLength(PatternColors, 4);
                PatternColors[3] := PopDouble;
                PatternColors[2] := PopDouble;
                PatternColors[1] := PopDouble;
                PatternColors[0] := PopDouble;
              end else
              if (PatternAltCS = 'DeviceRGB') then
              begin
                SetLength(PatternColors, 3);
                PatternColors[2] := PopDouble;
                PatternColors[1] := PopDouble;
                PatternColors[0] := PopDouble;
              end else
              if (PatternAltCS = 'DeviceGray') then
              begin
                SetLength(PatternColors, 1);
                PatternColors[0] := PopDouble;
              end;
              GS.FillPattern.SetColorComponents(PatternAltCS, PatternColors);
              if Assigned(FUTFPattern) then
                FUTFPattern.Free;
              FUTFPattern := GS.FillPattern;
            end;
            RenderPatternTileDPLR(GS.FillPattern, QPLCopy(GS.FillColorSpace, QPLPos(':', GS.FillColorSpace) + 1, MaxInt));
{$ENDIF}
          end;
        end;
      end;
    end;
  end;

  procedure SetStrokeColor;
  var
    K: Double;
    RGB: TPDFRGBColor;
    CMYK: TPDFCMYKColor;
    Sep: TPDFSeparationColorSpace;
    LabColor: TPDFLabColorSpace;
    Lab: TPDFLabColor;
    DeviceNCS: TPDFDeviceNColorSpace;
    DeviceNInput: TPDFDeviceNColor;
    DeviceNIndex: Integer;
    IndexedCS: TPDFIndexedColorSpace;
    PatternAltCS: AnsiString;
{$IFDEF QPL_DPLR}
    PatternColors: array of Double;
{$ENDIF}
  begin
    if not IgnoreColorCommands then
    begin
      GS.StrokePattern := nil;

      if GS.StrokeColorSpace = 'DeviceRGB' then
      begin
        RGB.Blue := PopDouble;
        RGB.Green := PopDouble;
        RGB.Red := PopDouble;
        GS.StrokeColor := FColorManager.RGB2Color(RGB);
        GS.StrokeColorEPS := F(RGB.Red) + F(RGB.Green) + F(RGB.Blue) + 'setrgbcolor';
      end else
      if GS.StrokeColorSpace = 'DeviceCMYK' then
      begin
        CMYK.Black := PopDouble;
        CMYK.Yellow := PopDouble;
        CMYK.Magenta := PopDouble;
        CMYK.Cyan := PopDouble;
        RGB := FColorManager.CMYK2RGB(CMYK);
        GS.StrokeColor := FColorManager.RGB2Color(RGB);
        GS.StrokeColorEPS := F(CMYK.Cyan) + F(CMYK.Magenta) + F(CMYK.Yellow) +
          F(CMYK.Black) + 'setcmykcolor';
      end else
      if GS.StrokeColorSpace = 'DeviceGray' then
      begin
        K := PopDouble;
        GS.StrokeColor := Round(K * 255) shl 16 +
          Round(K * 255) shl 8 + Round(K * 255);
        GS.StrokeColorEPS := F(K) + 'setgray';
      end else
      if QPLStartsWith(GS.StrokeColorSpace, 'Separation') then
      begin
        Sep := TPDFSeparationColorSpace(IntUncast(QPLStrToIntDef(QPLCopy(GS.StrokeColorSpace, 11, MaxInt), 0)));
        if Assigned(Sep) then
        begin
          K := PopDouble;
          Sep.GetColor(K);
          GS.StrokeColor := Sep.ResultColor;
          GS.StrokeColorEPS := Sep.ResultName;
          GS.AlternateFillCS := Sep.Alternate;
        end;
      end else
      if QPLStartsWith(GS.StrokeColorSpace, 'DeviceN') then
      begin
        DeviceNCS := TPDFDeviceNColorSpace(IntUncast(QPLStrToIntDef(QPLCopy(GS.StrokeColorSpace, 8, MaxInt), 0)));
        if Assigned(DeviceNCS) then
        begin
          SetLength(DeviceNInput, DeviceNCS.ComponentCount);
          for DeviceNIndex := DeviceNCS.ComponentCount - 1 downto 0 do
          begin
            DeviceNInput[DeviceNIndex] := PopDouble;
          end;
          DeviceNCS.GetColor(DeviceNInput);
          GS.StrokeColor := DeviceNCS.ResultColor;
          GS.StrokeColorEPS := DeviceNCS.ResultName;
        end;
      end else
      if QPLStartsWith(GS.StrokeColorSpace, 'Indexed') then
      begin
        IndexedCS := TPDFIndexedColorSpace(IntUncast(QPLStrToIntDef(QPLCopy(GS.StrokeColorSpace, 8, MaxInt), 0)));
        if Assigned(IndexedCS) then
        begin
          GS.StrokeColor := IndexedCS.GetColor(Trunc(PopDouble), FColorManager);
        end;
      end else
      if QPLStartsWith(GS.StrokeColorSpace, 'Lab') then
      begin
        LabColor := TPDFLabColorSpace(IntUncast(QPLStrToIntDef(QPLCopy(GS.StrokeColorSpace, 4, MaxInt), 0)));
        if Assigned(LabColor) then
        begin
          Lab.b := PopDouble;
          Lab.a := PopDouble;
          Lab.L := PopDouble;
          GS.StrokeColor := LabColor.GetColor(Lab, FColorManager);
        end;
      end else
      if QPLStartsWith(GS.StrokeColorSpace, 'Pattern') then
      begin
        if (QPLPos(':', GS.StrokeColorSpace) > 0) then
        begin
          GS.StrokePattern := GetPattern(QPLCopy(GS.StrokeColorSpace, QPLPos(':', GS.StrokeColorSpace) + 1, MaxInt));
        end else
        begin
          GS.StrokePattern := nil;
        end;
        if (not Assigned(GS.StrokePattern)) then
        begin
          GS.StrokeColor := clWhite;
        end else
        begin
          if ((QPLPos('[', GS.StrokeColorSpace) > 0) and (QPLPos(']', GS.StrokeColorSpace) > 0)) then
          begin
            PatternAltCS := QPLCopy(GS.StrokeColorSpace, QPLPos('[', GS.StrokeColorSpace) + 1, MaxInt);
            Delete(PatternAltCS, QPLPos(']', PatternAltCS), MaxInt);
          end;
{$IFDEF QPL_DPLR}
          if (GS.StrokePattern.PDFPatternType = ptTiling) and ((FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory)) then
          begin
            if (GS.StrokePattern.GetPaintType = 2) then
            begin
              if (PatternAltCS = 'DeviceCMYK') then
              begin
                SetLength(PatternColors, 4);
                PatternColors[3] := PopDouble;
                PatternColors[2] := PopDouble;
                PatternColors[1] := PopDouble;
                PatternColors[0] := PopDouble;
              end else
              if (PatternAltCS = 'DeviceRGB') then
              begin
                SetLength(PatternColors, 3);
                PatternColors[2] := PopDouble;
                PatternColors[1] := PopDouble;
                PatternColors[0] := PopDouble;
              end else
              if (PatternAltCS = 'DeviceGray') then
              begin
                SetLength(PatternColors, 1);
                PatternColors[0] := PopDouble;
              end;
              GS.StrokePattern.SetColorComponents(PatternAltCS, PatternColors);
              if Assigned(FUTSPattern) then
                FUTSPattern.Free;
              FUTSPattern := GS.StrokePattern;
            end;
            RenderPatternTileDPLR(GS.StrokePattern, QPLCopy(GS.StrokeColorSpace, QPLPos(':', GS.StrokeColorSpace) + 1, MaxInt));
          end;
{$ENDIF}
        end;
      end;
    end;
  end;

  function FindColorSpace(const CS: AnsiString): AnsiString;
  var
    O: TPDFObject;
    ColorSpace: TPDFArray;
    Family: AnsiString;
    SC: Integer;
    Sep: TPDFSeparationColorSpace;
    LabColorSpace: TPDFLabColorSpace;
    DeviceNColorSpace: TPDFDeviceNColorSpace;
    IndexedColorSpace: TPDFIndexedColorSpace;
    ICCStream: TPDFStream;
  begin
    Result := '';
    if QPLStartsWith(CS, '/') then
    begin
      if (CS = '/DeviceRGB') then Result := 'DeviceRGB';
      if (CS = '/DeviceGray') then Result := 'DeviceGray';
      if (CS = '/DeviceCMYK') then Result := 'DeviceCMYK';
      if (CS = '/Pattern') then Result := 'Pattern';
    end;
    if Result = '' then
    begin
      O := Resources.FindValueByKeyName('ColorSpace', False);
      if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
      if O is TPDFDictionary then
      begin
        O := TPDFDictionary(O).FindValueByKeyName(QPLCopy(CS, 2, MaxInt), False);
        if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
        if O is TPDFName then
        begin
          if TPDFName(O).Name = 'DeviceRGB' then Result := 'DeviceRGB';
          if TPDFName(O).Name = 'DeviceGray' then Result := 'DeviceGray';
          if TPDFName(O).Name = 'DeviceCMYK' then Result := 'DeviceCMYK';
        end else
        if O is TPDFArray then
        begin
          ColorSpace := TPDFArray(O);
          if ColorSpace.Count >= 1 then
          begin
            O := ColorSpace.Item[0];
            if O is TPDFName then
            begin
              Family := TPDFName(O).Name;
              if Family = 'ICCBased' then
              begin
                if ColorSpace.Count >= 2 then
                begin
                  O := ColorSpace.Item[1];
                  if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
                  if O is TPDFStream then
                  begin
                    ICCStream := TPDFStream(O);
                    O := ICCStream.Dictionary.FindValueByKeyName('Alternate', False);
                    if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
                    if O is TPDFName then
                    begin
                      Result := TPDFName(O).Name;
                    end else
                    begin
                      O := ICCStream.Dictionary.FindValueByKeyName('N', False);
                      if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
                      if O is TPDFNumeric then
                      begin
                        case TPDFNumeric(O).AsInteger of
                          1: Result := 'DeviceGray';
                          3: Result := 'DeviceRGB';
                          4: Result := 'DeviceCMYK';
                        end;
                      end;
                    end;
                  end;
                end;
              end else
              if Family = 'Separation' then
              begin
                SetLength(FSeparationColors, Length(FSeparationColors) + 1);
                Sep := TPDFSeparationColorSpace.Create(FColorManager);
                Sep.OnFindObject := FOnFindObject;
                Sep.LoadFromArray(ColorSpace, CS);
                FSeparationColors[Length(FSeparationColors) - 1] := Sep;
                Result := 'Separation' + QPLIntToStr(IntCast(FSeparationColors[Length(FSeparationColors) - 1]));
              end else
              if Family = 'Lab' then
              begin
                SetLength(FLabColors, Length(FLabColors) + 1);
                LabColorSpace := TPDFLabColorSpace.Create;
                FLabColors[Length(FLabColors) - 1] := LabColorSpace;
                LabColorSpace.OnFindObject := FOnFindObject;
                LabColorSpace.LoadFromArray(ColorSpace);
                Result := 'Lab' + QPLIntToStr(IntCast(FLabColors[Length(FLabColors) - 1]));
              end else
              if Family = 'DeviceN' then
              begin
                SetLength(FDeviceNColors, Length(FDeviceNColors) + 1);
                DeviceNColorSpace := TPDFDeviceNColorSpace.Create(FColorManager);
                FDeviceNColors[Length(FDeviceNColors) - 1] := DeviceNColorSpace;
                DeviceNColorSpace.OnFindObject := FOnFindObject;
                DeviceNColorSpace.LoadFromArray(ColorSpace, CS);
                Result := 'DeviceN' + QPLIntToStr(IntCast(FDeviceNColors[Length(FDeviceNColors) - 1]));
              end else
              if Family = 'CalGray' then
              begin
                Result := 'DeviceGray';
              end else
              if (Family = 'Pattern') then
              begin
                Result := 'Pattern';
                if ColorSpace.Count >= 2 then
                begin
                  O := ColorSpace.Item[1];
                  if O is TPDFName then
                  begin
                    Result := Result + '[' + TPDFName(O).Name + ']';
                  end;
                end;
              end else
              if (Family = 'Indexed') then
              begin
                SetLength(FIndexedColors, Length(FIndexedColors) + 1);
                IndexedColorSpace := TPDFIndexedColorSpace.Create;
                FIndexedColors[Length(FIndexedColors) - 1] := IndexedColorSpace;
                IndexedColorSpace.OnFindObject := FOnFindObject;
                IndexedColorSpace.LoadFromArray(ColorSpace);
                Result := 'Indexed' + QPLIntToStr(IntCast(FIndexedColors[Length(FIndexedColors) - 1]));
              end;
            end;
          end;
        end;
      end;
    end;
    if Result = '' then Result := 'DeviceRGB';
  end;

  procedure SetPen;
  var
    D: TPDFDashArray;
    DX: Integer;
    TestP1: TPDFDoublePoint;
    TestP2: TPDFDoublePoint;
  begin
    Picasso.SetStrokeAlpha(GS.StrokeAlpha);

    if (Assigned(GS.StrokePattern)) then
    begin
      // Pass in the current transformation matrix for Cairo/DPLR
      Picasso.SetCurrentXForm(CanvasMat);
      Picasso.SetStrokePattern(GS.StrokePattern);
    end else
    begin
      Picasso.SetStrokeColor(GS.StrokeColor);
    end;

{$IFDEF QPL_DPLR}
    if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
    begin
      Picasso.SetBlendMode(GS.BlendMode); // Stroke path blend mode
      Picasso.SetLineWidth(GS.LineWidth);
      Picasso.SetLineDashDouble(GS.DashArray, GS.DashPhase);
    end else
    begin
{$ENDIF}

    // DPL-459
    // use original line width
    Picasso.SetLineWidth(GS.LineWidth);

    // Doesn't work for vertical lines (e.g. barcodes), when the matrix has different scales x and y
    // TestP1.X := 0;
    // TestP1.Y := 0;
    // TestP2.X := 0;
    // TestP2.Y := GS.LineWidth;
    // TestP1 := DoPDFXForm(CanvasMat, TestP1);
    // TestP2 := DoPDFXForm(CanvasMat, TestP2);
    // Picasso.SetLineWidth(Sqrt(Sqr(TestP2.X - TestP1.X) + Sqr(TestP2.Y - TestP1.Y)));
    // end DPL-459

    if Length(GS.DashArray) > 0 then
    begin
      SetLength(D, Length(GS.DashArray));
      for DX := 0 to Length(D) - 1 do
        D[DX] := GS.DashArray[DX];
      Picasso.SetLineDash(D, GS.DashPhase);
    end else
    begin
      SetLength(D, 0);
      Picasso.SetLineDash(D, 0);
    end;
{$IFDEF QPL_DPLR}
    end;
{$ENDIF}

    Picasso.SetLineJoinStyle(GS.LineJoin);
    Picasso.SetLineCapStyle(GS.LineCap);
    Picasso.SetMiterLimit(GS.MiterLimit);
  end;

  procedure SetFill(FillMode: TPDFFillMode);
  begin
    Picasso.SetFillAlpha(GS.FillAlpha);
{$IFDEF QPL_DPLR}
    if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
    begin
      Picasso.SetBlendMode(GS.BlendMode); // Fill path blend mode
    end;
{$ENDIF}
    Picasso.SetFillMode(FillMode);
    if (Assigned(GS.FillPattern)) then
    begin
      // Pass in the current transformation matrix for Cairo/DPLR
      Picasso.SetCurrentXForm(CanvasMat);
      Picasso.SetFillPattern(GS.FillPattern);
    end else
    begin
      Picasso.SetFillColor(GS.FillColor);
    end;
  end;

  function GetContents: AnsiString;
  var
    OO: TPDFObject;
    X: Integer;
    CA: TPDFArray;
    IR: TPDFIndRef;
  begin
    IR := nil;
    Result := '';
    if Source is TPDFDictionary then
    begin
      if Type3CharProc <> '' then
      begin
        // Source is a Type3 font dictionary
        Result := Type3CharProc;
      end else
      begin
        // Source is a page object dictionary
        OO := TPDFDictionary(Source).FindValueByKeyName('Contents', False);
        if OO is TPDFIndRef then
        begin
          IR := TPDFIndRef(OO);
          OO := FindObject(TPDFIndRef(OO));
        end;

        if OO is TPDFStream then
        begin
          if Assigned(FOnDecrypt) and Assigned(IR) then
            FOnDecrypt(TPDFStream(OO), IR);
          Result := TPDFStream(OO).GetDecodedStream;
          if Assigned(FOnEncrypt) and Assigned(IR) then
            FOnEncrypt(TPDFStream(OO), IR);
        end else
        if OO is TPDFArray then
        begin
          CA := TPDFArray(OO);
          for X := 0 to CA.Count - 1 do
          begin
            OO := CA.Item[X];
            if OO is TPDFIndRef then
            begin
              IR := TPDFIndRef(OO);
              OO := FindObject(TPDFIndRef(OO));
            end else
              IR := nil;
            if OO is TPDFStream then
            begin
              if Assigned(FOnDecrypt) and Assigned(IR) then
                FOnDecrypt(TPDFStream(OO), IR);
              Result := Result + TPDFStream(OO).GetDecodedStream + ' ';
              if Assigned(FOnEncrypt) and Assigned(IR) then
                FOnEncrypt(TPDFStream(OO), IR);
            end;
          end;
        end;
      end;
    end else
    if (Source is TPDFStream) and Assigned(ContainerIR) then
    begin
        if Assigned(FOnDecrypt) and Assigned(ContainerIR) then
          FOnDecrypt(TPDFStream(Source), ContainerIR);
        Result := TPDFStream(Source).GetDecodedStream;
        if Assigned(FOnEncrypt) and Assigned(ContainerIR) then
          FOnEncrypt(TPDFStream(Source), ContainerIR);
    end else
    if (Source is TPDFString) then
    begin
      Result := TPDFString(Source).AsString;
    end;
  end;

  procedure SelectFont;
  var
    F: TPDFDictionary;
    O: TPDFObject;
  begin
    if QPLEndsWith(GS.TextFont, ' R') then
    begin
      O := FStructure.Decode(GS.TextFont);
      if O is TPDFIndRef then
        FFontCol.GetFontData(TPDFIndRef(O));
    end;
    if (Assigned(Resources) and QPLStartsWith(GS.TextFont, '/')) then
    begin
      O := Resources.FindValueByKeyName('Font', False);
      if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
      if O is TPDFDictionary then
      begin
        F := TPDFDictionary(O);
        O := F.FindValueByKeyName(QPLCopy(GS.TextFont, 2, MaxInt));
        if O is TPDFIndRef then
        begin
          FFontCol.OnDecrypt := FOnDecrypt;
          FFontCol.OnEncrypt := FOnEncrypt;
          FFontCol.GetFontData(TPDFIndRef(O));
        end else
        if O is TPDFDictionary then
        begin
          FFontCol.OnDecrypt := FOnDecrypt;
          FFontCol.OnEncrypt := FOnEncrypt;
          FFontCol.GetFontDataFromDict(TPDFDictionary(O));
        end;
      end;
    end;
  end;

  procedure SaveState;
  begin
    Inc(StackSize);
    if StackSize >= Length(Stack) then
    begin
      SetLength(Stack, Length(Stack) + 100);
    end;
{$IFDEF QPL_CAIRO}
    if ((FDestination = rdCairo) or (FDestination = rdCairoBitmap)) then
    begin
      Picasso.SaveState;
    end else
{$ENDIF}
{$IFDEF QPL_DPLR}
    if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
    begin
      Picasso.SaveState;
    end else
{$ENDIF}
    if (FDestination <> rdEPS) then
    begin
      GS.ClipRegion := Picasso.GetCurrentClipRegion;
    end else
    begin
      FEPS.PSSaveGraphicsState;
    end;
    Stack[StackSize - 1] := GS;
  end;

  procedure RestoreState(CallSelectFont: Boolean = True);
  begin
    if StackSize > 0 then
    begin
      Dec(StackSize);
      GS := Stack[StackSize];
    end;
{$IFDEF QPL_CAIRO}
    if ((FDestination = rdCairo) or (FDestination = rdCairoBitmap)) then
    begin
      Picasso.RestoreState;
      CanvasMat := GS.CTM;
    end else
{$ENDIF}
{$IFDEF QPL_DPLR}
    if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
    begin
      Picasso.RestoreState;
      CanvasMat := GS.CTM;
      Picasso.SetCurrentXForm(CanvasMat);
    end else
{$ENDIF}
    if (FDestination <> rdEPS) then
    begin
      Picasso.SetClippingRegion(GS.ClipRegion);
      CanvasMat := GS.CTM;
    end else
    begin
      FEPS.PSRestoreGraphicsState;
    end;

    if CallSelectFont then
    begin
      SelectFont;
    end;
  end;

  function OldGetHexColor: AnsiString;
  var
    C: TColor;
    Processed: Boolean;
  begin
    Processed := False;
    if (FDestination = rdTextFunnel) then
    begin
      if ((FFunnel.OutputCMYK) and ((GS.FillColorSpace = 'DeviceCMYK') or (GS.AlternateFillCS = 'DeviceCMYK'))) then
      begin
        Processed := True;
        Result := QPLIntToHex(Round(GS.FillColorCMYK.Cyan * 255), 2) +
          QPLIntToHex(Round(GS.FillColorCMYK.Magenta * 255), 2) +
          QPLIntToHex(Round(GS.FillColorCMYK.Yellow * 255), 2) +
          QPLIntToHex(Round(GS.FillColorCMYK.Black * 255), 2);
      end;
    end;
    if (not Processed) then
    begin
      C := GS.FillColor;
      Result := '#' + QPLIntToHex(C and $FF, 2);
      Result := Result + QPLIntToHex(C and $FF00 shr 8, 2);
      Result := Result + QPLIntToHex(C and $FF0000 shr 16, 2);
    end;
  end;

  function GetHexColor: TPDFTextColor;
  var
    C: TColor;
    Processed: Boolean;
  begin
    Processed := False;
    if (FDestination = rdTextFunnel) then
    begin
      if ((FFunnel.OutputCMYK) and ((GS.FillColorSpace = 'DeviceCMYK') or (GS.AlternateFillCS = 'DeviceCMYK'))) then
      begin
        Processed := True;
        Result.HexColor := QPLIntToHex(Round(GS.FillColorCMYK.Cyan * 255), 2) +
          QPLIntToHex(Round(GS.FillColorCMYK.Magenta * 255), 2) +
          QPLIntToHex(Round(GS.FillColorCMYK.Yellow * 255), 2) +
          QPLIntToHex(Round(GS.FillColorCMYK.Black * 255), 2);
        SetLength(Result.Color, 4);
        Result.Color[0] := GS.FillColorCMYK.Cyan;
        Result.Color[1] := GS.FillColorCMYK.Magenta;
        Result.Color[2] := GS.FillColorCMYK.Yellow;
        Result.Color[3] := GS.FillColorCMYK.Black;
      end;
    end;
    if (not Processed) then
    begin
      C := GS.FillColor;
      Result.HexColor := '#' + QPLIntToHex(C and $FF, 2);
      Result.HexColor := Result.HexColor + QPLIntToHex(C and $FF00 shr 8, 2);
      Result.HexColor := Result.HexColor + QPLIntToHex(C and $FF0000 shr 16, 2);
      SetLength(Result.Color, 3);
      Result.Color[0] := (C and $FF) / 255;
      Result.Color[1] := ((C and $FF00) shr 8) / 255;
      Result.Color[2] := ((C and $FF0000) shr 16) / 255;
    end;
  end;

  procedure ShowText;
  var
    X: Integer;
    C: AnsiChar;
    M: TPDFXForm;
    OldM: TPDFXForm;
    DX, DY: Double;
    RenderToCanvasDY: Double;
    OI: Integer;
    Text: AnsiString;
    W, ExtraW: Double;
    CW: Word;
    WI: Integer;
    GC: TPDFGenericCanvas;
    CN: AnsiString;
    CodeList: TQuickPDFCodeList;
    Type3Mat1: TPDFXForm;
    Type3Mat2: TPDFXForm;
    Type3ObjNum: Integer;
    I : Integer;
    Z: Double;
    XPos, YPos: Double;
    IdentityV: Boolean;
    MatrixScale: Double;
    FontMatrixScaling: Double;
    DW2_v, DW2_w1: Double;
    Codes: array[0..3] of Word;
    Type3Font: Boolean;
    HideGlyph: Boolean;
{$IFDEF QPL_DPLR}
    OldLW: Double;
    TestP1: TPDFDoublePoint;
    TestP2: TPDFDoublePoint;
{$ENDIF}
  begin
    Type3Font := (Assigned(FFontCol.FoundFontData.Rasterizer) and
                 (FFontCol.FoundFontData.Rasterizer is TPDFType3Rasterizer));

    if Assigned(FFontCol.FoundFontData) and (GS.TextSize <> 0) then
    begin
      MatrixScale := 1000;
      IdentityV := QPLEndsWith(FFontCol.FoundFontData.CIDEncoding, '-V');

      if FDestination = rdEPS then
      begin
        GC := FEPS
      end else
        GC := Picasso;
      GC.BeginPath;
      if GS.TextSize <> 0 then
      begin
        if Assigned(FFontCol.FoundFontData.Rasterizer) then
        begin
          FFontCol.FoundFontData.Rasterizer.RenderingMode := GS.TextRenderingMode;

          if (FGDIPlusSettings.DirectFonts and (Picasso.Model = pmGDIPlus)) then
          begin
            FFontCol.FoundFontData.Rasterizer.SetupDirectFont(GC);
          end;

          FontMatrixScaling := FFontCol.FoundFontData.Rasterizer.FontMatrixScaling;
          //if FFontCol.FoundFontData.Rasterizer is TPDFType3Rasterizer then
          //  FontMatrixScaling := TPDFType3Rasterizer(FFontCol.FoundFontData.Rasterizer).FontMatrix.eM11;
        end else
        begin
          FontMatrixScaling := 1;
        end;

        SetFill(pfUnknown);
        SetPen;
        OI := OperandCount - ArrayCount;
        OldM := CanvasMat;
        try
          CombinePDFXForm(CanvasMat, GS.TM, CanvasMat);
          if Type3Font then
          begin
            MatrixScale := 1;
            CombinePDFXForm(CanvasMat, TPDFType3Rasterizer(
              FFontCol.FoundFontData.Rasterizer).FontMatrix, CanvasMat);
            TPDFType3Rasterizer(FFontCol.FoundFontData.Rasterizer).FillColor :=
              GS.FillColor;
          end;
          if (MatrixScale <> 0) then
          begin
            Mat(M, GS.TextSize / MatrixScale * GS.TextScaling / 100, 0, 0, GS.TextSize / MatrixScale, 0, 0);
            CombinePDFXForm(CanvasMat, M, CanvasMat);
          end;

          DX := 0;
          DY := 0;

          repeat
            Text := OperandList[OI];

            if (Text[1] <> '(') and (Text[1] <> '<') then
            begin
              if (FontMatrixScaling <> 0) then
              begin
                TazzToFloatVar(Text, Z);
                if Type3Font then
                begin
                  if (not IdentityV) then
                    DX := DX - Z * MatrixScale / 1000 /
                      FontMatrixScaling * GS.TextScaling / 100 / TPDFType3Rasterizer(FFontCol.FoundFontData.Rasterizer).FontMatrix.eM11
                  else
                    DY := DY - Z * MatrixScale / 1000 /
                      FontMatrixScaling * GS.TextScaling / 100 / TPDFType3Rasterizer(FFontCol.FoundFontData.Rasterizer).FontMatrix.eM11;
                end else
                begin
                  if (not IdentityV) then
                    DX := DX - Z * MatrixScale / 1000 / FontMatrixScaling * Abs(GS.TextScaling) / 100
                  else
                    DY := DY - Z * MatrixScale / 1000 / FontMatrixScaling * Abs(GS.TextScaling) / 100;
                end;
              end;
            end else
            begin
              if (Text[1] = '(') then
              begin
                Text := FStructure.DecodeString(Text);
              end else
              if (Text[1] = '<') then
              begin
                Text := FStructure.DecodeHex(Text);
                if (Length(Text) > 2) and (Text[1] = #$FE) and (Text[2] = #$FF)  then
                  Text := AnsiString(QPLDecodeTextString(Text));
              end;

              if (FFontCol.FoundFontData.IsComposite) then
              begin
                FFontCol.GetCodeList(Text, CodeList);

                for X := 0 to Length(CodeList) - 1 do
                begin
                  CW := CodeList[X];
                  I := -1;

                  DW2_v := FFontCol.FoundFontData.DW2_v;
                  DW2_w1 := FFontCol.FoundFontData.DW2_w1;

                  if (FFontCol.FoundFontData.ToUnicodeMap <> nil) and (not FFontCol.FoundFontData.Embedded) then
                  begin
                    I := FFontCol.FoundFontData.ToUnicodeMap.GetValue(CW, Codes);
                    if (I <> -1) then
                      CW := Codes[0];  // No need to process ligatures.
                  end;

                  if (I = -1) and (FFontCol.FoundFontData.HasOwnCIDToGIDMap) and (FFontCol.FoundFontData.EncodingBuiltIn) then
                    begin
                      I := FFontCol.FoundFontData.CIDToGIDMap.GetValue(CW);
                      CN := 'GID:' + QPLIntToStr(I)
                    end
                  else
                  if (CodeList[X] = 32) and (FFontCol.FoundFontData.SingleByteCMap) then
                  begin
                    // Don't convert
                  end
                  else
                  if (I = -1) and (FFontCol.FoundFontData.GIDToCIDMap <> -1) then
                  //if (FFontCol.FoundFontData.GIDToCIDMap <> -1) then  // ADC
                  begin
                    I := FFontCol.ResourceCMapGetValue(FFontCol.FoundFontData.GIDToCIDMap, CW);
                    if (I <> -1) then
                      CW := I;
                  end;

                  if (FFontCol.FoundFontData.ToUnicodeMap <> nil) and (not FFontCol.FoundFontData.Embedded) then
                    CN := 'GID:' + QPLIntToStr(CW)
                  else
                  begin
                    if (I = -1) and (CodeList[X] = 32) and (FFontCol.FoundFontData.SingleByteCMap) then
                      CN := 'GID:32'
                    else if Assigned(FFontCol.FoundFontData.CIDToGIDMap) then
                    begin
                      I := FFontCol.FoundFontData.CIDToGIDMap.GetValue(CW);
                      if (I <> 0) then
                        CN := 'GID:' + QPLIntToStr(I)
                      else
                      begin
                          CN := 'GID:' + QPLIntToStr(CW);
                      end;
                    end
                    else if (FFontCol.FoundFontData.AdobeGIDType0) and (not FFontCol.FoundFontData.Embedded) then
                    begin

                      if (AdobeGIDToUnicode[CW] <> -1) then
                      begin
                        if (FFontCol.FoundFontData.SubType = 'CIDFontType0') then
                          CN := 'GID:' + QPLIntToStr(AdobeGIDToUnicode[CW])
                        else
                          CN := 'GID:' + QPLIntToStr(AdobeGIDToUnicode[CW]-2);
                      end
                      else
                        CN := 'GID:' + QPLIntToStr(CW);
                    end
                    else
                    begin
                      CN := 'GID:' + QPLIntToStr(CW);
                    end;
                  end;

                  ExtraW := 0.0;
                  if Assigned(FFontCol.FoundFontData.CIDWidths) then
                  begin

                    if (FFontCol.FoundFontData.ToUnicodeMap <> nil) and (not FFontCol.FoundFontData.Embedded) then
                      WI := FFontCol.FoundFontData.CIDWidths.IndexOf('CID:' + QPLIntToStr(CodeList[X]))
                    else
                      WI := FFontCol.FoundFontData.CIDWidths.IndexOf('CID:' + QPLIntToStr(CW));

                    if (WI < 0) and ((FFontCol.FoundFontData.SubType = 'CIDFontType2') or
                                     (FFontCol.FoundFontData.SubType = 'CIDFontType0')) then
                    begin
                      if FFontCol.FoundFontData.GIDToCIDMap <> -1 then
                      begin
                        if (FFontCol.FoundFontData.ToUnicodeMap <> nil) then
                          I := FFontCol.ResourceCMapGetValue(FFontCol.FoundFontData.GIDToCIDMap, CodeList[X])
                        else
                          I := FFontCol.ResourceCMapGetValue(FFontCol.FoundFontData.GIDToCIDMap, CW);

                        if (I <> -1) then
                        begin
                          WI := Integer(FFontCol.FoundFontData.CIDWidths.IndexOf('CID:' + QPLIntToStr(I)));
                        end;
                      end;
                    end;

                    if WI < 0 then
                      WI := FFontCol.FoundFontData.CIDWidths.IndexOf('Default');
                    if WI >= 0 then
                    begin
                      W := Integer(FFontCol.FoundFontData.CIDWidths.Objects[WI]);
                      ExtraW := GS.CharSpacing * MatrixScale / GS.TextSize;

                      if (CodeList[X] = 32) and FFontCol.FoundFontData.SingleByteCMap then
                        ExtraW := ExtraW + GS.WordSpacing * MatrixScale / GS.TextSize;

                      W := W + ExtraW;
                    end else
                      W := MatrixScale;
                  end else
                    W := MatrixScale;

                  if MCVisible then
                  begin
                    if Assigned(FFontCol.FoundFontData.Rasterizer) then
                    begin
                      if (not IdentityV) then
                      begin
                        XPos := DX;
                        YPos := GS.TextRise * MatrixScale / GS.TextSize;
                      end
                      else
                      begin
                        XPos := DX - W/2;
                        YPos := DY - DW2_v;
                      end;

                      if Type3Font then
                      begin
                        // Type3 fonts can contain any PDF drawing commands, so
                        // re-call the renderer on the CharString
                        with TPDFType3Rasterizer(FFontCol.FoundFontData.Rasterizer) do
                        begin
                          SaveState;
                          ParentResources := Resources;
                          Type3Mat1 := CanvasMat;
                          Type3Mat2.eM11 := 1;
                          Type3Mat2.eM12 := 0;
                          Type3Mat2.eM21 := 0;
                          Type3Mat2.eM22 := 1;
                          Type3Mat2.eDx := XPos;
                          Type3Mat2.eDy := YPos;
                          CombinePDFXForm(CanvasMat, Type3Mat2, CanvasMat);
                          Type3ObjNum := FFontCol.FoundFontData.ObjNum;
                          FUseInitialState := True;
                          FInitialState := GS;

                          SubRender(Picasso, Type3FontDict, nil, GetCharProc(CN));
                          RestoreState(False);
                          CanvasMat := Type3Mat1;
                          FFontCol.FastGetFontData(Type3ObjNum);
                        end;
                      end else
                      begin
                        with FFontCol.FoundFontData do
                          Rasterizer.RenderToCanvas(XPos, YPos, GC, CanvasMat, CN, FFontCol.FoundFontData.Enc);
                      end;
                    end;
                  end;

                  if (IdentityV) then
                    DY := DY + DW2_w1 + ExtraW
                  else
                    DX := DX + W;

                end;
              end else
              begin

                // Font is a simple font, not composite

                for X := 1 to Length(Text) do
                begin
                  C := Text[X];
                  W := (FFontCol.FoundFontData.Widths[Ord(C)] * GS.TextSize / GS.TextSize);

                  if Assigned(FFontCol.FoundFontData.Rasterizer) then
                    if (FontMatrixScaling <> 0) and (FontMatrixScaling <> 1) then
                        W := W / FontMatrixScaling * GS.TextScaling / 100;

                  if (FontMatrixScaling <> 0) then
                  begin
                    if (not Type3Font) then
                    begin
                      W := W + GS.CharSpacing * MatrixScale / GS.TextSize / FontMatrixScaling;
                      if C = #32 then
                        W := W + GS.WordSpacing * MatrixScale / GS.TextSize / FontMatrixScaling;
                    end
                    else
                    begin
                      W := W + GS.CharSpacing * MatrixScale / GS.TextSize / FontMatrixScaling / TPDFType3Rasterizer(FFontCol.FoundFontData.Rasterizer).FontMatrix.eM11;
                      if C = #32 then
                        W := W + GS.WordSpacing * MatrixScale / GS.TextSize / FontMatrixScaling;
                      //Type 3 fonts need to multiply Charspacing / Wordspacing instead of adding to the current with.
                      //This fix doesn't work for document from DPL-459
                      //W := (W - 2) * GS.CharSpacing * MatrixScale / GS.TextSize / FontMatrixScaling;  // -2 seems to match Acrobat
                      //if C = #32 then
                      //  W := (W - 2) * GS.WordSpacing * MatrixScale / GS.TextSize / FontMatrixScaling;
                    end
                  end else
                  begin
                    W := W + GS.CharSpacing * MatrixScale / GS.TextSize;
                    if C = #32 then
                      W := W + GS.WordSpacing * MatrixScale / GS.TextSize;
                  end;

                  if MCVisible then
                  begin
                    if Assigned(FFontCol.FoundFontData.Rasterizer) then
                    begin
                      if Type3Font then
                      begin
                        // Type3 fonts can contain any PDF drawing commands, so
                        // re-call the renderer on the CharString
                        with TPDFType3Rasterizer(FFontCol.FoundFontData.Rasterizer) do
                        begin
                          SaveState;
                          ParentResources := Resources;
                          Type3Mat1 := CanvasMat;
                          Type3Mat2.eM11 := 1;
                          Type3Mat2.eM12 := 0;
                          Type3Mat2.eM21 := 0;
                          Type3Mat2.eM22 := 1;
                          Type3Mat2.eDx := DX;
                          Type3Mat2.eDy := GS.TextRise * MatrixScale / GS.TextSize;
                          CombinePDFXForm(CanvasMat, Type3Mat2, CanvasMat);
                          Type3ObjNum := FFontCol.FoundFontData.ObjNum;
                          FUseInitialState := True;
                          FInitialState := GS;
{$IFDEF QPL_DPLR}
                          Type3Font := true;
{$ENDIF}
                          SubRender(Picasso, Type3FontDict, nil, GetCharProc(FFontCol.FoundFontData.Encoding[Ord(C)]));
                          RestoreState(False);
                          CanvasMat := Type3Mat1;
                          FFontCol.FastGetFontData(Type3ObjNum);
                        end;
                      end else
                      begin
                        with FFontCol.FoundFontData do
                        begin
                          RenderToCanvasDY := GS.TextRise * MatrixScale / GS.TextSize;

                          // Acrobat does not show the .notdef character for
                          // non-embedded TrueType or Type1 fonts
                          HideGlyph := False;
                          if ((SubType = 'Type1') or (SubType = 'TrueType')) and
                            (not Embedded) and (Rasterizer is TPDFTrueTypeRasterizer2) then
                          begin
                            if (Encoding[Ord(C)] = '.notdef') then
                            begin
                              HideGlyph := True;
                            end;
                          end;

                          if (not HideGlyph) then
                          begin
                            Rasterizer.RenderToCanvas(DX, RenderToCanvasDY, GC,
                              CanvasMat, Encoding[Ord(C)], FFontCol.FoundFontData.Enc);
                          end;
                        end;
                      end;
                    end;
                  end;
                  DX := DX + W;
                end;
              end;
            end;
            Inc(OI);
          until OI = OperandCount;

          if (FontMatrixScaling <> 0) then
          begin
            Mat(M, 1, 0, 0, 1, DX * GS.TextSize * FontMatrixScaling / MatrixScale * GS.TextScaling / 100,
                               DY * GS.TextSize * FontMatrixScaling / MatrixScale * GS.TextScaling / 100);
          end else
          begin
            Mat(M, 1, 0, 0, 1, DX * GS.TextSize / MatrixScale * GS.TextScaling / 100,
                               DY * GS.TextSize / MatrixScale * GS.TextScaling / 100);
          end;

          CombinePDFXForm(GS.TM, M, GS.TM);
        finally
          CanvasMat := OldM;
        end;
      end;

      ArrayCount := 0;

{$IFDEF QPL_DPLR}
      // different paths coordinates in GDI and DPLR
      if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
      begin
        OldM := CanvasMat;
        OldLW := GS.LineWidth;

        CanvasMat := TPDFXFormIdentity;
        Picasso.SetCurrentXForm(TPDFXFormIdentity);

        if (GS.TextRenderingMode >= 4) then
        begin
          Picasso.RendererDLL.DPLR_add_to_text_clip(Picasso.RendererHandle);
        end;

        // TODO - DPLR_fill_path methods was called 2 times -
        // in SubRender method for Type3 font
        // and also in here - with the same path
        if (not Type3Font) then
        begin
          if (GS.TextRenderingMode = 1) or (GS.TextRenderingMode = 2) or
            (GS.TextRenderingMode = 5) or (GS.TextRenderingMode = 6) then
          begin
            SetPen;
            TestP1.X := 0;
            TestP1.Y := 0;
            TestP2.X := 0;
            TestP2.Y := OldLW;
            TestP1 := DoPDFXForm(OldM, TestP1);
            TestP2 := DoPDFXForm(OldM, TestP2);
            Picasso.SetLineWidth(Sqrt(Sqr(TestP2.X - TestP1.X) + Sqr(TestP2.Y - TestP1.Y)));
          end;
          if (GS.TextRenderingMode = 0) or (GS.TextRenderingMode = 2) or
            (GS.TextRenderingMode = 4) or (GS.TextRenderingMode = 6) then
            SetFill(pfWinding);

          case GS.TextRenderingMode of
            0: Picasso.FillPath;
            1: Picasso.StrokePath;
            2: Picasso.StrokeAndFillPath;
            4: Picasso.FillPath;
            5: Picasso.StrokePath;
            6: Picasso.StrokeAndFillPath;
          end;
        end;

        CanvasMat := OldM;
        Picasso.SetCurrentXForm(OldM);
        Picasso.SetLineWidth(OldLW);
      end else
{$ENDIF}
      if FDestination = rdEPS then
      begin
        if (GS.TextRenderingMode = 0) or (GS.TextRenderingMode = 2) or
          (GS.TextRenderingMode = 4) or (GS.TextRenderingMode = 6) then
        begin
          FEPS.PSSetColor(GS.FillColorEPS);
          FEPS.PSFill(epsFillModeNonZeroWinding);
        end;
        if (GS.TextRenderingMode = 1) or (GS.TextRenderingMode = 2) or
          (GS.TextRenderingMode = 5) or (GS.TextRenderingMode = 6) then
        begin
          FEPS.PSSetColor(GS.StrokeColorEPS);
          FEPS.PSStroke;
        end;
      end else
{$IFDEF QPL_DPLR}
      if (FDestination = rdDPLRPrinter) then
      begin
        Picasso.GetPathBounds(@GDIPlusRect);
        if (IsBBoxInPrinterArray(GDIPlusRect.X, GDIPlusRect.Y,
            GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height) = False) then
        begin
          if ((GS.BlendMode <> bmNormal) or
            (GS.Softmask = True) or
            (((GS.TextRenderingMode = 0) or (GS.TextRenderingMode = 2) or
            (GS.TextRenderingMode = 4) or (GS.TextRenderingMode = 6)) and
            ((GS.FillAlpha < 1) or QPLStartsWith(GS.FillColorSpace, 'Pattern'))) or
            (((GS.TextRenderingMode = 1) or (GS.TextRenderingMode = 2) or
            (GS.TextRenderingMode = 5) or (GS.TextRenderingMode = 6)) and
            ((GS.StrokeAlpha < 1) or QPLStartsWith(GS.StrokeColorSpace, 'Pattern')))) then
          begin
            AddToPrinterBBoxArray(GDIPlusRect.X, GDIPlusRect.Y,
              GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height);
            if GS.TextRenderingMode >= 4 then
              Picasso.SetClippingPath(pfWinding);
            case GS.TextRenderingMode of
              3: Picasso.NullPath;
              7: Picasso.NullPath;
            end;
            Picasso.Path := 0;
          end else
          begin
            // use GDI+
            if (GS.TextRenderingMode = 1) or (GS.TextRenderingMode = 2) or
              (GS.TextRenderingMode = 5) or (GS.TextRenderingMode = 6) then
                SetPen;
            if (GS.TextRenderingMode = 0) or (GS.TextRenderingMode = 2) or
              (GS.TextRenderingMode = 4) or (GS.TextRenderingMode = 6) then
                SetFill(pfWinding);
            if GS.TextRenderingMode >= 4 then
              Picasso.SetClippingPath(pfWinding);
            case GS.TextRenderingMode of
              0: Picasso.FillPath;
              1: Picasso.StrokePath;
              2: Picasso.StrokeAndFillPath;
              3: Picasso.NullPath;
              4: Picasso.FillPath;
              5: Picasso.StrokePath;
              6: Picasso.StrokeAndFillPath;
              7: Picasso.NullPath;
            end;
          end;
        end;
      end else
{$ENDIF}
      begin
        if (GS.TextRenderingMode = 1) or (GS.TextRenderingMode = 2) or
          (GS.TextRenderingMode = 5) or (GS.TextRenderingMode = 6) then
            SetPen;
        if (GS.TextRenderingMode = 0) or (GS.TextRenderingMode = 2) or
          (GS.TextRenderingMode = 4) or (GS.TextRenderingMode = 6) then
            SetFill(pfWinding);
        if GS.TextRenderingMode >= 4 then
          Picasso.SetClippingPath(pfWinding);
        case GS.TextRenderingMode of
          0: Picasso.FillPath;
          1: Picasso.StrokePath;
          2: Picasso.StrokeAndFillPath;
          3: Picasso.NullPath;
          4: Picasso.FillPath;
          5: Picasso.StrokePath;
          6: Picasso.StrokeAndFillPath;
          7: Picasso.NullPath;
        end;
      end;
    end;
  end;

  procedure ExtractText;
  var
    X, I: Integer;
    M: TPDFXForm;
    OldM: TPDFXForm;
    DX, DY: Double;
    OI: Integer;
    Text: AnsiString;
    W, ExtraW: Double;
    CW: Word;
    WI: Integer;
    DXS: Double;
    TestP1: TPDFDoublePoint;
    TestP2: TPDFDoublePoint;
    RealTextSize: Double;
    GC: TPDFGenericCanvas;
    CodeList: TQuickPDFCodeList;

    Z: Double;
    MappedText: WideString;
    ThisMappedText: WideString;

    IdentityV: Boolean;
    MatrixScale: Double;
    FoundFontDescent: Double;
    FoundFontAscent: Double;
    DXoffsets: array of Double;
    Codes: array[0..3] of Word;
    { DW2_v,} DW2_w1: Double;
    Type3Font: Boolean;

  begin
    Type3Font := (Assigned(FFontCol.FoundFontData.Rasterizer) and
                 (FFontCol.FoundFontData.Rasterizer is TPDFType3Rasterizer));

    if Assigned(FFontCol.FoundFontData) and (GS.TextSize <> 0) then
    begin
      MatrixScale := 1000;
      IdentityV := QPLEndsWith(FFontCol.FoundFontData.CIDEncoding, '-V');
      MappedText := '';

      GC := Picasso;
      GC.BeginPath;
      if GS.TextSize <> 0 then
      begin
        if Assigned(FFontCol.FoundFontData.Rasterizer) then
          FFontCol.FoundFontData.Rasterizer.RenderingMode := GS.TextRenderingMode;

        SetFill(pfUnknown);
        SetPen;
        OI := OperandCount - ArrayCount;
        OldM := CanvasMat;
        try
          CombinePDFXForm(CanvasMat, GS.TM, CanvasMat);
          if Type3Font then
          begin
            MatrixScale := 1;
            CombinePDFXForm(CanvasMat, TPDFType3Rasterizer(
              FFontCol.FoundFontData.Rasterizer).FontMatrix, CanvasMat);
            TPDFType3Rasterizer(FFontCol.FoundFontData.Rasterizer).FillColor :=
              GS.FillColor;
          end;
          if (MatrixScale <> 0) then
          begin
            Mat(M, GS.TextSize / MatrixScale * GS.TextScaling / 100, 0, 0, GS.TextSize / MatrixScale, 0, 0);
            CombinePDFXForm(CanvasMat, M, CanvasMat);
          end;

          FoundFontAscent := FFontCol.FoundFontData.Ascent;
          FoundFontDescent := -Abs(FFontCol.FoundFontData.Descent);

          // Workarounds for fonts that are not correctly defined.
          if (FoundFontAscent = 0) and (FoundFontDescent = 0) then
          begin
            FoundFontAscent :=       FFontCol.FoundFontData.Bound.Top    * GS.TextSize * CanvasMat.eM11 / 1.5;
            FoundFontDescent := -Abs(FFontCol.FoundFontData.Bound.Bottom * GS.TextSize * CanvasMat.eM11) / 2;

            if Type3Font then
            begin
              FoundFontAscent := FoundFontAscent *  TPDFType3Rasterizer(FFontCol.FoundFontData.Rasterizer).FontMatrix.eM11;
              FoundFontDescent := FoundFontDescent * TPDFType3Rasterizer(FFontCol.FoundFontData.Rasterizer).FontMatrix.eM11;
            end;

            // Take a conservative best guess based on TextSize.
            if (FoundFontAscent = 0) and (FoundFontDescent = 0) then
            begin
              FoundFontAscent :=  GS.TextSize * 2.5;
              FoundFontDescent := -Abs(GS.TextSize / 2);
            end
          end;

          if (FoundFontAscent - FoundFontDescent > 1500) then
          begin
            FoundFontAscent := FoundFontAscent * 1000 / (FoundFontAscent - FoundFontDescent);
            FoundFontDescent := FoundFontDescent * 1000 / (FoundFontAscent - FoundFontDescent);
          end;

          if (FoundFontAscent <= 20) then
          begin
            FoundFontAscent :=       FFontCol.FoundFontData.Bound.Top    * GS.TextSize * CanvasMat.eM11 / 1.5;
            FoundFontDescent := -Abs(FFontCol.FoundFontData.Bound.Bottom * GS.TextSize * CanvasMat.eM11) / 2;
          end;

          if (FFunnel.IgnoreDescenders) then
            FoundFontDescent := 0.0;

          TestP1.X := 0;
          TestP1.Y := 0;
          TestP2.X := 0;
          if Type3Font then
          begin
            TestP2.Y := FoundFontAscent - FoundFontDescent;
          end else
          begin
            TestP2.Y := MatrixScale;
          end;
          TestP1 := DoPDFXForm(CanvasMat, TestP1);
          TestP2 := DoPDFXForm(CanvasMat, TestP2);
          RealTextSize := Sqrt(Sqr(TestP2.X - TestP1.X) + Sqr(TestP2.Y - TestP1.Y));

          DX := 0;
          DY := 0;
          DXS := 0;
          ExtraW := 0;

          repeat
            Text := OperandList[OI];
            if (Text[1] <> '(') and (Text[1] <> '<') then
            begin
              if (MappedText <> '') then
              begin
                FFunnel.AddText(CanvasMat, MappedText, GetHexColor,
                  FFontCol.FoundFontData.FontName, RealTextSize, DXS,
                  GS.TextRise * MatrixScale / Abs(GS.TextSize) + FoundFontDescent,
                  (DX - DXS - ExtraW),
                  (FoundFontAscent - FoundFontDescent),
                  DXoffsets);

                MappedText := '';
                FFunnel.SetNextMatch(True);
              end;

              TazzToFloatVar(Text, Z);
              if Type3Font then
              begin
                if (not IdentityV) then
                  DX := DX - Z * MatrixScale / 1000 *
                    GS.TextScaling / 100 / TPDFType3Rasterizer(FFontCol.FoundFontData.Rasterizer).FontMatrix.eM11
                else
                  DY := DY - Z * MatrixScale / 1000 *
                    GS.TextScaling / 100 / TPDFType3Rasterizer(FFontCol.FoundFontData.Rasterizer).FontMatrix.eM11;
              end else
              begin
                if (not IdentityV) then
                  DX := DX - Z * MatrixScale / 1000 * Abs(GS.TextScaling) / 100
                else
                  DY := DY - Z * MatrixScale / 1000 * Abs(GS.TextScaling) / 100;
              end;

              //DXS := DX - ExtraW;
              DXS := DX;

            end else
            begin
              if (Text[1] = '(') then
              begin
                Text := FStructure.DecodeString(Text);
              end else
              if (Text[1] = '<') then
              begin
                Text := FStructure.DecodeHex(Text);
                if (Length(Text) > 2) and (Text[1] = #$FE) and (Text[2] = #$FF)  then
                  Text := AnsiString(QPLDecodeTextString(Text));
              end;

              if (FFontCol.FoundFontData.IsComposite) then
              begin
                FFontCol.GetCodeList(Text, CodeList);

                for X := 0 to Length(CodeList) - 1 do
                begin
                  CW := CodeList[X];
                  ThisMappedText := '';

                  //DW2_v := FFontCol.FoundFontData.DW2_v;
                  DW2_w1 := FFontCol.FoundFontData.DW2_w1;

                  if (FFontCol.FoundFontData.ToUnicodeMap <> nil) then // and (not FFontCol.FoundFontData.Embedded) then
                  begin
                    I := FFontCol.FoundFontData.ToUnicodeMap.GetValue(CW, Codes);

                    if (I <> -1) then
                    begin
                      for WI := 1 to I do
                        ThisMappedText := ThisMappedText + WideChar(Codes[WI-1]);
                    end;
                  end
                  else
                  begin
                    if (FFontCol.FoundFontData.GIDToCIDMap <> -1) then
                    begin
                      I := FFontCol.ResourceCMapGetValue(FFontCol.FoundFontData.GIDToCIDMap, CW);
                      if (I <> -1) then
                        CW := I;
                    end
                    else
                    if Assigned(FFontCol.FoundFontData.CIDToGIDMap) then
                    begin
                      I := FFontCol.FoundFontData.CIDToGIDMap.GetValue(CW);
                      if (I <> 0) and (ThisMappedText = '') then
                        ThisMappedText := FFontCol.GetWideMap(Ord(I));
                    end;
                  end;

                  if (FFontCol.FoundFontData.AdobeGIDType0) and (ThisMappedText = '') then
                  begin
                    if (FFontCol.FoundFontData.SubType = 'CIDFontType0') then
                      ThisMappedText := WideChar(AdobeGIDToUnicode[CW])
                    else
                      ThisMappedText := WideChar(AdobeGIDToUnicode[CW]-2);
                  end;

                  if ThisMappedText = '' then
                    ThisMappedText := FFontCol.GetWideMap(Ord(CW));

                  ExtraW := 0.0;    // Added
                  if Assigned(FFontCol.FoundFontData.CIDWidths) then
                  begin

                    if (FFontCol.FoundFontData.ToUnicodeMap <> nil) and (not FFontCol.FoundFontData.Embedded) then
                      WI := FFontCol.FoundFontData.CIDWidths.IndexOf('CID:' + QPLIntToStr(CodeList[X]))
                    else
                      WI := FFontCol.FoundFontData.CIDWidths.IndexOf('CID:' + QPLIntToStr(CW));

                    if (WI < 0) and ((FFontCol.FoundFontData.SubType = 'CIDFontType2') or
                                     (FFontCol.FoundFontData.SubType = 'CIDFontType0')) then
                    begin
                      if FFontCol.FoundFontData.GIDToCIDMap <> -1 then
                      begin
                        if (FFontCol.FoundFontData.ToUnicodeMap <> nil) then
                          I := FFontCol.ResourceCMapGetValue(FFontCol.FoundFontData.GIDToCIDMap, CodeList[X])
                        else
                          I := FFontCol.ResourceCMapGetValue(FFontCol.FoundFontData.GIDToCIDMap, CW);

                        if (I <> -1) then
                        begin
                          WI := Integer(FFontCol.FoundFontData.CIDWidths.IndexOf('CID:' + QPLIntToStr(I)));
                        end;
                      end;
                    end;

                    if WI < 0 then
                      WI := FFontCol.FoundFontData.CIDWidths.IndexOf('Default');
                    if WI >= 0 then
                    begin
                      W := Integer(FFontCol.FoundFontData.CIDWidths.Objects[WI]);

                      if Not Type3Font then
                      begin
                        ExtraW := GS.CharSpacing * MatrixScale / GS.TextSize;
                        if (CodeList[X] = 32) and FFontCol.FoundFontData.SingleByteCMap then
                          ExtraW := ExtraW + GS.WordSpacing * MatrixScale / GS.TextSize;
                      end
                      else
                      begin
                        ExtraW := W * GS.CharSpacing * MatrixScale / GS.TextSize;
                        if (CodeList[X] = 32) and FFontCol.FoundFontData.SingleByteCMap then
                          ExtraW := ExtraW + W * GS.WordSpacing * MatrixScale / GS.TextSize;
                      end;

                      W := W + ExtraW;
                    end else
                      W := MatrixScale;
                  end else
                    W := MatrixScale;

                  if (ThisMappedText = #$00A0) or  // &nbsp Char(160)
                     (ThisMappedText = #$1680) or
                     ((ThisMappedText >= #$2000) and (ThisMappedText <= #$200A)) or
                     (ThisMappedText = #$202F) or
                     (ThisMappedText = #$205F) or
                     (ThisMappedText = #$3000) then
                    ThisMappedText := ' ';

                  if ((ThisMappedText = '')) or ((ThisMappedText < ' ') and not FFunnel.OutputNonAscii) then
                  begin
                    ThisMappedText := ' ';
                  end;

                  if (FFunnel.SplitOnDoubleSpace) and (ThisMappedText = ' ') and (MappedText <> '') and (MappedText[Length(MappedText)] = ' ') then
                  begin
                    if (MappedText <> ' ') then
                      FFunnel.AddText(CanvasMat, MappedText, GetHexColor,
                        FFontCol.FoundFontData.FontName, RealTextSize,
                          DXS,
                          GS.TextRise * MatrixScale / Abs(GS.TextSize) + FoundFontDescent,
                          DX - DXS,
                          (FoundFontAscent - FoundFontDescent),
                          DXoffsets);

                    MappedText := '';
                    FFunnel.SetNextMatch(false);
                    DXS := DX + W;
                  end else
                  if ((ThisMappedText = ' ') and (MappedText <> '') and FFunnel.SplitWords) then
                  begin
                    FFunnel.AddText(CanvasMat, MappedText, GetHexColor,
                      FFontCol.FoundFontData.FontName, RealTextSize,
                        DXS,
                        GS.TextRise * MatrixScale / Abs(GS.TextSize) + FoundFontDescent,
                        (DX - DXS),  // Was - ExtraW
                        (FoundFontAscent - FoundFontDescent),
                        DXoffsets);
                    MappedText := '';
                    FFunnel.SetNextMatch(not FFunnel.SplitWords);
                    DXS := DX + W;
                  end else
                  if ((ThisMappedText = ' ') and (MappedText = '') and FFunnel.SplitWords) then
                  begin
                    FFunnel.SetNextMatch(not FFunnel.SplitWords);
                    DXS := DX + W;
                  end else
                  if (Abs(GS.CharSpacing) > 1) or ((GS.WordSpacing > 1) and (ThisMappedText = ' ')) then
                  begin
                    if ThisMappedText = ' ' then
                      FFunnel.SetNextMatch(not FFunnel.SplitWords)
                    else
                      FFunnel.SetNextMatch(True);

                    SetLength(DXoffsets, Length(ThisMappedText));
                    if (Length(ThisMappedText) > 0) then
                      DXoffsets[Length(ThisMappedText) - 1] := DX;

                    FFunnel.AddText(CanvasMat, ThisMappedText, GetHexColor,
                      FFontCol.FoundFontData.FontName, RealTextSize,
                        DXS,
                        Abs(GS.TextRise) * MatrixScale / Abs(GS.TextSize) + FoundFontDescent,
                        (DX - DXS - ExtraW),
                        (FoundFontAscent - FoundFontDescent),
                        DXoffsets);

                    MappedText := '';
                    FFunnel.SetNextMatch(not FFunnel.SplitWords);
                    DXS := DX + W;

                  end else
                  begin
                    MappedText := MappedText + ThisMappedText;

                    SetLength(DXoffsets, Length(MappedText));
                    if (Length(MappedText) > 0 ) then   // This code supports ligatures.
                      for I := 0 to Length(ThisMappedText) - 1 do
                        DXoffsets[Length(MappedText) - Length(ThisMappedText) + I] := DX + I * (W / Length(ThisMappedText));

                  end;
                  if (IdentityV) then
                    DY := DY + DW2_w1 + ExtraW
                  else
                    DX := DX + W;
                end;
              end else
              begin

                // Font is a simple font, not composite

                for X := 1 to Length(Text) do
                begin
                  ThisMappedText := '';
                  CW := Word(Text[X]);

                  W := FFontCol.FoundFontData.Widths[Ord(CW)];

                  if not Type3Font then
                  begin
                    ExtraW := GS.CharSpacing * MatrixScale / GS.TextSize; // ?? DPL-313 -  * GS.TextScaling / 100;
                    if CW = 32 then
                      ExtraW := ExtraW + GS.WordSpacing * MatrixScale / GS.TextSize;
                  end
                  else
                  begin
                    ExtraW := W * (GS.CharSpacing - 1) * MatrixScale / GS.TextSize;
                    if CW = 32 then
                      ExtraW := ExtraW * GS.WordSpacing * MatrixScale / GS.TextSize;
                  end;

                  if (FFontCol.FoundFontData.ToUnicodeMap <> nil) then
                  begin
                    I := FFontCol.FoundFontData.ToUnicodeMap.GetValue(Ord(CW), Codes);
                    if (I <> -1) then
                    begin
                      for WI := 1 to I do
                        ThisMappedText := ThisMappedText + WideChar(Codes[WI-1]);
                    end;
                  end;

                  if ThisMappedText = '' then
                    ThisMappedText := FFontCol.GetWideMap(Ord(CW));

                  if (ThisMappedText = ' ') and (CW <> 32) then
                    ExtraW := ExtraW + GS.WordSpacing * MatrixScale / Abs(GS.TextSize);

                  if (FFunnel.SplitOnDoubleSpace) and (ThisMappedText = ' ') and (MappedText <> '') and (MappedText[Length(MappedText)] = ' ') then
                  begin
                    if (MappedText <> ' ') then
                      FFunnel.AddText(CanvasMat, MappedText, GetHexColor,
                        FFontCol.FoundFontData.FontName, RealTextSize,
                          DXS,
                          GS.TextRise * MatrixScale / Abs(GS.TextSize) + FoundFontDescent,
                          DX - DXS,
                          (FoundFontAscent - FoundFontDescent),
                          DXoffsets);

                    MappedText := '';
                    FFunnel.SetNextMatch(false);
                    DXS := DX + W + ExtraW;
                  end else
                  //if ((GS.WordSpacing > 1) or (GS.CharSpacing > 1)) and (MappedText <> '') and (ThisMappedText = ' ') then
                  if ((GS.WordSpacing > 1) or (GS.CharSpacing > 1)) and (ThisMappedText = ' ') then
                  begin
                    if (MappedText <> '') then
                    begin
                      FFunnel.AddText(CanvasMat, MappedText, GetHexColor,
                        FFontCol.FoundFontData.FontName, RealTextSize,
                          DXS,
                          GS.TextRise * MatrixScale / Abs(GS.TextSize) + FoundFontDescent,
                          DX - DXS,
                          (FoundFontAscent - FoundFontDescent),
                          DXoffsets);

                      MappedText := '';
                      FFunnel.SetNextMatch(true);
                      DXS := DX + W + ExtraW;
                    end
                    else
                    begin
                      FFunnel.SetNextMatch(false);
                      DXS := DX + W + ExtraW;
                    end;

                  end else
                  if (ThisMappedText = ' ') and (MappedText <> '') and (FFunnel.SplitWords) then
                  begin
                    FFunnel.AddText(CanvasMat, MappedText, GetHexColor,
                      FFontCol.FoundFontData.FontName, RealTextSize,
                        DXS,
                        GS.TextRise * MatrixScale / Abs(GS.TextSize) + FoundFontDescent,
                        (DX - DXS),   // Was ExtraW
                        (FoundFontAscent - FoundFontDescent),
                        DXoffsets);
                    MappedText := '';
                    FFunnel.SetNextMatch(not FFunnel.SplitWords);
                    DXS := DX + W + ExtraW;
                  end else
                  if ((ThisMappedText = ' ') and (MappedText = '') and FFunnel.SplitWords) then
                  begin
                    FFunnel.SetNextMatch(not FFunnel.SplitWords);
                    DXS := DX + W + ExtraW;
                  end else
                  if (Abs(GS.CharSpacing) > 1) then
                  begin
                    SetLength(DXoffsets, Length(ThisMappedText));
                    if (Length(ThisMappedText) > 0) then
                      DXoffsets[Length(ThisMappedText) - 1] := 0;  // Will only ever be 1 character

                    FFunnel.AddText(CanvasMat, ThisMappedText, GetHexColor,
                      FFontCol.FoundFontData.FontName, RealTextSize,
                        DX, // DX, // DXS,
                        GS.TextRise * MatrixScale / Abs(GS.TextSize) + FoundFontDescent,
                        W, // (DX - DXS + W),
                        (FoundFontAscent - FoundFontDescent),
                        DXoffsets);
                    MappedText := '';
                    ThisMappedText := '';
                    DXS := DX + W + ExtraW;
                    FFunnel.SetNextMatch(true);
                  end else
                  if (GS.WordSpacing > 1) and (ThisMappedText = ' ') then
                  begin
                    DXS := DX + W + ExtraW;
                  end else
                  begin
                    MappedText := MappedText + ThisMappedText;

                    SetLength(DXoffsets, Length(MappedText));
                    if (Length(MappedText) > 0 ) then   // This code supports ligatures.
                      for I := 0 to Length(ThisMappedText) - 1 do
                        DXoffsets[Length(MappedText) - Length(ThisMappedText) + I] := DX + I * (W / Length(ThisMappedText));
                  end;

                  DX := DX + W + ExtraW;

                end;
              end;
            end;
            Inc(OI);
          until OI = OperandCount;

          // Output remaining segments here
          if ((MappedText <> '') and
            ((MappedText <> ' ') or (not FFunnel.SplitWords))) then
          begin
            FFunnel.AddText(CanvasMat, MappedText, GetHexColor,
              FFontCol.FoundFontData.FontName, RealTextSize,
              DXS,
              GS.TextRise * MatrixScale / Abs(GS.TextSize) + FoundFontDescent,
              (DX - DXS - ExtraW),
              (FoundFontAscent - FoundFontDescent),
              DXoffsets);
          end;
          MappedText := '';

          Mat(M, 1, 0, 0, 1, DX * GS.TextSize / MatrixScale * GS.TextScaling / 100,
                             DY * GS.TextSize / MatrixScale * GS.TextScaling / 100);

          CombinePDFXForm(GS.TM, M, GS.TM);
        finally
          CanvasMat := OldM;
        end;
      end;
      ArrayCount := 0;
    end;
  end;

  procedure DrawShading(const ResourceName: AnsiString);
  var
    O: TPDFObject;
    ShadingDict: TPDFDictionary;
    ShadingResources: TPDFDictionary;
    ShadingType: Integer;
    ColorSpace: AnsiString;
  begin
    if (Assigned(Resources) and QPLStartsWith(ResourceName, '/')) then
    begin
      O := Resources.FindValueByKeyName('Shading', False);
      if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
      if O is TPDFDictionary then
      begin
        ShadingResources := TPDFDictionary(O);
        O := ShadingResources.FindValueByKeyName(QPLCopy(ResourceName, 2, MaxInt), False);
        if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
        if O is TPDFDictionary then
        begin
          ShadingDict := TPDFDictionary(O);
          O := ShadingDict.FindValueByKeyName('ShadingType', False);
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          if O is TPDFNumeric then ShadingType := TPDFNumeric(O).AsInteger
            else ShadingType := 0;
          O := ShadingDict.FindValueByKeyName('ColorSpace', False);
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          if O is TPDFName then ColorSpace := TPDFName(O).Name;
          if (ShadingType = 2) and (ColorSpace = '/DeviceRGB') then
          begin

          end;
        end;
      end;
    end;
  end;

  procedure DrawAnnot(Annot: TPDFDictionary);
  var
    O: TPDFObject;
    R: TPDFArray;
    B: TPDFArray;
    C: TPDFArray;
    DA: TPDFArray;
    Border: TPDFArray;
    BSDict: TPDFDictionary;
    W: Double;
    CMYK: TPDFCMYKColor;
    RGB: TPDFRGBColor;
    Dash: TPDFDashArray;
    I: Integer;
    AP: TPDFDictionary;
    RectL: Double;
    RectB: Double;
    RectR: Double;
    RectT: Double;
    N: TPDFStream;
    OldM: TPDFXForm;
    NDict: TPDFDictionary;
    IR: TPDFIndRef;
    StreamIR: TPDFIndRef;
    ClipPoint: TPDFDoublePoint;
    Matrix: TPDFArray;
    MatrixXForm: TPDFXForm;
    BBoxLowerLeft: TPDFDoublePoint;
    BBoxUpperRight: TPDFDoublePoint;
    TransAppBoxLowerLeft: TPDFDoublePoint;
    TransAppBoxUpperRight: TPDFDoublePoint;
    AXForm: TPDFXForm;
    AHorzScale: Double;
    AVertScale: Double;
    AHorzOffset: Double;
    AVertOffset: Double;
    AAXForm: TPDFXForm;
    StampName: AnsiString;
{$IFDEF QPL_OS_WINDOWS}
    //SrcRect, DstRect: TRect;
{$ENDIF}
    {
    SrcRectWidth, SrcRectHeight: Integer;
    SaveBitmap: TBitmap;
    IsHighlight: Boolean;
    OldMode: Integer;
    BMP: HBitmap;
    CDC: HDC;
    }
  begin
    DA := nil;
    W := 1.0;
    Border := nil;
    BSDict := nil;
    {
    IsHighlight := False;
    SaveBitmap := nil;
    CDC := 0;
    BMP := 0;
    SrcRectHeight := 0;
    SrcRectWidth := 0;

    O := Annot.FindValueByKeyName('Subtype', False);
    if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
    if (O is TPDFName) then
      if TPDFName(O).Name = 'Highlight' then
        IsHighlight := True;
    }

    O := Annot.FindValueByKeyName('Rect', False);
    if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
    if O is TPDFArray then
    begin
      R := TPDFArray(O);
      if (R.Count = 4) then
      begin
        if (R.Item[0] is TPDFNumeric) and (R.Item[1] is TPDFNumeric) and
          (R.Item[2] is TPDFNumeric) and (R.Item[3] is TPDFNumeric) then
        begin
          O := Annot.FindValueByKeyName('AP', False);
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          if O is TPDFDictionary then
          begin
            AP := TPDFDictionary(O);
            O := AP.FindValueByKeyName('N', False);
            if O is TPDFIndRef then
              StreamIR := TPDFIndRef(O)
            else
              StreamIR := nil;
            if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
            IR := nil;
            if O is TPDFDictionary then
            begin
              NDict := TPDFDictionary(O);
              O := Annot.FindValueByKeyName('AS', False);
              if O is TPDFIndRef then
              begin
                IR := TPDFIndRef(O);
                O := FindObject(TPDFIndRef(O));
              end else
              if O is TPDFName then
              begin
                O := NDict.FindValueByKeyName(TPDFName(O).Name);
                if O is TPDFIndRef then
                begin
                  IR := TPDFIndRef(O);
                  O := FindObject(TPDFIndRef(O));
                end;
              end;
            end else
            if (O is TPDFStream) then
            begin
              IR := StreamIR;
            end;
            if Assigned(IR) and (O is TPDFStream) then
            begin
              N := TPDFStream(O);
              O := N.Dictionary.FindValueByKeyName('BBox', False);
              if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
              if (O is TPDFArray) and (TPDFArray(O).Count = 4) then
              begin
                B := TPDFArray(O);
                if (B.Item[0] is TPDFNumeric) and (B.Item[1] is TPDFNumeric) and
                  (B.Item[2] is TPDFNumeric) and (B.Item[3] is TPDFNumeric) then
                begin

                  if (TPDFNumeric(R.Item[0]).AsDouble < TPDFNumeric(R.Item[2]).AsDouble) then
                  begin
                    RectL := TPDFNumeric(R.Item[0]).AsDouble;
                    RectR := TPDFNumeric(R.Item[2]).AsDouble;
                  end else
                  begin
                    RectL := TPDFNumeric(R.Item[2]).AsDouble;
                    RectR := TPDFNumeric(R.Item[0]).AsDouble;
                  end;

                  if (TPDFNumeric(R.Item[1]).AsDouble < TPDFNumeric(R.Item[3]).AsDouble) then
                  begin
                    RectB := TPDFNumeric(R.Item[1]).AsDouble;
                    RectT := TPDFNumeric(R.Item[3]).AsDouble;
                  end else
                  begin
                    RectB := TPDFNumeric(R.Item[3]).AsDouble;
                    RectT := TPDFNumeric(R.Item[1]).AsDouble;
                  end;

                  // Default MatrixXForm to the identity matrix
                  Mat(MatrixXForm, 1, 0, 0, 1, 0, 0);

                  // If the XObject has a valid /Matrix entry, get the
                  // values and store them in MatrixXForm
                  O := N.Dictionary.FindValueByKeyName('Matrix', False);
                  if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
                  if O is TPDFArray then
                  begin
                    Matrix := TPDFArray(O);
                    if (Matrix.AllItemsNumeric) then
                    begin
                      Mat(MatrixXForm,
                        TPDFNumeric(Matrix.Item[0]).AsDouble,
                        TPDFNumeric(Matrix.Item[1]).AsDouble,
                        TPDFNumeric(Matrix.Item[2]).AsDouble,
                        TPDFNumeric(Matrix.Item[3]).AsDouble,
                        TPDFNumeric(Matrix.Item[4]).AsDouble,
                        TPDFNumeric(Matrix.Item[5]).AsDouble);
                    end;
                  end;

                  // Transform /BBox using /Matrix
                  BBoxLowerLeft.X := TPDFNumeric(B.Item[0]).AsDouble;
                  BBoxLowerLeft.Y := TPDFNumeric(B.Item[1]).AsDouble;
                  BBoxLowerLeft := TranslateUsing(BBoxLowerLeft, MatrixXForm);
                  BBoxUpperRight.X := TPDFNumeric(B.Item[2]).AsDouble;
                  BBoxUpperRight.Y := TPDFNumeric(B.Item[3]).AsDouble;
                  BBoxUpperRight := TranslateUsing(BBoxUpperRight, MatrixXForm);

                  // Calculate the transformed appearance box
                  if (BBoxLowerLeft.X < BBoxUpperRight.X) then
                  begin
                    TransAppBoxLowerLeft.X := BBoxLowerLeft.X;
                    TransAppBoxUpperRight.X := BBoxUpperRight.X;
                  end else
                  begin
                    TransAppBoxLowerLeft.X := BBoxUpperRight.X;
                    TransAppBoxUpperRight.X := BBoxLowerLeft.X;
                  end;
                  if (BBoxLowerLeft.Y < BBoxUpperRight.Y) then
                  begin
                    TransAppBoxLowerLeft.Y := BBoxLowerLeft.Y;
                    TransAppBoxUpperRight.Y := BBoxUpperRight.Y;
                  end else
                  begin
                    TransAppBoxLowerLeft.Y := BBoxUpperRight.Y;
                    TransAppBoxUpperRight.Y := BBoxLowerLeft.Y;
                  end;

                  if (((TransAppBoxUpperRight.X - TransAppBoxLowerLeft.X) > 0) and
                    ((TransAppBoxUpperRight.Y - TransAppBoxLowerLeft.Y) > 0)) then
                  begin
                    // Compute the A matrix
                    AHorzScale := (RectR - RectL) / (TransAppBoxUpperRight.X - TransAppBoxLowerLeft.X);
                    AVertScale := (RectT - RectB) / (TransAppBoxUpperRight.Y - TransAppBoxLowerLeft.Y);
                    AHorzOffset := RectL - TransAppBoxLowerLeft.X * AHorzScale;
                    AVertOffset := RectT - TransAppBoxUpperRight.Y * AVertScale;

                    Mat(AXForm, AHorzScale, 0, 0, AVertScale, AHorzOffset, AVertOffset);

                    // Concatenate Matrix with A to form matrix AA
                    CombinePDFXForm(AAXForm, MatrixXForm, AXForm);

                    SaveState;

                    // Set clipping path
                    if not InPath then
                    begin
                      InPath := True;
                      if FDestination <> rdEPS then
                      begin
                        Picasso.BeginPath;
                      end else
                        FEPS.PSNewPath;
                    end;
{$IFDEF QPL_DPLR}
                    if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
                    begin
                      Picasso.MoveTo(RectL, RectB);
                      Picasso.AddLineToPath(RectL, RectT);
                      Picasso.AddLineToPath(RectR, RectT);
                      Picasso.AddLineToPath(RectR, RectB);
                      Picasso.ClosePath;
                      Picasso.SetClippingPath(pfAlternate);
                      Picasso.NullPath;
                      InPath := False;
                    end else
{$ENDIF}
                    if FDestination <> rdEPS then
                    begin
                      ClipPoint := Translate(DoublePoint(RectL, RectB));
{$IFDEF QPL_OS_WINDOWS}
                      {
                      SrcRect.Left := Round(ClipPoint.X);
                      SrcRect.Bottom := Round(ClipPoint.Y);
                      }
                      Picasso.MoveTo(ClipPoint.X, ClipPoint.Y);

                      ClipPoint := Translate(DoublePoint(RectL, RectT));
                      Picasso.AddLineToPath(ClipPoint.X, ClipPoint.Y);
{$ENDIF}
                      ClipPoint := Translate(DoublePoint(RectR, RectT));

{$IFDEF QPL_OS_WINDOWS}
                      {
                      SrcRect.Right := Round(ClipPoint.X);
                      SrcRect.Top := Round(ClipPoint.Y);
                      SrcRectWidth := Abs(SrcRect.Right - SrcRect.Left);
                      SrcRectHeight := Abs(SrcRect.Top - SrcRect.Bottom);
                      }
{$ENDIF}
                      Picasso.AddLineToPath(ClipPoint.X, ClipPoint.Y);

{$IFDEF QPL_OS_WINDOWS}
                      {
                      if (IsHighlight) then
                      begin
                        if (FDestination = rdPrinter) then
                        begin
                          // Not possible with a printer DC.  Alternative is to draw Annots first.
                        end
                        else
                        if (FDestination = rdDeviceContext) then
                        begin
                          CDC := CreateCompatibleDC(FDeviceContextTarget);
                          BMP := CreateCompatibleBitmap(FDeviceContextTarget, SrcRectWidth, SrcRectHeight);
                          SelectObject(CDC, BMP);
                          BitBlt(CDC, 0, 0, SrcRectWidth, SrcRectHeight, FDeviceContextTarget, SrcRect.Left, SrcRect.Top, SRCCOPY);
                        end
                        else
                        begin
                          SaveBitmap := TBitmap.Create;
                          SaveBitmap.PixelFormat := FBitmap.PixelFormat;
                          SaveBitmap.Width := SrcRectWidth;
                          SaveBitmap.Height := SrcRectHeight;
                          SaveBitmap.Canvas.Lock;

                          DstRect.Left := 0;
                          DstRect.Top := 0;
                          DstRect.Right := SrcRectWidth;
                          DstRect.Bottom := SrcRectHeight;

                          SaveBitmap.Canvas.CopyRect(dstRect, FBitmap.Canvas, srcRect);
                          //SaveBitmap.SaveToFile('out.bmp');
                        end;
                      end;
                      }
{$ENDIF}

                      ClipPoint := Translate(DoublePoint(RectR, RectB));
                      Picasso.AddLineToPath(ClipPoint.X, ClipPoint.Y);
                      Picasso.ClosePath;
                      Picasso.SetClippingPath(pfAlternate);
                      Picasso.NullPath;
                      InPath := False;
                    end
                    else
                    begin
                      FEPS.PSMoveTo(RectL, RectB);
                      FEPS.PSLineTo(RectL, RectT);
                      FEPS.PSLineTo(RectR, RectT);
                      FEPS.PSLineTo(RectR, RectB);
                      FEPS.PSClosePath;
                      FEPS.PSClip(epsFillModeNonZeroWinding);
                      InPath := False;
                    end;

                    OldM := CanvasMat;
                    try
                      CombinePDFXForm(CanvasMat, AAXForm, CanvasMat);

                      ParentResources := Resources;
                      FDrawingAnnot := True;
                      SubRender(Picasso, N, IR);
                      FDrawingAnnot := False;

{$IFDEF QPL_OS_WINDOWS}
                      {
                      if (IsHighlight) then
                      begin
                        if (FDestination = rdPrinter) then
                        begin
                          // Doesn't work with a printer DC.
                        end
                        else
                        if (FDestination = rdDeviceContext) then
                        begin
                          BitBlt(FDeviceContextTarget, SrcRect.Left, SrcRect.Top, SrcRectWidth, SrcRectHeight, CDC, 0, 0, SRCAND);
                          DeleteObject(BMP);
                          ReleaseDC(0, CDC);
                        end
                        else if Assigned(SaveBitmap) then
                        begin
                          OldMode := FBitmap.Canvas.CopyMode;
                          FBitmap.Canvas.CopyMode := cmSrcAnd;
                          FBitmap.Canvas.CopyRect(srcRect, SaveBitmap.Canvas, dstRect);
                          FBitmap.Canvas.CopyMode := OldMode;
                          SaveBitmap.Free;
                        end;
                      end;
                      }
{$ENDIF}

                    finally
                      CanvasMat := OldM;
                    end;

                    RestoreState;

                  end;
                end;
              end;
            end;
          end else
          begin
            // No appearance stream, simulate for known annotation types

            RectL := TPDFNumeric(R.Item[0]).AsDouble;
            RectR := TPDFNumeric(R.Item[2]).AsDouble;
            RectB := TPDFNumeric(R.Item[1]).AsDouble;
            RectT := TPDFNumeric(R.Item[3]).AsDouble;

            C := nil;

            O := Annot.FindValueByKeyName('C', False);
            if (O is TPDFIndRef) then
            begin
              O := FindObject(TPDFIndRef(O));
            end;
            if (O is TPDFArray) then
            begin
              C := TPDFArray(O);
            end;

            O := Annot.FindValueByKeyName('Subtype', False);
            if (O is TPDFIndRef) then
            begin
              O := FindObject(TPDFIndRef(O));
            end;

            if (O is TPDFName) then
            begin
              if (TPDFName(O).Name = 'Link') then
              begin
                SaveState;

                if (not InPath) then
                begin
                  InPath := True;
                  if FDestination <> rdEPS then
                  begin
                    Picasso.BeginPath;
                  end else
                    FEPS.PSNewPath;
                end;

                if (not Assigned(C)) then
                begin
                  RGB.Red := 0;
                  RGB.Green := 0;
                  RGB.Blue := 0;
                  GS.StrokeColor := FColorManager.RGB2Color(RGB);
                  GS.StrokeColorEPS := F(RGB.Red) + F(RGB.Green) + F(RGB.Blue) +
                    'setrgbcolor';
                end else
                begin
                  case (C.Count) of
                    0: W := 0;
                    1:
                    begin
                      RGB.Red := TPDFNumeric(C.Item[0]).AsDouble;
                      RGB.Green := TPDFNumeric(C.Item[0]).AsDouble;
                      RGB.Blue := TPDFNumeric(C.Item[0]).AsDouble;
                      GS.StrokeColor := FColorManager.RGB2Color(RGB);
                      GS.StrokeColorEPS := F(RGB.Red) + F(RGB.Green) + F(RGB.Blue)
                        + 'setrgbcolor';
                    end;
                    3:
                    begin
                      RGB.Red := TPDFNumeric(C.Item[0]).AsDouble;
                      RGB.Green := TPDFNumeric(C.Item[1]).AsDouble;
                      RGB.Blue := TPDFNumeric(C.Item[2]).AsDouble;

                      GS.StrokeColor := FColorManager.RGB2Color(RGB);
                      GS.StrokeColorEPS := F(RGB.Red) + F(RGB.Green) + F(RGB.Blue)
                        + 'setrgbcolor';
                    end;
                    4:
                    begin
                      CMYK.Cyan := TPDFNumeric(C.Item[0]).AsDouble;
                      CMYK.Magenta := TPDFNumeric(C.Item[1]).AsDouble;
                      CMYK.Yellow := TPDFNumeric(C.Item[2]).AsDouble;
                      CMYK.Black := TPDFNumeric(C.Item[3]).AsDouble;
                      RGB := FColorManager.CMYK2RGB(CMYK);
                      GS.StrokeColor := FColorManager.RGB2Color(RGB);
                      GS.StrokeColorEPS := F(RGB.Red) + F(RGB.Green) + F(RGB.Blue)
                        + 'setrgbcolor';
                    end;
                  end;
                end;

                // Rounded corners not supported yet.

                // Search for the newer BS dictionary
                O := Annot.FindValueByKeyName('BS', False);
                if (O is TPDFIndRef) then
                begin
                  O := FindObject(TPDFIndRef(O));
                end;

                if (O is TPDFDictionary) then
                begin
                  BSDict := TPDFDictionary(O);
                end;

                if (Assigned(BSDict)) then
                begin
                  O := BSDict.FindValueByKeyName('D', False);
                  if (O is TPDFArray) then
                  begin
                    DA := TPDFArray(O);
                  end;

                  O := BSDict.FindValueByKeyName('W', False);
                  if (O is TPDFNumeric) then
                  begin
                    W := TPDFNumeric(O).AsDouble;
                  end;
                end else
                begin
                  // Locate the Border key and use it if no BS
                  O := Annot.FindValueByKeyName('Border', False);

                  if (O is TPDFIndRef) then
                  begin
                    O := FindObject(TPDFIndRef(O));
                  end;
                  if (O is TPDFArray) then
                  begin
                    Border := TPDFArray(O);
                  end;

                  if (Assigned(Border)) then
                  begin
                    if (Border.Count >= 3) then
                    begin
                      W := TPDFNumeric(Border.Item[2]).AsDouble;
                    end;

                    if (Border.Count >= 4) then // Dash pattern
                    begin
                      if (Border.Item[3] is TPDFArray) then
                      begin
                        DA := TPDFArray(Border.Item[3]);
                      end
                      else
                        W := 0;
                    end;
                  end;
                end;

                Picasso.SetLineWidth(W);

                // Set the Line dash if we have a DA array.
                if (Assigned(DA)) then
                begin
                  SetLength(Dash, DA.Count);
                  for I := 0 to DA.Count - 1 do
                  begin
                    Dash[I] := TPDFNumeric(DA.Item[I]).AsInteger;
                  end;
                  Picasso.SetLineDash(Dash, 0); // Phase = 0
                end;

{$IFDEF QPL_DPLR}
                if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
                begin
                  Picasso.SetStrokeColor(GS.StrokeColor);

                  Picasso.MoveTo(RectL, RectB);
                  Picasso.AddLineToPath(RectL, RectT);
                  Picasso.AddLineToPath(RectR, RectT);
                  Picasso.AddLineToPath(RectR, RectB);
                  Picasso.ClosePath;
                  Picasso.SetClippingPath(pfAlternate);
                  if (W = 0) then
                    Picasso.NullPath
                  else
                    Picasso.StrokePath;
                  InPath := False;
                end else
{$ENDIF}

                if (FDestination <> rdEPS) then
                begin
                  Picasso.SetStrokeColor(GS.StrokeColor);

                  ClipPoint := Translate(DoublePoint(RectL, RectB));
                  Picasso.MoveTo(ClipPoint.X, ClipPoint.Y);
                  ClipPoint := Translate(DoublePoint(RectL, RectT));
                  Picasso.AddLineToPath(ClipPoint.X, ClipPoint.Y);
                  ClipPoint := Translate(DoublePoint(RectR, RectT));
                  Picasso.AddLineToPath(ClipPoint.X, ClipPoint.Y);
                  ClipPoint := Translate(DoublePoint(RectR, RectB));
                  Picasso.AddLineToPath(ClipPoint.X, ClipPoint.Y);
                  Picasso.ClosePath;
                  Picasso.SetClippingPath(pfAlternate);
                  if (W = 0) then
                    Picasso.NullPath
                  else
                    Picasso.StrokePath;
                  InPath := False;
                end else
                begin
                  FEPS.PSSetColor(GS.StrokeColorEPS);

                  FEPS.PSMoveTo(RectL, RectB);
                  FEPS.PSLineTo(RectL, RectT);
                  FEPS.PSLineTo(RectR, RectT);
                  FEPS.PSLineTo(RectR, RectB);
                  FEPS.PSClosePath;
                  FEPS.PSClip(epsFillModeNonZeroWinding);
                  InPath := False;
                end;

                RestoreState;
              end else
              if (TPDFName(O).Name = 'Stamp') then
              begin
                O := Annot.FindValueByKeyName('Name', False);
                if (O is TPDFIndRef) then
                begin
                  O := FindObject(TPDFIndRef(O));
                end;
                if (O is TPDFName) then
                begin
                  StampName := TPDFName(O).Name;
                end else
                begin
                  StampName := 'Draft';
                end;

                AHorzScale := (RectR - RectL) / 1000 * 30;
                AVertScale := -(RectT - RectB) / 1000 * 30;
                AHorzOffset := RectL;
                AVertOffset := RectT;

                if (AHorzScale < AVertScale) then
                begin
                  AVertScale := AHorzScale;
                end else
                begin
                  AHorzScale := AVertScale;
                end;

                Mat(AXForm, AHorzScale, 0, 0, AVertScale, AHorzOffset, AVertOffset);

                SaveState;
                Mat(MatrixXForm, 1, 0, 0, 1, 0, 0);
                CombinePDFXForm(AAXForm, MatrixXForm, AXForm);
                CombinePDFXForm(CanvasMat, AAXForm, CanvasMat);
                SubRender(Picasso, FStructure.NewString(GetStampStream(StampName)));
                RestoreState;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  procedure TrimImageCollection;
  var
    IX: Integer;
  begin
    FTotalImageCollectionSize := 0;
    for IX := 0 to Length(FImageCollection) - 1 do
    begin
      Inc(FTotalImageCollectionSize, FImageCollection[IX].ID.ImageDataSize);
    end;

    if (FTotalImageCollectionSize > 100000000) or (Length(FImageCollection) > 100) then
    begin
      for IX := 0 to Length(FImageCollection) - 1 do
        FImageCollection[IX].ID.Free;
      SetLength(FImageCollection, 0);
      FTotalImageCollectionSize := 0;
    end;
  end;

  function ProcessOCGMembershipDict(OCMDict: TPDFDictionary): Boolean;
  var
    Obj: TPDFObject;
    OCGRef: TPDFIndRef;
    OCGList: array of TPDFIndRef;
    OCGArray: TPDFArray;
    X: Integer;
    PName: AnsiString;
    OCGVisible: Boolean;
    OnCount: Integer;
    OffCount: Integer;
    SX: Integer;
  begin
    SetLength(OCGList, 0);

    // Get a list of the OCGs that are part of this membership dictionary
    OCGRef := nil;
    Obj := OCMDict.FindValueByKeyName('OCGs', False);
    if (Obj is TPDFIndRef) then
    begin
      // Could be an indirect reference to an array of OCGs or
      // an indirect reference to an OCG
      OCGRef := TPDFIndRef(Obj);
      Obj := FindObject(OCGRef);
    end;
    if (Obj is TPDFDictionary) then
    begin
      // The OCG membership dict has a single OCG
      SetLength(OCGList, 1);
      OCGList[0] := OCGRef;
    end else
    if (Obj is TPDFArray) then
    begin
      // Array of OCGs
      OCGArray := TPDFArray(Obj);
      for X := 0 to OCGArray.Count - 1 do
      begin
        Obj := OCGArray.Item[X];
        if (Obj is TPDFIndRef) then
        begin
          // Save the indirect reference, check if it's
          // really a TPDFDictionary first
          OCGRef := TPDFIndRef(Obj);
          Obj := FindObject(OCGRef);
        end;
        if (Obj is TPDFDictionary) then
        begin
          // We have an OCG dictionary, store the indirect reference
          SetLength(OCGList, Length(OCGList) + 1);
          OCGList[Length(OCGList) - 1] := OCGRef;
        end;
      end;
    end;

    // Default visibility policy is if any of the OCGs are on
    PName := 'AnyOn';
    Obj := OCMDict.FindValueByKeyName('P', False);
    if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
    if (Obj is TPDFName) then
    begin
      // Check for a different visibility policy, options are
      // AllOn, AnyOn, AnyOff and AllOff
      PName := TPDFName(Obj).Name;
    end;

    OnCount := 0;
    OffCount := 0;

    // Check the visibility of each OCG in OCGList
    for X := 0 to Length(OCGList) - 1 do
    begin
      OCGVisible := True;
      OCGRef := OCGList[X];

      for SX := 0 to Length(FOCGStateList) - 1 do
      begin
        if (FOCGStateList[SX].OCGIndRef.Output = OCGRef.Output) then
        begin
          if (not FOCGStateList[SX].Show) then
          begin
            OCGVisible := False;
          end;
        end;
      end;

{      Obj := FindObject(OCGRef);
      if (Obj is TPDFDictionary) then
      begin
        OCGDictionary := TPDFDictionary(Obj);
        // if not visible, set OCGVisible to false
        Obj := OCGDictionary.FindValueByKeyName('SomeValue', False);
        if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
        if (Obj is TPDFName) then
        begin
          PName := 'Something';
        end;
      end;}

      if (OCGVisible) then Inc(OnCount) else Inc(OffCount);
    end;

    Result := False;
    if ((PName = 'AllOn') and (OnCount = Length(OCGList))) then
    begin
      Result := True;
    end;
    if ((PName = 'AnyOn') and (OnCount > 0)) then
    begin
      Result := True;
    end;
    if ((PName = 'AllOff') and (OffCount = Length(OCGList))) then
    begin
      Result := True;
    end;
    if ((PName = 'AnyOff') and (OffCount > 0)) then
    begin
      Result := True;
    end;
  end;

  procedure DrawXObject(ResName: AnsiString);
  var
    O: TPDFObject;
    XO: TPDFStream;
    Subtype: AnsiString;
    Filter: AnsiString;
    M: TPDFArray;
    MMat: TPDFXForm;
    ID: TPDFImageDecoder;
    Unique: AnsiString;
    UniqueRef: TPDFIndRef;
    IX: Integer;
    FoundImage: Boolean;
    ImageListItem: TPDFImageListItem;
    TP1: TPDFDoublePoint;
    TP2: TPDFDoublePoint;
    TP3: TPDFDoublePoint;
    TP4: TPDFDoublePoint;
    FunnelImage: TPDFTextFunnelImage;
    MatchHash: Int64;
    HasBBox: Boolean;
    BBoxArray: TPDFArray;
    BBoxLeft: Double;
    BBoxTop: Double;
    BBoxRight: Double;
    BBoxBottom: Double;
    ClipPoint: TPDFDoublePoint;
    GroupDict: TPDFDictionary;
    TransparencyCS: AnsiString;
    TransparencyIsolate: Boolean;
    TransparencyKnockout: Boolean;
    XObjectOCGVisible: Boolean;
    OCGIndRef: TPDFIndRef;
    SX: Integer;
{$IFDEF QPL_CAIRO}
    punch_surface: Pcairo_surface_t;
    punch_context: Pcairo_t;
    layer_surface: Pcairo_surface_t;
    layer_context: Pcairo_t;
    target_surface: Pcairo_surface_t;
    target_context: Pcairo_t;
    backdrop_surface: Pcairo_surface_t;
    backdrop_context: Pcairo_t;
{$ENDIF}
{$IFDEF QPL_DPLR}
    TransparencyGroup: Boolean;
    FormRendererHandle: PDPLR_renderer_t;
    ParentRendererHandle: PDPLR_renderer_t;
    StrokeAlpha: Double;
    FillAlpha: Double;
    BlendMode: TPDFBlendMode;
    SavedPageMatrix: TPDFXForm;
    GDIPlusRect: TGPRectF;
    BBoxP1, BBoxP2: TPDFDoublePoint;
{$ENDIF}
    NormalRender: Boolean;
  begin
    TransparencyCS := '';
    TransparencyIsolate := False;
    TransparencyKnockout := False;
{$IFDEF QPL_DPLR}
    TransparencyGroup := False;
    FormRendererHandle := nil;
{$ENDIF}

    if MCVisible then
    begin
      O := nil;
      if Assigned(Resources) then
      begin
        O := Resources.Owner.Decode(ResName);
        if (O is TPDFName) then
        begin
          ResName := '/' + TPDFName(O).Name;
        end;
        O := Resources.FindValueByKeyName('XObject', False);
      end;
      if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
      if ((O is TPDFDictionary) and QPLStartsWith(ResName, '/')) then
      begin
        O := TPDFDictionary(O).FindValueByKeyName(QPLCopy(ResName, 2, MaxInt), False);
        if O is TPDFIndRef then
        begin
          UniqueRef := TPDFIndRef(O);
          Unique := TPDFIndRef(O).Output;
          while QPLPos(' ', Unique) > 0 do
            Unique[QPLPos(' ', Unique)] := '.';
          O := FindObject(TPDFIndRef(O));
        end else
          UniqueRef := nil;
        if O is TPDFStream then
        begin
          XO := TPDFStream(O);

          HasBBox := False;
          BBoxLeft := 0;
          BBoxBottom := 0;
          BBoxRight := 0;
          BBoxTop := 0;
          XObjectOCGVisible := MCVisible;

          O := XO.Dictionary.FindValueByKeyName('OC', False);
          if (O is TPDFIndRef) then
          begin
            OCGIndRef := TPDFIndRef(O);
            O := FindObject(OCGIndRef);
            if (O is TPDFDictionary) then
            begin
              if (TPDFDictionary(O).DictType = 'OCG') then
              begin
                // We have an optional content group
                for SX := 0 to Length(FOCGStateList) - 1 do
                begin
                  if (FOCGStateList[SX].OCGIndRef.Output = OCGIndRef.Output) then
                  begin
                    XObjectOCGVisible := FOCGStateList[SX].Show;
                  end;
                end;
              end else
              if (TPDFDictionary(O).DictType = 'OCMD') then
              begin
                // We have an optional content membership dictionary
                XObjectOCGVisible := ProcessOCGMembershipDict(TPDFDictionary(O));
              end;
            end;
          end;

          if (XObjectOCGVisible) then
          begin
            O := XO.Dictionary.FindValueByKeyName('BBox', False);
            if (O is TPDFIndRef) then
            begin
              O := FindObject(TPDFIndRef(O));
            end;
            if (O is TPDFArray) then
            begin
              BBoxArray := TPDFArray(O);
              if (BBoxArray.AllItemsNumeric) then
              begin
                HasBBox := True;
                BBoxLeft := TPDFNumeric(BBoxArray.Item[0]).AsDouble;
                BBoxBottom := TPDFNumeric(BBoxArray.Item[1]).AsDouble;
                BBoxRight := TPDFNumeric(BBoxArray.Item[2]).AsDouble;
                BBoxTop := TPDFNumeric(BBoxArray.Item[3]).AsDouble;
              end;
            end;

            O := XO.Dictionary.FindValueByKeyName('Group', False);
            if (O is TPDFIndRef) then O := FindObject(TPDFIndRef(O));
            if (O is TPDFDictionary) then
            begin
              GroupDict := TPDFDictionary(O);
              O := GroupDict.FindValueByKeyName('S', False);
              if (O is TPDFIndRef) then O := FindObject(TPDFIndRef(O));
              if (O is TPDFName) then
              begin
{$IFDEF QPL_DPLR}
                if (TPDFName(O).Name = 'Transparency') then
                begin
                  TransparencyGroup := True;
                end;
{$ENDIF}      end;

              // TODO CS can be name or array
              O := GroupDict.FindValueByKeyName('CS', False);
              if (O is TPDFIndRef) then O := FindObject(TPDFIndRef(O));
              if (O is TPDFName) then
              begin
                TransparencyCS := TPDFName(O).Name;
              end else
              begin
                TransparencyCS := 'DeviceRGB';
              end;

              O := GroupDict.FindValueByKeyName('I', False);
              if (O is TPDFIndRef) then O := FindObject(TPDFIndRef(O));
              if (O is TPDFBoolean) then
              begin
                TransparencyIsolate := TPDFBoolean(O).AsBoolean;
              end;

              O := GroupDict.FindValueByKeyName('K', False);
              if (O is TPDFIndRef) then O := FindObject(TPDFIndRef(O));
              if (O is TPDFBoolean) then
              begin
                TransparencyKnockout := TPDFBoolean(O).AsBoolean;
              end;
            end;

            O := XO.Dictionary.FindValueByKeyName('Subtype', False);
            if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
            if O is TPDFName then
            begin
              Subtype := TPDFName(O).Name;
              if Subtype = 'Form' then
              begin
                Filter := XO.Dictionary.Output;
                O := XO.Dictionary.FindValueByKeyName('Matrix', False);
                if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
                if (O is TPDFArray) and (TPDFArray(O).Count = 6) then
                begin
                  M := TPDFArray(O);
                  if (M.Item[0] is TPDFNumeric) and (M.Item[1] is TPDFNumeric) and
                    (M.Item[2] is TPDFNumeric) and (M.Item[3] is TPDFNumeric) and
                    (M.Item[4] is TPDFNumeric) and (M.Item[5] is TPDFNumeric) then
                  begin
                    MMat.eM11 := TPDFNumeric(M.Item[0]).AsDouble;
                    MMat.eM12 := TPDFNumeric(M.Item[1]).AsDouble;
                    MMat.eM21 := TPDFNumeric(M.Item[2]).AsDouble;
                    MMat.eM22 := TPDFNumeric(M.Item[3]).AsDouble;
                    MMat.eDx := TPDFNumeric(M.Item[4]).AsDouble;
                    MMat.eDy := TPDFNumeric(M.Item[5]).AsDouble;
                    CombinePDFXForm(CanvasMat, MMat, CanvasMat);
                    Picasso.SetCurrentXForm(CanvasMat);
                  end;
                end;
                ParentResources := Resources;
                SaveState;

                FUseInitialState := True;
                FInitialState := GS;

                // Set clipping path
                if (HasBBox) then
                begin
                  if (not InPath) then
                  begin
                    InPath := True;
                    if (FDestination <> rdEPS) then
                    begin
                      Picasso.BeginPath;
                    end else
                    begin
                      FEPS.PSNewPath;
                    end;
                  end;
{$IFDEF QPL_DPLR}
                  if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
                  begin
                    Picasso.BeginPath;
                    Picasso.MoveTo(BBoxLeft, BBoxBottom);
                    Picasso.AddLineToPath(BBoxLeft, BBoxTop);
                    Picasso.AddLineToPath(BBoxRight, BBoxTop);
                    Picasso.AddLineToPath(BBoxRight, BBoxBottom);
                    Picasso.ClosePath;
                    Picasso.SetClippingPath(pfAlternate);
                    Picasso.NullPath;
                    InPath := False;
                  end else
{$ENDIF}
                  if (FDestination <> rdEPS) then
                  begin
                    ClipPoint := Translate(DoublePoint(BBoxLeft, BBoxBottom));
                    Picasso.MoveTo(ClipPoint.X, ClipPoint.Y);
                    ClipPoint := Translate(DoublePoint(BBoxLeft, BBoxTop));
                    Picasso.AddLineToPath(ClipPoint.X, ClipPoint.Y);
                    ClipPoint := Translate(DoublePoint(BBoxRight, BBoxTop));
                    Picasso.AddLineToPath(ClipPoint.X, ClipPoint.Y);
                    ClipPoint := Translate(DoublePoint(BBoxRight, BBoxBottom));
                    Picasso.AddLineToPath(ClipPoint.X, ClipPoint.Y);
                    Picasso.ClosePath;
                    Picasso.SetClippingPath(pfAlternate);
                    Picasso.NullPath;
                    InPath := False;
                  end else
                  begin
                    FEPS.PSMoveTo(BBoxLeft, BBoxBottom);
                    FEPS.PSLineTo(BBoxLeft, BBoxTop);
                    FEPS.PSLineTo(BBoxRight, BBoxTop);
                    FEPS.PSLineTo(BBoxRight, BBoxBottom);
                    FEPS.PSClosePath;
                    FEPS.PSClip(epsFillModeNonZeroWinding);
                    InPath := False;
                  end;
                end;

                NormalRender := True;
{$IFDEF QPL_CAIRO}
                if ((TransparencyCS <> '') and ((FDestination = rdCairo) or (FDestination = rdCairoBitmap))) then
                begin
                  NormalRender := False;
                  if (TransparencyKnockout) then
                  begin
                    Picasso.NewCairoSurface(target_surface, backdrop_surface, target_context, backdrop_context, False);
                    Picasso.SelectCairoSurface(target_surface, target_context);
                    Picasso.NewCairoSurface(target_surface, punch_surface, target_context, punch_context, True);
                    Picasso.SelectCairoSurface(target_surface, target_context);
                    Picasso.SetCairoBackdrop(punch_surface, backdrop_surface, punch_context, backdrop_context, TransparencyIsolate);
                    FInitialState.Knockout := False;
                    SubRender(Picasso, XO, UniqueRef);
                    Picasso.CancelCairoBackdrop(target_surface, target_context);
                    Picasso.RemoveCairoSurface(punch_surface, punch_context);
                    Picasso.RemoveCairoSurface(backdrop_surface, backdrop_context);
                    RestoreState;
                  end else
                  if (TransparencyIsolate) then
                  begin
                    Picasso.NewCairoSurface(target_surface, punch_surface, target_context, punch_context, True);
                    FInitialState.Knockout := TransparencyKnockout;
                    SubRender(Picasso, XO, UniqueRef);
                    Picasso.SelectCairoSurface(target_surface, target_context);
                    Picasso.NewCairoSurface(target_surface, layer_surface, target_context, layer_context, False);
                    FInitialState.Knockout := False;
                    SubRender(Picasso, XO, UniqueRef);
                    Picasso.SelectCairoSurface(target_surface, target_context);
                    Picasso.DrawIsolatedCairoSurface(punch_surface, layer_surface);
                    Picasso.RemoveCairoSurface(layer_surface, layer_context);
                    Picasso.RemoveCairoSurface(punch_surface, punch_context);
                    RestoreState;
                  end else
                  begin
                    SubRender(Picasso, XO, UniqueRef);
                    RestoreState;
                  end;
  {                Picasso.BeginGroup;
                  FInitialState.FillAlpha := 1;
                  SubRender(Picasso, XO, UniqueRef);
                  RestoreState;
                  Picasso.EndGroup(GS.FillAlpha);}
                end;
{$ENDIF}

{$IFDEF QPL_DPLR}
                if (FDestination = rdDPLRPrinter) then
                begin
                  Picasso.GDIPlus.GdipGetVisibleClipBounds(Picasso.Graphics, @GDIPlusRect);
                  if (IsBBoxInPrinterArray(GDIPlusRect.X, GDIPlusRect.Y,
                      GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height) = False) then
                  begin
                    if TransparencyGroup and
                     ((GS.FillAlpha < 1) or (GS.StrokeAlpha < 1) or
                      (GS.BlendMode <> bmNormal) or
                     (GS.Softmask = True) or
                      TransparencyKnockout or TransparencyIsolate) then
                    begin
                      AddToPrinterBBoxArray(GDIPlusRect.X, GDIPlusRect.Y,
                        GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height);
                      NormalRender := False;
                      RestoreState;
                    end;
                  end else
                  begin
                    NormalRender := False;
                    RestoreState;
                  end;
                end;

                // DPLR clip optimization
                if ((FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory)) then
                begin
                  if (Picasso.RendererDLL.DPLR_has_clip(Picasso.RendererHandle) = 0) then
                  begin
                    NormalRender := False;
                    RestoreState;
                  end;
                end;

                if (NormalRender and TransparencyGroup and ((FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory)) and
                  ((GS.FillAlpha < 1) or (GS.StrokeAlpha < 1) or
                  (GS.BlendMode <> bmNormal) or
                  (Picasso.RendererDLL.DPLR_renderer_has_softmask(Picasso.RendererHandle) = 1) or
                  TransparencyKnockout or TransparencyIsolate)) then
                begin
                  NormalRender := False;

                  StrokeAlpha := GS.StrokeAlpha;
                  FillAlpha := GS.FillAlpha;
                  BlendMode := GS.BlendMode;

                  GS.StrokeAlpha := 1;
                  GS.FillAlpha := 1;
                  GS.BlendMode := bmNormal;
                  Picasso.RendererDLL.DPLR_renderer_clear_softmask(FormRendererHandle);

                  ParentRendererHandle := Picasso.RendererHandle;
                  FormRendererHandle := Picasso.RendererDLL.DPLR_renderer_group_create(ParentRendererHandle,
                    Integer(TransparencyGroup),
                    Integer(TransparencyKnockout),
                    Integer(TransparencyIsolate));
                  if (Assigned(FormRendererHandle)) then
                  try
                    Picasso.RendererHandle := FormRendererHandle;

                    Picasso.SetPageMatrix(CanvasMat);
                    SavedPageMatrix := FPageMatrix;
                    FPageMatrix := CanvasMat;

                    FUseInitialState := True;
                    FInitialState := GS;
                    SubRender(Picasso, XO, UniqueRef);

                    Picasso.RendererDLL.DPLR_renderer_blend_group(FormRendererHandle, FillAlpha, Picasso.RendererDLL.GetBlendMode(BlendMode));

                  finally
                    Picasso.RendererDLL.DPLR_renderer_destroy(FormRendererHandle);
                  end;

                  Picasso.RendererHandle := ParentRendererHandle;
                  FPageMatrix := SavedPageMatrix;
                  Picasso.SetPageMatrix(FPageMatrix);

                  GS.StrokeAlpha := StrokeAlpha;
                  GS.FillAlpha := FillAlpha;
                  GS.BlendMode := BlendMode;

                  RestoreState;
                end;
{$ENDIF}
                if (NormalRender) then
                begin
                  if ((TransparencyIsolate) or (TransparencyKnockout)) then
                  begin
                    // Use these variables to avoid compiler hints
                  end;
{$IFDEF QPL_DPLR}
                  if ((FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory)) then
                  begin
                      Picasso.SetPageMatrix(CanvasMat);
                      SavedPageMatrix := FPageMatrix;
                      FPageMatrix:=CanvasMat;
                  end;
{$ENDIF}
                  SubRender(Picasso, XO, UniqueRef);
                  RestoreState;
{$IFDEF QPL_DPLR}
                  if ((FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory)) then
                  begin
                    FPageMatrix := SavedPageMatrix;
                    Picasso.SetPageMatrix(FPageMatrix);
                  end;
{$ENDIF}
                end;
              end;
              if ((Subtype = 'Image') and (FDestination <> rdTextFunnel)) then
              begin
                ID := nil;
                FoundImage := False;
                IX := 0;
                if Assigned(UniqueRef) then
                begin
                  MatchHash := UniqueRef.GenNum;
                  MatchHash := MatchHash shl 32;
                  MatchHash := MatchHash + UniqueRef.ObjNum;
                  while (not FoundImage) and (IX < Length(FImageCollection)) do
                  begin
                    if MatchHash = FImageCollection[IX].Hash then
                    begin
                      FoundImage := True;
                      ID := FImageCollection[IX].ID;
                    end else
                      Inc(IX);
                  end;
                end;

                // Calculate top left, top right and bottom right corner
                // coordinates for GDI+
                TP1.X := 0;
                TP1.Y := 1;
                TP2.X := 1;
                TP2.Y := 1;
                TP3.X := 1;
                TP3.Y := 0;
                TP4.X := 0;
                TP4.Y := 0;
                TP1 := DoPDFXForm(CanvasMat, TP1);
                TP2 := DoPDFXForm(CanvasMat, TP2);
                TP3 := DoPDFXForm(CanvasMat, TP3);
                TP4 := DoPDFXForm(CanvasMat, TP4);

{$IFDEF QPL_DPLR}
                // DPLR clip optimization
                if ((FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory)) then
                begin
                  if (Picasso.RendererDLL.DPLR_has_clip(Picasso.RendererHandle) = 0) then
                    Exit;

                  BBoxP1.X := Math.Min(Math.Min(TP1.X, TP2.X), Math.Min(TP3.X, TP4.X));
                  BBoxP1.Y := Math.Min(Math.Min(TP1.Y, TP2.Y), Math.Min(TP3.Y, TP4.Y));
                  BBoxP2.X := Math.Max(Math.Max(TP1.X, TP2.X), Math.Max(TP3.X, TP4.X));
                  BBoxP2.Y := Math.Max(Math.Max(TP1.Y, TP2.Y), Math.Max(TP3.Y, TP4.Y));
                  if (Picasso.RendererDLL.DPLR_intersect_clip(Picasso.RendererHandle,
                    BBoxP1.X, BBoxP1.Y, BBoxP2.X, BBoxP2.Y) = 0) then
                    Exit;

                  SetFill(pfWinding);
                  Picasso.SetBlendMode(GS.BlendMode);
                end;

{$ENDIF}

                // Pass in the current transformation matrix for Cairo/DPLR
                Picasso.SetCurrentXForm(CanvasMat);

                if not FoundImage then
                begin
                  ID := TPDFImageDecoder.Create;
                  ID.HorizontalSize := Abs(TP1.X - TP2.X) / FDPI;
                  ID.VerticalSize := Abs(TP1.Y - TP4.Y) / FDPI;

                  if FDestination = rdImageList then
                  begin
                    ID.DecodeMode := dmToNative;
                    ID.IsImageExtraction := True;
{$IFDEF QPL_DPLR}
                  end else
                  if ((FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory)) then
                  begin
                    ID.DecodeMode := dmToDPLR;
                    ID.DPLRPicasso := Picasso;
{$ENDIF}
                  end;

                  ID.RenderToEPS := FDestination = rdEPS;

                  ID.SetColorManager(FColorManager);
                  ID.OnFindObject := FOnFindObject;
                  ID.OnDecrypt := FOnDecrypt;
                  ID.OnEncrypt := FOnEncrypt;
                  ID.OldFillColor := GS.FillColor;
                  ID.IgnoreICCProfiles := FGDIPlusSettings.IgnoreICCProfiles;
                  ID.LastFICCProfile := LastFICCProfile;
                  ID.LastFICCProfileIndObj := LastFICCProfileIndObj;

                  if Assigned(FOnDecrypt) and Assigned(UniqueRef) then
                    FOnDecrypt(XO, UniqueRef);
                  ID.LoadFromPDFStream(XO);
                  if Assigned(FOnEncrypt) and Assigned(UniqueRef) then
                    FOnEncrypt(XO, UniqueRef);

                  if (LastFICCProfile <> ID.LastFICCProfile) then
                  begin
                    LastFICCProfile := ID.LastFICCProfile;
                    LastFICCProfileIndObj := ID.LastFICCProfileIndObj;
                  end;

                  if (not ID.LoadException) then
                  begin
                    TrimImageCollection;
                    SetLength(FImageCollection, Length(FImageCollection) + 1);
                    FImageCollection[Length(FImageCollection) - 1].ID := ID;
                    FImageCollection[Length(FImageCollection) - 1].Ref := UniqueRef;
                    MatchHash := UniqueRef.GenNum;
                    MatchHash := MatchHash shl 32;
                    MatchHash := MatchHash + UniqueRef.ObjNum;
                    FImageCollection[Length(FImageCollection) - 1].Hash :=
                      MatchHash;
                    Inc(FTotalImageCollectionSize, ID.ImageDataSize);
                  end else
                  begin
                    ID.Free;
                    ID := nil;
                    FErrorDesc := 'Error rendering image';
                  end;
                end;
                if Assigned(ID) then
                begin
                  case FDestination of
                    rdTextFunnel:
                    begin
                      FunnelImage.XObjectName := ResName;
                      FunnelImage.XObjectObjRef := Unique;
                      FunnelImage.P1 := TPDFDoublePoint(TP1);
                      FunnelImage.P2 := TPDFDoublePoint(TP2);
                      FunnelImage.P3 := TPDFDoublePoint(TP3);
                      FunnelImage.P4 := TPDFDoublePoint(TP4);
                      TextFunnel.AddImage(FunnelImage);
                    end;
                    rdImageList:
                    begin
                      if ID.NativeType = nitTIFF then
                      begin
                        ImageListItem.ImageType := nitTIFF;
                        ImageListItem.ImageData := ID.NativeImageData;
                      end else
                      if ID.NativeType = nitJPEG then
                      begin
                        ImageListItem.ImageType := nitJPEG;
                        ImageListItem.ImageData := ID.NativeImageData;
                      end else
                      if ID.NativeType = nitPNG then
                      begin
                        ImageListItem.ImageType := nitPNG;
                        ImageListItem.ImageData := ID.NativeImageData;
                      end else
                      begin
                        ImageListItem.ImageType := nitBMP;
                        ImageListItem.ImageData := ID.NativeImageData;
                      end;
                      ImageListItem.PixelWidth := ID.Width;
                      ImageListItem.PixelHeight := ID.Height;
                      ImageListItem.Corners[icTopLeft] := TP1;
                      ImageListItem.Corners[icTopRight] := TP2;
                      ImageListItem.Corners[icBottomRight] := TP3;
                      ImageListItem.Corners[icBottomLeft] := TP4;

                      ImageListItem.ColorSpaceType := -1;
                      ImageListItem.BitsPerPixel := -1;
                      ImageListItem.FormatDesc0 := ID.GetFormatDesc(nil, 0, False);
                      ImageListItem.FormatDesc1 := ID.GetFormatDesc(nil, 1, False);

                      if (ID.ColorSpace = '') and (ID.BitsPerComponent = 1) then
                      begin
                        ImageListItem.ColorSpaceType := 1;
                        ImageListItem.BitsPerPixel := ID.BitsPerComponent;
                      end else
                      if (ID.ColorSpace = 'DeviceGray') then
                      begin
                        ImageListItem.ColorSpaceType := 1;
                        ImageListItem.BitsPerPixel := ID.BitsPerComponent;
                      end else
                      if (ID.ColorSpace = 'DeviceRGB') and (ID.MaskType = mtNone) then
                      begin
                        ImageListItem.ColorSpaceType := 2;
                        ImageListItem.BitsPerPixel := ID.BitsPerComponent * 3;
                      end else
                      if (ID.ColorSpace = 'DeviceRGB') and (ID.MaskType <> mtNone) then
                      begin
                        ImageListItem.ColorSpaceType := 2;
                        ImageListItem.BitsPerPixel := ID.BitsPerComponent * 3;
                      end else
                      if (ID.ColorSpace = 'Indexed') and (ID.MaskType <> mtNone) then
                      begin
                        // Indexed color spaces are converted to RGB
                        ImageListItem.ColorSpaceType := 2;
                        ImageListItem.BitsPerPixel := ID.BitsPerComponent * 3;
                      end
                      else  // We have already processed the following colorspaces ready for the image decoder
                            // so we will use the processed Bitmap for the rdImageList imagedata
                      begin
                        ImageListItem.ColorSpaceType := 2;
                        ImageListItem.BitsPerPixel := ID.BitsPerComponent * 3;

                        ImageListItem.ImageType := nitBMP;
                        ImageListItem.ImageData := ID.BitmapAsString;
                      end;

                      ImageListItem.ImageRef := UniqueRef;
                      FImageList.AddImage(ImageListItem);
                    end;
                    rdEPS:
                    begin
                      if (Assigned(ID.Bitmap)) then
                      begin
                        FEPS.PSImageFromBitmap(ID.Bitmap, ID.MaskBitmap, Unique, ID.MaskType = mtStencil);
                      end;
                    end;
{$IFDEF QPL_DPLR}
                    rdDPLRPrinter:
                    begin
                      BBoxP1.X := 0;
                      BBoxP1.Y := 0;
                      BBoxP1 := Translate(BBoxP1);
                      BBoxP2.X := 1;
                      BBoxP2.Y := 1;
                      BBoxP2 := Translate(BBoxP2);
                      if (IsBBoxInPrinterArray(BBoxP1.X, BBoxP1.Y, BBoxP2.X, BBoxP2.Y) = False) then
                      begin
                        if ((GS.FillAlpha < 1) or
                          (GS.BlendMode <> bmNormal) or
                          (GS.Softmask = True) or
                          //(ID.MaskType = mtStencil)) then  BUG Brothers1, page 5
                          (ID.MaskType <> mtNone)) then
                          AddToPrinterBBoxArray(BBoxP1.X, BBoxP1.Y, BBoxP2.X, BBoxP2.Y)
                        else
                          ID.Draw(Picasso, CanvasMat, GS.FillColor);
                      end;
                    end;
{$ENDIF}
                  else
                    ID.Draw(Picasso, CanvasMat, GS.FillColor);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;  // MCVisible
  end;  // DrawXObject function


{$IFDEF QPL_DPLR}
  procedure DrawSoftmaskXObject(Softmask: TQPLSoftmask);
  var
    O: TPDFObject;
    XO: TPDFStream;
    Unique: AnsiString;
    UniqueRef: TPDFIndRef;
    Subtype: AnsiString;
    Filter: AnsiString;
    M: TPDFArray;
    MMat: TPDFXForm;
    HasBBox: Boolean;
    BBoxArray: TPDFArray;
    BBoxLeft: Double;
    BBoxTop: Double;
    BBoxRight: Double;
    BBoxBottom: Double;
    GroupDict: TPDFDictionary;
    TransparencyCS: AnsiString;
    TransparencyGroup : Boolean;
    TransparencyIsolate: Boolean;
    TransparencyKnockout: Boolean;
    XObjectOCGVisible: Boolean;
    OCGIndRef: TPDFIndRef;
    SX: Integer;
    FormRendererHandle: PDPLR_renderer_t;
    ParentRendererHandle: PDPLR_renderer_t;
    K: Double;
    RGB: TPDFRGBColor;
    CMYK: TPDFCMYKColor;
    CSArray: TPDFArray;
    ICCStream: TPDFStream;
    BCColor: TColor;
    Family: AnsiString;
  begin
    TransparencyCS := '';
    TransparencyGroup := False;
    TransparencyIsolate := True;
    TransparencyKnockout := False;

    if MCVisible then
    begin
      if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
      begin
        O := Softmask.SourceDict.FindValueByKeyName('G', False);
        if O is TPDFIndRef then
        begin
          UniqueRef := TPDFIndRef(O);
          Unique := TPDFIndRef(O).Output;
          while QPLPos(' ', Unique) > 0 do
            Unique[QPLPos(' ', Unique)] := '.';
          O := FindObject(TPDFIndRef(O));
        end else
          UniqueRef := nil;
        if O is TPDFStream then
        begin
          XO := TPDFStream(O);

          HasBBox := False;
          BBoxLeft := 0;
          BBoxBottom := 0;
          BBoxRight := 0;
          BBoxTop := 0;
          XObjectOCGVisible := MCVisible;

          O := XO.Dictionary.FindValueByKeyName('OC', False);
          if (O is TPDFIndRef) then
          begin
            OCGIndRef := TPDFIndRef(O);
            O := FindObject(OCGIndRef);
            if (O is TPDFDictionary) then
            begin
              if (TPDFDictionary(O).DictType = 'OCG') then
              begin
                // We have an optional content group
                for SX := 0 to Length(FOCGStateList) - 1 do
                begin
                  if (FOCGStateList[SX].OCGIndRef.Output = OCGIndRef.Output) then
                  begin
                    XObjectOCGVisible := FOCGStateList[SX].Show;
                  end;
                end;
              end else
              if (TPDFDictionary(O).DictType = 'OCMD') then
              begin
                // We have an optional content membership dictionary
                XObjectOCGVisible := ProcessOCGMembershipDict(TPDFDictionary(O));
              end;
            end;
          end;

          if (XObjectOCGVisible) then
          begin
            O := XO.Dictionary.FindValueByKeyName('BBox', False);
            if (O is TPDFIndRef) then
            begin
              O := FindObject(TPDFIndRef(O));
            end;
            if (O is TPDFArray) then
            begin
              BBoxArray := TPDFArray(O);
              if (BBoxArray.AllItemsNumeric) then
              begin
                HasBBox := True;
                BBoxLeft := TPDFNumeric(BBoxArray.Item[0]).AsDouble;
                BBoxBottom := TPDFNumeric(BBoxArray.Item[1]).AsDouble;
                BBoxRight := TPDFNumeric(BBoxArray.Item[2]).AsDouble;
                BBoxTop := TPDFNumeric(BBoxArray.Item[3]).AsDouble;
              end;
            end;

            // TODO
            // If there is no TransparencyCS - use default color space instead
            // Default color space: the color space of the parent group or page into which this transparency group is painted.
            TransparencyCS := 'DeviceRGB';

            O := XO.Dictionary.FindValueByKeyName('Group', False);
            if (O is TPDFIndRef) then O := FindObject(TPDFIndRef(O));
            if (O is TPDFDictionary) then
            begin
              GroupDict := TPDFDictionary(O);

              O := GroupDict.FindValueByKeyName('S', False);
              if (O is TPDFIndRef) then O := FindObject(TPDFIndRef(O));
              if (O is TPDFName) then
              begin
                if (TPDFName(O).Name = 'Transparency') then
                begin
                  TransparencyGroup := True;
                end;
              end;

              // TODO CS can be name or array (e.g. ICCBased)
              O := GroupDict.FindValueByKeyName('CS', False);
              if (O is TPDFIndRef) then O := FindObject(TPDFIndRef(O));
              if (O is TPDFName) then
              begin
                TransparencyCS := TPDFName(O).Name;
              end else
              if (O is TPDFArray) then
              begin
                CSArray := TPDFArray(O);
                if CSArray.Count >= 1 then
                begin
                  O := CSArray.Item[0];
                  if O is TPDFName then
                  begin
                    Family := TPDFName(O).Name;
                    if Family = 'ICCBased' then
                    begin
                      if CSArray.Count >= 2 then
                      begin
                        O := CSArray.Item[1];
                        if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
                        if O is TPDFStream then
                        begin
                          ICCStream := TPDFStream(O);
                          O := ICCStream.Dictionary.FindValueByKeyName('Alternate', False);
                          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
                          if O is TPDFName then
                          begin
                            TransparencyCS := TPDFName(O).Name;
                          end else
                          begin
                            O := ICCStream.Dictionary.FindValueByKeyName('N', False);
                            if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
                            if O is TPDFNumeric then
                            begin
                              case TPDFNumeric(O).AsInteger of
                                1: TransparencyCS := 'DeviceGray';
                                3: TransparencyCS := 'DeviceRGB';
                                4: TransparencyCS := 'DeviceCMYK';
                              end;
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end;

              //FB 20943
              //O := GroupDict.FindValueByKeyName('I', False);
              //if (O is TPDFIndRef) then O := FindObject(TPDFIndRef(O));
              //if (O is TPDFBoolean) then
              //begin
              //  TransparencyIsolate := TPDFBoolean(O).AsBoolean;
              //end;

              O := GroupDict.FindValueByKeyName('K', False);
              if (O is TPDFIndRef) then O := FindObject(TPDFIndRef(O));
              if (O is TPDFBoolean) then
              begin
                TransparencyKnockout := TPDFBoolean(O).AsBoolean;
              end;
            end;

            O := XO.Dictionary.FindValueByKeyName('Subtype', False);
            if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
            if O is TPDFName then
            begin
              Subtype := TPDFName(O).Name;
              if Subtype = 'Form' then
              begin
                Filter := XO.Dictionary.Output;
                O := XO.Dictionary.FindValueByKeyName('Matrix', False);
                if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
                if (O is TPDFArray) and (TPDFArray(O).Count = 6) then
                begin
                  M := TPDFArray(O);
                  if (M.Item[0] is TPDFNumeric) and (M.Item[1] is TPDFNumeric) and
                    (M.Item[2] is TPDFNumeric) and (M.Item[3] is TPDFNumeric) and
                    (M.Item[4] is TPDFNumeric) and (M.Item[5] is TPDFNumeric) then
                  begin
                    MMat.eM11 := TPDFNumeric(M.Item[0]).AsDouble;
                    MMat.eM12 := TPDFNumeric(M.Item[1]).AsDouble;
                    MMat.eM21 := TPDFNumeric(M.Item[2]).AsDouble;
                    MMat.eM22 := TPDFNumeric(M.Item[3]).AsDouble;
                    MMat.eDx := TPDFNumeric(M.Item[4]).AsDouble;
                    MMat.eDy := TPDFNumeric(M.Item[5]).AsDouble;
                    CombinePDFXForm(CanvasMat, MMat, CanvasMat);
                    Picasso.SetCurrentXForm(CanvasMat);
                  end;
                end;
                ParentResources := Resources;

                SaveState;

                // Set clipping path
                if (HasBBox) then
                begin
                  InPath := True;
                  Picasso.BeginPath;
                  Picasso.MoveTo(BBoxLeft, BBoxBottom);
                  Picasso.AddLineToPath(BBoxLeft, BBoxTop);
                  Picasso.AddLineToPath(BBoxRight, BBoxTop);
                  Picasso.AddLineToPath(BBoxRight, BBoxBottom);
                  Picasso.ClosePath;
                  Picasso.SetClippingPath(pfWinding);
                  Picasso.NullPath;
                  InPath := False;
                end;

                // DPLR clip optimization
                if (Picasso.RendererDLL.DPLR_has_clip(Picasso.RendererHandle) <> 0) then
                begin
                  BCColor := clBlack;
                  if (TransparencyCS <> '') then
                  begin
                    if (Softmask.GetBCLength() > 0) then  // Alpha SM
                    begin
                      if ((TransparencyCS = 'DeviceRGB') and (Softmask.GetBCLength() >= 3)) then
                      begin
                          RGB.Blue := Softmask.GetBCArray(0);
                          RGB.Green := Softmask.GetBCArray(1);
                          RGB.Red := Softmask.GetBCArray(2);
                          BCColor := FColorManager.RGB2Color(RGB);
                      end else
                      if ((TransparencyCS = 'DeviceCMYK') and (Softmask.GetBCLength() >= 4)) then
                      begin
                        CMYK.Black := Softmask.GetBCArray(0);
                        CMYK.Yellow := Softmask.GetBCArray(1);
                        CMYK.Magenta := Softmask.GetBCArray(2);
                        CMYK.Cyan := Softmask.GetBCArray(3);
                        RGB := FColorManager.CMYK2RGB(CMYK);
                        BCColor := FColorManager.RGB2Color(RGB);
                      end else
                      if ((TransparencyCS = 'DeviceGray') and (Softmask.GetBCLength() >= 1)) then
                      begin
                        K := Softmask.GetBCArray(0);
                        BCColor := Round(K * 255) shl 16 + Round(K * 255) shl 8 + Round(K * 255);
                      end;
                    end;
                  end;

                  MMat := CanvasMat;
                  // TODO - pattern in softmask
                  //Picasso.SetPageMatrix(CanvasMat);
                  //SavedPageMatrix := FPageMatrix;
                  //FPageMatrix := CanvasMat;

                  ParentRendererHandle := Picasso.RendererHandle;
                  FormRendererHandle := Picasso.RendererDLL.DPLR_renderer_group_create(ParentRendererHandle,
                    Integer(TransparencyGroup),
                    Integer(TransparencyKnockout),
                    Integer(TransparencyIsolate));

                  if (Assigned(FormRendererHandle)) then
                  try
                    Picasso.RendererDLL.DPLR_renderer_clear_softmask(FormRendererHandle);

                    if (Softmask.SoftmaskType = ptLuminosity) then
                    begin
                      Picasso.RendererDLL.DPLR_renderer_clear_surface(FormRendererHandle,
                        (BCColor and $FF) / 255,
                        ((BCColor and $FF00) shr 8) / 255,
                        ((BCColor and $FF0000) shr 16) / 255, 1);
                    end;

                    Picasso.RendererHandle := FormRendererHandle;

                    FUseInitialState := False;
                    SubRender(Picasso, XO, UniqueRef);

                    Picasso.RendererDLL.DPLR_renderer_set_softmask(FormRendererHandle,
                      Integer(Softmask.SoftmaskType),
                      DPLR_softmask_read, Softmask);

                  finally
                    Picasso.RendererDLL.DPLR_renderer_destroy(FormRendererHandle);
                  end;

                  Picasso.RendererHandle := ParentRendererHandle;
                  CanvasMat := MMat;
                  // TODO
                  //FPageMatrix := SavedPageMatrix;
                  //Picasso.SetPageMatrix(FPageMatrix);

                  RestoreState;
                end else
                  RestoreState;
              end;
            end;
          end;
        end;
      end;
    end;  // MCVisible
  end;  // DrawSoftmaskXObject function
{$ENDIF}

  procedure FindGraphicsState(const GSName: AnsiString);
  var
    O: TPDFObject;
    GraphicsState: TPDFDictionary;
    FontArray: TPDFArray;
    DashArray: TPDFArray;
    DashPhaseArray: TPDFArray;
    I : Integer;
    ReadTransparency : Boolean;
{$IFDEF QPL_DPLR}
    Softmask: TQPLSoftmask;
{$ENDIF}
  begin
    O := Resources.FindValueByKeyName('ExtGState', False);
    if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
    if O is TPDFDictionary then
    begin
      O := TPDFDictionary(O).FindValueByKeyName(QPLCopy(GSName, 2, MaxInt), False);
      if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
      if O is TPDFDictionary then
      begin
        GraphicsState := TPDFDictionary(O);
        if (GraphicsState.DictType = '') or (GraphicsState.DictType = 'ExtGState') then
        begin
          O := GraphicsState.FindValueByKeyName('LW', False);
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          if O is TPDFNumeric then
            GS.LineWidth := TPDFNumeric(O).AsDouble;
          O := GraphicsState.FindValueByKeyName('LC', False);
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          if O is TPDFNumeric then
            GS.LineCap := TPDFNumeric(O).AsInteger;
          O := GraphicsState.FindValueByKeyName('LJ', False);
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          if O is TPDFNumeric then
            GS.LineJoin := TPDFNumeric(O).AsInteger;
          O := GraphicsState.FindValueByKeyName('ML', False);
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          if O is TPDFNumeric then
            GS.MiterLimit := TPDFNumeric(O).AsDouble;
          O := GraphicsState.FindValueByKeyName('Font', False);
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          if O is TPDFArray then
          begin
            FontArray := TPDFArray(O);
            if (FontArray.Count = 2) and (FontArray.Item[0] is TPDFIndRef) and
              (FontArray.Item[1] is TPDFNumeric) then
            begin
              GS.TextFont := FontArray.Item[0].Output;
              GS.TextSize := TPDFNumeric(FontArray.Item[0]).AsDouble;
            end;
          end;

          //D array
          //The line dash pattern, expressed as an array of the form [ dashArray dashPhase ],
          //where dashArray is itself an array and dashPhase is an integer
          O := GraphicsState.FindValueByKeyName('D', False);
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          if O is TPDFArray then
          begin
            SetLength(GS.DashArray, 0);
            DashArray := TPDFArray(O);
            O := DashArray.Item[0];
            if (O is TPDFIndRef) then O := FindObject(TPDFIndRef(O));
            if (O is TPDFArray) then
            begin
              DashPhaseArray := TPDFArray(O);
              SetLength(GS.DashArray, DashPhaseArray.Count);
              for I := 0 to DashPhaseArray.Count-1 do
              begin
                O := DashPhaseArray.Item[I];
                if O is TPDFNumeric then
                  GS.DashArray[I] := TPDFNumeric(O).AsDouble;
              end;
            end;
            O := DashArray.Item[1];
            if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
             if (O is TPDFNumeric) then
            begin
              GS.DashPhase := TPDFNumeric(O).AsDouble;
            end;
          end;
{$IFDEF QPL_DPLR}
          if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
          begin
            Picasso.SetLineDashDouble(GS.DashArray, GS.DashPhase);
          end;
{$ENDIF}

{$IFDEF QPL_DPLR}
          O := GraphicsState.FindValueByKeyName('SMask', False);
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          if O is TPDFName then
          begin
            GS.Softmask := False;
            if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
            begin
              Picasso.RendererDLL.DPLR_renderer_clear_softmask(Picasso.RendererHandle);
            end;
          end else if O is TPDFDictionary then
          begin
            GS.Softmask := True;
            if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
            begin
              // Populate the new softmask
              Softmask := TQPLSoftmask.Create(FColorManager);
              try
                Softmask.OnFindObject := FOnFindObject;
                Softmask.Populate(TPDFDictionary(O));
                // Apply softmask to DPLR
                DrawSoftmaskXObject(Softmask);
              finally
                Softmask.Free;
              end;
            end;
          end;

          { TODO
          O := GraphicsState.FindValueByKeyName('TK', False);
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          if O is TPDFBoolean then
          begin
            GS.TextKnockout := TPDFBoolean(O).AsBoolean;
          end;
          }
{$ENDIF}

          ReadTransparency := not GS.Knockout;
{$IFDEF QPL_DPLR}
          if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
          begin
            ReadTransparency := True;
          end;
{$ENDIF}
          if (ReadTransparency) then
          begin
            O := GraphicsState.FindValueByKeyName('CA', False);
            if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
            if O is TPDFNumeric then
            begin
              GS.StrokeAlpha := TPDFNumeric(O).AsDouble;
            end;

            O := GraphicsState.FindValueByKeyName('ca', False);
            if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
            if O is TPDFNumeric then
            begin
              GS.FillAlpha := TPDFNumeric(O).AsDouble;
            end;

            O := GraphicsState.FindValueByKeyName('BM', False);
            if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
            if O is TPDFName then
            begin
              if (TPDFName(O).Name = 'Normal') then GS.BlendMode := bmNormal;
              if (TPDFName(O).Name = 'Compatible') then GS.BlendMode := bmNormal;
              if (TPDFName(O).Name = 'Multiply') then GS.BlendMode := bmMultiply;
              if (TPDFName(O).Name = 'Screen') then GS.BlendMode := bmScreen;
              if (TPDFName(O).Name = 'Overlay') then GS.BlendMode := bmOverlay;
              if (TPDFName(O).Name = 'Darken') then GS.BlendMode := bmDarken;
              if (TPDFName(O).Name = 'Lighten') then GS.BlendMode := bmLighten;
              if (TPDFName(O).Name = 'ColorDodge') then GS.BlendMode := bmColorDodge;
              if (TPDFName(O).Name = 'ColorBurn') then GS.BlendMode := bmColorBurn;
              if (TPDFName(O).Name = 'HardLight') then GS.BlendMode := bmHardLight;
              if (TPDFName(O).Name = 'SoftLight') then GS.BlendMode := bmSoftLight;
              if (TPDFName(O).Name = 'Difference') then GS.BlendMode := bmDifference;
              if (TPDFName(O).Name = 'Exclusion') then GS.BlendMode := bmExclusion;
{$IFDEF QPL_DPLR}
              if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
              begin
                if (TPDFName(O).Name = 'Hue') then GS.BlendMode := bmHue;
                if (TPDFName(O).Name = 'Saturation') then GS.BlendMode := bmSaturation;
                if (TPDFName(O).Name = 'Color') then GS.BlendMode := bmColor;
                if (TPDFName(O).Name = 'Luminosity') then GS.BlendMode := bmLuminosity;
              end;
{$ENDIF}
            end;
          end;
        end;
      end;
    end;
  end;

  function NextToken: AnsiString;
  var
    InWhitespace: Boolean;
    TokStart: Integer;
    TokEnd: Integer;
    InStr: Integer;
    InSlash: Boolean;
  begin
    if TokPos < MaxLen then
    begin
      repeat
        InWhitespace := False;
        case S[TokPos] of
          #0,#9,#10,#12,#13,#32:
          begin
            InWhitespace := True;
            Inc(TokPos);
          end;
        end;
      until (not InWhitespace) or (TokPos > MaxLen);
      if TokPos = MaxLen then
      begin
        Result := S[TokPos];
        TokPos := MaxLen + 1;
      end else
      if TokPos < MaxLen then
      begin
        TokStart := TokPos;
        if S[TokStart] = '(' then
        begin
          InStr := 1;
          InSlash := False;
          repeat
            Inc(TokPos);
            if InSlash then
            begin
              InSlash := False;
            end else
            case S[TokPos] of
              '\': InSlash := True;
              ')': Dec(InStr);
              '(': Inc(InStr);
            end;
          until (InStr = 0) or (TokPos >= MaxLen);
          Inc(TokPos);
          Result := QPLCopy(S, TokStart, TokPos - TokStart);
        end else
        if (S[TokStart] = '<') and (S[TokStart+1] = '<') then
        begin
          repeat
            Inc(TokPos);
          until ((S[TokPos] = '>') and (S[TokPos+1] = '>')) or (TokPos >= MaxLen);
          Inc(TokPos);
          if (TokPos < MaxLen) then
            Inc(TokPos);
          Result := QPLCopy(S, TokStart, TokPos - TokStart);
        end else
        if S[TokStart] = '<' then
        begin
          repeat
            Inc(TokPos);
          until (S[TokPos] = '>') or (TokPos >= MaxLen);
          Inc(TokPos);
          Result := QPLCopy(S, TokStart, TokPos - TokStart);
        end else
        if (S[TokStart] = '[') or (S[TokStart] = ']') or (S[TokStart] = '''') then
        begin
          Result := S[TokStart];
          Inc(TokPos);
        end else
        begin
          repeat
            Inc(TokPos);
            InWhitespace := False;
            case S[TokPos] of
              #0,#9,#10,#12,#13,#32,#40,#47,#60,#91,#93: InWhitespace := True;
            end;
          until (InWhitespace) or (TokPos >= MaxLen);
          if (not InWhitespace) and (TokPos = MaxLen) then Inc(TokPos);
          TokEnd := TokPos - 1;
          Result := QPLCopy(S, TokStart, TokEnd - TokStart + 1);
          if InWhitespace and (TokPos = MaxLen) then Inc(TokPos);
        end;
      end else
        Result := '';
    end else
      Result := '';
  end;

  function FindColorSpaceResource(const CS: AnsiString): TPDFObject;
  var
    O: TPDFObject;
    ColorSpaceDict: TPDFDictionary;
  begin
    Result := nil;
    if (Assigned(Resources)) then
    begin
      O := Resources.FindValueByKeyName('ColorSpace');
      if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
      if O is TPDFDictionary then
      begin
        ColorSpaceDict := TPDFDictionary(O);
        if QPLStartsWith(CS, '/') then
          O := ColorSpaceDict.FindValueByKeyName(QPLCopy(CS, 2, MaxInt))
        else
          O := ColorSpaceDict.FindValueByKeyName(CS);
        if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
        if Assigned(O) then Result := O;
      end;
    end;
  end;

  procedure BeginMarkedContent(const Tag, Prop: AnsiString);
  var
    O: TPDFObject;
    P: TPDFDictionary;
    SX: Integer;
    OCGIndRef: TPDFIndRef;
  begin
    // Remember the previous visible/invisible state
    if MCVisible then
      MCStack.Add('Visible')
    else
      MCStack.Add('Invisible');

    if Tag = '/OC' then
    begin
      O := Resources.FindValueByKeyName('Properties', False);
      if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
      if O is TPDFDictionary then
      begin
        P := TPDFDictionary(O);
        O := P.FindValueByKeyName(QPLCopy(Prop, 2, MaxInt));
        if (O is TPDFIndRef) then
        begin
          OCGIndRef := TPDFIndRef(O);
          O := FindObject(OCGIndRef);
          if (O is TPDFDictionary) then
          begin
            if (TPDFDictionary(O).DictType = 'OCG') then
            begin
              // We have an optional content group
              for SX := 0 to Length(FOCGStateList) - 1 do
              begin
                if (FOCGStateList[SX].OCGIndRef.Output = OCGIndRef.Output) then
                begin
                  MCVisible := FOCGStateList[SX].Show and MCVisible;
                end;
              end;
            end else
            if (TPDFDictionary(O).DictType = 'OCMD') then
            begin
              // We have an optional content membership dictionary
              MCVisible := ProcessOCGMembershipDict(TPDFDictionary(O));
            end;
          end;
        end;
      end;
    end;
  end;

  procedure EndMarkedContent;
  begin
    if MCStack.Count > 0 then
    begin
      MCVisible := MCStack[MCStack.Count - 1] = 'Visible';
      MCStack.Delete(MCStack.Count - 1);
    end else
      MCVisible := True;
  end;

  procedure RenderAnnotations(PreRenderHighlightsOnly: Boolean);
  var
    AX: Integer;
    IsFormField: Boolean;
    IsHighLight: Boolean;
  begin
    Obj := TPDFDictionary(Source).FindValueByKeyName('Annots', False);
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFArray then
    begin
      Annots := TPDFArray(Obj);
      for AX := 0 to Annots.Count - 1 do
      begin
        Obj := Annots.Item[AX];
        if Obj is TPDFIndRef then
        begin
          Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFDictionary then
          begin
            AnnotDict := TPDFDictionary(Obj);
            Obj := AnnotDict.FindValueByKeyName('F');
            if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
            if Obj is TPDFNumeric then
              AnnotFlags := TPDFNumeric(Obj).AsInteger
            else
              AnnotFlags := 0;

            IsHighlight := False;
            Obj := AnnotDict.FindValueByKeyName('Subtype', False);
            if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
            if (Obj is TPDFName) then
              if TPDFName(Obj).Name = 'Highlight' then
                IsHighlight := True;

            Obj := AnnotDict.FindValueByKeyName('FT');
            IsFormField := Obj <> nil;
            RenderFlag := True;

            // Check to see if RenderFormFields is off and we have a formfield.
            if (GDIPlusSettings.RenderFormFields = False) and (IsFormField) then
              RenderFlag := False;

            // Check to see if RenderAnnots is off and we have an annotation.
            if (GDIPlusSettings.RenderAnnotations = False) and (not IsFormField) then
              RenderFlag := False;

            if (GDIPlusSettings.RenderFormFieldsOnly) and (not IsFormField) then
              RenderFlag := False;

{$IFDEF QPL_DPLR}
            if (FDestination <> rdDPLR) and (FDestination <> rdDPLRBitmap) and (FDestination <> rdDPLRMemory) then
            begin
{$ENDIF}
            if PreRenderHighlightsOnly and Not IsHighlight then
              RenderFlag := False;

            if (IsHighLight) and (not PreRenderHighlightsOnly) then
              RenderFlag := False;   // Already rendered.
{$IFDEF QPL_DPLR}
            end;
{$ENDIF}

            if (RenderFlag) then
            begin
              CanvasMat := StartMatrix;
              Picasso.SetCurrentXForm(CanvasMat);

              if (FDestination = rdPrinter)
{$IFDEF QPL_DPLR}
              or (FDestination = rdDPLRPrinter)
{$ENDIF}
              then
              begin
                if ((AnnotFlags and 2) = 0) and ((AnnotFlags and 4) = 4) then
                  DrawAnnot(AnnotDict);
              end
              else
              begin
                if ((AnnotFlags and 2) = 0) and ((AnnotFlags and 32) = 0) then
                  DrawAnnot(AnnotDict);
              end;
              CanvasMat := StartMatrix;
              Picasso.SetCurrentXForm(CanvasMat);
            end;
          end;
        end;
      end;
    end;
  end;

begin
  FErrorDesc := '';

  SetLength(Stack, 100);
  StackSize := 0;

  SetLength(OperandList, 100);
  OperandCount := 0;

  LastFICCProfile := '';
  LastFICCProfileIndObj := -1;

  IgnoreColorCommands := False;

  if Source is TPDFDictionary then
  begin
    if Type3CharProc <> '' then
    begin
      // Source is a Type3 font dictionary
      Obj := TPDFDictionary(Source).FindValueByKeyName('Resources');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then
        Resources := TPDFDictionary(Obj)
      else
        Resources := ParentResources;
    end else
    begin
      // Source is a page object dictionary
      Obj := GetInheritedValue(TPDFDictionary(Source), 'Resources');
      if Obj is TPDFDictionary then
        Resources := TPDFDictionary(Obj)
      else
        Resources := nil;
{$IFDEF QPL_DPLR}
      if (FDestination <> rdDPLR) and (FDestination <> rdDPLRBitmap) and (FDestination <> rdDPLRMemory) then
{$ENDIF}
      RenderAnnotations(True);  // Pre-render Highlight annotations.
    end;

    FStructure := Source.Owner;
  end else
  if Source is TPDFStream then
  begin
    Obj := GetInheritedValue(TPDFStream(Source).Dictionary, 'Resources');
    if Obj is TPDFDictionary then
    begin
      Resources := TPDFDictionary(Obj)
    end else
    begin
      if ((TPDFStream(Source).Dictionary.DictType = 'XObject') or
        (TPDFStream(Source).Dictionary.DictType = '')) then
      begin
        Resources := ParentResources;
      end else
        Resources := nil;
    end;
    FStructure := Source.Owner;
  end;

  S := GetContents;

  MaxLen := Length(S);
  TokPos := 1;
{$IFDEF QPL_OS_WINDOWS}
  LastProgress := -1;
{$ENDIF}

  GS.XPos := 110;
  GS.YPos := 700;
  GS.FillColor := clBlack;
  GS.StrokeColor := clBlack;
  GS.FillColorSpace := 'DeviceGray';
  GS.StrokeColorSpace := 'DeviceGray';

  GS.FillColorEPS := '0 setgray';
  GS.StrokeColorEPS := '0 setgray';

  GS.LineWidth := 1;
  GS.LineCap := 0;
  GS.LineJoin := 0;
  GS.MiterLimit := 10;
  GS.TextScaling := 100;
  GS.TextRise := 0;
  GS.TextSize := 12;
  GS.TextFont := '';
  GS.TextLeading := 0;
  GS.TextRenderingMode := 0;
  GS.StrokeAlpha := 1;
  GS.FillAlpha := 1;
  GS.BlendMode := bmNormal;
  GS.CharSpacing := 0;
  GS.WordSpacing := 0;
  GS.Knockout := False;
  GS.FillPattern := nil;
  GS.StrokePattern := nil;
{$IFDEF QPL_DPLR}
  GS.Softmask := False;
{$ENDIF}

  if FUseInitialState then
  begin
    FUseInitialState := False;
    GS := FInitialState;
  end;

  Mat(GS.TM, 1, 0, 0, 1, 0, 0);
  Mat(GS.TLM, 1, 0, 0, 1, 0, 0);
  ArrayCount := 0;

  InPath := False;
  MCVisible := True;

  Mat(NewMatrix, 1, 0, 0, 1, 0, 0);
  CombinePDFXForm(CanvasMat, NewMatrix, CanvasMat);
  GS.CTM := CanvasMat;

  Picasso.SetCurrentXForm(CanvasMat);

  if (not GDIPlusSettings.RenderFormFieldsOnly) or FDrawingAnnot then
  try
    MCStack := TQuickPDFStringList.Create;
    try
      repeat
        Tok := NextToken;

{$IFDEF QPL_OS_WINDOWS}
        if (MaxLen > 0) then
        begin
          if ((TokPos >= MaxLen) or (TokPos > 21474836)) then
          begin
            NewProgress := 100;
          end else
          begin
            NewProgress := ((TokPos * 100) div MaxLen);
          end;
        end else
        begin
          NewProgress := 0;
        end;
        if (NewProgress > LastProgress) then
        begin
          LastProgress := NewProgress;
          if (GDIPlusSettings.ProgressWindow > 0) then
          begin
            SendMessage(GDIPlusSettings.ProgressWindow, GDIPlusSettings.ProgressMessage,
              GDIPlusSettings.ProgressData, 2000 + NewProgress);
          end;
        end;
{$ENDIF}

        if Tok <> '' then
        begin
          case Tok[1] of
            'b':
            if Tok = 'b' then
            begin
              if FDestination <> rdEPS then
              begin
                SetPen;
                SetFill(pfWinding);
                Picasso.ClosePath;
                if MCVisible then
                begin
{$IFDEF QPL_DPLR}
                  if (FDestination = rdDPLRPrinter) then
                  begin
                    Picasso.GetPathBounds(@GDIPlusRect);
                    if (IsBBoxInPrinterArray(GDIPlusRect.X, GDIPlusRect.Y,
                      GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height) = False) then
                    begin
                      if ((GS.FillAlpha < 1) or (GS.StrokeAlpha < 1) or
                        (GS.BlendMode <> bmNormal) or
                        (GS.Softmask = True) or
                        (QPLStartsWith(GS.FillColorSpace, 'Pattern')) or
                        (QPLStartsWith(GS.StrokeColorSpace, 'Pattern'))) then
                        AddToPrinterBBoxArray(GDIPlusRect.X, GDIPlusRect.Y,
                          GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height)
                      else
                        Picasso.StrokeAndFillPath;
                    end;
                    Picasso.Path := 0;
                  end else
{$ENDIF}
                    Picasso.StrokeAndFillPath;
                end else
                  Picasso.NullPath;
              end else
              begin
                FEPS.PSClosePath;
                if MCVisible then
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  FEPS.PSFill;
                  FEPS.PSSetColor(GS.StrokeColorEPS);
                  FEPS.PSStroke;
                end else
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  FEPS.PSSetColor(GS.StrokeColorEPS);
                  // FEPS.NullPath;
                end;
              end;
              InPath := False;
            end else
            if Tok = 'b*' then
            begin
              if FDestination <> rdEPS then
              begin
                SetPen;
                SetFill(pfAlternate);
                Picasso.ClosePath;
                if MCVisible then
                begin
{$IFDEF QPL_DPLR}
                  if (FDestination = rdDPLRPrinter) then
                  begin
                    Picasso.GetPathBounds(@GDIPlusRect);
                    if (IsBBoxInPrinterArray(GDIPlusRect.X, GDIPlusRect.Y,
                      GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height) = False) then
                    begin
                      if ((GS.FillAlpha < 1) or (GS.StrokeAlpha < 1) or
                        (GS.BlendMode <> bmNormal) or
                        (GS.Softmask = True) or
                        (QPLStartsWith(GS.FillColorSpace, 'Pattern')) or
                        (QPLStartsWith(GS.StrokeColorSpace, 'Pattern'))) then
                        AddToPrinterBBoxArray(GDIPlusRect.X, GDIPlusRect.Y,
                          GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height)
                      else
                        Picasso.StrokeAndFillPath;
                    end;
                    Picasso.Path := 0;
                  end else
{$ENDIF}
                    Picasso.StrokeAndFillPath;
                end else
                  Picasso.NullPath;
              end else
              begin
                FEPS.PSClosePath;
                if MCVisible then
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  FEPS.PSFill(epsFillModeEvenOdd);
                  FEPS.PSSetColor(GS.StrokeColorEPS);
                  FEPS.PSStroke;
                end else
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  FEPS.PSSetColor(GS.StrokeColorEPS);
                  // FEPS.NullPath;
                end;
              end;
              InPath := False;
            end else
              AddOperand(Tok);

            'c':
            if Tok = 'c' then
            begin
              D[6] := PopDouble;
              D[5] := PopDouble;
              D[4] := PopDouble;
              D[3] := PopDouble;
              D[2] := PopDouble;
              D[1] := PopDouble;
{$IFDEF QPL_DPLR}
              if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
              begin
                Picasso.AddBezierToPath(D[1], D[2], D[3], D[4], D[5], D[6]);
                GS.XPos := D[5];
                GS.YPos := D[6];
              end else
{$ENDIF}
              if FDestination <> rdEPS then
              begin
                DP3 := Translate(DoublePoint(D[5], D[6]));
                DP2 := Translate(DoublePoint(D[3], D[4]));
                DP := Translate(DoublePoint(D[1], D[2]));
                Picasso.AddBezierToPath(DP.X, DP.Y, DP2.X, DP2.Y, DP3.X, DP3.Y);
                GS.XPos := DP3.X;
                GS.YPos := DP3.Y;
              end else
                FEPS.PSCurveTo(D[1], D[2], D[3], D[4], D[5], D[6]);
            end else
            if Tok = 'cm' then
            begin
              NewMatrix.eDy := PopDouble;
              NewMatrix.eDx := PopDouble;
              NewMatrix.eM22 := PopDouble;
              NewMatrix.eM21 := PopDouble;
              NewMatrix.eM12 := PopDouble;
              NewMatrix.eM11 := PopDouble;
              if FDestination <> rdEPS then
              begin
                CombinePDFXForm(CanvasMat, NewMatrix, CanvasMat);
                GS.CTM := CanvasMat;
                Picasso.SetCurrentXForm(CanvasMat);
              end else
                FEPS.PSConcat(NewMatrix);
            end else
            if Tok = 'cs' then
            begin
              GS.FillColorSpace := FindColorSpace(PopString);
            end else
              AddOperand(Tok);

            'd':
            if Tok = 'd' then
            begin
              GS.DashPhase := PopDouble;
              SetLength(GS.DashArray, ArrayCount);
              while ArrayCount > 0 do
              begin
                GS.DashArray[ArrayCount - 1] := PopDouble;
                Dec(ArrayCount);
              end;
{$IFDEF QPL_DPLR}
              if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
              begin
                Picasso.SetLineDashDouble(GS.DashArray, GS.DashPhase);
              end;
{$ENDIF}
            end else
            if Tok = 'd1' then
            begin
              IgnoreColorCommands := True;
            end else
              AddOperand(Tok);

            'f':
            if Tok = 'f' then
            begin
              if FDestination <> rdEPS then
              begin
                SetFill(pfWinding);
                if MCVisible then
                begin
{$IFDEF QPL_DPLR}
                  if (FDestination = rdDPLRPrinter) then
                  begin
                    Picasso.GetPathBounds(@GDIPlusRect);
                    if (IsBBoxInPrinterArray(GDIPlusRect.X, GDIPlusRect.Y,
                      GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height) = False) then
                    begin
                      if ((GS.FillAlpha < 1) or
                        (GS.BlendMode <> bmNormal) or
                        (GS.Softmask = True) or
                        (QPLStartsWith(GS.FillColorSpace, 'Pattern'))) then
                        AddToPrinterBBoxArray(GDIPlusRect.X, GDIPlusRect.Y,
                          GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height)
                      else
                        Picasso.FillPath;
                    end;
                    Picasso.Path := 0;
                  end else
  {$ENDIF}
                    Picasso.FillPath;
                end else
                  Picasso.NullPath;
              end else
              begin
                if MCVisible then
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  FEPS.PSFill;
                end else
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  // FEPS.NullPath;
                end;
              end;
              InPath := False;
            end else
            if Tok = 'f*' then
            begin
              if FDestination <> rdEPS then
              begin
                SetFill(pfAlternate);
                if MCVisible then
                begin
{$IFDEF QPL_DPLR}
                  if (FDestination = rdDPLRPrinter) then
                  begin
                    Picasso.GetPathBounds(@GDIPlusRect);
                    if (IsBBoxInPrinterArray(GDIPlusRect.X, GDIPlusRect.Y,
                      GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height) = False) then
                    begin
                      if ((GS.FillAlpha < 1) or
                        (GS.BlendMode <> bmNormal) or
                        (GS.Softmask = True) or
                        (QPLStartsWith(GS.FillColorSpace, 'Pattern'))) then
                        AddToPrinterBBoxArray(GDIPlusRect.X, GDIPlusRect.Y,
                          GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height)
                      else
                        Picasso.FillPath;
                    end;
                    Picasso.Path := 0;
                  end else
{$ENDIF}
                    Picasso.FillPath;
                end else
                  Picasso.NullPath;
              end else
              begin
                if MCVisible then
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  FEPS.PSFill(epsFillModeEvenOdd);
                end else
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  // FEPS.NullPath;
                end;
              end;
              InPath := False;
            end else
              AddOperand(Tok);

            'g':
            if Tok = 'g' then
            begin
              GS.FillColorSpace := 'DeviceGray';
              SetFillColor;
            end else
            if Tok = 'gs' then
            begin
              FindGraphicsState(PopString);
            end else
              AddOperand(Tok);

            'h':
            if Tok = 'h' then
            begin
              Picasso.ClosePath;
            end else
              AddOperand(Tok);

            'j':
            if Tok = 'j' then
            begin
              if FDestination <> rdEPS then
                GS.LineJoin := Round(PopDouble)
              else
                FEPS.PSSetLineJoin(TPDFEPSLineJoin(Round(PopDouble)));
            end else
              AddOperand(Tok);

            'k':
            if Tok = 'k' then
            begin
              GS.FillColorSpace := 'DeviceCMYK';
              SetFillColor;
            end else
              AddOperand(Tok);

            'l':
            if Tok = 'l' then
            begin
              D[2] := PopDouble;
              D[1] := PopDouble;
{$IFDEF QPL_DPLR}
              if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
              begin
                // We have a single dot
                if ((D[1] = GS.XPos) and (D[2] = GS.YPos)) then
                  // TODO
                  Picasso.AddLineToPath(D[1] - GS.LineWidth * 0.01, D[2] - GS.LineWidth * 0.01)
                else
                  Picasso.AddLineToPath(D[1], D[2]);
                GS.XPos := D[1];
                GS.YPos := D[2];
              end else
{$ENDIF}
              if FDestination <> rdEPS then
              begin
                DP := Translate(DoublePoint(D[1], D[2]));
                if ((DP.X = GS.XPos) and (DP.Y = GS.YPos)) then
                begin
                  // We have a single dot
                  Picasso.AddLineToPath(DP.X - GS.LineWidth * 0.01,
                    DP.Y - GS.LineWidth * 0.01);
                end else
                begin
                  Picasso.AddLineToPath(DP.X, DP.Y);
                end;
                GS.XPos := DP.X;
                GS.YPos := DP.Y;
              end else
                FEPS.PSLineTo(D[1], D[2]);
            end else
              AddOperand(Tok);

            'm':
            if Tok = 'm' then
            begin
              if not InPath then
              begin
                InPath := True;
                if FDestination <> rdEPS then
                begin
                  Picasso.BeginPath;
                end else
                  FEPS.PSNewPath;
              end;
              D[2] := PopDouble;
              D[1] := PopDouble;
{$IFDEF QPL_DPLR}
              if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
              begin
                Picasso.MoveTo(D[1], D[2]);
                GS.XPos := D[1];
                GS.YPos := D[2];
              end else
{$ENDIF}
              if FDestination <> rdEPS then
              begin
                DP := Translate(DoublePoint(D[1], D[2]));
                Picasso.MoveTo(DP.X, DP.Y);
                GS.XPos := DP.X;
                GS.YPos := DP.Y;
              end else
                FEPS.PSMoveTo(D[1], D[2]);
            end else
              AddOperand(Tok);

            'n':
            if Tok = 'n' then
            begin
              Picasso.NullPath;
              InPath := False;
            end else
              AddOperand(Tok);

            'q':
            if Tok = 'q' then
            begin
              SaveState;
            end else
              AddOperand(Tok);

            'r':
            if Tok = 're' then
            begin
              if not InPath then
              begin
                InPath := True;
                if FDestination <> rdEPS then
                begin
                  Picasso.BeginPath;
                end else
                  FEPS.PSNewPath;
              end;
              D[4] := PopDouble;
              D[3] := PopDouble;
              D[2] := PopDouble;
              D[1] := PopDouble;
{$IFDEF QPL_DPLR}
              if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
              begin
                Picasso.MoveTo(D[1], D[2]);
                GS.XPos := D[1];
                GS.YPos := D[2];
                Picasso.AddLineToPath(D[1] + D[3], D[2]);
                Picasso.AddLineToPath(D[1] + D[3], D[2] + D[4]);
                Picasso.AddLineToPath(D[1], D[2] + D[4]);
                Picasso.ClosePath;
              end else
{$ENDIF}
              if FDestination <> rdEPS then
              begin
                DP := Translate(DoublePoint(D[1], D[2]));
                Picasso.MoveTo(DP.X, DP.Y);
                GS.XPos := DP.X;
                GS.YPos := DP.Y;
                DP := Translate(DoublePoint(D[1] + D[3], D[2]));
                Picasso.AddLineToPath(DP.X, DP.Y);
                DP := Translate(DoublePoint(D[1] + D[3], D[2] + D[4]));
                Picasso.AddLineToPath(DP.X, DP.Y);
                DP := Translate(DoublePoint(D[1], D[2] + D[4]));
                Picasso.AddLineToPath(DP.X, DP.Y);
                Picasso.ClosePath;
              end else
              begin
                FEPS.PSMoveTo(D[1], D[2]);
                FEPS.PSLineTo(D[1] + D[3], D[2]);
                FEPS.PSLineTo(D[1] + D[3], D[2] + D[4]);
                FEPS.PSLineTo(D[1], D[2] + D[4]);
                FEPS.PSClosePath;
              end;
            end else
            if Tok = 'rg' then
            begin
              GS.FillColorSpace := 'DeviceRGB';
              SetFillColor;
            end else
            if (Tok = 'ri') then
            begin
              PopString;  //  We won't process this tag for now
            end else
              AddOperand(Tok);

            's':
            if Tok = 's' then
            begin
              if FDestination <> rdEPS then
              begin
                SetPen;
                Picasso.ClosePath;
                if MCVisible then
                begin
{$IFDEF QPL_DPLR}
                  if (FDestination = rdDPLRPrinter) then
                  begin
                    Picasso.GetPathBounds(@GDIPlusRect);
                    if (IsBBoxInPrinterArray(GDIPlusRect.X, GDIPlusRect.Y,
                      GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height) = False) then
                    begin
                      if ((GS.StrokeAlpha < 1) or
                        (GS.BlendMode <> bmNormal) or
                        (GS.Softmask = True) or
                        (QPLStartsWith(GS.StrokeColorSpace, 'Pattern'))) then
                        AddToPrinterBBoxArray(GDIPlusRect.X, GDIPlusRect.Y,
                          GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height)
                      else
                        Picasso.StrokePath;
                    end;
                    Picasso.Path := 0;
                  end else
{$ENDIF}
                    Picasso.StrokePath;
                end else
                  Picasso.NullPath;
              end else
              begin
                if MCVisible then
                begin
                  FEPS.PSSetColor(GS.StrokeColorEPS);
                  FEPS.PSClosePath;
                  FEPS.PSStroke;
                end else
                begin
                  FEPS.PSSetColor(GS.StrokeColorEPS);
                  FEPS.PSClosePath;
                  // FEPS.NullPath;
                end;
              end;
              InPath := False;
            end else
            if Tok = 'sc' then
            begin
              SetFillColor;
            end else
            if Tok = 'scn' then
            begin
              if (QPLStartsWith(GS.FillColorSpace, 'Pattern')) then
              begin
                if (QPLPos(':', GS.FillColorSpace) > 0) then
                begin
                  Delete(GS.FillColorSpace, QPLPos(':', GS.FillColorSpace), MaxInt);
                end;
                GS.FillColorSpace := GS.FillColorSpace + ':' + PopString;
              end;
              SetFillColor;
            end else
            if Tok = 'sh' then
            begin
{$IFDEF QPL_DPLR}
              if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
              begin
                GS.FillColorSpace := 'Pattern:' + PopString;
                SetFillColor;
                SetFill(pfWinding);
                if MCVisible then
                begin
                  Picasso.DrawShading;
                end;
              end else
{$ENDIF}
              begin
                GS.FillColorSpace := 'Pattern:' + PopString;
                SetFillColor;
                SetFill(pfWinding);
                if MCVisible then
                begin
{$IFDEF QPL_DPLR}
                  if (FDestination = rdDPLRPrinter) then
                  begin
                    Picasso.GDIPlus.GdipGetVisibleClipBounds(Picasso.Graphics, @GDIPlusRect);
                    if (IsBBoxInPrinterArray(GDIPlusRect.X, GDIPlusRect.Y,
                      GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height) = False) then
                    begin
                      if ((GS.FillAlpha < 1) or
                        (GS.BlendMode <> bmNormal) or
                        (GS.Softmask = True) or
                        (QPLStartsWith(GS.FillColorSpace, 'Pattern'))) then
                      begin
                        // TODO - intersect with shading bBox
                        AddToPrinterBBoxArray(GDIPlusRect.X, GDIPlusRect.Y,
                          GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height);
                      end else
                        Picasso.FillClippingPath;
                    end;
                    Picasso.Path := 0;
                  end else
{$ENDIF}
                    Picasso.FillClippingPath;
                end;
              end;
            end else
              AddOperand(Tok);

            'v':
            if Tok = 'v' then
            begin
              D[4] := PopDouble;
              D[3] := PopDouble;
              D[2] := PopDouble;
              D[1] := PopDouble;
{$IFDEF QPL_DPLR}
              if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
              begin
                Picasso.AddBezierToPath(GS.XPos, GS.YPos, D[1], D[2], D[3], D[4]);
                GS.XPos := D[3];
                GS.YPos := D[4];
              end else
{$ENDIF}
              if FDestination <> rdEPS then
              begin
                DP3 := Translate(DoublePoint(D[3], D[4]));
                DP2 := Translate(DoublePoint(D[1], D[2]));
                DP.X := GS.XPos;
                DP.Y := GS.YPos;
                Picasso.AddBezierToPath(DP.X, DP.Y, DP2.X, DP2.Y, DP3.X, DP3.Y);
                GS.XPos := DP3.X;
                GS.YPos := DP3.Y;
              end else
                FEPS.PSCurveToV(D[1], D[2], D[3], D[4]);
            end else
              AddOperand(Tok);

            'w':
            if Tok = 'w' then
            begin
{$IFDEF QPL_DPLR}
              if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
              begin
                GS.LineWidth := PopDouble;
                if GS.LineWidth > 1000 then
                  GS.LineWidth := 1;
              end else
{$ENDIF}
              if FDestination <> rdEPS then
              begin
                GS.LineWidth := PopDouble;
                if GS.LineWidth = 0 then
                  GS.LineWidth := 1; //DPL-459 * 72 / FDPI;  // Set to 1 pixel
                if GS.LineWidth > 1000 then
                  GS.LineWidth := 1;
              end else
                FEPS.PSSetLineWidth(PopDouble);
            end else
              AddOperand(Tok);

            'y':
            if Tok = 'y' then
            begin
              D[4] := PopDouble;
              D[3] := PopDouble;
              D[2] := PopDouble;
              D[1] := PopDouble;
{$IFDEF QPL_DPLR}
              if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
              begin
                Picasso.AddBezierToPath(D[1], D[2], D[3], D[4], D[3], D[4]);
                GS.XPos := D[3];
                GS.YPos := D[4];
              end else
{$ENDIF}
              if FDestination <> rdEPS then
              begin
                DP3 := Translate(DoublePoint(D[3], D[4]));
                DP2 := Translate(DoublePoint(D[3], D[4]));
                DP := Translate(DoublePoint(D[1], D[2]));
                Picasso.AddBezierToPath(DP.X, DP.Y, DP2.X, DP2.Y, DP3.X, DP3.Y);
                GS.XPos := DP3.X;
                GS.YPos := DP3.Y;
              end else
                FEPS.PSCurveToY(D[1], D[2], D[3], D[4]);
            end else
              AddOperand(Tok);

            'B':
            if Tok = 'B' then
            begin
              if FDestination <> rdEPS then
              begin
                SetPen;
                SetFill(pfWinding);
                if MCVisible then
                begin
{$IFDEF QPL_DPLR}
                  if (FDestination = rdDPLRPrinter) then
                  begin
                    Picasso.GetPathBounds(@GDIPlusRect);
                    if (IsBBoxInPrinterArray(GDIPlusRect.X, GDIPlusRect.Y,
                      GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height) = False) then
                    begin
                      if (GS.FillAlpha < 1) or (GS.StrokeAlpha < 1) or
                        (GS.BlendMode <> bmNormal) or
                        (GS.Softmask = True) or
                        (QPLStartsWith(GS.FillColorSpace, 'Pattern')) or
                        (QPLStartsWith(GS.StrokeColorSpace, 'Pattern')) then
                        AddToPrinterBBoxArray(GDIPlusRect.X, GDIPlusRect.Y,
                          GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height)
                      else
                        Picasso.StrokeAndFillPath;
                    end;
                    Picasso.Path := 0;
                 end else
{$ENDIF}
                    Picasso.StrokeAndFillPath;
                end else
                  Picasso.NullPath;
              end else
              begin
                if MCVisible then
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  FEPS.PSFill;
                  FEPS.PSSetColor(GS.StrokeColorEPS);
                  FEPS.PSStroke;
                end else
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  FEPS.PSSetColor(GS.StrokeColorEPS);
                  // FEPS.NullPath;
                end;
              end;
              InPath := False;
            end else
            if Tok = 'B*' then
            begin
              if FDestination <> rdEPS then
              begin
                SetPen;
                SetFill(pfAlternate);
                if MCVisible then
                begin
{$IFDEF QPL_DPLR}
                  if (FDestination = rdDPLRPrinter) then
                  begin
                    Picasso.GetPathBounds(@GDIPlusRect);
                    if (IsBBoxInPrinterArray(GDIPlusRect.X, GDIPlusRect.Y,
                      GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height) = False) then
                    begin
                      if ((GS.FillAlpha < 1) or (GS.StrokeAlpha < 1) or
                        (GS.BlendMode <> bmNormal) or
                        (GS.Softmask = True) or
                        (QPLStartsWith(GS.FillColorSpace, 'Pattern')) or
                        (QPLStartsWith(GS.StrokeColorSpace, 'Pattern'))) then
                        AddToPrinterBBoxArray(GDIPlusRect.X, GDIPlusRect.Y,
                          GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height)
                      else
                        Picasso.StrokeAndFillPath;
                    end;
                    Picasso.Path := 0;
                  end else
{$ENDIF}
                    Picasso.StrokeAndFillPath;
                end else
                  Picasso.NullPath;
              end else
              begin
                if MCVisible then
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  FEPS.PSFill(epsFillModeEvenOdd);
                  FEPS.PSSetColor(GS.StrokeColorEPS);
                  FEPS.PSStroke;
                end else
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  FEPS.PSSetColor(GS.StrokeColorEPS);
                  // FEPS.NullPath;
                end;
              end;
              InPath := False;
            end else
            if Tok = 'BI' then
            begin
              if DecodeInlineImage(S, TokPos, InlineImage, Resources, FOnFindObject) then
              begin
                if (FDestination <> rdTextFunnel) then
                begin
                  InlineImage.ColorSpaceObj :=
                    FindColorSpaceResource(InlineImage.ColorSpace);
                  InlineID := TPDFImageDecoder.Create;
                  try
{$IFDEF QPL_DPLR}
                    if ((FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory)) then   //FB21052
                    begin
                      InlineID.DecodeMode := dmToDPLR;
                      InlineID.DPLRPicasso := Picasso;
                    end;
{$ENDIF}

                    InlineID.SetColorManager(FColorManager);
                    InlineID.OnFindObject := FOnFindObject;

                    InlineID.RenderToEPS := FDestination = rdEPS;

                    InlineID.IgnoreICCProfiles := FGDIPlusSettings.IgnoreICCProfiles;
                    InlineID.LastFICCProfile := LastFICCProfile;
                    InlineID.LastFICCProfileIndObj := LastFICCProfileIndObj;

                    InlineID.LoadFromInlineImage(InlineImage, Resources.Owner);

                    if (LastFICCProfile <> InlineID.LastFICCProfile) then
                    begin
                      LastFICCProfile := InlineID.LastFICCProfile;
                      LastFICCProfileIndObj := InlineID.LastFICCProfileIndObj;
                    end;

                    if (FDestination = rdImageList) then
                    begin
                      if InlineID.NativeType = nitTIFF then
                      begin
                        ImageListItem.ImageType := nitTIFF;
                        ImageListItem.ImageData := InlineID.NativeImageData;
                      end else
                      if InlineID.NativeType = nitJPEG then
                      begin
                        ImageListItem.ImageType := nitJPEG;
                        ImageListItem.ImageData := InlineID.NativeImageData;
                      end else
                      if InlineID.NativeType = nitPNG then
                      begin
                        ImageListItem.ImageType := nitPNG;
                        ImageListItem.ImageData := InlineID.NativeImageData;
                      end else
                      begin
                        ImageListItem.ImageType := nitBMP;
                        ImageListItem.ImageData := InlineID.NativeImageData;
                      end;
                      ImageListItem.PixelWidth := InlineID.Width;
                      ImageListItem.PixelHeight := InlineID.Height;

                      TP1.X := 0;
                      TP1.Y := 1;
                      TP2.X := 1;
                      TP2.Y := 1;
                      TP3.X := 1;
                      TP3.Y := 0;
                      TP4.X := 0;
                      TP4.Y := 0;
                      TP1 := DoPDFXForm(CanvasMat, TP1);
                      TP2 := DoPDFXForm(CanvasMat, TP2);
                      TP3 := DoPDFXForm(CanvasMat, TP3);
                      TP4 := DoPDFXForm(CanvasMat, TP4);

                      ImageListItem.Corners[icTopLeft] := TP1;
                      ImageListItem.Corners[icTopRight] := TP2;
                      ImageListItem.Corners[icBottomRight] := TP3;
                      ImageListItem.Corners[icBottomLeft] := TP4;

                      ImageListItem.ColorSpaceType := -1;
                      ImageListItem.BitsPerPixel := -1;

                      if (InlineID.ColorSpace = '') and (InlineID.BitsPerComponent = 1) then
                      begin
                        ImageListItem.ColorSpaceType := 1;
                        ImageListItem.BitsPerPixel := InlineID.BitsPerComponent;
                      end else
                      if (InlineID.ColorSpace = 'DeviceGray') then
                      begin
                        ImageListItem.ColorSpaceType := 1;
                        ImageListItem.BitsPerPixel := InlineID.BitsPerComponent;
                      end else
                      if (InlineID.ColorSpace = 'DeviceRGB') then
                      begin
                        ImageListItem.ColorSpaceType := 2;
                        ImageListItem.BitsPerPixel := InlineID.BitsPerComponent * 3;
                      end else
                      if (InlineID.ColorSpace = 'DeviceCMYK') then
                      begin
                        ImageListItem.ColorSpaceType := 3;
                        ImageListItem.BitsPerPixel := InlineID.BitsPerComponent * 4;
                      end else
                      begin
                        ImageListItem.ColorSpaceType := 2;
                        ImageListItem.BitsPerPixel := InlineID.BitsPerComponent * 3;

                        ImageListItem.ImageType := nitBMP;
                        ImageListItem.ImageData := InlineID.BitmapAsString;
                      end;

                      ImageListItem.ImageRef := nil;
                      FImageList.AddImage(ImageListItem);
                    end
                    else
                    if FDestination <> rdEPS then
                    begin
{$IFDEF QPL_DPLR}
                      //FB21052
                      if FDestination = rdDPLRPrinter then
                      begin
                        TP2.X := 1;
                        TP2.Y := 1;
                        TP4.X := 0;
                        TP4.Y := 0;
                        TP2 := DoPDFXForm(CanvasMat, TP2);
                        TP4 := DoPDFXForm(CanvasMat, TP4);
                        if (IsBBoxInPrinterArray(TP4.X, TP4.Y, TP2.X, TP2.Y) = False) then
                        begin
                          if ((GS.FillAlpha < 1) or
                            (GS.BlendMode <> bmNormal) or
                            (GS.Softmask = True) or
                            (InlineID.MaskType = mtStencil)) then
                            AddToPrinterBBoxArray(TP4.X, TP4.Y, TP2.X, TP2.Y)
                          else
                            Picasso.SetCurrentXForm(CanvasMat);
                            InlineID.Draw(Picasso, CanvasMat, GS.FillColor);
                        end;
                      end else
{$ENDIF}
                      begin
                        // Pass in the current transformation matrix for Cairo/DPLR
                        Picasso.SetCurrentXForm(CanvasMat);
                        InlineID.Draw(Picasso, CanvasMat, GS.FillColor);
                      end;
                    end else
                      FEPS.PSImageFromBitmap(InlineID.Bitmap, InlineID.MaskBitmap, 'Inline' + QPLIntToStr(TokPos), InlineID.MaskType = mtStencil);
                  finally
                    InlineID.Free;
                  end;
                end;
              end;
            end else
            if Tok = 'BT' then
            begin
              Mat(GS.TM, 1, 0, 0, 1, 0, 0);
              Mat(GS.TLM, 1, 0, 0, 1, 0, 0);
{$IFDEF QPL_DPLR}
              if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
              begin
                Picasso.RendererDLL.DPLR_clear_text_clip(Picasso.RendererHandle);
              end;
{$ENDIF}
            end else
            if (Tok = 'BDC') then
            begin
              MCProp := PopString;
              MCTag := PopString;
              BeginMarkedContent(MCTag, MCProp);
            end else
            if (Tok = 'BMC') then
            begin
              MCProp := '';
              MCTag := PopString;
              BeginMarkedContent(MCTag, MCProp);
            end else
              AddOperand(Tok);

            'C':
            if Tok = 'CS' then
            begin
              GS.StrokeColorSpace := FindColorSpace(PopString);
            end else
              AddOperand(Tok);

            'D':
            if Tok = 'Do' then
            begin
              DrawXObject(PopString);
            end else
              AddOperand(Tok);

            'E':
            if Tok = 'EMC' then
            begin
              EndMarkedContent;
            end else
{$IFDEF QPL_DPLR}
            if Tok = 'ET' then
            begin
              if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
              begin
                if GS.TextRenderingMode >= 4 then
                  Picasso.RendererDLL.DPLR_set_text_clip(Picasso.RendererHandle);
              end;
            end else
{$ENDIF}
              AddOperand(Tok);

            'F':
            if Tok = 'F' then
            begin
              if FDestination <> rdEPS then
              begin
                SetFill(pfWinding);
                if MCVisible then
                begin
{$IFDEF QPL_DPLR}
                  if (FDestination = rdDPLRPrinter) then
                  begin
                    Picasso.GetPathBounds(@GDIPlusRect);
                    if (IsBBoxInPrinterArray(GDIPlusRect.X, GDIPlusRect.Y,
                      GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height) = False) then
                    begin
                      if ((GS.FillAlpha < 1) or
                        (GS.BlendMode <> bmNormal) or
                        (GS.Softmask = True) or
                        (QPLStartsWith(GS.FillColorSpace, 'Pattern'))) then
                        AddToPrinterBBoxArray(GDIPlusRect.X, GDIPlusRect.Y,
                          GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height)
                      else
                        Picasso.FillPath;
                    end;
                    Picasso.Path := 0;
                  end else
{$ENDIF}
                    Picasso.FillPath;
                end else
                  Picasso.NullPath;
              end else
              begin
                if MCVisible then
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  FEPS.PSFill;
                end else
                begin
                  FEPS.PSSetColor(GS.FillColorEPS);
                  // FEPS.NullPath;
                end;
              end;
              InPath := False;
            end else
              AddOperand(Tok);

            'G':
            if Tok = 'G' then
            begin
              GS.StrokeColorSpace := 'DeviceGray';
              SetStrokeColor;
            end else
              AddOperand(Tok);

            'J':
            if Tok = 'J' then
            begin
              if FDestination <> rdEPS then
                GS.LineCap := Round(PopDouble)
              else
                FEPS.PSSetLineCap(TPDFEPSLineCap(Round(PopDouble)));
            end else
              AddOperand(Tok);

            'K':
            if Tok = 'K' then
            begin
              GS.StrokeColorSpace := 'DeviceCMYK';
              SetStrokeColor;
            end else
              AddOperand(Tok);

            'M':
            if Tok = 'M' then
            begin
              if FDestination <> rdEPS then
              begin
                GS.MiterLimit := PopDouble;
              end else
                FEPS.PSSetMiterLimit(PopDouble);
            end else
              AddOperand(Tok);

            'Q':
            if Tok = 'Q' then
            begin
              RestoreState;
            end else
              AddOperand(Tok);

            'R':
            if Tok = 'RG' then
            begin
              GS.StrokeColorSpace := 'DeviceRGB';
              SetStrokeColor;
            end else
              AddOperand(Tok);

            'S':
            if Tok = 'S' then
            begin
              if FDestination <> rdEPS then
              begin
                SetPen;
                if MCVisible then
                begin
{$IFDEF QPL_DPLR}
                  if (FDestination = rdDPLRPrinter) then
                  begin
                    Picasso.GetPathBounds(@GDIPlusRect);
                    if (IsBBoxInPrinterArray(GDIPlusRect.X, GDIPlusRect.Y,
                      GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height) = False) then
                    begin
                      if ((GS.StrokeAlpha < 1) or
                        (GS.BlendMode <> bmNormal) or
                        (GS.Softmask = True) or
                        (QPLStartsWith(GS.StrokeColorSpace, 'Pattern'))) then
                        AddToPrinterBBoxArray(GDIPlusRect.X, GDIPlusRect.Y,
                          GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height)
                      else
                        Picasso.StrokePath;
                    end;
                    Picasso.Path := 0;
                  end else
{$ENDIF}
                    Picasso.StrokePath;
                end else
                  Picasso.NullPath;
              end else
              begin
                if MCVisible then
                begin
                  FEPS.PSSetColor(GS.StrokeColorEPS);
                  FEPS.PSStroke;
                end else
                begin
                  FEPS.PSSetColor(GS.StrokeColorEPS);
                  // FEPS.NullPath;
                end;
              end;
              InPath := False;
            end else
            if Tok = 'SC' then
            begin
              SetStrokeColor;
            end else
            if Tok = 'SCN' then
            begin
              if (QPLStartsWith(GS.StrokeColorSpace, 'Pattern')) then
              begin
                if (QPLPos(':', GS.StrokeColorSpace) > 0) then
                begin
                  Delete(GS.StrokeColorSpace, QPLPos(':', GS.StrokeColorSpace), MaxInt);
                end;
                GS.StrokeColorSpace := GS.StrokeColorSpace + ':' + PopString;
              end;
              SetStrokeColor;
            end else
              AddOperand(Tok);

            'T':
            if Tok = 'Tf' then
            begin
              GS.TextSize := PopDouble;
              GS.TextFont := PopString;
              SelectFont;
            end else
            if Tok = 'Tm' then
            begin
              D[6] := PopDouble;
              D[5] := PopDouble;
              D[4] := PopDouble;
              D[3] := PopDouble;
              D[2] := PopDouble;
              D[1] := PopDouble;
              Mat(GS.TM, D[1], D[2], D[3], D[4], D[5], D[6]);
              Mat(GS.TLM, D[1], D[2], D[3], D[4], D[5], D[6]);
            end else
            if Tok = 'Td' then
            begin
              D[2] := PopDouble;
              D[1] := PopDouble;
              Mat(NewMatrix, 1, 0, 0, 1, D[1], D[2]);
              CombinePDFXForm(GS.TLM, NewMatrix, GS.TLM);
              GS.TM := GS.TLM;
            end else
            if Tok = 'TD' then
            begin
              D[2] := PopDouble;
              D[1] := PopDouble;
              GS.TextLeading := -D[2];
              Mat(NewMatrix, 1, 0, 0, 1, D[1], D[2]);
              CombinePDFXForm(GS.TLM, NewMatrix, GS.TLM);
              GS.TM := GS.TLM;
            end else
            if Tok = 'T*' then
            begin
              Mat(NewMatrix, 1, 0, 0, 1, 0, -GS.TextLeading);
              CombinePDFXForm(GS.TLM, NewMatrix, GS.TLM);
              GS.TM := GS.TLM;
            end else
            if Tok = 'Tz' then
            begin
              GS.TextScaling := PopDouble;
            end else
            if Tok = 'Ts' then
            begin
              GS.TextRise := PopDouble;
            end else
            if Tok = 'Tr' then
            begin
              GS.TextRenderingMode := Round(PopDouble);
            end else
            if Tok = 'Tc' then
            begin
              GS.CharSpacing := PopDouble;
            end else
            if Tok = 'Tw' then
            begin
              GS.WordSpacing := PopDouble;
            end else
            if Tok = 'TL' then
            begin
              GS.TextLeading := PopDouble;
            end else
            if Tok = 'Tj' then
            begin
              ArrayCount := 1;
              if FDestination <> rdTextFunnel then
                ShowText
              else
                ExtractText;
            end else
            if Tok = 'TJ' then
            begin
              if ArrayCount > 0 then
              begin
                if FDestination <> rdTextFunnel then
                  ShowText
                else
                  ExtractText;
              end;
            end else
              AddOperand(Tok);

            'W':
            if Tok = 'W' then
            begin
              if FDestination <> rdEPS then
                Picasso.SetClippingPath(pfWinding)
              else
                FEPS.PSClip;
            end else
            if Tok = 'W*' then
            begin
              if FDestination <> rdEPS then
                Picasso.SetClippingPath(pfAlternate)
              else
                FEPS.PSClip(epsFillModeEvenOdd);
            end else
              AddOperand(Tok);

            '''':
            if Tok = '''' then
            begin
              Mat(NewMatrix, 1, 0, 0, 1, 0, -GS.TextLeading);
              CombinePDFXForm(GS.TLM, NewMatrix, GS.TLM);
              GS.TM := GS.TLM;
              ArrayCount := 1;
              if FDestination <> rdTextFunnel then
                ShowText
              else
                ExtractText;
            end else
              AddOperand(Tok);

            '"':
            if Tok = '"' then
            begin
              Mat(NewMatrix, 1, 0, 0, 1, 0, -GS.TextLeading);
              CombinePDFXForm(GS.TLM, NewMatrix, GS.TLM);
              GS.TM := GS.TLM;
              Str := PopString;
              GS.CharSpacing := PopDouble;
              GS.WordSpacing := PopDouble;
              AddOperand(Str);
              ArrayCount := 1;
              if FDestination <> rdTextFunnel then
                ShowText
              else
                ExtractText;
            end else
              AddOperand(Tok);

            '[':
            if Tok = '[' then
            begin
              ArrayCount := 0;
              repeat
                Str := NextToken;
                if Str <> ']' then
                begin
                  AddOperand(Str);
                  Inc(ArrayCount);
                end;
              until (Str = ']') or (Str = '');
            end else
              AddOperand(Tok);
          else
            AddOperand(Tok);
          end;
        end;
      until Tok = '';

    finally
      MCStack.Free;
    end;
  except
    on E: Exception do
      FErrorDesc := 'Rendering exception: ' + AnsiString(E.Message) + #13#10 +
        'Token position ' + QPLIntToStr(TokPos);
  end;

{$IFDEF QPL_DPLR}
  if (FDestination = rdDPLR) or (FDestination = rdDPLRBitmap) or (FDestination = rdDPLRMemory) then
  begin
    if (Source is TPDFDictionary) then
    begin
      RenderAnnotations(True);
    end;
  end else
{$ENDIF}
  if (ErrorDesc = '') and (Source is TPDFDictionary) then
    RenderAnnotations(False);
end;

function TPDFRenderer.Translate(P1: TPDFDoublePoint): TPDFDoublePoint;
begin
  Result.X := CanvasMat.eM11 * P1.X + CanvasMat.eM21 * P1.Y + CanvasMat.eDx;
  Result.Y := CanvasMat.eM12 * P1.X + CanvasMat.eM22 * P1.Y + CanvasMat.eDy;
end;

function TPDFRenderer.TranslateUsing(P1: TPDFDoublePoint;
  Mat: TPDFXForm): TPDFDoublePoint;
begin
  Result.X := Mat.eM11 * P1.X + Mat.eM21 * P1.Y + Mat.eDx;
  Result.Y := Mat.eM12 * P1.X + Mat.eM22 * P1.Y + Mat.eDy;
end;

end.
