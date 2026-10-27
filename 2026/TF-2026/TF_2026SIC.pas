unit TF_2026sic;
{
//20170328 Igor
}
interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,Grids,Outline;

type
  TSICTF_2026 = class(TForm)
    Label1: TLabel;
    GroupBox1: TRadioGroup;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Outline1: TOutline;
    Panel1: TPanel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure Outline1DblClick(Sender: TObject);
    procedure Outline1KeyPress(Sender: TObject; var Key: Char);
    procedure Outline1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SIC: TSICTF_2026;

implementation

{$R *.DFM}

uses vtTrimStr,TF_2026Declare, vtShared;

procedure TSICTF_2026.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TSICTF_2026.FormCreate(Sender: TObject);
begin
  Outline1.LoadFromFile(Appdir + '\NAICS.D');
  GroupBox1.ItemIndex := 1;  //20170328
end;

procedure TSICTF_2026.OkBtnClick(Sender: TObject);
begin
  SelectedString := LeftStr(AllTrim(Outline1.Items[Outline1.SelectedItem].Text),6);
  If Not Numeric(SelectedString) then
    ShowMessage('No code selected');
  Close;
end;

procedure TSICTF_2026.Outline1DblClick(Sender: TObject);
begin
  if Outline1.SelectedItem = -1 then Exit;
  if Outline1.Items[Outline1.SelectedItem].Level = 2 then
    OkBtnClick(nil);
end;

procedure TSICTF_2026.Outline1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RIGHT then
  begin
    if Outline1.Items[Outline1.SelectedItem].Level = 1 then
      if not Outline1.Items[Outline1.SelectedItem].Expanded then
        Outline1.Items[Outline1.SelectedItem].Expand;
  end
  else
  if Key = VK_LEFT then
  begin
    if Outline1.Items[Outline1.SelectedItem].Level = 1 then
      if Outline1.Items[Outline1.SelectedItem].Expanded then
        Outline1.Items[Outline1.SelectedItem].Collapse;
  end;
end;

procedure TSICTF_2026.Outline1KeyPress(Sender: TObject; var Key: Char);
begin
  if Outline1.SelectedItem = -1 then Exit;
  if Key = #13 then
  begin
    if Outline1.Items[Outline1.SelectedItem].Level = 1 then
    begin
      if not Outline1.Items[Outline1.SelectedItem].Expanded then
        Outline1.Items[Outline1.SelectedItem].Expand;
    end
    else
    if Outline1.Items[Outline1.SelectedItem].Level = 2 then
      OkBtnClick(nil);
  end
  else
  if Key = '+' then
  begin
    if Outline1.Items[Outline1.SelectedItem].Level = 1 then
      if not Outline1.Items[Outline1.SelectedItem].Expanded then
        Outline1.Items[Outline1.SelectedItem].Expand;
  end
  else
  if Key = '-' then
  begin
    if Outline1.Items[Outline1.SelectedItem].Level = 1 then
      if Outline1.Items[Outline1.SelectedItem].Expanded then
        Outline1.Items[Outline1.SelectedItem].Collapse
      else
    else
    if Outline1.Items[Outline1.SelectedItem].Level = 2 then
      if Outline1.Items[Outline1.SelectedItem].Parent.Expanded then
        Outline1.Items[Outline1.SelectedItem].Parent.Collapse;
  end;
end;

procedure TSICTF_2026.GroupBox1Click(Sender: TObject);
begin
  If GroupBox1.ItemIndex = 0 then
    Outline1.FullExpand
  else
    Outline1.FullCollapse;
end;

end.
