unit FP_2027objectives;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,ExtCtrls,Buttons,DB,VCLTee.TeEngine,VCLTee.Series,
  VCLTee.TeeProcs,VCLTee.Chart,Grids,ComCtrls,Spin;
  {UChart,USpevent,UChartAl,URetStrg;}
type
  TObjectivesFP_2012 = class(TForm)
    Panel1: TPanel;
    CancelBtn: TBitBtn;
    Panel2: TPanel;
    GroupBox2: TGroupBox;
    Label20: TLabel;
    Label30: TLabel;
    Label9: TLabel;
    Label50: TLabel;
    RetAgeBox: TEdit;
    IncGoalBox: TEdit;
    AgeBtn: TSpinButton;
    SpRetAgeBox: TEdit;
    SpAgeBtn: TSpinButton;
    PlanAgeBox: TEdit;
    PlanAgeBtn: TSpinButton;
    GroupBox1: TGroupBox;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label47: TLabel;
    SafetyBox: TComboBox;
    CashFlowBox: TComboBox;
    AppreciationBox: TComboBox;
    TaxBenefitsBox: TComboBox;
    LiquidityBox: TComboBox;
    DebtBox: TComboBox;
    RiskReturnBox: TComboBox;
    MgtEffortBox: TComboBox;
    GroupBox4: TGroupBox;
    RiskToleranceBox: TRadioGroup;
    Label1: TLabel;

    {procedure ChartCurrAssets;}
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure UpDownRetAgeChanging(Sender: TObject; var AllowChange: Boolean);

   { procedure SpEventsBtnClick(Sender: TObject);}
    procedure IncGoalBoxKeyPress(Sender: TObject; var Key: Char);
    procedure IncGoalBoxDblClick(Sender: TObject);
    procedure AgeBtnDownClick(Sender: TObject);
    procedure AgeBtnUpClick(Sender: TObject);
    procedure SpAgeBtnDownClick(Sender: TObject);
    procedure SpAgeBtnUpClick(Sender: TObject);
    procedure PlanAgeBtnDownClick(Sender: TObject);
    {procedure ChartNonShBtnClick(Sender: TObject);}
    procedure PlanAgeBtnUpClick(Sender: TObject);
    procedure StoreData(RetNo:Integer);
    procedure FetchData(RetNo:Integer);
  private

    { Private declarations }
  public
    RetNo: integer;
  end;

var
  Objectives: TObjectivesFP_2012;
  TempCanvas :TBitMap;
  TotValAtRetirement,ValRequired,ShortFall :real;
  YearOrAge:Boolean;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027Declare,FP_2027Trimstr,FP_2027Calc,
  FP_2027childwinNew,FP_2027Common2,vtTrimStr,vtShared;


procedure TObjectivesFP_2012.FormCreate(Sender: TObject);
Var FNo:Integer;
begin
  RetNo := GetCurrentRetNo;
 Caption :=Caption +ClientForCaption(RetNo);
 FetchData(RetNo);
end;


procedure TObjectivesFP_2012.CancelBtnClick(Sender: TObject);
begin
 StoreData(RetNo);
 CalcAll(RetNo);
 Close;
end;

procedure TObjectivesFP_2012.UpDownRetAgeChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
 AllowChange:=True;
end;

procedure TObjectivesFP_2012.IncGoalBoxKeyPress(Sender: TObject; var Key: Char);
begin
 StoreData(RetNo);
 close;
 OpenForm(RetNo,GetFormNo('LIVINGEXP_1'),0);
end;

procedure TObjectivesFP_2012.IncGoalBoxDblClick(Sender: TObject);
begin
 StoreData(RetNo);
 close;
 OpenForm(RetNo,GetFormNo('LIVINGEXP_1'),0);
end;


procedure TObjectivesFP_2012.AgeBtnDownClick(Sender: TObject);
begin
RetAgeBox.Text := IntToStr(MyStrToInt(RetAgeBox.Text) -1);
If Vl(RetAgeBox.Text) <ClientAge(RetNo) then
  RetAgeBox.Text:=IntToStr(ClientAge(RetNo));
end;

procedure TObjectivesFP_2012.AgeBtnUpClick(Sender: TObject);
begin
RetAgeBox.Text := IntToStr(MyStrToInt(RetAgeBox.Text) +1);
If Vl(RetAgeBox.Text) >ClientUltimateAge(RetNo) then
  RetAgeBox.Text:=IntToStr(ClientUltimateAge(RetNo));
end;

procedure TObjectivesFP_2012.SpAgeBtnDownClick(Sender: TObject);
begin
SpRetAgeBox.Text := IntToStr(MyStrToInt(SpRetAgeBox.Text) -1);
If Vl(SpRetAgeBox.Text) <SpouseAge(RetNo) then
  SpRetAgeBox.Text:=IntToStr(SpouseAge(RetNo));
end;

procedure TObjectivesFP_2012.SpAgeBtnUpClick(Sender: TObject);
begin
SpRetAgeBox.Text := IntToStr(MyStrToInt(SpretAgeBox.Text) +1);
If Vl(SpRetAgeBox.Text) >SpouseUltimateAge(RetNo) then
  SpRetAgeBox.Text:=IntToStr(SpouseUltimateAge(RetNo));
end;

procedure TObjectivesFP_2012.PlanAgeBtnDownClick(Sender: TObject);
begin
PlanAgeBox.Text := IntToStr(MyStrToInt(PlanAgeBox.Text) -1);
If Vl(PlanAgeBox.Text) <Vl(RetAgeBox.Text) then
  PlanAgeBox.Text:=RetAgeBox.Text;
end;

procedure TObjectivesFP_2012.PlanAgeBtnUpClick(Sender: TObject);
begin
PlanAgeBox.Text := IntToStr(MyStrToInt(PlanAgeBox.Text) +1);

If Vl(PlanAgeBox.Text) >110 then
  PlanAgeBox.Text:=IntToStr(110);
end;


procedure TObjectivesFP_2012.FetchData(RetNo:Integer);
Var RowNo,FNo,Elm:integer;
begin
 If RetNo<1 then exit;

 FNo:=GetFormNo('RETPLAN');
 RetAgeBox.Text :=FetchElmFNo(RetNo,FNo,6);
 SpRetAgeBox.Text :=FetchElmFNo(RetNo,FNo,7);
 PlanAgeBox.Text := FetchElmFNo(RetNo,FNo,8);
 IncGoalBox.Text  :=
    FormatFloat('##,###,##0',GetDesiredRetirementIncome(RetNo));

 FNo := GetFormNo('INVESTSTRATEGY');
 SafetyBox.Text := FetchElmFNo(RetNo,FNo,30);
 CashFlowBox.Text := FetchElmFNo(RetNo,FNo,31);
 AppreciationBox.Text := FetchElmFNo(RetNo,FNo,32);
 TaxBenefitsBox.Text := FetchElmFNo(RetNo,FNo,33);
 LiquidityBox.Text := FetchElmFNo(RetNo,FNo,34);
 DebtBox.Text := FetchElmFNo(RetNo,FNo,46);
 RiskReturnBox.Text := FetchElmFNo(RetNo,FNo,35);
 MgtEffortBox.Text := FetchElmFNo(RetNo,FNo,36);
 If FetchElmFNo(RetNo,FNo,52) >'' then
  RiskToleranceBox.ItemIndex := 0
 else If FetchElmFNo(RetNo,FNo,53) >'' then
  RiskToleranceBox.ItemIndex := 1
 else If FetchElmFNo(RetNo,FNo,54) >'' then
  RiskToleranceBox.ItemIndex := 2;

end;

procedure TObjectivesFP_2012.StoreData(RetNo:Integer);
Var RowNo,FNo,Elm:integer;
begin
 FNo:=GetFormNo('RETPLAN');
 if Ret[RetNo].Frm[Fno].Count = 0 then InitFormData(RetNo,FNo);
 StoreElm(RetNo,FNo,6,RetAgeBox.Text);
 StoreElm(RetNo,FNo,7,SpRetAgeBox.Text);
 StoreElm(RetNo,FNo,8,PlanAgeBox.Text);
 Calc(RetNo,'RETPLAN');

 FNo := GetFormNo('INVESTSTRATEGY');
 if Ret[RetNo].Frm[Fno].Count = 0 then InitFormData(RetNo,FNo);
 StoreElm(RetNo,FNo,30,SafetyBox.Text);
 StoreElm(RetNo,FNo,31,CashFlowBox.Text);
 StoreElm(RetNo,FNo,32,AppreciationBox.Text);
 StoreElm(RetNo,FNo,33,TaxBenefitsBox.Text);
 StoreElm(RetNo,FNo,34,LiquidityBox.Text);
 StoreElm(RetNo,FNo,46,DebtBox.Text);
 StoreElm(RetNo,FNo,35,RiskReturnBox.Text);
 StoreElm(RetNo,FNo,36,MgtEffortBox.Text);

 For elm:=52 to 54 do StoreElm(RetNo,FNo,elm,'');
 Case RiskToleranceBox.ItemIndex of
 0: StoreElm(RetNo,FNo,52,'X');
 1: StoreElm(RetNo,FNo,53,'X');
 2: StoreElm(RetNo,FNo,54,'X');
 end;
 Calc(RetNo,'INVESTSTRATEGY');
end;

end.
