unit vtVirtualTaxOffice;

interface

uses
  Classes, Controls, IdHTTP, IdSSLOpenSSL, IdSSLOpenSSLHeaders, Data.DBXJSON, Forms,
  SysUtils, IniFiles, System.IOUtils, Dialogs, HTTPApp, IdCookieManager, Vcl.StdCtrls,
  Windows, Graphics, MAPI, vtMulti, //20201222 Igor //20210118 Igor
  uEncrypt, //20210426 Igor
  ExtCtrls, PngImage, StrUtils, System.ZIP; //20210223 Igor //20210304 Igor

const
  //VirtualTaxOfficeUrl = 'http://192.168.1.147/VirtualTaxOffice/api.php';
  //VirtualTaxOfficeUrl = 'http://192.168.43.120/VirtualTaxOffice/api.php';
  VirtualTaxOfficeUrl = 'https://www.virtualofficetower.com/api.php'; //20201230 Igor

  VirtualTaxOfficeShowUrl = 'https://www.virtualofficetower.com'; //20201221 Igor //20210203 Igor

  ADMIN_PARAM = 'Microsophic=Igor'; //20210204 Igor
  CLIENT_DOCS_DIR = 'C:\VT\T1-2023\ClientDocs'; //20210205 Igor - this directory will be created automatically at startup for vtClient, vtCourier, vtSignPdf
  VTO_CRYPT_KEY = 'jZNC2wn9P2zv9ccz'; //20210426 Igor

type
  TVirtualTaxOfficeAccountType = (vtoNone, vtoOffice, vtoPayer);
  TRequestType = (rtGet, rtPost, rtFiles);//20201230 Igor

type TParamList = class(TStringList) //20201230 Igor
  public
    //20220317 Igor >>>
    procedure AddParam(AName, AValue: string); overload;
    procedure AddParam(AName: string; AValue: boolean); overload;
    //20220317 Igor <<<
    function Params: string;
end;

type TTaxOffice = record
  CyberId: string;
  Name: string;
  Email: string;
  Contact: string;
  //20210203 Igor >>>
  TeamviewerID: string;
  UltraviewerID: string;
  //20210203 Igor <<<
  Phone: string; //20210204 Igor
end;

//20210203 Igor >>>
type TTaxPayer = record
  CyberId: string;
  LastName: string;
  FirstName: string;
  Email: string;
  TeamviewerID: string;
  UltraviewerID: string;
  Phone: string; //20210204 Igors
end;
//20210203 Igor <<<

//20210303 Igor >>>
type TPatternRecord = record
  Name: string;
  Url: string;
  FileName: string;
  Bitmap: TBitmap;
  Width: integer;
  Height: integer;
end;
//20210303 Igor <<<

type
    TVirtualTaxOfficeInfo = class
    private
      FIniPath: string;
      FCyberId: string;
      FAccountType: TVirtualTaxOfficeAccountType;
      FCurrentName: string; //20210409 Igor

      FCookieManager: TIdCookieManager;
      //20210303 Igor >>>
      FPatterns: TArray<TPatternRecord>;
      FPatternsList: TImageList;
      //20210303 Igor <<<
      FCustPatColList: TStringList; //20210330 Igor
      procedure SetCyberId(const Value: string);
      //20210426 Igor >>>
      function EncryptValue(AValue: string): string;
      function DecryptValue(AValue: string): string;
      //20210426 Igor <<<
    public
      EncryptPassword: string;
      CyberIdPassword: string;
      SessionId: string;
      TaxOffice: TTaxOffice;
      Email: string; //20210202 Igor
      BaseUrl: string; //20210331 Igor

      constructor Create;
      destructor Destroy; override;
      //20210426 Igor >>>
      procedure SaveOption(AOptionName, AValue: string; AEncrypt: boolean = false);
      function ReadOption(AOptionName: string; ADecrypt: boolean = false): string;
      //20210426 Igor <<<
      function ReadClientDocs: string; //20210205 Igor

      function RequestToVirtualTaxOffice(AParams: TParamList; AType: TRequestType = rtPost; ASilent: boolean = false; AFiles: TParamList = nil): TJSONObject; //20201230 Igor

      function GetTaxPayerCyberIdByEmail(AEmail: string; ASilent: boolean = false): string;
      function GetTaxPayerInfo(ATaxPayerCyberId: string): TTaxPayer; //20210203 Igor
      function GetEncrPsw(ATaxPayerCyberId: string; var APsw: string; var AId: integer; ACreateNew: boolean; ASilent: boolean = false): boolean;
      procedure IncFileEncrPsw(AID: integer; ASilent: boolean = true);
      procedure DecFileEncrPsw(AID: integer; ASilent: boolean = true);
      procedure RefreshTaxOfficeInfo;
      //20201221 Igor >>>
      function CheckTaxOfficeStatus(ATaxOfficeCyberId: string): boolean;
      function CheckTaxPayerStatus(ATaxPayerCyberId: string): boolean; //20210201 Igor
      function IsTaxPayerActivated(ATaxPayerCyberId: string): boolean; //20220317 Igor
      function GetAccountType(ACyberId: string): TVirtualTaxOfficeAccountType;
      function AllowedEncryption: boolean;
      //20201221 Igor

      //function SendMAPIMail(const Subject, Body, FileNames,SenderName, SenderEMail,RecipientName, RecipientEMail: AnsiString): Integer; //20201221 Igor //20220202 Igor
      function GetFileContent(AUrl: string): string; //20210118 Igor

      function GetCurrentEmail: string; //20210211 Igor
      function GetCurrentName: string; //20210318 Igor
      function GetNameForCyberId(ACyberId: string): string; //20210322 Igor

      //20210218 Igor >>>
      procedure ClearPatterns;
      procedure LoadPatterns(AForceReload: boolean = false); //20210304 Igor
      function FindPatternByFileName(AFileName: string): TBitmap;
      //20210218 Igor <<<

      function GetSignature(ATaxPayerCyberId: string; AFolder: string): string; //20210331 Igor
      function SendEmail(AEmail, ASubject, ABody: String; AAttachments: String = ''): boolean; //20220202 Igor
      procedure RequestSignature(AEmail: string); //20210407 Igor

      function GetDoNotAnswerMessage: string; //20220202 Igor

      //20210430 Igor >>>
      function GetSessionToken: string;
      procedure ShowVirtualClientsAndAppointments;
      procedure ShowServiceRequests;
      //20210430 Igor <<<

      property CyberId: string read FCyberId write SetCyberId;
      property AccountType: TVirtualTaxOfficeAccountType read FAccountType write FAccountType;
      //20210303 Igor >>>
      property Patterns: TArray<TPatternRecord> read FPatterns;
      property PatternsList: TImageList read FPatternsList;
      //20210303 Igor <<<
      property CustomPatColors: TStringList read FCustPatColList; //20210330 Igor
  end;

var VirtualTaxOfficeInfo: TVirtualTaxOfficeInfo;

function GetJSONValue(AObject: TJSONObject; AName: string; ARaw: boolean = false): string; //20210127 Igor
function GetJSONIntValue(AObject: TJSONObject; AName: string; ADefaultValue: integer = 0): integer; //20201221 Igor
function GetCheckValue(ACB: TCheckBox): string;
function ReadonlyColor: TColor;

implementation

uses vtCommon, vtDialogs, IdMultipartFormData, vtEditHTML; //20201221 Igor //20201230 Igor //20220202 Igor

function ReadonlyColor: TColor;
begin
  Result := Rgb(245, 245, 245);
end;

function GetCheckValue(ACB: TCheckBox): string;
begin
  if ACB.Checked then
    Result := 'Y'
  else
    Result := 'N';
end;

function GetJSONValue(AObject: TJSONObject; AName: string; ARaw: boolean = false): string; //20210127 Igor
begin
  if not Assigned(AObject) then
    raise Exception.Create('JSON object is not assigned');
  if not Assigned(AObject.Get(AName)) then
    raise Exception.Create('Parameter '+ QuotedStr(AName) + ' is not found');
  if not Assigned(AObject.Get(AName).JSONValue) then
    raise Exception.Create('Parameter '+ QuotedStr(AName) + ' is not found');
  if ARaw then
    Result := AObject.Get(AName).JSONValue.Value
  else
    Result := HTTPDecode(AObject.Get(AName).JSONValue.Value);
end;

function GetJSONIntValue(AObject: TJSONObject; AName: string; ADefaultValue: integer = 0): integer; //20201221 Igor
begin
  Result := StrToIntDef(GetJSONValue(AObject, AName), 0);
end;

procedure TVirtualTaxOfficeInfo.RequestSignature(AEmail: string); //20210407 Igor //20210408 Igor
var FTaxPayerCyberId: string;
    FTaxPayerInfo: TTaxPayer;
    FBody, FRequestCode, FRequestUrl: string; //20220202 Igor
    FParams: TParamList;
    Res: TJSONObject;
begin
  if AEmail.IsEmpty then
  begin
    ShowMessageWarning('Please, enter VC email in Personal box on INFO form');
    Exit;
  end;

  FTaxPayerCyberId := GetTaxPayerCyberIdByEmail(AEmail);
  if FTaxPayerCyberId.IsEmpty then Exit;
  FTaxPayerInfo := GetTaxPayerInfo(FTaxPayerCyberId);

  FRequestCode := '';
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'REQUEST_SIGNATURE');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    FParams.AddParam('TaxPayerCyberId', FTaxPayerCyberId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtPost);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
        FRequestCode :=GetJSONValue(Res, 'RequestCode')
      else
        ShowMessageError(GetJSONValue(Res, 'error_message'));
    end;
  finally
    FParams.Free;
    if Assigned(Res) then
      FreeAndNil(Res);
  end;
  if FRequestCode = '' then Exit;
  //20210409 Igor >>>
  //20220202 Igor >>>
  FRequestUrl := 'https://www.virtualofficetower.com/send_signature.php?RequestCode='+ FRequestCode;
  FBody := '<html><body>';
  FBody := FBody + 'To: '+ FTaxPayerInfo.FirstName + ' ' + FTaxPayerInfo.LastName + '<br><br>'; //20210410 Igor
  FBody := FBody + 'In order to complete the signing process of your tax documents please provide us with the following:'+ '<br><br>';
  FBody := FBody + 'a. Your Electronic Signature to be used in the tax documents we have prepared. '+
                   'Then we will send you the signed documents for your confirmation and acceptance. '+
                   'This method is faster in the event we need to re-issue signed forms or re-file your tax return. '+
                   'To follow this method you need to open this link <a href="'+ FRequestUrl +'">'+ FRequestUrl +'</a> in a browser '+
                   'and click "Draw Signature" button to create signature and send it to our office (or upload existing signature if you have it)'+ '<br><br>';
  FBody := FBody + 'OR'+ '<br><br>';
  FBody := FBody + 'b. Request by return Email that you need the unsigned forms. '+
                    'Then we will Email your unsigned PDF forms, you sign them any way you can and send them back to us. '+
                    '(i.e, Print them and sign them).'+ '<br><br>';
  FBody := FBody + GetDoNotAnswerMessage + '<br><br>';

  FBody := FBody + 'Kind regards, '+ '<br>';
  FBody := FBody + GetCurrentName;
  FBody := FBody + '</body></html>';
  //20210409 Igor <<<
  if RunEditHTML(FBody) then
    if SendEmail(AEmail, 'Signature Request', FBody) then
      ShowMessageInfo('Request was successfully sent');
//  SendMapiMail('Signature Request',
//               FBody,
//               '',
//               '',
//               GetCurrentEmail,
//               '',
//               FTaxPayerInfo.Email);
  //20220202 Igor <<<
end;

function TVirtualTaxOfficeInfo.RequestToVirtualTaxOffice(AParams: TParamList; AType: TRequestType = rtPost; ASilent: boolean = false; AFiles: TParamList = nil): TJSONObject; //20201230 Igor
var
  HTTP: TIdHTTP;
  cResult, cErrorMessage, cParams: string;
  I: integer;
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  //20201230 Igor >>>
  MultiPartParams: TIdMultipartFormDataStream;
  MultiPartField: TIdFormDataField;
  //20201230 Igor <<<
begin
  Result := nil;
  HTTP := TIdHTTP.Create;
  HTTP.ConnectTimeout := HTTP_TimeOut * 5;
  HTTP.ReadTimeout := HTTP_TimeOut * 5;
  HTTP.AllowCookies := true;
  HTTP.Request.UserAgent := 'Mozilla/3.0';
  HTTP.CookieManager := FCookieManager;
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  //20201222 Igor >>>
  if not ASilent then
    Screen.Cursor := crHourGlass;
  //20201222 Igor <<<
  try
    IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];  //20210701 Igor
    HTTP.IOHandler := IdSSLIOHandlerSocket;
    try
      case AType of
        rtGet:
          cResult := HTTP.Get(VirtualTaxOfficeUrl + AParams.Params);
        rtPost:
          cResult := HTTP.Post(VirtualTaxOfficeUrl, AParams);
        //20201230 Igor >>>
        rtFiles:
          begin
            if not Assigned(AFiles) then
              raise Exception.Create('Files are not assigned');
            MultiPartParams := TIdMultipartFormDataStream.Create;
            try
              for I := 0 to AParams.Count - 1 do
              begin
                MultiPartField := MultiPartParams.AddFormField(AParams.Names[I], HTTPEncode(AParams.ValueFromIndex[I]));
                MultiPartField.ContentTransfer := '';
              end;
              for I := 0 to AFiles.Count - 1 do
                MultiPartParams.AddFile(AFiles.Names[I], AFiles.ValueFromIndex[I]);
              cResult := HTTP.Post(VirtualTaxOfficeUrl, MultiPartParams);
            finally
              MultiPartParams.Free;
            end;
          end
          //20201230 Igor <<<
        else Exit;
      end;
      Result := TJSONObject(TJSONObject.ParseJSONValue(cResult));
      if not Assigned(Result) then
        raise Exception.Create('Wrong JSON package');
    except on E: Exception do
      begin
        Screen.Cursor := crDefault;
        cErrorMessage := E.Message;
        if not cResult.IsEmpty then
          cErrorMessage := cErrorMessage + sLineBreak + sLineBreak + cResult;
        if ASilent then
          raise Exception.Create(cErrorMessage)
        else
          ShowMessageError(cErrorMessage); //20201221 Igor
      end;
    end;
  finally
    //20201222 Igor >>>
    if not ASilent then
      Screen.Cursor := crDefault;
    //20201222 Igor <<<
    HTTP.Free;
    IdSSLIOHandlerSocket.Free;
  end;
end;

{ TVirtualTaxOfficeInfo }

function TVirtualTaxOfficeInfo.AllowedEncryption: boolean; //20201222 Igor
var FParams: TParamList;
    Res: TJSONObject;
begin
  Result := false;
  if AccountType = vtoOffice then
    Result := true
  else if AccountType = vtoNone then
    Result := false
  else
  begin
    FParams := TParamList.Create;
    try
      FParams.AddParam('action', 'ENCRYPTION_ALLOWED');
      FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
      Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
      if Assigned(Res) then
      begin
        if SameText(GetJSONValue(Res, 'success'), 'true') then
          Result := SameText(GetJSONValue(Res, 'allowed'), 'true')
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
end;

function TVirtualTaxOfficeInfo.CheckTaxOfficeStatus( //20201221 Igor
  ATaxOfficeCyberId: string): boolean;
var FParams: TParamList;
    Res: TJSONObject;
    cMessage, cEmailMessage, cEmail, cSubject: string;
begin
  Result := false;
  if ATaxOfficeCyberId.IsEmpty then
  begin
    ShowMessage('Virtual Office Id is not specified');
    Exit;
  end;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'CHECK_OFFICE_STATUS');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    FParams.AddParam('CyberId', ATaxOfficeCyberId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        if SameText(GetJSONValue(Res, 'Status'), 'I') then
        begin
          cMessage := 'It appears that the VirtualOffice you have chosen is not currently active. Do you want to contact him by Email?';
          cEmailMessage := 'I tried to use your Virtual Office Id but your Virtual Office Id appears to be inactive. '+
                    'Please advice or check your records via '+ VirtualTaxOfficeShowUrl;
        end
        else if GetJSONIntValue(Res, 'ExpireDays') <= 0 then
        begin
          cMessage := 'It appears that the VirtualOffice you have chosen is expired. Do you want to contact him by Email?';
          cEmailMessage := 'I tried to use your Virtual Office Id but your Virtual Office Id appears to be expired. '+
                    'Please advice or check your records via '+ VirtualTaxOfficeShowUrl;
        end
        else
        begin
          Result := true;
          Exit;
        end;
        if MessageDlg(cMessage, mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit;
        cEmail := GetJSONValue(Res, 'Email');
        cEmailMessage := 'Good day, '+ GetJSONValue(Res, 'BusinessName') + #13#10#13#10 + cEmailMessage;
        //20220202 Igor >>>
        {SendMapiMail('Virtual Tax Office issue',
                     cEmailMessage,
                     '',
                     '',
                     GetCurrentEmail, //20210211 Igor
                     '',
                     cEmail);}
        cEmailMessage := '<html><body>' + ReplaceStr(cEmailMessage, #13#10, '<br>') + '</body></html>';
        if RunEditHTML(cEmailMessage) then
          if SendEmail(cEmail, 'Virtual Tax Office issue', cEmailMessage) then
            ShowMessageInfo('Request was successfully sent');
        //20220202 Igor <<<
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

function TVirtualTaxOfficeInfo.CheckTaxPayerStatus( //20210201 Igor
  ATaxPayerCyberId: string): boolean;
var FParams: TParamList;
    Res: TJSONObject;
    cMessage, cEmailMessage, cEmail, cSubject: string;
begin
  Result := false;
  if ATaxPayerCyberId.IsEmpty then
  begin
    ShowMessage('Virtual Office Id is not specified');
    Exit;
  end;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'CHECK_PAYER_STATUS');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    FParams.AddParam('CyberId', ATaxPayerCyberId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        if SameText(GetJSONValue(Res, 'Status'), 'I') then
          ShowMessageWarning('The recipient is not active and then Email will not be delivered. Please Activate your client first')
        else if SameText(GetJSONValue(Res, 'Activated'), 'N') then
          ShowMessageWarning('The recipient is not activated and then Email will not be delivered. Please Activate your client first')
        else
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

procedure TVirtualTaxOfficeInfo.ClearPatterns; //20210303 Igor
var I: integer;
begin
  for I := 0 to Length(FPatterns) - 1 do
    if Assigned(FPatterns[I].Bitmap) then
      FreeAndNil(FPatterns[I].Bitmap);
  SetLength(FPatterns, 0);
  FPatternsList.Clear;
end;

constructor TVirtualTaxOfficeInfo.Create;
begin
  BaseUrl := ReplaceStr(VirtualTaxOfficeUrl, 'api.php', ''); //20210331 Igor
  FAccountType := vtoNone;
  FIniPath := TPath.Combine(ExtractFilePath(Application.ExeName), 'VirtualTaxOffice.ini');
  FCookieManager := TIdCookieManager.Create(nil);
  FPatternsList := TImageList.Create(nil); //20210303 Igor
  FCustPatColList := TStringList.Create;   //20210330 Igor
end;

procedure TVirtualTaxOfficeInfo.DecFileEncrPsw(AID: integer; ASilent: boolean);
var FParams: TParamList;
    Res: TJSONObject;
begin
  if AID = 0 then
  begin
    if not ASilent then
      ShowMessage('Virtual Client Id is not defined'); //20210201 Igor
    Exit;
  end;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'DEC_FILE_ENCRPSW');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    FParams.AddParam('Id', IntToStr(AId));
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtPost, ASilent);
    if Assigned(Res) then
    begin
      if not SameText(GetJSONValue(Res, 'success'), 'true') then
        if not ASilent then
          ShowMessageError(GetJSONValue(Res, 'error_message')); //20201221 Igor
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

function TVirtualTaxOfficeInfo.DecryptValue(AValue: string): string; //20210426 Igor
begin
  Result := AValue;
  if not AValue.IsEmpty then
    Result := Decrypt(AValue, VTO_CRYPT_KEY);
end;

destructor TVirtualTaxOfficeInfo.Destroy;
begin
  if Assigned(FCookieManager) then
    FreeAndNil(FCookieManager);
  //20210303 Igor >>>
  ClearPatterns;
  if Assigned(FPatternsList) then
    FPatternsList.Free;
  //20210303 Igor <<<
  //20210330 Igor >>>
  if Assigned(FCustPatColList) then
  try
    FCustPatColList.Clear;
  finally
    FreeAndNil(FCustPatColList);
  end;
  //20210330 Igor <<<
  inherited;
end;

function TVirtualTaxOfficeInfo.EncryptValue(AValue: string): string; //20210426 Igor
begin
  Result := Encrypt(AValue, VTO_CRYPT_KEY);
end;

function TVirtualTaxOfficeInfo.FindPatternByFileName( //20210303 Igor
  AFileName: string): TBitmap;
var I: integer;
begin
  Result := nil;
  for I := 0 to Length(FPatterns) - 1 do
    if SameText(AFileName, FPatterns[I].FileName) then
    begin
      Result := FPatterns[I].Bitmap;
      break;
    end;
end;

function TVirtualTaxOfficeInfo.GetAccountType(ACyberId: string): TVirtualTaxOfficeAccountType; //20201222 Igor
begin
  if SameText(Copy(ACyberId, 1, 2), 'VO') then
    Result := vtoOffice
  else if SameText(Copy(ACyberId, 1, 2), 'VC') then
    Result := vtoPayer
  else
    Result := vtoNone;
end;

function TVirtualTaxOfficeInfo.GetCurrentEmail: string;
var FParams: TParamList;
    Res: TJSONObject;
begin
  Result := '';
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'LOAD_PROFILE');
    FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet, true);
    if Assigned(Res) then
      if SameText(GetJSONValue(Res, 'success'), 'true') then
        Result := GetJSONValue(Res, 'Email');
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

function TVirtualTaxOfficeInfo.GetCurrentName: string; //20210322 Igor //20210409 Igor
begin
  if FCurrentName.IsEmpty then
    FCurrentName := GetNameForCyberId(VirtualTaxOfficeInfo.CyberId);
  Result := FCurrentName;
end;

function TVirtualTaxOfficeInfo.GetDoNotAnswerMessage: string; //20220202 Igor
begin
  Result := 'Please do not reply to this email. If you want to reply, send your email to this address: '+ GetCurrentEmail; //20220202 Igor
end;

function TVirtualTaxOfficeInfo.GetEncrPsw(ATaxPayerCyberId: string;
  var APsw: string; var AId: integer; ACreateNew: boolean; ASilent: boolean = false): boolean;
var FParams: TParamList;
    Res: TJSONObject;
begin
  Result := false;
  if ATaxPayerCyberId.IsEmpty then
  begin
    if not ASilent then
      ShowMessage('Virtual Client Id is not defined'); //20210201 Igor
    Exit;
  end;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'GET_FILE_ENCRPSW');
    FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    FParams.AddParam('TaxPayerCyberId', ATaxPayerCyberId);
    if ACreateNew then
      FParams.AddParam('CreateNew', 'true')
    else
      FParams.AddParam('CreateNew', 'false');
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet, ASilent);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        Result := true;
        APsw := GetJSONValue(Res, 'EncryptPsw');
        AId := StrToInt(GetJSONValue(Res, 'Id'));
      end
      else if not ASilent then
        ShowMessageError(GetJSONValue(Res, 'error_message')); //20201221 Igor
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

function TVirtualTaxOfficeInfo.GetFileContent(AUrl: string): string; //20210118 Igor
var HTTP: TIdHTTP;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := '';
  if AUrl.IsEmpty then Exit;
  HTTP := TIdHTTP.Create(nil);
  IdOpenSSLSetLibPath(ExtractFilePath(Application.ExeName));//20200914 Igor
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];  //20210701 Igor
    HTTP.IOHandler := IdSSLIOHandlerSocket;
    HTTP.HandleRedirects := True;
    HTTP.AllowCookies := True;
    HTTP.ConnectTimeout := HTTP_TimeOut;
    HTTP.ReadTimeout := HTTP_TimeOut;
    with HTTP do
    begin
      Request.UserAgent := 'Mozilla/4.0';
      Request.Connection := 'Keep-Alive';
      Request.ProxyConnection := 'Keep-Alive';
      Request.CacheControl := 'no-cache';
    end;
    Result := HTTP.Get(AUrl);
  finally
    IdSSLIOHandlerSocket.Free;
    HTTP.Free;
  end;
end;

function TVirtualTaxOfficeInfo.GetNameForCyberId(ACyberId: string): string; //20210322 Igor
var FParams: TParamList;
    Res: TJSONObject;
begin
  Result := '';
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'LOAD_PROFILE');
    FParams.AddParam('CyberId', ACyberId);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet, true);
    if Assigned(Res) then
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        if GetAccountType(ACyberId) = vtoOffice then
          Result := GetJSONValue(Res, 'BusinessName')
        else
          Result := GetJSONValue(Res, 'LastName') + ' ' + GetJSONValue(Res, 'FirstName');
      end;
  finally
    FParams.Free;
    if Assigned(Res) then
      FreeAndNil(Res);
  end;
end;

function TVirtualTaxOfficeInfo.GetSessionToken: string; //20210430 Igor
var FParams: TParamList;
    Res: TJSONObject;
    FS : TFileStream;
    HTTP: TIdHTTP;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := '';
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'GET_SESSION_TOKEN');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet, true);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
        Result := GetJSONValue(Res, 'TokenId')
      else
        ShowMessageError(GetJSONValue(Res, 'error_message'));
    end;
  finally
    FParams.Free;
    if Assigned(Res) then
      FreeAndNil(Res);
  end;
end;

function TVirtualTaxOfficeInfo.GetSignature(ATaxPayerCyberId,  //20210331 Igor
  AFolder: string): string;
var FParams: TParamList;
    Res: TJSONObject;
    FS : TFileStream;
    HTTP: TIdHTTP;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
    FSignatureFile, FLocalFileName: string;
begin
  FSignatureFile := '';
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'LOAD_PROFILE');
    FParams.AddParam('CyberId', ATaxPayerCyberId);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet, true);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
        FSignatureFile := GetJSONValue(Res, 'SignatureFile')
      else
        ShowMessageError(GetJSONValue(Res, 'error_message'));
    end;
  finally
    FParams.Free;
    if Assigned(Res) then
      FreeAndNil(Res);
  end;
  if FSignatureFile.IsEmpty then Exit;
  //20220202 Igor >>>
  if not DirectoryExists(AFolder) then
    ForceDirectories(AFolder);
  //20220202 Igor <<<
  FLocalFileName := TPath.Combine(AFolder, 'Signature' + ExtractFileExt(FSignatureFile));
  FS := TFileStream.Create(FLocalFileName, fmCreate);
  HTTP := TIdHTTP.Create(nil);
  IdOpenSSLSetLibPath(ExtractFilePath(Application.ExeName));
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];  //20210701 Igor
    HTTP.IOHandler := IdSSLIOHandlerSocket;
    HTTP.HandleRedirects := True;
    HTTP.AllowCookies := True;
    HTTP.ConnectTimeout := HTTP_TimeOut;
    HTTP.ReadTimeout := HTTP_TimeOut;
    with HTTP do
    begin
      Request.UserAgent := 'Mozilla/4.0';
      Request.Connection := 'Keep-Alive';
      Request.ProxyConnection := 'Keep-Alive';
      Request.CacheControl := 'no-cache';
    end;
    HTTP.Get(BaseUrl + FSignatureFile, FS);
  finally
    FreeAndNil(FS);
    IdSSLIOHandlerSocket.Free;
    HTTP.Free;
  end;
end;

function TVirtualTaxOfficeInfo.GetTaxPayerInfo(ATaxPayerCyberId: string): TTaxPayer; //20210203 Igor
var FParams: TParamList;
    Res: TJSONObject;
begin
  if ATaxPayerCyberId.IsEmpty then Exit;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'LOAD_PROFILE');
    FParams.AddParam('CyberId', ATaxPayerCyberId);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet, true);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
      begin
        Result.CyberId := GetJSONValue(Res, 'CyberId');
        Result.LastName := GetJSONValue(Res, 'LastName');
        Result.FirstName := GetJSONValue(Res, 'FirstName');
        Result.Email := GetJSONValue(Res, 'Email');
        Result.TeamViewerId := GetJSONValue(Res, 'TeamviewerID');
        Result.UltraViewerId := GetJSONValue(Res, 'UltraViewerID');
        Result.Phone := GetJSONValue(Res, 'Area') + ' ' + GetJSONValue(Res, 'Phone'); //20210204 Igor
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

function TVirtualTaxOfficeInfo.GetTaxPayerCyberIdByEmail(AEmail: string;
  ASilent: boolean): string;
var FParams: TParamList;
    Res: TJSONObject;
begin
  Result := '';
  if AEmail.IsEmpty then
  begin
    if not ASilent then
      ShowMessage('Email is empty');
    Exit;
  end;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'GET_TAXPAYER_CYBERID_BY_EMAIL');
    FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    FParams.AddParam('Email', AEmail);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet, ASilent);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
        Result := GetJSONValue(Res, 'CyberId')
      else if not ASilent then
        ShowMessageError(GetJSONValue(Res, 'error_message')); //20201221 Igor
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

procedure TVirtualTaxOfficeInfo.IncFileEncrPsw(AID: integer; ASilent: boolean);
var FParams: TParamList;
    Res: TJSONObject;
begin
  if AID = 0 then
  begin
    if not ASilent then
      ShowMessage('Virtual Client Id is not defined'); //20210201 Igor
    Exit;
  end;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'INC_FILE_ENCRPSW');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    FParams.AddParam('Id', IntToStr(AId));
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtPost, ASilent);
    if Assigned(Res) then
    begin
      if not SameText(GetJSONValue(Res, 'success'), 'true') then
        if not ASilent then
          ShowMessageError(GetJSONValue(Res, 'error_message')); //20201221 Igor
    end;
  finally
    FParams.Free;
    //20210218 Igor >>>
    if Assigned(Res) then
      FreeAndNil(Res);
    //20210218 Igor <<<
  end;
end;

function TVirtualTaxOfficeInfo.IsTaxPayerActivated( //20220317 Igor
  ATaxPayerCyberId: string): boolean;
var FParams: TParamList;
    Res: TJSONObject;
begin
  Result := false;
  FParams := TParamList.Create;
  try
    FParams.AddParam('action', 'CHECK_PAYER_STATUS');
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    FParams.AddParam('CyberId', ATaxPayerCyberId);
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
        Result := SameText(GetJSONValue(Res, 'Activated'), 'Y');
    end;
  finally
    FParams.Free;
    if Assigned(Res) then
      FreeAndNil(Res);
  end;
end;

procedure TVirtualTaxOfficeInfo.LoadPatterns(AForceReload: boolean = false); //20210304 Igor
var FS : TFileStream;
    HTTP: TIdHTTP;
    IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
    cTempFile, cTempDir: string;
    FZip: TZipFile;
    MaxWidth, MaxHeight, I: integer;
    FBmp: TBitmap;

    function GetTempDir: string;
    var
      TempPath: array[0..MAX_PATH - 1] of Char;
    begin
      GetTempPath(MAX_PATH, TempPath);
      Result := TempPath;
    end;

    procedure DeleteDirectory(const ADir: string);
    var
      F: TSearchRec;
    begin
      if FindFirst(ADir + '\*', faAnyFile, F) = 0 then begin
        try
          repeat
            if (F.Attr and faDirectory <> 0) then begin
              if (F.Name <> '.') and (F.Name <> '..') then begin
                DeleteDirectory(ADir + '\' + F.Name);
              end;
            end else begin
              DeleteFile(PChar(ADir + '\' + F.Name));
            end;
          until FindNext(F) <> 0;
        finally
          SysUtils.FindClose(F);
        end;
        RemoveDir(ADir);
      end;
    end;
begin
  if (Length(FPatterns) > 0) and not AForceReload then Exit;
  ClearPatterns;
  cTempDir := TPath.Combine(GetTempDir, 'VTO_Patterns');
  if DirectoryExists(cTempDir) then
    DeleteDirectory(cTempDir);
  ForceDirectories(cTempDir);
  cTempFile := TPath.Combine(cTempDir, 'patterns.zip');
  FS := TFileStream.Create(cTempFile, fmCreate);
  HTTP := TIdHTTP.Create(nil);
  IdOpenSSLSetLibPath(ExtractFilePath(Application.ExeName));
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    IdSSLIOHandlerSocket.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];  //20210701 Igor
    HTTP.IOHandler := IdSSLIOHandlerSocket;
    HTTP.HandleRedirects := True;
    HTTP.AllowCookies := True;
    HTTP.ConnectTimeout := HTTP_TimeOut;
    HTTP.ReadTimeout := HTTP_TimeOut;
    with HTTP do
    begin
      Request.UserAgent := 'Mozilla/4.0';
      Request.Connection := 'Keep-Alive';
      Request.ProxyConnection := 'Keep-Alive';
      Request.CacheControl := 'no-cache';
    end;
    HTTP.Get(VirtualTaxOfficeUrl + '?action=GET_PATTERNS', FS);
  finally
    FreeAndNil(FS);
    IdSSLIOHandlerSocket.Free;
    HTTP.Free;
  end;
  FZip := TZipFile.Create;
  try
    try
      FZip.Open(cTempFile, zmRead);
      FZip.ExtractAll(cTempDir);
      FZip.Close;
      SysUtils.DeleteFile(cTempFile);
    except on E: Exception do
      begin
        Screen.Cursor := crDefault;
        ShowMessage('Error occured while unzipping file with patterns: ' + E.Message);
        Exit;
      end;
    end;
  finally
    FZip.Free;
  end;

  // fill patterns
  TDirectory.GetFiles(cTempDir, '*.png', TSearchOption.soTopDirectoryOnly,
    function(const Path: string; const SearchRec: TSearchRec): Boolean

      procedure AddPattern(AName: string);
      var I: integer;
          cFile, cName: string;
          FPng: TPngImage;
      begin
        if SameText(AName, '.') or SameText(AName, '..') or SameText(AName, '{}') or AName.IsEmpty then Exit;
        cFile := TPath.Combine(cTempDir, AName);
        cName := ReplaceStr(AName, '_', ' ');
        cName := ReplaceStr(cName, ExtractFileExt(cName), '');
        cName := UpperCase(Copy(cName, 1, 1)) + Copy(cName, 2, Length(cName));
        AName := 'img/patterns/' + AName;
        SetLength(FPatterns, Length(FPatterns) + 1);
        I := Length(FPatterns) - 1;
        FPatterns[I].Bitmap := TBitmap.Create;
        FPng := TPngImage.Create;
        try
          FPng.LoadFromFile(cFile);
          FPatterns[I].FileName := AName;
          FPatterns[I].Url := BaseUrl + AName;
          FPatterns[I].Bitmap.Width := FPng.Width;
          FPatterns[I].Bitmap.Height := FPng.Height;
          FPatterns[I].Bitmap.Assign(FPng);
          FPatterns[I].Name := cName;
          FPatterns[I].Width := FPatterns[I].Bitmap.Width;
          FPatterns[I].Height := FPatterns[I].Bitmap.Height;

          if FPatterns[I].Width > MaxWidth then
            MaxWidth := FPatterns[I].Width;
          if FPatterns[I].Height > MaxHeight then
            MaxHeight := FPatterns[I].Height;
        finally
          FPng.Free;
        end;
      end;

    begin
      Result := True;
      AddPattern(SearchRec.Name);
    end);

  // fill imagelist
  FPatternsList.Width := MaxWidth;
  FPatternsList.Height := MaxHeight;
  for I := 0 to Length(FPatterns) - 1 do
  begin
    FBmp := TBitmap.Create;
    try
      FBmp.Width := MaxWidth;
      FBmp.Height := MaxHeight;
      FBmp.Canvas.Brush.Color := clWhite;
      FBmp.Canvas.Brush.Style := bsSolid;
      FBmp.Canvas.FillRect(Rect(0, 0, MaxWidth, MaxHeight));
      FBmp.Canvas.Draw((MaxWidth - FPatterns[I].Width) div 2,
                       (MaxHeight - FPatterns[I].Height) div 2,
                       FPatterns[I].Bitmap);
      FPatternsList.AddMasked(FBmp, -1);
    finally
      FBmp.Free;
    end;
  end;
end;

(*
procedure TVirtualTaxOfficeInfo.LoadPatterns; //20210303 Igor
var FParams: TParamList;
    Res: TJSONObject;
    Values: TJSONArray;
    ArrayElement: TJSONValue;
    FBaseUrl: string;
    MaxWidth, MaxHeight, I: integer;
    FBmp: TBitmap;

    procedure AddPattern(AName: string);
    var I: integer;
        MS : TMemoryStream;
        HTTP: TIdHTTP;
        IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
        cName: string;
        FPng: TPngImage;
    begin
      if SameText(AName, '.') or SameText(AName, '..') or SameText(AName, '{}') or AName.IsEmpty then Exit;
      cName := ReplaceStr(AName, '_', ' ');
      cName := ReplaceStr(cName, ExtractFileExt(cName), '');
      cName := UpperCase(Copy(cName, 1, 1)) + Copy(cName, 2, Length(cName));
      AName := 'img/patterns/' + AName;
      SetLength(FPatterns, Length(FPatterns) + 1);
      I := Length(FPatterns) - 1;
      FPatterns[I].Bitmap := TBitmap.Create;
      MS := TMemoryStream.Create;
      HTTP := TIdHTTP.Create(nil);
      IdOpenSSLSetLibPath(ExtractFilePath(Application.ExeName));
      IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      FPng := TPngImage.Create;
      try
        HTTP.IOHandler := IdSSLIOHandlerSocket;
        HTTP.HandleRedirects := True;
        HTTP.AllowCookies := True;
        HTTP.ConnectTimeout := HTTP_TimeOut;
        HTTP.ReadTimeout := HTTP_TimeOut;
        with HTTP do
        begin
          Request.UserAgent := 'Mozilla/4.0';
          Request.Connection := 'Keep-Alive';
          Request.ProxyConnection := 'Keep-Alive';
          Request.CacheControl := 'no-cache';
        end;
        FPatterns[I].FileName := AName;
        FPatterns[I].Url := FBaseUrl + AName;
        HTTP.Get(FPatterns[I].Url, MS);
        MS.Seek(0,soFromBeginning);
        //FPatterns[I].Image.LoadFromStream(MS);
        FPng.LoadFromStream(MS);
        FPatterns[I].Bitmap.Width := FPng.Width;
        FPatterns[I].Bitmap.Height := FPng.Height;
        FPatterns[I].Bitmap.Assign(FPng);
        FPatterns[I].Name := cName;
        FPatterns[I].Width := FPatterns[I].Bitmap.Width;
        FPatterns[I].Height := FPatterns[I].Bitmap.Height;

        if FPatterns[I].Width > MaxWidth then
          MaxWidth := FPatterns[I].Width;
        if FPatterns[I].Height > MaxHeight then
          MaxHeight := FPatterns[I].Height;
      finally
        FreeAndNil(MS);
        IdSSLIOHandlerSocket.Free;
        HTTP.Free;
        FPng.Free;
      end;
    end;
begin
  ClearPatterns;
  FBaseUrl := ReplaceStr(VirtualTaxOfficeUrl, 'api.php', '');
  FParams := TParamList.Create;
  MaxWidth := 0;
  MaxHeight := 0;
  try
    FParams.Add('action=LIST_PATTERNS');
    Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtGet);
    if Assigned(Res) then
    begin
      if SameText(Res.Get('success').JSONValue.Value, 'true') then
      begin
        Values := TJSONArray(Res.Get('files').JSONValue);
        if Assigned(Values) then
        begin
          for ArrayElement in Values do
            if Assigned(ArrayElement) then
              AddPattern(ArrayElement.Value);
        end;
      end
      else
        ShowMessage(Res.Get('error_message').JSONValue.Value);
    end;
  finally
    FParams.Free;
    if Assigned(Res) then
      FreeAndNil(Res);
  end;

  // fill imagelist
  FPatternsList.Width := MaxWidth;
  FPatternsList.Height := MaxHeight;
  for I := 0 to Length(FPatterns) - 1 do
  begin
    FBmp := TBitmap.Create;
    try
      FBmp.Width := MaxWidth;
      FBmp.Height := MaxHeight;
      FBmp.Canvas.Brush.Color := clWhite;
      FBmp.Canvas.Brush.Style := bsSolid;
      FBmp.Canvas.FillRect(Rect(0, 0, MaxWidth, MaxHeight));
      FBmp.Canvas.Draw((MaxWidth - FPatterns[I].Width) div 2,
                       (MaxHeight - FPatterns[I].Height) div 2,
                       FPatterns[I].Bitmap);
      FPatternsList.AddMasked(FBmp, -1);
    finally
      FBmp.Free;
    end;
  end;
end;
*)

function TVirtualTaxOfficeInfo.ReadClientDocs: string; //20210205 Igor
begin
  Result := ReadOption('ClientDocs');
  if Result.IsEmpty then
    Result := CLIENT_DOCS_DIR;
end;

function TVirtualTaxOfficeInfo.ReadOption(AOptionName: string; ADecrypt: boolean = false): string; //20210426 Igor
var FIniFile: TIniFile;
begin
  FIniFile := TIniFile.Create(FIniPath);
  try
    Result := FIniFile.ReadString('Main', AOptionName, '');
    if ADecrypt then
      Result := DecryptValue(Result);
  finally
    FIniFile.Free;
  end;
end;

procedure TVirtualTaxOfficeInfo.RefreshTaxOfficeInfo;
var FParams: TParamList;
    Res: TJSONObject;
begin
  if (AccountType <> vtoPayer) or CyberId.IsEmpty then
  begin
    TaxOffice.CyberId := '';
    TaxOffice.Name := '';
    TaxOffice.Contact := '';
    TaxOffice.Email := '';
    //20210203 Igor >>>
    TaxOffice.TeamViewerId := '';
    TaxOffice.UltraViewerId := '';
    //20210203 Igor <<<
    TaxOffice.Phone := ''; //20210204 Igor
    Email := ''; //20210202 Igor
    Exit;
  end;
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
        TaxOffice.CyberId := GetJSONValue(Res, 'TaxOfficeCyberId');
        TaxOffice.Name := GetJSONValue(Res, 'TaxOfficeName');
        TaxOffice.Contact := GetJSONValue(Res, 'TaxOfficeContact');
        TaxOffice.Email := GetJSONValue(Res, 'TaxOfficeEmail');
        //20210203 Igor >>>
        TaxOffice.TeamViewerId := GetJSONValue(Res, 'TaxOfficeTeamViewerID');
        TaxOffice.UltraViewerId := GetJSONValue(Res, 'TaxOfficeUltraViewerID');
        //20210203 Igor <<<
        TaxOffice.Phone := GetJSONValue(Res, 'TaxOfficeArea') + ' ' + GetJSONValue(Res, 'TaxOfficePhone'); //20210204 Igor
        Email := GetJSONValue(Res, 'Email'); //20210202 Igor
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

procedure TVirtualTaxOfficeInfo.SaveOption(AOptionName, AValue: string; AEncrypt: boolean = false); //20210426 Igor
var FIniFile: TIniFile;
begin
  FIniFile := TIniFile.Create(FIniPath);
  try
    if AEncrypt then
      FIniFile.WriteString('Main', AOptionName, EncryptValue(AValue))
    else
      FIniFile.WriteString('Main', AOptionName, AValue);
  finally
    FIniFile.Free;
  end;
end;

procedure TVirtualTaxOfficeInfo.SetCyberId(const Value: string);
begin
  FCyberId := Value;
  //20210118 Igor >>>
  if not FCyberId.IsEmpty then
  begin
    if IsVtClient then
      SaveOption('PayerCyberID', Value)
    else
      SaveOption('OfficeCyberID', Value);
  end
  //20210118 Igor <<<
  else
  begin
    CyberIdPassword := '';
    SessionId := '';
  end;
  //20201216 Igor >>>
  FAccountType := GetAccountType(FCyberId); //20201222 Igor
  //20201216 Igor <<<
  RefreshTaxOfficeInfo;
  FCurrentName := ''; //20210409 Igor
end;

procedure TVirtualTaxOfficeInfo.ShowServiceRequests; //20210430 Igor
var FTokenId, FUrl: string;
begin
  FTokenId := GetSessionToken;
  if FTokenId.IsEmpty then Exit;
  FUrl := BaseUrl + 'T1ServiceRequest_list.php?TokenId='+ FTokenId;
  ConnectToWeb(FUrl);
end;

procedure TVirtualTaxOfficeInfo.ShowVirtualClientsAndAppointments; //20210430 Igor
var FTokenId, FUrl: string;
begin
  FTokenId := GetSessionToken;
  if FTokenId.IsEmpty then Exit;
  FUrl := BaseUrl + 'taxoffice_clients_list.php?TokenId='+ FTokenId;
  ConnectToWeb(FUrl);
end;

function TVirtualTaxOfficeInfo.SendEmail(AEmail, ASubject, ABody: String; AAttachments: String = ''): boolean; //20220202 Igor
var FParams, FFiles: TParamList;
    Res: TJSONObject;
    FilesList: TStringList;
    I: integer;
begin
  Result := false;
  FParams := TParamList.Create;
  FFiles := TParamList.Create;
  try
    FParams.AddParam('action', 'SEND_EMAIL');
    FParams.AddParam('CyberId', VirtualTaxOfficeInfo.CyberId);
    FParams.AddParam('SessionId', VirtualTaxOfficeInfo.SessionId);
    FParams.AddParam('Email', AEmail);
    FParams.AddParam('Subject', ASubject);
    FParams.AddParam('Body', ABody);
    if not AAttachments.IsEmpty then
    begin
      FilesList := TStringList.Create;
      try
        FilesList.Text := AAttachments;
        for I := 0 to FilesList.Count - 1 do
          FFiles.AddParam(ExtractFileName(FilesList.Strings[I]), FilesList.Strings[I]);
      finally
        FilesList.Free;
      end;
    end;

    if FFiles.Count = 0 then
      Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtPost, false)
    else
      Res := VirtualTaxOfficeInfo.RequestToVirtualTaxOffice(FParams, rtFiles, false, FFiles);
    if Assigned(Res) then
    begin
      if SameText(GetJSONValue(Res, 'success'), 'true') then
        Result := true
      else
        ShowMessageError(GetJSONValue(Res, 'error_message'));
    end;
  finally
    FParams.Free;
    FFiles.Free;
    if Assigned(Res) then
      FreeAndNil(Res);
  end;
end;

(* //20220202 Igor
function TVirtualTaxOfficeInfo.SendMAPIMail(const Subject, Body, FileNames,SenderName, SenderEMail,RecipientName, RecipientEMail: AnsiString): Integer; //20201221 Igor
// scalabium.com/faq/dct0115.htm
var
  Message: TMapiMessage;
  lpSender, lpRecipient: TMapiRecipDesc;
  FileAttachments: Array[0..100] of TMapiFileDesc;
  AttachmentList: TStringList;
  I: integer;

  SM: TFNMapiSendMail;
  MAPIModule: HModule;
  cError: string;
  cFiles: TArray<AnsiString>; //20201023 Igor
begin
  ShowMessage('Click the send button of the created Email. If you cannot see it, minimize your T1 Window or switch to your mail program in taskbar'); //20210419 Igor
  FillChar(Message, SizeOf(Message), 0);
  AttachmentList := TStringList.Create;
  try
    with Message do
    begin
      if (Subject <> '') then
        lpszSubject := PAnsiChar(''+Subject);

      if (Body <> '') then
        lpszNoteText := PAnsiChar(''+Body);

      if (SenderEmail <> '') then
      begin
        //20210217 Igor >>>
        lpSender.ulRecipClass := MAPI_ORIG;
        //20210317 Igor >>>
        lpSender.lpszName := PAnsiChar('');
        lpSender.lpszAddress := PAnsiChar('');
        //20210317 Igor <<<
        lpSender.ulReserved := 0;
        lpSender.ulEIDSize := 0;
        lpSender.lpEntryID := nil;
        lpOriginator := @lpSender;
        //20210217 Igor <<<
      end;

      if (RecipientEmail <> '') then
      begin
        lpRecipient.ulRecipClass := MAPI_TO;
        if (RecipientName = '') then
          lpRecipient.lpszName := PAnsiChar(''+RecipientEMail)
        else
          lpRecipient.lpszName := PAnsiChar(''+RecipientName);
        lpRecipient.lpszAddress := PAnsiChar('SMTP:'+RecipientEmail); //20210217 Igor
        lpRecipient.ulReserved := 0;
        lpRecipient.ulEIDSize := 0;
        lpRecipient.lpEntryID := nil;
        nRecipCount := 1;
        lpRecips := @lpRecipient;
      end
      else
        lpRecips := nil;

      if (FileNames = '') then
      begin
        nFileCount := 0;
        lpFiles := nil;
      end
      else
      begin
        AttachmentList.Text := FileNames;
        if AttachmentList.Count > 100 then
        begin
          Result := -1;
          ShowMessage('Only 100 files allowed for attach');
          Exit;
        end;
        nFileCount := AttachmentList.Count;
        lpFiles := @FileAttachments;
        FillChar(FileAttachments, SizeOf(FileAttachments), 0);
        //20201023 Igor >>>
        SetLength(cFiles, AttachmentList.Count);
        for I := 0 to AttachmentList.Count - 1 do
        begin
          cFiles[I] := AnsiString(AttachmentList.Strings[I]);
          FileAttachments[I].nPosition := Cardinal($FFFFFFFF);
          FileAttachments[I].lpszPathName := PAnsiChar(cFiles[I]);
        end;
        //20201023 Igor <<<
      end;
    end;

    MAPIModule := LoadLibrary(PChar(MAPIDLL));
    if MAPIModule = 0 then
      Result := -1
    else
      try
        @SM := GetProcAddress(MAPIModule, 'MAPISendMail');
        if @SM <> nil then
        begin
          Result := SM(0, Application.Handle, Message, MAPI_DIALOG or MAPI_LOGON_UI, 0);
          //Result := MapiSendMail(0, Application.Handle, Message, MAPI_DIALOG or MAPI_LOGON_UI, 0);
        end
        else
          Result := 1;
      finally
        FreeLibrary(MAPIModule);
      end;

    case Result of
      MAPI_USER_ABORT: cError := 'User abort';
      MAPI_E_FAILURE: cError := 'Failure';
      MAPI_E_LOGON_FAILURE: cError := 'Logon failure';
      MAPI_E_DISK_FULL: cError := 'Disk is full';
      MAPI_E_INSUFFICIENT_MEMORY: cError := 'Unsufficient memory';
      MAPI_E_ACCESS_DENIED: cError := 'Access denied';
      MAPI_E_TOO_MANY_SESSIONS: cError := 'Too many sessions';
      MAPI_E_TOO_MANY_FILES: cError := 'Too many files';
      MAPI_E_TOO_MANY_RECIPIENTS: cError := 'Too many recipients';
      MAPI_E_ATTACHMENT_NOT_FOUND: cError := 'Attachment not found';
      MAPI_E_ATTACHMENT_OPEN_FAILURE: cError := 'Attachment open failure';
      MAPI_E_ATTACHMENT_WRITE_FAILURE: cError := 'Attachment write failure';
      MAPI_E_UNKNOWN_RECIPIENT: cError := 'Unknown recipient';
      MAPI_E_BAD_RECIPTYPE: cError := 'Bad recipient type';
      MAPI_E_NO_MESSAGES: cError := 'No messages';
      MAPI_E_INVALID_MESSAGE: cError := 'Invalid message';
      MAPI_E_TEXT_TOO_LARGE: cError := 'Text too large';
      MAPI_E_INVALID_SESSION: cError := 'Invalid session';
      MAPI_E_TYPE_NOT_SUPPORTED: cError := 'Type not supported';
      MAPI_E_AMBIGUOUS_RECIPIENT: cError := 'Ambiguous recipient';
      MAPI_E_MESSAGE_IN_USE: cError := 'Message is use';
      MAPI_E_NETWORK_FAILURE: cError := 'Network failure';
      MAPI_E_INVALID_EDITFIELDS: cError := 'Invalid edit fields';
      MAPI_E_INVALID_RECIPS: cError := 'Invalid recipients';
      MAPI_E_NOT_SUPPORTED: cError := 'Not supported';
    end;
    //20210210 Igor >>>
    if (Result <> SUCCESS_SUCCESS) then
      if (Result = MAPI_USER_ABORT) then
        ShowMessageWarning('Email was not sent')
      else
        ShowMessageError('Error occured on opening email (MAPI): '+ #13#10#13#10 + cError);
    //20210210 Igor <<<
  finally
    AttachmentList.Free;
  end;
end;
*)

{ TParamList }

procedure TParamList.AddParam(AName, AValue: string);
begin
  //Add(HTTPEncode(AName) + '=' + HTTPEncode(AValue));
  Add(AName+ '=' + AValue);
end;

procedure TParamList.AddParam(AName: string; AValue: boolean); //20220317 Igor
begin
  if AValue then
    Add(AName+ '=true')
  else
    Add(AName+ '=false');
end;

function TParamList.Params: string;
var I: integer;
begin
  Result := '';
  for I := 0 to Count - 1 do
  begin
    if not Result.IsEmpty then
      Result := Result + '&';
    Result := Result + HTTPEncode(Names[I]) + '=' + HTTPEncode(ValueFromIndex[I]);
  end;
  if not Result.IsEmpty then
    Result := '?' + Result;
end;

initialization
  VirtualTaxOfficeInfo := TVirtualTaxOfficeInfo.Create;
  //20210205 Igor >>>
  if IsVtClient then
    ForceDirectories(CLIENT_DOCS_DIR);
  //20210205 Igor <<<

finalization
  if Assigned(VirtualTaxOfficeInfo) then
    VirtualTaxOfficeInfo.Free;
end.
