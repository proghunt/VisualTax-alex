unit Uoutln;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Buttons, StdCtrls, Grids, Outline,TrimStr, ExtCtrls;

type
  TOutln = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    RetNameLbl: TLabel;
    MultSelectBtn: TCheckBox;
    Outline1: TOutline;
    ExpandBtn: TBitBtn;
    CollapseBtn: TBitBtn;
    CheckBox1: TCheckBox;
    RadioGroup1: TRadioGroup;
    Panel2: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Outline1Click(Sender: TObject);
    procedure Outline1Expand(Sender: TObject; Index: Longint);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure CollapseBtnClick(Sender: TObject);
    procedure ExpandBtnClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Outln: TOutln;

implementation

{$R *.DFM}

procedure TOutln.SpeedButton1Click(Sender: TObject);

 var
  AddStr: string;
  AddIndex:LongInt;
 begin
 (*
 AddStr := Edit1.Text;
 AddIndex := StrToInt(Edit2.Text);
 Outline1.AddChild(AddIndex, AddStr);
 SelItem.Caption := IntToStr(Outline1.SelectedItem);
 Fpath.Caption := Outline1.Items[Outline1.SelectedItem].FullPath;
 Levl.Caption :=IntToStr(Outline1.Items[Outline1.SelectedItem].Level);
 *)
 end;

procedure TOutln.Outline1Click(Sender: TObject);
begin
 (*
 SelItem.Caption := IntToStr(Outline1.SelectedItem);
 Outln.Refresh;
 *)
 end;

procedure TOutln.Outline1Expand(Sender: TObject; Index: Longint);
begin
 (*
 CurIndex.Caption := IntToStr(Outline1.SelectedItem);
 *)
end;

procedure TOutln.FormActivate(Sender: TObject);
begin
Outline1click(sender);
end;

procedure TOutln.FormCreate(Sender: TObject);
begin
Outline1.LoadFromFile('c:\delphi\t1\Interv.d');
{put an x}
Outline1.Items[2].Text :=
  LeftStr(Outline1.Items[2].Text,1)+'X' + MidStr(Outline1.Items[2].Text,3,255);
end;

procedure TOutln.OKBtnClick(Sender: TObject);
Var FName : String[10];
begin
FName := MidStr(Outline1.Items[Outline1.SelectedItem].Text,50,10);
ShowMessage(FName);

end;

procedure TOutln.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TOutln.CollapseBtnClick(Sender: TObject);
begin
if Outline1[Outline1.SelectedItem].IsVisible then
  Outline1.FullCollapse;
end;

procedure TOutln.ExpandBtnClick(Sender: TObject);
begin
 {if not Outline1.Items[Outline1.SelectedItem].IsVisible then}
  Outline1.FullExpand;
end;

procedure TOutln.Panel1Click(Sender: TObject);
begin
RadioGroup1.ItemIndex := 0;
end;

procedure TOutln.RadioGroup1Click(Sender: TObject);
begin
Outline1.Clear;
If RadioGroup1.ItemIndex = 0 then
 Outline1.LoadFromFile('c:\delphi\t1\Interv.d')
else
 Outline1.LoadFromFile('c:\delphi\t1\Alphandx.d')
end;

end.
