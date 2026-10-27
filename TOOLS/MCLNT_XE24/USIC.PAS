unit Usic;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons,
  UDeclare,TrimStr, ExtCtrls, Grids, Outline;

type
  TSIC = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    Outline1: TOutline;
    Panel2: TPanel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TRadioGroup;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure Outline1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SIC: TSIC;

implementation

{$R *.DFM}

procedure TSIC.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TSIC.FormCreate(Sender: TObject);
begin
 {Outline1.LoadFromFile(Appdir+'\'+'SIC.D');}
 GroupBox1.ItemIndex :=1;
 { does not work
 with Outline1 do
  begin
  Items[1].Expanded := False;
  Items[2].Expanded := True;
  Items[3].Expanded := True;
  end;}
end;

procedure TSIC.OkBtnClick(Sender: TObject);
{Var Cd :String[4];}
begin
  SelectedString := RightStr(Outline1.Items[Outline1.SelectedItem].Text,4);
  If Numeric(SelectedString) then ShowMessage('Selected Code: '+SelectedString);
  Close;
end;

procedure TSIC.FormPaint(Sender: TObject);
begin
Outline1.LoadFromFile(Appdir+'\'+'SIC.D');
If GroupBox1.ItemIndex = 0 then
    Outline1.FullExpand
else
  Outline1.FullCollapse;
end;

procedure TSIC.GroupBox1Click(Sender: TObject);
begin
Outline1.Clear;
FormPaint(Sender);
end;

procedure TSIC.Outline1DblClick(Sender: TObject);
begin
 {OKBtnClick(Sender);}
end;

end.
