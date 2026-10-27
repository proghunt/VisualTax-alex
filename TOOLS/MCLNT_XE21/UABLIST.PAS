unit Uablist;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,
  UDeclare,TrimStr, Buttons, ExtCtrls,ChildWin;

type
  TABList = class(TForm)
    Panel1: TPanel;
    ListBox1: TListBox;
    OpenBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FindBox: TEdit;
    Label1: TLabel;
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FindBoxChange(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CancelBtnClick(Sender: TObject);
    procedure SingleMouseClick(Sender: TObject);
    procedure DoubleMouseClick(Sender: TObject);
    Function IsFormSelected(FName:String):Boolean;
    Function ExtractFormName(Sender:TObject):String;
    procedure OpenIt(FName:String);
    procedure UpdateSelectedForms(FName:string);
    procedure FormPaint(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ABList: TABList;
  SelectedForms : TStringList;
implementation

{$R *.DFM}

procedure TABList.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Fno,Offset: Integer;	{ text offset width }
  ShowStr :String[30];FName :string[10];
begin
  with (Control as TListBox).Canvas do	{ draw on the control canvas, not on the form }
  begin
    FillRect(Rect);	{ clear the rectangle }
    Offset := 1;	{ provide default offset }

   Fname := Ltrim(RTrim(ExtractFormName(Control)));
   FNo := GetFormNo(FName);

   {treat headers}
   If LeftStr(ListBox1.Items[Index],1) = '$' then
    begin
     ShowStr := MidStr(ListBox1.Items[Index],2,32);
     Font.color := clWhite;
     Brush.Color := clRed;
     Font.Size :=10;
     Font.Style := [fsBold,fsUnderline];
    end
   else
     begin
     ShowStr := LeftStr(ListBox1.Items[Index],32);
     Font.color := clBlack;
     Font.Size :=8;
     Font.Style := [];
     Brush.Color := (Control as TListBox).Color;
     end;
    (*
    begin
     If FName>'' then
     If IsFormSelected(FName) then {item already clicked}
         begin
          Font.color := clWhite; Brush.Color := clRed;Font.Style:=[];
          If FNo>0 then
            If Ret[RetNo]^.FrmHasData[FNo] then Font.color := clBlue;
         end
     else
         begin Font.color := clBlack;Font.Style:=[]; Brush.Color := (Control as TListBox).Color;end;
     ShowStr := LeftStr(ListBox1.Items[Index],32);
    end;
    *)

   TextOut(Rect.Left + Offset, Rect.Top, ShowStr);
  end;
end;

procedure TABList.FormCreate(Sender: TObject);
begin
SelectedForms := TStringList.Create;
{ListBox1.Items.LoadFromFile(AppDir+'\Interv.New');}
ListBox1.Items.LoadFromFile(AppDir+'\Alphandx.d');
ListBox1.ItemIndex :=0;
end;

Function TABList.IsFormSelected(FName:String):Boolean;
Var I:integer;
begin
 Result := False;
 If FName ='' then exit;
 For i:=0 to SelectedForms.Count-1 do
   If FName = SelectedForms[i] then begin Result := True;Exit;End;
end;

procedure TABList.UpdateSelectedForms(FName:string);
Var i:Integer;
Begin
 For i:=0 to SelectedForms.Count-1 do
  If FName = SelectedForms[i] then begin SelectedForms.Delete(i);exit;end;
 SelectedForms.Add(FName);
 Invalidate;
end;


procedure TABList.SingleMouseClick(Sender: TObject);
Var FName :string[10];
begin
FName :=ExtractFormName(Sender);
UpdateSelectedForms(FName);
ListBox1.Refresh; {to show highlight on selected item}
end;

procedure TABList.DoubleMouseClick(Sender: TObject);
Var FName :String[10];
begin
FName :=ExtractFormName(Sender);
ABList.Close;
OpenIt(FName);
end;

Function TABList.ExtractFormName(Sender:TObject):String;
Var FNo:integer;
begin
Result := UpperCase(MidStr(ListBox1.Items[ListBox1.ItemIndex],33,10));
end;

procedure TABList.OpenIt(FName:String);
Var FNo :Integer;
begin
  FNo := GetFormNo(FName);
  If FNo =0 then FNo :=GetFormNo(FName+'#1');
  OpenForm(RetNo,FNo);
end;

procedure TABList.FindBoxChange(Sender: TObject);
Var WhichItem :string[20];
 I : integer;
begin
 WhichItem := UpperCase(FindBox.Text);
 For i := 0 to ListBox1.Items.Count-1 do
   begin
     If WhichItem = UpperCase(LeftStr(ListBox1.Items[i],Length(WhichItem)))
     then begin ListBox1.ItemIndex := i;ListBox1.Refresh;exit;end;
  end;
end;

procedure TABList.OpenBtnClick(Sender: TObject);
Var FName :String[10]; I:integer;
begin
 Close;
 For i:=0 to SelectedForms.Count-1 do
  begin
   FName := SelectedForms[i];
   OpenIt(FName);
 end;
 SelectedForms.Free;
end;

procedure TABList.ListBox1DblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TABList.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 SingleMouseClick(Sender);
end;

procedure TABList.CancelBtnClick(Sender: TObject);
begin
Close;
SelectedForms.Free;
end;

procedure TABList.FormPaint(Sender: TObject);
begin
 If SelectedForms.Count >0 then
   OpenBtn.Enabled := True
 else
   OpenBtn.Enabled := False;
end;

procedure TABList.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

end.
