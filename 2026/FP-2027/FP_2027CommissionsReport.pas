unit FP_2027CommissionsReport;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,QuickRpt,
  Qrctrls,ExtCtrls,Db,FP_2027Declare,FP_2027TrimStr, uADStanIntf,
  uADStanOption, uADStanParam, uADStanError, uADDatSManager, uADPhysIntf,
  uADDAptIntf, uADStanAsync, uADDAptManager, uADGUIxIntf, uADStanDef,
  uADStanPool, uADPhysManager, uADCompClient, uADCompDataSet;

type
  TCommissionsReport = class(TForm)
    QuickRep1: TQuickRep;
    QRBand2: TQRBand;
    QRLabel5: TQRLabel;
    QRShape1: TQRShape;
    QRLabel9: TQRLabel;
    QRLabel11: TQRLabel;
    QRLabel7: TQRLabel;
    QRLabel10: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel6: TQRLabel;
    QRBand3: TQRBand;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText7: TQRDBText;
    TransactionsQ: TADQuery;
    QRLabel3: TQRLabel;
    QRDBText1: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText8: TQRDBText;
    QRBand5: TQRBand;
    QRLabel2: TQRLabel;
    DateRange: TQRLabel;
    QRExpr1: TQRExpr;
    QRLabel1: TQRLabel;
    QRShape3: TQRShape;
    AgentGroup: TQRGroup;
    AgentTotalBand: TQRBand;
    QRLabel4: TQRLabel;
    TxSumExpr: TQRExpr;
    QRShape2: TQRShape;
    QRBand1: TQRBand;
    QRBand4: TQRBand;
    QRLabel8: TQRLabel;
    ChequeAmountLbl: TQRLabel;
    QRShape4: TQRShape;
    CreditAmountLbl: TQRLabel;
    ChargesAmountLbl: TQRLabel;
    QRLabel13: TQRLabel;
    QRLabel14: TQRLabel;
    HdrAgentName: TQRLabel;
    NoDataLbl: TQRLabel;
    HdrAgentCode: TQRLabel;
    QRLabel15: TQRLabel;
    QRLabel17: TQRLabel;
    QRExpr2: TQRExpr;
    FDConnection: TADConnection;
    ClientsTbl: TADTable;
 (*
    procedure FormCreate(Sender: TObject);
    Procedure OpenTransactionsQ;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure QRExpr3Print(sender: TObject; var Value: String);
    procedure TransTypeifPrint(sender: TObject; var Value: String);

//    procedure TransactionsQCalcFields(DataSet: TDataSet);
    Procedure OpenTables;
//    procedure AgentTotalBandAfterPrint(Sender: TQRCustomBand;      BandPrinted: Boolean);
//    procedure QRBand3AfterPrint(Sender: TQRCustomBand; BandPrinted: Boolean);
  *)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CommissionsReport: TCommissionsReport;
  AgentCommissionRate :Real;
  CoAgentCommissionRate :Real;
  Charges,Credits:Real;
  AgCommission:Real; {each fund}
  CoAgentCommission:Real;

  TotalCheque:Real;
implementation

{$R *.DFM}

//Uses UCommissionStatementsFrm;

(*
procedure TCommissionsReport.FormCreate(Sender: TObject);
begin
 TotalCheque :=0;
 DateRange.Caption := 'Period: '+FromDt+ ' to '+ToDt;
 If ThisAgent > '' then
  begin
  HdrAgentName.Caption := GetAgentName(ThisAgent);
  HdrAgentCode.Caption := ThisAgent;
  end;
 OpenTables;
end;

Procedure TCommissionsReport.OpenTables;
begin
 Screen.Cursor := crHourGlass;
 If not ClientsTbl.Active then ClientsTbl.Open;
 ClientsTbl.IndexFieldNames := 'ClientId';
 OpenTransactionsQ;
 If TransactionsQ.RecordCount =0 then
   NoDataLbl.Caption := '*** No activity ***'
 else
   NoDataLbl.Caption := '';
 Screen.Cursor := crDefault;
end;


Procedure TCommissionsReport.OpenTransactionsQ;
Const Star='*'; Purch='5';St1='Settled';RealPurch='';Paid='Y';
Var WhereClause:String;
begin
 TransactionsQ.Close;
 TransactionsQ.SQL.Clear;

 WhereClause := 'WHERE Trim(AgentCode) = '''+ThisAgent+''' ';
 WhereClause := WhereClause+ ' and ' +
      'Trim(Status) = '''+St1+''' ';
 WhereClause := WhereClause+ ' and ' +
      'Trim(TransactionType) = '''+Purch+''' ';
 WhereClause := WhereClause+ ' and ' +
      'Trim(TransactionTypeDetail) = '''+RealPurch+''' ';
 WhereClause := WhereClause+ ' and ' +
      'Trim(DateSettled) >= '''+FromDt+''' ';
 WhereClause := WhereClause+ ' and ' +
      'Trim(DateSettled) <= '''+ToDt+''' ';

 {
 WhereClause := WhereClause+ ' and ' +
      'Trim(AgentPaid) <> '''+Paid+''' ';
 }
 With TransactionsQ do
 begin
  SQL.Add('Select * ');
  SQL.Add('from Transactions');
  SQL.Add( WhereClause);
  SQL.Add( 'ORDER BY AgentCode');

  {TransactionsQ.Sql.LoadFromFile(AppDir+'\'+'Commissions.qry');}
  TransactionsQ.Prepare;
  Try
   TransactionsQ.open;
  except
    on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;
 end;
end;

procedure TCommissionsReport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 If TransactionsQ.Active then TransactionsQ.Close;
 If ClientsTbl.Active then ClientsTbl.Close;
end;

procedure TCommissionsReport.QRExpr3Print(sender: TObject;
  var Value: String);
begin
 {
 If AllTrim(TransactionsQ.FieldByName('TransactionType').AsString)= '5' then
   Value := 'Purchase';
 }
end;

procedure TCommissionsReport.TransTypeifPrint(sender: TObject;
  var Value: String);

begin
  {TransType.Caption:= 'Purchase'; does not work}
  {Value:='Purchase';} {ABENDS}
end;
*)
(*
procedure TCommissionsReport.TransactionsQCalcFields(DataSet: TDataSet);
Var AgentRate:Real;CoAgentRate:Real;DealCommission:Real;
begin
  If ClientsTbl.FindKey([TransactionsQ['ClientId']]) then
   TransactionsQClientName.Value := AllTrim(ClientsTbl['LastName'])
   +', '+AllTrim(ClientsTbl['FirstName'])
  else
    TransactionsQClientName.Value := '??????';
  TransactionsQAgentName.Value := GetAgentName(TransactionsQ['AgentCode']);
  TransactionsQProductRt.Value := GetFundAndRatetype(
                        TransactionsQ['Product'],
                        TransactionsQ['GrossNetPurchase']);

  {Calc commissions}
  AgentRate := GetAgentFieldValue(FpUser.AgentCode,'AgentRate');
  Try
  CoAgentRate :=TransactionsQ['CoAgentRate'];
  except
   CoAgentRate :=0;
  end;

  Try
  Dealcommission:= CalcDealerCommission(TransactionsQ['GrossAmount'],
                        TransactionsQ['GrossNetPurchase'],
                        TransactionsQ['FE_Rate'],
                        TransactionsQ['DSC_Rate']);
  AgCommission:=CalcAgentCommission(DealCommission,AgentRate);
  CoAgentCommission := CalcCoAgentCommission(AgCommission,CoAgentRate);
  {put on query fields}
  TransactionsQTxAgentRate.Value := AgentRate;
  TransactionsQAgentCommission.Value :=AgCommission;
  TransactionsQCoAgentCommission.Value := -CoAgentCommission;
  If MarkAsPaid then
  begin
   TransactionsQ.Edit;
   TransactionsQ['AgentPaid'] := 'Y';
   TransactionsQ['DateAgentPaid'] := FormatDateTime('yyyy-mm-dd',Now);
   TransactionsQ['AgentRate'] := AgentRate;
   TransactionsQ.Post;
  end;
 Except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end; {try}
end;

procedure TCommissionsReport.AgentTotalBandAfterPrint(
  Sender: TQRCustomBand; BandPrinted: Boolean);
begin
 GetAutoAdjustments(TransactionsQ['AgentCode'],ToDt,Charges,Credits);
 If Credits<>0 then CreditAmountLbl.Caption:= FormatFloat('###,###.00',Credits)
   else CreditAmountLbl.Caption:= 'N/A';
 If Charges<>0 then ChargesAmountLbl.Caption:= FormatFloat('###,###.00',Charges)
    else ChargesAmountLbl.Caption:= 'N/A';
 TotalCheque :=TotalCheque+Credits+Charges;
 ChequeAmountLbl.Caption := JustRight(FormatFloat('###,###.00',TotalCheque),15);
 TotalCheque:=0;
end;

procedure TCommissionsReport.QRBand3AfterPrint(Sender: TQRCustomBand;
  BandPrinted: Boolean);
begin
TotalCheque := TotalCheque+ AgCommission-CoAgentCommission;
end;
*)
end.

