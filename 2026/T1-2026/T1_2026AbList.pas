unit T1_2026ablist;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls;

type
  TABListT1_2026 = class(TForm)
    Panel1: TPanel;
    ListBox1: TListBox;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    OpenBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FindBox: TEdit;
    Panel3: TPanel;
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
    procedure FindBoxKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    RetNo:Integer;
    SelectedForms : TStringList;
  end;

var
  ABList: TABListT1_2026;

implementation

{$R *.DFM}

uses vtTrimStr,vtCommon,T1_2026Declare,T1_2026TrimStr,T1_2026ChildWinNEW;

procedure TABListT1_2026.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Fno,Offset: Integer;	{ text offset width }
  ShowStr,FName :string;
begin
  with (Control as TListBox).Canvas do	{ draw on the control canvas, not on the form }
  begin
    FillRect(Rect);	{ clear the rectangle }
    Offset := 1;	{ provide default offset }

   Fname := Ltrim(RTrim(ExtractFormName(Control)));
   FNo := GetFormNo(FName);

   {treat headers}
   If LeftStr(ListBox1.Items[Index],1) = '-' then
    begin
     ShowStr := MidStr(ListBox1.Items[Index],2,48); //ShowStr := MidStr(ListBox1.Items[Index],2,40); //20170410
     Font.color := clRed;
     Brush.Color := (Control as TListBox).Color;
     {Brush.Color := clBlack;}
     Font.Size :=10;
     Font.Style := [fsBold];
    end
   else
     begin
     ShowStr := LeftStr(ListBox1.Items[Index],48);//ShowStr := LeftStr(ListBox1.Items[Index],40);    //20170410
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
            If ret[RetNo].FrmHasData[FNo] then Font.color := clBlue;
         end
     else
         begin Font.color := clBlack;Font.Style:=[]; Brush.Color := (Control as TListBox).Color;end;
     ShowStr := LeftStr(ListBox1.Items[Index],32);
    end;
    *)

   TextOut(Rect.Left + Offset, Rect.Top, ShowStr);
  end;
end;

procedure TABListT1_2026.FormCreate(Sender: TObject);
begin
SelectedForms := TStringList.Create;
ListBox1.Items.LoadFromFile(AppDir+'\Alphandx.d');
ListBox1.ItemIndex :=0;
end;

Function TABListT1_2026.IsFormSelected(FName:String):Boolean;
Var I:integer;
begin
 Result := False;
 If FName ='' then exit;
 For i:=0 to SelectedForms.Count-1 do
   If FName = SelectedForms[i] then begin Result := True;Exit;End;
end;

procedure TABListT1_2026.UpdateSelectedForms(FName:string);
Var i:Integer;
Begin
 For i:=0 to SelectedForms.Count-1 do
  If FName = SelectedForms[i] then begin SelectedForms.Delete(i);exit;end;
 SelectedForms.Add(FName);
 Invalidate;
end;


procedure TABListT1_2026.SingleMouseClick(Sender: TObject);
Var FName :string; //[12];
begin
FName :=ExtractFormName(Sender);
UpdateSelectedForms(FName);
ListBox1.Refresh; {to show highlight on selected item}
end;

procedure TABListT1_2026.DoubleMouseClick(Sender: TObject);
Var FName :string; //[12];
begin
FName :=ExtractFormName(Sender);
ABList.Close;
OpenIt(FName);
end;

Function TABListT1_2026.ExtractFormName(Sender:TObject):String;
Var FNo:integer;
begin
Result := UpperCase(AllTrim(MidStr(ListBox1.Items[ListBox1.ItemIndex],37,12)));
end;

procedure TABListT1_2026.OpenIt(FName:String);
Var FNo :Integer;
begin
  RetNo:=GetCurrentRetNo;
  FNo := GetFormNo(FName);
  If FNo =0 then FNo :=GetFormNo(FName+'#1');
  OpenForm(RetNo,FNo,0);
end;

procedure TABListT1_2026.FindBoxChange(Sender: TObject);
Var WhichItem :string; //[20];
 I : integer;
begin
 WhichItem := UpperCase(FindBox.Text);
 For i := 0 to ListBox1.Items.Count-1 do
   begin
     If WhichItem = UpperCase(LeftStr(ListBox1.Items[i],Length(WhichItem)))
     then begin ListBox1.ItemIndex := i;ListBox1.Refresh;exit;end;
  end;
end;

procedure TABListT1_2026.OpenBtnClick(Sender: TObject);
Var FName :string; //[12];
  I:integer;
begin
 Close;
 For i:=0 to SelectedForms.Count-1 do
  begin
   FName := SelectedForms[i];
   OpenIt(FName);
 end;
 SelectedForms.Free;
end;

procedure TABListT1_2026.ListBox1DblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TABListT1_2026.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 SingleMouseClick(Sender);
end;

procedure TABListT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
SelectedForms.Free;
end;

procedure TABListT1_2026.FormPaint(Sender: TObject);
begin
 FindBox.SetFocus;
 If SelectedForms.Count >0 then
   OpenBtn.Enabled := True
 else
   OpenBtn.Enabled := False;
end;

procedure TABListT1_2026.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TABListT1_2026.FindBoxKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
end;

end.
