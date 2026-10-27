unit REST.Clouds;

interface
uses
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.Variants,
  System.TypInfo,
  System.IOUtils,
  System.Generics.Collections,
  IdLogEvent,
  IdHTTP,
  IdURI,
  IdHeaderList,
  IdSSLOpenSSL,
  XSuperObject,
  REST.Client,
  REST.Types,
  REST.Authenticator.OAuth,
  OAuthWebForm,
  REST.Utils,
  System.JSON;

type

  TResponseMetadata = record
  end;

  TRequestChilds = record
  end;

  type TOAuth2Authenticator = class(REST.Authenticator.OAuth.TOAuth2Authenticator)
    public
      function GenerateNewAccessToken(): Boolean;
  end;

  TOAuth2ResponseType = REST.Authenticator.OAuth.TOAuth2ResponseType;

  TIdHTTP = class(IdHTTP.TIdHTTP)
  end;

  TUpdateTokens = procedure(AAccessToken, ARefreshToken: string) of Object;

  TRESTClient = class
  public type
    TMethod = (GET, POST, PUT, DELETE, PATCH);
    TURI = record
      class operator Implicit(const Value: string): TURI;
      class operator Explicit(const Value: string): TURI;
      class operator Add(const A: TURI; B: string): TURI;
    private
      FURI : string;
      FParams: TArray<TPair<string, string>>;
      function getURI: string;
    public
      procedure AddParam(const AName, AValue: string);
      procedure SetParam(const AName, AValue: string);
      procedure AddPath (const APath: string);
      property  URI: string read getURI;
    end;
  private
    FIdHTTP: TIdHTTP;
    FLastError : string;
    FAuthCode: string;
    FAccessToken: string;
    FRefreshToken: string;
    FNeedAuthorize: Boolean;
    FUpdateTokens: TUpdateTokens;
  private
    FAuthorizeParams: TStrings;
    procedure setAuthCode(const Value: string);
    procedure setAccessToken(const Value: string);
    procedure setRefreshToken(const Value: string);
    function  getCustomHeaders: TIdHeaderList;
    function  getContentType: string;
    procedure setContentType(const AValue: string);
    function  JSonToStream(const AJSon: ISuperObject): TStream;
    function  StreamToJSon(AStream: TStream): ISuperObject;

    procedure OAuth2_DropBox_OnAfterRedirect(const AURL: string; var DoCloseWebView : boolean);
    procedure OAuth2_GoogleDrive_BrowserTitleChanged(const ATitle: string; var DoCloseWebView: Boolean);


    procedure OnReceived (ASender: TComponent; const AText, AData: string);
    procedure OnSent     (ASender: TComponent; const AText, AData: string);
    procedure OnStatus   (ASender: TComponent; const AText: string);
    function FindToken(AURL: String): Boolean;
  protected
    function  &Do (AMethod: TMethod; const AUri: TURI; ASource, AResponse: TStream;
                   const AContentType: string = 'application/json; charset=UTF-8'): Integer; overload;
  public
    function  DoStream (AMethod: TMethod; const AUri: TURI;
                   const ASource: TStream; out AResponse: ISuperObject;
                   const AContentType: string = 'application/json; charset=UTF-8'): Integer; overload;
    function  DoStream (AMethod: TMethod; const AUri: TURI; const AResponse: TStream;
                   const AContentType: string = 'application/octet-stream'): Integer; overload;
    function  &Do (AMethod: TMethod; const AUri: TURI;
                   const ASource: ISuperObject; out AResponse: ISuperObject;
                   const AContentType: string = 'application/json; charset=UTF-8'): Integer; overload;
    function  &Do (AMethod: TMethod; const AUri: TURI; const ASource: ISuperObject;
                   const AContentType: string = 'application/json; charset=UTF-8'): Integer; overload;
    function  &Do (AMethod: TMethod; const AUri: TURI;
                   const ASource: ISuperObject; out AResponse: TStream;
                   const AContentType: string = 'application/json; charset=UTF-8'): Integer; overload;

    function Authorize: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
  public
    property Headers    : TIdHeaderList read getCustomHeaders;
    property ContentType: string read getContentType write setContentType;
    property AuthCode   : string read FAuthCode write setAuthCode;
    property AccessToken : string read FAccessToken write setAccessToken;
    property RefreshToken : string read FRefreshToken write setRefreshToken;
    property AuthorizeParams: TStrings read FAuthorizeParams;
    property LastError: string read FLastError;
    property UpdateTokens: TUpdateTokens read FUpdateTokens write FUpdateTokens;
  end;


  TCloudsPath = class

  const
    CS_PathSeparator = '/';
  public
    class function Combine(const APath1, APath2: string): string;
    class function PathToCloudsPath (const ARootPath, APath: string): string;
    class function GetFileName      (const APath: string; const ASeparator: Char = CS_PathSeparator): string;
    class function GetDirectoryName (const APath: string; const ASeparator: Char = CS_PathSeparator): string;
  end;


  TOAuth2ResponseTypeHelper = record helper for TOAuth2ResponseType

  public
    class function FromString(const AValue: string): TOAuth2ResponseType; static;
    function ToString: string;
  end;


implementation

type
  TMethodHelper = record helper for TRESTClient.TMethod
  public
    function ToString: string;
  end;

{ TClient }

function TRESTClient.DoStream(AMethod: TMethod; const AUri: TURI;
  const ASource: TStream; out AResponse: ISuperObject;
  const AContentType: string): Integer;
var
  LOutput: TStream;
begin
  LOutput := TMemoryStream.Create;
  try
    Result := &Do(AMethod, AUri, ASource, LOutput, AContentType);
    AResponse := StreamToJSon(LOutput);
  finally
    FreeAndNil(LOutput);
  end;
end;

function TRESTClient.Authorize(): Boolean;
var
  wv: Tfrm_OAuthWebForm;
  LOAuth2  : TOAuth2Authenticator;
begin
  FLastError := '';
  Result := ( not AccessToken.IsEmpty );
  if ( not Result ) or
     ( FNeedAuthorize )  then
  begin
    LOAuth2 := TOAuth2Authenticator.Create(nil);
    try
      LOAuth2.AuthorizationEndpoint := AuthorizeParams.Values['AuthorizationEndpoint'];
      LOAuth2.AccessTokenEndpoint   := AuthorizeParams.Values['AccessTokenEndpoint'];
      LOAuth2.RedirectionEndpoint   := AuthorizeParams.Values['RedirectionEndpoint'];
      LOAuth2.Scope                 := AuthorizeParams.Values['Scope'];
      LOAuth2.ClientID              := AuthorizeParams.Values['ClientID'];
      LOAuth2.ClientSecret          := AuthorizeParams.Values['ClientSecret'];
      LOAuth2.ResponseType          := TOAuth2ResponseType.FromString(AuthorizeParams.Values['ResponseType']);
      LOAuth2.TokenType             := TOAuth2TokenType.ttNONE;

      if not RefreshToken.IsEmpty then
      begin
        LOAuth2.RefreshToken := RefreshToken;
        try
          LOAuth2.GenerateNewAccessToken;
        except
          RefreshToken := '';
        end;
        AccessToken := LOAuth2.AccessToken;
        RefreshToken := LOAuth2.RefreshToken;
        if Assigned(FUpdateTokens) then
          FUpdateTokens(AccessToken, RefreshToken);
      end;

      if not AccessToken.IsEmpty then
        Exit;

//      DoLog('Start Craft Token');
      wv := Tfrm_OAuthWebForm.Create(nil);
      try
        wv.OnAfterRedirect  := self.OAuth2_DropBox_OnAfterRedirect;
        wv.OnBeforeRedirect := self.OAuth2_DropBox_OnAfterRedirect;
        wv.OnTitleChanged   := OAuth2_GoogleDrive_BrowserTitleChanged;
//        wv.OnError := WebBrowserError;
        wv.ShowModalWithURL(LOAuth2.AuthorizationRequestURI);
      finally
        wv.Free;
      end;
//      Result := FToken <> '';

      if ( not AuthCode.IsEmpty ) and
         ( not LOAuth2.AccessTokenEndpoint.IsEmpty ) then
      begin
        LOAuth2.AuthCode := AuthCode;
        LOAuth2.ChangeAuthCodeToAccesToken;
        AccessToken := LOAuth2.AccessToken;
        RefreshToken := LOAuth2.RefreshToken;
        if Assigned(FUpdateTokens) then
          FUpdateTokens(AccessToken, RefreshToken);
      end;
      Result := ( not AccessToken.IsEmpty );
    except
      on E: Exception do
      begin
        FLastError := e.Message;
//        Logger.WriteLogException('TRESTClient.Authorize', E);
        Result := false;
        AccessToken := '';
        RefreshToken := '';
      end;
    end;
  end;
end;

constructor TRESTClient.Create;
var
  LSSL: TIdSSLIOHandlerSocketOpenSSL;
  LLog: TIdLogEvent;
begin
  FIdHTTP := TIdHTTP.Create(nil);
  LLog := TIdLogEvent.Create(FIdHTTP);
  LSSL := TIdSSLIOHandlerSocketOpenSSL.Create(FIdHTTP);
  FIdHTTP.Intercept := LLog;
  FIdHTTP.IOHandler := LSSL;
  LLog.OnStatus := OnStatus;
  LLog.OnReceived := OnReceived;
  LLog.OnSent := OnSent;
  LLog.Active := True;
  FAuthorizeParams := TStringList.Create;
end;

destructor TRESTClient.Destroy;
begin
  FreeAndNil(FAuthorizeParams);
  inherited;
end;

function TRESTClient.getContentType: string;
begin
  Result := fIdHTTP.Request.ContentType;
end;

function TRESTClient.GetCustomHeaders: TIdHeaderList;
begin
  Result := fIdHTTP.Request.CustomHeaders;
end;

function TRESTClient.JSonToStream(const AJSon: ISuperObject): TStream;
begin
  if ( AJSon <> nil ) then
    Result := TStringStream.Create(AJSon.AsJSon())
  else
    Result := nil;
end;

procedure TRESTClient.OAuth2_DropBox_OnAfterRedirect(const AURL: string;
  var DoCloseWebView: boolean);
begin
  DoCloseWebView := FindToken(AURL);
end;

procedure TRESTClient.OAuth2_GoogleDrive_BrowserTitleChanged(
  const ATitle: string; var DoCloseWebView: boolean);
begin
  DoCloseWebView := FindToken(ATitle);
end;

procedure TRESTClient.OnReceived(ASender: TComponent; const AText, AData: string);
begin
//
end;

procedure TRESTClient.OnSent(ASender: TComponent; const AText, AData: string);
begin
//
end;

procedure TRESTClient.OnStatus(ASender: TComponent; const AText: string);
begin
//
end;

function TRESTClient.&Do(AMethod: TMethod; const AUri: TURI; const ASource: ISuperObject;
  out AResponse: TStream; const AContentType: string): Integer;
var
  LInput : TStream;
begin
  LInput := JSonToStream(ASource);
  try
    AResponse := TMemoryStream.Create;
    Result := &Do(AMethod, AUri, LInput, AResponse, AContentType);
  finally
    FreeAndNil(LInput);
  end;
end;

function TRESTClient.DoStream(AMethod: TMethod; const AUri: TURI;
  const AResponse: TStream; const AContentType: string): Integer;
begin
  Result := &Do(AMethod, AUri, nil, AResponse, AContentType);
end;

function TRESTClient.FindToken(AURL: String): Boolean;
var
  LToken: string;
begin
  if ( AuthCode.IsEmpty ) and
     ( StartsText('Success code', AURL) ) then
  begin
    LToken := Copy(AURL, 14, Length(AURL));
    if (Pos('&', LToken) > 0) then
      LToken := Copy(LToken, 1, Pos('&', LToken) - 1);
    AuthCode := LToken;
  end;
  Result := (AuthCode <> '');
end;

function TRESTClient.&Do(AMethod: TMethod; const AUri: TURI; const ASource: ISuperObject;
  const AContentType: string): Integer;
var
  LInput : TStream;
begin
  LInput := JSonToStream(ASource);
  try
    Result := &Do(AMethod, AUri, LInput, nil, AContentType);
  finally
    FreeAndNil(LInput);
  end;
end;

function TRESTClient.&Do(AMethod: TMethod; const AUri: TURI; ASource, AResponse: TStream;
  const AContentType: string): Integer;
var
  LStream: TStream;
  LJson  : ISuperObject;
  LErrorBody: string;
  LNeedRepeat: boolean;
begin
  Result := 0;
  FLastError := '';
  LStream := ASource;
  LErrorBody := '';
  if ASource = nil then
    LStream := TMemoryStream.Create;

  try
    repeat
      LNeedRepeat := false;
      fIdHTTP.Request.ContentType := AContentType;
      fIdHTTP.Request.CustomHeaders.Values['Authorization'] := 'Bearer '+AccessToken;
      fIdHTTP.Request.CustomHeaders.Values['Accept-Charset'] := 'utf-8';
      try
        try
          fIdHTTP.DoRequest(AMethod.ToString, AUri.URI, LStream, AResponse, []);
          Result := fIdHTTP.ResponseCode;
          if Result <> 200 then
          begin
            LJson := StreamToJSon(AResponse);
            if LJson <> nil then
              LErrorBody := LJson.AsJSon();

            //DoLog('TRESTClient.Post: %d, %s, body: %s', [Result, fIdHTTP.ResponseText, LErrorBody], lsvError);
          end;

        except
          on e: EIdHTTPProtocolException do
          begin
            FLastError := E.Message;
            Result := e.ErrorCode;
            LJson := StreamToJSon(AResponse);
            if LJson <> nil then
              LErrorBody := LJson.AsJSon();
            //Logger.WriteLogFmr('TRESTClient.Post %d, %s, body: %s', [e.ErrorCode, E.Message, LErrorBody], lsvError);
          end;
          on e: Exception do
          begin
            FLastError := E.Message;
            Result := 500;
            if not fIdHTTP.Connected then
              AuthCode := string.Empty;
            //Logger.WriteLogFmr('TRESTClient.Post %s', [E.Message], lsvError);
          end;
        end;
      finally
        if Result = 401 then  //Bad or expired token.
        begin
          AccessToken := string.Empty;
          Authorize();
          LNeedRepeat := not AccessToken.IsEmpty and not RefreshToken.IsEmpty;
        end;
        fIdHTTP.Request.CustomHeaders.Clear;
      end;
    until not LNeedRepeat;
  finally
    if ASource = nil then
      FreeAndNil(LStream);
  end;
end;

function TRESTClient.&Do(AMethod: TMethod; const AUri: TURI; const ASource: ISuperObject;
  out AResponse: ISuperObject; const AContentType: string): Integer;
var
  LOutput: TStream;
begin
  try
    Result := &Do(AMethod, AUri, ASource, LOutput, AContentType);
    if ( Result = 200 ) then
      AResponse := StreamToJSon(LOutput);
  finally
    FreeAndNil(LOutput);
  end;
end;

procedure TRESTClient.setAccessToken(const Value: string);
begin
  FAccessToken := Value;
end;

procedure TRESTClient.SetAuthCode(const Value: string);
begin
  FAuthCode := Value;
end;

procedure TRESTClient.setContentType(const AValue: string);
begin
  fIdHTTP.Request.ContentType := AValue;
end;

procedure TRESTClient.setRefreshToken(const Value: string);
begin
  FRefreshToken := Value;
end;

function TRESTClient.StreamToJSon(AStream: TStream): ISuperObject;
var
  LBuff: TBytes;
  LStr : string;
begin
  Result := SO;
  if ( AStream <> nil ) and
     ( AStream.Size > 0 ) then
    try
      SetLength(LBuff, AStream.Size);
      AStream.Seek(0, 0);
      AStream.Read(LBuff, AStream.Size);
      LStr := TEncoding.UTF8.GetString(LBuff);
      Result := SO(LStr);
    except
    end;
end;

{ TOAuth2ResponseTypeHelper }

class function TOAuth2ResponseTypeHelper.FromString(
  const AValue: string): TOAuth2ResponseType;
begin
  Result := TOAuth2ResponseType(GetEnumValue(TypeInfo(TOAuth2ResponseType), AValue));
end;

function TOAuth2ResponseTypeHelper.ToString: string;
begin
  Result := GetEnumName(TypeInfo(TOAuth2ResponseType), Integer(Self));
end;

{ TMethodHelper }

function TMethodHelper.ToString: string;
begin
  case Self of
    POST   : Result := Id_HTTPMethodPost;
    PUT    : Result := Id_HTTPMethodPut;
    DELETE : Result := Id_HTTPMethodDelete;
    PATCH  : Result := Id_HTTPMethodPatch;
  else
    Result := Id_HTTPMethodGet;
  end;
end;

{ TRESTClient.TURI }

class operator TRESTClient.TURI.Add(const A: TURI; B: string): TURI;
begin
  Result := A;
  Result.AddPath(B);
end;

procedure TRESTClient.TURI.AddParam(const AName, AValue: string);
begin
  FParams := FParams + [TPair<string, string>.Create(AName, AValue)];
end;

procedure TRESTClient.TURI.AddPath(const APath: string);
begin
  FURI := TCloudsPath.Combine(FURI, APath);
end;

class operator TRESTClient.TURI.Explicit(const Value: string): TURI;
begin
  Result.FURI := Value;
end;

function TRESTClient.TURI.getURI: string;

  function getParams: string;
  var
    LParam: TPair<string, string>;
  begin
    for LParam in FParams do
      Result := Result + '&' + URIEncode(LParam.Key) + '=' + URIEncode(LParam.Value);
    Result := Result.Trim(['&']);
  end;

var
  LUri: TIdURI;
  LStr: string;
  LParams: string;
begin
  LParams := getParams;
  LStr := FURI;
  if ( not LParams.IsEmpty ) then
    LStr := LStr + '?' + LParams;

  LUri := TIdURI.Create(LStr);
  try
    LUri.Path := TIdURI.PathEncode(LUri.Path);

    LUri.Document := TIdURI.PathEncode(LUri.Document);

//    LUri.Params := TNetEncoding.URL.Encode(LUri.Params);

    Result := LUri.URI;
  finally
    LUri.Free;
  end;
end;

class operator TRESTClient.TURI.Implicit(const Value: string): TURI;
begin
  Result.FURI := Value;
end;

procedure TRESTClient.TURI.SetParam(const AName, AValue: string);
var
  i: Integer;
begin
  for i := 0 to Length(FParams) -1 do
    if ( FParams[i].Key = AName ) then
    begin
      FParams[i].Value := AValue;
      Exit;
    end;
  AddParam(AName, AValue);
end;

{ TCloudsPath }

class function TCloudsPath.Combine(const APath1, APath2: string): string;
var
  Ch: Char;
begin
  if ( APath1 = '' ) then
    Result := APath2
  else
    if ( APath2 = '' ) then // DO NOT LOCALIZE
      Result := APath1
    else begin
      Ch := APath1[High(APath1)];
      if ( Ch <> CS_PathSeparator ) then
        Result := APath1 + CS_PathSeparator + APath2
      else
        Result := APath1 + APath2;
    end;
end;

class function TCloudsPath.GetDirectoryName(const APath: string;
  const ASeparator: Char): string;
begin
  Result := Copy(APath, 1, APath.LastDelimiter(ASeparator)+1);
end;

class function TCloudsPath.GetFileName(const APath: string;
  const ASeparator: Char): string;
begin
  Result := Copy(APath, APath.LastDelimiter(ASeparator)+2, Length(APath));
end;

class function TCloudsPath.PathToCloudsPath(const ARootPath, APath: string): string;
begin
  Result := CS_PathSeparator + APath.Replace(ARootPath, '',  [rfIgnoreCase]).Replace(TPath.DirectorySeparatorChar, CS_PathSeparator);
end;

{ TOAuth2Authenticator }

function TOAuth2Authenticator.GenerateNewAccessToken: Boolean;
var
  LClient: Rest.Client.TRestClient;
  LRequest: TRESTRequest;
  LToken: string;
begin
  Result := false;
  LClient := Rest.Client.TRestClient.Create(AccessTokenEndpoint);
  try
    LRequest := TRESTRequest.Create(LClient); // The LClient now "owns" the Request and will free it.
    LRequest.Method := TRESTRequestMethod.rmPOST;

    LRequest.AddAuthParameter('grant_type', 'refresh_token', TRESTRequestParameterKind.pkGETorPOST);
    LRequest.AddAuthParameter('client_id', ClientID, TRESTRequestParameterKind.pkGETorPOST);
    LRequest.AddAuthParameter('client_secret', ClientSecret, TRESTRequestParameterKind.pkGETorPOST);
    LRequest.AddAuthParameter('refresh_token', RefreshToken, TRESTRequestParameterKind.pkGETorPOST);

    LRequest.Execute;

    if LRequest.Response.GetSimpleValue('access_token', LToken) then
    begin
      AccessToken := LToken;
    end;

    if LRequest.Response.GetSimpleValue('refresh_token', LToken) then
    begin
      RefreshToken := LToken;
    end;

    {
    // detect token-type. this is important for how using it later
    if LRequest.Response.GetSimpleValue('token_type', LToken)
     then _TokenType := OAuth2TokenTypeFromString(LToken);

    // if provided by the service, the field "expires_in" contains
    // the number of seconds an access-token will be valid
    if LRequest.Response.GetSimpleValue('expires_in', LToken) then
    begin
      LIntValue := StrToIntdef(LToken, -1);
      if (LIntValue > -1) then
        _AccessTokenExpireDT := IncSecond(Now, LIntValue)
      else
        _AccessTokenExpireDT := 0.0;

      //Memo1.Lines.Add('RefreshExpiredToken: New Token Expires '+formatdatetime('hh:nn:ss dd/mm/yyyy', _AccessTokenExpireDT));
    end;

    }
  finally
    LClient.DisposeOf;
  end;
end;

end.
