unit TF_2026import;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,ExtCtrls,Buttons,Grids,DB,DBGrids,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

  type
  TImportTF_2026 = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    LastYearDirBox: TEdit;
    Label3: TLabel;
    ThisYearDirBox: TEdit;
    Image1: TImage;
    RetCntLabel: TLabel;
    FileListBox1: TFileListBox;
    DosFileBtn: TBitBtn;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    SearchBox: TEdit;
    FDConnection: TADConnection;
    Table1: TADTable;

    Function LastYearDirExists(S:string):Boolean;
    procedure FilesToShow;
    procedure CalcImported(RetNo:Integer);
    Function ValidDirectories:Boolean;
    procedure OpenIt(FlName:String);
    procedure SaveIt(FlName:String);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    {procedure AllBtnClick(Sender: TObject);}
    procedure LastYearDirBoxExit(Sender: TObject);
    procedure LastYearDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DosFileBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure SearchBoxKeyPress(Sender: TObject; var Key: Char);

   { procedure FindSinBtnClick(Sender: TObject);}  {Screen, element, valu}
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Import: TImportTF_2026;
  FlName: string; //[60];
  RetNo : integer;
  Cnt   : integer;
  InitialRowCount :integer;

implementation

{$R *.DFM}

uses vtCommon,TF_2026,TF_2026ChildWinNew,TF_2026Common,TF_2026Declare,
  TF_2026Common2,TF_2026TrimStr,TF_2026Calc,TF_2026Main, vtTrimStr, vtShared,
  vtDataBase,
  vtDBF_SQLite; //20170226 Igor

procedure TImportTF_2026.FormCreate(Sender: TObject);
Var
  slash :string; //[1];
begin
  FlName := '';
  LastYearDirBox.Text := OptRec.Dir_LastYr;
  ThisYearDirBox.Text := OptRec.Dir_Cur;
  if (UpperCase(LastYearDirBox.Text) = 'A:') or (UpperCase(LastYearDirBox.Text) = 'B:') then
    slash := ''
  else
    slash := '\';
  FilesToShow;
  //20180503 Igor >>>
  if CheckIsCloud(true) then
    LastYearDirBox.Enabled := False;
 //20180503 Igor <<<
end;

procedure TImportTF_2026.CalcImported(RetNo:Integer);
Var i ,SlipCode: integer;
begin
 Calc(RetNo,FirstFormName); //Calc(RetNo,'T3');  //20180212
 CalcAll(RetNo);
end;

procedure TImportTF_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TImportTF_2026.StringGrid1DblClick(Sender: TObject);
begin
OKBtnClick(Sender);
end;

Function TImportTF_2026.ValidDirectories:Boolean;
Var i,j: integer; Sin : string;
begin
 Result := False;
 If Not DirectoryExists(ThisYearDirBox.Text) then
 begin
  ShowMessage('Directory does not exist');
  ThisYearDirBox.SetFocus;
  exit;
 end;
 If Not LastYearDirExists(LastYearDirBox.Text) then
  begin
   ShowMessage('Directory does not exist');
   LastYearDirBox.SetFocus;
   exit;
  end;
 Result := True;
end;

Function TImportTF_2026.LastYearDirExists(S:string):Boolean;
begin
 If (UpperCase(s) ='A:') or (UpperCase(s) ='B:') then
   begin result :=true;exit;end;
 If DirectoryExists(S) then result := true
 else result := false;
end;

procedure TImportTF_2026.OKBtnClick(Sender: TObject);
begin
 DBGrid1DblClick(Sender);
end;


procedure TImportTF_2026.SaveIt(FlName:String);
begin
 If not SaveReturn(RetNo,ThisYearDirBox.Text,FlName,False,True) =0
             then ShowMessage('Return cannot be saved')
 else Inc(Cnt);
end;

procedure TImportTF_2026.FilesToShow;
var
  i, j: integer;
begin
//20170310 Igor >>>
  if FileExists(LastYearDirBox.text+'\' + ClientsTable_dbf) then
  begin
    Table1.Close;
    SetODBCConnect(FDConnection, LastYearDirBox.text);
    FDConnection.LoginPrompt := false;
    FDConnection.Open;
    Table1.TableName := ChangeFileExt(ClientsTable_dbf, ''); //20161031 Igor
    Table1.IndexFieldNames := 'CORP_NAME';
    Table1.Open;
  end
  else
  If FileExists(LastYearDirBox.text+'\' + ClientsDBLite) then
    SetTableName(FDConnection, Table1, LastYearDirBox.Text + '\' + ClientsDBLite,
      ClientsTableLite, 'CORP_NAME', False)
  else
  Begin
    ShowMessage('Last year directory does not contain VisualTax files');
    exit;
  End;
//20170310 Igor <<<
  Table1.First;
  Refresh;
end;

procedure TImportTF_2026.LastYearDirBoxExit(Sender: TObject);
begin
If not LastYearDirExists(LastYearDirBox.text) then
 begin
  ShowMessage('Directory '+ LastYearDirBox.text+ ' does not exist');
  LastYearDirBox.text := OptRec.Dir_lastYr;
  {exit}
 end;
 FilesToShow;
end;

procedure TImportTF_2026.LastYearDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If key = #13 then LastYearDirBoxExit(Application);
end;

procedure TImportTF_2026.DBGrid1DblClick(Sender: TObject);
begin
 FlName := Table1.FieldByName('FILE_NAME').AsString;
 OpenIt(FlName);
 Close;
end;

procedure TImportTF_2026.OpenIt(FlName:String);
Var
  RetNo:Integer;
begin
 if not ValidDirectories then exit;

 If FlName = '' then exit;
 retNo:=ReadReturn(LastYearDirBox.Text,FlName,True, False, True); //20170130 Igor
 if RetNo < 1 then
   ShowMessage('Opening file '+ Chr(13) +
         LastYearDirBox.Text+'\'+FlName + Chr(13) +
         'failed')
 else
 begin
   OpenForm(RetNo,GetFormNo('T3'),0);
   Ret[RetNo].SourceDataDir := OptRec.Dir_Cur; {fool it in import}
  // ShowMessage('You can press F2 to select the tax module you need'); //20220130
  // ShowTimedMsg('You can press F2 to select a different tax module',500); //20220130
 end;
end;


procedure TImportTF_2026.DosFileBtnClick(Sender: TObject);
begin
  FlName := InputBox('Input Box', 'Enter file number', '');
  OpenIt(FlName);
end;

procedure TImportTF_2026.BitBtn1Click(Sender: TObject);
begin
  ShowHelp('TfHelp','Conversion');
end;

procedure TImportTF_2026.SearchBoxChange(Sender: TObject);
begin
//20170522 Igor >>>
  Table1.Locate('CORP_NAME', SearchBox.Text, [loCaseInsensitive, loPartialKey]);
// with Table1 do
//  begin
//  SetKey;
//  FieldByName('CORP_NAME').AsString := UpperCase(SearchBox.Text); //20170130 Igor
//  GotoNearest;
//  end;
//20170522 Igor <<<
end;

procedure TImportTF_2026.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then OKBtnClick(Sender);
end;

end.
