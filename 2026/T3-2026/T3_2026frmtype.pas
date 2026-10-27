unit T3_2026frmtype;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Printers,ExtCtrls;

type
  TFrmtypeT3_2026 = class(TForm)
    T3List: TListBox;
    AlList: TListBox;
    MIList: TListBox;
    Label2: TLabel;
    Label6: TLabel;
    ADList: TListBox;
    T3PrvList: TListBox;
    Label7: TLabel;
    T3AllocList: TListBox;
    Label11: TLabel;
    Panel1: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    OpenBtn: TBitBtn;
    PrintBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label15: TLabel;
    FormBox: TEdit;
    T3MJLIST: TListBox;
    T3SPLIST: TListBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FindIt(ThisForm:String);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure T3ListDblClick(Sender: TObject);
    procedure T3AllocListDblClick(Sender: TObject);
    procedure T3PrvListDblClick(Sender: TObject);
    procedure CHListDblClick(Sender: TObject);
    procedure AlListDblClick(Sender: TObject);
    procedure PEListDblClick(Sender: TObject);
    procedure MIListDblClick(Sender: TObject);
    procedure ELListDblClick(Sender: TObject);
    procedure ADListDblClick(Sender: TObject);
    procedure UpdateSelectedForms(FName:string);
    procedure T3ListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CHListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AlListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PEListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MIListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ADListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ELListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Function SelectForm(Sender:TObject):String;
    procedure FormPaint(Sender: TObject);
    Procedure OpenIt(FName:String);
    procedure SingleMouseClick(Sender: TObject);
    procedure DoubleMouseClick(Sender: TObject);
    procedure T3ListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CHListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure AlListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PEListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ELListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure MIListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ADListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    Function IsFormSelected(FName:String):Boolean;
    procedure PAListDblClick(Sender: TObject);
    procedure PAListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PAListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure T3ListKeyPress(Sender: TObject; var Key: Char);
    procedure CHListKeyPress(Sender: TObject; var Key: Char);
    procedure AlListKeyPress(Sender: TObject; var Key: Char);
    procedure PEListKeyPress(Sender: TObject; var Key: Char);
    procedure MIListKeyPress(Sender: TObject; var Key: Char);
    procedure ADListKeyPress(Sender: TObject; var Key: Char);
    procedure ELListKeyPress(Sender: TObject; var Key: Char);
    procedure PAListKeyPress(Sender: TObject; var Key: Char);
    procedure PdfListDblClick(Sender: TObject);
   // procedure BitBtn1Click(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FormBoxExit(Sender: TObject);
    procedure FormBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject); //20170713 Igor


  private
    { Private declarations }
    SelectedForms : TStringList; //20170713 Igor
  public
    { Public declarations }
  end;

var
  FrmtypeT3_2026: TFrmtypeT3_2026;
  RetNo:Integer;
  FName :String{[20]};  // 20150815 igor
  AbrevName : String{[30]}; // 20150815 igor
  //20170713 Igor >>>
  //SelectedForms : TStringList;
  //20170713 Igor <<<

implementation
{$R *.DFM}

uses
  vtMulti, vtCommon, vtDialogs,
  T3_2026,T3_2026Main,T3_2026Declare,T3_2026TrimStr,T3_2026Common,
  T3_2026Common2,T3_2026ChildWinNew,T3_2026Print,
//T3_2026PopList
  vtTrimStr, vtShared,
  vtChild; //20170713 Igor

procedure TFrmtypeT3_2026.FormCreate(Sender: TObject);
Var I:integer;
begin
 KeyPreview:=True;
 RetNo:=GetCurrentRetNo;
 SelectedForms := TstringList.Create;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   if FRec.FormInst > '#1' then continue; //20170409 Igor

   If Frec.FormShow then
   begin
      If Frec.FormType = 'T3' then
       T3List.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'TP' then
       T3PrvList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'TA' then
       T3AllocList.Items.Add(Frec.FormAbrev)
    //  Else If Frec.FormType = 'EL' then ELList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'MI' then
       MIList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'AD' then
       ADList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'AL' then
       ALList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'MJ' then   //20231201
       T3MJList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'SP' then
       T3SPList.Items.Add(Frec.FormAbrev)
      ;
   end;
 end;
 T3List.ItemIndex :=-1;
end;


procedure TFrmtypeT3_2026.FormDestroy(Sender: TObject);//20170713 Igor
begin
  SelectedForms.Free;
end;

procedure TFrmtypeT3_2026.CancelBtnClick(Sender: TObject);
begin
(*
 If (RetInMem =1) and (FormList.Count =0) then
 begin
    MainForm.LeftPanel.Visible:=True;
    FormName := 'T3';
    FormNo := GetFormNo(FormName);
    InitFormData(RetNo,FormNo);
    MainForm.ReduceTutorialHeight(Application);
    OpenForm(RetNo,FormNo,0); //new child
    UpdateAllDataIndicators(RetNo);
    MainForm.FileCloseItemClick(Sender);
 end;
 *)
Close;
//20170713 Igor >>>
//SelectedForms.Free;
//20170713 Igor <<<
end;


procedure TFrmtypeT3_2026.UpdateSelectedForms(FName:string);
Var i:Integer;
Begin
 For i:=0 to SelectedForms.Count-1 do
  If FName = SelectedForms[i] then begin SelectedForms.Delete(i);exit;end;
 SelectedForms.Add(FName);
 Invalidate;
end;

procedure TFrmtypeT3_2026.OpenBtnClick(Sender: TObject);
//20170713 Igor >>>
Var
  i: integer;
  FName: string;
begin
  If FormBox.Text > '' then
  begin
    FindIt(FormBox.text);
    exit;
  end;
  Close;
  if SelectedForms.Count > 1 then
    vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
  try
  
    For i := 0 to SelectedForms.Count - 1 do
    begin
      FName := SelectedForms[i];
      OpenIt(FName);
    end;
  finally
    if SelectedForms.Count > 1 then
      vtChild.CreateNewMDIChild(RetNo, '').ShowAllControls;
  end;
  //If SelectedForms.Count>1 then MainForm.WindowTileItemClick(Sender);
  //SelectedForms.Free;
//20170713 Igor <<<
end;

(* 20090418
procedure TFrmtypes.OpenBtnClick(Sender: TObject);
Var i :integer;
begin
if FName = '' then exit;
{If T3List.ItemIndex <0 then exit;}
//Close;
For i:=0 to SelectedForms.Count-1 do
 begin
  FName := SelectedForms[i];
  MainForm.LeftPanel.Visible:=True;
  OpenIt(FName);
 end;
// If SelectedForms.Count>1 then  MainForm.WindowTileItemClick(Sender);
 SelectedForms.Free;
end;
*)
procedure TFrmtypeT3_2026.SingleMouseClick(Sender: TObject);
begin
FName :=SelectForm(Sender);
If FName = '' then exit;
UpdateSelectedForms(FName);
(Sender as TListBox).Refresh;    {Excellent:refresh the current listbox}

(*
FName :=SelectForm(Sender);
UpdateSelectedForms(FName);
(Sender as TListBox).Refresh;    {Excellent:refresh the current listbox}
*)
end;

procedure TFrmtypeT3_2026.DoubleMouseClick(Sender: TObject);
begin
FName :=SelectForm(Sender);
If FName = '' then exit;
Close;
OpenIt(FName);

{
FName :=SelectForm(Sender);
FrmTypes.Close;
OpenIt(FName);
}
end;

procedure TFrmtypeT3_2026.T3ListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.T3AllocListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.T3PrvListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.CHListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.AlListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.PEListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.MIListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.ELListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.ADListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.PAListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.T3ListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 SingleMouseClick(Sender);
end;

Procedure TFrmtypeT3_2026.OpenIt(FName:String);
Var FNo :Integer;
begin
  FNo := GetFormNo(FName);
  If FNo =0 then FNo :=GetFormNo(FName+'#1');
  OpenForm(RetNo,FNo,0);
end;

Function TFrmtypeT3_2026.SelectForm(Sender:TObject):String;
Var FNo:integer;
begin
If      Sender = T3List then AbrevName := T3List.Items[T3List.ItemIndex]
else If Sender = T3PrvList then AbrevName := T3PrvList.Items[T3PrvList.ItemIndex]
else If Sender = T3AllocList then AbrevName := T3AllocList.Items[T3AllocList.ItemIndex]
//else If Sender = ELList then AbrevName := ELList.Items[ELList.ItemIndex]
//else If Sender = PAList then AbrevName := PAList.Items[PAList.ItemIndex]  //20120219
//else If Sender = PEList then AbrevName := PEList.Items[PEList.ItemIndex] //20140101
else If Sender = MIList then AbrevName := MIList.Items[MIList.ItemIndex]
else If Sender = ADList then AbrevName := ADList.Items[ADList.ItemIndex]
else If Sender = ALList then AbrevName := ALList.Items[ALList.ItemIndex]
;

AbrevName := RTrim(AbrevName);
Result := GetFName(AbrevName);
end;


procedure TFrmtypeT3_2026.CHListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.AlListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.PEListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.MIListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.ADListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.ELListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.FormPaint(Sender: TObject);
begin

If SelectedForms.Count >0 then
  begin
  OpenBtn.Enabled := True;
  PrintBtn.Enabled := True;
  end
else
  begin
  OpenBtn.Enabled := False;
  PrintBtn.Enabled := False;
  end;

end;

Function TFrmtypeT3_2026.IsFormSelected(FName:String):Boolean;
Var I:integer;
begin
 Result := False;
 For i:=0 to SelectedForms.Count-1 do
   If FName = SelectedForms[i] then begin Result := True;Exit;End;
end;

procedure TFrmtypeT3_2026.T3ListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var
  Offset: Integer;	{ text offset width }
  FNo :integer;
begin
  with (Control as TListBox).Canvas do	{ draw on the control canvas, not on the form }
  begin
   FillRect(Rect);	{ clear the rectangle }
   Offset := 1;	{ provide default offset }
   AbrevName := (Control as TListBox).Items[Index];
   Fname := GetFName(AbrevName);
   FNo := GetFormNo(FName);
   Font.color := clBlack;
   If IsFormSelected(FName) then
     begin Font.color := clWhite; Brush.Color := clRed;end;
   If Ret[RetNo].FrmHasData[FNo] then
     Font.color := clBlue;
   TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index]);
  end;
end;

procedure TFrmtypeT3_2026.CHListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T3ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypeT3_2026.AlListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T3ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypeT3_2026.PEListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T3ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypeT3_2026.ELListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T3ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypeT3_2026.MIListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T3ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypeT3_2026.ADListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T3ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypeT3_2026.PAListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T3ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypeT3_2026.PAListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypeT3_2026.T3ListKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);

end;


procedure TFrmtypeT3_2026.CHListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);

end;

procedure TFrmtypeT3_2026.AlListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);

end;

procedure TFrmtypeT3_2026.PEListKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);

end;

procedure TFrmtypeT3_2026.MIListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);

end;

procedure TFrmtypeT3_2026.ADListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);

end;

procedure TFrmtypeT3_2026.ELListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);

end;

procedure TFrmtypeT3_2026.PAListKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 then DoubleMouseClick(Sender);
 If Key = #32 then SingleMouseClick(Sender);

end;


procedure TFrmtypeT3_2026.PdfListDblClick(Sender: TObject);
begin
  FName :=SelectForm(Sender);
  If FName = '' then exit;
  //OpenPdfForm(FName);
  Close;
end;


procedure TFrmtypeT3_2026.PrintBtnClick(Sender: TObject);
Var i:Integer;
begin
 If Not AllowedToFormPrint(RetNo,FormName) then exit;
 If MainFormT3.PrintDialogItem.Execute then
 begin
    For i:=0 to SelectedForms.Count-1 do
     begin
      FName := SelectedForms[i];
      MainFormT3.StartPrintForm(Retno,FName,99);
     end;
   if Printer.Printing then //20160905 Igor
     Printer.EndDoc;        //20160905 Igor
 end;

 SelectedForms.Clear;
 FormPaint(Application);
end;

procedure TFrmtypeT3_2026.FormBoxExit(Sender: TObject);
begin
 If FormBox.Text>'' then OpenBtnClick(Sender);
end;

procedure TFrmtypeT3_2026.FindIt(ThisForm:String);  //20170418 Igor
(*
Var i,Elm,FNo:Integer;FName:String;
  //FormRecs,
  ResultsList:TStringList;
    List1:TStringList;
*)
begin
  if QuickFormFind(RetNo, ThisForm) then
    Close;
(*
 ThisForm:=UpperCase(ThisForm);
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If ThisForm=AllTrim(ExtractFormRootName(Frec.FormName)) then
   begin
    FNo := GetFormNo(Frec.FormInstName);
    If FNo>0 then
    begin
     OpenForm(RetNo,FNo,0);
     Close;
     //List1.Free;
     exit;
   end;
  end;
 end;
  //load the firms
     List1:=TStringList.Create;
     List1.Clear;
     List1.Sorted := True;
     for i :=0 to (FList.Count - 1) do
     begin
      FRec := FList.Items[i];
      If Frec.FormShow then
         List1.Add(PaddR(Frec.FormAbrev,80)+Frec.FormInstName);
       //List1.Add(PaddR(Frec.FormRlNm,10)+PaddR(Frec.FormDescr,70)+Frec.FormName+Frec.FormInst);
     end; //i

 //not found as formname
  ResultsList:=TStringList.Create;
  IsAnyWhereInList(ThisForm,List1,ResultsList);
  List1.Free;
  If ResultsList.Count=0 then
  begin
    ResultsList.Free;
    ShowTimedMsg('Not found!',1300);
    Exit;
  end;

  SomeCaption := 'Form or KeyWord found in following';
  SelectedString := PopSomeList(ResultsList,SomeCaption);
  ResultsList.Free;
  If SelectedString > '' then
  begin
   FName:=UpperCase(AllTrim(MidStr(SelectedString,85,10)));
   FNo := GetFormNo(FName);
   If FNo>0 then
   begin
    OpenForm(RetNo,FNo,0);
    Close;
    exit;
   end;
  end;
*)
end;



procedure TFrmtypeT3_2026.FormBoxKeyPress(Sender: TObject; var Key: Char);
begin
if key=#13 then OpenBtnClick(Sender);
end;

end.
