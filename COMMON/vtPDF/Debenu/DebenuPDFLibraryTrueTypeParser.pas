{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryTrueTypeParser.pas                     }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryTrueTypeParser;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  Classes;

type
  // From http://www.microsoft.com/typography/otspec/otff.htm
  TPDFTTttcfTable = record
    tag: Cardinal;
    version: Double;
    numFonts: Cardinal;
    offsets: array of Cardinal; // NumFonts.
    ulDsigTag: Cardinal;
    ulDsigLength: Cardinal;
    ulDsigOffset: Cardinal;
  end;

  TPDFTTOffsetTable = record
    snftVersion: Double;
    numTables: Word;
    searchRange: Word;
    entrySelector: Word;
    rangeShift: Word;
  end;

  TPDFTTDirectoryEntry = record
    tag: Cardinal;
    tagName: AnsiString;
    checkSum: Cardinal;
    offset: Cardinal;
    length: Cardinal;
    readPosition: Int64;
  end;

  TPDFTTheadTable = record
    version: Double;
    fontRevision: Double;
    flags: Word;
    unitsPerEm: Word;
    created: Cardinal;
    modified: Cardinal;
    Bounds: array[1..4] of Integer;
    macStyle: Word;
    indexToLocFormat: Integer;
    glyphDataFormat: Integer;
  end;

  TPDFTTmaxpTable = record
    version: Double;
    numGlyphs: Cardinal;
  end;

  TPDFTTPoint = record
    X: Integer;
    Y: Integer;
  end;

  TPDFTTComposite = record
    flags: Integer;
    glyphIndex: Integer;
    argument1: Integer;
    argument2: Integer;
    xscale: Double;
    yscale: Double;
    scale01: Double;
    scale10: Double;
  end;

  TPDFTTglyfTable = record
    numberOfContours: Integer;
    xMin: Integer;
    yMin: Integer;
    xMax: Integer;
    yMax: Integer;
    endPtsOfContours: array of Word;
    Points: array of TPDFTTPoint;
    Flags: array of Byte;
    Composites: array of TPDFTTComposite;
  end;

  TPDFTTpostTable = record
    version: Double;
    italicAngle: Double;
    underlinePosition: Integer;
    underlineThickness: Integer;
    isFixedPitch: Cardinal;
    GlyphNames: array of AnsiString;
  end;

  TPDFTTEncodingRecord = record
    platformID: Word;
    encodingID: Word;
    offset: Integer;
    language: Word;
    format: Word;
    Codes: array of Word;
    GlyfID: array of Word;
  end;

  TPDFTTcmapTable = record
    version: Word;
    numTables: Word;
    encodingRecords: array of TPDFTTEncodingRecord;
  end;

  TPDFTThheaTable = record
    Ascender: Integer;
    Descender: Integer;
    LineGap: Integer;
    advanceWidthMax: Integer;
    minLeftSideBearing: Integer;
    minRightSideBearing: Integer;
    xMaxExtent: Integer;
    caretSlopeRise: Integer;
    caretSlopeRun: Integer;
    caretOffset: Integer;
    numberOfHMetrics: Integer;
  end;

  TPDFTThmtxTable = record
    Widths: array of Word;
  end;

  TPDFTTNameRecord = record
    platformID: Word;
    encodingID: Word;
    languageID: Word;
    nameID: Word;
    length: Word;
    offset: Word;
  end;

  TPDFTrueTypeParser = class
  protected
    FStream: TStream;
    FttcfTable: TPDFTTttcfTable;
    FOffsetTable: TPDFTTOffsetTable;
    FTableDirectory: array of TPDFTTDirectoryEntry;
    FmaxpTable: TPDFTTmaxpTable;
    FheadTable: TPDFTTheadTable;
    FGlyphOffsets: array of Integer;
    FGlyphData: array of TPDFTTglyfTable;
    FpostTable: TPDFTTpostTable;
    FcmapTable: TPDFTTcmapTable;
    FhheaTable: TPDFTThheaTable;
    FhmtxTable: TPDFTThmtxTable;
    OnlyTables: Boolean;
    FFontName: WideString;
    function ReadULong: Cardinal;
    function ReadUShort: Word;
    function ReadShort: Smallint;
    function ReadFixed: Double;
    function ReadF2Dot14: Double;
    function ReadByte: Byte;
    function ReadChar: Shortint;
    function FindTable(const tagName: AnsiString): Integer;
    procedure maxpLoad;
    procedure headLoad;
    procedure locaLoad;
    procedure glyfLoad;
    procedure postLoad;
    procedure cmapLoad;
    procedure hheaLoad;
    procedure hmtxLoad;
  public
    TableOffset: Cardinal;
    constructor Create;
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromString(const Source: AnsiString);
    procedure LoadTablesFromStream(Stream: TStream);
    function GetGlyphData(Index: Integer): TPDFTTglyfTable;
    function GetHeadTable: TPDFTTheadTable;
    function GlyphCount: Integer;
    function Findcmap(PlatformID, EncodingID: Word): Integer;
    function FindUnicodecmap: Integer;
    function Getcmap(Index: Integer): TPDFTTEncodingRecord;
    function PostCount: Integer;
    function HasPostName(const CharName: AnsiString): Integer;
    function GetWidth(Index: Integer): Integer;
    function GetCFFDataPosition: Integer;
    function GetCFFData: AnsiString;
    procedure ReadNameTable;
    procedure ShiftTableOffsets(var Source: AnsiString; Offset: Cardinal);
    procedure ReadMetrics(var Metrics: TOutlineTextmetricW);
    property FontName: WideString read FFontName;
  end;

implementation

uses
  SysUtils, DebenuPDFLibraryExtra;

const
  MacGlyphNames: array[0..257] of AnsiString = (
    '.notdef', '.null', 'nonmarkingreturn', 'space', 'exclam', 'quotedbl',
    'numbersign', 'dollar', 'percent', 'ampersand', 'quotesingle', 'parenleft',
    'parenright', 'asterisk', 'plus', 'comma', 'hyphen', 'period', 'slash',
    'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight',
    'nine', 'colon', 'semicolon', 'less', 'equal', 'greater', 'question', 'at',
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O',
    'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'bracketleft', 'backslash',
    'bracketright', 'asciicircum', 'underscore', 'grave', 'a', 'b', 'c', 'd',
    'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
    't', 'u', 'v', 'w', 'x', 'y', 'z', 'braceleft', 'bar', 'braceright', 'asciitilde',
    'Adieresis', 'Aring', 'Ccedilla', 'Eacute', 'Ntilde', 'Odieresis', 'Udieresis',
    'aacute', 'agrave', 'acircumflex', 'adieresis', 'atilde', 'aring', 'ccedilla',
    'eacute', 'egrave', 'ecircumflex', 'edieresis', 'iacute', 'igrave', 'icircumflex',
    'idieresis', 'ntilde', 'oacute', 'ograve', 'ocircumflex', 'odieresis',
    'otilde', 'uacute', 'ugrave', 'ucircumflex', 'udieresis', 'dagger', 'degree',
    'cent', 'sterling', 'section', 'bullet', 'paragraph', 'germandbls', 'registered',
    'copyright', 'trademark', 'acute', 'dieresis', 'notequal', 'AE', 'Oslash',
    'infinity', 'plusminus', 'lessequal', 'greaterequal', 'yen', 'mu', 'partialdiff',
    'summation', 'product', 'pi', 'integral', 'ordfeminine', 'ordmasculine',
    'Omega', 'ae', 'oslash', 'questiondown', 'exclamdown', 'logicalnot', 'radical',
    'florin', 'approxequal', 'Delta', 'guillemotleft', 'guillemotright', 'ellipsis',
    'nonbreakingspace', 'Agrave', 'Atilde', 'Otilde', 'OE', 'oe', 'endash',
    'emdash', 'quotedblleft', 'quotedblright', 'quoteleft', 'quoteright', 'divide',
    'lozenge', 'ydieresis', 'Ydieresis', 'fraction', 'currency', 'guilsinglleft',
    'guilsinglright', 'fi', 'fl', 'daggerdbl', 'periodcentered', 'quotesinglbase',
    'quotedblbase', 'perthousand', 'Acircumflex', 'Ecircumflex', 'Aacute',
    'Edieresis', 'Egrave', 'Iacute', 'Icircumflex', 'Idieresis', 'Igrave',
    'Oacute', 'Ocircumflex', 'apple', 'Ograve', 'Uacute', 'Ucircumflex', 'Ugrave',
    'dotlessi', 'circumflex', 'tilde', 'macron', 'breve', 'dotaccent', 'ring',
    'cedilla', 'hungarumlaut', 'ogonek', 'caron', 'Lslash', 'lslash', 'Scaron',
    'scaron', 'Zcaron', 'zcaron', 'brokenbar', 'Eth', 'eth', 'Yacute', 'yacute',
    'Thorn', 'thorn', 'minus', 'multiply', 'onesuperior', 'twosuperior', 'threesuperior',
    'onehalf', 'onequarter', 'threequarters', 'franc', 'Gbreve', 'gbreve',
    'Idotaccent', 'Scedilla', 'scedilla', 'Cacute', 'cacute', 'Ccaron', 'ccaron',
    'dcroat'
  );

{ TPDFTrueTypeParser }

function TPDFTrueTypeParser.FindTable(const tagName: AnsiString): Integer;
var
  TX: Integer;
begin
  Result := -1;
  TX := 0;
  while (Result < 0) and (TX < Length(FTableDirectory)) do
  begin
    if FTableDirectory[TX].tagName = tagName then
      Result := TX
    else
      Inc(TX);
  end;
end;

procedure TPDFTrueTypeParser.LoadFromStream(Stream: TStream);
var
  TX: Integer;
  Version: Cardinal;
  StrVersion: AnsiString;

  function GetTagName(C: Cardinal): AnsiString;
  begin
    Result := AnsiChar((C and $FF000000) shr 24) + AnsiChar((C and $FF0000) shr 16) +
      AnsiChar((C and $FF00) shr 8) + AnsiChar(C and $FF);
  end;

begin
  FStream := Stream;
  if FStream.Size > 0 then
  begin
    Version := ReadULong;
    FOffsetTable.snftVersion := Version / 65536;
    StrVersion := GetTagName(Version);
    if (StrVersion = 'ttcf') then
    begin
      FttcfTable.tag:= Version;
      FttcfTable.version := ReadULong / 65536;
      FttcfTable.numFonts := ReadULong;
      SetLength(FttcfTable.offsets, FttcfTable.numFonts);
      for TX := 0 to FttcfTable.numFonts - 1 do
        FttcfTable.offsets[TX] := ReadULong;

      if (FttcfTable.version = 2) then
      begin
        FttcfTable.ulDsigTag := ReadULong;
        FttcfTable.ulDsigLength := ReadULong;
        FttcfTable.ulDsigOffset := ReadULong;
      end;

      if (FttcfTable.numFonts >= 1) then
        FStream.Seek(FttcfTable.offsets[0], soBeginning);  //Use first font

      // Now read the header of the 1st font.  TODO : Use other font headers.
      Version := ReadULong;
      FOffsetTable.snftVersion := Version / 65536;
      StrVersion := GetTagName(Version);
    end;

    if (FOffsetTable.snftVersion = 1.0) or (StrVersion = 'true') or
      (StrVersion = 'typ1') or (StrVersion = 'OTTO') then
    begin
      FOffsetTable.numTables := ReadUShort;
      FOffsetTable.searchRange := ReadUShort;
      FOffsetTable.entrySelector := ReadUShort;
      FOffsetTable.rangeShift := ReadUShort;
      SetLength(FTableDirectory, FOffsetTable.numTables);
      for TX := 0 to FOffsetTable.numTables - 1 do
      begin
        FTableDirectory[TX].tag := ReadULong;
        FTableDirectory[TX].tagName := GetTagName(FTableDirectory[TX].tag);
        FTableDirectory[TX].checkSum := ReadULong;
        FTableDirectory[TX].readPosition := FStream.Position;
        FTableDirectory[TX].offset := ReadULong - TableOffset;
        FTableDirectory[TX].length := ReadULong;
      end;
      if not OnlyTables then
      begin
        headLoad;
        maxpLoad;
        locaLoad;
        glyfLoad;
        postLoad;
        cmapLoad;
        hheaLoad;
        hmtxLoad;
      end;
    end;
  end;
end;

procedure TPDFTrueTypeParser.maxpLoad;
var
  TI: Integer;
begin
  TI := FindTable('maxp');
  if TI >= 0 then
  begin
    FStream.Seek(FTableDirectory[TI].offset, soBeginning);
    FmaxpTable.version := ReadFixed;
    FmaxpTable.numGlyphs := ReadUShort;
  end;
end;

function TPDFTrueTypeParser.ReadULong: Cardinal;
begin
  FStream.Read(Result, 4);
  Result := (Result and $FF) shl 24 + (Result and $FF00) shl 8 +
    (Result and $FF0000) shr 8 + (Result and $FF000000) shr 24;
end;

function TPDFTrueTypeParser.ReadFixed: Double;
begin
  Result := ReadULong / 65536;
end;

procedure TPDFTrueTypeParser.ReadMetrics(var Metrics: TOutlineTextmetricW);
begin
  Metrics.otmrcFontBox.Left := FheadTable.Bounds[1];
  Metrics.otmrcFontBox.Bottom := FheadTable.Bounds[2];
  Metrics.otmrcFontBox.Right := FheadTable.Bounds[3];
  Metrics.otmrcFontBox.Top := FheadTable.Bounds[4];
  Metrics.otmAscent := FhheaTable.Ascender;
  Metrics.otmDescent := FhheaTable.Descender;
end;

function TPDFTrueTypeParser.ReadUShort: Word;
begin
  FStream.Read(Result, 2);
  Result := (Result and $FF) shl 8 + (Result and $FF00) shr 8;
end;

function TPDFTrueTypeParser.ReadShort: Smallint;
var
  W: Word;
begin
  W := ReadUShort;
  Result := Smallint(W);
end;

procedure TPDFTrueTypeParser.headLoad;
var
  TI: Integer;
begin
  TI := FindTable('head');
  if TI >= 0 then
  begin
    FStream.Seek(FTableDirectory[TI].offset, soBeginning);
    FheadTable.version := ReadFixed;
    FheadTable.fontRevision := ReadFixed;
    ReadULong;
    ReadULong;
    FheadTable.flags := ReadUShort;
    FheadTable.unitsPerEm := ReadUShort;
    FheadTable.created := ReadULong;
    FheadTable.created := ReadULong;
    FheadTable.modified := ReadULong;
    FheadTable.modified := ReadULong;
    FheadTable.Bounds[1] := ReadShort;
    FheadTable.Bounds[2] := ReadShort;
    FheadTable.Bounds[3] := ReadShort;
    FheadTable.Bounds[4] := ReadShort;
    FheadTable.macStyle := ReadUShort;
    ReadUShort;
    ReadShort;
    FheadTable.indexToLocFormat := ReadShort;
    FheadTable.glyphDataFormat := ReadShort;
  end else
  begin
    FheadTable.unitsPerEm := 2048;
  end;
end;

procedure TPDFTrueTypeParser.locaLoad;
var
  TI: Integer;
  GI: Integer;
  C: Cardinal;
begin
  TI := FindTable('loca');
  if TI >= 0 then
  begin
    FStream.Seek(FTableDirectory[TI].offset, soBeginning);
    SetLength(FGlyphOffsets, FmaxpTable.numGlyphs + 1);
    if (FheadTable.indexToLocFormat = 0) then
    begin
      for GI := 0 to FmaxpTable.numGlyphs do
        FGlyphOffsets[GI] := ReadUShort * 2;
    end else
    if ((FheadTable.indexToLocFormat = 1) or (FheadTable.indexToLocFormat = 256)) then
    begin
      for GI := 0 to FmaxpTable.numGlyphs do
      begin
        C := ReadULong;
        if (C <= $00FFFFFF) then
        begin
          FGlyphOffsets[GI] := Integer(C);
        end else
        begin
          FGlyphOffsets[GI] := 0;
        end;
      end;
    end else
    begin
      for GI := 0 to FmaxpTable.numGlyphs do
        FGlyphOffsets[GI] := 0;
    end;
  end;
end;

procedure TPDFTrueTypeParser.glyfLoad;
var
  GTStart: Integer;
  GI: Integer;
  GP: Integer;
  TI: Integer;
  CC: Integer;
  CX: Integer;
  IL: Integer;
  FX: Integer;
  FC: Integer;
  F: Byte;
  CFlags: Integer;
  C: TPDFTTComposite;
  R: Byte;
  RX: Integer;
  V: Integer;
  GlyphSize: Integer;
begin
  TI := FindTable('glyf');
  if TI >= 0 then
  begin
    GTStart := FTableDirectory[TI].offset;
    SetLength(FGlyphData, FmaxpTable.numGlyphs);
    for GI := 0 to FmaxpTable.numGlyphs - 1 do
    begin
      GP := FGlyphOffsets[GI];
      GlyphSize := Abs(FGlyphOffsets[GI + 1] - GP);
      if ((GlyphSize > 0) and
        ((GP + GTStart) < FStream.Size)) then
      begin
        FStream.Seek(GP + GTStart, soFromBeginning);
        CC := ReadShort;
        FGlyphData[GI].xMin := ReadShort;
        FGlyphData[GI].yMin := ReadShort;
        FGlyphData[GI].xMax := ReadShort;
        FGlyphData[GI].yMax := ReadShort;

        if (FStream.Position >= GP + GTStart + GlyphSize) then
          Continue;

        if CC <= 0 then
        begin
          FGlyphData[GI].numberOfContours := 0;
          repeat
            CFlags := ReadUShort;
            SetLength(FGlyphData[GI].Composites, Length(FGlyphData[GI].Composites) + 1);
            C.flags := CFlags;
            C.glyphIndex := ReadUShort;
            C.xscale := 1;
            C.yscale := 1;
            if (CFlags and 1) = 1 then
            begin
              C.argument1 := ReadShort;
              C.argument2 := ReadShort;
            end else
            begin
              C.argument1 := ReadChar;
              C.argument2 := ReadChar;
            end;
            if (CFlags and 8) = 8 then
            begin
              C.xscale := ReadF2Dot14;
              C.yscale := C.xscale;
            end else
            if (CFlags and 64) = 64 then
            begin
              C.xscale := ReadF2Dot14;
              C.yscale := ReadF2Dot14;
            end else
            if (CFlags and 128) = 128 then
            begin
              C.xscale := ReadF2Dot14;
              C.scale01 := ReadF2Dot14;
              C.scale10 := ReadF2Dot14;
              C.yscale := ReadF2Dot14;
            end;
            FGlyphData[GI].Composites[Length(FGlyphData[GI].Composites) - 1] := C;
          until (CFlags and 32) = 0;
        end else
        begin
          FGlyphData[GI].numberOfContours := CC;
          SetLength(FGlyphData[GI].endPtsOfContours, CC);
          for CX := 0 to CC - 1 do
            FGlyphData[GI].endPtsOfContours[CX] := ReadUShort;
          IL := ReadUShort;
          FStream.Seek(IL, soFromCurrent);
          FC := FGlyphData[GI].endPtsOfContours[CC - 1] + 1;
          SetLength(FGlyphData[GI].Points, FC);
          SetLength(FGlyphData[GI].Flags, FC);
          FX := 0;
          repeat
            F := ReadByte;
            FGlyphData[GI].Flags[FX] := F;
            if F and 8 = 8 then
            begin
              R := ReadByte;
              for RX := 1 to R do
              begin
                Inc(FX);
                if (FX < FC) then
                begin
                  FGlyphData[GI].Flags[FX] := F;
                end;
              end;
            end;
            Inc(FX);
          until FX >= FC;

          V := 0;
          FX := 0;
          repeat
            F := FGlyphData[GI].Flags[FX];
            if F and 2 = 2 then
            begin
              if F and 16 = 16 then
                V := V + ReadByte
              else
                V := V - ReadByte;
            end else
            begin
              if F and 16 = 0 then
                V := V + ReadShort;
            end;
            FGlyphData[GI].Points[FX].X := V;
            Inc(FX);
          until FX = FC;

          V := 0;
          FX := 0;
          repeat
            F := FGlyphData[GI].Flags[FX];
            if F and 4 = 4 then
            begin
              if F and 32 = 32 then
                V := V + ReadByte
              else
                V := V - ReadByte;
            end else
            begin
              if F and 32 = 0 then
                V := V + ReadShort;
            end;
            FGlyphData[GI].Points[FX].Y := V;
            Inc(FX);
          until FX = FC;
        end;
      end else
        FGlyphData[GI].numberOfContours := 0;
    end;
  end;
end;

function TPDFTrueTypeParser.ReadByte: Byte;
begin
  FStream.Read(Result, 1);
end;

procedure TPDFTrueTypeParser.LoadFromString(const Source: AnsiString);
var
  SS: TStringStream;
begin
  SS := TStringStream.Create(Source);
  try
    LoadFromStream(SS);
  finally
    SS.Free;
  end;
end;

procedure TPDFTrueTypeParser.LoadTablesFromStream(Stream: TStream);
begin
  OnlyTables := True;
  LoadFromStream(Stream);
end;

procedure TPDFTrueTypeParser.postLoad;
var
  TI: Integer;
  GX: Integer;
  GM: Word;
  GI: Integer;
  MaxNew: Integer;
  NewNames: array of AnsiString;
begin
  TI := FindTable('post');
  if TI >= 0 then
  begin
    SetLength(FpostTable.GlyphNames, FmaxpTable.numGlyphs);
    for GX := 0 to FmaxpTable.numGlyphs - 1 do
      FpostTable.GlyphNames[GX] := '';
    FStream.Seek(FTableDirectory[TI].offset, soBeginning);
    FpostTable.version := ReadFixed;
    FpostTable.italicAngle := ReadFixed;
    FpostTable.underlinePosition := ReadShort;
    FpostTable.underlineThickness := ReadShort;
    FpostTable.isFixedPitch := ReadULong;
    ReadULong;
    ReadULong;
    ReadULong;
    ReadULong;
    if FpostTable.version = 1 then
    begin
      GM := FmaxpTable.numGlyphs;
      if GM > 258 then GM := 258;
      for GX := 0 to GM - 1 do
        FpostTable.GlyphNames[GX] := MacGlyphNames[GX];
    end else
    if FpostTable.version = 2 then
    begin
      GM := ReadUShort;
      MaxNew := 0;
      for GX := 0 to GM - 1 do
      begin
        GI := ReadUShort;
        if (GX < Integer(FmaxpTable.numGlyphs)) then
        begin
          if (GI >= 0) and (GI <= 257) then
            FpostTable.GlyphNames[GX] := MacGlyphNames[GI];
          if (GI > 257) then
          begin
            FpostTable.GlyphNames[GX] := 'new:' + QPLIntToStr(GI - 258);
            if (GI - 257) > MaxNew then MaxNew := GI - 257;
          end;
        end;
      end;
      SetLength(NewNames, MaxNew);
      for GX := 0 to MaxNew - 1 do
      begin
        SetLength(NewNames[GX], ReadByte);
        if (Length(NewNames[GX]) > 0) then
        begin
          FStream.Read(NewNames[GX][1], Length(NewNames[GX]));
        end;
      end;
      for GX := 0 to Length(FpostTable.GlyphNames) - 1 do
      begin
        if QPLCopy(FpostTable.GlyphNames[GX], 1, 4) = 'new:' then
        begin
          FpostTable.GlyphNames[GX] := NewNames[QPLStrToIntDef(
            QPLCopy(FpostTable.GlyphNames[GX], 5, MaxInt), 0)];
        end;
      end;
    end else
    if FpostTable.version = 2.5 then
    begin
      GM := ReadUShort;
      if GM > FmaxpTable.numGlyphs then GM := FmaxpTable.numGlyphs;
      for GX := 0 to GM - 1 do
      begin
        GI := ReadChar + GX;
        if (GI > 0) and (GI <= 257) then
          FpostTable.GlyphNames[GX] := MacGlyphNames[GX + GI];
      end;
    end else
    if FpostTable.version = 3 then
    begin
      SetLength(FpostTable.GlyphNames, 0);
    end;
  end;
end;

function TPDFTrueTypeParser.ReadChar: Shortint;
begin
  FStream.Read(Result, 1);
end;

procedure TPDFTrueTypeParser.cmapLoad;
var
  TI: Integer;
  CX: Integer;
  CP: Integer;
  GX: Integer;
  SegCount: Word;
  StartCodes: array of Word;
  EndCodes: array of Word;
  Deltas: array of Integer;
  Offsets: array of Word;
  GlyphIDs: array of Word;
  TL: Word;
  L: Word;
  SX: Integer;
  SCX: Integer;
  CI: Integer;
  GI: Integer;
  FirstCode: Word;
  EntryCount: Word;
begin
  TI := FindTable('cmap');
  if TI >= 0 then
  begin
    CP := FTableDirectory[TI].offset;
    SetLength(FpostTable.GlyphNames, FmaxpTable.numGlyphs);
    FStream.Seek(CP, soFromBeginning);
    FcmapTable.version := ReadUShort;
    FcmapTable.numTables := ReadUShort;
    SetLength(FcmapTable.encodingRecords, FcmapTable.numTables);
    for CX := 0 to FcmapTable.numTables - 1 do
    begin
      FcmapTable.encodingRecords[CX].platformID := ReadUShort;
      FcmapTable.encodingRecords[CX].encodingID := ReadUShort;
      FcmapTable.encodingRecords[CX].offset := ReadULong;
    end;
    for CX := 0 to FcmapTable.numTables - 1 do
    begin
      FStream.Seek(CP + FcmapTable.encodingRecords[CX].offset, soFromBeginning);
      FcmapTable.encodingRecords[CX].format := ReadUShort;
      TL := ReadUShort;
      FcmapTable.encodingRecords[CX].language := ReadUShort; 
      case FcmapTable.encodingRecords[CX].format of
        0:
        begin
          SetLength(FcmapTable.encodingRecords[CX].Codes, 256);
          SetLength(FcmapTable.encodingRecords[CX].GlyfID, 256);
          for GX := 0 to 255 do
          begin
            FcmapTable.encodingRecords[CX].Codes[GX] := GX;
            FcmapTable.encodingRecords[CX].GlyfID[GX] := ReadByte;
          end;
        end;
        2:
        begin
        end;
        4:
        begin
          SegCount := ReadUShort div 2;
          ReadUShort;
          ReadUShort;
          ReadUShort;
          SetLength(StartCodes, SegCount);
          SetLength(EndCodes, SegCount);
          SetLength(Deltas, SegCount);
          SetLength(Offsets, SegCount);
          for SX := 0 to SegCount - 1 do
            EndCodes[SX] := ReadUShort;
          ReadUShort;
          L := 0;
          for SX := 0 to SegCount - 1 do
          begin
            StartCodes[SX] := ReadUShort;
            if EndCodes[SX] <> $FFFF then
              L := L + EndCodes[SX] - StartCodes[SX] + 1;
          end;
          for SX := 0 to SegCount - 1 do
            Deltas[SX] := ReadShort;
          for SX := 0 to SegCount - 1 do
            Offsets[SX] := ReadUShort;
          TL := TL - (SegCount * 8 + 16);
          SetLength(GlyphIDs, TL div 2 + 1);
          for SX := 0 to Length(GlyphIDs) - 1 do
            GlyphIDs[SX] := ReadUShort;
          SetLength(FcmapTable.encodingRecords[CX].Codes, L);
          SetLength(FcmapTable.encodingRecords[CX].GlyfID, L);
          CI := 0;
          for SX := 0 to SegCount - 1 do
          begin
            if EndCodes[SX] <> $FFFF then
            for SCX := StartCodes[SX] to EndCodes[SX] do
            begin
              FcmapTable.encodingRecords[CX].Codes[CI] := SCX;
              if Offsets[SX] > 0 then
              begin
                GX := (((Offsets[SX] + (SX + 1) * 2) div 2) - (SegCount + 1) +
                  (SCX - StartCodes[SX]) + Deltas[SX]) mod 65536;
                GI := GlyphIDs[GX];
              end else
                GI := Word(SCX + Deltas[SX]);
              FcmapTable.encodingRecords[CX].GlyfID[CI] := GI;
              Inc(CI);
            end;
          end;
        end;
        6:
        begin
          FirstCode := ReadUShort;
          EntryCount := ReadUShort;
          SetLength(FcmapTable.encodingRecords[CX].Codes, EntryCount);
          SetLength(FcmapTable.encodingRecords[CX].GlyfID, EntryCount);
          for SX := 0 to EntryCount - 1 do
          begin
            FcmapTable.encodingRecords[CX].Codes[SX] := SX + FirstCode;
            FcmapTable.encodingRecords[CX].GlyfID[SX] := ReadUShort;
          end;
        end;
        8:
        begin

        end;
        10:
        begin

        end;
        12:
        begin

        end;
      end;
    end;
  end;
end;

function TPDFTrueTypeParser.Findcmap(PlatformID,
  EncodingID: Word): Integer;
var
  X: Integer;
begin
  Result := -1;
  for X := 0 to Length(FcmapTable.encodingRecords) - 1 do
  begin
    if (FcmapTable.encodingRecords[X].platformID = PlatformID) and
      (FcmapTable.encodingRecords[X].encodingID = EncodingID) then
        Result := X;
  end;
end;

function TPDFTrueTypeParser.FindUnicodecmap: Integer;
var
  X: Integer;
begin
  Result := -1;
  for X := 0 to Length(FcmapTable.encodingRecords) - 1 do
  begin
    if (FcmapTable.encodingRecords[X].platformID = 0) then
        Result := X;
  end;
end;

function TPDFTrueTypeParser.ReadF2Dot14: Double;
var
  W: Word;
  UM: Word;
  M: Smallint;
begin
  W := ReadUShort;
  UM := W shr 14;
  if UM and 2 = 2 then UM := UM or $FFFE;
  M := Smallint(UM);
  Result := M + W and ($3FFF) / 16384;
end;

function TPDFTrueTypeParser.GetGlyphData(Index: Integer): TPDFTTglyfTable;
begin
  if (Index >= 0) and (Index < Length(FGlyphData)) then
    Result := FGlyphData[Index]
  else
    Result.numberOfContours := 0;
end;

function TPDFTrueTypeParser.GetHeadTable: TPDFTTheadTable;
begin
  Result := FheadTable;
end;

function TPDFTrueTypeParser.GlyphCount: Integer;
begin
  Result := Length(FGlyphData);
  if (Result = 0) then
  begin
    Result := FmaxpTable.numGlyphs;
  end;
end;

function TPDFTrueTypeParser.Getcmap(Index: Integer): TPDFTTEncodingRecord;
begin
  if (Index >= 0) and (Index < Length(FcmapTable.encodingRecords)) then
    Result := FcmapTable.EncodingRecords[Index]
  else
  begin
    Result.platformID := 0;
    Result.encodingID := 0;
  end;
end;

procedure TPDFTrueTypeParser.ReadNameTable;
var
  TI: Integer;
  //TableFormat: Integer;
  Count: Integer;
  StringOffset: Integer;
  NameRecords: array of TPDFTTNameRecord;
  RX: Integer;
  CP: Integer;
  FontNameA: AnsiString;
begin
  TI := FindTable('name');
  if (TI >= 0) then
  begin
    CP := FTableDirectory[TI].offset;
    FStream.Seek(CP, soFromBeginning);
    {TableFormat := }ReadUShort;
    Count := ReadUShort;
    StringOffset := ReadUShort;
    SetLength(NameRecords, Count);
    for RX := 0 to Count - 1 do
    begin
      NameRecords[RX].platformID := ReadUShort;
      NameRecords[RX].encodingID := ReadUShort;
      NameRecords[RX].languageID := ReadUShort;
      NameRecords[RX].nameID := ReadUShort;
      NameRecords[RX].length := ReadUShort;
      NameRecords[RX].offset := ReadUShort;
    end;

    for RX := 0 to Length(NameRecords) - 1 do
    begin
      if (NameRecords[RX].nameID = 4) then
      begin
        if ((NameRecords[RX].platformID = 1) and (NameRecords[RX].encodingID = 0)) then
        begin
          SetLength(FontNameA, NameRecords[RX].length);
          FStream.Seek(CP + StringOffset + NameRecords[RX].offset, soFromBeginning);
          FStream.Read(FontNameA[1], Length(FontNameA));
          FFontName := WideString(FontNameA);
        end;
      end;
    end;
  end;
end;

function TPDFTrueTypeParser.PostCount: Integer;
begin
  Result := Length(FpostTable.GlyphNames);  
end;

function TPDFTrueTypeParser.HasPostName(const CharName: AnsiString): Integer;
var
  I: Integer;
begin
  I := 0;
  Result := -1;

  while (I < Length(FpostTable.GlyphNames)) do
  begin
    if FpostTable.GlyphNames[I] = CharName then
    begin
      Result := I;
    end;
    Inc(I);
  end;
end;

procedure TPDFTrueTypeParser.hmtxLoad;
var
  TI: Integer;
  CP: Integer;
  X: Integer;
begin
  TI := FindTable('hmtx');
  if TI >= 0 then
  begin
    CP := FTableDirectory[TI].offset;
    FStream.Seek(CP, soFromBeginning);
    if FhheaTable.numberOfHMetrics > 0 then
    begin
      SetLength(FhmtxTable.Widths, FhheaTable.numberOfHMetrics);
      for X := 0 to Length(FhmtxTable.Widths) - 1 do
      begin
        FhmtxTable.Widths[X] := ReadUShort * 1000 div FheadTable.unitsPerEm;
        ReadShort;
      end;
    end;
  end;
end;

procedure TPDFTrueTypeParser.hheaLoad;
var
  TI: Integer;
  CP: Integer;
begin
  TI := FindTable('hhea');
  if TI >= 0 then
  begin
    CP := FTableDirectory[TI].offset;
    FStream.Seek(CP, soFromBeginning);
    if ReadFixed = 1 then
    begin
      FhheaTable.Ascender := ReadShort * 1000 div FheadTable.unitsPerEm;
      FhheaTable.Descender := ReadShort * 1000 div FheadTable.unitsPerEm;
      FhheaTable.LineGap := ReadShort * 1000 div FheadTable.unitsPerEm;
      FhheaTable.advanceWidthMax := ReadUShort * 1000 div FheadTable.unitsPerEm;
      FhheaTable.minLeftSideBearing := ReadShort * 1000 div FheadTable.unitsPerEm;
      FhheaTable.minRightSideBearing := ReadShort * 1000 div FheadTable.unitsPerEm;
      FhheaTable.xMaxExtent := ReadShort * 1000 div FheadTable.unitsPerEm;
      FhheaTable.caretSlopeRise := ReadShort;
      FhheaTable.caretSlopeRun := ReadShort;
      FhheaTable.caretOffset := ReadShort;
      ReadShort;
      ReadShort;
      ReadShort;
      ReadShort;
      ReadShort;
      FhheaTable.numberOfHMetrics := ReadShort;
    end;
  end;
end;

function TPDFTrueTypeParser.GetWidth(Index: Integer): Integer;
begin
  if Index >= Length(FhmtxTable.Widths) then
  begin
    if Length(FhmtxTable.Widths) > 0 then
      Result := FhmtxTable.Widths[Length(FhmtxTable.Widths) - 1]
    else
      Result := 750;
  end else if (Index >= 0) then
    Result := FhmtxTable.Widths[Index]
  else
      Result := 750;
end;

constructor TPDFTrueTypeParser.Create;
begin
  OnlyTables := False;
  TableOffset := 0;
end;

procedure TPDFTrueTypeParser.ShiftTableOffsets(var Source: AnsiString; Offset: Cardinal);
var
  Stream: TStringStream;
  TX: Integer;
  SI: Cardinal;
  NewOffset: Cardinal;
begin
  Stream := TStringStream.Create(Source);
  try
    OnlyTables := True;
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
  for TX := 0 to FOffsetTable.numTables - 1 do
  begin
    SI := FTableDirectory[TX].readPosition + 1;
    NewOffset := FTableDirectory[TX].offset - Offset;
    Source[SI] := AnsiChar((NewOffset and $FF000000) shr 24);
    Source[SI + 1] := AnsiChar((NewOffset and $FF0000) shr 16);
    Source[SI + 2] := AnsiChar((NewOffset and $FF00) shr 8);
    Source[SI + 3] := AnsiChar(NewOffset and $FF);
  end;
end;

function TPDFTrueTypeParser.GetCFFData: AnsiString;
var
  TI: Integer;
begin
  TI := FindTable('CFF ');
  if TI >= 0 then
  begin
    SetLength(Result, FTableDirectory[TI].length);
    FStream.Seek(FTableDirectory[TI].offset, soBeginning);
    FStream.Read(Result[1], Length(Result));
  end else
  begin
    Result := '';
  end;
end;

function TPDFTrueTypeParser.GetCFFDataPosition: Integer;
var
  TI: Integer;
begin
  TI := FindTable('CFF ');
  if TI >= 0 then
  begin
    Result := FTableDirectory[TI].offset;
  end else
  begin
    Result := 0;
  end;
end;

end.
