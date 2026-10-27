unit CloudHelperDropBox;

interface

uses
  CloudHelperAbstr,
  System.Classes,
  REST.Client,
  REST.Authenticator.OAuth,
  REST.Utils,
  REST.Types,
  IPPeerClient,
  System.DateUtils,
  System.ZLib;
type

  THelperThread = class(TThread)
  protected
    FToken,
    FClientID: string;

    FRESTResponse: TRESTResponse;
    FOAuth2_DropBox: TOAuth2Authenticator;
    FRESTRequest: TRESTRequest;
    FRESTClient: TRESTClient;
    FCallBackLog: TCallBackLog;

    procedure InitResource;
    procedure ResetAll;
    procedure AddParamAuthorization;
    procedure DoLog(AMessage: String);

  public
    destructor Destroy; override;
  end;

  TDownLoadHeadersThread = class(THelperThread)
  private
    FCloudPath,
    FFile: string;
    FCallBack: TGetDataBaseHeadersCallBack;
  public
    constructor Create(AToken, AClientID, ACloudPath, AFile: string;
      ACallBack: TGetDataBaseHeadersCallBack);
    procedure Execute; override;
  end;

  TDownLoadFile = class(THelperThread)
  private
    FCloudFile: TCloudFile;
    FCallBack: TGetFileCallBack;
  public
    constructor Create(AToken, AClientID: string; ACloudFile: TCloudFile;
      ACallBack: TGetFileCallBack; ACallBackLog: TCallBackLog = nil);
    procedure Execute; override;
  end;

  TCloudHelperDropBox = class(TCloudHelperAbstr)
  public
    class function GetToken(AURL: string; out AToken: String): Boolean; override;
    class function AuthorizationURL(ADropBoxClientId: String): string; override;
    class function HelperName: string; override;
    class function DefaultClientID: string; override;
    class procedure GetDataBaseHeaders(AToken, AClientID, ACloudPath, AFile: string;
      ACallBack: TGetDataBaseHeadersCallBack); override;
    class procedure GetFile(AToken, AClientID: string; ACloudFile: TCloudFile;
      ACallBack: TGetFileCallBack; ACallBackLog: TCallBackLog = nil); override;
  end;

implementation

{ TCloudHelperDropBox }

uses
  System.SysUtils, CloudHelperFactory, System.JSON;

const
  c_AuthorizationEndpoint = 'https://www.dropbox.com/oauth2/authorize';
  c_RedirectionEndpoint = 'http://localhost';
  c_AccessTokenEndpoint = 'https://api.dropboxapi.com/oauth2/token';
  c_Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,';

  c_DropBox_BaseURL_ListReceived = 'https://api.dropboxapi.com/2/sharing/list_received_files';
  c_DropBox_BaseURL_List_Continue = 'https://api.dropboxapi.com/2/files/list_folder/continue';
  c_DropBox_BaseURL_ListReceived_Continue = 'https://api.dropboxapi.com/2/sharing/list_received_files/continue';
  c_DropBox_BaseURL_Shared_link_metadata = 'https://api.dropboxapi.com/2/sharing/get_shared_link_metadata';

  c_DropBox_BaseURL_List =  'https://api.dropboxapi.com/2/files/list_folder';
  c_DropBox_BaseURL_Search =  'https://api.dropboxapi.com/2/files/search';

  c_DropBox_BaseURL_Dowload = 'https://content.dropboxapi.com/2/files/download';
  c_DropBox_BaseURL_DowloadShared= 'https://content.dropboxapi.com/2/sharing/get_shared_link_file';

  c_Authorization = 'Authorization';
  c_Bearer = 'Bearer ';
  c_AppFolder = 'vtMobile';

function MyEncode(AValue: String): String;
begin
  if AValue = '' then
    exit('');
  Result := StringReplace(TJSONString.Create(AValue).ToJSON, '\/', '/', [rfReplaceAll]);
  System.Delete(Result, 1, 1);
  System.Delete(Result, length(Result), 1);
end;

class function TCloudHelperDropBox.AuthorizationURL(ADropBoxClientId: String): string;
begin
  if ADropBoxClientId = '' then
    ADropBoxClientId := TCloudHelperDropBox.DefaultClientID;

  Result := c_AuthorizationEndpoint+
            '?client_id=' + URIEncode(ADropBoxClientId) +
            '&response_type=' + URIEncode('token') +
            '&redirect_uri=' + URIEncode(c_RedirectionEndpoint);
end;

class function TCloudHelperDropBox.DefaultClientID: string;
begin
  Result := 'g7rtsx5fpvec4x8';
end;

class procedure TCloudHelperDropBox.GetDataBaseHeaders(AToken, AClientID, ACloudPath,
  AFile: string; ACallBack: TGetDataBaseHeadersCallBack);
begin
  TDownLoadHeadersThread.Create(AToken, AClientID, ACloudPath, AFile, ACallBack);
end;

class procedure TCloudHelperDropBox.GetFile(AToken, AClientID: string;
  ACloudFile: TCloudFile; ACallBack: TGetFileCallBack; ACallBackLog: TCallBackLog = nil);
begin
  TDownLoadFile.Create(AToken, AClientID, ACloudFile, ACallBack, ACallBackLog);
end;

class function TCloudHelperDropBox.GetToken(AURL: string;
  out AToken: String): Boolean;
var
  I: Integer;
const
  c_TokenStart = 'access_token=';
begin
  AToken := '';
  I := Pos(c_TokenStart, LowerCase(AURL));
  if I = 0 then
    Exit(False);
  AToken := Copy(AURL, I + Length(c_TokenStart), MaxInt);
  I := Pos('&', AToken);
  if (I > 0) then
    AToken := Copy(AToken, 1, I - 1);
  Result := AToken <> '';
end;

class function TCloudHelperDropBox.HelperName: string;
begin
  Result := 'DropBox';
end;

{ TDownLoadHeadersThread }

constructor TDownLoadHeadersThread.Create(AToken, AClientID, ACloudPath,
  AFile: string; ACallBack: TGetDataBaseHeadersCallBack);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FToken := AToken;
  FClientID := AClientID;
  FCloudPath := ACloudPath;
  FFile := AFile;
  FCallBack := ACallBack;

  InitResource;
end;

procedure TDownLoadHeadersThread.Execute;
var
  json, row: TJSONObject;
  arr: TJSONArray;
  has_more: Boolean;
  cursor: string;
  i: Integer;

  LastErrorMessage: string;

  ResultList: TCloudFileList;
begin
  LastErrorMessage := '';
  try
    try
      //Shared
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

      has_more:=False;

      repeat
        try
          FRESTRequest.Execute;
        except
          on E: Exception do
          begin
            LastErrorMessage := E.Message;
            Exit;
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
              if SameText(row.GetValue('name').Value, FFile) then
              begin
                SetLength(ResultList, Length(ResultList)+1);
                ResultList[Length(ResultList) - 1].Path := row.GetValue('name').Value;
                ResultList[Length(ResultList) - 1].FullPath := 'Shared';
                ResultList[Length(ResultList) - 1].IsDir := False;
                ResultList[Length(ResultList) - 1].Size := 0;
                ResultList[Length(ResultList) - 1].ServerModified := Now;
                ResultList[Length(ResultList) - 1].Url := row.GetValue('preview_url').Value;
              end;
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
          end
          else
          if json.Values['error_summary'] <> nil then
          begin
            LastErrorMessage := json.Values['error_summary'].Value;
            Exit;
          end
          else
          begin
            LastErrorMessage := 'Bad answer: ' + json.ToJSON;
            Exit;
          end;
        finally
          json.Free;
        end;
      until not has_more;

      for I := Low(ResultList) to High(ResultList) do
      begin
        if ResultList[I].Url = '' then
          Continue;
        ResetAll;
        FRESTClient.BaseURL := c_DropBox_BaseURL_Shared_link_metadata;
        FRESTClient.Authenticator := nil;
        FRESTClient.ContentType := 'application/json';
        FRESTRequest.Method := TRESTRequestMethod.rmPOST;
        FRESTRequest.Params.Clear;
        AddParamAuthorization;
        json := TJSONObject.Create;
        try
          json.AddPair(TJSONPair.Create('url', ResultList[I].Url));
          FRESTRequest.Body.ClearBody;
          FRESTRequest.Body.Add(json);
          try
            FRESTRequest.Execute;
          except on E: Exception do
            begin
              LastErrorMessage := E.Message;
              Exit;
            end;
          end;
        finally
          json.Free;
        end;
        json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
        try
          if json.Values['server_modified'] <> nil then
          begin
            if json.Values['server_modified'] <> nil then
              ResultList[I].ServerModified := ISO8601ToDate( json.Values['server_modified'].Value, true);
            if json.Values['size'] <> nil then
              ResultList[I].Size := StrToInt(json.Values['size'].Value);
          end
          else
          if json.Values['error_summary'] <> nil then
          begin
            LastErrorMessage := json.Values['error_summary'].Value;
            Exit;
          end
          else
          begin
            LastErrorMessage := 'Bad answer: ' + json.ToJSON;
            Exit;
          end;
        finally
          json.Free;
        end;
      end;

      //self owner

      ResetAll;
      FRESTClient.BaseURL := c_DropBox_BaseURL_Search;
      FRESTClient.Authenticator := nil;
      FRESTClient.ContentType := 'application/json';

      FRESTRequest.Method := TRESTRequestMethod.rmPOST;
      FRESTRequest.SynchronizedEvents := false;
      FRESTRequest.Params.Clear;
      AddParamAuthorization;
      json := TJSONObject.Create;
      try
        if FCloudPath = '' then
          json.AddPair(TJSONPair.Create('path', '/apps/'+c_AppFolder))
        else
          json.AddPair(TJSONPair.Create('path', '/apps/'+c_AppFolder+'/'+FCloudPath));
        json.AddPair(TJSONPair.Create('query', ''));
        FRESTRequest.Body.ClearBody;
        FRESTRequest.Body.Add(json);
      finally
        json.Free;
      end;
      try
        FRESTRequest.Execute;
      except on E: Exception do
        begin
          LastErrorMessage := E.Message;
          Exit;
        end;
      end;
      json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
      try
        if (json.Values['error_summary'] <> nil) then
        begin
          if (json.Values['error_summary'].Value.StartsWith('path/not_found/'))  then
          begin
            exit;
          end
          else
          begin
            LastErrorMessage := json.Values['error_summary'].Value;
            Exit;
          end;
        end;
      finally
        json.Free;
      end;

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
        if FCloudPath = '' then
          json.AddPair(TJSONPair.Create('path', '/apps/'+c_AppFolder))
        else
          json.AddPair(TJSONPair.Create('path', '/apps/'+c_AppFolder+'/'+FCloudPath));
        FRESTRequest.Body.ClearBody;
        FRESTRequest.Body.Add(json);
      finally
        json.Free;
      end;
      has_more := False;
      repeat
        try
          FRESTRequest.Execute;
        except on E: Exception do
          begin
            LastErrorMessage := E.Message;
            Exit;
          end;
        end;
        json := TJSONObject.ParseJSONValue(FRESTResponse.Content) as TJSONObject;
        try
          if json.Values['entries'] <> nil then
          begin
            cursor := json.Values['cursor'].Value;
            has_more := json.Values['has_more'].Value = 'true';
            arr := json.Values['entries'] as TJSONArray;
            for i := 0 to arr.Count - 1 do
            begin
              row := arr.Items[i] as TJSONObject;
              if SameText(row.GetValue('name').Value, FFile) and
                 not sametext('folder', row.GetValue('.tag').Value) then
              begin
                SetLength(ResultList, Length(ResultList)+1);
                ResultList[Length(ResultList) - 1].Path := row.GetValue('name').Value;
                ResultList[Length(ResultList) - 1].FullPath := row.GetValue('path_display').Value;
                ResultList[Length(ResultList) - 1].IsDir := False;
                ResultList[Length(ResultList) - 1].Size := StrToInt(row.GetValue('size').Value);
                ResultList[Length(ResultList) - 1].ServerModified := ISO8601ToDate(row.GetValue('server_modified').Value);
                ResultList[Length(ResultList) - 1].Url := '';
              end;
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
          end
          else
          if json.Values['error_summary'] <> nil then
          begin
            LastErrorMessage := json.Values['error_summary'].Value;
            exit;
          end
          else
          begin
            LastErrorMessage := 'Bad answer: ' + json.ToJSON;
            exit;
          end;
        finally
          json.Free;
        end;
      until not has_more;
    except ON E: Exception DO
      LastErrorMessage := E.Message;
    end;
  finally
    Synchronize(
      procedure()
      begin
        if Assigned(FCallBack) then
          FCallBack(LastErrorMessage, ResultList);
      end);
  end;
end;
{ THelperThread }

procedure THelperThread.AddParamAuthorization;
begin
  with FRESTRequest.Params.AddItem do
  begin
    name := c_Authorization;
    Value := c_Bearer + FToken;
    ContentType := ctNone;
    Kind := pkHTTPHEADER;
    Options := [poDoNotEncode];
  end;
end;

destructor THelperThread.Destroy;
begin
  FRESTResponse.Free;
  FOAuth2_DropBox.Free;
  FRESTRequest.Free;
  FRESTClient.Free;
  inherited;
end;

procedure THelperThread.DoLog(AMessage: String);
begin
  if Assigned(FCallBackLog) then
    Synchronize(
      procedure
      begin
        FCallBackLog(AMessage);
      end);
end;

procedure THelperThread.InitResource;
begin
  // RESTResponse
  FRESTResponse := TRESTResponse.Create(nil);
  // OAuth2_DropBox
  FOAuth2_DropBox := TOAuth2Authenticator.Create(nil);
  // RESTRequest
  FRESTRequest := TRESTRequest.Create(nil);
  // RESTClient

  FRESTClient := TRESTClient.Create(nil);

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

procedure THelperThread.ResetAll;
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
end;

{ TDownLoadFile }

constructor TDownLoadFile.Create(AToken, AClientID: string;
  ACloudFile: TCloudFile; ACallBack: TGetFileCallBack; ACallBackLog: TCallBackLog = nil);
begin
  inherited Create(False);
  FreeOnTerminate := True;
  FToken := AToken;
  FClientID := AClientID;
  FCloudFile := ACloudFile;
  FCallBack := ACallBack;
  FCallBackLog := ACallBackLog;
  InitResource;
end;

procedure TDownLoadFile.Execute;
var
  SomeStream: TMemoryStream;
  LUnZip: TZDecompressionStream;
  ResultStream: TMemoryStream;
  json: TJSONObject;
  LastErrorMessage: string;
  Attempt: Integer;
begin
  DoLog('Start download database');
  ResultStream := nil;
  LastErrorMessage := '';
  try
    try
      ResetAll;
      FRESTRequest.Method := TRESTRequestMethod.rmGET;
      FRESTClient.Authenticator := nil;
      FRESTRequest.Params.Clear;
      FRESTRequest.ClearBody;
      AddParamAuthorization;
      if FCloudFile.Url = '' then
      begin
        DoLog('Source: ' + FCloudFile.FullPath);
        FRESTClient.BaseURL := c_DropBox_BaseURL_Dowload;
        json  := TJSONObject.Create;
        try
          json.AddPair('path', myEncode(FCloudFile.FullPath));
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
      end
      else
      begin
        DoLog('Source: ' + FCloudFile.Url);
        FRESTClient.BaseURL :=  c_DropBox_BaseURL_DowloadShared;
        json  := TJSONObject.Create;
        try
          json.AddPair('url', myEncode(FCloudFile.Url));
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
      end;
      Attempt := 0;
      repeat
        //download
        DoLog('Start transfer. Attempt #' + IntToStr(Attempt + 1));
        try
          FRESTRequest.Execute;
        except
          on E: Exception do
          begin
            LastErrorMessage := E.Message;
            Exit;
          end;
        end;
        //check size
        if (FCloudFile.Size <> Length(FRESTResponse.RawBytes)) then
        begin
          if Attempt < 3 then
            inc(Attempt)
          else
          begin
            LastErrorMessage := 'An error occurred while downloading the file. Retry the operation.';
            Exit;
          end;
        end
        else
          break;
      until false;
      DoLog('Transfer complete');
      try
        DoLog('Unpack ...');
        SomeStream := TMemoryStream.Create;
        try
          SomeStream.WriteData(FRESTResponse.RawBytes, Length(FRESTResponse.RawBytes));
          ResultStream := TMemoryStream.Create;
          SomeStream.Seek(0, soBeginning);
          LUnZip := TZDecompressionStream.Create(SomeStream);
          try
            ResultStream.CopyFrom(LUnZip, 0);
            DoLog('Unpack complete');
          finally
            LUnZip.Free;
          end;
        finally
          SomeStream.Free;
        end;
      except ON E: Exception do
        begin
          LastErrorMessage := E.Message;
          Exit;
        end;
      end;
    except ON E: Exception do
      begin
        LastErrorMessage := E.Message;
      end;
    end;
  finally
    Synchronize(
      procedure()
      begin
        if Assigned(FCallBack) then
          FCallBack(LastErrorMessage, ResultStream);
      end);
      FreeAndNil(ResultStream);
  end;
end;

initialization
  CloudHelperFactory.RegCloudHelper(TCloudHelperDropBox.HelperName, TCloudHelperDropBox);
finalization
  CloudHelperFactory.UnRegCloudHelper(TCloudHelperDropBox.ClassName);

end.
