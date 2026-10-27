unit T1_2026fees;
//updated 07-28

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons,DB,Grids,DBGrids,ExtCtrls,DBCtrls,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

type
  TFeesT1_2026 = class(TForm)
    FDConnection: TADConnection;
    DataSource1: TDataSource;
    Table1: TADTable;
    Table1FORMNAME: TStringField;
    Table1FEE: TStringField;
    PrintDialog1: TPrintDialog;
    Panel2: TPanel;
    TextRelatedPanel: TPanel;
    Label2: TLabel;
    ImportBtn: TBitBtn;
    ExportBtn: TBitBtn;
    FlBox: TEdit;
    PrintBtn: TBitBtn;
    SavePanel: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Table1EACH_ITEM: TStringField;
    Table1ADDNLFORM: TStringField;
    Table1FORMABREV: TStringField;
    Table1HOWCHARGED: TStringField;
    SortPanel: TPanel;
    SortBy: TRadioGroup;
    GetSampleBtn: TBitBtn;
    GetHelpBtn: TBitBtn;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    FootNotesPanel: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    EditBoxBtn: TBitBtn;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure SortByClick(Sender: TObject);
    procedure ExportBtnClick(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure GetHelpBtnClick(Sender: TObject);
    Function  PostTxtFeesToDB(FlName:String):Boolean;
    procedure SaveToTxt(FlName:String);
    procedure GetSampleBtnClick(Sender: TObject);
  //  procedure ConvertOldFees(File1,File2:String);
    procedure EditBoxBtnClick(Sender: TObject);
    Procedure UpdateFeesDbfWithNewForms;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Fees: TFeesT1_2026;

implementation

{$R *.DFM}

uses ShellApi,vtMulti,vtCommon,vtDialogs,T1_2026,T1_2026Declare,T1_2026Common,
  T1_2026TrimStr,T1_2026T1Rtns,T1_2026T1Rtns2,T1_2026CALC,T1_2026ChildWinNew,
  vtTrimStr, vtShared, vtDataBase;

procedure TFeesT1_2026.CancelBtnClick(Sender: TObject);
begin
 Table1.Close;
 InitFeesTable;  //20110407
Close;

end;

procedure TFeesT1_2026.FormCreate(Sender: TObject);
begin
  UpdateFeesDbfWithnewForms;   //20130208

  FlBox.Text := AppDir+'\'+'Fees-'+AppYear+'.Txt';

  //20150915 Igor
  SetTableName(FDConnection, Table1, AppDir + '\' + FormsFeesDBLite, FormsFeesTableLite, '');

  SortBy.ItemIndex :=0;
  SortByClick(Sender);
  Table1.Open;
  Table1.Edit;
  Table1.First;
 //end;
end;

procedure TFeesT1_2026.OKBtnClick(Sender: TObject);
Var RNo:Integer;
begin
 Table1.Edit;
 Table1.Post;
 Flist.Clear;
 // also save it to TXT
 SaveToTxt(AppDir+'\'+FlBox.text);
 InitFormsTable; {reinit the form specs}  //20090215
 InitFeesTable;  //20110407
 ShowTimedMsg('Done',1500);
 If RetInMem>0 then
 begin
  RNo:=GetCurrentRetNo; //20110107
  If RNo>0 then Calc(RNo,'INVFORMS');  //20110315
  If RNo>0 then OpenForm(RNo,'INVFORMS',0);
 end;
end;

procedure TFeesT1_2026.SortByClick(Sender: TObject);
begin
 Case SortBy.ItemIndex of
 0: Table1.IndexName := UpperCase ('FormName'); // 20150920 Igor
 1: Table1.IndexName := UpperCase ('Fee');      // 20150920 Igor
 else
 Table1.IndexName := UpperCase ('FormName'); // 20150920 Igor
 end;
If Table1.Active then Table1.First;
end;

procedure TFeesT1_2026.ExportBtnClick(Sender: TObject);
Begin
 If not DirectoryExists(ExtractFilePath(FlBox.Text)) then
 begin
  ShowMessage('Path does not exist');
  FlBox.SetFocus;
  exit;
 end;
 SaveToTxt(FlBox.Text);
 ShowMessage('Done');
end;

procedure TFeesT1_2026.SaveToTxt(FlName:String);
Var 
  ListNdx:integer;
  Templist:TStringList; 
  S,S1,S2,S3,S4,S5,s6:string;
begin
  //LockWindowUpdate(Handle); //20160819 Igor
  Table1.disableControls; //20160819 Igor
  try
    TempList := TstringList.Create;
    TempList.Sorted := True;
    Table1.First;
    while not Table1.EOF do
    begin
      If (Table1.FieldByName('Fee').AsString > '')
         or 
         (Table1.FieldByName('EACH_ITEM').AsString > '') then
      begin
        S1:=Table1.FieldByName('FormName').AsString;
        S2 :=Table1.FieldByName('FormAbrev').AsString;  //20110129
        s3 :=Table1.FieldByName('HOWCHARGED').AsString;
        s4 :=Table1.FieldByName('Fee').AsString;
        s5 :=Table1.FieldByName('AddnlForm').AsString;
        s6 :=Table1.FieldByName('Each_item').AsString;
        s :=PaddR(s1,8)
           +PaddR(s2,30)
           +PaddR(s3,20)
           +PaddR(s4,7)
           +PaddR(s5,7)
           +PaddR(s6,7);

        TempList.Add(s);
      end;
      Table1.Next;
    end;
    TempList.SaveToFile(FlBox.Text);
    TempList.Free;
    Table1.First;
  finally
    Table1.EnableControls; //20160819 Igor
    //LockWindowUpdate(0); //20160819 Igor
  end;
end;


procedure TFeesT1_2026.ImportBtnClick(Sender: TObject);
begin
 If PostTxtFeesToDB(FlBox.Text)= True then
 begin
  ShowMessage('Fees imported');
 end
 else
  ShowMessage('Import Fees Failed');
end;

Function TFeesT1_2026.PostTxtFeesToDB(flName:String):Boolean;
Var 
  i:integer;
  Templist:TStringList;
  FrmNm,FrmFee,FrmAddnlForm,FrmEachItem : String;
begin
  Result:=False;
  If not FileExists(FlName) then
  begin
    ShowMessage('Fees directory or file does not exist');
    exit;
  end;
  Screen.Cursor := crHourGlass;
  TempList := TstringList.Create;
  try //20160819 Igor
    TempList.LoadFromFile(FlName);

    //20150915 Igor
    SetTableName(FDConnection, Table1, AppDir + '\' + FormsFeesDBLite, FormsFeesTableLite, 'FORMNAME');

    For i:=0 to TempList.Count-1 do
    begin
      FrmNm     := AllTrim(LeftStr(TempList[i],8)); //marc h 6 2008
      FrmFee    := AllTrim(MidStr(TempList[i],59,7));
      FrmAddnlForm:=AllTrim(MidStr(TempList[i],66,7));
      FrmEachItem:=AllTrim(MidStr(TempList[i],73,7));
      if Table1.FindKey([FrmNm]) then
      begin
        Table1.Edit;
        Table1.FieldByName('Fee').AsString := Alltrim(FrmFee);
        Table1.FieldByName('AddnlForm').AsString := Alltrim(FrmAddnlForm);
        Table1.FieldByName('Each_item').AsString := Alltrim(FrmEachItem);
        Table1.Post;
      end
      //else
      //ShowMessage('Form '+FrmNm+' not found on data base')  //20130209
      ;
   end;
   InitFormsTable;
   Table1.IndexName := UpperCase ('FormName'); // 20150920 Igor
   SortBy.ItemIndex :=0;
   Table1.First;
   Result:=True;
 finally //20160819 Igor
   TempList.Free;
   Screen.Cursor := crDefault;
 end;
end;

procedure TFeesT1_2026.PrintBtnClick(Sender: TObject);
Var i:integer;FileNm,Hdr1,Hdr2,Hdr3:string; F1:textFile; S:string;
TempList1,TempList2:TstringList;
begin
 FileNm := FlBox.Text;
 If not fileExists(FlBox.Text) then
 begin
   ShowMessage('Fee Schedule '+FlBox.Text +'  file does not exist');
   exit;
 end;

 Hdr1 := PaddR('FEE SCHEDULE - File Name:',30)+
         PaddR(UpperCase(FlBox.Text),30)+PaddR(DateToMonthDayYear(Date),20);
 Hdr2 := PaddR('FORM',8)
         +PaddR('DESCRIPTION',30)+'   '
         +PaddR('How Charged',18)
         +PaddR('1stForm',8)
         +PaddR('+More',7)
         +PaddR('PerItem',8);
         Hdr3 := FilledStr(81,'=');

 TempList1:=TStringList.Create;
 TempList2:=TStringList.Create;
 TempList1.LoadFromFile(FlBox.Text);
 For i:=0 to templist1.count-1 do
 begin
  s:=LeftStr(TempList1[i],38)+'  '+MidStr(TempList1[i],39,50);
  TempList2.Add(S);
 end;
 TempList2.SaveToFile(AppDir+'\'+'Temp.txt');
 TempList1.Free;
 TempList2.Free;

 If PrintDialog1.Execute then
 begin
  If PrintAListing(AppDir+'\'+'Temp.txt',Hdr1,Hdr2,Hdr3) = True then
   ShowMessage('Printing Completed');
 end;

end;

procedure TFeesT1_2026.GetHelpBtnClick(Sender: TObject);
begin
ShowHelp('T1Help','Fee_schedule');
end;

//20160821
procedure TFeesT1_2026.GetSampleBtnClick(Sender: TObject);
Var File1:String;
begin
 if MessageDlg('Are you sure?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
 begin
  Exit;
 end;
 If FileExists(Appdir+'\'+'Fees.d') then
  FlBox.Text:=Appdir+'\'+'Fees.d'
 Else
 begin
  ShowMessage('File '+FlBox.text+ ' not found');
 end;

 If PostTxtFeesToDB(FlBox.Text)= True then
 begin
  ShowMessage('Sample Fees imported');
  CopyFile(FlBox.Text,AppDir+'\'+'Fees.txt');
 end
 else
  ShowMessage('Import Fees Failed');

 FlBox.Text:=AppDir+'\'+'Fees.txt';
 SortBy.ItemIndex:=1;
end;
(*  20160821
procedure TFeesT1_2026.GetSampleBtnClick(Sender: TObject);
Var File1:String;
begin
 if MessageDlg('Are you sure?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
 begin
  Exit;
 end;
 If FileExists(Appdir+'\'+'Fees-'+AppYear+'.d') then
  FlBox.Text:=Appdir+'\'+'Fees-'+AppYear+'.d'
 else
  FlBox.Text:=AppDir+'\'+'Fees-'+AppYear+'.d';

 If PostTxtFeesToDB(FlBox.Text)= True then
 begin
  ShowMessage('Sample Fees imported');
  CopyFile(FlBox.Text,AppDir+'\'+'Fees-'+AppYear+'.txt');
 end
 else
  ShowMessage('Import Fees Failed');

 FlBox.Text:=AppDir+'\'+'Fees-'+AppYear+'.txt';
 SortBy.ItemIndex:=1;
end;
*)
(*
procedure TFees.ConvertOldFees(File1,File2:String);
Var i:Integer;Temp1,Temp2:TStringList; s,FrmNm,Descr,Fee,AddnlForm:String;
begin
 Temp1:=TStringList.Create;
 Temp2:=TStringList.Create;
 Temp1.LoadFromFile(File1);
 For i:=0 to Temp1.count-1 do
 begin
  FrmNm:=LeftStr(Temp1[i],8);
  Descr:=MidStr(Temp1[i],23,40);
  Fee:=MidStr(Temp1[i],9,7);
  AddnlForm:=MidStr(Temp1[i],16,7);

  s :=PaddR(FrmNm,8)
      +PaddR(Descr,30)
      +PaddR('Per Form',20)
      +PaddR(Fee,7)
      +PaddR(AddnlForm,7)
      +PaddR(' ',7);

  Temp2.Add(S);
 end;
 Temp2.SaveToFile(File2);
 SysUtils.DeleteFile(File1);
 CopyFile(File2,AppDir+'\'+'Fees-2008.txt');
 Temp1.Free;
 Temp2.Free;
 ShowMessage('Done');
end;
*)

procedure TFeesT1_2026.EditBoxBtnClick(Sender: TObject);
Var  h : Thandle;
FileName:String;
PFlName:PChar;
begin
 FileName:= flBox.Text;  //20130208
 pFlName:=Pchar(AppDir+'\'+FileName);
 h:=ShellExecute(Application.Handle,'open','c:\windows\notepad.exe',PFlName,nil,SW_SHOWNORMAL);
end;

Procedure TFeesT1_2026.UpdateFeesDbfWithnewForms;     //20130208
Var HighestFNo:Integer;FrmNm:String;
  ADConnection: TADConnection;
  Tbl:TADTable;
  ScrADConnection: TADConnection;
  ScrTbl: TADTable;
begin
  //open t1fees table
  //20150915 Igor
  ADConnection:= TADConnection.Create(Application);
  Tbl := TADTable.Create(Application);
  SetTableName(ADConnection, Tbl, AppDir + '\' + FormsFeesDBLite, FormsFeesTableLite, 'FORMNAME');

  //20150915 Igor
  ScrADConnection:= TADConnection.Create(Application);
  ScrTbl:= TADTable.Create(Application);
  SetTableName(ScrADConnection, ScrTbl, AppDir + '\' + FormsDBLite, FormsTableLite, 'FORMNAME'); //20160819 Igor

  //now find forms in SCR but not in T1Fees and add them
  ScrTbl.First;
  while not ScrTbl.EOF do
  begin
   FrmNm     := UpperCase(ScrTbl.FieldByName('FormName').AsString);
  // If frmNm='PTRANSIT' then ShowMessage('PTransit');
   if Tbl.FindKey([FrmNm]) = false then  //it is not in T1Fees
   begin
     Tbl.Insert;
     Tbl.FieldByName('FormNo').AsInteger := ScrTbl.FieldByName('FormNo').AsInteger;//HighestFNo+1;
     Tbl.FieldByName('FormName').AsString := FrmNm;
     Tbl.FieldByName('FormAbrev').AsString := ScrTbl.FieldByName('FormAbrev').AsString;
     Tbl.FieldByName('FormRlNm').AsString := ScrTbl.FieldByName('FormRlNm').AsString;
     Tbl.FieldByName('HowCharged').AsString :='';
     Tbl.FieldByName('Fee').AsString :='';
     Tbl.FieldByName('AddnlForm').AsString := '';
     Tbl.FieldByName('Each_item').AsString := '';
     Tbl.Post;
   end
   Else  //found
   Begin
    Tbl.Edit;
    Tbl.FieldByName('FormNo').AsInteger := ScrTbl.FieldByName('FormNo').AsInteger;//HighestFNo+1;
    Tbl.FieldByName('FormAbrev').AsString := ScrTbl.FieldByName('FormAbrev').AsString;
    Tbl.FieldByName('FormRlNm').AsString := ScrTbl.FieldByName('FormRlNm').AsString;
    Tbl.FieldByName('FormType').AsString := ScrTbl.FieldByName('FormType').AsString;
    Tbl.FieldByName('CraForm').AsString := ScrTbl.FieldByName('CRAForm').AsString;
    Tbl.Post;
   end;
   ScrTbl.Next;
  end;

  ScrTbl.Close; ScrTbl.free;
  ScrADConnection.Free;
  Tbl.Close;Tbl.Free;
  ADConnection.Free;
end;

end.
