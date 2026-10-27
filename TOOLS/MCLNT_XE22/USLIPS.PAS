unit Uslips;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, Grids, ExtCtrls,
  UDeclare,TrimStr,UPopList;

type
  TSlipsFrm = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    T4Btn: TButton;
    T4ABtn: TButton;
    T4PSBtn: TButton;
    T4FBtn: TButton;
    T5Btn: TButton;
    T3Btn: TButton;
    T4RSPBtn: TButton;
    T4RIFBtn: TButton;
    ExitBtn: TBitBtn;
    T4APBtn: TButton;
    T4AOASBtn: TButton;
    T5007Btn: TButton;
    T5013Btn: TButton;
    T4UBtn: TButton;
    RetNameLbl: TLabel;
    Label1: TLabel;
    SlipNameBox: TLabel;
    SwitchBtn: TBitBtn;
    FPensBtn: TButton;
    BitBtn1: TBitBtn;
    CheckBox1: TCheckBox;
    ExchangeBtn: TButton;

    procedure ExchangeBtnClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure T4ABtnClick(Sender: TObject);
    procedure T4BtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure ShowSlipFixed(RetNo: integer; SlipName: String);
    procedure ShowSlipColumn(SlipCode :Integer; SlipCol: integer);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: String);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1GetEditText(Sender: TObject; ACol, ARow: Longint;
      var Value: OpenString);
    procedure StringGrid1SelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
    procedure DisplaySlip(SlipName : String);
    procedure ShowT4Fixed(RetNo: integer; SlipCode: integer);
    procedure ShowT4AFixed(RetNo: integer; SlipCode: integer);
    procedure ShowT4APFixed(RetNo: integer; SlipCode: integer);
    procedure ShowT4AOASFixed(RetNo: integer; SlipCode: integer);
    procedure ShowT4RSPFixed(RetNo: integer; SlipCode: integer);
    procedure ShowT4RIFFixed(RetNo: integer; SlipCode: integer);
    procedure ShowT4UFixed(RetNo: integer; SlipCode: integer);
    procedure ShowT4FFixed(RetNo: integer; SlipCode: integer);
    procedure ShowT4PSFixed(RetNo: integer; SlipCode: integer);
    procedure ShowT5Fixed(RetNo: integer; SlipCode: integer);
    procedure ShowT5007Fixed(RetNo: integer; SlipCode: integer);
    procedure ShowT3Fixed(RetNo: integer; SlipCode: integer);
    procedure ShowT5013Fixed(RetNo: integer; SlipCode: integer);
    procedure ShowFPensFixed(RetNo: integer; SlipCode: integer);

    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    Procedure SummarizeSlip(RetNo: integer;SlipName: string);
    procedure SwitchBtnClick(Sender: TObject);
    procedure T4AOASBtnClick(Sender: TObject);
    procedure T4APBtnClick(Sender: TObject);
    procedure T4FBtnClick(Sender: TObject);
    procedure T4PSBtnClick(Sender: TObject);
    procedure T4RIFBtnClick(Sender: TObject);
    procedure T4RSPBtnClick(Sender: TObject);
    procedure T4UBtnClick(Sender: TObject);
    procedure T3BtnClick(Sender: TObject);
    procedure T5BtnClick(Sender: TObject);
    procedure T5007BtnClick(Sender: TObject);
    procedure T5013BtnClick(Sender: TObject);
    procedure FPensBtnClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure HelpBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SlipsFrm: TSlipsFrm;
  RepaintGrid : boolean;
  SwitchingSlip : boolean;

implementation

{$R *.DFM}

procedure TSlipsFrm.ExchangeBtnClick(Sender: TObject);
begin
  (*
  If (SlipName = 'T3') Or (SlipName = 'T5')
  or (SlipName = 'FPENS') then
  begin
  *)
  SomeList := TStringList.Create;
  SomeCaption := 'Avearge Foreign Exch. Rates';
  SomeList.Add('1.3659  : US');
  SomeList.Add('2.0929  : UK');
  Application.CreateForm(TPoplist,PopList);
  PopList.ShowModal;
  SomeList.Free; PopList.Release;
  (*
  If SelectedString = '' then exit;
  If (SlipName = 'T3') or (SlipName = 'T5') then
    begin
     If (StringGrid1.Row = 4) and (StringGrid1.Col > 1) then
      StringGrid1.Cells[StringGrid1.Row,StringGrid1.Col] := LeftStr(SelectedString,6);
    end
    else
     If (SlipName = 'FPENS') and (StringGrid1.Row = 3) and (StringGrid1.Col > 1) then
       StringGrid1.Cells[StringGrid1.Row,StringGrid1.Col] := LeftStr(SelectedString,6);
   StringGrid1.Refresh;
   *)
end;

procedure TSlipsFrm.ExitClick(Sender: TObject);
begin
close;
end;

procedure TSlipsFrm.DisplaySlip(SlipName : String);
var
SlipCol : integer;
begin
  SwitchingSlip := True;
  SlipCode := GetSlipCode(SlipName);
  {ShowMessage('code, Name= '+IntToStr(SlipCode)+' '+SlipName);}
  ShowSlipFixed(RetNo,SlipName);
  for SlipCol := 1 to MaxSlips[SlipCode]-1 do
    ShowSlipColumn(SlipCode,SlipCol);
  SwitchingSlip := False;
 end;


procedure TSlipsFrm.T4BtnClick(Sender: TObject);
begin
 SummarizeSlip(RetNo,SlipName); {for any previous slip}
 SlipName := 'T4';DisplaySlip(SlipName); {SlipName needed}
end;

procedure TSlipsFrm.T4ABtnClick(Sender: TObject);
begin
 SummarizeSlip(RetNo,SlipName); {for any previous slip}
 SlipName := 'T4A';DisplaySlip(SlipName); {SlipName needed}
end;

procedure TSlipsFrm.ShowSlipColumn(SlipCode :Integer; SlipCol: integer);
var
i,j : integer;
s : string[15];
x : Real;
begin
  with StringGrid1 do
  for j := 1 to MaxSlipBoxes[SlipCode]-1 do
  begin
        If NoSummaryRow(SlipName,j) then
         Cells[SlipCol,j] :=
            Ret[RetNo]^.Slip[FirstSlipIndex[SlipCode]+SlipCol-1].Strings[j]
        else
           begin
           x :=Vl(Ret[RetNo]^.Slip[FirstSlipIndex[SlipCode]+SlipCol-1].Strings[j]);
           Str(x:12:2,s); if x = 0 then s := '';
           Cells[SlipCol,j] := JustRight(s,12);
           end;
  end;

     {??? why here??  save slip name - first row}
     {StringGrid1.Cells[SlipCol,1] :=
       Ret[RetNo]^.Slip[FirstSlipIndex[SlipCode]+SlipCol-1].Strings[1];}
 end;

procedure TSlipsFrm.ShowSlipFixed(RetNo: integer; SlipName: string);
Var
i,j : integer;
begin
 for i := 1 to StringGrid1.RowCount-1 do
   StringGrid1.Cells[0,i] := '';

 SlipCode := GetSlipCode(SlipName);
 SlipNameBox.Caption := SlipName +' slips';
 StringGrid1.ColCount := MaxSlips[SlipCode]; {columns}
 StringGrid1.RowCount := MaxSlipBoxes[SlipCode]; {rows}
 StringGrid1.ColWidths[0] := 270; {192;}
 For i := 1 to MaxSlips[SlipCode]-1 do
   StringGrid1.ColWidths[i] := 13 * 7;
 StringGrid1.FixedColor := GetRetColor(RetNo);
 For i := 1 to MaxSlips[SlipCode]-2 do
     StringGrid1.Cells[i,0] := ' Slip '+IntToStr(i);

 StringGrid1.Cells[MaxSlips[SlipCode]-1,0] := ' Total';  {Total column}
 {Select slip to paint}
 RepaintGrid := True;
 if SlipName = 'T4' then ShowT4Fixed(RetNo,SlipCode)
 else if SlipName = 'T4A' then ShowT4AFixed(RetNo,SlipCode)
 else if SlipName = 'T4AP' then ShowT4APFixed(RetNo,SlipCode)
 else if SlipName = 'T4AOAS' then ShowT4AOASFixed(RetNo,SlipCode)
 else if SlipName = 'T4F' then ShowT4FFixed(RetNo,SlipCode)
 else if SlipName = 'T4U' then ShowT4UFixed(RetNo,SlipCode)
 else if SlipName = 'T4PS' then ShowT4PSFixed(RetNo,SlipCode)
 else if SlipName = 'T4RSP' then ShowT4RSPFixed(RetNo,SlipCode)
 else if SlipName = 'T4RIF' then ShowT4RIFFixed(RetNo,SlipCode)
 else if SlipName = 'T3' then ShowT3Fixed(RetNo,SlipCode)
 else if SlipName = 'T5' then ShowT5Fixed(RetNo,SlipCode)
 else if SlipName = 'T5007' then ShowT5007Fixed(RetNo,SlipCode)
 else if SlipName = 'T5013' then ShowT5013Fixed(RetNo,SlipCode)
 else if SlipName = 'FPENS' then ShowFPensFixed(RetNo,SlipCode)
 ;

end;

Procedure TslipsFrm.SummarizeSlip(RetNo:Integer;SlipName: string);
var
i , startRow: integer;  {what rows to summarize}
begin
 SlipCode := GetSlipCode(SlipName);
 StartRow := 2;
 If SlipName = 'T4A' then StartRow := 3;
 If SlipName = 'T5' then StartRow := 6;
 If SlipName = 'T3' then StartRow := 6;

 For i :=StartRow to MaxSlipBoxes[SlipCode]-1 do
    begin SummarizeSlipRow(RetNo,SlipName,i);end;
 If CheckBox1.Checked then
  begin CalcAll(RetNo); SendMessage(MDIHandle,WM_PAINT,0,0);end;

end;


procedure TSlipsFrm.ExitBtnClick(Sender: TObject);
begin
 SummarizeSlip(RetNo,SlipName);
 CalcAll(RetNo);  {before exiting slips}
 SendMessage(MDIHandle,WM_PAINT,0,0);
 Close;
end;

procedure TSlipsFrm.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: String);
var
 NonZeroValue : string[20];
begin

 If SwitchingSlip then exit;
 if NoSummaryRow(SlipName,ARow) then
   Ret[RetNo]^.Slip[FirstSlipIndex[SlipCode]+Acol-1].Strings[ARow] := value
 else
 begin
  NonZeroValue := Value; If NonZeroValue = '0.00' then NonZeroValue := '';
  If NonZerovalue <>
      Ret[RetNo]^.Slip[FirstSlipIndex[SlipCode]+Acol- 1].Strings[ARow] then
    Begin
     Ret[RetNo]^.Slip[FirstSlipIndex[SlipCode]+Acol-1].Strings[ARow] := NonZeroValue;
     RepaintGrid := True;
    end;
 end;
end;

procedure TSlipsFrm.StringGrid1GetEditText(Sender: TObject; ACol,
  ARow: Longint; var Value: OpenString);
{numeric formatting}
begin

  Ret[RetNo]^.Changed := True;
  if ARow = 1 then exit; {no formatting on the description line}
  If NoSummaryRow(SlipName,ARow) then exit;
  {Value := FormatAmount(Value); it disappears}
  Str(vl(Value):12:2,Value);
  if Vl(Value) = 0 then Value := '';
end;



procedure TSlipsFrm.StringGrid1KeyPress(Sender: TObject; var Key: Char);
begin

 {Capture the enter key}
 If Key = #13 then Key := #9;
{exit if numeric validation not needed on strings}
 Ret[RetNo]^.Changed := True;
 if StringGrid1.Row = 1 then exit;
 If NoSummaryRow(SlipName,StringGrid1.Row) then exit;
 if ValidateAmountField(key) = False then key := CHR(0);
end;

procedure TSlipsFrm.StringGrid1SelectCell(Sender: TObject; Col, Row: Longint;
  var CanSelect: Boolean);
var
i : integer;
begin

 If RepaintGrid then
  begin
   For i :=2 to MaxSlipBoxes[SlipCode]-1 do SummarizeSlipRow(RetNo,SlipName,i);
   ShowSlipColumn(SlipCode,Col);  {current column}
   ShowSlipColumn(SlipCode,MaxSlips[SlipCode]-1);  {total column}
   If CheckBox1.Checked then CalcAll(RetNo);
   SendMessage(MDIHandle,WM_PAINT,0,0);  {update status}
   RepaintGrid := False;
  end;
end;

procedure TSlipsFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 If ActiveControl is TStringGrid then
    begin If Key = VK_RETURN then Key := VK_DOWN;end;
 If Key = VK_ESCAPE Then ExitBtnClick(Sender);
 If Key = VK_F1 then ShowHelp('Slips');
{
 If (Key = VK_LEFT) or (key = VK_RIGHT) then
    StringGrid1.Options.goAlwaysShowEditor := True
  else
   StringGrid1.Options.goAlwaysShowEditor := False;
}
  { key := VK_F2;}
  { SendMessage(StringGrid1.Handle, EM_SETSEL, 1, $FFFFFFFF); }{deselect}


end;

procedure TSlipsFrm.FormCreate(Sender: TObject);
begin

RetNameLbl.Caption := GetRetName(RetNo);
RetNameLbl.Color := GetRetColor(RetNo);
(*
 If (SlipName = 'T3') Or (SlipName = 'T5')
  or (SlipName = 'FPENS') then ExchangeBtn.Enabled := True
 else ExchangeBtn.Enabled := False;
 *)
{SlipsFrm.Visible := true;}
{SlipName := 'T4'; } {whatever is supplied by calling program}
SlipCode := GetSlipCode(SlipName);
SwitchingSlip := False;
RepaintGrid := False;
If SlipName = 'T4' then
  T4BtnClick(sender)
else if SlipName = 'T4A' then T4ABtnClick(sender)
else if SlipName = 'T4AOAS' then T4AOASBtnClick(sender)
else if SlipName = 'T4AP' then T4APBtnClick(sender)
else if SlipName = 'T4F' then T4FBtnClick(sender)
else if SlipName = 'T4PS' then T4PSBtnClick(sender)
else if SlipName = 'T4RSP' then T4RSPBtnClick(sender)
else if SlipName = 'T4RIF' then T4RIFBtnClick(sender)
else if SlipName = 'T4U' then T4UBtnClick(sender)
else if SlipName = 'T3' then T3BtnClick(sender)
else if SlipName = 'T5' then T5BtnClick(sender)
else if SlipName = 'T5007' then T5007BtnClick(sender)
else if SlipName = 'T5013' then T5013BtnClick(sender)
else if SlipName = 'FPENS' then FPENSBtnClick(sender)
;
SlipsFrm.Visible := true;
end;

procedure TSlipsFrm.SwitchBtnClick(Sender: TObject);
Var SpouseSin1, SpouseSin2: String[11];
PrevRetNo :integer;
begin
If RetInMem <1 then exit;
PrevRetNo := RetNo;
SpouseSin1 := FetchElm(RetNo,'PAGE_1',3);
SpouseSin2 := FetchElm(RetNo,'PAGE_1',4);
RetNo := GetNextReturn(RetNo);
If RetNo = RetNoOfSpouse(PrevRetNo,SpouseSin1,SpouseSin2) then
       CplXfer(PrevRetNo,RetNo);
{
If IsReturnASpouse(RetNo,SpouseSin1,SpouseSin2) then
     CplXfer(PrevRetNo,RetNo);
}
RetNameLbl.Caption := GetRetName(RetNo);
RetNameLbl.Color := GetRetColor(RetNo);
SummarizeSlip(RetNo,SlipName); {for any previous slip}
DisplaySlip(SlipName);
SendMessage(MDIHandle,WM_PAINT,0,0);
end;


procedure TSlipsFrm.ShowT4Fixed(RetNo: integer; SlipCode: integer);
begin
  With StringGrid1 do
   begin
   Cells[0,0] := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1] := '      Payer Name';
   Cells[0,2] := '(14) Total earnings';
   Cells[0,3] := '(16) CPP';
   Cells[0,4] := '(17) QPP';
   Cells[0,5] := '(18) UI';
   Cells[0,6] := '(20) RPP-current service';
   Cells[0,7] := '(20) RPP-past service';
   Cells[0,8] := '(22) Tax deducted';
   Cells[0,9] := '(24) Insurable earnings';
   Cells[0,10] := '(26) Pensionable earnings';
   Cells[0,11] := '(36) Home Loan';
   Cells[0,12] := '(38) Stock option benefits';
   Cells[0,13] := '(42) Employment commissions';
   Cells[0,14] := '(44) Union Dues';
   Cells[0,15] := '(46) Charitable donations';
   Cells[0,16] := '(52) Pension adjustment';
   Cells[0,17] := '     UI weeks (52,53,54)';
   end;
end;

procedure TSlipsFrm.ShowT4AFixed(RetNo: integer; SlipCode: integer);
begin
   With StringGrid1 do
   begin
   Cells[0,0]  := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1]  := '     Payer Name';
   Cells[0,2]  := '     Received due to death of spouse? (Y/N)';
   Cells[0,3]  := '(16) Pension/Superannuation -RPP';
   Cells[0,4]  := '(16) Pension/Superannuation -DPSP';
   Cells[0,5]  := '(18) Lump sum payment-RPP';
   Cells[0,6]  := '(18) Lump sum payment-DPSP';
   Cells[0,7]  := '(18) Payments from revoked DPSP';
   Cells[0,8]  := '(20) Self-employed income *Use T2124*';
   Cells[0,9]  := '(22) Income tax deducted';
   Cells[0,10] := '(24) Annuities-IAAC';
   Cells[0,11] := '(24) Annuities-General';
   Cells[0,12] := '(26) Retiring allowance-eligible';
   Cells[0,13] := '(26) Retiring allowance-non-eligible';

   Cells[0,14] := '(28) Other Income -Eligible for CPP/RRSP';
   Cells[0,15] := '(28) Other Income -Non-elgbl for CPP/RRSP';
   Cells[0,16]:= ' (28) DPSP Annuity Payments';
   Cells[0,17] := '(28) Scholarships/bursaries';
   Cells[0,18] := '(28) Employer paid benefits (i.e. grants)';
   Cells[0,19] := '(28) Wage Loss replacement Benefit';

   Cells[0,20] := '(30) Patronage allocations';
   Cells[0,21] := '(32) RPP contr.-past service after 1989';
   Cells[0,22] := '(34) Pension adjustment';
   Cells[0,23] := '(46) Charitable donations';
  end;
end;

procedure TSlipsFrm.ShowT4RSPFixed(RetNo: integer; SlipCode: integer);
begin
  With StringGrid1 do
   begin
   Cells[0,0]  := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1]  := 'Name on slip';
   Cells[0,2]  := '(16) Annuity payments-eligible';
   Cells[0,3]  := '(16) Annuity payments-Non-eligible';
   Cells[0,4]  := '(18) Refund of premiums to spouse';
   Cells[0,5]  := '(20) Refund of excess amounts';
   Cells[0,6]  := '(22) Withdrawal/other commutation';
   Cells[0,7]  := '(22 Commutation- direct transfer';
   Cells[0,8]  := '(26) Deemed receipt on Deregistration';
   Cells[0,9]  := '(28) Other income';
   Cells[0,10] := '(28) Other Deductions';
   Cells[0,11] := '(30) Total Tax deducted';
   Cells[0,12] := '(34) Deemed Receipt on Death';
   end;
end;

procedure TSlipsFrm.ShowT4FFixed(RetNo: integer; SlipCode: integer);
begin
  With StringGrid1 do
   begin
   Cells[0,0] := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1] := '     Description';
   Cells[0,2] := '(14) Gross Earnings *Use Fishing Statement*';
   Cells[0,3] := '(16) UI Insurable Earnings';
   Cells[0,4] := '(18) UI Premium';
   Cells[0,5] := '(22) Income Tax Deducted';
   end;
end;

procedure TSlipsFrm.ShowT4PSFixed(RetNo: integer; SlipCode: integer);
begin
  With StringGrid1 do
   begin
   Cells[0,0] := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1] := '     Description';
   Cells[0,2] := '(31) Taxable amount of dividends';
   Cells[0,3] := '(33) Interest';
   Cells[0,4] := '(34) Capital Gains(losses)';
   Cells[0,5] := '(35) Other Income';
   Cells[0,6] := '(36) Amount forefeited due to withdrawl';
   Cells[0,7] := '(37) Foreign Non-Business Income in $Can';
   Cells[0,8] := '(38) Foreign Capital Gains(losses) in $Can';
   Cells[0,9] := '(39) Foreign non-bus tax paid-Investment in $Can';
   Cells[0,10] := '(39) Foreign non-bus tax paid-Cap. Gains in $Can';
   Cells[0,11] := '(40) Non-eligible Capital Gains(losses)';
   end;
end;

procedure TSlipsFrm.ShowT4RIFFixed(RetNo: integer; SlipCode: integer);
begin
  With StringGrid1 do
   begin
   Cells[0,0] := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1] := '     Description';
   Cells[0,2] := '(16) Amounts taxable';
   Cells[0,3] := '(18) Deeemed Receipt - Deceased';
   Cells[0,4] := '(20) Deeemed Receipt - Deregistration';
   Cells[0,5] := '(22) Other Income';
   Cells[0,6] := '(22) Other Deductions';
   Cells[0,7] := '(28) Tax deducted';
   Cells[0,8] := '(24) Excess Amount';
   end;
end;


procedure TSlipsFrm.ShowT4AOASFixed(RetNo: integer; SlipCode: integer);
begin
  With StringGrid1 do
   begin
   Cells[0,0] := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1] := '     Description';
   Cells[0,2] := '(18) Net OAS';
   Cells[0,3] := '(22) Income tax deducted';
   Cells[0,4] := '(21) Net federal supplements';
   end;
end;

procedure TSlipsFrm.ShowT4APFixed(RetNo: integer; SlipCode: integer);
begin
  With StringGrid1 do
   begin
   Cells[0,0] := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1] := '     Description';
   Cells[0,2] := '     Type (1=Retrm,2=Srv,3=Disab.,4=Child 5=Death';
   Cells[0,3] := '     Month started (if Retirement or Disability)';
   Cells[0,4] := '(20) Taxable Benefits';
   Cells[0,5] := '(16) Disability in box 20';
   Cells[0,6] := '(22) Income Tax deducted';
   Cells[0,7] := '(24) Net OAS';
   end;
end;

procedure TSlipsFrm.ShowT4UFixed(RetNo: integer; SlipCode: integer);
begin
  With StringGrid1 do
   begin
   Cells[0,0] := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1] := '     Description';
   Cells[0,2] := '(14) Total Benefit';
   Cells[0,3] := '(22) Income Tax deducted';
   end;
end;

procedure TSlipsFrm.ShowT3Fixed(RetNo: integer; SlipCode: integer);
begin
  With StringGrid1 do
   begin
   Cells[0,0] := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1] := '     Description';
   Cells[0,2] := '     % Share of TaxPayer (if shared)';
   Cells[0,3] := '     Enter Y, If Shared with Spouse';
   Cells[0,4] := '     Foreign exchange Rate';
   Cells[0,5] := '     Foreign Country (Enter 1, 2, or 3)';
   Cells[0,6] := '(21) Capital Gains(losses)';
   Cells[0,7] := '(22) Lump-sum pension benefits';
   Cells[0,8] := '(24) Foreign Business Income *Use T2124*';
   Cells[0,9] := '(25) Foreign non-business income';
   Cells[0,10] := '(26) Other Income';
   Cells[0,11] := '(30) Capital Gains eligible for deduction';
   Cells[0,12] := '(31) Eligible Pension income';
   Cells[0,13] := '(32) Taxable amount of Dividends';
   Cells[0,14] := '(33) Foreign Business tax paid';
   Cells[0,15] := '(34) Foreign non-business tax paid';
   Cells[0,16] := '(37) Insurance Segregated Fund Capital Losses';
   Cells[0,17] := '';
   Cells[0,18] := '';
   Cells[0,19] := '(38) Part XII.2 tax credit';
   Cells[0,20] := '(41) Investment tax credit';

   end;
end;


procedure TSlipsFrm.ShowT5Fixed(RetNo: integer; SlipCode: integer);
begin
  With StringGrid1 do
   begin
   Cells[0,0] := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1] := '     Description';
   Cells[0,2] := '     % Share of TaxPayer (if shared)';
   Cells[0,3] := '     Enter Y (if Shared with spouse)';
   Cells[0,4] := '     Foreign Exchange Rate';
   Cells[0,5] := '     Foreign Country (Enter 1, 2, or 3)';
   Cells[0,6] := '(11) Taxable amount of dividends';
   Cells[0,7] := '(13) Interest from Canadian sources';
   Cells[0,8] := '(14) Other income from Can. sources';
   Cells[0,9] := '(15) Foreign Income';
   Cells[0,10] := '(16) Foreign Tax paid';
   Cells[0,11] := '(17) Royalties from Can. sources';
   Cells[0,12] := '(18) Capital Gains Dividends';
   Cells[0,13] := '(19) Annuity Income';
   Cells[0,14] := '  Source of interest(Bank=1,Bond=2,Mortgage=3)';
   end;
end;

procedure TSlipsFrm.ShowT5007Fixed(RetNo: integer; SlipCode: integer);
begin
  With StringGrid1 do
   begin
   Cells[0,0] := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1] := '     Description';
   Cells[0,2] := '(10) Worker Compensation';
   Cells[0,3] := '(11) Social Assistance Payment';
   Cells[0,4] := '     % of Social assistance (MANITOBA ONLY)';
   end;
end;

procedure TSlipsFrm.ShowFPENSFixed(RetNo: integer; SlipCode: integer);
begin
  With StringGrid1 do
   begin
   Cells[0,0] := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1] := '     Description';
   Cells[0,2] := '     Foreign Country (Enter 1,2,or 3)';
   Cells[0,3] := '     Foreign Exchange rate';
   Cells[0,4] := '  Foreign pension Amount (In foreign currency)';
   Cells[0,5] := '  Income tax deducted (In foreign currency)';
   Cells[0,6] := '  Amount exempt by treaty (In foreign currency)';
   end;
end;

procedure TSlipsFrm.ShowT5013Fixed(RetNo: integer; SlipCode: integer);
begin
  ShowMessage('Not available in this version of the program');
  With StringGrid1 do
   begin
   Cells[0,0] := ' Total=> '+ IntToStr(MaxSlips[SlipCode]-2);
   Cells[0,1] := '     Description';
   Cells[0,2] := '(18) Net Bus. Income (Loss)';
   Cells[0,3] := '(20) Net Rental Income (loss)';
   Cells[0,4] := '(23) Limited Partnership loss carryforward';
   Cells[0,5] := '(24) Actual amount of dividends';
   Cells[0,6] := '     Taxable amount of dividends';
   Cells[0,7] := '(25) Interest from canadian sources';
   Cells[0,8] := '(19) Foreign business income (loss)';
   Cells[0,9] := '(21) Foreign Rental Income (loss)';
   Cells[0,10] := '(26) Foreign Divident and interest income';
   Cells[0,11] := '(27) Foreign Capital Gains (losses)';
   Cells[0,12] := '(27) Capital Gains (losses) - Qualified Farm Prop.';
   Cells[0,13] := '(27) Capital Gains (losses) - Qualified Small Bus.';
   Cells[0,14] := '(27) Capital Gains (losses) - Other (Canadian only)';
   Cells[0,15] := '     Capital Gains not eligible for the deduction';
   Cells[0,16] := '(29) Business Investment Loss';
   Cells[0,17] := '(30) Income tax deducted';
   Cells[0,18] := '(31) Partnership gross income';
   Cells[0,19] := '(32) Carrying charges';
   Cells[0,20] := '(33) Foreign non business tax paid - on Rental income';
   Cells[0,21] := '(33) Foreign non business tax paid - on Investm. income';
   Cells[0,22] := '(33) Foreign non business tax paid - on capital ains';
   Cells[0,23] := '(33) Foreign Business tax paid - on Rental income';
   Cells[0,24] := '(34) Charitable donations';
   Cells[0,25] := '(35) Gifts to Canada or a province';
   Cells[0,26] := '(36) Federal Political contributions';
   Cells[0,27] := '(37) Provincial political contributions';
   Cells[0,28] := '(38) Investment tax credit';
   Cells[0,29] := '(39) Canadian exploration expenses';
   Cells[0,30] := '(40) Canadian development expenses';
   Cells[0,31] := '(41) Canadian Oil and gas property expenses';
   Cells[0,32] := '(42) Foreign exploration and development expenses';
   Cells[0,33] := '(43) Recapture of earned depletion';
   Cells[0,34] := '(44) Amount eligible for resource allowance deduction';
   end;
end;

procedure TSlipsFrm.T4AOASBtnClick(Sender: TObject);
begin
SummarizeSlip(RetNo,SlipName); {for any previous slip}
SlipName := 'T4AOAS';DisplaySlip(SlipName); {SlipName needed}
end;

procedure TSlipsFrm.T4APBtnClick(Sender: TObject);
begin
SummarizeSlip(RetNo,SlipName); {for any previous slip}
SlipName := 'T4AP';DisplaySlip(SlipName); {SlipName needed}
end;

procedure TSlipsFrm.T4FBtnClick(Sender: TObject);
begin
SummarizeSlip(RetNo,SlipName); {for any previous slip}
SlipName := 'T4F';DisplaySlip(SlipName); {SlipName needed}
end;

procedure TSlipsFrm.T4PSBtnClick(Sender: TObject);
begin
SummarizeSlip(RetNo,SlipName); {for any previous slip}
SlipName := 'T4PS';DisplaySlip(SlipName); {SlipName needed}
end;

procedure TSlipsFrm.T4RIFBtnClick(Sender: TObject);
begin
SummarizeSlip(RetNo,SlipName); {for any previous slip}
SlipName := 'T4RIF';DisplaySlip(SlipName); {SlipName needed}
end;

procedure TSlipsFrm.T4RSPBtnClick(Sender: TObject);
begin
SummarizeSlip(RetNo,SlipName); {for any previous slip}
SlipName := 'T4RSP';DisplaySlip(SlipName); {SlipName needed}
end;

procedure TSlipsFrm.T4UBtnClick(Sender: TObject);
begin
SummarizeSlip(RetNo,SlipName); {for any previous slip}
SlipName := 'T4U';DisplaySlip(SlipName); {SlipName needed}
end;

procedure TSlipsFrm.T3BtnClick(Sender: TObject);
begin
SummarizeSlip(RetNo,SlipName); {for any previous slip}
SlipName := 'T3';DisplaySlip(SlipName); {SlipName needed}
end;

procedure TSlipsFrm.T5BtnClick(Sender: TObject);
begin
SummarizeSlip(RetNo,SlipName); {for any previous slip}
SlipName := 'T5';DisplaySlip(SlipName); {SlipName needed}
end;

procedure TSlipsFrm.T5007BtnClick(Sender: TObject);
begin
SummarizeSlip(RetNo,SlipName); {for any previous slip}
SlipName := 'T5007';DisplaySlip(SlipName); {SlipName needed}
end;

procedure TSlipsFrm.FPENSBtnClick(Sender: TObject);
begin
SummarizeSlip(RetNo,SlipName); {for any previous slip}
SlipName := 'FPENS';DisplaySlip(SlipName); {SlipName needed}
end;


procedure TSlipsFrm.T5013BtnClick(Sender: TObject);
begin
SummarizeSlip(RetNo,SlipName); {for any previous slip}
SlipName := 'T5013';DisplaySlip(SlipName); {SlipName needed}
end;


procedure TSlipsFrm.StringGrid1DrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
begin

 (*
  With (Sender as TStringGrid).Canvas do
  begin
   if Col > 1 then
     begin
      Font.Name := 'Courier New';
      FillRect(Rect);
      TextOut(Rect.Left,Rect.Top,StringGrid1.Cells[Col,Row]);
     end
   else
     begin
      Font.Name := 'Arial';
      FillRect(Rect);
      TextOut(Rect.Left,Rect.Top,StringGrid1.Cells[Col,Row]);
     end;
  end;
 *)
end;
procedure TSlipsFrm.HelpBtnClick(Sender: TObject);
begin
ShowHelp('Slips');
end;

procedure TSlipsFrm.BitBtn1Click(Sender: TObject);
begin
 Application.HelpJump('Slips');
end;

procedure TSlipsFrm.CheckBox1Click(Sender: TObject);
begin
 CalcAll(RetNo);
 SendMessage(MDIHandle,WM_PAINT,0,0);
end;

end.


