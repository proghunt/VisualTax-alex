{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryFlate.pas                              }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryFlate;

{$I DebenuPDFLibraryDefines.inc}

{$IFDEF QPL_OS_MAC}
  {$UNDEF QPL_NOVCL}
{$ENDIF}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils, Classes;

type
  TPDFFlateParms = record
    Predictor: Integer;
    Colors: Integer;
    BitsPerComponent: Integer;
    Columns: Integer;
    ExpandedTo8Bit: Boolean;
    ColorSpace: AnsiString;
  end;

function DeflateStrNoCompression(const Input: AnsiString): AnsiString;
function DeflateStr(const Input: AnsiString): AnsiString;
function InflateStr(const Input: AnsiString): AnsiString;
function InflateStrParms(const Input: AnsiString; var Parms: TPDFFlateParms): AnsiString;

const
  DeflateDefaultCompressionLevel: Integer = 0;

implementation

{$IFDEF QPL_NOVCL}
function DeflateStrNoCompression(const Input: AnsiString): AnsiString;
begin
  Result := '';
end;

function DeflateStr(const Input: AnsiString): AnsiString;
begin
  Result := '';
end;

function InflateStr(const Input: AnsiString): AnsiString;
begin
  Result := '';
end;

function InflateStrParms(const Input: AnsiString; var Parms: TPDFFlateParms): AnsiString;
begin
  Result := '';
end;
{$ELSE}

uses
{$IFDEF WIN64}
  System.ZLib,
{$ENDIF}
  Math, DebenuPDFLibraryPNG, DebenuPDFLibraryTypes;

{$IFNDEF WIN64}
const
  ZLIB_VERSION: AnsiString = '1.2.5';

type
  TZAlloc = function(opaque: Pointer; items, size: Integer): Pointer;
  TZFree = procedure(opaque, block: Pointer);
  TZCompressionLevel = (zcNone, zcFastest, zcDefault, zcMax);

  TZStreamRec = packed record
    next_in: PAnsiChar;
    avail_in: Longint;
    total_in: Longint;
    next_out: PAnsiChar;
    avail_out: Longint;
    total_out: Longint;
    msg: PAnsiChar;
    state: Pointer;
    zalloc: TZAlloc;
    zfree: TZFree;
    opaque: Pointer;
    data_type: Integer;
    adler: Longint;
    reserved: Longint;
  end;

const
  Z_NO_FLUSH = 0;
  Z_PARTIAL_FLUSH = 1;
  Z_SYNC_FLUSH = 2;
  Z_FULL_FLUSH = 3;
  Z_FINISH = 4;

  Z_OK = 0;
  Z_STREAM_END = 1;
  Z_NEED_DICT = 2;
  Z_ERRNO = (-1);
  Z_STREAM_ERROR = (-2);
  Z_DATA_ERROR = (-3);
  Z_MEM_ERROR = (-4);
  Z_BUF_ERROR = (-5);
  Z_VERSION_ERROR = (-6);

  Z_NO_COMPRESSION = 0;
  Z_BEST_SPEED = 1;
  Z_BEST_COMPRESSION = 9;
  Z_DEFAULT_COMPRESSION = (-1);

  Z_FILTERED = 1;
  Z_HUFFMAN_ONLY = 2;
  Z_DEFAULT_STRATEGY = 0;

  Z_BINARY = 0;
  Z_ASCII = 1;
  Z_UNKNOWN = 2;

  Z_DEFLATED = 8;

  ZLevels: array[TZCompressionLevel] of Shortint = (Z_NO_COMPRESSION,
    Z_BEST_SPEED, Z_DEFAULT_COMPRESSION, Z_BEST_COMPRESSION);

{$L obj\adler32.obj}
{$L obj\deflate.obj}
{$L obj\infback.obj}
{$L obj\inffast.obj}
{$L obj\inflate.obj}
{$L obj\inftrees.obj}
{$L obj\trees.obj}
{$L obj\compress.obj}
{$L obj\crc32.obj}

function adler32(adler: LongInt; const buf: PAnsiChar; len: Integer): LongInt; cdecl; external;

procedure _memcpy(dest, source: Pointer; count: Integer); cdecl;
begin
  if (count > 0) then
    Move(source^, dest^, count);
end;

procedure _memset(p: Pointer; b: Byte; count: Integer); cdecl;
begin
  FillChar(p^, count, b);
end;

const
  _z_errmsg: array[0..9] of PChar = ('', '', '', '', '', '', '', '', '', '');

function zcalloc(opaque: Pointer; items, size: Integer): Pointer;
begin
  GetMem(result, items * size);
end;

procedure zcfree(opaque, block: Pointer);
begin
  FreeMem(block);
end;

{$IFDEF QPL_OS_MAC}
function _deflateInit_(var strm: TZStreamRec; level: Integer; version: PAnsiChar; recsize: Integer): Integer; cdecl; external '/usr/lib/libz.dylib';
function _DeflateInit2_(var strm: TZStreamRec; level: Integer; method: Integer; windowBits: Integer; memLevel: Integer; strategy: Integer; version: PAnsiChar; recsize: Integer): Integer; cdecl; external '/usr/lib/libz.dylib';
function _deflate(var strm: TZStreamRec; flush: Integer): Integer; cdecl; external '/usr/lib/libz.dylib';
function _deflateEnd(var strm: TZStreamRec): Integer; cdecl; external '/usr/lib/libz.dylib';
function _inflateInit_(var strm: TZStreamRec; version: PAnsiChar; recsize: Integer): Integer; cdecl; external '/usr/lib/libz.dylib';
function _inflate(var strm: TZStreamRec; flush: Integer): Integer; cdecl; external '/usr/lib/libz.dylib';
function _inflateEnd(var strm: TZStreamRec): Integer; cdecl; external '/usr/lib/libz.dylib';
function deflateInit_(var strm: TZStreamRec; level: Integer; version: PAnsiChar; recsize: Integer): Integer; external;
function DeflateInit2_(var strm: TZStreamRec; level: Integer; method: Integer; windowBits: Integer; memLevel: Integer; strategy: Integer; version: PAnsiChar; recsize: Integer): Integer; external;
function deflate(var strm: TZStreamRec; flush: Integer): Integer; external;
function deflateEnd(var strm: TZStreamRec): Integer; external;
{$ENDIF}

{$IFNDEF QPL_OS_MAC}
function deflateInit_(var strm: TZStreamRec; level: Integer; version: PAnsiChar; recsize: Integer): Integer; external;
function DeflateInit2_(var strm: TZStreamRec; level: Integer; method: Integer; windowBits: Integer; memLevel: Integer; strategy: Integer; version: PAnsiChar; recsize: Integer): Integer; external;
function deflate(var strm: TZStreamRec; flush: Integer): Integer; external;
function deflateEnd(var strm: TZStreamRec): Integer; external;
function inflateInit_(var strm: TZStreamRec; version: PAnsiChar; recsize: Integer): Integer; external;
function inflate(var strm: TZStreamRec; flush: Integer): Integer; external;
function inflateEnd(var strm: TZStreamRec): Integer; external;
{$ENDIF}

function ZCompressCheck(code: Integer): Integer;
begin
  result := code;

  if code < 0 then
  begin
    raise Exception.Create('');
  end;
end;

function ZCompressCheckBool(code: Integer): Boolean;
begin
  Result := code >= 0;
end;

function DeflateInit(var stream: TZStreamRec; level: Integer): Integer;
begin
{$IFDEF QPL_OS_MAC}
  result := _DeflateInit_(stream, level, PAnsiChar(ZLIB_VERSION), SizeOf(TZStreamRec));
{$ELSE}
  result := DeflateInit_(stream, level, PAnsiChar(ZLIB_VERSION), SizeOf(TZStreamRec));
{$ENDIF}
end;

procedure ZInternalCompress(var zstream: TZStreamRec; const inBuffer: Pointer;
  inSize: Integer; out outBuffer: Pointer; out outSize: Integer);
const
  delta = 256;
var
  zresult: Integer;
begin
  outSize := ((inSize + (inSize div 10) + 12) + 255) and not 255;

  outBuffer := Nil;

  try
    try
      zstream.next_in := inBuffer;
      zstream.avail_in := inSize;

      repeat
        ReallocMem(outBuffer, outSize);

        zstream.next_out := Pointer(TQPLIntPtr(outBuffer) + zstream.total_out);
        zstream.avail_out := outSize - zstream.total_out;

{$IFDEF QPL_OS_MAC}
        zresult := ZCompressCheck(_Deflate(zstream, Z_NO_FLUSH));
{$ELSE}
        zresult := ZCompressCheck(Deflate(zstream, Z_NO_FLUSH));
{$ENDIF}

        if (zstream.avail_out = 0) or (zresult = Z_BUF_ERROR) then
          Inc(outSize, delta);

      until (zresult = Z_STREAM_END) or (zstream.avail_in = 0);

      while zresult <> Z_STREAM_END do
      begin
        if (zstream.avail_out = 0) or (zresult = Z_BUF_ERROR) then              // ADC
        begin
          ReallocMem(outBuffer, outSize);

          zstream.next_out := Pointer(TQPLIntPtr(outBuffer) + zstream.total_out);
          zstream.avail_out := outSize - zstream.total_out;
        end;

{$IFDEF QPL_OS_MAC}
        zresult := ZCompressCheck(_Deflate(zstream, Z_FINISH));
{$ELSE}
        zresult := ZCompressCheck(Deflate(zstream, Z_FINISH));
{$ENDIF}

        Inc(outSize, delta);
      end;
    finally
{$IFDEF QPL_OS_MAC}
      ZCompressCheck(_DeflateEnd(zstream));
{$ELSE}
      ZCompressCheck(DeflateEnd(zstream));
{$ENDIF}
    end;

    ReallocMem(outBuffer, zstream.total_out);

    outSize := zstream.total_out;
  except
    FreeMem(outBuffer);
    raise;
  end;
end;

procedure ZCompress(const inBuffer: Pointer; inSize: Integer;
  out outBuffer: Pointer; out outSize: Integer;
  level: TZCompressionLevel);
var
  zstream: TZStreamRec;
  compressionLevel : integer;
begin
  FillChar(zstream, SizeOf(TZStreamRec), 0);
  outSize := 0;

  if level = zcDefault then
    compressionLevel := DeflateDefaultCompressionLevel - 1
  else
    compressionLevel := ZLevels[level];

  outBuffer := nil;
  if (ZCompressCheckBool(DeflateInit(zstream, compressionLevel))) then
  begin
    ZInternalCompress(zstream, inBuffer, inSize, outBuffer, outSize);
  end;
end;

function ZCompressStr(const s: AnsiString; level: TZCompressionLevel): AnsiString;
var
  buffer: Pointer;
  size: Integer;
begin
  ZCompress(PAnsiChar(s), Length(s), buffer, size, level);
  if (size > 0) then
  begin
    SetLength(result, size);
    Move(buffer^, Pointer(result)^, size);
    FreeMem(buffer);
  end else
  begin
    SetLength(result, 0);
  end;
end;

function InflateInit(var stream: TZStreamRec): Integer;
begin  
{$IFDEF QPL_OS_MAC}
  result := _InflateInit_(stream, PAnsiChar(ZLIB_VERSION), SizeOf(TZStreamRec));
{$ELSE}
  result := InflateInit_(stream, PAnsiChar(ZLIB_VERSION), SizeOf(TZStreamRec));
{$ENDIF}
end;

function ZDecompressCheck(code: Integer): Integer;
begin
  Result := code;

  if code < 0 then
  begin
    raise Exception.Create('');
  end;
end;

function ZDecompressCheckIgnoreDataErrorOrBufferError(code: Integer): Integer;
begin
  Result := code;

  if ((code < 0) and (code <> Z_DATA_ERROR) and (code <> Z_BUF_ERROR)) then
  begin
    raise Exception.Create('');
  end;
end;

procedure ZInternalDecompress(zstream: TZStreamRec; const inBuffer: Pointer;
  inSize: Integer; out outBuffer: Pointer; out outSize: Integer;
  outEstimate: Integer);
var
  zresult: Integer;
  delta: Integer;
begin
  delta := (inSize + 255) and not 255;
  if delta < 8192 then
    delta := 8192;

  if outEstimate = 0 then outSize := delta
  else outSize := outEstimate;

  outBuffer := Nil;

  try
    try
      zresult := Z_OK;

      zstream.avail_in := inSize;
      zstream.next_in := inBuffer;

      while (zresult <> Z_STREAM_END) and (zresult <> Z_NEED_DICT) and (zresult <> Z_DATA_ERROR) and (zstream.avail_in > 0) do
      begin
        repeat
          ReallocMem(outBuffer, outSize);

          zstream.next_out := Pointer(TQPLIntPtr(outBuffer) + zstream.total_out);
          zstream.avail_out := outSize - zstream.total_out;

{$IFDEF QPL_OS_MAC}
          zresult := ZDecompressCheckIgnoreDataErrorOrBufferError(_Inflate(zstream, Z_NO_FLUSH));
{$ELSE}
          zresult := ZDecompressCheckIgnoreDataErrorOrBufferError(Inflate(zstream, Z_NO_FLUSH));
{$ENDIF}

          Inc(outSize, delta);
        until (zresult = Z_STREAM_END) or (zresult = Z_DATA_ERROR) or(zresult = Z_NEED_DICT) or (zstream.avail_out > 0) and (zresult <> Z_BUF_ERROR)
      end;
    finally
{$IFDEF QPL_OS_MAC}
      ZDecompressCheck(_InflateEnd(zstream));
{$ELSE}
      ZDecompressCheck(InflateEnd(zstream));
{$ENDIF}
    end;

    ReallocMem(outBuffer, zstream.total_out);

    outSize := zstream.total_out;
  except
    if Assigned(outBuffer) then FreeMem(outBuffer);

    raise;
  end;
end;

procedure ZDecompress(const inBuffer: Pointer; inSize: Integer;
  out outBuffer: Pointer; out outSize: Integer; outEstimate: Integer = 0);
var
  zstream: TZStreamRec;
begin
  FillChar(zstream, SizeOf(TZStreamRec), 0);

  ZDecompressCheck(InflateInit(zstream));

  ZInternalDecompress(zstream, inBuffer, inSize, outBuffer, outSize,
    outEstimate);
end;

function ZDecompressStr(const s: AnsiString): AnsiString;
var
  buffer: Pointer;
  size: Integer;
begin
  ZDecompress(PAnsiChar(s), Length(s), buffer, size);
  SetLength(result, size);
  if (size > 0) then
    Move(buffer^, Pointer(result)^, size);
  FreeMem(buffer);
end;

function DeflateStrNoCompression(const Input: AnsiString): AnsiString;
type
  AnsiCharArr4 = array [0..3] of AnsiChar;
  PAnsiCharArr4 = ^AnsiCharArr4;
const
  FINAL_BLOCK_HEADER = #$78#$01;
  //BLOCK_HEADER = ...
  CHUNK_SIZE = 65535; // If we need to process more than one chunk than we will use ZLib. Otherwise we use a slightly faster option.
var
  strlen : Cardinal;
  chunklen, chunknlen : Word;
  adler : LongInt;
  PACharAAdler : PAnsiCharArr4;
begin
  try
    strlen := Length(Input);
    if strlen > CHUNK_SIZE then
      Result := ZCompressStr(Input, zcNone)
    else
      //:MM: By bypassing ZLib we decrease processing time by 10% - at least on the test system.
      if strlen > 0 then
      begin
        //SetLength(Result, strlen + (2 + 5 * strlen div CHUNK_SIZE) + 4 {Adler32} );
        chunklen := Length(Input);
        chunknlen := not(chunklen);
        //adler := 1; adler32(adler, nil, 0);
        adler := adler32(1, @Input[1], strlen);
        PACharAAdler := PAnsiCharArr4(@adler);

        Result := FINAL_BLOCK_HEADER + #01 +
                    AnsiString(AnsiChar(chunklen and $FF)) +
                    AnsiString(AnsiChar(chunklen shr 8 and $FF)) +
                    AnsiString(AnsiChar(chunknlen and $FF)) +
                    AnsiString(AnsiChar(chunknlen shr 8 and $FF)) +
                    Input +
                    PACharAAdler^[3] +
                    PACharAAdler^[2] +
                    PACharAAdler^[1] +
                    PACharAAdler^[0];
      end else
        Result := '';
  except
    Result := '';
  end;
end;

function DeflateStr(const Input: AnsiString): AnsiString;
begin
  try
    if Input <> '' then
    begin
      Result := ZCompressStr(Input, zcDefault);
    end else
      Result := '';
  except
    Result := '';
  end;
end;

function InflateStr(const Input: AnsiString): AnsiString;
begin
  try
    if Input <> '' then
    begin
      Result := ZDecompressStr(Input);
    end else
      Result := '';
  except
    Result := '';
  end;
end;
{$ELSE}
function DeflateStrNoCompression(const Input: AnsiString): AnsiString;
var
  InStream: TMemoryStream;
  OutStream: TMemoryStream;
begin
  try
    if Input <> '' then
    begin
      OutStream := TMemoryStream.Create;
      try
        InStream := TMemoryStream.Create;
        InStream.Write(Input[1], Length(Input));
        InStream.Seek(0, soFromBeginning);

        ZCompressStream(InStream, OutStream, zcNone);
        InStream.Free;
        SetLength(Result, OutStream.Size);
        if (OutStream.Size > 0) then
        begin
          OutStream.Seek(0, soFromBeginning);
          OutStream.Read(Result[1], Length(Result));
        end;
      finally
        OutStream.Free;
      end;
    end else
      Result := '';
  except
    Result := '';
  end;
end;

function DeflateStr(const Input: AnsiString): AnsiString;
var
  InStream: TMemoryStream;
  OutStream: TMemoryStream;
begin
  try
    if Input <> '' then
    begin
      OutStream := TMemoryStream.Create;
      try
        InStream := TMemoryStream.Create;
        InStream.Write(Input[1], Length(Input));
        InStream.Seek(0, soFromBeginning);
        ZCompressStream(InStream, OutStream, zcDefault);
        InStream.Free;
        SetLength(Result, OutStream.Size);
        if (OutStream.Size > 0) then
        begin
          OutStream.Seek(0, soFromBeginning);
          OutStream.Read(Result[1], Length(Result));
        end;
      finally
        OutStream.Free;
      end;
    end else
      Result := '';
  except
    Result := '';
  end;
end;

function QPLZCompressCheck(code: Integer): Integer;
begin
  result := code;

  if code < 0 then
  begin
    raise EZCompressionError.Create(string(_z_errmsg[2 - code]));
  end;
end;

function QPLZCompressCheckIgnoreDataErrorOrBufferError(code: Integer): Integer;
begin
  result := code;

  if ((code < 0) and (code <> Z_DATA_ERROR) and (code <> Z_BUF_ERROR)) then
  begin
    raise EZCompressionError.Create(string(_z_errmsg[2 - code]));
  end;
end;

procedure QPLZDecompressStream(inStream, outStream: TStream);
const
  bufferSize = 32768;
var
  zstream: TZStreamRec;
  zresult: Integer;
  inBuffer: array[0..bufferSize - 1] of Byte;
  outBuffer: array[0..bufferSize - 1] of Byte;
  inSize: Integer;
  outSize: Integer;
begin
  FillChar(zstream, SizeOf(TZStreamRec), 0);

  QPLZCompressCheck(InflateInit(zstream));

  inSize := inStream.Read(inBuffer, bufferSize);

  while inSize > 0 do
  begin
    zstream.next_in := @inBuffer;
    zstream.avail_in := inSize;

    repeat
      zstream.next_out := @outBuffer;
      zstream.avail_out := bufferSize;

{$IFDEF QPL_OS_MAC}
      zresult := QPLZCompressCheckIgnoreDataErrorOrBufferError(_Inflate(zstream, Z_NO_FLUSH));
{$ELSE}
      zresult := QPLZCompressCheckIgnoreDataErrorOrBufferError(Inflate(zstream, Z_NO_FLUSH));
{$ENDIF}

      // outSize := zstream.next_out - outBuffer;
      outSize := bufferSize - zstream.avail_out;

      outStream.Write(outBuffer, outSize);
    until (zresult = Z_STREAM_END) or (zresult = Z_DATA_ERROR) or (zstream.avail_in = 0) and (zstream.avail_out > 0);   // ADC

    inSize := inStream.Read(inBuffer, bufferSize);
  end;

  repeat
    zstream.next_out := @outBuffer;
    zstream.avail_out := bufferSize;

{$IFDEF QPL_OS_MAC}
    //zresult := QPLZCompressCheck(_Inflate(zstream, Z_FINISH));
    zresult := QPLZCompressCheckIgnoreDataErrorOrBufferError(_Inflate(zstream, Z_FINISH));
{$ELSE}
    //zresult := QPLZCompressCheck(Inflate(zstream, Z_FINISH));
    zresult := QPLZCompressCheckIgnoreDataErrorOrBufferError(Inflate(zstream, Z_FINISH));
{$ENDIF}

    // outSize := zstream.next_out - outBuffer;
    outSize := bufferSize - zstream.avail_out;

    outStream.Write(outBuffer, outSize);
  until (zresult = Z_STREAM_END) and (zstream.avail_out > 0) or (zResult < 0);

{$IFDEF QPL_OS_MAC}
  QPLZCompressCheck(_inflateEnd(zstream));
{$ELSE}
  QPLZCompressCheck(inflateEnd(zstream));
{$ENDIF}
end;

function InflateStr(const Input: AnsiString): AnsiString;
var
  InStream: TMemoryStream;
  OutStream: TMemoryStream;
begin
  try
    if Input <> '' then
    begin
      OutStream := TMemoryStream.Create;
      try
        InStream := TMemoryStream.Create;
        InStream.Write(Input[1], Length(Input));
        InStream.Seek(0, soFromBeginning);
        QPLZDecompressStream(InStream, OutStream);
        InStream.Free;
        SetLength(Result, OutStream.Size);
        if (OutStream.Size > 0) then
        begin
          OutStream.Seek(0, soFromBeginning);
          OutStream.Read(Result[1], Length(Result));
        end;
      finally
        OutStream.Free;
      end;
    end else
      Result := '';
  except
    Result := '';
  end;
end;
{$ENDIF}

function PaethPredictor(A, B, C: Byte): Byte;
var
  P, PA, PB, PC: Integer;
begin
  P := A + B - C;
  if (P - A) > 0 then PA := P - A else PA := A - P;
  if (P - B) > 0 then PB := P - B else PB := B - P;
  if (P - C) > 0 then PC := P - C else PC := C - P;

  if (PA <= PB) and (PA <= PC) then
  begin
    Result := A
  end else
  begin
    if PB <= PC then
      Result := B
    else
      Result := C;
  end;
end;

function InflateStrParms(const Input: AnsiString; var Parms: TPDFFlateParms): AnsiString;
var
  I, K: Integer;
  Offset: Integer;
  Leftover: array[0..8] of Byte;
  PL, PA, PAL: Integer;
  V1, V2: Integer;

  SourcePos: Integer;
  TargetPos: Integer;
  RowCount: Integer;
  SourceLength: Integer;
  SourceRowLength: Integer;
  TargetRowLength: Integer;
  Rows: array of array of Byte;
  TmpRow: array of Byte;
  Row: Integer;
  Col: Integer;
  Predictors: array of Byte;
  PixelSize: Integer;
  BitsPerRow: Integer;
begin
  // Decompress the data
  Result := InflateStr(Input);
  SourceLength := Length(Result);

  // Work out the pixel size in bytes
  PixelSize := (Parms.BitsPerComponent * Parms.Colors) div 8;
  if (PixelSize < 1) then PixelSize := 1;

  if (Parms.Predictor >= 10) and (Parms.BitsPerComponent = 4) and (Parms.Colors = 3) then
  begin
    PixelSize := 2;
  end;

  // Calculate the row length
  BitsPerRow := Parms.BitsPerComponent * Parms.Colors * Parms.Columns;
  TargetRowLength := BitsPerRow div 8;
  if TargetRowLength * 8 < BitsPerRow then
    Inc(TargetRowLength);

  if Parms.Predictor >= 10 then
    SourceRowLength := TargetRowLength + 1
  else
    SourceRowLength := TargetRowLength;

  // Calculate the number of rows
  RowCount := Ceil(SourceLength / SourceRowLength);

  // Set up the 2D data array
  SetLength(Rows, RowCount);
  for Row := 0 to RowCount - 1 do
    SetLength(Rows[Row], TargetRowLength);

  // Set up the TmpRow
  SetLength(TmpRow, TargetRowLength);

  // Set up the 1D predictor array
  SetLength(Predictors, RowCount);

  // Copy the decompressed data into the data and predictor arrays
  SourcePos := 1;
  if Parms.Predictor >= 10 then
  begin
    for Row := 0 to RowCount - 1 do
    begin
      Predictors[Row] := Byte(Result[SourcePos]);
      Inc(SourcePos);
      Move(Result[SourcePos], Rows[Row][0], TargetRowLength);
      Inc(SourcePos, TargetRowLength);
    end;
  end else
  begin
    if Parms.Predictor = 2 then
    begin
      for Row := 0 to RowCount - 1 do
      begin
        Predictors[Row] := 202;  // TIFF Predictor 2
        Move(Result[SourcePos], Rows[Row][0], TargetRowLength);
        Inc(SourcePos, TargetRowLength);
      end;
    end else
    begin
      for Row := 0 to RowCount - 1 do
      begin
        Predictors[Row] := 0;  // No prediction
        Move(Result[SourcePos], Rows[Row][0], TargetRowLength);
        Inc(SourcePos, TargetRowLength);
      end;
    end;
  end;

  // Unfilter the data
  for Row := 0 to RowCount - 1 do
  begin
    case Predictors[Row] of
      //0: // None, do nothing

      1: // Sub
      begin
        for Col := PixelSize to TargetRowLength - 1 do
        begin
          I := Rows[Row][Col - PixelSize];
          Rows[Row][Col] := (I + Rows[Row][Col]) and $FF;
        end;
      end;

      2: // Up
      begin
        if Row > 0 then
        begin
          for Col := 0 to TargetRowLength - 1 do
          begin
            I := Rows[Row - 1][Col];
            Rows[Row][Col] := (I + Rows[Row][Col]) and $FF;
          end;
        end;
      end;

      3: // Average
      begin
        for Col := 0 to TargetRowLength - 1 do
        begin
          if Col >= PixelSize then
            V1 := Rows[Row][Col - PixelSize]
          else
            V1 := 0;

          if Row > 0 then
            V2 := Rows[Row - 1][Col]
          else
            V2 := 0;

          I := (V1 + V2) div 2;

          Rows[Row][Col] := (I + Rows[Row][Col]) and $FF;
        end;
      end;

      4: // Paeth
      begin
        for Col := 0 to TargetRowLength - 1 do
        begin
          if Col >= PixelSize then
            PL := Rows[Row][Col - PixelSize]
          else
            PL := 0;

          if Row > 0 then
            PA := Rows[Row - 1][Col]
          else
            PA := 0;

          if (Col >= PixelSize) and (Row > 0) then
            PAL := Rows[Row - 1][Col - PixelSize]
          else
            PAL := 0;

          I := PaethPredictor(PL, PA, PAL);
          Rows[Row][Col] := (I + Rows[Row][Col]) and $FF;
        end;
      end;

      202: // TIFF Predictor 2
      begin
        for K := 0 to Parms.Colors - 1 do
          Leftover[K] := 0;

        // Copy the current row into a temporary TmpRow array so we can overwrite it.
        for K := 0 to TargetRowLength - 1 do
        begin
          TmpRow[K] := Rows[Row][K];
          Rows[Row][K] := 0;
        end;

      	for I := 0 to Parms.Columns - 1 do
        begin
      		for K := 0 to Parms.Colors - 1 do
          begin
            Offset := I * Parms.Colors + K;
            case Parms.BitsPerComponent of
            	1: V1 := (TmpRow[Offset shr 3] shr (7 - (Offset and 7))) and 1;
            	2: V1 := (TmpRow[Offset shr 2] shr ((3 - (Offset and 3)) shl 1)) and 3;
            	4: V1 := (TmpRow[Offset shr 1] shr ((1 - (Offset and 1)) shl 2)) and 15;
            	8: V1 := TmpRow[Offset];
            else
              V1 := TmpRow[Offset];
            end;

      			V2 := (V1 + Leftover[K]) mod (1 shl Parms.BitsPerComponent);

            case Parms.BitsPerComponent of
            	1: Rows[Row][Offset shr 3] := Rows[Row][Offset shr 3] or V2 shl (7 - (Offset and 7));
            	2: Rows[Row][Offset shr 2] := Rows[Row][Offset shr 2] or V2 shl ((3 - (Offset and 3)) shl 1);
            	4: Rows[Row][Offset shr 1] := Rows[Row][Offset shr 1] or V2 shl ((1 - (Offset and 1)) shl 2);
            	8: Rows[Row][Offset] := V2;
            end;

      			Leftover[K] := V2;
          end;
        end;
      end;

    end;
  end;

  TargetPos := 1;
  SetLength(Result, RowCount * TargetRowLength);
  for Row := 0 to RowCount - 1 do
  begin
    Move(Rows[Row][0], Result[TargetPos], TargetRowLength);
    Inc(TargetPos, TargetRowLength);
  end;
end;

{$ENDIF}

end.
