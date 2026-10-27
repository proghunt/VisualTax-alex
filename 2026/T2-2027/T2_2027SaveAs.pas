unit T2_2027saveas;
//revision 2014-07-29

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons,ExtCtrls;

type
  TSaveAsT2_2027 = class(TForm)
    Panel1: TPanel;
    StatusGroup: TRadioGroup;
    Panel2: TPanel;
    FLNameBox: TEdit;
    Label1: TLabel;
    DataDirBox: TEdit;
    noteslbl: TLabel;
    ClearBtn: TBitBtn;
    RetNameLbl: TLabel;
    Label2: TLabel;
    Notes: TEdit;
    RadioGroup1: TRadioGroup;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    HelpBtn: TBitBtn;
    Panel5: TPanel;
    Label6: TLabel;
    SelectCurBtn: TBitBtn;
    sbStorage: TScrollBox;
    FileNameFormat: TRadioGroup;
    Label3: TLabel;
    Label4: TLabel;
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure SaveCloseBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure SelectCurBtnClick(Sender: TObject);
    {procedure BitBtn2Click(Sender: TObject);}
    // 20190228 Igor >>>
    procedure cbShareWithPeopleClick(Sender: TObject);
    procedure sbShareWithPeopleClick(Sender: TObject);
    procedure HelperClick(Sender: TObject); // 20190228 Igor <<<
    procedure FileNameFormatClick(Sender: TObject); //20201013 Igor
  private
    FRetNo: integer;
  public
    property RetNo: integer read FRetNo;
  end;

Const HelpTopic='Save_a_return';

var
  SaveAsT2_2027: TSaveAsT2_2027;

implementation

{$R *.DFM}

uses
  vtMulti,vtCommon,
  T2_2027,T2_2027ChildWinNew,T2_2027Declare,T2_2027Common,
  T2_2027Common2,T2_2027TrimStr,T2_2027Features,T2_2027Calc,
//T2_2027SelectDir,
  vtHelperManager, vtShareToPeople, //20190228 Igor
  vtTrimStr,vtShared, vtDialogs; //20170113 Igor


procedure TSaveAsT2_2027.CancelBtnClick(Sender: TObject);
begin
release;
end;

procedure TSaveAsT2_2027.FileNameFormatClick(Sender: TObject); //20201013 Igor
begin
  FLNameBox.Text := GenerateReturnFileName(RetNo, IntToStr(FileNameFormat.ItemIndex));
end;

procedure TSaveAsT2_2027.FormCreate(Sender: TObject);
var
  i: integer;
  // 20190228 Igor >>>
  LastLeft, MaxLeft, a, j: integer;
  bShowShareList: boolean;

const dh = 20;

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
  // 20190228 Igor <<<
begin
  FileNameFormat.ItemIndex:=0;   //20201212 CON
  FRetNo:=GetCurrentRetNo;
  RetNameLbl.Caption := GetRetName(RetNo);
  RetNameLbl.Color := GetRetColor(RetNo);
  //20190312 Igor >>>
  if FileNameValid(Ret[RetNo].SourceFlName) then
    FLNameBox.Text := Ret[RetNo].SourceFlName; { GetRetFlName(RetNo); }
  //20190312 Igor <<<
  //20201013 Igor >>>
  FileNameFormat.ItemIndex:= StrToIntDef(OptRec.FileNameFormat, 0);
  If FLNameBox.Text = '' then
    FLNameBox.Text := GenerateReturnFileName(RetNo, IntToStr(FileNameFormat.ItemIndex));
  //20201013 Igor <<<
//   LeftStr(GetAccountNumber(RetNo),8)             //20160302 Igor
//   +'.'+MidStr(GetTaxationYearEnd(RetNo),3,2);    //20160305 Igor

  DataDirBox.Text := Ret[RetNo].SourceDataDir;

  If DataDirBox.Text ='' then
    DataDirBox.Text := OptRec.Dir_Cur;
  Notes.Text := Ret[RetNo].Notes;
  If (Notes.Text = '') and
     (Ret[RetNo].FrmHasData[GetFormNo('ADDINFO')]) = True
   then Notes.Text := '(See ADDINFO form)';

  For i :=0 to High(PrpStatusDescr) do
       StatusGroup.Items.Add(PrpStatusDescr[i]);
  If Ret[RetNo].PrpStatus = '' then Ret[RetNo].PrpStatus := '00';

  If GetEFileConfirmationNo(RetNo) >'' then
    Ret[RetNo].PrpStatus := '09';

  StatusGroup.ItemIndex := StrToInt(Ret[RetNo].PrpStatus); {when retrieved}

  // 20190228 Igor >>>
  bShowShareList := false;
  MaxLeft := 0;
  j := 0;
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
          checked := HelperManager.Config(HelperClassList.Keys.ToArray[I].ClassName,
            AppT2.AppId, User.UserName).SaveReturnToCloud;
          left := 10;
          J := J + dh;
          Top :=  J - height;
          Caption := HelperClassList.Values.ToArray[I];
          onClick := HelperClick;
          Width := GetTextWidth(Caption, Font) + dh;
          LastLeft := Left + Width + dh;
        end;

        if HelperManager.AllowSetShare(I) then
        begin
          if (Trim(FetchElm(RetNo, 'INFO', 140)) <> '') then
          begin
            with TCheckBox.Create(Self) do
            begin
              Tag := 1000 + I;
              Parent := sbStorage;
              checked := False;
              left := LastLeft;
              Top :=  J - height;
              Caption := 'Share for client ('+Trim(FetchElm(RetNo, 'INFO', 140))+')';
              Width := GetTextWidth(Caption, Font) + dh;
              LastLeft := Left + Width + dh;
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
  if bShowShareList then
  begin
    with TSpeedButton.Create(Self) do
    begin
      Tag := 1000;
      Parent := sbStorage;
      Left := LastLeft + dh;
      Top := dh - Height + 5;
      Caption := 'E-mail list';
      Width := GetTextWidth(Caption, Font) + dh;
      OnClick := sbShareWithPeopleClick;
    end;
    Self.Height := Self.Height + 15;
  end;
  // 20190228 Igor <<<

  //20170113 Igor >>>
  if AppT2.LicenseLevel in anyMulti then
  begin
    if User.UserName <> 'ADMIN' then
    begin
      DataDirBox.Text := OptRec.Dir_Cur;
      DataDirBox.ReadOnly := True;
    end;
  end;
  //20170113 Igor <<<
 //20180503 Igor >>>
  if CheckIsCloud(true) then
  begin
    DataDirBox.ReadOnly := True;
  end;
  //20180503 Igor <<<
end;

procedure TSaveAsT2_2027.cbShareWithPeopleClick(Sender: TObject);
var
  I: integer;
begin
  if not(Sender is TCheckBox) then
    Exit;
  for I := 0 to sbStorage.ControlCount - 1 do
    if (sbStorage.Controls[I] is TSpeedButton) and
      ((sbStorage.Controls[I] as TSpeedButton).Tag = 1000) then
    begin
      (sbStorage.Controls[I] as TSpeedButton).Enabled := (Sender as TCheckBox).Checked;
      break;
    end;
end;

procedure TSaveAsT2_2027.ClearBtnClick(Sender: TObject);
begin
 Notes.Text := '';
end;

procedure TSaveAsT2_2027.SaveBtnClick(Sender: TObject);
//20170811 Igor>>>
var
  FNo: Integer;
  UserName: string;
  Dt: TDateTime; {Var YYYY,MM,DD:Word;}
  Err: string;
  OriginalSourceFileName: string;//20171031 Igor
  //20190228 Igor >>>
  I, j, nCloudsCount: integer;
  Clouds: TArrayOfInteger;
  bFound: boolean;
  //20190228 Igor <<<
begin
 //20090721
  if IsReturnLocked(RetNo) then
    if MessageDlg('This return is locked. Save it?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      Exit;

  if FlNameBox.Text = '' then
  begin
    ShowMessage('You must specify a File Name');
    FlNameBox.SetFocus;
    Exit;
  end;

  if FileExists(DataDirBox.Text + '\' + ClientsTable_dbf) then //20160227 Igor
  begin
    DataDirBox.Text := OptRec.Dir_cur; //20160415 Igor
    ShowMessage('The Data Directory is NOT compatible with the Multi-app version ' +
                'as it contains the old format of tax data' + Chr(13) +
                'The Data directory has been changed to ' + OptRec.Dir_cur + Chr(13) +
                ' or you can change it to some other directory name of your choice');
    exit;
  end;

  if IsDataDirectoryGood(DataDirBox.Text) = False then
    exit;
  if Length(FlNameBox.Text) > 50 then  //20201015 igor
  begin
    ShowMessage('Please use a short file name, up to 50 characters'); //20201015 Igor
    Exit;
  end;
  //20171031 Igor
  OriginalSourceFileName := RetList[RetNo].SourceFlName;
  RetList[RetNo].SourceFlName := FlNameBox.Text;
  try
    if AppT2.ExceedsMaxReturnsAllowed(false) then
    begin
  //    ShowMessage('Number of returns exceeds maximum allowed ' + '(' + IntToStr(LimitedVersionReturns) + ')' + Chr(13) + ' in the Limited version of the program');
      Exit;
    end;
  finally
    RetList[RetNo].SourceFlName := OriginalSourceFileName;
  end;
  //20171031 Igor<<<

  if (DataDirBox.Text = 'A:') or (DataDirBox.Text = 'B:') then
  begin
    ShowMessage('Sub-directory required such as a:\data');
    Exit;
  end;

  if not FileExists(DataDirBox.Text + '\' + ClientsDBLite) then //20150922 Igor
  begin
    if not InitDataBase(AppDir, DataDirBox.Text, Err) then
    begin
      ShowMessage(Err);
      DataDirBox.Text := OptRec.Dir_Cur;
      Exit;
    end;
  end;
//20170902 Igor>>>
//  //20170502 Igor >>>
//  if CountClientsRecordWithoutThisReturnFile(AppT2, DataDirBox.Text, FlNameBox.Text) >= AppT2.LimitReturns then
//  begin
//    ShowMessage('Number of returns exceeds maximum allowed ' + '(' + IntToStr(AppT2.LimitReturns) + ')' + Chr(13) +
//                ' in the Limited version');
//    Exit;
//  end;
//  //20170502 Igor <<<
//20170902 Igor<<<

  if Ret[RetNo].Frm[GetFormNo('STATUS')].Count = 0 then
  begin
    InitFormData(RetNo, GetFormNo('STATUS'));
    InitStatusForm(RetNo, GetFormNo('STATUS'));
  end;

  {put changed STATUS form data}
  FNo := GetFormNo('STATUS');
  StoreElm(RetNo, FNo, 4, PrpStatusCodes[StatusGroup.ItemIndex]);
  StoreElm(RetNo, FNo, 11, UserName);
  StoreElm(RetNo, FNo, 12, FormatDateTime('yyyy/mm/dd', Date));
  StoreElm(RetNo, FNo, 13, TimeToStr(Time));
  StoreElm(RetNo, FNo, 14, Notes.Text);   //20131016

  //20190228 Igor >>>
  SetLength(Clouds, 0);
  for I := 0 to sbStorage.ControlCount - 1 do
  begin
    if (sbStorage.Controls[I] is TCheckBox) and
      (sbStorage.Controls[I] as TCheckBox).Checked and
      ((sbStorage.Controls[I] as TCheckBox).Tag < 0) then
    begin
      SetLength(Clouds, length(Clouds) + 1);
      Clouds[length(Clouds) - 1] := (sbStorage.Controls[I] as TCheckBox).Tag + 100
    end;
  end;
  nCloudsCount := length(Clouds);
  for I := 0 to sbStorage.ControlCount - 1 do
  begin
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
        Screen.cursor := crDefault;
        ShowMessage('Please, check cloud first');
        Exit;
      end;
      SetLength(Clouds, length(Clouds) + 1);
      Clouds[length(Clouds) - 1] := (sbStorage.Controls[I] as TCheckBox).Tag;
    end;

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
  end;
  // 20190228 Igor <<<

  CalcUsedFrm(RetNo);
  if SaveReturn(RetNo, DataDirBox.Text, FlNameBox.Text, False, True, False, True, Clouds) = 0 then //20190228 Igor
  begin
    Ret[RetNo].SourceDataDir := DataDirBox.Text;
    Ret[RetNo].SourceFlName := FlNameBox.Text;
    AddLogAppMon(amtOnSave, RetNo); // 20180712 Igor //20220519 Igor
    Close;
    if LicenseLevel in [llPower..llMultiPower] then
      BuildSuperEntries(DataDirBox.Text + '\' + FlNameBox.Text); //new
  end
  else
  begin
    ShowMessage('Return was not saved... Press any key');
    exit;
  end;
//20170811 Igor<<<
end;

procedure TSaveAsT2_2027.SaveCloseBtnClick(Sender: TObject);
begin
 SaveBtnClick(Sender);
 CloseReturn(RetNo);
end;

procedure TSaveAsT2_2027.sbShareWithPeopleClick(Sender: TObject);
var
  cEmails: string;
begin
  cEmails := FetchElm(RetNo, 'STATUS', SHARE_WITH_PEOPLE);
  if ShareToPeople(RetNo, cEmails) then
    StoreElm(RetNo, 'STATUS', SHARE_WITH_PEOPLE, cEmails);
end;

procedure TSaveAsT2_2027.HelpBtnClick(Sender: TObject);
begin
ShowHelp('T2Help',HelpTopic);
end;


procedure TSaveAsT2_2027.HelperClick(Sender: TObject); //20190228 Igor
var
  Helper: String;
begin
  Helper := HelperManager.HelperClassList.Keys.ToArray[(Sender as TCheckBox).Tag + 100].ClassName;
  HelperManager.Config(Helper, AppT2.AppId, User.UserName).SaveReturnToCloud := (Sender as TCheckBox).Checked;
end;

procedure TSaveAsT2_2027.SelectCurBtnClick(Sender: TObject);
Var DirSelected:String;
begin
  if CheckIsCloud then Exit; //20180503 Igor
  //20170113 Igor >>>
  if AppT2.LicenseLevel in anyMulti then
    if User.UserName <> 'ADMIN' then
      if not YouknowTheAdminPassword then
        exit;
  //20170113 Igor <<<

 if SelectDirectory('Select a folder:', '', DirSelected) then
 begin
    If FileExists(DataDirBox.Text+'\'+ClientsTable_dbf) then //20160227 Igor
    begin
      ShowMessage(DirSelected + CHR(13)
                +'The data directory is NOT compatible with the Multi-App version.'+#13+
                 'Please use another data directory, such as ' + OptRec.Dir_Cur  +' in the  Save As  window');  //201602267 Igor
      exit;
    end;

  DataDirBox.Text := DirSelected;
  //DataDirBoxExit(Sender);
  //SearchBox.SetFocus;
 end;
 (*
 Application.CreateForm(TSelectDir,SelectDir);
 SelectDir.ShowModal;
 SelectDir.Free;
 If SelectedDir >'' then
 begin
  DataDirBox.Text := SelectedDir;
 end;
 *)
end;

end.
