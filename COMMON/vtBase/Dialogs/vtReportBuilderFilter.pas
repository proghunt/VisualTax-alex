unit vtReportBuilderFilter;

interface

uses
  System.Classes, System.Types, System.SysUtils, Vcl.Controls, VCL.StdCtrls, VCL.ExtCtrls,
  VCL.Buttons, VCL.Menus,
  Xml.XMLIntf, Xml.XMLDoc,
  System.Generics.Collections, vtDragAndDrop,
  Winapi.Windows, Winapi.Messages, Vcl.Graphics;

const
  UM_DROPSELF = WM_USER + 1;

type

  TEnumConverter = class
  public
    class function EnumToInt<T>(const enValue: T): Integer;
    class function EnumToString<T>(enValue: T): string;
    class procedure StringToEnum<T>(strValue:String; var enValue:T);
  end;

  TFilterCommonElement = class;

  IObserver = interface
  ['{6B24B2D8-D700-4FEE-811B-69F52AC749FB}']
    procedure UpdateObserver(Sender: TFilterCommonElement);
  end;

  ISubject = interface
  ['{3376A8F6-3818-4B2B-A073-A7278BE06512}']
    procedure RegisterObserver(aObserver: IObserver);
    procedure RemoveObserver(aObserver: IObserver);
    procedure NotifyObservers;
  end;


  TGroupCondition = (gcAND, gcOR);
  TOperand = (opEqual, opNotEqual, opGreat, opLess, opGreatOrEqual, opLessOrEqual,
    opStarts, opEnds, opContains, opEmpty, opNotEmpty);

  TOperatorKinds = set of TOperatorKind;

  TFilterElementKind = (fekNone, fekGroup, fekCondition);

  TFilterElements = TObjectList<TFilterCommonElement>;

  TFilterCommonElement = class(TComponent, ISubject)
  protected
    FObserverList: TList<IObserver>;
    FOwnerList: TFilterElements;
  public
    constructor Create(Owner: TComponent); override; //20170811 Igor
    destructor Destroy; override;
    procedure RegisterObserver(AObserver: IObserver);
    procedure RemoveObserver(AObserver: IObserver);
    procedure NotifyObservers;
    function Result: Boolean; virtual; abstract;
    function AsString: String; virtual; abstract;
    function HasConditionFilters(AOperatorKinds: TOperatorKinds): Boolean; virtual; abstract;
    procedure SaveToXML(ANode: IXMLNode); virtual; abstract;
    procedure LoadFromXML(ANode: IXMLNode); virtual; abstract;
  end;

  TFilterGroup = class(TFilterCommonElement)
  private
    FGroupCondition: TGroupCondition;
    FElements: TFilterElements;
    procedure SetGroupCondition(const Value: TGroupCondition);
    procedure ElementsNotify(Sender: TObject; const Item: TFilterCommonElement;
      Action: System.Generics.Collections.TCollectionNotification);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    constructor Create(Owner: TComponent); override;
    constructor CreateNew(Owner: TComponent; AList: TFilterElements);
    destructor Destroy; override;
    property Elements: TFilterElements read FElements;
    property GroupCondition: TGroupCondition read FGroupCondition write SetGroupCondition default gcAND;
    function Result: Boolean; override;
    function AsString: String; override;
    function AddGroup: Integer;
    function AddCondition: Integer;
    function HasConditionFilters(AOperatorKinds: TOperatorKinds): Boolean; override;
    procedure SaveToXML(ANode: IXMLNode); override;
    procedure LoadFromXML(ANode: IXMLNode); override;
    class function XMLIdentificator: String;
  end;

  TGetOperatorValueNotify = procedure(const AOperatorKind: TOperatorKind; const AOperatorLink: String; var AValue: String) of Object;
  TFilterCondition = class(TFilterCommonElement)
  private
    FOperatorLeftKind: TOperatorKind;
    FOperatorLeftValue: String;
    FOperatorRightKind: TOperatorKind;
    FOperatorRightValue: String;
    FOperand: TOperand;
    FOnGetOperatorValue: TGetOperatorValueNotify;
    procedure SetOnGetOperatorValue(const Value: TGetOperatorValueNotify);
    procedure SetOperand(const Value: TOperand);
    procedure SetOperatorLeftKind(const Value: TOperatorKind);
    procedure SetOperatorLeftValue(const Value: String);
    procedure SetOperatorRightKind(const Value: TOperatorKind);
    procedure SetOperatorRightValue(const Value: String);
  public
    constructor Create(Owner: TComponent); override;
    constructor CreateNew(Owner: TComponent; AList: TFilterElements);
    function Result: Boolean; override;
    function AsString: String; override;
    property OperatorLeftKind: TOperatorKind read FOperatorLeftKind write SetOperatorLeftKind;
    property OperatorLeftValue: String read FOperatorLeftValue write SetOperatorLeftValue;
    property OperatorRightKind: TOperatorKind read FOperatorRightKind write SetOperatorRightKind;
    property OperatorRightValue: String read FOperatorRightValue write SetOperatorRightValue;
    property Operand: TOperand read FOperand write SetOperand;
    property OnGetOperatorValue: TGetOperatorValueNotify read FOnGetOperatorValue write SetOnGetOperatorValue;
    procedure SetValues(AOperatorLeftKind: TOperatorKind;
      AOperatorLeftValue: Variant; AOperatorRightKind: TOperatorKind;
      AOperatorRightValue: Variant; AOperand: TOperand);
    function HasConditionFilters(AOperatorKinds: TOperatorKinds): Boolean; override;
    procedure SaveToXML(ANode: IXMLNode); override;
    procedure LoadFromXML(ANode: IXMLNode); override;
    class function XMLIdentificator: String;
  end;

  TFilterDisplay = class;

  TToolPanel = class(TPanel)
  protected
    FFilterDisplay: TFilterDisplay;
    FBtnDelete: TBitBtn;
    procedure BtnDeleteClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property BtnDelete: TBitBtn read FBtnDelete;
  end;

  TToolConditionPanel = class(TToolPanel)
  protected
  public
    constructor Create(AOwner: TComponent); override;

  end;

  TToolGroupPanel = class(TToolPanel)
  private
    procedure BtnGroupCondtionClick(Sender: TObject);
    procedure MenuItemGroupConditionClick(Sender: TObject);
  protected
    FBtnAddElement: TBitBtn;
    FPMAddElement: TPopupMenu;
    FBtnCondition: TBitBtn;
    FPMGroupCondition: TPopupMenu;
    procedure BtnAddElementClick(Sender: TObject);
    procedure MenuItemAddGroupClick(Sender: TObject);
    procedure MenuItemAddConditionClick(Sender: TObject);
    procedure Paint; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property BtnCondition: TBitBtn read FBtnCondition;
    property BtnAddElemen: TBitBtn read FBtnAddElement;
  end;

  TConditionPanelChangeEvent = procedure(AOperatorLeftKind: TOperatorKind;
    AOperatorLeftValue: Variant; AOperatorRightKind: TOperatorKind;
    AOperatorRightValue: Variant; AOperand: TOperand) of Object;

  TConditionPanel = class(TPanel)
  private
    FOperatorLeftKind: TComboBox;
    FOperatorLeftValue: TEdit;
    FOperatorRightKind: TCombobox;
    FOperatorRightValue: TEdit;
    FOperand: TCombobox;
    FOnControlsChange: TConditionPanelChangeEvent;
    FNoCallBack: Boolean;
    FMinWidth: Integer;
    procedure ControlChange(Sender: TObject);
    procedure DoChange;
    procedure InitControls;
    procedure FreeControls;
    procedure Resize; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateObserver(Sender: TFilterCondition);
    property OnControlsChange: TConditionPanelChangeEvent read FOnControlsChange write FOnControlsChange;
    property OperatorLeftKind: TComboBox read FOperatorLeftKind;
    property OperatorLeftValue: TEdit read FOperatorLeftValue;
    property OperatorRightKind: TCombobox read FOperatorRightKind;
    property OperatorRightValue: TEdit read FOperatorRightValue;
  end;

  TFilterDisplay = class(TPanel, IObserver, IDragTarget)
  private
    FFilterElement: TFilterCommonElement;
    FFilterElementKind: TFilterElementKind;
    FToolPanel: TToolPanel;
    FConditionPanel: TConditionPanel;
    FChildDisplays: TList<TFilterDisplay>;
    FRoot: Boolean;
    FOnGetOperatorValue: TGetOperatorValueNotify;
    FDragAccepted: Boolean;
    procedure SetFilterElement(const Value: TFilterCommonElement);
    procedure Clear;
    procedure RemoveToolPanel;
    procedure AddToolPanel(AFilterElementKind: TFilterElementKind);
    procedure AddGroupToolPanel;
    procedure AddConditionToolPanel;
    function GetGroupCondition: TGroupCondition;
    procedure SetGroupCondition(const Value: TGroupCondition);
    procedure ConditionPanelControlChange(AOperatorLeftKind: TOperatorKind;
      AOperatorLeftValue: Variant; AOperatorRightKind: TOperatorKind;
      AOperatorRightValue: Variant; AOperand: TOperand);
    procedure SetOnGetOperatorValue(const Value: TGetOperatorValueNotify);
    function AddEmpty: TFilterDisplay;
    procedure ElementDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure btnAddDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure EditLeftValueDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure EditRightValueDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure DragEnter;
    procedure DragLeave;
    function GetDropRect: TRect;
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    property GroupCondition: TGroupCondition read GetGroupCondition write SetGroupCondition;
    procedure ResizeMe(ARecalcParent: Boolean = True);
    procedure DropSelf(var Message: TMessage); message UM_DROPSELF;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateAsRoot(AOwner: TComponent);
    destructor Destroy; override;
    procedure UpdateObserver(Sender: TFilterCommonElement);
    procedure AddCondition;
    procedure AddGroup;
    property FilterElement: TFilterCommonElement read FFilterElement write SetFilterElement;
    property OnGetOperatorValue: TGetOperatorValueNotify read FOnGetOperatorValue write SetOnGetOperatorValue;
    procedure SaveToXML(ANode: IXMLNode);
    procedure LoadFromXML(ANode: IXMLNode);
    property ChildDisplays: TList<TFilterDisplay> read FChildDisplays;
  end;

implementation

uses
  System.Variants, System.StrUtils, System.Math, TypInfo;

const
  c_toolPanelWidth = 35;
  c_MinDisplayHeight = 42;
  GroupConditionStr: Array[TGroupCondition] of String = ('AND', 'OR');
  OperatorKindStr: Array[TOperatorKind] of string = ('DB field', 'Form field', 'Const');
  OperandStr: array[TOperand] of string = ('=', '<>', '>', '<', '>=', '<=',
    'Starts', 'Ends', 'Contains',
    'Is empty', 'Is not empty');
  NoRightValueOperands: set of TOperand = [opEmpty, opNotEmpty];
{ TFilterCommonElement }

constructor TFilterCommonElement.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FObserverList := TList<IObserver>.Create;
end;

destructor TFilterCommonElement.Destroy;
begin
  FObserverList.Free;
  inherited;
end;

procedure TFilterCommonElement.NotifyObservers;
var
  Observer: IObserver;
begin
  for Observer in FObserverList do
    Observer.UpdateObserver(Self);
end;

procedure TFilterCommonElement.RegisterObserver(AObserver: IObserver);
begin
  if FObserverList.IndexOf(AObserver) = -1 then
    FObserverList.Add(AObserver);
end;

procedure TFilterCommonElement.RemoveObserver(AObserver: IObserver);
begin
  FObserverList.Remove(AObserver);
end;

{ TFilterGroup }

function TFilterGroup.AddCondition: Integer;
begin
  Result := FElements.Add(TFilterCondition.CreateNew(Self, FElements));
end;

function TFilterGroup.AddGroup: Integer;
begin
  Result := FElements.Add(TFilterGroup.CreateNew(Self, FElements));
end;

function TFilterGroup.AsString: String;
var
  E: TFilterCommonElement;
begin
  Result := '( ';
  for E in FElements do
  begin
    Result := Result + E.AsString;
    if E <> FElements.Last then
      Result := Result + ' ' + GroupConditionStr[FGroupCondition] + ' ';
  end;
  Result := Result + ' )';
end;

constructor TFilterGroup.Create(Owner: TComponent);
begin
  inherited Create(Owner);
  FElements := TFilterElements.Create(False);
  FElements.OnNotify := ElementsNotify;
  FGroupCondition := gcAND;
end;

constructor TFilterGroup.CreateNew(Owner: TComponent; AList: TFilterElements);
begin
  Create(Owner);
  FOwnerList := AList;
end;

destructor TFilterGroup.Destroy;
var
  I: Integer;
begin
  if Assigned(FOwnerList) then
    FOwnerList.Remove(Self);
  While FElements.Count > 0 do
    FElements[0].Free;
  FElements.Free;
  inherited;
end;

procedure TFilterGroup.ElementsNotify(Sender: TObject;
  const Item: TFilterCommonElement;
  Action: System.Generics.Collections.TCollectionNotification);
begin
  NotifyObservers;
end;

function TFilterGroup.HasConditionFilters(AOperatorKinds: TOperatorKinds): Boolean;
var
  FE: TFilterCommonElement;
begin
  for FE in FElements do
    if FE.HasConditionFilters(AOperatorKinds) then
      Exit(True);
  Result := False;
end;

procedure TFilterGroup.LoadFromXML(ANode: IXMLNode);
begin
  if ANode = nil then
    exit;
  if ANode.AttributeNodes.FindNode('GroupCondition') <> nil then
    try
      TEnumConverter.StringToEnum<TGroupCondition>(VarToStr(ANode.Attributes['GroupCondition']), FGroupCondition)
    except
    end;
end;

procedure TFilterGroup.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) then
  begin
    if Assigned(FElements) AND (AComponent is TFilterCommonElement) AND FElements.Contains(TFilterCommonElement(AComponent)) then
      FElements.Remove(TFilterCommonElement(AComponent));
  end;
end;

function TFilterGroup.Result: Boolean;
var
  E: TFilterCommonElement;
begin
  case FGroupCondition of
    gcAND:
      begin
        Result := True;
        for E in FElements do
        begin
          Result := Result AND E.Result;
          if Not Result then
            Break;
        end;
      end;
    gcOR:
      begin
        Result := False;
        for E in FElements do
        begin
          Result := Result OR E.Result;
          if Result then
            Break;
        end;
      end
//20170811 Igor>>>
  else
    Result := False;
//20170811 Igor<<<
  end;
end;

procedure TFilterGroup.SaveToXML(ANode: IXMLNode);
begin
  ANode.Attributes['Kind'] := TFilterGroup.XMLIdentificator;
  ANode.Attributes['GroupCondition'] := TEnumConverter.EnumToString<TGroupCondition>(FGroupCondition);
end;

procedure TFilterGroup.SetGroupCondition(const Value: TGroupCondition);
begin
  if FGroupCondition <> Value then
  begin
    FGroupCondition := Value;
    NotifyObservers;
  end;
end;

class function TFilterGroup.XMLIdentificator: String;
begin
  Result := 'FilterGroup';
end;

{ TFilterCondition }

function TFilterCondition.AsString: String;
begin
  Result := '';
  case FOperatorLeftKind of
    okDBField, okFormField:
      Result := Result + OperatorKindStr[FOperatorLeftKind] + ' ';
  end;
  Result := Result + '"' + FOperatorLeftValue + '" ' + OperandStr[FOperand];
  if not (FOperand in NoRightValueOperands) then
  begin
    case FOperatorRightKind of
      okDBField, okFormField:
        Result := Result + ' ' + OperatorKindStr[FOperatorRightKind];
    end;
    Result := Result + ' "' + FOperatorRightValue + '"';
  end;
end;

constructor TFilterCondition.Create(Owner: TComponent);
begin
  inherited;
  FOperatorLeftKind := TOperatorKind.okFormField;
  FOperatorLeftValue := '';
  FOperatorRightKind := TOperatorKind.okConst;
  FOperatorRightValue := '';
  FOperand := TOperand.opEqual;
end;

constructor TFilterCondition.CreateNew(Owner: TComponent;
  AList: TFilterElements);
begin
  Create(Owner);
  FOwnerList := AList;
end;

function TFilterCondition.HasConditionFilters(AOperatorKinds: TOperatorKinds): Boolean;
begin
  if AOperatorKinds = [] then
    Result := True
  else
  begin
    Result := False;
    if okDBField in AOperatorKinds then
      Result := (FOperatorLeftKind = okDBField) or (FOperatorRightKind = okDBField);
    if Result then
      exit;
    if okFormField in AOperatorKinds then
      Result := (FOperatorLeftKind = okFormField) or (FOperatorRightKind = okFormField);
    if Result then
      exit;
    if okConst in AOperatorKinds then
      Result := (FOperatorLeftKind = okConst) or (FOperatorRightKind = okConst);
  end;
end;

procedure TFilterCondition.LoadFromXML(ANode: IXMLNode);
begin
  if ANode = nil then
    exit;
  if ANode.AttributeNodes.FindNode('OperatorLeftKind') <> nil then
    try
      TEnumConverter.StringToEnum<TOperatorKind>(VarToStr(ANode.Attributes['OperatorLeftKind']), FOperatorLeftKind)
    except
    end;
  if ANode.AttributeNodes.FindNode('OperatorLeftValue') <> nil then
    try
      OperatorLeftValue :=VarToStr(ANode.Attributes['OperatorLeftValue']);
    except
    end;
  if ANode.AttributeNodes.FindNode('OperatorRightKind') <> nil then
    try
      TEnumConverter.StringToEnum<TOperatorKind>(VarToStr(ANode.Attributes['OperatorRightKind']), FOperatorRightKind)
    except
    end;
  if ANode.AttributeNodes.FindNode('OperatorRightValue') <> nil then
    try
      OperatorRightValue := VarToStr(ANode.Attributes['OperatorRightValue'])
    except
    end;
  if ANode.AttributeNodes.FindNode('Operand') <> nil then
    try
      TEnumConverter.StringToEnum<TOperand>(VarToStr(ANode.Attributes['Operand']), FOperand)
    except
    end;
  NotifyObservers;
end;

function myCompare(AVal1, AVal2: String): Integer;
var
  VReal1, VReal2: Extended;
  VDate1, VDate2: TDateTime;
  VInt1, VInt2: Integer;
  function myTryStrToDate(const AStr: string; var ADAte: TDateTime): Boolean;
  var
    s, s1, s2, s3: string;
    w, wY, wM, wD: Integer;
    I: Integer;
    function IsYear(AStr: String): Boolean;
    var
      Y: Integer;
    begin
      Result := TryStrToInt(AStr, Y);
      if Result then
        Result := (Length(AStr) = 4) or
                  ((Y > 31) and
                   (Y < 2100));
    end;
    function IsDay(AStr: String): Boolean;
    var
      D: Integer;
    begin
      Result := TryStrToInt(AStr, D);
      if Result then
        Result := (Length(AStr) >= 1) and
                  (Length(AStr) <= 2) AND
                  (D > 12);
    end;
  begin
    if Length(AStr) < 8 then
      Exit(False);
    try  
      s1 := '';
      s2 := '';
      s3 := '';
    
      S := '';
      w := 0;
      for I := 1 to Length(AStr) do
        if CharInSet(AStr[I], ['0','1','2','3','4','5','6','7','8','9']) then
          S := S + AStr[I]
        else
        begin    
          case w of
            0: s1 := s;
            1: s2 := s;
            2: s3 := s;
          end;
          s := '';
          inc(w);
        end;
      if Trim(s) <> '' then
        case w of
          0: s1 := s;
          1: s2 := s;
          2: s3 := s;
        end;
      if (Length(s1) = 8) and (s2 = '') then
      begin
        s2 := Copy(s1, 5, 2);
        s3 := Copy(s1, 7, 2);
        s1 := Copy(s1, 1, 4);
      end;
      
      if IsYear(s1) then
      begin
        wY := StrToInt(s1);
        if isDay(s2) then
        begin
          wD := StrToInt(s2);
          wM := StrToInt(s3);
        end
        else
        begin
          wD := StrToInt(s3);
          wM := StrToInt(s2);
        end;
      end
      else
      if IsYear(s3) then
      begin
        wY := StrToInt(s3);
        if isDay(s2) then
        begin
          wD := StrToInt(s2);
          wM := StrToInt(s1);
        end
        else
        begin
          wD := StrToInt(s1);
          wM := StrToInt(s2);
        end;
      end
      else
      if IsYear(s2) then
      begin
        wY := StrToInt(s2);
        if isDay(s1) then
        begin
          wD := StrToInt(s1);
          wM := StrToInt(s3);
        end
        else
        begin
          wD := StrToInt(s3);
          wM := StrToInt(s1);
        end;
      end
      else
        exit(False);//20170811 Igor
      try
        ADAte := EncodeDate(wY, wM, wD);
        Result := True;
      except
        Result := False;
      end;
    except
      Result := False;
    end;  
  end;
  function myTryStrToInt(const AStr: String; var AValue: Integer): Boolean;
  begin
    if AStr = '' then
    begin
      AValue := 0;
      Result := True;
    end
    else
      Result := TryStrToInt(AStr, AValue);
  end;
  function myTryStrToFloat(const AStr: String; var AValue: Extended): Boolean;
  begin
    if AStr = '' then
    begin
      AValue := 0;
      Result := True;
    end
    else
      Result := TryStrToFloat(AStr, AValue);
  end;
begin
  if myTryStrToInt(trim(AVal1), VInt1) AND
     myTryStrToInt(trim(AVal2), VInt2) then
    Result := CompareValue(VInt1, VInt2)
  else
  if myTryStrToFloat(trim(AVal1), VReal1) AND
     myTryStrToFloat(trim(AVal2), VReal2) then
    Result := CompareValue(VReal1, VReal2)
  else
  if myTryStrToDate(trim(AVal1), VDate1) AND
     myTryStrToDate(trim(AVal2), VDate2) then
    Result := CompareValue(VDate1, VDate2)
  else
    Result := CompareStr(AVal1, AVal2);
end;

function TFilterCondition.Result: Boolean;
var
  LeftValue, RightValue: String;
begin
  LeftValue := FOperatorLeftValue;
  case FOperatorLeftKind of
    okDBField, okFormField:
      begin
        if Assigned(FOnGetOperatorValue) then
          FOnGetOperatorValue(FOperatorLeftKind, FOperatorLeftValue, LeftValue);
      end;
  end;
  RightValue := FOperatorRightValue;
  case FOperatorRightKind of
    okDBField, okFormField:
      begin
        if Assigned(FOnGetOperatorValue)  then
          FOnGetOperatorValue(FOperatorRightKind, FOperatorRightValue, RightValue);
      end;
  end;
  case FOperand of
    opEqual: Result := myCompare(LeftValue, RightValue) = EqualsValue;
    opNotEqual: Result := myCompare(LeftValue, RightValue) <> EqualsValue;
    opGreat: Result := myCompare(LeftValue, RightValue) >= GreaterThanValue;
    opLess: Result := myCompare(LeftValue, RightValue) <= LessThanValue;
    opGreatOrEqual: Result := myCompare(LeftValue, RightValue) >= EqualsValue;
    opLessOrEqual: Result := myCompare(LeftValue, RightValue) <= EqualsValue;
    opStarts: Result := StartsStr(RightValue, LeftValue);
    opEnds: Result := EndsStr(RightValue, LeftValue);
    opContains: Result := ContainsStr(LeftValue, RightValue);
    opEmpty: Result := LeftValue.IsEmpty;
    opNotEmpty: Result := not LeftValue.IsEmpty;
  else
    Result := false;
  end;

end;

procedure TFilterCondition.SaveToXML(ANode: IXMLNode);
begin
  ANode.Attributes['Kind'] := TFilterCondition.XMLIdentificator;
  ANode.Attributes['OperatorLeftKind'] := TEnumConverter.EnumToString<TOperatorKind>(OperatorLeftKind);
  ANode.Attributes['OperatorLeftValue'] := OperatorLeftValue;
  ANode.Attributes['OperatorRightKind'] := TEnumConverter.EnumToString<TOperatorKind>(OperatorRightKind);
  ANode.Attributes['OperatorRightValue'] := OperatorRightValue;
  ANode.Attributes['Operand'] := TEnumConverter.EnumToString<TOperand>(Operand);
end;

procedure TFilterCondition.SetOnGetOperatorValue(
  const Value: TGetOperatorValueNotify);
begin
  FOnGetOperatorValue := Value;
end;

procedure TFilterCondition.SetOperand(const Value: TOperand);
begin
  if FOperand <> Value then
  begin
    FOperand := Value;
    NotifyObservers;
  end;
end;

procedure TFilterCondition.SetOperatorLeftKind(const Value: TOperatorKind);
begin
  if FOperatorLeftKind <> Value then
  begin
    FOperatorLeftKind := Value;
    NotifyObservers;
  end;
end;

procedure TFilterCondition.SetOperatorLeftValue(const Value: String);
begin
  if FOperatorLeftValue <> Value then
  begin
    FOperatorLeftValue := Value;
    NotifyObservers;
  end;
end;

procedure TFilterCondition.SetOperatorRightKind(const Value: TOperatorKind);
begin
  if FOperatorRightKind <> Value then
  begin
    FOperatorRightKind := Value;
    NotifyObservers;
  end;
end;

procedure TFilterCondition.SetOperatorRightValue(const Value: String);
begin
  if FOperatorRightValue <> Value then
  begin
    FOperatorRightValue := Value;
    NotifyObservers;
  end;
end;

procedure TFilterCondition.SetValues(AOperatorLeftKind: TOperatorKind;
  AOperatorLeftValue: Variant; AOperatorRightKind: TOperatorKind;
  AOperatorRightValue: Variant; AOperand: TOperand);
begin
  FOperatorLeftKind := AOperatorLeftKind;
  FOperatorLeftValue := AOperatorLeftValue;
  FOperatorRightKind := AOperatorRightKind;
  FOperatorRightValue := AOperatorRightValue;
  FOperand := AOperand;
  NotifyObservers;
end;

class function TFilterCondition.XMLIdentificator: String;
begin
  Result := 'FilterCondition';
end;

{ TFilterGroupDisplay }

procedure TFilterDisplay.AddConditionToolPanel;
begin
  FToolPanel := TToolConditionPanel.Create(Self);
  FConditionPanel := TConditionPanel.Create(Self);
  with FConditionPanel do
  begin
    Left := FToolPanel.Left + FToolPanel.Width;
    Top := 0;
    OnControlsChange := ConditionPanelControlChange;
    OperatorLeftKind.OnDragOver := ElementDragOver;
    OperatorLeftKind.OnDragDrop := EditLeftValueDragDrop;
    OperatorLeftValue.OnDragOver := ElementDragOver;
    OperatorLeftValue.OnDragDrop := EditLeftValueDragDrop;
    OperatorRightKind.OnDragOver := ElementDragOver;
    OperatorRightKind.OnDragDrop := EditRightValueDragDrop;
    OperatorRightValue.OnDragOver := ElementDragOver;
    OperatorRightValue.OnDragDrop := EditRightValueDragDrop;
  end;
  Self.Width := FConditionPanel.Left + FConditionPanel.Width;
  ResizeMe;
end;

procedure TFilterDisplay.AddGroup;
var
  FD: TFilterDisplay;
  I: Integer;
begin
  if FFilterElement is TFilterGroup then
  begin
    I := TFilterGroup(FFilterElement).AddGroup;
    FD := AddEmpty;
    FD.FilterElement := TFilterGroup(FFilterElement).FElements[i];
    ResizeMe;
  end;
end;

function TFilterDisplay.AddEmpty: TFilterDisplay;
begin
  Result := TFilterDisplay.Create(Self);
  Result.Parent := Self;
  Result.Left := FToolPanel.Left + FToolPanel.Width;
  Result.OnGetOperatorValue := FOnGetOperatorValue;
  if FChildDisplays.Count = 0 then
    Result.Top := 0
  else
    Result.Top := FChildDisplays.Last.Top + FChildDisplays.Last.Height;
  FChildDisplays.Add(Result);
end;

procedure TFilterDisplay.AddCondition;
var
  i: Integer;
  FD: TFilterDisplay;
begin
  if FFilterElement is TFilterGroup then
  begin
    I := TFilterGroup(FFilterElement).AddCondition;
    FD := AddEmpty;
    FD.FilterElement := TFilterGroup(FFilterElement).FElements[i];
    (FD.FilterElement as TFilterCondition).OnGetOperatorValue := FOnGetOperatorValue;
    ResizeMe;
  end;
end;

procedure TFilterDisplay.AddGroupToolPanel;
begin
  FToolPanel := TToolGroupPanel.Create(Self);
  with TToolGroupPanel(FToolPanel) do
  begin
    BtnAddElemen.OnDragOver := ElementDragOver;
    BtnAddElemen.OnDragDrop := btnAddDragDrop;
    OnDragOver := ElementDragOver;
    OnDragDrop := btnAddDragDrop;
  end;
  Self.OnDragOver := ElementDragOver;
  Self.OnDragDrop := btnAddDragDrop;
end;

procedure TFilterDisplay.AddToolPanel(AFilterElementKind: TFilterElementKind);
begin
  if (FFilterElementKind = AFilterElementKind) AND Assigned(FtoolPanel) then
    exit;
  RemoveToolPanel;
  FFilterElementKind := AFilterElementKind;
  case FFilterElementKind of
    fekGroup:
      AddGroupToolPanel;
    fekCondition:
      AddConditionToolPanel;
  end;
  if Assigned(FToolPanel) and FRoot then
    FtoolPanel.BtnDelete.Visible := False;
end;

procedure TFilterDisplay.btnAddDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  I: IDragTarget;
begin
  if Source is TDragElement then
  begin
    AddCondition;
    TFilterCondition(FChildDisplays.Last.FFilterElement).OperatorLeftKind :=
      TDragElement(Source).ElementKind;
    TFilterCondition(FChildDisplays.Last.FFilterElement).OperatorLeftValue :=
      TDragElement(Source).ElementFullName;
    if Sender.GetInterface(IDragTarget, I) then
      I.DragLeave;
  end;
end;

procedure TFilterDisplay.ElementDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  I: IDragTarget;
begin
  Accept := Source is TDragElement;
  if Accept AND Sender.GetInterface(IDragTarget, I) then
  begin
    case State of
      TDragState.dsDragEnter: I.DragEnter;
      TDragState.dsDragLeave: I.DragLeave;
      TDragState.dsDragMove: ;
    end;
  end;
end;

procedure TFilterDisplay.Clear;
begin
  RemoveToolPanel;
  while FChildDisplays.Count > 0 do
    FChildDisplays[0].Free;
  FChildDisplays.Clear;
  freeAndNil(FFilterElement);
  FFilterElementKind := fekNone;
end;

procedure TFilterDisplay.ConditionPanelControlChange(
  AOperatorLeftKind: TOperatorKind; AOperatorLeftValue: Variant;
  AOperatorRightKind: TOperatorKind; AOperatorRightValue: Variant;
  AOperand: TOperand);
begin
  if Assigned(FFilterElement) AND (FFilterElement is TFilterCondition) then
    TFilterCondition(FFilterElement).SetValues(AOperatorLeftKind, AOperatorLeftValue,
      AOperatorRightKind, AOperatorRightValue, AOperand);
end;

constructor TFilterDisplay.Create(AOwner: TComponent);
begin
  inherited;
  FRoot := False;
  FChildDisplays := TList<TFilterDisplay>.Create;
  UpdateObserver(nil);
end;

constructor TFilterDisplay.CreateAsRoot(AOwner: TComponent);
begin
  Create(AOwner);
  FRoot := True;
  ResizeMe;
end;

destructor TFilterDisplay.Destroy;
begin
  Clear;
  FreeAndNil(FChildDisplays);
  inherited;
end;

procedure TFilterDisplay.DragEnter;
begin
  FDragAccepted := True;
  Repaint;
end;

procedure TFilterDisplay.DragLeave;
begin
  if not FDragAccepted then
    Exit;
  FDragAccepted := False;
  Repaint;
end;

procedure TFilterDisplay.DropSelf(var Message: TMessage);
begin
  Self.Destroy;
end;

procedure TFilterDisplay.EditLeftValueDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if Source is TDragElement then
  begin
    if FFilterElement is TFilterCondition then
    begin
      TFilterCondition(FFilterElement).OperatorLeftKind := TDragElement(Source).ElementKind;
      TFilterCondition(FFilterElement).OperatorLeftValue := TDragElement(Source).ElementFullName;
    end;
  end;
end;

procedure TFilterDisplay.EditRightValueDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if Source is TDragElement then
  begin
    if FFilterElement is TFilterCondition then
    begin
      TFilterCondition(FFilterElement).OperatorRightKind := TDragElement(Source).ElementKind;
      TFilterCondition(FFilterElement).OperatorRightValue := TDragElement(Source).ElementFullName;
    end;
  end;
end;

function TFilterDisplay.GetGroupCondition: TGroupCondition;
begin
  if not Assigned(FFilterElement) or not (FFilterElement is TFilterGroup) then
    Result := gcAND
  else
    Result := (FFilterElement as TFilterGroup).GroupCondition;
end;


procedure TFilterDisplay.LoadFromXML(ANode: IXMLNode);
var
  N: IXMLNode;
  FD: TFilterDisplay;
begin
  if ANode = nil then
    exit;
  if ANode.NodeName <> 'Filter' then
    exit;
  Clear;
  if assigned(Parent) AND (Parent is TFilterDisplay) AND (TFilterDisplay(Parent).FFilterElement is TFilterGroup) then
  begin
    with TFilterGroup(TFilterDisplay(Parent).FFilterElement) do
    begin
      if VarToStr(ANode.Attributes['Kind']) = TFilterGroup.XMLIdentificator then
        FilterElement := Elements[AddGroup]
      else
      if VarToStr(ANode.Attributes['Kind']) = TFilterCondition.XMLIdentificator then
        FilterElement := Elements[AddCondition]
      else
        exit;
    end;
  end
  else
  begin
    if VarToStr(ANode.Attributes['Kind']) = TFilterGroup.XMLIdentificator then
      FilterElement := TFilterGroup.Create(Self)
    else
    if VarToStr(ANode.Attributes['Kind']) = TFilterCondition.XMLIdentificator then
      FilterElement := TFilterCondition.Create(Self)
    else
      exit;
  end;
  FilterElement.LoadFromXML(ANode);
  if FilterElement is TFilterCondition then
    TFilterCondition(FilterElement).OnGetOperatorValue := FOnGetOperatorValue;
  N := ANode.ChildNodes.First;
  while N <> nil do
  Begin
    FD := AddEmpty;
    FD.LoadFromXML(N);
    N := N.NextSibling;
  End;
  ResizeMe;
end;

procedure TFilterDisplay.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) then
  begin
    if (AComponent = FFilterElement) then
      FilterElement := nil
    else
    if Assigned(FChildDisplays) AND (AComponent is TFilterDisplay) AND FChildDisplays.Contains(TFilterDisplay(AComponent)) then
    begin
      FChildDisplays.Remove(TFilterDisplay(AComponent));
      ResizeMe;
    end;
  end;
end;
function TFilterDisplay.GetDropRect: TRect;
begin
  if FChildDisplays.Count = 0 then
    Result := Rect(FToolPanel.Left + FToolPanel.Width, ClientRect.Top, ClientRect.Right, ClientRect.Bottom)
  else
    Result := Rect(FToolPanel.Left + FToolPanel.Width, FChildDisplays.Last.Top + FChildDisplays.Last.Height,
      ClientRect.Right, ClientRect.Bottom);
end;

procedure TFilterDisplay.Paint;
var
  R: TRect;
  P: TPoint;
  OldPenStyle: TPenStyle;
  OldPenColor: TColor;
  OldBrushColor: TColor;
const
  c_DropHere = 'Drop here to create a new condition.';
begin
  inherited;
  if not FDragAccepted then
    Exit;
  R := GetDropRect;
  OldPenStyle := Canvas.Pen.Style;
  OldPenColor := Canvas.Pen.Color;
  OldBrushColor := Canvas.Brush.Color;
  try
    Canvas.Pen.Style := psDash;
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color := $00B5FBF9;
    Canvas.FillRect(R);
    Canvas.Rectangle(R);
    P.X := (R.Width - Canvas.TextWidth(c_DropHere)) div 2;
    P.Y := (R.Height - Canvas.TextHeight(c_DropHere)) div 2;
    Canvas.TextOut(R.Left + P.X, R.Top + P.Y, c_DropHere);
  finally
    Canvas.Pen.Style := OldPenStyle;
    Canvas.Pen.Color := OldPenColor;
    Canvas.Brush.Color := OldBrushColor;
  end;

end;

procedure TFilterDisplay.RemoveToolPanel;
begin
  FreeAndNil(FToolPanel);
  FreeAndNil(FConditionPanel);
  Self.OnDragOver := nil;
  Self.OnDragDrop := nil;
end;

procedure TFilterDisplay.ResizeMe(ARecalcParent: Boolean = True);
var
  FD: TFilterDisplay;
  Y: Integer;
begin
  if Assigned(Parent) and (Parent is TFilterDisplay) AND ARecalcParent then
    (Parent as TFilterDisplay).ResizeMe
  else
  begin
    Y := 0;
    for FD in FChildDisplays do
    begin
      FD.ResizeMe(False);
      FD.Top := Y;
      Y := Y + FD.Height;
      if Assigned(FToolPanel) then
        Self.Width := Max(Self.Width, FD.Width + FToolPanel.Width + 1)
      else
        Self.Width := Max(Self.Width, FD.Width + c_toolPanelWidth + 1);
    end;
    Self.Height := Max(Y, c_MinDisplayHeight);
    if (FFilterElement is TFilterGroup) or FRoot then
      Self.Height := Self.Height + 12;
  end;
end;

procedure TFilterDisplay.SaveToXML(ANode: IXMLNode);
var
  N: IXMLNode;
  FD: TFilterDisplay;
begin
  if ANode = nil then
    exit;
  N := ANode.AddChild('Filter');
  if FFilterElement <> nil then
    FFilterElement.SaveToXML(N);
  for FD in FChildDisplays do
    FD.SaveToXML(N);
end;

procedure TFilterDisplay.SetFilterElement(const Value: TFilterCommonElement);
begin
  if FFilterElement <> Value then
  begin
    if Assigned(FFilterElement) then
      FFilterElement.RemoveObserver(Self);
    FFilterElement := Value;
    FFilterElement.FreeNotification(Self);
    if Assigned(FFilterElement) then
      FFilterElement.RegisterObserver(Self);
    UpdateObserver(FFilterElement);
  end;
end;

procedure TFilterDisplay.SetGroupCondition(const Value: TGroupCondition);
begin
  if Assigned(FFilterElement) AND (FFilterElement is TFilterGroup) then
    (FFilterElement as TFilterGroup).GroupCondition := Value;
end;

procedure TFilterDisplay.SetOnGetOperatorValue(
  const Value: TGetOperatorValueNotify);
var
  FD: TFilterDisplay;
begin
  FOnGetOperatorValue := Value;
  if Assigned(FFilterElement) AND (FFilterElement is TFilterCondition) then
    TFilterCondition(FFilterElement).OnGetOperatorValue := Value;
  for FD in FChildDisplays do
    FD.OnGetOperatorValue := Value;
end;

procedure TFilterDisplay.UpdateObserver(Sender: TFilterCommonElement);
begin
  if Sender = nil then
    Clear
  else
  begin
    if Sender is TFilterGroup then
    begin
      if (FFilterElementKind <> fekGroup) or not assigned(FToolPanel) then
        AddToolPanel(fekGroup);
      TToolGroupPanel(FToolPanel).BtnCondition.Caption := GroupConditionStr[(Sender as TFilterGroup).GroupCondition];
    end
    else
    if Sender is TFilterCondition then
    begin
      if (FFilterElementKind <> fekCondition) or not assigned(FToolPanel) then
        AddToolPanel(fekCondition);
      FConditionPanel.UpdateObserver(TFilterCondition(Sender));
    end;
  end;
end;


{ TToolPanel }

procedure TToolPanel.BtnDeleteClick(Sender: TObject);
begin
  if Assigned(FFilterDisplay) then
    PostMessage(FFilterDisplay.Handle, UM_DROPSELF, 0, 0);
end;

constructor TToolPanel.Create(AOwner: TComponent);
begin
  inherited;
  if AOwner is TFilterDisplay then
  begin
    FFilterDisplay := AOwner as TFilterDisplay;
    Parent := FFilterDisplay;
    Align := alLeft;
    Width := c_toolPanelWidth;
    FBtnDelete := TBitBtn.Create(Self);
    with FBtnDelete do
    begin
      Parent := Self;
      //Flat := True;
      Caption := 'X';
      ShowHint := True;
      OnClick := BtnDeleteClick;
      SetBounds(1, Self.Height - 1 - 16, 16, 16);
      Anchors := [akLeft, akBottom];
    end;
  end;
end;

destructor TToolPanel.Destroy;
begin
  FreeAndNil(FBtnDelete);
  inherited;
end;

{ TToolConditionPanel }

constructor TToolConditionPanel.Create(AOwner: TComponent);
begin
  inherited;
  Width := FBtnDelete.Left + FBtnDelete.Width + 1;
  BtnDelete.Hint := 'Delete this condition';
end;

{ TToolGroupPanel }

constructor TToolGroupPanel.Create(AOwner: TComponent);
var
  mi: TMenuItem;
  gc: TGroupCondition;
begin
  inherited;
  BtnDelete.Hint := 'Delete this group of conditions';
  if FFilterDisplay <> nil then
  begin
    FBtnAddElement := TBitBtn.Create(Self);
    with FBtnAddElement do
    begin
      Parent := Self;
      //Flat := True;
      Caption := '+';
      ShowHint := True;
      Hint := 'Create new condition or group of conditions';
      OnClick := BtnAddElementClick;
      SetBounds(18, Self.Height - 1 - 16, 16, 16);
      Anchors := [akLeft, akBottom];
    end;

    FPMAddElement := TPopupMenu.Create(Self);
    mi := TMenuItem.Create(Self);
    mi.Caption := 'New group of conditions (e.g. [Prov = "MB" AND City="WINNIPEG"])';
    mi.Hint := 'New group of conditions (e.g. [Prov = "MB" AND City="WINNIPEG"])';
    mi.OnClick := MenuItemAddGroupClick;
    FPMAddElement.Items.Add(mi);
    mi := TMenuItem.Create(Self);
    mi.Caption := 'New condition (e.g. Maried = "X")';
    mi.Hint := 'New condition (e.g. Maried = "X")';
    mi.OnClick := MenuItemAddConditionClick;
    FPMAddElement.Items.Add(mi);

    FBtnCondition := TBitBtn.Create(Self);
    with FBtnCondition do
    begin
      Parent := Self;
      //Flat := True;
      ShowHint := True;
      Hint := 'Change the condition for the group';
      Caption := GroupConditionStr[FFilterDisplay.GroupCondition];
      OnClick := BtnGroupCondtionClick;
      SetBounds((Self.Width - 24) div 2, (Self.Height - 16) div 2, 24, 16);
      Anchors := [akLeft, akBottom];
    end;
    FPMGroupCondition := TPopupMenu.Create(Self);
    for GC := Low(TGroupCondition) to High(TGroupCondition) do
    begin
      mi := TMenuItem.Create(Self);
      mi.Caption := GroupConditionStr[GC];
      mi.OnClick := MenuItemGroupConditionClick;
      mi.Tag := Integer(GC);
      FPMGroupCondition.Items.Add(mi);
    end;
  end;
end;

destructor TToolGroupPanel.Destroy;
begin
  FreeAndNil(FPMAddElement);
  FreeAndNil(FBtnAddElement);
  FreeAndNil(FBtnCondition);
  FreeAndNil(FPMGroupCondition);
  inherited;
end;

procedure TToolGroupPanel.MenuItemAddConditionClick(Sender: TObject);
begin
  if Assigned(FFilterDisplay) then
    FFilterDisplay.AddCondition;
end;

procedure TToolGroupPanel.MenuItemAddGroupClick(Sender: TObject);
begin
  if Assigned(FFilterDisplay) then
    FFilterDisplay.AddGroup;
end;

procedure TToolGroupPanel.MenuItemGroupConditionClick(Sender: TObject);
begin
  if Assigned(FFilterDisplay) then
  begin
    FFilterDisplay.GroupCondition := TGroupCondition((Sender as TMenuItem).Tag);
  end;
end;

procedure TToolGroupPanel.Paint;
var
  R: TRect;
begin
  inherited;
  R := Self.ClientRect;
  R.Left := R.Left + R.Width - 8;
  R.Width := 16;
  Canvas.Arc(R.Left, R.Top, R.Right, R.Bottom, R.Left + 8, R.Top, R.Left + 8, R.Bottom);
end;

procedure TToolGroupPanel.Resize;
begin
  inherited;
  if Assigned(FBtnCondition) then
    FBtnCondition.Top := (Height - FBtnCondition.Height) div 2;
end;

procedure TToolGroupPanel.BtnAddElementClick(Sender: TObject);
var
  P: TPoint;
begin
  P := Point(0, (Sender as TBitBtn).Height);
  P := (Sender as TBitBtn).ClientToScreen(P);
  FPMAddElement.Popup(P.X, P.Y);
end;

procedure TToolGroupPanel.BtnGroupCondtionClick(Sender: TObject);
var
  P: TPoint;
begin
  P := Point(0, (Sender as TBitBtn).Height);
  P := (Sender as TBitBtn).ClientToScreen(P);
  FPMGroupCondition.Popup(P.X, P.Y);
end;

{ TConditionPanel }

procedure TConditionPanel.ControlChange(Sender: TObject);
begin
  DoChange;
end;

constructor TConditionPanel.Create(AOwner: TComponent);
begin
  inherited;
  if AOwner is TFilterDisplay then
  begin
    Parent := TFilterDisplay(AOwner);
    InitControls;
  end;
end;

destructor TConditionPanel.Destroy;
begin
  FreeControls;
  inherited;
end;

procedure TConditionPanel.DoChange;
var
  OpLeftKind: TOperatorKind;
  OpLeftValue: Variant;
  OpRightKind: TOperatorKind;
  OpRightValue: Variant;
  Op: TOperand;
begin
  if FNoCallBack then
    exit;
  if Assigned(FOnControlsChange) then
  begin
    if FOperatorLeftKind.ItemIndex > 0 then
      OpLeftKind := TOperatorKind(Integer(FOperatorLeftKind.Items.Objects[FOperatorLeftKind.ItemIndex]))
    else
      OpLeftKind := Low(TOperatorKind);
    if FOperatorRightKind.ItemIndex > 0 then
      OpRightKind := TOperatorKind(Integer(FOperatorRightKind.Items.Objects[FOperatorRightKind.ItemIndex]))
    else
      OpRightKind := Low(TOperatorKind);
    OpLeftValue := Variant(FOperatorLeftValue.Text);
    OpRightValue := Variant(FOperatorRightValue.Text);
    if FOperand.ItemIndex > 0 then
      Op := TOperand(Integer(FOperand.Items.Objects[FOperand.ItemIndex]))
    else
      Op := Low(TOperand);
    FOnControlsChange(OpLeftKind, OpLeftValue, OpRightKind, OpRightValue, Op);
  end;
end;

procedure TConditionPanel.FreeControls;
begin
  FNoCallBack := True;
  try
    FreeAndNil(FOperatorLeftKind);
    FreeAndNil(FOperatorLeftValue);
    FreeAndNil(FOperatorRightKind);
    FreeAndNil(FOperatorRightValue);
    FreeAndNil(FOperand);
  finally
    FNoCallBack := False;
  end;
end;

procedure TConditionPanel.InitControls;
var
  ok: TOperatorKind;
  op: TOperand;
begin
  FNoCallBack := True;
  try
    FOperatorLeftKind := TComboBox.Create(Self);
    with FOperatorLeftKind do
    begin
      Parent := Self;
      Style := csDropDownList;
      SetBounds(2, (Self.Height - Height) div 2, 72, Height);
      for ok := Low(TOperatorKind) to High(TOperatorKind) do
        Items.AddObject(OperatorKindStr[ok], TObject(Integer(ok)));
      ItemIndex := -1;
      OnChange := ControlChange;
      ShowHint := True;
      Hint := 'Source for the filter ("Database field", "Form field" or "constant")';
    end;

    FOperatorLeftValue := TEdit.Create(Self);
    with FOperatorLeftValue do
    begin
      Parent := Self;
      SetBounds(FOperatorLeftKind.Left + FOperatorLeftKind.Width + 1, (Self.Height - Height) div 2, 90, Height);
      OnChange := ControlChange;
      ShowHint := True;
      Hint := 'Value for the filter ' + #13 +
              '( If source is Database field then <Field name>, for example "FIRST_NAME".' + #13 +
               ' If source is Form field then <Form name>.<Item number>, for example "T1.1".' + #13 +
               ' If Source is contant then any value, for example "1985-12-22")';
    end;

    FOperand := TComboBox.Create(Self);
    with FOperand do
    begin
      Parent := Self;
      Style := csDropDownList;
      SetBounds(FOperatorLeftValue.Left + FOperatorLeftValue.Width + 16, (Self.Height - Height) div 2, 72, Height);
      for op := Low(TOperand) to High(TOperand) do
        Items.AddObject(OperandStr[op], TObject(Integer(op)));
      ItemIndex := -1;
      OnChange := ControlChange;
      ShowHint := True;
      Hint := 'Condition (equal, not equal, etc.)';
      DropDownCount := Integer(High(TOperand)) + 1;
    end;

    FOperatorRightKind := TComboBox.Create(Self);
    with FOperatorRightKind do
    begin
      Parent := Self;
      Style := csDropDownList;
      SetBounds(FOperand.Left + FOperand.Width + 16, (Self.Height - Height) div 2, 72, Height);
      for ok := Low(TOperatorKind) to High(TOperatorKind) do
        Items.AddObject(OperatorKindStr[ok], TObject(Integer(ok)));
      ItemIndex := -1;
      OnChange := ControlChange;
      ShowHint := True;
      Hint := 'Source for the filter ("Database field", "Form field" or "constant")';
    end;

    FOperatorRightValue := TEdit.Create(Self);
    with FOperatorRightValue do
    begin
      Parent := Self;
      SetBounds(FOperatorRightKind.Left + FOperatorRightKind.Width + 1, (Self.Height - Height) div 2, 90, Height);
      OnChange := ControlChange;
      ShowHint := True;
      Hint := 'Value for the filter ' + #13 +
              '( If source is Database field then <Field name>, for example "FIRST_NAME".' + #13 +
               ' If source is Form field then <Form name>.<Item number>, for example "T1.1".' + #13 +
               ' If Source is contant then any value, for example "1985-12-22")';
    end;
    FMinWidth := FOperatorRightValue.Left + FOperatorRightValue.Width + 2;
    Self.Width := FMinWidth;
  finally
    FNoCallBack := False;
  end;
end;

procedure TConditionPanel.Resize;
begin
  inherited;
  if Width < FMinWidth  then
    Width := FMinWidth;
  if assigned(FOperatorLeftKind) then
    FOperatorLeftKind.Top := (Self.Height - FOperatorLeftKind.Height) div 2;
  if assigned(FOperatorLeftValue) then
    FOperatorLeftValue.Top := (Self.Height - FOperatorLeftValue.Height) div 2;
  if assigned(FOperand) then
    FOperand.Top := (Self.Height - FOperand.Height) div 2;
  if assigned(FOperatorRightKind) then
    FOperatorRightKind.Top := (Self.Height - FOperatorRightKind.Height) div 2;
  if assigned(FOperatorRightValue) then
    FOperatorRightValue.Top := (Self.Height - FOperatorRightValue.Height) div 2;
end;

procedure TConditionPanel.UpdateObserver(Sender: TFilterCondition);
begin
  FNoCallBack := True;
  try
    if assigned(FOperatorLeftKind) then
      FOperatorLeftKind.ItemIndex := FOperatorLeftKind.Items.IndexOfObject(TObject(Integer(Sender.OperatorLeftKind)));
    if assigned(FOperatorLeftValue) then
      FOperatorLeftValue.Text := VarToStr(Sender.OperatorLeftValue);
    if assigned(FOperand) then
      FOperand.ItemIndex := FOperand.Items.IndexOfObject(TObject(Integer(Sender.Operand)));
    if assigned(FOperatorRightKind) then
    begin
      FOperatorRightKind.ItemIndex := FOperatorRightKind.Items.IndexOfObject(TObject(Integer(Sender.OperatorRightKind)));
      FOperatorRightKind.Visible := not (Sender.Operand in NoRightValueOperands);
    end;
    if assigned(FOperatorRightValue) then
    begin
      FOperatorRightValue.Text := VarToStr(Sender.OperatorRightValue);
      FOperatorRightValue.Visible := not (Sender.Operand in NoRightValueOperands);
    end;
  finally
    FNoCallBack := False;
  end;
end;

{ TEnumConverter }

class function TEnumConverter.EnumToInt<T>(const enValue: T): Integer;
begin
  Result := 0;
   Move(enValue, Result, sizeOf(enValue));
end;

class function TEnumConverter.EnumToString<T>(enValue: T): string;
begin
   Result := GetEnumName(TypeInfo(T), EnumToInt(enValue));
end;

class procedure TEnumConverter.StringToEnum<T>(strValue: String;
  var enValue: T);
var
  Tipo: PTypeInfo;
  Temp: Integer;
  PTemp: Pointer;
begin
  Tipo := TypeInfo(T);
  Temp := GetEnumValue(Tipo, strValue);
  PTemp := @Temp;
  enValue := T(PTemp^);
end;

end.
