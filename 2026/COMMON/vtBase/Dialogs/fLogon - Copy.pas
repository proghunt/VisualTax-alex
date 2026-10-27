unit fLogon;
(* This version is T1 specific - make more general
*)

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons,Dialogs,SysUtils,
  ExtCtrls, jpeg, vtLabel, vtShape,
  vtMulti, Vcl.ComCtrls, Vcl.ExtActns,
  xmldom, XMLIntf, msxmldom, XMLDoc, uADStanIntf, uADStanOption, uADStanParam,
  uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, Vcl.DBCtrls, Data.DB,
  Vcl.DBCGrids, uADCompDataSet, uADCompClient, Vcl.Grids, Vcl.DBGrids,
  Vcl.ImgList, Vcl.OleCtrls, SHDocVw, IdHTTP, MSHTML, IdSSLOpenSSL, //20160425 Igor //20180212 Igor //20191210 Igor
  IdSSLOpenSSLHeaders; //20200914 Igor

type
  TLogon = class(TForm)
    Image3: TImage;
    Label16: TLabel;
    Label14: TLabel;
    PswdLabel: TLabel;
    Label2: TLabel;
    PswdBox: TEdit;
    CheckBox1: TCheckBox;
    NameBox: TComboBox;
    lbProgramId: TLabel;
    vtLabel2: TLabel;
    CancelBtn: TBitBtn;
    Helpbtn: TBitBtn;
    OKBtn: TBitBtn;
    SkipLogin: TCheckBox;
    Label1: TLabel;
    gbActivateTaxModule: TGroupBox;
    XMLDoc: TXMLDocument;
    btnUpdate: TBitBtn;
    mtModule: TADMemTable;
    dsModule: TDataSource;
    mtModuleDisabled: TBooleanField;
    mtModuleName: TStringField;
    mtModuleLicense: TStringField;
    mtModuleCurentVersion: TStringField;
    mtModuleActualVersion: TStringField;
    mtModuleHelpFile: TStringField;
    grModules: TDBGrid;
    mtModuleHaveUpdate: TBooleanField;
    mtModuleHelpName: TStringField;
    mtModuleIndex: TIntegerField;
    mtModuleNeedUpdate: TBooleanField;
    ilCheck: TImageList;
    mtModuleModuleStatus: TStringField;
    Label3: TLabel;
    lblRedesignDocument: TLabel;
    WebBrowserAlert: TWebBrowser;
    GroupBoxAlert: TGroupBox;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    //procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure HelpbtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvApplicationsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnUpdateClick(Sender: TObject);
    procedure lblHelpMouseEnter(Sender: TObject);
    procedure lblHelpMouseLeave(Sender: TObject);
    procedure grModulesCellClick(Column: TColumn);
    procedure grModulesDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure RedesignNewsBtnClick(Sender: TObject);
    procedure lblRedesignDocumentMouseEnter(Sender: TObject);
    procedure lblRedesignDocumentMouseLeave(Sender: TObject); //20160705 Igor
    procedure WebBrowserAlertBeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, //20160819 Igor
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowserAlertNavigateError(ASender: TObject;
      const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;//20160819 Igor
      var Cancel: WordBool);
    procedure WebBrowserAlertDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant); //20180212 Igor
  private
    HaveMulti: Boolean;//20170112 Igor
    FSkipLinkIntercept: boolean; //20210426 Igor
    procedure UpdateLoginNames(Nm: String);
  public
    //MyApp: TApp;
    ValidUser: boolean;
  end;

implementation

{$R *.DFM}

uses
  vtDialogs, vtAuthorization, // UUsers;
  vtCommon,
//keep last
  vtTrimStr, vtShared;

const
  c_UpdateRequired = 'Update required';
  c_UpToDate = 'Up-to-date';

Procedure TLogon.UpdateLoginNames(Nm:String);
Var TempList:TStringList;
begin
  TempList:=TStringList.Create;
  GetLoginNames(TempList);
  Nm:=UpperCase(Nm);
  If IsInList(Nm,TempList) < 0 then
  begin
    TempList.Add(Nm);
    //TempList.SaveToFile(ExeDir+'\'+LoginNames);
    SaveLoginNames(TempList);
  end;
  TempList.Free;
end;

procedure TLogon.WebBrowserAlertBeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool); //20160819 Igor
begin
  //20210426 Igor >>>
  if FSkipLinkIntercept then Exit;
  Cancel := true;
  ConnectToWeb(URL);
  //20210426 Igor <<<
  Exit; //20190513 Igor
  if Pos(LowerCase(vtAlerthtml), LowerCase(URL)) = 0 then //20170212 Igor //20180228 Igor
  begin
    ShowHelp(URL, '', True);
    Cancel := True;
  end;
end;

procedure TLogon.WebBrowserAlertDocumentComplete(ASender: TObject; //20180212 Igor
  const pDisp: IDispatch; const URL: OleVariant);
var nWidth: integer;

  function GetWindowWidth(AWebBrowser: TWebBrowser): integer;
  var HtmlElement, BodyElement: IHTMLElement2;
  begin
    with AWebBrowser.ControlInterface do
      Result := ((Document as IHTMLDocument2).body as IHTMLElement2).ScrollWidth;
  end;

begin
  if not Assigned(WebBrowserAlert.ControlInterface.Document) then Exit; //20190513 Igor
  nWidth := GetWindowWidth(WebBrowserAlert) + GetSystemMetrics(SM_CXVSCROLL) + GetSystemMetrics(SM_CXEDGE) * 2;
  if nWidth > WebBrowserAlert.Width then
    Width := Width + nWidth - WebBrowserAlert.Width;
end;

procedure TLogon.WebBrowserAlertNavigateError(ASender: TObject;
  const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant; //20160819 Igor
  var Cancel: WordBool);
begin
  GroupBoxAlert.Visible := False;
  Height := Height - GroupBoxAlert.Height;
end;

procedure TLogon.OKBtnClick(Sender: TObject);
var
  s:String;
  I, J: Integer;

begin
  J := 0;
  for I := 0 to AppList.Count - 1 do
  begin
    if Assigned(AppList.GetApp(I)) AND
       (AppList.GetApp(I).LicenseLevel > llNone) AND
       (not AppList.GetApp(I).Disabled) then
      inc(J);
  end;
  if J = 0 then
  Begin
    ShowMessage('Please, check one or more tax module.');
    exit;
  End;
  //20160601 Igor
  if btnUpdate.Tag = 1 then
  Begin
    if MessageDlg('Run without updating?',mtWarning, [mbYes, mbNo],0) <> mrYes then
      exit;
  End;

  for I := 0 to AppList.Count - 1 do
    AppList.GetApp(I).NeedUpdate := true; //20160526 Igor

  //LoginName:=NameBox.Text; //20160205 //20160216 Igor //20170112 Igor
//20170112 Igor >>>
(*  If FileExists('C:\PDOXUSRS.NET') then SysUtils.DeleteFile('C:\PDOXUSRS.NET');
  If FileExists('C:\DBDWORK.INI') then
  begin
    SysUtils.DeleteFile('C:\DBDWORK.INI');  //20101230
    //  ShowMessage('Deleted DBWork.ini');
  end;
*)
//20170112 Igor <<<

//save name and password, unchecked
//20170112 >>> Igor
//  UserName := AllTrim(UpperCase(NameBox.Text));
//  LoginPwd := UpperCase(PswdBox.Text);
//  IsDeveloperLogin := LoginPwd = DeveloperPwd;
  IsDeveloperLogin := PswdBox.Text = DeveloperPwd;
//20170112 <<< Igor
  s:=GetPgmPsw;
  If S<>'' then
    SkipLogin.checked:=False;
  MainOptions.SingleLoginId:=NameBox.Text; //for use on next program start
  MainOptions.Save;//20170127 Igor
  UpdateLoginNames(NameBox.Text);
  MainOptions.SkipLogin:=SkipLogin.Checked;

//20160717 Igor
//  If TimeToCheckUpdates = True then
//  begin
//    if MessageDlg('You should check the Internet for any program update'+
//       Chr(13)+'Last time you checked was: '+GetLastUpdCheck+
//       Chr(13)+'Please set frequency in Configure | How often to check for updates'+
//       Chr(13)+' '+
//       Chr(13)+'Check for any update now?',
//      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
//       //Checkupdates(Self.Handle,AppName+'-'+AppYear);  //'T1-2003');
//       Checkupdates(Handle,'???');
//  end;

//20170112 Igor >>>
//  If IsDeveloperLogin then
//  begin
//    ValidUser:=True;
//    Close;
//    exit;
//  end;
  //FixMostRecent;  //20150214?
//20170112 Igor <<<
  If (S <> '') AND not IsDeveloperLogin then //20170112 Igor
    If YouKnowThePGMPassword = false then
    begin
      Application.Terminate;
      Exit;
    end;

{ TODO -oCon : check multi-user how? }
(*
  If LeftStr(LicenseLevel,8) <> 'T1 Multi' then
  begin
    UpdateLoginNames(NameBox.Text);
    close;
    exit;
  end;
*)
//20170112 Igor >>>
  // ALL below apply to Multi user only
  if User.LoadUserProfile(AllTrim(UpperCase(NameBox.Text)), HaveMulti)//20170115 Igor
     and
     (
       not HaveMulti
       or
       IsDeveloperLogin
       or
       sametext(User.Password, PswdBox.Text) //20170212 Igor
     ) then
  begin
     UpdateLoginNames(NameBox.Text);
     ValidUser :=True;
     ModalResult := mrOk; // Close;
  end
  else
  begin
    ValidUser:=False;
    if MessageDlg('Invalid User Name or Password' + Chr(13) +
                  'Try Name: ADMIN and Password: ADMIN' + Chr(13) +
                  'or check with your Office Administrator.' + Chr(13) +
                  ' Try again?', mtInformation, [mbYes, mbNo], 0) = mrYes then
      NameBox.SetFocus
    else
      ModalResult := mrCancel;
  end;
  //20170112 Igor <<<
end;

procedure TLogon.RedesignNewsBtnClick(Sender: TObject);
begin
  ShowHelp(RedesignFile,'Logon',true); //20160705 Igor //20160719 Igor
end;

procedure TLogon.btnUpdateClick(Sender: TObject);
begin
  if btnUpdate.Tag = 0 then
    if MessageDlg('Do you want to Update again?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      exit;
  Checkupdates(Handle,'???');
end;

procedure TLogon.CancelBtnClick(Sender: TObject);
begin
 //UserMsg('Exiting now');  //20161215
  //ModalResult := mrCancel;
  Application.Terminate;
end;


procedure TLogon.FormShow(Sender: TObject);
//procedure TLogon.FormCreate(Sender: TObject);
Var
  i, K : Integer;
  TempList:TStringList;
//  LI: TListItem;
  XMLFileName: String;
  //20190513 Igor >>>
  AlertFile: string;
  AlertList: TStringList;
  Doc: Variant;
  //20190513 Igor <<<
  RootNode : IXMLNode;
  ANode : IXMLNode;
  Flags: OleVariant; //20170212 Igor
  LoadXML: boolean; //20180220 Igor
  function GenerateTempFilename: String;
  var
    TempFile: array[0..MAX_PATH - 1] of Char;
    TempPath: array[0..MAX_PATH - 1] of Char;
  begin
    GetTempPath(MAX_PATH, TempPath);
    if GetTempFileName(TempPath, PChar('abc'), 0, TempFile) <> 0 then
      Result := TempFile
    else
      Result := '';
  end;
  function MyStrToDate(S: String): TDateTime;
  var
    Y,M,D: Word;
  Begin
    Y := StrToInt(copy(S,1,4));
    M := StrToInt(copy(S,6,2));
    D := StrToInt(copy(S,9,2));
    Result := EncodeDate(Y,M,D);
  End;

  procedure GetFileWithNoCache(AUrl, AFileName: string); // 20171229 Igor //20191210 Igor
  var HTTP: TIdHTTP;
      FS: TFileStream;
      IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  begin
    if FileExists(AFileName) then
      DeleteFile(AFileName);
    if AUrl.IsEmpty then Exit; //20201117 Igor
    FS := TFileStream.Create(AFileName, fmCreate);
    HTTP := TIdHTTP.Create(self);
    IdOpenSSLSetLibPath(ExtractFilePath(Application.ExeName));//20200914 Igor
    IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    try
      HTTP.IOHandler := IdSSLIOHandlerSocket;
      HTTP.HandleRedirects := True;
      HTTP.AllowCookies := True;
      //20190513 Igor >>>
      HTTP.ConnectTimeout := HTTP_TimeOut;
      HTTP.ReadTimeout := HTTP_TimeOut;
      //20190513 Igor <<<
      with HTTP do
      begin
        Request.UserAgent := 'Mozilla/4.0';
        Request.Connection := 'Keep-Alive';
        Request.ProxyConnection := 'Keep-Alive';
        Request.CacheControl := 'no-cache';
      end;
      HTTP.Get(AUrl, FS);
    finally
      IdSSLIOHandlerSocket.Free;
      FS.Free;
      HTTP.Free;
    end;
  end;

begin
  FSkipLinkIntercept := false; //20210426 Igor
  HaveMulti := False; //20170112 Igor
  //20160819 Igor>>>
  //20190513 Igor >>>
  //20201117 Igor >>>
  if IsvtClient then //20210112 Igor
  begin
    GroupBoxAlert.Visible := False;
    Height := Height - GroupBoxAlert.Height;
  end
  else
    try
      Flags := DWORD(navNoReadFromCache or navNoWriteToCache);  //20170212 Igor
      {generate unique url for disable cache}
      AlertFile := GenerateTempFilename;
      GetFileWithNoCache('http://'+vtAlerthtml, AlertFile);
      //WebBrowserAlert.Navigate2(vtAlerthtml+'?readtime='+formatdatetime('yyyymmddhhnnss',now), Flags); //20170212 Igor
      FSkipLinkIntercept := true; //20210426 Igor
      AlertList := TStringList.Create;
      try
        AlertList.LoadFromFile(AlertFile);
        if not Assigned(WebBrowserAlert.Document) then
          WebBrowserAlert.Navigate('about:blank');
        Doc := WebBrowserAlert.Document;
        Doc.Clear;
        Doc.Write(AlertList.Text);
        Doc.Close;
      finally
        AlertList.Free;
        FSkipLinkIntercept := false; //20210426 Igor
      end;
    except
      GroupBoxAlert.Visible := False;
      Height := Height - GroupBoxAlert.Height;
    end;
  //20190513 Igor <<<
  //20160819 Igor<<<
  //20201117 Igor <<<

 btnUpdate.Tag := 0;
 //20170112 Igor >>>
(* GetLoginNames(NameBox.Items);
  if NameBox.Items.Count > 0 then
    NameBox.ItemIndex := 0;
  //if IsDevelopmentMode then
  PswdBox.Text := 'ADMIN';
  //20160425 Igor >>>>
*)
  //20170112 Igor <<<
  mtModule.Active := true;
  mtModule.Append;
  mtModuleDisabled.AsBoolean := False;
  mtModuleName.AsString := 'Base Module'; //20160529 Igor
  mtModuleLicense.AsString := 'Base Module'; //20160608 Igor
  mtModuleCurentVersion.AsString := AppUpdateDate;
  //20160601 Igor
  mtModuleHelpFile.AsString := MainHelpUpdFile;
  //if FileExists(MainHelpUpdFile) then //20160808 Igor
    mtModuleHelpName.AsString := 'Click to review';

  SendAndUpdateAppMon; // 20180711 Igor

  XMLFileName := GenerateTempFilename;
  if XMLFileName <> '' then
  Begin
    // 20171229 Igor >>>
    try
      GetFileWithNoCache(URLVersionFile, XMLFileName);
    //20180227 Igor >>>
    except on E: Exception do
      begin
        DeleteFile(XMLFileName); //20180220 Igor
        ShowMessage('There is no internet connection to the web site. Some functions will not be available');
      end;
    end;
    //20180227 Igor <<<
    {
    with  TDownloadURL.Create(nil) do
    try
      URL := URLVersionFile + '?readtime='+formatdatetime('yyyymmddhhnnss',now);
      Filename := XMLFileName;
      try
        ExecuteTarget(nil);
      except
      end;
    finally
      Free;
    end;
    }
    // 20171229 Igor <<<
    if fileExists(XMLFileName) then
    Begin
      XMLDoc.FileName := XMLFileName;
      //20180220 Igor >>>
      try
        XMLDoc.Active:=True;
        LoadXML := True;
      except
        LoadXML := false;
      end;
      if LoadXML then
      begin
        RootNode := XMLDoc.ChildNodes.FindNode('UPDATE');
        for K := 0 to RootNode.ChildNodes.Count - 1 do
        Begin
          ANode := RootNode.ChildNodes.Get(K);
          //20191007 Igor >>>
          if SameText(String(ANode.ChildNodes.FindNode('NAME').NodeValue),ChangeFileExt(ExtractFileName(Application.ExeName),''))
             or
             SameText(String(ANode.ChildNodes.FindNode('NAME').NodeValue).Replace('vt', 'vtDebug'),ChangeFileExt(ExtractFileName(Application.ExeName),'')) then
          //20191007 Igor <<<
          Begin
            mtModuleActualVersion.AsString := String(ANode.ChildNodes.FindNode('DATEUPDATE').NodeValue);
            mtModuleHaveUpdate.AsBoolean := MyStrToDate(String(ANode.ChildNodes.FindNode('DATEUPDATE').NodeValue)) >
                                            MyStrToDate(AppUpdateDate);
            mtModuleNeedUpdate.AsBoolean := True;
            //20160601 Igor
            if mtModuleHaveUpdate.AsBoolean then
            begin
              mtModuleModuleStatus.AsString := c_UpdateRequired;
              btnUpdate.Tag := 1;
            end
            else
              mtModuleModuleStatus.AsString := c_UpToDate;
  //          if MyStrToDate(String(ANode.ChildNodes.FindNode('DATEUPDATE').NodeValue)) > MyStrToDate(AppUpdateDate)  then
  //          Begin
  //            lblUpdateState.Caption := 'Have update '+String(ANode.ChildNodes.FindNode('DATEUPDATE').NodeValue);
  //            lblUpdateState.Visible := true;
  //          end;
            break;
          end;
        end;
      end;
      //20180220 Igor <<<
    end;
  end;
  mtModule.Post;

  //20160425 Igor <<<<
//  lvApplications.Clear;
  for I := 0 to AppList.Count - 1 do
  Begin
    with TApp(AppList.Objects[I]) do
    Begin
      mtModule.Append;
      mtModuleIndex.AsInteger := I;
      mtModuleDisabled.AsBoolean := (ProductName = '') or MainOptions.isDisabledApp(AppId);
      Disabled := mtModuleDisabled.AsBoolean;
      mtModuleName.AsString := AppList[I];
      mtModuleLicense.AsString := ProductName;
      mtModuleCurentVersion.AsString := AppUpdateDate;
      mtModuleHelpFile.AsString := ModuleHelpUpdFile;
      //20170112 Igor >>>
      if LicenseLevel in anyMulti then
        HaveMulti := True;
      //20170112 Igor <<<
//      LI := lvApplications.Items.Add;
//      LI.Caption := AppList[I];
//      LI.SubItems.Add(ProductName);
      if ProductName = '' then
      Begin
        mtModuleNeedUpdate.AsBoolean := False;
        NeedUpdate := False;
        //20160721 Igor
//        lvApplications.Hint := 'To activate the module, enter the license key ( [Help] -> [About...] )';
//        LI.SubItems.Add('N/A');
      end
      else
      Begin
        if XMLDoc.Active then
        Begin
          for K := 0 to RootNode.ChildNodes.Count - 1 do
          Begin
            ANode := RootNode.ChildNodes.Get(K);
            if String(ANode.ChildNodes.FindNode('NAME').NodeValue) = AppTitle then
            Begin
              mtModuleActualVersion.AsString := String(ANode.ChildNodes.FindNode('DATEUPDATE').NodeValue);
//              if FileExists(ModuleHelpUpdFile) then  //20160808 Igor
                mtModuleHelpName.AsString := 'Click to review';
              mtModuleHaveUpdate.AsBoolean := MyStrToDate(String(ANode.ChildNodes.FindNode('DATEUPDATE').NodeValue)) >
                                              MyStrToDate(AppUpdateDate);
              mtModuleNeedUpdate.AsBoolean := True;
              NeedUpdate := mtModuleNeedUpdate.AsBoolean;
              //20160601 Igor
              if mtModuleHaveUpdate.AsBoolean then
              begin
                mtModuleModuleStatus.AsString := c_UpdateRequired;
                btnUpdate.Tag := 1;
              end
              else
                mtModuleModuleStatus.AsString := c_UpToDate;
              break;
            end;
          end;
        end
//        else
//          LI.SubItems.Add('N/A');
      end;
      mtModule.Post;
      //20160425 Igor <<<<
    End;
  End;

  //20190917 Igor >>>
  mtModule.Append;
  mtModuleDisabled.AsBoolean := false;
  mtModuleName.AsString := 'Utilities';
  mtModuleLicense.AsString := 'Utilities';
  mtModuleCurentVersion.AsString := GetUtilitiesDateUpdate;
  if LoadXML then
  begin
    RootNode := XMLDoc.ChildNodes.FindNode('UPDATE');
    for K := 0 to RootNode.ChildNodes.Count - 1 do
    Begin
      ANode := RootNode.ChildNodes.Get(K);
      if SameText(String(ANode.ChildNodes.FindNode('NAME').NodeValue),mtModuleName.AsString) then
      Begin
        mtModuleActualVersion.AsString := String(ANode.ChildNodes.FindNode('DATEUPDATE').NodeValue);
        mtModuleHaveUpdate.AsBoolean := MyStrToDate(String(ANode.ChildNodes.FindNode('DATEUPDATE').NodeValue)) >
                                        MyStrToDate(GetUtilitiesDateUpdate);
        mtModuleNeedUpdate.AsBoolean := True;
        if mtModuleHaveUpdate.AsBoolean then
        begin
          mtModuleModuleStatus.AsString := c_UpdateRequired;
          btnUpdate.Tag := 1;
        end
        else
          mtModuleModuleStatus.AsString := c_UpToDate;
        break;
      end;
    end;
  end;
  mtModule.Post;
  //20190917 Igor <<<

  if XMLDoc.Active then
    XMLDoc.Active := False;
  if (XMLFileName <> '') AND FileExists(XMLFileName) then
    DeleteFile(XMLFileName);
  //20170112 Igor >>>
  if HaveMulti then
  begin
    NameBox.Visible := True;
    Label2.Visible := True;
    PswdBox.Visible := True;
    PswdLabel.Visible := True;
    GetLoginNames(NameBox.Items);
    NameBox.Text := MainOptions.SingleLoginId;
    if NameBox.Text = 'ADMIN' then
      PswdBox.Text := 'ADMIN';
  end
  else
  begin
    NameBox.Visible := True; //20170115 Igor
    Label2.Visible := True;  //20170115 Igor
    PswdBox.Visible := False;
    PswdLabel.Visible := False;
    GetLoginNames(NameBox.Items); //20170115 Igor
    NameBox.Text := MainOptions.SingleLoginId;//20170115 Igor
  end;
  //20170112 Igor <<<
end;

procedure TLogon.CheckBox1Click(Sender: TObject);
begin
  //CheckBox1.Checked := True;
end;

procedure TLogon.grModulesCellClick(Column: TColumn);
begin
  if SameText(Column.FieldName,'Disabled') and (mtModuleLicense.AsString <> '')
     and Not SameText(mtModuleLicense.AsString, 'Base module') //20170212 Igor
     and Not SameText(mtModuleLicense.AsString, 'Utilities')  then //20190917 Igor
  Begin
  //20170803 Igor>>>
    AppList.GetApp(mtModuleIndex.asInteger).Disabled := not mtModuleDisabled.AsBoolean;
    if AppList.GetApp(mtModuleIndex.asInteger).Disabled <> mtModuleDisabled.AsBoolean then
    begin
      if mtModule.State <> dsEdit then
        mtModule.Edit;
      mtModuleDisabled.AsBoolean := not mtModuleDisabled.AsBoolean;
      mtModule.Post;
    end;
    //20170803 Igor<<<
  End;
  if SameText(Column.FieldName,'HelpName') and (mtModuleHelpFile.AsString <> '') then
  Begin
    ConnectToWeb(mtModuleHelpFile.AsString); //20171204
   // ShowHelp(mtModuleHelpFile.asString, 'HELP_CONTENTS', True); //20160801 Igor
  End;
  if SameText(Column.FieldName,'NeedUpdate') then
  Begin
    if mtModule.State <> dsEdit then
      mtModule.Edit;
    mtModuleNeedUpdate.AsBoolean := not mtModuleNeedUpdate.AsBoolean;
    mtModule.Post;
    AppList.GetApp(mtModuleIndex.asInteger).NeedUpdate := mtModuleNeedUpdate.AsBoolean;
  End;

end;

procedure TLogon.grModulesDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  clr: TColor;
begin
  if sametext(Column.FieldName,mtModuleDisabled.FieldName) then
  Begin
    grModules.Canvas.FillRect(Rect);
    //20160529 Igor
    if mtModuleDisabled.AsBoolean then
    Begin
      ilCheck.Draw(grModules.Canvas,(Rect.Left + (Rect.Right - Rect.Left) div 2) - (ilCheck.Width div 2),Rect.Top,0);
    End
    else
    begin
      ilCheck.Draw(grModules.Canvas,(Rect.Left + (Rect.Right - Rect.Left) div 2) - (ilCheck.Width div 2),Rect.Top,1);
    end;
//    clr := grModules.Canvas.Brush.Color;
//    if not mtModuleDisabled.AsBoolean then
//    Begin
//      grModules.Canvas.Brush.Color := clGreen;
//    End
//    else
//    Begin
//      grModules.Canvas.Brush.Color := clGray;
//    End;
//    grModules.Canvas.FillRect(Rect);
//    grModules.Canvas.Brush.Color := clr;
  End;

//20160601 Igor
//  if sametext(Column.FieldName,mtModuleActualVersion.FieldName) then
//  Begin
//    if mtModuleHaveUpdate.AsBoolean then
//    Begin
//      grModules.Canvas.FillRect(Rect);
//      grModules.Canvas.Font.Color := clGreen;
//      grModules.Canvas.TextOut(Rect.Left+2, Rect.Top+2, mtModuleActualVersion.AsString);
//    End;
//  End;
  if SameText(Column.FieldName,mtModuleHelpName.FieldName) then
  Begin
    if mtModuleHelpFile.AsString <> '' then
    Begin
      grModules.Canvas.FillRect(Rect);
      grModules.Canvas.Font.Style := [fsUnderline];
      grModules.Canvas.TextOut(Rect.Left+2, Rect.Top+2, mtModuleHelpName.AsString);
    End;
  End;
  //201606001 Igor
  if SameText(Column.FieldName,mtModuleModuleStatus.FieldName) then
  Begin
    if mtModuleHaveUpdate.AsBoolean then
    Begin
      grModules.Canvas.Brush.Color := clRed;
      grModules.Canvas.Font.Color := clWhite;
    End
    else
    Begin
      grModules.Canvas.Font.Color := clGreen;
    End;
    grModules.Canvas.FillRect(Rect);
    grModules.Canvas.TextOut(Rect.Left+2, Rect.Top+2, mtModuleModuleStatus.AsString);
  End;

  if sametext(Column.FieldName,mtModuleNeedUpdate.FieldName) then
  Begin
    grModules.Canvas.FillRect(Rect);
    if mtModuleNeedUpdate.AsBoolean then
    Begin
      ilCheck.Draw(grModules.Canvas,(Rect.Left + (Rect.Right - Rect.Left) div 2) - (ilCheck.Width div 2),Rect.Top,1);
//      grModules.Canvas.Brush.Color := clGreen;
//      grModules.Canvas.FillRect(Rect);
    End
    else
    Begin
      ilCheck.Draw(grModules.Canvas,(Rect.Left + (Rect.Right - Rect.Left) div 2) - (ilCheck.Width div 2),Rect.Top,0);
//      grModules.Canvas.Brush.Color := clRed;
//      grModules.Canvas.FillRect(Rect);
    End;
  End;
end;

procedure TLogon.HelpbtnClick(Sender: TObject);
begin
 ConnectToWeb('https://www.visualtax.com/Vt2020HELP/vtBaseHelp/vtHelp.html'); //20210305 CON
// ConnectToWeb('http://www.visualtax.com/Vt2016HELP/vtBaseHelp/vt2016Help.html');  //20161218 //20161220 Igor
 // ShowHelp(RedesignFile,'Logon',true); //20161211
//  ShowHelp(MainHelpFile,'Logon', True); //20160601 Igor //20161220 Igor
end;

procedure TLogon.lblRedesignDocumentMouseEnter(Sender: TObject);  //20160705 Igor
begin
  (Sender as TLabel).Font.Style := (Sender as TLabel).Font.Style + [fsUnderline];
end;

procedure TLogon.lblRedesignDocumentMouseLeave(Sender: TObject);  //20160705 Igor
begin
  (Sender as TLabel).Font.Style := (Sender as TLabel).Font.Style - [fsUnderline];
end;

procedure TLogon.lblHelpMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clBlue;
  (Sender as TLabel).Font.Style := (Sender as TLabel).Font.Style + [fsUnderline];
end;

procedure TLogon.lblHelpMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clBlack;
  (Sender as TLabel).Font.Style := (Sender as TLabel).Font.Style - [fsUnderline];
end;

procedure TLogon.lvApplicationsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.SubItems[0] = '' then
    Sender.Canvas.Font.Color := clGray;
end;

end.

