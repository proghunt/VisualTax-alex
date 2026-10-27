{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryFontRasterizer.pas                     }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryFontRasterizer;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFDEF QPL_OS_MAC}
  Types,
{$ENDIF}
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  Classes, SysUtils, DebenuPDFLibraryTypes, DebenuPDFLibraryStructure, DebenuPDFLibraryFont, DebenuPDFLibraryBuffer, DebenuPDFLibraryCMap,
  DebenuPDFLibraryFontConst, DebenuPDFLibraryGenericCanvas,
{$IFNDEF VER120}
  contnrs,
{$ENDIF}
{$IFDEF QPL_OS_WINDOWS}
{$IFDEF QPL_XE3_HIGHER}
  System.UITypes,
{$ENDIF}
{$ENDIF}
  DebenuPDFLibraryExtra, DebenuPDFLibraryMatrix, DebenuPDFLibraryImageDecoder;

type
  TPDFFontRasterizer = class
  protected
    FOnFindObject: TPDFFindObjectEvent;
    FOnDecrypt: TPDFCryptStreamEvent;
    FOnEncrypt: TPDFCryptStreamEvent;    
    function FindObject(Ref: TPDFIndRef): TPDFObject;
  public
    RenderingMode: Integer;
    function RenderToCanvas(var RX, RY: Double; Canvas: TPDFGenericCanvas; Mat: TPDFXForm;
      const CharName: AnsiString; Enc: TPDFEncodingVector): Boolean; virtual; abstract;
    function FontMatrixScaling: Double; virtual; abstract;
    procedure SetupDirectFont(Canvas: TPDFGenericCanvas); virtual;
    property OnFindObject: TPDFFindObjectEvent read FOnFindObject write FOnFindObject;
    property OnDecrypt: TPDFCryptStreamEvent read FOnDecrypt write FOnDecrypt;
    property OnEncrypt: TPDFCryptStreamEvent read FOnEncrypt write FOnEncrypt;
  end;

  TPDFType3Rasterizer = class(TPDFFontRasterizer)
  private
    FDict: TPDFDictionary;
    CharNames: TQuickPDFCaseSensitiveStringList;
    CharProcs: TQuickPDFStringList;
    FFillColor: TColor;
    InlineImages: TQuickPDFCaseSensitiveStringList;
  public
    FontMatrix: TPDFXForm;
    constructor Create; virtual;
    destructor Destroy; override;
    function RenderToCanvas(var RX, RY: Double; Canvas: TPDFGenericCanvas; Mat: TPDFXForm;
      const CharName: AnsiString; Enc: TPDFEncodingVector): Boolean; override;
    procedure LoadFromPDFDict(Dict: TPDFDictionary);
    function FontMatrixScaling: Double; override;
    function GetCharProc(const CharName: AnsiString): AnsiString;
    property Type3FontDict: TPDFDictionary read FDict;
    property FillColor: TColor read FFillColor write FFillColor;
  end;

  TResultCodes = array of Integer;

  TPDFCMapEntry = record
    StartCode: Word;
    EndCode: Word;
    ResultCodes: TResultCodes;
  end;

  TPDFW2Entry = record
    StartCID: Integer;
    EndCID: Integer;
    w1y, v1x, v1y: Integer;
  end;

  TPDFCMap = array of TPDFCMapEntry;

  TPDFFontCollectionData = class
  public
    ObjNum: Integer;
    Widths: TPDFCharsetWidths;
    DW2_v, DW2_w1: Integer;
    W2: array of TPDFW2Entry;
    FontName: AnsiString;
    Rasterizer: TPDFFontRasterizer;
    Encoding: TPDFCharsetNames;
    IsComposite: Boolean;
    CIDWidths: TQuickPDFStringList;
    Ascent: Double;
    Descent: Double;
    Bound: TRect;
    DisplayCSW: TPDFCharsetWide;
    DisplayCS2: TPDFCMap;
    FirstChar: Integer;
    LastChar: Integer;
    CIDToGIDMap: TQPLWordPairList;
    HasOwnCIDToGIDMap: Boolean;
    EncodingBuiltIn: Boolean;
    GIDToCIDMap: Integer;
    ToUnicodeMap: TDebenuPDFLibraryCMap;
    SingleByteCMap: Boolean;
    CIDEncoding: AnsiString;
    CIDSystemInfo: AnsiString;
    AdobeGIDType0: Boolean;
    Enc: TPDFEncodingVector;
    Panose: AnsiString;
    Embedded: Boolean;
    Subsetted: Boolean;
    SubType: AnsiString;
  end;

  TPDFFontCollection = class
  private
    FMapObjNum: array of Integer;
    FMapIndex: array of Integer;
    FFontData: array of TPDFFontCollectionData;
    FOnFindObject: TPDFFindObjectEvent;
    FOnDecrypt: TPDFCryptStreamEvent;
    FOnEncrypt: TPDFCryptStreamEvent;
    FFoundFontData: TPDFFontCollectionData;
    FInstallFonts: Boolean;
    ResourceList: TQuickPDFStringList;
    FUsingTextFunnel: Boolean;
    CMapList: array of TDebenuPDFLibraryCMap;
    CMapCount: Integer;
    FDirectFonts: Boolean;
  protected
    function FindObject(Ref: TPDFIndRef): TPDFObject;
    function DecodeCIDWidths(W: TPDFArray; DW: Integer; WFactor: Double): TQuickPDFStringList;
    function DecodeCJKCIDWidths(const EncodedWidthData: AnsiString; DW: Integer): TQuickPDFStringList;
    function ProcessCMap(const CMap: AnsiString; var SingleByte: Boolean): TPDFCMap;
    function ConvertCMap(CMap: TPDFCMap): TPDFCharsetDisplay;
    function ConvertCMapBase(CMap: TPDFCMap; Base: TPDFCharsetDisplay): TPDFCharsetDisplay;
    function ConvertCMapWide(CMap: TPDFCMap): TPDFCharsetWide;
    function ConvertCMapWideBase(CMap: TPDFCMap; Base: TPDFCharsetWide): TPDFCharsetWide;
    procedure UpdateMapObjNum;
    function FindMapObjNum(ObjNum: Integer): Integer;
  public
    constructor Create;
    destructor Destroy; override;

    function ResourceCMapGetValue(CMapId, Code: Integer): Integer;
    function ResourcesAddCMapFromString(Encoding: AnsiString; CMapAsString: AnsiString):Integer;
    function ResourcesAddCMapFromStream(Encoding: AnsiString; FS: TQuickPDFWideFileStream): Integer;
    function ResourceCMapCodeSplit(GIDToCIDMap: Integer; const Text: AnsiString; var CodeList: TQuickPDFCodeList): Boolean;
    function GetCMAP(Encoding: AnsiString) : Integer;

    procedure AnalyseFont(RefOrDict: TPDFObject; ParentDict: TPDFDictionary = nil);
    procedure GetFontData(Ref: TPDFIndRef);
    procedure GetFontDataFromDict(Dict: TPDFDictionary);
    procedure FastGetFontData(ObjNum: Integer);
    function GetWideMap(CharCode: Integer): WideString;
    procedure GetCodeList(const Text: AnsiString; var CodeList: TQuickPDFCodeList);
    property OnFindObject: TPDFFindObjectEvent read FOnFindObject write FOnFindObject;
    property OnDecrypt: TPDFCryptStreamEvent read FOnDecrypt write FOnDecrypt;
    property OnEncrypt: TPDFCryptStreamEvent read FOnEncrypt write FOnEncrypt;
    property FoundFontData: TPDFFontCollectionData read FFoundFontData;
    property InstallFonts: Boolean read FInstallFonts write FInstallFonts;
    property UsingTextFunnel: Boolean read FUsingTextFunnel write FUsingTextFunnel;
    property DirectFonts: Boolean read FDirectFonts write FDirectFonts;
  end;

implementation

uses
  DebenuPDFLibraryType1, DebenuPDFLibraryTrueTypeParser, DebenuPDFLibraryTrueTypeRasterizer,
  DebenuPDFLibraryPicasso, DebenuPDFLibraryFlate;

const
  WinAnsiChars: array[1..216] of AnsiString =
    ('A', 'AE', 'Aacute', 'Acircumflex', 'Adieresis', 'Agrave', 'Aring', 'Atilde',
    'B', 'C', 'Ccedilla', 'D', 'E', 'Eacute', 'Ecircumflex', 'Edieresis', 'Egrave',
    'Eth', 'Euro1', 'F', 'G', 'H', 'I', 'Iacute', 'Icircumflex', 'Idieresis',
    'Igrave', 'J', 'K', 'L', 'M', 'N', 'Ntilde', 'O', ' OE', 'Oacute',
    'Ocircumflex', 'Odieresis', 'Ograve', 'Oslash', 'Otilde', 'P', 'Q', 'R', 'S',
    'Scaron', 'T', 'Thorn', 'U', 'Uacute', 'Ucircumflex', 'Udieresis', 'Ugrave',
    'V', 'W', 'X', 'Y', 'Yacute', 'Ydieresis', 'Z', 'Zcaron', 'a', 'aacute',
    'acircumflex', 'acute', 'adieresis', 'ae', 'agrave', 'ampersand', 'aring',
    'asciicircum', 'asciitilde', 'asterisk', 'at', 'atilde', 'b', 'backslash',
    'bar', 'braceleft', 'braceright', 'bracketleft', 'bracketright', 'brokenbar',
    'bullet', 'c', 'ccedilla', 'cedilla', 'cent', 'circumflex', 'colon', 'comma',
    'copyright', 'currency', 'd', 'dagger', 'daggerdbl', 'degree', 'dieresis',
    'divide', 'dollar', 'e', 'eacute', 'ecircumflex', 'edieresis', 'egrave',
    'eight', 'ellipsis', 'emdash', 'endash', 'equal', 'eth', 'exclam',
    'exclamdown', 'f', 'five', 'florin', 'four', 'g', 'germandbls', 'grave',
    'greater', 'guillemotleft', 'guillemotright', 'guilsinglleft',
    'guilsinglright', 'h', 'hyphen', 'i', 'iacute', 'icircumflex', 'idieresis',
    'igrave', 'j', 'k', 'l', 'less', 'logicalnot', 'm', 'macron', 'mu', 'multiply',
    'n', 'nine', 'ntilde', 'numbersign', 'o', 'oacute', 'ocircumflex', 'odieresis',
    'oe', 'ograve', 'one', 'onehalf', 'onequarter', 'onesuperior', 'ordfeminine',
    'ordmasculine', 'oslash', 'otilde', 'p', 'paragraph', 'parenleft',
    'parenright', 'percent', 'period', 'periodcentered', 'perthousand',
    'plus', 'plusminus', 'q', 'question', 'questiondown', 'quotedbl',
    'quotedblbase', 'quotedblleft', 'quotedblright', 'quoteleft', 'quoteright',
    'quotesinglbase', 'quotesingle', 'r', 'registered', 's', 'scaron', 'section',
    'semicolon', 'seven', 'six', 'slash', 'space', 'sterling', 't', 'thorn', 'three',
    'threequarters', 'threesuperior', 'tilde', 'trademark', 'two', 'twosuperior',
    'u', 'uacute', 'ucircumflex', 'udieresis', 'ugrave', 'underscore', 'v', 'w',
    'x', 'y', 'yacute', 'ydieresis', 'yen', 'z', 'zcaron', 'zero');

  WinAnsiValues: array[1..216] of Integer =
    (65, 198, 193, 194, 196, 192, 197, 195, 66, 67, 199, 68, 69, 201, 202, 203,
    200, 208, 128, 70, 71, 72, 73, 205, 206, 207, 204, 74, 75, 76, 77, 78, 209,
    79, 140, 211, 212, 214, 210, 216, 213, 80, 81, 82, 83, 138, 84, 222, 85,
    218, 219, 220, 217, 86, 87, 88, 89, 221, 159, 90, 142, 97, 225, 226, 180,
    228, 230, 224, 38, 229, 94, 126, 42, 64, 227, 98, 92, 124, 123, 125, 91, 93,
    166, 149, 99, 231, 184, 162, 136, 58, 44, 169, 164, 100, 134, 135, 176, 168,
    247, 36, 101, 233, 234, 235, 232, 56, 133, 151, 150, 61, 240, 33, 161, 102,
    53, 131, 52, 103, 223, 96, 62, 171, 187, 139, 155, 104, 45, 105, 237, 238,
    239, 236, 106, 107, 108, 60, 172, 109, 175, 181, 215, 110, 57, 241, 35, 111,
    243, 244, 246, 156, 242, 49, 189, 188, 185, 170, 186, 248, 245, 112, 182,
    40, 41, 37, 46, 183, 137, 43, 177, 113, 63, 191, 34, 132, 147, 148, 145,
    146, 130, 39, 114, 174, 115, 154, 167, 59, 55, 54, 47, 32, 163, 116, 254,
    51, 190, 179, 152, 153, 50, 178, 117, 250, 251, 252, 249, 95, 118, 119, 120,
    121, 253, 255, 165, 122, 158, 48);

function ConvertTrueTypeCMap(TTR: TPDFTrueTypeRasterizer2): TPDFCMap;
var
  UnicodeCMap: Integer;
  EncodingRecord: TPDFTTEncodingRecord;
  FirstCode: Word;
  LastCode: Word;
  FirstGlyph: Word;
  LastGlyph: Word;
  FirstCodeNumber: Integer;
  LastCodeNumber: Integer;
  ResultLength: Integer;
  CodesMatch: Boolean;
  GlyphsMatch: Boolean;
begin
  ResultLength := 0;
  UnicodeCMap := TTR.Parser.Findcmap(3, 1);
  if UnicodeCMap >= 0 then
  begin
    EncodingRecord := TTR.Parser.Getcmap(UnicodeCMap);
    FirstCodeNumber := 0;
    LastCodeNumber := 0;
    while (FirstCodeNumber < Length(EncodingRecord.Codes)) and
      (LastCodeNumber < Length(EncodingRecord.Codes)) do
    begin
      FirstCode := EncodingRecord.Codes[FirstCodeNumber];
      LastCode := EncodingRecord.Codes[LastCodeNumber];
      FirstGlyph := EncodingRecord.GlyfID[FirstCodeNumber];
      LastGlyph := EncodingRecord.GlyfID[LastCodeNumber];

      CodesMatch := LastCode = FirstCode + (LastCodeNumber - FirstCodeNumber);
      GlyphsMatch := LastGlyph = FirstGlyph + (LastCodeNumber - FirstCodeNumber);

      if (CodesMatch and GlyphsMatch) then
      begin
        Inc(LastCodeNumber);
      end else
      begin
        Inc(ResultLength);
        SetLength(Result, ResultLength);
        Result[ResultLength - 1].StartCode := FirstGlyph;
        Result[ResultLength - 1].EndCode := EncodingRecord.GlyfID[LastCodeNumber - 1];

        SetLength(Result[ResultLength - 1].ResultCodes, 1);
        Result[ResultLength - 1].ResultCodes[0] := FirstCode;

        FirstCodeNumber := LastCodeNumber;
        LastCodeNumber := FirstCodeNumber;
      end;
    end;
    if (LastCodeNumber > FirstCodeNumber) then
    begin
      Inc(ResultLength);
      SetLength(Result, ResultLength);
      Result[ResultLength - 1].StartCode := FirstCodeNumber;
      Result[ResultLength - 1].EndCode := LastCodeNumber - 1;

      SetLength(Result[ResultLength - 1].ResultCodes, 1);
      Result[ResultLength - 1].ResultCodes[0] := EncodingRecord.Codes[FirstCodeNumber];
    end;
  end;
end;

{$IFDEF QPL_OS_MAC}
procedure CopyCharsetNames(var Dest: TPDFCharsetNames; Source: TPDFCharsetNames);
var
  X: Integer;
begin
  for X := 0 to 255 do
  begin
    Dest[X] := Source[X];
  end;
end;
{$ENDIF}

{ TPDFFontCollection }

function TPDFFontCollection.ResourceCMapGetValue(CMapId, Code: Integer): Integer;
var
  UseCMap: Integer;
  Codes: Array[0..3] of Word;
  Count: Integer;
begin
  Result := -1;
  if (CMapId >= 0) and (CMapId < CMapCount) then
  begin
    UseCMap := CMapList[CMapId].UseCMap;

    Count := CMapList[CMapId].GetValue(Code, Codes);
    if (Count >= 1) then
      Result := Codes[0];

    if (Result = -1) and (UseCMap <> -1) then
    begin
      Count := CMapList[UseCMap].GetValue(Code, Codes);
      if (Count >= 1) then
        Result := Codes[0];
    end;
  end;
end;

function TPDFFontCollection.ResourcesAddCMapFromStream(Encoding: AnsiString; FS: TQuickPDFWideFileStream): Integer;
var
  I: Integer;
  CMapParser: TDebenuPDFLibraryCMapParser;
  CMapBuffer: TQPLBuffer;
begin
  Result := -1;

  i := 0;
  while (I < CMapCount) and (Result = -1) do
  begin
    if (CMapList[i].CMapName = Encoding) then
      Result := I;
    Inc(I);
  end;

  if (Result = -1) then
  begin
    CMapParser := TDebenuPDFLibraryCMapParser.Create;
    try
      CMapBuffer := TQPLBuffer.Create;
      try
        CMapBuffer.SetStreamSource(FS);

        CMapList[CMapCount] := TDebenuPDFLibraryCMap.Create;
        CMapList[CMapCount] := CMapParser.ParseCMap(CMapBuffer);
        CMapList[CMapCount].CMapName := Encoding;
      finally
        CMapBuffer.Free;
      end;
    finally
      CMapParser.Free;
      Result := CMapCount;
      Inc(CMapCount);
    end;
  end;
end;

function TPDFFontCollection.ResourcesAddCMapFromString(Encoding: AnsiString; CMapAsString: AnsiString):Integer;
var
  I: Integer;
  CMapParser: TDebenuPDFLibraryCMapParser;
  CMapBuffer: TQPLBuffer;
begin
  Result := -1;
  I := 0;

  while (I < CMapCount) and (Result = -1) and (Encoding <> '') do
  begin
    if (CMapList[i].CMapName = Encoding) then
      Result := I;
    Inc(I);
  end;

  if (Result = -1) then
  begin
    CMapParser := TDebenuPDFLibraryCMapParser.Create;
    try
      CMapBuffer := TQPLBuffer.Create;
      try
        CMapBuffer.SetAnsiStringSource(CMapAsString);

        SetLength(CMapList, CMapCount + 1);
        CMapList[CMapCount] := CMapParser.ParseCMap(CMapBuffer);
        CMapList[CMapCount].CMapName := Encoding;
      finally
        CMapBuffer.Free;
      end;
    finally
      CMapParser.Free;
      Result := CMapCount;
      Inc(CMapCount);
    end;
  end;
end;

function TPDFFontCollection.ResourceCMapCodeSplit(GIDToCIDMap: Integer; const Text: AnsiString; var CodeList: TQuickPDFCodeList): Boolean;
var
  ValidEncoding: Boolean;
  CX: Integer;
  CharPos: Integer;
  CharSize: Integer;
  CharCode: Cardinal;
  CodeBuffer: TQuickPDFCodeList;
  BufferSize: Integer;
begin

  ValidEncoding := False;

  if (not ValidEncoding) and (GIDToCIDMap <> -1) and (Length(Text) > 0) then
  begin
    SetLength(CodeBuffer, 200);
    BufferSize := 0;

    CharPos := 1;
    CharSize := 1;

    if (CMapList[GIDToCIDMap].SingleByteCMap) then
    begin
      repeat
        if (CharSize = 1) or ((CharSize = 2) and (CharPos = Length(Text))) then
          CharCode := Ord(Text[CharPos])
        else
          CharCode := Ord(Text[CharPos]) shl 8 + Ord(Text[CharPos + 1]);

        CodeBuffer[BufferSize] := CharCode;

        if (ResourceCMapGetValue(GIDToCIDMap, CharCode) <> -1) or (CharSize = 2)  then
        begin
          CodeBuffer[BufferSize] := CharCode;
          Inc(BufferSize, 1);
          if (BufferSize > Length(CodeBuffer)) then
          begin
            SetLength(CodeBuffer, Length(CodeBuffer) + 200);
          end;
          Inc(CharPos, CharSize);
          CharSize := 1;
        end else
        begin
          if CharSize = 1 then
          begin
            Inc(CharSize);
          end else
          begin
            Inc(CharPos, CharSize);
          end;
        end;
      until CharPos > Length(Text);
      SetLength(CodeList, BufferSize);
      if (BufferSize > 0) then
      begin
        Move(CodeBuffer[0], CodeList[0], Length(CodeList) * SizeOf(Word));
        ValidEncoding := True;
      end;
    end;

    if not ValidEncoding then
    begin
      SetLength(CodeList, Length(Text) div 2);
      for CX := 0 to Length(CodeList) - 1 do
        CodeList[CX] := Ord(Text[CX * 2 + 1]) shl 8 + Ord(Text[CX * 2 + 2]);

      ValidEncoding := True;
    end;
  end;

  Result := ValidEncoding;
end;

function TPDFFontCollection.GetCMAP(Encoding: AnsiString) : Integer;
// const
// {$I DebenuPDFLibraryCMap.inc}
//    CMapResourceList: array[1..165] of AnsiString  - included in DebenuPDFLibraryCMap

var
  I: Integer;
  ResourceStream: TResourceStream;
  CMapEnc: AnsiString;
  CMapID: Integer;

begin
  CMapID := -1;
  for I := 0 to CMapCount - 1 do
  begin
    if (CMapList[I].CMapName = Encoding) then
      CMapID := I;
  end;

  if (CMapID = -1) then
  begin
    for I := 1 to Length(CMapResourceList) do
    begin
      if (CMapResourceList[I] = Encoding) then
      begin
{$IFNDEF QPL_CPP}
        ResourceStream := TResourceStream.CreateFromID(HInstance, 11000 + I, RT_RCDATA);
        try
          SetLength(CMapEnc, ResourceStream.Size);
          ResourceStream.Read(CMapEnc[1], Length(CMapEnc));

          CMapEnc := InflateStr(CMapEnc);

          CMapID := ResourcesAddCMapFromString(Encoding, CMapEnc);

          if (CMapList[CMapID].UseCMapName <> '') then
            CMapList[CMapID].UseCMap := GetCMap(CMapList[CMapID].UseCMapName);

        finally
          ResourceStream.Free;
        end;
{$ENDIF}
      end;
    end;
  end;

  Result := CMapID;
end;

procedure TPDFFontCollection.AnalyseFont(RefOrDict: TPDFObject; ParentDict: TPDFDictionary);
var
  Obj: TPDFObject;
  Font: TPDFDictionary;
  FontDescriptor: TPDFDictionary;
  FirstChar: Integer;
  LastChar: Integer;
  Widths: TPDFCharsetWidths;
  CharMap: TPDFCharsetDisplay;
  X: Integer;
  I: Integer;
  GX: Integer;
  Encoding: TPDFDictionary;
  StdFontIndex: Integer;
  FontName, FamilyName: AnsiString;
  MatchFontName: AnsiString;
  FontFile: AnsiString;
  SubType: AnsiString;
  Rasterizer: TPDFFontRasterizer;
  CSN: TPDFCharsetNames;
  Enc: TPDFEncodingVector;
  EncStr: AnsiString;
  Differences: TPDFArray;
  OldDifferences: TPDFArray;
  DW, DW2_v, DW2_w1: Integer;
  W2: array of TPDFW2Entry;
  CIDWidths: TQuickPDFStringList;
  Flags: Integer;
  Ascent: Double;
  Descent: Double;
  CapHeight: Double;
  Bound: TRect;
  BBox: TPDFArray;
  Panose: AnsiString;
  Embedded: Boolean;
  Subsetted: Boolean;
  CIDToGIDMap: TQPLWordPairList;
  HasOwnCIDToGIDMap: Boolean;
  EncodingBuiltIn: Boolean;
  AdobeGIDType0: Boolean;
  GIDToCIDMap: Integer;
  GetCID: Boolean;
  CMap: AnsiString;
  IR: TPDFIndRef;
  CIDSystemInfoDict: TPDFDictionary;
  CIDSystemInfoStr: AnsiString;
  MissingWidth: Double;
  ToUnicode: AnsiString;
  CFFStream: TMemoryStream;
  SingleByteCMapEncoding: Boolean;
  CFFMS: TMemoryStream;
  Charset: Integer;
  CIDEncoding: AnsiString;
  WX, W2Count: Integer;
  WArray: TPDFArray;
  WFactor: Double;

{$IFNDEF QPL_OS_WINDOWS}
  procedure InstallFont;
  begin
  end;
{$ELSE}
  procedure InstallFont;
  var
    FS: TQuickPDFWideFileStream;
    TempName: WideString;
  begin
    if FInstallFonts and (FontFile <> '') then
    begin
      SetLength(TempName, 1024);
      SetLength(TempName, GetTempPathW(1023, @TempName[1]));
      if Copy(TempName, Length(TempName), 1) <> '\' then
        TempName := TempName + '\';
      TempName := TempName + 'QuickPDFTempFont' + WideString(IntToStr(TQPLIntPtr(RefOrDict))) + '.ttf';
      FS := QPLCreateFileStream(TempName, fmCreate);
      try
        FS.Write(FontFile[1], Length(FontFile));
      finally
        FS.Free;
      end;
      AddFontResourceW(@TempName[1]);
      ResourceList.Add(QPLUTF8Encode(TempName));
    end;
  end;
{$ENDIF}

  procedure MatchFont(Font: TFont);
  var
    X: Integer;
    MatchFontName: AnsiString;
    MatchFontName2: AnsiString;
    TestFontName: AnsiString;
    TestFontNameNoSpaces: AnsiString;
    Matched: Boolean;
    FontStyle: TFontStyles;
    Std: Integer;
  begin
    Matched := False;
    MatchFontName := FontName;

    if QPLEndsWith(MatchFontName, 'MT') then
      Delete(MatchFontName, Length(MatchFontName) - 1, 2);
    if QPLPos('MT-', MatchFontName) > 0 then
      Delete(MatchFontName, QPLPos('MT-', MatchFontName), 3);

    if (Length(MatchFontName) > 7) and (MatchFontName[7] = '+') then
    begin
      Matched := True;
      for X := 1 to 6 do
        if (MatchFontName[X] < 'A') or (MatchFontName[X] > 'Z') then
          Matched := False;
      if Matched then
      begin
        Delete(MatchFontName, 1, 7);
        Matched := False;
      end;
    end;

    Std := 0;
    for X := 1 to 14 do
    begin
      if QPLPos(MatchFontName + '*', BaseFonts[X]) > 0 then
        Std := X;
    end;
    if Std > 0 then
    begin
      MatchFontName := ReplacementFonts[Std];
    end;

    {
    if QPLPos('+', MatchFontName) > 0 then
      Delete(MatchFontName, QPLPos('+', MatchFontName), MaxInt);
    if QPLPos('-Bold', MatchFontName) > 0 then
      MatchFontName := QPLStringReplace(MatchFontName, '-Bold', ',Bold', [rfReplaceAll]);
    if QPLPos('-Medium', MatchFontName) > 0 then
      MatchFontName := QPLStringReplace(MatchFontName, '-Medium', ',Bold', [rfReplaceAll]);
    if QPLPos('-Italic', MatchFontName) > 0 then
      MatchFontName := QPLStringReplace(MatchFontName, '-Italic', ',Italic', [rfReplaceAll]);
    if QPLEndsWith(MatchFontName, '-It') then
      MatchFontName := QPLStringReplace(MatchFontName, '-It', ',Italic', [rfReplaceAll]);
    if QPLPos('-Oblique', MatchFontName) > 0 then
      MatchFontName := QPLStringReplace(MatchFontName, '-Oblique', ',Italic', [rfReplaceAll]);
    if QPLPos('-BoldItalic', MatchFontName) > 0 then
      MatchFontName := QPLStringReplace(MatchFontName, '-BoldItalic', ',BoldItalic', [rfReplaceAll]);
    if QPLPos('-BoldOblique', MatchFontName) > 0 then
      MatchFontName := QPLStringReplace(MatchFontName, '-BoldOblique', ',BoldItalic', [rfReplaceAll]);
    MatchFontName := QPLStringReplace(MatchFontName, ',Bold,Bold', ',Bold', [rfReplaceAll]);
    }

    if QPLPos('+', MatchFontName) > 0 then
      Delete(MatchFontName, QPLPos('+', MatchFontName), MaxInt);
    if (QPLEndsWith(MatchFontName, '-Bold')) then
      MatchFontName := QPLStringReplace(MatchFontName, '-Bold', ',Bold', [rfReplaceAll]);
    if (QPLEndsWith(MatchFontName, '-Medium')) then
      MatchFontName := QPLStringReplace(MatchFontName, '-Medium', ',Bold', [rfReplaceAll]);
    if (QPLEndsWith(MatchFontName, '-Italic')) then
      MatchFontName := QPLStringReplace(MatchFontName, '-Italic', ',Italic', [rfReplaceAll]);
    if (QPLEndsWith(MatchFontName, '-It')) then
      MatchFontName := QPLStringReplace(MatchFontName, '-It', ',Italic', [rfReplaceAll]);
    if (QPLEndsWith(MatchFontName, '-Oblique')) then
      MatchFontName := QPLStringReplace(MatchFontName, '-Oblique', ',Italic', [rfReplaceAll]);
    if (QPLEndsWith(MatchFontName, '-BoldItalic')) then
      MatchFontName := QPLStringReplace(MatchFontName, '-BoldItalic', ',BoldItalic', [rfReplaceAll]);
    if (QPLEndsWith(MatchFontName, '-BoldOblique')) then
      MatchFontName := QPLStringReplace(MatchFontName, '-BoldOblique', ',BoldItalic', [rfReplaceAll]);

    MatchFontName := QPLStringReplace(MatchFontName, ',Bold,Bold', ',Bold', [rfReplaceAll]);


    while QPLPos('-', MatchFontName) > 0 do
      Delete(MatchFontName, QPLPos('-', MatchFontName), 1);

    FontStyle := [];
    if QPLEndsWith(MatchFontName, ',Bold') then
    begin
      FontStyle := FontStyle + [fsBold];
      Delete(MatchFontName, Length(MatchFontName) - 4, 5);
    end;
    if QPLEndsWith(MatchFontName, ',Italic') then
    begin
      FontStyle := FontStyle + [fsItalic];
      Delete(MatchFontName, Length(MatchFontName) - 6, 7);
    end;
    if QPLEndsWith(MatchFontName, ',BoldItalic') then
    begin
      FontStyle := FontStyle + [fsBold, fsItalic];
      Delete(MatchFontName, Length(MatchFontName) - 10, 11);
    end;

    X := 0;

    if (fsBold in FontStyle) or (fsItalic in FontStyle) then
    begin
      while (not Matched) and (X < ScreenFonts.Count) do
      begin
        if (ScreenFonts[X][1] = MatchFontName[1]) then
        begin
          TestFontName := ScreenFonts[X];
          TestFontNameNoSpaces := TestFontName;

          while QPLPos(' ', TestFontNameNoSpaces) > 0 do  // Remove Spaces for matching purposes.
            Delete(TestFontNameNoSpaces, QPLPos(' ', TestFontNameNoSpaces), 1);

          while QPLPos('-', TestFontNameNoSpaces) > 0 do  // Remove Hyphens for matching purposes.
            Delete(TestFontNameNoSpaces, QPLPos('-', TestFontNameNoSpaces), 1);

          MatchFontName2 := MatchFontName;
          if fsBold in FontStyle then
          begin
            MatchFontName2 := MatchFontName + 'Bold';

            if (TestFontNameNoSpaces = MatchFontName2) then
            begin
              Matched := True;
              Font.Name := QPLAnsiToNative(ScreenFonts[X]);
              Font.Style := FontStyle;
            end;
          end;

          if fsItalic in FontStyle then
          begin
            MatchFontName2 := MatchFontName + 'Italic';

            if (TestFontNameNoSpaces = MatchFontName2) then
            begin
              Matched := True;
              Font.Name := QPLAnsiToNative(ScreenFonts[X]);
              Font.Style := FontStyle;
            end;
          end;
        end;

        if (not Matched) then
          Inc(X);
      end;
    end;

    X := 0;
    while (not Matched) and (X < ScreenFonts.Count) do
    begin

      if (ScreenFonts[X][1] = MatchFontName[1]) then
      begin
        TestFontName := ScreenFonts[X];
        TestFontNameNoSpaces := TestFontName;
        while QPLPos(' ', TestFontNameNoSpaces) > 0 do
          Delete(TestFontNameNoSpaces, QPLPos(' ', TestFontNameNoSpaces), 1);

        while QPLPos('-', TestFontNameNoSpaces) > 0 do
          Delete(TestFontNameNoSpaces, QPLPos('-', TestFontNameNoSpaces), 1);

        if (TestFontName = MatchFontName) or (TestFontNameNoSpaces = MatchFontName) then
        begin
          Matched := True;
          Font.Name := QPLAnsiToNative(ScreenFonts[X]);
          Font.Style := FontStyle;
        end else
        if TestFontName + 'Italic' = MatchFontName then
        begin
          Matched := True;
          Font.Name := QPLAnsiToNative(TestFontName);
          Font.Style := FontStyle + [fsItalic];
        end;
      end;

      if (not Matched) then
        Inc(X);
    end;

    if ((not Matched) and (QPLEndsWith(MatchFontName, 'Regular'))) then
    begin
      Delete(MatchFontName, Length(MatchFontName) - 6, 7);
      X := 0;
      while (not Matched) and (X < ScreenFonts.Count) do
      begin
        if (ScreenFonts[X][1] = MatchFontName[1]) then
        begin
          TestFontName := ScreenFonts[X];
          TestFontNameNoSpaces := TestFontName;
          while QPLPos(' ', TestFontNameNoSpaces) > 0 do
            Delete(TestFontNameNoSpaces, QPLPos(' ', TestFontNameNoSpaces), 1);
          while QPLPos('-', TestFontNameNoSpaces) > 0 do
            Delete(TestFontNameNoSpaces, QPLPos('-', TestFontNameNoSpaces), 1);

          if (TestFontName = MatchFontName) or (TestFontNameNoSpaces = MatchFontName) then
          begin
            Matched := True;
            Font.Name := QPLAnsiToNative(ScreenFonts[X]);
            Font.Style := FontStyle;
          end;
        end;

        if (not Matched) then
          Inc(X);
      end;
    end;

    if not Matched then
    begin
      Font.Name := 'Arial';
      if Flags and 1 = 1 then Font.Name := 'Courier New';
      if Flags and 2 = 2 then Font.Name := 'Times New Roman';
      if Flags and 64 = 64 then Font.Style := Font.Style + [fsItalic];
    end;
  end;

  function GetCIDSystemInfo(Obj: TPDFObject): AnsiString;
  begin
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      CIDSystemInfoDict := TPDFDictionary(Obj);
      Result := '';
      Obj := CIDSystemInfoDict.FindValueByKeyName('Registry');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFString then Result := TPDFString(Obj).AsString;
      Result := Result + '-';
      Obj := CIDSystemInfoDict.FindValueByKeyName('Ordering');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFString then Result := Result + TPDFString(Obj).AsString;
      Result := Result + '-';
      Obj := CIDSystemInfoDict.FindValueByKeyName('Supplement');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFNumeric then Result := Result +
        QPLIntToStr(TPDFNumeric(Obj).AsInteger);
    end;
  end;

  procedure UseFont(Encoding:AnsiString; Charset: Integer; Font1: AnsiString);
  var
    Font2: AnsiString;
    FontFound: Boolean;
  begin
    if (Assigned(Rasterizer)) then
    begin
      Rasterizer.Free;
    end;
    Rasterizer := TPDFSimpleTrueTypeRasterizer.Create;

    if QPLEndsWith(FontName, ',Bold') then
      TPDFSimpleTrueTypeRasterizer(Rasterizer).Font.Style := [fsBold];
    if QPLEndsWith(FontName,',Italic') then
      TPDFSimpleTrueTypeRasterizer(Rasterizer).Font.Style := [fsItalic];
    if QPLEndsWith(FontName, ',BoldItalic') then
      TPDFSimpleTrueTypeRasterizer(Rasterizer).Font.Style := [fsBold, fsItalic];

    FontFound := False;
    if (ScreenFonts(Charset, Flags).IndexOf(Font1) >= 0) then
    begin
      TPDFSimpleTrueTypeRasterizer(Rasterizer).Font.Name := string(Font1);
    end
    else
    begin
      // If Locale is set to Japanese, Chinese then the fonts have been renamed in Windows
      // and we need to use the localalised font names.  More fonts need to be added.
      // http://lewan.chez-alice.fr/050908asiamacfonts/fontfaces.html

      Font2 := '';

      // Use fontnames with spaces removed.
      if (QPLStartsWith(Font1, 'MS Mincho')) then
        Font2 := 'ÇlÇrñæí©';
      if (QPLStartsWith(Font1, 'MS PMincho')) then
        Font2 := 'ÇlÇrÇoñæí©';
      if (QPLStartsWith(Font1, 'MS Gothic')) then
        Font2 := 'ÇlÇrÉSÉVÉbÉN';
      if (QPLStartsWith(Font1, 'MS PGothic')) then
        Font2 := 'ÇlÇrÇoÉSÉVÉbÉN';

      if (QPLStartsWith(Font1, 'MingLiu')) then
        Font2 := 'ç◊ñæÈì';
      if (QPLStartsWith(Font1, 'PMingLiu')) then
        Font2 := 'êVç◊ñæÈì';
      if (QPLStartsWith(Font1, 'DFKai-SB')) then
        Font2 := 'ïWû≤Èì';
      if (QPLStartsWith(Font1, 'SimSun')) then
        Font2 := 'ëvÈì';
      if (QPLStartsWith(Font1, 'NSimSun')) then
        Font2 := 'êVëvÈì';

      if (Font2 <> '') and (ScreenFonts(Charset).IndexOf(Font2) >= 0) then
      begin
        TPDFSimpleTrueTypeRasterizer(Rasterizer).Font.Name := string(Font2);
        FontFound := True;
      end;

      if (Font2 <> '') and (not FontFound) then
      begin
        // Use fontnames with added spaces removed.
        if (QPLStartsWith(Font1, 'MS Mincho')) then
          Font2 := 'ÇlÇr ñæí©';
        if (QPLStartsWith(Font1, 'MS PMincho')) then
          Font2 := 'ÇlÇr Çoñæí©';
        if (QPLStartsWith(Font1, 'MS Gothic')) then
          Font2 := 'ÇlÇr ÉSÉVÉbÉN';
        if (QPLStartsWith(Font1, 'MS PGothic')) then
          Font2 := 'ÇlÇr ÇoÉSÉVÉbÉN';

        if (ScreenFonts(Charset).IndexOf(Font2) >= 0) then
        begin
          TPDFSimpleTrueTypeRasterizer(Rasterizer).Font.Name := string(Font2);
          FontFound := True;
        end;
      end;

      if (not FontFound) and (ScreenFonts(Charset, Flags).Count > 0) then
      begin
        MatchFont(TPDFSimpleTrueTypeRasterizer(Rasterizer).Font);
      end;
    end;
  end;

  // Based on http://partners.adobe.com/public/developer/en/font/5094.CJK_CID.pdf

  function GetCharset(Encoding, CIDSystemInfoStr: AnsiString) : Integer;
  const

    JapaneseEncodings: AnsiString =
     '*H*V*78-H*78-V*EUC-H*EUC-V*78-EUC-H*78-EUC-V*Ext-H*Ext-V*' +
     'NWP-H*NWP-V*Add-H*Add-V*Hankaku*Hiragana*Katakana*Roman*WP-Symbol*';

  begin
    GIDToCIDMap := GetCMap(Encoding);
    Result := 0;

    begin
      if (QPLPos('JIS', Encoding) > 0) or (QPLPos('RKSJ', Encoding) > 0) or (QPLPos('*' + Encoding + '*', JapaneseEncodings) > 0) then
      begin
        CIDToGIDMap := LoadCPToUnicode(932);
        Result := SHIFTJIS_CHARSET;
      end
      else if QPLPos('GB', Encoding) > 0  then
      begin
        CIDToGIDMap := LoadCPToUnicode(936);
        Result := GB2312_CHARSET;
      end
      else if (QPLPos('KSC', Encoding) > 0) or (QPLPos('UniKS', Encoding) > 0) then
      begin
        CIDToGIDMap := LoadCPToUnicode(949);
        Result := HANGEUL_CHARSET;
      end
      else if (QPLPos('B5', Encoding) > 0) or (QPLPos('CNS', Encoding) > 0)  then
      begin
        CIDToGIDMap := LoadCPToUnicode(950);
        Result := CHINESEBIG5_CHARSET;
      end

      else if ((QPLStartsWith(Encoding, 'UniGB-UCS2')) or
               (QPLStartsWith(Encoding, 'UniCNS-UCS2')) or
               (QPLStartsWith(Encoding, 'UniKS-UCS2')) or
               (QPLStartsWith(Encoding, 'UniJIS-UCS2'))) then

      begin
        CIDToGIDMap := nil;
        if QPLStartsWith(CIDSystemInfoStr, 'Adobe-Japan1-') then
          Result := SHIFTJIS_CHARSET
        else if QPLStartsWith(CIDSystemInfoStr, 'Adobe-GB1-') then
          Result := GB2312_CHARSET
        else if QPLStartsWith(CIDSystemInfoStr, 'Adobe-CNS1-') then
          Result := CHINESEBIG5_CHARSET
        else if QPLStartsWith(CIDSystemInfoStr, 'Adobe-Korea1-') then
          Result := HANGEUL_CHARSET;
      end
      else if QPLStartsWith(Encoding, 'Identity-') then
      begin
        if QPLStartsWith(CIDSystemInfoStr, 'Adobe-Japan1-') then
        begin
          CIDToGIDMap := LoadCPToUnicode(932);
          Result := SHIFTJIS_CHARSET;
        end
        else if QPLStartsWith(CIDSystemInfoStr, 'Adobe-GB1-') then
        begin
          CIDToGIDMap := LoadCPToUnicode(936);
          Result := GB2312_CHARSET
        end
        else if QPLStartsWith(CIDSystemInfoStr, 'Adobe-Korea1-') then
        begin
          CIDToGIDMap := LoadCPToUnicode(949);
          Result := HANGEUL_CHARSET;
        end
        else if QPLStartsWith(CIDSystemInfoStr, 'Adobe-CNS1-') then
        begin
          CIDToGIDMap := LoadCPToUnicode(950);
          Result := CHINESEBIG5_CHARSET
        end;
      end
    end;
  end;

  procedure DecodeCIDToGIDMap(S: AnsiString);
  var
    Charcode :Word;
    Len: Integer;
  begin
    Len := Integer(Length(S)) div 2;

    for CharCode := 0 to Len - 1 do
      CIDToGIDMap.Add(CharCode, (Ord(S[CharCode * 2 + 1]) shl 8) + Ord(S[CharCode * 2 + 2]));
  end;

  function GetW2DictCount: Integer;
  begin
    Result := 0;
    Obj := Font.FindValueByKeyName('W2', True);
    if (Obj is TPDFArray) and (TPDFArray(Obj).Count > 1) then
    begin
      WArray := TPDFArray(Obj);
      WX := 0;
      while WX < (WArray.Count - 1) do
      begin
        if WArray.Item[WX] is TPDFNumeric then
        begin
          if WArray.Item[WX + 1] is TPDFNumeric then
          begin
            WX := WX + 5;
            Inc(Result);
          end
          else if WArray.Item[WX + 1] is TPDFArray then
          begin
            Inc(Result, TPDFArray(WArray.Item[WX + 1]).Count);
            Inc(WX, 2);
          end;
        end
        else if WArray.Item[WX + 1] is TPDFArray then
        begin
          Inc(Result, TPDFArray(WArray.Item[WX + 1]).Count div 3);
          Inc(WX, 2);
        end;
      end;
    end;
  end;

  procedure ProcessW2Dict;
  var
    I, J: Integer;
    A: TPDFArray;
  begin
    Obj := Font.FindValueByKeyName('DW2');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFArray then
    begin
      if (TPDFArray(Obj).Count = 2) and (TPDFArray(Obj).Item[0] is TPDFNumeric) and
        (TPDFArray(Obj).Item[0] is TPDFNumeric) then
      begin
        DW2_v := TPDFNumeric(TPDFArray(Obj).Item[0]).AsInteger;
        DW2_w1 := TPDFNumeric(TPDFArray(Obj).Item[1]).AsInteger;
      end;
    end;

    W2Count := GetW2DictCount;
    if (W2Count > 0) then
    begin
      SetLength(W2, W2Count);

      WArray := TPDFArray(Obj);
      I := 0;
      WX := 0;
      while WX < (WArray.Count - 1) do
      begin
        if WArray.Item[WX] is TPDFNumeric then
        begin
          if WArray.Item[WX + 1] is TPDFNumeric then
          begin
            W2[I].StartCID := TPDFNumeric(WArray.Item[WX + 0]).AsInteger;
            W2[I].EndCID := TPDFNumeric(WArray.Item[WX + 1]).AsInteger;
            W2[I].w1y := TPDFNumeric(WArray.Item[WX + 2]).AsInteger;
            W2[I].v1x := TPDFNumeric(WArray.Item[WX + 3]).AsInteger;
            W2[I].v1y := TPDFNumeric(WArray.Item[WX + 4]).AsInteger;
            WX := WX + 5;
            Inc(I);
          end
          else if WArray.Item[WX + 1] is TPDFArray then
          begin
            A := TPDFArray(WArray.Item[WX + 1]);
            J := 0;
            while (J < A.Count) do
            begin
              W2[I].StartCID := TPDFNumeric(WArray.Item[WX + 0]).AsInteger + J;
              W2[I].EndCID := W2[I].StartCID;
              W2[I].w1y := TPDFNumeric(A.Item[J + 0]).AsInteger;
              W2[I].v1x := TPDFNumeric(A.Item[J + 1]).AsInteger;
              W2[I].v1y := TPDFNumeric(A.Item[J + 2]).AsInteger;
              Inc(I);
              Inc(J, 3);
              Inc(WX, 2);
            end;
          end;
        end
        else if WArray.Item[WX + 1] is TPDFArray then
        begin
          A := TPDFArray(WArray.Item[WX + 1]);
          J := 0;
          while (J < A.Count) do
          begin
            W2[I].StartCID := TPDFNumeric(WArray.Item[WX + 0]).AsInteger + J;
            W2[I].EndCID := W2[I].StartCID;
            W2[I].w1y := TPDFNumeric(A.Item[J + 0]).AsInteger;
            W2[I].v1x := TPDFNumeric(A.Item[J + 1]).AsInteger;
            W2[I].v1y := TPDFNumeric(A.Item[J + 2]).AsInteger;
            Inc(I);
            Inc(J, 3);
            Inc(WX, 2);
          end;
        end;
      end;
    end;
  end;

begin
  Font := nil;
  GetCID := False;
  FirstChar := 0;
  LastChar := 0;

  DW := 1000;
  DW2_v := 880;
  DW2_w1 := -1000;
  W2Count := 0;
  WFactor := 1.0;

  Enc := peStandard;
  EncStr := '';
  GetCharsetNames(peStandard, CSN);

  FontName := 'Arial';
  Rasterizer := nil;
  Differences := nil;
  OldDifferences := nil;
  CIDWidths := nil;
  StdFontIndex := 0;
  Flags := 0;
  Ascent := 0;
  Descent := 0;
  CapHeight := 0;
  Bound.Left := 0;
  Bound.Right := 0;
  Bound.Top := 0;
  Bound.Bottom := 0;

  CMap := '';
  SingleByteCMapEncoding := False;
  GIDToCIDMap := -1;
  CIDSystemInfoStr := '';
  CIDEncoding := '';
  CIDToGIDMap := nil;
  HasOwnCIDToGIDMap := False;
  EncodingBuiltIn := False;
  AdobeGIDType0 := False;
  Panose := '';
  Embedded := False;
  Subsetted := False;

  if RefOrDict is TPDFIndRef then
    Obj := FindObject(TPDFIndRef(RefOrDict))
  else
    Obj := RefOrDict;

  if Obj is TPDFDictionary then
  begin
    Font := TPDFDictionary(Obj);

    Obj := Font.FindValueByKeyName('FontDescriptor');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      FontDescriptor := TPDFDictionary(Obj);
    end else
    begin
      FontDescriptor := nil;
    end;

    MissingWidth := 0;

    if (Assigned(FontDescriptor)) then
    begin
      Obj := FontDescriptor.FindValueByKeyName('MissingWidth');
      if Obj is TPDFIndRef then FindObject(TPDFIndRef(Obj));
      if Obj is TPDFNumeric then
      begin
        MissingWidth := TPDFNumeric(Obj).AsDouble;
      end;
    end;

    for X := 0 to 255 do
      Widths[X] := MissingWidth;

    Obj := Font.FindValueByKeyName('BaseFont', False);
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFName then
    begin
      FontName := TPDFName(Obj).Name;
      if (Length(FontName) > 7) and (FontName[7] = '+') then
        Subsetted := True;
    end;

    Obj := Font.FindValueByKeyName('Encoding', False);
    if Obj is TPDFIndRef then
    begin
      IR := TPDFIndRef(Obj);
      Obj := FindObject(IR);
    end;
    if Obj is TPDFName then
    begin
      EncStr := TPDFName(Obj).Name;
      if EncStr = 'StandardEncoding' then Enc := peStandard;
      if EncStr = 'WinAnsiEncoding' then Enc := peWinAnsi;
      if EncStr = 'MacRomanEncoding' then Enc := peMacRoman;
      if EncStr = 'PDFDocEncoding' then Enc := pePDFDoc;
      if EncStr = 'MacExpertEncoding' then Enc := peMacExpertEncoding;
    end else
    if Obj is TPDFDictionary then
    begin
      Encoding := TPDFDictionary(Obj);
      Obj := Encoding.FindValueByKeyName('BaseEncoding');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFName then
      begin
        EncStr := TPDFName(Obj).Name;
        if EncStr = 'StandardEncoding' then Enc := peStandard;
        if EncStr = 'WinAnsiEncoding' then Enc := peWinAnsi;
        if EncStr = 'MacRomanEncoding' then Enc := peMacRoman;
        if EncStr = 'PDFDocEncoding' then Enc := pePDFDoc;
        if EncStr = 'MacExpertEncoding' then Enc := peMacExpertEncoding;
      end;
      Obj := Encoding.FindValueByKeyName('Differences', False);
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFArray then
        Differences := TPDFArray(Obj);
    end;

    GetCharsetNames(Enc, CSN);

    Obj := Font.FindValueByKeyName('FontBBox', True);
    if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 4) then
      begin
        BBox := TPDFArray(Obj);
        Obj := BBox.Item[0];
        if Obj is TPDFNumeric then Bound.Left := TPDFNumeric(Obj).AsInteger;
        Obj := BBox.Item[1];
        if Obj is TPDFNumeric then Bound.Bottom := TPDFNumeric(Obj).AsInteger;
        Obj := BBox.Item[2];
        if Obj is TPDFNumeric then Bound.Right := TPDFNumeric(Obj).AsInteger;
        Obj := BBox.Item[3];
        if Obj is TPDFNumeric then Bound.Top := TPDFNumeric(Obj).AsInteger;
      end;

    Obj := Font.FindValueByKeyName('Subtype');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFName then
    begin
      SubType := TPDFName(Obj).Name;

      if (SubType = 'CIDFontType0') or (SubType = 'CIDFontType2') then
      begin
        Obj := Font.FindValueByKeyName('CIDSystemInfo');
        if (Obj <> nil) then
          CIDSystemInfoStr := GetCIDSystemInfo(Obj);

        Obj := nil;
        if (Assigned(ParentDict)) then
          Obj := ParentDict.FindValueByKeyName('Encoding');

        IR := nil;
        if Obj is TPDFIndRef then
        begin
          IR := TPDFIndRef(Obj);
          Obj := FindObject(IR);
        end;

        if (Obj is TPDFName) then
        begin
          CIDEncoding := TPDFName(Obj).Name;
        end
        else if Obj is TPDFStream then
        begin

          if Assigned(FOnDecrypt) and Assigned(IR) then
            FOnDecrypt(TPDFStream(Obj), IR);
          EncStr := TPDFStream(Obj).GetDecodedStream;
          if Assigned(FOnEncrypt) and Assigned(IR) then
            FOnEncrypt(TPDFStream(Obj), IR);

          Obj := TPDFStream(Obj).Dictionary.FindValueByKeyName('CMapName', true);
          if (Obj is TPDFName) then
            CIDEncoding := TPDFName(Obj).Name;

          if (CIDEncoding <> '') then
          begin
            GIDToCIDMap := ResourcesAddCMapFromString(CIDEncoding, EncStr);
            EncodingBuiltIn := True;
          end;

          EncStr := '';
        end;

        if (CIDEncoding <> '') then
          GIDToCIDMap := GetCMap(CIDEncoding);

        if (Assigned(FontDescriptor)) then
        begin
          Obj := FontDescriptor.FindValueByKeyName('Style', True);
          if (Obj is TPDFDictionary) then
          begin
            Obj := TPDFDictionary(Obj).FindValueByKeyName('Panose');
            if (Obj is TPDFString) then
            begin
              Panose := TPDFString(Obj).AsString;
            end;
          end;
        end;

        if (Assigned(ParentDict)) then
          begin
          Obj := ParentDict.FindValueByKeyName('DescendantFonts');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 1) then
          begin
            Obj :=TPDFArray(Obj).Item[0];
            if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));

            if (Obj is TPDFDictionary) then
            begin
              DW := 1000;
              Obj := TPDFDictionary(Obj).FindValueByKeyName('DW');
              if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
              if Obj is TPDFNumeric then DW := TPDFNumeric(Obj).AsInteger;
            end;
          end;
        end;


      end;

      if (SubType = 'Type1') or (SubType = 'MMType1') or (SubType = 'CIDFontType0') then
      begin
        if (Assigned(FontDescriptor)) then
        begin
          Obj := FontDescriptor.FindValueByKeyName('Ascent');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFNumeric then
          begin
            Ascent := TPDFNumeric(Obj).AsInteger;
            if (Abs(Ascent) <= 1) then
            begin
              Ascent := TPDFNumeric(Obj).AsDouble * 1000;
            end;
          end;
          Obj := FontDescriptor.FindValueByKeyName('Descent');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFNumeric then
          begin
            Descent := TPDFNumeric(Obj).AsInteger;
            if (Abs(Descent) <= 1) then
            begin
              Descent := TPDFNumeric(Obj).AsDouble * 1000;
            end;
          end;

          Obj := FontDescriptor.FindValueByKeyName('FontBBox', True);
          if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 4) then
          begin
            BBox := TPDFArray(Obj);
            Obj := BBox.Item[0];
            if Obj is TPDFNumeric then Bound.Left := TPDFNumeric(Obj).AsInteger;
            Obj := BBox.Item[1];
            if Obj is TPDFNumeric then Bound.Bottom := TPDFNumeric(Obj).AsInteger;
            Obj := BBox.Item[2];
            if Obj is TPDFNumeric then Bound.Right := TPDFNumeric(Obj).AsInteger;
            Obj := BBox.Item[3];
            if Obj is TPDFNumeric then Bound.Top := TPDFNumeric(Obj).AsInteger;
          end;

          Obj := FontDescriptor.FindValueByKeyName('Flags');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFNumeric then
            Flags := TPDFNumeric(Obj).AsInteger;
          Obj := FontDescriptor.FindValueByKeyName('FontFile');
          IR := nil;
          if Obj is TPDFIndRef then
          begin
            IR := TPDFIndRef(Obj);
            Obj := FindObject(IR);
          end;
          if Obj is TPDFStream then
          begin
            if FInstallFonts then
            begin
              Rasterizer := TPDFType1Decoder.Create;
              TPDFType1Decoder(Rasterizer).OnFindObject := FOnFindObject;

              if Assigned(FOnDecrypt) and Assigned(IR) then
                FOnDecrypt(TPDFStream(Obj), IR);
              TPDFType1Decoder(Rasterizer).LoadPFBFromPDFStream(TPDFStream(Obj));
              if Assigned(FOnEncrypt) and Assigned(IR) then
                FOnEncrypt(TPDFStream(Obj), IR);

              TPDFType1Decoder(Rasterizer).DecodeFontDict;
              if (not TPDFType1Decoder(Rasterizer).DecodeEncryptedPortion) then
              begin
                Rasterizer.Free;
                Rasterizer := nil;
              end;
            end;
            begin
            if (Assigned(Rasterizer)) and (EncStr = '') then
              CSN := TPDFType1Decoder(Rasterizer).GetEncoding;
            end;

            Embedded := True;

          end;
          Obj := FontDescriptor.FindValueByKeyName('FontFile3');
          IR := nil;
          if Obj is TPDFIndRef then
          begin
            IR := TPDFIndRef(Obj);
            Obj := FindObject(IR);
          end;
          if Obj is TPDFStream then
          begin
            Rasterizer := TPDFType1Decoder.Create;
            if Assigned(FOnDecrypt) and Assigned(IR) then
              FOnDecrypt(TPDFStream(Obj), IR);
            TPDFType1Decoder(Rasterizer).LoadCFFFromPDFStream(TPDFStream(Obj));
            if Assigned(FOnEncrypt) and Assigned(IR) then
              FOnEncrypt(TPDFStream(Obj), IR);
            if (EncStr = '') {or (Flags and 4 = 4)} then
              CSN := TPDFType1Decoder(Rasterizer).GetEncoding;

            Embedded := True;
          end;

          if not Assigned(Rasterizer) then
          begin

            if (CIDEncoding <> '') then
            begin

              Charset := GetCharset(CIDEncoding, CIDSystemInfoStr);     // Also sets CIDToGIDMap - 'CIDFontType0'

              if (QPLStartsWith(FontName, 'HeiseiKakuGo-W5')) then
              begin
                UseFont(CIDEncoding, Charset, 'MS Gothic');
              end
              else if (QPLStartsWith(FontName, 'HYGoThic')) then
                UseFont(CIDEncoding, Charset, 'Dotum')

              else if (QPLStartsWith(FontName, 'STSongStd-Light-Acro')) then
                UseFont(CIDEncoding, Charset, 'MS Mincho')

              else if (QPLStartsWith(FontName, 'AdobeSongStd-Light')) then
                UseFont(CIDEncoding, Charset, 'MS PMincho')

              else if (QPLStartsWith(FontName, 'AdobeMingStd-Light')) then
                UseFont(CIDEncoding, Charset, 'MS Mincho')

              else if (QPLStartsWith(FontName, 'KozMinPr6N')) then
                UseFont(CIDEncoding, Charset, 'MS PMincho')

              else if (QPLStartsWith(FontName, 'KozGoPr6N')) then
                UseFont(CIDEncoding, Charset, 'MS PGothic')

              {
              else if (QPLStartsWith(FontName, 'KozMinPr6N')) then
                UseFont(CIDEncoding, Charset, 'Kozuka Mincho Pr6N R')

              else if (QPLStartsWith(FontName, 'KozGoPr6N')) then
                UseFont(CIDEncoding, Charset, 'Kozuka Gothic Pr6N M')
              }

              else if (QPLStartsWith(FontName, 'GothicBBB')) then
                UseFont(CIDEncoding, Charset, 'MS PGothic')

              else if (QPLStartsWith(FontName, 'Ryumin-Light')) then
                UseFont(CIDEncoding, Charset, 'MS Mincho')

              else if (QPLStartsWith(FontName, 'RodinPlus-DB')) then
                UseFont(CIDEncoding, Charset, 'MS PGothic')

              else if (QPLStartsWith(FontName, 'MatissePlus-DB')) then
                UseFont(CIDEncoding, Charset, 'MS PMincho')

              else if (QPLStartsWith(FontName, 'MatissePlus-M')) then
                UseFont(CIDEncoding, Charset, 'MS PMincho')

              else if (QPLStartsWith(FontName, 'MatissePlus-B')) then
                UseFont(CIDEncoding, Charset, 'MS Mincho')

              else if (Length(Panose) <> 0) then
              begin
                if (Panose[1] = #2) and (Panose[2] = #11) and (Panose[4] = #9) then
                  UseFont(CIDEncoding, Charset, 'MS PGothic')
                else if (Panose[1] = #2) and (Panose[2] = #11) and (Panose[4] = #0) then
                  UseFont(CIDEncoding, Charset, 'MS Gothic')
                else if (Panose[1] = #2) and (Panose[2] = #2) and (Panose[4] = #9) then
                  UseFont(CIDEncoding, Charset, 'MS PMincho')
                else if (Panose[1] = #2) and (Panose[2] = #2) and (Panose[4] = #0) then
                  UseFont(CIDEncoding, Charset, 'MS Mincho')
                else
                  UseFont(CIDEncoding, Charset, 'MS Mincho');
              end

              else if (Flags and 1 = 1) then    // Fixed Pitch
              begin
                if (Flags and 2 = 2) then       // Serif
                  UseFont(CIDEncoding, Charset, 'MS PMincho')

                else if (Flags and 4 = 4) then  // Symbolic
                  UseFont(CIDEncoding, Charset, 'MS PGothic')

                else if (Flags and 8 = 8) then  // Script
                  UseFont(CIDEncoding, Charset, 'MS PMincho')
                else
                  UseFont(CIDEncoding, Charset, 'MS Mincho');
              end
              else
              begin
                if (Flags and 2 = 2) then       // Serif
                  UseFont(CIDEncoding, Charset, 'MS Mincho')

                else if (Flags and 4 = 4) then  // Symbolic
                  UseFont(CIDEncoding, Charset, 'MS Gothic')

                else if (Flags and 8 = 8) then  // Script
                  UseFont(CIDEncoding, Charset, 'MS Mincho')

                else
                  UseFont(CIDEncoding, Charset, 'MS Mincho');
              end
            end
            else if (Obj is TPDFStream) then
            begin

            end;

            {  // CIDFonts included with Acrobat - Need to find alternate fonts.
            AdobeArabic-Bold, AdobeArabic-BoldItalic,
            AdobeArabic-Italic, AdobeArabic-Regular
            AdobeHebrew-Bold, AdobeHebrew-BoldItalic
            AdobeHebrew-Italic, AdobeHebrew-Regular
            AdobePIStd, AdobeThai-Bold, AdobeThai-BoldItalic
            AdobeThai-Italic, AdobeThai-Regular
            }

            if (SubType = 'CIDFontType0') and (CIDSystemInfoStr = 'Adobe-Identity-0') then
            begin
              AdobeGIDType0 := True;
              if (FontName = 'CourierStd-Bold') then
                FontName := 'Courier,Bold';
              if (FontName = 'CourierStd-BoldOblique') then
                FontName := 'Courier,BoldItalic';
              if (FontName = 'CourierStd-Oblique') then
                FontName := 'Courier,Italic;';
              if (FontName = 'CourierStd') then
                FontName := 'Courier';

              Charset := GetCharset(CIDEncoding, CIDSystemInfoStr);
              UseFont(CIDEncoding, Charset, FontName);
            end;
          end;

        end else
        begin
          Obj := Font.FindValueByKeyName('BaseFont');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          StdFontIndex := 0;
          if Obj is TPDFName then
          begin

            MatchFontName := TPDFName(Obj).Name;
            if QPLEndsWith(MatchFontName, 'MT') then
              Delete(MatchFontName, Length(MatchFontName) - 1, 2);
            if QPLPos('MT-', MatchFontName) > 0 then
              Delete(MatchFontName, QPLPos('MT-', MatchFontName), 3);

            for GX := 1 to 14 do
            begin
              if QPLPos(MatchFontName + '*', BaseFonts[GX]) > 0 then
                StdFontIndex := GX;
            end;
          end;
          if (StdFontIndex >= 1) and (StdFontIndex <= 14) then
          begin
            Ascent := FontMetrics[StdFontIndex, 5];
            Descent := FontMetrics[StdFontIndex, 6];

            if (StdFontIndex = 13) then
            begin
              // Symbol font, use the Symbol encoding
              Enc := peSymbol;

              // Retrieve the U+xxxx Unicode names for the symbol glyphs
              GetUnicodeNames(Enc, CSN);
            end;

            if FInstallFonts then
            begin
              if StdFontIndex = 14 then
              begin
                FontName := 'DBNDingbats';
                Rasterizer := TPDFTrueTypeRasterizer2.Create;
                TPDFTrueTypeRasterizer2(Rasterizer).Parser.LoadFromString(GetDingbats);
              end else
              begin
                FontName := ReplacementFonts[StdFontIndex];
                if (FDirectFonts) then
                begin
                  Rasterizer := TPDFSimpleTrueTypeRasterizer.Create;
                  MatchFont(TPDFSimpleTrueTypeRasterizer(Rasterizer).Font);
                end else
                begin
                  Rasterizer := TPDFTrueTypeRasterizer2.Create;
                  MatchFont(TPDFTrueTypeRasterizer2(Rasterizer).Font);
                  TPDFTrueTypeRasterizer2(Rasterizer).LoadFromFont;
                end;
              end;

            end;
          end;
        end;
      end else
      if (SubType = 'TrueType') or (SubType = 'CIDFontType2') then
      begin
        Obj := Font.FindValueByKeyName('FontDescriptor');
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFDictionary then
        begin
          FontDescriptor := TPDFDictionary(Obj);
          Obj := FontDescriptor.FindValueByKeyName('Ascent');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFNumeric then
          begin
            Ascent := TPDFNumeric(Obj).AsInteger;
            if (Abs(Ascent) <= 1) then
            begin
              Ascent := TPDFNumeric(Obj).AsDouble * 1000;
            end;
          end;
          Obj := FontDescriptor.FindValueByKeyName('Descent');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFNumeric then
          begin
            Descent := TPDFNumeric(Obj).AsInteger;
            if (Abs(Descent) <= 1) then
            begin
              Descent := TPDFNumeric(Obj).AsDouble * 1000;
            end;
          end;

          Obj := FontDescriptor.FindValueByKeyName('FontBBox', True);
          if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 4) then
          begin
            BBox := TPDFArray(Obj);
            Obj := BBox.Item[0];
            if Obj is TPDFNumeric then Bound.Left := TPDFNumeric(Obj).AsInteger;
            Obj := BBox.Item[1];
            if Obj is TPDFNumeric then Bound.Bottom := TPDFNumeric(Obj).AsInteger;
            Obj := BBox.Item[2];
            if Obj is TPDFNumeric then Bound.Right := TPDFNumeric(Obj).AsInteger;
            Obj := BBox.Item[3];
            if Obj is TPDFNumeric then Bound.Top := TPDFNumeric(Obj).AsInteger;
          end;

          Obj := FontDescriptor.FindValueByKeyName('CapHeight');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFNumeric then
          begin
            CapHeight := TPDFNumeric(Obj).AsInteger;
            if (Abs(CapHeight) <= 1) then
            begin
              CapHeight := TPDFNumeric(Obj).AsDouble * 1000;
            end;
          end;

          if (Ascent < Descent) or ((Ascent = 0) and (Descent = 0)) then
          begin
            Ascent := -Ascent + CapHeight;
            Descent := -Descent;
          end;
          if (Descent > 0) then
          begin
            Descent := Descent;
          end;

          Obj := FontDescriptor.FindValueByKeyName('Flags');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFNumeric then
            Flags := TPDFNumeric(Obj).AsInteger;
          Obj := FontDescriptor.FindValueByKeyName('FontFile2');

          // Font name - OMPEMC+DFKaiShu-SB-Estd-BF
          FamilyName := FontName;
          if (Length(FamilyName) > 7) and (FamilyName[7] = '+') then
            FamilyName := QPLCopy(FontName, 8, 99);

          // This code replaces any embedded DFKaiShu with a nonembedded font
          // be setting for FontFile2 pointer to nil so the fontdata is not
          // and the font will then be provided by Windows
          // http://lists.freedesktop.org/archives/poppler/2010-August/006286.html
          // Also see FT_FACE_FLAG_TRICKY in FreeType documentation notes.

          //if (QPLStartsWith(FamilyName, 'DFKaiShu')) then
          //  Obj := nil;

          IR := nil;
          if Obj is TPDFIndRef then
          begin
            IR := TPDFIndRef(Obj);
            Obj := FindObject(IR);
          end;
          if FInstallFonts then
          begin
            if (Obj is TPDFStream) then
            begin
              if Assigned(FOnDecrypt) and Assigned(IR) then
                FOnDecrypt(TPDFStream(Obj), IR);

              //FontFile := TPDFStream(Obj).GetDecodedStream;
              FontFile := TPDFStream(Obj).GetDecodedStreamWithLookup(FOnFindObject);

              if Assigned(FOnEncrypt) and Assigned(IR) then
                FOnEncrypt(TPDFStream(Obj), IR);
              //InstallFont;

              Embedded := True;

            end;
            if FontFile <> '' then
            begin
              if (QPLPos('!PS-AdobeFont', QPLCopy(FontFile, 1, 100)) > 0) then
              begin
                Rasterizer := TPDFType1Decoder.Create;
                TPDFType1Decoder(Rasterizer).OnFindObject := FOnFindObject;
                TPDFType1Decoder(Rasterizer).LoadPFBFromString(FontFile);
                TPDFType1Decoder(Rasterizer).DecodeFontDict;
                TPDFType1Decoder(Rasterizer).DecodeEncryptedPortion;
                if (EncStr = '') or (Flags and 4 = 4) then
                  CSN := TPDFType1Decoder(Rasterizer).GetEncoding;
              end else
              begin
                Rasterizer := TPDFTrueTypeRasterizer2.Create;
                TPDFTrueTypeRasterizer2(Rasterizer).Parser.LoadFromString(FontFile);

                //if (TPDFTrueTypeRasterizer2(Rasterizer).Parser.GetHeadTable.unitsPerEm = 2048) then
                //  WFactor := 2.048;

                if (TPDFTrueTypeRasterizer2(Rasterizer).Parser.GetCFFDataPosition > 0) then
                begin
                  TPDFTrueTypeRasterizer2(Rasterizer).Free;
                  Rasterizer := TPDFType1Decoder.Create;
                  CFFMS := TMemoryStream.Create;
                  try
                    CFFMS.Write(FontFile[1], Length(FontFile));
                    CFFMS.Seek(0, soFromBeginning);
                    TPDFType1Decoder(Rasterizer).LoadCFFFromStream(CFFMS);
                  finally
                    CFFMS.Free;
                  end;
                end else
                begin
                  TPDFTrueTypeRasterizer2(Rasterizer).SetFlags(Flags);
                  if TPDFTrueTypeRasterizer2(Rasterizer).Symbolic then
                  begin
                    GetCID := True;
                    for X := 0 to 255 do
                      CSN[X] := 'CID:' + QPLIntToStr(X);
                    OldDifferences := Differences;

                    if (not FUsingTextFunnel) then
                    begin
                      Differences := nil;
                    end;
                  end;
                end;
              end;
            end else
            begin
              // The font is a non-embedded composite font. A system
              // font will be used so the mapping must be converted to
              // Unicode

              if (CIDEncoding <> '') then
              begin
                Charset := GetCharset(CIDEncoding, CIDSystemInfoStr);           // Also sets CIDToGIDMap - 'CIDFontType2'

                if (QPLStartsWith(FontName, 'HGPGothicE')) then
                  UseFont(CIDEncoding, Charset, 'MS PGothic')

                else if (QPLStartsWith(FontName, 'HGPSoeiKakugothicUB')) then
                begin
                  if (Flags and 14 = 14) then
                    UseFont(CIDEncoding, Charset, 'MS PMincho')
                  else
                    UseFont(CIDEncoding, Charset, 'MS PGothic');
                end

                else if (QPLStartsWith(FontName, 'HGSSoeiKakugothicUB')) then
                begin
                  if (Flags and 14 = 14) then
                    UseFont(CIDEncoding, Charset, 'MS PMincho')
                  else
                    UseFont(CIDEncoding, Charset, 'MS PGothic');
                end

                else if (QPLStartsWith(FontName, 'HGSSoeiKakupoptai')) then
                  UseFont(CIDEncoding, Charset, 'MS PGothic')

                else if (QPLStartsWith(FontName, 'SimSun')) then
                  UseFont(CIDEncoding, Charset, 'SimSun')

                else if (QPLStartsWith(FontName, 'HYSMyeongJo')) then
                  UseFont(CIDEncoding, Charset, 'SimSun')

                else if (QPLStartsWith(FontName, 'HGPSoeiKakupoptai')) then
                  UseFont(CIDEncoding, Charset, 'MS PMincho')

                else if (QPLStartsWith(FontName, 'YentiEGP-Medium-SJIS')) then
                  UseFont(CIDEncoding, Charset, 'MS PGothic')

                else if (QPLStartsWith(FontName, 'HGPSoeiPresenceEB')) then
                  UseFont(CIDEncoding, Charset, 'MS PMincho')

                else if (QPLStartsWith(FontName, 'MS-Mincho')) then
                  UseFont(CIDEncoding, SHIFTJIS_CHARSET, 'MS Mincho')

                else if (QPLStartsWith(FontName, 'MS-PGothic')) then
                  UseFont(CIDEncoding, Charset, 'MS PGothic')

                else if (QPLStartsWith(FontName, 'MS-Gothic')) then
                  UseFont(CIDEncoding, Charset, 'MS Gothic')

                else if (QPLStartsWith(FontName, 'Century')) then
                  UseFont(CIDEncoding, Charset, 'MS Gothic')

                else if (QPLStartsWith(FontName, 'ÇlÇrÇoñæí©')) then
                  UseFont(CIDEncoding, Charset, 'MS PMincho')

                else if (QPLStartsWith(FontName, 'ÇlÇrñæí©')) then
                  UseFont(CIDEncoding, Charset, 'MS Mincho')

                // Add spaces into font name
                else if (QPLStartsWith(FontName, 'ÇlÇrÇoÉSÉVÉbÉN')) then
                  UseFont(CIDEncoding, Charset, 'MS PGothic')

                else if (QPLStartsWith(FontName, 'ÇlÇrÉSÉVÉbÉN')) then
                  UseFont(CIDEncoding, Charset, 'MS Gothic')

                else if (QPLStartsWith(FontName, 'ÇlÇrÇo ñæí©')) then
                  UseFont(CIDEncoding, Charset, 'MS PMincho')

                else if (QPLStartsWith(FontName, 'ÇlÇr ñæí©')) then
                  UseFont(CIDEncoding, Charset, 'MS Mincho')

                else if (QPLStartsWith(FontName, 'ÇlÇrÇo ÉSÉVÉbÉN')) then
                  UseFont(CIDEncoding, Charset, 'MS PGothic')

                else if (QPLStartsWith(FontName, 'ÇlÇr ÉSÉVÉbÉN')) then
                  UseFont(CIDEncoding, Charset, 'MS Gothic')


                else if (QPLStartsWith(FontName, 'Meiryo')) then
                  UseFont(CIDEncoding, Charset, 'MS PGothic')

                else if (QPLStartsWith(FontName, 'ç◊ñæÈì')) then
                  UseFont(CIDEncoding, Charset, 'MingLiu')

                else if (QPLStartsWith(FontName, 'êVç◊ñæÈì')) then
                  UseFont(CIDEncoding, Charset, 'PMingLiu')

                else if (QPLStartsWith(FontName, 'ïWû≤Èì')) then
                  UseFont(CIDEncoding, Charset, 'DFKai-SB')

                else if (QPLStartsWith(FontName, 'ëvÈì')) then
                  UseFont(CIDEncoding, Charset, 'SimSun')

                else if (QPLStartsWith(FontName, 'êVëvÈì')) then
                  UseFont(CIDEncoding, Charset, 'NSimSun')

                else if (QPLStartsWith(FontName, 'RodinPlus-DB')) then
                  UseFont(CIDEncoding, Charset, 'MS PGothic')

                else if (QPLStartsWith(FontName, 'MatissePlus-DB')) then
                  UseFont(CIDEncoding, Charset, 'MS PGothic')

                else if (QPLStartsWith(FontName, 'MatissePlus-M')) then
                  UseFont(CIDEncoding, Charset, 'MS PGothic')

                else if (QPLStartsWith(FontName, 'MatissePlus-B')) then
                  UseFont(CIDEncoding, Charset, 'MS PGothic')

                else if (QPLStartsWith(FontName, 'HGMaruGothicMPRO')) then
                  UseFont(CIDEncoding, Charset, 'MS PMincho')

                else if (QPLStartsWith(FontName, 'DFKaiShu-SB-Estd-BF')) then
                  UseFont(CIDEncoding, Charset, 'DFKai-SB')

                else if (QPLStartsWith(FontName, 'PMingLiU')) then
                  UseFont(CIDEncoding, Charset, 'PMingLiU')

                else if (Length(Panose) <> 0) then
                begin
                  if (Panose[1] = #2) and (Panose[2] = #11) and (Panose[4] = #9) then
                    UseFont(CIDEncoding, Charset, 'MS PGothic')
                  else if (Panose[1] = #2) and (Panose[2] = #11) and (Panose[4] = #0) then
                    UseFont(CIDEncoding, Charset, 'MS Gothic')
                  else if (Panose[1] = #2) and (Panose[2] = #2) and (Panose[4] = #9) then
                    UseFont(CIDEncoding, Charset, 'MS PMincho')
                  else if (Panose[1] = #2) and (Panose[2] = #2) and (Panose[4] = #0) then
                    UseFont(CIDEncoding, Charset, 'MS Mincho')
                else
                  UseFont(CIDEncoding, Charset, 'MS Mincho');
                end

                else
                if (Flags and 1 = 1) then         // Fixed Pitch
                begin
                  if (Flags and 2 = 2) then       // Serif
                    UseFont(CIDEncoding, Charset, 'MS Mincho')

                  else if (Flags and 4 = 4) then  // Symbolic
                    UseFont(CIDEncoding, Charset, 'MS Gothic')

                  else if (Flags and 8 = 8) then  // Script
                    UseFont(CIDEncoding, Charset, 'MS Mincho')

                else
                  UseFont(CIDEncoding, Charset, 'MS Mincho');

                end                               // Proportional
                else
                begin
                  if (Flags and 14 = 14) then     // Serif
                    UseFont(CIDEncoding, Charset, 'MS PMincho')

                  else if (Flags and 2 = 2) then  // Serif
                    UseFont(CIDEncoding, Charset, 'MS PMincho')

                  else if (Flags and 4 = 4) then  // Symbolic
                    UseFont(CIDEncoding, Charset, 'MS PGothic')

                  else if (Flags and 8 = 8) then  // Script
                    UseFont(CIDEncoding, Charset, 'MS PMincho')

                else if FontName <> '' then
                  UseFont(CIDEncoding, Charset, FontName)
                else
                  UseFont(CIDEncoding, Charset, 'MS Mincho');
                end;

                if (SubType = 'CIDFontType2') and (CIDSystemInfoStr = 'Adobe-Identity-0') then
                begin
                  AdobeGIDType0 := True;
                  if (FontName = 'CourierStd-Bold') then
                    FontName := 'Courier,Bold';
                  if (FontName = 'CourierStd-BoldOblique') then
                    FontName := 'Courier,BoldItalic';
                  if (FontName = 'CourierStd-Oblique') then
                    FontName := 'Courier,Italic;';
                  if (FontName = 'CourierStd') then
                    FontName := 'Courier';

                  if (QPLStartsWith(FamilyName, 'DFKaiShu')) then
                    FontName := 'DFKai-SB';

                  Charset := GetCharset(CIDEncoding, CIDSystemInfoStr);
                  UseFont(CIDEncoding, Charset, FontName);
                end;

              end;
            end;
          end;
        end;
      end else
      if SubType = 'Type3' then
      begin
        if FInstallFonts then
        begin
          Rasterizer := TPDFType3Rasterizer.Create;
          Rasterizer.OnFindObject := FOnFindObject;
          Rasterizer.OnDecrypt := FOnDecrypt;
          Rasterizer.OnEncrypt := FOnEncrypt;
          TPDFType3Rasterizer(Rasterizer).LoadFromPDFDict(Font);
        end;
      end else
      if SubType = 'Type0' then
      begin
        Obj := Font.FindValueByKeyName('DescendantFonts');
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 1) then
        begin
          AnalyseFont(TPDFArray(Obj).Item[0], Font);
        end;
      end;
    end;

    if FInstallFonts and not Assigned(Rasterizer) and (SubType <> 'Type0') then
    begin
      Rasterizer := TPDFTrueTypeRasterizer2.Create;
      TPDFTrueTypeRasterizer2(Rasterizer).IsZapfDingbats := FontName = 'ZapfDingbats';
      if (TPDFTrueTypeRasterizer2(Rasterizer).IsZapfDingbats) then
      begin
        TPDFTrueTypeRasterizer2(Rasterizer).Font.Name := 'Symbol';
      end else
      begin
        MatchFont(TPDFTrueTypeRasterizer2(Rasterizer).Font);
      end;
      TPDFTrueTypeRasterizer2(Rasterizer).LoadFromFont;

      if (TPDFTrueTypeRasterizer2(Rasterizer).HasCFFTable) then
      begin
        CFFStream := TMemoryStream.Create;
        try
          CFFStream.Write(TPDFTrueTypeRasterizer2(Rasterizer).FontData[1],
            Length(TPDFTrueTypeRasterizer2(Rasterizer).FontData));
          CFFStream.Seek(0, soFromBeginning);
          TPDFTrueTypeRasterizer2(Rasterizer).Free;
          Rasterizer := TPDFType1Decoder.Create;
          TPDFType1Decoder(Rasterizer).LoadCFFFromStream(CFFStream);
        finally
          CFFStream.Free;
        end;
      end else
      begin
        if Assigned(Differences) then
        begin
          ApplyDifferencesArray(CSN, Differences);
          Differences := nil;
        end;
        TPDFTrueTypeRasterizer2(Rasterizer).GetWidths(CSN, Widths);
      end;
    end;

    GetWinAnsiDisplay(CSN, CharMap);

    if Assigned(Differences) then
      ApplyDifferencesArray(CSN, Differences);

    if StdFontIndex > 0 then
      GetAFMWidths(StdFontIndex, CSN, Widths);

    if (SubType = 'CIDFontType0') then
    begin
      // DW is processed above.

      Obj := Font.FindValueByKeyName('W');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if QPLStartsWith(FontName, 'HeiseiKakuGo-W5') then
      begin
        CIDWidths := DecodeCJKCIDWidths(HeiseiKakuGoW5UCWidths, DW);
        CIDWidths.InsertObject(0, 'Default', TObject(DW));
      end else
      begin
        if Obj is TPDFArray then
        begin
          CIDWidths := DecodeCIDWidths(TPDFArray(Obj), DW, WFactor);
        end else
        begin
          CIDWidths := TQuickPDFStringList.Create;
          CIDWidths.AddObject('Default', TObject(DW));
        end;
      end;

      ProcessW2Dict;

    end else
    if (SubType = 'CIDFontType2') then
    begin
      // DW is processed above.

      Obj := Font.FindValueByKeyName('W');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFArray then
      begin
        CIDWidths := DecodeCIDWidths(TPDFArray(Obj), DW, WFactor);
      end else
      begin
        CIDWidths := TQuickPDFStringList.Create;
        CIDWidths.AddObject('Default', TObject(DW));
      end;

      ProcessW2Dict;

      Obj := Font.FindValueByKeyName('CIDToGIDMap');
      IR := nil;
      if Obj is TPDFIndRef then
      begin
        IR := TPDFIndRef(Obj);
        Obj := FindObject(IR);
      end;
      if Obj is TPDFStream then
      begin
        if Assigned(FOnDecrypt) and Assigned(IR) then
          FOnDecrypt(TPDFStream(Obj), IR);

        CIDToGIDMap := TQPLWordPairList.Create();
        DecodeCIDToGIDMap(TPDFStream(Obj).GetDecodedStream);
        HasOwnCIDToGIDMap := True;

        if Assigned(FOnEncrypt) and Assigned(IR) then
          FOnEncrypt(TPDFStream(Obj), IR);
      end
      else
      if (Obj is TPDFName) then
      begin
        if (CIDEncoding = '') then
          CIDEncoding := TPDFName(Obj).Name;
      end;

    end else
    begin
      Obj := Font.FindValueByKeyName('FirstChar');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFNumeric then
      begin
        FirstChar := TPDFNumeric(Obj).AsInteger;
        Obj := Font.FindValueByKeyName('LastChar');
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFNumeric then
        begin
          LastChar := TPDFNumeric(Obj).AsInteger;
          if LastChar > 255 then LastChar := 255;
          Obj := Font.FindValueByKeyName('Widths');
          if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
          if Obj is TPDFArray then
          begin
            for X := 0 to Length(Widths) - 1 do
              Widths[X] := MissingWidth;
            for X := 0 to TPDFArray(Obj).Count - 1 do
            begin
              if X + FirstChar <= LastChar then
              begin
                if TPDFArray(Obj).Item[X] is TPDFNumeric then
                  Widths[X + FirstChar] := TPDFNumeric(TPDFArray(Obj).Item[X]).AsDouble
                else
                  Widths[X + FirstChar] := 0;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  if SubType <> 'Type0' then
  begin
    X := Length(FFontData);
    SetLength(FFontData, X + 1);
    FFontData[X] := TPDFFontCollectionData.Create;
    if (RefOrDict is TPDFIndRef) then
      FFontData[X].ObjNum := TPDFIndRef(RefOrDict).ObjNum
    else
      FFontData[X].ObjNum := 0;
    FFontData[X].Widths := Widths;
    FFontData[X].DW2_v := DW2_v;
    FFontData[X].DW2_w1 := DW2_w1;

    SetLength(FFontData[X].W2, W2Count);
    for I := 0 to W2Count - 1 do
     FFontData[X].W2[I] := W2[I];

    FFontData[X].FontName := FontName;
    FFontData[X].Rasterizer := Rasterizer;
{$IFDEF QPL_OS_MAC}
    CopyCharsetNames(FFontData[X].Encoding, CSN);
{$ELSE}
    FFontData[X].Encoding := CSN;
{$ENDIF}
    FFontData[X].IsComposite := False;
    FFontData[X].CIDWidths := CIDWidths;
    FFontData[X].Ascent := Ascent;
    FFontData[X].Descent := Descent;
    FFontData[X].Bound := Bound;
    FFontData[X].FirstChar := FirstChar;
    FFontData[X].LastChar := LastChar;
    FFontData[X].CIDToGIDMap := CIDToGIDMap;
    FFontData[X].HasOwnCIDToGIDMap := HasOwnCIDToGIDMap;
    FFontData[X].EncodingBuiltIn := EncodingBuiltIn;
    FFontData[X].AdobeGIDType0 := AdobeGIDType0;
    FFontData[X].GIDToCIDMap := GIDToCIDMap;
    FFontData[X].CIDEncoding := CIDEncoding;
    FFontData[X].ToUnicodeMap := nil;
    FFontData[X].SingleByteCMap := False;
    FFontData[X].CIDSystemInfo := CIDSystemInfoStr;
    FFontData[X].Panose := Panose;
    FFontData[X].Embedded := Embedded;
    FFontData[X].Subsetted := Subsetted;
    FFontData[X].SubType := SubType;
    SetLength(FFontData[X].DisplayCS2, 0);
  end else
  begin
    FFontData[Length(FFontData) - 1].IsComposite := True;
    FFontData[Length(FFontData) - 1].SingleByteCMap := SingleByteCMapEncoding;

    if (FFontData[Length(FFontData) - 1].GIDToCIDMap <> -1) then
      if (CMapList[FFontData[Length(FFontData) - 1].GIDToCIDMap].SingleByteCMap) then
        FFontData[Length(FFontData) - 1].SingleByteCMap := True;

    X := Length(FFontData) - 1;
    GetCID := True;
  end;

  ToUnicode := '';

  Obj := Font.FindValueByKeyName('ToUnicode', False);
  IR := nil;
  if Obj is TPDFIndRef then
  begin
    IR := TPDFIndRef(Obj);
    Obj := FindObject(IR);
  end;
  if Obj is TPDFStream then
  begin
    if Assigned(FOnDecrypt) and Assigned(IR) then
      FOnDecrypt(TPDFStream(Obj), IR);
    ToUnicode := TPDFStream(Obj).GetDecodedStream;
    if Assigned(FOnEncrypt) and Assigned(IR) then
      FOnEncrypt(TPDFStream(Obj), IR);
  end;
  if Obj is TPDFName then
  begin
    ToUnicode := TPDFName(Obj).Name;
  end;

  if GetCID then
  begin
    if (ToUnicode <> '') then
    begin

      if (Obj is TPDFStream) then
        FFontData[X].ToUnicodeMap := ResourcesAddToUnicodeCMapFromString(QPLIntToStr(X), ToUnicode)
      else
      begin
        FFontData[X].ToUnicodeMap := TDebenuPDFLibraryCMap.Create;
        FFontData[X].ToUnicodeMap.SetIdentityMapping;
      end;

      if (FFontData[X].SingleByteCMap) then
      begin
        FFontData[X].DisplayCS2 := ProcessCMap(ToUnicode, SingleByteCMapEncoding);
      end else
      begin
        FFontData[X].DisplayCS2 := ProcessCMap(ToUnicode, FFontData[X].SingleByteCMap);
      end;

      for I := 0 to 255 do
      begin
        FFontData[X].DisplayCSW[I] := WideChar(I);
      end;
      GetUnicode(CSN, FFontData[X].DisplayCSW);
      FFontData[X].DisplayCSW := ConvertCMapWideBase(FFontData[X].DisplayCS2, FFontData[X].DisplayCSW);
    end else
    begin
      if Assigned(OldDifferences) then
      begin
        GetCharsetNames(Enc, CSN);
        ApplyDifferencesArray(CSN, OldDifferences);
      end;
      GetUnicode(CSN, FFontData[X].DisplayCSW);
    end;
    if FFontData[X].CIDSystemInfo <> '' then
    begin
    end;
  end else
  begin
    if (ToUnicode <> '') then
    begin
      FFontData[X].ToUnicodeMap := ResourcesAddToUnicodeCMapFromString(QPLIntToStr(X), ToUnicode);

      FFontData[X].DisplayCS2 := ProcessCMap(ToUnicode, FFontData[X].SingleByteCMap);
      GetUnicode(CSN, FFontData[X].DisplayCSW);
      FFontData[X].DisplayCSW := ConvertCMapWideBase(FFontData[X].DisplayCS2, FFontData[X].DisplayCSW);
    end else
    begin
      GetUnicode(CSN, FFontData[X].DisplayCSW);
    end;
  end;
end;

function TPDFFontCollection.ConvertCMap(
  CMap: TPDFCMap): TPDFCharsetDisplay;
var
  I: Integer;
  J: Integer;
  X: Integer;
  WC: WideChar;
begin
  if Length(CMap) > 0 then
  begin
    for X := 0 to 255 do
    begin
      for I := 0 to Length(CMap) - 1 do
      begin
        if (X >= CMap[I].StartCode) and (X <= CMap[I].EndCode) then
        begin
          Result[X] := '';

          for J := 0 to Length(CMap[I].ResultCodes) - 1 do
          begin
            WC := WideChar(CMap[I].ResultCodes[J] + (X - CMap[I].StartCode));
            Result[X] := Result[X] + AnsiString(WC);
          end;
        end;
      end;
    end;
  end;
end;

function TPDFFontCollection.ConvertCMapBase(CMap: TPDFCMap;
  Base: TPDFCharsetDisplay): TPDFCharsetDisplay;
var
  I: Integer;
  J: Integer;
  X: Integer;
  WC: WideChar;
begin
  Result := Base;
  if Length(CMap) > 0 then
  begin
    for X := 0 to 255 do
    begin
      for I := 0 to Length(CMap) - 1 do
      begin
        if (X >= CMap[I].StartCode) and (X <= CMap[I].EndCode) then
        begin
          Result[X] := '';
          for J := 0 to  Length(CMap[I].ResultCodes) - 1 do
          begin
            WC := WideChar(CMap[I].ResultCodes[J] + (X - CMap[I].StartCode));
            Result[X] := Result[X] + AnsiString(WC);
          end;
        end;
      end;
    end;
  end;
end;

function TPDFFontCollection.ConvertCMapWide(
  CMap: TPDFCMap): TPDFCharsetWide;
var
  I: Integer;
  J: Integer;
  X: Integer;
begin
  if Length(CMap) > 0 then
  begin
    for X := 0 to 255 do
    begin
      for I := 0 to Length(CMap) - 1 do
      begin
        if (X >= CMap[I].StartCode) and (X <= CMap[I].EndCode) then
        begin
          Result[X] := '';
          for J := 0 to  Length(CMap[I].ResultCodes) - 1 do
          begin
            Result[X] := Result[X] + WideChar(CMap[I].ResultCodes[J] + (X - CMap[I].StartCode));
          end;
        end;
      end;
    end;
  end;
end;

function TPDFFontCollection.ConvertCMapWideBase(CMap: TPDFCMap;
  Base: TPDFCharsetWide): TPDFCharsetWide;
var
  I: Integer;
  J: Integer;
  X: Integer;
begin
  Result := Base;
  if Length(CMap) > 0 then
  begin
    for X := 0 to 255 do
    begin
      for I := 0 to Length(CMap) - 1 do
      begin
        if (X >= CMap[I].StartCode) and (X <= CMap[I].EndCode) then
        begin
          Result[X] := '';
          for J := 0 to  Length(CMap[I].ResultCodes) - 1 do
          begin
            Result[X] := Result[X] + WideChar(CMap[I].ResultCodes[J] + (X - CMap[I].StartCode));
          end;
        end;
      end;
    end;
  end;
end;

constructor TPDFFontCollection.Create;
begin
  FInstallFonts := False;
  FUsingTextFunnel := False;
  ResourceList := TQuickPDFStringList.Create;
  SetLength(FFontData, 0);

  SetLength(CMapList, 0);
  CMapCount := 0;
end;

function TPDFFontCollection.DecodeCIDWidths(W: TPDFArray;
  DW: Integer; WFactor: Double): TQuickPDFStringList;
var
  Obj: TPDFObject;
  I: Integer;
  CFirst: Integer;
  CLast: Integer;
  Width: Integer;
  WX: Integer;
  A2: TPDFArray;
begin
  Result := TQuickPDFStringList.Create;
  Result.AddObject('Default', TObject(DW));
  I := 0;
  while I < W.Count - 1 do
  begin
    Obj := W.Item[I];
    if (Obj is TPDFIndRef) then
    begin
      Obj := FindObject(TPDFIndRef(Obj));
    end;
    if Obj is TPDFNumeric then
      CFirst := TPDFNumeric(Obj).AsInteger
    else
      CFirst := -1;
    if CFirst >= 0 then
    begin
      Obj := W.Item[I + 1];
      if (Obj is TPDFIndRef) then
      begin
        Obj := FindObject(TPDFIndRef(Obj));
      end;
      if Obj is TPDFNumeric then
      begin
        CLast := TPDFNumeric(Obj).AsInteger;
        if (I < W.Count - 2) then
        begin
          Obj := W.Item[I + 2];
          if Obj is TPDFNumeric then
          begin
            Width := TPDFNumeric(Obj).AsInteger;
            Width := Round(Width * WFactor);
            for WX := CFirst to CLast do
              Result.AddObject('CID:' + QPLIntToStr(WX), TObject(Width));
          end else
            I := W.Count;
        end else
          I := W.Count;
        Inc(I, 3);
      end else
      if Obj is TPDFArray then
      begin
        A2 := TPDFArray(Obj);
        for WX := CFirst to CFirst + A2.Count - 1 do
        begin
          Obj := A2.Item[WX - CFirst];
          if Obj is TPDFNumeric then
          begin
            Width := TPDFNumeric(Obj).AsInteger;
            Width := Round(Width * WFactor);
            Result.AddObject('CID:' + QPLIntToStr(WX), TObject(Width));
          end;
        end;
        Inc(I, 2);
      end;
    end else
      I := W.Count;
  end;
end;

function TPDFFontCollection.DecodeCJKCIDWidths(
  const EncodedWidthData: AnsiString; DW: Integer): TQuickPDFStringList;
var
  Width: Integer;
  FC: Integer;
  FX: Integer;
  UB: Integer;
  LB: Byte;
  CharCode: Word;
  CIDWidths: AnsiString;
begin
  Result := TQuickPDFStringList.Create;
  Result.AddObject('Default', TObject(0));
  CIDWidths := InflateStr(EncodedWidthData);
  FC := Length(CIDWidths) div 513;
  for FX := 0 to FC - 1 do
  begin
    UB := Ord(CIDWidths[FX * 513 + 1]);
    for LB := 0 to 255 do
    begin
      Width := Ord(CIDWidths[FX * 513 + LB * 2 + 2]) * 256 +
        Ord(CIDWidths[FX * 513 + LB * 2 + 3]);
      if Width <> 0 then
      begin
        CharCode := UB * 256 + LB;
        Result.AddObject('CID:' + QPLIntToStr(CharCode), TObject(Width));
      end;
    end;
  end;
end;

destructor TPDFFontCollection.Destroy;
var
  X: Integer;
  FN: WideString;
begin

  for X := 0 to CMapCount - 1 do
    CMapList[X].Destroy;

  for X := 0 to Length(FFontData) - 1 do
  begin
    if Assigned(FFontData[X].Rasterizer) then
      FFontData[X].Rasterizer.Free;
    if Assigned(FFontData[X].CIDWidths) then
      FFontData[X].CIDWidths.Free;
    if (Assigned(FFontData[X].ToUnicodeMap)) then
      FFontData[X].ToUnicodeMap.Free;
    if Assigned(FFontData[X].CIDToGIDMap) and FFontData[X].HasOwnCIDToGIDMap then
      FFontData[X].CIDToGIDMap.Free;
    FFontData[X].Free;
  end;
  SetLength(FFontData, 0);
  for X := 0 to ResourceList.Count - 1 do
  begin
    FN := QPLUTF8Decode(ResourceList[X]);
{$IFDEF QPL_OS_WINDOWS}
    RemoveFontResourceW(@FN[1]);
{$ENDIF}
    QPLDeleteFile(FN);
  end;
  ResourceList.Free;

  inherited;
end;

function TPDFFontCollection.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

// Splits a block of 8-bit data from the content stream into
// an array of 16-bit codes based on the encoding of the
// selected font
procedure TPDFFontCollection.GetCodeList(const Text: AnsiString;
  var CodeList: TQuickPDFCodeList);
var
  CX: Integer;
begin
  SetLength(CodeList, 0);
  if Length(Text) > 0 then
  begin
    if (Length(FFoundFontData.CIDSystemInfo) > 0) then
    begin
      ResourceCMapCodeSplit(FFoundFontData.GIDToCIDMap, Text, CodeList);
    end else
    begin
      SetLength(CodeList, Length(Text) div 2);
      for CX := 0 to Length(CodeList) - 1 do
      begin
        CodeList[CX] := Ord(Text[CX * 2 + 1]) shl 8 + Ord(Text[CX * 2 + 2]);
      end;
    end;
  end;
end;

procedure TPDFFontCollection.GetFontData(Ref: TPDFIndRef);
var
  FoundIndex: Integer;
begin
  FoundIndex := FindMapObjNum(Ref.ObjNum);
  if FoundIndex >= 0 then
  begin
    FFoundFontData := FFontData[FoundIndex];
  end else
  begin
    AnalyseFont(Ref);
    FFontData[Length(FFontData) - 1].ObjNum := Ref.ObjNum;
    UpdateMapObjNum;
    FFoundFontData := FFontData[Length(FFontData) - 1];
  end;
end;

procedure TPDFFontCollection.FastGetFontData(ObjNum: Integer);
var
  FoundIndex: Integer;
begin
  FoundIndex := FindMapObjNum(ObjNum);
  if FoundIndex >= 0 then
  begin
    FFoundFontData := FFontData[FoundIndex];
  end;
end;

function TPDFFontCollection.GetWideMap(CharCode: Integer): WideString;
var
  I: Integer;
  J: Integer;
  CMap: TPDFCMap;
  Found: Boolean;
begin
  Result := '';
  SetLength(CMap, 0);

  if FFoundFontData.IsComposite then
  begin
    CMap := FFoundFontData.DisplayCS2;
    if Length(CMap) > 0 then
    begin
      Found := False;
      I := 0;

      while (not Found) and (I < Length(CMap)) do
      begin
        if (CharCode >= CMap[I].StartCode) and (CharCode <= CMap[I].EndCode) then
        begin
          Result := '';
          for J := 0 to Length(CMap[I].ResultCodes) - 1 do
          begin
            Result := Result + WideChar(CMap[I].ResultCodes[J] + (CharCode - CMap[I].StartCode));
          end;
          Found := True;
        end;
        Inc(I);
      end;
    end else
    if Length(FFoundFontData.CIDSystemInfo) > 0 then
    begin
      Result := WideChar(CharCode);
    end;
  end else
  begin
    if (CharCode >= 0) and (CharCode <= $FF) then
    begin
      Result := FFoundFontData.DisplayCSW[CharCode];
      if Result = #0 then
      begin
        Result := WideChar(CharCode);
      end;
    end;
  end;
end;

function TPDFFontCollection.ProcessCMap(
  const CMap: AnsiString; var SingleByte: Boolean): TPDFCMap;
var
  P1: Integer;
  P2: Integer;
  R1: Integer;
  R2: Integer;
  S: AnsiString;
  BFR: AnsiString;
  Done: Boolean;
  PopSize: Integer;
  AX: Integer;
  Codes: TResultCodes;

  function PopHex: Integer;
  var
    PH1: Integer;
    PH2: Integer;
    PH3: Integer;
    PopText: AnsiString;
  begin
    PH1 := QPLPos('<', S);
    PH2 := QPLPos('>', S);
    PH3 := QPLPos('[', S);

    if (PH3 > 0) and (PH1 > 0) and (PH3 < PH1) then
    begin
      Delete(S, 1, PH3);
      Result := -2;
      Exit;
    end;

    if (PH1 > 0) and (PH2 > 0) and (PH1 < PH2) then
    begin
      PopText := QPLCopy(S, PH1 + 1, PH2 - PH1 - 1);
      if (Length(PopText) = 5) and (PopText[4] = #13) then
      begin
        SetLength(PopText, 4);
      end;
      PopSize := Length(PopText);
      Result := QPLStrToIntDef('$' + PopText, -1);
      Delete(S, 1, PH2);
    end else
    begin
      Result := -1;
      S := '';
    end;
  end;

  function PopHexCodes: TResultCodes;
  var
    PH1: Integer;
    PH2: Integer;
    PH3: Integer;
    PopText: AnsiString;
    Words: Integer;
    I: Integer;
  begin
    PH1 := QPLPos('<', S);
    PH2 := QPLPos('>', S);
    PH3 := QPLPos('[', S);

    if (PH3 > 0) and (PH1 > 0) and (PH3 < PH1) then
    begin
      SetLength(Result, 1);
      Delete(S, 1, PH3);
      Result[0] := -2;
      Exit;
    end;

    if (PH1 > 0) and (PH2 > 0) and (PH1 < PH2) then
    begin
      PopText := QPLCopy(S, PH1 + 1, PH2 - PH1 - 1);
      if ((Length(PopText) = 5) and (PopText[5] = #13)) then
      begin
        SetLength(PopText, 4);
      end;

      PopSize := Length(PopText);

      if (PopSize <= 4) then
      begin
        SetLength(Result, 1);
        Result[0] := QPLStrToIntDef('$' + PopText, -1);
        Delete(S, 1, PH2);
      end else
      begin     // Here we read 4, 6, 8 etc  byte HexCodes 4 characters at a time.
        Words := Length(PopText) div 4;
        SetLength(Result, Words);
        for I := 0 to (Words - 1) do
        begin
          Result[I] := QPLStrToIntDef('$' + QPLCopy(PopText, I * 4 + 1, 4), -1);
        end;
        Delete(S, 1, PH2);
      end;
    end else
    begin
      SetLength(Result, 1);
      Result[0] := -1;
      S := '';
    end;
  end;

begin
  SetLength(Result, 0);
  SetLength(Codes, 0);
  SingleByte := False;
  P1 := QPLPos('begincodespacerange', CMap);
  P2 := QPLPos('endcodespacerange', CMap);
  if (P1 > 0) and (P2 > 0) and (P1 < P2) then
  begin
    S := QPLCopy(CMap, P1 + 20, P2 - P1 - 20);
    R1 := PopHex;
    if PopSize = 2 then SingleByte := True;
    R2 := PopHex;
    if (R1 >= 0) and (R2 >= 0) then
    begin
      BFR := QPLCopy(CMap, P2 + 17, MaxInt);

      repeat
        Done := False;

        P1 := QPLPos('beginbfrange', BFR);
        P2 := QPLPos('beginbfchar', BFR);

        if (P1 = 0) and (P2 = 0) then
        begin
          P1 := QPLPos('begincidrange', BFR);
          P2 := QPLPos('endcidchar', BFR);
        end;

        if ((P1 > 0) and (P2 > 0) and (P1 < P2)) or
          ((P1 > 0) and (P2 = 0)) then
        begin
          P1 := QPLPos('beginbfrange', BFR);
          P2 := QPLPos('endbfrange', BFR);

          if (P1 = 0) and (P2 = 0) then
          begin
            P1 := QPLPos('begincidrange', BFR);
            P2 := QPLPos('endcidrange', BFR);
          end;

          if (P1 > P2) then  // Desk 13748 - Malformed double ToUnicode table.
            Done := True;

          if (P1 >= 0) and (P2 >= 0) and (P1 < P2) then
          begin
            S := QPLCopy(BFR, P1 + 12, P2 - P1 - 12);
            repeat
              R1 := PopHex;
              R2 := PopHex;
              Codes := PopHexCodes;

              if Codes[0] = -2 then
              begin
                // Array
                for AX := 1 to (R2 - R1 + 1) do
                begin
                  Codes := PopHexCodes;
                  if (R1 <= $FFFF) and (Codes[0] <= $FFFF) and (Codes[0] < $FFFF) then
                  begin
                    SetLength(Result, Length(Result) + 1);
                    Result[Length(Result) - 1].StartCode := R1;
                    Result[Length(Result) - 1].EndCode := R1;
                    Result[Length(Result) - 1].ResultCodes := Codes;
                  end;
                  Inc(R1);
                end;
              end else
              begin
                if (R1 >= 0) and (R2 >= 0) then
                begin
                  if (R1 <= $FFFF) and (R2 <= $FFFF) then
                  begin
                    SetLength(Result, Length(Result) + 1);
                    Result[Length(Result) - 1].StartCode := R1;
                    Result[Length(Result) - 1].EndCode := R2;
                    Result[Length(Result) - 1].ResultCodes := Codes;
                  end;
                end;
              end;
            until (R1 < 0) or (R2 < 0);
            Delete(BFR, 1, P2 + 10);
          end;
        end else
        if ((P2 > 0) and (P1 > 0) and (P2 < P1)) or
          ((P2 > 0) and (P1 = 0)) then
        begin
          P1 := QPLPos('beginbfchar', BFR);
          P2 := QPLPos('endbfchar', BFR);

          if (P1 = 0) and (P2 = 0) then
          begin
            P1 := QPLPos('begincidchar', BFR);
            P2 := QPLPos('endcidchar', BFR);
          end;


          // Check for the case of a missing endbfchar token
          if (P1 > 0) and (P2 = 0) then
          begin
            P2 := QPLPos('endcmap', BFR);
          end;

          if (P1 >= 0) and (P2 >= 0) and (P1 < P2) then
          begin
            S := QPLCopy(BFR, P1 + 11, P2 - P1 - 11);
            repeat
              R1 := PopHex;
              Codes := PopHexCodes;

              if (R1 >= 0) and (Codes[0] >= 0) then
              begin
                if (R1 <= $FFFF) and (R2 <= $FFFF) then
                begin
                  SetLength(Result, Length(Result) + 1);
                  Result[Length(Result) - 1].StartCode := R1;
                  Result[Length(Result) - 1].EndCode := R1;
                  Result[Length(Result) - 1].ResultCodes := Codes;
                end;
              end;
            until (R1 < 0) or (Codes[0] < 0);
            Delete(BFR, 1, P2 + 9);
          end;
        end else
          Done := True;
      until Done;

    end;
  end;
end;

// Uses the Shell Sort algorithm to sort the list of ObjNum
// values and the indices into the FFontData entries
procedure TPDFFontCollection.UpdateMapObjNum;
var
  OriginalLength: Integer;
  NewLength: Integer;
  X: Integer;
  I, J, K: Integer;
  Temp: Integer;
begin
  OriginalLength := Length(FMapObjNum);
  NewLength := Length(FFontData);
  SetLength(FMapObjNum, NewLength);
  SetLength(FMapIndex, NewLength);
  for X := OriginalLength to NewLength - 1 do
  begin
    FMapObjNum[X] := FFontData[X].ObjNum;
    FMapIndex[X] := X;
  end;

  K := (NewLength - 1) shr 1;
  while K > 0 do
  begin
    for I := 0 to (NewLength - 1) - K do
    begin
      J := I;
      while (J >= 0) and (FMapObjNum[J] > FMapObjNum[J + K]) do
      begin
        Temp := FMapObjNum[J];
        FMapObjNum[J] := FMapObjNum[J + K];
        FMapObjNum[J + K] := Temp;

        Temp := FMapIndex[J];
        FMapIndex[J] := FMapIndex[J + K];
        FMapIndex[J + K] := Temp;

        if J > K then
        begin
          Dec(J, K);
        end else
        begin
          J := 0;
        end;
      end;
    end;
    K := K shr 1;
  end;
end;

// Uses the Binary Search algorithm to find the index into
// FFontData for the specified ObjNum from the sorted
// FMapObjNum array
function TPDFFontCollection.FindMapObjNum(ObjNum: Integer): Integer;
var
  Min, Max: Integer;
  Mid: Integer;
begin
  Min := 0;
  Max := Length(FMapObjNum);
  while (Min < Max) do
  begin
    Mid := Min + ((Max - Min) div 2);
    if (FMapObjNum[Mid] < ObjNum) then
    begin
      Min := Mid + 1;
    end else
    begin
      Max := Mid;
    end;
  end;
  if ((Min < Length(FMapObjNum)) and (FMapObjNum[Min] = ObjNum)) then
  begin
    Result := FMapIndex[Min];
  end else
  begin
    Result := -1;
  end;
end;

procedure TPDFFontCollection.GetFontDataFromDict(Dict: TPDFDictionary);
begin
  AnalyseFont(Dict);
  if (Length(FFontData) > 0) then
  begin
    FFoundFontData := FFontData[Length(FFontData) - 1];
  end;
end;

{ TPDFType3Rasterizer }

constructor TPDFType3Rasterizer.Create;
begin
  CharNames := TQuickPDFCaseSensitiveStringList.Create;
  CharProcs := TQuickPDFStringList.Create;
  FFillColor := clBlack;
  InlineImages := TQuickPDFCaseSensitiveStringList.Create;
end;

destructor TPDFType3Rasterizer.Destroy;
var
  X: Integer;
begin
  CharNames.Free;
  CharProcs.Free;
  for X := 0 to InlineImages.Count - 1 do
    InlineImages.Objects[X].Free;
  InlineImages.Free;
  inherited;
end;

function TPDFType3Rasterizer.FontMatrixScaling: Double;
begin
  Result := 1;
end;

function TPDFType3Rasterizer.GetCharProc(
  const CharName: AnsiString): AnsiString;
var
  I: Integer;
begin
  I := CharNames.IndexOf(CharName);
  if I >= 0 then
  begin
    Result := CharProcs[Integer(CharNames.Objects[I])];
  end else
  begin
    Result := '';
  end;
end;

procedure TPDFType3Rasterizer.LoadFromPDFDict(Dict: TPDFDictionary);
var
  X: Integer;
  Obj: TPDFObject;
  CPDict: TPDFDictionary;
  CharProc: AnsiString;
  FM: TPDFArray;
  IR: TPDFIndRef;
begin
  FDict := Dict;
  FontMatrix.eM11 := 1;
  FontMatrix.eM12 := 0;
  FontMatrix.eM21 := 0;
  FontMatrix.eM22 := 1;
  FontMatrix.eDx := 0;
  FontMatrix.eDy := 0;
  Obj := FDict.FindValueByKeyName('FontMatrix', False);
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if Obj is TPDFArray then
  begin
    FM := TPDFArray(Obj);
    if FM.Count = 6 then
    begin
      Obj := FM.Item[0];
      if Obj is TPDFNumeric then FontMatrix.eM11 := TPDFNumeric(Obj).AsDouble;
      Obj := FM.Item[1];
      if Obj is TPDFNumeric then FontMatrix.eM12 := TPDFNumeric(Obj).AsDouble;
      Obj := FM.Item[2];
      if Obj is TPDFNumeric then FontMatrix.eM21 := TPDFNumeric(Obj).AsDouble;
      Obj := FM.Item[3];
      if Obj is TPDFNumeric then FontMatrix.eM22 := TPDFNumeric(Obj).AsDouble;
      Obj := FM.Item[4];
      if Obj is TPDFNumeric then FontMatrix.eDx := TPDFNumeric(Obj).AsDouble;
      Obj := FM.Item[5];
      if Obj is TPDFNumeric then FontMatrix.eDy := TPDFNumeric(Obj).AsDouble;
    end;
  end;
  Obj := FDict.FindValueByKeyName('CharProcs', False);
  if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));  
  if Obj is TPDFDictionary then
  begin
    CPDict := TPDFDictionary(Obj);
    for X := 0 to CPDict.Count - 1 do
    begin
      CharNames.AddObject(CPDict.Entry[X].Key.Name, TObject(X));
      Obj := CPDict.Entry[X].Value;
      CharProc := '';
      if Obj is TPDFIndRef then
      begin
        IR := TPDFIndRef(Obj);
        Obj := FindObject(IR);
        if Obj is TPDFStream then
        begin
          if Assigned(FOnDecrypt) and Assigned(IR) then
            FOnDecrypt(TPDFStream(Obj), IR);
          CharProc := TPDFStream(Obj).GetDecodedStream;
          if Assigned(FOnEncrypt) and Assigned(IR) then
            FOnEncrypt(TPDFStream(Obj), IR);
        end;
      end;
      CharProcs.Add(CharProc);
    end;
    CharNames.Sorted := True;
  end;
end;

function TPDFType3Rasterizer.RenderToCanvas(var RX, RY: Double;
  Canvas: TPDFGenericCanvas; Mat: TPDFXForm; const CharName: AnsiString; Enc: TPDFEncodingVector): Boolean;
var
  I: Integer;
  S: AnsiString;
  MaxLen: Integer;
  TokPos: Integer;
  Tok: AnsiString;
  Stack: TQuickPDFStringList;
  TP: TPDFDoublePoint;
  TP2: TPDFDoublePoint;
  TP3: TPDFDoublePoint;
  TempMat: TPDFXForm;
  InlineImage: TPDFInlineImage;
  InlineID: TPDFImageDecoder;
  InlineIndex: Integer;

  function Translate(P1: TPDFDoublePoint): TPDFDoublePoint;
  begin
    Result.X := Mat.eM11 * P1.X + Mat.eM21 * P1.Y + Mat.eDx;
    Result.Y := Mat.eM12 * P1.X + Mat.eM22 * P1.Y + Mat.eDy;
  end;

  function NextToken: AnsiString;
  var
    InWhitespace: Boolean;
    TokStart: Integer;
    TokEnd: Integer;
    InStr: Integer;
    InSlash: Boolean;
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
        if S[TokStart] = '(' then
        begin
          InStr := 1;
          InSlash := False;
          repeat
            Inc(TokPos);
            if InSlash then
            begin
              InSlash := False;
            end else
            case S[TokPos] of
              '\': InSlash := True;
              ')': Dec(InStr);
              '(': Inc(InStr);
            end;
          until (InStr = 0) or (TokPos >= MaxLen);
          Inc(TokPos);
          Result := QPLCopy(S, TokStart, TokPos - TokStart);
        end else
        if S[TokStart] = '<' then
        begin
          repeat
            Inc(TokPos);
          until (S[TokPos] = '>') or (TokPos >= MaxLen);
          Inc(TokPos);
          Result := QPLCopy(S, TokStart, TokPos - TokStart);
        end else
        if (S[TokStart] = '[') or (S[TokStart] = ']') or (S[TokStart] = '''') then
        begin
          Result := S[TokStart];
          Inc(TokPos);
        end else
        begin
          repeat
            Inc(TokPos);
            InWhitespace := False;
            case S[TokPos] of
              #0,#9,#10,#12,#13,#32,#40,#47,#60,#91,#93: InWhitespace := True;
            end;
          until (InWhitespace) or (TokPos >= MaxLen);
          if (not InWhitespace) and (TokPos = MaxLen) then Inc(TokPos);
          TokEnd := TokPos - 1;
          Result := QPLCopy(S, TokStart, TokEnd - TokStart + 1);
          if InWhitespace and (TokPos = MaxLen) then Inc(TokPos);
        end;
      end else
        Result := '';
    end else
      Result := '';
  end;

  function PopDouble: Double;
  begin
    if Stack.Count > 0 then
    begin
      Result := TazzToFloat(Stack[Stack.Count - 1]);
      Stack.Delete(Stack.Count - 1);
    end else
      Result := 0;
  end;

begin
  Result := False;
  Stack := TQuickPDFStringList.Create;
  try
    TempMat.eM11 := 1;
    TempMat.eM12 := 0;
    TempMat.eM21 := 0;
    TempMat.eM22 := 1;
    TempMat.eDx := RX;
    TempMat.eDy := RY;
    CombinePDFXForm(Mat, TempMat, Mat);
    I := CharNames.IndexOf(CharName);
    if I >= 0 then
    begin
      Result := True;
      Canvas.BeginPath;
      S := CharProcs[Integer(CharNames.Objects[I])];
      MaxLen := Length(S);
      TokPos := 1;
      repeat
        Tok := NextToken;
        if Tok = 'm' then
        begin
          TP.Y := PopDouble;
          TP.X := PopDouble;
          TP := Translate(TP);
          Canvas.MoveTo(TP.X, TP.Y);
        end else
        if Tok = 'l' then
        begin
          TP.Y := PopDouble;
          TP.X := PopDouble;
          TP := Translate(TP);
          Canvas.AddLineToPath(TP.X, TP.Y);
        end else
        if Tok = 'c' then
        begin
          TP3.Y := PopDouble;
          TP3.X := PopDouble;
          TP3 := Translate(TP3);
          TP2.Y := PopDouble;
          TP2.X := PopDouble;
          TP2 := Translate(TP2);
          TP.Y := PopDouble;
          TP.X := PopDouble;
          TP := Translate(TP);
          Canvas.AddBezierToPath(TP.X, TP.Y, TP2.X, TP2.Y, TP3.X, TP3.Y);
        end else
        if Tok = 'h' then
        begin
          Canvas.ClosePath;
        end else
        if Tok = 'f' then
        begin
          Canvas.FillPath;
        end else
        if Tok = 'cm' then
        begin
          TempMat.eDy := PopDouble;
          TempMat.eDx := PopDouble;
          TempMat.eM22 := PopDouble;
          TempMat.eM21 := PopDouble;
          TempMat.eM12 := PopDouble;
          TempMat.eM11 := PopDouble;
          CombinePDFXForm(Mat, TempMat, Mat);
        end else
        if Tok = 'BI' then
        begin
          InlineIndex := InlineImages.IndexOf(CharName);
          if InlineIndex >= 0 then
          begin
            InlineID := TPDFImageDecoder(InlineImages.Objects[InlineIndex]);
            InlineID.Draw(TPDFPicasso(Canvas), Mat, FFillColor);
            TokPos := InlineID.TokPos;                       
          end else
          begin
            if DecodeInlineImage(S, TokPos, InlineImage, nil, nil) then
            begin
              InlineID := TPDFImageDecoder.Create;
              try
                InlineID.LoadFromInlineImage(InlineImage, nil);
                InlineID.Draw(TPDFPicasso(Canvas), Mat, FFillColor);
                InlineID.TokPos := TokPos;
              finally
                InlineImages.AddObject(CharName, InlineID);
              end;
            end;
          end;
        end else
          Stack.Add(Tok);
      until Tok = '';
    end;
  finally
    Stack.Free;
  end;
end;

{ TPDFFontRasterizer }

function TPDFFontRasterizer.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FOnFindObject) then
    Result := FOnFindObject(Ref)
  else
    Result := Ref.Obj;
end;

procedure TPDFFontRasterizer.SetupDirectFont(Canvas: TPDFGenericCanvas);
begin

end;

end.
