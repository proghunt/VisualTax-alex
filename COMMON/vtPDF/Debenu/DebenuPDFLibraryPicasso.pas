{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryPicasso.pas                            }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryPicasso;

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
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  DebenuPDFLibraryGDIPlus, Classes, DebenuPDFLibraryPNG,
{$IFDEF QPL_OS_WINDOWS}
  ActiveX,
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  Types,
  Macapi.CocoaTypes,
{$ENDIF}
{$IFDEF QPL_CAIRO}
  DebenuPDFLibraryCairo,
{$ENDIF}
{$IFDEF QPL_DPLR}
  DebenuPDFLibraryDPLR,
{$ENDIF}
  DebenuPDFLibraryGenericCanvas, DebenuPDFLibraryMatrix, DebenuPDFLibraryExtra, DebenuPDFLibraryTypes,
  DebenuPDFLibraryPatterns, DebenuPDFLibraryPrinting;

type
  TGDIPlusDLLStartup = (dsNever, dsNotIfPiggyback, dsAlways);

  TDPLImagePrintMode = (pmNormal, pmOptimizeImages);

  TDPLPathCombineMode = (cmNormalPaths, cmCombinePaths);

  TGDIPlusSettings = record
    FileName: WideString;
    Smoothing: Boolean;
    UseGDIPlus: Boolean;
    AccurateInterpolation: Boolean;
    SmoothImages: Boolean;
    ProcessNullPath: Boolean;
    MonoThreshold: Integer;
    DLLSuppressBackgroundThread: Boolean;
    DLLAllowPiggyBack: Boolean;
    DLLStartup: TGDIPlusDLLStartup;

    UpdateAppearanceStreams: Integer;
    RenderFormFields: Boolean;
    RenderAnnotations: Boolean;
    UseGammaCorrection: Boolean;
    IgnoreICCProfiles: Boolean;
    RenderFormFieldsOnly: Boolean;
    IsPrinting: Boolean;
    EnhanceThinLines: Integer;
    SmoothingMode: Integer;
    InterpolationMode: Integer;
    PixelOffsetMode: Integer;
    PathCombineMode: TDPLPathCombineMode;
    DirectFonts: Boolean;

{$IFDEF QPL_OS_WINDOWS}
    ProgressWindow: HWND;
{$ELSE}
    ProgressWindow: Integer;
{$ENDIF}
    ProgressMessage: Integer;
    ProgressData: Integer;

    PrintMode: Integer;
  end;

  TPDFPicassoHorzAlign = (haLeft, haCenter, haRight);
  TPDFPicassoVertAlign = (vaTop, vaCenter, vaBottom);
  TPDFPicassoRotateAspect = (raNone, raClockwise, raAntiClockwise);

  TPDFPicassoImageAlign = record
    ShrinkLargeImages: Boolean;
    ExpandSmallImages: Boolean;
    HorizontalAlignment: TPDFPicassoHorzAlign;
    VerticalAlignment: TPDFPicassoVertAlign;
    SmallHorizontalAlignment: TPDFPicassoHorzAlign;
    SmallVerticalAlignment: TPDFPicassoVertAlign;
    RotateMatchAspec: TPDFPicassoRotateAspect;
  end;

{$IFNDEF QPL_OS_WINDOWS}
  TImageBytesStreamAdapter = class
  end;
{$ELSE}
  IImageBytes = interface(IUnknown) ['{025D1823-6C7D-447B-BBDB-A3CBC3DFA2FC}']
    function CountBytes(pcb: PLongint): HResult; stdcall;
    function LockBytes(cb: Longint; ulOffset: Longint; out ppvBytes: Pointer): HResult; stdcall;
    function UnlockBytes(pvBytes: Pointer; cb: Longint; ulOffset: Longint): HResult; stdcall;
  end;

  TImageBytesStreamAdapter = class(TStreamAdapter, IImageBytes)
  private
    LockedBytes: array of AnsiString;
  public
    function CountBytes(pcb: PLongint): HResult; stdcall;
    function LockBytes(cb: Longint; ulOffset: Longint; out ppvBytes: Pointer): HResult; stdcall;
    function UnlockBytes(pvBytes: Pointer; cb: Longint; ulOffset: Longint): HResult; stdcall;
  end;
{$ENDIF}

  TPDFPicassoModel = (pmUnknown, pmGDI, pmGDIPlus, pmHTML5
{$IFDEF QPL_OS_MAC}
    , pmQuartz
{$ENDIF}
{$IFDEF QPL_CAIRO}
    , pmCairo
{$ENDIF}
{$IFDEF QPL_DPLR}
    , pmDPLR
{$ENDIF}
    );

  TPDFDashArray = TGPDashArray;

  TPDFFillMode = (pfUnknown, pfWinding, pfAlternate);

  TPDFPicassoDoubleRect = record
    X1, Y1: Double;
    X2, Y2: Double;
    X3, Y3: Double;
    X4, Y4: Double;
  end;

  TPDFMetafileInfo = record
    UseMetafile: Boolean;
    Width, Height: Integer;
    Adapter: TImageBytesStreamAdapter;
    MetafileHandle: TQPLIntPtr;
    MetafileDC: HDC;
  end;

  TPDFDeviceContextInfo = record
    UseDeviceContext: Boolean;
    Width, Height: Integer;
    TargetDC: HDC;
{$IFDEF QPL_OS_MAC}
    QuartzContext: CGContextRef;
{$ENDIF}
  end;

  TPDFPicasso = class(TPDFGenericCanvas)
  private
    FX: Double;
    FY: Double;
    FSettings: TGDIPlusSettings;
    FFillColor: Cardinal;
    FStrokeColor: Cardinal;
    FLineWidth: Double;
    FLineCapStyle: Integer;
    FLineJoinStyle: Integer;
    FMiterLimit: Double;
    FLineDashArray: TPDFDashArray;
    FLineDashPhase: Double;
{$IFDEF QPL_DPLR}
    FLineDashDoubleArray: array of Double;
    FLineDashDoublePhase: Double;
{$ENDIF}
    FModel: TPDFPicassoModel;
    FGDIPlus: TDQPLGDIPlus;
    FCanvas: TCanvas;
    FStrokeAlpha: Double;
    FFillAlpha: Double;
    FBlendMode: TPDFBlendMode;
    FFillMode: TPDFFillMode;
    FIsClippingPath: Boolean;
    FCustomColors: TQuickPDFStringList;
    FNeedClipRegion: Boolean;
    FLastClipRegion: TQPLIntPtr;
    FFillPattern: TQPLPattern;
    FStrokePattern: TQPLPattern;
    FPageHeight: Double;
    //FRenderOffsetX: Integer;
    //FRenderOffsetY: Integer;

    FMetafileInfo: TPDFMetafileInfo;
    FDeviceContextInfo: TPDFDeviceContextInfo;

    FCurrentXForm: TPDFXForm;

{$IFDEF QPL_OS_MAC}
    // Quartz
    FCanClosePath: Boolean;
{$ENDIF}
    FValidPath: Boolean;

    // GDIPlus
    FGraphics: TQPLIntPtr;
    FToken: TQPLIntPtr;
    FPath: TQPLIntPtr;
    FClipRegions: array of TQPLIntPtr;
    FClipRegionCount: Integer;
    FBMPEncoderGUID: TGUID;
    FPNGEncoderGUID: TGUID;
    FHTML5Target: TStream;
    FGDIPlusCallStartup: Boolean;
    FGDIPlusStartupOutput: TGdiplusStartupOutput;
    FGDIPlusThreadToken: Cardinal;
    FImagePrintMode: TDPLImagePrintMode;
    FPathCombineMode: TDPLPathCombineMode;
    FCombinedPathPoints: array of TGPPointF;
    FCombinedPathPointTypes: array of Byte;
    FCombinedPathPointCount: Integer;

{$IFDEF QPL_CAIRO}
    // Cairo
    FCairoDLL: TCairoDLL;
    FCairoSurface: Pcairo_surface_t;
    FCairoHandle: Pcairo_t;
    FCairoHasBackdrop: Boolean;
    FCairoBackdropSurface: Pcairo_surface_t;
    FCairoBackdropContext: Pcairo_t;
    FCairoPunchSurface: Pcairo_surface_t;
    FCairoPunchContext: Pcairo_t;
{$ENDIF}
{$IFDEF QPL_DPLR}
    FRendererDLL: TDebenuPDFLibraryDPLR;
    FRendererHandle: PDPLR_renderer_t;
    FStartMatrix: TPDFXForm;
{$ENDIF}
    function StrokeColorToARGB: Cardinal;
    function FillColorToARGB: Cardinal;
    procedure CheckPath;
{$IFDEF QPL_OS_WINDOWS}
    function FitImage(TargetLeft, TargetTop, TargetWidth, TargetHeight,
      ImageWidth, ImageHeight: Double; RotateToFit: TPDFPicassoRotateAspect;
      ExpandToFit, ReduceToFit: Boolean; HorzAlign: TPDFPicassoHorzAlign;
      VertAlign: TPDFPicassoVertAlign; SmallHorzAlign: TPDFPicassoHorzAlign;
      SmallVertAlign: TPDFPicassoVertAlign): TPDFPicassoDoubleRect;
    function CreateMetafile(ReferenceHDC: HDC): Boolean;
{$ENDIF}
    function SetupGDIPlusPattern(Pattern: TQPLPattern): TQPLIntPtr;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure UseGDIModel(Canvas: TCanvas);
    procedure UseGDIPlusModel(Canvas: TCanvas; Settings: TGDIPlusSettings);
    procedure UseHTML5Model(Target: TStream);
{$IFDEF QPL_CAIRO}
    procedure UseCairoModel(TargetDC: HDC; const CairoDLL: WideString; EraseBackground: Boolean);
{$ENDIF}
{$IFDEF QPL_DPLR}
    procedure SetupPrivateGDIPlus;
    procedure ReleasePrivateGDIPlus;
    procedure UseRendererModel(TargetDC: HDC; const RendererDLL: WideString;
      EraseBackground: Boolean);
    procedure UseRendererModelMemory(Width, Height: Integer; const RendererDLL: WideString);
    procedure FinishDPLR(TargetDC: HDC);
    procedure FinishDPLRMemory(Target: Pointer; Width, Height, BitsPerPixel: Integer);
{$ENDIF}
    procedure FinishHTML5(Width, Height: Integer);
    procedure HTML5Write(const HTMLCommand: string);
    function HTML5Number(Number: Double): string;
    function HTML5HexColor(Value: Integer): string;
    procedure SetFillColor(Red, Green, Blue: Byte); overload;
    procedure SetFillColor(Color: Cardinal); overload;
    procedure SetFillPattern(Pattern: TQPLPattern);
    procedure SetStrokeColor(Red, Green, Blue: Byte); overload;
    procedure SetStrokeColor(Color: Cardinal); overload;
    procedure SetStrokePattern(Pattern: TQPLPattern);
    procedure SetLineWidth(NewWidth: Double);
    procedure SetLineCapStyle(Style: Integer);
    procedure SetLineJoinStyle(Style: Integer);
    procedure SetMiterLimit(Limit: Double);
    procedure SetLineDash(DashArray: TPDFDashArray; Phase: Double);
{$IFDEF QPL_DPLR}
    procedure SetLineDashDouble(DashArray: array of Double; Phase: Double);
{$ENDIF}
    procedure BeginPath; override;
    procedure MoveTo(NewX, NewY: Double); override;
    procedure AddLineToPath(EndX, EndY: Double); override;
    procedure AddBezierToPath(CtAX, CtAY, CtBX, CtBY, EndX, EndY: Double); override;
    procedure AddQBezierToPath(QX, QY, EndX, EndY: Double); override;
    procedure ClosePath; override;
    procedure StrokePath; override;
    procedure FillPath; override;
    procedure StrokeAndFillPath; override;
    procedure NullPath;
    procedure FillClippingPath;
    procedure DrawImage(Left, Top, Width, Height: Double; BM: TBitmap);
    procedure DrawAnyImage(Left, Top, Width, Height: Double; Stream: TStream; Page: Integer; UseICM: Boolean = False);
    procedure DrawAnyImageAlign(Left, Top, Width, Height: Double; HDPI, VDPI: Double;
      Alignment: TPDFPicassoImageAlign; Stream: TStream);
    procedure DrawImagePoints(ULX, ULY, URX, URY, LLX, LLY: Double; BM: TBitmap);
    procedure DrawAnyImagePoints(ULX, ULY, URX, URY, LLX, LLY: Double; Stream: TStream);
    procedure DrawTransparentImage(ULX, ULY, URX, URY, LLX, LLY: Double; Stream: TStream; Transparency: Double);
    procedure DrawAnyImagePointsChroma(ULX, ULY, URX, URY, LLX, LLY: Double;
      Stream: TStream; Width, Height: Integer; Min, Max: Cardinal);
    procedure DrawAnyImageFast(Left, Top, Width, Height: Integer; Stream: TStream);
    procedure DrawDirectImage(Source: Pointer; RowLength, Width, Height, Format: Integer;
      Interpolate: Boolean; Min, Max: Integer);
    procedure DrawDirectImageWithPalette(Source: Pointer; RowLength, Width, Height,
      Format: Integer; Palette: Pointer; Interpolate: Boolean; Min, Max: Integer);
    procedure DrawStencilImage(Source: Pointer; RowLength, Width, Height, Format: Integer; Palette: Pointer; Interpolate: Boolean);
    procedure SetFillAlpha(NewFillAlpha: Double);
    procedure SetStrokeAlpha(NewStrokeAlpha: Double);
    procedure SetBlendMode(NewBlendMode: TPDFBlendMode);
    procedure SetFillMode(NewMode: TPDFFillMode);
    procedure SetClippingPath(FillMode: TPDFFillMode);
    procedure SetClippingRegion(ClipRegion: TQPLIntPtr);
    function GetCurrentClipRegion: TQPLIntPtr;
    procedure DrawBitmap(BM: TBitmap; var ULX, ULY, URX, URY, LLX, LLY: Double); override;
    procedure SetGDIPlusImageMode;
    procedure SetGDIPlusTextMode;
    function ConvertStream(InputStream, OutputStream: TStream; const Encoder: TGUID): Boolean;
    function ConvertFile(InputFile, OutputFile: WideString; const Encoder: TGUID): Boolean;
    function ConvertStreamToG4(InputStream, OutputStream: TStream): Boolean;
    procedure SetupMetafile(Width, Height: Integer; Target: TStream);
    procedure SetupDeviceContext(Width, Height: Integer; TargetDC: HDC);
    procedure SetFastestMode;
    procedure BeginGroup;
    procedure EndGroup(Alpha: Double; BlendMode: TPDFBlendMode);
    procedure SaveState;
    procedure RestoreState;
    procedure SetCurrentXForm(NewCurrentXForm: TPDFXForm); override;
    function GetCurrentXForm: TPDFXForm; override;
    procedure AddCombinedPathPoint(PointX, PointY: Double; PointType: Byte);
    procedure DrawDirectString(Font: TQPLIntPtr; UnicodeChar: WideChar; TextMatrix: TPDFXForm);
    function GetDeviceContext: HDC;

{$IFDEF QPL_DPLR}
    function DPLRConvertImage(Stream: TStream): TBitmap;
{$ENDIF}

{$IFDEF QPL_CAIRO}
    function CairoConvertImage(Stream: TStream): TMemoryStream;
    procedure NewCairoSurface(var OldSurface, NewSurface: Pcairo_surface_t; var OldContext, NewContext: Pcairo_t; OnlyAlpha: Boolean);
    procedure RemoveCairoSurface(Surface: Pcairo_surface_t; Context: Pcairo_t);
    procedure SelectCairoSurface(Surface: Pcairo_surface_t; Context: Pcairo_t);
    procedure DrawIsolatedCairoSurface(PunchSurface, LayerSurface: Pcairo_surface_t);
    procedure SetCairoBackdrop(PunchSurface, BackdropSurface: Pcairo_surface_t; PunchContext, BackdropContext: Pcairo_t; Isolate: Boolean);
    procedure CancelCairoBackdrop(Surface: Pcairo_surface_t; Context: Pcairo_t);
    procedure SaveCairoSurface(Surface: Pcairo_surface_t; const FileName: WideString);
    procedure SetupCairoPattern(Pattern: TQPLPattern);
    procedure CairoClearPunchSurface;
{$ENDIF}
{$IFDEF QPL_DPLR}
    procedure SetPageMatrix(var MR: TPDFXForm);
    procedure SetupDPLRPattern(PatternP: PTQPLPattern; Stroke:Integer);
    procedure DrawShading();
    procedure GetPathBounds(Bounds: PGPRectF);
    property RendererHandle: PDPLR_renderer_t read FRendererHandle write FRendererHandle;
    property RendererDLL: TDebenuPDFLibraryDPLR read FRendererDLL;
    property StartMatrix: TPDFXForm read FStartMatrix write FStartMatrix;
{$ENDIF}
    property Model: TPDFPicassoModel read FModel;
    property BMPEncoderGUID: TGUID read FBMPEncoderGUID;
    property PNGEncoderGUID: TGUID read FPNGEncoderGUID;
    property PageHeight: Double read FPageHeight write FPageHeight;
    property GDIPlus: TDQPLGDIPlus read FGDIPlus;
    property Graphics: TQPLIntPtr read FGraphics;
    property Path: TQPLIntPtr read FPath write FPath;
    property LineWidth: Double read FLineWidth;
    //property RenderOffsetX: Integer read FRenderOffsetX write FRenderOffsetX;
    //property RenderOffsetY: Integer read FRenderOffsetY write FRenderOffsetY;
    property ImagePrintMode: TDPLImagePrintMode read FImagePrintMode write FImagePrintMode;
    property PathCombineMode: TDPLPathCombineMode read FPathCombineMode write FPathCombineMode;
    property FillPattern: TQPLPattern read FFillPattern;
  end;

procedure DefaultGDIPlusSettings(var Settings: TGDIPlusSettings);

implementation

uses
  Math,
{$IFDEF WIN64}
  DebenuPDFLibraryJPEGWin64,
{$ELSE}
  DebenuPDFLibraryJPEG,
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  Macapi.CoreGraphics,
{$ENDIF}
  SysUtils;

procedure DefaultGDIPlusSettings(var Settings: TGDIPlusSettings);
begin
  Settings.FileName := 'gdiplus.dll';
  Settings.Smoothing := True;
  Settings.UseGDIPlus := True;
  Settings.AccurateInterpolation := True;
  Settings.SmoothImages := False;
  Settings.ProcessNullPath := True;
  Settings.MonoThreshold := 0;
  Settings.DLLAllowPiggyBack := False;
  Settings.DLLStartup := dsNotIfPiggyback;
  Settings.DLLSuppressBackgroundThread := True;

  Settings.UpdateAppearanceStreams := 0;
  Settings.RenderFormFields := True;
  Settings.RenderAnnotations := True;
  Settings.UseGammaCorrection := True;
  Settings.IgnoreICCProfiles := False;
  Settings.RenderFormFieldsOnly := False;
  Settings.IsPrinting := False;
  Settings.EnhanceThinLines := 0;
  Settings.SmoothingMode := 0;
  Settings.InterpolationMode := 0;
  Settings.PixelOffsetMode := 0;
  Settings.PathCombineMode := cmNormalPaths;
  Settings.DirectFonts := False;

  Settings.ProgressWindow := 0;
  Settings.ProgressMessage := 0;
  Settings.ProgressData := 0;

  Settings.PrintMode := 0;
end;

{ TPDFPicasso }

procedure TPDFPicasso.AddBezierToPath(CtAX, CtAY, CtBX, CtBY, EndX,
  EndY: Double);
{$IFDEF QPL_OS_WINDOWS}
var
  P: array[0..2] of TPoint;
{$ENDIF}
begin
{$IFDEF QPL_OS_WINDOWS}
  if FModel = pmGDI then
  begin
    P[0].X := Round(CtAX);
    P[0].Y := Round(CtAY);
    P[1].X := Round(CtBX);
    P[1].Y := Round(CtBY);
    P[2].X := Round(EndX);
    P[2].Y := Round(EndY);
    Windows.PolyBezierTo(FCanvas.Handle, P[0], 3);
  end else
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  if (FModel = pmQuartz) then
  begin
    FCanClosePath := True;
    CGContextAddCurveToPoint(FDeviceContextInfo.QuartzContext, CtAX, CtAY, CtBX, CtBY, EndX, EndY);
  end else
{$ENDIF}
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    FCairoDLL.cairo_curve_to(FCairoHandle, CtAX, CtAY, CtBX, CtBY, EndX, EndY);
    if (FCairoHasBackdrop) then
    begin
      FCairoDLL.cairo_curve_to(FCairoPunchContext, CtAX, CtAY, CtBX, CtBY, EndX, EndY);
    end;
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_curve_to(FRendererHandle, CtAX, CtAY, CtBX, CtBY,
      EndX, EndY);
  end
  else
{$ENDIF}
  if (FModel = pmHTML5) then
  begin
    HTML5Write('ctx.bezierCurveTo(' + HTML5Number(CtAX) + ',' +
      HTML5Number(CtAY) + ',' + HTML5Number(CtBX) + ',' +
      HTML5Number(CtBY) + ',' + HTML5Number(EndX) + ',' +
      HTML5Number(EndY) + ');');
  end else
  if FModel = pmGDIPlus then
  begin
    if (FPathCombineMode = cmNormalPaths) then
    begin
      FGDIPlus.GdipAddPathBezier(FPath, FX, FY, CtAX, CtAY, CtBX, CtBY, EndX, EndY);
    end else
    begin
      AddCombinedPathPoint(CtAX, CtAY, 3);
      AddCombinedPathPoint(CtBX, CtBY, 3);
      AddCombinedPathPoint(EndX, EndY, 3);
    end;
  end;
  FX := EndX;
  FY := EndY;
end;

procedure TPDFPicasso.AddCombinedPathPoint(PointX, PointY: Double;
  PointType: Byte);
begin
  if (FCombinedPathPointCount = Length(FCombinedPathPoints)) then
  begin
    SetLength(FCombinedPathPoints, Length(FCombinedPathPoints) * 2);
    SetLength(FCombinedPathPointTypes, Length(FCombinedPathPoints));
  end;
  FCombinedPathPoints[FCombinedPathPointCount].X := PointX;
  FCombinedPathPoints[FCombinedPathPointCount].Y := PointY;
  FCombinedPathPointTypes[FCombinedPathPointCount] := PointType;
  Inc(FCombinedPathPointCount);
end;

procedure TPDFPicasso.AddLineToPath(EndX, EndY: Double);
begin
{$IFDEF QPL_OS_WINDOWS}
  if FModel = pmGDI then
  begin
    Windows.LineTo(FCanvas.Handle, Round(EndX), Round(EndY));
  end else
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  if (FModel = pmQuartz) then
  begin
    FCanClosePath := True;
    CGContextAddLineToPoint(FDeviceContextInfo.QuartzContext, EndX, EndY);
  end else
{$ENDIF}
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    FCairoDLL.cairo_line_to(FCairoHandle, EndX, EndY);
    if (FCairoHasBackdrop) then
    begin
      FCairoDLL.cairo_line_to(FCairoPunchContext, EndX, EndY);
    end;
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_line_to(FRendererHandle, EndX, EndY);
  end
  else
{$ENDIF}
  if (FModel = pmHTML5) then
  begin
    HTML5Write('ctx.lineTo(' + HTML5Number(EndX) + ',' + HTML5Number(EndY) + ');');
  end else
  if FModel = pmGDIPlus then
  begin
    if (FPathCombineMode = cmNormalPaths) then
    begin
      FGDIPlus.GdipAddPathLine(FPath, FX, FY, EndX, EndY);
      // DPL-472
      //if (EndX > 100000) or (EndX < - 100000) or  (EndY > 100000) or (EndY < - 100000) then
      //  FValidPath := False;
    end else
    begin
      AddCombinedPathPoint(EndX, EndY, 1);
    end;
  end;
  FX := EndX;
  FY := EndY;
end;

procedure TPDFPicasso.BeginGroup;
begin
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    FCairoDLL.cairo_push_group(FCairoHandle);
  end;
{$ENDIF}
end;

procedure TPDFPicasso.EndGroup(Alpha: Double; BlendMode: TPDFBlendMode);
begin
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    FCairoDLL.cairo_pop_group_to_source(FCairoHandle);
    FCairoDLL.cairo_set_operator(FCairoHandle, FCairoDLL.GetBlendMode(BlendMode));
    FCairoDLL.cairo_paint_with_alpha(FCairoHandle, Alpha);
  end;
{$ENDIF}
end;

procedure TPDFPicasso.BeginPath;
begin
  FValidPath := True;
{$IFDEF QPL_OS_WINDOWS}
  if FModel = pmGDI then
  begin
    Windows.BeginPath(FCanvas.Handle);
  end else
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  if (FModel = pmQuartz) then
  begin
    FCanClosePath := False;
    CGContextBeginPath(FDeviceContextInfo.QuartzContext);
  end else
{$ENDIF}
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    case FFillMode of
      pfAlternate: FCairoDLL.cairo_set_fill_rule(FCairoHandle, CAIRO_FILL_RULE_EVEN_ODD);
      pfWinding: FCairoDLL.cairo_set_fill_rule(FCairoHandle, CAIRO_FILL_RULE_WINDING);
    else
      FCairoDLL.cairo_set_fill_rule(FCairoHandle, CAIRO_FILL_RULE_EVEN_ODD);
    end;

    FCairoDLL.cairo_new_path(FCairoHandle);
    if (FCairoHasBackdrop) then
    begin
      FCairoDLL.cairo_new_path(FCairoPunchContext);
    end;
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    case FFillMode of
      pfAlternate: FRendererDLL.DPLR_set_fill_rule(FRendererHandle, DPLR_FILL_RULE_EVEN_ODD);
      pfWinding: FRendererDLL.DPLR_set_fill_rule(FRendererHandle, DPLR_FILL_RULE_WINDING);
    else
      FRendererDLL.DPLR_set_fill_rule(FRendererHandle, DPLR_FILL_RULE_EVEN_ODD);
    end;
    FRendererDLL.DPLR_new_path(FRendererHandle);
  end
  else
{$ENDIF}
  if (FModel = pmHTML5) then
  begin
    HTML5Write('ctx.beginPath();');
  end else
  if FModel = pmGDIPlus then
  begin
    if (FPathCombineMode = cmNormalPaths) then
    begin
      case FFillMode of
        pfAlternate: FGDIPlus.GdipCreatePath(fmAlternate, FPath);
        pfWinding: FGDIPlus.GdipCreatePath(fmWinding, FPath);
      else
        FGDIPlus.GdipCreatePath(fmAlternate, FPath);
      end;
    end else
    begin
      SetLength(FCombinedPathPoints, 32);
      SetLength(FCombinedPathPointTypes, 32);
      FCombinedPathPointCount := 0;
    end;
  end;
end;

procedure TPDFPicasso.ClosePath;
begin
{$IFDEF QPL_OS_WINDOWS}
  if FModel = pmGDI then
  begin
    CloseFigure(FCanvas.Handle);
  end else
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  if (FModel = pmQuartz) then
  begin
    if (FCanClosePath) then
    begin
      FCanClosePath := False;
      CGContextClosePath(FDeviceContextInfo.QuartzContext);
    end;
  end else
{$ENDIF}
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    FCairoDLL.cairo_close_path(FCairoHandle);
    if (FCairoHasBackdrop) then
    begin
      FCairoDLL.cairo_close_path(FCairoPunchContext);
    end;
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_close_path(FRendererHandle);
  end
  else
{$ENDIF}
  if (FModel = pmHTML5) then
  begin
    HTML5Write('ctx.closePath();');
  end else
  if FModel = pmGDIPlus then
  begin
    if (FPathCombineMode = cmNormalPaths) then
    begin
      FGDIPlus.GdipClosePathFigure(FPath);
    end else
    begin
      if (FCombinedPathPointCount > 0) then
      begin
        // Mark the last point as closed
        FCombinedPathPointTypes[FCombinedPathPointCount - 1] :=
          FCombinedPathPointTypes[FCombinedPathPointCount - 1] or 128;
      end;
    end;
  end;
end;

constructor TPDFPicasso.Create;
begin
  FModel := pmUnknown;
  FGDIPlus := nil;
  FFillAlpha := 1;
  FStrokeAlpha := 1;
  FFillPattern := nil;
  FStrokePattern := nil;
  FBlendMode := bmNormal;
  FIsClippingPath := False;
  FCustomColors := TQuickPDFStringList.Create;
  FPageHeight := 0;
  //FRenderOffsetX := 0;
  //FRenderOffsetY := 0;
  FImagePrintMode := pmNormal;
  FPathCombineMode := cmNormalPaths;

  FNeedClipRegion := True;
  FLastClipRegion := 0;
  SetLength(FClipRegions, 100);
  FClipRegionCount := 0;

{$IFDEF QPL_CAIRO}
  FCairoDLL := nil;
  FCairoHasBackdrop := False;
{$ENDIF}
{$IFDEF QPL_DPLR}
  FRendererDLL := nil;
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  FCanClosePath := False;
{$ENDIF}

  FMetafileInfo.UseMetafile := False;
  FMetafileInfo.MetafileHandle := 0;

  FDeviceContextInfo.UseDeviceContext := False;
  FDeviceContextInfo.TargetDC := 0;
{$IFDEF QPL_OS_MAC}
  FDeviceContextInfo.QuartzContext := nil;
{$ENDIF}
end;

destructor TPDFPicasso.Destroy;
var
  X: Integer;
begin
  if (FModel = pmGDI) then
  begin

  end else
{$IFDEF QPL_CAIRO}
  if (Model = pmCairo) then
  begin
    if (Assigned(FCairoDLL)) then
    begin
      FCairoDLL.cairo_destroy(FCairoHandle);
      FCairoDLL.cairo_surface_destroy(FCairoSurface);
      FCairoDLL.Free;
    end;
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (Model = pmDPLR) then
  begin
    if (Assigned(FRendererDLL)) then
    begin
      FRendererDLL.DPLR_renderer_destroy(FRendererHandle);
      FRendererDLL.Free;
    end;
  end
  else
{$ENDIF}
  if (FModel = pmGDIPlus) then
  begin
    if (FMetafileInfo.UseMetafile) then
    begin
      FGDIPlus.GdipDisposeImage(FMetafileInfo.MetafileHandle);
      FMetafileInfo.Adapter := nil;
      DeleteDC(FMetafileInfo.MetafileDC);
    end;

    for X := 0 to FClipRegionCount - 1 do
      FGDIPlus.GdipDeleteRegion(FClipRegions[X]);
    FGDIPlus.GdipDeleteGraphics(FGraphics);

    if (FGDIPlusCallStartup) then
    begin
      if (FSettings.DLLSuppressBackgroundThread) then
      begin
        FGDIPlusStartupOutput.NotificationUnhook(FGDIPlusThreadToken);
      end;
      FGDIPlus.GdiplusShutdown(FToken);
    end;
    FGraphics := 0;
    FToken := 0;
    if (Assigned(FGDIPlus)) then
    begin
      FGDIPlus.Free;
    end;
  end;

  FCustomColors.Free;
  inherited;
end;

{$IFNDEF QPL_OS_WINDOWS}
procedure TPDFPicasso.DrawImage(Left, Top, Width, Height: Double; BM: TBitmap);
begin

end;
{$ELSE}
procedure TPDFPicasso.DrawImage(Left, Top, Width, Height: Double; BM: TBitmap);
var
  MS: TMemoryStream;
  SA: TImageBytesStreamAdapter;
  FImage: TQPLIntPtr;
begin
  if FModel = pmGDI then
  begin
    FCanvas.Lock;
    try
      FCanvas.CopyRect(Rect(Round(Left), Round(Top), Round(Left + Width), Round(Top + Height)),
        BM.Canvas, Rect(0, 0, BM.Width, BM.Height));
    finally
      FCanvas.Unlock;
    end;
  end else
  if FModel = pmGDIPlus then
  begin
    MS := TMemoryStream.Create;
    try
      BM.Canvas.Lock;
      try
        BM.SaveToStream(MS);
      finally
        BM.Canvas.Unlock;
      end;
      SA := TImageBytesStreamAdapter.Create(MS, soReference);
      try
        if FGDIPlus.GdipLoadImageFromStream(SA as IStream, FImage) = gsOk then
        begin
          FGDIPlus.GdipDrawImageRect(FGraphics, FImage, Left, Top, Width, Height);
          FGDIPlus.GdipDisposeImage(FImage);
        end;
      finally
        //SA.Free;
      end;
    finally
      MS.Free;
    end;
  end;
end;
{$ENDIF}

procedure TPDFPicasso.FillPath;
var
  FBrush: TQPLIntPtr;
begin
{$IFDEF QPL_OS_WINDOWS}
  if FModel = pmGDI then
  begin
    FCanvas.Brush.Color := FFillColor;
    FCanvas.Brush.Style := bsSolid;
    FCanvas.Pen.Style := psClear;
    Windows.EndPath(FCanvas.Handle);
    Windows.FillPath(FCanvas.Handle);
  end else
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  if (FModel = pmQuartz) then
  begin
    CGContextSetRGBFillColor(FDeviceContextInfo.QuartzContext,
      (FFillColor and $FF) / 255,
      ((FFillColor and $FF00) shr 8) / 255,
      ((FFillColor and $FF0000) shr 16) / 255,
      FFillAlpha);
    CGContextFillPath(FDeviceContextInfo.QuartzContext);
  end else
{$ENDIF}
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    if (FCairoHasBackdrop) then
    begin
      // Draw the shape in white onto the punch surface
      FCairoDLL.cairo_set_source_rgba(FCairoPunchContext, 0, 0, 0, 1);
      FCairoDLL.cairo_fill(FCairoPunchContext);

      // Use the punch surface as a mask to paint the original backdrop
      // onto the output surface
      FCairoDLL.cairo_set_operator(FCairoHandle, CAIRO_OPERATOR_OVER);
      FCairoDLL.cairo_set_source_surface(FCairoHandle, FCairoBackdropSurface, 0, 0);
      FCairoDLL.cairo_mask_surface(FCairoHandle, FCairoPunchSurface, 0, 0);

      CairoClearPunchSurface;
    end;

    FCairoDLL.cairo_set_operator(FCairoHandle, FCairoDLL.GetBlendMode(FBlendMode));
    if (Assigned(FFillPattern) and (FFillPattern.PatternType <> ptUnknown)) then
    begin
      SetupCairoPattern(FFillPattern);
    end else
    begin
      FCairoDLL.cairo_set_source_rgba(FCairoHandle,
        (FFillColor and $FF) / 255,
        ((FFillColor and $FF00) shr 8) / 255,
        ((FFillColor and $FF0000) shr 16) / 255, FFillAlpha);
    end;

    if (FIsClippingPath) then
    begin
      FCairoDLL.cairo_fill_preserve(FCairoHandle);
      FCairoDLL.cairo_clip(FCairoHandle);
      FIsClippingPath := False;
    end else
    begin
      if (FCairoDLL.cairo_status(FCairoHandle) = CAIRO_STATUS_SUCCESS) then
      begin
        FCairoDLL.cairo_fill(FCairoHandle);
      end;
    end;
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (Model = pmDPLR) then
  begin
    FRendererDLL.DPLR_gState_init(FRendererHandle);

    FRendererDLL.DPLR_set_matrix(FRendererHandle,
      FCurrentXForm.eM11, FCurrentXForm.eM12,
      FCurrentXForm.eM21, FCurrentXForm.eM22,
      FCurrentXForm.eDx, FCurrentXForm.eDy);

    FRendererDLL.DPLR_set_fill_alpha(FRendererHandle, FFillAlpha);

    FRendererDLL.DPLR_set_operator(FRendererHandle, FRendererDLL.GetBlendMode(FBlendMode));

   if (Assigned(FFillPattern) and (FFillPattern.PDFPatternType <> ptNone)) then
    begin
      SetupDPLRPattern(@FFillPattern, 0);
    end else
    begin
      FRendererDLL.DPLR_set_fill_rgba(FRendererHandle,
        (FFillColor and $FF) / 255,
        ((FFillColor and $FF00) shr 8) / 255,
        ((FFillColor and $FF0000) shr 16) / 255);
    end;

    { At the end of the text object, the accumulated glyph outlines, if any,
    are combined into a single path, treating the individual outlines as subpaths of that path and
    applying the nonzero winding number rule.
    The current clipping path in the graphics state is set to the intersection of this path
    with the previous clipping path. As is the case for path objects,
    this clipping occurs after all filling and stroking operations for the text object have occurred.
    It remains in effect until some previous clipping path is restored by an invocation
    of the Q operator.}
    FRendererDLL.DPLR_fill_path(FRendererHandle);
    if (FIsClippingPath) then
    begin
      FRendererDLL.DPLR_set_clip(FRendererHandle);
      FIsClippingPath := False;
    end;
    FRendererDLL.DPLR_clear_path(FRendererHandle);
  end
  else
{$ENDIF}
  if (FModel = pmHTML5) then
  begin
    HTML5Write('ctx.fillStyle = "#' + HTML5HexColor(FFillColor) + '";');
    HTML5Write('ctx.fill();');
  end else
  if FModel = pmGDIPlus then
  begin
    CheckPath;
    if (Assigned(FFillPattern) and (FFillPattern.PatternType <> ptUnknown)) then
    begin
      FBrush := SetupGDIPlusPattern(FFillPattern);
    end else
    begin
      FGDIPlus.GdipCreateSolidFill(FillColorToARGB, FBrush);
    end;
    FGDIPlus.GdipFillPath(FGraphics, FBrush, FPath);
    if FIsClippingPath then
    begin
      FGDIPlus.GdipSetClipPath(FGraphics, FPath, cmIntersect);
      FLastClipRegion := 0;
      FIsClippingPath := False;
    end;
    FGDIPlus.GdipDeleteBrush(FBrush);
    FGDIPlus.GdipDeletePath(FPath);
    FPath := 0;
  end;
end;

procedure TPDFPicasso.MoveTo(NewX, NewY: Double);
begin
  FX := NewX;
  FY := NewY;
{$IFDEF QPL_OS_WINDOWS}
  if (FModel = pmGDI) then
  begin
    Windows.MoveToEx(FCanvas.Handle, Round(NewX), Round(NewY), nil);
  end else
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  if (FModel = pmQuartz) then
  begin
    FCanClosePath := True;
    CGContextMoveToPoint(FDeviceContextInfo.QuartzContext, NewX, NewY);
  end else
{$ENDIF}
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    if (FCairoHasBackdrop) then
    begin
      FCairoDLL.cairo_move_to(FCairoPunchContext, NewX, NewY);
    end;
    FCairoDLL.cairo_move_to(FCairoHandle, NewX, NewY);
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_move_to(FRendererHandle, NewX, NewY);
  end
  else
{$ENDIF}
  if (FModel = pmHTML5) then
  begin
    HTML5Write('ctx.moveTo(' + HTML5Number(NewX) + ',' + HTML5Number(NewY) + ');');
  end else
  if FModel = pmGDIPlus then
  begin
    if (FPathCombineMode = cmNormalPaths) then
    begin
      if FPath <> 0 then
        FGDIPlus.GdipStartPathFigure(FPath);
    end else
    begin
      AddCombinedPathPoint(NewX, NewY, 0);
    end;
  end;
end;

procedure TPDFPicasso.SetFillColor(Red, Green, Blue: Byte);
begin
  FFillPattern := nil;
  FFillColor := Blue shl 16 + Green shl 8 + Red;
end;

procedure TPDFPicasso.SetFillAlpha(NewFillAlpha: Double);
begin
  FFillAlpha := NewFillAlpha;
end;

procedure TPDFPicasso.SetFillColor(Color: Cardinal);
begin
  FFillPattern := nil;
  FFillColor := Color;
end;

procedure TPDFPicasso.SetLineCapStyle(Style: Integer);
begin
  FLineCapStyle := Style;
end;

{$IFDEF QPL_DPLR}
procedure TPDFPicasso.SetLineDashDouble(DashArray: array of Double;
  Phase: Double);
var
  I: Integer;
begin
  SetLength(FLineDashDoubleArray, Length(DashArray));
  for I := Low(DashArray) to High(DashArray) do
    FLineDashDoubleArray[I] := DashArray[I];
  FLineDashDoublePhase := Phase;
end;
{$ENDIF}

procedure TPDFPicasso.SetLineDash(DashArray: TPDFDashArray; Phase: Double);
begin
  FLineDashArray := DashArray;
  FLineDashPhase := Phase;
end;

procedure TPDFPicasso.SetLineJoinStyle(Style: Integer);
begin
  FLineJoinStyle := Style;
end;

procedure TPDFPicasso.SetLineWidth(NewWidth: Double);
begin
  FLineWidth := NewWidth;

  if (FModel = pmGDIPlus) and (FSettings.EnhanceThinLines <> 0) then
    if (NewWidth <= 1) then
      FLineWidth := FSettings.EnhanceThinLines;

{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) and (FSettings.EnhanceThinLines <> 0) then
  begin
      FLineWidth := 0;
  end;
{$ENDIF}
end;

procedure TPDFPicasso.SetMiterLimit(Limit: Double);
begin
  FMiterLimit := Limit;
end;

procedure TPDFPicasso.SetStrokeColor(Red, Green, Blue: Byte);
begin
  FStrokePattern := nil;
  FStrokeColor := Blue shl 16 + Green shl 8 + Red;
end;

procedure TPDFPicasso.SetStrokeAlpha(NewStrokeAlpha: Double);
begin
  FStrokeAlpha := NewStrokeAlpha;
end;

procedure TPDFPicasso.SetStrokeColor(Color: Cardinal);
begin
  FStrokePattern := nil;
  FStrokeColor := Color;
end;

procedure TPDFPicasso.SetStrokePattern(Pattern: TQPLPattern);
begin
  FStrokePattern := Pattern;
end;

procedure TPDFPicasso.StrokeAndFillPath;
var
  FBrush: TQPLIntPtr;
  FPen: TQPLIntPtr;
  PenMatrix: TQPLIntPtr;
  Status: TGPStatus;
  LineDashArray: TPDFDashArray;
  LineDashPhase: Double;
  DX : Integer;
  TestP1: TPDFDoublePoint;
  TestP2: TPDFDoublePoint;
  DashScale: Double;
begin
{$IFDEF QPL_OS_WINDOWS}
  if FModel = pmGDI then
  begin
    FCanvas.Brush.Color := FFillColor;
    FCanvas.Pen.Color := FStrokeColor;
    FCanvas.Pen.Width := Round(FLineWidth);
    FCanvas.Brush.Style := bsSolid;
    FCanvas.Pen.Style := psSolid;

    // To do: Miterlimit

    Windows.EndPath(FCanvas.Handle);
    Windows.StrokeAndFillPath(FCanvas.Handle);
  end else
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  if (FModel = pmQuartz) then
  begin
    CGContextSetRGBFillColor(FDeviceContextInfo.QuartzContext,
      (FFillColor and $FF) / 255,
      ((FFillColor and $FF00) shr 8) / 255,
      ((FFillColor and $FF0000) shr 16) / 255,
      FFillAlpha);
    CGContextFillPath(FDeviceContextInfo.QuartzContext);
    CGContextSetLineWidth(FDeviceContextInfo.QuartzContext, FLineWidth);
    CGContextSetRGBStrokeColor(FDeviceContextInfo.QuartzContext,
      (FStrokeColor and $FF) / 255,
      ((FStrokeColor and $FF00) shr 8) / 255,
      ((FStrokeColor and $FF0000) shr 16) / 255,
      FStrokeAlpha);
    CGContextStrokePath(FDeviceContextInfo.QuartzContext);
  end else
{$ENDIF}
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    FCairoDLL.cairo_set_operator(FCairoHandle, FCairoDLL.GetBlendMode(FBlendMode));

    if (Assigned(FFillPattern) and (FFillPattern.PatternType <> ptUnknown)) then
    begin
      SetupCairoPattern(FFillPattern);
    end else
    begin
      FCairoDLL.cairo_set_source_rgba(FCairoHandle,
        (FFillColor and $FF) / 255,
        ((FFillColor and $FF00) shr 8) / 255,
        ((FFillColor and $FF0000) shr 16) / 255,
        FFillAlpha);
    end;
    FCairoDLL.cairo_fill_preserve(FCairoHandle);

    if (Assigned(FStrokePattern) and (FStrokePattern.PatternType <> ptUnknown)) then
    begin
      SetupCairoPattern(FStrokePattern);
    end else
    begin
      FCairoDLL.cairo_set_source_rgba(FCairoHandle,
        (FStrokeColor and $FF) / 255,
        ((FStrokeColor and $FF00) shr 8) / 255,
        ((FStrokeColor and $FF0000) shr 16) / 255,
        FStrokeAlpha);
    end;
    FCairoDLL.cairo_set_line_width(FCairoHandle, FLineWidth);

    if (FIsClippingPath) then
    begin
      FCairoDLL.cairo_stroke_preserve(FCairoHandle);
      FCairoDLL.cairo_clip(FCairoHandle);
      FIsClippingPath := False;
    end else
    begin
      FCairoDLL.cairo_stroke(FCairoHandle);
    end;
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_gState_init(FRendererHandle);

    FRendererDLL.DPLR_set_matrix(FRendererHandle,
      FCurrentXForm.eM11, FCurrentXForm.eM12,
      FCurrentXForm.eM21, FCurrentXForm.eM22,
      FCurrentXForm.eDx, FCurrentXForm.eDy);

    FRendererDLL.DPLR_set_operator(FRendererHandle, FRendererDLL.GetBlendMode(FBlendMode));

   if (Assigned(FFillPattern) and (FFillPattern.PDFPatternType <> ptNone)) then
    begin
      SetupDPLRPattern(@FFillPattern, 0);
    end else
    begin
      FRendererDLL.DPLR_set_fill_rgba(FRendererHandle,
        (FFillColor and $FF) / 255,
        ((FFillColor and $FF00) shr 8) / 255,
        ((FFillColor and $FF0000) shr 16) / 255);
    end;
    FRendererDLL.DPLR_set_fill_alpha(FRendererHandle, FFillAlpha);

    if (Assigned(FStrokePattern) and (FStrokePattern.PDFPatternType <> ptNone)) then
    begin
      SetupDPLRPattern(@FStrokePattern, 1);
    end else
    begin
      FRendererDLL.DPLR_set_stroke_rgba(FRendererHandle,
        (FStrokeColor and $FF) / 255,
        ((FStrokeColor and $FF00) shr 8) / 255,
        ((FStrokeColor and $FF0000) shr 16) / 255);
    end;
    FRendererDLL.DPLR_set_stroke_alpha(FRendererHandle, FStrokeAlpha);

    case FLineCapStyle of
      0:FRendererDLL.DPLR_set_line_cap(FRendererHandle, DPLR_LINE_CAP_BUTT);
      1:FRendererDLL.DPLR_set_line_cap(FRendererHandle, DPLR_LINE_CAP_ROUND);
      2:FRendererDLL.DPLR_set_line_cap(FRendererHandle, DPLR_LINE_CAP_SQUARE);
    end;

    case FLineJoinStyle of
      0:FRendererDLL.DPLR_set_line_join(FRendererHandle, DPLR_LINE_JOIN_MITER);
      1:FRendererDLL.DPLR_set_line_join(FRendererHandle, DPLR_LINE_JOIN_ROUND);
      2:FRendererDLL.DPLR_set_line_join(FRendererHandle, DPLR_LINE_JOIN_BEVEL);
    end;

    FRendererDLL.DPLR_set_line_width(FRendererHandle, FLineWidth);

    FRendererDLL.DPLR_set_miter_limit(FRendererHandle, FMiterLimit);

    FRendererDLL.DPLR_set_dash(FRendererHandle,
      PDouble(FLineDashDoubleArray),
      Length(FLineDashDoubleArray),
      FLineDashDoublePhase);

    FRendererDLL.DPLR_stroke_and_fill_path(FRendererHandle);
    if (FIsClippingPath) then
    begin
      FRendererDLL.DPLR_set_clip(FRendererHandle);
      FIsClippingPath := False;
    end;
    FRendererDLL.DPLR_clear_path(FRendererHandle);
  end
  else
{$ENDIF}
  if (FModel = pmHTML5) then
  begin
    HTML5Write('ctx.fillStyle = "#' + HTML5HexColor(FFillColor) + '";');
    HTML5Write('ctx.fill();');
  end else
  if FModel = pmGDIPlus then
  begin
    CheckPath;

    // Dash
    if Length(FLineDashArray) mod 2 <> 0 then
    begin
      SetLength(FLineDashArray, Length(FLineDashArray)*2);
      for DX := (Length(FLineDashArray) div 2) to Length(FLineDashArray) - 1 do
        FLineDashArray[DX] := FLineDashArray[DX - (Length(FLineDashArray) div 2)];
    end;

    if (FSettings.IsPrinting) then
    begin
      if (FLineWidth <= 0) then
        FLineWidth := 1;
      TestP1.X := 0;
      TestP1.Y := 0;
      TestP2.X := 1;
      TestP2.Y := 1;
      TestP1 := DoPDFXForm(FCurrentXForm, TestP1);
      TestP2 := DoPDFXForm(FCurrentXForm, TestP2);
      DashScale := Sqrt(Sqr(TestP2.X - TestP1.X) + Sqr(TestP2.Y - TestP1.Y));
      FLineWidth := FLineWidth * DashScale;

      FGDIPlus.GdipCreatePen1(StrokeColorToARGB, FLineWidth, unPixel, FPen);

      if Length(FLineDashArray) > 0 then
      begin
        SetLength(LineDashArray, Length(FLineDashArray));
        for DX := 0 to Length(LineDashArray) - 1 do
          LineDashArray[DX] := FLineDashArray[DX] / FLineWidth * DashScale;
        LineDashPhase := FLineDashPhase / FLineWidth * DashScale;
      end else
      begin
        SetLength(LineDashArray, 0);
        LineDashPhase := 0;
      end;
    end else
    begin
      if (FLineWidth <= 0) then
        FLineWidth := 1;
      FGDIPlus.GdipCreatePen1(StrokeColorToARGB, FLineWidth, unWorld, FPen);
      Status := FGDIPlus.GdipCreateMatrix2(
        FCurrentXForm.eM11, FCurrentXForm.eM12,
        FCurrentXForm.eM21, FCurrentXForm.eM22,
        0, 0,
        PenMatrix);
      Status := FGDIPlus.GdipSetPenTransform(FPen, PenMatrix);

      TestP1.X := 0;
      TestP1.Y := 0;
      TestP2.X := 1;
      TestP2.Y := 0;
      TestP1 := DoPDFXForm(FCurrentXForm, TestP1);
      TestP2 := DoPDFXForm(FCurrentXForm, TestP2);
      DashScale := Sqrt(Sqr(TestP2.X - TestP1.X) + Sqr(TestP2.Y - TestP1.Y));

      if Length(FLineDashArray) > 0 then
      begin
        SetLength(LineDashArray, Length(FLineDashArray));
        for DX := 0 to Length(LineDashArray) - 1 do
          LineDashArray[DX] := FLineDashArray[DX] / FLineWidth * DashScale;
        LineDashPhase := FLineDashPhase / FLineWidth * DashScale;
      end else
      begin
        SetLength(LineDashArray, 0);
        LineDashPhase := 0;
      end;
    end;

    if Length(LineDashArray) > 0 then
    begin
      FGDIPlus.GdipSetPenDashArray(FPen, LineDashArray, Length(LineDashArray));
      FGDIPlus.GdipSetPenDashOffset(FPen, LineDashPhase);
    end;
    case FLineJoinStyle of
      0: FGDIPlus.GdipSetPenLineJoin(FPen, ljMiter);
      1: FGDIPlus.GdipSetPenLineJoin(FPen, ljRound);
      2: FGDIPlus.GdipSetPenLineJoin(FPen, ljBevel);
    end;
    case FLineCapStyle of
      0: FGDIPlus.GdipSetPenEndCap(FPen, lcFlat);
      1: FGDIPlus.GdipSetPenEndCap(FPen, lcRound);
      2: FGDIPlus.GdipSetPenEndCap(FPen, lcSquare);
    end;
    case FLineCapStyle of
      0: FGDIPlus.GdipSetPenStartCap(FPen, lcFlat);
      1: FGDIPlus.GdipSetPenStartCap(FPen, lcRound);
      2: FGDIPlus.GdipSetPenStartCap(FPen, lcSquare);
    end;
    case FLineCapStyle of
      0: FGDIPlus.GdipSetPenDashCap197819(FPen, dcFlat);
      1: FGDIPlus.GdipSetPenDashCap197819(FPen, dcRound);
      2: FGDIPlus.GdipSetPenDashCap197819(FPen, dcRound);
    end;
    FGDIPlus.GdipSetPenMiterLimit(FPen, FMiterLimit);

    if (Assigned(FFillPattern) and (FFillPattern.PatternType <> ptUnknown)) then
    begin
      FBrush := SetupGDIPlusPattern(FFillPattern);
    end else
    begin
      FGDIPlus.GdipCreateSolidFill(FillColorToARGB, FBrush);
    end;

    FGDIPlus.GdipFillPath(FGraphics, FBrush, FPath);
    FGDIPlus.GdipDrawPath(FGraphics, FPen, FPath);
    if FIsClippingPath then
    begin
      FGDIPlus.GdipSetClipPath(FGraphics, FPath, cmIntersect);
      FLastClipRegion := 0;
      FIsClippingPath := False;
    end;
    FGDIPlus.GdipDeletePen(FPen);
    FGDIPlus.GdipDeleteBrush(FBrush);
    FGDIPlus.GdipDeletePath(FPath);
    FPath := 0;
  end;
end;

procedure TPDFPicasso.StrokePath;
var
  FPen: TQPLIntPtr;
  PenMatrix: TQPLIntPtr;
  Status: TGPStatus;
  Elements: array[0..24] of Single;
  LineDashArray: TPDFDashArray;
  LineDashPhase: Double;
  DX : Integer;
  TestP1: TPDFDoublePoint;
  TestP2: TPDFDoublePoint;
  DashScale: Double;
begin
{$IFDEF QPL_OS_WINDOWS}
  if FModel = pmGDI then
  begin
    FCanvas.Pen.Color := FStrokeColor;
    FCanvas.Pen.Width := Round(FLineWidth);
    FCanvas.Brush.Style := bsClear;
    FCanvas.Pen.Style := psSolid;

    // To do: Miterlimit

    Windows.EndPath(FCanvas.Handle);
    Windows.StrokePath(FCanvas.Handle);
  end else
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  if (FModel = pmQuartz) then
  begin
    CGContextSetRGBStrokeColor(FDeviceContextInfo.QuartzContext,
      (FStrokeColor and $FF) / 255,
      ((FStrokeColor and $FF00) shr 8) / 255,
      ((FStrokeColor and $FF0000) shr 16) / 255,
      FStrokeAlpha);
    CGContextSetLineWidth(FDeviceContextInfo.QuartzContext, FLineWidth);
    CGContextStrokePath(FDeviceContextInfo.QuartzContext);
  end else
{$ENDIF}
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    if (Assigned(FStrokePattern) and (FStrokePattern.PatternType <> ptUnknown)) then
    begin
      SetupCairoPattern(FStrokePattern);
    end else
    begin
      FCairoDLL.cairo_set_source_rgba(FCairoHandle,
        (FStrokeColor and $FF) / 255,
        ((FStrokeColor and $FF00) shr 8) / 255,
        ((FStrokeColor and $FF0000) shr 16) / 255,
        FStrokeAlpha);
    end;
    FCairoDLL.cairo_set_line_width(FCairoHandle, FLineWidth);

    if (FIsClippingPath) then
    begin
      FCairoDLL.cairo_stroke_preserve(FCairoHandle);
      FCairoDLL.cairo_clip(FCairoHandle);
      FIsClippingPath := False;
    end else
    begin
      FCairoDLL.cairo_stroke(FCairoHandle);
    end;
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_gState_init(FRendererHandle);

    FRendererDLL.DPLR_set_matrix(FRendererHandle,
      FCurrentXForm.eM11, FCurrentXForm.eM12,
      FCurrentXForm.eM21, FCurrentXForm.eM22,
      FCurrentXForm.eDx, FCurrentXForm.eDy);

    FRendererDLL.DPLR_set_stroke_alpha(FRendererHandle, FStrokeAlpha);

    FRendererDLL.DPLR_set_operator(FRendererHandle, FRendererDLL.GetBlendMode(FBlendMode));

    if (Assigned(FStrokePattern) and (FStrokePattern.PDFPatternType <> ptNone)) then
    begin
      SetupDPLRPattern(@FStrokePattern, 1);
    end else
    begin
      FRendererDLL.DPLR_set_stroke_rgba(FRendererHandle,
        (FStrokeColor and $FF) / 255,
        ((FStrokeColor and $FF00) shr 8) / 255,
        ((FStrokeColor and $FF0000) shr 16) / 255);
    end;

    case FLineCapStyle of
      0:FRendererDLL.DPLR_set_line_cap(FRendererHandle, DPLR_LINE_CAP_BUTT);
      1:FRendererDLL.DPLR_set_line_cap(FRendererHandle, DPLR_LINE_CAP_ROUND);
      2:FRendererDLL.DPLR_set_line_cap(FRendererHandle, DPLR_LINE_CAP_SQUARE);
    end;

    case FLineJoinStyle of
      0:FRendererDLL.DPLR_set_line_join(FRendererHandle, DPLR_LINE_JOIN_MITER);
      1:FRendererDLL.DPLR_set_line_join(FRendererHandle, DPLR_LINE_JOIN_ROUND);
      2:FRendererDLL.DPLR_set_line_join(FRendererHandle, DPLR_LINE_JOIN_BEVEL);
    end;

    FRendererDLL.DPLR_set_line_width(FRendererHandle, FLineWidth);

    FRendererDLL.DPLR_set_miter_limit(FRendererHandle, FMiterLimit);

    FRendererDLL.DPLR_set_dash(FRendererHandle,
      PDouble(FLineDashDoubleArray),
      Length(FLineDashDoubleArray),
      FLineDashDoublePhase);

    FRendererDLL.DPLR_stroke_path(FRendererHandle);
    if (FIsClippingPath) then
    begin
      FRendererDLL.DPLR_set_clip(FRendererHandle);
      FIsClippingPath := False;
    end;
    FRendererDLL.DPLR_clear_path(FRendererHandle);
  end
  else
{$ENDIF}
  if (FModel = pmHTML5) then
  begin
    HTML5Write('ctx.strokeStyle = "#' + HTML5HexColor(FStrokeColor) + '";');
    HTML5Write('ctx.stroke();');
  end else
  if FModel = pmGDIPlus then
  begin
    CheckPath;

    // Dash
    if Length(FLineDashArray) mod 2 <> 0 then
    begin
      SetLength(FLineDashArray, Length(FLineDashArray)*2);
      for DX := (Length(FLineDashArray) div 2) to Length(FLineDashArray) - 1 do
        FLineDashArray[DX] := FLineDashArray[DX - (Length(FLineDashArray) div 2)];
    end;

    if (FSettings.IsPrinting) then
    begin
      if (FLineWidth <= 0) then
        FLineWidth := 1;

      TestP1.X := 0;
      TestP1.Y := 0;
      TestP2.X := 1;
      TestP2.Y := 1;
      TestP1 := DoPDFXForm(FCurrentXForm, TestP1);
      TestP2 := DoPDFXForm(FCurrentXForm, TestP2);
      DashScale := Sqrt(Sqr(TestP2.X - TestP1.X) + Sqr(TestP2.Y - TestP1.Y));
      FLineWidth := FLineWidth * DashScale;

      FGDIPlus.GdipCreatePen1(StrokeColorToARGB, FLineWidth, unPixel, FPen);

      if Length(FLineDashArray) > 0 then
      begin
        SetLength(LineDashArray, Length(FLineDashArray));
        for DX := 0 to Length(LineDashArray) - 1 do
          LineDashArray[DX] := FLineDashArray[DX] / FLineWidth * DashScale;
        LineDashPhase := FLineDashPhase / FLineWidth * DashScale;
      end else
      begin
        SetLength(LineDashArray, 0);
        LineDashPhase := 0;
      end;
    end else
    begin
      if (FLineWidth <= 0) then
        FLineWidth := 1;
      FGDIPlus.GdipCreatePen1(StrokeColorToARGB, FLineWidth, unWorld, FPen);
      Status := FGDIPlus.GdipCreateMatrix2(
        FCurrentXForm.eM11, FCurrentXForm.eM12,
        FCurrentXForm.eM21, FCurrentXForm.eM22,
        0, 0,
        PenMatrix);
      Status := FGDIPlus.GdipSetPenTransform(FPen, PenMatrix);

      TestP1.X := 0;
      TestP1.Y := 0;
      TestP2.X := 1;
      TestP2.Y := 0;
      TestP1 := DoPDFXForm(FCurrentXForm, TestP1);
      TestP2 := DoPDFXForm(FCurrentXForm, TestP2);
      DashScale := Sqrt(Sqr(TestP2.X - TestP1.X) + Sqr(TestP2.Y - TestP1.Y));

      if Length(FLineDashArray) > 0 then
      begin
        SetLength(LineDashArray, Length(FLineDashArray));
        for DX := 0 to Length(LineDashArray) - 1 do
          LineDashArray[DX] := FLineDashArray[DX] / FLineWidth * DashScale;
        LineDashPhase := FLineDashPhase / FLineWidth * DashScale;
      end else
      begin
        SetLength(LineDashArray, 0);
        LineDashPhase := 0;
      end;
    end;

    if Length(LineDashArray) > 0 then
    begin
      FGDIPlus.GdipSetPenDashArray(FPen, LineDashArray, Length(LineDashArray));
      FGDIPlus.GdipSetPenDashOffset(FPen, LineDashPhase);
    end;
    case FLineJoinStyle of
      0: FGDIPlus.GdipSetPenLineJoin(FPen, ljMiter);
      1: FGDIPlus.GdipSetPenLineJoin(FPen, ljRound);
      2: FGDIPlus.GdipSetPenLineJoin(FPen, ljBevel);
    end;
    case FLineCapStyle of
      0: FGDIPlus.GdipSetPenEndCap(FPen, lcFlat);
      1: FGDIPlus.GdipSetPenEndCap(FPen, lcRound);
      2: FGDIPlus.GdipSetPenEndCap(FPen, lcSquare);
    end;
    case FLineCapStyle of
      0: FGDIPlus.GdipSetPenStartCap(FPen, lcFlat);
      1: FGDIPlus.GdipSetPenStartCap(FPen, lcRound);
      2: FGDIPlus.GdipSetPenStartCap(FPen, lcSquare);
    end;
    case FLineCapStyle of
      0: FGDIPlus.GdipSetPenDashCap197819(FPen, dcFlat);
      1: FGDIPlus.GdipSetPenDashCap197819(FPen, dcRound);
      2: FGDIPlus.GdipSetPenDashCap197819(FPen, dcRound);
    end;

    FGDIPlus.GdipSetPenMiterLimit(FPen, FMiterLimit);

    FGDIPlus.GdipDrawPath(FGraphics, FPen, FPath);

    if FIsClippingPath then
    begin
      FGDIPlus.GdipSetClipPath(FGraphics, FPath, cmIntersect);
      FLastClipRegion := 0;
      FIsClippingPath := False;
    end;
    FGDIPlus.GdipDeletePen(FPen);
    FGDIPlus.GdipDeletePath(FPath);
    FPath := 0;
  end;
end;

procedure TPDFPicasso.UseGDIModel(Canvas: TCanvas);
begin
  FCanvas := Canvas;
  FModel := pmGDI;
end;

{$IFNDEF QPL_OS_WINDOWS}
procedure TPDFPicasso.UseGDIPlusModel(Canvas: TCanvas; Settings: TGDIPlusSettings);
begin
end;
{$ELSE}
procedure TPDFPicasso.UseGDIPlusModel(Canvas: TCanvas; Settings: TGDIPlusSettings);
var
  Okay: Boolean;
  Status: TGPStatus;
  StartupInput: TGdiplusStartupInput;
  FN: WideString;
begin
  FToken := 0;
  FGraphics := 0;
  FSettings := Settings;
  FGDIPlusCallStartup := False;

  if (Assigned(FGDIPlus)) then
  begin
    FGDIPlus.GDIPlusFree;
    FGDIPlus.Free;
  end;
  FGDIPlus := TDQPLGDIPlus.Create;
  FCanvas := Canvas;
  FModel := pmGDIPlus;
  if Settings.FileName = '' then FN := 'gdiplus.dll' else FN := Settings.FileName;
  if FGDIPlus.GDIPlusStatus = gpUndefined then FGDIPlus.GDIPlusLoad(@FN[1], Settings.DLLAllowPiggyBack);
  if FGDIPlus.GDIPlusStatus = gpMissing then
  begin
    SetLength(FN, 2048);
    SetLength(FN, GetModuleFileNameW(HInstance, @FN[1], 2000));
    FN := QPLExtractFilePath(FN) + 'gdiplus.dll';
    FGDIPlus.GDIPlusLoad(@FN[1], Settings.DLLAllowPiggyBack);
  end;
  Okay := FGDIPlus.GDIPlusStatus = gpReady;
  if Okay then
  begin
    if (Settings.DLLStartup = dsNever) then
    begin
      FGDIPlusCallStartup := False;
    end else
    if (Settings.DLLStartup = dsNotIfPiggyback) then
    begin
      FGDIPlusCallStartup := not FGDIPlus.PiggyBack;
    end else
    begin
      FGDIPlusCallStartup := True;
    end;

    if (not FGDIPlusCallStartup) then
    begin
      if (not FGDIPlus.GetEncoderClsid('image/bmp', FBMPEncoderGUID)) then
      begin
        FGDIPlusCallStartup := True;
      end;
    end;

    if (FGDIPlusCallStartup) then
    begin
      StartupInput.GdiplusVersion := 1;
      StartupInput.DebugEventCallback := 0;
      StartupInput.SuppressExternalCodecs := False;
      if (Settings.DLLSuppressBackgroundThread) then
      begin
        StartupInput.SuppressBackgroundThread := True;
        if (FGDIPlus.GdiplusStartup(FToken, @StartupInput, @FGDIPlusStartupOutput) = gsOk) then
        begin
          Status := FGDIPlusStartupOutput.NotificationHook(FGDIPlusThreadToken);
        end else
        begin
          Status := gsGenericError;
        end;
      end else
      begin
        StartupInput.SuppressBackgroundThread := False;
        Status := FGDIPlus.GdiplusStartup(FToken, @StartupInput, nil);
      end;
    end else
    begin
      Status := gsOk;
    end;
    if Status = gsOk then
    begin
      // Get the GUIDs of various image format encoders
      if (not FGDIPlus.GetEncoderClsid('image/bmp', FBMPEncoderGUID)) then
      begin
        FillChar(FBMPEncoderGUID, SizeOf(FBMPEncoderGUID), 0);
      end;
      if (not FGDIPlus.GetEncoderClsid('image/png', FPNGEncoderGUID)) then
      begin
        FillChar(FPNGEncoderGUID, SizeOf(FPNGEncoderGUID), 0);
      end;

      if FMetafileInfo.UseMetafile then
      begin
        FMetafileInfo.MetafileDC := CreateCompatibleDC(0);
        CreateMetafile(FMetafileInfo.MetafileDC);
        Status := FGDIPlus.GdipGetImageGraphicsContext(
          FMetafileInfo.MetafileHandle, FGraphics);
      end else
      if FDeviceContextInfo.UseDeviceContext then
      begin
        Status := FGDIPlus.GdipCreateFromHDC(FDeviceContextInfo.TargetDC, FGraphics);
      end else
      begin
        Status := FGDIPlus.GdipCreateFromHDC(FCanvas.Handle, FGraphics);
      end;
      if Status = gsOk then
      begin
        SetGDIPlusTextMode;

        FGDIPlus.GdipSetPageUnit(FGraphics, unPixel);
        FPath := 0;
      end else
        Okay := False;
    end else
      Okay := False;
  end;

  if not Okay then
  begin
    FGraphics := 0;
    FToken := 0;
    FModel := pmGDI;
    if (Assigned(FGDIPlus)) then
    begin
      FGDIPlus.GDIPlusFree;
      FGDIPlus.Free;
      FGDIPlus := nil;
    end;
  end;
end;
{$ENDIF}

{$IFDEF QPL_CAIRO}
procedure TPDFPicasso.UseCairoModel(TargetDC: HDC; const CairoDLL: WideString; EraseBackground: Boolean);
begin
  FCairoDLL := TCairoDLL.Create;
  if FCairoDLL.Attach(CairoDLL) then
  begin
    FModel := pmCairo;
    FCairoSurface := FCairoDLL.cairo_win32_surface_create(TargetDC);
    FCairoHandle := FCairoDLL.cairo_create(FCairoSurface);
    if (EraseBackground) then
    begin
      FCairoDLL.cairo_set_source_rgba(FCairoHandle, 1, 1, 1, 1);
      FCairoDLL.cairo_paint(FCairoHandle);
    end;
  end else
  begin
    FCairoDLL.Free;
    FCairoDLL := nil;
  end;
end;
{$ENDIF}

{$IFDEF QPL_DPLR}
procedure TPDFPicasso.SetupPrivateGDIPlus;
var
  StartupInput: TGdiplusStartupInput;
begin
  if (not Assigned(FGDIPlus)) then
  begin
    FGDIPlus := TDQPLGDIPlus.Create;
    FGDIPlus.GDIPlusLoad('gdiplus.dll', True);
    if (FGDIPlus.GDIPlusStatus = gpReady) then
    begin
      StartupInput.GdiplusVersion := 1;
      StartupInput.DebugEventCallback := 0;
      StartupInput.SuppressExternalCodecs := False;
      StartupInput.SuppressBackgroundThread := False;
      FGDIPlus.GdiplusStartup(FToken, @StartupInput, nil);
      if (not FGDIPlus.GetEncoderClsid('image/bmp', FBMPEncoderGUID)) then
      begin
        FillChar(FBMPEncoderGUID, SizeOf(FBMPEncoderGUID), 0);
        FGDIPlus.Free;
        FGDIPlus := nil;
      end;
    end;
  end;
end;

procedure TPDFPicasso.ReleasePrivateGDIPlus;
begin
  if (Assigned(FGDIPlus)) then
  begin
    FGDIPlus.GdiplusShutdown(FToken);
    FGDIPlus.Free;
    FGDIPlus := nil;
  end;
end;

procedure TPDFPicasso.UseRendererModel(TargetDC: HDC;
  const RendererDLL: WideString; EraseBackground: Boolean);
begin
  FRendererDLL := TDebenuPDFLibraryDPLR.Create;
  if FRendererDLL.Attach(RendererDLL) then
  begin
    FModel := pmDPLR;
    FRendererHandle := FRendererDLL.DPLR_renderer_win32_create(TargetDC);
    if (EraseBackground) then
    begin
      // FCairoDLL.cairo_set_source_rgba(FCairoHandle, 1, 1, 1, 1);
      // FCairoDLL.cairo_paint(FCairoHandle);
    end;
  end
  else
  begin
    FRendererDLL.Free;
    FRendererDLL := nil;
  end;
end;

procedure TPDFPicasso.UseRendererModelMemory(Width, Height: Integer;
  const RendererDLL: WideString);
begin
  FRendererDLL := TDebenuPDFLibraryDPLR.Create;
  if FRendererDLL.Attach(RendererDLL) then
  begin
    FModel := pmDPLR;
    FRendererHandle := FRendererDLL.DPLR_renderer_create(Width, Height);
  end
  else
  begin
    FRendererDLL.Free;
    FRendererDLL := nil;
  end;
end;

procedure TPDFPicasso.FinishDPLR(TargetDC: HDC);
begin
  if (FModel = pmDPLR) then
  begin
    if (Assigned(FGDIPlus)) then
    begin
      ReleasePrivateGDIPlus;
    end;
    FRendererDLL.DPLR_renderer_draw_to_DC(FRendererHandle, TargetDC, 0, 0, 32);
  end
end;

procedure TPDFPicasso.FinishDPLRMemory(Target: Pointer; Width, Height, BitsPerPixel: Integer);
begin
  if (FModel = pmDPLR) then
  begin
    if (Assigned(FGDIPlus)) then
    begin
      ReleasePrivateGDIPlus;
    end;
    FRendererDLL.DPLR_renderer_draw_to_memory(FRendererHandle, Target, Width, Height, BitsPerPixel);
  end
end;
{$ENDIF}

procedure TPDFPicasso.UseHTML5Model(Target: TStream);
var
  Header: AnsiString;
  LB: AnsiString;
begin
  FHTML5Target := Target;
  FModel := pmHTML5;
  LB := #13#10;
  Header := '<!DOCTYPE html><html><head><script type="text/javascript">' + LB +
    'function DebenuPDFLibraryDraw() {' + LB +
    '  var canvas = document.getElementById("QPLCanvas");' + LB +
    '  if (canvas.getContext) {' + LB +
    '    var ctx = canvas.getContext("2d");' + LB;
  FHTML5Target.Write(Header[1], Length(Header));
end;

procedure TPDFPicasso.FinishHTML5(Width, Height: Integer);
var
  Trailer: AnsiString;
  LB: AnsiString;
begin
  LB := #13#10;
  Trailer := '  }' + LB +
             '}' + LB +
             '</script>' + LB +
             '</head><body onload="DebenuPDFLibraryDraw()">' + LB +
             '<canvas id="QPLCanvas" width="' + QPLIntToStr(Width) + '" ' +
             'height="' + QPLIntToStr(Height) + '"></canvas>' + LB +
             '</body></html>';
  FHTML5Target.Write(Trailer[1], Length(Trailer));
end;

function TPDFPicasso.HTML5Number(Number: Double): string;
begin
  Result := string(QPLDoubleToStr(Number, 3));
end;

procedure TPDFPicasso.HTML5Write(const HTMLCommand: string);
var
  AnsiCommand: AnsiString;
begin
  if (Assigned(FHTML5Target)) then
  begin
    AnsiCommand := AnsiString(HTMLCommand);
    if (Length(AnsiCommand) > 0) then
    begin
      FHTML5Target.Write(AnsiCommand[1], Length(AnsiCommand));
    end;
  end;
end;

function TPDFPicasso.HTML5HexColor(Value: Integer): string;
begin

  Result := IntToHex(Value and $FF, 2) +
            IntToHex(Value and $FF00 shr 8, 2) +
            IntToHex(Value and $FF0000 shr 16, 2);
end;

procedure TPDFPicasso.SetFillMode(NewMode: TPDFFillMode);
begin
  FFillMode := NewMode;
  if FModel = pmGDI then
  begin

  end else
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    case FFillMode of
      pfAlternate: FCairoDLL.cairo_set_fill_rule(FCairoHandle, CAIRO_FILL_RULE_EVEN_ODD);
      pfWinding: FCairoDLL.cairo_set_fill_rule(FCairoHandle, CAIRO_FILL_RULE_WINDING);
    end;
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    case FFillMode of
      pfAlternate: FRendererDLL.DPLR_set_fill_rule(FRendererHandle, DPLR_FILL_RULE_EVEN_ODD);
      pfWinding: FRendererDLL.DPLR_set_fill_rule(FRendererHandle, DPLR_FILL_RULE_WINDING);
    end;
  end
  else
{$ENDIF}
  if FModel = pmGDIPlus then
  begin
    if FPath > 0 then
    case FFillMode of
      pfAlternate: FGDIPlus.GdipSetPathFillMode(FPath, fmAlternate);
      pfWinding: FGDIPlus.GdipSetPathFillMode(FPath, fmWinding);
    end
  end;
end;

procedure TPDFPicasso.SetFillPattern(Pattern: TQPLPattern);
begin
  FFillPattern := Pattern;
end;

function TPDFPicasso.StrokeColorToARGB: Cardinal;
var
  C: Cardinal;
  Alpha: Cardinal;
begin
  C := FStrokeColor;
  Alpha := Round(FStrokeAlpha * 255) shl 24;
  Result := C and $FF shl 16 + C and $FF00 + C and $FF0000 shr 16 + Alpha;
end;

procedure TPDFPicasso.FillClippingPath;
var
  GDIPlusRect: TGPRectF;
{$IFDEF QPL_CAIRO}
  CairoRect: array[0..3] of Double;
{$ENDIF}
begin
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    FCairoDLL.cairo_clip_extents(FCairoHandle, CairoRect[0], CairoRect[1], CairoRect[2], CairoRect[3]);
    FCairoDLL.cairo_new_path(FCairoHandle);
    FCairoDLL.cairo_move_to(FCairoHandle, CairoRect[0], CairoRect[1]);
    FCairoDLL.cairo_line_to(FCairoHandle, CairoRect[2], CairoRect[1]);
    FCairoDLL.cairo_line_to(FCairoHandle, CairoRect[2], CairoRect[3]);
    FCairoDLL.cairo_line_to(FCairoHandle, CairoRect[0], CairoRect[3]);
    FCairoDLL.cairo_close_path(FCairoHandle);
  end else
{$ENDIF}
  if (FModel = pmGDIPlus) then
  begin
    FGDIPlus.GdipGetVisibleClipBounds(FGraphics, @GDIPlusRect);
    FGDIPlus.GdipCreatePath(fmWinding, FPath);
    FGDIPlus.GdipStartPathFigure(FPath);
    FGDIPlus.GdipAddPathLine(FPath, GDIPlusRect.X, GDIPlusRect.Y, GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y);
    FGDIPlus.GdipAddPathLine(FPath, GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y, GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height);
    FGDIPlus.GdipAddPathLine(FPath, GDIPlusRect.X + GDIPlusRect.Width, GDIPlusRect.Y + GDIPlusRect.Height, GDIPlusRect.X, GDIPlusRect.Y + GDIPlusRect.Height);
    FGDIPlus.GdipClosePathFigure(FPath);
  end;
  FillPath;
end;

function TPDFPicasso.FillColorToARGB: Cardinal;
var
  C: Cardinal;
  Alpha: Cardinal;
begin
  C := FFillColor;
  Alpha := Round(FFillAlpha * 255) shl 24;
  Result := C and $FF shl 16 + C and $FF00 + C and $FF0000 shr 16 + Alpha;
end;

{$IFNDEF QPL_OS_WINDOWS}

procedure TPDFPicasso.DrawAnyImage(Left, Top, Width, Height: Double;
  Stream: TStream; Page: Integer; UseICM: Boolean);
begin

end;

procedure TPDFPicasso.DrawImagePoints(ULX, ULY, URX, URY, LLX, LLY: Double;
  BM: TBitmap);
begin

end;

procedure TPDFPicasso.DrawTransparentImage(ULX, ULY, URX, URY, LLX, LLY: Double;
  Stream: TStream; Transparency: Double);
begin

end;

{$ELSE}

procedure TPDFPicasso.DrawAnyImage(Left, Top, Width, Height: Double;
  Stream: TStream; Page: Integer; UseICM: Boolean);
var
  SA: TImageBytesStreamAdapter;
  FImage: TQPLIntPtr;
  LoadResult: TGPStatus;
begin
  if FModel = pmGDIPlus then
  begin
    SA := TImageBytesStreamAdapter.Create(Stream, soReference);
    try
      if UseICM then
      begin
        LoadResult := FGDIPlus.GdipLoadImageFromStreamICM(SA as IStream, FImage);
      end else
      begin
        LoadResult := FGDIPlus.GdipLoadImageFromStream(SA as IStream, FImage);
      end;

      if ((LoadResult = gsOk) and (Page > 1)) then
      begin
        LoadResult := FGDIPlus.SelectImagePage(FImage, Page);
      end;

      if (LoadResult = gsOk) then
      begin
        FGDIPlus.GdipDrawImageRect(FGraphics, FImage, Left, Top, Width, Height);
        FGDIPlus.GdipDisposeImage(FImage);
      end;
    finally
    end;
  end;
end;

procedure TPDFPicasso.DrawImagePoints(ULX, ULY, URX, URY, LLX, LLY: Double;
  BM: TBitmap);
var
  MS: TMemoryStream;
  SA: TImageBytesStreamAdapter;
  FImage: TQPLIntPtr;
  Points: array[1..3, 1..2] of Single;
begin
  if FModel = pmGDIPlus then
  begin
    MS := TMemoryStream.Create;
    try
      BM.SaveToStream(MS);
      SA := TImageBytesStreamAdapter.Create(MS, soReference);
      try
        if FGDIPlus.GdipLoadImageFromStream(SA as IStream, FImage) = gsOk then
        begin
          Points[1, 1] := ULX;
          Points[1, 2] := ULY;
          Points[2, 1] := URX;
          Points[2, 2] := URY;
          Points[3, 1] := LLX;
          Points[3, 2] := LLY;
          SetGDIPlusImageMode;
          FGDIPlus.GdipDrawImagePoints(FGraphics, FImage, @Points[1, 1], 3);
          SetGDIPlusTextMode;
          //GdipDrawImagePoints(FGraphics, FImage, @Points[1, 1], 3);
          FGDIPlus.GdipDisposeImage(FImage);
        end;
      finally
        //SA.Free;
      end;
    finally
      MS.Free;
    end;
  end;
end;
{$ENDIF}

procedure TPDFPicasso.SaveState;
begin
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    FCairoDLL.cairo_save(FCairoHandle);
  end;
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_save(FRendererHandle);
  end;
{$ENDIF}
end;

procedure TPDFPicasso.SetBlendMode(NewBlendMode: TPDFBlendMode);
begin
  FBlendMode := NewBlendMode;
end;

procedure TPDFPicasso.SetClippingPath(FillMode: TPDFFillMode);
begin
  SetFillMode(FillMode);
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    FIsClippingPath := True;
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FIsClippingPath := True;
  end
  else
{$ENDIF}
  if (FModel = pmGDIPlus) then
  begin
    FIsClippingPath := True;
    FNeedClipRegion := True;
  end;
end;

procedure TPDFPicasso.NullPath;
begin
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    if (FIsClippingPath) then
    begin
      FCairoDLL.cairo_clip(FCairoHandle);
      FIsClippingPath := False;
    end else
    begin
      FCairoDLL.cairo_new_path(FCairoHandle);
    end;
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    if (FIsClippingPath) then
    begin
      FRendererDLL.DPLR_set_matrix(FRendererHandle,
        FCurrentXForm.eM11, FCurrentXForm.eM12,
        FCurrentXForm.eM21, FCurrentXForm.eM22,
        FCurrentXForm.eDx, FCurrentXForm.eDy);
      FRendererDLL.DPLR_set_clip(FRendererHandle);
      FIsClippingPath := False;
      FRendererDLL.DPLR_clear_path(FRendererHandle);
    end
    else
    begin
      FRendererDLL.DPLR_new_path(FRendererHandle);
    end;
  end
  else
{$ENDIF}
  if FModel = pmGDIPlus then
  begin
    if FPath > 0 then
    begin
      CheckPath;
      if FIsClippingPath then
      begin
        if ((FSettings.ProcessNullPath) and FValidPath) then
        begin
          FGDIPlus.GdipSetClipPath(FGraphics, FPath, cmIntersect);
        end;
        FLastClipRegion := 0;
        FIsClippingPath := False;
      end;
      FGDIPlus.GdipDeletePath(FPath);
    end;
  end;
  FPath := 0;
end;

procedure TPDFPicasso.RestoreState;
begin
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    FCairoDLL.cairo_restore(FCairoHandle);
  end;
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_restore(FRendererHandle);
  end;
{$ENDIF}
end;

function TPDFPicasso.GetCurrentClipRegion: TQPLIntPtr;
begin
  if FModel = pmGDIPlus then
  begin
    if FNeedClipRegion then
    begin
      FNeedClipRegion := False;
      FGDIPlus.GdipCreateRegion(FLastClipRegion);
      FGDIPlus.GdipGetClip(FGraphics, FLastClipRegion);
      Inc(FClipRegionCount);
      if FClipRegionCount >= Length(FClipRegions) then
      begin
        SetLength(FClipRegions, Length(FClipRegions) + 100);
      end;
      FClipRegions[FClipRegionCount - 1] := FLastClipRegion;
    end;
    Result := FLastClipRegion;
  end else
    Result := 0;
end;

procedure TPDFPicasso.SetClippingRegion(ClipRegion: TQPLIntPtr);
begin
  if FModel = pmGDIPlus then
  begin
    if FLastClipRegion <> ClipRegion then
    begin
      FLastClipRegion := ClipRegion;
      FGDIPlus.GdipSetClipRegion(FGraphics, ClipRegion, cmReplace);
    end;
  end;
end;

procedure TPDFPicasso.SetCurrentXForm(NewCurrentXForm: TPDFXForm);
begin
  FCurrentXForm := NewCurrentXForm;
end;

function TPDFPicasso.GetCurrentXForm: TPDFXForm;
begin
  Result := FCurrentXForm;
end;

procedure TPDFPicasso.AddQBezierToPath(QX, QY, EndX, EndY: Double);
var
{$IFDEF QPL_OS_WINDOWS}
  P: array[0..2] of TPoint;
{$ENDIF}
  CtAX: Double;
  CtAY: Double;
  CtBX: Double;
  CtBY: Double;
begin
  CtAX := FX + 2/3 * (QX - FX);
  CtAY := FY + 2/3 * (QY - FY);
  CtBX := QX + 1/3 * (EndX - QX);
  CtBY := QY + 1/3 * (EndY - QY);
{$IFDEF QPL_OS_WINDOWS}
  if FModel = pmGDI then
  begin
    P[0].X := Round(CtAX);
    P[0].Y := Round(CtAY);
    P[1].X := Round(CtBX);
    P[1].Y := Round(CtBY);
    P[2].X := Round(EndX);
    P[2].Y := Round(EndY);
    Windows.PolyBezierTo(FCanvas.Handle, P[0], 3);
  end else
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  if (FModel = pmQuartz) then
  begin
    FCanClosePath := True;
    CGContextAddCurveToPoint(FDeviceContextInfo.QuartzContext, CtAX, CtAY, CtBX, CtBY, EndX, EndY);
  end else
{$ENDIF}
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    if (FCairoHasBackdrop) then
    begin
      FCairoDLL.cairo_curve_to(FCairoPunchContext, CtAX, CtAY, CtBX, CtBY, EndX, EndY);
    end;
    FCairoDLL.cairo_curve_to(FCairoHandle, CtAX, CtAY, CtBX, CtBY, EndX, EndY);
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_curve_to(FRendererHandle, CtAX, CtAY, CtBX, CtBY,
      EndX, EndY);
  end
  else
{$ENDIF}
  if (FModel = pmHTML5) then
  begin
    HTML5Write('ctx.quadraticCurveTo(' + HTML5Number(QX) + ',' +
      HTML5Number(QY) + ',' + HTML5Number(EndX) + ',' +
      HTML5Number(EndY) + ');');
  end else
  if FModel = pmGDIPlus then
  begin
    if (FPathCombineMode = cmNormalPaths) then
    begin
      FGDIPlus.GdipAddPathBezier(FPath, FX, FY, CtAX, CtAY, CtBX, CtBY, EndX, EndY);
    end else
    begin
      AddCombinedPathPoint(CtAX, CtAY, 3);
      AddCombinedPathPoint(CtBX, CtBY, 3);
      AddCombinedPathPoint(EndX, EndY, 3);
    end;
  end;
  FX := EndX;
  FY := EndY;
end;

{$IFNDEF QPL_OS_WINDOWS}
procedure TPDFPicasso.DrawAnyImagePoints(ULX, ULY, URX, URY, LLX,
  LLY: Double; Stream: TStream);
begin

end;

procedure TPDFPicasso.DrawAnyImagePointsChroma(ULX, ULY, URX, URY, LLX,
  LLY: Double; Stream: TStream; Width, Height: Integer; Min, Max: Cardinal);
begin

end;
{$ELSE}

procedure TPDFPicasso.DrawTransparentImage(ULX, ULY, URX, URY, LLX, LLY: Double; Stream: TStream; Transparency: Double);
var
  SA: TImageBytesStreamAdapter;
  FImage: TQPLIntPtr;
  Points: array[1..3, 1..2] of Single;
  ImageAttr: TQPLIntPtr;
  ColorMatrix: array[0..4, 0..4] of Single;
  MatrixRow, MatrixCol: Integer;
  CMResult: TGPStatus;
  DrawResult: TGPStatus;
begin
  if FModel = pmGDIPlus then
  begin
    SA := TImageBytesStreamAdapter.Create(Stream, soReference);
    try
      if FGDIPlus.GdipLoadImageFromStream(SA as IStream, FImage) = gsOk then
      begin
        Points[1, 1] := ULX;
        Points[1, 2] := ULY;
        Points[2, 1] := URX;
        Points[2, 2] := URY;
        Points[3, 1] := LLX;
        Points[3, 2] := LLY;
        SetGDIPlusImageMode;

        FGDIPlus.GdipCreateImageAttributes(ImageAttr);

        for MatrixRow := 0 to 4 do
        begin
          for MatrixCol := 0 to 4 do
          begin
            if (MatrixCol = MatrixRow) then
            begin
              if (MatrixCol = 3) then
              begin
                ColorMatrix[MatrixRow, MatrixCol] := Transparency;
              end else
              begin
                ColorMatrix[MatrixRow, MatrixCol] := 1;
              end;
            end else
            begin
              ColorMatrix[MatrixRow, MatrixCol] := 0;
            end;
          end;
        end;

        CMResult := FGDIPlus.GdipSetImageAttributesColorMatrix(ImageAttr, atBitmap, True, @ColorMatrix[0, 0], @ColorMatrix[0, 0], mfDefault);

        if (CMResult = gsOk) then
        begin
          DrawResult := FGDIPlus.GdipDrawImagePointsRect(FGraphics, FImage, @Points[1, 1], 3, 0, 0, 417, 417, unPixel, ImageAttr, nil, nil);
          if (DrawResult <> gsOk) then
          begin
            ImageAttr := 0;
          end;
        end;

        FGDIPlus.GdipDisposeImageAttributes(ImageAttr);
        SetGDIPlusTextMode;
        FGDIPlus.GdipDisposeImage(FImage);
      end;
    finally
      //SA.Free;
    end;
  end;
end;

procedure TPDFPicasso.DrawAnyImagePoints(ULX, ULY, URX, URY, LLX,
  LLY: Double; Stream: TStream);
var
  SA: TImageBytesStreamAdapter;
  FImage: TQPLIntPtr;
  Points: array[1..3, 1..2] of Single;
  CanOptimize: Boolean;
  HasBeenDrawn: Boolean;
{$IFDEF QPL_CAIRO}
  CairoStream: TMemoryStream;
  CairoImageSurface: Pcairo_surface_t;
  CairoMatrix: cairo_matrix_t;
  CairoImageWidth: Integer;
  CairoImageHeight: Integer;
  SurfaceStatus: cairo_status_t;
{$ENDIF}
{$IFDEF QPL_DPLR}
  Data: array of Byte;
  I: Integer;
  BM: TBitmap;
  Len: Integer;
  Format: Integer;
  Header: AnsiString;
{$ENDIF}
begin
{$IFDEF QPL_CAIRO}
  if (FModel = pmCairo) then
  begin
    // Cairo doesn't have an option to draw an image using a set of
    // points, so we use the current transformation matrix and draw
    // the image from (0,0) to (1,1)

    // Convert the stream
    CairoStream := CairoConvertImage(Stream);

    // First, create the image surface from the stream and get
    // the width and height
    if (Assigned(CairoStream)) then
    begin
      CairoImageSurface := FCairoDLL.cairo_image_surface_create_from_png_stream(
        CairoStreamRead, CairoStream);
      CairoStream.Free;
    end else
    begin
      CairoImageSurface := FCairoDLL.cairo_image_surface_create_from_png_stream(
        CairoStreamRead, Stream);
    end;

    SurfaceStatus := FCairoDLL.cairo_surface_status(CairoImageSurface);
    if ((SurfaceStatus <> CAIRO_STATUS_NO_MEMORY) and (SurfaceStatus <> CAIRO_STATUS_READ_ERROR)) then
    begin
      CairoImageWidth := FCairoDLL.cairo_image_surface_get_width(CairoImageSurface);
      CairoImageHeight := FCairoDLL.cairo_image_surface_get_height(CairoImageSurface);

      // Copy the current transformation matrix to a Cairo matrix structure
      CairoMatrix.xx := FCurrentXForm.eM11;
      CairoMatrix.yx := FCurrentXForm.eM12;
      CairoMatrix.xy := FCurrentXForm.eM21;
      CairoMatrix.yy := FCurrentXForm.eM22;
      CairoMatrix.x0 := FCurrentXForm.eDx;
      CairoMatrix.y0 := FCurrentXForm.eDy;

      // Set the Cairo matrix
      FCairoDLL.cairo_set_matrix(FCairoHandle, @CairoMatrix);

      // Scale by the width and height
      CairoMatrix.xx := 1 / CairoImageWidth;
      CairoMatrix.yx := 0;
      CairoMatrix.xy := 0;
      CairoMatrix.yy := -1 / CairoImageHeight;
      CairoMatrix.x0 := 0;
      CairoMatrix.y0 := 1;
      FCairoDLL.cairo_transform(FCairoHandle, @CairoMatrix);

      // Set the image surface as the source, then draw the image
      FCairoDLL.cairo_set_operator(FCairoHandle, FCairoDLL.GetBlendMode(FBlendMode));
      FCairoDLL.cairo_set_source_surface(FCairoHandle, CairoImageSurface, 0, 0);
      //FCairoDLL.cairo_rectangle(FCairoHandle, 0, 0, CairoImageWidth, CairoImageHeight);
      FCairoDLL.cairo_paint_with_alpha(FCairoHandle, FFillAlpha);

      // Reset the Cairo matrix
      FCairoDLL.cairo_identity_matrix(FCairoHandle);
    end;

    // Release the image surface
    FCairoDLL.cairo_surface_destroy(CairoImageSurface);
  end else
{$ENDIF}
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    BM := DPLRConvertImage(Stream);
    if (Assigned(BM)) then
    begin
      try
        Len := 0;
        // prepare data for image rendering
        if (BM.PixelFormat = pf1bit) then
        begin
          Format := 3;
          Len := (BM.Width + 7) div 8;
          SetLength(Data, BM.Height*Len);
          for I := 0 to (BM.Height - 1) do
          begin
            Move(BM.ScanLine[i]^, Data[i*Len], Len);
          end;
        end else if (BM.PixelFormat = pf8bit) then
        begin
          Format := 2;
          Len := BM.Width;
          SetLength(Data, BM.Height*Len);
          for I := 0 to (BM.Height - 1) do
          begin
            Move(BM.ScanLine[i]^, Data[i*Len], Len);
          end;
        end else if (BM.PixelFormat = pf24bit) then
        begin
          Format := 1;
          Len := BM.Width*3;
          SetLength(Data, BM.Height*Len);
          for I := 0 to (BM.Height - 1) do
          begin
            Move(BM.ScanLine[i]^, Data[i*Len], Len);
          end;
        end else if (BM.PixelFormat = pf32bit) then
        begin
          Format := 0;
          Len := BM.Width*4;
          SetLength(Data, BM.Height*Len);
          for I := 0 to (BM.Height - 1) do
          begin
            Move(BM.ScanLine[i]^, Data[i*Len], Len);
          end;
        end else
        begin
          Format := -1;
        end;

        FRendererDLL.DPLR_gState_init(FRendererHandle);

        FRendererDLL.DPLR_set_matrix(FRendererHandle,
          FCurrentXForm.eM11, FCurrentXForm.eM12,
          FCurrentXForm.eM21, FCurrentXForm.eM22,
          FCurrentXForm.eDx, FCurrentXForm.eDy);

        FRendererDLL.DPLR_set_operator(FRendererHandle, FRendererDLL.GetBlendMode(FBlendMode));

        FRendererDLL.DPLR_set_fill_alpha(FRendererHandle, FFillAlpha);

        if (Len > 0) then
          FRendererDLL.DPLR_draw_image(FRendererHandle, PByte(Data),
            BM.Width, BM.Height, Len, Format, 1{Kevin}, -1, -1);
      finally
        BM.Free;
      end;
    end;
  end
  else
{$ENDIF}
  if FModel = pmGDIPlus then
  begin
    CanOptimize := False;
    if (FImagePrintMode = pmOptimizeImages) then
    begin
      // Check that the image is not rotated or sheared
      CanOptimize := (Round(ULX * 10) = Round(LLX * 10)) and
        (Round(ULY * 10) = Round(URY * 10));

      SetLength(Header, 2);
      Stream.Seek(0, soBeginning);
      Stream.Read(Header[1], Length(Header));

      if ((Header = #$FF#$D8) or (Header = 'BM')) then
      begin
        // We have JPEG, BMP or PNG data
      end else
{      if (Header = #$89'P') then
      begin
        // We have PNG data
        PR := TPNGReader.Create;
        try
          Stream.Seek(0, soBeginning);
          PR.LoadFromStream(Stream);
          if (PR.AlphaBitDepth > 0) then
          begin
            // Can't optimize if the PNG has an alpha channel
            CanOptimize := False;
          end;
        finally
          PR.Free;
        end;
      end else}
      begin
        CanOptimize := False;
      end;
    end;

    HasBeenDrawn := False;    // To work around 1bit and 8bit images not being supported.

    if (CanOptimize) then
    begin
      BM := DPLRConvertImage(Stream);
      if (Assigned(BM) and (BM.PixelFormat = pf24Bit)) then
      begin
        HasBeenDrawn := PrintRaw24BitBGRData(FCanvas.Handle, BM, Round(ULX), Round(ULY),
          Round(URX - ULX), Round(LLY - ULY), FSettings.PrintMode);
        BM.Free;
      end;
    end;
    //end else

    if (not HasBeenDrawn) then
    begin
      SA := TImageBytesStreamAdapter.Create(Stream, soReference);
      try
        if FGDIPlus.GdipLoadImageFromStream(SA as IStream, FImage) = gsOk then
        begin
          Points[1, 1] := ULX;
          Points[1, 2] := ULY;
          Points[2, 1] := URX;
          Points[2, 2] := URY;
          Points[3, 1] := LLX;
          Points[3, 2] := LLY;
          SetGDIPlusImageMode;
          FGDIPlus.GdipDrawImagePoints(FGraphics, FImage, @Points[1, 1], 3);
          SetGDIPlusTextMode;
          //GdipDrawImagePoints(FGraphics, FImage, @Points[1, 1], 3);
          FGDIPlus.GdipDisposeImage(FImage);
        end;
      finally
        //SA.Free;
      end;
    end;
  end;
end;

procedure TPDFPicasso.DrawAnyImagePointsChroma(ULX, ULY, URX, URY, LLX,
  LLY: Double; Stream: TStream; Width, Height: Integer; Min, Max: Cardinal);
var
  SA: TImageBytesStreamAdapter;
  FImage: TQPLIntPtr;
  Points: array[1..3, 1..2] of Single;
  FAttr: TQPLIntPtr;
  S: TGPStatus;
begin
  if FModel = pmGDIPlus then
  begin
    SA := TImageBytesStreamAdapter.Create(Stream, soReference);
    try
      if FGDIPlus.GdipLoadImageFromStream(SA as IStream, FImage) = gsOk then
      begin
        Points[1, 1] := ULX;
        Points[1, 2] := ULY;
        Points[2, 1] := URX;
        Points[2, 2] := URY;
        Points[3, 1] := LLX;
        Points[3, 2] := LLY;
        if FGDIPlus.GdipCreateImageAttributes(FAttr) = gsOk then
        begin
          S := FGDIPlus.GdipSetImageAttributesColorKeys(FAttr, atBitmap, True, Min, Max);
          if S = gsOk then
          begin
            SetGDIPlusImageMode;
            FGDIPlus.GdipDrawImagePointsRect(FGraphics, FImage, @Points[1, 1], 3,
              0, 0, Width, Height, unPixel, FAttr, nil, nil);
            SetGDIPlusTextMode;
          end;
        end else
          FGDIPlus.GdipDisposeImageAttributes(FAttr);
        FGDIPlus.GdipDisposeImage(FImage);
      end;
    finally
      //SA.Free;
    end;
  end;
end;
{$ENDIF}

procedure TPDFPicasso.DrawBitmap(BM: TBitmap; var ULX, ULY, URX, URY, LLX, LLY: Double);
begin
  DrawImagePoints(ULX, ULY, URX, URY, LLX, LLY, BM);
end;

procedure TPDFPicasso.DrawDirectImage(Source: Pointer; RowLength,
  Width, Height, Format: Integer; Interpolate: Boolean; Min, Max: Integer);
begin
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_gState_init(FRendererHandle);

    FRendererDLL.DPLR_set_matrix(FRendererHandle,
      FCurrentXForm.eM11, FCurrentXForm.eM12,
      FCurrentXForm.eM21, FCurrentXForm.eM22,
      FCurrentXForm.eDx, FCurrentXForm.eDy);

    FRendererDLL.DPLR_set_operator(FRendererHandle, FRendererDLL.GetBlendMode(FBlendMode));

    FRendererDLL.DPLR_set_fill_alpha(FRendererHandle, FFillAlpha);

    if (RowLength > 0) then
      FRendererDLL.DPLR_draw_image(FRendererHandle, Source,
        Width, Height, RowLength, Format, Ord(Interpolate), Min, Max);
  end;
{$ENDIF}
end;

procedure TPDFPicasso.DrawDirectImageWithPalette(Source: Pointer; RowLength,
  Width, Height, Format: Integer; Palette: Pointer; Interpolate: Boolean; Min, Max: Integer);
begin
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_gState_init(FRendererHandle);

    FRendererDLL.DPLR_set_matrix(FRendererHandle,
      FCurrentXForm.eM11, FCurrentXForm.eM12,
      FCurrentXForm.eM21, FCurrentXForm.eM22,
      FCurrentXForm.eDx, FCurrentXForm.eDy);

    FRendererDLL.DPLR_set_operator(FRendererHandle, FRendererDLL.GetBlendMode(FBlendMode));

    FRendererDLL.DPLR_set_fill_alpha(FRendererHandle, FFillAlpha);

    if (RowLength > 0) then
      FRendererDLL.DPLR_draw_palette_image(FRendererHandle, Source,
        Width, Height, RowLength, Format, Ord(Interpolate), Palette, Min, Max);
  end;
{$ENDIF}
end;

procedure TPDFPicasso.DrawDirectString(Font: TQPLIntPtr;
  UnicodeChar: WideChar; TextMatrix: TPDFXForm);
var
  FBrush: TQPLIntPtr;
  Positions: array of TGPPointF;
  Matrix: TQPLIntPtr;
  Status: TGPStatus;
begin
  SetLength(Positions, 1);
  Positions[0].X := 60;
  Positions[0].Y := 60;
  FGDIPlus.GdipCreateSolidFill(FillColorToARGB, FBrush);
  FGDIPlus.GdipCreateMatrix2(5, 0, 0, 5, 0, 0, Matrix);
  Status := FGDIPlus.GdipDrawDriverString(FGraphics, @UnicodeChar, 1,
    Font, FBrush, @Positions[0], 1, Matrix);
  if (Status = gsOk) then
  begin
    FGDIPlus.GdipDeleteBrush(Font);
  end;
  FGDIPlus.GdipDeleteBrush(FBrush);
end;

procedure TPDFPicasso.DrawStencilImage(Source: Pointer; RowLength,
  Width, Height, Format: Integer; Palette: Pointer; Interpolate: Boolean);
begin
{$IFDEF QPL_DPLR}
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_gState_init(FRendererHandle);

    FRendererDLL.DPLR_set_matrix(FRendererHandle,
      FCurrentXForm.eM11, FCurrentXForm.eM12,
      FCurrentXForm.eM21, FCurrentXForm.eM22,
      FCurrentXForm.eDx, FCurrentXForm.eDy);

    if (RowLength > 0) then
    begin
      SaveState;

      FRendererDLL.DPLR_set_image_clip(FRendererHandle, Source,
        Width, Height, RowLength, Ord(Interpolate), Palette);

      BeginPath;
      MoveTo(0, 0);
      AddLineToPath(0, 1);
      AddLineToPath(1, 1);
      AddLineToPath(1, 0);
      ClosePath;

      FillPath;

      RestoreState;
    end;
  end;
{$ENDIF}
end;

procedure TPDFPicasso.CheckPath;
var
  PointCount: Integer;
  GDIPlusFillMode: TGPFillMode;
begin
  if (FPathCombineMode = cmCombinePaths) then
  begin
    if (FCombinedPathPointCount > 0) then
    begin
      case FFillMode of
        pfAlternate: GDIPlusFillMode := fmAlternate;
        pfWinding: GDIPlusFillMode := fmWinding;
      else
        GDIPlusFillMode := fmAlternate;
      end;
      FPath := 0;
      FGDIPlus.GdipCreatePath2(@FCombinedPathPoints[0],
        @FCombinedPathPointTypes[0], FCombinedPathPointCount,
        GDIPlusFillMode, FPath);
    end;
  end;
  if FPath > 0 then
  begin
    FGDIPlus.GdipGetPointCount(FPath, PointCount);
    if PointCount = 2 then
      FGDIPlus.GdipAddPathLine(FPath, FX, FY, FX, FY);
  end;
end;

{$IFNDEF QPL_OS_WINDOWS}
procedure TPDFPicasso.DrawAnyImageAlign(Left, Top, Width, Height: Double;
  HDPI, VDPI: Double; Alignment: TPDFPicassoImageAlign; Stream: TStream);
begin

end;
{$ELSE}
procedure TPDFPicasso.DrawAnyImageAlign(Left, Top, Width, Height: Double;
  HDPI, VDPI: Double; Alignment: TPDFPicassoImageAlign; Stream: TStream);
var
  SA: TImageBytesStreamAdapter;
  FImage: TQPLIntPtr;
  ImWidthPixels: Single;
  ImHeightPixels: Single;
  ImWidth: Double;
  ImHeight: Double;
  ImHorzDPI: Single;
  ImVertDPI: Single;
  Points: array[1..3, 1..2] of Single;
  Fitted: TPDFPicassoDoubleRect;
begin
  if FModel = pmGDIPlus then
  begin
    SA := TImageBytesStreamAdapter.Create(Stream, soReference);
    try
      if FGDIPlus.GdipLoadImageFromStream(SA as IStream, FImage) = gsOk then
      begin
        FGDIPlus.GdipGetImageDimension(FImage, ImWidthPixels, ImHeightPixels);
        FGDIPlus.GdipGetImageHorizontalResolution(FImage, ImHorzDPI);
        FGDIPlus.GdipGetImageVerticalResolution(FImage, ImVertDPI);
        ImWidth := ImWidthPixels / ImHorzDPI;
        ImHeight := ImHeightPixels / ImVertDPI;
        Fitted := FitImage(Left / HDPI, Top / VDPI, Width / HDPI, Height / VDPI,
          ImWidth, ImHeight,
          Alignment.RotateMatchAspec, Alignment.ExpandSmallImages,
          Alignment.ShrinkLargeImages, Alignment.HorizontalAlignment,
          Alignment.VerticalAlignment, Alignment.SmallHorizontalAlignment,
          Alignment.SmallVerticalAlignment);

        Points[1, 1] := Fitted.X1 * HDPI;
        Points[1, 2] := Fitted.Y1 * VDPI;
        Points[2, 1] := Fitted.X2 * HDPI;
        Points[2, 2] := Fitted.Y2 * VDPI;
        Points[3, 1] := Fitted.X4 * HDPI;
        Points[3, 2] := Fitted.Y4 * VDPI;
        FGDIPlus.GdipDrawImagePoints(FGraphics, FImage, @Points[1, 1], 3);
        FGDIPlus.GdipDisposeImage(FImage);
      end;
    finally
    end;
  end;
end;
{$ENDIF}

{$IFDEF QPL_OS_WINDOWS}
function TPDFPicasso.FitImage(TargetLeft, TargetTop, TargetWidth,
  TargetHeight, ImageWidth, ImageHeight: Double; RotateToFit: TPDFPicassoRotateAspect;
  ExpandToFit, ReduceToFit: Boolean; HorzAlign: TPDFPicassoHorzAlign;
  VertAlign: TPDFPicassoVertAlign; SmallHorzAlign: TPDFPicassoHorzAlign;
  SmallVertAlign: TPDFPicassoVertAlign): TPDFPicassoDoubleRect;
var
  XOffset: Double;
  YOffset: Double;
  Rotated: Boolean;
  Temp: Double;
  Scale: Double;
  XScale: Double;
  YScale: Double;
  HA: TPDFPicassoHorzAlign;
  VA: TPDFPicassoVertAlign;
begin
  HA := HorzAlign;
  VA := VertAlign;
  Scale := 1;
  Rotated := False;
  XOffset := 0;
  YOffset := 0;
  if RotateToFit <> raNone then
  begin
    if ((ImageWidth > ImageHeight) and (TargetWidth < TargetHeight)) or
    ((ImageWidth < ImageHeight) and (TargetWidth > TargetHeight)) then
    begin
      Temp := ImageWidth;
      ImageWidth := ImageHeight;
      ImageHeight := Temp;
      Rotated := True;
    end;
  end;
  if ReduceToFit then
  begin
    if (ImageWidth > TargetWidth) or (ImageHeight > TargetHeight) then
    begin
      XScale := TargetWidth / ImageWidth;
      YScale := TargetHeight / ImageHeight;
      if XScale < YScale then Scale := XScale else Scale := YScale;
    end;
  end;
  if ExpandToFit and (Scale = 1) then
  begin
    if (ImageWidth < TargetWidth) and (ImageHeight < TargetHeight) then
    begin
      XScale := TargetWidth / ImageWidth;
      YScale := TargetHeight / ImageHeight;
      if XScale < YScale then Scale := XScale else Scale := YScale;
    end;
  end;
  if (not ExpandToFit) then
  begin
    if (ImageWidth < TargetWidth) and (ImageHeight < TargetHeight) then
    begin
      HA := SmallHorzAlign;
      VA := SmallVertAlign;
    end;
  end;
  ImageWidth := ImageWidth * Scale;
  ImageHeight := ImageHeight * Scale;
  if HA = haRight then
    XOffset := TargetWidth - ImageWidth;
  if HA = haCenter then
    XOffset := (TargetWidth - ImageWidth) / 2;
  if VA = vaBottom then
    YOffset := TargetHeight - ImageHeight;
  if VA = vaCenter then
    YOffset := (TargetHeight - ImageHeight) / 2;
  if Rotated and (RotateToFit = raClockwise) then
  begin
    Result.X1 := TargetLeft + XOffset + ImageWidth;
    Result.Y1 := TargetTop + YOffset;
    Result.X2 := TargetLeft + XOffset + ImageWidth;
    Result.Y2 := TargetTop + YOffset + ImageHeight;
    Result.X3 := TargetLeft + XOffset;
    Result.Y3 := TargetTop + YOffset + ImageHeight;
    Result.X4 := TargetLeft + XOffset;
    Result.Y4 := TargetTop + YOffset;
  end else
  if Rotated and (RotateToFit = raAntiClockwise) then
  begin
    Result.X1 := TargetLeft + XOffset;
    Result.Y1 := TargetTop + YOffset + ImageHeight;
    Result.X2 := TargetLeft + XOffset;
    Result.Y2 := TargetTop + YOffset;
    Result.X3 := TargetLeft + XOffset + ImageWidth;
    Result.Y3 := TargetTop + YOffset;
    Result.X4 := TargetLeft + XOffset + ImageWidth;
    Result.Y4 := TargetTop + YOffset + ImageHeight;
  end else
  begin
    Result.X1 := TargetLeft + XOffset;
    Result.Y1 := TargetTop + YOffset;
    Result.X2 := TargetLeft + XOffset + ImageWidth;
    Result.Y2 := TargetTop + YOffset;
    Result.X3 := TargetLeft + XOffset + ImageWidth;
    Result.Y3 := TargetTop + YOffset + ImageHeight;
    Result.X4 := TargetLeft + XOffset;
    Result.Y4 := TargetTop + YOffset + ImageHeight;
  end;
end;
{$ENDIF}

procedure TPDFPicasso.SetGDIPlusTextMode;
begin
  if FModel = pmGDIPlus then
  begin
    if (FSettings.IsPrinting) then
    begin
      FGDIPlus.GdipSetSmoothingMode(FGraphics, smHighQuality);
      FGDIPlus.GdipSetInterpolationMode(FGraphics, imHighQuality);
      FGDIPlus.GdipSetPixelOffsetMode(FGraphics, poHighQuality);
    end else
    if (FSettings.Smoothing) then
    begin
      FGDIPlus.GdipSetSmoothingMode(FGraphics, smAntiAlias);
      FGDIPlus.GdipSetInterpolationMode(FGraphics, imBiCubic);
      FGDIPlus.GdipSetPixelOffsetMode(FGraphics, poHalf);
    end
    else
    begin
      FGDIPlus.GdipSetSmoothingMode(FGraphics, smNone);
      FGDIPlus.GdipSetInterpolationMode(FGraphics, imNearestNeighbor);
      FGDIPlus.GdipSetPixelOffsetMode(FGraphics, poHalf);
    end;

    if (not FSettings.IsPrinting) then
    begin
      if FSettings.SmoothingMode > 0 then
        FGDIPlus.GdipSetSmoothingMode(FGraphics, TGPSmoothingMode(FSettings.SmoothingMode));

      if FSettings.InterpolationMode > 0 then
        FGDIPlus.GdipSetInterpolationMode(FGraphics, TGPInterpolationMode(FSettings.InterpolationMode));

      if FSettings.PixelOffsetMode > 0 then
        FGDIPlus.GdipSetPixelOffsetMode(FGraphics, TGPPixelOffsetMode(FSettings.PixelOffsetMode));
    end;

  end;
end;

{
  TGPSmoothingMode = (smInvalid = -1, smDefault, smHighSpeed, smHighQuality, smNone, smAntiAlias);
  TGPInterpolationMode = (imInvalid = -1, imDefault, imLowQuality, imHighQuality, imBilinear,
                         imBicubic, imNearestNeighbor, imHighQualityBilinear, imHighQualityBicubic);
  TGPPixelOffsetMode = (poInvalid = -1, poDefault, poHighSpeed, poHighQuality, poNone, poHalf);
}

procedure TPDFPicasso.SetGDIPlusImageMode;
begin
  if (FModel = pmGDIPlus) and (not FSettings.IsPrinting) then
  begin
    if FSettings.SmoothImages then
    begin
      FGDIPlus.GdipSetSmoothingMode(FGraphics, smHighQuality);
      FGDIPlus.GdipSetInterpolationMode(FGraphics, imHighQualityBilinear);
      FGDIPlus.GdipSetPixelOffsetMode(FGraphics, poHighQuality);
    end else
    if FSettings.Smoothing then
    begin
      FGDIPlus.GdipSetSmoothingMode(FGraphics, smNone);
      FGDIPlus.GdipSetInterpolationMode(FGraphics, imNearestNeighbor);
      FGDIPlus.GdipSetPixelOffsetMode(FGraphics, poHalf);
    end else
    begin
      FGDIPlus.GdipSetSmoothingMode(FGraphics, smHighQuality);
      FGDIPlus.GdipSetInterpolationMode(FGraphics, imBiCubic);
      FGDIPlus.GdipSetPixelOffsetMode(FGraphics, poHighQuality);
    end;

    if FSettings.SmoothingMode > 0 then
      FGDIPlus.GdipSetSmoothingMode(FGraphics, TGPSmoothingMode(FSettings.SmoothingMode));

    if FSettings.InterpolationMode > 0 then
      FGDIPlus.GdipSetInterpolationMode(FGraphics, TGPInterpolationMode(FSettings.InterpolationMode));

    if FSettings.PixelOffsetMode > 0 then
      FGDIPlus.GdipSetPixelOffsetMode(FGraphics, TGPPixelOffsetMode(FSettings.PixelOffsetMode));
  end;
end;

{$IFNDEF QPL_OS_WINDOWS}
function TPDFPicasso.ConvertStreamToG4(InputStream, OutputStream: TStream): Boolean;
begin
  Result := False;
end;
{$ELSE}
function TPDFPicasso.ConvertStreamToG4(InputStream, OutputStream: TStream): Boolean;
var
  InputStreamAdapter: TImageBytesStreamAdapter;
  OutputStreamAdapter: TImageBytesStreamAdapter;
  FImage: TQPLIntPtr;
  SaveResult: TGPStatus;
  PixelFormat: Integer;
  Comp, BitDepth: Integer;
  EncodeParams: TGPEncoderParameters;
  S: AnsiString;
  ParamListSize: Cardinal;
  Encoder: TGUID;
  Compression: TGUID;
  ColorDepth: TGUID;
begin
  Result := False;
  InputStreamAdapter := TImageBytesStreamAdapter.Create(InputStream, soReference);
  OutputStreamAdapter := TImageBytesStreamAdapter.Create(OutputStream, soReference);
  try
    if (FGDIPlus.GetEncoderClsid('image/tiff', Encoder) and
      (FGDIPlus.GdipLoadImageFromStream(InputStreamAdapter as IStream, FImage) = gsOk)) then
    begin
      PixelFormat := 0;
      FGDIPlus.GdipGetImagePixelFormat(FImage, PixelFormat);

      FGDIPlus.GdipGetEncoderParameterListSize(FImage, @Encoder, ParamListSize);
      SetLength(S, ParamListSize);
      if (ParamListSize > 0) then
      begin
        FGDIPlus.GdipGetEncoderParameterList(FImage, @Encoder, ParamListSize, @S[1]);
      end;

      // Compression - e09d739d-ccd4-44ee-8eba-3fbf8be4fc58
      Compression.D1 := $e09d739d;
      Compression.D2 := $ccd4;
      Compression.D3 := $44ee;
      Compression.D4[0] := $8e;
      Compression.D4[1] := $ba;
      Compression.D4[2] := $3f;
      Compression.D4[3] := $bf;
      Compression.D4[4] := $8b;
      Compression.D4[5] := $e4;
      Compression.D4[6] := $fc;
      Compression.D4[7] := $58;

      // ColorDepth - 66087055-ad66-4c7c-9a18-38a2310b8337
      ColorDepth.D1 := $66087055;
      ColorDepth.D2 := $ad66;
      ColorDepth.D3 := $4c7c;
      ColorDepth.D4[0] := $9a;
      ColorDepth.D4[1] := $18;
      ColorDepth.D4[2] := $38;
      ColorDepth.D4[3] := $23;
      ColorDepth.D4[4] := $31;
      ColorDepth.D4[5] := $0b;
      ColorDepth.D4[6] := $83;
      ColorDepth.D4[7] := $37;

      Comp := 4;
      BitDepth := 1;

      EncodeParams.Count := 2;
      EncodeParams.Parameter[0].Guid := Compression;
      EncodeParams.Parameter[0].NumberOfValues := 1;
      EncodeParams.Parameter[0].Type_ := 4;
      EncodeParams.Parameter[0].Value := @Comp;

      EncodeParams.Parameter[1].Guid := ColorDepth;
      EncodeParams.Parameter[1].NumberOfValues := 1;
      EncodeParams.Parameter[1].Type_ := 4;
      EncodeParams.Parameter[1].Value := @BitDepth;

      SaveResult := FGDIPlus.GdipSaveImageToStream(FImage,
        OutputStreamAdapter as IStream, @Encoder, @EncodeParams);

      Result := SaveResult = gsOk;
      FGDIPlus.GdipDisposeImage(FImage);
    end;
  finally
  end;
end;
{$ENDIF}

{$IFNDEF QPL_OS_WINDOWS}
function TPDFPicasso.ConvertStream(InputStream, OutputStream: TStream;
  const Encoder: TGUID): Boolean;
begin
  Result := False;
end;
{$ELSE}
function TPDFPicasso.ConvertStream(InputStream, OutputStream: TStream;
  const Encoder: TGUID): Boolean;
var
  InputStreamAdapter: TImageBytesStreamAdapter;
  OutputStreamAdapter: TImageBytesStreamAdapter;
  FImage: TQPLIntPtr;
  SaveResult: TGPStatus;
  PixelFormat: Integer;
begin
  Result := False;
  InputStreamAdapter := TImageBytesStreamAdapter.Create(InputStream, soReference);
  OutputStreamAdapter := TImageBytesStreamAdapter.Create(OutputStream, soReference);
  try
    if FGDIPlus.GdipLoadImageFromStream(InputStreamAdapter as IStream, FImage) = gsOk then
    begin
      PixelFormat := 0;
      FGDIPlus.GdipGetImagePixelFormat(FImage, PixelFormat);
      SaveResult := FGDIPlus.GdipSaveImageToStream(FImage,
        OutputStreamAdapter as IStream, @Encoder, nil);
      Result := SaveResult = gsOk;
      FGDIPlus.GdipDisposeImage(FImage);
    end;
  finally
  end;
end;
{$ENDIF}

{$IFDEF QPL_OS_WINDOWS}
function TPDFPicasso.CreateMetafile(ReferenceHDC: HDC): Boolean;
var
  FrameRect: TGPRectF;
begin
  Result := False;

  FrameRect.X := 0;
  FrameRect.Y := 0;
  FrameRect.Width := FMetafileInfo.Width;
  FrameRect.Height := FMetafileInfo.Height;

  if (FModel = pmGDIPlus) then
  begin
    Result := FGDIPlus.GdipRecordMetafileStream(
      FMetafileInfo.Adapter,
      ReferenceHDC, mtEmfPlusOnly, @FrameRect, fuPixel, nil,
      FMetafileInfo.MetafileHandle) = gsOk;
  end;
end;
{$ENDIF}

procedure TPDFPicasso.SetupDeviceContext(Width, Height: Integer; TargetDC: HDC);
begin
  FDeviceContextInfo.UseDeviceContext := True;
  FDeviceContextInfo.Width := Width;
  FDeviceContextInfo.Height := Height;
  FDeviceContextInfo.TargetDC := TargetDC;
{$IFDEF QPL_OS_MAC}
  FDeviceContextInfo.QuartzContext := CGContextRef(TargetDC);
  FModel := pmQuartz;
{$ENDIF}
end;

{$IFNDEF QPL_OS_WINDOWS}
function TPDFPicasso.SetupGDIPlusPattern(Pattern: TQPLPattern): TQPLIntPtr;
begin
  Result := TQPLIntPtr(0);
end;
{$ELSE}
function TPDFPicasso.SetupGDIPlusPattern(Pattern: TQPLPattern): TQPLIntPtr;
var
  StartX: Double;
  StartY: Double;
  StartPoint: TGPPointF;
  EndX: Double;
  EndY: Double;
  EndPoint: TGPPointF;
  PDFPoint: TPDFDoublePoint;
  LinearGradient: TQPLIntPtr;
  ColorList: array of Cardinal;
  PositionList: array of Single;
  StepCount: Integer;
  RGBCount: Integer;
  StepCountDbl: Double;
  StepDivisor: Double;
  StopPosition: Double;
  InputStreamAdapter: TImageBytesStreamAdapter;
  ImageHandle: TQPLIntPtr;
  TextureBrush: TQPLIntPtr;
  TextureResult: TGPStatus;
  ImageWidth: Integer;
  ImageHeight: Integer;
  Matrix: TQPLIntPtr;
  MatrixOkay: Boolean;
  Mat: TPDFXForm;
begin
  Result := 0;
  if (Pattern.PatternType = ptAxial) then
  begin
    Mat.eM11 := Pattern.GetMatrix(0);
    Mat.eM12 := Pattern.GetMatrix(1);
    Mat.eM21 := Pattern.GetMatrix(2);
    Mat.eM22 := Pattern.GetMatrix(3);
    Mat.eDx  := Pattern.GetMatrix(4);
    Mat.eDy  := Pattern.GetMatrix(5);
    CombinePDFXForm(Mat, FCurrentXForm, Mat);

    // Get the pattern parameters
    StartX := Pattern.GetCoords(0);
    StartY := Pattern.GetCoords(1);
    EndX := Pattern.GetCoords(2);
    EndY := Pattern.GetCoords(3);

    // Create the GDI+ LinearGradientBrush
    PDFPoint.X := StartX;
    PDFPoint.Y := StartY;
    PDFPoint := DoPDFXForm(Mat, PDFPoint);
    StartPoint.X := PDFPoint.X;
    StartPoint.Y := PDFPoint.Y;

    PDFPoint.X := EndX;
    PDFPoint.Y := EndY;
    PDFPoint := DoPDFXForm(Mat, PDFPoint);
    EndPoint.X := PDFPoint.X;
    EndPoint.Y := PDFPoint.Y;

    // Add two or more colors
    RGBCount := Pattern.GetRGBCount;
    SetLength(ColorList, RGBCount);
    SetLength(PositionList, RGBCount);
    StepDivisor := RGBCount - 1;
    for StepCount := 0 to RGBCount - 1 do
    begin
      StepCountDbl := StepCount;
      StopPosition := StepCountDbl / StepDivisor;
      PositionList[StepCount] := StopPosition;
      ColorList[StepCount] := (Round(Pattern.GetRGB(StepCount, 0) * 255) shl 16) +
        (Round(Pattern.GetRGB(StepCount, 1) * 255) shl 8) +
        Round(Pattern.GetRGB(StepCount, 2) * 255) +
        $FF000000;
    end;

    if (FGDIPlus.GdipCreateLineBrush(@StartPoint, @EndPoint, ColorList[0], ColorList[RGBCount - 1], 0, LinearGradient) = gsOk) then
    begin
      Result := LinearGradient;
      if (RGBCount > 2) then
      begin
        FGDIPlus.GdipSetLinePresetBlend(LinearGradient, @ColorList[0], @PositionList[0], RGBCount);
      end;
    end;
  end else
  if (Pattern.PatternType = ptColorTile) then
  begin
    InputStreamAdapter := TImageBytesStreamAdapter.Create(Pattern.TileImageData, soReference);
    try
      if (FGDIPlus.GdipLoadImageFromStream(InputStreamAdapter as IStream, ImageHandle) = gsOk) then
      begin
        FGDIPlus.GdipGetImageWidth(ImageHandle, ImageWidth);
        FGDIPlus.GdipGetImageHeight(ImageHandle, ImageHeight);

        TextureResult := FGDIPlus.GdipCreateTexture2(ImageHandle, 0, 0, 0,
          ImageWidth, ImageHeight, TextureBrush);

        if (TextureResult = gsOk) then
        begin
          Result := TextureBrush;

          MatrixOkay := False;
          if (FPageHeight > 0) then
          begin
            {if (FGDIPlus.GdipCreateMatrix2(Pattern.GetMatrix(0), Pattern.GetMatrix(1),
              Pattern.GetMatrix(2), Pattern.GetMatrix(3),
              Pattern.GetMatrix(4) * FCurrentXForm.eM11,
              (Pattern.GetMatrix(5) - FPageHeight) * FCurrentXForm.eM22,
              Matrix) = gsOk) then   }
            if (FGDIPlus.GdipCreateMatrix2( Pattern.GetMatrix(0), Pattern.GetMatrix(1),
                                            Pattern.GetMatrix(2), Pattern.GetMatrix(3),
                                            Pattern.GetMatrix(4), FPageHeight - Pattern.GetMatrix(5),
              Matrix) = gsOk) then
            begin
              MatrixOkay := True;
            end;
          end else
          begin
            if (FGDIPlus.GdipCreateMatrix2(Pattern.GetMatrix(0), Pattern.GetMatrix(1),
              Pattern.GetMatrix(2), Pattern.GetMatrix(3), Pattern.GetMatrix(4),
              Pattern.GetMatrix(5), Matrix) = gsOk) then
            begin
              MatrixOkay := True;
            end;
          end;

          if (MatrixOkay) then
          begin
            FGDIPlus.GdipSetTextureTransform(TextureBrush, Matrix);
            if (Pattern.TileScale <> 1) then
            begin
              FGDIPlus.GdipScaleTextureTransform(TextureBrush, Pattern.TileScale, Pattern.TileScale, 0);
            end;
          end;
        end;
        FGDIPlus.GdipDisposeImage(ImageHandle);
      end;
    finally
    end;
  end;
end;
{$ENDIF}

{$IFNDEF QPL_OS_WINDOWS}
procedure TPDFPicasso.SetupMetafile(Width, Height: Integer; Target: TStream);
begin

end;

procedure TPDFPicasso.DrawAnyImageFast(Left, Top, Width, Height: Integer;
  Stream: TStream);
begin

end;
{$ELSE}
procedure TPDFPicasso.SetupMetafile(Width, Height: Integer; Target: TStream);
begin
  FMetafileInfo.UseMetafile := True;
  FMetafileInfo.Width := Width;
  FMetafileInfo.Height := Height;

  FMetafileInfo.Adapter := TImageBytesStreamAdapter.Create(
    Target, soReference);

  // MetafileHandle will be created in the UseGDIPlusModel function
  FMetafileInfo.MetafileHandle := 0;
end;

procedure TPDFPicasso.DrawAnyImageFast(Left, Top, Width, Height: Integer;
  Stream: TStream);
var
  SA: TImageBytesStreamAdapter;
  FImage: TQPLIntPtr;
  LoadResult: TGPStatus;
begin
  if FModel = pmGDIPlus then
  begin
    SA := TImageBytesStreamAdapter.Create(Stream, soReference);
    try
      LoadResult := FGDIPlus.GdipLoadImageFromStream(SA as IStream, FImage);

      if LoadResult = gsOk then
      begin
        FGDIPlus.GdipDrawImageRectI(FGraphics, FImage, Left, Top, Width, Height);
        FGDIPlus.GdipDisposeImage(FImage);
      end;
    finally
    end;
  end;
end;
{$ENDIF}

procedure TPDFPicasso.SetFastestMode;
begin
  if FModel = pmGDIPlus then
  begin
    FGDIPlus.GdipSetCompositingMode(FGraphics, cmSourceCopy);
    FGDIPlus.GdipSetCompositingQuality(FGraphics, cqHighSpeed);
    FGDIPlus.GdipSetSmoothingMode(FGraphics, smNone);
    FGDIPlus.GdipSetInterpolationMode(FGraphics, imDefault);
    FGDIPlus.GdipSetPixelOffsetMode(FGraphics, poHighSpeed);
  end;
end;

function TPDFPicasso.ConvertFile(InputFile, OutputFile: WideString;
  const Encoder: TGUID): Boolean;
var
  FImage: TQPLIntPtr;
  SaveResult: TGPStatus;
begin
  Result := False;
  if FGDIPlus.GdipLoadImageFromFile(@InputFile[1], FImage) = gsOk then
  begin
    SaveResult := FGDIPlus.GdipSaveImageToFile(FImage, @OutputFile[1],
      @Encoder, nil);
    Result := SaveResult = gsOk; 
  end;
end;

{$IFDEF QPL_OS_WINDOWS}
{ TImageBytesStreamAdapter }

function TImageBytesStreamAdapter.CountBytes(pcb: PLongint): HResult;
begin
  Result := 0;
  pcb^ := Stream.Size;
end;

function TImageBytesStreamAdapter.LockBytes(cb: Longint; ulOffset: Longint; out ppvBytes: Pointer): HResult;
var
  L: Integer;
begin
  L := Length(LockedBytes);
  SetLength(LockedBytes, L + 1);
  SetLength(LockedBytes[L], cb);
  Stream.Seek(ulOffset, soFromBeginning);
  Stream.Read(LockedBytes[L][1], cb);
  Result := 0;
  ppvBytes := @LockedBytes[L][1];
end;

function TImageBytesStreamAdapter.UnlockBytes(pvBytes: Pointer; cb: LongInt; ulOffset: Longint): HResult;
var
  X: Integer;
  I: Integer;
  Found: Boolean;
begin
  X := 0;
  I := 0;
  Found := False;
  while (X < Length(LockedBytes)) and (not Found) do
  begin
    if @LockedBytes[X][1] = pvBytes then
    begin
      Found := True;
      I := X;
    end;
    Inc(X);
  end;
  if Found then LockedBytes[I] := '';
  Result := 0;
end;
{$ENDIF}

{$IFDEF QPL_CAIRO}
function TPDFPicasso.CairoConvertImage(Stream: TStream): TMemoryStream;
var
  Header: AnsiString;
  JI: TPDFJPEGImage;
  BM: TBitmap;
  PI: TPNGWriter;
begin
  Result := nil;

  SetLength(Header, 2);
  Stream.Seek(0, soFromBeginning);
  Stream.Read(Header[1], 2);
  Stream.Seek(0, soFromBeginning);

  if (Header = 'PN') then
  begin
    // Do nothing - the image is already in PNG format
  end else
  if (Header = 'BM') then
  begin
    // Image is in BMP format
    Result := TMemoryStream.Create;
    BM := TBitmap.Create;
    try
      BM.LoadFromStream(Stream);
      PI := TPNGWriter.Create(BM);
      try
        PI.SaveToStream(Result);
        Result.Seek(0, soFromBeginning);
      finally
        PI.Free;
      end;
    finally
      BM.Free;
    end;
  end else
  if (Header = 'JF') then
  begin
    // Image is in JPEG format
    Result := TMemoryStream.Create;
    JI := TPDFJPEGImage.Create;
    try
      JI.LoadFromStream(Stream);
      BM := TBitmap.Create;
      try
        PI := TPNGWriter.Create(BM);
        try
          PI.SaveToStream(Result);
          Result.Seek(0, soFromBeginning);
        finally
          PI.Free;
        end;
      finally
        BM.Free;
      end;
    finally
      JI.Free;
    end;
  end;
end;
{$ENDIF}

{$IFDEF QPL_DPLR}
function TPDFPicasso.DPLRConvertImage(Stream: TStream): TBitmap;
var
  Header: AnsiString;
  MS: TMemoryStream;
  PR: TPNGReader;
begin
  Result := nil;

  SetLength(Header, 2);
  Stream.Seek(0, soFromBeginning);
  Stream.Read(Header[1], 2);
  Stream.Seek(0, soFromBeginning);

  if (Header = 'BM') then
  begin
    // Image is already in BMP format
    Result := TBitmap.Create;
    Result.LoadFromStream(Stream);
  end else
  if (Header = #137'P') then
  begin
    // PNG format, check if can be processed
    PR := TPNGReader.Create;
    try
      PR.LoadFromStream(Stream);
      Result := PR.SaveToBitmap;
    finally
      PR.Free;
    end;
  end else

  if (not Assigned(Result)) then
  begin
    MS := TMemoryStream.Create;
    try
      if (not Assigned(FGDIPlus)) then
      begin
        SetupPrivateGDIPlus;
      end;
      if (Assigned(FGDIPlus)) then
      begin
        ConvertStream(Stream, MS, FBMPEncoderGUID);
        Result := TBitmap.Create;
        MS.Seek(0, soBeginning);
        Result.LoadFromStream(MS);
      end;
    finally
      MS.Free;
    end;
  end;
end;
{$ENDIF}

{$IFDEF QPL_CAIRO}
procedure TPDFPicasso.DrawIsolatedCairoSurface(PunchSurface, LayerSurface: Pcairo_surface_t);
begin
//  FCairoDLL.cairo_set_source_surface(FCairoHandle, PunchSurface, 0, 0);
//  FCairoDLL.cairo_paint(FCairoHandle);

  FCairoDLL.cairo_set_source_rgba(FCairoHandle, 1, 1, 1, 1);
  FCairoDLL.cairo_mask_surface(FCairoHandle, PunchSurface, 0, 0);
  FCairoDLL.cairo_set_source_surface(FCairoHandle, LayerSurface, 0, 0);
  FCairoDLL.cairo_mask_surface(FCairoHandle, PunchSurface, 0, 0);
end;

procedure TPDFPicasso.NewCairoSurface(var OldSurface, NewSurface: Pcairo_surface_t; var OldContext, NewContext: Pcairo_t; OnlyAlpha: Boolean);
begin
  OldSurface := FCairoSurface;
  OldContext := FCairoHandle;

  if (OnlyAlpha) then
  begin
    NewSurface := FCairoDLL.cairo_surface_create_similar(OldSurface, CAIRO_CONTENT_ALPHA, 1000, 1000);
  end else
  begin
    NewSurface := FCairoDLL.cairo_surface_create_similar(OldSurface, CAIRO_CONTENT_COLOR_ALPHA, 1000, 1000);
  end;

  NewContext := FCairoDLL.cairo_create(NewSurface);

  FCairoSurface := NewSurface;
  FCairoHandle := NewContext;
end;

procedure TPDFPicasso.RemoveCairoSurface(Surface: Pcairo_surface_t; Context: Pcairo_t);
begin
  FCairoDLL.cairo_destroy(Context);
  FCairoDLL.cairo_surface_destroy(Surface);
end;

procedure TPDFPicasso.SelectCairoSurface(Surface: Pcairo_surface_t; Context: Pcairo_t);
begin
  FCairoSurface := Surface;
  FCairoHandle := Context;
end;

procedure TPDFPicasso.SetupCairoPattern(Pattern: TQPLPattern);
var
  StartX: Double;
  StartY: Double;
  EndX: Double;
  EndY: Double;
  CairoPattern: Pcairo_pattern_t;
  CairoMatrix: cairo_matrix_t;
  StepCount: Integer;
  RGBCount: Integer;
  StepCountDbl: Double;
  StepDivisor: Double;
  StopPosition: Double;
begin
  if (Pattern.PatternType = ptAxial) then
  begin
    // Get the pattern parameters
    StartX := Pattern.GetCoords(0);
    StartY := Pattern.GetCoords(1);
    EndX := Pattern.GetCoords(2);
    EndY := Pattern.GetCoords(3);

    // Create the Cairo pattern
    CairoPattern := FCairoDLL.cairo_pattern_create_linear(StartX, StartY, EndX, EndY);

    // Add two or more colors at different positions
    RGBCount := Pattern.GetRGBCount;
    StepDivisor := RGBCount - 1;
    for StepCount := 0 to RGBCount - 1 do
    begin
      StepCountDbl := StepCount;
      StopPosition := StepCountDbl / StepDivisor;
      FCairoDLL.cairo_pattern_add_color_stop_rgb(CairoPattern, StopPosition, Pattern.GetRGB(StepCount, 0), Pattern.GetRGB(StepCount, 1), Pattern.GetRGB(StepCount, 2));
    end;

    // Copy the current transformation matrix to a Cairo matrix structure
    CairoMatrix.xx := FCurrentXForm.eM11;
    CairoMatrix.yx := FCurrentXForm.eM12;
    CairoMatrix.xy := FCurrentXForm.eM21;
    CairoMatrix.yy := FCurrentXForm.eM22;
    CairoMatrix.x0 := FCurrentXForm.eDx;
    CairoMatrix.y0 := FCurrentXForm.eDy;

    FCairoDLL.cairo_matrix_invert(@CairoMatrix);

    // Set the Cairo matrix
    FCairoDLL.cairo_pattern_set_matrix(CairoPattern, @CairoMatrix);

    // Set the extends
    if (Pattern.GetExtend(0)) then
    begin
      FCairoDLL.cairo_pattern_set_extend(CairoPattern, CAIRO_EXTEND_PAD);
    end else
    begin
      FCairoDLL.cairo_pattern_set_extend(CairoPattern, CAIRO_EXTEND_NONE);
    end;

    // Set the pattern as the source
    FCairoDLL.cairo_set_source(FCairoHandle, CairoPattern);
  end;
end;

procedure TPDFPicasso.SetCairoBackdrop(PunchSurface, BackdropSurface: Pcairo_surface_t; PunchContext, BackdropContext: Pcairo_t; Isolate: Boolean);
begin
  FCairoHasBackdrop := True;
  if (Isolate) then
  begin
    FCairoDLL.cairo_set_source_rgba(BackdropContext, 1, 1, 1, 1);
  end else
  begin
    FCairoDLL.cairo_set_source_surface(BackdropContext, FCairoSurface, 0, 0);
  end;
  FCairoDLL.cairo_paint(BackdropContext);

  FCairoBackdropSurface := BackdropSurface;
  FCairoBackdropContext := BackdropContext;

  FCairoPunchSurface := PunchSurface;
  FCairoPunchContext := PunchContext;
  CairoClearPunchSurface;
end;

procedure TPDFPicasso.CancelCairoBackdrop(Surface: Pcairo_surface_t; Context: Pcairo_t);
begin
  FCairoHasBackdrop := False;
  FCairoSurface := Surface;
  FCairoHandle := Context;
end;

procedure TPDFPicasso.CairoClearPunchSurface;
begin
  FCairoDLL.cairo_set_source_rgba(FCairoPunchContext, 0, 0, 0, 0);
  FCairoDLL.cairo_set_operator(FCairoPunchContext, CAIRO_OPERATOR_SOURCE);
  FCairoDLL.cairo_paint(FCairoPunchContext);
end;

procedure TPDFPicasso.SaveCairoSurface(Surface: Pcairo_surface_t; const FileName: WideString);
var
  FBitmap: TBitmap;
  TS: Pcairo_surface_t;
  TC: Pcairo_t;
begin
  FBitmap := TBitmap.Create;
  FBitmap.Width := 200;
  FBitmap.Height := 200;
  FBitmap.PixelFormat := pf24bit;
  FBitmap.Canvas.Lock;
  try
    TS := FCairoDLL.cairo_win32_surface_create(FBitmap.Canvas.Handle);
    TC := FCairoDLL.cairo_create(TS);

    FCairoDLL.cairo_set_source_surface(TC, Surface, 0, 0);
    FCairoDLL.cairo_paint(TC);

    FCairoDLL.cairo_destroy(TC);
    FCairoDLL.cairo_surface_destroy(TS);
  finally
    FBitmap.Canvas.Unlock;
  end;
{$IFNDEF QPL_NOVCL}
  FBitmap.SaveToFile(FileName);
{$ENDIF}
  FBitmap.Free;
end;
{$ENDIF}

{$IFDEF QPL_DPLR}
procedure TPDFPicasso.SetPageMatrix(var MR: TPDFXForm);
begin
  if (FModel = pmDPLR) then
  begin
    FRendererDLL.DPLR_set_page_matrix(FRendererHandle,
      MR.eM11, MR.eM12,
      MR.eM21, MR.eM22,
      MR.eDx, MR.eDy);
  end;
end;

procedure TPDFPicasso.SetupDPLRPattern(PatternP: PTQPLPattern; Stroke:Integer);
var
  DecodeStream: AnsiString;
  Mat : TPDFXForm;
begin
  // tiling pattern
  if (PatternP^.PDFPatternType = ptTiling) then
  begin
    Mat.eM11 := PatternP^.GetMatrix(0);
    Mat.eM12 := PatternP^.GetMatrix(1);
    Mat.eM21 := PatternP^.GetMatrix(2);
    Mat.eM22 := PatternP^.GetMatrix(3);
    Mat.eDx := PatternP^.GetMatrix(4);
    Mat.eDy := PatternP^.GetMatrix(5);

    FRendererDLL.DPLR_pattern_init(FRendererHandle, Stroke, Integer(PatternP^.PDFPatternType));

    FRendererDLL.DPLR_pattern_set_matrix(FRendererHandle, Stroke,
      Mat.eM11,
      Mat.eM12,
      Mat.eM21,
      Mat.eM22,
      Mat.eDx,
      Mat.eDy);

    FRendererDLL.DPLR_pattern_set_bBox (FRendererHandle, Stroke,
      Integer((PatternP^.GetBBox(0) < PatternP^.GetBBox(2)) and (PatternP^.GetBBox(1) < PatternP^.GetBBox(3))),
      PatternP^.GetBBox(0),
      PatternP^.GetBBox(1),
      PatternP^.GetBBox(2),
      PatternP^.GetBBox(3));

    FRendererDLL.DPLR_pattern_set_stepX(FRendererHandle, Stroke,
      PatternP^.GetStep(0));

    FRendererDLL.DPLR_pattern_set_stepY(FRendererHandle, Stroke,
      PatternP^.GetStep(1));

    FRendererDLL.DPLR_pattern_set_tilingType(FRendererHandle, Stroke,
      PatternP^.GetTilingType);

    FRendererDLL.DPLR_pattern_set_paintType(FRendererHandle, Stroke,
      PatternP^.GetPaintType);

    FRendererDLL.DPLR_pattern_set_tile_buffer(FRendererHandle, Stroke,
      PatternP^.TileRenderBuf);

    FRendererDLL.DPLR_pattern_set_tile_size(FRendererHandle, Stroke,
      PatternP^.TileWidth, PatternP^.TileHeight);

  end else if (PatternP^.PDFPatternType = ptShading) then
  begin
    FRendererDLL.DPLR_pattern_set_matrix(FRendererHandle, Stroke,
      PatternP^.GetMatrix(0),
      PatternP^.GetMatrix(1),
      PatternP^.GetMatrix(2),
      PatternP^.GetMatrix(3),
      PatternP^.GetMatrix(4),
      PatternP^.GetMatrix(5));

    if (PatternP.ShadingType >= 1) and (PatternP^.ShadingType <= 7) then
    begin
      FRendererDLL.DPLR_pattern_init(FRendererHandle, Stroke, Integer(PatternP^.PDFPatternType));
      FRendererDLL.DPLR_shading_init(FRendererHandle, Stroke, PatternP.ShadingType);

      if(PatternP^.HasBackColor) then
      begin
        FRendererDLL.DPLR_shading_set_background_color (FRendererHandle, Stroke,
          PatternP^.BackColor.Red,
          PatternP^.BackColor.Green,
          PatternP^.BackColor.Blue);
      end;

      FRendererDLL.DPLR_shading_set_bBox (FRendererHandle, Stroke,
        Integer((PatternP^.GetBBox(0) < PatternP^.GetBBox(2)) and (PatternP^.GetBBox(1) < PatternP^.GetBBox(3))),
        PatternP^.GetBBox(0),
        PatternP^.GetBBox(1),
        PatternP^.GetBBox(2),
        PatternP^.GetBBox(3));

      FRendererDLL.DPLR_shading_set_domain(FRendererHandle, Stroke,
        PatternP^.GetDomain(0),
        PatternP^.GetDomain(1),
        PatternP^.GetDomain(2),
        PatternP^.GetDomain(3));

      FRendererDLL.DPLR_shading_set_coords(FRendererHandle, Stroke,
        PatternP^.GetCoords(0),
        PatternP^.GetCoords(1),
        PatternP^.GetCoords(2),
        PatternP^.GetCoords(3),
        PatternP^.GetCoords(4),
        PatternP^.GetCoords(5));

      FRendererDLL.DPLR_shading_set_matrix(FRendererHandle, Stroke,
        PatternP^.GetMatrix(0),
        PatternP^.GetMatrix(1),
        PatternP^.GetMatrix(2),
        PatternP^.GetMatrix(3),
        PatternP^.GetMatrix(4),
        PatternP^.GetMatrix(5));

      FRendererDLL.DPLR_shading_set_shading_matrix(FRendererHandle, Stroke,
        PatternP^.GetShadingMatrix(0),
        PatternP^.GetShadingMatrix(1),
        PatternP^.GetShadingMatrix(2),
        PatternP^.GetShadingMatrix(3),
        PatternP^.GetShadingMatrix(4),
        PatternP^.GetShadingMatrix(5));

      FRendererDLL.DPLR_shading_set_extend(FRendererHandle, Stroke,
        Integer(PatternP^.GetExtend(0)),
        Integer(PatternP^.GetExtend(1)));

      FRendererDLL.DPLR_shading_set_function(FRendererHandle, Stroke,
        DPLR_shading_read, PatternP);

      FRendererDLL.DPLR_shading_set_color_components(FRendererHandle, Stroke,
        PatternP^.ColorComponents);

      if (PatternP^.ShadingType >= 4) and (PatternP^.ShadingType <= 7) then
      begin
        FRendererDLL.DPLR_shading_set_bitsPerCoordinate(FRendererHandle, Stroke,
          Integer(PatternP^.BitsPerCoordinate));

        FRendererDLL.DPLR_shading_set_bitsPerComponent(FRendererHandle, Stroke,
          Integer(PatternP^.BitsPerComponent));

        FRendererDLL.DPLR_shading_set_bitsPerFlag(FRendererHandle, Stroke,
          Integer(PatternP^.BitsPerFlag));

        FRendererDLL.DPLR_shading_set_verticesPerRow(FRendererHandle, Stroke,
          Integer(PatternP^.VerticesPerRow));

        FRendererDLL.DPLR_shading_set_decode(FRendererHandle, Stroke,
          PDOuble(PatternP^.GetDecodeArray()),
          PatternP^.GetDecodeLength());

        DecodeStream :=  PatternP^.SourceStream;
        FRendererDLL.DPLR_shading_set_stream(FRendererHandle, Stroke,
          DecodeStream,
          Length(DecodeStream));
      end;
    end;
  end;
end;

procedure TPDFPicasso.GetPathBounds(Bounds: PGPRectF);
begin
  GDIPlus.GdipGetPathWorldBounds(Path, Bounds, 0, 0);
  Bounds.X := Bounds.X - LineWidth;
  Bounds.Y := Bounds.Y - LineWidth;
  Bounds.Width := Bounds.Width + 2*LineWidth;
  Bounds.Height := Bounds.Height + 2*LineWidth;
end;

procedure TPDFPicasso.DrawShading();
begin
  if (FModel = pmDPLR) then
  begin
    if (Assigned(FFillPattern) and (FFillPattern.PDFPatternType = ptShading)) then
    begin
      FRendererDLL.DPLR_gState_init(FRendererHandle);

      FRendererDLL.DPLR_set_matrix(FRendererHandle,
        FCurrentXForm.eM11, FCurrentXForm.eM12,
        FCurrentXForm.eM21, FCurrentXForm.eM22,
        FCurrentXForm.eDx, FCurrentXForm.eDy);

      FRendererDLL.DPLR_set_operator(FRendererHandle, FRendererDLL.GetBlendMode(FBlendMode));

      FRendererDLL.DPLR_set_fill_alpha(FRendererHandle, FFillAlpha);

      SetupDPLRPattern(@FFillPattern, 0);

      // draw shading
      FRendererDLL.DPLR_draw_shading(FRendererHandle);
    end
  end;
end;

{$ENDIF}

function TPDFPicasso.GetDeviceContext: HDC;
begin
  Result := FDeviceContextInfo.TargetDC;
end;

end.
