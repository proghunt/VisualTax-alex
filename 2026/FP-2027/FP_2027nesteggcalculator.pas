unit FP_2027nesteggcalculator;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,Math,ExtCtrls;

type
  TNestEggCalculatorFP_2012 = class(TForm)
    CalcBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ListBox1: TListBox;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    AmountBox: TEdit;
    YearsBox: TEdit;
    InterestBox: TEdit;
    ResultBox: TEdit;
    Bevel3: TBevel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    TaxRateBox: TEdit;
    Panel2: TPanel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NestEggCalculator: TNestEggCalculatorFP_2012;

implementation

{$R *.DFM}

uses FP_2027,FP_2027Declare,FP_2027TrimStr,vtTrimStr,vtShared;

procedure TNestEggCalculatorFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TNestEggCalculatorFP_2012.FormCreate(Sender: TObject);
begin
{OpeningBalanceBox.Text :='0';}
AmountBox.Text := '10000';
YearsBox.Text := '10';
InterestBox.Text := '10';
{InflationBox.Text := '0';}
end;

procedure TNestEggCalculatorFP_2012.CalcBtnClick(Sender: TObject);
Var i,Years:Integer;
    x,OpeningBalance,Amount,Interest,TaxRate,Inflation,EffectiveInterest :Real;
begin
 Amount := Vl(AmountBox.Text);
 Years := MyStrToInt(YearsBox.Text);
 If Years <1 then begin YearsBox.Text:='1'; Years:=1;end;
 Interest := Vl(InterestBox.Text);
 Inflation :=0;
 {Inflation := Vl(InflationBox.Text)/100;}
 TaxRate   := Vl(TaxRateBox.Text);

 EffectiveInterest := (Interest * (100-TaxRate)/100);
 x:=AnnuityPV(Amount,EffectiveInterest,Years);
 {Same result with option for withdrawal at beginning or end of period
 //EffectiveInterest := (Interest * (100-TaxRate)/100)/100;
 //x:=Math.PresentValue(EffectiveInterest,Years,-Amount,0,PtEndOfPeriod);
 }
 ResultBox.Text :=JustRight(FormatFloat('###,###,###.00',x),15);

end;

end.

