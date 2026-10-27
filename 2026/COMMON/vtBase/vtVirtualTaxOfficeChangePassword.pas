Unit vtVirtualTaxOfficeChangePassword;

interface

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DBCtrls,
  Vcl.Mask, vteditbox, vtLabel, vtShape, ShellApi, System.Generics.Collections,
  System.IOUtils, Data.DBXJSON, vtVirtualTaxOffice;

type
  TvtVirtualTaxOfficeChangePassword = class(TForm)
    shHeader: TvtShape;
    vtLabel37: TvtLabel;
    GroupBox1: TGroupBox;
    gbLogin: TGroupBox;
    lbCyberId: TLabel;
    edCyberId: TEdit;
    Label1: TLabel;
    edPassword: TEdit;
    Label3: TLabel;
    edNewPassword: TEdit;
    Label6: TLabel;
    edConfirmPassword: TEdit;
    btnChangePassword: TButton;
    procedure btnChangePasswordClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function ChangePasswordForVirtualTaxOffice: boolean;

implementation

{$R *.dfm}

Uses
  vtMulti, vtCommon, vtDialogs, vtMain, vtTrimStr, vtShared, vtDataBase,
  Variants;

function ChangePasswordForVirtualTaxOffice: boolean;
var
  FVirtualTaxOfficeChangePassword: TvtVirtualTaxOfficeChangePassword;
begin
  FVirtualTaxOfficeChangePassword := TvtVirtualTaxOfficeChangePassword.Create(Application);
  try
    Result := FVirtualTaxOfficeChangePassword.ShowModal = mrOk;
  finally
    FVirtualTaxOfficeChangePassword.Free;
  end;
end;

procedure TvtVirtualTaxOfficeChangePassword.btnChangePasswordClick(Sender: TObject);
var Password, NewPassword, ConfirmPassword, TaxOfficeCyberId: string;
    FParams: TParamList;
    Res: TJSONObject;
begin
  Password := edPassword.Text;
  NewPassword := edNewPassword.Text;
  ConfirmPassword := edConfirmPassword.Text;

  if Password.IsEmpty then
  begin
    edPassword.SetFocus;
    ShowMessage('Password is not entered');
    Exit;
  end;
  if NewPassword.IsEmpty then
  begin
    edNewPassword.SetFocus;
    ShowMessage('New Password is not entered');
    Exit;
  end;
  if ConfirmPassword.IsEmpty then
  begin
    edConfirmPassword.SetFocus;
    ShowMessage('Confirm Password is not entered');
    Exit;
  end;
  if NewPassword <> ConfirmPassword then
  begin
    edConfirmPassword.SetFocus;
    ShowMessage('New Password and Confirm Password are not the same');
    Exit;
  end;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action','CHANGE_PASSWORD');
    FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
    FParams.AddParam('Password', Password);
    FParams.AddParam('NewPassword', NewPassword);
    FParams.AddParam('ConfirmPassword', ConfirmPassword);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        ShowMessageInfo('Password was successfully changed!'); //20201221 Igor
        ModalResult := mrOk;
      end
      else
      begin
        if SameText(GetJSONValue(Res, 'type'), 'cyberid') then
          edCyberId.SetFocus
        else if SameText(GetJSONValue(Res, 'type'), 'password') then
          edPassword.SetFocus
        else if SameText(GetJSONValue(Res, 'type'), 'new_password') then
          edNewPassword.SetFocus
        else if SameText(GetJSONValue(Res, 'type'), 'confirm_password') then
          edConfirmPassword.SetFocus;
        ShowMessageError(GetJSONValue(Res, 'error_message')); //20201221 Igor
      end;
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

procedure TvtVirtualTaxOfficeChangePassword.FormShow(Sender: TObject);
var I: integer;
begin
  for I := 0 to ComponentCount - 1 do
    if Components[I] is TEdit then
      if TEdit(Components[I]).ReadOnly then
        TEdit(Components[I]).Color := ReadonlyColor;
  edCyberId.Text := VirtualTaxOfficeInfo.CyberId;
  edPassword.SetFocus;
end;

end.
