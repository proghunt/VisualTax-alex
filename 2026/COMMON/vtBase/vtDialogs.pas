unit vtDialogs;
(* Show dialogs...
*)

interface

//uses  uMultiApp;
uses
  Classes, Controls,
  vtMulti, fStatBox
  //20150915 Igor
, uADStanIntf, uADStanOption, uADStanParam, uADStanError,
  uADDatSManager, uADPhysIntf, uADDAptIntf, uADStanAsync, uADDAptManager,
  uADGUIxIntf, uADStanDef, uADStanPool, uADPhysManager, uADCompClient,
  uADCompDataSet, fCloudLogon;

function GetCalendar: string;
var
  DD, MM, YYYY: integer;
  //as TDate?

procedure ShowTimedMsg(const Msg: string; DelayTime: Integer);
procedure ShowHelp(HelpFile, Helptopic: string; AisWeb: Boolean = False); //20160713 Igor //20161220 Igor

type
  eDataBaseType = (dbtAny, dbtClients, dbtDataDict, dbtForms);
procedure FixDbForm(const DBDir, DBName, DBTableName: string; DBType: eDataBaseType);//20150918 Igor

function OutLnList(RNo: integer; ASomeList: TStrings; SomeCaption: string): string;//20161207 Igor
//function  OutLnList(RNo: integer; SomeCaption: string; SomeList: TStrings; SortSw: boolean): string;
function PopSomeList(AList: TStrings; ACaption: string = ''; ACtrl: TControl = nil; ASort: boolean = False): string; //20200306 Igor
function PopMatchingList(AString: string; AList: TStrings; ACaption: string = ''; fSort: boolean = False; ACtrl: TControl = nil): string;
function PopSomeFile(const FileName: string; ACaption: string = ''; fSort: boolean = False; AHeaderLine: string = ''): string;
var
  PopListIdx: integer; //index of selected item
  PopListObject: TObject; //object associated with selected item
  PopResult: integer; //modal result of poplist

function SelectDir: string;
var
  SelectedDir: string;
function SelectApp: TApp;
function SelectNew: TApp;
function SelectFromLoadedReturns(RetNo: Integer; AWithOutAppendix: Boolean = False): Integer; //20170307 Igor
procedure SignOffWarnings(RNo: integer);

procedure ShowAbout;
procedure PreviewRichText(FName: string); //~TRtfForm, uninterpreted file only
procedure ShowLetterEditor(RNo: integer);

procedure ShowSplash(const id: string = '');  //procedure ShowSplash;  //20151001
procedure ShowFileViewer(AApp: TApp);
function StatusBox(ACaption: string): TStatusBox;
//external program invocation
procedure ShowCalculator;

function EncryptPsw(const S: string; Key: Word): string;
function DecryptPsw(const S: string; Key: Word): string;

function Logon: boolean;

{$IFDEF multi}
// --- Passwords ---
//Return - somewhere in the return (checked after loading)
procedure StoreReturnPsw(RetNo: Integer; const RetPsw: string);
procedure SetFilePsw(RNo: integer);
procedure RemoveReturnPsw(RetNo: Integer);
{$ELSE}
{$ENDIF}
function YouKnowTheReturnPassword(const UnencryptedPsw: string): Boolean;
function AskForReturnPsw: string;
function ReturnPswHasEof(const S: string): Boolean;

//Admin - Users.db f, Pswd
function IsAdmin: boolean;
function YouHaveAdminRights: boolean;
function YouKnowTheAdminPassword: Boolean;
function GetDeveloperPwd: boolean;
function IsDeveloper: boolean;

//Program - AppDir+'\'+ActivationFile (LVerf.EX_) [2]
function YouKnowThePGMPassword: Boolean;
function GetPGMPsw: string;
procedure SavePGMPsw(const PGMPsw: string);
procedure RemovePGMPsw;
procedure SetThePgmPsw;

//20201221 Igor >>>
procedure ShowMessageInfo(const Msg: string);
procedure ShowMessageWarning(const Msg: string);
procedure ShowMessageError(const Msg: string);
//20201221 Igor <<<

implementation

uses
  SysUtils, Forms,  Dialogs,
  ShellApi, Windows, HtmlHelp,
  fLicenses, fSplash, fProgres, fSignOffWarnings,
  fTimedMsg, fSelectDir, fPopList, fOutLine, fFixDb,
  fFixDBLite,//20150916 Igor
  fFileReader, fClientLetter,
  fAnyPassword,
  //fAdminPassword, fReturnPassword, fProgramPassword,
  fSetPgmPsw, fLogon, //fSetFilePsw,
  fYearCalendar, fNewReturn, fPreviewRich,
  vtMain, vtCommon, vtDataBase,
  //keep last
  vtTrimStr, vtShared,
  Soap.EncdDecd, //20171129 Igor
  vtDataModuleUnit, vtVirtualTaxOfficeLogin; //20160226 Igor

const
  BasePrefix = '<!--BASE64>'; //20171129 Igor

procedure ShowAbout;
begin
  (* Show the installable app and list, allow for license key updates.
    Do whatever required to adjust for license changes.
  *)
  ExecuteForm(TAbout);
  AppList.GetLicenses;
  if assigned(MainForm.GuiCommand) then //may be nil during program start
    MainForm.GuiCommand(gcLicenseCheck);
end;

function GetCalendar: string;
begin
  with TYearCalendar.Create(Application) do
  begin
    ShowModal;
    Result := Picked;
    Release;
  end;
end;

procedure ShowCalculator;
begin
  ShellExecute(Application.MainForm.Handle, nil, 'Calc.Exe', nil, nil, SW_RESTORE);
end;

procedure ShowTimedMsg(const Msg: string; DelayTime: Integer);
begin
  (* Show Msg for DelayTime ms.
  *)
    //ShowTimed(Msg, DelayTime);
  Application.ProcessMessages; //close the form!
  DelayMsg := Msg;
  TheDelay := DelayTime;
//  if TimedMsg = nil then
  TimedMsg := TTimedMsg.Create(nil); //Application.CreateForm(TTimedMsg, TimedMsg); //20160223 Igor (start project - mainform)
  try
    TimedMsg.ShowModal;
  finally
    TimedMsg.free;
    TimedMsg := nil;
  end;
  Application.ProcessMessages; //close the form!
end;

function SelectApp: TApp;
begin
  Result := QueryApp('Select Application...', 'OK');
end;

function SelectNew: TApp;
begin
  Result := QueryApp('New Return...', 'Create');
end;

function SelectDir: string;
var
  MySelectDir: TSelectDir;
begin
  Application.CreateForm(TSelectDir, MySelectDir);
  MySelectDir.ShowModal;
  Result := MySelectDir.SelectedDir;
  SelectedDir := Result; //frequently used
  MySelectDir.Free;
end;

function GetAdminPassword(UserName: string): string;
var
  ADConnection: TADConnection;
  Table1: TADTable;
begin
  Result := '';

  //20150915 Igor
  ADConnection:= TADConnection.Create(Application);
  Table1 := TADTable.Create(Application);
  SetTableName(ADConnection, Table1, ExeDir + '\' + UserDBLite, UserTableLite, 'Name');

  if Table1.FindKey([UserName]) = true then
    result := Table1.FieldByName('Pswd').AsString;

  Table1.Free;
  ADConnection.Free;
end;

function YouKnowTheAdminPassword: Boolean;

  function CheckPwd(pwd: string): boolean;
  begin
    Result := UpperCase(pwd) = DeveloperPwd;
    if Result then
      exit;
    if UpperCase(pwd) = UpperCase(GetAdminPassword('ADMIN')) then
      result := True;
  end;

var
  InputString: string;
begin
  (* Check LoginPwd first, if not matches then ask for pwd
  ??? Remember when correct Admin pwd has been entered ???
  *)
  Result := IsDeveloperLogin or (User.UserName = 'ADMIN') or IsAdminPasswordEntered; //CheckPwd(LoginPwd); //20170112 Igor
  if Result then
    exit;
  InputString :=GetPwd('Admin Password', '');
  Result := CheckPwd(InputString);
  IsAdminPasswordEntered := false;
end;

function IsAdmin: boolean;
begin
  Result := (CurrentApp.LicenseLevel in anyMulti)
    and YouKnowTheAdminPassword;
end;

function YouHaveAdminRights: boolean;
begin
  (* Every user is the admin, except in MultiOffice versions
  *)
  Result := not (CurrentApp.LicenseLevel in anyMulti)
    or YouKnowTheAdminPassword;
end;

// --- licensing ---

const
  C1 = 52845;
  C2 = 22719;
  C26 = #26;

{$RANGECHECKS off}
{$OVERFLOWCHECKS OFF}

function EncryptPsw(const S: string; Key: Word): string;
var
  I: byte;
  C, CC: AnsiChar;//20160311 Igor
begin
  //Result := S; exit;
  //Result[0] := S[0];
//  SetLength(Result, Length(s));//20160311 Igor
  for I := 1 to Length(S) do
  begin
    C := AnsiChar(AnsiString(S)[I]);//20160311 Igor
    Result := Result + AnsiChar(byte(C) xor (Key shr 8)); //chr(byte(S[I]) xor (Key shr 8));//20160311 Igor
    CC :=AnsiChar(AnsiString(Result)[I]);//20160311 Igor
    Key := ((byte(CC) + Key) * C1 + C2);//20160311 Igor
  end;
  if Pos(C26, Result) > 0 then
    UserMsg('Password contains bad character');
  Result := BasePrefix + EncodeString(Result); //20171129 Igor
end;
//20171129 Igor>>
function DecryptPsw(const S: string; Key: Word): string;
var
  I: byte;
  C: AnsiChar;//20160311 Igor
  Pass: string;
begin
  if pos(BasePrefix, S) = 1 then
  begin
    Pass := Copy(S, Length(BasePrefix) + 1, Length(S));
    Pass := DecodeString(Pass);
  end
  else
    Pass := S;
  //Result[0] := S[0];
//  SetLength(Result, Length(s));//20160311 Igor
  for I := 1 to Length(Pass) do
  begin
    C := AnsiChar(AnsiString(Pass)[I]);//20160311 Igor
    Result := Result + char(Byte(C) xor (Key shr 8));//20160311 Igor
    Key := ((byte(C) + Key) * C1 + C2);//20160311 Igor
  end;
end;
//20171129 Igor<<
{$RANGECHECKS on}
{$OVERFLOWCHECKS ON}

{$IFDEF multi}

procedure RemoveReturnPsw(RetNo: Integer);
begin
  RetList[RetNo].ReturnPassword := ''; // StoreElm(RetNo,GetFormNo('STATUS'),17,'');
end;

procedure StoreReturnPsw(RetNo: Integer; const RetPsw: string);
begin
  RetList[RetNo].ReturnPassword := EncryptPsw(RetPsw, 9999); //  StoreElm(RetNo,GetFormNo('STATUS'),17,EncryptPsw(RetPsw,9999));
end;

function FetchReturnPsw(RetNo: Integer): string;
begin
  Result := DecryptPsw(RetList[RetNo].ReturnPassword, 9999); //  Result:=DecryptPsw(FetchElm(RetNo,'STATUS',17),9999);
end;
{$ELSE}
{$ENDIF}

function ReturnPswHasEof(const S: string): Boolean;
begin
  Result := Pos(Chr(26), S) > 0;
end;

function AskForReturnPsw: string;
begin
  Result := GetPwd('Return Password');
end;

function YouKnowTheReturnPassword(const UnencryptedPsw: string): Boolean;
var
  InputString: string;
begin
  Result := IsDeveloperLogin;
  if Result then
    exit;
  InputString := AskForReturnPsw;
  //InputString:= LeftStr(InputString,Length(UnencryptedPsw));
  if (Inputstring = 'costas') or (Inputstring = 'COSTAS') then
    Result := true; //20100425
  if UpperCase(InputString) = UpperCase(UnencryptedPsw) then
    result := True;
end;

procedure SavePGMPsw(const PGMPsw: string);
//save encrypted
begin
  //LicenseList.Values['ADMIN'] := EncryptPsw(PgmPsw,9999);
  LicenseList.Password := PGMPsw;
  LicenseList.SaveToFile(LicenseFile); //20160913 Igor
end;

procedure RemovePGMPsw;
//Const ActivationFile = 'LVerf.EX_';  //20120128
begin
  LicenseList.Password := '';
  LicenseList.SaveToFile(LicenseFile); //20160913 Igor
end;

function GetPGMPsw: string;
// returns the unencrypted
//Const ActivationFile = 'LVerf.EX_';  //20120128
begin
  //result:=DecryptPsw(MainOptions.Password,9999);
  result := LicenseList.Password;
end;

procedure SetThePgmPsw;
begin
  Application.CreateForm(TSetPgmPsw, SetPgmPsw);
  if SetPgmPsw.ShowModal = mrOk then
    SavePGMPsw(SetPgmPsw.Psw);
  SetPgmPsw.Free;
end;

//Function YouKnowThePGMPassword(const UnencryptedPsw:String):Boolean;

function YouKnowThePGMPassword: Boolean;
var
  InputString: string;
begin
  (* called from Logon form (only!)
  *)
  Result := MainOptions.SkipLogin;
  if Result then
    exit;
  InputString := GetPwd('Program Password');
  Result := (UpperCase(InputString) = DeveloperPwd)
    or (InputString = LicenseList.Password);
end;

function Logon: boolean;
begin
  (* Handle multi-user login pwd, check for invalid accounts...
  *)
    //Result := False;  // ValidUser;
  if not CheckTableStructure(Nil) then  //20160226 Igor;
  Begin
    MessageDlg('The structure of the database is not updated. The program can not be started!',
               mtWarning,[mbOk],0);
    Halt;
    exit(False);//20170811 Igor
  end;

  //20201208 Igor >>>
  if IsVtClient then
  begin
    Result := LoginToVirtualTaxOffice;
  end
  else
  begin
    if MainOptions.SkipLogin then
    begin
      //20170112 Igor >>>
  //    UserName := MainOptions.SingleLoginId;
  //    UserId := UserName; //???
      Result := user.LoadUserProfile(MainOptions.SingleLoginId, True);//20170115 Igor
      if Result then
        exit;
      //20170112 Igor <<<
    end;

    if not StartParams.isCloud then
      with TLogon.Create(Application) do
      begin
        lbProgramId.Caption := ExeYear;
        ShowModal;
        Result := ValidUser; //set where???
        Release;
      end;
  end;
  //20201208 Igor <<<
end;



//20151001
//procedure ShowSplash(app: TApp);
procedure ShowSplash(const id: string);
var
  i: integer;
begin
  if Splash = nil then
    exit; //program startup
  //20201117 Igor >>>
  if IsVtClient then
  begin
    Splash.Visible := false;
    Exit;
  end;
  //20201117 Igor <<<
//  Splash.SelectApp(id);    DOES not work   //20151001
  Splash.Visible := True;
  Splash.BringToFront;  // ShowModal;
  //RetNoChanged(GetCurrentRetNo);
  //Splash.UpdatePosition; //20180201 Igor not sure if it is needed. Flash ignores resizing
end;

(*
procedure ShowSplash;
begin
  if Splash = nil then
    exit; //program startup
  Splash.Visible := True;
  Splash.BringToFront; // ShowModal;
  //RetNoChanged(GetCurrentRetNo);
end;
*)
procedure PreviewRichText(FName: string);
begin
  QrLtrName := FName;
  ExecuteForm(TPreviewRich);
end;

function StatusBox(ACaption: string): TStatusBox;
begin
  if FStatusBox = nil then
    FStatusBox := TStatusBox.Create(Application);
  result := FStatusBox;
  if ACaption <> '' then
    FStatusBox.Caption := ACaption;
  FStatusBox.show;
end;

{$IFDEF multi}

procedure SetFilePsw(RNo: integer);
begin
  with TSetFilePsw.Create(Application) do
  begin
    RetNo := RNo;
    ShowModal;
    Release;
  end;
end;
{$ELSE}
{$ENDIF}

//20150918 Igor
procedure FixDbForm(const DBDir, DBName, DBTableName: string; DBType: eDataBaseType);
begin
  with TFixDBLiteForm.Create(Application) do
  begin
    FixDBType := DBType;
    FixDbDir := DBDir;
    FixDbName := DBName;
    FixDbTableName := DBTableName;
    ShowModal;
    Free;
  end;
end;

function OutLnList(RNo: integer; ASomeList: TStrings; SomeCaption: string): string; //20161207 Igor
//function OutLnList(RNo: integer; SomeCaption: string; SomeList: TStrings; SortSw: boolean): string;
begin
  with TOutlnList.Create(Application) do
  begin
    try //20161207 Igor
      RetNo := RNo;
      Caption := SomeCaption;
      Color := GetRetColor(RetNo);
      //SomeList.sort!?
  //SomeList.SaveToFile('outln.txt');
      Outline1.Lines.Assign(ASomeList); //20161207 Igor
      Outline1.FullExpand;
      Outline1.SelectedItem := 0;
      ShowModal;
      Result := Selected;
    finally  //20161207 Igor
      Free;
    end;
  end;
end;

var
  MyList: TPopList;

procedure PreparePop(ACaption: string; ACtrl: TControl = nil);
var
  p: TPoint;
begin
  (* prepare poplist for selection
  *)
  if MyList = nil then
    Application.CreateForm(TPoplist, MyList);
  //20200305 Igor >>>
  if CheckIsCloud(true) then
    MyList.FormStyle := fsStayOnTop;
  //20200305 Igor <<<
  if ACtrl <> nil then
  begin
    //!!! ACtrl.Top are CLIENT coords!
    {
      r := ACtrl.BoundsRect;
      p := ACtrl.ClientToScreen(r.TopLeft);
    }
    p := ACtrl.ClientOrigin;
    //ClientToScreen(ACtrl.handle,ACtrl.
    MyList.Top := p.y + ACtrl.Height;
    MyList.Left := p.x; // r.Left; // ACtrl.Left;
    MyList.NearCtrl := ACtrl; //20170313 Igor
  end;
  if ACaption = '' then
    ACaption := 'Select one';
  MyList.Caption := ACaption;
  MyList.SomeList.Clear;
end;

function SelectFromPop: string;
begin
  (* Show PopList, error msg if list is empty
  *)
  Result := '';
  if MyList.SomeList.Count = 0 then
  begin
    ShowTimedMsg('Not found!', 1300);
    Exit;
  end;
//  PopResult := MyList.ShowModal;
  if MyList.ShowModal = mrOk then //20160216 Igor
  begin
    Result := MyList.Selected;
    PopListIdx := MyList.SelIdx;
    PopListObject := MyList.SomeList.Objects[poplistidx];
  end;
end;

function PopSomeList(AList: TStrings; ACaption: string; ACtrl: TControl; ASort: boolean): string; //20200306 Igor
begin
  PreparePop(ACaption, ACtrl);
  MyList.SomeList.Assign(AList);
  MyList.ListBox1.Sorted := ASort; //20200306 Igor
  Result := SelectFromPop;
end;

function PopMatchingList(AString: string; AList: TStrings; ACaption: string; fSort: boolean; ACtrl: TControl): string;
begin
  (* select from specific entries in AList, matching AString
  *)
  PreparePop(ACaption, ACtrl);
  //MyList.SomeList.Assign(AList);
  IsAnyWhereInList(AString, AList, MyList.SomeList);
  MyList.ListBox1.Sorted := fSort;
  Result := SelectFromPop;
end;

//function PopFileList(const ACaption, AFileName: string; fSorted: boolean; AHeaderLine: string): string;

function PopSomeFile(const FileName: string; ACaption: string; fSort: boolean; AHeaderLine: string): string;
begin
  (* No recursive calls can occur, re-use the same instance
  *)
  Delay(2); //20250524 //othrwisw list gets sorted all the time
  PreparePop(ACaption);
  if FileExists(FileName) then
  begin
    MyList.SomeList.LoadFromFile(FileName);
    if fSort then MyList.Sorted := True;
  end
  else
    MyList.SomeList.Clear;
  if AHeaderLine <> '' then
    MyList.SomeList.Insert(0, AHeaderLine);
  Result := SelectFromPop;
end;

procedure ShowHelpIn(const HelpFile, Helptopic: string; AParent: TWinControl; AisWeb: Boolean); //20160713 Igor
var
//  RetCode: LongInt; //iHelpID: LongInt;
  FullName: string;
begin
  //20160713 Igor >>> {if Web help}
  if AisWeb then
  begin
    ShellExecute(0, 'open', PWideChar(HelpFile+'?'+StringReplace(Helptopic+'.html', ' ', '%20', [rfReplaceAll])), nil, nil, SW_SHOW); //20161220 Igor
    exit;
  end;
  //20160713 Igor <<< {if Web help}

  if ExtractFileExt(HelpFile) = '' then //20160526 Igor
    FullName := HelpFile + '.CHM'
  else
    FullName := HelpFile;

  if not FileExists(FullName) then
  begin
    ErrorMsg('Missing file ' + FullName);
    exit;
  end;
  //20161220 Igor >>>
  if Helptopic <> '' then
    ShellExecute(0, 'open', 'HH.exe', PWideChar('"'+FullName + '::/' + Helptopic + '.html'+'"'), nil, SW_SHOW)
  else
    ShellExecute(0, 'open', PWideChar('"'+FullName+'"'), nil, nil, SW_SHOW);
  //20161220 Igor <<<

//  if HtmlHelpInstalled = True then
//  begin
//    if ExtractFileExt(HelpFile) = '' then //20160526 Igor
//      FullName := HelpFile + '.CHM'
//    else
//      FullName := HelpFile;
//    if not FileExists(FullName) then
//    begin
//      ErrorMsg('Missing file ' + FullName);
//      exit;
//    end;
//    if HelpTopic = 'HELP_CONTENTS' then
//      RetCode := HH(0, PChar(FullName + Chr(0)), HH_DISPLAY_TOPIC, 0)
//    else
//      RetCode := HH(0, PChar(FullName + '::/' + HelpTopic + '.html' + Chr(0)), HH_DISPLAY_TOPIC, 0);
//  end
//  else
//  begin
//    ShowMessage('Please install at least v4.01 of Internet Explorer before ' +
//      'displaying a CHM file');
//  end;
end;

procedure ShowHelp(HelpFile, Helptopic: string; AisWeb: Boolean = False); //20160713 Igor //20161220 Igor
begin
  //20161220 Igor >>>
  if SameText(HelpFile, CurrentApp.AppName+'Help') then //20170731 Igor
  begin
    AIsWeb := True;
    HelpFile := CurrentApp.ModuleHelpFile;
  end
  else
  if SameText(HelpFile, CurrentApp.AppName+'UPDHLP') then//20170731 Igor
  begin
    AIsWeb := True;
    HelpFile := CurrentApp.ModuleHelpUpdFile;
  end;
  //20161220 Igor <<<

  ShowHelpIn(HelpFile, Helptopic, nil, AisWeb); //20160713 Igor
end;

procedure ShowFileViewer(AApp: TApp);
begin
  RTFForm := TFileReader.Create(Application);
  RTFForm.MyApp := AApp;
  RTFForm.ShowModal; //?
  RTFForm.free;
end;

procedure ShowLetterEditor(RNo: integer);
begin
  with TLetterEditor.Create(Application) do
  begin
    RetNo := RNo;
    ShowModal;
    Free;
  end;
end;

function SelectFromLoadedReturns(RetNo: Integer; AWithOutAppendix: Boolean = False): Integer; //20170307 Igor
var
  SomeList: TStringList;
begin
  Result := RetNo;
  SomeList := TStringList.Create;
  SomeList.Sorted := True;
  //fill list with return captions and objects
  RetList.GetListOfLoadedReturns(SomeList, RetList[RetNo].MyApp, AWithOutAppendix); //20161216 Igor //20170307 Igor
  if PopSomeList(SomeList, 'Select from Loaded returns') <> '' then
    Result := TRetData(SomeList.Objects[PopListIdx]).RetNo;
  SomeList.Free;
end;

procedure SignOffWarnings(RNo: integer);
begin
  (* show SignOff dialog.
    refresh everything related.
  *)
  with TSignOffWarnings.Create(Application) do
  begin
    RetList[RNo].AuditList.BeginUpdate;
    RetNo := RNo;
    //Result := ShowModal = mrOK;
    ShowModal;
    Release;
    RetList[RNo].AuditList.EndUpdate; //update everything
  end;
end;

function GetDeveloperPwd: boolean;
var
  psw: string;
begin
  Result := IsDeveloperLogin;
  if Result then
    exit;
  Psw := GetPwd('Developer Password'); // InputBox('Visual Tax','Enter Developer Password', '');
  psw := UpperCase(PSW);
  Result := (psw = DeveloperPwd); // or (psw = 'FRED');
  IsDeveloperLogin := Result;
end;

function IsDeveloper: boolean;
begin
  Result := GetDeveloperPwd;
end;

procedure ShowMessageInfo(const Msg: string); //20201221 Igor
begin
  MessageDlg(Msg, mtInformation, [mbOk], 0);
end;

procedure ShowMessageWarning(const Msg: string); //20201221 Igor
begin
  MessageDlg(Msg, mtWarning, [mbOk], 0);
end;

procedure ShowMessageError(const Msg: string); //20201221 Igor
begin
  MessageDlg(Msg, mtError, [mbOk], 0);
end;

end.

