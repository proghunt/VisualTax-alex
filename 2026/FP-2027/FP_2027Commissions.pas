unit FP_2027Commissions;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  Buttons,Grids,DBGrids,Db,ComCtrls,ExtCtrls, uADStanIntf,
  uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef,
  uADStanPool, uADStanAsync, uADPhysManager, uADStanParam, uADDatSManager,
  uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TCommissionsFP_2012 = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    TransactionsSrc: TDataSource;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    SupplierFilter: TEdit;
    AccountTypeFilter: TComboBox;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    StatusFilter: TComboBox;
    TransactionTypeFilter: TComboBox;
    GroupBox5: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    DateFrom: TEdit;
    DateTo: TEdit;
    FindBtn: TBitBtn;
    SearchBtn: TBitBtn;
    Panel3: TPanel;
    Panel2: TPanel;
    TreeView1: TTreeView;
    FDConnection: TADConnection;
    TransactionsQ: TADQuery;
    Query1: TADQuery;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    Procedure OpenTables;
    procedure OpenTransactionsQ;
    Procedure OpenBranchOfficesQ;
    procedure SearchBtnClick(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Query1CalcFields(DataSet: TDataSet);
    procedure TransactionsQCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Commissions: TCommissionsFP_2012;
  ThisAgent,ThisBranch:string; //[5];

implementation

{$R *.DFM}

uses vtCommon,FP_2027,FP_2027TrimStr,FP_2027Declare,vtTrimStr,vtShared;

procedure TCommissionsFP_2012.Query1CalcFields(DataSet: TDataSet);
begin
  // 20150922 Igor
  Query1.FieldByName('FieManager').AsString := AllTrim(Query1['ManagerFirstName'])
    +' '+AllTrim(Query1['ManagerLastName']);
  Query1.FieldByName('AgentName').AsString := AllTrim(Query1['FirstName'])
    +' '+AllTrim(Query1['LastName']);
end;

Procedure TCommissionsFP_2012.OpenTables;
begin
 OpenBranchOfficesQ;
 OpenTransactionsQ;
end;

Procedure TCommissionsFP_2012.OpenBranchOfficesQ;
Var i:Integer;WhereClause:String; TempList:TStringList;
  PrevBranch:string; //[4];
begin
 Query1.Close;
 query1.SQL.Clear;
 WhereClause := ' where a.Branch = b.branch ';
 With query1 do
 begin
  SQL.Add('Select *  from Agents a, BranchOffices b');
  SQL.Add( WhereClause);
  SQL.Add( ' ORDER BY b.Branch, a.LastName');
  Prepare;
  open;
 end;
 TempList := TStringList.Create;
 PrevBranch:='';
 Query1.First;
 Repeat
  {add the branch level}
  Try
   If Query1['b.Branch'] > PrevBranch then
    Templist.Add(
                 PaddR(Query1['b.Branch'],4)
                 +'-'+AllTrim(Query1['BranchName'])
                 +' ('
                 +AllTrim(Query1['Manager'])+')'
                 );
   PrevBranch:=Query1['b.Branch'];
  {add agent indended}
   Templist.Add(' '+PaddR(Query1['AgentCode'],5)
    +'-'+Query1['AgentName']);
  except
  end;
  Query1.Next;
 until Query1.Eof;
 TempList.SaveToFile(AppDir+'\'+'Temp');
 TempList.Free;
 Treeview1.LoadFromFile(AppDir+'\'+'Temp');
 TreeView1.FullExpand;
end;

procedure TCommissionsFP_2012.FormCreate(Sender: TObject);
Var i:Integer;
begin
 AccountTypeFilter.ItemIndex:=0;
 TransactionTypeFilter.Text := '5';
 {TransactionTypeFilter.ItemIndex:=0;}
 StatusFilter.Text := 'Settled';
 {StatusFilter.ItemIndex:=0;}

 DateFrom.Text := '';
 DateTo.Text := FormatDateTime('yyyy-mm-dd',Now);
 For i:=Low(TransactionStatus) to High(TransactionStatus) do
  StatusFilter.Items.add(TransactionStatus[i]);
 OpenTables;
end;

procedure TCommissionsFP_2012.CancelBtnClick(Sender: TObject);
begin
 If Query1.Active then Query1.Close;
 Close;
end;

procedure TCommissionsFP_2012.OpenTransactionsQ;
Const Star='*'; Purch='5';St1='Settled';
Var WhereClause:String;
begin
 TransactionsQ.Close;
 TransactionsQ.SQL.Clear;

 WhereClause :='';

 WhereClause := 'Where Trim(AgentCode) = '''+ThisAgent+''' ';


 WhereClause := WhereClause+ ' and ' +
      'Trim(Status) = '''+St1+''' ';

 {
 WhereClause := WhereClause+ ' and ' +
      'TradeDate >= '''+DateFrom.Text+''' ';
 WhereClause := WhereClause+ ' and ' +
      'TradeDate <= '''+DateTo.Text+''' ';
 WhereClause := WhereClause+ ' and ' +
      'TransactionType = '''+Purch+''' ';
 }
{
 If SupplierFilter.Text > '' then
   WhereClause := WhereClause + ' and '+
   'Supplier = '''+SupplierFilter.Text+''' ';

 If (AccountTypeFilter.Text > '') and
   (AccountTypeFilter.Text <> 'ALL') then
   WhereClause := WhereClause+ ' and ' +
      'AccountType = '''+AccountTypeFilter.Text+''' ';

 If (TransactionTypeFilter.Text > '') and
   (TransactionTypeFilter.Text <> 'ALL') then
 begin
   WhereClause := WhereClause+ ' and ' +
      'TransactionType = '''+Purch+''' ';
 end;

 If (StatusFilter.Text > '') and
   (StatusFilter.Text <> 'ALL') then
   WhereClause := WhereClause+ ' and ' +
      'Status = '''+StatusFilter.Text+''' ';
  }

 {------------}
 With TransactionsQ do
 begin
 SQL.Add('Select * ');
 SQL.Add('from Transactions');
 SQL.Add( WhereClause);
 {SQL.Add( 'ORDER BY DateCreated,Supplier');}
 Prepare;
 open;
 {good only for local db and SELECT statement on Client server}
 {Query1.ExecSql;}  {good for INSERT, UPDATE, DELETE, and CREATE TABLE and client server db as well}
 end;
end;

procedure TCommissionsFP_2012.TransactionsQCalcFields(DataSet: TDataSet);
begin
  // 20150922 Igor
  TransactionsQ.FieldByName('TransType').AsString:= GetTransactionDescription
 (AllTrim(TransactionsQ.FieldByName('TransactionType').AsString)
  +AllTrim(TransactionsQ.FieldByName('TransactionTypeDetail').AsString));

 TransactionsQ.FieldByName('DealerCommission').AsFloat :=
  CalcDealerCommission(TransactionsQ['GrossAmount'],
                       TransactionsQ['GrossNetPurchase'],
                       TransactionsQ['FE_Rate'],
                       TransactionsQ['DSC_Rate']);
end;

procedure TCommissionsFP_2012.SearchBtnClick(Sender: TObject);
begin
OpenTransactionsQ;
end;

procedure TCommissionsFP_2012.TreeView1Click(Sender: TObject);
Var SourceNode:TTreeNode;ndx:Integer;Rec:String;
begin
 SourceNode:= TreeView1.Selected;
 {
 If SourceNode.Expanded then
  SourceNode.Collapse(True)
 else
  begin
   If SourceNode.HasChildren then SourceNode.Expand(True);
 end;
 }
 Ndx :=SourceNode.AbsoluteIndex;
 Rec :=TreeView1.Items[ndx].text;
 {Ftype := AllTrim(FrmTreeFType[Ndx]);}
 ThisAgent:= LeftStr(Rec,4);
 {ThisBranch := LeftStr(}
 {
 Agent := AllTrim(FrmTreeForms[ndx]);
 Ftype := AllTrim(FrmTreeFType[Ndx]);
 }
 OpenTransactionsQ;
end;

procedure TCommissionsFP_2012.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;

end.
