unit T1_2026SuperEntry;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,FileCtrl;

type
  TSuperEntryT1_2026 = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    MemorizeGroup: TGroupBox;
    BanksBox: TCheckBox;
    MedExpBox: TCheckBox;
    CharitiesBox: TCheckBox;
    DoctorsBox: TCheckBox;
    ActionGroup: TGroupBox;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ExperienceBox: TRadioGroup;
    GroupBox1: TGroupBox;
    FileListBox1: TFileListBox;
    EmployersBox: TCheckBox;
    GroupBox2: TGroupBox;
    MedExpBtn: TBitBtn;
    DoctorsBtn: TBitBtn;
    CharityBtn: TBitBtn;
    BanksBtn: TBitBtn;
    EmployersBtn: TBitBtn;
    FirstNmBox: TCheckBox;
    FirstNameBox: TBitBtn;
    CitiesBox: TCheckBox;
    CitiesBtn: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExperienceBoxClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure MedExpBtnClick(Sender: TObject);
    procedure DoctorsBtnClick(Sender: TObject);
    procedure CharityBtnClick(Sender: TObject);
    procedure BanksBtnClick(Sender: TObject);
    procedure EmployersBtnClick(Sender: TObject);
    procedure FirstNameBoxClick(Sender: TObject);
    procedure CitiesBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var  SuperEntryT1_2026: TSuperEntryT1_2026;

implementation

{$R *.DFM}

uses vtMulti,T1_2026,T1_2026Declare,T1_2026TrimStr,T1_2026Main,vtTrimStr,
  vtShared,
  vtFileStorage; //20160819 Igor

procedure TSuperEntryT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TSuperEntryT1_2026.FormCreate(Sender: TObject);
begin
 If OptRec.Dir_LastYr>'' then
  FileListBox1.Directory:=OptRec.Dir_LastYr
 Else
  FileListBox1.Clear;
 ExperienceBox.ItemIndex := 1;
end;

procedure TSuperEntryT1_2026.ExperienceBoxClick(Sender: TObject);
begin
  If ExperienceBox.ItemIndex=0 then
   FileListBox1.Directory:=OptRec.Dir_LastYr
  Else
   FileListBox1.Directory:=OptRec.Dir_Cur;
end;

procedure TSuperEntryT1_2026.OKBtnClick(Sender: TObject);
Var
  i,j: Integer;
//20160820 Igor >>>
//  DataList,ElmList,TempList: TStringList;
  FullFlName, Dir, S: String;
  SQLite: TSQLiteStorage;
  f: TFileStorage;
  Var1, Var2, Var3, Var4: String;

begin
  If RetInMem>0 then
  begin
    ShowMessage('Please close all returns first');
    exit;
  end;

  If (ExperienceBox.ItemIndex = 0) and
     (AllTrim(OptRec.Dir_LastYr) ='') then
  begin
    ShowMessage('Last year'+Chr(39)+'s directory has not been defined');
    Exit;
  end;

  If (ExperienceBox.ItemIndex = 1) and
     (AllTrim(OptRec.Dir_Cur) ='') then
  begin
    ShowMessage('Current year'+Chr(39)+'s directory has not been defined');
    Exit;
  end;

  If (ExperienceBox.ItemIndex = 0) then
    Dir:=OptRec.Dir_LastYr
  else
    Dir:=OptRec.Dir_Cur;

//  DataList:=TStringList.Create;
//  ElmList:= TStringList.Create;
//  TempList:=TStringList.Create;
//  FileListBox1.ItemIndex:=0;

  For i:= 0 to FileListBox1.Items.Count-1 do
  Begin
    FileListBox1.ItemIndex := i;
    FullFlName:=Dir+'\'+FileListBox1.Items[i];
    if CheckReturnPsw(ExtractFileDir(FullFlName), ExtractFileName(FullFlName), AppT1_2026.SQLLitePassword.PassRFArray) <> iorReported then
      exit;
    SQLite := TSQLiteStorage.Create(ExtractFileDir(FullFlName), ExtractFileName(FullFlName), fsRead, AppT1_2026.SQLLitePassword.PassRFArray);
    if SQLite.LastError <> '' then
    Begin
      FreeAndNil(SQLite);
      f := TFileStorage.Create(ExtractFileDir(FullFlName), ExtractFileName(FullFlName), fsRead);
    End;
    if assigned(SQLite) then
    Begin
      SQLite.StartRead; //20161206 Igor
      if not SQLite.ReadSettings('AppName', Var1) or
         (Var1 <> AppName) then
      begin
        freeAndNil(SQLite);
        Continue;
      end;
    End
    else
    if assigned(F) then
    begin
      F.ResetCursor;
      if not f.ReadLine(Var1, Var2, Var3, Var4)
         or (Var1 <> AppName) then
      begin
        FreeAndNil(F);
        Continue;
      end;
    end;
    try
//    If FileExists(FullFlName) then
//      DataList.LoadFromFile(FullFlName)
//    else
//      DataList.Clear;

      If MedExpBox.Checked then
        BuildExperience('MEDICAL', 8, 108, 5, IncludeTrailingPathDelimiter(AppDir)+'MedExp.txt', SQLite, f);
      If DoctorsBox.Checked then
        BuildExperience('MEDICAL', 7, 107, 5, IncludeTrailingPathDelimiter(AppDir)+'Doctors.txt', SQLite, f);
      If CharitiesBox.Checked then
      begin
        BuildExperience('DON',16, 82, 6, IncludeTrailingPathDelimiter(AppDir)+'Charity.txt', SQLite, f);
        BuildExperience('DON',3,  13, 5, IncludeTrailingPathDelimiter(AppDir)+'Charity.txt', SQLite, f);
        BuildExperience('DON',19, 85, 6, IncludeTrailingPathDelimiter(AppDir)+'Charity.txt', SQLite, f);
      end;

      If BanksBox.Checked then
      begin
        BuildExperience('T3MULT#1', 17, 21, 1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('T3MULT#2', 17, 21, 1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('T5#1',     1,  1,  1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('T5#2',     1,  1,  1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('T5#3',     1,  1,  1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('T5#4',     1,  1,  1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('T5#5',     1,  1,  1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('T4RIF#1',  1,  1,  1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('T4RIF#2',  1,  1,  1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('T4RSP#1',  1,  1,  1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('T4RSP#2',  1,  1,  1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('UNIOND',   2,  12, 2, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('RRSP',     9,  9,  1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('RRSP',     20, 36, 4, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('RRSP',     43, 63, 4, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
        BuildExperience('RRSP',     79, 79, 1, IncludeTrailingPathDelimiter(AppDir)+'Banks.txt', SQLite, f);
      end;

      If EmployersBox.Checked then
      begin
        BuildExperience('T4#1',  1,  1,  1, IncludeTrailingPathDelimiter(AppDir)+'Employers.txt', SQLite, f);
        BuildExperience('T4#2',  1,  1,  1, IncludeTrailingPathDelimiter(AppDir)+'Employers.txt', SQLite, f);
        BuildExperience('T4A#1', 15, 15, 1, IncludeTrailingPathDelimiter(AppDir)+'Employers.txt', SQLite, f);
        BuildExperience('T4A#2', 15, 15, 1, IncludeTrailingPathDelimiter(AppDir)+'Employers.txt', SQLite, f);
        BuildExperience('T4A#3', 15, 15, 1, IncludeTrailingPathDelimiter(AppDir)+'Employers.txt', SQLite, f);
      end;

      If FirstNmBox.Checked then
      begin
        BuildExperience('T1',     2, 2,  2,   IncludeTrailingPathDelimiter(AppDir)+'FirstNm.txt', SQLite, f);
        BuildExperience('DEPEND', 5, 20, 125, IncludeTrailingPathDelimiter(AppDir)+'FirstNm.txt', SQLite, f);
      end;

      If CitiesBox.Checked then
      begin
        BuildExperience('T1', 10, 10, 1, IncludeTrailingPathDelimiter(AppDir)+'Cities.txt', SQLite, f);
      end; //cities

    finally
      if assigned(f) then
        FreeAndNil(f);
      if assigned(SQLite) then
        FreeAndNil(SQLite);
    end;
//    DataList.Clear;
  end; //i
  FileListBox1.ItemIndex :=0;
  ShowMessage('Done');
//  DataList.Free;
//  TempList.Free;
//  ElmList.Free;
//20160820 Igor <<<
end;

procedure TSuperEntryT1_2026.MedExpBtnClick(Sender: TObject);
begin
  MainFormT1.MedicalExpenseDescriptions1Click(Sender);
end;

procedure TSuperEntryT1_2026.DoctorsBtnClick(Sender: TObject);
begin
  MainFormT1.DoctorsHospitalsPharmacies1Click(Sender);
end;

procedure TSuperEntryT1_2026.CharityBtnClick(Sender: TObject);
begin
 MainFormT1.CharityOrganizations1Click(Sender);
end;

procedure TSuperEntryT1_2026.BanksBtnClick(Sender: TObject);
begin
MainFormT1.FinancialInstitutions1Click(Sender);
end;

procedure TSuperEntryT1_2026.EmployersBtnClick(Sender: TObject);
begin
  MainFormT1.Employers1Click(Sender);
end;

procedure TSuperEntryT1_2026.FirstNameBoxClick(Sender: TObject);
begin
 MainFormT1.FirstNames1Click(Sender);
end;

procedure TSuperEntryT1_2026.CitiesBtnClick(Sender: TObject);
begin
MainFormT1.Cities1Click(Sender);
end;

end.

