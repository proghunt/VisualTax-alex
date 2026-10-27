unit T1_2026diropt;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Mask,DBCtrls,DB,Buttons,Grids,Outline,DirOutln,
  FileCtrl,ExtCtrls, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;

type
  TDirOptT1_2026 = class(TForm)
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
    Function EditDirectory(DirName: string): boolean;
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
Const HelpTopic = 'Data_directories';
var
  DirOpt: TDirOptT1_2026;

implementation

{$R *.DFM}

uses vtDialogs,T1_2026Declare,T1_2026common,T1_2026TrimStr,T1_2026Features,
  T1_2026Main, vtTrimStr, vtShared, vtDataBase;

Procedure TDirOptT1_2026.SaveBtnClick(Sender: TObject);
//20170811 Igor>>>
Var
  TempList: TStringList;
  Err: String;
begin
  try
    if not IsDataDirectoryGood(CurDir.EditText) then
      exit;
    if not IsDataDirectoryGood(DefaultDir.EditText) then
      exit;
    if SysUtils.DirectoryExists(CurDir.EditText) and
       not SysUtils.FileExists(IncludeTrailingPathDelimiter(CurDir.EditText) + ClientsDbLite) then
      if not InitDataBase(CurDir.EditText, Err) then//20171031 igor
        MessageDlg(Err, mtError, [mbOk], 0);
    if EditDirectory(CurDir.EditText) and EditDirectory(DefaultDir.EditText) and EditDirectory(LastYrDir.EditText) then
    begin
      {initialize data bases}
      if not SysUtils.FileExists(IncludeTrailingPathDelimiter(CurDir.EditText) + ClientsDbLite) then
        if not InitDataBase(CurDir.EditText, Err) then//20171031 igor
          ShowMessage(Err);
      if not SysUtils.FileExists(IncludeTrailingPathDelimiter(DefaultDir.EditText) + ClientsDbLite) then
        if not InitDataBase(DefaultDir.EditText, Err) then//20171031 igor
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
      MainFormT1.ShowMostRecentReturns;
      ShowTimedMsg('Saved', 900);
    end;
  except
  end;
//20170811 Igor<<<
end;

Function TDirOptT1_2026.EditDirectory(DirName: string): boolean;
//20170811 Igor>>>
//Var
//  s: String;
begin
  If UpperCase(DirName) = UpperCase(AppDir) then
  begin
    ShowMessage('You cannot use the Program Directory ' + DirName + Chr(13)+
                'as Data Directory');
    Exit(False);
  end;
  {
  s := GetAnyPathMoreThan8Chars(DirName);
   If s>'' then
   begin
    ShowMessage('If you plan to EFile from this directory: '+DirName+
    Chr(13)+'the sub-path name '+ Chr(39)+S+Chr(39) +' must be reduced to 8 characters max')
   end;
  }
  If DirName = '' then
    exit(True); {no directory}
  if SysUtils.DirectoryExists(DirName) then
    exit(true);

  {Does Not exist}
  if MessageDlg('Directory: '+ DirName + ' does not exist. Create?',
       mtInformation, [mbYes, mbNo], 0) = mrYes then
  begin {replied mrYes to create}
    if SysUtils.ForceDirectories(DirName) then
    begin
      MessageDlg('Directory: '+ DirName + ' created', mtInformation, [mbOk], 0);
      exit(True);
    end
    else
    begin
      MessageDlg('Directory: '+ DirName + chr(13)+
                 ' cannot be created', mtInformation, [mbOk], 0);
      Exit(False);
    end;
  end
  else  {replied mrNo}
    Exit(True);
//20170811 Igor<<<
end;

procedure TDirOptT1_2026.CancelBtnClick(Sender: TObject);
begin
 Try
  Table1.Close;
 except
 end; {try}
 Close;
end;

procedure TDirOptT1_2026.FormCreate(Sender: TObject);
Var TempList:TStringList;
begin
   //Load dirs
   If FileExists(AppDir+'\'+'Dirs.d') then
   begin
    TempList:=TStringList.Create;
    TempList.LoadFromFile(AppDir+'/'+'DIRS.d');
    CurDir.Text:=TempList[0];
    LastYrDir.Text:=TempList[1];
   // PrvLYr.Text:=TempList[2];
   // L3Yr.Text:=TempList[3];
   // L4Yr.Text:=TempList[4];
    TempList.Free;
   end;

   CurDirLbl.Caption := IntToStr(StrToInt(AppYear));
   Prior1Lbl.Caption := IntToStr(StrToInt(AppYear)-1);
   Prior2Lbl.Caption := IntToStr(StrToInt(AppYear)-2);
   Prior3Lbl.Caption := IntToStr(StrToInt(AppYear)-3);
   Prior4Lbl.Caption := IntToStr(StrToInt(AppYear)-4);

  if Table1.State = dsInactive then
  begin
  //20150916 IGOR
  if not SetTableName(FDConnection, Table1, AppDir + '\' + FormsCfgDBLite, FormsCfgTableLite, '')
  then exit;

   {try
     Table1.Open;
   Except
     on EDataBaseError do
        ShowMessage(Table1.TableName + ' can not be opened');
     end;}
  end;
 Table1.Edit;
end;

procedure TDirOptT1_2026.BitBtn1Click(Sender: TObject);
begin
ShowHelp('T1Help',HelpTopic);
end;

procedure TDirOptT1_2026.SelectCurBtnClick(Sender: TObject);
var
  SelectedDir: string;
begin
  SelectedDir := SelectDir;
 If SelectedDir >'' then
 begin
  CurDir.Text := SelectedDir;
  Table1.Edit;
  Table1.Post;
 end;
end;

procedure TDirOptT1_2026.SelectDefBtnClick(Sender: TObject);
var
  SelectedDir: string;
begin
  SelectedDir := SelectDir;
 If SelectedDir >'' then
 begin
  DefaultDir.Text := SelectedDir;
  Table1.Edit;
  Table1.Post;
 end;
end;

procedure TDirOptT1_2026.SelectL1BtnClick(Sender: TObject);
var
  SelectedDir: string;
begin
  SelectedDir := SelectDir;
 If SelectedDir >'' then
 begin
  LastYrDir.EditText := SelectedDir;
  Table1.Edit;
  Table1.Post;
 end;
 //If SelectedDir >'' then LastYrDir.Text := SelectedDir;
end;

procedure TDirOptT1_2026.SelectL2btnClick(Sender: TObject);
var
  SelectedDir: string;
begin
  SelectedDir := SelectDir;
 If SelectedDir >'' then
 begin
  Table1.Edit;
  PrvLYr.Edittext := SelectedDir;
  Table1.Post;
 end;

// If SelectedDir >'' then PrvLYr.Text := SelectedDir;
end;

procedure TDirOptT1_2026.SelectLast3BtnClick(Sender: TObject);
var
  SelectedDir: string;
begin
  SelectedDir := SelectDir;
 If SelectedDir >'' then SampleDir.Text := SelectedDir;
end;

procedure TDirOptT1_2026.SelectL3BtnClick(Sender: TObject);
var
  SelectedDir: string;
begin
  SelectedDir := SelectDir;
 If SelectedDir >'' then L3Yr.text := SelectedDir;
end;

procedure TDirOptT1_2026.SelectL4BtnClick(Sender: TObject);
var
  SelectedDir: string;
begin
  SelectedDir := SelectDir;
 If SelectedDir >'' then
 begin
  L4Yr.text := SelectedDir;
 end;

end;

end.
