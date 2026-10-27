unit FP_2027SIC;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,FP_2027Declare,ExtCtrls,Grids,Outline;

type
  TSICFP_2012 = class(TForm)
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
  SIC: TSICFP_2012;

implementation

{$R *.DFM}

uses FP_2027TrimStr,vtTrimStr;
  
procedure TSICFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TSICFP_2012.FormCreate(Sender: TObject);
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

procedure TSICFP_2012.OkBtnClick(Sender: TObject);
begin
  SelectedString := RightStr(Outline1.Items[Outline1.SelectedItem].Text,4);
  If Numeric(SelectedString) then ShowMessage('Selected Code: '+SelectedString);
  Close;
end;

procedure TSICFP_2012.FormPaint(Sender: TObject);
begin
Outline1.LoadFromFile(Appdir+'\'+'SIC.D');
If GroupBox1.ItemIndex = 0 then
    Outline1.FullExpand
else
  Outline1.FullCollapse;
end;

procedure TSICFP_2012.GroupBox1Click(Sender: TObject);
begin
Outline1.Clear;
FormPaint(Sender);
end;

procedure TSICFP_2012.Outline1DblClick(Sender: TObject);
begin
 {OKBtnClick(Sender);}
end;

end.
