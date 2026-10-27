unit FP_2027assetsummary;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,ExtCtrls,Db,
  FP_2027TrimStr,FP_2027Declare, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart;
  //20150817 igor

type
  TAssetSummary = class(TForm)
    Chart2: TChart;
    Series2: TPieSeries;
    Chart1: TChart;
    Series1: TPieSeries;
    Cancel: TBitBtn;
    procedure FormCreate(Sender: TObject);
    {procedure OpenAssetsQ;}
    Procedure ChartByAssetType;
    Procedure ChartByPortfolioType;
    procedure CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AssetSummary: TAssetSummary;

implementation

{$R *.DFM}

procedure TAssetSummary.FormCreate(Sender: TObject);
begin
 ChartByAssetType;
 ChartByPortfolioType;
 {OpenAssetsQ;}
end;

Procedure TAssetSummary.ChartByAssetType;
Var i:Integer;
ChartColor:Array[0..20] of TColor;
begin
  For i:= Low(ChartColor) to High(ChartColor) do ChartColor[i] := clSilver;
  GetChartColors(ChartColor);
  For i:=0 to AssetSumList.Count-1 do
  Begin
    AssetSumRec := AssetSumList[i];
    Series1.Add(Round(AssetSumRec.TotalValue),AssetSumRec.AssetType,ChartColor[i]);
  end;
end;

Procedure TAssetSummary.ChartByPortfolioType;
Var i:Integer;
begin
  Series2.Add(Round(AssetsSumRec.NonShTotalValue),'Non-Sheltered',clBlue);
  Series2.Add(Round(AssetsSumRec.SheltTotalValue),'Sheltered',clRed);
  Series2.Add(Round(AssetsSumRec.SemShTotalValue),'Semi-Sheltered',clYellow);
  Series2.Add(Round(AssetsSumRec.OtherTotalValue),'Other',clGreen);
end;

(*
procedure TAssetSummary.OpenAssetsQ;
Var i:Integer;WhereClause:String;
begin
 AssetsQ.Close;
 AssetsQ.SQL.Clear;
 WhereClause := ' where '
  +'('
  + 'Trim(ClientId) = ' + '"' + ClientId + '"'
  +')';


 With AssetsQ do
 begin
  SQL.Add('Select ');
  SQL.Add('ClientId');
  SQL.Add(',Product');
  SQL.Add(',Description');
  SQL.Add(',CurrentValue');
  SQL.Add(',Interest');
  SQL.Add(',Account');
  SQL.Add(',AnnualYield');
  SQL.Add(',AssetType');
  SQL.Add(',LastUpdate');
  SQL.Add(',UpdatedBy');
  SQL.Add(',Units');
  SQL.Add(',OriginalCost');
  SQL.Add(',FaceValue');
  SQL.Add(',ValuationDate');
  SQL.Add(',Contributor');
  SQL.Add(',Beneficiary');
  SQL.Add(',DateBought');
  SQL.Add(',PortfolioType');
  SQL.Add('from Assets');
  SQL.Add( WhereClause);

  Prepare;
  open;
 End;
end;
*)


procedure TAssetSummary.CancelClick(Sender: TObject);
begin
Close;
end;

end.
