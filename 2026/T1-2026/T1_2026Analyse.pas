unit T1_2026Analyse;
//imported 07-19

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,DB,StdCtrls,ExtCtrls,Buttons,Grids,DBGrids,DBCtrls,
  Printers, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;

type
  TAnalyseT1_2026 = class(TForm)
    Panel1: TPanel;
    DataSource1: TDataSource;
    Label6: TLabel;
    Label7: TLabel;
    LineBox1: TEdit;
    LineBox2: TEdit;
    AmountBox1: TEdit;
    AmountBox2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label12: TLabel;
    CountBox: TLabel;
    Panel3: TPanel;
    PrintListBtn: TBitBtn;
    PrintLabelsBtn: TBitBtn;
    Panel4: TPanel;
    PrintLetterBtn: TBitBtn;
    LineBox3: TEdit;
    AmountBox3: TEdit;
    Label2: TLabel;
    Label5: TLabel;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    DataDirBox: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label11: TLabel;
    Panel2: TPanel;
    ListBox1: TListBox;
    SaveBtn: TBitBtn;
    OpenBtn: TBitBtn;
    ClearListBtn: TButton;
    ManualBtn: TButton;
    FileListBox1: TFileListBox;
    DesignBtn: TBitBtn;
    Label13: TLabel;
    PrintDialog1: TPrintDialog;
    Label14: TLabel;
    Label1: TLabel;
    Label15: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    AgeBox1: TEdit;
    Label21: TLabel;
    Label22: TLabel;
    AgeBox2: TEdit;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    MarBox1: TCheckBox;
    MarBox2: TCheckBox;
    MarBox3: TCheckBox;
    MarBox4: TCheckBox;
    MarBox5: TCheckBox;
    MarBox6: TCheckBox;
    Label16: TLabel;
    GraphBtn: TSpeedButton;
    Panel5: TPanel;
    FindBtn: TBitBtn;
    AdvancedBtn: TBitBtn;
    CancelBtn: TBitBtn;
    FpFindBtn: TBitBtn;
    Memo1: TMemo;
    CreateEmailListBtn: TBitBtn;
    SendEmailbtn: TBitBtn;
    OpenReturnBtn: TBitBtn;
    FDConnection: TADConnection;
    Table1: TADTable;
    Label17: TLabel;

   Procedure OpenTheDataBase;
   procedure PrintLetter(LetterName:String;RetFlName:String);
  // Procedure PrintARichLetter(RetNo:Integer;LetterName:String);
   Function SelectLine:String;
    procedure CancelBtnClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintLabelsBtnClick(Sender: TObject);
    procedure PrintLetterBtnClick(Sender: TObject);
    procedure PrintListBtnClick(Sender: TObject);
    Function AnalyseReturn(DataDir: string; FlName: string;
             Age1,Age2:String; Mar1,Mar2,Mar3,Mar4,Mar5,Mar6:boolean;Telephone:String;EMail:String):integer;
    procedure FormPaint(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure ClearListBtnClick(Sender: TObject);
    procedure ManualBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure DesignBtnClick(Sender: TObject);
    procedure MarBox1Change(Sender: TObject);
    procedure AgeBox1Change(Sender: TObject);
    procedure MarBox2Change(Sender: TObject);
    procedure AgeBox2Change(Sender: TObject);
    procedure GraphBtnClick(Sender: TObject);
    Function  TaxCriteriaExist(Line1,Line2,Line3:string):boolean;
    procedure AdvancedBtnClick(Sender: TObject);
    procedure FpFindBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure CreateEmailListBtnClick(Sender: TObject);
    procedure SendEmailbtnClick(Sender: TObject);
    procedure OpenReturnBtnClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
  private
    FRetNo: integer;

    LastFirstName,  // : String[45];
    FlName : String;  // [12];
    MxLength :integer; {for LastFirstName on the listbox}
  public
    property RetNo: integer read FRetNo;
  end;

var
  Analyse: TAnalyseT1_2026;

implementation
{$R *.DFM}

uses
  vtMulti,vtCommon,vtDialogs,vtMain,
  T1_2026,T1_2026Declare,T1_2026Common,T1_2026Cpl,
  T1_2026Common2,T1_2026TrimStr,T1_2026GetFile,T1_2026T1Rtns,T1_2026T1Rtns2,
  T1_2026FpFind,T1_2026AdvFnd,T1_2026Calc,T1_2026Print,T1_2026ChildWinNew,
  T1_2026Main,T1_2026ChartClients,
  vtTrimStr,vtShared, vtDataBase, //20150826 IGOR
  vtFileStorage, Variants; //20160422 Igor

procedure TAnalyseT1_2026.CancelBtnClick(Sender: TObject);
begin
 Table1.Close;
 Close;
end;

procedure TAnalyseT1_2026.FindBtnClick(Sender: TObject);
Var Result, I,MarStat1,Marstat2,Age1,Age2 : Integer; Telephone,EMail:String;
begin
  If DirectoryExists(DataDirBox.Text) = False then
  begin
   ShowMessage('Directory does not exist');
   DataDirBox.SetFocus;
   Exit;
  end;
  If ListBox1.Items.Count >0 then
     if MessageDlg('Add to the current list?',
        mtInformation, [mbYes, mbNo], 0) = mrNo then
        ListBox1.Clear;
  CountBox.Caption := IntToStr(ListBox1.Items.Count);
  Table1.First;
  while not Table1.EOF do
   begin
    FlName := Table1.FieldByName('File_Name').AsString;
    LastFirstName := Rtrim(Table1.FieldByName('Last_Name').AsString)+
       ' '+LeftStr(Table1.FieldByName('First_Name').AsString,1)+'.';
    Telephone := Table1.FieldByName('Area').AsString+
       ' - '+Table1.FieldByName('Phone').AsString;

    Email := Table1.FieldByName('Email').AsString;

    Screen.Cursor := crHourGlass;

    result := AnalyseReturn(DataDirBox.Text,FlName,
       AgeBox1.text,AgeBox2.text,
       MarBox1.Checked,MarBox2.Checked, MarBox3.Checked,
       MarBox4.Checked,MarBox5.Checked, MarBox6.Checked,Telephone,EMail);

    If result <> 0 then ShowOpenReturnFailure(Result,DataDirBox.Text,FlName);
    {end;}
    Table1.Next;
   end;
   Screen.Cursor := crDefault;
   Refresh;
end;

procedure TAnalyseT1_2026.FormCreate(Sender: TObject);
begin
  FRetNo:=GetCurrentRetNo; //asked to close all return first???
  MxLength :=15;
  Panel5.Caption := SomeCaption;
  Analyse.Caption := SomeCaption;
  {SelectGroup.ItemIndex := 0;}
  DataDirBox.Text := OptRec.Dir_Cur;
  OpenTheDataBase;
  (*
  If Table1.Active then Table1.Close;
  Table1.DataBaseName := DataDirBox.Text;
  Table1.TableName := ClientsTable;
  Table1.Open;
  *)
  FileListBox1.Directory := AppDir;
  FileListBox1.Mask := '*.Rtf';
  FileListBox1.ItemIndex :=0;
  MarBox1.Checked := True;
  MarBox2.Checked := True;
  MarBox3.Checked := True;
  MarBox4.Checked := True;
  MarBox5.Checked := True;
  MarBox6.Checked := True;
  //20150904 igor
//  FDConnection.Params.Values['Password'] := OptRec.SQLLitePassword.CurrentPassword; //20160226 Igor   //20160422 Igor
end;

procedure TAnalyseT1_2026.PrintLabelsBtnClick(Sender: TObject);
Var i,ndx,FNo:Integer; FlName,FName :String;
  FileNm:String;F1:textFile; S:string;
  KeysForLabels: TStringList;
begin
 if MessageDlg('Load laser printer label sheets (2 5/8" X 1" (3 columns)'+
        Chr(13)+'Ready?',
        mtInformation, [mbYes, mbNo], 0) = mrNo then
        exit;

 If ListBox1.Items.Count =0 then exit;
 KeysForLabels := TstringList.Create;
 For i := 0 to ListBox1.Items.Count-1 do
  KeysForLabels.Add(AllTrim(MidStr(ListBox1.Items[i],MxLength+2,12)));
 FileNm:=AppDir+'\'+'TempFile';
 KeysForLabels.SaveToFile(FileNm);
 KeysForLabels.Free;
 If PrintDialog1.Execute then
 begin
  Screen.Cursor := crHourGlass;
  PrintLabels(RetNo,DataDirBox.Text,FileNm);
  ShowMessage('Labels printing completed');
  Screen.Cursor := crDefault;
 end;
end;


procedure TAnalyseT1_2026.PrintListBtnClick(Sender: TObject);
Var FileNm,Hdr1,Hdr2,Hdr3,s:string;
begin
 s:= InputBox('', 'Enter report title (up to 50 characters)', 'Client Tax Criteria:');
 If ListBox1.Items.Count =0 then exit;

 Hdr1 := PaddR(S,60)+' '+PaddR(DateToMonthDayYear(Date),20);
 Hdr2 := 'Name            File Name';
 Hdr3 := FilledStr(80,'=')+FilledStr(14,'=');
 FileNm:=AppDir+'\'+'TempFile';
 ListBox1.Items.SaveToFile(FileNm);
 If PrintDialog1.Execute then
 begin
 If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
  ShowMessage('Printing Completed');
 end;
end;

Function TAnalyseT1_2026.AnalyseReturn(DataDir: string; FlName: string;
  Age1, Age2: String; Mar1, Mar2, Mar3, Mar4, Mar5, Mar6: boolean;
  Telephone: String; EMail: String): integer;
var
  I, j, k, FNo, SNo, BxNo, ApplYear, Birthyear, HisAge: integer;
  Qualif1, Qualif2, Qualif3: boolean; { one for each condition }
  F1: textFile;
  HisMarStatus: String[1];
  ndx: Array [1 .. 3] of byte;
  S: String[16];
  InputLin, Var1, Var2, Var3, Var4: String;
  TempList: TStringList;
  FoundValue1, FoundValue2, FoundValue3: Real;
  InputValue1, InputValue2, InputValue3: Real;
  F: TFileStorage;
  SQLite: TSQLiteStorage;
  ElementID: Integer; //20161206 Igor
begin
  FoundValue1 := 0;
  FoundValue2 := 0;
  FoundValue3 := 0;

  InputValue1 := Vl(AmountBox1.Text);
  InputValue2 := Vl(AmountBox2.Text);
  InputValue3 := Vl(AmountBox3.Text);

  TempList := TStringList.Create;
  If Mar1 then
    TempList.Add('1');
  If Mar2 then
    TempList.Add('2');
  If Mar3 then
    TempList.Add('3');
  If Mar4 then
    TempList.Add('4');
  If Mar5 then
    TempList.Add('5');
  If Mar6 then
    TempList.Add('6');

  ApplYear := MyStrToInt(AppYear);
  Qualif1 := False;
  Qualif2 := False;
  Qualif3 := False;

  If Vl(LineBox3.Text) = 0 then
    Qualif3 := True;

  Result := 0;
  Birthyear := MyStrToInt(LeftStr(AllTrim(Table1.FieldByName('BirthDate')
    .AsString), 4));
  HisAge := ApplYear - Birthyear;
  HisMarStatus := Table1.FieldByName('MarStatus').AsString;

  If TaxCriteriaExist(LineBox1.Text, LineBox2.Text, LineBox3.Text) then
  begin
    if FileExists(DataDir + '\' + FlName) = False then
    begin
      Result := -1;
      Exit;
    end;

    SQLite := TSQLiteStorage.Create(DataDir, FlName, fsRead, AppT1_2026.SQLLitePassword.PassRFArray);
    if SQLite.LastError <> '' then
    Begin
      freeAndNil(SQLite);
      f := TFileStorage.Create(DataDir, FlName, fsRead);
    End;
    try
      if assigned(SQLite) then
      Begin
         if not SQLite.ReadSettings('AppName', Var1) then
         Begin
           ShowMessage(SQLite.LastError);
           exit;
         End;
      End
      else
        f.ReadLine(Var1,Var2,Var3,Var4);
      if Var1 <> AppName then
      Begin
        Result := -2;
        exit;
      End;
      if Assigned(SQLite) then
      Begin
      //20161206 Igor >>>
        if (LineBox1.Text <> '') and TryStrToInt(LineBox1.Text, ElementID) then
          FoundValue1 := Vl(SQLite.ReadData('Z_LINES', 'L', ElementID));
//           SQLite.QData.Locate('RecordType;ElementID',VarArrayOf(['L',LineBox1.Text]),[]) then
//          FoundValue1 := Vl(SQLite.QData.fieldByName('Value').asString);
        if (LineBox2.Text <> '') and TryStrToInt(LineBox1.Text, ElementID) then
          FoundValue2 := Vl(SQLite.ReadData('Z_LINES', 'L', ElementID));
//            SQLite.QData.Locate('RecordType;ElementID',VarArrayOf(['L',LineBox2.Text]),[]) then
//          FoundValue2 := Vl(SQLite.QData.fieldByName('Value').asString);
        if (LineBox3.Text <> '') and TryStrToInt(LineBox1.Text, ElementID) then
          FoundValue3 := Vl(SQLite.ReadData('Z_LINES', 'L', ElementID));
//            SQLite.QData.Locate('RecordType;ElementID',VarArrayOf(['L',LineBox3.Text]),[]) then
//          FoundValue3 := Vl(SQLite.QData.fieldByName('Value').asString);
      //20161206 Igor <<<
      End
      else
      Begin
        while f.ReadLine(Var1,Var2,Var3,Var4) do
        Begin
          if Var1 = 'L' then
          begin
            If (Vl(Var2) = Vl(LineBox1.Text)) then
              FoundValue1 := Vl(Var3);
            If (Vl(Var2) = Vl(LineBox2.Text)) then
              FoundValue2 := Vl(Var3);
            If (Vl(Var2) = Vl(LineBox3.Text)) then
              FoundValue3 := Vl(Var3);
          end;
        End;
      End;

    finally
      if assigned(SQLite) then
        FreeAndNil(SQLite);
      if assigned(F) then
        freeAndNil(F);
    end;
  end;

  { tax criteria }
  If Vl(LineBox1.Text) = 0 then
    Qualif1 := True;
  If Vl(LineBox2.Text) = 0 then
    Qualif2 := True;
  If Vl(LineBox3.Text) = 0 then
    Qualif3 := True;

  If FoundValue1 > InputValue1 then
    Qualif1 := True;
  If FoundValue2 > InputValue2 then
    Qualif2 := True;
  If FoundValue3 < InputValue3 then
    Qualif3 := True;

  If (Qualif1 = True) and (Qualif2 = True) and (Qualif3 = True) and
    (HisAge >= MyStrToInt(Age1)) and (HisAge <= MyStrToInt(Age2)) and
    (IsInList(HisMarStatus, TempList) > -1) then
    // mxlength is 15
    ListBox1.Items.Add(PaddR(LastFirstName, MxLength) + '-' + PaddR(FlName, 15)
      + Space(5) + PaddR(Telephone, 15) + Space(5) + EMail);
  // Email at position 56
  CountBox.Caption := IntToStr(ListBox1.Items.Count);
  TempList.Free;
end;

Function TAnalyseT1_2026.TaxCriteriaExist(Line1,Line2,Line3:string):boolean;
begin
  result := true;
  If ((Vl(Line1) =0) and (Vl(Line2) =0) and (Vl(Line3) =0)) then
   result := false;
end;

procedure TAnalyseT1_2026.FormPaint(Sender: TObject);
begin
If AgeBox1.Text ='' then AgeBox1.Text :='0';
If AgeBox2.Text ='' then AgeBox2.Text :='110';

If ListBox1.Items.Count = 0 then
 begin
 PrintLetterBtn.Enabled := False;
 PrintListBtn.Enabled := False;
 PrintLabelsBtn.Enabled := False;
 ClearListBtn.Enabled := False;
 SaveBtn.Enabled := False;
 end
else
 begin
 PrintLetterBtn.Enabled := True;
 PrintListBtn.Enabled := True;
 PrintLabelsBtn.Enabled := True;
 ClearListBtn.Enabled := True;
 SaveBtn.Enabled := True;
 end;
CountBox.Caption := IntToStr(ListBox1.Items.Count);
end;

procedure TAnalyseT1_2026.OpenBtnClick(Sender: TObject);
Var TempList :TstringList;
I,j :integer;
begin
  TempList := TStringList.Create;
  SomeList.Clear; // := TstringList.Create;
  SomeCaption := 'Select File(s)';
  {'Text Files (*.Txt)|*.Txt|All files (*)|*.*'}
  SomeFilter := 'Text Files (*.T1X)|All Files (*.*)';
  SomeFileMask := '*.T1X';

  Application.CreateForm(TgetfileT1_2026,GetFile);
  GetFile.ShowModal; {prepares selected files into the SomeList global}
  For i:= 0 to SomeList.Count-1 do
   begin
   TempList.LoadFromFile(SomeList[i]); {Get returns from each file}
   For j:=0 to TempList.Count-1 do
     begin ListBox1.Items.Add(TempList[j]);Refresh;end;
     {ListBox1.Items.AddStrings(TempList);}
   TempList.Clear;
   CountBox.Caption := IntToStr(ListBox1.Items.Count);
   {CountBox.Refresh;}
   end;
  GetFile.Free;   {free the modal form}
  SomeList.Clear; //SomeList.Free;
  TempList.Free;
  Refresh;
end;

procedure TAnalyseT1_2026.SaveBtnClick(Sender: TObject);
Var  InputString: string;
begin
SaveDialog1.FileName := 'Mylist1.T1X';
SaveDialog1.Filter := 'Text Files (*.T1X)';
if SaveDialog1.Execute then
  begin
    ListBox1.Items.SaveToFile(SaveDialog1.Filename);
    ShowMessage('List saved');
  end;
end;

procedure TAnalyseT1_2026.ClearListBtnClick(Sender: TObject);
begin
ListBox1.Clear;
CountBox.Caption := IntToStr(ListBox1.Items.Count);
Refresh;
end;

procedure TAnalyseT1_2026.ManualBtnClick(Sender: TObject);
var
  FlName: string[12];s:string;
begin
  s:='';
  FlName:= InputBox(
    'Enter File Name (SIN)', 'SIN: (as 99999999.9)', '');
  If FlName ='' then exit;
  if FileExists(DataDirbox.text+'\'+FlName) = false then
    ShowMessage('File does not exist in specified directory')
  else
    ListBox1.Items.Add(PaddR(s,MxLength)+'-'+FlName);
  Refresh;
end;

procedure TAnalyseT1_2026.Button1Click(Sender: TObject);
begin
 SelectedString := SelectLine;
 If Numeric(LeftStr(SelectedString,3)) then
    begin
    LineBox1.Text := LeftStr(SelectedString,3);
    AmountBox1.Text := '0';
    end
end;

procedure TAnalyseT1_2026.Button2Click(Sender: TObject);
begin
 SelectedString := SelectLine;
 If Numeric(LeftStr(SelectedString,3)) then
    begin
    LineBox2.Text := LeftStr(SelectedString,3);
    AmountBox2.Text := '0';
    end;
end;

procedure TAnalyseT1_2026.Button3Click(Sender: TObject);
begin
 SelectedString := SelectLine;
 If Numeric(LeftStr(SelectedString,3)) then
    begin
    LineBox3.Text := LeftStr(SelectedString,3);
    AmountBox3.Text := '0';
    end;
end;

Function TAnalyseT1_2026.SelectLine:String;
begin
  Result := PopSomeFile('Lines.d','Select a Line');
end;

procedure TAnalyseT1_2026.DesignBtnClick(Sender: TObject);
begin
  MainFormT1.ClientLetter1Click(Sender);
  FileListBox1.Update;
end;

procedure TAnalyseT1_2026.MarBox1Change(Sender: TObject);
begin
Paint;
end;

procedure TAnalyseT1_2026.AgeBox1Change(Sender: TObject);
begin
Paint;
end;

procedure TAnalyseT1_2026.MarBox2Change(Sender: TObject);
begin
Paint;
end;

procedure TAnalyseT1_2026.AgeBox2Change(Sender: TObject);
begin
Paint;
end;

procedure TAnalyseT1_2026.GraphBtnClick(Sender: TObject);
begin
  ExecuteForm(TChartClientsT1_2026);
end;


procedure TAnalyseT1_2026.AdvancedBtnClick(Sender: TObject);
begin
  SomeList.Clear;  // := Tstringlist.Create;
 Application.CreateForm(TadvfndT1_2026,AdvFnd);
 AdvFnd.ShowModal;
 AdvFnd.Free;

 Try
  If Somelist = Nil then  //20140206
  // do nothing
  Else
  Begin
   If SomeList.Count >0 then   {created in advance}
   begin
    If ListBox1.Items.Count >0 then
         if MessageDlg('Add to the current list?',
            mtInformation, [mbYes, mbNo], 0) = mrNo then ListBox1.Clear;
    CountBox.Caption := IntToStr(ListBox1.Items.Count);
    ListBox1.Items.AddStrings(SomeList);
   end;
  end;
 Except
 End;
 //do not free some list here
end;

procedure TAnalyseT1_2026.FpFindBtnClick(Sender: TObject);
begin
 begin
      ShowMessage('This feature is offered only in the top T1 version');
      exit;
 end;

 SomeList.Clear;  // := Tstringlist.Create;
 Application.CreateForm(TFPFINDT1_2026,FpFind);
 FpFind.ShowModal;
 FpFind.Free;
 If SomeList.Count >0 then   {created in advance}
 begin
  If ListBox1.Items.Count >0 then
      if MessageDlg('Add to the current list?',
         mtInformation, [mbYes, mbNo], 0) = mrNo then ListBox1.Clear;
  CountBox.Caption := IntToStr(ListBox1.Items.Count);
  ListBox1.Items.AddStrings(SomeList);
 end;
end;

procedure TAnalyseT1_2026.PrintLetterBtnClick(Sender: TObject);
Var i:Integer;
begin
  If FileListBox1.ItemIndex<0 then
   begin
    ShowMessage('You must select a letter first');
    exit;
   end;

  If PrintDialog1.Execute then   //20140105
  Begin
   Screen.Cursor := crHourGlass;
   For i:=0 to ListBox1.Items.Count-1 do
   begin
     PrintLetter(FileListBox1.Items[FileListBox1.ItemIndex],
         AllTrim(MidStr(ListBox1.Items[i],MxLength+2,12)));
     If i=0 then
     begin
      if MessageDlg('Print letters for the rest of the clients listed?',
       mtConfirmation, [mbYes, mbNo], 0) = mrNo then
        begin  Screen.Cursor := crDefault; Exit; end;
     end;
   end;
  end;
  Screen.Cursor := crDefault;
end;


procedure TAnalyseT1_2026.PrintLetter(LetterName:String;RetFlName:String);
Var RetNo:Integer;
begin
  RetNo:=ReadReturn(DataDirBox.Text,RetFlName);
  if RetNo > 0 then
  begin
      CalcAll(RetNo);
      Calc(Retno,'GSTC');
      SomeLetterName:=LetterName;
      MainFormT1.StartPrintForm(Retno,'ALETTER',99);
      if Printer.Printing then //20160905 Igor
        Printer.EndDoc; //20160905 Igor

      //PrintARichLetter(RetNo,AppDir+'\'+LetterName);
    RemoveReturnFromMemory(RetNo);
  end
  else
      ShowMessage('File: '+AppDir+'\'+RetFlName+' not found');
end;

procedure TAnalyseT1_2026.DataDirBoxExit(Sender: TObject);
begin
 OpenTheDataBase;
end;

Procedure TAnalyseT1_2026.OpenTheDataBase;
begin
  //20150826 IGOR
  SetTableName(FDConnection, Table1, DataDirBox.Text + '\' + ClientsDbLite, ClientsTableLite, '');
  Table1.Open; //20160422 Igor
end;

procedure TAnalyseT1_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If Key =#13 then
 begin
  OpenTheDataBase;
  FindBtnClick(Sender);
 end;
end;

procedure TAnalyseT1_2026.CreateEmailListBtnClick(Sender: TObject);
Var i:Integer; ClientFiles: TStringList;//FileNm:String;
begin
 If ListBox1.Items.Count =0 then exit;
 ClientFiles := TstringList.Create;
 For i := 0 to ListBox1.Items.Count-1 do
  ClientFiles.Add(AllTrim(MidStr(ListBox1.Items[i],17,15)));

 CreateEmailList(DataDirBox.Text,ClientFiles);
 ClientFiles.Free;
end;

procedure TAnalyseT1_2026.SendEmailbtnClick(Sender: TObject);
Var SomeSubject,SomeRecipientEMail,SomeSenderEMail,SomeAttachment:String;
SomeText:String;
i:Integer; h:THandle;
ClientFiles:TstringList;
begin
(*  seems very slow, unpredictable
 ClientFiles:=TStringList.Create;
 For i := 0 to ListBox1.Items.Count-1 do ClientFiles.Add(AllTrim(MidStr(ListBox1.Items[i],17,15)));

 For i:=0 to ClientFiles.count-1 do
 Begin
  SomeSubject:='Message from '+OptRec.Prp_Name;
  SomeRecipientEMail:=GetClientEmail(ClientFiles[i]);
  SomeSenderEmail:='';
  SomeAttachment:='';
  SomeText:=Chr(13)
           +Chr(13)+'Thank you '
           +Chr(13)+' '
           +Chr(13)+OptRec.Prp_Name
           +Chr(13)+' ('+OptRec.Prp_Area+') '+OptRec.Prp_Tel;

  SomeText:= SomeText + '%0D%0A'; //20111113 //%0D%0A is hex for 10 (linefeed) and 13 (carriage return)
  If SomeRecipientEMail>'' then
  Begin
   h:=ShellExecute(MainForm.Handle,nil,Pchar(''+ 'mailto:'+ SomeRecipientEMail +'?Subject='+SomeSubject + '&Body=' + SomeText), nil, nil, SW_NORMAL);
   If h<=32 then begin ShowMessage('Operation failed');end;
  end;
 End;
 ClientFiles.Free;
*)
end;

procedure TAnalyseT1_2026.OpenReturnBtnClick(Sender: TObject);
Var
  FormName, FlName, FullFlName:String;Sin:String;
  RetNo, FormNo:Integer; Result:Integer;
begin
 If listbox1.itemIndex>-1 then
 begin
  flName:=AllTrim(MidStr(ListBox1.items[ListBox1.ItemIndex],17,12));
  If flName>'' then
  Begin
   FullflName:=DataDirBox.text+'\'+FlName;
   If IsOkToOpenReturn(ExtractFileDir(FullFlName),FlName,Sin) = False then Exit;
   RetNo:= OpenReturn(ExtractFileDir(FullFlName),FlName,True);
   If RetNo > 0 then
   begin
    //LockWindowUpdate(MainForm.Handle); - unlock where?
    CountDiagnostics(RetNo);
    //MainForm.LeftPanel.Visible:=True;
    MainForm.GuiCommand(gcShowLeftPanel); //20160220 Igor
    FormName := 'INFO';
    FormNo := GetFormNo(FormName);
    OpenForm(RetNo,FormNo,0);
    OpenUsedForms(RetNo);
    MainForm.FormPaint(Application);
    If Ret[RetNo].FormHasData['FAMSET'] then
    begin
      if MessageDlg('Last time it was processed as Family'+
        Chr(13)+'Process as Family again?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        DoCoupling(RetNo);
      end;
    end
   end
   else
   begin
    ShowOpenReturnFailure(Result,ExtractFileDir(FullFlName),
       ExtractFileName(FullFlName));
    exit;
   end;
   MainForm.RefreshAuditPanel(RetNo); //If AuditPanel.Visible then RefreshAuditPanel;
   If MainForm.FormsPanel.Visible then MainForm.RefreshFormsPanel(RetNo);
 end;
 end;
end;


procedure TAnalyseT1_2026.ListBox1DblClick(Sender: TObject);
begin
 OpenReturnBtnClick(Sender);
end;

end.
