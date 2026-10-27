unit Worker;

interface
uses
  vtCommonIntf,  System.SysUtils,  System.Classes,  REST.Client,  REST.Authenticator.OAuth,
  OAuthWebForm, REST.Clouds, XSuperObject,
  IPPeerCommon, ippeerapi, IPPeerClient,
  IdMultipartFormData, IdCharsets,
  System.Threading, System.Types, System.UITypes,  System.ZLib,  System.StrUtils,
  System.Generics.Collections, System.NetEncoding, data.DB,
  MidasLib, System.DateUtils, vtLicense, GoogleDriveLicense;


type
{$region 'REST'}
  TResponseParent = record
    id: string;
  public
    constructor Create(const AParentID: string);
  end;

  TResponseMetadata = record
    id              : string;
    title           : string;
    ownedByMe       : Boolean;
    parents         : TArray<TResponseParent>;
    modifiedDate    : TDateTime;
    fileSize        : string;
  public
    class function FromJSon(const AJson: ISuperObject): TResponseMetadata; static;
    function ToJSon: ISuperObject;
  end;

//  'path': '/drive/v2/files',
//  'method': 'POST',
  TCreateMetadata = record
    mimeType : string; // "application/vnd.google-apps.folder";
    title    : string;
    parents  : TArray<TResponseParent>;
  public
    function ToJSon: ISuperObject;
  end;

  TPermissionMetadata = record
    role: string;
    &type: string;
    value: string;
  public
    function ToJSon: ISuperObject;
  end;

  TResponseList = record
    nextPageToken: string;
    nextLink     : string;
    incompleteSearch: Boolean;
    items        : TArray<TResponseMetadata>;
  public
    class function FromJSon(const AJson: ISuperObject): TResponseList; static;
  end;

{$endregion 'REST'}

  TGoogleDriveHelper = class(TCloudHelper)
  private
    FRest  : TRESTClient;
    FAnswer: THelperAnswer;
    FFolderInfo: TResponseMetadata;

    //20180113 Igor >>>
    FLicenseKey: string;
    LicenseRec: PPgmLicenseData;
    //20180113 Igor <<<
    FLicenseYear: integer; //20180307 Igor
    FLastError: string; //20200224 Igor

    function CraftToken: boolean;
    function DoSetShare: boolean;
    function GetPermissionId(AEmail: string): string;
    function DoUpload: boolean;
    function DoDownload: boolean;
    function DoDownloadShared: boolean;
    function DoDeleteCloudFile: boolean; //20190522 Igor
    function DoGetFileId(AFileName: string): string;
    function FileIdExists(AFileId: string): boolean;
    procedure DoUnDeleteCloudFile(AFileId: string);
    procedure DoCreateFolder;
    function DoDownloadList: TCloudFileList;
    function DoDownloadListReceived: TCloudFileList;
    function FolderExist (const AName, AParent: string; out AMetadata: TResponseMetadata): Boolean;
    procedure Init;
    function CloudFolderExists: Boolean;
    procedure DoLog(AEvent: String); //20161213 Igor
    function CheckDateDemo(AKey: string = ''): boolean; //20180113 Igor
    procedure UpdateTokens(AAccessToken, ARefreshToken: string);
    procedure InitTokens;
  public
    constructor Create; override;
    destructor Destroy; override;
    function Send: boolean; overload; override;
    function Send(const ALocalFile, ACloudPath, ACloudFile, AUrlFile, AClientId, AToken, ARefreshToken: string): boolean; overload; override;
    function Get: boolean; overload; override;
    function Get(const ALocalFile, ACloudPath, ACloudFile, AUrlFile, AClientId, AToken, ARefreshToken: string): boolean; overload; override;
    //20190522 Igor >>>
    function DeleteCloudFile: boolean; overload; override;
    function DeleteCloudFile(const ACloudPath, ACloudFile, AUrlFile, AClientId, AToken, ARefreshToken: string): boolean; overload; override;
    //20190522 Igor <<<
    function SetShare: boolean; overload; override;
    function SetShare(const AEmail, ACloudPath, ACloudFile, AUrlFile, AClientId, AToken, ARefreshToken: string): boolean; overload; override;
    function GetShared: boolean; overload; override;
    function GetShared(const ALocalFile, AUrlFile, AClientId, AToken, ARefreshToken: string): boolean; overload; override;
    function List: PChar; overload; override;
    function List(const ACloudPath, AClientId, AToken, ARefreshToken: string): PChar; overload; override;
    function ListReceived: PChar; overload; override;
    function ListReceived(AClientId, AToken, ARefreshToken: String): PChar; overload; override;
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
  //c_VisualTaxGoogleDriveClientID =  'g7rtsx5fpvec4x8';
  //c_VisualTaxGoogleDriveClientID =  '655376877694-6oodsrnhfa1ucm1jlo1legfn7rk3shru.apps.googleusercontent.com';
  c_VisualTaxGoogleDriveClientID =  '310107706077-c0j47q5a2fg9brtf8ddasmbricrvalvq.apps.googleusercontent.com';
  CS_Client_ID = c_VisualTaxGoogleDriveClientID;
//  c_ClientSecret                 = 'fojrbwGuJJRrw7brYAZwPN23';
  c_ClientSecret                 = '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';
  CS_CLIENT_SECRET_SCOPE = c_ClientSecret;


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

implementation

const
  CS_BASEURL = 'https://www.googleapis.com/drive/v2/';
  CS_UPLOADURL = 'https://www.googleapis.com/upload/drive/v2/';

  CS_ACCESS_SCOPE = 'https://www.googleapis.com/auth/drive';
  //CS_REDIRECT_URI = 'urn:ietf:wg:oauth:2.0:oob';
  CS_REDIRECT_URI = 'http://localhost:8765';
  CS_AUTHORIZATION_ENDPOINT = 'https://accounts.google.com/o/oauth2/auth';
  CS_TOKEN_ENDPOINT = 'https://accounts.google.com/o/oauth2/token';
  
  CS_COMMAND_LIST = 'files';
  CS_COMAND_FILE = 'files/%s';
  CS_COMAND_TO_TRASH = 'files/%s/trash';
  CS_COMAND_UNTRASH = 'files/%s/untrash';
  CS_COMAND_INSERT_PERMISSION = 'files/%s/permissions';
  CS_COMAND_GET_PERMISSION_ID = 'permissionIds/%s';
  CS_COMAND_GET_PERMISSIONS = 'files/%s/permissions/%s';

  CS_COMAND_PATCH = 'files/%s'; // PATCH  /files/fileId
  CS_COMAND_PATCH_METADATA_MOVE = 'files/%s?addParents=%s&removeParents=%s'; // PATCH  /files/fileId?addParents=ComsList&removeParents=ComsList'

  CS_PARAMS_SEARCH_FROM_PARENT = '''%0:s'' in parents and title = ''%1:s'' and ';
  CS_PARAMS_SEARCH_FOLDERS = 'mimeType = ''application/vnd.google-apps.folder'''; //?q=
  CS_PARAMS_FIELDS_FOLDERS = 'items(title,thumbnailLink,parents/id,ownedByMe,labels/trashed,id,iconLink),nextPageToken';

  CS_PARAMS_SEARCH_FILES = '(trashed = false) and (mimeType != ''application/vnd.google-apps.folder'') and (mimeType != ''application/vnd.google-apps.document'') and (mimeType != ''application/vnd.google-apps.spreadsheet'')';
  CS_PARAMS_SEARCH_SHARED_FILES = 'sharedWithMe and (trashed = false) and (mimeType != ''application/vnd.google-apps.folder'') and (mimeType != ''application/vnd.google-apps.document'') and (mimeType != ''application/vnd.google-apps.spreadsheet'')';
  CS_PARAMS_FIELDS_FILES = 'items(id,title,parents/id,ownedByMe,originalFilename,modifiedDate,labels/trashed,fileSize),nextPageToken';

  c_AppFolder = 'vtCloud';
var
  dialog: string;


function MyEncode(AValue: String): String;
begin
  if AValue = '' then
    exit('');
  //Result := StringReplace(TJSONString.Create(AValue).ToJSON, '\/', '/', [rfReplaceAll]);
  System.Delete(Result, 1, 1);
  System.Delete(Result, length(Result), 1);
end;

{ TDropBoxHelper }

constructor TGoogleDriveHelper.Create;
begin
  inherited Create;
  FLastError := '';
  DoLog('Created');
  init;
  DoLog('Init complete');
end;

procedure TGoogleDriveHelper.Init;
begin
  FRest    := TRESTClient.Create;
  FRest.AuthorizeParams.Values['AuthorizationEndpoint'] := CS_AUTHORIZATION_ENDPOINT;
  FRest.AuthorizeParams.Values['AccessTokenEndpoint']   := CS_TOKEN_ENDPOINT;
  FRest.AuthorizeParams.Values['RedirectionEndpoint']   := CS_REDIRECT_URI;
  FRest.AuthorizeParams.Values['Scope']                 := CS_ACCESS_SCOPE;
  FRest.AuthorizeParams.Values['ClientID']              := CS_Client_ID;
  FRest.AuthorizeParams.Values['ClientSecret']          := CS_CLIENT_SECRET_SCOPE;
  FRest.AuthorizeParams.Values['ResponseType']          := TOAuth2ResponseType.rtCODE.ToString;
  FRest.UpdateTokens := UpdateTokens;

//  FOAuth2 := TOAuth2Authenticator.Create(nil);
//  FOAuth2.AccessTokenEndpoint   := c_AccessTokenEndpoint;
//  FOAuth2.AuthorizationEndpoint := c_AuthorizationEndpoint;
//  FOAuth2.ResponseType := REST.Authenticator.OAuth.TOAuth2ResponseType.rtCODE;
//  FOAuth2.Scope := CS_ACCESS_SCOPE;
//  FOAuth2.RedirectionEndpoint := CS_REDIRECT_URI;
//  FOAuth2.ClientSecret :=     c_ClientSecret;
end;

procedure TGoogleDriveHelper.InitTokens;
begin
  FRest.AccessToken := FToken;
  FRest.RefreshToken := FRefreshToken;
end;

function TGoogleDriveHelper.DeleteCloudFile: boolean; //20190522 Igor
begin
  Result := false; //20190522 Igor
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  if FToken = '' then
    if not CraftToken then
      Exit(false);
  Result := DoDeleteCloudFile;
end;

function TGoogleDriveHelper.DeleteCloudFile(const ACloudPath, ACloudFile, AUrlFile, AClientId, //20190522 Igor
  AToken, ARefreshToken: string): boolean;
begin
  Result := false; //20190522 Igor
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  SetCloudPath(ACloudPath);
  SetCloudFile(ACloudFile);
  SetUrlFile(AUrlFile);
  SetClientId(AClientId);
  SetToken(AToken);
  SetRefreshToken(ARefreshToken);
  InitTokens;
  Result := DeleteCloudFile;
end;

destructor TGoogleDriveHelper.Destroy;
begin
//  FMemData.Free;
//  FRESTResponseDataSetAdapter.Free;
//  FRESTResponse.Free;
//  FOAuth2.Free;
//  FRESTRequest.Free;
//  FRESTClient.Free;
  DoLog('Destroy');
  inherited;
end;

function TGoogleDriveHelper.AllowExecuteOperation(AHelperAction: THelperAction): boolean; //20180113 Igor //20190306 Igor
begin
  //20190509 Igor >>>
  Result := true;
  Exit;
  //20190509 Igor <<<
  Result := false;
  if not HasLicenseKey then Exit;
  Result := (LicenseRec.Level = llStd) or (LicenseRec.Level = llDemo);
end;

function TGoogleDriveHelper.CheckDateDemo(AKey: string = ''): boolean; //20180113 Igor
begin
  if AKey = '' then
    AKey := FLicenseKey;
  Result := Date <= vtGetDemoDateExpiration(AKey, PgmLicenses);
end;

function TGoogleDriveHelper.CloudFolderExists: Boolean;
var
  Path: string;
  LFolders: TArray<string>;
  LFolder, LParent : string;
  LMetadata: TResponseMetadata;
begin
  DoLog(Format('Start search Folder with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; ClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FClientId, FToken]));

  Result := False;
  if (FToken = '') then Exit;
  Exit;

  Path := '/apps/' + c_AppFolder + '/' + FCloudPath;
  LFolders := Path.Split(['/'], TStringSplitOptions.ExcludeEmpty);
  LParent := 'root';
  for LFolder in LFolders do
  begin
    if not FolderExist(LFolder, LParent, LMetadata) then
      Exit;
    LParent := LMetadata.id;
  end;
  FFolderInfo := LMetadata;
  Result := True;
end;

function TGoogleDriveHelper.CraftToken: boolean;
begin
  DoLog('Start Craft Token');
  Result := FRest.Authorize();
  if (Result) then
  begin
    FToken := FRest.AccessToken;
    FRefreshToken := FRest.RefreshToken;
  end;
(*
  wv := Tfrm_OAuthWebForm.Create(nil);
  try
    wv.OnAfterRedirect := self.OAuth2_DropBox_AccessTokenRedirect;
    wv.OnBeforeRedirect := self.OAuth2_DropBox_AccessTokenRedirect;
    wv.OnTitleChanged := OAuth2_GoogleDrive_BrowserTitleChanged;
    //20190228 Igor >>>
    //wv.Browser.OnNavigateError := WebBrowser1NavigateError;
    wv.OnError := WebBrowserError;
    //20190228 Igor <<<
    wv.ShowModalWithURL(GenerateAuthorizeURL);
  finally
    wv.Free;
  end;
  Result := FToken <> '';
*)
end;

//public for User
function TGoogleDriveHelper.List: PChar;
var
  myList: TCloudFileList;
  Res: string;
begin
  Result := nil; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  if (FToken = '') AND not CraftToken then
    Exit(nil);
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

function TGoogleDriveHelper.List(const ACloudPath, AClientId, AToken, ARefreshToken: String): PChar;
begin
  Result := nil; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  SetCloudPath(ACloudPath);
  SetClientId(AClientId);
  SetToken(AToken);
  SetRefreshToken(ARefreshToken);
  InitTokens;
  Result := List;
end;

function TGoogleDriveHelper.ListReceived: PChar;
var
  myList: TCloudFileList;
  Res: string;
begin
  Result := nil; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  if (FToken = '') AND not CraftToken then
    Exit(nil);
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

function TGoogleDriveHelper.ListReceived(AClientId, AToken, ARefreshToken: String): PChar;
begin
  Result := nil; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  SetClientId(AClientId);
  SetToken(AToken);
  SetRefreshToken(ARefreshToken);
  InitTokens;
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
function TGoogleDriveHelper.Send: boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haSaveToCloud) then Exit;
  //20180113 Igor <<<
  if FToken = '' then
    if not CraftToken then
      Exit(false);
  Result := DoUpload;
end;

function TGoogleDriveHelper.Send(const ALocalFile, ACloudPath, ACloudFile, AUrlFile, AClientId, AToken, ARefreshToken: string): boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haSaveToCloud) then Exit;
  //20180113 Igor <<<
  SetLocalFile(ALocalFile);
  SetCloudPath(ACloudPath);
  SetCloudFile(ACloudFile);
  SetUrlFile(AUrlFile);
  SetClientId(AClientId);
  SetToken(AToken);
  SetRefreshToken(ARefreshToken);
  InitTokens;
  Result := Send;
end;

procedure TGoogleDriveHelper.SetLicense(AKey: string); //20180113 Igor
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

function TGoogleDriveHelper.SetShare(const AEmail, ACloudPath, ACloudFile, AUrlFile, AClientId, AToken, ARefreshToken: string): boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haSaveToCloud) then Exit;
  //20180113 Igor <<<
  SetEmail(AEmail);
  SetCloudPath(ACloudPath);
  SetCloudFile(ACloudFile);
  SetUrlFile(AUrlFile);
  SetClientId(AClientId);
  SetToken(AToken);
  SetRefreshToken(ARefreshToken);
  InitTokens;
  Result := SetShare;
end;

procedure TGoogleDriveHelper.UpdateTokens(AAccessToken, ARefreshToken: string);
begin
  FToken := AAccessToken;
  FRefreshToken := ARefreshToken;
end;

function TGoogleDriveHelper.ValidateApp(AApp: string): boolean; //20190305 Igor
begin
  //20190509 Igor >>>
  Result := true;
  Exit;
  //20190509 Igor <<<
  Result := vtValidateApp(GetLicenseKey, AApp);
end;

function TGoogleDriveHelper.ValidateKey(AKey: string; AYear: integer): boolean; //20180113 Igor //20190307 Igor
begin
  //20190509 Igor >>>
  Result := true;
  Exit;
  //20190509 Igor <<<
  Result := (Length(AKey) = 24) and (Copy(AKey, 1, 2) = GetLicenseKeyPrefix);
  if not Result then
    exit;
  InitLicenseYear(AYear);
  Result := vtValidateKey(AKey, 'GD', PgmLicenses, F2_GoogleDrive);
  SetLicense(AKey);
  FLicenseYear := AYear;
end;

function TGoogleDriveHelper.SetShare: boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haSaveToCloud) then Exit;
  //20180113 Igor <<<
  if FToken = '' then
    if not CraftToken then
      Exit(false);
  Result := DoSetShare;
end;



function TGoogleDriveHelper.Get: boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  if FToken = '' then
    if not CraftToken then
      Exit(false);
  Result := DoDownload;
end;

function TGoogleDriveHelper.Get(const ALocalFile, ACloudPath, ACloudFile, AUrlFile, AClientId, AToken, ARefreshToken: string): boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  SetLocalFile(ALocalFile);
  SetCloudPath(ACloudPath);
  SetCloudFile(ACloudFile);
  SetUrlFile(AUrlFile);
  SetClientId(AClientId);
  SetToken(AToken);
  SetRefreshToken(ARefreshToken);
  InitTokens;
  Result := Get;
end;

function TGoogleDriveHelper.GetAllowedApps(AKey: string): string; //20190305 Igor
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

function TGoogleDriveHelper.GetLastError: string;
begin
  Result := FLastError;
end;

function TGoogleDriveHelper.GetLicenseData(AKey: string): PPgmLicenseData; //20180113 Igor
begin
  Result := LicenseRec;
end;

function TGoogleDriveHelper.GetLicenseDemoDate(AKey: string): TDateTime; //20180113 Igor
begin
  if AKey = '' then
    AKey := FLicenseKey;
  Result := vtGetDemoDateExpiration(AKey, PgmLicenses);
end;

function TGoogleDriveHelper.GetLicenseKey: string; //20180113 Igor
begin
  Result := FLicenseKey;
end;

function TGoogleDriveHelper.GetLicenseKeyPrefix: string; //20180113 Igor
begin
  Result := GoogleDrive_LicenseKeyPrefix;
end;

function TGoogleDriveHelper.GetLicenses: PPgmLicenseData; //20180113 Igor
begin
  Result := @pgmLicenses;
end;

function TGoogleDriveHelper.GetPermissionId(AEmail: string): string;
var LCommand : TRESTClient.TURI;
    LOutJson : ISuperObject;
begin
  Result := '';
  LCommand := CS_BASEURL;
  LCommand.AddPath(string.Format(CS_COMAND_GET_PERMISSION_ID, [FEmail]));
  if FRest.&Do(TRESTClient.TMethod.GET, LCommand, nil, LOutJson) = 200 then
    Result := LOutJson.S['id'];
end;

function TGoogleDriveHelper.GetShared: boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  if FToken = '' then
    if not CraftToken then
      Exit(false);
  Result := DoDownloadShared;
end;

function TGoogleDriveHelper.GetShared(const ALocalFile, AUrlFile, AClientId, AToken, ARefreshToken: string): boolean;
begin
  Result := false; //20190522 Igor
  //20180113 Igor >>>
  if not HasLicenseKey then Exit;
  if not AllowExecuteOperation(haLoadFromCloud) then Exit;
  //20180113 Igor <<<
  SetLocalFile(ALocalFile);
  SetUrlFile(AUrlFile);
  SetClientId(AClientId);
  SetToken(AToken);
  SetRefreshToken(ARefreshToken);
  InitTokens;
  Result := GetShared;
end;

function TGoogleDriveHelper.HasLicenseKey: boolean; //20180113 Igor
begin
  //20190509 Igor >>>
  Result := true;
  Exit;
  //20190509 Igor <<<
  Result := not SameStr(FLicenseKey, '') and CheckDateDemo;
end;

//private

function TGoogleDriveHelper.DoDownloadList: TCloudFileList;
var
  LResponse: TResponseList;
  LMetadata: TResponseMetadata;
  LOutJson : ISuperObject;
  LCommand : TRESTClient.TURI;
  LResult  : Boolean;
begin
  Result := nil;
  DoLog(Format('Start download list with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; ClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FClientId, FToken]));
  if FToken = '' then
    Exit;

  DoCreateFolder;

  LCommand := CS_BASEURL;
  LCommand.AddPath(CS_COMMAND_LIST);
  LCommand.AddParam('fields', CS_PARAMS_FIELDS_FILES);
  LCommand.AddParam('maxResults', IntToStr(10000));
  LCommand.SetParam('q', string.Format('''%0:s'' in parents and ', [FFolderInfo.id]) + CS_PARAMS_SEARCH_FILES);

  repeat
    LResult := ( FRest.&Do(TRESTClient.TMethod.GET, LCommand, nil, LOutJson) = 200 );
    if ( not LResult ) then
      Break;
    LResponse := TResponseList.FromJSon(LOutJson);
    if (Result = nil) then
      Result := TCloudFileList.Create(True);

    for LMetadata in LResponse.items do
    begin
      Result.Add(TCloudFile.Create(LMetadata.title, LMetadata.title, false, StrToIntDef(LMetadata.fileSize, 0), LMetadata.modifiedDate, LMetadata.id));
    end;
    LCommand.SetParam('pageToken', LResponse.nextPageToken);

  until (LResponse.nextPageToken.IsEmpty);

(*
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
    finally
      json.Free;
    end;
  until not has_more;
*)
end;

function TGoogleDriveHelper.DoDownloadListReceived: TCloudFileList;
var
  LResponse: TResponseList;
  LMetadata: TResponseMetadata;
  LOutJson : ISuperObject;
  LCommand : TRESTClient.TURI;
  LResult  : Boolean;
begin
  Result := nil;
  DoLog(Format('Start download list shared with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; ClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FClientId, FToken]));
  if FToken = '' then
    Exit;

  LCommand := CS_BASEURL;
  LCommand.AddPath(CS_COMMAND_LIST);
  LCommand.AddParam('fields', CS_PARAMS_FIELDS_FILES);
  LCommand.AddParam('maxResults', IntToStr(10000));
  LCommand.SetParam('q', CS_PARAMS_SEARCH_SHARED_FILES);

  repeat
    LResult := ( FRest.&Do(TRESTClient.TMethod.GET, LCommand, nil, LOutJson) = 200 );
    if ( not LResult ) then
      Break;
    LResponse := TResponseList.FromJSon(LOutJson);
    if (Result = nil) then
      Result := TCloudFileList.Create(True);

    for LMetadata in LResponse.items do
    begin
      Result.Add(TCloudFile.Create(LMetadata.title, LMetadata.title, false, StrToIntDef(LMetadata.fileSize, 0), LMetadata.modifiedDate, LMetadata.id));
    end;
    LCommand.SetParam('pageToken', LResponse.nextPageToken);

  until (LResponse.nextPageToken.IsEmpty);
(*

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
    finally
      json.Free;
    end;
  until not has_more;

  for F in Result do
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
     json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
    try
      if json.Values['server_modified'] <> nil then
      begin
        if json.Values['server_modified']<>nil then           //ISO8601ToDate(l_server_modified)
        begin
         f.ServerModified := ISO8601ToDate( json.Values['server_modified'].Value, true);
        end ;
         if json.Values['size']<>nil then
        begin
         f.Size := StrToInt(json.Values['size'].Value);
        end

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
    finally
      json.Free;
    end;
     FRESTResponseDataSetAdapter.RootElement := '';
  end;
*)
end;



function TGoogleDriveHelper.DoDownloadShared: boolean;
var
  SomeStream: TMemoryStream;
  LUnZip: TZDecompressionStream;
  LOutput: TFileStream;
  AllowOverwrite: boolean;
  LOutJson : ISuperObject;
  LCommand : TRESTClient.TURI;
  LResult  : Integer;
  LBuf     : TBytes;
  LFileSize: Int64;
begin
  Result := false;
  DoLog(Format('Start Download Shared with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; ClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FClientId, FToken]));
  if FToken = '' then
    Exit(False);

  LCommand := CS_BASEURL;
  LCommand.AddPath(string.Format(CS_COMAND_FILE, [FUrlFile]));
  LResult := FRest.DoStream(TRESTClient.TMethod.GET, LCommand, nil, LOutJson);
  if LResult = 200 then
    LFileSize := StrToIntDef(LOutJson.S['fileSize'], 0)
  else
  begin
    FLastError := 'File with Id = '+ QuotedStr(FUrlFIle) + ' was not found on Google Drive';
    Exit;
  end;

  SomeStream := TMemoryStream.Create;
  try
    repeat
      //download
      try
        SomeStream.Clear;
        LCommand := CS_BASEURL;
        LCommand.AddPath(string.Format(CS_COMAND_FILE, [FUrlFile]) + '?alt=media&source=downloadUrl');
        LResult := FRest.DoStream(TRESTClient.TMethod.GET, LCommand, SomeStream);
      except
        on E: Exception do
        begin
          FAnswer := haBreak;
          if Assigned(CallBackDownLoadError) then
            CallBackDownLoadError(self, E.Message, FCloudFile, FAnswer);
          case FAnswer of
            haRetry: Continue;
          else
            Exit(false);
          end;
        end;
      end;
      //check LResult
      if LResult <> 200 then
      begin
        FAnswer := haBreak;
        if Assigned(CallBackDownLoadError) then
          CallBackDownLoadError(self, 'Error '+ IntToStr(LResult) + ' occured', FCloudFile, FAnswer);
        case FAnswer of
          haRetry: Continue;
        else
          Exit(false);
        end;
      end;
      //check size
      if (LFileSize <> SomeStream.Size) then
      begin
        FAnswer := haBreak;
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
        LOutput := TFileStream.Create(FLocalFile, fmCreate);
        try
          SomeStream.Seek(0, soBeginning);
          SetLength(LBuf, 2);
          SomeStream.Read(Pointer(LBuf)^, Length(LBuf));
          SomeStream.Seek(0, soBeginning);
          if (LBuf[0] = $78)
              and
             (LBuf[1] in [$01, $9C, $DA])  then
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
        finally
          LOutput.Free;
        end;
      except ON E: Exception do
        begin
          FAnswer := haBreak;
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
    SomeStream.Free;
  end;

  FAnswer := haOk;
  if Assigned(CallBackDialog) then
    CallBackDialog(self, hmtInfo, dialog, FAnswer);
  Result := True;
end;

function TGoogleDriveHelper.DoGetFileId(AFileName: string): string;
var
  LResponse: TResponseList;
  LMetadata: TResponseMetadata;
  LOutJson : ISuperObject;
  LCommand : TRESTClient.TURI;
  LResult  : Boolean;
begin
  Result := '';
  DoLog(Format('Start Get File Id with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; ClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FClientId, FToken]));
  if FToken = '' then
    Exit;

  LCommand := CS_BASEURL;
  LCommand.AddPath(CS_COMMAND_LIST);
  LCommand.AddParam('fields', CS_PARAMS_FIELDS_FILES);
  LCommand.AddParam('maxResults', IntToStr(10000));
  LCommand.SetParam('q', string.Format('''%0:s'' in parents and (title = ''%s'') and ', [FFolderInfo.id, AFileName]) + CS_PARAMS_SEARCH_FILES);
  //LCommand.SetParam('q', 'name = '+ QuotedStr(AFileName));

  repeat
    LResult := ( FRest.&Do(TRESTClient.TMethod.GET, LCommand, nil, LOutJson) = 200 );
    if ( not LResult ) then
      Break;
    LResponse := TResponseList.FromJSon(LOutJson);

    for LMetadata in LResponse.items do
    begin
//      if ( LMetadata.labels.trashed ) then
//        Continue;
      Result := LMetadata.id;
      Exit;
    end;
    LCommand.SetParam('pageToken', LResponse.nextPageToken);

  until (LResponse.nextPageToken.IsEmpty);
end;

procedure TGoogleDriveHelper.DoLog(AEvent: String);
begin
  if Assigned(CallBackHelperLog) then
    CallBackHelperLog(Self, AEvent);
end;

function TGoogleDriveHelper.DoSetShare: boolean;
var LCommand, LPermissions : TRESTClient.TURI;
    LOutJson : ISuperObject;
    LRequest: TPermissionMetadata;
    LPermissionId: string;
begin
  Result := false;
  DoLog(Format('Start Download with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; ClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FClientId, FToken]));
  if FToken = '' then
    Exit(False);

  if FUrlFile.IsEmpty then
    FUrlFile := DoGetFileId(FCloudFile);

  if FUrlFile.IsEmpty then
  begin
    FLastError := 'File Id was not specified';
    Exit;
  end;

  if FEmail.IsEmpty then
  begin
    FLastError := 'Email was not specified';
    Exit;
  end;

  LPermissionId := GetPermissionId(FEmail);
  if not LPermissionId.IsEmpty then
  begin
    LPermissions := CS_BASEURL;
    LPermissions.AddPath(string.Format(CS_COMAND_GET_PERMISSIONS, [FUrlFile, LPermissionId]));
    if FRest.&Do(TRESTClient.TMethod.GET, LPermissions, nil, LOutJson) = 200 then
      if not LOutJSon.B['deleted'] then Exit;
  end;

  LRequest.role := 'writer';
  LRequest.&type := 'user';
  LRequest.value := FEmail;

  LCommand := CS_BASEURL;
  LCommand.AddPath(string.Format(CS_COMAND_INSERT_PERMISSION, [FUrlFile]));
  Result := FRest.&Do(TRESTClient.TMethod.POST, LCommand, LRequest.ToJSon, LOutJson) = 200;
end;

procedure TGoogleDriveHelper.DoCreateFolder;
var
  LRequest: TCreateMetadata;
  LParent : TResponseParent;

  Path: string;
  LFolders: TArray<string>;
  LFolder, LParentName: string;

  LOutJson : ISuperObject;
  LCommand : TRESTClient.TURI;
  LMetadata: TResponseMetadata;
  LResult  : Boolean;
begin
  LResult := false;
  DoLog(Format('Start Create Folder with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; ClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FClientId, FToken]));

  if (FToken = '') then Exit;
  if {(FCloudPath='') or} CloudFolderExists then //20190228 Igor >>>
    Exit;

  LCommand := CS_BASEURL;
  LCommand.AddPath(CS_COMMAND_LIST);
  LRequest.mimeType := 'application/vnd.google-apps.folder';
  LParent.id := 'root';
  Path := '/apps/' + c_AppFolder + '/' + FCloudPath;
  LFolders := Path.Split(['/'], TStringSplitOptions.ExcludeEmpty);
  LParent.id := 'root';
  LParentName := 'root';
  for LFolder in LFolders do
  begin
    if (not FolderExist(LFolder, LParentName, LMetadata)) then
    begin
      LRequest.title := LFolder;
      LRequest.parents := [LParent];
      LResult := (FRest.&Do(TRESTClient.TMethod.POST, LCommand, LRequest.ToJSon, LOutJson) in [200, 204]);
      if (not LResult) then Break;
      LMetadata := TResponseMetadata.FromJSon(LOutJson);

      LParentName := LMetadata.id;
      LParent.id := LMetadata.id;
    end
    else begin
      LResult := True;
      LParentName := LMetadata.id;
      LParent.id := LMetadata.id;
    end;
  end;
  if (LResult) then
    FFolderInfo := LMetadata;
end;

function TGoogleDriveHelper.DoDownload: boolean;
var
  SomeStream: TMemoryStream;
  LUnZip: TZDecompressionStream;
  LOutput: TFileStream;
  AllowOverwrite: boolean;
  LCommand : TRESTClient.TURI;
  LResult  : Integer;
  LFileId  : String;
  LBuf     : TBytes;
  LFileSize: Int64;
  LOutJson: ISuperObject;
begin
  LResult := 0;
  DoLog(Format('Start Download with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; ClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FClientId, FToken]));
  if FToken = '' then
    Exit(False);

  LCommand := CS_BASEURL;
  LCommand.AddPath(string.Format(CS_COMAND_FILE, [FUrlFile]));
  LResult := FRest.DoStream(TRESTClient.TMethod.GET, LCommand, nil, LOutJson);
  if LResult = 200 then
    LFileSize := StrToIntDef(LOutJson.S['fileSize'], 0)
  else
  begin
    FLastError := 'File with Id = '+ QuotedStr(FUrlFIle) + ' was not found on Google Drive';
    Exit;
  end;

  SomeStream := TMemoryStream.Create;
  try
    repeat
      //download
      try
        SomeStream.Clear;
        LCommand := CS_BASEURL;
        LCommand.AddPath(string.Format(CS_COMAND_FILE, [FUrlFile]) + '?alt=media&source=downloadUrl');
        LResult := FRest.DoStream(TRESTClient.TMethod.GET, LCommand, SomeStream);
      except
        on E: Exception do
        begin
          FAnswer := haBreak;
          if Assigned(CallBackDownLoadError) then
            CallBackDownLoadError(self, E.Message, FCloudFile, FAnswer);
          case FAnswer of
            haRetry: Continue;
          else
            Exit(false);
          end;
        end;
      end;
      //check LResult
      if LResult <> 200 then
      begin
        FAnswer := haBreak;
        if Assigned(CallBackDownLoadError) then
          CallBackDownLoadError(self, 'Error '+ IntToStr(LResult) + ' occured', FCloudFile, FAnswer);
        case FAnswer of
          haRetry: Continue;
        else
          Exit(false);
        end;
      end;
      //check size
      if (LFileSize <> SomeStream.Size) then
      begin
        FAnswer := haBreak;
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
        LOutput := TFileStream.Create(FLocalFile, fmCreate);
        try
          SomeStream.Seek(0, soBeginning);
          SetLength(LBuf, 2);
          SomeStream.Read(Pointer(LBuf)^, Length(LBuf));
          SomeStream.Seek(0, soBeginning);
          if (LBuf[0] = $78)
              and
             (LBuf[1] in [$01, $9C, $DA])  then
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
        finally
          LOutput.Free;
        end;
      except ON E: Exception do
        begin
          FAnswer := haBreak;
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
    SomeStream.Free;
  end;

  FAnswer := haOk;
  if Assigned(CallBackDialog) then
    CallBackDialog(self, hmtInfo, dialog, FAnswer);
  Result := True;
end;

procedure TGoogleDriveHelper.DoUnDeleteCloudFile(AFileId: string);
var LCommand : TRESTClient.TURI;
    LOutJson : ISuperObject;
begin
  LCommand := CS_BASEURL;
  LCommand.AddPath(string.Format(CS_COMAND_UNTRASH, [AFileId]));
  FRest.&Do(TRESTClient.TMethod.POST, LCommand, nil, LOutJson);
end;

function TGoogleDriveHelper.DoUpload: boolean;
var
  local_filename: string;
  upload_stream: TFileStream;
  upload_stream_compresed: TMemoryStream;
  LZip: TZCompressionStream;
  LCommand : TRESTClient.TURI;
  LData    : TIdMultiPartFormDataStream;
  LMetadata: TCreateMetadata;
  LResult  : Integer;
  LOutJson : ISuperObject;
  LMethod  : TRESTClient.TMethod;
begin
  DoLog(Format('Start Upload with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; ClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FClientId, FToken]));
  if (FToken = '') then Exit(False);

  DoCreateFolder;
  local_filename := ExtractFileName(FLocalFile);

  repeat
    //check file exists
    if not FileExists(FLocalFile) then
    begin
      FAnswer := haBreak;
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

          if not FUrlFile.IsEmpty then
          begin
            if not FileIdExists(FUrlFile) then
              FUrlFile := DoGetFileId(FCloudFile)
            else
              DoUnDeleteCloudFile(FUrlFile);
          end;

          LCommand := CS_BASEURL;
          LCommand.AddPath(string.Format(CS_COMAND_FILE, [FUrlFile]));
          LResult := FRest.DoStream(TRESTClient.TMethod.GET, LCommand, nil, LOutJson);

          if FUrlFile.IsEmpty then
          begin
            LCommand := CS_UPLOADURL;
            LCommand.AddPath(CS_COMMAND_LIST);
            LCommand.AddParam('uploadType', 'multipart');

            LData := TIdMultiPartFormDataStream.Create;
            LMetadata.title := FCloudFile;
            if FUrlFile.IsEmpty then
              LMetadata.parents := [TResponseParent.Create(FFolderInfo.id)];
            LMetadata.mimeType := 'application/octet-stream';

            LData.AddFormField('', LMetadata.ToJSon.AsJSON(), '', 'application/json').ContentTransfer := '';
            LData.AddFormField('', '', '', upload_stream_compresed, '').ContentTransfer := '';
            LResult := FRest.DoStream(TRESTClient.TMethod.POST, LCommand, LData, LOutJson, LData.RequestContentType);
          end
          else
          begin
            LCommand := CS_UPLOADURL;
            LCommand.AddPath(string.Format(CS_COMAND_FILE, [FUrlFile]));
            LCommand.AddParam('uploadType', 'media');
            LResult := FRest.DoStream(TRESTClient.TMethod.PUT, LCommand, upload_stream_compresed, LOutJson);
          end;

          if LResult <> 200 then
            raise Exception.Create('Error '+ IntToStr(LResult) + ' occured');
          FUrlFile := LOutJSon.S['id'];
        finally
          upload_stream_compresed.Free;
        end;
      finally
        upload_stream.Free;
      end;
    except ON E: Exception do
      begin
        FAnswer := haBreak;
        if Assigned(CallBackReadLocalFileError) then
          CallBackReadLocalFileError(self, E.Message, FLocalFile, FAnswer);
        case FAnswer of
          haRetry: Continue;
        else
          Exit(False);
        end;
      end;
    end;
    Break;
  until false;
  FAnswer := haOk;
  if Assigned(CallBackDialog) then
    CallBackDialog(self, hmtInfo, dialog, FAnswer);
  Result := True;
end;

function TGoogleDriveHelper.DoDeleteCloudFile: boolean; //20190522 Igor
//var
//  FileList: TCloudFileList;
//  CloudFile: TCloudFile;
//  json: TJSONObject;
begin
  Result := false;
  DoLog(Format('Start Delete with params:   LocalFile: %s; CloudPath: %s; CloudFile: %s; ClientId: %s; Token: %s',
    [FLocalFile, FCloudPath, FCloudFile, FClientId, FToken]));
  if FToken = '' then
    Exit(False);

(*
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
*)
end;

function TGoogleDriveHelper.FileIdExists(AFileId: string): boolean;
var
  LOutJson : ISuperObject;
  LCommand : TRESTClient.TURI;
begin
  Result := false;
  try
    LCommand := CS_BASEURL;
    LCommand.AddPath(string.Format(CS_COMAND_FILE, [AFileId]));
    Result := (FRest.&Do(TRESTClient.TMethod.GET, LCommand, nil, LOutJson) = 200);
  except
  end;
end;

function TGoogleDriveHelper.FolderExist(const AName, AParent: string;
  out AMetadata: TResponseMetadata): Boolean;
var
  LResponse: TResponseList;
  LOutJson : ISuperObject;
  LCommand : TRESTClient.TURI;
  LResult  : Boolean;
begin
  FRest.AccessToken := FToken;
  FRest.RefreshToken := FRefreshToken;
  LCommand := CS_BASEURL;
  LCommand.AddPath(CS_COMMAND_LIST);
  LCommand.AddParam('fields', CS_PARAMS_FIELDS_FOLDERS);
  LCommand.AddParam('maxResults', IntToStr(10000));
  Result := False;
  LCommand.SetParam('q', string.Format(CS_PARAMS_SEARCH_FROM_PARENT, [AParent, AName]) + CS_PARAMS_SEARCH_FOLDERS);
  LResult := (FRest.&Do(TRESTClient.TMethod.GET, LCommand, nil, LOutJson) = 200);
  if ( not LResult ) then
    Exit;
  LResponse := TResponseList.FromJSon(LOutJson);
  if (LResponse.items = nil) then
    Exit;
  AMetadata := LResponse.items[0];
  Result := True;
end;

{ TResponseMetadata }

class function TResponseMetadata.FromJSon(
  const AJson: ISuperObject): TResponseMetadata;
begin
  Result := TJSON.Parse<TResponseMetadata>(AJson);
end;

function TResponseMetadata.ToJSon: ISuperObject;
begin
  Result := TJSON.SuperObject<TResponseMetadata>(Self);
end;

{ TCreateMetadata }

function TCreateMetadata.ToJSon: ISuperObject;
begin
  Result := TJSON.SuperObject<TCreateMetadata>(Self);
end;

{ TResponseList }

class function TResponseList.FromJSon(const AJson: ISuperObject): TResponseList;
begin
  Result := TJSON.Parse<TResponseList>(AJson);
end;

{ TResponseParent }

constructor TResponseParent.Create(const AParentID: string);
begin
  id := AParentID;
end;

{ TPermissionMetadata }

function TPermissionMetadata.ToJSon: ISuperObject;
begin
  Result := TJSON.SuperObject<TPermissionMetadata>(Self);
end;

end.
