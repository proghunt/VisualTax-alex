unit Efer;
{
STEP 1
Convert Ch2-xxe.pdf we get from CRA using the VeryPdf PdfToTxt
into a text file Ch2-xxe.txt.
Note: Copy also any revisions to Ch2 to EFErrors.TXT also

Then clean up the txt file before using it to create the data base.
Some examples:
Remove all lines starting with end of file indicator (Alt 012)
Remove all header lines 'ERROR CODES...'
ENSURE: Each line has at least 6 empty spaces in front
Keys must be 6 characters
Use UltraEdit and replace tabs with spaces
Use Advanced and wrap at window end of the full file
Client's appears as client##'  Play with File Conversion .
UTF-8 to Acii then again ? until it comes as ? then
global ? to '

STEP 2:
Clear data base Eferr.dbf before adding the new stuff - using Delphi Tools
Put introduction text as code 0
}
interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, Mask, ExtCtrls,Dialogs,
  UDecl,{TrimStr,UDeclare,} Grids, DBGrids, Buttons, Data.DbxSqlite, //20160204 Igor
  Data.FMTBcd, Data.SqlExpr, Datasnap.Provider, Datasnap.DBClient;

type
  Teferrform = class(TForm)
    DataSource1: TDataSource;
    Button1: TButton;
    CancelBtn: TButton;
    Memo1: TMemo;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    DBMemo1: TDBMemo;
    Label3: TLabel;
    Label4: TLabel;
    SQLConnection: TSQLConnection; //20160204 Igor
    SQLQuery1: TSQLQuery; //20160204 Igor
    ClientDataSet1: TClientDataSet; //20160204 Igor
    SQLTable: TSQLQuery; //20160204 Igor
    Button2: TButton; //20160204 Igor
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    Function NewErrorLine(InpLine:String):Boolean;
    Function ExtractErrCode(InpLine:String):String;
    procedure Button2Click(Sender: TObject); //20160204 Igor


  private
    { private declarations }
    procedure reloadData; //20160204 Igor
  public
    { public declarations }
  end;

var
  AppDir:String;
  eferrform: Teferrform;
  Errlist  : TStringList;
CONST
  DBName: String = 'EfErrors.db'; //20160204 Igor
  TableName: String = 'EfErrors'; //20160204 Igor
implementation

{$R *.DFM}

function RightStr(Const Str: String; Size: Word): String; //20160204 Igor
var len: Byte absolute Str;
begin
  if Size > len then Size := len;
  Result := Copy(Str,len-Size+1,Size)
  {RightStr := Copy(Str,len-Size+1,Size)}
end {RightStr};

function LeftStr(Const Str: String; Size: Word): String; //20160204 Igor
begin
  {LeftStr := Copy(Str,1,Size)}
  Result := Copy(Str,1,Size)
end {LeftStr};

function MidStr(Const Str: String;StartPos: Word; Size: Word): String; //20160204 Igor
var len: Byte absolute Str;
begin
  Result := Copy(Str,StartPos,Size);
end {MidStr};

Function Numeric(S:string):Boolean; //20160204 Igor
Var
  i:integer;
begin
  If s ='' then
    exit(false)
  else
  begin
    Result := True;
    For i:= 1 to Length(S) do
      If not charInSet(S[i], ['0','1','2','3','4','5','6','7','8','9']) then
      begin
        exit(False);
        Exit;
      end;
  end;
end;

procedure Teferrform.FormCreate(Sender: TObject);
Var TXTFileName:String;
  FullDBName: String; //20160204 Igor
  SQLCreateDataBase: String; //20160204 Igor
  NeedCreateTable : Boolean; //20160204 Igor
begin
  FullDBName := ExtractFilePath(Application.ExeName)+DBName; //20160204 Igor

  AppDir := ExtractFilePath(Application.ExeName);
  (* Original file coming from the government is Ch2-15e.pdf
  We used a PdfToTxt program to create the Ch2-15e.txt
  We cleaned it up manually so it contains only
  the error code (6 characters) and the descriptions
  *)
  TxtFileName:= 'Ch2-15e.txt';
  ErrList := TStringList.Create;
  ErrList.Loadfromfile(AppDir+TxtFileName);
 //20160204 Igor >>>>>>
  NeedCreateTable := not fileExists(FullDBName);
  SQLConnection.Params.Values['Database'] := FullDBName;
  try
    SQLConnection.Open;
  except
    ShowMessage ('Error open SqliteSchema: ' + FullDBName);
    exit;
  end;
  if NeedCreateTable then
  Begin
    SQLCreateDataBase := 'CREATE TABLE '+TableName+'(CODE VARCHAR(12) NOT NULL, DESCR Text NULL)';
    try
      SQLConnection.Execute(SQLCreateDataBase, nil);
    except
      ShowMessage ('Error create table: '+TableName);
      exit;
    end;
    SQLCreateDataBase := 'CREATE Unique INDEX idx_Code ON '+TableName+'(CODE)';
    try
      SQLConnection.Execute(SQLCreateDataBase, nil);
    except
      ShowMessage ('Error create index idx_Code');
      exit;
    end;
  End;


  reloaddata;

//  If not Table1.Active then
//   begin
//   Table1.DataBaseName := AppDir; //'C:\delphi\t1\mkefdb';
//   Table1.TableName := 'EfErrors.dbf';
//   Table1.IndexName := 'Code';
//   Table1.Open;
//   Table1.First;
//   end;
 //20160204 Igor <<<<<<<<
   DbGrid1.Refresh;
end;

procedure Teferrform.Button1Click(Sender: TObject);
Var I:integer; ErrCode :string;
SQLExec: String; //20160204 Igor
begin
  Memo1.Clear; ErrCode:='';
  For i:=0 to ErrList.Count-1 do
  begin
     If NewErrorLine(ErrList[i]) then
       begin
         Memo1.Refresh;
         {ShowMessage('');}
         If ErrCode > '' then  {write to data base}
         begin
 //20160204 Igor >>>>>>
            If ClientDataSet1.Locate('Code',ErrCode,[]) then
              SQLExec := 'Update '+TableName+' SET DESCR = '+QuotedStr(Memo1.lines.Text)+' Where CODE = '+QuotedSTR(ErrCode)
            else
              SQLExec := 'INSERT INTO '+TableName+' (CODE, DESCR) VALUES ('+QuotedSTR(ErrCode)+' , '+QuotedStr(Memo1.lines.Text)+')';
            SQLQuery1.SQL.Text := SQLExec;
            SQLQuery1.ExecSQL;
 //20160204 Igor  <<<<<<<
         end;
         Memo1.Clear;
         ErrCode := ExtractErrCode(ErrList[i]);
         Memo1.Lines.Add(trim(ErrList[i]));
         {Memo1.text := Memo1.Text+ErrList[i];}

       end
      else
        Memo1.Lines.Add(Trim(ErrList[i]));
       {Memo1.text := Memo1.Text+ErrList[i];}

  end;
  {Last error block}
 //20160204 Igor >>>>>>>
  If ClientDataSet1.Locate('Code',ErrCode,[]) then
    SQLExec := 'Update '+TableName+' SET DESCR = '+QuotedStr(Memo1.lines.Text)+' Where CODE = '+QuotedSTR(ErrCode)
  else
    SQLExec := 'INSERT INTO '+TableName+' (CODE, DESCR) VALUES ('+QuotedSTR(ErrCode)+' , '+QuotedStr(Memo1.lines.Text)+')';
  SQLQuery1.SQL.Text := SQLExec;
  SQLQuery1.ExecSQL;
 //20160204 Igor<<<<<<<<<  
  DbGrid1.Refresh;
  ShowMessage('Done');
end;


Function Teferrform.NewErrorLine(InpLine:String):Boolean;
Begin

 Result := (Length(InpLine)>0) AND (InpLine[1]<>' '); //20160204 Igor
//
// If (Numeric(Trim(LeftStr(InpLine,6))))   {123}
// or (Numeric(Trim(LeftStr(InpLine,5))))   {123}  //20140209
// or ((LeftStr(InpLine,1)='Y') and (Numeric(MidStr(InpLine,2,1))))  {Y1...}
// or ((Numeric(LeftStr(InpLine,1)) and (MidStr(InpLine,2,4)='NNNN'))) {5NNNN}
// then
//  Result := True
// else
//  Result := False;
End;

procedure Teferrform.reloadData; //20160204 Igor
begin
  SQLTable.Active := False;
  SQLTable.Active := True;
  if not ClientDataSet1.Active then
    ClientDataSet1.CreateDataSet;
  ClientDataSet1.Active := true;
  ClientDataSet1.EmptyDataSet;
  while not SQLTable.Eof do
  Begin
    ClientDataSet1.Append;
    ClientDataSet1.FieldByName('CODE').AsString := SQLTable.FieldByName('CODE').AsString;
    ClientDataSet1.FieldByName('DESCR').AsString := SQLTable.FieldByName('DESCR').AsString;
    ClientDataSet1.Post;
    SQLTable.Next;
  End;
end;

Function Teferrform.ExtractErrCode(InpLine:String):String;
Begin
  Result := Copy(InpLine, 1 ,pos(' ',InpLine)-1);  //20160204 Igor
End;

procedure Teferrform.Button2Click(Sender: TObject);
begin
  reloadData;
end;

procedure Teferrform.CancelBtnClick(Sender: TObject);
begin
  SQLTable.Close; //20160204 Igor
  Close;
end;

end.
