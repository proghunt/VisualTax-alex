{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryCMap.pas                               }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryCMap;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, SysUtils, DebenuPDFLibraryExtra, DebenuPDFLibraryBuffer, DebenuPDFLibraryTypes;

const

{$I DebenuPDFLibraryCMap.inc}     //  CMapResourceList: array[1..165] of AnsiString


type
  TDebenuPDFLibraryCMapSection = class
  private
    Inputs: array of Cardinal;
    Targets: TQPLByteArray;
  public
    InputSize: Cardinal;
    TargetSize: Cardinal;
    function ContainsCode(Code: Cardinal): Boolean;
    procedure AddMapping(Code: Cardinal; const Target: TQPLByteArray);
    function GetMappingToWideString(Code: Cardinal): WideString;
    function GetMappingToWord(Code: Cardinal): Word;
    procedure GetMappingToByteArray(Code: Cardinal; var Target: TQPLByteArray);
    procedure SaveToStream(OutputStream: TStream);
    procedure LoadFromStream(InputStream: TStream);
  end;

  TDebenuPDFLibraryCMapCodespaceRange = record
    StartCode: Cardinal;
    EndCode: Cardinal;
    CodeSize: Cardinal;
  end;

  TDebenuPDFLibraryCMapRange = record
    StartCode: Cardinal;
    EndCode: Cardinal;
    Value: Array[0..3] of Word;
  end;

  TPDFDebenuPDFLibraryCMapType = (cmapToCode, cmapToUnicode, cmapGIDToCID);

  TDebenuPDFLibraryCMap = class
  private
    FSections: array of TDebenuPDFLibraryCMapSection;
    FCodespaceRanges: array of TDebenuPDFLibraryCMapRange;
    FCIDRanges: array of TDebenuPDFLibraryCMapRange;
    FBFRanges: array of TDebenuPDFLibraryCMapRange;
    FCMapName: AnsiString;
    FIdentityMapping: Boolean;
    FCMapType: TPDFDebenuPDFLibraryCMapType;
    FSingleByteCMap: Boolean;
    FUseCMap: Integer;
    FUseCMapName: AnsiString;
    CIDCount: Integer;
    BFCount: Integer;
  protected
    procedure ClearSections;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure SetIdentityMapping;
    procedure AddCodespaceRange(StartCode, EndCode, CodeSize: Cardinal);
    procedure AddCIDRange(StartCode, EndCode, Ch: Cardinal);
    procedure AddBFRange(StartCode, EndCode: Cardinal; S: WideString);
    procedure Sort(var RangeArray: array of TDebenuPDFLibraryCMapRange);
    procedure AddMapping(InputSize, Code: Cardinal; const Target: TQPLByteArray);
    function GetMappingToWideString(InputSize, Code: Cardinal): WideString;
    function GetMappingToWord(InputSize, Code: Cardinal): Word;
    function GetMappingToByteArray(InputSize, Code: Cardinal; var Target: TQPLByteArray): Boolean;
    function ContainsCode(InputSize, Code: Cardinal): Boolean;
    function GetValue(Code: Cardinal; var codes: array of Word): Integer;
    procedure SaveToStream(OutputStream: TStream);
    procedure LoadFromStream(InputStream: TStream);
    property CMapType: TPDFDebenuPDFLibraryCMapType read FCMapType write FCMapType;
    property SingleByteCMap: Boolean read FSingleByteCMap;
    property UseCMap: Integer read FUseCMap write FUseCMap;
    property CMapName: AnsiString read FCMapName write FCMapName;
    property UseCMapName: AnsiString read FUseCMapName write FUseCMapName;
  end;

  TDebenuPDFLibraryCMapParser = class
  private
    FBuffer: TQPLBuffer;
    FEndOfLine: TQPLByteArray;
    FAllWhitespace: TQPLByteArray;
    FNonCharacter: TQPLByteArray;
    FArray: TQPLByteArray;
    FCMap: TDebenuPDFLibraryCMap;
    FTokenStack: array[0..9] of AnsiString;
    procedure SkipWhitespace;
    function NextToken: AnsiString;
    procedure AddCodespaceRange(const Token1, Token2: AnsiString);
    procedure AddCIDRange(const Token1, Token2, Token3: AnsiString);
    procedure AddBFRange(const Token1, Token2, Token3: AnsiString);
    function HexToCardinal(const Token: AnsiString; var Value: Cardinal): Boolean;
    function ParseBuffer(Buffer: TQPLBuffer): AnsiString;
  public
    constructor Create;
    function ParseCMap(Buffer: TQPLBuffer): TDebenuPDFLibraryCMap;
  end;

function ResourcesAddToUnicodeCMapFromString(Encoding: AnsiString; CMapAsString: AnsiString): TDebenuPDFLibraryCMap;
function LoadCPToUnicode(codepageId: Integer): TQPLWordPairList;

implementation

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  DebenuPDFLibraryFlate;

var
  CpToUnicodeList: array[1..4] of TQPLWordPairList;

procedure TDebenuPDFLibraryCMapSection.AddMapping(Code: Cardinal; const Target: TQPLByteArray);
var
  CS: Cardinal;
  CI: Cardinal;
  CX: Cardinal;
  MustInsert: Boolean;
begin
  CI := 0;
  MustInsert := False;
  CS := Length(Inputs);

  if ((CS > 0) and (Code > Inputs[CS - 1])) then
  begin
    // If the new code is greater than the last code then
    // we can just add it to the end
    MustInsert := False;
  end else
  begin
    // Look for existing codes bigger than this one
    // so the new code can be inserted in order
    CX := 0;
    while (CX < CS) and (not MustInsert) do
    begin
      if Inputs[CX] > Code then
      begin
        MustInsert := True;
        CI := CX;
      end;
      Inc(CX);
    end;
  end;

  Inc(CS);
  SetLength(Inputs, CS);
  SetLength(Targets, CS * TargetSize);

  if (not MustInsert) then
  begin
    // None of the existing codes are bigger so
    // add the new code to the end
    Inputs[CS - 1] := Code;
    Move(Target[0], Targets[(CS - 1) * TargetSize], TargetSize);
  end else
  begin
    // A bigger code exists so shift to
    // make space for the new code
    Move(Inputs[CI], Inputs[CI + 1], (CS - CI - 1) * SizeOf(Cardinal));
    Move(Targets[CI * TargetSize],
      Targets[(CI + 1) * TargetSize],
      (CS - CI - 1) * TargetSize);
    Inputs[CI] := Code;
    Move(Target[0], Targets[CI * TargetSize], TargetSize);
  end;
end;

function TDebenuPDFLibraryCMapSection.ContainsCode(Code: Cardinal): Boolean;
var
  CS: Cardinal;
  CX: Cardinal;
begin
  Result := False;

  CS := Length(Inputs);

  CX := 0;
  while (CX < CS) and (not Result) do
  begin
    if Inputs[CX] = Code then
    begin
      Result := True;
    end;
    Inc(CX);
  end;
end;

procedure TDebenuPDFLibraryCMapSection.GetMappingToByteArray(Code: Cardinal;
  var Target: TQPLByteArray);
var
  CS: Cardinal;
  CX: Cardinal;
  Found: Boolean;
begin
  SetLength(Target, 0);
  Found := False;

  CS := Length(Inputs);

  CX := 0;
  while (CX < CS) and (not Found) do
  begin
    if Inputs[CX] = Code then
    begin
      Found := True;
      SetLength(Target, TargetSize);
      Move(Targets[CX * TargetSize], Target[0], TargetSize);
    end;
    Inc(CX);
  end;
end;

function TDebenuPDFLibraryCMapSection.GetMappingToWideString(Code: Cardinal): WideString;
var
  CS: Cardinal;
  CX: Cardinal;
  Found: Boolean;
  ResultLength: Cardinal;
  TX: Cardinal;
  TargetOffset: Cardinal;
begin
  Found := False;
  Result := '';

  CS := Length(Inputs);

  CX := 0;
  while (CX < CS) and (not Found) do
  begin
    if Inputs[CX] = Code then
    begin
      Found := True;
      if (TargetSize = 1) then
      begin
        Result := WideChar(Targets[CX]);
      end else
      begin
        ResultLength := TargetSize div 2;
        if (ResultLength * 2) < TargetSize then Inc(ResultLength);
        SetLength(Result, ResultLength);
        if (ResultLength > 0) then
        begin
          Result[ResultLength] := WideChar(0);
          TargetOffset := CX * TargetSize;
          for TX := 0 to ResultLength - 1 do
          begin
            Result[TX + 1] := WideChar((Targets[TargetOffset] shl 8) +
              Targets[TargetOffset + 1]);
            Inc(TargetOffset, 2);
          end;
        end;
      end;
    end;
    Inc(CX);
  end;
end;

function TDebenuPDFLibraryCMapSection.GetMappingToWord(Code: Cardinal): Word;
var
  CS: Cardinal;
  CX: Cardinal;
  Found: Boolean;
begin
  Found := False;
  Result := 0;

  CS := Length(Inputs);

  CX := 0;
  while (CX < CS) and (not Found) do
  begin
    if Inputs[CX] = Code then
    begin
      Found := True;
      if (TargetSize = 1) then
      begin
        Result := Targets[CX];
      end else
      if (TargetSize = 2) then
      begin
        Result := Targets[CX * 2] shl 8 + Targets[CX * 2 + 1];
      end;
    end;
    Inc(CX);
  end;
end;

procedure TDebenuPDFLibraryCMapSection.SaveToStream(OutputStream: TStream);
var
  BList: TQPLByteArray;
  WList: array of Word;
  CList: array of Cardinal;
  C: Cardinal;
  CX: Cardinal;
  CodeOffset: Cardinal;
begin
  C := InputSize;
  OutputStream.Write(C, Sizeof(Cardinal));
  C := TargetSize;
  OutputStream.Write(C, Sizeof(Cardinal));
  C := Length(Inputs);
  OutputStream.Write(C, Sizeof(Cardinal));
  if (C > 0) then
  begin
    CodeOffset := 0;
    if InputSize = 1 then
    begin
      SetLength(BList, C);
      for CX := 0 to C - 1 do
      begin
        BList[CX] := Inputs[CX] and $FF - CodeOffset;
        Inc(CodeOffset, BList[CX]);
      end;
      OutputStream.Write(BList[0], C * SizeOf(Byte));
    end else
    if InputSize = 2 then
    begin
      SetLength(WList, C);
      for CX := 0 to C - 1 do
      begin
        WList[CX] := Inputs[CX] and $FFFF - CodeOffset;
        Inc(CodeOffset, WList[CX]);
      end;
      OutputStream.Write(WList[0], C * SizeOf(Word));
    end else
    begin
      SetLength(CList, C);
      for CX := 0 to C - 1 do
      begin
        CList[CX] := Inputs[CX] - CodeOffset;
        Inc(CodeOffset, CList[CX]);
      end;
      OutputStream.Write(WList[0], C * SizeOf(Cardinal));
    end;
    OutputStream.Write(Targets[0], C * TargetSize)
  end;
end;

procedure TDebenuPDFLibraryCMapSection.LoadFromStream(InputStream: TStream);
var
  C: Cardinal;
  WList: array of Word;
  BList: TQPLByteArray;
  CList: array of Cardinal;
  CX: Cardinal;
  CodeOffset: Cardinal;
begin
  InputStream.Read(C, SizeOf(Cardinal));
  InputSize := C;
  InputStream.Read(C, SizeOf(Cardinal));
  TargetSize := C;
  InputStream.Read(C, SizeOf(Cardinal));
  if (InputSize <= 4) and (TargetSize <= 64) and (C <= $FFFF) then
  begin
    SetLength(Inputs, C);
    SetLength(Targets, C * TargetSize);
    if (C > 0) then
    begin
      CodeOffset := 0;
      if InputSize = 1 then
      begin
        SetLength(BList, C);
        InputStream.Read(BList[0], C * SizeOf(Byte));
        for CX := 0 to C - 1 do
        begin
          Inputs[CX] := BList[CX] + CodeOffset;
          CodeOffset := Inputs[CX];
        end;
      end else
      if InputSize = 2 then
      begin
        SetLength(WList, C);
        InputStream.Read(WList[0], C * SizeOf(Word));
        for CX := 0 to C - 1 do
        begin
          Inputs[CX] := WList[CX] + CodeOffset;
          CodeOffset := Inputs[CX];
        end;
      end else
      begin
        SetLength(CList, C);
        InputStream.Read(CList[0], C * SizeOf(Cardinal));
        for CX := 0 to C - 1 do
        begin
          Inputs[CX] := CList[CX] + CodeOffset;
          CodeOffset := Inputs[CX];
        end;
      end;
      InputStream.Read(Targets[0], C * TargetSize);
    end;
  end;
end;

constructor TDebenuPDFLibraryCMap.Create;
begin
  FCMapName := '';
  SetLength(FSections, 0);
  SetLength(FCodespaceRanges, 0);
  SetLength(FCIDRanges, 0);
  SetLength(FBFRanges, 0);
  FIdentityMapping := False;
  FSingleByteCMap := False;
  CIDCount := 0;
  BFCount:= 0;
  UseCMap := -1;
  UseCMapName := '';
end;

destructor TDebenuPDFLibraryCMap.Destroy;
begin
  ClearSections;
  inherited;
end;

procedure TDebenuPDFLibraryCMap.AddMapping(InputSize, Code: Cardinal; const Target: TQPLByteArray);
var
  SS: Cardinal;
  SX: Cardinal;
  TargetSize: Cardinal;
  Section: TDebenuPDFLibraryCMapSection;
begin
  TargetSize := Length(Target);
  Section := nil;

  // Look for an existing section with matching
  // InputSize and TargetSize
  SX := 0;
  SS := Length(FSections);
  while (SX < SS) and (not Assigned(Section)) do
  begin
    if (FSections[SX].InputSize = InputSize) and
      (FSections[SX].TargetSize = TargetSize) then
    begin
      Section := FSections[SX];
    end;
    Inc(SX);
  end;

  if not Assigned(Section) then
  begin
    // No matching section found, add a new one
    Section := TDebenuPDFLibraryCMapSection.Create;
    Section.InputSize := InputSize;
    Section.TargetSize := TargetSize;
    SetLength(Section.Inputs, 0);
    SetLength(Section.Targets, 0);
    SetLength(FSections, Length(FSections) + 1);
    FSections[Length(FSections) - 1] := Section;
  end;

  // Add the mapping to the section
  Section.AddMapping(Code, Target);
end;

procedure TDebenuPDFLibraryCMap.ClearSections;
var
  SX: Cardinal;
begin
  if Length(FSections) > 0 then
  begin
    for SX := 0 to Length(FSections) - 1 do
      FSections[SX].Free;
    SetLength(FSections, 0);
  end;

  SetLength(FCodespaceRanges, 0);
  SetLength(FCIDRanges, 0);
  SetLength(FBFRanges, 0);
end;

function TDebenuPDFLibraryCMap.GetMappingToByteArray(InputSize, Code: Cardinal;
  var Target: TQPLByteArray): Boolean;
var
  Found: Boolean;
  SS: Cardinal;
  SX: Cardinal;
begin
  Result := False;
  if (FIdentityMapping) then
  begin
    if (InputSize = 2) then
    begin
      Result := True;
      SetLength(Target, 2);
      Target[1] := Code and $FF;
      Target[0] := (Code and $FF00) shr 8;
    end;
  end else
  begin
    Found := False;
    SX := 0;
    SS := Length(FSections);
    while (SX < SS) and (not Found) do
    begin
      if FSections[SX].InputSize = InputSize then
      begin
        Found := FSections[SX].ContainsCode(Code);
        if Found then
        begin
          FSections[SX].GetMappingToByteArray(Code, Target);
          Result := True;
        end else
        begin
          Found := FSections[SX].ContainsCode(32);
          if Found then
          begin
            FSections[SX].GetMappingToByteArray(32, Target);
            Result := True;
          end;
        end;
      end;
      Inc(SX);
    end;

    if (not Found) then
    begin
      if (InputSize = 2) then
      begin
        Result := True;
        SetLength(Target, 2);
        Target[1] := Code and $FF;
        Target[0] := (Code and $FF00) shr 8;
      end;
    end;
  end;
end;

function TDebenuPDFLibraryCMap.GetMappingToWideString(InputSize, Code: Cardinal): WideString;
var
  Found: Boolean;
  SS: Cardinal;
  SX: Cardinal;
begin
  Result := '';
  Found := False;
  SX := 0;
  SS := Length(FSections);
  while (SX < SS) and (not Found) do
  begin
    if FSections[SX].InputSize = InputSize then
    begin
      Found := FSections[SX].ContainsCode(Code);
      if Found then
      begin
        Result := FSections[SX].GetMappingToWideString(Code);
      end;
    end;
    Inc(SX);
  end;
end;

function TDebenuPDFLibraryCMap.GetMappingToWord(InputSize, Code: Cardinal): Word;
var
  Found: Boolean;
  SS: Cardinal;
  SX: Cardinal;
begin
  Result := 0;
  Found := False;
  SX := 0;
  SS := Length(FSections);
  while (SX < SS) and (not Found) do
  begin
    if (InputSize = 0) or (FSections[SX].InputSize = InputSize) then
    begin
      Found := FSections[SX].ContainsCode(Code);
      if Found then
      begin
        Result := FSections[SX].GetMappingToWord(Code);
      end;
    end;
    Inc(SX);
  end;
end;

procedure TDebenuPDFLibraryCMap.SaveToStream(OutputStream: TStream);
var
  C: Cardinal;
  SX: Cardinal;
begin
  C := Length(FSections);
  OutputStream.Write(C, SizeOf(Cardinal));
  if (C > 0) then
  begin
    for SX := 0 to C - 1 do
    begin
      FSections[SX].SaveToStream(OutputStream);
    end;
  end;
end;

procedure TDebenuPDFLibraryCMap.SetIdentityMapping;
begin
  FIdentityMapping := True;
end;

procedure TDebenuPDFLibraryCMap.LoadFromStream(InputStream: TStream);
var
  C: Cardinal;
  SX: Cardinal;
begin
  ClearSections;
  InputStream.Read(C, SizeOf(Cardinal));
  if (C > 0) then
  begin
    SetLength(FSections, C);
    for SX := 0 to C - 1 do
    begin
      FSections[SX] := TDebenuPDFLibraryCMapSection.Create;
      FSections[SX].LoadFromStream(InputStream);
    end;
  end;
end;

function TDebenuPDFLibraryCMap.ContainsCode(InputSize, Code: Cardinal): Boolean;
var
  Found: Boolean;
  SS: Cardinal;
  SX: Cardinal;
begin
  if (FIdentityMapping) then
  begin
    Result := True;
  end else
  begin
    Found := False;
    SX := 0;
    SS := Length(FSections);
    while (SX < SS) and (not Found) do
    begin
      if FSections[SX].InputSize = InputSize then
      begin
        Found := FSections[SX].ContainsCode(Code);
      end;
      Inc(SX);
    end;

    Result := Found;
  end;
end;

function TDebenuPDFLibraryCMap.GetValue(Code: Cardinal; var codes: array of Word): Integer;
var
  SS: Cardinal;
  SX: Cardinal;
  I: Integer;
begin

  for I  := 0 to 3 do
    Codes[I] := 0;

  SS := Length(FCIDRanges);

  if (FIdentityMapping) then
  begin
    Result := Code;
  end else
  if (CMapType = cmapGIDToCID) and (SS <> 0) then
  begin
    Result := -1;
    SX := 0;
    while (SX < SS) and (Result = -1) do
    begin
      if (Code >= FCIDRanges[SX].StartCode) and (Code <= FCIDRanges[SX].EndCode) then
      begin
        Codes[0] := FCIDRanges[SX].Value[0] + Code - FCIDRanges[SX].StartCode;
        Result := 1;
      end;
      Inc(SX);
    end;
  end
  else
  //if (CMapType = cmapToUnicode) then
  begin
    Result := -1;
    SX := 0;
    SS := Length(FBFRanges);
    while (SX < SS) and (Result = -1) do
    begin
      if (Code >= FBFRanges[SX].StartCode) and (Code <= FBFRanges[SX].EndCode) then
      begin

        for I := 0 to 3 do
        begin
          if (FBFRanges[SX].Value[I] <> 0) then
          begin
            Codes[I] := FBFRanges[SX].Value[I] + Code - FBFRanges[SX].StartCode;
            if (Codes[I] <> 0) then
              Result := I + 1;
          end;
        end;

        //Result := FBFRanges[SX].Value[0] + Code - FBFRanges[SX].StartCode;
        //if (FBFRanges[SX].Value[1] <> 0) then
        //  Result := Result or ((FBFRanges[SX].Value[1] + Code - FBFRanges[SX].StartCode) shl 16);
      end;
      Inc(SX);
    end;
  end;
end;

{ TDebenuPDFLibraryCMapParser }

procedure TDebenuPDFLibraryCMapParser.AddCodespaceRange(const Token1,
  Token2: AnsiString);
var
  Valid: Boolean;
  StartCode: Cardinal;
  EndCode: Cardinal;
begin
  Valid := True;
  if not HexToCardinal(Token1, StartCode) then Valid := False;
  if not HexToCardinal(Token2, EndCode) then Valid := False;
  if Valid then
  begin
    FCMap.AddCodespaceRange(StartCode, EndCode, (Length(Token1) - 2) div 2);
  end;
end;

procedure TDebenuPDFLibraryCMap.AddCodeSpaceRange(StartCode, EndCode, CodeSize: Cardinal);
var
  L: Integer;
begin
  L := Length(FCodespaceRanges);

  SetLength(FCodespaceRanges, L + 1);
  FCodespaceRanges[L].StartCode := StartCode;
  FCodespaceRanges[L].EndCode := EndCode;
end;

procedure TDebenuPDFLibraryCMap.AddBFRange(StartCode, EndCode: Cardinal; S: WideString);
var
  I, L: Integer;
begin
  L := Length(FBFRanges);

  SetLength(FBFRanges, L + 1);
  FBFRanges[L].StartCode := StartCode;
  FBFRanges[L].EndCode := EndCode;

  for I := 0 to Length(FBFRanges[L].Value) -  1 do
    FBFRanges[L].Value[I] := 0;

  for I := 0 to Length(S) - 1 do
    FBFRanges[L].Value[I] := Word(S[I+1]);
end;

procedure TDebenuPDFLibraryCMap.AddCIDRange(StartCode, EndCode, Ch: Cardinal);
var
  L: Integer;
begin
  L := Length(FCIDRanges);

  SetLength(FCIDRanges, L + 1);
  FCIDRanges[L].StartCode := StartCode;
  FCIDRanges[L].EndCode := EndCode;
  FCIDRanges[L].Value[0] := Ch;
end;

procedure TDebenuPDFLibraryCMap.Sort(var RangeArray: array of TDebenuPDFLibraryCMapRange);

  procedure _QuickSort(var A: array of TDebenuPDFLibraryCMapRange; iLo, iHi: Integer) ;
   var
     Lo, Hi:Integer;
     Pivot, T: TDebenuPDFLibraryCMapRange;
   begin
     Lo := iLo;
     Hi := iHi;
     Pivot := A[(Lo + Hi) div 2];
     repeat
       while A[Lo].StartCode < Pivot.StartCode do Inc(Lo) ;
       while A[Hi].StartCode > Pivot.StartCode do Dec(Hi) ;
       if Lo <= Hi then
       begin
         T := A[Lo];
         A[Lo] := A[Hi];
         A[Hi] := T;
         Inc(Lo) ;
         Dec(Hi) ;
       end;
     until Lo > Hi;
     if Hi > iLo then _QuickSort(A, iLo, Hi) ;
     if Lo < iHi then _QuickSort(A, Lo, iHi) ;
   end;

begin

  if (High(RangeArray) <= 1) then
    Exit;

  _QuickSort(RangeArray, Low(RangeArray), High(RangeArray));
end;

{ TDebenuPDFLibraryCMapParser }

procedure TDebenuPDFLibraryCMapParser.AddBFRange(const Token1, Token2,
  Token3: AnsiString);
var
  Valid: Boolean;
  StartCode: Cardinal;
  EndCode: Cardinal;
  Ch: Cardinal;
  I, L: Integer;
  NewTok: AnsiString;
  S: WideString;
begin
  Valid := Length(Token1) = Length(Token2);
  if not HexToCardinal(Token1, StartCode) then
    Valid := False;
  if not HexToCardinal(Token2, EndCode) then
    Valid := False;

  if QPLStartsWith(Token3, '<') and QPLEndsWith(Token3, '>') then
  begin
    L := (Length(Token3) - 2) div 4;
    SetLength(S, L);

    for I := 0 to L - 1 do
    begin
      NewTok := '<' + QPLCopy(Token3, I * 4 + 2, 4) + '>';
      S[I+1] := Chr(0);

      if not HexToCardinal(NewTok, Ch) then
        Valid := False
      else
        S[I+1] := WideChar(Ch);
    end;
  end
  else
  begin
    SetLength(S, 1);
    if not HexToCardinal(Token3, Ch) then
      Valid := False
    else
      S[1] := WideChar(Ch);
  end;

  if (FCMap.FSingleByteCMap = False) then   // Optimisation
    if QPLStartsWith(Token1, '<') and QPLEndsWith(Token1, '>') then
      if (Length(Token1) = 4) then
        FCMap.FSingleByteCMap := True;

  if (Valid) then
    FCMap.AddBFRange(StartCode, EndCode, S);
end;

procedure TDebenuPDFLibraryCMapParser.AddCIDRange(const Token1, Token2,
  Token3: AnsiString);
var
  Valid: Boolean;
  StartCode: Cardinal;
  EndCode: Cardinal;
  Ch: Cardinal;
begin
  Valid := Length(Token1) = Length(Token2);
  if not HexToCardinal(Token1, StartCode) then
    Valid := False;
  if not HexToCardinal(Token2, EndCode) then
    Valid := False;
  if not HexToCardinal(Token3, Ch) then
    Valid := False;

  if (FCMap.FSingleByteCMap = False) then   // Optimisation
    if QPLStartsWith(Token1, '<') and QPLEndsWith(Token1, '>') then
      if (Length(Token1) = 4) then
        FCMap.FSingleByteCMap := True;

  if (Valid) then
    FCMap.AddCIDRange(StartCode, EndCode, Ch);
end;

constructor TDebenuPDFLibraryCMapParser.Create;
begin
  SetLength(FEndOfLine, 2);
  FEndOfLine[0] := 10;  // Line feed
  FEndOfLine[1] := 13;  // Carriage return

  // Whitespace and end of line
  SetLength(FAllWhitespace, 6);
  FAllWhitespace[0] := 0;
  FAllWhitespace[1] := 9;
  FAllWhitespace[2] := 12;
  FAllWhitespace[3] := 32;
  FAllWhitespace[4] := 10;
  FAllWhitespace[5] := 13;

  // Whitespace, end of line, comment, array start, array end
  SetLength(FNonCharacter, 9);
  FNonCharacter[0] := 0;
  FNonCharacter[1] := 9;
  FNonCharacter[2] := 12;
  FNonCharacter[3] := 32;
  FNonCharacter[4] := 10;
  FNonCharacter[5] := 13;
  FNonCharacter[6] := 37;
  FNonCharacter[7] := Ord('[');
  FNonCharacter[8] := Ord(']');

  SetLength(FArray, 2);
  FArray[0] := Ord('[');
  FArray[1] := Ord(']');
end;

function TDebenuPDFLibraryCMapParser.NextToken: AnsiString;
var
  IsComment: boolean;
  TempPosition: Integer;
  EndOfLineDistance: Integer;
  NonCharacterDistance: Integer;
  ArrayDistance: Integer;
  HexDistance: Integer;
begin
  Result := '';
  SkipWhitespace;

  //CommentDistance := FBuffer.DistanceToByte(Ord('%'));
  //if (CommentDistance = 0) then
  //We dont need to chceck the possition of the comment sign since we want to know if its the next byte
  TempPosition := FBuffer.Position;
  IsComment := FBuffer.ReadByte() = Ord('%');
  FBuffer.Position := TempPosition;
  if(IsComment) then
  begin
    // This is a comment - return everything until the next end of line
    EndOfLineDistance := FBuffer.DistanceToAnyByte(FEndOfLine);
    if (EndOfLineDistance > 0) then
    begin
      Result := FBuffer.ReadAnsiString(EndOfLineDistance);
    end;
  end else
  begin
    // This isn't a comment, check if it's an array
    ArrayDistance := FBuffer.DistanceToAnyByte(FArray);
    if ArrayDistance = 0 then
    begin
      Result := FBuffer.ReadAnsiString(1);
    end else
    begin
      HexDistance := FBuffer.DistanceToByte(Ord('<'));
      if (HexDistance = 0) then
      begin
        // Skip over the first "<"
        FBuffer.ReadAnsiString(1);

        HexDistance := FBuffer.DistanceToByte(Ord('<'));
        if (HexDistance = 0) then
        begin
          // This is a dictionary
          HexDistance := FBuffer.DistanceToByte(Ord('>'));
          Result := '<' + FBuffer.ReadAnsiString(HexDistance + 2);
        end else
        begin
          HexDistance := FBuffer.DistanceToByte(Ord('>'));
          Result := '<' + FBuffer.ReadAnsiString(HexDistance + 1);
        end;
      end else
      begin
        // This isn't a comment or an array or a hex string so return everything
        // until the next non-character
        NonCharacterDistance := FBuffer.DistanceToAnyByte(FNonCharacter);
        if (NonCharacterDistance > 0) then
        begin
          Result := FBuffer.ReadAnsiString(NonCharacterDistance);
        end;
      end;
    end;
  end;
end;

function TDebenuPDFLibraryCMapParser.ParseCMap(Buffer: TQPLBuffer): TDebenuPDFLibraryCMap;
begin
  FCMap := TDebenuPDFLibraryCMap.Create;

  FBuffer := Buffer;
  FCMap.UseCMapName := ParseBuffer(Buffer);

  Result := FCMap;
end;

function TDebenuPDFLibraryCMapParser.ParseBuffer(Buffer: TQPLBuffer): AnsiString;
var
  Token, LastToken: AnsiString;
  Finished: Boolean;
  StackIndex: Integer;
  State: AnsiString;
  ItemCount: Integer;
  PartCount: Integer;
  ArrayOne: Cardinal;
  ArrayTwo: Cardinal;
  ArrayIndex: Cardinal;

begin

  Result := '';
  State := '';
  Token := '';
  ItemCount := 0;
  PartCount := 0;
  Finished := False;

  repeat
    LastToken := Token;
    Token := NextToken;

    if Token = '/CMapType' then
    begin
      Token := NextToken;

      if Token = '0' then FCMap.CMapType := cmapGIDToCID;
      if Token = '1' then FCMap.CMapType := cmapGIDToCID;
      if Token = '2' then FCMap.CMapType := cmapToUnicode;
    end;

    if (Token = 'usecmap') then
    begin
      LastToken := Copy(LastToken,  2, MaxInt);
      Result := LastToken;
    end;

    if Token = '' then Finished := True;
    if Token = 'endcmap' then Finished := True;

    if Token = 'begincmap' then State := 'begincmap';

    if State = 'begincmap' then
    begin
      if Token = 'begincodespacerange' then
      begin
        State := State + '-' + Token;
        ItemCount := QPLStrToIntDef(FTokenStack[0], 0);
        PartCount := 0;
      end else
      if Token = 'beginbfchar' then
      begin
        State := State + '-' + Token;
        ItemCount := QPLStrToIntDef(FTokenStack[0], 0);
        PartCount := 0;
      end else
      if Token = 'beginbfrange' then
      begin
        State := State + '-' + Token;
        ItemCount := QPLStrToIntDef(FTokenStack[0], 0);
        PartCount := 0;
      end else
      if Token = 'begincidchar' then
      begin
        State := State + '-' + Token;
        ItemCount := QPLStrToIntDef(FTokenStack[0], 0);
        PartCount := 0;
      end else
      if Token = 'begincidrange' then
      begin
        State := State + '-' + Token;
        ItemCount := QPLStrToIntDef(FTokenStack[0], 0);
        PartCount := 0;
      end;
    end else
    if State = 'begincmap-begincodespacerange' then
    begin
      if (ItemCount > 0) then
      begin
        Inc(PartCount);
        if PartCount = 2 then
        begin
          PartCount := 0;
          AddCodespaceRange(FTokenStack[0], Token);
          Dec(ItemCount);
        end;
      end;
      if Token = 'endcodespacerange' then
      begin
        State := 'begincmap';
        ItemCount := 0;
      end;
    end else
    if State = 'begincmap-beginbfrange' then
    begin
      if (ItemCount > 0) then
      begin
        Inc(PartCount);
        if PartCount = 3 then
        begin
          if (Token = '[') then
          begin
            HexToCardinal(FTokenStack[1], ArrayOne);
            HexToCardinal(FTokenStack[0], ArrayTwo);
            if (ArrayTwo >= ArrayOne) then
            begin
              for ArrayIndex := ArrayOne to ArrayTwo do
              begin
                Token := NextToken;
                if (Token <> '') then
                begin
                  AddBFRange('<' + QPLIntToHex(ArrayIndex, 4) + '>',
                    '<' + QPLIntToHex(ArrayIndex, 4) + '>', Token);
                end;
              end;
            end;

            repeat
              Token := NextToken;
            until (Token = ']') or (Token = '');
          end else
          begin
            PartCount := 0;
            AddBFRange(FTokenStack[1], FTokenStack[0], Token);
            Dec(ItemCount);
          end;
        end;
      end;
      if Token = 'endbfrange' then
      begin
        State := 'begincmap';
        ItemCount := 0;
      end;
    end else
    if State = 'begincmap-beginbfchar' then
    begin
      if (ItemCount > 0) then
      begin
        Inc(PartCount);
        if PartCount = 2 then
        begin
          PartCount := 0;
          AddBFRange(FTokenStack[0], FTokenStack[0], Token);
          Dec(ItemCount);
        end;
      end;
      if Token = 'endbfchar' then
      begin
        State := 'begincmap';
        ItemCount := 0;
      end;
    end else
    if State = 'begincmap-begincidrange' then
    begin
      if (ItemCount > 0) then
      begin
        Inc(PartCount);
        if PartCount = 3 then
        begin
          if (Token = '[') then
          begin
            PartCount := 100;
          end else
          begin
            PartCount := 0;
            AddCIDRange(FTokenStack[1], FTokenStack[0], Token);
            Dec(ItemCount);
          end;
        end;
      end;
      if Token = 'endcidrange' then
      begin
        State := 'begincmap';
        ItemCount := 0;
      end;
    end else
    if State = 'begincmap-begincidchar' then
    begin
      if (ItemCount > 0) then
      begin
        Inc(PartCount);
        if PartCount = 2 then
        begin
          PartCount := 0;
          AddCIDRange(FTokenStack[0], FTokenStack[0], Token);
          Dec(ItemCount);
        end;
      end;
      if Token = 'endcidchar' then
      begin
        State := 'begincmap';
        ItemCount := 0;
      end;
    end;

    for StackIndex := 9 downto 1 do
      FTokenStack[StackIndex] := FTokenStack[StackIndex - 1];
    FTokenStack[0] := Token;
  until Finished;
end;

procedure TDebenuPDFLibraryCMapParser.SkipWhitespace;
var
  WhitespaceDistance: Integer;
  CharacterDistance: Integer;
begin
  // Currently in whitespace or end of line?
  WhitespaceDistance := FBuffer.DistanceToAnyByte(FAllWhitespace);
  if (WhitespaceDistance = 0) then
  begin
    // Get the distance to the next character
    CharacterDistance := FBuffer.DistanceToOtherBytes(FAllWhitespace);
    if (CharacterDistance > 0) then
    begin
      FBuffer.Position := FBuffer.Position + CharacterDistance;
    end;
  end;
end;

function TDebenuPDFLibraryCMapParser.HexToCardinal(
  const Token: AnsiString; var Value: Cardinal): Boolean;
var
  TestValue: Int64;
begin
  Value := 0;
  Result := False;

  if (QPLCopy(Token, 1, 1) = '<') and (QPLCopy(Token, Length(Token), 1) = '>') then
  begin
    TestValue := QPLStrToInt64Def('$' + QPLCopy(Token, 2, Length(Token) - 2), -1);
    if TestValue >= 0 then
    begin
      Value := TestValue;
      Result := True;
    end;
  end
  else
  begin                                  // Test to see if it is an integer.
    TestValue := QPLStrToInt(Token);
    if TestValue >= 0 then
    begin
      Value := TestValue;
      Result := True;
    end;
  end;
end;

{ General functions }

function ResourcesAddToUnicodeCMapFromString(Encoding: AnsiString; CMapAsString: AnsiString): TDebenuPDFLibraryCMap;
var
  CMapParser: TDebenuPDFLibraryCMapParser;
  CMapBuffer: TQPLBuffer;
begin
  CMapParser := TDebenuPDFLibraryCMapParser.Create;
  try
    CMapBuffer := TQPLBuffer.Create;
    try
      CMapBuffer.SetAnsiStringSource(CMapAsString);
      Result := CMapParser.ParseCMap(CMapBuffer);
    finally
      CMapBuffer.Free;
    end;
  finally
    CMapParser.Free;
  end;
end;

function LoadCPToUnicode(codepageId: Integer): TQPLWordPairList;
var
  ResourceStream: TResourceStream;
  RCData: AnsiString;
  I, Index: Integer;
begin

  case codePageId of
    932:  Index := 1;
    936:  Index := 2;
    949:  Index := 3;
    950:  Index := 4;
  else
    Index := 1;
  end;

  if not Assigned(CpToUnicodeList[Index]) then
  begin
    CpToUnicodeList[Index] := TQPLWordPairList.Create; 

{$IFNDEF QPL_CPP}
    ResourceStream := TResourceStream.CreateFromID(HInstance, 11000 + codepageId, RT_RCDATA);
    try
      SetLength(RCData, ResourceStream.Size);
      ResourceStream.Read(RCData[1], Length(RCData));

      RCData := InflateStr(RCData);

      I := 1;
      while I < Length(RCData) do
      begin
        CpToUnicodeList[Index].Add(I div 2, Ord(RCData[I]) + Ord(RCData[I+1]) * 256);
        Inc(I, 2);
      end;

    finally
      ResourceStream.Free;
      CpToUnicodeList[Index].Sort();
    end;
{$ENDIF}
  end;

  Result := CpToUnicodeList[Index];
end;

initialization
  CpToUnicodeList[1] := nil;
  CpToUnicodeList[2] := nil;
  CpToUnicodeList[3] := nil;
  CpToUnicodeList[4] := nil;

finalization
  if Assigned(CpToUnicodeList[1]) then CpToUnicodeList[1].Free;
  if Assigned(CpToUnicodeList[2]) then CpToUnicodeList[2].Free;
  if Assigned(CpToUnicodeList[3]) then CpToUnicodeList[3].Free;
  if Assigned(CpToUnicodeList[4]) then CpToUnicodeList[4].Free;
end.
