{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryCryptoAPI.pas                          }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryCryptoAPI;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryTypes;

const
  CRYPT_USER_KEYSET = $1000;
  CERT_KEY_PROV_INFO_PROP_ID = 2;
  CRYPT_DELETEKEYSET = 2;
  PROV_RSA_FULL = 1;
  CRYPT_VERIFYCONTEXT = $F0000000;
  CRYPT_MACHINE_KEYSET = 32;
  CALG_MD5 = $8003;
  CALG_SHA1 = $8004;
  HP_HASHVAL = 2;
  X509_ASN_ENCODING = 1;
  PKCS_7_ASN_ENCODING = $10000;

{$IFDEF QPL_OS_WINDOWS}
function PFXIsPFXBlob(pPFX: Pointer): LongBool;
  stdcall; external 'crypt32.dll';
function PFXImportCertStore(pPFX: Pointer; szPassword: PWideChar;
  dwFlags: Cardinal): Cardinal;
  stdcall; external 'crypt32.dll';
function CertCloseStore(hCertStore: TQPLIntPtr): LongBool;
  stdcall; external 'crypt32.dll';
function CertEnumCertificatesInStore(hCertStore,
  hCertContext: TQPLIntPtr): Cardinal;
  stdcall; external 'crypt32.dll';
function CertFreeCertificateContext(hCertContext: TQPLIntPtr): LongBool;
  stdcall; external 'crypt32.dll';
function CertGetCertificateContextProperty(hCertContext: TQPLIntPtr; dwPropId: Cardinal;
  pvData: Pointer; var cbData: Cardinal): LongBool;
  stdcall; external 'crypt32.dll';
function CryptSignMessage(pSignPara: Pointer; fDetachedSignature: LongBool;
  cToBeSigned: Cardinal; pbToBeSigned: Pointer;
  pcbToBeSigned: Pointer; pbSignedBlob: Pointer;
  var cbSignedBlob: Cardinal): LongBool;
  stdcall; external 'crypt32.dll';
function CertGetNameString(hCertContext: TQPLIntPtr; dwType, dwFlags: Cardinal;
  pvTypePara, pszNameString: Pointer; cchNameString: Cardinal): Cardinal;
  stdcall; external 'crypt32.dll';

function CryptAcquireContextW(var hCryptProv: TQPLIntPtr; Container: PWideChar;
  Provider: PWideChar; dwProvType, dwFlags: Cardinal): LongBool;
  stdcall; external 'advapi32.dll';
function CryptReleaseContext(hCryptProv: TQPLIntPtr;
  dwFlags: Cardinal): LongBool;
  stdcall; external 'advapi32.dll';
function CryptCreateHash(hCryptProv: TQPLIntPtr; AlgId, hKey, dwFlags: Cardinal;
  var hHash: TQPLIntPtr): LongBool;
  stdcall; external 'advapi32.dll';
function CryptDestroyHash(hHash: TQPLIntPtr): LongBool;
  stdcall; external 'advapi32.dll';
function CryptHashData(hHash: TQPLIntPtr; Buffer: Pointer; dwDataLen,
  dwFlags: Cardinal): LongBool;
  stdcall; external 'advapi32.dll';
function CryptGetHashParam(hHash: TQPLIntPtr; dwParam: Cardinal; pbData: Pointer;
  var DataLen: Cardinal; dwFlags: Cardinal): LongBool;
  stdcall; external 'advapi32.dll';
{$ELSE}
function PFXIsPFXBlob(pPFX: Pointer): LongBool;
  stdcall;
function PFXImportCertStore(pPFX: Pointer; szPassword: PWideChar;
  dwFlags: Cardinal): Cardinal;
  stdcall;
function CertCloseStore(hCertStore: TQPLIntPtr): LongBool;
  stdcall;
function CertEnumCertificatesInStore(hCertStore,
  hCertContext: TQPLIntPtr): Cardinal;
  stdcall;
function CertFreeCertificateContext(hCertContext: TQPLIntPtr): LongBool;
  stdcall;
function CertGetCertificateContextProperty(hCertContext: TQPLIntPtr; dwPropId: Cardinal;
  pvData: Pointer; var cbData: Cardinal): LongBool;
  stdcall;
function CryptSignMessage(pSignPara: Pointer; fDetachedSignature: LongBool;
  cToBeSigned: Cardinal; pbToBeSigned: Pointer;
  pcbToBeSigned: Pointer; pbSignedBlob: Pointer;
  var cbSignedBlob: Cardinal): LongBool;
  stdcall;
function CertGetNameString(hCertContext: TQPLIntPtr; dwType, dwFlags: Cardinal;
  pvTypePara, pszNameString: Pointer; cchNameString: Cardinal): Cardinal;
  stdcall;

function CryptAcquireContextW(var hCryptProv: TQPLIntPtr; Container: PWideChar;
  Provider: PWideChar; dwProvType, dwFlags: Cardinal): LongBool;
  stdcall;
function CryptReleaseContext(hCryptProv: TQPLIntPtr;
  dwFlags: Cardinal): LongBool;
  stdcall;
function CryptCreateHash(hCryptProv: TQPLIntPtr; AlgId, hKey, dwFlags: Cardinal;
  var hHash: TQPLIntPtr): LongBool;
  stdcall;
function CryptDestroyHash(hHash: TQPLIntPtr): LongBool;
  stdcall;
function CryptHashData(hHash: TQPLIntPtr; Buffer: Pointer; dwDataLen,
  dwFlags: Cardinal): LongBool;
  stdcall;
function CryptGetHashParam(hHash: TQPLIntPtr; dwParam: Cardinal; pbData: Pointer;
  var DataLen: Cardinal; dwFlags: Cardinal): LongBool;
  stdcall;
{$ENDIF}

type
  CRYPT_KEY_PROV_INFO = record
    ContainerName: PWideChar;
    ProvName: PWideChar;
    ProvType: Cardinal;
    Flags: Cardinal;
    ProvParam: Cardinal;
    rgProvParam: Pointer;
    KeySpec: Cardinal;
  end;

  CERT_CONTEXT = record
    dwCertEncodingType: Cardinal;
    pbCertEncoded: PAnsiChar;
    cbCertEncoded: Cardinal;
    pCertInfo: Pointer;
    hCertStore: Cardinal;
  end;

  CRYPT_SIGN_MESSAGE_PARA = record
    cbSize: Cardinal;
    dwMsgEncodingType: Cardinal;
    pSigningCert: Cardinal;    // Certificate to sign
    HashAlgorithmObjId: PAnsiChar;
    HashAlgorithmcbData: Cardinal;
    HashAlgorithmpbData: Pointer;
    pvHashAuxInfo: Pointer;
    cMsgCert: Cardinal;        // Number of certificates in rgpMsgCert
    rgpMsgCert: Pointer;       // Array of certificates to include
    cMsgCrl: Cardinal;         // Number of CRLs
    rgpMsgCrl: Pointer;        // Array of CRLs
    cAuthAttr: Cardinal;       // Number of auth attributes
    rgAuthAttr: Pointer;       // Array of auth attributes
    cUnauthAttr: Cardinal;     // Number of unauth attributes
    rgUnauthAttr: Pointer;     // Array of unauth attributes
    dwFlags: Cardinal;
    dwInnerContentType: Cardinal;
  end;

implementation

{$IFNDEF QPL_OS_WINDOWS}
function PFXIsPFXBlob(pPFX: Pointer): LongBool; stdcall;
begin
  Result := False;
end;

function PFXImportCertStore(pPFX: Pointer; szPassword: PWideChar;
  dwFlags: Cardinal): Cardinal; stdcall;
begin
  Result := 0;
end;

function CertCloseStore(hCertStore: TQPLIntPtr): LongBool; stdcall;
begin
  Result := False;
end;

function CertEnumCertificatesInStore(hCertStore, hCertContext: TQPLIntPtr): Cardinal; stdcall;
begin
  Result := 0;
end;

function CertFreeCertificateContext(hCertContext: TQPLIntPtr): LongBool; stdcall;
begin
  Result := False;
end;

function CertGetCertificateContextProperty(hCertContext: TQPLIntPtr; dwPropId: Cardinal;
  pvData: Pointer; var cbData: Cardinal): LongBool; stdcall;
begin
  Result := False;
end;

function CryptSignMessage(pSignPara: Pointer; fDetachedSignature: LongBool;
  cToBeSigned: Cardinal; pbToBeSigned: Pointer;
  pcbToBeSigned: Pointer; pbSignedBlob: Pointer;
  var cbSignedBlob: Cardinal): LongBool; stdcall;
begin
  Result := False;
end;

function CertGetNameString(hCertContext: TQPLIntPtr; dwType, dwFlags: Cardinal;
  pvTypePara, pszNameString: Pointer; cchNameString: Cardinal): Cardinal;
  stdcall;
begin
  Result := 0;
end;

function CryptAcquireContextW(var hCryptProv: TQPLIntPtr; Container: PWideChar;
  Provider: PWideChar; dwProvType, dwFlags: Cardinal): LongBool;
  stdcall;
begin
  Result := False;
end;

function CryptReleaseContext(hCryptProv: TQPLIntPtr;
  dwFlags: Cardinal): LongBool;
  stdcall;
begin
  Result := False;
end;

function CryptCreateHash(hCryptProv: TQPLIntPtr; AlgId, hKey, dwFlags: Cardinal;
  var hHash: TQPLIntPtr): LongBool;
  stdcall;
begin
  Result := False;
end;

function CryptDestroyHash(hHash: TQPLIntPtr): LongBool;
  stdcall;
begin
  Result := False;
end;

function CryptHashData(hHash: TQPLIntPtr; Buffer: Pointer; dwDataLen,
  dwFlags: Cardinal): LongBool;
  stdcall;
begin
  Result := False;
end;

function CryptGetHashParam(hHash: TQPLIntPtr; dwParam: Cardinal; pbData: Pointer;
  var DataLen: Cardinal; dwFlags: Cardinal): LongBool;
  stdcall;
begin
  Result := False;
end;
{$ENDIF}

end.
