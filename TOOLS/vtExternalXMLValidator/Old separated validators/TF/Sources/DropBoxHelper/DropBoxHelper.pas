unit DropBoxHelper;

interface

uses
  vtCommonIntf,
  System.Classes,

  REST.Client,
  REST.Authenticator.OAuth,
  REST.Authenticator.OAuth.WebForm.Win,
  REST.Utils,
  REST.Response.Adapter,
  FireDAC.Comp.Client;

type
  TDropBoxHelper = class(TCloudHelper)
  private
    FMemData: TFDMemTable;
    FRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
    FRESTResponse: TRESTResponse;
    FOAuth2_DropBox: TOAuth2Authenticator;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;
    function CraftToken: boolean;
    function DoUpload: boolean;
    procedure OAuth2_DropBox_AccessTokenRedirect(const AURL: string; var DoCloseWebView: boolean);
    procedure WebBrowser1NavigateError(ASender: TObject;
      const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
      var Cancel: WordBool);
    function GenerateAuthorizeURL: string;
  public
    constructor Create;
    destructor Destroy; override;
    function Send: boolean; overload; override;
    function Send(const ALocalFile, ACloudFile,
      ADropBoxClientId, AToken: String): boolean; overload; override;
  end;

  procedure Radar(out AClass: TCloudHelperClass; out AHelperName: string); export;
implementation

uses
  System.StrUtils,
  System.SysUtils,
  Vcl.Dialogs,
  REST.Types,
  System.UITypes,
  Vcl.Forms;

procedure Radar(out AClass: TCloudHelperClass; out AHelperName: string);
begin
  AClass := TDropBoxHelper;
  AHelperName := 'DropBox';
end;
{ TDropBoxHelper }

const
  c_VisualTaxDropBoxClientID = 'clmqhseptut86vm';
  c_DropBox_BaseURL = 'https://api.dropbox.com/1/';
  c_DropBox_BaseURL_Put = 'https://api-content.dropbox.com/1/';
  c_DropBox_ResourceURI = 'metadata/{ROOT}/{PATH}';
  c_DropBox_ResourceURI_Put = 'files_put/{ROOT}/{PATH}?{ACCES_TOKEN}={VALUE}';

function TDropBoxHelper.CraftToken: boolean;
var
  wv: Tfrm_OAuthWebForm;
begin
  wv := Tfrm_OAuthWebForm.Create(nil);
  try
    wv.OnAfterRedirect := self.OAuth2_DropBox_AccessTokenRedirect;
    wv.OnBeforeRedirect := self.OAuth2_DropBox_AccessTokenRedirect;
    wv.Browser.OnNavigateError := WebBrowser1NavigateError;
    wv.ShowModalWithURL(GenerateAuthorizeURL);
  finally
    wv.Release;
  end;
end;

constructor TDropBoxHelper.Create;
begin
  inherited Create;
  //MemData
  FMemData := TFDMemTable.Create(nil);
  //RESTResponseDataSetAdapter
  FRESTResponseDataSetAdapter := TRESTResponseDataSetAdapter.Create(nil);
  //RESTResponse
  FRESTResponse := TRESTResponse.Create(nil);
  //OAuth2_DropBox
  FOAuth2_DropBox := TOAuth2Authenticator.Create(nil);
  //RESTRequest
  FRESTRequest := TRESTRequest.Create(nil);
  //RESTClient
  FRESTClient := TRESTClient.Create(nil);
  //RESTResponseDataSetAdapter
  FRESTResponseDataSetAdapter.Dataset := FMemData;
  FRESTResponseDataSetAdapter.Response := FRESTResponse;
  //OAuth2_DropBox
  FOAuth2_DropBox.AccessTokenEndpoint := 'https://api.dropbox.com/1/oauth2/token';
  FOAuth2_DropBox.AuthorizationEndpoint := 'https://www.dropbox.com/1/oauth2/authorize';
  FOAuth2_DropBox.RedirectionEndpoint := 'http://localhost';
  FOAuth2_DropBox.ResponseType := REST.Authenticator.OAuth.TOAuth2ResponseType.rtTOKEN;
  //RESTRequest
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
  FRESTRequest.SynchronizedEvents := False;
  //RESTClient
  FRESTClient.Authenticator := FOAuth2_DropBox;
  FRESTClient.Accept := 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';
  FRESTClient.HandleRedirects := True;
end;

destructor TDropBoxHelper.Destroy;
begin
  FMemData.Free;
  FRESTResponseDataSetAdapter.Free;
  FRESTResponse.Free;
  FOAuth2_DropBox.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
  inherited;
end;

function TDropBoxHelper.DoUpload: boolean;
var
  local_filename: String;
  upload_stream: TFileStream;
begin
  local_filename := ExtractFileName(FLocalFile);

  FRESTRequest.Method := TRESTRequestMethod.rmPUT;
  FRESTClient.BaseURL :=  c_DropBox_BaseURL_Put;
  FRESTClient.Authenticator := nil;

  FRESTRequest.Params.Clear;
  FRESTRequest.ClearBody;
  FRESTRequest.Resource := c_DropBox_ResourceURI_Put;
  FRESTRequest.Params.AddItem('ROOT', 'auto', TRESTRequestParameterKind.pkURLSEGMENT);
  FRESTRequest.Params.AddItem('PATH', URIEncode(FCloudFile), TRESTRequestParameterKind.pkURLSEGMENT);
  FRESTRequest.Params.AddItem('ACCES_TOKEN', 'access_token', TRESTRequestParameterKind.pkURLSEGMENT);
  FRESTRequest.Params.AddItem('VALUE', FToken, TRESTRequestParameterKind.pkURLSEGMENT);


  FRESTClient.ContentType := 'text/plain';
  FRESTRequest.ClearBody;

  upload_stream := TFileStream.Create(FLocalFile ,fmOpenRead);
  upload_stream.Position := 0;
  FRESTRequest.Params.AddHeader('Content-Type', 'multipart/mixed');
  FRESTRequest.Params.AddHeader('Content-Length', IntTostr(upload_stream.Size));

  try
    FRESTRequest.AddBody(upload_stream, TRESTContentType.ctMULTIPART_MIXED);
    try
      FRESTRequest.Execute;
    except ON E: Exception DO
      begin
        MessageDlg(E.Message, mtError, [mbOk], 0);
        exit(false);
      end;
    end;
  finally
    upload_stream.Free;
  end;

  //Check upload
  if (FMemData.RecordCount > 0) and
     (FMemData.FindField('revision') <> nil) and
     (FMemData.FindField('modified') <> nil) then

  begin // Upload Ok, exit program
    MessageDlg('Upload comlete.'+#13+
               '  File revision = "'+FMemData.FindField('revision').AsString+'"' + #13 +
               '  Date modification = "'+FMemData.FindField('modified').AsString+'"',
      mtInformation, [mbOk], 0);
    exit(true);
  end
  else
  Begin
    MessageDlg('Unknown error. Server said "'+FRESTResponse.JSONText+'"', mtError, [mbOk], 0);
    exit(False);
  End;
end;

procedure TDropBoxHelper.OAuth2_DropBox_AccessTokenRedirect(const AURL: string;
  var DoCloseWebView: boolean);
var
  LATPos: integer;
  LToken: string;
begin
  LATPos := Pos('access_token=', AURL);
  if (LATPos > 0) then
  begin
    LToken := Copy(AURL, LATPos + 13, Length(AURL));
    if (Pos('&', LToken) > 0) then
    begin
      LToken := Copy(LToken, 1, Pos('&', LToken) - 1);
    end;
    FToken := LToken;
    if (LToken <> '') then
      DoCloseWebView := TRUE;
  end;
end;

function TDropBoxHelper.Send(const ALocalFile, ACloudFile,
  ADropBoxClientId, AToken: String): boolean;
begin
  FLocalFile := ALocalFile;
  FCloudFile := ACloudFile;
  FDropBoxClientId := ADropBoxClientId;
  FToken := AToken;
  Result := Send;
end;

function TDropBoxHelper.Send: boolean;
begin
  if FToken = '' then
    if not CraftToken then
      exit(False);
  Result := DoUpload;
end;

procedure TDropBoxHelper.WebBrowser1NavigateError(ASender: TObject;
  const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
begin
  Cancel:=True;
end;

function TDropBoxHelper.GenerateAuthorizeURL: string;
begin
  if FDropBoxClientID = '' then
    FDropBoxClientID := c_VisualTaxDropBoxClientID;
  Result := 'https://www.dropbox.com/1/oauth2/authorize';
  Result := Result + '?client_id=' + URIEncode(FDropBoxClientID);
  Result := Result + '&response_type=' + URIEncode('token');
  Result := Result + '&redirect_uri=' + URIEncode('http://localhost');
end;

//procedure RegisterMe;
//var
//  vtMainForm: IVTMainForm;
//begin
//  if not Assigned(Application) then ShowMessage('Application')
//  else if not Assigned(Application.MainForm) then ShowMessage('Application.MainForm')
//  else if not Application.MainForm.GetInterface(IVTMainForm, vtMainForm) then ShowMessage('Application.MainForm.GetInterface')
//  else vtMainForm.RegisterCloudHelperClass(TDropBoxHelper, 'DropBox');
//end;

//procedure UnRegisterMe;
//var
//  vtMainForm: IVTMainForm;
//begin
//  if Assigned(Application) and
//     Assigned(Application.MainForm) then
//    if Application.MainForm.GetInterface(IVTMainForm, vtMainForm) then
//      vtMainForm.UnRegisterCloudHelperClass(TDropBoxHelper);
//end;

exports
  Radar;
initialization
//  RegisterMe;

finalization
//  UnRegisterMe;

end.
