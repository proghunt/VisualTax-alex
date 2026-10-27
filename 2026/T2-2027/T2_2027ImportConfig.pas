unit T2_2027ImportConfig;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, FileCtrl, T2_2027Declare, T2_2027Trimstr, Buttons,
  T2_2027Common;

type
  TImportConfigT2_2027 = class(TForm)
    Panel2: TPanel;
    Label4: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox4: TCheckBox;
    GroupBox2: TGroupBox;
    ImportFromBox: TRadioGroup;
    Label1: TLabel;
    LastYrPgmDirBox: TEdit;
    Label5: TLabel;
    LastConfigDirBox: TEdit;
    ListBox1: TListBox;
    GroupBox3: TGroupBox;
    OkBtn: TBitBtn;
    ExitBtn: TBitBtn;
    Label6: TLabel;
    CheckAllBtn: TBitBtn;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    procedure ImportFees(FromDir: string; FlName: string);
    function ImportFeeSchedule(ToDir, FeesFile: string): Boolean;
    function ExportFeeSchedule(FromDir, FeesFile: string): Boolean;
    procedure ImportCfg(FromDir: string);
    procedure ImportOthOpt(FromDir: string);
    procedure ImportPrintTemplates(FromDir: string);
    procedure ImportSuperEntry(FromDir: string);
    // procedure ImportCompanyLogo(FromDir:String);
    procedure ImportClientLetters(FromDir: string);
    procedure ImportDataDictionary(FromDir: string);
    procedure CheckAllBtnClick(Sender: TObject);
    //procedure FormPaint(Sender: TObject);
    procedure ImportFromBoxExit(Sender: TObject);
    procedure ImportPrintSeq(FromDir: string; FlName: string);
  private
    { Private declarations }
  public

  end;

var
  ImportConfig: TImportConfigT2_2027;

implementation

{$R *.DFM}

uses vtMulti, vtTrimStr, vtShared
   , vtDataBase, uADCompClient; // 20150920 Igor

procedure TImportConfigT2_2027.FormCreate(Sender: TObject);
var
  LastYr: Integer;
begin
  LastYr := StrToInt(AppYear) - 1;
  if LastYrPgmDirBox.Text = '' then
    LastYrPgmDirBox.Text := 'C:\T2-' + AllTrim(IntToStr(LastYr));

  if LastConfigDirBox.Text = '' then
    LastConfigDirBox.Text := 'C:\T2-' + AppYear + 'Config';
  ImportFromBox.ItemIndex := 1;
end;

procedure TImportConfigT2_2027.OkBtnClick(Sender: TObject);
var
  FromDir: string;
begin
  ListBox1.Items.Clear;
  if ImportFromBox.ItemIndex < 0 then
  begin
    ShowMessage('You must select a Import From option first');
    Exit;
  end;

  if ImportFromBox.Itemindex = 0 then
  begin
    if not SysUtils.DirectoryExists(LastYrPgmDirBox.Text) then //20150702
    begin
      ShowMessage('Directory ' + LastYrPgmDirBox.Text + ' does not exist');
      LastYrPgmDirBox.SetFocus;
      Exit;
    end;
  end;

  if ImportFromBox.Itemindex = 0 then
  begin
    if MessageDlg('Import from last year used normaly with a brand new installation' +
      Chr(13) + 'Are you sure you want to import from last year?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      exit;
  end;

  if ImportFromBox.Itemindex = 1 then
  begin
    if not SysUtils.DirectoryExists(LastConfigDirBox.Text) then //20150702
    begin
      ShowMessage('Directory ' + LastConfigDirBox.Text + ' does not exist');
      LastConfigDirBox.SetFocus;
      Exit;
    end;
  end;

  if ImportFromBox.Itemindex = 0 then
    FromDir := LastYrPgmDirBox.Text
  else
    FromDir := LastConfigDirBox.Text;

  if CheckBox1.Checked then
    ImportCfg(FromDir);
  if CheckBox2.Checked then
    ImportOthOpt(FromDir);
  if CheckBox3.Checked then
    ImportPrintTemplates(FromDir);
  if CheckBox4.Checked then
    ImportPrintSeq(FromDir, 'PrintSeq.Txt');
  if CheckBox5.Checked then
    ImportFees(FromDir, 'Fees.Txt');
  if CheckBox6.Checked then
    ImportSuperEntry(FromDir);
  //If CheckBox7.Checked then ImportCompanyLogo(FromDir);
  if CheckBox7.Checked then
    ImportClientLetters(FromDir);
  if CheckBox8.Checked then
    ImportDataDictionary(FromDir);
  if ImportFromBox.ItemIndex = 0 then
    ShowMessage('You should review again the Options' + Chr(13) +
      'via the Configure | Options' + chr(13) +
      'after exiting this screen');
end;

(*
procedure TImportConfig.ImportCompanyLogo(FromDir:String);
begin
  If CopyFile(FromDir+'\'+'LogoInfo.Txt',AppDir+'\'+ 'LogoInfo.Txt') = True then
   ListBox1.Items.Add('Company Logo...Done')
  Else
   ListBox1.Items.Add('Company Logo...FAILED');
end;
*)

procedure TImportConfigT2_2027.ImportFees(FromDir: string; FlName: string);
var
  FeesFile, ToDir: string;
begin
  if ImportFromBox.ItemIndex = 1 then //last backup
  begin
    FeesFile := FromDir + '\' + FlName;
    ToDir := AppDir;
    if ImportFeeSchedule(ToDir, FeesFile) then
      ListBox1.Items.Add('Fee schedules....Done')
    else
      ListBox1.Items.Add('Fee schedules....FAILED');
    exit;
  end;

  if ImportFromBox.ItemIndex = 1 then //last yr
  begin
    FeesFile := AppDir + '\' + FlName;
    if ExportFeeSchedule(FromDir, FeesFile) then
    begin
      ToDir := AppDir;
      if ImportFeeSchedule(ToDir, FeesFile) then
        ListBox1.Items.Add('Fee schedules....Done');
    end
    else
      ListBox1.Items.Add('Fee schedules....FAILED');
  end; //last yr
end;

function TImportConfigT2_2027.ImportFeeSchedule(ToDir, FeesFile: string): Boolean;
var
    i: integer;
    Templist: TStringList;
    FrmNm, FrmFee, FrmAddFee: string;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
  Result := True;

  Table1 := nil;   // 20150702
  TempList := nil;
  try
    if not FileExists(FeesFile) then
    begin
      ListBox1.Items.Add('Fees schedule... FAILED');
      Exit;
    end;

    //20150920 Igor
    ADConnection:= TADConnection.Create(Application);
    Table1 := TADTable.Create(Application);
    SetTableName(ADConnection, Table1, ToDir + '\' + FormsDBLite, FormsTableLite, 'FormName');

    TempList := TstringList.Create;
    TempList.LoadFromFile(FeesFile);

    for i := 0 to TempList.Count - 1 do
    begin
      FrmNm := LeftStr(TempList[i], 8);
      FrmFee := MidStr(TempList[i], 9, 7);
      FrmAddFee := MidStr(TempList[i], 16, 7);
      if Table1.FindKey([FrmNm]) then
      begin
        Table1.Edit;
        Table1.FieldByName('Fee').AsString := Alltrim(FrmFee);
        Table1.FieldByName('FeeAddItem').AsString := AllTrim(FrmAddFee);
        Table1.Post;
      end
      else
        ListBox1.Items.Add('Form ' + FrmNm + ' not found on data base');
    end;
    TempList.Free;
    Table1.Close;
    Table1.Free;
    ADConnection.Free;
    InitFormsTable;
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbok], 0);
      Result := False;
      TempList.Free;
      Table1.Close;
      Table1.Free;
      ADConnection.Free;
    end;
  end; //try
end;

//needed fr=or import rom last yr. takes t2scr and creates fees.txt

function TImportConfigT2_2027.ExportFeeSchedule(FromDir, FeesFile: string): Boolean;
var
    TempList: TStringList;
    S1, S2, S3, S4, S: string;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
  Result := True;
  Table1 := nil;   // 20150702
  TempList := nil;
  try
    //first export last years fees from T2scr.d bf a TEMP file
    //20150920 Igor
    ADConnection:= TADConnection.Create(Application);
    Table1 := TADTable.Create(Application);
    SetTableName(ADConnection, Table1, FromDir + '\' + FormsDBLite, FormsTableLite, '');

    TempList := TstringList.Create;
    TempList.Sorted := True;
    Table1.First;
    while not Table1.EOF do
    begin
      if (Table1.FieldByName('Fee').AsString > '') or (Table1.FieldByName('FeeAddItem').AsString > '') then
      begin
        S1 := Table1.FieldByName('FormName').AsString;
        S2 := Table1.FieldByName('Fee').AsString;
        s3 := Table1.FieldByName('FeeAddItem').AsString;
        s4 := Table1.FieldByName('FormDescr').AsString;
        s := s1 + Space(PaddCount(s1, 8))
          + s2 + Space(PaddCount(s2, 7))
          + s3 + Space(PaddCount(s3, 7))
          + s4 + Space(PaddCount(s2, 30));
        TempList.Add(s);
      end;
      Table1.Next;
    end;

    TempList.SaveToFile(FeesFile);
    TempList.Free;
    Table1.Close;
    Table1.Free;
    ADConnection.Free;
  except on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbok], 0);
      Result := False;
      TempList.Free;
      Table1.Close;
      Table1.Free;
      ADConnection.Free;
    end;
  end; //try
end;

procedure TImportConfigT2_2027.ImportCfg(FromDir: string);
var TempList: TStringList;
    ADConnection: TADConnection;
    CfgTbl: TADTable;
begin

  if FileExists(FromDir + '\' + 'Options.Txt') then
  begin
    if CopyFile(FromDir + '\' + 'Options.Txt', AppDir + '\' + 'Options.Txt') = True then
    begin
      InitOptions;
      ListBox1.Items.Add('Preparer/Data directories...Done');
      //If ImportFromBox.ItemIndex =0 then ListBox1.Items.Add('  You should review/revise the Data Directories again');
    end
    else
      ListBox1.Items.Add('Preparer/Data directories...FAILED');
  end
  else //import the old cfg file
  begin
    if FileExists(FromDir + '\' + FormsCfgDBLite) then //20150923 Igor
    begin
      //20150922 Igor
      ADConnection:= TADConnection.Create(Application);
      CfgTbl := TADTable.Create(Application);
      SetTableName(ADConnection, CfgTbl, FromDir + '\' + FormsCfgDBLite, FormsCfgTableLite, '');

      ConvertCfgToOptionsFile(CfgTbl);
      CfgTbl.Close;
      CfgTbl.Free;
      ADConnection.Free;
      //Rename old files
      RenameFile(AppDir +'\' +FormsCfgDBLite, AppDir +'\'+ ReplaceStr(UpperCase(FormsCfgDBLite),'.DB','.OLD'));//20150923 Igor
      RenameFile(AppDir + '\' + 'OthOpt.d', AppDir + '\' + 'OthOpt.old');
      RenameFile(AppDir + '\' + 'InvFoot.d', AppDir + '\' + 'InvFoot.old');
      RenameFile(AppDir + '\' + 'UpdSch.Txt', AppDir + '\' + 'UpdSch.old');
      RenameFile(AppDir + '\' + 'EfMethod.d', AppDir + '\' + 'EfMethod.old');
      InitOptions;
      ListBox1.Items.Add('Preparer etc...Done');
    end
    else
      ListBox1.Items.Add('Preparer/Data directories...FAILED');
  end;
end;

procedure TImportConfigT2_2027.ImportDataDictionary(FromDir: string);
//20170811 Igor>>>
var
  s, f: string;
  i: Integer;
  Dt: TDateTime;
begin
  if ImportFromBox.ItemIndex = 0 then
  begin
    ListBox1.Items.Add('Data Dictionary, not allowed to import from previous year');
    Exit;
  end;
  f := IncludeTrailingPathDelimiter(FromDir) + DictDBLite; // 20150920 Igor
  if FileExists(f) then
  begin
    //i:=FileAge(f); //20150702
    //Dt:=FileDateToDateTime(i); //20150702
    if FileAge(f, Dt) then //20150702
    begin
      s := FormatDateTime('yyyy-mm-dd', Dt);
      if LeftStr(s, 10) < '2005-01-27' then
        exit;
    end;
  end;

  if CopyDB(DictDBLite, FromDir, AppDir, s) then // 20150920 Igor
    ListBox1.Items.Add('Data Dictionary...Done')
  else
  begin
    MessageDlg(S, mtError, [mbOk], 0);
    ListBox1.Items.Add('Data Dictionary...FAILED');
  end;
//20170811 Igor<<<
end;

procedure TImportConfigT2_2027.ImportOthOpt(FromDir: string);
var
  s: string;
  i: Integer;
  Dt: TDateTime;
begin
  //i:=FileAge(FromDir+'\'+'OthOpt.D'); //20150702
  //Dt:=FileDateToDateTime(i);          //20150702
  FileAge(FromDir + '\' + 'OthOpt.D', Dt); //20150702
  s := FormatDateTime('yyyy-mm-dd', Dt);
  if LeftStr(s, 10) < '2005-01-27' then
    exit;

  if CopyFile(FromDir + '\' + 'OthOpt.D', AppDir + '\' + 'OthOpt.D') = True then
    ListBox1.Items.Add('Other Options....Done')
  else
    ListBox1.Items.Add('Other Options....FAILED');
end;

procedure TImportConfigT2_2027.ImportPrintTemplates(FromDir: string);
begin
  ListBox1.Items.Add('PRINT TEMPLATES');

  if CopyFile(FromDir + '\' + 'RVCANSet.D', AppDir + '\' + 'RVCANSet.D') = True then
    ListBox1.Items.Add('  RVCANSet....Done')
  else
    ListBox1.Items.Add('  RVCANSet....FAILED');

  if CopyFile(FromDir + '\' + 'PrepSet.D', AppDir + '\' + 'PrepSet.D') = True then
    ListBox1.Items.Add('  PrepSet....Done')
  else
    ListBox1.Items.Add('  PrepSet....FAILED');

  if CopyFile(FromDir + '\' + 'ClintSet.D', AppDir + '\' + 'ClintSet.D') = True then
    ListBox1.Items.Add('  ClintSet....Done')
  else
    ListBox1.Items.Add('  ClintSet....FAILED');

  if CopyFile(FromDir + '\' + 'Oth1Set.D', AppDir + '\' + 'Oth1Set.D') = True then
    ListBox1.Items.Add('  Oth1Set....Done')
  else
    ListBox1.Items.Add('  Oth1Set....FAILED');

  if CopyFile(FromDir + '\' + 'Oth2Set.D', AppDir + '\' + 'Oth2Set.D') = True then
    ListBox1.Items.Add('  Oth2Set....Done')
  else
    ListBox1.Items.Add('  Oth2Set....FAILED');

  if CopyFile(FromDir + '\' + 'Oth3Set.D', AppDir + '\' + 'Oth3Set.D') = True then
    ListBox1.Items.Add('  Oth3Set....Done')
  else
    ListBox1.Items.Add('  Oth3Set....FAILED');

end;

procedure TImportConfigT2_2027.ImportClientLetters(FromDir: string);
begin
  ListBox1.Items.Add('CLIENT LETTERS');

  if CopyFile(FromDir + '\' + 'EfiledLetter.RTF', AppDir + '\' + 'EfiledLetter.RTF') = True then
    ListBox1.Items.Add('  EfiledLetter...Done')
  else
    ListBox1.Items.Add('  EfiledLetter...FAILED');

  if CopyFile(FromDir + '\' + 'PaperFiledLetter.RTF', AppDir + '\' + 'PaperFiledLetter.RTF') = True then
    ListBox1.Items.Add('  PaperFiledLetter...Done')
  else
    ListBox1.Items.Add('  PaperFiledLetter...FAILED');

  if CopyFile(FromDir + '\' + 'PIPEDALetter.RTF', AppDir + '\' + 'PIPEDALetter.RTF') = True then
    ListBox1.Items.Add('  PIPEDALetter...Done')
  else
    ListBox1.Items.Add('  PIPEDALetter....FAILED');

  if CopyFile(FromDir + '\' + 'EngagementLetter.RTF', AppDir + '\' + 'EngagementLetter.RTF') = True then
    ListBox1.Items.Add('  EngagementLetter...Done')
  else
    ListBox1.Items.Add('  EngagementLetter...FAILED');

end;

procedure TImportConfigT2_2027.ImportSuperEntry(FromDir: string);
begin
  ListBox1.Items.Add('SUPER ENTRY FILES');

  if FileExists(FromDir + '\' + 'Charity.txt') then
  begin
    if CopyFile(FromDir + '\' + 'Charity.Txt', AppDir + '\' + 'Charity.Txt') = True then
      ListBox1.Items.Add('  Charities....Done')
    else
      ListBox1.Items.Add('  Charities....FAILED');
  end
  else
  begin
    if CopyFile(FromDir + '\' + 'Charity.D', AppDir + '\' + 'Charity.Txt') = True then
      ListBox1.Items.Add('  Charities....Done')
    else
      ListBox1.Items.Add('  Charities....FAILED');
  end;

  if FileExists(FromDir + '\' + 'Cities.Txt') then
  begin
    if CopyFile(FromDir + '\' + 'Cities.Txt', AppDir + '\' + 'Cities.Txt') = True then
      ListBox1.Items.Add('  Cities....Done')
    else
      ListBox1.Items.Add('  Cities....FAILED');
  end
  else
  begin
    if CopyFile(FromDir + '\' + 'Cities.D', AppDir + '\' + 'Cities.Txt') = True then
      ListBox1.Items.Add('  Cities....Done')
    else
      ListBox1.Items.Add('  Cities....FAILED');
  end;

  if FileExists(FromDir + '\' + 'CorpBN.Txt') then
  begin
    if CopyFile(FromDir + '\' + 'CorpBN.Txt', AppDir + '\' + 'CorpBN.Txt') = True then
      ListBox1.Items.Add('  CorpBN....Done')
    else
      ListBox1.Items.Add('  CorpBN....FAILED');
  end
  else
  begin
    if CopyFile(FromDir + '\' + 'CorpBN.D', AppDir + '\' + 'CorpBN.Txt') = True then
      ListBox1.Items.Add('  CorpBN....Done')
    else
      ListBox1.Items.Add('  CorpBN....FAILED');
  end;

  if FileExists(FromDir + '\' + 'CorpNM.Txt') then
  begin
    if CopyFile(FromDir + '\' + 'CorpNM.Txt', AppDir + '\' + 'CorpNM.Txt') = True then
      ListBox1.Items.Add('  CorpNM....Done')
    else
      ListBox1.Items.Add('  CorpNM....FAILED');
  end
  else
  begin
    if CopyFile(FromDir + '\' + 'CorpBN.D', AppDir + '\' + 'CorpBN.Txt') = True then
      ListBox1.Items.Add('  CorpNM....Done')
    else
      ListBox1.Items.Add('  CorpNM....FAILED');
  end;

  (*
  If FileExists(FromDir+'\'+'Doctors.txt') then
  begin
   If CopyFile(FromDir+'\'+'Doctors.txt',AppDir+'\'+ 'Doctors.txt') = True then
    ListBox1.Items.Add('  Doctors....Done')
   Else
    ListBox1.Items.Add('  Doctors....FAILED');
  end
  else
  begin
  If CopyFile(FromDir+'\'+'Doctors.D',AppDir+'\'+ 'Doctors.txt') = True then
   ListBox1.Items.Add('  Doctors....Done')
  Else
   ListBox1.Items.Add('  Doctors....FAILED');
  end;

  If FileExists(FromDir+'\'+'MedExp.txt') then
  begin
   If CopyFile(FromDir+'\'+'MedExp.Txt',AppDir+'\'+ 'MedExp.Txt') = True then
    ListBox1.Items.Add('  Med. Expense types...Done')
   Else
    ListBox1.Items.Add('  Med. Expense types...FAILED');
  end
  else
  begin
  If CopyFile(FromDir+'\'+'MedExp.D',AppDir+'\'+ 'MedExp.txt') = True then
   ListBox1.Items.Add('  Med. Expense types...Done')
  Else
   ListBox1.Items.Add('  Med. Expense types...FAILED');
  end;

  If FileExists(FromDir+'\'+'FirstNm.txt') then
  begin
   If CopyFile(FromDir+'\'+'FirstNm.Txt',AppDir+'\'+ 'FirstNm.txt') = True then
    ListBox1.Items.Add('  First Names...Done')
   Else
    ListBox1.Items.Add('  First Names...FAILED');
  end
  else
  begin
  If CopyFile(FromDir+'\'+'FirstNm.D',AppDir+'\'+ 'FirstNm.Txt') = True then
   ListBox1.Items.Add('  First Names...Done')
  Else
   ListBox1.Items.Add('  First Names...FAILED');
  end;

  If FileExists(FromDir+'\'+'Employers.txt') then
  begin
   If CopyFile(FromDir+'\'+'Employers.Txt',AppDir+'\'+ 'Employers.Txt') = True then
    ListBox1.Items.Add('  Employers....Done')
   Else
    ListBox1.Items.Add('  Employers....FAILED');
  end
  else
  begin
   If CopyFile(FromDir+'\'+'Employers.D',AppDir+'\'+ 'Employers.Txt') = True then
    ListBox1.Items.Add('  Employers....Done')
   Else
    ListBox1.Items.Add('  Employers....FAILED');
  end;

  If FileExists(FromDir+'\'+'Banks.Txt') then
  begin
   If CopyFile(FromDir+'\'+'Banks.Txt',AppDir+'\'+ 'Banks.Txt') = True then
    ListBox1.Items.Add('  Banks....Done')
   Else
    ListBox1.Items.Add('  Banks....FAILED');
  end
  else
  begin
  If CopyFile(FromDir+'\'+'Banks.D',AppDir+'\'+ 'Banks.Txt') = True then
   ListBox1.Items.Add('  Banks....Done')
  Else
   ListBox1.Items.Add('  Banks....FAILED');
  end;
 *)
end;

procedure TImportConfigT2_2027.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TImportConfigT2_2027.CheckAllBtnClick(Sender: TObject);
begin
  CheckBox1.Checked := True;
  //CheckBox2.Checked := True;
  CheckBox3.Checked := True;
  CheckBox4.Checked := True;
  CheckBox5.Checked := True;
  CheckBox6.Checked := True;
  CheckBox7.Checked := True;
  CheckBox8.Checked := True;
  //If ImportFromBox.ItemIndex=0 then CheckBox9.Checked := False;
end;

procedure TImportConfigT2_2027.ImportFromBoxExit(Sender: TObject);
begin
  if ImportFromBox.ItemIndex = 0 then
  begin
    CheckBox8.Checked := False;
    CheckBox8.Enabled := False;
  end
  else
  begin
    CheckBox8.Enabled := True;
  end;
end;

procedure TImportConfigT2_2027.ImportPrintSeq(FromDir: string; FlName: string);
var i: Integer;
    ListNdx: integer;
    Templist: TStringList;
    S, S1, S2, FrmNm, Prns: string;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
  try
    //20150920 Igor
    ADConnection:= TADConnection.Create(Application);
    Table1 := TADTable.Create(Application);
    SetTableName(ADConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite, 'FormName');

    TempList := TstringList.Create;
    TempList.Sorted := True;
    if FileExists(FromDir + '\' + FlName) then
      TempList.LoadFromFile(FromDir + '\' + FlName);
    Table1.First;

    for i := 0 to TempList.Count - 1 do
    begin
      FrmNm := AllTrim(LeftStr(TempList[i], 15));
      PrnS := AllTrim(MidStr(TempList[i], 16, 5));
      if Table1.FindKey([FrmNm]) then
      begin
        Table1.Edit;
        Table1.FieldByName('PrnSeq').AsString := PrnS;
        Table1.Post;
      end;
    end;
    TempList.Free;
    Table1.Close;
    Table1.Free;
    ADConnection.Free;
    ListBox1.Items.Add('Print Sequence...Done');
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbok], 0);
  end; //try
end;

end.

