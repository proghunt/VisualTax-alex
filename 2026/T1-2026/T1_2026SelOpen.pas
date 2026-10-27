unit T1_2026SelOpen;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB, DBTables, Mask, ExtCtrls,FileCtrl,
  Grids, Dialogs,DBGrids, Buttons,Menus, uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf,
  uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync, uADPhysManager,
  uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet,
  uADCompClient;


type
  TSelOpenT1_2026 = class(TForm)
    DataSource1: TDataSource;
    Panel4: TPanel;
    CancelBtn: TBitBtn;
    RadioGroup1: TRadioGroup;
    OpenDialog1: TOpenDialog;
    OpenBtn: TBitBtn;
    PrintBtn: TBitBtn;
    PrintDialog1: TPrintDialog;
    CopyBtn: TBitBtn;
    Panel2: TPanel;
    Panel1: TPanel;
    Label1: TLabel;
    DataDirBox: TEdit;
    Panel3: TPanel;
    AutoLbl: TLabel;
    DBGrid1: TDBGrid;
    SelectCurBtn: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    FDConnection: TADConnection;
    Query1: TADQuery;
    procedure CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FilterBoxChange(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    Procedure RefreshScreen(FilterDescr: string);
    Function  OpenQuery(DBName: string;QryName: string): boolean;
    Function  MkSelectedStr: String;
    procedure RadioGroup1Click(Sender: TObject);
    Function  DoOperation(Operation: string): boolean;
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure OpenBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    Function  OpenByCategory(Category:String):Boolean;
    procedure SelectCurBtnClick(Sender: TObject);
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
  private
    { private declarations }
    Category: string; //20170322 Igor
  public
    { public declarations }
    ShowSw: boolean; //to be set before ShowModal
  end;

var
  SelOpen: TSelOpenT1_2026;
 // RetNo:Integer;
  PrintTemplate : string[20];
  DestinationDir : String[50];
  FilterDescr   :String[40];
implementation

{$R *.DFM}
uses
 vtMulti,vtCommon,vtMain,vtDialogs,T1_2026,T1_2026Declare,T1_2026TrimStr,
  T1_2026ChildWinNEW,T1_2026RTU,T1_2026Common,T1_2026Common2,T1_2026T1Rtns,
  T1_2026T1Rtns2,T1_2026Features,T1_2026CntErr,T1_2026Cpl,T1_2026Main,
  T1_2026SQlFilt,vtTrimStr,vtShared,
  vtDataBase;



procedure TSelOpenT1_2026.CancelClick(Sender: TObject);
begin
  Close;
end;


Procedure TSelOpenT1_2026.RefreshScreen(FilterDescr: string);
begin
  AutoLbl.Caption :=
    '('+FilterDescr+')'+'  No. of returns: '+IntToStr(Query1.RecordCount);
  AutoLbl.Refresh;
end;

Function TSelOpenT1_2026.OpenQuery(DBName: string;QryName: string): boolean;
begin
 try
   SqlLoadDBFromFile(FDConnection, Query1, DBName + '\' + ClientsDBLite, AppDir+'\'+QryName);//20150909 Igor
   Query1.Open;
   Query1.Last; //20160302 Igor
   Query1.First; //20160302 Igor
   Result:= True;
 except
 on EdataBaseError do Result := False; end;
end;

procedure TSelOpenT1_2026.FormCreate(Sender: TObject);
const
  separator = '====================';
var i : integer;
begin
  // RetNo:=GetCurrentRetNo;
  With RadioGroup1 do
  begin
    Items.Add('All');
    //20200217
    Items.Add('AuthRepAndNotAutoFilled');
    Items.Add('AuthRepDone');
    Items.Add('AuthRepNotDone');

    Items.Add(Separator);
    For i :=Low(PRPStatusDescr) to High(PRPStatusDescr) do
      Items.Add(PRPStatusDescr[i]);
    Items.Add(Separator);
    For i :=Low(EFStatusDescr) to High(EFStatusDescr) do
      Items.Add(EFStatusDescr[i]);
    Items.Add(Separator);
    Items.Add('Return Category...');
  end;
  {initialize other controls}
  DataDirBox.Text := OptRec.Dir_Cur;
  RadioGroup1.ItemIndex := 0; //14;  //20160107
  FilterDescr := RadioGroup1.Items[RadioGroup1.ItemIndex];
  AutoLbl.Caption := FilterDescr+' Count: '+IntToStr(Query1.RecordCount);
  OptRec.Dir_Cur := DataDirBox.Text;
  OpenQuery(DataDirBox.Text,GetQueryName(FilterDescr)+'.QRY');
  RefreshScreen(FilterDescr);
  Screen.Cursor := crDefault;
  //20171031 igor>>>
  if CheckIsCloud(true) then //20180503 Igor
  begin
    DataDirBox.Enabled := False;
    SelectCurBtn.Enabled := False;
  end;
  //20171031 igor<<<
end;

procedure TSelOpenT1_2026.CancelBtnClick(Sender: TObject);
begin
 Query1.Free;
 Screen.Cursor :=crDefault;
 Close;
end;

procedure TSelOpenT1_2026.DBGrid1DblClick(Sender: TObject);
begin
 OpenBtnClick(Application);
end;

Function TSelOpenT1_2026.MkSelectedStr: String;
Const
 PartNameLen = 14;
Var
 S : string[80];
begin
    Result :=
     LeftStr(Query1.FieldByName('Last_Name').AsString,PartNameLen)
     + ' ' +LeftStr(Query1.FieldByName('First_Name').AsString,1)
     + '.'
     + FilledStr(
       PartNameLen+3-Length(LeftStr(Query1.FieldByName('Last_Name').AsString,PartNameLen))
       + 1 + Length(LeftStr(Query1.FieldByName('First_Name').AsString,1))+1
       ,' ')
     + '\'+Query1.FieldByName('File_Name').AsString
end;

procedure TSelOpenT1_2026.FilterBoxChange(Sender: TObject);
var
 QueryName : String[30];
begin
 If FilterDescr = 'All' then QueryName := FilterDescr  //'All'
 //20160107
 Else If FilterDescr = 'AuthRepDone' then QueryName := FilterDescr
 Else If FilterDescr = 'AuthRepNotDone' then QueryName := FilterDescr

 else if RadioGroup1.Items[RadioGroup1.ItemIndex] = 'User Defined' then QueryName := 'User'
 else QueryName := GetQueryName(RadioGroup1.Items[RadioGroup1.ItemIndex]);
If QueryName >'' then
 If OpenQuery(DataDirBox.Text,QueryName+'.QRY') = False then
   begin
    ShowMessage('Cannot open data base');
    exit;
   end
 else
   RefreshScreen(FilterDescr);
end;


Function TSelOpenT1_2026.DoOperation(Operation: string): boolean;
Var
 i :integer; FlName : string[12];Template:string[12];
 FormsToPrint:TstringList;
begin
Result := False;

 If Operation = 'Open' then
 begin
 end;

{ ShowMessage('Done. Press any key');}
 Result := true;
end;

procedure TSelOpenT1_2026.DataDirBoxExit(Sender: TObject);
begin
If DataDirBox.Text = OptRec.Dir_Cur then exit;

//If LeftStr(LicenseLevel,8) = 'T1 Multi' then {try to ch dir}
If LicenseLevel in anyMulti then {try to ch dir}
begin
 If YouKnowTheAdminPassword = False then
 begin
  DataDirBox.Text := OptRec.Dir_Cur;
  exit;
 end;
end;

If (ChangeDataDir(DataDirBox.Text) = False)
 or (OpenQuery(DataDirBox.Text,'All.QRY') = False)
 then
  begin
   DataDirBox.Text := OptRec.Dir_Cur;
   DataDirBox.Refresh;
   exit;
  end
 else
   begin
    {
    If not AllowedToChangeDir then
    begin
     DataDirBox.Text := CfgRec.Dir_Cur;
     exit;
    end;
    }
    OptRec.Dir_Cur := DataDirBox.Text;
    RefreshScreen('All');
   end;
end;

procedure TSelOpenT1_2026.RadioGroup1Click(Sender: TObject);
var
  QueryName: String[30];
//  Category: String; //20170322 Igor
begin
  FilterDescr := RadioGroup1.Items[RadioGroup1.ItemIndex];

  If FilterDescr = 'Return Category...' then
  begin
    //20170322 Igor >>>
    if not InputQuery('Filter by Return Category',
                      'Enter the code you used as Category during Save As ("*" - any chars)', Category) then
      Exit;
    If OpenByCategory(Category) then
      RefreshScreen(FilterDescr);
    //20170322 Igor <<<
    Exit;
  end;

  QueryName := GetQueryName(RadioGroup1.Items[RadioGroup1.ItemIndex]);
  If QueryName >'' then
    If OpenQuery(DataDirBox.Text,QueryName+'.QRY') = False then
    begin
      ShowMessage('Cannot open data base');
      exit;
    end
  else
    RefreshScreen(FilterDescr);
end;

Function TSelOpenT1_2026.OpenByCategory(Category: String): Boolean; //20170322 Igor
Var
  Whereclause: String;
begin
  Result := False;
  try
    if not FDConnection.Connected then
      if not SetConnection(FDConnection, DataDirBox.Text + '\' + ClientsDbLite,
         AppT1_2026.ClientsDBLite) then
        Exit;
    Query1.Open('SELECT * FROM `' + ClientsTableLite + '` AS T ' +
      'WHERE lower(T.Category) like ' + QuotedStr(LowerCase(ReplaceStr(Category, '*', '%'))));
    Query1.FetchAll;
    Result:=True;
  except on E: EdataBaseError do
    begin
      MessageDlg('An error occurred while fetching clients from the database. Notify the developer.' + #13 +
                 'Error Message: ' + E.Message,
        mtError, [mbOk], 0);
      RadioGroup1.ItemIndex := 0;
      Result:=False;
    end;
  end;
end;

procedure TSelOpenT1_2026.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
if key = #32 then
begin
 DBGrid1DblClick(Application);
 Query1.Next;
end;
end;


procedure TSelOpenT1_2026.OpenBtnClick(Sender: TObject);
Begin
FlName:=Query1.FieldByName('File_Name').AsString;
 If FlName = '' then exit;
 begin
   ShowSw:=True;   //20220212  CON
   OpenReturnCoupled(DataDirBox.Text,FlName,ShowSw);
   self.show; //20160126 Igor
 end;
//var
// Result:Integer;
// FlName : string;
// sin : string;
// s:String;
// RetNo:Integer;
//begin
// FlName:=Query1.FieldByName('File_Name').AsString;
// If FlName = '' then exit;
// If Length(FlName) = 10 then Sin := LeftStr(FlName,8)+MidStr(FlName,10,1);
// If IsOkToOpenReturn(DataDirBox.Text,FlName,Sin) = False then Exit;
//
// RetNo:=InitNewReturn;
// If RetNo=0 then exit;
// result := OpenReturn(RetNo,DataDirBox.Text,FlName,False);
// If Result = 0 then
// begin
//   LockWindowUpdate(MainForm.Handle);
//   CountDiagnostics(RetNo);
//   MainForm.LeftPanel.Visible:=True;
//   FormName := 'INFO';
//   FormNo := GetFormNo(FormName);
//   OpenForm(RetNo,FormNo,0);
//   OpenUsedForms(RetNo);
//   MainForm.FormPaint(Application);
//   If Ret[RetNo].FrmHasData[GetFormNo('FAMSET')] then
//   begin
//     if MessageDlg('Last time it was processed as Family'+
//       Chr(13)+'Process as Family again?',
//       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
//     begin
//      CplList:=TList.Create;
//      LoadCPLList(RetNo,CplList);
//      Couple.DoCoupling(RetNo);
//      CplList.Free;
//     end;
//   end;
// //  Close;  //20150313
//   exit;
// end
// else
//   begin
//    ShowOpenReturnFailure(Result,DataDirBox.Text,FlName);
//    exit;
//   end;
end;

procedure TSelOpenT1_2026.PrintBtnClick(Sender: TObject);
Var FileNm,Hdr1,Hdr2,Hdr3:string; F1:textFile; S:string;Apartment:String;
begin
// If LeftStr(LicenseLevel,8) = 'T1 Multi' then
 If LicenseLevel in anyMulti then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;
 If IsDataDirectoryGood(DataDirBox.Text) = False then exit;
 Hdr1 := Space(30)+'Client Listing - '+PaddR(FilterDescr,20)+PaddR(DateToMonthDayYear(Date),20);
 Hdr2 := PaddR('Name',36)+PaddR('File',13)+PaddR('SIN',20)+
         PaddR('Last Update',12)+PaddR('Area',5)+PaddR('Phone',8)+
         PaddR('$Invoice',8);
 Hdr3 := FilledStr(80,'=')+FilledStr(21,'=');
 {open output file}
 FileNm:=AppDir+'\'+'TempFile';
 AssignFile(F1,FileNm);
 Rewrite(F1);
 {scan query}
 Query1.First;
 Repeat
   s:= PaddR(
    LeftStr(AllTrim(Query1.FieldByName('Last_Name').AsString)+','
    +AllTrim(Query1.FieldByName('First_Name').AsString),40),35)+' '
    +PaddR(Query1.FieldByName('File_Name').AsString,12)+' '
    +PaddR(Query1.FieldByName('SIN').AsString,9)+' '
    +PaddR(Query1.FieldByName('Updated_By').AsString,10)+' '
    +PaddR(Query1.FieldByName('Updated_Dt').AsString,10)+' '
    +PaddR(Query1.FieldByName('Area').AsString,3)+' '
    +PaddR(Query1.FieldByName('Phone').AsString,8)
    +' '+FormatFloat('#,###.00',Query1.FieldByName('Inv_Amount').AsFloat);
   WriteLn(F1,s);
   Apartment:=AllTrim(Query1.FieldByName('Apartment').AsString);
   If Apartment>'' then Apartment:=',#'+Apartment+',' else Apartment:='';
   s:='            '+AllTrim(Query1.FieldByName('STREET').AsString)
      +Apartment+' '+
      AllTrim(Query1.FieldByName('City').AsString)+','+
      AllTrim(Query1.FieldByName('PROVINCE').AsString)+','+
      AllTrim(Query1.FieldByName('POSTAL').AsString);

   WriteLn(F1,s);
   Query1.Next;
 until Query1.Eof;
 CloseFile(F1);
 If PrintDialog1.Execute then
 begin
  If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
   ShowMessage('Printing Completed');
 end;
end;

procedure TSelOpenT1_2026.CopyBtnClick(Sender: TObject);
//20170518 Igor >>>
Var
  CopyToDir, FileNm: string;
  Cnt: Integer;
  ClickedOK: Boolean;
begin
//20171031 igor>>>
  if StartParams.IsDemo then
  begin
    MessageDlg(c_NotAvailable, mtInformation, [mbOk], 0);
    Exit;
  end;
//20171031 igor<<<
  Cnt := 0;
  CopyToDir := 'A:\DATA';
  CopyToDir := InputBox('Files will be replaced. No warning',
                        'Enter destination directory', CopyToDir);

  If (MidStr(CopyToDir, 2, 1) <> ':') then
  begin
    ShowMessage('Please enter full directory path');
    exit;
  end;

  If not DirectoryExists(CopyToDir) then
  begin
    {$I-}
    try
      MkDir(CopyToDir);
      if IOResult <> 0 then
      begin
        MessageDlg('Cannot create specified directory', mtWarning, [mbOk], 0);
        exit;
      end
      else
        MessageDlg('New directory created', mtInformation, [mbOk], 0);
    finally
      {$I+}
    end;
  end;
  {scan query}
  Screen.Cursor := crHourGlass;
  try
     Query1.DisableControls;
     Query1.First;
     while not Query1.eof do
     begin
       FileNm := Query1.FieldByName('File_Name').AsString;
       if not FileExists(IncludeTrailingPathDelimiter(DataDirBox.Text) + FileNm) then
         if MessageDlg('File ' + FileNm + ' not found.' + #13 +
                       'Continue?',
                       mtWarning, mbYesNoCancel, 0) <> mrYes then
           Exit
         else
       else
       If Not CopyFile(IncludeTrailingPathDelimiter(DataDirBox.Text) + FileNm,
                       IncludeTrailingPathDelimiter(CopyToDir) + FileNm) then
         if MessageDlg('Copy failed in File Name ' + Query1.FieldByName('Last_Name').AsString + ' File: ' + FileNm + #13 +
                       'Continue?', mtWarning, mbYesNoCancel, 0) <> mrYes then
           Exit
         else
       else
         Inc(Cnt);
       Query1.Next;
     end;
  finally
    Screen.Cursor := crDefault;
  end;

  ShowMessage(IntToStr(Cnt) + ' tax returns have been copied');

  if MessageDlg('Copy Client Master also?', mtInformation, [mbYes, mbNo], 0) = mrYes then
  begin
    Screen.Cursor := crHourGlass;
    try
      If (Not CopyFile(IncludeTrailingPathDelimiter(DataDirBox.Text) + ClientsDBLite,
                       IncludeTrailingPathDelimiter(CopyToDir) + ClientsDBLite)) then
        MessageDlg('Copy of Client master failed', mtError, [mbOk], 0)
      else
        MessageDlg('Client Master copied' + chr(13) +
                   'Destination directory is usable by VisualTax', mtInformation, [mbOk], 0);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
//20170518 Igor <<<
end;

procedure TSelOpenT1_2026.SelectCurBtnClick(Sender: TObject);
Var DirSelected:String;
begin
 if SelectDirectory('Select a folder:', '', DirSelected) then
 begin
  DataDirBox.Text := DirSelected;
  DataDirBoxExit(Sender);
  //SearchBox.SetFocus;
 end;
end;

procedure TSelOpenT1_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then DataDirBoxExit(Application);
end;

end.
