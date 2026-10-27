unit Umpswd;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,
  UDeclare;

type
  TMpswd = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Edit1: TEdit;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Mpswd: TMpswd;

implementation

{$R *.DFM}

procedure TMpswd.BitBtn1Click(Sender: TObject);
begin
 MasterPswd := Edit1.Text;
 Close;
end;

end.
