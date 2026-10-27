unit T2_2027DirOpt;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, DB, Buttons, Grids, Outline, DirOutln,
  FileCtrl, ExtCtrls, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;

type
  TDirOptT2_2027 = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Prior1Lbl: TLabel;
    Label6: TLabel;
    CurDir: TDBEdit;
    DefaultDir: TDBEdit;
    LastYrDir: TDBEdit;
    SampleDir: TDBEdit;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DataSource1: TDataSource;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label4: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label7: TLabel;
    Label19: TLabel;
    Prior2Lbl: TLabel;
    PrvLYr: TDBEdit;
    Label22: TLabel;
    BitBtn1: TBitBtn;
    Label5: TLabel;
    Bevel1: TBevel;
    Label24: TLabel;
    Panel2: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    SelectCurBtn: TBitBtn;
    SelectDefBtn: TBitBtn;
    SelectL1Btn: TBitBtn;
    SelectL2btn: TBitBtn;
    SelectLast3Btn: TBitBtn;
    Label21: TLabel;
    Prior3Lbl: TLabel;
    SelectL3Btn: TBitBtn;
    Prior4Lbl: TLabel;
    SelectL4Btn: TBitBtn;
    L3Yr: TEdit;
    L4Yr: TEdit;
    Label3: TLabel;
    CurDirLbl: TLabel;
    Label18: TLabel;
    FDConnection: TADConnection;
    Table1: TADTable;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function EditDirectory(DirName: string): boolean;
    procedure SaveBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SelectCurBtnClick(Sender: TObject);
    procedure SelectDefBtnClick(Sender: TObject);
    procedure SelectL1BtnClick(Sender: TObject);
    procedure SelectL2btnClick(Sender: TObject);
    procedure SelectLast3BtnClick(Sender: TObject);
    procedure SelectL3BtnClick(Sender: TObject);
    procedure SelectL4BtnClick(Sender: TObject);
    { procedure FormKeyPress(Sender: TObject; var Key: Char);}
    { Function CopyClientTable(DestinationDirectory: string): LongInt;}
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
  HelpTopic = 'Data_directories';
var
  DirOpt: TDirOptT2_2027;

implementation
{$R *.DFM}

uses
  vtDialogs, vtCommon,
  //T2_2027SelectDir,
  T2_2027Main, vtMain, T2_2027Declare,
  T2_2027common, T2_2027TrimStr, T2_2027Features,
  vtTrimStr, vtShared, vtDataBase;

procedure TDirOptT2_2027.SaveBtnClick(Sender: TObject);
//20170811 Igor>>>
var
  TempList: TStringList;
  Err: String;
begin
  try
    if IsDataDirectoryGood(CurDir.EditText) = False then
      exit;
    if IsDataDirectoryGood(DefaultDir.EditText) = False then
      exit;
    if EditDirectory(CurDir.EditText) and
       EditDirectory(DefaultDir.EditText) and
       EditDirectory(LastYrDir.EditText) then
    begin
      {initialize data bases}
      if not FileExists(CurDir.EditText + '\' + ClientsDBLite) then //20150922 Igor
        if not InitDataBase(AppDir, CurDir.EditText, Err) then
          ShowMessage(Err);
      if not FileExists(DefaultDir.EditText + '\' + ClientsDBLite) then    //20150922 Igor
        if not InitDataBase(AppDir, DefaultDir.EditText, Err) then
          ShowMessage(Err);
      Table1.Edit;
      Table1.Post;
      InitOptions; {this puts record in memory}
      //Save dirs
      TempList := TStringList.Create;
      try
        TempList.Add(CurDir.Text);
        TempList.Add(LastYrDir.Text);
        TempList.Add(PrvLYr.Text);
        TempList.Add(L3Yr.Text);
        TempList.Add(L4Yr.Text);
        TempList.SaveToFile(AppDir + '/' + 'DIRS.d');
      finally
        TempList.Free;
      end;
      MainFormT2.ShowMostRecentReturns;
      ShowTimedMsg('Saved', 900);
    end;
  except
  end;
//20170811 Igor<<<
end;

function TDirOptT2_2027.EditDirectory(DirName: string): boolean;
var
  s: string;
begin
  Result := True;
  if UpperCase(DirName) = UpperCase(AppDir) then
  begin
    ShowMessage('You cannot use the Program Directory ' +
      DirName + Chr(13) + 'as Data Directory');
    result := False;
    exit;
  end;

  s := GetAnyPathMoreThan8Chars(DirName);
  {
  If s>'' then
  begin
   ShowMessage('If you plan to EFile from this directory: '+DirName+
   Chr(13)+'the sub-path name '+ Chr(39)+S+Chr(39) +' must be reduced to 8 characters max')
  end;
  }
  if SysUtils.DirectoryExists(DirName) then
    exit; //20150701
  if DirName = '' then
    exit; {no directory}

  {Does Not exist}
  if MessageDlg('Directory: ' + DirName +
    ' does not exist. Create?',
    mtInformation, [mbYes, mbNo], 0) = mrYes then
  begin {replied mrYes to create}
{$I-} {so that the ioresult can be effective}
    SysUtils.ForceDirectories(DirName); {MkDir(DirName);} //20150701
    if IOResult = 0 then
    begin
      MessageDlg('Directory: ' + DirName + ' created', mtInformation, [mbOk], 0);
      exit;
    end
    else
    begin
      MessageDlg('Directory: ' + DirName +
        chr(13) + ' cannot be created', mtInformation, [mbOk], 0);
      Result := False;
      exit;
    end;
  end
  else {replied mrNo}
  begin result := False;
    exit;
  end;
end;

procedure TDirOptT2_2027.CancelBtnClick(Sender: TObject);
begin
  try
    Table1.Close;
  except
  end; {try}
  Close;
end;

procedure TDirOptT2_2027.FormCreate(Sender: TObject);
var
  TempList: TStringList;
begin
  //Load dirs
  if FileExists(AppDir + '\' + 'Dirs.d') then
  begin
    TempList := TStringList.Create;
    TempList.LoadFromFile(AppDir + '/' + 'DIRS.d');
    CurDir.Text := TempList[0];
    LastYrDir.Text := TempList[1];
    // PrvLYr.Text:=TempList[2];
    // L3Yr.Text:=TempList[3];
    // L4Yr.Text:=TempList[4];
    TempList.Free;
  end;

  CurDirLbl.Caption := IntToStr(StrToInt(AppYear));
  Prior1Lbl.Caption := IntToStr(StrToInt(AppYear) - 1);
  Prior2Lbl.Caption := IntToStr(StrToInt(AppYear) - 2);
  Prior3Lbl.Caption := IntToStr(StrToInt(AppYear) - 3);
  Prior4Lbl.Caption := IntToStr(StrToInt(AppYear) - 4);

  //20150922 IGOR
  if not SetTableName(FDConnection, Table1, AppDir + '\' + FormsCfgT1DBLite, FormsCfgT1TableLite, '')
  then exit;

  {if Table1.State = dsInactive then
  begin
    try
      Table1.Open;
    except
      on EDataBaseError do
        ShowMessage(Table1.TableName + ' can not be opened');
    end;
  end;}
  Table1.Edit;
end;

procedure TDirOptT2_2027.BitBtn1Click(Sender: TObject);
begin
  ShowHelp('T2Help', HelpTopic);
end;

procedure TDirOptT2_2027.SelectCurBtnClick(Sender: TObject);
begin
  SelectedDir := SelectDir;
  //ExecuteForm(TSelectDirT2_2027);
  if SelectedDir > '' then
  begin
    CurDir.Text := SelectedDir;
    Table1.Edit;
    Table1.Post;
  end;
end;

procedure TDirOptT2_2027.SelectDefBtnClick(Sender: TObject);
begin
  SelectedDir := SelectDir;
  //ExecuteForm(TSelectDirT2_2027);
  if SelectedDir > '' then
  begin
    DefaultDir.Text := SelectedDir;
    Table1.Edit;
    Table1.Post;
  end;
end;

procedure TDirOptT2_2027.SelectL1BtnClick(Sender: TObject);
begin
  SelectedDir := SelectDir;
  //ExecuteForm(TSelectDirT2_2027);
  if SelectedDir > '' then
  begin
    LastYrDir.EditText := SelectedDir;
    Table1.Edit;
    Table1.Post;
  end;
  //If SelectedDir >'' then LastYrDir.Text := SelectedDir;
end;

procedure TDirOptT2_2027.SelectL2btnClick(Sender: TObject);
begin
  SelectedDir := SelectDir;
  //ExecuteForm(TSelectDirT2_2027);
  if SelectedDir > '' then
  begin
    Table1.Edit;
    PrvLYr.Edittext := SelectedDir;
    Table1.Post;
  end;

  // If SelectedDir >'' then PrvLYr.Text := SelectedDir;
end;

procedure TDirOptT2_2027.SelectLast3BtnClick(Sender: TObject);
begin
  SelectedDir := SelectDir;
  //ExecuteForm(TSelectDirT2_2027);
  if SelectedDir > '' then
    SampleDir.Text := SelectedDir;
end;

procedure TDirOptT2_2027.SelectL3BtnClick(Sender: TObject);
begin
  SelectedDir := SelectDir;
  //ExecuteForm(TSelectDirT2_2027);
  if SelectedDir > '' then
    L3Yr.text := SelectedDir;
end;

procedure TDirOptT2_2027.SelectL4BtnClick(Sender: TObject);
begin
  SelectedDir := SelectDir;
  //ExecuteForm(TSelectDirT2_2027);
  if SelectedDir > '' then
  begin
    L4Yr.text := SelectedDir;
  end;
end;

end.

