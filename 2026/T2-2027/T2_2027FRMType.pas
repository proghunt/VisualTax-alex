unit T2_2027frmtype;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Printers;

type
  TFrmtypesT2_2027 = class(TForm)
    T2List: TListBox;
    ScList: TListBox;
    OOList: TListBox;
    AlList: TListBox;
    TFList: TListBox;
    MIList: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    OpenBtn: TBitBtn;
    CancelBtn: TBitBtn;
    PrintBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    RDList: TListBox;
    OtherBtn: TBitBtn;
    Label7: TLabel;
    Label8: TLabel;
    ClList: TListBox;
    Label10: TLabel;
    Label11: TLabel;
    FormBox: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    SERSList: TListBox;
    Label9: TLabel;
    Label14: TLabel;

    procedure FindIt(ThisForm:String);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure T2ListDblClick(Sender: TObject);
    procedure ScListDblClick(Sender: TObject);
    procedure OOListDblClick(Sender: TObject);
    procedure AlListDblClick(Sender: TObject);
    procedure TFListDblClick(Sender: TObject);
    procedure MIListDblClick(Sender: TObject);
    procedure RSListDblClick(Sender: TObject);
    procedure LCListDblClick(Sender: TObject);
    procedure SersListDblClick(Sender: TObject);

    procedure UpdateSelectedForms(FName:string);
    procedure T2ListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ScListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OOListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure AlListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TFListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MIListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LCListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RSListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Function SelectForm(Sender:TObject):String;
    procedure FormPaint(Sender: TObject);
    Procedure OpenIt(FName:String);
    procedure SingleMouseClick(Sender: TObject);
    procedure DoubleMouseClick(Sender: TObject);
    procedure T2ListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ScListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure OOListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure AlListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TFListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure RSListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure MIListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure LCListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    Function IsFormSelected(FName:String):Boolean;
    procedure RDListDblClick(Sender: TObject);
    procedure RDListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure RDListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

   // procedure SersListDblClick(Sender: TObject);
    procedure SersListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SersListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);


    procedure T2ListKeyPress(Sender: TObject; var Key: Char);
    procedure ScListKeyPress(Sender: TObject; var Key: Char);
    procedure OOListKeyPress(Sender: TObject; var Key: Char);
    procedure AlListKeyPress(Sender: TObject; var Key: Char);
    procedure TFListKeyPress(Sender: TObject; var Key: Char);
    procedure MIListKeyPress(Sender: TObject; var Key: Char);
    procedure LCListKeyPress(Sender: TObject; var Key: Char);
    procedure RSListKeyPress(Sender: TObject; var Key: Char);
    procedure RDListKeyPress(Sender: TObject; var Key: Char);
    procedure SersListKeyPress(Sender: TObject; var Key: Char);
    procedure PrintBtnClick(Sender: TObject);
    {procedure UpdateIndBtnClick(Sender: TObject);}
    procedure RefreshList;
    procedure ClearLists;
    procedure QCListDblClick(Sender: TObject);
    procedure QCListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure QCListKeyPress(Sender: TObject; var Key: Char);
    procedure QCListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DoPdfFile(RetNo: integer; FName:String;PdfFile:String);
    //procedure CBListener1ClipboardChanged;
    procedure OtherBtnClick(Sender: TObject);
    procedure ClListDblClick(Sender: TObject);
    procedure ClListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ClListKeyPress(Sender: TObject; var Key: Char);
    procedure FormBoxExit(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    //procedure FormBoxKeyPress(Sender: TObject; var Key: Char); //(Sender: TObject);
  private
    FRetNo: integer;
    FName :string; //[10];
    AbrevName : string; //[20];
    SelectedForms : TStringList;
  public
    property RetNo: integer read FRetNo;
  end;



procedure FrmTypes(RNo: integer; FmName: string);

implementation

{$R *.DFM}

uses
  vtMulti,vtMain,vtCommon,vtDialogs,
  T2_2027,T2_2027Declare,T2_2027TrimStr,
  T2_2027Common,T2_2027Common2,T2_2027ChildWinNew,ExtCtrls,T2_2027Print,
  T2_2027Calc,ClipBrd,
//T2_2027SelectDir,
  T2_2027Main,
  vtTrimStr,vtShared,
  vtChild; //20170628 Igor

procedure FrmTypes(RNo: integer; FmName: string);
begin
  with TFrmtypesT2_2027.Create(Application) do
  begin
    FRetNo := RNo;
    FName := FName;
    ShowModal;
    Free;
  end;
end;

procedure TFrmtypesT2_2027.FormCreate(Sender: TObject);
begin
  FRetNo := GetCurrentRetNo;
 KeyPreview:=True;
 SelectedForms := TstringList.Create;
 RefreshList;
end;

procedure TFrmtypesT2_2027.RefreshList;
Var I:integer;
begin
 OOList.items.clear;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   if FRec.FormInst > '#1' then continue; //20170729 Igor
   If Frec.FormShow then
   begin
      If Frec.FormType = 'T2' then
       T2List.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'SC' then
       ScList.Items.Add(Frec.FormAbrev)

      else if (Frec.FormType = 'ON') then
      begin
       If GetTaxationYearEnd(RetNo)>'2008/12/31' then
         OOList.Items.Add(Frec.FormAbrev)
      end

      Else If Frec.FormType = 'AL' then
       AlList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'MI' then
       MIList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'CL' then
       CLList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'RD' then
       RDList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'EL' then
       SersList.Items.Add(Frec.FormAbrev)
      Else
      begin
       If (Frec.FormType = 'TF') then TFList.Items.Add(Frec.FormAbrev);  //all TF and New ON
      end;
   end;
 end;
end;


procedure TFrmtypesT2_2027.CancelBtnClick(Sender: TObject);
begin
Close;
//SelectedForms.Free;
end;


procedure TFrmtypesT2_2027.UpdateSelectedForms(FName:string);
Var i:Integer;
Begin
 For i:=0 to SelectedForms.Count-1 do
  If FName = SelectedForms[i] then begin SelectedForms.Delete(i);exit;end;
 SelectedForms.Add(FName);
 Invalidate;
end;

procedure TFrmtypesT2_2027.OpenBtnClick(Sender: TObject);
//20170628 Igor >>>
Var
  i: integer;
  FName{, PdfFile}: String;
begin
  If FormBox.Text > '' then
  begin
    FindIt(FormBox.text);
    exit;
  end;
  Try
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
  except
    on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;
//20170628 Igor <<<
end;

procedure TFrmtypesT2_2027.DoPdfFile(RetNo: integer; FName:String;PdfFile:String);
var FNo,NumFlds:Integer;
begin
  FNo:=GetFormNo(FName);
  NumFlds:=GetNumbFields(FName);
  If FNo=0 then
   begin
    ShowPdf(PdfFormsDir,PdfFile);
    Exit;
   end;
  ProcessPdfFile(RetNo, FName,FNo,NumFlds,PdfFile);
end;

procedure TFrmtypesT2_2027.SingleMouseClick(Sender: TObject);
Var FName :string; //[10];
begin
FName :=SelectForm(Sender);
UpdateSelectedForms(FName);
(Sender as TListBox).Refresh;    {Excellent:refresh the current listbox}
end;

{double clicks}
procedure TFrmtypesT2_2027.DoubleMouseClick(Sender: TObject);
begin
FName :=SelectForm(Sender);
Close;
OpenIt(FName);
end;

procedure TFrmtypesT2_2027.T2ListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.ScListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;


procedure TFrmtypesT2_2027.OOListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.AlListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.TFListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.MIListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.RSListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.LCListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.RDListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.SersListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;




procedure TFrmtypesT2_2027.T2ListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 SingleMouseClick(Sender);
end;

Procedure TFrmtypesT2_2027.OpenIt(FName:String);
Var FNo :Integer;
  SomeList: TStringList;
begin
   If FName='ALETTER' then
   begin
    if LicenseLevel in [llDemo,llPower..llMultiPower]
     then
      //ok
     else
     begin
      ShowMessage('Available only in the Power version of the program');
      Exit;
     end;
     //SomeList := TStringList.Create;
     SomeList:=GetFileList(Appdir, '*.RTF');
     SomeList.Sorted := True;
     SelectedString := PopSomeList(SomeList);
     SomeList.Free;
     SelectedString:=ExtractFileName(SelectedString);
     If SelectedString > '' then SomeLetterName:=SelectedString;
   end;

  FNo := GetFormNo(FName);
  If FNo =0 then FNo :=GetFormNo(FName+'#1');
  If FName = 'OPGS_1' then
  begin
   ShowMessage('You can not enter data on the Short form.'+
   Chr(13)+'Useful only for printing purposes');
  end;
  OpenForm(RetNo,FNo,0);
end;

Function TFrmtypesT2_2027.SelectForm(Sender:TObject):String;
{Var FNo:integer;}
begin
If      Sender = T2List then AbrevName := T2List.Items[T2List.ItemIndex]
else If Sender = ScList then AbrevName := ScList.Items[ScList.ItemIndex]
else If Sender = OOList then AbrevName := OOList.Items[OOList.ItemIndex]
else If Sender = AlList then AbrevName := AlList.Items[AlList.ItemIndex]
else If Sender = TFList then AbrevName := TFList.Items[TFList.ItemIndex]
else If Sender = MIList then AbrevName := MIList.Items[MIList.ItemIndex]
else If Sender = RdList then AbrevName := RdList.Items[RdList.ItemIndex]
else If Sender = SERSList then AbrevName := SersList.Items[SersList.ItemIndex];


AbrevName := RTrim(AbrevName);
Result := GetFName(AbrevName);
end;

procedure TFrmtypesT2_2027.ScListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.OOListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.AlListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.TFListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.MIListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.LCListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.RSListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.FormPaint(Sender: TObject);
begin
{
If SelectedForms.Count >0 then
  OpenBtn.Enabled := True
else
  OpenBtn.Enabled := False;
 }
end;

Function TFrmtypesT2_2027.IsFormSelected(FName:String):Boolean;
Var I:integer;
begin
 Result := False;
 For i:=0 to SelectedForms.Count-1 do
   If FName = SelectedForms[i] then begin Result := True;Exit;End;
end;

procedure TFrmtypesT2_2027.T2ListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var
  Offset: Integer;	{ text offset width }
  FName :String; FNo :integer;
begin
  with (Control as TListBox).Canvas do	{ draw on the control canvas, not on the form }
  begin
   FillRect(Rect);	{ clear the rectangle }
   Offset := 2;	{ provide default offset }
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

procedure TFrmtypesT2_2027.ScListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T2ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT2_2027.OOListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T2ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT2_2027.AlListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T2ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT2_2027.TFListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T2ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT2_2027.RSListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T2ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT2_2027.MIListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T2ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT2_2027.LCListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T2ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT2_2027.RDListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T2ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT2_2027.SersListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T2ListDrawItem(Control,Index,Rect,State);
end;


procedure TFrmtypesT2_2027.RDListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.SersListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 SingleMouseClick(Sender);
end;


procedure TFrmtypesT2_2027.T2ListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.ScListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.OOListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.AlListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.TFListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.MIListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.LCListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.RSListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.RDListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.SERSListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;



procedure TFrmtypesT2_2027.PrintBtnClick(Sender: TObject);
Var i :integer; FName : string; //[10];
begin
 If LicenseLevel = llDemo then
  begin
  ShowMessage('Printing not included in the demo version');
  exit;
  end;
 For i:=0 to SelectedForms.Count-1 do
 begin
  FName := SelectedForms[i];
  If PrintDialog1.Execute then
  begin
     MainFormT2.StartPrintForm(Retno,FName,99);
     if Printer.Printing then //20160905 Igor
       Printer.EndDoc;        //20160905 Igor
  end;
 end;
end;

(*
procedure TFrmtypes.UpdateIndBtnClick(Sender: TObject);
begin
 Screen.Cursor := CrHourGlass;
 If Ret[RetNo].FedCalcStatus = False then CalcFed(RetNo);
 If Ret[RetNo].OntCalcStatus = False then CalcOnt(RetNo);
 If Ret[RetNo].AlbCalcStatus = False then CalcAlb(RetNo);
 UpdateAllDataIndicators(RetNo);
 ClearLists;
 RefreshList;
 Screen.Cursor := CrDefault;
end;
*)
procedure TFrmtypesT2_2027.ClearLists;
begin
 T2List.Clear;
 MiList.Clear;
 ScList.Clear;
 TfList.Clear;
 OOList.Clear;
 AlList.Clear;
end;
procedure TFrmtypesT2_2027.QCListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.QCListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T2ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT2_2027.QCListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.QCListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

(*
procedure TFrmtypes.CBListener1ClipboardChanged; //(Sender: TObject);
Var i,FNo:Integer;
    AMemo:TMemo;
    ClipboardText:AnsiString;
    WList:TStringList;
    TempList:TStringList;
    h : THandle;
    ActionVerb:String;
    ActionParm:String;
    CurrentPdfFile:String;
    NumFlds:Integer;
    FldCountS:String;
    FName:String;
    PdfFile:String;
    FullfdfFile:String;
begin
   DoClipBoardChanged;
   exit;
end;
*)

procedure TFrmtypesT2_2027.OtherBtnClick(Sender: TObject);
begin
 (*
  Application.CreateForm(TPdfForms,PdfForms);
  PdfForms.ShowModal;
  PdfForms.Free;
  *)
 //MainForm.QuebecTaxReturn1Click(Sender);

 Close;
 (*
 PdfForms.Free;
 Application.CreateForm(TPdfForms,PdfForms);
 PdfForms.ShowModal;
 FrmTypes.Close;
 //PdfForms.Free;
 *)
end;

procedure TFrmtypesT2_2027.ClListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.ClListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T2ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT2_2027.ClListKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 then DoubleMouseClick(Sender);
 If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT2_2027.FindIt(ThisForm:String);
Var i,Elm,FNo,TheLength:Integer;FName:String;
  //ResultsList:TStringList;
    List1:TStringList;
begin
 ThisForm:=UpperCase(ThisForm);
 ThisForm := AutocompleteFormName(ThisForm); //20160711 Igor
// If ThisForm='S1' then ThisForm:='S01';
// If ThisForm='S2' then ThisForm:='S02';
// If ThisForm='S3' then ThisForm:='S03';
// If ThisForm='S4' then ThisForm:='S04';
// If ThisForm='S5' then ThisForm:='S05';
// If ThisForm='S6' then ThisForm:='S06';
// If ThisForm='S7' then ThisForm:='S07';
// If ThisForm='S8' then ThisForm:='S08';
// If ThisForm='S9' then ThisForm:='S09';
 TheLength:=Length(ThisForm);

  //load the firms
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If ThisForm=AllTrim(ExtractFormRootName(Frec.FormName)) then
   begin
    FNo := FRec.FormNo; // GetFormNo(Frec.FormName);
    If FNo>0 then
    begin
     OpenForm(RetNo,FNo,0);
     Close;
     exit;
   end;
  end;
 end;
     List1:=TStringList.Create;
     List1.Clear;
     List1.Sorted := True;
     for i :=0 to (FList.Count - 1) do
     begin
      FRec := FList.Items[i];
      If Frec.FormShow then
       List1.AddObject(PaddR(Frec.FormRlNm,10)
                       +PaddR(Frec.FormAbrev,70)
                       +Frec.FormInstName,FRec);
     end; //i
   //not found as formname
   SomeCaption := 'Form or KeyWord found in following';

    SelectedString := PopMatchingList(ThisForm,List1,SomeCaption);
    List1.Free;

    If SelectedString > '' then
    begin
      TObject(FRec) := PopListObject;
      FNo := FRec.FormNo;

     If FNo>0 then
     begin
      OpenForm(RetNo,FNo,0);
      Close;
     end;
    end;
    //ResultsList.Free;
end;

procedure TFrmtypesT2_2027.FormBoxExit(Sender: TObject);
begin
 If FormBox.Text>'' then OpenBtnClick(Sender);
end;

procedure TFrmtypesT2_2027.FormDestroy(Sender: TObject);
begin
  SelectedForms.Free;
end;

end.
