unit T2_2027ExportConfig;

interface

uses Windows,Messages,SysUtils,Classes,Graphics,Controls,Forms,Dialogs,StdCtrls,
  ExtCtrls,FileCtrl,T2_2027Declare,T2_2027Trimstr,Buttons,
  T2_2027Common;

type
  TExportConfigT2_2027 = class(TForm)
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
    Label5: TLabel;
    LastConfigDirBox: TEdit;
    ListBox1: TListBox;
    GroupBox3: TGroupBox;
    OkBtn: TBitBtn;
    ExitBtn: TBitBtn;
    Label6: TLabel;
    CheckAllBtn: TBitBtn;
    Label1: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
    //procedure ExportFees(ToDir:String);

    //Function  ExportFeeSchedule(ToDir,FeesFile:String):Boolean;
    //Function  ExportFeeSchedule(ToDir,FeesFile:String):Boolean;
    procedure ExportCfg(ToDir:String);
    procedure ExportOthOpt(ToDir:String);
    procedure ExportPrintTemplates(ToDir:String);
    procedure ExportSuperEntry(ToDir:String);
   // procedure ExportCompanyLogo(ToDir:String);
    procedure ExportClientLetters(ToDir:String);
    procedure ExportDataDictionary(ToDir:String);
    procedure CheckAllBtnClick(Sender: TObject);
    //procedure FormPaint(Sender: TObject);
    Procedure ExportFeesTotext(ToDir:String;FlName:String);
    Procedure ExportPrintSeq(ToDir:String;FlName:String);
    procedure FormPaint(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportConfig: TExportConfigT2_2027;
  ToDir:String;
  
implementation

{$R *.DFM}

uses vtMulti, vtTrimStr, vtShared
   , vtDataBase, uADCompClient; // 20150920 Igor

procedure TExportConfigT2_2027.FormCreate(Sender: TObject);
Var LastYr:Integer;
begin
 If LastConfigDirBox.Text = '' then
   LastConfigDirBox.Text := 'C:\T2-'+AppYear+'Config';
end;

procedure TExportConfigT2_2027.OkBtnClick(Sender: TObject);
begin
 ListBox1.Items.Clear;
 If Not SysUtils.DirectoryExists(LastConfigDirBox.Text) then //20150702
  begin
    SysUtils.ForceDirectories(LastConfigDirBox.Text); //20150702

  end;
 ToDir:=LastConfigDirBox.Text;

 If CheckBox1.Checked then ExportCfg(ToDir);
 //If CheckBox2.Checked then ExportOthOpt(ToDir);
 If CheckBox3.Checked then ExportPrintTemplates(ToDir);
 If CheckBox4.Checked then ExportPrintSeq(ToDir,'PrintSeq.txt');
 If CheckBox5.Checked then ExportFeesToText(ToDir,'Fees.Txt');
 If CheckBox6.Checked then ExportSuperEntry(ToDir);
 If CheckBox7.Checked then ExportClientLetters(ToDir);
 If CheckBox8.Checked then ExportDataDictionary(ToDir);

end;


(*
procedure TExportConfig.ExportCompanyLogo(ToDir:String);
begin
  If CopyFile(AppDir+'\'+ 'LogoInfo.Txt',ToDir+'\'+'LogoInfo.Txt') = True then
   ListBox1.Items.Add('Company Logo...Done')
  Else
   ListBox1.Items.Add('Company Logo...FAILED');
end;
*)


procedure TExportConfigT2_2027.ExportCfg(ToDir:String);
begin
  If CopyFile(AppDir+'\'+ 'Options.Txt',ToDir+'\'+'Options.Txt') = True then
    ListBox1.Items.Add('Options...Done')
  Else
    ListBox1.Items.Add('Options...FAILED');
end;


procedure TExportConfigT2_2027.ExportDataDictionary(ToDir:String);
begin
  //
end;

procedure TExportConfigT2_2027.ExportOthOpt(ToDir:String);
begin
  //
end;

procedure TExportConfigT2_2027.ExportPrintTemplates(ToDir:String);
begin
  ListBox1.Items.Add('PRINT TEMPLATES');

  If CopyFile(AppDir+'\'+ 'RVCANSet.D',ToDir+'\'+'RVCANSet.D') = True then
   ListBox1.Items.Add('  RVCANSet....Done')
  Else
   ListBox1.Items.Add('  RVCANSet....FAILED');

  If CopyFile(AppDir+'\'+ 'PrepSet.D',ToDir+'\'+'PrepSet.D') = True then
   ListBox1.Items.Add('  PrepSet....Done')
  Else
   ListBox1.Items.Add('  PrepSet....FAILED');

  If CopyFile(AppDir+'\'+ 'ClintSet.D',ToDir+'\'+'ClintSet.D') = True then
   ListBox1.Items.Add('  ClintSet....Done')
  Else
   ListBox1.Items.Add('  ClintSet....FAILED');

  If CopyFile(AppDir+'\'+ 'Oth1Set.D',ToDir+'\'+'Oth1Set.D') = True then
   ListBox1.Items.Add('  Oth1Set....Done')
  Else
   ListBox1.Items.Add('  Oth1Set....FAILED');

  If CopyFile(AppDir+'\'+ 'Oth2Set.D',ToDir+'\'+'Oth2Set.D') = True then
   ListBox1.Items.Add('  Oth2Set....Done')
  Else
   ListBox1.Items.Add('  Oth2Set....FAILED');

  If CopyFile(AppDir+'\'+ 'Oth3Set.D',ToDir+'\'+'Oth3Set.D') = True then
   ListBox1.Items.Add('  Oth3Set....Done')
  Else
   ListBox1.Items.Add('  Oth3Set....FAILED');

end;

procedure TExportConfigT2_2027.ExportClientLetters(ToDir:String);
begin
  ListBox1.Items.Add('CLIENT LETTERS');

  If CopyFile(AppDir+'\'+ 'EfiledLetter.RTF',ToDir+'\'+'EfiledLetter.RTF') = True then
   ListBox1.Items.Add('  EfiledLetter...Done')
  Else
   ListBox1.Items.Add('  EfiledLetter letter....FAILED');

  If CopyFile(AppDir+'\'+ 'PaperFiledLetter.RTF',ToDir+'\'+'PaperFiledLetter.RTF') = True then
   ListBox1.Items.Add('  PaperFiledLetter...Done')
  Else
   ListBox1.Items.Add('  PaperFiledLetter....FAILED');

  If CopyFile(AppDir+'\'+ 'PIPEDALetter.RTF',ToDir+'\'+'PIPEDALetter.RTF') = True then
   ListBox1.Items.Add('  PIPEDAletter...Done')
  Else
   ListBox1.Items.Add('  PIPEDALetter....FAILED');

  If CopyFile(AppDir+'\'+ 'EngagementLetter.RTF',ToDir+'\'+'EngagementLetter.RTF') = True then
   ListBox1.Items.Add('  EngagementLetter...Done')
  Else
   ListBox1.Items.Add('  EngagementLetter....FAILED');

end;



procedure TExportConfigT2_2027.ExportSuperEntry(ToDir:String);
begin
  ListBox1.Items.Add('SUPER ENTRY FILES');

  If CopyFile(AppDir+'\'+ 'CorpBn.txt',ToDir+'\'+'CorpBn.txt') = True then
   ListBox1.Items.Add('  CorpBn....Done')
  Else
   ListBox1.Items.Add('  CorpBn....FAILED');

  If CopyFile(AppDir+'\'+ 'CorpNm.txt',ToDir+'\'+'CorpNm.txt') = True then
   ListBox1.Items.Add('  CorpNm....Done')
  Else
   ListBox1.Items.Add('  CorpNm....FAILED');

  If CopyFile(AppDir+'\'+ 'Cities.txt',ToDir+'\'+'Cities.txt') = True then
   ListBox1.Items.Add('  Cities....Done')
  Else
   ListBox1.Items.Add('  Cities....FAILED');

  (*
  If CopyFile(AppDir+'\'+ 'Doctors.txt',ToDir+'\'+'Doctors.txt') = True then
   ListBox1.Items.Add('  Doctors....Done')
  Else
   ListBox1.Items.Add('  Doctors....FAILED');

  If CopyFile(AppDir+'\'+ 'MedExp.txt',ToDir+'\'+'MedExp.txt') = True then
   ListBox1.Items.Add('  Med. Expense types...Done')
  Else
   ListBox1.Items.Add('  Med. Expense types...FAILED');

  If CopyFile(AppDir+'\'+ 'FirstNm.txt',ToDir+'\'+'FirstNm.txt') = True then
   ListBox1.Items.Add('  First Names...Done')
  Else
   ListBox1.Items.Add('  First Names...FAILED');


  If CopyFile(AppDir+'\'+ 'Employers.txt',ToDir+'\'+'Employers.txt') = True then
   ListBox1.Items.Add('  Employers....Done')
  Else
   ListBox1.Items.Add('  Employers....FAILED');

  If CopyFile(AppDir+'\'+ 'Banks.txt',ToDir+'\'+'Banks.txt') = True then
   ListBox1.Items.Add('  Banks....Done')
  Else
   ListBox1.Items.Add('  Banks....FAILED');
 *)
end;

procedure TExportConfigT2_2027.ExitBtnClick(Sender: TObject);
begin
Close;
end;

procedure TExportConfigT2_2027.CheckAllBtnClick(Sender: TObject);
begin
 CheckBox1.Checked := True;
 CheckBox2.Checked := False;  //oth options not in use True;
 CheckBox3.Checked := True;
 CheckBox4.Checked := True;
 CheckBox5.Checked := True;
 CheckBox6.Checked := True;
 CheckBox7.Checked := True;
 CheckBox8.Checked := True;
 //If ImportFromBox.ItemIndex=0 then CheckBox9.Checked := False;
end;

Procedure TExportConfigT2_2027.ExportFeesTotext(ToDir:String;FlName:String);
Var ListNdx:integer;Templist:TStringList; S,S1,S2,S3,S4:string;
    ADConnection: TADConnection;
    Table1: TADTable;
begin

 //20150920 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite, 'FormName');

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
  TempList.SaveToFile(ToDir+'\'+FlName);
  TempList.Free;
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
  ListBox1.Items.Add('Fee schedule...Done')
end;

Procedure TExportConfigT2_2027.ExportPrintSeq(ToDir:String;FlName:String);
Var ListNdx:integer;Templist:TStringList; S,S1,S2:string;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
 //20150920 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, AppDir + '\' + FormsDBLite, FormsTableLite, 'FormName');

 TempList := TstringList.Create;
 TempList.Sorted := True;
 Table1.First;
 while not Table1.EOF do
  begin
    If (Table1.FieldByName('FormName').AsString > '')
    then
    begin
     S1:=Table1.FieldByName('FormName').AsString;
     S2 :=Table1.FieldByName('PrnSeq').AsString;
     s :=PaddR(s1,15)+s2;
     TempList.Add(s);
    end;
    Table1.Next;
  end;
  TempList.SaveToFile(ToDir+'\'+FlName);
  TempList.Free;
  Table1.Close;
  Table1.Free;
  ADConnection.Free;
  ListBox1.Items.Add('Print Sequence...Done')
end;


procedure TExportConfigT2_2027.FormPaint(Sender: TObject);
begin
 If LastConfigDirBox.Text ='' then
  LastConfigDirBox.Text := 'C:\T2-'+AppYear+'Config';
end;

end.
