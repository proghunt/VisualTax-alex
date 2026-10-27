{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryAscii85.pas                            }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryAscii85;

{$I DebenuPDFLibraryDefines.inc}

{$Q-}

interface

uses
  Classes;

function Ascii85Decode(const Input: AnsiString): AnsiString;
procedure Ascii85Encode(InStream, OutStream: TStream);
function Ascii85EncodeStr(const Input: AnsiString): AnsiString;

implementation

uses
  SysUtils, DebenuPDFLibraryExtra;

function Ascii85Decode(const Input: AnsiString): AnsiString;
var
  S: AnsiString;
  B: array[1..4] of Byte;
  D: Cardinal;
  DD: Double;
  C: array[1..5] of Byte;
  X: Integer;
  R: Integer;
  P: Integer;
  M: Integer;
  RX: Integer;
  RL: Integer;
  LastPos: Integer;
begin
  LastPos := -1;
  S := '';
  SetLength(Result, 1000);
  RL := 1000;
  SetLength(S, Length(Input));
  RX := 0;
  for X := 1 to Length(Input) do
  begin
    if (Input[X] >= '!') and (Input[X] <= 'u') then
    begin
      S[RX + 1] := Input[X];
      Inc(RX, 1);
    end;
    if (Input[X] = 'z') then
    begin
      SetLength(S, Length(S) + 4);
      S[RX + 1] := '!';
      S[RX + 2] := '!';
      S[RX + 3] := '!';
      S[RX + 4] := '!';
      S[RX + 5] := '!';
      Inc(RX, 5);
    end;
    if (Input[X] = '~') then
    begin
      S[RX + 1] := Input[X];
      Inc(RX, 1);
      if ((X < Length(Input)) and (Input[X + 1] = '>')) then
      begin
        LastPos := RX + 1;
      end;
    end;
  end;
  SetLength(S, RX);
  if (LastPos > 0) then
  begin
    SetLength(S, LastPos);
  end;
  RX := 1;
  if QPLCopy(S, Length(S) - 1, 2) = '~>' then
  begin
    Delete(S, Length(S) - 1, 2);
    M := Length(S) div 5;
    for P := 0 to M - 1 do
    begin
      Move(S[P * 5 + 1], C[1], 5);
      DD := (C[1] - 33) * 52200625.0 +
           (C[2] - 33) * 614125.0 +
           (C[3] - 33) * 7225.0 +
           (C[4] - 33) * 85.0 +
           (C[5] - 33);
      if DD <= $FFFFFFFF then
        D := Trunc(DD)
      else
        D := 0;
      B[4] := D and $FF;
      B[3] := (D and $FF00) shr 8;
      B[2] := (D and $FF0000) shr 16;
      B[1] := (D and $FF000000) shr 24;
      if RL - RX < 100 then
      begin
        RL := RL + 1000;
        SetLength(Result, RL);
      end;
      Result[RX] := AnsiChar(B[1]);
      Result[RX + 1] := AnsiChar(B[2]);
      Result[RX + 2] := AnsiChar(B[3]);
      Result[RX + 3] := AnsiChar(B[4]);
      Inc(RX, 4);
    end;
    SetLength(Result, RX - 1);
    Delete(S, 1, (Length(S) div 5) * 5);
    R := Length(S);
    S := S + 'uuuuu';
    S := QPLCopy(S, 1, 5);
    for X := 1 to 5 do
      C[X] := Ord(S[X]) - 33;

    DD := C[1] * 52200625.0 +
         C[2] * 614125.0 +
         C[3] * 7225.0 +
         C[4] * 85.0 +
         C[5];
    if DD < $FFFFFFFF then
      D := Trunc(DD)
    else
      D := 0;
    B[4] := D and $FF;
    B[3] := (D and $FF00) shr 8;
    B[2] := (D and $FF0000) shr 16;
    B[1] := (D and $FF000000) shr 24;

    for X := 1 to R - 1 do
      Result := Result + AnsiChar(B[X]);
  end;
end;

procedure Ascii85Encode(InStream, OutStream: TStream);
var
  D: Cardinal;
  B: array[1..4] of Byte;
  C: array[1..5] of Byte;
  R: Integer;
  Block: AnsiString;
  X: Integer;
begin
  R := -1;
  InStream.Seek(0, soFromBeginning);
  Block := '';
  while R <> 0 do
  begin
    R := InStream.Read(B[1], 4);
    if R > 0 then
    begin
      for X := R + 1 to 4 do
        B[X] := 0;

      D := B[1] * 256 * 256 * 256 +
           B[2] * 256 * 256 +
           B[3] * 256 +
           B[4];

      C[1] := D div (85 * 85 * 85 * 85);
      D := D - C[1] * 85 * 85 * 85 * 85;
      C[2] := D div (85 * 85 * 85);
      D := D - C[2] * 85 * 85 * 85;
      C[3] := D div (85 * 85);
      D := D - C[3] * 85 * 85;
      C[4] := D div 85;
      D := D - C[4] * 85;
      C[5] := D;

      for X := 1 to R + 1 do
        Block := Block + AnsiChar(C[X] + 33);

      if QPLCopy(Block, Length(Block) - 4, 5) = '!!!!!' then
      begin
        Delete(Block, Length(Block) - 4, 5);
        Block := Block + 'z';
      end;

      if Length(Block) > 70 then
      begin
        Block := Block + #13#10;
        OutStream.Write(Block[1], Length(Block));
        Block := '';
      end;
    end;
  end;
  Block := Block + '~>';
  OutStream.Write(Block[1], Length(Block));
end;

function Ascii85EncodeStr(const Input: AnsiString): AnsiString;
var
  SS: TStringStream;
  MS: TMemoryStream;
begin
  SS := TStringStream.Create(Input);
  try
    MS := TMemoryStream.Create;
    try
      Ascii85Encode(SS, MS);
      SetLength(Result, MS.Size);
      MS.Seek(0, soFromBeginning);
      MS.Read(Result[1], MS.Size);
    finally
      MS.Free;
    end;
  finally
    SS.Free;
  end;
end;

end.
