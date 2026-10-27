unit T4T5_2026SpecificPrint;
//20170214 Igor (All module and dfm)
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, vtMulti;

type
  TPrintKind = (pkT4, pkT4A, pkT5, pkUnknown);

  TfrmT4T5SpecificPrint = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    lblCurrentSlipName: TLabel;
    Label2: TLabel;
    lblTotalSlips: TLabel;
    BitBtn1: TBitBtn;
    lblWarning: TLabel;
    PrintDialogItem: TPrintDialog;
    rbBlankCurr: TRadioButton;
    rbBlankAll: TRadioButton;
    rbBlankSUM: TRadioButton;
    rbCRACurr: TRadioButton;
    rbCRAAll: TRadioButton;
    rbCRASUM: TRadioButton;
    gbPrintType: TGroupBox;
    lblCRAForm: TLabel;
    btnPrint: TBitBtn;
    rgSlipType: TRadioGroup;
    gbFilter: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label16: TLabel;
    edtFrom: TEdit;
    edtTo: TEdit;
    lblT4Total: TLabel;
    pnlPrintSettings: TPanel;
    btnSummaryInstructions: TBitBtn;
    Label3: TLabel;
    LblCurrentEmployer: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure rbBlankCurrClick(Sender: TObject);
    procedure edtFromChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSummaryInstructionsClick(Sender: TObject);
    procedure BitBtn1Exit(Sender: TObject);
  private
    FRetNo: Integer;
    FFormName: String;
    FNonInstFormName: String;
    FFormNo: Integer;
    FInstNo: Integer;
    FInstForms: TFRecArray;
    FFormToPrint: TStringList;
    FPrintKind: TPrintKind;
    { Private declarations }
    procedure StartPrint;
    procedure PrintCurr(AOnlyValue: Boolean);
    procedure PrintAll(AOnlyValue: Boolean);
    procedure PrintSUM(AOnlyValue: Boolean);

  public
    { Public declarations }
  end;

procedure T4T5SpecificPrint(ARetNo: Integer; AFormName: String);
function GetPrintKind(AFormName: String): TPrintKind;
implementation

{$R *.dfm}

uses
  vtTrimStr,  vtCommon, vcl.Printers, vtShared,
  T4T5_2026Declare, T4T5_2026Print, T4T5_2026;

const
  PrintNames : Array[TPrintKind] of String = ('T4', 'T4A', 'T5', '');
  InstructionFormNames: Array[TPrintKind] of String = ('T4SUMI', 'T4ASUMI', 'T5SUMI', '');
  SumFormNames: Array[TPrintKind] of String = ('T4SUM', 'T4ASUM', 'T5SUM', ''); //20171223
  //SumFormNames: Array[TPrintKind] of String = ('T4SUML', 'T4ASUML', 'T5SUML', '');

//20171228 Igor>>>
function GetPrintKind(AFormName: String): TPrintKind;
var
  lPrintKind: TPrintKind;
begin
  for lPrintKind := Low(TPrintKind) to High(TPrintKind) do
    if AFormName.StartsWith(PrintNames[lPrintKind] + '#', True) then
      Exit(lPrintKind);
  Result := pkUnknown;
end;

procedure T4T5SpecificPrint(ARetNo: Integer; AFormName: String);
begin
  if GetPrintKind(AFormName) = pkUnknown then
  begin
    MessageDlg('Please open the slips before you call the printing of the Slips or Summary',
      TMsgDlgType.mtWarning, [mbOk], 0);
    Exit;
  end;
//20171228 Igor<<<

  with TfrmT4T5SpecificPrint.Create(application) do
  begin
    try
      FRetNo := ARetNo;
      FFormName := AFormName;
      FNonInstFormName := ExtractNonInstFormName(AFormName);
      FInstForms := FList.GetAllInstForms(FNonInstFormName, FRetNo); //20180111 Igor
      FFormNo := RetList[FRetNo].Form[AFormName].FormNo;
      FInstNo := ExtractFormInstNo(AFormName);
      if ARetNo > 0 then LblCurrentEmployer.Caption:=FetchElm(ARetNo,'EMPL',1); //20171227
      ShowModal;
    finally
      free;
    end;
  end;
end;

procedure TfrmT4T5SpecificPrint.BitBtn1Exit(Sender: TObject);
begin
//20180114
 ShowMessage('If you printed final slips/summaries,'
  +Chr(13)+' '+'Open the EMPL form and Set the Status of the corresponding slips to PRINTED'
  +Chr(13)+' '+'and Save the return'); //20180114

 {
 Case TypeOfReturnBtn.ItemIndex of
      0:Begin OpenForm(RetNo,'EMPL',17);end;     //t4
      1:Begin OpenForm(RetNo,'EMPL',39);end;   //t4a
      2:Begin OpenForm(RetNo,'EMPL',40);end;   //t4a

 end;
 }
end;

procedure TfrmT4T5SpecificPrint.btnPrintClick(Sender: TObject);
begin
  StartPrint;
end;

procedure TfrmT4T5SpecificPrint.FormCreate(Sender: TObject);
begin
  FFormToPrint := TStringList.Create;
end;

procedure TfrmT4T5SpecificPrint.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FFormToPrint);
end;

procedure TfrmT4T5SpecificPrint.FormShow(Sender: TObject);
//20171228 Igor>>>
begin
  FPrintKind := GetPrintKind(FFormName);
  if FPrintKind = pkUnknown then
  begin
    Close;
    Exit;
  end;
//20171228 Igor<<<
  case FPrintKind of
    pkT4:
      lblCurrentSlipName.Caption := FFormName + '; ' +
        FetchElm(FRetNo, FFormName, T4_LASTNAME)+ ' '+
        FetchElm(FRetNo, FFormName, T4_FIRSTNAME);
    pkT4A:
      lblCurrentSlipName.Caption := FFormName + '; ' +
        FetchElm(FRetNo, FFormName, T4A_LASTNAME)+ ' '+
        FetchElm(FRetNo, FFormName, T4A_FIRSTNAME);
    pkT5:
      lblCurrentSlipName.Caption := FFormName + '; ' +
        FetchElm(FRetNo, FFormName, T5_LASTNAME_FIRSTNAME);
  end;

  lblTotalSlips.Caption := intToStr(length(FInstForms));
  CountDiagnostics(FRetNo);
  If (RetList[FRetNo].MandatoryErrorCount + RetList[FRetNo].SeriousErrorCount) > 0 then
    lblWarning.Caption := 'Return has errors. Please fix before printing/filing';
  rbBlankCurrClick(nil);
  edtFromChange(nil);
end;

procedure TfrmT4T5SpecificPrint.btnSummaryInstructionsClick(Sender: TObject);
var
  InstructionFormName: String;
begin
  InstructionFormName := InstructionFormNames[FPrintKind];
  Assert(RetList[FRetNo].GetFormNo(InstructionFormName) > 0,  'Form ' + InstructionFormName + ' not found');
  If PrintDialogItem.Execute then
  begin
    PrintForm(FRetNo, InstructionFormName, 99, '');
    if Printer.Printing then
      Printer.EndDoc;
  end;
end;

procedure TfrmT4T5SpecificPrint.edtFromChange(Sender: TObject);
var
  I, AllCount: Integer;
  LastName, MinLastName, MaxLastName: String;
begin
  AllCount := 0;
  MinLastName := '';
  MaxLastName := '';
  FFormToPrint.Clear;
  for I := 0 to Length(FInstForms) - 1 do
  begin
    case FPrintKind of
      pkT4:
        LastName := FetchElm(FRetNo, FInstForms[I].FormInstName, T4_LASTNAME) + ' ' +
          FetchElm(FRetNo, FInstForms[I].FormInstName, T4_FIRSTNAME);
      pkT4A:
        LastName := FetchElm(FRetNo, FInstForms[I].FormInstName, T4A_LASTNAME) + ' ' +
          FetchElm(FRetNo, FInstForms[I].FormInstName, T4A_FIRSTNAME);
      pkT5:
        LastName := FetchElm(FRetNo, FInstForms[I].FormInstName, T5_LASTNAME_FIRSTNAME);
    else
      LastName := '';
    end;


    if ((edtFrom.Text = '') or (CompareText(Copy(LastName, 1, length(edtFrom.Text)), edtFrom.Text) >= 0)) and
       ((edtTo.Text = '') or (CompareText(Copy(LastName, 1, length(edtTo.Text)), edtTo.Text) <= 0))  then
    begin
      inc(AllCount);
      if (LastName < MinLastName) or (MinLastName = '') then
        MinLastName := LastName;
      if (LastName > MaxLastName) or (MaxLastName = '') then
        MaxLastName := LastName;
      FFormToPrint.AddObject(LastName, TObject(I));
    end;
  end;
  FFormToPrint.Sort;
  lblT4Total.Hint := FFormToPrint.Text;
  if AllCount = 0 then
    lblT4Total.Caption := '0 slips.'
  else
    lblT4Total.Caption := IntToStr(AllCount)+' slips. From "' + MinLastName + '" to "' + MaxLastName + '"';
end;

//*************    T4   ****************

procedure TfrmT4T5SpecificPrint.StartPrint;
begin
  if rbBlankCurr.Checked or rbCRACurr.Checked then
    PrintCurr(rbCRACurr.Checked)
  else
  if rbBlankAll.Checked or rbCRAAll.Checked then
    PrintAll(rbCRAAll.Checked)
  else
  if rbBlankSUM.Checked or rbCRASUM.Checked then
    PrintSUM(rbCRASUM.Checked);
end;

procedure TfrmT4T5SpecificPrint.PrintCurr(AOnlyValue: Boolean);//20171223 Igor
var
  st: TSlipTypes;
begin
  If PrintDialogItem.Execute then
  begin
    case rgSlipType.ItemIndex of
      0: st := [stGovernment];
      1: st := [stEmployee];
      2: st := [stPreparer];
      3: st := [stGovernment, stEmployee, stPreparer];
    end;
    PrintForm(FRetNo, FFormName, 99, '', st, AOnlyValue);
    if Printer.Printing then
      Printer.EndDoc;
  end;
end;

procedure TfrmT4T5SpecificPrint.PrintAll(AOnlyValue: Boolean);
var
  I: Integer;//20171228 Igor
  F: TFRec;
  st: TSlipTypes;
  t, LastT: TSlipType;//20171228 Igor
  LastFormName, S: string;//20171228 Igor
begin
  If PrintDialogItem.Execute then
  begin
    case rgSlipType.ItemIndex of
      0: begin
        st := [stGovernment];
        LastT := stGovernment;
      end;
      1: begin
        st := [stEmployee];
        LastT := stEmployee;
      end;
      2: begin
        st := [stPreparer];
        LastT := stPreparer;
      end;
      3: begin
        st := [stGovernment, stEmployee, stPreparer];
        LastT := stPreparer;
      end;
    end;
    FastPrint := True;
    try
      try
        LastFormName := FInstForms[Integer(FFormToPrint.Objects[FFormToPrint.Count - 1])].FormInstName;//20171228 Igor
        //20171228 Igor>>>
        for t in st do
        begin
          //20180118 Igor >>>
          {if t = LastT then
            S := LastFormName
          else
            S := 'Continue';}
          //20180118 Igor <<<
          for I := 0 to FFormToPrint.Count - 1 do
          begin
            //20180118 Igor >>>
            if I = FFormToPrint.Count - 1 then
              S := LastFormName
            else
              S := 'Continue';
            //20180118 Igor <<<
            F := FInstForms[Integer(FFormToPrint.Objects[I])];
            PrintForm(FRetNo, F.FormInstName, 99, S, [t], AOnlyValue);//20171228 Igor
          end;
        end;
        //20171228 Igor<<<
      finally
        if Printer.Printing then
          Printer.EndDoc;
      end;
    finally
      FastPrint := False;
    end;
  end;
end;

procedure TfrmT4T5SpecificPrint.PrintSUM(AOnlyValue: Boolean);
var
  T4SumFormNo: Integer;
  T4SumFormName: String;
begin
  T4SumFormName := SumFormNames[FPrintKind];
  T4SumFormNo := RetList[FRetNo].GetFormNo(T4SumFormName);
  assert(T4SumFormNo > 0, 'Form ' + T4SumFormName + ' not found');
  If RetList[FRetNo].Frm[T4SumFormNo].Count = 0 then
    InitFormData(FRetNo, T4SumFormNo);
  Calc(FRetNo, T4SumFormName);
  If PrintDialogItem.Execute then
  begin
    PrintForm(FRetNo, T4SumFormName, 99, '', stDefault, AOnlyValue);
    if Printer.Printing then
      Printer.EndDoc;
  end;
end;

procedure TfrmT4T5SpecificPrint.rbBlankCurrClick(Sender: TObject);
begin
  rgSlipType.Visible := rbBlankAll.Checked or rbCRAAll.Checked or
    rbBlankCurr.Checked or rbCRACurr.Checked;
  gbFilter.Visible := rbBlankAll.Checked or rbCRAAll.Checked;
end;

end.
