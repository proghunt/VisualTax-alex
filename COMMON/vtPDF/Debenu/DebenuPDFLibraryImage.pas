{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryImage.pas                              }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryImage;

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
  Classes,
{$IFNDEF VER120}
  contnrs,
{$ENDIF}
  DebenuPDFLibraryTIFF, DebenuPDFLibraryPNG, DebenuPDFLibraryStructure,
  DebenuPDFLibraryFont, DebenuPDFLibraryPicasso, DebenuPDFLibraryExtra;

type
  TPDFImageType = (itUnknown, itJPEG, itBMP, itTIFF, itPNG, itWMF, itEMF, itGIF);
  TPDFMaskType = (mtUnknown, mtStencilMask, mtSoftMask);

  TPDFImage = class
  private
    FImageData: AnsiString;
    FStructure: TPDFStructure;
    FName: AnsiString;
    FIndRef: TPDFIndRef;
    FWidth: Integer;
    FHeight: Integer;
    FImageDictionary: TPDFDictionary;
    FPageDict: TPDFDictionary;
    FImageType: TPDFImageType;
    FCompress: Integer;
    FCompressFonts: Boolean;
    FEMFImageType: Integer;
    FRecompressImage: Boolean;
    FNeedData: Boolean;
    FHDPI: Integer;
    FVDPI: Integer;
    FDPIUnits: Integer;
    FFillColor: TColor;
    FIncludedFonts: TObjectList;
    FIncludedBitmaps: TObjectList;
    FIncludedGS: TObjectList;
    FIncludedPatterns: TObjectList;
    FContains16Bit: Boolean;
    FColorSpace: AnsiString;
    FNoEmbedFontList: AnsiString;
    FForceInline: Boolean;

    procedure NewJPEG(InStream: TStream; IsJPEGTiff: Boolean = False);
    function NewBMP(BM: TBitmap; TIFFPage: PTIFFPage; Greyscale: Boolean; UpsideDown: Boolean): Boolean;
{$IFNDEF QPL_LITE}
    procedure NewEMF(MF: TMetafile; FontOptions: Integer; RecompressImages: Boolean);

{$ENDIF}
    procedure NewThroughTIFF(PT: TPDFTIFF; Page: Integer);
    procedure NewPackbitsTIFF(Page: TTIFFPage);
    procedure NewJPEGTIFF(Page: TTIFFPage);
    procedure NewTIFF(PT: TPDFTIFF; Page: Integer);
    procedure NewPNG(PNG: TPNGReader; Options: Integer);
  public
    GDIPlusSettings: TGDIPlusSettings;
    constructor Create(AStructure: TPDFStructure; const AName: AnsiString; AIncludedFonts : TObjectList);
    destructor Destroy; override;
    procedure SetImageMask(FromRed, FromGreen, FromBlue, ToRed, ToGreen, ToBlue: Double);
    procedure SetImageMaskCMYK(FromC, FromM, FromY, FromK, ToC, ToM, ToY, ToK: Double);
    function SetImageMaskFromImage(ObjNum, GenNum: Integer; MaskType: TPDFMaskType): Boolean;
    procedure ClearImageMask;
    procedure ClearImage;
    procedure DeleteOCG;
    function Reverse(Reset: Boolean): Boolean;
    function SetImageAsMask(MaskType: TPDFMaskType): Boolean;
    function GetMaskType: TPDFMaskType;
    function NewImageFromStream(InStream: TStream; Options: Integer): Boolean;
    function NewImageFromMetafile(InMetafile: TMetafile; Options: Integer; RecompressImages: Boolean): Boolean;
    function NewEMFFromStream(InStream: TStream; FontOptions, GeneralOptions: Integer): Boolean;
    function NewImageDirectFromString(const Source: AnsiString; Width, Height, BitsPerComponent: Integer;
      const ColorSpace, Filter, Decode: WideString; Interpolate: Boolean): Boolean;
    function SaveToFile(const FileName: WideString): Boolean;
    function SaveToStream(OutStream: TStream): Boolean;
    function GetMeasureDict: TPDFDictionary;
    function GetPtDataDict: TPDFDictionary;
    procedure Populate(ObjNum, GenNum, ImWidth, ImHeight: Integer);
    property Name: AnsiString read FName;
    procedure SetName(const NewName: AnsiString);
    procedure SetOCG(IndRef: TPDFIndRef);
    procedure ConvertToGray;
    property IndRef: TPDFIndRef read FIndRef;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
    property ImageType: TPDFImageType read FImageType write FImageType;
    property ImageData: AnsiString read FImageData write FImageData;
    property Compress: Integer read FCompress write FCompress;
    property EMFImageType: Integer read FEMFImageType write FEMFImageType;
    property CompressFonts: Boolean read FCompressFonts write FCompressFonts;
    property RecompressImage: Boolean read FRecompressImage write FRecompressImage;
    property HorizontalDPI: Integer read FHDPI write FHDPI;
    property VerticalDPI: Integer read FVDPI write FVDPI;
    property DPIUnits: Integer read FDPIUnits write FDPIUnits;
    property FillColor: TColor read FFillColor write FFillColor;
    property Contains16Bit: Boolean read FContains16Bit;
    // property IncludedFonts: TObjectList read FIncludedFonts;
    property IncludedBitmaps: TObjectList read FIncludedBitmaps;
    property IncludedGS: TObjectList read FIncludedGS;
    property IncludedPatterns: TObjectList read FIncludedPatterns;
    property NoEmbedFontList: AnsiString read FNoEmbedFontList write FNoEmbedFontList;
    property ForceInline: Boolean read FForceInline write FForceInline;
    property PageDict: TPDFDictionary read FPageDict;
  end;

  TEMFGraphicState = class
  public
    Transparency: Double;
    GSName: AnsiString;
    GS: TPDFIndRef;
    FuncName: AnsiString;
  end;

function CountImagePages(InStream: TStream): Integer;
function DetermineImageType(S: TStream): TPDFImageType;

implementation

uses
  SysUtils, Math, DebenuPDFLibraryFlate, DebenuPDFLibraryDigest, DebenuPDFLibraryMetafile,
  DebenuPDFLibraryGIF, DebenuPDFLibraryTypes,
{$IFDEF WIN64}
  DebenuPDFLibraryJPEGWin64;
{$ELSE}
  DebenuPDFLibraryJPEG;
{$ENDIF}


type
  TMetafileHeader = packed record
    Key: Cardinal;
    Handle: Word;
    BoxLeft: Word;
    BoxTop: Word;
    BoxRight: Word;
    BoxBottom: Word;
    Inch: Word;
    Reserved1: Word;
    Reserved2: Word;
    CheckSum: Word;
  end;

const
  WMFKey = Integer($9AC6CDD7);

{ TPDFImage }

type
  TJPEGQuickInfo = record
    Width: Integer;
    Height: Integer;
    Components: Integer;
    HD: Integer;
    VD: Integer;
    DU: Integer;
  end;

procedure JPEGSizeColorStream(InStream: TStream; var Info: TJPEGQuickInfo);
var
  Seg: AnsiChar;
  S: AnsiString;
  W: Word;
  L: Word;
  B: Byte;
  P: Integer;
  T: TPDFTIFF;
const
  Parm: AnsiString = #$01#$D0#$D1#$D2#$D3#$D4#$D5#$D6#$D7;

  function WS(W: Word): Word;
  begin
    Result := (W and $FF) shl 8 + (W and $FF00) shr 8;
  end;

begin
  InStream.Seek(0, soFromBeginning);

  Info.Width := 0;
  Info.Height := 0;
  Info.Components := 3;
  Info.DU := -1;
  Info.VD := 0;
  Info.HD := 0;
  SetLength(S, 2);
  InStream.Read(S[1], 2);
  if S = #$FF#$D8 then
  begin
    InStream.Read(Seg, 1);
    while (Seg = #$FF) do
    begin
      InStream.Read(Seg, 1);
      if Seg <> #$FF then
      begin
        if (Seg = #$E0) or (Seg = #$E1) then
        begin

          InStream.Read(W, 2);
          P := InStream.Position;
          L := WS(W) - 2;

          SetLength(S, 5);
          InStream.Read(S[1], 5);
          if (S = 'JFIF'#0) and (Seg = #$E0) then
          begin
            InStream.Seek(2, soFromCurrent);
            InStream.Read(B, 1);
            Info.DU := B;
            InStream.Read(W, 2);
            Info.HD := WS(W);
            InStream.Read(W, 2);
            Info.VD := WS(W);
          end;
          if (S = 'Exif'#0) and (Seg = #$E1) then
          begin
            InStream.Seek(1, soFromCurrent);
            SetLength(S, L);
            InStream.Read(S[1], Length(S));
            T := TPDFTIFF.Create;
            try
              T.LoadFromString(S);
              if (Info.DU = 0) then
              begin
                Info.DU := 1;
                Info.HD := T.PageInfo[1].XRes;
                Info.VD := T.PageInfo[1].YRes;
              end;
            finally
              T.Free;
            end;
          end;

          InStream.Seek(P + L, soFromBeginning);
          InStream.Read(Seg, 1);
        end else
        if (Seg = #$C0) or (Seg = #$C1) or (Seg = #$C2) or (Seg = #$C3) then
        begin
          InStream.Seek(3, soFromCurrent);
          InStream.Read(W, 2);
          Info.Height := WS(W);
          InStream.Read(W, 2);
          Info.Width := WS(W);
          InStream.Read(B, 1);
          Info.Components := B;
          InStream.Seek(0, soFromEnd);
        end else
        begin
          if QPLPos(Seg, Parm) = 0 then
          begin
            InStream.Read(W, 2);
            W := WS(W) - 2;
            InStream.Seek(W, soFromCurrent);
            InStream.Read(Seg, 1);
          end else
            Seg := #$FF;
        end;
      end;
    end;
  end;
end;

function CountImagePages(InStream: TStream): Integer;
var
  ValidTIFF: Boolean;
  BM: TBitmap;
  T: TPDFTIFF;
  PNG: TPNGReader;
  Info: TJPEGQuickInfo;
  ImageType: TPDFImageType;
begin
  Result := 0;
  InStream.Seek(0, soFromBeginning);

  ImageType := DetermineImageType(InStream);

  if ImageType = itJPEG then
  begin
    JPEGSizeColorStream(InStream, Info);
    if (Info.Width <> 0) and (Info.Height <> 0) then
      Result := 1;
  end;

  if ImageType = itGIF then
    Result := 1;

  if ImageType = itBMP then
  begin
    BM := TBitmap.Create;
    try
      try
        InStream.Seek(0, soFromBeginning);
        BM.LoadFromStream(InStream);
        Result := 1;
      except
      end;
    finally
      BM.Free;
    end;
  end;

  if ImageType = itTIFF then
  begin
    T := TPDFTIFF.Create;
    try
      InStream.Seek(0, soFromBeginning);
      T.LoadFromStream(InStream);
      ValidTIFF := T.PageCount > 0;
      if ValidTIFF then Result := T.PageCount;
    finally
      T.Free;
    end;
  end;

  if ImageType = itPNG then
  begin
    PNG := TPNGReader.Create;
    try
      InStream.Seek(0, soFromBeginning);
      PNG.LoadFromStream(InStream);
      if (PNG.Width > 0) and (PNG.Height > 0) then
        Result := 1;
    finally
      PNG.Free;
    end;
  end;
end;

constructor TPDFImage.Create(AStructure: TPDFStructure; const AName: AnsiString; AIncludedFonts : TObjectList);
begin
  FNeedData := False;
  FStructure := AStructure;
  FImageType := itUnknown;
  FWidth := 0;
  FHeight := 0;
  FName := AName;
  FImageData := '';
  FCompress := 0;
  FCompressFonts := False;
  FEMFImageType := 0; // None
  FHDPI := 0;
  FVDPI := 0;
  FFillColor := clWhite;
  FContains16Bit := False;
  FNoEmbedFontList := '';
  FForceInline := False;

  // The Document object will free all the fonts
  //FIncludedFonts := TObjectList.Create(False);  // ADC

  // The bitmaps, graphics states and patterns will be freed
  // by the image, not the document
  FIncludedBitmaps := TObjectList.Create(True);
  FIncludedGS := TObjectList.Create(True);
  FIncludedPatterns := TObjectList.Create(True);
  FIncludedFonts := AIncludedFonts;
end;

function TPDFImage.NewBMP(BM: TBitmap; TIFFPage: PTIFFPage; Greyscale: Boolean; UpsideDown: Boolean): Boolean;
var
  GenNum: Integer;
  ObjNum: Integer;
  Obj: TPDFStream;
  W: Integer;
  H: Integer;
  X: Integer;
  Y: Integer;
  DataStream: AnsiString;
  P: PByteArray;
  T: Byte;
  MS: TMemoryStream;
  ColorSpace: AnsiString;
  BPC: Integer;
  BW: Integer;
  Decode: AnsiString;
  MonoPal: array[0..1] of PALETTEENTRY;
  GrayPal: array[0..255] of PALETTEENTRY;
  OriginalDataLength: Integer;
  Off, DOff: Integer;
  ColList: TQuickPDFIntegerList;
  C, ColorCount: Integer;

  // ADC
  JPEGSuccess: Boolean;
  Jpg: TPDFJPEGImage;

  function UniqueColorCount: Integer;
  var
    X, Y: Integer;
    Bytes: Integer;
    C, LastC: Integer;
  begin
    Result := 65536;
    ColList := TQuickPDFIntegerList.Create;
    LastC := -1;

    Bytes := 3;
    if (BM.PixelFormat = pf32bit) then Bytes := 4;

    if (BM.PixelFormat = pf24bit) or (BM.PixelFormat = pf32bit) then
    begin
      for Y := 0 to H - 1 do
      begin
        P := BM.ScanLine[Y];

        if (ColList.Count < 257) then  // No use counting over 256 colours
        begin
          Off := 0;
          for X := 0 to W - 1 do
          begin
            C := (P[Off+2] shl 16) or (P[Off+1] shl 8) or P[Off];

            if (C <> LastC) and (ColList.IndexOf(C) = -1) then
            begin
              ColList.Add(C);
              ColList.SortList;
            end;
            LastC := C;

            Inc(Off, Bytes);
          end;
        end;
      end;
      Result := ColList.Count;
    end;
  end;

  function GetIndexColorSpaceAsString: AnsiString;
  var
    X: Integer;
  begin

    if (not Assigned(ColList)) then      // FB 11245
      Result := '/DeviceRGB'
    else
    begin
      Result := '[ /Indexed /DeviceRGB ' + QPLIntToStr(ColList.Count - 1) + ' <';
      for X := 0 to ColList.Count - 1 do
        Result := Result + QPLIntToHex((ColList[X] shr 16) and $FF, 2) +
          QPLIntToHex((ColList[X] shr 8) and $FF, 2) +
          QPLIntToHex((ColList[X] shr 0) and $FF, 2);

      Result := Result + '>]';
    end;
  end;

begin
  Result := False;
  ColorCount := 99999;
  ColList := nil;
  JPEGSuccess := False;

  if FNeedData then
  begin
    MS := TMemoryStream.Create;
    try
      BM.Canvas.Lock;
      try
        BM.SaveToStream(MS);
      finally
        BM.Canvas.Unlock;
      end;
      SetLength(FImageData, MS.Size);
      MS.Seek(0, soFromBeginning);
      MS.Read(FImageData[1], Length(FImageData));
    finally
      MS.Free;
    end;
  end;

  if Assigned(TIFFPage) then
    FImageType := itTIFF
  else
    FImageType := itBMP;

  W := BM.Width;
  H := BM.Height;
  FWidth := W;
  FHeight := H;

  BPC := 8;
  ColorSpace := '/DeviceRGB';

  // Doesn't work with ImageMasks - so disable for now  //  ADC
  if (GetMaskType = mtUnknown) and (FEMFImageType = 1) then  // EMF without mask
  begin
    if (BM.PixelFormat = pf24bit) or (BM.PixelFormat = pf32bit) then
    begin
      ColorCount := UniqueColorCount;

      if (ColorCount = 1) or (ColorCount = 2) then  // Needs to be indexed.
      begin
        //BM.PixelFormat := pf1Bit;
        ColorSpace := GetIndexColorSpaceAsString;
        FRecompressImage := False;
      end;
    end;
  end;

  if (BM.PixelFormat = pf8bit) and (not Greyscale) then
  begin
{$IFDEF QPL_OS_WINDOWS}
    GetPaletteEntries(BM.Palette, 0, 256, GrayPal);
{$ENDIF}
    Greyscale := True;
    X := 0;
    while (X < 256) and (Greyscale) do
    begin
      if (GrayPal[X].peRed <> X) or
        (GrayPal[X].peGreen <> X) or
          (GrayPal[X].peBlue <> X) then
            Greyscale := False;
      Inc(X);
    end;
  end;

  if (BM.PixelFormat = pf8bit) and (not Greyscale) then
    BM.PixelFormat := pf24bit;

  if (BM.PixelFormat = pf16bit) and (not Greyscale) then
    BM.PixelFormat := pf24bit;

  if (BM.PixelFormat = pf15bit) and (not Greyscale) then
    BM.PixelFormat := pf24bit;

  if (BM.PixelFormat = pf32bit) then
  begin
    if Assigned(TiffPage) then
    begin
      if TIFFPage.PhotometricInterpretation = piRGB then
        BM.PixelFormat := pf24bit;
    end
    {else BM.PixelFormat := pf24bit};
  end;

  if BM.PixelFormat = pfCustom then
    BM.PixelFormat := pf24bit;

  if BM.PixelFormat = pf4bit then
    BM.PixelFormat := pf24bit;

  if (BM.PixelFormat = pf32bit) and (Assigned(TiffPage) and (TIFFPage.PhotometricInterpretation = piCMYK)) then
  begin
    SetLength(DataStream, W * H * 4);

    for Y := 0 to H - 1 do
    begin
      if (not UpsideDown) then
        P := BM.ScanLine[Y]
      else
        P := BM.ScanLine[H - Y - 1];

      for X := 0 to W - 1 do
      begin
        T := P[X * 4 + 1];
        P[X * 4 + 1] := P[X * 4 + 2];
        P[X * 4 + 2] := T;
        T := P[X * 4];
        P[X * 4] := P[X * 4 + 3];
        P[X * 4 + 3] := T;
      end;
      Move(P^, DataStream[Y * W * 4 + 1], W * 4);
    end;

    ColorSpace := '/DeviceCMYK';
    BPC := 8;
    Result := True;   // Processed
  end;

  if BM.PixelFormat = pf1bit then
  begin
    if Assigned(TIFFPage) then
    begin
      if TIFFPage.Reversed then
        Decode := '[ 0 1 ]'
      else
        Decode := '[ 1 0 ]';
    end else
    begin
{$IFDEF QPL_OS_WINDOWS}
      GetPaletteEntries(BM.Palette, 0, 2, MonoPal);
{$ENDIF}
      if (MonoPal[0].peRed = 0) then
        Decode := '[ 0 1 ]'
      else
        Decode := '[ 1 0 ]';

      if (FEMFImageType = 1) then
        Decode := '[ 1 0 ]'
    end;

    BW := W div 8;
    if (W - (BW * 8)) > 0 then Inc(BW);
    SetLength(DataStream, BW * H);

    for Y := 0 to H - 1 do
    begin
      if (not UpsideDown) then
        P := BM.ScanLine[Y]
      else
        P := BM.ScanLine[H - Y - 1];

      Move(P^, DataStream[Y * BW + 1], BW);
    end;

    ColorSpace := '/DeviceGray';
    BPC := 1;
    Result := True;   // Processed
  end;

  if (BM.PixelFormat = pf8bit) and Greyscale then
  begin
    SetLength(DataStream, W * H);

    for Y := 0 to H - 1 do
    begin
      if (not UpsideDown) then
        P := BM.ScanLine[Y]
      else
        P := BM.ScanLine[H - Y - 1];

      Move(P^, DataStream[Y * W + 1], W);
    end;

    ColorSpace := '/DeviceGray';
    BPC := 8;
    Result := True;   // Processed
  end;

  if (Result = False) then  // Not Processed yet ?
  begin
    BM.PixelFormat := pf24bit;

    if (ColorCount <= 256) then  // Process as 8bit Indexed
    begin
      SetLength(DataStream, W * H);

      ColorSpace := GetIndexColorSpaceAsString;
      FRecompressImage := False;

      DOff := 1;
      for Y := 0 to H - 1 do
      begin
        if (not UpsideDown) then
          P := BM.ScanLine[Y]
        else
          P := BM.ScanLine[H - Y - 1];

        Off := 0;
        for X := 0 to W - 1 do
        begin
          C := (P[Off+2] shl 16) + (P[Off+1] shl 8) or P[Off];
          DataStream[DOff] := AnsiChar(ColList.IndexOf(C));

          Inc(Off, 3);
          Inc(DOff, 1);
        end;
      end;
      Result := True;   // Processed
    end;
  end;

  if (Result = False) and FRecompressImage then // convert it to JPEG
  begin
    if (BM.Width > 64) and (BM.Height > 64) then
    begin
      MS := TMemoryStream.Create;
      Jpg := TPDFJPEGImage.Create;
      Jpg.LoadFromBitmap(BM);
      try
        Jpg.CompressionQuality := 50;     // ADC Quality.
        Jpg.SaveToStream(MS);

        SetLength(DataStream, MS.Size);
        MS.Seek(0, soFromBeginning);
        MS.Read(DataStream[1], Length(DataStream));

      finally
        MS.Free;
        Jpg.Free;
        JPEGSuccess := True;
        Result := True;
      end;
    end;
  end;

  if (Result = False) then    // Process it uncompressed
  begin
    SetLength(DataStream, W * H * 3);

    for Y := 0 to H - 1 do
    begin
      if (not UpsideDown) then
        P := BM.ScanLine[Y]
      else
        P := BM.ScanLine[H - Y - 1];

      for X := 0 to W - 1 do
      begin
        T := P[X * 3];
        P[X * 3] := P[X * 3 + 2];
        P[X * 3 + 2] := T;
      end;
      Move(P^, DataStream[Y * W * 3 + 1], W * 3);
    end;

    ColorSpace := '/DeviceRGB';
    BPC := 8;
    Result := True;
  end;

  if (Compress = 1) and (not JPEGSuccess)then
  begin
    OriginalDataLength := Length(DataStream);
    DataStream := DeflateStr(DataStream);
    if ((Length(DataStream) = 0) and (OriginalDataLength > 0)) then
    begin
      if Assigned(ColList) then
        ColList.Free;
        Result := False;
      Exit;
    end;
  end;

  Obj := FStructure.NewStream(DataStream);
  Obj.Dictionary.Add('Type', FStructure.NewName('XObject'));
  Obj.Dictionary.Add('Subtype', FStructure.NewName('Image'));
  Obj.Dictionary.Add('Width', FStructure.NewNumeric(W));
  Obj.Dictionary.Add('Height', FStructure.NewNumeric(H));
  Obj.Dictionary.Add('Name', FStructure.NewName(Name));
  Obj.Dictionary.Add('ColorSpace', FStructure.Decode(ColorSpace));

  Obj.Dictionary.Add('BitsPerComponent', FStructure.NewNumeric(BPC));

  if (JPEGSuccess) then
    Obj.Dictionary.Add('Filter', FStructure.NewName('DCTDecode'))
  else if FCompress = 1 then
    Obj.Dictionary.Add('Filter', FStructure.NewName('FlateDecode'));

  if Decode <> '' then
    Obj.Dictionary.Add('Decode', FStructure.Decode(Decode));
  FImageDictionary := Obj.Dictionary;

  FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
  FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);

  if Assigned(ColList) then
    ColList.Free;
end;

function TPDFImage.NewImageDirectFromString(const Source: AnsiString; Width,
  Height, BitsPerComponent: Integer; const ColorSpace, Filter, Decode: WideString; Interpolate: Boolean): Boolean;
var
  Obj: TPDFStream;
  ObjNum: Integer;
  GenNum: Integer;
  DecodeParmsDict: TPDFDictionary;
  RealFilter: string;
  BlackIs1: Boolean;
  K: Integer;
begin
  Result := True;
  Obj := FStructure.NewStream(Source);
  Obj.Dictionary.Add('Type', FStructure.NewName('XObject'));
  Obj.Dictionary.Add('Subtype', FStructure.NewName('Image'));
  Obj.Dictionary.Add('Width', FStructure.NewNumeric(Width));
  Obj.Dictionary.Add('Height', FStructure.NewNumeric(Height));
  Obj.Dictionary.Add('Name', FStructure.NewName(Name));
  if (Filter <> '') then
  begin
    RealFilter := Filter;
    if (RealFilter = 'CCITTFaxDecodeBlackIs1T4') then
    begin
      K := 0;
      BlackIs1 := True;
      RealFilter := 'CCITTFaxDecode';
    end else
    if (RealFilter = 'CCITTFaxDecodeT4') then
    begin
      K := 0;
      BlackIs1 := False;
      RealFilter := 'CCITTFaxDecode';
    end else
    if (RealFilter = 'CCITTFaxDecodeBlackIs1') then
    begin
      K := -1;
      BlackIs1 := True;
      RealFilter := 'CCITTFaxDecode';
    end else
    begin
      K := -1;
      BlackIs1 := False;
    end;

    Obj.Dictionary.Add('Filter', FStructure.NewName(AnsiString(RealFilter)));
    if (RealFilter = 'CCITTFaxDecode') then
    begin
      DecodeParmsDict := FStructure.NewDictionary;
      DecodeParmsDict.Add('K', FStructure.NewNumeric(K));
      DecodeParmsDict.Add('Columns', FStructure.NewNumeric(Width));
      if (BlackIs1) then
      begin
        DecodeParmsDict.Add('BlackIs1', FStructure.NewBoolean(True));
      end;
      Obj.Dictionary.Add('DecodeParms', DecodeParmsDict);
    end;
  end;
  Obj.Dictionary.Add('Interpolate', FStructure.NewBoolean(Interpolate));
  if (ColorSpace <> '') then
  begin
    Obj.Dictionary.Add('ColorSpace', FStructure.Decode(AnsiString(ColorSpace)));
  end;

  Obj.Dictionary.Add('BitsPerComponent', FStructure.NewNumeric(BitsPerComponent));
  if Decode <> '' then

    Obj.Dictionary.Add('Decode', FStructure.Decode(AnsiString(Decode)));
  FImageDictionary := Obj.Dictionary;

  FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
  FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
end;

function TPDFImage.NewImageFromMetafile(InMetafile: TMetafile;
  Options: Integer; RecompressImages: Boolean): Boolean;
begin
  Result := False;
{$IFNDEF QPL_LITE}
  if Assigned(FStructure.OnNewIndObj) then
  begin
    try
      Result := True;
      NewEMF(InMetafile, Options, RecompressImages);
    except
      Result := False;
    end;
  end;
{$ENDIF}
end;

function TPDFImage.NewImageFromStream(InStream: TStream;
  Options: Integer): Boolean;
var
  ValidTIFF: Boolean;
  BM: TBitmap;
  EMF: TMetafile;
  WMF: TMetafile;
  TempCanvas: TMetaFileCanvas;
  T: TPDFTIFF;
  PNG: TPNGReader;
  CheckType: TPDFImageType;
  Info: TJPEGQuickInfo;
  GD: TPDFGIFDecoder;
  MyPic: TPDFPicasso;
  MyBitmapInfoHeader: BitmapInfoHeader;
begin
  Result := False;

  if Assigned(FStructure.OnNewIndObj) then
  begin
    CheckType := DetermineImageType(InStream);
    case CheckType of
      itWMF..itEMF:
      begin
        EMF := TMetaFile.Create;
        try
          try
            InStream.Seek(0, soFromBeginning);
            EMF.LoadFromStream(InStream);

            //FB21027
            if (CheckType = itWMF) then
            begin
              WMF := TMetaFile.Create;
              WMF.Width := EMF.Width;
              WMF.Height := EMF.Height;
              TempCanvas := TMetaFileCanvas.Create(WMF, 0);
              with TempCanvas do
              try
                Draw(0,0, EMF);
              finally
                Free;
              end;
              EMF.Free;
              EMF := WMF;
            end;

            if Options = -1 then
            begin
              BM := TBitmap.Create;
              MyPic := TPDFPicasso.Create;
              try
                InStream.Seek(0, soFromBeginning);
                BM.PixelFormat := pf24bit;
                BM.Width := EMF.Width;
                BM.Height := EMF.Height;
                BM.Canvas.Lock;

                if (EMF.MMWidth <> 0) and (EMF.MMHeight <> 0) then
                begin
                  FHDPI := Round(BM.Width / (EMF.MMWidth / 2540));
                  FVDPI := Round(BM.Height / (EMF.MMHeight / 2540));
                end;

                GDIPlusSettings.UseGDIPlus := True;
                GDIPlusSettings.Smoothing := True;
                GDIPlusSettings.AccurateInterpolation := True;
                GDIPlusSettings.SmoothImages := True;
                GDIPlusSettings.ProcessNullPath := True;
                GDIPlusSettings.MonoThreshold := 0;

                MyPic.UseGDIPlusModel(BM.Canvas, GDIPlusSettings);
                MyPic.DrawAnyImage(0, 0, BM.Width, BM.Height, InStream, 1);
                if FCompress = 0 then
                begin
                  FCompress := 1;
                  Result := NewBMP(BM, nil, False, False);
                  FCompress := 0;
                end else
                  Result := NewBMP(BM, nil, False, False);
                ImageType := itBMP;
              finally
                MyPic.Free;
                BM.Free;
              end;
            end else
            begin
{$IFNDEF QPL_LITE}
              Result := True;
              ImageType := itEMF;
              NewEMF(EMF, Options, RecompressImage);  // ADC
{$ENDIF}
            end;
          except
            Result := False;
          end;
        finally
          EMF.Free;
        end;
      end;

      itJPEG:
      begin
        JPEGSizeColorStream(InStream, Info);
        if (Info.Width <> 0) and (Info.Height <> 0) then
        begin
          Result := True;
          NewJPEG(InStream);
        end;
      end;

      itBMP:
      begin
        BM := TBitmap.Create;
        try
          if (Options >= 0) then
          begin
            try
              InStream.Seek(SizeOf(TBitmapFileHeader), soFromBeginning);
              InStream.Read(MyBitmapInfoHeader, Sizeof(TBitmapInfoHeader));
              FHDPI := Round(MyBitmapInfoHeader.biXPelsPerMeter / 1000 * 25.4);
              FVDPI := Round(MyBitmapInfoHeader.biYPelsPerMeter / 1000 * 25.4);
              InStream.Seek(0, soFromBeginning);
              BM.LoadFromStream(InStream);
              Result := NewBMP(BM, nil, False, MyBitmapInfoHeader.biHeight < 0);
            except
              Result := False;
            end;
          end
          else
          begin
            MyPic := TPDFPicasso.Create;
            try
              InStream.Seek(SizeOf(TBitmapFileHeader), soFromBeginning);
              InStream.Read(MyBitmapInfoHeader, Sizeof(TBitmapInfoHeader));

              InStream.Seek(0, soFromBeginning);

              GDIPlusSettings.UseGDIPlus := True;
              GDIPlusSettings.Smoothing := True;
              GDIPlusSettings.AccurateInterpolation := True;
              GDIPlusSettings.SmoothImages := True;
              GDIPlusSettings.ProcessNullPath := True;
              GDIPlusSettings.MonoThreshold := 0;

              case MyBitmapInfoHeader.biBitCount of
                1:  BM.PixelFormat := pf1bit;
                4:  BM.PixelFormat := pf4bit;
                8:  BM.PixelFormat := pf8bit;
                16: BM.PixelFormat := pf16bit;
                24: BM.PixelFormat := pf24bit;
                32: BM.PixelFormat := pf32bit;
              end;

              BM.Width := MyBitmapInfoHeader.biWidth;
              BM.Height := Abs(MyBitmapInfoHeader.biHeight);
              BM.Canvas.Lock;

              MyPic.UseGDIPlusModel(BM.Canvas, GDIPlusSettings);
              MyPic.DrawAnyImage(0, 0, BM.Width, BM.Height, InStream, -Options);
              if FCompress = 0 then
              begin
                FCompress := 1;
                Result := NewBMP(BM, nil, MyBitmapInfoHeader.biHeight < 0, False);
                FCompress := 0;
              end else
                Result := NewBMP(BM, nil, MyBitmapInfoHeader.biHeight < 0, False);
            finally
              MyPic.Free;
            end;
          end;
        finally
          BM.Free;
        end;
      end;

      itGIF:
      begin
        BM := TBitmap.Create;
        try
          GD := TPDFGIFDecoder.Create;
          try
            InStream.Seek(0, soFromBeginning);
            GD.LoadFromStream(InStream);
            GD.SaveToBitmap(BM);
            if FCompress = 0 then
            begin
              FCompress := 1;
              Result := NewBMP(BM, nil, False, False);
              FCompress := 0;
            end else
              Result := NewBMP(BM, nil, False, False);
          finally
            GD.Free;
          end;
        finally
          BM.Free;
        end;
      end;

      itTIFF:
      begin
        if Options <= -1 then
        begin
          T := TPDFTIFF.Create;
          BM := TBitmap.Create;
          MyPic := TPDFPicasso.Create;
          try
            InStream.Seek(0, soFromBeginning);
            T.LoadFromStream(InStream);
            InStream.Seek(0, soFromBeginning);
            BM.PixelFormat := pf24bit;
            BM.Width := T.PageInfo[-Options].Width;
            BM.Height := T.PageInfo[-Options].Height;
            BM.Canvas.Lock;

            GDIPlusSettings.UseGDIPlus := True;
            GDIPlusSettings.Smoothing := True;
            GDIPlusSettings.AccurateInterpolation := True;
            GDIPlusSettings.SmoothImages := True;
            GDIPlusSettings.ProcessNullPath := True;
            GDIPlusSettings.MonoThreshold := 0;

            MyPic.UseGDIPlusModel(BM.Canvas, GDIPlusSettings);
            MyPic.DrawAnyImage(0, 0, BM.Width, BM.Height, InStream, -Options);
            if FCompress = 0 then
            begin
              FCompress := 1;
              Result := NewBMP(BM, nil, False, False);
              FCompress := 0;
            end else
              Result := NewBMP(BM, nil, False, False);
          finally
            MyPic.Free;
            BM.Free;
            T.Free;
          end;
        end else
        begin
          T := TPDFTIFF.Create;
          try
            InStream.Seek(0, soFromBeginning);
            if Options < 1 then Options := 1;
            T.LoadFromStream(InStream, Options - 1);

            if Options > T.PageCount then Options := T.PageCount;
            ValidTIFF := T.ValidTIFF and (T.PageCount > 0) and (not T.HasJPEGTags);
            with T.PageInfo[Options] do
            begin
              FHDPI := XRes;
              FVDPI := YRes;
              FDPIUnits := 2;
            end;

            if ValidTIFF then
            begin
              Result := (T.PageInfo[Options].PlanarConfiguration = pcChunky) or (T.PageInfo[Options].SamplesPerPixel = 1);
              if Result then
                NewTIFF(T, Options);
            end;
          finally
            T.Free;
          end;
        end;
      end;

      itPNG:
      begin
        PNG := TPNGReader.Create;
        try
          InStream.Seek(0, soFromBeginning);

          if (Options < 0) then
          begin
            Options := 0;
          end;

          if ((Options = 3) or (Options = 5)) then
          begin
            // Image data has been requested and the bit depth should
            // be downsampled to 8-bit if it is 16-bit
            PNG.DownSampleImage := True;
          end;

          if ((Options = 2) or (Options = 4) or (Options = 5)) then
          begin
            // Alpha channel has been requested and the bit depth should
            // be downsampled to 8-bit if it is 16-bit
            PNG.DownSampleAlpha := True;
          end;

          PNG.LoadFromStream(InStream);

          Result := True;

          if ((PNG.Width = 0) or (PNG.Height = 0)) then
          begin
            Result := False;
          end;

          if (((Options = 1) or (Options = 4)) and (Length(PNG.AlphaData) = 0)) then
          begin
            // Only the alpha
            Result := False;
          end;

          if (Length(PNG.ImageData) = 0) then
          begin
            Result := False;
          end;

          if (Result) then
          begin
            NewPNG(PNG, Options);
          end;
        finally
          PNG.Free;
        end;
      end;

    end;
  end;
end;

procedure TPDFImage.NewJPEG(InStream: TStream;IsJPEGTiff: Boolean);
var
  GenNum: Integer;
  ObjNum: Integer;
  Obj: TPDFStream;
  Decode: AnsiString;
  Source: AnsiString;
  Info: TJPEGQuickInfo;
begin
  InStream.Seek(0, soFromBeginning);

  SetLength(Source, InStream.Size);
  InStream.Read(Source[1], InStream.Size);
  if FNeedData then FImageData := Source;

  FImageType := itJPEG;
  JPEGSizeColorStream(InStream, Info);

  if (not IsJPEGTiff) then
  begin
    FDPIUnits := Info.DU + 1;
    FHDPI := Info.HD;
    FVDPI := Info.VD;
  end;
  // else we already have DPI from TIFF tags.

  FColorSpace := 'DeviceRGB';
  Decode := '';
  if Info.Components = 1 then
  begin
    FColorSpace := 'DeviceGray';
  end;
  if Info.Components = 4 then
  begin
    FColorSpace := 'DeviceCMYK';
    Decode := '[ 1 0 1 0 1 0 1 0 ]';
  end;

  FWidth := Info.Width;
  FHeight := Info.Height;

  Obj := FStructure.NewStream(Source);
  Obj.Dictionary.Add('Type', FStructure.NewName('XObject'));
  Obj.Dictionary.Add('Subtype', FStructure.NewName('Image'));
  Obj.Dictionary.Add('Width', FStructure.NewNumeric(Info.Width));
  Obj.Dictionary.Add('Height', FStructure.NewNumeric(Info.Height));
  Obj.Dictionary.Add('ColorSpace', FStructure.NewName(FColorSpace));
  if Decode <> '' then
    Obj.Dictionary.Add('Decode', FStructure.Decode(Decode));
  Obj.Dictionary.Add('BitsPerComponent', FStructure.NewNumeric(8));
  Obj.Dictionary.Add('Filter', FStructure.NewName('DCTDecode'));
  FImageDictionary := Obj.Dictionary;

  FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
  FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
end;

procedure TPDFImage.NewPNG(PNG: TPNGReader; Options: Integer);
var
  GenNum: Integer;
  ObjNum: Integer;
  Obj: TPDFStream;
  DecodeParms: AnsiString;
  CS: AnsiString;
  AlphaIndRef: TPDFIndRef;
  ICCIndRef: TPDFIndRef;
  ICCN: Integer;
begin
  // Possible values for the Options parameter
  // 0 = Load image data, allow 16-bit
  // 1 = Load alpha channel, allow 16-bit
  // 2 = Load image data and alpha channel, force alpha to 8-bit
  // 3 = Load image data, force to 8-bit
  // 4 = Load alpha channel, force to 8-bit
  // 5 = Load image data and alpha channel, force both to 8-bit
  // 6 = Load image data and alpha channel, allow 16-bit
  // 7 = Load image data, allow 16-bit and import ICC color profile

  if FNeedData then FImageData := PNG.ImageData;

  FImageType := itPNG;

  FWidth := PNG.Width;
  FHeight := PNG.Height;
  FHDPI := PNG.HorizontalDPI;
  FVDPI := PNG.VerticalDPI;
  FDPIUnits := 2;

  FContains16Bit := False;

  if (((Options = 0) or (Options = 2) or (Options = 6) or (Options = 7)) and
    (PNG.ImageBitDepth = 16)) then
  begin
    // Image data has been requested and it contains 16-bit data
    FContains16Bit := True;
  end;

  if (((Options = 1) or (Options = 6)) and (PNG.AlphaBitDepth = 16)) then
  begin
    // Alpha channel has been requested and it contains 16-bit data
    FContains16Bit := True;
  end;

  if (((Options = 1) or (Options = 2) or (Options = 4) or (Options = 5) or
    (Options = 6)) and (Length(PNG.AlphaData) > 0)) then
  begin
    // Alpha channel has been requested and was found in the image

    // The color space will always be /DeviceGray
    CS := '/DeviceGray';
    
    Obj := FStructure.NewStream(PNG.AlphaData);
    Obj.Dictionary.Add('Type', FStructure.NewName('XObject'));
    Obj.Dictionary.Add('Subtype', FStructure.NewName('Image'));
    Obj.Dictionary.Add('Width', FStructure.NewNumeric(FWidth));
    Obj.Dictionary.Add('Height', FStructure.NewNumeric(FHeight));
    Obj.Dictionary.Add('ColorSpace', FStructure.Decode(CS));
    Obj.Dictionary.Add('BitsPerComponent',
      FStructure.NewNumeric(PNG.AlphaBitDepth));
    Obj.Dictionary.Add('Filter', FStructure.NewName('FlateDecode'));

    FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
    AlphaIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);

    if ((Options = 1) or (Options = 4)) then
    begin
      // Only the alpha channel was requested, so store the dictionary and
      // the indirect reference as this will be the main image
      FImageDictionary := Obj.Dictionary;
      FIndRef := AlphaIndRef;
    end;
  end else
  begin
    // Make sure the alpha channel's indirect reference is clear
    // so that an /SMask entry is not added to the main image
    AlphaIndRef := nil;
  end;

  if ((Options = 0) or (Options = 2) or (Options = 3) or (Options = 5) or
    (Options = 6) or (Options = 7)) then
  begin
    // The image data has been requested

    CS := '/DeviceRGB';
    case PNG.ColorType of
      0: CS := '/DeviceGray';
      2: CS := '/DeviceRGB';
      3: CS := '[ /Indexed ' + PNG.MakePDFPalette + ' ]';
      4: CS := '/DeviceGray';
      6: CS := '/DeviceRGB';
    end;

    if ((Options = 7) and (Length(PNG.ICCData) > 0)) then
    begin
      Obj := FStructure.NewStream(PNG.ICCData);
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
      ICCIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);

      if (QPLStartsWith(CS, '[ /Indexed /DeviceRGB')) then
      begin
        ICCN := 3;
        CS := QPLStringReplace(CS, '/DeviceRGB', '[ /ICCBased ' + ICCIndRef.Output + ']', [rfReplaceAll]);
      end else
      if (CS = '/DeviceGray') then
      begin
        ICCN := 1;
        CS := '[ /ICCBased ' + ICCIndRef.Output + ']';
      end else
      begin
        ICCN := 3;
        CS := '[ /ICCBased ' + ICCIndRef.Output + ']';
      end;

      Obj.Dictionary.Add('N', FStructure.NewNumeric(ICCN));
      Obj.Dictionary.Add('Filter', FStructure.NewName('FlateDecode'));
    end;

    // Check if the PNG data is in a suitable format to store the data
    // directly into the PDF without being decompressed and then recompressed
    if PNG.EmbeddedPredictor then
    begin
      // Predictor 15 is for each scanline to start with a filter byte
      DecodeParms := '<< /Predictor 15 ';
      case PNG.ColorType of
        0: DecodeParms := DecodeParms + '/Colors 1 ';
        2: DecodeParms := DecodeParms + '/Colors 3 ';
      end;
      DecodeParms := DecodeParms + '/BitsPerComponent ' +
        QPLIntToStr(PNG.ImageBitDepth) + ' /Columns ' +
        QPLIntToStr(PNG.Width) + ' >>';
    end else
    begin
      DecodeParms := '';
    end;

    Obj := FStructure.NewStream(PNG.ImageData);
    Obj.Dictionary.Add('Type', FStructure.NewName('XObject'));
    Obj.Dictionary.Add('Subtype', FStructure.NewName('Image'));
    Obj.Dictionary.Add('Width', FStructure.NewNumeric(FWidth));
    Obj.Dictionary.Add('Height', FStructure.NewNumeric(FHeight));
    Obj.Dictionary.Add('ColorSpace', FStructure.Decode(CS));
    Obj.Dictionary.Add('BitsPerComponent',
      FStructure.NewNumeric(PNG.ImageBitDepth));
    Obj.Dictionary.Add('Filter', FStructure.NewName('FlateDecode'));
    if (Length(DecodeParms) > 0) then
    begin
      Obj.Dictionary.Add('DecodeParms', FStructure.Decode(DecodeParms));
    end;

    if (Assigned(AlphaIndRef)) then
    begin
      // The alpha channel has been loaded into a separate image object
      // so we can add a link to it using the soft mask entry
      Obj.Dictionary.Add('SMask', AlphaIndRef);
    end;

    // Create the indirect reference
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
    FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);

    // Store the image dictionary object
    FImageDictionary := Obj.Dictionary;
  end;
end;

procedure TPDFImage.NewThroughTIFF(PT: TPDFTIFF; Page: Integer);
var
  GenNum: Integer;
  ObjNum: Integer;
  Obj: TPDFStream;
  W: Integer;
  H: Integer;
  ColorSpace: AnsiString;
  DecodeDict: TPDFDictionary;
  BPC: Integer;
  TileXObject: TPDFStream;
  TileResources: TPDFDictionary;
  TileResourcesX: TPDFDictionary;
  StripX: Integer;
  YPos: Double;
  XPos: Double;
  XRestart: Boolean;
  Predictor: Integer;
  ImageName: AnsiString;
  Contents: AnsiString;
  TotalHeight: Integer;
  TotalWidth: Integer;
  RPS: Integer;
  CPS: Integer;
  StripHeight: Integer;
  StripWidth: Integer;
  StripCount: Integer;
  RowsRemaining: Integer;
  ImageData: AnsiString;
  BX: Integer;
  B: Byte;
  Dict: TPDFDictionary;
  DecodeArray: AnsiString;
  CreateInlineImage: Boolean;
  TmpContents: AnsiString;

  function ShouldUseInlineImages: Boolean;
  begin
    Result := True;

    if (RPS * CPS * PT.PageInfo[Page].BitsPerSample *
      PT.PageInfo[Page].SamplesPerPixel div 8 > 4096) then
        Result := False;

    if (Result or FForceInline) then
    begin
      Result := (StripCount > 4) and not (PT.PageInfo[Page].Compression = ttNone);
    end;

    //if (PT.PageInfo[Page].EncodedByteAlign) then
    //  Result := False;
  end;

  function CreateHexPalette(PaletteWords: TQPLIntegerArray): AnsiString;
  var
    X: Integer;
    CL: Integer;
    PaletteCount: Integer;
    HexLength: Integer;
  begin
    Result := '';

    PaletteCount := 1 shl BPC;

    CL := Length(PaletteWords) div 3;

    for X := 0 to CL - 1 do
    begin
      Result := Result + QPLIntToHex(PaletteWords[X] shr 8, 2);
      Result := Result + QPLIntToHex(PaletteWords[X + CL] shr 8, 2);
      Result := Result + QPLIntToHex(PaletteWords[X + CL * 2] shr 8, 2);
    end;

    HexLength := PaletteCount * 6;
    if (Length(Result) > HexLength) then
    begin
      SetLength(Result, HexLength);
    end;
    while (Length(Result) < HexLength)  do
    begin
      Result := Result + '00';
    end;
    Result := '<' + Result + '>';
  end;

begin
  Obj := nil;
  TileResourcesX := nil;
  FImageType := itTIFF;
  W := PT.PageInfo[Page].Width;
  H := PT.PageInfo[Page].Height;
  FWidth := W;
  FHeight := H;
  TotalHeight := H;
  StripCount := Length(PT.PageInfo[Page].Strips);
  StripHeight := 0;
  StripWidth := 0;

  if (PT.PageInfo[Page].RowsPerStrip > 1) or (PT.PageInfo[Page].RowsPerTile > 1) then
  begin
    if PT.PageInfo[Page].StripsAreTiles then
    begin
      RPS := PT.PageInfo[Page].RowsPerTile;
      CPS := PT.PageInfo[Page].ColumnsPerTile;
    end else
    begin
      RPS := PT.PageInfo[Page].RowsPerStrip;
      CPS := PT.PageInfo[Page].Width;
      if (RPS < 0) then
      begin
        RPS := PT.PageInfo[Page].Height div StripCount;
      end;
    end
  end else
  begin
    //RPS := PT.PageInfo[Page].Height;
    CPS := PT.PageInfo[Page].Width;
    RPS := PT.PageInfo[Page].RowsPerStrip;
  end;

  CreateInlineImage := ShouldUseInlineImages;

  TileXObject := FStructure.NewStream('');
  if (StripCount > 1) or CreateInlineImage then
  begin
    TileXObject.Dictionary.Add('Subtype', FStructure.NewCommonName('Form'));
    TileXObject.Dictionary.Add('BBox', FStructure.NewIntArray([0, 0, 1, 1]));
    if (not CreateInlineImage) then
    begin
      TileResources := FStructure.NewDictionary;
      TileResourcesX := FStructure.NewDictionary;
      TileXObject.Dictionary.Add('Resources', TileResources);
      TileResources.Add('XObject', TileResourcesX);
    end;
  end;

  BPC := PT.PageInfo[Page].BitsPerSample;
  Predictor := PT.PageInfo[Page].Predictor;
  YPos := 1;
  DecodeArray := '';
  Contents := '';
  TmpContents := '';

  if (not CreateInlineImage) then
  begin
    case PT.PageInfo[Page].PhotometricInterpretation of
      piWhiteIsZero:
      begin
        ColorSpace := '/DeviceGray';
        DecodeArray := '[ 1 0 ]';
      end;
      piBlackIsZero: ColorSpace := '/DeviceGray';
      piRGB:         ColorSpace := '/DeviceRGB';
      piCMYK:        ColorSpace := '/DeviceCMYK';
      piRGBPalette:  ColorSpace := '[ /Indexed /DeviceRGB ' +
        QPLIntToStr((1 shl BPC) - 1) + ' ' +
        CreateHexPalette(PT.PageInfo[Page].PaletteValues) + ' ]';
    end;
  end else
  begin
    case PT.PageInfo[Page].PhotometricInterpretation of
      piWhiteIsZero: begin
          ColorSpace := '/G';
          DecodeArray := '[ 1 0 ]';
        end;
      piBlackIsZero: ColorSpace := '/G';
      piRGB: ColorSpace := '/RGB';
      piCMYK: ColorSpace := '/CMYK';
      piRGBPalette: ColorSpace := '[ /Indexed /RGB ' + QPLIntToStr((1 shl BPC) - 1) + ' ' + CreateHexPalette(PT.PageInfo[Page].PaletteValues) + ' ]';
    end;
  end;

  XRestart := True;
  XPos := 0;
  TotalWidth := 0;

  RowsRemaining := PT.PageInfo[Page].Height;
  for StripX := 0 to StripCount - 1 do
  begin
    if XRestart or not (PT.PageInfo[Page].StripsAreTiles) then
    begin
      XRestart := False;
      TotalWidth := PT.PageInfo[Page].Width;

      if (TotalHeight < RPS) and not (PT.PageInfo[Page].StripsAreTiles) then
      begin
        StripHeight := TotalHeight;
      end else
      begin
        StripHeight := RPS;
      end;

      TotalHeight := TotalHeight - RPS;

      XPos := 0;
      YPos := YPos - (StripHeight / PT.PageInfo[Page].Height);
    end;
    if (TotalWidth <= CPS) and PT.PageInfo[Page].StripsAreTiles then
    begin
      XRestart := True;
    end else
    begin
      StripWidth := CPS;
      TotalWidth := TotalWidth - CPS;
    end;

    if not (PT.PageInfo[Page].StripsAreTiles) then
      if (RowsRemaining < StripHeight) then
        StripHeight := RowsRemaining;

    ImageData := PT.PageInfo[Page].Strips[StripX];
    if (PT.PageInfo[Page].FillOrder = 2) then
    begin
      for BX := 1 to Length(ImageData) do
      begin
        B := Ord(ImageData[BX]);
        B := (B and 128) shr 7 + (B and 64) shr 5 + (B and 32) shr 3 +
          (B and 16) shr 1 + (B and 8) shl 1 + (B and 4) shl 3 +
          (B and 2) shl 5 + (B and 1) shl 7;
        ImageData[BX] := AnsiChar(B);
      end;
    end;
    if (StripCount > 1) and (not CreateInlineImage) then
    begin
      Obj := FStructure.NewStream(ImageData);
      Dict := Obj.Dictionary;
    end else
    begin
      Dict := TileXObject.Dictionary;
    end;

    if not(CreateInlineImage) then
    begin
      Dict.Add('Subtype', FStructure.NewName('Image'));
      Dict.Add('Width', FStructure.NewNumeric(StripWidth));
      Dict.Add('Height', FStructure.NewNumeric(StripHeight));
      Dict.Add('ColorSpace', FStructure.Decode(ColorSpace));
      Dict.Add('BitsPerComponent', FStructure.NewNumeric(BPC));
      if (DecodeArray <> '') then
      begin
        Dict.Add('Decode', FStructure.Decode(DecodeArray));
      end;

      if (PT.PageInfo[Page].Compression = ttComp) then
      begin
        Dict.Add('Filter', FStructure.NewName('LZWDecode'));
        if (Predictor >= 2) then
        begin
          DecodeDict := FStructure.NewDictionary;
          Dict.Add('DecodeParms', DecodeDict);
          DecodeDict.Add('Predictor', FStructure.NewNumeric(Predictor));
          DecodeDict.Add('Colors', FStructure.NewNumeric(PT.PageInfo[Page].SamplesPerPixel));
          DecodeDict.Add('Columns', FStructure.NewNumeric(W));
        end;
      end else
      if (PT.PageInfo[Page].Compression = ttNone) then
      begin
        // The /Filter entry will be set to /FlateDecode by
        // the TPDFStream class if necessary
      end else
      if (PT.PageInfo[Page].Compression = ttDeflate) then
      begin
        Dict.Add('Filter', FStructure.NewName('FlateDecode'));
        if (Predictor >= 2) then
        begin
          DecodeDict := FStructure.NewDictionary;
          Dict.Add('DecodeParms', DecodeDict);
          DecodeDict.Add('Predictor', FStructure.NewNumeric(Predictor));
          DecodeDict.Add('Colors', FStructure.NewNumeric(PT.PageInfo[Page].SamplesPerPixel));
          DecodeDict.Add('Columns', FStructure.NewNumeric(StripWidth));
        end;
      end else
      begin
        Dict.Add('Filter', FStructure.NewName('CCITTFaxDecode'));
        DecodeDict := FStructure.NewDictionary;
        Dict.Add('DecodeParms', DecodeDict);

        if PT.PageInfo[Page].Compression = ttCCITT4 then
          DecodeDict.Add('K', FStructure.NewNumeric(-1));

        if PT.PageInfo[Page].Compression = ttCCITT31d then
          DecodeDict.Add('K', FStructure.NewNumeric(0));

        if PT.PageInfo[Page].Compression = ttCCITT32d then
          DecodeDict.Add('K', FStructure.NewNumeric(1));

        DecodeDict.Add('Columns', FStructure.NewNumeric(StripWidth));
        DecodeDict.Add('Rows', FStructure.NewNumeric(StripHeight));
        DecodeDict.Add('BlackIs1', FStructure.NewBoolean(True));

        if PT.PageInfo[Page].EncodedByteAlign then
        begin
          DecodeDict.Add('EncodedByteAlign', FStructure.NewBoolean(True));
          DecodeDict.Add('EndOfLine', FStructure.NewBoolean(True));
        end;
      end;
    end else
    begin
      TmpContents := '/W ' + QPLIntToStr(StripWidth) + ' /H ' +
        QPLIntToStr(StripHeight) + ' /CS ' + ColorSpace + ' /BPC ' +
        QPLIntToStr(BPC);
      if (DecodeArray <> '') then
        TmpContents := TmpContents + ' /D ' + DecodeArray;

      if (PT.PageInfo[Page].Compression = ttComp) then
      begin
        //ImageData := DeflateStr(ImageData);
        TmpContents := TmpContents + ' /F [ /Fl /LZW ]';

        if (Predictor >= 2) then
        begin
          TmpContents := TmpContents + ' /DP [ null << /Predictor ' +
            QPLIntToStr(Predictor) + ' /Colors ' +
            QPLIntToStr(PT.PageInfo[Page].SamplesPerPixel) +
            ' /Columns ' + QPLIntToStr(StripWidth) + ' >> ]';
        end;
      end else if (PT.PageInfo[Page].Compression = ttNone) then
      begin
        // The /Filter entry will be set to /FlateDecode by
        // the TPDFStream class if necessary
      end else if (PT.PageInfo[Page].Compression = ttDeflate) then
      begin
        TmpContents := TmpContents + ' /F /Fl';
        if (Predictor >= 2) then
        begin
          TmpContents := TmpContents + ' /DP << /Predictor ' +
            QPLIntToStr(Predictor) + ' /Colors ' +
            QPLIntToStr(PT.PageInfo[Page].SamplesPerPixel) + ' /Columns ' +
            QPLIntToStr(StripWidth) + ' >>';
        end;
      end else
      begin
        TmpContents := TmpContents + ' /F /CCF /DP <<';

        If (PT.PageInfo[Page].Compression = ttCCITT4) then
          TmpContents := TmpContents + ' /K -1 '
        else if (PT.PageInfo[Page].Compression = ttCCITT31d) then
          TmpContents := TmpContents + ' /K 0 '
        else if (PT.PageInfo[Page].Compression = ttCCITT32d) then
          TmpContents := TmpContents + ' /K 1 ';

        TmpContents := TmpContents + ' /Columns ' + QPLIntToStr(StripWidth) +
          ' /Rows ' + QPLIntToStr(StripHeight) + ' /BlackIs1 true';

        if PT.PageInfo[Page].EncodedByteAlign then
          TmpContents := TmpContents + ' /EncodedByteAlign true /EndOfLine true';

        TmpContents := TmpContents + ' >>';
      end;
    end;

    if (StripCount > 1) and (not CreateInlineImage) then
    begin
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
      FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    end;

    if (not CreateInlineImage) then
    begin
      ImageName := 'QuickPDFIm' + QPLRandomID;
      if StripCount > 1 then
      begin
        if Assigned(TileResourcesX) then
          TileResourcesX.Add(ImageName, FIndRef);
        Contents := Contents + 'q ' + QPLDoubleToStrConst(StripWidth / PT.PageInfo[Page].Width,
          { 4 } 6) + ' 0 0 ' + QPLDoubleToStrConst(StripHeight / PT.PageInfo[Page].Height,
          { 4 } 6) + ' ' + QPLDoubleToStrConst(XPos,
          { 4 } 6) + ' ' + QPLDoubleToStrConst(YPos,
          { 4 } 6) + ' cm /' + ImageName + ' Do Q'#10;
      end;
    end else
    begin
      if (PT.PageInfo[Page].Compression = ttComp) then
        Contents := Contents + 'q ' + QPLDoubleToStrConst(StripWidth / PT.PageInfo[Page].Width,
          { 4 } 6) + ' 0 0 ' + QPLDoubleToStrConst(StripHeight / PT.PageInfo[Page].Height,
          { 4 } 6) + ' ' + QPLDoubleToStr(XPos,
          { 4 } 6) + ' ' + QPLDoubleToStr(YPos,
          { 4 } 6) + ' cm'#10'BI'#10 + TmpContents + #10'ID'#10 + DeflateStrNoCompression(ImageData) + #10'EI'#10'Q'#10
      else
        Contents := Contents + 'q ' + QPLDoubleToStrConst(StripWidth / PT.PageInfo[Page].Width,
          { 4 } 6) + ' 0 0 ' + QPLDoubleToStrConst(StripHeight / PT.PageInfo[Page].Height,
          { 4 } 6) + ' ' + QPLDoubleToStrConst(XPos,
          { 4 } 6) + ' ' + QPLDoubleToStrConst(YPos,
          { 4 } 6) + ' cm'#10'BI'#10 + TmpContents + #10'ID'#10 + ImageData + #10'EI'#10'Q'#10;
    end;
    XPos := XPos + (StripWidth / PT.PageInfo[Page].Width);

    Dec(RowsRemaining, StripHeight);
  end;

  if (StripCount > 1) or CreateInlineImage then
  begin
    TileXObject.SetTo(Contents, (DebenuPDFLibraryFlate.DeflateDefaultCompressionLevel <> 1)
      or (PT.PageInfo[Page].Compression = ttNone));
  end else
  begin
    TileXObject.SetTo(ImageData);
    if (PT.PageInfo[Page].Compression = ttComp) then
    begin
      TileXObject.Dictionary.Add('Filter', FStructure.NewName('LZWDecode'));
    end else
    if (PT.PageInfo[Page].Compression = ttNone) then
    begin
      // The /Filter entry will be set to /FlateDecode by
      // the TPDFStream class if necessary
    end else
    if (PT.PageInfo[Page].Compression = ttDeflate) then
    begin
      TileXObject.Dictionary.Add('Filter', FStructure.NewName('FlateDecode'));
    end else
    begin
      TileXObject.Dictionary.Add('Filter', FStructure.NewName('CCITTFaxDecode'));
    end;
  end;

  FImageDictionary := TileXObject.Dictionary;
  FStructure.OnNewIndObj(Self, ObjNum, GenNum, TileXObject);
  FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
end;

procedure TPDFImage.NewTIFF(PT: TPDFTIFF; Page: Integer);
var
  UseBMP: Boolean;
  TIFFPage: TTIFFPage;
begin
  UseBMP := True;
  if (PT.PageInfo[Page].Compression = ttCCITT4) or
    (PT.PageInfo[Page].Compression = ttCCITT31d) or
    (PT.PageInfo[Page].Compression = ttCCITT32d) or
    ((PT.PageInfo[Page].Compression = ttNone) and (PT.PageInfo[Page].SamplesPerPixel <= 4)) or
    (PT.PageInfo[Page].Compression = ttDeflate) or
    ((PT.PageInfo[Page].Compression = ttComp) and (PT.PageInfo[Page].ExtraSamples = 0)) then
  begin
    NewThroughTIFF(PT, Page);
    UseBMP := False;
  end;

  if PT.PageInfo[Page].Compression = ttNone then
  begin
    PT.SimpleExtract(Page);
  end;

  if ((PT.PageInfo[Page].Compression = ttComp) and (PT.PageInfo[Page].ExtraSamples > 0)) then
  begin
    PT.CompDecode(Page);
  end;

  if PT.PageInfo[Page].Compression = ttPackbits then
  begin
    NewPackbitsTIFF(PT.PageInfo[Page]);
    UseBMP := False;
  end;
  if PT.PageInfo[Page].Compression = ttJPEG then
  begin
    NewJPEGTIFF(PT.PageInfo[Page]);
    UseBMP := False;
  end;
  if UseBMP then
  begin
    TIFFPage := PT.PageInfo[Page];
    NewBMP(PT.Bitmap, @TIFFPage, (PT.PageInfo[Page].SamplesPerPixel = 1) and
      (PT.PageInfo[Page].BitsPerSample = 8), False);
  end;
end;

function TPDFImage.SaveToFile(const FileName: WideString): Boolean;
var
  FS: TQuickPDFWideFileStream;
begin
  Result := False;
  try
    FS := QPLCreateFileStream(FileName, fmCreate);
    try
      FS.Write(FImageData[1], Length(FImageData));
    finally
      FS.Free;
    end;
    Result := True;
  except
  end;
end;

procedure TPDFImage.SetImageMask(FromRed, FromGreen, FromBlue, ToRed,
  ToGreen, ToBlue: Double);
var
  R1, G1, B1: Byte;
  R2, G2, B2: Byte;
  Obj: TPDFObject;
  BPC: Integer;
  CS: AnsiString;
begin
  FromRed := Max(Min(1, FromRed), 0);
  FromGreen := Max(Min(1, FromGreen), 0);
  FromBlue := Max(Min(1, FromBlue), 0);
  ToRed := Max(Min(1, ToRed), 0);
  ToGreen := Max(Min(1, ToGreen), 0);
  ToBlue := Max(Min(1, ToBlue), 0);
  R1 := Round(FromRed * 255);
  R2 := Round(ToRed * 255);
  G1 := Round(FromGreen * 255);
  G2 := Round(ToGreen * 255);
  B1 := Round(FromBlue * 255);
  B2 := Round(ToBlue * 255);

  Obj := FImageDictionary.FindValuebyKeyName('BitsPerComponent', True);
  if Obj is TPDFNumeric then
  begin
    BPC := TPDFNumeric(Obj).AsInteger;
  end else
  begin
    BPC := 0;
  end;

  Obj := FImageDictionary.FindValuebyKeyName('ColorSpace', True);
  if Obj is TPDFName then
  begin
    CS := TPDFName(Obj).Name;
  end else
  if Obj is TPDFArray then
  begin
    if (TPDFArray(Obj).Count >= 2) then
      CS := TPDFName(TPDFArray(Obj).Item[1]).Name;
  end else
  begin
    CS := '';
  end;

  case BPC of
    1:
      FImageDictionary.Add('Mask', FStructure.NewIntArray([Round(FromRed), Round(ToRed)]));

    8:
      if (CS = 'DeviceGray') then
        FImageDictionary.Add('Mask', FStructure.NewIntArray([R1, R2]))
      else if (CS = 'DeviceRGB') then
        FImageDictionary.Add('Mask', FStructure.NewIntArray([R1, R2, G1, G2, B1, B2]));
  end;
end;

procedure TPDFImage.SetImageMaskCMYK(FromC, FromM, FromY, FromK, ToC, ToM,
  ToY, ToK: Double);
var
  C1, M1, Y1, K1: Byte;
  C2, M2, Y2, K2: Byte;
begin
  FromC := Max(Min(1, FromC), 0);
  FromM := Max(Min(1, FromM), 0);
  FromY := Max(Min(1, FromY), 0);
  FromK := Max(Min(1, FromK), 0);
  ToC := Max(Min(1, ToC), 0);
  ToM := Max(Min(1, ToM), 0);
  ToY := Max(Min(1, ToY), 0);
  ToK := Max(Min(1, ToK), 0);
  C1 := Round(FromC * 255);
  C2 := Round(ToC * 255);
  M1 := Round(FromM * 255);
  M2 := Round(ToM * 255);
  Y1 := Round(FromY * 255);
  Y2 := Round(ToY * 255);
  K1 := Round(FromK * 255);
  K2 := Round(ToK * 255);
  FImageDictionary.Add('Mask', FStructure.NewIntArray([C1, C2, M1, M2, Y1, Y2, K1, K2]));
end;

function TPDFImage.SetImageAsMask(MaskType: TPDFMaskType): Boolean;
var
  Obj: TPDFObject;
  BPC: Integer;
  CS: AnsiString;
begin
  Result := False;

  Obj := FImageDictionary.FindValuebyKeyName('BitsPerComponent', True);
  if Obj is TPDFNumeric then
    BPC := TPDFNumeric(Obj).AsInteger
  else
    BPC := 0;

  Obj := FImageDictionary.FindValuebyKeyName('ColorSpace', True);
  if Obj is TPDFName then
    CS := TPDFName(Obj).Name
  else
    CS := '';

  Obj := FImageDictionary.FindValuebyKeyName('ImageMask', True);
  if (Obj is TPDFBoolean) and TPDFBoolean(Obj).AsBoolean then
  begin
    if (CS = '') and (BPC = 1) then
    begin
      FImageDictionary.Add('ColorSpace', FStructure.NewName('DeviceGray'));
      CS := 'DeviceGray';
    end;
  end;

  if MaskType = mtStencilMask then
  begin
    if (CS = 'DeviceGray') and (BPC = 1) then
    begin
      FImageDictionary.Add('ImageMask', FStructure.NewBoolean(True));
      FImageDictionary.PurgeKey('ColorSpace');
      ClearImageMask;
      Result := True;
    end;
  end;

  if MaskType = mtSoftMask then
  begin
    if (CS = 'DeviceRGB') then
    begin
      ConvertToGray;
      Obj := FImageDictionary.FindValuebyKeyName('ColorSpace', True);
      if Obj is TPDFName then
        CS := TPDFName(Obj).Name
      else
        CS := '';
    end;
    if (CS = 'DeviceGray') then
    begin
      FImageDictionary.Add('ImageMask', FStructure.NewBoolean(False));
      ClearImageMask;
      Result := True;
    end;
  end;
end;

function TPDFImage.SetImageMaskFromImage(ObjNum, GenNum: Integer; MaskType: TPDFMaskType): Boolean;
begin
  Result := False;
  case MaskType of
    mtStencilMask:
    begin
      Result := True;
      FImageDictionary.Add('Mask', FStructure.NewIndirectRef(ObjNum, GenNum));
    end;
    mtSoftMask:
    begin
      Result := True;
      FImageDictionary.Add('SMask', FStructure.NewIndirectRef(ObjNum, GenNum));
    end;
  end;
end;

function TPDFImage.GetMaskType: TPDFMaskType;
var
  Obj: TPDFObject;
  HasMask: Boolean;
  HasSMask: Boolean;
  HasBPC: Boolean;  
  ImageMask: Boolean;
  BPC: Integer;
  HasDecode: Boolean;
  Decode: AnsiString;
  HasCS: Boolean;  
  CS: AnsiString;
begin

  Result := mtUnknown;
  if (Assigned(FImageDictionary)) then
  begin
    Obj := FImageDictionary.FindValueByKeyName('ImageMask', True);
    ImageMask := (Obj is TPDFBoolean) and TPDFBoolean(Obj).AsBoolean;
    Obj := FImageDictionary.FindValueByKeyName('Mask', True);
    HasMask := Assigned(Obj);
    Obj := FImageDictionary.FindValueByKeyName('SMask', True);
    HasSMask := Assigned(Obj);
    Obj := FImageDictionary.FindValueByKeyName('BitsPerComponent', True);
    HasBPC := Obj is TPDFNumeric;
    if HasBPC then
      BPC := TPDFNumeric(Obj).AsInteger
    else
      BPC := 0;
    Obj := FImageDictionary.FindValueByKeyName('ColorSpace', True);
    HasCS := Obj is TPDFName;
    if HasCS then
      CS := TPDFName(Obj).Name
    else
      CS := '';
    Obj := FImageDictionary.FindValueByKeyName('Decode', True);
    HasDecode := Obj is TPDFArray;
    if HasDecode then
      Decode := TPDFArray(Obj).Output;
    if ImageMask and (not HasSMask) and (not HasMask) and
      ((not HasBPC) or (HasBPC and (BPC = 1))) and
      ((not HasDecode) or (HasDecode and (Decode = '[ 0 1 ]')) or
      (HasDecode and (Decode = '[ 1 0 ]'))) and
      (not HasCS) then
        Result := mtStencilMask;
    if (not ImageMask) and (not HasSMask) and (not HasMask) and
      HasCS and (CS = 'DeviceGray') then
        Result := mtSoftMask;
  end;
end;

function TPDFImage.GetMeasureDict: TPDFDictionary;
var
  Obj: TPDFObject;
begin
  Obj := FImageDictionary.FindValueByKeyName('Measure', True);
  if (Obj is TPDFDictionary) then
  begin
    Result := TPDFDictionary(Obj);
  end else
  begin
    Result := FStructure.NewDictionary;
    FImageDictionary.Add('Measure', Result);
  end;
end;

function TPDFImage.GetPtDataDict: TPDFDictionary;
var
  Obj: TPDFObject;
begin
  Obj := FImageDictionary.FindValueByKeyName('PtData', True);
  if (Obj is TPDFDictionary) then
  begin
    Result := TPDFDictionary(Obj);
  end else
  begin
    Result := FStructure.NewDictionary;
    FImageDictionary.Add('PtData', Result);
    FImageDictionary.Add('Type', FStructure.NewName('PtData'));
    FImageDictionary.Add('Subtype', FStructure.NewName('Cloud'));
  end;
end;

procedure TPDFImage.ClearImageMask;
begin
  FImageDictionary.PurgeKey('Mask');
  FImageDictionary.PurgeKey('SMask');
end;

procedure TPDFImage.ConvertToGray;
var
  Obj: TPDFObject;
  RGBData: AnsiString;
  GrayData: AnsiString;
  X: Integer;
  Offset: Integer;
  R, G, B: Double;
begin
  if (FIndRef.Obj is TPDFStream) then
  begin
    RGBData := TPDFStream(FindRef.Obj).GetDecodedStream;
    if (RGBData <> '') then
    begin
      Obj := FImageDictionary.FindValueByKeyName('ColorSpace', True);
      if (Obj is TPDFName) then
      begin
        if (TPDFName(Obj).Name = 'DeviceRGB') then
        begin
          TPDFName(Obj).SetTo('DeviceGray');
          SetLength(GrayData, Length(RGBData) div 3);
          Offset := 1;
          for X := 1 to Length(GrayData) do
          begin
            R := Ord(RGBData[Offset]);
            G := Ord(RGBData[Offset + 1]);
            B := Ord(RGBData[Offset + 2]);
            Inc(Offset, 3);
            GrayData[X] := AnsiChar(Round(R * 0.2989 + G * 0.587 + B * 0.114));
          end;

          if (FIndRef.Obj is TPDFStream) then
          begin
            TPDFStream(FIndRef.Obj).SetTo(GrayData, True);
          end;
        end;
      end;
    end;
  end;
end;

function TPDFImage.Reverse(Reset: Boolean): Boolean;
var
  Obj: TPDFObject;
  CS: AnsiString;
  Components: Integer;
  Decode: TPDFArray;
  X: Integer;
  V: Double;
  Sum: array[0..1] of Double;
  Start: Integer;
begin
  Result := False;
  if Reset then
  begin
    FImageDictionary.PurgeKey('Decode');
    Result := True;
  end else
  begin
    Obj := FImageDictionary.FindValueByKeyName('ColorSpace', True);
    if Obj is TPDFName then
      CS := TPDFName(Obj).Name
    else
      CS := '';

    Obj := FImageDictionary.FindValueByKeyName('Decode', True);
    if Obj is TPDFArray then
    begin
      Decode := TPDFArray(Obj);
      Obj := FImageDictionary.FindValueByKeyName('ImageMask', True);
      if (Obj is TPDFBoolean) and TPDFBoolean(Obj).AsBoolean then
        CS := 'DeviceGray';
      Components := 0;
      if CS = 'DeviceGray' then Components := 1;
      if CS = 'DeviceRGB' then Components := 3;
      if CS = 'DeviceCMYK' then Components := 4;
      if Components > 0 then
      begin
        if Decode.Count = Components * 2 then
        begin
          Result := True;
          Sum[0] := 0;
          Sum[1] := 0;
          for X := 0 to Decode.Count - 1 do
          begin
            if not (Decode.Item[X] is TPDFNumeric) then
              Result := False;
            if Result then
            begin
              V := TPDFNumeric(Decode.Item[X]).AsDouble;
              if (V <> 0) and (V <> 1) then
                Result := False;
              if Result then
                Sum[X mod 2] := Sum[X mod 2] + V;
            end;
          end;
          if Result and (((Sum[0] = Components) and (Sum[1] = 0)) or
            ((Sum[1] = Components) and (Sum[0] = 0))) then
          begin
            Result := True;
            Start := TPDFNumeric(Decode.Item[0]).AsInteger;
            for X := 0 to Decode.Count - 1 do
              TPDFNumeric(Decode.Item[X]).SetTo(
                Abs(((X + 1) mod 2) - Start));
          end else
            Result := False;
        end;
      end;
    end else
    begin
      if CS = 'DeviceGray' then FImageDictionary.Add('Decode', FStructure.Decode('[ 1 0 ]'));
      if CS = 'DeviceRGB' then FImageDictionary.Add('Decode', FStructure.Decode('[ 1 0 1 0 1 0 ]'));
      if CS = 'DeviceCMYK' then FImageDictionary.Add('Decode', FStructure.Decode('[ 1 0 1 0 1 0 1 0 ]'));            
    end;
  end;
end;

procedure TPDFImage.Populate(ObjNum, GenNum, ImWidth, ImHeight: Integer);
var
  Obj: TPDFObject;
begin
  FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
  FWidth := ImWidth;
  FHeight := ImHeight;
  Obj := FIndRef.Obj;
  if Obj is TPDFStream then
    FImageDictionary := TPDFStream(Obj).Dictionary
  else
    FImageDictionary := FStructure.NewStream('').Dictionary;
end;

function TPDFImage.SaveToStream(OutStream: TStream): Boolean;
begin
  if (Length(FImageData) > 0) then
  begin
    Result := OutStream.Write(FImageData[1], Length(FImageData)) =
      Length(FImageData);
  end else
  begin
    Result := False;
  end;
end;

{$IFNDEF QPL_LITE}
procedure TPDFImage.NewEMF(MF: TMetafile; FontOptions: Integer; RecompressImages: Boolean);
var
  GenNum: Integer;
  ObjNum: Integer;
  Obj: TPDFStream;
  PMF: TPDFMetafile;
begin
  Obj := FStructure.NewStream('');
  Obj.Dictionary.Add('Type', FStructure.NewName('XObject'));
  Obj.Dictionary.Add('Subtype', FStructure.NewName('Form'));
  Obj.Dictionary.Add('FormType', FStructure.NewNumeric(1));

  FWidth := Round(MF.MMWidth * 72 / 2540);
  FHeight := Round(MF.MMHeight * 72 / 2540);

  if (FHeight > FWidth) then
  begin
    Obj.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, 1, FHeight / FWidth]));
  end else
  begin
    Obj.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, FWidth / FHeight, 1]));
  end;

  // Changed the Matrix to [ 1 0 0 1 0 0 ]
  // TPDFMetafile now calls FPainter.Scale(0.001);
  Obj.Dictionary.Add('Matrix', FStructure.NewDoubleArray([1, 0, 0, 1, 0, 0]));

  FImageDictionary := Obj.Dictionary;

  PMF := TPDFMetafile.Create(FStructure, FIncludedFonts, FIncludedBitmaps,
    FIncludedGS, FIncludedPatterns);
  try
    PMF.Enhanced := MF.Enhanced;
    PMF.EmbedFonts := FontOptions = 1;  //ADC
    PMF.CompressFonts := FCompressFonts;
    PMF.NoEmbedFontList := FNoEmbedFontList;
    PMF.RecompressImages := RecompressImages;
    PMF.Process(MF, Obj);
  finally
    PMF.Free;
  end;

  FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
  FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
end;
{$ENDIF}

function DetermineImageType(S: TStream): TPDFImageType;
var
{$IFDEF QPL_OS_WINDOWS}
  WMF: TMetafileHeader;
  EMF: TEnhMetaHeader;
{$ENDIF}
  BMP: TBitmapFileHeader;
  JPEG: Word;
  TIFF: Word;
  PNG1: Cardinal;
  PNG2: Cardinal;
{$IFDEF QPL_OS_WINDOWS}
  Checksum: Word;
{$ENDIF}
  GIF: AnsiString;
begin
  Result := itUnknown;

{$IFDEF QPL_OS_WINDOWS}
  // WMF
  if Result = itUnknown then
  begin
    S.Seek(0, soFromBeginning);
    S.Read(WMF, SizeOf(WMF));
    Checksum := 0 xor (WMF.Key and $FFFF0000 shr 16) xor (WMF.Key and $FFFF) xor
      WMF.Handle xor WMF.BoxLeft xor WMF.BoxTop xor WMF.BoxRight xor
      WMF.BoxBottom xor WMF.Inch xor WMF.Reserved1 xor WMF.Reserved2;
    if (WMF.Key = Cardinal(WMFKEY)) and (Checksum = WMF.CheckSum) then
      Result := itWMF;
  end;

  // EMF
  if Result = itUnknown then
  begin
    S.Seek(0, soFromBeginning);
    S.Read(EMF, SizeOf(EMF));
    if (EMF.iType = EMR_HEADER) and (EMF.dSignature = ENHMETA_SIGNATURE) then
      Result := itEMF;
  end;
{$ENDIF}

  // BMP
  if Result = itUnknown then
  begin
    S.Seek(0, soFromBeginning);
    S.Read(BMP, SizeOf(BMP));
    if (BMP.bfType = $4D42) and (BMP.bfReserved1 = 0) and (BMP.bfReserved2 = 0) then
      Result := itBMP;
  end;

  // JPEG
  if Result = itUnknown then
  begin
    S.Seek(0, soFromBeginning);
    S.Read(JPEG, SizeOf(JPEG));
    if JPEG = $D8FF then
      Result := itJPEG;
  end;

  // TIFF
  if Result = itUnknown then
  begin
    S.Seek(0, soFromBeginning);
    S.Read(TIFF, SizeOf(TIFF));
    if (TIFF = $4D4D) or (TIFF = $4949) then
      Result := itTIFF;
  end;

  // PNG
  if Result = itUnknown then
  begin
    S.Seek(0, soFromBeginning);
    S.Read(PNG1, SizeOf(PNG1));
    S.Read(PNG2, SizeOf(PNG2));
    if (PNG1 = $474E5089) and (PNG2 = $0A1A0A0D) then
      Result := itPNG;
  end;

  // GIF
  if Result = itUnknown then
  begin
    S.Seek(0, soFromBeginning);
    SetLength(GIF, 6);
    S.Read(GIF[1], 6);
    if (GIF = 'GIF87a') or (GIF = 'GIF89a') then
      Result := itGIF;
  end;

  S.Seek(0, soFromBeginning);
end;

procedure TPDFImage.SetName(const NewName: AnsiString);
begin
  FName := NewName;
end;

procedure TPDFImage.SetOCG(IndRef: TPDFIndRef);
begin
  FImageDictionary.Add('OC', IndRef);
end;

procedure TPDFImage.NewPackbitsTIFF(Page: TTIFFPage);
var
  GenNum: Integer;
  ObjNum: Integer;
  Obj: TPDFStream;
  Decode: AnsiString;
  CS: AnsiString;
  ImageData: AnsiString;
  X: Integer;
  TilesAcross: Integer;
  TilesDown: Integer;
  Col: Integer;
  B: Byte;
  CreateInlineImage: Boolean;
  ImageName: AnsiString;
  TileXObject: TPDFStream;
  TileResources: TPDFDictionary;
  TileResourcesX: TPDFDictionary;
  Dict: TPDFDictionary;
  Contents: AnsiString;
  TmpContents: AnsiString;
  ColHeight: Integer;

  function ShouldUseInlineImages: Boolean;
  begin
    Result := (TilesAcross > 4)
  end;

  function CreateHexPalette(PaletteWords: TQPLIntegerArray): AnsiString;
  var
    X: Integer;
    CL: Integer;
    PaletteCount: Integer;
    HexLength: Integer;
  begin
    Result := '';

    PaletteCount := 1 shl Page.BitsPerSample;

    CL := Length(PaletteWords) div 3;

    for X := 0 to CL - 1 do
    begin
      Result := Result + QPLIntToHex(PaletteWords[X] shr 8, 2);
      Result := Result + QPLIntToHex(PaletteWords[X + CL] shr 8, 2);
      Result := Result + QPLIntToHex(PaletteWords[X + CL * 2] shr 8, 2);
    end;

    HexLength := PaletteCount * 6;
    if (Length(Result) > HexLength) then
    begin
      SetLength(Result, HexLength);
    end;
    while (Length(Result) < HexLength)  do
    begin
      Result := Result + '00';
    end;
    Result := '<' + Result + '>';
  end;

begin
  TileXObject := nil;

  if Page.StripsAreTiles then
  begin
    TilesAcross := Trunc((Page.Width + Page.ColumnsPerTile - 1) / Page.ColumnsPerTile);
    TilesDown := Trunc((Page.Height + Page.RowsPerTile - 1) / Page.RowsPerTile);
  end else
  begin
    TilesAcross := 1;
    TilesDown := Length(Page.Strips);
  end;

  CreateInlineImage := ShouldUseInlineImages;

  FImageType := itTIFF;

  FWidth := Page.Width;
  FHeight := Page.Height;
  FHDPI := Page.XRes;
  FVDPI := Page.YRes;
  FDPIUnits := 2;
  ColHeight := Page.RowsPerTile * TilesDown;

  Obj := nil;
  TileResourcesX := nil;
  Contents := '';

  if (TilesAcross > 1) then
  begin
    TileXObject := FStructure.NewStream('');
    TileXObject.Dictionary.Add('Subtype', FStructure.NewCommonName('Form'));
    TileXObject.Dictionary.Add('BBox', FStructure.NewIntArray([0, 0, 1, 1]));
    if not(CreateInlineImage) then
    begin
      TileResources := FStructure.NewDictionary;
      TileResourcesX := FStructure.NewDictionary;
      TileXObject.Dictionary.Add('Resources', TileResources);
      TileResources.Add('XObject', TileResourcesX);
    end;
  end;

  for Col := 0 to TilesAcross - 1 do
  begin
    ImageData := '';

    for X := 0 to TilesDown - 1 do
      ImageData := ImageData + Page.Strips[(X * TilesAcross) + Col];

    if (Page.FillOrder = 2) then
    begin
      for X := 1 to Length(ImageData) do
      begin
        B := Ord(ImageData[X]);
        B := (B and 128) shr 7 + (B and 64) shr 5 + (B and 32) shr 3 + (B and 16) shr 1 + (B and 8) shl 1 + (B and 4) shl 3 + (B and 2) shl 5 + (B and 1) shl 7;
        ImageData[X] := AnsiChar(B);
      end;
    end;

    if (not CreateInlineImage) or (TilesAcross = 1) then
    begin
      CS := '/DeviceGray';
      if Page.PhotometricInterpretation = piRGB then
        CS := '/DeviceRGB';
      if Page.PhotometricInterpretation = piRGBPalette then
      begin
        CS := '[ /Indexed /DeviceRGB ' + QPLIntToStr((1 shl Page.BitsPerSample) - 1) + ' ' + CreateHexPalette(Page.PaletteValues) + ' ]'
      end;
    end else
    begin
      CS := '/G';
      if Page.PhotometricInterpretation = piRGB then
        CS := '/RGB';
      if Page.PhotometricInterpretation = piRGBPalette then
      begin
        CS := '[ /Indexed /RGB ' + QPLIntToStr((1 shl Page.BitsPerSample) - 1) + ' ' + CreateHexPalette(Page.PaletteValues) + ' ]'
      end;
    end;

    Decode := '';
    if Page.PhotometricInterpretation = piWhiteIsZero then
    begin
      Decode := '[ 1 0 ]';
    end;

    if not(CreateInlineImage) or (TilesAcross = 1) then
    begin
      Obj := FStructure.NewStream(ImageData, True);
      Dict := Obj.Dictionary;
      Dict.Add('Type', FStructure.NewName('XObject'));
      Dict.Add('Subtype', FStructure.NewName('Image'));
      if not(Page.StripsAreTiles) then
      begin
        Dict.Add('Width', FStructure.NewNumeric(FWidth));
        Dict.Add('Height', FStructure.NewNumeric(FHeight));
      end else
      begin
        Dict.Add('Width', FStructure.NewNumeric(Page.ColumnsPerTile));
        Dict.Add('Height', FStructure.NewNumeric(Page.RowsPerTile * TilesDown));
      end;
      Dict.Add('ColorSpace', FStructure.Decode(CS));
      if Decode <> '' then
        Dict.Add('Decode', FStructure.Decode(Decode));
      Dict.Add('BitsPerComponent', FStructure.NewNumeric(Page.BitsPerSample));
      Dict.Add('Filter', FStructure.Decode('[ /FlateDecode /RunLengthDecode ]'))
    end else
    begin
      if not(Page.StripsAreTiles) then
        TmpContents := '/W ' + QPLIntToStr(FWidth) + ' /H ' + QPLIntToStr(FHeight)
      else
        TmpContents := '/W ' + QPLIntToStr(Page.ColumnsPerTile) + ' /H ' + QPLIntToStr(ColHeight);
      TmpContents := TmpContents + ' /CS ' + CS + ' /BPC ' + QPLIntToStr(Page.BitsPerSample);
      if (Decode <> '') then
        TmpContents := TmpContents + ' /D ' + Decode;
      TmpContents := TmpContents + ' /F [ /Fl /RL ]';
    end;

    if TilesAcross > 1 then
    begin
      if not(Page.StripsAreTiles) then
        Contents := Contents + 'q 1 0 0 1 0 0'
      else
        Contents := Contents + 'q ' + QPLDoubleToStrConst(Page.ColumnsPerTile / Page.Width, 6) + ' 0 0 ' + QPLDoubleToStrConst(ColHeight / Page.Height, 6) + ' ' + QPLDoubleToStrConst
          (Page.ColumnsPerTile * Col / Page.Width, 6) + ' ' + QPLDoubleToStrConst(1 - ColHeight / Page.Height, 6);
      if not(CreateInlineImage) then
      begin
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
        FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
        ImageName := 'QuickPDFIm' + QPLRandomID;
        TileResourcesX.Add(ImageName, FIndRef);
        Contents := Contents + ' cm /' + ImageName + ' Do Q'#10
      end else
        Contents := Contents + ' cm'#10'BI'#10 + TmpContents + #10'ID'#10 + DeflateStr(ImageData) + #10'EI'#10'Q'#10
    end;
  end;

  if (TilesAcross = 1) then
  begin
    FImageDictionary := Obj.Dictionary;
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
  end else
  begin
    if (Assigned(TileXObject)) then
    begin
      TileXObject.SetTo(Contents, False);
      FImageDictionary := TileXObject.Dictionary;
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, TileXObject);
    end;
  end;

  FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
end;


function TPDFImage.NewEMFFromStream(InStream: TStream; FontOptions,
  GeneralOptions: Integer): Boolean;
var
  BM: TBitmap;
  EMF: TMetafile;
  MyPic: TPDFPicasso;
  WMF: TMetafile;
  TempCanvas: TMetaFileCanvas;
  CheckType: TPDFImageType;
begin
  EMF := TMetaFile.Create;
  try
    try
      InStream.Seek(0, soFromBeginning);
      EMF.LoadFromStream(InStream);

      CheckType := DetermineImageType(InStream);
      //FB21027
      if (CheckType = itWMF) then
      begin
        WMF := TMetaFile.Create;
        WMF.Width := EMF.Width;
        WMF.Height := EMF.Height;
        TempCanvas := TMetaFileCanvas.Create(WMF, 0);
        with TempCanvas do
        try
          Draw(0,0, EMF);
        finally
          Free;
        end;
        EMF.Free;
        EMF := WMF;
      end;

      if GeneralOptions = 1 then
      begin
        BM := TBitmap.Create;
        MyPic := TPDFPicasso.Create;
        try
          InStream.Seek(0, soFromBeginning);
          BM.PixelFormat := pf24bit;
          BM.Width := EMF.Width;
          BM.Height := EMF.Height;
          BM.Canvas.Lock;

          GDIPlusSettings.UseGDIPlus := True;
          GDIPlusSettings.Smoothing := True;
          GDIPlusSettings.AccurateInterpolation := True;
          GDIPlusSettings.SmoothImages := True;
          GDIPlusSettings.ProcessNullPath := True;
          GDIPlusSettings.MonoThreshold := 0;

          MyPic.UseGDIPlusModel(BM.Canvas, GDIPlusSettings);
          MyPic.DrawAnyImage(0, 0, BM.Width, BM.Height, InStream, 1);
          if FCompress = 0 then
          begin
            FCompress := 1;
            Result := NewBMP(BM, nil, False, False);
            FCompress := 0;
          end else
            Result := NewBMP(BM, nil, False, False);
        finally
          MyPic.Free;
          BM.Free;
        end;
      end else
      begin
{$IFDEF QPL_LITE}
        Result := False;
{$ELSE}
        Result := True;
        NewEMF(EMF, FontOptions, (GeneralOptions = 2));
{$ENDIF}
      end;
    except
      Result := False;
    end;
  finally
    EMF.Free;
  end;
end;

destructor TPDFImage.Destroy;
begin
  //FIncludedFonts.Free;
  FIncludedBitmaps.Free;
  FIncludedGS.Free;
  FIncludedPatterns.Free;
  inherited;
end;

procedure TPDFImage.NewJPEGTIFF(Page: TTIFFPage);
var
  ImageStream: TMemoryStream;
  ThisStrip: AnsiString;
  X: Integer;
  StripCount: Integer;
  TileXObject: TPDFStream;
  TileResources: TPDFDictionary;
  TileResourcesX: TPDFDictionary;
  ImageName: AnsiString;
  TotalHeight: Integer;
  TotalWidth: Integer;
  Contents: AnsiString;
  ObjNum: Integer;
  GenNum: Integer;
  CreateInlineImage: Boolean;
  RPS: Integer;
  CPS: Integer;
  YPos: Double;
  XPos: Double;
  XRestart: Boolean;
  StripHeight: Integer;
  StripWidth: Integer;
  Buffer: AnsiString;
  Info: TJPEGQuickInfo;

  function ShouldUseInlineImages: Boolean;
  var
    StripSize: Cardinal;
  begin
    Result := True;
    StripSize := StripWidth * StripHeight;
    if (StripSize > 4096) then
    begin
      Result := False;
    end;

    if (Result or FForceInline) then
    begin
      Result := (StripCount > 4);
    end;
  end;

begin
  StripCount := Length(Page.Strips);

  CreateInlineImage := ShouldUseInlineImages;

  if (StripCount > 1) or CreateInlineImage then
  begin

    YPos := 1;

    if Page.StripsAreTiles then
    begin
      RPS := Page.RowsPerTile;
      CPS := Page.ColumnsPerTile;
    end else
    begin
      RPS := Page.RowsPerStrip;
      CPS := Page.Width;
      if (RPS < 0) then
      begin
        RPS := Page.Height div StripCount;
      end;
    end;

    TotalHeight := Page.Height;

    Contents := '';
    TileXObject := FStructure.NewStream('');
    TileXObject.Dictionary.Add('Subtype', FStructure.NewCommonName('Form'));
    TileXObject.Dictionary.Add('BBox', FStructure.NewIntArray([0, 0, 1, 1]));
    if not (CreateInlineImage) then
    begin
      TileResources := FStructure.NewDictionary;
      TileResourcesX := FStructure.NewDictionary;
      TileXObject.Dictionary.Add('Resources', TileResources);
      TileResources.Add('XObject', TileResourcesX);
    end else
    begin
      TileResourcesX := nil;
    end;

    // Add each strip as a separate JPEG (/DCTDecode filter) image
    XRestart := True;
    XPos := 0;
    TotalWidth := 0;
    for X := 0 to StripCount - 1 do
    begin
      if XRestart or not (Page.StripsAreTiles) then
      begin
        XRestart := False;
        TotalWidth := Page.Width;

        if (TotalHeight < RPS) and not(Page.StripsAreTiles) then
        begin
          StripHeight := TotalHeight;
        end else
        begin
          StripHeight := RPS;
        end;

        TotalHeight := TotalHeight - RPS;

        XPos := 0;
        YPos := YPos - (StripHeight / Page.Height);
      end;

      if (TotalWidth < CPS) and Page.StripsAreTiles then
      begin
        XRestart := True;
      end else
      begin
        StripWidth := CPS;
        TotalWidth := TotalWidth - CPS;
      end;

      ThisStrip := Page.Strips[X];
      ImageStream := TMemoryStream.Create;
      try
        if Length(ThisStrip) > 0 then
        begin
          ImageStream.Write(ThisStrip[1], Length(ThisStrip));
        end;
        ImageStream.Seek(0, soFromBeginning);

        Contents := Contents + 'q ' + QPLDoubleToStrConst(StripWidth / Page.Width,
          { 4 } 6) + ' 0 0 ' + QPLDoubleToStrConst(StripHeight / Page.Height,
          { 4 } 6) + ' ' + QPLDoubleToStrConst(XPos,
          { 4 } 6) + ' ' + QPLDoubleToStrConst(YPos, { 4 } 6) + ' cm';

        XPos := XPos + (StripWidth / Page.Width);

        if CreateInlineImage then
        begin
          SetLength(Buffer, ImageStream.Size);
          ImageStream.Read(Buffer[1], ImageStream.Size);

          JPEGSizeColorStream(ImageStream, Info);

          Contents := Contents + #10'BI'#10 + '/W ' +
            QPLIntToStr(Info.Width) + ' /H ' + QPLIntToStr(Info.Height);

          if Info.Components = 1 then
            Contents := Contents + ' /CS /G'
          else if Info.Components = 4 then
          begin
            Contents := Contents + ' /CS /CMYK /D [ 1 0 1 0 1 0 1 0 ]'
          end else
            Contents := Contents + ' /CS /RGB';

          Contents := Contents + ' /BPC 8 /F /DCT' + #10'ID'#10 + Buffer + #10'EI'#10'Q'#10;
        end else
        begin
          NewJPEG(ImageStream);
          ImageName := 'QuickPDFIm' + QPLRandomID;
          if (Assigned(TileResourcesX)) then
          begin
            TileResourcesX.Add(ImageName, FIndRef);
          end;
          Contents := Contents + ' /' + ImageName + ' Do Q'#10;
        end;
      finally
        ImageStream.Free;
      end;
    end;

    FWidth := Page.Width;
    FHeight := Page.Height;

    TileXObject.SetTo(Contents, False);
    FImageDictionary := TileXObject.Dictionary;
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, TileXObject);
    FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
  end else
  begin
    ImageStream := TMemoryStream.Create;
    try
      ThisStrip := Page.Strips[0];
      if Length(ThisStrip) > 0 then
      begin
        ImageStream.Write(ThisStrip[1], Length(ThisStrip));
      end;
      ImageStream.Seek(0, soFromBeginning);
      NewJPEG(ImageStream, True);
    finally
      ImageStream.Free;
    end;
  end;
end;

procedure TPDFImage.ClearImage;
var
  Obj: TPDFObject;
begin
  Obj := FIndRef.Obj;
  if Obj is TPDFStream then
  begin
    // Set the image stream to a single black pixel
    TPDFStream(Obj).SetTo(#0#0#0, False);
    FImageDictionary.Add('Width', FStructure.NewNumeric(1));
    FImageDictionary.Add('Height', FStructure.NewNumeric(1));
    FImageDictionary.Add('ColorSpace', FStructure.NewName('DeviceRGB'));
    FImageDictionary.Add('BitsPerComponent', FStructure.NewNumeric(8));
    FImageDictionary.Add('ImageMask', FStructure.NewBoolean(False));
    FImageDictionary.Add('Mask', FStructure.NewDoubleArray([0, 0, 0, 0, 0, 0]));
    FImageDictionary.PurgeKey('Decode');
    FImageDictionary.PurgeKey('SMask');

    FWidth := 1;
    FHeight := 1;
  end;
end;

procedure TPDFImage.DeleteOCG;
begin
 FImageDictionary.PurgeKey('OC');
end;

end.
