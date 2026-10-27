unit fSetPgmPsw;
(* Enter the program password.
  Dont use this form directly, use uDialogs.SetThePgmPsw instead.
*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TSetPgmPsw = class(TForm)
    HeaderPanel: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

  public
    Psw: string;
  end;

var
  SetPgmPsw: TSetPgmPsw;

implementation

{$R *.DFM}

uses
  vtDialogs;

procedure TSetPgmPsw.BitBtn1Click(Sender: TObject);
begin
  //Close;
  ModalResult := mrCancel;
end;

procedure TSetPgmPsw.Button1Click(Sender: TObject);
begin
  if Edit1.Text = Edit2.text then
  begin
    //SavePgmPsw(Edit1.Text);
    Psw := Edit1.Text;
    ShowTimedMsg('Done', 1000);
    ModalResult := mrOk;
  end
  else
    ShowTimedMsg('The confirmation is invalid', 1000);
end;

end.

