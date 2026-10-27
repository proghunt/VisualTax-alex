{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryDigest.pas                             }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryDigest;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, SysUtils,
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  DebenuPDFLibraryCryptoAPI, DebenuPDFLibraryExtra;

{$UNDEF QPL_MD5_CRYPTOAPI}
{$DEFINE QPL_MD5_MAC}

type
  MD5Digest = array[0..15] of Byte;
  TQPLSHA256Digest = array[0..31] of Byte;
  TQPLSHA384Digest = array[0..47] of Byte;
  TQPLSHA512Digest = array[0..63] of Byte;

function MD5File(const FileName: WideString): MD5Digest;
function MD5Match(D1, D2: MD5Digest): Boolean;
function MD5DigestToString(D: MD5Digest): AnsiString;
function MD5String(M: AnsiString): MD5Digest;
function MD5Print(D: MD5Digest): AnsiString;
function UMD5(const S: AnsiString): AnsiString;

function MD5Stream(Input: TStream): AnsiString;

function SHA1StreamRange(Input: TStream; FirstLength,
  SecondStart, SecondLength: Int64): AnsiString;

function SHA256ByteArray(Input: array of Byte): TQPLSHA256Digest;
function SHA384ByteArray(Input: array of Byte): TQPLSHA384Digest;
function SHA512ByteArray(Input: array of Byte): TQPLSHA512Digest;

type
  EDCP_hash= class(Exception);

  TDCP_hash = class
  protected
    fInitialized: boolean;  { Whether or not the algorithm has been initialized }
  public
    property Initialized: boolean
      read fInitialized;
    procedure Init; virtual; abstract;
    procedure Final(var Digest); virtual; abstract;
    procedure Burn; virtual; abstract;
    procedure Update(const Buffer; Size: longword); virtual; abstract;
  end;

  TDCP_sha256 = class(TDCP_hash)
  protected
    LenHi, LenLo: longword;
    Index: DWord;
    CurrentHash: array[0..7] of DWord;
    HashBuffer: array[0..63] of byte;
    procedure Compress;
  public
    procedure Init; override;
    procedure Final(var Digest); override;
    procedure Burn; override;
    procedure Update(const Buffer; Size: longword); override;
  end;

  TDCP_sha512base= class(TDCP_hash)
  protected
    LenHi, LenLo: int64;
    Index: DWord;
    CurrentHash: array[0..7] of int64;
    HashBuffer: array[0..127] of byte;
    procedure Compress;
  public
    procedure Update(const Buffer; Size: longword); override;
    procedure Burn; override;
  end;

  TDCP_sha384= class(TDCP_sha512base)
  public
    procedure Init; override;
    procedure Final(var Digest); override;
  end;

  TDCP_sha512= class(TDCP_sha512base)
  public
    procedure Init; override;
    procedure Final(var Digest); override;
  end;

implementation

uses
{$IFDEF QPL_USEFPCMD5}
  md5,
{$ENDIF}
  DebenuPDFLibraryTypes;

function MD5String(M: AnsiString): MD5Digest;
var
  MS: TMemoryStream;
  Hash: AnsiString;
begin
  if Length(M) > 0 then
  begin
    MS := TMemoryStream.Create;
    try
      MS.Write(M[1], Length(M));
      Hash := MD5Stream(MS);
      Move(Hash[1], Result[0], 16);
    finally
      MS.Free;
    end;
  end else
  begin
    Result[0] := $d4;
    Result[1] := $1d;
    Result[2] := $8c;
    Result[3] := $d9;
    Result[4] := $8f;
    Result[5] := $00;
    Result[6] := $b2;
    Result[7] := $04;
    Result[8] := $e9;
    Result[9] := $80;
    Result[10] := $09;
    Result[11] := $98;
    Result[12] := $ec;
    Result[13] := $f8;
    Result[14] := $42;
    Result[15] := $7e;
  end;
end;

function MD5File(const FileName: WideString): MD5Digest;
var
  FS: TQuickPDFWideFileStream;
  Hash: AnsiString;
begin
  FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Hash := MD5Stream(FS);
    Move(Hash[1], Result[0], 16);
      finally
    FS.Free;
      end;
end;

function MD5Print(D: MD5Digest): AnsiString;
var
  I: Byte;
const
  Digits: array[0..15] of AnsiChar = '0123456789abcdef';
begin
  Result := '';
  for I := 0 to 15 do
    Result := Result + Digits[(D[I] shr 4) and $0f] + Digits[D[I] and $0f];
end;

function MD5Match(D1, D2: MD5Digest): Boolean;
var
  I: Byte;
begin
  I := 0;
  Result := True;
  while Result and (I < 16) do
  begin
    Result := D1[I] = D2[I];
    Inc(I);
  end;
end;

function MD5DigestToString(D: MD5Digest): AnsiString;
var
  I: Byte;
begin
  SetLength(Result, 16);
  for I := 0 to 15 do Result[I + 1] := AnsiChar(D[I]);
end;

function UMD5(const S: AnsiString): AnsiString;
begin
  Result := QPLUpperCase(MD5Print(MD5String(S)));
end;

{$IFDEF QPL_MD5_FPC}
function MD5Stream(Input: TStream): AnsiString;
var
  Buffer: AnsiString;
  Digest: md5.TMD5Digest;
begin
  Result := '';
  SetLength(Buffer, Input.Size);
  if (Length(Buffer) > 0) then
  begin
    Input.Seek(0, soFromBeginning);
    Input.Read(Buffer[1], Length(Buffer));
    Digest := md5.MD5String(Buffer);
    SetLength(Result, 16);
    Move(Digest[0], Result[1], 16);
  end;
end;
{$ENDIF}

{$IFDEF QPL_MD5_CRYPTOAPI}
function MD5Stream(Input: TStream): AnsiString;
var
  hCryptProv: TQPLIntPtr;
  hHash: TQPLIntPtr;
  BlockData: AnsiString;
  Valid: LongBool;
  HashLength: Cardinal;
  InputLength: Int64;
  TotalRead: Int64;
  ReadSize: Cardinal;
begin
  Result := '';
  if CryptAcquireContextW(hCryptProv, nil, nil, PROV_RSA_FULL,
    CRYPT_VERIFYCONTEXT or CRYPT_MACHINE_KEYSET) then
  begin
    if CryptCreateHash(hCryptProv, CALG_MD5, 0, 0, hHash) then
    begin
      Input.Seek(0, soFromBeginning);

      Valid := True;
      TotalRead := 0;
      ReadSize := 8000;
      InputLength := Input.Size;

      repeat
        if TotalRead + ReadSize > InputLength then
          ReadSize := InputLength - TotalRead;
        SetLength(BlockData, ReadSize);
        Input.Read(BlockData[1], Length(BlockData));
        Valid := Valid and CryptHashData(hHash, @BlockData[1], Length(BlockData), 0);
        Inc(TotalRead, ReadSize);
      until TotalRead >= InputLength;

      if Valid then
      begin
        SetLength(Result, 16);
        HashLength := 16;
        if CryptGetHashParam(hHash, HP_HASHVAL, @Result[1], HashLength, 0) then
        begin
          if HashLength < 16 then SetLength(Result, 0);
        end;
      end;

      CryptDestroyHash(hHash);
    end;
    CryptReleaseContext(hCryptProv, 0);
  end;
end;
{$ENDIF}

function SHA1StreamRange(Input: TStream; FirstLength,
  SecondStart, SecondLength: Int64): AnsiString;
var
  hCryptProv: TQPLIntPtr;
  hHash: TQPLIntPtr;
  BlockData: AnsiString;
  Valid: LongBool;
  HashLength: Cardinal;
  ReadSize: Cardinal;
  TotalRead: Int64;
begin
  Result := '';
  if CryptAcquireContextW(hCryptProv, nil, nil, PROV_RSA_FULL,
    CRYPT_VERIFYCONTEXT or CRYPT_MACHINE_KEYSET) then
  begin
    if CryptCreateHash(hCryptProv, CALG_SHA1, 0, 0, hHash) then
    begin
      Input.Seek(0, soFromBeginning);

      Valid := True;
      TotalRead := 0;
      ReadSize := 8000;

      repeat
        if TotalRead + ReadSize > FirstLength then
          ReadSize := FirstLength - TotalRead;
        SetLength(BlockData, ReadSize);
        Input.Read(BlockData[1], Length(BlockData));
        Valid := Valid and CryptHashData(hHash, @BlockData[1], Length(BlockData), 0);
        Inc(TotalRead, ReadSize);
      until TotalRead >= FirstLength;

      Input.Seek(SecondStart, soBeginning);
      TotalRead := 0;
      ReadSize := 8000;

      repeat
        if TotalRead + ReadSize > SecondLength then
          ReadSize := SecondLength - TotalRead;
        SetLength(BlockData, ReadSize);
        Input.Read(BlockData[1], Length(BlockData));
        Valid := Valid and CryptHashData(hHash, @BlockData[1], Length(BlockData), 0);
        Inc(TotalRead, ReadSize);
      until TotalRead >= SecondLength;

      if Valid then
      begin
        SetLength(Result, 20);
        HashLength := 20;
        if CryptGetHashParam(hHash, HP_HASHVAL, @Result[1], HashLength, 0) then
        begin
          if HashLength < 20 then SetLength(Result, 0);
        end;
      end;

      CryptDestroyHash(hHash);
    end;
    CryptReleaseContext(hCryptProv, 0);
  end;
end;

{******************************************************************************}
{* DCPcrypt v2.0 written by David Barton (crypto@cityinthesky.co.uk) **********}
{******************************************************************************}
{* A binary compatible implementation of SHA256 *******************************}
{******************************************************************************}
{* Copyright (c) 1999-2002 David Barton                                       *}
{* Permission is hereby granted, free of charge, to any person obtaining a    *}
{* copy of this software and associated documentation files (the "Software"), *}
{* to deal in the Software without restriction, including without limitation  *}
{* the rights to use, copy, modify, merge, publish, distribute, sublicense,   *}
{* and/or sell copies of the Software, and to permit persons to whom the      *}
{* Software is furnished to do so, subject to the following conditions:       *}
{*                                                                            *}
{* The above copyright notice and this permission notice shall be included in *}
{* all copies or substantial portions of the Software.                        *}
{*                                                                            *}
{* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *}
{* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   *}
{* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    *}
{* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *}
{* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    *}
{* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER        *}
{* DEALINGS IN THE SOFTWARE.                                                  *}
{******************************************************************************}

{$R-}{$Q-}

function SwapDWord(a: dword): dword;
begin
  Result:= ((a and $FF) shl 24) or ((a and $FF00) shl 8) or ((a and $FF0000) shr 8) or ((a and $FF000000) shr 24);
end;

procedure TDCP_sha256.Compress;
var
  a, b, c, d, e, f, g, h, t1, t2: DWord;
  W: array[0..63] of DWord;
  i: longword;
begin
  Index:= 0;
  a:= CurrentHash[0]; b:= CurrentHash[1]; c:= CurrentHash[2]; d:= CurrentHash[3];
  e:= CurrentHash[4]; f:= CurrentHash[5]; g:= CurrentHash[6]; h:= CurrentHash[7];
  Move(HashBuffer,W,Sizeof(HashBuffer));
  for i:= 0 to 15 do
    W[i]:= SwapDWord(W[i]);
  for i:= 16 to 63 do
    W[i]:= (((W[i-2] shr 17) or (W[i-2] shl 15)) xor ((W[i-2] shr 19) or (W[i-2] shl 13)) xor
      (W[i-2] shr 10)) + W[i-7] + (((W[i-15] shr 7) or (W[i-15] shl 25)) xor
      ((W[i-15] shr 18) or (W[i-15] shl 14)) xor (W[i-15] shr 3)) + W[i-16];
{
Non-optimised version
  for i:= 0 to 63 do
  begin
    t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) +
      ((e and f) xor (not e and g)) + K[i] + W[i];
    t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) +
      ((a and b) xor (a and c) xor (b and c));
    h:= g; g:= f; f:= e; e:= d + t1; d:= c; c:= b; b:= a; a:= t1 + t2;
  end;
}

  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $428a2f98 + W[0]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $71374491 + W[1]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $b5c0fbcf + W[2]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $e9b5dba5 + W[3]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $3956c25b + W[4]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $59f111f1 + W[5]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $923f82a4 + W[6]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $ab1c5ed5 + W[7]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $d807aa98 + W[8]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $12835b01 + W[9]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $243185be + W[10]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $550c7dc3 + W[11]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $72be5d74 + W[12]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $80deb1fe + W[13]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $9bdc06a7 + W[14]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $c19bf174 + W[15]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $e49b69c1 + W[16]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $efbe4786 + W[17]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $0fc19dc6 + W[18]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $240ca1cc + W[19]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $2de92c6f + W[20]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $4a7484aa + W[21]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $5cb0a9dc + W[22]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $76f988da + W[23]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $983e5152 + W[24]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $a831c66d + W[25]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $b00327c8 + W[26]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $bf597fc7 + W[27]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $c6e00bf3 + W[28]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $d5a79147 + W[29]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $06ca6351 + W[30]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $14292967 + W[31]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $27b70a85 + W[32]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $2e1b2138 + W[33]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $4d2c6dfc + W[34]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $53380d13 + W[35]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $650a7354 + W[36]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $766a0abb + W[37]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $81c2c92e + W[38]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $92722c85 + W[39]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $a2bfe8a1 + W[40]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $a81a664b + W[41]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $c24b8b70 + W[42]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $c76c51a3 + W[43]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $d192e819 + W[44]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $d6990624 + W[45]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $f40e3585 + W[46]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $106aa070 + W[47]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $19a4c116 + W[48]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $1e376c08 + W[49]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $2748774c + W[50]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $34b0bcb5 + W[51]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $391c0cb3 + W[52]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $4ed8aa4a + W[53]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $5b9cca4f + W[54]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $682e6ff3 + W[55]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $748f82ee + W[56]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $78a5636f + W[57]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $84c87814 + W[58]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $8cc70208 + W[59]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $90befffa + W[60]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $a4506ceb + W[61]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $bef9a3f7 + W[62]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $c67178f2 + W[63]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;

  CurrentHash[0]:= CurrentHash[0] + a;
  CurrentHash[1]:= CurrentHash[1] + b;
  CurrentHash[2]:= CurrentHash[2] + c;
  CurrentHash[3]:= CurrentHash[3] + d;
  CurrentHash[4]:= CurrentHash[4] + e;
  CurrentHash[5]:= CurrentHash[5] + f;
  CurrentHash[6]:= CurrentHash[6] + g;
  CurrentHash[7]:= CurrentHash[7] + h;
  FillChar(W,Sizeof(W),0);
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
end;

procedure TDCP_sha256.Init;
begin
  Burn;
  CurrentHash[0]:= $6a09e667;
  CurrentHash[1]:= $bb67ae85;
  CurrentHash[2]:= $3c6ef372;
  CurrentHash[3]:= $a54ff53a;
  CurrentHash[4]:= $510e527f;
  CurrentHash[5]:= $9b05688c;
  CurrentHash[6]:= $1f83d9ab;
  CurrentHash[7]:= $5be0cd19;
  fInitialized:= true;
end;

procedure TDCP_sha256.Burn;
begin
  LenHi:= 0; LenLo:= 0;
  Index:= 0;
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
  FillChar(CurrentHash,Sizeof(CurrentHash),0);
  fInitialized:= false;
end;

procedure TDCP_sha256.Update(const Buffer; Size: longword);
var
  PBuf: ^byte;
begin
  if not fInitialized then
    raise EDCP_hash.Create('Hash not initialized');

  Inc(LenHi,Size shr 29);
  Inc(LenLo,Size*8);
  if LenLo< (Size*8) then
    Inc(LenHi);

  PBuf:= @Buffer;
  while Size> 0 do
  begin
    if (Sizeof(HashBuffer)-Index)<= DWord(Size) then
    begin
      Move(PBuf^,HashBuffer[Index],Sizeof(HashBuffer)-Index);
      Dec(Size,Sizeof(HashBuffer)-Index);
      Inc(PBuf,Sizeof(HashBuffer)-Index);
      Compress;
    end
    else
    begin
      Move(PBuf^,HashBuffer[Index],Size);
      Inc(Index,Size);
      Size:= 0;
    end;
  end;
end;

procedure TDCP_sha256.Final(var Digest);
begin
  if not fInitialized then
    raise EDCP_hash.Create('Hash not initialized');
  HashBuffer[Index]:= $80;
  if Index>= 56 then
    Compress;
  PDWord(@HashBuffer[56])^:= SwapDWord(LenHi);
  PDWord(@HashBuffer[60])^:= SwapDWord(LenLo);
  Compress;
  CurrentHash[0]:= SwapDWord(CurrentHash[0]);
  CurrentHash[1]:= SwapDWord(CurrentHash[1]);
  CurrentHash[2]:= SwapDWord(CurrentHash[2]);
  CurrentHash[3]:= SwapDWord(CurrentHash[3]);
  CurrentHash[4]:= SwapDWord(CurrentHash[4]);
  CurrentHash[5]:= SwapDWord(CurrentHash[5]);
  CurrentHash[6]:= SwapDWord(CurrentHash[6]);
  CurrentHash[7]:= SwapDWord(CurrentHash[7]);
  Move(CurrentHash,Digest,Sizeof(CurrentHash));
  Burn;
end;

function SwapDWord64(a: int64): int64;
begin
  Result:= ((a and $FF) shl 56) or ((a and $FF00) shl 40) or ((a and $FF0000) shl 24) or ((a and $FF000000) shl 8) or
    ((a and $FF00000000) shr 8) or ((a and $FF0000000000) shr 24) or ((a and $FF000000000000) shr 40) or ((a and $FF00000000000000) shr 56);
end;

procedure TDCP_sha512base.Compress;
var
  a, b, c, d, e, f, g, h, t1, t2: int64;
  W: array[0..79] of int64;
  i: longword;
begin
  Index:= 0;
  a:= CurrentHash[0]; b:= CurrentHash[1]; c:= CurrentHash[2]; d:= CurrentHash[3];
  e:= CurrentHash[4]; f:= CurrentHash[5]; g:= CurrentHash[6]; h:= CurrentHash[7];
  Move(HashBuffer,W,Sizeof(HashBuffer));
  for i:= 0 to 15 do
    W[i]:= SwapDWord64(W[i]);
  for i:= 16 to 79 do
    W[i]:= (((W[i-2] shr 19) or (W[i-2] shl 45)) xor ((W[i-2] shr 61) or (W[i-2] shl 3)) xor
      (W[i-2] shr 6)) + W[i-7] + (((W[i-15] shr 1) or (W[i-15] shl 63)) xor ((W[i-15] shr 8) or
      (W[i-15] shl 56)) xor (W[i-15] shr 7)) + W[i-16];

{
Non-optimised version
  for i:= 0 to 79 do
  begin
    t1:= h + (((e shr 14) or (e shl 50)) xor ((e shr 18) or (e shl 46)) xor ((e shr 41) or (e shl 23))) +
      ((e and f) xor (not e and g)) + K[i] + W[i];
    t2:= (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30)) xor ((a shr 39) or (a shl 25))) +
      ((a and b) xor (a and c) xor (b and c));
    h:= g; g:= f; f:= e; e:= d + t1; d:= c; c:= b; b:= a; a:= t1 + t2;
  end;
}

  t1:= h + (((e shr 14) or (e shl 50)) xor ((e shr 18) or (e shl 46)) xor ((e shr 41) or (e shl 23))) + ((e and f) xor (not e and g)) + $428a2f98d728ae22 + W[0]; t2:= (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30)) xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and c) xor (b and c)); d:= d + t1; h:= t1 + t2;
  t1:= g + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46)) xor ((d shr 41) or (d shl 23))) + ((d and e) xor (not d and f)) + $7137449123ef65cd + W[1]; t2:= (((h shr 28) or (h shl 36)) xor ((h shr 34) or (h shl 30)) xor ((h shr 39) or (h shl 25))) + ((h and a) xor (h and b) xor (a and b)); c:= c + t1; g:= t1 + t2;
  t1:= f + (((c shr 14) or (c shl 50)) xor ((c shr 18) or (c shl 46)) xor ((c shr 41) or (c shl 23))) + ((c and d) xor (not c and e)) + $b5c0fbcfec4d3b2f + W[2]; t2:= (((g shr 28) or (g shl 36)) xor ((g shr 34) or (g shl 30)) xor ((g shr 39) or (g shl 25))) + ((g and h) xor (g and a) xor (h and a)); b:= b + t1; f:= t1 + t2;
  t1:= e + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46)) xor ((b shr 41) or (b shl 23))) + ((b and c) xor (not b and d)) + $e9b5dba58189dbbc + W[3]; t2:= (((f shr 28) or (f shl 36)) xor ((f shr 34) or (f shl 30)) xor ((f shr 39) or (f shl 25))) + ((f and g) xor (f and h) xor (g and h)); a:= a + t1; e:= t1 + t2;
  t1:= d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46)) xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and c)) + $3956c25bf348b538 + W[4]; t2:= (((e shr 28) or (e shl 36)) xor ((e shr 34) or (e shl 30)) xor ((e shr 39) or (e shl 25))) + ((e and f) xor (e and g) xor (f and g)); h:= h + t1; d:= t1 + t2;
  t1:= c + (((h shr 14) or (h shl 50)) xor ((h shr 18) or (h shl 46)) xor ((h shr 41) or (h shl 23))) + ((h and a) xor (not h and b)) + $59f111f1b605d019 + W[5]; t2:= (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30)) xor ((d shr 39) or (d shl 25))) + ((d and e) xor (d and f) xor (e and f)); g:= g + t1; c:= t1 + t2;
  t1:= b + (((g shr 14) or (g shl 50)) xor ((g shr 18) or (g shl 46)) xor ((g shr 41) or (g shl 23))) + ((g and h) xor (not g and a)) + $923f82a4af194f9b + W[6]; t2:= (((c shr 28) or (c shl 36)) xor ((c shr 34) or (c shl 30)) xor ((c shr 39) or (c shl 25))) + ((c and d) xor (c and e) xor (d and e)); f:= f + t1; b:= t1 + t2;
  t1:= a + (((f shr 14) or (f shl 50)) xor ((f shr 18) or (f shl 46)) xor ((f shr 41) or (f shl 23))) + ((f and g) xor (not f and h)) + $ab1c5ed5da6d8118 + W[7]; t2:= (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30)) xor ((b shr 39) or (b shl 25))) + ((b and c) xor (b and d) xor (c and d)); e:= e + t1; a:= t1 + t2;
  t1:= h + (((e shr 14) or (e shl 50)) xor ((e shr 18) or (e shl 46)) xor ((e shr 41) or (e shl 23))) + ((e and f) xor (not e and g)) + $d807aa98a3030242 + W[8]; t2:= (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30)) xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and c) xor (b and c)); d:= d + t1; h:= t1 + t2;
  t1:= g + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46)) xor ((d shr 41) or (d shl 23))) + ((d and e) xor (not d and f)) + $12835b0145706fbe + W[9]; t2:= (((h shr 28) or (h shl 36)) xor ((h shr 34) or (h shl 30)) xor ((h shr 39) or (h shl 25))) + ((h and a) xor (h and b) xor (a and b)); c:= c + t1; g:= t1 + t2;
  t1:= f + (((c shr 14) or (c shl 50)) xor ((c shr 18) or (c shl 46)) xor ((c shr 41) or (c shl 23))) + ((c and d) xor (not c and e)) + $243185be4ee4b28c + W[10]; t2:= (((g shr 28) or (g shl 36)) xor ((g shr 34) or (g shl 30)) xor ((g shr 39) or (g shl 25))) + ((g and h) xor (g and a) xor (h and a)); b:= b + t1; f:= t1 + t2;
  t1:= e + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46)) xor ((b shr 41) or (b shl 23))) + ((b and c) xor (not b and d)) + $550c7dc3d5ffb4e2 + W[11]; t2:= (((f shr 28) or (f shl 36)) xor ((f shr 34) or (f shl 30)) xor ((f shr 39) or (f shl 25))) + ((f and g) xor (f and h) xor (g and h)); a:= a + t1; e:= t1 + t2;
  t1:= d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46)) xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and c)) + $72be5d74f27b896f + W[12]; t2:= (((e shr 28) or (e shl 36)) xor ((e shr 34) or (e shl 30)) xor ((e shr 39) or (e shl 25))) + ((e and f) xor (e and g) xor (f and g)); h:= h + t1; d:= t1 + t2;
  t1:= c + (((h shr 14) or (h shl 50)) xor ((h shr 18) or (h shl 46)) xor ((h shr 41) or (h shl 23))) + ((h and a) xor (not h and b)) + $80deb1fe3b1696b1 + W[13]; t2:= (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30)) xor ((d shr 39) or (d shl 25))) + ((d and e) xor (d and f) xor (e and f)); g:= g + t1; c:= t1 + t2;
  t1:= b + (((g shr 14) or (g shl 50)) xor ((g shr 18) or (g shl 46)) xor ((g shr 41) or (g shl 23))) + ((g and h) xor (not g and a)) + $9bdc06a725c71235 + W[14]; t2:= (((c shr 28) or (c shl 36)) xor ((c shr 34) or (c shl 30)) xor ((c shr 39) or (c shl 25))) + ((c and d) xor (c and e) xor (d and e)); f:= f + t1; b:= t1 + t2;
  t1:= a + (((f shr 14) or (f shl 50)) xor ((f shr 18) or (f shl 46)) xor ((f shr 41) or (f shl 23))) + ((f and g) xor (not f and h)) + $c19bf174cf692694 + W[15]; t2:= (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30)) xor ((b shr 39) or (b shl 25))) + ((b and c) xor (b and d) xor (c and d)); e:= e + t1; a:= t1 + t2;
  t1:= h + (((e shr 14) or (e shl 50)) xor ((e shr 18) or (e shl 46)) xor ((e shr 41) or (e shl 23))) + ((e and f) xor (not e and g)) + $e49b69c19ef14ad2 + W[16]; t2:= (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30)) xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and c) xor (b and c)); d:= d + t1; h:= t1 + t2;
  t1:= g + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46)) xor ((d shr 41) or (d shl 23))) + ((d and e) xor (not d and f)) + $efbe4786384f25e3 + W[17]; t2:= (((h shr 28) or (h shl 36)) xor ((h shr 34) or (h shl 30)) xor ((h shr 39) or (h shl 25))) + ((h and a) xor (h and b) xor (a and b)); c:= c + t1; g:= t1 + t2;
  t1:= f + (((c shr 14) or (c shl 50)) xor ((c shr 18) or (c shl 46)) xor ((c shr 41) or (c shl 23))) + ((c and d) xor (not c and e)) + $0fc19dc68b8cd5b5 + W[18]; t2:= (((g shr 28) or (g shl 36)) xor ((g shr 34) or (g shl 30)) xor ((g shr 39) or (g shl 25))) + ((g and h) xor (g and a) xor (h and a)); b:= b + t1; f:= t1 + t2;
  t1:= e + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46)) xor ((b shr 41) or (b shl 23))) + ((b and c) xor (not b and d)) + $240ca1cc77ac9c65 + W[19]; t2:= (((f shr 28) or (f shl 36)) xor ((f shr 34) or (f shl 30)) xor ((f shr 39) or (f shl 25))) + ((f and g) xor (f and h) xor (g and h)); a:= a + t1; e:= t1 + t2;
  t1:= d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46)) xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and c)) + $2de92c6f592b0275 + W[20]; t2:= (((e shr 28) or (e shl 36)) xor ((e shr 34) or (e shl 30)) xor ((e shr 39) or (e shl 25))) + ((e and f) xor (e and g) xor (f and g)); h:= h + t1; d:= t1 + t2;
  t1:= c + (((h shr 14) or (h shl 50)) xor ((h shr 18) or (h shl 46)) xor ((h shr 41) or (h shl 23))) + ((h and a) xor (not h and b)) + $4a7484aa6ea6e483 + W[21]; t2:= (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30)) xor ((d shr 39) or (d shl 25))) + ((d and e) xor (d and f) xor (e and f)); g:= g + t1; c:= t1 + t2;
  t1:= b + (((g shr 14) or (g shl 50)) xor ((g shr 18) or (g shl 46)) xor ((g shr 41) or (g shl 23))) + ((g and h) xor (not g and a)) + $5cb0a9dcbd41fbd4 + W[22]; t2:= (((c shr 28) or (c shl 36)) xor ((c shr 34) or (c shl 30)) xor ((c shr 39) or (c shl 25))) + ((c and d) xor (c and e) xor (d and e)); f:= f + t1; b:= t1 + t2;
  t1:= a + (((f shr 14) or (f shl 50)) xor ((f shr 18) or (f shl 46)) xor ((f shr 41) or (f shl 23))) + ((f and g) xor (not f and h)) + $76f988da831153b5 + W[23]; t2:= (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30)) xor ((b shr 39) or (b shl 25))) + ((b and c) xor (b and d) xor (c and d)); e:= e + t1; a:= t1 + t2;
  t1:= h + (((e shr 14) or (e shl 50)) xor ((e shr 18) or (e shl 46)) xor ((e shr 41) or (e shl 23))) + ((e and f) xor (not e and g)) + $983e5152ee66dfab + W[24]; t2:= (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30)) xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and c) xor (b and c)); d:= d + t1; h:= t1 + t2;
  t1:= g + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46)) xor ((d shr 41) or (d shl 23))) + ((d and e) xor (not d and f)) + $a831c66d2db43210 + W[25]; t2:= (((h shr 28) or (h shl 36)) xor ((h shr 34) or (h shl 30)) xor ((h shr 39) or (h shl 25))) + ((h and a) xor (h and b) xor (a and b)); c:= c + t1; g:= t1 + t2;
  t1:= f + (((c shr 14) or (c shl 50)) xor ((c shr 18) or (c shl 46)) xor ((c shr 41) or (c shl 23))) + ((c and d) xor (not c and e)) + $b00327c898fb213f + W[26]; t2:= (((g shr 28) or (g shl 36)) xor ((g shr 34) or (g shl 30)) xor ((g shr 39) or (g shl 25))) + ((g and h) xor (g and a) xor (h and a)); b:= b + t1; f:= t1 + t2;
  t1:= e + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46)) xor ((b shr 41) or (b shl 23))) + ((b and c) xor (not b and d)) + $bf597fc7beef0ee4 + W[27]; t2:= (((f shr 28) or (f shl 36)) xor ((f shr 34) or (f shl 30)) xor ((f shr 39) or (f shl 25))) + ((f and g) xor (f and h) xor (g and h)); a:= a + t1; e:= t1 + t2;
  t1:= d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46)) xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and c)) + $c6e00bf33da88fc2 + W[28]; t2:= (((e shr 28) or (e shl 36)) xor ((e shr 34) or (e shl 30)) xor ((e shr 39) or (e shl 25))) + ((e and f) xor (e and g) xor (f and g)); h:= h + t1; d:= t1 + t2;
  t1:= c + (((h shr 14) or (h shl 50)) xor ((h shr 18) or (h shl 46)) xor ((h shr 41) or (h shl 23))) + ((h and a) xor (not h and b)) + $d5a79147930aa725 + W[29]; t2:= (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30)) xor ((d shr 39) or (d shl 25))) + ((d and e) xor (d and f) xor (e and f)); g:= g + t1; c:= t1 + t2;
  t1:= b + (((g shr 14) or (g shl 50)) xor ((g shr 18) or (g shl 46)) xor ((g shr 41) or (g shl 23))) + ((g and h) xor (not g and a)) + $06ca6351e003826f + W[30]; t2:= (((c shr 28) or (c shl 36)) xor ((c shr 34) or (c shl 30)) xor ((c shr 39) or (c shl 25))) + ((c and d) xor (c and e) xor (d and e)); f:= f + t1; b:= t1 + t2;
  t1:= a + (((f shr 14) or (f shl 50)) xor ((f shr 18) or (f shl 46)) xor ((f shr 41) or (f shl 23))) + ((f and g) xor (not f and h)) + $142929670a0e6e70 + W[31]; t2:= (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30)) xor ((b shr 39) or (b shl 25))) + ((b and c) xor (b and d) xor (c and d)); e:= e + t1; a:= t1 + t2;
  t1:= h + (((e shr 14) or (e shl 50)) xor ((e shr 18) or (e shl 46)) xor ((e shr 41) or (e shl 23))) + ((e and f) xor (not e and g)) + $27b70a8546d22ffc + W[32]; t2:= (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30)) xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and c) xor (b and c)); d:= d + t1; h:= t1 + t2;
  t1:= g + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46)) xor ((d shr 41) or (d shl 23))) + ((d and e) xor (not d and f)) + $2e1b21385c26c926 + W[33]; t2:= (((h shr 28) or (h shl 36)) xor ((h shr 34) or (h shl 30)) xor ((h shr 39) or (h shl 25))) + ((h and a) xor (h and b) xor (a and b)); c:= c + t1; g:= t1 + t2;
  t1:= f + (((c shr 14) or (c shl 50)) xor ((c shr 18) or (c shl 46)) xor ((c shr 41) or (c shl 23))) + ((c and d) xor (not c and e)) + $4d2c6dfc5ac42aed + W[34]; t2:= (((g shr 28) or (g shl 36)) xor ((g shr 34) or (g shl 30)) xor ((g shr 39) or (g shl 25))) + ((g and h) xor (g and a) xor (h and a)); b:= b + t1; f:= t1 + t2;
  t1:= e + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46)) xor ((b shr 41) or (b shl 23))) + ((b and c) xor (not b and d)) + $53380d139d95b3df + W[35]; t2:= (((f shr 28) or (f shl 36)) xor ((f shr 34) or (f shl 30)) xor ((f shr 39) or (f shl 25))) + ((f and g) xor (f and h) xor (g and h)); a:= a + t1; e:= t1 + t2;
  t1:= d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46)) xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and c)) + $650a73548baf63de + W[36]; t2:= (((e shr 28) or (e shl 36)) xor ((e shr 34) or (e shl 30)) xor ((e shr 39) or (e shl 25))) + ((e and f) xor (e and g) xor (f and g)); h:= h + t1; d:= t1 + t2;
  t1:= c + (((h shr 14) or (h shl 50)) xor ((h shr 18) or (h shl 46)) xor ((h shr 41) or (h shl 23))) + ((h and a) xor (not h and b)) + $766a0abb3c77b2a8 + W[37]; t2:= (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30)) xor ((d shr 39) or (d shl 25))) + ((d and e) xor (d and f) xor (e and f)); g:= g + t1; c:= t1 + t2;
  t1:= b + (((g shr 14) or (g shl 50)) xor ((g shr 18) or (g shl 46)) xor ((g shr 41) or (g shl 23))) + ((g and h) xor (not g and a)) + $81c2c92e47edaee6 + W[38]; t2:= (((c shr 28) or (c shl 36)) xor ((c shr 34) or (c shl 30)) xor ((c shr 39) or (c shl 25))) + ((c and d) xor (c and e) xor (d and e)); f:= f + t1; b:= t1 + t2;
  t1:= a + (((f shr 14) or (f shl 50)) xor ((f shr 18) or (f shl 46)) xor ((f shr 41) or (f shl 23))) + ((f and g) xor (not f and h)) + $92722c851482353b + W[39]; t2:= (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30)) xor ((b shr 39) or (b shl 25))) + ((b and c) xor (b and d) xor (c and d)); e:= e + t1; a:= t1 + t2;
  t1:= h + (((e shr 14) or (e shl 50)) xor ((e shr 18) or (e shl 46)) xor ((e shr 41) or (e shl 23))) + ((e and f) xor (not e and g)) + $a2bfe8a14cf10364 + W[40]; t2:= (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30)) xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and c) xor (b and c)); d:= d + t1; h:= t1 + t2;
  t1:= g + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46)) xor ((d shr 41) or (d shl 23))) + ((d and e) xor (not d and f)) + $a81a664bbc423001 + W[41]; t2:= (((h shr 28) or (h shl 36)) xor ((h shr 34) or (h shl 30)) xor ((h shr 39) or (h shl 25))) + ((h and a) xor (h and b) xor (a and b)); c:= c + t1; g:= t1 + t2;
  t1:= f + (((c shr 14) or (c shl 50)) xor ((c shr 18) or (c shl 46)) xor ((c shr 41) or (c shl 23))) + ((c and d) xor (not c and e)) + $c24b8b70d0f89791 + W[42]; t2:= (((g shr 28) or (g shl 36)) xor ((g shr 34) or (g shl 30)) xor ((g shr 39) or (g shl 25))) + ((g and h) xor (g and a) xor (h and a)); b:= b + t1; f:= t1 + t2;
  t1:= e + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46)) xor ((b shr 41) or (b shl 23))) + ((b and c) xor (not b and d)) + $c76c51a30654be30 + W[43]; t2:= (((f shr 28) or (f shl 36)) xor ((f shr 34) or (f shl 30)) xor ((f shr 39) or (f shl 25))) + ((f and g) xor (f and h) xor (g and h)); a:= a + t1; e:= t1 + t2;
  t1:= d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46)) xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and c)) + $d192e819d6ef5218 + W[44]; t2:= (((e shr 28) or (e shl 36)) xor ((e shr 34) or (e shl 30)) xor ((e shr 39) or (e shl 25))) + ((e and f) xor (e and g) xor (f and g)); h:= h + t1; d:= t1 + t2;
  t1:= c + (((h shr 14) or (h shl 50)) xor ((h shr 18) or (h shl 46)) xor ((h shr 41) or (h shl 23))) + ((h and a) xor (not h and b)) + $d69906245565a910 + W[45]; t2:= (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30)) xor ((d shr 39) or (d shl 25))) + ((d and e) xor (d and f) xor (e and f)); g:= g + t1; c:= t1 + t2;
  t1:= b + (((g shr 14) or (g shl 50)) xor ((g shr 18) or (g shl 46)) xor ((g shr 41) or (g shl 23))) + ((g and h) xor (not g and a)) + $f40e35855771202a + W[46]; t2:= (((c shr 28) or (c shl 36)) xor ((c shr 34) or (c shl 30)) xor ((c shr 39) or (c shl 25))) + ((c and d) xor (c and e) xor (d and e)); f:= f + t1; b:= t1 + t2;
  t1:= a + (((f shr 14) or (f shl 50)) xor ((f shr 18) or (f shl 46)) xor ((f shr 41) or (f shl 23))) + ((f and g) xor (not f and h)) + $106aa07032bbd1b8 + W[47]; t2:= (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30)) xor ((b shr 39) or (b shl 25))) + ((b and c) xor (b and d) xor (c and d)); e:= e + t1; a:= t1 + t2;
  t1:= h + (((e shr 14) or (e shl 50)) xor ((e shr 18) or (e shl 46)) xor ((e shr 41) or (e shl 23))) + ((e and f) xor (not e and g)) + $19a4c116b8d2d0c8 + W[48]; t2:= (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30)) xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and c) xor (b and c)); d:= d + t1; h:= t1 + t2;
  t1:= g + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46)) xor ((d shr 41) or (d shl 23))) + ((d and e) xor (not d and f)) + $1e376c085141ab53 + W[49]; t2:= (((h shr 28) or (h shl 36)) xor ((h shr 34) or (h shl 30)) xor ((h shr 39) or (h shl 25))) + ((h and a) xor (h and b) xor (a and b)); c:= c + t1; g:= t1 + t2;
  t1:= f + (((c shr 14) or (c shl 50)) xor ((c shr 18) or (c shl 46)) xor ((c shr 41) or (c shl 23))) + ((c and d) xor (not c and e)) + $2748774cdf8eeb99 + W[50]; t2:= (((g shr 28) or (g shl 36)) xor ((g shr 34) or (g shl 30)) xor ((g shr 39) or (g shl 25))) + ((g and h) xor (g and a) xor (h and a)); b:= b + t1; f:= t1 + t2;
  t1:= e + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46)) xor ((b shr 41) or (b shl 23))) + ((b and c) xor (not b and d)) + $34b0bcb5e19b48a8 + W[51]; t2:= (((f shr 28) or (f shl 36)) xor ((f shr 34) or (f shl 30)) xor ((f shr 39) or (f shl 25))) + ((f and g) xor (f and h) xor (g and h)); a:= a + t1; e:= t1 + t2;
  t1:= d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46)) xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and c)) + $391c0cb3c5c95a63 + W[52]; t2:= (((e shr 28) or (e shl 36)) xor ((e shr 34) or (e shl 30)) xor ((e shr 39) or (e shl 25))) + ((e and f) xor (e and g) xor (f and g)); h:= h + t1; d:= t1 + t2;
  t1:= c + (((h shr 14) or (h shl 50)) xor ((h shr 18) or (h shl 46)) xor ((h shr 41) or (h shl 23))) + ((h and a) xor (not h and b)) + $4ed8aa4ae3418acb + W[53]; t2:= (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30)) xor ((d shr 39) or (d shl 25))) + ((d and e) xor (d and f) xor (e and f)); g:= g + t1; c:= t1 + t2;
  t1:= b + (((g shr 14) or (g shl 50)) xor ((g shr 18) or (g shl 46)) xor ((g shr 41) or (g shl 23))) + ((g and h) xor (not g and a)) + $5b9cca4f7763e373 + W[54]; t2:= (((c shr 28) or (c shl 36)) xor ((c shr 34) or (c shl 30)) xor ((c shr 39) or (c shl 25))) + ((c and d) xor (c and e) xor (d and e)); f:= f + t1; b:= t1 + t2;
  t1:= a + (((f shr 14) or (f shl 50)) xor ((f shr 18) or (f shl 46)) xor ((f shr 41) or (f shl 23))) + ((f and g) xor (not f and h)) + $682e6ff3d6b2b8a3 + W[55]; t2:= (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30)) xor ((b shr 39) or (b shl 25))) + ((b and c) xor (b and d) xor (c and d)); e:= e + t1; a:= t1 + t2;
  t1:= h + (((e shr 14) or (e shl 50)) xor ((e shr 18) or (e shl 46)) xor ((e shr 41) or (e shl 23))) + ((e and f) xor (not e and g)) + $748f82ee5defb2fc + W[56]; t2:= (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30)) xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and c) xor (b and c)); d:= d + t1; h:= t1 + t2;
  t1:= g + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46)) xor ((d shr 41) or (d shl 23))) + ((d and e) xor (not d and f)) + $78a5636f43172f60 + W[57]; t2:= (((h shr 28) or (h shl 36)) xor ((h shr 34) or (h shl 30)) xor ((h shr 39) or (h shl 25))) + ((h and a) xor (h and b) xor (a and b)); c:= c + t1; g:= t1 + t2;
  t1:= f + (((c shr 14) or (c shl 50)) xor ((c shr 18) or (c shl 46)) xor ((c shr 41) or (c shl 23))) + ((c and d) xor (not c and e)) + $84c87814a1f0ab72 + W[58]; t2:= (((g shr 28) or (g shl 36)) xor ((g shr 34) or (g shl 30)) xor ((g shr 39) or (g shl 25))) + ((g and h) xor (g and a) xor (h and a)); b:= b + t1; f:= t1 + t2;
  t1:= e + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46)) xor ((b shr 41) or (b shl 23))) + ((b and c) xor (not b and d)) + $8cc702081a6439ec + W[59]; t2:= (((f shr 28) or (f shl 36)) xor ((f shr 34) or (f shl 30)) xor ((f shr 39) or (f shl 25))) + ((f and g) xor (f and h) xor (g and h)); a:= a + t1; e:= t1 + t2;
  t1:= d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46)) xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and c)) + $90befffa23631e28 + W[60]; t2:= (((e shr 28) or (e shl 36)) xor ((e shr 34) or (e shl 30)) xor ((e shr 39) or (e shl 25))) + ((e and f) xor (e and g) xor (f and g)); h:= h + t1; d:= t1 + t2;
  t1:= c + (((h shr 14) or (h shl 50)) xor ((h shr 18) or (h shl 46)) xor ((h shr 41) or (h shl 23))) + ((h and a) xor (not h and b)) + $a4506cebde82bde9 + W[61]; t2:= (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30)) xor ((d shr 39) or (d shl 25))) + ((d and e) xor (d and f) xor (e and f)); g:= g + t1; c:= t1 + t2;
  t1:= b + (((g shr 14) or (g shl 50)) xor ((g shr 18) or (g shl 46)) xor ((g shr 41) or (g shl 23))) + ((g and h) xor (not g and a)) + $bef9a3f7b2c67915 + W[62]; t2:= (((c shr 28) or (c shl 36)) xor ((c shr 34) or (c shl 30)) xor ((c shr 39) or (c shl 25))) + ((c and d) xor (c and e) xor (d and e)); f:= f + t1; b:= t1 + t2;
  t1:= a + (((f shr 14) or (f shl 50)) xor ((f shr 18) or (f shl 46)) xor ((f shr 41) or (f shl 23))) + ((f and g) xor (not f and h)) + $c67178f2e372532b + W[63]; t2:= (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30)) xor ((b shr 39) or (b shl 25))) + ((b and c) xor (b and d) xor (c and d)); e:= e + t1; a:= t1 + t2;
  t1:= h + (((e shr 14) or (e shl 50)) xor ((e shr 18) or (e shl 46)) xor ((e shr 41) or (e shl 23))) + ((e and f) xor (not e and g)) + $ca273eceea26619c + W[64]; t2:= (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30)) xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and c) xor (b and c)); d:= d + t1; h:= t1 + t2;
  t1:= g + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46)) xor ((d shr 41) or (d shl 23))) + ((d and e) xor (not d and f)) + $d186b8c721c0c207 + W[65]; t2:= (((h shr 28) or (h shl 36)) xor ((h shr 34) or (h shl 30)) xor ((h shr 39) or (h shl 25))) + ((h and a) xor (h and b) xor (a and b)); c:= c + t1; g:= t1 + t2;
  t1:= f + (((c shr 14) or (c shl 50)) xor ((c shr 18) or (c shl 46)) xor ((c shr 41) or (c shl 23))) + ((c and d) xor (not c and e)) + $eada7dd6cde0eb1e + W[66]; t2:= (((g shr 28) or (g shl 36)) xor ((g shr 34) or (g shl 30)) xor ((g shr 39) or (g shl 25))) + ((g and h) xor (g and a) xor (h and a)); b:= b + t1; f:= t1 + t2;
  t1:= e + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46)) xor ((b shr 41) or (b shl 23))) + ((b and c) xor (not b and d)) + $f57d4f7fee6ed178 + W[67]; t2:= (((f shr 28) or (f shl 36)) xor ((f shr 34) or (f shl 30)) xor ((f shr 39) or (f shl 25))) + ((f and g) xor (f and h) xor (g and h)); a:= a + t1; e:= t1 + t2;
  t1:= d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46)) xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and c)) + $06f067aa72176fba + W[68]; t2:= (((e shr 28) or (e shl 36)) xor ((e shr 34) or (e shl 30)) xor ((e shr 39) or (e shl 25))) + ((e and f) xor (e and g) xor (f and g)); h:= h + t1; d:= t1 + t2;
  t1:= c + (((h shr 14) or (h shl 50)) xor ((h shr 18) or (h shl 46)) xor ((h shr 41) or (h shl 23))) + ((h and a) xor (not h and b)) + $0a637dc5a2c898a6 + W[69]; t2:= (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30)) xor ((d shr 39) or (d shl 25))) + ((d and e) xor (d and f) xor (e and f)); g:= g + t1; c:= t1 + t2;
  t1:= b + (((g shr 14) or (g shl 50)) xor ((g shr 18) or (g shl 46)) xor ((g shr 41) or (g shl 23))) + ((g and h) xor (not g and a)) + $113f9804bef90dae + W[70]; t2:= (((c shr 28) or (c shl 36)) xor ((c shr 34) or (c shl 30)) xor ((c shr 39) or (c shl 25))) + ((c and d) xor (c and e) xor (d and e)); f:= f + t1; b:= t1 + t2;
  t1:= a + (((f shr 14) or (f shl 50)) xor ((f shr 18) or (f shl 46)) xor ((f shr 41) or (f shl 23))) + ((f and g) xor (not f and h)) + $1b710b35131c471b + W[71]; t2:= (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30)) xor ((b shr 39) or (b shl 25))) + ((b and c) xor (b and d) xor (c and d)); e:= e + t1; a:= t1 + t2;
  t1:= h + (((e shr 14) or (e shl 50)) xor ((e shr 18) or (e shl 46)) xor ((e shr 41) or (e shl 23))) + ((e and f) xor (not e and g)) + $28db77f523047d84 + W[72]; t2:= (((a shr 28) or (a shl 36)) xor ((a shr 34) or (a shl 30)) xor ((a shr 39) or (a shl 25))) + ((a and b) xor (a and c) xor (b and c)); d:= d + t1; h:= t1 + t2;
  t1:= g + (((d shr 14) or (d shl 50)) xor ((d shr 18) or (d shl 46)) xor ((d shr 41) or (d shl 23))) + ((d and e) xor (not d and f)) + $32caab7b40c72493 + W[73]; t2:= (((h shr 28) or (h shl 36)) xor ((h shr 34) or (h shl 30)) xor ((h shr 39) or (h shl 25))) + ((h and a) xor (h and b) xor (a and b)); c:= c + t1; g:= t1 + t2;
  t1:= f + (((c shr 14) or (c shl 50)) xor ((c shr 18) or (c shl 46)) xor ((c shr 41) or (c shl 23))) + ((c and d) xor (not c and e)) + $3c9ebe0a15c9bebc + W[74]; t2:= (((g shr 28) or (g shl 36)) xor ((g shr 34) or (g shl 30)) xor ((g shr 39) or (g shl 25))) + ((g and h) xor (g and a) xor (h and a)); b:= b + t1; f:= t1 + t2;
  t1:= e + (((b shr 14) or (b shl 50)) xor ((b shr 18) or (b shl 46)) xor ((b shr 41) or (b shl 23))) + ((b and c) xor (not b and d)) + $431d67c49c100d4c + W[75]; t2:= (((f shr 28) or (f shl 36)) xor ((f shr 34) or (f shl 30)) xor ((f shr 39) or (f shl 25))) + ((f and g) xor (f and h) xor (g and h)); a:= a + t1; e:= t1 + t2;
  t1:= d + (((a shr 14) or (a shl 50)) xor ((a shr 18) or (a shl 46)) xor ((a shr 41) or (a shl 23))) + ((a and b) xor (not a and c)) + $4cc5d4becb3e42b6 + W[76]; t2:= (((e shr 28) or (e shl 36)) xor ((e shr 34) or (e shl 30)) xor ((e shr 39) or (e shl 25))) + ((e and f) xor (e and g) xor (f and g)); h:= h + t1; d:= t1 + t2;
  t1:= c + (((h shr 14) or (h shl 50)) xor ((h shr 18) or (h shl 46)) xor ((h shr 41) or (h shl 23))) + ((h and a) xor (not h and b)) + $597f299cfc657e2a + W[77]; t2:= (((d shr 28) or (d shl 36)) xor ((d shr 34) or (d shl 30)) xor ((d shr 39) or (d shl 25))) + ((d and e) xor (d and f) xor (e and f)); g:= g + t1; c:= t1 + t2;
  t1:= b + (((g shr 14) or (g shl 50)) xor ((g shr 18) or (g shl 46)) xor ((g shr 41) or (g shl 23))) + ((g and h) xor (not g and a)) + $5fcb6fab3ad6faec + W[78]; t2:= (((c shr 28) or (c shl 36)) xor ((c shr 34) or (c shl 30)) xor ((c shr 39) or (c shl 25))) + ((c and d) xor (c and e) xor (d and e)); f:= f + t1; b:= t1 + t2;
  t1:= a + (((f shr 14) or (f shl 50)) xor ((f shr 18) or (f shl 46)) xor ((f shr 41) or (f shl 23))) + ((f and g) xor (not f and h)) + $6c44198c4a475817 + W[79]; t2:= (((b shr 28) or (b shl 36)) xor ((b shr 34) or (b shl 30)) xor ((b shr 39) or (b shl 25))) + ((b and c) xor (b and d) xor (c and d)); e:= e + t1; a:= t1 + t2;

  CurrentHash[0]:= CurrentHash[0] + a;
  CurrentHash[1]:= CurrentHash[1] + b;
  CurrentHash[2]:= CurrentHash[2] + c;
  CurrentHash[3]:= CurrentHash[3] + d;
  CurrentHash[4]:= CurrentHash[4] + e;
  CurrentHash[5]:= CurrentHash[5] + f;
  CurrentHash[6]:= CurrentHash[6] + g;
  CurrentHash[7]:= CurrentHash[7] + h;
  FillChar(W,Sizeof(W),0);
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
end;

procedure TDCP_sha512base.Burn;
begin
  LenHi:= 0; LenLo:= 0;
  Index:= 0;
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
  FillChar(CurrentHash,Sizeof(CurrentHash),0);
  fInitialized:= false;
end;

procedure TDCP_sha512base.Update(const Buffer; Size: longword);
var
  PBuf: ^byte;
begin
  if not fInitialized then
    raise EDCP_hash.Create('Hash not initialized');

  Inc(LenLo,Size*8);
  if LenLo< (Size*8) then
    Inc(LenHi);

  PBuf:= @Buffer;
  while Size> 0 do
  begin
    if (Sizeof(HashBuffer)-Index)<= DWord(Size) then
    begin
      Move(PBuf^,HashBuffer[Index],Sizeof(HashBuffer)-Index);
      Dec(Size,Sizeof(HashBuffer)-Index);
      Inc(PBuf,Sizeof(HashBuffer)-Index);
      Compress;
    end
    else
    begin
      Move(PBuf^,HashBuffer[Index],Size);
      Inc(Index,Size);
      Size:= 0;
    end;
  end;
end;

{******************************************************************************}
procedure TDCP_sha384.Init;
begin
  Burn;
  CurrentHash[0] := Int64($cbbb9d5dc1059ed8);
  CurrentHash[1] := Int64($629a292a367cd507);
  CurrentHash[2] := Int64($9159015a3070dd17);
  CurrentHash[3] := Int64($152fecd8f70e5939);
  CurrentHash[4] := Int64($67332667ffc00b31);
  CurrentHash[5] := Int64($8eb44a8768581511);
  CurrentHash[6] := Int64($db0c2e0d64f98fa7);
  CurrentHash[7] := Int64($47b5481dbefa4fa4);
  FInitialized := True;
end;

procedure TDCP_sha384.Final(var Digest);
begin
  if not fInitialized then
    raise EDCP_hash.Create('Hash not initialized');
  HashBuffer[Index]:= $80;
  if Index>= 112 then
    Compress;
  Pint64(@HashBuffer[112])^:= SwapDWord64(LenHi);
  Pint64(@HashBuffer[120])^:= SwapDWord64(LenLo);
  Compress;
  CurrentHash[0]:= SwapDWord64(CurrentHash[0]);
  CurrentHash[1]:= SwapDWord64(CurrentHash[1]);
  CurrentHash[2]:= SwapDWord64(CurrentHash[2]);
  CurrentHash[3]:= SwapDWord64(CurrentHash[3]);
  CurrentHash[4]:= SwapDWord64(CurrentHash[4]);
  CurrentHash[5]:= SwapDWord64(CurrentHash[5]);
  Move(CurrentHash,Digest,384 div 8);
  Burn;
end;

{******************************************************************************}
procedure TDCP_sha512.Init;
begin
  Burn;
  CurrentHash[0] := Int64($6a09e667f3bcc908);
  CurrentHash[1] := Int64($bb67ae8584caa73b);
  CurrentHash[2] := Int64($3c6ef372fe94f82b);
  CurrentHash[3] := Int64($a54ff53a5f1d36f1);
  CurrentHash[4] := Int64($510e527fade682d1);
  CurrentHash[5] := Int64($9b05688c2b3e6c1f);
  CurrentHash[6] := Int64($1f83d9abfb41bd6b);
  CurrentHash[7] := Int64($5be0cd19137e2179);
  FInitialized := True;
end;

procedure TDCP_sha512.Final(var Digest);
begin
  if not fInitialized then
    raise EDCP_hash.Create('Hash not initialized');
  HashBuffer[Index]:= $80;
  if Index>= 112 then
    Compress;
  Pint64(@HashBuffer[112])^:= SwapDWord64(LenHi);
  Pint64(@HashBuffer[120])^:= SwapDWord64(LenLo);
  Compress;
  CurrentHash[0]:= SwapDWord64(CurrentHash[0]);
  CurrentHash[1]:= SwapDWord64(CurrentHash[1]);
  CurrentHash[2]:= SwapDWord64(CurrentHash[2]);
  CurrentHash[3]:= SwapDWord64(CurrentHash[3]);
  CurrentHash[4]:= SwapDWord64(CurrentHash[4]);
  CurrentHash[5]:= SwapDWord64(CurrentHash[5]);
  CurrentHash[6]:= SwapDWord64(CurrentHash[6]);
  CurrentHash[7]:= SwapDWord64(CurrentHash[7]);
  Move(CurrentHash,Digest,Sizeof(CurrentHash));
  Burn;
end;

function SHA256ByteArray(Input: array of Byte): TQPLSHA256Digest;
var
  Hash: TDCP_sha256;
begin
  Hash := TDCP_sha256.Create;
  try
    Hash.Init;
    if (Length(Input) > 0) then
    begin
      Hash.Update(Input[0], Length(Input));
    end;
      Hash.Final(Result[0]);
  finally
    Hash.Free;
  end;
end;

function SHA384ByteArray(Input: array of Byte): TQPLSHA384Digest;
var
  Hash: TDCP_sha384;
begin
  Hash := TDCP_sha384.Create;
  try
    Hash.Init;
    if (Length(Input) > 0) then
    begin
      Hash.Update(Input[0], Length(Input));
    end;
      Hash.Final(Result[0]);
  finally
    Hash.Free;
  end;
end;

function SHA512ByteArray(Input: array of Byte): TQPLSHA512Digest;
var
  Hash: TDCP_sha512;
begin
  Hash := TDCP_sha512.Create;
  try
    Hash.Init;
    if (Length(Input) > 0) then
    begin
      Hash.Update(Input[0], Length(Input));
    end;
      Hash.Final(Result[0]);
  finally
    Hash.Free;
  end;
end;

{$IFDEF QPL_MD5_MAC}
type
  MacMD5Count = array[0..1] of Longword;
  MacMD5State = array[0..3] of Longword;
  MacMD5Block = array[0..15] of Longword;
  MacMD5CBits = array[0..7] of Byte;
  MacMD5Buffer = array[0..63] of Byte;
  MacMD5Context = record
    State: MacMD5State;
    Count: MacMD5Count;
    Buffer: MacMD5Buffer;
  end;

var
  MacPadding: MacMD5Buffer = (
    $80, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00
  );

function MacF(x, y, z: Longword): Longword;
begin
  {$OVERFLOWCHECKS OFF}
  Result := (x and y) or ((not x) and z);
end;

function MacG(x, y, z: Longword): Longword;
begin
  {$OVERFLOWCHECKS OFF}
  Result := (x and z) or (y and (not z));
end;

function MacH(x, y, z: Longword): Longword;
begin
  {$OVERFLOWCHECKS OFF}
  Result := x xor y xor z;
end;

function MacI(x, y, z: Longword): Longword;
begin
  {$OVERFLOWCHECKS OFF}
  Result := y xor (x or (not z));
end;

procedure Macrot(var x: Longword; n: Byte);
begin
  {$OVERFLOWCHECKS OFF}
  x := (x shl n) or (x shr (32 - n));
end;

procedure MacFF(var a: Longword; b, c, d, x: Longword; s: Byte; ac: Longword);
begin
  {$OVERFLOWCHECKS OFF}
  Inc(a, MacF(b, c, d) + x + ac);
  Macrot(a, s);
  Inc(a, b);
end;

procedure MacGG(var a: Longword; b, c, d, x: Longword; s: Byte; ac: Longword);
begin
  {$OVERFLOWCHECKS OFF}
  Inc(a, MacG(b, c, d) + x + ac);
  Macrot(a, s);
  Inc(a, b);
end;

procedure MacHH(var a: Longword; b, c, d, x: Longword; s: Byte; ac: Longword);
begin
  {$OVERFLOWCHECKS OFF}
  Inc(a, MacH(b, c, d) + x + ac);
  Macrot(a, s);
  Inc(a, b);
end;

procedure MacII(var a: Longword; b, c, d, x: Longword; s: Byte; ac: Longword);
begin
  {$OVERFLOWCHECKS OFF}
  Inc(a, MacI(b, c, d) + x + ac);
  Macrot(a, s);
  Inc(a, b);
end;

procedure MacEncode(Source, Target: pointer; Count: Longword);
var
  S: PByte;
  T: PLongword;
  I: Longword;
begin
  S := Source;
  T := Target;
  for I := 1 to Count div 4 do
  begin
    T^ := S^;
    Inc(S);
    T^ := T^ or (S^ shl 8);
    Inc(S);
    T^ := T^ or (S^ shl 16);
    Inc(S);
    T^ := T^ or (S^ shl 24);
    Inc(S);
    Inc(T);
  end;
end;

procedure MacDecode(Source, Target: pointer; Count: Longword);
var
  S: PLongword;
  T: PByte;
  I: Longword;
begin
  S := Source;
  T := Target;
  for I := 1 to Count do
  begin
    T^ := S^ and $ff;
    Inc(T);
    T^ := (S^ shr 8) and $ff;
    Inc(T);
    T^ := (S^ shr 16) and $ff;
    Inc(T);
    T^ := (S^ shr 24) and $ff;
    Inc(T);
    Inc(S);
  end;
end;

procedure MacTransform(Buffer: pointer; var State: MacMD5State);
var
  a, b, c, d: Longword;
  Block: MacMD5Block;
begin
  MacEncode(Buffer, @Block, 64);
  a := State[0];
  b := State[1];
  c := State[2];
  d := State[3];
  MacFF(a, b, c, d, Block[ 0],  7, $d76aa478);
  MacFF(d, a, b, c, Block[ 1], 12, $e8c7b756);
  MacFF(c, d, a, b, Block[ 2], 17, $242070db);
  MacFF(b, c, d, a, Block[ 3], 22, $c1bdceee);
  MacFF(a, b, c, d, Block[ 4],  7, $f57c0faf);
  MacFF(d, a, b, c, Block[ 5], 12, $4787c62a);
  MacFF(c, d, a, b, Block[ 6], 17, $a8304613);
  MacFF(b, c, d, a, Block[ 7], 22, $fd469501);
  MacFF(a, b, c, d, Block[ 8],  7, $698098d8);
  MacFF(d, a, b, c, Block[ 9], 12, $8b44f7af);
  MacFF(c, d, a, b, Block[10], 17, $ffff5bb1);
  MacFF(b, c, d, a, Block[11], 22, $895cd7be);
  MacFF(a, b, c, d, Block[12],  7, $6b901122);
  MacFF(d, a, b, c, Block[13], 12, $fd987193);
  MacFF(c, d, a, b, Block[14], 17, $a679438e);
  MacFF(b, c, d, a, Block[15], 22, $49b40821);
  MacGG(a, b, c, d, Block[ 1],  5, $f61e2562);
  MacGG(d, a, b, c, Block[ 6],  9, $c040b340);
  MacGG(c, d, a, b, Block[11], 14, $265e5a51);
  MacGG(b, c, d, a, Block[ 0], 20, $e9b6c7aa);
  MacGG(a, b, c, d, Block[ 5],  5, $d62f105d);
  MacGG(d, a, b, c, Block[10],  9,  $2441453);
  MacGG(c, d, a, b, Block[15], 14, $d8a1e681);
  MacGG(b, c, d, a, Block[ 4], 20, $e7d3fbc8);
  MacGG(a, b, c, d, Block[ 9],  5, $21e1cde6);
  MacGG(d, a, b, c, Block[14],  9, $c33707d6);
  MacGG(c, d, a, b, Block[ 3], 14, $f4d50d87);
  MacGG(b, c, d, a, Block[ 8], 20, $455a14ed);
  MacGG(a, b, c, d, Block[13],  5, $a9e3e905);
  MacGG(d, a, b, c, Block[ 2],  9, $fcefa3f8);
  MacGG(c, d, a, b, Block[ 7], 14, $676f02d9);
  MacGG(b, c, d, a, Block[12], 20, $8d2a4c8a);
  MacHH(a, b, c, d, Block[ 5],  4, $fffa3942);
  MacHH(d, a, b, c, Block[ 8], 11, $8771f681);
  MacHH(c, d, a, b, Block[11], 16, $6d9d6122);
  MacHH(b, c, d, a, Block[14], 23, $fde5380c);
  MacHH(a, b, c, d, Block[ 1],  4, $a4beea44);
  MacHH(d, a, b, c, Block[ 4], 11, $4bdecfa9);
  MacHH(c, d, a, b, Block[ 7], 16, $f6bb4b60);
  MacHH(b, c, d, a, Block[10], 23, $bebfbc70);
  MacHH(a, b, c, d, Block[13],  4, $289b7ec6);
  MacHH(d, a, b, c, Block[ 0], 11, $eaa127fa);
  MacHH(c, d, a, b, Block[ 3], 16, $d4ef3085);
  MacHH(b, c, d, a, Block[ 6], 23,  $4881d05);
  MacHH(a, b, c, d, Block[ 9],  4, $d9d4d039);
  MacHH(d, a, b, c, Block[12], 11, $e6db99e5);
  MacHH(c, d, a, b, Block[15], 16, $1fa27cf8);
  MacHH(b, c, d, a, Block[ 2], 23, $c4ac5665);
  MacII(a, b, c, d, Block[ 0],  6, $f4292244);
  MacII(d, a, b, c, Block[ 7], 10, $432aff97);
  MacII(c, d, a, b, Block[14], 15, $ab9423a7);
  MacII(b, c, d, a, Block[ 5], 21, $fc93a039);
  MacII(a, b, c, d, Block[12],  6, $655b59c3);
  MacII(d, a, b, c, Block[ 3], 10, $8f0ccc92);
  MacII(c, d, a, b, Block[10], 15, $ffeff47d);
  MacII(b, c, d, a, Block[ 1], 21, $85845dd1);
  MacII(a, b, c, d, Block[ 8],  6, $6fa87e4f);
  MacII(d, a, b, c, Block[15], 10, $fe2ce6e0);
  MacII(c, d, a, b, Block[ 6], 15, $a3014314);
  MacII(b, c, d, a, Block[13], 21, $4e0811a1);
  MacII(a, b, c, d, Block[ 4],  6, $f7537e82);
  MacII(d, a, b, c, Block[11], 10, $bd3af235);
  MacII(c, d, a, b, Block[ 2], 15, $2ad7d2bb);
  MacII(b, c, d, a, Block[ 9], 21, $eb86d391);
  Inc(State[0], a);
  Inc(State[1], b);
  Inc(State[2], c);
  Inc(State[3], d);
end;

procedure MacMD5Init(var Context: MacMD5Context);
begin
  with Context do
  begin
    State[0] := $67452301;
    State[1] := $efcdab89;
    State[2] := $98badcfe;
    State[3] := $10325476;
    Count[0] := 0;
    Count[1] := 0;
    FillChar(Buffer, SizeOf(MacMD5Buffer), 0);
  end;
end;

procedure MacMD5Update(var Context: MacMD5Context; Input: PAnsiChar; Length: Longword);
var
  Index: Longword;
  PartLen: Longword;
  I: Longword;
begin
  with Context do
  begin
    Index := (Count[0] shr 3) and $3f;
    Inc(Count[0], Length shl 3);
    if Count[0] < (Length shl 3) then Inc(Count[1]);
    Inc(Count[1], Length shr 29);
  end;
  PartLen := 64 - Index;
  if Length >= PartLen then
  begin
    Move(Input^, Context.Buffer[Index], PartLen);
    MacTransform(@Context.Buffer, Context.State);
    I := PartLen;
    while I + 63 < Length do
    begin
      MacTransform(@Input[I], Context.State);
      Inc(I, 64);
    end;
    Index := 0;
  end else I := 0;
  Move(Input[I], Context.Buffer[Index], Length - I);
end;

procedure MacMD5Final(var Context: MacMD5Context; var Digest: MD5Digest);
var
  Bits: MacMD5CBits;
  Index: Longword;
  PadLen: Longword;
begin
  MacDecode(@Context.Count, @Bits, 2);
  Index := (Context.Count[0] shr 3) and $3f;
  if Index < 56 then PadLen := 56 - Index else PadLen := 120 - Index;
  MacMD5Update(Context, @MacPadding, PadLen);
  MacMD5Update(Context, @Bits, 8);
  MacDecode(@Context.State, @Digest, 4);
  FillChar(Context, SizeOf(MacMD5Context), 0);
end;

function MacMD5String(const M: AnsiString): MD5Digest;
var
  Context: MacMD5Context;
begin
  MacMD5Init(Context);
  MacMD5Update(Context, @M[1], Length(M));
  MacMD5Final(Context, Result);
end;

function MD5Stream(Input: TStream): AnsiString;
var
  M: AnsiString;
begin
  Input.Seek(0, soFromBeginning);
  SetLength(M, Input.Size);
  if (Length(M) > 0) then
  begin
    Input.Read(M[1], Length(M));
    Result := MD5DigestToString(MacMD5String(M));
  end;
end;
{$ENDIF}

end.
