unit FP_2027PopTreeview;
{Uses a pre-populated SomeString and SomeCaption, displays it
on a list and returns the selected string}

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,ComCtrls;

type
  TPopTreeViewFP_2012 = class(TForm)
    TreeView1: TTreeView;
    Panel1: TPanel;
    Panel2: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure TreeView1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PopTreeView: TPopTreeViewFP_2012;

implementation

{$R *.DFM}

uses FP_2027Declare,FP_2027TrimStr,vtTrimStr,vtShared;
  
procedure TPopTreeViewFP_2012.OKBtnClick(Sender: TObject);
Var SourceNode : TTreeNode; Ndx :Integer;Rec:String;
 Flags: OLEVariant;
 i :integer;
begin
 Flags:= 0;
 SourceNode:= Treeview1.Selected;
 If SourceNode <> Nil then
 begin
  Ndx :=SourceNode.AbsoluteIndex;
  Rec:=SourceNode.text;
  SelectedString:=Rec;
 end;
 {
 If ListBox1.ItemIndex >-1 then
   SelectedString := AllTrim(SomeList[ListBox1.ItemIndex])
 Else SelectedString :='';
 }
 Close;
end;

procedure TPopTreeViewFP_2012.ListBox1DblClick(Sender: TObject);
{Selected item is a global variable}
begin
OKBtnClick(Sender);
end;

procedure TPopTreeViewFP_2012.FormCreate(Sender: TObject);
var
i : integer; SourceNo,SourceDoc,PrevSourceDoc,ATitle:String;
aList:TStringList;
begin
 aList:=TStringList.Create;
 Treeview1.Items.clear;
 PopTreeView.Caption := SomeCaption;
 PrevSourceDoc:='';
 For i:= 0 to SomeList.Count -1 do
 begin
   SourceNo:=PaddR(AllTrim(LeftStr(SomeList[i],4)),4);
   SourceDoc:=AllTrim(MidStr(SomeList[i],6,30));
   aTitle:=AllTrim(MidStr(SomeList[i],36,100));
   If i=0 then Begin aList.Add(SourceDoc);PrevSourceDoc:=SourceDoc;end;
   If SourceDoc =PrevSourceDoc then
     aList.Add(' '+PaddR(aTitle,100)+' '+SourceNo)
   else //new source doc
   begin
    aList.Add(SourceDoc);
    aList.Add(' '+PaddR(aTitle,100)+' '+SourceNo);
    PrevSourceDoc:=SourceDoc;
   end;
 end;
 aList.SaveToFile(AppDir+'\'+'Temp.txt');
 aList.Free;
 Try
  Treeview1.LoadFromFile(AppDir+'\'+'Temp.txt');
  TreeView1.FullExpand;
 Except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
 If TreeView1.Items.count>0 then TreeView1.TopItem:=TreeView1.Items[0];
end;

procedure TPopTreeViewFP_2012.CancelBtnClick(Sender: TObject);
begin
SelectedString := '';
Close;
end;

procedure TPopTreeViewFP_2012.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then ListBox1DblClick(Sender);
end;

procedure TPopTreeViewFP_2012.TreeView1DblClick(Sender: TObject);
begin
 OKBtnClick(Sender);
end;

end.
