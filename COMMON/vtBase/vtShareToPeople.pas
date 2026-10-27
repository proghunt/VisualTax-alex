unit vtShareToPeople;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type TContact = record
  Name: string;
  Email: string;
end;

type
  TfrmShareToPeople = class(TForm)
    Panel2: TPanel;
    BitBtn2: TBitBtn;
    Panel1: TPanel;
    Label4: TLabel;
    edName: TEdit;
    btnAdd: TSpeedButton;
    Panel3: TPanel;
    lbEmails: TListBox;
    BitBtn1: TBitBtn;
    btnRemove: TSpeedButton;
    Label1: TLabel;
    edEmail: TEdit;
    procedure btnAddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure edEmailChange(Sender: TObject);
  private
    { Private declarations }
    FRetNo: integer;
    FContacts: array of TContact;
    procedure InitContacts(AEmails: string);
    function PackContacts: string;
    procedure UpdateButtons;
    procedure AddEmailToListBox(AIndex: integer);
  public
    { Public declarations }
    property RetNo: integer read FRetNo;
  end;

  function ShareToPeople(ARetNo: integer; var AEmails: string): boolean;

implementation

uses vtCommon, StrUtils, System.RegularExpressions;

{$R *.dfm}

function ShareToPeople(ARetNo: integer; var AEmails: string): boolean;
begin
  Result := false;
  with TfrmShareToPeople.Create(Application) do
  begin
    try
      FRetNo := ARetNo;
      InitContacts(AEmails);
      Result := ShowModal = mrOk;
      if Result then
        AEmails := PackContacts();
    finally
      Free;
    end;
  end;
end;

procedure TfrmShareToPeople.btnRemoveClick(Sender: TObject);
var index, i: integer;
begin
  index := lbEmails.ItemIndex;
  if index = -1 then Exit;
  lbEmails.Items.Delete(index);
  for i := index + 1 to Length(FContacts) - 1 do
    FContacts[i - 1] := FContacts[i];
  SetLength(FContacts, Length(FContacts) - 1);
  UpdateButtons;
end;

procedure TfrmShareToPeople.edEmailChange(Sender: TObject);
begin
  btnAdd.Enabled := edEmail.Text <> '';
end;

procedure TfrmShareToPeople.FormShow(Sender: TObject);
begin
  UpdateButtons;
end;

procedure TfrmShareToPeople.InitContacts(AEmails: string);
var cStr: string;
    L: TStringList;
    i: integer;
begin
  L := TStringList.Create;
  try
    lbEmails.Clear;
    L.Text := ReplaceStr(AEmails, ';', #13#10);
    SetLength(FContacts, L.Count);
    for i := 0 to L.Count - 1 do
    begin
      FContacts[i].Name := Copy(L.Strings[i], 1, Pos('|', L.Strings[i]) - 1);
      FContacts[i].Email := Copy(L.Strings[i], Pos('|', L.Strings[i])+ 1, Length(L.Strings[i]));
      AddEmailToListBox(i);
    end;
  finally
    L.Free;
  end;
end;

function TfrmShareToPeople.PackContacts: string;
var i: integer;
begin
  Result := '';
  for i := 0 to Length(FContacts) - 1 do
  begin
    if Result <> '' then
      Result := Result + ';';
    Result := Result + FContacts[i].Name + '|' + FContacts[i].Email;
  end;
end;

procedure TfrmShareToPeople.AddEmailToListBox(AIndex: integer);
begin
  if FContacts[AIndex].Name = '' then
    lbEmails.Items.Add(FContacts[AIndex].Email)
  else
    lbEmails.Items.Add(FContacts[AIndex].Name + ' <' + FContacts[AIndex].Email + '>');
end;

procedure TfrmShareToPeople.btnAddClick(Sender: TObject);
var i: integer;

const NameChars = '|<>;';
      EmailChars = ' |<>(){}[]"''?!;,';

  function CheckIfStringContainsChars(AStr, AChars: string): boolean;
  var j: integer;
  begin
    Result := false;
    for j := 1 to Length(AChars) do
      if Pos(AChars[j], AStr) > 0 then
      begin
        Result := true;
        break;
      end;
  end;

begin
  if CheckIfStringContainsChars(edName.Text, NameChars) then
  begin
    ShowMessage('Please, do not use '+ NameChars +' chars in name!');
    Exit;
  end;

  if edEmail.Text = '' then
  begin
    ShowMessage('Please, enter e-mail!');
    Exit;
  end;

  if CheckIfStringContainsChars(edEmail.Text, EmailChars) then
  begin
    ShowMessage('Please, do not use '+ EmailChars +' chars and spaces in e-mail!');
    Exit;
  end;

  if not TRegEx.IsMatch(AnsiLowerCase(edEmail.Text), '^(\S+)@(([a-z0-9-]+)(\.)){1,}([a-z]{0,4})+$') then
  begin
    ShowMessage('E-mail '+ edEmail.Text +' is not valid!');
    Exit;
  end;

  if Length(edEmail.Text) <> Length(ReplaceStr(edEmail.Text, '@', '')) + 1 then
  begin
    ShowMessage('E-mail must contain only one @!');
    Exit;
  end;

  for i := 0 to Length(FContacts) - 1 do
  begin
    if SameText(FContacts[i].Email, edEmail.Text)  then
    begin
      ShowMessage('This e-mail is already in the list!');
      Exit;
    end;
  end;

  SetLength(FContacts, Length(FContacts) + 1);
  FContacts[Length(FContacts) - 1].Name := Trim(edName.Text);
  FContacts[Length(FContacts) - 1].Email := edEmail.Text;
  AddEmailToListBox(Length(FContacts) - 1);

  edName.Text := '';
  edEmail.Text := '';
  UpdateButtons;
end;

procedure TfrmShareToPeople.UpdateButtons;
begin
  btnRemove.Enabled := Length(FContacts) > 0;
end;

end.
