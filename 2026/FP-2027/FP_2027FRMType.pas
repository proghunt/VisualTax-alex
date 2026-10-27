unit FP_2027FRMType;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Printers,ExtCtrls;

type
  TFrmtypesFP_2012 = class(TForm)
    PrList: TListBox;
    GlList: TListBox;
    PAList: TListBox;
    ImList: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    PlList: TListBox;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    PeList: TListBox;
    PrintDialog1: TPrintDialog;
    Panel1: TPanel;
    Label11: TLabel;
    OpenBtn: TBitBtn;
    PrintBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label4: TLabel;
    CoList: TListBox;
    Label5: TLabel;
    AdList: TListBox;
    Label8: TLabel;
    Label12: TLabel;
    DaList: TListBox;
    Liabilities: TLabel;
    DlList: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure PrepareForm;
    procedure CancelBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure PRListDblClick(Sender: TObject);
    procedure MJListDblClick(Sender: TObject);
    procedure PAListDblClick(Sender: TObject);
    procedure ImListDblClick(Sender: TObject);
    //procedure TFListDblClick(Sender: TObject);
    procedure MIListDblClick(Sender: TObject);
    //procedure CFListDblClick(Sender: TObject);
    procedure PlListDblClick(Sender: TObject);
    procedure UpdateSelectedForms(FName:string);
    procedure PRListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MJListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PAListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TFListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MIListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PlListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    Function SelectForm(Sender:TObject):String;
    procedure FormPaint(Sender: TObject);
    Procedure OpenIt(FName:String);
    procedure SingleMouseClick(Sender: TObject);
    procedure DoubleMouseClick(Sender: TObject);
    procedure PRListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PAListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ImListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure MIListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PlListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    Function IsFormSelected(FName:String):Boolean;
    procedure PeListDblClick(Sender: TObject);
    procedure PeListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PeListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SwapBtnClick(Sender: TObject);
    procedure PRListKeyPress(Sender: TObject; var Key: Char);
    procedure MJListKeyPress(Sender: TObject; var Key: Char);
    procedure PAListKeyPress(Sender: TObject; var Key: Char);
    procedure ImListKeyPress(Sender: TObject; var Key: Char);
    procedure MIListKeyPress(Sender: TObject; var Key: Char);
    procedure PlListKeyPress(Sender: TObject; var Key: Char);
    procedure PeListKeyPress(Sender: TObject; var Key: Char);
    procedure PrintBtnClick(Sender: TObject);
    procedure GlListDblClick(Sender: TObject);
    procedure GlListKeyPress(Sender: TObject; var Key: Char);
    procedure GlListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CoListDblClick(Sender: TObject);
    procedure CoListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CoListKeyPress(Sender: TObject; var Key: Char);
    procedure CoListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);//20170731 Iggor
  private
    { Private declarations }
  public
    RetNo: integer;
    FName :String;
    AbrevName : String;
    SelectedForms : TStringList;
  end;

var
  Frmtypes: TFrmtypesFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027Declare,FP_2027TrimStr,FP_2027Common,
  FP_2027Common2,FP_2027ChildWinNew,FP_2027Print,FP_2027Main,vtTrimStr,vtShared,
  vtChild; //20170731 Igor

procedure TFrmtypesFP_2012.FormCreate(Sender: TObject);
begin
  //Top:=0;
  RetNo := GetCurrentRetNo;
  PrepareForm;
end;

procedure TFrmtypesFP_2012.FormDestroy(Sender: TObject); //20170731 Iggor
begin
  SelectedForms.Free;
end;

procedure TFrmtypesFP_2012.PrepareForm;
Var I:integer;
begin
 SelectedForms := TstringList.Create;
 PrList.Clear;
 DAList.Clear;
 DLList.Clear;
 GlList.Clear;
 PAList.Clear;
 PlList.Clear;
 ImList.Clear;
 PeList.Clear;
 CoList.Clear;
 AdList.Clear;

 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If Frec.FormShow then
   begin
     if FRec.FormInst > '#1' then continue; //no dupes
      If Frec.FormType      = 'PR' then  PrList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'DA' then  DAList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'DL' then  DLList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'GL' then  GLList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'PA' then  PAList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'PL' then  PLList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'IM' then  IMList.Items.Add(Frec.FormAbrev)
    //  Else If Frec.FormType = 'PE' then  PEList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'CO' then  CoList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'AD' then  AdList.Items.Add(Frec.FormAbrev)
      ;
   end;
 end;
 PRList.ItemIndex :=0;
 AbrevName := PrList.Items[PrList.ItemIndex];
 FName := GetFName(AbrevName);
 {FrmDescr.Caption := GetFormDescr(AbrevName);}

 //SwapBtn.Caption := AllTrim(FetchElm(RetNo,'PAGE_1',2))+', '+AllTrim(LeftStr(FetchElm(RetNo,'PAGE_1',5),10));

end;


procedure TFrmtypesFP_2012.CancelBtnClick(Sender: TObject);
begin
  Close;
  //SelectedForms.Free; //20170731 Igor
end;


procedure TFrmtypesFP_2012.UpdateSelectedForms(FName:string);
//20170731 Igor >>>
Var
  i:Integer;
Begin
  For i:=0 to SelectedForms.Count-1 do
    If FName = SelectedForms[i] then
    begin
      SelectedForms.Delete(i);
      exit;
    end;
  SelectedForms.Add(FName);
  Invalidate;
//20170731 Igor <<<
end;

procedure TFrmtypesFP_2012.OpenBtnClick(Sender: TObject);
//20170731 Igor >>>
Var
  i: integer;
  FName: string; //[15];
begin
  //Close;
  if SelectedForms.Count > 1 then
    vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
  try
    For i:=0 to SelectedForms.Count-1 do
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
//20170731 Igor <<<
end;

procedure TFrmtypesFP_2012.SingleMouseClick(Sender: TObject);
Var FName :string; //[15];
begin
FName :=SelectForm(Sender);
If FName = '' then exit;
UpdateSelectedForms(FName);
(Sender as TListBox).Refresh;    {Excellent:refresh the current listbox}
end;

procedure TFrmtypesFP_2012.DoubleMouseClick(Sender: TObject);
begin
FName :=SelectForm(Sender);
If FName = '' then exit;
//FrmTypes.Close;
OpenIt(FName);
end;

procedure TFrmtypesFP_2012.PRListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.MJListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;


procedure TFrmtypesFP_2012.PAListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.ImListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.MIListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.PlListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.PeListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.PRListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 SingleMouseClick(Sender);
end;

Procedure TFrmtypesFP_2012.OpenIt(FName:String);
Var FNo :Integer;
begin
   FNo := GetFormNo(FName);
(*
   If IsDelphiForm(FNo)='Y' then
   begin
    MainForm.OpenDelphiForm(RetNo,GetFormName(FNo));
    Exit;
   end;
 *)
   FrmTypes.close;
   If FNo =0 then FNo :=GetFormNo(FName+'#1');
   OpenForm(RetNo,FNo,0);
end;

Function TFrmtypesFP_2012.SelectForm(Sender:TObject):String;
Var FNo:integer;
begin

If (Sender as TListBox).ItemIndex <0 then exit;
If      Sender = PrList then AbrevName := PrList.Items[PrList.ItemIndex] //present
else If Sender = GlList then AbrevName := GlList.Items[GlList.ItemIndex] //goals
else If Sender = PAList then AbrevName := PAList.Items[PAList.ItemIndex] //proj and assessment
else If Sender = PlList then AbrevName := PlList.Items[PlList.ItemIndex] //strategy and plans
else If Sender = ImList then AbrevName := ImList.Items[ImList.ItemIndex] //implementation
else If Sender = PeList then AbrevName := PeList.Items[PeList.ItemIndex] //performance review
else If Sender = CoList then AbrevName := CoList.Items[CoList.ItemIndex] //compliance forms
else If Sender = AdList then AbrevName := AdList.Items[AdList.ItemIndex] //admin forms
;

AbrevName := RTrim(AbrevName);
Result := GetFName(AbrevName);
end;

procedure TFrmtypesFP_2012.MJListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;


procedure TFrmtypesFP_2012.PAListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.ImListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.TFListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.MIListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.PlListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.FormPaint(Sender: TObject);
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

Function TFrmtypesFP_2012.IsFormSelected(FName:String):Boolean;
Var I:integer;
begin
 Result := False;
 For i:=0 to SelectedForms.Count-1 do
   If FName = SelectedForms[i] then begin Result := True;Exit;End;
end;

procedure TFrmtypesFP_2012.PRListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var
  Offset: Integer;	{ text offset width }
  FName :String; FNo :integer;
begin
  with (Control as TListBox).Canvas do	{ draw on the control canvas, not on the form }
  begin
   FillRect(Rect);	{ clear the rectangle }
   Offset := 1;	{ provide default offset }
   AbrevName := (Control as TListBox).Items[Index];
   Fname := GetFName(AbrevName);
   If FName ='' then exit;
   FNo := GetFormNo(FName);
   Font.color := clBlack;
   If IsFormSelected(FName) then
     begin Font.color := clWhite; Brush.Color := clRed;end;
   If Ret[RetNo].FrmHasData[FNo] then
     Font.color := clBlue;
   TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index]);
  end;
end;


procedure TFrmtypesFP_2012.PAListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
PrListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesFP_2012.ImListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
PrListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesFP_2012.MIListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
PrListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesFP_2012.PlListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
PrListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesFP_2012.PeListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
PrListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesFP_2012.PeListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.SwapBtnClick(Sender: TObject);
begin
 If RetInMem=1 then
 begin ShowMessage('This is the only file in memory!');exit;end;
 MainFormFP.SwapReturns1Click(Sender);
 UpdateAllDataIndicators(RetNo);
 PrepareForm;
end;


procedure TFrmtypesFP_2012.PRListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.MJListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;


procedure TFrmtypesFP_2012.PAListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.ImListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;


procedure TFrmtypesFP_2012.MIListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.PlListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;


procedure TFrmtypesFP_2012.PeListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.PrintBtnClick(Sender: TObject);
Var i :integer; FName : string; //[15];
begin
 //If Not AllowedToFormPrint(RetNo,FormName) then exit;
 If PrintDialog1.Execute then
 begin
    For i:=0 to SelectedForms.Count-1 do
     begin
      FName := SelectedForms[i];
      MainFormFP.StartPrintForm(Retno,FName,99);
     end;
    if Printer.Printing then //20160905 Igor
      Printer.EndDoc;        //20160905 Igor
 end;

 SelectedForms.Clear;
 Frmtypes.FormPaint(Application);
end;

procedure TFrmtypesFP_2012.GlListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.GlListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.GlListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.CoListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.CoListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
PrListDrawItem(Control,Index,Rect,State);
end;

procedure TFrmtypesFP_2012.CoListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFrmtypesFP_2012.CoListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

end.
