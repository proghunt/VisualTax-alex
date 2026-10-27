unit FP_2027importconfig;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
     ExtCtrls,FileCtrl,FP_2027Declare,Buttons;

type
  TImportConfigFP_2012 = class(TForm)
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
    procedure ImportFees(FromDir:String;FlName:String);
    Function  ImportFeeSchedule(ToDir,FeesFile:String):Boolean;
    Function  ExportFeeSchedule(FromDir,FeesFile:String):Boolean;
    procedure ImportCfg(FromDir:String);
    procedure ImportOthOpt(FromDir:String);
    procedure ImportPrintTemplates(FromDir:String);
 //   procedure ImportSuperEntry(FromDir:String);
   // procedure ImportCompanyLogo(FromDir:String);
    procedure ImportClientLetters(FromDir:String);
    procedure ImportDataDictionary(FromDir:String);
    procedure CheckAllBtnClick(Sender: TObject);
    //procedure FormPaint(Sender: TObject);
    procedure ImportFromBoxExit(Sender: TObject);
    Procedure ImportPrintSeq(FromDir:String;FlName:String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImportConfig: TImportConfigFP_2012;

implementation

{$R *.DFM}

uses vtCommon,FP_2027Trimstr,FP_2027Common, vtTrimStr, vtShared
   , vtDataBase, uADCompClient; // 20150920 Igor

procedure TImportConfigFP_2012.FormCreate(Sender: TObject);
Var LastYr:Integer;
begin
 LastYr := StrToInt(AppYear)-1;
 If LastYrPgmDirBox.Text = '' then
 LastYrPgmDirBox.Text := 'C:\FP-'+AllTrim(IntToStr(LastYr));

 If LastConfigDirBox.Text = '' then
   LastConfigDirBox.Text := 'C:\FP-'+AppYear+'Config';
 ImportFromBox.ItemIndex:=1;
end;

procedure TImportConfigFP_2012.OkBtnClick(Sender: TObject);
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
 If CheckBox5.Checked then ImportFees(FromDir,'Fees.Txt');
// If CheckBox6.Checked then ImportSuperEntry(FromDir);
 //If CheckBox7.Checked then ImportCompanyLogo(FromDir);
 If CheckBox7.Checked then ImportClientLetters(FromDir);
 If CheckBox8.Checked then ImportDataDictionary(FromDir);
 If ImportFromBox.ItemIndex=0 then
 ShowMessage('You should review again the Options'+Chr(13)+
  'via the Configure | Options'+chr(13)+
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

procedure TImportConfigFP_2012.ImportFees(FromDir:String;FlName:String);
Var FeesFile,ToDir:String;
begin
 If ImportFromBox.ItemIndex =1 then  //last backup
 begin
  FeesFile:= FromDir+'\'+FlName;
  ToDir:=AppDir;
  If ImportFeeSchedule(ToDir,FeesFile) then
    ListBox1.Items.Add('Fee schedules....Done')
  Else
   ListBox1.Items.Add('Fee schedules....FAILED');
  exit;
 end;

 If ImportFromBox.ItemIndex =1 then  //last yr
 begin
   FeesFile:= AppDir+'\'+FlName;
   If ExportFeeSchedule(FromDir,FeesFile) then
   begin
    ToDir:=AppDir;
    If ImportFeeSchedule(ToDir,FeesFile) then
     ListBox1.Items.Add('Fee schedules....Done');
   end
   Else
    ListBox1.Items.Add('Fee schedules....FAILED');
 end;  //last yr
end;

Function TImportConfigFP_2012.ImportFeeSchedule(ToDir,FeesFile:String):Boolean;
Var i:integer;Templist:TStringList;
  FrmNm,FrmFee,FrmAddFee : String;
  ADConnection: TADConnection;
  Table1: TADTable;
begin
 Result:=True;
Try
 If not FileExists(FeesFile) then
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

 For i:=0 to TempList.Count-1 do
 begin
   FrmNm     := LeftStr(TempList[i],8);
   FrmFee    := MidStr(TempList[i],9,7);
   FrmAddFee := MidStr(TempList[i],16,7);
   if Table1.FindKey([FrmNm]) then
    begin
     Table1.Edit;
     Table1.FieldByName('Fee').AsString := Alltrim(FrmFee);
     Table1.FieldByName('FeeAddItem').AsString := AllTrim(FrmAddFee);
     Table1.Post;
    end
   else
    ListBox1.Items.Add('Form '+FrmNm+' not found on data base');
 end;
 TempList.Free;
 Table1.Close;
 Table1.Free;
 ADConnection.Free;
 InitFormsTable;
 Except on E: Exception do
  begin
  MessageDlg(E.Message, mtError, [mbok], 0);
  Result:=False;
  TempList.Free;
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
  end;
end; //try
end;


//needed fr=or import rom last yr. takes FPscr and creates fees.txt
Function TImportConfigFP_2012.ExportFeeSchedule(FromDir,FeesFile:String):Boolean;
Var TempList:TStringList;
    S1,S2,S3,S4,S:String;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
Try
 Result:=True;

 //first export last years fees from FPscr.d bf a TEMP file
 //20150920 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, FromDir + '\' + FormsDBLite, FormsTableLite, '');

 TempList := TstringList.Create;
 TempList.Sorted := True;
 Table1.First;
 while not Table1.EOF do
  begin
    If (Table1.FieldByName('Fee').AsString > '')
    or (Table1.FieldByName('FeeAddItem').AsString > '') then
    begin
     S1:=Table1.FieldByName('FormName').AsString;
     S2 :=Table1.FieldByName('Fee').AsString;
     s3 :=Table1.FieldByName('FeeAddItem').AsString;
     s4 :=Table1.FieldByName('FormDescr').AsString;
     s :=s1+Space(PaddCount(s1,8))
         +s2+Space(PaddCount(s2,7))
         +s3+Space(PaddCount(s3,7))
         +s4+Space(PaddCount(s2,30));
     TempList.Add(s);
    end;
    Table1.Next;
  end;
  TempList.SaveToFile(FeesFile);
  TempList.Free;
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
 Except on E: Exception do
   begin
   MessageDlg(E.Message, mtError, [mbok], 0);
   Result:=False;
   TempList.Free;
   Table1.Close;
   Table1.Free;
   ADConnection.Free;
   end;
end;  //try
end;

procedure TImportConfigFP_2012.ImportCfg(FromDir:String);
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
   If FileExists(FromDir+'\' + FormsCfgDBLite) then //20150923 Igor
   begin
    //20150923 Igor
    ADConnection:= TADConnection.Create(Application);
    CfgTbl := TADTable.Create(Application);
    SetTableName(ADConnection, CfgTbl, FromDir + '\' + FormsCfgDBLite, FormsCfgTableLite, '');

    ConvertCfgToOptionsFile(CfgTbl);
    CfgTbl.Close;
    CfgTbl.Free;
     //Rename old files
    RenameFile(AppDir +'\' +FormsCfgDBLite, AppDir +'\'+ ReplaceStr(UpperCase(FormsCfgDBLite),'.DB','.OLD'));//20150923 Igor
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


procedure TImportConfigFP_2012.ImportDataDictionary(FromDir:String);
Var s:String;i:Integer; Dt:TDateTime;
begin
end;

procedure TImportConfigFP_2012.ImportOthOpt(FromDir:String);
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

procedure TImportConfigFP_2012.ImportPrintTemplates(FromDir:String);
begin
  ListBox1.Items.Add('PRINT TEMPLATES');

  If CopyFile(FromDir+'\'+'PrepSet.D',AppDir+'\'+ 'PrepSet.D') = True then
   ListBox1.Items.Add('  PrepSet....Done')
  Else
   ListBox1.Items.Add('  PrepSet....FAILED');

  If CopyFile(FromDir+'\'+'ClintSet.D',AppDir+'\'+ 'ClintSet.D') = True then
   ListBox1.Items.Add('  ClintSet....Done')
  Else
   ListBox1.Items.Add('  ClintSet....FAILED');

  If CopyFile(FromDir+'\'+'Oth1Set.D',AppDir+'\'+ 'Oth1Set.D') = True then
   ListBox1.Items.Add('  Oth1Set....Done')
  Else
   ListBox1.Items.Add('  Oth1Set....FAILED');

  If CopyFile(FromDir+'\'+'Oth2Set.D',AppDir+'\'+ 'Oth2Set.D') = True then
   ListBox1.Items.Add('  Oth2Set....Done')
  Else
   ListBox1.Items.Add('  Oth2Set....FAILED');

  If CopyFile(FromDir+'\'+'Oth3Set.D',AppDir+'\'+ 'Oth3Set.D') = True then
   ListBox1.Items.Add('  Oth3Set....Done')
  Else
   ListBox1.Items.Add('  Oth3Set....FAILED');

end;

procedure TImportConfigFP_2012.ImportClientLetters(FromDir:String);
begin
  ListBox1.Items.Add('CLIENT LETTERS');

  If CopyFile(FromDir+'\'+'EXECSum.RTF',AppDir+'\'+ 'ExecSum.RTF') = True then
   ListBox1.Items.Add('  ExecSum...Done')
  Else
   ListBox1.Items.Add('  ExecSum....FAILED');


  If CopyFile(FromDir+'\'+'PIPEDALetter.RTF',AppDir+'\'+ 'PIPEDALetter.RTF') = True then
   ListBox1.Items.Add('  PIPEDALetter...Done')
  Else
   ListBox1.Items.Add('  PIPEDALetter....FAILED');

  If CopyFile(FromDir+'\'+'EngagementLetter.RTF',AppDir+'\'+ 'EngagementLetter.RTF') = True then
   ListBox1.Items.Add('  EngagementLetter...Done')
  Else
   ListBox1.Items.Add('  EngagementLetter...FAILED');

end;

procedure TImportConfigFP_2012.ExitBtnClick(Sender: TObject);
begin
Close;
end;

procedure TImportConfigFP_2012.CheckAllBtnClick(Sender: TObject);
begin
 CheckBox1.Checked := True;
 CheckBox2.Checked := False;
 CheckBox3.Checked := True;
 CheckBox4.Checked := True;
 CheckBox5.Checked := True;
 CheckBox6.Checked := False;
 CheckBox7.Checked := True;
 CheckBox8.Checked := True;
 //If ImportFromBox.ItemIndex=0 then CheckBox9.Checked := False;
end;



procedure TImportConfigFP_2012.ImportFromBoxExit(Sender: TObject);
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


Procedure TImportConfigFP_2012.ImportPrintSeq(FromDir:String;FlName:String);
Var i:Integer;ListNdx:integer;Templist:TStringList;
    S,S1,S2,FrmNm,Prns:string;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
Try
  //20150920 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite, 'FormName');

 TempList := TstringList.Create;
 TempList.Sorted := True;
 If FileExists(FromDir+'\'+FlName) then
  TempList.LoadFromFile(FromDir+'\'+FlName);
 Table1.First;

 For i:=0 to TempList.Count-1 do
 begin
   FrmNm:=AllTrim(LeftStr(TempList[i],15));
   PrnS :=AllTrim(MidStr(TempList[i],16,5));
   If Table1.FindKey([FrmNm]) then
   begin
     Table1.Edit;
     Table1.FieldByName('PrnSeq').AsString:= PrnS;
     Table1.Post;
   end;
 end;
 TempList.Free;
 Table1.Close;
 Table1.Free;
 ADConnection.Free;
 ListBox1.Items.Add('Print Sequence...Done');
Except
 on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
end; //try
end;


end.
