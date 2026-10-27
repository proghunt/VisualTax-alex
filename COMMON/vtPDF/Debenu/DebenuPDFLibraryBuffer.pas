{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryBuffer.pas                             }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryBuffer;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, DebenuPDFLibraryTypes;

type
  TQPLBufferSource = (bsAnsiString, bsPointer, bsByteArray, bsStream);

  TQPLBuffer = class
  protected
    FPosition: Int64;
    FBufferLength: Int64;
    FSourceType: TQPLBufferSource;

    FAnsiStringSource: AnsiString;
    FByteArraySource: TQPLByteArray;
    FStreamSource: TStream;
    FPointerSource: Pointer;
    FPointerMax: Int64;
    FFreeStream: Boolean;

    procedure Reset;
    procedure SetPosition(NewPosition: Int64);
    procedure SetBufferLength(NewBufferLength: Int64);
  public
    constructor Create;
    destructor Destroy; override;

    procedure SetAnsiStringSource(const Source: AnsiString);
    procedure SetByteArraySource(ByteArray: TQPLByteArray);
    procedure SetStreamSource(Stream: TStream);
    procedure SetPointerSource(Data: Pointer; Length: Cardinal);
    procedure SetFileSource(const FileName: WideString);

    // Current position and length of the buffer
    property Position: Int64 read FPosition write SetPosition;
    property BufferLength: Int64 read FBufferLength write SetBufferLength;
    property SourceType: TQPLBufferSource read FSourceType;

    // Read data from the buffer starting at the current position
    // and then increment the position
    function ReadByte: Byte;
    function ReadInteger: Integer;
    function ReadWord: Word;
    function ReadCardinal: Cardinal;
    function ReadAnsiString(StringLength: Integer): AnsiString;
    function ReadByteArray(ByteCount: Integer): TQPLByteArray;

    // Peek functions
    function DistanceToByte(Value: Byte): Int64;
    function DistanceToOtherByte(Value: Byte): Int64;
    function DistanceToAnyByte(Values: TQPLByteArray): Int64;
    function DistanceToOtherBytes(Values: TQPLByteArray): Int64;
  end;

implementation

uses
  DebenuPDFLibraryExtra, SysUtils;

{ TQPLBuffer }

constructor TQPLBuffer.Create;
begin
  Reset;
end;

destructor TQPLBuffer.Destroy;
begin
  Reset;
  inherited;
end;

function TQPLBuffer.DistanceToAnyByte(Values: TQPLByteArray): Int64;
var
  Found: Boolean;
  TempBuffer: TQPLByteArray;
  BlockSize: Integer;
  TotalSkipped: Int64;
  TestPos: Integer;
  AnyPos: Integer;
begin
  Result := -1;
  Found := False;
  TotalSkipped := 0;
  BlockSize := 1024;
  SetLength(TempBuffer, 0);
   
  repeat
    TempBuffer := ReadByteArray(BlockSize);
    Dec(FPosition, Length(TempBuffer));
    TestPos := 0;
    while (not Found) and (TestPos < Length(TempBuffer)) do
    begin
      for AnyPos := 0 to Length(Values) - 1 do
      begin
        if TempBuffer[TestPos] = Values[AnyPos] then
        begin
          Found := True;
          Result := TotalSkipped + TestPos;
        end;
      end;
      Inc(TestPos);      
    end;
    if not Found then
    begin
      Inc(TotalSkipped, BlockSize);
      BlockSize := BlockSize * 2;
    end;
  until Found or (Length(TempBuffer) < BlockSize);
end;

function TQPLBuffer.DistanceToByte(Value: Byte): Int64;
var
  Found: Boolean;
  TempBuffer: TQPLByteArray;
  BlockSize: Integer;
  TotalSkipped: Int64;
  TestPos: Integer;
  TempPosition :Int64;
begin
  Result := -1;
  Found := False;
  TotalSkipped := 0;
  BlockSize := 1024;
  TempPosition := FPosition;
  repeat
    TempBuffer := ReadByteArray(BlockSize);
    TestPos := 0;
    while (not Found) and (TestPos < Length(TempBuffer)) do
    begin
      if TempBuffer[TestPos] = Value then
      begin
        Found := True;
        Result := TotalSkipped + TestPos;
      end;
      TestPos := TestPos + 1;
    end;
    if not Found then
    begin
      Inc(TotalSkipped, BlockSize);
    end;
  until Found or (Length(TempBuffer) < BlockSize);
  FPosition := TempPosition;
end;

function TQPLBuffer.DistanceToOtherByte(Value: Byte): Int64;
var
  Found: Boolean;
  TempBuffer: TQPLByteArray;
  BlockSize: Integer;
  TotalSkipped: Int64;
  TestPos: Integer;
  TempPosition :Int64;
begin
  Result := -1;
  Found := False;
  TotalSkipped := 0;
  BlockSize := 1024;
  TempPosition := FPosition;
  repeat
    TempBuffer := ReadByteArray(BlockSize);
    TestPos := 0;
    while (not Found) and (TestPos < Length(TempBuffer)) do
    begin
      if TempBuffer[TestPos] <> Value then
      begin
        Found := True;
        Result := TotalSkipped + TestPos;
      end;
      Inc(TestPos);
    end;
    if not Found then
    begin
      Inc(TotalSkipped, BlockSize);
    end;
  until Found or (Length(TempBuffer) < BlockSize);
  FPosition := TempPosition;
end;

function TQPLBuffer.DistanceToOtherBytes(Values: TQPLByteArray): Int64;
var
  Found: Boolean;
  TempBuffer: TQPLByteArray;
  BlockSize: Integer;
  TotalSkipped: Int64;
  TestPos: Integer;
  AnyPos: Integer;
  Match: Boolean;
  TempPosition :Int64;
begin
  Result := -1;
  Found := False;
  TotalSkipped := 0;
  BlockSize := 1024;
  TempPosition := FPosition;
  repeat
    TempBuffer := ReadByteArray(BlockSize);
    TestPos := 0;
    while (not Found) and (TestPos < Length(TempBuffer)) do
    begin
      Match := False;
      for AnyPos := 0 to Length(Values) - 1 do
      begin
        if TempBuffer[TestPos] = Values[AnyPos] then Match := True;
      end;

      if not Match then
      begin
        Found := True;
        Result := TotalSkipped + TestPos;
      end;
      Inc(TestPos);
    end;
    if not Found then
    begin
      Inc(TotalSkipped, BlockSize);
      BlockSize := BlockSize;
    end;
  until Found or (Length(TempBuffer) < BlockSize);
  FPosition := TempPosition;
end;

function TQPLBuffer.ReadAnsiString(StringLength: Integer): AnsiString;
var
  TempBuffer: TQPLByteArray;
begin
  SetLength(TempBuffer, 0);
  if StringLength < 0 then StringLength := 0;
  SetLength(Result, StringLength);
  if StringLength > 0 then
  begin
    TempBuffer := ReadByteArray(StringLength);
    if Length(TempBuffer) < Length(Result) then
      SetLength(Result, Length(TempBuffer));
    Move(TempBuffer[0], Result[1], Length(TempBuffer));
  end;
end;

function TQPLBuffer.ReadByte: Byte;
var
  TempBuffer: TQPLByteArray;
begin
  TempBuffer := ReadByteArray(1);
  if Length(TempBuffer) = 1 then
    Result := TempBuffer[0]
  else
    Result := 0;
end;

function TQPLBuffer.ReadByteArray(ByteCount: Integer): TQPLByteArray;
var
  BytesToRead: Int64;
  BytePointer: TQPLPByte;
begin
  BytesToRead := ByteCount;
  if (FPosition + BytesToRead) > FBufferLength then
  begin
    BytesToRead := FBufferLength - FPosition;
  end;
  if BytesToRead > 0 then
  begin
    SetLength(Result, BytesToRead);
    case FSourceType of
      bsAnsiString: Move(FAnsiStringSource[FPosition + 1], Result[0], BytesToRead);
      bsPointer:
      begin
        BytePointer := Pointer(TQPLIntPtr(FPointerSource) + FPosition);
        Move(BytePointer^, Result[0], BytesToRead);
      end;
      bsByteArray: Move(FByteArraySource[FPosition], Result[0], BytesToRead);
      bsStream:
      begin
        FStreamSource.Seek(FPosition, soBeginning);
        FStreamSource.Read(Result[0], BytesToRead);
      end;
    end;
    SetPosition(FPosition + BytesToRead);
  end else
  begin
    SetLength(Result, 0);
  end;
end;

function TQPLBuffer.ReadCardinal: Cardinal;
var
  TempBuffer: TQPLByteArray;
begin
  TempBuffer := ReadByteArray(4);
  if Length(TempBuffer) = 4 then
    Move(TempBuffer[0], Result, 4)
  else
    Result := 0;
end;

function TQPLBuffer.ReadInteger: Integer;
begin
  Result := Integer(ReadCardinal);
end;

function TQPLBuffer.ReadWord: Word;
var
  TempBuffer: TQPLByteArray;
begin
  TempBuffer := ReadByteArray(4);
  if Length(TempBuffer) = 2 then
    Move(TempBuffer[0], Result, 2)
  else
    Result := 0;
end;

procedure TQPLBuffer.Reset;
begin
  if FFreeStream then
  begin
    FStreamSource.Free;
  end;
  FSourceType := bsByteArray;
  FBufferLength := 0;
  FPosition := 0;
  SetLength(FByteArraySource, 0);
  SetLength(FAnsiStringSource, 0);
  FStreamSource := nil;
  FPointerSource := nil;
  FPointerMax := 0;
  FFreeStream := False;
end;

procedure TQPLBuffer.SetAnsiStringSource(const Source: AnsiString);
begin
  Reset;
  FSourceType := bsAnsiString;
  FBufferLength := Length(Source);
  FPosition := 0;
  FAnsiStringSource := Source;
end;

procedure TQPLBuffer.SetBufferLength(NewBufferLength: Int64);
begin
  if NewBufferLength >= 0 then
  begin
    case FSourceType of
      bsAnsiString:
      begin
        SetLength(FAnsiStringSource, NewBufferLength);
        FBufferLength := NewBufferLength;
      end;

      bsPointer:
      begin
        if NewBufferLength > FPointerMax then
          FBufferLength := FPointerMax
        else
          FBufferLength := NewBufferLength;
      end;

      bsByteArray:
      begin
        SetLength(FByteArraySource, NewBufferLength);
        FBufferLength := NewBufferLength;
      end;

      bsStream:
      begin
        FStreamSource.Size := NewBufferLength;
        FBufferLength := NewBufferLength;
      end;
    end;
  end;
end;

procedure TQPLBuffer.SetByteArraySource(ByteArray: TQPLByteArray);
begin
  Reset;
  FSourceType := bsByteArray;
  SetLength(FByteArraySource, Length(ByteArray));
  if Length(ByteArray) > 0 then
  begin
    Move(ByteArray[0], FByteArraySource[0], Length(ByteArray));
    FPosition := 0;
    FBufferLength := Length(ByteArray);
  end;
end;

procedure TQPLBuffer.SetFileSource(const FileName: WideString);
begin
  Reset;
  FSourceType := bsStream;
  FStreamSource := TQuickPDFWideFileStream.Create(FileName,
    fmOpenRead or fmShareDenyWrite);
  FPosition := 0;
  FBufferLength := FStreamSource.Size;
end;

procedure TQPLBuffer.SetPointerSource(Data: Pointer;
  Length: Cardinal);
begin
  Reset;
  FSourceType := bsPointer;
  FPointerSource := Data;
  FBufferLength := Length;
  FPointerMax := Length;
  FPosition := 0;
end;

procedure TQPLBuffer.SetPosition(NewPosition: Int64);
begin
  if ((NewPosition >= 0) and (NewPosition <= FBufferLength)) then
  begin
    FPosition := NewPosition;
  end;
end;

procedure TQPLBuffer.SetStreamSource(Stream: TStream);
begin
  Reset;
  FSourceType := bsStream;
  FStreamSource := Stream;
  FPosition := 0;
  FBufferLength := Stream.Size;
end;

end.
