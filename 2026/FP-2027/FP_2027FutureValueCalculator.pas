unit FP_2027FutureValueCalculator;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls;

type
  TFutureValueCalculatorFP_2012 = class(TForm)
    CancelBtn: TBitBtn;
    CalcBtn: TBitBtn;
    Panel2: TPanel;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    AmountBox: TEdit;
    YearsBox: TEdit;
    InterestBox: TEdit;
    FutValBox: TEdit;
    Bevel1: TBevel;
    procedure CalcBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FutureValueCalculator: TFutureValueCalculatorFP_2012;

implementation

{$R *.DFM}

uses FP_2027TrimStr,vtTrimStr;

procedure TFutureValueCalculatorFP_2012.CalcBtnClick(Sender: TObject);
begin
If Vl(AmountBox.Text) =0 then
begin
ShowMessage('Please enter the Amount');
AmountBox.SetFocus;
exit;
end;

If Vl(YearsBox.Text) <1 then
begin
ShowMessage('Please enter the number of years');
YearsBox.SetFocus;
exit;
end;

If Vl(InterestBox.Text) =0 then
begin
ShowMessage('Please enter the interest rate');
InterestBox.SetFocus;
exit;
end;

FutValBox.Text :=
   FormatFloat('##,###,###.00',
   FutureValue(
   StrToFloat(AmountBox.Text),
   StrToFloat(InterestBox.Text),MyStrToInt(YearsBox.Text)));
end;

procedure TFutureValueCalculatorFP_2012.FormCreate(Sender: TObject);
begin
 AmountBox.Text := '10000';
 YearsBox.Text := '5';
 InterestBox.Text := '8';
end;

end.
