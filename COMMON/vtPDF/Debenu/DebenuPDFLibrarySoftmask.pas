{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibrarySoftmask.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibrarySoftmask;

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
  DebenuPDFLibraryFunctions,
  DebenuPDFLibraryColorManagement;

{$IFDEF QPL_DPLR}
{$DEFINE VER320}

 type
  TQPLSoftmaskType = (ptAlpha, ptLuminosity);

  TQPLSoftmask = class
  private
    FSource: TPDFDictionary;
    FColorManager: TPDFColorManager;
    FSoftmaskType: TQPLSoftmaskType;
    FOnFindObject: TPDFFindObjectEvent;
    FPDFFunction: TPDFFunction;
    FBCArray: array of Double;

    function FindObject(Ref: TPDFIndRef): TPDFObject;
  public
    constructor Create(ColorManager: TPDFColorManager);
    destructor Destroy; override;
    procedure Populate(Source: TPDFDictionary);

    property SourceDict: TPDFDictionary read FSource;
    property SoftmaskType: TQPLSoftmaskType read FSoftmaskType;
    property OnFindObject: TPDFFindObjectEvent read FOnFindObject write FOnFindObject;
    property ColorManager: TPDFColorManager read FColorManager;

    {$IFDEF QPL_DPLR}

    function GetFunctionValue(FunctionInput: TPDFDoubleArray): Double;
    property PDFFunction: TPDFFunction read FPDFFunction;
    function GetBCArray(Index: Integer): Double;
    function GetBCLength(): Integer;
{$ENDIF}
  end;

PTQPLSoftmask = ^TQPLSoftmask;

implementation

{ TQPLSoftmask }

constructor TQPLSoftmask.Create(ColorManager: TPDFColorManager);
begin
  FSource := nil;
  FSoftmaskType := ptAlpha;
  FColorManager := ColorManager;
  FPDFFunction := nil;
end;

destructor TQPLSoftmask.Destroy;
begin
  if (Assigned(FPDFFunction)) then
    FPDFFunction.Free;
  inherited;
end;

function TQPLSoftmask.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

procedure TQPLSoftmask.Populate(Source: TPDFDictionary);
var
  Obj: TPDFObject;
  TempArray: TPDFArray;
  X: Integer;
begin
  FSource := Source;
  FSoftmaskType := ptAlpha;
  if (Assigned(Source)) then
  begin
    // Softmask type
    Obj := SourceDict.FindValueByKeyName('S');
    if (Obj is TPDFName) then
    begin
      if (TPDFName(Obj).Name = 'Alpha') then
      begin
        FSoftmaskType := ptAlpha;
      end;
      if (TPDFName(Obj).Name = 'Luminosity') then
      begin
        FSoftmaskType := ptLuminosity;
      end;
    end;

    // An array of component values specifying the color to be used as the backdrop against which
    // to composite the transparency group XObject G. This entry is consulted only if the subtype S is Luminosity.
    // The array consists of n numbers, where n is the number of components in the color space specified by the CS entry
    // in the group attributes dictionary
    //Default value: the color space’s initial value, representing black.
    if (FSoftmaskType = ptLuminosity) then  //  (!mHaveBackdropColor)
    begin
      Obj := SourceDict.FindValueByKeyName('BC', False);
      if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
      if (Obj is TPDFArray) then
      begin
        TempArray := TPDFArray(Obj);
        SetLength(FBCArray, TempArray.Count);
        for X := 0 to TempArray.Count-1 do
        begin
          Obj := TempArray.Item[X];
          if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
          if (Obj is TPDFNumeric) then
          begin
            FBCArray[X] := TPDFNumeric(Obj).AsDouble;
          end;
        end;
      end;
    end;

    // Function entry
    FPDFFunction := nil;
    Obj := SourceDict.FindValueByKeyName('TR', False);
    if (Obj is TPDFIndRef) then Obj := FindObject(TPDFIndRef(Obj));
    if (Obj is TPDFDictionary) then
    begin
      FPDFFunction := TPDFFunction.FunctionFactory(TPDFDictionary(Obj), FOnFindObject);
      if (Assigned(FPDFFunction)) then
      begin
        if ((FPDFFunction.InputValueCount <> 1) or (FPDFFunction.OutputValueCount <> 1)) then
        begin
          FPDFFunction.Free;
          FPDFFunction := nil;
        end;
      end;
    end else
    if (Obj is TPDFStream) then
    begin
      FPDFFunction := TPDFFunction.FunctionFactory(TPDFStream(Obj), FOnFindObject);
      if (Assigned(FPDFFunction)) then
      begin
        if ((FPDFFunction.InputValueCount <> 1) or (FPDFFunction.OutputValueCount <> 1)) then
        begin
          FPDFFunction.Free;
          FPDFFunction := nil;
        end;
      end;
    end;

  end;
end;

function TQPLSoftmask.GetBCArray(Index: Integer): Double;
begin
  if ((Index >= 0) and (Index < Length(FBCArray))) then
  begin
    Result := FBCArray[Index];
  end else
  begin
    Result := 0;
  end;
end;

function TQPLSoftmask.GetBCLength(): Integer;
begin
  Result := Length(FBCArray);
end;

function TQPLSoftmask.GetFunctionValue(FunctionInput: TPDFDoubleArray): Double;
var
  FunctionOutput: TPDFDoubleArray;
begin
  if (Assigned(PDFFunction)) then
  begin
    PDFFunction.RunFunction(FunctionInput, FunctionOutput);
  end else begin
    SetLength(FunctionOutput, 1);
    FunctionOutput[0] := FunctionInput[0];
  end;
  Result := FunctionOutput[0];
end;

{$ENDIF}

end.
