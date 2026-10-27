unit FP_2027InvestmentStrategy;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,Buttons,DB,FP_2027Declare,VCLTee.TeEngine,VCLTee.Series,
  VCLTee.TeeProcs,VCLTee.Chart,Grids,ComCtrls,Spin;  //20150819 Igor
  {UChart,USpevent,UChartAl;}

type
  TInvestmentStrategyFP_2012 = class(TForm)
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    NonShBfrTax: TEdit;
    NonShAftTax: TEdit;
    SheltBfrTax: TEdit;
    SheltAftTax: TEdit;
    SemShBfrTax: TEdit;
    SemShAftTax: TEdit;
    OtherBfrTax: TEdit;
    OtherAftTax: TEdit;
    NonShBtn: TSpinButton;
    SheltBtn: TSpinButton;
    SemShBtn: TSpinButton;
    OthBtn: TSpinButton;
    GroupBox2: TGroupBox;
    Label48: TLabel;
    Label49: TLabel;
    Label10: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label9: TLabel;
    Label13: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    NonShBalBox: TEdit;
    SheltBalBox: TEdit;
    SemShBalBox: TEdit;
    OtherBalBox: TEdit;
    TotValAtRetirementBox: TEdit;
    NonShCurBalBox: TEdit;
    SheltCurBalBox: TEdit;
    SemShCurBalBox: TEdit;
    OtherCurBalBox: TEdit;
    TotCurBalBox: TEdit;
    NonShEstateBox: TEdit;
    SheltEstateBox: TEdit;
    SemShEstateBox: TEdit;
    OtherEstateBox: TEdit;
    TotEstateValBox: TEdit;
    Label8: TLabel;
    Label25: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    NonShTotalBox: TEdit;
    SheltTotalBox: TEdit;
    SemShTotalBox: TEdit;
    OtherTotalBox: TEdit;
    Panel1: TPanel;
    Label21: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label26: TLabel;
    Label28: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label3: TLabel;
    Shape5: TShape;
    Label17: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Label4: TLabel;
    DispIncBox: TEdit;
    NonShAmountBox: TEdit;
    SheltAmountBox: TEdit;
    SemShAmountBox: TEdit;
    OtherAmountBox: TEdit;
    NonShPercentBox: TEdit;
    SheltPerCentBox: TEdit;
    SemShPercentBox: TEdit;
    OtherPercentBox: TEdit;
    SheltPercentBtn: TSpinButton;
    SemShPercentBtn: TSpinButton;
    OtherPercentBtn: TSpinButton;
    RRSProomBox: TEdit;
    InvestDisposableBox: TCheckBox;
    Panel3: TPanel;
    Label6: TLabel;
    Label1: TLabel;
    Label7: TLabel;
    Label22: TLabel;
    Label27: TLabel;
    Label35: TLabel;
    Shape6: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    TaxRefundBox: TEdit;
    NonShRefundAmountBox: TEdit;
    SheltRefundAmountBox: TEdit;
    SemShRefundAmountBox: TEdit;
    OtherRefundAmountBox: TEdit;
    NonShRefundPercentBox: TEdit;
    SheltRefundPercentBox: TEdit;
    SemShRefundPercentBox: TEdit;
    OtherRefundPercentBox: TEdit;
    SheltRefundPercentBtn: TSpinButton;
    SemShRefundPercentBtn: TSpinButton;
    OtherRefundPercentBtn: TSpinButton;
    InvestTaxRefundBox: TCheckBox;
    Label2: TLabel;
    CancelBtn: TBitBtn;

    {procedure ChartCurrAssets;}
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure RecalcBtnClick(Sender: TObject);
    procedure Recalc;
    procedure FetchEvents(RetNo:Integer);
    procedure StoreEvents(RetNo:Integer);
    Function CalcAmount(Tot,Percent:String):String;

    procedure FormPaint(Sender: TObject);
    Procedure ReviseAfterTaxBoxes;
    procedure MargRateBoxChange(Sender: TObject);
    procedure NonShBfrTaxChange(Sender: TObject);
    procedure SheltBfrTaxChange(Sender: TObject);
    procedure SemShBfrTaxChange(Sender: TObject);
    procedure OtherBfrTaxChange(Sender: TObject);
    procedure UpDownNonshClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownSemShClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownSheltClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownOtherClick(Sender: TObject; Button: TUDBtnType);
    procedure UpDownRetAgeChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure UpDownNonshChanging(Sender: TObject;
      var AllowChange: Boolean);

    procedure SpEventsBtnClick(Sender: TObject);
    procedure IncGoalBoxKeyPress(Sender: TObject; var Key: Char);

    procedure NonShBtnDownClick(Sender: TObject);
    procedure NonShBtnUpClick(Sender: TObject);
    procedure SheltBtnUpClick(Sender: TObject);
    procedure SheltBtnDownClick(Sender: TObject);
    procedure SemShBtnDownClick(Sender: TObject);
    procedure SemShBtnUpClick(Sender: TObject);
    procedure OthBtnDownClick(Sender: TObject);
    procedure OthBtnUpClick(Sender: TObject);
    Procedure ChartNonShBtnClick(Sender: TObject);
    procedure NonShPercentBtnDownClick(Sender: TObject);
    procedure NonShPercentBtnUpClick(Sender: TObject);
    procedure SheltPercentBtnUpClick(Sender: TObject);
    procedure SheltPercentBtnDownClick(Sender: TObject);
    procedure SemShPercentBtnDownClick(Sender: TObject);
    procedure SemShPercentBtnUpClick(Sender: TObject);
    procedure OtherPercentBtnDownClick(Sender: TObject);
    procedure OtherPercentBtnUpClick(Sender: TObject);
    procedure NonShRefundPercentBtnDownClick(Sender: TObject);
    procedure NonShRefundPercentBtnUpClick(Sender: TObject);
    procedure SheltRefundPercentBtnDownClick(Sender: TObject);
    procedure SheltRefundPercentBtnUpClick(Sender: TObject);
    procedure SemShRefundPercentBtnDownClick(Sender: TObject);
    procedure SemShRefundPercentBtnUpClick(Sender: TObject);
    procedure OtherRefundPercentBtnDownClick(Sender: TObject);
    procedure OtherRefundPercentBtnUpClick(Sender: TObject);
    Function EditDispIncAllocation(RetNo:Integer):Boolean;
    procedure DetScheduleBtnClick(Sender: TObject);
    procedure NonShCurBalBoxKeyPress(Sender: TObject; var Key: Char);
    procedure SheltCurBalBoxKeyPress(Sender: TObject; var Key: Char);
    procedure SemShCurBalBoxKeyPress(Sender: TObject; var Key: Char);
    procedure OtherCurBalBoxKeyPress(Sender: TObject; var Key: Char);
    procedure OtherCurBalBoxDblClick(Sender: TObject);
    procedure SheltCurBalBoxDblClick(Sender: TObject);
    procedure SemShCurBalBoxDblClick(Sender: TObject);
    procedure NonShCurBalBoxDblClick(Sender: TObject);
    procedure ShFallDiscountBoxChange(Sender: TObject);
    procedure RRSProomBoxKeyPress(Sender: TObject; var Key: Char);
    procedure SheltPerCentBoxExit(Sender: TObject);
    procedure SemShPercentBoxExit(Sender: TObject);
    procedure NonShBfrTaxKeyPress(Sender: TObject; var Key: Char);
    procedure SheltBfrTaxKeyPress(Sender: TObject; var Key: Char);
    procedure SemShBfrTaxKeyPress(Sender: TObject; var Key: Char);
    procedure SheltPerCentBoxChange(Sender: TObject);
    procedure SemShPercentBoxChange(Sender: TObject);
    procedure OtherPercentBoxChange(Sender: TObject);
    procedure SheltRefundPercentBoxChange(Sender: TObject);
    procedure SemShRefundPercentBoxChange(Sender: TObject);
    procedure OtherRefundPercentBoxChange(Sender: TObject);
    procedure ChartsBtnClick(Sender: TObject);
    procedure ObjectivesBtnClick(Sender: TObject);
    procedure InvestDisposableBoxClick(Sender: TObject);
    procedure InvestTaxRefundBoxClick(Sender: TObject);
  private

    { Private declarations }
  public
    RetNo: integer;
  end;

var
  InvestmentStrategy: TInvestmentStrategyFP_2012;
  TempCanvas :TBitMap;
  TotValAtRetirement,TotEstateVal,ValRequired,ShortFall :real;
  YearOrAge:Boolean;

implementation

{$R *.DFM}

uses
  vtCommon,
  FP_2027,FP_2027Trimstr,FP_2027Calc,FP_2027childwinNew,vtTrimStr,vtShared;

procedure TInvestmentStrategyFP_2012.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
   InvestDisposableBox.Checked:=True;
   InvestTaxRefundBox.Checked:=True;
   FormatSettings.DecimalSeparator:='.';   //20150819 Igor
   //PageControl1.Align := alClient;
   //PageControl1.ActivePage:=Tabsheet1;
   Caption :=Caption +ClientForCaption(RetNo);
   FetchEvents(RetNo);
   ReviseAfterTaxBoxes;
   //StoreEvents(RetNo);
   //Recalc;
end;

procedure TInvestmentStrategyFP_2012.CancelBtnClick(Sender: TObject);
begin
 CalcAll(RetNo);
 Close;
end;

procedure TInvestmentStrategyFP_2012.RecalcBtnClick(Sender: TObject);
begin
 Recalc;
end;

procedure TInvestmentStrategyFP_2012.Recalc;
Var i,FNo,MxPgNo:Integer;RetAge,UltimAge:Integer;

begin
 Screen.Cursor := crHourGlass;
 If Vl(NonShPercentBox.Text) >100 then NonShPercentBox.Text:='100';
 If Vl(SheltPercentBox.Text) >100 then SheltPercentBox.Text:='100';
 If Vl(SemShPercentBox.Text) >100 then SemShPercentBox.Text:='100';
 If Vl(OtherPercentBox.Text) >100 then OtherPercentBox.Text:='100';

 If Vl(NonShPercentBox.Text) <0 then NonShPercentBox.Text:='0';
 If Vl(SheltPercentBox.Text) <0 then SheltPercentBox.Text:='0';
 If Vl(SemShPercentBox.Text) <0 then SemShPercentBox.Text:='0';
 If Vl(OtherPercentBox.Text) <0 then OtherPercentBox.Text:='0';

 If Vl(SheltPercentBox.Text) > GetMaxSheltPercent(RetNo,GetRRSPLimit(RetNo),
   Vl(DispIncBox.Text)) then
   SheltPercentBox.Text := FormatFloat('###.00',GetMaxSheltPercent(
      RetNo,GetRRSPLimit(RetNo), Vl(DispIncBox.Text)));

 SheltAmountBox.text := CalcAmount(DispIncBox.text,SheltPercentBox.Text);
 SemShAmountBox.text := CalcAmount(DispIncBox.text,SemShPercentBox.Text);
 OtherAmountBox.text := CalcAmount(DispIncBox.text,OtherPercentBox.Text);

 NonShPercentBox.Text := FormatFloat('###.##',
   DeriveNonShPercent(RetNo,Vl(SheltPercentBox.Text),
   Vl(SemShPercentBox.Text),Vl(OtherPercentBox.Text)));
 NonShAmountBox.text := CalcAmount(DispIncBox.text,NonShPercentBox.Text);

 If InvestDisposableBox.Checked =False then
 begin
  NonShAmountBox.text :='0';
  SheltAmountBox.text :='0';
  SemShAmountBox.text :='0';
  OtherAmountBox.text :='0';
 end;
 {Tax refund}
 If Vl(NonShRefundPercentBox.Text) >100 then NonShRefundPercentBox.Text:='100';
 If Vl(SheltRefundPercentBox.Text) >100 then SheltRefundPercentBox.Text:='100';
 If Vl(SemShRefundPercentBox.Text) >100 then SemShRefundPercentBox.Text:='100';
 If Vl(OtherRefundPercentBox.Text) >100 then OtherRefundPercentBox.Text:='100';

 If Vl(NonShRefundPercentBox.Text) <0 then NonShRefundPercentBox.Text:='0';
 If Vl(SheltRefundPercentBox.Text) <0 then SheltRefundPercentBox.Text:='0';
 If Vl(SemShRefundPercentBox.Text) <0 then SemShRefundPercentBox.Text:='0';
 If Vl(OtherRefundPercentBox.Text) <0 then OtherRefundPercentBox.Text:='0';

 If Vl(SheltRefundPercentBox.Text) > GetMaxSheltRefundPercent(RetNo,GetRRSPLimit(RetNo),
   Vl(DispIncBox.Text),Vl(TaxRefundBox.Text),Vl(SheltAmountBox.Text)) then
   SheltRefundPercentBox.Text := FormatFloat('###.00',GetMaxSheltRefundPercent(RetNo,GetRRSPLimit(RetNo),
      Vl(DispIncBox.Text),Vl(TaxRefundBox.Text),Vl(SheltAmountBox.Text)));

 SheltRefundAmountBox.text := CalcAmount(TaxRefundBox.text,SheltRefundPercentBox.Text);
 SemShRefundAmountBox.text := CalcAmount(TaxRefundBox.text,SemShRefundPercentBox.Text);
 OtherRefundAmountBox.text := CalcAmount(TaxRefundBox.text,OtherRefundPercentBox.Text);

 NonShRefundPercentBox.Text := FormatFloat('###.00',
   DeriveNonShRefundPercent(RetNo,Vl(SheltRefundPercentBox.Text),
   Vl(SemShRefundPercentBox.Text),Vl(OtherRefundPercentBox.Text)));
 NonShRefundAmountBox.text := CalcAmount(TaxRefundBox.text,NonShRefundPercentBox.Text);

 If InvestTaxRefundBox.Checked = false then
 begin
   NonShRefundAmountBox.text := '0';
   SheltRefundAmountBox.text := '0';
   SemShRefundAmountBox.text := '0';
   OtherRefundAmountBox.text := '0';
 end;

 If EditDispIncAllocation(RetNo) =False then
  Begin
  ShowMessage('Check disposable income allocation');
  exit
  end;

 StoreEvents(RetNo);
 Calc(RetNo,'PACCUM');
 BuildInvDetailProjection(RetNo);

 RetAge:=ClientAgeAtRetirement(RetNo); {MyStrToInt(RetPlanner.RetAgeBox.Text);}
 NonShBalBox.Text := FormatFloat('##,###,##0',GetEndBalanceByAge(RetNo,RetAge,'PNONSH'));
 SheltBalBox.Text := FormatFloat('##,###,##0',GetEndBalanceByAge(RetNo,RetAge,'PSHELT'));
 SemShBalBox.Text := FormatFloat('##,###,##0',GetEndBalanceByAge(RetNo,RetAge,'PSEMSH'));
 OtherBalBox.Text := FormatFloat('##,###,##0',GetEndBalanceByAge(RetNo,RetAge,'POTHER'));
 TotValAtRetirementBox.Text := FormatFloat('##,###,##0',
              Vl(NonShBalBox.Text)+
              Vl(SheltBalBox.Text)+
              Vl(SemShBalBox.Text)+
              Vl(OtherBalBox.Text));

 NonShTotalBox.Text := FormatFloat('##,###,##0',Vl(NonShAmountBox.Text)+
                       vl(NonShRefundAmountBox.Text));
 SheltTotalBox.Text := FormatFloat('##,###,##0',Vl(SheltAmountBox.Text)+
                       vl(SheltRefundAmountBox.Text));
 SemShTotalBox.Text := FormatFloat('##,###,##0',Vl(SemShAmountBox.Text)+
                       vl(SemShRefundAmountBox.Text));
 OtherTotalBox.Text := FormatFloat('##,###,##0',Vl(OtherAmountBox.Text)+
                       vl(OtherRefundAmountBox.Text));


 UltimAge:= ClientUltimateAge(RetNo);
 NonShEstateBox.Text := FormatFloat('##,###,##0',GetEndBalanceByAge(RetNo,UltimAge,'PNONSH'));
 SheltEstateBox.Text := FormatFloat('##,###,##0',GetEndBalanceByAge(RetNo,UltimAge,'PSHELT'));
 SemShEstateBox.Text := FormatFloat('##,###,##0',GetEndBalanceByAge(RetNo,UltimAge,'PSEMSH'));
 OtherEstateBox.Text := FormatFloat('##,###,##0',GetEndBalanceByAge(RetNo,UltimAge,'POTHER'));
 TotEstateValBox.Text := FormatFloat('##,###,##0',
              Vl(NonShEstateBox.Text)+
              Vl(SheltEstateBox.Text)+
              Vl(SemShEstateBox.Text)+
              Vl(OtherEstateBox.Text));

 Screen.Cursor := crDefault;
end;


procedure TInvestmentStrategyFP_2012.FormPaint(Sender: TObject);
begin
 If vl(NonShBalBox.Text) <0 then NonShBalBox.Color := clRed else NonShBalBox.Color := clWhite;
 If vl(SheltBalBox.Text) <0 then SheltBalBox.Color := clRed else SheltBalBox.Color := clWhite;
 If vl(SemShBalBox.Text) <0 then SemShBalBox.Color := clRed else SemShBalBox.Color := clWhite;
 If vl(OtherBalBox.Text) <0 then OtherBalBox.Color := clRed else OtherBalBox.Color := clWhite;

 If vl(NonShEstateBox.Text) <0 then NonShEstateBox.Color := clRed else NonShEstateBox.Color := clWhite;
 If vl(SheltEstateBox.Text) <0 then SheltEstateBox.Color := clRed else SheltEstateBox.Color := clWhite;
 If vl(SemShEstateBox.Text) <0 then SemShEstateBox.Color := clRed else SemShEstateBox.Color := clWhite;
 If vl(OtherEstateBox.Text) <0 then OtherEstateBox.Color := clRed else OtherEstateBox.Color := clWhite;
 If vl(TotEstateValBox.Text) <0 then TotEstateValBox.Color := clRed else TotEstateValBox.Color := clWhite;

 If vl(TotValAtRetirementBox.Text) <0 then TotValAtRetirementBox.Color := clRed
   else TotValAtRetirementBox.Color := clWhite;
end;

Procedure TInvestmentStrategyFP_2012.ReviseAfterTaxBoxes;
begin
 NonShAftTax.Text := FormatFloat('##0.00',AfterTaxReturn(Vl(NonShBfrTax.Text),GetMargRate(RetNo)));
 SheltAftTax.Text := SheltBfrTax.Text;
 SEmShAftTax.Text := FormatFloat('##0.00',AfterTaxReturn(Vl(SemShBfrTax.Text),GetMargRate(RetNo)*0.75));
 OtherAftTax.Text := FormatFloat('##0.00',AfterTaxReturn(Vl(OtherBfrTax.Text),GetMargRate(RetNo)));
end;

procedure TInvestmentStrategyFP_2012.MargRateBoxChange(Sender: TObject);
begin
 ReviseAfterTaxBoxes;
end;

procedure TInvestmentStrategyFP_2012.NonShBfrTaxChange(Sender: TObject);
begin
 ReviseAfterTaxBoxes;
end;

procedure TInvestmentStrategyFP_2012.SheltBfrTaxChange(Sender: TObject);
begin
 ReviseAfterTaxBoxes;
end;

procedure TInvestmentStrategyFP_2012.SemShBfrTaxChange(Sender: TObject);
begin
 ReviseAfterTaxBoxes;
end;

procedure TInvestmentStrategyFP_2012.OtherBfrTaxChange(Sender: TObject);
begin
 ReviseAfterTaxBoxes;
end;

procedure TInvestmentStrategyFP_2012.FetchEvents(RetNo:Integer);
Var RowNo,FNo,Elm:integer;
begin
 If RetNo<1 then exit;
 {IncGoalBox.Text  := FormatFloat('##,###,##0',GetDesiredRetirementIncome(RetNo));}
  (*
  If AllTrim(NonShBfrTax.Text)='' then NonShBfrTax.Text :=
       FetchElm(RetNo,'ASSUME',15); //DefaultNonShInterest;
  If AllTrim(SheltBfrTax.Text)='' then SheltBfrTax.Text :=
      FetchElm(RetNo,'ASSUME',16); //DefaultSheltInterest;
  If AllTrim(SemShBfrTax.Text)='' then SemShBfrTax.Text :=
      FetchElm(RetNo,'ASSUME',17); //DefaultSemShInterest;
  If AllTrim(OtherBfrTax.Text)='' then OtherBfrTax.Text :=
      FetchElm(RetNo,'ASSUME',18); //DefaultOtherInterest;
  *)
  FNo := GetFormNo('RETPLAN');
  RRSPRoomBox.Text :=FormatFloat('##,###,##0',GetRRSPLimit(RetNo));

  NonShBfrTax.Text :=AllTrim(FetchElmFNo(RetNo,FNo,45)); {Non sh % bftax}
  NonShAftTax.Text :=AllTrim(FetchElmFNo(RetNo,FNo,55)); {Non sh % afttax}

  SheltBfrTax.Text :=AllTrim(FetchElmFNo(RetNo,FNo,46)); {Sheltered %}
  SheltAftTax.Text :=FetchElmFNo(RetNo,FNo,56); {Sheltered %}

  SemShBfrTax.Text :=AllTrim(FetchElmFNo(RetNo,FNo,47)); {Semi-sh %}
  SemShAftTax.Text :=AllTrim(FetchElmFNo(RetNo,FNo,57)); {Sheltered % aft tax}

  OtherBfrTax.Text :=AllTrim(FetchElmFNo(RetNo,FNo,48)); {other %}
  OtherAftTax.Text :=AllTrim(FetchElmFNo(RetNo,FNo,58)); {other % aftr tax}

  DispIncBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,23)));
  TaxRefundBox.Text := FormatFloat('##,###,###.00',Vl(FetchElmFNo(RetNo,FNo,28)));

  NonShAmountBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,19)));
  SheltAmountBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,20)));
  SemShAmountBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,22)));
  OtherAmountBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,21)));

  {ShFallDiscountBox.Text := FetchElmFNo(RetNo,FNo,53);} {oes not work???}
  {calc %}
  If Vl(DispIncBox.Text) >0 then
  begin
  NonShPercentBox.Text := FormatFloat('##,###,##0',
       Vl(NonShAmountBox.Text)*100/Vl(DispIncBox.Text));
  SheltPercentBox.Text := FormatFloat('##,###,##0',
     Vl(SheltAmountBox.Text)*100/Vl(DispIncBox.Text));
  SemShPercentBox.Text := FormatFloat('##,###,##0',
     Vl(SemShAmountBox.Text)*100/Vl(DispIncBox.Text));
  OtherPercentBox.Text := FormatFloat('##,###,##0',
     Vl(OtherAmountBox.Text)*100/Vl(DispIncBox.Text));
  end
  else
  begin
   NonShPercentBox.Text := '0';
  SheltPercentBox.Text := '0';
  SemShPercentBox.Text := '0';
  OtherPercentBox.Text := '0';
  end;

  NonShRefundAmountBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,24)));
  SheltRefundAmountBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,25)));
  SemShRefundAmountBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,27)));
  OtherRefundAmountBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,26)));

  If Vl(TaxRefundBox.Text) <> 0 then
  begin
  NonShRefundPercentBox.Text := FormatFloat('##,###,##0',
     Vl(NonShRefundAmountBox.Text)*100/Vl(TaxRefundBox.Text));
  SheltRefundPercentBox.Text := FormatFloat('##,###,##0',
     Vl(SheltRefundAmountBox.Text)*100/Vl(TaxRefundBox.Text));
  SemShRefundPercentBox.Text := FormatFloat('##,###,##0',
    Vl(SemShRefundAmountBox.Text)*100/Vl(TaxRefundBox.Text));
  OtherRefundPercentBox.Text := FormatFloat('##,###,##0',
    Vl(OtherRefundAmountBox.Text)*100/Vl(TaxRefundBox.Text));
  end
  else
  begin
   NonShRefundPercentBox.Text := '0';
   SheltRefundPercentBox.Text := '0';
   SemShRefundPercentBox.Text := '0';
   OtherRefundPercentBox.Text := '0';
  end;

  NonShCurBalBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,14)));
  SheltCurBalBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,15)));
  SemShCurBalBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,17)));
  OtherCurBalBox.Text := FormatFloat('##,###,##0',Vl(FetchElmFNo(RetNo,FNo,16)));
  TotCurBalBox.Text := FormatFloat('##,###,##0',
              Vl(NonShCurBalBox.Text)+
              Vl(SheltCurBalBox.Text)+
              Vl(SemShCurBalBox.Text)+
              Vl(OtherCurBalBox.Text));
end;

procedure TInvestmentStrategyFP_2012.StoreEvents(RetNo:Integer);
Var RowNo,FNo,Elm:integer;
begin
 (*
 FNo := GetFormNo('ASSUME');
 StoreElm(RetNo,FNo,15,AllTrim(NonShBfrTax.Text));
 StoreElm(RetNo,FNo,16,AllTrim(SheltBfrTax.Text));
 StoreElm(RetNo,FNo,17,AllTrim(SemShBfrTax.Text));
 StoreElm(RetNo,FNo,18,AllTrim(OtherBfrTax.Text));
 *)
 FNo := GetFormNo('RETPLAN');
 StoreElm(RetNo,FNo,45,AllTrim(NonShBfrTax.Text)); {Non sh % bftax}
 StoreElm(RetNo,FNo,55,AllTrim(NonShAftTax.Text)); {Non sh % afttax}

 StoreElm(RetNo,FNo,46,AllTrim(SheltBfrTax.Text)); {Sheltered %}
 StoreElm(RetNo,FNo,56,AllTrim(SheltAftTax.Text)); {Sheltered %}

 StoreElm(RetNo,FNo,47,AllTrim(SemShBfrTax.Text)); {Semi-sh %}
 StoreElm(RetNo,FNo,57,AllTrim(SemShAftTax.Text)); {semi Sheltered % aft tax}

 StoreElm(RetNo,FNo,48,AllTrim(OtherBfrTax.Text)); {other %}
 StoreElm(RetNo,FNo,58,AllTrim(OtherAftTax.Text)); {other % aftr tax}

  StoreElm(RetNo,FNo,19,NonShAmountBox.Text);
  StoreElm(RetNo,FNo,20,SheltAmountBox.Text);
  StoreElm(RetNo,FNo,22,SemShAmountBox.Text);
  StoreElm(RetNo,FNo,21,OtherAmountBox.Text);

  StoreElm(RetNo,FNo,24,NonShRefundAmountBox.Text);
  StoreElm(RetNo,FNo,25,SheltRefundAmountBox.Text);
  StoreElm(RetNo,FNo,27,SemShRefundAmountBox.Text);
  StoreElm(RetNo,FNo,26,OtherRefundAmountBox.Text);

  Calc(RetNo,'RETPLAN');
end;

procedure TInvestmentStrategyFP_2012.UpDownNonshClick(Sender: TObject; Button: TUDBtnType);
begin
ReviseAfterTaxBoxes;
end;

procedure TInvestmentStrategyFP_2012.UpDownSemShClick(Sender: TObject; Button: TUDBtnType);
begin
ReviseAfterTaxBoxes;
end;

procedure TInvestmentStrategyFP_2012.UpDownSheltClick(Sender: TObject; Button: TUDBtnType);
begin
ReviseAfterTaxBoxes;
end;

procedure TInvestmentStrategyFP_2012.UpDownOtherClick(Sender: TObject; Button: TUDBtnType);
begin
ReviseAfterTaxBoxes;
end;

procedure TInvestmentStrategyFP_2012.UpDownRetAgeChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
 AllowChange:=True;
end;

procedure TInvestmentStrategyFP_2012.UpDownNonshChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
AllowChange :=True;
end;

procedure TInvestmentStrategyFP_2012.SpEventsBtnClick(Sender: TObject);
begin
 {
 Application.CreateForm(TSpEvents, SpEvents);
 SpEvents.ShowModal;
 SpEvents.Free;
 }
end;

procedure TInvestmentStrategyFP_2012.IncGoalBoxKeyPress(Sender: TObject; var Key: Char);
begin
{ShowMessage('You can change it only on the Disposable Income form');}
Key:= Chr(0);
CancelBtnClick(Sender);
OpenForm(RetNo,GetFormNo('INVESTSTRATEGY'),0);
end;

procedure TInvestmentStrategyFP_2012.NonShBtnDownClick(Sender: TObject);
begin
NonShBfrTax.Text := FormatFloat('###.00',(Vl(NonShBfrTax.Text) -1));
If Vl(NonShBfrTax.Text) <0 then NonShBfrTax.Text:='0';
Recalc;
end;

procedure TInvestmentStrategyFP_2012.NonShBtnUpClick(Sender: TObject);
begin
NonShBfrTax.Text := FormatFloat('###.00',(Vl(NonShBfrTax.Text) +1));
Recalc;
end;

procedure TInvestmentStrategyFP_2012.SheltBtnUpClick(Sender: TObject);
begin
SheltBfrTax.Text := FormatFloat('###.00',(Vl(SheltBfrTax.Text) +1));
Recalc;
end;

procedure TInvestmentStrategyFP_2012.SheltBtnDownClick(Sender: TObject);
begin
SheltBfrTax.Text := FormatFloat('###.00',(Vl(SheltBfrTax.Text) -1));
If Vl(SheltBfrTax.Text) <0 then SheltBfrTax.Text:='0';
Recalc;
end;

procedure TInvestmentStrategyFP_2012.SemShBtnDownClick(Sender: TObject);
begin
SemShBfrTax.Text := FormatFloat('###.00',(Vl(SemShBfrTax.Text) -1));
If Vl(SemShBfrTax.Text) <0 then SemShBfrTax.Text:='0';
Recalc;
end;

procedure TInvestmentStrategyFP_2012.SemShBtnUpClick(Sender: TObject);
begin
SemShBfrTax.Text := FormatFloat('###.00',(Vl(SemShBfrTax.Text) +1));
Recalc;
end;

procedure TInvestmentStrategyFP_2012.OthBtnDownClick(Sender: TObject);
begin
OtherBfrTax.Text := FormatFloat('###.00',(Vl(OtherBfrTax.Text) -1));
If Vl(OtherBfrTax.Text) <0 then OtherBfrTax.Text:='0';
Recalc;
end;

procedure TInvestmentStrategyFP_2012.OthBtnUpClick(Sender: TObject);
begin
OtherBfrTax.Text := FormatFloat('###.00',(Vl(OtherBfrTax.Text) +1));
Recalc;
end;


procedure TInvestmentStrategyFP_2012.ChartNonShBtnClick(Sender: TObject);
begin
 {
 Application.CreateForm(TChartAll,ChartAll);
 ChartAll.ShowModal;
 ChartAll.Free;
 }
 {
 Application.CreateForm(TChartFrm, ChartFrm);
 ChartFrm.ShowModal;
 ChartFrm.Free;
 }
end;




procedure TInvestmentStrategyFP_2012.NonShPercentBtnDownClick(Sender: TObject);
begin
NonShPercentBox.Text := FormatFloat('###.00',(Vl(NonShPercentBox.Text) -1));
If Vl(NonShPercentBox.Text) <0 then NonShPercentBox.Text:='0';

Recalc;
end;

procedure TInvestmentStrategyFP_2012.NonShPercentBtnUpClick(Sender: TObject);
begin
NonShPercentBox.Text := FormatFloat('###.00',(Vl(NonShPercentBox.Text) +1));
Recalc;
end;

procedure TInvestmentStrategyFP_2012.SheltPercentBtnUpClick(Sender: TObject);
begin
If Vl(SheltPercentBox.Text) < GetMaxSheltPercent(RetNo,GetRRSPLimit(RetNo),
   Vl(DispIncBox.Text)) then
 begin
 SheltPercentBox.Text := FormatFloat('###.00',(Vl(SheltPercentBox.Text) +1));
 Recalc;
 end
 else
 begin
   ShowMessage('Cannot allocate more than the RRSP contribution room');
 end;
end;

procedure TInvestmentStrategyFP_2012.SheltPercentBtnDownClick(Sender: TObject);
begin
SheltPercentBox.Text := FormatFloat('###.00',(Vl(SheltPercentBox.Text) -1));
If Vl(SheltPercentBox.Text) <0 then SheltPercentBox.Text:='0';
Recalc;
end;

procedure TInvestmentStrategyFP_2012.SemShPercentBtnDownClick(Sender: TObject);
begin
SEmShPercentBox.Text := FormatFloat('###.00',(Vl(SemShPercentBox.Text) -1));
If Vl(SEmShPercentBox.Text) <0 then SemShPercentBox.Text:='0';
Recalc;
end;

procedure TInvestmentStrategyFP_2012.SemShPercentBtnUpClick(Sender: TObject);
begin
SEmShPercentBox.Text := FormatFloat('###.00',(Vl(SemShPercentBox.Text) +1));
Recalc;
end;

procedure TInvestmentStrategyFP_2012.OtherPercentBtnDownClick(Sender: TObject);
begin
OtherPercentBox.Text := FormatFloat('###.00',(Vl(OtherPercentBox.Text) -1));
If Vl(OtherPercentBox.Text) <0 then OtherPercentBox.Text:='0';

Recalc;
end;

procedure TInvestmentStrategyFP_2012.OtherPercentBtnUpClick(Sender: TObject);
begin
OtherPercentBox.Text := FormatFloat('###.00',(Vl(OtherPercentBox.Text) +1));
Recalc;
end;

procedure TInvestmentStrategyFP_2012.NonShRefundPercentBtnDownClick(Sender: TObject);
begin
NonShRefundPercentBox.Text := FormatFloat('###.00',(Vl(NonShRefundPercentBox.Text) -1));
If Vl(NonShRefundPercentBox.Text) <0 then NonShRefundPercentBox.Text:='0';
Recalc;
end;

procedure TInvestmentStrategyFP_2012.NonShRefundPercentBtnUpClick(Sender: TObject);
begin
NonShRefundPercentBox.Text := FormatFloat('###.00',(Vl(NonShRefundPercentBox.Text) +1));

Recalc;
end;

procedure TInvestmentStrategyFP_2012.SheltRefundPercentBtnDownClick(Sender: TObject);
begin
SheltRefundPercentBox.Text := FormatFloat('###.00',(Vl(SheltRefundPercentBox.Text) -1));
If Vl(SheltRefundPercentBox.Text) <0 then SheltRefundPercentBox.Text:='0';
Recalc;
end;

procedure TInvestmentStrategyFP_2012.SheltRefundPercentBtnUpClick(Sender: TObject);
begin
SheltRefundPercentBox.Text := FormatFloat('###.00',(Vl(SheltRefundPercentBox.Text) +1));
Recalc;
end;

procedure TInvestmentStrategyFP_2012.SemShRefundPercentBtnDownClick(Sender: TObject);
begin
SEmShRefundPercentBox.Text := FormatFloat('###.00',(Vl(SemShRefundPercentBox.Text) -1));
If Vl(SemShRefundPercentBox.Text) <0 then SemShRefundPercentBox.Text:='0';
Recalc;
end;

procedure TInvestmentStrategyFP_2012.SemShRefundPercentBtnUpClick(Sender: TObject);
begin
SEmShRefundPercentBox.Text := FormatFloat('###.00',(Vl(SemShRefundPercentBox.Text) +1));
Recalc;
end;

procedure TInvestmentStrategyFP_2012.OtherRefundPercentBtnDownClick(Sender: TObject);
begin
OtherRefundPercentBox.Text := FormatFloat('###.00',(Vl(OtherRefundPercentBox.Text) -1));
If Vl(OtherRefundPercentBox.Text) <0 then OtherRefundPercentBox.Text:='0';
Recalc;
end;

procedure TInvestmentStrategyFP_2012.OtherRefundPercentBtnUpClick(Sender: TObject);
begin
OtherRefundPercentBox.Text := FormatFloat('###.00',(Vl(OtherRefundPercentBox.Text) +1));
Recalc;
end;

Function TInvestmentStrategyFP_2012.CalcAmount(Tot,Percent:String):String;
begin
 result := FormatFloat('##,###,###',(Vl(Tot) * Vl(Percent))/100);
end;


Function TInvestmentStrategyFP_2012.EditDispIncAllocation(RetNo:Integer):Boolean;
begin
  result :=true;

end;


procedure TInvestmentStrategyFP_2012.DetScheduleBtnClick(Sender: TObject);
begin
 Close;
 OpenForm(RetNo,GetFormNo('PNONSH#1'),0);
end;

procedure TInvestmentStrategyFP_2012.NonShCurBalBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
close;
OpenForm(RetNo,GetFormNo('BALSHT'),0);
end;

procedure TInvestmentStrategyFP_2012.SheltCurBalBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
close;
OpenForm(RetNo,GetFormNo('BALSHT'),0);
end;

procedure TInvestmentStrategyFP_2012.SemShCurBalBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
close;
OpenForm(RetNo,GetFormNo('BALSHT'),0);
end;

procedure TInvestmentStrategyFP_2012.OtherCurBalBoxKeyPress(Sender: TObject;
  var Key: Char);
begin
close;
OpenForm(RetNo,GetFormNo('BALSHT'),0);
end;

procedure TInvestmentStrategyFP_2012.OtherCurBalBoxDblClick(Sender: TObject);
begin
close;
OpenForm(RetNo,GetFormNo('BALSHT'),0);
end;

procedure TInvestmentStrategyFP_2012.SheltCurBalBoxDblClick(Sender: TObject);
begin
close;
OpenForm(RetNo,GetFormNo('BALSHT'),0);
end;

procedure TInvestmentStrategyFP_2012.SemShCurBalBoxDblClick(Sender: TObject);
begin
close;
OpenForm(RetNo,GetFormNo('BALSHT'),0);
end;

procedure TInvestmentStrategyFP_2012.NonShCurBalBoxDblClick(Sender: TObject);
begin
close;
OpenForm(RetNo,GetFormNo('BALSHT'),0);
end;

procedure TInvestmentStrategyFP_2012.ShFallDiscountBoxChange(Sender: TObject);
begin
Recalc;
end;

procedure TInvestmentStrategyFP_2012.RRSProomBoxKeyPress(Sender: TObject; var Key: Char);
begin
ShowMessage('You can change it only on the DispInc form');
end;

procedure TInvestmentStrategyFP_2012.SheltPerCentBoxExit(Sender: TObject);
begin
recalc;
end;

procedure TInvestmentStrategyFP_2012.SemShPercentBoxExit(Sender: TObject);
begin
recalc;
end;

procedure TInvestmentStrategyFP_2012.NonShBfrTaxKeyPress(Sender: TObject; var Key: Char);
begin
recalc;
end;

procedure TInvestmentStrategyFP_2012.SheltBfrTaxKeyPress(Sender: TObject; var Key: Char);
begin
recalc
end;

procedure TInvestmentStrategyFP_2012.SemShBfrTaxKeyPress(Sender: TObject; var Key: Char);
begin
recalc;
end;

procedure TInvestmentStrategyFP_2012.SheltPerCentBoxChange(Sender: TObject);
begin
recalc;
end;

procedure TInvestmentStrategyFP_2012.SemShPercentBoxChange(Sender: TObject);
begin
recalc;
end;

procedure TInvestmentStrategyFP_2012.OtherPercentBoxChange(Sender: TObject);
begin
recalc;
end;

procedure TInvestmentStrategyFP_2012.SheltRefundPercentBoxChange(Sender: TObject);
begin
recalc;
end;

procedure TInvestmentStrategyFP_2012.SemShRefundPercentBoxChange(Sender: TObject);
begin
recalc;
end;

procedure TInvestmentStrategyFP_2012.OtherRefundPercentBoxChange(Sender: TObject);
begin
recalc;
end;

procedure TInvestmentStrategyFP_2012.ChartsBtnClick(Sender: TObject);
begin
//ExecuteForm(TRetirementCharts);
end;

procedure TInvestmentStrategyFP_2012.ObjectivesBtnClick(Sender: TObject);
begin
//ExecuteForm(TObjectives);
end;

procedure TInvestmentStrategyFP_2012.InvestDisposableBoxClick(Sender: TObject);
begin
Recalc;
end;

procedure TInvestmentStrategyFP_2012.InvestTaxRefundBoxClick(Sender: TObject);
begin
Recalc;
end;

end.
