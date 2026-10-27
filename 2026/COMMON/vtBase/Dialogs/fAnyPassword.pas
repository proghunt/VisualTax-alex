unit fAnyPassword;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TPassword = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
  private

  public

  end;

function GetPwd(ACaption: string; ADefault: string = ''): string;
function CheckPwd(ACaption: string; APassword: string): Boolean; //20160227 Igor

implementation

var
  Password: TPassword;

{$R *.DFM}

function GetPwd(ACaption: string; ADefault: string): string;
begin
  Password := TPassword.Create(Application);
  Password.Caption := 'Visual Tax ' + ACaption;
  Password.Edit1.Text := ADefault;
  Password.ShowModal;
  Result := Password.Edit1.Text;
  Password.Release;
end;

function CheckPwd(ACaption: string; APassword: string): Boolean; //20160227 Igor
var
  Counter: Integer;
Begin
  Result := False;
 With TPassword.Create(Application) do
 Begin
   try
     Left := Application.MainForm.Left + (Application.MainForm.Width div 2) - (Width div 2);
     Top := Application.MainForm.Top + (Application.MainForm.Height div 2) - (Height div 2);
     Caption := 'Visual Tax ' + ACaption;
     Edit1.Text := '';
     Counter := 0;
     repeat
       inc(Counter);
       ShowModal;
       if (ModalResult = mrOk) then
       Begin
         result := (Edit1.Text = APassword);
         if not result AND (Counter < 3) then
           ShowMessage('Incorrect password! Try again.')
         else
         if not result AND (Counter >= 3) then
         Begin
           ShowMessage('Incorrect password!');
           Break;
         End;
       End;
     until (ModalResult <> mrOk) or Result;
   finally
     free;
   end;
 End;

End;

end.

