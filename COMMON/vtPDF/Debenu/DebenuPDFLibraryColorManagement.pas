{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryImageDecoder.pas                       }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryColorManagement;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  Classes,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  DebenuPDFLibraryStructure, DebenuPDFLibraryFunctions, DebenuPDFLibraryTypes;

type
  // Each component ranges from 0 to 1
  TPDFCMYKColor = record
    Cyan: Double;
    Magenta: Double;
    Yellow: Double;
    Black: Double;
  end;

  // Each component ranges from 0 to 1
  TPDFRGBColor = record
    Red: Double;
    Green: Double;
    Blue: Double;
  end;

  // The L component ranges from 0 to 100
  TPDFLabColor = record
    L: Double;
    a: Double;
    b: Double;
  end;

  TPDFXYZColor = record
    X: Double;
    Y: Double;
    Z: Double;
  end;

  TPDFColorManager = class
  private
    FFixedGamma: Boolean;
  public
    function CMYK2RGB(var C: TPDFCMYKColor): TPDFRGBColor; virtual; abstract;
    function RGB2Color(var C: TPDFRGBColor): TColor; virtual; abstract;
    function Lab2RGB(var C: TPDFLabColor): TPDFRGBColor; virtual; abstract;
    property FixedGamma: Boolean read FFixedGamma write FFixedGamma;
  end;

  TPDFSimpleColorManager = class(TPDFColorManager)
  private
    WhitePoint: array[0..2] of Double;
    LabRange: array[0..3] of Double;
  public
    constructor Create;
    function SetWhitePoint(WX, WY, WZ: Double): Boolean;
    procedure SetLabRange(aMin, aMax, bMin, bMax: Double);
    function Lab2XYZ(var C: TPDFLabColor): TPDFXYZColor;
    function XYZ2RGB(var C: TPDFXYZColor): TPDFRGBColor;

    function CMYK2RGB(var C: TPDFCMYKColor): TPDFRGBColor; override;
    function RGB2Color(var C: TPDFRGBColor): TColor; override;
    function Lab2RGB(var C: TPDFLabColor): TPDFRGBColor; override;
  end;

  TPDFLabColorSpace = class
  private
    FWhitePoint: array[0..2] of Double;
    FLabRange: array[0..3] of Double;
    FOnFindObject: TPDFFindObjectEvent;
    function FindObject(Ref: TPDFIndRef): TPDFObject;
  public
    procedure LoadFromArray(Source: TPDFArray);
    function ScaleA(Input: Integer; MaxInput: Double): Double;
    function ScaleB(Input: Integer; MaxInput: Double): Double;
    function GetColor(Input: TPDFLabColor; ColorManager: TPDFColorManager): TColor;
    property OnFindObject: TPDFFindObjectEvent read
      FOnFindObject write FOnFindObject;
  end;

  TPDFSeparationColorSpace = class
  private
    FAlternate: AnsiString;
    FCMYKColor: TPDFCMYKColor;
    FRGBColor: TPDFRGBColor;
    FLabColorSpace: TPDFLabColorSpace;
    FSeparationName: AnsiString;
    FTintTransform: TPDFFunction;
    FResName: AnsiString;
{$IFDEF QPL_COLOR_CACHE}
    FResultCacheInputs: array of Double;
    FResultCacheColors: array of TColor;
    FResultCacheNames: array of AnsiString;
{$ENDIF}
    FResultColor: TColor;
    FResultName: AnsiString;
    FColorManager: TPDFColorManager;
    FOnFindObject: TPDFFindObjectEvent;
    FOnDecrypt: TPDFCryptStreamEvent;
    FOnEncrypt: TPDFCryptStreamEvent;

    function FindObject(Ref: TPDFIndRef): TPDFObject;
  public
    constructor Create(ColorManager: TPDFColorManager);
    destructor Destroy; override;
    procedure LoadFromArray(Source: TPDFArray; const AResName: AnsiString);
    procedure GetColor(Input: Double; Fast: Boolean = False);
    property ResName: AnsiString read FResName;
    property ResultColor: TColor read FResultColor;
    property ResultName: AnsiString read FResultName;
    property SeparationName: AnsiString read FSeparationName;
    property Alternate: AnsiString read FAlternate;
    property CMYKColor: TPDFCMYKColor read FCMYKColor;
    property RGBColor: TPDFRGBColor read FRGBColor;
    property OnFindObject: TPDFFindObjectEvent read
      FOnFindObject write FOnFindObject;
    property OnDecrypt: TPDFCryptStreamEvent read FOnDecrypt write FOnDecrypt;
    property OnEncrypt: TPDFCryptStreamEvent read FOnEncrypt write FOnEncrypt;
  end;

  TPDFDeviceNColor = array of Double;

  TPDFDeviceNColorSpace = class
  private
    FAlternate: AnsiString;
    FLabColorSpace: TPDFLabColorSpace;
    FColorNames: AnsiString;
    FTintTransform: TPDFFunction;
    FResName: AnsiString;
    FResultCacheInputs: array of AnsiString;
    FResultCacheColors: array of TColor;
    FResultCacheNames: array of AnsiString;
    FResultColor: TColor;
    FResultName: AnsiString;
    FColorManager: TPDFColorManager;
    FComponentCount: Integer;
    FOnFindObject: TPDFFindObjectEvent;
    FOnDecrypt: TPDFCryptStreamEvent;
    FOnEncrypt: TPDFCryptStreamEvent;
    function FindObject(Ref: TPDFIndRef): TPDFObject;
  public
    constructor Create(ColorManager: TPDFColorManager);
    destructor Destroy; override;
    procedure LoadFromArray(Source: TPDFArray; const AResName: AnsiString);
    procedure GetColor(Input: TPDFDeviceNColor; Fast: Boolean = False);
    property ResName: AnsiString read FResName;
    property ResultColor: TColor read FResultColor;
    property ResultName: AnsiString read FResultName;
    property ComponentCount: Integer read FComponentCount;
    property OnFindObject: TPDFFindObjectEvent read
      FOnFindObject write FOnFindObject;
    property OnDecrypt: TPDFCryptStreamEvent read FOnDecrypt write FOnDecrypt;
    property OnEncrypt: TPDFCryptStreamEvent read FOnEncrypt write FOnEncrypt;
    property Alternate: AnsiString read FAlternate;
  end;

  TPDFIndexedColorSpace = class
  private
    FBaseColorSpace: AnsiString;
    FHiVal: Integer;
    FColorTable: array of Byte;
    FOnFindObject: TPDFFindObjectEvent;
    function FindObject(Ref: TPDFIndRef): TPDFObject;
  public
    procedure LoadFromArray(Source: TPDFArray);
    function GetColor(Input: Byte; ColorManager: TPDFColorManager): TColor;
    property OnFindObject: TPDFFindObjectEvent read
      FOnFindObject write FOnFindObject;
    property BaseColorSpace: AnsiString read FBaseColorSpace;
  end;

function DefaultRGBProfile: TQPLByteArray;

implementation

uses
  Math, DebenuPDFLibraryExtra;

{$R DebenuPDFLibraryColorProfiles.res}

function F(D: Double): AnsiString;
begin
  Result := QPLDoubleToStr(D, 3) + ' ';
end;

{ TPDFSimpleColorManager }

function TPDFSimpleColorManager.CMYK2RGB(var C: TPDFCMYKColor): TPDFRGBColor;
var
  CC, CM, CY, CK: Double;
begin
  if FixedGamma then
  begin
    CC := C.Cyan;
    CM := C.Magenta;
    CY := C.Yellow;
    CK := C.Black;

    Result.Red := 1 - CC - 0.8627 * CK - 0.0745 * CM + 0.2549 * CC * CM +
      0.8627 * CC * CK + 0.0784 * CK * CM - 0.0275 * CK * CY + 0.0039 * CM * CY -
      0.2588 * CC * CK * CM + 0.0275 * CC * CK * CY + 0.0275 * CC * CM * CY +
      0.0157 * CK * CM * CY - 0.0471 * CC * CK * CM * CY;
    Result.Green := 1 - CM - 0.8784 * CK - 0.051*CY - 0.3216 * CC +
      0.2588 * CC * CK + 0.5138 * CC * CM + 0.8784 * CK * CM +
      0.0236 * CC * CY + 0.0314 * CK * CY + 0.1608*CM * CY -
      0.451 * CC * CK * CM + 0.0117 * CC * CK * CY - 0.1137 * CC * CM * CY -
      0.1412 * CK * CM * CY + 0.0784 * CC * CK * CM * CY;
    Result.Blue := 1 - CY - 0.8745 * CK - 0.451*CM - 0.0627 * CC +
      0.0784 * CC * CK + 0.0862 * CC * CM + 0.3255 * CK * CM + 0.5176 * CC * CY +
      0.8745 * CK * CY + 0.451*CM * CY - 0.0941 * CC * CK * CM -
      0.5333 * CC * CK * CY - 0.3176 * CC * CM * CY - 0.3255 * CK * CM * CY +
      0.3255 * CC * CK * CM * CY;
  end else
  begin
    Result.Red := (1 - Min(1, C.Cyan * (1 - C.Black) + C.Black));
    Result.Green := (1 - Min(1, C.Magenta * (1 - C.Black) + C.Black));
    Result.Blue := (1 - Min(1, C.Yellow * (1 - C.Black) + C.Black));
  end;
end;

constructor TPDFSimpleColorManager.Create;
begin
  FixedGamma := True;
  WhitePoint[0] := 0.9505;
  WhitePoint[1] := 1;
  WhitePoint[2] := 1.089;
  LabRange[0] := -128;
  LabRange[1] := 127;
  LabRange[2] := -128;
  LabRange[3] := 127;
end;

function TPDFSimpleColorManager.Lab2RGB(var C: TPDFLabColor): TPDFRGBColor;
var
  XYZColor: TPDFXYZColor;
begin
  XYZColor := Lab2XYZ(C);
  Result := XYZ2RGB(XYZColor);
end;

function TPDFSimpleColorManager.Lab2XYZ(var C: TPDFLabColor): TPDFXYZColor;
var
  LMN: array[0..2] of Double;
begin
  // Ensure components are in range
  if (C.L < 0) then C.L := 0;
  if (C.L > 100) then C.L := 100;
  if (C.a < LabRange[0]) then C.a := LabRange[0];
  if (C.a > LabRange[1]) then C.a := LabRange[1];
  if (C.b < LabRange[2]) then C.b := LabRange[2];
  if (C.b > LabRange[3]) then C.b := LabRange[3];

  // Convert (L*, a*, b*) to (L, M, N)
  LMN[1] := (C.L + 16) / 116;
  LMN[0] := LMN[1] + C.a / 500;
  LMN[2] := LMN[1] - C.b / 200;

  // Convert (L, M, N) to (X, Y, Z)
  if LMN[0] >= (6 / 29) then
  begin
    Result.X := WhitePoint[0] * Power(LMN[0], 3);
  end else
  begin
    Result.X := WhitePoint[0] * ((108 / 841) * (LMN[0] - (4 / 29)));
  end;
  if LMN[1] >= (6 / 29) then
  begin
    Result.Y := WhitePoint[1] * Power(LMN[1], 3);
  end else
  begin
    Result.Y := WhitePoint[1] * ((108 / 841) * (LMN[1] - (4 / 29)));
  end;
  if LMN[2] >= (6 / 29) then
  begin
    Result.Z := WhitePoint[2] * (Power(LMN[2], 3));
  end else
  begin
    Result.Z := WhitePoint[2] * ((108 / 841) * (LMN[2] - (4 / 29)));
  end;
end;

function TPDFSimpleColorManager.RGB2Color(var C: TPDFRGBColor): TColor;
begin
  if C.Red > 1 then C.Red := 1;
  if C.Red < 0 then C.Red := 0;
  if C.Green > 1 then C.Green := 1;
  if C.Green < 0 then C.Green := 0;
  if C.Blue > 1 then C.Blue := 1;
  if C.Blue < 0 then C.Blue := 0;
  Result := Round(C.Blue * 255) shl 16 + Round(C.Green * 255) shl 8 +
    Round(C.Red * 255);
end;

procedure TPDFSimpleColorManager.SetLabRange(aMin, aMax, bMin,
  bMax: Double);
begin
  LabRange[0] := aMin;
  LabRange[1] := aMax;
  LabRange[2] := bMin;
  LabRange[3] := bMax;
end;

function TPDFSimpleColorManager.SetWhitePoint(WX, WY, WZ: Double): Boolean;
begin
  if (WX > 0) and (WY = 1) and (WZ > 0) then
  begin
    Result := True;
    WhitePoint[0] := WX;
    WhitePoint[1] := 1;
    WhitePoint[2] := WZ;
  end else
  begin
    Result := False;
    WhitePoint[0] := 0.9505;
    WhitePoint[1] := 1;
    WhitePoint[2] := 1.089;
  end;
end;

function TPDFSimpleColorManager.XYZ2RGB(var C: TPDFXYZColor): TPDFRGBColor;
begin
  Result.Red := C.X * 2.0416 + C.Y * -0.5650 + C.Z * -0.3447;
  Result.Green := C.X * -0.9692 + C.Y * 1.8760 + C.Z * 0.0416;
  Result.Blue := C.X * 0.0134 + C.Y * -0.1184 + C.Z * 1.0152;

  if (Result.Red > 0.0031308) then
  begin
    Result.Red := 1.055 * Power(Result.Red, 1 / 2.4) - 0.055;
  end else
  begin
    Result.Red := 12.92 * Result.Red;
  end;
  if (Result.Green > 0.0031308) then
  begin
    Result.Green := 1.055 * Power(Result.Green, 1 / 2.4) - 0.055;
  end else
  begin
    Result.Green := 12.92 * Result.Green;
  end;
  if (Result.Blue > 0.0031308) then
  begin
    Result.Blue := 1.055 * Power(Result.Blue, 1 / 2.4) - 0.055;
  end else
  begin
    Result.Blue := 12.92 * Result.Blue;
  end;

  // Simple gamut correction, limit components to (0..1)
  if (Result.Red < 0) then Result.Red := 0;
  if (Result.Red > 1) then Result.Red := 1;
  if (Result.Green < 0) then Result.Green := 0;
  if (Result.Green > 1) then Result.Green := 1;
  if (Result.Blue < 0) then Result.Blue := 0;
  if (Result.Blue > 1) then Result.Blue := 1;
end;

{ TPDFLabColorSpace }

function TPDFLabColorSpace.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

function TPDFLabColorSpace.GetColor(Input: TPDFLabColor; ColorManager: TPDFColorManager): TColor;
var
  RGBColor: TPDFRGBColor;
begin
  if (ColorManager is TPDFSimpleColorManager) then
  begin
    TPDFSimpleColorManager(ColorManager).SetWhitePoint(FWhitePoint[0],
      {FWhitePoint[1]}-5, FWhitePoint[2]);
    TPDFSimpleColorManager(ColorManager).SetLabRange(FLabRange[0],
      FLabRange[1], FLabRange[2], FLabRange[3]);
  end;
  RGBColor := ColorManager.Lab2RGB(Input);
  Result := ColorManager.RGB2Color(RGBColor);
end;

procedure TPDFLabColorSpace.LoadFromArray(Source: TPDFArray);
var
  Obj: TPDFObject;
  LabDict: TPDFDictionary;
begin
  if (Source.Count >= 2) then
  begin
    Obj := Source.Item[1];
    if (Obj is TPDFIndRef) then
    begin
      Obj := FindObject(TPDFIndRef(Obj));
    end;
    if Obj is TPDFDictionary then
    begin
      LabDict := TPDFDictionary(Obj);
      Obj := LabDict.FindValueByKeyName('WhitePoint');
      if (Obj is TPDFIndRef) then
      begin
        Obj := FindObject(TPDFIndRef(Obj));
      end;
      if (Obj is TPDFArray) then
      begin
        if (TPDFArray(Obj).Count = 3) and TPDFArray(Obj).AllItemsNumeric then
        begin
          FWhitePoint[0] := TPDFNumeric(TPDFArray(Obj).Item[0]).AsDouble;
          FWhitePoint[1] := TPDFNumeric(TPDFArray(Obj).Item[1]).AsDouble;
          FWhitePoint[2] := TPDFNumeric(TPDFArray(Obj).Item[2]).AsDouble;
        end;
      end;
      FLabRange[0] := -100;
      FLabRange[1] := 100;
      FLabRange[2] := -100;
      FLabRange[3] := 100;
      Obj := LabDict.FindValueByKeyName('Range');
      if (Obj is TPDFIndRef) then
      begin
        Obj := FindObject(TPDFIndRef(Obj));
      end;
      if (Obj is TPDFArray) then
      begin
        if (TPDFArray(Obj).Count = 4) and TPDFArray(Obj).AllItemsNumeric then
        begin
          FLabRange[0] := TPDFNumeric(TPDFArray(Obj).Item[0]).AsDouble;
          FLabRange[1] := TPDFNumeric(TPDFArray(Obj).Item[1]).AsDouble;
          FLabRange[2] := TPDFNumeric(TPDFArray(Obj).Item[2]).AsDouble;
          FLabRange[3] := TPDFNumeric(TPDFArray(Obj).Item[3]).AsDouble;
        end;
      end;
    end;
  end;
end;

function TPDFLabColorSpace.ScaleA(Input: Integer; MaxInput: Double): Double;
begin
  Result := ((Input * (FLabRange[1] - FLabRange[0])) / MaxInput) + FLabRange[0];
end;

function TPDFLabColorSpace.ScaleB(Input: Integer; MaxInput: Double): Double;
begin
  Result := ((Input * (FLabRange[3] - FLabRange[2])) / MaxInput) + FLabRange[2];
end;

{ TPDFSeparationColorSpace }

procedure TPDFSeparationColorSpace.LoadFromArray(Source: TPDFArray; const AResName: AnsiString);
var
  Obj: TPDFObject;
  AltArray: TPDFArray;
  ICCStream: TPDFStream;
  O: TPDFObject;
  IR: TPDFIndRef;
begin
  FResName := AResName;
  FAlternate := '';
  FSeparationName := '';
  FTintTransform := nil;
  if Source.Count >= 2 then
  begin
    Obj := Source.Item[1];
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFName then
      FSeparationName := TPDFName(Obj).Name;
  end;
  if Source.Count >= 3 then
  begin
    Obj := Source.Item[2];
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFName then
      FAlternate := TPDFName(Obj).Name;
    if Obj is TPDFArray then
    begin
      AltArray := TPDFArray(Obj);
      if (AltArray.Count > 0) and (AltArray.Item[0] is TPDFName) then
        FAlternate := TPDFName(AltArray.Item[0]).Name;
      if (FAlternate = 'ICCBased') and (AltArray.Count > 1) then
      begin
        Obj := AltArray.Item[1];
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFStream then
        begin
          ICCStream := TPDFStream(Obj);
          Obj := ICCStream.Dictionary.FindValueByKeyName('Alternate');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFName then
          begin
            FAlternate := TPDFName(Obj).Name;
          end else
          begin
            Obj := ICCStream.Dictionary.FindValueByKeyName('N');
            if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
            if Obj is TPDFNumeric then
            begin
              case TPDFNumeric(Obj).AsInteger of
                1: FAlternate := 'DeviceGray';
                3: FAlternate := 'DeviceRGB';
                4: FAlternate := 'DeviceCMYK';
              end;
            end;
          end;
        end;
      end else
      if ((FAlternate = 'Lab') and (AltArray.Count >= 2)) then
      begin
        FLabColorSpace := TPDFLabColorSpace.Create;
        FLabColorSpace.OnFindObject := FOnFindObject;
        FLabColorSpace.LoadFromArray(AltArray);
      end;
    end;
  end;
  if Source.Count >= 4 then
  begin
    IR := Nil;
    O := Source.Item[3];
    if O is TPDFIndRef then
    begin
      IR := TPDFIndRef(O);
      O := FindObject(IR);
    end;
    if O is TPDFStream then
    begin
    if Assigned(FOnDecrypt) and Assigned(IR) then
      FOnDecrypt(TPDFStream(O), IR);

    FTintTransform := TPDFFunction.FunctionFactory(O, FOnFindObject);

    if Assigned(FOnEncrypt) and Assigned(IR) then
      FOnEncrypt(TPDFStream(O), IR);
    end
    else
    if (O is TPDFDictionary) then
      FTintTransform := TPDFFunction.FunctionFactory(O, FOnFindObject);

  end;
end;

function TPDFSeparationColorSpace.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

procedure TPDFSeparationColorSpace.GetColor(Input: Double; Fast: Boolean = False);
var
  CR: Double; // Red
  CG: Double; // Green
  CB: Double; // Blue
  CC: Double; // Cyan
  CM: Double; // Magenta
  CY: Double; // Yellow
  CK: Double; // Black
  CLab: TPDFLabColor;
  X: TPDFDoubleArray;
  Y: TPDFDoubleArray;
{$IFDEF QPL_COLOR_CACHE}
  CX: Integer;
  Found: Boolean;
{$ENDIF}
begin
{$IFDEF QPL_COLOR_CACHE}
  CX := 0;
  Found := False;
  while (CX < Length(FResultCacheInputs)) and (not Found) do
  begin
    if FResultCacheInputs[CX] = Input then
    begin
      Found := True;
      FResultColor := FResultCacheColors[CX];
      FResultName := FResultCacheNames[CX];
    end else
      Inc(CX);
  end;
  if not Found then
{$ENDIF}
  begin
    FResultColor := clBlack;
    FResultName := '0.5 setgray';
    if Assigned(FTintTransform) and (FTintTransform.InputValueCount = 1) then
    begin
      if (FTintTransform.OutputValueCount = 4) and (FAlternate = 'DeviceCMYK') then
      begin
        SetLength(X, 1);
        SetLength(Y, 4);
        X[0] := Input;
        FTintTransform.RunFunction(X, Y);

        FCMYKColor.Cyan := Y[0];
        FCMYKColor.Magenta := Y[1];
        FCMYKColor.Yellow := Y[2];
        FCMYKColor.Black := Y[3];

        FRGBColor := FColorManager.CMYK2RGB(FCMYKColor);
        FResultColor := FColorManager.RGB2Color(FRGBColor);

        if (not Fast) then
        begin
          X[0] := 1;
          FTintTransform.RunFunction(X, Y);
          CC := Y[0];
          CM := Y[1];
          CY := Y[2];
          CK := Y[3];
          FResultName := F(CC) + F(CM) + F(CY) + F(CK) + '(' + FSeparationName + ') ' +
            'findcmykcustomcolor ' + F(Input) + 'setcustomcolor';
        end;
      end else
      if (FTintTransform.OutputValueCount = 3) and
        ((FAlternate = 'DeviceRGB') or (FAlternate = 'CalRGB') or (FAlternate = 'ICCBased')) then
      begin
        SetLength(X, 1);
        SetLength(Y, 3);
        X[0] := Input;
        FTintTransform.RunFunction(X, Y);
        CR := Y[0];
        CG := Y[1];
        CB := Y[2];
        FResultColor := Round(CB * 255) shl 16 +
          Round(CG * 255) shl 8 + Round(CR * 255);
        if (not Fast) then
        begin
          FResultName := F(CR) + F(CG) + F(CB) + 'setrgbcolor';
        end;
      end else
      if ((FTintTransform.OutputValueCount = 3) and (FAlternate = 'Lab')) then
      begin
        SetLength(X, 1);
        SetLength(Y, 3);
        X[0] := Input;
        FTintTransform.RunFunction(X, Y);

        CLab.L := Y[0];
        CLab.a := Y[1];
        CLab.b := Y[2];

        FRGBColor := FColorManager.Lab2RGB(CLab);

        FResultColor := FColorManager.RGB2Color(FRGBColor);
        if (not Fast) then
        begin
          FResultName := F(RGBColor.Red) + F(RGBColor.Green) + F(RGBColor.Blue) + 'setrgbcolor';
        end;
      end else
      if ((FTintTransform.OutputValueCount = 1) and (FAlternate = 'DeviceGray')) then
      begin
        SetLength(X, 1);
        SetLength(Y, 1);
        X[0] := Input;
        FTintTransform.RunFunction(X, Y);

        CR := Y[0];
        CG := Y[0];
        CB := Y[0];

        FResultColor := Round(CB * 255) shl 16 +
          Round(CG * 255) shl 8 + Round(CR * 255);
        if (not Fast) then
        begin
          FResultName := F(CR) + F(CG) + F(CB) + 'setrgbcolor';
        end;
      end;
    end;
{$IFDEF QPL_COLOR_CACHE}
    CX := Length(FResultCacheInputs);
    SetLength(FResultCacheInputs, CX + 1);
    SetLength(FResultCacheColors, CX + 1);
    SetLength(FResultCacheNames, CX + 1);
    FResultCacheInputs[CX] := Input;
    FResultCacheColors[CX] := FResultColor;
    FResultCacheNames[CX] := FResultName;
{$ENDIF}
  end;
end;

destructor TPDFSeparationColorSpace.Destroy;
begin
  if Assigned(FTintTransform) then FTintTransform.Free;
  if Assigned(FLabColorSpace) then
  begin
    FLabColorSpace.Free;
  end;
  inherited;
end;

constructor TPDFSeparationColorSpace.Create(ColorManager: TPDFColorManager);
begin
  FColorManager := ColorManager;
end;

{ TPDFDeviceNColorSpace }

procedure TPDFDeviceNColorSpace.LoadFromArray(Source: TPDFArray; const AResName: AnsiString);
var
  O, Obj: TPDFObject;
  IR: TPDFIndRef;
  AltArray: TPDFArray;
  ICCStream: TPDFStream;
  NamesArray: TPDFArray;
  NameIndex: Integer;
begin
  FResName := AResName;
  FAlternate := '';
  FColorNames := '';
  FTintTransform := nil;
  if Source.Count >= 2 then
  begin
    Obj := Source.Item[1];
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFArray then
    begin
      FColorNames := '[';
      NamesArray := TPDFArray(Obj);
      FComponentCount := NamesArray.Count;
      for NameIndex := 0 to NamesArray.Count - 1 do
      begin
        Obj := NamesArray.Item[NameIndex];
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFName then
        begin
          FColorNames := FColorNames + TPDFName(Obj).Name;
          if (NameIndex < (NamesArray.Count - 1)) then
          begin
            FColorNames := FColorNames + ',';
          end;
        end;
      end;
      FColorNames := FColorNames + ']';
    end;
  end;
  if Source.Count >= 3 then
  begin
    Obj := Source.Item[2];
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFName then
      FAlternate := TPDFName(Obj).Name;
    if Obj is TPDFArray then
    begin
      AltArray := TPDFArray(Obj);
      if (AltArray.Count > 0) and (AltArray.Item[0] is TPDFName) then
        FAlternate := TPDFName(AltArray.Item[0]).Name;
      if (FAlternate = 'ICCBased') and (AltArray.Count > 1) then
      begin
        Obj := AltArray.Item[1];
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFStream then
        begin
          ICCStream := TPDFStream(Obj);
          Obj := ICCStream.Dictionary.FindValueByKeyName('Alternate');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFName then
          begin
            FAlternate := TPDFName(Obj).Name;
          end else
          begin
            Obj := ICCStream.Dictionary.FindValueByKeyName('N');
            if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
            if Obj is TPDFNumeric then
            begin
              case TPDFNumeric(Obj).AsInteger of
                1: FAlternate := 'DeviceGray';
                3: FAlternate := 'DeviceRGB';
                4: FAlternate := 'DeviceCMYK';
              end;
            end;
          end;
        end;
      end else
      if ((FAlternate = 'Lab') and (AltArray.Count >= 2)) then
      begin
        FLabColorSpace := TPDFLabColorSpace.Create;
        FLabColorSpace.OnFindObject := FOnFindObject;
        FLabColorSpace.LoadFromArray(AltArray);
      end;
    end;
  end;
  if Source.Count >= 4 then
  begin
    IR := Nil;
    O := Source.Item[3];
    if O is TPDFIndRef then
    begin
      IR := TPDFIndRef(O);
      O := FindObject(IR);
    end;
    if O is TPDFStream then
    begin
    if Assigned(FOnDecrypt) and Assigned(IR) then
      FOnDecrypt(TPDFStream(O), IR);

    FTintTransform := TPDFFunction.FunctionFactory(O, FOnFindObject);

    if Assigned(FOnEncrypt) and Assigned(IR) then
      FOnEncrypt(TPDFStream(O), IR);
    end
    else if (O is TPDFDictionary) then
      FTintTransform := TPDFFunction.FunctionFactory(O, FOnFindObject);

  end;
end;

function TPDFDeviceNColorSpace.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

procedure TPDFDeviceNColorSpace.GetColor(Input: TPDFDeviceNColor; Fast: Boolean = False);
var
  CR: Double; // Red
  CG: Double; // Green
  CB: Double; // Blue
  CC: Double; // Cyan
  CM: Double; // Magenta
  CY: Double; // Yellow
  CK: Double; // Black
  CLab: TPDFLabColor;
  RGBColor: TPDFRGBColor;
  CMYKColor: TPDFCMYKColor;
  X: TPDFDoubleArray;
  Y: TPDFDoubleArray;
  CX: Integer;
  Found: Boolean;
  InputSearch: AnsiString;
  ComponentIndex: Integer;
  UseCache: Boolean;
begin
  CX := 0;
  Found := False;

  UseCache := Length(Input) <= 1;

  InputSearch := '';
  for ComponentIndex := 0 to Length(Input) - 1 do
  begin
    InputSearch := InputSearch + F(Input[ComponentIndex]);
  end;

  while (UseCache) and (CX < Length(FResultCacheInputs)) and (not Found) do
  begin
    if FResultCacheInputs[CX] = InputSearch then
    begin
      Found := True;
      FResultColor := FResultCacheColors[CX];
      FResultName := FResultCacheNames[CX];
    end else
      Inc(CX);
  end;
  if not Found then
  begin
    FResultColor := clBlack;
    FResultName := '0.5 setgray';
    if Assigned(FTintTransform) and (FTintTransform.InputValueCount = Length(Input)) then
    begin
      if (FTintTransform.OutputValueCount = 4) and (FAlternate = 'DeviceCMYK') then
      begin
        SetLength(X, Length(Input));
        SetLength(Y, 4);
        for ComponentIndex := 0 to Length(Input) - 1 do
        begin
          X[ComponentIndex] := Input[ComponentIndex];
        end;
        FTintTransform.RunFunction(X, Y);
        CMYKColor.Cyan := Y[0];
        CMYKColor.Magenta := Y[1];
        CMYKColor.Yellow := Y[2];
        CMYKColor.Black := Y[3];
        RGBColor := FColorManager.CMYK2RGB(CMYKColor);
        FResultColor := FColorManager.RGB2Color(RGBColor);

        if (not Fast) then
        begin
          CC := Y[0];
          CM := Y[1];
          CY := Y[2];
          CK := Y[3];
          FResultName := F(CC) + F(CM) + F(CY) + F(CK) + '(' + FColorNames + ') ' +
            'findcmykcustomcolor ';
          for ComponentIndex := 0 to Length(Input) - 1 do
          begin
            FResultName := FResultName + F(Input[ComponentIndex]);
          end;
          FResultName := FResultName + 'setcustomcolor';
        end;
      end else
      if (FTintTransform.OutputValueCount = 3) and
        ((FAlternate = 'DeviceRGB') or (FAlternate = 'CalRGB') or (FAlternate = 'ICCBased')) then
      begin
        SetLength(X, Length(Input));
        SetLength(Y, 3);
        for ComponentIndex := 0 to Length(Input) - 1 do
        begin
          X[ComponentIndex] := Input[ComponentIndex];
        end;
        FTintTransform.RunFunction(X, Y);
        CR := Y[0];
        CG := Y[1];
        CB := Y[2];
        FResultColor := Round(CB * 255) shl 16 +
          Round(CG * 255) shl 8 + Round(CR * 255);
        if (not Fast) then
        begin
          FResultName := F(CR) + F(CG) + F(CB) + 'setrgbcolor';
        end;
      end else
      if ((FTintTransform.OutputValueCount = 3) and (FAlternate = 'Lab')) then
      begin
        SetLength(X, Length(Input));
        SetLength(Y, 3);
        for ComponentIndex := 0 to Length(Input) - 1 do
        begin
          X[ComponentIndex] := Input[ComponentIndex];
        end;
        FTintTransform.RunFunction(X, Y);

        CLab.L := Y[0];
        CLab.a := Y[1];
        CLab.b := Y[2];

        RGBColor := FColorManager.Lab2RGB(CLab);

        FResultColor := FColorManager.RGB2Color(RGBColor);
        if (not Fast) then
        begin
          FResultName := F(RGBColor.Red) + F(RGBColor.Green) + F(RGBColor.Blue) + 'setrgbcolor';
        end;
      end;
    end;

    if (UseCache) then
    begin
      CX := Length(FResultCacheInputs);
      if (CX > 1000) then
      begin
        CX := 0;
      end;
      SetLength(FResultCacheInputs, CX + 1);
      SetLength(FResultCacheColors, CX + 1);
      SetLength(FResultCacheNames, CX + 1);
      FResultCacheInputs[CX] := InputSearch;
      FResultCacheColors[CX] := FResultColor;
      if (not Fast) then FResultCacheNames[CX] := FResultName;
    end;
  end;
end;

destructor TPDFDeviceNColorSpace.Destroy;
begin
  if Assigned(FTintTransform) then FTintTransform.Free;
  if Assigned(FLabColorSpace) then
  begin
    FLabColorSpace.Free;
  end;
  inherited;
end;

constructor TPDFDeviceNColorSpace.Create(ColorManager: TPDFColorManager);
begin
  FColorManager := ColorManager;
  FComponentCount := 0;
end;

function DefaultRGBProfile: TQPLByteArray;
var
  ResourceStream: TResourceStream;
  MS: TMemoryStream;
  ResID: Integer;
begin
  ResID := 12101;
  MS := TMemoryStream.Create;
  try
{$IFNDEF QPL_CPP}
    ResourceStream := TResourceStream.CreateFromID(HInstance, ResID, RT_RCDATA);
    try
      SetLength(Result, ResourceStream.Size);
      if (Length(Result) > 0) then
      begin
        ResourceStream.Read(Result[0], Length(Result));
      end;
    finally
      ResourceStream.Free;
    end;
{$ENDIF}
  finally
    MS.Free;
  end;
end;

{ TPDFIndexedColorSpace }

function TPDFIndexedColorSpace.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

function TPDFIndexedColorSpace.GetColor(Input: Byte;
  ColorManager: TPDFColorManager): TColor;
var
  Components: Integer;
  Values: array of Byte;
  CMYKColor: TPDFCMYKColor;
  RGBColor: TPDFRGBColor;
begin
  Result := $FFFFFF;
  if (Input <= FHiVal) then
  begin
    if ((FBaseColorSpace = 'DeviceRGB') or (FBaseColorSpace = 'CalRGB')) then
    begin
      Components := 3;
    end else
    if (FBaseColorSpace = 'DeviceCMYK') then
    begin
      Components := 4;
    end else
    begin
      Components := 0;
    end;
    if (Components > 0) then
    begin
      SetLength(Values, Components);
      Move(FColorTable[Input * Components], Values[0], Components);
    end;
  end;
  if ((FBaseColorSpace = 'DeviceRGB') or (FBaseColorSpace = 'CalRGB')) then
  begin
    Result := Values[0] + Values[1] shl 8 + Values[2] shl 16;
  end else
  if (FBaseColorSpace = 'DeviceCMYK') then
  begin
    CMYKColor.Cyan := Values[0] / 255;
    CMYKColor.Magenta := Values[1] / 255;
    CMYKColor.Yellow := Values[2] / 255;
    CMYKColor.Black := Values[3] / 255;
    RGBColor := ColorManager.CMYK2RGB(CMYKColor);
    Result := ColorManager.RGB2Color(RGBColor);
  end;
end;

procedure TPDFIndexedColorSpace.LoadFromArray(Source: TPDFArray);
var
  Obj: TPDFObject;
  BaseArray: TPDFArray;
  AnsiColorTable: AnsiString;
begin
  FBaseColorSpace := '';
  if (Source.Count >= 4) then
  begin
    Obj := Source.Item[1];
    if (Obj is TPDFIndRef) then
    begin
      Obj := FindObject(TPDFIndRef(Obj));
    end;
    if (Obj is TPDFName) then
    begin
      FBaseColorSpace := TPDFName(Obj).Name;
    end else
    if (Obj is TPDFArray) then
    begin
      BaseArray := TPDFArray(Obj);
      if (BaseArray.Count > 0) then
      begin
        if (BaseArray.Item[0] is TPDFName) then
        begin
          FBaseColorSpace := TPDFName(BaseArray.Item[0]).Name;
        end;
      end;
    end;

    Obj := Source.Item[2];
    if (Obj is TPDFIndRef) then
    begin
      Obj := FindObject(TPDFIndRef(Obj));
    end;
    if (Obj is TPDFNumeric) then
    begin
      FHiVal := TPDFNumeric(Obj).AsInteger;
    end;

    Obj := Source.Item[3];
    if (Obj is TPDFIndRef) then
    begin
      Obj := FindObject(TPDFIndRef(Obj));
    end;
    if (Obj is TPDFStream) then
    begin
      AnsiColorTable := TPDFStream(Obj).GetDecodedStream;
      SetLength(FColorTable, Length(AnsiColorTable));
      if (Length(FColorTable) > 0) then
      begin
        Move(AnsiColorTable[1], FColorTable[0], Length(FColorTable));
      end;
    end else
    if (Obj is TPDFString) then
    begin
      AnsiColorTable := TPDFString(Obj).AsString;
      SetLength(FColorTable, Length(AnsiColorTable));
      if (Length(FColorTable) > 0) then
      begin
        Move(AnsiColorTable[1], FColorTable[0], Length(FColorTable));
      end;
    end;
  end;
end;

end.
