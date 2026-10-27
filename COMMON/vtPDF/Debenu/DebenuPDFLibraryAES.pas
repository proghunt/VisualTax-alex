{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryAES.pas                                }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryAES;

{$I DebenuPDFLibraryDefines.inc}

{$IFDEF QPL_OS_MAC}
  {$UNDEF QPL_NOVCL}
{$ENDIF}

interface

uses
  Classes, Sysutils;

function AESEncryptString(const Key, Plaintext: AnsiString): AnsiString;
function AESEncryptStringNoPadding(const Key, IV, Plaintext: AnsiString): AnsiString;
function AESDecryptString(const Key, Ciphertext: AnsiString): AnsiString;
function AES256EncryptString(const Key, IV, Plaintext: AnsiString): AnsiString;
function AES256DecryptString(const Key, IV, Ciphertext: AnsiString): AnsiString;

implementation

{$IFDEF QPL_NOVCL}
function AESEncryptString(const Key, Plaintext: AnsiString): AnsiString;
begin
  Result := '';
end;

function AESDecryptString(const Key, Ciphertext: AnsiString): AnsiString;
begin
  Result := '';
end;

function AES256EncryptString(const Key, IV, Plaintext: AnsiString): AnsiString;
begin
  Result := '';
end;

function AES256DecryptString(const Key, IV, Ciphertext: AnsiString): AnsiString;
begin
  Result := '';
end;

function AESEncryptStringNoPadding(const Key, IV, Plaintext: AnsiString): AnsiString;
begin
  Result := '';
end;
{$ELSE}
uses
  DebenuPDFLibraryExtra;

type
  Taes_encrypt_ctx = record
    ks: array[0..79] of Cardinal;
    inf: Cardinal;
  end;

  Taes_decrypt_ctx = Taes_encrypt_ctx;

{$IFDEF WIN64}
{$L obj64\aes_modes.obj}
{$L obj64\aescrypt.obj}
{$L obj64\aeskey.obj}
{$L obj64\aestab.obj}
{$ELSE}
{$L obj\aes_modes.obj}
{$L obj\aescrypt.obj}
{$L obj\aeskey.obj}
{$L obj\aestab.obj}

procedure _memset (var Dest; Value, Count: Integer); cdecl;
begin
  FillChar(Dest, Count, AnsiChar(Value));
end;

procedure _memcpy(var Dest; const Source; Count: Integer); cdecl;
begin
  Move(Source, Dest, Count);
end;

procedure __assert(Test: Integer); cdecl;
begin
  // Do nothing - just needed for it to compile
end;

{$ENDIF}

function aes_init: Integer; external;
function aes_encrypt_key(key: PAnsiChar; key_len: Integer; var cx: Taes_encrypt_ctx): Integer; external;
function aes_decrypt_key(key: PAnsiChar; key_len: Integer; var cx: Taes_decrypt_ctx): Integer; external;
function aes_cbc_encrypt(ibuf: PAnsiChar; obuf: PAnsiChar; len: Integer; iv: PAnsiChar; var cx: Taes_encrypt_ctx): Integer; external;
function aes_cbc_decrypt(ibuf: PAnsiChar; obuf: PAnsiChar; len: Integer; iv: PAnsiChar; var cx: Taes_decrypt_ctx): Integer; external;

procedure qplaes256enc(plaintext: PAnsiChar; plaintextlen: Integer; key: PAnsiChar; keylen: Integer; iv: PAnsiChar; ciphertext: PAnsiChar);
var
  aes: Taes_encrypt_ctx;
  local_iv: array[0..15] of Byte;
begin
  Move(iv^, local_iv[0], 16);
  aes_init;
  aes_encrypt_key(key, keylen * 8, aes);
	aes_cbc_encrypt(plaintext, ciphertext, plaintextlen, @local_iv[0], aes);
end;

procedure qplaes256dec(ciphertext: PAnsiChar; ciphertextlen: Integer; key: PAnsiChar; keylen: Integer; iv: PAnsiChar; plaintext: PAnsiChar);
var
  aes: Taes_decrypt_ctx;
  local_iv: array[0..15] of Byte;
begin
  Move(iv^, local_iv[0], 16);
  aes_init;
  aes_decrypt_key(key, keylen * 8, aes);
	aes_cbc_decrypt(ciphertext, plaintext, ciphertextlen, @local_iv[0], aes);
end;

function AESEncryptString(const Key, Plaintext: AnsiString): AnsiString;
var
  Padded: AnsiString;
  M: Integer;
  IV: AnsiString;
  RandDWords: array[0..3] of Cardinal;
  PadBytes: AnsiString;
begin
  SetLength(IV, 16);
  RandDWords[0] := Random($7FFFFFFF);
  RandDWords[1] := Random($7FFFFFFF);
  RandDWords[2] := Random($7FFFFFFF);
  RandDWords[3] := Random($7FFFFFFF);
  Move(RandDWords[0], IV[1], 16);

  M := Length(Plaintext);

  SetLength(PadBytes, 16 - (M mod 16));
  FillChar(PadBytes[1], Length(PadBytes), 16 - (M mod 16));

  Padded := Plaintext + PadBytes;

  Result := IV + AES256EncryptString(Key, IV, Padded);
end;

function AESEncryptStringNoPadding(const Key, IV, Plaintext: AnsiString): AnsiString;
begin
  Result := AES256EncryptString(Key, IV, PlainText);
end;

function AES256EncryptString(const Key, IV, Plaintext: AnsiString): AnsiString;
begin
  SetLength(Result, Length(Plaintext));
  if (Length(Plaintext) > 0) then
  begin
    qplaes256enc(@Plaintext[1], Length(Plaintext), @Key[1], Length(Key), @IV[1], @Result[1]);
  end;
end;

function AES256DecryptString(const Key, IV, Ciphertext: AnsiString): AnsiString;
begin
  SetLength(Result, Length(Ciphertext));
  if (Length(Ciphertext) > 0) then
  begin
    qplaes256dec(@Ciphertext[1], Length(Ciphertext), @Key[1], Length(Key), @IV[1], @Result[1]);
  end;
end;

function AESDecryptString(const Key, Ciphertext: AnsiString): AnsiString;
var
  IV: AnsiString;
  Input: AnsiString;
  LastByte: Integer;
  ValidPadding: Boolean;
  PadCheckPos: Integer;
begin
  IV := QPLCopy(Ciphertext, 1, 16);
  Input := QPLCopy(Ciphertext, 17, MaxInt);
  Result := AES256DecryptString(Key, IV, Input);
  ValidPadding := False;
  if (Length(Result) > 0) then
  begin
    LastByte := Ord(Result[Length(Result)]);
    if ((LastByte >= 1) and (LastByte <= 16)) then
    begin
      ValidPadding := True;
      for PadCheckPos := Length(Result) - LastByte + 1 to Length(Result) do
      begin
        if (PadCheckPos >= 1) then
        begin
          if (Ord(Result[PadCheckPos]) <> LastByte) then
          begin
            ValidPadding := False;
          end;
        end;
      end;
    end;
    if (ValidPadding) then
    begin
      SetLength(Result, Length(Result) - LastByte);
    end else
    begin
      Result := '';
    end;
  end;
end;
{$ENDIF}

end.
