unit FP_2027mortgagecalculator;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,ExtCtrls;

type
  TMortgageCalculatorFP_2012 = class(TForm)
    PrincipalBox: TEdit;
    Label1: TLabel;
    InterestBox: TEdit;
    YearsBox: TEdit;
    PaymentBox: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    resultList: TListBox;
    CalcBtn: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    CancelBtn: TBitBtn;
    Label11: TLabel;
    Label12: TLabel;
    PrintBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    FindMinimumOptionBox: TCheckBox;
    Panel2: TPanel;
    Bevel3: TBevel;
    Label5: TLabel;
    Label10: TLabel;
    Label14: TLabel;
    TotInterestPaidBox: TEdit;
    Label15: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    procedure CalcBtnClick(Sender: TObject);
    function testforzero (n :double; s :String) :Boolean;
    procedure FormCreate(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DoIt;
    {Function  XToY(x,y:Double): Double;}
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MortgageCalculator: TMortgageCalculatorFP_2012;
  Principal :Double;
  Intrst  :Double;
  Period    :Integer;
  Pymnt   :Double;
  Balance   :Double;

implementation

uses FP_2027,FP_2027Declare,FP_2027TrimStr,vtTrimStr,vtShared;

 (*
 function testfun (n :double) :double; far; external 'Proj0002';
 function powerof (n :double; m :double) :double; far; external 'Proj0002';
 *)
 {function GetPassword(Password: string): Boolean;
  far; external 'CHKPWORD';}
{$R *.DFM}

procedure TMortgageCalculatorFP_2012.CalcBtnClick(Sender: TObject);
Var i:Integer;
    InputString:String;
    Principal:Real;Interest:Real;Years:Integer;
    Compounding:Integer;
    PeriodNoList,InterestPaidList,PrincipalPaidList,BalanceRemainingList:TStringList;
begin
  DoIt;

 (*
 InputString:=InputBox('Input Box', 'Compounding', '2');
 Compounding:=MyStrToInt(InputString);
 If Vl(InputString) >0 then
 begin
  Principal:=Vl(PrincipalBox.Text);
  Interest:=Vl(InterestBox.Text);
  Years:=StrToInt(YearsBox.Text);
  ShowMessage(FormatFloat('##,###,###.00',
   GetMonthyMortgage(Principal,Interest,Years,Compounding)));

  ResultList.Clear;
  PeriodNoList:=TStringList.Create;
  InterestPaidList:=TStringList.Create;
  PrincipalPaidList:=TStringList.Create;
  BalanceRemainingList:=TStringList.Create;
  GetMortgageTable(Principal,Interest,Years,PeriodNoList,
     InterestPaidList,PrincipalPaidList,BalanceRemainingList);

  For i:=0 to InterestPaidList.Count-1 do
  Begin
   ResultList.items.Add
    (PeriodNoList[i] + ' '
     +InterestPaidList[i] + ' '
     + PrincipalPaidList[i] + ' '
     + BalanceRemainingList[i]);
  end;
  PeriodNoList.Free;
  InterestPaidList.Free;
  PrincipalPaidList.Free;
  BalanceRemainingList.Free;
 end
 Else
  DoIt;
 *)
end;

procedure TMortgageCalculatorFP_2012.DoIt;
//mif = Monthly interest factor
var
 Code,i,Cnt,Year:Integer; SYear:string; //[3];
 mif,InterestPaid,PrincipalPaid,BalanceRemaining,Q,TotMonthly,TotInterestPaid:Double;
 S:String;
 Mstr,Istr, Pstr, Bstr,STotMonthly,STotInterestPaid:String [15];

begin
 If FindMinimumOptionBox.Checked then PaymentBox.text := '0';
 Val (InterestBox.Text, Intrst, Code );
 Period := MyStrToInt(YearsBox.Text)* 12;
 Val (PrincipalBox.Text, BalanceRemaining, Code);
 Val (PaymentBox.Text, Pymnt, Code);

 if (testforzero (intrst, 'Interest Rate')) then
 begin
  ShowMessage('Interest must be greater than zero');
  InterestBox.SetFocus;
  exit;
 end;

 if (testforzero (Period, 'Amortization Period')) then
 begin
  ShowMessage('Period must be greater than zero');
  YearsBox.SetFocus;
  exit;
 end;

 if (testforzero (BalanceRemaining, 'Principal')) then
 begin
  ShowMessage('Principal must be greater than zero');
  PrincipalBox.SetFocus;
  exit;
 end;

 mif := 1 + intrst/200;
 mif := XToY(mif,1/6)-1;

 if (testforzero (Pymnt, 'Monthly Payment')) then
 begin
  Q := (1/mif) * ( 1 - XToY ( (1+ intrst/200), - (Period/6)));
  Pymnt := BalanceRemaining / Q;
  Str(Pymnt:7:2, S);
  PaymentBox.Text := S;
 end;

 mif := 1 + intrst/200;
 mif := XToY(mif,1/6)-1;
 ResultList.Clear;

 TotInterestPaid:=0;

 Cnt:=0;Year:=1;
 for i := 1 to period do
 begin
   Inc(Cnt);
   If Cnt=12 then Begin Cnt:=0;end;//Inc(Year);end;
   SYear:=IntToStr(Year);
   InterestPaid := mif * BalanceRemaining;
   PrincipalPaid := Pymnt - InterestPaid;
   if PrincipalPaid <=0 then
   begin
   MessageDlg( 'Payment amount does not cover monthly interest required', mtError, [mbOk] , 0);
   exit;
   end;
   BalanceRemaining := BalanceRemaining - PrincipalPaid;
   If BalanceRemaining=-0 then BalanceRemaining:=0;

   TotInterestPaid:=TotInterestPaid+InterestPaid;
   Str (i:3, Mstr);
   Str(Year:3,SYear);
   iStr:=JustRight(PaddR(FormatFloat('###,###,###.00',InterestPaid),15),15);
   PStr:=JustRight(PaddR(FormatFloat('###,###,###.00',PrincipalPaid),15),15);;
   BStr:=JustRight(PaddR(FormatFloat('###,###,###.00',BalanceRemaining),15),15);;
   TotMonthly:=InterestPaid+PrincipalPaid;
   STotMonthly:=JustRight(PaddR(FormatFloat('###,###,###.00',TotMonthly),15),15);

   ResultList.items.Add (SYear+'   '+ Mstr + ' ' + Istr + ' ' + Pstr + STotMonthly
   +' '+ Bstr);
   if BalanceRemaining < -0.10 then
   begin
    MessageDlg( 'Mortgage paid off in '+
     FormatFloat('##0.00',i/12)+ ' years',
     mtError, [mbOk] , 0);
    exit;
   end;
   If Cnt=0 then Inc(Year);
 end; //i
 TotInterestPaidBox.Text:=FormatFloat('##,###,###.00',TotInterestPaid);
end;

function tMortgageCalculatorFP_2012.testforzero (n :double; s :String) :Boolean;
  begin
  if n <= 0 then
    result := true
  else
    result := false;
end;

procedure TMortgageCalculatorFP_2012.FormCreate(Sender: TObject);
begin
PrincipalBox.text := '100000';
InterestBox.Text  := '8';
YearsBox.text := '25';
PaymentBox.text := '0';
FindMinimumOptionBox.Checked:=True;
end;

procedure TMortgageCalculatorFP_2012.PrintBtnClick(Sender: TObject);
Var FileNm,Hdr1,Hdr2,Hdr3,s:string;Periods:Integer;
begin
 Periods:=MyStrToInt(YearsBox.Text) *12;
 If ResultList.Items.Count =0 then exit;
 s:= InputBox('', 'Enter report title (up to 50 characters)', 'Mortgage Amortization');
 Hdr1 := PaddR(S,60)+' '+PaddR(DateToMonthDayYear(Date),20);
 Hdr2 := '     Principal: '+FormatFloat('##,###,###.00',Vl(PrincipalBox.Text))+'    '
        +'Amortization Years: '+YearsBox.Text+'    '
        +'Payment periods: '+IntToStr(Periods)+'   '
        +'Interest '+InterestBox.Text+'%';
 Hdr3 := 'Year  Period(M)  Interest       Principal      Total monthly   Balance (Principle)';
 FileNm:=AppDir+'\'+'TempFile';
 ResultList.Items.SaveToFile(FileNm);
 If PrintDialog1.Execute then
 begin
  If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
   ShowMessage('Printing Completed');
 end;
end;

procedure TMortgageCalculatorFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

end.
