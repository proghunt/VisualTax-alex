unit FP_2027CommissionSummary;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,
  Db,Grids,DBGrids,StdCtrls,FP_2027TrimStr,FP_2027declare,Buttons;

type
  TCommissionSummary = class(TForm)
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    FromDateBox: TEdit;
    ToDateBox: TEdit;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    AgentBox: TEdit;
    Label1: TLabel;
    CalcBtn: TBitBtn;
//    procedure FormCreate(Sender: TObject);
(*
    procedure FormCreate(Sender: TObject);
    Procedure OpenTransactionsQ;
    procedure TransactionsQCalcFields(DataSet: TDataSet);
    procedure OkBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
    Function CalcTotalAgentCommission(ThisAgent,FromDt,ToDt:String):Real;
*)    
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CommissionSummary: TCommissionSummary;
  FromDt,ToDt:String[10];
  AgentCommissionRate :Real;
  Item1,Item2,Item3:String[20];
  Amount1,Amount2,Amount3:Real;
  AgCommission:Real; {each fund}
  TotalCheque:Real;

implementation

{$R *.DFM}

(*
procedure TCommissionSummary.FormCreate(Sender: TObject);
begin
 ToDateBox.Text := FormatDateTime('yyyy-mm-dd',Now);
 FromDateBox.Text := LeftStr(ToDateBox.text,8)+'01';{first of month}

end;

Procedure TCommissionSummary.OpenTransactionsQ;
Const Star='*'; Purch='5';St1='Settled';RealPurch='';
Var WhereClause:String;
begin
 //TransactionsQ.DataBaseName := ClientsDb;
 TransactionsQ.Close;
 TransactionsQ.SQL.Clear;
 WhereClause := 'WHERE Trim(AgentCode) = '''+ThisAgent+''' ';
 WhereClause := WhereClause+ ' AND ' +
      'Trim(Status) = '''+St1+''' ';
 WhereClause := WhereClause+ ' and ' +
      'Trim(TransactionType) = '''+Purch+''' ';
 WhereClause := WhereClause+ ' and ' +
      'Trim(TransactionTypeDetail) = '''+RealPurch+''' ';
 WhereClause := WhereClause+ ' and ' +
      'Trim(SettlementDate) >= '''+FromDt+''' ';
 WhereClause := WhereClause+ ' and ' +
      'Trim(SettlementDate) <= '''+ToDt+''' ';

 With TransactionsQ do
 begin
  SQL.Add('Select * ');
  SQL.Add('from Transactions');
  SQL.Add( WhereClause);
  SQL.Add( 'ORDER BY AgentCode');

  {TransactionsQ.Sql.LoadFromFile(AppDir+'\'+'Commissions.qry');}
  //TransactionsQ.Prepare;
  Try
   TransactionsQ.open;
  except
    on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;
 end;
end;


procedure TCommissionSummary.TransactionsQCalcFields(DataSet: TDataSet);
Var AgentRate:Real;DealCommission:Real;
begin
// TransactionsQAgentName.Value := GetAgentName(TransactionsQ['AgentCode']);

 Dealcommission:= CalcDealerCommission(TransactionsQ['GrossAmount'],
                       TransactionsQ['GrossNetPurchase'],
                       TransactionsQ['FE_Rate'],
                       TransactionsQ['DSC_Rate']);

 //TransactionsQDealerCommission.Value := DealCommission;
 AgentRate := GetAgentFieldValue(AgentBox.Text,'AgentRate');

 //TransactionsQTxAgentRate.Value := AgentRate;
 AgCommission:=CalcAgentCommission(DealCommission,AgentRate);
 //TransactionsQAgentCommission.Value :=AgCommission;


end;

procedure TCommissionSummary.OkBtnClick(Sender: TObject);
begin
 FromDt := AllTrim(FromDateBox.Text);
 ToDt   := AllTrim(ToDateBox.Text);
 ThisAgent:=AgentBox.Text;
 OpenTransactionsQ;
end;

procedure TCommissionSummary.CancelBtnClick(Sender: TObject);
begin
If TransactionsQ.Active Then TransactionsQ.Close;
Close;
end;

procedure TCommissionSummary.CalcBtnClick(Sender: TObject);
Begin
 FromDt := AllTrim(FromDateBox.Text);
 ToDt   := AllTrim(ToDateBox.Text);
 ThisAgent:=AgentBox.Text;
 ShowMessage(
  FormatFloat('####,###.00',CalcTotalAgentCommission(ThisAgent,FromDt,ToDt)));
end;

Function TCommissionSummary.CalcTotalAgentCommission(ThisAgent,FromDt,ToDt:String):Real;
Var TotalAgentCommission:Real;
begin
 Result:=0;
 OpenTransactionsQ;
 If TransactionsQ.RecordCount=0 then
 begin
  result :=0;
  Exit;
 end;

 TransactionsQ.First;
 Repeat
  Result := Result + TransactionsQ['AgentCommission'];
  TransactionsQ.Next;
 until TransactionsQ.Eof;

end;


procedure TCommissionSummary.FormCreate(Sender: TObject);
begin

end;
*)
end.
