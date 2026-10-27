unit FP_2027trustreconciliation;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,TabNotBk,StdCtrls,Buttons,ComCtrls,FP_2027Declare,FP_2027TrimStr,
  FP_2027FsRtns,Grids,Db,DBGrids,Mask,DBCtrls,FP_2027Common,ExtCtrls,
  FP_2027FsOutFiles, uADStanIntf, uADStanOption, uADStanParam, uADStanError,
  uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager,
  uADGUIxIntf, uADStanDef, uADStanPool, uADPhysManager, uADCompClient,
  uADCompDataSet;

type
  TTrustReconciliation = class(TForm)
    Panel3: TPanel;
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    datasource2: TDataSource;
    Label1: TLabel;
    DBNavigator1: TDBNavigator;
    DBGrid2: TDBGrid;
    DBGrid1: TDBGrid;
    Label2: TLabel;
    DBNavigator2: TDBNavigator;
    Panel1: TPanel;
    ShowOnlyBox: TRadioGroup;
    PutOnHoldBtn: TBitBtn;
    PutHOReadyBtn: TBitBtn;
    ExpectedDepositsQ: TADQuery;
    eFDConnection: TADConnection;
    TransactionsQ: TADQuery;
    tFDConnection: TADConnection;
    procedure CancelBtnClick(Sender: TObject);
    procedure OpenTransactionsQ;
    procedure OpenExpectedDepositsQ;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OpenQueries;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure ShowOnlyBoxClick(Sender: TObject);
    Function  GetStatusToShow:String;
    procedure PutOnHoldBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure PutHOReadyBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TrustReconciliation: TTrustReconciliation;
  St : String;

implementation

{$R *.DFM}


procedure TTrustReconciliation.OpenExpectedDepositsQ;
Var WhereClause:String;
begin
 eFDConnection.Params.Values['DataBase'] := cfgClientsDbLite_noUse;//20150922 Igor

 ExpectedDepositsQ.Close;
 ExpectedDepositsQ.SQL.Clear;
 St := GetStatusToShow;
 WhereClause := ' where '
  + 'Trim(TransactionType) = ' + '"' + '5' + '"'
  + ' AND Trim(Status) = ' + '"' + St + '"';

 With  ExpectedDepositsQ do
 begin
 SQL.Add('Select ');
 SQL.Add(' AgentCode, LastUpdate, ClientId, Sum(GrossAmount) as TotalAmount');
 SQL.Add('from Transactions');
 SQL.Add( WhereClause);
 SQL.Add(' GROUP BY AgentCode, LastUpdate, ClientId');
 Prepare;
 open;
 end;
end;


procedure TTrustReconciliation.OpenTransactionsQ;
Var WhereClause:String;
 Dt,CurrentAgent,CurrentClient:String;
begin
 tFDConnection.Params.Values['DataBase'] := cfgClientsDbLite_noUse;//20150922 Igor

 If ExpectedDepositsQ.RecordCount = 0 then
  begin TransactionsQ.Close; exit; end;
 TransactionsQ.Close;
 TransactionsQ.SQL.Clear;
 St           := GetStatusToShow;
 CurrentAgent := ExpectedDepositsQ['AgentCode'];
 CurrentClient:= ExpectedDepositsQ['ClientId'];
 Dt           := ExpectedDepositsQ['LastUpdate'];

 WhereClause := ' where '
  + ' Trim(LastUpdate) = ' + '"' + Dt + '"'
  + ' AND Trim(Status) = ' + '"' + St + '"'
  + ' AND Trim(AgentCode) = ' + '"' + CurrentAgent + '"'
  + ' AND Trim(ClientId) = ' + '"' + CurrentClient + '"';

 With TransactionsQ do
 begin
 SQL.Add('Select * from Transactions');
 SQL.Add( WhereClause);
 Prepare;
 open;
 end;
end;

procedure TTrustReconciliation.CancelBtnClick(Sender: TObject);
begin
 If TransactionsQ.Active then TransactionsQ.Close;
 If ExpectedDepositsQ.Active then ExpectedDepositsQ.Close;
 Close;
end;

procedure TTrustReconciliation.FormCreate(Sender: TObject);
begin
 FormatSettings.DecimalSeparator:='.'; //20150817 igor
 ShowOnlyBox.ItemIndex :=0;
 Screen.Cursor := crHourGlass;
 OpenQueries;
 Screen.Cursor := crDefault;
end;

procedure TTrustReconciliation.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
CancelBtnClick(Sender);
end;

procedure TTrustReconciliation.OpenQueries;
begin
 OpenExpectedDepositsQ;
 OpenTransactionsQ;
end;

procedure TTrustReconciliation.DBGrid1CellClick(Column: TColumn);
begin
 OpenTransactionsQ;
end;

procedure TTrustReconciliation.ShowOnlyBoxClick(Sender: TObject);
begin
 OpenQueries;
 Paint;
end;

Function TTrustReconciliation.GetStatusToShow:String;
begin
 If ShowOnlyBox.ItemIndex=0 then
  result:='HO Ready'
 else
  result:= 'Hold';
end;

procedure TTrustReconciliation.FormPaint(Sender: TObject);
begin
 If ShowOnlyBox.ItemIndex = 0 then
  begin
   PutOnHoldBtn.Enabled := True;
   PutHOReadyBtn.Enabled := False;
  end
 else
  begin
   PutOnHoldBtn.Enabled := False;
   PutHOReadyBtn.Enabled := True;
  end;
end;

procedure TTrustReconciliation.PutOnHoldBtnClick(Sender: TObject);
begin
 If TransactionsQ.RecordCount = 0 then exit;
 Screen.Cursor := crHourGlass;
 With TransactionsQ do
 begin
  DisableControls;
  First;
  Repeat
   Edit;
   FieldByName('Status').AsString := 'Hold';
   Post;
   Next;
  until TransactionsQ.Eof;
  EnableControls;
 end;
 ShowOnlyBox.ItemIndex := 1;
 OpenQueries;
 Screen.Cursor := crDefault;
end;

procedure TTrustReconciliation.PutHOReadyBtnClick(Sender: TObject);
begin
 If TransactionsQ.RecordCount = 0 then exit;
 Screen.Cursor := crHourGlass;
 With TransactionsQ do
 begin
  DisableControls;
  First;
  Repeat
   Edit;
   FieldByName('Status').AsString := 'HO Ready';
   Post;
   Next;
  until TransactionsQ.Eof;
  EnableControls;
 end;
 ShowOnlyBox.ItemIndex := 0;
 OpenQueries;
 Screen.Cursor := crDefault;
end;


end.
