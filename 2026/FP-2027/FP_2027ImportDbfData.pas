unit FP_2027ImportDbfData;

interface

uses
  SysUtils,FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, Grids, VCLTee.TeEngine,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.DBGrids, Data.DB,
  Vcl.ComCtrls, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;

  type
  TImportDBFFP_2027 = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    DbfData_Dir: TEdit;
    Label3: TLabel;
    Cur_Dir: TEdit;
    Image1: TImage;
    AllBtn: TBitBtn;
    RetCntLabel: TLabel;
    FileListBox1: TFileListBox;
    DBGrid1: TDBGrid;
    OverrideOption: TRadioGroup;
    Label2: TLabel;
    SearchBox: TEdit;
    Chart1: TChart;
    Label4: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    DataSource1: TDataSource;
    ProgressBar: TProgressBar;  //20160229 Igor
    LabelProgressBar: TLabel;
    MemoLog: TMemo;
    ButtonCloseLog: TButton;   //20160229 Igor
    btnHelp: TBitBtn;
    Connection: TADConnection;
    Table: TADTable; //20160713 Igor
    procedure FilesToShow;
    procedure CalcImported(RetNo:Integer);
    Function ValidDirectories:Boolean;
    procedure OpenIt(Dir:String;FlName:String);
//    procedure SaveIt(FlName:String); //20160627 Igor
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure AllBtnClick(Sender: TObject);
    procedure DbfData_DirExit(Sender: TObject);
    procedure DbfData_DirKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure SearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure TableFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ButtonCloseLogClick(Sender: TObject);  //20160229 Igor
    procedure btnHelpClick(Sender: TObject); //20160713 Igor

   { procedure FindSinBtnClick(Sender: TObject);}  {Screen, element, valu}
  private
    { Private declarations }
    WorkRetNo: Integer;
    StartProcess: Boolean;
    procedure SetEnabledControlElements(AValue: Boolean); //20160229 Igor
    procedure AddLog(AText: String);
  public
    { Public declarations }
  end;

var
  ImportDBFFP_2027: TImportDBFFP_2027;
  FlName: String[60];
  Cnt   : integer;
  InitialRowCount :integer;

implementation

{$R *.DFM}
uses FP_2027Main, FP_2027, vtShared, FP_2027TrimStr, vtDialogs, FP_2027Common2,
  FP_2027Common, vtTrimStr, vtMain, vtMulti, vtCommon,
  vtDBF_SQLite; //20161202 Igor

const
  c_ImportToMultiAppHelp = 'www.visualtax.com/vtImportToMultiApp.asp';  //20160713 Igor

procedure TImportDBFFP_2027.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);  //20160229 Igor
begin
  CanClose := not StartProcess;
end;

procedure TImportDBFFP_2027.FormCreate(Sender: TObject);
begin
  FlName := '';
  OverrideOption.itemIndex :=0;
  DbfData_Dir.Text := OptRec.Dir_DBFData;
  Cur_Dir.Text := OptRec.Dir_Cur;
  FilesToShow;
  //20180503 Igor >>>
  if CheckIsCloud(true) then
    DbfData_Dir.Enabled := False;
  //20180503 Igor <<<
end;


procedure TImportDBFFP_2027.ButtonCloseLogClick(Sender: TObject);
begin
  MemoLog.Visible := not MemoLog.Visible;
end;

procedure TImportDBFFP_2027.CalcImported(RetNo: Integer);
begin
//  Calc(WorkRetNo,'T1');
  CalcAll(WorkRetNo);
end;

procedure TImportDBFFP_2027.CancelBtnClick(Sender: TObject);
begin
  if StartProcess then
  Begin
    if MessageDlg('Cancel operation?',mtConfirmation,[mbYes,mbNo],0) = mrYes then
    Begin
      SetEnabledControlElements(True);
      Close;
    End
  End
  else
    Close;
end;

procedure TImportDBFFP_2027.StringGrid1DblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;

procedure TImportDBFFP_2027.TableFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := (SearchBox.Text = '') or
            (Pos(AnsiUpperCase(SearchBox.Text), AnsiUpperCase(DataSet.FieldByName('Last_Name').asString))>0);
end;

Function TImportDBFFP_2027.ValidDirectories:Boolean;
Var
  i,j: integer;
  Sin : string;
begin
  Result := False;
  If Not DirectoryExists(Cur_Dir.Text) then
  begin
    ShowMessage('Directory does not exist');
    Cur_Dir.SetFocus;
    exit;
  end;
  If Not DirectoryExists(DBFData_Dir.Text) then
  begin
    ShowMessage('Directory does not exist');
    DBFData_Dir.SetFocus;
    exit;
  end;
  If Not FileExists(Cur_Dir.Text+'\'+ClientsDbLite) then
  begin
    ShowMessage('Data catalog does not contain the database file to a new(DB) format.'+
                 Chr(13)+
                 'Use Configure | Data Directories');
    Cur_Dir.SetFocus;
    exit;
  end;
  If Not FileExists(DBFData_Dir.Text+'\'+ClientsTable_dbf) then
  begin
    ShowMessage('Data catalog does not contain the database file to a old(DBF) format.'+
                 Chr(13)+
                 'Use Configure | Data Directories');
    DBFData_Dir.SetFocus;
    exit;
  end;
  Result := True;
end;

procedure TImportDBFFP_2027.OKBtnClick(Sender: TObject);
Var
  i: Integer;
  s, FlName: String;
  Sin: String;
  WrongAssets:String;
Begin
  WrongAssets:='';
  FlName := Table.FieldByName('FILE_NAME').AsString;
  If FileExists(Cur_Dir.text+'\'+FLName) then
  begin
    if MessageDlg('This return is already on this year'+Chr(39)+'s folder: '+Cur_Dir.text
                  +Chr(13)+
                  ' Import it over again?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;
  end;

  OpenIt(DBFData_Dir.Text,FlName);
  
end;


procedure TImportDBFFP_2027.OpenIt(Dir: String; FlName: String);
Var
  i,j: integer;
  Sin: string;
  s: String;
begin
  if not ValidDirectories then exit;
  If FlName = '' then exit;
  if FileExists(Dir+'\'+FlName) = false then
  begin
    ShowMessage('File '+ Chr(13) +
                Dir+'\'+FlName + Chr(13) +
                'does not exist');
    exit;
  end;
  If FlName = '' then exit;

  If GetRetNoFromSin(RemoveChar(FlName,'.'))>0 then
  begin
     ShowTimedMsg('Return of SIN '+RemoveChar(FlName,'.') +' is already loaded. Skipped',1200);
     Exit;
  end;

  WorkRetNo := ReadReturn(Dir,FlName);
//  s:=GetReturnPsw(Dir,FlName);
//  If (S > '') AND Not YouKnowTheReturnPassword(s) then
//  begin
//    ShowTimedMsg('Invalid Password',900);
//    RemoveReturnFromMemory(WorkRetNo);
//    exit;
//  end;


  If WorkRetNo > 0 then
  begin
    LockWindowUpdate(MainFormFP.Handle); //no impact
    CountDiagnostics(WorkRetNo);
    MainForm.GuiCommand(gcShowLeftPanel);
    OpenForm(WorkRetNo,GetFormNo('INFO'),0);
    MainForm.FormPaint(Application);
    StoreElm(WorkRetNo,GetFormNo('STATUS'),4,'01'); //not started
    Ret[WorkRetNo].PrpStatus:='01';
    Ret[WorkRetNo].SourceDataDir := OptRec.Dir_Cur; {fool it in import}
    StoreElm(WorkRetNo,GetFormNo('T183'),10,FetchElm(WorkRetNo,'INFO',64)); //store Cra Email in T183 //20151213
  end
  else
  begin
    ShowOpenReturnFailure(WorkRetNo,Dir,FlName);
    exit;
  end;
end;

procedure TImportDBFFP_2027.AddLog(AText: String);
begin
  MemoLog.Lines.Add({'***'+DateTimeToStr(Now)+':   '+}AText); //20160305 Igor
  MemoLog.Repaint;
end;

procedure TImportDBFFP_2027.AllBtnClick(Sender: TObject);
Var
  i, j, FNo: integer;
  Sin: string;
  Msg: string;
  PrPStatus, EfStatus: String[2];
  Notes: String[80];
  DbfDataDir: String[60];
  Err: String; //20160627 Igor
begin
  If LicenseLevel in anyMulti then
  begin
    If YouKnowTheAdminPassword = false then 
      exit;
  end;

  If RetInMem > 0 then
  begin
    ShowMessage('Please close all returns first');
    exit;
  end;

  if MessageDlg('Import all. Are you sure?',
                mtInformation, [mbYes, mbNo], 0) = mrNo then exit;

  Cnt :=0;

  Table.First;
  SetEnabledControlElements(False); //20160229 Igor
  AddLog('Start');
  try
    while not Table.eof do
    Begin
      Application.ProcessMessages;  //20160229 Igor
      if Not StartProcess then
      Begin
        AddLog('Process terminated by user');
        exit;  //20160229 Igor
      end;

      //AddLog('Record #'+IntToStr(Table.RecNo)); //20160305 Igor
      InitFormsTable;  //20101214
      FlName := AllTrim(Table.FieldByName('File_Name').AsString);
      AddLog('File in progress: "'+FlName+'" '+Table.FieldByName('Last_Name').AsString+
             ' '+LeftStr(Table.FieldByName('First_Name').AsString,1));
      if not FP_2027TrimStr.ImportOneReturn(Table, DbfData_Dir.Text, Cur_Dir.text, Err, OverrideOption.itemIndex = 1) then  //20160627 Igor
        AddLog(Err)
      else
        inc(cnt);
      Table.Next;
      ProgressBar.Position := Table.RecNo;  //20160229 Igor
      LabelProgressBar.Caption := IntToStr(Table.RecNo) + ' of ' +IntToStr(Table.RecordCount);  //20160229 Igor
    End;
    Addlog('End. Total returns converted/added= '+IntTostr(cnt));
  finally
    SetEnabledControlElements(true);  //20160229 Igor

  end;
  ShowMessage('Import from last year completed.'+Chr(13)+
              'Total returns converted/added= '+IntTostr(cnt));
  SendMessage(MainForm.Handle, WM_PAINT,0,0);
end;

procedure TImportDBFFP_2027.btnHelpClick(Sender: TObject); //20160713 Igor
begin
  ShowHelp(c_ImportToMultiAppHelp,'', true);
end;

//procedure TImportDBFFP_2027.SaveIt(FlName:String);
//begin
//  If not SaveReturn(WorkRetNo, Cur_Dir.Text, FlName, True, True) = 0 then
//    ShowMessage('Return cannot be saved')
//  else
//    Inc(Cnt);
//end;


procedure TImportDBFFP_2027.FilesToShow;
begin
  Connection.Close;
  Table.Close;
  //20161031 Igor >>>
//20161202 Igor >>>
   SetODBCConnect(Connection, DBFData_Dir.Text);
//  Connection.Params.Values['DriverID'] := 'ODBC';
//  Connection.Params.Values['ODBCDriver'] := '{Microsoft Access dBASE Driver (*.dbf, *.ndx, *.mdx)}';
//  Connection.Params.Values['Database'] :=  ExcludeTrailingPathDelimiter(DBFData_Dir.Text);
//20161202 Igor <<<
//  Connection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
//                                 'Data Source=' + DBFData_Dir.Text + ';' +
//                                 'Extended Properties="DBASE IV";';
//20161031 Igor <<<
  Connection.LoginPrompt := false;
  Connection.Open;
  Table.TableName := ChangeFileExt(ClientsTable_dbf, ''); //20161031 Igor
  Table.IndexName := 'LAST_NAME';
  Table.Open;
  Table.First;
  Refresh;
end;

procedure TImportDBFFP_2027.DbfData_DirExit(Sender: TObject);
begin
  If not DirectoryExists(DbfData_Dir.text) then
  begin
    ShowMessage('Directory '+ DbfData_Dir.text+ ' does not exist');
    DbfData_Dir.text := OptRec.Dir_DbfData;
  end;
  FilesToShow;
end;

procedure TImportDBFFP_2027.DbfData_DirKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
    DbfData_DirExit(Application);
end;

procedure TImportDBFFP_2027.DBGrid1DblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;


procedure TImportDBFFP_2027.SearchBoxChange(Sender: TObject);
begin
  if SearchBox.Text <> '' then
  Begin
    Table.Filtered := False; //20161031 Igor
    Table.Filtered := True;
    Table.First;
  end
  else Table.Filtered := False; //20161031 Igor

end;

procedure TImportDBFFP_2027.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
    OKBtnClick(Sender);
end;

procedure TImportDBFFP_2027.SetEnabledControlElements(AValue: Boolean);  //20160229 Igor
begin
  StartProcess := not AValue;
  GroupBox1.Enabled := AValue;
  OverrideOption.Enabled := AValue;
  SearchBox.Enabled := AValue;
  DBGrid1.Enabled := AValue;
  OKBtn.Enabled := AValue;
  AllBtn.Enabled := AValue;
  ProgressBar.Visible := not AValue;
  if ProgressBar.Visible then //20160305 Igor
  Begin
    ProgressBar.Max := Table.RecordCount;
    ProgressBar.Position :=0;
  End;

  LabelProgressBar.Visible := not AValue;
  if not AValue then
  Begin
    MemoLog.SetBounds(DBGrid1.Left,DBGrid1.Top,
                      DBGrid1.Width, DBGrid1.Height);
    MemoLog.Clear;
    MemoLog.Visible := True;
    MemoLog.BringToFront;
    ButtonCloseLog.Visible := true;
  End;

  if not AValue then
    LockWindowUpdate(MainFormFP.Handle)
  else
    LockWindowUpdate(0);   //no impact

end;

end.
