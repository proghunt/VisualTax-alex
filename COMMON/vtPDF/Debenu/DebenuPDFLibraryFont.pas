{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryFont.pas                               }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryFont;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  Types,
{$ENDIF}
{$IFDEF QPL_OS_WINDOWS}
{$IFDEF QPL_XE3_HIGHER}
  System.UITypes,
{$ENDIF}
{$ENDIF}
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  Classes, DebenuPDFLibraryStructure, DebenuPDFLibraryFontConst, DebenuPDFLibraryExtra,
  DebenuPDFLibraryCMap, DebenuPDFLibraryTypes;

const
  BaseFonts: array[1..14] of AnsiString = (
    'Courier*CourierNew*CourierNewPS*',
    'Courier-Bold*Courier,Bold*CourierNew-Bold*CourierNew,Bold*CourierNewPS,Bold*CourierNewPS,BoldMT,Bold*CourierNewPS-Bold*',
    'Courier-BoldOblique*Courier,BoldItalic*CourierNew-BoldItalic*CourierNew,BoldItalic*CourierNewPS-BoldItalic*',
    'Courier-Oblique*Courier,Italic*CourierNew-Italic*CourierNew,Italic*CourierNewPS-Italic*CourierNewPS,ItalicMT,Italic*',
    'Helvetica*Arial*ArialMT*HelveticaNeue-Roman*HelveticaNeue-UltraLight*',
    'Helvetica-Bold*Arial,BoldMT,Bold*Helvetica,Bold*Arial-Bold*Arial,Bold*Arial-Bold*HelveticaNeue,Bold*',
    'Helvetica-BoldOblique*Helvetica-BoldItalic*Helvetica,BoldItalic*Arial-BoldItalic*Arial,BoldItalic*',
    'Helvetica-Oblique*Helvetica-Italic*Helvetica,Italic*Arial-Italic*Arial,Italic*',
    'Times-Roman*TimesNewRoman*TimesNewRomanPS*',
    'Times-Bold*TimesNewRoman-Bold*TimesNewRoman,Bold*TimesNewRomanPS-Bold*TimesNewRomanPS,Bold*',
    'Times-Italic*TimesNewRoman-Italic*TimesNewRoman,Italic*TimesNewRomanPS-Italic*',
    'Times-BoldItalic*TimesNewRoman-BoldItalic*TimesNewRoman,BoldItalic*TimesNewRomanPS-BoldItalic*',
    'Symbol*',
    'ZapfDingbats*');
  ReplacementFonts: array[1..14] of AnsiString = (
    'CourierNew',
    'CourierNew,Bold',
    'CourierNew,BoldItalic',
    'CourierNew,Italic',
    'Arial',
    'Arial,Bold',
    'Arial,BoldItalic',
    'Arial,Italic',
    'TimesNewRoman',
    'TimesNewRoman,Bold',
    'TimesNewRoman,Italic',
    'TimesNewRoman,BoldItalic',
    'Symbol',
    'ZapfDingbats'
  );

type
  TKernSupport = (ksLoadNoUse, ksLoadAndUse, ksNoLoad);

  TPDFFontType = (ftUnknown, ftStandard, ftTrueTypeRef, ftTrueTypeEmbed,
    ftPackaged, ftType1, ftSubset, ftType3, ftType1CID, ftTrueTypeCID,
    ftCJK);

  TWidthsArray = array of Integer;

  TPDFKernPair = record
    Match: Cardinal;
    Adjust: Integer;
  end;

  TQuickPDFWidthLookup = class
  private
    FCodeCount: Integer;
    FCharacterCodes: array of Word;
    FWidths: array of Integer;
    FSorted: Boolean;
    procedure SortList;
  public
    constructor Create;
    procedure AddWidth(CharacterCode: Word; Width: Integer);
    function GetWidth(CharacterCode: Word): Integer;
    property CodeCount: Integer read FCodeCount;
  end;

  TPDFFont = class
  private
    FStructure: TPDFStructure;
    FCompress: Boolean;
    FName: AnsiString;
    FFontName: AnsiString;
    FFontFamily: AnsiString;
    FIndRef: TPDFIndRef;
    FFontType: TPDFFontType;
    FIsEmbedded: Boolean;
    FIsSubsetted: Boolean;
    FCIDWidths: AnsiString;
    Widths: TWidthsArray;
    FirstChar, LastChar: Integer;
    FAscent: Integer;
    FDescent: Integer;
    FAscentTM: Integer;
    FDescentTM: Integer;
    FInternalLeading: Integer;
    FExternalLeading: Integer;
    FHeight: Integer;
    FAveCharWidth: Integer;
    FBound: TRect;
    FFontDict: TPDFDictionary;
    FToUnicodeSource: TQuickPDFCaseSensitiveStringList;
    FToUnicodeTarget: TQuickPDFCaseSensitiveStringList;
    KernPairs: array of TPDFKernPair;
    FEncodingCMap: TDebenuPDFLibraryCMap;
    FWidthLookup: TQuickPDFWidthLookup;
    //FGIDToCID: array[0..255] of Word;
    FGIDToCID: array of Word;          // ADC
    FCIDSystemInfo: AnsiString;
    FCanUpdate: Boolean;
    FAutoUpdate: Boolean;
    FNeedsUpdate: Boolean;
    FOriginalOptions: Integer;
    FOriginalCharset: Integer;
    FHasDescendantFont: Boolean;
    FCharsUsed: array of Byte;
    CIDKeepCodes: array of Word;
    GIDCodes: array of Word;

    procedure GetSymbolWidths(var Widths: TWidthsArray; FontIndex: Integer);
    function FindKernPair(C1, C2: AnsiChar): Integer;
    function MakeCMap(const BaseEncoding: AnsiString; Differences: TPDFArray): AnsiString;
    procedure SetupEncodingCMap(const BaseEncoding: AnsiString; Differences: TPDFArray);
    procedure SetupSimpleUnicodeCMap;
  public
    constructor Create(AStructure: TPDFStructure; const AName: AnsiString);
    destructor Destroy; override;
    property Name: AnsiString read FName;
    property IndRef: TPDFIndRef read FIndRef;
    property FontName: AnsiString read FFontName;
    property FontFamily: AnsiString read FFontFamily;
    property FontType: TPDFFontType read FFontType;
    property IsEmbedded: Boolean read FIsEmbedded;
    property IsSubsetted: Boolean read FIsSubsetted;
    property OriginalCharset: Integer read FOriginalCharset write FOriginalCharset;
    function CharWidth(AChar: Integer): Integer;

    procedure SetCharWidth(AChar, NewWidth: Integer);
    procedure NewStandardFont(const BaseFont: AnsiString; FontIndex: Integer);
    function NewTrueTypeFont(BaseFont: AnsiString; Embed, Force, LoadKernPairs: Boolean): Boolean;
    function NewOpenTypeFont(Source: TStream): Boolean;
    function NewTrueTypeFontFromStream(Source: TStream): Boolean;
    function NewPackagedFont(const FontPack: WideString): Boolean;
    function NewType1Font(const FileName: WideString): Boolean;
    procedure QSortWordArray(var A: array of Word);
    function NewSubsettedFont(const FontName: AnsiString; CharSet: Integer; const SubsetChars: WideString; Scaled: Boolean = True): Boolean;
    //function ConvertCIDToGID(Text: WideString): WideString;
    function NewSubsettedTrueTypeFont(const FontName: AnsiString; SubsetChars: WideString; Options: Integer; Update: Boolean; Charset: Integer; Embed: Boolean): Boolean;
    function NewCJKFont(CJKFontID: Integer): Boolean;
    function FixText(const Source: AnsiString): AnsiString;
    function FixWideText(const Source: WideString): WideString;
    function CharacterExists(C: WideChar): Boolean;
    procedure SetEncoding(const EncodingName: AnsiString);
    function GetEncoding: AnsiString;
    procedure PopulateFromIndRef(IndRef: TPDFIndRef);
    function GetSubsetString(const Input: WideString): AnsiString;
    function SaveToFile(const FileName: WideString): Boolean;
    function FontSize: Integer;
    function GetFontIsSubsetted: Integer;
    function GetFontIsEmbedded: Integer;
    function GetKernAmount(C1, C2: WideChar): Integer;
    procedure SetKernAmount(C1, C2: WideChar; Amount: Integer);
    function HasKernData: Boolean;
    procedure AddToSubset(S: WideString; UpdateWidths: Boolean = True);
    procedure SetName(const Name: AnsiString);
    procedure SetFlags(Fixed, Serif, Symbolic, Script, Italic, AllCap,
      SmallCap, ForceBold: Boolean);
    function GetFlags(FontFlagItemID: Integer): Integer;
    function GetCharacterCodes(const Text: WideString): AnsiString;
    function GetGIDToCID(const GID: Integer): Word;
    procedure UpdateSubsettedFont(UpdateFontDescriptor: Boolean = True);
    property Ascent: Integer read FAscent;
    property Descent: Integer read FDescent;
    property AscentTM: Integer read FAscentTM;
    property DescentTM: Integer read FDescentTM;
    property InternalLeading: Integer read FInternalLeading;
    property ExternalLeading: Integer read FExternalLeading;
    property Height: Integer read FHeight;
    property AveCharWidth: Integer read FAveCharWidth;
    property Bound: TRect read FBound;
    property Compress: Boolean read FCompress write FCompress;
    property InitChar: Integer read FirstChar;
    property CanUpdate: Boolean read FCanUpdate;
    property AutoUpdate: Boolean read FAutoUpdate;
    property NeedsUpdate: Boolean read FNeedsUpdate write FNeedsUpdate;
    property CIDSystemInfo: AnsiString read FCIDSystemInfo write FCIDSystemInfo;
    property HasDescendantFont: Boolean read FHasDescendantFont;
  end;

procedure GetWidthsByEncoding(Encoding: TPDFEncodingVector;
  var Widths: TWidthsArray; PDFFontNumber: Integer);

function IsOpenType(Stream: TStream): Boolean;

implementation

uses
  SysUtils, DebenuPDFLibraryFlate, DebenuPDFLibraryDigest,
{$IFNDEF VER120}
  contnrs,
{$ENDIF}
  DebenuPDFLibraryTTFVector, DebenuPDFLibraryPainter, DebenuPDFLibraryType1, DebenuPDFLibraryTrueTypeParser,
  DebenuPDFLibraryBuffer;

{ TPDFFont }

const
  AFMFontWidths: array[1..12, 1..229] of Integer = (
    // Courier
    (600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600,
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600,
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600),

    // Courier-Bold
    (600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600,
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600,
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600),

    // Courier-BoldOblique
    (600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600,
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600),

    // Courier-Oblique
    (600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600,
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600,
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 600, 
    600, 600, 600, 600, 600),

    // Helvetica
    (667, 1000, 667, 667, 667, 667, 667, 667, 667, 722, 722, 722, 667, 667, 
    667, 667, 667, 722, 556, 611, 778, 722, 278, 278, 278, 278, 278, 500, 667, 
    556, 556, 833, 722, 722, 778, 1000, 778, 778, 778, 778, 778, 778, 667, 
    778, 722, 667, 667, 611, 667, 722, 722, 722, 722, 722, 667, 944, 667, 667, 
    667, 667, 611, 611, 556, 556, 556, 333, 556, 889, 556, 667, 556, 469, 584, 
    389, 1015, 556, 556, 278, 260, 334, 334, 278, 278, 333, 260, 350, 500, 
    333, 500, 333, 556, 333, 278, 278, 737, 556, 556, 556, 556, 400, 333, 584, 
    556, 333, 278, 556, 556, 556, 556, 556, 556, 1000, 1000, 556, 584, 556, 
    278, 333, 278, 500, 556, 500, 556, 556, 167, 556, 611, 333, 584, 556, 556, 
    333, 333, 556, 333, 333, 222, 278, 278, 278, 278, 222, 500, 222, 584, 584,
    222, 833, 333, 584, 556, 584, 556, 556, 556, 556, 556, 556, 556, 556, 944, 
    333, 556, 556, 834, 834, 333, 370, 365, 611, 556, 556, 537, 333, 333, 889, 
    278, 278, 1000, 584, 584, 556, 556, 611, 355, 333, 333, 333, 222, 222, 
    222, 191, 333, 737, 333, 500, 500, 556, 278, 556, 556, 278, 278, 556, 278, 
    556, 556, 834, 333, 333, 1000, 556, 333, 556, 556, 556, 556, 556, 556, 
    500, 722, 500, 500, 500, 500, 556, 500, 500, 556),

    // Helvetica-Bold
    (722, 1000, 722, 722, 722, 722, 722, 722, 722, 722, 722, 722, 667, 667, 
    667, 667, 667, 722, 556, 611, 778, 722, 278, 278, 278, 278, 278, 556, 722, 
    611, 611, 833, 722, 722, 778, 1000, 778, 778, 778, 778, 778, 778, 667, 
    778, 722, 667, 667, 611, 667, 722, 722, 722, 722, 722, 667, 944, 667, 667, 
    667, 667, 611, 611, 556, 556, 556, 333, 556, 889, 556, 722, 556, 584, 584, 
    389, 975, 556, 611, 278, 280, 389, 389, 333, 333, 333, 280, 350, 556, 333, 
    556, 333, 556, 333, 333, 278, 737, 556, 611, 556, 556, 400, 333, 584, 556, 
    333, 278, 556, 556, 556, 556, 556, 556, 1000, 1000, 556, 584, 611, 333, 
    333, 333, 611, 556, 611, 556, 556, 167, 611, 611, 333, 584, 556, 556, 333, 
    333, 611, 333, 333, 278, 278, 278, 278, 278, 278, 556, 278, 584, 584, 278, 
    889, 333, 584, 611, 584, 611, 556, 611, 556, 611, 611, 611, 611, 944, 333,
    611, 556, 834, 834, 333, 370, 365, 611, 611, 611, 556, 333, 333, 889, 278, 
    278, 1000, 584, 584, 611, 611, 611, 474, 500, 500, 500, 278, 278, 278, 
    238, 389, 737, 333, 556, 556, 556, 333, 556, 556, 278, 278, 556, 333, 611, 
    556, 834, 333, 333, 1000, 556, 333, 611, 611, 611, 611, 611, 556, 556, 
    778, 556, 556, 556, 556, 556, 500, 500, 556),

    // Helvetica-BoldOblique
    (722, 1000, 722, 722, 722, 722, 722, 722, 722, 722, 722, 722, 667, 667, 
    667, 667, 667, 722, 556, 611, 778, 722, 278, 278, 278, 278, 278, 556, 722,
    611, 611, 833, 722, 722, 778, 1000, 778, 778, 778, 778, 778, 778, 667, 
    778, 722, 667, 667, 611, 667, 722, 722, 722, 722, 722, 667, 944, 667, 667, 
    667, 667, 611, 611, 556, 556, 556, 333, 556, 889, 556, 722, 556, 584, 584, 
    389, 975, 556, 611, 278, 280, 389, 389, 333, 333, 333, 280, 350, 556, 333, 
    556, 333, 556, 333, 333, 278, 737, 556, 611, 556, 556, 400, 333, 584, 556, 
    333, 278, 556, 556, 556, 556, 556, 556, 1000, 1000, 556, 584, 611, 333, 
    333, 333, 611, 556, 611, 556, 556, 167, 611, 611, 333, 584, 556, 556, 333, 
    333, 611, 333, 333, 278, 278, 278, 278, 278, 278, 556, 278, 584, 584, 278, 
    889, 333, 584, 611, 584, 611, 556, 611, 556, 611, 611, 611, 611, 944, 333, 
    611, 556, 834, 834, 333, 370, 365, 611, 611, 611, 556, 333, 333, 889, 278,
    278, 1000, 584, 584, 611, 611, 611, 474, 500, 500, 500, 278, 278, 278, 
    238, 389, 737, 333, 556, 556, 556, 333, 556, 556, 278, 278, 556, 333, 611, 
    556, 834, 333, 333, 1000, 556, 333, 611, 611, 611, 611, 611, 556, 556, 
    778, 556, 556, 556, 556, 556, 500, 500, 556),

    // Helvetica-Oblique
    (667, 1000, 667, 667, 667, 667, 667, 667, 667, 722, 722, 722, 667, 667, 
    667, 667, 667, 722, 556, 611, 778, 722, 278, 278, 278, 278, 278, 500, 667, 
    556, 556, 833, 722, 722, 778, 1000, 778, 778, 778, 778, 778, 778, 667, 
    778, 722, 667, 667, 611, 667, 722, 722, 722, 722, 722, 667, 944, 667, 667, 
    667, 667, 611, 611, 556, 556, 556, 333, 556, 889, 556, 667, 556, 469, 584, 
    389, 1015, 556, 556, 278, 260, 334, 334, 278, 278, 333, 260, 350, 500,
    333, 500, 333, 556, 333, 278, 278, 737, 556, 556, 556, 556, 400, 333, 584, 
    556, 333, 278, 556, 556, 556, 556, 556, 556, 1000, 1000, 556, 584, 556, 
    278, 333, 278, 500, 556, 500, 556, 556, 167, 556, 611, 333, 584, 556, 556, 
    333, 333, 556, 333, 333, 222, 278, 278, 278, 278, 222, 500, 222, 584, 584, 
    222, 833, 333, 584, 556, 584, 556, 556, 556, 556, 556, 556, 556, 556, 944, 
    333, 556, 556, 834, 834, 333, 370, 365, 611, 556, 556, 537, 333, 333, 889, 
    278, 278, 1000, 584, 584, 556, 556, 611, 355, 333, 333, 333, 222, 222,
    222, 191, 333, 737, 333, 500, 500, 556, 278, 556, 556, 278, 278, 556, 278, 
    556, 556, 834, 333, 333, 1000, 556, 333, 556, 556, 556, 556, 556, 556, 
    500, 722, 500, 500, 500, 500, 556, 500, 500, 556),

    // Times-Roman
    (722, 889, 722, 722, 722, 722, 722, 722, 667, 667, 667, 722, 611, 611, 
    611, 611, 611, 722, 500, 556, 722, 722, 333, 333, 333, 333, 333, 389, 722, 
    611, 611, 889, 722, 722, 722, 889, 722, 722, 722, 722, 722, 722, 556, 722, 
    667, 556, 556, 611, 556, 722, 722, 722, 722, 722, 722, 944, 722, 722, 722, 
    722, 611, 611, 444, 444, 444, 333, 444, 667, 444, 778, 444, 469, 541, 500, 
    921, 444, 500, 278, 200, 480, 480, 333, 333, 333, 200, 350, 444, 333, 444, 
    333, 500, 333, 278, 250, 760, 500, 500, 500, 500, 400, 333, 564, 500, 333, 
    278, 444, 444, 444, 444, 444, 500, 1000, 1000, 500, 564, 500, 333, 333, 
    333, 556, 500, 556, 500, 500, 167, 500, 500, 333, 564, 500, 500, 333, 333, 
    500, 333, 333, 278, 278, 278, 278, 278, 278, 500, 278, 564, 564, 278, 778,
    333, 564, 500, 564, 500, 500, 500, 500, 500, 500, 500, 500, 722, 333, 500, 
    500, 750, 750, 300, 276, 310, 500, 500, 500, 453, 333, 333, 833, 250, 250, 
    1000, 564, 564, 500, 444, 444, 408, 444, 444, 444, 333, 333, 333, 180, 
    333, 760, 333, 389, 389, 500, 278, 500, 500, 278, 250, 500, 278, 500, 500,
    750, 300, 333, 980, 500, 300, 500, 500, 500, 500, 500, 500, 500, 722, 500, 
    500, 500, 500, 500, 444, 444, 500),

    // Times-Bold
    (722, 1000, 722, 722, 722, 722, 722, 722, 667, 722, 722, 722, 667, 667, 
    667, 667, 667, 722, 500, 611, 778, 778, 389, 389, 389, 389, 389, 500, 778, 
    667, 667, 944, 722, 722, 778, 1000, 778, 778, 778, 778, 778, 778, 611, 
    778, 722, 556, 556, 667, 611, 722, 722, 722, 722, 722, 722, 1000, 722, 
    722, 722, 722, 667, 667, 500, 500, 500, 333, 500, 722, 500, 833, 500, 581, 
    520, 500, 930, 500, 556, 278, 220, 394, 394, 333, 333, 333, 220, 350, 444, 
    333, 444, 333, 500, 333, 333, 250, 747, 500, 556, 500, 500, 400, 333, 570, 
    500, 333, 278, 444, 444, 444, 444, 444, 500, 1000, 1000, 500, 570, 500, 
    333, 333, 333, 556, 500, 556, 500, 500, 167, 500, 556, 333, 570, 500, 500, 
    333, 333, 556, 333, 333, 278, 278, 278, 278, 278, 333, 556, 278, 570, 570, 
    278, 833, 333, 570, 556, 570, 556, 500, 556, 500, 500, 500, 500, 500, 722, 
    333, 500, 500, 750, 750, 300, 300, 330, 500, 500, 556, 540, 333, 333, 1000, 
    250, 250, 1000, 570, 570, 556, 500, 500, 555, 500, 500, 500, 333, 333, 
    333, 278, 444, 747, 333, 389, 389, 500, 333, 500, 500, 278, 250, 500, 333,
    556, 500, 750, 300, 333, 1000, 500, 300, 556, 556, 556, 556, 556, 500,
    500, 722, 500, 500, 500, 500, 500, 444, 444, 500),

    // Times-Italic
    (611, 889, 611, 611, 611, 611, 611, 611, 611, 667, 667, 722, 611, 611, 
    611, 611, 611, 722, 500, 611, 722, 722, 333, 333, 333, 333, 333, 444, 667, 
    556, 556, 833, 667, 667, 722, 944, 722, 722, 722, 722, 722, 722, 611, 722, 
    611, 500, 500, 556, 611, 722, 722, 722, 722, 722, 611, 833, 611, 556, 556, 
    556, 556, 556, 500, 500, 500, 333, 500, 667, 500, 778, 500, 422, 541, 500, 
    920, 500, 500, 278, 275, 400, 400, 389, 389, 333, 275, 350, 444, 333, 444, 
    333, 500, 333, 333, 250, 760, 500, 500, 500, 500, 400, 333, 675, 500, 333, 
    278, 444, 444, 444, 444, 444, 500, 889, 889, 500, 675, 500, 333, 389, 278, 
    500, 500, 500, 500, 500, 167, 500, 500, 333, 675, 500, 500, 333, 333, 500, 
    333, 333, 278, 278, 278, 278, 278, 278, 444, 278, 675, 675, 278, 722, 333, 
    675, 500, 675, 500, 500, 500, 500, 500, 500, 500, 500, 667, 333, 500, 500, 
    750, 750, 300, 276, 310, 500, 500, 500, 523, 333, 333, 833, 250, 250, 1000, 
    675, 675, 500, 500, 500, 420, 556, 556, 556, 333, 333, 333, 214, 389, 760, 
    333, 389, 389, 500, 333, 500, 500, 278, 250, 500, 278, 500, 500, 750, 300, 
    333, 980, 500, 300, 500, 500, 500, 500, 500, 500, 444, 667, 444, 444, 444, 
    444, 500, 389, 389, 500),

    // Times-BoldItalic
    (667, 944, 667, 667, 667, 667, 667, 667, 667, 667, 667, 722, 667, 667, 
    667, 667, 667, 722, 500, 667, 722, 778, 389, 389, 389, 389, 389, 500, 667, 
    611, 611, 889, 722, 722, 722, 944, 722, 722, 722, 722, 722, 722, 611, 722, 
    667, 556, 556, 611, 611, 722, 722, 722, 722, 722, 667, 889, 667, 611, 611, 
    611, 611, 611, 500, 500, 500, 333, 500, 722, 500, 778, 500, 570, 570, 500, 
    832, 500, 500, 278, 220, 348, 348, 333, 333, 333, 220, 350, 444, 333, 444, 
    333, 500, 333, 333, 250, 747, 500, 500, 500, 500, 400, 333, 570, 500, 333, 
    278, 444, 444, 444, 444, 444, 500, 1000, 1000, 500, 570, 500, 389, 389, 
    333, 556, 500, 556, 500, 500, 167, 500, 500, 333, 570, 500, 500, 333, 333, 
    556, 333, 333, 278, 278, 278, 278, 278, 278, 500, 278, 570, 606, 278, 778, 
    333, 606, 576, 570, 556, 500, 556, 500, 500, 500, 500, 500, 722, 333, 500, 
    500, 750, 750, 300, 266, 300, 500, 500, 500, 500, 333, 333, 833, 250, 250, 
    1000, 570, 570, 500, 500, 500, 555, 500, 500, 500, 333, 333, 333, 278, 
    389, 747, 333, 389, 389, 500, 333, 500, 500, 278, 250, 500, 278, 500, 500, 
    750, 300, 333, 1000, 500, 300, 556, 556, 556, 556, 556, 500, 444, 667, 
    500, 444, 444, 444, 500, 389, 389, 500)
  );

  CharacterEncodings: array[1..229, 1..4] of Integer = ((65, 65, 65, 65),
    (225, 174, 198, 198), (-1, 231, 193, 193), (-1, 229, 194, 194),
    (-1, 128, 196, 196), (-1, 203, 192, 192), (-1, 129, 197, 197),
    (-1, 204, 195, 195), (66, 66, 66, 66), (67, 67, 67, 67),
    (-1, 130, 199, 199), (68, 68, 68, 68), (69, 69, 69, 69),
    (-1, 131, 201, 201), (-1, 230, 202, 202), (-1, 232, 203, 203),
    (-1, 233, 200, 200), (-1, -1, 208, 208), (-1, -1, 128, 160),
    (70, 70, 70, 70), (71, 71, 71, 71), (72, 72, 72, 72), (73, 73, 73, 73),
    (-1, 234, 205, 205), (-1, 235, 206, 206), (-1, 236, 207, 207),
    (-1, 237, 204, 204), (74, 74, 74, 74), (75, 75, 75, 75), (76, 76, 76, 76),
    (232, -1, -1, 149), (77, 77, 77, 77), (78, 78, 78, 78), (-1, 132, 209, 209),
    (79, 79, 79, 79), (234, 206, 140, 150), (-1, 238, 211, 211),
    (-1, 239, 212, 212), (-1, 133, 214, 214), (-1, 241, 210, 210),
    (233, 175, 216, 216), (-1, 205, 213, 213), (80, 80, 80, 80),
    (81, 81, 81, 81), (82, 82, 82, 82), (83, 83, 83, 83), (-1, -1, 138, 151),
    (84, 84, 84, 84), (-1, -1, 222, 222), (85, 85, 85, 85), (-1, 242, 218, 218),
    (-1, 243, 219, 219), (-1, 134, 220, 220), (-1, 244, 217, 217),
    (86, 86, 86, 86), (87, 87, 87, 87), (88, 88, 88, 88), (89, 89, 89, 89),
    (-1, -1, 221, 221), (-1, 217, 159, 152), (90, 90, 90, 90),
    (-1, -1, 142, 153), (97, 97, 97, 97), (-1, 135, 225, 225),
    (-1, 137, 226, 226), (194, 171, 180, 180), (-1, 138, 228, 228),
    (241, 190, 230, 230), (-1, 136, 224, 224), (38, 38, 38, 38),
    (-1, 140, 229, 229), (94, 94, 94, 94), (126, 126, 126, 126),
    (42, 42, 42, 42), (64, 64, 64, 64), (-1, 139, 227, 227), (98, 98, 98, 98),
    (92, 92, 92, 92), (124, 124, 124, 124), (123, 123, 123, 123),
    (125, 125, 125, 125), (91, 91, 91, 91), (93, 93, 93, 93),
    (198, 249, -1, 24), (-1, -1, 166, 166), (183, 165, 149, 128),
    (99, 99, 99, 99), (207, 255, -1, 25), (-1, 141, 231, 231),
    (203, 252, 184, 184), (162, 162, 162, 162), (195, 246, 136, 26),
    (58, 58, 58, 58), (44, 44, 44, 44), (-1, 169, 169, 169),
    (168, 219, 164, 164), (100, 100, 100, 100), (178, 160, 134, 129),
    (179, 224, 135, 130), (-1, 161, 176, 176), (200, 172, 168, 168),
    (-1, 214, 247, 247), (36, 36, 36, 36), (199, 250, -1, 27),
    (245, 245, -1, 154), (101, 101, 101, 101), (-1, 142, 233, 233),
    (-1, 144, 234, 234), (-1, 145, 235, 235), (-1, 143, 232, 232),
    (56, 56, 56, 56), (188, 201, 133, 131), (208, 209, 151, 132),
    (177, 208, 150, 133), (61, 61, 61, 61), (-1, -1, 240, 240),
    (33, 33, 33, 33), (161, 193, 161, 161), (102, 102, 102, 102),
    (174, 222, -1, 147), (53, 53, 53, 53), (175, 223, -1, 148),
    (166, 196, 131, 134), (52, 52, 52, 52), (164, 218, -1, 135),
    (103, 103, 103, 103), (251, 167, 223, 223), (193, 96, 96, 96),
    (62, 62, 62, 62), (171, 199, 171, 171), (187, 200, 187, 187),
    (172, 220, 139, 136), (173, 221, 155, 137), (104, 104, 104, 104),
    (205, 253, -1, 28), (45, 45, 45, 45), (105, 105, 105, 105),
    (-1, 146, 237, 237), (-1, 148, 238, 238), (-1, 149, 239, 239),
    (-1, 147, 236, 236), (106, 106, 106, 106), (107, 107, 107, 107),
    (108, 108, 108, 108), (60, 60, 60, 60), (-1, 194, 172, 172),
    (248, -1, -1, 155), (109, 109, 109, 109), (197, 248, 175, 175),
    (-1, -1, -1, 138), (-1, 181, 181, 181), (-1, -1, 215, 215),
    (110, 110, 110, 110), (57, 57, 57, 57), (-1, 150, 241, 241),
    (35, 35, 35, 35), (111, 111, 111, 111), (-1, 151, 243, 243),
    (-1, 153, 244, 244), (-1, 154, 246, 246), (250, 207, 156, 156),
    (206, 254, -1, 29), (-1, 152, 242, 242), (49, 49, 49, 49),
    (-1, -1, 189, 189), (-1, -1, 188, 188), (-1, -1, 185, 185),
    (227, 187, 170, 170), (235, 188, 186, 186), (249, 191, 248, 248),
    (-1, 155, 245, 245), (112, 112, 112, 112), (182, 166, 182, 182),
    (40, 40, 40, 40), (41, 41, 41, 41), (37, 37, 37, 37),
    (46, 46, 46, 46), (180, 225, 183, 183), (189, 228, 137, 139),
    (43, 43, 43, 43), (-1, 177, 177, 177), (113, 113, 113, 113),
    (63, 63, 63, 63), (191, 192, 191, 191), (34, 34, 34, 34),
    (185, 227, 132, 140), (170, 210, 147, 141), (186, 211, 148, 142),
    (96, 212, 145, 143), (39, 213, 146, 144), (184, 226, 130, 145),
    (169, 39, 39, 39), (114, 114, 114, 114), (-1, 168, 174, 174),
    (202, 251, -1, 30), (115, 115, 115, 115), (-1, -1, 154, 157),
    (167, 164, 167, 167), (59, 59, 59, 59), (55, 55, 55, 55),
    (54, 54, 54, 54), (47, 47, 47, 47), (32, 32, 32, 32),
    (163, 163, 163, 163), (116, 116, 116, 116), (-1, -1, 254, 254),
    (51, 51, 51, 51), (-1, -1, 190, 190), (-1, -1, 179, 179),
    (196, 247, 152, 31), (-1, 170, 153, 146), (50, 50, 50, 50),
    (-1, -1, 178, 178), (117, 117, 117, 117), (-1, 156, 250, 250),
    (-1, 158, 251, 251), (-1, 159, 252, 252), (-1, 157, 249, 249),
    (95, 95, 95, 95), (118, 118, 118, 118), (119, 119, 119, 119),
    (120, 120, 120, 120), (121, 121, 121, 121), (-1, -1, 253, 253),
    (-1, 216, 255, 255), (165, 180, 165, 165), (122, 122, 122, 122),
    (-1, -1, 158, 158), (48, 48, 48, 48));

  SymbolWidths: array[32..254] of Integer = (250, 333, 713, 500, 549, 833, 778,
    439, 333, 333, 500, 549, 250, 549, 250, 278, 500, 500, 500, 500, 500, 500,
    500, 500, 500, 500, 278, 278, 549, 549, 549, 444, 549, 722, 667, 722, 612,
    611, 763, 603, 722, 333, 631, 722, 686, 889, 722, 722, 768, 741, 556, 592,
    611, 690, 439, 768, 645, 795, 611, 333, 863, 333, 658, 500, 500, 631, 549,
    549, 494, 439, 521, 411, 603, 329, 603, 549, 549, 576, 521, 549, 549, 521,
    549, 603, 439, 576, 713, 686, 493, 686, 494, 480, 200, 480, 549, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 750, 620,
    247, 549, 167, 713, 500, 753, 753, 753, 753, 1042, 987, 603, 987, 603, 400,
    549, 411, 549, 549, 713, 494, 460, 549, 549, 549, 549, 1000, 603, 1000, 658,
    823, 686, 795, 987, 768, 768, 823, 768, 768, 713, 713, 713, 713, 713, 713,
    713, 768, 713, 790, 790, 890, 823, 549, 250, 713, 603, 603, 1042, 987, 603,
    987, 603, 494, 329, 790, 790, 786, 713, 384, 384, 384, 384, 384, 384, 494,
    494, 494, 494, 0, 329, 274, 686, 686, 686, 384, 384, 384, 384, 384, 384, 494,
    494, 494);

procedure GetWidthsByEncoding(Encoding: TPDFEncodingVector;
  var Widths: TWidthsArray; PDFFontNumber: Integer);
var
  X: Integer;
  S: Integer;  // Special
  D: Integer;
  I: Integer;
begin
  I := 1;
  if Encoding = peStandard then I := 1;
  if Encoding = peMacRoman then I := 2;
  if Encoding = peWinAnsi then I := 3;
  if Encoding = pePDFDoc then I := 4;
  SetLength(Widths, 255 - 24 + 1);
  for X := 24 to 255 do
  begin
    Widths[X - 24] := 0;
    S := X;
    if (X = 160) and (Encoding = peWinAnsi) then S := 32;
    if (X = 202) and (Encoding = peMacRoman) then S := 32;
    case PDFFontNumber of
      1..12:
      begin
        for D := 1 to 229 do
        begin
          if CharacterEncodings[D, I] = S then
            Widths[X - 24] := AFMFontWidths[PDFFontNumber, D];
        end;
      end;
      13:
      begin
        if (X >= 32) and (X <= 254) then
          Widths[X - 24] := SymbolWidths[X];
      end;
      14:
      begin
        if (X >= 32) and (X <= 254) then
          Widths[X - 24] := ZapfDingbatsWidths[X];
      end;
    end;
  end;
end;

function TPDFFont.CharacterExists(C: WideChar): Boolean;
begin
  Result := FEncodingCMap.ContainsCode(2, Ord(C));
end;

function TPDFFont.CharWidth(AChar: Integer): Integer;
var
  UB: AnsiChar;
  BX: Integer;
  FC: Integer;
  FI: Integer;
  TempW: Integer;
  ACharB: Integer;
  I: Integer;
begin
  if (AChar = 160) then
  begin
    AChar := 32;
  end;

  if (FWidthLookup.CodeCount > 0) then
  begin
    Result := FWidthLookup.GetWidth(AChar);
  end else
  if FFontType = ftTrueTypeCID then
  begin
    if (CIDSystemInfo = 'Adobe-Identity-0') then
    begin
      BX := -1;
      for I := 0 to Length(AdobeGIDToUnicode) - 1 do
        if (AChar = AdobeGIDToUnicode[I]) then
          BX := I + 2;

      if (BX > 0) then
        Result := Widths[BX]
      else
        Result := Widths[AChar];
    end
    else
      Result := Widths[AChar];
  end
  else if FFontType = ftCJK then
  begin
    Result := 1000;
    FC := Length(FCIDWidths) div 513;
    UB := AnsiChar((AChar and $FF00) shr 8);
    FI := 0;
    BX := 0;
    while (FI = 0) and (BX < FC) do
    begin
//    for BX := 0 to FC - 1 do
      if FCIDWidths[BX * 513 + 1] = UB then
        FI := BX * 513 + 2;
      BX := BX + 1;
    end;
    if FI > 0 then
    begin
      FC := FI + (AChar and $FF) * 2;
      TempW := Ord(FCIDWidths[FC]) * 256 + Ord(FCIDWidths[FC + 1]);
      if TempW <> 0 then
        Result := TempW;
    end;
  end else
  begin
    ACharB := FEncodingCMap.GetMappingToWord(2, AChar);
    if ((ACharB >= FirstChar) and (ACharB - FirstChar <= LastChar)) then
    begin
      Result := Widths[ACharB - FirstChar];
    end else
    begin
      Result := 0;
    end;
  end;
end;

constructor TPDFFont.Create(AStructure: TPDFStructure;
  const AName: AnsiString);
begin
  FStructure := AStructure;
  FName := AName;
  FFontType := ftUnknown;
  FFontDict := nil;
  FCompress := False;
  FToUnicodeSource := TQuickPDFCaseSensitiveStringList.Create;
  FToUnicodeTarget := TQuickPDFCaseSensitiveStringList.Create;
  FEncodingCMap := TDebenuPDFLibraryCMap.Create;
  FWidthLookup := TQuickPDFWidthLookup.Create;
  FCanUpdate := False;
  FAutoUpdate := False;
  FNeedsUpdate := False;
end;

destructor TPDFFont.Destroy;
begin
  FToUnicodeSource.Free;
  FToUnicodeTarget.Free;
  FEncodingCMap.Free;
  FWidthLookup.Free;
  inherited;
end;

function TPDFFont.FindKernPair(C1, C2: AnsiChar): Integer;
var
  Match: Cardinal;
  X: Integer;
begin
  Result := -1;
  Match := Ord(C1) shl 16 + Ord(C2);
  X := 0;
  while (X < Length(KernPairs)) and (Result < 0) do
  begin
    if KernPairs[X].Match = Match then
      Result := X
    else
      Inc(X);
  end;
end;

function TPDFFont.FixText(const Source: AnsiString): AnsiString;
var
  X: Integer;
  I: Integer;
  D: Integer;
begin
  Result := '';
  if (FFontType = ftType1CID) or (FFontType = ftTrueTypeCID) then
  begin
    if FToUnicodeSource.Count > 0 then
    begin
      for X := 1 to Length(Source) do
      begin
        I := FToUnicodeSource.IndexOf(AnsiChar(0) + Source[X]);
        if I >= 0 then
        begin
          I := Integer(FToUnicodeSource.Objects[I]);
          if (I >= 0) and (I < FToUnicodeTarget.Count) then
            Result := Result + FToUnicodeTarget[I];
        end;
      end;
    end else
      for X := 1 to Length(Source) do
        Result := Result + #0 + Source[X];
  end else
  if FFontType = ftCJK then
  begin
    if QPLCopy(Source, 1, 2) = #$FF#$FE then
    begin
      Result := '';
      for X := 1 to (Length(Source) - 2) div 2 do
        Result := Result + Source[X * 2 + 1] + Source[X * 2 + 2];
    end else
    if QPLCopy(Source, 1, 2) = #$FE#$FF then
    begin
      Result := QPLCopy(Source, 3, MaxInt);
    end else
      Result := '';
  end else
  begin
    D := 0;
    SetLength(Result, Length(Source));
    for X := 1 to Length(Source) do
    begin
      if (Ord(Source[X]) >= FirstChar) and (Ord(Source[X]) <= LastChar)
        and (Widths[Ord(Source[X]) - FirstChar] > 0) then
        begin
          Inc(D);
          Result[D] := Source[X];
        end;
    end;
    SetLength(Result, D);
  end;
end;

function TPDFFont.FixWideText(const Source: WideString): WideString;
var
  X: Integer;
begin
  Result := '';
  if (FAutoUpdate) then
  begin
    AddToSubset(Source);
  end;
  for X := 1 to Length(Source) do
  begin
    if (CharacterExists(Source[X]) or (Source[X] = AnsiChar(160))) then
    begin
      Result := Result + Source[X];
    end
    else if (FontType = ftTrueTypeCID) then
      Result := Result + Source[X];
  end;
end;

function TPDFFont.FontSize: Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  Obj := FFontDict.FindValueByKeyName('Subtype', True);
  if (Obj is TPDFName) and (TPDFName(Obj).Name = 'TrueType') then
  begin
    Obj := FFontDict.FindValueByKeyName('FontDescriptor', True);
    if Obj is TPDFDictionary then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName('FontFile2', True);
      if Obj is TPDFStream then
        Result := Length(TPDFStream(Obj).Stream);

      Obj := TPDFDictionary(Obj).FindValueByKeyName('FontFile3', True);
      if Obj is TPDFStream then
        Result := Length(TPDFStream(Obj).Stream);
    end;
  end;
end;

function TPDFFont.GetFontIsSubsetted: Integer;
begin
  Result := 0;
  if (IsSubsetted) then
    Result := 1;

end;

function TPDFFont.GetFontIsEmbedded: Integer;
begin
  Result := 0;
  if (IsEmbedded) then
    Result := 1;
end;

function TPDFFont.GetKernAmount(C1, C2: WideChar): Integer;
var
  I: Integer;
begin
  I := FindKernPair(AnsiChar(C1), AnsiChar(C2));
  if I >= 0 then
    Result := KernPairs[I].Adjust
  else
    Result := 0;
end;

function TPDFFont.GetSubsetString(const Input: WideString): AnsiString;
var
  X: Integer;
  I: Integer;
  Obj: TPDFObject;
  Differences: TPDFArray;
  Mapping: TQuickPDFStringList;
  Offset: Integer;
  WC: WideChar;
  CharName: AnsiString;
begin
  if FFontType = ftSubset then
  begin
    Mapping := TQuickPDFStringList.Create;
    try
      for X := 0 to 255 do
        Mapping.Add('');
      Obj := FFontDict.FindValueByKeyName('Encoding', True);
      if (Obj is TPDFDictionary) and (TPDFDictionary(Obj).DictType = 'Encoding') then
      begin
        Obj := TPDFDictionary(Obj).FindValueByKeyName('Differences', True);
        Offset := 0;
        if Obj is TPDFArray then
        begin
          Differences := TPDFArray(Obj);
          for X := 0 to Differences.Count - 1 do
          begin
            if Differences.Item[X] is TPDFNumeric then
              Offset := TPDFNumeric(Differences.Item[X]).AsInteger;
            if Differences.Item[X] is TPDFName then
            begin
              Mapping[Offset] := TPDFName(Differences.Item[X]).Name;
              Inc(Offset);
            end;
          end;
        end;
      end;
      Result := '';
      for X := 1 to Length(Input) do
      begin
        WC := Input[X];
        CharName := 'QuickPDF' + QPLIntToHex(Word(WC), 4);
        I := Mapping.IndexOf(CharName);
        if I >= 0 then
          Result := Result + AnsiChar(I);
      end;
    finally
      Mapping.Free;
    end;
  end else
    Result := AnsiString(Input);
end;

procedure TPDFFont.GetSymbolWidths(var Widths: TWidthsArray; FontIndex: Integer);
var
  X: Integer;
begin
  SetLength(Widths, 254 - 32 + 1);
  if FontIndex = 13 then
    for X := 32 to 254 do
      Widths[X - 32] := SymbolWidths[X];
  if FontIndex = 14 then
    for X := 32 to 254 do
      Widths[X - 32] := ZapfDingbatsWidths[X];
end;

function TPDFFont.HasKernData: Boolean;
begin
  Result := Length(KernPairs) > 0;
end;

function TPDFFont.NewPackagedFont(const FontPack: WideString): Boolean;
var
  FontStream: TPDFStream;
  ObjNum, GenNum: Integer;
  S: AnsiString;
  Dict: TPDFDictionary;
  FontFile: TPDFIndRef;
  FontDescriptor: TPDFIndRef;
  BaseFont: AnsiString;

  UncompLen: Integer;

  FS: TQuickPDFWideFileStream;

  X: Integer;
  R1, R2, R3, R4: Integer;
begin
  Result := True;
  FS := QPLCreateFileStream(FontPack, fmOpenRead or fmShareDenyWrite);
  try
    FS.Seek(0, soFromBeginning);
    FS.Read(X, SizeOf(X));//

    SetLength(BaseFont, X);//
    FS.Read(BaseFont[1], X);//
    FFontName := BaseFont;

    FS.Read(X, SizeOf(X));//
    SetLength(S, X);//
    FS.Read(S[1], X);//

    UncompLen := Length(S);

    if FCompress then
    begin
      FontStream := FStructure.NewStream(DeflateStr(S));
      FontStream.Dictionary.Add('Filter', FStructure.NewCommonName('FlateDecode'));
    end else
      FontStream := FStructure.NewStream(S);

    if Assigned(FStructure.OnNewIndObj) then
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, FontStream);
    FontFile := FStructure.NewIndirectRef(ObjNum, GenNum);
    FontStream.Dictionary.Add('Length1', FStructure.NewNumeric(UncompLen));

    Dict := FStructure.NewDictionary;
    Dict.Add('Type', FStructure.NewName('FontDescriptor'));
    Dict.Add('FontName', FStructure.NewName(BaseFont));

    FS.Read(R1, SizeOf(R1));//
    FS.Read(R2, SizeOf(R2));//
    FS.Read(R3, SizeOf(R3));//
    FS.Read(R4, SizeOf(R4));//
    FBound.Left := R1;
    FBound.Top := R4;
    FBound.Right := R3;
    FBound.Bottom := R2;

    Dict.Add('FontBBox', FStructure.NewIntArray([R1, R2, R3, R4]));
    Dict.Add('Flags', FStructure.NewNumeric(34));
    Dict.Add('MissingWidth', FStructure.NewNumeric(750));
    Dict.Add('StemV', FStructure.NewNumeric(0));

    FS.Read(X, SizeOf(X));//
    Dict.Add('ItalicAngle', FStructure.NewNumeric(X));
    FS.Read(X, SizeOf(X));//
    Dict.Add('CapHeight', FStructure.NewNumeric(X));
    FS.Read(X, SizeOf(X));//
    Dict.Add('Ascent', FStructure.NewNumeric(X));
    FAscent := X;
    FS.Read(X, SizeOf(X));//
    Dict.Add('Descent', FStructure.NewNumeric(X));
    FDescent := X;    
    FS.Read(X, SizeOf(X));//
    Dict.Add('MaxWidth', FStructure.NewNumeric(X));
    FS.Read(X, SizeOf(X));//
    Dict.Add('AvgWidth', FStructure.NewNumeric(X));

    Dict.Add('FontFile2', FontFile);

    if Assigned(FStructure.OnNewIndObj) then
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, Dict);
    FontDescriptor := FStructure.NewIndirectRef(ObjNum, GenNum);

    Dict := FStructure.NewDictionary;
    FFontDict := Dict;
    Dict.Add('Type', FStructure.NewName('Font'));
    Dict.Add('Subtype', FStructure.NewName('TrueType'));
    Dict.Add('BaseFont', FStructure.NewName(BaseFont));
    Dict.Add('Encoding',  FStructure.NewName('WinAnsiEncoding'));

    FS.Read(FirstChar, SizeOf(FirstChar));//
    Dict.Add('FirstChar', FStructure.NewNumeric(FirstChar));
    FS.Read(LastChar, SizeOf(LastChar));//
    Dict.Add('LastChar', FStructure.NewNumeric(LastChar));
    FS.Read(X, SizeOf(X));//

    SetLength(Widths, X);
    for X := 0 to Length(Widths) - 1 do
      FS.Read(Widths[X], SizeOf(Widths[X]));

    Dict.Add('Widths', FStructure.NewIntArray(Widths));
    Dict.Add('FontDescriptor', FontDescriptor);
    FFontType := ftPackaged;

    if Assigned(FStructure.OnNewIndObj) then
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, Dict);
    FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
  finally
    FS.Free;
  end;
end;

procedure TPDFFont.NewStandardFont(const BaseFont: AnsiString; FontIndex: Integer);
var
  FontDict: TPDFDictionary;
  ObjNum, GenNum: Integer;
  CharCode: Integer;
  Target: TQPLByteArray;
begin
  FFontName := BaseFont;
  FontDict := FStructure.NewDictionary;
  FFontDict := FontDict;
  FontDict.Add('Type', FStructure.NewCommonName('Font'));
  FontDict.Add('Subtype', FStructure.NewCommonName('Type1'));
  FontDict.Add('BaseFont', FStructure.NewCommonName(BaseFont));
  if (BaseFont = 'Symbol') then
  begin
    FirstChar := 32;
    LastChar := 254;
    GetSymbolWidths(Widths, FontIndex);
    FEncodingCMap.AddCodespaceRange(32, 254, 1);
    SetLength(Target, 1);
    for CharCode := 1 to 189 do
    begin
      if (SymbolEncodingVector[CharCode] >= 0) then
      begin
        Target[0] := SymbolEncodingVector[CharCode];
        FEncodingCMap.AddMapping(2, SymbolUnicodeValues[CharCode], Target);
      end;
    end;
  end else
  if (BaseFont = 'ZapfDingbats') then
  begin
    FirstChar := 32;
    LastChar := 254;
    GetSymbolWidths(Widths, FontIndex);
    FEncodingCMap.AddCodespaceRange(32, 254, 1);
    SetLength(Target, 1);
    for CharCode := 32 to 254 do
    begin
      Target[0] := CharCode;
      FEncodingCMap.AddMapping(2, CharCode, Target);
    end;
  end else
  begin
    FontDict.Add('Encoding', FStructure.NewCommonName('WinAnsiEncoding'));
    FirstChar := 24;
    LastChar := 255;
    GetWidthsByEncoding(peWinAnsi, Widths, FontIndex);
    SetupEncodingCMap('WinAnsiEncoding', nil);
  end;
  FHeight := 1000;
  FAscent := FontMetrics[FontIndex, 5];
  FDescent := FontMetrics[FontIndex, 6];
  FBound.Left := FontMetrics[FontIndex, 1];
  FBound.Top := FontMetrics[FontIndex, 4];
  FBound.Right := FontMetrics[FontIndex, 3];
  FBound.Bottom := FontMetrics[FontIndex, 2];
  if Assigned(FStructure.OnNewIndObj) then
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, FontDict);
  FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
  FFontType := ftStandard;
end;

function TPDFFont.NewSubsettedFont(const FontName: AnsiString;
  CharSet: Integer; const SubsetChars: WideString; Scaled: Boolean): Boolean;
var
  Dict: TPDFDictionary;
  Encoding: TPDFDictionary;
  CharProcs: TPDFDictionary;
  ToUnicode: AnsiString;
  ToUnicodeStream: TPDFStream;
  BBox: array[1..4] of Integer;
  GlyphBBox: array[1..4] of Integer;
  ObjNum: Integer;
  GenNum: Integer;
  VC: TTTFToVectorConverter;
  CharX: Integer;
  X: Integer;
  CX, CY: Double;
  Parts: TObjectList;
  Painter: TPDFPainter;
  PX: Integer;
  CtAX, CtAY: Double;
  CtBX, CtBY: Double;
  Content: TPDFStream;
  ThisChar: Word;
  CharName: AnsiString;
  Differences: TPDFArray;
  Mapping: array[0..255] of AnsiString;
  DoubleByte: AnsiString;
  SingleByte: AnsiString;
  MapPos: Integer;
  ScreenDC: HDC;
  ScreenDPI: Integer;
  U1: AnsiString;
  U2: AnsiString;
  UCount: Integer;
  BM: TBitmap;
  Metrics: TOutlineTextMetricA;
  FontStyle: TFontStyles;
  BaseFont: AnsiString;
  CharCount: Integer;
  Target: TQPLByteArray;
begin
  Result := True;
  BBox[1] := 1000;
  BBox[2] := 1000;
  BBox[3] := 0;
  BBox[4] := 0;
  Dict := FStructure.NewDictionary;
  FFontDict := Dict;
  Encoding := FStructure.NewDictionary;
  CharProcs := FStructure.NewDictionary;
  Differences := FStructure.NewArray;
  Encoding.Add('Type', FStructure.NewName('Encoding'));
  Encoding.Add('Differences', Differences);
  FirstChar := 0;
  LastChar := 255;
  SetLength(Widths, 256);
  FFontType := ftSubset;

  BaseFont := FontName;
  FontStyle := [];
  if QPLCopy(BaseFont, Length(BaseFont) - 6, 7) = ' [Bold]' then
  begin
    FontStyle := [fsBold];
    Delete(BaseFont, Length(BaseFont) - 6, 7);
  end;
  if QPLCopy(BaseFont, Length(BaseFont) - 8, 9) = ' [Italic]' then
  begin
    FontStyle := [fsItalic];
    Delete(BaseFont, Length(BaseFont) - 8, 9);
  end;
  if QPLCopy(BaseFont, Length(BaseFont) - 12, 13) = ' [BoldItalic]' then
  begin
    FontStyle := [fsBold, fsItalic];
    Delete(BaseFont, Length(BaseFont) - 12, 13);
  end;

  for X := 0 to 255 do
  begin
    Mapping[X] := '';
    Widths[X] := 0;
  end;

{$IFNDEF QPL_OS_WINDOWS}
  ScreenDPI := 96;
{$ELSE}
  ScreenDC := GetDC(0);
  try
    ScreenDPI := GetDeviceCaps(ScreenDC, LOGPIXELSX);
  finally
    ReleaseDC(0, ScreenDC);
  end;
{$ENDIF}

  SetLength(Target, 1);
  CharCount := Length(SubsetChars);
  for CharX := 1 to CharCount do
  begin
    GlyphBBox[1] := 1000;
    GlyphBBox[2] := 1000;
    GlyphBBox[3] := 0;
    GlyphBBox[4] := 0;
    Painter := TPDFPainter.Create;
    try
      Painter.PDFPrecNum := 2;
      ThisChar := Word(SubsetChars[CharX]);

      VC := TTTFToVectorConverter.Create;
      try
        VC.Font.Name := QPLAnsiToNative(BaseFont);
        VC.Font.Style := FontStyle;
        if ScreenDPI > 0 then
          VC.Font.Size := Round(72000 / ScreenDPI)
        else
          VC.Font.Size := 750;
        VC.Font.Charset := CharSet;

        VC.GetCharacterGlyphs(ThisChar);
        for X := 0 to Length(VC.CurveCollection.StartPoints) - 1 do
        begin
          CX := VC.CurveCollection.StartPoints[X].X;
          CY := VC.CurveCollection.StartPoints[X].Y;
          if Round(CX) < GlyphBBox[1] then GlyphBBox[1] := Round(CX);
          if Round(CX) > GlyphBBox[3] then GlyphBBox[3] := Round(CX);
          if Round(CY) < GlyphBBox[2] then GlyphBBox[2] := Round(CY);
          if Round(CY) > GlyphBBox[4] then GlyphBBox[4] := Round(CY);
          if X = 0 then
            Painter.StartPath(CX, CY)
          else
            Painter.MovePath(CX, CY);

          Parts := VC.CurveCollection.Parts[X];
          for PX := 0 to Parts.Count - 1 do
          begin
            if Parts.Items[PX] is TFontLine then
            begin
              CX := TFontLine(Parts.Items[PX]).EndPoint.X;
              CY := TFontLine(Parts.Items[PX]).EndPoint.Y;
              if Round(CX) < GlyphBBox[1] then GlyphBBox[1] := Round(CX);
              if Round(CX) > GlyphBBox[3] then GlyphBBox[3] := Round(CX);
              if Round(CY) < GlyphBBox[2] then GlyphBBox[2] := Round(CY);
              if Round(CY) > GlyphBBox[4] then GlyphBBox[4] := Round(CY);
              Painter.AddLineToPath(CX, CY);
            end;
            if Parts.Items[PX] is TFontSpline then
            begin
              CtAX := TFontSpline(Parts.Items[PX]).ControlA.X;
              CtAY := TFontSpline(Parts.Items[PX]).ControlA.Y;
              CtBX := TFontSpline(Parts.Items[PX]).ControlB.X;
              CtBY := TFontSpline(Parts.Items[PX]).ControlB.Y;
              CX := TFontSpline(Parts.Items[PX]).EndPoint.X;
              CY := TFontSpline(Parts.Items[PX]).EndPoint.Y;
              if Round(CX) < GlyphBBox[1] then GlyphBBox[1] := Round(CX);
              if Round(CX) > GlyphBBox[3] then GlyphBBox[3] := Round(CX);
              if Round(CY) < GlyphBBox[2] then GlyphBBox[2] := Round(CY);
              if Round(CY) > GlyphBBox[4] then GlyphBBox[4] := Round(CY);
              Painter.AddCurveToPath(CtAX, CtAY, CtBX, CtBY, CX, CY);
            end;
          end;
          Painter.ClosePath;
        end;
        if GlyphBBox[1] < BBox[1] then BBox[1] := GlyphBBox[1];
        if GlyphBBox[2] < BBox[2] then BBox[2] := GlyphBBox[2];
        if GlyphBBox[3] > BBox[3] then BBox[3] := GlyphBBox[3];
        if GlyphBBox[4] > BBox[4] then BBox[4] := GlyphBBox[4];
        Painter.HideLineProperties;
        Painter.DrawPath(True, False);
        Content := FStructure.NewStream('');
        Content.SetTo(QPLIntToStr(VC.CharWidth) +
          ' 0 ' + QPLIntToStr(GlyphBBox[1]) + ' ' +
          QPLIntToStr(GlyphBBox[2]) + ' ' +
          QPLIntToStr(GlyphBBox[3]) + ' ' +
          QPLIntToStr(GlyphBBox[4]) + ' d1'#10 + Painter.Source, True);
        if Assigned(FStructure.OnNewIndObj) then
          FStructure.OnNewIndObj(Self, ObjNum, GenNum, Content);
        FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
        CharName := 'QuickPDF' + QPLIntToHex(ThisChar, 4);
        CharProcs.Add(CharName, FIndRef);
        if ThisChar <= 255 then
        begin
          DoubleByte := AnsiString(WideChar(ThisChar));
          SingleByte := DoubleByte;
          MapPos := Ord(SingleByte[1]);
        end else
          MapPos := 255;
        if Mapping[MapPos] = '' then
        begin
          Mapping[MapPos] := CharName;
          Widths[MapPos] := VC.CharWidth;
        end else
        begin
          MapPos := 255;
          while (MapPos > 0) and (Mapping[MapPos] <> '') do
            Dec(MapPos);
          if MapPos > 0 then
          begin
            Mapping[MapPos] := CharName;
            Widths[MapPos] := VC.CharWidth;
          end;
        end;
        Target[0] := MapPos;
        FEncodingCMap.AddMapping(2, ThisChar, Target);
      finally
        VC.Free;
      end;
    finally
      Painter.Free;
    end;
  end;

  while (Mapping[FirstChar] = '') and (FirstChar < LastChar) do
    Inc(FirstChar);
  while (Mapping[LastChar] = '') and (LastChar > FirstChar) do
    Dec(LastChar);
  for X := 0 to 255 - FirstChar do
  begin
    Mapping[X] := Mapping[FirstChar + X];
    Widths[X] := Widths[FirstChar + X];
  end;
  for X := 255 - FirstChar + 1 to 255 do
    Mapping[X] := '';
  SetLength(Widths, LastChar - FirstChar + 1);

  UCount := 0;
  U2 := '';
  U1 := 'beginbfchar'#10;
  for X := 0 to 255 do
  begin
    if Mapping[X] <> '' then
    begin
      U1 := U1 + '<' + QPLIntToHex(X + FirstChar, 2) + '> ';
      U1 := U1 + '<' + QPLCopy(Mapping[X], 9, 4) + '>'#10;
      Inc(UCount);
      if UCount >= 50 then
      begin
        U1 := QPLIntToStr(UCount) + ' ' + U1 + 'endbfchar'#10;
        U2 := U2 + U1;
        U1 := 'beginbfchar'#10;
        UCount := 0;
      end;
      if (X = 0) or (Mapping[X - 1] = '') then
        Differences.Add(FStructure.NewNumeric(X + FirstChar));
      Differences.Add(FStructure.NewName(Mapping[X]));
    end;
  end;
  if UCount > 0 then
  begin
    U1 := QPLIntToStr(UCount) + ' ' + U1 + 'endbfchar'#10;
    U2 := U2 + U1;
  end;

  ToUnicode :=
    '%!PS-Adobe-3.0 Resource-CMap'#13 +
    '/CIDInit /ProcSet findresource begin'#10 +
    '12 dict begin'#10 +
    ''#10 +
    'begincmap'#10 +
    '/CIDSystemInfo 3 dict dup begin'#10 +
    '/Registry (Adobe) def'#10 +
    '/Ordering () def'#10 +
    '/Supplement 0 def'#10 +
    'end def'#10 +
    ''#10 +
    '/CMapName /Adobe--000 def'#10 +
    '/CMapType 2 def'#10 +
    ''#10 +
    'WMode 0 def'#10 +
    ''#10 +
    '1 begincodespacerange'#10 +
    '<00> <FF>'#10 +
    'endcodespacerange'#10 + U2 +
    ''#10 +
    'endcmap'#10 +
    'CMapName currentdict /CMap'#10 +
    'defineresource pop'#10 +
    'end'#10 +
    'end';

  BM := TBitmap.Create;
  try
    BM.Width := 10;
    BM.Height := 10;
    BM.Canvas.Lock;
    BM.Canvas.Font.Name := QPLAnsiToNative(BaseFont);
    BM.Canvas.Font.Style := FontStyle;
    if ScreenDPI > 0 then
      BM.Canvas.Font.Size := Round(72000 / ScreenDPI)
    else
      BM.Canvas.Font.Size := 750;
    BM.Canvas.Font.Charset := CharSet;

{$IFDEF QPL_OS_WINDOWS}
    GetOutlineTextMetricsA(BM.Canvas.Handle, SizeOf(Metrics), @Metrics);
{$ENDIF}

    FAscent := Metrics.otmAscent;
    FDescent := -Abs(Metrics.otmDescent);

    FAscentTM := Metrics.otmTextMetrics.tmAscent;
    FDescentTM := -Abs(Metrics.otmTextMetrics.tmDescent);

    FInternalLeading := Metrics.otmTextMetrics.tmInternalLeading;
    FExternalLeading := Metrics.otmTextMetrics.tmExternalLeading;
    FHeight := Metrics.otmTextMetrics.tmHeight;
    FAveCharWidth := Metrics.otmTextMetrics.tmAveCharWidth;

  finally
    BM.Free;
  end;

  {
  FBound.Left := BBox[1];
  FBound.Top := BBox[4];
  FBound.Right := BBox[3];
  FBound.Bottom := BBox[2];
  }
  FBound.Left := Metrics.otmrcFontBox.Left;
  FBound.Top := Metrics.otmrcFontBox.Top;
  FBound.Right := Metrics.otmrcFontBox.Right;
  FBound.Bottom := Metrics.otmrcFontBox.Bottom;

  Dict.Add('Type', FStructure.NewName('Font'));
  Dict.Add('Subtype', FStructure.NewName('Type3'));
  Dict.Add('FontBBox', FStructure.NewIntArray(BBox));
  if Scaled then
  begin
    Dict.Add('FontMatrix', FStructure.NewDoubleArray(
      [0.001, 0, 0, 0.001, 0, 0]));
  end else
  begin
    Dict.Add('FontMatrix', FStructure.NewDoubleArray([1, 0, 0, 1, 0, 0]));
  end;

  Dict.Add('Encoding', Encoding);
  Dict.Add('CharProcs', CharProcs);
  Dict.Add('FirstChar', FStructure.NewNumeric(FirstChar));
  Dict.Add('LastChar', FStructure.NewNumeric(LastChar));
  Dict.Add('Widths', FStructure.NewIntArray(Widths));
  ToUnicodeStream := FStructure.NewStream('');
  ToUnicodeStream.SetTo(ToUnicode, True);
  with ToUnicodeStream.Dictionary do
  begin
    Add('Type', FStructure.Decode('/CMap'));
    Add('CMapName', FStructure.Decode('/Adobe--000'));
    Add('CIDSystemInfo', FStructure.Decode('<< /Registry (Adobe) /Ordering () /Supplement 0 >>'));
    Add('WMode', FStructure.NewNumeric(0));
  end;
  if Assigned(FStructure.OnNewIndObj) then
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, ToUnicodeStream);
  FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
  Dict.Add('ToUnicode', FIndRef);

  if Assigned(FStructure.OnNewIndObj) then
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, Dict);
  FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
end;

{$IFDEF QPL_NOVCL}
const
  JOHAB_CHARSET = 130;
  VIETNAMESE_CHARSET = 163;
{$ENDIF}

function TPDFFont.NewTrueTypeFont(BaseFont: AnsiString; Embed, Force, LoadKernPairs: Boolean): Boolean;
var
  FontStream: TPDFStream;
  ObjNum, GenNum: Integer;
  BM: TBitmap;
  Metrics: TOutlineTextMetricA;
  Len: Cardinal;
  S: AnsiString;
  Dict: TPDFDictionary;
  FontFile: TPDFIndRef;
  FontDescriptor: TPDFIndRef;
  EncodingDict: TPDFDictionary;
  GlyphIndices: array[0..255] of word;
  fl: Word;

  C: AnsiChar;
  UncompLen: Integer;
  CodePageWidthS: AnsiString;
  CodePageWidthWS: WideString;
  Flags: Integer;
  CodePage: Integer;
  Charset: Integer;
  Differences: AnsiString;
  DefaultCodePage: Boolean;
  ScreenDC: HDC;
  ScreenDPI: Integer;
  KP: array of TKerningPair;
  KPN: Cardinal;

  // TrueType Collection fonts
  TTCLen: Cardinal;
  TTCOffset: Cardinal;
  TrueTypeParser: TPDFTrueTypeParser;

  // ToUnicode
  DifferencesArray: TPDFObject;
  ToUnicodeData: AnsiString;
  ToUnicodeStream: TPDFStream;
  ToUnicodeRef: TPDFIndRef;

  // CMap for symbol fonts
  I: Integer;
  Target: TQPLByteArray;

  procedure SortKP;
  var
    KX: Integer;
    KL: Integer;
    Swapped: Boolean;
    KT: TKerningPair;
  begin
    KL := Length(KP);
    Swapped := True;
    while Swapped do
    begin
      Swapped := False;
      for KX := 0 to KL - 2 do
      begin
        if (KP[KX].wFirst shl 16 + KP[KX].wSecond) >
          (KP[KX + 1].wFirst shl 16 + KP[KX + 1].wSecond) then
        begin
          KT := KP[KX];
          KP[KX] := KP[KX + 1];
          KP[KX + 1] := KT;
          Swapped := True;
        end;
      end;
    end;
  end;

begin
  CodePage := -1;
  DefaultCodePage := True;
  Charset := DEFAULT_CHARSET;
  Differences := '';
  ToUnicodeData := '';

  FFontName := BaseFont;
  if QPLPos('{', BaseFont) > 0 then
  begin
    S := QPLCopy(BaseFont, QPLPos('{', BaseFont) + 1, MaxInt);
    if QPLPos('}', S) > 0 then
    begin
      DefaultCodePage := False;
      Delete(S, QPLPos('}', S), MaxInt);
      CodePage := QPLStrToIntDef(S, 0);
      Delete(BaseFont, QPLPos('{', BaseFont), MaxInt);
      BaseFont := QPLTrim(BaseFont);
      case CodePage of
        437: Charset := OEM_CHARSET;
        850: Charset := OEM_CHARSET;
        852: Charset := OEM_CHARSET;
        874: Charset := THAI_CHARSET;
        932: Charset := SHIFTJIS_CHARSET;
        936: Charset := GB2312_CHARSET;
        949: Charset := HANGEUL_CHARSET;
        950: Charset := CHINESEBIG5_CHARSET;
        1250: Charset := EASTEUROPE_CHARSET;
        1251: Charset := RUSSIAN_CHARSET;
        1252: Charset := ANSI_CHARSET;
        1253: Charset := GREEK_CHARSET;
        1254: Charset := TURKISH_CHARSET;
        1255: Charset := HEBREW_CHARSET;
        1256: Charset := ARABIC_CHARSET;
        1257: Charset := BALTIC_CHARSET;
        1258: Charset := VIETNAMESE_CHARSET;
        1361: Charset := JOHAB_CHARSET;
      end;
    end;
  end;

  BM := TBitmap.Create;
  try
    BM.Canvas.Lock;
    BM.Canvas.Font.Style := [];
    if QPLCopy(BaseFont, Length(BaseFont) - 6, 7) = ' [Bold]' then
    begin
      BM.Canvas.Font.Style := [fsBold];
      Delete(BaseFont, Length(BaseFont) - 6, 7);
    end;
    if QPLCopy(BaseFont, Length(BaseFont) - 8, 9) = ' [Italic]' then
    begin
      BM.Canvas.Font.Style := [fsItalic];
      Delete(BaseFont, Length(BaseFont) - 8, 9);
    end;
    if QPLCopy(BaseFont, Length(BaseFont) - 12, 13) = ' [BoldItalic]' then
    begin
      BM.Canvas.Font.Style := [fsBold, fsItalic];
      Delete(BaseFont, Length(BaseFont) - 12, 13);
    end;

    BM.Canvas.Font.Name := QPLAnsiToNative(BaseFont);
    BM.Canvas.Font.Charset := Charset;
    BM.Canvas.Font.Size := 750;

{$IFNDEF QPL_OS_WINDOWS}
    ScreenDPI := 96;
    BM.Canvas.Font.Size := Round(72000 / ScreenDPI);
{$ELSE}
    ScreenDC := GetDC(0);
    try
      ScreenDPI := GetDeviceCaps(ScreenDC, LOGPIXELSX);
      if ScreenDPI > 0 then
        BM.Canvas.Font.Size := Round(72000 / ScreenDPI);
    finally
      ReleaseDC(0, ScreenDC);
    end;

    SetLength(S, 256);
    for I := 0 to 255 do
      S[I+1] := AnsiChar(I);

    SetLength(FGIDToCID, 256);  // ADC

    // Get the GlyphIndesx for ETO_GLPYH_INDEX for the EMF import
    GetGlyphIndicesA(BM.Canvas.Handle, @S[1], 256, @GlyphIndices, GGI_MARK_NONEXISTING_GLYPHS);
    for I := 0 to 255 do
    begin
      if (GlyphIndices[I] <= 255) then
        FGIDToCID[GlyphIndices[I]] := I
      else
        FGIDToCID[I] := 65535;
    end;

    GetOutlineTextMetricsA(BM.Canvas.Handle, SizeOf(Metrics), @Metrics);
{$ENDIF}

    if (Embed and ((Metrics.otmfsType and 1) = 1)) and (not Force) then
    begin
      Result := False;
    end else
    begin
      Result := True;

{$IFNDEF QPL_OS_WINDOWS}
      SetLength(KernPairs, 0);
{$ELSE}
      if LoadKernPairs then
      begin
        KPN := GetKerningPairs(BM.Canvas.Handle, 0, PKerningPair(nil)^);
        SetLength(KP, KPN);
        if KPN > 0 then
        begin
          GetKerningPairs(BM.Canvas.Handle, KPN, KP[0]);
          SortKP;
          SetLength(KernPairs, Length(KP));
          for KPN := 0 to Length(KP) - 1 do
          begin
            KernPairs[KPN].Match := KP[KPN].wFirst shl 16 + KP[KPN].wSecond;
            KernPairs[KPN].Adjust := -KP[KPN].iKernAmount;
          end;
        end;
      end else
        SetLength(KernPairs, 0);
{$ENDIF}

      if Embed then
      begin
        FFontType := ftTrueTypeEmbed;

{$IFDEF QPL_OS_WINDOWS}
        // Check for a TrueType Collection
        TTCLen := GetFontData(BM.Canvas.Handle, $66637474, 0, nil, 0);

        Len := GetFontData(BM.Canvas.Handle, 0, 0, nil, 0);
        if (Len > 0) and (Len < $FFFFFFFF) then
        begin
          SetLength(S, Len);
          GetFontData(BM.Canvas.Handle, 0, 0, @S[1], Len);
          if (TTCLen > 0) and (TTCLen <> GDI_ERROR) then
          begin
            TTCOffset := TTCLen - Len;
            TrueTypeParser := TPDFTrueTypeParser.Create;
            try
              TrueTypeParser.ShiftTableOffsets(S, TTCOffset);
            finally
              TrueTypeParser.Free;
            end;
          end;
        end else
          S := '';
{$ENDIF}

        UncompLen := Length(S);

        if FCompress then
        begin
          FontStream := FStructure.NewStream(DeflateStr(S));
          FontStream.Dictionary.Add('Filter', FStructure.NewCommonName('FlateDecode'));
        end else
          FontStream := FStructure.NewStream(S);

        if Assigned(FStructure.OnNewIndObj) then
          FStructure.OnNewIndObj(Self, ObjNum, GenNum, FontStream);
        FontFile := FStructure.NewIndirectRef(ObjNum, GenNum);
        FontStream.Dictionary.Add('Length1', FStructure.NewNumeric(UncompLen));
      end else
      begin
        FontFile := nil;
        FFontType := ftTrueTypeRef;
      end;

      Dict := FStructure.NewDictionary;
      Dict.Add('Type', FStructure.NewName('FontDescriptor'));

      BaseFont := QPLStringReplace(BaseFont, ' ', '', [rfReplaceAll]);
      if BM.Canvas.Font.Style = [fsBold] then
        BaseFont := BaseFont + ',Bold';
      if BM.Canvas.Font.Style = [fsItalic] then
        BaseFont := BaseFont + ',Italic';
      if BM.Canvas.Font.Style = [fsBold, fsItalic] then
        BaseFont := BaseFont + ',BoldItalic';
      Dict.Add('FontName', FStructure.NewName(BaseFont));
      with Metrics do
      begin
        Dict.Add('FontBBox', FStructure.NewIntArray([otmrcFontBox.Left,
          otmrcFontBox.Bottom, otmrcFontBox.Right, otmrcFontBox.Top]));
{$IFNDEF QPL_CPP}
        FBound := otmrcFontBox;
{$ENDIF}
        Flags := 0;
        if otmTextMetrics.tmCharSet = SYMBOL_CHARSET then
          Flags := Flags + 4 else Flags := Flags + 32;
        if (otmTextMetrics.tmPitchAndFamily and
          TMPF_FIXED_PITCH) = TMPF_FIXED_PITCH then
            Flags := Flags + 1;
        Dict.Add('Flags', FStructure.NewNumeric(Flags));
        Dict.Add('MissingWidth', FStructure.NewNumeric(750));
        Dict.Add('StemV', FStructure.NewNumeric(0));
        Dict.Add('ItalicAngle', FStructure.NewNumeric(otmItalicAngle));
        Dict.Add('CapHeight', FStructure.NewNumeric(Metrics.otmTextMetrics.tmAscent));

        FAscent := otmAscent;
        FDescent := -Abs(otmDescent);

        FAscentTM := Metrics.otmTextMetrics.tmAscent;
        FDescentTM := -Abs(Metrics.otmTextMetrics.tmDescent);
        FInternalLeading := Metrics.otmTextMetrics.tmInternalLeading;
        FExternalLeading := Metrics.otmTextMetrics.tmExternalLeading;
        FHeight := Metrics.otmTextMetrics.tmHeight;
        FAveCharWidth := Metrics.otmTextMetrics.tmAveCharWidth;

        Dict.Add('Ascent', FStructure.NewNumeric(FAscent));
        Dict.Add('Descent', FStructure.NewNumeric(FDescent));
        Dict.Add('MaxWidth', FStructure.NewNumeric(otmTextMetrics.tmMaxCharWidth));
        Dict.Add('AvgWidth', FStructure.NewNumeric(otmTextMetrics.tmAveCharWidth));
      end;
      if Embed then
        Dict.Add('FontFile2', FontFile);

      if Assigned(FStructure.OnNewIndObj) then
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, Dict);
      FontDescriptor := FStructure.NewIndirectRef(ObjNum, GenNum);

      Dict := FStructure.NewDictionary;
      FFontDict := Dict;
      Dict.Add('Type', FStructure.NewName('Font'));
      Dict.Add('Subtype', FStructure.NewName('TrueType'));
      Dict.Add('BaseFont', FStructure.NewName(BaseFont));

      if CodePage = 437 then
        Differences := '[ 128 /Ccedilla /udieresis /eacute /acircumflex ' +
          '/adieresis /agrave /aring /ccedilla /ecircumflex /edieresis ' +
          '/egrave /idieresis /icircumflex /igrave /Adieresis /Aring ' +
          '/Eacute /ae /AE /ocircumflex /odieresis /ograve /ucircumflex ' +
          '/ugrave /ydieresis /Odieresis /Udieresis /cent /sterling ' +
          '/yen /peseta /florin /aacute /iacute /oacute /uacute /ntilde ' +
          '/Ntilde /ordfeminine /ordmasculine /questiondown ' +
          '/logicalnotreversed /logicalnot /onehalf /onequarter ' +
          '/exclamdown /guillemotleft /guillemotright /ltshade /shade ' +
          '/dkshade /SF110000 /SF090000 /SF190000 /SF200000 /SF210000 ' +
          '/SF220000 /SF230000 /SF240000 /SF250000 /SF260000 /SF270000 ' +
          '/SF280000 /SF030000 /SF020000 /SF070000 /SF060000 /SF080000 ' +
          '/SF100000 /SF050000 /SF360000 /SF370000 /SF380000 /SF390000 ' +
          '/SF400000 /SF410000 /SF420000 /SF430000 /SF440000 /SF450000 ' +
          '/SF460000 /SF470000 /SF480000 /SF490000 /SF500000 /SF510000 ' +
          '/SF520000 /SF530000 /SF540000 /SF040000 /SF010000 /block ' +
          '/dnblock /lfblock /rtblock /upblock /alpha /germandbls /Gamma ' +
          '/pi /Sigma /sigma /mu /tau /Phi /Theta /Omegagreek /delta ' +
          '/infinity /phi /epsilon /intersection /equivalence /plusminus ' +
          '/greaterequal /lessequal /integraltop /integralbottom /divide ' +
          '/approxequal /degree /bulletoperator /middot /radical /nsuperior ' +
          '/twosuperior /blacksquare /nbspace ]';

      if CodePage = 850 then
        Differences := '[ 128 /Ccedilla /udieresis /eacute /acircumflex ' +
          '/adieresis /agrave /aring /ccedilla /ecircumflex /edieresis ' +
          '/egrave /idieresis /icircumflex /igrave /Adieresis /Aring ' +
          '/Eacute /ae /AE /ocircumflex /odieresis /ograve /ucircumflex ' +
          '/ugrave /ydieresis /Odieresis /Udieresis /oslash /sterling ' +
          '/Oslash /multiply /florin /aacute /iacute /oacute /uacute ' +
          '/ntilde /Ntilde /ordfeminine /ordmasculine /questiondown ' +
          '/registered /logicalnot /onehalf /onequarter /exclamdown ' +
          '/guillemotleft /guillemotright /ltshade /shade /dkshade ' +
          '/SF110000 /SF090000 /Aacute /Acircumflex /Agrave /copyright ' +
          '/SF230000 /SF240000 /SF250000 /SF260000 /cent /yen /SF030000 ' +
          '/SF020000 /SF070000 /SF060000 /SF080000 /SF100000 /SF050000 ' +
          '/atilde /Atilde /SF380000 /SF390000 /SF400000 /SF410000 ' +
          '/SF420000 /SF430000 /SF440000 /currency /eth /Eth /Ecircumflex ' +
          '/Edieresis /Egrave /dotlessi /Iacute /Icircumflex /Idieresis ' +
          '/SF040000 /SF010000 /block /dnblock /brokenbar /Igrave /upblock ' +
          '/Oacute /germandbls /Ocircumflex /Ograve /otilde /Otilde /mu ' +
          '/thorn /Thorn /Uacute /Ucircumflex /Ugrave /yacute /Yacute ' +
          '/macron /acute /sfthyphen /plusminus /dbllowline /threequarters ' +
          '/paragraph /section /divide /cedilla /degree /dieresis /middot ' +
          '/onesuperior /threesuperior /twosuperior /blacksquare /nbspace ]';

      if CodePage = 852 then
        Differences := '[ 128 /Ccedilla /udieresis /eacute /acircumflex ' +
          '/adieresis /uring /cacute /ccedilla /lslash /edieresis ' +
          '/Odblacute /odblacute /icircumflex /Zacute /Adieresis /Cacute ' +
          '/Eacute /Lacute /lacute /ocircumflex /odieresis /Lcaron /lcaron ' +
          '/Sacute /sacute /Odieresis /Udieresis /Tcaron /tcaron /Lslash ' +
          '/multiply /ccaron /aacute /iacute /oacute /uacute /Aogonek ' +
          '/aogonek /Zcaron /zcaron /Eogonek /eogonek 171 /zacute /Ccaron ' +
          '/scedilla /guillemotleft /guillemotright /ltshade /shade ' +
          '/dkshade /SF110000 /SF090000 /Aacute /Acircumflex /Ecaron ' +
          '/Scedilla /SF230000 /SF240000 /SF250000 /SF260000 /Zdot /zdot ' +
          '/SF030000 /SF020000 /SF070000 /SF060000 /SF080000 /SF100000 ' +
          '/SF050000 /Abreve /abreve /SF380000 /SF390000 /SF400000 ' +
          '/SF410000 /SF420000 /SF430000 /SF440000 /currency /dcroat ' +
          '/Dcroat /Dcaron /Edieresis /dcaron /Ncaron /Iacute /Icircumflex ' +
          '/ecaron /SF040000 /SF010000 /block /dnblock /Tcedilla /Uring ' +
          '/upblock /Oacute /germandbls /Ocircumflex /Nacute /nacute ' +
          '/ncaron /Scaron /scaron /Racute /Uacute /racute /Udblacute ' +
          '/yacute /Yacute /tcedilla /acute /sfthyphen /hungarumlaut ' +
          '/ogonek /caron /breve /section /divide /cedilla /degree ' +
          '/dieresis /dotaccent /udblacute /Rcaron /rcaron /blacksquare ' +
          '/nbspace ]';

      if CodePage = 874 then
        Differences := '[ 161 /kokaithai /khokhaithai /khokhuatthai ' +
          '/khokhwaithai /khokhonthai /khorakhangthai /ngonguthai ' +
          '/chochanthai /chochingthai /chochangthai /sosothai ' +
          '/chochoethai /yoyingthai /dochadathai /topatakthai ' +
          '/thothanthai /thonangmonthothai /thophuthaothai ' +
          '/nonenthai /dodekthai /totaothai /thothungthai ' +
          '/thothahanthai /thothongthai /nonuthai /bobaimaithai ' +
          '/poplathai /phophungthai /fofathai /phophanthai ' +
          '/fofanthai /phosamphaothai /momathai /yoyakthai ' +
          '/roruathai /ruthai /lolingthai /luthai /wowaenthai ' +
          '/sosalathai /sorusithai /sosuathai /hohipthai ' +
          '/lochulathai /oangthai /honokhukthai /paiyannoithai ' +
          '/saraathai /maihanakatthai /saraaathai /saraamthai ' +
          '/saraithai /saraiithai /sarauethai /saraueethai ' +
          '/sarauthai /sarauuthai /phinthuthai /bahtthai ' +
          '/saraethai /saraaethai /saraothai /saraaimaimuanthai ' +
          '/saraaimaimalaithai /lakkhangyaothai /maiyamokthai ' +
          '/maitaikhuthai /maiekthai /maithothai /maitrithai ' +
          '/maichattawathai /thanthakhatthai /nikhahitthai ' +
          '/yamakkanthai /fongmanthai /zerothai /onethai /twothai ' +
          '/threethai /fourthai /fivethai /sixthai /seventhai ' +
          '/eightthai /ninethai /angkhankhuthai /khomutthai ]';

      if CodePage = 1250 then
        Differences := '[128 /Euro /space /quotesinglbase /space ' +
          '/quotedblbase /ellipsis /dagger /daggerdbl /space /perthousand ' +
          '/Scaron /guilsinglleft /Sacute /Tcaron /Zcaron /Zacute /space ' +
          '/quoteleft /quoteright /quotedblleft /quotedblright /bullet ' +
          '/endash /emdash /space /trademark /scaron /guilsinglright ' +
          '/sacute /tcaron /zcaron /zacute /space /breve /breve /Lslash ' +
          '/currency /Aogonek /bar /section /dieresis /copyright /Scedilla ' +
          '/guillemotleft /logicalnot /hyphen /registered /Zdot /degree ' +
          '/plusminus /ogonek /lslash /acute /mu /paragraph /dotaccent ' +
          '/cedilla /aogonek /scedilla /guillemotright /Lcaron /hungarumlaut ' +
          '/lcaron /zdot /Racute /Aacute /Acircumflex /Abreve /Adieresis ' +
          '/Lacute /Cacute /Ccedilla /Ccaron /Eacute /Eogonek /Edieresis ' +
          '/Ecaron /Iacute /Icircumflex /Dcaron /Dcroat /Nacute /Ncaron ' +
          '/Oacute /Ocircumflex /Ohungarumlaut /Odieresis /multiply /Rcaron ' +
          '/Uring /Uacute /Uhungarumlaut /Udieresis /Yacute /Tcommaaccent ' +
          '/germandbls /racute /aacute /acircumflex /abreve /adieresis ' +
          '/lacute /cacute /ccedilla /ccaron /eacute /eogonek /edieresis ' +
          '/ecaron /iacute /icircumflex /dcaron /dcroat /nacute /ncaron ' +
          '/oacute /ocircumflex /ohungarumlaut /odieresis /divide /rcaron ' +
          '/uring /uacute /uhungarumlaut /udieresis /yacute /tcommaaccent ' +
          '/dotaccent]';

      if CodePage = 1251 then
        Differences := '[ 128 /afii10051 /afii10052 131 /afii10100 136 /Euro ' +
          '138 /afii10058 140 /afii10059 /afii10061 /afii10060 /afii10145 ' +
          '/afii10099 149 /bullet 153 /trademark /afii10106 ' +
          '156 /afii10107 /afii10109 /afii10108 /afii10193 /space /afii10062 ' +
          '/afii10110 /afii10057 165 /afii10050 168 /afii10023 ' +
          '170 /afii10053 175 /afii10056 178 /afii10055 /afii10103 ' +
          '/afii10098 184 /afii10071 /afii61352 /afii10101 188 /afii10105 ' +
          '/afii10054 /afii10102 /afii10104 /afii10017 /afii10018 /afii10019 ' +
          '/afii10020 /afii10021 /afii10022 /afii10024 /afii10025 /afii10026 ' +
          '/afii10027 /afii10028 /afii10029 /afii10030 /afii10031 /afii10032 ' +
          '/afii10033 /afii10034 /afii10035 /afii10036 /afii10037 /afii10038 ' +
          '/afii10039 /afii10040 /afii10041 /afii10042 /afii10043 /afii10044 ' +
          '/afii10045 /afii10046 /afii10047 /afii10048 /afii10049 /afii10065 ' +
          '/afii10066 /afii10067 /afii10068 /afii10069 /afii10070 /afii10072 ' +
          '/afii10073 /afii10074 /afii10075 /afii10076 /afii10077 /afii10078 ' +
          '/afii10079 /afii10080 /afii10081 /afii10082 /afii10083 /afii10084 ' +
          '/afii10085 /afii10086 /afii10087 /afii10088 /afii10089 /afii10090 ' +
          '/afii10091 /afii10092 /afii10093 /afii10094 /afii10095 /afii10096 ' +
          '/afii10097 ]';

      if CodePage = 1252 then
        Differences := '[ 128 /Euro 142 /Zcaron 149 /bullet 153 /trademark ' +
          '158 /zcaron 160 /space ]';

      if CodePage = 1253 then
        Differences := '[ 128 /Euro 149 /bullet 153 /trademark 160 /space ' +
          '/dieresistonos /Alphatonos 175 /afii00208 180 /tonos ' +
          '184 /Epsilontonos /Etatonos /Iotatonos 188 /Omicrontonos ' +
          '190 /Upsilontonos /Omegatonos /iotadieresistonos /Alpha /Beta ' +
          '/Gamma /Delta /Epsilon /Zeta /Eta /Theta /Iota /Kappa /Lambda /Mu ' +
          '/Nu /Xi /Omicron /Pi /Rho 211 /Sigma /Tau /Upsilon /Phi /Chi /Psi ' +
          '/Omega /Iotadieresis /Upsilondieresis /alphatonos /epsilontonos ' +
          '/etatonos /iotatonos /upsilondieresistonos /alpha /beta /gamma ' +
          '/delta /epsilon /zeta /eta /theta /iota /kappa /lambda /mu /nu ' +
          '/xi /omicron /pi /rho /sigma1 /sigma /tau /upsilon /phi /chi /psi ' +
          '/omega /iotadieresis /upsilondieresis /omicrontonos /upsilontonos ' +
          '/omegatonos ]';

      if CodePage = 1254 then
        Differences := '[ 128 /Euro 149 /bullet 153 /trademark 160 /space ' +
          '208 /Gbreve 221 /Idotaccent /Scedilla 240 /gbreve 253 /dotlessi ' +
          '/scedilla ]';

      if CodePage = 1255 then
        Differences := '[ 128 /Euro 149 /bullet 153 /trademark 160 /space ' +
          '164 /afii57636 170 /multiply 173 /sfthyphen 183 /middot ' +
          '186 /divide 192 /afii57799 /afii57801 /afii57800 /afii57802 ' +
          '/afii57793 /afii57794 /afii57795 /afii57798 /afii57797 /afii57806 ' +
          '203 /afii57796 /afii57807 /afii57839 /afii57645 /afii57841 ' +
          '/afii57842 /afii57804 /afii57803 /afii57658 /afii57716 /afii57717 ' +
          '/afii57718 /gereshhebrew /gershayimhebrew 224 /afii57664 ' +
          '/afii57665 /afii57666 /afii57667 /afii57668 /afii57669 /afii57670 ' +
          '/afii57671 /afii57672 /afii57673 /afii57674 /afii57675 /afii57676 ' +
          '/afii57677 /afii57678 /afii57679 /afii57680 /afii57681 /afii57682 ' +
          '/afii57683 /afii57684 /afii57685 /afii57686 /afii57687 /afii57688 ' +
          '/afii57689 /afii57690 253 /afii299 /afii300 ]';

      if CodePage = 1256 then
        Differences := '[ 128 /Euro /afii57506 /quotesinglbase /florin /quotedblbase ' +
          '/ellipsis /dagger /daggerdbl /circumflex /perthousand /afii57511 /guilsinglleft' +
          '/OE /afii57507 /afii57508 /afii57512 /afii57509 /quoteleft /quoteright' +
          '/quotedblleft /quotedblright /bullet /endash /emdash /??? /trademark' +
          '/afii57513 /guilsinglright /oe /zerowidthnonjoiner /afii301 /afii57514 /nbspace' +
          '/commaarabic /cent /sterling /currency /yen /brokenbar /section /dieresis' +
          '/copyright /??? /guillemotleft /logicalnot /sfthyphen /registered /macron' +
          '/degree /plusminus /twosuperior /threesuperior /acute /mu /paragraph /middot' +
          '/cedilla /onesuperior /semicolonarabic /guillemotright /onequarter /onehalf' +
          '/threequarters /questionarabic /haaltonearabic /afii57409 /afii57410' +
          '/afii57411 /afii57412 /afii57413 /afii57414 /afii57415 /afii57416 /afii57417' +
          '/afii57418 /afii57419 /afii57420 /afii57421 /afii57422 /afii57423' +
          '/afii57424 /afii57425 /afii57426 /afii57427 /afii57428 /afii57429 /afii57430' +
          '/multiply /afii57431 /afii57432 /afii57433 /afii57434 /afii57440 /afii57441' +
          '/afii57442 /afii57443 /agrave /afii57444 /acircumflex /afii57445 /afii57446' +
          '/afii57447 /afii57448 /ccedilla /egrave /eacute /ecircumflex /edieresis' +
          '/afii57449 /afii57450 /icircumflex /idieresis /afii57451 /afii57452' +
          '/afii57453 /afii57454 /ocircumflex /afii57455 /afii57456 /divide /afii57457' +
          '/ugrave /afii57458 /ucircumflex /udieresis /afii299 /afii300 /afii57519';

      if CodePage = 1257 then
        Differences := '[ 128 /Euro 141 /dieresis /caron /cedilla ' +
          '149 /bullet 153 /trademark 157 /macron /ogonek 160 /space ' +
          '168 /Oslash 170 /Rcommaaccent 175 /AE 184 /oslash ' +
          '186 /rcommaaccent 191 /ae /Aogonek /Iogonek /Amacron /Cacute ' +
          '198 /Eogonek /Emacron /Ccaron 202 /Zacute /Edotaccent ' +
          '/Gcommaaccent /Kcommaaccent /Imacron /Lcommaaccent /Scaron ' +
          '/Nacute /Ncommaaccent 212 /Omacron 216 /Uogonek /Lslash /Sacute ' +
          '/Umacron 221 /Zdotaccent /Zcaron 224 /aogonek /iogonek /amacron ' +
          '/cacute 230 /eogonek /emacron /ccaron 234 /zacute /edotaccent ' +
          '/gcommaaccent /kcommaaccent /imacron /lcommaaccent /scaron ' +
          '/nacute /ncommaaccent 244 /omacron 248 /uogonek /lslash /sacute ' +
          '/umacron 253 /zdotaccent /zcaron /dotaccent ]';

      if CodePage = 1258 then
        Differences := '[ 128 /Euro 149 /bullet 153 /trademark 160 /space ' +
          '195 /Abreve 204 /gravecomb 208 /Dcroat 210 /hookabovecomb ' +
          '213 /Ohorn 221 /Uhorn /tildecomb 227 /abreve 236 /acutecomb ' +
          '240 /dcroat 242 /dotbelowcomb 245 /ohorn 253 /uhorn /dong ]';

      if (Flags and 4 <> 0) then  // A Symbolic font
      begin
        SetLength(Target, 1);
        for I := 0 to 255 do
        begin
          Target[0] := I;
          FEncodingCMap.AddMapping(2, I, Target);
        end;
      end else
      if DefaultCodePage then
      begin
        Dict.Add('Encoding',  FStructure.NewName('WinAnsiEncoding'));
        SetupEncodingCMap('WinAnsiEncoding', nil);
      end else
      begin
        EncodingDict := FStructure.NewDictionary;
        EncodingDict.Add('Type', FStructure.NewName('Encoding'));
        EncodingDict.Add('BaseEncoding', FStructure.NewName('WinAnsiEncoding'));
        if Differences <> '' then
        begin
          DifferencesArray := FStructure.Decode(Differences);
          EncodingDict.Add('Differences', DifferencesArray);
          if DifferencesArray is TPDFArray then
          begin
            SetupEncodingCMap('WinAnsiEncoding', TPDFArray(DifferencesArray));
            ToUnicodeData := MakeCMap('WinAnsiEncoding', TPDFArray(DifferencesArray));
            ToUnicodeStream := FStructure.NewStream('');
            ToUnicodeStream.SetTo(ToUnicodeData, False);

            if Assigned(FStructure.OnNewIndObj) then
              FStructure.OnNewIndObj(Self, ObjNum, GenNum, ToUnicodeStream);
            ToUnicodeRef := FStructure.NewIndirectRef(ObjNum, GenNum);

            Dict.Add('ToUnicode', ToUnicodeRef);
          end;
        end;
        Dict.Add('Encoding', EncodingDict);
      end;
      with Metrics.otmTextMetrics do
      begin
        FirstChar := Ord(tmFirstChar);
        LastChar := Ord(tmLastChar);
        Dict.Add('FirstChar', FStructure.NewNumeric(FirstChar));
        Dict.Add('LastChar', FStructure.NewNumeric(LastChar));
        SetLength(Widths, LastChar - FirstChar + 1);

        for C := AnsiChar(FirstChar) to AnsiChar(LastChar) do
        begin
          CodePageWidthS := C;
          SetLength(CodePageWidthWS, 1);
          if (CodePage < 0) then
          begin
            MultiByteToWideChar(1252, 0, PAnsiChar(CodePageWidthS), -1,
              PWideChar(CodePageWidthWS), 1);
          end else
          begin
            MultiByteToWideChar(CodePage, 0, PAnsiChar(CodePageWidthS), -1,
              PWideChar(CodePageWidthWS), 1);
          end;
{$IFDEF QPL_OS_WINDOWS}
          GetCharWidthW(BM.Canvas.Handle, Word(CodePageWidthWS[1]),
            Word(CodePageWidthWS[1]), Widths[Ord(C) - FirstChar]);
{$ENDIF}
          if (CodePage = 0) then
          begin
            FWidthLookup.AddWidth(Ord(C), Widths[Ord(C) - FirstChar]);
          end else
          begin
            FWidthLookup.AddWidth(Word(CodePageWidthWS[1]), Widths[Ord(C) - FirstChar]);
          end;
        end;
      end;
      Dict.Add('Widths', FStructure.NewIntArray(Widths));
      Dict.Add('FontDescriptor', FontDescriptor);

      if Assigned(FStructure.OnNewIndObj) then
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, Dict);
      FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    end;
  finally
    BM.Free;
  end;
end;

function TPDFFont.NewTrueTypeFontFromStream(Source: TStream): Boolean;
var
  TTP: TPDFTrueTypeParser;
var
  Dict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  FontDataStr: AnsiString;
  CIDIndex: Integer;
  DescendantFont: TPDFDictionary;
  FontDescriptor: TPDFDictionary;
  Metrics: TOutlineTextmetricW;
  Flags: Integer;
  FontStream: TPDFStream;
  FontFile: TPDFIndRef;
  WidthsArrayStr: AnsiString;
  Target: TQPLByteArray;
  TTCMapIndex: Integer;
  EncodingRecord: TPDFTTEncodingRecord;
  MappingIndex: Integer;
  ToUnicode: AnsiString;
  ToUnicodeStream: TPDFStream;
  CIDRanges: AnsiString;
  CIDList: TStringList;
  MapA, MapB, MapC, MapD, MapF: Integer;
begin
  TTP := TPDFTrueTypeParser.Create;
  try
    Source.Seek(0, soFromBeginning);
    TTP.LoadFromStream(Source);
    Result := True;

    TTP.ReadNameTable;
    FFontName := AnsiString(TTP.FontName);

    CIDRanges := '';
    CIDList := TStringList.Create;
    try
      if (Assigned(FEncodingCMap)) then
      begin
        FEncodingCMap.Free;
        FEncodingCMap := nil;
      end;

      FEncodingCMap := TDebenuPDFLibraryCMap.Create;
      FEncodingCMap.AddCodespaceRange(0, TTP.GlyphCount - 1, 2);
      SetLength(Target, 2);

      // Get the Unicode to CID mapping
      TTCMapIndex := TTP.Findcmap(0, 3);
      if (TTCMapIndex >= 0) then
      begin
        EncodingRecord := TTP.Getcmap(TTCMapIndex);
        for MappingIndex := 0 to Length(EncodingRecord.Codes) - 1 do
        begin
          Target[0] := (EncodingRecord.GlyfID[MappingIndex] and $FF00) shr 8;
          Target[1] := EncodingRecord.GlyfID[MappingIndex] and $FF;
          FEncodingCMap.AddMapping(2, EncodingRecord.Codes[MappingIndex], Target);

          CIDList.Add('<' + IntToHex(EncodingRecord.GlyfID[MappingIndex], 4) + '> ' +
            '<' + IntToHex(EncodingRecord.GlyfID[MappingIndex], 4) + '> ' +
            '<' + IntToHex(EncodingRecord.Codes[MappingIndex], 4) + '>');
        end;
      end;

      // Sort the list
      CIDList.Sort;

      // Collapse consecutive items into a single
      MappingIndex := 0;
      while (MappingIndex < (CIDList.Count - 1)) do
      begin
        MapA := StrToInt('$' + Copy(CIDList[MappingIndex], 2, 4));
        MapB := StrToInt('$' + Copy(CIDList[MappingIndex], 9, 4));
        MapC := StrToInt('$' + Copy(CIDList[MappingIndex], 16, 4));
        MapD := StrToInt('$' + Copy(CIDList[MappingIndex + 1], 2, 4));
        MapF := StrToInt('$' + Copy(CIDList[MappingIndex + 1], 16, 4));

        if ((MapD = MapB + 1) and (MapF = MapC + MapB - MapA + 1) and
          ((MapB and $FF00) = (MapD and $FF00))) then
        begin
          CIDList[MappingIndex] := Copy(CIDList[MappingIndex], 1, 8) +
            Copy(CIDList[MappingIndex + 1], 2, 4) +
            Copy(CIDList[MappingIndex], 13, MaxInt);
          CIDList.Delete(MappingIndex + 1);
        end else
        begin
          Inc(MappingIndex, 1);
        end;
      end;

      while (CIDList.Count >= 100) do
      begin
        CIDRanges := CIDRanges + '100 beginbfrange'#10;
        for MappingIndex := 0 to 99 do
        begin
          CIDRanges := CIDRanges + AnsiString(CIDList[0]) + #10;
          CIDList.Delete(0);
        end;
        CIDRanges := CIDRanges + 'endbfrange'#10;
      end;
      if (CIDList.Count > 0) then
      begin
        CIDRanges := CIDRanges + QPLIntToStr(CIDList.Count) + ' beginbfrange'#10;
        for MappingIndex := 0 to CIDList.Count - 1 do
        begin
          CIDRanges := CIDRanges + AnsiString(CIDList[MappingIndex]) + #10;
        end;
        CIDRanges := CIDRanges + 'endbfrange'#10;
      end;
    finally
      CIDList.Free;
    end;

    // Get the font widths
    FirstChar := 0;
    LastChar := TTP.GlyphCount - 1;
    SetLength(Widths, TTP.GlyphCount + 1);
    WidthsArrayStr := '0 [';
    for CIDIndex := 0 to TTP.GlyphCount - 1 do
    begin
      WidthsArrayStr := WidthsArrayStr + ' ' + QPLIntToStr(TTP.GetWidth(CIDIndex));
      Widths[CIDIndex] := TTP.GetWidth(CIDIndex);
    end;
    WidthsArrayStr := WidthsArrayStr + ' ]';

    // Get the font metrics
    TTP.ReadMetrics(Metrics);

    Source.Seek(0, soFromBeginning);
    SetLength(FontDataStr, Source.Size);
    Source.Read(FontDataStr[1], Length(FontDataStr));

    Dict := FStructure.NewDictionary;
    FFontDict := Dict;
    Dict.Add('Type', FStructure.NewName('Font'));
    Dict.Add('Subtype', FStructure.NewName('Type0'));
    Dict.Add('Encoding', FStructure.NewName('Identity-H'));
    Dict.Add('BaseFont', FStructure.NewName(FFontName));

    ToUnicode :=
      '%!PS-Adobe-3.0 Resource-CMap'#10 +
      '%%DocumentNeededResources: ProcSet (CIDInit)'#10 +
      '%%IncludeResource: ProcSet (CIDInit)'#10 +
      '%%BeginResource: CMap (Adobe-Identity-000)'#10 +
      '%%Title: (Adobe-Identity-000 Adobe Identity 0)'#10 +
      '%%EndComments'#10 +
      '/CIDInit /ProcSet findresource begin'#10 +
      '12 dict begin'#10 +
      'begincmap'#10 +
      '/CIDSystemInfo 3 dict dup begin'#10 +
      '/Registry (Adobe) def'#10 +
      '/Ordering (Identity) def'#10 +
      '/Supplement 0 def'#10 +
      'end def'#10 +
      '/CMapName /Adobe-Identity-000 def'#10 +
      '/CMapVersion 1.000 def'#10 +
      '/CMapType 2 def'#10 +
      '/WMode 0 def'#10 +
      '1 begincodespacerange'#10 +
      '<0000> <FFFF>'#10 +
      'endcodespacerange'#10 +
      CIDRanges +
      #10'endcmap'#10 +
      'CMapName currentdict /CMap defineresource pop'#10 +
      'end'#10 +
      'end';

    ToUnicodeStream := FStructure.NewStream('');
    ToUnicodeStream.SetTo(ToUnicode, False);
    with ToUnicodeStream.Dictionary do
    begin
      Add('Type', FStructure.Decode('/CMap'));
      Add('CMapName', FStructure.Decode('/Adobe-Identity-000'));
      Add('CIDSystemInfo', FStructure.Decode('<< /Registry (Adobe) /Ordering (Identity) /Supplement 0 >>'));
      Add('WMode', FStructure.NewNumeric(0));
    end;
    if Assigned(FStructure.OnNewIndObj) then
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, ToUnicodeStream);
    FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    Dict.Add('ToUnicode', FIndRef);

    DescendantFont := FStructure.NewDictionary;
    DescendantFont.Add('Type', FStructure.NewName('Font'));
    DescendantFont.Add('Subtype', FStructure.NewName('CIDFontType0'));
    DescendantFont.Add('BaseFont', FStructure.NewName(FFontName));
    DescendantFont.Add('CIDSystemInfo', FStructure.Decode('<< /Registry (Adobe) /Ordering (Identity) /Supplement 0 >>'));
    DescendantFont.Add('DW', FStructure.NewNumeric(1000));
    DescendantFont.Add('W', FStructure.Decode('[ ' + WidthsArrayStr + ']'));

    FontDescriptor := FStructure.NewDictionary;
    FontDescriptor.Add('Type', FStructure.NewName('FontDescriptor'));
    FontDescriptor.Add('FontName', FStructure.NewName(FFontName));
    with Metrics do
    begin
      FontDescriptor.Add('FontBBox', FStructure.NewIntArray([otmrcFontBox.Left,
        otmrcFontBox.Bottom, otmrcFontBox.Right, otmrcFontBox.Top]));
{$IFNDEF QPL_CPP}
      FBound := otmrcFontBox;
{$ENDIF}
      Flags := 0;
      if otmTextMetrics.tmCharSet = SYMBOL_CHARSET then
        Flags := Flags + 4 else Flags := Flags + 32;
      if (otmTextMetrics.tmPitchAndFamily and
        TMPF_FIXED_PITCH) = TMPF_FIXED_PITCH then
          Flags := Flags + 1;
      FontDescriptor.Add('Flags', FStructure.NewNumeric(Flags));
      FontDescriptor.Add('MissingWidth', FStructure.NewNumeric(750));
      FontDescriptor.Add('StemV', FStructure.NewNumeric(0));
      FontDescriptor.Add('ItalicAngle', FStructure.NewNumeric(otmItalicAngle));
      FontDescriptor.Add('CapHeight', FStructure.NewNumeric(Metrics.otmTextMetrics.tmAscent));

      FAscent := Metrics.otmAscent;
      FDescent := -Abs(Metrics.otmDescent);

      FAscentTM := Metrics.otmTextMetrics.tmAscent;
      FDescentTM := -Abs(Metrics.otmTextMetrics.tmDescent);
      FInternalLeading := otmTextMetrics.tmInternalLeading;
      FExternalLeading := otmTextMetrics.tmExternalLeading;
      FHeight := otmTextMetrics.tmHeight;
      FAveCharWidth := otmTextMetrics.tmAveCharWidth;

      FontDescriptor.Add('Ascent', FStructure.NewNumeric(FAscent));
      FontDescriptor.Add('Descent', FStructure.NewNumeric(FDescent));
      FontDescriptor.Add('MaxWidth', FStructure.NewNumeric(otmTextMetrics.tmMaxCharWidth));
      FontDescriptor.Add('AvgWidth', FStructure.NewNumeric(otmTextMetrics.tmAveCharWidth));
    end;

    FontStream := FStructure.NewStream(DeflateStr(FontDataStr));
    FontStream.Dictionary.Add('Filter', FStructure.NewCommonName('FlateDecode'));

    if Assigned(FStructure.OnNewIndObj) then
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, FontStream);
    FontFile := FStructure.NewIndirectRef(ObjNum, GenNum);
    FontStream.Dictionary.Add('Subtype', FStructure.NewName('CIDFontType0C'));
    FontDescriptor.Add('FontFile2', FontFile);

    if Assigned(FStructure.OnNewIndObj) then
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, FontDescriptor);
    FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    DescendantFont.Add('FontDescriptor', FIndRef);

    if Assigned(FStructure.OnNewIndObj) then
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, DescendantFont);
    FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    Dict.Add('DescendantFonts', FStructure.NewArray([FIndRef]));
    if Assigned(FStructure.OnNewIndObj) then
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, Dict);
    FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
  finally
    TTP.Free;
  end;
end;

type
  TPFMInfo = record
    Bounds: array[1..4] of Integer;
    ItalicAngle: Integer;
    CapHeight: Integer;
    Height: Integer;
    Ascent: Integer;
    Descent: Integer;
    InternalLeading: Integer;
    ExternalLeading: Integer;
    MaxWidth: Integer;
    AvgWidth: Integer;
    FontName: AnsiString;
    FirstChar: Integer;
    LastChar: Integer;
    Widths: array of Integer;
    IsItalic: Boolean;
    IsSymbol: Boolean;
    IsSerif: Boolean;
    IsScript: Boolean;
    IsFixed: Boolean;
  end;

function ReadPFM(const FileName: WideString): TPFMInfo;
var
  FS: TQuickPDFWideFileStream;
  B: Byte;
  W: Word;
  DW: Cardinal;
  SI: Smallint;
  FacePos: Cardinal;
  MetricsPos: Cardinal;
  ExtentPos: Cardinal;
begin
  FillChar(Result, 0, SizeOf(Result));
  FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
  try
    FS.Seek(0, soFromBeginning);
    FS.Read(W, SizeOf(Word));
    if (W = $100) or (W = $200) then
    begin
      FS.Read(DW, SizeOf(Cardinal)); // Size
      if DW = Word(FS.Size) then
      begin
        FS.Seek(60, soFromCurrent);  // Copyright
        FS.Read(W, SizeOf(Word));    // Type
        if W = $81 then
        begin
          FS.Read(W, SizeOf(Word));  // Points
          Result.Height := W;
          FS.Read(W, SizeOf(Word));  // VertRes
          FS.Read(W, SizeOf(Word));  // HorizRes
          FS.Read(W, SizeOf(Word));  // Ascent
          FS.Read(W, SizeOf(Word));  // InternalLeading
          Result.InternalLeading := W;
          FS.Read(W, SizeOf(Word));  // ExternalLeading
          Result.ExternalLeading := W;
          FS.Read(B, SizeOf(Byte));  // Italic
          Result.IsItalic := B = 1;
          FS.Read(B, SizeOf(Byte));  // Underline
          FS.Read(B, SizeOf(Byte));  // Strike-out
          FS.Read(W, SizeOf(Word));  // Weight
          FS.Read(B, SizeOf(Byte));  // Charset
          Result.IsSymbol := B = 2;
          FS.Read(W, SizeOf(Word));  // PixWidth
          FS.Read(W, SizeOf(Word));  // PixHeight
          FS.Read(B, SizeOf(Byte));  // PitchAndFamily
          Result.IsSerif := B and $10 = $10;
          if B and $20 = $20 then Result.IsSerif := False;
          Result.IsFixed := B and $30 = $30;
          Result.IsScript := B and $40 = $40;
          FS.Read(W, SizeOf(Word));  // AvgWidth
          Result.AvgWidth := W;
          FS.Read(W, SizeOf(Word));  // MaxWidth
          Result.MaxWidth := W;
          FS.Read(B, SizeOf(Byte));  // FirstChar
          Result.FirstChar := B;
          FS.Read(B, SizeOf(Byte));  // LastChar
          Result.LastChar := B;
          FS.Seek(8, soFromCurrent);
          FS.Read(DW, SizeOf(Cardinal));
          FacePos := DW;
          FS.Seek(8, soFromCurrent);
          FS.Read(W, SizeOf(Word));
          FS.Read(DW, SizeOf(Cardinal));
          MetricsPos := DW;
          FS.Read(DW, SizeOf(Cardinal));
          ExtentPos := DW;

          FS.Seek(FacePos, soBeginning);
          Result.FontName := '';
          repeat
            FS.Read(B, SizeOf(Byte));
            if B <> 0 then
              Result.FontName := Result.FontName + AnsiChar(B);
          until B = 0;

          Result.Height := 0;
          Result.CapHeight := 0;
          Result.Ascent := 0;
          Result.Descent := 0;
          Result.ItalicAngle := 0;

          FS.Seek(MetricsPos, soBeginning);
          FS.Read(W, SizeOf(Word));

          // W should be $34, but isn't always...
          {if W = $34 then}
          begin
            FS.Seek(12, soFromCurrent);
            FS.Read(SI, SizeOf(Smallint));
            Result.CapHeight := SI;
            FS.Read(SI, SizeOf(Smallint));
            FS.Read(SI, SizeOf(Smallint));
            Result.Ascent := SI;
            FS.Read(SI, SizeOf(Smallint));
            if SI > 0 then SI := -SI;
            Result.Descent := SI;
            FS.Read(SI, SizeOf(Smallint));
            Result.ItalicAngle := SI div 10;
          end;

          { If any of these values are out of range, set all the
            values to zero to avoid errors... }
          if (Result.CapHeight < 0) or (Result.CapHeight > 2000) or
            (Result.Ascent < 0) or (Result.Ascent > 2000) or
            (Result.Descent < -500) then
          begin
            Result.CapHeight := 0;
            Result.Ascent := 0;
            Result.Descent := 0;
            Result.ItalicAngle := 0;
          end;

          SetLength(Result.Widths, Result.LastChar - Result.FirstChar + 1);
          FS.Seek(ExtentPos, soBeginning);
          for B := 0 to Result.LastChar - Result.FirstChar do
          begin
            FS.Read(W, SizeOf(Word));
            Result.Widths[B] := W;
          end;
        end;
      end;
    end;
  finally
    FS.Free;
  end;
end;

function DecodePFB(const FileName: WideString; var L1, L2, L3, B1, B2, B3, B4: Integer; var FontName: AnsiString): AnsiString;
var
  FS: TQuickPDFWideFileStream;
  B: Byte;
  Error: Boolean;
  T: Byte;
  S: AnsiString;
  SN: AnsiString;
  DW: Cardinal;

  function PopNumber: Integer;
  begin
    Result := 0;
    repeat
      Delete(S, 1, 1);
    until (((S[1] >= '0') and (S[1] <= '9')) or (S[1] = '-')) or (Length(S) = 0);
    if Length(S) > 0 then
    begin
      SN := '';
      repeat
        SN := SN + S[1];
        Delete(S, 1, 1);
      until (S[1] < '0') or (S[1] > '9');
      Result := QPLStrToIntDef(SN, 0);
    end;
  end;

  function PopString: AnsiString;
  begin
    Result := '';
    repeat
      Delete(S, 1, 1);
    until (S[1] <> ' ') or (Length(S) = 0);
    if Length(S) > 0 then
    begin
      SN := '';
      repeat
        SN := SN + S[1];
        Delete(S, 1, 1);
      until (S[1] = ' ');
      Result := SN;
    end;
  end;

begin
  Result := '';
  FontName := '';  
  L1 := 0;
  L2 := 0;
  L3 := 0;
  B1 := 0;
  B2 := 0;
  B3 := 0;
  B4 := 0;
  if QPLFileExists(FileName) then
  begin
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    try
      Error := False;
      repeat
        FS.Read(B, SizeOf(Byte));
        if B = 128 then
        begin
          FS.Read(T, SizeOf(Byte));
          if (T = 1) or (T = 2) then
          begin
            FS.Read(DW, SizeOf(Cardinal));
            SetLength(S, DW);
            FS.Read(S[1], Length(S));
            if (T = 1) and (Result = '') then L1 := DW;
            if (T = 2) then L2 := DW;
            if (T = 1) and (Result <> '') then L3 := DW;
            Result := Result + S;
          end;
        end else
          Error := True;
      until Error or (T = 3);
    finally
      FS.Free;
    end;
  end;
  if QPLPos('/FontBBox', Result) > 0 then
  begin
    S := QPLCopy(Result, QPLPos('/FontBBox', Result) + 9, MaxInt);
    B1 := PopNumber;
    B2 := PopNumber;
    B3 := PopNumber;
    B4 := PopNumber;
  end;
  if QPLPos('/FontName', Result) > 0 then
  begin
    S := QPLCopy(Result, QPLPos('/FontName', Result) + 9, MaxInt);
    FontName := PopString;
    if QPLCopy(FontName, 1, 1) = '/' then
      Delete(FontName, 1, 1);
  end;
end;

function TPDFFont.NewType1Font(const FileName: WideString): Boolean;
var
  FontStream: TPDFStream;
  ObjNum, GenNum: Integer;
  S: AnsiString;
  Dict: TPDFDictionary;
  FontFile: TPDFIndRef;
  FontDescriptor: TPDFIndRef;

  X: Integer;
  R1, R2, R3, R4: Integer;
  PFMInfo: TPFMInfo;
  FontDataFile: WideString;
  L1, L2, L3: Integer;
  PFBFontName: AnsiString;
  Flags: Integer;
  T1: TPDFType1Decoder;
  T1CSN: TPDFCharsetNames;
  //StdCSN: TPDFCharsetNames;
  //Target: TQPLByteArray;
begin
  FontDataFile := QPLChangeFileExt(FileName, '.pfb');
  if QPLFileExists(FileName) and QPLFileExists(FontDataFile) then
  begin
    Result := True;
    PFMInfo := ReadPFM(FileName);
    S := DecodePFB(FontDataFile, L1, L2, L3, R1, R2, R3, R4, PFBFontName);

    if PFBFontName <> '' then
      PFMInfo.FontName := PFBFontName;

    FirstChar := PFMInfo.FirstChar;
    LastChar := PFMInfo.LastChar;
    FFontName := PFMInfo.FontName;

    if FCompress then
    begin
      FontStream := FStructure.NewStream(DeflateStr(S));
      FontStream.Dictionary.Add('Filter', FStructure.NewCommonName('FlateDecode'));
    end else
      FontStream := FStructure.NewStream(S);

    if Assigned(FStructure.OnNewIndObj) then
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, FontStream);
    FontFile := FStructure.NewIndirectRef(ObjNum, GenNum);
    FontStream.Dictionary.Add('Length1', FStructure.NewNumeric(L1));
    FontStream.Dictionary.Add('Length2', FStructure.NewNumeric(L2));
    FontStream.Dictionary.Add('Length3', FStructure.NewNumeric(L3));

    T1 := TPDFType1Decoder.Create;
    try
      T1.LoadPFBFromPDFStream(FontStream);
      T1.DecodeFontDict;
      T1.DecodeEncryptedPortion;
      T1CSN := T1.GetEncoding;
    finally
      T1.Free;
    end;

    if (Assigned(FEncodingCMap)) then
    begin
      FEncodingCMap.Free;
      FEncodingCMap := nil;
    end;

    SetupEncodingCMap('WinAnsiEncoding', nil);
    {FEncodingCMap := TDebenuPDFLibraryCMap.Create;
    FEncodingCMap.AddCodespaceRange(FirstChar, LastChar, 1);
    SetLength(Target, 1);
    for X := FirstChar to LastChar do
    begin
      Target[0] := X;
      FEncodingCMap.AddMapping(2, GetGlyphUnicode(T1CSN[X]), Target);
    end;

    GetCharsetNames(peStandard, StdCSN);
    X := 0;
    while (X < 256) and (not PFMInfo.IsSymbol) do
    begin
      if (T1CSN[X] <> '.notdef') and (T1CSN[X] <> StdCSN[X]) then
        PFMInfo.IsSymbol := True
      else
        Inc(X);
    end;}

    Dict := FStructure.NewDictionary;
    Dict.Add('Type', FStructure.NewName('FontDescriptor'));
    Dict.Add('FontName', FStructure.NewName(PFMInfo.FontName));

    Dict.Add('FontBBox', FStructure.NewIntArray([R1, R2, R3, R4]));
    Flags := 0;
    if PFMInfo.IsFixed then Flags := Flags + 1;
    if PFMInfo.IsSerif then Flags := Flags + 2;
    if PFMInfo.IsSymbol then Flags := Flags + 4;
    if PFMInfo.IsScript then Flags := Flags + 8;
    if not PFMInfo.IsSymbol then Flags := Flags + 32;
    if PFMInfo.IsItalic then Flags := Flags + 64;

    Dict.Add('Flags', FStructure.NewNumeric(Flags));
    Dict.Add('MissingWidth', FStructure.NewNumeric(750));
    Dict.Add('StemV', FStructure.NewNumeric(0));

    Dict.Add('ItalicAngle', FStructure.NewNumeric(PFMInfo.ItalicAngle));
    Dict.Add('CapHeight', FStructure.NewNumeric(PFMInfo.CapHeight));
    Dict.Add('Ascent', FStructure.NewNumeric(PFMInfo.Ascent));
    Dict.Add('Descent', FStructure.NewNumeric(PFMInfo.Descent));
    Dict.Add('MaxWidth', FStructure.NewNumeric(PFMInfo.MaxWidth));
    Dict.Add('AvgWidth', FStructure.NewNumeric(PFMInfo.AvgWidth));

    Dict.Add('FontFile', FontFile);

    if Assigned(FStructure.OnNewIndObj) then
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, Dict);
    FontDescriptor := FStructure.NewIndirectRef(ObjNum, GenNum);

    Dict := FStructure.NewDictionary;
    FFontDict := Dict;
    Dict.Add('Type', FStructure.NewName('Font'));
    Dict.Add('Subtype', FStructure.NewName('Type1'));
    Dict.Add('BaseFont', FStructure.NewName(PFMInfo.FontName));
    if not PFMInfo.IsSymbol then
      Dict.Add('Encoding',  FStructure.NewName('WinAnsiEncoding'));

    Dict.Add('FirstChar', FStructure.NewNumeric(FirstChar));
    Dict.Add('LastChar', FStructure.NewNumeric(LastChar));

    SetLength(Widths, Length(PFMInfo.Widths));
    for X := 0 to Length(Widths) - 1 do
      Widths[X] := PFMInfo.Widths[X];

    Dict.Add('Widths', FStructure.NewIntArray(Widths));
    Dict.Add('FontDescriptor', FontDescriptor);
    FFontType := ftType1;

    FAscent := PFMInfo.Ascent;
    FDescent := PFMInfo.Descent;
    FAveCharWidth := PFMInfo.AvgWidth;

    FHeight := PFMInfo.Height;
    FInternalLeading := PFMInfo.InternalLeading;
    FExternalLeading := PFMInfo.ExternalLeading;

    FBound.Left := R1;
    FBound.Top := R4;
    FBound.Right := R3;
    FBound.Bottom := R2;

    if Assigned(FStructure.OnNewIndObj) then
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, Dict);
    FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
  end else
    Result := False;
end;

procedure TPDFFont.PopulateFromIndRef(IndRef: TPDFIndRef);
var
  Obj: TPDFObject;
  X: Integer;
  C: Integer;
  DescDict: TPDFDictionary;
  BBox: TPDFArray;
  Subtype: AnsiString;
  HasDescriptor: Boolean;
  WX: Integer;
  WArray: TPDFArray;
  WFirst: Integer;
  WLast: Integer;
  W: Integer;
  WSubArray: TPDFArray;
  IsCID: Boolean;
  ToUnicode: AnsiString;
  EncodingDict: TPDFDictionary;
  BaseEncoding: AnsiString;
  CMapParser: TDebenuPDFLibraryCMapParser;
  CMapBuffer: TQPLBuffer;
  ParentFontDict: TPDFDictionary;
  MatchFontName: AnsiString;

  function GetCIDSystemInfo(CIDSystemInfoDict: TPDFDictionary): AnsiString;
  begin
    Result := '';
    Obj := CIDSystemInfoDict.FindValueByKeyName('Registry', True);
    if Obj is TPDFString then Result := TPDFString(Obj).AsString;
    Result := Result + '-';
    Obj := CIDSystemInfoDict.FindValueByKeyName('Ordering', True);
    if Obj is TPDFString then Result := Result + TPDFString(Obj).AsString;
    Result := Result + '-';
    Obj := CIDSystemInfoDict.FindValueByKeyName('Supplement', True);
    if Obj is TPDFNumeric then Result := Result +
      QPLIntToStr(TPDFNumeric(Obj).AsInteger);
  end;

begin
  ParentFontDict := nil;
  FFontType := ftUnknown;
  FIsEmbedded := False;
  FIsSubsetted := False;
  FIndRef := IndRef;
  CIDSystemInfo := '';
  FHasDescendantFont := False;

  Obj := IndRef.Obj;
  if Obj is TPDFDictionary then
  begin
    FFontDict := TPDFDictionary(Obj);

    Obj := FFontDict.FindValueByKeyName('Subtype', True);
    if Obj is TPDFName then Subtype := TPDFName(Obj).Name;

    //IsCID := Subtype = 'Type0';
    IsCID := (Subtype = 'Type0') or (Subtype = 'CIDFontType0') or (Subtype = 'CIDFontType2');
    if IsCID then
    begin
      Obj := FFontDict.FindValueByKeyName('CIDSystemInfo', True);
      if (Obj is TPDFDictionary) then
      begin
        CIDSystemInfo := GetCIDSystemInfo(TPDFDictionary(Obj));
      end;

      Obj := FFontDict.FindValueByKeyName('ToUnicode', True);
      if Obj is TPDFStream then
      begin
        ToUnicode := TPDFStream(Obj).GetDecodedStream;

        CMapParser := TDebenuPDFLibraryCMapParser.Create;
        try
          CMapBuffer := TQPLBuffer.Create;
          try
            CMapBuffer.SetAnsiStringSource(ToUnicode);
            if (Assigned(FEncodingCMap)) then
            begin
              FEncodingCMap.Free;
              FEncodingCMap := nil;
            end;
            FEncodingCMap := CMapParser.ParseCMap(CMapBuffer);
          finally
            CMapBuffer.Free;
          end;
        finally
          CMapParser.Free;
        end;
      end;
      Obj := FFontDict.FindValueByKeyName('DescendantFonts', True);
      if (Obj is TPDFArray) and (TPDFArray(Obj).Count > 0) then
      begin
        Obj := TPDFArray(Obj).Item[0];
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFDictionary then
        begin
          ParentFontDict := FFontDict;
          FHasDescendantFont := True;
          FFontDict := TPDFDictionary(Obj);
          Obj := FFontDict.FindValueByKeyName('Subtype', True);
          if Obj is TPDFName then Subtype := TPDFName(Obj).Name;
        end;
      end;
    end;

    Obj := FFontDict.FindValueByKeyName('Encoding', True);
    if ((not Assigned(Obj)) and (Assigned(ParentFontDict))) then
    begin
      Obj := ParentFontDict.FindValueByKeyName('Encoding', True);
    end;
    if (Obj is TPDFName) then
    begin
      if (TPDFName(Obj).Name = 'WinAnsiEncoding') then
      begin
        SetupEncodingCMap('WinAnsiEncoding', nil);
      end else
      if (TPDFName(Obj).Name = 'UniJIS-UCS2-H') then
      begin
        FEncodingCMap.SetIdentityMapping;
      end;
    end else
    if (Obj is TPDFDictionary) then
    begin
      EncodingDict := TPDFDictionary(Obj);
      Obj := EncodingDict.FindValueByKeyName('BaseEncoding', True);
      if (Obj is TPDFName) then
      begin
        BaseEncoding := TPDFName(Obj).Name;
      end else
      begin
        BaseEncoding := '';
      end;
      Obj := EncodingDict.FindValueByKeyName('Differences', True);
      if (Obj is TPDFArray) then
      begin
        SetupEncodingCMap(BaseEncoding, TPDFArray(Obj));
      end;
    end else
    begin
      SetupSimpleUnicodeCMap;
    end;

    Obj := FFontDict.FindValueByKeyName('BaseFont', True);
    if Obj is TPDFName then
    begin
      FFontName := TPDFName(Obj).Name;
      if (Length(FFontName) > 7) and (FFontName[7] = '+') then
        FIsSubsetted := True;
    end;
    Obj := FFontDict.FindValueByKeyName('FontBBox', True);
    if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 4) then
    begin
      BBox := TPDFArray(Obj);
      Obj := BBox.Item[0];
      if Obj is TPDFNumeric then FBound.Left := TPDFNumeric(Obj).AsInteger;
      Obj := BBox.Item[1];
      if Obj is TPDFNumeric then FBound.Bottom := TPDFNumeric(Obj).AsInteger;
      Obj := BBox.Item[2];
      if Obj is TPDFNumeric then FBound.Right := TPDFNumeric(Obj).AsInteger;
      Obj := BBox.Item[3];
      if Obj is TPDFNumeric then FBound.Top := TPDFNumeric(Obj).AsInteger;
    end;

    if (FFontName = 'HeiseiKakuGo-W5') then
    begin
      FFontType := ftCJK;
      FCIDWidths := InflateStr(HeiseiKakuGoW5UCWidths);
    end;

    Obj := FFontDict.FindValueByKeyName('FirstChar', True);
    if Obj is TPDFNumeric then FirstChar := TPDFNumeric(Obj).AsInteger;
    Obj := FFontDict.FindValueByKeyName('LastChar', True);
    if Obj is TPDFNumeric then LastChar := TPDFNumeric(Obj).AsInteger;
    HasDescriptor := Assigned(FFontDict.FindValueByKeyName('FontDescriptor', True));

    MatchFontName := FontName;
    if QPLEndsWith(MatchFontName, 'MT') then
      Delete(MatchFontName, Length(MatchFontName) - 1, 2);
    if QPLPos('MT-', MatchFontName) > 0 then
      Delete(MatchFontName, QPLPos('MT-', MatchFontName), 3);

    if (not HasDescriptor) and (Subtype = 'Type1') then
    begin
      for X := 1 to 14 do
        if QPLPos(MatchFontName + '*', BaseFonts[X]) > 0 then
        begin
          FirstChar := 24;
          LastChar := 255;
          GetWidthsByEncoding(peWinAnsi, Widths, X);
          FAscent := FontMetrics[X, 5];
          FDescent := FontMetrics[X, 6];
          FBound.Left := FontMetrics[X, 1];
          FBound.Top := FontMetrics[X, 4];
          FBound.Right := FontMetrics[X, 3];
          FBound.Bottom := FontMetrics[X, 2];
          FFontType := ftStandard;
        end;
    end;

    if (FFontType = ftUnknown) then
    begin
      if (Subtype = 'Type1') then FFontType := ftType1;
      if (Subtype = 'TrueType') then FFontType := ftTrueTypeRef;
      if (Subtype = 'Type3') then FFontType := ftType3;
      if IsCID then
      begin
        if (Subtype = 'CIDFontType0') then FFontType := ftType1CID;
        if (Subtype = 'CIDFontType2') then FFontType := ftTrueTypeCID;
      end;
    end;

    Obj := FFontDict.FindValueByKeyName('FontDescriptor', True);
    if Obj is TPDFDictionary then
    begin
      DescDict := TPDFDictionary(Obj);
      Obj := DescDict.FindValueByKeyName('Ascent', True);
      if Obj is TPDFNumeric then FAscent := TPDFNumeric(Obj).AsInteger;
      Obj := DescDict.FindValueByKeyName('Descent', True);
      if Obj is TPDFNumeric then FDescent := TPDFNumeric(Obj).AsInteger;

      if FAscent = 0.0 then
      begin
        for X := 1 to 14 do
        begin
          if QPLPos(MatchFontName + '*', BaseFonts[X]) > 0 then
          begin
            FAscent := FontMetrics[X, 5];
          end;
        end;
      end;

      if FDescent = 0.0 then
      begin
        for X := 1 to 14 do
        begin
          if QPLPos(MatchFontName + '*', BaseFonts[X]) > 0 then
          begin
            FDescent := FontMetrics[X, 6];
          end;
        end;
      end;

      for X := 1 to 14 do
      begin
        if QPLPos(MatchFontName + '*', BaseFonts[X]) > 0 then
        begin
          FInternalLeading := FontMetrics[X, 7];
          FExternalLeading := FontMetrics[X, 8];
          FAveCharWidth := FontMetrics[X, 10];
        end;
      end;

      Obj := DescDict.FindValueByKeyName('FontFamily', True);
      if Obj is TPDFString then FFontFamily := TPDFString(Obj).AsString;

      Obj := DescDict.FindValueByKeyName('FontBBox', True);
      if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 4) then
      begin
        BBox := TPDFArray(Obj);
        Obj := BBox.Item[0];
        if Obj is TPDFNumeric then FBound.Left := TPDFNumeric(Obj).AsInteger;
        Obj := BBox.Item[1];
        if Obj is TPDFNumeric then FBound.Bottom := TPDFNumeric(Obj).AsInteger;
        Obj := BBox.Item[2];
        if Obj is TPDFNumeric then FBound.Right := TPDFNumeric(Obj).AsInteger;
        Obj := BBox.Item[3];
        if Obj is TPDFNumeric then FBound.Top := TPDFNumeric(Obj).AsInteger;
      end;

      if Assigned(DescDict.FindValueByKeyName('FontFile', True)) then
          FIsEmbedded := True;
      if Assigned(DescDict.FindValueByKeyName('FontFile2', True)) then
          FIsEmbedded := True;
      if Assigned(DescDict.FindValueByKeyName('FontFile3', True)) then
          FIsEmbedded := True;

      {
      if FFontType = ftTrueTypeRef then
      begin
        if Assigned(DescDict.FindValueByKeyName('FontFile2', True)) then
        begin
          FFontType := ftTrueTypeEmbed;
        end;
      end;
      }
    end;

    Obj := FFontDict.FindValueByKeyName('Widths', True);
    if Obj is TPDFArray then
    begin
      SetLength(Widths, LastChar - FirstChar + 1);
      C := TPDFArray(Obj).Count;
      if C >= Length(Widths) then C := Length(Widths);
      for X := 0 to C - 1 do
      begin
        if TPDFArray(Obj).Item[X] is TPDFNumeric then
          Widths[X] := TPDFNumeric(TPDFArray(Obj).Item[X]).AsInteger;
      end;
    end;

    if (FFontType = ftType1CID) or (FFontType = ftTrueTypeCID) then
    begin
      Obj := FFontDict.FindValueByKeyName('W', True);
      if (Obj is TPDFArray) and (TPDFArray(Obj).Count > 1) then
      begin
        FirstChar := -1;
        LastChar := -1;
        WArray := TPDFArray(Obj);
        WX := 0;
        while WX < (WArray.Count - 1) do
        begin
          if WArray.Item[WX] is TPDFNumeric then
          begin
            if WArray.Item[WX + 1] is TPDFNumeric then
            begin
              if (WX < (WArray.Count - 2)) and (WArray.Item[WX + 2] is TPDFNumeric) then
              begin
                WFirst := TPDFNumeric(WArray.Item[WX]).AsInteger;
                WLast := TPDFNumeric(WArray.Item[WX + 1]).AsInteger;
                if (FirstChar < 0) then FirstChar := WFirst else
                begin
                  if WFirst < FirstChar then FirstChar := WFirst;
                end;
                if WLast > LastChar then LastChar := WLast;
                W := TPDFNumeric(WArray.Item[WX + 2]).AsInteger;
                if Length(Widths) < (WLast + 1) then
                  SetLength(Widths, WLast + 1);
                for X := WFirst to WLast do
                  Widths[X] := W;
                Inc(WX, 3);
              end else
                WX := WArray.Count;
            end else
            if WArray.Item[WX + 1] is TPDFArray then
            begin
              WFirst := TPDFNumeric(WArray.Item[WX]).AsInteger;
              WSubArray := TPDFArray(WArray.Item[WX + 1]);
              WLast := WFirst + WSubArray.Count - 1;
              if (FirstChar < 0) then FirstChar := WFirst else
              begin
                if WFirst < FirstChar then FirstChar := WFirst;
              end;
              if WLast > LastChar then LastChar := WLast;
              if Length(Widths) < (WLast + 1) then
                SetLength(Widths, WLast + 1);
              for X := WFirst to WLast do
              begin
                Obj := WSubArray.Item[X - WFirst];
                if Obj is TPDFNumeric then
                  Widths[X] := TPDFNumeric(Obj).AsInteger
                else
                  Widths[X] := 0;
              end;
              Inc(WX, 2);
            end else
              WX := WArray.Count;
          end else
            WX := WArray.Count;
        end;
      end;
    end;
  end;
end;

function TPDFFont.SaveToFile(const FileName: WideString): Boolean;
var
  FS: TQuickPDFWideFileStream;
  Obj: TPDFObject;
  S: AnsiString;
begin
  Result := False;
  Obj := FFontDict.FindValueByKeyName('Subtype', True);
  if (Obj is TPDFName) and (TPDFName(Obj).Name = 'TrueType') then
  begin
    Obj := FFontDict.FindValueByKeyName('FontDescriptor', True);
    if Obj is TPDFDictionary then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName('FontFile2', True);
      if Obj is TPDFStream then
      begin
        try
          FS := QPLCreateFileStream(FileName, fmCreate or fmShareDenyWrite);
          try
            S := TPDFStream(Obj).GetDecodedStream;
            FS.Write(S[1], Length(S));
            Result := True;
          finally
            FS.Free;
          end;
        except
        end;
      end;
    end;
  end;
  if (Obj is TPDFName) and (TPDFName(Obj).Name = 'Type1') then
  begin
    Obj := FFontDict.FindValueByKeyName('FontDescriptor', True);
    if Obj is TPDFDictionary then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName('FontFile', True);
      if Obj is TPDFStream then
      begin
        try
          FS := QPLCreateFileStream(FileName, fmCreate or fmShareDenyWrite);
          try
            S := TPDFStream(Obj).GetDecodedStream;
            FS.Write(S[1], Length(S));
            Result := True;
          finally
            FS.Free;
          end;
        except
        end;
      end;
    end;
  end;
end;

procedure TPDFFont.SetEncoding(const EncodingName: AnsiString);
begin
  if Assigned(FFontDict) and (FFontDict is TPDFDictionary) then
  begin
    FFontDict.PurgeKey('Encoding');
    if EncodingName <> '' then
    begin
      FFontDict.Add('Encoding', FStructure.NewName(EncodingName));
      SetupEncodingCMap(EncodingName, nil);
    end;
  end;
end;

procedure TPDFFont.SetFlags(Fixed, Serif, Symbolic, Script, Italic, AllCap,
  SmallCap, ForceBold: Boolean);
var
  Obj: TPDFObject;
  Flags: Integer;
begin
  Flags := 0;
  if Fixed then Flags := Flags + 1;
  if Serif then Flags := Flags + 2;
  if Symbolic then Flags := Flags + 4;
  if Script then Flags := Flags + 8;
  if not Symbolic then Flags := Flags + 32;
  if Italic then Flags := Flags + 64;
  if AllCap then Flags := Flags + $10000;
  if SmallCap then Flags := Flags + $20000;
  if ForceBold then Flags := Flags + $40000;
  Obj := FFontDict.FindValueByKeyName('FontDescriptor', True);
  if Obj is TPDFDictionary then
  begin
    Obj := TPDFDictionary(Obj).FindValueByKeyName('Flags', True);
    if Obj is TPDFNumeric then
      TPDFNumeric(Obj).SetTo(Flags)
    else
      FFontDict.Add('Flags', FStructure.NewNumeric(Flags));
  end;
end;

function TPDFFont.GetFlags(FontFlagItemID: Integer): Integer;
var
  Flags: Integer;
  FlagMask: Integer;
  Obj: TPDFObject;
begin
  Flags := 0;
  Obj := FFontDict.FindValueByKeyName('FontDescriptor', True);
  if Obj is TPDFDictionary then
  begin
    Obj := TPDFDictionary(Obj).FindValueByKeyName('Flags', True);
    if Obj is TPDFNumeric then
    begin
      Flags := TPDFNumeric(Obj).AsInteger;
    end;
  end;

  FlagMask := 0;
  case FontFlagItemID of
    1: FlagMask := 1;       // Fixed
    2: FlagMask := 2;       // Serif
    3: FlagMask := 4;       // Symbolic
    4: FlagMask := 8;       // Script
    5: FlagMask := 64;      // Italic
    6: FlagMask := $10000;  // AllCap
    7: FlagMask := $20000;  // SmallCap
    8: FlagMask := $40000;  // ForceBold
  end;

  if ((FlagMask > 0) and (Flags and FlagMask = FlagMask)) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

procedure TPDFFont.SetName(const Name: AnsiString);
begin
  FFontDict.Add('Name', FStructure.NewName(Name));
end;

procedure TPDFFont.SetupEncodingCMap(const BaseEncoding: AnsiString;
  Differences: TPDFArray);
var
  X: Integer;
  CharPos: Integer;
  ThisGlyphName: AnsiString;
  DiffList: AnsiString;
  Mapping: array[0..255] of Word;
  Target: TQPLByteArray;
  FirstChar, LastChar: Integer;
begin
  FirstChar := 256;
  LastChar := 0;

  if (Assigned(FEncodingCMap)) then
  begin
    FEncodingCMap.Free;
    FEncodingCMap := nil;
  end;
  FEncodingCMap := TDebenuPDFLibraryCMap.Create;

  FillChar(Mapping[0], 256 * 2, 0);

  if (BaseEncoding = 'MacRomanEncoding') then
  begin
    for X := 1 to 229 do
    begin
      if (MacRomanEncodingVector[X] >= 0) then
      begin
        if (MacRomanEncodingVector[X] < FirstChar) then
        begin
          FirstChar := MacRomanEncodingVector[X];
        end;
        if (MacRomanEncodingVector[X] > LastChar) then
        begin
          LastChar := MacRomanEncodingVector[X];
        end;
        Mapping[MacRomanEncodingVector[X]] := UnicodeValues[X];
      end;
    end;
  end else
  //if (BaseEncoding = 'WinAnsiEncoding') then
  begin
    for X := 1 to 229 do
    begin
      if (WinAnsiEncodingVector[X] >= 0) then
      begin
        if (WinAnsiEncodingVector[X] < FirstChar) then
        begin
          FirstChar := WinAnsiEncodingVector[X];
        end;
        if (WinAnsiEncodingVector[X] > LastChar) then
        begin
          LastChar := WinAnsiEncodingVector[X];
        end;
        Mapping[WinAnsiEncodingVector[X]] := UnicodeValues[X];
      end;
    end;
  end;

  if (Assigned(Differences)) then
  begin
    CharPos := 0;
    DiffList := '';
    for X := 0 to Differences.Count - 1 do
    begin
      if Differences.Item[X] is TPDFNumeric then
      begin
        CharPos := TPDFNumeric(Differences.Item[X]).AsInteger;
      end else
      if Differences.Item[X] is TPDFName then
      begin
        ThisGlyphName := TPDFName(Differences.Item[X]).Name;
        if (CharPos < FirstChar) then
        begin
          FirstChar := CharPos;
        end;
        if (CharPos > LastChar) then
        begin
          LastChar := CharPos;
        end;
        Mapping[CharPos] := GetGlyphUnicode(ThisGlyphName);
        Inc(CharPos);
      end;
    end;
  end;

  FEncodingCMap.AddCodespaceRange(FirstChar, LastChar, 1);

  SetLength(Target, 1);
  for X := 0 to 255 do
  begin
    Target[0] := X;
    if (Mapping[X] > 0) then
    begin
      FEncodingCMap.AddMapping(2, Mapping[X], Target);
    end;
  end;
end;

procedure TPDFFont.SetupSimpleUnicodeCMap;
var
  X: Integer;
  Target: TQPLByteArray;
begin
  if (Assigned(FEncodingCMap)) then
  begin
    FEncodingCMap.Free;
    FEncodingCMap := nil;
  end;
  FEncodingCMap := TDebenuPDFLibraryCMap.Create;

  FEncodingCMap.AddCodespaceRange(0, 255, 1);

  SetLength(Target, 1);
  for X := 0 to 255 do
  begin
    Target[0] := X;
    FEncodingCMap.AddMapping(2, X, Target);
  end;
end;

procedure TPDFFont.UpdateSubsettedFont(UpdateFontDescriptor: Boolean);
var
  NewSubsetString: WideString;
  I: Integer;
  bytepos, bitpos: Integer;
begin
  if (FCanUpdate and FNeedsUpdate) then
  begin

    for I := 0 to 65535 do
    begin
      bytepos := I div 8;
      bitpos  := I mod 8;

      if ((FCharsUsed[bytepos] and ($01 shl bitpos)) <> 0) then
        NewSubsetString := NewSubsetString + WideChar(I);
    end;

    if (Length(NewSubsetString) > 0) then
    begin
      if (UpdateFontDescriptor) then
        NewSubsettedTrueTypeFont(FFontName, NewSubsetString, FOriginalOptions, True, FOriginalCharset, IsEmbedded)
      else
        NewSubsettedTrueTypeFont(FFontName, NewSubsetString, 0, True, FOriginalCharset, IsEmbedded);
    end;
  end;
end;

procedure TPDFFont.SetKernAmount(C1, C2: WideChar; Amount: Integer);
var
  X: Integer;
  I: Integer;
  Match: Cardinal;
begin
  I := FindKernPair(AnsiChar(C1), AnsiChar(C2));
  if I >= 0 then
  begin
    KernPairs[I].Adjust := Amount;
  end else
  begin
    I := 0;
    Match := Ord(C1) shl 16 + Ord(C2);
    for X := 0 to Length(KernPairs) - 1 do
      if KernPairs[X].Match > Match then I := X;
    SetLength(KernPairs, Length(KernPairs) + 1);
    for X := Length(KernPairs) - 1 downto I + 1 do
      KernPairs[X] := KernPairs[X - 1];
    KernPairs[I].Match := Match;
    KernPairs[I].Adjust := Amount;
  end;
end;

procedure TPDFFont.SetCharWidth(AChar, NewWidth: Integer);
var
  Obj: TPDFObject;
  WidthsArray: TPDFArray;
  IntArray: array of Integer;
  X: Integer;
begin
  Widths[AChar - FirstChar] := NewWidth;
  Obj := FFontDict.FindValueByKeyName('Widths');
  if Obj is TPDFArray then
  begin
    WidthsArray := TPDFArray(Obj);
    Obj := WidthsArray.Item[AChar - FirstChar];
    if Obj is TPDFNumeric then
      TPDFNumeric(Obj).SetTo(NewWidth);
  end else
  begin
    FFontDict.Add('FirstChar', FStructure.NewNumeric(FirstChar));
    FFontDict.Add('LastChar', FStructure.NewNumeric(LastChar));    
    SetLength(IntArray, LastChar - FirstChar + 1);
    for X := FirstChar to LastChar do
      IntArray[X - FirstChar] := Widths[X - FirstChar];
    WidthsArray := FStructure.NewIntArray(IntArray);
    FFontDict.Add('Widths', WidthsArray);
  end;
end;

function TPDFFont.NewCJKFont(CJKFontID: Integer): Boolean;
var
  FontDict: TPDFDictionary;
  DescFont: TPDFDictionary;
  ObjNum, GenNum: Integer;
  CID: TPDFDictionary;
  FontDescriptor: TPDFDictionary;
  StyleDict: TPDFDictionary;
  StyleModifier: AnsiString;
  CMapName: AnsiString;
  S: AnsiString;
begin
  Result := True;

  StyleModifier := '';

  if ((CJKFontID >= 1) and (CJKFontID <= 4)) then
  begin
    CMapName := 'UniJIS-UCS2-H';
  end else
  if ((CJKFontID >= 5) and (CJKFontID <= 16)) then
  begin
    CMapName := 'UniKS-UCS2-H';
  end else
  begin
    CMapName := '';
  end;

  if ((CJKFontID >= 1) and (CJKFontID <= 4)) then
  begin
    FFontName := 'HeiseiKakuGo-W5';
  end else
  if ((CJKFontID >= 5) and (CJKFontID <= 8)) then
  begin
    FFontName := 'HYGoThic-Medium';
  end else
  if ((CJKFontID >= 9) and (CJKFontID <= 12)) then
  begin
    FFontName := 'HYSMyeongJo-Medium';
  end else
  if ((CJKFontID >= 13) and (CJKFontID <= 16)) then
  begin
    FFontName := 'HYSMyeongJoStd-Medium';
  end;

  StyleModifier := '';
  if ((CJKFontID mod 4) = 2) then StyleModifier := ',Bold';
  if ((CJKFontID mod 4) = 3) then StyleModifier := ',BoldItalic';
  if ((CJKFontID mod 4) = 0) then StyleModifier := ',Italic';

// HYGoThic-Medium
// HYSMyeongJo-Medium
// HYSMyeongJoStd-Medium

  FontDict := FStructure.NewDictionary;
  FFontDict := FontDict;
  if Assigned(FStructure.OnNewIndObj) then
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, FontDict);
  FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);

  FontDict.Add('Type', FStructure.NewCommonName('Font'));
  DescFont := FStructure.NewDictionary;
  if Assigned(FStructure.OnNewIndObj) then
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, DescFont);
  FontDict.Add('DescendantFonts', FStructure.NewArray([FStructure.NewIndirectRef(ObjNum, GenNum)]));
  FontDict.Add('BaseFont', FStructure.NewName(FFontName + '-' + CMapName + StyleModifier));
  FontDict.Add('Subtype', FStructure.NewCommonName('Type0'));
  FontDict.Add('Encoding', FStructure.NewName(CMapName));
  DescFont.Add('Type', FStructure.NewCommonName('Font'));
  DescFont.Add('DW', FStructure.NewNumeric(1000));
  CID := FStructure.NewDictionary;
  DescFont.Add('CIDSystemInfo', CID);
  if (CMapName = 'UniJIS-UCS2-H') then
  begin
    CID.Add('Supplement', FStructure.NewNumeric(4));
    CID.Add('Ordering', FStructure.NewString('Japan1'));
    CID.Add('Registry', FStructure.NewString('Adobe'));
  end else
  if (CMapName = 'UniKS-UCS2-H') then
  begin
    CID.Add('Supplement', FStructure.NewNumeric(1));
    CID.Add('Ordering', FStructure.NewString('Korea1'));
    CID.Add('Registry', FStructure.NewString('Adobe'));
  end;

  FontDescriptor := FStructure.NewDictionary;
  if Assigned(FStructure.OnNewIndObj) then
    FStructure.OnNewIndObj(Self, ObjNum, GenNum, FontDescriptor);
  DescFont.Add('FontDescriptor', FStructure.NewIndirectRef(ObjNum, GenNum));

  DescFont.Add('BaseFont', FStructure.NewName(FFontName + StyleModifier));
  DescFont.Add('Subtype', FStructure.NewCommonName('CIDFontType0'));

  FontDescriptor.Add('Type', FStructure.NewCommonName('FontDescriptor'));
  FontDescriptor.Add('FontName', FStructure.NewName(FFontName + StyleModifier));
  FontDescriptor.Add('ItalicAngle', FStructure.NewNumeric(0));
  if QPLPos('Bold', StyleModifier) > 0 then
    FontDescriptor.Add('StemV', FStructure.NewNumeric(140))
  else
    FontDescriptor.Add('StemV', FStructure.NewNumeric(80));
  FontDescriptor.Add('XHeight', FStructure.NewNumeric(553));
  StyleDict := FStructure.NewDictionary;
  FontDescriptor.Add('Style', StyleDict);

  if (FFontName = 'HeiseiKakuGo-W5') then
  begin
    FCIDWidths := InflateStr(HeiseiKakuGoW5UCWidths);
    S := InflateStr(HeiseiKakuGoW5CIDWidths);
    DescFont.Add('W', FStructure.Decode(S));
    FontDescriptor.Add('Ascent', FStructure.NewNumeric(752));
    FontDescriptor.Add('CapHeight', FStructure.NewNumeric(737));
    FontDescriptor.Add('Descent', FStructure.NewNumeric(-221));
    FontDescriptor.Add('Flags', FStructure.NewNumeric(4));
    FontDescriptor.Add('FontBBox', FStructure.NewIntArray([-92, -250, 1010, 922]));
    StyleDict.Add('Panose', FStructure.NewString(
      AnsiChar($08) + AnsiChar($01) + AnsiChar($02) + AnsiChar($0b) +
      AnsiChar($06) + AnsiChar($00) + AnsiChar($00) + AnsiChar($00) +
      AnsiChar($00) + AnsiChar($00) + AnsiChar($00) + AnsiChar($00), smHex));
  end else
  if (FFontName = 'HYGoThic-Medium') then
  begin
    FCIDWidths := InflateStr(HYGoThicMediumUCWidths);
    S := InflateStr(HYGoThicMediumCIDWidths);
    DescFont.Add('W', FStructure.Decode(S));
    FontDescriptor.Add('Ascent', FStructure.NewNumeric(880));
    FontDescriptor.Add('CapHeight', FStructure.NewNumeric(880));
    FontDescriptor.Add('Descent', FStructure.NewNumeric(-120));
    FontDescriptor.Add('Flags', FStructure.NewNumeric(4));
    FontDescriptor.Add('FontBBox', FStructure.NewIntArray([-6, -145, 1003, 880]));
    StyleDict.Add('Panose', FStructure.NewString(
      AnsiChar($08) + AnsiChar($01) + AnsiChar($02) + AnsiChar($0b) +
      AnsiChar($06) + AnsiChar($00) + AnsiChar($00) + AnsiChar($00) +
      AnsiChar($00) + AnsiChar($00) + AnsiChar($00) + AnsiChar($00), smHex));
  end else
  if (FFontName = 'HYSMyeongJo-Medium') then
  begin
    FCIDWidths := InflateStr(HYGoThicMediumUCWidths);
    S := InflateStr(HYGoThicMediumCIDWidths);
    DescFont.Add('W', FStructure.Decode(S));
    FontDescriptor.Add('Ascent', FStructure.NewNumeric(880));
    FontDescriptor.Add('CapHeight', FStructure.NewNumeric(880));
    FontDescriptor.Add('Descent', FStructure.NewNumeric(-120));
    FontDescriptor.Add('Flags', FStructure.NewNumeric(6));
    FontDescriptor.Add('FontBBox', FStructure.NewIntArray([0, -148, 1001, 880]));
    StyleDict.Add('Panose', FStructure.NewString(
      AnsiChar($01) + AnsiChar($05) + AnsiChar($02) + AnsiChar($02) +
      AnsiChar($06) + AnsiChar($00) + AnsiChar($00) + AnsiChar($00) +
      AnsiChar($00) + AnsiChar($00) + AnsiChar($00) + AnsiChar($00), smHex));
  end else
  if (FFontName = 'HYSMyeongJoStd-Medium') then
  begin
    FCIDWidths := InflateStr(HYGoThicMediumUCWidths);
    S := InflateStr(HYGoThicMediumCIDWidths);
    DescFont.Add('W', FStructure.Decode(S));
    FontDescriptor.Add('Ascent', FStructure.NewNumeric(880));
    FontDescriptor.Add('CapHeight', FStructure.NewNumeric(880));
    FontDescriptor.Add('Descent', FStructure.NewNumeric(-120));
    FontDescriptor.Add('Flags', FStructure.NewNumeric(6));
    FontDescriptor.Add('FontBBox', FStructure.NewIntArray([0, -148, 1001, 880]));
    StyleDict.Add('Panose', FStructure.NewString(
      AnsiChar($01) + AnsiChar($05) + AnsiChar($00) + AnsiChar($00) +
      AnsiChar($06) + AnsiChar($00) + AnsiChar($00) + AnsiChar($00) +
      AnsiChar($00) + AnsiChar($00) + AnsiChar($00) + AnsiChar($00), smHex));
  end;

  FAscent := 880;
  FDescent := -120;
  FBound.Left := -92;
  FBound.Top := 922;
  FBound.Right := 1010;
  FBound.Bottom := -250;

  FFontType := ftCJK;

  FEncodingCMap.SetIdentityMapping;
end;

function TPDFFont.NewOpenTypeFont(Source: TStream): Boolean;
var
  TTP: TPDFTrueTypeParser;
var
  Dict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  FontDataStr: AnsiString;
  CIDIndex: Integer;
  DescendantFont: TPDFDictionary;
  FontDescriptor: TPDFDictionary;
  Metrics: TOutlineTextmetricW;
  Flags: Integer;
  FontStream: TPDFStream;
  FontFile: TPDFIndRef;
  WidthsArrayStr: AnsiString;
  Target: TQPLByteArray;
  TTCMapIndex: Integer;
  EncodingRecord: TPDFTTEncodingRecord;
  MappingIndex: Integer;
  ToUnicode: AnsiString;
  ToUnicodeStream: TPDFStream;
  CIDRanges: AnsiString;
  CIDList: TStringList;
  MapA, MapB, MapC, MapD, MapF: Integer;
begin
  Result := False;

  TTP := TPDFTrueTypeParser.Create;
  try
    Source.Seek(0, soFromBeginning);
    TTP.LoadFromStream(Source);
    if (TTP.GetCFFDataPosition > 0) then
    begin
      Result := True;

      TTP.ReadNameTable;
      FFontName := AnsiString(TTP.FontName);

      CIDRanges := '';
      CIDList := TStringList.Create;
      try
        if (Assigned(FEncodingCMap)) then
        begin
          FEncodingCMap.Free;
          FEncodingCMap := nil;
        end;

        FEncodingCMap := TDebenuPDFLibraryCMap.Create;
        FEncodingCMap.AddCodespaceRange(0, TTP.GlyphCount - 1, 2);
        SetLength(Target, 2);

        // Get the Unicode to CID mapping
        TTCMapIndex := TTP.Findcmap(0, 3);
        if (TTCMapIndex >= 0) then
        begin
          EncodingRecord := TTP.Getcmap(TTCMapIndex);
          for MappingIndex := 0 to Length(EncodingRecord.Codes) - 1 do
          begin
            Target[0] := (EncodingRecord.GlyfID[MappingIndex] and $FF00) shr 8;
            Target[1] := EncodingRecord.GlyfID[MappingIndex] and $FF;
            FEncodingCMap.AddMapping(2, EncodingRecord.Codes[MappingIndex], Target);

            CIDList.Add('<' + IntToHex(EncodingRecord.GlyfID[MappingIndex], 4) + '> ' +
              '<' + IntToHex(EncodingRecord.GlyfID[MappingIndex], 4) + '> ' +
              '<' + IntToHex(EncodingRecord.Codes[MappingIndex], 4) + '>');
          end;
        end;

        // Sort the list
        CIDList.Sort;

        // Collapse consecutive items into a single
        MappingIndex := 0;
        while (MappingIndex < (CIDList.Count - 1)) do
        begin
          MapA := StrToInt('$' + Copy(CIDList[MappingIndex], 2, 4));
          MapB := StrToInt('$' + Copy(CIDList[MappingIndex], 9, 4));
          MapC := StrToInt('$' + Copy(CIDList[MappingIndex], 16, 4));
          MapD := StrToInt('$' + Copy(CIDList[MappingIndex + 1], 2, 4));
          MapF := StrToInt('$' + Copy(CIDList[MappingIndex + 1], 16, 4));

          if ((MapD = MapB + 1) and (MapF = MapC + MapB - MapA + 1) and
            ((MapB and $FF00) = (MapD and $FF00))) then
          begin
            CIDList[MappingIndex] := Copy(CIDList[MappingIndex], 1, 8) +
              Copy(CIDList[MappingIndex + 1], 2, 4) +
              Copy(CIDList[MappingIndex], 13, MaxInt);
            CIDList.Delete(MappingIndex + 1);
          end else
          begin
            Inc(MappingIndex, 1);
          end;
        end;

        while (CIDList.Count >= 100) do
        begin
          CIDRanges := CIDRanges + '100 beginbfrange'#10;
          for MappingIndex := 0 to 99 do
          begin
            CIDRanges := CIDRanges + AnsiString(CIDList[0]) + #10;
            CIDList.Delete(0);
          end;
          CIDRanges := CIDRanges + 'endbfrange'#10;
        end;
        if (CIDList.Count > 0) then
        begin
          CIDRanges := CIDRanges + QPLIntToStr(CIDList.Count) + ' beginbfrange'#10;
          for MappingIndex := 0 to CIDList.Count - 1 do
          begin
            CIDRanges := CIDRanges + AnsiString(CIDList[MappingIndex]) + #10;
          end;
          CIDRanges := CIDRanges + 'endbfrange'#10;
        end;
      finally
        CIDList.Free;
      end;

      // Get the font widths
      FirstChar := 0;
      LastChar := TTP.GlyphCount - 1;
      SetLength(Widths, TTP.GlyphCount + 1);
      WidthsArrayStr := '0 [';
      for CIDIndex := 0 to TTP.GlyphCount - 1 do
      begin
        WidthsArrayStr := WidthsArrayStr + ' ' + QPLIntToStr(TTP.GetWidth(CIDIndex));
        Widths[CIDIndex] := TTP.GetWidth(CIDIndex);
      end;
      WidthsArrayStr := WidthsArrayStr + ' ]';

      // Get the font metrics
      TTP.ReadMetrics(Metrics);

      // Extract the CFF data from the OpenType font
      //Source.Seek(0, soFromBeginning);
      //SetLength(FontDataStr, Source.Size);
      //Source.Read(FontDataStr[1], Length(FontDataStr));
      FontDataStr := TTP.GetCFFData;

      Dict := FStructure.NewDictionary;
      FFontDict := Dict;
      Dict.Add('Type', FStructure.NewName('Font'));
      Dict.Add('Subtype', FStructure.NewName('Type0'));
      Dict.Add('Encoding', FStructure.NewName('Identity-H'));
      Dict.Add('BaseFont', FStructure.NewName(FFontName));

      ToUnicode :=
        '%!PS-Adobe-3.0 Resource-CMap'#10 +
        '%%DocumentNeededResources: ProcSet (CIDInit)'#10 +
        '%%IncludeResource: ProcSet (CIDInit)'#10 +
        '%%BeginResource: CMap (Adobe-Identity-000)'#10 +
        '%%Title: (Adobe-Identity-000 Adobe Identity 0)'#10 +
        '%%EndComments'#10 +
        '/CIDInit /ProcSet findresource begin'#10 +
        '12 dict begin'#10 +
        'begincmap'#10 +
        '/CIDSystemInfo 3 dict dup begin'#10 +
        '/Registry (Adobe) def'#10 +
        '/Ordering (Identity) def'#10 +
        '/Supplement 0 def'#10 +
        'end def'#10 +
        '/CMapName /Adobe-Identity-000 def'#10 +
        '/CMapVersion 1.000 def'#10 +
        '/CMapType 2 def'#10 +
        '/WMode 0 def'#10 +
        '1 begincodespacerange'#10 +
        '<0000> <FFFF>'#10 +
        'endcodespacerange'#10 +
        CIDRanges +
        #10'endcmap'#10 +
        'CMapName currentdict /CMap defineresource pop'#10 +
        'end'#10 +
        'end';

      ToUnicodeStream := FStructure.NewStream('');
      ToUnicodeStream.SetTo(ToUnicode, False);
      with ToUnicodeStream.Dictionary do
      begin
        Add('Type', FStructure.Decode('/CMap'));
        Add('CMapName', FStructure.Decode('/Adobe-Identity-000'));
        Add('CIDSystemInfo', FStructure.Decode('<< /Registry (Adobe) /Ordering (Identity) /Supplement 0 >>'));
        Add('WMode', FStructure.NewNumeric(0));
      end;
      if Assigned(FStructure.OnNewIndObj) then
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, ToUnicodeStream);
      FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
      Dict.Add('ToUnicode', FIndRef);

      DescendantFont := FStructure.NewDictionary;
      DescendantFont.Add('Type', FStructure.NewName('Font'));
      DescendantFont.Add('Subtype', FStructure.NewName('CIDFontType0'));
      DescendantFont.Add('BaseFont', FStructure.NewName(FFontName));
      DescendantFont.Add('CIDSystemInfo', FStructure.Decode('<< /Registry (Adobe) /Ordering (Identity) /Supplement 0 >>'));
      DescendantFont.Add('DW', FStructure.NewNumeric(1000));
      DescendantFont.Add('W', FStructure.Decode('[ ' + WidthsArrayStr + ']'));

      FontDescriptor := FStructure.NewDictionary;
      FontDescriptor.Add('Type', FStructure.NewName('FontDescriptor'));
      FontDescriptor.Add('FontName', FStructure.NewName(FFontName));
      with Metrics do
      begin
        FontDescriptor.Add('FontBBox', FStructure.NewIntArray([otmrcFontBox.Left,
          otmrcFontBox.Bottom, otmrcFontBox.Right, otmrcFontBox.Top]));
{$IFNDEF QPL_CPP}
        FBound := otmrcFontBox;
{$ENDIF}
        Flags := 0;
        if otmTextMetrics.tmCharSet = SYMBOL_CHARSET then
          Flags := Flags + 4 else Flags := Flags + 32;
        if (otmTextMetrics.tmPitchAndFamily and
          TMPF_FIXED_PITCH) = TMPF_FIXED_PITCH then
            Flags := Flags + 1;
        FontDescriptor.Add('Flags', FStructure.NewNumeric(Flags));
        FontDescriptor.Add('MissingWidth', FStructure.NewNumeric(750));
        FontDescriptor.Add('StemV', FStructure.NewNumeric(0));
        FontDescriptor.Add('ItalicAngle', FStructure.NewNumeric(otmItalicAngle));
        FontDescriptor.Add('CapHeight', FStructure.NewNumeric(Metrics.otmTextMetrics.tmAscent));

        FAscent := Metrics.otmAscent;
        FDescent := -Abs(Metrics.otmDescent);

        FAscentTM := Metrics.otmTextMetrics.tmAscent;
        FDescentTM := -Abs(Metrics.otmTextMetrics.tmDescent);
        FInternalLeading := Metrics.otmTextMetrics.tmInternalLeading;
        FExternalLeading := Metrics.otmTextMetrics.tmExternalLeading;
        FHeight := Metrics.otmTextMetrics.tmHeight;
        FAveCharWidth := Metrics.otmTextMetrics.tmAveCharWidth;

        FontDescriptor.Add('Ascent', FStructure.NewNumeric(FAscent));
        FontDescriptor.Add('Descent', FStructure.NewNumeric(FDescent));
        FontDescriptor.Add('MaxWidth', FStructure.NewNumeric(otmTextMetrics.tmMaxCharWidth));
        FontDescriptor.Add('AvgWidth', FStructure.NewNumeric(otmTextMetrics.tmAveCharWidth));
      end;

      FontStream := FStructure.NewStream(DeflateStr(FontDataStr));
      FontStream.Dictionary.Add('Filter', FStructure.NewCommonName('FlateDecode'));

      if Assigned(FStructure.OnNewIndObj) then
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, FontStream);
      FontFile := FStructure.NewIndirectRef(ObjNum, GenNum);
      FontStream.Dictionary.Add('Subtype', FStructure.NewName('CIDFontType0C'));
      //FontStream.Dictionary.Add('Subtype', FStructure.NewName('OpenType'));
      FontDescriptor.Add('FontFile3', FontFile);

      if Assigned(FStructure.OnNewIndObj) then
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, FontDescriptor);
      FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
      DescendantFont.Add('FontDescriptor', FIndRef);

      if Assigned(FStructure.OnNewIndObj) then
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, DescendantFont);
      FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
      Dict.Add('DescendantFonts', FStructure.NewArray([FIndRef]));
      if Assigned(FStructure.OnNewIndObj) then
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, Dict);
      FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    end;
  finally
    TTP.Free;
  end;
end;

function TPDFFont.MakeCMap(const BaseEncoding: AnsiString;
  Differences: TPDFArray): AnsiString;
var
  SL: TQuickPDFStringList;
  X: Integer;
  CharPos: Integer;
  ThisGlyphName: AnsiString;
  DiffList: AnsiString;
  DiffCount: Integer;
begin
  CharPos := 0;
  DiffList := '';
  DiffCount := 0;
  for X := 0 to Differences.Count - 1 do
  begin
    if Differences.Item[X] is TPDFNumeric then
    begin
      CharPos := TPDFNumeric(Differences.Item[X]).AsInteger;
    end else
    if Differences.Item[X] is TPDFName then
    begin
      Inc(DiffCount);
      ThisGlyphName := TPDFName(Differences.Item[X]).Name;
      DiffList := DiffList + '<' + QPLIntToHex(CharPos, 2) + '> <' +
        QPLIntToHex(GetGlyphUnicode(ThisGlyphName), 4) + '>'#13#10;
      Inc(CharPos);
    end;
  end;
  SL := TQuickPDFStringList.Create;
  try
    SL.Add('/CIDInit /ProcSet findresource begin');
    SL.Add('12 dict begin');
    SL.Add('begincmap');
    SL.Add('/CIDSystemInfo');
    SL.Add('<< /Registry (Adobe)');
    SL.Add('/Ordering ()');
    SL.Add('/Supplement 0');
    SL.Add('>> def');
    SL.Add('/CMapName /Adobe--000 def');
    SL.Add('/CMapType 2 def');
    SL.Add('1 begincodespacerange');
    SL.Add('<00> <FF>');
    SL.Add('endcodespacerange');
    SL.Add(QPLIntToStr(DiffCount) + ' beginbfchar');
    SL.Add(DiffList);
    SL.Add('endbfchar');
    SL.Add('endcmap');
    SL.Add('CMapName currentdict /CMap defineresource pop');
    SL.Add('end');
    SL.Add('end');
    Result := SL.Text;
  finally
    SL.Free;
  end;
end;

function TPDFFont.GetCharacterCodes(const Text: WideString): AnsiString;
var
  CharIndex: Integer;
  Target: TQPLByteArray;
  ResultLength: Integer;
begin

  Result := '';
  ResultLength := 0;
  for CharIndex := 1 to Length(Text) do
  begin
    if (FEncodingCMap.GetMappingToByteArray(2, Ord(Text[CharIndex]), Target)) then
    begin
      if (ResultLength + Length(Target) > Length(Result)) then
      begin
        SetLength(Result, Length(Result) + 1000);
      end;
      if (Length(Target) > 0) then
      begin
        Move(Target[0], Result[ResultLength + 1], Length(Target));
      end;
      Inc(ResultLength, Length(Target));
    end;
  end;
  SetLength(Result, ResultLength);
end;

function TPDFFont.GetGIDToCID(const GID: Integer): Word;
begin
  Result := 65535;
  //if (GID >= 0) and (GID <= 255) then
  if (GID >= 0) and (GID <= Length(FGIDTOCID)) then
    Result := FGIDToCID[GID];
end;

function TPDFFont.GetEncoding: AnsiString;
//var
//  Obj: TPDFObject;
begin
  Result := '';
  if Assigned(FFontDict) and (FFontDict is TPDFDictionary) then
  begin

  end;
end;

const
  TTFCFP_SUBSET = 0;
  TTFCFP_SUBSET1 = 1;
  TTFCFP_DELTA = 2;

  TTFCFP_UNICODE_PLATFORMID = 0;
  TTFCFP_APPLE_PLATFORMID = 1;
  TTFCFP_ISO_PLATFORMID = 2;
  TTFCFP_MS_PLATFORMID = 3;

  TTFCFP_STD_MAC_CHAR_SET = 0;
  TTFCFP_SYMBOL_CHAR_SET = 0;
  TTFCFP_UNICODE_CHAR_SET = 1;
  TTFCFP_DONT_CARE = $FFFF;

  TTFCFP_LANG_KEEP_ALL = 0;

  TTFCFP_FLAGS_SUBSET = $0001;
  TTFCFP_FLAGS_COMPRESS = $0002;
  TTFCFP_FLAGS_TTC = $0004;
  TTFCFP_FLAGS_GLYPHLIST = $0008;

function CreateFontPackageAllocate(Size: Integer): Pointer; cdecl;
begin
  GetMem(Result, Size);
end;

function CreateFontPackageReallocate(Buffer: Pointer; Size: Integer): Pointer; cdecl;
begin
  ReallocMem(Buffer, Size);
  Result := Buffer;
end;

procedure CreateFontPackageFree(Buffer: Pointer); cdecl;
begin
  FreeMem(Buffer);
end;

{$IFDEF QPL_OS_WINDOWS}
function CreateFontPackage(
  puchSrcBuffer: PByte;
  ulSrcBufferSize: Cardinal;
  var puchFontPackageBuffer: PByte;
  var pulFontPackageBufferSize: Cardinal;
  var pulBytesWritten: Cardinal;
  usFlags: Word;
  usTTCIndex: Word;
  usSubsetFormat: Word;
  usSubsetLanguage: Word;
  usSubsetPlatform: Word;
  usSubsetEncoding: Word;
  pusSubsetKeepList: PWord;
  usSubsetKeepListCount: Word;
  lpfnAllocate: FARPROC;
  lpfnReAllocate: FARPROC;
  lpfnFree: FARPROC;
  lpvReserved: Pointer
): Cardinal; cdecl; external 'FontSub.dll' name 'CreateFontPackage';
{$ENDIF}

procedure TPDFFont.QSortWordArray(var A: array of Word);
  procedure QuickSort(var A: array of Word; iLo, iHi: Integer);
  var Lo, Hi, Mid, T: Integer;
  begin

    Lo := iLo;
    Hi := iHi;

    if (Lo > Hi) then
      Exit;

    Mid := A[(Lo + Hi) div 2];
    repeat
      while A[Lo] < Mid do
        Inc(Lo);
      while A[Hi] > Mid do
        Dec(Hi);
      if Lo <= Hi then begin
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then
      QuickSort(A, iLo, Hi);
    if Lo < iHi then
      QuickSort(A, Lo, iHi);
  end;
begin
  QuickSort(A, Low(A), High(A));
end;

{
function TPDFFont.ConvertCIDToGID(Text: WideString): WideString;
  var I, J: Integer;
begin
  Result := Text;
  for I := 1 to Length(Text) do
  begin
    for J := 0 to Length(CIDKeepCodes) - 1 do
      if (Ord(Result[I]) = CIDKeepCodes[J]) then
        Result[I] := AnsiChar(GIDCodes[J]);
  end;
end;
}

function TPDFFont.NewSubsettedTrueTypeFont(const FontName: AnsiString;
  SubsetChars: WideString; Options: Integer; Update: Boolean; Charset: Integer; Embed: Boolean): Boolean;
var
  Dict: TPDFDictionary;
  ObjNum: Integer;
  GenNum: Integer;
  FontPackageBuffer: PByte;
  FontPackageBufferSize: Cardinal;
  BytesWritten: Cardinal;
  Widths: array of Word;
  ResultCode: Cardinal;
  FontDataStr: AnsiString;
  BM: TBitmap;
  RetFont: TFont;
  BaseFont: AnsiString;
  ScreenDC: HDC;
  ScreenDPI: Integer;
  TTCLen: Cardinal;
  Len: Cardinal;
  TTCOffset: Integer;
  TrueTypeParser: TPDFTrueTypeParser;
  ToUnicode: AnsiString;
  ToUnicodeStream: TPDFStream;
  RandomIndex: Integer;
  DescendantFont: TPDFDictionary;
  FontDescriptor: TPDFDictionary;
  Metrics: TOutlineTextmetricW;
  Flags: Integer;
  MappingIndex: Integer;
  Target: TQPLByteArray;
  FontStream: TPDFStream;
  FontFile: TPDFIndRef;
  WidthsArrayStr: AnsiString;
  WidthsArray: array of Integer;
  TTCMapIndex: Integer;
  EncodingRecord: TPDFTTEncodingRecord;
  CIDToGIDMap: AnsiString;
  CIDToGIDMapStream: TPDFStream;
  CIDToGIDMapStreamRef: TPDFIndRef;
  PlatformID: Integer;
  PlatformCharset: Integer;
  CIDRanges: AnsiString;
  CIDList: TStringList;
  S1, S2: AnsiString;
  Start, LastW: Integer;
  IsSequential: Boolean;
  IsSameWidth: Boolean;
  MapA, MapB, MapC, MapD, MapF: Integer;
  Obj: TPDFObject;
  S: WideString;
  I: Integer;
  MaxCode: Integer;
  FaceName: WideString;
  LangInfo: DWord;
  MaxCID: Integer;
begin
  FontStream := nil;
  Result := False;
  FIsEmbedded := Embed;
  MaxCID := -1;

  FEncodingCMap.SetIdentityMapping;

  if ((Options = 2) or (Options = 3) or (Options = 4) or (Options = 5)) then
  begin
    FCanUpdate := True;

    FAutoUpdate := (Options = 4) or (Options = 5);
    FOriginalOptions := Options;
    FOriginalCharSet := Charset;

    SetLength(FCharsUsed, 8192);   // 65536 bits.
    // AddToSubset(SubsetChars);
  end;

  if (not Update) then
  begin
    BaseFont := AnsiString(FontName);
    FFontFamily := BaseFont;

    if (Embed) then
    begin
      FFontName := '';
      for RandomIndex := 1 to 6 do
      begin
        FFontName := FFontName + AnsiChar(Random(26) + 65);
      end;
      FFontName := FFontName + '+' + BaseFont;
    end
    else
      FFontName := BaseFont;

    FFontType := ftTrueTypeCID;
    FIsSubsetted := True;
  end
  else
  begin
    if (Length(FontName) > 7) and (FontName[7] = '+') then
    begin
      BaseFont := QPLCopy(AnsiString(FontName), 8, MaxInt);
      FFontFamily := BaseFont;
    end;
  end;

  WidthsArrayStr := '';

  SetLength(FontDataStr, 0);
  BM := TBitmap.Create;
  try
    BM.Canvas.Lock;
    BM.Canvas.Font.Style := [];
    if QPLEndsWith(BaseFont, ' [Bold]') then
    begin
      BM.Canvas.Font.Style := [fsBold];
      Delete(BaseFont, Length(BaseFont) - 6, 7);
    end;
    if QPLEndsWith(BaseFont, ' [Italic]') then
    begin
      BM.Canvas.Font.Style := [fsItalic];
      Delete(BaseFont, Length(BaseFont) - 8, 9);
    end;
    if QPLEndsWith(BaseFont, ' [BoldItalic]') then
    begin
      BM.Canvas.Font.Style := [fsBold, fsItalic];
      Delete(BaseFont, Length(BaseFont) - 12, 13);
    end;

    BM.Canvas.Font.Name := QPLAnsiToNative(BaseFont);
    BM.Canvas.Font.Charset := OriginalCharset;
    BM.Canvas.Font.Size := 750;

{$IFNDEF QPL_OS_WINDOWS}
    ScreenDPI := 96;
    BM.Canvas.Font.Size := Round(72000 / ScreenDPI);
{$ELSE}
    ScreenDC := GetDC(0);
    try
      ScreenDPI := GetDeviceCaps(ScreenDC, LOGPIXELSX);
      if ScreenDPI > 0 then
        BM.Canvas.Font.Size := Round(72000 / ScreenDPI);
    finally
      ReleaseDC(0, ScreenDC);
    end;
{$ENDIF}

{$IFDEF QPL_OS_WINDOWS}
    SetLength(FaceName, 32);
    I := GetTextFace(BM.Canvas.Handle, Length(FaceName), @FaceName[1]);
    SetLength(FaceName, I - 1);

    //BaseFont := AnsiString(FaceName);
    //FFontFamily := BaseFont;

    GetOutlineTextMetricsW(BM.Canvas.Handle, SizeOf(Metrics), @Metrics);

    // Required for EMF Import with ETO_GLYPH_INDEX
    SetLength(GIDCodes, 65536);
    SetLength(S, 65536);
    for I := 1 to Length(S) do
      S[I] := WideChar(I - 1);
    GetGlyphIndicesW(BM.Canvas.Handle, @S[1], Length(S), @GIDCodes[0], GGI_MARK_NONEXISTING_GLYPHS);

    SetLength(FGIDToCID, 65536);   // ADC
    for I := 0 to Length(FGIDToCID) -1 do
      FGIDToCID[I] := 65535;

    for I := 0 to 65535 do
    begin
      if (GIDCodes[I] <= Length(FGIDToCID)) then  // ADC
      begin
        FGIDToCID[GIDCodes[I]] := I;
        if (GIDCodes[I] <> 65535) and (GIDCodes[I] > MaxCID)  then
          MaxCID := GIDCodes[I];
      end;
    end;

    if (MaxCID > -1) then
      SetLength(FGIDToCID, MaxCID);

    SetLength(CIDKeepCodes, Length(SubsetChars));
    if (Length(SubsetChars) > 0) then
    begin
      Move(SubsetChars[1], CIDKeepCodes[0], Length(SubsetChars) * 2);
    end;

    QSortWordArray(CIDKeepCodes);

    LangInfo := GetFontLanguageInfo(BM.Canvas.Handle);
    if (LangInfo and FLI_GLYPHS <> 0) then
    begin
      //LangInfo := LangInfo;
    end;

    // Check for a TrueType Collection
    TTCLen := GetFontData(BM.Canvas.Handle, $66637474, 0, nil, 0);

    Len := GetFontData(BM.Canvas.Handle, 0, 0, nil, 0);
    if (Len > 0) and (Len < $FFFFFFFF) then
    begin
      SetLength(FontDataStr, Len);
      GetFontData(BM.Canvas.Handle, 0, 0, @FontDataStr[1], Len);
      if (TTCLen > 0) and (TTCLen <> GDI_ERROR) then
      begin
        TTCOffset := TTCLen - Len;
        TrueTypeParser := TPDFTrueTypeParser.Create;
        try
          TrueTypeParser.ShiftTableOffsets(FontDataStr, TTCOffset);
        finally
          TrueTypeParser.Free;
        end;
      end;
    end else
    begin
      FontDataStr := '';
    end;
{$ENDIF}

    FontPackageBuffer := nil;
    FontPackageBufferSize := 0;
    BytesWritten := 0;

    CIDRanges := '';
    CIDList := TStringList.Create;
    try
      // Get an entry for each character in the subset
      for MappingIndex := 0 to Length(CIDKeepCodes) - 1 do
      begin
        if Embed = False then
        begin
          CIDList.Add('<' + IntToHex(CIDKeepCodes[MappingIndex], 4) + '> ' +
            '<' + IntToHex(CIDKeepCodes[MappingIndex], 4) + '> ' +
            '<' + IntToHex(CIDKeepCodes[MappingIndex], 4) + '>')
        end
        {
        else if (FOriginalCharSet = SYMBOL_CHARSET) then
          // Map from GID to CID for Symbol fonts only
            CIDList.Add(
            //'<' + IntToHex(GIDCodes[CIDKeepCodes[MappingIndex]], 4) + '> ' +
            //'<' + IntToHex(GIDCodes[CIDKeepCodes[MappingIndex]], 4) + '> ' +
            '<' + IntToHex(CIDKeepCodes[MappingIndex], 4) + '>')
        }
        else
          CIDList.Add(
            '<' + IntToHex(CIDKeepCodes[MappingIndex], 4) + '> ' +
            '<' + IntToHex(CIDKeepCodes[MappingIndex], 4) + '> ' +
            '<' + IntToHex(CIDKeepCodes[MappingIndex], 4) + '>')
      end;

      // Collapse consecutive items into a single
      MappingIndex := 0;
      while (MappingIndex < (CIDList.Count - 1)) do
      begin
        MapA := StrToInt('$' + Copy(CIDList[MappingIndex], 2, 4));
        MapB := StrToInt('$' + Copy(CIDList[MappingIndex], 9, 4));
        MapC := StrToInt('$' + Copy(CIDList[MappingIndex], 16, 4));
        MapD := StrToInt('$' + Copy(CIDList[MappingIndex + 1], 2, 4));
        MapF := StrToInt('$' + Copy(CIDList[MappingIndex + 1], 16, 4));

        if ((MapD = MapB + 1) and (MapF = MapC + MapB - MapA + 1) and
          ((MapB and $FF00) = (MapD and $FF00))) then
        begin
          CIDList[MappingIndex] := Copy(CIDList[MappingIndex], 1, 8) +
            Copy(CIDList[MappingIndex + 1], 2, 4) +
            Copy(CIDList[MappingIndex], 13, MaxInt);
          CIDList.Delete(MappingIndex + 1);
        end else
        begin
          Inc(MappingIndex, 1);
        end;
      end;

      while (CIDList.Count >= 100) do
      begin
        CIDRanges := CIDRanges + '100 beginbfrange'#10;
        for MappingIndex := 0 to 99 do
        begin
          CIDRanges := CIDRanges + AnsiString(CIDList[0]) + #10;
          CIDList.Delete(0);
        end;
        CIDRanges := CIDRanges + 'endbfrange'#10;
      end;
      if (CIDList.Count > 0) then
      begin
        CIDRanges := CIDRanges + QPLIntToStr(CIDList.Count) + ' beginbfrange'#10;
        for MappingIndex := 0 to CIDList.Count - 1 do
        begin
          CIDRanges := CIDRanges + AnsiString(CIDList[MappingIndex]) + #10;
        end;
        CIDRanges := CIDRanges + 'endbfrange'#10;
      end;
    finally
      CIDList.Free;
    end;

    FEncodingCMap.AddCodespaceRange(0, $FFFF, 2);
    SetLength(WidthsArray, 1);
    SetLength(Target, 2);

    Start := -1;
    LastW := -1;
    S1 := '';
    S2 := '';

    SetLength(Widths, Length(CIDKeepCodes));

    for MappingIndex := 0 to Length(CIDKeepCodes) - 1 do
    begin
      Target[1] := CIDKeepCodes[MappingIndex] and $FF;
      Target[0] := (CIDKeepCodes[MappingIndex] and $FF00) shr 8;
      FEncodingCMap.AddMapping(2, CIDKeepCodes[MappingIndex], Target);
{$IFDEF QPL_OS_WINDOWS}
      GetCharWidth32W(BM.Canvas.Handle, CIDKeepCodes[MappingIndex], CIDKeepCodes[MappingIndex], WidthsArray[0]);
{$ENDIF}
      Widths[MappingIndex] := WidthsArray[0];
    end;

    isSequential := False;
    isSameWidth := False;

    for MappingIndex := 0 to Length(CIDKeepCodes) - 1 do
    begin
      // s1 = from to width
      // s2 = from [ width, width, width .. ]

      if ((not isSequential) and (not isSameWidth)) then // Start a new sequence
      begin
        Start := CIDKeepCodes[MappingIndex];

        S1 := '';
        S2 := QPLIntToStr(CIDKeepCodes[MappingIndex]) + ' [' + QPLIntToStr
          (Widths[MappingIndex]);

        isSequential := True;
        isSameWidth := True;
      end
      else
      begin
        if (MappingIndex < Length(CIDKeepCodes) - 1) then
          if (not isSameWidth) and
            (Widths[MappingIndex] = Widths[MappingIndex + 1]) and
            (LastW <> Widths[MappingIndex]) then
            isSequential := False; // Introduce an artificial break.

        if (CIDKeepCodes[MappingIndex] - 1 = CIDKeepCodes[MappingIndex - 1]) and
          (isSequential) then
          S2 := S2 + ' ' + QPLIntToStr(Widths[MappingIndex])
        else
          isSequential := False;

        if (Widths[MappingIndex] = LastW) and (isSequential) and (isSameWidth)
          then
          S1 := QPLIntToStr(Start) + ' ' + QPLIntToStr(CIDKeepCodes[MappingIndex])
            + ' ' + QPLIntToStr(Widths[MappingIndex]) + ' '
        else
          isSameWidth := False;

        // not sequential and not equal width so output something.
        if (S1 <> '') and (not isSameWidth) then
        begin
          WidthsArrayStr := WidthsArrayStr + S1 + ' ';

          Start := CIDKeepCodes[MappingIndex];
          S1 := '';
          S2 := QPLIntToStr(CIDKeepCodes[MappingIndex]) + ' [' + QPLIntToStr
            (Widths[MappingIndex]);
          isSequential := True;

          if (MappingIndex < Length(CIDKeepCodes) - 1) then
            if (Widths[MappingIndex] = Widths[MappingIndex + 1]) then
              isSameWidth := True;

        end
        else if (not isSequential) and (not isSameWidth) then
        begin
          if (S1 <> '') then
            WidthsArrayStr := WidthsArrayStr + S1
          else
            WidthsArrayStr := WidthsArrayStr + S2 + '] ';

          Start := CIDKeepCodes[MappingIndex];
          S1 := '';
          S2 := QPLIntToStr(CIDKeepCodes[MappingIndex]) + ' [' + QPLIntToStr
            (Widths[MappingIndex]);
          isSequential := True;

          if (MappingIndex < Length(CIDKeepCodes) - 1) then
            if (Widths[MappingIndex] = Widths[MappingIndex + 1]) then
              isSameWidth := True;
        end;

      end;
      LastW := Widths[MappingIndex];
      FWidthLookup.AddWidth(CIDKeepCodes[MappingIndex], Widths[MappingIndex]);
    end;

    // Write out any remaining segments.
    if (S1 <> '') then
      WidthsArrayStr := WidthsArrayStr + S1
    else
      WidthsArrayStr := WidthsArrayStr + S2 + ']';

  finally
    BM.Free;
  end;

  if ((Options = 1) or (Options = 3) or (Options = 5)) then
  begin
    PlatformID := TTFCFP_UNICODE_PLATFORMID;
    PlatformCharset := TTFCFP_DONT_CARE;
  end else
  begin
    PlatformID := TTFCFP_MS_PLATFORMID;

    if (FOriginalCharset = SYMBOL_CHARSET) then
      PlatformCharSet := TTFCFP_SYMBOL_CHAR_SET
    else
      PlatformCharset := TTFCFP_UNICODE_CHAR_SET; // TTFCFP_DONT_CARE;
end;

{$IFDEF QPL_OS_WINDOWS}
  ResultCode := CreateFontPackage(@FontDataStr[1], Length(FontDataStr),
    FontPackageBuffer, FontPackageBufferSize, BytesWritten,
    TTFCFP_FLAGS_SUBSET, 0, TTFCFP_SUBSET, 0, PlatformID,
    PlatformCharset, @CIDKeepCodes[0], Length(CIDKeepCodes),
    @CreateFontPackageAllocate, @CreateFontPackageReallocate, @CreateFontPackageFree,
    nil);
{$ENDIF}

  if (ResultCode = 0) then
  begin
    Result := True;

    // Copy the returned font data into the FontData byte array
    SetLength(FontDataStr, BytesWritten);
    Move(FontPackageBuffer^, FontDataStr[1], BytesWritten);

    // Get the Unicode to glyph ID mapping
    SetLength(CIDToGIDMap, 0);
    TrueTypeParser := TPDFTrueTypeParser.Create;
    try
      TrueTypeParser.LoadFromString(FontDataStr);
      {
      if (PlatformCharSet = TTFCFP_SYMBOL_CHAR_SET) then
        TTCMapIndex := TrueTypeParser.Findcmap(3, 0)   // Symbol
      else
      }
        TTCMapIndex := TrueTypeParser.Findcmap(3, 1);   // Unicode

      if (TTCMapIndex >= 0) then
      begin
        EncodingRecord := TrueTypeParser.Getcmap(TTCMapIndex);

        MaxCode := 0;
        for MappingIndex := 0 to Length(EncodingRecord.Codes) - 1 do
          if (EncodingRecord.Codes[MappingIndex] > MaxCode) then
            MaxCode := EncodingRecord.Codes[MappingIndex];
        SetLength(CIDToGIDMap, MaxCode * 2 + 2);
        for I := 1 to MaxCode * 2 + 2 do
          CIDToGIDMap[I] := #0;

        for MappingIndex := 0 to Length(EncodingRecord.Codes) - 1 do
        begin
          CIDToGIDMap[EncodingRecord.Codes[MappingIndex] * 2 + 1] :=
            AnsiChar((EncodingRecord.GlyfID[MappingIndex] and $FF00) shr 8);
          CIDToGIDMap[EncodingRecord.Codes[MappingIndex] * 2 + 2] :=
            AnsiChar(EncodingRecord.GlyfID[MappingIndex] and $FF);
        end;

      end;
    finally
      TrueTypeParser.Free;
    end;

    if (TTCMapIndex = -1) then  // Fallback code if the CMAP table is not found above.
    begin
      MaxCode := 0;
      for I := 0 to Length(CIDKeepCodes) - 1 do
        if (CIDKeepCodes[I] > MaxCode) then
          MaxCode := CIDKeepCodes[I];

      // Get the Unicode to glyph ID mapping
      SetLength(CIDToGIDMap, (MaxCode+1) * 2);
      for I := 1 to Length(CIDToGIDMap) do
        CIDToGIDMap[I] := Chr(0);

      for I := 0 to Length(CIDKeepCodes) - 1 do
      begin
        CIDToGIDMap[CIDKeepCodes[I] * 2 + 1] := AnsiChar((GIDCodes[CIDKeepCodes[I]] and $FF00) shr 8);
        CIDToGIDMap[CIDKeepCodes[I] * 2 + 2] := AnsiChar(GIDCodes[CIDKeepCodes[I]] and $FF);
      end;
    end;

    if (Update) then
    begin
      Dict := FFontDict;

      ToUnicodeStream := nil;
      Obj := Dict.FindValueByKeyName('ToUnicode');
      if (Obj is TPDFIndRef) then
      begin
        Obj := TPDFIndRef(Obj).Obj;
      end;
      if (Obj is TPDFStream) then
      begin
        ToUnicodeStream := TPDFStream(Obj);
      end;

      DescendantFont := nil;
      CIDToGIDMapStream := nil;
      FontDescriptor := nil;

      Obj := Dict.FindValueByKeyName('DescendantFonts');
      if (Obj is TPDFArray) then
      begin
        if (TPDFArray(Obj).Count = 1) then
        begin
          Obj := TPDFArray(Obj).Item[0];
          if (Obj is TPDFIndRef) then
          begin
            Obj := TPDFIndRef(Obj).Obj;
          end;
          if (Obj is TPDFDictionary) then
          begin
            DescendantFont := TPDFDictionary(Obj);

            Obj := DescendantFont.FindValueByKeyName('CIDToGIDMap');
            if (Obj is TPDFIndRef) then
            begin
              Obj := TPDFIndRef(Obj).Obj;
            end;
            if (Obj is TPDFStream) then
            begin
              CIDToGIDMapStream := TPDFStream(Obj);
            end;

            Obj := DescendantFont.FindValueByKeyName('FontDescriptor');
            if (Obj is TPDFIndRef) then
            begin
              Obj := TPDFIndRef(Obj).Obj;
            end;
            if (Obj is TPDFDictionary) then
            begin
              FontDescriptor := TPDFDictionary(Obj);

              if (Embed) then
              begin
                Obj := FontDescriptor.FindValueByKeyName('FontFile2');
                if (Obj is TPDFIndRef) then
                begin
                  Obj := TPDFIndRef(Obj).Obj;
                end;
                if (Obj is TPDFStream) then
                begin
                  FontStream := TPDFStream(Obj);
                end;
              end;
            end;
          end;
        end;
      end;
    end else
    begin
      Dict := FStructure.NewDictionary;
      FFontDict := Dict;

      ToUnicodeStream := FStructure.NewStream('');
      if Assigned(FStructure.OnNewIndObj) then
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, ToUnicodeStream);
      FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
      Dict.Add('ToUnicode', FIndRef);

      DescendantFont := FStructure.NewDictionary;

      CIDToGIDMapStream := FStructure.NewStream('');
      if Assigned(FStructure.OnNewIndObj) then
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, CIDToGIDMapStream);
      CIDToGIDMapStreamRef := FStructure.NewIndirectRef(ObjNum, GenNum);
      DescendantFont.Add('CIDToGIDMap', CIDToGIDMapStreamRef);

      FontDescriptor := FStructure.NewDictionary;
      if Assigned(FStructure.OnNewIndObj) then
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, FontDescriptor);
      FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
      DescendantFont.Add('FontDescriptor', FIndRef);

      if (Embed) then
      begin
        FontStream := FStructure.NewStream('');
        if Assigned(FStructure.OnNewIndObj) then
          FStructure.OnNewIndObj(Self, ObjNum, GenNum, FontStream);
        FontFile := FStructure.NewIndirectRef(ObjNum, GenNum);
        FontDescriptor.Add('FontFile2', FontFile);
      end;

      if Assigned(FStructure.OnNewIndObj) then
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, DescendantFont);
      FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);
      Dict.Add('DescendantFonts', FStructure.NewArray([FIndRef]));

      if Assigned(FStructure.OnNewIndObj) then
        FStructure.OnNewIndObj(Self, ObjNum, GenNum, Dict);
      FIndRef := FStructure.NewIndirectRef(ObjNum, GenNum);

      Dict.Add('Type', FStructure.NewName('Font'));
      Dict.Add('Subtype', FStructure.NewName('Type0'));
      Dict.Add('Encoding', FStructure.NewName('Identity-H'));
      Dict.Add('BaseFont', FStructure.NewName(FFontName));
    end;

    ToUnicode :=
      '%!PS-Adobe-3.0 Resource-CMap'#13 +
      '/CIDInit /ProcSet findresource begin'#10 +
      '12 dict begin'#10 +
      ''#10 +
      'begincmap'#10 +
      '/CIDSystemInfo 3 dict dup begin'#10 +
      '/Registry (Adobe) def'#10 +
      '/Ordering (Identity) def'#10 +
      '/Supplement 0 def'#10 +
      'end def'#10 +
      ''#10 +
      '/CMapName /Identity-H def'#10 +
      '/CMapType 2 def'#10 +
      ''#10 +
      'WMode 0 def'#10 +
      ''#10 +
      '1 begincodespacerange'#10 +
      '<0000> <FFFF>'#10 +
      'endcodespacerange'#10 +
      CIDRanges +
      #10'endcmap'#10 +
      'CMapName currentdict /CMap'#10 +
      'defineresource pop'#10 +
      'end'#10 +
      'end';

    if (Assigned(ToUnicodeStream)) then
    begin
      ToUnicodeStream.SetTo(ToUnicode, False);
    end;

    if (Assigned(CIDToGIDMapStream)) then
    begin
      CIDToGIDMapStream.SetTo(CIDToGIDMap, True);
    end;

    if (Assigned(DescendantFont)) then
    begin
      DescendantFont.Add('W', FStructure.Decode('[ ' + WidthsArrayStr + ']'));
    end;

    if (not Update) then
    begin
      with ToUnicodeStream.Dictionary do
      begin
        Add('Type', FStructure.Decode('/CMap'));
        Add('CMapName', FStructure.Decode('/Adobe-Identity-0'));
        Add('CIDSystemInfo', FStructure.Decode('<< /Registry (Adobe) /Ordering (Identity) /Supplement 0 >>'));
        Add('WMode', FStructure.NewNumeric(0));
      end;

      DescendantFont.Add('Type', FStructure.NewName('Font'));
      DescendantFont.Add('Subtype', FStructure.NewName('CIDFontType2'));
      DescendantFont.Add('BaseFont', FStructure.NewName(FFontName));
      DescendantFont.Add('CIDSystemInfo', FStructure.Decode('<< /Registry (Adobe) /Ordering (Identity) /Supplement 0 >>'));
      DescendantFont.Add('DW', FStructure.NewNumeric(1000));

      FontDescriptor.Add('Type', FStructure.NewName('FontDescriptor'));
      FontDescriptor.Add('FontName', FStructure.NewName(FFontName));
      with Metrics do
      begin
        FontDescriptor.Add('FontBBox', FStructure.NewIntArray([otmrcFontBox.Left,
          otmrcFontBox.Bottom, otmrcFontBox.Right, otmrcFontBox.Top]));
{$IFNDEF QPL_CPP}
        FBound := otmrcFontBox;
{$ENDIF}
        Flags := 0;
        if otmTextMetrics.tmCharSet = SYMBOL_CHARSET then
          Flags := Flags + 4 else Flags := Flags + 32;
        if (otmTextMetrics.tmPitchAndFamily and
          TMPF_FIXED_PITCH) = TMPF_FIXED_PITCH then
            Flags := Flags + 1;
        FontDescriptor.Add('Flags', FStructure.NewNumeric(Flags));
        FontDescriptor.Add('MissingWidth', FStructure.NewNumeric(750));
        FontDescriptor.Add('StemV', FStructure.NewNumeric(0));
        FontDescriptor.Add('ItalicAngle', FStructure.NewNumeric(otmItalicAngle));
        FontDescriptor.Add('CapHeight', FStructure.NewNumeric(Metrics.otmAscent));

        FAscent := Metrics.otmAscent;
        FDescent := -Abs(Metrics.otmDescent);

        FAscentTM := Metrics.otmTextMetrics.tmAscent;
        FDescentTM := -Abs(Metrics.otmTextMetrics.tmDescent);
        FInternalLeading := Metrics.otmTextMetrics.tmInternalLeading;
        FExternalLeading := Metrics.otmTextMetrics.tmExternalLeading;
        FHeight := Metrics.otmTextMetrics.tmHeight;
        FAveCharWidth := Metrics.otmTextMetrics.tmAveCharWidth;

        FontDescriptor.Add('Ascent', FStructure.NewNumeric(FAscent));
        FontDescriptor.Add('Descent', FStructure.NewNumeric(FDescent));
        FontDescriptor.Add('MaxWidth', FStructure.NewNumeric(otmTextMetrics.tmMaxCharWidth));
        FontDescriptor.Add('AvgWidth', FStructure.NewNumeric(otmTextMetrics.tmAveCharWidth));
      end;
    end;

    if (Embed and Assigned(FontStream)) then
    begin
      FontStream.SetTo(FontDataStr, True);
      FontStream.Dictionary.Add('Filter', FStructure.NewCommonName('FlateDecode'));
      FontStream.Dictionary.Add('Length1', FStructure.NewNumeric(Length(FontDataStr)));
    end;
  end;

  // Free the memory allocated by the CreateFontPackage function
  if (FontPackageBufferSize > 0) then
  begin
    FreeMem(FontPackageBuffer, FontPackageBufferSize);
  end;

  if (FCanUpdate) then
    AddToSubset(SubsetChars);

end;

{ TQuickPDFWidthLookup }

procedure TQuickPDFWidthLookup.AddWidth(CharacterCode: Word; Width: Integer);
begin
  FSorted := False;
  if (Length(FCharacterCodes) = FCodeCount) then
  begin
    SetLength(FCharacterCodes, Length(FCharacterCodes) + 1024);
    SetLength(FWidths, Length(FCharacterCodes));
  end;
  FCharacterCodes[FCodeCount] := CharacterCode;
  FWidths[FCodeCount] := Width;
  Inc(FCodeCount);
end;

procedure TPDFFont.AddToSubset(S: WideString; UpdateWidths: Boolean = true);
var
  X: Integer;
  Bytepos, Bitpos: Integer;
begin
  if (CanUpdate) then
  begin
    NeedsUpdate := False;

    for X := 1 to Length(S) do
    begin
      Bytepos := Ord(S[X]) div 8;
      Bitpos := Ord(S[X]) mod 8;

      if (FCharsUsed[BytePos] and ($01 shl Bitpos) = 0) then
        NeedsUpdate := True;

      FCharsUsed[Bytepos] := FCharsUsed[BytePos] or ($01 shl Bitpos);
    end;

    if NeedsUpdate and UpdateWidths then
      UpdateSubsettedFont(false);  // Update the widths.
  end;
end;

constructor TQuickPDFWidthLookup.Create;
begin
  FCodeCount := 0;
  FSorted := False;
  SetLength(FCharacterCodes, 0);
  SetLength(FWidths, 0);
end;

function TQuickPDFWidthLookup.GetWidth(CharacterCode: Word): Integer;
var
  Min, Max: Integer;
  Mid: Integer;
begin
  if (not FSorted) then
  begin
    SortList;
  end;
  Min := 0;
  Max := Length(FCharacterCodes);
  while (Min < Max) do
  begin
    Mid := Min + ((Max - Min) div 2);
    if (FCharacterCodes[Mid] < CharacterCode) then
    begin
      Min := Mid + 1;
    end else
    begin
      Max := Mid;
    end;
  end;
  if ((Min < Length(FCharacterCodes)) and (FCharacterCodes[Min] = CharacterCode)) then
  begin
    Result := FWidths[Min];
  end else
  begin
    Result := 0;
  end;
end;

procedure TQuickPDFWidthLookup.SortList;
var
  NewLength: Integer;
  I, J, K: Integer;
  Temp: Integer;
begin
  SetLength(FCharacterCodes, FCodeCount);
  SetLength(FWidths, FCodeCount);

  FSorted := True;
  NewLength := Length(FCharacterCodes);

  K := (NewLength - 1) shr 1;
  while K > 0 do
  begin
    for I := 0 to (NewLength - 1) - K do
    begin
      J := I;
      while (J >= 0) and (FCharacterCodes[J] > FCharacterCodes[J + K]) do
      begin
        Temp := FCharacterCodes[J];
        FCharacterCodes[J] := FCharacterCodes[J + K];
        FCharacterCodes[J + K] := Temp;

        Temp := FWidths[J];
        FWidths[J] := FWidths[J + K];
        FWidths[J + K] := Temp;

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

function IsOpenType(Stream: TStream): Boolean;
var
  TTP: TPDFTrueTypeParser;
begin
  TTP := TPDFTrueTypeParser.Create;
  try
    Stream.Seek(0, soFromBeginning);
    TTP.LoadTablesFromStream(Stream);
    Result := TTP.GetCFFDataPosition > 0;
  finally
    TTP.Free;
  end;
end;

end.
