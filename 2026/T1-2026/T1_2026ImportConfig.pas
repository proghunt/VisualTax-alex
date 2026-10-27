unit T1_2026importconfig;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,FileCtrl,Buttons;

type
  TImportConfigT1_2026 = class(TForm)
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
    BrowseFromBtn: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
   // procedure ImportFees(FromDir:String;FlName:String);
    procedure ImportFees(FromDir:String);
//    Function  ImportFeeSchedule(ToDir,FeesFile:String):Boolean;
//    Function  ExportFeeSchedule(FromDir,FeesFile:String):Boolean;
    procedure ImportCfg(FromDir:String);
    procedure ImportOthOpt(FromDir:String);
    procedure ImportPrintTemplates(FromDir:String);
    procedure ImportSuperEntry(FromDir:String);
    procedure ImportClientLetters(FromDir:String);
    procedure ImportDataDictionary(FromDir:String);
    procedure CheckAllBtnClick(Sender: TObject);
    procedure ImportFromBoxExit(Sender: TObject);
    Procedure ImportPrintSeq(FromDir:String;FlName:String);
    procedure BrowseFromBtnClick(Sender: TObject);
    Procedure CleanUpPrSet(FlName:String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImportConfig: TImportConfigT1_2026;

implementation

{$R *.DFM}

uses T1_2026Declare,T1_2026Trimstr,T1_2026Common
   , vtCommon, vtTrimStr, vtShared, vtDataBase
   , uADCompClient; // 20150916 igor

procedure TImportConfigT1_2026.FormCreate(Sender: TObject);
Var LastYr:Integer;
begin
 LastYr := StrToInt(AppYear)-1;
 //20190209
 If LastYrPgmDirBox.Text = '' then
 LastYrPgmDirBox.Text := 'C:\VT-'+AllTrim(IntToStr(LastYr))+'\T1-'+AllTrim(IntToStr(LastYr)); //'C:\T1-'+AllTrim(IntToStr(LastYr));

 If LastConfigDirBox.Text = '' then
   LastConfigDirBox.Text := 'C:\T1-'+AppYear+'Config';
 ImportFromBox.ItemIndex:=1;
end;

procedure TImportConfigT1_2026.OkBtnClick(Sender: TObject);
Var FromDir:String;
begin
 ListBox1.Items.Clear;
 If ImportFromBox.ItemIndex <0 then
 begin
  ShowMessage('You must select a Import From option first');
  Exit;
 end;

 If ImportFromBox.Itemindex =0 then
 begin
  If Not DirectoryExists(LastYrPgmDirBox.Text) then
  begin
    ShowMessage('Directory '+LastYrPgmDirBox.Text+ ' does not exist');
    LastYrPgmDirBox.SetFocus;
    Exit;
  end;
 end;

 If ImportFromBox.Itemindex =0 then
 begin
  if MessageDlg('Import from last year used normaly with a brand new installation'+
     Chr(13)+'Are you sure you want to import from last year?',
     mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
 end;

 If ImportFromBox.Itemindex =1 then
 begin
  If Not DirectoryExists(LastConfigDirBox.Text) then
  begin
    ShowMessage('Directory '+LastConfigDirBox.Text+ ' does not exist');
    LastConfigDirBox.SetFocus;
    Exit;
  end;
 end;

 If ImportFromBox.Itemindex =0 then
  FromDir:=LastYrPgmDirBox.Text
 else
  FromDir:=LastConfigDirBox.Text;

 If CheckBox1.Checked then ImportCfg(FromDir);
 If CheckBox2.Checked then ImportOthOpt(FromDir);
 If CheckBox3.Checked then ImportPrintTemplates(FromDir);
 If CheckBox4.Checked then ImportPrintSeq(FromDir,'PrintSeq.Txt');
 //If CheckBox5.Checked then ImportFees(FromDir,'Fees-'+AppYear+'.Txt');
 If CheckBox5.Checked then ImportFees(FromDir);
 If CheckBox6.Checked then ImportSuperEntry(FromDir);
 //If CheckBox7.Checked then ImportCompanyLogo(FromDir);
 If CheckBox7.Checked then ImportClientLetters(FromDir);
 If CheckBox8.Checked then ImportDataDictionary(FromDir);
 If ImportFromBox.ItemIndex=0 then
 //20190209
 ShowMessage('You should review again the Options'+Chr(13)+
  'via the Configure | Options'+chr(13)+
  'after exiting this screen'
  +chr(13)+'  '
  +chr(13)+'You MUST REVIEW/CHANGE the Data Directories to the proper ones this year');
end;


procedure TImportConfigT1_2026.ImportCfg(FromDir:String);
Var TempList:TStringList;
    ADConnection: TADConnection;
    CfgTbl: TADTable;
begin

 If FileExists(FromDir+'\'+'Options.Txt') then
 begin
   If CopyFile(FromDir+'\'+'Options.Txt',AppDir+'\'+ 'Options.Txt') = True then
   begin
    InitOptions;
    ListBox1.Items.Add('Preparer/Data directories...Done');
    //If ImportFromBox.ItemIndex =0 then ListBox1.Items.Add('  You should review/revise the Data Directories again');
   end
   Else
    ListBox1.Items.Add('Preparer/Data directories...FAILED');
 end
 Else //import the old cfg file
 begin
   If FileExists(FromDir+'\'+FormsCfgDBLite) then
   begin
        //20150916 Igor
        ADConnection:= TADConnection.Create(Application);
        CfgTbl:= TADTable.Create(Application);
        SetTableName(ADConnection, CfgTbl, FromDir + '\' + FormsCfgDBLite, FormsCfgTableLite, '');

    ConvertCfgToOptionsFile(CfgTbl);
    CfgTbl.Close;
    CfgTbl.Free;
    ADConnection.Free;
     //Rename old files
    RenameFile(AppDir+'\'+FormsCfgDBLite,AppDir+'\'+ReplaceStr(UpperCase(FormsCfgDBLite),'.DB','.OLD'));//20150916 Igor
    RenameFile(AppDir+'\'+'OthOpt.d',AppDir+'\'+'OthOpt.old');
    RenameFile(AppDir+'\'+'InvFoot.d',AppDir+'\'+'InvFoot.old');
    RenameFile(AppDir+'\'+'UpdSch.Txt',AppDir+'\'+'UpdSch.old');
    RenameFile(AppDir+'\'+'EfMethod.d',AppDir+'\'+'EfMethod.old');

    InitOptions;
    ListBox1.Items.Add('Preparer etc...Done');
   end
   else
    ListBox1.Items.Add('Preparer/Data directories...FAILED');
 end;
end;


procedure TImportConfigT1_2026.ImportDataDictionary(FromDir: String);
//20170811 Igor>>>
Var
  s: String;
  Dt: TDateTime;
begin
  if ImportFromBox.ItemIndex = 0 then
  begin
    ListBox1.Items.Add('Data Dictionary, not allowed to import from previous year');
    Exit;
  end;
  if SysUtils.FileExists(IncludeTrailingPathDelimiter(FromDir) + DictDBLite) then
  begin
    if FileAge(IncludeTrailingPathDelimiter(FromDir) + DictDBLite, Dt) then  //20150915 Igor
    s := FormatDateTime('yyyy-mm-dd', Dt);
    if LeftStr(s, 10) < '2005-01-27' then
      exit;
  end;

  if CopyDB(DictDBLite, FromDir, AppDir, S) then
    ListBox1.Items.Add('Data Dictionary...Done')
  else
  begin
    MessageDlg(S, mtError, [mbOk], 0);
    ListBox1.Items.Add('Data Dictionary...FAILED');
  end;
//20170811 Igor<<<
end;

procedure TImportConfigT1_2026.ImportOthOpt(FromDir:String);
Var s:String;i:Integer; Dt:TDateTime;
begin
  i:=FileAge(FromDir+'\'+'OthOpt.D');
  Dt:=FileDateToDateTime(i);
  s:=FormatDateTime('yyyy-mm-dd',Dt);
  If LeftStr(s,10) <'2005-01-27' then exit;

  If CopyFile(FromDir+'\'+'OthOpt.D',AppDir+'\'+ 'OthOpt.D') = True then
   ListBox1.Items.Add('Other Options....Done')
  Else
   ListBox1.Items.Add('Other Options....FAILED');
end;

procedure TImportConfigT1_2026.ImportPrintTemplates(FromDir:String);
begin
  ListBox1.Items.Add('PRINT TEMPLATES');

  If CopyFile(FromDir+'\'+'CRASet.D',AppDir+'\'+ 'CRASet.D') = True then
  begin
   CleanUpPrSet(AppDir+'\'+ 'CRASet.D');
   ListBox1.Items.Add('  CRASet....Done')
  end
  Else
   ListBox1.Items.Add('  CRASet....FAILED');

  If CopyFile(FromDir+'\'+'PrepSet.D',AppDir+'\'+ 'PrepSet.D') = True then
  begin
   CleanUpPrSet(AppDir+'\'+ 'PrepSet.D');
   ListBox1.Items.Add('  PrepSet....Done');
  end
  Else
   ListBox1.Items.Add('  PrepSet....FAILED');

  If CopyFile(FromDir+'\'+'ClintSet.D',AppDir+'\'+ 'ClintSet.D') = True then
   begin
    CleanUpPrSet(AppDir+'\'+ 'ClintSet.D');
    ListBox1.Items.Add('  ClintSet....Done');
   end
  Else
   ListBox1.Items.Add('  ClintSet....FAILED');

  If CopyFile(FromDir+'\'+'Oth1Set.D',AppDir+'\'+ 'Oth1Set.D') = True then
  begin
   CleanUpPrSet(AppDir+'\'+ 'Oth1Set.D');
   ListBox1.Items.Add('  Oth1Set....Done');
  end
  Else
   ListBox1.Items.Add('  Oth1Set....FAILED');

  If CopyFile(FromDir+'\'+'Oth2Set.D',AppDir+'\'+ 'Oth2Set.D') = True then
  begin
   CleanUpPrSet(AppDir+'\'+ 'Oth2Set.D');
   ListBox1.Items.Add('  Oth2Set....Done')
  end
  Else
   ListBox1.Items.Add('  Oth2Set....FAILED');

  If CopyFile(FromDir+'\'+'Oth3Set.D',AppDir+'\'+ 'Oth3Set.D') = True then
  begin
   CleanUpPrSet(AppDir+'\'+ 'Oth3Set.D');
   ListBox1.Items.Add('  Oth3Set....Done');
  end
  Else
   ListBox1.Items.Add('  Oth3Set....FAILED');
end;

Procedure TImportConfigT1_2026.CleanUpPrSet(FlName:String);
Var i:Integer;TempList1,TempList2:TStringList;s:String;
begin
 TempList1:=TStringList.Create;
 TempList2:=TStringList.Create;
 TempList1.LoadFromFile(FlName);
 For i:=0 to TempList1.count-1 do
 begin
  s:=TempList1[i];
  s:=ReplaceStr(S,'_1', '');
  s:=ReplaceStr(S,'_2', '');
  s:=ReplaceStr(S,'_3', '');
  s:=ReplaceStr(S,'_4', '');
  s:=ReplaceStr(S,'_5', '');
  s:=ReplaceStr(S,'_6', '');
  s:=ReplaceStr(S,'_7', '');
  s:=ReplaceStr(S,'_8', '');
  s:=ReplaceStr(S,'_9', '');
  s:=ReplaceStr(S,'_10', '');
  s:=ReplaceStr(S,'_11', '');
  s:=ReplaceStr(S,'_12', '');
 // s:=ReplaceStr(S,'GST37','GST370');  //fail
 // s:=ReplaceStr(S,'PAGE','T1');
 // s:=ReplaceStr(S,'INV','INVOICE');
  TempList2.Add(s);
 end;
 TempList2.SaveToFile(FlName);
 TempList1.Free;
 TempList2.Free;
end;

procedure TImportConfigT1_2026.ImportFees(FromDir:String);
//20170811 Igor>>>
var
  Err: String;
begin
  ListBox1.Items.Add('FEES SCHEDULE');

  //20150916 Igor
  If CopyDB(FormsFeesDBLite, FromDir, AppDir, Err) then
   ListBox1.Items.Add('   '+FormsFeesDBLite+'...Done')
  Else
   ListBox1.Items.Add('   '+FormsFeesDBLite+' data Base...FAILED');
//20170811 Igor <<<
end;


procedure TImportConfigT1_2026.ImportClientLetters(FromDir:String);
begin
  ListBox1.Items.Add('CLIENT LETTERS');

  If CopyFile(FromDir+'\'+'EfiledLetter.RTF',AppDir+'\'+ 'EfiledLetter.RTF') = True then
   ListBox1.Items.Add('  EfiledLetter...Done')
  Else
   ListBox1.Items.Add('  EfiledLetter...FAILED');

  If CopyFile(FromDir+'\'+'PaperFiledLetter.RTF',AppDir+'\'+ 'PaperFiledLetter.RTF') = True then
   ListBox1.Items.Add('  PaperFiledLetter...Done')
  Else
   ListBox1.Items.Add('  PaperFiledLetter...FAILED');

  If CopyFile(FromDir+'\'+'PIPEDALetter.RTF',AppDir+'\'+ 'PIPEDALetter.RTF') = True then
   ListBox1.Items.Add('  PIPEDALetter...Done')
  Else
   ListBox1.Items.Add('  PIPEDALetter....FAILED');

  If CopyFile(FromDir+'\'+'EngagementLetter.RTF',AppDir+'\'+ 'EngagementLetter.RTF') = True then
   ListBox1.Items.Add('  EngagementLetter...Done')
  Else
   ListBox1.Items.Add('  EngagementLetter...FAILED');

end;



procedure TImportConfigT1_2026.ImportSuperEntry(FromDir:String);
begin
  ListBox1.Items.Add('SUPER ENTRY FILES');

  If FileExists(FromDir+'\'+'Charity.txt') then
  begin
   If CopyFile(FromDir+'\'+'Charity.Txt',AppDir+'\'+ 'Charity.Txt') = True then
    ListBox1.Items.Add('  Charities....Done')
   Else
    ListBox1.Items.Add('  Charities....FAILED');
  end
  else
  begin
   If CopyFile(FromDir+'\'+'Charity.D',AppDir+'\'+ 'Charity.Txt') = True then
    ListBox1.Items.Add('  Charities....Done')
   Else
    ListBox1.Items.Add('  Charities....FAILED');
  end;

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

  If FileExists(FromDir+'\'+'Cities.Txt') then
  begin
   If CopyFile(FromDir+'\'+'Cities.Txt',AppDir+'\'+ 'Cities.Txt') = True then
    ListBox1.Items.Add('  Cities....Done')
   Else
    ListBox1.Items.Add('  Cities....FAILED');
  end
  else
  begin
  If CopyFile(FromDir+'\'+'Cities.D',AppDir+'\'+ 'Cities.Txt') = True then
   ListBox1.Items.Add('  Cities....Done')
  Else
   ListBox1.Items.Add('  Cities....FAILED');
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
end;

procedure TImportConfigT1_2026.ExitBtnClick(Sender: TObject);
begin
Close;
end;

procedure TImportConfigT1_2026.CheckAllBtnClick(Sender: TObject);
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



procedure TImportConfigT1_2026.ImportFromBoxExit(Sender: TObject);
begin
If ImportFromBox.ItemIndex =0 then
 begin
  CheckBox8.Checked := False;
  CheckBox8.Enabled := False;
 end
 Else
 begin
  CheckBox8.Enabled := True;
 end;
end;


Procedure TImportConfigT1_2026.ImportPrintSeq(FromDir:String;FlName:String);
Var i:Integer;ListNdx:integer;Templist:TStringList;
    S,S1,S2,FrmNm,Prns:string;
begin   //20110210
   If CopyFile(FromDir+'\'+'PrintSeq.Txt',AppDir+'\'+ 'PrintSeq.Txt') = True then
    ListBox1.Items.Add('PRINT SEQUENCE...Done')
   Else
    ListBox1.Items.Add('PRINT SEQUENCE...FAILED');
end;

procedure TImportConfigT1_2026.BrowseFromBtnClick(Sender: TObject);
Var DirSelected:String;
begin
  if SelectDirectory('Select a folder:', '', DirSelected) then
    LastConfigDirBox.text:=DirSelected;
end;

end.
