unit TR_2026PopTreeView;
{Uses a pre-populated SomeString and SomeCaption, displays it
on a list and returns the selected string}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, StrUtils, UITypes,

  TR_2026Declare, TR_2026Utils;

type
  TPopTreeViewTR_2026 = class(TForm)
    TreeView1: TTreeView;
    SearchHeader: TPanel;
    Panel2: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ExpandBtn: TBitBtn;
    CollapseBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure TreeView1DblClick(Sender: TObject);
    procedure ExpandBtnClick(Sender: TObject);
    procedure CollapseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PopTreeViewTR_2026: TPopTreeViewTR_2026;

implementation

{$R *.DFM}

procedure TPopTreeViewTR_2026.OKBtnClick(Sender: TObject);
var
  SourceNode: TTreeNode;
  Rec: string;
  Flags: OLEVariant;
begin
  Flags := 0;
  SourceNode := Treeview1.Selected;
  if SourceNode <> Nil then
  begin
    Rec := SourceNode.text;
    SelectedString := Rec;
  end;
  Close;
end;

procedure TPopTreeViewTR_2026.ListBox1DblClick(Sender: TObject);
{Selected item is a global variable}
begin
  OKBtnClick(Sender);
end;

procedure TPopTreeViewTR_2026.FormCreate(Sender: TObject);
var
  i: integer;
  SourceNo, SourceDoc, PrevSourceDoc, ATitle: string;
  aList: TStringList;
begin
 //TreeView1.ShowButtons:=True;
  aList := TStringList.Create;
  Treeview1.Items.clear;
  PopTreeViewTR_2026.Caption := SomeCaption;
 //SearchHeader.Caption:='Search Results for: '+SomeCaption;
  PrevSourceDoc := '';
  for i := 0 to SomeList.Count - 1 do
  begin
    SourceNo := PaddR(Trim(LeftStr(SomeList[i], 7)), 7);
    SourceDoc := Trim(Copy(SomeList[i], 6, 100)); //SourceDoc:=AllTrim(MidStr(SomeList[i],6,30));
    ATitle := Trim(Copy(SomeList[i], 107, 100)); //aTitle:=AllTrim(MidStr(SomeList[i],36,100));

    if i = 0 then
    begin
      aList.Add(SourceDoc);
      PrevSourceDoc := SourceDoc;
    end;
    if SourceDoc = PrevSourceDoc then
      aList.Add(' ' + PaddR(ATitle, 100) + ' ' + SourceNo)
    else //new source doc
    begin
      aList.Add(SourceDoc);
      aList.Add(' ' + PaddR(ATitle, 100) + ' ' + SourceNo);
      PrevSourceDoc := SourceDoc;
    end;
  end;
  aList.SaveToFile(AppDir + '\' + 'Temp.txt');
  aList.Free;
  try
    Treeview1.LoadFromFile(AppDir + '\' + 'Temp.txt');
    TreeView1.FullExpand;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbok], 0);
  end;
  if TreeView1.Items.count > 0 then
    TreeView1.TopItem := TreeView1.Items[0];
end;

procedure TPopTreeViewTR_2026.CancelBtnClick(Sender: TObject);
begin
  SelectedString := '';
  Close;
end;

procedure TPopTreeViewTR_2026.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    ListBox1DblClick(Sender);
end;

procedure TPopTreeViewTR_2026.TreeView1DblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;

procedure TPopTreeViewTR_2026.ExpandBtnClick(Sender: TObject);
begin
  Treeview1.FullExpand;
  if Treeview1.Items.count > 0 then
    TreeView1.TopItem := TreeView1.Items[0];
end;

procedure TPopTreeViewTR_2026.CollapseBtnClick(Sender: TObject);
begin
  TreeView1.FullCollapse;
end;

end.

