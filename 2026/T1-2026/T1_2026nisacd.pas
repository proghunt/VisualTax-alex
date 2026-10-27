unit T1_2026nisacd;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,Grids,Outline;

type
  TNISACDT1_2026 = class(TForm)
    Panel2: TPanel;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TRadioGroup;
    Outline1: TOutline;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NISACDT1_2026: TNISACDT1_2026;

implementation

{$R *.DFM}

uses vtTrimStr,T1_2026Declare,T1_2026TrimStr,
vtShared; //20160907 igor

procedure TNISACDT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TNISACDT1_2026.FormCreate(Sender: TObject);
begin
 GroupBox1.ItemIndex :=0;
end;

procedure TNISACDT1_2026.OkBtnClick(Sender: TObject);
begin
  SelectedString := RightStr(Outline1.Items[Outline1.SelectedItem].Text,4);
  If Numeric(SelectedString) then ShowMessage('Selected Code: '+SelectedString);
  Close;
end;

procedure TNISACDT1_2026.FormPaint(Sender: TObject);
begin
Outline1.LoadFromFile(Appdir+'\'+'NISA.D');
If GroupBox1.ItemIndex = 0 then
    Outline1.FullExpand
else
  Outline1.FullCollapse;
end;

procedure TNISACDT1_2026.GroupBox1Click(Sender: TObject);
begin
Outline1.Clear;
FormPaint(Sender);
end;

end.
