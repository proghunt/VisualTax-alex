unit FP_2027ExportOrders;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,TabNotBk,StdCtrls,Buttons,ComCtrls,FileCtrl,ExtCtrls,Grids,Db,
  DBGrids,Mask,DBCtrls, uADStanIntf, uADStanOption, uADStanParam,
  uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync,
  uADDAptManager, uADGUIxIntf, uADStanDef, uADStanPool, uADPhysManager,
  uADCompClient, uADCompDataSet;

type
  TExportOrdersFP_2012 = class(TForm)
    TransactionsQSrc: TDataSource;
    SetForSelectedBtn: TBitBtn;
    SetForAllBtn: TBitBtn;
    Label2: TLabel;
    Panel3: TPanel;
    CancelBtn: TBitBtn;
    Panel1: TPanel;
    DBGrid2: TDBGrid;
    Panel2: TPanel;
    OKBtn: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    FilesOutBox: TEdit;
    FlNameBox: TEdit;
    DealerOrBranchBox: TRadioGroup;
    DBMemo1: TDBMemo;
    ClientsSource: TDataSource;
    AccountsSrc: TDataSource;
    TransactionsQ: TADQuery;
    FDConnection: TADConnection;
    AccountsTbl: TADTable;
    TransactionsExportQ: TADQuery;
    ClientsTbl: TADTable;

    Function DateToMDD(Dt:TDateTime;TestOrProduction:Integer):String;
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OpenTransactionsQ;
    procedure OpenTransactionsExportQ;
    procedure SetForAllBtnClick(Sender: TObject);
    procedure SetForSelectedBtnClick(Sender: TObject);
    procedure ChangeStatus(NewStatus,TransId:String);
//    procedure OKBtnClick(Sender: TObject);
    Procedure GetDistinctClients(Var ClientList:TStringList);
    Function  EditScreen:Boolean;
    Procedure GetNewDistinctAccounts(Client:String;Var AccountList:TStringList);
//    procedure DealerOrBranchBoxClick(Sender: TObject);
    Function  AccountExists(ASupplier,AClientId,AnAccount:String):Boolean;
    procedure TransactionsQCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportOrders: TExportOrdersFP_2012;
  {
  FSOutDir   :String;
  RecCount:Integer;
  BufferRec : AnsiString;
  }

implementation

{$R *.DFM}

uses FP_2027,FP_2027Declare,FP_2027TrimStr,FP_2027Common, vtTrimStr, vtShared, vtDataBase;

Function TExportOrdersFP_2012.DateToMDD(Dt:TDateTime;TestOrProduction:Integer):String;
{MDD  8.3 format}
Const ProductionMonths = 'ABCDEFGHIJKL';
Const testMonths       = 'MNOPQRSTUVXYZ';
Var YYYY,MM,DD:Word; M:string; //[1];
begin
  DecodeDate(Dt,YYYY,MM,DD);
  If TestOrProduction = 1 then m:=TestMonths[mm] else m:=ProductionMonths[mm];
  result := m+PaddZero(IntToStr(DD),2);
end;

procedure TExportOrdersFP_2012.FormCreate(Sender: TObject);
begin
 DealerOrBranchBox.ItemIndex :=-1;
 FlNameBox.Text := '';
 FilesOutBox.Text := ThisFilesOutDir;
 If Not ClientsTbl.Active then ClientsTbl.Open;
 ClientsTbl.IndexFieldNames := 'ClientId';
 OpenTransactionsQ;
 If TransactionsQ.RecordCount =0 then
   ShowMessage('There are no HO Ready orders for processing');
end;

procedure TExportOrdersFP_2012.OpenTransactionsQ;
Var WhereClause:String;
begin
 Screen.Cursor := crHourGlass;
 TransactionsQ.Close;
 TransactionsQ.SQL.Clear;

 WhereClause := ' where '
  + 'Trim(Status) = ' + '"' + 'HO Ready' + '"';

 With TransactionsQ do
 begin
  SQL.Add('Select * from Transactions');
  SQL.Add( WhereClause);
  Sql.Add( ' ORDER BY TransactionId');
  Prepare;
  Try
   open;
  except
    on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end; {end try}
 end; {with}
 Screen.Cursor := crHourGlass;
end;

procedure TExportOrdersFP_2012.OpenTransactionsExportQ;
{the one displayed has calculated fields!}
Var WhereClause:String;
begin
 TransactionsExportQ.Close;
 TransactionsExportQ.SQL.Clear;

 WhereClause := ' where '
  + 'Trim(Status) = ' + '"' + 'HO Ready' + '"';

 With TransactionsExportQ do
 begin
 SQL.Add('Select * from Transactions');
 SQL.Add( WhereClause);
 Sql.Add( ' ORDER BY TransactionId');
 Prepare;
 open;
 end;
end;



Procedure TExportOrdersFP_2012.GetDistinctClients(Var ClientList:TStringList);
Var WhereClause:String;
    ADConnection: TADConnection;
    TempQ: TADQuery;
begin
  WhereClause := ' where '
  + 'Trim(Status) = ' + '"' + 'HO Ready' + '"';

  //20150923 Igor
  ADConnection:= TADConnection.Create(Application);
  TempQ := TADQuery.Create(Application);
  SqlLoadDBFromFile(ADConnection, TempQ, cfgClientsDbLite_noUse, '');

  With TempQ do
  begin
   SQL.Add('Select DISTINCT ClientId from Transactions');
   SQL.Add( WhereClause);
   SQL.Add( ' ORDER BY ClientId');
   Prepare;
   open;
   First;
   Repeat
     ClientList.Add(TempQ['ClientId']);
     Next;
   until Eof;
   Close;
   Free;
   ADConnection.Free;
  end;
end;

Procedure TExportOrdersFP_2012.GetNewDistinctAccounts(Client:String;Var AccountList:TStringList);
Const NewAcc='NEW';
Var WhereClause:String;
    ADConnection: TADConnection;
    TempQ: TADQuery;
begin
   {only new accounts}
   WhereClause := ' Where '
   +'('+ 'Trim(ClientId) = ' + '"' +  Client + '"';
   WhereClause := WhereClause
   + ' AND Trim(Status) = ' + '"' + 'HO Ready' + '"';

   WhereClause := WhereClause
   +' AND '+ 'Trim(Account) Like ' + '"' +  NewAcc + '"' +')';

  //20150923 Igor
  ADConnection:= TADConnection.Create(Application);
  TempQ := TADQuery.Create(Application);
  SqlLoadDBFromFile(ADConnection, TempQ, cfgClientsDbLite_noUse, '');

  With TempQ do
  begin
   SQL.Add('Select Distinct Account from Transactions ');
   SQL.Add( WhereClause);
   Prepare;
   open;
   First;
   Repeat
     AccountList.Add(TempQ['Account']);
     Next;
   until Eof;
   Close;
   Free;
   ADConnection.Free;
  end;
end;

procedure TExportOrdersFP_2012.CancelBtnClick(Sender: TObject);
begin
 If TransactionsQ.Active then TransactionsQ.Close;
 If TransactionsExportQ.Active then TransactionsExportQ.Close;
 If ClientsTbl.Active then ClientsTbl.Close;
 FsFldList.Free;
end;


procedure TExportOrdersFP_2012.SetForAllBtnClick(Sender: TObject);
Var TransId:string; //[20];
begin
 TransId := 'ALL';
 ChangeStatus('Xmitted',TransId);
end;

procedure TExportOrdersFP_2012.SetForSelectedBtnClick(Sender: TObject);
Var TransId:string; //[20];
begin
 TransId := TransactionsQ.FieldByName('TransactionId').AsString;
 ChangeStatus('Xmitted',TransId);
end;

procedure TExportOrdersFP_2012.ChangeStatus(NewStatus,TransId:String);
begin
If TransactionsQ.RecordCount = 0 then exit;
 Screen.Cursor := crHourGlass;
 With TransactionsQ do
 begin
  DisableControls;
  First;
  Repeat
   Edit;
   If TransId='ALL' then
   begin
    FieldByName('Status').AsString := 'Xmitted';
    Post;
   end
   else
   begin
    if FieldByName('TransactionId').AsString = TransId then
      begin
       FieldByName('Status').AsString := 'Xmitted';
       Post;
      end;
   end;
   Next;
  until TransactionsQ.Eof;
  EnableControls;
 end;
 OpenTransactionsQ;
 If TransactionsQ.RecordCount =0 then
  ShowMessage('All outstanding field orders are now processed');
 Screen.Cursor := crDefault;
end;

procedure TExportOrdersFP_2012.TransactionsQCalcFields(DataSet: TDataSet);
begin
 ShowMessage('rem 20150921 Igor');
 //rem 20150921 Igor
 {TransactionsQTransType.Value := GetTransactionDescription
 (AllTrim(TransactionsQTransactionType.Value)
  +AllTrim(TransactionsQTransactionTypeDetail.Value));

 If ClientsTbl.FindKey([TransactionsQ['ClientId']]) = True then
  TransactionsQClientName.Value :=
    AllTrim(ClientsTbl['LastName'])+ ', '
    +AllTrim(ClientsTbl['FirstName'])
 else
   TransactionsQClientName.Value := '??????';}
end;

Function TExportOrdersFP_2012.EditScreen:Boolean;
Var FlName:String; FilesOutDir:String;
begin
  Result:=True;
  FlName := FlNameBox.Text;
  FilesOutDir := FilesOutBox.Text;

  If DealerOrBranchBox.ItemIndex <0 then
  begin
   ShowMessage('Please select Dealer or Branch'
    +Chr(13)+'A remote Agent should export for his Branch Office');
   DealerOrBranchBox.SetFocus;
   Result:=False;
   exit;
  end;

  If Not DirectoryExists(FilesOutDir) then
  begin
   ShowMessage('FilesOut directory does not exist. Check Set-up');
   FilesOutBox.SetFocus;
   Result:=False;
   exit;
  end;

  If LeftStr(FilesOutDir,1) = '?' then
  begin
   ShowMessage('Cannot determine the FilesOut directory or invalid Branch code');
   Result:=False;
   exit;
  end;

  If FileExists(FilesOutDir+'\'+FlName) then
  begin
   ShowMessage('File name already exists. Try again');
   Result:=False;
   exit;
  end;
end;

Function TExportOrdersFP_2012.AccountExists(ASupplier,AClientId,AnAccount:String):Boolean;
begin
 Result := False;
 With AccountsTbl do
 begin
  First;
  Repeat
    If (FieldByName('Supplier').AsString = ASupplier)
    and (FieldByName('ClientId').AsString = AClientId)
    and (FieldByName('Account').AsString = AnAccount) then
    begin Result := True;Exit;end;
    Next;
  until AccountsTbl.Eof;
 end;
end;



end.
