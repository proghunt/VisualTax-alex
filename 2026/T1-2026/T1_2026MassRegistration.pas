unit T1_2026MassRegistration;

interface

uses SysUtils,WinTypes,WinProcs,Messages,Classes,Graphics,Controls,Forms,
  Dialogs,StdCtrls,Buttons,Grids,ExtCtrls, System.Generics.Collections,
  vtMulti, Vcl.Menus, uADStanIntf, uADStanOption,
  uADStanParam, uADStanError, uADDatSManager, uADPhysIntf, uADDAptIntf, Data.DB,
  uADCompDataSet, uADCompClient, Vcl.DBGrids, System.IOUtils, Data.DBXJSON,
  vtVirtualTaxOffice, Vcl.ComCtrls, Vcl.OleCtrls, SHDocVw, MSHTML, ActiveX, //20201222 Igor
  vtEditHTML; //20210129 Igor

const ALREADY_REGISTERED = 'FAILED: This Email is already registered'; //20210317 Igor

type
  TMassRegisterThread = class; //20201222 Igor

  TMassRegistrationT1_2026 = class(TForm)
    pnlCaption: TPanel;
    pnlBottom: TPanel;
    QPayers: TADMemTable;
    grPayers: TDBGrid;
    QPayersLAST_NAME: TStringField;
    QPayersFIRST_NAME: TStringField;
    QPayersEMAIL: TStringField;
    QPayersRESULT: TStringField;
    dsPayers: TDataSource;
    QPayersREGISTERED: TBooleanField;
    QPayersERROR: TBooleanField;
    btnRegister: TButton;
    btnCancel: TButton;
    pnlButtons: TPanel;
    pnlProgress: TPanel;
    pbProgress: TProgressBar;
    lbProgress: TLabel;
    ThreadTimer: TTimer;
    lbTime: TLabel;
    pnlTemplate: TPanel;
    lbTemplateCaption: TLabel;
    pnlTemplateHeader: TPanel;
    btnSendTestEmail: TSpeedButton;
    btnCreateOwn: TSpeedButton;
    rbDefault: TRadioButton;
    rbOwn: TRadioButton;
    wbPreview: TWebBrowser;
    pnlPreview: TPanel;
    Splitter1: TSplitter;
    btnHelp: TButton;
    btnResetToDefault: TSpeedButton;
    pmGrid: TPopupMenu;
    Resendregistrationemail1: TMenuItem;
    cbSendEmail: TCheckBox; //20220303 Igor
    procedure FormShow(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure grPayersDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ThreadTimerTimer(Sender: TObject);
    procedure btnSendTestEmailClick(Sender: TObject);
     //20210129 Igor >>>
    procedure btnHelpClick(Sender: TObject);
    procedure QPayersAfterScroll(DataSet: TDataSet);
    procedure wbPreviewCommandStateChange(ASender: TObject; Command: Integer;
      Enable: WordBool);
    procedure btnCreateOwnClick(Sender: TObject);
    procedure rbDefaultClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    //20210129 Igor <<<
    //20210201 Igor >>>
    procedure btnResetToDefaultClick(Sender: TObject);
    procedure wbPreviewBeforeNavigate2(ASender: TObject; const pDisp: IDispatch;
      const URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure Resendregistrationemail1Click(Sender: TObject); //20210205 Igor
    procedure cbSendEmailClick(Sender: TObject); //20220303 Igor
    //20210201 Igor <<<
    //20210127 Igor <<<
  private
    { Private declarations }
    //20201222 Igor >>>
    FThread: TMassRegisterThread;
    FProcessedCount: integer;
    FStartTime: TDateTime;
    //20201222 Igor <<<
    FTemplateChanged: boolean; //20210127 Igor
     //20210129 Igor >>>
    FDefaultTemplate: string;
    FOwnTemplate: string;
    FOfficeName: string;
    FOfficePhone: string;
    FOfficeCyberId: string;
    FSingleMode: boolean;
    FEmail: string;
    FFirstName: string;
    FLastName: string;
    //20210129 Igor <<<
    FSkipLinkIntercept: boolean; //20210201 Igor
    procedure LoadPayersFromClientsDb;
    //20201222 Igor >>>
    procedure ThreadStarted;
    procedure ThreadFinished;
    function GetRecord(var AFirstName, ALastName, AEmail: string): boolean;
    procedure SaveRecordAndNext(AResult: string; ARegistered, AError: boolean);
    //20201222 Igor <<<
    //20210127 Igor >>>
     //20210129 Igor >>>
    procedure InitDefaultTemplate;
    procedure InitOwnTemplate;
    procedure InitOffice;
    function CheckTemplate(ATemplate: string): boolean;
    function SaveTemplate(ATemplate: string): boolean;
    //20210127 Igor <<<
    procedure InitMode;
    procedure RefreshPreview;
     //20210129 Igor <<<
  public
    { Public declarations }
  end;

  TMassRegisterThread = class(TThread) //20201222 Igor
  private
    FForm: TMassRegistrationT1_2026;
  protected
    procedure Execute; override;
    constructor Create(AForm: TMassRegistrationT1_2026);
  end;

  procedure SingleRegistration(ARetNo: integer = 0); //20201216 Igor
  procedure MassRegistration; //20210201 Igor

implementation

{$R *.DFM}

uses vtCommon,T1_2026,T1_2026Common,T1_2026Common2,T1_2026TrimStr,
  T1_2026Declare,T1_2026ChildWinNEW,vtTrimStr,vtShared,vtDatabase,
  vtDialogs,DateUtils; //20201222 Igor

procedure SingleRegistration(ARetNo: integer = 0); //20201216 Igor  //20210129 Igor
var FMassRegistrationT1_2026: TMassRegistrationT1_2026;
begin
  FMassRegistrationT1_2026 := TMassRegistrationT1_2026.Create(Screen.ActiveForm);
  try
    FMassRegistrationT1_2026.FSingleMode := true;
    FMassRegistrationT1_2026.FEmail := FetchElm(ARetNo,'INFO', 140);
    FMassRegistrationT1_2026.FFirstName := FetchElm(ARetNo,'INFO', 2);
    FMassRegistrationT1_2026.FLastName := FetchElm(ARetNo,'INFO', 5);
    //20210201 Igor >>>
    FMassRegistrationT1_2026.LoadPayersFromClientsDb;
    if FMassRegistrationT1_2026.QPayers.RecordCount = 0 then
      ShowMessage('There are no Clients with Emails. Please, enter Email on the Info form')
    else
      FMassRegistrationT1_2026.ShowModal;
    //20210201 Igor <<<
  finally
    FMassRegistrationT1_2026.Free;
  end;
end;

procedure MassRegistration; //20210201 Igor
var FMassRegistrationT1_2026: TMassRegistrationT1_2026;
begin
  FMassRegistrationT1_2026 := TMassRegistrationT1_2026.Create(Screen.ActiveForm);
  try
    FMassRegistrationT1_2026.LoadPayersFromClientsDb;
    if FMassRegistrationT1_2026.QPayers.RecordCount = 0 then
      ShowMessage('There are no Clients with Emails. Please, enter Email on the Info form')
    else
      FMassRegistrationT1_2026.ShowModal;
  finally
    FMassRegistrationT1_2026.Free;
  end;
end;

{ TMassRegistrationT1_2026 }

procedure TMassRegistrationT1_2026.btnCreateOwnClick(Sender: TObject);  //20210129 Igor
begin
  if FOwnTemplate.IsEmpty then
    FOwnTemplate := FDefaultTemplate;
  if RunEditHTML(FOwnTemplate, SaveTemplate) then
  begin
    InitMode;
    if rbOwn.Enabled then
      rbOwn.Checked := true;
    RefreshPreview;
  end;
end;
 
procedure TMassRegistrationT1_2026.btnHelpClick(Sender: TObject);  //20210129 Igor
begin
  ConnectToWeb('https://www.visualtax.com/vtMassRegistration.php');
end;

procedure TMassRegistrationT1_2026.btnRegisterClick(Sender: TObject); //20201222 Igor
var FRecNo: integer;
    FParams: TParamList;
    Res: TJSONObject;
begin
  if Assigned(FThread) then
  begin
    if MessageDlg('Are you sure you want to cancel registration ?',
            mtInformation, [mbYes, mbNo], 0) <> mrYes then Exit;
    FThread.Terminate;
    btnRegister.Enabled := false;
  end
  else
  begin
    if QPayers.RecordCount = 0 then
    begin
      ShowMessageWarning('There is no clients to register');
      Exit;
    end;
    //20201216 Igor >>>
    //20220303 Igor >>>
    if cbSendEmail.Checked then
    begin
      if MessageDlg('Program will register and sent invitation emails to all your clients from the list '+
                    'to introduce our Virtual Tax Office.'+ Chr(13)+'Are you sure ?',
              mtInformation, [mbYes, mbNo], 0) <> mrYes then Exit;
    end
    else
    begin
      if MessageDlg('"Send Email" is not ticked. It is not an error. It means that the registration Email(s) will not be send to client(s) listed. Proceed with the Registration?', //20220304 Igor
              mtInformation, [mbYes, mbNo], 0) <> mrYes then Exit;
    end;
    //20220303 Igor <<<
    //20201216 Igor <<<
    QPayers.First;
    FThread := TMassRegisterThread.Create(Self);
    ThreadStarted;
  end;

  {FRecNo := QPayers.RecNo;
  QPayers.DisableControls;
  FParams := TParamList.Create;
  try
    QPayers.First;
    while not QPayers.Eof do
    begin
      if not QPayers.FieldByName('REGISTERED').AsBoolean then
      begin
        FParams.AddParam('action', 'REGISTER_PAYER');
        FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
        FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
        FParams.AddParam('MassRegistration', 'true');
        FParams.AddParam('FirstName', QPayers.FieldByName('FIRST_NAME').AsString);
        FParams.AddParam('LastName', QPayers.FieldByName('LAST_NAME').AsString);
        FParams.AddParam('Email', QPayers.FieldByName('EMAIL').AsString);
        FParams.AddParam('PreparerName', OptRec.Prp_Name); //20201216 Igor
        try
          Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtPost, true);
        except on E: Exception do
          begin
            QPayers.Edit;
            QPayers.FieldByName('RESULT').Value := E.Message;
            QPayers.FieldByName('REGISTERED').Value := false;
            QPayers.FieldByName('ERROR').Value := true;
            QPayers.Next;
            QPayers.Post;
            continue;
          end;
        end;
        if Assigned(Res) then
        begin
          QPayers.Edit;
          if SameText( GetJSONValue(Res, 'success'), 'true') then
          begin
            QPayers.FieldByName('RESULT').Value := GetJSONValue(Res, 'cyberid');
            QPayers.FieldByName('REGISTERED').Value := true;
            QPayers.FieldByName('ERROR').Value := false;
          end
          else
          begin
            if SameText(GetJSONValue(Res, 'type'), 'already_registered') then
            begin
              QPayers.FieldByName('RESULT').Value := 'Already registered';
              QPayers.FieldByName('REGISTERED').Value := true;
              QPayers.FieldByName('ERROR').Value := false;
            end
            else
            begin
              QPayers.FieldByName('RESULT').Value := GetJSONValue(Res, 'error_message');
              QPayers.FieldByName('REGISTERED').Value := false;
              QPayers.FieldByName('ERROR').Value := true;
            end;
          end;
          QPayers.Post;
        end;
      end;
      QPayers.Next;
    end;
  finally
    QPayers.RecNo := FRecNo;
    QPayers.EnableControls;
    FParams.Free;
  end;}
end;

procedure TMassRegistrationT1_2026.btnResetToDefaultClick(Sender: TObject); //20210201 Igor
begin
  if RunEditHTML(FDefaultTemplate, SaveTemplate) then
  begin
    InitMode;
    if rbOwn.Enabled then
      rbOwn.Checked := true;
    RefreshPreview;
  end;
end;

procedure TMassRegistrationT1_2026.btnSendTestEmailClick(Sender: TObject); //20210127 Igor  //20210129 Igor
//var FParams: TParamList;
//    Res: TJSONObject;
begin
//  if String(meTemplate.Text).IsEmpty then
//  begin
//    ShowMessageWarning('Template is empty');
//    Exit;
//  end;
//  if not CheckTemplate(meTemplate.Text) then Exit;
//  FParams := TParamList.Create;
//  try
//    FParams.AddParam('action','SEND_TEST_MASS_REGISTRATION_TEMPLATE');
//    FParams.AddParam('MassRegistrationTemplate', meTemplate.Text);
//    FParams.AddParam('PreparerName', OptRec.Prp_Name);
//    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
//    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtPost);
//    if Assigned(Res) then
//    begin
//      if SameText(GetJSONValue(Res, 'success'), 'true') then
//        ShowMessageInfo('Test email was successfully sent to '+ GetJSONValue(Res, 'Email'))
//      else
//        ShowMessageError(GetJSONValue(Res, 'error_message'));
//    end;
//  finally
//    FParams.Free;
//  end;
end;

procedure TMassRegistrationT1_2026.cbSendEmailClick(Sender: TObject); //20220303 Igor
begin
  lbTemplateCaption.Enabled := cbSendEmail.Checked;
  rbDefault.Enabled := cbSendEmail.Checked;
  rbOwn.Enabled := cbSendEmail.Checked;
  btnCreateOwn.Enabled := cbSendEmail.Checked;
  btnResetToDefault.Enabled := cbSendEmail.Checked;
  if cbSendEmail.Checked then
  begin
    btnRegister.Caption := 'Register and Email to clients';
    btnRegister.Width := 190;
  end
  else
  begin
    btnRegister.Caption := 'Register clients';
    btnRegister.Width := 120;
  end;
  btnRegister.Left := btnCancel.Left - 10 - btnRegister.Width;
end;

function TMassRegistrationT1_2026.CheckTemplate(ATemplate: string): boolean; //20210127 Igor
begin
  Result := false;
  if Pos('%VIRTUAL_ID%', ATemplate) = 0 then
  begin
    ShowMessageWarning('%VIRTUAL_ID% part is not found in template');
    Exit;
  end;
  if Pos('%TEMP_PASSWORD%', ATemplate) = 0 then
  begin
    ShowMessageWarning('%TEMP_PASSWORD% part is not found in template');
    Exit;
  end;
  {if Pos('%ACTIVATION_LINK%', ATemplate) = 0 then
  begin
    ShowMessageWarning('%ACTIVATION_LINK% part is not found in template');
    Exit;
  end;}
  Result := true;
end;

procedure TMassRegistrationT1_2026.FormClose(Sender: TObject;  //20210129 Igor
  var Action: TCloseAction);
begin
  if rbOwn.Checked and not FOwnTemplate.IsEmpty then
    VirtualTaxOfficeInfo.SaveOption('MassRegistrationMode', 'O')
  else
    VirtualTaxOfficeInfo.SaveOption('MassRegistrationMode', 'D');
end;

procedure TMassRegistrationT1_2026.FormCreate(Sender: TObject);  //20210129 Igor
begin
  FSingleMode := false;
  FSkipLinkIntercept := false; //20210201 Igor
end;

procedure TMassRegistrationT1_2026.FormShow(Sender: TObject); //20210129 Igor
begin
  if FSingleMode then
    pnlCaption.Caption := 'Single Registration of your client to your Virtual Tax Office'; //20210201 Igor //20210426 Igor
  // LoadPayersFromClientsDb; //20210201 Igor
  InitOffice;
  InitDefaultTemplate; //20210127 Igor
  InitOwnTemplate;
  InitMode;
  if SameText(VirtualTaxOfficeInfo.ReadOption('MassRegistrationMode'), 'O') and not FOwnTemplate.IsEmpty then
    rbOwn.Checked := true;
  RefreshPreview;
  cbSendEmailClick(nil); //20220303 Igor
end;

function TMassRegistrationT1_2026.GetRecord(var AFirstName, ALastName, //20201222 Igor
  AEmail: string): boolean;
begin
  Result := false;
  if QPayers.Eof then Exit;
  AFirstName := QPayers.FieldByName('FIRST_NAME').AsString;
  ALastName := QPayers.FieldByName('LAST_NAME').AsString;
  AEmail := QPayers.FieldByName('EMAIL').AsString;
  Result := true;
end;

procedure TMassRegistrationT1_2026.grPayersDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if (gdFocused in State) then
  begin
    grPayers.Canvas.Brush.Color := clHighlight;
    grPayers.Canvas.Font.Color := clHighlightText;
  end
  else if QPayers.FieldByName('ERROR').AsBoolean then
    grPayers.Canvas.Brush.Color := Rgb(255, 128, 128)
  else if QPayers.FieldByName('REGISTERED').AsBoolean then
  begin
    if SameText(QPayers.FieldByName('RESULT').AsString, ALREADY_REGISTERED) then //20210317 Igor
      grPayers.Canvas.Brush.Color := Rgb(255, 198, 0)
    else
      grPayers.Canvas.Brush.Color := Rgb(198, 255, 198);
  end;
  grPayers.DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TMassRegistrationT1_2026.InitOffice;  //20210129 Igor
var FParams: TParamList;
    Res: TJSONObject;
begin
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'LOAD_PROFILE');
    FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet, true);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        FOfficeCyberId := GetJSONValue(Res, 'CyberId');
        FOfficeName := GetJSONValue(Res, 'BusinessName');
        FOfficePhone := GetJSONValue(Res, 'Area') + ' ' + GetJSONValue(Res, 'Phone');
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

procedure TMassRegistrationT1_2026.InitOwnTemplate; //20210129 Igor
var FParams: TParamList;
    Res: TJSONObject;
begin
  FParams := TParamList.Create;
  try
    FParams.AddParam('action','GET_MASS_REGISTRATION_TEMPLATE');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        FOwnTemplate := GetJSONValue(Res, 'MassRegistrationTemplate', true);
        FTemplateChanged := false;
      end
      else
        ShowMessageError(GetJSONValue(Res, 'error_message'));
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

procedure TMassRegistrationT1_2026.InitDefaultTemplate; //20210129 Igor
var FParams: TParamList;
    Res: TJSONObject;
begin
  FParams := TParamList.Create;
  try
    FParams.AddParam('action','GET_MASS_REGISTRATION_DEFAULT_TEMPLATE');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        FDefaultTemplate := GetJSONValue(Res, 'MassRegistrationTemplate', true);
        FTemplateChanged := false;
      end
      else
        ShowMessageError(GetJSONValue(Res, 'error_message'));
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

procedure TMassRegistrationT1_2026.InitMode;  //20210129 Igor
begin
  rbOwn.Enabled := not FOwnTemplate.IsEmpty and cbSendEmail.Checked; //20220303 Igor
  if rbOwn.Enabled then
    btnCreateOwn.Caption := 'Edit my own wording'
  else
    btnCreateOwn.Caption := 'Create my own wording';
  btnResetToDefault.Visible := rbOwn.Enabled; //20210201 Igor
end;

procedure TMassRegistrationT1_2026.LoadPayersFromClientsDb;
var
  Conn: TADConnection;
  Q: TADQuery;
  cEmail: string;

  procedure AddEmail(AEmail, AFirstName, ALastName: string);  //20210129 Igor
  begin
    if AEmail.IsEmpty then Exit;
    if QPayers.Locate('EMAIL', AEmail, [loCaseInsensitive]) then Exit;
    QPayers.Append;
    QPayers.FieldByName('FIRST_NAME').Value := AFirstName;
    QPayers.FieldByName('LAST_NAME').Value := ALastName;
    QPayers.FieldByName('EMAIL').Value := AEmail;
    QPayers.FieldByName('REGISTERED').Value := false;
    QPayers.FieldByName('ERROR').Value := false;
    QPayers.Post;
  end;

begin
   //20210129 Igor >>>	
  if FSingleMode then
  begin
    QPayers.Close;
    QPayers.Open;
    AddEmail(FEmail, FFirstName, FLastName);
  end
  else if TFile.Exists(TPath.Combine(OptRec.Dir_Cur, AppT1_2026.ClientsDBLite)) then
  //20210129 Igor <<<
  begin
    QPayers.Close;
    QPayers.Open;
    Conn := TADConnection.Create(Nil);
    Q := TADQuery.Create(Nil);
    try
      Conn.LoginPrompt := false;
      Conn.DriverName := 'SQLite';
      Conn.Params.Values['Database'] :=
        TPath.Combine(OptRec.Dir_Cur, AppT1_2026.ClientsDBLite);
      Conn.Params.Values['Password'] :=
        Pswd(GC_SQLLitePasswordVersion, false);
      try
        try
          Conn.Connected := True;
        except
          Conn.Params.Values['Password'] := '';
          Conn.Connected := True;
        end;
        Q.Connection := Conn;
        Q.SQL.Text := 'SELECT * FROM Clients';
        Q.Open;
        while not Q.Eof do
        begin
           //20210129 Igor >>>
          AddEmail(Q.FieldByName('EMAIL').AsString, Q.FieldByName('FIRST_NAME').Value, Q.FieldByName('LAST_NAME').Value);
          AddEmail(Q.FieldByName('EMAIL2').AsString, Q.FieldByName('FIRST_NAME').Value, Q.FieldByName('LAST_NAME').Value);
          //20210129 Igor <<<
          Q.Next;
        end;
      except
        ON E: Exception DO
        begin
          Errors.Log(E.Message);
        end;
      end;
    finally
      QPayers.First; //20201222 Igor
      Q.Free;
      Conn.Free;
    end;
  end;
end;

procedure TMassRegistrationT1_2026.QPayersAfterScroll(DataSet: TDataSet); //20210129 Igor
begin
  pnlPreview.Enabled := false;

  RefreshPreview;

  pnlPreview.Enabled := true;
end;

procedure TMassRegistrationT1_2026.rbDefaultClick(Sender: TObject); //20210129 Igor
begin
  RefreshPreview;
end;

procedure TMassRegistrationT1_2026.RefreshPreview; //20210129 Igor
var FHTML, FPayerName, FPayerCyberId, FPassword: string;
    Doc: Variant;
begin
  if rbDefault.Checked then
    FHTML := FDefaultTemplate
  else
    FHTML := FOwnTemplate;

  FPayerName := '';
  FPayerCyberId := 'VC******';
  FPassword := 'Tmp123456';
  if QPayers.RecordCount > 0 then
    FPayerName := QPayers.FieldByName('FIRST_NAME').AsString + ' ' + QPayers.FieldByName('LAST_NAME').AsString;
  FHTML := FHTML.Replace('%DATE%', formatdatetime('yyyy-mm-dd', Date)); //20210201 Igor
  FHTML := FHTML.Replace('%PAYER_NAME%', FPayerName);
  FHTML := FHTML.Replace('%VIRTUAL_ID%', FPayerCyberId);
  FHTML := FHTML.Replace('%TEMP_PASSWORD%', FPassword);
  FHTML := FHTML.Replace('%OFFICE_NAME%', FOfficeName);
  FHTML := FHTML.Replace('%PREPARER_NAME%', OptRec.Prp_Name);
  FHTML := FHTML.Replace('%OFFICE_PHONE%', FOfficePhone);
  FHTML := FHTML.Replace('%OFFICE_VIRTUAL_ID%', FOfficeCyberId);
  FHTML := FHTML.Replace('%ACTIVATION_LINK%', '');

  //20210201 Igor >>>
  FSkipLinkIntercept := true;
  try
    if not Assigned(wbPreview.Document) then
      wbPreview.Navigate('about:blank');

    Doc := wbPreview.Document;
    Doc.Clear;
    Doc.Write(FHTML);
    Doc.Close;
    while wbPreview.ReadyState <> READYSTATE_COMPLETE do
      Application.ProcessMessages;
  finally
    FSkipLinkIntercept := false;
  end;
  //20210201 Igor <<<
end;

procedure TMassRegistrationT1_2026.Resendregistrationemail1Click( //20210205 Igor
  Sender: TObject);
var FParams: TParamList;
    Res: TJSONObject;
    FMode: string;
    cResult: string;
    bRegistered, bError: boolean;
    //20220317 Igor >>>
    cTaxPayerCyberId: string;
    bIsActivated: boolean;
    //20220317 Igor <<<
begin
  if QPayers.RecordCount = 0 then
  begin
    ShowMessage('There is no payers in the list');
    Exit;
  end;
  //20220317 Igor >>>
  bIsActivated := false;
  cTaxPayerCyberId := VirtualTaxOfficeInfo.GetTaxPayerCyberIdByEmail(QPayers.FieldByName('EMAIL').AsString, true);
  if not cTaxPayerCyberId.IsEmpty then
    bIsActivated := VirtualTaxOfficeInfo.IsTaxPayerActivated(cTaxPayerCyberId);
  if bIsActivated then
  begin
    if MessageDlg('Virtual Client is already activated. If you continue, program will reset existing Virtual Client password, generate new and send it to Virtual Client.'+
                  Chr(13)+'Are you sure ?',
              mtInformation, [mbYes, mbNo], 0) <> mrYes then Exit;
    FParams := TParamList.Create;
    try
      FParams.Clear;
      FParams.AddParam('action', 'FORCE_RESET_PASSWORD');
      FParams.Add(ADMIN_PARAM);
      FParams.AddParam('CyberId', cTaxPayerCyberId);
      FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
      FParams.AddParam('SendEmail', 'true');
      try
        Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtPost, true);
        if Assigned(Res) then
        begin
          if SameText( GetJSONValue(Res, 'success'), 'true') then
            ShowMessageInfo('Email was successfully sent')
          else
          begin
            cResult := GetJSONValue(Res, 'error_message');
            ShowMessageWarning(cResult);
          end;
        end;
      except on E: Exception do
        begin
          cResult := E.Message;
          bRegistered := false;
          bError := true;
        end;
      end;
    finally
      FParams.Free;
      if Assigned(Res) then
        FreeAndNil(Res);
    end;
  end
  else
  begin
    if MessageDlg('Program will re-register '+ QPayers.FieldByName('LAST_NAME').AsString + ' ' + QPayers.FieldByName('FIRST_NAME').AsString +
                  ' and sent invitation email to '+ QPayers.FieldByName('EMAIL').AsString +
                  ' to introduce our Virtual Tax Office.'+ Chr(13)+'Are you sure ?',
              mtInformation, [mbYes, mbNo], 0) <> mrYes then Exit;
    if rbOwn.Checked then
      FMode := 'O'
    else
      FMode := 'D';
    FParams := TParamList.Create;
    try
      FParams.Clear;
      FParams.AddParam('action', 'REGISTER_PAYER');
      FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
      FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
      FParams.AddParam('MassRegistration', 'true');
      FParams.AddParam('ReRegister', 'true');
      FParams.AddParam('FirstName', QPayers.FieldByName('FIRST_NAME').AsString);
      FParams.AddParam('LastName', QPayers.FieldByName('LAST_NAME').AsString);
      FParams.AddParam('Email', QPayers.FieldByName('EMAIL').AsString);
      FParams.AddParam('PreparerName', OptRec.Prp_Name);
      FParams.AddParam('TemplateMode', FMode);
      FParams.AddParam('SendEmail', cbSendEmail.Checked); //20220303 Igor
      try
        Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtPost, true);
        if Assigned(Res) then
        begin
          if SameText( GetJSONValue(Res, 'success'), 'true') then
          begin
            cResult := GetJSONValue(Res, 'cyberid');
            bRegistered := true;
            bError := false;
          end
          else
          begin
            cResult := GetJSONValue(Res, 'error_message');
            bRegistered := false;
            bError := true;
            ShowMessageWarning(cResult);
          end;
          QPayers.Edit;
          QPayers.FieldByName('RESULT').Value := cResult;
          QPayers.FieldByName('REGISTERED').Value := bRegistered;
          QPayers.FieldByName('ERROR').Value := bError;
          QPayers.Post;
        end;
      except on E: Exception do
        begin
          cResult := E.Message;
          bRegistered := false;
          bError := true;
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
  //20220317 Igor <<<
end;

procedure TMassRegistrationT1_2026.ThreadFinished; //20201222 Igor //20210129 Igor
begin
  pnlProgress.Visible := false;
  btnCancel.Visible := true;
  //btnRegister.Width := btnCancel.Width;
  cbSendEmailClick(nil); //20220303 Igor
  btnRegister.Enabled := true;
  FThread := nil;
  ThreadTimer.Enabled := false;
  grPayers.Enabled := true;
  grPayers.Repaint;
  pnlTemplateHeader.Enabled := true;
  pnlPreview.Enabled := true;
end;

procedure TMassRegistrationT1_2026.ThreadStarted; //20201222 Igor //20210129 Igor
begin
  FStartTime := Now;
  ThreadTimer.Enabled := true;
  ThreadTimerTimer(ThreadTimer);
  pbProgress.Position := 0;
  pbProgress.Max := QPayers.RecordCount;
  FProcessedCount := 0;
  pnlProgress.Visible := true;
  btnCancel.Visible := false;
  //btnRegister.Width := btnCancel.Left + btnCancel.Width - btnRegister.Left;
  btnRegister.Caption := 'Cancel registration';
  grPayers.Enabled := false;
  grPayers.Repaint;
  pnlTemplateHeader.Enabled := false;
  pnlPreview.Enabled := false;
  lbProgress.Caption := 'Processed 0 of ' + IntToStr(QPayers.RecordCount) + ' records.';
end;

procedure TMassRegistrationT1_2026.ThreadTimerTimer(Sender: TObject); //20201222 Igor
var nElapsedSeconds, nRemainingSeconds: integer;
    ElapsedTime, RemainingTime: TDateTime;
    cCaption: string;
begin
  nElapsedSeconds := SecondsBetween(FStartTime, Now);
  if FProcessedCount = 0 then
    nRemainingSeconds := 0
  else
    nRemainingSeconds := Trunc(nElapsedSeconds / FProcessedCount * (QPayers.RecordCount - FProcessedCount));
  ElapsedTime := 0;
  ElapsedTime := IncSecond(ElapsedTime, nElapsedSeconds);
  RemainingTime := 0;
  RemainingTime := IncSecond(RemainingTime, nRemainingSeconds);
  cCaption := 'Elapsed Time: '+ TimeToStr(ElapsedTime) + '. Remaining Time: ' + TimeToStr(RemainingTime);
  if not SameText(lbTime.Caption, cCaption) then
    lbTime.Caption := cCaption;
end;

procedure TMassRegistrationT1_2026.wbPreviewBeforeNavigate2(ASender: TObject; //20210201 Igor
  const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  if FSkipLinkIntercept then Exit;
  Cancel := true;
  ConnectToWeb(URL);
end;

procedure TMassRegistrationT1_2026.wbPreviewCommandStateChange(ASender: TObject; //20210129 Igor
  Command: Integer; Enable: WordBool);
var Doc: IHTMLDocument2;
    Sel: IHTMLSelectionObject;
    C: TControl;
begin
  if not Assigned(ASender) or not (ASender is TWebBrowser) then
    Exit;
  if TOleEnum(Command) <> CSC_UPDATECOMMANDS then
    Exit;
  Doc := wbPreview.Document as IHTMLDocument2;
  if not Assigned(Doc) then
    Exit;
  Sel := Doc.Selection as IHTMLSelectionObject;
  C := FindVCLWindow(Mouse.CursorPos);
  if Assigned(Sel) and ((Sel.type_ = 'Text') or (C = ASender) or (C = TControl(ASender).Parent)) then
    ActiveControl := wbPreview;
end;

procedure TMassRegistrationT1_2026.SaveRecordAndNext(AResult: string; //20201222 Igor
  ARegistered, AError: boolean);
begin
  QPayers.Edit;
  QPayers.FieldByName('RESULT').Value := AResult;
  QPayers.FieldByName('REGISTERED').Value := ARegistered;
  QPayers.FieldByName('ERROR').Value := AError;
  QPayers.Post;
  QPayers.Next;
  inc(FProcessedCount);
  pbProgress.Position := FProcessedCount;
  lbProgress.Caption := 'Processed '+ IntToStr(FProcessedCount) + ' of ' + IntToStr(QPayers.RecordCount) + ' records.';
  ThreadTimerTimer(ThreadTimer);
end;

function TMassRegistrationT1_2026.SaveTemplate(ATemplate: string): boolean; //20210129 Igor
var FParams: TParamList;
    Res: TJSONObject;
begin
  Result := false;
  if not CheckTemplate(ATemplate) then Exit;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action','SAVE_MASS_REGISTRATION_TEMPLATE');
    FParams.AddParam('MassRegistrationTemplate', ATemplate);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtPost);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        ShowMessageInfo('Template was successfully saved');
        FOwnTemplate := ATemplate;
        Result := true;
      end
      else
        ShowMessageError(GetJSONValue(Res, 'error_message'));
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

{ TMassRegisterThread } //20201222 Igor

constructor TMassRegisterThread.Create(AForm: TMassRegistrationT1_2026);
begin
  FForm := AForm;
  inherited Create(false);
end;

procedure TMassRegisterThread.Execute;
var cFirstName, cLastName, cEmail, cResult: string;
    bResult, bRegistered, bError: boolean;
    FParams: TParamList;
    Res: TJSONObject;
    FMode: string; //20210129 Igor
    //20210317 Igor >>>
    FTotalCount: integer;
    FSuccessCount: integer;
    FFailedCount: integer;
    //20210317 Igor <<<
    FSendEmail: string; //20220303 Igor
begin
  inherited;
  //20210317 Igor >>>
  FTotalCount := 0;
  FSuccessCount := 0;
  FFailedCount:= 0;
  //20210317 Igor <<<
  try
    //20210129 Igor >>>
    FMode := 'D';
    //20220303 Igor >>>
    FSendEmail := 'false';
    Synchronize(nil,
          procedure
          begin
            if FForm.rbOwn.Checked then
              FMode := 'O';
            if FForm.cbSendEmail.Checked then
              FSendEmail := 'true';
          end);
    //20220303 Igor <<<
    //20210129 Igor <<<
    FParams := TParamList.Create;
    try
      while not Terminated do
      begin
        cFirstName := '';
        cLastName := '';
        cEmail := '';
        cResult := '';
        bResult := false;
        bRegistered := false;
        bError := false;

        Synchronize(nil,
          procedure
          begin
            bResult := FForm.GetRecord(cFirstName, cLastName, cEmail);
          end);
        if not bResult then
        begin
          Synchronize(nil,
            procedure
            //20210317 Igor >>>
            var cMsg: string;
            begin
              FForm.ThreadTimer.Enabled := false;
              cMsg := 'Registrations: '+ IntToStr(FTotalCount) + sLineBreak + sLineBreak + //20220303 Igor
                      'Registrations successfully completed: '+ IntToStr(FSuccessCount) + sLineBreak;
              if FFailedCount = 0 then
                cMsg := cMsg + 'Registrations failed: 0'
              else
                cMsg := cMsg + 'Registrations failed: '+ IntToStr(FFailedCount) + ' (see reason on the Result column of the listing)';
              if FFailedCount = 0 then
                ShowMessageInfo(cMsg)
              else
                ShowMessageWarning(cMsg);
            //20210317 Igor <<<
            end);
          Terminate;
        end
        else
        begin
          FParams.Clear;
          FParams.AddParam('action', 'REGISTER_PAYER');
          FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
          FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
          FParams.AddParam('MassRegistration', 'true');
          FParams.AddParam('FirstName', cFirstName);
          FParams.AddParam('LastName', cLastName);
          FParams.AddParam('Email', cEmail);
          FParams.AddParam('PreparerName', OptRec.Prp_Name);
          FParams.AddParam('TemplateMode', FMode); //20210129 Igor
          FParams.AddParam('SendEmail', FSendEmail); //20220303 Igor
          try
            Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtPost, true);
            //20210218 Igor >>>
            try
              if Assigned(Res) then
              begin
                if SameText( GetJSONValue(Res, 'success'), 'true') then
                begin
                  cResult := GetJSONValue(Res, 'cyberid');
                  bRegistered := true;
                  bError := false;
                end
                else
                begin
                  if SameText(GetJSONValue(Res, 'type'), 'already_registered') then
                  begin
                    cResult := ALREADY_REGISTERED; //20210317 Igor
                    bRegistered := true;
                    bError := false;
                  end
                  else
                  begin
                    cResult := GetJSONValue(Res, 'error_message');
                    bRegistered := false;
                    bError := true;
                  end;
                end;
              end;
            finally              
              if Assigned(Res) then
                FreeAndNil(Res);    
            end;
            //20210218 Igor <<<
          except on E: Exception do
            begin
              cResult := E.Message;
              bRegistered := false;
              bError := true;
            end;
          end;
          //20210317 Igor >>>
          inc(FTotalCount);
          if bError or SameText(cResult, ALREADY_REGISTERED) then
            inc(FFailedCount)
          else
            inc(FSuccessCount);
          //20210317 Igor <<<
          Synchronize(nil,
            procedure
            begin
              FForm.SaveRecordAndNext(cResult, bRegistered, bError);
            end);
        end;
      end;
      Synchronize(nil,
        procedure
        begin
          FForm.ThreadFinished;
        end);
    finally
      FParams.Free;
    end;
  except on E: Exception do
    begin
      Synchronize(nil,
        procedure
        begin
          FForm.ThreadTimer.Enabled := false;
          ShowMessageError(E.Message);
          FForm.ThreadFinished;
        end);
    end;
  end;
end;

end.
