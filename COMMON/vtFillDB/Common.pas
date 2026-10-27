{
Email: VisualTaxCanada@gmail.com
Password: vtSecret2015
App Key: clmqhseptut86vm
App Secret: l66h2jrszkkail6
Access Token: ZjjtdmqTrEAAAAAAAAAAFAT5RWj0EnQ1xu3EpLb5pL10P7ar8Ioiui1SXviVcYhO
}
unit Common;

interface

CONST
//  _DropBox_ClientID = 'clmqhseptut86vm';
  _DropBox_ClientID = 'g7rtsx5fpvec4x8';
//  DropBox_ClientSecret = 'l66h2jrszkkail6';
  DropBox_BaseURL = 'https://api.dropbox.com/1/';
  DropBox_BaseURL_Put = 'https://api-content.dropbox.com/1/';
  DropBox_ResourceURI = 'metadata/{ROOT}/{PATH}';
  DropBox_ResourceURI_Put = 'files_put/{ROOT}/{PATH}?{ACCES_TOKEN}={VALUE}';
  DataBaseFileName = 'vtMobile.sdb';
  c_DropBoxToken = 'DROPBOXTOKEN';
  c_OptionsTxt = 'Options.txt';
var
  DropBox_AccessToken, DropBox_AuthCode, DropBox_ClientID, VisualTaxUserId: string;

function GenerateAuthorizeURL: string;
procedure GetToken(const AURL: string; var DoCloseWebView: boolean);
function GetSavedToken: string;
function SaveToken(AToken: String): Boolean;
function DeleteToken: Boolean;

implementation

uses
   System.Classes, System.SysUtils, System.IOUtils, vtHelperManager;

function GenerateAuthorizeURL: string;
begin
  if DropBox_ClientID = '' then
    DropBox_ClientID := _DropBox_ClientID;
//  Result := 'https://www.dropbox.com/1/oauth2/authorize';
//  Result := Result + '?client_id=' + URIEncode(DropBox_ClientID);
//  Result := Result + '&response_type=' + URIEncode('token');
//  Result := Result + '&redirect_uri=' + URIEncode('http://localhost');
end;

procedure GetToken(const AURL: string; var DoCloseWebView: boolean);
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
    DropBox_AccessToken := LToken;
    if (LToken <> '') then
      DoCloseWebView := TRUE;
  end;
End;

function GetCorrectFileName(AFileName: String): String;
var
  C: Char;
const
  BadChar: Array[0..8] of Char = ('<','>',':','"','/','\','|','?','*');
Begin
  Result := AFileName;
  for C in BadChar do
    Result := StringReplace(Result, C, '', [rfReplaceAll]);
End;


function GetOptionsFile: string;
begin
  {$IF DEFINED(ANDROID)}
  Result := TPath.Combine(TPath.GetDocumentsPath, c_OptionsTxt);
  {$ELSE}
  Result := ExtractFilePath(ParamStr(0))+GetCorrectFileName(VisualTaxUserId+'.dbtkn');
  {$ENDIF}
end;

function GetSavedToken: string;
var
  sl: TStringList;
  OptionsFile: string;
  I: Integer;
begin
  Result := '';
  OptionsFile := GetOptionsFile;
  if not FileExists(OptionsFile) then
    Exit;
  sl := TStringList.Create;
  try
    sl.LoadFromFile(OptionsFile);
    for I := 0 to sl.Count - 1 do
    begin
      if Trim(Copy(sl[i], 1, 20)) = c_DropBoxToken then
      begin
        Result := Copy(sl[i],21,255);
        Exit;
      end;
    end;
  finally
    FreeAndNil(sl);
  end;
end;

function SaveToken(AToken: String): Boolean;
var
  sl: TStringList;
  OptionsFile: string;
  I: Integer;
begin
  Result := false;
  OptionsFile := GetOptionsFile;
  sl := TStringList.Create;
  try
    if FileExists(OptionsFile) then
      sl.LoadFromFile(OptionsFile);
    for I := 0 to sl.Count - 1 do
    begin
      if Trim(Copy(sl[i], 1, 20)) = c_DropBoxToken then
      begin
        sl[I] := c_DropBoxToken + StringOfChar(' ', 20 - Length(c_DropBoxToken)) + AToken;
        Result := True;
        Break;
      end;
    end;
    if not Result then
      sl.Add(c_DropBoxToken + StringOfChar(' ', 20 - Length(c_DropBoxToken)) + AToken);
    try
      sl.SaveToFile(OptionsFile);
      Result := True;
    except on E: Exception do
      Begin
        Result := False;
        raise;
      end;
    end;
  finally
    sl.Free;
  end;
end;

function DeleteToken: Boolean;
var
  sl: TStringList;
  OptionsFile: string;
  I: Integer;
begin
  Result := True;
  OptionsFile := GetOptionsFile;
  if not FileExists(OptionsFile) then
    Exit;
  sl := TStringList.Create;
  try
    sl.LoadFromFile(OptionsFile);
    for I := 0 to sl.Count - 1 do
    begin
      if Trim(Copy(sl[i], 1, 20)) = c_DropBoxToken then
      begin
        sl.Delete(I);
        Result := True;
        Break;
      end;
    end;
    if Result then
    begin
      try
        sl.SaveToFile(OptionsFile);
      Except ON E: Exception DO
        begin
          Result := False;
          raise;
        end;
      end;
    end;
  finally
    sl.Free;
  end;
end;

end.
