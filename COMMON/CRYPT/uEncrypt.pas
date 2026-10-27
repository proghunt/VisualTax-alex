unit uEncrypt;

interface

function Decrypt(const S: AnsiString; Key: Word): AnsiString; overload;
function Encrypt(const S: AnsiString; Key: Word): AnsiString; overload;

function Decrypt(const S: AnsiString; Key: String; Salt: Boolean = False): AnsiString; overload;
function Encrypt(const S: AnsiString; Key: String; Salt: Boolean = False): AnsiString; overload;

implementation

const
  C1 = 52845;
  C2 = 22719;

function Decode(const S: AnsiString): AnsiString;
const
  Map: array [AnsiChar] of Byte = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 62, 0, 0, 0, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 0, 0, 0,
    0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
    18, 19, 20, 21, 22, 23, 24, 25, 0, 0, 0, 0, 0, 0, 26, 27, 28, 29, 30, 31,
    32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
    51, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0);
var
  I: LongInt;
begin
  case Length(S) of
    2:
      begin
        I := Map[S[1]] + (Map[S[2]] shl 6);
        SetLength(Result, 1);
        Move(I, Result[1], Length(Result))
      end;
    3:
      begin
        I := Map[S[1]] + (Map[S[2]] shl 6) + (Map[S[3]] shl 12);
        SetLength(Result, 2);
        Move(I, Result[1], Length(Result))
      end;
    4:
      begin
        I := Map[S[1]] + (Map[S[2]] shl 6) + (Map[S[3]] shl 12) +
          (Map[S[4]] shl 18);
        SetLength(Result, 3);
        Move(I, Result[1], Length(Result))
      end
  end
end;

function PreProcess(const S: AnsiString): AnsiString;
var
  SS: AnsiString;
begin
  SS := S;
  Result := '';
  while SS <> '' do
  begin
    Result := Result + Decode(Copy(SS, 1, 4));
    Delete(SS, 1, 4)
  end
end;

function InternalDecrypt(const S: AnsiString; Key: Word): AnsiString;
var
  I: Word;
  Seed: Word;
  C: Cardinal;
begin
  Result := S;
  Seed := Key;
  for I := 1 to Length(Result) do
  begin
    Result[I] := AnsiChar(Byte(Result[I]) xor (Seed shr 8));
    //20161210 Igor>>>
    C := Byte(S[I]) + Seed;
    C := C * C1;
    C := C + C2;
    //C := (Byte(S[I]) + Seed) * Word(C1) + Word(C2);
    //20161210 Igor <<<
    Seed := WORD(C mod 65535);
  end
end;

function Decrypt(const S: AnsiString; Key: Word): AnsiString;
begin
  Result := InternalDecrypt(PreProcess(S), Key)
end;

function Encode(const S: AnsiString): AnsiString;
const
  Map: array [0 .. 63] of AnsiChar = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +//20170811 Igor
    'abcdefghijklmnopqrstuvwxyz0123456789+/';
var
  I: LongInt;
begin
  I := 0;
  Move(S[1], I, Length(S));
  case Length(S) of
    1:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64];
    2:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64] + Map[(I shr 12) mod 64];
    3:
      Result := Map[I mod 64] + Map[(I shr 6) mod 64] + Map[(I shr 12) mod 64] +
        Map[(I shr 18) mod 64]
  end
end;

function PostProcess(const S: AnsiString): AnsiString;
var
  SS: AnsiString;
begin
  SS := S;
  Result := '';
  while SS <> '' do
  begin
    Result := Result + Encode(Copy(SS, 1, 3));
    Delete(SS, 1, 3)
  end
end;

function InternalEncrypt(const S: AnsiString; Key: Word): AnsiString;
var
  I: Word;
  Seed: Word;
  C: Cardinal;
begin
  Result := S;
  Seed := Key;
  for I := 1 to Length(Result) do
  begin
    Result[I] := AnsiChar(Byte(Result[I]) xor (Seed shr 8));
    //20161210 Igor>>>
    C := Byte(Result[I]) + Seed;
    C := C * C1;
    C := C + C2;
//    C := (Byte(Result[I]) + Seed) * Word(C1) + Word(C2);
    //20161210 Igor<<<
    Seed := WORD(C mod 65535);
  end
end;

function Encrypt(const S: AnsiString; Key: Word): AnsiString;
begin
  Result := PostProcess(InternalEncrypt(S, Key))
end;

function NextChar(Akey: String; pos: Integer): Char;
begin
  if pos >= length(AKey) then
    result := AKey[1]
  else
    result := AKey[pos + 1];
end;

function PrePostProcess(S: AnsiString; encr: boolean = true; Salt: Boolean = False): AnsiString;
var
  sufix, sufix2, l1, l2: integer;
  prefix, prefix2: AnsiString;//20170811 Igor
const
  map: AnsiString = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +//20170811 Igor
    'abcdefghijklmnopqrstuvwxyz0123456789+/';
begin
  if not Salt then
  begin
    Result := s;
    exit;
  end;
  if encr then
  begin
    sufix := Random(3) + 1;
    sufix2 := Random(3) + 1;
    l1 := random(9) + 1;
    l2 := random(9) + 1;
    prefix := map[l1];
    while length(prefix) < sufix do
      prefix := prefix + map[random(length(map) - 1) + 1];
    prefix2 := map[l2];
    while length(prefix2) < sufix2 do
      prefix2 := map[random(length(map) - 1) + 1] + prefix2;
    result := prefix  +  map[sufix2 * l2] + s + prefix2 + map[sufix * l1];
  end
  else
  begin
    result := s;
    sufix := pos(result[length(result)], map) div pos(result[1], map);
    Delete(result, 1, sufix);
    Delete(result, length(result), 1);
    sufix := pos(result[1], map) div pos(result[length(result)], map);
    Delete(Result, 1, 1);
    Delete(Result, length(Result) - sufix + 1, sufix);
  end;
end;

function Decrypt(const S: AnsiString; Key: String; Salt: Boolean = False): AnsiString;
var
  ss: AnsiString;//20170811 Igor
  i: integer;
begin
  ss := s;
  result := '';
  i := 1;
  while length(ss) > 0 do
  begin
    result := result + Decrypt(copy(ss, 1, 4), ord(key[i]) + ord(NextChar(key,i)));
    inc(i);
    if i > length(Key) then
      i := 1;
    delete(ss, 1, 4);
  end;
  result := PrePostProcess(result, false, Salt);
end;




function Encrypt(const S: AnsiString; Key: String; Salt: Boolean = False): AnsiString;
var
  ss: AnsiString;//20170811 Igor
  i: integer;
begin
  Randomize;
  ss := PrePostProcess(s, true, Salt);
  result := '';
  i := 1;
  while length(ss) > 0 do
  begin
    result := result + Encrypt(copy(ss, 1, 3), ord(key[i]) + ord(NextChar(key,i)));
    inc(i);
    if i > length(Key) then
      i := 1;
    delete(ss,1,3);
  end;
end;

end.
