unit T4T5_2026SearchList;
{Uses a pre-populated SomeString and SomeCaption, displays it
on a list and returns the selected string}

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons;

type
  TSearchListT4T5_2026 = class(TForm)
    ListBox1: TListBox;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    KeyWBox: TEdit;
    procedure OKBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    //procedure KeyWBoxKeyPress(Sender: TObject; var Key: Char);
    //procedure ListBox1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure FormPaint(Sender: TObject);
    procedure KeyWBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SearchList: TSearchListT4T5_2026;

implementation

{$R *.DFM}

uses T4T5_2026Declare,T4T5_2026common,T4T5_2026TrimStr,vtTrimStr,vtShared;

procedure TSearchListT4T5_2026.OKBtnClick(Sender: TObject);
Var
i :integer;
begin
If ListBox1.ItemIndex >-1 then
  SelectedString := AllTrim(ListBox1.items[ListBox1.ItemIndex])
Else SelectedString :='';
If AllTrim(LeftStr(ListBox1.items[ListBox1.ItemIndex],3))='' then SelectedString :='';
Close;
end;

procedure TSearchListT4T5_2026.ListBox1DblClick(Sender: TObject);
{Selected item is a global variable}
begin
OKBtnClick(Sender);
end;

procedure TSearchListT4T5_2026.FormCreate(Sender: TObject);
var
i : integer;
begin
 Caption := SomeCaption;
 For i:= 0 to SomeList.Count -1 do
   ListBox1.Items.Add(SomeList[i]);
 ListBox1.ItemIndex := 0;
end;

procedure TSearchListT4T5_2026.CancelBtnClick(Sender: TObject);
begin
SelectedString := '';
Close;
end;

procedure TSearchListT4T5_2026.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then ListBox1DblClick(Sender);
end;

procedure TSearchListT4T5_2026.FormPaint(Sender: TObject);
Var i:Integer;TempList:TStringList;
begin
 If KeyWBox.Text='' then
 begin
  For i:= 0 to SomeList.Count -1 do ListBox1.Items.Add(SomeList[i]);
  ListBox1.ItemIndex := 0;
  exit;
 end;
 TempList:=TStringList.Create;
 ListBox1.Clear;
 For i:=0 to SomeList.Count-1 do
 begin
  If FindWord(KeyWBox.Text,SomeList[i])>0 then
    TempList.Add(SomeList[i]);
 end;

 For i:=0 to templist.count-1 do ListBox1.Items.Add(TempList[i]);
 If ListBox1.Items.count>0 then ListBox1.ItemIndex:=0; 
 ListBox1.ItemIndex:=0;
 TempList.Free;

end;

procedure TSearchListT4T5_2026.KeyWBoxChange(Sender: TObject);
begin
Paint;
end;

end.
