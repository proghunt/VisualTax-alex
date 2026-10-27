unit Umclnt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids, DB, DBTables, StdCtrls, Buttons,
  ExtCtrls, DBCtrls,
  UDeclare,TrimStr;

type
  TClients = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    BitBtn1: TBitBtn;
    ListBox1: TListBox;
    DBNavigator1: TDBNavigator;
    ClearBtn: TBitBtn;
    PrintLabelsBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    FilterBtn: TBitBtn;
    LblCount: TLabel;
    Label1: TLabel;
    Query1: TQuery;
    Query1NAME: TStringField;
    Query1NC: TStringField;
    Query1CD: TStringField;
    Query1IN: TStringField;
    Query1PR: TStringField;
    Query1T1: TStringField;
    Query1T2: TStringField;
    Query1T3: TStringField;
    Query1T4: TStringField;
    Query1FP: TStringField;
    Query1AR: TStringField;
    Query1ORDATE: TStringField;
    Query1PAID: TFloatField;
    Query1GST: TFloatField;
    Query1PST: TFloatField;
    Query1HST: TFloatField;
    Query1CONTACT: TStringField;
    Query1STREET: TStringField;
    Query1CITY: TStringField;
    Query1PROVINCE: TStringField;
    Query1POSTAL: TStringField;
    Query1AREAP: TStringField;
    Query1PHONE: TStringField;
    Query1AREAF: TStringField;
    Query1FAX: TStringField;
    Query1EMAIL: TStringField;
    Query1PROVTAX: TFloatField;
    Query1INVOICENO: TStringField;
    Query1DISCOUNT: TFloatField;
    Query1NOTES: TStringField;
    Label2: TLabel;
    WhereBox: TEdit;
    Label3: TLabel;
    DBCountLbl: TLabel;
    CopyAllBtn: TBitBtn;
    Label4: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure PrintLabelsBtnClick(Sender: TObject);
    procedure FilterBtnClick(Sender: TObject);
    Procedure ShowCount;
    procedure OpenClientsQ;
    procedure CopyAllBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Clients: TClients;
  WhereClause:String;
  
implementation

{$R *.DFM}

procedure TClients.BitBtn1Click(Sender: TObject);
begin
Close;
end;

procedure TClients.DBGrid1DblClick(Sender: TObject);
begin
 ListBox1.Items.Add(Query1.FieldByName('Name').AsString);
 ShowCount;
end;

Procedure TClients.ShowCount;
begin
 LblCount.Caption := IntToStr(ListBox1.Items.Count);
 LblCount.Refresh;
end;

procedure TClients.FormCreate(Sender: TObject);
begin
ListBox1.Clear;
try
 WhereClause:='';
 OpenClientsQ;

 (*
 If Table1.Active then Table1.Close;
 Table1.DataBaseName := AppDir;
 Table1.TableName := 'Clients.DBF';
 Table1.IndexName := 'NAME';
 Table1.Open;
 *)
except
 ShowMessage('cannot open data base');
end;
end;

procedure TClients.ClearBtnClick(Sender: TObject);
begin
ListBox1.Clear;
ShowCount;
end;

procedure TClients.PrintLabelsBtnClick(Sender: TObject);
Var i,ndx,FNo:Integer; Tbl:TTable;FlName,FName :String;
  FileNm:String;F1:textFile; S:string;
  KeysForLabels: TStringList;
begin
 {
 if MessageDlg('If you print labels from the 1996 data base,'+Chr(13)
      + 'you must re-build the Client Data Base at least once'+
      + Chr(13)+'using Utilities|Re-Build or Recalculate and Save'+
        Chr(13)+'Have you done it?',
        mtInformation, [mbYes, mbNo], 0) = mrNo then
        exit;
 }
 if MessageDlg('Load laser printer label sheets (2 5/8" X 1" (3 columns)'+
        Chr(13)+'Ready?',
        mtInformation, [mbYes, mbNo], 0) = mrNo then
        exit;

 If ListBox1.Items.Count =0 then exit;
 KeysForLabels := TstringList.Create;
 For i := 0 to ListBox1.Items.Count-1 do
  KeysForLabels.Add(LeftStr(ListBox1.Items[i],34));
 FileNm:=AppDir+'\'+'TempFile';
 KeysForLabels.SaveToFile(FileNm);
 KeysForLabels.Free;
 If PrintDialog1.Execute then PrintLabels(AppDir,FileNm);
 exit;
end;


procedure TClients.FilterBtnClick(Sender: TObject);
begin
If AllTrim(Wherebox.Text) = '' then
  WhereClause:=''
else
 WhereClause:='WHERE ' +WhereBox.Text;
OpenClientsQ;
(*
 ListBox1.Clear;
{this is a comment line....  }
 With table1 do
 begin
   First;
   Repeat
    If FieldByName('OrDate').AsString > ' ' then
    begin
     If (FieldByName('T2').AsString = '2')
     or (FieldByName('T3').AsString = '3')
     or (FieldByName('FP').AsString = 'F')
     then
      ListBox1.Items.Add(FieldByName('NAME').AsString);
    end;
     ShowCount;
    Next;
   until Eof;
 end;
*)
end;


procedure TClients.OpenClientsQ;
Const Star='*';
begin
 
 Try
 Query1.Close;
 Query1.SQL.Clear;
 {Build where clause}
 (*
 If Client >'' then
  WhereClause := ' where ' + 'ClientId = ' + '"' + Client + '"'
 else
  WhereClause:= ' Where ClientId LIKE ' + '"' + Star + '"';
 *)
 (*
 WhereClause := WhereClause+ ' and ' +
      'DateCreated >= '''+DateFrom.Text+''' ';
 WhereClause := WhereClause+ ' and ' +
      'DateCreated <= '''+DateTo.Text+''' ';
 *)

 {------------}
 With Query1 do
 begin
 SQL.Add('Select * ');
 SQL.Add('from Clients');
 If AllTrim(WhereClause) <> '' then SQL.Add(WhereClause);
 {If RightStr(WhereClause,1) <> star then SQL.Add(WhereClause);}
 SQL.Add( 'ORDER BY Name');
 Prepare;

 open;
 DbCountLbl.Caption := IntToStr(Query1.RecordCount);
 {good only for local db and SELECT statement on Client server}
 {Query1.ExecSql;}  {good for INSERT, UPDATE, DELETE, and CREATE TABLE and client server db as well}
 end;
 Except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
end;


procedure TClients.CopyAllBtnClick(Sender: TObject);
begin
 Query1.First;
 Repeat
  ListBox1.Items.Add(Query1.FieldByName('Name').AsString);
  Query1.Next;
 until Query1.EOF;
 ShowCount;
end;

end.
