unit T4T5_2026frmtype;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Printers,ExtCtrls;

type
  TFrmtypeT4T5_2026 = class(TForm)
    SLList: TListBox;
    Label2: TLabel;
    Panel1: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    OpenBtn: TBitBtn;
    PrintBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label15: TLabel;
    FormBox: TEdit;
    Label9: TLabel;
    Label3: TLabel;
    OtherList: TListBox;
    procedure FindIt(ThisForm:String);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure SLListDblClick(Sender: TObject);
    procedure UpdateSelectedForms(FName:string);
    procedure SLListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Function SelectForm(Sender:TObject):String;
    procedure FormPaint(Sender: TObject);
    Procedure OpenIt(FName:String);
    procedure SingleMouseClick(Sender: TObject);
    procedure DoubleMouseClick(Sender: TObject);
    procedure SLListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    Function IsFormSelected(FName: String):Boolean;
    procedure PAListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SLListKeyPress(Sender: TObject; var Key: Char);
    procedure PdfListDblClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure FormBoxExit(Sender: TObject);
    procedure FormBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject); //20170621 Igor


  private
    { Private declarations }
    SelectedForms : TStringList; //20170621 Igor
  public
    { Public declarations }
  end;

var
  FrmtypeT4T5_2026: TFrmtypeT4T5_2026;
  RetNo:Integer;
  FName :String{[20]};  // 20150815 igor
  AbrevName : String{[30]}; // 20150815 igor
  //SelectedForms : TStringList; //20170515 Igor

implementation
{$R *.DFM}

uses
  vtMulti, vtCommon, vtDialogs,
  T4T5_2026,T4T5_2026Main,T4T5_2026Declare,T4T5_2026TrimStr,T4T5_2026Common,
  T4T5_2026Common2,T4T5_2026ChildWinNew,T4T5_2026Print,
//T4T5_2026PopList
  vtTrimStr, vtShared,
  vtChild; //20170621 Igor

procedure TFrmtypeT4T5_2026.FormCreate(Sender: TObject);
Var I:integer;
  c: TComponent;
begin
 KeyPreview:=True;
 RetNo:=GetCurrentRetNo;
 SelectedForms := TstringList.Create;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   if FRec.FormInst > '#1' then continue; //20170729 Igor
   If Frec.FormShow then
   begin
      c := Self.FindComponent(Frec.FormType+'List');
      if (c <> nil) and (c is TListBox) then
      //20170621 Igor >>>
        if (c as TListBox).Items.IndexOf(Frec.FormAbrev) = -1 then
          (c as TListBox).Items.Add(Frec.FormAbrev)
        else
      else
        if OtherList.Items.IndexOf(Frec.FormAbrev) = -1 then
          OtherList.Items.Add(Frec.FormAbrev);
      //20170621 Igor <<<
   end;
 end;
end;


procedure TFrmtypeT4T5_2026.FormDestroy(Sender: TObject); //20170621 Igor
begin
  SelectedForms.Free;
end;

procedure TFrmtypeT4T5_2026.CancelBtnClick(Sender: TObject);
begin
  Close;
  //SelectedForms.Free; //20170621 Igor
end;


procedure TFrmtypeT4T5_2026.UpdateSelectedForms(FName:string);
Var i:Integer;
Begin
 For i:=0 to SelectedForms.Count-1 do
  If FName = SelectedForms[i] then begin SelectedForms.Delete(i);exit;end;
 SelectedForms.Add(FName);
 Invalidate;
end;

procedure TFrmtypeT4T5_2026.OpenBtnClick(Sender: TObject);
//20170621 Igor >>>
Var
  i: integer;
  FName: string; //[10];
begin
  If FormBox.Text > '' then
  begin
    FindIt(FormBox.text);
    exit;
  end;
  Close;
  vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
  try
    For i := 0 to SelectedForms.Count - 1 do
    begin
      FName := SelectedForms[i];
      OpenIt(FName);
    end;
    //If SelectedForms.Count>1 then MainForm.WindowTileItemClick(Sender);
  finally
    vtChild.CreateNewMDIChild(RetNo, '').ShowAllControls;
  end;
  //SelectedForms.Free;
//20170621 Igor <<<
end;

procedure TFrmtypeT4T5_2026.SingleMouseClick(Sender: TObject);
begin
FName :=SelectForm(Sender);
If FName = '' then exit;
UpdateSelectedForms(FName);
(Sender as TListBox).Refresh;    {Excellent:refresh the current listbox}

end;

procedure TFrmtypeT4T5_2026.DoubleMouseClick(Sender: TObject);
begin
FName :=SelectForm(Sender);
If FName = '' then exit;
Close;
OpenIt(FName);
end;

procedure TFrmtypeT4T5_2026.SLListDblClick(Sender: TObject);
begin
  DoubleMouseClick(Sender);
end;
procedure TFrmtypeT4T5_2026.SLListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SingleMouseClick(Sender);
end;

Procedure TFrmtypeT4T5_2026.OpenIt(FName:String);
Var FNo :Integer;
begin
  FNo := GetFormNo(FName);
  If FNo =0 then FNo :=GetFormNo(FName+'#1');
  OpenForm(RetNo,FNo,0);
end;

Function TFrmtypeT4T5_2026.SelectForm(Sender:TObject):String;
begin
  if (Sender <> nil) AND (Sender is TListBox) then
    AbrevName := (Sender as TListBox).Items[(Sender as TListBox).ItemIndex];

  AbrevName := RTrim(AbrevName);
  Result := GetFName(AbrevName);
end;

procedure TFrmtypeT4T5_2026.FormPaint(Sender: TObject);
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

Function TFrmtypeT4T5_2026.IsFormSelected(FName:String):Boolean;
Var I:integer;
begin
 Result := False;
 For i:=0 to SelectedForms.Count-1 do
   If FName = SelectedForms[i] then begin Result := True;Exit;End;
end;

procedure TFrmtypeT4T5_2026.SLListDrawItem(Control: TWinControl; Index: Integer;
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
   //20171031 Igor>>>
   if not FList.ByFormName(FName).Allowed then
     Font.Style := Font.Style + [fsStrikeOut]
   else
     Font.Style := Font.Style - [fsStrikeOut];
   //20171031 Igor<<<
   TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index]);
  end;
end;

procedure TFrmtypeT4T5_2026.PAListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SingleMouseClick(Sender);
end;

procedure TFrmtypeT4T5_2026.SLListKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 then DoubleMouseClick(Sender);
  If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypeT4T5_2026.PdfListDblClick(Sender: TObject);
begin
  FName :=SelectForm(Sender);
  If FName = '' then exit;
  //OpenPdfForm(FName);
  Close;
end;


procedure TFrmtypeT4T5_2026.BitBtn1Click(Sender: TObject);
begin
  MainFormT4T5.FilableFormsWeb1Click(Sender);
end;

procedure TFrmtypeT4T5_2026.PrintBtnClick(Sender: TObject);
Var i:Integer;
begin
 If Not AllowedToFormPrint(RetNo,FormName) then exit;
 If MainFormT4T5.PrintDialogItem.Execute then
 begin
    For i:=0 to SelectedForms.Count-1 do
     begin
      FName := SelectedForms[i];
      MainFormT4T5.StartPrintForm(Retno,FName,99);
     end;
   if Printer.Printing then //20160905 Igor
     Printer.EndDoc;        //20160905 Igor
 end;

 SelectedForms.Clear;
 FormPaint(Application);
end;

procedure TFrmtypeT4T5_2026.FormBoxExit(Sender: TObject);
begin
 If FormBox.Text>'' then OpenBtnClick(Sender);
end;

procedure TFrmtypeT4T5_2026.FindIt(ThisForm:String); //20170418 Igor
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



procedure TFrmtypeT4T5_2026.FormBoxKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    OpenBtnClick(Sender);
end;

end.
