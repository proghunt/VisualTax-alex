
{************************************************************************************************************************}
{                                                                                                                        }
{                                                    XML Data Binding                                                    }
{                                                                                                                        }
{         Generated on: 20.05.2017 22:09:30                                                                              }
{       Generated from: D:\POLAK\PROJECTS\OUTSORCE\Customers\VisualTax\VisualTax_V2\2016\DistrFl\T1-2016\TempDir\2.XML   }
{   Settings stored in: D:\POLAK\PROJECTS\OUTSORCE\Customers\VisualTax\VisualTax_V2\2016\DistrFl\T1-2016\TempDir\2.xdb   }
{                                                                                                                        }
{************************************************************************************************************************}

unit vtFilterPreSets;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLFilterPreSetsType = interface;
  IXMLFilterPreSetType = interface;
  IXMLFilterType = interface;
  IXMLFilterGroupType = interface;
  IXMLFilterGroupTypeList = interface;

{ IXMLFilterPreSetsType }

  IXMLFilterPreSetsType = interface(IXMLNodeCollection)
    ['{4D984571-3A1C-4CC1-AC4B-3BC150598C01}']
    { Property Accessors }
    function Get_FilterPreSet(Index: Integer): IXMLFilterPreSetType;
    { Methods & Properties }
    function Add: IXMLFilterPreSetType;
    function Insert(const Index: Integer): IXMLFilterPreSetType;
    property FilterPreSet[Index: Integer]: IXMLFilterPreSetType read Get_FilterPreSet; default;
  end;

{ IXMLFilterPreSetType }

  IXMLFilterPreSetType = interface(IXMLNode)
    ['{84DBB188-A6C9-4FFB-81DE-619CD1B9FD85}']
    { Property Accessors }
    function Get_Name: Integer;
    function Get_Note: Integer;
    function Get_Filter: IXMLFilterType;
    function Get_FilterGroup: IXMLFilterGroupTypeList;
    procedure Set_Name(Value: Integer);
    procedure Set_Note(Value: Integer);
    { Methods & Properties }
    property Name: Integer read Get_Name write Set_Name;
    property Note: Integer read Get_Note write Set_Note;
    property Filter: IXMLFilterType read Get_Filter;
    property FilterGroup: IXMLFilterGroupTypeList read Get_FilterGroup;
  end;

{ IXMLFilterType }

  IXMLFilterType = interface(IXMLNode)
    ['{967D0F3B-79FA-4734-911F-45D624D39056}']
    { Property Accessors }
    function Get_OperatorLeftKind: Integer;
    function Get_OperatorLeftHint: UnicodeString;
    function Get_OperatorLeftValue: UnicodeString;
    function Get_OperatorRightKind: Integer;
    function Get_OperatorRightHint: Integer;
    function Get_OperatorRightValue: Integer;
    function Get_Operand: Integer;
    procedure Set_OperatorLeftKind(Value: Integer);
    procedure Set_OperatorLeftHint(Value: UnicodeString);
    procedure Set_OperatorLeftValue(Value: UnicodeString);
    procedure Set_OperatorRightKind(Value: Integer);
    procedure Set_OperatorRightHint(Value: Integer);
    procedure Set_OperatorRightValue(Value: Integer);
    procedure Set_Operand(Value: Integer);
    { Methods & Properties }
    property OperatorLeftKind: Integer read Get_OperatorLeftKind write Set_OperatorLeftKind;
    property OperatorLeftHint: UnicodeString read Get_OperatorLeftHint write Set_OperatorLeftHint;
    property OperatorLeftValue: UnicodeString read Get_OperatorLeftValue write Set_OperatorLeftValue;
    property OperatorRightKind: Integer read Get_OperatorRightKind write Set_OperatorRightKind;
    property OperatorRightHint: Integer read Get_OperatorRightHint write Set_OperatorRightHint;
    property OperatorRightValue: Integer read Get_OperatorRightValue write Set_OperatorRightValue;
    property Operand: Integer read Get_Operand write Set_Operand;
  end;

{ IXMLFilterGroupType }

  IXMLFilterGroupType = interface(IXMLNode)
    ['{0E9B2767-5AB4-4BF6-9C2E-966537D681B8}']
    { Property Accessors }
    function Get_GroupCondition: Integer;
    function Get_Filter: IXMLFilterType;
    function Get_FilterGroup: IXMLFilterGroupTypeList;
    procedure Set_GroupCondition(Value: Integer);
    { Methods & Properties }
    property GroupCondition: Integer read Get_GroupCondition write Set_GroupCondition;
    property Filter: IXMLFilterType read Get_Filter;
    property FilterGroup: IXMLFilterGroupTypeList read Get_FilterGroup;
  end;

{ IXMLFilterGroupTypeList }

  IXMLFilterGroupTypeList = interface(IXMLNodeCollection)
    ['{0FB2E0AE-C195-46C1-814E-2393FE4893EA}']
    { Methods & Properties }
    function Add: IXMLFilterGroupType;
    function Insert(const Index: Integer): IXMLFilterGroupType;

    function Get_Item(Index: Integer): IXMLFilterGroupType;
    property Items[Index: Integer]: IXMLFilterGroupType read Get_Item; default;
  end;

{ Forward Decls }

  TXMLFilterPreSetsType = class;
  TXMLFilterPreSetType = class;
  TXMLFilterType = class;
  TXMLFilterGroupType = class;
  TXMLFilterGroupTypeList = class;

{ TXMLFilterPreSetsType }

  TXMLFilterPreSetsType = class(TXMLNodeCollection, IXMLFilterPreSetsType)
  protected
    { IXMLFilterPreSetsType }
    function Get_FilterPreSet(Index: Integer): IXMLFilterPreSetType;
    function Add: IXMLFilterPreSetType;
    function Insert(const Index: Integer): IXMLFilterPreSetType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFilterPreSetType }

  TXMLFilterPreSetType = class(TXMLNode, IXMLFilterPreSetType)
  private
    FFilter: IXMLFilterType;
    FFilterGroup: IXMLFilterGroupTypeList;
  protected
    { IXMLFilterPreSetType }
    function Get_Name: Integer;
    function Get_Note: Integer;
    function Get_Filter: IXMLFilterType;
    function Get_FilterGroup: IXMLFilterGroupTypeList;
    procedure Set_Name(Value: Integer);
    procedure Set_Note(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFilterType }

  TXMLFilterType = class(TXMLNode, IXMLFilterType)
  protected
    { IXMLFilterType }
    function Get_OperatorLeftKind: Integer;
    function Get_OperatorLeftHint: UnicodeString;
    function Get_OperatorLeftValue: UnicodeString;
    function Get_OperatorRightKind: Integer;
    function Get_OperatorRightHint: Integer;
    function Get_OperatorRightValue: Integer;
    function Get_Operand: Integer;
    procedure Set_OperatorLeftKind(Value: Integer);
    procedure Set_OperatorLeftHint(Value: UnicodeString);
    procedure Set_OperatorLeftValue(Value: UnicodeString);
    procedure Set_OperatorRightKind(Value: Integer);
    procedure Set_OperatorRightHint(Value: Integer);
    procedure Set_OperatorRightValue(Value: Integer);
    procedure Set_Operand(Value: Integer);
  end;

{ TXMLFilterGroupType }

  TXMLFilterGroupType = class(TXMLNode, IXMLFilterGroupType)
  private
    FFilter: IXMLFilterType;
    FFilterGroup: IXMLFilterGroupTypeList;
  protected
    { IXMLFilterGroupType }
    function Get_GroupCondition: Integer;
    function Get_Filter: IXMLFilterType;
    function Get_FilterGroup: IXMLFilterGroupTypeList;
    procedure Set_GroupCondition(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFilterGroupTypeList }

  TXMLFilterGroupTypeList = class(TXMLNodeCollection, IXMLFilterGroupTypeList)
  protected
    { IXMLFilterGroupTypeList }
    function Add: IXMLFilterGroupType;
    function Insert(const Index: Integer): IXMLFilterGroupType;

    function Get_Item(Index: Integer): IXMLFilterGroupType;
  end;

{ Global Functions }

function GetFilterPreSets(Doc: IXMLDocument): IXMLFilterPreSetsType;
function LoadFilterPreSets(const FileName: string): IXMLFilterPreSetsType;
function NewFilterPreSets: IXMLFilterPreSetsType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetFilterPreSets(Doc: IXMLDocument): IXMLFilterPreSetsType;
begin
  Result := Doc.GetDocBinding('FilterPreSets', TXMLFilterPreSetsType, TargetNamespace) as IXMLFilterPreSetsType;
end;

function LoadFilterPreSets(const FileName: string): IXMLFilterPreSetsType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('FilterPreSets', TXMLFilterPreSetsType, TargetNamespace) as IXMLFilterPreSetsType;
end;

function NewFilterPreSets: IXMLFilterPreSetsType;
begin
  Result := NewXMLDocument.GetDocBinding('FilterPreSets', TXMLFilterPreSetsType, TargetNamespace) as IXMLFilterPreSetsType;
end;

{ TXMLFilterPreSetsType }

procedure TXMLFilterPreSetsType.AfterConstruction;
begin
  RegisterChildNode('FilterPreSet', TXMLFilterPreSetType);
  ItemTag := 'FilterPreSet';
  ItemInterface := IXMLFilterPreSetType;
  inherited;
end;

function TXMLFilterPreSetsType.Get_FilterPreSet(Index: Integer): IXMLFilterPreSetType;
begin
  Result := List[Index] as IXMLFilterPreSetType;
end;

function TXMLFilterPreSetsType.Add: IXMLFilterPreSetType;
begin
  Result := AddItem(-1) as IXMLFilterPreSetType;
end;

function TXMLFilterPreSetsType.Insert(const Index: Integer): IXMLFilterPreSetType;
begin
  Result := AddItem(Index) as IXMLFilterPreSetType;
end;

{ TXMLFilterPreSetType }

procedure TXMLFilterPreSetType.AfterConstruction;
begin
  RegisterChildNode('Filter', TXMLFilterType);
  RegisterChildNode('FilterGroup', TXMLFilterGroupType);
  FFilterGroup := CreateCollection(TXMLFilterGroupTypeList, IXMLFilterGroupType, 'FilterGroup') as IXMLFilterGroupTypeList;
  inherited;
end;

function TXMLFilterPreSetType.Get_Name: Integer;
begin
  Result := AttributeNodes['Name'].NodeValue;
end;

procedure TXMLFilterPreSetType.Set_Name(Value: Integer);
begin
  SetAttribute('Name', Value);
end;

function TXMLFilterPreSetType.Get_Note: Integer;
begin
  Result := AttributeNodes['Note'].NodeValue;
end;

procedure TXMLFilterPreSetType.Set_Note(Value: Integer);
begin
  SetAttribute('Note', Value);
end;

function TXMLFilterPreSetType.Get_Filter: IXMLFilterType;
begin
  Result := ChildNodes['Filter'] as IXMLFilterType;
end;

function TXMLFilterPreSetType.Get_FilterGroup: IXMLFilterGroupTypeList;
begin
  Result := FFilterGroup;
end;

{ TXMLFilterType }

function TXMLFilterType.Get_OperatorLeftKind: Integer;
begin
  Result := AttributeNodes['OperatorLeftKind'].NodeValue;
end;

procedure TXMLFilterType.Set_OperatorLeftKind(Value: Integer);
begin
  SetAttribute('OperatorLeftKind', Value);
end;

function TXMLFilterType.Get_OperatorLeftHint: UnicodeString;
begin
  Result := AttributeNodes['OperatorLeftHint'].Text;
end;

procedure TXMLFilterType.Set_OperatorLeftHint(Value: UnicodeString);
begin
  SetAttribute('OperatorLeftHint', Value);
end;

function TXMLFilterType.Get_OperatorLeftValue: UnicodeString;
begin
  Result := AttributeNodes['OperatorLeftValue'].Text;
end;

procedure TXMLFilterType.Set_OperatorLeftValue(Value: UnicodeString);
begin
  SetAttribute('OperatorLeftValue', Value);
end;

function TXMLFilterType.Get_OperatorRightKind: Integer;
begin
  Result := AttributeNodes['OperatorRightKind'].NodeValue;
end;

procedure TXMLFilterType.Set_OperatorRightKind(Value: Integer);
begin
  SetAttribute('OperatorRightKind', Value);
end;

function TXMLFilterType.Get_OperatorRightHint: Integer;
begin
  Result := AttributeNodes['OperatorRightHint'].NodeValue;
end;

procedure TXMLFilterType.Set_OperatorRightHint(Value: Integer);
begin
  SetAttribute('OperatorRightHint', Value);
end;

function TXMLFilterType.Get_OperatorRightValue: Integer;
begin
  Result := AttributeNodes['OperatorRightValue'].NodeValue;
end;

procedure TXMLFilterType.Set_OperatorRightValue(Value: Integer);
begin
  SetAttribute('OperatorRightValue', Value);
end;

function TXMLFilterType.Get_Operand: Integer;
begin
  Result := AttributeNodes['Operand'].NodeValue;
end;

procedure TXMLFilterType.Set_Operand(Value: Integer);
begin
  SetAttribute('Operand', Value);
end;

{ TXMLFilterGroupType }

procedure TXMLFilterGroupType.AfterConstruction;
begin
  RegisterChildNode('Filter', TXMLFilterType);
  RegisterChildNode('FilterGroup', TXMLFilterGroupType);
  FFilterGroup := CreateCollection(TXMLFilterGroupTypeList, IXMLFilterGroupType, 'FilterGroup') as IXMLFilterGroupTypeList;
  inherited;
end;

function TXMLFilterGroupType.Get_GroupCondition: Integer;
begin
  Result := AttributeNodes['GroupCondition'].NodeValue;
end;

procedure TXMLFilterGroupType.Set_GroupCondition(Value: Integer);
begin
  SetAttribute('GroupCondition', Value);
end;

function TXMLFilterGroupType.Get_Filter: IXMLFilterType;
begin
  Result := ChildNodes['Filter'] as IXMLFilterType;
end;

function TXMLFilterGroupType.Get_FilterGroup: IXMLFilterGroupTypeList;
begin
  Result := FFilterGroup;
end;

{ TXMLFilterGroupTypeList }

function TXMLFilterGroupTypeList.Add: IXMLFilterGroupType;
begin
  Result := AddItem(-1) as IXMLFilterGroupType;
end;

function TXMLFilterGroupTypeList.Insert(const Index: Integer): IXMLFilterGroupType;
begin
  Result := AddItem(Index) as IXMLFilterGroupType;
end;

function TXMLFilterGroupTypeList.Get_Item(Index: Integer): IXMLFilterGroupType;
begin
  Result := List[Index] as IXMLFilterGroupType;
end;

end.