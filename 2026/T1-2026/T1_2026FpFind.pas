unit T1_2026FpFind;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons,ExtCtrls,DB,DBCtrls,Grids,DBGrids,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TFPFINDT1_2026 = class(TForm)
    ClearBtn: TBitBtn;
    Panel5: TPanel;
    Panel1: TPanel;
    Label15: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Frm1: TEdit;
    Fld1: TEdit;
    Condition1: TComboBox;
    Value1: TEdit;
    Frm2: TEdit;
    Fld2: TEdit;
    Condition2: TComboBox;
    Value2: TEdit;
    Frm3: TEdit;
    Fld3: TEdit;
    Condition3: TComboBox;
    Value3: TEdit;
    Frm4: TEdit;
    Fld4: TEdit;
    Condition4: TComboBox;
    Value4: TEdit;
    FldType1: TComboBox;
    FldType2: TComboBox;
    FldType3: TComboBox;
    FldType4: TComboBox;
    Label12: TLabel;
    Panel3: TPanel;
    doing: TLabel;
    Label14: TLabel;
    DataDirBox: TEdit;
    ServiceGroup: TRadioGroup;
    DataSource1: TDataSource;
    ListBox1: TListBox;
    FindBtn: TBitBtn;
    BitBtn1: TBitBtn;
    FDConnection: TADConnection;
    Table1: TADTable;
    procedure ListFldBt1Click(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    Function EvaluateCondition(Frm:String;FldNo:Integer;
         FldType:String;Cond:String;Val:String):Boolean;
    {procedure Sample1BtnClick(Sender: TObject);}
    procedure ClearBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    Procedure LoadFilesBox;
   { Procedure DrawList;}
    procedure DataDirBoxExit(Sender: TObject);
    {
    procedure Sample2BtnClick(Sender: TObject);
    procedure Sample3BtnClick(Sender: TObject);
    }
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure ServiceGroupClick(Sender: TObject);
  private
    { Private declarations }
  public
    RetNo:Integer;
  end;

var
  FPFIND: TFPFINDT1_2026;

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026DECLARE,T1_2026COMMOn,T1_2026Common2,
  T1_2026TrimStr,T1_2026ChildWinNew,T1_2026Calc, vtTrimStr, vtShared, vtDataBase;

procedure TFPFINDT1_2026.ListFldBt1Click(Sender: TObject);
begin
 //
end;

procedure TFPFINDT1_2026.FindBtnClick(Sender: TObject);
Const NonNumMsg = 'Field No must be numeric';
      InvalidFrmMsg = 'Invalid Form Name';
      MxLength = 15;
Var Qlf1,Qlf2,Qlf3,Qlf4:boolean; I:integer;
LastFirstName : string; //[45];
FlName :string; //[12];
AdvList :TstringList;
begin
 If ServiceGroup.ItemIndex <0 then
 begin
  ShowMessage('You must select a service first');
  exit;
 end;
 AdvList := TstringList.Create;
 Qlf1:=False;Qlf2:=False;Qlf3:=False;Qlf4:=False;
 If (Frm1.Text ='') and (Frm2.Text ='') and
    (Frm3.Text ='') and (Frm4.Text ='') then exit;

 {edit data entered}
 If (Fld1.text >'') and (Vl(Fld1.text)=0) then begin ShowMessage(NonNumMsg);Fld1.SetFocus;exit;end;
 If (Fld2.text >'') and (Vl(Fld2.text)=0) then begin ShowMessage(NonNumMsg);Fld2.SetFocus;exit;end;
 If (Fld3.text >'') and (Vl(Fld3.text)=0) then begin ShowMessage(NonNumMsg);Fld3.SetFocus;exit;end;
 If (Fld4.text >'') and (Vl(Fld4.text)=0) then begin ShowMessage(NonNumMsg);Fld4.SetFocus;exit;end;
 If DirectoryExists(DataDirBox.Text) = False then
 begin
    ShowMessage('Directory does not exist');
    DataDirBox.SetFocus;
    Exit;
 end;
 If (Frm1.Text > '') and (GetFormNo(UpperCase(Frm1.Text)) =0) then
   begin showMessage(InvalidFrmMsg);Frm1.SetFocus;exit;end;
 If (Frm2.Text > '') and (GetFormNo(UpperCase(Frm2.Text)) =0) then
   begin showMessage(InvalidFrmMsg);Frm2.SetFocus;exit;end;
 If (Frm3.Text > '') and (GetFormNo(UpperCase(Frm3.Text)) =0) then
   begin showMessage(InvalidFrmMsg);Frm3.SetFocus;exit;end;
 If (Frm4.Text > '') and (GetFormNo(UpperCase(Frm4.Text)) =0) then
   begin showMessage(InvalidFrmMsg);Frm4.SetFocus;exit;end;

 {read the return files}
 Screen.Cursor := crHourGlass;
 AdvList.Clear;
 for i:=0 to ListBox1.Items.Count -1 do
 begin
   ListBox1.ItemIndex :=i;
   ListBox1.Refresh;
   //RetNo:=GetCurrentRetNo; //???
   FlName :=AllTrim(ListBox1.Items[i]);
   If (UpperCase(FlName) <> UpperCase(ClientsDBLite))              //20150909 Igor
   and(UpperCase(FlName) <> UpperCase(ClientsDBLite) + '-JOURNAL') //20150909 Igor
   then
   RetNo := ReadReturn(DataDirBox.Text,FlName);
   if RetNo > 0 then
   begin
       Qlf1:=False;Qlf2:=False;Qlf3:=False;Qlf4:=False;
       LastFirstName := FetchElm(RetNo,'T1',5)+' '+
                       FetchElm(RetNo,'T1',2);
       Doing.Caption:=Space(35);
       Doing.Caption := LastFirstName;
       Doing.Refresh;
       CalcAll(RetNo);
       {also normally read only}
       GSTC(RetNo,'GSTC',GetFormno('GSTC'));
       TAXSUM(RetNo,'TAXSUM',GetFormno('TAXSUM'));  {otherwise strings not updated}
       ADDINFO(RetNo,'ADDINFO',GetFormno('ADDINFO'));

       {Evaluate conditions}
       Qlf1 := EvaluateCondition(Frm1.Text,MyStrToInt(Fld1.Text),FldType1.text,Condition1.text,Value1.text);
       Qlf2 := EvaluateCondition(Frm2.Text,MyStrToInt(Fld2.Text),FldType2.text,Condition2.text,Value2.text);
       Qlf3 := EvaluateCondition(Frm3.Text,MyStrToInt(Fld3.Text),FldType3.text,Condition3.text,Value3.text);
       Qlf4 := EvaluateCondition(Frm4.Text,MyStrToInt(Fld4.Text),FldType4.text,Condition4.text,Value4.text);
       {add to the list}
       If (Qlf1 =True) and (Qlf2 =True) and (Qlf3 =True) and (Qlf4 =True) then
          AdvList.Add(PaddR(LastFirstName,MxLength)+'-'+FlName);
    RemoveReturnFromMemory(RetNo);
   end;
 end; {end db scan}
 Doing.Caption := 'All Done';
 SomeList.Clear;
 SomeList.AddStrings(AdvList);
 ShowMessage('All returns checked'
   +Chr(13)+IntToStr(SomeList.Count)+' returns meet the filter criteria');
 AdvList.Free;
 Screen.Cursor := crDefault;
 Table1.Close;
 Close;
end;

Function TFPFINDT1_2026.EvaluateCondition(Frm:String;FldNo:Integer;
         FldType:String;Cond:String;Val:String):Boolean;
Var ReturnValue:String;
begin
 If Frm ='' then begin Result :=True;exit;end;
 Result :=False;
 Frm := UpperCase(AllTrim(Frm));
 If FldType = 'Amount' then
 begin
  ReturnValue :=AllTrim(FetchElm(RetNo,Frm,FldNo));
  Val := AllTrim(Val);
  If (Cond = '>') then  If Vl(ReturnValue) > Vl(Val) then result :=true;
  If (Cond = '=') then If Vl(ReturnValue) = Vl(Val) then result :=true;
  If (Cond = '<')  then If Vl(ReturnValue) < Vl(Val) then result :=true;
  If (Cond = '>=')  then If Vl(ReturnValue) >= Vl(Val) then result :=true;
  If (Cond = '<=')  then If Vl(ReturnValue) <= Vl(Val) then result :=true;
 end;

 If FldType = 'Character' then
 begin
  ReturnValue := AllTrim(UpperCase(LeftStr(FetchElm(RetNo,Frm,FldNo),Length(Val))));
  Val := AllTrim(UpperCase(Val));
  If (Cond = '>')   then If ReturnValue > Val then result :=true;
  If (Cond = '=')   then If ReturnValue = Val then result :=true;
  If (Cond = '<')   then If ReturnValue < Val then result :=true;
  If (Cond = '>=')  then If ReturnValue >= Val then result :=true;
  If (Cond = '<=')  then If ReturnValue <= Val then result :=true;
 end;

end;

procedure TFPFINDT1_2026.FormCreate(Sender: TObject);
begin
 {Sample1BtnClick(Sender);}
 DataDirBox.Text := OptRec.Dir_Cur;
 ServiceGroup.ItemIndex := -1;
 Doing.Caption :='';
 LoadFilesBox;
end;

Procedure TFPFINDT1_2026.LoadFilesBox;
begin
 If Not FileExists(DataDirBox.Text+'\'+AssistDBLite) then
 begin
  ShowMessage('This directory does not have any services listed');
  exit;
 end;
 ListBox1.Items.Clear;

 //20150916 Igor
 SetTableName(FDConnection, Table1, DataDirBox.Text + '\' + AssistDBLite, AssistTableLite, 'File_Name');

 With Table1 do
 begin
  First;
  Repeat
    ListBox1.Items.Add(FieldByName('File_Name').AsString);
    Next;
  until Eof;
 end;
end;
procedure TFPFINDT1_2026.ClearBtnClick(Sender: TObject);
begin
 Frm1.Text := ''; Fld1.Text := ''; FldType1.text := 'Amount';
 Condition1.text := '>'; Value1.Text :='';
Frm2.Text := ''; Fld2.Text := ''; FldType2.text := 'Amount';
 Condition2.text := '>'; Value2.Text :='';
Frm3.Text := ''; Fld3.Text := ''; FldType3.text := 'Amount';
 Condition3.text := '>'; Value3.Text :='';
Frm4.Text := ''; Fld4.Text := ''; FldType4.text := 'Amount';
 Condition4.text := '>'; Value4.Text :='';
end;

procedure TFPFINDT1_2026.BitBtn1Click(Sender: TObject);
begin
Close;
end;

procedure TFPFINDT1_2026.DataDirBoxExit(Sender: TObject);
begin
 If DataDirBox.Text = OptRec.Dir_Cur then exit;
 LoadFilesBox;
end;

procedure TFPFINDT1_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If key = #13 then DataDirBoxExit(Application);
end;

procedure TFPFINDT1_2026.ServiceGroupClick(Sender: TObject);
begin
 ClearBtnClick(Sender);
 Frm1.Text := 'FPCHECK';
 FldType1.text := 'Character';
 Condition1.text := '=';
 Value1.Text :='Y';
 Case ServiceGroup.ItemIndex of
  0: Fld1.Text := '2';  {mortg}
  1: Fld1.Text := '4';  {resp}
  2: Fld1.Text := '6';  {rrsp plan}
  3: Fld1.Text := '8';  {rrsp contr}
  4: Fld1.Text := '12';  {empl pension}
  5: Fld1.Text := '14';  {life ins}
  6: Fld1.Text := '16';  {investm}
  7: Fld1.Text := '18';  {retir allow}
  8: Fld1.Text := '20';  {disabil}
  9: Fld1.Text := '22';  {disabled members}
  10: Fld1.Text := '24';  {gifts}
  11: Fld1.Text := '26';  {tax shelter}
 end;
end;

end.
