unit T4T5_2026sic;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,Grids,Outline;

type
  TSICT4T5_2026 = class(TForm)
    Label1: TLabel;
    GroupBox1: TRadioGroup;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Outline1: TOutline;
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
  SIC: TSICT4T5_2026;

implementation

{$R *.DFM}

uses vtTrimStr,T4T5_2026Declare,T4T5_2026TrimStr;

procedure TSICT4T5_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TSICT4T5_2026.FormCreate(Sender: TObject);
begin
 GroupBox1.ItemIndex :=1;
 { does not work
 with Outline1 do
  begin
  Items[1].Expanded := False;
  Items[2].Expanded := True;
  Items[3].Expanded := True;
  end;}
end;

procedure TSICT4T5_2026.OkBtnClick(Sender: TObject);
begin
  SelectedString := LeftStr(AllTrim(Outline1.Items[Outline1.SelectedItem].Text),6);
 {SelectedString := RightStr(Outline1.Items[Outline1.SelectedItem].Text,4);}
  If Not Numeric(SelectedString) then ShowMessage('No code selected');
  Close;
end;

procedure TSICT4T5_2026.FormPaint(Sender: TObject);
begin
Outline1.LoadFromFile(Appdir+'\'+'NAICS.D');
If GroupBox1.ItemIndex = 0 then
    Outline1.FullExpand
else
  Outline1.FullCollapse;
end;

procedure TSICT4T5_2026.GroupBox1Click(Sender: TObject);
begin
Outline1.Clear;
FormPaint(Sender);
end;

procedure TSICT4T5_2026.Outline1DblClick(Sender: TObject);
begin
 {OKBtnClick(Sender);}
end;

end.
