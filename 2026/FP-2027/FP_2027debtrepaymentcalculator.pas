unit FP_2027debtrepaymentcalculator;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,Math,ExtCtrls;

type
  TDebtRepaymentCalculatorFP_2012 = class(TForm)
    CalcBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ListBox1: TListBox;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    PrincipalBox: TEdit;
    PeriodsBox: TEdit;
    InterestBox: TEdit;
    ResultBox: TEdit;
    Bevel3: TBevel;
    Label8: TLabel;
    Panel2: TPanel;
    PeriodTypeBox: TRadioGroup;
    perPaymentBox: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DebtRepaymentCalculator: TDebtRepaymentCalculatorFP_2012;

implementation

{$R *.DFM}

uses FP_2027,FP_2027Declare,FP_2027TrimStr,vtTrimStr,vtShared;

procedure TDebtRepaymentCalculatorFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TDebtRepaymentCalculatorFP_2012.FormCreate(Sender: TObject);
begin
PrincipalBox.Text := '10000';
PeriodsBox.Text := '5';
InterestBox.Text := '10';
PeriodTypeBox.ItemIndex :=0;
end;

procedure TDebtRepaymentCalculatorFP_2012.CalcBtnClick(Sender: TObject);
Var i:Integer;NumPeriods:Real;
    x,Principal,Interest :Real;
    {
    PeriodInterestArray: array of Real;
    PeriodBalanceArray : array of Real;}
begin
 {OpeningBalance := Vl(OpeningBalanceBox.Text);}
 Principal := Vl(PrincipalBox.Text);
 NumPeriods := Vl(PeriodsBox.Text);
 If NumPeriods <1 then begin PeriodsBox.Text:='1'; NumPeriods:=1;end;
 Interest := Vl(InterestBox.Text);
 If PeriodTypeBox.ItemIndex =1 then
  begin
  Interest := Interest/12;
  PerPaymentBox.Caption := 'per month';
  end
 else
   PerPaymentBox.Caption := 'per year';
 x:=DebtPayment(Principal,Interest,NumPeriods);
 ResultBox.Text :=JustRight(FormatFloat('###,###,###.00',x),15);
end;

end.

