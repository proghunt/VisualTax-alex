{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryLZW.pas                                }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryLZW;

{$I DebenuPDFLibraryDefines.inc}

interface

type
  TPDFLZWFillOrder = (foBottom, foTop);

  TPDFLZWParms = record
    Predictor: Integer;
    Colors: Integer;
    BitsPerComponent: Integer;
    Columns: Integer;
    ExpandedTo8Bit: Boolean;
    ColorSpace: AnsiString;
  end;

  TPDFLZWDecompressor = class
  private
    FFillOrder: TPDFLZWFillOrder;
    FEarlyChange: Boolean;
    FInitialCodeSize: Cardinal;
    FCodeSize: Cardinal;
    FInput: AnsiString;
    FInputPos: Cardinal;
    FBitPos: Cardinal;
    FBitMask: Cardinal;
    FInputLen: Cardinal;
    FEOICode: Cardinal;
    FClearCode: Cardinal;
    FNextCode: Cardinal;
    FOutput: AnsiString;
    FOutputLen: Integer;
    FDictionary: array[0..4095] of AnsiString;
    FChangeCode: Cardinal;
    procedure Initialize;
    function GetNextCode: Cardinal;
    function GetNextCodeBottom: Cardinal;
    function GetNextCodeTop: Cardinal;
    procedure Output(const S: AnsiString);
  public
    constructor Create;
    function Decompress(const Input: AnsiString): AnsiString; overload;
    function Decompress(const Input: AnsiString; Parms: TPDFLZWParms): AnsiString; overload;
    property FillOrder: TPDFLZWFillOrder read FFillOrder write FFillOrder;
    property EarlyChange: Boolean read FEarlyChange write FEarlyChange;
    property InitialCodeSize: Cardinal read FInitialCodeSize write FInitialCodeSize;
  end;

implementation

uses
  Classes, DebenuPDFLibraryExtra;

{ TPDFLZWDecompressor }

constructor TPDFLZWDecompressor.Create;
begin
  inherited Create;
  FFillOrder := foTop;
  FEarlyChange := False;
  FInitialCodeSize := 9;
end;

function TPDFLZWDecompressor.GetNextCode: Cardinal;
begin
  if FFillOrder = foBottom then
    Result := GetNextCodeBottom
  else
    Result := GetNextCodeTop;
end;

function TPDFLZWDecompressor.GetNextCodeBottom: Cardinal;
begin
  if FInputPos < FInputLen then
  begin
    Result := ((Ord(FInput[FInputPos]) + Ord(FInput[FInputPos + 1]) shl 8 +
      Ord(FInput[FInputPos + 2]) shl 16) shr FBitPos) and FBitMask;
    Inc(FBitPos, FCodeSize);
    while FBitPos > 7 do
    begin
      Inc(FInputPos);
      Dec(FBitPos, 8);
    end;
  end else
    Result := FEOICode;
end;

function TPDFLZWDecompressor.GetNextCodeTop: Cardinal;
begin
  if FInputPos < (FInputLen - 1) then
  begin
    Result := Ord(FInput[FInputPos]) shl 16 + Ord(FInput[FInputPos + 1]) shl 8 +
      Ord(FInput[FInputPos + 2]);
    Result := Result shr (24 - FBitPos - FCodeSize);
    Result := Result and FBitMask;
    Inc(FBitPos, FCodeSize);
    while FBitPos > 7 do
    begin
      Inc(FInputPos);
      Dec(FBitPos, 8);
    end;
  end else
    Result := FEOICode;
end;

procedure TPDFLZWDecompressor.Output(const S: AnsiString);
begin
  if Length(S) > 0 then
  begin
    if FOutputLen + Length(S) > Length(FOutput) then
      SetLength(FOutput, Length(FOutput) + 4096);
    Move(S[1], FOutput[FOutputLen + 1], Length(S));
    Inc(FOutputLen, Length(S));
  end;
end;

function TPDFLZWDecompressor.Decompress(const Input: AnsiString): AnsiString;
var
  Parms: TPDFLZWParms;
begin
  Parms.Predictor := 0;
  Result := Decompress(Input, Parms);
end;

function TPDFLZWDecompressor.Decompress(const Input: AnsiString; Parms: TPDFLZWParms): AnsiString;
var
  Code: Cardinal;
  LastCode: Cardinal;
  NewString: AnsiString;
//  PredRows: Integer;
  I: Integer;
  J: Integer;
  H: Integer;
  Count: Integer;
begin
  FInput := Input + #0#0#0;
  Initialize;

  Code := GetNextCode;
  if Code = FClearCode then
    Code := GetNextCode;
  if Code <> FEOICode then Output(FDictionary[Code]);
  LastCode := Code;
  repeat
    Code := GetNextCode;
    if Code = FClearCode then
    begin
      FCodeSize := FInitialCodeSize;
      FBitMask := (1 shl FCodeSize) - 1;
      FNextCode := FClearCode + 1;
      if FEarlyChange then FChangeCode := FBitMask - 1 else
        FChangeCode := FBitMask;
    end else
    if Code <> FEOICode then
    begin
      if Code < FNextCode then
      begin
        Output(FDictionary[Code]);
        if Length(FDictionary[Code]) > 0 then
          FDictionary[FNextCode] := FDictionary[LastCode] + FDictionary[Code][1];
        if (FNextCode = FChangeCode) and (FCodeSize < 12) then
        begin
          Inc(FCodeSize);
          FBitMask := (1 shl FCodeSize) - 1;
          if FEarlyChange then FChangeCode := FBitMask - 1 else
            FChangeCode := FBitMask;
        end;
        if FNextCode < 4095 then Inc(FNextCode);
        LastCode := Code;
      end else
      begin
        NewString := FDictionary[LastCode];
        if Length(NewString) > 0 then
          NewString := NewString + NewString[1];
        Output(NewString);
        FDictionary[FNextCode] := NewString;
        if (FNextCode = FChangeCode) and (FCodeSize < 12) then
        begin
          Inc(FCodeSize);
          FBitMask := (1 shl FCodeSize) - 1;
          if FEarlyChange then FChangeCode := FBitMask - 1 else
            FChangeCode := FBitMask;
        end;
        if FNextCode < 4095 then Inc(FNextCode);
        LastCode := Code;
      end;
    end;
  until Code = FEOICode;
  Result := QPLCopy(FOutput, 1, FOutputLen);

  // Horizontal Differencing Predictor
  if (Parms.Predictor = 2) then
  begin
    H := Length(Result) div Parms.Columns div Parms.Colors;

    for J := 0 to H - 1 do
    begin
      Count := Parms.Colors * (J * Parms.Columns + 1);
      for I := Parms.Colors to Parms.Columns * Parms.Colors - 1 do
      begin
        Result[Count + 1] := AnsiChar(Ord(Result[Count + 1]) +
          Ord(Result[Count + 1 - Parms.Colors]));
        Inc(Count);
      end;
    end;
  end;
end;

procedure TPDFLZWDecompressor.Initialize;
var
  X: Cardinal;
begin
  SetLength(FOutput, 4096);
  FOutputLen := 0;
  FInputLen := Length(FInput);
  FInputPos := 1;
  FBitPos := 0;
  FCodeSize := FInitialCodeSize;
  FBitMask := (1 shl FCodeSize) - 1;
  if FEarlyChange then FChangeCode := FBitMask - 1 else
    FChangeCode := FBitMask;
  FClearCode := 1 shl (FCodeSize - 1);
  FEOICode := FClearCode + 1;
  FNextCode := FClearCode + 2;
  for X := 0 to FNextCode - 1 do
    FDictionary[X] := AnsiChar(X);
end;

end.
