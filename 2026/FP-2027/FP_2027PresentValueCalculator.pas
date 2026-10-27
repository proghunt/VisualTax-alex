unit FP_2027PresentValueCalculator;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls;

type
  TPresentValueCalculatorFP_2012 = class(TForm)
    CancelBtn: TBitBtn;
    Panel1: TPanel;
    Label2: TLabel;
    AmountBox: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    YearsBox: TEdit;
    Label5: TLabel;
    CalcBtn: TBitBtn;
    InterestBox: TEdit;
    Label6: TLabel;
    Panel2: TPanel;
    Bevel3: TBevel;
    PresValBox: TEdit;
    procedure CalcBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PresentValueCalculator: TPresentValueCalculatorFP_2012;

implementation

{$R *.DFM}

uses FP_2027TrimStr,vtTrimStr;


procedure TPresentValueCalculatorFP_2012.CalcBtnClick(Sender: TObject);
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

PresValBox.Text :=
   FormatFloat('##,###,###.00',
   MyPresentValue(
   StrToFloat(AmountBox.Text),
   MyStrToInt(YearsBox.Text),
   StrToFloat(InterestBox.Text)));
end;

procedure TPresentValueCalculatorFP_2012.FormCreate(Sender: TObject);
begin
 AmountBox.Text := '10000';
 YearsBox.Text := '5';
 InterestBox.Text := '8';
end;

end.
