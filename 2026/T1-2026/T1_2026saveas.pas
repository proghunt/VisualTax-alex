unit T1_2026saveas;

interface

uses SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics,
  Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TSaveAsT1_2026 = class(TForm)
    Panel1: TPanel;
    StatusGroup: TRadioGroup;
    EFStatusGroup: TRadioGroup;
    Panel2: TPanel;
    FLNameBox: TEdit;
    Label1: TLabel;
    statuslbl: TLabel;
    Panel3: TPanel;
    DataDirBox: TEdit;
    noteslbl: TLabel;
    ClearBtn: TBitBtn;
    SaveBtn: TBitBtn;
    DoNotSaveBtn: TBitBtn;
    RetNameLbl: TLabel;
    Label2: TLabel;
    Notes: TEdit;
    HelpBtn: TBitBtn;
    Label3: TLabel;
    Category: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblDirectoryNote: TLabel; // 20161208 Igor
    BrowseBtn: TBitBtn;
    gbStorage: TGroupBox; // 20161208 Igor
    lblDirectory: TLabel; // 20161208 Igor
    sbStorage: TScrollBox;// 20161208 Igor
    btnDownload: TBitBtn; //20181130 Igor
    FileNameFormat: TRadioGroup;
    Label8: TLabel;
    Label9: TLabel; //20200921 Igor
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure SaveCloseBtnClick(Sender: TObject);
    procedure DoNotSaveBtnClick(Sender: TObject);
    { procedure BitBtn2Click(Sender: TObject); }
    procedure FormPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HelpBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
    procedure BrowseBtnClick(Sender: TObject);
    // 20171225 Igor >>>
    procedure cbShareWithPeopleClick(Sender: TObject);
    procedure sbShareWithPeopleClick(Sender: TObject);
    // 20171225 Igor <<<
    procedure FileNameFormatClick(Sender: TObject); //20200921 Igor
  private
    FRetNo: integer;
    { Private declarations }
    procedure HelperClick(Sender: TObject); // 20161209 Igor
  public
    property RetNo: integer read FRetNo;
  end;

var
  SaveAs: TSaveAsT1_2026;
  RetNo: integer;

implementation

{$R *.DFM}

uses vtMulti, vtCommon, T1_2026, T1_2026Declare, T1_2026Common, T1_2026Common2,
  T1_2026TrimStr, T1_2026T1Rtns, T1_2026Features, T1_2026Calc,
  T1_2026ChildWinNEW,
  vtTrimStr, vtShared,
  System.IOUtils, VirtualUI_Mediator, //20181130 Igor
  vtHelperManager, vtDialogs, vtShareToPeople;
// 20161208 Igor //20170113 Igor // 20171224 Igor

procedure TSaveAsT1_2026.CancelBtnClick(Sender: TObject);
begin
  release;
end;

procedure TSaveAsT1_2026.cbShareWithPeopleClick(Sender: TObject);
// 20171225 Igor
var
  I: integer;
begin
  if not(Sender is TCheckBox) then
    Exit;
  for I := 0 to sbStorage.ControlCount - 1 do
    if (sbStorage.Controls[I] is TSpeedButton) and
      ((sbStorage.Controls[I] as TSpeedButton).Tag = 1000) then
    begin
      (sbStorage.Controls[I] as TSpeedButton).Enabled :=
        (Sender as TCheckBox).Checked;
      break;
    end;
end;

procedure TSaveAsT1_2026.FileNameFormatClick(Sender: TObject); //20200921 Igor
begin
  FLNameBox.Text := GenerateReturnFileName(RetNo, IntToStr(FileNameFormat.ItemIndex));
end;

procedure TSaveAsT1_2026.FormCreate(Sender: TObject);
var
  I, j: integer; // 20161208 Igor
  s1, s2: string;
  // 20180111 Igor >>>
  LastLeft, MaxLeft, a: integer; // 20171225 Igor
  bShowShareList: boolean; // 20171229 Igor
  // 20180111 Igor <<<
const
  dh = 20; // 20161208 Igor

  function GetTextWidth(AText: string; AFont: TFont): integer; // 20171224 Igor
  var
    ABitmap: TBitmap;
  begin
    Result := 0;
    ABitmap := TBitmap.Create;
    try
      ABitmap.Canvas.Font.Assign(AFont);
      Result := ABitmap.Canvas.TextWidth(AText);
    finally
      ABitmap.Free;
    end;
  end;

begin
  FRetNo := GetCurrentRetNo;
  RetNameLbl.Caption := GetRetName(RetNo);
  RetNameLbl.Color := GetRetColor(RetNo);
  //20201130 Igor >>>
  FileNameFormat.ItemIndex:= StrToIntDef(OptRec.FileNameFormat, 0);
  if FileNameValid(Ret[RetNo].SourceFlName) then
    FLNameBox.Text := Ret[RetNo].SourceFlName; { GetRetFlName(RetNo); }
  If FLNameBox.Text = '' then
    FLNameBox.Text := GenerateReturnFileName(RetNo, IntToStr(FileNameFormat.ItemIndex)); // 20160305 Igor
  //20201130 Igor <<<

  // LeftStr(FetchElm(RetNo,'INFO',3),8)+          //20160305 Igor
  // '.'+RightStr(FetchElm(RetNo,'INFO',3),1);     //20160305 Igor

  If Ret[RetNo].IsTaxPlan = false then // normal year
    DataDirBox.Text := Ret[RetNo].SourceDataDir
  else
  begin // is taxplan
    If GetPlannerDir = '' then
      ShowMessage('The Planner directory has not been defined. See Configure');
    DataDirBox.Text := GetPlannerDir;
  end;

  Notes.Text := Ret[RetNo].Notes;
  s1 := 'See ADDINFO form';
  s2 := 'See PRIVATE Notepad';

  If (Notes.Text = s1) or (Notes.Text = s2) Or (Notes.Text = s1 + ', ' + s2)
  then
    Notes.Text := ''; { initialize it }

  If (Notes.Text = '') then
  begin
    If ((Ret[RetNo].FormHasData['ADDINFO'] = True) and
      (Ret[RetNo].FormHasData['PRIVAT#1'] = True)) then
      Notes.Text := s1 + ', ' + s2
    else If ((Ret[RetNo].FormHasData['ADDINFO'] = True) and
      (Ret[RetNo].FormHasData['PRIVAT#1'] = false)) then
      Notes.Text := s1
    else If ((Ret[RetNo].FormHasData['ADDINFO'] = false) and
      (Ret[RetNo].FormHasData['PRIVAT#1'] = True)) then
      Notes.Text := s2;
  end;

  For I := 0 to High(PrpStatusDescr) do
    StatusGroup.Items.Add(PrpStatusDescr[I]);
  For I := 0 to High(EfStatusDescr) do
    EFStatusGroup.Items.Add(EfStatusDescr[I]);

  If FetchElm(RetNo, 'STATUS', 4) > '' then
  begin
    StatusGroup.ItemIndex := MyStrToInt(FetchElm(RetNo, 'STATUS', 4));
    Ret[RetNo].PrpStatus := FetchElm(RetNo, 'STATUS', 4);
  end;
  If Ret[RetNo].PrpStatus = '' then
    Ret[RetNo].PrpStatus := '00';
  if Ret[RetNo].EFStatus = '' then
    Ret[RetNo].EFStatus := '00';
  StatusGroup.ItemIndex := StrToInt(Ret[RetNo].PrpStatus); { when retrieved }
  EFStatusGroup.ItemIndex := StrToInt(Ret[RetNo].EFStatus);
  Category.Text := FetchElm(RetNo, 'STATUS', 33);
  // 20161208 Igor >>>
  // fill loaded cloud helpers
  j := lblDirectoryNote.Top + lblDirectoryNote.Height;
  // 20180112 CON
  // 20190222 Igor >>>
  bShowShareList := false;
  MaxLeft := 0;
  with HelperManager do
  begin
    for I := 0 to HelperClassList.Count - 1 do
    begin
      if HelperManager.AllowSend(I) then
      begin
        LastLeft := 0;
        with TCheckBox.Create(Self) do
        begin
          Tag := I - 100;
          Parent := sbStorage;
          //20190506 Igor >>>
          //20190522 Igor >>>
          checked := HelperManager.Config(HelperClassList.Keys.ToArray[I].ClassName,
                     AppT1_2026.AppId, User.UserName).SaveReturnToCloud; //20161209 Igor //20170112 Igor
          if CheckIsCloud(true) then
            checked := true;
          //20190522 Igor <<<
          left := lblDirectory.Left;
          J := J + dh;
          Top :=  J - height;
          Caption := HelperClassList.Values.ToArray[I];
          onClick := HelperClick; //20161209 Igor
          // 20171225 igor >>>
          Width := GetTextWidth(Caption, Font) + dh;
          LastLeft := Left + Width + dh;
          // 20171225 igor <<<
        end;

        if HelperManager.AllowSetShare(I) then
        begin
          if (Trim(FetchElm(RetNo, 'INFO', 140)) <> '') then // 20171229 Igor
          begin
            with TCheckBox.Create(Self) do
            begin
              Tag := 1000 + I;
              Parent := sbStorage;
              checked := False;
              left := LastLeft; // 20171225 igor
              Top :=  J - height;
              // 20171225 igor >>>
              Caption := 'Share for client ('+Trim(FetchElm(RetNo, 'INFO', 140))+')';
              Width := GetTextWidth(Caption, Font) + dh;
              LastLeft := Left + Width + dh;
              // 20171225 igor <<<
            end;
          end;

          with TCheckBox.Create(Self) do
          begin
            bShowShareList := true;
            Tag := 2000 + I;
            Parent := sbStorage;
            Checked := False;
            Left := LastLeft;
            Top :=  J - height;
            Caption := 'Share with other people';
            Width := GetTextWidth(Caption, Font) + dh;
            //OnClick := cbShareWithPeopleClick;
            LastLeft := Left + Width;
          end;
        end;
        if LastLeft > MaxLeft then
          MaxLeft := LastLeft;
        Self.Height := Self.Height + dh;
      end;
    end;
  end;
  // 20171224 Igor <<<
  if bShowShareList then
  begin
    with TSpeedButton.Create(Self) do
    begin
      Tag := 1000;
      Parent := sbStorage;
      Left := LastLeft + dh;
      Top := lblDirectoryNote.Top + lblDirectoryNote.Height + dh - Height + 5;
      Caption := 'E-mail list';
      Width := GetTextWidth(Caption, Font) + dh;
      OnClick := sbShareWithPeopleClick;
      // Enabled := false;
    end;
    Self.Height := Self.Height + 15;
  end;
  // 20190222 Igor <<<
  // 20161208 Igor >>>

  // 20170113 Igor >>>
  if AppT1_2026.LicenseLevel in anyMulti then
  begin
    if User.UserName <> 'ADMIN' then
    begin
      DataDirBox.Text := OptRec.Dir_Cur;
      DataDirBox.ReadOnly := True;
    end;
  end;
  // 20171031 igor>>>
  if CheckIsCloud(true) then //20180503 Igor
  begin
    DataDirBox.ReadOnly := True;
  end;
  // 20171031 igor<<<
  // 20170113 Igor <<<
  btnDownload.Visible := CheckIsCloud(true); //20181130 Igor
end;

procedure TSaveAsT1_2026.HelperClick(Sender: TObject); // 20161209 Igor //20190222 Igor
// 20170126 Igor>>>
 var
 Helper: String;
begin
   Helper := HelperManager.HelperClassList.Keys.ToArray[(Sender as TCheckBox).Tag + 100].ClassName;
   HelperManager.Config(Helper, AppT1_2026.AppId, User.UserName).SaveReturnToCloud := (Sender as TCheckBox).Checked; //20170112 Igor
  // 20170126 Igor <<<
end;

procedure TSaveAsT1_2026.ClearBtnClick(Sender: TObject);
begin
  Notes.Text := '';
end;

procedure TSaveAsT1_2026.SaveBtnClick(Sender: TObject);
var
  I, j, nCloudsCount: integer; // 20161208 Igor //20180111 Igor
  Clouds: TArrayOfInteger; // 20161208 Igor
  Err: String; // 20170811 Igor
  OriginalSourceFileName: string; // 20171031 Igor
  bFound: boolean; // 20180111 Igor
begin
  // ShowMessage('Bfr SaveAs 2043A#1  '+FetchElm(RetNo,'T2043A#1',7)); //20220220
  // {$IFNDEF DEBUG} //20160327 Igor
  If FileExists(DataDirBox.Text + '\' + ClientsTable_dbf) then // 20160227 Igor
  begin
    DataDirBox.Text := OptRec.Dir_Cur; // 20160415 Igor
    ShowMessage
      ('The Data Directory is NOT compatible with the Multi-app version ' +
      'as it contains the old format of tax data' + Chr(13) +
      'The Data directory has been changed to ' + OptRec.Dir_Cur + Chr(13) +
      ' or you can change it to some other directory name of your choice');
    // ShowMessage(DataDirBox.Text + CHR(13)
    // +'The data directory is NOT compatible with the Multi-App version.'+#13+
    // 'Please use another data directory, such as ' + OptRec.Dir_Cur  +' in the  Save As  window');  //201602267 Igor
    Exit;
  end;
  // {$ENDIF} //20160327 Igor

  // 20170901 Igor>>>
  // If IsHomeUse then
  // begin
  // If ExceedsMaxReturnsAllowed then
  // begin
  // ShowMessage('Number of returns exceeds maximum allowed '
  // +'('+IntToStr(NetFileVersionReturns)+')'+
  // Chr(13)+' in the NetFile version');
  // // +Chr(13)+'Please delete some returns');
  // Exit;
  // end;
  // end;
  If not IsDataDirectoryGood(DataDirBox.Text) then Exit;
  // 20171031 Igor
  OriginalSourceFileName := RetList[RetNo].SourceFlName;
  RetList[RetNo].SourceFlName := FLNameBox.Text;
  try
    If AppT1_2026.ExceedsMaxReturnsAllowed(false) then
    begin
      // ShowMessage('Number of returns exceeds maximum allowed '
      // +'('+IntToStr(LimitedVersionReturns)+')'+
      // Chr(13)+' in the T1 Limited version');
      // +Chr(13)+'Please delete some returns');
      Exit;
    end;
  finally
    RetList[RetNo].SourceFlName := OriginalSourceFileName;
  end;
  // 20171031 Igor<<<

  If Not FileExists(DataDirBox.Text + '\' + ClientsDBLite) then
  begin
    // 20170811 Igor >>>
    If not InitDataBase(DataDirBox.Text, Err) then // 20171031 igor
    begin
      MessageDlg(Err, mtError, [mbOk], 0);
      Exit;
    end;
    // 20170811 Igor <<<
  end;

  // 20170902 Igor>>>
  // //20170502 Igor >>>
  // if CountClientsRecordWithoutThisReturnFile(AppT1_2026, DataDirBox.Text, FlNameBox.Text) >= AppT1_2026.LimitReturns then
  // begin
  // ShowMessage('Number of returns exceeds maximum allowed '
  // +'('+IntToStr(AppT1_2026.LimitReturns)+')'+
  // Chr(13)+' in the Limited version');
  // Exit;
  // end;
  // //20170502 Igor <<<

  // If IsDataDirectoryGood(DataDirBox.Text) = False then
  // exit;
  // 20170902 Igor<<<

  If (UpperCase(Leftstr(DataDirBox.Text, 1)) = 'A') or
    (UpperCase(Leftstr(DataDirBox.Text, 1)) = 'B') then
  begin
    If FileExists(DataDirBox.Text + '\' + ClientsDBLite) = false then
    begin
      // 20170811 Igor>>>
      If SysUtils.DirectoryExists(DataDirBox.Text) = false then
        SysUtils.ForceDirectories(DataDirBox.Text);
      If not InitDataBase(DataDirBox.Text, Err) then // 20171031 igor
      begin
        ShowMessage(Err);
        DataDirBox.Text := OptRec.Dir_Cur;
        Exit;
      end;
      // 20170811 Igor<<<
    end;
  end;

  If Ret[RetNo].Locked = True then
  begin
    ShowMessage('Cannot save. Return is locked' + Chr(13) +
      'You may use File | Unlock return');
    Exit;
  end;

  If CanStatusBeReady(RetNo, EFStatusGroup.ItemIndex, StatusGroup.ItemIndex) = false
  then
  begin
    ShowMessage('Cannot set Ready for Efile or Ready to Print' + Chr(13) +
      'unless you enter Invoice Amount and Type of Payment first');
    Exit;
  end;

  If (EFStatusGroup.ItemIndex = 1) and (IsReturnEFiled(RetNo) = false) then
  begin
    if MessageDlg('Return not set for Efile. Set it now?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
      StoreElm(RetNo, GetFormNo('T1'), 46, 'Y')
    else
      Exit;
  end;

  If (EFStatusGroup.ItemIndex = 1) and (IsReadyForEfile(RetNo) = false) then
  begin
    ShowMessage('Return not ready for Efile/Netfile' + Chr(13) +
      'Please fix errors or save as EFile not started');
    Exit;
  end;

  If FLNameBox.Text = '00000000.0' then
  begin
    if MessageDlg('File name is all zeros. Change file name to ' + Chr(13) +
      '8 characters of the Last Name plus First Name?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
    Begin
      FLNameBox.Text := Leftstr(GetLastName(RetNo), 8) + '.' +
        Leftstr(GetFirstName(RetNo), 1);
      Exit;
    end;
  end;
  If FileNameValid(FLNameBox.Text) = false then
  begin
    ShowMessage('You must specify a File Name' + Chr(13) +
      'of no more than 60 characters' + Chr(13) +   //20200914 Igor
      'i.e. xxxxxxxx.x or xxxxxxxx.xxx');
    FLNameBox.SetFocus;
    Exit;
  End;
  If not SysUtils.DirectoryExists(DataDirBox.Text) then // 20170811 Igor
  begin
    ShowMessage('Directory does not exist');
    DataDirBox.SetFocus;
    Exit;
  End;
  If FileExists(DataDirBox.Text + '\' + ClientsDBLite) = false then
  begin
    ShowMessage('Directory was not initialized for tax returns');
    DataDirBox.SetFocus;
    Exit;
  End;

  if Ret[RetNo].Frm[GetFormNo('STATUS')].Count = 0 then
  begin
    InitFormData(RetNo, GetFormNo('STATUS'));
    InitStatusForm(RetNo, GetFormNo('STATUS'));
  end;

  { put changed STATUS form data }
  with Ret[RetNo].Frm[GetFormNo('STATUS')] do
  begin
    Strings[4] := PrpStatusCodes[StatusGroup.ItemIndex];
    Strings[15] := EFStatusCodes[EFStatusGroup.ItemIndex];
    Ret[RetNo].PrpStatus := Strings[4];
    Ret[RetNo].EFStatus := Strings[15];
    Strings[14] := Notes.Text;
    { last update }
    Strings[11] := User.UserName; // 20170112 Igor
    Strings[12] := FormatDateTime('yyyy-mm-dd', Now);
    { DateToStr(Date); }
    Strings[13] := TimeToStr(Time);
    //20210115 Igor >>>
    if IsVtClient and not SameText(Strings[33], Category.Text) and SameText(Category.Text, vtClientCreated) then
      ShowMessageWarning('You should not edit return, unless you never send it to your Tax Preparer');
    //20210115 Igor <<<
    Strings[33] := Category.Text;
  end;

  If (StatusGroup.ItemIndex = 0) and (IsReturnPaid(RetNo)) then
    if MessageDlg('Return has been paid. Should status be WIP? ', mtInformation,
      [mbYes, mbNo], 0) = mrNo then
      Exit;

  CalcUsedFrm(RetNo);
  Screen.cursor := crHourGlass;
  // 20161208 Igor >>>
  SetLength(Clouds, 0);
  for I := 0 to sbStorage.ControlCount - 1 do
  begin
    if (sbStorage.Controls[I] is TCheckBox) and
      (sbStorage.Controls[I] as TCheckBox).Checked and
      ((sbStorage.Controls[I] as TCheckBox).Tag < 0) then // 20171215 Igor
    begin
      SetLength(Clouds, length(Clouds) + 1);
      Clouds[length(Clouds) - 1] := (sbStorage.Controls[I] as TCheckBox)
        .Tag + 100
    end;
    // 20180111 Igor >>>
  end;
  nCloudsCount := length(Clouds);
  for I := 0 to sbStorage.ControlCount - 1 do
  begin
    // 20171215 Igor>>
    if (sbStorage.Controls[I] is TCheckBox) and
      (sbStorage.Controls[I] as TCheckBox).Checked and
      ((sbStorage.Controls[I] as TCheckBox).Tag >= 1000) then
    begin
      bFound := false;
      for j := 0 to nCloudsCount - 1 do
        if (((sbStorage.Controls[I] as TCheckBox).Tag < 2000) and
          (Clouds[j] = (sbStorage.Controls[I] as TCheckBox).Tag - 1000)) or
          (((sbStorage.Controls[I] as TCheckBox).Tag >= 2000) and
          (Clouds[j] = (sbStorage.Controls[I] as TCheckBox).Tag - 2000)) then
        begin
          bFound := True;
          break;
        end;

      if not bFound then
      begin
        Screen.cursor := crDefault; // 20171224 Igor
        ShowMessage('Please, check cloud first');
        Exit;
      end;
      SetLength(Clouds, length(Clouds) + 1);
      Clouds[length(Clouds) - 1] := (sbStorage.Controls[I] as TCheckBox).Tag;
    end;
    // 20171215 Igor<<
    // 20171224 Igor >>>
    //20190222 Igor >>>

      if (sbStorage.Controls[I] is TCheckBox) and
      (sbStorage.Controls[I] as TCheckBox).Checked and
      ((sbStorage.Controls[I] as TCheckBox).Tag = 1000) then
      begin
	    if Length(Clouds) = 0 then
	    begin
	      Screen.cursor:=crDefault;
	      ShowMessage('Please, check cloud first');
	      Exit;
	    end;
	    SetLength(Clouds, length(Clouds) + 1);
        Clouds[Length(Clouds) - 1] := (sbStorage.Controls[I] as TCheckBox).Tag;
      end;
    //20190222 Igor <<<

    // 20171224 Igor <<<
  end;
  // 20161208 Igor <<<
  // 20180111 Igor <<<

  If SaveReturn(RetNo, DataDirBox.Text, FLNameBox.Text, false, True, false,
    True, Clouds) = 0 then // 20161208 Igor
  begin
   //20190506 Igor >>>
    //if run in browser and "Dropbox" checked
    if CheckIsCloud(true) and IsCloudStorageEnabled then begin
      TFile.Delete(TPath.Combine(DataDirBox.Text, FLNameBox.Text));
    end;
    //20190506 Igor <<<

    Ret[RetNo].SourceDataDir := DataDirBox.Text;
    Ret[RetNo].SourceFlName := FLNameBox.Text;
    If (LicenseLevel in anyMulti) and (Vl(FetchElm(RetNo, 'FPCHECK', 35)) > 0)
    then
      UpdateFpAssist(RetNo, DataDirBox.Text, FLNameBox.Text);
    AddLogAppMon(amtOnSave, RetNo); // 20180712 Igor    //20210619   //20220518 Igor //20220519 Igor
    Close;
    If (LicenseLevel = llPower) or (LicenseLevel in anyMulti) then
      BuildSuperEntries(DataDirBox.Text + '\' + FLNameBox.Text); // new
    // 20181130 Igor >>>
    if (Sender = btnDownload) and CheckIsCloud(true) then
      DownloadFile(TPath.Combine(DataDirBox.Text, FLNameBox.Text), FLNameBox.Text);
    // 20181130 Igor <<<
  end
  else
  begin
    ShowMessage('Return was not saved... Press any key');
    Screen.cursor := crDefault;
    Exit;
  end;

  Screen.cursor := crDefault;
end;

procedure TSaveAsT1_2026.SaveCloseBtnClick(Sender: TObject);
begin
  SaveBtnClick(Sender);
  CloseReturn(RetNo);
end;

procedure TSaveAsT1_2026.sbShareWithPeopleClick(Sender: TObject);
// 201271225 igor
var
  cEmails: string;
begin
  cEmails := FetchElm(RetNo, 'STATUS', SHARE_WITH_PEOPLE);
  if ShareToPeople(RetNo, cEmails) then
    StoreElm(RetNo, 'STATUS', SHARE_WITH_PEOPLE, cEmails);
end;

procedure TSaveAsT1_2026.DoNotSaveBtnClick(Sender: TObject);
begin
  Close; { release; }
end;

procedure TSaveAsT1_2026.FormPaint(Sender: TObject);
begin
  // SaveBtn.SetFocus; 20150820 igor
end;

procedure TSaveAsT1_2026.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key = VK_F3 then
    SaveBtnClick(Application);
end;

procedure TSaveAsT1_2026.HelpBtnClick(Sender: TObject);
begin
  ShowHelp('T1Help', 'Save_a_return');
end;

procedure TSaveAsT1_2026.DataDirBoxExit(Sender: TObject);
// 20170811 Igor>>>
var
  Err: String;
begin
  If DataDirBox.Text = OptRec.Dir_Cur then
    Exit;

  If FileExists(IncludeTrailingPathDelimiter(DataDirBox.Text) + ClientsTable_dbf)
  then // 20160227 Igor
  begin
    ShowMessage(DataDirBox.Text + Chr(13) +
      'The data directory is NOT compatible with the Multi-App version.' + #13 +
      'Please use another data directory, such as ' + OptRec.Dir_Cur +
      ' in the  Save As  window'); // 201602267 Igor
    DataDirBox.Text := OptRec.Dir_Cur;
    DataDirBox.Refresh;
    Exit;
  end;

  If not IsDataDirectoryGood(DataDirBox.Text) then
  begin
    DataDirBox.Text := OptRec.Dir_Cur;
    DataDirBox.Refresh;
    Exit;
  end;

  // 20180209 Igor >>>
  If Not FileExists(DataDirBox.Text + '\' + ClientsDBLite) then
  begin
    If not InitDataBase(DataDirBox.Text, Err) then
    begin
      MessageDlg(Err, mtError, [mbOk], 0);
      Exit;
    end;
  end;
  // 20180209 Igor <<<

  If (ChangeDataDir(DataDirBox.Text) = false) then
  begin
    DataDirBox.Text := OptRec.Dir_Cur;
    DataDirBox.Refresh;
    Exit;
  end
  else
  begin
    If not AllowedToChangeSaveDir(DataDirBox.Text) then
    begin
      DataDirBox.Text := OptRec.Dir_Cur;
      DataDirBox.Refresh;
      Exit;
    end;
  end;
  // 20170811 Igor<<<
end;

procedure TSaveAsT1_2026.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
  If Key = #13 then
    DataDirBoxExit(Application);
end;

procedure TSaveAsT1_2026.BrowseBtnClick(Sender: TObject);
Var
  DirSelected: String;
begin
  {
  // 20171031 igor>>>
  if StartParams.isCloud then
  begin
    MessageDlg(c_NotAvailable, mtInformation, [mbOk], 0);
    Exit;
  end;
  // 20171031 igor<<<
  }
  if CheckIsCloud then Exit; //20180503 Igor
  // 20170113 Igor >>>
  if AppT1_2026.LicenseLevel in anyMulti then
    if User.UserName <> 'ADMIN' then
      if not YouknowTheAdminPassword then
        Exit;
  // 20170113 Igor <<<

  if SelectDirectory('Select a folder:', '', DirSelected) then
  // 20170811 Igor>>>
  begin
    DataDirBox.Text := DirSelected;
    DataDirBoxExit(DataDirBox);
  end;
  // 20170811 Igor<<<
end;

end.
