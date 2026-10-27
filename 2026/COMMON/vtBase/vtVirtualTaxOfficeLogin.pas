Unit vtVirtualTaxOfficeLogin;

interface

uses
  SysUtils, FileCtrl, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids, DBCtrls,
  Vcl.Mask, vteditbox, vtLabel, vtShape, ShellApi, System.Generics.Collections,
  System.IOUtils, Data.DBXJSON, vtVirtualTaxOffice, Vcl.ImgList, System.UITypes; //20210118 Igor //20210202 Igor

type
  TvtVirtualTaxOfficeLogin = class(TForm)
    shHeader: TvtShape;
    vtLabel37: TvtLabel;
    GroupBox1: TGroupBox;
    gbLogin: TGroupBox;
    lbCyberId: TLabel;
    edCyberId: TEdit;
    Label1: TLabel;
    edPassword: TEdit;
    btnLogin: TButton;
    gbRegister: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    edFirstName: TEdit;
    edNewPassword: TEdit;
    btnRegister: TButton;
    Label4: TLabel;
    edLastName: TEdit;
    Label5: TLabel;
    edEmail: TEdit;
    Label6: TLabel;
    edConfirmPassword: TEdit;
    Label7: TLabel;
    edTaxOfficeCyberId: TEdit;
    lbRegister: TLabel;
    //20210118 Igor >>>
    btnUpdate: TSpeedButton;
    il16: TImageList;
    cbSavePasswordAndAutoLogin: TCheckBox;
    //20210118 Igor <<<
    procedure btnLoginClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbRegisterMouseEnter(Sender: TObject);
    procedure lbRegisterMouseLeave(Sender: TObject);
    procedure lbRegisterClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure cbSavePasswordAndAutoLoginClick(Sender: TObject); //20210118 Igor
  //20210205 Igor >>>
  protected
    procedure CreateParams(var Params: TCreateParams) ; override;
  //20210205 Igor <<<
  private
    { Private declarations }
    FNeedUpdate: boolean; //20210118 Igor
    procedure RegisterVisible(AValue: boolean);
    procedure RunCheckUpdate; //20210118 Igor
  public
    { Public declarations }
  end;

  function LoginToVirtualTaxOffice: boolean;
  function AutoLoginToVirtualTaxOffice: boolean; //20210426 Igor

implementation

{$R *.dfm}

Uses
  vtMulti, vtCommon, vtDialogs, vtShared, Variants, Xml.XMLDoc, Xml.XMLIntf; //20210118 Igor //20210120 Igor

function LoginToVirtualTaxOffice: boolean;
var
  FVirtualTaxOfficeLogin: TvtVirtualTaxOfficeLogin;
begin
  FVirtualTaxOfficeLogin := TvtVirtualTaxOfficeLogin.Create(Application);
  try
    Result := FVirtualTaxOfficeLogin.ShowModal = mrOk;
  finally
    FVirtualTaxOfficeLogin.Free;
  end;
end;

function AutoLoginToVirtualTaxOffice: boolean; //20210426 Igor
var
  FVirtualTaxOfficeLogin: TvtVirtualTaxOfficeLogin;
begin
  FVirtualTaxOfficeLogin := TvtVirtualTaxOfficeLogin.Create(Application);
  try
    FVirtualTaxOfficeLogin.FormShow(FVirtualTaxOfficeLogin);
    if FVirtualTaxOfficeLogin.cbSavePasswordAndAutoLogin.Checked and
       not String(FVirtualTaxOfficeLogin.edCyberId.Text).IsEmpty and
       not String(FVirtualTaxOfficeLogin.edPassword.Text).IsEmpty then
      FVirtualTaxOfficeLogin.btnLogin.Click;
  finally
    FVirtualTaxOfficeLogin.Free;
  end;
end;

procedure TvtVirtualTaxOfficeLogin.btnLoginClick(Sender: TObject);
var CyberId, Password: string;
    FParams: TParamList;
    Res: TJSONObject;
    //20201222 Igor >>>
    nExpireDays: integer;
    cWarningMessage: string;
    //20201222 Igor <<<

    function GetAppVersion(const FileName: string = ''): string; //20210205 Igor
    var
      V1, V2, V3, V4 : Word;
      VerInfoSize:  DWORD;
      VerInfo:      Pointer;
      VerValueSize: DWORD;
      VerValue:     PVSFixedFileInfo;
      Dummy:        DWORD;
      s: string;
    begin
      V1 := 0; V2 := 0; V3 := 0; V4 := 0;
      if FileName = '' then
        s := ParamStr(0) else
        s := FileName;
      VerInfoSize := GetFileVersionInfoSize(PCHar(s), Dummy);
      if VerInfoSize > 0 then
        begin
          GetMem(VerInfo, VerInfoSize);
          GetFileVersionInfo(PChar(s), 0, VerInfoSize, VerInfo);
          if VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize) then
            with VerValue^ do
              begin
                V1 := dwFileVersionMS shr 16;
                V2 := dwFileVersionMS and $FFFF;
                V3 := dwFileVersionLS shr 16;
                V4 := dwFileVersionLS and $FFFF;
              end
          else RaiseLastOSError;
          FreeMem(VerInfo, VerInfoSize);
        end;
      Result := Format('%d.%d.%d.%d', [V1, V2, V3, V4]);
    end;

begin
  CyberId := edCyberId.Text;
  Password := edPassword.Text;
  if CyberId.IsEmpty then
  begin
    edCyberId.SetFocus;
    ShowMessage('Virtual ID is not entered'); //20210201 Igor
    Exit;
  end;
  //20201222 Igor >>>
  if IsvtClient and (VirtualTaxOfficeInfo.GetAccountType(CyberId) <> vtoPayer) then //20210112 Igor
  begin
    edCyberId.SetFocus;
    ShowMessage('Only Virtual Client accounts are allowed in vtClient'); //20210112 Igor
    Exit;
  end;
  //20201222 Igor <<<
  if Password.IsEmpty then
  begin
    edPassword.SetFocus;
    ShowMessage('Password is not entered');
    Exit;
  end;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action','LOGIN');
    FParams.AddParam('CyberId', CyberId);
    FParams.AddParam('Password', Password);
    FParams.AddParam('DesktopMode', 'true'); //20210201 Igor
    //20210205 Igor >>>
    FParams.AddParam('Application', ExtractFileName(Application.ExeName));
    FParams.AddParam('Version', GetAppVersion);
    //20210205 Igor <<<
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        VirtualTaxOfficeInfo.SessionId := GetJSONValue(Res, 'session_id');
        VirtualTaxOfficeInfo.CyberId := CyberId;
        VirtualTaxOfficeInfo.CyberIdPassword := Password;
        //20210426 Igor >>>
        if cbSavePasswordAndAutoLogin.Checked then
          VirtualTaxOfficeInfo.SaveOption('SavedPassword', Password, true);
        //20210426 Igor <<<
        //20201221 Igor >>>
        {nExpireDays := GetJSONIntValue(Res, 'ExpireDays');
        cWarningMessage := '';
        if (nExpireDays <= 10) and (nExpireDays > 1) then
          cWarningMessage := #13#10#13#10 + 'Your account will expire in '+ IntToStr(nExpireDays) + ' days'
        else if nExpireDays = 1 then
          cWarningMessage := #13#10#13#10 + 'Your account will expire in '+ IntToStr(nExpireDays) + ' day';}
        //20210202 Igor >>>
        if ShowVtLoginMessage and Self.Visible then //20210426 Igor
        begin
          if IsvtClient then //20210112 Igor
            ShowMessageInfo('You are logged in now. '+
                        'You can choose the functions available om Virtual Client panel.'+ //20210118 Igor
                        cWarningMessage)
          else
            ShowMessageInfo('You are logged in now. '+
                        'You can choose the functions available in the Virtual Tax Office dropdown.'+ //20210118 Igor
                        cWarningMessage);
        end;
        //20210202 Igor <<<
        //20201221 Igor <<<
        ModalResult := mrOk;
      end
      else
      begin
        //20210426 Igor >>>
        if Self.Visible then
        begin
          if SameText(GetJSONValue(Res, 'type'), 'cyberid') then
            edCyberId.SetFocus
          else if SameText(GetJSONValue(Res, 'type'), 'password') then
            edPassword.SetFocus;
        end;
        //20210426 Igor <<<
        ShowMessageError(GetJSONValue(Res, 'error_message')); //20201221 Igor
      end;
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

procedure TvtVirtualTaxOfficeLogin.btnRegisterClick(Sender: TObject);
var FirstName, LastName, Email, Password, ConfirmPassword, TaxOfficeCyberId: string;
    FParams: TParamList;
    Res: TJSONObject;
begin
  FirstName := edFirstName.Text;
  LastName := edLastName.Text;
  Email := edEmail.Text;
  Password := edNewPassword.Text;
  ConfirmPassword := edConfirmPassword.Text;
  TaxOfficeCyberId := edTaxOfficeCyberId.Text;
  if FirstName.IsEmpty then
  begin
    edFirstName.SetFocus;
    ShowMessage('First Name is not entered');
    Exit;
  end;
  if LastName.IsEmpty then
  begin
    edLastName.SetFocus;
    ShowMessage('Last Name is not entered');
    Exit;
  end;
  if Email.IsEmpty then
  begin
    edEmail.SetFocus;
    ShowMessage('Email is not entered');
    Exit;
  end;
  if Password.IsEmpty then
  begin
    edNewPassword.SetFocus;
    ShowMessage('Password is not entered');
    Exit;
  end;
  if ConfirmPassword.IsEmpty then
  begin
    edConfirmPassword.SetFocus;
    ShowMessage('Confirm Password is not entered');
    Exit;
  end;
  if Password <> ConfirmPassword then
  begin
    edConfirmPassword.SetFocus;
    ShowMessage('Password and Confirm Password are not the same');
    Exit;
  end;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action','REGISTER_PAYER');
    FParams.AddParam('FirstName', FirstName);
    FParams.AddParam('LastName', LastName);
    FParams.AddParam('Email', Email);
    FParams.AddParam('Password', Password);
    FParams.AddParam('ConfirmPassword', ConfirmPassword);
    if not TaxOfficeCyberId.IsEmpty then
      FParams.AddParam('TaxOfficeCyberId', TaxOfficeCyberId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        edCyberId.Text := GetJSONValue(Res, 'cyberid');
        edFirstName.Text := '';
        edLastName.Text := '';
        edEmail.Text := '';
        edNewPassword.Text := '';
        edConfirmPassword.Text := '';
        edTaxOfficeCyberId.Text := '';
        RegisterVisible(false);
        ShowMessage('Your account was successfully registered. Please, check your email for activation link before you login');
      end
      else
      begin
        if SameText(GetJSONValue(Res, 'type'), 'first_name') then
          edFirstName.SetFocus
        else if SameText(GetJSONValue(Res, 'type'), 'last_name') then
          edLastName.SetFocus
        else if SameText(GetJSONValue(Res, 'type'), 'email') then
          edEmail.SetFocus
        else if SameText(GetJSONValue(Res, 'type'), 'password') then
          edPassword.SetFocus
        else if SameText(GetJSONValue(Res, 'type'), 'confirm_password') then
          edConfirmPassword.SetFocus
        else if SameText(GetJSONValue(Res, 'type'), 'taxoffice_cyberid') then
          edTaxOfficeCyberId.SetFocus;
        ShowMessageError(GetJSONValue(Res, 'error_message')); //20201221 Igor
      end;
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

procedure TvtVirtualTaxOfficeLogin.btnUpdateClick(Sender: TObject); //20210118 Igor
begin
  if not FNeedUpdate then
    if MessageDlg('Do you want to Update again?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      exit;
  Checkupdates(Handle,'???');
end;

procedure TvtVirtualTaxOfficeLogin.cbSavePasswordAndAutoLoginClick( //20210426 Igor
  Sender: TObject);
begin
  if cbSavePasswordAndAutoLogin.Checked then
    VirtualTaxOfficeInfo.SaveOption('AutoLogin', 'Y')
  else
    VirtualTaxOfficeInfo.SaveOption('AutoLogin', 'N');
end;

procedure TvtVirtualTaxOfficeLogin.CreateParams(var Params: TCreateParams); //20210205 Igor
begin
  inherited;
  if not Assigned(Application.MainForm) or not Application.MainForm.Visible then //20210326 Igor
  begin
    Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
    Params.WndParent := 0;
  end;
end;

procedure TvtVirtualTaxOfficeLogin.FormCreate(Sender: TObject);
begin
  RegisterVisible(false);
  //20210118 Igor >>>
  FNeedUpdate := false;
  if IsVtClient then
    Caption := 'Virtual Client Login'
  else
    Caption := 'Virtual Office Login';
  //20210118 Igor <<<
end;

procedure TvtVirtualTaxOfficeLogin.FormShow(Sender: TObject);
begin
  lbRegister.Visible := false; //20210113 Igor
  //20210118 Igor >>>
  if IsVtClient then
    edCyberId.Text := VirtualTaxOfficeInfo.ReadOption('PayerCyberID')
  else
    edCyberId.Text := VirtualTaxOfficeInfo.ReadOption('OfficeCyberID');
  //20210118 Igor <<<
  //20210426 Igor >>>
  cbSavePasswordAndAutoLogin.OnClick := nil;
  try
    cbSavePasswordAndAutoLogin.Checked := SameText(VirtualTaxOfficeInfo.ReadOption('AutoLogin'), 'Y');
    if cbSavePasswordAndAutoLogin.Checked then
      edPassword.Text := VirtualTaxOfficeInfo.ReadOption('SavedPassword', true);
  finally
    cbSavePasswordAndAutoLogin.OnClick := cbSavePasswordAndAutoLoginClick;
  end;
  //20210426 Igor <<<
  if Self.Visible then
  begin
    if String(edCyberID.Text).IsEmpty then
      edCyberId.SetFocus
    else
      edPassword.SetFocus;
  end;
    //20210118 Igor >>>
  if IsVtClient and ShowVtLoginMessage then //20210205 Igor
    RunCheckUpdate
  else
    btnUpdate.Visible := false;
    //20210118 Igor <<<
end;

procedure TvtVirtualTaxOfficeLogin.lbRegisterClick(Sender: TObject);
begin
  RegisterVisible(not gbRegister.Visible);
end;

procedure TvtVirtualTaxOfficeLogin.lbRegisterMouseEnter(Sender: TObject);
begin
  lbRegister.Font.Style := [fsUnderline];
end;

procedure TvtVirtualTaxOfficeLogin.lbRegisterMouseLeave(Sender: TObject);
begin
  lbRegister.Font.Style := [];
end;

procedure TvtVirtualTaxOfficeLogin.RegisterVisible(AValue: boolean);
begin
  if AValue then
  begin
    gbRegister.Visible := true;
    lbRegister.Caption := 'Hide';
    ClientHeight := shHeader.Height + gbLogin.Height + 15 + gbRegister.Height + 10;
    Top := Top - (gbRegister.Height + 10) div 2;
  end
  else
  begin
    gbRegister.Visible := false;
    lbRegister.Caption := 'Register';
    ClientHeight := shHeader.Height + gbLogin.Height + 15;
    Top := Top + (gbRegister.Height + 10) div 2;
  end;
end;

procedure TvtVirtualTaxOfficeLogin.RunCheckUpdate;   //20210118 Igor
var XMLText: String;
    XMLDoc: XML.XMLDoc.TXMLDocument;
    RootNode, ANode: IXMLNode;
    I: integer;
    bFound: boolean;

    function MyStrToDate(S: String): TDateTime;
    var
      Y,M,D: Word;
    begin
      Y := StrToInt(copy(S,1,4));
      M := StrToInt(copy(S,6,2));
      D := StrToInt(copy(S,9,2));
      Result := EncodeDate(Y,M,D);
    end;
begin
  FNeedUpdate := false;
  try
    XMLText := VirtualTaxOfficeInfo.GetFileContent(URLVersionFile);
  except on E: Exception do
    begin
      ShowMessage('There is no internet connection to the web site. Some functions will not be available'+ #13#10#13#10 + E.Message);
    end;
  end;
  if not XMLText.IsEmpty and Assigned(CurrentApp) then
  begin
    XMLDoc := XML.XMLDoc.TXMLDocument.Create(Application);
    try
      try
        XMLDoc.XML.Clear;
        XMLDoc.XML.Add(XMLText);
        if not (XMLDoc.Active) then
          XMLDoc.Active := true;
        RootNode := XMLDoc.ChildNodes.FindNode('UPDATE');
        bFound := false;
        for I := 0 to RootNode.ChildNodes.Count - 1 do
        begin
          ANode := RootNode.ChildNodes.Get(I);
          if SameText(String(ANode.ChildNodes.FindNode('NAME').NodeValue), ChangeFileExt(ExtractFileName(Application.ExeName),'')) then
          begin
            FNeedUpdate := MyStrToDate(String(ANode.ChildNodes.FindNode('DATEUPDATE').NodeValue)) > MyStrToDate(CurrentApp.vtClientUpdateDate);
            bFound := true;
            break;
          end;
        end;
        if not bFound then
          ShowMessageWarning('vtClient section is not found in vtVersions.xml');
      except on E: Exception do
        ShowMessageError('Error occured during check version procedure: '+ #13#10#13#10 + E.Message);
      end;
    finally
      XMLDoc.Free;
    end;
  end;

  btnUpdate.Visible := true;
  if FNeedUpdate then
  begin
    il16.GetBitmap(0, btnUpdate.Glyph);
    //20210203 Igor >>>
    btnUpdate.Caption := 'Update from the web is required'; 
    btnUpdate.Width := 190;
    //20210203 Igor <<<
  end;
end;

end.
