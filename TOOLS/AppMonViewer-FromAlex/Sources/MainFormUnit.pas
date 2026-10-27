unit MainFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons, System.Actions, Vcl.ActnList, Vcl.ImgList,
  uADStanIntf, uADStanOption, Math,
  uADStanParam, uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, Data.DB,
  uADCompDataSet, uADCompClient, Vcl.ComCtrls, Vcl.DBCtrls, uADGUIxIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADDAptManager,
  uADStanExprFuncs, uADGUIxFormsWait, uADCompGUIx, uADPhysSQLite,
  ShellApi, ComObj; //20220524 Igor

type
  TMainForm = class(TForm)
    pnlConnection: TPanel;
    pnlFilter: TPanel;
    Label1: TLabel;
    edDBFile: TEdit;
    btnOpen: TSpeedButton;
    ActionList: TActionList;
    actFileOpen: TAction;
    actConnect: TAction;
    btnConnect: TSpeedButton;
    OpenDBDialog: TOpenDialog;
    FConnection: TADConnection;
    QData: TADQuery;
    FDPhysSQLiteDriverLink1: TADPhysSQLiteDriverLink;
    deStart: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    deEnd: TDateTimePicker;
    rbAll: TRadioButton;
    rbKeyMisUse: TRadioButton;
    rbT2MisUse: TRadioButton;
    edKey: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    QApp: TADQuery;
    cbApp: TComboBox;
    FDGUIxWaitCursor1: TADGUIxWaitCursor;
    btnSearch: TSpeedButton;
    actSearch: TAction;
    dsData: TDataSource;
    QDataId: TADAutoIncField;
    QDataAppName: TStringField;
    QDataAppKey: TStringField;
    QDataLicenseLevel: TStringField;
    QDataReturnCountLimited: TBooleanField;
    QDataMaxReturnCount: TStringField;
    QDataEventDate: TDateTimeField;
    QDataComputerName: TStringField;
    QDataPreparerName: TStringField;
    QDataPreparerAddress: TStringField;
    QDataReturnCount: TIntegerField;
    QDataFileName: TStringField;
    QDataEfileNumber: TStringField;
    QDataTaxationYear: TStringField;
    QDataAdditionalInfo: TStringField;
    btnMergeDatabases: TSpeedButton;
    actMergeDatabases: TAction;
    SaveDBDialog: TSaveDialog;
    sbAppMon: TStatusBar;
    actAppMisuse: TAction;
    actT2Summary: TAction;
    SaveReportDialog: TSaveDialog;
    QAppKeyMisuseReport: TADQuery;
    QT2LimitedReport: TADQuery;
    SaveXlsReportDialog: TSaveDialog;
    QAppKeys: TADQuery;
    pcMain: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    AppMonGrid: TDBGrid;
    sbFindOffenders: TSpeedButton;
    GroupBox1: TGroupBox;
    cbComputerName: TCheckBox;
    cbPreparerName: TCheckBox;
    cbPreparerAddress: TCheckBox;
    cbEfiler: TCheckBox;
    cbIgnoreEmptyValues: TCheckBox;
    actFindOffenders: TAction;
    ShortAppMonGrid: TDBGrid;
    dsShortData: TDataSource;
    qShortData1: TADQuery;
    ADAutoIncField1: TADAutoIncField;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    BooleanField1: TBooleanField;
    StringField4: TStringField;
    DateTimeField1: TDateTimeField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    IntegerField1: TIntegerField;
    StringField8: TStringField;
    StringField9: TStringField;
    StringField10: TStringField;
    StringField11: TStringField;
    qShortData: TADQuery;
    cbPrintToExcel: TCheckBox;
    cbPrintEfiler4: TCheckBox;
    rbExportGroup: TRadioGroup;
    SpeedButton1: TSpeedButton;
    actExportDataToExcel: TAction;
    btnAppMisuse: TSpeedButton;
    btnT2Summary: TSpeedButton;
    procedure actFileOpenExecute(Sender: TObject);
    procedure FConnectionAfterConnect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure actConnectExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure actSearchExecute(Sender: TObject);
    procedure AppMonGridDrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure AppMonGridTitleClick(Column: TColumn);
    procedure actMergeDatabasesExecute(Sender: TObject);
    procedure QDataAfterScroll(DataSet: TDataSet);
    procedure actAppMisuseExecute(Sender: TObject);
    procedure actT2SummaryExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actFindOffendersExecute(Sender: TObject);
    procedure actExportDataToExcelExecute(Sender: TObject);
  private
    FDefaultSort: string;
    FAppKeyList: TStringList;
    procedure ConnectionStateChanged;
    procedure InitAppCombo;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure CreateIndices(AConn: TADConnection = nil);
    procedure FillAppMisuse(AConn: TADConnection = nil; AForceClear: boolean = false);
    procedure OpenQAppMisUseReport;
    procedure PrintAppMisuseToTxt;
    procedure PrintAppMisuseToExcel;
    procedure RefreshAppKeyList;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

function DateToSQL(ADateTime: TDateTime): string;

implementation

uses System.IOUtils, IniFiles;

{$R *.dfm}

function DateToSQL(ADateTime: TDateTime): string;
begin
  Result := 'Date('''+ FormatDateTime('yyyy-mm-dd', ADateTime) +''')';
end;

function PaddR(S: string; MaxLength: integer): string;
begin
  S := S.SubString(0, MaxLength);
  Result := S.PadRight(MaxLength, ' ');
end;

procedure TMainForm.actConnectExecute(Sender: TObject);
var
  lYear: Word;
  lMonth: Word;
  lDay: Word;
  lDate: TDateTime;
begin
  if FConnection.Connected then
    FConnection.Connected := false
  else
  begin
    lYear:= 2025;
    lMonth:= 3;
    lDay:= 1;

    lDate:= EncodeDate(lYear, lMonth, lDay);
    deStart.Date:= lDate;
    deStart.Time:= StrToTime('00:00:01');
    lDate:= Now;
    deEnd.Date:= lDate;

    if not TFile.Exists(edDBFile.Text) then
    begin
      ShowMessage('File "'+ edDBFile.Text + '" does not exist!');
      Exit;
    end;
    FConnection.LoginPrompt := False;
    FConnection.DriverName := 'SQLite';
    FConnection.Params.Values['Database'] := edDBFile.Text;
    FConnection.Params.Values['Password'] := '';
    try
      FConnection.Connected := True;
      FConnection.ExecSQL('PRAGMA journal_mode = MEMORY');
    except on E: Exception do
      ShowMessage('Error occured while opening database: '+ #13#10 + E.Message);
    end;
  end;
end;

procedure TMainForm.actFileOpenExecute(Sender: TObject);
begin
  OpenDBDialog.Options := OpenDBDialog.Options - [ofAllowMultiSelect];
  OpenDBDialog.FileName := edDBFile.Text;
  if not OpenDBDialog.Execute then Exit;
  edDBFile.Text := OpenDBDialog.FileName;
end;

procedure TMainForm.actMergeDatabasesExecute(Sender: TObject);
var FMergeConn: TADConnection;
    cSourceDatabase, cMergeDatabase, cError: string;
    I: integer;
begin
  OpenDBDialog.Options := OpenDBDialog.Options + [ofAllowMultiSelect];
  if not OpenDBDialog.Execute then Exit;
  if OpenDBDialog.Files.Count < 2 then
  begin
    ShowMessage('You need to select 2 or more files to merge them');
    Exit;
  end;
  if not SaveDBDialog.Execute then Exit;
  cMergeDatabase := SaveDBDialog.Filename;
  FMergeConn := TADConnection.create(nil);
  cError := '';
  try
    FMergeConn.LoginPrompt := False;
    FMergeConn.DriverName := 'SQLite';
    FMergeConn.Params.Values['Database'] := cMergeDatabase;
    FMergeConn.Params.Values['Password'] := '';
    if not TFile.Exists(cMergeDatabase) then
    begin
      FMergeConn.Connected := True;
      FMergeConn.ExecSQL(
        ' CREATE TABLE IF NOT EXISTS SaveLog ( '+
        '    Id                  INTEGER       PRIMARY KEY AUTOINCREMENT '+
        '                                      UNIQUE '+
        '                                      NOT NULL, '+
        '    AppName             VARCHAR (10), '+
        '    AppKey              VARCHAR (19), '+
        '    LicenseLevel        VARCHAR (255), '+
        '    ReturnCountLimited  BOOLEAN, '+
        '    MaxReturnCount      VARCHAR (255), '+
        '    EventDate           DATETIME, '+
        '    ComputerName        VARCHAR (255), '+
        '    PreparerName        VARCHAR (255), '+
        '    PreparerAddress     VARCHAR (255), '+
        '    ReturnCount         INTEGER, '+
        '    FileName            VARCHAR (255), '+
        '    EfileNumber         VARCHAR (20), '+
        '    TaxationYear        VARCHAR (20), '+
        '    AdditionalInfo      VARCHAR (500) '+
        ' )');
    end
    else
      FMergeConn.Connected := True;
    FMergeConn.ExecSQL('PRAGMA journal_mode = WAL');
    FMergeConn.ExecSQL('PRAGMA synchronous = NORMAL');

    for I := 0 to OpenDBDialog.Files.Count - 1 do
    begin
      cSourceDatabase := OpenDBDialog.Files.Strings[I];
      if SameText(cSourceDatabase, cMergeDatabase) then continue;

      try
        FMergeConn.ExecSQL('ATTACH '+ QuotedStr(cSourceDatabase) + ' AS SourceDB');
        FMergeConn.ExecSQL(
          ' INSERT INTO SaveLog(AppName, AppKey, LicenseLevel, ReturnCountLimited, MaxReturnCount, EventDate, '+
          '                     ComputerName, PreparerName, PreparerAddress, ReturnCount, FileName, EfileNumber, '+
          '                     TaxationYear, AdditionalInfo)'+
          ' SELECT AppName, AppKey, LicenseLevel, ReturnCountLimited, MaxReturnCount, EventDate, '+
          '        ComputerName, PreparerName, PreparerAddress, ReturnCount, FileName, EfileNumber, '+
          '        TaxationYear, AdditionalInfo '+
          ' FROM SourceDB.SaveLog '+
          ' ORDER BY Id');

        FMergeConn.ExecSQL('DETACH SourceDB');
      except on E: Exception do
        begin
          FMergeConn.Rollback;
          cError := cError + 'Error occured while merging '+ QuotedStr(cSourceDatabase) + ': ' + E.Message + #13#10;
        end;
      end;
    end;
    CreateIndices(FMergeConn);
    FillAppMisuse(FMergeConn, true);
  finally
    FMergeConn.Connected := false;
    FMergeConn.Free;
    if cError.IsEmpty then
      ShowMessage('Database merged successfully')
    else
      ShowMessage(cError);
  end;
end;

procedure TMainForm.actSearchExecute(Sender: TObject); //20220524 Igor
var cSQL, cKeys, cMisUse: string; 
    A: TArray<string>;
    I: integer;
begin
  cSQL :=
    ' SELECT * FROM SaveLog '+ #13#10;

  cSQL := cSQL +
    ' WHERE EventDate >= '+ DateToSQL(deStart.Date) + ' AND EventDate < date('+ DateToSQL(deEnd.Date) +', ''+1 day'') '+ #13#10;

  if cbApp.ItemIndex > 0 then
    cSQL := cSQL + ' AND AppName = '+ QuotedStr(cbApp.Text);

  cKeys := edKey.Text;
  A := cKeys.Split([','], ExcludeEmpty);
  cKeys := '';
  for I := 0 to Length(A) - 1 do
  begin
    if not SameText(cKeys, '') then
      cKeys := cKeys + ',';
    cKeys := cKeys + QuotedStr(A[I]);
  end;
  if not SameText(cKeys, '') then
    cSQL := cSQL + ' AND AppKey IN (' + cKeys + ')' + #13#10;

  FDefaultSort := 'EventDate';
  if rbKeyMisUse.Checked then
  begin
    if not cbEfiler.Checked and not cbPreparerName.Checked and not cbPreparerAddress.Checked then
    begin
      ShowMessage('Select at least one field to use for Appkey misuse detection');
      Exit;
    end;

    cMisUse := '1 = 0';
    if cbIgnoreEmptyValues.Checked then
    begin
      if cbEfiler.Checked then
        cMisUse := cMisUse + ' OR COUNT(DISTINCT CASE WHEN TRIM(S.EfileNumber) = '''' THEN NULL ELSE S.EfileNumber END) > 1 ';
      if cbPreparerName.Checked then
        cMisUse := cMisUse + ' OR COUNT(DISTINCT CASE WHEN TRIM(S.PreparerName) = '''' THEN NULL ELSE S.PreparerName END) > 1 ';
      if cbPreparerAddress.Checked then
        cMisUse := cMisUse + ' OR COUNT(DISTINCT CASE WHEN TRIM(S.PreparerAddress) = '''' THEN NULL ELSE S.PreparerAddress END) > 1 ';
    end
    else
    begin
      if cbEfiler.Checked then
        cMisUse := cMisUse + ' OR COUNT(DISTINCT S.EfileNumber) > 1 ';
      if cbPreparerName.Checked then
        cMisUse := cMisUse + ' OR COUNT(DISTINCT S.PreparerName) > 1 ';
      if cbPreparerAddress.Checked then
        cMisUse := cMisUse + ' OR COUNT(DISTINCT S.PreparerAddress) > 1 ';
    end;

    cSQL := cSQL +
      ' AND AppKey IN '+ #13#10 +
      '   ( '+ #13#10 +
      '     SELECT S.AppKey '+ #13#10 +
      '     FROM SaveLog S '+ #13#10 +
      '     GROUP BY S.AppKey '+ #13#10 +
      '     HAVING '+ cMisUse + #13#10 +
      '   ) ';

    FDefaultSort := 'AppKey';
  end
  else if rbT2MisUse.Checked then
  begin
    cSQL := cSQL +
      ' AND AppKey IN '+ #13#10 +
      '   ( '+ #13#10 +
      '     SELECT S.AppKey '+ #13#10 +
      '     FROM SaveLog S '+ #13#10 +
      '     WHERE ReturnCountLimited = 1 '+ #13#10 +
      '     GROUP BY S.AppKey '+ #13#10 +
      '     HAVING COUNT(DISTINCT S.FileName) > MaxReturnCount '+ #13#10 +
      '   ) ';
    FDefaultSort := 'AppKey';
  end;

  cSQL := cSQL + ' ORDER BY !SORTFIELD !SORTORDER ';
  QData.Close;
  QData.SQL.Text := cSQL;
  QData.MacroByName('SORTFIELD').Value := FDefaultSort;
  QData.MacroByName('SORTORDER').Value := 'ASC';
  QData.Open;

  RefreshAppKeyList;
end;

procedure TMainForm.actT2SummaryExecute(Sender: TObject);
var cFile, cHeader, cLine: string;
    F1: TextFile;
begin
  SaveReportDialog.FileName := 'T2 summary report for the Limited version.txt';
  if not SaveReportDialog.Execute then Exit;
  cFile := SaveReportDialog.FileName;
  FillAppMisuse;

  QT2LimitedReport.Close;
  QT2LimitedReport.Open;
  if QT2LimitedReport.RecordCount = 0 then
  begin
    ShowMessage('There are no misued keys for export');
    Exit;
  end;
  QT2LimitedReport.First;

  cHeader := PaddR('App', 8) +
             PaddR('Key', 20) +
             PaddR('Lic. Lvl', 11) +
             PaddR('Start Date', 17) +
             PaddR('End Date', 17) +
             PaddR('Efiler1', 12) +
             PaddR('Efiler2', 12) +
             PaddR('Efiler3', 12);
  if cbPrintEfiler4.Checked then
    cHeader := cHeader +
               PaddR('Efiler4', 12);

  AssignFile(F1, cFile);
  try
    Rewrite(F1);
    WriteLn(F1, 'T2 summary report for the Limited version');
    WriteLn(F1, '');
    WriteLn(F1, cHeader);
    WriteLn(F1, StringOfChar('-', Length(cHeader)));

    while not QT2LimitedReport.Eof do
    begin
      cLine := PaddR(QT2LimitedReport.FieldByName('AppName').AsString, 7) + ' ' +
              PaddR(QT2LimitedReport.FieldByName('AppKey').AsString, 19) + ' ' +
              PaddR(QT2LimitedReport.FieldByName('LicenseLevel').AsString, 10) + ' ' +
              PaddR(QT2LimitedReport.FieldByName('StartDate').AsString, 16) + ' ' +
              PaddR(QT2LimitedReport.FieldByName('EndDate').AsString, 16) + ' ' +
              PaddR(QT2LimitedReport.FieldByName('Efiler1').AsString, 11) + ' ' +
              PaddR(QT2LimitedReport.FieldByName('Efiler2').AsString, 11) + ' ' +
              PaddR(QT2LimitedReport.FieldByName('Efiler3').AsString, 11);
      if cbPrintEfiler4.Checked then
        cLine := cLine + ' ' +
              PaddR(QT2LimitedReport.FieldByName('Efiler4').AsString, 11);
      WriteLn(F1, cLine);
      QT2LimitedReport.Next;
    end;
  finally
    CloseFile(F1);
  end;
  //ShowMessage('Report is successfully created!');
  ShellExecute(Application.Handle, 'open', PChar(cFile), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.AppMonGridDrawColumnCell(Sender: TObject; const Rect: TRect; //20220524 Igor
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var nIndex: integer;
begin
  if gdSelected in State then Exit;
  nIndex := FAppKeyList.IndexOf(QData.FieldByName('AppKey').AsString);
  if nIndex = -1 then Exit;
  if nIndex mod 2 = 0 then
    AppMonGrid.Canvas.Brush.Color := clCream
  else
    AppMonGrid.Canvas.Brush.Color := clSkyBlue;
  AppMonGrid.DefaultDrawDataCell(Rect, Column.Field, State);
end;

procedure TMainForm.AppMonGridTitleClick(Column: TColumn); //20220524 Igor
var
  MFN : TADMacro;
  MSO : TADMacro;
begin
  FDefaultSort := Column.FieldName;
  QData.Close;
  MFN := QData.Macros.MacroByName('SORTFIELD');
  MSO := QData.Macros.MacroByName('SORTORDER');
  if SameText(FDefaultSort, MFN.AsIdentifier) then
  begin
    if SameText(MSO.AsRaw, 'ASC') then
      MSO.AsRaw := 'DESC'
    else
      MSO.AsRaw := 'ASC';
  end
  else
  begin
    MFN.Asidentifier := FDefaultSort;
    MSO.AsRaw := 'ASC';
  end;
  QData.Open;
  RefreshAppKeyList;
end;

procedure TMainForm.ConnectionStateChanged;
begin
  if not Assigned(FConnection) then Exit;
  if FConnection.Connected then
  begin
    edDBFile.Readonly := true;
    actFileOpen.Enabled := false;
    actConnect.Caption := 'Disconnect';
    InitAppCombo;
    pnlFilter.Visible := true;
  end
  else
  begin
    edDBFile.Readonly := false;
    actFileOpen.Enabled := true;
    actConnect.Caption := 'Connect';
    pnlFilter.Visible := false;
  end;
end;

procedure TMainForm.CreateIndices(AConn: TADConnection = nil);
begin
  if not Assigned(AConn) then
    AConn := FConnection;
  if not AConn.Connected then Exit;
  AConn.ExecSQL(
    ' CREATE INDEX IF NOT EXISTS SaveLog_AppName ON SaveLog (AppName);');
  AConn.ExecSQL(
    ' CREATE INDEX IF NOT EXISTS SaveLog_AppKeyEfileNumber ON SaveLog (AppKey, EfileNumber);');
end;

procedure TMainForm.FConnectionAfterConnect(Sender: TObject);
begin
  ConnectionStateChanged;
  CreateIndices;
  FillAppMisuse(FConnection, true); //20220524 Igor
end;

procedure TMainForm.FillAppMisuse(AConn: TADConnection = nil; AForceClear: boolean = false);
var Q: TADQuery;
begin
  if not Assigned(AConn) then
    AConn := FConnection;
  if not AConn.Connected then Exit;
  Q := TADQuery.Create(nil);
  try
    AConn.ExecSQL(
      ' CREATE TABLE IF NOT EXISTS AppMisuse ( '+
      '   Id     INTEGER       PRIMARY KEY AUTOINCREMENT '+
      '                                      UNIQUE '+
      '                                      NOT NULL, '+
      '   AppKey VARCHAR(20), '+
      '   Efiler VARCHAR(20), '+
      '   SeqNo INTEGER '+
      ');');
    AConn.ExecSQL(
      ' CREATE INDEX IF NOT EXISTS AppMisuse_AppKeySeqNo ON AppMisuse (AppKey, SeqNo);');
    if AForceClear then
      AConn.ExecSQl(
        ' DELETE FROM AppMisuse ');
    Q.Connection := AConn;
    Q.SQL.Text := 'SELECT COUNT(*) AS C FROM AppMisuse';
    Q.Open;
    if Q.FieldByName('C').AsInteger = 0 then
      AConn.ExecSQL(
        ' INSERT INTO AppMisuse(AppKey, Efiler, SeqNo) '+ #13#10 +
        ' SELECT '+ #13#10 +
        '     AppKey, '+ #13#10 +
        '     CASE WHEN IFNULL(TRIM(EfileNumber), '''') = '''' THEN ''EMPTY'' ELSE SUBSTRING(EfileNumber, 1, 5) END || ": " || ReturnCount AS Efiler, '+ #13#10 +
        '     ( '+ #13#10 +
        '         SELECT COUNT(*) '+ #13#10 +
        '         FROM '+ #13#10 +
        '         ( '+ #13#10 +
        '             SELECT DISTINCT AppKey, EfileNumber '+ #13#10 +
        '             FROM SaveLog '+ #13#10 +
        '         ) S2 '+ #13#10 +
        '         WHERE S.AppKey = S2.AppKey AND S.EfileNumber <= S2.EfileNumber '+ #13#10 +
        '     ) AS SeqNo '+ #13#10 +
        ' FROM '+ #13#10 +
        ' ( '+ #13#10 +
        '     SELECT AppKey, EfileNumber, MAX(ReturnCount) AS ReturnCount '+ #13#10 +
        '     FROM SaveLog '+ #13#10 +
        '     GROUP BY AppKey, EfileNumber '+ #13#10 +
        ' ) S ');
  finally
    Q.Close; Q.Free;
  end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveSettings;
  //20220524 Igor >>>
  if FConnection.Connected then
    FConnection.Connected := false;
  //20220524 Igor <<<
end;

procedure TMainForm.FormCreate(Sender: TObject); //20220524 Igor
begin
  FAppKeyList := TStringList.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject); //20220524 Igor
begin
  FAppKeyList.Free;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  FConnection.Connected := false;
  LoadSettings;
  ConnectionStateChanged;
  pcMain.TabIndex:= 0;
  rbExportGroup.ItemIndex:= 0;
end;

procedure TMainForm.InitAppCombo;
var cSave: string;
    nIndex: integer;
begin
  cSave := cbApp.Items[cbApp.ItemIndex];
  QApp.Close;
  QApp.Open;
  cbApp.Items.Clear;
  cbApp.Items.Add('< ALL >');
  while not QApp.Eof do
  begin
    cbApp.Items.Add(QApp.FieldByName('AppName').AsString);
    QApp.Next;
  end;
  nIndex := cbApp.Items.IndexOf(cSave);
  if nIndex = -1 then
    nIndex := 0;
  cbApp.ItemIndex := nIndex;
end;

procedure TMainForm.LoadSettings;
var FIniFile: TIniFile;
    FRBMode: integer;
    cApp: string;
begin
  FIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    edDBFile.Text := FIniFile.ReadString('Main', 'DBFile', '');
    deStart.Date := FIniFile.ReadDateTime('Main', 'StartDate', Date);
    deEnd.Date := FIniFile.ReadDateTime('Main', 'EndDate', Date);
    FRBMode := FIniFile.ReadInteger('Main', 'RbMode', 0);
    rbAll.Checked := FRBMode = 0;
    rbKeyMisUse.Checked := FRBMode = 1;
    rbT2MisUse.Checked := FRBMode = 2;

    cbComputerName.Checked:= FIniFile.ReadInteger('Main', 'ComputerName', 0) = 1;
    cbIgnoreEmptyValues.Checked := FIniFile.ReadInteger('Main', 'IgnoreEmptyValues', 0) = 1;
    cbEfiler.Checked := FIniFile.ReadInteger('Main', 'UseEfilerNumber', 0) = 1;
    cbPreparerName.Checked := FIniFile.ReadInteger('Main', 'UsePreparerName', 0) = 1;
    cbPreparerAddress.Checked := FIniFile.ReadInteger('Main', 'UsePreparerAddress', 0) = 1;
    cbPrintEfiler4.Checked := FIniFile.ReadInteger('Main', 'PrintEfiler4', 0) = 1;
    cbPrintToExcel.Checked := FIniFile.ReadInteger('Main', 'PrintToExcel', 0) = 1;

    cApp := FIniFile.ReadString('Main', 'AppName', '< ALL >');
    if cbApp.Items.IndexOf(cApp) = -1 then
      cbApp.Items.Add(cApp);
    cbApp.ItemIndex := cbApp.Items.IndexOf(cApp);
    edKey.Text := FIniFile.ReadString('Main', 'Key', '');
  finally
    FIniFile.Free;
  end;
end;

procedure TMainForm.OpenQAppMisUseReport; //20220524 Igor
var cMisUseFilter: string;
begin
  QAppKeyMisuseReport.Close;

  cMisUseFilter := '1 = 0';
  if cbIgnoreEmptyValues.Checked then
  begin
    if cbEfiler.Checked then
      cMisUseFilter := cMisUseFilter + ' OR COUNT(DISTINCT CASE WHEN TRIM(S.EfileNumber) = '''' THEN NULL ELSE S.EfileNumber END) > 1 ';
    if cbPreparerName.Checked then
      cMisUseFilter := cMisUseFilter + ' OR COUNT(DISTINCT CASE WHEN TRIM(S.PreparerName) = '''' THEN NULL ELSE S.PreparerName END) > 1 ';
    if cbPreparerAddress.Checked then
      cMisUseFilter := cMisUseFilter + ' OR COUNT(DISTINCT CASE WHEN TRIM(S.PreparerAddress) = '''' THEN NULL ELSE S.PreparerAddress END) > 1 ';
  end
  else
  begin
    if cbEfiler.Checked then
      cMisUseFilter := cMisUseFilter + ' OR COUNT(DISTINCT S.EfileNumber) > 1 ';
    if cbPreparerName.Checked then
      cMisUseFilter := cMisUseFilter + ' OR COUNT(DISTINCT S.PreparerName) > 1 ';
    if cbPreparerAddress.Checked then
      cMisUseFilter := cMisUseFilter + ' OR COUNT(DISTINCT S.PreparerAddress) > 1 ';
  end;

  QAppKeyMisuseReport.MacroByName('MisUseFilter').Value := cMisUseFilter;
  QAppKeyMisuseReport.Open;
end;

procedure TMainForm.PrintAppMisuseToTxt; //20220524 Igor
var cFile, cHeader, cLine, cValue: string;
    F1: TextFile;
    qTemp: TADQuery;
begin
  if not cbEfiler.Checked and not cbPreparerName.Checked and not cbPreparerAddress.Checked then
  begin
    ShowMessage('Select at least one field to use for Appkey misuse detection');
    Exit;
  end;
  SaveReportDialog.FileName := 'App Key Misuse Report.txt';
  if not SaveReportDialog.Execute then Exit;
  cFile := SaveReportDialog.FileName;
  FillAppMisuse;

  QAppKeyMisuseReport.Close;
  OpenQAppMisUseReport;
  if QAppKeyMisuseReport.RecordCount = 0 then
  begin
    ShowMessage('There are no misued keys for export');
    Exit;
  end;
  QAppKeyMisuseReport.First;

  cHeader := PaddR('App', 8) +
             PaddR('Key', 20) +
             PaddR('Lic. Lvl', 11) +
             PaddR('Start Date', 18) +
             PaddR('End Date', 18) +
             PaddR('Efiler1', 12) +
             PaddR('Efiler2', 12) +
             PaddR('Efiler3', 12);
  if cbPrintEfiler4.Checked then
    cHeader := cHeader +
               PaddR('Efiler4', 12);

  qTemp := TADQuery.Create(nil);
  AssignFile(F1, cFile);
  try
    qTemp.Connection := FConnection;
    Rewrite(F1);
    WriteLn(F1, 'App Key Misuse Summary report');
    WriteLn(F1, '');
    WriteLn(F1, cHeader);
    WriteLn(F1, StringOfChar('-', Length(cHeader)));

    while not QAppKeyMisuseReport.Eof do
    begin
      cLine := PaddR(QAppKeyMisuseReport.FieldByName('AppName').AsString, 7) + ' ' +
              PaddR(QAppKeyMisuseReport.FieldByName('AppKey').AsString, 19) + ' ' +
              PaddR(QAppKeyMisuseReport.FieldByName('LicenseLevel').AsString, 10) + ' ' +
              PaddR(QAppKeyMisuseReport.FieldByName('StartDate').AsString, 17) + ' ' +
              PaddR(QAppKeyMisuseReport.FieldByName('EndDate').AsString, 17) + ' ' +
              PaddR(QAppKeyMisuseReport.FieldByName('Efiler1').AsString, 11) + ' ' +
              PaddR(QAppKeyMisuseReport.FieldByName('Efiler2').AsString, 11) + ' ' +
              PaddR(QAppKeyMisuseReport.FieldByName('Efiler3').AsString, 11);
      if cbPrintEfiler4.Checked then
        cLine := cLine + ' ' +
              PaddR(QAppKeyMisuseReport.FieldByName('Efiler4').AsString, 11);
      WriteLn(F1, cLine);

      qTemp.Close;
      qTemp.SQL.Text :=
        ' SELECT PreparerName, MAX(ReturnCount) AS ReturnCount '+
        ' FROM SaveLog '+
        ' WHERE AppKey = :AppKey '+
        ' GROUP BY PreparerName';
      qTemp.ParamByName('AppKey').Value := QAppKeyMisuseReport.FieldByName('AppKey').AsString;
      qTemp.Open;
      if qTemp.RecordCount > 1 then
      begin
        cLine := '    Preparer Names:';
        WriteLn(F1, cLine);
        while not qTemp.Eof do
        begin
          cValue := qTemp.FieldByName('PreparerName').AsString;
          if cValue.IsEmpty then
            cValue := '< EMPTY >';
          cLine := '      '+ cValue + ' (ReturnCount: '+ IntToStr(qTemp.FieldByName('ReturnCount').AsInteger) + ')';
          WriteLn(F1, cLine);
          qTemp.Next;
        end;
      end;

      qTemp.Close;
      qTemp.SQL.Text :=
        ' SELECT PreparerAddress, MAX(ReturnCount) AS ReturnCount '+
        ' FROM SaveLog '+
        ' WHERE AppKey = :AppKey '+
        ' GROUP BY PreparerAddress';
      qTemp.ParamByName('AppKey').Value := QAppKeyMisuseReport.FieldByName('AppKey').AsString;
      qTemp.Open;
      if qTemp.RecordCount > 1 then
      begin
        cLine := '    Preparer Addresses:';
        WriteLn(F1, cLine);
        while not qTemp.Eof do
        begin
          cValue := qTemp.FieldByName('PreparerAddress').AsString;
          if cValue.IsEmpty then
            cValue := '< EMPTY >';
          cLine := '      '+ cValue + ' (ReturnCount: '+ IntToStr(qTemp.FieldByName('ReturnCount').AsInteger) + ')';
          WriteLn(F1, cLine);
          qTemp.Next;
        end;
      end;

      QAppKeyMisuseReport.Next;
    end;
  finally
    CloseFile(F1);
    FreeAndNil(qTemp);
  end;
  //ShowMessage('Report is successfully created!');
  ShellExecute(Application.Handle, 'open', PChar(cFile), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.QDataAfterScroll(DataSet: TDataSet);
begin
  sbAppMon.Panels[0].Text := IntToStr(DataSet.RecNo) + ':' + IntToStr(DataSet.RecordCount);
end;

procedure TMainForm.SaveSettings;
var FIniFile: TIniFile;
    FRBMode: integer;
begin
  FIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    FIniFile.WriteString('Main', 'DBFile', edDBFile.Text);
    FIniFile.WriteDateTime('Main', 'StartDate', deStart.Date);
    FIniFile.WriteDateTime('Main', 'EndDate', deEnd.Date);
    if rbKeyMisUse.Checked then
      FRBMode := 1
    else if rbT2MisUse.Checked then
      FRBMode := 2
    else
      FRBMode := 0;
    FIniFile.WriteInteger('Main', 'RbMode', FRBMode);

    FIniFile.WriteInteger('Main', 'ComputerName', IfThen(cbComputerName.Checked, 1, 0));

    if cbIgnoreEmptyValues.Checked then
      FIniFile.WriteInteger('Main', 'IgnoreEmptyValues', 1)
    else
      FIniFile.WriteInteger('Main', 'IgnoreEmptyValues', 0);
    if cbEfiler.Checked then
      FIniFile.WriteInteger('Main', 'UseEfilerNumber', 1)
    else
      FIniFile.WriteInteger('Main', 'UseEfilerNumber', 0);
    if cbPreparerName.Checked then
      FIniFile.WriteInteger('Main', 'UsePreparerName', 1)
    else
      FIniFile.WriteInteger('Main', 'UsePreparerName', 0);
    if cbPreparerAddress.Checked then
      FIniFile.WriteInteger('Main', 'UsePreparerAddress', 1)
    else
      FIniFile.WriteInteger('Main', 'UsePreparerAddress', 0);
    if cbPrintEfiler4.Checked then
      FIniFile.WriteInteger('Main', 'PrintEfiler4', 1)
    else
      FIniFile.WriteInteger('Main', 'PrintEfiler4', 0);
    if cbPrintToExcel.Checked then
      FIniFile.WriteInteger('Main', 'PrintToExcel', 1)
    else
      FIniFile.WriteInteger('Main', 'PrintToExcel', 0);
    //20220524 Igor <<<
    FIniFile.WriteString('Main', 'AppName', cbApp.Text);
    FIniFile.WriteString('Main', 'Key', edKey.Text);
  finally
    FIniFile.Free;
  end;
end;

procedure TMainForm.actAppMisuseExecute(Sender: TObject);
begin
  if cbPrintToExcel.Checked then
    PrintAppMisuseToExcel
  else
    PrintAppMisuseToTxt;
end;

procedure TMainForm.PrintAppMisuseToExcel; //20220524 Igor
var qTemp: TADQuery;
    cFile, cValue: string;
    FSaveSheetsCount: integer;
    nLine, nLastCol: integer;
    xlApp, xlBook, xlSheet, xlRange: OLEVariant;

    procedure SetBorders(ARange: OLEVariant; AWeight, ALineStyle: integer);
    const
      xlEdgeLeft = 7;
      xlEdgeTop = 8;
      xlEdgeBottom = 9;
      xlEdgeRight = 10;
      xlInsideVertical = 11;
      xlInsideHorizontal = 12;
      xlAbove = 0;
      xlBelow = 1;
      xlLeft = -4131;
      xlRight = -4152;
    begin
      ARange.Borders.Item[xlEdgeLeft].Weight := AWeight;
      ARange.Borders.Item[xlEdgeLeft].LineStyle := ALineStyle;
      ARange.Borders.Item[xlEdgeTop].Weight := AWeight;
      ARange.Borders.Item[xlEdgeTop].LineStyle := ALineStyle;
      ARange.Borders.Item[xlEdgeRight].Weight := AWeight;
      ARange.Borders.Item[xlEdgeRight].LineStyle := ALineStyle;
      ARange.Borders.Item[xlEdgeBottom].Weight := AWeight;
      ARange.Borders.Item[xlEdgeBottom].LineStyle := ALineStyle;
      ARange.Borders.Item[xlInsideVertical].Weight := AWeight;
      ARange.Borders.Item[xlInsideVertical].LineStyle := ALineStyle;
      ARange.Borders.Item[xlInsideHorizontal].Weight := AWeight;
      ARange.Borders.Item[xlInsideHorizontal].LineStyle := ALineStyle;
    end;

begin
  SaveXlsReportDialog.FileName := 'App Key Misuse Report.xlsx';
  if not SaveXlsReportDialog.Execute then Exit;
  cFile:= SaveXlsReportDialog.FileName;
  if FileExists(cFile) then
    if not DeleteFile(PChar(cFile)) then
    begin
      ShowMessage('File '+ QuotedStr(cFile) + ' already exists and cannot be overwritten. ');
      Exit;
    end;
{  FillAppMisuse;
  OpenQAppMisUseReport;
  if QAppKeyMisuseReport.RecordCount = 0 then
  begin
    ShowMessage('There are no misued keys for export');
    Exit;
  end;
  QAppKeyMisuseReport.First;
}
  qTemp:= TADQuery.Create(nil);
  try
    qTemp.Connection:= FConnection;

    xlApp:= CreateOLEObject('Excel.Application');
    try
      xlApp.Application.ScreenUpdating:= false;
      xlApp.DisplayAlerts:= False;
      FSaveSheetsCount:= xlApp.SheetsInNewWorkbook;
      try
        xlApp.SheetsInNewWorkbook:= 1;
        xlBook:= xlApp.WorkBooks.Add;
        xlSheet:= xlBook.ActiveSheet;
      finally
        xlApp.SheetsInNewWorkbook:= FSaveSheetsCount;
      end;

      xlSheet.Cells[1,1].FormulaR1C1:= 'App Key Misuse Summary report';
      xlSheet.Cells[1,1].Font.Bold:= true;
      xlSheet.Cells[1,1].Font.Size:= 14;


      xlSheet.Cells[2,1].FormulaR1C1:= 'App';
      xlSheet.Cells[2,2].FormulaR1C1:= 'Key';
      xlSheet.Cells[2,3].FormulaR1C1:= 'Lic. Lvl';
      xlSheet.Cells[2,4].FormulaR1C1:= 'Start Date';
      xlSheet.Cells[2,5].FormulaR1C1:= 'End Date';
      nLastCol:= 5;
      xlSheet.Range[xlSheet.Cells[1, 1], xlSheet.Cells[1, nLastCol]].Merge;

      nLine:= 3;

      while not QAppKeyMisuseReport.Eof do
      begin
        xlSheet.Cells[nLine,1].FormulaR1C1 := QAppKeyMisuseReport.FieldByName('AppName').AsString;
        xlSheet.Cells[nLine,2].FormulaR1C1 := QAppKeyMisuseReport.FieldByName('AppKey').AsString;
        xlSheet.Cells[nLine,3].FormulaR1C1 := QAppKeyMisuseReport.FieldByName('LicenseLevel').AsString;
        xlSheet.Cells[nLine,4].FormulaR1C1 := QAppKeyMisuseReport.FieldByName('StartDate').AsString;
        xlSheet.Cells[nLine,5].FormulaR1C1 := QAppKeyMisuseReport.FieldByName('EndDate').AsString;
        xlRange := xlSheet.Range[xlSheet.Cells[nLine, 1], xlSheet.Cells[nLine, nLastCol]];
        SetBorders(xlRange, 2, 1); // thin borders
        inc(nLine);

        qTemp.Close;
        qTemp.SQL.Text :=
          ' SELECT EfileNumber, MAX(ReturnCount) AS ReturnCount '+
          ' FROM SaveLog '+
          ' WHERE AppKey = :AppKey '+
          ' GROUP BY EfileNumber';
        qTemp.ParamByName('AppKey').Value := QAppKeyMisuseReport.FieldByName('AppKey').AsString;
        qTemp.Open;
        if qTemp.RecordCount > 1 then
        begin
          xlSheet.Cells[nLine,2].FormulaR1C1 := 'Efilers:';
          xlSheet.Cells[nLine,2].Font.Italic := true;
          xlSheet.Cells[nLine,2].Font.Bold := true;
          xlSheet.Range[xlSheet.Cells[nLine, 2], xlSheet.Cells[nLine, nLastCol]].Merge;
          xlRange := xlSheet.Range[xlSheet.Cells[nLine, 2], xlSheet.Cells[nLine, nLastCol]];
          SetBorders(xlRange, 2, 1); // thin borders
          inc(nLine);
          while not qTemp.Eof do
          begin
            cValue := qTemp.FieldByName('EfileNumber').AsString;
            if cValue.IsEmpty then
              cValue := '< EMPTY >';

            xlSheet.Cells[nLine,2].FormulaR1C1 := cValue;
            xlSheet.Range[xlSheet.Cells[nLine, 2], xlSheet.Cells[nLine, nLastCol-2]].Merge;

            xlSheet.Cells[nLine,nLastCol-1].FormulaR1C1 := 'Return Count:';
            xlSheet.Cells[nLine,nLastCol].FormulaR1C1 := qTemp.FieldByName('ReturnCount').AsInteger;
            xlRange := xlSheet.Range[xlSheet.Cells[nLine, 2], xlSheet.Cells[nLine, nLastCol]];
            SetBorders(xlRange, 2, 1); // thin borders
            inc(nLine);
            qTemp.Next;
          end;
        end;

        qTemp.Close;
        qTemp.SQL.Text :=
          ' SELECT PreparerName, MAX(ReturnCount) AS ReturnCount '+
          ' FROM SaveLog '+
          ' WHERE AppKey = :AppKey '+
          ' GROUP BY PreparerName';
        qTemp.ParamByName('AppKey').Value := QAppKeyMisuseReport.FieldByName('AppKey').AsString;
        qTemp.Open;
        if qTemp.RecordCount > 1 then
        begin
          xlSheet.Cells[nLine,2].FormulaR1C1 := 'Preparer Names:';
          xlSheet.Cells[nLine,2].Font.Italic := true;
          xlSheet.Cells[nLine,2].Font.Bold := true;
          xlSheet.Range[xlSheet.Cells[nLine, 2], xlSheet.Cells[nLine, nLastCol]].Merge;
          xlRange := xlSheet.Range[xlSheet.Cells[nLine, 2], xlSheet.Cells[nLine, nLastCol]];
          SetBorders(xlRange, 2, 1); // thin borders
          inc(nLine);
          while not qTemp.Eof do
          begin
            cValue := qTemp.FieldByName('PreparerName').AsString;
            if cValue.IsEmpty then
              cValue := '< EMPTY >';

            xlSheet.Cells[nLine,2].FormulaR1C1 := cValue;
            xlSheet.Range[xlSheet.Cells[nLine, 2], xlSheet.Cells[nLine, nLastCol-2]].Merge;

            xlSheet.Cells[nLine,nLastCol-1].FormulaR1C1 := 'Return Count:';
            xlSheet.Cells[nLine,nLastCol].FormulaR1C1 := qTemp.FieldByName('ReturnCount').AsInteger;
            xlRange := xlSheet.Range[xlSheet.Cells[nLine, 2], xlSheet.Cells[nLine, nLastCol]];
            SetBorders(xlRange, 2, 1); // thin borders
            inc(nLine);
            qTemp.Next;
          end;
        end;

        qTemp.Close;
        qTemp.SQL.Text :=
          ' SELECT PreparerAddress, MAX(ReturnCount) AS ReturnCount '+
          ' FROM SaveLog '+
          ' WHERE AppKey = :AppKey '+
          ' GROUP BY PreparerAddress';
        qTemp.ParamByName('AppKey').Value := QAppKeyMisuseReport.FieldByName('AppKey').AsString;
        qTemp.Open;
        if qTemp.RecordCount > 1 then
        begin
          xlSheet.Cells[nLine,2].FormulaR1C1 := 'Preparer Addresses:';
          xlSheet.Cells[nLine,2].Font.Italic := true;
          xlSheet.Cells[nLine,2].Font.Bold := true;
          xlSheet.Range[xlSheet.Cells[nLine, 2], xlSheet.Cells[nLine, nLastCol]].Merge;
          xlRange := xlSheet.Range[xlSheet.Cells[nLine, 2], xlSheet.Cells[nLine, nLastCol]];
          SetBorders(xlRange, 2, 1); // thin borders
          inc(nLine);
          while not qTemp.Eof do
          begin
            cValue := qTemp.FieldByName('PreparerAddress').AsString;
            if cValue.IsEmpty then
              cValue := '< EMPTY >';
            xlSheet.Cells[nLine,2].FormulaR1C1 := cValue;
            xlSheet.Range[xlSheet.Cells[nLine, 2], xlSheet.Cells[nLine, nLastCol-2]].Merge;

            xlSheet.Cells[nLine,nLastCol-1].FormulaR1C1 := 'Return Count:';
            xlSheet.Cells[nLine,nLastCol].FormulaR1C1 := qTemp.FieldByName('ReturnCount').AsInteger;
            xlRange := xlSheet.Range[xlSheet.Cells[nLine, 2], xlSheet.Cells[nLine, nLastCol]];
            SetBorders(xlRange, 2, 1); // thin borders
            inc(nLine);
            qTemp.Next;
          end;
        end;

        QAppKeyMisuseReport.Next;
      end;


      xlRange := xlSheet.Range[xlSheet.Cells[2, 1], xlSheet.Cells[2, nLastCol]];
      SetBorders(xlRange, -4138, 1); //thick borders

      xlRange.EntireColumn.AutoFit;
      xlRange.EntireRow.AutoFit;

      ForceDirectories(ExtractFilePath(cFile));
      xlApp.ActiveWorkbook.SaveAs(cFile);
      xlApp.ActiveWindow.Close;
    finally
      if not VarIsEmpty(XLApp) then
      begin
        xlApp.Application.ScreenUpdating:= true;
        xlApp.DisplayAlerts:= true;
        xlApp.Quit;
        xlApp:= Unassigned;
        xlSheet:= Unassigned;
      end;
    end;
  finally
    FreeAndNil(qTemp);
  end;

  ShellExecute(Application.Handle, 'open', PChar(cFile), nil, nil, SW_SHOWNORMAL);
end;

//New part

procedure TMainForm.actFindOffendersExecute(Sender: TObject);
var
  lSQL, lShortSQL, lSQLCondition, lShortSQLCondition, lKeys, lMisUse: string;
  lArr: TArray<string>;
  ifor: Integer;

  function ConditionAdd(aIsCheckerChecked: Boolean; aParameterName, aSQLCondition: string): string;
  begin
    Result:= aSQLCondition;

    if aIsCheckerChecked then
      if aSQLCondition.IsEmpty() then
        Result:= 'COALESCE(' + aParameterName + ', '''')'
      else
        Result:= aSQLCondition + ' || ''|'' || ' + 'COALESCE(' + aParameterName + ', '''')';
  end;

begin
  lKeys:= edKey.Text;
  lArr:= lKeys.Split([','], ExcludeEmpty);
  lKeys:= '';
  for ifor:= 0 to pred(Length(lArr)) do
  begin
    if not SameText(lKeys, '') then lKeys:= lKeys + ',';
    lKeys:= lKeys + QuotedStr(lArr[ifor]);
  end;

  //Full data list
  lSQL:= 'SELECT Id, AppName, AppKey, LicenseLevel, ReturnCountLimited, MaxReturnCount, EventDate, ComputerName, PreparerName, PreparerAddress, ReturnCount, FileName, EfileNumber, TaxationYear, AdditionalInfo' + #13#10;
  lSQL:= lSQL + '  FROM SaveLog' + #13#10;
  lSQL := lSQL + ' WHERE EventDate >= ' + 'DateTime(''' + FormatDateTime('yyyy-mm-dd', deStart.Date) + ' 00:00:01'')' + ' AND EventDate < date(' + 'DateTime(''' + FormatDateTime('yyyy-mm-dd', deEnd.Date) + ' 23:59:59'')' +', ''+1 day'') '+ #13#10;
  if cbIgnoreEmptyValues.Checked then lSQL:= lSQL + '   AND EfileNumber != ''''' + #13#10;
  if (cbApp.ItemIndex > 0) then lSQL:= lSQL + ' AND AppName = ' + QuotedStr(cbApp.Text) + #13#10;
  if not SameText(lKeys, '') then lSQL:= lSQL + ' AND AppKey IN (' + lKeys + ')' + #13#10;

  lSQL:= lSQL + ' AND AppKey IN (SELECT AppKey FROM SaveLog' + #13#10;
  lSQL:= lSQL + ' WHERE EventDate >= ' + 'DateTime(''' + FormatDateTime('yyyy-mm-dd', deStart.Date) + ' 00:00:01'')' + ' AND EventDate < date(' + 'DateTime(''' + FormatDateTime('yyyy-mm-dd', deEnd.Date) + ' 23:59:59'')' +', ''+1 day'') '+ #13#10;
  if cbIgnoreEmptyValues.Checked then lSQL:= lSQL + ' AND EfileNumber != ''''' + #13#10;
  if (cbApp.ItemIndex > 0) then lSQL := lSQL + ' AND AppName = '+ QuotedStr(cbApp.Text);
  if not SameText(lKeys, '') then lSQL:= lSQL + ' AND AppKey IN (' + lKeys + ')' + #13#10;

  lSQL:= lSQL + '   GROUP BY AppKey' + #13#10;
  lSQL:= lSQL + '  HAVING COUNT(*) > 1' + #13#10;

  if cbComputerName.Checked or cbPreparerName.Checked or cbPreparerAddress.Checked or cbEfiler.Checked then
  begin
    lSQL:= lSQL + '  AND COUNT(DISTINCT ' + #13#10;
    lSQLCondition:= ConditionAdd(cbComputerName.Checked, 'ComputerName', lSQLCondition);
    lSQLCondition:= ConditionAdd(cbPreparerName.Checked, 'PreparerName', lSQLCondition);
    lSQLCondition:= ConditionAdd(cbPreparerAddress.Checked, 'PreparerAddress', lSQLCondition);
    lSQLCondition:= ConditionAdd(cbEfiler.Checked, 'EfileNumber', lSQLCondition);
    lSQL:= lSQL + lSQLCondition;
    lSQL:= lSQL + ') > 1' + #13#10;
  end;
  lSQL:= lSQL + ')' + #13#10;

  lSQL:= lSQL + ' ORDER BY &SORTFIELD';

  //Short data list
  //lShortSQL:= 'SELECT ROW_NUMBER() OVER (ORDER BY AppName, AppKey) AS Id, AppName, AppKey, EventDate, ComputerName, PreparerName, PreparerAddress, EfileNumber' + #13#10;
  lShortSQL:= 'SELECT DISTINCT AppName, AppKey, ComputerName, PreparerName, PreparerAddress, EfileNumber' + #13#10;
  lShortSQL:= lShortSQL + ' FROM SaveLog' + #13#10;
  lShortSQL := lShortSQL + ' WHERE EventDate >= ' + 'DateTime(''' + FormatDateTime('yyyy-mm-dd', deStart.Date) + ' 00:00:01'')' + ' AND EventDate < date(' + 'DateTime(''' + FormatDateTime('yyyy-mm-dd', deEnd.Date) + ' 23:59:59'')' +', ''+1 day'')' + #13#10;
  if cbIgnoreEmptyValues.Checked then lShortSQL:= lShortSQL + '   AND EfileNumber != ''''' + #13#10;
  if (cbApp.ItemIndex > 0) then lShortSQL:= lShortSQL + ' AND AppName = ' + QuotedStr(cbApp.Text) + #13#10;
  if not SameText(lKeys, '') then lShortSQL:= lShortSQL + ' AND AppKey IN (' + lKeys + ')' + #13#10;

  lShortSQL:= lShortSQL + ' AND AppKey IN (SELECT AppKey FROM SaveLog' + #13#10;
  lShortSQL:= lShortSQL + ' WHERE EventDate >= ' + 'DateTime(''' + FormatDateTime('yyyy-mm-dd', deStart.Date) + ' 00:00:01'')' + ' AND EventDate < date(' + 'DateTime(''' + FormatDateTime('yyyy-mm-dd', deEnd.Date) + ' 23:59:59'')' +', ''+1 day'')' + #13#10;
  if cbIgnoreEmptyValues.Checked then lShortSQL:= lShortSQL + ' AND EfileNumber != ''''' + #13#10;
  if (cbApp.ItemIndex > 0) then lShortSQL:= lShortSQL + ' AND AppName = '+ QuotedStr(cbApp.Text);
  if not SameText(lKeys, '') then lShortSQL:= lShortSQL + ' AND AppKey IN (' + lKeys + ')' + #13#10;

  lShortSQL:= lShortSQL + '   GROUP BY AppKey' + #13#10;
  lShortSQL:= lShortSQL + '  HAVING COUNT(*) > 1' + #13#10;

  if cbComputerName.Checked or cbPreparerName.Checked or cbPreparerAddress.Checked or cbEfiler.Checked then
  begin
    lShortSQL:= lShortSQL + '  AND COUNT(DISTINCT ' + #13#10;
    lShortSQLCondition:= ConditionAdd(cbComputerName.Checked, 'ComputerName', lShortSQLCondition);
    lShortSQLCondition:= ConditionAdd(cbPreparerName.Checked, 'PreparerName', lShortSQLCondition);
    lShortSQLCondition:= ConditionAdd(cbPreparerAddress.Checked, 'PreparerAddress', lShortSQLCondition);
    lShortSQLCondition:= ConditionAdd(cbEfiler.Checked, 'EfileNumber', lShortSQLCondition);
    lShortSQL:= lShortSQL + lShortSQLCondition;
    lShortSQL:= lShortSQL + ') > 1' + #13#10;
  end;
  lShortSQL:= lShortSQL + ')' + #13#10;

  lShortSQL:= lShortSQL + ' ORDER BY &SORTFIELD';

  //Full data list
  FDefaultSort:= 'AppName ASC, AppKey ASC';
  QData.Close;
  QData.SQL.Text:= lSQL;
  QData.MacroByName('SORTFIELD').AsRaw:= FDefaultSort;
  QData.Open;

  //Short data list
  qShortData.Close;
  qShortData.SQL.Text:= lShortSQL;
  qShortData.MacroByName('SORTFIELD').AsRaw:= FDefaultSort;
  qShortData.Open;

  RefreshAppKeyList;
end;

procedure TMainForm.RefreshAppKeyList;
var
  FRecNo: integer;
begin
  //Full data list
  FAppKeyList.Clear;
//  if not SameText(FDefaultSort, 'AppKey') then Exit;
  QData.DisableControls;
  dsData.DataSet:= nil;
  FRecNo:= QData.RecNo;

  try
    while not QData.Eof do
    begin
      if FAppKeyList.IndexOf(QData.FieldByName('AppKey').AsString) = -1 then FAppKeyList.Add(QData.FieldByName('AppKey').AsString);
      QData.Next;
    end;
  finally
    QData.RecNo:= FRecNo;
    QData.EnableControls;
    dsData.DataSet:= QData;
  end;

  //Short data list
  FAppKeyList.Clear;
  qShortData.DisableControls;
  dsShortData.DataSet:= nil;
  FRecNo:= qShortData.RecNo;

  try
    while not qShortData.Eof do
    begin
      if FAppKeyList.IndexOf(qShortData.FieldByName('AppKey').AsString) = -1 then FAppKeyList.Add(qShortData.FieldByName('AppKey').AsString);
      qShortData.Next;
    end;
  finally
    qShortData.RecNo:= FRecNo;
    qShortData.EnableControls;
    dsShortData.DataSet:= qShortData;
  end;
end;

procedure TMainForm.actExportDataToExcelExecute(Sender: TObject);
var
  qTemp: TADQuery;
  cFile, cValue: string;
  FSaveSheetsCount: integer;
  nLine, nLastCol: integer;
  xlApp, xlBook, xlSheet, xlRange: OLEVariant;

  procedure SetBorders(ARange: OLEVariant; AWeight, ALineStyle: integer);
  const
    xlEdgeLeft = 7;
    xlEdgeTop = 8;
    xlEdgeBottom = 9;
    xlEdgeRight = 10;
    xlInsideVertical = 11;
    xlInsideHorizontal = 12;
    xlAbove = 0;
    xlBelow = 1;
    xlLeft = -4131;
    xlRight = -4152;
  begin
    ARange.Borders.Item[xlEdgeLeft].Weight:= AWeight;
    ARange.Borders.Item[xlEdgeLeft].LineStyle:= ALineStyle;
    ARange.Borders.Item[xlEdgeTop].Weight:= AWeight;
    ARange.Borders.Item[xlEdgeTop].LineStyle:= ALineStyle;
    ARange.Borders.Item[xlEdgeRight].Weight:= AWeight;
    ARange.Borders.Item[xlEdgeRight].LineStyle:= ALineStyle;
    ARange.Borders.Item[xlEdgeBottom].Weight:= AWeight;
    ARange.Borders.Item[xlEdgeBottom].LineStyle:= ALineStyle;
    ARange.Borders.Item[xlInsideVertical].Weight:= AWeight;
    ARange.Borders.Item[xlInsideVertical].LineStyle:= ALineStyle;
    ARange.Borders.Item[xlInsideHorizontal].Weight:= AWeight;
    ARange.Borders.Item[xlInsideHorizontal].LineStyle:= ALineStyle;
  end;

begin
  if rbExportGroup.ItemIndex = 0 then
    SaveXlsReportDialog.FileName:= 'Full list of offenders report.xlsx'
  else
  if rbExportGroup.ItemIndex = 1 then
    SaveXlsReportDialog.FileName:= 'Short list of offenders report.xlsx';

  if not SaveXlsReportDialog.Execute then Exit;
  cFile:= SaveXlsReportDialog.FileName;

  if FileExists(cFile) then
    if not DeleteFile(PChar(cFile)) then
    begin
      ShowMessage('File '+ QuotedStr(cFile) + ' already exists and cannot be overwritten. ');
      Exit;
    end;

  qTemp:= TADQuery.Create(nil);
  try
    qTemp.Connection:= FConnection;

    xlApp:= CreateOLEObject('Excel.Application');
    try
      xlApp.Application.ScreenUpdating:= false;
      xlApp.DisplayAlerts:= False;
      FSaveSheetsCount:= xlApp.SheetsInNewWorkbook;
      try
        xlApp.SheetsInNewWorkbook:= 1;
        xlBook:= xlApp.WorkBooks.Add;
        xlSheet:= xlBook.ActiveSheet;
      finally
        xlApp.SheetsInNewWorkbook:= FSaveSheetsCount;
      end;

      //Full
      if rbExportGroup.ItemIndex = 0 then
      begin
        xlSheet.Cells[1, 1].FormulaR1C1:= 'Full list of offenders report';
        xlSheet.Cells[1, 1].Font.Bold:= true;
        xlSheet.Cells[1, 1].Font.Size:= 14;

        xlSheet.Cells[2, 1].FormulaR1C1:= 'App Name';
        xlSheet.Cells[2, 2].FormulaR1C1:= 'App Key';
        xlSheet.Cells[2, 3].FormulaR1C1:= 'License Level';
        xlSheet.Cells[2, 4].FormulaR1C1:= 'Event Date';
        xlSheet.Cells[2, 5].FormulaR1C1:= 'Computer Name';
        xlSheet.Cells[2, 6].FormulaR1C1:= 'Preparer Name';
        xlSheet.Cells[2, 7].FormulaR1C1:= 'Preparer Address';
        xlSheet.Cells[2, 8].FormulaR1C1:= 'Return Count';
        xlSheet.Cells[2, 9].FormulaR1C1:= 'FileName';
        xlSheet.Cells[2, 10].FormulaR1C1:= 'Efile Number';
        xlSheet.Cells[2, 11].FormulaR1C1:= 'Taxation Year';
        xlSheet.Cells[2, 12].FormulaR1C1:= 'Additional Info';
        nLastCol:= 12;
        xlSheet.Range[xlSheet.Cells[1, 1], xlSheet.Cells[1, nLastCol]].Merge;

        nLine:= 3;
        QData.First;

        while not QData.Eof do
        begin
          xlSheet.Cells[nLine, 1].FormulaR1C1:= QData.FieldByName('AppName').AsString;
          xlSheet.Cells[nLine, 2].FormulaR1C1:= QData.FieldByName('AppKey').AsString;
          xlSheet.Cells[nLine, 3].FormulaR1C1:= QData.FieldByName('LicenseLevel').AsString;
          xlSheet.Cells[nLine, 4].FormulaR1C1:= QData.FieldByName('EventDate').AsString;
          xlSheet.Cells[nLine, 5].FormulaR1C1:= QData.FieldByName('ComputerName').AsString;
          xlSheet.Cells[nLine, 6].FormulaR1C1:= QData.FieldByName('PreparerName').AsString;
          xlSheet.Cells[nLine, 7].FormulaR1C1:= QData.FieldByName('PreparerAddress').AsString;
          xlSheet.Cells[nLine, 8].FormulaR1C1:= QData.FieldByName('ReturnCount').AsString;
          xlSheet.Cells[nLine, 9].FormulaR1C1:= QData.FieldByName('FileName').AsString;
          xlSheet.Cells[nLine, 10].FormulaR1C1:= QData.FieldByName('EfileNumber').AsString;
          xlSheet.Cells[nLine, 11].FormulaR1C1:= QData.FieldByName('TaxationYear').AsString;
          xlSheet.Cells[nLine, 12].FormulaR1C1:= QData.FieldByName('AdditionalInfo').AsString;

          xlRange:= xlSheet.Range[xlSheet.Cells[nLine, 1], xlSheet.Cells[nLine, nLastCol]];
          SetBorders(xlRange, 2, 1);
          inc(nLine);

          QData.Next;
        end;
      end else
      //Short
      if rbExportGroup.ItemIndex = 1 then
      begin
        xlSheet.Cells[1, 1].FormulaR1C1:= 'Short list of offenders report';
        xlSheet.Cells[1, 1].Font.Bold:= true;
        xlSheet.Cells[1, 1].Font.Size:= 14;

        xlSheet.Cells[2, 1].FormulaR1C1:= 'App Name';
        xlSheet.Cells[2, 2].FormulaR1C1:= 'App Key';
        xlSheet.Cells[2, 3].FormulaR1C1:= 'Computer Name';
        xlSheet.Cells[2, 4].FormulaR1C1:= 'Preparer Name';
        xlSheet.Cells[2, 5].FormulaR1C1:= 'Preparer Address';
        xlSheet.Cells[2, 6].FormulaR1C1:= 'Efile Number';
        nLastCol:= 6;
        xlSheet.Range[xlSheet.Cells[1, 1], xlSheet.Cells[1, nLastCol]].Merge;

        nLine:= 3;
        qShortData.First;

        while not qShortData.Eof do
        begin
          xlSheet.Cells[nLine, 1].FormulaR1C1:= qShortData.FieldByName('AppName').AsString;
          xlSheet.Cells[nLine, 2].FormulaR1C1:= qShortData.FieldByName('AppKey').AsString;
          xlSheet.Cells[nLine, 3].FormulaR1C1:= qShortData.FieldByName('ComputerName').AsString;
          xlSheet.Cells[nLine, 4].FormulaR1C1:= qShortData.FieldByName('PreparerName').AsString;
          xlSheet.Cells[nLine, 5].FormulaR1C1:= qShortData.FieldByName('PreparerAddress').AsString;
          xlSheet.Cells[nLine, 6].FormulaR1C1:= qShortData.FieldByName('EfileNumber').AsString;

          xlRange:= xlSheet.Range[xlSheet.Cells[nLine, 1], xlSheet.Cells[nLine, nLastCol]];
          SetBorders(xlRange, 2, 1);
          inc(nLine);

          qShortData.Next;
        end;
      end;

      xlRange:= xlSheet.Range[xlSheet.Cells[2, 1], xlSheet.Cells[2, nLastCol]];
      SetBorders(xlRange, -4138, 1); //thick borders

      xlRange.EntireColumn.AutoFit;
      xlRange.EntireRow.AutoFit;

      ForceDirectories(ExtractFilePath(cFile));
      xlApp.ActiveWorkbook.SaveAs(cFile);
      xlApp.ActiveWindow.Close;
    finally
      if not VarIsEmpty(XLApp) then
      begin
        xlApp.Application.ScreenUpdating:= true;
        xlApp.DisplayAlerts:= true;
        xlApp.Quit;
        xlApp:= Unassigned;
        xlSheet:= Unassigned;
      end;
    end;
  finally
    FreeAndNil(qTemp);
  end;

  ShellExecute(Application.Handle, 'open', PChar(cFile), nil, nil, SW_SHOWNORMAL);
end;

end.
