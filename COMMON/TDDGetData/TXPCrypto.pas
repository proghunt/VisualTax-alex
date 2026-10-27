unit TXPCrypto;

interface

uses
  Windows;

type
  TBytes = array of Byte;

  TTXPCrypto = class
  private
    FSHA_Alg: DWORD;

    function BinToStr(const AData: TBytes): string;
    function BinToStrA(const AData: TBytes): AnsiString;
  public
    constructor Create;

    function GenHash(const AText: AnsiString): TBytes; overload;
    function GenHash(const AData: TBytes): TBytes; overload;

    function GenSalt(const ALen: Cardinal): string;
    function GenSaltA(const ALen: Cardinal): AnsiString;

    function GenPwdHash(const APass, ASalt: string): string;

    function GenPwdHashA(const APass, ASalt: Ansistring): AnsiString;
    function GenPwdHashBase64(const APass, ASalt: Ansistring): AnsiString;

    function BinToBase64(const AData: TBytes): AnsiString;

    function SHA1Hash(const AData: TBytes): TBytes;
    function Base64Encode(const AData: TBytes): AnsiString;

    property SHA_Alg: DWORD read FSHA_Alg write FSHA_Alg; // default is CALG_SHA_512
  end;

implementation

uses
  SysUtils, JwaWinCrypt;

const
  MS_ENH_RSA_AES_PROV = 'Microsoft Enhanced RSA and AES Cryptographic Provider';
  MS_ENH_RSA_AES_PROV_XP = 'Microsoft Enhanced RSA and AES Cryptographic Provider (Prototype)';

{ TTXPCrypto }

function TTXPCrypto.Base64Encode(const AData: TBytes): AnsiString;
begin
  Result := BinToBase64(AData);
end;

function TTXPCrypto.BinToBase64(const AData: TBytes): AnsiString;
var
  Len: DWORD;
begin
  CryptBinaryToStringA(@AData[0], Length(AData), CRYPT_STRING_BASE64, nil, Len);
  SetLength(Result, Len);
  CryptBinaryToStringA(@AData[0], Length(AData), CRYPT_STRING_BASE64, PAnsiChar(Result), Len);
end;

function TTXPCrypto.BinToStr(const AData: TBytes): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to High(AData) do
    Result := Result + IntToHex(AData[i], 2);

  Result := LowerCase(Result);
end;

function TTXPCrypto.BinToStrA(const AData: TBytes): AnsiString;
var
  i: Integer;
  Temp: String;
begin
  Temp := '';
  for i := 0 to High(AData) do
    Temp := Temp + IntToHex(AData[i], 2);

  Result := AnsiString(LowerCase(Temp));
end;

constructor TTXPCrypto.Create;
begin
  inherited Create;

  FSHA_Alg := CALG_SHA_512;
end;

function TTXPCrypto.GenHash(const AText: AnsiString): TBytes;
var
  Temp: TBytes;
begin
  SetLength(Temp, Length(AText));
  Move(AText[1], Temp, Length(AText));
  Result := GenHash(Temp);
end;

function TTXPCrypto.GenHash(const AData: TBytes): TBytes;
var
  hProv: HCRYPTPROV;
  hHash: HCRYPTHASH;
  HashLen: DWORD;
  Provider: AnsiString;
begin
  hProv := 0;
  hHash := 0;
  Result := nil;

  if (Win32MajorVersion = 5) and (Win32MinorVersion = 1) then
    Provider := MS_ENH_RSA_AES_PROV_XP
  else
    Provider := MS_ENH_RSA_AES_PROV;

  if not CryptAcquireContextA(hProv, nil, PAnsiChar(Provider), PROV_RSA_AES, CRYPT_VERIFYCONTEXT) then
    CryptAcquireContextA(hProv, nil, PAnsiChar(Provider), PROV_RSA_AES, CRYPT_NEWKEYSET or CRYPT_VERIFYCONTEXT);

  if not CryptCreateHash(hProv, FSHA_Alg, 0, 0, hHash) then
    RaiseLastOSError;

  if CryptHashData(hHash, @AData[0], Length(AData), 0) then
  begin
    CryptGetHashParam(hHash, HP_HASHVAL, nil, HashLen, 0);
    SetLength(Result, HashLen);

    if not CryptGetHashParam(hHash, HP_HASHVAL, @Result[0], HashLen, 0) then
      RaiseLastOSError;

    CryptDestroyHash(hHash);
  end;

  CryptReleaseContext(hProv, 0);
end;

function TTXPCrypto.GenPwdHash(const APass, ASalt: string): string;
var
  hProv: HCRYPTPROV;
  hHash: HCRYPTHASH;
  HashLen: DWORD;
  buf: TBytes;
  SaltPass: string;
  Provider: string;
begin
  hProv := 0;
  hHash := 0;
  Result := '';

  if (Win32MajorVersion = 5) and (Win32MinorVersion = 1) then
    Provider := MS_ENH_RSA_AES_PROV_XP
  else
    Provider := MS_ENH_RSA_AES_PROV;

  if not CryptAcquireContext(hProv, nil, PChar(Provider), PROV_RSA_AES, CRYPT_VERIFYCONTEXT) then
    CryptAcquireContext(hProv, nil, PChar(Provider), PROV_RSA_AES, CRYPT_NEWKEYSET or CRYPT_VERIFYCONTEXT);

  if not CryptCreateHash(hProv, FSHA_Alg, 0, 0, hHash) then
    RaiseLastOSError;

  SaltPass := ASalt + APass;

  if CryptHashData(hHash, PByte(PChar(SaltPass)), (Length(SaltPass)) * SizeOf(Char), 0) then
  begin
    CryptGetHashParam(hHash, HP_HASHVAL, nil, HashLen, 0);
    SetLength(buf, HashLen);

    if CryptGetHashParam(hHash, HP_HASHVAL, @buf[0], HashLen, 0) then
      Result := BinToStr(buf)
    else
      RaiseLastOSError;

    CryptDestroyHash(hHash);
  end;

  CryptReleaseContext(hProv, 0);
end;

function TTXPCrypto.GenPwdHashA(const APass, ASalt: Ansistring): AnsiString;
var
  buf: TBytes;
begin
  buf := GenHash(ASalt + APass);
  Result := BinToStrA(buf);
end;

function TTXPCrypto.GenPwdHashBase64(const APass, ASalt: Ansistring): AnsiString;
var
  buf: TBytes;
begin
  buf := GenHash(ASalt + APass);
  Result := BinToBase64(buf);
end;

function TTXPCrypto.GenSalt(const ALen: Cardinal): string;
var
  hProv: HCRYPTPROV;
  Temp: TBytes;
begin
  // Generate salt of wanted length (binary length) it will be longer when converted to string
  if not CryptAcquireContext(hProv, nil, MS_ENHANCED_PROV, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT) then
    CryptAcquireContext(hProv, nil, MS_ENHANCED_PROV, PROV_RSA_FULL, CRYPT_NEWKEYSET or CRYPT_VERIFYCONTEXT);

  if hProv > 0 then
  try
    SetLength(Temp, ALen);
    if CryptGenRandom(hProv, ALen, @Temp[0]) then
      Result := BinToStr(Temp);
  finally
    CryptReleaseContext(hProv, 0);
  end;
end;

function TTXPCrypto.GenSaltA(const ALen: Cardinal): AnsiString;
var
  hProv: HCRYPTPROV;
  Temp: TBytes;
begin
  // Generate salt of wanted length (binary length) it will be longer when converted to string
  if not CryptAcquireContextA(hProv, nil, MS_ENHANCED_PROV, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT) then
    CryptAcquireContextA(hProv, nil, MS_ENHANCED_PROV, PROV_RSA_FULL, CRYPT_NEWKEYSET or CRYPT_VERIFYCONTEXT);

  if hProv > 0 then
  try
    SetLength(Temp, ALen);
    if CryptGenRandom(hProv, ALen, @Temp[0]) then
      Result := BinToStrA(Temp);
  finally
    CryptReleaseContext(hProv, 0);
  end;
end;

function TTXPCrypto.SHA1Hash(const AData: TBytes): TBytes;
begin
  SHA_Alg := CALG_SHA1;
  Result := GenHash(AData);
end;

end.

