
{**************************************************}
{                                                  }
{                 XML Data Binding                 }
{                                                  }
{         Generated on: 29.04.2017 18:33:31        }
{       Generated from: D:\POLAK\TaxCycleMap.xml   }
{   Settings stored in: D:\POLAK\TaxCycleMap.xdb   }
{                                                  }
{**************************************************}

unit TaxCycleMap;

interface

uses xmldom, XMLDoc, XMLIntf, SysUtils, Variants, Classes,
  System.RegularExpressions;

const
  c_FormGroupCaption = 'Group of form #';
  c_TableRowCaption = 'Table row #';

type

{ Forward Decls }

  IXMLTaxCycleMapType = interface;
  IXMLElementsType = interface;
  IXMLElementType = interface;
  IXMLVisualTaxPathType = interface;
  IXMLValueType = interface;
  IXMLTransformType = interface;
  IXMLTransformItemType = interface;
  IXMLDynTargetType = interface;
  IXMLDynTargetItemType = interface;

{ IXMLTaxCycleMapType }

  IXMLTaxCycleMapType = interface(IXMLNode)
    ['{E6286AC7-2FCB-4CA6-B308-39B24972014F}']
    { Property Accessors }
    function Get_Elements: IXMLElementsType;
    { Methods & Properties }
    property Elements: IXMLElementsType read Get_Elements;
    procedure SaveToFile(AFileName: String);
  end;

{ IXMLElementsType }

  IXMLElementsType = interface(IXMLNodeCollection)
    ['{503D475E-B1C9-444A-92A0-F99F84671EA2}']
    { Property Accessors }
    function Get_Element(Index: Integer): IXMLElementType;
    { Methods & Properties }
    function Add: IXMLElementType;
    function Insert(const Index: Integer): IXMLElementType;
    function ElementByTaxCyclePath(const ATaxCyclePath: String): IXMLElementType;
    function FindElementByTaxCyclePath(const ATaxCyclePath: String): IXMLElementType;
    property Element[Index: Integer]: IXMLElementType read Get_Element; default;
  end;

{ IXMLElementType }

  IXMLElementType = interface(IXMLNode)
    ['{86307B90-0707-431A-963D-C1ABF8D82848}']
    { Property Accessors }
    function Get_TaxCyclePath: UnicodeString;
    function Get_SlipToMuliSlip: Boolean;
    function Get_NumberOfForms: Integer;
    function Get_Shift: Integer;
    function Get_VisualTaxPath: IXMLVisualTaxPathType;
    function Get_Value: IXMLValueType;
    function Get_UseDynTarget: Boolean;
    function Get_DynTarget: IXMLDynTargetType;
    function Get_SkipLastRow: Boolean;
    procedure Set_TaxCyclePath(Value: UnicodeString);
    procedure Set_SlipToMuliSlip(Value: Boolean);
    procedure Set_NumberOfForms(Value: Integer);
    procedure Set_Shift(Value: Integer);
    procedure Set_UseDynTarget(Value: Boolean);
    procedure Set_SkipLastRow(Value: Boolean);
    function GetIsSlipsElement: Boolean;
    function GetisTableRowElement: Boolean;
    function RealVisualTaxFormName(APath: String; ASlipNo: Integer): UnicodeString;
    function GetNumberOfForms: Integer;
    function GetTableRowNo(APath: String): Integer;
    function GetParentSlipToMultiSlip: Boolean;
    { Methods & Properties }
    property TaxCyclePath: UnicodeString read Get_TaxCyclePath write Set_TaxCyclePath;
    property VisualTaxPath: IXMLVisualTaxPathType read Get_VisualTaxPath;
    property Value: IXMLValueType read Get_Value;
    property SlipToMuliSlip: Boolean read Get_SlipToMuliSlip write Set_SlipToMuliSlip;
    property NumberOfForms: Integer read Get_NumberOfForms write Set_NumberOfForms;
    property Shift: Integer read Get_Shift write Set_Shift;
    property SkipLastRow: Boolean read Get_SkipLastRow write Set_SkipLastRow;
    property UseDynTarget: Boolean read Get_UseDynTarget write Set_UseDynTarget;
    property DynTarget: IXMLDynTargetType read Get_DynTarget;
    property IsSlipsElement: Boolean read GetIsSlipsElement;
    property isTableRowElement: Boolean read GetisTableRowElement;
  end;

{ IXMLDynTargetType }

  IXMLDynTargetType = interface(IXMLNodeCollection)
    ['{18B7E156-47BD-49F3-AB71-B911B2AF10B1}']
    { Property Accessors }
    function Get_DynTargetItem(Index: Integer): IXMLDynTargetItemType;
    { Methods & Properties }
    function Add: IXMLDynTargetItemType;
    function Insert(const Index: Integer): IXMLDynTargetItemType;
    property DynTargetItem[Index: Integer]: IXMLDynTargetItemType read Get_DynTargetItem; default;
  end;

{ IXMLTransformItemType }

  IXMLDynTargetItemType = interface(IXMLNode)
    ['{10A1CD2C-A954-4610-97F8-D67F6DB74C58}']
    { Property Accessors }
    function Get_TaxCycleFromRowNo: Integer;
    function Get_VisualTaxFormName: UnicodeString;
    function Get_VisualTaxStartElementNo: Integer;
    function Get_VisualTaxShift: Integer;
    procedure Set_TaxCycleFromRowNo(Value: Integer);
    procedure Set_VisualTaxFormName(Value: UnicodeString);
    procedure Set_VisualTaxStartElementNo(Value: Integer);
    procedure Set_VisualTaxShift(Value: Integer);
    { Methods & Properties }
    property TaxCycleFromRowNo: Integer read Get_TaxCycleFromRowNo write Set_TaxCycleFromRowNo;
    property VisualTaxFormName: UnicodeString read Get_VisualTaxFormName write Set_VisualTaxFormName;
    property VisualTaxStartElementNo: Integer read Get_VisualTaxStartElementNo write Set_VisualTaxStartElementNo;
    property VisualTaxShift: Integer read Get_VisualTaxShift write Set_VisualTaxShift;
  end;

{ IXMLVisualTaxPathType }

  IXMLVisualTaxPathType = interface(IXMLNode)
    ['{BE25A04A-6FCA-44AD-A119-BC304C0831B7}']
    { Property Accessors }
    function Get_FormName: UnicodeString;
    function Get_ElementNo: Integer;
    procedure Set_FormName(Value: UnicodeString);
    procedure Set_ElementNo(Value: Integer);
    { Methods & Properties }
    property FormName: UnicodeString read Get_FormName write Set_FormName;
    property ElementNo: Integer read Get_ElementNo write Set_ElementNo;
  end;

{ IXMLValueType }

  IXMLValueType = interface(IXMLNode)
    ['{2290DD94-3125-4310-B9D1-8989FB5CD20E}']
    { Property Accessors }
    function Get_Kind: Smallint;
    function Get_Transform: IXMLTransformType;
    procedure Set_Kind(Value: Smallint);
    { Methods & Properties }
    property Kind: Smallint read Get_Kind write Set_Kind;
    property Transform: IXMLTransformType read Get_Transform;
  end;

{ IXMLTransformType }

  IXMLTransformType = interface(IXMLNodeCollection)
    ['{2BECE697-36A8-4610-9D89-DE2002B83912}']
    { Property Accessors }
    function Get_TransformItem(Index: Integer): IXMLTransformItemType;
    { Methods & Properties }
    function Add: IXMLTransformItemType;
    function Insert(const Index: Integer): IXMLTransformItemType;
    property TransformItem[Index: Integer]: IXMLTransformItemType read Get_TransformItem; default;
  end;

{ IXMLTransformItemType }

  IXMLTransformItemType = interface(IXMLNode)
    ['{10A1CD2C-A954-4610-97F8-D67F6DB74C58}']
    { Property Accessors }
    function Get_TaxCycleValue: Variant;
    function Get_VisualTaxValue: UnicodeString;
    procedure Set_TaxCycleValue(Value: Variant);
    procedure Set_VisualTaxValue(Value: UnicodeString);
    { Methods & Properties }
    property TaxCycleValue: Variant read Get_TaxCycleValue write Set_TaxCycleValue;
    property VisualTaxValue: UnicodeString read Get_VisualTaxValue write Set_VisualTaxValue;
  end;

{ Forward Decls }

  TXMLTaxCycleMapType = class;
  TXMLElementsType = class;
  TXMLElementType = class;
  TXMLVisualTaxPathType = class;
  TXMLValueType = class;
  TXMLTransformType = class;
  TXMLTransformItemType = class;
  TXMLDynTargetType = class;
  TXMLDynTargetItemType = class;

{ TXMLTaxCycleMapType }

  TXMLTaxCycleMapType = class(TXMLNode, IXMLTaxCycleMapType)
  protected
    { IXMLTaxCycleMapType }
    function Get_Elements: IXMLElementsType;
  public
    procedure AfterConstruction; override;
    procedure SaveToFile(AFileName: String);
  end;

{ TXMLElementsType }

  TXMLElementsType = class(TXMLNodeCollection, IXMLElementsType)
  private
    FSortedListPrepared: Boolean;
    FSortedList: TStringList;
    procedure PrepareSortedList;
  protected
    { IXMLElementsType }

    function Get_Element(Index: Integer): IXMLElementType;
    function Add: IXMLElementType;
    function Insert(const Index: Integer): IXMLElementType;
    procedure ChildListNotify(Operation: TNodeListOperation;
      var Node: IXMLNode; const IndexOrName: OleVariant; BeforeOperation: Boolean); override;

  public
    procedure AfterConstruction; override;
    destructor Destroy; override;
    function ElementByTaxCyclePath(const ATaxCyclePath: String): IXMLElementType;
    function FindElementByTaxCyclePath(const ATaxCyclePath: String): IXMLElementType; inline;
  end;

{ TXMLElementType }

  TXMLElementType = class(TXMLNode, IXMLElementType)
  protected
    { IXMLElementType }
    function Get_TaxCyclePath: UnicodeString;
    function Get_SlipToMuliSlip: Boolean;
    function Get_NumberOfForms: Integer;
    function Get_Shift: Integer;
    function Get_VisualTaxPath: IXMLVisualTaxPathType;
    function Get_Value: IXMLValueType;
    function Get_UseDynTarget: Boolean;
    function Get_DynTarget: IXMLDynTargetType;
    function Get_SkipLastRow: Boolean;
    procedure Set_TaxCyclePath(Value: UnicodeString);
    procedure Set_SlipToMuliSlip(Value: Boolean);
    procedure Set_NumberOfForms(Value: Integer);
    procedure Set_Shift(Value: Integer);
    procedure Set_UseDynTarget(Value: Boolean);
    procedure Set_SkipLastRow(Value: Boolean);

    function GetIsSlipsElement: Boolean;
    function GetisTableRowElement: Boolean;

    function RealVisualTaxFormName(APath: String; ASlipNo: Integer): UnicodeString;
    function GetNumberOfForms: Integer;
    function GetTableRowNo(APath: String): Integer;
    function GetParentSlipToMultiSlip: Boolean;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLVisualTaxPathType }

  TXMLVisualTaxPathType = class(TXMLNode, IXMLVisualTaxPathType)
  protected
    { IXMLVisualTaxPathType }
    function Get_FormName: UnicodeString;
    function Get_ElementNo: Integer;
    procedure Set_FormName(Value: UnicodeString);
    procedure Set_ElementNo(Value: Integer);
  end;

{ TXMLValueType }

  TXMLValueType = class(TXMLNode, IXMLValueType)
  protected
    { IXMLValueType }
    function Get_Kind: Smallint;
    function Get_Transform: IXMLTransformType;
    procedure Set_Kind(Value: Smallint);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTransformType }

  TXMLTransformType = class(TXMLNodeCollection, IXMLTransformType)
  protected
    { IXMLTransformType }
    function Get_TransformItem(Index: Integer): IXMLTransformItemType;
    function Add: IXMLTransformItemType;
    function Insert(const Index: Integer): IXMLTransformItemType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTransformItemType }

  TXMLTransformItemType = class(TXMLNode, IXMLTransformItemType)
  protected
    { IXMLTransformItemType }
    function Get_TaxCycleValue: Variant;
    function Get_VisualTaxValue: UnicodeString;
    procedure Set_TaxCycleValue(Value: Variant);
    procedure Set_VisualTaxValue(Value: UnicodeString);
  end;

{ IXMLDynTargetType }

  TXMLDynTargetType = class(TXMLNodeCollection, IXMLDynTargetType)
  protected
    { IXMLDynTargetType }
    function Get_DynTargetItem(Index: Integer): IXMLDynTargetItemType;
    function Add: IXMLDynTargetItemType;
    function Insert(const Index: Integer): IXMLDynTargetItemType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTransformItemType }

  TXMLDynTargetItemType = class(TXMLNode, IXMLDynTargetItemType)
  protected
    { IXMLDynTargetItemType }
    function Get_TaxCycleFromRowNo: Integer;
    function Get_VisualTaxFormName: UnicodeString;
    function Get_VisualTaxStartElementNo: Integer;
    function Get_VisualTaxShift: Integer;
    procedure Set_TaxCycleFromRowNo(Value: Integer);
    procedure Set_VisualTaxFormName(Value: UnicodeString);
    procedure Set_VisualTaxStartElementNo(Value: Integer);
    procedure Set_VisualTaxShift(Value: Integer);
  end;

{ Global Functions }

function GetTaxCycleMap(Doc: IXMLDocument): IXMLTaxCycleMapType;
function LoadTaxCycleMap(const FileName: string): IXMLTaxCycleMapType;
function NewTaxCycleMap: IXMLTaxCycleMapType;

const
  TargetNamespace = '';

  c_Value_AsIs = 0;
  c_Value_InDollar = 1;
  c_Value_YesOrNot = 2;
  c_Value_Check = 3;
  c_Value_RadioGroup = 4;
  c_Value_DateTime = 5;
  c_Value_Transform = 6;
  c_Value_Split = 7;
  c_Value_Percent = 8;
  c_Value_Cumulative = 9;
  c_Value_Concat = 10;
  c_Value_Extract = 11; // extract value from start to first non 0-9 or "." char // 10-a -> 10  //20190723 Igor

implementation

{ Global Functions }

function GetTaxCycleMap(Doc: IXMLDocument): IXMLTaxCycleMapType;
begin
  Result := Doc.GetDocBinding('TaxCycleMap', TXMLTaxCycleMapType, TargetNamespace) as IXMLTaxCycleMapType;
end;

function LoadTaxCycleMap(const FileName: string): IXMLTaxCycleMapType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('TaxCycleMap', TXMLTaxCycleMapType, TargetNamespace) as IXMLTaxCycleMapType;
end;

function NewTaxCycleMap: IXMLTaxCycleMapType;
begin
  Result := NewXMLDocument.GetDocBinding('TaxCycleMap', TXMLTaxCycleMapType, TargetNamespace) as IXMLTaxCycleMapType;
end;

{ TXMLTaxCycleMapType }

procedure TXMLTaxCycleMapType.AfterConstruction;
begin
  RegisterChildNode('Elements', TXMLElementsType);
  inherited;
end;

function TXMLTaxCycleMapType.Get_Elements: IXMLElementsType;
begin
  Result := ChildNodes['Elements'] as IXMLElementsType;
end;

procedure TXMLTaxCycleMapType.SaveToFile(AFileName: String);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.Text := xmlDoc.FormatXMLData(Self.OwnerDocument.XML.Text);
    SL.SaveToFile(AFilename);
  finally
    SL.Free;
  end;
end;

{ TXMLElementsType }

procedure TXMLElementsType.AfterConstruction;
begin
  RegisterChildNode('Element', TXMLElementType);
  ItemTag := 'Element';
  ItemInterface := IXMLElementType;
  FSortedList := TStringList.Create;
  inherited;
end;

procedure TXMLElementsType.ChildListNotify(Operation: TNodeListOperation;
  var Node: IXMLNode; const IndexOrName: OleVariant; BeforeOperation: Boolean);
begin
  inherited;
  FSortedListPrepared := False;
end;

destructor TXMLElementsType.Destroy;
begin
  FreeAndNil(FSortedList);
  inherited;
end;

function TXMLElementsType.ElementByTaxCyclePath(
  const ATaxCyclePath: String): IXMLElementType;
begin
  Result := FindElementByTaxCyclePath(ATaxCyclePath);
  if Result <> nil then
    exit;
  Result := Self.Add;
  Result.TaxCyclePath := ATaxCyclePath;
  Result.Value.Kind := 0;
end;

function TXMLElementsType.FindElementByTaxCyclePath(
  const ATaxCyclePath: String): IXMLElementType;
var
  I: Integer;
begin
  PrepareSortedList;
  I := FSortedList.IndexOf(TRegEx.Replace(ATaxCyclePath, '#[\d]{1,}\.', '#1.'));
  if I > 0 then
    Result := Self.Get_Element(Integer(FSortedList.Objects[I]))
  else
    Result := nil;
end;

function TXMLElementsType.Get_Element(Index: Integer): IXMLElementType;
begin
  Result := List[Index] as IXMLElementType;
end;

function TXMLElementsType.Add: IXMLElementType;
begin
  Result := AddItem(-1) as IXMLElementType;
end;

function TXMLElementsType.Insert(const Index: Integer): IXMLElementType;
begin
  Result := AddItem(Index) as IXMLElementType;
end;

procedure TXMLElementsType.PrepareSortedList;
var
  I: Integer;
begin
  if FSortedListPrepared then
    exit;
  FSortedList.Clear;
  for I := 0 to Self.Count - 1 do
    FSortedList.AddObject(Self.Get_Element(I).TaxCyclePath, TObject(I));
  FSortedList.Sort;
  FSortedListPrepared := True;
end;

{ TXMLElementType }

procedure TXMLElementType.AfterConstruction;
begin
  RegisterChildNode('VisualTaxPath', TXMLVisualTaxPathType);
  RegisterChildNode('Value', TXMLValueType);
  RegisterChildNode('DynTarget', TXMLDynTargetType);
  inherited;
end;

function TXMLElementType.GetIsSlipsElement: Boolean;
begin
  Result := pos(c_FormGroupCaption, Self.Get_TaxCyclePath) > 0;
end;

function TXMLElementType.GetisTableRowElement: Boolean;
begin
  Result := pos(c_TableRowCaption, Self.Get_TaxCyclePath) > 0;
end;

function TXMLElementType.GetTableRowNo(APath: String): Integer;
var
  RowNo: String;
  M: TMatch;
begin
  M := TRegEx.Match(APath, c_TableRowCaption + '[/d]{1,}');
  if M.Success then
  begin
    RowNo := copy(M.Value, length(c_TableRowCaption) + 1, 5);
    if not tryStrToInt(RowNo, Result) then
      Result := 0;
  end
  else
    Result := 0;
end;

function TXMLElementType.RealVisualTaxFormName(APath: String; ASlipNo: Integer): UnicodeString;
var
  VTFormName: String;
  FormGroup: String;
  Elements: IXMLElementsType;
  FormGroupElement: IXMLElementType;
const
  c_EndsSlipNo = '#[\d]{1,}$';
begin
  VTFormName := Self.Get_VisualTaxPath.FormName;
  if pos(c_FormGroupCaption, APath) > 0 then
  begin
    FormGroup := copy(APath, 1, pos(c_FormGroupCaption, APath) + length(c_FormGroupCaption) - 1) + '1';
    Elements := Self.ParentNode as IXMLElementsType;
    FormGroupElement := Elements.FindElementByTaxCyclePath(FormGroup+'1');
    if (FormGroupElement <> nil) AND
       FormGroupElement.SlipToMuliSlip AND
       (FormGroupElement.NumberOfForms > 0) then
      ASlipNo := (ASlipNo - 1) div FormGroupElement.NumberOfForms;
    Result := TRegEx.Replace(VTFormName, c_EndsSlipNo, '#' + IntToStr(ASlipNo));
  end
  else
    Result := VTFormName;
end;

function TXMLElementType.GetNumberOfForms: Integer;
var
  VTFormName: String;
  A: TArray<String>;
  Found: Boolean;
  S: String;
  IntSlipNo: Integer;
  FormGroup: String;
  Elements: IXMLElementsType;
  FormGroupElement: IXMLElementType;
const
  c_AnyChars = '.{1,}';
  c_EndsSlipNo = '#[\d]{1,}$';
begin
  VTFormName := Self.Get_VisualTaxPath.FormName;
  if TRegEx.IsMatch(VTFormName, c_AnyChars + c_EndsSlipNo, [roIgnoreCase]) then
  begin
    A := Self.Get_TaxCyclePath.Split(['.']);
    FormGroup := '';
    Found := False;
    for S in A do
    begin
      FormGroup := FormGroup + S + '.';
      if S.StartsWith(c_FormGroupCaption) then
      begin
        Found := True;
        break;
      end;
    end;
    if Found then
    begin
      if FormGroup <> '' then
        Delete(FormGroup, Length(FormGroup), 1);
      Elements := Self.ParentNode as IXMLElementsType;
      FormGroupElement := Elements.FindElementByTaxCyclePath(FormGroup);
      if (FormGroupElement <> nil) AND
         FormGroupElement.SlipToMuliSlip AND
         (FormGroupElement.NumberOfForms > 0) then
        Result := FormGroupElement.NumberOfForms
      else
        Result := 0;
    end
    else
      Result := 0;
  end
  else
    Result := 0;
end;

function TXMLElementType.GetParentSlipToMultiSlip: Boolean;
var
  VTFormName: String;
  A: TArray<String>;
  Found: Boolean;
  S: String;
  IntSlipNo: Integer;
  FormGroup: String;
  Elements: IXMLElementsType;
  FormGroupElement: IXMLElementType;
const
  c_AnyChars = '.{1,}';
  c_EndsSlipNo = '#[\d]{1,}$';
begin
  VTFormName := Self.Get_VisualTaxPath.FormName;
  if TRegEx.IsMatch(VTFormName, c_AnyChars + c_EndsSlipNo, [roIgnoreCase]) then
  begin
    A := Self.Get_TaxCyclePath.Split(['.']);
    FormGroup := '';
    Found := False;
    for S in A do
    begin
      FormGroup := FormGroup + S + '.';
      if S.StartsWith(c_FormGroupCaption) then
      begin
        Found := True;
        break;
      end;
    end;
    if Found then
    begin
      if FormGroup <> '' then
        Delete(FormGroup, Length(FormGroup), 1);
      Elements := Self.ParentNode as IXMLElementsType;
      FormGroupElement := Elements.FindElementByTaxCyclePath(FormGroup);
      if (FormGroupElement <> nil) then
        Result := FormGroupElement.SlipToMuliSlip
      else
        Result := false;
    end
    else
      Result := false;
  end
  else
    Result := false;
end;

function TXMLElementType.Get_DynTarget: IXMLDynTargetType;
begin
  Result := ChildNodes['DynTarget'] as IXMLDynTargetType;
end;

function TXMLElementType.Get_NumberOfForms: Integer;
var
  V: Variant;
begin
  V := ChildNodes['NumberOfForms'].NodeValue;
  if VarIsNull(V) or VarIsEmpty(V) or not TryStrToInt(VarToStr(V), Result) then
    Result := 0;
end;

function TXMLElementType.Get_Shift: Integer;
var
  V: Variant;
begin
  V := ChildNodes['Shift'].NodeValue;
  if VarIsNull(V) or VarIsEmpty(V) or not TryStrToInt(VarToStr(V), Result) then
    Result := 0;
end;

function TXMLElementType.Get_SkipLastRow: Boolean;
var
  V: Variant;
begin
  V := ChildNodes['SkipLastRow'].NodeValue;
  if VarIsNull(V) or VarIsEmpty(V) or not TryStrToBool(VarToStr(V), Result) then
    Result := False;
end;

function TXMLElementType.Get_SlipToMuliSlip: Boolean;
var
  V: Variant;
begin
  V := ChildNodes['SlipToMuliSlip'].NodeValue;
  if VarIsNull(V) or VarIsEmpty(V) or not TryStrToBool(VarToStr(V), Result) then
    Result := False;
end;

function TXMLElementType.Get_TaxCyclePath: UnicodeString;
begin
  Result := ChildNodes['TaxCyclePath'].Text;
end;

function TXMLElementType.Get_UseDynTarget: Boolean;
var
  V: Variant;
begin
  V := ChildNodes['UseDynTarget'].NodeValue;
  if VarIsNull(V) or VarIsEmpty(V) or not TryStrToBool(VarToStr(V), Result) then
    Result := False;
end;

procedure TXMLElementType.Set_NumberOfForms(Value: Integer);
begin
  ChildNodes['NumberOfForms'].NodeValue := Value;
end;

procedure TXMLElementType.Set_Shift(Value: Integer);
begin
  ChildNodes['Shift'].NodeValue := Value;
end;

procedure TXMLElementType.Set_SkipLastRow(Value: Boolean);
begin
  ChildNodes['SkipLastRow'].NodeValue := Value;
end;

procedure TXMLElementType.Set_SlipToMuliSlip(Value: Boolean);
begin
  ChildNodes['SlipToMuliSlip'].NodeValue := Value;
end;

procedure TXMLElementType.Set_TaxCyclePath(Value: UnicodeString);
begin
  ChildNodes['TaxCyclePath'].NodeValue := Value;
end;

procedure TXMLElementType.Set_UseDynTarget(Value: Boolean);
begin
  ChildNodes['UseDynTarget'].NodeValue := Value;
end;

function TXMLElementType.Get_VisualTaxPath: IXMLVisualTaxPathType;
begin
  Result := ChildNodes['VisualTaxPath'] as IXMLVisualTaxPathType;
end;

function TXMLElementType.Get_Value: IXMLValueType;
begin
  Result := ChildNodes['Value'] as IXMLValueType;
end;

{ TXMLVisualTaxPathType }

function TXMLVisualTaxPathType.Get_FormName: UnicodeString;
begin
  Result := ChildNodes['FormName'].Text;
end;

procedure TXMLVisualTaxPathType.Set_FormName(Value: UnicodeString);
begin
  ChildNodes['FormName'].NodeValue := Value;
end;

function TXMLVisualTaxPathType.Get_ElementNo: Integer;
var
  V: Variant;
begin
  V := ChildNodes['ElementNo'].NodeValue;
  if VarIsNull(V) or VarIsEmpty(V) or not TryStrToInt(VarToStr(V), Result) then
    Result := 0;
end;

procedure TXMLVisualTaxPathType.Set_ElementNo(Value: Integer);
begin
  ChildNodes['ElementNo'].NodeValue := Value;
end;

{ TXMLValueType }

procedure TXMLValueType.AfterConstruction;
begin
  RegisterChildNode('Transform', TXMLTransformType);
  inherited;
end;

function TXMLValueType.Get_Kind: Smallint;
begin
  Result := ChildNodes['Kind'].NodeValue;
end;

procedure TXMLValueType.Set_Kind(Value: Smallint);
begin
  ChildNodes['Kind'].NodeValue := Value;
end;

function TXMLValueType.Get_Transform: IXMLTransformType;
begin
  Result := ChildNodes['Transform'] as IXMLTransformType;
end;

{ TXMLTransformType }

procedure TXMLTransformType.AfterConstruction;
begin
  RegisterChildNode('TransformItem', TXMLTransformItemType);
  ItemTag := 'TransformItem';
  ItemInterface := IXMLTransformItemType;
  inherited;
end;

function TXMLTransformType.Get_TransformItem(Index: Integer): IXMLTransformItemType;
begin
  Result := List[Index] as IXMLTransformItemType;
end;

function TXMLTransformType.Add: IXMLTransformItemType;
begin
  Result := AddItem(-1) as IXMLTransformItemType;
end;

function TXMLTransformType.Insert(const Index: Integer): IXMLTransformItemType;
begin
  Result := AddItem(Index) as IXMLTransformItemType;
end;

{ TXMLTransformItemType }

function TXMLTransformItemType.Get_TaxCycleValue: Variant;
begin
  Result := ChildNodes['TaxCycleValue'].NodeValue;
end;

procedure TXMLTransformItemType.Set_TaxCycleValue(Value: Variant);
begin
  ChildNodes['TaxCycleValue'].NodeValue := Value;
end;

function TXMLTransformItemType.Get_VisualTaxValue: UnicodeString;
begin
  Result := ChildNodes['VisualTaxValue'].Text;
end;

procedure TXMLTransformItemType.Set_VisualTaxValue(Value: UnicodeString);
begin
  ChildNodes['VisualTaxValue'].NodeValue := Value;
end;

{ TXMLDynTargetType }

procedure TXMLDynTargetType.AfterConstruction;
begin
  RegisterChildNode('DynTargetItem', TXMLDynTargetItemType);
  ItemTag := 'DynTargetItem';
  ItemInterface := IXMLDynTargetItemType;
  inherited;
end;

function TXMLDynTargetType.Get_DynTargetItem(
  Index: Integer): IXMLDynTargetItemType;
begin
  Result := List[Index] as IXMLDynTargetItemType;
end;

function TXMLDynTargetType.Add: IXMLDynTargetItemType;
begin
  Result := AddItem(-1) as IXMLDynTargetItemType;
end;

function TXMLDynTargetType.Insert(const Index: Integer): IXMLDynTargetItemType;
begin
  Result := AddItem(Index) as IXMLDynTargetItemType;
end;

{ TXMLDynTargetItemType }

function TXMLDynTargetItemType.Get_TaxCycleFromRowNo: Integer;
var
  V: Variant;
begin
  V := ChildNodes['TaxCycleFromRowNo'].NodeValue;
  if VarIsNull(V) or VarIsEmpty(V) or not TryStrToInt(VarToStr(V), Result) then
    Result := 0;
end;

procedure TXMLDynTargetItemType.Set_TaxCycleFromRowNo(Value: Integer);
begin
  ChildNodes['TaxCycleFromRowNo'].NodeValue := Value;
end;

function TXMLDynTargetItemType.Get_VisualTaxFormName: UnicodeString;
begin
  Result := ChildNodes['VisualTaxFormName'].Text;
end;

procedure TXMLDynTargetItemType.Set_VisualTaxFormName(Value: UnicodeString);
begin
  ChildNodes['VisualTaxFormName'].NodeValue := Value;
end;

function TXMLDynTargetItemType.Get_VisualTaxShift: Integer;
var
  V: Variant;
begin
  V := ChildNodes['VisualTaxShift'].NodeValue;
  if VarIsNull(V) or VarIsEmpty(V) or not TryStrToInt(VarToStr(V), Result) then
    Result := 0;
end;

procedure TXMLDynTargetItemType.Set_VisualTaxShift(Value: Integer);
begin
  ChildNodes['VisualTaxShift'].NodeValue := Value;
end;

function TXMLDynTargetItemType.Get_VisualTaxStartElementNo: Integer;
var
  V: Variant;
begin
  V := ChildNodes['VisualTaxStartElementNo'].NodeValue;
  if VarIsNull(V) or VarIsEmpty(V) or not TryStrToInt(VarToStr(V), Result) then
    Result := 0;
end;

procedure TXMLDynTargetItemType.Set_VisualTaxStartElementNo(Value: Integer);
begin
  ChildNodes['VisualTaxStartElementNo'].NodeValue := Value;
end;

end.
