unit Upoplist;
{Uses a pre-populated SomeString and SomeCaption, displays it
on a list and returns the selected string}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  UDeclare,Buttons;

type
  TPopList = class(TForm)
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
  PopList: TPopList;

implementation

{$R *.DFM}
Uses Trimstr;

procedure TPopList.OKBtnClick(Sender: TObject);
Var
i :integer;
begin
If ListBox1.ItemIndex >-1 then
  SelectedString := AllTrim(SomeList[ListBox1.ItemIndex])
Else SelectedString :='';
Close;
end;

procedure TPopList.ListBox1DblClick(Sender: TObject);
{Selected item is a global variable}
begin
OKBtnClick(Sender);
end;

procedure TPopList.FormCreate(Sender: TObject);
var
i : integer;
begin
 SomeList:=TStringList.Create;  //20141003
 ListBox1.Top := Self.Top + 30;
 PopList.Caption := SomeCaption;
 For i:= 0 to SomeList.Count -1 do
   ListBox1.Items.Add(SomeList[i]);
 ListBox1.ItemIndex := 0;
end;

procedure TPopList.CancelBtnClick(Sender: TObject);
begin
SelectedString := '';
Close;
end;

procedure TPopList.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then ListBox1DblClick(Sender);
end;

end.
