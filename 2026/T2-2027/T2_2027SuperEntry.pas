unit T2_2027superentry;
//revision 2014-07-29

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,ExtCtrls,
  StdCtrls,Buttons,FileCtrl,T2_2027ChildWinNew,T2_2027Declare,T2_2027TrimStr;

type
  TSuperEntryT2_2027 = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    MemorizeGroup: TGroupBox;
    CharityBox: TCheckBox;
    CorpNmBox: TCheckBox;
    ActionGroup: TGroupBox;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ExperienceBox: TRadioGroup;
    GroupBox1: TGroupBox;
    FileListBox1: TFileListBox;
    CorpBnBox: TCheckBox;
    GroupBox2: TGroupBox;
    CharityBtn: TBitBtn;
    CoppBNBtn: TBitBtn;
    CorpNamesBtn: TBitBtn;
    CitiesBox: TCheckBox;
    CitiesBtn: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ExperienceBoxClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure CharityBtnClick(Sender: TObject);
    procedure CorpNamesBtnClick(Sender: TObject);
    procedure IndivNmBtnClick(Sender: TObject);
    procedure CitiesBtnClick(Sender: TObject);
    procedure CoppBNBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SuperEntry: TSuperEntryT2_2027;

implementation

{$R *.DFM}

uses T2_2027,vtCommon,vtTrimStr,T2_2027Main,
  vtFileStorage, vtShared; //20160820 Igor

procedure TSuperEntryT2_2027.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TSuperEntryT2_2027.FormCreate(Sender: TObject);
begin
 If OptRec.Dir_LastYr>'' then
  FileListBox1.Directory:=OptRec.Dir_LastYr
 Else
  FileListBox1.Clear;
end;

procedure TSuperEntryT2_2027.ExperienceBoxClick(Sender: TObject);
begin
  If ExperienceBox.ItemIndex=0 then
   FileListBox1.Directory:=OptRec.Dir_LastYr
  Else
   FileListBox1.Directory:=OptRec.Dir_Cur;
end;

procedure TSuperEntryT2_2027.OKBtnClick(Sender: TObject);
Var
  i, j: Integer;
  //DataList,ElmList,TempList: TStringList;
  FullFlName, Dir, S: String;
  SQLite: TSQLiteStorage;
  f: TFileStorage;
  Var1, Var2, Var3, Var4: String;
begin

  If GetCurrentRetNo>0 then
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

  FileListBox1.ItemIndex:=0;
  For i:= 0 to FileListBox1.Items.Count-1 do
  Begin
    FileListBox1.ItemIndex := i;
    FullFlName:=Dir+'\'+FileListBox1.Items[i];
//    If FileExists(FullFlName) then
//      DataList.LoadFromFile(FullFlName)
//    else
//      DataList.Clear;
    if CheckReturnPsw(ExtractFileDir(FullFlName), ExtractFileName(FullFlName)) <> iorReported then
      exit;
    SQLite := TSQLiteStorage.Create(ExtractFileDir(FullFlName), ExtractFileName(FullFlName), fsRead, AppT2.SQLLitePassword.PassRFArray);
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
      If CharityBox.Checked then
      begin
        BuildExperience('S2', 404, 470, 3, IncludeTrailingPathDelimiter(AppDir)+'Charity.Txt', SQLite, f);
        BuildExperience('S2', 474, 486, 3, IncludeTrailingPathDelimiter(AppDir)+'Charity.Txt', SQLite, f);
        BuildExperience('S2', 490, 502, 3, IncludeTrailingPathDelimiter(AppDir)+'Charity.Txt', SQLite, f);
        BuildExperience('S2', 506, 518, 3, IncludeTrailingPathDelimiter(AppDir)+'Charity.Txt', SQLite, f);
      end;


      If CitiesBox.Checked then
      begin
        BuildExperience('T2', 16, 16, 1, IncludeTrailingPathDelimiter(AppDir)+'Cities.Txt', SQLite, f);
        BuildExperience('T2', 32, 32, 1, IncludeTrailingPathDelimiter(AppDir)+'Cities.Txt', SQLite, f);
        BuildExperience('T2', 44, 44, 1, IncludeTrailingPathDelimiter(AppDir)+'Cities.Txt', SQLite, f);

        BuildExperience('S14', 7, 115, 12, IncludeTrailingPathDelimiter(AppDir)+'Cities.Txt', SQLite, f);
        BuildExperience('S15', 9, 149, 10, IncludeTrailingPathDelimiter(AppDir)+'Cities.Txt', SQLite, f);
        BuildExperience('S22', 6, 55,  7,  IncludeTrailingPathDelimiter(AppDir)+'Cities.Txt', SQLite, f);
        BuildExperience('S29', 6, 55,  8,  IncludeTrailingPathDelimiter(AppDir)+'Cities.Txt', SQLite, f);
      end;

      If CorpNmBox.Checked then
      begin
        BuildExperience('T2',  3,   3,   1, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S3',  4,   85,  9, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S3',  210, 246, 4, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f); //pg2
        BuildExperience('S9',  4,   130, 9, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S23', 5,   119, 6, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S25', 4,   64,  3, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S28', 49,  49,  1, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S28', 4,   46,  3, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S39', 4,   92,  4, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S40', 4,   92,  4, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S41', 5,   73,  4, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S44', 4,   73,  3, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S45', 3,   3,   1, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S45', 6,   6,   1, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S49', 5,   119, 6, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
        BuildExperience('S50', 4,   124, 5, IncludeTrailingPathDelimiter(AppDir)+'CorpNm.Txt', SQLite, f);
      end; //corpnm

      If CorpBNBox.Checked then
      begin
        BuildExperience('T2',  1,   1,   1, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S3',  6,   87,  9, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S3',  211, 247, 4, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f); //pg2
        BuildExperience('S9',  6,   132, 9, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S23', 6,   120, 6, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S28', 50,  50,  1, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S28', 5,   47,  3, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S39', 5,   93,  4, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S40', 5,   93,  4, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S41', 6,   74,  4, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S44', 5,   74,  3, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S45', 4,   4,   1, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S45', 7,   7,   1, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S49', 6,   120, 6, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
        BuildExperience('S50', 5,   125, 5, IncludeTrailingPathDelimiter(AppDir)+'CorpBN.Txt', SQLite, f);
      end; //corpBN
    finally
      if assigned(f) then
        FreeAndNil(f);
      if assigned(SQLite) then
        FreeAndNil(SQLite);
    end;
//      DataList.Clear;
  end; //i
  FileListBox1.ItemIndex :=0;
  ShowMessage('Done');
//  DataList.Free;
//  TempList.Free;
//  ElmList.Free;
end;

procedure TSuperEntryT2_2027.CharityBtnClick(Sender: TObject);
begin
 MainFormT2.CharityOrganizations1Click(Sender);
end;

procedure TSuperEntryT2_2027.CorpNamesBtnClick(Sender: TObject);
begin
  MainFormT2.CorporationNames1Click(Sender);
end;

procedure TSuperEntryT2_2027.IndivNmBtnClick(Sender: TObject);
begin
 MainFormT2.Individualsnames1Click(Sender);
end;

procedure TSuperEntryT2_2027.CitiesBtnClick(Sender: TObject);
begin
MainFormT2.Cities1Click(Sender);
end;

procedure TSuperEntryT2_2027.CoppBNBtnClick(Sender: TObject);
begin
 MainFormT2.BusinessNumbers1Click(Sender);
end;

end.
