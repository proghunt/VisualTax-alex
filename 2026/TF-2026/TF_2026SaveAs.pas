unit TF_2026SaveAs;

interface

uses SysUtils,FileCtrl,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,
  Forms,Dialogs,StdCtrls,Buttons,ExtCtrls;

type
  TSaveAsTF_2026 = class(TForm)
    Panel1: TPanel;
    StatusGroup: TRadioGroup;
    Panel2: TPanel;
    FLNameBox: TEdit;
    Label1: TLabel;
    statuslbl: TLabel;
    DataDirBox: TEdit;
    noteslbl: TLabel;
    ClearBtn: TBitBtn;
    RetNameLbl: TLabel;
    Label2: TLabel;
    Notes: TEdit;
    Panel3: TPanel;
    SaveBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label3: TLabel;
    FlDescrBox: TEdit;
    HelpBtn: TBitBtn;
    Label4: TLabel;
    BrowseBtn: TBitBtn;
    sbStorage: TScrollBox;
    Label5: TLabel; //20190228 Igor
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure SaveCloseBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure BrowseBtnClick(Sender: TObject);
    procedure FlDescrBoxChange(Sender: TObject);
 //   procedure BitBtn2Click(Sender: TObject);
    // 20190228 Igor >>>
    procedure cbShareWithPeopleClick(Sender: TObject);
    procedure sbShareWithPeopleClick(Sender: TObject);
    procedure HelperClick(Sender: TObject);
    // 20190228 Igor <<<
  private
    FRetNo: integer;
  public
    property RetNo: integer read FRetNo;
  end;
Const HelpTopic = 'Save_a_return';
var
  SaveAs: TSaveAsTF_2026;

implementation

{$R *.DFM}
uses vtCommon,vtMulti,TF_2026,TF_2026Declare,TF_2026Common,TF_2026Common2,
  TF_2026TrimStr,TF_2026Calc,TF_2026ChildWinNew,vtTrimStr,vtShared,
  vtHelperManager, vtShareToPeople, //20190228 Igor
  TF_2026Features;

procedure TSaveAsTF_2026.CancelBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;  //Close;
end;

procedure TSaveAsTF_2026.cbShareWithPeopleClick(Sender: TObject); //20190228 Igor
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

procedure TSaveAsTF_2026.FormCreate(Sender: TObject);
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
  FRetNo:=GetCurrentRetNo;
  RetNameLbl.Caption := GetRetName(RetNo);
  RetNameLbl.Color := GetRetColor(RetNo);
  FlNameBox.Text := Ret[RetNo].GetDefaultFileName;  //20160302 Igor
//  If IsT3Return(RetNo) = True then
//  begin
//
//    FlNameBox.Text := LeftStr(GetAccountNumber(RetNo),8)+'.'+MidStr(GetYearEnd(RetNo),3,2);
//    If Length(GetAccountNumber(RetNo)) =0 then
//      FlNameBox.Text :=RemoveSpaces(LeftStr(GetRetName(RetNo),8))+'.'+
//                       MidStr(GetYearEnd(RetNo),3,2);
//  end
//  else
//    FlNameBox.Text:='';

  If Ret[RetNo].SourceFlName> '' then  FlNameBox.Text := Ret[RetNo].SourceFlName;
  //20180314 Igor >>>
  FlDescrBox.Text := FetchElm(RetNo, GetFormNo('STATUS'), c_FileDescription);
  if FlDescrBox.Text = '' then
    FlDescrBox.Text := GetRetName(RetNo);
  //20180314 Igor <<<


If Ret[RetNo].SourceDataDir = '' then
 DataDirBox.Text := OptRec.Dir_Cur
else
 DataDirBox.Text := Ret[RetNo].SourceDataDir;
Notes.Text := Ret[RetNo].Notes;

For i :=0 to High(PrpStatusDescr) do StatusGroup.Items.Add(PrpStatusDescr[i]);
If Ret[RetNo].PrpStatus = '' then Ret[RetNo].PrpStatus := '00';
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
            AppTF_2026.AppId, User.UserName).SaveReturnToCloud;
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

procedure TSaveAsTF_2026.ClearBtnClick(Sender: TObject);
begin
 Notes.Text := '';
end;

procedure TSaveAsTF_2026.SaveBtnClick(Sender: TObject);
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
 If Ret[RetNo].Locked = True then
 begin
  ShowMessage('Return is locked and cannot be saved. Unlock it or Close it');
  Exit;
 end;
 If Length(AllTrim(FlNameBox.Text))<4 then  //20230325
 //If AllTrim(FlNameBox.Text) = '' then
  begin
   ShowMessage('You must specify a File Name more than 3 characters');
   FlNameBox.SetFocus;
   Exit;
  End;

 If Length(FlNameBox.Text) > 50 then
  begin
  ShowMessage('File Name cannot exceed 50 characters');
  FlNameBox.SetFocus;
  Exit;
  End;

//{$IFNDEF DEBUG} //20160327 Igor
  If FileExists(DataDirBox.Text+'\'+ClientsTable_dbf) then //20160227 Igor
  begin
    DataDirBox.Text := OptRec.Dir_cur; //20160415 Igor
    ShowMessage('The Data Directory is NOT compatible with the Multi-app version '+
                'as it contains the old format of tax data' + Chr(13) +
                'The Data directory has been changed to ' + OptRec.Dir_cur + Chr(13) +
                ' or you can change it to some other directory name of your choice');
//    ShowMessage(DataDirBox.Text + CHR(13)
//              +'The data directory is NOT compatible with the Multi-App version.'+#13+
//               'Please use another data directory, such as ' + OptRec.Dir_Cur  +' in the  Save As  window');
    exit;
  end;
  If IsDataDirectoryGood(DataDirBox.Text) = False then exit;//20170803 Igor
  //20171031 Igor>>>
  OriginalSourceFileName := RetList[RetNo].SourceFlName;
  RetList[RetNo].SourceFlName := FlNameBox.Text;
  try
    if AppTF_2026.ExceedsMaxReturnsAllowed(False) then
      Exit;
  finally
    RetList[RetNo].SourceFlName := OriginalSourceFileName;
  end;
  //20171031 Igor<<<

//{$ENDIF} //20160327 Igor
 If Not FileExists(DataDirBox.text+'\'+ClientsDBLite) then
 begin
   If InitDataBase(AppDir,DataDirBox.Text)=false then Exit;
 end;
//20170902 Igor>>>
//  //20170502 Igor >>>
//  if CountClientsRecordWithoutThisReturnFile(AppTF_2026, DataDirBox.Text, FlNameBox.Text) >= AppTF_2026.LimitReturns then
//  begin
//    ShowMessage('Number of returns exceeds maximum allowed '
//        +'('+IntToStr(AppTF_2026.LimitReturns)+')'+
//        Chr(13)+' in the Limited version');
//    Exit;
//  end;
//  //20170502 Igor <<<
//20170902 Igor<<<

 If DirectoryExists(DataDirBox.Text) = False then
  begin
   ShowMessage('Directory does not exist');
   DataDirBox.SetFocus;
   Exit;
  End;

 If FileExists(DataDirBox.Text+'\'+ClientsDBLite) = False then
  begin
   ShowMessage('Directory was not initialized for tax returns');
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
  Strings[14] := Notes.Text;
  Strings[4]  := FillLeftZeros(IntToStr(StatusGroup.ItemIndex),2);
  {last update}
  Strings[11] := User.UserName; //20170112 Igor
  Strings[12] := FormatDateTime('yyyy-mm-dd',Now);
  Strings[13] := TimeToStr(Time);
 end;

  CalcUsedFrm(RetNo);
  FileDescr := UpperCase(FlDescrBox.Text); {global var to be used in save return}
  if FlDescrBox.Text='' then FlDescrBox.Text:=FlNameBox.Text;  //20260830CZ


  StoreElm(RetNo, GetFormNo('STATUS'), c_FileDescription, FlDescrBox.Text); //20180314

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

  If SaveReturn(RetNo,DataDirBox.Text,FlNameBox.Text,False,True,False,True,Clouds) = 0 then //20190228 Igor
    begin
     Ret[RetNo].SourceDataDir := DataDirBox.Text;
     Ret[RetNo].SourceFlName := FlNameBox.Text;
     AddLogAppMon(amtOnSave, RetNo); // 20180712 Igor //20220519 Igor
     ModalResult := mrOK; // Close;
    end
  else
     begin
      ShowMessage('Return was not saved... Press any key');
      exit;
     end;
end;

procedure TSaveAsTF_2026.SaveCloseBtnClick(Sender: TObject);
begin
 SaveBtnClick(Sender);
 CloseReturn(RetNo,True);
end;

procedure TSaveAsTF_2026.sbShareWithPeopleClick(Sender: TObject); //20190228 Igor
var
  cEmails: string;
begin
  cEmails := FetchElm(RetNo, 'STATUS', SHARE_WITH_PEOPLE);
  if ShareToPeople(RetNo, cEmails) then
    StoreElm(RetNo, 'STATUS', SHARE_WITH_PEOPLE, cEmails);
end;

procedure TSaveAsTF_2026.HelpBtnClick(Sender: TObject);
begin
ShowHelp('TfHelp',HelpTopic);
end;

procedure TSaveAsTF_2026.HelperClick(Sender: TObject); //20190228 Igor
var
  Helper: String;
begin
  Helper := HelperManager.HelperClassList.Keys.ToArray[(Sender as TCheckBox).Tag + 100].ClassName;
  HelperManager.Config(Helper, AppTF_2026.AppId, User.UserName).SaveReturnToCloud := (Sender as TCheckBox).Checked;
end;

procedure TSaveAsTF_2026.BrowseBtnClick(Sender: TObject);
Var DirSelected:String;
begin
  if CheckIsCloud then Exit; //20180503 Igor
  if SelectDirectory('Select a folder:', '', DirSelected) then
  Begin
    If FileExists(DataDirBox.Text+'\'+ClientsTable_dbf) then //20160227 Igor
    begin
      ShowMessage(DirSelected + CHR(13)
                +'The data directory is NOT compatible with the Multi-App version.'+#13+
                 'Please use another data directory, such as ' + OptRec.Dir_Cur  +' in the  Save As  window');
      exit;
    end;

    DataDirBox.Text:= DirSelected;
  End;
end;

procedure TSaveAsTF_2026.FlDescrBoxChange(Sender: TObject);
begin
If FlDescrBox.Text>'' then RetNameLbl.Caption:= FlDescrBox.Text;  //20120304
end;

end.
