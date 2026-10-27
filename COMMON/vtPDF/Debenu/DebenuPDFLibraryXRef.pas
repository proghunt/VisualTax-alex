{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryDocument.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryXRef;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, DebenuPDFLibraryStructure;

type
  TPDFXRefItemEvent = procedure(O: Integer; N: Int64; G: Integer; T: AnsiChar) of object;
  TPDFXRefTrailerEvent = procedure(const Trailer: AnsiString) of object;
  TPDFXRefReadEvent = procedure(Pos: Int64) of object;

  TPDFXRefReader = class
  private
    FStream: TStream;
    FOnXRefItem: TPDFXRefItemEvent;
    FOnXRefTrailer: TPDFXRefTrailerEvent;
    FOnXRefRead: TPDFXRefReadEvent;
    FHasXRefStream: Boolean;
    FHybrid: Boolean;
    FLastStartPos: Int64;
    FOffset: Int64;

    //XRefObjPos: TQPLSortedInt64List;

    function ReadString(Start: Int64; Len: Integer): AnsiString;
    function ReadXRefStream(Start: Int64): Boolean;
    function ReadXRefTable(Start: Int64): Boolean;
  public
    constructor Create(Stream: TStream);
    function ReadXRef(Start: Int64): Boolean;
    function FindXRefPos: Int64;
    property HasXRefStream: Boolean read FHasXRefStream;
    property LastStartPos: Int64 read FLastStartPos write FLastStartPos;
    property Offset: Int64 read FOffset write FOffset;
    property OnXRefItem: TPDFXRefItemEvent read FOnXRefItem write FOnXRefItem;
    property OnXRefTrailer: TPDFXRefTrailerEvent read FOnXRefTrailer write FOnXRefTrailer;
    property OnXRefRead: TPDFXRefReadEvent read FOnXRefRead write FOnXRefRead;
  end;

function ValidXRefStreamDict(const S: AnsiString): Boolean;

implementation

uses
  SysUtils, DebenuPDFLibraryExtra;

{ TPDFXRefReader }

constructor TPDFXRefReader.Create(Stream: TStream);
begin
  FStream := Stream;
  FHybrid := False;
  FHasXRefStream := False;
  FLastStartPos := -1;
  FOffset := 0;
end;

function TPDFXRefReader.FindXRefPos: Int64;
var
  Offset: Int64;
  S: AnsiString;
  P: Integer;
  LastP: Int64;
  BlockSize: Integer;
  EOFPos: Int64;
  StartXRefPos: Int64;
  Lines: TQuickPDFStringList;
  LineIndex: Integer;
  MalformedEOF: Boolean;

  function IsWhitespace(C: AnsiChar): Boolean;
  begin
    Result := (C = #0) or (C = #9) or (C = #10) or (C = #12) or (C = #13)
      or (C = #32);
  end;

  function IsNumber(C: AnsiChar): Boolean;
  begin
    Result := (C >= '0') and (C <= '9');
  end;

begin
  Result := 0;
  BlockSize := 1024;

  Offset := 0;
  LastP := 0;
  MalformedEOF := False;
  S := ReadString(FStream.Size - 10, 10);
  P := QPLPos('%%E', S);
  if (P > 0) then
  begin
    Delete(S, 1, P - 1);
    if (QPLCopy(S, 1, 5) <> '%%EOF') then
    begin
      MalformedEOF := True;
      LastP := FStream.Size - 1;
      repeat
        Dec(LastP);
        S := ReadString(LastP, 3);
      until S = '%%E';
    end;
  end;

  if (not MalformedEOF) then
  begin
    // Look for the last "%%EOF" token in the stream
    Offset := FStream.Size;
    repeat
      Dec(Offset, BlockSize);
      if (Offset < 0) then
      begin
        Offset := 0;
      end;
      S := ReadString(Offset, BlockSize);
      P := QPLPos('%%EOF', S);
      if ((Offset > 0) and (P = 0)) then
      begin
        // Move ahead four bytes in case the "%%EOF" token
        // crosses the border between two blocks
        Inc(Offset, 4);
      end;
    until (Offset = 0) or (P > 0);

    // There might be more than one "%%EOF" token in the buffer,
    // so find them all and store the position of the last one
    LastP := 0;
    repeat
      P := QPLPos('%%EOF', S);
      if P > 0 then
      begin
        LastP := P;
        S[P] := ' ';
      end;
    until P = 0;
  end;

  // If LastP is positive it contains the distance from the start
  // of the buffer to the "%%EOF" token which is equivalent to a zero-based
  // position of (Offset + LastP - 1) in the stream
  if LastP > 0 then
  begin
    EOFPos := Offset + LastP - 1;

    // Look for the last "startxref" token
    Offset := EOFPos;
    repeat
      Dec(Offset, BlockSize);
      if (Offset < 0) then
      begin
        Offset := 0;
      end;
      S := ReadString(Offset, BlockSize);
      P := QPLPos('startxref', S);
      if ((Offset > 0) and (P = 0)) then
      begin
        // Move ahead eight bytes in case the token
        // crosses the border between two blocks
        Inc(Offset, 8);
      end;
    until (Offset = 0) or (P > 0);

    // There might be more than one "startxref" token in the buffer,
    // so find them all and store the position of the last one
    LastP := 0;
    repeat
      P := QPLPos('startxref', S);
      if P > 0 then
      begin
        LastP := P;
        S[P] := ' ';
      end;
    until P = 0;

    // If LastP is positive it contains the distance from the start
    // of the buffer to the "startxref" token which is equivalent to a zero-based
    // position of (Offset + LastP - 1) in the stream
    if (LastP > 0) then
    begin
      StartXRefPos := Offset + LastP - 1;

      Lines := TQuickPDFStringList.Create;
      try
        SetLength(S, EOFPos - StartXRefPos - 9);
        S := ReadString(StartXRefPos + 9, Length(S));
        Lines.Text := S;
        for LineIndex := 0 to Lines.Count - 1 do
        begin
          S := QPLTrim(Lines[LineIndex]);
          P := QPLPos('%', S);
          if (P > 0) then
          begin
            Delete(S, P, MaxInt);
          end;
          Result := QPLStrToInt64Def(QPLTrim(S), 0);
        end;
      finally
        Lines.Free;
      end;
    end;
  end;
end;

function TPDFXRefReader.ReadString(Start: Int64; Len: Integer): AnsiString;
begin
  Start := Start + FOffset;
  if Start < 0 then Start := 0;
  if (Start + Len) > FStream.Size then
    Len := FStream.Size - Start;
  if Len > 0 then
  begin
    FStream.Seek(Start, soBeginning);
    SetLength(Result, Len);
    if (Len > 0) then
    begin
      Len := FStream.Read(Result[1], Len);
      SetLength(Result, Len);
    end;
  end else
    Result := '';
end;

function TPDFXRefReader.ReadXRef(Start: Int64): Boolean;
var
  S: AnsiString;
  P: Int64;
  P1, P2, P3: Int64;
  OrigStart, Offset: Int64;
  Retries: Integer;
begin
  OrigStart := Start;
  if Assigned(FOnXRefRead) then FOnXRefRead(Start);
  Offset := -10;
  if Start + Offset < 0 then Offset := -Start;
  P := Start + Offset;
  S := ReadString(P, 40);
  P1 := QPLPos('txref', S);
  P2 := QPLPos('xref', S);
  P3 := QPLPos(' obj', S);

  // D14627 : Aspose has a proble with it's linearisation.  It allocates a large block
  // of memory, zeros it and then writes the xref at the back of the block leaving
  // lots on $#00 character at the start of the block where the xref entry is meant to start.
  // This code skips over the $#00's.

  Retries := 1;
  while (P1 = 0) and (P2 = 0) and (P3 = 0) and (Retries <= 10) do
  begin
    Start := OrigStart;
    P := 1;

    S := ReadString(Start, 2048 * Retries);
    while (P < Length(S)) and ((S[P] = #$00) or (S[P] = #$0A)) do
      Inc(P);

    Inc(Retries);

    P := P + OrigStart + Offset;
    Start := P;

    S := ReadString(P, 40);
    P1 := QPLPos('txref', S);
    P2 := QPLPos('xref', S);
    P3 := QPLPos(' obj', S);
  end;

  // End of Aspose #$00 skipping.

  if (P1 > 0) and (P2 > 0) and (P2 = P1 + 1) then
    P2 := 0;
  if (P2 = 0) and (P3 > 0) then
  begin
    Result := ReadXRefStream(Start + Offset + P3 + 3);
  end else
  if (P2 > 0) and ((P3 = 0) or (P2 < P3)) then
  begin
    Result := ReadXRefTable(Start + Offset + P2 + 3);
  end else
    Result := False;

  if not Result then
  begin
    if Assigned(FOnXRefRead) then FOnXRefRead(-Start);
  end;
end;

function ValidXRefStreamDict(const S: AnsiString): Boolean;
var
  DictStartPos: Integer;
  StreamPos: Integer;
  IndexPos: Integer;
  ArrayStartPos: Integer;
  ArrayEndPos: Integer;
begin
  DictStartPos := QPLPos('<<', S);
  IndexPos := QPLPos('/Index', S);
  if (IndexPos > 0) then
  begin
    ArrayStartPos := QPLPos('[', QPLCopy(S, IndexPos, MaxInt)) + IndexPos;
    if (ArrayStartPos = IndexPos) then
    begin
      ArrayStartPos := 0;
    end;
    ArrayEndPos := QPLPos(']', QPLCopy(S, IndexPos, MaxInt)) + IndexPos;
    if (ArrayEndPos = IndexPos) then
    begin
      ArrayEndPos := 0;
    end;
  end else
  begin
    ArrayStartPos := 0;
    ArrayEndPos := 0;
  end;
  StreamPos := QPLPos('stream', S);
  Result := (DictStartPos > 0) and (StreamPos > 0) and
    (IndexPos = 0) or (
      (IndexPos > 0) and (ArrayStartPos > 0) and (ArrayEndPos > 0) and
      (IndexPos > DictStartPos) and (ArrayStartPos > IndexPos) and
      (ArrayEndPos > ArrayStartPos) and (StreamPos > ArrayEndPos));
end;

function TPDFXRefReader.ReadXRefStream(Start: Int64): Boolean;
var
  S: AnsiString;
  X: Integer;
  St: TPDFStructure;
  Obj: TPDFObject;
  TempDict: TPDFDictionary;
  TempArray: TPDFArray;
  XRefStreamSize: Integer;
  XRefStreamIndex: array of array[1..2] of Integer;
  XRefStreamPrev: Integer;
  XRefStreamW: array[1..3] of Integer;
  P1: Integer;
  P2: Integer;
  XRefPos: Integer;
  XRefStream: TPDFStream;
  ObjStart: Integer;
  ObjCount: Integer;
  ObjNum: Integer;
  O: Integer;
  N: Int64;
  G: Integer;
  T: AnsiChar;
  XT: Integer;
  Len: Integer;
  InWhitespace: Boolean;
  StreamDictionaryLength: Integer;
  XRefObjNumS: AnsiString;
  XRefObjNum: Integer;

  function ReadValue(Index: Integer): Int64;
  var
    W: Integer;
  begin
    W := XRefStreamW[Index];
    if W = 1 then
    begin
      Result := Ord(S[XRefPos]);
      Inc(XRefPos);
    end else
    if W = 2 then
    begin
      Result := Ord(S[XRefPos]) * 256 +
        Ord(S[XRefPos + 1]);
      Inc(XRefPos, 2);
    end else
    if W = 3 then
    begin
      Result := Ord(S[XRefPos]) * 256 * 256 +
        Ord(S[XRefPos + 1]) * 256 +
        Ord(S[XRefPos + 2]);
      Inc(XRefPos, 3);
    end else
    if W = 4 then
    begin
      Result := Ord(S[XRefPos]) * 256 * 256 * 256 +
        Ord(S[XRefPos + 1]) * 256 * 256 +
        Ord(S[XRefPos + 2]) * 256 +
        Ord(S[XRefPos + 3]);
      Inc(XRefPos, 4);
    end else
    if ((W >= 5) and (W <= 8)) then
    begin
      Result := 0;
      while (W > 0) do
      begin
        Result := Result shl 8;
        Result := Result + Ord(S[XRefPos]);
        Inc(XRefPos);
        Dec(W);
      end;
    end else
      Result := 0;
  end;

begin
  Result := False;
  FHasXRefStream := True;
  St := TPDFStructure.Create;
  try
    Len := 0;
    repeat
      Inc(Len, 20480);
      if (Start + Len) > FStream.Size then
        Len := FStream.Size - Start;
      S := ReadString(Start, Len);
      StreamDictionaryLength := 0;
    until (ValidXRefStreamDict(S)) or ((Start + Len) >= FStream.Size);
    Obj := St.DecodeWithLength(S, StreamDictionaryLength);
    if (Obj is TPDFDictionary) and (TPDFDictionary(Obj).DictType = 'XRef') then
    begin
      // Read the object number before the xref stream, used to detect
      // malformed xref streams where the xref stream's object number
      // is incorrectly used as the position of the object
      XRefObjNum := 0;
      XRefObjNumS := ReadString(Start - 20, 21);
      repeat
        Delete(XRefObjNumS, Length(XRefObjNumS), 1);
      until (QPLEndsWith(XRefObjNumS, 'obj') or (XRefObjNumS = ''));
      repeat
        Delete(XRefObjNumS, Length(XRefObjNumS), 1);
      until (QPLEndsWith(XRefObjNumS, '0') or (XRefObjNumS = ''));
      repeat
        Delete(XRefObjNumS, Length(XRefObjNumS), 1);
      until (QPLEndsWith(XRefObjNumS, ' ') or (XRefObjNumS = ''));
      repeat
        Delete(XRefObjNumS, Length(XRefObjNumS), 1);
      until (not QPLEndsWith(XRefObjNumS, ' '));
      if (Length(XRefObjNumS) > 0) then
      begin
        P1 := Length(XRefObjNumS);
        while (P1 > 1) and (XRefObjNumS[P1] >= '0') and (XRefObjNumS[P1] <= '9') do
        begin
          Dec(P1);
        end;
        XRefObjNum := QPLStrToIntDef(QPLCopy(XRefObjNumS, P1 + 1, MaxInt), 0);
      end;

      TempDict := TPDFDictionary(Obj);
      Obj := TempDict.FindValueByKeyName('Size');
      if Obj is TPDFNumeric then
      begin
        XRefStreamSize := TPDFNumeric(Obj).AsInteger;
        Obj := TempDict.FindValueByKeyName('Index');
        if Obj is TPDFArray then
        begin
          TempArray := TPDFArray(Obj);
          SetLength(XRefStreamIndex, TempArray.Count div 2);
          for X := 0 to Length(XRefStreamIndex) - 1 do
          begin
            Obj := TempArray.Item[X * 2];
            if Obj is TPDFNumeric then
              XRefStreamIndex[X][1] := TPDFNumeric(Obj).AsInteger
            else
              XRefStreamIndex[X][1] := 0;
            Obj := TempArray.Item[X * 2 + 1];
            if Obj is TPDFNumeric then
              XRefStreamIndex[X][2] := TPDFNumeric(Obj).AsInteger
            else
              XRefStreamIndex[X][2] := 0;
          end;
        end else
        begin
          SetLength(XRefStreamIndex, 1);
          XRefStreamIndex[0][1] := 0;
          XRefStreamIndex[0][2] := XRefStreamSize;
        end;
        Obj := TempDict.FindValueByKeyName('Prev');
        if Obj is TPDFNumeric then
          XRefStreamPrev := TPDFNumeric(Obj).AsInteger
        else
          XRefStreamPrev := 0;
        Obj := TempDict.FindValueByKeyName('W');
        if Obj is TPDFArray then
        begin
          TempArray := TPDFArray(Obj);
          if TempArray.Count >= 3 then
          begin
            Obj := TempArray.Item[0];
            if Obj is TPDFNumeric then
              XRefStreamW[1] := TPDFNumeric(Obj).AsInteger
            else
              XRefStreamW[1] := 0;
            Obj := TempArray.Item[1];
            if Obj is TPDFNumeric then
              XRefStreamW[2] := TPDFNumeric(Obj).AsInteger
            else
              XRefStreamW[2] := 0;
            Obj := TempArray.Item[2];
            if Obj is TPDFNumeric then
              XRefStreamW[3] := TPDFNumeric(Obj).AsInteger
            else
              XRefStreamW[3] := 0;

            FillChar(S[1], StreamDictionaryLength, 32);

            repeat
              P1 := QPLPos('>>', S);
              P2 := QPLPos('stream', S);
              if (P1 > 0) and (P2 > 0) and (P1 < P2) then
                for X := 1 to P1 + 1 do S[X] := ' ';
            until ((P2 > 0) and (P1 = 0)) or ((P1 = 0) and (P2 = 0)) or
              ((P2 > 0) and (P1 > 0) and (P2 < P1));
            if (P1 = 0) and (P2 = 0) then XRefPos := 0 else XRefPos := P2;

            if (XRefPos > 0) then
            begin
              Inc(XRefPos, 6);

              repeat
                InWhitespace := (S[XRefPos] = #0) or (S[XRefPos] = #9) or
                  (S[XRefPos] = #12) or (S[XRefPos] = #32);
                if (InWhitespace) then
                begin
                  Inc(XRefPos);
                end;
              until (XRefPos >= Length(S)) or (not InWhitespace);

              if S[XRefPos] = #13 then
              begin
                Inc(XRefPos);
                if S[XRefPos] = #10 then
                begin
                  Inc(XRefPos);
                end else
                begin
                  // This is an invalid stream keyword. It is followed by
                  // a CR but the next character is not a LF
                  // Process it anyway
                end;
              end else
              if S[XRefPos] = #10 then
              begin
                Inc(XRefPos);
              end else
              begin
                XRefPos := 0;
              end;

              SetLength(S, 0);
              if (XRefPos > 0) then
              begin
                Start := Start + XRefPos - 1;
                Obj := TempDict.FindValueByKeyName('Length');
                if Obj is TPDFNumeric then
                  S := ReadString(Start, TPDFNumeric(Obj).AsInteger)
              end;

              if Length(S) > 0 then
              begin
                XRefStream := St.NewStream(S);
                XRefStream.SetDict(TempDict);
                S := XRefStream.GetDecodedStream;

                XRefPos := 1;
                for X := 0 to Length(XRefStreamIndex) - 1 do
                begin
                  ObjStart := XRefStreamIndex[X][1];
                  ObjCount := XRefStreamIndex[X][2];
                  for ObjNum := ObjStart to ObjStart + ObjCount - 1 do
                  begin
                    O := ObjNum;
                    if XRefStreamW[1] = 0 then XT := 1 else XT := ReadValue(1);
                    if XT = 0 then
                    begin
                      T := 'f';
                      N := ReadValue(2);
                      G := ReadValue(3);
                    end else
                    if XT = 1 then
                    begin
                      T := 'n';
                      N := ReadValue(2);

                      // Check for a malformed xref stream where the
                      // object number of the xref stream is incorrectly
                      // used as the position of the object
                      if ((XRefObjNum > 0) and (ObjNum = XRefObjNum) and (N = ObjNum)) then
                      begin
                        if (ReadString(N, Length(IntToStr(ObjNum))) <> QPLIntToStr(ObjNum)) then
                        begin
                          N := Start;
                        end;
                      end;
                      if XRefStreamW[3] = 0 then
                        G := 0
                      else
                        G := ReadValue(3);
                    end else
                    if XT = 2 then
                    begin
                      T := 'c';
                      N := ReadValue(2);
                      G := ReadValue(3);
                    end else
                    begin
                      G := 0;
                      N := 0;
                      T := ' ';
                      ReadValue(2);
                      ReadValue(3);
                    end;
                    if Assigned(FOnXRefItem) then FOnXRefItem(O, N, G, T);
                  end;
                end;
              end;
            end;
          end;
        end;
        if Assigned(FOnXRefTrailer) then
          FOnXRefTrailer(TempDict.Output);
        if XRefStreamPrev > 0 then
          Result := ReadXRef(XRefStreamPrev)
        else
          Result := True;
      end;
    end;
  finally
    St.Free;
  end;
end;

function TPDFXRefReader.ReadXRefTable(Start: Int64): Boolean;
var
  S: AnsiString;
  ObjStart: Integer;
  ObjCount: Integer;
  O: Integer;
  N: Int64;
  G: Integer;
  T: AnsiChar;
  ObjNum: Integer;
  X: Integer;
  TS: AnsiString;
  St: TPDFStructure;
  Obj: TPDFObject;
  Trailer: TPDFDictionary;
  Retries: Integer;

  function FindSubStart: Boolean;
  var
    ObjectStart: AnsiString;
    ObjectCount: AnsiString;
  begin
    Result := False;
    S := ReadString(Start, 30);
    if (QPLPos('%', Copy(S, 1, 3)) <= 0) then
    begin
      if (QPLPos('trailer', S) = 0) then
      begin
        if (S[1] < '0') or (S[1] > '9') then
        repeat
          Delete(S, 1, 1);
          Inc(Start);
        until (Length(S) = 0) or ((S[1] >= '0') and (S[1] <= '9'));
        ObjectStart := '';
        if (Length(S) > 0) then
        begin
          repeat
            ObjectStart := ObjectStart + S[1];
            Delete(S, 1, 1);
            Inc(Start);
          until (Length(S) = 0) or (S[1] < '0') or (S[1] > '9');
          repeat
            Delete(S, 1, 1);
            Inc(Start);
          until (Length(S) = 0) or ((S[1] >= '0') and (S[1] <= '9'));
        end;
        ObjectCount := '';
        if (Length(S) > 0) then
        begin
          repeat
            ObjectCount := ObjectCount + S[1];
            Delete(S, 1, 1);
            Inc(Start);
          until (Length(S) = 0) or (S[1] < '0') or (S[1] > '9');
          repeat
            Delete(S, 1, 1);
            Inc(Start);
          until (Length(S) = 0) or ((S[1] >= '0') and (S[1] <= '9'));
          ObjStart := QPLStrToIntDef(ObjectStart, -1);
          ObjCount := QPLStrToIntDef(ObjectCount, 0);
          Result := (ObjStart >= 0) and (ObjCount > 0);
        end;
      end;
    end;
  end;

  procedure SkipComments;
  begin
    repeat
      S := ReadString(Start, 7);
      if S <> 'trailer' then Inc(Start);
    until (S = 'trailer') or (S = '');
  end;

begin
  Result := False;
  while FindSubStart do
  begin
    S := ReadString(Start, ObjCount * 20);
    S := S + 'trailer';
    X := 1;

    // D12704 : check for malformed / invalid ObjStart
    //
    // xref 1 7    <-   1 should be 0.
    // 0000000000 65535 f
    // 0000000009 00000 n

    if (ObjCount > 0) then
    begin
      TS := QPLCopy(S, X, 10);
      N := QPLStrToInt64Def(TS, 0);
      TS := QPLCopy(S, X + 11, 5);
      G := QPLStrToIntDef(TS, 0);

      if (N = 0) and (G = 65535) and (ObjStart = 1) then
        ObjStart := 0;
    end;
    // End of malformed xref check.

    for ObjNum := ObjStart to ObjStart + ObjCount - 1 do
    begin
      O := ObjNum;
      try
        TS := QPLCopy(S, X, 10);
        N := QPLStrToInt64Def(TS, 0);
        TS := QPLCopy(S, X + 11, 5);
        G := QPLStrToIntDef(TS, 0);
        T := S[X + 17];
        if Assigned(FOnXRefItem) then FOnXRefItem(O, N, G, T);
        Inc(X, 18);
        while (S[X] = ' ') or (S[X] = #10) or (S[X] = #13) do
          Inc(X);
      except
        Result := false;
        Exit;
      end;
    end;
    Inc(Start, X - 1);
  end;
  SkipComments;

  Retries := 0;
  while (Result <> True) and (Retries < 5) do
  begin
    Inc(Retries);
    S := ReadString(Start, 2048 * Retries);
    if QPLPos('trailer', S) > 0 then
    begin
      Delete(S, 1, QPLPos('trailer', S) + 6);
      if (QPLPos('<<', S) > 0) and (QPLPos('>>', S) > 0) then
      begin
        St := TPDFStructure.Create;
        try
          Obj := St.Decode(S);
          if (Obj is TPDFDictionary) then
          begin
            Trailer := TPDFDictionary(Obj);
            if Assigned(FOnXRefTrailer) then FOnXRefTrailer(Trailer.Output);
            Obj := Trailer.FindValueByKeyName('XRefStm');
            if Obj is TPDFNumeric then
            begin
              FHybrid := True;
              ReadXRef(TPDFNumeric(Obj).AsInteger);
            end;
            Obj := Trailer.FindValueByKeyName('Prev');
            if Obj is TPDFNumeric then
            begin
              if (TPDFNumeric(Obj).AsInteger = LastStartPos) then
                Result := false
              else
              begin
                LastStartPos := TPDFNumeric(Obj).AsInteger;
                Result := ReadXRef(TPDFNumeric(Obj).AsInteger);
              end;
            end
            else
              Result := True;
          end;
        finally
          St.Free;
        end;
      end;
    end;
  end;
end;

end.
