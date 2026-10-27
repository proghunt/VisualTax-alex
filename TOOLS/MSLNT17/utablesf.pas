unit UTablesF;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, DB, ExtCtrls, Buttons, Grids,
  DBGrids, DBTables,GenRtns,UDecl, ComCtrls, DBCtrls,
  QuickRpt,qrextra, Qrctrls,wwDialog, wwRcdVw,
  UReportFrm;

type
  TTablesF = class(TForm)
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Table1: TTable;
    DataSource1: TDataSource;
    SelectColumnsBtn: TSpeedButton;
    Splitter1: TSplitter;
    PrintLayoutBtn: TSpeedButton;
    ConnectBtn: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    DBGrid1: TDBGrid;
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    Panel4: TPanel;
    RunBtn: TBitBtn;
    QueryGrid: TDBGrid;
    ErrorList: TMemo;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    Query1: TQuery;
    QuerySource: TDataSource;
    DBNavigator1: TDBNavigator;
    StringGrid1: TStringGrid;
    ReportBtn: TSpeedButton;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    ListBox1: TListBox;
    TabSheet5: TTabSheet;
    LoadBtn: TBitBtn;
    SaveBtn: TBitBtn;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ClearBtn: TBitBtn;
    TabSheet6: TTabSheet;
    IndexListBox: TListBox;
    Label2: TLabel;
    RecviewBtn: TBitBtn;
    wwRecordViewDialog1: TwwRecordViewDialog;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure SelectColumnsBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure PrintLayoutBtnClick(Sender: TObject);
    Procedure PrintDBLayout(DBName:String;TblName:String);
    procedure OpenTable(ThisDataBase,ThisTable:String);
    procedure ConnectBtnClick(Sender: TObject);
    procedure DataBaseChange;
    procedure PageControl1Change(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
    procedure OpenQuery;
    Procedure ShowFieldProperties;
    Procedure ShowTableIndexes;
    Procedure CreateAReport;
    procedure ReportBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    Function GetDataType(DtType:Integer):String;
    procedure RecviewBtnClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  TablesF: TTablesF;
  Report : TQuickRep;
implementation

{$R *.DFM}

uses
  FieldsF, DbGridF;

procedure TTablesF.FormCreate(Sender: TObject);
begin
   PageControl1.ActivePage := Tabsheet1;
   Memo1.Clear;
   Session.GetDatabaseNames (ComboBox1.Items);
   ComboBox1.ItemIndex :=0;
   {ComboBox1.Text := 'Dbase Files';}
   ThisDataBase := ComboBox1.Text;
   {
   ComboBox1Change (self);
   ListBox1.ItemIndex := 0;
   ListBox1Click (self);
   }
end;


procedure TTablesF.ComboBox1Change(Sender: TObject);
begin
 ThisDataBase:= ComboBox1.Text;
 DataBaseChange;
end;

procedure TTablesF.DataBaseChange;
begin
  ListBox1.Clear;
  QueryGrid.DataSource := Nil;
  StringGrid1.RowCount :=0;
  Try
  Session.GetTableNames (ThisDataBase, '',
    True, False, ListBox1.Items);
  If ListBox1.Items.Count>0 then
  begin
   ThisDataBase :=ComboBox1.Text;
   ListBox1.ItemIndex:=0;
   ListBox1Click(Self);
  end;
 except
  on E: Exception do
   begin
    MessageDlg(E.Message, mtError, [mbok], 0);
    If Table1.Active then Table1.Close;
    DbGrid1.DataSource:=Nil;
    ListBox1.Clear;
    ListBox1.ItemIndex :=-1;
   end;
 end; {try}
end;

procedure TTablesF.ListBox1Click(Sender: TObject);
begin
  If ListBox1.ItemIndex<0 then exit;
  ThisTable:= Listbox1.Items [Listbox1.ItemIndex];
  If PageControl1.ActivePage = TabSheet1 then
   DbGrid1.DataSource := DataSource1
  else
   DbGrid1.DataSource := Nil;
  OpenTable(ThisDataBase,ThisTable);
  If Query1.Active then Query1.Close;
  Memo1.Lines.Clear;
  Memo1.Lines.Add('Select * from '+ ThisTable);
  ShowFieldProperties;
  ShowTableIndexes;

  If PageControl1.ActivePage = TabSheet2 then RunBtnClick(Sender);{Query}

end;

Procedure TTablesF.ShowFieldProperties;
Var i:Integer;
begin
   StringGrid1.RowCount := Table1.FieldDefs.Count+1;
   StringGrid1.FixedRows := 1;
   StringGrid1.FixedColor := $00D3CBAD;
   StringGrid1.Cells[0,0] := 'Column Name';
   StringGrid1.Cells[1,0] := 'Data Type';
   StringGrid1.Cells[2,0] := 'Column Size';
   For i:=0 to Table1.FieldDefs.Count-1 do
   begin
    StringGrid1.Cells[0,i+1] := Table1.FieldDefs[i].Name;
    StringGrid1.Cells[1,i+1] := GetDataType(Ord(Table1.FieldDefs[i].DataType));
    StringGrid1.Cells[2,i+1] := IntToStr(Table1.FieldDefs[i].Size);
   end;
end;

Procedure TTablesF.ShowTableIndexes;
Var i:Integer;
begin
   IndexListBox.Clear;
  Try
   Table1.IndexDefs.Update;
   For i:=0 to Table1.IndexDefs.Count-1 do
    IndexListBox.Items.add(Table1.IndexDefs.Items[I].Fields);
  except
    IndexListBox.Items.add('** Error: Could not get the indexes');
  end;
end;


procedure TTablesF.OpenTable(ThisDataBase,ThisTable:String);
begin
 Try
  Table1.Close;
  DbGrid1.DataSource:= Nil;
  Table1.DatabaseName := ThisDataBase;
  Table1.Tablename := ThisTable;
  Table1.Open;
  DbGrid1.DataSource := DataSource1;
  Caption := Format ('Table: %s - %s',
    [ThisDataBase,ThisTable]);
  Memo1.Clear; {this is the SQL memo} 
 except
  on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
 end;
end;

procedure TTablesF.SelectColumnsBtnClick(Sender: TObject);
var
  I: Integer;
begin
  FieldsForm.FieldsList.Clear;
  for I := 0 to Table1.FieldCount - 1 do
  begin
    FieldsForm.FieldsList.Items.Add (
      Table1.Fields[I].FieldName);
    FieldsForm.FieldsList.Selected [I] :=
      Table1.Fields[I].Visible;
  end;
  if FieldsForm.ShowModal = mrOk then
    for I := 0 to Table1.FieldCount - 1 do
      Table1.Fields[I].Visible :=
        FieldsForm.FieldsList.Selected [I];
end;

procedure TTablesF.ListBox1DblClick(Sender: TObject);
var
  GridForm: TGridForm;
begin
  (*
  GridForm := TGridForm.Create (self);
  {connect the table component to the selected
  table and activate it}
  GridForm.Table1.DatabaseName := ComboBox1.Text;
  GridForm.Table1.TableName :=
    Listbox1.Items [Listbox1.ItemIndex];
  try
    GridForm.Table1.Open;
    GridForm.Show;
  except
    GridForm.Close;
  end;
  *)
end;

procedure TTablesF.PrintLayoutBtnClick(Sender: TObject);
begin
  PrintDBLayout(ThisDataBase,ThisTable);
end;

Procedure TTablesF.PrintDBLayout(DBName:String;TblName:String);
Var i:Integer;Templist:TStringList;FlName:String;
 Tbl:TTable;

begin
 FlName := 'C:\temp.txt';
 TempList:=TStringList.Create;
 Tbl := TTable.Create(Application);
 Tbl.DataBaseName:= DBName; {extractFilePath(DataBase);}
 {Tbl.DataBaseName := LeftStr(Tbl.DataBaseName,Length(Tbl.DataBaseName)-1);}
 Tbl.TableName := TblName; {ExtractFileName(DataBase);}
 Tbl.Open;
 With Tbl do
 begin
   For i:=0 to Tbl.FieldDefs.Count-1 do
   begin
   TempList.Add(PaddR(FieldDefs[i].Name,15)+' '+
                PaddR(IntToStr(FieldDefs[i].Size),5));
   end;
 end;
 {Tbl.GetFieldNames(TempList);}
 Templist.SaveToFile(FlName);
 TempList.free;
 TblName:= Tbl.TableName;
 DbName := Tbl.DataBaseName;
 Tbl.Close;
 Tbl.Free;
 {H1:= Tbl.TableName+Space(40);}
 PrintAlisting(FlName,
      TblName+Space(40),
      DBName,
      '');
end;

procedure TTablesF.ConnectBtnClick(Sender: TObject);
begin
  DataBaseChange;
  ListBox1.ItemIndex := 0;
  ListBox1Click (self);
end;

procedure TTablesF.PageControl1Change(Sender: TObject);
Var i:Integer;
begin
  If PageControl1.ActivePage = Tabsheet1 then
  begin
   If Query1.Active then Query1.close;
  end;

  If PageControl1.ActivePage = Tabsheet2 then
  begin
   If ThisTable='' then
   begin
    ShowMessage('You must open a Data Base first');
    PageControl1.ActivePage := Tabsheet1;
    exit;
   end;
   Query1.DataSource:= Nil;
   If Query1.Active then Query1.close;
   If Memo1.Lines.Count =0 then
    Memo1.Lines.Add('Select * from '+ ThisTable);
  end; {tabsheet2}

  If PageControl1.ActivePage = Tabsheet3 then
  begin
   If ThisTable='' then
   begin
    ShowMessage('You must open a Data Base first');
    PageControl1.ActivePage := Tabsheet1;
    exit;
   end;
   ShowFieldProperties;
  end; {tabsheet3}

  (*
  If PageControl1.ActivePage = Tabsheet4 then
  begin
   If ThisTable='' then
   begin
    ShowMessage('You must open a Data Base first');
    PageControl1.ActivePage := Tabsheet1;
    exit;
   end;
   CreateAReport;
  end; {tabsheet4}
  *)
  If PageControl1.ActivePage = Tabsheet3 then
  begin
   If ThisTable='' then
   begin
    ShowMessage('You must open a Data Base first');
    PageControl1.ActivePage := Tabsheet1;
    exit;
   end;
   ShowTableIndexes;
  end; {tabsheet3}

end;

Procedure TTablesF.CreateAReport;
Var FieldList:TstringList;
begin
 {
 QuickRep1.Dataset := Table1;
 aReport := TablesF.QuickRep1;
 aReport.Preview;
 }
 {
 FieldList:= TStringList.Create;
 FieldList := Nil;
 aReport := Nil;
 QrCreateList(aReport,Self,ThisTable,'This Table Report',FieldList);
 aReport.Preview;
 aReport.Free;
 FieldList.Free;
 }
end;

procedure TTablesF.RunBtnClick(Sender: TObject);
begin
 OpenQuery;
end;

procedure TTablesF.OpenQuery;
Var i:Integer;{Qry:TQuery; QrySource:TDataSource;}
begin
   Screen.Cursor := crHourGlass;
   With Query1 do
   begin
   Sql.Clear;
   DataBaseName := ThisDataBase;
   {QueryGrid.DataSource := QuerySource;}
   ErrorList.Clear;
   For i:=0 to Memo1.Lines.Count-1  do
     Sql.Add(Memo1.lines[i]);

   If (AllTrim(Memo1.lines[0]) >'') then
   begin
       Try
         Query1.Open;   {ExecSql;}
         QueryGrid.DataSource := QuerySource;
         ErrorList.Lines.Add('Done');
       except
         on E: Exception do ErrorList.Lines.Add(E.Message);
       end;
    end
   else
    ShowMessage('No SQL statement');
  end; {with}
  Screen.Cursor := crDefault;
end;

procedure TTablesF.ReportBtnClick(Sender: TObject);
Var FieldList:TStringList;
begin
  If ThisTable='' then
  begin
    ShowMessage('You must open a Data Base first');
    PageControl1.ActivePage := Tabsheet1;
    exit;
   end;
  Application.CreateForm(TReportFrm,ReportFrm);
  Report := ReportFrm.QuickRep1;
  {Report :=Nil;}
  {QrCreateList(Report,ReportFrm.Canvas,Table1,'fffff',Nil);}
  Report.Preview;
  ReportFrm.Free;
end;

procedure TTablesF.LoadBtnClick(Sender: TObject);
begin
 If OpenDialog1.Execute then
  Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TTablesF.SaveBtnClick(Sender: TObject);
begin
  If SaveDialog1.Execute then
  Memo1.Lines.SaveToFile(SaveDialog1.FileName);

end;

procedure TTablesF.ClearBtnClick(Sender: TObject);
begin
Memo1.Clear;
end;


Function TTablesF.GetDataType(DtType:Integer):String;
Begin
 Case DtType of
 0: Result:= 'Unknown';
 1:Result:= 'String';
 2:Result:= 'Smallint';
 3:Result:= 'Integer';
 4:Result:= 'Word';
 5:Result:= 'Boolean';
 6:Result:= 'Float';
 7:Result:= 'Currency';
 8:Result:= 'BCD';
 9:Result:= 'Date';
 10:Result:='Time';
 11:Result:= 'DateTime';
 12:Result:= 'Bytes';
 13:Result:= 'VarBytes';
 14:Result:= 'AutoInc';
 15:Result:= 'Blob';
 16:Result:= 'Memo';
 17:Result:= 'Graphic';
 18:Result:= 'FmtMemo';
 19:Result:= 'ParadoxOle';
 20:Result:= 'DBaseOle';
 21:Result:= 'TypedBinary';
 22:Result:= 'Cursor';
 23:Result:= 'FixedChar';
 24:Result:= 'WideString';
 25:Result:= 'Largeint';
 26:Result:= 'ADT';
 27:Result:= 'Array';
 28:Result:= 'Reference';
 29:Result:= 'DataSet';
 30:Result:= 'OraBlob';
 31:Result:= 'OraClob';
 32:Result:= 'Variant';
 33:Result:= 'Interface';
 34:Result:= 'IDispatch';
 35:Result:= 'Guid';
 end;
end;
procedure TTablesF.RecviewBtnClick(Sender: TObject);
begin
wwRecordViewDialog1.execute;
end;

end.
