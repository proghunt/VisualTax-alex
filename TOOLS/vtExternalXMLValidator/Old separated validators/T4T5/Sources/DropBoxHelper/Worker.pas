{$DEFINE API_V2}

unit Worker;

interface
uses
  vtCommonIntf,  System.SysUtils,  System.Classes,  REST.Client,  REST.Authenticator.OAuth,
  {REST.Authenticator.OAuth.WebForm.Win}OAuthWebForm, REST.Utils, REST.Types, REST.Response.Adapter, //20190228 Igor
  FireDAC.Comp.Client, IPPeerCommon, ippeerapi, IPPeerClient, Datasnap.DBClient, System.JSON,
  REST.JSON, System.Threading, System.Types, System.UITypes,  System.ZLib,  System.StrUtils,
  System.Generics.Collections, data.DB, Rest.Exception,
  MidasLib, System.DateUtils, vtLicense, DropBoxLicense; //20180113 Igor


type
  TDropBoxHelper = class(TCloudHelper)
  private
    FMemData: TClientDataSet;
    FRESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
    FRESTResponse: TRESTResponse;
    FOAuth2_DropBox: TOAuth2Authenticator;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;
    FAnswer: THelperAnswer;
    //20180113 Igor >>>
    FLicenseKey: string;
    LicenseRec: PPgmLicenseData;
    //20180113 Igor <<<
    wv: Tfrm_OAuthWebForm; //20161216 Igor
    FLicenseYear: integer; //20180307 Igor
    FLastError: string; //20200224 Igor
    //20230314 Igor >>>
    FAccessToken: string;
    FPreviousCode: string;
    //20230314 Igor <<<
    function CraftToken: boolean;
    function DoSetShare: boolean;
    function DoUpload: boolean;
    function DoDownload: boolean;
    function DoDownloadShared: boolean;
    function DoDeleteCloudFile: boolean; //20190522 Igor
    procedure DoCreateFolder;
    function DoDownloadList(ACreatePathIfNotExists: Boolean = False): TCloudFileList;
    function DoDownloadListReceived(ACreatePathIfNotExists: Boolean = False): TCloudFileList;
    procedure OAuth2_DropBox_AccessTokenRedirect(const AURL: string; var DoCloseWebView: boolean);
    //20190228 Igor >>>
    //procedure WebBrowser1NavigateError(ASender: TObject; const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
    procedure WebBrowserError(const URL: string);
    //20190228 Igor <<<
    function GenerateAuthorizeURL: string;
    procedure Init;
    procedure ResetAll;
    procedure DisableAdapter;
    procedure AddParamAuthorization;
    function CloudFolderExists: Boolean;
//    function MyExtractFileName(AFullPath: string): string;
    procedure DoLog(AEvent: String); //20161213 Igor
    function FindToken(AURL: String): Boolean; //20161216 Igor
    function CheckDateDemo(AKey: string = ''): boolean; //20180113 Igor
    //20230314 Igor >>>
    function GetRefreshTokenByCode(ACode: String): string;
    function PrepareAccessToken: boolean;
    procedure RefreshAccessToken;
    //20230314 Igor <<<
  public
    constructor Create; override;
    destructor Destroy; override;
    function Send: boolean; overload; override;
    function Send(const ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId, AToken: string): boolean; overload; override;
    function Get: boolean; overload; override;
    function Get(const ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId, AToken: string): boolean; overload; override;
    //20190522 Igor >>>
    function DeleteCloudFile: boolean; overload; override;
    function DeleteCloudFile(const ACloudPath, ACloudFile, ADropBoxClientId, AToken: string): boolean; overload; override;
    //20190522 Igor <<<
    function SetShare: boolean; overload; override;
    function SetShare(const AEmail, ACloudPath, ACloudFile, ADropBoxClientId, AToken: string): boolean; overload; override;
    function GetShared: boolean; overload; override;
    function GetShared(const ALocalFile, AUrlFile, ADropBoxClientId, AToken: string): boolean; overload; override;
    function List: PChar; overload; override;
    function List(const ACloudPath, ADropBoxClientId, AToken: string): PChar; overload; override;
    function ListReceived: PChar; overload; override;
    function ListReceived(ADropBoxClientId, AToken: String): PChar; overload; override;
    //20180113 Igor >>>
    function HasLicenseKey: boolean; override;
    function GetLicenseKey: string; override;
    function GetLicenseKeyPrefix: string; override;
    function GetLicenses: PPgmLicenseData; override;
    function ValidateKey(AKey: string; AYear: integer): boolean; override; //20190307 Igor
    function GetLicenseData(AKey: string): PPgmLicenseData; override;
    function GetLicenseDemoDate(AKey: string): TDateTime; override;
    procedure SetLicense(AKey: string); override; //20190307 Igor
    function AllowExecuteOperation(AHelperAction: THelperAction): boolean; override;
    //20180113 Igor <<<
    //20190305 Igor >>>
    function ValidateApp(AApp: string): boolean; override;
    function GetAllowedApps(AKey: string): string; override;
    //20190305 Igor <<<
    function GetLastError: string; override; //20200224 Igor
  end;

const
  c_VisualTaxDropBoxClientID =  'g7rtsx5fpvec4x8';
  c_VisualTaxDropBoxClientSecret =  'dgw2jn2tgedc9pz'; //20230314 Igor


var
  CallBackDialog: TCallBackHelperDialog;
  CallBackLocalFileExists: TCallBackHelperIOError;
  CallBackLocalFileNotExists: TCallBackHelperIOError;
  CallBackCloudFileExists: TCallBackHelperIOError;
  CallBackCloudFileNotExists: TCallBackHelperIOError;
  CallBackDownLoadError: TCallBackHelperIOError;
  CallBackUpLoadError: TCallBackHelperIOError;
  CallBackCheckBytesError: TCallBackHelperIOError;
  CallBackSaveLocalFileError: TCallBackHelperIOError;
  CallBackReadLocalFileError: TCallBackHelperIOError;
  CallBackHelperLog: TCallBackHelperLog;

function MyEncode(AValue: String): String;

//20230314 Igor >>>
type
  TAccessToken = class
  private
    FAccessToken: string;
    FExpiry: TDateTime;
  public
    property AccessToken: string read FAccessToken write FAccessToken;
    property Expiry: TDateTime read FExpiry write FExpiry;
end;

type
  TTokensCache = class(TDictionary<string, TAccessToken>)
  public
    destructor Destroy; override;
    procedure AddTokens(ARefreshToken, AAccessToken: string; AExpiry: Integer);
  end;

var TokensCache: TTokensCache;
//20230314 Igor <<<

implementation

const
//  c_DropBox_BaseURL = 'https://api.dropbox.com/1/';
  c_DropBox_BaseURL_Put = 'https://content.dropboxapi.com/2/files/upload';
//  c_DropBox_BaseURL_Get = 'https://content.dropboxapi.com/1/';
  c_DropBox_BaseURL_List =  'https://api.dropboxapi.com/2/files/list_folder';

  c_DropBox_BaseURL_ListReceived = 'https://api.dropboxapi.com/2/sharing/list_received_files';
  c_DropBox_BaseURL_List_Continue = 'https://api.dropboxapi.com/2/files/list_folder/continue';
  c_DropBox_BaseURL_ListReceived_Continue = 'https://api.dropboxapi.com/2/sharing/list_received_files/continue';

  c_DropBox_BaseURL_SharedList =  'https://api.dropboxapi.com/2/sharing/list_mountable_folders';
  c_DropBox_BaseURL_SharedList_Continue =  'https://api.dropboxapi.com/2/sharing/list_mountable_folders/continue';

  c_DropBox_BaseURL_CreateFolder = 'https://api.dropboxapi.com/2/files/create_folder';
  c_DropBox_BaseURL_List_SharedFolders =  'https://api.dropboxapi.com/2/sharing/list_mountable_folders';
  c_DropBox_BaseURL_List_SharedFolders_Continue =  'https://api.dropboxapi.com/2/sharing/list_mountable_folders/continue';

  c_DropBox_BaseURL_Dowload = 'https://content.dropboxapi.com/2/files/download';
  c_DropBox_BaseURL_DowloadShared= 'https://content.dropboxapi.com/2/sharing/get_shared_link_file';

  c_DropBox_BaseURL_Delete = 'https://api.dropboxapi.com/2/files/delete_v2'; //20190522 Igor

  c_DropBox_BaseURL_Shared_Add = 'https://api.dropboxapi.com/2/sharing/add_file_member';
  c_DropBox_BaseURL_Shared_link_metadata = 'https://api.dropboxapi.com/2/sharing/get_shared_link_metadata';
  c_DropBox_BaseURL_Search = 'https://api.dropboxapi.com/2/files/search_v2'; //20230314 Igor
  c_DropBox_ResourceURI = 'metadata/{ROOT}/{PATH}';
  c_DropBox_ResourceURI_Put = 'files_put/{ROOT}/{PATH}?{ACCES_TOKEN}={VALUE}';
  c_DropBox_ResourceURI_Get = 'files/{ROOT}/{PATH}?{ACCES_TOKEN}={VALUE}';
  c_DropBox_ResourceURI_CreateFolder = 'fileops/create_folder?root={ROOT}&path={PATH}&{ACCES_TOKEN}={VALUE}';

  c_AccessTokenEndpoint = //'https://api.dropbox.com/1/oauth2/token';
                          'https://api.dropboxapi.com/oauth2/token';



  c_AuthorizationEndpoint = 'https://www.dropbox.com/oauth2/authorize';


  //c_RedirectionEndpoint = 'https://www.visualtax.com/dropbox_endpoint.html';
  //c_RedirectionEndpoint = 'http://localhost';
  //c_RedirectionEndpoint = 'https://www.visualtax.com/dropbox_endpoint';
  c_RedirectionEndpoint = 'https://localhost:8765'; //20230314 Igor
  c_Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,';


  c_ROOT = 'auto';
  c_access_token = 'access_token';

  c_Authorization = 'Authorization';
  c_Bearer = 'Bearer ';
  c_AppFolder = 'vtCloud';
var
  dialog: string;


function MyEncode(AValue: String): String;
begin
  if AValue = '' then
    exit('');
  Result := StringReplace(TJSONString.Create(AValue).ToJSON, '\/', '/', [rfReplaceAll]);
  System.Delete(Result, 1, 1);
  System.Delete(Result, length(Result), 1);
end;

{ TDropBoxHelper }

constructor TDropBoxHelper.Create;
begin
  inherited Create;
  DoLog('Created');
  init;
  DoLog('Init complete');
end;

procedure TDropBoxHelper.Init;
begin
  //20180113 Igor >>>
  //20190307 Igor >>>
  {FLicenseKey := GetLicenseKeyFromFile(HELPER_NAME);
  if not ValidateKey(FLicenseKey) then
    FLicenseKey := '';}
  //20190307 Igor <<<
  //20180113 Igor <<<
  // MemData
  FMemData := TClientDataSet.Create(nil);
  // RESTResponseDataSetAdapter
  FRESTResponseDataSetAdapter := TRESTResponseDataSetAdapter.Create(nil);
  // RESTResponse
  FRESTResponse := TRESTResponse.Create(nil);
  // OAuth2_DropBox
  FOAuth2_DropBox := TOAuth2Authenticator.Create(nil);
  // RESTRequest
  FRESTRequest := TRESTRequest.Create(nil);
  // RESTClient

  FRESTClient := TRESTClient.Create(nil);
  // RESTResponseDataSetAdapter
  FRESTResponseDataSetAdapter.Dataset := FMemData;
  FRESTResponseDataSetAdapter.Response := FRESTResponse;
  // OAuth2_DropBox
  FOAuth2_DropBox.AccessTokenEndpoint := c_AccessTokenEndpoint;
  FOAuth2_DropBox.AuthorizationEndpoint := c_AuthorizationEndpoint;
  FOAuth2_DropBox.RedirectionEndpoint := c_RedirectionEndpoint;
  FOAuth2_DropBox.ResponseType := REST.Authenticator.OAuth.TOAuth2ResponseType.rtTOKEN;
  // RESTRequest

  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
  FRESTRequest.SynchronizedEvents := false;
  // RESTClient
  FRESTClient.Authenticator := FOAuth2_DropBox;
  FRESTClient.Accept := c_Accept;
  FRESTClient.HandleRedirects := True;
end;

function TDropBoxHelper.DeleteCloudFile: boolean; //20190522 Igor
begin
  Result := false; //20190522 Igor
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20230314 Igor >>>
  PrepareAccessToken;
  if FAccessToken.IsEmpty then Exit;
  //20230314 Igor <<<
  Result := DoDeleteCloudFile;
end;

function TDropBoxHelper.DeleteCloudFile(const ACloudPath, ACloudFile, ADropBoxClientId, //20190522 Igor
  AToken: string): boolean;
begin
  Result := false; //20190522 Igor
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  SetCloudPath(ACloudPath);
  SetCloudFile(ACloudFile);
  SetDropBoxClientId(c_VisualTaxDropBoxClientID{ADropBoxClientId}); //20230314 Igor
  FToken := AToken;
  Result := DeleteCloudFile;
end;

destructor TDropBoxHelper.Destroy;
begin
  FMemData.Free;
  FRESTResponseDataSetAdapter.Free;
  FRESTResponse.Free;
  FOAuth2_DropBox.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
  DoLog('Destroy');
  inherited;
end;

procedure TDropBoxHelper.DisableAdapter;
begin
  FRESTResponseDataSetAdapter.AutoUpdate := False;
  FRESTResponseDataSetAdapter.Active := False;
  FRESTResponseDataSetAdapter.RootElement := '';
  FRESTResponseDataSetAdapter.Dataset := nil;
end;

procedure TDropBoxHelper.AddParamAuthorization;
begin
  with FRESTRequest.Params.AddItem do
  begin
    name := c_Authorization;
    Value := c_Bearer + FAccessToken; //20230314 Igor
    ContentType := ctNone;
    Kind := pkHTTPHEADER;
    Options := [poDoNotEncode];
  end;
end;

function TDropBoxHelper.AllowExecuteOperation(AHelperAction: THelperAction): boolean; //20180113 Igor //20190306 Igor
begin
  //20190509 Igor >>>
  Result := true;
  Exit;
  //20190509 Igor <<<
  Result := false;
  if not HasLicenseKey then Exit;
  Result := (LicenseRec.Level = llStd) or (LicenseRec.Level = llDemo);
end;

function TDropBoxHelper.CheckDateDemo(AKey: string = ''): boolean; //20180113 Igor
begin
  if AKey = '' then
    AKey := FLicenseKey;
  Result := Date <= vtGetDemoDateExpiration(AKey, PgmLicenses);
end;

function TDropBoxHelper.CloudFolderExists: Boolean;
var
  json: TJSONObject;
  Path, query: String;
  I: Integer;
begin
  DoLog(Format('Start search Folder with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; DropBoxClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FDropBoxClientId, FToken]));
  if FToken = '' then
    Exit(False);
  ResetAll;
  DisableAdapter;

  FRESTClient.BaseURL := c_DropBox_BaseURL_Search;
  FRESTClient.ContentType := 'application/json';
  FRESTClient.Authenticator := nil;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.SynchronizedEvents := False;
  FRESTRequest.Params.Clear;
  AddParamAuthorization;
  json := TJSONObject.Create;
  try
    Path := '/apps/' + c_AppFolder + '/' + FCloudPath;
    Query := '';
    I := length(Path);
    while I > 0 do
    begin
      if Path[I] = '/' then
      begin
        Delete(Path, I, 1);
        break;
      end
      else
      begin
        Query := Path[I] + Query;
        Delete(Path, I, 1);
      end;
      dec(I);
    end;
    //20190610 Igor >>>
    if SameText(Query, 'Test') then
    begin
      Query := '';
      Path := '/apps/' + c_AppFolder + '/' + FCloudPath;
    end;
    //20190610 Igor <<<
    json.AddPair(TJSONPair.Create('path', TJSONString.Create(Path)));
    json.AddPair(TJSONPair.Create('query', TJSONString.Create(Query)));   // оставляем если даже пустой
    FRESTRequest.Body.ClearBody;
    FRESTRequest.Body.Add(json);
  finally
    json.free;
  end;
  try
    FRESTRequest.Execute;
  except
    on E: Exception do
    begin
      FAnswer := haOk;
      FLastError := E.Message; //20200224 Igor
      if Assigned(CallBackDialog) then
        CallBackDialog(self, hmtError, E.Message, FAnswer);
      Exit(False);
    end;
  end;
  json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
  try
    if json.Values['matches'] <> nil then
    begin
      if (json.Values['matches'] as TJSONArray).Count = 0 then
        Exit(False)
      else
        Exit(True);
    end
    else
    if json.Values['error_summary'] <> nil then
    begin
      FAnswer := haOk;
      FLastError := json.Values['error_summary'].Value; //20200224 Igor
      if Assigned(CallBackDialog) then
        CallBackDialog(self, hmtError, json.Values['error_summary'].Value, FAnswer);
      Exit(False);
    end
    else
    begin
      FAnswer := haOk;
      FLastError := 'Unknown error. Response Content: '+ #13#13 + FRestResponse.Content; //20200224 Igor
      if Assigned(CallBackDialog) then
        CallBackDialog(self, hmtError, 'Unknown error', FAnswer);
      Exit(False);
    end;
  finally
    json.Free;
  end;
end;

function TDropBoxHelper.CraftToken: boolean;
begin
  DoLog('Start Craft Token');
  FLastError := ''; //20230314 Igor
  wv := Tfrm_OAuthWebForm.Create(nil);
  try
    wv.OnAfterRedirect := self.OAuth2_DropBox_AccessTokenRedirect;
    wv.OnBeforeRedirect := self.OAuth2_DropBox_AccessTokenRedirect;
    //20190228 Igor >>>
    //wv.Browser.OnNavigateError := WebBrowser1NavigateError;
    wv.OnError := WebBrowserError;
    //20190228 Igor <<<
    wv.ShowModalWithURL(GenerateAuthorizeURL);
  finally
    wv.Free;
  end;
  Result := FToken <> '';
end;

procedure TDropBoxHelper.OAuth2_DropBox_AccessTokenRedirect(const AURL: string; var DoCloseWebView: boolean);
begin
  DoLog('AccessTokenRedirect. URL: '+AURL);
  //20230314 Igor >>>
  FLastError := '';
  DoCloseWebView := FindToken(AURL) or not FLastError.IsEmpty;
  //20230314 Igor <<<
  DoLog('FToken = ' + FToken);
end;

function TDropBoxHelper.PrepareAccessToken: boolean; //20230314 Igor
begin
  Result := false;
  if FToken = '' then
    if not CraftToken then
      Exit;
  if not TokensCache.ContainsKey(FToken) then
    RefreshAccessToken;
  if TokensCache.ContainsKey(FToken) then
  begin
    if Now > TokensCache.Items[FToken].Expiry then
      RefreshAccessToken;
    if TokensCache.Items[FToken].Expiry > Now then
    begin
      FAccessToken := TokensCache.Items[FToken].AccessToken;
      Result := true;
    end;
  end;
end;

procedure TDropBoxHelper.RefreshAccessToken; //20230314 Igor
var
  json: TJSONObject;
  lAccessToken: string;
  lExpiry: Integer;
begin
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTClient.BaseURL := c_AccessTokenEndpoint;
  FRESTClient.Authenticator := nil;
  FRESTRequest.Params.Clear;
  FRESTRequest.ClearBody;
  FRESTRequest.AddParameter('refresh_token', FToken, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('grant_type', 'refresh_token', TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('client_id', c_VisualTaxDropBoxClientID, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('client_secret', c_VisualTaxDropBoxClientSecret, TRESTRequestParameterKind.pkGETorPOST);
  try
    FRESTRequest.Execute;
  except
    on E: Exception do
    begin
      FAnswer := haOk;
      FLastError := E.Message;
      if Assigned(CallBackDialog) then
        CallBackDialog(self, hmtError, E.Message, FAnswer);
      Exit();
    end;
  end;
  json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
  try
    if Assigned(json.Values['error_description']) then
    begin
      FLastError := json.Values['error_description'].Value;
      if Assigned(CallBackDialog) then
        CallBackDialog(self, hmtError, FLastError, FAnswer);
      FToken := '';
    end
    else if Assigned(json.Values['access_token']) and
            Assigned(json.Values['expires_in']) then
    begin
      lAccessToken := json.Values['access_token'].Value;
      lExpiry := StrToIntDef(json.Values['expires_in'].Value, 0);
      TokensCache.AddTokens(FToken, lAccessToken, lExpiry);
    end
    else
    begin
      FLastError := 'Invalid json structure in refresh_token request:'+ sLineBreak + FRESTResponse.Content;
      if Assigned(CallBackDialog) then
        CallBackDialog(self, hmtError, FLastError, FAnswer);
      FToken := '';
    end;
  finally
    json.Free;
  end;
  if FToken = '' then
    CraftToken;
end;

procedure TDropBoxHelper.ResetAll;
begin
  FRESTClient.ResetToDefaults;
  FRESTClient.Params.Clear;
  FRESTClient.Authenticator := nil;

  FRESTRequest.ResetToDefaults;
  FRESTRequest.Params.Clear;
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
  FRESTRequest.SynchronizedEvents := False;

  FRESTResponse.ResetToDefaults;

  FRESTResponseDataSetAdapter.ResetToDefaults;
  FRESTResponseDataSetAdapter.Response := FRESTResponse;
  FRESTResponseDataSetAdapter.RootElement := '';
  FRESTResponseDataSetAdapter.DataSet := FMemData;

end;

//20190228 Igor >>>
{procedure TDropBoxHelper.WebBrowser1NavigateError(ASender: TObject; const pDisp: IDispatch; const URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
begin
  DoLog('NavigateError. URL: ' + URL);
  Cancel := True;
  if FindToken(URL) then
    wv.Close;
end;}

procedure TDropBoxHelper.WebBrowserError(const URL: string);
begin
  DoLog('Error. URL: ' + URL);
  if FindToken(URL) then
    wv.Close;
end;
//20190228 Igor <<<

function TDropBoxHelper.GenerateAuthorizeURL: string;
begin
  if FDropBoxClientId = '' then
    FDropBoxClientId := c_VisualTaxDropBoxClientID;

  //20230314 Igor >>>
  Result := c_AuthorizationEndpoint+
            '?client_id=' + URIEncode(FDropBoxClientId) +
            '&token_access_type=offline'+
            '&response_type=' + URIEncode('code') {+
            '&redirect_uri=' + URIEncode(c_RedirectionEndpoint)};
  //20230314 Igor <<<
end;


//public for User
function TDropBoxHelper.List: PChar;
var
  myList: TCloudFileList;
  Res: string;
begin
  Result := nil; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  //20230314 Igor >>>
  PrepareAccessToken;
  if FAccessToken.IsEmpty then Exit;
  //20230314 Igor <<<
  myList := DoDownloadList;
  try
    if Assigned(myList) then
    begin
     Res := vtCommonIntf.TCloudFileListToStr(myList);
     Result := PChar(Res);
    end
    else
      Result := nil;
  finally
    myList.Free;
  end;
end;

function TDropBoxHelper.List(const ACloudPath, ADropBoxClientId, AToken: String): PChar;
begin
  Result := nil; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  SetCloudPath(ACloudPath);
  SetDropBoxClientId(c_VisualTaxDropBoxClientID{ADropBoxClientId}); //20230314 Igor
  SetToken(AToken);
  Result := List;
end;

function TDropBoxHelper.ListReceived: PChar;
var
  myList: TCloudFileList;
  Res: string;
begin
  Result := nil; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  //20230314 Igor >>>
  PrepareAccessToken;
  if FAccessToken.IsEmpty then Exit;
  //20230314 Igor <<<
  myList := DoDownloadListReceived;
  try
    if Assigned(myList) then
    begin
     Res := vtCommonIntf.TCloudFileListToStr(myList);
     Result := PChar(Res);
    end
    else
      Result := nil;
  finally
    myList.Free;
  end;

end;

function TDropBoxHelper.ListReceived(ADropBoxClientId, AToken: String): PChar;
begin
  Result := nil; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  SetDropBoxClientId(c_VisualTaxDropBoxClientID{ADropBoxClientId}); //20230314 Igor
  SetToken(AToken);
  Result := ListReceived;
end;
(*
function TDropBoxHelper.MyExtractFileName(AFullPath: string): string;
begin
  Result := AfullPath;
  if Pos('/', Result) = 1 then
    Delete(Result, 1, 1);
  if pos(LowerCase(FCloudPath), LowerCase(Result)) = 1 then
    Delete(Result, 1, Length(FCloudPath));
  if Pos('/', Result) = 1 then
    Delete(Result, 1, 1);
end;
*)
function TDropBoxHelper.Send: boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haSaveToCloud) then Exit;
  //20180113 Igor <<<
  //20230314 Igor >>>
  PrepareAccessToken;
  if FAccessToken.IsEmpty then Exit;
  //20230314 Igor <<<
  Result := DoUpload;
end;

function TDropBoxHelper.Send(const ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId, AToken: string): boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haSaveToCloud) then Exit;
  //20180113 Igor <<<
  SetLocalFile(ALocalFile);
  SetCloudPath(ACloudPath);
  SetCloudFile(ACloudFile);
  SetDropBoxClientId(c_VisualTaxDropBoxClientID{ADropBoxClientId}); //20230314 Igor
  SetToken(AToken);
  Result := Send;
end;

procedure TDropBoxHelper.SetLicense(AKey: string); //20180113 Igor
begin
  //20190307 Igor >>>
  if AKey = '' then
    AKey := FLicenseKey
  else
    FLicenseKey := AKey;
  //20190307 Igor <<<
  LicenseRec := @PgmLicenses[0];
  while LicenseRec.Level <> llNone do
  begin
    if LeftStr(AKey, 4) = LicenseRec.Id then
      break; //found it
    inc(LicenseRec); //next record
  end;
end;

function TDropBoxHelper.SetShare(const AEmail, ACloudPath, ACloudFile, ADropBoxClientId, AToken: string): boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haSaveToCloud) then Exit;
  //20180113 Igor <<<
  SetEmail(AEmail);
  SetCloudPath(ACloudPath);
  SetCloudFile(ACloudFile);
  SetDropBoxClientId(c_VisualTaxDropBoxClientID{ADropBoxClientId}); //20230314 Igor
  FToken := AToken;
  Result := SetShare;
end;

function TDropBoxHelper.ValidateApp(AApp: string): boolean; //20190305 Igor
begin
  //20190509 Igor >>>
  Result := true;
  Exit;
  //20190509 Igor <<<
  Result := vtValidateApp(GetLicenseKey, AApp);
end;

function TDropBoxHelper.ValidateKey(AKey: string; AYear: integer): boolean; //20180113 Igor //20190307 Igor
begin
  //20190509 Igor >>>
  Result := true;
  Exit;
  //20190509 Igor <<<
  Result := (Length(AKey) = 24) and (Copy(AKey, 1, 2) = GetLicenseKeyPrefix);
  if not Result then
    exit;
  InitLicenseYear(AYear);
  Result := vtValidateKey(AKey, 'DB', PgmLicenses, F2_DROPBOX);
  SetLicense(AKey);
  FLicenseYear := AYear;
end;

function TDropBoxHelper.SetShare: boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haSaveToCloud) then Exit;
  //20180113 Igor <<<
  //20230314 Igor >>>
  PrepareAccessToken;
  if FAccessToken.IsEmpty then Exit;
  //20230314 Igor <<<
  Result := DoSetShare;
end;



function TDropBoxHelper.Get: boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  //20230314 Igor >>>
  PrepareAccessToken;
  if FAccessToken.IsEmpty then Exit;
  //20230314 Igor <<<
  Result := DoDownload;
end;

function TDropBoxHelper.Get(const ALocalFile, ACloudPath, ACloudFile, ADropBoxClientId, AToken: string): boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  SetLocalFile(ALocalFile);
  SetCloudPath(ACloudPath);
  SetCloudFile(ACloudFile);
  SetDropBoxClientId(c_VisualTaxDropBoxClientID{ADropBoxClientId}); //20230314 Igor
  FToken := AToken;
  Result := Get;
end;

function TDropBoxHelper.GetAllowedApps(AKey: string): string; //20190305 Igor
  procedure CheckApp(App: string);
  begin
    if not vtValidateApp(AKey, App) then Exit;
    if not Result.IsEmpty then
      Result := Result + ',';
    Result := Result + App;
  end;
begin
  Result := '';
  CheckApp('T1');
  CheckApp('T2');
  CheckApp('T3');
  CheckApp('T4T5');
  CheckApp('TF');
  CheckApp('FP');
end;

function TDropBoxHelper.GetLastError: string; //20200224 Igor
begin
  Result := FLastError;
end;

function TDropBoxHelper.GetLicenseData(AKey: string): PPgmLicenseData; //20180113 Igor
begin
  Result := LicenseRec;
end;

function TDropBoxHelper.GetLicenseDemoDate(AKey: string): TDateTime; //20180113 Igor
begin
  if AKey = '' then
    AKey := FLicenseKey;
  Result := vtGetDemoDateExpiration(AKey, PgmLicenses);
end;

function TDropBoxHelper.GetLicenseKey: string; //20180113 Igor
begin
  Result := FLicenseKey;
end;

function TDropBoxHelper.GetLicenseKeyPrefix: string; //20180113 Igor
begin
  Result := DROPBOX_LicenseKeyPrefix;
end;

function TDropBoxHelper.GetLicenses: PPgmLicenseData; //20180113 Igor
begin
  Result := @pgmLicenses;
end;

function TDropBoxHelper.GetRefreshTokenByCode(ACode: String): string; //20230314 Igor
var
  json: TJSONObject;
  lAccessToken, lRefreshToken: string;
  lExpiry: Integer;
begin
  Result := '';
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTClient.BaseURL := c_AccessTokenEndpoint;
  FRESTClient.Authenticator := nil;
  FRESTRequest.Params.Clear;
  FRESTRequest.ClearBody;

  FRESTRequest.AddParameter('code', ACode, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('grant_type', 'authorization_code', TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('client_id', c_VisualTaxDropBoxClientID, TRESTRequestParameterKind.pkGETorPOST);
  FRESTRequest.AddParameter('client_secret', c_VisualTaxDropBoxClientSecret, TRESTRequestParameterKind.pkGETorPOST);
  try
    FRESTRequest.Execute;
  except
    on E: Exception do
    begin
      FAnswer := haOk;
      FLastError := E.Message;
      if Assigned(CallBackDialog) then
        CallBackDialog(self, hmtError, E.Message, FAnswer);
      Exit();
    end;
  end;
  json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
  try
    if Assigned(json.Values['error_description']) then
    begin
      FLastError := json.Values['error_description'].Value;
      if Assigned(CallBackDialog) then
        CallBackDialog(self, hmtError, FLastError, FAnswer);
    end
    else if Assigned(json.Values['refresh_token']) and
            Assigned(json.Values['access_token']) and
            Assigned(json.Values['expires_in']) then
    begin
      lRefreshToken := json.Values['refresh_token'].Value;
      lAccessToken := json.Values['access_token'].Value;
      lExpiry := StrToIntDef(json.Values['expires_in'].Value, 0);
      TokensCache.AddTokens(lRefreshToken, lAccessToken, lExpiry);
      Result := lRefreshToken;
    end
    else
    begin
      FLastError := 'Invalid json structure in authorization_code request:'+ sLineBreak + FRESTResponse.Content;
      if Assigned(CallBackDialog) then
        CallBackDialog(self, hmtError, FLastError, FAnswer);
    end;
  finally
    json.Free;
  end;
end;

function TDropBoxHelper.GetShared: boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  //20230314 Igor >>>
  PrepareAccessToken;
  if FAccessToken.IsEmpty then Exit;
  //20230314 Igor <<<
  Result := DoDownloadShared;
end;

function TDropBoxHelper.GetShared(const ALocalFile, AUrlFile, ADropBoxClientId, AToken: string): boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  SetLocalFile(ALocalFile);
  SetUrlFile(AUrlFile);
  SetDropBoxClientId(c_VisualTaxDropBoxClientID{ADropBoxClientId}); //20230314 Igor
  FToken := AToken;
  Result := GetShared;
end;

function TDropBoxHelper.HasLicenseKey: boolean; //20180113 Igor
begin
  //20190509 Igor >>>
  Result := true;
  Exit;
  //20190509 Igor <<<
  Result := not SameStr(FLicenseKey, '') and CheckDateDemo;
end;

//private

function TDropBoxHelper.DoDownloadList(ACreatePathIfNotExists: Boolean = False): TCloudFileList;
var
  json, row: TJSONObject;
  arr: TJSONArray;
  has_more: Boolean;
  cursor: string;
  i: Integer;

  l_name, l_path, l_tag, l_Size, l_server_modified: string;
  ResultCreated: Boolean;

begin
  Result := nil;
  DoLog(Format('Start download list with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; DropBoxClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FDropBoxClientId, FToken]));
  if FToken = '' then
    Exit(nil);

  //if ACreatePathIfNotExists then
    DoCreateFolder;

  ResetAll;


  FRESTClient.BaseURL := c_DropBox_BaseURL_List;
  FRESTClient.Authenticator := nil;
  FRESTClient.ContentType := 'application/json';

  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.SynchronizedEvents := false;
  FRESTRequest.Params.Clear;
  AddParamAuthorization;
  json := TJSONObject.Create;
  try
    if FCloudPath='' then
      json.AddPair(TJSONPair.Create('path', '/apps/'+c_AppFolder))
    else
      json.AddPair(TJSONPair.Create('path', '/apps/'+c_AppFolder+'/'+FCloudPath));
    FRESTRequest.Body.ClearBody;
    FRESTRequest.Body.Add(json);
  finally
    json.Free;
  end;
  has_more := False;
  ResultCreated := False;
  repeat
    DisableAdapter;
    try
      FRESTRequest.Execute;
    except
      on E: Exception do
      begin
        FAnswer := haOk;
        FLastError := E.Message; //20200224 Igor
        if Assigned(CallBackDialog) then
          CallBackDialog(self, hmtError, E.Message, FAnswer);
        Exit(nil);
      end;
    end;
    json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
    try
      if json.Values['entries'] <> nil then
      begin
        cursor := json.Values['cursor'].Value;
        has_more := json.Values['has_more'].Value = 'true';
        if not ResultCreated then
        begin
          Result := TCloudFileList.Create(True);
          ResultCreated := True;
        end;
        arr := json.Values['entries'] as TJSONArray;
        for i := 0 to arr.Count - 1 do
        begin
          row := arr.Items[i] as TJSONObject;
          l_name := row.GetValue('name').Value;
          l_path := row.GetValue('path_display').Value;
          l_tag := row.GetValue('.tag').Value;
          if not sametext('folder', l_tag) then
          begin
            l_Size := row.GetValue('size').Value;
            l_server_modified :=row.GetValue('server_modified').Value;
          end;
          if l_Size = '' then
            l_Size := '0';
          if l_server_modified<>'' then                                                          //ISO8601ToDate(l_server_modified)
             Result.Add(TCloudFile.Create(l_name, l_path, l_tag = 'folder', l_Size.ToInteger, ISO8601ToDate(l_server_modified)))
          else
           Result.Add(TCloudFile.Create(l_name, l_path, l_tag = 'folder', l_Size.ToInteger, 0));
        end;
        if has_more then
        begin
          ResetAll;
          FRESTClient.BaseURL := c_DropBox_BaseURL_List_Continue;
          FRESTClient.Authenticator := nil;
          FRESTClient.ContentType := 'application/json';

          FRESTRequest.Method := TRESTRequestMethod.rmPOST;
          FRESTRequest.Params.Clear;
          AddParamAuthorization;
          json := TJSONObject.Create;
          json.AddPair(TJSONPair.Create('cursor', cursor));
          FRESTRequest.Body.ClearBody;
          FRESTRequest.Body.Add(json);
        end;
        FRESTResponseDataSetAdapter.RootElement := '';
      end
      else
      if json.Values['error_summary'] <> nil then
      begin
        FAnswer := haOk;
        FLastError := json.Values['error_summary'].Value; //20200224 Igor
        if Assigned(CallBackDialog) then
          CallBackDialog(self, hmtError, json.Values['error_summary'].Value, FAnswer);
        Exit(nil);
      end
      else
      begin
        FAnswer := haOk;
        FLastError := 'Unknown error. Response Content: '+ #13#13 + FRestResponse.Content; //20200224 Igor
        if Assigned(CallBackDialog) then
          CallBackDialog(self, hmtError, 'Unknown error', FAnswer);
        Exit(nil);
      end;
    finally
      json.Free;
    end;
  until not has_more;
end;

function TDropBoxHelper.DoDownloadListReceived(ACreatePathIfNotExists: Boolean): TCloudFileList;
type TSharedFolder = record
  shared_folder_id: string;
  preview_url: string;
  name: string;
end;

var
  json, row: TJSONObject;
  arr: TJSONArray;
  has_more: Boolean;
  cursor: string;
  i, j: Integer;

  l_name, l_url, l_path, l_tag, l_Size, l_server_modified: string;
  ResultCreated: Boolean;
  F: TCloudFile;
  SharedFolders: TList<TSharedFolder>;
  sf: TSharedFolder;
  SharedFiles: TCloudFileList;
begin

  Result := nil;
  DoLog(Format('Start download list with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; DropBoxClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FDropBoxClientId, FToken]));
  if FToken = '' then
    Exit(nil);

  if ACreatePathIfNotExists then
    DoCreateFolder;

  ResetAll;

  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.SynchronizedEvents := false;
  FRESTRequest.Params.Clear;
  FRESTClient.BaseURL := c_DropBox_BaseURL_ListReceived;
  FRESTClient.Authenticator := nil;
  FRESTClient.ContentType := 'application/json';
  AddParamAuthorization;
  json := TJSONObject.Create;
  try
   json.AddPair(TJSONPair.Create('limit', TJSONNumber.Create(100)));
   FRESTRequest.Body.ClearBody;
   FRESTRequest.Body.Add(json);
  finally
    json.Free;
  end;

  ResultCreated := False;
  has_more:=False;

  repeat
    DisableAdapter;
    try
      FRESTRequest.Execute;
    except
      on E: Exception do
      begin
        FAnswer := haOk;
        FLastError := E.Message; //20200224 Igor
        if Assigned(CallBackDialog) then
          CallBackDialog(self, hmtError, E.Message, FAnswer);
        Exit(nil);
      end;
    end;
    json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
    try
      if json.Values['entries'] <> nil then
      begin
        if json.Values['cursor']<>nil then
        begin
         cursor := json.Values['cursor'].Value;
         has_more:=True;

        end
        else
        begin
         cursor:='';
         has_more:=False;
        end;
        if not ResultCreated then
        begin
          Result := TCloudFileList.Create(True);
          ResultCreated := True;
        end;
        arr := json.Values['entries'] as TJSONArray;
        for i := 0 to arr.Count - 1 do
        begin
          row := arr.Items[i] as TJSONObject;
          l_name := row.GetValue('name').Value;
          l_url := row.GetValue('preview_url').Value;
          Result.Add(TCloudFile.Create(l_name, 'share' , False, 0, now,  l_url));
        end;
        if cursor<>'' then
        begin
          ResetAll;
          FRESTClient.BaseURL := c_DropBox_BaseURL_ListReceived_Continue;
          FRESTClient.Authenticator := nil;
          FRESTClient.ContentType := 'application/json';
          FRESTRequest.Method := TRESTRequestMethod.rmPOST;
          FRESTRequest.Params.Clear;
          AddParamAuthorization;
          json := TJSONObject.Create;
          json.AddPair(TJSONPair.Create('cursor', cursor));
          FRESTRequest.Body.ClearBody;
          FRESTRequest.Body.Add(json);
        end;
        FRESTResponseDataSetAdapter.RootElement := '';
      end
      else
      if json.Values['error_summary'] <> nil then
      begin
        FAnswer := haOk;
        FLastError := json.Values['error_summary'].Value; //20200224 Igor
        if Assigned(CallBackDialog) then
          CallBackDialog(self, hmtError, json.Values['error_summary'].Value, FAnswer);
        Exit(nil);
      end
      else
      begin
        FAnswer := haOk;
        FLastError := 'Unknown error. Response Content: '+ #13#13 + FRestResponse.Content; //20200224 Igor
        if Assigned(CallBackDialog) then
          CallBackDialog(self, hmtError, 'Unknown error', FAnswer);
        Exit(nil);
      end;
    finally
      json.Free;
    end;
  until not has_more;

  // shared folders
  ResetAll;

  SharedFolders := TList<TSharedFolder>.Create;
  SharedFiles := TCloudFileList.Create;
  try

    FRESTRequest.Method := TRESTRequestMethod.rmPOST;
    FRESTRequest.SynchronizedEvents := false;
    FRESTRequest.Params.Clear;
    FRESTClient.BaseURL := c_DropBox_BaseURL_List_SharedFolders;
    FRESTClient.Authenticator := nil;
    FRESTClient.ContentType := 'application/json';
    AddParamAuthorization;
    json := TJSONObject.Create;
    try
     json.AddPair(TJSONPair.Create('limit', TJSONNumber.Create(100)));
     FRESTRequest.Body.ClearBody;
     FRESTRequest.Body.Add(json);
    finally
      json.Free;
    end;

    has_more:=False;

    repeat
      DisableAdapter;
      try
        FRESTRequest.Execute;
      except
        on E: Exception do
        begin
          FAnswer := haOk;
          FLastError := 'Unknown error. Response Content: '+ #13#13 + FRestResponse.Content; //20200224 Igor
          if Assigned(CallBackDialog) then
            CallBackDialog(self, hmtError, E.Message, FAnswer);
          Exit(nil);
        end;
      end;
      json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
      try
        if json.Values['entries'] <> nil then
        begin
          if json.Values['cursor']<>nil then
          begin
           cursor := json.Values['cursor'].Value;
           has_more:=True;

          end
          else
          begin
           cursor:='';
           has_more:=False;
          end;
          arr := json.Values['entries'] as TJSONArray;
          for i := 0 to arr.Count - 1 do
          begin
            row := arr.Items[i] as TJSONObject;
            l_url := row.GetValue('preview_url').Value;
            sf.name := row.GetValue('name').Value;
            sf.preview_url := l_url;//.Replace('?dl=0', '');
            sf.shared_folder_id := row.GetValue('shared_folder_id').Value;
            SharedFolders.Add(sf);
          end;
          if cursor<>'' then
          begin
            ResetAll;
            FRESTClient.BaseURL := c_DropBox_BaseURL_List_SharedFolders_Continue;
            FRESTClient.Authenticator := nil;
            FRESTClient.ContentType := 'application/json';
            FRESTRequest.Method := TRESTRequestMethod.rmPOST;
            FRESTRequest.Params.Clear;
            AddParamAuthorization;
            json := TJSONObject.Create;
            json.AddPair(TJSONPair.Create('cursor', cursor));
            FRESTRequest.Body.ClearBody;
            FRESTRequest.Body.Add(json);
          end;
          FRESTResponseDataSetAdapter.RootElement := '';
        end
        else
        if json.Values['error_summary'] <> nil then
        begin
          FAnswer := haOk;
          FLastError := json.Values['error_summary'].Value; //20200224 Igor
          if Assigned(CallBackDialog) then
            CallBackDialog(self, hmtError, json.Values['error_summary'].Value, FAnswer);
          Exit(nil);
        end
        else
        begin
          FAnswer := haOk;
          FLastError := 'Unknown error. Response Content: '+ #13#13 + FRestResponse.Content; //20200224 Igor
          if Assigned(CallBackDialog) then
            CallBackDialog(self, hmtError, 'Unknown error', FAnswer);
          Exit(nil);
        end;
      finally
        json.Free;
      end;
    until not has_more;

    for j := 0 to SharedFolders.Count - 1 do
    begin
      ResetAll;

      FRESTClient.BaseURL := c_DropBox_BaseURL_List;
      FRESTClient.Authenticator := nil;
      FRESTClient.ContentType := 'application/json';

      FRESTRequest.Method := TRESTRequestMethod.rmPOST;
      FRESTRequest.SynchronizedEvents := false;
      FRESTRequest.Params.Clear;
      AddParamAuthorization;
      json := TJSONObject.Create;
      try
        json.AddPair(TJSONPair.Create('path', 'ns:'+ SharedFolders[j].shared_folder_id));
        FRESTRequest.Body.ClearBody;
        FRESTRequest.Body.Add(json);
      finally
        json.Free;
      end;
      has_more := False;
      repeat
        DisableAdapter;
        try
          FRESTRequest.Execute;
        except
          on E: Exception do
          begin
            FAnswer := haOk;
            FLastError := E.Message; //20200224 Igor
            if Assigned(CallBackDialog) then
              CallBackDialog(self, hmtError, E.Message, FAnswer);
            Exit(nil);
          end;
        end;
        json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
        try
          if json.Values['entries'] <> nil then
          begin
            cursor := json.Values['cursor'].Value;
            has_more := json.Values['has_more'].Value = 'true';
            if not ResultCreated then
            begin
              Result := TCloudFileList.Create(True);
              ResultCreated := True;
            end;
            arr := json.Values['entries'] as TJSONArray;
            for i := 0 to arr.Count - 1 do
            begin
              row := arr.Items[i] as TJSONObject;
              l_tag := row.GetValue('.tag').Value;
              if SameText(l_tag, 'folder') then continue;
              l_name := row.GetValue('name').Value;
              //l_url := row.GetValue('preview_url').Value;
              l_path := row.GetValue('path_display').Value;
              //20200218 Igor >>>    
              //SharedFiles.Add(TCloudFile.Create(l_name, l_path, False, 0, now,  SharedFolders[j].preview_url));
              Result.Add(TCloudFile.Create(SharedFolders[j].name + '\' + l_name, l_path, False, 0, now,  SharedFolders[j].preview_url + '~/' + l_name));
              //20200218 Igor <<<
            end;
            if has_more then
            begin
              ResetAll;
              FRESTClient.BaseURL := c_DropBox_BaseURL_List_Continue;
              FRESTClient.Authenticator := nil;
              FRESTClient.ContentType := 'application/json';

              FRESTRequest.Method := TRESTRequestMethod.rmPOST;
              FRESTRequest.Params.Clear;
              AddParamAuthorization;
              json := TJSONObject.Create;
              json.AddPair(TJSONPair.Create('cursor', cursor));
              FRESTRequest.Body.ClearBody;
              FRESTRequest.Body.Add(json);
            end;
            FRESTResponseDataSetAdapter.RootElement := '';
          end
          else
          if json.Values['error_summary'] <> nil then
          begin
            FAnswer := haOk;
            //20200217 Igor >>>
            if json.Values['error_summary'].Value.Contains('not_found') then
              continue;
            //20200217 Igor <<<
            FLastError := json.Values['error_summary'].Value; //20200224 Igor
            if Assigned(CallBackDialog) then
              CallBackDialog(self, hmtError, json.Values['error_summary'].Value, FAnswer);
            Exit(nil);
          end
          else
          begin
            FAnswer := haOk;
            FLastError := 'Unknown error. Response Content: '+ #13#13 + FRestResponse.Content; //20200224 Igor
            if Assigned(CallBackDialog) then
              CallBackDialog(self, hmtError, 'Unknown error', FAnswer);
            Exit(nil);
          end;
        finally
          json.Free;
        end;
      until not has_more;

    end;

    //20200218 Igor >>>
    {for F in SharedFiles do
    begin
      ResetAll;
      FRESTClient.BaseURL := c_DropBox_BaseURL_Shared_link_metadata;
      FRESTClient.Authenticator := nil;
      FRESTClient.ContentType := 'application/json';
      FRESTRequest.Method := TRESTRequestMethod.rmPOST;
      FRESTRequest.Params.Clear;
      AddParamAuthorization;
      json := TJSONObject.Create;
      try
        json.AddPair(TJSONPair.Create('url', f.Url));
        if f.Path <> 'share' then
          json.AddPair(TJSONPair.Create('path', '/' + f.Path));
        FRESTRequest.Body.ClearBody;
        FRESTRequest.Body.Add(json);
           try
            if F.Url<>'' then
            FRESTRequest.Execute;
          except
            on E: Exception do
            begin
              FAnswer := haOk;
              if Assigned(CallBackDialog) then
                CallBackDialog(self, hmtError, E.Message, FAnswer);
              Exit(nil);
            end;
          end;
      finally
        json.Free;
      end;
      if not FRESTResponse.Content.IsEmpty then
      begin
        json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
        try
          f.Url := json.Values['url'].Value + '~/' + f.Path;
          if json.Values['server_modified'] <> nil then
          begin
            if json.Values['server_modified']<>nil then           //ISO8601ToDate(l_server_modified)
            begin
             f.ServerModified := ISO8601ToDate( json.Values['server_modified'].Value, true);
            end ;
             if json.Values['size']<>nil then
            begin
             f.Size := StrToInt(json.Values['size'].Value);
            end;
          end
          else
          if json.Values['error_summary'] <> nil then
          begin
            FAnswer := haOk;
            if Assigned(CallBackDialog) then
              CallBackDialog(self, hmtError, json.Values['error_summary'].Value, FAnswer);
            Exit(nil);
          end
          else
          begin
            FAnswer := haOk;
            if Assigned(CallBackDialog) then
              CallBackDialog(self, hmtError, 'Unknown error', FAnswer);
            Exit(nil);
          end;
          Result.Add(TCloudFile.Create(F.Path, F.FullPath, F.IsDir, F.Size, F.ServerModified, F.Url));
        finally
          json.Free;
        end;
      end;
      FRESTResponseDataSetAdapter.RootElement := '';
    end;}
    //20200218 Igor <<<
  // shared_folders
  finally
    SharedFolders.Free;
    SharedFiles.Free;
  end;
end;



function TDropBoxHelper.DoDownloadShared: boolean;
var
  SomeStream: TMemoryStream;
  LUnZip: TZDecompressionStream;
  LOutput: TFileStream;
  AllowOverwrite: boolean;
  json, json2: TJSONObject;
  CloudSize: Int64;
  FPath: string;
begin
  DoLog(Format('Start Download with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; DropBoxClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FDropBoxClientId, FToken]));
  if FToken = '' then
    Exit(False);
  ResetAll;
  CloudSize := 0;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTClient.BaseURL := 'https://api.dropboxapi.com/2/sharing/get_shared_link_metadata';
  FRESTClient.Authenticator := nil;
  FRESTClient.ContentType := 'application/json';
  FRESTRequest.Params.Clear;
  FRESTRequest.ClearBody;
  AddParamAuthorization;
  FRESTResponseDataSetAdapter.DataSet:=nil;

  FPath := '';
  if Pos('~', FUrlFile) > 0 then
  begin
    FPath := Copy(FUrlFile, Pos('~', FUrlFile) + 1, Length(FUrlFile));
    FUrlFile := Copy(FUrlFile, 1, Pos('~', FUrlFile) - 1);
  end;
  json  := TJSONObject.Create;
  try
    json.AddPair('url', FUrlFile);
    if not FPath.IsEmpty then
      json.AddPair('path', FPath);
    FRESTRequest.Body.Add(json);
    FRESTRequest.Execute;
  finally
   json.Free;
  end;

  json2 := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
  try
    if json2.GetValue('size') <> nil then
    begin
      CloudSize := StrToInt64(json2.GetValue('size').Value);
    end;

     if json2.GetValue('server_modified') <> nil then
    begin
     Fl_server_modified  := ISO8601ToDate(json2.GetValue('server_modified').Value);
    end;
  finally
    json2.Free
  end;

    ResetAll;
    DisableAdapter;
    FRESTRequest.Method := TRESTRequestMethod.rmGet;
    FRESTClient.BaseURL :=  c_DropBox_BaseURL_DowloadShared;
    FRESTClient.Authenticator := nil;
    FRESTRequest.Params.Clear;
    FRESTRequest.ClearBody;
    AddParamAuthorization;

    with FRESTRequest.Params.AddItem do
    begin
      name := 'Dropbox-API-Arg';
      if FPath.IsEmpty then
        Value := '{"url":"'+FUrlFile+'"}'
      else
        Value := '{"url":"'+FUrlFile+'", "path":"'+FPath+'"}';
      ContentType := ctNone;
      Kind := pkHTTPHEADER;
      Options := [poDoNotEncode];
    end;

    repeat
      //download
      try
        FRESTRequest.Execute;
      except
        on E: Exception do
        begin
          FAnswer := haBreak;
          FLastError := E.Message; //20200224 Igor
          if Assigned(CallBackDownLoadError) then
            CallBackDownLoadError(self, E.Message, FCloudFile, FAnswer);
          case FAnswer of
            haRetry: Continue;
          else
            Exit(false);
          end;
        end;
      end;
     
      //check size

      if (CloudSize <> Length(FRESTResponse.RawBytes)) then
      begin
        FAnswer := haBreak;
        FLastError := 'Cloud and downloaded file sizes are not the same'; //20200224 Igor
        if Assigned(CallBackCheckBytesError) then
          CallBackCheckBytesError(self, '', FCloudFile, FAnswer);
        case FAnswer of
          haRetry: Continue;
        else
          Exit(false);
        end;
      end
      else
        break;
    until false;

    AllowOverwrite := false;
    repeat
      // check local file exists
      if not AllowOverwrite and FileExists(FLocalFile) then
      begin
        FAnswer := haOk;
        if Assigned(CallBackLocalFileExists) then
          CallBackLocalFileExists(self, '', FLocalFile, FAnswer);
        case FAnswer of
          haOk, haContinue: AllowOverwrite := true;
          haBreak: Exit(False);
          haRetry: Continue;
        end;
      end;

      //try save to localfile
      try
        SomeStream := TMemoryStream.Create;
        try
          SomeStream.WriteData(FRESTResponse.RawBytes, Length(FRESTResponse.RawBytes));
          LOutput := TFileStream.Create(FLocalFile, fmCreate);
          try
            SomeStream.Seek(0, soBeginning);
            try
              LUnZip := TZDecompressionStream.Create(SomeStream);
              try
                LOutput.CopyFrom(LUnZip, 0);
                dialog := 'Download complete.';
                Break;
              finally
                LUnZip.Free;
              end;
            except
              LOutput.CopyFrom(SomeStream, 0);
              dialog := 'Download complete.';
              Break;
            end;
          finally
            LOutput.Free;
          end;
        finally
          SomeStream.Free;
        end;
      except ON E: Exception do
        begin
          FAnswer := haBreak;
          FLastError := E.Message; //20200224 Igor
          if Assigned(CallBackSaveLocalFileError) then
            CallBackSaveLocalFileError(self, E.Message, FLocalFile, FAnswer);
          case FAnswer of
            haRetry: Continue;
          else
            Exit(false);
          end;
        end;
      end;
    Until false;

  FAnswer := haOk;
  if Assigned(CallBackDialog) then
    CallBackDialog(self, hmtInfo, dialog, FAnswer);
  Result := True;

end;

procedure TDropBoxHelper.DoLog(AEvent: String);
begin
  if Assigned(CallBackHelperLog) then
    CallBackHelperLog(Self, AEvent);
end;

function TDropBoxHelper.DoSetShare: boolean;
var
  json: TJSONObject;
begin
  DoLog(Format('Start Download with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; DropBoxClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FDropBoxClientId, FToken]));
  if FToken = '' then
    Exit(False);

  ResetAll;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTClient.BaseURL := c_DropBox_BaseURL_Shared_Add;
  FRESTClient.Authenticator := nil;
  FRESTClient.ContentType := 'application/json';
  FRESTRequest.Params.Clear;
  FRESTRequest.ClearBody;
  AddParamAuthorization;
  json  := TJSONObject.Create;
  try
    if FCloudPath='' then
      json.AddPair('file', '/apps/'+c_AppFolder+'/'+FCloudFile)
    else
      json.AddPair('file', '/apps/'+c_AppFolder+'/'+FCloudPath+'/'+FCloudFile);
    json.AddPair('members', TJSONArray.Create);
    (json.Values['members'] as TJSONArray).Add(TJSONObject.Create);
    ((json.Values['members'] as TJSONArray).Items[0] as TJSONObject).AddPair('.tag', 'email');
    ((json.Values['members'] as TJSONArray).Items[0] as TJSONObject).AddPair('email', FEmail);
    json.AddPair('access_level', TJSONObject.Create);
    (json.Values['access_level'] as TJSONObject).AddPair('.tag', 'viewer');
    FRESTRequest.Body.Add(json);
    try
      FRESTRequest.Execute;
      Result := True;
    except ON E: Exception DO
      begin
        Result := False;
        FLastError := E.Message; //20200224 Igor
        if Assigned(CallBackDialog) then
          CallBackDialog(self, hmtError, E.Message, FAnswer);
      end;
    end;
  finally
   json.Free;
  end;
end;

procedure TDropBoxHelper.DoCreateFolder;
var
  json: TJSONObject;
begin
  DoLog(Format('Start Create Folder with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; DropBoxClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FDropBoxClientId, FToken]));
  if FToken = '' then
    Exit;
  ResetAll;

  if {(FCloudPath='') or} CloudFolderExists then //20190228 Igor >>>
    Exit;

  DisableAdapter;

  FRESTClient.BaseURL := c_DropBox_BaseURL_CreateFolder;
  FRESTClient.ContentType := 'application/json';
  FRESTClient.Authenticator := nil;
  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTRequest.SynchronizedEvents := False;
  FRESTRequest.Params.Clear;
  AddParamAuthorization;
  json := TJSONObject.Create;
  try
    if FCloudPath='' then
      json.AddPair(TJSONPair.Create('path', '/apps/'+c_AppFolder))
    else
      json.AddPair(TJSONPair.Create('path', '/apps/'+c_AppFolder+'/'+FCloudPath));
    json.AddPair(TJSONPair.Create('autorename', TJSONBool.Create(false)));
    FRESTRequest.Body.ClearBody;
    FRESTRequest.Body.Add(json);
    try
      FRESTRequest.Execute;
    //20200224 Igor >>>
    except on E: Exception do
      FLastError := E.Message;      
    end;
    //20200224 Igor <<<
  finally
    json.free;
  end;

end;

function TDropBoxHelper.DoDownload: boolean;
var
  SomeStream: TMemoryStream;
  LUnZip: TZDecompressionStream;
  LOutput: TFileStream;
  AllowOverwrite: boolean;
  FileList: TCloudFileList;
  CloudFile: TCloudFile;
  json: TJSONObject;
begin
  DoLog(Format('Start Download with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; DropBoxClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FDropBoxClientId, FToken]));
  if FToken = '' then
    Exit(False);

  FileList := DoDownloadList;
  if not Assigned(FileList) then
    Exit(false);
  try
    repeat
      CloudFile := FileList.GetFileByPath(FCloudFile);
      if Assigned(CloudFile) then
        break
      else
      begin
        FAnswer := haBreak;
        FLastError := 'Cloud file "'+ FCloudFile + '" does not exist'; //20200224 Igor //20200305 Igor
        if Assigned(CallBackCloudFileNotExists) then
          CallBackCloudFileNotExists(self, '', FCloudFile, FAnswer);
        if FAnswer = haBreak then
          Exit(false);
      end;
    until false;

    ResetAll;


    FRESTRequest.Method := TRESTRequestMethod.rmGET;
    FRESTClient.BaseURL := c_DropBox_BaseURL_Dowload;
    FRESTClient.Authenticator := nil;
    FRESTRequest.Params.Clear;
    FRESTRequest.ClearBody;
    AddParamAuthorization;
    json  := TJSONObject.Create;

    try
      if True then
      if FCloudPath='' then
        json.AddPair('path', myEncode('/apps/'+c_AppFolder+'/'+FCloudFile))
      else
        json.AddPair('path', myEncode('/apps/'+c_AppFolder+'/'+FCloudPath+'/'+FCloudFile));

      with FRESTRequest.Params.AddItem do
      begin
        name := 'Dropbox-API-Arg';
        Value := json.ToString;
        ContentType := ctNone;
        Kind := pkHTTPHEADER;
        Options := [poDoNotEncode];
      end;

    finally
     json.Free;
    end;

    repeat
      //download
      try
        FRESTRequest.Execute;
      except
        on E: Exception do
        begin
          FAnswer := haBreak;
          FLastError := E.Message; //20200224 Igor
          if Assigned(CallBackDownLoadError) then
            CallBackDownLoadError(self, E.Message, FCloudFile, FAnswer);
          case FAnswer of
            haRetry: Continue;
          else
            Exit(false);
          end;
        end;
      end;
      //check size
      if (CloudFile.Size <> Length(FRESTResponse.RawBytes)) then
      begin
        FAnswer := haBreak;
        FLastError := 'Cloud and downloaded file sizes are not the same'; //20200224 Igor
        if Assigned(CallBackCheckBytesError) then
          CallBackCheckBytesError(self, '', FCloudFile, FAnswer);
        case FAnswer of
          haRetry: Continue;
        else
          Exit(false);
        end;
      end
      else
        break;
    until false;

    AllowOverwrite := false;
    repeat
      // check local file exists
      if not AllowOverwrite and FileExists(FLocalFile) then
      begin
        FAnswer := haOk;
        if Assigned(CallBackLocalFileExists) then
          CallBackLocalFileExists(self, '', FLocalFile, FAnswer);
        case FAnswer of
          haOk, haContinue: AllowOverwrite := true;
          haBreak: Exit(False);
          haRetry: Continue;
        end;
      end;

      //try save to localfile
      try
        SomeStream := TMemoryStream.Create;
        try
          SomeStream.WriteData(FRESTResponse.RawBytes, Length(FRESTResponse.RawBytes));
          LOutput := TFileStream.Create(FLocalFile, fmCreate);
          try
            SomeStream.Seek(0, soBeginning);
            //20190228 Igor >>>
            if (FRestResponse.RawBytes[0] = $78)
                and
               (FRestResponse.RawBytes[1] in [$01, $9C, $DA])  then
            begin
              // try to unzip content
              try
                LUnZip := TZDecompressionStream.Create(SomeStream);
                try
                  LOutput.CopyFrom(LUnZip, 0);
                  dialog := 'Download complete.';
                  Break;
                finally
                  LUnZip.Free;
                end;
              except
              end;
            end;
            // content is not zipped
            LOutput.CopyFrom(SomeStream, 0);
            dialog := 'Download complete.';
            break;
            //20190228 Igor <<<
          finally
            LOutput.Free;
          end;
        finally
          SomeStream.Free;
        end;
      except ON E: Exception do
        begin
          FAnswer := haBreak;
          FLastError := E.Message; //20200224 Igor
          if Assigned(CallBackSaveLocalFileError) then
            CallBackSaveLocalFileError(self, E.Message, FLocalFile, FAnswer);
          case FAnswer of
            haRetry: Continue;
          else
            Exit(false);
          end;
        end;
      end;
    Until false;
  finally
    FileList.free;
  end;
  FAnswer := haOk;
  if Assigned(CallBackDialog) then
    CallBackDialog(self, hmtInfo, dialog, FAnswer);
  Result := True;
end;

function TDropBoxHelper.DoUpload: boolean;
var
  local_filename: string;
  upload_stream: TFileStream;
  upload_stream_compresed: TMemoryStream;
  LZip: TZCompressionStream;
  CompressedSize, CloudSize: Int64;
  FileList: TCloudFileList;
  CloudFile: TCloudFile;
  json, jmode: TJSONObject;
begin
  DoLog(Format('Start Upload with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; DropBoxClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FDropBoxClientId, FToken]));
  if FToken = '' then
    Exit(False);
  FileList := DoDownloadList(True);
  if not Assigned(FileList) then
    Exit(false);
  CompressedSize := 0;
  try
    CloudFile := FileList.GetFileByPath(FCloudFile);
    if Assigned(CloudFile) then
    begin
      FAnswer := haContinue;
      FLastError := 'Cloud file "'+ FCloudFile +'" does not exists'; //20200224 Igor
      if Assigned(CallBackCloudFileExists) then
        CallBackCloudFileExists(Self, '', FCloudFile, FAnswer);
      case FAnswer of
        haBreak: Exit(False);
      end;
    end;
  finally
    FileList.Free;
  end;


  local_filename := ExtractFileName(FLocalFile);

  ResetAll;


  DisableAdapter;
  CloudSize := 0;

  FRESTRequest.Method := TRESTRequestMethod.rmPOST;
  FRESTClient.BaseURL := c_DropBox_BaseURL_Put;
  FRESTClient.Authenticator := nil;
  FRESTClient.ContentType := 'application/octet-stream';
  FRESTRequest.Params.Clear;
  FRESTRequest.ClearBody;
  AddParamAuthorization;
  json  := TJSONObject.Create;
  jmode := TJSONObject.Create;
  try
    if FCloudPath='' then
     json.AddPair('path', myEncode('/apps/'+c_AppFolder+'/'+FCloudFile))
    else
     json.AddPair('path', myEncode('/apps/'+c_AppFolder+'/'+FCloudPath+'/'+FCloudFile));

    jmode.AddPair('.tag', 'overwrite');
    json.AddPair('mode',  jmode as TJSONValue);
    with FRESTRequest.Params.AddItem do
    begin
      name := 'Dropbox-API-Arg';
      Value := json.ToString;
      ContentType := ctNone;
      Kind := pkHTTPHEADER;
      Options := [poDoNotEncode];
    end;

  finally
   json.Free;
  end;


  repeat
    //check file exists
    if not FileExists(FLocalFile) then
    begin
      FAnswer := haBreak;
      FLastError := 'Local file "'+ FLocalFile +'" does not exists'; //20200224 Igor
      if Assigned(CallBackLocalFileNotExists) then
          CallBackLocalFileNotExists(self, '', FLocalFile, FAnswer);
      case FAnswer of
        haRetry: Continue;
      else
        Exit(False);
      end;
    end;

    //try read file
    try
      upload_stream := TFileStream.Create(FLocalFile, fmOpenRead);
      try
        upload_stream_compresed := TMemoryStream.Create;
        try
          //Try Compress
          LZip := TZCompressionStream.Create(upload_stream_compresed);
          try
            LZip.CopyFrom(upload_stream, 0);
          finally
            LZip.Free;
          end;
          //20200430 Igor >>>
          //CompressedSize := upload_stream_compresed.Size;
          //FRESTRequest.AddBody(upload_stream_compresed, TRESTContentType.ctAPPLICATION_OCTET_STREAM);
          CompressedSize := upload_stream.Size;
          FRESTRequest.AddBody(upload_stream, TRESTContentType.ctAPPLICATION_OCTET_STREAM);
          //20200430 Igor <<<
          try
            // try upload
            FRESTRequest.Execute;
          except on E: Exception do
            begin
              FAnswer := haBreak;
              FLastError := E.Message; //20200224 Igor
              if Assigned(CallBackUpLoadError) then
                CallBackUpLoadError(self, E.Message, FCloudFile, FAnswer);
              case FAnswer of
                haRetry: Continue;
              else
                Exit(false);
              end;
            end;
          end;
          json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
          try
            if json.GetValue('size') <> nil then
            begin
              CloudSize := StrToInt64(json.GetValue('size').Value);
              Break;
            end
            else
            if json.GetValue('error_summary') <> nil then
            begin
              FAnswer := haBreak;
              FLastError := json.Values['error_summary'].Value; //20200224 Igor
              if Assigned(CallBackUpLoadError) then
                CallBackUpLoadError(self, json.GetValue('error_summary').Value, FLocalFile, FAnswer);
              case FAnswer of
                haRetry: Continue;
              else
                Exit(False);
              end;
            end
            else
            begin
              FAnswer := haBreak;
              FLastError := 'Unknown error. Response Content: '+ #13#13 + FRestResponse.Content; //20200224 Igor
              if Assigned(CallBackUpLoadError) then
                CallBackUpLoadError(self, 'Unknown error', FLocalFile, FAnswer);
              case FAnswer of
                haRetry: Continue;
              else
                Exit(False);
              end;
            end;
          finally
            json.Free;
          end;
        finally
          upload_stream_compresed.Free;
        end;
      finally
        upload_stream.Free;
      end;
    except ON E: Exception do
      begin
        FAnswer := haBreak;
        FLastError := E.Message; //20200224 Igor
        if Assigned(CallBackReadLocalFileError) then
          CallBackReadLocalFileError(self, E.Message, FLocalFile, FAnswer);
        case FAnswer of
          haRetry: Continue;
        else
          Exit(False);
        end;
      end;
    end;

    if CloudSize <> CompressedSize then
    begin
      FAnswer := haBreak;
      FLastError := 'Cloud and downloaded sizes are not the same'; //20200224 Igor
      if Assigned(CallBackCheckBytesError) then
        CallBackCheckBytesError(self, '', FCloudFile, FAnswer);
      case FAnswer of
        haRetry: Continue;
      else
        Exit(false);
      end;
    end;
    Break;
  until false;
  FAnswer := haOk;
  if Assigned(CallBackDialog) then
    CallBackDialog(self, hmtInfo, dialog, FAnswer);
  Result := True;

end;

function TDropBoxHelper.DoDeleteCloudFile: boolean; //20190522 Igor
var
  FileList: TCloudFileList;
  CloudFile: TCloudFile;
  json: TJSONObject;
begin
  DoLog(Format('Start Delete with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; DropBoxClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FDropBoxClientId, FToken]));
  if FToken = '' then
    Exit(False);

  FileList := DoDownloadList;
  if not Assigned(FileList) then
    Exit(false);
  try
    repeat
      CloudFile := FileList.GetFileByPath(FCloudFile);
      if Assigned(CloudFile) then
        break
      else
      begin
        FAnswer := haBreak;
        FLastError := 'Cloud file "'+ FCloudFile + '" does not exist'; //20200224 Igor
        if Assigned(CallBackCloudFileNotExists) then
          CallBackCloudFileNotExists(self, '', FCloudFile, FAnswer);
        if FAnswer = haBreak then
          Exit(false);
      end;
    until false;

    ResetAll;


    FRESTRequest.Method := TRESTRequestMethod.rmPOST;
    FRESTClient.BaseURL := c_DropBox_BaseURL_Delete;
    FRESTClient.Authenticator := nil;
    FRESTRequest.Params.Clear;
    FRESTRequest.ClearBody;
    AddParamAuthorization;
    json  := TJSONObject.Create;

    try
      if True then
      if FCloudPath='' then
        json.AddPair('path', myEncode('/apps/'+c_AppFolder+'/'+FCloudFile))
      else
        json.AddPair('path', myEncode('/apps/'+c_AppFolder+'/'+FCloudPath+'/'+FCloudFile));


      FRESTRequest.Body.ClearBody;
      FRESTRequest.Body.Add(json);
      {with FRESTRequest.Params.AddItem do
      begin
        name := 'Dropbox-API-Arg';
        Value := json.ToString;
        ContentType := ctNone;
        Kind := pkHTTPHEADER;
        Options := [poDoNotEncode];
      end;}

    finally
     json.Free;
    end;

    //delete
    try
      FRESTRequest.Execute;
    except
    end;

  finally
    FileList.free;
  end;
  FAnswer := haOk;
  if Assigned(CallBackDialog) then
    CallBackDialog(self, hmtInfo, dialog, FAnswer);
  Result := True;
end;

function TDropBoxHelper.FindToken(AURL: String): Boolean; //20230314 Igor
var
  LATPos: Integer;
  FCode: string;
begin
  DoLog('Find Token. URL: ' + AURL);
  LATPos := Pos('code=', AURL);
  if (LATPos > 0) then
  begin
    FCode := Copy(AURL, LATPos + 5, Length(AURL));
    if (Pos('&', FCode) > 0) then
      FCode := Copy(FCode, 1, Pos('&', FCode) - 1);
    if not SameStr(FPreviousCode, FCode) then
      FToken := GetRefreshTokenByCode(FCode);
    FPreviousCode := FCode;
  end;
  Result := (FToken <> '');
end;

{ TTokensCache }

procedure TTokensCache.AddTokens(ARefreshToken, AAccessToken: string; //20230314 Igor
  AExpiry: Integer);
var LTokenObj: TAccessToken;
begin
  if not ARefreshToken.IsEmpty and not AAccessToken.IsEmpty and (AExpiry > 0) then
  begin
    if not TryGetValue(ARefreshToken, LTokenObj) then
    begin
      LTokenObj := TAccessToken.Create;
      AddOrSetValue(ARefreshToken, LTokenObj);
    end;
    lTokenObj.AccessToken := AAccessToken;
    lTokenObj.Expiry := IncSecond(Now, AExpiry - 60 * 5); // if less than 5 minutes left to expiry, regenerate token
  end;
end;

destructor TTokensCache.Destroy; //20230314 Igor
var LTokenObj: TAccessToken;
begin
  for LTokenObj in Values do
    LTokenObj.Free;
  inherited;
end;

//20230314 Igor >>>
initialization
  TokensCache := TTokensCache.Create;

finalization
  FreeAndNil(TokensCache);
//20230314 Igor <<<

end.
