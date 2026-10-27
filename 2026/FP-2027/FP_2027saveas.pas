unit FP_2027saveas;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons,ExtCtrls; //20150819 Igor

type
  TSaveAsFP_2012 = class(TForm)
    Panel1: TPanel;
    StatusGroup: TRadioGroup;
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
    Label6: TLabel;
    sbStorage: TScrollBox;
    Label3: TLabel; //20190228 Igor
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure SaveCloseBtnClick(Sender: TObject);
    procedure DoNotSaveBtnClick(Sender: TObject);
    {procedure BitBtn2Click(Sender: TObject);}
    procedure FormPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure HelpBtnClick(Sender: TObject);
    procedure DataDirBoxExit(Sender: TObject);
    procedure DataDirBoxKeyPress(Sender: TObject; var Key: Char);
    // 20190228 Igor >>>
    procedure cbShareWithPeopleClick(Sender: TObject);
    procedure sbShareWithPeopleClick(Sender: TObject);
    procedure HelperClick(Sender: TObject);
    // 20190228 Igor <<<
  private
    { Private declarations }
  public
    RetNo:Integer;
  end;

var
  SaveAs: TSaveAsFP_2012;

implementation

{$R *.DFM}

uses vtMulti,vtCommon,vtDialogs,FP_2027,FP_2027Declare,FP_2027Common,
  FP_2027Common2,FP_2027TrimStr,FP_2027Features,FP_2027ChildWinNEW,vtTrimStr,
  vtHelperManager, vtShareToPeople, //20190228 Igor
  vtShared;

procedure TSaveAsFP_2012.CancelBtnClick(Sender: TObject);
begin
release;
end;

procedure TSaveAsFP_2012.FormCreate(Sender: TObject);
var
i : integer;s1,s2:string;
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
 RetNo:=GetCurrentRetNo;
 RetNameLbl.Caption := GetRetName(RetNo);
 RetNameLbl.Color := GetRetColor(RetNo);
 if FileNameValid(Ret[RetNo].SourceFlName) then  //20220306
    FLNameBox.Text := Ret[RetNo].SourceFlName { GetRetFlName(RetNo); }
 else
 FlNameBox.Text := MkFileName(RetNo); //ReRet[RetNo]^.SourceFlName; {GetRetFlName(RetNo);}

 If FlNameBox.Text = '' then FlNameBox.Text := MkFileName(RetNo);
  // LeftStr(FetchElm(RetNo,'PROFILE',3),8)+'.'+RightStr(FetchElm(RetNo,'PROFILE',3),1);

 DataDirBox.Text := Ret[RetNo].SourceDataDir;
 If DataDirBox.Text='' then DataDirBox.Text:=OptRec.Dir_cur;

 Notes.Text := Ret[RetNo].Notes;
 s1 := 'See ADDINFO form';
 s2 := 'See PRIVATE Notepad';

 If (Notes.Text = S1) or (Notes.Text = S2) Or (Notes.Text = S1+', '+S2)
  then Notes.Text :=''; {initialize it}

 If (Notes.Text = '') then
 begin
  If ((Ret[RetNo].FrmHasData[GetFormNo('ADDINFO')] = True) and
     (Ret[RetNo].FrmHasData[GetFormNo('PRIVAT#1')] = True))
    then Notes.Text := S1+', '+S2
  else
  If ((Ret[RetNo].FrmHasData[GetFormNo('ADDINFO')] = True) and
      (Ret[RetNo].FrmHasData[GetFormNo('PRIVAT#1')] = False))
    then Notes.Text := S1
  else
  If ((Ret[RetNo].FrmHasData[GetFormNo('ADDINFO')] = False) and
     (Ret[RetNo].FrmHasData[GetFormNo('PRIVAT#1')] = True))
    then Notes.Text := S2;
 end;

 For i :=0 to High(PrpStatusDescr) do StatusGroup.Items.Add(PrpStatusDescr[i]);

 If FetchElm(RetNo,'STATUS',4) >'' then
 begin
   StatusGroup.ItemIndex:=MyStrToInt(FetchElm(RetNo,'STATUS',4));
   Ret[RetNo].PrpStatus :=FetchElm(RetNo,'STATUS',4);
 end;
 If Ret[RetNo].PrpStatus = '' then Ret[RetNo].PrpStatus := '00';
 //if Ret[RetNo].EFStatus = '' then Ret[RetNo].EFStatus := '00';
 StatusGroup.ItemIndex := StrToInt(Ret[RetNo].PrpStatus); {when retrieved}
// EFStatusGroup.ItemIndex := StrToInt(Ret[RetNo].EFStatus);
// Category.Text:=FetchElm(RetNo,'STATUS',33);

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
            AppFP.AppId, User.UserName).SaveReturnToCloud;
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

 //20180503 Igor >>>
 if CheckIsCloud(true) then
 begin
   DataDirBox.ReadOnly := True;
 end;
 //20180503 Igor <<<
end;

procedure TSaveAsFP_2012.cbShareWithPeopleClick(Sender: TObject); //20190228 Igor
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

procedure TSaveAsFP_2012.ClearBtnClick(Sender: TObject);
begin
 Notes.Text := '';
end;

procedure TSaveAsFP_2012.SaveBtnClick(Sender: TObject);
//20171031 Igor>>>
var
  OriginalSourceFileName: string;
//20171031 Igor<<<
  //20190228 Igor >>>
  I, j, nCloudsCount: integer;
  Clouds: TArrayOfInteger;
  bFound: boolean;
  //20190228 Igor <<<
begin
 If (LicenseLevel = llDemo) // 'FP Demo')
 then
 begin
  ShowMessage('The FP Demo program does not allow data to be saved');
   Exit;
 end;
//20170901 Igor>>>
// If ExceedsMaxReturnsAllowed then
//  begin
//   ShowMessage('Number of files exceeds maximum allowed '
//   +'('+IntToStr(LimitedVersionReturns)+')'+
//   Chr(13)+' in the FP Limited version'
//   +Chr(13)+'Please delete some files');
//   Exit;
//  end;
//20170901 Igor<<<

//{$IFNDEF DEBUG} //20160327 Igor
  If FileExists(DataDirBox.Text+'\'+ClientsTable_dbf) then //20160227 Igor
  begin
    DataDirBox.Text := OptRec.Dir_cur; //20160415 Igor
    ShowMessage('The Data Directory is NOT compatible with the Multi-app version '+
                'as it contains the old format of tax data' + Chr(13) +
                'The Data directory has been changed to ' + OptRec.Dir_cur + Chr(13) +
                ' or you can change it to some other directory name of your choice');
//              DataDirBox.Text + CHR(13)
//              +'The data directory is NOT compatible with the Multi-App version.'+#13+
//               'Please use another data directory, such as ' + OptRec.Dir_Cur  +' in the  Save As  window');
    exit;
  end;
//{$ENDIF} //20160327 Igor
//20160316 Igor

//20170901 Igor>>>
  If not IsDataDirectoryGood(DataDirBox.Text) then
    exit;
  //20171031 Igor>>>
  OriginalSourceFileName := RetList[RetNo].SourceFlName;
  RetList[RetNo].SourceFlName := FlNameBox.Text;
  try
    If AppFP.ExceedsMaxReturnsAllowed(False) then
      Exit;
  finally
    RetList[RetNo].SourceFlName := OriginalSourceFileName;
  end;
  //20171031 Igor<<<

 If Not FileExists(DataDirBox.text + '\' + ClientsDBLite) then
 begin
   If not DirectoryExists(DataDirBox.Text) then //20160518 Igor
     ForceDirectories(DataDirBox.Text);
   If InitDataBase(AppDir,DataDirBox.Text)=false then Exit;
 end;

//20170902 Igor>>>
//  //20170502 Igor >>>
//  if CountClientsRecordWithoutThisReturnFile(AppFP, DataDirBox.Text, FlNameBox.Text) >= AppFP.LimitReturns then
//  begin
//    ShowMessage('Number of returns exceeds maximum allowed '
//        +'('+IntToStr(AppFP.LimitReturns)+')'+
//        Chr(13)+' in the Limited version');
//    Exit;
//  end;
//  //20170502 Igor <<<
//If IsDataDirectoryGood(DataDirBox.Text) = False then exit;
//20170902 Igor<<<

If (UpperCase(Leftstr(DataDirBox.Text,1)) ='A')
 or (UpperCase(Leftstr(DataDirBox.Text,1)) ='B') then
 begin
  If FileExists(DataDirBox.Text+'\'+ ClientsDBLite) = false then // 20150922 Igor
  begin
   If DirectoryExists(DataDirBox.Text) = false then ForceDirectories(DataDirBox.Text);
   If InitDataBase(AppDir,DataDirBox.Text) = false then
     begin
       ShowMessage('Data directory '+DataDirBox.Text + ' cannot be initialized');
       DataDirBox.Text := OptRec.Dir_Cur;
       Exit;
     end;
  end;
 end;


If Ret[RetNo].Locked = true then
 begin
 ShowMessage('Cannot save. File is locked'+
   chr(13)+'You may use File | Unlock file');
 exit;
 end;


If DirectoryExists(DataDirBox.Text) = False then
  begin
   ShowMessage('Directory does not exist');
   DataDirBox.SetFocus;
   Exit;
  End;
If FileExists(DataDirBox.Text+'\'+ClientsDBLite) = False then // 20150922 Igor
  begin
   ShowMessage('Directory was not initialized for FP files');
   DataDirBox.SetFocus;
   Exit;
  End;

 if Ret[RetNo].Frm[GetFormNo('STATUS')].Count = 0 then
  begin
   InitFormData(RetNo,GetFormNo('STATUS'));
   InitStatusForm(RetNo,GetFormNo('STATUS'));
  end;

{put changed STATUS form data}
 with Ret[RetNo].Frm[GetFormNo('STATUS')] do
 begin
  Strings[4]  := PrpStatusCodes[StatusGroup.ItemIndex];
  Ret[RetNo].PrpStatus:=Strings[4];
  Strings[14] := Notes.Text;
  {last update}
  Strings[11] := User.UserName; //20170112 Igor
  Strings[12] := FormatDateTime('yyyy-mm-dd',Now);
  Strings[13] := TimeToStr(Time);
 end;

 If (StatusGroup.ItemIndex =0) and (IsReturnPaid(RetNo)) then
  if MessageDlg('Client plan has been paid. Should status be WIP? ',
    mtInformation, [mbYes, mbNo], 0) = mrNo then
    exit;

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

 Screen.cursor:=crHourGlass;
 If SaveReturn(RetNo,DataDirBox.Text,FlNameBox.Text,False,True,False,True,Clouds) = 0 then //20190228
    begin
     Ret[RetNo].SourceDataDir := DataDirBox.Text;
     Ret[RetNo].SourceFlName := FlNameBox.Text;
     AddLogAppMon(amtOnSave, RetNo); // 20180712 Igor //20220519 Igor
     ShowTimedMsg('Saved',1400);
     Close;
    end
  else
     begin
      ShowMessage('File was not saved... Press any key');
      Screen.cursor:=crDefault;
      exit;
     end;
  Screen.cursor:=crDefault;
end;

procedure TSaveAsFP_2012.SaveCloseBtnClick(Sender: TObject);
begin
 SaveBtnClick(Sender);
 CloseReturn(RetNo,True);
end;

procedure TSaveAsFP_2012.sbShareWithPeopleClick(Sender: TObject); //20190228 Igor
var
  cEmails: string;
begin
  cEmails := FetchElm(RetNo, 'STATUS', SHARE_WITH_PEOPLE);
  if ShareToPeople(RetNo, cEmails) then
    StoreElm(RetNo, 'STATUS', SHARE_WITH_PEOPLE, cEmails);
end;

procedure TSaveAsFP_2012.DoNotSaveBtnClick(Sender: TObject);
begin
Close; {release;}
end;
procedure TSaveAsFP_2012.FormPaint(Sender: TObject);
begin
//SaveBtn.SetFocus; //20190228 Igor
end;

procedure TSaveAsFP_2012.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
If Key = VK_F3 then SaveBtnClick(Application);
end;

procedure TSaveAsFP_2012.HelpBtnClick(Sender: TObject);
begin
ShowHelp('FpHelp','Save_a_return');
end;

procedure TSaveAsFP_2012.HelperClick(Sender: TObject); //20190228 Igor
var
  Helper: String;
begin
  Helper := HelperManager.HelperClassList.Keys.ToArray[(Sender as TCheckBox).Tag + 100].ClassName;
  HelperManager.Config(Helper, AppFP.AppId, User.UserName).SaveReturnToCloud := (Sender as TCheckBox).Checked;
end;

procedure TSaveAsFP_2012.DataDirBoxExit(Sender: TObject);
begin
  If DataDirBox.Text = OptRec.Dir_Cur then exit;
  If FileExists(DataDirBox.Text+'\'+ClientsTable_dbf) then //20160227 Igor
  begin
    ShowMessage(DataDirBox.Text + CHR(13)
              +'The data directory is NOT compatible with the Multi-App version.'+#13+
               'Please use another data directory, such as ' + OptRec.Dir_Cur  +' in the  Save As  window');
    exit;
  end;
 If IsDataDirectoryGood(DataDirBox.text) = false then exit;

 If (UpperCase(Leftstr(DataDirBox.Text,1)) ='A')
 or (UpperCase(Leftstr(DataDirBox.Text,1)) ='B') then
 begin
  If FileExists(DataDirBox.Text+'\'+ ClientsDBLite) = false then //20150922 Igor
  begin
   If DirectoryExists(DataDirBox.Text) = false then ForceDirectories(DataDirBox.Text);
   If InitDataBase(AppDir,DataDirBox.Text) = false then
     begin
       ShowMessage('Data directory '+DataDirBox.Text + ' cannot be initialized');
       DataDirBox.Text := OptRec.Dir_Cur;
       Exit;
     end;
  end;
 end;
 
 If (ChangeDataDir(DataDirBox.Text) = False) then
  begin
   DataDirBox.Text := OptRec.Dir_Cur;
   DataDirBox.Refresh;
   exit;
  end
 else
  begin
    {
    If not AllowedToChangeSaveDir(DataDirBox.Text) then
    begin
     DataDirBox.Text := OptRec.Dir_Cur;
     exit;
    end;
    }
  end;

end;

procedure TSaveAsFP_2012.DataDirBoxKeyPress(Sender: TObject; var Key: Char);
begin
If key = #13 then DataDirBoxExit(Application);
end;

end.
