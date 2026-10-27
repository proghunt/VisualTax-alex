unit FP_2027networthchart;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
 StdCtrls,Buttons,ComCtrls,Grids, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart;
  //20150817 igor

type
  TNetWorthChartFP_2012 = class(TForm)
    Panel2: TPanel;
    ByYearOrAge: TRadioGroup;
    CancelBtn: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Chart1: TChart;
    Series1: TBarSeries;
    StringGrid1: TStringGrid;
    PrintBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure ByYearOrAgeClick(Sender: TObject);
    procedure ShowChart;
    procedure CancelBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    Procedure ShowBalances;
    procedure PrintBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    RetNo: integer;
  end;

var
  NetWorthChart: TNetWorthChartFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027Declare,FP_2027Trimstr,vtTrimStr,vtShared;

procedure TNetWorthChartFP_2012.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
 PageControl1.ActivePage := Tabsheet1;
 ByYearOrAge.ItemIndex :=1;
 BuildNetWorthProjection(RetNo);
 StringGrid1.RowCount := NetWorthProjectionList.Count+2;
 ShowChart;
end;

procedure TNetWorthChartFP_2012.ShowChart;
Var i,Density:Integer;
begin
  GetRetirementParms(RetNo);
  If NetWorthProjectionList.Count <20 then density :=1
  else if NetWorthProjectionList.count<40  then density:=2
  else density :=3;

 i:=0;
 Repeat
  NetWorthProjectionRec := TNetWorthProjectionRec(NetWorthProjectionList.Items[i]);
  If ByYearOrAge.ItemIndex = 0 then
    Series1.Add(Round(NetWorthProjectionRec.NetWorth),IntToStr(NetWorthProjectionRec.Year),clTeeColor)
  else
    Series1.Add(Round(NetWorthProjectionRec.NetWorth),IntToStr(NetWorthProjectionRec.Age),clTeeColor);
  Inc(i,Density); {every  1,2 or 3years}
  until i>RetirementParms.NumbPeriods;  //NetWorthProjectionList.Count-1;
end;

procedure TNetWorthChartFP_2012.ByYearOrAgeClick(Sender: TObject);
begin
 Series1.Clear;
 ShowChart;
end;

procedure TNetWorthChartFP_2012.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TNetWorthChartFP_2012.PageControl1Change(Sender: TObject);
begin
 If PageControl1.ActivePage = TaBsheet2 then
   ShowBalances;
end;

Procedure TNetWorthChartFP_2012.ShowBalances;
Var  i,aRow:Integer; //,PrevRow,PrevCol:integer;
   Year,Age: String; x:Real;
   CapGainsTax:string; //[15];
   //InvestmentAssets,FixedAssets,
   TotAssets,TotLiabilities,NetWorth:string; //[15];
   Notes :string; //[40];
begin
 CapGainsTax:='';
 With StringGrid1 do
 begin
   //PrevCol := Col;
   //PrevRow:=Row;
   For i:=0 to 1 do ColWidths[i]:= 40;
   For i:=2 to 5 do ColWidths[i]:= 100;
   Cells[0,0]:='Age';
   Cells[1,0]:='Year';
   Cells[2,0]:='Total Assets';
   Cells[3,0]:='Less Total Liabilities';
   //Cells[4,0]:='CapGains';
   Cells[4,0]:='Less Deferred CapGainsTax';
   Cells[5,0]:='= Net Worth';
   For i:=0 to RetirementParms.NumbPeriods do //NetWorthProjectionList.Count-1 do
   begin
    aRow := i+1;
    NetWorthProjectionRec := TNetWorthProjectionRec(NetWorthProjectionList.Items[i]);
    //FixedAssetsProjectionRec:= FixedAssetsProjectionList.Items[i];
    LiabilitiesProjectionRec:=LiabilitiesProjectionList.Items[i];

    Age:=IntToStr(NetWorthProjectionRec.Age);
    Year:=IntToStr(NetWorthProjectionRec.Year);
    //str(FixedAssetsProjectionRec.Total:15, FixedAssets);
    //str(TotInvestmProjectionRec.TotEndBalance:15, InvestmentAssets); //investment
    //x:=Vl(InvestmentAssets)+Vl(FixedAssets);
    //Str(x:15, TotAssets);
    Str(NetWorthProjectionRec.TotAssets:15, TotAssets);
    Str(NetWorthProjectionRec.TotLiabilities:15, TotLiabilities);
    //str(FixedAssetsProjectionRec.CapGains:15, TotCapGains);
    Str(NetWorthProjectionRec.NetWorth:15, NetWorth);
    Cells[0,aRow] := Age;
    Cells[1,aRow] := Year;
    //Cells[2,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(InvestmentAssets)),12);
    //Cells[3,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(FixedAssets)),12);
    Cells[2,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(TotAssets)),12);
    Cells[3,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(TotLiabilities)),12);
    //Cells[7,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(CapGains)),12);
    Cells[4,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(CapGainsTax)),12);
    Cells[5,aRow]:=PaddR(FormatFloat('##,###,##0',Vl(NetWorth)),12);

   end; {i}
  // Row:=PrevRow;
  // Col:=PrevCol;
 end; {stringgrid1}
end;



procedure TNetWorthChartFP_2012.PrintBtnClick(Sender: TObject);
begin
PrintAChart(Chart1,ClientLastName(RetNo)+', '+ClientFirstName(RetNo)
  + '    Prepared '+FormatDateTime('yyyy-mm-dd',Date));
end;

procedure TNetWorthChartFP_2012.FormClose(Sender: TObject; var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;

end.
