{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryGDIPlus.pas                            }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryGDIPlus;

{$I DebenuPDFLibraryDefines.inc}

interface

{$MINENUMSIZE 4}

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  {$IFDEF QPL_OS_WINDOWS}
  ActiveX,
  {$ENDIF}
  DebenuPDFLibraryTypes;

type
  TGDIPlusStatus = (gpUndefined, gpMissing, gpIncompatible, gpReady);

  TGPStatus = (gsOk, gsGenericError, gsInvalidParameter, gsOutOfMemory,
    gsObjectBusy, gsInsufficientBuffer, gsNotImplemented, gsWin32Error,
    gsWrongState, gsAborted, gsFileNotFound, gsValueOverflow, gsAccessDenied,
    gsUnknownImageFormat, gsFontFamilyNotFound, gsFontStyleNotFound,
    gsNotTrueTypeFont, gsUnsupportedGdiplusVersion, gsGdiplusNotInitialized,
    gsPropertyNotFound, gsPropertyNotSupported, gsProfileNotFound);

{$IFDEF VER120}
{$DEFINE D4ORD5}
{$ENDIF}
{$IFDEF VER130}
{$DEFINE D4ORD5}
{$ENDIF}

{$IFDEF D4ORD5}
  TGPSmoothingMode = (smDefault, smHighSpeed, smHighQuality,
    smNone, smAntiAlias);
  TGPPixelOffsetMode = (poDefault, poHighSpeed, poHighQuality,
    poNone, poHalf);
  TGPInterpolationMode = (imDefault, imLowQuality, imHighQuality,
    imBilinear, imBicubic, imNearestNeighbor, imHighQualityBilinear,
    imHighQualityBicubic);
{$ELSE}
  TGPSmoothingMode = (smInvalid = -1, smDefault, smHighSpeed, smHighQuality,
    smNone, smAntiAlias);
  TGPPixelOffsetMode = (poInvalid = -1, poDefault, poHighSpeed, poHighQuality,
    poNone, poHalf);
  TGPInterpolationMode = (imInvalid = -1, imDefault, imLowQuality,
    imHighQuality, imBilinear, imBicubic, imNearestNeighbor,
    imHighQualityBilinear, imHighQualityBicubic);
{$ENDIF}

  TGPCompositingMode = (cmSourceOver, cmSourceCopy);

{$IFDEF D4ORD5}
  TGPCompositingQuality = (cqDefault, cqHighSpeed,
    cqHighQuality, cqGammaCorrected, cqAssumeLinear);
{$ELSE}
  TGPCompositingQuality = (cqInvalid = -1, cqDefault, cqHighSpeed,
    cqHighQuality, cqGammaCorrected, cqAssumeLinear);
{$ENDIF}

  TGPCombineMode = (cmReplace, cmIntersect, cmUnion, cmXor, cmExclude,
    cmComplement);

  PGdiplusStartupInput = ^TGdiplusStartupInput;
  TGdiplusStartupInput = record
    GdiplusVersion: Integer;
    DebugEventCallback: TQPLIntPtr;
    SuppressBackgroundThread: BOOL;
    SuppressExternalCodecs: BOOL;
  end;

  TGdiplusNotificationHookProc = function(out Token: Cardinal): TGPStatus; stdcall;
  TGdiplusNotificationUnhookProc = procedure(Token: Cardinal); stdcall;

  PGDIPlusStartupOutput = ^TGDIPlusStartupOutput;
  TGdiplusStartupOutput = record
    NotificationHook: TGdiplusNotificationHookProc;
    NotificationUnhook: TGdiplusNotificationUnhookProc;
  end;

  PGdiplusPropertyItem = ^TGdiplusPropertyItem;
  TGdiplusPropertyItem = record
    Id: Cardinal;
    Length: Cardinal;
    Type_: SmallInt;
    Value: Pointer;
  end;

  PGPColorPalette = ^TGPColorPalette;
  TGPColorPalette = record
    Flags: Cardinal;
    Count: Cardinal;
    Entries: array[0..255] of Cardinal;
  end;

  TGPFillMode = (fmAlternate, fmWinding);

  TGPLineJoin = (ljMiter, ljBevel, ljRound);

  TGPLineCap = (lcFlat, lcSquare, lcRound, lcTriangle);

  TGPDashCap = (dcFlat, dcUnknown0, dcRound, dcTriangle);

  TGPDitherType = (dtNone, dtSolid, dtOrdered4x4, dtOrdered8x8, dtOrdered16x16,
    dtOrdered91x91, dtSpiral4x4, dtSpiral8x8, dtDualSpiral4x4, dtDualSpiral8x8,
    dtErrorDiffusion);

  TGPPaletteType = (ptCustom, ptOptimal, ptFixedBW, ptFixedHalftone8,
    ptFixedHalftone27, ptFixedHalftone64, ptFixedHalftone125,
    ptFixedHalftone216, ptFixedHalftone252, ptFixedHalftone256);

  TGPUnit = (unWorld, unDisplay, unPixel, unPoint, unInch,
    unDocument, unMillimeter);

  TGPDashArray = array of Single;
  PSingle = ^Single;

  TGPColorAdjustType = (atDefault, atBitmap, atBrush, atPen, atText,
    atCount, atAny);

  TGPMetafileType = (mtUnknown0, mtUnknown1, mtUnknown2,
    mtEmfOnly, mtEmfPlusOnly, mtEmfPlusDual);

  TGPMetafileFrameUnit = (fuUnknown0, fuUnknown1, fuPixel, fuPoint, fuInch,
    fuDocument, fuMillimeter, fuGDI);

  TGPColorMatrixFlags = (mfDefault, mfSkipGrays, mfAltGray);

  PGPRectF = ^TGPRectF;
  TGPRectF = packed record
    X, Y, Width, Height: Single;
  end;

  PGPPointF = ^TGPPointF;
  TGPPointF = packed record
    X, Y: Single;
  end;

  PGPEncoderParameter = ^TGPEncoderParameter;
  TGPEncoderParameter = packed record
    Guid: TGuid;
    NumberOfValues: Cardinal;
    Type_: Cardinal;
    Value: Pointer;
  end;

  TGPEncoderParameters = packed record
    Count: Cardinal;
{$IFDEF WIN64}
    Padding: Cardinal;
{$ENDIF}
    Parameter: array[0..10] of TGPEncoderParameter;
  end;
  PGPEncoderParameters = ^TGPEncoderParameters;

  TGPImageCodecInfo = packed record
    Clsid: TGUID;             
    FormatID: TGUID;
    CodecName: PWChar;
    DllName: PWChar;           
    FormatDescription: PWChar; 
    FilenameExtension: PWChar; 
    MimeType: PWChar;
    Flags: DWORD;             
    Version: DWORD;           
    SigCount: DWORD;
    SigSize: DWORD;
    SigPattern: PByte;
    SigMask: PByte;
  end;
  PGPImageCodecInfo = ^TGPImageCodecInfo;

  TGPPixelFormat = Integer;

{$IFNDEF QPL_OS_WINDOWS}
  IStream = interface
  end;
{$ENDIF}

const
  PixelFormatGDI = $00020000; // Is a GDI-supported format
  PixelFormatAlpha = $00040000; // Has an alpha component
  PixelFormatCanonical = $00200000;
  PixelFormat32bppARGB = (10 or (32 shl 8) or PixelFormatAlpha or PixelFormatGDI
                       or PixelFormatCanonical);

  EncoderParameterValueTypeByte           = 1;    // 8-bit unsigned int
  EncoderParameterValueTypeASCII          = 2;    // 8-bit byte containing one 7-bit ASCII
                                                  // code. NULL terminated.
  EncoderParameterValueTypeShort          = 3;    // 16-bit unsigned int
  EncoderParameterValueTypeLong           = 4;    // 32-bit unsigned int
  EncoderParameterValueTypeRational       = 5;    // Two Longs. The first Long is the
                                                  // numerator, the second Long expresses the
                                                  // denomintor.
  EncoderParameterValueTypeLongRange      = 6;    // Two longs which specify a range of
                                                  // integer values. The first Long specifies
                                                  // the lower end and the second one
                                                  // specifies the higher end. All values
                                                  // are inclusive at both ends
  EncoderParameterValueTypeUndefined      = 7;    // 8-bit byte that can take any value
                                                  // depending on field definition
  EncoderParameterValueTypeRationalRange  = 8;    // Two Rationals. The first Rational
                                                  // specifies the lower end and the second
                                                  // specifies the higher end. All values
                                                  // are inclusive at both ends

  EncoderValueColorTypeCMYK = 0;
  EncoderValueColorTypeYCCK = 1;
  EncoderValueCompressionLZW = 2;
  EncoderValueCompressionCCITT3 = 3;
  EncoderValueCompressionCCITT4 = 4;
  EncoderValueCompressionRle = 5;
  EncoderValueCompressionNone = 6;
  EncoderValueScanMethodInterlaced = 7;
  EncoderValueScanMethodNonInterlaced = 8;
  EncoderValueVersionGif87 = 9;
  EncoderValueVersionGif89 = 10;
  EncoderValueRenderProgressive = 11;
  EncoderValueRenderNonProgressive = 12;
  EncoderValueTransformRotate90 = 13;
  EncoderValueTransformRotate180 = 14;
  EncoderValueTransformRotate270 = 15;
  EncoderValueTransformFlipHorizontal = 16;
  EncoderValueTransformFlipVertical = 17;
  EncoderValueMultiFrame = 18;
  EncoderValueLastFrame = 19;
  EncoderValueFlush = 20;
  EncoderValueFrameDimensionTime = 21;
  EncoderValueFrameDimensionResolution = 22;
  EncoderValueFrameDimensionPage = 23;

type
  TDQPLGDIPlus = class
  private
    FPiggyBack: Boolean;
  public
    GDIPlusHandle: HMODULE;  // = 0;
    GDIPlusStatus: TGDIPlusStatus; // = gpUndefined;

    // General
    GdiplusStartup: function(var Token: TQPLIntPtr; InputBuf: PGDIPlusStartupInput; OutputBuf: PGDIPlusStartupOutput): TGPStatus; stdcall;
    GdiplusShutdown: procedure(Token: TQPLIntPtr); stdcall;

    // Graphics
    GdipCreateFromHDC: function(DC: HDC; var Graphics: TQPLIntPtr): TGPStatus; stdcall;
    GdipDeleteGraphics: function(Graphics: TQPLIntPtr): TGPStatus; stdcall;
    GdipSetSmoothingMode: function(Graphics: TQPLIntPtr; SmoothingMode: TGPSmoothingMode): TGPStatus; stdcall;
    GdipSetPixelOffsetMode: function(Graphics: TQPLIntPtr; PixelOffsetMode: TGPPixelOffsetMode): TGPStatus; stdcall;
    GdipSetInterpolationMode: function(Graphics: TQPLIntPtr; InterpolationMode: TGPInterpolationMode): TGPStatus; stdcall;
    GdipSetCompositingMode: function(Graphics: TQPLIntPtr; CompositingMode: TGPCompositingMode): TGPStatus; stdcall;
    GdipSetCompositingQuality: function(Graphics: TQPLIntPtr; CompositingQuality: TGPCompositingQuality): TGPStatus; stdcall;
    GdipSetPageUnit: function(Graphics: TQPLIntPtr; PageUnit: TGPUnit): TGPStatus; stdcall;
    GdipGetImageGraphicsContext: function(Image: TQPLIntPtr; var Graphics: TQPLIntPtr): TGPStatus; stdcall;
    GdipGraphicsClear: function(Graphics: TQPLIntPtr; Color: Cardinal): TGPStatus; stdcall;

    // Regions
    GdipCreateRegion: function(var Region: TQPLIntPtr): TGPStatus; stdcall;
    GdipGetClip: function(Graphics, Region: TQPLIntPtr): TGPStatus; stdcall;
    GdipDeleteRegion: function(Region: TQPLIntPtr): TGPStatus; stdcall;
    GdipSetClipRegion: function(Graphics, Region: TQPLIntPtr; CombineMode: TGPCombineMode): TGPStatus; stdcall;

    // Paths
    GdipCreatePath: function(FillMode: TGPFillMode; var Path: TQPLIntPtr): TGPStatus; stdcall;
    GdipDeletePath: function(Path: TQPLIntPtr): TGPStatus; stdcall;
    GdipAddPathLine: function(Path: TQPLIntPtr; x1, y1, x2, y2: Single): TGPStatus; stdcall;
    GdipClosePathFigure: function(Path: TQPLIntPtr): TGPStatus; stdcall;
    GdipAddPathBezier: function(Path: TQPLIntPtr; X1, Y1, X2, Y2, X3, Y3, X4, Y4: Single): TGPStatus; stdcall;
    GdipFillPath: function(Graphics, Brush, Path: TQPLIntPtr): TGPStatus; stdcall;
    GdipDrawPath: function(Graphics, Pen, Path: TQPLIntPtr): TGPStatus; stdcall;
    GdipSetPathFillMode: function(Path: TQPLIntPtr; FillMode: TGPFillMode): TGPStatus; stdcall;
    GdipSetClipPath: function(Graphics, Path: TQPLIntPtr; CombineMode: TGPCombineMode): TGPStatus; stdcall;
    GdipStartPathFigure: function(Path: TQPLIntPtr): TGPStatus; stdcall;
    GdipGetPointCount: function(Path: TQPLIntPtr; var Count: Integer): TGPStatus; stdcall;
    GdipGetVisibleClipBounds: function(Graphics: TQPLIntPtr; ClipRect: PGPRectF): TGPStatus; stdcall;
    GdipGetPathWorldBounds: function(Path: TQPLIntPtr; Bounds: PGPRectF; Matrix,Pen: TQPLIntPtr): TGPStatus; stdcall;
    GdipCreatePath2: function(Points: PGPPointF; PointTypes: PByte; PointCount: Integer; FillMode: TGPFillMode; var Path: TQPLIntPtr): TGPStatus; stdcall;

    // Brushes
    GdipCreateSolidFill: function(Color: Cardinal; var Brush: TQPLIntPtr): TGPStatus; stdcall;
    GdipDeleteBrush: function(Brush: TQPLIntPtr): TGPStatus; stdcall;
    GdipCreateLineBrush: function(Point1, Point2: PGPPointF; Color1, Color2: Cardinal; WrapMode: Integer; var LineGradient: TQPLIntPtr): TGPStatus; stdcall;
    GdipSetLinePresetBlend: function(Brush: TQPLIntPtr; Colors, Positions: Pointer; Count: Cardinal): TGPStatus; stdcall;
    GdipSetLineTransform: function(Brush, Matrix: TQPLIntPtr): TGPStatus; stdcall;
    GdipCreateTexture2: function(Image: TQPLIntPtr; Wrapmode: Integer; X, Y, Width, Height: Single; var TextureBrush: TQPLIntPtr): TGPStatus; stdcall;
    GdipSetTextureTransform: function(TextureBrush, Matrix: TQPLIntPtr): TGPStatus; stdcall;
    GdipMultiplyTextureTransform: function(TextureBrush, Matrix: TQPLIntPtr; MatrixOrder: Integer): TGPStatus; stdcall;
    GdipScaleTextureTransform: function(TextureBrush: TQPLIntPtr; ScaleX, ScaleY: Single; MatrixOrder: Integer): TGPStatus; stdcall;

    // Pens
    GdipCreatePen1: function(Color: Cardinal; Width: Single; WidthUnit: TGPUnit; var Pen: TQPLIntPtr): TGPStatus; stdcall;
    GdipDeletePen: function(Pen: TQPLIntPtr): TGPStatus; stdcall;
    GdipSetPenDashArray: function(Pen: TQPLIntPtr; Dash: TGPDashArray; Count: Integer): TGPStatus; stdcall;
    GdipSetPenDashOffset: function(Pen: TQPLIntPtr; Offset: Single): TGPStatus; stdcall;
    GdipSetPenLineJoin: function(Pen: TQPLIntPtr; LineJoin: TGPLineJoin): TGPStatus; stdcall;
    GdipSetPenStartCap: function(Pen: TQPLIntPtr; StartCap: TGPLineCap): TGPStatus; stdcall;
    GdipSetPenEndCap: function(Pen: TQPLIntPtr; EndCap: TGPLineCap): TGPStatus; stdcall;
    GdipSetPenMiterLimit: function(Pen: TQPLIntPtr; MiterLimit: Single): TGPStatus; stdcall;
    GdipSetPenDashCap197819: function(Pen: TQPLIntPtr; DashCap: TGPDashCap): TGPStatus; stdcall;

    //GdipSetPenTransform: function(Pen: TQPLIntPtr; PenMatrix: Pointer): TGPStatus; stdcall;
    GdipSetPenTransform: function(Pen: TQPLIntPtr; PenMatrix: TQPLIntPtr): TGPStatus; stdcall;
    GdipGetPenTransform: function(Pen: TQPLIntPtr; PenMatrix: TQPLIntPtr): TGPStatus; stdcall;
    GdipGetMatrixElements: function(Matrix: TQPLIntPtr; Elements: Pointer): TGPStatus; stdcall;
    GdipSetMatrixElements: function(Matrix: TQPLIntPtr; m11, m12, m21, m22, dx, dy: Single): TGPStatus; stdcall;
    GdipResetPenTransform: function(Pen: TQPLIntPtr): TGPStatus; stdcall;
    GdipScalePenTransform: function(Pen: TQPLIntPtr; sx, sy: Single; MatrixOrder: Integer): TGPStatus; stdcall;
    GdipSetWorldTransform: function(Graphics: TQPLIntPtr; Matrix: TQPLIntPtr): TGPStatus; stdcall;
    
    // Images
    GdipLoadImageFromStream: function(Stream: IStream; var Image: TQPLIntPtr): TGPStatus; stdcall;
    GdipLoadImageFromStreamICM: function(Stream: IStream; var Image: TQPLIntPtr): TGPStatus; stdcall;
    GdipSaveImageToStream: function(Image: TQPLIntPtr; Stream: IStream; const Encoder: PGUID; const EncoderParams: PGPEncoderParameters): TGPStatus; stdcall;
    GdipLoadImageFromFile: function(FileName: PWChar; var Image: TQPLIntPtr): TGPStatus; stdcall;
    GdipSaveImageToFile: function(Image: TQPLIntPtr; FileName: PWChar; const Encoder: PGUID; const EncoderParams: PGPEncoderParameters): TGPStatus; stdcall;
    GdipDisposeImage: function(Image: TQPLIntPtr): TGPStatus; stdcall;
    GdipDrawImageRect: function(Graphics, Image: TQPLIntPtr; X, Y, Width, Height: Single): TGPStatus; stdcall;
    GdipDrawImagePoints: function(Graphics, Image: TQPLIntPtr; Points: Pointer; Count: Integer): TGPStatus; stdcall;
    GdipDrawImagePointsRect: function(Graphics, Image: TQPLIntPtr; Points: Pointer; Count: Integer; SrcX, SrcY, SrcWidth, SrcHeight: Single; SrcUnit: TGPUnit; ImageAttr: TQPLIntPtr; Abort, CallbackData: Pointer): TGPStatus; stdcall;
    GdipDrawImageI: function(Graphics, Image: TQPLIntPtr; X, Y: Integer): TGPStatus; stdcall;
    GdipDrawImageRectI: function(Graphics, Image: TQPLIntPtr; X, Y, Width, Height: Integer): TGPStatus; stdcall;
    GdipDrawImagePointRectI: function(Graphics, Image: TQPLIntPtr; X, Y, SrcX, SrcY, SrcWidth, SrcHeight: Integer; SrcUnit: TGPUnit): TGPStatus; stdcall;
    GdipGetImageDimension: function(Image: TQPLIntPtr; var Width, Height: Single): TGPStatus; stdcall;
    GdipGetImageWidth: function(Image: TQPLIntPtr; var Width: Integer): TGPStatus; stdcall;
    GdipGetImageHeight: function(Image: TQPLIntPtr; var Height: Integer): TGPStatus; stdcall;
    GdipGetImageHorizontalResolution: function(Image: TQPLIntPtr; var Resolution: Single): TGPStatus; stdcall;
    GdipGetImageVerticalResolution: function(Image: TQPLIntPtr; var Resolution: Single): TGPStatus; stdcall;
    GdipGetImagePixelFormat: function(Image: TQPLIntPtr; var PixelFormat: Integer): TGPStatus; stdcall;
    GdipImageGetFrameDimensionsCount: function(Image: TQPLIntPtr; var Count: Cardinal): TGPStatus; stdcall;
    GdipImageGetFrameDimensionsList: function(Image: TQPLIntPtr; const DimensionIDs: PGUID; Count: Cardinal): TGPStatus; stdcall;
    GdipImageGetFrameCount: function(Image: TQPLIntPtr; const DimensionID: PGUID; var Count: Cardinal): TGPStatus; stdcall;
    GdipImageSelectActiveFrame: function(Image: TQPLIntPtr; const DimensionID: PGUID; FrameIndex: Cardinal): TGPStatus; stdcall;

    // Image attributes
    GdipSetImageAttributesColorKeys: function(ImageAttr: TQPLIntPtr; ColorAdjustType: TGPColorAdjustType; EnableFlag: LongBool; ColorLow, ColorHigh: Cardinal): TGPStatus; stdcall;
    GdipCreateImageAttributes: function(var ImageAttr: TQPLIntPtr): TGPStatus; stdcall;
    GdipDisposeImageAttributes: function(ImageAttr: TQPLIntPtr): TGPStatus; stdcall;
    GdipSetImageAttributesColorMatrix: function(ImageAttr: TQPLIntPtr; ColorAdjustType: TGPColorAdjustType; EnableFlag: LongBool; ColorMatrix: Pointer; GrayMatrix: Pointer; MatrixFlags: TGPColorMatrixFlags): TGPStatus; stdcall;

    // Image encoders
    GdipGetImageEncodersSize: function(var NumEncoders, Size: Integer): TGPStatus; stdcall;
    GdipGetImageEncoders: function(NumEncoders, Size: Integer; ImageCodecInfo: PGPImageCodecInfo): TGPStatus; stdcall;
    GdipGetEncoderParameterListSize: function(Image: TQPLIntPtr; const Encoder: PGUID; var Size: Cardinal) : TGPStatus; stdcall;
    GdipGetEncoderParameterList: function(Image: TQPLIntPtr; const Encoder: PGUID; Size: Cardinal; const EncoderParams: PGPEncoderParameters) : TGPStatus; stdcall;
    GdipGetPropertyItem: function(Image: TQPLIntPtr; PropId: Integer; PropSize: Cardinal; Buffer: TQPLIntPtr): TGPStatus; stdcall;
    GdipSetPropertyItem: function(Image: TQPLIntPtr; var Item: TGdiplusPropertyItem): TGPStatus; stdcall;
    GdipGetPropertyCount: function(Image: TQPLIntPtr; var numProperties: Cardinal): TGPStatus; stdcall;
    GdipGetAllPropertyItems: function(Image: TQPLIntPtr; var TotalBufferSize:Cardinal; var numProperties: Cardinal; AllItems: PGdiplusPropertyItem): TGPStatus; stdcall;

    // Metafiles
    GdipRecordMetafileFileName: function(FileName: PWCHAR; ReferenceHDC: HDC;
      EmfType: TGPMetafileType; FrameRect: PGPRectF; FrameUnit: TGPMetafileFrameUnit;
      Description: PWCHAR; var Metafile: TQPLIntPtr): TGPStatus; stdcall;
    GdipRecordMetafileStream: function(Stream: IStream; ReferenceHDC: HDC;
      EmfType: TGPMetafileType; FrameRect: PGPRectF; FrameUnit: TGPMetafileFrameUnit;
      Description: PWCHAR; var Metafile: TQPLIntPtr): TGPStatus; stdcall;

    // Bitmaps
    GdipCreateBitmapFromGraphics: function(Width, Height: Integer;
      Graphics: TQPLIntPtr; var Bitmap: TQPLIntPtr): TGPStatus; stdcall;
    GdipCreateBitmapFromScan0: function(Width, Height, Stride: Integer;
      PixelFormat: TGPPixelFormat; scan0: Pointer; var Bitmap: TQPLIntPtr): TGPStatus; stdcall;
    GdipCreateBitmapFromGdiDib: function(BitmapInfo: PBitmapInfo; GdiBitmapData: Pointer; var Bitmap: TQPLIntPtr): TGPStatus; stdcall;
    GdipCreateBitmapFromHBITMAP: function(hbm: HBITMAP; hpal: HPALETTE; var Bitmap: TQPLIntPtr): TGPStatus; stdcall;
    GdipBitmapSetResolution: function(Bitmap: TQPLIntPtr; xdpi, ydpi: Single): TGPStatus; stdcall;

    // Matrix functions
    GdipCreateMatrix2: function(m11, m12, m21, m22, dx, dy: Single; var Matrix: TQPLIntPtr): TGPStatus; stdcall;
    GdipInvertMatrix: function(Matrix: TQPLIntPtr): TGPStatus; stdcall;

    // Font and test functions
    GdipCreateFontFromDC: function(SourceDC: HDC; var Font: TQPLIntPtr): TGPStatus; stdcall;
    GdipDrawDriverString: function(Graphics: TQPLIntPtr; Text: PWideChar; Length: Integer; Font: TQPLIntPtr; Brush: TQPLIntPtr; Positions: PSingle; Flags: Integer; Matrix: TQPLIntPtr): TGPStatus; stdcall;
    //GdipDeleteFont: function(Font: TQPLIntPtr): TGPStatus; stdcall;

    constructor Create; virtual;
    destructor Destroy; override;
    function GDIPlusLoad(FileName: PWideChar; AllowPiggyBack: Boolean): TGDIPlusStatus;
    procedure GDIPlusFree;
    function GetEncoderClsid(const Format: WideString; var Clsid: TGUID): Boolean;
    function SelectImagePage(Image: TQPLIntPtr; Page: Cardinal): TGPStatus;
    property PiggyBack: Boolean read FPiggyBack;
  end;

implementation

{$IFNDEF QPL_OS_WINDOWS}
function TDQPLGDIPlus.GDIPlusLoad(FileName: PWideChar; AllowPiggyBack: Boolean): TGDIPlusStatus;
begin
  Result := gpMissing;
end;

constructor TDQPLGDIPlus.Create;
begin

end;

destructor TDQPLGDIPlus.Destroy;
begin
  inherited;
end;

procedure TDQPLGDIPlus.GDIPlusFree;
begin

end;
{$ELSE}

function TDQPLGDIPlus.GDIPlusLoad(FileName: PWideChar; AllowPiggyBack: Boolean): TGDIPlusStatus;
var
  LastErrorMode: Cardinal;
  DefaultFileName: WideString;

  procedure AssignProc(var Proc: FARPROC; Name: PAnsiChar);
  begin
    Proc := GetProcAddress(GDIPlusHandle, Name);
    if Proc = nil then GDIPlusStatus := gpIncompatible;
  end;

begin
  GDIPlusFree;

  if (FileName = nil) then
  begin
    DefaultFileName := 'gdiplus.dll';
    FileName := @DefaultFileName[1];
  end;
  try
    if (AllowPiggyBack) then
    begin
      GDIPlusHandle := GetModuleHandleW(FileName);
    end;
    if (GDIPlusHandle > 0) then
    begin
      FPiggyBack := True;
    end else
    begin
      LastErrorMode := SetErrorMode(SEM_NOOPENFILEERRORBOX or SEM_FAILCRITICALERRORS);
      try
        GDIPlusHandle := LoadLibraryW(FileName);
      finally
        SetErrorMode(LastErrorMode);
      end;
    end;
  except
    GDIPlusHandle := 0;
  end;
  if GDIPlusHandle = 0 then
  begin
    GDIPlusStatus := gpMissing;
  end else
  begin
    GDIPlusStatus := gpReady;
    AssignProc(@GdiplusStartup, 'GdiplusStartup');
    AssignProc(@GdiplusShutdown, 'GdiplusShutdown');
    AssignProc(@GdipCreateFromHDC, 'GdipCreateFromHDC');
    AssignProc(@GdipDeleteGraphics, 'GdipDeleteGraphics');
    AssignProc(@GdipCreatePath, 'GdipCreatePath');
    AssignProc(@GdipDeletePath, 'GdipDeletePath');
    AssignProc(@GdipAddPathLine, 'GdipAddPathLine');
    AssignProc(@GdipFillPath, 'GdipFillPath');
    AssignProc(@GdipCreateSolidFill, 'GdipCreateSolidFill');
    AssignProc(@GdipDeleteBrush, 'GdipDeleteBrush');
    AssignProc(@GdipSetSmoothingMode, 'GdipSetSmoothingMode');
    AssignProc(@GdipSetPixelOffsetMode, 'GdipSetPixelOffsetMode');    
    AssignProc(@GdipAddPathBezier, 'GdipAddPathBezier');
    AssignProc(@GdipClosePathFigure, 'GdipClosePathFigure');
    AssignProc(@GdipCreatePen1, 'GdipCreatePen1');
    AssignProc(@GdipDeletePen, 'GdipDeletePen');
    AssignProc(@GdipDrawPath, 'GdipDrawPath');
    AssignProc(@GdipLoadImageFromStream, 'GdipLoadImageFromStream');
    AssignProc(@GdipSaveImageToStream, 'GdipSaveImageToStream');
    AssignProc(@GdipDisposeImage, 'GdipDisposeImage');
    AssignProc(@GdipDrawImageRect, 'GdipDrawImageRect');
    AssignProc(@GdipSetPathFillMode, 'GdipSetPathFillMode');
    AssignProc(@GdipGetPointCount, 'GdipGetPointCount');
    AssignProc(@GdipDrawImagePoints, 'GdipDrawImagePoints');
    AssignProc(@GdipSetClipPath, 'GdipSetClipPath');
    AssignProc(@GdipCreateRegion, 'GdipCreateRegion');
    AssignProc(@GdipGetClip, 'GdipGetClip');
    AssignProc(@GdipDeleteRegion, 'GdipDeleteRegion');
    AssignProc(@GdipSetClipRegion, 'GdipSetClipRegion');
    AssignProc(@GdipSetPageUnit, 'GdipSetPageUnit');
    AssignProc(@GdipStartPathFigure, 'GdipStartPathFigure');
    AssignProc(@GdipSetPenDashArray, 'GdipSetPenDashArray');
    AssignProc(@GdipSetPenDashOffset, 'GdipSetPenDashOffset');
    AssignProc(@GdipSetPenLineJoin, 'GdipSetPenLineJoin');
    AssignProc(@GdipSetPenStartCap, 'GdipSetPenStartCap');
    AssignProc(@GdipSetPenEndCap, 'GdipSetPenEndCap');
    AssignProc(@GdipSetInterpolationMode, 'GdipSetInterpolationMode');
    AssignProc(@GdipDrawImagePointsRect, 'GdipDrawImagePointsRect');
    AssignProc(@GdipSetImageAttributesColorKeys, 'GdipSetImageAttributesColorKeys');
    AssignProc(@GdipCreateImageAttributes, 'GdipCreateImageAttributes');
    AssignProc(@GdipDisposeImageAttributes, 'GdipDisposeImageAttributes');
    AssignProc(@GdipGetImageDimension, 'GdipGetImageDimension');
    AssignProc(@GdipGetImageHorizontalResolution, 'GdipGetImageHorizontalResolution');
    AssignProc(@GdipGetImageVerticalResolution, 'GdipGetImageVerticalResolution');
    AssignProc(@GdipGetImageEncodersSize, 'GdipGetImageEncodersSize');
    AssignProc(@GdipGetImageEncoders, 'GdipGetImageEncoders');
    AssignProc(@GdipRecordMetafileFileName, 'GdipRecordMetafileFileName');
    AssignProc(@GdipRecordMetafileStream, 'GdipRecordMetafileStream');
    AssignProc(@GdipGetImageGraphicsContext, 'GdipGetImageGraphicsContext');
    AssignProc(@GdipLoadImageFromStreamICM, 'GdipLoadImageFromStreamICM');
    AssignProc(@GdipSetPenMiterLimit, 'GdipSetPenMiterLimit');
    AssignProc(@GdipDrawImageI, 'GdipDrawImageI');
    AssignProc(@GdipDrawImageRectI, 'GdipDrawImageRectI');
    AssignProc(@GdipDrawImagePointRectI, 'GdipDrawImagePointRectI');
    AssignProc(@GdipGetImageWidth, 'GdipGetImageWidth');
    AssignProc(@GdipGetImageHeight, 'GdipGetImageHeight');
    AssignProc(@GdipSetCompositingMode, 'GdipSetCompositingMode');
    AssignProc(@GdipSetCompositingQuality, 'GdipSetCompositingQuality');
    AssignProc(@GdipSaveImageToFile, 'GdipSaveImageToFile');
    AssignProc(@GdipLoadImageFromFile, 'GdipLoadImageFromFile');
    AssignProc(@GdipGetImagePixelFormat, 'GdipGetImagePixelFormat');
    AssignProc(@GdipCreateBitmapFromGraphics, 'GdipCreateBitmapFromGraphics');
    AssignProc(@GdipCreateBitmapFromScan0, 'GdipCreateBitmapFromScan0');
    AssignProc(@GdipGraphicsClear, 'GdipGraphicsClear');
    AssignProc(@GdipCreateBitmapFromGdiDib, 'GdipCreateBitmapFromGdiDib');
    AssignProc(@GdipCreateBitmapFromHBITMAP, 'GdipCreateBitmapFromHBITMAP');
    AssignProc(@GdipGetPropertyItem, 'GdipGetPropertyItem');
    AssignProc(@GdipSetPropertyItem, 'GdipSetPropertyItem');
    AssignProc(@GdipGetEncoderParameterListSize, 'GdipGetEncoderParameterListSize');
    AssignProc(@GdipGetEncoderParameterList, 'GdipGetEncoderParameterList');
    AssignProc(@GdipBitmapSetResolution, 'GdipBitmapSetResolution');
    AssignProc(@GdipGetPropertyCount, 'GdipGetPropertyCount');
    AssignProc(@GdipGetAllPropertyItems, 'GdipGetAllPropertyItems');
    AssignProc(@GdipBitmapSetResolution, 'GdipBitmapSetResolution');
    AssignProc(@GdipSetPenDashCap197819, 'GdipSetPenDashCap197819');
    AssignProc(@GdipImageGetFrameDimensionsCount, 'GdipImageGetFrameDimensionsCount');
    AssignProc(@GdipImageGetFrameDimensionsList, 'GdipImageGetFrameDimensionsList');
    AssignProc(@GdipImageGetFrameCount, 'GdipImageGetFrameCount');
    AssignProc(@GdipImageSelectActiveFrame, 'GdipImageSelectActiveFrame');
    AssignProc(@GdipSetImageAttributesColorMatrix, 'GdipSetImageAttributesColorMatrix');
    AssignProc(@GdipCreateLineBrush, 'GdipCreateLineBrush');
    AssignProc(@GdipSetLinePresetBlend, 'GdipSetLinePresetBlend');
    AssignProc(@GdipCreateMatrix2, 'GdipCreateMatrix2');
    AssignProc(@GdipInvertMatrix, 'GdipInvertMatrix');
    AssignProc(@GdipSetLineTransform, 'GdipSetLineTransform');
    AssignProc(@GdipGetVisibleClipBounds, 'GdipGetVisibleClipBounds');
    AssignProc(@GdipCreateTexture2, 'GdipCreateTexture2');
    AssignProc(@GdipSetTextureTransform, 'GdipSetTextureTransform');
    AssignProc(@GdipMultiplyTextureTransform, 'GdipMultiplyTextureTransform');
    AssignProc(@GdipScaleTextureTransform, 'GdipScaleTextureTransform');
    AssignProc(@GdipSetPenTransform, 'GdipSetPenTransform');

    AssignProc(@GdipGetPenTransform, 'GdipGetPenTransform');
    AssignProc(@GdipGetMatrixElements, 'GdipGetMatrixElements');
    AssignProc(@GdipSetMatrixElements, 'GdipSetMatrixElements');
    AssignProc(@GdipResetPenTransform, 'GdipResetPenTransform');
    AssignProc(@GdipScalePenTransform, 'GdipScalePenTransform');
    AssignProc(@GdipSetWorldTransform, 'GdipSetWorldTransform');

    AssignProc(@GdipGetPathWorldBounds, 'GdipGetPathWorldBounds');
    AssignProc(@GdipCreatePath2, 'GdipCreatePath2');
    AssignProc(@GdipCreateFontFromDC, 'GdipCreateFontFromDC');
    AssignProc(@GdipDrawDriverString, 'GdipDrawDriverString');
    //AssignProc(@GdipDeleteFont, 'GdipDeleteFont');
  end;
  Result := GDIPlusStatus;
end;

procedure TDQPLGDIPlus.GDIPlusFree;
begin
  if ((GDIPlusHandle <> 0) and (not FPiggyBack)) then
  begin
    FreeLibrary(GDIPlusHandle);
  end;
  GDIPlusHandle := 0;
  GDIPlusStatus := gpUndefined;
  FPiggyBack := False;
end;

constructor TDQPLGDIPlus.Create;
begin
  GDIPlusHandle := 0;
  GDIPlusStatus := gpUndefined;
  FPiggyBack := False;
end;

destructor TDQPLGDIPlus.Destroy;
begin
  GDIPlusFree;
end;
{$ENDIF}

function TDQPLGDIPlus.GetEncoderClsid(const Format: WideString; var Clsid: TGUID): Boolean;
var
  Num, Size: Integer;
  Codecs, Item: PGPImageCodecInfo;
  I: Integer;
begin
  Result := False;
  try
    GdipGetImageEncodersSize(Num, Size);
  except
    Size := 0;
  end;
  if (Size > 0) then
  begin
    GetMem(Codecs, Size);
    GdipGetImageEncoders(Num, Size, Codecs);
    Item := Codecs;
    for I := 0 to Num - 1 do
    begin
      if Format = Item.MimeType then
      begin
        Clsid := Item.Clsid;
        Result := True;
        Break;
      end;
      Inc(Item);
    end;
    FreeMem(Codecs);
  end;
end;

function TDQPLGDIPlus.SelectImagePage(Image: TQPLIntPtr; Page: Cardinal): TGPStatus;
var
  FramePage: TGUID;
  Count: Cardinal;
begin
  FramePage.D1 := $7462dc86;
  FramePage.D2 := $6180;
  FramePage.D3 := $4c7e;
  FramePage.D4[0] := $8e;
  FramePage.D4[1] := $3f;
  FramePage.D4[2] := $ee;
  FramePage.D4[3] := $73;
  FramePage.D4[4] := $33;
  FramePage.D4[5] := $a7;
  FramePage.D4[6] := $a4;
  FramePage.D4[7] := $83;

  Result := gsGenericError;
  if (GdipImageGetFrameCount(Image, @FramePage, Count) = gsOk) then
  begin
    if ((Page >= 1) and (Page <= Count)) then
    begin
      Result := GdipImageSelectActiveFrame(Image, @FramePage, Page - 1);
    end;
  end;
end;

initialization

finalization

end.
