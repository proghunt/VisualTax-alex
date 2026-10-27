unit T1_2026Import;
//unchanged 07-28

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,ExtCtrls,Buttons,Grids,DB,DBGrids,VclTee.TeeProcs,
  VclTee.TeEngine,VclTee.Chart, VclTee.TeeGDIPlus, uADStanIntf, uADStanOption,
  uADStanError, uADGUIxIntf, uADPhysIntf, uADStanDef, uADStanPool, uADStanAsync,
  uADPhysManager, uADStanParam, uADDatSManager, uADDAptIntf, uADDAptManager,
  uADCompDataSet, uADCompClient,
  VKDBFDataSet; //20160327 Igor

  type
  TImportT1_2026 = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    LastYearDirBox: TEdit;
    Label3: TLabel;
    ThisYearDirBox: TEdit;
    Image1: TImage;
    AllBtn: TBitBtn;
    RetCntLabel: TLabel;
    FileListBox1: TFileListBox;
    DosFileBtn: TBitBtn;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    OverrideOption: TRadioGroup;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    SearchBox: TEdit;
    CfT4Box: TCheckBox;
    CfT5Box: TCheckBox;
    CfEfileIndicBox: TCheckBox;
    BothSpousesBtn: TCheckBox;
    FDConnection: TADConnection;
    Table1: TADTable;
    ADMemTable1: TADMemTable;
    btnFixPasswords: TButton;
    Chart1: TChart;
    Label4: TLabel;//20160913 Igor

    Procedure SetCfIndicators;
    Function LastYearDirExists(S:string):Boolean;
    procedure FilesToShow;
    procedure CalcImported(RetNo:Integer);
    Function ValidDirectories:Boolean;
    procedure OpenIt(Dir:String;FlName:String);
    procedure SaveIt(FlName:String);
    procedure CancelBtnClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure AllBtnClick(Sender: TObject);
    procedure LastYearDirBoxExit(Sender: TObject);
    procedure LastYearDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DosFileBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure SearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure Table1FilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure btnFixPasswordsClick(Sender: TObject); //20160327 igor
    procedure FormCreate(Sender: TObject); //20161031 igor

   { procedure FindSinBtnClick(Sender: TObject);}  {Screen, element, valu}
  private
    FlName: String[60];
    {RetNo : integer;}
    Cnt   : integer;
    InitialRowCount :integer;
    DBFTable: TVKSmartDBF; //20160327 Igor
    WorkTable: TDataSet; //20160327 Igor
    CurrentDataBase: String; //20160913 igor
  public
    RetNo:Integer;
    //FormName: string;
  end;

//var  Import: TImportT1_2026;

function Import: integer;

implementation

{$R *.DFM}

uses vtMulti,vtMain,vtCommon,vtDialogs,T1_2026,T1_2026Common,T1_2026Declare,
  T1_2026Common2,T1_2026TrimStr,T1_2026ChildWinNEW,T1_2026Calc,T1_2026Cnterr,
  T1_2026T1Rtns,T1_2026Main,vtTrimStr,vtShared, vtDataBase, vtDataModuleUnit;   // 20150826 igor //20170117 Igor


function Import: integer;
begin
  with TImportT1_2026.Create(Application) do
  begin
    RetNo := 0;
    ShowModal;
    Result := RetNo;
    Free;
  end;
end;

procedure TImportT1_2026.FormCreate(Sender: TObject);//20171031 igor
begin
  if CheckIsCloud(true) then //20180503 Igor
    LastYearDirBox.Enabled := False;
end;

procedure TImportT1_2026.FormShow(Sender: TObject);
//procedure TImportT1_2026.FormCreate(Sender: TObject);
Var slash :string[1];
begin
   //20150904 igor
  FDConnection.Params.Values['Password'] := OptRec.SQLLitePassword.CurrentPassword;

 //RetNo:=GetCurrentRetNo;
 FlName := '';
 OverrideOption.itemIndex :=0;
 LastYearDirBox.Text := OptRec.Dir_LastYr;
 ThisYearDirBox.Text := OptRec.Dir_Cur;
 If (UpperCase(LastYearDirBox.Text) = 'A:') or
  (UpperCase(LastYearDirBox.Text) = 'B:') then
  slash :='' else slash := '\';

 If GetT4T5RolloverIndicator =True then
 begin
   CfT4Box.Checked:=True;
   CfT5Box.Checked:=True;
 end
 else
 begin
   CfT4Box.Checked:=False;
   CfT5Box.Checked:=False;
 end;
FilesToShow;
end;

procedure TImportT1_2026.CalcImported(RetNo:Integer);
Var i ,SlipCode: integer;
begin
 Calc(RetNo,'T1');
 CalcAll(RetNo);
end;

procedure TImportT1_2026.CancelBtnClick(Sender: TObject);
begin
Close;
end;

procedure TImportT1_2026.StringGrid1DblClick(Sender: TObject);
begin
OKBtnClick(Sender);
end;

procedure TImportT1_2026.Table1FilterRecord(DataSet: TDataSet; //20160327 Igor
  var Accept: Boolean);
begin
  Accept := (SearchBox.Text = '') or (pos(UpperCase(SearchBox.Text),UpperCase(DataSet.fieldByname('LAST_NAME').asString))>0);
end;

Function TImportT1_2026.ValidDirectories:Boolean;
Var i,j: integer; Sin : string;
begin
 Result := False;
 If Not DirectoryExists(ThisYearDirBox.Text) then
 begin
  ShowMessage('Directory does not exist');
  ThisYearDirBox.SetFocus;
  exit;
 end;
 If Not LastYearDirExists(LastYearDirBox.Text) then
  begin
   ShowMessage('Directory does not exist');
   LastYearDirBox.SetFocus;
   exit;
  end;
 Result := True;
end;

Function TImportT1_2026.LastYearDirExists(S:string):Boolean;
begin
 If (UpperCase(s) ='A:') or (UpperCase(s) ='B:') then
   begin result :=true;exit;end;
 If DirectoryExists(S) then result := true
 else result := false;
end;

procedure TImportT1_2026.OKBtnClick(Sender: TObject);
Var
  i: Integer;
  s, FlName: String;
  RetNo, SpRetNo: Integer;
  Sin: String;
  WrongAssets: String;
Begin
  SIN:=''; //temp 20251108 always brings 544494727
  WrongAssets:='';
  //20200914 Igor >>>
  FlName := GetRealReturnFileName(LastYearDirBox.Text,
                                  WorkTable.FieldByName('File_Name').AsString,
                                  WorkTable.FieldByName('SIN').AsString,
                                  WorkTable.FieldByName('Last_Name').AsString,
                                  WorkTable.FieldByName('First_Name').AsString);
  //20200914 Igor <<<
  //20110104
  If FileExists(ThisYearDirBox.text+'\'+FLName) then
  begin
    if MessageDlg('This return is already on this year'+Chr(39)+'s folder: '+ThisYearDirBox.text
                  +Chr(13)+' Roll it over again?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     //ok
    Else
      Exit;
  end;
  OpenIt(LastYearDirBox.Text,FlName);
  RetNo:=GetCurrentRetNo;
  If BothSpousesBtn.Checked then
  begin
    s:=GetSpouseSin(RetNo);
    If s > '' then
    begin
      FlName := LeftStr(s,8)+'.'+RightStr(s,1);
      OpenIt(LastYearDirBox.Text, FlName);
      //20090406
      // WrongAssets:=CheckAssets(RetNo);

      If WrongAssets>'' then  //20100306
      begin
        ShowMessage('Prior year'+Chr(39)+'s UCC of Assets/Automobiles is incosistent between spouses for the following:'
                    +Chr(13)+WrongAssets
                    +Chr(13)+'You must not couple until you verify/fix Opening UCC in both spouses');
      end
      Else
      begin
        ShowMessage('You can now Couple the returns');
        MainFormT1.StartCoupling1Click(Sender);
      end;
    end;
  end;
  Close;
end;


Procedure TImportT1_2026.SetCfIndicators;
begin
 CfT4:=CfT4Box.Checked;
 CfT5:=CfT5Box.Checked;
 CfEfileIndic:=CfEfileIndicBox.Checked;
end;


procedure TImportT1_2026.OpenIt(Dir:String;FlName:String);
Var i,j: integer; Sin : string;s:String;
  RetNo,FormNo:Integer;
  FormName: string;
begin
  if not ValidDirectories then exit;
  If FlName = '' then exit;
  SetCfIndicators;
  if FileExists(Dir+'\'+FlName) = false then
    begin
      ShowMessage('File '+ Chr(13) +
           Dir+'\'+FlName + Chr(13) +
           'does not exist');
      exit;
     end;

   If FlName = '' then exit;
   // 20150826 igor
//20160327 Igor >>>
//   If Not FileExists(Dir+'\'+ClientsDbLite) then
//   begin
//    showMessage('Data directory has not been defined'+
//    Chr(13)+'Use Configure | Data Directories');
//    exit;
//   end;
//20160327 Igor <<<
  If GetRetNoFromSin(RemoveChar(FlName,'.'))>0 then
  begin
   ShowTimedMsg('Return of SIN '+RemoveChar(FlName,'.') +' is already loaded. Skipped',1200);
   Exit;
  end;

  RetNo:=OpenReturn(Dir,FlName,False,False,True); //20160329 Igor
  If RetNo < 1 then
  begin ShowOpenReturnFailure(RetNo,Dir,FlName); exit; end;

   LockWindowUpdate(MainForm.Handle); //no impact
   CountDiagnostics(RetNo);
   //MainForm.LeftPanel.Visible:=True;
   MainForm.GuiCommand(gcShowLeftPanel); //20160220 Igor
   FormName := 'INFO';
   FormNo := GetFormNo(FormName);
   OpenForm(RetNo,FormNo,0);
   MainForm.FormPaint(Application);
   StoreElm(RetNo,'STATUS',4,'01'); //not started
   Ret[RetNo].PrpStatus:='01';
   Ret[RetNo].SourceDataDir := OptRec.Dir_Cur {fool it in import}
end;

procedure TImportT1_2026.AllBtnClick(Sender: TObject);
Var i,j,FNo: integer; Sin : string;Msg:string;
PrPStatus,EfStatus :String[2];Notes:String[80];
LastYrDir:String[60];
begin
 // ShowMessage('Batch rollover will be released later with the production version'); //20240131
 // If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit;  //20180126
  //Exit;

  If LicenseLevel in anyMulti then
  begin
    If YouKnowTheAdminPassword = false then exit;
  end;

  If RetInMem(AppT1_2026)>0 then
  begin
    ShowMessage('Please close all returns first');
    exit;
  end;

  if MessageDlg('Import all. Are you sure?', mtInformation, [mbYes, mbNo], 0) = mrNo then
    exit;

  SetCfIndicators;
  Cnt :=0;
  WorkTable.First; //20160327 Igor
  InitFormsTable;  //20101214 - why that?
  Repeat
    //InitFormsTable;  //20101214 - repeatedly???
    //20200914 Igor >>>
    FlName := GetRealReturnFileName(LastYearDirBox.Text,
                                    WorkTable.FieldByName('File_Name').AsString,
                                    WorkTable.FieldByName('SIN').AsString,
                                    WorkTable.FieldByName('Last_Name').AsString,
                                    WorkTable.FieldByName('First_Name').AsString);
    //20200914 Igor <<<
    If FlName = '' then exit;
    Try
      RetNo:=ReadReturn(LastYearDirBox.Text,FlName, False, True); //20161110 Igor
      if RetNo > 0 then
      begin
        StoreElm(RetNo,'STATUS',4,'01'); //not started
        Ret[RetNo].SourceDataDir := OptRec.Dir_Cur; {fooli t}
        PrpStatus := FetchElm(RetNo,'STATUS',4);
        If Not Numeric(PrpStatus) then PrpStatus :='00';
        EFStatus  := FetchElm(RetNo,'STATUS',15);
        If Not Numeric(EFStatus) then EFStatus :='00';
        Notes     := FetchElm(RetNo,'STATUS',14);
        CalcAll(RetNo);
        FNo :=GetFormNo('STATUS');
        For j:=8 to 10 do StoreElm(RetNo,FNo,j,'');
        For j:=18 to 30 do StoreElm(RetNo,FNo,j,'');
        For j:=16 to 16 do StoreElm(RetNo,FNo,j,'');
        For j:=14 to 14 do StoreElm(RetNo,FNo,j,'');
        For j:=31 to 31 do StoreElm(RetNo,FNo,j,'');

        For j:=11 to 11 do StoreElm(RetNo,FNo,j,User.UserName); //20170112 Igor
        For j:=12 to 12 do StoreElm(RetNo,FNo,j,FormatDateTime('yyyy-mm-dd',Date));
        {DateToStr(Date));}
        For j:=13 to 13 do StoreElm(RetNo,FNo,j,TimeToStr(Time));

        If FileExists(ThisYearDirBox.Text+'\'+FlName) then
        begin
          if OverrideOption.ItemIndex =1 then SaveIt(FlName);
        end
        else
          SaveIt(FlName);
      end;
    except
    end;
    If RetNo >0 then
      RemoveReturnFromMemory(RetNo);
    //20171031 igor>>>  
    if asFamilyOpen in ApplicationState then
      Exclude(ApplicationState, asFamilyOpen);
    //20171031 igor<<<  
    RetNo :=0; //RetINmem :=0;
    WorkTable.Next; //20160327 Igor
  until WorkTable.Eof; //20160327 Igor
  ShowMessage('Import from last year completed.'+Chr(13)+
              'Total returns converted/added= '+IntTostr(cnt));
  //Ret[RetNo].MyChild.Invalidate; //SendMessage(MDIHandle,WM_PAINT,0,0);
end;

procedure TImportT1_2026.SaveIt(FlName:String);
begin
 If not SaveReturn(RetNo,ThisYearDirBox.Text,FlName,True,True) =0
             then ShowMessage('Return cannot be saved')
 else Inc(Cnt);
end;

Function CheckLastYearFile:Boolean;
begin

end;

procedure TImportT1_2026.FilesToShow;
Var i,j:integer;
begin
  if CurrentDataBase = LastYearDirBox.Text then exit; //20160913 igor
  CurrentDataBase := LastYearDirBox.Text;             //20160913 igor

//  If Assigned(WorkTable) and WorkTable.Active then WorkTable.Close; //20160327 igor //20160913 Igor
  //20160327 Igor >>>>
  //20170310 Igor >>>
  If FileExists(LastYearDirBox.Text+'\'+ClientsTable_dbf) then
  Begin
    if not assigned(DBFTable) then //20160913 Igor
      DBFTable := TVKSmartDBF.Create(Self);
    DBFTable.Close; //20160913 Igor
    DBFTable.DBFFileName := LastYearDirBox.Text+'\'+ClientsTable_dbf;
    try
      DBFTable.Open;
    except
      ShowMessage ('Error open: ' + LastYearDirBox.Text+'\'+ClientsTable_dbf);
      exit;
    end;
    ADMemTable1.CopyDataSet(DBFTable, [coStructure, coRestart, coAppend]);  //20160913 Igor
    ADMemTable1.IndexFieldNames := 'LAST_NAME';                             //20160913 Igor
    WorkTable := ADMemTable1;                                               //20160913 Igor
  End
  else
  If FileExists(LastYearDirBox.Text+'\'+ClientsDBLite) then
  begin
    SetTableName(FDConnection, Table1, LastYearDirBox.Text + '\' + ClientsDBLite,
      ClientsTableLite, 'LAST_NAME', False); //20170112 Igor
    WorkTable := Table1;
  end
  //20170310 Igor <<<
  else
  Begin
    ShowMessage('Last year directory does not contain VisualTax files');
    exit;
  End;
  WorkTable.OnFilterRecord := Table1FilterRecord;
  DataSource1.DataSet := WorkTable;
  WorkTable.First;

//
// SetTableName(FDConnection, Table1, LastYearDirBox.Text + '\' + ClientsDbLite,
//     ClientsTableLite, 'LAST_NAME');
  //20160327 Igor <<<
end;

procedure TImportT1_2026.LastYearDirBoxExit(Sender: TObject);
begin
If not LastYearDirExists(LastYearDirBox.text) then
 begin
  ShowMessage('Directory '+ LastYearDirBox.text+ ' does not exist');
  LastYearDirBox.text := OptRec.Dir_lastYr;
  {exit}
 end;
 FilesToShow;
end;

procedure TImportT1_2026.LastYearDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
 If key = #13 then LastYearDirBoxExit(Application);
end;

procedure TImportT1_2026.DBGrid1DblClick(Sender: TObject);
//Var s,FlName:String;
begin
 OKBtnClick(Sender);
end;

procedure TImportT1_2026.DosFileBtnClick(Sender: TObject);
begin
 FlName := InputBox('Input Box', 'Enter SIN in form nnnnnnnn.n', '');
 //20110104
 If FileExists(ThisYearDirBox.text+'\'+FLName) then
 begin
    if MessageDlg('This return is already on this year'+Chr(39)+'s folder: '+ThisYearDirBox.text
      +Chr(13)+' Roll it over again?',
       mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     //ok
    Else
    Exit;
 end;

OpenIt(LastYearDirBox.Text,FlName);
Close;
end;

procedure TImportT1_2026.BitBtn1Click(Sender: TObject);
begin
ShowHelp('T1Help','Conversion');
end;

procedure TImportT1_2026.btnFixPasswordsClick(Sender: TObject); //20200914 Igor
var FlName: string;
begin
  //if source folder dbf
  if not FDConnection.Connected then
    Exit;
  FDConnection.Close;
  try
    SetPasswordVersion(FDConnection.Params.Values['DataBase'], 'Clients', False, 2);
  except
  end;
  SetTableName(FDConnection, Table1, LastYearDirBox.Text + '\' + ClientsDBLite,
    ClientsTableLite, 'LAST_NAME', False); //20170112 Igor
  Table1.Open;
  Table1.First;
  while not Table1.Eof do
  begin
    //20200914 Igor >>>
    FlName := GetRealReturnFileName(LastYearDirBox.Text,
                                    WorkTable.FieldByName('File_Name').AsString,
                                    WorkTable.FieldByName('SIN').AsString,
                                    WorkTable.FieldByName('Last_Name').AsString,
                                    WorkTable.FieldByName('First_Name').AsString);
    try
      SetPasswordVersion(LastYearDirBox.Text + '\' + FlName, '', True, 2);
    except
    end;
    //20200914 Igor <<<
    Table1.Next;
    Application.ProcessMessages;
  end;
  UserMsg('Done!');
end;

procedure TImportT1_2026.SearchBoxChange(Sender: TObject);
begin
  WorkTable.filtered := False; //20160913 Igor
  WorkTable.filtered := true;
//  WorkTable.first; //20160913 Igor
// with Table1 do
//  begin
//  SetKey;
//  FieldByName('Last_Name').AsString := UpperCase(SearchBox.Text);
//  GotoNearest;
//  end;

end;

procedure TImportT1_2026.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then OKBtnClick(Sender);
end;

end.
