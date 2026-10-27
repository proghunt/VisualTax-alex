unit uEditUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, DB, System.UITypes;

type
  TfrmEditUser = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    chbAdministrator: TCheckBox;
    edID: TEdit;
    edLogin: TEdit;
    edPassword: TEdit;
    edEmail: TEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edIDChange(Sender: TObject);
  private
    { Private declarations }
    FDataChanged: Boolean;
    FDataSet: TDataSet;
    procedure LoadData;
    function CheckAndSave(ADoAsc: Boolean): Boolean;
    procedure MessageE(AMessage: String);
  public
    { Public declarations }
  end;

  function EditUser(ADataSet: TDataSet): Boolean;
implementation

{$R *.dfm}

function EditUser(ADataSet: TDataSet): Boolean;
Begin
  With TfrmEditUser.Create(Application) do
  Begin
    try
      FDataSet:= ADataSet;
      LoadData;
      Result := (ShowModal = mrOk) and FDataChanged;
    finally
      Free;
    end;
  End;

End;

function TfrmEditUser.CheckAndSave(ADoAsc: Boolean): Boolean;
var
  mr: TModalResult;
begin
  Result := True;
  if not FDataChanged then
    exit;
  if ADoAsc then
    mr := MessageDlg('Data have been modified. Save changes?', mtConfirmation, mbYesNoCancel, 0)
  else
    mr := mrYes;

  case mr of
    mrYes:
      Begin
        if trim(edLogin.Text) = '' then
        Begin
          MessageE('Login is empty');
          edLogin.SetFocus;
          Result := False;
        End
        else
        if trim(edPassword.Text) = '' then
        Begin
          MessageE('Password is empty');
          edPassword.SetFocus;
          Result := False;
        End
        else
        if trim(edEmail.Text) = '' then
        Begin
          MessageE('Email is empty');
          edEmail.SetFocus;
          Result := False;
        End
        else
        Begin
          if not (FDataSet.State in dsEditModes) then
            FDataSet.Edit;
          FDataSet.FieldByName('Login').AsString := edLogin.Text;
          FDataSet.FieldByName('Password').AsString := edPassword.Text;//20170703 Igor
          FDataSet.FieldByName('Email').AsString := edEmail.Text;//20170703 Igor
          if chbAdministrator.Checked then
            FDataSet.FieldByName('IsAdmin').AsInteger := 1
          else
            FDataSet.FieldByName('IsAdmin').AsInteger := 0;
          try
            FDataSet.Post;
          Except ON E: Exception DO
            Begin
              MessageE(E.Message);
              Result := False;
            End;
          end;
        End;
      End;
    mrNo: Result := True;
    mrCancel: Result := False;
  end;
end;

procedure TfrmEditUser.edIDChange(Sender: TObject);
begin
  FDataChanged := (edID.Text <> FDataSet.FieldByName('ID').AsString) or
                  (edLogin.Text <> FDataSet.FieldByName('Login').AsString) or
                  (edPassword.Text <> FDataSet.FieldByName('Password').AsString) or
                  (edEmail.Text <> FDataSet.FieldByName('Email').AsString) or
                  (chbAdministrator.Checked <> (FDataSet.FieldByName('IsAdmin').AsInteger = 1));
end;

procedure TfrmEditUser.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := CheckAndSave(ModalResult <> mrOk);
end;

procedure TfrmEditUser.LoadData;
begin
  edID.Text := FDataSet.FieldByName('ID').AsString;
  edLogin.Text := FDataSet.FieldByName('Login').AsString;
  edPassword.Text := FDataSet.FieldByName('Password').AsString;
  edEmail.Text := FDataSet.FieldByName('Email').AsString;
  chbAdministrator.Checked := (FDataSet.FieldByName('IsAdmin').AsInteger = 1);
  FDataChanged := False;
end;

procedure TfrmEditUser.MessageE(AMessage: String);
begin
  MessageDlg(AMessage, mtError, [mbOk], 0);
end;

end.
