unit vtButton;

{.$DEFINE childwin}

interface

uses
  WinAPI.Windows, WinAPI.Messages, System.SysUtils, System.Classes,
  VCL.Graphics, VCL.Controls, VCL.Forms, VCL.Dialogs,
  VCL.StdCtrls, VCL.Buttons;

type
  TvtActionCode = (
    acNone,
    acOpenForm,
    acOpenHelp,
    acMethodCall
    //more as required
    );

  TvtButton = class(TBitBtn)
  private
    FActionCode: TvtActionCode;
    FActionReference: string;
    procedure SetActionCode(const Value: TvtActionCode);
    procedure SetActionReference(const Value: string);
  published
    procedure Click; override;
    property ActionCode: TvtActionCode read FActionCode write SetActionCode;
    property ActionReference: string read FActionReference write SetActionReference;
  end;

  TvtButtonProc = function(AButton: TvtButton): boolean of object;

procedure Register;

implementation

{$IFDEF childwin}
uses
  ChildWin;
{$ELSE}
{$ENDIF}

procedure Register;
begin
  RegisterComponents('VisualTax', [TvtButton]);
end;

{ TvtButton }

procedure TvtButton.Click;
var
  MyForm: TCustomForm;
{$IFDEF childwin}
  MyChild: TMyChild absolute MyForm;
{$ELSE}
{$ENDIF}
  Meth: TMethod;
  BtnProc: TvtButtonProc absolute Meth;
begin
  if ActionCode <> acNone then
  begin
    MyForm := GetParentForm(self);
    if assigned(MyForm) and (ActionCode = acMethodCall) then
    begin
      Meth.Data := MyForm;
      Meth.Code := MyForm.MethodAddress(ActionReference);
      if assigned(Meth.Code) and BtnProc(Self) then
        exit;
    end;
{$IFDEF childwin}
    if (MyForm is TMyChild) and MyChild.OnVtButtonClick(self) then
      exit; //handled
{$ELSE}
{$ENDIF}
  end;
  inherited;
end;

procedure TvtButton.SetActionCode(const Value: TvtActionCode);
begin
  FActionCode := Value;
end;

procedure TvtButton.SetActionReference(const Value: string);
begin
  FActionReference := Value;
end;

end.

