{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryEncrypt.pas                            }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryEncrypt;

{$I DebenuPDFLibraryDefines.inc}

interface

function ARC4HexOut(const Key, PlainText: AnsiString): AnsiString;
function ARC4HexIn(const Key, PlainText: AnsiString): AnsiString;

function ARC4Encrypt(const Key, PlainText: AnsiString): AnsiString;

implementation

uses SysUtils, DebenuPDFLibraryExtra;

function ARC4HexOut(const Key, PlainText: AnsiString): AnsiString;
var
  S: AnsiString;
  X: Integer;
begin
  S := ARC4Encrypt(Key, PlainText);
  Result := '';
  for X := 1 to Length(S) do
    Result := Result + QPLIntToHex(Ord(S[X]), 2);
  Result := QPLLowerCase(Result);
end;

function ARC4HexIn(const Key, PlainText: AnsiString): AnsiString;
var
  S: AnsiString;
  X: Integer;
begin
  Result := QPLLowerCase(PlainText);
  for X := 1 to Length(Result) div 2 do
    S := S + AnsiChar(QPLStrToIntDef('$' + QPLCopy(Result, X * 2 - 1, 2), 65));
  Result := ARC4Encrypt(Key, S);
end;

function ARC4Encrypt(const Key, PlainText: AnsiString): AnsiString;
var
  X: Integer;
  S: array[0..255] of Byte;
  K: array of Byte;
  i, n: Integer;
  KeyLen: Integer;
  Temp: Byte;
  t: Byte;
  B: Integer;
begin
  SetLength(Result, Length(PlainText));
  for X := 1 to Length(Result) do
    Result[X] := #0;

  // Setup the byte arrays
  for X := 0 to 255 do
    S[X] := X;
  SetLength(K, 256);
  KeyLen := Length(Key);
  for X := 0 to 255 do
    K[X] := Ord(Key[(X mod KeyLen) + 1]);

  n := 0;
  for i := 0 to 255 do
  begin
    n := (n + S[i] + K[i]) mod 256;
    Temp := S[i];
    S[i] := S[n];
    S[n] := Temp;
  end;

  i := 0;
  n := 0;
  for X := 1 to Length(PlainText) do
  begin
    i := (i + 1) mod 256;
    n := (n + S[i]) mod 256;
    Temp := S[i];
    S[i] := S[n];
    S[n] := Temp;
    t := (S[i] + S[n]) mod 256;
    B := Ord(PlainText[X]);
    B := S[t] xor B;
    Result[X] := AnsiChar(B);
  end;
end;

end.
