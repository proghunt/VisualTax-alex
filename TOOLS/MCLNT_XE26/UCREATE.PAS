unit Ucreate;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls;

type
  TCreateBoxes = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CreateBoxes: TCreateBoxes;
  PaintSw : boolean;
implementation

{$R *.DFM}

procedure TCreateBoxes.Button1Click(Sender: TObject);
const
 NumBoxes = 120;
var
 EditBox : Array[1..NumBoxes] of TEdit;
 I : integer;
begin
 for i := 1 to NumBoxes do
 begin
   PaintSw := False;
   EditBox[i] := Tedit.Create(CreateBoxes);
   {EditBox[i].Parent := CreateBoxes;}
   EditBox[i].Visible := False;
   EditBox[i].Left := i *10;
   EditBox[i].Top := i * 20;
   EditBox[i].Height := 20;
   EditBox[i].Width := 50;
   EditBox[i].TabOrder := i;
 end;
 for i := 1 to 120 do
  begin
  EditBox[i].Parent := CreateBoxes;
  EditBox[i].Visible := True;
  end;

  PaintSw := True;
  EditBox[1].SetFocus;
 end;

procedure TCreateBoxes.FormPaint(Sender: TObject);
begin
If PaintSw = False then exit;
end;

end.
