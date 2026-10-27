{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryRebuild.pas                            }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryRebuild;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes, DebenuPDFLibraryTypes;

type
  TQPLRawAnalyser = class
  private
    FDebug: AnsiString;
    FObjectCount: Integer;
    FObjNumList: array of Integer;
    FGenNumList: array of Integer;
    FLocationList: array of Int64;
    FTrailer: AnsiString;
  public
    constructor Create;
    procedure LoadFromStream(Input: TStream);
    function GetObjNum(Index: Integer): Integer;
    function GetGenNum(Index: Integer): Integer;
    function GetLocation(Index: Integer): Int64;
    property Trailer: AnsiString read FTrailer;
    property Debug: AnsiString read FDebug;
    property ObjectCount: Integer read FObjectCount;
  end;

implementation

uses
  DebenuPDFLibraryExtra, DebenuPDFLibraryStructure;

{ TQPLRawAnalyser }

constructor TQPLRawAnalyser.Create;
begin

end;

function TQPLRawAnalyser.GetGenNum(Index: Integer): Integer;
begin
  if (Index >= 0) and (Index < FObjectCount) then
  begin
    Result := FGenNumList[Index];
  end else
  begin
    Result := 0;
  end;
end;

function TQPLRawAnalyser.GetLocation(Index: Integer): Int64;
begin
  if (Index >= 0) and (Index < FObjectCount) then
  begin
    Result := FLocationList[Index];
  end else
  begin
    Result := 0;
  end;
end;

function TQPLRawAnalyser.GetObjNum(Index: Integer): Integer;
begin
  if (Index >= 0) and (Index < FObjectCount) then
  begin
    Result := FObjNumList[Index];
  end else
  begin
    Result := 0;
  end;
end;

procedure TQPLRawAnalyser.LoadFromStream(Input: TStream);
var
  Buffer: TQPLByteArray;
  ReadSize: Integer;
  BlockPos: Int64;
  OPos: Integer;
  OPosList: array of Int64;
  OPosCount: Integer;
  OPosIndex: Integer;
  ObjCount: Integer;
  ValidToken: Boolean;
  ObjPos: Int64;
  ObjOffset: Integer;
  Match: Boolean;
  LastGen: Integer;
  FirstGen: Integer;
  LastObj: Integer;
  FirstObj: Integer;
  S: AnsiString;
  ObjNum: Integer;
  GenNum: Integer;
  TrailerPos: Int64;
begin
  SetLength(OPosList, 1024);
  OPosCount := 0;
  Input.Seek(0, soFromBeginning);
  SetLength(Buffer, 2048);
  repeat
    BlockPos := Input.Position;
    ReadSize := Input.Read(Buffer[0], 2048);
    if (ReadSize > 0) then
    begin
      for OPos := 0 to ReadSize - 1 do
      begin
        if (Buffer[OPos] = Ord('o')) then
        begin
          if (OPosCount = Length(OPosList)) then
          begin
            SetLength(OPosList, Length(OPosList) * 2);
          end;
          Inc(OPosCount);
          OPosList[OPosCount - 1] := BlockPos + OPos;
        end;
      end;
    end;
  until ReadSize < Length(Buffer);
  FDebug := QPLIntToStr(OPosCount) + ' "o" characters in the file'#13#10;

  SetLength(FObjNumList, OPosCount);
  SetLength(FGenNumList, OPosCount);
  SetLength(FLocationList, OPosCount);
  FObjectCount := 0;

  ObjCount := 0;
  for OPosIndex := 0 to OPosCount - 1 do
  begin
    ValidToken := False;
    ObjPos := OPosList[OPosIndex] - 47;
    ObjOffset := 0;
    ReadSize := 50;
    if (ObjPos < 0) then
    begin
      ReadSize := OPosList[OPosIndex] + 3;
      ObjPos := 0;
    end;
    Input.Seek(ObjPos, soBeginning);
    if (Input.Read(Buffer[ObjOffset], ReadSize) = ReadSize) then
    begin
      if ((Buffer[ReadSize - 2] = Ord('b')) and (Buffer[ReadSize - 1] = Ord('j'))) then
      begin
        BlockPos := ReadSize - 4;
        if ((Buffer[BlockPos] = 32) or (Buffer[BlockPos] = 10) or
            (Buffer[BlockPos] = 13) or (Buffer[BlockPos] = 9) or
            (Buffer[BlockPos] = 12) or (Buffer[BlockPos] = 0)) then
        begin
          repeat
            Dec(BlockPos);
            Match := (Buffer[BlockPos] = 32) or (Buffer[BlockPos] = 10) or
              (Buffer[BlockPos] = 13) or (Buffer[BlockPos] = 9) or
              (Buffer[BlockPos] = 12) or (Buffer[BlockPos] = 0);
          until (not Match) or (BlockPos = 0);
          if ((BlockPos > 0) and (Buffer[BlockPos] >= Ord('0')) and (Buffer[BlockPos] <= Ord('9'))) then
          begin
            LastGen := BlockPos;
            repeat
              Dec(BlockPos);
              Match := ((Buffer[BlockPos] >= Ord('0')) and (Buffer[BlockPos] <= Ord('9')));
            until (not Match) or (BlockPos = 0);
            if ((Buffer[BlockPos] = 32) or (Buffer[BlockPos] = 10) or
                (Buffer[BlockPos] = 13) or (Buffer[BlockPos] = 9) or
                (Buffer[BlockPos] = 12) or (Buffer[BlockPos] = 0)) then
            begin
              FirstGen := BlockPos + 1;
              repeat
                Dec(BlockPos);
                Match := (Buffer[BlockPos] = 32) or (Buffer[BlockPos] = 10) or
                  (Buffer[BlockPos] = 13) or (Buffer[BlockPos] = 9) or
                  (Buffer[BlockPos] = 12) or (Buffer[BlockPos] = 0);
              until (not Match) or (BlockPos = 0);
              if ((BlockPos > 0) and (Buffer[BlockPos] >= Ord('0')) and (Buffer[BlockPos] <= Ord('9'))) then
              begin
                LastObj := BlockPos;
                repeat
                  Dec(BlockPos);
                  Match := ((Buffer[BlockPos] >= Ord('0')) and (Buffer[BlockPos] <= Ord('9')));
                until (not Match) or (BlockPos = 0);
                if ((Buffer[BlockPos] = 32) or (Buffer[BlockPos] = 10) or
                    (Buffer[BlockPos] = 13) or (Buffer[BlockPos] = 9) or
                    (Buffer[BlockPos] = 12) or (Buffer[BlockPos] = 0)) then
                begin
                  FirstObj := BlockPos + 1;
                  SetLength(S, LastObj - FirstObj + 1);
                  Move(Buffer[FirstObj], S[1], Length(S));
                  ObjNum := QPLStrToIntDef(S, -1);
                  SetLength(S, LastGen - FirstGen + 1);
                  Move(Buffer[FirstGen], S[1], Length(S));
                  GenNum := QPLStrToIntDef(S, -1);

                  FObjNumList[FObjectCount] := ObjNum;
                  FGenNumList[FObjectCount] := GenNum;
                  FLocationList[FObjectCount] := ObjPos + FirstObj;
                  Inc(FObjectCount);

                  FDebug := FDebug + 'Object (' + QPLIntToStr(ObjNum) + ' ' +
                    QPLIntToStr(GenNum) + ' obj) found at ' + QPLIntToStr(ObjPos + FirstObj) + #13#10;

{                  Structure := TPDFStructure.Create;
                  try
                    //Structure.DecodeWithLength()
                  finally
                    Structure.Free;
                  end;}

                  Inc(ObjCount);
                  ValidToken := True;
                  OPosList[OPosIndex] := ObjPos + FirstObj;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    if (not ValidToken) then
    begin
      OPosList[OPosIndex] := 0;
    end;
  end;

  TrailerPos := Input.Size;
  repeat
    Dec(TrailerPos);
    Input.Seek(TrailerPos, soBeginning);
    SetLength(FTrailer, 7);
    SetLength(FTrailer, Input.Read(FTrailer[1], 7));
    if (FTrailer <> 'trailer') then
    begin
      FTrailer := '';
    end;
  until (FTrailer <> '') or (TrailerPos = 0);
  if (FTrailer = 'trailer') then
  begin
    repeat
      Inc(TrailerPos);
      Input.Seek(TrailerPos, soBeginning);
      SetLength(FTrailer, 2);
      SetLength(FTrailer, Input.Read(FTrailer[1], 2));
      if (FTrailer <> '<<') then
      begin
        FTrailer := '';
      end;
    until (FTrailer <> '') or (TrailerPos >= (Input.Size - 2));
    if (FTrailer = '<<') then
    begin
      Input.Seek(TrailerPos, soBeginning);
      SetLength(FTrailer, 2048);
      SetLength(FTrailer, Input.Read(FTrailer[1], 2048));
      if (QPLPos('>>', FTrailer) > 0) then
      begin
        Delete(FTrailer, QPLPos('>>', FTrailer) + 2, MaxInt);
      end else
      begin
        FTrailer := '';
      end;
    end;
  end;

  FDebug := FDebug + QPLIntToStr(ObjCount) + ' "obj" tokens in the file'#13#10;
end;

end.
