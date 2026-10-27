unit FP_2027CurrentPortfolio;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,Grids,DBGrids,ExtCtrls,DBCtrls,DB,StdCtrls,Buttons,Printers,
  Mask, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompClient, uADCompDataSet;

type
  TCurrentPortfolioFP_2012 = class(TForm)
    DataSource1: TDataSource;
    Label8: TLabel;
    PrintDialog1: TPrintDialog;
    GroupBox1: TGroupBox;
    DBGrid1: TDBGrid;
    CancelBtn: TBitBtn;
    HeaderPanel: TLabel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    SupplierFilter: TEdit;
    AccountTypeFilter: TComboBox;
    FindBtn: TBitBtn;
    SearchBtn: TBitBtn;
    GroupBox4: TGroupBox;
    SelectClientBtn: TBitBtn;
    AllClientsBtn: TBitBtn;
    BitBtn1: TBitBtn;
    FDConnection: TADConnection;
    ClientsTbl: TADTable;
    AssetsQ: TADQuery;
    procedure FormCreate(Sender: TObject);
    procedure OpenAssetsQ;
    procedure CancelBtnClick(Sender: TObject);
    procedure SelectClientBtnClick(Sender: TObject);
    procedure AllClientsBtnClick(Sender: TObject);
    procedure SupplierFilterKeyPress(Sender: TObject; var Key: Char);
    procedure AccountTypeFilterChange(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure AssetsQ2CalcFields(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);

  private
    { Private declarations }
  public
    RetNo: integer;
  end;

var
  CurrentPortfolioFP_2012: TCurrentPortfolioFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027declare,FP_2027Trimstr,FP_2027Common,
{$IFDEF ADO}
  FP_2012SelectClient,
{$ELSE}
{$ENDIF}
  FP_2027AssetSummary, vtTrimStr, vtShared, vtDataBase;

procedure TCurrentPortfolioFP_2012.FormCreate(Sender: TObject);
begin
  RetNo := GetcurrentRetNo;
 (*
 DecimalSeparator:='.';
 ClientsTbl.DataBaseName := ClientsDb;
 If not ClientsTbl.Active then ClientsTbl.Open;
 ClientsTbl.IndexFieldNames := 'ClientId';
 If WhichModule = 'F' then Client := Ret[RetNo]^.ClientId;
 {
 If RetInMem>0 then
  Client := Ret[RetNo]^.ClientId
 else
  Client := '';
 }
 OpenAssetsQ;
 *)
end;

procedure TCurrentPortfolioFP_2012.OpenAssetsQ;
Const Star='*';PortFl1='NONSH';PortFl2='SHELT';PortFl3='SEMSH';
Var i:Integer;WhereClause:String;
begin
 //20150921 Igor
 SqlLoadDBFromFile(FDConnection, AssetsQ, cfgClientsDbLite_noUse, '');

 If Client >'' then
  WhereClause := ' where ' + 'ClientId = ' + '"' + Client + '"'
 else
  WhereClause:= ' Where ClientId LIKE ' + '"' + Star + '"';

  WhereClause:= WhereClause +
  ' AND (Trim(PortfolioType) = ' + '"' + PortFl1 + '"'
  + ' OR Trim(PortfolioType) = ' + '"' + PortFl2 + '"'
  + ' OR Trim(PortfolioType) = ' + '"' + PortFl3 + '"'
  +')';

  If SupplierFilter.Text > '' then
   WhereClause := WhereClause + ' and '+
   'Supplier = '''+SupplierFilter.Text+''' ';

  If (AccountTypeFilter.Text > '') and
   (AccountTypeFilter.Text <> 'ALL') then
   WhereClause := WhereClause+ ' and ' +
      'AccountType = '''+AccountTypeFilter.Text+''' ';


 With AssetsQ do
 begin
  SQL.Add('Select * from Assets');
  SQL.Add( WhereClause);
  SQL.Add( 'ORDER BY PortfolioType, AccountType');
  Prepare;
  open;
 end;

End;

procedure TCurrentPortfolioFP_2012.CancelBtnClick(Sender: TObject);
begin
AssetsQ.Close;
Close;
end;

procedure TCurrentPortfolioFP_2012.SelectClientBtnClick(Sender: TObject);
begin
{$IFDEF ADO}
 Application.CreateForm(TSelectClient,SelectClient);
 SelectClient.ShowModal;
 If SelectClient.SelectedItem.Text >'' then
 begin
  Client := LeftStr(SelectClient.SelectedItem.Text,13);
  HeaderPanel.Caption := 'Current M/F Portfolio - '+
    AllTrim(MidStr(SelectClient.SelectedItem.Text,14,40))
    +', '+AllTrim(MidStr(SelectClient.SelectedItem.Text,55,20));

 end;
 SelectClient.Free; {free after getting the value}
 OpenAssetsQ;
{$ELSE}
  ADOMsg('SelectClient');
{$ENDIF}
end;

procedure TCurrentPortfolioFP_2012.AllClientsBtnClick(Sender: TObject);
begin
 Client:='';
 OpenAssetsQ;
 HeaderPanel.Caption := 'Current M/F Portfolio - All Clients';
end;


procedure TCurrentPortfolioFP_2012.SupplierFilterKeyPress(Sender: TObject;
  var Key: Char);
begin
 If Key=#13 then SearchBtnClick(Sender);
end;

procedure TCurrentPortfolioFP_2012.AccountTypeFilterChange(Sender: TObject);
begin
SearchBtnClick(Sender);
end;

procedure TCurrentPortfolioFP_2012.SearchBtnClick(Sender: TObject);
begin
 OpenAssetsQ;
end;

procedure TCurrentPortfolioFP_2012.AssetsQ2CalcFields(DataSet: TDataSet);
begin
 ShowMessage('Not existing events'); //20150920    //20171206
 //20150920 Igor: not exists events => rem calc...
{
  If ClientsTbl.FindKey([AssetsQ['ClientId']]) then
  AssetsQ.ClientName.Value :=
    AllTrim(ClientsTbl['LastName'])+', '+AllTrim(ClientsTbl['FirstName'])
 else
    AssetsQClientName.Value := '??????';
}
end;

procedure TCurrentPortfolioFP_2012.BitBtn1Click(Sender: TObject);
begin
 SummarizeAssets(RetNo);
 ExecuteForm(TAssetSummary);
end;

end.
