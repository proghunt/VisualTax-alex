unit vtConditionValues;

interface

uses
  vtControlIntf, System.Classes, System.SysUtils, Vcl.Forms;

type
  TConditionalBoolean = class(TPersistent)
  private
    FValue: Boolean;
    FLocalIdentificator: string;
    FIdentificator: string;
    FOwner: TComponent;

    procedure SetIdentificator(const Value: string);
    procedure DoInvalidateOwner;
    procedure SetValue(const AValue: Boolean);
    procedure DoCalc;
  public
    constructor Create(AOwner: TComponent; AIdentificator: String);
    procedure Invalidate;
    procedure SetDefaultIdentificator;
  published
    property Identificator: string read FIdentificator write SetIdentificator;
    property Value: Boolean read FValue write SetValue default False;
  end;

implementation

{ TConditionalBoolean }

procedure TConditionalBoolean.DoCalc;
var
  I: IvtControl;
  IForm: IvtForm;
begin
  if not Assigned(FOwner) or (csDesigning in FOwner.ComponentState) then
    Exit;
  if not FOwner.getInterface(IvtControl, I) then
    Exit;
  if (FOwner.Owner <> nil) AND FOwner.Owner.GetInterface(IvtForm, IForm) then
    IForm.ConditionCalc(FIdentificator, FValue);
end;

constructor TConditionalBoolean.Create(AOwner: TComponent; AIdentificator: String);
begin
  inherited Create;
  FOwner := AOwner;
  FValue := False;
  FLocalIdentificator := AIdentificator;
  SetDefaultIdentificator;
end;

procedure TConditionalBoolean.DoInvalidateOwner;
var
  I: IvtConditionalControl;
begin
  if Assigned(FOwner) and FOwner.GetInterface(IvtConditionalControl, I) then
    I.InvalidateConditionalValues(Self);
end;

procedure TConditionalBoolean.SetDefaultIdentificator;
begin
  FIdentificator := FLocalIdentificator;
  if (FOwner <> nil) AND (FOwner.Name <> '') then
  begin
    FIdentificator := FOwner.Name + '.' + FIdentificator;
    if FOwner.Owner <> nil then
      FIdentificator := FOwner.Owner.ClassName + '.' + FIdentificator;
  end;
end;

procedure TConditionalBoolean.Invalidate;
begin
  {TODO : Calck}
  DoCalc;
  DoInvalidateOwner;
end;

procedure TConditionalBoolean.SetIdentificator(const Value: string);
begin
  if FIdentificator <> Value then
  begin
    FIdentificator := Value;
    Invalidate;
  end;
end;

procedure TConditionalBoolean.SetValue(const AValue: Boolean);
begin
  if FValue <> AValue then
  begin
    FValue := AValue;
    DoInvalidateOwner;
  end;
end;

end.
