{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryPatterns.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryPatterns;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  SysUtils,
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
  DebenuPDFLibraryExtra,
  DebenuPDFLibraryFlate,
  DebenuPDFLibraryStructure,
  DebenuPDFLibraryMatrix,
  DebenuPDFLibraryFunctions,
  DebenuPDFLibraryTypes,
  DebenuPDFLibraryColorManagement;

type
  TPDFPatternBBox = record
    Left: Double;
    Top: Double;
    Right: Double;
    Bottom: Double;
  end;

  TPDFPattern = class
  private
    FName: AnsiString;
    FMatrix: TPDFXForm;
    FPatternType: Double;
    FPaintType: Double;
    FTilingType: Double;
    FBBox: TPDFPatternBBox;
    FXStep: Double;
    FYStep: Double;
    FFilter: AnsiString;
    FStream: AnsiString;
    FStructure: TPDFStructure;
    FIndRef: TPDFIndRef;
    FBitmap: TBitmap;
    FHandle: Integer;
    FColors: TQuickPDFIntegerList;
  public
    constructor Create(AStructure: TPDFStructure; const AName: AnsiString);
    function SetBWToColor(Bitmap: TBitmap; BColor, WColor: TColor): TBitmap;
    function NewPatternBitMap(Bitmap: TBitmap; Color: TColor): Boolean;
    function GetInlineStream(BM: TBitmap): AnsiString;
    property Name: AnsiString read FName write FName;
    property Matrix: TPDFXForm read FMatrix write FMatrix;
    property PatternType: Double read FPatternType write FPatternType;
    property PaintType: Double read FPaintType write FPaintType;
    property TilingType: Double read FTilingType write FTilingType;
    property BBox: TPDFPatternBBox read FBBox write FBBox;
    property XStep: Double read FXStep write FXStep;
    property YStep: Double read FYStep write FYStep;
    property Filter: AnsiString read FFilter write FFilter;
    property Stream: AnsiString read FStream write FStream;
    property IndRef: TPDFIndRef read FIndRef;
    property Bitmap: TBitmap read FBitmap write FBitmap;
    property Handle: Integer read FHandle write FHandle;
    property Colors: TQuickPDFIntegerList read FColors;

  end;

  TQPLPatternType = (ptUnknown, ptAxial, ptRadial, ptColorTile);
  TQPLPDFPatternType = (ptNone, ptTiling, ptShading);

  TQPLPatternModel = (pmUnknown
{$IFDEF QPL_DPLR}
    , pmDPLR
{$ENDIF}
    );

  TQPLPattern = class
  private
    FModel: TQPLPatternModel;
    FSource: TPDFDictionary;
    FOnFindObject: TPDFFindObjectEvent;
    FOnDecrypt: TPDFCryptStreamEvent;
    FOnEncrypt: TPDFCryptStreamEvent;
    FPatternType: TQPLPatternType;
    FPDFPatternType: TQPLPDFPatternType;
    FPatternMatrix: array[0..5] of Double;
    FColorManager: TPDFColorManager;
    FTileImageData: TStream;
    FDecodeStream: AnsiString;

    // Axial shading
    FCoords: array[0..5] of Double;
    FDomain: array[0..3] of Double;
    FExtend: array[0..1] of Boolean;
    FRGBList: array of array[0..2] of Double;

    // Tiling
    FBBox: array[0..3] of Double;
    FXStep: Double;
    FYStep: Double;
    FTileScale: Double;

    // DPLR renderer
{$IFDEF QPL_DPLR}
    FShadingType: Integer;
    FPDFFunction: TPDFFunction;
    FBackColor: TPDFRGBColor;
    FDeviceNColorSpace: TPDFDeviceNColorSpace;
    FDeviceNColor: TPDFDeviceNColor;
    FSeparationColorSpace: TPDFSeparationColorSpace;
    FColorComponents: Integer;
    FBitsPerCoordinate: Integer;
    FBitsPerComponent: Integer;
    FBitsPerFlag: Integer;
    FVerticesPerRow: Integer;
    FDecodeArray: array of Double;
    FBackgroundArray: TPDFDoubleArray;
    FTilingType: Integer;
    FPaintType: Integer;
    FTileRenderBuf : PByte;
    FShadingMatrix: array[0..5] of Double;
    FTileWidth: Integer;
    FTileHeight: Integer;
    FUncoloredPatternColor: Integer;
    FUncoloredPatternCS: AnsiString;

    procedure ReadDPLRShadingDict(SourceDict: TPDFDictionary);
{$ENDIF}

    procedure ReadShadingDict(SourceDict: TPDFDictionary);
    procedure ReadTilingDict(SourceDict: TPDFDictionary; SourceStream: TPDFStream);
    function FindObject(Ref: TPDFIndRef): TPDFObject;
  public
    constructor Create(ColorManager: TPDFColorManager);
    destructor Destroy; override;
    procedure Populate(Source: TPDFDictionary; Stream: TPDFStream = nil; StreamRef: TPDFIndRef = nil);
    function GetCoords(Index: Integer): Double;
    function GetRGBCount: Integer;
    function GetRGB(Part, Index: Integer): Double;
    function GetMatrix(Index: Integer): Double;
    function GetExtend(Index: Integer): Boolean;
    function GetBBox(Index: Integer): Double;
    function GetStep(Index: Integer): Double;
    property SourceDict: TPDFDictionary read FSource;
    property PatternType: TQPLPatternType read FPatternType;
    property PDFPatternType: TQPLPDFPatternType read FPDFPatternType write FPDFPatternType;
    property TileImageData: TStream read FTileImageData;
    property TileScale: Double read FTileScale write FTileScale;
    property OnFindObject: TPDFFindObjectEvent read FOnFindObject write FOnFindObject;
    property OnDecrypt: TPDFCryptStreamEvent read FOnDecrypt write FOnDecrypt;
    property OnEncrypt: TPDFCryptStreamEvent read FOnEncrypt write FOnEncrypt;
    property ColorManager: TPDFColorManager read FColorManager;
    property Model: TQPLPatternModel read FModel;
    procedure SetColorComponents(const AltColorSpace: AnsiString; Colors: array of Double);
{$IFDEF QPL_DPLR}
    procedure UseRendererModel();
    function GetDomain(Index: Integer): Double;
    function GetColor(FunctionOutput: TPDFDoubleArray): TPDFRGBColor;
    function GetFunctionColor(FunctionInput: TPDFDoubleArray): TPDFRGBColor;
    property ShadingType: Integer read FShadingType;
    property PDFFunction: TPDFFunction read FPDFFunction;
    property BackColor: TPDFRGBColor read FBackColor;
    property ColorComponents: Integer read FColorComponents;
    property BitsPerCoordinate: Integer read FBitsPerCoordinate;
    property BitsPerComponent: Integer read FBitsPerComponent;
    property BitsPerFlag: Integer read FBitsPerFlag;
    property VerticesPerRow: Integer read FVerticesPerRow;
    function GetDecodeArray(): PDouble;
    function GetDecodeLength(): Integer;
    property SourceStream: AnsiString read FDecodeStream;
    function HasBackColor(): Boolean;
    function GetTilingType(): Integer;
    function GetPaintType(): Integer;
    property TileRenderBuf: PByte read FTileRenderBuf write FTileRenderBuf;
    function GetShadingMatrix(Index: Integer): Double;
    property TileWidth: Integer read FTileWidth write FTileWidth;
    property TileHeight: Integer read FTileHeight write FTileHeight;
    property UncoloredPatternColor: Integer read FUncoloredPatternColor write FUncoloredPatternColor;
    property UncoloredPatternCS: AnsiString read FUncoloredPatternCS write FUncoloredPatternCS;
{$ENDIF}
  end;

PTQPLPattern = ^TQPLPattern;

implementation


{ TPDFPattern }

constructor TPDFPattern.Create(AStructure: TPDFStructure;
  const AName: AnsiString);
begin
  FStructure := AStructure;
  FName := AName;
  FMatrix.eM11 := 1;
  FMatrix.eM12 := 0;
  FMatrix.eM21 := 0;
  FMatrix.eM22 := 1;
  FMatrix.eDx := 0;
  FMatrix.eDy := 0;
  FPatternType := 1;
  FPaintType := 1;
  FTilingType := 1;
  FBBox.Left := 0;
  FBBox.Top := 0;
  FBBox.Right := 0;
  FBBox.Bottom := 0;
  FXStep := 0;
  FYStep := 0;
  FFilter := '';
  FStream := '';
  FColors := TQuickPDFIntegerList.Create;
end;

function TPDFPattern.GetInlineStream(BM: TBitmap): AnsiString;
var
  W: Integer;
  H: Integer;
  X: Integer;
  Y: Integer;
  DataStream: AnsiString;
  RowData: array of Byte;
  T: Byte;
begin
  BM.PixelFormat := pf24bit;

  W := BM.Width;
  H := BM.Height;

  SetLength(DataStream, W * H * 3);
  SetLength(RowData, W * 3);

  for Y := 0 to H - 1 do
  begin
    Move(BM.ScanLine[Y]^, RowData[0], W * 3);
    for X := 0 to W - 1 do
    begin
      T := RowData[X * 3];
      RowData[X * 3] := RowData[X * 3 + 2];
      RowData[X * 3 + 2] := T;
    end;
    Move(RowData[0], DataStream[Y * W * 3 + 1], W * 3);
  end;

  Result := DeflateStr(DataStream)
end;

function TPDFPattern.SetBWToColor(Bitmap: TBitmap; BColor, WColor: TColor): TBitmap;
var
  X, Y: Integer;
  P: PRGBTriple;
begin
  Bitmap.PixelFormat := pf24bit;
  begin
    for Y := 0 to Bitmap.Height - 1 do
    begin
      P := Bitmap.ScanLine[Y];
      for X := 0 to Bitmap.Width - 1 do
      begin
        if (P^.rgbtRed = 0) and (P^.rgbtGreen = 0) and (P^.rgbtBlue = 0) then
        begin
          P^.rgbtRed := (BColor and $FF);
          P^.rgbtGreen := (BColor and $FF00) shr 8;
          P^.rgbtBlue := (BColor and $FF0000) shr 16;
        end else
        if (P^.rgbtRed = 255) and (P^.rgbtGreen = 255) and (P^.rgbtBlue = 255) then
        begin
          P^.rgbtRed := (WColor and $FF);
          P^.rgbtGreen := (WColor and $FF00) shr 8;
          P^.rgbtBlue := (WColor and $FF0000) shr 16;
        end;
        Inc(P);
      end;
    end;
  end;
  Result := Bitmap;
end;

function TPDFPattern.NewPatternBitmap(Bitmap: TBitmap; Color: TColor): Boolean;
var
  GenNum: Integer;
  ObjNum: Integer;
  Obj: TPDFStream;
  DataStream: AnsiString;
  TileResources: TPDFDictionary;
  H, W: Double;
  CRLF: AnsiString;
  TempBitmap: TBitmap;

  function MakeFloat(D: Double): AnsiString;
  begin
    Result := QPLDoubleToStr(D, FStructure.PDFPrecNum);
  end;

begin
  Result := True;

  TempBitmap := TBitmap.Create;
  TempBitmap.Assign(Bitmap);
  TempBitmap := SetBWToColor(TempBitmap, Color, clWhite);
  W := TempBitmap.Width;
  H := TempBitmap.Height;

  CRLF := #13#10;

  DataStream := 'q ' + CRLF +
    MakeFloat(W) + ' 0 0 ' + MakeFloat(H) + ' 0 0 cm' + CRLF +
    'BI' + CRLF +
    '/BPC 8' + CRLF +
    '/H ' + MakeFloat(H) + CRLF +
    '/W ' + MakeFloat(W) + CRLF +
    '/CS /RGB' + CRLF +
    '/F /Fl' + CRLF +
    'ID'#13;

  DataStream := DataStream + GetInlineStream(TempBitmap);
  DataStream := DataStream + CRLF + 'EI' + CRLF + 'Q' + CRLF;

  Obj := FStructure.NewStream(DataStream);
  Obj.Dictionary.Add('Type', FStructure.NewName('Pattern'));
  Obj.Dictionary.Add('PatternType', FStructure.NewNumeric(1));
  Obj.Dictionary.Add('PaintType', FStructure.NewNumeric(1));
  Obj.Dictionary.Add('TilingType', FStructure.NewNumeric(1));
  Obj.Dictionary.Add('BBox', FStructure.NewDoubleArray([0, 0, W, H]));
  Obj.Dictionary.Add('XStep', FStructure.NewNumeric(W));
  Obj.Dictionary.Add('YStep', FStructure.NewNumeric(H));
  Obj.Dictionary.Add('Matrix', FStructure.NewDoubleArray(
    [0.00072, 0, 0, 0.00072, 0, 0]));
  TileResources := TPDFDictionary(FStructure.Decode(
    '<< /ProcSet [ /PDF /Text /ImageB /ImageC /ImageI ] >>'));
  Obj.Dictionary.Add('Resources', TileResources);

  if Assigned(FStructure.OnNewIndObj) then
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, Obj);
  FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);

  TempBitmap.Free;

end;

{ TQPLPattern }

constructor TQPLPattern.Create(ColorManager: TPDFColorManager);
begin
  FModel := pmUnknown;
  FSource := nil;
  FPatternType := ptUnknown;
  FPDFPatternType := ptNone;
  FColorManager := ColorManager;
  FTileImageData := TMemoryStream.Create;
  FTileScale := 1;
{$IFDEF QPL_DPLR}
  FDecodeStream := '';
  FShadingType := 0;
  FPDFFunction := nil;
  FDeviceNColorSpace := nil;
  FSeparationColorSpace := nil;
  FColorComponents := 0;
  FBackColor.Red := 0;
  FBackColor.Green := 0;
  FBackColor.Blue := 0;
  FBitsPerCoordinate := 0;
  FBitsPerComponent := 0;
  FBitsPerFlag := 0;
  FVerticesPerRow := 0;
  FTilingType := 0;
  FPaintType := 0;
  FTileRenderBuf := nil;
  FTileWidth := 0;
  FTileHeight := 0;
{$ENDIF}
end;

destructor TQPLPattern.Destroy;
begin
{$IFDEF QPL_DPLR}
  if (Assigned(FDeviceNColorSpace)) then
    FDeviceNColorSpace.Free;
  if (Assigned(FSeparationColorSpace)) then
    FSeparationColorSpace.Free;
  if (Assigned(FPDFFunction)) then
    FPDFFunction.Free;
  if(Assigned(FTileRenderBuf)) then
    FreeMem(FTileRenderBuf);
{$ENDIF}
  if (Assigned(FTileImageData)) then
  begin
    FTileImageData.Free;
  end;
  inherited;
end;

function TQPLPattern.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

function TQPLPattern.GetBBox(Index: Integer): Double;
begin
  if ((Index >= 0) and (Index < 4)) then
  begin
    Result := FBBox[Index];
  end else
  begin
    Result := 0;
  end;
end;

function TQPLPattern.GetCoords(Index: Integer): Double;
begin
  if ((Index >= 0) and (Index < 6)) then
  begin
    Result := FCoords[Index];
  end else
  begin
    Result := 0;
  end;
end;

function TQPLPattern.GetExtend(Index: Integer): Boolean;
begin
  if ((Index >= 0) and (Index <= 1)) then
  begin
    Result := FExtend[Index];
  end else
  begin
    Result := False;
  end;
end;

function TQPLPattern.GetRGBCount: Integer;
begin
  Result := Length(FRGBList);
end;

function TQPLPattern.GetStep(Index: Integer): Double;
begin
  if (Index = 0) then
  begin
    Result := FXStep;
  end else
  if (Index = 1) then
  begin
    Result := FYStep;
  end else
  begin
    Result := 1;
  end;
end;

function TQPLPattern.GetMatrix(Index: Integer): Double;
begin
  if ((Index >= 0) and (Index < 6)) then
  begin
    Result := FPatternMatrix[Index];
  end else
  begin
    Result := 0;
  end;
end;

function TQPLPattern.GetRGB(Part, Index: Integer): Double;
begin
  if ((Part >= 0) and (Part < Length(FRGBList)) and (Index >= 0) and (Index < 3)) then
  begin
    Result := FRGBList[Part][Index];
  end else
  begin
    Result := 0;
  end;
end;

procedure TQPLPattern.Populate(Source: TPDFDictionary; Stream: TPDFStream; StreamRef: TPDFIndRef);
var
  Obj: TPDFObject;
  PatternDict: TPDFDictionary;
  MatrixArray: TPDFArray;
  X: Integer;
begin
  FSource := Source;
  FDecodeStream := '';
  if Assigned(Stream) then
  begin
    if (Assigned(StreamRef)) then
    begin
      if Assigned(FOnDecrypt) then
      begin
        FOnDecrypt(Stream, StreamRef);
      end;
    end;
    FDecodeStream := Stream.GetDecodedStream();
    if (Assigned(StreamRef)) then
    begin
      if Assigned(FOnEncrypt) then
      begin
        FOnEncrypt(Stream, StreamRef);
      end;
    end;
  end;
  FPatternType := ptUnknown;
  if (Assigned(Source)) then
  begin
    PatternDict := Source;

    // The default pattern matrix
    FPatternMatrix[0] := 1;
    FPatternMatrix[1] := 0;
    FPatternMatrix[2] := 0;
    FPatternMatrix[3] := 1;
    FPatternMatrix[4] := 0;
    FPatternMatrix[5] := 0;

    // Get the pattern matrix if it exists
    Obj := PatternDict.FindValueByKeyName('Matrix');
    if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
    if (Obj is TPDFArray) then
    begin
      MatrixArray := TPDFArray(Obj);
      if ((MatrixArray.Count = 6) and MatrixArray.AllItemsNumeric) then
      begin
        for X := 0 to 5 do
        begin
          FPatternMatrix[X] := TPDFNumeric(MatrixArray.Item[X]).AsDouble;
        end;
      end;
    end;

    // Get the PDF pattern type
    Obj := PatternDict.FindValueByKeyName('PatternType');
    if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
    if (Obj is TPDFNumeric) then
    begin
      FPDFPatternType := TQPLPDFPatternType(TPDFNumeric(Obj).AsInteger);
      if (FPDFPatternType = ptTiling) then
      begin
        // We have a tiling pattern
        ReadTilingDict(Source, Stream);
      end else
      if (FPDFPatternType = ptShading) then
      begin
        // We have a shading pattern
        Obj := PatternDict.FindValueByKeyName('Shading');
        if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
{$IFDEF QPL_DPLR}
        if (FModel = pmDPLR) then
        begin
          if (Obj is TPDFDictionary) then
          begin
            ReadDPLRShadingDict(TPDFDictionary(Obj));
          end else
          if (Obj is TPDFStream) then
          begin
            FDecodeStream := TPDFStream(Obj).GetDecodedStream();
            ReadDPLRShadingDict(TPDFStream(Obj).Dictionary);
          end;
        end else
{$ENDIF}
        if (Obj is TPDFDictionary) then
        begin
          ReadShadingDict(TPDFDictionary(Obj));
        end else
        if (Obj is TPDFStream) then
        begin
          FDecodeStream := TPDFStream(Obj).GetDecodedStream();
          ReadShadingDict(TPDFStream(Obj).Dictionary);
        end;
      end;
    end else
    begin
      // A pattern was not found, check if this is a direct shading pattern
      Obj := PatternDict.FindValueByKeyName('ShadingType');
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFNumeric) then
      begin
        FPDFPatternType := ptShading;
{$IFDEF QPL_DPLR}
        if (FModel = pmDPLR) then
        begin
          // The default pattern matrix is shading matrix
          FPatternMatrix[0] := 1;
          FPatternMatrix[1] := 0;
          FPatternMatrix[2] := 0;
          FPatternMatrix[3] := 1;
          FPatternMatrix[4] := 0;
          FPatternMatrix[5] := 0;
          ReadDPLRShadingDict(PatternDict);
        end else
{$ENDIF}
        begin
          ReadShadingDict(PatternDict);
        end;
      end;
    end;
  end;
end;

procedure TQPLPattern.ReadShadingDict(SourceDict: TPDFDictionary);
var
  PDFShadingType: Integer;
  Obj: TPDFObject;
  X: Integer;
  TempArray: TPDFArray;
  ValidTempArrayCount: Integer;
  PDFFunction: TPDFFunction;
  FunctionInput: TPDFDoubleArray;
  FunctionOutput: TPDFDoubleArray;
  ValidColorSpace: Boolean;
  ColorComponents: Integer;
  CSArray: TPDFArray;
  ValidFunction: Boolean;
  StepCount: Integer;
  IsCMY: Boolean;
  CMYKColor: TPDFCMYKColor;
  DeviceNColorSpace: TPDFDeviceNColorSpace;
  DeviceNColor: TPDFDeviceNColor;
  SeparationColorSpace: TPDFSeparationColorSpace;
  RGBColor: TPDFRGBColor;
  ICCStream: TPDFStream;
  ComponentIndex: Integer;
  StreamRef: TPDFIndRef;
begin
  DeviceNColorSpace := nil;
  SeparationColorSpace := nil;

  // Get the PDF shading type
  Obj := SourceDict.FindValueByKeyName('ShadingType');
  if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
  if (Obj is TPDFNumeric) then
  begin
    PDFShadingType := TPDFNumeric(Obj).AsInteger;
    if (PDFShadingType = 2) then
    begin
      // This is an Axial shading dictionary

      // DeviceRGB, DeviceCMYK, DeviceN, Separation and certain
      // ICCBased color spaces are supported
      Obj := SourceDict.FindValueByKeyName('ColorSpace', False);
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));

      IsCMY := False;
      ColorComponents := 0;
      ValidColorSpace := False;

      if (Obj is TPDFName) then
      begin
        if (TPDFName(Obj).Name = 'DeviceRGB') then
        begin
          ColorComponents := 3;
          ValidColorSpace := True;
        end;
        if (TPDFName(Obj).Name = 'DeviceCMYK') then
        begin
          ColorComponents := 4;
          ValidColorSpace := True;
        end;
      end;

      if (Obj is TPDFArray) then
      begin
        CSArray := TPDFArray(Obj);
        if ((CSArray.Count >= 2) and (CSArray.Item[0] is TPDFName)) then
        begin
          if (TPDFName(CSArray.Item[0]).Name = 'DeviceN') then
          begin
            DeviceNColorSpace := TPDFDeviceNColorSpace.Create(FColorManager);
            DeviceNColorSpace.OnFindObject := FOnFindObject;
            DeviceNColorSpace.LoadFromArray(CSArray, '');
            ValidColorSpace := True;
            ColorComponents := DeviceNColorSpace.ComponentCount;
          end else
          if (TPDFName(CSArray.Item[0]).Name = 'ICCBased') then
          begin
            // Look for a compatible /ICCBased color space
            Obj := CSArray.Item[1];
            if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
            if (Obj is TPDFStream) then
            begin
              ICCStream := TPDFStream(Obj);
              Obj := ICCStream.Dictionary.FindValueByKeyName('Alternate');
              if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
              if (Obj is TPDFName) then
              begin
                if (TPDFName(Obj).Name = 'DeviceRGB') then
                begin
                  ColorComponents := 3;
                  ValidColorSpace := True;
                end;
                if (TPDFName(Obj).Name = 'DeviceCMYK') then
                begin
                  ColorComponents := 4;
                  ValidColorSpace := True;
                end;
              end else
              if (not Assigned(Obj)) then
              begin
                Obj := ICCStream.Dictionary.FindValueByKeyName('N');
                if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
                if (Obj is TPDFNumeric) then
                begin
                  if (TPDFNumeric(Obj).AsInteger = 3) then
                  begin
                    ColorComponents := 3;
                    ValidColorSpace := True;
                  end;
                end;
              end;
            end;
          end else
          if (TPDFName(CSArray.Item[0]).Name = 'Separation') then
          begin
            SeparationColorSpace := TPDFSeparationColorSpace.Create(FColorManager);
            SeparationColorSpace.OnFindObject := FOnFindObject;
            SeparationColorSpace.LoadFromArray(CSArray, '');
            ColorComponents := 1;
            ValidColorSpace := True;
          end else
          if (TPDFName(CSArray.Item[0]).Name = 'CalRGB') then
          begin
            ColorComponents := 3;
            ValidColorSpace := True;
          end;
        end;
      end;

      if (ValidColorSpace) then
      begin
        ValidTempArrayCount := 4;

        // Read the /Coords array
        Obj := SourceDict.FindValueByKeyName('Coords', False);
        if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
        if (Obj is TPDFArray) then
        begin
          TempArray := TPDFArray(Obj);
          if (TempArray.Count = 4) then
          begin
            ValidTempArrayCount := 0;
            for X := 0 to 3 do
            begin
              Obj := TempArray.Item[X];
              if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
              if (Obj is TPDFNumeric) then
              begin
                Inc(ValidTempArrayCount);
                FCoords[X] := TPDFNumeric(Obj).AsDouble;
              end;
            end;
          end;
        end;

        if (ValidTempArrayCount = 4) then
        begin
          // The default /Domain entry is [ 0.0 1.0 ]
          FDomain[0] := 0;
          FDomain[1] := 1;

          // Read the domain limits if they are specified
          Obj := SourceDict.FindValueByKeyName('Domain', False);
          if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
          if (Obj is TPDFArray) then
          begin
            TempArray := TPDFArray(Obj);
            if (TempArray.AllItemsNumeric and (TempArray.Count = 2)) then
            begin
              for X := 0 to 1 do
              begin
                Obj := TempArray.Item[X];
                if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
                if (Obj is TPDFNumeric) then
                begin
                  FDomain[X] := TPDFNumeric(Obj).AsDouble;
                end;
              end;
            end;
          end;

          // The default /Extend entry is [ false false ]
          FExtend[0] := False;
          FExtend[1] := False;

          // Read the /Extend entry if it exists
          Obj := SourceDict.FindValueByKeyName('Extend', False);
          if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
          if (Obj is TPDFArray) then
          begin
            TempArray := TPDFArray(Obj);
            if (TempArray.Count = 2) then
            begin
              Obj := TempArray.Item[0];
              if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
              if (Obj is TPDFBoolean) then
              begin
                FExtend[0] := TPDFBoolean(Obj).AsBoolean;
                Obj := TempArray.Item[1];
                if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
                if (Obj is TPDFBoolean) then
                begin
                  FExtend[1] := TPDFBoolean(Obj).AsBoolean;
                end;
              end;
            end;
          end;

          // Read the /Function entry
          Obj := SourceDict.FindValueByKeyName('Function', False);
          if (Obj is TPDFIndRef) then
          begin
            StreamRef := TPDFIndRef(Obj);
            Obj := FindObject(TPDFIndRef(Obj));
          end else
          begin
            StreamRef := nil;
          end;

          PDFFunction := nil;
          if (Obj is TPDFDictionary) then
          begin
            PDFFunction := TPDFFunction.FunctionFactory(TPDFDictionary(Obj), FOnFindObject);
          end else
          if (Obj is TPDFStream) then
          begin
            if (Assigned(FOnDecrypt)) then
            begin
              FOnDecrypt(TPDFStream(Obj), StreamRef);
            end;
            PDFFunction := TPDFFunction.FunctionFactory(TPDFStream(Obj), FOnFindObject);
            if (Assigned(FOnEncrypt)) then
            begin
              FOnEncrypt(TPDFStream(Obj), StreamRef);
            end;
          end;

          if (Assigned(PDFFunction)) then
          begin
            // Function should map a single value to three values (RGB) or
            // four values (CMYK)
            SetLength(FunctionInput, 1);
            ValidFunction := False;

            // Some functions don't know the output size at first, so run the function once
            // to check the output size
            if ((PDFFunction.InputValueCount = 1) and (PDFFunction.OutputValueCount = 0)) then
            begin
              SetLength(FunctionInput, 1);
              FunctionInput[0] := 0;
              PDFFunction.RunFunction(FunctionInput, FunctionOutput);
              ValidFunction := Length(FunctionOutput) = ColorComponents;
            end;

            if ((PDFFunction.InputValueCount = 1) and (PDFFunction.OutputValueCount = ColorComponents)) then
            begin
              ValidFunction := True;
            end;

            if (ValidFunction) then
            begin
              // We have everything we need so the pattern type can be set
              FPatternType := ptAxial;

              SetLength(FRGBList, PDFFunction.Steps);
              for StepCount := 0 to Length(FRGBList) - 1 do
              begin
                FunctionInput[0] := StepCount / (Length(FRGBList) - 1);
                PDFFunction.RunFunction(FunctionInput, FunctionOutput);
                if (Assigned(DeviceNColorSpace)) then
                begin
                  SetLength(DeviceNColor, DeviceNColorSpace.ComponentCount);
                  for ComponentIndex := 0 to DeviceNColorSpace.ComponentCount - 1 do
                  begin
                    DeviceNColor[ComponentIndex] := FunctionOutput[ComponentIndex];
                  end;
                  DeviceNColorSpace.GetColor(DeviceNColor);
                  FRGBList[StepCount][0] := (DeviceNColorSpace.ResultColor and $FF) / 255;
                  FRGBList[StepCount][1] := ((DeviceNColorSpace.ResultColor and $FF00) shr 8) / 255;
                  FRGBList[StepCount][2] := ((DeviceNColorSpace.ResultColor and $FF0000) shr 16) / 255;
                end else
                if (Assigned(SeparationColorSpace)) then
                begin
                  SeparationColorSpace.GetColor(FunctionOutput[0]);
                  FRGBList[StepCount][0] := (SeparationColorSpace.ResultColor and $FF) / 255;
                  FRGBList[StepCount][1] := ((SeparationColorSpace.ResultColor and $FF00) shr 8) / 255;
                  FRGBList[StepCount][2] := ((SeparationColorSpace.ResultColor and $FF0000) shr 16) / 255;
                end else
                if ((ColorComponents = 3) and (not IsCMY)) then
                begin
                  FRGBList[StepCount][0] := FunctionOutput[0];
                  FRGBList[StepCount][1] := FunctionOutput[1];
                  FRGBList[StepCount][2] := FunctionOutput[2];
                end else
                if ((ColorComponents = 3) and IsCMY) then
                begin
                  CMYKColor.Cyan := FunctionOutput[0];
                  CMYKColor.Magenta := FunctionOutput[1];
                  CMYKColor.Yellow := FunctionOutput[2];
                  CMYKColor.Black := 0;
                  RGBColor := FColorManager.CMYK2RGB(CMYKColor);
                  FRGBList[StepCount][0] := RGBColor.Red;
                  FRGBList[StepCount][1] := RGBColor.Green;
                  FRGBList[StepCount][2] := RGBColor.Blue;
                end else
                if (ColorComponents = 4) then
                begin
                  CMYKColor.Cyan := FunctionOutput[0];
                  CMYKColor.Magenta := FunctionOutput[1];
                  CMYKColor.Yellow := FunctionOutput[2];
                  CMYKColor.Black := FunctionOutput[3];
                  RGBColor := FColorManager.CMYK2RGB(CMYKColor);
                  FRGBList[StepCount][0] := RGBColor.Red;
                  FRGBList[StepCount][1] := RGBColor.Green;
                  FRGBList[StepCount][2] := RGBColor.Blue;
                end else
                if (ColorComponents = 1) then
                begin
                  CMYKColor.Cyan := FunctionOutput[0];
                  CMYKColor.Magenta := FunctionOutput[0];
                  CMYKColor.Yellow := FunctionOutput[0];
                  CMYKColor.Black := FunctionOutput[0];
                  RGBColor := FColorManager.CMYK2RGB(CMYKColor);
                  FRGBList[StepCount][0] := RGBColor.Red;
                  FRGBList[StepCount][1] := RGBColor.Green;
                  FRGBList[StepCount][2] := RGBColor.Blue;
                end;
              end;
            end;
            PDFFunction.Free;
          end;
        end;
      end;
    end;
  end;

  if (Assigned(DeviceNColorSpace)) then
  begin
    DeviceNColorSpace.Free;
  end;

  if (Assigned(SeparationColorSpace)) then
  begin
    SeparationColorSpace.Free;
  end;
end;

procedure TQPLPattern.ReadTilingDict(SourceDict: TPDFDictionary; SourceStream: TPDFStream);
var
  Obj: TPDFObject;
  PDFTilingType: Integer;
  TempArray: TPDFArray;
  ValidTempArrayCount: Integer;
  X: Integer;
  TempValue: Double;
begin
  // Get the PDF tiling type
  Obj := SourceDict.FindValueByKeyName('TilingType');
  if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
  if (Obj is TPDFNumeric) then
  begin
    PDFTilingType := TPDFNumeric(Obj).AsInteger;
    if ((PDFTilingType = 1) or (PDFTilingType = 2) or (PDFTilingType = 3)) then
    begin
{$IFDEF QPL_DPLR}
      FTilingType := PDFTilingType;
      Obj := SourceDict.FindValueByKeyName('PaintType');
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFNumeric) then
      begin
        FPaintType := TPDFNumeric(Obj).AsInteger;
      end;
{$ENDIF}
      // Read the /BBox array
      Obj := SourceDict.FindValueByKeyName('BBox', False);
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFArray) then
      begin
        TempArray := TPDFArray(Obj);
        ValidTempArrayCount := 0;
        if (TempArray.Count = 4) then
        begin
          for X := 0 to 3 do
          begin
            Obj := TempArray.Item[X];
            if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
            if (Obj is TPDFNumeric) then
            begin
              Inc(ValidTempArrayCount);
              FBBox[X] := TPDFNumeric(Obj).AsDouble;
            end;
          end;
        end;

        if (ValidTempArrayCount = 4) then
        begin
          FPatternType := ptColorTile;

          if (FBBox[0] > FBBox[2]) then
          begin
            TempValue := FBBox[0];
            FBBox[0] := FBBox[2];
            FBBox[2] := TempValue;
          end;
          if (FBBox[1] > FBBox[3]) then
          begin
            TempValue := FBBox[1];
            FBBox[1] := FBBox[3];
            FBBox[3] := TempValue;
          end;

          // Read the /XStep and /YStep values
          Obj := SourceDict.FindValueByKeyName('XStep', False);
          if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
          if (Obj is TPDFNumeric) then
          begin
            FXStep := TPDFNumeric(Obj).AsDouble;
          end else
          begin
            FXStep := FBBox[2] - FBBox[0];
          end;
          Obj := SourceDict.FindValueByKeyName('YStep', False);
          if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
          if (Obj is TPDFNumeric) then
          begin
            FYStep := TPDFNumeric(Obj).AsDouble;
          end else
          begin
            FXStep := FBBox[3] - FBBox[1];
          end;

        end;
      end;
    end;
  end;
end;

procedure TQPLPattern.SetColorComponents(const AltColorSpace: AnsiString;
  Colors: array of Double);
{$IFDEF QPL_DPLR}
var
  K: Double;
  RGB: TPDFRGBColor;
  CMYK: TPDFCMYKColor;
{$ENDIF}
begin
{$IFDEF QPL_DPLR}
  UncoloredPatternCS := AltColorSpace;
  if AltColorSpace = 'DeviceRGB' then
  begin
    RGB.Blue := Colors[2];
    RGB.Green := Colors[1];
    RGB.Red := Colors[0];
    UncoloredPatternColor := FColorManager.RGB2Color(RGB);
  end else
  if AltColorSpace = 'DeviceCMYK' then
  begin
    CMYK.Black := Colors[3];
    CMYK.Yellow := Colors[2];
    CMYK.Magenta := Colors[1];
    CMYK.Cyan := Colors[0];
    RGB := FColorManager.CMYK2RGB(CMYK);
    UncoloredPatternColor := FColorManager.RGB2Color(RGB);

    //GS.FillColorCMYK := CMYK;
  end else
   if AltColorSpace = 'DeviceGray' then
  begin
    K := Colors[0];
    UncoloredPatternColor := Round(K * 255) shl 16 +
      Round(K * 255) shl 8 + Round(K * 255);
  end;
{$ENDIF}
end;

{$IFDEF QPL_DPLR}
procedure TQPLPattern.UseRendererModel();
begin
  FModel := pmDPLR;
end;

function TQPLPattern.GetDomain(Index: Integer): Double;
begin
  if ((Index >= 0) and (Index < 4)) then
  begin
    Result := FDomain[Index];
  end else
  begin
    Result := 0;
  end;
end;

function TQPLPattern.GetDecodeArray(): PDouble;
begin
  if Length(FDecodeArray) = 0 then
    Result := nil
  else
    Result := PDouble(FDecodeArray);
end;

function TQPLPattern.GetDecodeLength(): Integer;
begin
  Result := Length(FDecodeArray);
end;

function TQPLPattern.HasBackColor(): Boolean;
begin
  Result := (Length(FBackgroundArray) > 0);
end;

function TQPLPattern.GetShadingMatrix(Index: Integer): Double;
begin
  if ((Index >= 0) and (Index < 6)) then
  begin
    Result := FShadingMatrix[Index];
  end else
  begin
    Result := 0;
  end;
end;

procedure TQPLPattern.ReadDPLRShadingDict(SourceDict: TPDFDictionary);
var
  Obj: TPDFObject;
  X: Integer;
  TempArray: TPDFArray;
  ValidColorSpace: Boolean;
  CSArray: TPDFArray;
  MatrixArray: TPDFArray;
  //ValidFunction: Boolean;
  ICCStream: TPDFStream;
begin
  // Get the PDF shading type
  Obj := SourceDict.FindValueByKeyName('ShadingType');
  if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
  if (Obj is TPDFNumeric) then
  begin
    FShadingType := TPDFNumeric(Obj).AsInteger;

    // Entries common to all shading dictionaries

    // ColorSpace
    // DeviceRGB, DeviceCMYK, DeviceN, Separation and certain
    // ICCBased color spaces are supported
    Obj := SourceDict.FindValueByKeyName('ColorSpace', False);
    if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));

    FColorComponents := 0;
    ValidColorSpace := False;

    if (Obj is TPDFName) then
    begin
      if (TPDFName(Obj).Name = 'DeviceGray') then
      begin
        FColorComponents := 1;
        ValidColorSpace := True;
      end;
      if (TPDFName(Obj).Name = 'DeviceRGB') then
      begin
        FColorComponents := 3;
        ValidColorSpace := True;
      end;
      if (TPDFName(Obj).Name = 'DeviceCMYK') then
      begin
        FColorComponents := 4;
        ValidColorSpace := True;
      end;
    end;

    if (Obj is TPDFArray) then
    begin
      CSArray := TPDFArray(Obj);
      if ((CSArray.Count >= 2) and (CSArray.Item[0] is TPDFName)) then
      begin
        if (TPDFName(CSArray.Item[0]).Name = 'DeviceN') then
        begin
          FDeviceNColorSpace := TPDFDeviceNColorSpace.Create(FColorManager);
          FDeviceNColorSpace.OnFindObject := FOnFindObject;
          FDeviceNColorSpace.LoadFromArray(CSArray, '');
          ValidColorSpace := True;
          FColorComponents := FDeviceNColorSpace.ComponentCount;
        end else
        if (TPDFName(CSArray.Item[0]).Name = 'ICCBased') then
        begin
          // Look for a compatible /ICCBased color space
          Obj := CSArray.Item[1];
          if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
          if (Obj is TPDFStream) then
          begin
            ICCStream := TPDFStream(Obj);
            Obj := ICCStream.Dictionary.FindValueByKeyName('Alternate');
            if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
            if (Obj is TPDFName) then
            begin
              if (TPDFName(Obj).Name = 'DeviceGray') then
              begin
                FColorComponents := 1;
                ValidColorSpace := True;
              end;
              if (TPDFName(Obj).Name = 'DeviceRGB') then
              begin
                FColorComponents := 3;
                ValidColorSpace := True;
              end;
              if (TPDFName(Obj).Name = 'DeviceCMYK') then
              begin
                FColorComponents := 4;
                ValidColorSpace := True;
              end;
            end else
            if (not Assigned(Obj)) then
            begin
              Obj := ICCStream.Dictionary.FindValueByKeyName('N');
              if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
              if (Obj is TPDFNumeric) then
              begin
                case TPDFNumeric(Obj).AsInteger of
                  1: begin FColorComponents := 1; ValidColorSpace := True; end;
                  3: begin FColorComponents := 3; ValidColorSpace := True; end;
                  4: begin FColorComponents := 4; ValidColorSpace := True; end;
                end;
              end;
            end;
          end;
        end else
        if (TPDFName(CSArray.Item[0]).Name = 'Separation') then
        begin
          FSeparationColorSpace := TPDFSeparationColorSpace.Create(FColorManager);
          FSeparationColorSpace.OnFindObject := FOnFindObject;
          FSeparationColorSpace.LoadFromArray(CSArray, '');
          FColorComponents := 1;
          ValidColorSpace := True;
        end else
        if (TPDFName(CSArray.Item[0]).Name = 'CalRGB') then
        begin
          FColorComponents := 3;
          ValidColorSpace := True;
        end;
      end;
    end;

    // Background color
    if (ValidColorSpace) then
    begin
      Obj := SourceDict.FindValueByKeyName('Background', False);
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFArray) then
      begin
        TempArray := TPDFArray(Obj);
        SetLength(FBackgroundArray, TempArray.Count);
        if (TempArray.Count = FColorComponents) then
        begin
          for X := 0 to FColorComponents-1 do
          begin
            Obj := TempArray.Item[X];
            if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
            if (Obj is TPDFNumeric) then
            begin
              FBackgroundArray[X] := TPDFNumeric(Obj).AsDouble;
            end;
          end;
        end;
        // convert to FBackColor
        FBackColor :=  GetColor(FBackgroundArray);
      end;
    end;

    // BBox
    FBBox[0] := 0;
    FBBox[1] := 0;
    FBBox[2] := -1;
    FBBox[3] := -1;
    Obj := SourceDict.FindValueByKeyName('BBox', False);
    if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
    if (Obj is TPDFArray) then
    begin
      TempArray := TPDFArray(Obj);
      if (TempArray.Count = 4) then
      begin
        for X := 0 to 3 do
        begin
          Obj := TempArray.Item[X];
          if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
          if (Obj is TPDFNumeric) then
          begin
            FBBox[X] := TPDFNumeric(Obj).AsDouble;
          end;
        end;
      end;
    end;

    // Get the shading matrix if it exists
    FShadingMatrix[0] := 1;
    FShadingMatrix[1] := 0;
    FShadingMatrix[2] := 0;
    FShadingMatrix[3] := 1;
    FShadingMatrix[4] := 0;
    FShadingMatrix[5] := 0;
    Obj := SourceDict.FindValueByKeyName('Matrix');
    if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
    if (Obj is TPDFArray) then
    begin
      MatrixArray := TPDFArray(Obj);
      if ((MatrixArray.Count = 6) and MatrixArray.AllItemsNumeric) then
      begin
        for X := 0 to 5 do
        begin
          FShadingMatrix[X] := TPDFNumeric(MatrixArray.Item[X]).AsDouble;
        end;
      end;
    end;

    // Domain
    FDomain[0] := 0;
    FDomain[1] := 1;
    FDomain[2] := 0;
    FDomain[3] := 1;
    if (FShadingType = 1) or (FShadingType = 2) or (FShadingType = 3) then
    begin
      // Read the domain limits if they are specified
      Obj := SourceDict.FindValueByKeyName('Domain', False);
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFArray) then
      begin
        TempArray := TPDFArray(Obj);
        if (TempArray.AllItemsNumeric and (TempArray.Count <= 4)) then
        begin
          for X := 0 to TempArray.Count-1 do
          begin
            Obj := TempArray.Item[X];
            if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
            if (Obj is TPDFNumeric) then
            begin
              FDomain[X] := TPDFNumeric(Obj).AsDouble;
            end;
          end;
        end;
      end;
    end;

    // Coords
    FCoords[0] := 0;
    FCoords[1] := 0;
    FCoords[2] := 0;
    FCoords[3] := 0;
    FCoords[4] := 0;
    FCoords[5] := 0;
    if (FShadingType = 2) or (FShadingType = 3) then
    begin
      Obj := SourceDict.FindValueByKeyName('Coords', False);
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFArray) then
      begin
        TempArray := TPDFArray(Obj);
        if (TempArray.AllItemsNumeric and (TempArray.Count <= 6)) then
        begin
          for X := 0 to TempArray.Count-1 do
          begin
            Obj := TempArray.Item[X];
            if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
            if (Obj is TPDFNumeric) then
            begin
              FCoords[X] := TPDFNumeric(Obj).AsDouble;
            end;
          end;
        end;
      end;
    end;

    // Extend entry
    FExtend[0] := False;
    FExtend[1] := False;
    if (FShadingType = 2) or (FShadingType = 3) then
    begin
        Obj := SourceDict.FindValueByKeyName('Extend', False);
        if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
        if (Obj is TPDFArray) then
        begin
          TempArray := TPDFArray(Obj);
          if (TempArray.Count = 2) then
          begin
            Obj := TempArray.Item[0];
            if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
            if (Obj is TPDFBoolean) then
            begin
              FExtend[0] := TPDFBoolean(Obj).AsBoolean;
              Obj := TempArray.Item[1];
              if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
              if (Obj is TPDFBoolean) then
              begin
                FExtend[1] := TPDFBoolean(Obj).AsBoolean;
              end;
            end;
          end;
        end;
    end;

    // Function entry
    FPDFFunction := nil;
    Obj := SourceDict.FindValueByKeyName('Function', False);
    if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
    if (Obj is TPDFDictionary) then
    begin
      FPDFFunction := TPDFFunction.FunctionFactory(TPDFDictionary(Obj), FOnFindObject);
    end else
    if (Obj is TPDFStream) then
    begin
      FPDFFunction := TPDFFunction.FunctionFactory(TPDFStream(Obj), FOnFindObject);
    end;

    {  ?? check validity
    // Function should map a single value to three values (RGB) or
    // four values (CMYK)
    SetLength(FunctionInput, 1);
    ValidFunction := False;

    // Some functions don't know the output size at first, so run the function once
    // to check the output size
    if ((PDFFunction.InputValueCount = 1) and (PDFFunction.OutputValueCount = 0)) then
    begin
      SetLength(FunctionInput, 1);
      FunctionInput[0] := 0;
      PDFFunction.RunFunction(FunctionInput, FunctionOutput);
      ValidFunction := Length(FunctionOutput) = ColorComponents;
    end;

    if ((PDFFunction.InputValueCount = 1) and (PDFFunction.OutputValueCount = ColorComponents)) then
    begin
      ValidFunction := True;
    end;}

		// BitsPerCoordinate
    FBitsPerCoordinate := 0;
    if (FShadingType = 4) or (FShadingType = 5) or (FShadingType = 6) or (FShadingType = 7) then
    begin
      Obj := SourceDict.FindValueByKeyName('BitsPerCoordinate');
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFNumeric) then
      begin
        FBitsPerCoordinate := TPDFNumeric(Obj).AsInteger;
      end;
    end;

		// BitsPerComponent
    FBitsPerComponent := 0;
    if (FShadingType = 4) or (FShadingType = 5) or (FShadingType = 6) or (FShadingType = 7) then
    begin
      Obj := SourceDict.FindValueByKeyName('BitsPerComponent');
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFNumeric) then
      begin
        FBitsPerComponent := TPDFNumeric(Obj).AsInteger;
      end;
    end;

		// BitsPerFlag
    FBitsPerFlag := 0;
    if (FShadingType = 4) or (FShadingType = 6) or (FShadingType = 7) then
    begin
      Obj := SourceDict.FindValueByKeyName('BitsPerFlag');
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFNumeric) then
      begin
        FBitsPerFlag := TPDFNumeric(Obj).AsInteger;
      end;
    end;

		// VerticesPerRow
    FVerticesPerRow := 0;
    if (FShadingType = 5) then
    begin
      Obj := SourceDict.FindValueByKeyName('VerticesPerRow');
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFNumeric) then
      begin
        FVerticesPerRow := TPDFNumeric(Obj).AsInteger;
      end;
    end;

		// Decode
    SetLength(FDecodeArray, 0);
    if (FShadingType = 4) or (FShadingType = 5) or (FShadingType = 6) or (FShadingType = 7) then
    begin
      Obj := SourceDict.FindValueByKeyName('Decode', False);
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFArray) then
      begin
        TempArray := TPDFArray(Obj);
        if (TempArray.AllItemsNumeric) then
        begin
          SetLength(FDecodeArray, TempArray.Count);
          for X := 0 to TempArray.Count-1 do
          begin
            Obj := TempArray.Item[X];
            if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
            if (Obj is TPDFNumeric) then
            begin
              FDecodeArray[X] := TPDFNumeric(Obj).AsDouble;
            end;
          end;
        end;
      end;
    end;

  end;
end;

function TQPLPattern.GetColor(FunctionOutput: TPDFDoubleArray): TPDFRGBColor;
var
  CMYKColor: TPDFCMYKColor;
  ComponentIndex: Integer;
begin
  if (Assigned(FDeviceNColorSpace)) then
  begin
    SetLength(FDeviceNColor, FDeviceNColorSpace.ComponentCount);
    for ComponentIndex := 0 to FDeviceNColorSpace.ComponentCount - 1 do
    begin
      FDeviceNColor[ComponentIndex] := FunctionOutput[ComponentIndex];
    end;
    FDeviceNColorSpace.GetColor(FDeviceNColor);
    Result.Red := (FDeviceNColorSpace.ResultColor and $FF) / 255;
    Result.Green := ((FDeviceNColorSpace.ResultColor and $FF00) shr 8) / 255;
    Result.Blue := ((FDeviceNColorSpace.ResultColor and $FF0000) shr 16) / 255;
  end else
  if (Assigned(FSeparationColorSpace)) then
  begin
    FSeparationColorSpace.GetColor(FunctionOutput[0]);
    Result.Red := (FSeparationColorSpace.ResultColor and $FF) / 255;
    Result.Green := ((FSeparationColorSpace.ResultColor and $FF00) shr 8) / 255;
    Result.Blue := ((FSeparationColorSpace.ResultColor and $FF0000) shr 16) / 255;
  end else
  if (FColorComponents = 3) then
  begin
    Result.Red := FunctionOutput[0];
    Result.Green := FunctionOutput[1];
    Result.Blue := FunctionOutput[2];
  end else
  if (FColorComponents = 4) then
  begin
    if (Length(FunctionOutput) = 4) then
    begin
      CMYKColor.Cyan := FunctionOutput[0];
      CMYKColor.Magenta := FunctionOutput[1];
      CMYKColor.Yellow := FunctionOutput[2];
      CMYKColor.Black := FunctionOutput[3];
      Result := FColorManager.CMYK2RGB(CMYKColor);
    end else
    begin
      // The function did not have four outputs
      Result.Red := 0;
      Result.Green := 0;
      Result.Blue := 0;
    end;
  end else
  if (FColorComponents = 1) then
  begin
    Result.Red := FunctionOutput[0];
    Result.Green := FunctionOutput[0];
    Result.Blue := FunctionOutput[0];
    {CMYKColor.Cyan := FunctionOutput[0];
    CMYKColor.Magenta := FunctionOutput[0];
    CMYKColor.Yellow := FunctionOutput[0];
    CMYKColor.Black := FunctionOutput[0];
    Result := FColorManager.CMYK2RGB(CMYKColor); }
  end;
end;

function TQPLPattern.GetFunctionColor(FunctionInput: TPDFDoubleArray): TPDFRGBColor;
var
  X: Integer;
  FunctionOutput: TPDFDoubleArray;
begin
  if (Assigned(PDFFunction)) then
  begin
    PDFFunction.RunFunction(FunctionInput, FunctionOutput);
  end
  else if (FColorComponents > 0) then
  begin
    //X := High(FunctionInput);
    SetLength(FunctionOutput, FColorComponents);
    for X := 0 to FColorComponents-1 do
      FunctionOutput[X] := FunctionInput[X];
  end;

  Result :=  GetColor(FunctionOutput);
end;

function TQPLPattern.GetTilingType(): Integer;
begin
  Result:= FTilingType;
end;

function TQPLPattern.GetPaintType(): Integer;
begin
   Result:= FPaintType;
end;
{$ENDIF}

end.
