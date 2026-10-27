unit T1_2026FRMType;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Printers,ExtCtrls;

type
  TFrmtypesT1_2026 = class(TForm)
    Label9: TLabel;
    PrintDialog1: TPrintDialog;
    Panel1: TPanel;
    SwapBtn: TBitBtn;
    OpenBtn: TBitBtn;
    PrintBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FindBtn: TBitBtn;
    FindAlphaBtn: TBitBtn;
    PanelFind: TPanel;
    Label15: TLabel;
    Label16: TLabel;
    FormBox: TEdit;
    Panel3: TPanel;
    SEList: TListBox;
    SmList: TListBox;
    MjList: TListBox;
    Panel4: TPanel;
    Panel5: TPanel;
    T1List: TListBox;
    ADList: TListBox;
    CLList: TListBox;
    SLList: TListBox;
    CFList: TListBox;
    REList: TListBox;
    Panel6: TPanel;
    Panel7: TPanel;
    Label6: TLabel;
    MIList: TListBox;
    Label5: TLabel;
    TFList: TListBox;
    Panel2: TPanel;
    Label2: TLabel;
    CRList: TListBox;
    Label1: TLabel;
    Label7: TLabel;
    Label14: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Label13: TLabel;
    Label12: TLabel;
    Label11: TLabel;
    LastYearLabel: TLabel;
    Label17: TLabel;
    SERSLIST: TListBox;
    procedure FindIt(ThisForm:String);
    procedure PrepareForm;
    procedure CancelBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure T1ListDblClick(Sender: TObject);
    procedure MJListDblClick(Sender: TObject);
    procedure SLListDblClick(Sender: TObject);
    procedure SEListDblClick(Sender: TObject);
    procedure SERSListDblClick(Sender: TObject);
    procedure TFListDblClick(Sender: TObject);
    procedure MIListDblClick(Sender: TObject);
    procedure CFListDblClick(Sender: TObject);
    procedure ADListDblClick(Sender: TObject);
    procedure CLListDblClick(Sender: TObject);
    procedure UpdateSelectedForms(FName:string);
    procedure T1ListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MJListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SLListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure SEListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SERSListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure TFListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MIListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ADListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CLListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure CFListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Function SelectForm(Sender:TObject):String;
    procedure FormPaint(Sender: TObject);
    Procedure OpenIt(FName:String);
    procedure SingleMouseClick(Sender: TObject);
    procedure DoubleMouseClick(Sender: TObject);
    procedure T1ListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure MJListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SLListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SEListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);

    procedure SERSListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);

    procedure TFListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CFListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure MIListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ADListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CLListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);

    Function IsFormSelected(FName:String):Boolean;
    procedure REListDblClick(Sender: TObject);
    procedure REListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure REListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SwapBtnClick(Sender: TObject);
    procedure T1ListKeyPress(Sender: TObject; var Key: Char);
    procedure MJListKeyPress(Sender: TObject; var Key: Char);
    procedure SLListKeyPress(Sender: TObject; var Key: Char);
    procedure SEListKeyPress(Sender: TObject; var Key: Char);
    procedure SERSListKeyPress(Sender: TObject; var Key: Char);
    procedure TFListKeyPress(Sender: TObject; var Key: Char);
    procedure MIListKeyPress(Sender: TObject; var Key: Char);
    procedure ADListKeyPress(Sender: TObject; var Key: Char);
    procedure CLListKeyPress(Sender: TObject; var Key: Char);
    procedure CFListKeyPress(Sender: TObject; var Key: Char);
    procedure REListKeyPress(Sender: TObject; var Key: Char);
    procedure PrintBtnClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure FindAlphaBtnClick(Sender: TObject);
    procedure FormBoxExit(Sender: TObject);
    procedure SmListDblClick(Sender: TObject);
    procedure SmListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SmListKeyPress(Sender: TObject; var Key: Char);
    procedure SmListMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    //procedure KeyWBoxKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    RetNo:Integer;
    FormName: string;
    //FName :string; //[12];
    AbrevName : String;
    SelectedForms : TStringList;
  end;

//var  Frmtypes: TFrmtypesT1_2026;

procedure FrmTypes(RNo: integer; FName: string);

implementation

{$R *.DFM}

uses vtMulti,vtCommon,vtDialogs,T1_2026,T1_2026Declare,T1_2026TrimStr,
  T1_2026Common,T1_2026Common2,T1_2026ChildWinNEW,T1_2026Print,T1_2026T1Rtns,
  T1_2026FindALine,T1_2026AbList,T1_2026Main,vtTrimStr,vtShared,
  vtChild; //20170518 Igor

procedure FrmTypes(RNo: integer; FName: string);
begin
  with TFrmtypesT1_2026.Create(Application) do
  begin
    RetNo := RNo;
    FormName := FName;
    ShowModal;
    Free;
  end;
end;

procedure TFrmtypesT1_2026.FormShow(Sender: TObject);
//procedure TFrmtypesT1_2026.FormCreate(Sender: TObject);
begin
  KeyPreview:=True;
  SelectedForms := TstringList.Create;
  //RetNo:=GetCurrentRetNo;

  If (Screen.width <801) then
  begin

   Adlist.height:= Trunc(AdList.Height * 3/4);
   Cllist.height:= Trunc(AdList.Height * 3/4);
   Crlist.height:= Trunc(CrList.Height * 7/8);
   RElist.height:= Trunc(REList.Height * 2/4);
   MJlist.height:= Trunc(MJList.Height * 3/4);
   TFlist.height:= Trunc(TFList.Height * 7/8);
   MIlist.height:= Trunc(MIList.Height * 7/8);
  end;

{
    if Screen.PixelsPerInch > 96 then
    begin
        ScaleBy(Screen.PixelsPerInch, 120);
    end;
}

  PrepareForm;
end;

procedure TFrmtypesT1_2026.FormDestroy(Sender: TObject);
begin
  FreeAndNil(SelectedForms);
end;

procedure TFrmtypesT1_2026.PrepareForm;
Var I:integer;
begin
 RetNo:=GetCurrentRetNo;
 //SelectedForms := TstringList.Create;
 T1List.Clear;
 CrList.Clear;
 MjList.Clear;
 SLList.Clear;
 SEList.Clear;
 SERSList.Clear;
 TFList.Clear;
 SMList.Clear;
 MIList.Clear;
 ADList.Clear;
 CLList.Clear;
 CFList.Clear;
 REList.Clear;

 If Ret[RetNo].IsLastYearReturn = false then //20160314 Igor
 Begin
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If Frec.FormShow then
   begin
    if FRec.FormInst > '#1' then continue; //no dupes
      If Frec.FormType = 'T1' then
       T1List.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'CR' then
       CRList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'MJ' then
       MjList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'SL' then
       SLList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'SE' then
       SEList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'EL' then
       SERSList.Items.Add(Frec.FormAbrev)

      Else If Frec.FormType = 'TF' then
       TFList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'SM' then
       SMList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'MI' then
       MIList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'AD' then
       ADList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'CL' then
       CLList.Items.Add(Frec.FormAbrev)

      Else If Frec.FormType = 'CF' then
       CFList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'RE' then
       REList.Items.Add(Frec.FormAbrev)
       ;
    end;
  end;
 end
 Else  //lastyear retno
 Begin
  for i :=0 to (FLastYearList.Count - 1) do
  begin
   FLastYearRec := FLastYearList.Items[i];
   If FLastYearRec.FormShow then
   begin
      If FLastYearrec.FormType = 'T1' then
       T1List.Items.Add(FLastYearrec.FormAbrev)
      Else If FLastYearrec.FormType = 'CR' then
       CRList.Items.Add(FLastYearrec.FormAbrev)
      Else If FLastYearrec.FormType = 'MJ' then
       MjList.Items.Add(FLastYearrec.FormAbrev)
      Else If FLastYearrec.FormType = 'SL' then
       SLList.Items.Add(FLastYearrec.FormAbrev)
      Else If FLastYearrec.FormType = 'SE' then
       SEList.Items.Add(FLastYearrec.FormAbrev)
      Else If FLastYearrec.FormType = 'EL' then
       SERSList.Items.Add(FLastYearrec.FormAbrev)

      Else If FLastYearrec.FormType = 'TF' then
       TFList.Items.Add(FLastYearrec.FormAbrev)
      Else If FLastYearrec.FormType = 'SM' then
       SMList.Items.Add(FLastYearrec.FormAbrev)
      Else If FLastYearrec.FormType = 'MI' then
       MIList.Items.Add(FLastYearrec.FormAbrev)
      Else If FLastYearrec.FormType = 'AD' then
       ADList.Items.Add(FLastYearrec.FormAbrev)
      Else If FLastYearrec.FormType = 'CL' then
       CLList.Items.Add(FLastYearrec.FormAbrev)
      Else If FLastYearrec.FormType = 'CF' then
       CFList.Items.Add(FLastYearrec.FormAbrev)
      Else If FLastYearrec.FormType = 'RE' then
       REList.Items.Add(FLastYearrec.FormAbrev)
       ;
   end;  //formshow
  end; //i
 end;  //last year

 SwapBtn.Caption := AllTrim(FetchElm(RetNo,'T1',2))+', '+
                    AllTrim(LeftStr(FetchElm(RetNo,'T1',5),10));

end;


procedure TFrmtypesT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
SelectedForms.Clear;  //.Free;
end;


procedure TFrmtypesT1_2026.UpdateSelectedForms(FName:string);
Var i:Integer;
Begin
 For i:=0 to SelectedForms.Count-1 do
  If FName = SelectedForms[i] then begin SelectedForms.Delete(i);exit;end;
 SelectedForms.Add(FName);
 Invalidate;
end;

procedure TFrmtypesT1_2026.OpenBtnClick(Sender: TObject);
//20170518 Igor >>>
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
  if SelectedForms.Count > 1 then
    vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
  try
    For i := 0 to SelectedForms.Count - 1 do
    begin
      FName := SelectedForms[i];
      //20100422
      OpenIt(ExtractNonInstFormName(FName)+GetFirstInstanceWithData(RetNo,FName));
    end;
  finally
    if SelectedForms.Count > 1 then
      vtChild.CreateNewMDIChild(RetNo, '').ShowAllControls;
  end;
  //If SelectedForms.Count>1 then MainForm.WindowTileItemClick(Sender);
  SelectedForms.Clear; //.Free;
end;
//20170518 Igor <<<

procedure TFrmtypesT1_2026.SingleMouseClick(Sender: TObject);
Var FName :string; //[12];
begin
FName :=SelectForm(Sender);
If FName = '' then exit;
UpdateSelectedForms(FName);
(Sender as TListBox).Refresh;    {Excellent:refresh the current listbox}
end;

procedure TFrmtypesT1_2026.DoubleMouseClick(Sender: TObject);
Var FName :string; //[12];
begin
  FName :=SelectForm(Sender);
  If FName = '' then exit;
  Close;
  //20100422
  OpenIt(ExtractNonInstFormName(FName)+GetFirstInstanceWithData(RetNo,FName));
end;

procedure TFrmtypesT1_2026.T1ListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.MJListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;


procedure TFrmtypesT1_2026.SLListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.SEListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.SERSListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.TFListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.MIListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.CFListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.ADListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.CLListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.REListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.T1ListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 SingleMouseClick(Sender);
end;

Procedure TFrmtypesT1_2026.OpenIt(FName:String);
Var i,FNo :Integer;
begin
   FNo := GetFormNo(FName);
   //If Ret[RetNo].IsLastYearRetNo then FNo:=GetLastYearFormNo(FName);
   If FNo =0 then
   Begin
    FNo :=GetFormNo(FName+'#1');
    If Ret[RetNo].IsLastYearReturn then Begin FName:=FName+'#1';GetLastYearFormNo(FName);end;  //20160314 Igor
   end;
   If FName='ALETTER' then
   begin
    if (LicenseLevel in [llDemo,llPower..llMultiPower])
     or (isEnterpriseVersion) //20250119
    then
      //ok
     else
     begin
      ShowMessage('Available only in the Power/Enterprise versions of the program');
      Exit;
     end;
     SomeList.Clear;  // := TStringList.Create;
     SomeList.Sorted := True;
     GetFileList(Appdir, '*.RTF',SomeList);

     SelectedString := PopSomeList(SomeList,SomeCaption);
     //SomeList.Free; //20160301 Igor
     SelectedString:=ExtractFileName(SelectedString);
     If SelectedString > '' then SomeLetterName:=SelectedString;
   end;
   FormNameNo(RetNo,FName); //20110221
   OpenForm(RetNo,FNo,0);

end;

Function TFrmtypesT1_2026.SelectForm(Sender:TObject):String;
Var FNo:integer;
begin
{does not work
If (Sender as TListBox).Tlist.ItemIndex >
  (Sender as TListBox).Items.Count then begin FName:='';exit;end;
}

If (Sender as TListBox).ItemIndex <0 then exit;
If      Sender = T1List then AbrevName := T1List.Items[T1List.ItemIndex]
else If Sender = CRList then AbrevName := CRList.Items[CRList.ItemIndex]
else If Sender = MJList then AbrevName := MJList.Items[MJList.ItemIndex]
else If Sender = SLList then AbrevName := SLList.Items[SLList.ItemIndex]
else If Sender = SEList then AbrevName := SEList.Items[SEList.ItemIndex]
else If Sender = SERSList then AbrevName := SERSList.Items[SERSList.ItemIndex]
else If Sender = TFList then AbrevName := TFList.Items[TFList.ItemIndex]
else If Sender = SMList then AbrevName := SMList.Items[SMList.ItemIndex]
else If Sender = MIList then AbrevName := MIList.Items[MIList.ItemIndex]
else If Sender = ADList then AbrevName := ADList.Items[ADList.ItemIndex]
else If Sender = CLList then AbrevName := CLList.Items[CLList.ItemIndex]
else If Sender = CFList then AbrevName := CFList.Items[CFList.ItemIndex]
else If Sender = REList then AbrevName := REList.Items[REList.ItemIndex]
;

AbrevName := RTrim(AbrevName);
Result := GetFName(AbrevName);
If Ret[RetNo].IsLastYearReturn then Result := GetLastYearFName(AbrevName);
end;

procedure TFrmtypesT1_2026.MJListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;


procedure TFrmtypesT1_2026.SLListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.SEListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.SERSListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;


procedure TFrmtypesT1_2026.TFListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.MIListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.ADListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.CLListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;


procedure TFrmtypesT1_2026.CFListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.FormPaint(Sender: TObject);
begin
 If Ret[RetNo].IsLastYearReturn = True then //20110227
 begin
     LastYearLabel.Visible := True;
     FormBox.Enabled := False;
  end
  else  //this year
  begin
    LastYearLabel.Visible := False;
    FormBox.Enabled := True;
  end;

If SelectedForms.Count >0 then
  begin
 // OpenBtn.Enabled := True;
  PrintBtn.Enabled := True;
  end
else
  begin
 // OpenBtn.Enabled := False;
  PrintBtn.Enabled := False;
  end;

end;

Function TFrmtypesT1_2026.IsFormSelected(FName:String):Boolean;
Var I:integer;
begin
 Result := False;
 For i:=0 to SelectedForms.Count-1 do
   If FName = SelectedForms[i] then begin Result := True;Exit;End;
end;

procedure TFrmtypesT1_2026.T1ListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var
  i,j,Offset: Integer;	{ text offset width }
  FName :String; FNo :integer;
  RetNo:Integer;
begin
  with (Control as TListBox).Canvas do	{ draw on the control canvas, not on the form }
  begin
   FillRect(Rect);	{ clear the rectangle }
   Offset := 1;	{ provide default offset }

   //20110220
   RetNo:=GetCurrentRetNo;
   AbrevName := (Control as TListBox).Items[Index];
   Fname := GetFName(AbrevName);
   If Ret[RetNo].IsLastYearReturn then Fname := GetLastYearFName(AbrevName);
   If FName ='' then exit;
 //  AbrevName := (Control as TListBox).Items[Index];
 //  Fname := GetFName(AbrevName);
 //  If Ret[RetNo].IsLastYearRetNo then Fname := GetLastYearFName(AbrevName);

 //  If FName ='' then exit;
   FNo := GetFormNo(FName);
   If Ret[RetNo].IsLastYearReturn then FNo:=GetLastYearFormNo(FName);
   Font.color := clBlack;
   If IsFormSelected(FName) then begin Font.color := clWhite; Brush.Color := clRed;end;
   If FNo=0 then Exit;  //20101219

   //20110109
   If (Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)]) and (ShouldHighlight(RetNo,FName,FNo)) then Font.color := clBlue;


   //check more //20100422
   //i.e. T2125 only the second statement has data then highlight it
   If (ExtractFormInst(FName)>'') and (Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)])=False then
   begin
    For j:=2 to 8 do
    Begin
     FNo:=GetFormNo(ExtractNonInstFormName(FName)+'#'+AllTrim(IntToStr(j)));  //20101219
     If Ret[RetNo].IsLastYearReturn then FNo:=GetLastYearFormNo(ExtractNonInstFormName(FName)+'#'+AllTrim(IntToStr(j)));  //20101219
     If FNo>0 then  //20101219
     Begin
      If Ret[RetNo].FormHasData[GetFormName(RetNo,Fno)] then Font.color := clBlue;
     end;
    end;
   end;

   If Ret[RetNo].IsLastYearReturn then Font.color := clBlack;

   TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index]);
  end;
end;

procedure TFrmtypesT1_2026.MJListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;


procedure TFrmtypesT1_2026.SLListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT1_2026.SEListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT1_2026.SERSListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;


procedure TFrmtypesT1_2026.TFListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT1_2026.CFListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT1_2026.MIListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT1_2026.ADListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT1_2026.CLListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT1_2026.REListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT1_2026.REListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.SwapBtnClick(Sender: TObject);
begin
 If RetInMem=1 then
 begin ShowMessage('This is the only return in memory!');exit;end;
 MainFormT1.SwapReturns1Click(Sender);
 UpdateAllDataIndicators(RetNo);
 PrepareForm;
 //SendMessage(MDIHandle,WM_PAINT,0,0);
end;


procedure TFrmtypesT1_2026.T1ListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.MJListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;


procedure TFrmtypesT1_2026.SLListKeyPress(Sender: TObject; var Key: Char);
begin

If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.SEListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.SERSListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;


procedure TFrmtypesT1_2026.TFListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.MIListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.ADListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.CLListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.CFListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.REListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.PrintBtnClick(Sender: TObject);
Var i :integer; FName : string;FInst:String;
begin
 If Not AllowedToFormPrint(RetNo,FormName) then exit;
 If PrintDialog1.Execute then
 begin
    For i:=0 to SelectedForms.Count-1 do
     begin
      FName := SelectedForms[i];
      //20100422
      If IsFormMultiInst(FName) then
      begin
       FInst:=GetFirstInstanceWithData(RetNo,FName);
       If FInst>'' then FName:=ExtractNonInstFormName(FName)+FInst
      end;
      MainFormT1.StartPrintForm(Retno,FName,99);
      if Printer.Printing then //20160905 Igor
        Printer.EndDoc; //20160905 Igor

     end;
 end;

 SelectedForms.Clear;
 FormPaint(Application);
end;

procedure TFrmtypesT1_2026.FindBtnClick(Sender: TObject);
begin
   Application.CreateForm(TFindALineT1_2026,FindALine);
   FindALine.ShowModal;
   FindALine.Free;
   Close;
end;

procedure TFrmtypesT1_2026.FindAlphaBtnClick(Sender: TObject);
begin
   Application.CreateForm(TABListT1_2026,ABList);
   ABList.ShowModal;
   ABList.Free;
   Close;
end;

procedure TFrmtypesT1_2026.FormBoxExit(Sender: TObject);
begin
If FormBox.Text>'' then OpenBtnClick(Sender);
end;

procedure TFrmtypesT1_2026.FindIt(ThisForm:String);
Var i,Elm,FNo,TheLength:Integer;FName:String;
//ResultsList:TStringList;
    List1:TStringList;
begin
 ThisForm:=UpperCase(ThisForm);

 If ThisForm='T1' then ThisForm:='T1';
 If ThisForm='T3' then ThisForm:='T3MULT';
 If ThisForm='T5' then ThisForm:='T5MULT';

 TheLength:=Length(ThisForm);

 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If ThisForm=AllTrim(ExtractFormRootName(Frec.FormName)) then
   begin
    FNo := FRec.FormNo; // GetFormNo(Frec.FormInstName);
    If FNo>0 then
    begin
     OpenForm(RetNo,FNo,0);
     Close;
     exit;
   end;
  end;
 end;
 //not found as formname
  //load the firms
     List1:=TStringList.Create;
     List1.Clear;
     List1.Sorted := True;
     for i :=0 to (FList.Count - 1) do
     begin
      FRec := FList.Items[i];
      If Frec.FormShow then
       List1.Add(PaddR(Frec.FormRlNm,10)
                       +PaddR(Frec.FormDescr,70)
                       +Frec.FormInstName);
     end; //i
  SomeCaption := 'Form or KeyWord found in following';
  SelectedString := PopMatchingList(ThisForm,List1,SomeCaption,True);
  List1.Free;
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
end;

procedure TFrmtypesT1_2026.SmListDblClick(Sender: TObject);
begin
 DoubleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.SmListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesT1_2026.SmListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.SmListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesT1_2026.FormActivate(Sender: TObject);
begin
  FormBox.SetFocus;
end;

end.
