unit FP_2027savingscalculator;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls;

type
  TSavingsCalculatorFP_2012 = class(TForm)
    CalcBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ListBox1: TListBox;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    AmountBox: TEdit;
    YearsBox: TEdit;
    InterestBox: TEdit;
    Label7: TLabel;
    OpeningBalanceBox: TEdit;
    ResultBox: TEdit;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    TaxRateBox: TEdit;
    Panel2: TPanel;
    Label4: TLabel;
    TimingBox: TEdit;
    Label6: TLabel;
    Label5: TLabel;
    Label11: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SavingsCalculator: TSavingsCalculatorFP_2012;

implementation

{$R *.DFM}

uses FP_2027,FP_2027Declare,FP_2027TrimStr,vtTrimStr,vtShared;

procedure TSavingsCalculatorFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TSavingsCalculatorFP_2012.FormCreate(Sender: TObject);
begin
OpeningBalanceBox.Text :='0';
AmountBox.Text := '10000';
YearsBox.Text := '10';
InterestBox.Text := '10';
{InflationBox.Text := '0';}
end;

procedure TSavingsCalculatorFP_2012.CalcBtnClick(Sender: TObject);
Var i,Years:Integer;
    OpeningBalance,Amount,Interest,TaxRate,Inflation :Real;
    PeriodInterestArray: array of Real;
    PeriodBalanceArray : array of Real;
begin
 OpeningBalance := Vl(OpeningBalanceBox.Text);
 Amount := Vl(AmountBox.Text);
 Years := MyStrToInt(YearsBox.Text);
 If Years <1 then begin YearsBox.Text:='1'; Years:=1;end;
 Interest := Vl(InterestBox.Text)/100;
 Inflation :=0;
 {Inflation := Vl(InflationBox.Text)/100;}
 TaxRate   := Vl(TaxRateBox.Text)/100;
 SetLength(PeriodInterestArray, Years);
 SetLength(PeriodBalanceArray, Years);
 SavingsCalc(OpeningBalance,Amount,Interest,TaxRate,Inflation,Years,
     PeriodInterestArray,PeriodBalanceArray,TimingBox.Text);
 ListBox1.Clear;
 ListBox1.Items.Add(
      PaddR('Year',5)
     +JustRight('Interest',15)
     +JustRight('Balance',15));
 ListBox1.Items.Add(
   PaddR('',5)
     +JustRight('After tax',15)
     +JustRight('',15));
 ListBox1.Items.Add(' ');
 For i:=0 to years-1 do   {show year as I+1}
 begin
  ListBox1.Items.Add(
    PaddR(IntToStr(i+1),5)
   +JustRight(FormatFloat('###,###,###.00',PeriodInterestArray[i]),15)
   +JustRight(FormatFloat('###,###,###.00',PeriodBalanceArray[i]),15));
 end;
 ResultBox.Text :=JustRight(FormatFloat('###,###,###.00',PeriodBalanceArray[Years-1]),15);
 SetLength(PeriodInterestArray, 0);
 SetLength(PeriodBalanceArray, 0);
end;

end.
