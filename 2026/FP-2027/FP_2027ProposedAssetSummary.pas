unit FP_2027ProposedAssetSummary;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,VCLTee.TeEngine,VCLTee.Series,ExtCtrls,VCLTee.TeeProcs,VCLTee.Chart,VCLTee.DBChart,Db, //20150819 Igor
  FP_2027TrimStr,FP_2027Declare, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient;

type
  TProposedAssetSummary = class(TForm)
    CancelBtn: TBitBtn;
    Chart1: TChart;
    Series1: TPieSeries;
    DataSource1: TDataSource;
    Chart3: TChart;
    Series3: TBarSeries;
    Series4: TBarSeries;
    DataSource2: TDataSource;
    Label1: TLabel;
    Edit1: TEdit;
    FDConnection: TADConnection;
    InvestmentPlanQ: TADQuery;
    AssetTypesTbl: TADTable;
    tblFDConnection: TADConnection;
    procedure FormCreate(Sender: TObject);
    {procedure OpenInvestmentPlanQ;}
    Procedure ChartAssetType;
    {Procedure ChartPortfolioType;}
    { Procedure SummarizeProposedAssets(ClientId:String);}
    Procedure ChartPortfolioTypeComparison;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CancelBtnClick(Sender: TObject);
    {procedure LoadAssetTypes;}
   { procedure SummarizeBuySell;}
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProposedAssetSummary: TProposedAssetSummary;

implementation

{$R *.DFM}

procedure TProposedAssetSummary.FormCreate(Sender: TObject);
begin
 (*
 {OpenInvestmentPlanQ;}
 SummarizeBuySell(Ret[RetNo]^.ClientId);
 SummarizeProposedAssets(Ret[RetNo]^.ClientId);
 {ChartAssetType;}
 ChartPortfolioTypeComparison;
 Edit1.Text := FormatFloat('##,###,###.##',ProposedAssetsSumRec.UnallocatedCashFromSales);
 *)
end;

Procedure TProposedAssetSummary.ChartAssetType;
Var i:Integer; ChartColor: Array[0..20] of TColor;
begin
(*
 For i:= Low(ChartColor) to High(ChartColor) do ChartColor[i] := clSilver;
 GetChartColors(ChartColor);
 For i:=0 to ProposedAssetSumList.Count-1 do
  Begin
    ProposedAssetSumRec := ProposedAssetSumList[i];
    Series1.Add(Round(ProposedAssetSumRec.TotalValue),ProposedAssetSumRec.AssetType,ChartColor[i]);
  end;
 *)
end;

(*
Procedure TProposedAssetSummary.ChartPortfolioType;
Var i:Integer;
begin
  With Chart2 do
  begin
   Title.Font.Color := clMaroon;
   Title.Font.Size := 12;
   Title.Font.Style := [fsBold];
   Title.Text.Clear;
   Title.Text.Add('(Proposed) Investment Mix');
  end;
  Series2.Add(Round(ProposedAssetsSumRec.NonShTotalValue),'Non-Sheltered',clRed);
  Series2.Add(Round(ProposedAssetsSumRec.SheltTotalValue),'Sheltered',clRed);
  Series2.Add(Round(ProposedAssetsSumRec.SemShTotalValue),'Semi-Sheltered',clRed);
  Series2.Add(Round(ProposedAssetsSumRec.OtherTotalValue),'Other',clRed);
end;
*)
Procedure TProposedAssetSummary.ChartPortfolioTypeComparison;
Var i:Integer;
begin
 With Series3 do
 begin
  Add(Round(AssetsSumRec.NonShTotalValue),'Non-Sheltered',clRed);
  Add(Round(AssetsSumRec.SheltTotalValue),'Sheltered',clRed);
  Add(Round(AssetsSumRec.SemShTotalValue),'Semi-Sheltered',clRed);
  Add(Round(AssetsSumRec.OtherTotalValue),'Other',clRed);
 end;

 With Series4 do
 begin
 (*
  Add(Round(ProposedAssetsSumRec.NonShTotalValue),'Non-Sheltered',clGreen);
  Add(Round(ProposedAssetsSumRec.SheltTotalValue),'Sheltered',clGreen);
  Add(Round(ProposedAssetsSumRec.SemShTotalValue),'Semi-Sheltered',clGreen);
  Add(Round(ProposedAssetsSumRec.OtherTotalValue),'Other',clGreen);
 *)
 end;

end;


procedure TProposedAssetSummary.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;

procedure TProposedAssetSummary.CancelBtnClick(Sender: TObject);
begin
If InvestmentPlanQ.Active then InvestmentPlanQ.Close;
Close;
end;

end.
