unit fConvertToMultiApp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.CheckLst,
  Vcl.ExtCtrls,
  vtMulti, Data.DB, Data.Win.ADODB, Vcl.ComCtrls, Vcl.Menus;

type
  TOptionsNode = record
    Name, Caption, Value: String;
  end;
  POptionsNode = ^TOptionsNode;
  TfrmConvertToMultiApp = class(TForm)
    lblTaxModule: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    chkUseOptions: TCheckBox;
    edtLocation: TEdit;
    Label4: TLabel;
    GroupBox2: TGroupBox;
    chkUseKey: TCheckBox;
    edtKey: TEdit;
    GroupBox3: TGroupBox;
    chlbReturns: TCheckListBox;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    chkBackUp: TCheckBox;
    Label5: TLabel;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    edtvt2015tLocation: TEdit;
    GroupBox5: TGroupBox;
    edtvt2015Key: TEdit;
    GroupBox6: TGroupBox;
    lblLicenseName: TLabel;
    lchbvt2015Returns: TListBox;
    lbOptions: TListBox;
    lbvt2015Options: TListBox;
    Connection: TADOConnection;
    Table: TADOTable;
    pbOptions: TProgressBar;
    pbConvert: TProgressBar;
    chkOverwrite: TCheckBox;
    chkResetDefault: TCheckBox;
    pnlLog: TPanel;
    mmoLog: TMemo;
    btnCloseLog: TButton;
    btnShowLog: TButton;
    PopupMenu1: TPopupMenu;
    mniCheckall: TMenuItem;
    mniUncheckall: TMenuItem;
    mniInvert: TMenuItem;
    Label1: TLabel;
    rbAllReturns: TRadioButton;
    rbSomeReturns: TRadioButton;
    rbNoneReturns: TRadioButton;
    btnHelp: TBitBtn;//20161713 Igor
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtvt2015KeyChange(Sender: TObject);
    procedure chkUseKeyClick(Sender: TObject);
    procedure lbvt2015OptionsDblClick(Sender: TObject);
    procedure chkUseOptionsClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCloseLogClick(Sender: TObject);
    procedure pnlLogMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlLogMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlLogMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnShowLogClick(Sender: TObject);
    procedure mniCheckallClick(Sender: TObject);
    procedure mniUncheckallClick(Sender: TObject);
    procedure mniInvertClick(Sender: TObject);
    procedure rbNoneReturnsClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure btnHelpClick(Sender: TObject); //20160713 Igor
  private
    FApp : TApp;
    FPrevOptionsPath: String;
    FOldOptions: TStringList;
    FOldDataDir, FOldBackUpDir, FOldLastBackUpDir: String;
    DX, DY: Integer;
    AllDone: Boolean; //20160713 Igor
    function Init: Boolean;
    function ConvertValue(const AName, AValue: String): String;
    procedure AddLog(AMessage: String; AAddToLastMessage: Boolean = False);
    function HiddenExecute: Boolean; //20160713 Igor
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConvertToMultiApp: TfrmConvertToMultiApp;
function ConvertToMultiApp(App: TApp; AShowMessageIfNotExists: Boolean = False): Boolean;
implementation

{$R *.dfm}

uses
  vtTrimStr, vtShared, vtDialogs;//20160713 Igor
const
  c_widthName = 35;
  c_ConvertToMultiAppHelp = 'www.visualtax.com/vtConvertToMultiAp.asp';

function ConvertToMultiApp(App: TApp; AShowMessageIfNotExists: Boolean = False): boolean;
Begin
  Result := False;
  //20170927 igor>>>
  if StartParams.IsDemo or StartParams.isCloud then
  begin
    if AShowMessageIfNotExists then
      MessageDlg(c_NotAvailable, mtInformation, [mbOk], 0);
    Exit;
  end;
  //20170927 igor<<<
  with TfrmConvertToMultiApp.Create(nil) do
  begin
    try
      FApp := App;
      if Init then
        if AShowMessageIfNotExists then //20160713 Igor {not AShowMessageIfNotExists = first start}
          Result := (ShowModal = mrOk)
        else
          Result := HiddenExecute
      else
      if AShowMessageIfNotExists then
        MessageDlg('The old version of the program can not be found', mtInformation, [mbOk], 0);
    finally
      free;
    end;
  end;

End;

{ TfrmConvertToMultiApp }

procedure TfrmConvertToMultiApp.AddLog(AMessage: String; AAddToLastMessage: Boolean = False); //20160615 Igor //20160616 Igor
begin
  if not AAddToLastMessage or (mmoLog.Lines.Count < 1) then
  Begin
    mmoLog.Lines.Add(AMessage);
  End
  else
  begin
    mmoLog.Lines[mmoLog.Lines.Count - 1] := mmoLog.Lines[mmoLog.Lines.Count - 1] + AMessage;
  end;
  Application.ProcessMessages;
end;

procedure TfrmConvertToMultiApp.btnHelpClick(Sender: TObject); //20160713 Igor
begin
  ShowHelp(c_ConvertToMultiAppHelp, '', true);
end;

procedure TfrmConvertToMultiApp.btnCloseLogClick(Sender: TObject); //20160615 Igor
begin
  if btnCloseLog.Caption <> 'Finish' then
  Begin
    pnlLog.Visible := False;
    btnShowLog.Visible := True;
  End
  else
  begin
    self.ModalResult := mrOk;
    Self.CloseModal;
  end;
end;

procedure TfrmConvertToMultiApp.btnOkClick(Sender: TObject); //20160615 Igor (All proc)
var
  sl: TStringList;
  I, J: Integer;
  Node: POptionsNode;
  NewDataDir,
  NewBackUpDataDir: String;
  Err: string;
  SkippedReturn, DoneReturn: Integer;
  OptName: String; //20160621 Igor
  AShowWarning: Boolean; //20160713 Igor
begin
  AllDone := False; //20160713 Igor
  AShowWarning := Sender <> nil; //20160713 Igor
  mmoLog.Lines.Clear;
  //Check key
  if not FApp.ValidateKey(edtvt2015Key.Text) then
  Begin
    if AShowWarning then //20160713 Igor
      MessageDlg('Please enter a valid key or use the key of the old version of the program.',
                 mtWarning, [mbOk], 0);
    exit;
  End;

  if AShowWarning then //20160713 Igor
    if MessageDlg('Convert options from old program?', mtConfirmation, [mbYes, mbCancel], 0) <> mrYes then
      exit;
  btnCancel.Enabled := False;
  btnOk.Enabled := False;
  try
    //show log
    if AShowWarning then //20160713 Igor
      btnShowLogClick(nil);
    //create backup old Program

    if AShowWarning AND rbNoneReturns.Checked then //20160713 Igor
    begin
      if MessageDlg('If you want to convert the Old format of your tax returns, you must choose All or Some.'+#13+
                    'Change it now?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
      Begin
        btnCloseLogClick(btnCloseLog);
        rbAllReturns.SetFocus;
        exit;
      End;
    end;

    //Save options to file
    //not need check state chkUseOptions, Options list have imported or default value
    sl := TStringList.Create;
    try
      pbOptions.Max := lbvt2015Options.Count;
      for I := 0 to lbvt2015Options.Count - 1 do
      Begin
        pbOptions.Position := I + 1;
        Node := POptionsNode(lbvt2015Options.Items.Objects[I]);
        //20160718 Igor >>>
        if (sameText(Node^.Name, 'dir_cur') or
            sameText(Node^.Name, 'Dir_Deflt')) and
           (FApp.LicenseLevel in anyLimited) then
        begin
          Node^.Value := FApp.LimitedVersionDir;
        end;
        //20160718 Igor <<<
        sl.Add(PaddR(UpperCase(Node^.Name),20)+Node^.Value);
        if (Node^.Value <> '') AND (pos('dir_',ansiLowerCase(Node^.Name)) = 1) then
        begin
          if not ForceDirectories(Node^.Value) then
          Begin
            AddLog('Can''t create directory "'+Node^.Value+'"');
            if AShowWarning then //20160713 Igor
              MessageDlg('Can''t create directory "'+Node^.Value+'"', mtError, [mbOk], 0);
            exit;
          End
          else
            AddLog('Force directory "' + Node^.Value + '" for options parameter "' + Node^.Name + '"');
        end;
        if SameText(Node^.Name,'Dir_Cur') or
           SameText(Node^.Name,'Dir_Deflt') then
        Begin
          if DirectoryExists(Node^.Value) AND
             sametext(Node^.Value, FApp.AppDir) then
          Begin
            AddLog('The parameter "' + Node^.Name + '" is invalid: You cannot use the Program Directory "'+
              Node^.Value + Chr(13)+'" as Data Directory');
            if AShowWarning then //20160713 Igor
              MessageDlg('The parameter "' + Node^.Name + '" is invalid: You cannot use the Program Directory "'+
                Node^.Value + Chr(13)+'" as Data Directory', mtError, [mbOk], 0);
            exit;
          End;
          if DirectoryExists(Node^.Value) AND
             FileExists(IncludeTrailingPathDelimiter(Node^.Value)+ClientsTable_dbf) then
          Begin
            AddLog('The parameter "' + Node^.Name + '" is invalid: this data directory '+ Node^.Value + ' has tax returns with the old format. '+
                   'Please use a different data directory for this program.');
            if AShowWarning then //20160713 Igor
              MessageDlg('The parameter "' + Node^.Name + '" is invalid: this data directory '+ Node^.Value + ' has tax returns with the old format. '+
                         'Please use a different data directory for this program.', mtError, [mbOk], 0);
            exit;
          End;


          NewDataDir := Node^.Value;
          if not FileExists(IncludeTrailingPathDelimiter(NewDataDir) + FApp.ClientsDBLite) then
          begin
            if CopyDB(FApp.ClientsDBLite, FApp.AppDir, NewDataDir, Err) then//20170802 Igor
              AddLog('Create database in directory "' + Node^.Value + '" for options parameter "' + Node^.Name + '"')
            else
            Begin
              if AShowWarning then //20160713 Igor
                MessageDlg('Can''t Create database in directory "' + Node^.Value + '" for options parameter "' + Node^.Name + '"', mtError, [mbOk], 0);
              AddLog('Can''t Create database in directory "' + Node^.Value + '" for options parameter "' + Node^.Name + '"');
              exit;
            End;
          end;
        End;

      End;
      AddLog('Save options to file "' + IncludeTrailingPathDelimiter(FApp.AppDir)+OptionsFlName + '"');//20170802 Igor
      sl.SaveToFile(IncludeTrailingPathDelimiter(FApp.AppDir)+OptionsFlName);//20170802 Igor
    finally
      sl.Free;
    end;
    //Load options to App

    AddLog('Apply Configuration Options');
    AddLog('');
    FApp.LoadOptionsFileToMem;
    //Create FList
    FApp.InitFList;

    if chkUseKey.Checked then
    Begin
      //Save License
      AddLog('Apply License');
      LicenseList.Keys[FApp.AppId] := edtvt2015Key.Text;
      LicenseList.SaveToFile(ExtractFilePath(Application.ExeName)+LicenseFile);
    End;

    if not rbNoneReturns.Checked then
    begin
      //Create BackUp
      if chkBackUp.Checked then
      begin
        AddLog('Start create backup');
        NewBackUpDataDir := IncrementlastBackUpDir(FOldLastBackUpDir, FOldBackUpDir);
        Err := '';
        // Create BackUp
        if BackUpData(FOldDataDir, NewBackUpDataDir, Err) then
        begin
          // Write Last BackUpDir to OldProgram options
          FApp.SaveSingleOptions('LastBackUpDir', NewBackUpDataDir, FPrevOptionsPath);
          AddLog('Backup old program data created in directory "' + NewBackUpDataDir + '"');
        end
        else
        Begin
          AddLog('An error occurred during the creation of backup data! '+#13+Err);
          if AShowWarning then //20160713 Igor
            MessageDlg('An error occurred during the creation of backup data!'+#13+Err, mtError, [mbOk], 0);
          exit;
        End;
      end;
      //Convert Returns
      AddLog('START CONVERSION OF RETURNS');
      Table.First;
      pbConvert.Max := Table.RecordCount;
      SkippedReturn := 0;
      DoneReturn := 0;
      I := 0;
      while not Table.Eof do
      Begin
        inc(I);
        pbConvert.Position := Table.RecNo;
        if chlbReturns.Checked[Table.RecNo - 1] then
        Begin
          chlbReturns.Selected[Table.RecNo - 1] := True;
          //20160621 Igor >>>
          OptName := '';
          J :=0;
          for J := 0 to Table.FieldCount - 1 do
          begin
            if SameText(Table.Fields.Fields[J].FieldName, 'FILE_NAME') then
              break;
            OptName := OptName + Table.Fields.Fields[J].AsString + ' ';
          end;
          AddLog('Start conversion of  return "' + Table.FieldByName('File_Name').AsString + '" (' +
             OptName + ')');
          //20160621 Igor <<<
          Err := '';
          if FApp.ImportOneReturn(Table, FOldDataDir, NewDataDir, Err, chkOverwrite.Checked) then
          begin
            AddLog('. DONE', true);
            lchbvt2015Returns.Items.Add(chlbReturns.Items[Table.RecNo - 1]);
            lchbvt2015Returns.Selected[lchbvt2015Returns.Count - 1] := true;
            lchbvt2015Returns.Refresh;
            inc(DoneReturn);
          end
          else
          Begin
            AddLog('. SKIPPED. Reason: ' + Err, True);
            inc(SkippedReturn);
          End;
        End;
        if FApp.FList.ApproachedLimit then  //20160617 Igor
          FApp.InitFormsTable;
        Table.Next;
        Application.ProcessMessages;
      End;
      //20160713 Igor >>>
      AddLog('');
      AddLog('***********************************');
      AddLog('');
      if SkippedReturn = 0 then
        AddLog('All done. '+IntToStr(DoneReturn)+' return(s) converted.')
      else
        AddLog('Warning! ' + IntToStr(SkippedReturn) + ' return(s) skipped / '+IntToStr(DoneReturn)+' return(s) converted.');
    end;
    AllDone := True;
    if AShowWarning then
    Begin
      if not pnlLog.Visible then
      Begin
        self.ModalResult := mrOk;
        Self.CloseModal;
      End
      else
      begin
        btnCloseLog.Caption := 'Finish';
      end;
    End;
    //20160713 Igor <<<
  finally
    if btnCloseLog.Caption <> 'Finish' then
    begin
      btnCancel.Enabled := True;
      btnOk.Enabled := True;
    end;
  end;

end;

procedure TfrmConvertToMultiApp.btnShowLogClick(Sender: TObject); //20160615 Igor
var
  L,T,W,H: Integer;
begin
  W := Self.ClientWidth div 2;
  H := Self.ClientHeight div 2;
  L := (Self.ClientWidth div 2) - (W div 2);
  T := (Self.ClientHeight div 2) - (H div 2);
  pnlLog.SetBounds(L,T,W,H);
  pnlLog.Visible := True;
end;

procedure TfrmConvertToMultiApp.mniCheckallClick(Sender: TObject);
begin
  chlbReturns.CheckAll(cbChecked);
end;

procedure TfrmConvertToMultiApp.chkUseKeyClick(Sender: TObject);
begin
  if chkUseKey.Checked then
  begin
    edtvt2015Key.Color := clBtnFace;
    edtvt2015Key.ReadOnly := true;
    edtvt2015Key.Text := edtKey.Text;
  end
  else
  begin
    edtvt2015Key.Color := clWindow;
    edtvt2015Key.ReadOnly := False;
    edtvt2015Key.Text := FApp.GetLicenseKey;
  end;
end;

function TfrmConvertToMultiApp.ConvertValue(const AName, AValue: String): String;
var J: Integer;
begin
  if SameText(AName,'Dir_Cur') or SameText(AName,'Dir_Deflt') then
    Result := IncludeTrailingPathDelimiter(FApp.AppDir) + 'Data'//20170802 Igor
  else
  if SameText(AName,'Dir_ClientDocs') then
    Result := IncludeTrailingPathDelimiter(FApp.AppDir) + 'ClientDocs'//20170802 Igor
  else
  if SameText(AName,'BackUpDir') then
    Result := IncludeTrailingPathDelimiter(FApp.AppDir) + 'BackUp'//20170802 Igor
  else
  //20160805 Igor >>>
  if SameText(AName,'LastBackupDir') then
    Result := ''
  else
  //20160805 Igor <<<
  if SameText(AName,'Dir_Planner') then
    Result := IncludeTrailingPathDelimiter(FApp.AppDir) + 'Planner'//20170802 Igor
  else
  if SameText(AName,'Dir_AutoFill') then
    Result := IncludeTrailingPathDelimiter(FApp.AppDir) + 'AutoFill'//20170802 Igor
  else
  if SameText(AName,'Dir_DBFData') then
  Begin
    for J := 0 to FOldOptions.Count - 1 do
    Begin
      if SameText(trim(LeftStr(FOldOptions[J],20)),'Dir_Cur') then
      begin
         Result := MidStr(FOldOptions[J], 21, 250);
         break;
      end;
    End;
  End
  else
    Result := AValue;
end;

procedure TfrmConvertToMultiApp.chkUseOptionsClick(Sender: TObject);
var
  I, K: Integer;
  OptionsNode2, OptionsNode: POptionsNode;
  sl: TStringList;
begin
  for I := 0 to lbvt2015Options.Count - 1 do
    freeMem(POptionsNode(lbvt2015Options.Items.Objects[I]));
  lbvt2015Options.Clear;
  if chkResetDefault.Checked then
    sl := FApp.GetDefaultOptions
  else
    sl := FApp.GetOptions;
  try
    if chkUseOptions.Checked then
    Begin
      for I := 0 to FOldOptions.Count - 1 do
      Begin
        OptionsNode := POptionsNode(lbOptions.Items.Objects[I]);
        new(OptionsNode2);
        OptionsNode2^.Name := OptionsNode^.Name;
        OptionsNode2^.Caption := OptionsNode^.Caption;
        OptionsNode2^.Value := ConvertValue(OptionsNode^.Name, OptionsNode^.Value);
        lbvt2015Options.Items.AddObject(PaddR(OptionsNode2^.Caption,c_widthName) + ' = ' + OptionsNode2^.Value, Pointer(OptionsNode2));
        K := sl.IndexOfName(OptionsNode^.Name);
        if K <> -1 then
          sl.Delete(K);
      End;
    End;
    for I := 0 to sl.Count - 1 do
    Begin
      new(OptionsNode2);
      OptionsNode2^.Name := sl.Names[I];
      OptionsNode2^.Caption := FApp.GetOptionsCaption(sl.Names[I]);
      OptionsNode2^.Value := ConvertValue(sl.Names[I], sl.ValueFromIndex[I]);
      lbvt2015Options.Items.AddObject(PaddR(OptionsNode2^.Caption,c_widthName) + ' = ' + OptionsNode2^.Value, Pointer(OptionsNode2));
    End;
  finally
    sl.Free;
  end;
end;

procedure TfrmConvertToMultiApp.edtvt2015KeyChange(Sender: TObject);
var
  key: string;
begin
  key := edtvt2015Key.Text;
  if FApp.ValidateKey(key) then
  begin
    FApp.SetLicense(Key);
    lblLicenseName.Caption := FApp.ProductName;
  end
  else
  begin
    FApp.SetLicense(''); //20160615 Igor
    lblLicenseName.Caption := 'XXXXXXXXXX';
  end;
end;

procedure TfrmConvertToMultiApp.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//20160615 Igor
//  if (ModalResult = mrCancel) AND
//     (not chkUseKey.Checked) then
//    FApp.SetLicense('');
  FreeAndNil(FOldOptions);
end;

procedure TfrmConvertToMultiApp.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  //20160615 Igor
  if btnCloseLog.Caption = 'Finish' then
     ModalResult := mrOk
  else
  begin
    if ModalResult = mrCancel then
      CanClose := MessageDlg('Exit without importing settings?',mtWarning,[mbYes,mbNo],0) = mrYes;
  end;
end;

procedure TfrmConvertToMultiApp.FormCreate(Sender: TObject);
begin
  FOldOptions := TStringList.Create;
end;

function TfrmConvertToMultiApp.HiddenExecute: Boolean; //20160713
begin
  chkResetDefault.Checked := True;
  chkUseOptions.Checked := True;
  chkUseOptionsClick(chkUseOptions);
  if chkUseKey.Enabled then
  begin
    chkUseKey.Checked := True;
    chkUseKeyClick(chkUseKey);
  end;
  rbNoneReturns.Checked := True;
  rbNoneReturnsClick(rbNoneReturns);
  chkBackUp.Checked := False;
  btnOkClick(nil);
  Result := AllDone;
end;

function TfrmConvertToMultiApp.Init: Boolean;
var
  I: Integer;
  LVERF: TStringList;
  OptionsNode: POptionsNode;
  OptName,optValue: String;
begin
  if ExistsPrevOption(FApp.AppId, FPrevOptionsPath) then
  begin
    lblTaxModule.Caption := lblTaxModule.Caption + ' ' + FApp.AppName;
    edtLocation.Text := ExtractFileDir(FPrevOptionsPath);
    edtvt2015tLocation.Text := FApp.AppDir;
    if FileExists(IncludeTrailingPathDelimiter(FApp.AppDir)+OptionsFlName) then
    Begin
      chkResetDefault.Checked := False;
      chkResetDefault.Enabled := true;
    End
    else
    begin
      chkResetDefault.Checked := true;
      chkResetDefault.Enabled := false;
    end;

    FOldOptions := TStringList.Create;
    FOldOptions.LoadFromFile(FPrevOptionsPath);
    FOldDataDir := '';
    //Load old Setting
    for I := 0 to FOldOptions.Count - 1 do
    Begin
      OptName := Trim(LeftStr(FOldOptions[I], 20));
      OptValue := MidStr(FOldOptions[I], 21, 250);
      new(OptionsNode);
      OptionsNode^.Name := OptName;
      OptionsNode^.Caption := FApp.GetOptionsCaption(OptName);
      OptionsNode^.Value := OptValue;
      lbOptions.Items.AddObject(PaddR(OptionsNode^.Caption,c_widthName) + ' = ' + OptionsNode^.Value, Pointer(OptionsNode));
      if SameText(OptionsNode^.Name,'Dir_Cur') then
        FOldDataDir := OptionsNode^.Value;
      if SameText(OptionsNode^.Name,'BackupDir') then
      Begin
        FOldBackUpDir := OptionsNode^.Value;
        chkBackUp.Checked := FOldBackUpDir <> '';
        chkBackUp.Enabled := FOldBackUpDir <> '';
      End;
      if SameText(OptionsNode^.Name,'LastBackupDir') then
      Begin
        FOldLastBackUpDir := OptionsNode^.Value;
      End;
    End;
    chkUseOptionsClick(nil);
    //Load License Key
    LVERF := TStringList.Create;
    if FileExists(ExtractFilePath(FPrevOptionsPath)+LicenseFile) then //20160713 Igor
      LVERF.LoadFromFile(ExtractFilePath(FPrevOptionsPath)+LicenseFile);
    if LVERF.Count > 0 then
    begin
      edtKey.Text := copy(LVERF[0],1,19);
      chkUseKey.Checked := FApp.GetLicenseKey = '';
      chkUseKeyClick(chkUseKey);
    end;

    //Load return List
    Connection.Close;
    Table.Close;
    try
      try
        Connection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;' +
                                       'Data Source=' + FOldDataDir + ';' +
                                       'Extended Properties="DBASE IV";';
        Connection.LoginPrompt := false;
        Connection.Open;
        Table.TableName := ClientsTable_dbf;
        Table.IndexName := 'LAST_NAME';
        Table.Open;
        Table.First;
        while not Table.Eof do
        Begin
          OptName := '';
          I :=0;
          for I := 0 to Table.FieldCount - 1 do
          begin
            OptName := OptName + PaddR(Table.Fields.Fields[I].AsString, 20) + ' ';
            if SameText(Table.Fields.Fields[I].FieldName, 'FILE_NAME') then
              break;
          end;
          chlbReturns.Items.Add(OptName);
          Table.Next;
        End;
        chlbReturns.CheckAll(cbChecked);
      except
        rbAllReturns.Enabled := False;
        rbSomeReturns.Enabled := False;
        rbNoneReturns.Enabled := False;
      end;
    finally
      rbNoneReturns.Checked := True;
    end;
    Result := True;
  end
  else
    result := False;
end;

procedure TfrmConvertToMultiApp.mniInvertClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to chlbReturns.Count - 1 do
    chlbReturns.Checked[I] := not chlbReturns.Checked[I];
end;

procedure TfrmConvertToMultiApp.lbvt2015OptionsDblClick(Sender: TObject);
var
  Node: POptionsNode;
  Val: String;
begin
  if lbvt2015Options.ItemIndex <> -1 then
  Begin
    Node := POptionsNode(lbvt2015Options.Items.Objects[lbvt2015Options.ItemIndex]);
    Val := Node^.Value;
    if InputQuery('Change options value', Node^.Name, Val) then
    Begin
      Node^.Value := Val;
      lbvt2015Options.Items[lbvt2015Options.ItemIndex] := PaddR(Node^.Caption, c_widthName) + ' = ' + Node^.Value;
    End;
  End;
end;

procedure TfrmConvertToMultiApp.pnlLogMouseDown(Sender: TObject;  //20160615 Igor
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DX := X;
  DY := Y;
  pnlLog.Tag := -1;
end;

procedure TfrmConvertToMultiApp.pnlLogMouseMove(Sender: TObject;   //20160615 Igor
  Shift: TShiftState; X, Y: Integer);
begin
  if pnlLog.Tag = -1 then
  Begin
    pnlLog.SetBounds(pnlLog.Left + (X - DX), pnlLog.Top + (Y - DY), pnlLog.Width, pnlLog.Height);
  End;
end;

procedure TfrmConvertToMultiApp.pnlLogMouseUp(Sender: TObject;  //20160615 Igor
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  pnlLog.Tag := 0;
end;

procedure TfrmConvertToMultiApp.PopupMenu1Popup(Sender: TObject);
begin
  mniCheckall.Enabled := chlbReturns.Enabled;
  mniUnCheckall.Enabled := chlbReturns.Enabled;
  mniInvert.Enabled := chlbReturns.Enabled;
end;

procedure TfrmConvertToMultiApp.rbNoneReturnsClick(Sender: TObject);
begin
  if rbAllReturns.Checked then
  Begin
    chlbReturns.CheckAll(cbChecked);
    chlbReturns.Enabled := False;
  End
  else
  if rbSomeReturns.Checked then
  begin
    chlbReturns.CheckAll(cbUnchecked);
    chlbReturns.Enabled := True;
  end
  else
  if rbNoneReturns.Checked then
  Begin
    chlbReturns.CheckAll(cbUnchecked);
    chlbReturns.Enabled := False;
  End;
end;

procedure TfrmConvertToMultiApp.mniUncheckallClick(Sender: TObject);
begin
  chlbReturns.CheckAll(cbUnchecked);
end;

end.
