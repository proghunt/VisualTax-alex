unit T1_2026ImportDbfData;

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
  TImportDBFT1_2026 = class(TForm)
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
    btnHelp: TBitBtn; //20160713 Igor
    Connection: TADConnection; //20161031 Igor
    Table: TADTable;           //20161031 Igor
    procedure FilesToShow;
    procedure CalcImported(RetNo:Integer);
    Function ValidDirectories:Boolean;
    procedure OpenIt(Dir:String;FlName:String);
    procedure SaveIt(FlName:String);
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
  ImportDBFT1_2026: TImportDBFT1_2026;
  FlName: String[60];
  Cnt   : integer;
  InitialRowCount :integer;

implementation

{$R *.DFM}
uses T1_2026Main, T1_2026, vtShared, T1_2026TrimStr, vtDialogs, T1_2026Common2,
  T1_2026Common, vtTrimStr, vtMain, vtMulti, vtCommon, T1_2026Declare,
  vtDBF_SQLite; //20161202 Igor

const
  c_ImportToMultiAppHelp = 'www.visualtax.com/vtImportToMultiApp.asp';  //20160713 Igor

procedure TImportDBFT1_2026.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);  //20160229 Igor
begin
  CanClose := not StartProcess;
end;

procedure TImportDBFT1_2026.FormCreate(Sender: TObject);
begin
  FlName := '';
  OverrideOption.itemIndex :=0;
  DbfData_Dir.Text := OptRec.Dir_DBFData;
  Cur_Dir.Text := OptRec.Dir_Cur;
  FilesToShow;
end;


procedure TImportDBFT1_2026.ButtonCloseLogClick(Sender: TObject);
begin
  MemoLog.Visible := not MemoLog.Visible;
end;

procedure TImportDBFT1_2026.CalcImported(RetNo: Integer);
begin
  Calc(WorkRetNo,'T1');
  CalcAll(WorkRetNo);
end;

procedure TImportDBFT1_2026.CancelBtnClick(Sender: TObject);
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

procedure TImportDBFT1_2026.StringGrid1DblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;

procedure TImportDBFT1_2026.TableFilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
begin
  Accept := (SearchBox.Text = '') or
            (Pos(AnsiUpperCase(SearchBox.Text), AnsiUpperCase(DataSet.FieldByName('Last_Name').asString))>0);
end;

Function TImportDBFT1_2026.ValidDirectories:Boolean;
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

procedure TImportDBFT1_2026.OKBtnClick(Sender: TObject);
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
                  ' Import it over again?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then //20160310 Igor
      Exit;
  end;

  OpenIt(DBFData_Dir.Text,FlName);
  
end;


procedure TImportDBFT1_2026.OpenIt(Dir: String; FlName: String);
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
  s:=GetReturnPsw(Dir,FlName,AppT1_2026.SQLLitePassword.PassRFArray); //20160415 Igor
  If (S > '') AND Not YouKnowTheReturnPassword(s) then
  begin
    ShowTimedMsg('Invalid Password',900);
    RemoveReturnFromMemory(WorkRetNo);
    exit;
  end;


  If WorkRetNo > 0 then
  begin
    LockWindowUpdate(MainFormT1.Handle); //no impact
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

procedure TImportDBFT1_2026.AddLog(AText: String);
begin
  MemoLog.Lines.Add({'***'+DateTimeToStr(Now)+':   '+}AText); //20160305 Igor
  MemoLog.Repaint;
end;

procedure TImportDBFT1_2026.AllBtnClick(Sender: TObject);
Var
  i: integer;
  Sin: string;
  Msg: string;
  Err: String;
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
      AddLog('File in progress: "'+Table.FieldByName('File_Name').AsString+'" '+Table.FieldByName('Last_Name').AsString+
         ' '+LeftStr(Table.FieldByName('First_Name').AsString,1));

      if not T1_2026TrimStr.ImportOneReturn(Table, DbfData_Dir.Text, Cur_Dir.text, Err, OverrideOption.itemIndex = 1) then
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

procedure TImportDBFT1_2026.btnHelpClick(Sender: TObject);  //20160713 Igor
begin
  ShowHelp(c_ImportToMultiAppHelp,'', true);
end;

procedure TImportDBFT1_2026.SaveIt(FlName:String);
begin
  If not SaveReturn(WorkRetNo, Cur_Dir.Text, FlName, True, True) = 0 then
    ShowMessage('Return cannot be saved')
  else
    Inc(Cnt);
end;


procedure TImportDBFT1_2026.FilesToShow;
begin
  Connection.Close;
  Table.Close;
  //20161031 Igor >>>
  //20161202 Igor >>>
  SetODBCConnect(Connection, DBFData_Dir.Text);
//  Connection.Params.Values['DriverID'] := 'ODBC';
//  Connection.Params.Values['ODBCDriver'] := '{Microsoft Access dBASE Driver (*.dbf, *.ndx, *.mdx)}';
//  Connection.Params.Values['Database'] :=  ExcludeTrailingPathDelimiter(DBFData_Dir.Text);
//  Connection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
//                                 'Data Source=' + DBFData_Dir.Text + ';' +
//                                 'Extended Properties="DBASE IV";';
//20161202 Igor <<<
  //20161031 Igor <<<
  Connection.LoginPrompt := false;
  Connection.Open;
  Table.TableName := ChangeFileExt(ClientsTable_dbf, ''); //20161031 Igor
  Table.IndexName := 'LAST_NAME';
  Table.Open;
  Table.First;
  Refresh;
end;

procedure TImportDBFT1_2026.DbfData_DirExit(Sender: TObject);
begin
  If not DirectoryExists(DbfData_Dir.text) then
  begin
    ShowMessage('Directory '+ DbfData_Dir.text+ ' does not exist');
    DbfData_Dir.text := OptRec.Dir_DbfData;
  end;
  FilesToShow;
end;

procedure TImportDBFT1_2026.DbfData_DirKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
    DbfData_DirExit(Application);
end;

procedure TImportDBFT1_2026.DBGrid1DblClick(Sender: TObject);
begin
  OKBtnClick(Sender);
end;


procedure TImportDBFT1_2026.SearchBoxChange(Sender: TObject);
begin
  if SearchBox.Text <> '' then
  Begin
    Table.Filtered := False; //20161031 Igor
    Table.Filtered := True;
    Table.First;
  end
  else Table.Filtered := False; //20161031 Igor
end;

procedure TImportDBFT1_2026.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
    OKBtnClick(Sender);
end;

procedure TImportDBFT1_2026.SetEnabledControlElements(AValue: Boolean);  //20160229 Igor
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
    LockWindowUpdate(MainFormT1.Handle)
  else
    LockWindowUpdate(0);   //no impact

end;

end.
