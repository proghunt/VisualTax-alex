{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryEncoding.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryEncoding;

{$I DebenuPDFLibraryDefines.inc}

interface

function QPLDecodeTextString(const Input: AnsiString): WideString;
function QPLEncodeTextString(const WS: WideString; AlwaysWide: Boolean = False): AnsiString;
function QPLEncodePDFDoc(const Input: WideString): AnsiString;
function QPLLatin1ToWideString(const Input: AnsiString): WideString;
function QPLWideStringToLatin1(const Input: WideString): AnsiString;

function QPLEncodeStringFromCodes(NumberList: array of Cardinal;
  const Encoding: AnsiString; IgnoreMismatch: Boolean): WideString;

implementation

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  DebenuPDFLibraryFontConst, DebenuPDFLibraryUnicode, DebenuPDFLibraryCMap, DebenuPDFLibraryExtra;

// Returns a value between 0 and 255 if the
// specified WideChar is in the PDFDocEncoding
// character set, otherwise returns -1
function ValidPDFDocWideChar(C: WideChar): Integer;
var
  X: Integer;
begin
  // Check for direct mapping to improve speed
  if PDFDocUnicode[Word(C) and $FF] = C then
  begin
    Result := Word(C) and $FF;
  end else
  begin
    Result := -1;
    X := 0;
    repeat
      if PDFDocUnicode[X] = C then Result := X;
      Inc(X);
    until (Result >= 0) or (X > 255);
  end;
end;

// Returns either a PDFDoc encoded AnsiString or a UTF-16BE with BOM
// encoded AnsiString from a Unicode input string in UTF-16LE without BOM.
// If AlwaysWide is true then always use UTF-16BE format
function QPLEncodeTextString(const WS: WideString; AlwaysWide: Boolean): AnsiString;
var
  X: Integer;
  C: Integer;
  Temp: WideString;
  PDFDoc: AnsiString;
  Input: WideString;
begin
  Input := QPLLengthAdjustment(WS);
  
  if Length(Input) = 0 then
  begin
    Result := '';
  end else
  begin
    if AlwaysWide then
    begin
      SetLength(PDFDoc, 0);
    end else
    begin
      SetLength(PDFDoc, Length(Input));
      for X := 1 to Length(Input) do
      begin
        if (Length(PDFDoc) > 0) then
        begin
          C := ValidPDFDocWideChar(Input[X]);
          if C >= 0 then
          begin
            PDFDoc[X] := AnsiChar(C);
          end else
          begin
            // The Unicode character was not in the PDFDocEncoding
            // character set
            SetLength(PDFDoc, 0);
          end;
        end;
      end;
    end;

    if Length(PDFDoc) > 0 then
    begin
      // We have a valid 8-bit string in PDFDocEncoding format
      Result := PDFDoc;
    end else
    begin
      // Need to convert to UTF-16BE with BOM
      QPLUnicodeConvert16To16(Input, Temp, QPLUnicodeUTF16LE, QPLUnicodeUTF16BE,
        QPLUnicodeForce, QPLUnicodeMark);

      SetLength(Result, Length(Temp) * 2);
      Move(Temp[1], Result[1], Length(Result));
    end;
  end;
end;

// Converts an 8-bit string containing UTF-16BE with BOM or a PDFDocEncoding
// encoded string to UTF-16LE without BOM
function QPLDecodeTextString(const Input: AnsiString): WideString;
var
  X: Integer;
  IsUnicode: Boolean;
  Buffer16: WideString;
begin
  IsUnicode := False;
  if (Length(Input) >= 2) then
  begin
    // Look for the BOM
    if (Byte(Input[1]) = $FE) and (Byte(Input[2]) = $FF) then
    begin
      IsUnicode := True;
    end else
    if (Byte(Input[1]) = $FF) and (Byte(Input[2]) = $FE) then
    begin
      // String is in UTF-16LE already, strip the BOM
      SetLength(Result, (Length(Input) - 2) div 2);
      Move(Input[3], Result[1], Length(Result) * 2);
      Exit;
    end;
  end;

  if IsUnicode then
  begin
    // Input buffer contains a UTF-16BE with BOM
    SetLength(Buffer16, Length(Input) div 2);
    if (Length(Buffer16) * 2) < Length(Input) then
    begin
      SetLength(Buffer16, Length(Buffer16) + 1);
      Buffer16[Length(Buffer16)] := WideChar(0);
    end;
    Move(Input[1], Buffer16[1], Length(Input));

    QPLUnicodeConvert16To16(Buffer16, Result, QPLUnicodeUTF16BE, QPLUnicodeUTF16LE,
      QPLUnicodeStrip, QPLUnicodeMark);
  end else
  begin
    // Content is encoded with PDFDocEncoding
    SetLength(Result, Length(Input));
    for X := 1 to Length(Input) do
    begin
      Result[X] := PDFDocUnicode[Byte(Input[X])];
    end;
  end;
end;

// Converts a 16-bit Unicode string in UTF-16LE format to
// an 8-bit string containing only characters from the
// PDFDocEncoding character set. Unicode characters that
// cannot be matched are converted to a question mark (U+003F)
function QPLEncodePDFDoc(const Input: WideString): AnsiString;
var
  X: Integer;
  C: Integer;
begin
  SetLength(Result, 0);
  if Length(Input) > 0 then
  begin
    SetLength(Result, Length(Input));
    for X := 1 to Length(Input) do
    begin
      C := ValidPDFDocWideChar(Input[X]);
      if C >= 0 then
      begin
        Result[X] := AnsiChar(C);
      end else
      begin
        // The Unicode character was not in the PDFDocEncoding
        // character set
        Result[X] := '?';
      end;
    end;
  end;
end;

function QPLEncodeStringFromCodes(NumberList: array of Cardinal;
  const Encoding: AnsiString; IgnoreMismatch: Boolean): WideString;
var
  Buffer8: AnsiString;
  Buffer16: WideString;
  X: Integer;
  MalformedAction: TQPLUnicodeMalformed;
  //CP932Char: WideString;
  EncodeList: TQPLWordPairList;

begin
  SetLength(Result, 0);

  if IgnoreMismatch then
  begin
    MalformedAction := QPLUnicodeIgnore;
  end else
  begin
    MalformedAction := QPLUnicodeMark;
  end;

  if Encoding = 'Unicode' then
  begin
    QPLUnicodeConvertArrayTo16(NumberList, Result,
      QPLUnicodeUTF16LE, QPLUnicodeStrip, MalformedAction);
  end else
  if Encoding = 'UTF-8' then
  begin
    SetLength(Buffer8, Length(NumberList));
    for X := 0 to Length(NumberList) - 1 do
    begin
      if (NumberList[X] <= $F4) then
      begin
        Buffer8[X + 1] := AnsiChar(NumberList[X] and $FF);
      end else
      begin
        // Out of range
        Buffer8[X + 1] := AnsiChar($FF);
      end;
    end;
    QPLUnicodeConvert8To16(Buffer8, Result, QPLUnicodeUTF8,
      QPLUnicodeUTF16LE, QPLUnicodeStrip, MalformedAction);
  end else
  if Encoding = 'UTF-16' then
  begin
    SetLength(Buffer16, Length(NumberList));
    for X := 0 to Length(NumberList) - 1 do
    begin
      if (NumberList[X] <= $FFFF) then
      begin
        Buffer16[X + 1] := WideChar(NumberList[X] and $FFFF);
      end else
      begin
        // Out of range
        Buffer16[X + 1] := WideChar($FFFD);
      end;
    end;
    QPLUnicodeConvert16To16(Buffer16, Result, QPLUnicodeUTF16LE,
      QPLUnicodeUTF16LE, QPLUnicodeStrip, MalformedAction);
  end else
  if Encoding = 'UTF-16LE' then
  begin
    X := Length(NumberList) div 2;
    if X * 2 < Length(NumberList) then Inc(X);
    SetLength(Buffer16, X);
    for X := 1 to Length(Buffer16) do
    begin
      if ((NumberList[X * 2 - 2] <= $FF) and (NumberList[X * 2 - 1] <= $FF)) then
      begin
        Buffer16[X] := WideChar((NumberList[X * 2 - 2] +
          NumberList[X * 2 - 1] * 256) and $FFFF);
      end else
      begin
        // Out of range
        Buffer16[X] := WideChar($FFFD);
      end;
    end;
    QPLUnicodeConvert16To16(Buffer16, Result, QPLUnicodeUTF16LE,
      QPLUnicodeUTF16LE, QPLUnicodeStrip, MalformedAction);
  end else
  if Encoding = 'UTF-16BE' then
  begin
    X := Length(NumberList) div 2;
    if X * 2 < Length(NumberList) then Inc(X);
    SetLength(Buffer16, X);
    for X := 1 to Length(Buffer16) do
    begin
      if ((NumberList[X * 2 - 2] <= $FF) and (NumberList[X * 2 - 1] <= $FF)) then
      begin
        Buffer16[X] := WideChar((NumberList[X * 2 - 1] +
          NumberList[X * 2 - 2] * 256) and $FFFF);
      end else
      begin
        // Out of range
        Buffer16[X] := WideChar($FFFD);
      end;
    end;
    QPLUnicodeConvert16To16(Buffer16, Result, QPLUnicodeUTF16LE,
      QPLUnicodeUTF16LE, QPLUnicodeStrip, MalformedAction);
  end
  else
  if Encoding = 'CP932' then
  begin
    EncodeList := LoadCPToUnicode(932);
    SetLength(Buffer16, Length(NumberList));
    for X := 0 to Length(NumberList) - 1 do
    begin
      Buffer16[X + 1] := WideChar(EncodeList.GetValue(NumberList[X]));
    end;
    QPLUnicodeConvert16To16(Buffer16, Result, QPLUnicodeUTF16LE,
      QPLUnicodeUTF16LE, QPLUnicodeStrip, MalformedAction);
  end
  else if Encoding = 'CP936' then
  begin
    EncodeList := LoadCPToUnicode(936);
    SetLength(Buffer16, Length(NumberList));
    for X := 0 to Length(NumberList) - 1 do
    begin
      Buffer16[X + 1] := WideChar(EncodeList.GetValue(NumberList[X]));
    end;
    QPLUnicodeConvert16To16(Buffer16, Result, QPLUnicodeUTF16LE,
      QPLUnicodeUTF16LE, QPLUnicodeStrip, MalformedAction);
  end
  else if Encoding = 'CP949' then
  begin
    EncodeList := LoadCPToUnicode(949);
    SetLength(Buffer16, Length(NumberList));
    for X := 0 to Length(NumberList) - 1 do
    begin
      Buffer16[X + 1] := WideChar(EncodeList.GetValue(NumberList[X]));
    end;
    QPLUnicodeConvert16To16(Buffer16, Result, QPLUnicodeUTF16LE,
      QPLUnicodeUTF16LE, QPLUnicodeStrip, MalformedAction);
  end
  else if Encoding = 'CP950' then
  begin
    EncodeList := LoadCPToUnicode(950);
    SetLength(Buffer16, Length(NumberList));
    for X := 0 to Length(NumberList) - 1 do
    begin
      Buffer16[X + 1] := WideChar(EncodeList.GetValue(NumberList[X]));
    end;
    QPLUnicodeConvert16To16(Buffer16, Result, QPLUnicodeUTF16LE,
      QPLUnicodeUTF16LE, QPLUnicodeStrip, MalformedAction);
  end;
end;

// Converts a sequence of 8-bit bytes stored in an AnsiString
// to a WideString interpreting the byte values as
// ISO-8859-1 (Latin-1) character codes which means
//    0x00 to 0xFF  ->  0+0000 to 0+00FF
function QPLLatin1ToWideString(const Input: AnsiString): WideString;
var
  X: Integer;
begin
  SetLength(Result, Length(Input));
  if Length(Input) > 0 then
  begin
    for X := 1 to Length(Input) do
    begin
      if Byte(Input[X]) < $7F then
      begin
        Result[X] := WideChar(Byte(Input[X]));
      end else
      begin
        Result[X] := WideChar($FFFD);
      end;
    end;
  end;
end;

function QPLWideStringToLatin1(const Input: WideString): AnsiString;
var
  X: Integer;
begin
  Result := '';
  for X := 1 to Length(Input) do
  begin
    if Word(Input[X]) <= $FF then
    begin
      Result := Result + AnsiChar(Word(Input[X]));
    end;
  end;
end;

end.
