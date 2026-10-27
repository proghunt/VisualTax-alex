unit FP_2027exportTRN;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,TabNotBk,StdCtrls,Buttons,ComCtrls,FileCtrl,ExtCtrls,Grids,Db,
  DBGrids,Mask,DBCtrls, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompClient, uADCompDataSet;

type
  TExportTRNFP_2012 = class(TForm)
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
    FilesOutBox: TEdit;
    DealerOrBranchBox: TRadioGroup;
    DBMemo1: TDBMemo;
    ClientsSource: TDataSource;
    AccountsSrc: TDataSource;
    GroupBox5: TGroupBox;
    Label8: TLabel;
    Label9: TLabel;
    DateFrom: TEdit;
    DateTo: TEdit;
    ExportOneBtn: TBitBtn;
    FDConnection: TADConnection;
    TransactionsQ: TADQuery;
    TransactionsExportQ: TADQuery;
    AccountsTbl: TADTable;
    ClientsTbl: TADTable;

    Function DateToMDD(Dt:TDateTime;TestOrProduction:Integer):String;
//    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OpenTransactionsQ;
    procedure OpenTransactionsExportQ;
    procedure SetForAllBtnClick(Sender: TObject);
    procedure SetForSelectedBtnClick(Sender: TObject);
    {procedure ChangeStatus(NewStatus,TransId:String);}
    procedure ChangeFsToBranch(TransId:String);
    procedure OKBtnClick(Sender: TObject);
    Procedure GetDistinctClients(Var ClientList:TStringList);
    Function  EditScreen:Boolean;
    Procedure GetNewDistinctAccounts(Client:String;Var AccountList:TStringList);
    {procedure DealerOrBranchBoxClick(Sender: TObject);}
    Function  AccountExists(ASupplier,AClientId,AnAccount:String):Boolean;
    procedure DateFromKeyPress(Sender: TObject; var Key: Char);
    procedure DateToKeyPress(Sender: TObject; var Key: Char);
    procedure DateFromDblClick(Sender: TObject);
    procedure DateToDblClick(Sender: TObject);
    procedure DateToExit(Sender: TObject);
    procedure ExportOne;
    procedure ExportOneBtnClick(Sender: TObject);
    procedure TransactionsQCalcFields(DataSet: TDataSet);
//    procedure DealerOrBranchBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportTRN: TExportTRNFP_2012;
  {
  FSOutDir   :String;
  RecCount:Integer;
  BufferRec : AnsiString;
  }

implementation

{$R *.DFM}

uses FP_2027,FP_2027Declare,FP_2027TrimStr,FP_2027Common,vtTrimStr,vtShared,
  vtMulti; //20170112 Igor

Function TExportTRNFP_2012.DateToMDD(Dt:TDateTime;TestOrProduction:Integer):String;
{MDD  8.3 format}
Const ProductionMonths = 'ABCDEFGHIJKL';
Const testMonths       = 'MNOPQRSTUVXYZ';
Var YYYY,MM,DD:Word; M:string; //[1];
begin
  DecodeDate(Dt,YYYY,MM,DD);
  If TestOrProduction = 1 then m:=TestMonths[mm] else m:=ProductionMonths[mm];
  result := m+PaddZero(IntToStr(DD),2);
end;

procedure TExportTRNFP_2012.OpenTransactionsQ;
Var WhereClause:String; Br:string; //[4];
begin
 Screen.Cursor := crHourGlass;
 FDConnection.Params.Values['DataBase']:=cfgClientsDbLite_noUse;//20150920 Igor
 TransactionsQ.Close;
 TransactionsQ.SQL.Clear;

 WhereClause:='';

 WhereClause := ' where '
  + 'FsToBranch <> ' + '"' + 'Y' + '"';

 WhereClause := WhereClause+ ' and ' +
      'LastUpdate >= '''+DateFrom.Text+''' ';
 WhereClause := WhereClause+ ' and ' +
      'LastUpdate <= '''+DateTo.Text+''' ';

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
 Screen.Cursor := crDefault;
end;

procedure TExportTRNFP_2012.OpenTransactionsExportQ;
{the one displayed has calculated fields!}
Var WhereClause:String;
begin
 FDConnection.Params.Values['DataBase']:=cfgClientsDbLite_noUse;//20150920 Igor
 TransactionsExportQ.Close;
 TransactionsExportQ.SQL.Clear;
 WhereClause:='';

 WhereClause := ' where '
  + 'FsToBranch <> ' + '"' + 'Y' + '"';

 WhereClause := WhereClause+ ' and ' +
      'LastUpdate >= '''+DateFrom.Text+''' ';
 WhereClause := WhereClause+ ' and ' +
      'LastUpdate <= '''+DateTo.Text+''' ';

 With TransactionsExportQ do
 begin
 SQL.Add('Select * from Transactions');
 SQL.Add( WhereClause);
 Sql.Add( ' ORDER BY TransactionId');
 Prepare;
 open;
 end;
end;


Procedure TExportTRNFP_2012.GetDistinctClients(Var ClientList:TStringList);
Var WhereClause:String;
    ADConnection: TADConnection;
    TempQ:TADQuery;
begin
  WhereClause := ' where '
  + 'Trim(Status) = ' + '"' + 'HO Ready' + '"';

  //20150921 Igor
  ADConnection:= TADConnection.Create(Application);
  ADConnection.Params.Values['DataBase']:=cfgClientsDbLite_noUse;//20150920 Igor
  TempQ := TADQuery.Create(Application);

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


Procedure TExportTRNFP_2012.GetNewDistinctAccounts(Client:String;Var AccountList:TStringList);
Const NewAcc='NEW';
Var WhereClause:String;
    TempQ:TADQuery;
    ADConnection: TADConnection;
begin
   {only new accounts}
   WhereClause := ' Where '
   +'('+ 'Trim(ClientId) = ' + '"' +  Client + '"';
   WhereClause := WhereClause
   + ' AND Trim(Status) = ' + '"' + 'HO Ready' + '"';

   WhereClause := WhereClause
   +' AND '+ 'Trim(Account) Like ' + '"' +  NewAcc + '"' +')';

  //20150921 Igor
  ADConnection:= TADConnection.Create(Application);
  ADConnection.Params.Values['DataBase']:=cfgClientsDbLite_noUse;//20150920 Igor
  TempQ := TADQuery.Create(Application);

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

procedure TExportTRNFP_2012.CancelBtnClick(Sender: TObject);
begin
 If TransactionsQ.Active then TransactionsQ.Close;
 If TransactionsExportQ.Active then TransactionsExportQ.Close;
 If ClientsTbl.Active then ClientsTbl.Close;
 FsFldList.Free;
end;


procedure TExportTRNFP_2012.SetForAllBtnClick(Sender: TObject);
Var TransId:string; //[20];
begin
 TransId := 'ALL';
 ChangeFsToBranch(TransId);
end;

procedure TExportTRNFP_2012.SetForSelectedBtnClick(Sender: TObject);
Var TransId:string; //[20];
begin
 TransId := TransactionsQ.FieldByName('TransactionId').AsString;
 ChangeFsToBranch(TransId);
end;

procedure TExportTRNFP_2012.ChangeFsToBranch(TransId:String);
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
    FieldByName('FsToBranch').AsString := 'Y';
    Post;
   end
   else
   begin
    if FieldByName('TransactionId').AsString = TransId then
      begin
       FieldByName('FsToBranch').AsString := 'Y';
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

procedure TExportTRNFP_2012.TransactionsQCalcFields(DataSet: TDataSet);
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

Function TExportTRNFP_2012.EditScreen:Boolean;
Var FlName:String; FilesOutDir:String;
begin
  Result:=True;
  {
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
  }
  If Not DirectoryExists(FilesOutBox.Text) then
  begin
   ShowMessage('FilesOut directory does not exist. Check Set-up');
   FilesOutBox.SetFocus;
   Result:=False;
   exit;
  end;

  If LeftStr(FilesOutBox.text,1) = '?' then
  begin
   ShowMessage('Cannot determine the FilesOut directory or invalid Branch code');
   Result:=False;
   exit;
  end;
  {
  If FileExists(FilesOutDir+'\'+FlName) then
  begin
   ShowMessage('File name already exists. Try again');
   Result:=False;
   exit;
  end;
  }
end;

procedure TExportTRNFP_2012.OKBtnClick(Sender: TObject);
Const DbName='FpClients';
Var i,j,k:Integer;{TblNames:TStringList;}
    FlName:String; FilesOutDir:String; F1:TextFile;
    ClientList,FormNames,AccountList:TstringList;
begin
 Try
  If TransactionsQ.RecordCount =0 then exit;
  {
  If (DealerOrBranchBox.ItemIndex =0) and
   (AllTrim(GetHoBranch) = '') then
  begin
   ShowMessage('The Dealer Branch has not been defined in configuration');
   exit;
  end;
  }
  Screen.Cursor := crHourGlass;
  OpenTransactionsExportQ; {the other one has calculated fields!}
  If EditScreen = false then exit;
  TransactionsExportQ.First;
  Repeat
    ExportOne;
    (*
    FlName := User.Branch
                 + '-'+LeftStr(TransactionsQ['Transaction'],4)
                 +'-'+ConvertDateToMdd(Now)
                 +'-'+GetTheTime(now)
                 +'.'+'ORD';
    FilesOutDir := FilesOutBox.Text;
    AssignFile(F1, FilesOutDir+'\'+FlName);
    Rewrite(F1);
    {Now do the transactions for all clients on screen}
    WriteLn(F1,AppName+Delimiter+AppYear+Delimiter+AppVersion+Delimiter+'');
    {Write header rec}
    WriteLn(F1,'T'+Delimiter+DBName+Delimiter+'TRANSACTIONS'+Delimiter+'');
    {get the transactionid value}
    For j:=0 to TransactionsExportQ.FieldCount-1 do
    begin
     If UpperCase(TransactionsExportQ.Fields[j].FieldName) = 'TRANSACTIONID' then
      WriteLn(F1,'K'+Delimiter+'TransactionId'+Delimiter
        +TransactionsExportQ.Fields[j].AsString+Delimiter+'');
    end;
    For j:=0 to TransactionsExportQ.FieldCount-1 do
    begin
      WriteLn(F1, 'E'+Delimiter+TransactionsExportQ.Fields[j].FieldName+Delimiter+
        TransactionsExportQ.Fields[j].AsString+Delimiter+'');
    end;
    CloseFile(F1);
    *)
    TransactionsExportQ.Next;
  until TransactionsExportQ.Eof;

  FormNames.Free;
  AccountList.Free;
  Screen.Cursor := crDefault;
  ShowMessage('Completed');
 except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
end;

procedure TExportTRNFP_2012.ExportOne;
Const DbName='FpClients';
Var i,j,k:Integer;{TblNames:TStringList;}
    FlName:String; FilesOutDir:String; F1:TextFile;
    ClientList,FormNames,AccountList:TstringList;
begin
    Screen.Cursor := crHourGlass;
    FlName := User.Branch //20170112 Igor
                 + '-'+LeftStr(TransactionsQ['TransactionId'],4)
                 +'-'+ConvertDateToMdd(Now)
                 +'-'+GetTheTime(now)
                 +'.'+'TRN';
    FilesOutDir := FilesOutBox.Text;
    AssignFile(F1, FilesOutDir+'\'+FlName);
    Rewrite(F1);
    {Now do the transactions for all clients on screen}
    WriteLn(F1,AppName+Delimiter+AppYear+Delimiter+AppRelease+Delimiter+'');
    {Write header rec}
    WriteLn(F1,'T'+Delimiter+DBName+Delimiter+'TRANSACTIONS'+Delimiter+'');
    {get the transactionid value}
    For j:=0 to TransactionsQ.FieldCount-1 do
    begin
     If UpperCase(TransactionsQ.Fields[j].FieldName) = 'TRANSACTIONID' then
      WriteLn(F1,'K'+Delimiter+'TransactionId'+Delimiter
        +TransactionsQ.Fields[j].AsString+Delimiter+'');
    end;
    For j:=0 to TransactionsQ.FieldCount-1 do
    begin
      If (TransactionsQ.Fields[j].FieldName <> 'ClientName')
      and (TransactionsQ.Fields[j].FieldName <> 'TransType') {calcd fields}
       then
       WriteLn(F1, 'E'+Delimiter+TransactionsQ.Fields[j].FieldName+Delimiter+
        TransactionsQ.Fields[j].AsString+Delimiter+'');
    end;
    CloseFile(F1);
   Screen.Cursor := crDefault;
end;

Function TExportTRNFP_2012.AccountExists(ASupplier,AClientId,AnAccount:String):Boolean;
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


procedure TExportTRNFP_2012.DateFromKeyPress(Sender: TObject;
  var Key: Char);
begin
If Key=#13 then OpenTransactionsQ
 else
 begin
   Key := Chr(0);
   DateFromDblClick(Sender);
 end;
end;

procedure TExportTRNFP_2012.DateToKeyPress(Sender: TObject;
  var Key: Char);
begin
  If Key=#13 then
   OpenTransactionsQ
  else
  begin
   Key := Chr(0);
   DateToDblClick(Sender);
  end;

end;

procedure TExportTRNFP_2012.DateToDblClick(Sender: TObject);
 Var ADate:string; //[10];
begin
   ADate:= FetchADate;
   If ADate>'' then
   Begin
     DateTo.Text := ADate;
     OpenTransactionsQ;
   end;
end;

procedure TExportTRNFP_2012.DateFromDblClick(Sender: TObject);
 Var ADate:string; //[10];
begin
   ADate:= FetchADate;
   If ADate>'' then
   begin
    DateFrom.Text := ADate;
    OpenTransactionsQ;
   end;

end;

procedure TExportTRNFP_2012.DateToExit(Sender: TObject);
begin
OpenTransactionsQ;
end;

procedure TExportTRNFP_2012.ExportOneBtnClick(Sender: TObject);
begin
 If EditScreen = false then exit;
 If TransactionsQ.FieldByName('FsToBranch').AsString = 'Y' then
  begin
   ShowMessage('Already exported!');
   Exit;
  end;
 ExportOne;
 With TransactionsQ do
 begin
  Edit;
  FieldByName('FsToBranch').AsString := 'Y';
  Post;
 end;
 ShowMessage('Done. Record removed from list');
end;

(*
procedure TExportTRN.DealerOrBranchBoxClick(Sender: TObject);
begin
 Case DealerOrBranchBox.ItemIndex  of
  0: ThisFilesOutDir := HoRec.FilesOutDir;
  1: ThisFilesOutDir :=  GetBranchFieldValue(FpUser.Branch,'AgentsFilesOutDir');
 end;
end;
*)
end.
