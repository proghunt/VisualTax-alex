{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryUnicode.pas                            }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryUnicode;

{$I DebenuPDFLibraryDefines.inc}

interface

type
  TQPLUnicodeEncoding = (
    QPLUnicodeUTF8,
    QPLUnicodeUTF16LE,
    QPLUnicodeUTF16BE,
    QPLUnicodeUCS2LE,
    QPLUnicodeUCS2BE);

  TQPLUnicodeBOM = (
    QPLUnicodePreserve,   // Preserve existing BOM
    QPLUnicodeStrip,      // Remove existing BOM
    QPLUnicodeForce);     // Output always has a BOM

  TQPLUnicodeMalformed = (
    QPLUnicodeEmpty,    // Return nothing, indicate failure
    QPLUnicodeStop,     // Return valid codes up to illegal input, indicate failure
    QPLUnicodeIgnore,   // Ignore malformed codes, indicate success
    QPLUnicodeMark);    // Mark malformed codes with U+FFFD, indicate success

function QPLUnicodeConvert8To16(const Input: AnsiString; var Output: WideString;
  InputEncoding, OutputEncoding: TQPLUnicodeEncoding;
  BOMAction: TQPLUnicodeBOM;
  MalformedAction: TQPLUnicodeMalformed): Boolean;

function QPLUnicodeConvert16To16(const Input: WideString; var Output: WideString;
  InputEncoding, OutputEncoding: TQPLUnicodeEncoding;
  BOMAction: TQPLUnicodeBOM;
  MalformedAction: TQPLUnicodeMalformed): Boolean;

function QPLUnicodeConvert16To8(const Input: WideString; var Output: AnsiString;
  InputEncoding, OutputEncoding: TQPLUnicodeEncoding;
  BOMAction: TQPLUnicodeBOM;
  MalformedAction: TQPLUnicodeMalformed): Boolean;

function QPLUnicodeConvertArrayTo16(CodePoints: array of Cardinal; var Output: WideString;
  OutputEncoding: TQPLUnicodeEncoding;
  BOMAction: TQPLUnicodeBOM;
  MalformedAction: TQPLUnicodeMalformed): Boolean;

implementation

const
  ReplacementChar: Cardinal = $FFFD;
  InternalErrorChar: Cardinal = $FF0000;
  BOMChar: Cardinal = $FEFF;

// Converts an 8-bit buffer to a 16-bit buffer.
// Returns false if an error occurred
//   Input is the 8-bit input buffer
//   Output is the 16-bit output buffer
//   InputEncoding is the format of the input
//   OutputEncoding is the format of the output
//   BOMAction specifies how a BOM should be handled or added
//   MalformedAction sets the behaviour on ill-formed input
function QPLUnicodeConvert8To16(const Input: AnsiString; var Output: WideString;
  InputEncoding, OutputEncoding: TQPLUnicodeEncoding;
  BOMAction: TQPLUnicodeBOM;
  MalformedAction: TQPLUnicodeMalformed): Boolean;
var
  EndLoop: Boolean;
  InputLength: Integer;
  InputPosition: Integer;
  InputRemaining: Integer;
  OutputLength: Integer;
  OutputCapacity: Integer;
  IB1: Cardinal;
  IB2: Cardinal;
  IB3: Cardinal;
  IB4: Cardinal;
  CodePoint: Cardinal;
  ValidCodePoint: Boolean;
  OutputCodePoint: Boolean;
  MaxCodePoint: Cardinal;
  OW1: Cardinal;
  OW2: Cardinal;
  SurrogateOffset: Cardinal;
  SwapBytes: Boolean;
  ValidSecondByteStart: Cardinal;
  ValidSecondByteEnd: Cardinal;
begin
  Result := True;
  EndLoop := False;
  InputLength := Length(Input);
  MaxCodePoint := 0;
  SwapBytes := False;

  if (InputEncoding <> QPLUnicodeUTF8) then
  begin
    // Return failure - input must be 8-bit
    EndLoop := True;
    Result := False;
  end;

  case OutputEncoding of
    QPLUnicodeUTF8:
    begin
      // Return failure - output must be 16-bit
      EndLoop := True;
      Result := False;
    end;

    QPLUnicodeUTF16LE:
    begin
      SwapBytes := False;
      MaxCodePoint := $10FFFF;
    end;

    QPLUnicodeUTF16BE:
    begin
      SwapBytes := True;
      MaxCodePoint := $10FFFF;
    end;

    QPLUnicodeUCS2LE:
    begin
      SwapBytes := False;
      MaxCodePoint := $FFFF;
    end;

    QPLUnicodeUCS2BE:
    begin
      SwapBytes := True;
      MaxCodePoint := $FFFF;
    end;
  end;

  if (BOMAction = QPLUnicodeForce) then
  begin
    // Add the byte order marker, start with output length of 1
    OutputLength := 1;
    SetLength(Output, 1);

    if (SwapBytes) then
    begin
      Output[1] := WideChar((BOMChar and $FF) shl 8 + (BOMChar and $FF00) shr 8);
    end else
    begin
      Output[1] := WideChar(BOMChar and $FFFF);
    end;
  end else
  begin
    // No byte order marker needed now, output length set to 0
    OutputLength := 0;
  end;

  // Don't process an empty input
  if (Length(Input) = 0) then
  begin
    EndLoop := True;
  end;

  if not EndLoop then
  begin
    InputPosition := 1;

    // Start with an output capacity roughly 10% more than the
    // number of input bytes plus an extra few bytes
    OutputCapacity := Round(Int(InputLength) * 1.1) + 20;

    // Add an extra capacity margin
    SetLength(Output, OutputCapacity + 20);

    repeat

      // Number of bytes left after the current byte
      InputRemaining := InputLength - InputPosition;

      // Start with an invalid code point
      CodePoint := InternalErrorChar;

      case InputEncoding of
        QPLUnicodeUTF8:
        begin
          IB1 := Byte(Input[InputPosition]);
          case IB1 of
            $00..$7F:
            begin
              // Single byte US-ASCII
              CodePoint := IB1;
              Inc(InputPosition);
            end;

            $80..$BF:
            begin
              // Second or later byte of a multi-byte sequence
              CodePoint := ReplacementChar;

              // Consume this byte
              Inc(InputPosition);
            end;

            $C0..$C1:
            begin
              // Overlong encoding (2-byte sequence of codepoint less than $80)
              CodePoint := ReplacementChar;

              // Consume this byte
              Inc(InputPosition);
            end;

            $C2..$DF:
            begin
              // Two byte sequence
              if (InputRemaining >= 1) then
              begin
                IB2 := Byte(Input[InputPosition + 1]);
                if (IB2 and $C0) = $80 then
                begin
                  // 110yyyxx | 10xxxxxx
                  CodePoint := (IB1 and $1F) shl 6 +
                    (IB2 and $3F);

                  // Consume both bytes
                  Inc(InputPosition, 2);
                end else
                begin
                  // Second byte is invalid (must be 10xxxxxx)
                  CodePoint := ReplacementChar;

                  // Consume both bytes
                  Inc(InputPosition, 2);
                end;
              end else
              begin
                // Not enough available input
                CodePoint := ReplacementChar;

                // Consume the first byte (second byte not available)
                Inc(InputPosition);
              end;
            end;

            $E0..$EF:
            begin
              // Three byte sequence
              if (InputRemaining >= 2) then
              begin
                IB2 := Byte(Input[InputPosition + 1]);

                if (IB1 = $E0) then
                begin
                  ValidSecondByteStart := $A0;
                  ValidSecondByteEnd := $BF;
                end else
                if (IB1 = $ED) then
                begin
                  ValidSecondByteStart := $80;
                  ValidSecondByteEnd := $9F;
                end else
                begin
                  ValidSecondByteStart := $80;
                  ValidSecondByteEnd := $BF;
                end;

                if ((IB2 >= ValidSecondByteStart) and (IB2 <= ValidSecondByteEnd)) then
                begin
                  IB3 := Byte(Input[InputPosition + 2]);
                  if (IB3 and $C0) = $80 then
                  begin
                    // 1110yyyy | 10yyyyxx | 10xxxxxx
                    CodePoint := (IB1 and $0F) shl 12 +
                      (IB2 and $3F) shl 6 +
                      (IB3 and $3F);

                    // Consume all three bytes
                    Inc(InputPosition, 3);
                  end else
                  begin
                    // Third byte is invalid (must be 10xxxxxx)
                    CodePoint := ReplacementChar;

                    // Consume all three bytes
                    Inc(InputPosition, 3);
                  end;
                end else
                begin
                  // Second byte is not in a valid range
                  if (MalformedAction <> QPLUnicodeIgnore) then
                  begin
                    CodePoint := ReplacementChar;

                    // Consume first two bytes
                    Inc(InputPosition, 2);
                  end
                  else
                  begin // ADC - Ignore errors and use original characters.
                    CodePoint := IB1;
                    Inc(InputPosition, 1);
                  end;
                end;
              end else
              begin
                // Not enough available input
                CodePoint := ReplacementChar;

                if (InputRemaining > 1) then
                begin
                  // Consume the first and second byte (third not available)
                  Inc(InputPosition, 2);
                end else
                begin
                  // Consume the first byte (second and third not available)
                  Inc(InputPosition);
                end;
              end;
            end;

            $F0..$F4:
            begin
              // Four byte sequence
              if (InputRemaining >= 3) then
              begin
                IB2 := Byte(Input[InputPosition + 1]);

                if (IB1 = $F0) then
                begin
                  ValidSecondByteStart := $90;
                  ValidSecondByteEnd := $BF;
                end else
                if (IB1 = $F4) then
                begin
                  ValidSecondByteStart := $80;
                  ValidSecondByteEnd := $8F;
                end else
                begin
                  ValidSecondByteStart := $80;
                  ValidSecondByteEnd := $BF;
                end;

                if ((IB2 >= ValidSecondByteStart) and (IB2 <= ValidSecondByteEnd)) then
                begin
                  IB3 := Byte(Input[InputPosition + 2]);
                  if (IB3 and $C0) = $80 then
                  begin
                    IB4 := Byte(Input[InputPosition + 3]);
                    if (IB4 and $C0) = $80 then
                    begin
                      // 11110zzz | 10zzyyyy | 10yyyyxx | 10xxxxxx
                      CodePoint := (IB1 and $07) shl 18 +
                        (IB2 and $3F) shl 12 +
                        (IB3 and $3F) shl 6 +
                        (IB4 and $3F);

                      // Consume all four bytes
                      Inc(InputPosition, 4);
                    end else
                    begin
                      // Fourth byte is invalid (must be 10xxxxxx)
                      CodePoint := ReplacementChar;

                      // Consume all four bytes
                      Inc(InputPosition, 4);
                    end;
                  end else
                  begin
                    // Third byte is invalid (must be 10xxxxxx)
                    CodePoint := ReplacementChar;

                    // Consume the first three bytes
                    Inc(InputPosition, 3);
                  end;
                end else
                begin
                  // Second byte is invalid (must be 10xxxxxx)
                  CodePoint := ReplacementChar;

                  // Consume the first two bytes
                  Inc(InputPosition, 2);
                end;
              end else
              begin
                // Not enough available input
                CodePoint := ReplacementChar;

                if (InputRemaining > 2) then
                begin
                  // Consume the first to third bytes (fourth not available)
                  Inc(InputPosition, 3);
                end else
                if (InputRemaining > 1) then
                begin
                  // Consume the first and second byte (third to fourth not available)
                  Inc(InputPosition, 2);
                end else
                begin
                  // Consume the first byte (second to fourth not available)
                  Inc(InputPosition);
                end;
              end;
            end;

            $F5..$FF:
            begin
              // F5 to F7: 4-byte sequence of codepoint above U+10FFFF
              // F8 to FB: 5-byte sequence
              // FC to FD: 6-byte sequence
              // FE to FF: Undefined
              CodePoint := ReplacementChar;

              // Consume this byte
              Inc(InputPosition);
            end;
          end;
        end;
      end;

      // Check for invalid code points
      ValidCodePoint := True;
      if (CodePoint = InternalErrorChar) then
      begin
        // Internal error - stop processing
        EndLoop := True;
        ValidCodePoint := False;
      end else
      if (CodePoint = ReplacementChar) then
      begin
        // We have a replacement code
        ValidCodePoint := False;
      end else
      if (CodePoint > MaxCodePoint) then
      begin
        // Out of range (depends on requested output encoding format)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $FFF800) = $00D800) then
      begin
        // High or low surrogate (U+00D800 to U+00DFFF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $00FFFE) = $00FFFE) then
      begin
        // Noncharacter (U+xxFFFE and U+xxFFFF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $FFFFF0) = $00FDD0) then
      begin
        // Noncharacter (U+00FDD0 to U+00FDDF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $FFFFF0) = $00FDE0) then
      begin
        // Noncharacter (U+00FDE0 to U+00FDEF)
        ValidCodePoint := False;
      end;

      // Check if the code point should be output
      OutputCodePoint := True;
      if (not ValidCodePoint) then
      begin
        // Process the invalid code point
        case MalformedAction of
          QPLUnicodeEmpty:
          begin
            // Return an empty string
            if BOMAction = QPLUnicodeForce then
            begin
              // Keep the byte order marker that was added earlier
              OutputLength := 1;
            end else
            begin
              // No byte order marker on the output
              OutputLength := 0;
            end;

            // End processing
            EndLoop := True;
            OutputCodePoint := False;

            // Return failure
            Result := False;
          end;

          QPLUnicodeStop:
          begin
            // End processing keeping existing code points
            EndLoop := True;
            OutputCodePoint := False;

            // Return failure
            Result := False;
          end;

          QPLUnicodeIgnore:
          begin
            // Ignore the invalid code point
            OutputCodePoint := False;
          end;

          QPLUnicodeMark:
          begin
            // Mark the invalid code point
            CodePoint := ReplacementChar;
            OutputCodePoint := True;
          end;
        end;
      end else
      begin
        // Process the valid code point
        if ((CodePoint = $FEFF) and (OutputLength = 0)) then
        begin
          // Byte order marker
          case BOMAction of
            QPLUnicodePreserve:
            begin
              // Add the byte order marker
              OutputCodePoint := True;
            end;

            QPLUnicodeStrip:
            begin
              // Ignore the byte order marker
              OutputCodePoint := False;
            end;

            QPLUnicodeForce:
            begin
              // Keep the byte order marker that was added earlier
              OutputCodePoint := False;
            end;
          end;
        end else
        begin
          // Valid code point that isn't a byte order marker
          OutputCodePoint := True;
        end;
      end;

      if OutputCodePoint then
      begin
        if (CodePoint >= $FFFF) then
        begin
          // Output a surrogate pair (two 16-bit values)
          // U+10hh hhhh
          // From: [ 0001xxxx xxxxxxyy yyyyyyyy ]
          // To: [ 110110xx xxxxxxxx ] and [ 110111yy yyyyyyyy ]

          SurrogateOffset := CodePoint - $10000;
          OW1 := ((SurrogateOffset and $FFC00) shr 10) + $D800;
          OW2 := (SurrogateOffset and $3FF) + $DC00;

          if (SwapBytes) then
          begin
            Inc(OutputLength);
            Output[OutputLength] := WideChar((OW1 and $FF) shl 8 +
              (OW1 and $FF00) shr 8);
            Inc(OutputLength);
            Output[OutputLength] := WideChar((OW2 and $FF) shl 8 +
              (OW2 and $FF00) shr 8);
          end else
          begin
            Inc(OutputLength);
            Output[OutputLength] := WideChar(OW1);
            Inc(OutputLength);
            Output[OutputLength] := WideChar(OW2);
          end;
        end else
        begin
          // Output one 16-bit value
          if (SwapBytes) then
          begin
            Inc(OutputLength);
            Output[OutputLength] := WideChar((CodePoint and $FF) shl 8 +
              (CodePoint and $FF00) shr 8);
          end else
          begin
            Inc(OutputLength);          
            Output[OutputLength] := WideChar(CodePoint);
          end;
        end;

        if (OutputLength >= OutputCapacity) then
        begin
          // Increase the output capacity by an amount equal to
          // twice the number of remaining bytes plus a few extra
          Inc(OutputCapacity, (InputLength - InputPosition) * 2 + 20);

          // Add an extra capacity margin
          SetLength(Output, OutputCapacity + 20);
        end;
      end;

      if (InputPosition > InputLength) then
      begin
        // Reached the end of the input
        EndLoop := True;
      end;
    until EndLoop;
  end;

  SetLength(Output, OutputLength);
end;

// Converts a 16-bit buffer to another 16-bit buffer.
// Returns false if an error occurred
//   Input is the 16-bit input buffer
//   Output is the 16-bit output buffer
//   InputEncoding is the format of the input
//   OutputEncoding is the format of the output
//   BOMAction specifies how a BOM should be handled or added
//   MalformedAction sets the behaviour on ill-formed input
function QPLUnicodeConvert16To16(const Input: WideString; var Output: WideString;
  InputEncoding, OutputEncoding: TQPLUnicodeEncoding;
  BOMAction: TQPLUnicodeBOM;
  MalformedAction: TQPLUnicodeMalformed): Boolean;
var
  EndLoop: Boolean;
  InputLength: Integer;
  InputPosition: Integer;
  SwapBytes: Boolean;
  MaxCodePoint: Cardinal;
  OutputLength: Integer;
  OutputCapacity: Integer;
  InputRemaining: Integer;
  CodePoint: Cardinal;
  IW1: Cardinal;
  IW2: Cardinal;
  ValidCodePoint: Boolean;
  OutputCodePoint: Boolean;
  SurrogateOffset: Cardinal;
  OW1: Cardinal;
  OW2: Cardinal;
begin
  Result := True;
  EndLoop := False;
  InputLength := Length(Input);
  MaxCodePoint := 0;
  SwapBytes := False;

  if (InputEncoding = QPLUnicodeUTF8) then
  begin
    // Return failure - input must be 16-bit
    EndLoop := True;
    Result := False;
  end;

  case OutputEncoding of
    QPLUnicodeUTF8:
    begin
      // Return failure - output must be 16-bit
      EndLoop := True;
      Result := False;
    end;

    QPLUnicodeUTF16LE:
    begin
      SwapBytes := False;
      MaxCodePoint := $10FFFF;
    end;

    QPLUnicodeUTF16BE:
    begin
      SwapBytes := True;
      MaxCodePoint := $10FFFF;
    end;

    QPLUnicodeUCS2LE:
    begin
      SwapBytes := False;
      MaxCodePoint := $FFFF;
    end;

    QPLUnicodeUCS2BE:
    begin
      SwapBytes := True;
      MaxCodePoint := $FFFF;
    end;
  end;

  if (BOMAction = QPLUnicodeForce) then
  begin
    // Add the byte order marker, start with output length of 1
    OutputLength := 1;
    SetLength(Output, 1);

    if (SwapBytes) then
    begin
      Output[1] := WideChar((BOMChar and $FF) shl 8 + (BOMChar and $FF00) shr 8);
    end else
    begin
      Output[1] := WideChar(BOMChar and $FFFF);
    end;
  end else
  begin
    // No byte order marker needed now, output length set to 0
    OutputLength := 0;
  end;

  // Don't process an empty input
  if (Length(Input) = 0) then
  begin
    EndLoop := True;
  end;

  if not EndLoop then
  begin
    InputPosition := 1;

    // Start with an output capacity roughly 10% more than the
    // number of input bytes plus an extra few bytes
    OutputCapacity := Round(Int(InputLength) * 1.1) + 20;

    // Add an extra capacity margin
    SetLength(Output, OutputCapacity + 20);

    repeat

      // Number of words left after the current word
      InputRemaining := InputLength - InputPosition;

      // Start with an invalid code point
      // CodePoint := InternalErrorChar;

      if (InputEncoding = QPLUnicodeUTF16LE) or
        (InputEncoding = QPLUnicodeUCS2LE) then
      begin
        // Little endian
        IW1 := Word(Input[InputPosition]);
      end else
      begin
        // Big endian
        IW1 := Word(Input[InputPosition]);
        IW1 := (IW1 and $FF00) shr 8 + (IW1 and $FF) shl 8;
      end;

      if (InputEncoding = QPLUnicodeUTF16BE) or
        (InputEncoding = QPLUnicodeUTF16LE) then
      begin
        if (IW1 >= $DC00) and (IW1 <= $DFFF) then
        begin
          // Found an out of order second surrogate
          CodePoint := ReplacementChar;

          // Consume this word
          Inc(InputPosition);
        end else
        if (IW1 >= $D800) and (IW1 <= $DBFF) then
        begin
          // Found a first surrogate
          if (InputRemaining >= 1) then
          begin
            if (InputEncoding = QPLUnicodeUTF16LE) then
            begin
              // Little endian
              IW2 := Word(Input[InputPosition + 1]);
            end else
            begin
              // Big endian
              IW2 := Word(Input[InputPosition + 1]);
              IW2 := (IW2 and $FF00) shr 8 + (IW2 and $FF) shl 8;
            end;

            if (IW2 >= $DC00) and (IW2 <= $DFFF) then
            begin
              // Second surrogate is in range
              CodePoint := (IW1 and $3FF) shl 10 + (IW2 and $3FF) + $10000;

              // Consume both words
              Inc(InputPosition, 2);
            end else
            begin
              // Second surrogate is out of range
              CodePoint := ReplacementChar;

              // Consume both words
              Inc(InputPosition, 2);
            end;
          end else
          begin
            // Second surrogate not found
            CodePoint := ReplacementChar;

            // Consume this word
            Inc(InputPosition);
          end;
        end else
        begin
          // Not a surrogate so it is valid
          CodePoint := IW1;

          // Consume this word
          Inc(InputPosition);
        end;
      end else
      begin
        // Surrogates are not allowed
        if (IW1 >= $D800) and (IW1 <= $DFFF) then
        begin
          CodePoint := ReplacementChar;
        end else
        begin
          CodePoint := IW1;
        end;

        // Consume this word
        Inc(InputPosition);
      end;

      // Check for invalid code points
      ValidCodePoint := True;
      if (CodePoint = InternalErrorChar) then
      begin
        // Internal error - stop processing
        EndLoop := True;
        ValidCodePoint := False;
      end else
      if (CodePoint = ReplacementChar) then
      begin
        // We have a replacement code
        ValidCodePoint := False;
      end else
      if (CodePoint > MaxCodePoint) then
      begin
        // Out of range (depends on requested output encoding format)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $FFF800) = $00D800) then
      begin
        // High or low surrogate (U+00D800 to U+00DFFF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $00FFFE) = $00FFFE) then
      begin
        // Noncharacter (U+xxFFFE and U+xxFFFF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $FFFFF0) = $00FDD0) then
      begin
        // Noncharacter (U+00FDD0 to U+00FDDF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $FFFFF0) = $00FDE0) then
      begin
        // Noncharacter (U+00FDE0 to U+00FDEF)
        ValidCodePoint := False;
      end;

      // Check if the code point should be output
      OutputCodePoint := True;
      if (not ValidCodePoint) then
      begin
        // Process the invalid code point
        case MalformedAction of
          QPLUnicodeEmpty:
          begin
            // Return an empty string
            if BOMAction = QPLUnicodeForce then
            begin
              // Keep the byte order marker that was added earlier
              OutputLength := 1;
            end else
            begin
              // No byte order marker on the output
              OutputLength := 0;
            end;

            // End processing
            EndLoop := True;
            OutputCodePoint := False;

            // Return failure
            Result := False;
          end;

          QPLUnicodeStop:
          begin
            // End processing keeping existing code points
            EndLoop := True;
            OutputCodePoint := False;

            // Return failure
            Result := False;
          end;

          QPLUnicodeIgnore:
          begin
            // Ignore the invalid code point
            OutputCodePoint := False;
          end;

          QPLUnicodeMark:
          begin
            // Mark the invalid code point
            CodePoint := ReplacementChar;
            OutputCodePoint := True;
          end;
        end;
      end else
      begin
        // Process the valid code point
        if ((CodePoint = $FEFF) and (OutputLength = 0)) then
        begin
          // Byte order marker
          case BOMAction of
            QPLUnicodePreserve:
            begin
              // Add the byte order marker
              OutputCodePoint := True;
            end;

            QPLUnicodeStrip:
            begin
              // Ignore the byte order marker
              OutputCodePoint := False;
            end;

            QPLUnicodeForce:
            begin
              // Keep the byte order marker that was added earlier
              OutputCodePoint := False;
            end;
          end;
        end else
        begin
          // Valid code point that isn't a byte order marker
          OutputCodePoint := True;
        end;
      end;

      if OutputCodePoint then
      begin
        if (CodePoint >= $FFFF) then
        begin
          // Output a surrogate pair (two 16-bit values)
          // U+10hh hhhh
          // From: [ 0001xxxx xxxxxxyy yyyyyyyy ]
          // To: [ 110110xx xxxxxxxx ] and [ 110111yy yyyyyyyy ]

          SurrogateOffset := CodePoint - $10000;
          OW1 := ((SurrogateOffset and $FFC00) shr 10) + $D800;
          OW2 := (SurrogateOffset and $3FF) + $DC00;

          if (SwapBytes) then
          begin
            Inc(OutputLength);
            Output[OutputLength] := WideChar((OW1 and $FF) shl 8 +
              (OW1 and $FF00) shr 8);
            Inc(OutputLength);
            Output[OutputLength] := WideChar((OW2 and $FF) shl 8 +
              (OW2 and $FF00) shr 8);
          end else
          begin
            Inc(OutputLength);
            Output[OutputLength] := WideChar(OW1);
            Inc(OutputLength);
            Output[OutputLength] := WideChar(OW2);
          end;
        end else
        begin
          // Output one 16-bit value
          if (SwapBytes) then
          begin
            Inc(OutputLength);
            Output[OutputLength] := WideChar((CodePoint and $FF) shl 8 +
              (CodePoint and $FF00) shr 8);
          end else
          begin
            Inc(OutputLength);
            Output[OutputLength] := WideChar(CodePoint);
          end;
        end;

        if (OutputLength >= OutputCapacity) then
        begin
          // Increase the output capacity by an amount equal to
          // twice the number of remaining bytes plus a few extra
          Inc(OutputCapacity, (InputLength - InputPosition) * 2 + 20);

          // Add an extra capacity margin
          SetLength(Output, OutputCapacity + 20);
        end;
      end;

      if (InputPosition > InputLength) then
      begin
        // Reached the end of the input
        EndLoop := True;
      end;
    until EndLoop;
  end;

  SetLength(Output, OutputLength);
end;

// Converts a 16-bit buffer to an 8-bit buffer.
// Returns false if an error occurred
//   Input is the 16-bit input buffer
//   Output is the 8-bit output buffer
//   InputEncoding is the format of the input
//   OutputEncoding is the format of the output
//   BOMAction specifies how a BOM should be handled or added
//   MalformedAction sets the behaviour on ill-formed input
function QPLUnicodeConvert16To8(const Input: WideString; var Output: AnsiString;
  InputEncoding, OutputEncoding: TQPLUnicodeEncoding;
  BOMAction: TQPLUnicodeBOM;
  MalformedAction: TQPLUnicodeMalformed): Boolean;
var
  EndLoop: Boolean;
  InputLength: Integer;
  InputPosition: Integer;
  MaxCodePoint: Cardinal;
  OutputLength: Integer;
  OutputCapacity: Integer;
  InputRemaining: Integer;
  CodePoint: Cardinal;
  IW1: Cardinal;
  IW2: Cardinal;
  ValidCodePoint: Boolean;
  OutputCodePoint: Boolean;
  OB1: Cardinal;
  OB2: Cardinal;
  OB3: Cardinal;
  OB4: Cardinal;
begin
  Result := True;
  EndLoop := False;
  InputLength := Length(Input);
  MaxCodePoint := $10FFFF;

  if (InputEncoding = QPLUnicodeUTF8) then
  begin
    // Return failure - input must be 16-bit
    EndLoop := True;
    Result := False;
  end;

  if (OutputEncoding <> QPLUnicodeUTF8) then
  begin
    // Return failure - output must be 8-bit
    EndLoop := True;
    Result := False;
  end;

  if (BOMAction = QPLUnicodeForce) then
  begin
    // Add the byte order marker, start with output length of 3
    OutputLength := 3;
    SetLength(Output, 3);

    Output[1] := AnsiChar($EF);
    Output[2] := AnsiChar($BB);
    Output[3] := AnsiChar($BF);
  end else
  begin
    // No byte order marker needed now, output length set to 0
    OutputLength := 0;
  end;

  // Don't process an empty input
  if (Length(Input) = 0) then
  begin
    EndLoop := True;
  end;

  if not EndLoop then
  begin
    InputPosition := 1;

    // Start with an output capacity roughly 10% more than the
    // number of input bytes plus an extra few bytes
    OutputCapacity := Round(Int(InputLength) * 1.1) + 20;

    // Add an extra capacity margin
    SetLength(Output, OutputCapacity + 20);

    repeat

      // Number of words left after the current word
      InputRemaining := InputLength - InputPosition;

      // Start with an invalid code point
      // CodePoint := InternalErrorChar;

      if (InputEncoding = QPLUnicodeUTF16LE) or
        (InputEncoding = QPLUnicodeUCS2LE) then
      begin
        // Little endian
        IW1 := Word(Input[InputPosition]);
      end else
      begin
        // Big endian
        IW1 := Word(Input[InputPosition]);
        IW1 := (IW1 and $FF00) shr 8 + (IW1 and $FF) shl 8;
      end;

      if (InputEncoding = QPLUnicodeUTF16BE) or
        (InputEncoding = QPLUnicodeUTF16LE) then
      begin
        if (IW1 >= $DC00) and (IW1 <= $DFFF) then
        begin
          // Found an out of order second surrogate
          CodePoint := ReplacementChar;

          // Consume this word
          Inc(InputPosition);
        end else
        if (IW1 >= $D800) and (IW1 <= $DBFF) then
        begin
          // Found a first surrogate
          if (InputRemaining >= 1) then
          begin
            if (InputEncoding = QPLUnicodeUTF16LE) then
            begin
              // Little endian
              IW2 := Word(Input[InputPosition + 1]);
            end else
            begin
              // Big endian
              IW2 := Word(Input[InputPosition + 1]);
              IW2 := (IW2 and $FF00) shr 8 + (IW2 and $FF) shl 8;
            end;

            if (IW2 >= $DC00) and (IW2 <= $DFFF) then
            begin
              // Second surrogate is in range
              CodePoint := (IW1 and $3FF) shl 10 + (IW2 and $3FF) + $10000;

              // Consume both words
              Inc(InputPosition, 2);
            end else
            begin
              // Second surrogate is out of range
              CodePoint := ReplacementChar;

              // Consume both words
              Inc(InputPosition, 2);
            end;
          end else
          begin
            // Second surrogate not found
            CodePoint := ReplacementChar;

            // Consume this word
            Inc(InputPosition);
          end;
        end else
        begin
          // Not a surrogate so it is valid
          CodePoint := IW1;

          // Consume this word
          Inc(InputPosition);
        end;
      end else
      begin
        // Surrogates are not allowed
        if (IW1 >= $D800) and (IW1 <= $DFFF) then
        begin
          CodePoint := ReplacementChar;
        end else
        begin
          CodePoint := IW1;
        end;

        // Consume this word
        Inc(InputPosition);
      end;

      // Check for invalid code points
      ValidCodePoint := True;
      if (CodePoint = InternalErrorChar) then
      begin
        // Internal error - stop processing
        EndLoop := True;
        ValidCodePoint := False;
      end else
      if (CodePoint = ReplacementChar) then
      begin
        // We have a replacement code
        ValidCodePoint := False;
      end else
      if (CodePoint > MaxCodePoint) then
      begin
        // Out of range (for UTF-8 max is U+10FFFF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $FFF800) = $00D800) then
      begin
        // High or low surrogate (U+00D800 to U+00DFFF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $00FFFE) = $00FFFE) then
      begin
        // Noncharacter (U+xxFFFE and U+xxFFFF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $FFFFF0) = $00FDD0) then
      begin
        // Noncharacter (U+00FDD0 to U+00FDDF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $FFFFF0) = $00FDE0) then
      begin
        // Noncharacter (U+00FDE0 to U+00FDEF)
        ValidCodePoint := False;
      end;

      // Check if the code point should be output
      OutputCodePoint := True;
      if (not ValidCodePoint) then
      begin
        // Process the invalid code point
        case MalformedAction of
          QPLUnicodeEmpty:
          begin
            // Return an empty string
            if BOMAction = QPLUnicodeForce then
            begin
              // Keep the byte order marker that was added earlier
              OutputLength := 3;
            end else
            begin
              // No byte order marker on the output
              OutputLength := 0;
            end;

            // End processing
            EndLoop := True;
            OutputCodePoint := False;

            // Return failure
            Result := False;
          end;

          QPLUnicodeStop:
          begin
            // End processing keeping existing code points
            EndLoop := True;
            OutputCodePoint := False;

            // Return failure
            Result := False;
          end;

          QPLUnicodeIgnore:
          begin
            // Ignore the invalid code point
            OutputCodePoint := False;
          end;

          QPLUnicodeMark:
          begin
            // Mark the invalid code point
            CodePoint := ReplacementChar;
            OutputCodePoint := True;
          end;
        end;
      end else
      begin
        // Process the valid code point
        if ((CodePoint = $FEFF) and (OutputLength = 0)) then
        begin
          // Byte order marker
          case BOMAction of
            QPLUnicodePreserve:
            begin
              // Add the byte order marker
              OutputCodePoint := True;
            end;

            QPLUnicodeStrip:
            begin
              // Ignore the byte order marker
              OutputCodePoint := False;
            end;

            QPLUnicodeForce:
            begin
              // Keep the byte order marker that was added earlier
              OutputCodePoint := False;
            end;
          end;
        end else
        begin
          // Valid code point that isn't a byte order marker
          OutputCodePoint := True;
        end;
      end;

      if OutputCodePoint then
      begin
        if (CodePoint <= $7F) then
        begin
          // Single byte
          Inc(OutputLength, 1);
          Output[OutputLength] := AnsiChar(CodePoint);
        end else
        if (CodePoint <= $7FF) then
        begin
          // Two bytes
          OB1 := $C0 + (CodePoint and $7C0) shr 6;
          OB2 := $80 + (CodePoint and $3F);

          Inc(OutputLength, 1);
          Output[OutputLength] := AnsiChar(OB1);
          Inc(OutputLength, 1);
          Output[OutputLength] := AnsiChar(OB2);
        end else
        if (CodePoint <= $FFFF) then
        begin
          // Three bytes
          OB1 := $E0 + (CodePoint and $F000) shr 12;
          OB2 := $80 + (CodePoint and $FC0) shr 6;
          OB3 := $80 + (CodePoint and $3F);

          Inc(OutputLength, 1);
          Output[OutputLength] := AnsiChar(OB1);
          Inc(OutputLength, 1);
          Output[OutputLength] := AnsiChar(OB2);
          Inc(OutputLength, 1);
          Output[OutputLength] := AnsiChar(OB3);
        end else
        begin
          // Four bytes
          OB1 := $F0 + (CodePoint and $1C0000) shr 18;
          OB2 := $80 + (CodePoint and $3F000) shr 12;
          OB3 := $80 + (CodePoint and $FC0) shr 6;
          OB4 := $80 + (CodePoint and $3F);

          Inc(OutputLength, 1);
          Output[OutputLength] := AnsiChar(OB1);
          Inc(OutputLength, 1);
          Output[OutputLength] := AnsiChar(OB2);
          Inc(OutputLength, 1);
          Output[OutputLength] := AnsiChar(OB3);
          Inc(OutputLength, 1);
          Output[OutputLength] := AnsiChar(OB4);
        end;

        if (OutputLength >= OutputCapacity) then
        begin
          // Increase the output capacity by an amount equal to
          // twice the number of remaining bytes plus a few extra
          Inc(OutputCapacity, (InputLength - InputPosition) * 2 + 20);

          // Add an extra capacity margin
          SetLength(Output, OutputCapacity + 20);
        end;
      end;

      if (InputPosition > InputLength) then
      begin
        // Reached the end of the input
        EndLoop := True;
      end;
    until EndLoop;
  end;

  SetLength(Output, OutputLength);
end;

function QPLUnicodeConvertArrayTo16(CodePoints: array of Cardinal; var Output: WideString;
  OutputEncoding: TQPLUnicodeEncoding;
  BOMAction: TQPLUnicodeBOM;
  MalformedAction: TQPLUnicodeMalformed): Boolean;
var
  EndLoop: Boolean;
  InputLength: Integer;
  InputPosition: Integer;
  SwapBytes: Boolean;
  MaxCodePoint: Cardinal;
  OutputLength: Integer;
  OutputCapacity: Integer;
  CodePoint: Cardinal;
  ValidCodePoint: Boolean;
  OutputCodePoint: Boolean;
  SurrogateOffset: Cardinal;
  OW1: Cardinal;
  OW2: Cardinal;
begin
  Result := True;
  EndLoop := False;
  InputLength := Length(CodePoints);
  MaxCodePoint := 0;
  SwapBytes := False;

  case OutputEncoding of
    QPLUnicodeUTF8:
    begin
      // Return failure - output must be 16-bit
      EndLoop := True;
      Result := False;
    end;

    QPLUnicodeUTF16LE:
    begin
      SwapBytes := False;
      MaxCodePoint := $10FFFF;
    end;

    QPLUnicodeUTF16BE:
    begin
      SwapBytes := True;
      MaxCodePoint := $10FFFF;
    end;

    QPLUnicodeUCS2LE:
    begin
      SwapBytes := False;
      MaxCodePoint := $FFFF;
    end;

    QPLUnicodeUCS2BE:
    begin
      SwapBytes := True;
      MaxCodePoint := $FFFF;
    end;
  end;

  if (BOMAction = QPLUnicodeForce) then
  begin
    // Add the byte order marker, start with output length of 1
    OutputLength := 1;
    SetLength(Output, 1);

    if (SwapBytes) then
    begin
      Output[1] := WideChar((BOMChar and $FF) shl 8 + (BOMChar and $FF00) shr 8);
    end else
    begin
      Output[1] := WideChar(BOMChar and $FFFF);
    end;
  end else
  begin
    // No byte order marker needed now, output length set to 0
    OutputLength := 0;
  end;

  // Don't process an empty input
  if (InputLength = 0) then
  begin
    EndLoop := True;
  end;

  if not EndLoop then
  begin
    InputPosition := 1;

    // Start with an output capacity roughly 10% more than the
    // number of input bytes plus an extra few bytes
    OutputCapacity := Round(Int(InputLength) * 1.1) + 20;

    // Add an extra capacity margin
    SetLength(Output, OutputCapacity + 20);

    repeat
      CodePoint := CodePoints[InputPosition - 1];
      Inc(InputPosition);

      // Check for invalid code points
      ValidCodePoint := True;
      if (CodePoint = InternalErrorChar) then
      begin
        // Internal error - stop processing
        EndLoop := True;
        ValidCodePoint := False;
      end else
      if (CodePoint = ReplacementChar) then
      begin
        // We have a replacement code
        ValidCodePoint := False;
      end else
      if (CodePoint > MaxCodePoint) then
      begin
        // Out of range (depends on requested output encoding format)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $FFF800) = $00D800) then
      begin
        // High or low surrogate (U+00D800 to U+00DFFF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $00FFFE) = $00FFFE) then
      begin
        // Noncharacter (U+xxFFFE and U+xxFFFF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $FFFFF0) = $00FDD0) then
      begin
        // Noncharacter (U+00FDD0 to U+00FDDF)
        ValidCodePoint := False;
      end else
      if ((CodePoint and $FFFFF0) = $00FDE0) then
      begin
        // Noncharacter (U+00FDE0 to U+00FDEF)
        ValidCodePoint := False;
      end;

      // Check if the code point should be output
      OutputCodePoint := True;
      if (not ValidCodePoint) then
      begin
        // Process the invalid code point
        case MalformedAction of
          QPLUnicodeEmpty:
          begin
            // Return an empty string
            if BOMAction = QPLUnicodeForce then
            begin
              // Keep the byte order marker that was added earlier
              OutputLength := 1;
            end else
            begin
              // No byte order marker on the output
              OutputLength := 0;
            end;

            // End processing
            EndLoop := True;
            OutputCodePoint := False;

            // Return failure
            Result := False;
          end;

          QPLUnicodeStop:
          begin
            // End processing keeping existing code points
            EndLoop := True;
            OutputCodePoint := False;

            // Return failure
            Result := False;
          end;

          QPLUnicodeIgnore:
          begin
            // Ignore the invalid code point
            OutputCodePoint := False;
          end;

          QPLUnicodeMark:
          begin
            // Mark the invalid code point
            CodePoint := ReplacementChar;
            OutputCodePoint := True;
          end;
        end;
      end else
      begin
        // Process the valid code point
        if ((CodePoint = $FEFF) and (OutputLength = 0)) then
        begin
          // Byte order marker
          case BOMAction of
            QPLUnicodePreserve:
            begin
              // Add the byte order marker
              OutputCodePoint := True;
            end;

            QPLUnicodeStrip:
            begin
              // Ignore the byte order marker
              OutputCodePoint := False;
            end;

            QPLUnicodeForce:
            begin
              // Keep the byte order marker that was added earlier
              OutputCodePoint := False;
            end;
          end;
        end else
        begin
          // Valid code point that isn't a byte order marker
          OutputCodePoint := True;
        end;
      end;

      if OutputCodePoint then
      begin
        if (CodePoint >= $FFFF) then
        begin
          // Output a surrogate pair (two 16-bit values)
          // U+10hh hhhh
          // From: [ 0001xxxx xxxxxxyy yyyyyyyy ]
          // To: [ 110110xx xxxxxxxx ] and [ 110111yy yyyyyyyy ]

          SurrogateOffset := CodePoint - $10000;
          OW1 := ((SurrogateOffset and $FFC00) shr 10) + $D800;
          OW2 := (SurrogateOffset and $3FF) + $DC00;

          if (SwapBytes) then
          begin
            Inc(OutputLength);
            Output[OutputLength] := WideChar((OW1 and $FF) shl 8 +
              (OW1 and $FF00) shr 8);
            Inc(OutputLength);
            Output[OutputLength] := WideChar((OW2 and $FF) shl 8 +
              (OW2 and $FF00) shr 8);
          end else
          begin
            Inc(OutputLength);
            Output[OutputLength] := WideChar(OW1);
            Inc(OutputLength);
            Output[OutputLength] := WideChar(OW2);
          end;
        end else
        begin
          // Output one 16-bit value
          if (SwapBytes) then
          begin
            Inc(OutputLength);
            Output[OutputLength] := WideChar((CodePoint and $FF) shl 8 +
              (CodePoint and $FF00) shr 8);
          end else
          begin
            Inc(OutputLength);
            Output[OutputLength] := WideChar(CodePoint);
          end;
        end;

        if (OutputLength >= OutputCapacity) then
        begin
          // Increase the output capacity by an amount equal to
          // twice the number of remaining bytes plus a few extra
          Inc(OutputCapacity, (InputLength - InputPosition) * 2 + 20);

          // Add an extra capacity margin
          SetLength(Output, OutputCapacity + 20);
        end;
      end;

      if (InputPosition > InputLength) then
      begin
        // Reached the end of the input
        EndLoop := True;
      end;
    until EndLoop;
  end;

  SetLength(Output, OutputLength);
end;

end.
