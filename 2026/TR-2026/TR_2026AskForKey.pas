unit TR_2026AskForKey;

interface

uses
  SysUtils, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,

  TR_2026Utils, TR_2026Declare, TR_2026Authorization;

type
  TAskForKeyTR_2026 = class(TForm)
    Label3: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Edit1: TEdit;
    OKBtn: TBitBtn;
    CancelProgramBtn: TBitBtn;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AskForKeyTR_2026: TAskForKeyTR_2026;

implementation

{$R *.DFM}

procedure TAskForKeyTR_2026.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOk then
  begin
    CanClose := ValidateKey(Edit1.Text);
    if not CanClose then
      ShowMessage('Invalid Key')
    else
      SetKey(Edit1.Text);
  end;
end;

end.

