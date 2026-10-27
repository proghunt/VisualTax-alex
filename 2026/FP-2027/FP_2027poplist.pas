unit FP_2027poplist;
{Uses a pre-populated SomeString and SomeCaption, displays it
on a list and returns the selected string}

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons;

type
  TPopListFP_2012 = class(TForm)
    ListBox1: TListBox;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PopList: TPopListFP_2012;

implementation

{$R *.DFM}

uses FP_2027Declare,FP_2027common,FP_2027TrimStr,vtTrimStr,vtShared;
  
procedure TPopListFP_2012.OKBtnClick(Sender: TObject);
Var
i :integer;
begin
If ListBox1.ItemIndex >-1 then
  SelectedString := AllTrim(ListBox1.items[ListBox1.ItemIndex])
Else SelectedString :='';
Close;
end;

procedure TPopListFP_2012.ListBox1DblClick(Sender: TObject);
{Selected item is a global variable}
begin
OKBtnClick(Sender);
end;

procedure TPopListFP_2012.FormCreate(Sender: TObject);
var
i : integer;
begin
 PopList.Caption := SomeCaption;
 For i:= 0 to SomeList.Count-1 do
   ListBox1.Items.Add(SomeList[i]);
 ListBox1.ItemIndex := 0;
end;

procedure TPopListFP_2012.CancelBtnClick(Sender: TObject);
begin
SelectedString := '';
Close;
end;

procedure TPopListFP_2012.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then ListBox1DblClick(Sender);
end;

end.
