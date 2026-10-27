{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryImageDecoder.pas                       }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryImageDecoder;

{$I DebenuPDFLibraryDefines.inc}

interface

{$IFDEF VER120}
  {$DEFINE NOJPEG2000}
{$ENDIF}

{$IFDEF VER130}
  {$DEFINE NOJPEG2000}
{$ENDIF}

{$IFDEF WIN64}
//  {$DEFINE NOJPEG2000}
{$ENDIF}

{$IFDEF QPL_NOVCL}
  {$DEFINE NOJPEG2000}
{$ENDIF}

uses
  DebenuPDFLibraryStructure, DebenuPDFLibraryPicasso,
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
{$IFDEF QPL_OS_MAC}
  Types,
{$ENDIF}
  Classes, DebenuPDFLibraryMatrix, DebenuPDFLibraryTypes,
  DebenuPDFLibraryColorManagement, DebenuPDFLibraryImageList, DebenuPDFLibraryExtra,
  DebenuPDFLibraryImageTransform;

type
  TPDFInlineImage = record
    Width: Integer;
    Height: Integer;
    BitsPerComponent: Integer;
    ColorSpace: AnsiString;
    ColorSpaceObj: TPDFObject;
    Filter: AnsiString;
    DecodeParms: AnsiString;
    ImageData: AnsiString;
    ImageStart: Integer;
    ImageEnd: Integer;
    ImageMask: Boolean;
    Decode: AnsiString;
    TokPos: Integer;
  end;

  TPDFMaskType = (mtNone, mtStencil, mtExplicit, mtSoft, mtColorKey);

  TPDFImageDecodeMode = (dmToBitmap, dmToNative, dmToDPLR);

  TPDFImageDecoder = class
  private
    FSource: TPDFStream;
    FParentStructure: TPDFStructure;
    FWidth: Integer;
    FHeight: Integer;
    FColorSpace: AnsiString;
    FBitmap: TBitmap;
    FFilter: AnsiString;
    FBitsPerComponent: Integer;
    FIndexedBaseColorSpace: AnsiString;
    FIndexedBaseComponents: Integer;
    FIndexedData: AnsiString;
    FIndexedHival: Integer;
    FImageData: AnsiString;
    FDecodeParms: AnsiString;
    FDecode: AnsiString;
    FGDIPlusSettings: TGDIPlusSettings;
    FValidImage: Boolean;
    FMaskBitmap: TBitmap;
    FMaskDecode: AnsiString;
    FMaskColor: array of Double;
    FMaskFormatDesc0: AnsiString;
    FMaskFormatDesc1: AnsiString;
    FOnFindObject: TPDFFindObjectEvent;
    FOnDecrypt: TPDFCryptStreamEvent;
    FOnEncrypt: TPDFCryptStreamEvent;
    FPrivateColorManager: Boolean;
    FColorManager: TPDFColorManager;
    FMaskType: TPDFMaskType;
    FChildMask: Boolean;
    FDecodeMode: TPDFImageDecodeMode;
    FIsImageExtraction: Boolean;
    FNativeType: TPDFImageListItemType;
    FHorizontalSize: Double;
    FVerticalSize: Double;
    FImageStream: TMemoryStream;
    FICCProfile: AnsiString;
    FLabColorSpace: TPDFLabColorSpace;
    FSeparationColorSpace: TPDFSeparationColorSpace;
    FDeviceNColorSpace: TPDFDeviceNColorSpace;
    FOriginalPNGPalette: array[0..1] of TColor;
    FRenderToEPS: Boolean;
    FLoadException: Boolean;
    FDrawException: Boolean;
    FInterpolate: Boolean;

    FDPLRDirect: Boolean;
    FDPLRPointer: Pointer;
    FDPLRLength: Integer;
    FDPLRFormat: Integer;
    FDPLRWidth: Integer;
    FDPLRHeight: Integer;
    FDPLRImageData: TDPLImageByteArray;
    FDPLRMainImage: TDPLImage;
    FDPLRMaskImage: TDPLImage;
    FDPLRPicasso: TPDFPicasso;
    FDPLRPalette: TDPLImageByteArray;
    FIsInlineImage: Boolean;

    function FindColorSpace(O: TPDFObject): AnsiString;
    procedure ProcessImageDict;

    procedure LoadBMP;
    procedure LoadJPEG(DD: TQuickPDFStringList);
    procedure LoadJPEG2000;
    procedure LoadCCITT(DD: TQuickPDFStringList);
    procedure LoadJBIG2(JBIG2Globals: TPDFIndRef);

    procedure LoadDPLRBMP;
    procedure LoadDPLRJPEG(DD: TQuickPDFStringList);
    procedure LoadDPLRCCITT(DD: TQuickPDFStringList);
    procedure LoadDPLRJBIG2(JBIG2Globals: TPDFIndRef);
    procedure LoadDPLRJPEG2000;

    procedure Unfilter;

    procedure ApplyICCProfile(SourceBitmap: TBitmap);
    procedure ConvertLabToRGB(SourceBitmap: TBitmap);
    procedure ConvertSeparationToRGB(SourceBitmap: TBitmap);
    procedure ConvertDeviceNToRGB(SourceBitmap: TBitmap);

    procedure ConvertDPLRLabToRGB;
    procedure ConvertDPLRDeviceNToRGB;
    procedure ConvertDPLRSeparationToRGB;
    procedure ConvertDPLRIndexedToRGB;
    procedure ConvertDPLRCMYKToRGB;
    procedure ConvertDPLRRGBToBGR;
    procedure PrepareDPLRPalette;
    procedure DPLRPostProcess;
    procedure DPLRSetMaxSize(MaxWidth, MaxHeight: Integer; Image: TDPLImage);

{$IFNDEF NOJPEG2000}
    procedure ProcessIndexedColorSpace;
{$ENDIF}
    function GetImageDataSize: Integer;
    procedure SetPNGPalette(PNGStream: TStream; const Operation: AnsiString;
      NewColor: TColor = clBlack);
    function GetGDIPlusSettings: TGDIPlusSettings;
    procedure GenerateDPLRStencilImageData(NewColor: Integer);
  public
    TokPos: Integer;
    OldFillColor: TColor;
    LastFICCProfile: AnsiString;
    LastFICCProfileIndObj: Integer;
    IgnoreICCProfiles: Boolean;
    constructor Create;
    procedure LoadFromPDFStream(Source: TPDFStream);
    procedure LoadFromInlineImage(Img: TPDFInlineImage; ParentStructure: TPDFStructure);
    destructor Destroy; override;
    function FindObject(IndRef: TPDFIndRef): TPDFObject;
    procedure Draw(Picasso: TPDFPicasso; Mat: TPDFXForm; FillColor: TColor);
    procedure SetColorManager(NewColorManager: TPDFColorManager);
    function ImageData: AnsiString;
    function NativeImageData: AnsiString;
    function GetCenterColor: TColor;
    function BitmapAsString: AnsiString;
    function GetFormatDesc(Source: TPDFDictionary; Options: Integer; Child: Boolean): AnsiString;
    function ColorSpaceDesc(O: TPDFObject; var CompCount: Integer): AnsiString; overload;
    function ColorSpaceDesc(O: TPDFObject): AnsiString; overload;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property ColorSpace: AnsiString read FColorSpace;
    property GDIPlusSettings: TGDIPlusSettings read FGDIPlusSettings write FGDIPlusSettings;
    property Bitmap: TBitmap read FBitmap;
    property MaskBitmap: TBitmap read FMaskBitmap;
    property ChildMask: Boolean read FChildMask write FChildMask;
    property MaskType: TPDFMaskType read FMaskType;
    property OnFindObject: TPDFFindObjectEvent read FOnFindObject write FOnFindObject;
    property OnDecrypt: TPDFCryptStreamEvent read FOnDecrypt write FOnDecrypt;
    property OnEncrypt: TPDFCryptStreamEvent read FOnEncrypt write FOnEncrypt;
    property DecodeMode: TPDFImageDecodeMode read FDecodeMode write FDecodeMode;
    property IsImageExtraction: Boolean read FIsImageExtraction write FIsImageExtraction;
    property NativeType: TPDFImageListItemType read FNativeType;
    property HorizontalSize: Double read FHorizontalSize write FHorizontalSize;
    property VerticalSize: Double read FVerticalSize write FVerticalSize;
    property ImageDataSize: Integer read GetImageDataSize;
    property RenderToEPS: Boolean read FRenderToEPS write FRenderToEPS;
    property BitsPerComponent: Integer read FBitsPerComponent;
    property LoadException: Boolean read FLoadException;
    property DrawException: Boolean read FDrawException;
    property DPLRPicasso: TPDFPicasso read FDPLRPicasso write FDPLRPicasso;
  end;

function DecodeInlineImage(const Source: AnsiString; var TokPos: Integer;
  var InlineImage: TPDFInlineImage; ResourceDict: TPDFDictionary;
  FindObjectEvent: TPDFFindObjectEvent): Boolean;

implementation

uses
{$IFDEF WIN64}
  DebenuPDFLibraryJPEGWin64,
{$ELSE}
  DebenuPDFLibraryJPEG,
{$ENDIF}
  DebenuPDFLibraryTIFF, SysUtils, DebenuPDFLibraryFlate, DebenuPDFLibraryLZW, DebenuPDFLibraryAscii85,
  DebenuPDFLibraryPNG, DebenuPDFLibraryJBIG2, DebenuPDFLibraryCCITT,
{$IFNDEF NOJPEG2000}
  DebenuPDFLibraryJpeg2000Bitmap,
{$ENDIF}
  Math;

{ TPDFImageDecoder }

// This function applies the ICC profile stored in FICCProfile to
// the supplied bitmap. First, TPNGWriter is used to create PNG image from the
// bitmap with the color profile embedded as an iCCP chunk.
// The PNG is saved into a memory stream which is then applied to the bitmap
// using the Picasso class.
procedure TPDFImageDecoder.ApplyICCProfile(SourceBitmap: TBitmap);
var
  PNGWriter: TPNGWriter;
  MS: TMemoryStream;
  Picasso: TPDFPicasso;
  TempSettings: TGDIPlusSettings;
begin

  if IgnoreICCProfiles = True then
    exit;

  // Create the memory stream
  MS := TMemoryStream.Create;
  try
    // Create the PNG writer from the bitmap
    PNGWriter := TPNGWriter.Create(SourceBitmap);
    try
      // Add the ICC color profile
      PNGWriter.AddColorProfile(FICCProfile);

      // Release the memory used by the profile
      SetLength(FICCProfile, 0);

      // Save the PNG image to a memory stream
      PNGWriter.SaveToStream(MS);
    finally
      PNGWriter.Free;
    end;

    Picasso := TPDFPicasso.Create;
    try
      SourceBitmap.Canvas.Lock;
      try
        TempSettings := GetGDIPlusSettings;
        Picasso.UseGDIPlusModel(SourceBitmap.Canvas, TempSettings);

        // Rewind the memory stream back to the beginning
        MS.Seek(0, soFromBeginning);

        // Draw the PNG in the memory stream onto the source bitmap with ICM
        // enabled
        Picasso.DrawAnyImage(0, 0, SourceBitmap.Width, SourceBitmap.Height, MS, 1, True);
      finally
        SourceBitmap.Canvas.Unlock;
      end;
    finally
      Picasso.Free;
    end;
  finally
    MS.Free;
  end;
end;

procedure TPDFImageDecoder.ConvertDeviceNToRGB(SourceBitmap: TBitmap);
var
  Row: Integer;
  Col: Integer;
  RowPixels: array of Byte;
  PixelColor: TColor;
  DeviceNColor: TPDFDeviceNColor;
  Offset: Integer;
begin
  if Assigned(FDeviceNColorSpace) then
  begin
    try
      SourceBitmap.PixelFormat := pf24bit;
    except
      FLoadException := True;
    end;

    if (not FLoadException) then
    begin
      SetLength(RowPixels, SourceBitmap.Width * 3);
      SetLength(DeviceNColor, FDeviceNColorSpace.ComponentCount);
      for Row := 0 to SourceBitmap.Height - 1 do
      begin
        Move(SourceBitmap.ScanLine[Row]^, RowPixels[0], Length(RowPixels));
        Offset := 0;
        for Col := 0 to SourceBitmap.Width - 1 do
        begin
          DeviceNColor[0] := RowPixels[Offset] / 255;
          FDeviceNColorSpace.GetColor(DeviceNColor, True);
          PixelColor := FDeviceNColorSpace.ResultColor;
          RowPixels[Offset + 0] := (PixelColor and $FF);
          RowPixels[Offset + 1] := (PixelColor and $FF00) shr 8;
          RowPixels[Offset + 2] := (PixelColor and $FF0000) shr 16;
          Inc(Offset, 3);
        end;
        Move(RowPixels[0], SourceBitmap.ScanLine[Row]^, Length(RowPixels));
      end;
    end;
  end;
end;

// Converts CMYK color to RGB, directly modifying FDPLRMainImage
procedure TPDFImageDecoder.ConvertDPLRCMYKToRGB;
var
  Row: Integer;
  Col: Integer;
  OldImage: TDPLImage;
  CMYK: TPDFCMYKColor;
  RGB: TPDFRGBColor;
  CMYKRowData: array of Byte;
  CMYKIndex: Integer;
  RGBIndex: Integer;
  RGBRowData: array of Byte;
begin
  if (FDPLRMainImage.Components = 4) then
  begin
    FColorSpace := 'DeviceBGR';
    OldImage := FDPLRMainImage;
    FDPLRMainImage := TDPLImage.Create(FDPLRMainImage.Width, FDPLRMainImage.Height, 3, 8);

    // Make sure the old image is 8 bits per component
    OldImage.SetBitsPerComponent(8, True);

    SetLength(RGBRowData, FDPLRMainImage.Width * 3);
    SetLength(CMYKRowData, FDPLRMainImage.Width * 4);

    for Row := 0 to FDPLRMainImage.Height - 1 do
    begin
      CMYKIndex := 0;
      RGBIndex := 0;
      Move(OldImage.GetRowPointer(Row)^, CMYKRowData[0], Length(CMYKRowData));
      for Col := 0 to FDPLRMainImage.Width - 1 do
      begin
        CMYK.Cyan := Ord(CMYKRowData[CMYKIndex]) / 255;
        CMYK.Magenta := Ord(CMYKRowData[CMYKIndex + 1]) / 255;
        CMYK.Yellow := Ord(CMYKRowData[CMYKIndex + 2]) / 255;
        CMYK.Black := Ord(CMYKRowData[CMYKIndex + 3]) / 255;
        RGB := FColorManager.CMYK2RGB(CMYK);
        RGBRowData[RGBIndex + 2] := Round(RGB.Red * 255);
        RGBRowData[RGBIndex + 1] := Round(RGB.Green * 255);
        RGBRowData[RGBIndex] := Round(RGB.Blue * 255);
        Inc(CMYKIndex, 4);
        Inc(RGBIndex, 3);
      end;
      Move(RGBRowData[0], FDPLRMainImage.GetRowPointer(Row)^, Length(RGBRowData));
    end;

    OldImage.Free;
  end;
end;

// Converts DeviceN color to RGB, directly modifying FDPLRMainImage
// Single channel image is converted to a three channel image
procedure TPDFImageDecoder.ConvertDPLRDeviceNToRGB;
var
  Row: Integer;
  Col: Integer;
  OldImage: TDPLImage;
  DeviceN: TPDFDeviceNColor;
  RGB: Integer;
  DeviceNRowData: array of Byte;
  DeviceNIndex: Integer;
  RGBIndex: Integer;
  RGBRowData: array of Byte;
  CX: Integer;
begin
  if (Assigned(FDeviceNColorSpace)) then
  begin
    if (FDPLRMainImage.Components = FDeviceNColorSpace.ComponentCount) then
    begin
      FColorSpace := 'DeviceBGR';
      OldImage := FDPLRMainImage;
      FDPLRMainImage := TDPLImage.Create(FDPLRMainImage.Width, FDPLRMainImage.Height, 3, 8);

      // Make sure the old image is 8 bits per component
      OldImage.SetBitsPerComponent(8, True);

      SetLength(RGBRowData, FDPLRMainImage.Width * 3);
      SetLength(DeviceNRowData, FDPLRMainImage.Width * FDeviceNColorSpace.ComponentCount);
      SetLength(DeviceN, FDeviceNColorSpace.ComponentCount);

      for Row := 0 to FDPLRMainImage.Height - 1 do
      begin
        DeviceNIndex := 0;
        RGBIndex := 0;
        Move(OldImage.GetRowPointer(Row)^, DeviceNRowData[0], Length(DeviceNRowData));
        for Col := 0 to FDPLRMainImage.Width - 1 do
        begin
          for CX := 0 to FDeviceNColorSpace.ComponentCount - 1 do
          begin
            DeviceN[CX] := Ord(DeviceNRowData[DeviceNIndex + CX]) / 255;
          end;
          FDeviceNColorSpace.GetColor(DeviceN, True);
          RGB := FDeviceNColorSpace.ResultColor;
          RGBRowData[RGBIndex + 2] := RGB and $FF;
          RGBRowData[RGBIndex + 1] := (RGB and $FF00) shr 8;
          RGBRowData[RGBIndex] := (RGB and $FF0000) shr 16;
          Inc(DeviceNIndex, FDeviceNColorSpace.ComponentCount);
          Inc(RGBIndex, 3);
        end;
        Move(RGBRowData[0], FDPLRMainImage.GetRowPointer(Row)^, Length(RGBRowData));
      end;

      OldImage.Free;
    end;
  end;
end;

// Converts Indexed color to RGB, directly modifying FDPLRMainImage
// Single channel image is converted to a three channel image
procedure TPDFImageDecoder.ConvertDPLRIndexedToRGB;
var
  X: Integer;
  Palette: TDPLImageByteArray;
  RGBColor: TPDFRGBColor;
  CMYKColor: TPDFCMYKColor;
  LabColor: TPDFLabColor;
  ColorCount: Integer;
  PixelValue: Byte;
  ScaledL: array[0..255] of Double;
  ScaledA: array[0..255] of Double;
  ScaledB: array[0..255] of Double;
begin
  if ((FColorSpace = 'Indexed') and
    ((FIndexedBaseColorSpace = 'DeviceGray') or (FIndexedBaseColorSpace = 'CalGray')) {and
    (FBitsPerComponent = 8)}) then
  begin
    SetLength(Palette, Length(FIndexedData) * 3);
    for X := 0 to Length(FIndexedData) - 1 do
    begin
      Palette[X * 3 + 0] := Ord(FIndexedData[X + 1]);
      Palette[X * 3 + 1] := Ord(FIndexedData[X + 1]);
      Palette[X * 3 + 2] := Ord(FIndexedData[X + 1]);
    end;
    FDPLRMainImage.ApplyPalette(Palette);
    FColorSpace := 'DeviceGray';
  end else
  if ((FColorSpace = 'Indexed') and
    ((FIndexedBaseColorSpace = 'DeviceRGB') or (FIndexedBaseColorSpace = 'CalRGB'))) then
  begin
    FDPLRMainImage.SetBitsPerComponent(8, False);
    SetLength(Palette, Length(FIndexedData));
    Move(FIndexedData[1], Palette[0], Length(FIndexedData));
    FDPLRMainImage.ApplyPalette(Palette);
    FColorSpace := 'DeviceRGB';
  end else
  if ((FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'Lab')) then
  begin
    ColorCount := Length(FIndexedData) div 3;
    SetLength(Palette, ColorCount * 3);
    for PixelValue := 0 to 255 do
    begin
      ScaledL[PixelValue] := (PixelValue * 100) / 255;
      ScaledA[PixelValue] := FLabColorSpace.ScaleA(PixelValue, 255);
      ScaledB[PixelValue] := FLabColorSpace.ScaleB(PixelValue, 255);
    end;
    for X := 0 to ColorCount - 1 do
    begin
      LabColor.L := ScaledL[Ord(FIndexedData[X * 3 + 1])];
      LabColor.a := ScaledA[Ord(FIndexedData[X * 3 + 2])];
      LabColor.b := ScaledB[Ord(FIndexedData[X * 3 + 3])];
      RGBColor := FColorManager.Lab2RGB(LabColor);
      Palette[X * 3] := Round(RGBColor.Red * 255);
      Palette[X * 3 + 1] := Round(RGBColor.Green * 255);
      Palette[X * 3 + 2] := Round(RGBColor.Blue * 255);
    end;
    FDPLRMainImage.ApplyPalette(Palette);
    FColorSpace := 'DeviceRGB';
  end else
  if ((FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceCMYK') {and
    (FBitsPerComponent = 8)}) then
  begin
    ColorCount := Length(FIndexedData) div 4;
    SetLength(Palette, ColorCount * 3);
    for X := 0 to ColorCount - 1 do
    begin
      CMYKColor.Cyan := Ord(FIndexedData[X * 4 + 1]) / 255;
      CMYKColor.Magenta := Ord(FIndexedData[X * 4 + 2]) / 255;
      CMYKColor.Yellow := Ord(FIndexedData[X * 4 + 3]) / 255;
      CMYKColor.Black := Ord(FIndexedData[X * 4 + 4]) / 255;
      RGBColor := FColorManager.CMYK2RGB(CMYKColor);
      Palette[X * 3] := Round(RGBColor.Red * 255);
      Palette[X * 3 + 1] := Round(RGBColor.Green * 255);
      Palette[X * 3 + 2] := Round(RGBColor.Blue * 255);
    end;
    FDPLRMainImage.ApplyPalette(Palette);
    FColorSpace := 'DeviceRGB';
  end else
  if ((FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceGray') and
    (FBitsPerComponent = 1)) then
  begin

  end;
end;

// Converts Lab color to RGB, directly modifying FDPLRMainImage
procedure TPDFImageDecoder.ConvertDPLRLabToRGB;
var
  Row: Integer;
  Col: Integer;
  RowPixels: array of Byte;
  LabColor: TPDFLabColor;
  PixelRGBColor: TPDFRGBColor;
  PixelValue: Byte;
  ScaledL: array[0..255] of Double;
  ScaledA: array[0..255] of Double;
  ScaledB: array[0..255] of Double;
  Offset: Integer;
begin
  if (Assigned(FLabColorSpace) and Assigned(FDPLRMainImage) and
    (FDPLRMainImage.Components = 3) and (FDPLRMainImage.BitsPerComponent = 8)) then
  begin
    for PixelValue := 0 to 255 do
    begin
      ScaledL[PixelValue] := (PixelValue * 100) / 255;
      ScaledA[PixelValue] := FLabColorSpace.ScaleA(PixelValue, 255);
      ScaledB[PixelValue] := FLabColorSpace.ScaleB(PixelValue, 255);
    end;
    LabColor.L := 0;
    LabColor.a := 0;
    LabColor.b := 0;
    FLabColorSpace.GetColor(LabColor, FColorManager);

    SetLength(RowPixels, FDPLRMainImage.Stride);
    for Row := 0 to FDPLRMainImage.Height - 1 do
    begin
      Move(FDPLRMainImage.GetRowPointer(Row)^, RowPixels[0], Length(RowPixels));
      Offset := 0;
      for Col := 0 to FDPLRMainImage.Width - 1 do
      begin
        LabColor.L := ScaledL[RowPixels[Offset + 2]];
        LabColor.a := ScaledA[RowPixels[Offset + 1]];
        LabColor.b := ScaledB[RowPixels[Offset + 0]];
        PixelRGBColor := FColorManager.Lab2RGB(LabColor);
        RowPixels[Offset + 2] := Round(PixelRGBColor.Blue * 255);
        RowPixels[Offset + 1] := Round(PixelRGBColor.Green * 255);
        RowPixels[Offset + 0] := Round(PixelRGBColor.Red * 255);
        Inc(Offset, 3);
      end;
      Move(RowPixels[0], FDPLRMainImage.GetRowPointer(Row)^, Length(RowPixels));
    end;
    FColorSpace := 'DeviceRGB';
  end;
end;

procedure TPDFImageDecoder.ConvertDPLRRGBToBGR;
var
  Row: Integer;
  Col: Integer;
  RowData: array of Byte;
  Temp: Integer;
  Index: Integer;
begin
  if ((FDPLRMainImage.Components = 3) and (FDPLRMainImage.BitsPerComponent = 8)) then
  begin
    SetLength(RowData, FDPLRMainImage.Width * 3);
    for Row := 0 to FDPLRMainImage.Height - 1 do
    begin
      Move(FDPLRMainImage.GetRowPointer(Row)^, RowData[0], Length(RowData));
      Index := 0;
      for Col := 0 to FDPLRMainImage.Width - 1 do
      begin
        Temp := RowData[Index];
        RowData[Index] := RowData[Index + 2];
        RowData[Index + 2] := Temp;
        Inc(Index, 3);
      end;
      Move(RowData[0], FDPLRMainImage.GetRowPointer(Row)^, Length(RowData));
    end;
  end;
end;

// Converts Separation color to RGB, directly modifying FDPLRMainImage
procedure TPDFImageDecoder.ConvertDPLRSeparationToRGB;
var
  Palette: TDPLImageByteArray;
  Col: Integer;
  PixelColor: Integer;
  OldFixedGamma: Boolean;
begin
  if (Assigned(FSeparationColorSpace) and Assigned(FDPLRMainImage) and
    (FDPLRMainImage.Components = 1) and (FDPLRMainImage.BitsPerComponent = 8)) then
  begin
    // Set the color manager to use the simple CMYK->RGB conversion from the
    // PDF specification, this seems to be the correct one to use for
    // separation images with a /DeviceCMYK alternate color space
    OldFixedGamma := FColorManager.FixedGamma;
    try
      FColorManager.FixedGamma := False;
      SetLength(Palette, 256 * 3);
      for Col := 0 to 255 do
      begin
        FSeparationColorSpace.GetColor(Col / 255, True);
        PixelColor := FSeparationColorSpace.ResultColor;
        Palette[Col * 3 + 0] := (PixelColor and $FF0000) shr 16;
        Palette[Col * 3 + 1] := (PixelColor and $FF00) shr 8;
        Palette[Col * 3 + 2] := (PixelColor and $FF);
      end;
      FDPLRMainImage.ApplyPalette(Palette);
    finally
      FColorManager.FixedGamma := OldFixedGamma;
    end;
  end;
end;

procedure TPDFImageDecoder.ConvertLabToRGB(SourceBitmap: TBitmap);
var
  Row: Integer;
  Col: Integer;
  RowPixels: array of Byte;
  LabColor: TPDFLabColor;
  PixelRGBColor: TPDFRGBColor;
  PixelValue: Byte;
  ScaledL: array[0..255] of Double;
  ScaledA: array[0..255] of Double;
  ScaledB: array[0..255] of Double;
  Offset: Integer;
begin
  if Assigned(FLabColorSpace) then
  begin
    for PixelValue := 0 to 255 do
    begin
      ScaledL[PixelValue] := (PixelValue * 100) / 255;
      ScaledA[PixelValue] := FLabColorSpace.ScaleA(PixelValue, 255);
      ScaledB[PixelValue] := FLabColorSpace.ScaleB(PixelValue, 255);
    end;
    LabColor.L := 0;
    LabColor.a := 0;
    LabColor.b := 0;
    FLabColorSpace.GetColor(LabColor, FColorManager);
    if (SourceBitmap.PixelFormat <> pf24bit) then
    begin
      try
        SourceBitmap.PixelFormat := pf24bit;
      except
        FLoadException := True;
      end;
    end;
    if (not FLoadException) then
    begin
      SetLength(RowPixels, SourceBitmap.Width * 3);
      for Row := 0 to SourceBitmap.Height - 1 do
      begin
        Move(SourceBitmap.ScanLine[Row]^, RowPixels[0], Length(RowPixels));
        Offset := 0;
        for Col := 0 to SourceBitmap.Width - 1 do
        begin
          LabColor.L := ScaledL[RowPixels[Offset + 2]];
          LabColor.a := ScaledA[RowPixels[Offset + 1]];
          LabColor.b := ScaledB[RowPixels[Offset + 0]];
          PixelRGBColor := FColorManager.Lab2RGB(LabColor);
          RowPixels[Offset + 0] := Round(PixelRGBColor.Blue * 255);
          RowPixels[Offset + 1] := Round(PixelRGBColor.Green * 255);
          RowPixels[Offset + 2] := Round(PixelRGBColor.Red * 255);
          Inc(Offset, 3);
        end;
        Move(RowPixels[0], SourceBitmap.ScanLine[Row]^, Length(RowPixels));
      end;
    end;
  end;
end;

procedure TPDFImageDecoder.ConvertSeparationToRGB(SourceBitmap: TBitmap);
var
  Row: Integer;
  Col: Integer;
  RowPixels: array of Byte;
  PixelColor: TColor;
  Offset: Integer;
  IndexedRGB: array of array[0..2] of byte;
begin
  if Assigned(FSeparationColorSpace) then
  begin
    try
      SourceBitmap.PixelFormat := pf24bit;
    except
      FLoadException := True;
    end;
    if (not FLoadException) then
    begin
      SetLength(RowPixels, SourceBitmap.Width * 3);

      SetLength(IndexedRGB, 256);
      for Col := 0 to 255 do
      begin
        FSeparationColorSpace.GetColor(Col / 255, True);
        PixelColor := FSeparationColorSpace.ResultColor;
        IndexedRGB[Col][0] := (PixelColor and $FF0000) shr 16;
        IndexedRGB[Col][1] := (PixelColor and $FF00) shr 8;
        IndexedRGB[Col][2] := (PixelColor and $FF);
      end;

      for Row := 0 to SourceBitmap.Height - 1 do
      begin
        Move(SourceBitmap.ScanLine[Row]^, RowPixels[0], Length(RowPixels));
        Offset := 0;
        for Col := 0 to SourceBitmap.Width - 1 do
        begin
          Move(IndexedRGB[RowPixels[Offset]][0], RowPixels[Offset], 3);
          Inc(Offset, 3);
        end;
        Move(RowPixels[0], SourceBitmap.ScanLine[Row]^, Length(RowPixels));
      end;
    end;
  end;
end;

function TPDFImageDecoder.BitmapAsString: AnsiString;
var
  MS: TMemoryStream;
begin
  if (Assigned(FBitmap)) then
  begin
    MS := TMemoryStream.Create;
    try
      FBitmap.Canvas.Lock;
      try
        FBitmap.SaveToStream(MS);
      finally
        FBitmap.Canvas.Unlock;
      end;
      MS.Seek(0, soFromBeginning);
      SetLength(Result, MS.Size);
      MS.Read(Result[1], Length(Result));
    finally
      MS.Free;
    end;
  end else
  begin
    Result := '';
  end;
end;

constructor TPDFImageDecoder.Create;
begin
  FWidth := 0;
  FHeight := 0;
  FBitmap := TBitmap.Create;
  FLoadException := False;
  FDrawException := False;
  FDPLRDirect := False;
  FDPLRPointer := nil;
  FDPLRLength := 0;
  FDPLRFormat := 0;
  FDPLRWidth := 0;
  FDPLRHeight := 0;
  SetLength(FDPLRPalette, 0);

  DefaultGDIPlusSettings(FGDIPlusSettings);

  FValidImage := False;
  FMaskBitmap := nil;
  FPrivateColorManager := True;
  FColorManager := TPDFSimpleColorManager.Create;
  FMaskType := mtNone;
  FMaskFormatDesc0 := '';
  FMaskFormatDesc1 := '';
  FChildMask := False;
  FDecodeMode := dmToBitmap;
  FNativeType := nitUnknown;
  FIsImageExtraction := False;
  FImageStream := nil;
  FInterpolate := True;
  FIsInlineImage := False;

  OldFillColor := clBlack;
end;

destructor TPDFImageDecoder.Destroy;
begin
  if (Assigned(FBitmap)) then
  begin
    FBitmap.Free;
  end;
  if (Assigned(FMaskBitmap)) then
  begin
    FMaskBitmap.Free;
  end;
  if (FPrivateColorManager) then
  begin
    FColorManager.Free;
  end;
  if (Assigned(FImageStream)) then
  begin
    FImageStream.Free;
  end;
  if (Assigned(FLabColorSpace)) then
  begin
    FLabColorSpace.Free;
  end;
  if (Assigned(FSeparationColorSpace)) then
  begin
    FSeparationColorSpace.Free;
  end;
  if (Assigned(FDeviceNColorSpace)) then
  begin
    FDeviceNColorSpace.Free;
  end;
  if (Assigned(FDPLRMainImage)) then
  begin
    FDPLRMainImage.Free;
  end;
  if (Assigned(FDPLRMaskImage)) then
  begin
    FDPLRMaskImage.Free;
  end;
  inherited;
end;

procedure TPDFImageDecoder.DPLRPostProcess;
var
  Palette: TDPLImageByteArray;
  PX: Integer;
  InlineStencil: Boolean;
begin
  if (Assigned(FDPLRMainImage)) then
  begin
    InlineStencil := FIsInlineImage and (FMaskType = mtStencil);
    if (FColorSpace = 'DeviceGray') then
    begin
      if (InlineStencil) then
      begin
        FDPLRMainImage.Invert;
      end;
      if (FBitsPerComponent = 1) then
      begin
        if (FMaskType <> mtSoft) then
        begin
          FDPLRMainImage.Invert;
        end;
      end else
      begin
        FDPLRMainImage.SetBitsPerComponent(8, True);
      end;
      if (QPLStartsWith(FDecode, '[ 1 0')) then
      begin
        FDecode := '';
        FDPLRMainImage.Invert;
      end;
    end else
    if (FColorSpace = 'DeviceRGB') then
    begin
      FDPLRMainImage.SetBitsPerComponent(8, True);
      if (QPLStartsWith(FDecode, '[ 1 0')) then
      begin
        FDecode := '';
        FDPLRMainImage.Invert;
      end else
      begin

      end;
    end else
    if (FColorSpace = 'DeviceCMYK') then
    begin
      FDPLRMainImage.SetBitsPerComponent(8, True);
      if (QPLStartsWith(FDecode, '[ 1 0')) then
      begin
        FDecode := '';
        FDPLRMainImage.Invert;
      end else
      begin

      end;
      ConvertDPLRCMYKToRGB;
    end else
    if (FColorSpace = 'Lab') then
    begin
      FDPLRMainImage.SetBitsPerComponent(8, True);
      ConvertDPLRLabToRGB;
    end else
    if (FColorSpace = 'DeviceN') then
    begin
      ConvertDPLRDeviceNToRGB;
    end else
    if (FColorSpace = 'Indexed') then
    begin
      if ((QPLStartsWith(FDecode, '[ 0')) or (FDecode = '')) then
      begin

      end else
      begin
        FDPLRMainImage.Invert;
        FDecode := '';
      end;
      if ((FIndexedBaseColorSpace = 'DeviceRGB') and (FMaskType = mtNone)) then
      begin
        PrepareDPLRPalette;
        if (FDPLRMainImage.BitsPerComponent > 1) then
        begin
          FDPLRMainImage.SetBitsPerComponent(8, False);
        end;
      end else
      begin
        ConvertDPLRIndexedToRGB;
      end;
    end else
    if (FColorSpace = 'Separation') then
    begin
      if (QPLStartsWith(FDecode, '[ 1 0')) then
      begin
        FDPLRMainImage.Invert;
        FDecode := '';
      end else
      begin

      end;
      ConvertDPLRSeparationToRGB;
    end;

    if (FMaskType = mtStencil) then
    begin
      // Set up the palette
      SetLength(FDPLRPalette, 8);
      if (QPLStartsWith(FDecode, '[ 1 0')) then
      begin
        FDPLRPalette[0] := 0;
        FDPLRPalette[1] := 0;
        FDPLRPalette[2] := 0;
        FDPLRPalette[3] := 0;
        FDPLRPalette[4] := 0;
        FDPLRPalette[5] := 0;
        FDPLRPalette[6] := 0;
        FDPLRPalette[7] := 255;
      end else
      begin
        FDPLRPalette[0] := 0;
        FDPLRPalette[1] := 0;
        FDPLRPalette[2] := 0;
        FDPLRPalette[3] := 255;
        FDPLRPalette[4] := 0;
        FDPLRPalette[5] := 0;
        FDPLRPalette[6] := 0;
        FDPLRPalette[7] := 0;
      end;
    end else
    if ((FMaskType = mtSoft) or (FMaskType = mtExplicit)) then
    begin
      // Combine the mask and the image

      if ((FDPLRMainImage.BitsPerComponent > 1) and (FDPLRMainImage.Components = 1)) then
      begin
        // Now convert to 8-bit using a 256 entry palette
        SetLength(Palette, 256 * 3);
        for PX := 0 to 255 do
        begin
          Palette[PX * 3] := PX;
          Palette[PX * 3 + 1] := PX;
          Palette[PX * 3 + 2] := PX;
        end;
        FDPLRMainImage.ApplyPalette(Palette);
      end else
      if ((FDPLRMainImage.BitsPerComponent = 1) and (FDPLRMainImage.Components = 1)) then
      begin
        // Main image is mono, have to convert to RGB to combine
        // with alpha. The result might be too large, scale down
        // if necessary first
        DPLRSetMaxSize(6000, 6000, FDPLRMainImage);

        // Now convert to 8-bit using a two entry palette
        SetLength(Palette, 6);
        Palette[0] := 0;
        Palette[1] := 0;
        Palette[2] := 0;
        Palette[3] := 255;
        Palette[4] := 255;
        Palette[5] := 255;
        FDPLRMainImage.ApplyPalette(Palette);
      end;

      if (FDPLRMaskImage.BitsPerComponent = 1) then
      begin
        if (FMaskType = mtExplicit) or (FMaskType = mtSoft) then
        begin
          FDPLRMaskImage.Invert;
        end;
        // Mask image is mono, have to convert to 8-bit to be used
        // as alpha. The result might be too large, scale down
        // if necessary first
        DPLRSetMaxSize(6000, 6000, FDPLRMaskImage);
        FDPLRMaskImage.SetBitsPerComponent(8, True);
      end;

      if ((FDPLRMaskImage.Width <> FDPLRMainImage.Width) or
        (FDPLRMaskImage.Height <> FDPLRMainImage.Height)) then
      begin
        // Make the mask and main image the same size
        if (FDPLRMaskImage.Width > FDPLRMainImage.Width) then
        begin
          FDPLRMainImage.SetSizeScale(FDPLRMaskImage.Width,
            FDPLRMaskImage.Height, tmNearestNeighbour);
        end else
        begin
          FDPLRMaskImage.SetSizeScale(FDPLRMainImage.Width,
            FDPLRMainImage.Height, tmNearestNeighbour);
        end;
      end;

      if (FColorSpace = 'DeviceBGR') then
      begin
        FColorSpace := 'DeviceRGB';
        ConvertDPLRRGBToBGR;
      end;

      if ((FDPLRMainImage.BitsPerComponent = 8) and
        (FDPLRMainImage.Components = 3) and
        (FDPLRMaskImage.BitsPerComponent = 8) and
        (FDPLRMaskImage.Components = 1)) then
      begin
        // Both are 8-bit and we are combining RGB with image data
        FDPLRMainImage.AddComponentFromImage(FDPLRMaskImage);
        FDPLRMaskImage.Free;
        FDPLRMaskImage := nil;
      end;
    end;

    if ((FDPLRMainImage.Components = 3) and (FDPLRMainImage.BitsPerComponent = 8) and (FColorSpace = 'DeviceRGB')) then
    begin
      // Swap red and blue for DPLR DLL
      ConvertDPLRRGBToBGR;
    end;
  end;
end;

procedure TPDFImageDecoder.DPLRSetMaxSize(MaxWidth, MaxHeight: Integer; Image: TDPLImage);
var
  Scale: Double;
  NewWidth: Integer;
  NewHeight: Integer;
begin
  if (Assigned(Image)) then
  begin
    if ((Image.Width > MaxWidth) or (Image.Height > MaxHeight)) then
    begin
      if (Image.Width > Image.Height) then
      begin
        Scale := MaxWidth / Image.Width;
        NewWidth := MaxWidth;
        NewHeight := Trunc(Scale * Image.Height);
      end else
      begin
        Scale := MaxHeight / Image.Width;
        NewHeight := MaxHeight;
        NewWidth := Trunc(Scale * Image.Width);
      end;

      Image.SetSizeScale(NewWidth, NewHeight, tmNearestNeighbour);
    end;
  end;
end;

procedure TPDFImageDecoder.Draw(Picasso: TPDFPicasso; Mat: TPDFXForm; FillColor: TColor);
var
  TX: Double;
  TY: Double;
  TopLeftX: Double;
  TopLeftY: Double;
  TopRightX: Double;
  TopRightY: Double;
  BottomLeftX: Double;
  BottomLeftY: Double;
  PNGWriter: TPNGWriter;
  ReverseMask: Boolean;
  Scaled: TBitmap;
  ScaleP: TPDFPicasso;
  CMYK: TPDFCMYKColor;
  RGB: TPDFRGBColor;
  MaskColorMin, MaskColorMax: Cardinal;
  MaxX, MaxY: Integer;
  SinglePixelColor: TColor;
  TempSettings: TGDIPlusSettings;

  procedure Translate(X, Y: Double);
  begin
    TX := Mat.eM11 * X + Mat.eM21 * Y + Mat.eDx;
    TY := Mat.eM12 * X + Mat.eM22 * Y + Mat.eDy;
  end;

begin
  MaskColorMin := 0;
  MaskColorMax := 0;
  if FMaskType = mtColorKey then
  begin
    if (FColorSpace = 'DeviceCMYK') and (Length(FMaskColor) = 8) then
    begin
      CMYK.Cyan := FMaskColor[0] / 255;
      CMYK.Magenta := FMaskColor[2] / 255;
      CMYK.Yellow := FMaskColor[4] / 255;
      CMYK.Black := FMaskColor[6] / 255;
      if QPLStartsWith(FDecode, '[ 1 0') then
      begin
        CMYK.Cyan := 1 - CMYK.Cyan;
        CMYK.Magenta := 1 - CMYK.Magenta;
        CMYK.Yellow := 1 - CMYK.Yellow;
        CMYK.Black := 1 - CMYK.Black;
      end;
      RGB := FColorManager.CMYK2RGB(CMYK);
      MaskColorMin := FColorManager.RGB2Color(RGB);
      CMYK.Cyan := FMaskColor[1] / 255;
      CMYK.Magenta := FMaskColor[3] / 255;
      CMYK.Yellow := FMaskColor[5] / 255;
      CMYK.Black := FMaskColor[7] / 255;
      if QPLStartsWith(FDecode, '[ 1 0') then
      begin
        CMYK.Cyan := 1 - CMYK.Cyan;
        CMYK.Magenta := 1 - CMYK.Magenta;
        CMYK.Yellow := 1 - CMYK.Yellow;
        CMYK.Black := 1 - CMYK.Black;
      end;
      RGB := FColorManager.CMYK2RGB(CMYK);
      MaskColorMax := FColorManager.RGB2Color(RGB);
    end;

    if (FColorSpace = 'DeviceRGB') and (Length(FMaskColor) = 6) then
    begin
      RGB.Red := FMaskColor[4] / 255;
      RGB.Green := FMaskColor[2] / 255;
      RGB.Blue := FMaskColor[0] / 255;
      MaskColorMin := FColorManager.RGB2Color(RGB);
      RGB.Red := FMaskColor[5] / 255;
      RGB.Green := FMaskColor[3] / 255;
      RGB.Blue := FMaskColor[1] / 255;
      MaskColorMax := FColorManager.RGB2Color(RGB);
    end;

    if (FColorSpace = 'DeviceBGR') and (Length(FMaskColor) = 6) then
    begin
      RGB.Blue := FMaskColor[4] / 255;
      RGB.Green := FMaskColor[2] / 255;
      RGB.Red := FMaskColor[0] / 255;
      MaskColorMin := FColorManager.RGB2Color(RGB);
      RGB.Blue := FMaskColor[5] / 255;
      RGB.Green := FMaskColor[3] / 255;
      RGB.Red := FMaskColor[1] / 255;
      MaskColorMax := FColorManager.RGB2Color(RGB);
    end;

    if (FColorSpace = 'DeviceGray') and (Length(FMaskColor) = 2) then
    begin
      RGB.Red := FMaskColor[0] / 255;
      RGB.Green := FMaskColor[0] / 255;
      RGB.Blue := FMaskColor[0] / 255;
      MaskColorMin := FColorManager.RGB2Color(RGB);
      RGB.Red := FMaskColor[1] / 255;
      RGB.Green := FMaskColor[1] / 255;
      RGB.Blue := FMaskColor[1] / 255;
      MaskColorMax := FColorManager.RGB2Color(RGB);
    end;
  end;

  if (DecodeMode = dmToDPLR) then
  begin
    if (Assigned(FDPLRMainImage)) then
    begin
      if (FMaskType = mtStencil) then
      begin
        FDPLRPalette[0] := (FillColor and $FF0000) shr 16;
        FDPLRPalette[1] := (FillColor and $FF00) shr 8;
        FDPLRPalette[2] := (FillColor and $FF);
        FDPLRPalette[4] := (FillColor and $FF0000) shr 16;
        FDPLRPalette[5] := (FillColor and $FF00) shr 8;
        FDPLRPalette[6] := (FillColor and $FF);
        GenerateDPLRStencilImageData(FillColor);
      end;
      if ((FDPLRMainImage.BitsPerComponent = 1) and (FDPLRMainImage.Components = 1)) then
      begin
        if (FMaskType = mtStencil) and (Assigned(Picasso.FillPattern) and (Integer(Picasso.FillPattern.PDFPatternType) <> 0)) then
        begin
          Picasso.DrawStencilImage(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
            FDPLRMainImage.Width, FDPLRMainImage.Height,
            5,   // 1-bit indexed
            @FDPLRPalette[0], FInterpolate);
        end else
        if (Length(FDPLRPalette) > 0) then
        begin
          if FMaskType = mtColorKey then
            Picasso.DrawDirectImageWithPalette(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
              FDPLRMainImage.Width, FDPLRMainImage.Height, 5,   // 1-bit indexed
              @FDPLRPalette[0], FInterpolate, MaskColorMin, MaskColorMax)
          else
            Picasso.DrawDirectImageWithPalette(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
              FDPLRMainImage.Width, FDPLRMainImage.Height, 5,   // 1-bit indexed
              @FDPLRPalette[0], FInterpolate, -1, -1);
        end else
        begin
          if FMaskType = mtColorKey then
            Picasso.DrawDirectImage(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
              FDPLRMainImage.Width, FDPLRMainImage.Height, 3,  // Mono/bitonal
              FInterpolate, MaskColorMin, MaskColorMax)
          else
            Picasso.DrawDirectImage(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
              FDPLRMainImage.Width, FDPLRMainImage.Height, 3,  // Mono/bitonal
              FInterpolate, -1, -1);
        end;
      end else
      if ((FDPLRMainImage.BitsPerComponent = 8) and (FDPLRMainImage.Components = 1)) then
      begin
        if (Length(FDPLRPalette) > 0) then
        begin
          if FMaskType = mtColorKey then
            Picasso.DrawDirectImageWithPalette(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
              FDPLRMainImage.Width, FDPLRMainImage.Height, 4,   // 8-bit indexed
              @FDPLRPalette[0], FInterpolate, MaskColorMin, MaskColorMax)
          else
            Picasso.DrawDirectImageWithPalette(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
              FDPLRMainImage.Width, FDPLRMainImage.Height, 4,   // 8-bit indexed
              @FDPLRPalette[0], FInterpolate, -1, -1)
        end else
        begin
          if FMaskType = mtColorKey then
            Picasso.DrawDirectImage(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
              FDPLRMainImage.Width, FDPLRMainImage.Height, 2,  // Gray
              FInterpolate, MaskColorMin, MaskColorMax)
          else
            Picasso.DrawDirectImage(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
              FDPLRMainImage.Width, FDPLRMainImage.Height, 2,  // Gray
              FInterpolate, -1, -1);
        end;
      end else
      if ((FDPLRMainImage.BitsPerComponent = 8) and (FDPLRMainImage.Components = 3)) then
      begin
        if FMaskType = mtColorKey then
          Picasso.DrawDirectImage(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
            FDPLRMainImage.Width, FDPLRMainImage.Height, 1,  // BGR
            FInterpolate, MaskColorMin, MaskColorMax)
        else
          Picasso.DrawDirectImage(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
            FDPLRMainImage.Width, FDPLRMainImage.Height, 1,  // BGR
            FInterpolate, -1, -1);
      end else
      if ((FDPLRMainImage.BitsPerComponent = 8) and (FDPLRMainImage.Components = 4)) then
      begin
        if FMaskType = mtColorKey then
          Picasso.DrawDirectImage(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
            FDPLRMainImage.Width, FDPLRMainImage.Height, 0,  // BGR + Alpha
            FInterpolate, MaskColorMin, MaskColorMax)
        else
          Picasso.DrawDirectImage(FDPLRMainImage.GetDataPointer, FDPLRMainImage.Stride,
            FDPLRMainImage.Width, FDPLRMainImage.Height, 0,  // BGR + Alpha
            FInterpolate, -1, -1);
      end;
    end;
  end else
  if (FValidImage) then
  try
    Translate(0, 1);
    TopLeftX := TX;
    TopLeftY := TY;
    Translate(1, 1);
    TopRightX := TX;
    TopRightY := TY;
    Translate(0, 0);
    BottomLeftX := TX;
    BottomLeftY := TY;

    if not Assigned(FImageStream) then
    begin
      FImageStream := TMemoryStream.Create;
      if Assigned(FMaskBitmap) then
      begin
        if (FMaskBitmap.Width <> FBitmap.Width) or (FMaskBitmap.Height <> FBitmap.Height) then
        begin
          if FMaskBitmap.Width > FBitmap.Width then MaxX := FMaskBitmap.Width
            else MaxX := FBitmap.Width;
          if FMaskBitmap.Height > FBitmap.Height then MaxY := FMaskBitmap.Height
            else MaxY := FBitmap.Height;

          if (FBitmap.Width <> MaxX) or (FBitmap.Height <> MaxY) then
          begin
            if ((FBitmap.Width = 1) and (FBitmap.Height = 1)) then
            begin
              FBitmap.Canvas.Lock;
              try
                SinglePixelColor := FBitmap.Canvas.Pixels[0, 0];
                try
                  FBitmap.PixelFormat := pf24bit;
                  FBitmap.Width := MaxX;
                  FBitmap.Height := MaxY;
                except
                  FDrawException := True;
                  Exit;
                end;
                FBitmap.Canvas.Brush.Color := SinglePixelColor;
{$IFNDEF QPL_CPP}
                FBitmap.Canvas.FillRect(Rect(0, 0, MaxX, MaxY));
{$ENDIF}
              finally
                FBitmap.Canvas.Unlock;
              end;
            end else
            begin
              Scaled := TBitmap.Create;
              ScaleP := TPDFPicasso.Create;
              try
                try
                  Scaled.PixelFormat := pf24bit;
                  Scaled.Width := MaxX;
                  Scaled.Height := MaxY;
                  Scaled.Canvas.Lock;
                except
                  FDrawException := True;
                  Exit;
                end;
                TempSettings := GetGDIPlusSettings;
                ScaleP.UseGDIPlusModel(Scaled.Canvas, TempSettings);
                ScaleP.DrawImage(0, 0, Scaled.Width + 1, Scaled.Height + 1, FBitmap);
                FBitmap.Assign(Scaled);
              finally
                ScaleP.Free;
                Scaled.Free;
              end;
            end;
          end;

          if (FMaskBitmap.Width <> MaxX) or (FMaskBitmap.Height <> MaxY) then
          begin
            Scaled := TBitmap.Create;
            ScaleP := TPDFPicasso.Create;
            try
              try
                Scaled.PixelFormat := pf24bit;
                Scaled.Width := MaxX;
                Scaled.Height := MaxY;
                Scaled.Canvas.Lock;
              except
                FDrawException := True;
                Exit;
              end;
              TempSettings := GetGDIPlusSettings;
              ScaleP.UseGDIPlusModel(Scaled.Canvas, TempSettings);
              ScaleP.DrawImage(0, 0, Scaled.Width + 1, Scaled.Height + 1, FMaskBitmap);
              FMaskBitmap.Assign(Scaled);
            finally
              ScaleP.Free;
              Scaled.Free;
            end;
          end;
        end;

//        FWidth := FBitmap.Width;
//        FHeight := FBitmap.Height;

        PNGWriter := TPNGWriter.Create(FBitmap);
        try
          ReverseMask := False;
          if (FMaskType = mtStencil) then
            ReverseMask := QPLStartsWith(FMaskDecode, '[ 1 0');
          if FMaskType = mtExplicit then
            ReverseMask := QPLStartsWith(FMaskDecode, '[ 1 0');
          if (FMaskType = mtSoft) then
            ReverseMask := QPLStartsWith(FMaskDecode, '[ 1 0');
          if Assigned(FMaskBitmap) then
            PNGWriter.SetAlphaChannel(FMaskBitmap, ReverseMask);
          PNGWriter.SaveToStream(FImageStream);
        finally
          PNGWriter.Free;
        end;
      end else
      begin
        FBitmap.Canvas.Lock;
        try
          FBitmap.SaveToStream(FImageStream);
        finally
          FBitmap.Canvas.Unlock;
        end;
      end;
    end;

    if Assigned(FImageStream) then
    begin
      FImageStream.Seek(0, soFromBeginning);
      if FMaskType = mtColorKey then
      begin
        {
        MaskColorMin := 0;
        MaskColorMax := 0;
        if (FColorSpace = 'DeviceCMYK') and (Length(FMaskColor) = 8) then
        begin
          CMYK.Cyan := FMaskColor[0] / 255;
          CMYK.Magenta := FMaskColor[2] / 255;
          CMYK.Yellow := FMaskColor[4] / 255;
          CMYK.Black := FMaskColor[6] / 255;
          if QPLStartsWith(FDecode, '[ 1 0') then
          begin
            CMYK.Cyan := 1 - CMYK.Cyan;
            CMYK.Magenta := 1 - CMYK.Magenta;
            CMYK.Yellow := 1 - CMYK.Yellow;
            CMYK.Black := 1 - CMYK.Black;
          end;
          RGB := FColorManager.CMYK2RGB(CMYK);
          MaskColorMin := FColorManager.RGB2Color(RGB);
          CMYK.Cyan := FMaskColor[1] / 255;
          CMYK.Magenta := FMaskColor[3] / 255;
          CMYK.Yellow := FMaskColor[5] / 255;
          CMYK.Black := FMaskColor[7] / 255;
          if QPLStartsWith(FDecode, '[ 1 0') then
          begin
            CMYK.Cyan := 1 - CMYK.Cyan;
            CMYK.Magenta := 1 - CMYK.Magenta;
            CMYK.Yellow := 1 - CMYK.Yellow;
            CMYK.Black := 1 - CMYK.Black;
          end;
          RGB := FColorManager.CMYK2RGB(CMYK);
          MaskColorMax := FColorManager.RGB2Color(RGB);
        end;

        if (FColorSpace = 'DeviceRGB') and (Length(FMaskColor) = 6) then
        begin
          RGB.Red := FMaskColor[4] / 255;
          RGB.Green := FMaskColor[2] / 255;
          RGB.Blue := FMaskColor[0] / 255;
          MaskColorMin := FColorManager.RGB2Color(RGB);
          RGB.Red := FMaskColor[5] / 255;
          RGB.Green := FMaskColor[3] / 255;
          RGB.Blue := FMaskColor[1] / 255;
          MaskColorMax := FColorManager.RGB2Color(RGB);
        end;

        if (FColorSpace = 'DeviceGray') and (Length(FMaskColor) = 2) then
        begin
          RGB.Red := FMaskColor[0] / 255;
          RGB.Green := FMaskColor[0] / 255;
          RGB.Blue := FMaskColor[0] / 255;
          MaskColorMin := FColorManager.RGB2Color(RGB);
          RGB.Red := FMaskColor[1] / 255;
          RGB.Green := FMaskColor[1] / 255;
          RGB.Blue := FMaskColor[1] / 255;
          MaskColorMax := FColorManager.RGB2Color(RGB);
        end;  }

        Picasso.DrawAnyImagePointsChroma(TopLeftX, TopLeftY, TopRightX, TopRightY,
          BottomLeftX, BottomLeftY, FImageStream, FBitmap.Width, FBitmap.Height, MaskColorMin, MaskColorMax);
      end else
      if FMaskType = mtStencil then
      begin
        SetPNGPalette(FImageStream, 'SetTrans', FillColor);
        Picasso.DrawAnyImagePoints(TopLeftX, TopLeftY, TopRightX, TopRightY,
          BottomLeftX, BottomLeftY, FImageStream);
        SetPNGPalette(FImageStream, 'Reset');
      end else
      begin
        Picasso.DrawAnyImagePoints(TopLeftX, TopLeftY, TopRightX, TopRightY,
          BottomLeftX, BottomLeftY, FImageStream);
      end;
    end;
  except
  end;
end;

procedure TPDFImageDecoder.GenerateDPLRStencilImageData(NewColor: Integer);
var
  Row: Integer;
  Col: Integer;
  MaxCol: Integer;
  RowValues: TDPLImageIntegerArray;
  RedByte: Integer;
  GreenByte: Integer;
  BlueByte: Integer;
  Index: Integer;
begin
  if (Assigned(FDPLRMainImage) and (FDPLRMainImage.Components = 4) and
    (FDPLRMainImage.BitsPerComponent = 8)) then
  begin
    MaxCol := FDPLRMainImage.Width - 1;
    RedByte := NewColor and $FF;
    GreenByte := (NewColor and $FF00) shr 8;
    BlueByte := (NewColor and $FF0000) shr 16;
    for Row := 0 to FDPLRMainImage.Height - 1 do
    begin
      FDPLRMainImage.GetRowValues(Row, RowValues);
      Index := 0;
      for Col := 0 to MaxCol do
      begin
        RowValues[Index] := RedByte;
        RowValues[Index + 1] := GreenByte;
        RowValues[Index + 2] := BlueByte;
        Inc(Index, 4);
      end;
      FDPLRMainImage.SetRowValues(Row, RowValues);
    end;
  end;
end;

function TPDFImageDecoder.GetCenterColor: TColor;
var
  X: Integer;
  Y: Integer;
begin
  if (Assigned(FBitmap)) then
  begin
    X := FWidth div 2;
    Y := FHeight div 2;
    FBitmap.Canvas.Lock;
    try
      Result := FBitmap.Canvas.Pixels[X, Y];
    finally
      FBitmap.Canvas.Unlock;
    end;
  end else
  begin
    Result := clBlack;
  end;
end;

function TPDFImageDecoder.GetGDIPlusSettings: TGDIPlusSettings;
begin
  Result := FGDIPlusSettings;
  Result.DLLAllowPiggyBack := True;
  Result.DLLStartup := dsNotIfPiggyback;
end;

function TPDFImageDecoder.FindColorSpace(O: TPDFObject): AnsiString;
var
  Family: AnsiString;
  ColorSpace: TPDFArray;
  IR: TPDFIndRef;
begin
  if O is TPDFName then Result := TPDFName(O).Name;
  if O is TPDFArray then
  begin
    ColorSpace := TPDFArray(O);
    if ColorSpace.Count >= 1 then
    begin
      O := ColorSpace.Item[0];
      if O is TPDFName then
      begin
        Family := TPDFName(O).Name;
        if Family = 'DeviceGray' then
        begin
          Result := 'DeviceGray';
        end else
        if Family = 'DeviceCMYK' then
        begin
          Result := 'DeviceCMYK';
        end else
        if Family = 'CalRGB' then
        begin
          Result := 'DeviceRGB';
        end else
        if Family = 'CalGray' then
        begin
          Result := 'DeviceGray';
        end else
        if Family = 'DeviceRGB' then
        begin
          Result := 'DeviceRGB';
        end else
        if Family = 'Indexed' then
        begin
          O := ColorSpace.Item[1];
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          FIndexedBaseColorSpace := FindColorSpace(O);

          if (FIndexedBaseColorSpace = 'DeviceN') then  // Get the count of DeviceN components
          begin
            if (O is TPDFArray) and (TPDFArray(O).Count >= 2) then
              O := TPDFArray(O).Item[1];
            if (O is TPDFArray) then
              FIndexedBaseComponents := TPDFArray(O).Count;
          end;

          O := ColorSpace.Item[2];
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          if O is TPDFNumeric then
            FIndexedHival := TPDFNumeric(O).AsInteger
          else
            FIndexedHival := -1;
          O := ColorSpace.Item[3];
          IR := nil;
          if O is TPDFIndRef then
          begin
            IR := TPDFIndRef(O);
            O := FindObject(IR);
          end;
          if O is TPDFString then FIndexedData := TPDFString(O).AsString;
          if O is TPDFStream then
          begin
            if Assigned(FOnDecrypt) and Assigned(IR) then
              FOnDecrypt(TPDFStream(O), IR);
            FIndexedData := TPDFStream(O).GetDecodedStreamWithLookup(FOnFindObject);
            if Assigned(FOnEncrypt) and Assigned(IR) then
              FOnEncrypt(TPDFStream(O), IR);
          end;
          Result := 'Indexed';
        end else
        if (Family = 'ICCBased') then
        begin
          if ColorSpace.Count >= 2 then
          begin
            O := ColorSpace.Item[1];
            if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
            if O is TPDFStream then
            begin
              if (O.IndObjNum = LastFICCProfileIndObj) then
              begin
                FICCProfile := LastFICCProfile;
              end
              else
              begin
                FICCProfile := TPDFStream(O).GetDecodedStreamWithLookup(FOnFindObject);
                FICCProfile := DeflateStr(FICCProfile);
                LastFICCProfile := FICCProfile;
                LastFICCProfileIndObj := O.IndObjNum;
              end;

              O := TPDFStream(O).Dictionary.FindValueByKeyName('Alternate', False);
              if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
              if O is TPDFName then
                Result := TPDFName(O).Name;
            end;

            if Result = '' then
            begin
              O := ColorSpace.Item[1];
              if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
              if O is TPDFStream then
              begin
                O := TPDFStream(O).Dictionary.FindValueByKeyName('N');
                if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
                if O is TPDFNumeric then
                case TPDFNumeric(O).AsInteger of
                  1 : Result := 'DeviceGray';
                  3 : Result := 'DeviceRGB';
                  4 : Result := 'DeviceCMYK';
                end;
              end;
            end;
          end;
        end else
        if (Family = 'DeviceN') then
        begin
          Result := 'DeviceN';
          FDeviceNColorSpace := TPDFDeviceNColorSpace.Create(FColorManager);
          FDeviceNColorSpace.OnFindObject := FOnFindObject;
          FDeviceNColorSpace.LoadFromArray(ColorSpace, '');
        end else
        if (Family = 'Lab') then
        begin
          Result := 'Lab';
          FLabColorSpace := TPDFLabColorSpace.Create;
          FLabColorSpace.OnFindObject := FOnFindObject;
          FLabColorSpace.LoadFromArray(ColorSpace);
        end else
        if (Family = 'Separation') then
        begin
          Result := 'Separation';
          FSeparationColorSpace := TPDFSeparationColorSpace.Create(FColorManager);
          FSeparationColorSpace.OnFindObject := FOnFindObject;
          FSeparationColorSpace.LoadFromArray(ColorSpace, '');
        end;
      end;
    end;
  end;
end;

function TPDFImageDecoder.FindObject(IndRef: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(IndRef)
  else
    Result := IndRef.Obj;
end;

function TPDFImageDecoder.GetImageDataSize: Integer;
begin
  if Assigned(FDPLRMainImage) then
  begin
    Result := FDPLRMainImage.DataSizeBytes;
  end else
  if Assigned(FImageStream) then
  begin
    Result := FImageStream.Size;
  end else
  begin
    Result := Length(FImageData);
  end;
end;

function TPDFImageDecoder.ColorSpaceDesc(O: TPDFObject): AnsiString;
var
  PlaceHolder: Integer;
begin
  Result := ColorSpaceDesc(O, PlaceHolder);
end;

function TPDFImageDecoder.ColorSpaceDesc(O: TPDFObject; var CompCount: Integer): AnsiString;
var
  Family: AnsiString;
  ColorSpace: TPDFArray;
  DescDeviceNColorSpace: TPDFDeviceNColorSpace;
  DescSeparationColorSpace: TPDFSeparationColorSpace;
begin
  Result := '';
  CompCount := 1;
  if O is TPDFName then
  begin
    Family := TPDFName(O).Name;
    if Family = 'DeviceGray' then
    begin
      Result := 'Gray';
      CompCount := 1;
    end else
    if Family = 'DeviceCMYK' then
    begin
      Result := 'CMYK';
      CompCount := 4;
    end else
    if Family = 'CalRGB' then
    begin
      Result := 'RGB';
      CompCount := 3;
    end else
    if Family = 'CalGray' then
    begin
      Result := 'Gray';
      CompCount := 1;
    end else
    if Family = 'DeviceRGB' then
    begin
      Result := 'RGB';
      CompCount := 3;
    end else
    if (Family = 'Lab') then
    begin
      Result := 'Lab';
    end else
    begin
      Result := Family;
    end;
  end;
  if O is TPDFArray then
  begin
    ColorSpace := TPDFArray(O);
    if ColorSpace.Count >= 1 then
    begin
      O := ColorSpace.Item[0];
      if O is TPDFName then
      begin
        Family := TPDFName(O).Name;
        if Family = 'DeviceGray' then
        begin
          Result := 'Gray';
          CompCount := 1;
        end else
        if Family = 'DeviceCMYK' then
        begin
          Result := 'CMYK';
          CompCount := 4;
        end else
        if Family = 'CalRGB' then
        begin
          Result := 'RGB';
          CompCount := 3;
        end else
        if Family = 'CalGray' then
        begin
          Result := 'Gray';
          CompCount := 1;
        end else
        if Family = 'DeviceRGB' then
        begin
          Result := 'RGB';
          CompCount := 3;
        end else
        if Family = 'Indexed' then
        begin
          CompCount := 1;
          Result := 'Indexed[';
          O := ColorSpace.Item[1];
          if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
          Result := Result + ColorSpaceDesc(O);
          Result := Result + ']';
        end else
        if (Family = 'ICCBased') then
        begin
          Result := 'ICC[';
          if ColorSpace.Count >= 2 then
          begin
            O := ColorSpace.Item[1];
            if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
            if O is TPDFStream then
            begin
              O := TPDFStream(O).Dictionary.FindValueByKeyName('Alternate', False);
              if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
              if O is TPDFName then
                Result := Result + ColorSpaceDesc(TPDFName(O));
            end;

            if QPLCopy(Result, Length(Result), 1) = '[' then
            begin
              O := ColorSpace.Item[1];
              if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
              if O is TPDFStream then
              begin
                O := TPDFStream(O).Dictionary.FindValueByKeyName('N');
                if O is TPDFIndRef then O := FindObject(TPDFIndRef(O));
                if O is TPDFNumeric then
                case TPDFNumeric(O).AsInteger of
                  1 : Result := Result + 'Gray';
                  3 : Result := Result + 'RGB';
                  4 : Result := Result + 'CMYK';
                end;
              end;
            end;
          end;
          Result := Result + ']';
        end else
        if (Family = 'DeviceN') then
        begin
          Result := 'DeviceN[';
          DescDeviceNColorSpace := TPDFDeviceNColorSpace.Create(FColorManager);
          try
            DescDeviceNColorSpace.OnFindObject := FOnFindObject;
            DescDeviceNColorSpace.LoadFromArray(ColorSpace, '');
            Result := Result + QPLIntToStr(DescDeviceNColorSpace.ComponentCount) + ']';
          finally
            DescDeviceNColorSpace.Free;
          end;
        end else
        if (Family = 'Lab') then
        begin
          Result := 'Lab';
        end else
        if (Family = 'Separation') then
        begin
          Result := 'Separation[';
          DescSeparationColorSpace := TPDFSeparationColorSpace.Create(FColorManager);
          try
            DescSeparationColorSpace.OnFindObject := FOnFindObject;
            DescSeparationColorSpace.LoadFromArray(ColorSpace, '');
            if (DescSeparationColorSpace.Alternate = 'DeviceCMYK') then
            begin
              Result := Result + 'CMYK]';
            end else
            begin
              Result := Result + 'Unknown]';
            end;
          finally
            DescSeparationColorSpace.Free;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFImageDecoder.GetFormatDesc(Source: TPDFDictionary; Options: Integer; Child: Boolean): AnsiString;
var
  Obj: TPDFObject;
  FDWidth: Integer;
  FDHeight: Integer;
  FDInverse: Boolean;
  FDColorSpace: AnsiString;
  FDBitsPerComponent: Integer;
  FDMask: AnsiString;
  FDFilter: AnsiString;
  FDCompCount: Integer;
  FDBitsPerPixel: Integer;
  IR: TPDFIndRef;

  function GetInteger(const Key: AnsiString): Integer;
  begin
    Obj := Source.FindValueByKeyName(Key);
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFNumeric then
      Result := TPDFNumeric(Obj).AsInteger
    else
      Result := 0;
  end;

begin
  Result := '';
  if (not Assigned(Source)) then
  begin
    Source := FSource.Dictionary;
  end;
  if Assigned(Source) then
  begin
    FDWidth := GetInteger('Width');
    FDHeight := GetInteger('Height');

    FDInverse := False;
    Obj := Source.FindValueByKeyName('Decode');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFArray then
    begin
      if QPLStartsWith(TPDFArray(Obj).Output, '[ 1 0') then FDInverse := True;
    end;

    FDBitsPerComponent := GetInteger('BitsPerComponent');

    Obj := Source.FindValueByKeyName('ColorSpace');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    FDColorSpace := ColorSpaceDesc(Obj, FDCompCount);

    FDMask := '';

    if (not Child) then
    begin
      Obj := Source.FindValueByKeyName('ImageMask');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFBoolean) and TPDFBoolean(Obj).AsBoolean then
      begin
        if FDBitsPerComponent = 0 then
          FDBitsPerComponent := 1;
        FDMask := 'Stencil';
      end;

      if (FDMask = '') then
      begin
        Obj := Source.FindValueByKeyName('SMask');
        if Obj is TPDFIndRef then
        begin
          IR := TPDFIndRef(Obj);
          Obj := FindObject(IR);
        end;
        if Obj is TPDFStream then
        begin
          FDMask := 'SoftMask';
        end;
      end;

      if (FDMask = '') then
      begin
        Obj := Source.FindValueByKeyName('Mask');
        if Obj is TPDFIndRef then
        begin
          IR := TPDFIndRef(Obj);
          Obj := FindObject(IR);
        end;
        if Obj is TPDFStream then
        begin
          FDMask := 'ExplicitMask';
        end;
      end;
    end;

    Obj := Source.FindValueByKeyName('Filter');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Assigned(Obj) then
      FDFilter := Obj.Output
    else
      FDFilter := '';

    FDFilter := '[ ' + FDFilter + ' ]';
    if (FDFilter = '[  ]') then
    begin
      FDFilter := 'Uncompressed';
    end else
    if (FDFilter = '[ /FlateDecode ]') then
    begin
      FDFilter := 'Flate';
    end else
    if (FDFilter = '[ /DCTDecode ]') then
    begin
      FDFilter := 'JPEG';
    end else
    if (FDFilter = '[ /JPXDecode ]') then
    begin
      FDFilter := 'JPEG2000';
    end else
    if (FDFilter = '[ /CCITTDecode ]') then
    begin
      FDFilter := 'CCITT';
    end else
    if (FDFilter = '[ /JBIG2Decode ]') then
    begin
      FDFilter := 'JBIG2';
    end else
    begin
      FDFilter := 'Unknown';
    end;

    if (Options = 1) then
    begin
      FDBitsPerPixel := FDCompCount * FBitsPerComponent;

      Result := QPLIntToStr(FDWidth) + 'x' + QPLIntToStr(FDHeight) + ' ' + QPLIntToStr(FDBitsPerPixel) + '-bit ';
      Result := Result + FDFilter + ' ';
      if (Child) then
      begin
        // Don't output a color space because this image is a mask image
      end else
      begin
        Result := Result + FDColorSpace;

        if (FDInverse) then
        begin
          Result := Result + 'Inverse ';
        end;
      end;

      if (FDMask = 'SoftMask') then
      begin
        Result := Result + ' SoftMask ' + FMaskFormatDesc1;
      end else
      if (FDMask = 'ExplicitMask') then
      begin
        Result := Result + ' ExplicitMask ' + FMaskFormatDesc1;
      end else
      begin
        // No mask
      end;
    end else
    begin
      if Child then
      begin
        Result := 'MW:' + QPLIntToStr(FDWidth) + ';MH:' + QPLIntToStr(FDHeight) + ';';
        Result := Result + 'MBPC:' + QPLIntToStr(FDBitsPerComponent) + ';';
      end else
      begin
        Result := 'W:' + QPLIntToStr(FDWidth) + ';H:' + QPLIntToStr(FDHeight) + ';';
        Result := Result + 'BPC:' + QPLIntToStr(FDBitsPerComponent) + ';';
        Result := Result + 'CS:' + FDColorSpace + ';';
      end;

      if Child then
      begin
        Result := Result + 'MC:' + FDFilter + ';';
      end else
      begin
        Result := Result + 'C:' + FDFilter + ';';
      end;

      if (not Child) then
      begin
        if FDMask = 'StencilMask' then
        begin
          Result := Result + 'M:Stencil;';
        end else
        if FDMask = 'SoftMask' then
        begin
          Result := Result + 'M:Soft;' + FMaskFormatDesc0;
        end else
        if FDMask = 'ExplicitMask' then
        begin
          Result := Result + 'M:Explicit;' + FMaskFormatDesc0;
        end else
        begin
          // No mask
        end;
      end;
    end;
  end;
end;

function TPDFImageDecoder.NativeImageData: AnsiString;
begin
  if Assigned(FImageStream) then
  begin
    SetLength(Result, FImageStream.Size);
    FImageStream.Seek(0, soFromBeginning);
    if Length(Result) > 0 then
    begin
      FImageStream.Read(Result[1], Length(Result));
    end;
  end else
  begin
    Result := ImageData;
  end;
end;

function TPDFImageDecoder.ImageData: AnsiString;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    FBitmap.Canvas.Lock;
    try
      FBitmap.SaveToStream(MS);
    finally
      FBitmap.Canvas.Unlock;
    end;
    SetLength(Result, MS.Size);
    MS.Seek(0, soFromBeginning);
    if (MS.Size > 0) then
    begin
      MS.Read(Result[1], Length(Result));
    end;
  finally
    MS.Free;
  end;
end;

// Input: FWidth, FHeight, FColorSpace, FBitsPerComponent, FDPLRImageData (uncompressed)
// Transfers PDF image data directly into FDPLRMainImage
// Output: FDPLRMainImage created, FDPLRImageData emptied
procedure TPDFImageDecoder.LoadDPLRBMP;
var
  Comp: Integer;
begin
  Comp := 1;
  if FColorSpace = 'Indexed' then Comp := 1;
  if FColorSpace = 'DeviceGray' then Comp := 1;
  if FColorSpace = 'DeviceRGB' then Comp := 3;
  if FColorSpace = 'DeviceCMYK' then Comp := 4;
  if FColorSpace = 'Lab' then Comp := 3;
  if FColorSpace = 'Separation' then Comp := 1;
  if FColorSpace = 'DeviceN' then Comp := FDeviceNColorSpace.ComponentCount;

  FDPLRMainImage := TDPLImage.Create(FWidth, FHeight, Comp, FBitsPerComponent);
  if (Length(FDPLRImageData) >= FDPLRMainImage.DataSizeBytes) then
  begin
    FDPLRMainImage.SetFromPointer(@FDPLRImageData[0]);
    SetLength(FDPLRImageData, 0);
  end;
end;

// Input: FWidth, FHeight, FColorSpace, FBitsPerComponent, FDPLRImageData (JPEG)
// Converts CCITT data using native code or GDI+ into 1-bit pixel data
// Output: FDPLRMainImage created, FDPLRImageData emptied
procedure TPDFImageDecoder.LoadDPLRCCITT(DD: TQuickPDFStringList);
var
  MS: TMemoryStream;
  K: Integer;
  CCITTReverse: Boolean;
  CCITTDecoder: TQPLCCITTDecoder;
  CCITTBuffer: TCCITTByteArray;
  CCITTStride: Integer;
  EncodedByteAlign: Boolean;
  GDIPlusCCITT: Boolean;
  TM: TPDFTIFFMaker;
  Columns: Integer;
  BMStream: TMemoryStream;
  TempBM: TBitmap;
  Row: Integer;

  function GetIntValue(const Key: AnsiString; Default: Integer): Integer;
  begin
    Result := QPLStrToIntDef(DD.Values[Key], Default);
  end;

begin
  K := GetIntValue('K', 0);
  EncodedByteAlign := DD.Values['EncodedByteAlign'] = 'true';

  CCITTReverse := True;
  if (DD.Values['BlackIs1'] = 'true') then
  begin
    CCITTReverse := not CCITTReverse;
  end;

{  if ((not FChildMask) and (QPLStartsWith(FDecode, '[ 1 0'))) then
  begin
    CCITTReverse := not CCITTReverse;
  end;}

{  if (FMaskType = mtStencil) then
  begin
    CCITTReverse := not CCITTReverse;
  end;}

  GDIPlusCCITT := False;

  Columns := GetIntValue('Columns', 1728);

  CCITTDecoder := TQPLCCITTDecoder.Create(Columns, FHeight,
    1, EncodedByteAlign, False, FBitsPerComponent);
  try
    CCITTStride := (FWidth + 7) div 8;
    if (FBitsPerComponent = 8) then
      CCITTStride := FWidth;
    SetLength(CCITTBuffer, CCITTStride * FHeight);
    FillChar(CCITTBuffer[0], Length(CCITTBuffer), 0);

    if (K < 0) then
    begin
      if (not CCITTDecoder.DecodeT6(CCITTBuffer, TCCITTByteArray(FDPLRImageData))) then
      begin
        // There was a decoding error, fall back to using GDI+ to decode
        GDIPlusCCITT := True;
      end;
    end else
    if (K = 0) then
    begin
      if (not CCITTDecoder.DecodeT41D(CCITTBuffer, TCCITTByteArray(FDPLRImageData))) then
      begin
        // There was a decoding error, fall back to using GDI+ to decode
        GDIPlusCCITT := True;
      end;
    end else
    if (K > 0) then
    begin
      CCITTDecoder.DecodeT42D(CCITTBuffer, TCCITTByteArray(FDPLRImageData));
    end;

    if (not GDIPlusCCITT) then
    begin
      // CCITT decoding was successful, we can free the compressed data
      SetLength(FDPLRImageData, 0);

      FDPLRMainImage := TDPLImage.Create(FWidth, FHeight, 1, 1);
      Move(CCITTBuffer[0], FDPLRMainImage.GetDataPointer^, Length(CCITTBuffer));
      if (CCITTReverse) then
      begin
        FDPLRMainImage.Invert;
      end;
    end;
  finally
    CCITTDecoder.Free;
  end;

  if (GDIPlusCCITT) then
  begin
    TempBM := TBitmap.Create;
    try
      BMStream := TMemoryStream.Create;
      try
        MS := TMemoryStream.Create;
        try
          TM := TPDFTIFFMaker.Create;
          try
            K := GetIntValue('K', 0);
            if K < 0 then TM.Compression := ttCCITT4;
            if K = 0 then TM.Compression := ttCCITT31d;
            if K > 0 then TM.Compression := ttCCITT32d;

            TM.EncodedByteAlign := DD.Values['EncodedByteAlign'] = 'true';

            TM.Height := FHeight;
            TM.Width := GetIntValue('Columns', 1728);

            if (TM.Compression = ttCCITT4) and TM.EncodedByteAlign then
            begin
              //TM.Source := FixG4EOL(FImageData, TM.Height, TM.Width);
            end else
            begin
              // Write the compressed image data into a temp AnsiString
              SetLength(FImageData, Length(FDPLRImageData));
              Move(FDPLRImageData[0], FImageData[1], Length(FDPLRImageData));

              // Free the original compressed data
              SetLength(FDPLRImageData, 0);

              // Set the temp AnsiString to the TIFF generator's Source property
              TM.Source := FImageData;

              // Free the data in the temp string
              FImageData := '';
            end;

            TM.Reversed := False;
            if (DD.Values['BlackIs1'] = 'true') then
            begin
              TM.Reversed := not TM.Reversed;
            end;
{            if (QPLStartsWith(FDecode, '[ 1 0')) then
            begin
              TM.Reversed := not TM.Reversed;
            end;
            if (FMaskType = mtStencil) then
            begin
              TM.Reversed := not TM.Reversed;
            end;}

            // Set the DPI to zero to prevent resolution tags being added to the TIFF
            TM.HorizontalDPI := 0;
            TM.VerticalDPI := 0;

            TM.WriteTIFFToStream(MS);
            MS.Seek(0, soFromBeginning);
{$IFDEF QPL_DPLR}
            FDPLRPicasso.SetupPrivateGDIPlus;
{$ENDIF}
            FDPLRPicasso.ConvertStream(MS, BMStream, FDPLRPicasso.BMPEncoderGUID);
          finally
            TM.Free;
          end;
        finally
          MS.Free;
        end;
        BMStream.Seek(0, soBeginning);
        TempBM.LoadFromStream(BMStream);
      finally
        BMStream.Free;
      end;
      FDPLRMainImage := TDPLImage.Create(FWidth, FHeight, 1, 1);
      for Row := 0 to FHeight - 1 do
      begin
        Move(TempBM.ScanLine[Row]^, FDPLRMainImage.GetRowPointer(Row)^,
          FDPLRMainImage.Stride);
      end;
    finally
      TempBM.Free;
    end;
  end;
end;

// Input: FWidth, FHeight, FColorSpace, FBitsPerComponent, FDPLRImageData (JBIG2)
// Converts JBIG2 data using native converter into 1-bit mono image
// Output: FDPLRMainImage created, FDPLRImageData emptied
procedure TPDFImageDecoder.LoadDPLRJBIG2(JBIG2Globals: TPDFIndRef);
var
  JBIG2GlobalsData: AnsiString;
  Obj: TPDFObject;
  GlobalData: TJBIG2ByteArray;
  Scanline: TJBIG2ByteArray;
  Decoder: TQPLJBIG2Decoder;
  RowValues: TDPLImageIntegerArray;
  Loaded: Boolean;
  Row: Integer;
  Col: Integer;
begin
  FValidImage := False;
  JBIG2GlobalsData := '';
  if Assigned(JBIG2Globals) then
  begin
    Obj := FindObject(JBIG2Globals);
    if Obj is TPDFStream then
    begin
      JBIG2GlobalsData := TPDFStream(Obj).GetDecodedStream;
    end;
  end;

  Decoder := TQPLJBIG2Decoder.Create;
  try
    if Length(JBIG2GlobalsData) > 0 then
    begin
      SetLength(GlobalData, Length(JBIG2GlobalsData));
      Move(JBIG2GlobalsData[1], GlobalData[0], Length(JBIG2GlobalsData));
      Loaded := Decoder.LoadFromByteArray(TJBIG2ByteArray(FDPLRImageData), GlobalData);
    end else
    begin
      Loaded := Decoder.LoadFromByteArray(TJBIG2ByteArray(FDPLRImageData));
    end;
    SetLength(FDPLRImageData, 0);

    if Loaded then
    begin
      FDPLRMainImage := TDPLImage.Create(Decoder.Width, Decoder.Height, 1, 8);

      SetLength(RowValues, Decoder.Width);
      for Row := 0 to Decoder.Height - 1 do
      begin
        Decoder.GetScanline(Row, Scanline);
        for Col := 0 to Length(Scanline) - 1 do
        begin
          if (Scanline[Col] = 0) then
          begin
            RowValues[Col] := 1;
          end else
          begin
            RowValues[Col] := 0;
          end;
        end;
        FDPLRMainImage.SetRowValues(Row, RowValues);
      end;
      FDPLRMainImage.SetBitsPerComponent(1, False);
    end;
  finally
    Decoder.Free;
  end;
end;

// Input: FWidth, FHeight, FColorSpace, FBitsPerComponent, FDPLRImageData (JPEG)
// Converts JPEG data using GDI+ into 24-bit RGB or 8-bit Gray pixel data
// Output: FDPLRMainImage created, FDPLRImageData emptied
procedure TPDFImageDecoder.LoadDPLRJPEG(DD: TQuickPDFStringList);
var
  SS: TMemoryStream;
  PJ: TPDFJPEGImage;
  Invert: Boolean;
  BMStream: TMemoryStream;
  MS: TMemoryStream;
  TempBM: TBitmap;
  Row: Integer;
  MyPic: TPDFPicasso;
  TempSettings: TGDIPlusSettings;
begin
  Invert := False;

  // Look for 1-byte shifted data and correct
  if (Length(FDPLRImageData) > 3) then
  begin
    if ((FDPLRImageData[0] = 10) and (FDPLRImageData[1] = 255) and (FDPLRImageData[2] = 216)) then
    begin
      Move(FDPLRImageData[1], FDPLRImageData[0], Length(FDPLRImageData) - 1);
      SetLength(FDPLRImageData, Length(FDPLRImageData) - 1);
    end;
  end;

  // Create a temporary TBitmap
  TempBM := TBitmap.Create;
  try
    // Create the stream that the bitmap will be loaded from
    BMStream := TMemoryStream.Create;
    try
      SS := TMemoryStream.Create;
      try
        SS.Write(FDPLRImageData[0], Length(FDPLRImageData));
        SetLength(FDPLRImageData, 0);

        if (FColorSpace = 'DeviceCMYK') and ((FDecode = '[ 0 1 0 1 0 1 0 1 ]') or (FDecode = '')) then
        begin
          Invert := True;
        end;

        if ((FColorSpace = 'Separation') and (FSeparationColorSpace.Alternate = 'DeviceCMYK') and (FDecode = '[ 1 0 ]')) then
        begin
          Invert := True;
        end;

        if (Invert) then
        begin
          // Load the JPEG using the TPDFJPEGImage class (libjpeg .obj)
          PJ := TPDFJPEGImage.Create;
          try
            PJ.ColorManager := FColorManager;
            SS.Seek(0, soBeginning);
            PJ.LoadFromStream(SS);
            PJ.InvertCMYK;
{$IFDEF QPL_OS_WINDOWS}
            if ((FColorSpace = 'Separation') and (FSeparationColorSpace.Alternate = 'DeviceCMYK') and (FDecode = '[ 1 0 ]')) then
            begin
{$IFDEF QPL_DPLR}
              FDPLRPicasso.SetupPrivateGDIPlus;
{$ENDIF}
              MS := TMemoryStream.Create;
              try
                PJ.SaveToStream(MS);

                TempBM.Width := PJ.Width;
                TempBM.Height := PJ.Height;
                TempBM.PixelFormat := pf8bit;
                MyPic := TPDFPicasso.Create;
                try
                  TempSettings := GetGDIPlusSettings;
                  MyPic.UseGDIPlusModel(TempBM.Canvas, TempSettings);
                  MyPic.DrawAnyImage(0, 0, TempBM.Width, TempBM.Height, MS, 1, True);
                finally
                  MyPic.Free;
                end;
              finally
                MS.Free;
              end;
            end else
            begin
{$IFNDEF QPL_NOVCL}
              TempBM.Assign(PJ);
{$ENDIF}
            end;
{$ENDIF}
          finally
            PJ.Free;
          end;
        end else
        begin
          // Convert the raw JPEG data to bitmap format using GDI+
{$IFDEF QPL_DPLR}
          FDPLRPicasso.SetupPrivateGDIPlus;
{$ENDIF}
          FDPLRPicasso.ConvertStream(SS, BMStream, FDPLRPicasso.BMPEncoderGUID);
          // Load the image from the TStream into the TBitmap
          BMStream.Seek(0, soBeginning);
          TempBM.LoadFromStream(BMStream);
        end;
      finally
        SS.Free;
      end;
    finally
      BMStream.Free;
    end;

    // At this point the TempBM should contain 24-bit RGB or 8-bit grayscale
    if (TempBM.PixelFormat = pf24bit) then
    begin
      if ((FColorSpace = 'DeviceCMYK') or (FColorSpace = 'DeviceRGB')) then
      begin
        FColorSpace := 'DeviceBGR';
      end;
      FDPLRMainImage := TDPLImage.Create(TempBM.Width, TempBM.Height, 3, 8);
      for Row := 0 to TempBM.Height - 1 do
      begin
        Move(TempBM.ScanLine[Row]^, FDPLRMainImage.GetRowPointer(Row)^, FDPLRMainImage.Stride);
      end;
    end else
    if (TempBM.PixelFormat = pf8bit) then
    begin
      if (FColorSpace <> 'DeviceN') and (FColorSpace <> 'Separation') then
      begin
        FColorSpace := 'DeviceGray';
      end;
      FDPLRMainImage := TDPLImage.Create(TempBM.Width, TempBM.Height, 1, 8);
      for Row := 0 to TempBM.Height - 1 do
      begin
        Move(TempBM.ScanLine[Row]^, FDPLRMainImage.GetRowPointer(Row)^, FDPLRMainImage.Stride);
      end;
    end;
  finally
    TempBM.Free;
  end;
end;

procedure TPDFImageDecoder.LoadDPLRJPEG2000;
{$IFDEF NOJPEG2000}
begin
end;
{$ELSE}
var
  MS: TMemoryStream;
  JB: TJpeg2000Bitmap;
  Row: Integer;
  Col: Integer;
  Index: Integer;
  RowData: array of Byte;
  Temp: Integer;
  isCMYK: Boolean;
begin
  isCMYK := False;
  JB := TJpeg2000Bitmap.Create;
  try
    MS := TMemoryStream.Create;
    try
      MS.Write(FDPLRImageData[0], Length(FDPLRImageData));
      try
        MS.Seek(0, soFromBeginning);

        if (FColorSpace = 'DeviceCMYK') then
          isCMYK := True
        else if (FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceCMYK') then
          isCMYK := True
        else if (FColorSpace = 'DeviceN') and (Assigned(FDeviceNColorSpace)) and
          (FDeviceNColorSpace.Alternate = 'DeviceCMYK') then
            isCMYK := True
        else if (FColorSpace = 'Separation') and (Assigned(FSeparationColorSpace)) and
          (FSeparationColorSpace.Alternate = 'DeviceCMYK')then
            isCMYK := True;

        if (isCMYK) then
          JB.SetCMYK(True);

        JB.LoadFromStream(MS);
      except
        JB.Free;
        JB := nil;
      end;
    finally
      MS.Free;
    end;
    if Assigned(JB) then
    begin
      if ((JB.PixelFormat = pf32bit) and isCMYK) then
      begin
        FDPLRMainImage := TDPLImage.Create(JB.Width, JB.Height, 4, 8);
        SetLength(RowData, FDPLRMainImage.Stride);
        for Row := 0 to JB.Height - 1 do
        begin
          Move(JB.ScanLine[Row]^, RowData[0], FDPLRMainImage.Stride);
          Index := 0;
          for Col := 0 to JB.Width - 1 do
          begin
            Temp := RowData[Index + 0];
            RowData[Index + 0] := RowData[Index + 3];
            RowData[Index + 3] := Temp;
            Temp := RowData[Index + 1];
            RowData[Index + 1] := RowData[Index + 2];
            RowData[Index + 2] := Temp;
            Inc(Index, 4);
          end;
          Move(RowData[0], FDPLRMainImage.GetRowPointer(Row)^, FDPLRMainImage.Stride);
        end;
      end else
      if ((JB.PixelFormat = pf8bit) and isCMYK) then
      begin
        FDPLRMainImage := TDPLImage.Create(JB.Width, JB.Height, 1, 8);
        SetLength(RowData, FDPLRMainImage.Stride);
        for Row := 0 to JB.Height - 1 do
        begin
          Move(JB.ScanLine[Row]^, FDPLRMainImage.GetRowPointer(Row)^, FDPLRMainImage.Stride);
        end;
      end else
      if ((JB.PixelFormat = pf24bit) and (FColorSpace = 'DeviceRGB')) then
      begin
        FDPLRMainImage := TDPLImage.Create(JB.Width, JB.Height, 3, 8);
        for Row := 0 to JB.Height - 1 do
        begin
          Move(JB.ScanLine[Row]^, FDPLRMainImage.GetRowPointer(Row)^, FDPLRMainImage.Stride);
        end;
        FColorSpace := 'DeviceBGR';
      end else
      if ((JB.PixelFormat = pf8bit) and ((FColorSpace = 'DeviceGray') or (FColorSpace = 'Indexed'))) then
      begin
        FDPLRMainImage := TDPLImage.Create(JB.Width, JB.Height, 1, 8);
        for Row := 0 to JB.Height - 1 do
        begin
          Move(JB.ScanLine[Row]^, FDPLRMainImage.GetRowPointer(Row)^, FDPLRMainImage.Stride);
        end;
      end;
    end;
  finally
    if Assigned(JB) then
    begin
      JB.Free;
    end;
  end;
end;
{$ENDIF}

procedure TPDFImageDecoder.LoadBMP;
var
  Row: Integer;
  Col: Integer;
  IV, IV2: Integer;
  RowData: AnsiString;
  RowLength: Integer;
  MaskRowData: array of Byte;
  Mask: Integer;
  Comp: Integer;
  DCol: Integer;
  RGB: TPDFRGBColor;
  CMYK: TPDFCMYKColor;
  Reverse: Boolean;
  DataIndex: Integer;
  DeviceNInput: TPDFDeviceNColor;
  DeviceNIndex: Integer;
  DeviceNRowData: array of Byte;
  MS: TMemoryStream;
  MyPic: TPDFPicasso;
  PNGWriter: TPNGWriter;
  MonoBitmap: TBitmap;
  IsMonoBitmap: Boolean;
  Offset, Offset2: Integer;
  IndexedRGB: array of array[0..2] of byte;
  TempSettings: TGDIPlusSettings;
  ReverseMask: Boolean;
begin
  FValidImage := True;

  Reverse := QPLStartsWith(FDecode, '[ 1 0');

  if (FMaskType = mtStencil) then
  begin
    Reverse := not Reverse;
  end;

  if (FColorSpace = 'DeviceGray') and (FBitsPerComponent = 1) and (FMaskType <> mtStencil) then
  begin
    FBitmap.Width := 1;
    FBitmap.Height := 1;
    try
      FBitmap.PixelFormat := pf1bit;
      FBitmap.Width := FWidth;
      FBitmap.Height := FHeight;
    except
      FLoadException := True;
      Exit;
    end;
    DataIndex := 1;

    RowLength := FWidth div 8;
    if (RowLength * 8) < FWidth then Inc(RowLength);
    SetLength(RowData, RowLength);

    for Row := 0 to FHeight - 1 do
    begin
      Move(FImageData[DataIndex], RowData[1], RowLength);
      if Reverse then
      begin
        for Col := 1 to RowLength do
        begin
          RowData[Col] := AnsiChar(not Ord(RowData[Col]));
        end;
      end;
      Move(RowData[1], FBitmap.ScanLine[Row]^, RowLength);
      Inc(DataIndex, RowLength);
    end;

    FDecode := '[ 0 1 ]';
    IsMonoBitmap := True;
  end else
  begin
    IsMonoBitmap := False;
    FBitmap.Width := 1;
    FBitmap.Height := 1;
    try
      FBitmap.PixelFormat := pf24bit;
      FBitmap.Width := FWidth;
      FBitmap.Height := FHeight;
    except
      FLoadException := True;
      Exit;
    end;

    Comp := 1;
    if FColorSpace = 'Indexed' then Comp := 1;
    if FColorSpace = 'DeviceGray' then Comp := 1;
    if FColorSpace = 'DeviceRGB' then Comp := 3;
    if FColorSpace = 'DeviceCMYK' then Comp := 4;
    if FColorSpace = 'Lab' then Comp := 3;
    if FColorSpace = 'ICCBased' then Comp := 3;
    if FColorSpace = 'Separation' then Comp := 1;
    if FColorSpace = 'DeviceN' then Comp := FDeviceNColorSpace.ComponentCount;

    RowLength := FWidth;
    if FBitsPerComponent = 1 then
    begin
      RowLength := FWidth * Comp div 8;
      if (RowLength * 8) div Comp < FWidth then Inc(RowLength);
    end else
    if FBitsPerComponent = 2 then
    begin
      RowLength := FWidth * Comp div 4;
      if (RowLength * 4) div Comp < FWidth then Inc(RowLength);
    end else
    if FBitsPerComponent = 4 then
    begin
      RowLength := FWidth * Comp div 2;
      if (RowLength * 2) div Comp < FWidth then Inc(RowLength);
    end else
    if FBitsPerComponent = 8 then
    begin
      RowLength := FWidth * Comp;
    end else
    if FBitsPerComponent = 16 then
    begin
      RowLength := FWidth * Comp * 2;
    end;

    SetLength(FImageData, RowLength * FHeight);

    try
      if ((FColorSpace = 'DeviceGray') or (FColorSpace = 'Separation') or
        (FMaskType = mtStencil)) then
      begin
        SetLength(RowData, FWidth * 3);
        for Row := 0 to FHeight - 1 do
        begin
          Offset := 0;
          for Col := 0 to FWidth - 1 do
          begin
            if FBitsPerComponent = 1 then
            begin
              Mask := 1 shl (7 - (Col mod 8));
              RowData[Offset + 1] := AnsiChar(Ord(FImageData[Row * RowLength +
                Col div 8 + 1]) and Mask shr (7 - (Col mod 8)) * 255);
            end else
            if FBitsPerComponent = 2 then
            begin
              Mask := 3 shl ((3 - (Col mod 4)) * 2);
              RowData[Offset + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 4 + 1]) and Mask) shr ((3 - (Col mod 4)) * 2)) * 255 div 3);
            end else
            if FBitsPerComponent = 4 then
            begin
              Mask := 15 shl ((1 - (Col mod 2)) * 4);
              RowData[Offset + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 2 + 1]) and Mask) shr ((1 - (Col mod 2)) * 4)) * 255 div 15);
            end else
            if FBitsPerComponent = 8 then
            begin
              RowData[Offset + 1] := FImageData[Row * RowLength + Col + 1];
            end else
            if FBitsPerComponent = 16 then
            begin
              RowData[Offset + 1] := FImageData[Row * RowLength + Col * 2 + 1];
            end;
            RowData[Offset + 2] := RowData[Offset + 1];
            RowData[Offset + 3] := RowData[Offset + 1];
            if Reverse then
            begin
              RowData[Offset + 1] := AnsiChar(not Byte(RowData[Offset + 1]));
              RowData[Offset + 2] := AnsiChar(not Byte(RowData[Offset + 2]));
              RowData[Offset + 3] := AnsiChar(not Byte(RowData[Offset + 3]));
            end;
            Inc(Offset, 3);
          end;
          Move(RowData[1], FBitmap.ScanLine[Row]^, FWidth * 3);
        end;
        FDecode := '[ 0 1 ]';
        if FMaskType = mtStencil then
        begin
          MonoBitmap := TBitmap.Create;
          try
            MonoBitmap.PixelFormat := pf1bit;
            MonoBitmap.Width := FBitmap.Width;
            MonoBitmap.Height := FBitmap.Height;
          except
            MonoBitmap.Free;
            FLoadException := True;
            Exit;
          end;

          MonoBitmap.Canvas.Lock;
          try
            MonoBitmap.Canvas.Draw(0, 0, FBitmap);
            FBitmap.Free;
            FBitmap := MonoBitmap;
          finally
            MonoBitmap.Canvas.Unlock;
          end;

          MS := TMemoryStream.Create;
          try
            FBitmap.Canvas.Lock;
            try
              FBitmap.SaveToStream(MS);
              MyPic := TPDFPicasso.Create;
              try
                TempSettings := GetGDIPlusSettings;
                MyPic.UseGDIPlusModel(FBitmap.Canvas, TempSettings);
                FImageStream := TMemoryStream.Create;
                MyPic.ConvertStream(MS, FImageStream, MyPic.PNGEncoderGUID);
              finally
                MyPic.Free;
              end;
            finally
              FBitmap.Canvas.Unlock;
            end;
            FBitmap.Free;
            FBitmap := nil;
          finally
            MS.Free;
          end;
        end;
      end else
      if ((FColorSpace = 'DeviceRGB') or (FColorSpace = 'Lab') or (FColorSpace = 'ICCBased')) then
      begin
        SetLength(RowData, FWidth * 3);
        for Row := 0 to FHeight - 1 do
        begin
          for Col := 0 to FWidth * 3 - 1 do
          begin
            case Col mod 3 of
              0: DCol := Col + 2;
              1: DCol := Col;
            else
              DCol := Col - 2;
            end;
            if FBitsPerComponent = 1 then
            begin
              Mask := 1 shl (7 - (Col mod 8));
              RowData[DCol + 1] := AnsiChar(Ord(FImageData[Row * RowLength +
                Col div 8 + 1]) and Mask shr (7 - (Col mod 8)) * 255);
            end else
            if FBitsPerComponent = 2 then
            begin
              Mask := 3 shl ((3 - (Col mod 4)) * 2);
              RowData[DCol + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 4 + 1]) and Mask) shr ((3 - (Col mod 4)) * 2)) * 255 div 3);
            end else
            if FBitsPerComponent = 4 then
            begin
              Mask := 15 shl ((1 - (Col mod 2)) * 4);
              RowData[DCol + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 2 + 1]) and Mask) shr ((1 - (Col mod 2)) * 4)) * 255 div 15);
            end else
            if FBitsPerComponent = 8 then
            begin
              RowData[DCol + 1] := FImageData[Row * RowLength + Col + 1];
            end else
            if FBitsPerComponent = 16 then
            begin
              RowData[DCol + 1] := FImageData[Row * RowLength + Col * 2 + 1];
            end;
          end;
          Move(RowData[1], FBitmap.ScanLine[Row]^, FWidth * 3);
        end;
        FDecode := '[ 0 1 0 1 0 1 ]';
      end else
      if (FColorSpace = 'DeviceN') then
      begin
        SetLength(RowData, FWidth * FDeviceNColorSpace.ComponentCount);
        for Row := 0 to FHeight - 1 do
        begin
          for Col := 0 to FWidth * FDeviceNColorSpace.ComponentCount - 1 do
          begin
            DCol := Col;
            if FBitsPerComponent = 1 then
            begin
              Mask := 1 shl (7 - (Col mod 8));
              RowData[DCol + 1] := AnsiChar(Ord(FImageData[Row * RowLength +
                Col div 8 + 1]) and Mask shr (7 - (Col mod 8)) * 255);
            end;
            if FBitsPerComponent = 2 then
            begin
              Mask := 3 shl ((3 - (Col mod 4)) * 2);
              RowData[DCol + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 4 + 1]) and Mask) shr ((3 - (Col mod 4)) * 2)) * 255 div 3);
            end;
            if FBitsPerComponent = 4 then
            begin
              Mask := 15 shl ((1 - (Col mod 2)) * 4);
              RowData[DCol + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 2 + 1]) and Mask) shr ((1 - (Col mod 2)) * 4)) * 255 div 15);
            end;
            if FBitsPerComponent = 8 then
            begin
              RowData[DCol + 1] := FImageData[Row * RowLength + Col + 1];
            end;
          end;

          SetLength(DeviceNInput, FDeviceNColorSpace.ComponentCount);
          SetLength(DeviceNRowData, FWidth * 3);
          Offset := 0;
          for Col := 0 to FWidth - 1 do
          begin
            for DeviceNIndex := 1 to FDeviceNColorSpace.ComponentCount do
            begin
              DeviceNInput[DeviceNIndex - 1] := Ord(RowData[Col *
                FDeviceNColorSpace.ComponentCount + DeviceNIndex]) / 255;
            end;
            FDeviceNColorSpace.GetColor(DeviceNInput, True);
            DeviceNRowData[Offset + 2] :=
              (FDeviceNColorSpace.ResultColor and $FF);
            DeviceNRowData[Offset + 1] :=
              (FDeviceNColorSpace.ResultColor and $FF00) shr 8;
            DeviceNRowData[Offset + 0] :=
              (FDeviceNColorSpace.ResultColor and $FF0000) shr 16;
            Inc(Offset, 3);
          end;
          Move(DeviceNRowData[0], FBitmap.ScanLine[Row]^, FWidth * 3);
        end;
      end else
      if (FColorSpace = 'DeviceCMYK') then
      begin
        SetLength(RowData, FWidth * 4);
        for Row := 0 to FHeight - 1 do
        begin
          for Col := 0 to FWidth * 4 - 1 do
          begin
            DCol := Col;
            if FBitsPerComponent = 1 then
            begin
              Mask := 1 shl (7 - (Col mod 8));
              RowData[DCol + 1] := AnsiChar(Ord(FImageData[Row * RowLength +
                Col div 8 + 1]) and Mask shr (7 - (Col mod 8)) * 255);
            end;
            if FBitsPerComponent = 2 then
            begin
              Mask := 3 shl ((3 - (Col mod 4)) * 2);
              RowData[DCol + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 4 + 1]) and Mask) shr ((3 - (Col mod 4)) * 2)) * 255 div 3);
            end;
            if FBitsPerComponent = 4 then
            begin
              Mask := 15 shl ((1 - (Col mod 2)) * 4);
              RowData[DCol + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 2 + 1]) and Mask) shr ((1 - (Col mod 2)) * 4)) * 255 div 15);
            end;
            if FBitsPerComponent = 8 then
            begin
              RowData[DCol + 1] := FImageData[Row * RowLength + Col + 1];
            end;
          end;
          Offset := 0;
          Offset2 := 0;
          for Col := 0 to FWidth - 1 do
          begin
            CMYK.Cyan := Ord(RowData[Offset2 + 1]) / 255;
            CMYK.Magenta := Ord(RowData[Offset2 + 2]) / 255;
            CMYK.Yellow := Ord(RowData[Offset2 + 3]) / 255;
            CMYK.Black := Ord(RowData[Offset2 + 4]) / 255;
            RGB := FColorManager.CMYK2RGB(CMYK);
            RowData[Offset + 1] := AnsiChar(Round(RGB.Blue * 255));
            RowData[Offset + 2] := AnsiChar(Round(RGB.Green * 255));
            RowData[Offset + 3] := AnsiChar(Round(RGB.Red * 255));
            Inc(Offset, 3);
            Inc(Offset2, 4);
          end;
          Move(RowData[1], FBitmap.ScanLine[Row]^, FWidth * 3);
        end;
      end else
      if (FColorSpace = 'Indexed') and (
        (FIndexedBaseColorSpace = 'DeviceRGB') or
        (FIndexedBaseColorSpace = 'CalRGB') or  //DPL-297
        (FIndexedBaseColorSpace = 'ICCBased') or
        (FIndexedBaseColorSpace = '') or
        (FIndexedBaseColorSpace = 'Lab')) then
      begin
        if FMaskType = mtColorKey then
        begin
          if Assigned(FMaskBitmap) then
          begin
            FMaskBitmap.Free;
            FMaskBitmap := nil;
          end;
          FMaskBitmap := TBitmap.Create;
          try
            FMaskBitmap.PixelFormat := pf8bit;
            FMaskBitmap.Width := FBitmap.Width;
            FMaskBitmap.Height := FBitmap.Height;
          except
            FMaskBitmap.Free;
            FMaskBitmap := nil;
            FLoadException := True;
            Exit;
          end;
          FMaskBitmap.Canvas.Lock;
          try
            FMaskBitmap.Canvas.Brush.Color := clWhite;
{$IFNDEF QPL_CPP}
            FMaskBitmap.Canvas.FillRect(Rect(0, 0, FBitmap.Width, FBitmap.Height));
{$ENDIF}
          finally
            FMaskBitmap.Canvas.Unlock;
          end;
          SetLength(MaskRowData, FMaskBitmap.Width);
        end;

        SetLength(IndexedRGB, 256);
        for IV := 0 to 255 do
        begin
          IV2 := IV;
          if IV2 >= FIndexedHival then IV2 := FIndexedHival;

          if (IV2 >= 0) and ((IV2 * 3 + 3) <= Length(FIndexedData)) then
          begin
            IndexedRGB[IV][2] := Byte(FIndexedData[IV2 * 3 + 1]);
            IndexedRGB[IV][1] := Byte(FIndexedData[IV2 * 3 + 2]);
            IndexedRGB[IV][0] := Byte(FIndexedData[IV2 * 3 + 3]);
          end else
          begin
            IndexedRGB[IV][2] := Byte(#0);
            IndexedRGB[IV][1] := Byte(#0);
            IndexedRGB[IV][0] := Byte(#0);
          end;
        end;

        SetLength(RowData, FWidth * 3);
        for Row := 0 to FHeight - 1 do
        begin
          if FMaskType = mtColorKey then
            for Col := 0 to FWidth - 1 do
              MaskRowData[Col] := 255;
          Offset := 0;
          for Col := 0 to FWidth - 1 do
          begin
            if FBitsPerComponent = 1 then
            begin
              Mask := 1 shl (7 - (Col mod 8));
              RowData[Offset + 1] := AnsiChar(Ord(FImageData[Row * RowLength +
                Col div 8 + 1]) and Mask shr (7 - (Col mod 8)));
            end;
            if FBitsPerComponent = 2 then
            begin
              Mask := 3 shl ((3 - (Col mod 4)) * 2);
              RowData[Offset + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 4 + 1]) and Mask) shr ((3 - (Col mod 4)) * 2)));
            end;
            if FBitsPerComponent = 4 then
            begin
              Mask := 15 shl ((1 - (Col mod 2)) * 4);
              RowData[Offset + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 2 + 1]) and Mask) shr ((1 - (Col mod 2)) * 4)));
            end;
            if FBitsPerComponent = 8 then
              RowData[Offset + 1] := FImageData[Row * RowLength + Col + 1];

            IV := Ord(RowData[Offset + 1]);
            Move(IndexedRGB[IV][0], RowData[Offset + 1], 3);

            if FMaskType = mtColorKey then
            begin
              if (IV >= FMaskColor[0]) and (IV <= FMaskColor[1]) then
                MaskRowData[Col] := 0;
            end;

            Inc(Offset, 3);
          end;
          Move(RowData[1], FBitmap.ScanLine[Row]^, FWidth * 3);
          if FMaskType = mtColorKey then
            Move(MaskRowData[0], FMaskBitmap.ScanLine[Row]^, FWidth);
        end;
        if FMaskType = mtColorKey then
        begin
          try
            FMaskBitmap.PixelFormat := pf24bit;
          except
            FLoadException := True;
            Exit;
          end;
          FMaskType := mtExplicit;
        end;
      end else
      if (FColorSpace = 'Indexed') and
        ((FIndexedBaseColorSpace = 'DeviceGray') or
         (FIndexedBaseColorSpace = 'CalGray')) then
      begin
        if FMaskType = mtColorKey then
        begin
          if Assigned(FMaskBitmap) then
          begin
            FMaskBitmap.Free;
            FMaskBitmap := nil;
          end;
          FMaskBitmap := TBitmap.Create;
          try
            FMaskBitmap.PixelFormat := pf8bit;
            FMaskBitmap.Width := FBitmap.Width;
            FMaskBitmap.Height := FBitmap.Height;
          except
            FMaskBitmap.Free;
            FMaskBitmap := nil;
            FLoadException := True;
            Exit;
          end;
          FMaskBitmap.Canvas.Lock;
          try
            FMaskBitmap.Canvas.Brush.Color := clWhite;
{$IFNDEF QPL_CPP}
            FMaskBitmap.Canvas.FillRect(Rect(0, 0, FBitmap.Width, FBitmap.Height));
{$ENDIF}
          finally
            FMaskBitmap.Canvas.Unlock;
          end;
          SetLength(MaskRowData, FMaskBitmap.Width);
        end;

        SetLength(RowData, FWidth * 3);
        SetLength(IndexedRGB, 256);
        for IV := 0 to 255 do
        begin
          IV2 := IV;
          if IV2 >= FIndexedHival then IV2 := FIndexedHival;
          if (IV2 >= 0) and ((IV2 + 1) <= Length(FIndexedData)) then
          begin
            IndexedRGB[IV][2] := Byte(FIndexedData[IV2 + 1]);
            IndexedRGB[IV][1] := Byte(FIndexedData[IV2 + 1]);
            IndexedRGB[IV][0] := Byte(FIndexedData[IV2 + 1]);
          end else
          begin
            IndexedRGB[IV][2] := Byte(#0);
            IndexedRGB[IV][1] := Byte(#0);
            IndexedRGB[IV][0] := Byte(#0);
          end;
        end;

        for Row := 0 to FHeight - 1 do
        begin
          if FMaskType = mtColorKey then
            for Col := 0 to FWidth - 1 do
              MaskRowData[Col] := 255;
          Offset := 0;
          for Col := 0 to FWidth - 1 do
          begin
            if FBitsPerComponent = 1 then
            begin
              Mask := 1 shl (7 - (Col mod 8));
              RowData[Offset + 1] := AnsiChar(Ord(FImageData[Row * RowLength +
                Col div 8 + 1]) and Mask shr (7 - (Col mod 8)));
            end;
            if FBitsPerComponent = 2 then
            begin
              Mask := 3 shl ((3 - (Col mod 4)) * 2);
              RowData[Offset + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 4 + 1]) and Mask) shr ((3 - (Col mod 4)) * 2)));
            end;
            if FBitsPerComponent = 4 then
            begin
              Mask := 15 shl ((1 - (Col mod 2)) * 4);
              RowData[Offset + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 2 + 1]) and Mask) shr ((1 - (Col mod 2)) * 4)));
            end;
            if FBitsPerComponent = 8 then
              RowData[Offset + 1] := FImageData[Row * RowLength + Col + 1];

            IV := Ord(RowData[Offset + 1]);
            Move(IndexedRGB[IV][0], RowData[Offset + 1], 3);

            if FMaskType = mtColorKey then
            begin
              if (IV >= FMaskColor[0]) and (IV <= FMaskColor[1]) then
                MaskRowData[Col] := 0;
            end;

            Inc(Offset, 3);
          end;
          Move(RowData[1], FBitmap.ScanLine[Row]^, FWidth * 3);
          if FMaskType = mtColorKey then
            Move(MaskRowData[0], FMaskBitmap.ScanLine[Row]^, FWidth);
        end;
        if FMaskType = mtColorKey then
        begin
          try
            FMaskBitmap.PixelFormat := pf24bit;
          except
            FLoadException := True;
            Exit;
          end;
          FMaskType := mtExplicit;
        end;
      end else
      if (FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceCMYK') then
      begin

        if FMaskType = mtColorKey then
        begin
          if Assigned(FMaskBitmap) then
          begin
            FMaskBitmap.Free;
            FMaskBitmap := nil;
          end;
          FMaskBitmap := TBitmap.Create;
          try
            FMaskBitmap.PixelFormat := pf8bit;
            FMaskBitmap.Width := FBitmap.Width;
            FMaskBitmap.Height := FBitmap.Height;
          except
            FMaskBitmap.Free;
            FMaskBitmap := nil;
            FLoadException := True;
            Exit;
          end;
          FMaskBitmap.Canvas.Lock;
          try
            FMaskBitmap.Canvas.Brush.Color := clWhite;
{$IFNDEF QPL_CPP}
            FMaskBitmap.Canvas.FillRect(Rect(0, 0, FBitmap.Width, FBitmap.Height));
{$ENDIF}
          finally
            FMaskBitmap.Canvas.Unlock;
          end;
          SetLength(MaskRowData, FMaskBitmap.Width);
        end;

        SetLength(RowData, FWidth * 3);
        SetLength(IndexedRGB, 256);
        for IV := 0 to 255 do
        begin
          IV2 := IV;
          if IV2 >= FIndexedHival then IV2 := FIndexedHival;
          if (IV2 >= 0) and ((IV2 * 4 + 4) <= Length(FIndexedData)) then
          begin
            CMYK.Cyan := Ord(FIndexedData[IV2 * 4 + 1]) / 255;
            CMYK.Magenta := Ord(FIndexedData[IV2 * 4 + 2]) / 255;
            CMYK.Yellow := Ord(FIndexedData[IV2 * 4 + 3]) / 255;
            CMYK.Black := Ord(FIndexedData[IV2 * 4 + 4]) / 255;
            RGB := FColorManager.CMYK2RGB(CMYK);
            IndexedRGB[IV][2] := Byte(Round(RGB.Red   * 255));
            IndexedRGB[IV][1] := Byte(Round(RGB.Green * 255));
            IndexedRGB[IV][0] := Byte(Round(RGB.Blue  * 255));
          end else
          begin
            IndexedRGB[IV][2] := Byte(#0);
            IndexedRGB[IV][1] := Byte(#0);
            IndexedRGB[IV][0] := Byte(#0);
          end;
        end;

        for Row := 0 to FHeight - 1 do
        begin
          Offset := 0;
          for Col := 0 to FWidth - 1 do
          begin
            if FBitsPerComponent = 1 then
            begin
              Mask := 1 shl (7 - (Col mod 8));
              RowData[Offset + 1] := AnsiChar(Ord(FImageData[Row * RowLength +
                Col div 8 + 1]) and Mask shr (7 - (Col mod 8)));
            end;
            if FBitsPerComponent = 2 then
            begin
              Mask := 3 shl ((3 - (Col mod 4)) * 2);
              RowData[Offset + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 4 + 1]) and Mask) shr ((3 - (Col mod 4)) * 2)));
            end;
            if FBitsPerComponent = 4 then
            begin
              Mask := 15 shl ((1 - (Col mod 2)) * 4);
              RowData[Offset + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 2 + 1]) and Mask) shr ((1 - (Col mod 2)) * 4)));
            end;
            if FBitsPerComponent = 8 then
              RowData[Offset + 1] := FImageData[Row * RowLength + Col + 1];

            IV := Ord(RowData[Offset + 1]);
            Move(IndexedRGB[IV][0], RowData[Offset + 1], 3);

            if FMaskType = mtColorKey then
            begin
              if (IV >= FMaskColor[0]) and (IV <= FMaskColor[1]) then
                MaskRowData[Col] := 0;
            end;

            Inc(Offset, 3);
          end;
          Move(RowData[1], FBitmap.ScanLine[Row]^, FWidth * 3);
        end;
      end else
      if (FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceN') then
      begin

        if FMaskType = mtColorKey then
        begin
          if Assigned(FMaskBitmap) then
          begin
            FMaskBitmap.Free;
            FMaskBitmap := nil;
          end;
          FMaskBitmap := TBitmap.Create;
          try
            FMaskBitmap.PixelFormat := pf8bit;
            FMaskBitmap.Width := FBitmap.Width;
            FMaskBitmap.Height := FBitmap.Height;
          except
            FMaskBitmap.Free;
            FMaskBitmap := nil;
            FLoadException := True;
            Exit;
          end;
          FMaskBitmap.Canvas.Lock;
          try
            FMaskBitmap.Canvas.Brush.Color := clWhite;
{$IFNDEF QPL_CPP}
            FMaskBitmap.Canvas.FillRect(Rect(0, 0, FBitmap.Width, FBitmap.Height));
{$ENDIF}
          finally
            FMaskBitmap.Canvas.Unlock;
          end;
          SetLength(MaskRowData, FMaskBitmap.Width);
        end;

        SetLength(DeviceNInput, FDeviceNColorSpace.ComponentCount);
        SetLength(RowData, FWidth * 3);
        SetLength(IndexedRGB, 256);
        for IV := 0 to 255 do
        begin
          IV2 := IV;
          if IV2 >= FIndexedHival then IV2 := FIndexedHival;
          if (IV2 >= 0) and (((IV2 + 1) * FDeviceNColorSpace.ComponentCount) <= Length(FIndexedData)) then
          begin
            for DeviceNIndex := 1 to FDeviceNColorSpace.ComponentCount do
              DeviceNInput[DeviceNIndex - 1] := Ord(FIndexedData[IV2 * FDeviceNColorSpace.ComponentCount + DeviceNIndex]) / 255;

            FDeviceNColorSpace.GetColor(DeviceNInput, True);
            IndexedRGB[IV][0] := Byte((FDeviceNColorSpace.ResultColor and $FF0000) shr 16);
            IndexedRGB[IV][1] := Byte((FDeviceNColorSpace.ResultColor and $FF00) shr 8);
            IndexedRGB[IV][2] := Byte((FDeviceNColorSpace.ResultColor and $FF));
          end else
          begin
            IndexedRGB[IV][0] := Byte(#0);
            IndexedRGB[IV][1] := Byte(#0);
            IndexedRGB[IV][2] := Byte(#0);
          end;
        end;

        for Row := 0 to FHeight - 1 do
        begin
          Offset := 0;
          for Col := 0 to FWidth - 1 do
          begin
            if FBitsPerComponent = 1 then
            begin
              Mask := 1 shl (7 - (Col mod 8));
              RowData[Offset + 1] := AnsiChar(Ord(FImageData[Row * RowLength +
                Col div 8 + 1]) and Mask shr (7 - (Col mod 8)));
            end;
            if FBitsPerComponent = 2 then
            begin
              Mask := 3 shl ((3 - (Col mod 4)) * 2);
              RowData[Offset + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 4 + 1]) and Mask) shr ((3 - (Col mod 4)) * 2)));
            end;
            if FBitsPerComponent = 4 then
            begin
              Mask := 15 shl ((1 - (Col mod 2)) * 4);
              RowData[Offset + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 2 + 1]) and Mask) shr ((1 - (Col mod 2)) * 4)));
            end;
            if FBitsPerComponent = 8 then
              RowData[Offset + 1] := FImageData[Row * RowLength + Col + 1];

            IV := Ord(RowData[Offset + 1]);
            Move(IndexedRGB[IV][0], RowData[Offset + 1], 3);

            if FMaskType = mtColorKey then
            begin
              if (IV >= FMaskColor[0]) and (IV <= FMaskColor[1]) then
                MaskRowData[Col] := 0;
            end;

            Inc(Offset, 3);
          end;
          Move(RowData[1], FBitmap.ScanLine[Row]^, FWidth * 3);
        end;
      end else
      if (FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'Separation') then
      begin

        if FMaskType = mtColorKey then
        begin
          if Assigned(FMaskBitmap) then
          begin
            FMaskBitmap.Free;
            FMaskBitmap := nil;
          end;
          FMaskBitmap := TBitmap.Create;
          try
            FMaskBitmap.PixelFormat := pf8bit;
            FMaskBitmap.Width := FBitmap.Width;
            FMaskBitmap.Height := FBitmap.Height;
          except
            FMaskBitmap.Free;
            FMaskBitmap := nil;
            FLoadException := True;
            Exit;
          end;
          FMaskBitmap.Canvas.Lock;
          try
            FMaskBitmap.Canvas.Brush.Color := clWhite;
{$IFNDEF QPL_CPP}
            FMaskBitmap.Canvas.FillRect(Rect(0, 0, FBitmap.Width, FBitmap.Height));
{$ENDIF}
          finally
            FMaskBitmap.Canvas.Unlock;
          end;
          SetLength(MaskRowData, FMaskBitmap.Width);
        end;

        SetLength(RowData, FWidth * 3);
        SetLength(IndexedRGB, 256);
        for IV := 0 to 255 do
        begin
          IV2 := IV;
          if IV2 >= FIndexedHival then IV2 := FIndexedHival;
          if (IV2 >= 0) and (((IV2 + 1) * 1) <= Length(FIndexedData)) then
          begin
            FSeparationColorSpace.GetColor(Ord(FIndexedData[IV2 * 1 + 1]) / 255, True);
            IndexedRGB[IV][0] := Byte((FSeparationColorSpace.ResultColor and $FF0000) shr 16);
            IndexedRGB[IV][1] := Byte((FSeparationColorSpace.ResultColor and $FF00) shr 8);
            IndexedRGB[IV][2] := Byte((FSeparationColorSpace.ResultColor and $FF));
          end else
          begin
            IndexedRGB[IV][0] := Byte(#0);
            IndexedRGB[IV][1] := Byte(#0);
            IndexedRGB[IV][2] := Byte(#0);
          end;
        end;

        for Row := 0 to FHeight - 1 do
        begin
          Offset := 0;
          for Col := 0 to FWidth - 1 do
          begin
            if FBitsPerComponent = 1 then
            begin
              Mask := 1 shl (7 - (Col mod 8));
              RowData[Offset + 1] := AnsiChar(Ord(FImageData[Row * RowLength +
                Col div 8 + 1]) and Mask shr (7 - (Col mod 8)));
            end;
            if FBitsPerComponent = 2 then
            begin
              Mask := 3 shl ((3 - (Col mod 4)) * 2);
              RowData[Offset + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 4 + 1]) and Mask) shr ((3 - (Col mod 4)) * 2)));
            end;
            if FBitsPerComponent = 4 then
            begin
              Mask := 15 shl ((1 - (Col mod 2)) * 4);
              RowData[Offset + 1] := AnsiChar(((Ord(FImageData[Row * RowLength +
                Col div 2 + 1]) and Mask) shr ((1 - (Col mod 2)) * 4)));
            end;
            if FBitsPerComponent = 8 then
              RowData[Offset + 1] := FImageData[Row * RowLength + Col + 1];

            IV := Ord(RowData[Offset + 1]);
            Move(IndexedRGB[IV][0], RowData[Offset + 1], 3);

            if FMaskType = mtColorKey then
            begin
              if (IV >= FMaskColor[0]) and (IV <= FMaskColor[1]) then
                MaskRowData[Col] := 0;
            end;

            Inc(Offset, 3);
          end;
          Move(RowData[1], FBitmap.ScanLine[Row]^, FWidth * 3);
        end;
      end;

      if Length(FICCProfile) > 0 then
      begin
        ApplyICCProfile(FBitmap);
      end;

      if (((FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'Lab')) or
        (FColorSpace = 'Lab')) then
      begin
        ConvertLabToRGB(FBitmap);
      end;

      if (FColorSpace = 'Separation') then
      begin
        ConvertSeparationToRGB(FBitmap);
      end;

    except
    end;
  end;

  if ((FMaskType = mtNone) and (not FChildMask) and (FDecodeMode <> dmToNative)
    and (not IsMonoBitmap)) then
  begin
    SetLength(FImageData, 0);
    PNGWriter := TPNGWriter.Create(FBitmap);
    try
      FImageStream := TMemoryStream.Create;
      PNGWriter.SaveToStream(FImageStream);
    finally
      PNGWriter.Free;
    end;
    if (not RenderToEPS) then
    begin
      FBitmap.Free;
      FBitmap := nil;
    end;
    FNativeType := nitPNG;
  end;

    // Now convert it to a PNG file
  if (IsImageExtraction) and (FMaskType <> mtNone) then
  begin
    DecodeMode := dmToNative;
    FNativeType  := nitPNG;

    PNGWriter := TPNGWriter.Create(FBitmap);
    try
      ReverseMask := False;
      if (FMaskType = mtStencil) then
        ReverseMask := QPLStartsWith(FMaskDecode, '[ 1 0');
      if FMaskType = mtExplicit then
        ReverseMask := QPLStartsWith(FMaskDecode, '[ 1 0');
      if (FMaskType = mtSoft) then
        ReverseMask := QPLStartsWith(FMaskDecode, '[ 1 0');
      if Assigned(FMaskBitmap) then
        PNGWriter.SetAlphaChannel(FMaskBitmap, ReverseMask);

      FImageStream := TMemoryStream.Create;
      PNGWriter.SaveToStream(FImageStream);
    finally
      PNGWriter.Free;
    end;
  end;
end;

procedure TPDFImageDecoder.LoadCCITT(DD: TQuickPDFStringList);
var
  MS: TMemoryStream;
  MyPic: TPDFPicasso;
  K: Integer;
  CCITTReverse: Boolean;
  CCITTDecoder: TQPLCCITTDecoder;
  CCITTBuffer: TCCITTByteArray;
  CCITTData: TCCITTByteArray;
  CCITTRow: Integer;
  CCITTStride: Integer;
  EncodedByteAlign: Boolean;
  MonoPal: array[0..1] of PALETTEENTRY;
  TempPal: PALETTEENTRY;
  GDIPlusCCITT: Boolean;
  TM: TPDFTIFFMaker;
  Columns: Integer;
  CMYK: TPDFCMYKColor;
  RGB: TPDFRGBColor;
  TempSettings: TGDIPlusSettings;

  function GetIntValue(const Key: AnsiString; Default: Integer): Integer;
  begin
    Result := QPLStrToIntDef(DD.Values[Key], Default);
  end;

begin
  FValidImage := True;

  K := GetIntValue('K', 0);
  EncodedByteAlign := DD.Values['EncodedByteAlign'] = 'true';

  CCITTReverse := False;
  if (DD.Values['BlackIs1'] = 'true') then
  begin
    CCITTReverse := not CCITTReverse;
  end;

  if ((not FChildMask) and (QPLStartsWith(FDecode, '[ 1 0'))) then
  begin
    CCITTReverse := not CCITTReverse;
  end;

  GDIPlusCCITT := False;

  if (IsImageExtraction) and (FMaskType = mtStencil) then
  begin
    CCITTReverse := not CCITTReverse;
    DecodeMode := dmToBitmap;
  end;

  Columns := GetIntValue('Columns', 1728);

  CCITTDecoder := TQPLCCITTDecoder.Create(Columns, FHeight,
    1, EncodedByteAlign, False, FBitsPerComponent);
  try
    SetLength(CCITTData, Length(FImageData));
    Move(FImageData[1], CCITTData[0], Length(FImageData));

    CCITTStride := (FWidth + 7) div 8;
    if (FBitsPerComponent = 8) then
      CCITTStride := FWidth;
    SetLength(CCITTBuffer, CCITTStride * FHeight);

    if (K < 0) then
    begin
      if (not CCITTDecoder.DecodeT6(CCITTBuffer, CCITTData)) then
      begin
        GDIPlusCCITT := True;
      end else
      begin
        //FImageData := '';
      end;
    end else
    if (K = 0) then
    begin
      if (not CCITTDecoder.DecodeT41D(CCITTBuffer, CCITTData)) then
      begin
        GDIPlusCCITT := True;
      end;
    end else
    if (K > 0) then
    begin
      CCITTDecoder.DecodeT42D(CCITTBuffer, CCITTData);
    end;

    if (not GDIPlusCCITT) and (DecodeMode <> dmToNative) then
    begin
      try
        FBitmap.PixelFormat := pf8bit;
        FBitmap.Width := Columns;
        FBitmap.Height := FHeight;
      except
        FLoadException := True;
        Exit;
      end;

      if (FBitsPerComponent = 1) then                                           // ADC Start
      begin

        MonoPal[0].peRed := 0;
        MonoPal[0].peGreen := 0;
        MonoPal[0].peBlue := 0;
        MonoPal[0].peFlags := PC_EXPLICIT;
        MonoPal[1].peRed := 255;
        MonoPal[1].peGreen := 255;
        MonoPal[1].peBlue := 255;
        MonoPal[1].peFlags := PC_EXPLICIT;

        if ((FColorSpace = 'DeviceGray') or (FMaskType = mtStencil)) then
        begin
          MonoPal[0].peRed := 255;
          MonoPal[0].peGreen := 255;
          MonoPal[0].peBlue := 255;
          MonoPal[0].peFlags := PC_EXPLICIT;
          MonoPal[1].peRed := 0;
          MonoPal[1].peGreen := 0;
          MonoPal[1].peBlue := 0;
          MonoPal[1].peFlags := PC_EXPLICIT;
        end else
        if ((FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceGray')) then
        begin
          if (FIndexedHival >= 1) then
          begin
            MonoPal[0].peRed := Byte(FIndexedData[2]);
            MonoPal[0].peGreen := Byte(FIndexedData[2]);
            MonoPal[0].peBlue := Byte(FIndexedData[2]);
            MonoPal[0].peFlags := PC_EXPLICIT;
            MonoPal[1].peRed := Byte(FIndexedData[1]);
            MonoPal[1].peGreen := Byte(FIndexedData[1]);
            MonoPal[1].peBlue := Byte(FIndexedData[1]);
            MonoPal[1].peFlags := PC_EXPLICIT;
          end;
        end else
        if ((FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceRGB')) then
        begin
          if (FIndexedHival >= 1) then
          begin
            MonoPal[0].peRed := Byte(FIndexedData[4]);
            MonoPal[0].peGreen := Byte(FIndexedData[5]);
            MonoPal[0].peBlue := Byte(FIndexedData[6]);
            MonoPal[0].peFlags := PC_EXPLICIT;
            MonoPal[1].peRed := Byte(FIndexedData[1]);
            MonoPal[1].peGreen := Byte(FIndexedData[2]);
            MonoPal[1].peBlue := Byte(FIndexedData[3]);
            MonoPal[1].peFlags := PC_EXPLICIT;
          end;
        end else
        if ((FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceCMYK')) then
        begin
          if (FIndexedHival >= 1) then
          begin
            CMYK.Cyan := Byte(FIndexedData[1]) / 255;
            CMYK.Magenta := Byte(FIndexedData[2]) / 255;
            CMYK.Yellow := Byte(FIndexedData[3]) / 255;
            CMYK.Black := Byte(FIndexedData[4]) / 255;
            RGB := FColorManager.CMYK2RGB(CMYK);

            MonoPal[1].peRed := Round(RGB.Red * 255);
            MonoPal[1].peGreen := Round(RGB.Green * 255);
            MonoPal[1].peBlue := Round(RGB.Blue * 255);
            MonoPal[1].peFlags := PC_EXPLICIT;

            CMYK.Cyan := Byte(FIndexedData[5]) / 255;
            CMYK.Magenta := Byte(FIndexedData[6]) / 255;
            CMYK.Yellow := Byte(FIndexedData[7]) / 255;
            CMYK.Black := Byte(FIndexedData[8]) / 255;
            RGB := FColorManager.CMYK2RGB(CMYK);

            MonoPal[0].peRed := Round(RGB.Red * 255);
            MonoPal[0].peGreen := Round(RGB.Green * 255);
            MonoPal[0].peBlue := Round(RGB.Blue * 255);
            MonoPal[0].peFlags := PC_EXPLICIT;
          end;
        end
        else
        if ((FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceN')) then
        begin
           if (FIndexedHival >= 1) then
           begin
            MonoPal[0].peRed := Byte(FIndexedData[1]);
            MonoPal[0].peGreen := Byte(FIndexedData[1]);
            MonoPal[0].peBlue := Byte(FIndexedData[1]);
            MonoPal[0].peFlags := PC_EXPLICIT;
            MonoPal[1].peRed := Byte(FIndexedData[FIndexedBaseComponents + 1]);
            MonoPal[1].peGreen := Byte(FIndexedData[FIndexedBaseComponents + 1]);
            MonoPal[1].peBlue := Byte(FIndexedData[FIndexedBaseComponents + 1]);
            MonoPal[1].peFlags := PC_EXPLICIT;
           end;

        end;

        if (CCITTReverse) then
        begin
          TempPal := MonoPal[0];
          MonoPal[0] := MonoPal[1];
          MonoPal[1] := TempPal;
        end;

{$IFDEF QPL_OS_WINDOWS}
        SetPaletteEntries(FBitmap.Palette, 0, 2, MonoPal);
{$ENDIF}
        FBitmap.PixelFormat := pf1bit;
      end
      else if (FBitsPerComponent = 8) then
      begin
        for CCITTRow := 0 to CCITTStride * (FHeight - 1) do
        begin
          CCITTBuffer[CCITTRow] := not CCITTBuffer[CCITTRow];
        end;
      end;

      for CCITTRow := 0 to FHeight - 1 do
      begin
        Move(CCITTBuffer[CCITTRow * CCITTStride],
          FBitmap.ScanLine[CCITTRow]^, CCITTStride);
      end;

      FBitmap.Width := FWidth;

      if ((FMaskType = mtStencil) and (not FChildMask) and (FDecodeMode <> dmToNative)) then
      begin
        MS := TMemoryStream.Create;
        try
          FBitmap.Canvas.Lock;
          try
            FBitmap.SaveToStream(MS);
            MS.Seek(0, soFromBeginning);
            MyPic := TPDFPicasso.Create;
            try
              TempSettings := GetGDIPlusSettings;
              MyPic.UseGDIPlusModel(FBitmap.Canvas, TempSettings);
              FImageStream := TMemoryStream.Create;
              MyPic.ConvertStream(MS, FImageStream, MyPic.PNGEncoderGUID);
            finally
              MyPic.Free;
            end;

            FNativeType := nitPNG;
            SetPNGPalette(FImageStream, 'Swap');

          finally
            FBitmap.Canvas.Unlock;

            if (not RenderToEPS) then
            begin
              FBitmap.Free;
              FBitmap := nil;
            end;
          end;

        finally
          MS.Free;
        end;
      end;
    end;
  finally
    CCITTDecoder.Free;
  end;

  if (GDIPlusCCITT) or (FDecodeMode = dmToNative) then
  begin
    TM := TPDFTIFFMaker.Create;
    try
      K := GetIntValue('K', 0);
      if K < 0 then TM.Compression := ttCCITT4;
      if K = 0 then TM.Compression := ttCCITT31d;
      if K > 0 then TM.Compression := ttCCITT32d;

      TM.EncodedByteAlign := DD.Values['EncodedByteAlign'] = 'true';
      TM.Height := FHeight;
      TM.Width := GetIntValue('Columns', 1728);

      if (TM.Compression = ttCCITT4) and TM.EncodedByteAlign then
      begin
        TM.Source := FixG4EOL(FImageData, TM.Height, TM.Width);
      end else
        TM.Source := FImageData;

      TM.Reversed := False;
      if (DD.Values['BlackIs1'] = 'true') then
      begin
        TM.Reversed := not TM.Reversed;
      end;
      if (QPLStartsWith(FDecode, '[ 1 0')) then
      begin
        TM.Reversed := not TM.Reversed;
      end;
      if (FMaskType = mtStencil) then
      begin
        TM.Reversed := not TM.Reversed;
      end;

      // The original FImageData is no longer needed
      SetLength(FImageData, 0);

      // Set the DPI to zero to prevent resolution tags being added to the TIFF
      TM.HorizontalDPI := 0;
      TM.VerticalDPI := 0;

      MS := TMemoryStream.Create;
      try
        TM.WriteTIFFToStream(MS);
        MS.Seek(0, soFromBeginning);

        if (FDecodeMode = dmToNative) then
        begin
          FNativeType := nitTIFF;
          FImageStream := TMemoryStream.Create;
          FImageStream.CopyFrom(MS, MS.Size);
        end else
        begin
          MyPic := TPDFPicasso.Create;
          try
            FBitmap.Canvas.Lock;
            try
              TempSettings := GetGDIPlusSettings;
              TempSettings.SmoothImages := False;
              MyPic.UseGDIPlusModel(FBitmap.Canvas, TempSettings);
              FImageStream := TMemoryStream.Create;
              MyPic.ConvertStream(MS, FImageStream, MyPic.PNGEncoderGUID);
            finally
              if (Assigned(FBitmap)) then
                FBitmap.Canvas.Unlock;
            end;
          finally
            MyPic.Free;
          end;
        end;
      finally
        MS.Free;
      end;
    finally
      TM.Free;
    end;
  end;
end;

procedure TPDFImageDecoder.LoadFromInlineImage(Img: TPDFInlineImage; ParentStructure: TPDFStructure);
begin
  FParentStructure := ParentStructure;
  FWidth := Img.Width;
  FHeight := Img.Height;
  FColorSpace := Img.ColorSpace;
  FFilter := Img.Filter;
  FBitsPerComponent := Img.BitsPerComponent;
  FImageData := Img.ImageData;
  FDecodeParms := Img.DecodeParms;
  FDecode := Img.Decode;
  FColorSpace := QPLStringReplace(FColorSpace, '/G', '/DeviceGray', [rfReplaceAll]);
  FColorSpace := QPLStringReplace(FColorSpace, '/RGB', '/DeviceRGB', [rfReplaceAll]);
  FColorSpace := QPLStringReplace(FColorSpace, '/CMYK', '/DeviceCMYK', [rfReplaceAll]);
  FColorSpace := QPLStringReplace(FColorSpace, '/I ', '/Indexed ', [rfReplaceAll]);
  if Assigned(Img.ColorSpaceObj) then
    FColorSpace := FindColorSpace(Img.ColorSpaceObj);
  if Img.ImageMask then FMaskType := mtStencil;
  while QPLPos('/', FColorSpace) > 0 do
    Delete(FColorSpace, QPLPos('/', FColorSpace), 1);
  if QPLStartsWith(FColorSpace, '[ Indexed ') then
  begin
    Delete(FColorSpace, 1, 10);
    Delete(FColorSpace, Length(FColorSpace) - 1, 2);
    FIndexedBaseColorSpace := QPLCopy(FColorSpace, 1, QPLPos(' ', FColorSpace) - 1);
    Delete(FColorSpace, 1, QPLPos(' ', FColorSpace));
    FIndexedHival := QPLStrToIntDef(QPLCopy(FColorSpace, 1, QPLPos(' ', FColorSpace) - 1), 0);
    Delete(FColorSpace, 1, QPLPos(' ', FColorSpace));
    if (QPLStartsWith(FColorSpace, '<')) then
    begin
      FIndexedData := SODecodeHex(FColorSpace);
    end else
    if (QPLStartsWith(FColorSpace, '(')) then
    begin
      FIndexedData := ParentStructure.DecodeString(FColorSpace);
    end else
      FIndexedData := FColorSpace;
    FColorSpace := 'Indexed';
  end;

  FIsInlineImage := True;
  Unfilter;
end;

procedure TPDFImageDecoder.LoadFromPDFStream(Source: TPDFStream);
begin
  FSource := Source;
  FParentStructure := FSource.Owner;
  ProcessImageDict;
end;

procedure TPDFImageDecoder.LoadJBIG2(JBIG2Globals: TPDFIndRef);
var
  JBIG2GlobalsData: AnsiString;
  Obj: TPDFObject;
  ImageData: TJBIG2ByteArray;
  GlobalData: TJBIG2ByteArray;
  Scanline: TJBIG2ByteArray;
  Decoder: TQPLJBIG2Decoder;
  Loaded: Boolean;
  Row: Integer;
  MonoPal: array[0..1] of PALETTEENTRY;
  TempPal: PALETTEENTRY;
  MS: TMemoryStream;
  MyPic: TPDFPicasso;
  Col: Integer;
  TempSettings: TGDIPlusSettings;
begin
  FValidImage := False;
  JBIG2GlobalsData := '';
  if Assigned(JBIG2Globals) then
  begin
    Obj := FindObject(JBIG2Globals);
    if Obj is TPDFStream then
    begin
      JBIG2GlobalsData := TPDFStream(Obj).GetDecodedStream;
    end;
  end;

  Decoder := TQPLJBIG2Decoder.Create;
  try
    SetLength(ImageData, Length(FImageData));
    Move(FImageData[1], ImageData[0], Length(FImageData));
    if Length(JBIG2GlobalsData) > 0 then
    begin
      SetLength(GlobalData, Length(JBIG2GlobalsData));
      Move(JBIG2GlobalsData[1], GlobalData[0], Length(JBIG2GlobalsData));
      Loaded := Decoder.LoadFromByteArray(ImageData, GlobalData);
    end else
    begin
      Loaded := Decoder.LoadFromByteArray(ImageData);
    end;

    if Loaded then
    begin
      FValidImage := True;
      FBitmap.Width := 1;
      FBitmap.Height := 1;
      FBitmap.PixelFormat := pf8bit;

      if (FColorSpace = '') then
      begin
        MonoPal[0].peRed := 0;
        MonoPal[0].peGreen := 0;
        MonoPal[0].peBlue := 0;
        MonoPal[1].peRed := 255;
        MonoPal[1].peGreen := 255;
        MonoPal[1].peBlue := 255;
      end;

      if ((FColorSpace = 'DeviceGray') or (FMaskType = mtStencil)) then
      begin
        MonoPal[0].peRed := 255;
        MonoPal[0].peGreen := 255;
        MonoPal[0].peBlue := 255;
        MonoPal[1].peRed := 0;
        MonoPal[1].peGreen := 0;
        MonoPal[1].peBlue := 0;
      end else
      if ((FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceRGB')) then
      begin
        if (FIndexedHival >= 1) then
        begin
          MonoPal[0].peRed := Byte(FIndexedData[4]);
          MonoPal[0].peGreen := Byte(FIndexedData[5]);
          MonoPal[0].peBlue := Byte(FIndexedData[6]);
          MonoPal[1].peRed := Byte(FIndexedData[1]);
          MonoPal[1].peGreen := Byte(FIndexedData[2]);
          MonoPal[1].peBlue := Byte(FIndexedData[3]);
        end;
      end;

      if (QPLStartsWith(FDecode, '[ 1 0')) then
      begin
        TempPal := MonoPal[0];
        MonoPal[0] := MonoPal[1];
        MonoPal[1] := TempPal;
      end;

{$IFDEF QPL_OS_WINDOWS}
      SetPaletteEntries(FBitmap.Palette, 0, 2, MonoPal);
{$ENDIF}
      FBitmap.Width := Decoder.Width;
      FBitmap.Height := Decoder.Height;
      for Row := 0 to FBitmap.Height - 1 do
      begin
        Decoder.GetScanline(Row, Scanline);
        if (FChildMask) and (FMaskType <> mtStencil) then
        begin
          if (QPLStartsWith(FDecode, '[ 1 0')) then
          begin
            for Col := 0 to FBitmap.Width - 1 do
            begin
              Scanline[Col] := 1 - Scanline[Col];
            end;
          end;
        end;
        Move(Scanline[0], FBitmap.ScanLine[Row]^, FBitmap.Width);
      end;

      // mtStencil requires images to be in PNG format to apply stencil mask
      if ((FMaskType = mtStencil) and (not FChildMask)) then
      begin
        FBitmap.PixelFormat := pf1bit;

        MS := TMemoryStream.Create;
        try
          FBitmap.Canvas.Lock;
          try
            FBitmap.SaveToStream(MS);

            MyPic := TPDFPicasso.Create;
            try
              TempSettings := GetGDIPlusSettings;
              MyPic.UseGDIPlusModel(FBitmap.Canvas, TempSettings);
              FImageStream := TMemoryStream.Create;
              MyPic.ConvertStream(MS, FImageStream, MyPic.PNGEncoderGUID);
            finally
              MyPic.Free;
            end;

            SetPNGPalette(FImageStream, 'Swap');
          finally
            FBitmap.Canvas.Unlock;
          end;

          FBitmap.Free;
          FBitmap := nil;
        finally
          MS.Free;
        end;
      end else
      begin
        if (QPLStartsWith(FDecode, '[ 1 0')) then
        begin

        end;
      end;
    end;
  finally
    Decoder.Free;
  end;
end;

procedure TPDFImageDecoder.LoadJPEG(DD: TQuickPDFStringList);
var
  SS: TStringStream;
  MyPic: TPDFPicasso;
  OutStream: TStream;
  MS: TMemoryStream;
  PJ: TPDFJPEGImage;
  TempSettings: TGDIPlusSettings;
  Invert: Boolean;
  PNGWriter: TPNGWriter;
  ReverseMask: Boolean;

begin
  FValidImage := True;
  Invert := False;

  try
    FBitmap.PixelFormat := pf24bit;
    FBitmap.Width := FWidth;
    FBitmap.Height := FHeight;
  except
    FLoadException := True;
    Exit;
  end;
  MS := nil;

  if QPLStartsWith(FImageData, #10#255#216) then
  begin
    Delete(FImageData, 1, 1);
  end;

  if (IsImageExtraction) and (FColorSpace <> 'DeviceRGB') then
    DecodeMode := dmToBitmap;

  if (IsImageExtraction) and (FMaskType <> mtNone) then
    DecodeMode := dmToBitmap;  // Extract to Bitmap now to be used later by PNG writer.

  if (DecodeMode = dmToNative) then
  begin
    FNativeType := nitJPEG;
    FImageStream := TMemoryStream.Create;
    if (Length(FImageData) > 0) then
    begin
      FImageStream.Write(FImageData[1], Length(FImageData));
      SetLength(FImageData, 0);
    end;
  end
  else
  begin
    SS := TStringStream.Create(FImageData);
    try
      OutStream := SS;

      if (FColorSpace = 'DeviceCMYK') and ((FDecode = '[ 0 1 0 1 0 1 0 1 ]') or (FDecode = '')) then
        Invert := true;

      if (FColorSpace = 'Separation') and (FSeparationColorSpace.Alternate = 'DeviceCMYK') and (FDecode = '[ 1 0 ]') then
        Invert := True;

      if (Invert) then
      begin
        MS := TMemoryStream.Create;
        PJ := TPDFJPEGImage.Create;
        try
          PJ.ColorManager := FColorManager;
          PJ.LoadFromStream(SS);
          PJ.InvertCMYK;
          PJ.SaveBitmapToStream(MS);
          OutStream := MS;
        finally
          PJ.Free;
        end;
      end;

      MyPic := TPDFPicasso.Create;
      try
        TempSettings := GetGDIPlusSettings;
        MyPic.UseGDIPlusModel(FBitmap.Canvas, TempSettings);
        MyPic.DrawAnyImage(0, 0, FBitmap.Width, FBitmap.Height, OutStream, 1, True);
      finally
        MyPic.Free;
      end;

      if (FColorSpace = 'Lab') then
      begin
        ConvertLabToRGB(FBitmap);
      end;

      if (FColorSpace = 'Separation') then
      begin
        ConvertSeparationToRGB(FBitmap);
      end;

      if (FColorSpace = 'DeviceN') then
      begin
        ConvertDeviceNToRGB(FBitmap);
      end;

    finally
      SS.Free;
      if Assigned(MS) then MS.Free;
    end;

    if Length(FICCProfile) > 0 then
    begin
      ApplyICCProfile(FBitmap);
    end;
  end;

  // Now convert it to a PNG file
  if (IsImageExtraction) and (FMaskType <> mtNone) then
  begin
    DecodeMode := dmToNative;
    FNativeType  := nitPNG;

    PNGWriter := TPNGWriter.Create(FBitmap);
    try
      ReverseMask := False;
      if (FMaskType = mtStencil) then
        ReverseMask := QPLStartsWith(FMaskDecode, '[ 1 0');
      if FMaskType = mtExplicit then
        ReverseMask := QPLStartsWith(FMaskDecode, '[ 1 0');
      if (FMaskType = mtSoft) then
        ReverseMask := QPLStartsWith(FMaskDecode, '[ 1 0');
      if Assigned(FMaskBitmap) then
        PNGWriter.SetAlphaChannel(FMaskBitmap, ReverseMask);

      FImageStream := TMemoryStream.Create;
      PNGWriter.SaveToStream(FImageStream);
    finally
      PNGWriter.Free;
    end;
  end;
end;

procedure TPDFImageDecoder.LoadJPEG2000;
{$IFDEF NOJPEG2000}
begin
end;
{$ELSE}
var
  MS: TMemoryStream;
  JB: TJpeg2000Bitmap;
  Row: Integer;
  Col: Integer;
  CMYK: TPDFCMYKColor;
  RGB: TPDFRGBColor;
  RowData: array of Byte;
  IsCMYK: Boolean;
begin
  IsCMYK := False;
  JB := TJpeg2000Bitmap.Create;
  try
    MS := TMemoryStream.Create;
    try
      MS.Write(FImageData[1], Length(FImageData));
      try
        MS.Seek(0, soFromBeginning);
        if (FColorSpace = 'DeviceCMYK') then
          isCMYK := True
        else if (FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceCMYK') then
          isCMYK := True
        else if (FColorSpace = 'DeviceN') and (Assigned(FDeviceNColorSpace)) and
          (FDeviceNColorSpace.Alternate = 'DeviceCMYK') then
            isCMYK := True
        else if (FColorSpace = 'Separation') and (Assigned(FSeparationColorSpace)) and
          (FSeparationColorSpace.Alternate = 'DeviceCMYK')then
            isCMYK := True;

        if (isCMYK) then
          JB.SetCMYK(True);

        JB.LoadFromStream(MS);
      except
        JB.Free;
        JB := nil;
      end;
    finally
      MS.Free;
    end;
    if Assigned(JB) then
    begin
      FBitmap.Assign(JB);

      if ((FBitmap.PixelFormat = pf32bit) and isCMYK) then
      begin
        SetLength(RowData, FBitmap.Width * 4);
        for Row := 0 to FBitmap.Height - 1 do
        begin
          Move(FBitmap.ScanLine[Row]^, RowData[0], Length(RowData));
          for Col := 0 to FBitmap.Width - 1 do
          begin
            CMYK.Cyan := RowData[Col * 4 + 3] / 255;
            CMYK.Magenta := RowData[Col * 4 + 2] / 255;
            CMYK.Yellow := RowData[Col * 4 + 1] / 255;
            CMYK.Black := RowData[Col * 4 + 0] / 255;
            RGB := FColorManager.CMYK2RGB(CMYK);
            RowData[Col * 4 + 0] := Round(RGB.Blue * 255);
            RowData[Col * 4 + 1] := Round(RGB.Green * 255);
            RowData[Col * 4 + 2] := Round(RGB.Red * 255);
            RowData[Col * 4 + 3] := 255;
          end;
          Move(RowData[0], FBitmap.ScanLine[Row]^, Length(RowData));
        end;
        try
          FBitmap.PixelFormat := pf24bit;
        except
          FLoadException := True;
          Exit;
        end;
      end;

      FValidImage := True;
    end;
  finally
    if Assigned(JB) then
    begin
      JB.Free;
    end;
  end;

  if (FColorSpace = 'DeviceN') then
    ConvertDeviceNToRGB(FBitmap)
  else
  if (FColorSpace = 'Indexed') then
    ProcessIndexedColorSpace
  else
  if (FColorSpace = 'Separation') then
    ConvertSeparationToRGB(FBitmap);
end;
{$ENDIF}

procedure TPDFImageDecoder.PrepareDPLRPalette;
var
  X: Integer;
  RedByte: Integer;
  GreenByte: Integer;
  BlueByte: Integer;
  AlphaByte: Integer;
begin
  AlphaByte := 255; // 100% opaque
  SetLength(FDPLRPalette, 256 * 4);
  FillChar(FDPLRPalette[0], 256 * 4, 0);

  SetLength(FIndexedData, (FIndexedHiVal + 1) * 3);  // Prevent an under / overflow
  for X := 0 to FIndexedHiVal do
  begin
    RedByte := Ord(FIndexedData[X * 3 + 1]);
    GreenByte := Ord(FIndexedData[X * 3 + 2]);
    BlueByte := Ord(FIndexedData[X * 3 + 3]);
    FDPLRPalette[X * 4 + 0] := BlueByte;
    FDPLRPalette[X * 4 + 1] := GreenByte;
    FDPLRPalette[X * 4 + 2] := RedByte;
    FDPLRPalette[X * 4 + 3] := AlphaByte;
  end;
end;

procedure TPDFImageDecoder.ProcessImageDict;
var
  Obj: TPDFObject;
  FDict: TPDFDictionary;
  DictSource: AnsiString;
  SMaskID: TPDFImageDecoder;
  MaskA: TPDFArray;
  MaskX: Integer;
  IR: TPDFIndRef;
  ColorCount: Integer;
  Temp: Double;
begin
  if Assigned(FSource) then
    FDict := FSource.Dictionary
  else
    FDict := nil;
  if Assigned(FDict) then
  begin
    DictSource := FDict.Output;
    Obj := FDict.FindValueByKeyName('Width');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFNumeric then
      FWidth := TPDFNumeric(Obj).AsInteger
    else
      FWidth := 0;
    Obj := FDict.FindValueByKeyName('Height');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFNumeric then
      FHeight := TPDFNumeric(Obj).AsInteger
    else
      FHeight := 0;
    Obj := FDict.FindValueByKeyName('Decode');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFArray then
      FDecode := TPDFArray(Obj).Output
    else
      FDecode := '';
    Obj := FDict.FindValueByKeyName('DecodeParms');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      FDecodeParms := '[ ' + TPDFDictionary(Obj).Output + ' ]';
    end else
    if Obj is TPDFArray then
    begin
      FDecodeParms := TPDFArray(Obj).Output;
    end else
      FDecodeParms := '';
    Obj := FDict.FindValueByKeyName('ColorSpace');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    FColorSpace := FindColorSpace(Obj);
    Obj := FDict.FindValueByKeyName('BitsPerComponent');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFNumeric then
      FBitsPerComponent := TPDFNumeric(Obj).AsInteger
    else
      FBitsPerComponent := 0;

    Obj := FDict.FindValueByKeyName('ImageMask');
    if (Obj is TPDFBoolean) and TPDFBoolean(Obj).AsBoolean then
    begin
      if FBitsPerComponent = 0 then
        FBitsPerComponent := 1;
      if FChildMask then
      begin
        FColorSpace := 'DeviceGray';
        if QPLStartsWith(FDecode, '[ 1 0') then
          FDecode := ''
        else
          FDecode := '[ 1 0 ]';
      end else
        FMaskType := mtStencil;
    end;

    Obj := FDict.FindValueByKeyName('Filter');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Assigned(Obj) then
      FFilter := Obj.Output
    else
      FFilter := '';
    FImageData := FSource.Stream;

    Obj := FDict.FindValueByKeyName('Interpolate');
    if (Obj is TPDFIndRef) then
    begin
      Obj := FindObject(TPDFIndRef(Obj));
    end;
    if (Obj is TPDFBoolean) then
    begin
      FInterpolate := TPDFBoolean(Obj).AsBoolean;
    end;

    if not (FChildMask) then
    begin
      if FMaskType = mtNone then
      begin
        Obj := FDict.FindValueByKeyName('SMask');
        IR := nil;
        if Obj is TPDFIndRef then
        begin
          IR := TPDFIndRef(Obj);
          Obj := FindObject(IR);
        end;
        if Obj is TPDFStream then
        begin
          SMaskID := TPDFImageDecoder.Create;
          try
            SMaskID.OnFindObject := FOnFindObject;
            SMaskID.OnDecrypt := FOnDecrypt;
            SMaskID.OnEncrypt := FOnEncrypt;
            SMaskID.ChildMask := True;

            // Decode the mask in DPLR mode too
            if (DecodeMode = dmToDPLR) then
            begin
              SMaskID.DecodeMode := dmToDPLR;
              SMaskID.DPLRPicasso := FDPLRPicasso;
            end;

            if Assigned(FOnDecrypt) and Assigned(IR) then
              FOnDecrypt(TPDFStream(Obj), IR);
            SMaskID.LoadFromPDFStream(TPDFStream(Obj));
            if Assigned(FOnEncrypt) and Assigned(IR) then
              FOnEncrypt(TPDFStream(Obj), IR);

            if (DecodeMode = dmToDPLR) then
            begin
              // For a DPLR mask, copy the TDPLImage
              if Assigned(SMaskID.FDPLRMainImage) then
              begin
                FDPLRMaskImage := SMaskID.FDPLRMainImage;
                SMaskID.FDPLRMainImage := nil;
                FMaskDecode := SMaskID.FDecode;
                FMaskType := mtSoft;
              end;
            end else
            begin
              // For a GDI+ mask, copy the TBitmap
              if Assigned(SMaskID.FBitmap) then
              begin
                if Assigned(FMaskBitmap) then FMaskBitmap.Free;
                FMaskBitmap := TBitmap.Create;
                FMaskBitmap.Assign(SMaskID.FBitmap);
                FMaskDecode := SMaskID.FDecode;
                FMaskType := mtSoft;
              end;
            end;
            FMaskFormatDesc0 := SMaskID.GetFormatDesc(TPDFStream(Obj).Dictionary, 0, True);
            FMaskFormatDesc1 := SMaskID.GetFormatDesc(TPDFStream(Obj).Dictionary, 1, True);
          finally
            SMaskID.Free;
          end;
        end;
      end;

      if FMaskType = mtNone then
      begin
        Obj := FDict.FindValueByKeyName('Mask');
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFStream then
        begin
          SMaskID := TPDFImageDecoder.Create;
          try
            SMaskID.ChildMask := True;

            // Decode the mask in DPLR mode too
            if (DecodeMode = dmToDPLR) then
            begin
              SMaskID.DecodeMode := dmToDPLR;
              SMaskID.DPLRPicasso := FDPLRPicasso;
            end;

            SMaskID.LoadFromPDFStream(TPDFStream(Obj));

            if (DecodeMode = dmToDPLR) then
            begin
              // For a DPLR mask, copy the TDPLImage
              if Assigned(SMaskID.FDPLRMainImage) then
              begin
                FDPLRMaskImage := SMaskID.FDPLRMainImage;
                SMaskID.FDPLRMainImage := nil;
                FMaskDecode := SMaskID.FDecode;
                FMaskType := mtExplicit;
              end;
            end else
            begin
              // For a GDI+ mask, copy the TBitmap
              if Assigned(SMaskID.FBitmap) then
              begin
                if Assigned(FMaskBitmap) then FMaskBitmap.Free;
                FMaskBitmap := TBitmap.Create;
                FMaskBitmap.Assign(SMaskID.FBitmap);
                FMaskDecode := SMaskID.FDecode;
                FMaskType := mtExplicit;
              end;
            end;
            FMaskFormatDesc0 := SMaskID.GetFormatDesc(TPDFStream(Obj).Dictionary, 0, True);
            FMaskFormatDesc1 := SMaskID.GetFormatDesc(TPDFStream(Obj).Dictionary, 1, True);
          finally
            SMaskID.Free;
          end;
        end else
        if Obj is TPDFArray then
        begin
          MaskA := TPDFArray(Obj);
          SetLength(FMaskColor, MaskA.Count);
          for MaskX := 0 to MaskA.Count - 1 do
          begin
            Obj := MaskA.Item[MaskX];
            if Obj is TPDFNumeric then
              FMaskColor[MaskX] := TPDFNumeric(Obj).AsDouble;
          end;

          ColorCount := MaskA.Count div 2;
          for MaskX := 0 to ColorCount - 1 do
          begin
            if (FMaskColor[MaskX] >= FMaskColor[MaskX + ColorCount]) then
            begin
              Temp := FMaskColor[MaskX];
              FMaskColor[MaskX] := FMaskColor[MaskX + ColorCount];
              FMaskColor[MaskX + ColorCount] := Temp;
            end;
          end;

          FMaskType := mtColorKey;
        end;
      end;
    end;

    Unfilter;

  end;
end;

{$IFNDEF NOJPEG2000}
procedure TPDFImageDecoder.ProcessIndexedColorSpace;
var
  NewBitmap: TBitmap;
  PF: TPixelFormat;
  RowData: array of Byte;
  NewRowData: array of Byte;
  IV: Integer;
  Row: Integer;
  Col: Integer;
  CMYK: TPDFCMYKColor;
  RGB: TPDFRGBColor;
begin
  PF := FBitmap.PixelFormat;
  if (PF = pf8bit) then
  begin
   if (FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceGray')
      and (FBitsPerComponent = 8) then
    begin
      NewBitmap := TBitmap.Create;
      try
        NewBitmap.PixelFormat := pf24bit;
        NewBitmap.Width := FWidth;
        NewBitmap.Height := FHeight;
      except
        NewBitmap.Free;
        FLoadException := True;
        Exit;
      end;

      SetLength(RowData, FWidth);
      SetLength(NewRowData, FWidth * 3);

      for Row := 0 to FHeight - 1 do
      begin
        Move(FBitmap.ScanLine[Row]^, RowData[0], FWidth);
        for Col := 0 to FWidth - 1 do
        begin
          IV := RowData[Col];
          if IV >= FIndexedHival then IV := FIndexedHival;
          if IV >= 0 then
          begin
              NewRowData[Col * 3 + 2] := Byte(FIndexedData[IV + 1]);
              NewRowData[Col * 3 + 1] := Byte(FIndexedData[IV + 1]);
              NewRowData[Col * 3] := Byte(FIndexedData[IV + 1]);
          end else
          begin
            NewRowData[Col * 3] := 0;
            NewRowData[Col * 3 + 1] := 0;
            NewRowData[Col * 3 + 2] := 0;
          end;
        end;
        Move(NewRowData[0], NewBitmap.ScanLine[Row]^, FWidth * 3);
      end;

      FBitmap.Free;
      FBitmap := NewBitmap;
    end;

    if (FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceRGB')
      and (FBitsPerComponent = 8) then
    begin
      NewBitmap := TBitmap.Create;
      try
        NewBitmap.PixelFormat := pf24bit;
        NewBitmap.Width := FWidth;
        NewBitmap.Height := FHeight;
      except
        NewBitmap.Free;
        FLoadException := True;
        Exit;
      end;

      SetLength(RowData, FWidth);
      SetLength(NewRowData, FWidth * 3);

      for Row := 0 to FHeight - 1 do
      begin
        Move(FBitmap.ScanLine[Row]^, RowData[0], FWidth);
        for Col := 0 to FWidth - 1 do
        begin
          IV := RowData[Col];
          if IV >= FIndexedHival then IV := FIndexedHival;
          if IV >= 0 then
          begin
              NewRowData[Col * 3 + 2] := Byte(FIndexedData[IV * 3 + 1]);
              NewRowData[Col * 3 + 1] := Byte(FIndexedData[IV * 3 + 2]);
              NewRowData[Col * 3] := Byte(FIndexedData[IV * 3 + 3]);
          end else
          begin
            NewRowData[Col * 3] := 0;
            NewRowData[Col * 3 + 1] := 0;
            NewRowData[Col * 3 + 2] := 0;
          end;
        end;
        Move(NewRowData[0], NewBitmap.ScanLine[Row]^, FWidth * 3);
      end;

      FBitmap.Free;
      FBitmap := NewBitmap;
    end;

    if (FColorSpace = 'Indexed') and (FIndexedBaseColorSpace = 'DeviceCMYK')
      and (FBitsPerComponent = 8) then
    begin
      NewBitmap := TBitmap.Create;
      try
        NewBitmap.PixelFormat := pf24bit;
        NewBitmap.Width := FWidth;
        NewBitmap.Height := FHeight;
      except
        NewBitmap.Free;
        FLoadException := True;
        Exit;
      end;

      SetLength(RowData, FWidth);
      SetLength(NewRowData, FWidth * 3);

      for Row := 0 to FHeight - 1 do
      begin
        Move(FBitmap.ScanLine[Row]^, RowData[0], FWidth);
        for Col := 0 to FWidth - 1 do
        begin
          IV := RowData[Col];
          if IV >= FIndexedHival then IV := FIndexedHival;
          if IV >= 0 then
          begin
            CMYK.Cyan := Ord(FIndexedData[IV * 4 + 1]) / 255;
            CMYK.Magenta := Ord(FIndexedData[IV * 4 + 2]) / 255;
            CMYK.Yellow := Ord(FIndexedData[IV * 4 + 3]) / 255;
            CMYK.Black := Ord(FIndexedData[IV * 4 + 4]) / 255;
            RGB := FColorManager.CMYK2RGB(CMYK);
            NewRowData[Col * 3 ] := Round(RGB.Blue * 255);
            NewRowData[Col * 3 + 1] := Round(RGB.Green * 255);
            NewRowData[Col * 3 + 2] := Round(RGB.Red * 255);
          end else
          begin
            NewRowData[Col * 3] := 0;
            NewRowData[Col * 3 + 1] := 0;
            NewRowData[Col * 3 + 2] := 0;
          end;
        end;
        Move(NewRowData[0], NewBitmap.ScanLine[Row]^, FWidth * 3);
      end;

      FBitmap.Free;
      FBitmap := NewBitmap;
    end;
  end;
end;
{$ENDIF}

procedure TPDFImageDecoder.SetColorManager(
  NewColorManager: TPDFColorManager);
begin
  if FPrivateColorManager then FColorManager.Free;
  FColorManager := NewColorManager;
  FPrivateColorManager := False;
end;

procedure TPDFImageDecoder.Unfilter;
var
  Obj: TPDFObject;
  FA: TPDFArray;
  DA: TPDFArray;
  FN: AnsiString;
  TempStructure: TPDFStructure;
  LeftOver: AnsiString;
  LeftOverDD: TPDFDictionary;
  DD: TPDFDictionary;
  SL: TQuickPDFStringList;
  DS: AnsiString;
  FlateParms: TPDFFlateParms;
  LZWDecompressor: TPDFLZWDecompressor;
  LZWParms: TPDFLZWParms;
  JBIG2Globals: TPDFIndRef;

  procedure GetParms(ADict: TPDFDictionary);
  var
    DX: Integer;
  begin
    SL.Clear;
    if Assigned(ADict) then
    begin
      for DX := 0 to ADict.Count - 1 do
      begin
        Obj := ADict.Entry[DX].Key;
        if Assigned(Obj) and (Obj is TPDFName) then
        begin
          DS := TPDFName(Obj).Name;
          Obj := ADict.Entry[DX].Value;
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Assigned(Obj) then
          begin
            DS := DS + '=' + Obj.Output;
            SL.Add(DS);
          end;
        end;
      end;
    end;
  end;

begin
  SL := TQuickPDFStringList.Create;
  try
    LeftOver := '';
    LeftOverDD := nil;
    JBIG2Globals := nil;

    if QPLPos('[', FFilter) = 0 then FFilter := '[ ' + QPLTrim(FFilter) + ' ]';
    TempStructure := TPDFStructure.Create;
    try
      if Assigned(FParentStructure) then
      begin
        TempStructure.OnIndObjLookup := FParentStructure.OnIndObjLookup;
      end;

      Obj := TempStructure.Decode(FFilter);
      if Obj is TPDFArray then
        FA := TPDFArray(Obj)
      else
        FA := nil;
      Obj := TempStructure.Decode(FDecodeParms);
      if Obj is TPDFArray then
        DA := TPDFArray(Obj)
      else
        DA := nil;
      if Assigned(FA) then
      begin
        if not Assigned(DA) then
          DA := TempStructure.NewArray;
        while DA.Count < FA.Count do
          DA.Add(TempStructure.NewNull);
        while FA.Count > 0 do
        begin
          Obj := FA.Item[0];
          if Obj is TPDFName then
          begin
            FN := TPDFName(Obj).Name;
            Obj := DA.Item[0];
            if (Obj is TPDFIndRef) then
            begin
              Obj := FindObject(TPDFIndRef(Obj));
            end;
            if (Obj is TPDFDictionary) then
            begin
              DD := TPDFDictionary(Obj);
            end else
            begin
              DD := nil;
            end;
            if ((FN = 'LZWDecode') or (FN = 'LZW')) then
            begin
              GetParms(DD);
              LZWDecompressor := TPDFLZWDecompressor.Create;
              try
                LZWDecompressor.FillOrder := foTop;
                LZWDecompressor.InitialCodeSize := 9;
                LZWDecompressor.EarlyChange := QPLStrToIntDef(SL.Values['EarlyChange'], 1) = 1;
                if QPLStrToIntDef(SL.Values['Predictor'], 0) > 0 then
                begin
                  LZWParms.Predictor := QPLStrToIntDef(SL.Values['Predictor'], 1);
                  LZWParms.Colors := QPLStrToIntDef(SL.Values['Colors'], 1);
                  LZWParms.BitsPerComponent := QPLStrToIntDef(SL.Values['BitsPerComponent'], 8);
                  LZWParms.Columns := QPLStrToIntDef(SL.Values['Columns'], 1);
                  LZWParms.ExpandedTo8Bit := False;
                  LZWParms.ColorSpace := FColorSpace;
                  FImageData := LZWDecompressor.Decompress(FImageData, LZWParms);
                end else
                  FImageData := LZWDecompressor.Decompress(FImageData);
              finally
                LZWDecompressor.Free;
              end;
            end;
            if ((FN = 'RunLengthDecode') or (FN = 'RL')) then
            begin
              FImageData := RLEDecode(FImageData);
            end;
            if ((FN = 'FlateDecode') or (FN = 'Fl')) then
            begin
              GetParms(DD);
              if SL.Count > 0 then
              begin
                FlateParms.Predictor := QPLStrToIntDef(SL.Values['Predictor'], 1);
                FlateParms.Colors := QPLStrToIntDef(SL.Values['Colors'], 1);
                FlateParms.BitsPerComponent := QPLStrToIntDef(SL.Values['BitsPerComponent'], 8);
                FlateParms.Columns := QPLStrToIntDef(SL.Values['Columns'], 1);
                FlateParms.ExpandedTo8Bit := False;
                FlateParms.ColorSpace := FColorSpace;
                FImageData := InflateStrParms(FImageData, FlateParms);
                if FlateParms.ExpandedTo8Bit then
                begin
                  FBitsPerComponent := 8;
                end;
              end else
                FImageData := InflateStr(FImageData);
            end;
            if ((FN = 'ASCIIHexDecode') or (FN = 'AHx')) then
            begin
              FImageData := SODecodeHex('<' + FImageData + '>');
            end;
            if ((FN = 'ASCII85Decode') or (FN = 'A85')) then
            begin
              FImageData := ASCII85Decode(FImageData);
            end;
            if ((FN = 'DCTDecode') or (FN = 'DCT') or (FN = 'JPEGDecode')) then
            begin
              LeftOver := 'DCTDecode';
              LeftOverDD := DD;
            end;
            if ((FN = 'CCITTFaxDecode') or (FN = 'CCF')) then
            begin
              LeftOver := 'CCITTFaxDecode';
              LeftOverDD := DD;
            end;
            if FN = 'JBIG2Decode' then
            begin
              LeftOver := 'JBIG2Decode';
              if Assigned(DD) then
              begin
                Obj := DD.FindValueByKeyName('JBIG2Globals');
                if Obj is TPDFIndRef then
                begin
                  JBIG2Globals := TPDFIndRef(Obj);
                end;
              end;
            end;
            if FN = 'JPXDecode' then
            begin
              LeftOver := 'JPXDecode';
              LeftOverDD := DD;
            end;
          end;
          FA.Delete(0);
          DA.Delete(0);
        end;
      end;

      GetParms(LeftOverDD);

      if (DecodeMode = dmToDPLR) then
      begin
        // Move FImageData (AnsiString) to FDPLRImageData (byte array) and
        // empty FImageData
        if (Length(FImageData) > 0) then
        begin
          SetLength(FDPLRImageData, Length(FImageData));
          Move(FImageData[1], FDPLRImageData[0], Length(FImageData));
          FImageData := '';

          if LeftOver = '' then
          begin
            LoadDPLRBMP;
          end;

          if LeftOver = 'DCTDecode' then LoadDPLRJPEG(SL);
          if LeftOver = 'CCITTFaxDecode' then LoadDPLRCCITT(SL);
          if LeftOver = 'JPXDecode' then LoadDPLRJPEG2000;
          if LeftOver = 'JBIG2Decode' then LoadDPLRJBIG2(JBIG2Globals);

          DPLRPostProcess;
        end;
      end else
      begin
        if LeftOver = '' then
        begin
          LoadBMP;
        end;
        if LeftOver = 'DCTDecode' then LoadJPEG(SL);
        if LeftOver = 'CCITTFaxDecode' then LoadCCITT(SL);
        if LeftOver = 'JPXDecode' then LoadJPEG2000;
        if LeftOver = 'JBIG2Decode' then LoadJBIG2(JBIG2Globals);
      end;
    finally
      TempStructure.Free;
    end;
  finally
    SL.Free;
  end;
end;

function DecodeInlineImage(const Source: AnsiString; var TokPos: Integer;
  var InlineImage: TPDFInlineImage; ResourceDict: TPDFDictionary;
  FindObjectEvent: TPDFFindObjectEvent): Boolean;
var
  Tok: AnsiString;
  MaxLen: Integer;
  AX: Integer;
  TestDeflate: AnsiString;
  EnoughData: Boolean;
  BaseColorSpace: AnsiString;
  ColorIndexLookup: AnsiString;
  IndexedData: AnsiString;
  IndexValue: Integer;
  Limit: Integer;
  Offset: Integer;

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
        case Source[TokPos] of
          #0,#9,#10,#12,#13,#32:
          begin
            InWhitespace := True;
            Inc(TokPos);
          end;
        end;
      until (not InWhitespace) or (TokPos > MaxLen);
      if TokPos = MaxLen then
      begin
        Result := Source[TokPos];
        TokPos := MaxLen + 1;
      end else
      if TokPos < MaxLen then
      begin
        TokStart := TokPos;
        if Source[TokStart] = '(' then
        begin
          InStr := 1;
          InSlash := False;
          repeat
            Inc(TokPos);
            if InSlash then
            begin
              InSlash := False;
            end else
            case Source[TokPos] of
              '\': InSlash := True;
              ')': Dec(InStr);
              '(': Inc(InStr);
            end;
          until (InStr = 0) or (TokPos >= MaxLen);
          Inc(TokPos);
          Result := QPLCopy(Source, TokStart, TokPos - TokStart);
        end else
        if (Source[TokStart] = '<') then
        begin
          repeat
            Inc(TokPos);
          until (Source[TokPos] = '>') or (TokPos >= (MaxLen - 2));
          repeat
            Inc(TokPos);
          until (Source[TokPos] <> '>') or (TokPos >= (MaxLen - 2));
          Result := QPLCopy(Source, TokStart, TokPos - TokStart);
        end else
        if (Source[TokStart] = '[') or (Source[TokStart] = ']') or (Source[TokStart] = '''') then
        begin
          Result := Source[TokStart];
          Inc(TokPos);
        end else
        begin
          repeat
            Inc(TokPos);
            InWhitespace := False;
            case Source[TokPos] of
              #0,#9,#10,#12,#13,#32,#40,#47,#60,#91,#93: InWhitespace := True;
            end;
          until (InWhitespace) or (TokPos >= MaxLen);
          if (not InWhitespace) and (TokPos = MaxLen) then Inc(TokPos);
          TokEnd := TokPos - 1;
          Result := QPLCopy(Source, TokStart, TokEnd - TokStart + 1);
          if InWhitespace and (TokPos = MaxLen) then Inc(TokPos);
        end;
      end else
        Result := '';
    end else
      Result := '';
  end;

  function Expand(const S: AnsiString): AnsiString;
  begin
    Result := S;
    if QPLStartsWith(Result, '/') then
    begin
      if S = '/G' then Result := '/DeviceGray' else
      if S = '/RGB' then Result := '/DeviceRGB' else
      if S = '/CMYK' then Result := '/DeviceCMYK' else
      if S = '/I' then Result := '/Indexed' else
      if S = '/AHx' then Result := '/ASCIIHexDecode' else
      if S = '/A85' then Result := '/ASCII85Decode' else
      if S = '/LZW' then Result := '/LZWDecode' else
      if S = '/Fl' then Result := '/FlateDecode' else
      if S = '/RL' then Result := '/RunLengthDecode' else
      if S = '/CCF' then Result := '/CCITTFaxDecode' else
      if S = '/DCT' then Result := '/DCTDecode';
    end;
  end;

  function FindObject(IR: TPDFIndRef): TPDFObject;
  begin
    if Assigned(FindObjectEvent) then
      Result := FindObjectEvent(IR)
    else
      Result := IR.Obj;
  end;

  function FindColorSpace(const Name: AnsiString): AnsiString;
  const
    PassThrough: AnsiString = '/DeviceGray/DeviceRGB/DeviceCMYK/Indexed';
  var
    Obj: TPDFObject;
    CS: TPDFDictionary;
    A: TPDFArray;
  begin
    if QPLPos(Name, PassThrough) > 0 then
    begin
      Result := Copy(Name, 2, MaxInt)
    end else
    if (Assigned(ResourceDict)) then
    begin
      Result := '/DeviceRGB';
      Obj := ResourceDict.FindValueByKeyName('ColorSpace');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then
      begin
        CS := TPDFDictionary(Obj);
        Obj := CS.FindValueByKeyName(Copy(Name, 2, MaxInt));
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFArray then
        begin
          A := TPDFArray(Obj);
          if A.Count > 1 then
          begin
            Obj := A.Item[0];
            if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
            if Obj is TPDFName then
            begin
              Result := TPDFName(Obj).Name;
              if Result = 'Indexed' then
              begin
                Obj := A.Item[1];
                if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
                if Obj is TPDFName then
                  BaseColorSpace := TPDFName(Obj).Name
                else if Obj is TPDFArray then
                begin
                  Obj := TPDFArray(Obj).Item[0];
                  if (Obj is TPDFName) then
                    BaseColorSpace := TPDFName(Obj).Name
                end;

                Obj := A.Item[2];
                if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
                if Obj is TPDFNumeric then
                  Limit := TPDFNumeric(Obj).AsInteger
                else
                  Limit := 255;
                Obj := A.Item[3];
                if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
                if Obj is TPDFStream then
                  ColorIndexLookup := TPDFStream(Obj).Stream;
                if Obj is TPDFString then
                  ColorIndexLookup := TPDFString(Obj).AsString;
                if (BaseColorSpace = 'DeviceRGB') and
                  (Length(ColorIndexLookup) <= (Limit + 1) * 3) then
                    SetLength(ColorIndexLookup, (Limit + 1) * 3);
                if (BaseColorSpace = 'CalRGB') and
                  (Length(ColorIndexLookup) <= (Limit + 1) * 3) then
                    SetLength(ColorIndexLookup, (Limit + 1) * 3);
                if (BaseColorSpace = 'DeviceCMYK') and
                  (Length(ColorIndexLookup) <= (Limit + 1) * 4) then
                    SetLength(ColorIndexLookup, (Limit + 1) * 4);
              end else
              if Result = 'CalRGB' then
              begin
                Result := 'DeviceRGB';
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  function IsValidEI(TokPos: Integer): Boolean;
  var
    I: Integer;
  begin
    Result := True;
    if not (Source[TokPos] in [#0, #9, #10, #12, #13, #32]) then
      Result := False;

    if (Result) then
    begin
      if (TokPos <= MaxLen - 10) then
      begin
        for I := 1 to 10 do
          if ((Source[TokPos + I] < ' ') or (Source[TokPos + 2] > 'z')) and not (Source[TokPos + I] in [#0, #9, #10, #12, #13, #32]) then
            Result := False;
      end;
    end;
  end;

begin
  Result := False;
  MaxLen := Length(Source);
  InlineImage.Width := 0;
  InlineImage.Height := 0;
  InlineImage.BitsPerComponent := 0;
  InlineImage.ColorSpace := '';
  InlineImage.ColorSpaceObj := nil;
  InlineImage.ImageData := '';
  InlineImage.ImageMask := False;
  InlineImage.Decode := '';
  InlineImage.DecodeParms := '';
  InlineImage.Filter := '';
  repeat
    Tok := NextToken;
    if (Tok = '/W') or (Tok = '/Width') then
    begin
      InlineImage.Width := QPLStrToIntDef(NextToken, 0);
    end else
    if (Tok = '/H') or (Tok = '/Height') then
    begin
      InlineImage.Height := QPLStrToIntDef(NextToken, 0);
    end else
    if (Tok = '/BPC') or (Tok = '/BitsPerComponent') then
    begin
      InlineImage.BitsPerComponent := QPLStrToIntDef(NextToken, 0);
    end else
    if (Tok = '/IM') or (Tok = '/ImageMask') then
    begin
      InlineImage.ImageMask := NextToken = 'true';
      if InlineImage.ImageMask then
      begin
        InlineImage.ColorSpace := '/DeviceGray';
      end;
    end else
    if (Tok = '/CS') or (Tok = '/ColorSpace') then
    begin
      Tok := Expand(NextToken);
      if Tok = '[' then
      begin
        InlineImage.ColorSpace := '[ ';
        repeat
          Tok := Expand(NextToken);
          InlineImage.ColorSpace := InlineImage.ColorSpace + Tok + ' ';
        until Tok = ']';
        InlineImage.ColorSpace := QPLTrim(InlineImage.ColorSpace);
      end else
        InlineImage.ColorSpace := Tok;
      if Copy(InlineImage.ColorSpace, 1, 1) = '/' then
        InlineImage.ColorSpace := FindColorSpace(InlineImage.ColorSpace);
    end else
    if (Tok = '/D') or (Tok = '/Decode') then
    begin
      Tok := NextToken;
      if Tok = '[' then
      begin
        InlineImage.Decode := '[ ';
        repeat
          Tok := NextToken;
          InlineImage.Decode := InlineImage.Decode + Tok + ' ';
        until Tok = ']';
        InlineImage.Decode := QPLTrim(InlineImage.Decode);
      end else
        InlineImage.Decode := Tok;
    end else
    if (Tok = '/DP') or (Tok = '/DecodeParms') then
    begin
      Tok := NextToken;
      if Tok = '[' then
      begin
        InlineImage.DecodeParms := '[ ';
        repeat
          Tok := NextToken;
          InlineImage.DecodeParms := InlineImage.DecodeParms + Tok + ' ';
        until Tok = ']';
        InlineImage.DecodeParms := QPLTrim(InlineImage.DecodeParms);
      end else
        InlineImage.DecodeParms := '[ ' + QPLTrim(Tok) + ' ]';
    end else
    if (Tok = '/F') or (Tok = '/Filter') then
    begin
      Tok := Expand(NextToken);
      if Tok = '[' then
      begin
        InlineImage.Filter := '[ ';
        repeat
          Tok := Expand(NextToken);
          InlineImage.Filter := InlineImage.Filter + Tok + ' ';
        until Tok = ']';
        InlineImage.Filter := QPLTrim(InlineImage.Filter);
      end else
        InlineImage.Filter := Tok;
    end;
  until (Tok = 'ID') or (Tok = '');

  if (InlineImage.BitsPerComponent = 0) and (InlineImage.ColorSpace = '/DeviceGray') then
    InlineImage.BitsPerComponent := 1;

  if (Tok = 'ID') then
  begin
    if InlineImage.Filter = '/DCTDecode' then
    begin
      InlineImage.ImageStart := TokPos;
      Inc(TokPos);
      Tok := QPLCopy(Source, TokPos, 2);
      if Tok = #$FF#$D8 then
      begin
        Inc(TokPos, 2);
        repeat
          Tok := QPLCopy(Source, TokPos, 2);
          Inc(TokPos, 2);

          if (Tok[1] = #$FF) and ((Tok[2] >= #$D0) and (Tok[2] <= #$D7)) then
          begin
            repeat
              Inc(TokPos);
            until (TokPos > (MaxLen - 2)) or ((Source[TokPos] = #$FF) and (Source[TokPos + 1] <> #0));
          end
          else
          if (Tok[1] = #$FF) and (Tok <> #$FF#$D9) then
          begin
            AX := Ord(Source[TokPos + 0]) * 256 + Ord(Source[TokPos + 1]);
            Inc(TokPos, AX);
          end;

          if (Tok = #$FF#$DA) then
          begin
            repeat
              Inc(TokPos);
            until (TokPos > (MaxLen - 2)) or ((Source[TokPos] = #$FF) and (Source[TokPos + 1] <> #0));
          end;
        until (TokPos > (MaxLen - 2)) or (Tok = #$FF#$D9) or (Tok[1] <> #$FF);

        if Tok = #$FF#$D9 then
        begin
          InlineImage.ImageEnd := TokPos;
          repeat
            Tok := NextToken;
          until (Tok = 'EI') or (Tok = '');
        end;

      end;
    end else
    if ((InlineImage.Filter = '/ASCII85Decode') or (QPLPos('/ASCII85Decode', InlineImage.Filter) = 3)) then
    begin

      if Tok <> 'EI' then
      begin
        InlineImage.ImageStart := TokPos;
        InlineImage.ImageEnd := TokPos;
        repeat
          Inc(TokPos);
        until ((Source[TokPos] = '~') and (Source[TokPos + 1] = '>')) or (TokPos >= (MaxLen - 2));

        if (TokPos < MaxLen - 2) then  // we found it.
          InlineImage.ImageEnd := TokPos + 1;

        repeat
          Tok := NextToken;
        until (Tok = 'EI') or (Tok = '');

        //if (TokPos <= (MaxLen - 2)) then
          Tok := 'EI';
      end;
    end else
    if (InlineImage.Filter = '') then
    begin
      InlineImage.ImageStart := TokPos;
      AX := InlineImage.Width * InlineImage.BitsPerComponent div 8;
      if (AX * 8) < InlineImage.Width then Inc(AX);
      AX := AX * InlineImage.Height;
      if (InlineImage.ColorSpace = 'RGB') or (InlineImage.ColorSpace = 'DeviceRGB') then
        AX := AX * 3;
      if (InlineImage.ColorSpace = 'CMYK') or (InlineImage.ColorSpace = 'DeviceCMYK') then
        AX := AX * 4;
      TokPos := TokPos + AX;
      repeat
        InlineImage.ImageEnd := TokPos;
        Inc(TokPos);
        Tok := QPLCopy(Source, TokPos, 2);
      until (Tok = 'EI') or (Tok = '');
    end else
    if (InlineImage.Filter = '/FlateDecode') then
    begin
      InlineImage.ImageStart := TokPos;
      AX := InlineImage.Width * InlineImage.BitsPerComponent div 8;
      if (AX * 8) < InlineImage.Width then Inc(AX);
      AX := AX * InlineImage.Height;
      if (InlineImage.ColorSpace = 'RGB') or (InlineImage.ColorSpace = 'DeviceRGB') or (InlineImage.ColorSpace = 'ICCBased') then
        AX := AX * 3;
      if (InlineImage.ColorSpace = 'CMYK') or (InlineImage.ColorSpace = 'DeviceCMYK') then
        AX := AX * 4;
      InlineImage.ImageStart := TokPos;

      repeat
        repeat
          Inc(TokPos);
        until ((Source[TokPos] = 'E') and (Source[TokPos + 1] = 'I') and IsValidEI(TokPos + 2)) or (TokPos >= (MaxLen - 2));

        InlineImage.ImageEnd := TokPos;
        if (TokPos < (MaxLen - 2)) then
          Tok := 'EI';

        TestDeflate := InflateStr(QPLCopy(Source, InlineImage.ImageStart + 1,
          InlineImage.ImageEnd - InlineImage.ImageStart + 2));

        EnoughData := (AX - Length(TestDeflate)) < 4;
      until EnoughData or (TokPos >= (MaxLen - 2));
    end else
    if (InlineImage.Filter = '[ /FlateDecode /RunLengthDecode ]') then
    begin
      InlineImage.ImageStart := TokPos;
      AX := InlineImage.Width * InlineImage.BitsPerComponent div 8;
      if (AX * 8) < InlineImage.Width then Inc(AX);
      AX := AX * InlineImage.Height;
      if (InlineImage.ColorSpace = 'RGB') or (InlineImage.ColorSpace = 'DeviceRGB') then
        AX := AX * 3;
      if (InlineImage.ColorSpace = 'CMYK') or (InlineImage.ColorSpace = 'DeviceCMYK') then
        AX := AX * 4;
      InlineImage.ImageStart := TokPos;

      repeat
        repeat
          Inc(TokPos);
        until ((Source[TokPos] = 'E') and (Source[TokPos + 1] = 'I') and IsValidEI(TokPos + 2)) or (TokPos >= (MaxLen - 2));

        InlineImage.ImageEnd := TokPos;
        if (TokPos < (MaxLen - 2)) then
          Tok := 'EI';

        TestDeflate := InflateStr(QPLCopy(Source, InlineImage.ImageStart + 1,
          InlineImage.ImageEnd - InlineImage.ImageStart + 2));

        TestDeflate := RLEDecode(TestDeflate);

        EnoughData := (AX - Length(TestDeflate)) < 4;
      until EnoughData or (TokPos >= (MaxLen - 2));
    end;

    if Tok <> 'EI' then
    begin
      InlineImage.ImageStart := TokPos;
      repeat
        Inc(TokPos);
      until ((Source[TokPos] = 'E') and (Source[TokPos + 1] = 'I') and IsValidEI(TokPos + 2)) or (TokPos >= (MaxLen - 2));

      InlineImage.ImageEnd := TokPos;
      if (TokPos <= (MaxLen - 2)) then
        Tok := 'EI';
    end;

    if Tok = 'EI' then
    begin
      Result := True;
      Inc(InlineImage.ImageStart);
      InlineImage.ImageData := QPLCopy(Source, InlineImage.ImageStart,
        InlineImage.ImageEnd - InlineImage.ImageStart + 1);
      if InlineImage.ColorSpace = 'Indexed' then
      begin
        with TPDFString.Create(nil) do
        begin
          SetTo(ColorIndexLookup);
          InlineImage.ColorSpace := '[ /Indexed /' + BaseColorSpace + ' ' +
            QPLIntToStr(Limit) + ' ' + Output + ' ]';
          Free;
        end;
      end;
      if InlineImage.ColorSpace = 'Indexed1' then
      begin
        InlineImage.ColorSpace := BaseColorSpace;
        if InlineImage.Filter = '/FlateDecode' then
          IndexedData := InflateStr(InlineImage.ImageData);
        InlineImage.Filter := '';
        if ((BaseColorSpace = 'DeviceRGB') or (BaseColorSpace = 'ICCBased')) and (InlineImage.BitsPerComponent = 8) then
        begin
          SetLength(InlineImage.ImageData, Length(IndexedData) * 3);
          Offset := 0;
          for AX := 1 to Length(IndexedData) do
          begin
            Move(ColorIndexLookup[Ord(IndexedData[AX]) + 1],
              InlineImage.ImageData[Offset - 2], 3);
            Inc(Offset, 3);
          end;
        end else
        if (BaseColorSpace = 'DeviceRGB') and (InlineImage.BitsPerComponent = 4) then
        begin
          SetLength(InlineImage.ImageData, Length(IndexedData) * 6);
          Offset := 6;
          for AX := 1 to Length(IndexedData) do
          begin
            IndexValue := Ord(IndexedData[AX]);
            Move(ColorIndexLookup[(IndexValue and $0f) + 1],
              InlineImage.ImageData[Offset - 2], 3);
            Move(ColorIndexLookup[((IndexValue and $f0) shr 4) + 1],
              InlineImage.ImageData[Offset - 5], 3);
            Inc(Offset, 6);
          end;
        end else
        if (BaseColorSpace = 'DeviceCMYK') and (InlineImage.BitsPerComponent = 8) then
        begin
          SetLength(InlineImage.ImageData, Length(IndexedData) * 4);
          Offset := 4;
          for AX := 1 to Length(IndexedData) do
          begin
            Move(ColorIndexLookup[Ord(IndexedData[AX]) + 1],
              InlineImage.ImageData[Offset - 3], 4);
            Inc(Offset, 4);
          end;
        end;
      end;
    end;
  end;
end;

procedure TPDFImageDecoder.SetPNGPalette(PNGStream: TStream;
  const Operation: AnsiString; NewColor: TColor);
var
  PNGReader: TPNGReader;
  tRNSChunk: AnsiString;
begin
  PNGReader := TPNGReader.Create;
  try
    PNGReader.SkipImageData := True;
    PNGStream.Seek(0, soFromBeginning);
    PNGReader.LoadFromStream(PNGStream);

    // Expecting a paletted PNG image containing two palette entries
    if ((PNGReader.PalettePosition > 0) and (PNGReader.PaletteSize = 2)) then
    begin
      // Locate the position of the palette in the PNG data stream
      PNGStream.Seek(PNGReader.PalettePosition, soFromBeginning);

      if (Operation = 'Reset') then
      begin
        PNGStream.Write(FOriginalPNGPalette[0], 3);
        PNGStream.Write(FOriginalPNGPalette[1], 3);
      end else
      begin
        if (Operation = 'Swap') then
        begin
          PNGStream.Read(FOriginalPNGPalette[1], 3);
          PNGStream.Read(FOriginalPNGPalette[0], 3);
          PNGStream.Seek(PNGReader.PalettePosition, soFromBeginning);
          PNGStream.Write(FOriginalPNGPalette[0], 3);
          PNGStream.Write(FOriginalPNGPalette[1], 3);
        end else
        if (Operation = 'SetTrans') then
        begin
          PNGStream.Read(FOriginalPNGPalette[0], 3);
          PNGStream.Read(FOriginalPNGPalette[1], 3);
          PNGStream.Seek(PNGReader.PalettePosition, soFromBeginning);

          if (FOriginalPNGPalette[0] = clBlack) then
          begin
            // Write the current color into the second palette entry
            PNGStream.Seek(3, soFromCurrent);
            PNGStream.Write(NewColor, 3);

            // Set up the transparency chunk
            tRNSChunk := #0#0#0#2'tRNS'#$00#$FF#$5B#$91#$22#$B5;
          end else
          begin
            // Write the current color into the first palette entry
            PNGStream.Write(NewColor, 3);

            // Set up the transparency chunk
            tRNSChunk := #0#0#0#2'tRNS'#$FF#$00#$E5#$B7#$30#$4A;
          end;

          // Check for a "tRNS" chunk that specifies the alpha transparency
          // for each palette entry
          if (PNGReader.TransparencyPosition = 0) then
          begin
            // No "tRNS" chunk was found, insert one containing two
            // entries (opaque and transparent) just before the first "IDAT"
            // image data chunk
            QPLStreamInsert(PNGStream, tRNSChunk, PNGReader.FirstDataPosition);
          end else
          begin
            // Replace the existing tRNS chunk
            PNGStream.Seek(PNGReader.TransparencyPosition, soFromBeginning);
            PNGStream.Write(tRNSChunk[1], Length(tRNSChunk));
          end;
        end;
      end;
    end;
  finally
    PNGReader.Free;
  end;
end;

end.
