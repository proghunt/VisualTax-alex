{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryGeospatial.pas                         }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryGeospatial;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  DebenuPDFLibraryDocument, DebenuPDFLibraryStructure;

type
  TQuickPDFMeasureDict = class
  private
    Dict: TPDFDictionary;
    Structure: TPDFStructure;
  public
    constructor Create(MeasureDict: TPDFDictionary; Structure: TPDFStructure);
    function SetCoordinateSystem(CoordinateSystemID: Integer): Boolean;
    function GetCoordinateSystem: Integer;
    function SetBoundsCount(NewCount: Integer): Boolean;
    function GetBoundsCount: Integer;
    function GetBoundsItem(ItemIndex: Integer): Double;
    function SetBoundsItem(ItemIndex: Integer; NewValue: Double): Boolean;
    function SetPDU(LinearUnit, AreaUnit, AngularUnit: Integer): Boolean;
    function GetPDU(UnitIndex: Integer): Integer;
    function GetGCSDict: TPDFDictionary;
    function GetDCSDict: TPDFDictionary;
    function SetGPTSCount(NewCount: Integer): Boolean;
    function GetGPTSCount: Integer;
    function SetGPTSItem(ItemIndex: Integer; NewValue: Double): Boolean;
    function GetGPTSItem(ItemIndex: Integer): Double;
    function SetLPTSCount(NewCount: Integer): Boolean;
    function GetLPTSCount: Integer;
    function SetLPTSItem(ItemIndex: Integer; NewValue: Double): Boolean;
    function GetLPTSItem(ItemIndex: Integer): Double;
  end;

  TQuickPDFCoordinateSystemDict = class
  private
    Dict: TPDFDictionary;
    Structure: TPDFStructure;
  public
    constructor Create(CSDict: TPDFDictionary; Structure: TPDFStructure);
    function GetEPSG: Integer;
    function SetEPSG(NewEPSG: Integer): Boolean;
    function GetWKT: WideString;
    function SetWKT(const NewWKT: WideString): Boolean;
    function GetDictType: Integer;
    function SetDictType(NewDictType: Integer): Boolean;
  end;

implementation

{ TQuickPDFMeasureDict }

constructor TQuickPDFMeasureDict.Create(MeasureDict: TPDFDictionary; Structure: TPDFStructure);
begin
  Dict := MeasureDict;
  Self.Structure := Structure;
end;

function TQuickPDFMeasureDict.GetBoundsCount: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('Bounds', True);
    if (Obj is TPDFArray) then
    begin
      Result := TPDFArray(Obj).Count;
    end;
  end;
end;

function TQuickPDFMeasureDict.GetBoundsItem(ItemIndex: Integer): Double;
var
  Obj: TPDFObject;
begin
  Result := 0;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('Bounds', True);
    if (Obj is TPDFArray) then
    begin
      if ((ItemIndex >= 0) and (ItemIndex < TPDFArray(Obj).Count)) then
      begin
        Obj := TPDFArray(Obj).Item[ItemIndex];
        if (Obj is TPDFNumeric) then
        begin
          Result := TPDFNumeric(Obj).AsDouble;
        end;
      end;
    end;
  end;
end;

function TQuickPDFMeasureDict.GetCoordinateSystem: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('Subtype', True);
    if (Obj is TPDFName) then
    begin
      if (TPDFName(Obj).Name = 'RL') then
      begin
        Result := 1;
      end else
      if (TPDFName(Obj).Name = 'GEO') then
      begin
        Result := 2;
      end;
    end;
  end;
end;

function TQuickPDFMeasureDict.GetDCSDict: TPDFDictionary;
var
  Obj: TPDFObject;
begin
  Result := nil;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('DCS', True);
    if (Obj is TPDFDictionary) then
    begin
      Result := TPDFDictionary(Obj);
    end else
    begin
      Result := Structure.NewDictionary;
      Dict.Add('DCS', Result);
    end;
  end;
end;

function TQuickPDFMeasureDict.GetGCSDict: TPDFDictionary;
var
  Obj: TPDFObject;
begin
  Result := nil;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('GCS', True);
    if (Obj is TPDFDictionary) then
    begin
      Result := TPDFDictionary(Obj);
    end else
    begin
      Result := Structure.NewDictionary;
      Dict.Add('GCS', Result);
    end;
  end;
end;

function TQuickPDFMeasureDict.GetGPTSCount: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('GPTS', True);
    if (Obj is TPDFArray) then
    begin
      Result := TPDFArray(Obj).Count;
    end;
  end;
end;

function TQuickPDFMeasureDict.GetGPTSItem(ItemIndex: Integer): Double;
var
  Obj: TPDFObject;
begin
  Result := 0;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('GPTS', True);
    if (Obj is TPDFArray) then
    begin
      if ((ItemIndex >= 0) and (ItemIndex < TPDFArray(Obj).Count)) then
      begin
        Obj := TPDFArray(Obj).Item[ItemIndex];
        if (Obj is TPDFNumeric) then
        begin
          Result := TPDFNumeric(Obj).AsDouble;
        end;
      end;
    end;
  end;
end;

function TQuickPDFMeasureDict.GetLPTSCount: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('LPTS', True);
    if (Obj is TPDFArray) then
    begin
      Result := TPDFArray(Obj).Count;
    end;
  end;
end;

function TQuickPDFMeasureDict.GetLPTSItem(ItemIndex: Integer): Double;
var
  Obj: TPDFObject;
begin
  Result := 0;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('LPTS', True);
    if (Obj is TPDFArray) then
    begin
      if ((ItemIndex >= 0) and (ItemIndex < TPDFArray(Obj).Count)) then
      begin
        Obj := TPDFArray(Obj).Item[ItemIndex];
        if (Obj is TPDFNumeric) then
        begin
          Result := TPDFNumeric(Obj).AsDouble;
        end;
      end;
    end;
  end;
end;

function TQuickPDFMeasureDict.GetPDU(UnitIndex: Integer): Integer;
var
  Obj: TPDFObject;
  PDUArray: TPDFArray;
  NameValue: AnsiString;
begin
  Result := 0;
  if ((UnitIndex >= 0) and (UnitIndex <= 2) and Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('PDU', True);
    if (Obj is TPDFArray) then
    begin
      PDUArray := TPDFArray(Obj);
      if (PDUArray.Count = 3) then
      begin
        if (PDUArray.Item[UnitIndex] is TPDFName) then
        begin
          NameValue := TPDFName(PDUArray.Item[UnitIndex]).Name;
          if (UnitIndex = 0) then
          begin
            if (NameValue = 'M') then Result := 1;
            if (NameValue = 'KM') then Result := 2;
            if (NameValue = 'FT') then Result := 3;
            if (NameValue = 'USFT') then Result := 4;
            if (NameValue = 'MI') then Result := 5;
            if (NameValue = 'NM') then Result := 6;
          end else
          if (UnitIndex = 1) then
          begin
            if (NameValue = 'SQM') then Result := 1;
            if (NameValue = 'HA') then Result := 2;
            if (NameValue = 'SQKM') then Result := 3;
            if (NameValue = 'SQFT') then Result := 4;
            if (NameValue = 'A') then Result := 5;
            if (NameValue = 'SQMI') then Result := 6;
          end else
          if (UnitIndex = 2) then
          begin
            if (NameValue = 'DEG') then Result := 1;
            if (NameValue = 'GRD') then Result := 2;
          end;
        end;
      end;
    end;
  end;
end;

function TQuickPDFMeasureDict.SetBoundsCount(NewCount: Integer): Boolean;
var
  Obj: TPDFObject;
  BoundsArray: TPDFArray;
begin
  Result := False;
  if (Assigned(Dict)) then
  begin
    Result := True;
    BoundsArray := nil;
    Obj := Dict.FindValueByKeyName('Bounds', True);
    if (Obj is TPDFArray) then
    begin
      BoundsArray := TPDFArray(Obj);
      if (not BoundsArray.AllItemsNumeric) then
      begin
        BoundsArray := nil;
      end;
    end;
    if (not Assigned(BoundsArray)) then
    begin
      BoundsArray := Structure.NewArray;
      Dict.Add('Bounds', BoundsArray);
    end;
    while (BoundsArray.Count > NewCount) do
    begin
      BoundsArray.Delete(BoundsArray.Count - 1);
    end;
    while (BoundsArray.Count < NewCount) do
    begin
      BoundsArray.Add(Structure.NewNumeric(0));
    end;
  end;
end;

function TQuickPDFMeasureDict.SetBoundsItem(ItemIndex: Integer;
  NewValue: Double): Boolean;
var
  Obj: TPDFObject;
  BoundsArray: TPDFArray;
begin
  Result := False;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('Bounds', True);
    if (Obj is TPDFArray) then
    begin
      BoundsArray := TPDFArray(Obj);
      if ((ItemIndex >= 0) and (ItemIndex < BoundsArray.Count)) then
      begin
        Obj := BoundsArray.Item[ItemIndex];
        if (Obj is TPDFNumeric) then
        begin
          TPDFNumeric(Obj).SetTo(NewValue);
          Result := True;
        end else
        begin
          BoundsArray.Replace(ItemIndex, Structure.NewNumeric(NewValue));
        end;
      end;
    end;
  end;
end;

function TQuickPDFMeasureDict.SetCoordinateSystem(CoordinateSystemID: Integer): Boolean;
begin
  Result := False;
  if (Assigned(Dict)) then
  begin
    if (CoordinateSystemID = 1) then
    begin
      Dict.Add('Subtype', Structure.NewName('RL'));
      Result := True;
    end else
    begin
      Dict.Add('Subtype', Structure.NewName('GEO'));
      Result := True;
    end;
  end;
end;

function TQuickPDFMeasureDict.SetGPTSCount(NewCount: Integer): Boolean;
var
  Obj: TPDFObject;
  BoundsArray: TPDFArray;
begin
  Result := False;
  if (Assigned(Dict)) then
  begin
    Result := True;
    BoundsArray := nil;
    Obj := Dict.FindValueByKeyName('GPTS', True);
    if (Obj is TPDFArray) then
    begin
      BoundsArray := TPDFArray(Obj);
      if (not BoundsArray.AllItemsNumeric) then
      begin
        BoundsArray := nil;
      end;
    end;
    if (not Assigned(BoundsArray)) then
    begin
      BoundsArray := Structure.NewArray;
      Dict.Add('GPTS', BoundsArray);
    end;
    while (BoundsArray.Count > NewCount) do
    begin
      BoundsArray.Delete(BoundsArray.Count - 1);
    end;
    while (BoundsArray.Count < NewCount) do
    begin
      BoundsArray.Add(Structure.NewNumeric(0));
    end;
  end;
end;

function TQuickPDFMeasureDict.SetGPTSItem(ItemIndex: Integer;
  NewValue: Double): Boolean;
var
  Obj: TPDFObject;
  BoundsArray: TPDFArray;
begin
  Result := False;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('GPTS', True);
    if (Obj is TPDFArray) then
    begin
      BoundsArray := TPDFArray(Obj);
      if ((ItemIndex >= 0) and (ItemIndex < BoundsArray.Count)) then
      begin
        Obj := BoundsArray.Item[ItemIndex];
        if (Obj is TPDFNumeric) then
        begin
          TPDFNumeric(Obj).SetTo(NewValue);
          Result := True;
        end else
        begin
          BoundsArray.Replace(ItemIndex, Structure.NewNumeric(NewValue));
        end;
      end;
    end;
  end;
end;

function TQuickPDFMeasureDict.SetLPTSCount(NewCount: Integer): Boolean;
var
  Obj: TPDFObject;
  BoundsArray: TPDFArray;
begin
  Result := False;
  if (Assigned(Dict)) then
  begin
    Result := True;
    BoundsArray := nil;
    Obj := Dict.FindValueByKeyName('LPTS', True);
    if (Obj is TPDFArray) then
    begin
      BoundsArray := TPDFArray(Obj);
      if (not BoundsArray.AllItemsNumeric) then
      begin
        BoundsArray := nil;
      end;
    end;
    if (not Assigned(BoundsArray)) then
    begin
      BoundsArray := Structure.NewArray;
      Dict.Add('LPTS', BoundsArray);
    end;
    while (BoundsArray.Count > NewCount) do
    begin
      BoundsArray.Delete(BoundsArray.Count - 1);
    end;
    while (BoundsArray.Count < NewCount) do
    begin
      BoundsArray.Add(Structure.NewNumeric(0));
    end;
  end;
end;

function TQuickPDFMeasureDict.SetLPTSItem(ItemIndex: Integer;
  NewValue: Double): Boolean;
var
  Obj: TPDFObject;
  BoundsArray: TPDFArray;
begin
  Result := False;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('LPTS', True);
    if (Obj is TPDFArray) then
    begin
      BoundsArray := TPDFArray(Obj);
      if ((ItemIndex >= 0) and (ItemIndex < BoundsArray.Count)) then
      begin
        Obj := BoundsArray.Item[ItemIndex];
        if (Obj is TPDFNumeric) then
        begin
          TPDFNumeric(Obj).SetTo(NewValue);
          Result := True;
        end else
        begin
          BoundsArray.Replace(ItemIndex, Structure.NewNumeric(NewValue));
        end;
      end;
    end;
  end;
end;

function TQuickPDFMeasureDict.SetPDU(LinearUnit, AreaUnit,
  AngularUnit: Integer): Boolean;
var
  Obj: TPDFObject;
  PDUArray: TPDFArray;
begin
  Result := False;
  if ((LinearUnit >= 1) and (LinearUnit <= 6) and (AreaUnit >= 1) and
    (AreaUnit <= 6) and (AngularUnit >= 1) and (AngularUnit <= 2) and
    Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('PDU', True);
    Result := True;
    if (Obj is TPDFArray) then
    begin
      PDUArray := TPDFArray(Obj);
      if (PDUArray.Count <> 3) then
      begin
        PDUArray := nil;
      end else
      begin
        if ((not (PDUArray.Item[0] is TPDFName)) or
          (not (PDUArray.Item[1] is TPDFName)) or
          (not (PDUArray.Item[2] is TPDFName))) then
        begin
          PDUArray := nil;
        end;
      end;
    end else
    begin
      PDUArray := nil;
    end;
    if (not Assigned(PDUArray)) then
    begin
      PDUArray := Structure.NewArray([Structure.NewName('M'),
        Structure.NewName('SQM'), Structure.NewName('DEG')]);
    end;
    case LinearUnit of
      1: TPDFName(PDUArray.Item[0]).SetTo('M');
      2: TPDFName(PDUArray.Item[0]).SetTo('KM');
      3: TPDFName(PDUArray.Item[0]).SetTo('FT');
      4: TPDFName(PDUArray.Item[0]).SetTo('USFT');
      5: TPDFName(PDUArray.Item[0]).SetTo('MI');
      6: TPDFName(PDUArray.Item[0]).SetTo('NM');
    end;
    case AreaUnit of
      1: TPDFName(PDUArray.Item[1]).SetTo('SQM');
      2: TPDFName(PDUArray.Item[1]).SetTo('HA');
      3: TPDFName(PDUArray.Item[1]).SetTo('SQKM');
      4: TPDFName(PDUArray.Item[1]).SetTo('SQFT');
      5: TPDFName(PDUArray.Item[1]).SetTo('A');
      6: TPDFName(PDUArray.Item[1]).SetTo('SQMI');
    end;
    case AngularUnit of
      1: TPDFName(PDUArray.Item[2]).SetTo('DEG');
      2: TPDFName(PDUArray.Item[2]).SetTo('GRD');
    end;
  end;
end;

{ TQuickPDFCoordinateSystemDict }

constructor TQuickPDFCoordinateSystemDict.Create(CSDict: TPDFDictionary;
  Structure: TPDFStructure);
begin
  Dict := CSDict;
  Self.Structure := Structure;
end;

function TQuickPDFCoordinateSystemDict.GetDictType: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('Type', True);
    if (Obj is TPDFName) then
    begin
      if (TPDFName(Obj).Name = 'GEOGCS') then
      begin
        Result := 1;
      end else
      if (TPDFName(Obj).Name = 'PROJCS') then
      begin
        Result := 2;
      end;
    end;
  end;
end;

function TQuickPDFCoordinateSystemDict.GetEPSG: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('EPSG', True);
    if (Obj is TPDFNumeric) then
    begin
      Result := TPDFNumeric(Obj).AsInteger;
    end;
  end;
end;

function TQuickPDFCoordinateSystemDict.GetWKT: WideString;
var
  Obj: TPDFObject;
begin
  Result := '';
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('WKT', True);
    if (Obj is TPDFString) then
    begin
      Result := TPDFString(Obj).AsTextString;
    end;
  end;
end;

function TQuickPDFCoordinateSystemDict.SetDictType(
  NewDictType: Integer): Boolean;
var
  Obj: TPDFObject;
begin
  Result := False;
  if (Assigned(Dict)) then
  begin
    Obj := Dict.FindValueByKeyName('Type', True);
    if (not (Obj is TPDFName)) then
    begin
      Obj := Structure.NewName('');
      Dict.Add('Type', Obj);
    end;
    if (Obj is TPDFName) then
    begin
      Result := True;
      if (NewDictType = 1) then TPDFName(Obj).SetTo('GEOGCS');
      if (NewDictType = 2) then TPDFName(Obj).SetTo('PROJCS');
    end;
  end;
end;

function TQuickPDFCoordinateSystemDict.SetEPSG(NewEPSG: Integer): Boolean;
var
  Obj: TPDFObject;
begin
  Result := False;
  if (Assigned(Dict)) then
  begin
    Result := True;
    Obj := Dict.FindValueByKeyName('EPSG', True);
    if (Obj is TPDFNumeric) then
    begin
      TPDFNumeric(Obj).SetTo(NewEPSG);
    end else
    begin
      Dict.Add('EPSG', Structure.NewNumeric(NewEPSG));
    end;
  end;
end;

function TQuickPDFCoordinateSystemDict.SetWKT(
  const NewWKT: WideString): Boolean;
var
  Obj: TPDFObject;
begin
  Result := False;
  if (Assigned(Dict)) then
  begin
    Result := True;
    Obj := Dict.FindValueByKeyName('WKT', True);
    if (Obj is TPDFString) then
    begin
      TPDFString(Obj).SetToTextString(NewWKT);
    end else
    begin
      Dict.Add('WKT', Structure.NewTextString(NewWKT));
    end;
  end;
end;

end.
