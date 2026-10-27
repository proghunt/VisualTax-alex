unit FP_2027FormsExplorer;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Printers,ExtCtrls,ComCtrls;

type
  TFormsExplorerFP_2012 = class(TForm)
    Panel1: TPanel;
    PrintDialog1: TPrintDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    T1List: TListBox;
    CRList: TListBox;
    SLList: TListBox;
    SEList: TListBox;
    TFList: TListBox;
    MIList: TListBox;
    ADList: TListBox;
    CFList: TListBox;
    REList: TListBox;
    Label11: TLabel;
    FindBox: TEdit;
    FoundList: TListBox;
    FindResultLbl: TLabel;
    Panel2: TPanel;
    FrmDescr: TLabel;
    OpenBtn: TBitBtn;
    CancelBtn: TBitBtn;
    PrintBtn: TBitBtn;
    SwapBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure PrepareForm;
    procedure CancelBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure T1ListDblClick(Sender: TObject);
    procedure CRListDblClick(Sender: TObject);
    procedure SLListDblClick(Sender: TObject);
    procedure SEListDblClick(Sender: TObject);
    procedure TFListDblClick(Sender: TObject);
    procedure MIListDblClick(Sender: TObject);
    procedure CFListDblClick(Sender: TObject);
    procedure ADListDblClick(Sender: TObject);
    procedure UpdateSelectedForms(FName:string);
    procedure T1ListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CRListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SLListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SEListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TFListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MIListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ADListMouseDown(Sender: TObject; Button: TMouseButton;
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
    procedure CRListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SLListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure SEListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TFListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CFListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure MIListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ADListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    Function IsFormSelected(FName:String):Boolean;
    procedure REListDblClick(Sender: TObject);
    procedure REListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure REListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SwapBtnClick(Sender: TObject);
    procedure T1ListKeyPress(Sender: TObject; var Key: Char);
    procedure CRListKeyPress(Sender: TObject; var Key: Char);
    procedure SLListKeyPress(Sender: TObject; var Key: Char);
    procedure SEListKeyPress(Sender: TObject; var Key: Char);
    procedure TFListKeyPress(Sender: TObject; var Key: Char);
    procedure MIListKeyPress(Sender: TObject; var Key: Char);
    procedure ADListKeyPress(Sender: TObject; var Key: Char);
    procedure CFListKeyPress(Sender: TObject; var Key: Char);
    procedure REListKeyPress(Sender: TObject; var Key: Char);
    procedure PrintBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure FindBoxChange(Sender: TObject);
  private
    { Private declarations }
  public
    RetNo:Integer;
    FName :string; //[10];
    AbrevName : string; //[18];
    SelectedForms : TStringList;
  end;

var
  FormsExplorer: TFormsExplorerFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027Declare,FP_2027TrimStr,FP_2027Common,
  FP_2027Common2,FP_2027ChildWinNEW,FP_2027Print,FP_2027Main,vtTrimStr,vtShared;

procedure TFormsExplorerFP_2012.FormCreate(Sender: TObject);
begin
 RetNo:=GetCurrentRetNo;
 PageControl1.ActivePage := Tabsheet1;
 FindResultLbl.Caption:='';
 PrepareForm;
end;

procedure TFormsExplorerFP_2012.PrepareForm;
Var I:integer;
begin
 SelectedForms := TstringList.Create;
 T1List.Clear; CrList.Clear; SLList.Clear;
 SEList.Clear; TFList.Clear; MIList.Clear;
 ADList.Clear; CFList.Clear; REList.Clear;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   if FRec.FormInst > '#1' then continue; //no dupes
   If Frec.FormShow then
   begin
      If Frec.FormType = 'T1' then
       T1List.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'CR' then
       CRList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'SL' then
       SLList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'SE' then
       SEList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'TF' then
       TFList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'MI' then
       MIList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'AD' then
       ADList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'CF' then
       CFList.Items.Add(Frec.FormAbrev)
      Else If Frec.FormType = 'RE' then
       REList.Items.Add(Frec.FormAbrev)
       ;
   end;
 end;
 T1List.ItemIndex :=12;
 AbrevName := T1List.Items[T1List.ItemIndex];
 FName := GetFName(AbrevName);
 {FrmDescr.Caption := GetFormDescr(AbrevName);}
 SwapBtn.Caption := AllTrim(FetchElm(RetNo,'PAGE_1',2))+', '+
                    AllTrim(LeftStr(FetchElm(RetNo,'PAGE_1',5),10));

end;


procedure TFormsExplorerFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
SelectedForms.Free;
end;


procedure TFormsExplorerFP_2012.UpdateSelectedForms(FName:string);
Var i:Integer;
Begin
 For i:=0 to SelectedForms.Count-1 do
  If FName = SelectedForms[i] then begin SelectedForms.Delete(i);exit;end;
 SelectedForms.Add(FName);
 Invalidate;
end;

procedure TFormsExplorerFP_2012.OpenBtnClick(Sender: TObject);
Var i :integer; FName : string; //[10];
begin
Close;
For i:=0 to SelectedForms.Count-1 do
 begin
  FName := SelectedForms[i];
  OpenIt(FName);
 end;
 //If SelectedForms.Count>1 then MainForm.WindowTileItemClick(Sender);
 SelectedForms.Free;
end;

procedure TFormsExplorerFP_2012.SingleMouseClick(Sender: TObject);
Var FName :string; //[10];
begin
FName :=SelectForm(Sender);
If FName = '' then exit;
UpdateSelectedForms(FName);
(Sender as TListBox).Refresh;    {Excellent:refresh the current listbox}
end;

{double clicks}
procedure TFormsExplorerFP_2012.DoubleMouseClick(Sender: TObject);
begin
FName :=SelectForm(Sender);
If FName = '' then exit;
FormsExplorer.Close;
{FrmTypes.Close;}
OpenIt(FName);
end;

procedure TFormsExplorerFP_2012.T1ListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.CRListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.SLListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.SEListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.TFListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.MIListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.CFListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.ADListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.REListDblClick(Sender: TObject);
begin
DoubleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.T1ListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 SingleMouseClick(Sender);
end;

Procedure TFormsExplorerFP_2012.OpenIt(FName:String);
Var FNo :Integer;
begin
   FNo := GetFormNo(FName);
   If FNo =0 then FNo :=GetFormNo(FName+'#1');
   OpenForm(RetNo,FNo,0);
end;

Function TFormsExplorerFP_2012.SelectForm(Sender:TObject):String;
Var FNo:integer;
begin
{does not work
If (Sender as TListBox).ItemIndex >
  (Sender as TListBox).Items.Count then begin FName:='';exit;end;
}
If      Sender = T1List then AbrevName := T1List.Items[T1List.ItemIndex]
else If Sender = CRList then AbrevName := CRList.Items[CRList.ItemIndex]
else If Sender = SLList then AbrevName := SLList.Items[SLList.ItemIndex]
else If Sender = SEList then AbrevName := SEList.Items[SEList.ItemIndex]
else If Sender = TFList then AbrevName := TFList.Items[TFList.ItemIndex]
else If Sender = MIList then AbrevName := MIList.Items[MIList.ItemIndex]
else If Sender = ADList then AbrevName := ADList.Items[ADList.ItemIndex]
else If Sender = CFList then AbrevName := CFList.Items[CFList.ItemIndex]
else If Sender = REList then AbrevName := REList.Items[REList.ItemIndex]
;

AbrevName := RTrim(AbrevName);
Result := GetFName(AbrevName);
end;

procedure TFormsExplorerFP_2012.CRListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.SLListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.SEListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.TFListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.MIListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.ADListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.CFListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.FormPaint(Sender: TObject);
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

Function TFormsExplorerFP_2012.IsFormSelected(FName:String):Boolean;
Var I:integer;
begin
 Result := False;
 For i:=0 to SelectedForms.Count-1 do
   If FName = SelectedForms[i] then begin Result := True;Exit;End;
end;

procedure TFormsExplorerFP_2012.T1ListDrawItem(Control: TWinControl; Index: Integer;
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

procedure TFormsExplorerFP_2012.CRListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFormsExplorerFP_2012.SLListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFormsExplorerFP_2012.SEListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFormsExplorerFP_2012.TFListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFormsExplorerFP_2012.CFListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFormsExplorerFP_2012.MIListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFormsExplorerFP_2012.ADListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFormsExplorerFP_2012.REListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
T1ListDrawItem(Control,Index,Rect,State);
end;

procedure TFormsExplorerFP_2012.REListMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.SwapBtnClick(Sender: TObject);
begin
 If RetInMem=1 then
 begin ShowMessage('This is the only file in memory!');exit;end;
 MainFormFP.SwapReturns1Click(Sender);
 UpdateAllDataIndicators(RetNo);
 PrepareForm;
end;


procedure TFormsExplorerFP_2012.T1ListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.CRListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.SLListKeyPress(Sender: TObject; var Key: Char);
begin

If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.SEListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.TFListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.MIListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.ADListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.CFListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.REListKeyPress(Sender: TObject; var Key: Char);
begin
If Key = #13 then DoubleMouseClick(Sender);
If Key = #32 then SingleMouseClick(Sender);
end;

procedure TFormsExplorerFP_2012.PrintBtnClick(Sender: TObject);
Var i :integer; FName : string; //[10];
begin
 If Not AllowedToFormPrint(RetNo) then exit;
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
 FormsExplorer.FormPaint(Application);
 {Frmtypes.FormPaint(Application);}
end;

procedure TFormsExplorerFP_2012.PageControl1Change(Sender: TObject);
begin
 If PageControl1.ActivePage = Tabsheet2 then
  FindBox.Text:='';
end;

procedure TFormsExplorerFP_2012.FindBoxChange(Sender: TObject);
Var i:Integer;KeyWordList:TStringList;
begin
  If AllTrim(FindBox.Text)='' then exit;
  FindResultLbl.Caption :='';
  KeyWordList:=TStringList.Create;
  KeyWordList.LoadFromFile(AppDir+'\'+'AlphaNdx.d');
  FoundList.Items.Clear;
  For i:=0 to KeyWordList.Count-1 do
  begin
   If FindWord(FindBox.Text,KeyWordList[i])>0 then
     FoundList.Items.Add(KeyWordList[i]);
  end;
  If FoundList.Items.Count =0 then
   FindResultLbl.Caption :='Not found';
end;

end.
