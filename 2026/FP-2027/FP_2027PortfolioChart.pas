unit FP_2027PortfolioChart;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,Grids,DBGrids,ExtCtrls,DBCtrls,DB,StdCtrls,Buttons,Mask,
  ComCtrls,Tabnotbk,VCLTee.TeEngine,VCLTee.Series,VCLTee.TeeProcs,VCLTee.Chart,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient; //20150819 Igor

type
  TPortFolioChartFP_2012 = class(TForm)
    LeftPanel: TPanel;
    DBGrid1: TDBGrid;
    RightPanel: TPanel;
    TabbedNotebook1: TTabbedNotebook;
    Splitter1: TSplitter;
    DBNavigator1: TDBNavigator;
    DataSource1: TDataSource;
    Panel1: TPanel;
    ChartBtn: TBitBtn;
    BitBtn1: TBitBtn;
    PortFolioTypeBox: TRadioGroup;
    Panel2: TPanel;
    PortFlLabel: TLabel;
    Image1: TImage;
    FDConnection: TADConnection;
    InvestmentPlanQ: TADQuery;

    procedure OpenInvestmentPlanQ;
    Procedure WhenFundChanges;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGrid1Enter(Sender: TObject);
    Function  GetFundId:String;
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGrid1Exit(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure TabbedNotebook1Change(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure ChartBtnClick(Sender: TObject);
    {Procedure ShowNewPortFolio;}
    procedure PortFolioTypeBoxClick(Sender: TObject);
   { procedure Table1FilterRecord(DataSet: TDataSet; var Accept: Boolean);}
    procedure ShowPortFolioMix(Tbl:TDataSet;CurrentOrProposed:String);
    Procedure ShowPortfolioCharts;
    { Private declarations }
  public
    RetNo: integer;
  end;

var
  PortFolioChart: TPortFolioChartFP_2012;
  FundId : string; //[10];
  CreateStage:boolean;
  PortfolioType:string; //[10];

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027declare,FP_2027Trimstr,FP_2027ChartAFund,vtTrimStr,
  vtShared;

procedure TPortFolioChartFP_2012.BitBtn1Click(Sender: TObject);
begin
Close;
{Table1.Close;}
end;

procedure TPortFolioChartFP_2012.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
CreateStage := True;
PortfolioTypeBox.ItemIndex :=0;
Screen.Cursor := crHourGlass;
LeftPanel.Align := alLeft;
Splitter1.Align := alLeft;
RightPanel.Align := alClient;
DbGrid1.Align := alClient;
Caption := Caption + ClientForCaption(RetNo);
TabbedNotebook1.ActivePage := 'Portfolio Mix';
OpenInvestmentPlanQ;
{ShowNewPortFolio;}
FundId := GetFundId;
WhenFundChanges;
Screen.Cursor := crDefault;
ShowPortFolioCharts;
CreateStage := false;
end;

Function TPortFolioChartFP_2012.GetFundId;
begin
 result :=InvestmentPlanQ.FieldByName('InvestmentId').AsString;
end;


procedure TPortFolioChartFP_2012.DBGrid1Enter(Sender: TObject);
begin
WhenFundChanges;
end;

Procedure TPortFolioChartFP_2012.WhenFundChanges;
begin
 FundId := GetFundId;
end;


procedure TPortFolioChartFP_2012.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
WhenFundChanges;
end;

procedure TPortFolioChartFP_2012.DBGrid1Exit(Sender: TObject);
begin
{WhenFundChanges;}
end;

procedure TPortFolioChartFP_2012.DBGrid1DblClick(Sender: TObject);
begin
WhenFundChanges;
ChartBtnClick(Sender);
end;


procedure TPortFolioChartFP_2012.TabbedNotebook1Change(Sender: TObject;
  NewTab: Integer; var AllowChange: Boolean);
begin
 {
 If TabbedNotebook1.ActivePage = 'Portfolio Mix' then
  begin ShowPortFolioMix(Table1,'P');exit;end
 else
 ShowMessage('Data not available for charting');
 }
end;

procedure TPortFolioChartFP_2012.DBGrid1CellClick(Column: TColumn);
begin
WhenFundChanges;
end;

procedure TPortFolioChartFP_2012.ChartBtnClick(Sender: TObject);
begin
 FundToChart := InvestmentPlanQ.FieldByName('InvestmentId').AsString;
 Application.CreateForm(TChartAFund,ChartAFund);
 ChartAFund.ShowModal;
 ChartAFund.Free;
end;


procedure TPortFolioChartFP_2012.PortFolioTypeBoxClick(Sender: TObject);
Var FNo:Integer;
begin
 ShowPortFolioCharts;
end;

{
procedure TPortFolioChart.Table1FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
If CreateStage = True then exit;
If PortFolioType.ItemIndex =0 then
  Accept := DataSet['POOL'] = 'SEMSH'
else
  Accept := DataSet['POOL'] = 'SHELT';
end;
}
procedure TPortFolioChartFP_2012.ShowPortFolioMix(Tbl:TDataSet;CurrentOrProposed:String);
Var i,j:integer;TotAmount:Real; MixArray:Array[0..20] of real;R:TRect;
   TempCanvas:TBitMap;
begin
(*
 TotAmount :=0;
 For i:=0 to 20 do MixArray[i] :=0;
 Tbl.First;
 With Tbl do
 begin
   repeat
    j:=IsInList(FieldByName('FundType').AsString,MfCtgryCode);
    If J>-1 then
       begin
       MixArray[j] := MixArray[j]+ FieldByName('Amount').AsFloat;
       TotAmount := TotAmount+ FieldByName('Amount').AsFloat;
       end;
    next;
   until Tbl.Eof;

   {convert to %}
   If TotAmount >0 then
   begin
    For i:=0 to MfCtgryCode.Count-1 do
      MixArray[i] := (MixArray[i]/TotAmount) * 100;
   end
   else
   begin
    For i:=0 to MfCtgryCode.Count-1 do
      MixArray[i] := 0;
   end;
   R := Image1.BoundsRect;
   TempCanvas := TBitMap.Create;
   TempCanvas.Width := Width;
   TempCanvas.Height :=Height;
   TempCanvas.Canvas.Pen.Width := 1;
   TempCanvas.Canvas.Brush.Color := clBtnShadow;
   ChartPortFolioMix(MixArray,CurrentOrProposed,TempCanvas,R);
   Try
    Image1.Canvas.CopyMode := cmSrcCopy;
    Image1.Canvas.CopyRect(R,TempCanvas.Canvas,R);
    TempCanvas.Free;
   finally
   ;
   end;
 end;
*)
end;

Procedure TPortFolioChartFP_2012.ShowPortfolioCharts;
begin
{
If TabbedNotebook1.ActivePage = 'Portfolio Mix' then
 ShowPortfolioMix(Table1,'P');
 }
end;

procedure TPortFolioChartFP_2012.OpenInvestmentPlanQ;
Var WhereClause:String;
begin
 (*
 InvestmentPlanQ.Close;
 InvestmentPlanQ.SQL.Clear;
 {Build where clause}

 WhereClause := ' where '
  +'('
  + 'ClientId = ' + '"' + Ret[RetNo]^.ClientId + '"'
  +')'
  + ' and '
  + '('
  + 'PortfolioType = ' + '"' + PortfolioType + '"'
  + ')';

 {
 If SupplierFilter.Text > '' then
   WhereClause := WhereClause + ' and '+
   'Supplier = '''+SupplierFilter.Text+''' ';
 If AccountTypeFilter.Text > '' then
   WhereClause := WhereClause+ ' and ' +
      'AccountType = '''+AccountTypeFilter.Text+''' ';
 }
 {------------}
 With  InvestmentPlanQ do
 begin
 {SQL.Add('Select * ');}

 SQL.Add('Select ');
 SQL.Add('PortFolioType');
 SQL.Add(',Supplier');
 SQL.Add(',InvestmentId');
 SQL.Add(',Description');
 SQL.Add(',Amount');
 SQL.Add(',When');
 SQL.Add(',Status');
 {
 SQL.Add(',Percent');
 SQL.Add(',FundType');
 SQL.Add(',RRSPEligible');
 SQL.Add(',ForeignContent');
 SQL.Add(',SouthamId');
 }
 SQL.Add(',ClientId');
 {
 SQL.Add(',Ret1Year');
 SQL.Add(',Ret2Year');
 SQL.Add(',Ret3Year');
 SQL.Add(',StdDeviation');
 SQL.Add(',StdDeviation5');
 }

 SQL.Add('from InvestmentPlan');
 SQL.Add( WhereClause);
 Prepare;
 open; {good only for local db and SELECT statement on Client server}
 {Query1.ExecSql;}  {good for INSERT, UPDATE, DELETE, and CREATE TABLE and client server db as well}
 end;
*) 
end;



end.
