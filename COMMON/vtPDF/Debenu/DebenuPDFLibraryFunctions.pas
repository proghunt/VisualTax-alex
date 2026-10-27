{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryFunctions.pas                          }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryFunctions;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryStructure, DebenuPDFLibraryTypes;

type
  TPDFDoubleArray = array of Double;

  TPDFOp = (
    psOpAbs,
    psOpAdd,
    psOpAnd,
    psOpAtan,
    psOpBitshift,
    psOpCeiling,
    psOpCopy,
    psOpCos,
    psOpCvi,
    psOpCvr,
    psOpDiv,
    psOpDup,
    psOpEq,
    psOpExch,
    psOpExp,
    psOpFalse,
    psOpFloor,
    psOpGe,
    psOpGt,
    psOpIdiv,
    psOpIndex,
    psOpLe,
    psOpLn,
    psOpLog,
    psOpLt,
    psOpMod,
    psOpMul,
    psOpNe,
    psOpNeg,
    psOpNot,
    psOpOr,
    psOpPop,
    psOpRoll,
    psOpRound,
    psOpSin,
    psOpSqrt,
    psOpSub,
    psOpTrue,
    psOpTruncate,
    psOpXor,
    psOpIf,
    psOpIfelse,
    psOpReturn
  );

  TPDFTokenType = (
    psBool,
    psInt,
    psReal,
    psOperator,
    psBlock
  );

  TPDFToken = record
    ttype: TPDFTokenType;
    booln: Boolean;
    intg: Integer;
    real: Double;
    op: TPDFOp;
    blk: Integer;
  end;

  TPDFFunction = class
  private
    FFunctionType: Integer;
  protected
    FDict: TPDFDictionary;
    FStream: AnsiString;
    FDomain: TPDFDoubleArray;
    FRange: TPDFDoubleArray;
    FInputValueCount: Integer;
    FOutputValueCount: Integer;
    FSteps: Integer;
    FOnFindObject: TPDFFindObjectEvent;
    function FindObject(IndRef: TPDFIndRef): TPDFObject;
    function ReadArray(const Name: AnsiString): TPDFDoubleArray;
    function ReadInteger(const Name: AnsiString; Default: Integer = 0): Integer;
    function ReadDouble(const Name: AnsiString; Default: Double = 0): Double;
  public
    constructor Create(Source: TPDFObject; OnFindObject: TPDFFindObjectEvent); virtual;
    procedure RunFunction(var X: TPDFDoubleArray; var Y: TPDFDoubleArray); virtual; abstract;
    class function FunctionFactory(Source: TPDFObject; OnFindObject: TPDFFindObjectEvent): TPDFFunction;
    property FunctionType: Integer read FFunctionType;
    property InputValueCount: Integer read FInputValueCount;
    property OutputValueCount: Integer read FOutputValueCount;
    property Steps: Integer read FSteps;
  end;

  TPDFType0Function = class(TPDFFunction)
  private
    FSize: TPDFDoubleArray;
    FBitsPerSample: Integer;
    FOrder: Integer;
    FEncode: TPDFDoubleArray;
    FDecode: TPDFDoubleArray;
    FSamples: array of Double;
    FExpanded: Boolean;
  protected
    procedure ExpandData;
  public
    constructor Create(Source: TPDFObject; OnFindObject: TPDFFindObjectEvent); override;
    procedure RunFunction(var X: TPDFDoubleArray; var Y: TPDFDoubleArray); override;
  end;

  TPDFType2Function = class(TPDFFunction)
  private
    FC0: TPDFDoubleArray;
    FC1: TPDFDoubleArray;
    FN: Double;
  public
    constructor Create(Source: TPDFObject; OnFindObject: TPDFFindObjectEvent); override;
    procedure RunFunction(var X: TPDFDoubleArray; var Y: TPDFDoubleArray); override;
  end;

  TPDFType3Function = class(TPDFFunction)
  private
    FBounds: TPDFDoubleArray;
    FEncode: TPDFDoubleArray;
    FNArray: array of TPDFFunction;
  public
    constructor Create(Source: TPDFObject; OnFindObject: TPDFFindObjectEvent); override;
    destructor Destroy; override;
    procedure RunFunction(var X: TPDFDoubleArray; var Y: TPDFDoubleArray); override;
  end;

  TPDFType4Function = class(TPDFFunction)
  private
    FStack: TPDFDoubleArray;
	  FTokens: array of TPDFToken;
    MaxLen: Integer;
  public
    constructor Create(Source: TPDFObject; OnFindObject: TPDFFindObjectEvent); override;
    procedure RunFunction(var X: TPDFDoubleArray; var Y: TPDFDoubleArray); override;
    procedure RunFunctionNonOpt(var X: TPDFDoubleArray; var Y: TPDFDoubleArray);
  end;

implementation

uses
  Math, DebenuPDFLibraryExtra;

{ TPDFFunction }

constructor TPDFFunction.Create(Source: TPDFObject; OnFindObject: TPDFFindObjectEvent);
begin
  FInputValueCount := 0;
  FOutputValueCount := 0;
  FSteps := 2;
  FOnFindObject := OnFindObject;

  FDict := nil;
  FStream := '';
  if Source is TPDFDictionary then
    FDict := TPDFDictionary(Source);
  if Source is TPDFStream then
  begin
    FDict := TPDFStream(Source).Dictionary;
    FStream := TPDFStream(Source).GetDecodedStream;
  end;
  if Assigned(FDict) then
  begin
    FDomain := ReadArray('Domain');
    FInputValueCount := Length(FDomain) div 2;
    FRange := ReadArray('Range');
    FOutputValueCount := Length(FRange) div 2;
  end;
end;

function TPDFFunction.FindObject(IndRef: TPDFIndRef): TPDFObject;
begin
  if (Assigned(FOnFindObject)) then
  begin
    Result := FOnFindObject(IndRef);
  end else
  begin
    Result := IndRef.Obj;
  end;
end;

class function TPDFFunction.FunctionFactory(
  Source: TPDFObject; OnFindObject: TPDFFindObjectEvent): TPDFFunction;
var
  Obj: TPDFObject;
  Dict: TPDFDictionary;
  FunctionType: Integer;
begin
  Dict := nil;
  Result := nil;
  if Source is TPDFDictionary then
    Dict := TPDFDictionary(Source);
  if Source is TPDFStream then
    Dict := TPDFStream(Source).Dictionary;
  if Assigned(Dict) then
  begin
    Obj := Dict.FindValueByKeyName('FunctionType');
    if (Obj is TPDFIndRef) then
    begin
      if (Assigned(OnFindObject)) then
      begin
        Obj := OnFindObject(TPDFIndRef(Obj));
      end else
      begin
        Obj := TPDFIndRef(Obj).Obj;
      end;
    end;
    if Obj is TPDFNumeric then
      FunctionType := TPDFNumeric(Obj).AsInteger
    else
      FunctionType := -1;
    case FunctionType of
      0: Result := TPDFType0Function.Create(Source, OnFindObject);
      2: Result := TPDFType2Function.Create(Source, OnFindObject);
      3: Result := TPDFType3Function.Create(Source, OnFindObject);
      4: Result := TPDFType4Function.Create(Source, OnFindObject);
    end;
  end;
end;

function TPDFFunction.ReadArray(const Name: AnsiString): TPDFDoubleArray;
var
  Obj: TPDFObject;
  TempA: TPDFArray;
  X: Integer;
begin
  SetLength(Result, 0);
  Obj := FDict.FindValueByKeyName(Name);
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFArray then
  begin
    TempA := TPDFArray(Obj);
    SetLength(Result, TempA.Count);
    for X := 0 to TempA.Count - 1 do
    begin
      Obj := TempA.Item[X];
      if Obj is TPDFNumeric then
        Result[X] := TPDFNumeric(Obj).AsDouble
      else
        Result[X] := 0;
    end;
  end;
end;

function TPDFFunction.ReadDouble(const Name: AnsiString; Default: Double): Double;
var
  Obj: TPDFObject;
begin
  Obj := FDict.FindValueByKeyName(Name);
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsDouble
  else
    Result := Default;
end;

function TPDFFunction.ReadInteger(const Name: AnsiString; Default: Integer): Integer;
var
  Obj: TPDFObject;
begin
  Obj := FDict.FindValueByKeyName(Name);
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsInteger
  else
    Result := Default;
end;

{ TPDFType0Function }

constructor TPDFType0Function.Create;
var
  X: Integer;
begin
  inherited;
  FExpanded := False;
  FSize := ReadArray('Size');
  FBitsPerSample := ReadInteger('BitsPerSample');
  FOrder := ReadInteger('Order', 1);
  FEncode := ReadArray('Encode');
  if Length(FEncode) = 0 then
  begin
    SetLength(FEncode, FInputValueCount * 2);
    for X := 0 to FInputValueCount - 1 do
    begin
      FEncode[X * 2] := 0;
      FEncode[X * 2 + 1] := FSize[X] - 1;
    end;
  end;
  if (Length(FSize) > 0) then
  begin
    FSteps := Round(FSize[0]);
  end;
  FDecode := ReadArray('Decode');
  if Length(FDecode) = 0 then
    FDecode := Copy(FRange);
end;

procedure TPDFType0Function.ExpandData;
var
  BitPos: Integer;
  J: Integer;

  function ReadSample: Cardinal;
  var
    B: Integer;
    Offset: Integer;
    BX: Integer;
    BV: Byte;
    Bitmap: Int64;
    M: Int64;
    V: Int64;
  begin
    Bitmap := 0;
    Result := 0;
    B := BitPos div 8 + 1;
    Offset := BitPos - (B - 1) * 8;
    for BX := 0 to FBitsPerSample div 8 do
    begin
      if (B + BX) <= Length(FStream) then
        BV := Ord(FStream[B + BX])
      else
        BV := 0;

      Bitmap := (Bitmap shl 8) + BV;
    end;

    M := 1 shl (FBitsPerSample - 1);

    for BX := Offset to Offset + FBitsPerSample - 1 do
    begin
      V := 1 shl (FBitsPerSample + 8 - 1 - BX);
      if (Bitmap and V <> 0) then Result := Result + M;

      M := M shr 1;
    end;
    Inc(BitPos, FBitsPerSample);
  end;
begin
  SetLength(FSamples, Trunc((Length(FStream) * 8) / FBitsPerSample));
  BitPos := 0;
  for J := 0 to Length(FSamples) - 1 do
  begin
    FSamples[J] := ReadSample;
  end;
end;

procedure TPDFType0Function.RunFunction(var X: TPDFDoubleArray;
  var Y: TPDFDoubleArray);
var
  E1: TPDFDoubleArray;
  E2: TPDFDoubleArray;
  EDist: TPDFDoubleArray;
  EScale: TPDFDoubleArray;
  XV: Double;
  R: TPDFDoubleArray;
  R1: TPDFDoubleArray;
  R2: TPDFDoubleArray;
  X2: TPDFDoubleArray;
  I: Integer;
  M: Integer;
  N: Integer;
//  J: Integer;
//  BitPos: Integer;
//  Temp: Integer;
  A: Double;
  B: Double;
  C: Double;
  D: Double;
  AB: Double;
  CD: Double;
  ABCD: Double;
  S0: Double;
  S1: Double;
//  DebugStr: AnsiString;

  function Interpolate(X, XMin, XMax, YMin, YMax: Double): Double; {$IFNDEF QPL_NOINLINE}inline;{$ENDIF}
  begin
    if ((XMax - XMin) = 0) then
    begin
      Result := YMin;
    end else
    begin
      Result := YMin + (YMax - YMin) * (X - XMin) / (XMax - XMin);
    end;
  end;

  function InterpolateSample(Dim, Index: Integer): Double;
  var
    A, B: Double;
    Index0: Integer;
    Index1: Integer;
  begin
    Index0 := Trunc(E1[Dim] * EScale[Dim]) + Index;
    Index1 := Trunc(E2[Dim] * EScale[Dim]) + Index;
    if (Dim = 0) then
    begin
      A := FSamples[Index0];
      B := FSamples[Index1];
    end else
    begin
      A := InterpolateSample(Dim - 1, Index0);
      B := InterpolateSample(Dim - 1, Index1);
    end;

    Result := A + (B - A) * EDist[Dim];
  end;

begin
  if (not FExpanded) then
  begin
    ExpandData;
    FExpanded := True;
  end;
  M := FInputValueCount;
  N := FOutputValueCount;

  SetLength(E1, M);
  SetLength(E2, M);
  SetLength(EDist, M);
  SetLength(EScale, M);
  SetLength(R, N);
  SetLength(R1, N);
  SetLength(R2, N);
  SetLength(Y, N);

  X2 := Copy(X, 0, Length(X));

  for I := 0 to M - 1 do
  begin
    X2[I] := Math.Min(Math.Max(X2[I], FDomain[2 * I]), FDomain[2 * I + 1]);
    XV := Interpolate(X2[I], FDomain[2 * I], FDomain[2 * I + 1], FEncode[2 * I], FEncode[2 * I + 1]);
    XV := Math.Min(Math.Max(XV, 0), FSize[I] - 1);
    E1[I] := Floor(XV);
    E2[I] := Ceil(XV);
    EDist[I] := XV - Floor(XV);
  end;

  EScale[0] := N;
  for I := 1 to M - 1 do
  begin
    EScale[I] := EScale[I - 1] * FSize[I];
  end;

  for I := 0 to N - 1 do
  begin
    if (M = 1) then
    begin
      A := FSamples[Trunc(E1[0] * N) + I];
      B := FSamples[Trunc(E2[0] * N) + I];
      AB := A + (B - A) * EDist[0];
      Y[I] := Interpolate(AB, 0, 1 shl FBitsPerSample - 1, FDecode[2 * I], FDecode[2 * I + 1]);
      Y[I] := Math.Min(Math.Max(Y[I], FRange[2 * I]), FRange[2 * I + 1]);
    end else
    if (M = 2) then
    begin
      S0 := N;
      S1 := S0 * FSize[0];
      A := FSamples[Trunc(E1[0] * S0 + E1[1] * S1 + I)];
      B := FSamples[Trunc(E2[0] * S0 + E1[1] * S1 + I)];
      C := FSamples[Trunc(E1[0] * S0 + E2[1] * S1 + I)];
      D := FSamples[Trunc(E2[0] * S0 + E2[1] * S1 + I)];
      AB := A + (B - A) * EDist[0];
      CD := C + (D - C) * EDist[0];
      ABCD := AB + (CD - AB) * EDist[1];
      Y[I] := Interpolate(ABCD, 0, 1 shl FBitsPerSample - 1, FDecode[2 * I], FDecode[2 * I + 1]);
      Y[I] := Math.Min(Math.Max(Y[I], FRange[2 * I]), FRange[2 * I + 1]);
    end else
    begin
      A := InterpolateSample(M - 1, I);
      Y[I] := Interpolate(A, 0, 1 shl FBitsPerSample - 1, FDecode[2 * I], FDecode[2 * I + 1]);
      Y[I] := Math.Min(Math.Max(Y[I], FRange[2 * I]), FRange[2 * I + 1]);
    end;
  end;
end;

{ TPDFType2Function }

constructor TPDFType2Function.Create;
begin
  inherited;
  FC0 := ReadArray('C0');
  if Length(FC0) = 0 then
  begin
    SetLength(FC0, 1);
    FC0[0] := 0;
  end;
  FC1 := ReadArray('C1');
  if Length(FC1) = 0 then
  begin
    SetLength(FC1, 1);
    FC1[0] := 1;
  end;
  FN := ReadDouble('N', 1);
  if (FOutputValueCount = 0) then
  begin
    FOutputValueCount := Length(FC0);
  end;
end;

procedure TPDFType2Function.RunFunction(var X: TPDFDoubleArray;
  var Y: TPDFDoubleArray);
var
  J: Integer;
begin
  SetLength(Y, FOutputValueCount);
  for J := 0 to FOutputValueCount - 1 do
    Y[J] := FC0[J] + Power(X[0], FN) * (FC1[J] - FC0[J]);
end;

{ TPDFType4Function }

constructor TPDFType4Function.Create(Source: TPDFObject; OnFindObject: TPDFFindObjectEvent);
var
  TokenIndex: Integer;
  CurrPos: Integer;
  S: AnsiString;
  I: Integer;

  procedure ResizeTokens(Size: Integer);
  begin
    if (Size >= Length(FTokens)) then
    begin
      SetLength(FTokens, Size+1);
    end;
  end;

  function GetToken: AnsiString;
  var
    InWhitespace: Boolean;
    TokStart: Integer;
    TokEnd: Integer;
  begin
    if CurrPos < MaxLen then
    begin
      repeat
        InWhitespace := False;
        case S[CurrPos] of
          #0,#9,#10,#12,#13,#32:
          begin
            InWhitespace := True;
            Inc(CurrPos);
          end;
        end;
      until (not InWhitespace) or (CurrPos > MaxLen);
      if CurrPos = MaxLen then
      begin
        Result := S[CurrPos];
        CurrPos := MaxLen + 1;
      end else
      if CurrPos < MaxLen then
      begin
        TokStart := CurrPos;
        if S[CurrPos] = '{' then
        begin
          Result := '{';
          Inc(CurrPos);
        end else
        if S[CurrPos] = '}' then
        begin
          Result := '}';
          Inc(CurrPos);
        end else
        repeat
          Inc(CurrPos);
          InWhitespace := False;
          case S[CurrPos] of
            #0,#9,#10,#12,#13,#32,#123,#125: InWhitespace := True;
          end;
        until (InWhitespace) or (CurrPos >= MaxLen);
        if (not InWhitespace) and (CurrPos = MaxLen) then Inc(CurrPos);
        TokEnd := CurrPos - 1;
        Result := Copy(S, TokStart, TokEnd - TokStart + 1);
        if InWhitespace and (CurrPos = MaxLen) then Inc(CurrPos);
      end else
        Result := '';
    end else
      Result := '';
  end;

  function ParseFunction(TokenIndex: PInteger): Boolean;
  var
    Tok: AnsiString;
    opPtr: Integer;
    elsePtr: Integer;
  begin
    repeat
      Tok := GetToken;
      if Tok <> '' then
      begin
        if Tok = '{' then
        begin
          opPtr := TokenIndex^;
          Inc(TokenIndex^, 3);
          ResizeTokens(opPtr + 2);
          if (ParseFunction(TokenIndex) = False) then
          begin
            Result := False;
            Exit;
          end;
          Tok := GetToken;
          if Tok = '{' then
          begin
            elsePtr := TokenIndex^;
            if (ParseFunction(TokenIndex) = False) then
            begin
              Result := False;
              Exit;
            end;
            Tok := GetToken;
          end else
          begin
            elsePtr := -1;
          end;

          if Tok = 'if' then
          begin
            if (elsePtr >= 0)  then
            begin
              Result := False;
              Exit;
            end;
            FTokens[opPtr].ttype := psOperator;
            FTokens[opPtr].op := psOpIf;
            FTokens[opPtr+2].ttype := psBlock;
            FTokens[opPtr+2].blk := TokenIndex^;
          end else
          if Tok = 'ifelse' then
          begin
            if (elsePtr < 0) then
            begin
              Result := False;
              Exit;
            end;
            FTokens[opPtr].ttype := psOperator;
            FTokens[opPtr].op := psOpIfelse;
            FTokens[opPtr+1].ttype := psBlock;
            FTokens[opPtr+1].blk := elsePtr;
            FTokens[opPtr+2].ttype := psBlock;
            FTokens[opPtr+2].blk := TokenIndex^;
          end else
          begin
            Result := False;
            Exit;
          end;
        end else
        if Tok = '}' then
        begin
          ResizeTokens(TokenIndex^);
          FTokens[TokenIndex^].ttype := psOperator;
          FTokens[TokenIndex^].op := psOpReturn;
          Inc(TokenIndex^);
          Break;
        end else
        if ((Tok[1] >= 'a') and (Tok[1] <= 'z')) or (Tok = '{') or (Tok = '}') then
        begin
          ResizeTokens(TokenIndex^);
          FTokens[TokenIndex^].ttype := psOperator;

          if Tok = 'add' then FTokens[TokenIndex^].op := psOpAdd
          else if Tok = 'sub' then FTokens[TokenIndex^].op := psOpSub
          else if Tok = 'mul' then FTokens[TokenIndex^].op := psOpMul
          else if Tok = 'div' then FTokens[TokenIndex^].op := psOpDiv
          else if Tok = 'idiv' then FTokens[TokenIndex^].op := psOpIdiv
          else if Tok = 'mod' then FTokens[TokenIndex^].op := psOpMod
          else if Tok = 'neg' then FTokens[TokenIndex^].op := psOpNeg
          else if Tok = 'abs' then FTokens[TokenIndex^].op := psOpAbs
          else if Tok = 'ceiling' then FTokens[TokenIndex^].op := psOpCeiling
          else if Tok = 'floor' then FTokens[TokenIndex^].op := psOpFloor
          else if Tok = 'round' then FTokens[TokenIndex^].op := psOpRound
          else if Tok = 'truncate' then FTokens[TokenIndex^].op := psOpTruncate
          else if Tok = 'sqrt' then FTokens[TokenIndex^].op := psOpSqrt
          else if Tok = 'sin' then FTokens[TokenIndex^].op := psOpSin
          else if Tok = 'cos' then FTokens[TokenIndex^].op := psOpCos
          else if Tok = 'atan' then FTokens[TokenIndex^].op := psOpAtan
          else if Tok = 'exp' then FTokens[TokenIndex^].op := psOpExp
          else if Tok = 'ln' then FTokens[TokenIndex^].op := psOpLn
          else if Tok = 'log' then FTokens[TokenIndex^].op := psOpLog
          else if Tok = 'cvi' then FTokens[TokenIndex^].op := psOpCvi
          else if Tok = 'cvr' then FTokens[TokenIndex^].op := psOpCvr
          else if Tok = 'eq' then FTokens[TokenIndex^].op := psOpEq
          else if Tok = 'ne' then FTokens[TokenIndex^].op := psOpNe
          else if Tok = 'gt' then FTokens[TokenIndex^].op := psOpGt
          else if Tok = 'ge' then FTokens[TokenIndex^].op := psOpGe
          else if Tok = 'lt' then FTokens[TokenIndex^].op := psOpLt
          else if Tok = 'le' then FTokens[TokenIndex^].op := psOpLe
          else if Tok = 'and' then FTokens[TokenIndex^].op := psOpAnd
          else if Tok = 'or' then FTokens[TokenIndex^].op := psOpOr
          else if Tok = 'xor' then FTokens[TokenIndex^].op := psOpXor
          else if Tok = 'not' then FTokens[TokenIndex^].op := psOpNot
          else if Tok = 'bitshift' then FTokens[TokenIndex^].op := psOpBitshift
          else if Tok = 'true' then FTokens[TokenIndex^].op := psOpTrue
          else if Tok = 'false' then FTokens[TokenIndex^].op := psOpFalse
          else if Tok = 'pop' then FTokens[TokenIndex^].op := psOpPop
          else if Tok = 'exch' then FTokens[TokenIndex^].op := psOpExch
          else if Tok = 'dup' then FTokens[TokenIndex^].op := psOpDup
          else if Tok = 'copy' then FTokens[TokenIndex^].op := psOpCopy
          else if Tok = 'index' then FTokens[TokenIndex^].op := psOpIndex
          else if Tok = 'roll' then FTokens[TokenIndex^].op := psOpRoll
          else begin
            Result := False;
            Exit;
          end;
          Inc(TokenIndex^);
        end else
        begin
          ResizeTokens(TokenIndex^);
          FTokens[TokenIndex^].ttype := psReal;
          FTokens[TokenIndex^].real := TazzToFloat(Tok);
          Inc(TokenIndex^);
        end;
      end;
    until Tok = '';
    Result := True;
  end;

begin
  inherited;
  SetLength(FStack, 0);

  MaxLen := Length(FStream);
  TokenIndex := 0;
  CurrPos := 1;

  S := FStream;
  if Copy(S, 1, 1) = '{' then Delete(S, 1, 1);
  CurrPos := Length(S);
  for I := 1 to Length(S) do
  begin
    if S[I] = '}' then
      CurrPos := I;
  end;
  S := Copy(S, 1, CurrPos - 1);
  CurrPos := 1;
  MaxLen := Length(S);

  TokenIndex := 0;
  ParseFunction(@TokenIndex);
end;

procedure TPDFType4Function.RunFunction(var X: TPDFDoubleArray;
  var Y: TPDFDoubleArray);
var
  I: Integer;
  J: Integer;

  procedure Push(Value: Double);
  begin
    SetLength(FStack, Length(FStack) + 1);
    FStack[Length(FStack) - 1] := Value;
  end;

  function Pop: Double;
  begin
    if Length(FStack) > 0 then
    begin
      Result := FStack[Length(FStack) - 1];
      SetLength(FStack, Length(FStack) - 1);
    end else
      Result := 0;  // Stack underflow
  end;

  function PopI: Integer;
  begin
    Result := Round(Pop);
  end;

  procedure Exec(TokenIndex: Integer);
  var
    D1, D2: Double;
    I1, I2: Integer;
    TX: Integer;
    TI: Integer;
  begin
    repeat
      if TokenIndex >= Length(FTokens) then
        Break
      else begin
        if (FTokens[TokenIndex].ttype = psReal) then
        begin
          Push(FTokens[TokenIndex].real);
          Inc(TokenIndex);
        end else
        if (FTokens[TokenIndex].ttype = psOperator) then
        begin
          // Arithmetic operators
          if FTokens[TokenIndex].op = psOpAdd then
          begin
            D2 := Pop;
            D1 := Pop;
            Push(D1 + D2);
          end else
          if FTokens[TokenIndex].op = psOpSub then
          begin
            D2 := Pop;
            D1 := Pop;
            Push(D1 - D2);
          end else
          if FTokens[TokenIndex].op = psOpMul then
          begin
            D2 := Pop;
            D1 := Pop;
            Push(D1 * D2);
          end else
          if FTokens[TokenIndex].op = psOpDiv then
          begin
            D2 := Pop;
            D1 := Pop;
            Push(D1 / D2);
          end else
          if FTokens[TokenIndex].op = psOpIdiv then
          begin
            I2 := PopI;
            I1 := PopI;
            Push(I1 div I2);
          end else
          if FTokens[TokenIndex].op = psOpMod then
          begin
            I2 := PopI;
            I1 := PopI;
            Push(I1 mod I2);
          end else
          if FTokens[TokenIndex].op = psOpNeg then
          begin
            Push(-Pop);
          end else
          if FTokens[TokenIndex].op = psOpAbs then
          begin
            Push(Abs(Pop));
          end else
          if FTokens[TokenIndex].op = psOpCeiling then
          begin
            Push(Ceil(Pop));
          end else
          if FTokens[TokenIndex].op = psOpFloor then
          begin
            Push(Floor(Pop));
          end else
          if FTokens[TokenIndex].op = psOpRound then
          begin
            Push(Round(Pop));
          end else
          if FTokens[TokenIndex].op = psOpTruncate then
          begin
            Push(Trunc(Pop));
          end else
          if FTokens[TokenIndex].op = psOpSqrt then
          begin
            Push(Sqrt(Pop));
          end else
          if FTokens[TokenIndex].op = psOpSin then
          begin
            Push(Sin(DegToRad(Pop)));
          end else
          if FTokens[TokenIndex].op = psOpCos then
          begin
            Push(Cos(DegToRad(Pop)));
          end else
          if FTokens[TokenIndex].op = psOpAtan then
          begin
            D2 := Pop;
            D1 := Pop;
            D1 := RadToDeg(ArcTan2(D1, D2));
            if (D1 < 0) then
            begin
              D1 := D1 + 360;
            end;
            Push(D1);
          end else
          if FTokens[TokenIndex].op = psOpExp then
          begin
            D2 := Pop;
            D1 := Pop;
            Push(Power(D1, D2));
          end else
          if FTokens[TokenIndex].op = psOpLn then
          begin
            Push(Ln(Pop));
          end else
          if FTokens[TokenIndex].op = psOpLog then
          begin
            Push(Log10(Pop));
          end else
          if FTokens[TokenIndex].op = psOpCvi then
          begin
            Push(Round(Pop));
          end else
          if FTokens[TokenIndex].op = psOpCvr then
          begin
            Push(Pop);
          end else
          // Relational, Boolean and Bitwise Operators
          if FTokens[TokenIndex].op = psOpEq then
          begin
            D2 := Pop;
            D1 := Pop;
            if (D1 = D2) then Push(1) else Push(0);
          end else
          if FTokens[TokenIndex].op = psOpNe then
          begin
            D2 := Pop;
            D1 := Pop;
            if (D1 = D2) then Push(0) else Push(1);
          end else
          if FTokens[TokenIndex].op = psOpGt then
          begin
            D2 := Pop;
            D1 := Pop;
            if (D1 > D2) then Push(1) else Push(0);
          end else
          if FTokens[TokenIndex].op = psOpGe then
          begin
            D2 := Pop;
            D1 := Pop;
            if (D1 >= D2) then Push(1) else Push(0);
          end else
          if FTokens[TokenIndex].op = psOpLt then
          begin
            D2 := Pop;
            D1 := Pop;
            if (D1 < D2) then Push(1) else Push(0);
          end else
          if FTokens[TokenIndex].op = psOpLe then
          begin
            D2 := Pop;
            D1 := Pop;
            if (D1 <= D2) then Push(1) else Push(0);
          end else
          if FTokens[TokenIndex].op = psOpAnd then
          begin
            I2 := PopI;
            I1 := PopI;
            Push(I1 and I2);
          end else
          if FTokens[TokenIndex].op = psOpOr then
          begin
            I2 := PopI;
            I1 := PopI;
            Push(I1 or I2);
          end else
          if FTokens[TokenIndex].op = psOpXor then
          begin
            I2 := PopI;
            I1 := PopI;
            Push(I1 xor I2);
          end else
          if FTokens[TokenIndex].op = psOpNot then
          begin
            Push(not PopI);
          end else
          if FTokens[TokenIndex].op = psOpBitshift then
          begin
            I2 := PopI;
            I1 := PopI;
            if I1 > 0 then
              Push(I1 shl I2)
            else
              Push(I1 shr I2);
          end else
          if FTokens[TokenIndex].op = psOpTrue then
          begin
            Push(1);
          end else
          if FTokens[TokenIndex].op = psOpFalse then
          begin
            Push(0);
          end else
          // Conditional operators
          if FTokens[TokenIndex].op = psOpIf then
          begin
            I1 := PopI;
            if (I1 = 1) then
					    Exec(TokenIndex + 3);
				    TokenIndex := FTokens[TokenIndex + 2].blk;
            Dec(TokenIndex);
          end else
          if FTokens[TokenIndex].op = psOpIfelse then
          begin
            I1 := PopI;
            if (I1 = 1) then
					    Exec(TokenIndex + 3)
            else
					    Exec(FTokens[TokenIndex+1].blk);
    				TokenIndex := FTokens[TokenIndex + 2].blk;
            Dec(TokenIndex);
          end else
          if FTokens[TokenIndex].op = psOpReturn then
          begin
            Exit;
          end else
          // Stack operators
          if FTokens[TokenIndex].op = psOpPop then
          begin
            Pop;
          end else
          if FTokens[TokenIndex].op = psOpExch then
          begin
            D2 := Pop;
            D1 := Pop;
            Push(D2);
            Push(D1);
          end else
          if FTokens[TokenIndex].op = psOpDup then
          begin
            Push(FStack[Length(FStack) - 1]);
          end else
          if FTokens[TokenIndex].op = psOpCopy then
          begin
            I1 := PopI;
            TI := Length(FStack) - I1;
            for TX := 0 to I1 - 1 do
              Push(FStack[TI + TX]);
          end else
          if FTokens[TokenIndex].op = psOpIndex then
          begin
            I1 := PopI;
            Push(FStack[Length(FStack) - I1 - 1]);
          end else
          if FTokens[TokenIndex].op = psOpRoll then
          begin
            I1 := PopI;
            I2 := PopI;
            if I1 > 0 then
            begin
              while I1 > 0 do
              begin
                D1 := FStack[Length(FStack) - 1];
                for TX := Length(FStack) - 1 downto Length(FStack) - I2 + 1 do
                  FStack[TX] := FStack[TX - 1];
                FStack[Length(FStack) - I2] := D1;
                Dec(I1);
              end;
            end else
            if I1 < 0 then
            begin
              while I1 < 0 do
              begin
                D1 := FStack[Length(FStack) - I2];
                for TX := Length(FStack) - I2 to Length(FStack) - 2 do
                  FStack[TX] := FStack[TX + 1];
                FStack[Length(FStack) - 1] := D1;
                Inc(I1);
              end;
            end;
          end else
          begin
            Break;
          end;
          Inc(TokenIndex);
        end else
          Break;
      end;
    until False;
  end;

begin
  SetLength(FStack, 0);

  for I := 0 to FInputValueCount - 1 do
    Push(X[I]);

  Exec(0);

  SetLength(Y, FOutputValueCount);
  for J := 0 to FOutputValueCount - 1 do
    Y[FOutputValueCount - 1 - J] := Pop;

  // Range
  // (Required for type 0 and type 4 functions, optional otherwise; see below)
  // An array of 2 × n numbers, where n is the number of output values.
  // For each jfrom 0 to n - 1, Range2j must be less than or equal to Range2j+1 ,
  // and the jth output value, yj , must lie in the interval Range2j = yj = Range2j+1 .
  // Output values outside the declared range are clipped to the nearest boundary value.
  // If this entry is absent, no clipping is done.
  for J := 0 to FOutputValueCount - 1 do
    Y[J] := Math.Min(Math.Max(Y[J], FRange[2 * J]), FRange[2 * J + 1]);
end;

////////////////////////////////////////////////////////////////////////////////
procedure TPDFType4Function.RunFunctionNonOpt(var X: TPDFDoubleArray;
  var Y: TPDFDoubleArray);
var
  I: Integer;
  J: Integer;
  S: AnsiString;
  MaxLen: Integer;
  TokPos: Integer;
  Tok: AnsiString;
  D1, D2: Double;
  I1, I2: Integer;
  Bad: AnsiString;
  TX: Integer;
  TI: Integer;
  Sub: array of AnsiString;
  SubCount: Integer;

  function NextToken: AnsiString;
  var
    InWhitespace: Boolean;
    TokStart: Integer;
    TokEnd: Integer;
  begin
    if TokPos < MaxLen then
    begin
      repeat
        InWhitespace := False;
        case S[TokPos] of
          #0,#9,#10,#12,#13,#32:
          begin
            InWhitespace := True;
            Inc(TokPos);
          end;
        end;
      until (not InWhitespace) or (TokPos > MaxLen);
      if TokPos = MaxLen then
      begin
        Result := S[TokPos];
        TokPos := MaxLen + 1;
      end else
      if TokPos < MaxLen then
      begin
        TokStart := TokPos;
        if S[TokPos] = '{' then
        begin
          Result := '{';
          Inc(TokPos);
        end else
        if S[TokPos] = '}' then
        begin
          Result := '}';
          Inc(TokPos);
        end else
        repeat
          Inc(TokPos);
          InWhitespace := False;
          case S[TokPos] of
            #0,#9,#10,#12,#13,#32,#123,#125: InWhitespace := True;
          end;
        until (InWhitespace) or (TokPos >= MaxLen);
        if (not InWhitespace) and (TokPos = MaxLen) then Inc(TokPos);
        TokEnd := TokPos - 1;
        Result := QPLCopy(S, TokStart, TokEnd - TokStart + 1);
        if InWhitespace and (TokPos = MaxLen) then Inc(TokPos);
      end else
        Result := '';
    end else
      Result := '';
  end;

  procedure Push(Value: Double);
  begin
    SetLength(FStack, Length(FStack) + 1);
    FStack[Length(FStack) - 1] := Value;
  end;

  function Pop: Double;
  begin
    if Length(FStack) > 0 then
    begin
      Result := FStack[Length(FStack) - 1];
      SetLength(FStack, Length(FStack) - 1);
    end else
      Result := 0;  // Stack underflow
  end;

  function PopI: Integer;
  begin
    Result := Round(Pop);
  end;

begin
  for I := 0 to FInputValueCount - 1 do
    Push(X[I]);

  S := FStream;
  if QPLCopy(S, 1, 1) = '{' then Delete(S, 1, 1);
  TokPos := Length(S);
  for I := 1 to Length(S) do
  begin
    if S[I] = '}' then
      TokPos := I;
  end;
  S := QPLCopy(S, 1, TokPos - 1);
  TokPos := 1;
  MaxLen := Length(S);
  Bad := '';

  repeat
    Tok := NextToken;
    if Tok <> '' then
    begin
      if Tok = '{' then
      begin
        SubCount := 1;
        SetLength(Sub, Length(Sub) + 1);
        Sub[Length(Sub) - 1] := '';
        repeat
          Tok := NextToken;
          if Tok = '{' then Inc(SubCount);
          if Tok = '}' then Dec(SubCount);
          if Tok = '' then SubCount := 0;
          if (SubCount > 0) then
          begin
            Sub[Length(Sub) - 1] := Sub[Length(Sub) - 1] + Tok + ' ';
          end;
        until SubCount = 0;
        Sub[Length(Sub) - 1] := Sub[Length(Sub) - 1] + ' ';
      end else
      if ((Tok[1] >= 'a') and (Tok[1] <= 'z')) or (Tok = '{') or (Tok = '}') then
      begin
        // Arithmetic operators
        if Tok = 'add' then
        begin
          D2 := Pop;
          D1 := Pop;
          Push(D1 + D2);
        end else
        if Tok = 'sub' then
        begin
          D2 := Pop;
          D1 := Pop;
          Push(D1 - D2);
        end else
        if Tok = 'mul' then
        begin
          D2 := Pop;
          D1 := Pop;
          Push(D1 * D2);
        end else
        if Tok = 'div' then
        begin
          D2 := Pop;
          D1 := Pop;
          Push(D1 / D2);
        end else
        if Tok = 'idiv' then
        begin
          I2 := PopI;
          I1 := PopI;
          Push(I1 div I2);
        end else
        if Tok = 'mod' then
        begin
          I2 := PopI;
          I1 := PopI;
          Push(I1 mod I2);
        end else
        if Tok = 'neg' then
        begin
          Push(-Pop);
        end else
        if Tok = 'abs' then
        begin
          Push(Abs(Pop));
        end else
        if Tok = 'ceiling' then
        begin
          Push(Ceil(Pop));
        end else
        if Tok = 'floor' then
        begin
          Push(Floor(Pop));
        end else
        if Tok = 'round' then
        begin
          Push(Round(Pop));
        end else
        if Tok = 'truncate' then
        begin
          Push(Trunc(Pop));
        end else
        if Tok = 'sqrt' then
        begin
          Push(Sqrt(Pop));
        end else
        if Tok = 'sin' then
        begin
          Push(Sin(DegToRad(Pop)));
        end else
        if Tok = 'cos' then
        begin
          Push(Cos(DegToRad(Pop)));
        end else
        if Tok = 'atan' then
        begin
          D2 := Pop;
          D1 := Pop;
          D1 := RadToDeg(ArcTan2(D1, D2));
          if (D1 < 0) then
          begin
            D1 := D1 + 360;
          end;
          Push(D1);
        end else
        if Tok = 'exp' then
        begin
          D2 := Pop;
          D1 := Pop;
          Push(Power(D1, D2));
        end else
        if Tok = 'ln' then
        begin
          Push(Ln(Pop));
        end else
        if Tok = 'log' then
        begin
          Push(Log10(Pop));
        end else
        if Tok = 'cvi' then
        begin
          Push(Round(Pop));
        end else
        if Tok = 'cvr' then
        begin
          Push(Pop);
        end else

        // Relational, Boolean and Bitwise Operators
        if Tok = 'eq' then
        begin
          D2 := Pop;
          D1 := Pop;
          if (D1 = D2) then Push(1) else Push(0);
        end else
        if Tok = 'ne' then
        begin
          D2 := Pop;
          D1 := Pop;
          if (D1 = D2) then Push(0) else Push(1);
        end else
        if Tok = 'gt' then
        begin
          D2 := Pop;
          D1 := Pop;
          if (D1 > D2) then Push(1) else Push(0);
        end else
        if Tok = 'ge' then
        begin
          D2 := Pop;
          D1 := Pop;
          if (D1 >= D2) then Push(1) else Push(0);
        end else
        if Tok = 'lt' then
        begin
          D2 := Pop;
          D1 := Pop;
          if (D1 < D2) then Push(1) else Push(0);
        end else
        if Tok = 'le' then
        begin
          D2 := Pop;
          D1 := Pop;
          if (D1 <= D2) then Push(1) else Push(0);
        end else
        if Tok = 'and' then
        begin
          I2 := PopI;
          I1 := PopI;
          Push(I1 and I2);
        end else
        if Tok = 'or' then
        begin
          I2 := PopI;
          I1 := PopI;
          Push(I1 or I2);
        end else
        if Tok = 'xor' then
        begin
          I2 := PopI;
          I1 := PopI;
          Push(I1 xor I2);
        end else
        if Tok = 'not' then
        begin
          Push(not PopI);
        end else
        if Tok = 'bitshift' then
        begin
          I2 := PopI;
          I1 := PopI;
          if I1 > 0 then
            Push(I1 shl I2)
          else
            Push(I1 shr I2);
        end else
        if Tok = 'true' then
        begin
          Push(1);
        end else
        if Tok = 'false' then
        begin
          Push(0);
        end else

        // Conditional operators
        if Tok = 'if' then
        begin
          I1 := PopI;
          if (I1 = 1) and (Length(Sub) > 0) then
            Insert(Sub[0], S, TokPos);
          MaxLen := Length(S);
          SetLength(Sub, 0);
        end else
        if Tok = 'ifelse' then
        begin
          I1 := PopI;
          if Length(Sub) > 1 then
          begin
            if (I1 = 1) then
              Insert(' ' + Sub[0], S, TokPos)
            else
              Insert(' ' + Sub[1], S, TokPos);
          end;
          MaxLen := Length(S);
          SetLength(Sub, 0);
        end else

        // Stack operators
        if Tok = 'pop' then
        begin
          Pop;
        end else
        if Tok = 'exch' then
        begin
          D2 := Pop;
          D1 := Pop;
          Push(D2);
          Push(D1);
        end else
        if Tok = 'dup' then
        begin
          Push(FStack[Length(FStack) - 1]);
        end else
        if Tok = 'copy' then
        begin
          I1 := PopI;
          TI := Length(FStack) - I1;
          for TX := 0 to I1 - 1 do
            Push(FStack[TI + TX]);
        end else
        if Tok = 'index' then
        begin
          I1 := PopI;
          Push(FStack[Length(FStack) - I1 - 1]);
        end else
        if Tok = 'roll' then
        begin
          I1 := PopI;
          I2 := PopI;
          if I1 > 0 then
          begin
            while I1 > 0 do
            begin
              D1 := FStack[Length(FStack) - 1];
              for TX := Length(FStack) - 1 downto Length(FStack) - I2 + 1 do
                FStack[TX] := FStack[TX - 1];
              FStack[Length(FStack) - I2] := D1;
              Dec(I1);              
            end;
          end else
          if I1 < 0 then
          begin
            while I1 < 0 do
            begin
              D1 := FStack[Length(FStack) - I2];
              for TX := Length(FStack) - I2 to Length(FStack) - 2 do
                FStack[TX] := FStack[TX + 1];
              FStack[Length(FStack) - 1] := D1;
              Inc(I1);
            end;
          end;
        end else
        begin
          Bad := Bad + Tok + ' ';
        end;
      end else
        Push(TazzToFloat(Tok));
    end;
  until Tok = '';

  SetLength(Y, FOutputValueCount);
  for J := 0 to FOutputValueCount - 1 do
    Y[FOutputValueCount - 1 - J] := Pop;

  // Range
  // (Required for type 0 and type 4 functions, optional otherwise; see below)
  // An array of 2 × n numbers, where n is the number of output values.
  // For each jfrom 0 to n - 1, Range2j must be less than or equal to Range2j+1 ,
  // and the jth output value, yj , must lie in the interval Range2j = yj = Range2j+1 .
  // Output values outside the declared range are clipped to the nearest boundary value.
  // If this entry is absent, no clipping is done.
  for J := 0 to FOutputValueCount - 1 do
    Y[J] := Math.Min(Math.Max(Y[J], FRange[2 * J]), FRange[2 * J + 1]);
end;

{ TPDFType3Function }

constructor TPDFType3Function.Create(Source: TPDFObject; OnFindObject: TPDFFindObjectEvent);
Var
  Obj: TPDFObject;
  TempA: TPDFArray;
  X: Integer;
begin
  inherited;
  FBounds := ReadArray('Bounds');

  SetLength(FBounds, Length(FBounds) + 1);
  FBounds[Length(FBounds) - 1] := 1;

  FEncode := ReadArray('Encode');
  if Length(FEncode) = 0 then
  begin
    SetLength(FEncode, 2);
    FEncode[0] := 0;
    FEncode[1] := 1;
  end;

  SetLength(FNArray, 0);
  Obj := FDict.FindValueByKeyName('Functions');
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
  if Obj is TPDFArray then
  begin
    TempA := TPDFArray(Obj);
    FSteps := 2;
    SetLength(FNArray, TempA.Count);
    for X := 0 to TempA.Count - 1 do
    begin
      Obj := TempA.Item[X];
      if Obj is TPDFIndRef then
        Obj := FindObject(TPDFIndRef(Obj));

      if Assigned(Obj) then
      begin
        FNArray[X] := TPDFFunction.FunctionFactory(Obj, FOnFindObject);
        Inc(FSteps, FNArray[X].Steps);
      end else
        FNArray[X] := nil;
    end;
  end;
end;

destructor TPDFType3Function.Destroy;
var
  I: Integer;
begin
  for I := 0 to Length(FNArray) - 1 do
  begin
    if Assigned(FNArray[I]) then
    begin
      FNArray[I].Free;
      FNArray[I] := nil;
    end;
  end;
  inherited Destroy;
end;

procedure TPDFType3Function.RunFunction(var X: TPDFDoubleArray; var Y: TPDFDoubleArray);
var
  LoBound: Double;
  UpBound: Double;
  I: Integer;
  X2: TPDFDoubleArray;

  function Interpolate(X, XMin, XMax, YMin, YMax: Double): Double; {$IFNDEF QPL_NOINLINE}inline;{$ENDIF}
  begin
    if ((XMax - XMin) = 0) then
    begin
      Result := YMin;
    end else
    begin
      Result := YMin + (YMax - YMin) * (X - XMin) / (XMax - XMin);
    end;
  end;

begin
  LoBound := FDomain[0];
  X2 := Copy(X, 0, Length(X));
  for I := 0 to Length(FNArray) - 1 do
  begin
    UpBound := FBounds[I];
    if (LoBound <= X2[0]) and (X2[0] <= UpBound) then
    begin
      X2[0] := Math.Min(Math.Max(X2[0], FDomain[0]), FDomain[1]);
      X2[0] := Interpolate(X2[0], LoBound, UpBound, FEncode[2 * I], FEncode[2 * I + 1]);
      FNArray[i].RunFunction(X2, Y);
      Break;
    end;
    LoBound := UpBound;
  end;
end;

end.
