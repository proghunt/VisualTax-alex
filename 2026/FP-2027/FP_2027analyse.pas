unit FP_2027analyse;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,DB,StdCtrls,ExtCtrls,Buttons,Grids,DBGrids,
  FP_2027Declare,DBCtrls,ComCtrls, uADStanIntf, uADStanOption, uADStanError,
  uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient,

  rxRichEd; //20160819 Igor (Must be last)

type
  TAnalyseFP_2012 = class(TForm)
    Panel1: TPanel;
    DataSource1: TDataSource;
    Label12: TLabel;
    CountBox: TLabel;
    Panel3: TPanel;
    PrintListBtn: TBitBtn;
    PrintLabelsBtn: TBitBtn;
    Panel4: TPanel;
    PrintLetterBtn: TBitBtn;
    CancelBtn: TBitBtn;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Label11: TLabel;
    Panel2: TPanel;
    ListBox1: TListBox;
    SaveBtn: TBitBtn;
    OpenBtn: TBitBtn;
    ClearListBtn: TButton;
    ManualBtn: TButton;
    FileListBox1: TFileListBox;
    DesignBtn: TBitBtn;
    RichEdit1: TRichEdit;
    Memo1: TMemo;
    SelectGroup: TRadioGroup;
    FindBtn: TBitBtn;
    DBGrid1: TDBGrid;
    Panel5: TPanel;
    SelectAllBtn: TBitBtn;
    SelectOneBtn: TBitBtn;
    FDConnection: TADConnection;
    Table1: TADTable;

    Procedure PrintARichLetter(LetterName:String);
    procedure PrintLetter(LetterName:String;RetFlName:String);
    Procedure PrepareLetter(RetNo:Integer;
            Var LetterLines:TStringList; Var WhichPage:integer);
    Function SelectLine:String;
    procedure CancelBtnClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintLabelsBtnClick(Sender: TObject);
    procedure PrintLetterBtnClick(Sender: TObject);
    procedure PrintListBtnClick(Sender: TObject);
    Function AnalyseReturn(FlName: string):integer;
    procedure FormPaint(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure ClearListBtnClick(Sender: TObject);
    procedure ManualBtnClick(Sender: TObject);
    procedure DesignBtnClick(Sender: TObject);
    procedure SelectAllBtnClick(Sender: TObject);
    procedure SelectOneBtnClick(Sender: TObject);

  private
    { Private declarations }
  public
    RetNo: integer;
  end;

var
  Analyse: TAnalyseFP_2012;
  LastFirstName : string; //[45];
  FlName : string; //[10];
  MxLength :integer; {for LastFirstName on the listbox}

implementation

{$R *.DFM}

uses vtCommon,vtDialogs,FP_2027,FP_2027TrimStr,FP_2027Common,FP_2027Common2,
     FP_2027GetFile,FP_2027PopList,FP_2027Calc,FP_2027Main
   , vtTrimStr, vtShared, vtDataBase;

procedure TAnalyseFP_2012.CancelBtnClick(Sender: TObject);
begin
 Table1.Close;
 Close;
end;

procedure TAnalyseFP_2012.FindBtnClick(Sender: TObject);
Var Result, I : Integer;
begin
  If ListBox1.Items.Count >0 then
     if MessageDlg('Clear existing list first?',
        mtInformation, [mbYes, mbNo], 0) = mrYes then
        ListBox1.Clear;
  CountBox.Caption := IntToStr(ListBox1.Items.Count);
  Table1.First;
  while not Table1.EOF do
   begin
    FlName := Table1.FieldByName('ClientId').AsString;
    LastFirstName := Rtrim(Table1.FieldByName('LastName').AsString)+
       ' '+LeftStr(Table1.FieldByName('FirstName').AsString,1)+'.';
    If SelectGroup.ItemIndex =1 then
    begin
      ListBox1.Items.Add(PaddR(LastFirstName,MxLength)+'-'+FlName);
      CountBox.Caption := IntToStr(ListBox1.Items.Count);
    end
    else
    begin
      Screen.Cursor := crHourGlass;
      result := AnalyseReturn(FlName);
      If result <> 0 then
        ShowMessage('Client not found');
        {ShowOpenReturnFailure(Result,DataDirBox.Text,FlName);}
    end;
    Table1.Next;
   end;
   Screen.Cursor := crDefault;
   Refresh;
end;

procedure TAnalyseFP_2012.FormCreate(Sender: TObject);
begin
  RetNo := GetCurrentRetNo;
MxLength :=15;
{
FormTitle.Caption := SomeCaption;
Analyse.Caption := SomeCaption;
}
SelectGroup.ItemIndex := 0;

  //20150920 Igor
  SetTableName(FDConnection, Table1, AppDir + '\' + ClientsDBLite, ClientsTableLite, '');

FileListBox1.Directory := AppDir;
FileListBox1.Mask := '*.Ltr';
FileListBox1.ItemIndex :=0;
end;

procedure TAnalyseFP_2012.PrintLabelsBtnClick(Sender: TObject);
begin
If ListBox1.Items.Count =0 then exit;
ShowMessage('Not available in this Demo');
{better disable button if list is empty}
{Use Crystal reports if possible}
{input is the displayed list}
end;

procedure TAnalyseFP_2012.PrintLetterBtnClick(Sender: TObject);
Var i:Integer;
begin

  If FileListBox1.ItemIndex<0 then
   begin
    ShowMessage('You must select a letter first');
    exit;
   end;
  Screen.Cursor := crHourGlass;
  For i:=0 to ListBox1.Items.Count-1 do
   PrintLetter(FileListBox1.Items[FileListBox1.ItemIndex],
    AllTrim(MidStr(ListBox1.Items[i],MxLength+2,12)));
  Screen.Cursor := crDefault;
end;

procedure TAnalyseFP_2012.PrintLetter(LetterName:String;RetFlName:String);
begin
(*
  InitNewReturn(RetNo);
  if ReadReturn(RetNo,DataDirBox.Text,RetFlName) =0 then
    begin
      LetterType := 'Other';
      CalcAll(RetNo);
      PrintARichLetter(LetterName);
    end
    else
      ShowMessage('File: '+AppDir+'\'+RetFlName+' not found');
    RemoveReturnFromMemory(RetNo);
 *)
end;

(*
procedure TAnalyse.PrintLetter(LetterName:String);
Var I,j:integer;
LetterLines : TStringList;
WhichPage:integer;
begin
   If ListBox1.Items.Count =0 then exit;
   LetterLines := TStringList.Create;
   For i :=0 to ListBox1.Items.Count-1 do
   begin
       LetterLines.LoadFromFile(AppDir+'\'+LetterName);
       If AbortSw then begin LetterLines.Free;AbortSw:=False;exit;end;
       FlName := AllTrim(MidStr(ListBox1.Items[i],MxLength+2,12));  {sin with dot }
       InitNewReturn(RetNo);
       if ReadReturn(RetNo,DataDirBox.Text,FlName) =0 then
        begin
         LetterType := 'Other';
         PrepareLetter(RetNo,LetterLines,WhichPage);
         MainForm.StartPrintForm(RetNo,'LETR_1',WhichPage);
        end
        else
         ShowMessage('File: '+AppDir+'\'+FlName+' not found');

        RemoveReturnFromMemory(RetNo);
        LetterLines.Clear;
   end; {for i..}
   LetterLines.Free;
end;
*)
Procedure TAnalyseFP_2012.PrepareLetter(RetNo:Integer;
 Var LetterLines:TStringList; Var WhichPage:integer);
Var I,LinesInPage1,FNo,MaxLinesInPage:integer;Txt:Ansistring;
begin
  LoadDataDict;
  For i :=0 to LetterLines.Count-1 do
  begin
       txt := LetterLines[i];
       InterpretTextLine(txt);
       LetterLines[i] := txt; {put it back}
  end;
  ResolveConditions(LetterLines);  {second pass}
  ExpandTabs(LetterLines);
  AllowLinesForLogo(LetterLines);

  MaxLinesInPage := 59;
  If LetterLines.Count >MaxLinesInPage then
    begin
     LinesInPage1:=MaxLinesInPage;WhichPage :=99;{all}
    end
  else
    begin
     LinesInPage1:=LetterLines.Count;WhichPage:=1;
    end;

  InitFormData(RetNo,GetFormNo('LETR_1'));
  InitFormData(RetNo,GetFormNo('LETR_2'));
  ClearForm(RetNo,'LETR_1');
  ClearForm(RetNo,'LETR_2');
  for i:=0 to LinesInPage1-1 do
    Ret[RetNo].Frm[GetFormNo('LETR_1')].Strings[i+1] := LetterLines[i];
  for i:=LinesInPage1 to LetterLines.Count-1 do
     Ret[RetNo].Frm[GetFormNo('LETR_2')].Strings[i-MaxLinesInPage+1] := LetterLines[i];
end;

procedure TAnalyseFP_2012.PrintListBtnClick(Sender: TObject);
begin
If ListBox1.Items.Count =0 then exit;
ShowMessage('Not available in this Demo');
{Use Crystal reports if possible}
{input is the displayed list}
end;

Function TAnalyseFP_2012.AnalyseReturn(FlName: string):integer;
var
  i,j,k,FNo, SNo, BxNo : integer;
  Qualif1,Qualif2,Qualif3 : boolean; {one for each condition}
  F1: TextFile;
  Ndx : Array[1..3] of byte;
  S : string; //[16];
  InputLin,Var1,Var2,Var3,Var4 : String;
begin
 (*
    Result := 0;
    Qualif1 := False;Qualif2 := False;Qualif3 := False;
    if FileExists(DataDir+'\'+FlName) = false then
     begin  result := -1; exit; end;
    AssignFile(F1, DataDir + '\'+ FlName);
    ReSet(F1);
    Readln(F1, InputLin);
    {Break up into variables}
    j := 0;
    for i :=1 to Length(InputLin) do
     begin
     if InputLin[i] = Delimiter then begin inc(j);ndx[j] :=i; end;
     end;
    Var1 := Copy(InputLin,1,Ndx[1]-1);
    Var2 := Copy(InputLin,Ndx[1]+1,Ndx[2]-Ndx[1]-1);
    Var3 := Copy(InputLin,Ndx[2]+1,Ndx[3]-Ndx[2]-1);
    Var4 := Copy(InputLin,Ndx[3]+1,255);
    If Var1 <> AppName then
     begin Result := -2; CloseFile(F1); exit; end;

    While not EOF(F1) do
    begin
       Readln(F1, InputLin);
      {break it}
       j := 0;
       for i :=1 to Length(InputLin) do
       begin
         if InputLin[i] = Delimiter then begin inc(j);ndx[j] :=i; end;
       end;
       Var1 := Copy(InputLin,1,Ndx[1]-1);
       Var2 := Copy(InputLin,Ndx[1]+1,Ndx[2]-Ndx[1]-1);
       Var3 := Copy(InputLin,Ndx[2]+1,Ndx[3]-Ndx[2]-1);
       Var4 := Copy(InputLin,Ndx[3]+1,255);

       if Var1 = 'L' then
       begin
         If (Vl(Var2) = Vl(LineBox1.Text)) and
           (Vl(Var3) > Vl(AmountBox1.Text))
          then Qualif1 := True;
         If (Vl(Var2) = Vl(LineBox2.Text)) and
           (Vl(Var3) > Vl(AmountBox2.Text))
          then Qualif2 := True;
         If (Vl(Var2) = Vl(LineBox3.Text)) and
           (Vl(Var3) < Vl(AmountBox3.Text))
          then Qualif3 := True;
      end;
    end;
    If Vl(LineBox1.Text) =0 then Qualif1 := True;
    If Vl(LineBox2.Text) =0 then Qualif2 := True;
    If Vl(LineBox3.Text) =0 then Qualif3 := True;

    If Qualif1 and Qualif2 and Qualif3 then
      ListBox1.Items.Add(PaddR(LastFirstName,MxLength)+'-'+FlName);
    CloseFile(F1);
    CountBox.Caption := IntToStr(ListBox1.Items.Count);
 *)
end;


procedure TAnalyseFP_2012.FormPaint(Sender: TObject);
begin
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

procedure TAnalyseFP_2012.OpenBtnClick(Sender: TObject);
Var TempList :TstringList;
I,j :integer;
begin
  TempList := TStringList.Create;
  (*
  If ListBox1.Items.Count >0 then
   if MessageDlg('Add to the existing list?',
       mtInformation, [mbYes, mbNo], 0) = mrNo then ListBox1.Clear;
   *)
  SomeList.Clear; // := TstringList.Create;
  SomeCaption := 'Select File(s)';
  {'Text Files (*.Txt)|*.Txt|All files (*)|*.*'}
  SomeFilter := 'Text Files (*.T1X)|All Files (*.*)';
  SomeFileMask := '*.T1X';

  Application.CreateForm(TgetfileFP_2012,GetFile);
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
  SomeList.Clear; 
  //SomeList.Free; //20160704 Igor
  TempList.Free;
  Refresh;
end;

procedure TAnalyseFP_2012.SaveBtnClick(Sender: TObject);
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

procedure TAnalyseFP_2012.ClearListBtnClick(Sender: TObject);
begin
ListBox1.Clear;
CountBox.Caption := IntToStr(ListBox1.Items.Count);
Refresh;
end;

procedure TAnalyseFP_2012.ManualBtnClick(Sender: TObject);
var
  FlName,s:string;
begin
  s:='';
  FlName:= InputBox(
    'Enter File Name (SIN)', 'SIN: (as 99999999.9)', '');
  If FlName ='' then exit;

  {
  if FileExists(DataDirbox.text+'\'+FlName) = false then
    ShowMessage('File does not exist in specified directory')
  else
  }
    ListBox1.Items.Add(PaddR(s,MxLength)+'-'+FlName);
  Refresh;
end;

Function TAnalyseFP_2012.SelectLine:String;
begin
 SomeCaption := 'Select a Line';
 PopSomeFile(AppDir+'\'+'Lines.d',SomeCaption);
end;

procedure TAnalyseFP_2012.DesignBtnClick(Sender: TObject);
begin
MainFormFP.ClientLetter1Click(Sender);
{
FileListBox1.Mask := '*.Ltr';
FileListBox1.ItemIndex :=0;
}
FileListBox1.Update;
end;


Procedure TAnalyseFP_2012.PrintARichLetter(LetterName:String);
Var i,j:integer; ErrorC : boolean;txt :Ansistring; //[255];
   AList: TstringList;
   TempFileName :String;
Begin
 TempFileName := AppDir+'\'+'Temp.rtf'; //20160819 Igor
 If RetNo < 1 then exit;
 AList := TstringList.Create;
 Memo1.Lines.LoadFromFile(LetterName);
 {Copy memo to AList}
 For i:=0 to Memo1.Lines.Count-1 do
    AList.Add(Memo1.Lines[i]);

 LoadDataDict;
 Memo1.Clear;
 For i :=0 to AList.Count-1 do {first pass:conditions stay in}
   begin
    txt :=AList[i];
    InterpretTextLine(txt);
    AList[i] :=txt;
   end;

  ResolveConditions(AList);
  For i :=0 to AList.Count-1 do
   Memo1.Lines.Add(AList[i]);

  Memo1.Lines.SaveToFile(TempFileName);
  RichEdit1.Clear;
  RichEdit1.Lines.LoadFromFile(TempFileName);
  RichEdit1.Print(TempFileName);
  AList.Free;
end;

procedure TAnalyseFP_2012.SelectAllBtnClick(Sender: TObject);
Var FlName : string; //[20];
begin
  If ListBox1.Items.Count >0 then
    if MessageDlg('Clear existing list first?',
        mtInformation, [mbYes, mbNo], 0) = mrYes then
        ListBox1.Clear;

  With Table1 do
  begin
   First;
   Repeat
    FlName :=FieldByName('ClientId').AsString;
    LastFirstName := Rtrim(FieldByName('LastName').AsString)+
       ' '+LeftStr(FieldByName('FirstName').AsString,1)+'.';
    ListBox1.Items.Add(PaddR(LastFirstName,MxLength)+'-'+FlName);
    Next;
   until EoF;
  end;
  CountBox.Caption := IntToStr(ListBox1.Items.Count);
end;

procedure TAnalyseFP_2012.SelectOneBtnClick(Sender: TObject);
Var FlName:String;
begin
 With Table1 do
  begin
  Try
   FlName :=FieldByName('ClientId').AsString;
   LastFirstName := Rtrim(FieldByName('LastName').AsString)+
         ' '+LeftStr(FieldByName('FirstName').AsString,1)+'.';
   ListBox1.Items.Add(PaddR(LastFirstName,MxLength)+'-'+FlName);
  except
   on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
  end;
 end;
end;

end.
