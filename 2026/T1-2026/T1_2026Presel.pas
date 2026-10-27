unit T1_2026presel;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls,vtShape;

type
  TPreSelT1_2026 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    ListBox1: TListBox;
    StudentBox: TCheckBox;
    EmployeeBox: TCheckBox;
    PensionerBox: TCheckBox;
    InvestorBox: TCheckBox;
    CreditsBox: TCheckBox;
    Label2: TLabel;
    Dependants: TCheckBox;
    RrspBox: TCheckBox;
    Label4: TLabel;
    SingleBtn: TBitBtn;
    CancelBtn: TBitBtn;
    SelectedOnlyBtn: TBitBtn;
    EditAllBtn: TBitBtn;
    EditNoneBtn: TBitBtn;
    SelfEmployedBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure SingleBtnClick(Sender: TObject);


    Function GetIndexOfForm(FName:String):Integer;
    procedure CancelBtnClick(Sender: TObject);
    procedure SingleMouseClick(Sender: TObject);
    procedure DoubleMouseClick(Sender: TObject);
    Function IsFormSelected(FName:String):Boolean;
    Function ExtractFormName(Ndx:Integer):String;
    procedure OpenIt(FName:String);
    procedure UpdatePreSelForms(FName:string);
    procedure FormPaint(Sender: TObject);
    procedure SelectedOnlyBtnClick(Sender: TObject);
    procedure EditNoneBtnClick(Sender: TObject);
    procedure EditAllBtnClick(Sender: TObject);
    Function  GetValidFormNo(FName:String):Integer;
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure EmployeeBoxClick(Sender: TObject);
    procedure InvestorBoxClick(Sender: TObject);
    procedure PensionerBoxClick(Sender: TObject);
    procedure StudentBoxClick(Sender: TObject);
    procedure DependantsClick(Sender: TObject);
    procedure RrspBoxClick(Sender: TObject);
    procedure CreditsBoxClick(Sender: TObject);
    procedure SelfEmployedBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    RetNo:Integer;
  end;

var
  PreSel: TPreSelT1_2026;
  {SelectedForms : TStringList;}

implementation

{$R *.DFM}

uses vtTrimStr,vtCommon,T1_2026,T1_2026Declare,T1_2026TrimStr,
  T1_2026ChildWinNEW,T1_2026Common;

procedure TPreSelT1_2026.FormCreate(Sender: TObject);
begin
RetNo:=GetCurrentRetNo;
Panel1.Color := GetRetColor(RetNo);
ListBox1.Items.LoadFromFile(AppDir+'\PRESEL.D');
ListBox1.ItemIndex :=0;
end;

Function TPreSelT1_2026.IsFormSelected(FName:String):Boolean;
Var I:integer;
begin
 Result := False;
 If FName ='' then exit;
 //If ret[RetNo].PreSelForms = Nil then exit;
 For i:=0 to Ret[RetNo].PreSelForms.Count-1 do
   If FName = Ret[RetNo].PreSelForms[i] then begin Result := True;Exit;End;
end;

procedure TPreSelT1_2026.UpdatePreSelForms(FName:string);
Var i:Integer;
Begin
  For i:=0 to Ret[RetNo].PreSelForms.Count-1 do
   If FName = Ret[RetNo].PreSelForms[i] then
    begin Ret[RetNo].PreSelForms.Delete(i);exit;end;
  If GetValidFormNo(FName) >0 then
  begin
   If IsInList(FName, Ret[RetNo].PreselForms) = -1 then Ret[RetNo].PreSelForms.Add(FName);
  end;

 Invalidate;
end;


procedure TPreSelT1_2026.SingleMouseClick(Sender: TObject);
Var FName :string; //[12];
begin
FName :=ExtractFormName(ListBox1.ItemIndex);
UpdatePreSelForms(FName);
ListBox1.Refresh; {to show highlight on selected item}
end;

procedure TPreSelT1_2026.DoubleMouseClick(Sender: TObject);
Var FName :string; //[12];
begin
FName :=ExtractFormName(ListBox1.ItemIndex);
Close;
OpenIt(FName);
end;

Function TPreSelT1_2026.ExtractFormName(Ndx:Integer):String;
Var FNo:integer;
begin
 Result := ALLTRIM(UpperCase(LeftStr(ListBox1.Items[Ndx],10)));
end;

procedure TPreSelT1_2026.OpenIt(FName:String);
Var FNo :Integer;
begin
 FNo := GetValidFormNo(FName);
 If FNo >0 then OpenForm(RetNo,FNo,0);
end;


procedure TPreSelT1_2026.SingleBtnClick(Sender: TObject);
Var FName :String; I:integer;
begin
DoubleMouseClick(Sender);
end;

procedure TPreSelT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TPreSelT1_2026.FormPaint(Sender: TObject);
begin
 RetNo:=GetCurrentRetNo;
 //If Ret[RetNo].PreSelForms = Nil then exit;
 If Ret[RetNo].PreSelForms.Count >0 then
   SingleBtn.Enabled := True
 else
   SingleBtn.Enabled := False;
end;

procedure TPreSelT1_2026.SelectedOnlyBtnClick(Sender: TObject);
Var FName :String; I,k:integer;
begin

 If Ret[RetNo].PreselForms.Count =0 then
 begin
  ShowMessage('No forms selected. Click once on the required items');
  exit;
 end;
 Ret[RetNo].PreSelSw := True;
 Ret[RetNo].PreSelNdx :=0;
 Close;

 //new
 For i:=0 to Ret[RetNo].PreselForms.count-1 do
   OpenForm(RetNo,Ret[RetNo].PreSelForms[i],0);
 EXIT;
end;

Function TPreSelT1_2026.GetIndexOfForm(FName:String):Integer;
Var i:Integer;  TempList:TStringList;
begin
 TempList:=TStringList.Create;
 For i:=0 to ListBox1.Items.count -1 do TempList.Add(ListBox1.Items[i]);
 result:=IsInList(FName,TempList);
 TempList.Free;
end;

procedure TPreSelT1_2026.EditNoneBtnClick(Sender: TObject);
begin
 Ret[RetNo].PreSelForms.Clear;
 Ret[RetNo].PreSelSw := False;
 Ret[RetNo].PreSelNdx := 0;
 ListBox1.Refresh;
 //if MessageDlg('All selections have been removed. Go to forms?',mtInformation, [mbYes, mbNo], 0) = mrYes then Close;
end;

Function TPreSelT1_2026.GetValidFormNo(FName:String):Integer;
Var FNo :Integer;
begin
 FNo := GetFormNo(FName);
 If Fno >0 then begin result := FNo;exit;end;
 FName := FName+'#1';
 FNo := GetFormNo(FName);
 If Fno >0 then begin result := FNo;exit;end;
 result :=0;
end;

procedure TPreSelT1_2026.EditAllBtnClick(Sender: TObject);
Var i: integer;FName: string; //[12];
begin
  For i:=0 to ListBox1.Items.Count-1 do
  begin
    FName :=ExtractFormName(i);
    If GetValidFormNo(FName)>0  then Ret[RetNo].PreSelForms.Add(FName);
  end;
  ListBox1.Refresh;
  Ret[RetNo].PreSelSw := True;
  if MessageDlg('All forms have been selected. Go to forms now?',
    mtInformation, [mbYes, mbNo], 0) = mrYes then
   begin
    Close;
    FName := Ret[RetNo].PreSelForms[0];
    OpenIt(FName);
   end;
end;

procedure TPreSelT1_2026.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Fno,Offset: Integer;	{ text offset width }
  ShowStr, FName :string;
begin
  with (Control as TListBox).Canvas do	{ draw on the control canvas, not on the form }
  begin
   FillRect(Rect);	{ clear the rectangle }
   Offset := 1;	{ provide default offset }
   FName :='';
   {treat headers}
   If LeftStr(ListBox1.Items[Index],1) = '$' then
    begin
     ShowStr := MidStr(ListBox1.Items[Index],2,70);;
     Font.color := clNavy; //BtnShadow;
     Font.Size :=10;
     Font.Style := [fsBold];
    end
   else
     begin
     ShowStr :=ListBox1.Items[Index];
     Font.Size :=10;
     Font.Style:=[];
     Fname := ExtractFormName(Index);
     FNo := GetValidFormNo(FName);
     If FNo >0 then {try}
       If IsFormSelected(FName) then {item already clicked}
         Font.color := clRed
       else
         Font.color := clBlack;;Font.Style:=[];
     end;
   TextOut(Rect.Left + Offset, Rect.Top, ShowStr);
  end;
end;

procedure TPreSelT1_2026.ListBox1DblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TPreSelT1_2026.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TPreSelT1_2026.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 SingleMouseClick(Sender);
end;

procedure TPreSelT1_2026.SpeedButton1Click(Sender: TObject);
begin
 SelectedOnlyBtnClick(Sender);
end;

procedure TPreSelT1_2026.EmployeeBoxClick(Sender: TObject);
Var k:Integer;
begin
 k:=GetIndexOfForm('T4#1');
 If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
end;

procedure TPreSelT1_2026.InvestorBoxClick(Sender: TObject);
Var k:Integer;
begin
 k:=GetIndexOfForm('T5MULT#1');
 If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
end;


procedure TPreSelT1_2026.PensionerBoxClick(Sender: TObject);
Var k:Integer;
begin
 k:=GetIndexOfForm('T4A#1');
 If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
 k:=GetIndexOfForm('T4AP#1');
 If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
 k:=GetIndexOfForm('T4AOAS#1');
 If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
end;

procedure TPreSelT1_2026.StudentBoxClick(Sender: TObject);
Var k:Integer;
begin
 k:=GetIndexOfForm('T4A#1');
 If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
 k:=GetIndexOfForm('S11');
 If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
 k:=GetIndexOfForm('STLOAN');
 If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
end;

procedure TPreSelT1_2026.DependantsClick(Sender: TObject);
Var k:Integer;
begin
 k:=GetIndexOfForm('DEPEND');
 If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
end;

procedure TPreSelT1_2026.RrspBoxClick(Sender: TObject);
Var k:Integer;
begin
 k:=GetIndexOfForm('RRSP');
 If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
end;

procedure TPreSelT1_2026.CreditsBoxClick(Sender: TObject);
Var k:Integer; Prv:String;FName:String;
begin
 FName:=WhichCreditForm(RetNo,Ret[RetNo].Province);
 k:=GetIndexOfForm(FName);
 If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
 If FName='MB479' then
 begin
  FName:='MB479';
  k:=GetIndexOfForm(FName);
  If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
 end;

 If FName='NL428' then
 begin
  FName:='NL428';
  k:=GetIndexOfForm(FName);
  If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
 end;

 If FName='PE428' then
 begin
  FName:='PE428';
  k:=GetIndexOfForm(FName);
  If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
 end;

 If FName='NB428' then
 begin
  FName:='NB428';
  k:=GetIndexOfForm(FName);
  If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
 end;

 If FName='SK428' then
 begin
  FName:='SK428';
  k:=GetIndexOfForm(FName);
  If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
 end;
end;

procedure TPreSelT1_2026.SelfEmployedBoxClick(Sender: TObject);
Var k:Integer;
begin
 k:=GetIndexOfForm('T2125#1');
 If K>0 then begin ListBox1.ItemIndex:=k;SingleMouseClick(Application);end;
end;

end.
