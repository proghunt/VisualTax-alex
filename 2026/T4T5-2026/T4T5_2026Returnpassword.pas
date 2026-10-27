unit T4T5_2026Returnpassword;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons;

type
  TReturnPasswordT4T5_2026 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ReturnPassword: TReturnPasswordT4T5_2026;

implementation

{$R *.DFM}



procedure TReturnPasswordT4T5_2026.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then Close;
end;

end.
