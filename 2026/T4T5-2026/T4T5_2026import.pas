unit T4T5_2026import;

//20170123 Igor Update pas and dfm

interface

uses SysUtils,
  {$WARN UNIT_PLATFORM OFF}FileCtrl,{$WARN UNIT_PLATFORM ON} //20170612 Igor
  WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,ExtCtrls,Buttons,Grids,DB,DBGrids,
  uADStanIntf, uADStanOption, uADStanError, uADGUIxIntf, uADPhysIntf,
  uADStanDef, uADStanPool, uADStanAsync, uADPhysManager, uADStanParam,
  uADDatSManager, uADDAptIntf, uADDAptManager, uADCompDataSet, uADCompClient;

  type
  TImportT4T5_2026 = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    LastYearDirBox: TEdit;
    Label3: TLabel;
    ThisYearDirBox: TEdit;
    Image1: TImage;
    RetCntLabel: TLabel;
    FileListBox1: TFileListBox;
    DosFileBtn: TBitBtn;
    grClient: TDBGrid;
    DataSource1: TDataSource;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    SearchBox: TEdit;
    conClient: TADConnection;
    tblClient: TADTable;
    pnlSearch: TPanel;
    pnlTools: TPanel;
    btnRolloverAll: TBitBtn;
    OverrideOption: TRadioGroup; //20181217 Igor

    Function LastYearDirExists(S:string):Boolean;
    procedure FilesToShow;
    procedure CalcImported(RetNo:Integer);
    Function ValidDirectories:Boolean;
    procedure OpenIt(FlName:String);
    procedure SaveIt(FlName:String);
    procedure FormCreate(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    {procedure AllBtnClick(Sender: TObject);}
    procedure LastYearDirBoxExit(Sender: TObject);
    procedure LastYearDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure grClientDblClick(Sender: TObject);
    procedure DosFileBtnClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SearchBoxChange(Sender: TObject);
    procedure SearchBoxKeyPress(Sender: TObject; var Key: Char);
    procedure btnRolloverAllClick(Sender: TObject); //20181217 Igor

   { procedure FindSinBtnClick(Sender: TObject);}  {Screen, element, valu}
  private
    { Private declarations }
    //20181712 Igor >>>
    FRolloverAll: Boolean;
    FAbortRolloverAll: Boolean;
    //20181712 Igor <<<
  public
    { Public declarations }
  end;

var
  Import: TImportT4T5_2026;
  FlName: string; //[60];
  RetNo : integer;
  Cnt   : integer;
  InitialRowCount :integer;

implementation

{$R *.DFM}

uses vtCommon,T4T5_2026,T4T5_2026ChildWinNew,T4T5_2026Common,T4T5_2026Declare,
  T4T5_2026Common2,T4T5_2026TrimStr,T4T5_2026Calc,T4T5_2026Main, vtTrimStr, vtShared, vtDataBase,
  vtMulti;

procedure TImportT4T5_2026.FormCreate(Sender: TObject);
begin
  OverrideOption.ItemIndex:=0;  //20181217
  //20181712 Igor >>>
  FRolloverAll := False;
  FAbortRolloverAll := False;
  //20181712 Igor <<<
  FlName := '';
  LastYearDirBox.Text := OptRec.Dir_LastYr;
  ThisYearDirBox.Text := OptRec.Dir_Cur;
  FilesToShow;
  //20180503 Igor >>>
  if CheckIsCloud(true) then
    LastYearDirBox.Enabled := False;
  //20180503 Igor <<<
end;


procedure TImportT4T5_2026.btnRolloverAllClick(Sender: TObject); //20181217 Igor
Var ReplaceFile:Boolean;
begin
 (*
  //20181217
  if OptRec.Dir_PgmLastYr='' Then
  Begin
   ShowMessage('First, you must Enter the Program Directory Folder you used last year, in the Configuration (Typically C:\VT-2017\T4T5-2017)');
   Exit;
  end;
 *)
  FRolloverAll := True;
  ReplaceFile:=False;if OverrideOption.ItemIndex=1 then ReplaceFile:=True;
  Cnt:=0; //20181217 CON
  try
    tblClient.First;
    while not tblClient.Eof do
    begin
      //grClientDblClick(Sender);  //gets flname and calls openit
      if FAbortRolloverAll then break;
      //*****20181217 CON ***********************
      FlName:=tblClient.FieldByName('FILE_NAME').AsString;

      If FileExists(OptRec.Dir_Cur+'\'+FlName) then
      begin
       If ReplaceFile=True then
       Begin
         OpenIt(FlName);  //reads the file, removes amounts from slips and opens the form if single file rolover
         If not SaveReturn(RetNo,OptRec.Dir_Cur,FlName,True,True) =0 then
          ShowMessage('Return '+FlName+' cannot be saved')
         Else
          Inc(Cnt);
         RemoveReturnFromMemory(RetNo);
       end
      end  //fileexists
      Else //new file
      Begin
        OpenIt(FlName);  //reads the file, removes amounts from slips and opens the form if single file rollover
        If not SaveReturn(RetNo,OptRec.Dir_Cur,FlName,True,True) =0 then
         ShowMessage('Return '+FlName+' cannot be saved')
        Else
         Inc(Cnt);
        RemoveReturnFromMemory(RetNo);
      End;
      tblClient.Next;
    end;
  finally
    FRolloverAll := False;
  end;
  ShowMessage(IntTostr(Cnt)+' Employers/Payers and their slips were rolled over to '+AppYear); //20181217 CON
end;

(*
procedure TImportT4T5_2026.btnRolloverAllClick(Sender: TObject); //20181217 Igor
begin
  //20181217
  if OptRec.Dir_PgmLastYr='' Then
  Begin
   ShowMessage('First, you must Enter the Program Directory Folder you used last year, in the Configuration (Typically C:\VT-2017\T4T5-2017)');
   Exit;
  end;

  FRolloverAll := True;
  try
    tblClient.First;
    while not tblClient.Eof do
    begin
      grClientDblClick(Sender);
      if FAbortRolloverAll then break;

      //*****20181217 CON ***********************
      If FileExists(OptRec.Dir_Cur+'\'+FlName) then
      begin
       if OverrideOption.ItemIndex =0 then
       begin
        //DO NOT SAVE
       end
       Else //brand new file
       Begin //new file
        If not SaveReturn(RetNo,OptRec.Dir_Cur,FlName,True,True) =0 then
         ShowMessage('Return '+FlName+' cannot be saved')
        Else
         Inc(Cnt);
        RemoveReturnFromMemory(RetNo);
       End;
      end;
      tblClient.Next;
    end;
  finally
    FRolloverAll := False;
  end;
  ShowMessage(IntTostr(Cnt)+' Employers/Payers and their slips were successfully rolled over to the new tax year'); //20181217 CON
end;
 *)
procedure TImportT4T5_2026.CalcImported(RetNo:Integer);
begin
  Calc(RetNo, AppT4T5_2026.FirstForm);
  CalcAll(RetNo);
end;

procedure TImportT4T5_2026.CancelBtnClick(Sender: TObject);
begin
  Close;
end;

Function TImportT4T5_2026.ValidDirectories:Boolean;
Var
  i, j: integer;
  Sin: string;
begin
  Result := False;
  ForceDirectories(ThisYearDirBox.Text); //20181217 Igor
  If Not SysUtils.DirectoryExists(ThisYearDirBox.Text) then //20170612 Igor
  begin
    ShowMessage('Directory does not exist');
    if ThisYearDirBox.Enabled then //20181217 Igor
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

Function TImportT4T5_2026.LastYearDirExists(S:string):Boolean;
begin
  If (UpperCase(s) ='A:') or (UpperCase(s) ='B:') then
  begin
    result := true;
    exit;
  end;
  If SysUtils.DirectoryExists(S) then //20170612 Igor
    result := true
  else
    result := false;
end;

procedure TImportT4T5_2026.OKBtnClick(Sender: TObject);
begin
 (*
  //20181217
  if OptRec.Dir_PgmLastYr='' Then
  Begin
   ShowMessage('First, you must Enter the Program Directory Folder you used last year, in the Configuration (Typically C:\VT-2017\T4T5-2017');
   Exit;
  end;
 *)
  grClientDblClick(Sender);
  Close;  //20181217
end;


procedure TImportT4T5_2026.SaveIt(FlName:String);
begin
  If not SaveReturn(RetNo, ThisYearDirBox.Text, FlName, False, True) = 0 then
    ShowMessage('Return cannot be saved')
  else
    Inc(Cnt);
end;

procedure TImportT4T5_2026.FilesToShow;
Var
  i, j: integer;
begin
  //20150923 Igor
  SetTableName(conClient, tblClient, LastYearDirBox.Text + '\' + ClientsDBLite,
    ClientsTableLite, 'CORP_NAME', False); //20170112 Igor
  tblClient.First;
  Refresh;
end;

procedure TImportT4T5_2026.LastYearDirBoxExit(Sender: TObject);
begin
  If not LastYearDirExists(LastYearDirBox.text) then
  begin
    ShowMessage('Directory '+ LastYearDirBox.text+ ' does not exist');
    LastYearDirBox.text := OptRec.Dir_lastYr;
   {exit}
  end;
  FilesToShow;
end;

procedure TImportT4T5_2026.LastYearDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
    LastYearDirBoxExit(Application);
end;

procedure TImportT4T5_2026.grClientDblClick(Sender: TObject);
begin
  FlName := tblClient.FieldByName('FILE_NAME').AsString;
  OpenIt(FlName);
  Close;
end;

procedure TImportT4T5_2026.OpenIt(FlName:String);
Var
  //RetNo:Integer; //20181217 CON
  I,j: Integer;
  myRec: TFRec;
  myFormNo: Integer;
  //Cnt: Integer;  //20181217 CON
begin
  FAbortRolloverAll := True; //20181217 Igor
  if not ValidDirectories then exit;
 // if not AppT4T5_2026.InitLastYear then Exit; //20181217 Igor    //20181219 CON
  If FlName = '' then exit;
  RetNo := ReadReturn(LastYearDirBox.Text, FlName, True, False, True, FRolloverAll); //20181217 Igor  //20181219 Igor
  if RetNo < 1 then
    ShowMessage('Opening file '+ Chr(13) +
                LastYearDirBox.Text+'\'+FlName + Chr(13) +
                'failed')
  else
  begin
    //clear last yead data
    for I := 0 to (FList.Count - 1) do
    begin
      myRec := FList.Items[I];
      myFormNo := myRec.FormNo;
      if myFormNo <= 0 then Continue;

      if SameText(myRec.FormName, 'EMPL') then  //20200112
      Begin
        StoreElm(RetNo,myFormNo,17,'WIP (Work in Progress)');
        StoreElm(RetNo,myFormNo,39,'WIP (Work in Progress)');
        StoreElm(RetNo,myFormNo,40,'WIP (Work in Progress)');
      end

      else
      if SameText(myRec.FormName, 'T4') then
        ClearDigitT4(RetNo, myFormNo)

      else
      if SameText(myRec.FormName, 'T4A') then
        ClearDigitT4A(RetNo, myFormNo)

      else
      if SameText(myRec.FormName, 'T5') then
        ClearDigitT5(RetNo, myFormNo);
    end;
    CalcAll(RetNo); //20190103 Igor
    If FRolloverAll=False then //20181217
      OpenForm(RetNo, GetFormNo(AppT4T5_2026.FirstForm), 0);

     (* does not work
     //20200203
    If FRolloverAll=True then //clear the summary
    Begin
       for j:= 1 to 35 do begin StoreElm(RetNo,'T4SUM',j,'');end;
       for j:= 1 to 35 do begin StoreElm(RetNo,'T4ASUM',j,'');end;
       for j:= 1 to 43 do begin StoreElm(RetNo,'T5SUM',j,'');end;
    end;
    *)
    Ret[RetNo].SourceDataDir := OptRec.Dir_Cur; {fool it in import}
    Ret[RetNo].Changed := True;
    FAbortRolloverAll := False; //20181217 Igor
  end;
end;


procedure TImportT4T5_2026.DosFileBtnClick(Sender: TObject);
begin
  FlName := InputBox('Input Box', 'Enter file number', '');
  OpenIt(FlName);
end;

procedure TImportT4T5_2026.BitBtn1Click(Sender: TObject);
begin
  ShowHelp('TfHelp','Conversion');
end;

procedure TImportT4T5_2026.SearchBoxChange(Sender: TObject);
begin
  with tblClient do
  begin
    SetKey;
    FieldByName('CORP_NAME').AsString := UpperCase(SearchBox.Text);
    GotoNearest;
  end;
end;

procedure TImportT4T5_2026.SearchBoxKeyPress(Sender: TObject; var Key: Char);
begin
  If key = #13 then
    OKBtnClick(Sender);
end;

end.

