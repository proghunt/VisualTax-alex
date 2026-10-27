{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryJBIG2.pas                              }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryJBIG2;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  Classes;

type
  TJBIG2ByteArray = array of Byte;

  TQPLJBIG2Decoder = class
  private
    FScanlines: array of TJBIG2ByteArray;
    FWidth: Integer;
    FHeight: Integer;
  public
    constructor Create;
    function LoadFromByteArray(ImageData, GlobalData: TJBIG2ByteArray): Boolean; overload;
    function LoadFromByteArray(ImageData: TJBIG2ByteArray): Boolean; overload;    
    function GetScanline(Row: Integer; var Data: TJBIG2ByteArray): Boolean;
    property Width: Integer read FWidth;
    property Height: Integer read FHeight;
  end;

implementation

uses
  Math;

const
  LEFT_SHIFT: Integer = 0;
  RIGHT_SHIFT: Integer = 1;
  JBIG2_MMR = 'MMR';
  JBIG2_GB_TEMPLATE = 'GB_TEMPLATE';
  JBIG2_TPGDON = 'TPGDON';
  JBIG2_H_MMR = 'H_MMR';
  JBIG2_H_TEMPLATE = 'H_TEMPLATE';
  JBIG2_H_ENABLE_SKIP = 'H_ENABLE_SKIP';
  JBIG2_H_COMB_OP = 'H_COMB_OP';
  JBIG2_H_DEF_PIXEL = 'H_DEF_PIXEL';
  jbig2HuffmanLOW = $fffffffd;
  jbig2HuffmanOOB = $fffffffe;
  jbig2HuffmanEOT = $ffffffff;
  twoDimensionalPass = 0;
  twoDimensionalHorizontal = 1;
  twoDimensionalVertical0 = 2;
  twoDimensionalVerticalR1 = 3;
  twoDimensionalVerticalL1 = 4;
  twoDimensionalVerticalR2 = 5;
  twoDimensionalVerticalL2 = 6;
  twoDimensionalVerticalR3 = 7;
  twoDimensionalVerticalL3 = 8;
  JBIG2_DEFAULT_PIXEL_VALUE = 'DEFAULT_PIXEL_VALUE';
  JBIG2_DEFAULT_COMBINATION_OPERATOR = 'DEFAULT_COMBINATION_OPERATOR';
  JBIG2_HD_MMR = 'HD_MMR';
  JBIG2_HD_TEMPLATE = 'HD_TEMPLATE';
  JBIG2_GR_TEMPLATE = 'GR_TEMPLATE';
  //JBIG2_TPGDON = 'TPGDON';
  JBIG2_EXTERNAL_COMBINATION_OPERATOR = 'EXTERNAL_COMBINATION_OPERATOR';
  JBIG2_SYMBOL_DICTIONARY = 0;
  JBIG2_INTERMEDIATE_TEXT_REGION = 4;
  JBIG2_IMMEDIATE_TEXT_REGION = 6;
  JBIG2_IMMEDIATE_LOSSLESS_TEXT_REGION = 7;
  JBIG2_PATTERN_DICTIONARY = 16;
  JBIG2_INTERMEDIATE_HALFTONE_REGION = 20;
  JBIG2_IMMEDIATE_HALFTONE_REGION = 22;
  JBIG2_IMMEDIATE_LOSSLESS_HALFTONE_REGION = 23;
  JBIG2_INTERMEDIATE_GENERIC_REGION = 36;
  JBIG2_IMMEDIATE_GENERIC_REGION = 38;
  JBIG2_IMMEDIATE_LOSSLESS_GENERIC_REGION = 39;
  JBIG2_INTERMEDIATE_GENERIC_REFINEMENT_REGION = 40;
  JBIG2_IMMEDIATE_GENERIC_REFINEMENT_REGION = 42;
  JBIG2_IMMEDIATE_LOSSLESS_GENERIC_REFINEMENT_REGION = 43;
  JBIG2_PAGE_INFORMATION = 48;
  JBIG2_END_OF_PAGE = 49;
  JBIG2_END_OF_STRIPE = 50;
  JBIG2_END_OF_FILE = 51;
  JBIG2_PROFILES = 52;
  JBIG2_TABLES = 53;
  JBIG2_EXTENSION = 62;
  JBIG2_BITMAP = 70;
  JBIG2_SD_HUFF = 'SD_HUFF';
  JBIG2_SD_REF_AGG = 'SD_REF_AGG';
  JBIG2_SD_HUFF_DH = 'SD_HUFF_DH';
  JBIG2_SD_HUFF_DW = 'SD_HUFF_DW';
  JBIG2_SD_HUFF_BM_SIZE = 'SD_HUFF_BM_SIZE';
  JBIG2_SD_HUFF_AGG_INST = 'SD_HUFF_AGG_INST';
  JBIG2_BITMAP_CC_USED = 'BITMAP_CC_USED';
  JBIG2_BITMAP_CC_RETAINED = 'BITMAP_CC_RETAINED';
  JBIG2_SD_TEMPLATE = 'SD_TEMPLATE';
  JBIG2_SD_R_TEMPLATE = 'SD_R_TEMPLATE';
  JBIG2_SB_HUFF = 'SB_HUFF';
  JBIG2_SB_REFINE = 'SB_REFINE';
  JBIG2_LOG_SB_STRIPES = 'LOG_SB_STRIPES';
  JBIG2_REF_CORNER = 'REF_CORNER';
  JBIG2_TRANSPOSED = 'TRANSPOSED';
  JBIG2_SB_COMB_OP = 'SB_COMB_OP';
  JBIG2_SB_DEF_PIXEL = 'SB_DEF_PIXEL';
  JBIG2_SB_DS_OFFSET = 'SB_DS_OFFSET';
  JBIG2_SB_R_TEMPLATE = 'SB_R_TEMPLATE';
  JBIG2_SB_HUFF_FS = 'SB_HUFF_FS';
  JBIG2_SB_HUFF_DS = 'SB_HUFF_DS';
  JBIG2_SB_HUFF_DT = 'SB_HUFF_DT';
  JBIG2_SB_HUFF_RDW = 'SB_HUFF_RDW';
  JBIG2_SB_HUFF_RDH = 'SB_HUFF_RDH';
  JBIG2_SB_HUFF_RDX = 'SB_HUFF_RDX';
  JBIG2_SB_HUFF_RDY = 'SB_HUFF_RDY';
  JBIG2_SB_HUFF_RSIZE = 'SB_HUFF_RSIZE';

type
  TJBIG2List = class(TList);
  TJBIG2StringList = class(TStringList);
  TJBIG2SmallintArray = array of Smallint;
  TJBIG2IntegerArray = array of Integer;
  TJBIG2Integer2DArray = array of TJBIG2IntegerArray;

function bit8Shift(number, shift, direction: Integer): Integer;
var
  mask: Integer;
begin
  if (direction = LEFT_SHIFT) then
  begin
    number := number shl shift;
  end else
  begin
    number := number shr shift;
  end;

  mask := $ff;
  Result := (number and mask);
end;

function getInt32(number: TJBIG2SmallintArray): Integer; overload;
begin
  Result := (number[0] shl 24) or (number[1] shl 16) or (number[2] shl 8) or number[3];
end;

function getInt16(number: TJBIG2SmallintArray): Integer;
begin
  Result := (number[0] shl 8) or number[1];
end;

function getInt32(number: TJBIG2ByteArray): Integer; overload;
begin
  Result := (number[0] shl 24) or (number[1] shl 16) or (number[2] shl 8) or number[3];
end;

function bit32Shift(number: Int64; shift, direction: Integer): Int64;
var
  mask: Int64;
begin
  if (direction = LEFT_SHIFT) then
  begin
    number := number shl shift;
  end else
  begin
    number := number shr shift;
  end;

  mask := $ffffffff;
  Result := (number and mask);
end;

type
  TStreamReader = class
  private
    data: TJBIG2ByteArray;
    bitPointer: Integer;
    bytePointer: Integer;
    BufferOverrun: Boolean;
  public
    constructor Create(data: TJBIG2ByteArray);
    function readByte: Smallint; overload;
    function readBit: Integer;
    procedure movePointer(amount: Integer);
    function readBits(num: Integer): Integer;
    procedure consumeRemainingBits;
    procedure readByte(buf: TJBIG2SmallintArray); overload;
    function isFinished: Boolean;
  end;

  TDecodeIntResult = record
    intResult: Integer;
    booleanResult: Boolean;
  end;

  TArithmeticDecoderStats = class
  private
    contextSize: Integer;
  protected
    codingContextTable: TJBIG2IntegerArray;
  public
    function getContextCodingTableValue(index: Integer): Integer;
    constructor Create(contextSize: Integer);
    procedure reset;
    procedure setContextCodingTableValue(index, value: Integer);
    procedure setEntry(codingContext, i, moreProbableSymbol: Integer);
    function getContextSize: Integer;
    procedure overwrite(stats: TArithmeticDecoderStats);
    function copy: TArithmeticDecoderStats;
  end;

  TArithmeticDecoder = class
  private
    reader: TStreamReader;
    buffer0: Int64;
    buffer1: Int64;
    c: Int64;
    a: Int64;
    previous: Int64;
    counter: Integer;
    procedure readByte;
    function decodeIntBit(stats: TArithmeticDecoderStats): Integer;
  public
    genericRegionStats: TArithmeticDecoderStats;
    refinementRegionStats: TArithmeticDecoderStats;
    iadhStats: TArithmeticDecoderStats;
    iadwStats: TArithmeticDecoderStats;
    iaexStats: TArithmeticDecoderStats;
    iaaiStats: TArithmeticDecoderStats;
    iadtStats: TArithmeticDecoderStats;
    iaitStats: TArithmeticDecoderStats;
    iafsStats: TArithmeticDecoderStats;
    iadsStats: TArithmeticDecoderStats;
    iardxStats: TArithmeticDecoderStats;
    iardyStats: TArithmeticDecoderStats;
    iardwStats: TArithmeticDecoderStats;
    iardhStats: TArithmeticDecoderStats;
    iariStats: TArithmeticDecoderStats;
    iaidStats: TArithmeticDecoderStats;
    constructor Create(reader: TStreamReader);
    destructor Destroy; override;
    function decodeBit(context: Int64; stats: TArithmeticDecoderStats): Integer;
    procedure resetIntStats(symbolCodeLength: Integer);
    procedure resetGenericStats(template: Integer; previousStats: TArithmeticDecoderStats);
    procedure resetRefinementStats(template: Integer; previousStats: TArithmeticDecoderStats);
    procedure start;
    function decodeIAID(codeLen: Integer; stats: TArithmeticDecoderStats): Int64;
    function decodeInt(stats: TArithmeticDecoderStats): TDecodeIntResult;
  end;

  THuffmanTable = record
    val: Integer;
    prefixLen: Cardinal;
    rangeLen: Cardinal;
    prefix: Cardinal;
  end;

  THuffmanTableArray = array of THuffmanTable;

  THuffmanDecoder = class
  private
    reader: TStreamReader;
  public
    constructor Create(reader: TStreamReader);
    function buildTable(table: THuffmanTableArray; length: Integer): THuffmanTableArray;
    function decodeInt(table: THuffmanTableArray): TDecodeIntResult;
    function readBits(num: Integer): Integer;
    function readBit: Integer;
    procedure consumeRemainingBits;
  end;

  TMMRDecoder = class
  private
    bufferLength: Int64;
    buffer: Int64;
    noOfBytesRead: Int64;
    reader: TStreamReader;
  public
    constructor Create(reader: TStreamReader); 
    procedure Initialize;
    procedure reset;
    function get2DCode: Integer;
    function getBlackCode: Integer;
    function getWhiteCode: Integer;
    procedure skipTo(length: Integer);
    function get24Bits: Int64;
  end;

  TJBIG2BitmapFactory = class;

  TJBIG2Bitmap = class
  private
    width: Integer;
    height: Integer;
    line: Integer;
    bitmapNumber: Integer;
    data: array of TJBIG2ByteArray;
    arithmeticDecoder: TArithmeticDecoder;
    huffmanDecoder: THuffmanDecoder;
    mmrDecoder: TMMRDecoder;
    FFactory: TJBIG2BitmapFactory;
    procedure duplicateRow(yDest, ySrc: Integer);
  public
    constructor Create(width, height: Integer; arithmeticDecoder: TArithmeticDecoder; huffmanDecoder: THuffmanDecoder; mmrDecoder: TMMRDecoder; Factory: TJBIG2BitmapFactory);
    procedure readBitmap(useMMR: Boolean; template: Integer; typicalPredictionGenericDecodingOn, useSkip: Boolean; skipBitmap: TJBIG2Bitmap; adaptiveTemplateX, adaptiveTemplateY: TJBIG2SmallintArray; mmrDataLength: Integer);
    function getWidth: Integer;
    function getHeight: Integer;
    function getPixel(col, row: Integer): Integer;
    procedure readGenericRefinementRegion(template: Integer; typicalPredictionGenericRefinementOn: Boolean; referredToBitmap: TJBIG2Bitmap; referenceDX, referenceDY: Integer; adaptiveTemplateX, adaptiveTemplateY: TJBIG2SmallintArray);
    procedure readTextRegion(huffman, symbolRefine: Boolean; noOfSymbolInstances, logStrips, noOfSymbols: Integer; symbolCodeTable: THuffmanTableArray;
      symbolCodeLength: Integer; symbols: array of TJBIG2Bitmap; defaultPixel, combinationOperator: Integer; transposed: Boolean; referenceCorner, sOffset: Integer;
      huffmanFSTable, huffmanDSTable, huffmanDTTable, huffmanRDWTable, huffmanRDHTable, huffmanRDXTable, huffmanRDYTable, huffmanRSizeTable: THuffmanTableArray;
      template: Integer; symbolRegionAdaptiveTemplateX, symbolRegionAdaptiveTemplateY: TJBIG2SmallintArray);
    procedure clear(defPixel: Integer);
    procedure combine(bitmap: TJBIG2Bitmap; x, y: Integer; combOp: Int64);
    function getSlice(x, y, width, height: Integer): TJBIG2Bitmap;
    procedure expand(newHeight, defaultPixel: Integer);
    procedure setBitmapNumber(segmentNumber: Integer);
    function getBitmapNumber: Integer;
    procedure setPixel(col, row, value: Integer); overload;
    function getRow(row: Integer): TJBIG2ByteArray;
  end;

  TJBIG2BitmapArray = array of TJBIG2Bitmap;

  TJBIG2BitmapFactory = class
  private
    BitmapList: TJBIG2List;
  public
    constructor Create;
    destructor Destroy; override;
    function CreateBitmap(width, height: Integer;
      arithmeticDecoder: TArithmeticDecoder; huffmanDecoder: THuffmanDecoder;
      mmrDecoder: TMMRDecoder): TJBIG2Bitmap;
  end;
  
  TBitmapPointer = class
  private
    x: Integer;
    y: Integer;
    width: Integer;
    height: Integer;
    count: Integer;
    bitmap: TJBIG2Bitmap;
  public
    constructor Create(bitmap: TJBIG2Bitmap);
    procedure setPointer(x, y: Integer);
    function NextPixel: Integer;
  end;

  TFlags = class
  protected
    flagsAsInt: Integer;
    flags: TJBIG2StringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure setFlags(flagsAsInt: Integer); virtual; abstract;
    function getFlagValue(const key: string): Integer;
  end;

  TPageInformationFlags = class(TFlags)
  public
    procedure setFlags(flagsAsInt: Integer); override;
  end;

  TGenericRegionFlags = class(TFlags)
  public
    procedure setFlags(flagsAsInt: Integer); override;
  end;

  THalftoneRegionFlags = class(TFlags)
  public
    procedure setFlags(flagsAsInt: Integer); override;
  end;

  TPatternDictionaryFlags = class(TFlags)
  public
    procedure setFlags(flagsAsInt: Integer); override;
  end;

  TRefinementRegionFlags = class(TFlags)
  public
    procedure setFlags(flagsAsInt: Integer); override;
  end;

  TRegionFlags = class(TFlags)
  public
    procedure setFlags(flagsAsInt: Integer); override;
  end;

  TSymbolDictionaryFlags = class(TFlags)
  public
    procedure setFlags(flagsAsInt: Integer); override;
  end;

  TTextRegionFlags = class(TFlags)
  public
    procedure setFlags(flagsAsInt: Integer); override;
  end;

  TTextRegionHuffmanFlags = class(TFlags)
  public
    procedure setFlags(intFlags: Integer); override;
  end;

  TSegmentHeader = class
  private
    segmentNumber: Integer;
    segmentType: Integer;
    pageAssociationSizeSet: Boolean;
    deferredNonRetainSet: Boolean;
    referredToSegmentCount: Integer;
    rententionFlags: TJBIG2SmallintArray;
    referredToSegments: TJBIG2IntegerArray;
    pageAssociation: Integer;
    dataLength: Integer;
  public
    procedure setSegmentNumber(segmentNumber: Integer);
    procedure setSegmentHeaderFlags(segmentHeaderFlags: Smallint);
    procedure setReferredToSegmentCount(referredToSegmentCount: Integer);
    procedure setReferredToSegments(referredToSegments: TJBIG2IntegerArray);
    procedure setRententionFlags(rententionFlags: TJBIG2SmallintArray);
    procedure setSegmentType(segmentType: Integer);
    function getReferredToSegments: TJBIG2IntegerArray;
    function getPageAssociation: Integer;
    function getReferredToSegmentCount: Integer;
    function getRententionFlags: TJBIG2SmallintArray;
    function getSegmentDataLength: Integer;
    function getSegmentNumber: Integer;
    function getSegmentType: Integer;
    function isDeferredNonRetainSet: Boolean;
    function isPageAssociationSizeSet: Boolean;
    procedure setDataLength(dataLength: Integer);
    procedure setPageAssociation(pageAssociation: Integer);
  end;

  TSegment = class;
  TPageInformationSegment = class;

  TJBIG2StreamDecoder = class
  private
    arithmeticDecoder: TArithmeticDecoder;
    huffmanDecoder: THuffmanDecoder;
    mmrDecoder: TMMRDecoder;
    reader: TStreamReader;
    noOfPagesKnown: Boolean;
    randomAccessOrganisation: Boolean;
    noOfPages: Integer;
    segments: TJBIG2List;
    bitmaps: TJBIG2List;
    globalData: TJBIG2ByteArray;
    FBitmapFactory: TJBIG2BitmapFactory;
    procedure resetDecoder;
    function checkHeader: Boolean;
    procedure readSegments;
    procedure setFileHeaderFlags;
    function getNoOfPages: Integer;
    procedure readSegmentHeader(segmentHeader: TSegmentHeader);
    procedure handleSegmentNumber(segmentHeader: TSegmentHeader);
    procedure handleSegmentHeaderFlags(segmentHeader: TSegmentHeader);
    procedure handleSegmentReferredToCountAndRententionFlags(segmentHeader: TSegmentHeader);
    procedure handleReferedToSegmentNumbers(segmentHeader: TSegmentHeader);
    procedure handlePageAssociation(segmentHeader: TSegmentHeader);
    procedure handleSegmentDataLength(segmentHeader: TSegmentHeader);
  public
    constructor Create;
    destructor Destroy; override;
    function getHuffmanDecoder: THuffmanDecoder;
    function getMMRDecoder: TMMRDecoder;
    function getArithmeticDecoder: TArithmeticDecoder;
    function readByte: Smallint; overload;
    procedure readByte(buff: TJBIG2SmallintArray); overload;
    function readBits(num: Integer): Integer;
    function readBit: Integer;
    procedure consumeRemainingBits;
    procedure movePointer(i: Integer);
    procedure setGlobalData(data: TJBIG2ByteArray);
    procedure decodeJBIG2(data: TJBIG2ByteArray);
    function findSegment(segmentNumber: Integer): TSegment;
    function findPageSegment(page: Integer): TPageInformationSegment;
    function getAllSegments: TJBIG2List;
    function getNumberOfPages: Integer;
    function getPageAsJBIG2Bitmap(i: Integer): TJBIG2Bitmap;
    function isNumberOfPagesKnown: Boolean;
    function isRandomAccessOrganisationUsed: Boolean;
    procedure appendBitmap(bitmap: TJBIG2Bitmap);
    function findBitmap(bitmapNumber: Integer): TJBIG2Bitmap;
    property BitmapFactory: TJBIG2BitmapFactory read FBitmapFactory;
  end;

  TSegment = class
  protected
    segmentHeader: TSegmentHeader;
    huffmanDecoder: THuffmanDecoder;
    arithmeticDecoder: TArithmeticDecoder;
    mmrDecoder: TMMRDecoder;
    decoder: TJBIG2StreamDecoder;
    function readATValue: Smallint;
  public
    constructor Create(streamDecoder: TJBIG2StreamDecoder); virtual;
    destructor Destroy; override;
    function getSegmentHeader: TSegmentHeader;
    procedure setSegmentHeader(segmentHeader: TSegmentHeader);
    procedure readSegment; virtual; abstract;
  end;

  TPageInformationSegment = class(TSegment)
  private
    pageBitmapHeight: Integer;
    pageBitmapWidth: Integer;
    yResolution: Integer;
    xResolution: Integer;
    pageInformationFlags: TPageInformationFlags;
    pageStriping: Integer;
    pageBitmap: TJBIG2Bitmap;
  public
    constructor Create(streamDecoder: TJBIG2StreamDecoder); override;
    destructor Destroy; override;
    procedure readSegment; override;
    function getPageInformationFlags: TPageInformationFlags;
    function getPageBitmap: TJBIG2Bitmap;
    function getPageBitmapHeight: Integer;
  end;

  TPatternDictionarySegment = class(TSegment)
  private
    patternDictionaryFlags: TPatternDictionaryFlags;
    width: Integer;
    height: Integer;
    grayMax: Integer;
    bitmaps: TJBIG2BitmapArray;
    size: Integer;
    procedure readPatternDictionaryFlags;
  public
    constructor Create(streamDecoder: TJBIG2StreamDecoder); override;
    destructor Destroy; override;
    procedure readSegment; override;
    function getBitmaps: TJBIG2BitmapArray;
    function getPatternDictionaryFlags: TPatternDictionaryFlags;
    function getSize: Integer;
  end;

  TRegionSegment = class(TSegment)
  protected
    regionBitmapWidth: Integer;
    regionBitmapHeight: Integer;
    regionBitmapXLocation: Integer;
    regionBitmapYLocation: Integer;
    regionFlags: TRegionFlags;
  public
    constructor Create(streamDecoder: TJBIG2StreamDecoder); override;
    destructor Destroy; override;
    procedure readSegment; override;
  end;

  TRefinementRegionSegment = class(TRegionSegment)
  private
    inlineImage: Boolean;
    noOfReferedToSegments: Integer;
    referedToSegments: TJBIG2IntegerArray;
    refinementRegionFlags: TRefinementRegionFlags;
    procedure readGenericRegionFlags;
  public
    constructor Create(streamDecoder: TJBIG2StreamDecoder; inlineImage: Boolean; referedToSegments: TJBIG2IntegerArray; noOfReferedToSegments: Integer); reintroduce;
    destructor Destroy; override;
    procedure readSegment; override;
    function getRefinementRegionFlags: TRefinementRegionFlags;
  end;

  TGenericRegionSegment = class(TRegionSegment)
  private
    genericRegionFlags: TGenericRegionFlags;
    unknownLength: Boolean;
    inlineImage: Boolean;
    procedure readGenericRegionFlags;
  public
    constructor Create(streamDecoder: TJBIG2StreamDecoder; inlineImage: Boolean); reintroduce;
    destructor Destroy; override;
    procedure readSegment; override;
    function getGenericRegionFlags: TGenericRegionFlags;
  end;

  THalftoneRegionSegment = class(TRegionSegment)
  private
    inlineImage: Boolean;
    halftoneRegionFlags: THalftoneRegionFlags;
    procedure readHalftoneRegionFlags;
  public
    constructor Create(streamDecoder: TJBIG2StreamDecoder; inlineImage: Boolean); reintroduce;
    destructor Destroy; override;
    procedure readSegment; override;
  end;

  TSymbolDictionarySegment = class(TSegment)
  private
    noOfExportedSymbols: Integer;
    noOfNewSymbols: Integer;
    symbolDictionaryAdaptiveTemplateX: TJBIG2SmallintArray;
    symbolDictionaryAdaptiveTemplateY: TJBIG2SmallintArray;
    symbolDictionaryRAdaptiveTemplateX: TJBIG2SmallintArray;
    symbolDictionaryRAdaptiveTemplateY: TJBIG2SmallintArray;
    bitmaps: TJBIG2BitmapArray;
    symbolDictionaryFlags: TSymbolDictionaryFlags;
    genericRegionStats: TArithmeticDecoderStats;
    refinementRegionStats: TArithmeticDecoderStats;
    procedure readSymbolDictionaryFlags;
  public
    constructor Create(streamDecoder: TJBIG2StreamDecoder); override;
    destructor Destroy; override;
    procedure readSegment; override;
    function getNoOfExportedSymbols: Integer;
    procedure setNoOfExportedSymbols(noOfExportedSymbols: Integer);
    function getNoOfNewSymbols: Integer;
    procedure setNoOfNewSymbols(noOfNewSymbols: Integer);
    function getBitmaps: TJBIG2BitmapArray;
    function getSymbolDictionaryFlags: TSymbolDictionaryFlags;
    procedure setSymbolDictionaryFlags(symbolDictionaryFlags: TSymbolDictionaryFlags);
    function getGenericRegionStats: TArithmeticDecoderStats;
    procedure setGenericRegionStats(genericRegionStats: TArithmeticDecoderStats);
    procedure setRefinementRegionStats(refinementRegionStats: TArithmeticDecoderStats);
    function getRefinementRegionStats: TArithmeticDecoderStats;
  end;

  TTextRegionSegment = class(TRegionSegment)
  private
    textRegionFlags: TTextRegionFlags;
    textRegionHuffmanFlags: TTextRegionHuffmanFlags;
    noOfSymbolInstances: Integer;
    inlineImage: Boolean;
    symbolRegionAdaptiveTemplateX: TJBIG2SmallintArray;
    symbolRegionAdaptiveTemplateY: TJBIG2SmallintArray;
    procedure readTextRegionFlags;
  public
    constructor Create(streamDecoder: TJBIG2StreamDecoder; inlineImage: Boolean); reintroduce; virtual;
    destructor Destroy; override;
    procedure readSegment; override;
    function getTextRegionFlags: TTextRegionFlags;
    function getTextRegionHuffmanFlags: TTextRegionHuffmanFlags;
  end;

  TEndOfStripeSegment = class(TSegment)
  public
    constructor Create(streamDecoder: TJBIG2StreamDecoder); override;
    procedure readSegment; override;
  end;

  TExtensionSegment = class(TSegment)
  public
    constructor Create(streamDecoder: TJBIG2StreamDecoder); override;
    procedure readSegment; override;
  end;

const
  contextSize: array[0..3] of Integer = (16, 13, 10, 10);
  referredToContextSize: array[0..1] of Integer = (13, 10);
  qeTable: array[0..46] of Integer = ($56010000, $34010000, $18010000,
    $0AC10000, $05210000, $02210000, $56010000, $54010000, $48010000,
    $38010000, $30010000, $24010000, $1C010000, $16010000, $56010000,
    $54010000, $51010000, $48010000, $38010000, $34010000, $30010000,
    $28010000, $24010000, $22010000, $1C010000, $18010000, $16010000,
    $14010000, $12010000, $11010000, $0AC10000, $09C10000, $08A10000,
    $05210000, $04410000, $02A10000, $02210000, $01410000, $01110000,
    $00850000, $00490000, $00250000, $00150000, $00090000, $00050000,
    $00010000, $56010000);

  nmpsTable: array[0..46] of Integer = (1, 2, 3, 4, 5, 38, 7, 8, 9, 10, 11, 12,
    13, 29, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
    32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 45, 46);

  nlpsTable: array[0..46] of Integer = (1, 6, 9, 12, 29, 33, 6, 14, 14, 14, 17,
    18, 20, 21, 14, 14, 15, 16, 17, 18, 19, 19, 20, 21, 22, 23, 24, 25, 26, 27,
    28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 46);

  switchTable: array[0..46] of Integer = (1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
    0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0);


{ TArithmeticDecoder }

constructor TArithmeticDecoder.Create(reader: TStreamReader);
begin
  Self.reader := reader;

  genericRegionStats := TArithmeticDecoderStats.Create(1 shl 1);
  refinementRegionStats := TArithmeticDecoderStats.Create(1 shl 1);

  iadhStats := TArithmeticDecoderStats.Create(1 shl 9);
  iadwStats := TArithmeticDecoderStats.Create(1 shl 9);
  iaexStats := TArithmeticDecoderStats.Create(1 shl 9);
  iaaiStats := TArithmeticDecoderStats.Create(1 shl 9);
  iadtStats := TArithmeticDecoderStats.Create(1 shl 9);
  iaitStats := TArithmeticDecoderStats.Create(1 shl 9);
  iafsStats := TArithmeticDecoderStats.Create(1 shl 9);
  iadsStats := TArithmeticDecoderStats.Create(1 shl 9);
  iardxStats := TArithmeticDecoderStats.Create(1 shl 9);
  iardyStats := TArithmeticDecoderStats.Create(1 shl 9);
  iardwStats := TArithmeticDecoderStats.Create(1 shl 9);
  iardhStats := TArithmeticDecoderStats.Create(1 shl 9);
  iariStats := TArithmeticDecoderStats.Create(1 shl 9);
  iaidStats := TArithmeticDecoderStats.Create(1 shl 1);
end;

function TArithmeticDecoder.decodeBit(context: Int64;
  stats: TArithmeticDecoderStats): Integer;
var
  iCX: Integer;
  mpsCX: Integer;
  qe: Integer;
  bit: Integer;
begin
  iCX := bit8Shift(stats.getContextCodingTableValue(Integer(context)), 1, RIGHT_SHIFT);
  mpsCX := stats.getContextCodingTableValue(Integer(context)) and 1;
  qe := qeTable[iCX];

  Dec(a, qe);

  if (c < a) then
  begin
    if ((a and $80000000) <> 0) then
    begin
      bit := mpsCX;
    end else
    begin
      if (a < qe) then
      begin
        bit := 1 - mpsCX;
        if (switchTable[iCX] <> 0) then
        begin
          stats.setContextCodingTableValue(Integer(context), (nlpsTable[iCX] shl 1) or (1 - mpsCX));
        end else
        begin
          stats.setContextCodingTableValue(Integer(context), (nlpsTable[iCX] shl 1) or mpsCX);
        end;
      end else
      begin
        bit := mpsCX;
        stats.setContextCodingTableValue(Integer(context), (nmpsTable[iCX] shl 1) or mpsCX);
      end;

      repeat
        if (counter = 0) then
        begin
          readByte;
        end;

        a := bit32Shift(a, 1, LEFT_SHIFT);
        c := bit32Shift(c, 1, LEFT_SHIFT);

        Dec(counter);
      until ((a and $80000000) <> 0);
    end;
  end else
  begin
    Dec(c, a);

    if (a < qe) then
    begin
      bit := mpsCX;
      stats.setContextCodingTableValue(Integer(context), (nmpsTable[iCX] shl 1) or mpsCX);
    end else
    begin
      bit := 1 - mpsCX;
      if (switchTable[iCX] <> 0) then
      begin
        stats.setContextCodingTableValue(Integer(context), (nlpsTable[iCX] shl 1) or (1 - mpsCX));
      end else
      begin
        stats.setContextCodingTableValue(Integer(context), (nlpsTable[iCX] shl 1) or mpsCX);
      end;
    end;
    a := qe;

    repeat
      if (counter = 0) then
      begin
        readByte;
      end;

      a := bit32Shift(a, 1, LEFT_SHIFT);
      c := bit32Shift(c, 1, LEFT_SHIFT);

      Dec(counter);
    until ((a and $80000000) <> 0);
  end;

  Result := bit;
end;

function TArithmeticDecoder.decodeIAID(codeLen: Integer;
  stats: TArithmeticDecoderStats): Int64;
var
  i: Integer;
  bit: Integer;
begin
  previous := 1;
  for i := 0 to codeLen - 1 do
  begin
    bit := decodeBit(previous, stats);
    previous := bit32Shift(previous, 1, LEFT_SHIFT) or bit;
  end;
  Result := previous - (1 shl codeLen);
end;

function TArithmeticDecoder.decodeInt(
  stats: TArithmeticDecoderStats): TDecodeIntResult;
var
  value: Int64;
  s: Integer;
  i: Integer;
  decodedInt: Integer;
begin
  previous := 1;
  s := decodeIntBit(stats);
  if (decodeIntBit(stats) <> 0) then
  begin
    if (decodeIntBit(stats) <> 0) then
    begin
      if (decodeIntBit(stats) <> 0) then
      begin
        if (decodeIntBit(stats) <> 0) then
        begin
          if (decodeIntBit(stats) <> 0) then
          begin
            value := 0;
            for i := 0 to 31 do
            begin
              value := bit32Shift(value, 1, LEFT_SHIFT) or decodeIntBit(stats);
            end;
            Inc(value, 4436);
          end else
          begin
            value := 0;
            for i := 0 to 11 do
            begin
              value := bit32Shift(value, 1, LEFT_SHIFT) or decodeIntBit(stats);
            end;
            Inc(value, 340);
          end;
        end else
        begin
          value := 0;
          for i := 0 to 7 do
          begin
            value := bit32Shift(value, 1, LEFT_SHIFT) or decodeIntBit(stats);
          end;
          Inc(value, 84);
        end;
      end else
      begin
        value := 0;
        for i := 0 to 5 do
        begin
          value := bit32Shift(value, 1, LEFT_SHIFT) or decodeIntBit(stats);
        end;
        Inc(value, 20);
      end;
    end else
    begin
      value := decodeIntBit(stats);
      value := bit32Shift(value, 1, LEFT_SHIFT) or decodeIntBit(stats);
      value := bit32Shift(value, 1, LEFT_SHIFT) or decodeIntBit(stats);
      value := bit32Shift(value, 1, LEFT_SHIFT) or decodeIntBit(stats);
      Inc(value, 4);
    end;
  end else
  begin
    value := decodeIntBit(stats);
    value := bit32Shift(value, 1, LEFT_SHIFT) or decodeIntBit(stats);
  end;

  if (s <> 0) then
  begin
    if (value = 0) then
    begin
      Result.intResult := Integer(value);
      Result.booleanResult := False;
      Exit;
    end;
    decodedInt := Integer(-value);
  end else
  begin
    decodedInt := Integer(value);
  end;

  Result.intResult := decodedInt;
  Result.booleanResult := True;
end;

function TArithmeticDecoder.decodeIntBit(
  stats: TArithmeticDecoderStats): Integer;
var
  bit: Integer;
begin
  bit := decodeBit(previous, stats);
  if (previous < $100) then
  begin
    previous := bit32Shift(previous, 1, LEFT_SHIFT) or bit;
  end else
  begin
    previous := (((bit32Shift(previous, 1, LEFT_SHIFT)) or bit) and $1ff) or $100;
  end;
  Result := bit;
end;

destructor TArithmeticDecoder.Destroy;
begin
  genericRegionStats.Free;
  refinementRegionStats.Free;
  iadhStats.Free;
  iadwStats.Free;
  iaexStats.Free;
  iaaiStats.Free;
  iadtStats.Free;
  iaitStats.Free;
  iafsStats.Free;
  iadsStats.Free;
  iardxStats.Free;
  iardyStats.Free;
  iardwStats.Free;
  iardhStats.Free;
  iariStats.Free;
  iaidStats.Free;
  inherited;
end;

procedure TArithmeticDecoder.readByte;
begin
  if (buffer0 = $ff) then
  begin
    if (buffer1 > $8f) then
    begin
      counter := 8;
    end else
    begin
      buffer0 := buffer1;
      buffer1 := reader.readByte;
      c := c + $fe00 - (bit32Shift(buffer0, 9, LEFT_SHIFT));
      counter := 7;
    end;
  end else
  begin
    buffer0 := buffer1;
    buffer1 := reader.readByte;
    c := c + $ff00 - (bit32Shift(buffer0, 8, LEFT_SHIFT));
    counter := 8;
  end;
end;

procedure TArithmeticDecoder.resetGenericStats(template: Integer;
  previousStats: TArithmeticDecoderStats);
var
  size: Integer;
begin
  size := contextSize[template];

  if (Assigned(previousStats) and (previousStats.getContextSize() = size)) then
  begin
    if (genericRegionStats.getContextSize() = size) then
    begin
      genericRegionStats.overwrite(previousStats);
    end else
    begin
      genericRegionStats.Free;
      genericRegionStats := previousStats.copy();
    end;
  end else
  begin
    if (genericRegionStats.getContextSize = size) then
    begin
      genericRegionStats.reset;
    end else
    begin
      genericRegionStats.Free;
      genericRegionStats := TArithmeticDecoderStats.Create(1 shl size);
    end;
  end;
end;

procedure TArithmeticDecoder.resetIntStats(symbolCodeLength: Integer);
begin
  iadhStats.reset;
  iadwStats.reset;
  iaexStats.reset;
  iaaiStats.reset;
  iadtStats.reset;
  iaitStats.reset;
  iafsStats.reset;
  iadsStats.reset;
  iardxStats.reset;
  iardyStats.reset;
  iardwStats.reset;
  iardhStats.reset;
  iariStats.reset;

  if (iaidStats.getContextSize = (1 shl (symbolCodeLength + 1))) then
  begin
    iaidStats.reset;
  end else
  begin
    iaidStats.Free;
    iaidStats := TArithmeticDecoderStats.Create(1 shl (symbolCodeLength + 1));
  end;
end;

procedure TArithmeticDecoder.resetRefinementStats(template: Integer;
  previousStats: TArithmeticDecoderStats);
var
  size: Integer;
begin
  size := referredToContextSize[template];
  if (Assigned(previousStats) and (previousStats.getContextSize() = size)) then
  begin
    if (refinementRegionStats.getContextSize() = size) then
    begin
      refinementRegionStats.overwrite(previousStats);
    end else
    begin
      refinementRegionStats.Free;
      refinementRegionStats := previousStats.copy();
    end;
  end else
  begin
    if (refinementRegionStats.getContextSize() = size) then
    begin
      refinementRegionStats.reset;
    end else
    begin
      refinementRegionStats.Free;
      refinementRegionStats := TArithmeticDecoderStats.Create(1 shl size);
    end;
  end;
end;

procedure TArithmeticDecoder.start;
begin
  buffer0 := reader.readByte;
  buffer1 := reader.readByte;

  c := bit32Shift((buffer0 xor $ff), 16, LEFT_SHIFT);
  readByte;
  c := bit32Shift(c, 7, LEFT_SHIFT);
  Dec(counter, 7);
  a := $80000000;
end;


{ TArithmeticDecoderStats }

function TArithmeticDecoderStats.copy: TArithmeticDecoderStats;
var
  stats: TArithmeticDecoderStats;
begin
  stats := TArithmeticDecoderStats.Create(contextSize);
  stats.overwrite(Self);
  Result := stats;
end;

constructor TArithmeticDecoderStats.Create(contextSize: Integer);
begin
  Self.contextSize := contextSize;
  SetLength(codingContextTable, contextSize);
  reset;
end;

function TArithmeticDecoderStats.getContextCodingTableValue(
  index: Integer): Integer;
begin
  Result := codingContextTable[index];
end;

function TArithmeticDecoderStats.getContextSize: Integer;
begin
  Result := contextSize;
end;

procedure TArithmeticDecoderStats.overwrite(
  stats: TArithmeticDecoderStats);
var
  MaxLen: Integer;
  X: Integer;
begin
  MaxLen := contextSize;
  if (stats.contextSize < MaxLen) then
  begin
    MaxLen := stats.contextSize;
  end;
  for X := 0 to MaxLen - 1 do
  begin
    codingContextTable[X] := stats.codingContextTable[X];
  end;
end;

procedure TArithmeticDecoderStats.reset;
var
  i: Integer;
begin
  for i := 0 to contextSize - 1 do
  begin
    codingContextTable[i] := 0;
  end;
end;

procedure TArithmeticDecoderStats.setContextCodingTableValue(index,
  value: Integer);
begin
  codingContextTable[index] := value;
end;

procedure TArithmeticDecoderStats.setEntry(codingContext, i,
  moreProbableSymbol: Integer);
begin
  codingContextTable[codingContext] := (i shl i) + moreProbableSymbol;
end;

{ TBitmapPointer }

constructor TBitmapPointer.Create(bitmap: TJBIG2Bitmap);
begin
  Self.bitmap := bitmap;
  height := bitmap.getHeight;
  width := bitmap.getWidth;
end;

function TBitmapPointer.NextPixel: Integer;
begin
  if ((y < 0) or (y >= height) or (x >= width)) then
  begin
    Result := 0;
    Exit;
  end else
  if (x < 0) then
  begin
    Inc(x);
    Result := 0;
    Exit;
  end;

  Result := bitmap.getPixel(x, y);
  Inc(x);
end;

procedure TBitmapPointer.setPointer(x, y: Integer);
begin
  Self.x := x;
  Self.y := y;
  count := 0;
end;


{ TEndOfStripeSegment }

constructor TEndOfStripeSegment.Create(streamDecoder: TJBIG2StreamDecoder);
begin
  inherited Create(streamDecoder);
end;

procedure TEndOfStripeSegment.readSegment;
var
  i: Integer;
begin
  for i := 0 to getSegmentHeader.getSegmentDataLength - 1 do
  begin
    decoder.readByte;
  end;
end;


{ TExtensionSegment }

constructor TExtensionSegment.Create(streamDecoder: TJBIG2StreamDecoder);
begin
  inherited Create(streamDecoder);     
end;

procedure TExtensionSegment.readSegment;
var
  i: Integer;
begin
  for i := 0 to getSegmentHeader.getSegmentDataLength - 1 do
  begin
    decoder.readByte;
  end;
end;


{ TFlags }

constructor TFlags.Create;
begin
  flags := TJBIG2StringList.Create;
end;

destructor TFlags.Destroy;
begin
  flags.Free;
  inherited;
end;

function TFlags.getFlagValue(const key: string): Integer;
var
  I: Integer;
begin
  I := flags.IndexOf(key);
  if I >= 0 then
  begin
    Result := Integer(flags.Objects[I]);
  end else
  begin
    Result := 0;
  end;
end;


{ TGenericRegionFlags }

procedure TGenericRegionFlags.setFlags(flagsAsInt: Integer);
begin
  Self.flagsAsInt := flagsAsInt;
  flags.AddObject(JBIG2_MMR, TObject(flagsAsInt and 1));
  flags.AddObject(JBIG2_GB_TEMPLATE, TObject((flagsAsInt shr 1) and 3));
  flags.AddObject(JBIG2_TPGDON, TObject((flagsAsInt shr 3) and 1));
end;


{ TGenericRegionSegment }

constructor TGenericRegionSegment.Create(
  streamDecoder: TJBIG2StreamDecoder; inlineImage: Boolean);
begin
  inherited Create(streamDecoder);
  Self.inlineImage := inlineImage;
  unknownLength := False;
  genericRegionFlags := TGenericRegionFlags.Create;
end;

destructor TGenericRegionSegment.Destroy;
begin
  genericRegionFlags.Free;
  inherited;
end;

function TGenericRegionSegment.getGenericRegionFlags: TGenericRegionFlags;
begin
  Result := genericRegionFlags;
end;

procedure TGenericRegionSegment.readGenericRegionFlags;
var
  genericRegionFlagsField: Smallint;
begin
  genericRegionFlagsField := decoder.readByte;
  genericRegionFlags.setFlags(genericRegionFlagsField);
end;

procedure TGenericRegionSegment.readSegment;
var
  useMMR: Boolean;
  template: Integer;
  genericBAdaptiveTemplateX: TJBIG2SmallintArray;
  genericBAdaptiveTemplateY: TJBIG2SmallintArray;
  typicalPredictionGenericDecodingOn: Boolean;
  length: Integer;
  match1: Smallint;
  match2: Smallint;
  bytesRead: Integer;
  bite1: Smallint;
  bite2: Smallint;
  bitmap: TJBIG2Bitmap;
  mmrDataLength: Integer;
  pageSegment: TPageInformationSegment;
  pageBitmap: TJBIG2Bitmap;
  extCombOp: Integer;
begin
  inherited readSegment;
  readGenericRegionFlags;

  useMMR := genericRegionFlags.getFlagValue(JBIG2_MMR) <> 0;
  template := genericRegionFlags.getFlagValue(JBIG2_GB_TEMPLATE);

  SetLength(genericBAdaptiveTemplateX, 4);
  SetLength(genericBAdaptiveTemplateY, 4);

  if (not useMMR) then
  begin
    if (template = 0) then
    begin
      genericBAdaptiveTemplateX[0] := readATValue;
      genericBAdaptiveTemplateY[0] := readATValue;
      genericBAdaptiveTemplateX[1] := readATValue;
      genericBAdaptiveTemplateY[1] := readATValue;
      genericBAdaptiveTemplateX[2] := readATValue;
      genericBAdaptiveTemplateY[2] := readATValue;
      genericBAdaptiveTemplateX[3] := readATValue;
      genericBAdaptiveTemplateY[3] := readATValue;
    end else
    begin
      genericBAdaptiveTemplateX[0] := readATValue;
      genericBAdaptiveTemplateY[0] := readATValue;
    end;

    arithmeticDecoder.resetGenericStats(template, nil);
    arithmeticDecoder.start;
  end;

  typicalPredictionGenericDecodingOn := genericRegionFlags.getFlagValue(JBIG2_TPGDON) <> 0;
  length := segmentHeader.getSegmentDataLength;

  if (length = -1) then
  begin
    // Length of data is unknown, so it needs to be determined through
    // examination of the data.
    // See 7.2.7 - Segment data length of the JBIG2 specification.

    unknownLength := True;

    if (useMMR) then
    begin
      // look for 0x00 0x00 (0, 0)

      match1 := 0;
      match2 := 0;
    end else
    begin
      // look for 0xFF 0xAC (255, 172)

      match1 := 255;
      match2 := 172;
    end;

    bytesRead := 0;
    while (True) do
    begin
      bite1 := decoder.readByte;
      Inc(bytesRead);

      if (bite1 = match1) then
      begin
        bite2 := decoder.readByte;
        Inc(bytesRead);

        if (bite2 = match2) then
        begin
          length := bytesRead - 2;
          Break;
        end;
      end;
    end;

    decoder.movePointer(-bytesRead);
  end;

  bitmap := decoder.BitmapFactory.CreateBitmap(regionBitmapWidth, regionBitmapHeight, arithmeticDecoder, huffmanDecoder, mmrDecoder);
  bitmap.clear(0);

  if (useMMR) then
  begin
    mmrDataLength := 0;
  end else
  begin
    mmrDataLength := length - 18;
  end;

  bitmap.readBitmap(useMMR, template, typicalPredictionGenericDecodingOn, False, nil, genericBAdaptiveTemplateX, genericBAdaptiveTemplateY, mmrDataLength);

  if (inlineImage) then
  begin
    pageSegment := decoder.findPageSegment(segmentHeader.getPageAssociation);
    pageBitmap := pageSegment.getPageBitmap;

    extCombOp := regionFlags.getFlagValue(JBIG2_EXTERNAL_COMBINATION_OPERATOR);

    if ((pageSegment.getPageBitmapHeight = -1) and (regionBitmapYLocation + regionBitmapHeight > pageBitmap.getHeight)) then
    begin
      pageBitmap.expand(regionBitmapYLocation + regionBitmapHeight,
        pageSegment.getPageInformationFlags.getFlagValue(JBIG2_DEFAULT_PIXEL_VALUE));
    end;

    pageBitmap.combine(bitmap, regionBitmapXLocation, regionBitmapYLocation, extCombOp);
  end else
  begin
    bitmap.setBitmapNumber(getSegmentHeader.getSegmentNumber);
    decoder.appendBitmap(bitmap);
  end;

  if (unknownLength) then
  begin
    decoder.movePointer(4);
  end;
end;


{ THalftoneRegionFlags }

procedure THalftoneRegionFlags.setFlags(flagsAsInt: Integer);
begin
  Self.flagsAsInt := flagsAsInt;
  flags.AddObject(JBIG2_H_MMR, TObject(flagsAsInt and 1));
  flags.AddObject(JBIG2_H_TEMPLATE, TObject((flagsAsInt shr 1) and 3));
  flags.AddObject(JBIG2_H_ENABLE_SKIP, TObject((flagsAsInt shr 3) and 1));
  flags.AddObject(JBIG2_H_COMB_OP, TObject((flagsAsInt shr 4) and 7));
  flags.AddObject(JBIG2_H_DEF_PIXEL, TObject((flagsAsInt shr 7) and 1));
end;

{ THalftoneRegionSegment }

constructor THalftoneRegionSegment.Create(
  streamDecoder: TJBIG2StreamDecoder; inlineImage: Boolean);
begin
  inherited Create(streamDecoder);
  Self.inlineImage := inlineImage;
  halftoneRegionFlags := THalftoneRegionFlags.Create;
end;

destructor THalftoneRegionSegment.Destroy;
begin
  halftoneRegionFlags.Free;
  inherited;
end;

procedure THalftoneRegionSegment.readHalftoneRegionFlags;
var
  halftoneRegionFlagsField: Smallint;
begin
  halftoneRegionFlagsField := decoder.readByte;
  halftoneRegionFlags.setFlags(halftoneRegionFlagsField);
end;

procedure THalftoneRegionSegment.readSegment;
var
  buf: TJBIG2SmallintArray;
  gridWidth: Integer;
  gridHeight: Integer;
  gridX: Integer;
  gridY: Integer;
  stepX: Integer;
  stepY: Integer;
  referedToSegments: TJBIG2IntegerArray;
  segment: TSegment;
  patternDictionarySegment: TPatternDictionarySegment;
  bitsPerValue: Integer;
  i: Integer;
  bitmap: TJBIG2Bitmap;
  patternWidth: Integer;
  patternHeight: Integer;
  useMMR: Boolean;
  template: Integer;
  halftoneDefaultPixel: Integer;
  enableSkip: Boolean;
  skipBitmap: TJBIG2Bitmap;
  grayScaleImage: TJBIG2IntegerArray;
  genericBAdaptiveTemplateX: TJBIG2SmallintArray;
  genericBAdaptiveTemplateY: TJBIG2SmallintArray;
  x: Integer;
  y: Integer;
  row: Integer;
  col: Integer;
  xx: Integer;
  yy: Integer;
  combinationOperator: Integer;
  pageSegment: TPageInformationSegment;
  pageBitmap: TJBIG2Bitmap;
  externalCombinationOperator: Integer;
  j: Integer;
  grayBitmap: TJBIG2Bitmap;
  bit: Integer;
  patternBitmap: TJBIG2Bitmap;
begin
  inherited readSegment;

  // read text region Segment flags
  readHalftoneRegionFlags;

  SetLength(buf, 4);
  decoder.readByte(buf);
  gridWidth := getInt32(buf);

  SetLength(buf, 4);
  decoder.readByte(buf);
  gridHeight := getInt32(buf);

  SetLength(buf, 4);
  decoder.readByte(buf);
  gridX := getInt32(buf);

  SetLength(buf, 4);
  decoder.readByte(buf);
  gridY := getInt32(buf);

  SetLength(buf, 2);
  decoder.readByte(buf);

  stepX := getInt16(buf);

  SetLength(buf, 2);
  decoder.readByte(buf);
  stepY := getInt16(buf);

  referedToSegments := segmentHeader.getReferredToSegments;
  if (Length(referedToSegments) <> 1) then
  begin
    // Error in halftone Segment, refSegs should be 1
  end;

  segment := decoder.findSegment(referedToSegments[0]);
  if (segment.getSegmentHeader.getSegmentType <> JBIG2_PATTERN_DICTIONARY) then
  begin
    // Error in halftone Segment. bad symbol dictionary reference
  end;

  patternDictionarySegment := TPatternDictionarySegment(segment);

  i := 1;
  bitsPerValue := 0;
  while (i < patternDictionarySegment.getSize) do
  begin
    Inc(bitsPerValue);
    i := i shl 1;
  end;

  bitmap := patternDictionarySegment.getBitmaps[0];
  patternWidth := bitmap.getWidth;
  patternHeight := bitmap.getHeight;

  useMMR := halftoneRegionFlags.getFlagValue(JBIG2_H_MMR) <> 0;
  template := halftoneRegionFlags.getFlagValue(JBIG2_H_TEMPLATE);

  if (not useMMR) then
  begin
    arithmeticDecoder.resetGenericStats(template, nil);
    arithmeticDecoder.start;
  end;

  halftoneDefaultPixel := halftoneRegionFlags.getFlagValue(JBIG2_H_DEF_PIXEL);
  bitmap := decoder.BitmapFactory.CreateBitmap(regionBitmapWidth, regionBitmapHeight, arithmeticDecoder, huffmanDecoder, mmrDecoder);
  bitmap.clear(halftoneDefaultPixel);

  enableSkip := halftoneRegionFlags.getFlagValue(JBIG2_H_ENABLE_SKIP) <> 0;

  skipBitmap := nil;
  if (enableSkip) then
  begin
    skipBitmap := decoder.BitmapFactory.CreateBitmap(gridWidth, gridHeight, arithmeticDecoder, huffmanDecoder, mmrDecoder);
    skipBitmap.clear(0);
    for y := 0 to gridHeight - 1 do
    begin
      for x := 0 to gridWidth - 1 do
      begin
        xx := gridX + (y * stepY) + (x * stepX);
        yy := gridY + (y * stepX) - (x * stepY);

        if ((((xx + patternWidth) shr 8) <= 0) or ((xx shr 8) >= regionBitmapWidth) or (((yy + patternHeight) shr 8) <= 0) or ((yy shr 8) >= regionBitmapHeight)) then
        begin
          skipBitmap.setPixel(y, x, 1);
        end;
      end;
    end;
  end;

  SetLength(grayScaleImage, gridWidth * gridHeight);

  SetLength(genericBAdaptiveTemplateX, 4);
  SetLength(genericBAdaptiveTemplateY, 4);

  if (template <= 1) then
  begin
    genericBAdaptiveTemplateX[0] := 3;
  end else
  begin
    genericBAdaptiveTemplateX[0] := 2;
  end;
  genericBAdaptiveTemplateY[0] := -1;
  genericBAdaptiveTemplateX[1] := -3;
  genericBAdaptiveTemplateY[1] := -1;
  genericBAdaptiveTemplateX[2] := 2;
  genericBAdaptiveTemplateY[2] := -2;
  genericBAdaptiveTemplateX[3] := -2;
  genericBAdaptiveTemplateY[3] := -2;

  for j := bitsPerValue - 1 downto 0 do
  begin
    grayBitmap := decoder.BitmapFactory.CreateBitmap(gridWidth, gridHeight, arithmeticDecoder, huffmanDecoder, mmrDecoder);

    grayBitmap.readBitmap(useMMR, template, False, enableSkip, skipBitmap, genericBAdaptiveTemplateX, genericBAdaptiveTemplateY, -1);

    i := 0;
    for row := 0 to gridHeight - 1 do
    begin
      for col := 0 to gridWidth - 1 do
      begin
        bit := grayBitmap.getPixel(col, row) xor (grayScaleImage[i] and 1);
        grayScaleImage[i] := (grayScaleImage[i] shl 1) or bit;
        Inc(i);
      end;
    end;
  end;

  combinationOperator := halftoneRegionFlags.getFlagValue(JBIG2_H_COMB_OP);

  i := 0;
  for col := 0 to gridHeight - 1 do
  begin
    xx := gridX + (col * stepY);
    yy := gridY + (col * stepX);
    for row := 0 to gridWidth - 1 do
    begin
      if (not (enableSkip and (skipBitmap.getPixel(col, row) = 1))) then
      begin
        patternBitmap := patternDictionarySegment.getBitmaps[grayScaleImage[i]];
        bitmap.combine(patternBitmap, xx shr 8, yy shr 8, combinationOperator);
      end;

      Inc(xx, stepX);
      Inc(yy, stepY);

      Inc(i);
    end;
  end;

  if (inlineImage) then
  begin
    pageSegment := decoder.findPageSegment(segmentHeader.getPageAssociation);
    pageBitmap := pageSegment.getPageBitmap;

    externalCombinationOperator := regionFlags.getFlagValue(JBIG2_EXTERNAL_COMBINATION_OPERATOR);
    pageBitmap.combine(bitmap, regionBitmapXLocation, regionBitmapYLocation, externalCombinationOperator);
  end else
  begin
    bitmap.setBitmapNumber(getSegmentHeader.getSegmentNumber);
    decoder.appendBitmap(bitmap);
  end;
end;


const
  huffmanTableA: array[0..4, 0..3] of Int64 = ((0, 1, 4, $000),
    (16, 2, 8, $002), (272, 3, 16, $006), (65808, 3, 32, $007),
    (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableB: array[0..7, 0..3] of Int64 = ((0, 1, 0, $000),
    (1, 2, 0, $002), (2, 3, 0, $006), (3, 4, 3, $00e), (11, 5, 6, $01e),
    (75, 6, 32, $03e), (0, 6, jbig2HuffmanOOB, $03f),
    (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableC: array[0..9, 0..3] of Int64 = ((0, 1, 0, $000),
    (1, 2, 0, $002), (2, 3, 0, $006), (3, 4, 3, $00e), (11, 5, 6, $01e),
    (0, 6, jbig2HuffmanOOB, $03e), (75, 7, 32, $0fe), (-256, 8, 8, $0fe),
    (-257, 8, jbig2HuffmanLOW, $0ff), (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableD: array[0..6, 0..3] of Int64 = ((1, 1, 0, $000),
    (2, 2, 0, $002), (3, 3, 0, $006), (4, 4, 3, $00e), (12, 5, 6, $01e),
    (76, 5, 32, $01f), (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableE: array[0..8, 0..3] of Int64 = ((1, 1, 0, $000),
    (2, 2, 0, $002), (3, 3, 0, $006), (4, 4, 3, $00e), (12, 5, 6, $01e),
    (76, 6, 32, $03e), (-255, 7, 8, $07e), (-256, 7, jbig2HuffmanLOW, $07f),
    (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableF: array[0..14, 0..3] of Int64 = ((0, 2, 7, $000),
    (128, 3, 7, $002), (256, 3, 8, $003), (-1024, 4, 9, $008),
    (-512, 4, 8, $009), (-256, 4, 7, $00a), (-32, 4, 5, $00b),
    (512, 4, 9, $00c), (1024, 4, 10, $00d), (-2048, 5, 10, $01c),
    (-128, 5, 6, $01d), (-64, 5, 5, $01e), (-2049, 6, jbig2HuffmanLOW, $03e),
    (2048, 6, 32, $03f), (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableG: array[0..15, 0..3] of Int64 = ((-512, 3, 8, $000),
    (256, 3, 8, $001), (512, 3, 9, $002), (1024, 3, 10, $003),
    (-1024, 4, 9, $008), (-256, 4, 7, $009), (-32, 4, 5, $00a),
    (0, 4, 5, $00b), (128, 4, 7, $00c), (-128, 5, 6, $01a), (-64, 5, 5, $01b),
    (32, 5, 5, $01c), (64, 5, 6, $01d), (-1025, 5, jbig2HuffmanLOW, $01e),
    (2048, 5, 32, $01f), (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableH: array[0..21, 0..3] of Int64 = ((0, 2, 1, $000),
    (0, 2, jbig2HuffmanOOB, $001), (4, 3, 4, $004), (-1, 4, 0, $00a),
    (22, 4, 4, $00b), (38, 4, 5, $00c), (2, 5, 0, $01a), (70, 5, 6, $01b),
    (134, 5, 7, $01c), (3, 6, 0, $03a), (20, 6, 1, $03b), (262, 6, 7, $03c),
    (646, 6, 10, $03d), (-2, 7, 0, $07c), (390, 7, 8, $07d), (-15, 8, 3, $0fc),
    (-5, 8, 1, $0fd), (-7, 9, 1, $1fc), (-3, 9, 0, $1fd),
    (-16, 9, jbig2HuffmanLOW, $1fe), (1670, 9, 32, $1ff),
    (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableI: array[0..22, 0..3] of Int64 = ((0, 2, jbig2HuffmanOOB, $000),
    (-1, 3, 1, $002), (1, 3, 1, $003), (7, 3, 5, $004), (-3, 4, 1, $00a),
    (43, 4, 5, $00b), (75, 4, 6, $00c), (3, 5, 1, $01a), (139, 5, 7, $01b),
    (267, 5, 8, $01c), (5, 6, 1, $03a), (39, 6, 2, $03b), (523, 6, 8, $03c),
    (1291, 6, 11, $03d), (-5, 7, 1, $07c), (779, 7, 9, $07d),
    (-31, 8, 4, $0fc), (-11, 8, 2, $0fd), (-15, 9, 2, $1fc),
    (-7, 9, 1, $1fd), (-32, 9, jbig2HuffmanLOW, $1fe), (3339, 9, 32, $1ff),
    (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableJ: array[0..21, 0..3] of Int64 = ((-2, 2, 2, $000),
    (6, 2, 6, $001), (0, 2, jbig2HuffmanOOB, $002), (-3, 5, 0, $018),
    (2, 5, 0, $019), (70, 5, 5, $01a), (3, 6, 0, $036), (102, 6, 5, $037),
    (134, 6, 6, $038), (198, 6, 7, $039), (326, 6, 8, $03a), (582, 6, 9, $03b),
    (1094, 6, 10, $03c), (-21, 7, 4, $07a), (-4, 7, 0, $07b),
    (4, 7, 0, $07c), (2118, 7, 11, $07d), (-5, 8, 0, $0fc), (5, 8, 0, $0fd),
    (-22, 8, jbig2HuffmanLOW, $0fe), (4166, 8, 32, $0ff),
    (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableK: array[0..13, 0..3] of Int64 = ((1, 1, 0, $000),
    (2, 2, 1, $002), (4, 4, 0, $00c), (5, 4, 1, $00d), (7, 5, 1, $01c),
    (9, 5, 2, $01d), (13, 6, 2, $03c), (17, 7, 2, $07a), (21, 7, 3, $07b),
    (29, 7, 4, $07c), (45, 7, 5, $07d), (77, 7, 6, $07e), (141, 7, 32, $07f),
    (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableL: array[0..13, 0..3] of Int64 = ((1, 1, 0, $000),
    (2, 2, 0, $002), (3, 3, 1, $006), (5, 5, 0, $01c), (6, 5, 1, $01d),
    (8, 6, 1, $03c), (10, 7, 0, $07a), (11, 7, 1, $07b), (13, 7, 2, $07c),
    (17, 7, 3, $07d), (25, 7, 4, $07e), (41, 8, 5, $0fe), (73, 8, 32, $0ff),
    (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableM: array[0..13, 0..3] of Int64 = ((1, 1, 0, $000),
    (2, 3, 0, $004), (7, 3, 3, $005), (3, 4, 0, $00c), (5, 4, 1, $00d),
    (4, 5, 0, $01c), (15, 6, 1, $03a), (17, 6, 2, $03b), (21, 6, 3, $03c),
    (29, 6, 4, $03d), (45, 6, 5, $03e), (77, 7, 6, $07e), (141, 7, 32, $07f),
    (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableN: array[0..5, 0..3] of Int64 = ((0, 1, 0, $000),
    (-2, 3, 0, $004), (-1, 3, 0, $005), (1, 3, 0, $006), (2, 3, 0, $007),
    (0, 0, jbig2HuffmanEOT, 0));

  huffmanTableO: array[0..13, 0..3] of Int64 = ((0, 1, 0, $000),
    (-1, 3, 0, $004), (1, 3, 0, $005), (-2, 4, 0, $00c), (2, 4, 0, $00d),
    (-4, 5, 1, $01c), (3, 5, 1, $01d), (-8, 6, 2, $03c), (5, 6, 2, $03d),
    (-24, 7, 4, $07c), (9, 7, 4, $07d), (-25, 7, jbig2HuffmanLOW, $07e),
    (25, 7, 32, $07f), (0, 0, jbig2HuffmanEOT, 0));

function GetHuffmanTableA: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableA));
  for X := 0 to Length(huffmanTableA) - 1 do
  begin
    Result[X].val := huffmanTableA[X][0];
    Result[X].prefixLen := huffmanTableA[X][1];
    Result[X].rangeLen := huffmanTableA[X][2];
    Result[X].prefix := huffmanTableA[X][3];
  end;
end;

function GetHuffmanTableB: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableB));
  for X := 0 to Length(huffmanTableB) - 1 do
  begin
    Result[X].val := huffmanTableB[X][0];
    Result[X].prefixLen := huffmanTableB[X][1];
    Result[X].rangeLen := huffmanTableB[X][2];
    Result[X].prefix := huffmanTableB[X][3];
  end;
end;

function GetHuffmanTableC: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableC));
  for X := 0 to Length(huffmanTableC) - 1 do
  begin
    Result[X].val := huffmanTableC[X][0];
    Result[X].prefixLen := huffmanTableC[X][1];
    Result[X].rangeLen := huffmanTableC[X][2];
    Result[X].prefix := huffmanTableC[X][3];
  end;
end;

function GetHuffmanTableD: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableD));
  for X := 0 to Length(huffmanTableD) - 1 do
  begin
    Result[X].val := huffmanTableD[X][0];
    Result[X].prefixLen := huffmanTableD[X][1];
    Result[X].rangeLen := huffmanTableD[X][2];
    Result[X].prefix := huffmanTableD[X][3];
  end;
end;

function GetHuffmanTableE: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableE));
  for X := 0 to Length(huffmanTableE) - 1 do
  begin
    Result[X].val := huffmanTableE[X][0];
    Result[X].prefixLen := huffmanTableE[X][1];
    Result[X].rangeLen := huffmanTableE[X][2];
    Result[X].prefix := huffmanTableE[X][3];
  end;
end;

function GetHuffmanTableF: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableF));
  for X := 0 to Length(huffmanTableF) - 1 do
  begin
    Result[X].val := huffmanTableF[X][0];
    Result[X].prefixLen := huffmanTableF[X][1];
    Result[X].rangeLen := huffmanTableF[X][2];
    Result[X].prefix := huffmanTableF[X][3];
  end;
end;

function GetHuffmanTableG: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableG));
  for X := 0 to Length(huffmanTableG) - 1 do
  begin
    Result[X].val := huffmanTableG[X][0];
    Result[X].prefixLen := huffmanTableG[X][1];
    Result[X].rangeLen := huffmanTableG[X][2];
    Result[X].prefix := huffmanTableG[X][3];
  end;
end;

function GetHuffmanTableH: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableH));
  for X := 0 to Length(huffmanTableH) - 1 do
  begin
    Result[X].val := huffmanTableH[X][0];
    Result[X].prefixLen := huffmanTableH[X][1];
    Result[X].rangeLen := huffmanTableH[X][2];
    Result[X].prefix := huffmanTableH[X][3];
  end;
end;

function GetHuffmanTableI: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableI));
  for X := 0 to Length(huffmanTableI) - 1 do
  begin
    Result[X].val := huffmanTableI[X][0];
    Result[X].prefixLen := huffmanTableI[X][1];
    Result[X].rangeLen := huffmanTableI[X][2];
    Result[X].prefix := huffmanTableI[X][3];
  end;
end;

function GetHuffmanTableJ: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableJ));
  for X := 0 to Length(huffmanTableJ) - 1 do
  begin
    Result[X].val := huffmanTableJ[X][0];
    Result[X].prefixLen := huffmanTableJ[X][1];
    Result[X].rangeLen := huffmanTableJ[X][2];
    Result[X].prefix := huffmanTableJ[X][3];
  end;
end;

function GetHuffmanTableK: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableK));
  for X := 0 to Length(huffmanTableK) - 1 do
  begin
    Result[X].val := huffmanTableK[X][0];
    Result[X].prefixLen := huffmanTableK[X][1];
    Result[X].rangeLen := huffmanTableK[X][2];
    Result[X].prefix := huffmanTableK[X][3];
  end;
end;

function GetHuffmanTableL: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableL));
  for X := 0 to Length(huffmanTableL) - 1 do
  begin
    Result[X].val := huffmanTableL[X][0];
    Result[X].prefixLen := huffmanTableL[X][1];
    Result[X].rangeLen := huffmanTableL[X][2];
    Result[X].prefix := huffmanTableL[X][3];
  end;
end;

function GetHuffmanTableM: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableM));
  for X := 0 to Length(huffmanTableM) - 1 do
  begin
    Result[X].val := huffmanTableM[X][0];
    Result[X].prefixLen := huffmanTableM[X][1];
    Result[X].rangeLen := huffmanTableM[X][2];
    Result[X].prefix := huffmanTableM[X][3];
  end;
end;

function GetHuffmanTableN: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableN));
  for X := 0 to Length(huffmanTableN) - 1 do
  begin
    Result[X].val := huffmanTableN[X][0];
    Result[X].prefixLen := huffmanTableN[X][1];
    Result[X].rangeLen := huffmanTableN[X][2];
    Result[X].prefix := huffmanTableN[X][3];
  end;
end;

function GetHuffmanTableO: THuffmanTableArray;
var
  X: Integer;
begin
  SetLength(Result, Length(huffmanTableO));
  for X := 0 to Length(huffmanTableO) - 1 do
  begin
    Result[X].val := huffmanTableO[X][0];
    Result[X].prefixLen := huffmanTableO[X][1];
    Result[X].rangeLen := huffmanTableO[X][2];
    Result[X].prefix := huffmanTableO[X][3];
  end;
end;


{ THuffmanDecoder }

function THuffmanDecoder.buildTable(table: THuffmanTableArray;
  length: Integer): THuffmanTableArray;
var
  i: Integer;
  j: Integer;
  k: Integer;
  prefix: Integer;
  tab: THuffmanTable;
begin
  for i := 0 to length - 1 do
  begin
    j := i;
    while ((j < length) and (table[j].prefixLen = 0)) do
    begin
      Inc(j);
    end;

    if (j = length) then
    begin
      Break;
    end;

    for k := j + 1 to length - 1 do
    begin
      if ((table[k].prefixLen > 0) and (table[k].prefixLen < table[j].prefixLen)) then
      begin
        j := k;
      end;
    end;

    if (j <> i) then
    begin
      tab := table[j];
      for k := j downto i + 1 do
      begin
        table[k] := table[k - 1];
      end;
      table[i] := tab;
    end;
  end;
  table[i] := table[length];

  i := 0;
  prefix := 0;
  table[i].prefix := prefix;
  Inc(i);
  Inc(prefix);

  while (table[i].rangeLen <> jbig2HuffmanEOT) do
  begin
    prefix := prefix shl (table[i].prefixLen - table[i - 1].prefixLen);
    table[i].prefix := prefix;
    Inc(prefix);
    Inc(i);
  end;

  Result := table;
end;

procedure THuffmanDecoder.consumeRemainingBits;
begin
  reader.consumeRemainingBits;
end;

constructor THuffmanDecoder.Create(reader: TStreamReader);
begin
  Self.reader := reader;
end;

function THuffmanDecoder.decodeInt(
  table: THuffmanTableArray): TDecodeIntResult;
var
  length: Cardinal;
  prefix: Cardinal;
  i: Integer;
  bit: Cardinal;
  decodedInt: Integer;
  readBits: Integer;
begin
  length := 0;
  prefix := 0;

  i := 0;
  while (table[i].rangeLen <> jbig2HuffmanEOT) do
  begin
    while (length < table[i].prefixLen) do
    begin
      bit := reader.readBit;
      prefix := (prefix shl 1) or bit;
      Inc(length);
    end;

    if (prefix = table[i].prefix) then
    begin
      if (table[i].rangeLen = jbig2HuffmanOOB) then
      begin
        Result.intResult := -1;
        Result.booleanResult := False;
        Exit;
      end;

      if (table[i].rangeLen = jbig2HuffmanLOW) then
      begin
        readBits := reader.readBits(32);
        decodedInt := table[i].val - readBits;
      end else
      if (table[i].rangeLen > 0) then
      begin
        readBits := reader.readBits(table[i].rangeLen);
        decodedInt := table[i].val + readBits;
      end else
      begin
        decodedInt := table[i].val;
      end;

      Result.intResult := decodedInt;
      Result.booleanResult := True;
      Exit;
    end;

    Inc(i);
  end;

  Result.intResult := -1;
  Result.booleanResult := False;
end;

function THuffmanDecoder.readBit: Integer;
begin
  Result := reader.readBit;
end;

function THuffmanDecoder.readBits(num: Integer): Integer;
begin
  Result := reader.readBits(num);
end;


{ TJBIG2Bitmap }

constructor TJBIG2Bitmap.Create(Width, Height: Integer;
  arithmeticDecoder: TArithmeticDecoder; huffmanDecoder: THuffmanDecoder;
  mmrDecoder: TMMRDecoder; Factory: TJBIG2BitmapFactory);
var
  row: Integer;
begin
  Self.width := width;
  Self.height := height;
  Self.arithmeticDecoder := arithmeticDecoder;
  Self.huffmanDecoder := huffmanDecoder;
  Self.mmrDecoder := mmrDecoder;
  FFactory := Factory;
  line := (width + 7) shr 3;
  SetLength(data, height);
  for row := 0 to height - 1 do
  begin
    SetLength(data[row], width);
  end;
end;

procedure TJBIG2Bitmap.duplicateRow(yDest, ySrc: Integer);
var
  i: Integer;
begin
  for i := 0 to width - 1 do
  begin
    setPixel(i, yDest, getPixel(i, ySrc));
  end;
end;

function TJBIG2Bitmap.getHeight: Integer;
begin
  Result := height;
end;

function TJBIG2Bitmap.getPixel(col, row: Integer): Integer;
begin
  if ((row >= 0) and (col >= 0)) then
  begin
    Result := data[row][col];
  end else
  begin
    Result := 0;
  end;
end;

function TJBIG2Bitmap.getWidth: Integer;
begin
  Result := width;
end;

procedure TJBIG2Bitmap.readBitmap(useMMR: Boolean; template: Integer;
  typicalPredictionGenericDecodingOn, useSkip: Boolean;
  skipBitmap: TJBIG2Bitmap; adaptiveTemplateX,
  adaptiveTemplateY: TJBIG2SmallintArray; mmrDataLength: Integer);
var
  referenceLine: TJBIG2IntegerArray;
  codingLine: TJBIG2IntegerArray;
  row: Integer;
  i: Integer;
  referenceI: Integer;
  codingI: Integer;
  a0: Integer;
  code1: Integer;
  code2: Integer;
  code3: Integer;
  j: Integer;
  col: Integer;
  cxPtr0: TBitmapPointer;
  cxPtr1: TBitmapPointer;
  atPtr0: TBitmapPointer;
  atPtr1: TBitmapPointer;
  atPtr2: TBitmapPointer;
  atPtr3: TBitmapPointer;
  ltpCX: Int64;
  ltp: Boolean;
  cx: Int64;
  cx0: Int64;
  cx1: Int64;
  cx2: Int64;
  bit: Integer;
  pixel: Integer;
begin
  if (useMMR) then
  begin
    mmrDecoder.reset;

    SetLength(referenceLine, width + 2);
    SetLength(codingLine, width + 2);
    codingLine[0] := width;
    codingLine[1] := width;

    for row := 0 to height - 1 do
    begin
      for i := 0 to width - 1 do
      begin
        referenceLine[i] := codingLine[i];
      end;
      referenceLine[width] := width;
      referenceLine[width + 1] := width;

      referenceI := 0;
      codingI := 0;
      a0 := 0;

      repeat
        code1 := mmrDecoder.get2DCode;

        case code1 of
          0: //MMRDecoder.twoDimensionalPass:
          begin
            if (referenceLine[referenceI] < width) then
            begin
              a0 := referenceLine[referenceI + 1];
              Inc(referenceI, 2);
            end;
          end;

          1: //MMRDecoder.twoDimensionalHorizontal:
          begin
            if ((codingI and 1) <> 0) then
            begin
              code1 := 0;
              repeat
                code3 := mmrDecoder.getBlackCode;
                Inc(code1, code3);
              until (code3 < 64);

              code2 := 0;
              repeat
                code3 := mmrDecoder.getWhiteCode;
                Inc(code2, code3);
              until (code3 < 64);
            end else
            begin
              code1 := 0;
              repeat
                code3 := mmrDecoder.getWhiteCode;
                Inc(code1, code3);
              until (code3 < 64);

              code2 := 0;
              repeat
                code3 := mmrDecoder.getBlackCode;
                Inc(code2, code3);
              until code3 < 64;
            end;

            if ((code1 > 0) or (code2 > 0)) then
            begin
              codingLine[codingI] := a0 + code1;
              a0 := codingLine[codingI];
              Inc(codingI);
              codingLine[codingI] := a0 + code2;
              a0 := codingLine[codingI];
              Inc(codingI);

              while ((referenceLine[referenceI] <= a0) and (referenceLine[referenceI] < width)) do
              begin
                Inc(referenceI, 2);
              end;
            end;
          end;

          2: //MMRDecoder.twoDimensionalVertical0:
          begin
            codingLine[codingI] := referenceLine[referenceI];
            a0 := codingLine[codingI];
            Inc(codingI);

            if (referenceLine[referenceI] < width) then
            begin
              Inc(referenceI);
            end;
          end;

          3: //MMRDecoder.twoDimensionalVerticalR1:
          begin
            codingLine[codingI] := referenceLine[referenceI] + 1;
            a0 := codingLine[codingI];
            Inc(codingI);

            if (referenceLine[referenceI] < width) then
            begin
              Inc(referenceI);
              while ((referenceLine[referenceI] <= a0) and (referenceLine[referenceI] < width)) do
              begin
                Inc(referenceI, 2);
              end;
            end;
          end;

          5: //MMRDecoder.twoDimensionalVerticalR2:
          begin
            codingLine[codingI] := referenceLine[referenceI] + 2;
            a0 := codingLine[codingI];
            Inc(codingI);

            if (referenceLine[referenceI] < width) then
            begin
              Inc(referenceI);
              while ((referenceLine[referenceI] <= a0) and (referenceLine[referenceI] < width)) do
              begin
                Inc(referenceI, 2);
              end;
            end;
          end;

          7: //MMRDecoder.twoDimensionalVerticalR3:
          begin
            codingLine[codingI] := referenceLine[referenceI] + 3;
            a0 := codingLine[codingI];
            Inc(codingI);

            if ((referenceLine[referenceI] < width)) then
            begin
              Inc(referenceI);
              while ((referenceLine[referenceI] <= a0) and (referenceLine[referenceI] < width)) do
              begin
                Inc(referenceI, 2);
              end;
            end;
          end;

          4: //MMRDecoder.twoDimensionalVerticalL1:
          begin
            codingLine[codingI] := referenceLine[referenceI] - 1;
            a0 := codingLine[codingI];
            Inc(codingI);

            if (referenceI > 0) then
            begin
              Dec(referenceI);
            end else
            begin
              Inc(referenceI);
            end;

            while ((referenceLine[referenceI] <= a0) and (referenceLine[referenceI] < width)) do
            begin
              Inc(referenceI, 2);
            end;
          end;

          6: //MMRDecoder.twoDimensionalVerticalL2:
          begin
            codingLine[codingI] := referenceLine[referenceI] - 2;
            a0 := codingLine[codingI];
            Inc(codingI);

            if (referenceI > 0) then
            begin
              Dec(referenceI);
            end else
            begin
              Inc(referenceI);
            end;

            while ((referenceLine[referenceI] <= a0) and (referenceLine[referenceI] < width)) do
            begin
              Inc(referenceI, 2);
            end;
          end;

          8: //MMRDecoder.twoDimensionalVerticalL3:
          begin
            codingLine[codingI] := referenceLine[referenceI] - 3;
            a0 := codingLine[codingI];
            Inc(codingI);

            if (referenceI > 0) then
            begin
              Dec(referenceI);
            end else
            begin
              Inc(referenceI);
            end;

            while ((referenceLine[referenceI] <= a0) and (referenceLine[referenceI] < width)) do
            begin
              Inc(referenceI, 2);
            end;
          end;

        else
          // Illegal code in JBIG2 MMR bitmap data
        end;
      until (a0 >= width);

      codingLine[codingI] := width;

      j := 0;
      while (codingLine[j] < width) do
      begin
        for col := codingLine[j] to codingLine[j + 1] - 1 do
        begin
          setPixel(col, row, 1);
        end;
        Inc(j, 2);
      end;
    end;

    if (mmrDataLength >= 0) then
    begin
      mmrDecoder.skipTo(mmrDataLength);
    end else
    begin
      if (mmrDecoder.get24Bits <> $001001) then
      begin
        // Missing EOFB in JBIG2 MMR bitmap data
      end;
    end;
  end else
  begin
    cxPtr0 := TBitmapPointer.Create(Self);
    cxPtr1 := TBitmapPointer.Create(Self);
    atPtr0 := TBitmapPointer.Create(Self);
    atPtr1 := TBitmapPointer.Create(Self);
    atPtr2 := TBitmapPointer.Create(Self);
    atPtr3 := TBitmapPointer.Create(Self);
    try
      ltpCX := 0;
      if (typicalPredictionGenericDecodingOn) then
      begin
        case (template) of
          0: ltpCX := $3953;
          1: ltpCX := $079a;
          2: ltpCX := $0e3;
          3: ltpCX := $18a;
        end;
      end;

      ltp := False;

      for row := 0 to height - 1 do
      begin
        if (typicalPredictionGenericDecodingOn) then
        begin
          bit := arithmeticDecoder.decodeBit(ltpCX, arithmeticDecoder.genericRegionStats);
          if (bit <> 0) then
          begin
            ltp := not ltp;
          end;

          if (ltp) then
          begin
            duplicateRow(row, row - 1);
            Continue;
          end;
        end;

        case (template) of
          0:
          begin
            cxPtr0.setPointer(0, row - 2);
            cx0 := cxPtr0.nextPixel;
            cx0 := (bit32Shift(cx0, 1, LEFT_SHIFT)) or cxPtr0.nextPixel;

            cxPtr1.setPointer(0, row - 1);
            cx1 := cxPtr1.nextPixel;

            cx1 := (bit32Shift(cx1, 1, LEFT_SHIFT)) or cxPtr1.nextPixel;
            cx1 := (bit32Shift(cx1, 1, LEFT_SHIFT)) or cxPtr1.nextPixel;

            cx2 := 0;

            atPtr0.setPointer(adaptiveTemplateX[0], row + adaptiveTemplateY[0]);
            atPtr1.setPointer(adaptiveTemplateX[1], row + adaptiveTemplateY[1]);
            atPtr2.setPointer(adaptiveTemplateX[2], row + adaptiveTemplateY[2]);
            atPtr3.setPointer(adaptiveTemplateX[3], row + adaptiveTemplateY[3]);

            for col := 0 to width - 1 do
            begin
              cx := (bit32Shift(cx0, 13, LEFT_SHIFT)) or (bit32Shift(cx1, 8, LEFT_SHIFT)) or (bit32Shift(cx2, 4, LEFT_SHIFT)) or (atPtr0.nextPixel shl 3) or (atPtr1.nextPixel shl 2) or (atPtr2.nextPixel shl 1) or atPtr3.nextPixel;

              if (useSkip and (skipBitmap.getPixel(col, row) <> 0)) then
              begin
                pixel := 0;
              end else
              begin
                pixel := arithmeticDecoder.decodeBit(cx, arithmeticDecoder.genericRegionStats);
                if (pixel <> 0) then
                begin
                  setPixel(col, row, 1);
                end;
              end;

              cx0 := ((bit32Shift(cx0, 1, LEFT_SHIFT)) or cxPtr0.nextPixel) and $07;
              cx1 := ((bit32Shift(cx1, 1, LEFT_SHIFT)) or cxPtr1.nextPixel) and $1f;
              cx2 := ((bit32Shift(cx2, 1, LEFT_SHIFT)) or pixel) and $0f;
            end;
          end;

          1:
          begin
            cxPtr0.setPointer(0, row - 2);
            cx0 := cxPtr0.nextPixel;
            cx0 := (bit32Shift(cx0, 1, LEFT_SHIFT)) or cxPtr0.nextPixel;
            cx0 := (bit32Shift(cx0, 1, LEFT_SHIFT)) or cxPtr0.nextPixel;

            cxPtr1.setPointer(0, row - 1);
            cx1 := cxPtr1.nextPixel;
            cx1 := (bit32Shift(cx1, 1, LEFT_SHIFT)) or cxPtr1.nextPixel;
            cx1 := (bit32Shift(cx1, 1, LEFT_SHIFT)) or cxPtr1.nextPixel;

            cx2 := 0;

            atPtr0.setPointer(adaptiveTemplateX[0], row + adaptiveTemplateY[0]);

            for col := 0 to width - 1 do
            begin
              cx := (bit32Shift(cx0, 9, LEFT_SHIFT)) or (bit32Shift(cx1, 4, LEFT_SHIFT)) or (bit32Shift(cx2, 1, LEFT_SHIFT)) or atPtr0.nextPixel;

              if (useSkip and (skipBitmap.getPixel(col, row) <> 0)) then
              begin
                pixel := 0;
              end else
              begin
                pixel := arithmeticDecoder.decodeBit(cx, arithmeticDecoder.genericRegionStats);
                if (pixel <> 0) then
                begin
                  setPixel(col, row, 1);
                end;
              end;

              cx0 := ((bit32Shift(cx0, 1, LEFT_SHIFT)) or cxPtr0.nextPixel) and $0f;
              cx1 := ((bit32Shift(cx1, 1, LEFT_SHIFT)) or cxPtr1.nextPixel) and $1f;
              cx2 := ((bit32Shift(cx2, 1, LEFT_SHIFT)) or pixel) and $07;
            end;
          end;

          2:
          begin
            cxPtr0.setPointer(0, row - 2);
            cx0 := cxPtr0.nextPixel;
            cx0 := (bit32Shift(cx0, 1, LEFT_SHIFT)) or cxPtr0.nextPixel;

            cxPtr1.setPointer(0, row - 1);
            cx1 := cxPtr1.nextPixel;
            cx1 := (bit32Shift(cx1, 1, LEFT_SHIFT)) or cxPtr1.nextPixel;

            cx2 := 0;

            atPtr0.setPointer(adaptiveTemplateX[0], row + adaptiveTemplateY[0]);

            for col := 0 to width - 1 do
            begin
              cx := (bit32Shift(cx0, 7, LEFT_SHIFT)) or (bit32Shift(cx1, 3, LEFT_SHIFT)) or (bit32Shift(cx2, 1, LEFT_SHIFT)) or atPtr0.nextPixel;

              if (useSkip and (skipBitmap.getPixel(col, row) <> 0)) then
              begin
                pixel := 0;
              end else
              begin
                pixel := arithmeticDecoder.decodeBit(cx, arithmeticDecoder.genericRegionStats);
                if (pixel <> 0) then
                begin
                  setPixel(col, row, 1);
                end;
              end;

              cx0 := ((bit32Shift(cx0, 1, LEFT_SHIFT)) or cxPtr0.nextPixel) and $07;
              cx1 := ((bit32Shift(cx1, 1, LEFT_SHIFT)) or cxPtr1.nextPixel) and $0f;
              cx2 := ((bit32Shift(cx2, 1, LEFT_SHIFT)) or pixel) and $03;
            end;
          end;

          3:
          begin
            cxPtr1.setPointer(0, row - 1);
            cx1 := cxPtr1.nextPixel;
            cx1 := (bit32Shift(cx1, 1, LEFT_SHIFT)) or cxPtr1.nextPixel;

            cx2 := 0;

            atPtr0.setPointer(adaptiveTemplateX[0], row + adaptiveTemplateY[0]);

            for col := 0 to width - 1 do
            begin
              cx := (bit32Shift(cx1, 5, LEFT_SHIFT)) or (bit32Shift(cx2, 1, LEFT_SHIFT)) or atPtr0.nextPixel;

              if (useSkip and (skipBitmap.getPixel(col, row) <> 0)) then
              begin
                pixel := 0;
              end else
              begin
                pixel := arithmeticDecoder.decodeBit(cx, arithmeticDecoder.genericRegionStats);
                if (pixel <> 0) then
                begin
                  setPixel(col, row, 1);
                end;
              end;

              cx1 := ((bit32Shift(cx1, 1, LEFT_SHIFT)) or cxPtr1.nextPixel) and $1f;
              cx2 := ((bit32Shift(cx2, 1, LEFT_SHIFT)) or pixel) and $0f;
            end;
          end;
        end;
      end;
    finally
      cxPtr0.Free;
      cxPtr1.Free;
      atPtr0.Free;
      atPtr1.Free;
      atPtr2.Free;
      atPtr3.Free;
    end;
  end;
end;

procedure TJBIG2Bitmap.readGenericRefinementRegion(template: Integer;
  typicalPredictionGenericRefinementOn: Boolean;
  referredToBitmap: TJBIG2Bitmap; referenceDX, referenceDY: Integer;
  adaptiveTemplateX, adaptiveTemplateY: TJBIG2SmallintArray);
var
  cxPtr0: TBitmapPointer;
  cxPtr1: TBitmapPointer;
  cxPtr2: TBitmapPointer;
  cxPtr3: TBitmapPointer;
  cxPtr4: TBitmapPointer;
  cxPtr5: TBitmapPointer;
  cxPtr6: TBitmapPointer;
  typicalPredictionGenericRefinementCXPtr0: TBitmapPointer;
  typicalPredictionGenericRefinementCXPtr1: TBitmapPointer;
  typicalPredictionGenericRefinementCXPtr2: TBitmapPointer;
  ltpCX: Int64;
  cx: Int64;
  cx0: Int64;
  cx2: Int64;
  cx3: Int64;
  cx4: Int64;
  typicalPredictionGenericRefinementCX0: Int64;
  typicalPredictionGenericRefinementCX1: Int64;
  typicalPredictionGenericRefinementCX2: Int64;
  ltp: Boolean;
  row: Integer;
  col: Integer;
  decodeBit: Integer;
  pixel: Integer;
begin
  ltp := False;

  if (template <> 0) then
  begin
    ltpCX := $008;

    cxPtr0 := TBitmapPointer.Create(Self);
    cxPtr1 := TBitmapPointer.Create(Self);
    cxPtr2 := TBitmapPointer.Create(referredToBitmap);
    cxPtr3 := TBitmapPointer.Create(referredToBitmap);
    cxPtr4 := TBitmapPointer.Create(referredToBitmap);
    cxPtr5 := TBitmapPointer.Create(Self);
    cxPtr6 := TBitmapPointer.Create(Self);
    typicalPredictionGenericRefinementCXPtr0 := TBitmapPointer.Create(referredToBitmap);
    typicalPredictionGenericRefinementCXPtr1 := TBitmapPointer.Create(referredToBitmap);
    typicalPredictionGenericRefinementCXPtr2 := TBitmapPointer.Create(referredToBitmap);
  end else
  begin
    ltpCX := $0010;

    cxPtr0 := TBitmapPointer.Create(Self);
    cxPtr1 := TBitmapPointer.Create(Self);
    cxPtr2 := TBitmapPointer.Create(referredToBitmap);
    cxPtr3 := TBitmapPointer.Create(referredToBitmap);
    cxPtr4 := TBitmapPointer.Create(referredToBitmap);
    cxPtr5 := TBitmapPointer.Create(Self);
    cxPtr6 := TBitmapPointer.Create(referredToBitmap);
    typicalPredictionGenericRefinementCXPtr0 := TBitmapPointer.Create(referredToBitmap);
    typicalPredictionGenericRefinementCXPtr1 := TBitmapPointer.Create(referredToBitmap);
    typicalPredictionGenericRefinementCXPtr2 := TBitmapPointer.Create(referredToBitmap);
  end;

  try
    for row := 0 to height - 1 do
    begin
      if (template <> 0) then
      begin
        cxPtr0.setPointer(0, row - 1);
        cx0 := cxPtr0.nextPixel;

        cxPtr1.setPointer(-1, row);

        cxPtr2.setPointer(-referenceDX, row - 1 - referenceDY);

        cxPtr3.setPointer(-1 - referenceDX, row - referenceDY);
        cx3 := cxPtr3.nextPixel;
        cx3 := (bit32Shift(cx3, 1, LEFT_SHIFT)) or cxPtr3.nextPixel;

        cxPtr4.setPointer(-referenceDX, row + 1 - referenceDY);
        cx4 := cxPtr4.nextPixel();

        typicalPredictionGenericRefinementCX0 := 0;
        typicalPredictionGenericRefinementCX1 := 0;
        typicalPredictionGenericRefinementCX2 := 0;

        if (typicalPredictionGenericRefinementOn) then
        begin
          typicalPredictionGenericRefinementCXPtr0.setPointer(-1 - referenceDX, row - 1 - referenceDY);
          typicalPredictionGenericRefinementCX0 := typicalPredictionGenericRefinementCXPtr0.nextPixel;
          typicalPredictionGenericRefinementCX0 := (bit32Shift(typicalPredictionGenericRefinementCX0, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr0.nextPixel;
          typicalPredictionGenericRefinementCX0 := (bit32Shift(typicalPredictionGenericRefinementCX0, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr0.nextPixel;

          typicalPredictionGenericRefinementCXPtr1.setPointer(-1 - referenceDX, row - referenceDY);
          typicalPredictionGenericRefinementCX1 := typicalPredictionGenericRefinementCXPtr1.nextPixel;
          typicalPredictionGenericRefinementCX1 := (bit32Shift(typicalPredictionGenericRefinementCX1, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr1.nextPixel;
          typicalPredictionGenericRefinementCX1 := (bit32Shift(typicalPredictionGenericRefinementCX1, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr1.nextPixel;

          typicalPredictionGenericRefinementCXPtr2.setPointer(-1 - referenceDX, row + 1 - referenceDY);
          typicalPredictionGenericRefinementCX2 := typicalPredictionGenericRefinementCXPtr2.nextPixel;
          typicalPredictionGenericRefinementCX2 := (bit32Shift(typicalPredictionGenericRefinementCX2, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr2.nextPixel;
          typicalPredictionGenericRefinementCX2 := (bit32Shift(typicalPredictionGenericRefinementCX2, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr2.nextPixel;
        end;

        for col := 0 to width - 1 do
        begin
          cx0 := ((bit32Shift(cx0, 1, LEFT_SHIFT)) or cxPtr0.nextPixel) and 7;
          cx3 := ((bit32Shift(cx3, 1, LEFT_SHIFT)) or cxPtr3.nextPixel) and 7;
          cx4 := ((bit32Shift(cx4, 1, LEFT_SHIFT)) or cxPtr4.nextPixel) and 3;

          if (typicalPredictionGenericRefinementOn) then
          begin
            typicalPredictionGenericRefinementCX0 := ((bit32Shift(typicalPredictionGenericRefinementCX0, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr0.nextPixel) and 7;
            typicalPredictionGenericRefinementCX1 := ((bit32Shift(typicalPredictionGenericRefinementCX1, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr1.nextPixel) and 7;
            typicalPredictionGenericRefinementCX2 := ((bit32Shift(typicalPredictionGenericRefinementCX2, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr2.nextPixel) and 7;

            decodeBit := arithmeticDecoder.decodeBit(ltpCX, arithmeticDecoder.refinementRegionStats);
            if (decodeBit <> 0) then
            begin
              ltp := not ltp;
            end;
            if ((typicalPredictionGenericRefinementCX0 = 0) and (typicalPredictionGenericRefinementCX1 = 0) and (typicalPredictionGenericRefinementCX2 = 0)) then
            begin
              setPixel(col, row, 0);
              Continue;
            end else
            if ((typicalPredictionGenericRefinementCX0 = 7) and (typicalPredictionGenericRefinementCX1 = 7) and (typicalPredictionGenericRefinementCX2 = 7)) then
            begin
              setPixel(col, row, 1);
              Continue;
            end;
          end;

          cx := (bit32Shift(cx0, 7, LEFT_SHIFT)) or (cxPtr1.nextPixel() shl 6) or (cxPtr2.nextPixel shl 5) or (bit32Shift(cx3, 2, LEFT_SHIFT)) or cx4;

          pixel := arithmeticDecoder.decodeBit(cx, arithmeticDecoder.refinementRegionStats);
          if (pixel = 1) then
          begin
            setPixel(col, row, 1);
          end;
        end;
      end else
      begin
        cxPtr0.setPointer(0, row - 1);
        cx0 := cxPtr0.nextPixel;

        cxPtr1.setPointer(-1, row);

        cxPtr2.setPointer(-referenceDX, row - 1 - referenceDY);
        cx2 := cxPtr2.nextPixel;

        cxPtr3.setPointer(-1 - referenceDX, row - referenceDY);
        cx3 := cxPtr3.nextPixel;
        cx3 := (bit32Shift(cx3, 1, LEFT_SHIFT)) or cxPtr3.nextPixel;

        cxPtr4.setPointer(-1 - referenceDX, row + 1 - referenceDY);
        cx4 := cxPtr4.nextPixel;
        cx4 := (bit32Shift(cx4, 1, LEFT_SHIFT)) or cxPtr4.nextPixel;

        cxPtr5.setPointer(adaptiveTemplateX[0], row + adaptiveTemplateY[0]);

        cxPtr6.setPointer(adaptiveTemplateX[1] - referenceDX, row + adaptiveTemplateY[1] - referenceDY);

        typicalPredictionGenericRefinementCX0 := 0;
        typicalPredictionGenericRefinementCX1 := 0;
        typicalPredictionGenericRefinementCX2 := 0;

        if (typicalPredictionGenericRefinementOn) then
        begin
          typicalPredictionGenericRefinementCXPtr0.setPointer(-1 - referenceDX, row - 1 - referenceDY);
          typicalPredictionGenericRefinementCX0 := typicalPredictionGenericRefinementCXPtr0.nextPixel;
          typicalPredictionGenericRefinementCX0 := (bit32Shift(typicalPredictionGenericRefinementCX0, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr0.nextPixel;
          typicalPredictionGenericRefinementCX0 := (bit32Shift(typicalPredictionGenericRefinementCX0, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr0.nextPixel;

          typicalPredictionGenericRefinementCXPtr1.setPointer(-1 - referenceDX, row - referenceDY);
          typicalPredictionGenericRefinementCX1 := typicalPredictionGenericRefinementCXPtr1.nextPixel;
          typicalPredictionGenericRefinementCX1 := (bit32Shift(typicalPredictionGenericRefinementCX1, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr1.nextPixel;
          typicalPredictionGenericRefinementCX1 := (bit32Shift(typicalPredictionGenericRefinementCX1, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr1.nextPixel;

          typicalPredictionGenericRefinementCXPtr2.setPointer(-1 - referenceDX, row + 1 - referenceDY);
          typicalPredictionGenericRefinementCX2 := typicalPredictionGenericRefinementCXPtr2.nextPixel;
          typicalPredictionGenericRefinementCX2 := (bit32Shift(typicalPredictionGenericRefinementCX2, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr2.nextPixel;
          typicalPredictionGenericRefinementCX2 := (bit32Shift(typicalPredictionGenericRefinementCX2, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr2.nextPixel;
        end;

        for col := 0 to width -1 do
        begin
          cx0 := ((bit32Shift(cx0, 1, LEFT_SHIFT)) or cxPtr0.nextPixel) and 3;
          cx2 := ((bit32Shift(cx2, 1, LEFT_SHIFT)) or cxPtr2.nextPixel) and 3;
          cx3 := ((bit32Shift(cx3, 1, LEFT_SHIFT)) or cxPtr3.nextPixel) and 7;
          cx4 := ((bit32Shift(cx4, 1, LEFT_SHIFT)) or cxPtr4.nextPixel) and 7;

          if (typicalPredictionGenericRefinementOn) then
          begin
            typicalPredictionGenericRefinementCX0 := ((bit32Shift(typicalPredictionGenericRefinementCX0, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr0.nextPixel) and 7;
            typicalPredictionGenericRefinementCX1 := ((bit32Shift(typicalPredictionGenericRefinementCX1, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr1.nextPixel) and 7;
            typicalPredictionGenericRefinementCX2 := ((bit32Shift(typicalPredictionGenericRefinementCX2, 1, LEFT_SHIFT)) or typicalPredictionGenericRefinementCXPtr2.nextPixel) and 7;

            decodeBit := arithmeticDecoder.decodeBit(ltpCX, arithmeticDecoder.refinementRegionStats);
            if (decodeBit = 1) then
            begin
              ltp := not ltp;
            end;
            if ((typicalPredictionGenericRefinementCX0 = 0) and (typicalPredictionGenericRefinementCX1 = 0) and (typicalPredictionGenericRefinementCX2 = 0)) then
            begin
              setPixel(col, row, 0);
              Continue;
            end else
            if ((typicalPredictionGenericRefinementCX0 = 7) and (typicalPredictionGenericRefinementCX1 = 7) and (typicalPredictionGenericRefinementCX2 = 7)) then
            begin
              setPixel(col, row, 1);
              Continue;
            end;
          end;

          cx := (bit32Shift(cx0, 11, LEFT_SHIFT)) or (cxPtr1.nextPixel shl 10) or (bit32Shift(cx2, 8, LEFT_SHIFT)) or (bit32Shift(cx3, 5, LEFT_SHIFT)) or (bit32Shift(cx4, 2, LEFT_SHIFT)) or (cxPtr5.nextPixel() shl 1) or cxPtr6.nextPixel;

          pixel := arithmeticDecoder.decodeBit(cx, arithmeticDecoder.refinementRegionStats);
          if (pixel = 1) then
          begin
            setPixel(col, row, 1);
          end;
        end;
      end;
    end;
  finally
    cxPtr0.Free;
    cxPtr1.Free;
    cxPtr2.Free;
    cxPtr3.Free;
    cxPtr4.Free;
    cxPtr5.Free;
    cxPtr6.Free;
    typicalPredictionGenericRefinementCXPtr0.Free;
    typicalPredictionGenericRefinementCXPtr1.Free;
    typicalPredictionGenericRefinementCXPtr2.Free;
  end;
end;

procedure TJBIG2Bitmap.setPixel(col, row, value: Integer);
begin
  if ((row >= 0) and (col >= 0) and (row < height) and (col < width)) then
  begin
    data[row][col] := value;
  end;
end;

procedure TJBIG2Bitmap.readTextRegion(huffman, symbolRefine: Boolean; noOfSymbolInstances, logStrips, noOfSymbols: Integer; symbolCodeTable: THuffmanTableArray;
  symbolCodeLength: Integer; symbols: array of TJBIG2Bitmap; defaultPixel, combinationOperator: Integer; transposed: Boolean; referenceCorner, sOffset: Integer;
  huffmanFSTable, huffmanDSTable, huffmanDTTable, huffmanRDWTable, huffmanRDHTable, huffmanRDXTable, huffmanRDYTable, huffmanRSizeTable: THuffmanTableArray;
  template: Integer; symbolRegionAdaptiveTemplateX, symbolRegionAdaptiveTemplateY: TJBIG2SmallintArray);
var
  symbolBitmap: TJBIG2Bitmap;
  strips: Integer;
  t: Integer;
  currentInstance: Integer;
  firstS: Integer;
  dt: Integer;
  tt: Integer;
  ds: Integer;
  s: Integer;
  symbolID: Int64;
  refinementDeltaWidth: Integer;
  refinementDeltaHeight: Integer;
  refinementDeltaX: Integer;
  refinementDeltaY: Integer;
  bitmapWidth: Integer;
  bitmapHeight: Integer;
  decodeIntResult: TDecodeIntResult;
  ri: Integer;
begin
  strips := 1 shl logStrips;

  clear(defaultPixel);

  if (huffman) then
  begin
    t := huffmanDecoder.decodeInt(huffmanDTTable).intResult;
  end else
  begin
    t := arithmeticDecoder.decodeInt(arithmeticDecoder.iadtStats).intResult;
  end;
  t := t * -strips;

  currentInstance := 0;
  firstS := 0;

  while (currentInstance < noOfSymbolInstances) do
  begin

    if (huffman) then
    begin
      dt := huffmanDecoder.decodeInt(huffmanDTTable).intResult;
    end else
    begin
      dt := arithmeticDecoder.decodeInt(arithmeticDecoder.iadtStats).intResult;
    end;
    Inc(t, dt * strips);

    if (huffman) then
    begin
      ds := huffmanDecoder.decodeInt(huffmanFSTable).intResult;
    end else
    begin
      ds := arithmeticDecoder.decodeInt(arithmeticDecoder.iafsStats).intResult;
    end;
    Inc(firstS, ds);
    s := firstS;
    while (True) do
    begin
      if (strips = 1) then
      begin
        dt := 0;
      end else
      if (huffman) then
      begin
        dt := huffmanDecoder.readBits(logStrips);
      end else
      begin
        dt := arithmeticDecoder.decodeInt(arithmeticDecoder.iaitStats).intResult;
      end;
      tt := t + dt;

      if (huffman) then
      begin
        if (Assigned(symbolCodeTable)) then
        begin
          symbolID := huffmanDecoder.decodeInt(symbolCodeTable).intResult;
        end else
        begin
          symbolID := huffmanDecoder.readBits(symbolCodeLength);
        end;
      end else
      begin
        symbolID := arithmeticDecoder.decodeIAID(symbolCodeLength, arithmeticDecoder.iaidStats);
      end;

      if (symbolID >= noOfSymbols) then
      begin
        // Invalid symbol number in JBIG2 text region
      end else
      begin
        if (symbolRefine) then
        begin
          if (huffman) then
          begin
            ri := huffmanDecoder.readBit;
          end else
          begin
            ri := arithmeticDecoder.decodeInt(arithmeticDecoder.iariStats).intResult;
          end;
        end else
        begin
          ri := 0;
        end;
        if (ri <> 0) then
        begin
          if (huffman) then
          begin
            refinementDeltaWidth := huffmanDecoder.decodeInt(huffmanRDWTable).intResult;
            refinementDeltaHeight := huffmanDecoder.decodeInt(huffmanRDHTable).intResult;
            refinementDeltaX := huffmanDecoder.decodeInt(huffmanRDXTable).intResult;
            refinementDeltaY := huffmanDecoder.decodeInt(huffmanRDYTable).intResult;

            huffmanDecoder.consumeRemainingBits;
            arithmeticDecoder.start;
          end else
          begin
            refinementDeltaWidth := arithmeticDecoder.decodeInt(arithmeticDecoder.iardwStats).intResult;
            refinementDeltaHeight := arithmeticDecoder.decodeInt(arithmeticDecoder.iardhStats).intResult;
            refinementDeltaX := arithmeticDecoder.decodeInt(arithmeticDecoder.iardxStats).intResult;
            refinementDeltaY := arithmeticDecoder.decodeInt(arithmeticDecoder.iardyStats).intResult;
          end;

          if (refinementDeltaWidth >= 0) then
          begin
            refinementDeltaX := (refinementDeltaWidth) div 2 + refinementDeltaX;
          end else
          begin
            refinementDeltaX := (refinementDeltaWidth - 1) div 2 + refinementDeltaX;
          end;
          if (refinementDeltaHeight >= 0) then
          begin
            refinementDeltaY := (refinementDeltaHeight) div 2 + refinementDeltaY;
          end else
          begin
            refinementDeltaY := (refinementDeltaHeight - 1) div 2 + refinementDeltaY;
          end;

          symbolBitmap := FFactory.CreateBitmap(refinementDeltaWidth + symbols[Integer(symbolID)].width, refinementDeltaHeight + symbols[Integer(symbolID)].height, arithmeticDecoder, huffmanDecoder, mmrDecoder);

          symbolBitmap.readGenericRefinementRegion(template, False, symbols[Integer(symbolID)], refinementDeltaX, refinementDeltaY, symbolRegionAdaptiveTemplateX, symbolRegionAdaptiveTemplateY);
        end else
        begin
          symbolBitmap := symbols[Integer(symbolID)];
        end;

        bitmapWidth := symbolBitmap.width - 1;
        bitmapHeight := symbolBitmap.height - 1;
        if (transposed) then
        begin
          case (referenceCorner) of
            0: // bottom left
            begin
              combine(symbolBitmap, tt, s, combinationOperator);
            end;

            1: // top left
            begin
              combine(symbolBitmap, tt, s, combinationOperator);
            end;

            2: // bottom right
            begin
              combine(symbolBitmap, (tt - bitmapWidth), s, combinationOperator);
            end;

            3: // top right
            begin
              combine(symbolBitmap, (tt - bitmapWidth), s, combinationOperator);
            end;
          end;
          Inc(s, bitmapHeight);
        end else
        begin
          case (referenceCorner) of
            0: // bottom left
            begin
              combine(symbolBitmap, s, (tt - bitmapHeight), combinationOperator);
            end;

            1: // top left
            begin
              combine(symbolBitmap, s, tt, combinationOperator);
            end;

            2: // bottom right
            begin
              combine(symbolBitmap, s, (tt - bitmapHeight), combinationOperator);
            end;

            3: // top right
            begin
              combine(symbolBitmap, s, tt, combinationOperator);
            end;
          end;
          Inc(s, bitmapWidth);
        end;
      end;

      Inc(currentInstance);

      if (huffman) then
      begin
        decodeIntResult := huffmanDecoder.decodeInt(huffmanDSTable);
      end else
      begin
        decodeIntResult := arithmeticDecoder.decodeInt(arithmeticDecoder.iadsStats);
      end;

      if (not decodeIntResult.booleanResult) then
      begin
        Break;
      end;

      ds := decodeIntResult.intResult;

      Inc(s, sOffset + ds);
    end;
  end;
end;

procedure TJBIG2Bitmap.clear(defPixel: Integer);
var
  row: Integer;
begin
  for row := 0 to height - 1 do
  begin
    FillChar(data[row][0], width, defPixel);
  end;
end;

procedure TJBIG2Bitmap.combine(bitmap: TJBIG2Bitmap; x, y: Integer;
  combOp: Int64);
var
  srcWidth: Integer;
  srcHeight: Integer;
  srcRow: Integer;
  srcCol: Integer;
  row: Integer;
  col: Integer;
  srcPixel: Integer;
begin
  srcWidth := bitmap.width;
  srcHeight := bitmap.height;
  srcRow := 0;
  srcCol := 0;

  if (x < 0) then x := 0;
  if (y < 0) then y := 0;

  for row := y to Min(y + srcHeight - 1, Self.height - 1) do
  begin
    for col := x to x + srcWidth - 1 do
    begin
      srcPixel := bitmap.getPixel(srcCol, srcRow);

      case Integer(combOp) of
        0: // or
        begin
          setPixel(col, row, getPixel(col, row) or srcPixel);
        end;

        1: // and
        begin
          setPixel(col, row, getPixel(col, row) and srcPixel);
        end;

        2: // xor
        begin
          setPixel(col, row, getPixel(col, row) xor srcPixel);
        end;

        3: // xnor
        begin
          if (((getPixel(col, row) = 1) and (srcPixel = 1)) or ((getPixel(col, row) = 0) and (srcPixel = 0))) then
          begin
            setPixel(col, row, 1);
          end else
          begin
            setPixel(col, row, 0);
          end;
        end;

        4: // replace
        begin
          setPixel(col, row, srcPixel);
        end;
      end;
      Inc(srcCol);
    end;

    srcCol := 0;
    Inc(srcRow);
  end;
end;

function TJBIG2Bitmap.getSlice(x, y, width, height: Integer): TJBIG2Bitmap;
var
  slice: TJBIG2Bitmap;
  sliceRow: Integer;
  sliceCol: Integer;
  row: Integer;
  col: Integer;
begin
  slice := FFactory.CreateBitmap(width, height, arithmeticDecoder,
    huffmanDecoder, mmrDecoder);

  sliceRow := 0;
  sliceCol := 0;
  // for row := y to height - 1 do
  // Fix from original: use y + height - 1 instead of height - 1
  for row := y to y + height - 1 do
  begin
    for col := x to x + width - 1 do
    begin
      slice.setPixel(sliceCol, sliceRow, getPixel(col, row));
      Inc(sliceCol);
    end;
    sliceCol := 0;
    Inc(sliceRow);
  end;

  Result := slice;
end;

procedure TJBIG2Bitmap.expand(newHeight, defaultPixel: Integer);
var
  row: Integer;
begin
  SetLength(data, newHeight);
  for row := height to newHeight - 1 do
  begin
    SetLength(data[row], width);
    FillChar(data[row][0], width, defaultPixel);
  end;

  height := newHeight;
end;

function TJBIG2Bitmap.getBitmapNumber: Integer;
begin
  Result := bitmapNumber;
end;

procedure TJBIG2Bitmap.setBitmapNumber(segmentNumber: Integer);
begin
  bitmapNumber := segmentNumber;
end;

function TJBIG2Bitmap.getRow(row: Integer): TJBIG2ByteArray;
begin
  if (row < height) then
  begin
    SetLength(Result, width);
    Move(data[row][0], Result[0], width);
  end else
  begin
    SetLength(Result, width);
    FillChar(Result[0], width, 0);
  end;
end;


{ TJBIG2BitmapFactory }

constructor TJBIG2BitmapFactory.Create;
begin
  BitmapList := TJBIG2List.Create;
end;

function TJBIG2BitmapFactory.CreateBitmap(width, height: Integer;
  arithmeticDecoder: TArithmeticDecoder; huffmanDecoder: THuffmanDecoder;
  mmrDecoder: TMMRDecoder): TJBIG2Bitmap;
begin
  Result := TJBIG2Bitmap.Create(width, height, arithmeticDecoder,
    huffmanDecoder, mmrDecoder, Self);
  BitmapList.Add(Result);
end;

destructor TJBIG2BitmapFactory.Destroy;
var
  X: Integer;
begin
  for X := 0 to BitmapList.Count - 1 do
  begin
    TJBIG2Bitmap(BitmapList[X]).Free;
  end;
  BitmapList.Free;

  inherited;
end;

function JBIG2Ceil(X: Double): Integer;
begin
  Result := Ceil(X);
end;


{ TJBIG2StreamDecoder }

function TJBIG2StreamDecoder.checkHeader: Boolean;
var
  actualHeader: TJBIG2SmallintArray;
begin
  SetLength(actualHeader, 8);
  reader.readByte(actualHeader);

  Result := True;
  if actualHeader[0] <> 151 then Result := False;
  if actualHeader[1] <> 74 then Result := False;
  if actualHeader[2] <> 66 then Result := False;
  if actualHeader[3] <> 50 then Result := False;
  if actualHeader[4] <> 13 then Result := False;
  if actualHeader[5] <> 10 then Result := False;
  if actualHeader[6] <> 26 then Result := False;
  if actualHeader[7] <> 10 then Result := False;
end;

procedure TJBIG2StreamDecoder.consumeRemainingBits;
begin
  reader.consumeRemainingBits;
end;

constructor TJBIG2StreamDecoder.Create;
begin
  noOfPages := -1;
  segments := TJBIG2List.Create;
  bitmaps := TJBIG2List.Create;
  FBitmapFactory := TJBIG2BitmapFactory.Create;
end;

procedure TJBIG2StreamDecoder.decodeJBIG2(data: TJBIG2ByteArray);
var
  validFile: Boolean;
begin
  if Assigned(reader) then
  begin
    reader.Free;
    reader := nil;
  end;

  reader := TStreamReader.Create(data);
  resetDecoder;

  validFile := checkHeader;

  if (not validFile) then
  begin
     // Assume this is a stream from a PDF so there is no file header,
     // end of page segments, or end of file segments. Organisation must
     // be sequential, and the number of pages is assumed to be 1.

    noOfPagesKnown := true;
    randomAccessOrganisation := false;
    noOfPages := 1;

    // Check to see if there is any global data to be read
    if Length(globalData) > 0 then
    begin
      // set the reader to read from the global data
      reader.Free;
      reader := TStreamReader.Create(globalData);

      huffmanDecoder := THuffmanDecoder.Create(reader);
      mmrDecoder := TMMRDecoder.Create(reader);
      arithmeticDecoder := TArithmeticDecoder.Create(reader);

      // read in the global data segments
      readSegments;

      // set the reader back to the main data
      reader.Free;
      reader := TStreamReader.Create(data);

      // Added for Delphi version
      huffmanDecoder.Free;
      huffmanDecoder := nil;

      mmrDecoder.Free;
      mmrDecoder := nil;

      arithmeticDecoder.Free;
      arithmeticDecoder := nil;
    end else
    begin
       // There's no global data, so move the file pointer back to the
       // start of the stream

      reader.movePointer(-8);
    end;
  end else
  begin
     // We have the file header, so assume it is a valid stand-alone
     // file.

    setFileHeaderFlags;

    if (noOfPagesKnown) then
    begin
      noOfPages := getNoOfPages;
    end;
  end;

  huffmanDecoder := THuffmanDecoder.Create(reader);
  mmrDecoder := TMMRDecoder.Create(reader);
  arithmeticDecoder := TArithmeticDecoder.Create(reader);

  readSegments;
end;

destructor TJBIG2StreamDecoder.Destroy;
var
  X: Integer;
begin
  for X := 0 to segments.Count - 1 do
  begin
    TSegment(segments.Items[X]).Free;
  end;
  segments.Free;

  bitmaps.Free;

  if Assigned(huffmanDecoder) then
  begin
    huffmanDecoder.Free;
  end;

  if Assigned(mmrDecoder) then
  begin
    mmrDecoder.Free;
  end;

  if Assigned(arithmeticDecoder) then
  begin
    arithmeticDecoder.Free;
  end;

  if Assigned(reader) then
  begin
    reader.Free;
  end;

  FBitmapFactory.Free;

  inherited;
end;

function TJBIG2StreamDecoder.getArithmeticDecoder: TArithmeticDecoder;
begin
  Result := arithmeticDecoder;
end;

function TJBIG2StreamDecoder.getHuffmanDecoder: THuffmanDecoder;
begin
  Result := huffmanDecoder;
end;

function TJBIG2StreamDecoder.getMMRDecoder: TMMRDecoder;
begin
  Result := mmrDecoder;
end;

function TJBIG2StreamDecoder.getNoOfPages: Integer;
var
  noOfPagesA: TJBIG2SmallintArray;
begin
  if (noOfPages > 0) then   // was (noOfPagesKnown)
  begin
    Result := noOfPages;
  end else
  begin
    SetLength(noOfPagesA, 4);
    reader.readByte(noOfPagesA);
    Result := getInt32(noOfPagesA);
  end;
end;

procedure TJBIG2StreamDecoder.handleReferedToSegmentNumbers(segmentHeader: TSegmentHeader);
var
  referredToSegmentCount: Integer;
  referredToSegments: TJBIG2IntegerArray;
  segmentNumber: Integer;
  i: Integer;
  buf: TJBIG2SmallintArray;
begin
  referredToSegmentCount := segmentHeader.getReferredToSegmentCount;
  SetLength(referredToSegments, referredToSegmentCount);

  segmentNumber := segmentHeader.getSegmentNumber;

  if (segmentNumber <= 256) then
  begin
    for i := 0 to referredToSegmentCount - 1 do
    begin
      referredToSegments[i] := reader.readByte;
    end;
  end else
  if (segmentNumber <= 65536) then
  begin
    SetLength(buf, 2);
    for i := 0 to referredToSegmentCount - 1 do
    begin
      reader.readByte(buf);
      referredToSegments[i] := getInt16(buf);
    end
  end else
  begin
    SetLength(buf, 4);
    for i := 0 to referredToSegmentCount - 1 do
    begin
      reader.readByte(buf);
      referredToSegments[i] := getInt32(buf);
    end;
  end;

  segmentHeader.setReferredToSegments(referredToSegments);
end;

procedure TJBIG2StreamDecoder.handleSegmentHeaderFlags(segmentHeader: TSegmentHeader);
var
  segmentHeaderFlags: Smallint;
begin
  segmentHeaderFlags := reader.readByte();
  segmentHeader.setSegmentHeaderFlags(segmentHeaderFlags);
end;

procedure TJBIG2StreamDecoder.handleSegmentNumber(segmentHeader: TSegmentHeader);
var
  segmentBytes: TJBIG2SmallintArray;
  segmentNumber: Integer;
begin
  SetLength(segmentBytes, 4);
  reader.readByte(segmentBytes);

  segmentNumber := getInt32(segmentBytes);
  segmentHeader.setSegmentNumber(segmentNumber);
end;

procedure TJBIG2StreamDecoder.handleSegmentReferredToCountAndRententionFlags(segmentHeader: TSegmentHeader);
var
  referedToSegmentCountAndRetentionFlags: SmallInt;
  referredToSegmentCount: Integer;
  retentionFlags: TJBIG2SmallintArray;
  firstByte: Smallint;
  longFormCountAndFlags: TJBIG2SmallintArray;
  i: Integer;
  noOfBytesInField: Integer;
  noOfRententionFlagBytes: Integer;
begin
  referedToSegmentCountAndRetentionFlags := reader.readByte;

  referredToSegmentCount := (referedToSegmentCountAndRetentionFlags and 224) shr 5;

  SetLength(retentionFlags, 0);
  firstByte := Smallint(referedToSegmentCountAndRetentionFlags and 31);

  if (referredToSegmentCount <= 4) then
  begin
    SetLength(retentionFlags, 1);
    retentionFlags[0] := firstByte;
  end else
  if (referredToSegmentCount = 7) then
  begin
    SetLength(longFormCountAndFlags, 4);
    longFormCountAndFlags[0] := firstByte;

    for i := 1 to 3 do
    begin
      longFormCountAndFlags[i] := reader.readByte;
    end;

    referredToSegmentCount := getInt32(longFormCountAndFlags);

    noOfBytesInField := JBIG2Ceil(4 + ((referredToSegmentCount + 1) / 8));

    noOfRententionFlagBytes := noOfBytesInField - 4;
    SetLength(retentionFlags, noOfRententionFlagBytes);
    reader.readByte(retentionFlags);
  end else
  begin
    // Error, 3 bit Segment count field = (referredToSegmentCount);
  end;

  segmentHeader.setReferredToSegmentCount(referredToSegmentCount);

  segmentHeader.setRententionFlags(retentionFlags);
end;

procedure TJBIG2StreamDecoder.movePointer(i: Integer);
begin
  reader.movePointer(i);
end;

function TJBIG2StreamDecoder.readBit: Integer;
begin
  Result := reader.readBit;
end;

function TJBIG2StreamDecoder.readBits(num: Integer): Integer;
begin
  Result := reader.readBits(num);
end;

function TJBIG2StreamDecoder.readByte: Smallint;
begin
  Result := reader.readByte;
end;

procedure TJBIG2StreamDecoder.readSegmentHeader(segmentHeader: TSegmentHeader);
begin
  handleSegmentNumber(segmentHeader);

  handleSegmentHeaderFlags(segmentHeader);

  if (not Reader.BufferOverrun) then
  begin

    handleSegmentReferredToCountAndRententionFlags(segmentHeader);

    handleReferedToSegmentNumbers(segmentHeader);

    handlePageAssociation(segmentHeader);

    if (segmentHeader.getSegmentType <> JBIG2_END_OF_FILE) then
    begin
      handleSegmentDataLength(segmentHeader);
    end;
  end;
end;

procedure TJBIG2StreamDecoder.readSegments;
var
  finished: Boolean;
  segmentHeader: TSegmentHeader;
  segment: TSegment;
  segmentType: Integer;
  referredToSegments: TJBIG2IntegerArray;
  noOfReferredToSegments: Integer;
  SegmentIndex: Integer;
begin
  finished := False;
  SetLength(referredToSegments, 0);
  while ((not reader.isFinished) and (not finished)) do
  begin
    segmentHeader := TSegmentHeader.Create;
    readSegmentHeader(segmentHeader);

    // read the Segment data
    segment := nil;

    segmentType := segmentHeader.getSegmentType;
    referredToSegments := segmentHeader.getReferredToSegments;
    noOfReferredToSegments := segmentHeader.getReferredToSegmentCount;

    case (segmentType) of
      JBIG2_SYMBOL_DICTIONARY:
      begin
        segment := TSymbolDictionarySegment.Create(Self);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_INTERMEDIATE_TEXT_REGION:
      begin
        segment := TTextRegionSegment.Create(Self, False);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_IMMEDIATE_TEXT_REGION:
      begin
        segment := TTextRegionSegment.Create(Self, True);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_IMMEDIATE_LOSSLESS_TEXT_REGION:
      begin
        segment := TTextRegionSegment.Create(Self, True);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_PATTERN_DICTIONARY:
      begin
        segment := TPatternDictionarySegment.Create(Self);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_INTERMEDIATE_HALFTONE_REGION:
      begin
        segment := THalftoneRegionSegment.Create(Self, False);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_IMMEDIATE_HALFTONE_REGION:
      begin
        segment := THalftoneRegionSegment.Create(Self, True);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_IMMEDIATE_LOSSLESS_HALFTONE_REGION:
      begin
        segment := THalftoneRegionSegment.Create(Self, True);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_INTERMEDIATE_GENERIC_REGION:
      begin
        segment := TGenericRegionSegment.Create(Self, False);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_IMMEDIATE_GENERIC_REGION:
      begin
        segment := TGenericRegionSegment.Create(Self, True);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_IMMEDIATE_LOSSLESS_GENERIC_REGION:
      begin
        segment := TGenericRegionSegment.Create(Self, True);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_INTERMEDIATE_GENERIC_REFINEMENT_REGION:
      begin
        segment := TRefinementRegionSegment.Create(Self, False, referredToSegments, noOfReferredToSegments);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_IMMEDIATE_GENERIC_REFINEMENT_REGION:
      begin
        segment := TRefinementRegionSegment.Create(Self, True, referredToSegments, noOfReferredToSegments);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_IMMEDIATE_LOSSLESS_GENERIC_REFINEMENT_REGION:
      begin
        segment := TRefinementRegionSegment.Create(Self, True, referredToSegments, noOfReferredToSegments);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_PAGE_INFORMATION:
      begin
        segment := TPageInformationSegment.Create(Self);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_END_OF_PAGE:
      begin
        Continue;
      end;

      JBIG2_END_OF_STRIPE:
      begin
        segment := TEndOfStripeSegment.Create(Self);
        segment.setSegmentHeader(segmentHeader);
      end;

      JBIG2_END_OF_FILE:
      begin
        Finished := true;
        Continue;
      end;

      JBIG2_PROFILES:
      begin
        // Not implemented
      end;

      JBIG2_TABLES:
      begin
        // Not implemented
      end;

      JBIG2_EXTENSION:
      begin
        segment := TExtensionSegment.Create(Self);
        segment.setSegmentHeader(segmentHeader);
      end;

    else
      // Unknown Segment type in JBIG2 stream
      segmentHeader.Free;
      finished := true;
    end;

    if (reader.BufferOverrun) then
      finished := true;

    if not(finished) then
    begin
      if (not randomAccessOrganisation) then
        segment.readSegment;

      segments.Add(segment)
    end;
  end;

  if (not finished) and (randomAccessOrganisation) then
  begin
    for SegmentIndex := 0 to segments.Count - 1 do
    begin
      segment := TSegment(segments[SegmentIndex]);
      segment.readSegment;
    end;
  end;
end;

procedure TJBIG2StreamDecoder.resetDecoder;
begin
  noOfPagesKnown := False;
  randomAccessOrganisation := False;

  noOfPages := -1;

  segments.Clear;
  bitmaps.Clear;
end;

procedure TJBIG2StreamDecoder.setFileHeaderFlags;
var
  headerFlags: Smallint;
  fileOrganisation: Integer;
  pagesKnown: Integer;
begin
  headerFlags := reader.readByte;

  if ((headerFlags and $fc) <> 0) then
  begin
    // Warning, reserved bits (2-7) of file header flags are not zero
  end;

  fileOrganisation := headerFlags and 1;
  randomAccessOrganisation := fileOrganisation = 0;

  pagesKnown := headerFlags and 2;
  noOfPagesKnown := pagesKnown = 0;
end;

procedure TJBIG2StreamDecoder.setGlobalData(data: TJBIG2ByteArray);
begin
  globalData := data;
end;

procedure TJBIG2StreamDecoder.handlePageAssociation(segmentHeader: TSegmentHeader);
var
  pageAssociation: Integer;
  isPageAssociationSizeSet: Boolean;
  buf: TJBIG2SmallintArray;
begin
  isPageAssociationSizeSet := segmentHeader.isPageAssociationSizeSet;
  if (isPageAssociationSizeSet) then
  begin
    // Field is 4 bytes long
    SetLength(buf, 4);
    reader.readByte(buf);
    pageAssociation := getInt32(buf);
  end else
  begin
    // Field is 1 byte long
    pageAssociation := reader.readByte();
  end;

  segmentHeader.setPageAssociation(pageAssociation);
end;

procedure TJBIG2StreamDecoder.handleSegmentDataLength(segmentHeader: TSegmentHeader);
var
  buf: TJBIG2SmallintArray;
  dataLength: Integer;
begin
  SetLength(buf, 4);
  reader.readByte(buf);

  dataLength := getInt32(buf);
  segmentHeader.setDataLength(dataLength);
end;

function TJBIG2StreamDecoder.findSegment(segmentNumber: Integer): TSegment;
var
  X: Integer;
  segment: TSegment;
begin
  Result := nil;
  for X := 0 to segments.Count - 1 do
  begin
    segment := TSegment(segments.Items[X]);
    if (segment.getSegmentHeader.getSegmentNumber = segmentNumber) then
    begin
      Result := segment;
      Exit;
    end;
  end;
end;

procedure TJBIG2StreamDecoder.readByte(buff: TJBIG2SmallintArray);
begin
  reader.readByte(buff);
end;

function TJBIG2StreamDecoder.findPageSegment(
  page: Integer): TPageInformationSegment;
var
  X: Integer;
  segment: TSegment;
  segmentHeader: TSegmentHeader;
begin
  Result := nil;
  for X := 0 to segments.Count - 1 do
  begin
    segment := TSegment(segments.Items[X]);
    segmentHeader := segment.getSegmentHeader;
    if ((segmentHeader.getSegmentType = JBIG2_PAGE_INFORMATION) and (segmentHeader.getPageAssociation = page)) then
    begin
      Result := TPageInformationSegment(segment);
      Exit;
    end;
  end;
end;

procedure TJBIG2StreamDecoder.appendBitmap(bitmap: TJBIG2Bitmap);
begin
  bitmaps.Add(bitmap);
end;

function TJBIG2StreamDecoder.findBitmap(bitmapNumber: Integer): TJBIG2Bitmap;
var
  X: Integer;
  bitmap: TJBIG2Bitmap;
begin
  Result := nil;
  for X := 0 to bitmaps.Count - 1 do
  begin
    bitmap := TJBIG2Bitmap(bitmaps.Items[X]);
    if (bitmap.getBitmapNumber = bitmapNumber) then
    begin
      Result := bitmap;
      Exit;
    end;
  end;
end;

function TJBIG2StreamDecoder.getPageAsJBIG2Bitmap(i: Integer): TJBIG2Bitmap;
begin
  Result := findPageSegment(1).getPageBitmap;
end;

function TJBIG2StreamDecoder.isNumberOfPagesKnown: Boolean;
begin
  Result := noOfPagesKnown;
end;

function TJBIG2StreamDecoder.getNumberOfPages: Integer;
begin
  Result := noOfPages;
end;

function TJBIG2StreamDecoder.isRandomAccessOrganisationUsed: Boolean;
begin
  Result := randomAccessOrganisation;
end;

function TJBIG2StreamDecoder.getAllSegments: TJBIG2List;
begin
  Result := segments;
end;


{ TSegment }

constructor TSegment.Create(streamDecoder: TJBIG2StreamDecoder);
begin
  decoder := streamDecoder;
  huffmanDecoder := decoder.getHuffmanDecoder;
  arithmeticDecoder := decoder.getArithmeticDecoder;
  mmrDecoder := decoder.getMMRDecoder;
end;

function TSegment.readATValue: Smallint;
var
  atValue: Smallint;
  c0: Smallint;
begin
  atValue := decoder.readByte;
  c0 := atValue;

  if ((c0 and $80) <> 0) then
  begin
    atValue := atValue or (-1 - $ff);
  end;

  Result := atValue;
end;

function TSegment.getSegmentHeader: TSegmentHeader;
begin
  Result := segmentHeader;
end;

procedure TSegment.setSegmentHeader(segmentHeader: TSegmentHeader);
begin
  Self.segmentHeader := segmentHeader;
end;

destructor TSegment.Destroy;
begin
  if Assigned(segmentHeader) then
  begin
    segmentHeader.Free;
  end;
  
  inherited;
end;


{ TPageInformationSegment }

constructor TPageInformationSegment.Create(
  streamDecoder: TJBIG2StreamDecoder);
begin
  inherited Create(streamDecoder);
  pageInformationFlags := TPageInformationFlags.Create;
  pageBitmap := nil;
end;

destructor TPageInformationSegment.Destroy;
begin
  pageInformationFlags.Free;
  inherited;
end;

function TPageInformationSegment.getPageInformationFlags: TPageInformationFlags;
begin
  Result := pageInformationFlags;
end;

procedure TPageInformationSegment.readSegment;
var
  buff: TJBIG2SmallintArray;
  pageInformationFlagsField: Smallint;
  defPix: Integer;
  height: Integer;
begin
  SetLength(buff, 4);
  decoder.readByte(buff);
  pageBitmapWidth := getInt32(buff);

  SetLength(buff, 4);
  decoder.readByte(buff);
  pageBitmapHeight := getInt32(buff);

  SetLength(buff, 4);
  decoder.readByte(buff);
  xResolution := getInt32(buff);

  SetLength(buff, 4);
  decoder.readByte(buff);
  yResolution := getInt32(buff);

  pageInformationFlagsField := decoder.readByte;
  pageInformationFlags.setFlags(pageInformationFlagsField);

  SetLength(buff, 2);
  decoder.readByte(buff);
  pageStriping := getInt16(buff);

  defPix := pageInformationFlags.getFlagValue(JBIG2_DEFAULT_PIXEL_VALUE);

  if (pageBitmapHeight = -1) then
  begin
    height := pageStriping and $7fff;
  end else
  begin
    height := pageBitmapHeight;
  end;

  pageBitmap := decoder.BitmapFactory.CreateBitmap(pageBitmapWidth, height, arithmeticDecoder, huffmanDecoder, mmrDecoder);
  pageBitmap.clear(defPix);
end;

function TPageInformationSegment.getPageBitmap: TJBIG2Bitmap;
begin
  Result := pageBitmap;
end;

function TPageInformationSegment.getPageBitmapHeight: Integer;
begin
  Result := pageBitmapHeight;
end;


{ TMMRDecoder }

const
  ccittEndOfLine = -2;
  
  twoDimensionalTable1: array[0..127, 0..1] of Integer =
    ((-1, -1), (-1, -1), (7, twoDimensionalVerticalL3),
    (7, twoDimensionalVerticalR3), (6, twoDimensionalVerticalL2),
    (6, twoDimensionalVerticalL2), (6, twoDimensionalVerticalR2),
    (6, twoDimensionalVerticalR2), (4, twoDimensionalPass),
    (4, twoDimensionalPass), (4, twoDimensionalPass),
    (4, twoDimensionalPass), (4, twoDimensionalPass),
    (4, twoDimensionalPass), (4, twoDimensionalPass),
    (4, twoDimensionalPass), (3, twoDimensionalHorizontal),
    (3, twoDimensionalHorizontal), (3, twoDimensionalHorizontal),
    (3, twoDimensionalHorizontal), (3, twoDimensionalHorizontal),
    (3, twoDimensionalHorizontal), (3, twoDimensionalHorizontal),
    (3, twoDimensionalHorizontal), (3, twoDimensionalHorizontal),
    (3, twoDimensionalHorizontal), (3, twoDimensionalHorizontal),
    (3, twoDimensionalHorizontal), (3, twoDimensionalHorizontal),
    (3, twoDimensionalHorizontal), (3, twoDimensionalHorizontal),
    (3, twoDimensionalHorizontal), (3, twoDimensionalVerticalL1),
    (3, twoDimensionalVerticalL1), (3, twoDimensionalVerticalL1),
    (3, twoDimensionalVerticalL1), (3, twoDimensionalVerticalL1),
    (3, twoDimensionalVerticalL1), (3, twoDimensionalVerticalL1),
    (3, twoDimensionalVerticalL1), (3, twoDimensionalVerticalL1),
    (3, twoDimensionalVerticalL1), (3, twoDimensionalVerticalL1),
    (3, twoDimensionalVerticalL1), (3, twoDimensionalVerticalL1),
    (3, twoDimensionalVerticalL1), (3, twoDimensionalVerticalL1),
    (3, twoDimensionalVerticalL1), (3, twoDimensionalVerticalR1),
    (3, twoDimensionalVerticalR1), (3, twoDimensionalVerticalR1),
    (3, twoDimensionalVerticalR1), (3, twoDimensionalVerticalR1),
    (3, twoDimensionalVerticalR1), (3, twoDimensionalVerticalR1),
    (3, twoDimensionalVerticalR1), (3, twoDimensionalVerticalR1),
    (3, twoDimensionalVerticalR1), (3, twoDimensionalVerticalR1),
    (3, twoDimensionalVerticalR1), (3, twoDimensionalVerticalR1),
    (3, twoDimensionalVerticalR1), (3, twoDimensionalVerticalR1),
    (3, twoDimensionalVerticalR1), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0), (1, twoDimensionalVertical0),
    (1, twoDimensionalVertical0));

  blackTable1: array[0..127, 0..1] of Integer = ((-1, -1), (-1, -1),
    (12, ccittEndOfLine), (12, ccittEndOfLine), (-1, -1), (-1, -1), (-1, -1),
    (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1),
    (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1),
    (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1),
    (-1, -1), (-1, -1), (-1, -1), (-1, -1), (11, 1792), (11, 1792), (11, 1792),
    (11, 1792), (12, 1984), (12, 1984), (12, 2048), (12, 2048), (12, 2112),
    (12, 2112), (12, 2176), (12, 2176), (12, 2240), (12, 2240), (12, 2304),
    (12, 2304), (11, 1856), (11, 1856), (11, 1856), (11, 1856), (11, 1920),
    (11, 1920), (11, 1920), (11, 1920), (12, 2368), (12, 2368), (12, 2432),
    (12, 2432), (12, 2496), (12, 2496), (12, 2560), (12, 2560), (10, 18),
    (10, 18), (10, 18), (10, 18), (10, 18), (10, 18), (10, 18), (10, 18),
    (12, 52), (12, 52), (13, 640), (13, 704), (13, 768), (13, 832), (12, 55),
    (12, 55), (12, 56), (12, 56), (13, 1280), (13, 1344), (13, 1408),
    (13, 1472), (12, 59), (12, 59), (12, 60), (12, 60), (13, 1536), (13, 1600),
    (11, 24), (11, 24), (11, 24), (11, 24), (11, 25), (11, 25), (11, 25),
    (11, 25), (13, 1664), (13, 1728), (12, 320), (12, 320), (12, 384),
    (12, 384), (12, 448), (12, 448), (13, 512), (13, 576), (12, 53), (12, 53),
    (12, 54), (12, 54), (13, 896), (13, 960), (13, 1024), (13, 1088),
    (13, 1152), (13, 1216), (10, 64), (10, 64), (10, 64), (10, 64), (10, 64),
    (10, 64), (10, 64), (10, 64));

  blackTable2: array[0..191, 0..1] of Integer = ((8, 13), (8, 13), (8, 13),
    (8, 13), (8, 13), (8, 13), (8, 13), (8, 13), (8, 13), (8, 13), (8, 13),
    (8, 13), (8, 13), (8, 13), (8, 13), (8, 13), (11, 23), (11, 23), (12, 50),
    (12, 51), (12, 44), (12, 45), (12, 46), (12, 47), (12, 57), (12, 58),
    (12, 61), (12, 256), (10, 16), (10, 16), (10, 16), (10, 16), (10, 17),
    (10, 17), (10, 17), (10, 17), (12, 48), (12, 49), (12, 62), (12, 63),
    (12, 30), (12, 31), (12, 32), (12, 33), (12, 40), (12, 41), (11, 22),
    (11, 22), (8, 14), (8, 14), (8, 14), (8, 14), (8, 14), (8, 14), (8, 14),
    (8, 14), (8, 14), (8, 14), (8, 14), (8, 14), (8, 14), (8, 14), (8, 14),
    (8, 14), (7, 10), (7, 10), (7, 10), (7, 10), (7, 10), (7, 10), (7, 10),
    (7, 10), (7, 10), (7, 10), (7, 10), (7, 10), (7, 10), (7, 10), (7, 10),
    (7, 10), (7, 10), (7, 10), (7, 10), (7, 10), (7, 10), (7, 10), (7, 10),
    (7, 10), (7, 10), (7, 10), (7, 10), (7, 10), (7, 10), (7, 10), (7, 10),
    (7, 10), (7, 11), (7, 11), (7, 11), (7, 11), (7, 11), (7, 11), (7, 11),
    (7, 11), (7, 11), (7, 11), (7, 11), (7, 11), (7, 11), (7, 11), (7, 11),
    (7, 11), (7, 11), (7, 11), (7, 11), (7, 11), (7, 11), (7, 11), (7, 11),
    (7, 11), (7, 11), (7, 11), (7, 11), (7, 11), (7, 11), (7, 11), (7, 11),
    (7, 11), (9, 15), (9, 15), (9, 15), (9, 15), (9, 15), (9, 15), (9, 15),
    (9, 15), (12, 128), (12, 192), (12, 26), (12, 27), (12, 28), (12, 29),
    (11, 19), (11, 19), (11, 20), (11, 20), (12, 34), (12, 35), (12, 36),
    (12, 37), (12, 38), (12, 39), (11, 21), (11, 21), (12, 42), (12, 43),
    (10, 0), (10, 0), (10, 0), (10, 0), (7, 12), (7, 12), (7, 12), (7, 12),
    (7, 12), (7, 12), (7, 12), (7, 12), (7, 12), (7, 12), (7, 12), (7, 12),
    (7, 12), (7, 12), (7, 12), (7, 12), (7, 12), (7, 12), (7, 12), (7, 12),
    (7, 12), (7, 12), (7, 12), (7, 12), (7, 12), (7, 12), (7, 12), (7, 12),
    (7, 12), (7, 12), (7, 12), (7, 12));

  blackTable3: array[0..63, 0..1] of Integer = ((-1, -1), (-1, -1), (-1, -1),
    (-1, -1), (6, 9), (6, 8), (5, 7), (5, 7), (4, 6), (4, 6), (4, 6), (4, 6),
    (4, 5), (4, 5), (4, 5), (4, 5), (3, 1), (3, 1), (3, 1), (3, 1), (3, 1),
    (3, 1), (3, 1), (3, 1), (3, 4), (3, 4), (3, 4), (3, 4), (3, 4), (3, 4),
    (3, 4), (3, 4), (2, 3), (2, 3), (2, 3), (2, 3), (2, 3), (2, 3), (2, 3),
    (2, 3), (2, 3), (2, 3), (2, 3), (2, 3), (2, 3), (2, 3), (2, 3), (2, 3),
    (2, 2), (2, 2), (2, 2), (2, 2), (2, 2), (2, 2), (2, 2), (2, 2), (2, 2),
    (2, 2), (2, 2), (2, 2), (2, 2), (2, 2), (2, 2), (2, 2));

  whiteTable1: array[0..31, 0..1] of Integer = ((-1, -1), (12, ccittEndOfLine),
    (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1),
    (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1), (-1, -1),
    (11, 1792), (11, 1792), (12, 1984), (12, 2048), (12, 2112), (12, 2176),
    (12, 2240), (12, 2304), (11, 1856), (11, 1856), (11, 1920), (11, 1920),
    (12, 2368), (12, 2432), (12, 2496), (12, 2560));

  whiteTable2: array[0..511, 0..1] of Integer = ((-1, -1), (-1, -1), (-1, -1),
    (-1, -1), (8, 29), (8, 29), (8, 30), (8, 30), (8, 45), (8, 45), (8, 46),
    (8, 46), (7, 22), (7, 22), (7, 22), (7, 22), (7, 23), (7, 23), (7, 23),
    (7, 23), (8, 47), (8, 47), (8, 48), (8, 48), (6, 13), (6, 13), (6, 13),
    (6, 13), (6, 13), (6, 13), (6, 13), (6, 13), (7, 20), (7, 20), (7, 20),
    (7, 20), (8, 33), (8, 33), (8, 34), (8, 34), (8, 35), (8, 35), (8, 36),
    (8, 36), (8, 37), (8, 37), (8, 38), (8, 38), (7, 19), (7, 19), (7, 19),
    (7, 19), (8, 31), (8, 31), (8, 32), (8, 32), (6, 1), (6, 1), (6, 1),
    (6, 1), (6, 1), (6, 1), (6, 1), (6, 1), (6, 12), (6, 12), (6, 12), (6, 12),
    (6, 12), (6, 12), (6, 12), (6, 12), (8, 53), (8, 53), (8, 54), (8, 54),
    (7, 26), (7, 26), (7, 26), (7, 26), (8, 39), (8, 39), (8, 40), (8, 40),
    (8, 41), (8, 41), (8, 42), (8, 42), (8, 43), (8, 43), (8, 44), (8, 44),
    (7, 21), (7, 21), (7, 21), (7, 21), (7, 28), (7, 28), (7, 28), (7, 28),
    (8, 61), (8, 61), (8, 62), (8, 62), (8, 63), (8, 63), (8, 0), (8, 0),
    (8, 320), (8, 320), (8, 384), (8, 384), (5, 10), (5, 10), (5, 10),
    (5, 10), (5, 10), (5, 10), (5, 10), (5, 10), (5, 10), (5, 10), (5, 10),
    (5, 10), (5, 10), (5, 10), (5, 10), (5, 10), (5, 11), (5, 11), (5, 11),
    (5, 11), (5, 11), (5, 11), (5, 11), (5, 11), (5, 11), (5, 11), (5, 11),
    (5, 11), (5, 11), (5, 11), (5, 11), (5, 11), (7, 27), (7, 27), (7, 27),
    (7, 27), (8, 59), (8, 59), (8, 60), (8, 60), (9, 1472), (9, 1536),
    (9, 1600), (9, 1728), (7, 18), (7, 18), (7, 18), (7, 18), (7, 24),
    (7, 24), (7, 24), (7, 24), (8, 49), (8, 49), (8, 50), (8, 50), (8, 51),
    (8, 51), (8, 52), (8, 52), (7, 25), (7, 25), (7, 25), (7, 25), (8, 55),
    (8, 55), (8, 56), (8, 56), (8, 57), (8, 57), (8, 58), (8, 58), (6, 192),
    (6, 192), (6, 192), (6, 192), (6, 192), (6, 192), (6, 192), (6, 192),
    (6, 1664), (6, 1664), (6, 1664), (6, 1664), (6, 1664), (6, 1664),
    (6, 1664), (6, 1664), (8, 448), (8, 448), (8, 512), (8, 512), (9, 704),
    (9, 768), (8, 640), (8, 640), (8, 576), (8, 576), (9, 832), (9, 896),
    (9, 960), (9, 1024), (9, 1088), (9, 1152), (9, 1216), (9, 1280), (9, 1344),
    (9, 1408), (7, 256), (7, 256), (7, 256), (7, 256), (4, 2), (4, 2), (4, 2),
    (4, 2), (4, 2), (4, 2), (4, 2), (4, 2), (4, 2), (4, 2), (4, 2), (4, 2),
    (4, 2), (4, 2), (4, 2), (4, 2), (4, 2), (4, 2), (4, 2), (4, 2), (4, 2),
    (4, 2), (4, 2), (4, 2), (4, 2), (4, 2), (4, 2), (4, 2), (4, 2), (4, 2),
    (4, 2), (4, 2), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3),
    (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3),
    (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3),
    (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (4, 3), (5, 128),
    (5, 128), (5, 128), (5, 128), (5, 128), (5, 128), (5, 128), (5, 128),
    (5, 128), (5, 128), (5, 128), (5, 128), (5, 128), (5, 128), (5, 128),
    (5, 128), (5, 8), (5, 8), (5, 8), (5, 8), (5, 8), (5, 8), (5, 8), (5, 8),
    (5, 8), (5, 8), (5, 8), (5, 8), (5, 8), (5, 8), (5, 8), (5, 8), (5, 9),
    (5, 9), (5, 9), (5, 9), (5, 9), (5, 9), (5, 9), (5, 9), (5, 9), (5, 9),
    (5, 9), (5, 9), (5, 9), (5, 9), (5, 9), (5, 9), (6, 16), (6, 16), (6, 16),
    (6, 16), (6, 16), (6, 16), (6, 16), (6, 16), (6, 17), (6, 17), (6, 17),
    (6, 17), (6, 17), (6, 17), (6, 17), (6, 17), (4, 4), (4, 4), (4, 4),
    (4, 4), (4, 4), (4, 4), (4, 4), (4, 4), (4, 4), (4, 4), (4, 4), (4, 4),
    (4, 4), (4, 4), (4, 4), (4, 4), (4, 4), (4, 4), (4, 4), (4, 4), (4, 4),
    (4, 4), (4, 4), (4, 4), (4, 4), (4, 4), (4, 4), (4, 4), (4, 4), (4, 4),
    (4, 4), (4, 4), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5),
    (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5),
    (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5),
    (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (4, 5), (6, 14), (6, 14),
    (6, 14), (6, 14), (6, 14), (6, 14), (6, 14), (6, 14), (6, 15), (6, 15),
    (6, 15), (6, 15), (6, 15), (6, 15), (6, 15), (6, 15), (5, 64), (5, 64),
    (5, 64), (5, 64), (5, 64), (5, 64), (5, 64), (5, 64), (5, 64), (5, 64),
    (5, 64), (5, 64), (5, 64), (5, 64), (5, 64), (5, 64), (4, 6), (4, 6),
    (4, 6), (4, 6), (4, 6), (4, 6), (4, 6), (4, 6), (4, 6), (4, 6), (4, 6),
    (4, 6), (4, 6), (4, 6), (4, 6), (4, 6), (4, 6), (4, 6), (4, 6), (4, 6),
    (4, 6), (4, 6), (4, 6), (4, 6), (4, 6), (4, 6), (4, 6), (4, 6), (4, 6),
    (4, 6), (4, 6), (4, 6), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7),
    (4, 7), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7),
    (4, 7), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7),
    (4, 7), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7), (4, 7));

constructor TMMRDecoder.Create(reader: TStreamReader);
begin
  Self.reader := reader;
  Initialize;
end;

function TMMRDecoder.get24Bits: Int64;
begin
  while (bufferLength < 24) do
  begin
    buffer := ((bit32Shift(buffer, 8, LEFT_SHIFT)) or (reader.readByte and $ff));
    Inc(bufferLength, 8);
    Inc(noOfBytesRead);
  end;

  Result := (bit32Shift(buffer, Integer(bufferLength - 24), RIGHT_SHIFT)) and $ffffff;
end;

function TMMRDecoder.get2DCode: Integer;
var
  TupleIndex: Integer;
  lookup: Integer;
  right: Integer;
  left: Int64;
  look: Integer;
begin
  if (bufferLength = 0) then
  begin
    buffer := (reader.readByte and $ff);
    bufferLength := 8;
    Inc(noOfBytesRead);
    lookup := Integer(((bit32Shift(buffer, 1, RIGHT_SHIFT)) and $7f));
    TupleIndex := lookup;
  end else
  if (bufferLength = 8) then
  begin
    lookup := Integer(((bit32Shift(buffer, 1, RIGHT_SHIFT)) and $7f));
    TupleIndex := lookup;
  end else
  begin
    lookup := Integer(((bit32Shift(buffer, Integer(7 - bufferLength), LEFT_SHIFT)) and $7f));
    TupleIndex := lookup;
    if ((twoDimensionalTable1[TupleIndex][0] < 0) or (twoDimensionalTable1[TupleIndex][0] > Integer(bufferLength))) then
    begin
      right := (reader.readByte() and $ff);
      left := (bit32Shift(buffer, 8, LEFT_SHIFT));

      buffer := left or right;
      Inc(bufferLength, 8);
      Inc(noOfBytesRead);

      look := Integer((bit32Shift(buffer, Integer(bufferLength - 7), RIGHT_SHIFT) and $7f));

      TupleIndex := look;
    end;
  end;

  if (twoDimensionalTable1[TupleIndex][0] < 0) then
  begin
    // Bad two dim code in JBIG2 MMR stream
    Result := 0;
  end else
  begin
    Dec(bufferLength, twoDimensionalTable1[TupleIndex][0]);
    Result := twoDimensionalTable1[TupleIndex][1];
  end;
end;

function TMMRDecoder.getBlackCode: Integer;
var
  TupleTable: Integer;
  TupleIndex: Integer;
  Tuple0: Integer;
  Tuple1: Integer;
  code: Int64;
  KeepLooping: Boolean;
  lookup: Integer;
begin
  if (bufferLength = 0) then
  begin
    buffer := (reader.readByte() and $ff);
    bufferLength := 8;
    Inc(noOfBytesRead);
  end;

  KeepLooping := True;
  while (KeepLooping) do
  begin
    if ((bufferLength >= 6) and (((bit32Shift(buffer, Integer(bufferLength - 6), RIGHT_SHIFT)) and $3f) = 0)) then
    begin
      if (bufferLength <= 13) then
      begin
        code := bit32Shift(buffer, Integer(13 - bufferLength), LEFT_SHIFT);
      end else
      begin
        code := bit32Shift(buffer, Integer(bufferLength - 13), RIGHT_SHIFT);
      end;

      TupleTable := 1;
      TupleIndex := Integer(code and $7f);
    end else
    if ((bufferLength >= 4) and (((buffer shr (bufferLength - 4)) and $0f) = 0)) then
    begin
      if (bufferLength <= 12) then
      begin
        code := bit32Shift(buffer, Integer(12 - bufferLength), LEFT_SHIFT);
      end else
      begin
        code := bit32Shift(buffer, Integer(bufferLength - 12), RIGHT_SHIFT);
      end;

      lookup := Integer((code and $ff) - 64);
      if (lookup >= 0) then
      begin
        TupleTable := 2;
        TupleIndex := lookup;
      end else
      begin
        TupleTable := 1;
        TupleIndex := 128 + lookup;
      end;
    end else
    begin
      if (bufferLength <= 6) then
      begin
        code := bit32Shift(buffer, Integer(6 - bufferLength), LEFT_SHIFT);
      end else
      begin
        code := bit32Shift(buffer, Integer(bufferLength - 6), RIGHT_SHIFT);
      end;

      lookup := Integer(code and $3f);
      if (lookup >= 0) then
      begin
        TupleTable := 3;
        TupleIndex := lookup;
      end else
      begin
        TupleTable := 2;
        TupleIndex := 192 + lookup;
      end;
    end;

    if TupleTable = 1 then
    begin
      Tuple0 := blackTable1[TupleIndex][0];
      Tuple1 := blackTable1[TupleIndex][1];
    end else
    if TupleTable = 2 then
    begin
      Tuple0 := blackTable2[TupleIndex][0];
      Tuple1 := blackTable2[TupleIndex][1];
    end else
    begin
      Tuple0 := blackTable3[TupleIndex][0];
      Tuple1 := blackTable3[TupleIndex][1];
    end;

    if ((Tuple0 > 0) and (Tuple0 <= Integer(bufferLength))) then
    begin
      Dec(bufferLength, Tuple0);
      Result := Tuple1;
      Exit;
    end;

    if (bufferLength >= 13) then
    begin
      KeepLooping := False;
    end else
    begin
      buffer := ((bit32Shift(buffer, 8, LEFT_SHIFT)) or (reader.readByte and $ff));
      Inc(bufferLength, 8);
      Inc(noOfBytesRead);
    end;
  end;

  // Bad black code in JBIG2 MMR stream

  Dec(bufferLength);
  Result := 1;
end;

function TMMRDecoder.getWhiteCode: Integer;
var
  TupleTable: Integer;
  TupleIndex: Integer;
  code: Int64;
  lookup: Integer;
  KeepLooping: Boolean;
  Tuple0: Integer;
  Tuple1: Integer;
begin
  if (bufferLength = 0) then
  begin
    buffer := (reader.readByte and $ff);
    bufferLength := 8;
    Inc(noOfBytesRead);
  end;

  KeepLooping := True;
  while (KeepLooping) do
  begin
    if ((bufferLength >= 7) and (((bit32Shift(buffer, Integer(bufferLength - 7), RIGHT_SHIFT)) and $7f) = 0)) then
    begin
      if (bufferLength <= 12) then
      begin
        code := bit32Shift(buffer, Integer(12 - bufferLength), LEFT_SHIFT);
      end else
      begin
        code := bit32Shift(buffer, Integer(bufferLength - 12), RIGHT_SHIFT);
      end;

      TupleTable := 1;
      TupleIndex := Integer(code and $1f);
    end else
    begin
      if (bufferLength <= 9) then
      begin
        code := bit32Shift(buffer, Integer(9 - bufferLength), LEFT_SHIFT);
      end else
      begin
        code := bit32Shift(buffer, Integer(bufferLength - 9), RIGHT_SHIFT);
      end;

      lookup := Integer(code and $1ff);
      if (lookup >= 0) then
      begin
        TupleTable := 2;
        TupleIndex := lookup;
      end else
      begin
        TupleTable := 2;
        TupleIndex := 512 + lookup;
      end;
    end;

    if TupleTable = 1 then
    begin
      Tuple0 := whiteTable1[TupleIndex][0];
      Tuple1 := whiteTable1[TupleIndex][1];
    end else
    begin
      Tuple0 := whiteTable2[TupleIndex][0];
      Tuple1 := whiteTable2[TupleIndex][1];
    end;

    if ((Tuple0 > 0) and (tuple0 <= Integer(bufferLength))) then
    begin
      Dec(bufferLength, tuple0);
      Result := Tuple1;
      Exit;
    end;

    if (bufferLength >= 12) then
    begin
      KeepLooping := False;
    end else
    begin
      buffer := ((bit32Shift(buffer, 8, LEFT_SHIFT)) or (reader.readByte and $ff));
      Inc(bufferLength, 8);
      Inc(noOfBytesRead);
    end;
  end;

  // Bad white code in JBIG2 MMR stream

  Dec(bufferLength);
  Result := 1;
end;

procedure TMMRDecoder.Initialize;
begin
  bufferLength := 0;
  noOfBytesRead := 0;
  buffer := 0;
end;

procedure TMMRDecoder.reset;
begin
  bufferLength := 0;
  noOfBytesRead := 0;
  buffer := 0;
end;

procedure TMMRDecoder.skipTo(length: Integer);
begin
  while (noOfBytesRead < length) do
  begin
    reader.readByte;
    Inc(noOfBytesRead);
  end;
end;


{ TPageInformationFlags }

procedure TPageInformationFlags.setFlags(flagsAsInt: Integer);
begin
  Self.flagsAsInt := flagsAsInt;

  flags.AddObject(JBIG2_DEFAULT_PIXEL_VALUE, TObject((flagsAsInt shr 2) and 1));
  flags.AddObject(JBIG2_DEFAULT_COMBINATION_OPERATOR, TObject((flagsAsInt shr 3) and 3));
end;


{ TPatternDictionaryFlags }

procedure TPatternDictionaryFlags.setFlags(flagsAsInt: Integer);
begin
  Self.flagsAsInt := flagsAsInt;
  flags.AddObject(JBIG2_HD_MMR, TObject(flagsAsInt and 1));
  flags.AddObject(JBIG2_HD_TEMPLATE, TObject((flagsAsInt shr 1) and 3));
end;


{ TPatternDictionarySegment }

constructor TPatternDictionarySegment.Create(
  streamDecoder: TJBIG2StreamDecoder);
begin
  inherited Create(streamDecoder);
  patternDictionaryFlags := TPatternDictionaryFlags.Create;
end;

destructor TPatternDictionarySegment.Destroy;
begin
  patternDictionaryFlags.Free;
  inherited;
end;

function TPatternDictionarySegment.getBitmaps: TJBIG2BitmapArray;
begin
  Result := bitmaps;
end;

function TPatternDictionarySegment.getPatternDictionaryFlags: TPatternDictionaryFlags;
begin
  Result := patternDictionaryFlags;
end;

function TPatternDictionarySegment.getSize: Integer;
begin
  Result := size;
end;

procedure TPatternDictionarySegment.readPatternDictionaryFlags;
var
  patternDictionaryFlagsField: Smallint;
begin
  patternDictionaryFlagsField := decoder.readByte;
  patternDictionaryFlags.setFlags(patternDictionaryFlagsField);
end;

procedure TPatternDictionarySegment.readSegment;
var
  buf: TJBIG2SmallintArray;
  useMMR: Boolean;
  template: Integer;
  genericBAdaptiveTemplateX: TJBIG2SmallintArray;
  genericBAdaptiveTemplateY: TJBIG2SmallintArray;
  bitmap: TJBIG2Bitmap;
  x: Integer;
  i: Integer;
begin
  // read text region Segment flags
  readPatternDictionaryFlags();

  width := decoder.readByte;
  height := decoder.readByte;

  SetLength(buf, 4);
  decoder.readByte(buf);
  grayMax := getInt32(buf);

  useMMR := patternDictionaryFlags.getFlagValue(JBIG2_HD_MMR) = 1;
  template := patternDictionaryFlags.getFlagValue(JBIG2_HD_TEMPLATE);

  if (not useMMR) then
  begin
    arithmeticDecoder.resetGenericStats(template, nil);
    arithmeticDecoder.start;
  end;

  SetLength(genericBAdaptiveTemplateX, 4);
  SetLength(genericBAdaptiveTemplateY, 4);

  genericBAdaptiveTemplateX[0] := Smallint(-width);
  genericBAdaptiveTemplateY[0] := 0;
  genericBAdaptiveTemplateX[1] := -3;
  genericBAdaptiveTemplateY[1] := -1;
  genericBAdaptiveTemplateX[2] := 2;
  genericBAdaptiveTemplateY[2] := -2;
  genericBAdaptiveTemplateX[3] := -2;
  genericBAdaptiveTemplateY[3] := -2;

  size := grayMax + 1;

  bitmap := decoder.BitmapFactory.CreateBitmap(size * width, height, arithmeticDecoder, huffmanDecoder, mmrDecoder);
  bitmap.clear(0);
  bitmap.readBitmap(useMMR, template, False, False, nil, genericBAdaptiveTemplateX, genericBAdaptiveTemplateY, segmentHeader.getSegmentDataLength - 7);

  SetLength(bitmaps, size);

  x := 0;
  for i := 0 to size - 1 do
  begin
    bitmaps[i] := bitmap.getSlice(x, 0, width, height);
    Inc(x, width);
  end;
end;


{ TRefinementRegionFlags }

procedure TRefinementRegionFlags.setFlags(flagsAsInt: Integer);
begin
  Self.flagsAsInt := flagsAsInt;
  flags.AddObject(JBIG2_GR_TEMPLATE, TObject(flagsAsInt and 1));
  flags.AddObject(JBIG2_TPGDON, TObject((flagsAsInt shr 1) and 1));
end;


{ TRefinementRegionSegment }

constructor TRefinementRegionSegment.Create(
  streamDecoder: TJBIG2StreamDecoder; inlineImage: Boolean;
  referedToSegments: TJBIG2IntegerArray; noOfReferedToSegments: Integer);
begin
  inherited Create(streamDecoder);
  Self.inlineImage := inlineImage;
  Self.referedToSegments := referedToSegments;
  Self.noOfReferedToSegments := noOfReferedToSegments;
  refinementRegionFlags := TRefinementRegionFlags.Create;
end;

destructor TRefinementRegionSegment.Destroy;
begin
  refinementRegionFlags.Free;
  inherited;
end;

function TRefinementRegionSegment.getRefinementRegionFlags: TRefinementRegionFlags;
begin
  Result := refinementRegionFlags;
end;

procedure TRefinementRegionSegment.readGenericRegionFlags;
var
  refinementRegionFlagsField: Smallint;
begin
  refinementRegionFlagsField := decoder.readByte;
  refinementRegionFlags.setFlags(refinementRegionFlagsField);
end;

procedure TRefinementRegionSegment.readSegment;
var
  genericRegionAdaptiveTemplateX: TJBIG2SmallIntArray;
  genericRegionAdaptiveTemplateY: TJBIG2SmallIntArray;
  template: Integer;
  pageSegment: TPageInformationSegment;
  pageBitmap: TJBIG2Bitmap;
  referedToBitmap: TJBIG2Bitmap;
  typicalPredictionGenericRefinementOn: Boolean;
  bitmap: TJBIG2Bitmap;
  extCombOp: Integer;
begin
  inherited readSegment;

  readGenericRegionFlags;

  SetLength(genericRegionAdaptiveTemplateX, 2);
  SetLength(genericRegionAdaptiveTemplateY, 2);

  template := refinementRegionFlags.getFlagValue(JBIG2_GR_TEMPLATE);
  if (template = 0) then
  begin
    genericRegionAdaptiveTemplateX[0] := readATValue;
    genericRegionAdaptiveTemplateY[0] := readATValue;
    genericRegionAdaptiveTemplateX[1] := readATValue;
    genericRegionAdaptiveTemplateY[1] := readATValue;
  end;

  if ((noOfReferedToSegments = 0) or inlineImage) then
  begin
    pageSegment := decoder.findPageSegment(segmentHeader.getPageAssociation);
    pageBitmap := pageSegment.getPageBitmap;

    if ((pageSegment.getPageBitmapHeight = -1) and ((regionBitmapYLocation + regionBitmapHeight) > pageBitmap.getHeight)) then
    begin
      pageBitmap.expand(regionBitmapYLocation + regionBitmapHeight, pageSegment.getPageInformationFlags.getFlagValue(JBIG2_DEFAULT_PIXEL_VALUE));
    end;
  end;

  if (noOfReferedToSegments > 1) then
  begin
    // Bad reference in JBIG2 generic refinement Segment
    Exit;
  end;

  if (noOfReferedToSegments = 1) then
  begin
    referedToBitmap := decoder.findBitmap(referedToSegments[0]);
  end else
  begin
    pageSegment := decoder.findPageSegment(segmentHeader.getPageAssociation);
    pageBitmap := pageSegment.getPageBitmap;
    referedToBitmap := pageBitmap.getSlice(regionBitmapXLocation, regionBitmapYLocation, regionBitmapWidth, regionBitmapHeight);
  end;

  arithmeticDecoder.resetRefinementStats(template, nil);
  arithmeticDecoder.start;

  typicalPredictionGenericRefinementOn := refinementRegionFlags.getFlagValue(JBIG2_TPGDON) <> 0;

  bitmap := decoder.BitmapFactory.CreateBitmap(regionBitmapWidth, regionBitmapHeight, arithmeticDecoder, huffmanDecoder, mmrDecoder);

  bitmap.readGenericRefinementRegion(template, typicalPredictionGenericRefinementOn, referedToBitmap, 0, 0, genericRegionAdaptiveTemplateX, genericRegionAdaptiveTemplateY);

  if (inlineImage) then
  begin
    pageSegment := decoder.findPageSegment(segmentHeader.getPageAssociation);
    pageBitmap := pageSegment.getPageBitmap;

    extCombOp := regionFlags.getFlagValue(JBIG2_EXTERNAL_COMBINATION_OPERATOR);

    pageBitmap.combine(bitmap, regionBitmapXLocation, regionBitmapYLocation, extCombOp);
  end else
  begin
    bitmap.setBitmapNumber(getSegmentHeader.getSegmentNumber);
    decoder.appendBitmap(bitmap);
  end;
end;


{ TRegionFlags }

procedure TRegionFlags.setFlags(flagsAsInt: Integer);
begin
  Self.flagsAsInt := flagsAsInt;
  flags.AddObject(JBIG2_EXTERNAL_COMBINATION_OPERATOR, TObject(flagsAsInt and 7));
end;

{ TRegionSegment }

constructor TRegionSegment.Create(streamDecoder: TJBIG2StreamDecoder);
begin
  inherited Create(streamDecoder);
  regionFlags := TRegionFlags.Create;
end;

destructor TRegionSegment.Destroy;
begin
  regionFlags.Free;
  inherited;
end;

procedure TRegionSegment.readSegment;
var
  buff: TJBIG2SmallintArray;
  regionFlagsField: Smallint;
begin
  SetLength(buff, 4);
  decoder.readByte(buff);
  regionBitmapWidth := getInt32(buff);

  SetLength(buff, 4);
  decoder.readByte(buff);
  regionBitmapHeight := getInt32(buff);

  SetLength(buff, 4);
  decoder.readByte(buff);
  regionBitmapXLocation := getInt32(buff);

  SetLength(buff, 4);
  decoder.readByte(buff);
  regionBitmapYLocation := getInt32(buff);

  regionFlagsField := decoder.readByte;
  regionFlags.setFlags(regionFlagsField);
end;


{ TSegmentHeader }

procedure TSegmentHeader.setSegmentHeaderFlags(
  segmentHeaderFlags: Smallint);
begin
  segmentType := segmentHeaderFlags and 63;
  pageAssociationSizeSet := (segmentHeaderFlags and 64) = 64;
  deferredNonRetainSet := (SegmentHeaderFlags and 80) = 80;
end;

procedure TSegmentHeader.setSegmentNumber(segmentNumber: Integer);
begin
  Self.segmentNumber := segmentNumber;
end;

procedure TSegmentHeader.setReferredToSegmentCount(referredToSegmentCount: Integer);
begin
  Self.referredToSegmentCount := referredToSegmentCount;
end;

procedure TSegmentHeader.setRententionFlags(rententionFlags: TJBIG2SmallintArray);
begin
  Self.rententionFlags := rententionFlags;
end;

procedure TSegmentHeader.setReferredToSegments(referredToSegments: TJBIG2IntegerArray);
begin
  Self.referredToSegments := referredToSegments;
end;

function TSegmentHeader.getReferredToSegments: TJBIG2IntegerArray;
begin
  Result := referredToSegments;
end;

function TSegmentHeader.getSegmentType: Integer;
begin
  Result := segmentType;
end;

function TSegmentHeader.getSegmentNumber: Integer;
begin
  Result := segmentNumber;
end;

function TSegmentHeader.isPageAssociationSizeSet: Boolean;
begin
  Result := pageAssociationSizeSet;
end;

function TSegmentHeader.isDeferredNonRetainSet: Boolean;
begin
  Result := deferredNonRetainSet;
end;

function TSegmentHeader.getReferredToSegmentCount: Integer;
begin
  Result := referredToSegmentCount;
end;

function TSegmentHeader.getRententionFlags: TJBIG2SmallintArray;
begin
  Result := rententionFlags;
end;

function TSegmentHeader.getPageAssociation: Integer;
begin
  Result := pageAssociation;
end;

procedure TSegmentHeader.setPageAssociation(pageAssociation: Integer);
begin
  Self.pageAssociation := pageAssociation;
end;

procedure TSegmentHeader.setDataLength(dataLength: Integer);
begin
  Self.dataLength := dataLength;
end;

procedure TSegmentHeader.setSegmentType(segmentType: Integer);
begin
  Self.segmentType := segmentType;
end;

function TSegmentHeader.getSegmentDataLength: Integer;
begin
  Result := dataLength;
end;


{ TStreamReader }

constructor TStreamReader.Create(data: TJBIG2ByteArray);
begin
  Self.data := data;
  bitPointer := 7;
  bytePointer := 0;
  BufferOverrun := false;                                                       // ADC
end;

procedure TStreamReader.movePointer(amount: Integer);
begin
  Inc(bytePointer, amount);
end;

function TStreamReader.readBit: Integer;
var
  buf: Smallint;
  mask: Smallint;
  bit: Integer;
begin
  buf := readByte;
  mask := Smallint(1 shl bitPointer);

  bit := (buf and mask) shr bitPointer;

  Dec(bitPointer);
  if (bitPointer = -1) then
  begin
    bitPointer := 7;
  end else
  begin
    movePointer(-1);
  end;

  Result := bit;
end;

function TStreamReader.readBits(num: Integer): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to num - 1 do
  begin
    Result := (Result shl 1) or readBit;
  end;
end;

function TStreamReader.readByte: Smallint;
begin
  Result := 0;
  if (bytePointer < Length(Data)) then
  begin
    Result := Smallint(data[bytePointer] and 255);
    Inc(bytePointer);
  end
  else
    BufferOverrun := true;
end;

procedure TStreamReader.consumeRemainingBits;
begin
  if (bitPointer <> 7) then
  begin
    readBits(bitPointer + 1);
  end;
end;

function TStreamReader.isFinished: Boolean;
begin
  Result := bytePointer = Length(data);
end;

procedure TStreamReader.readByte(buf: TJBIG2SmallintArray);
var
  i: Integer;
begin

  for i := 0 to Length(buf) - 1 do
  begin
    if (BytePointer < Length(Data)) then
      buf[i] := Smallint(data[bytePointer] and 255)
    else
      BufferOverrun := true;

    Inc(bytePointer);
  end;
end;


{ TSymbolDictionaryFlags }

procedure TSymbolDictionaryFlags.setFlags(flagsAsInt: Integer);
begin
  Self.flagsAsInt := flagsAsInt;
  flags.AddObject(JBIG2_SD_HUFF, TObject(flagsAsInt and 1));
  flags.AddObject(JBIG2_SD_REF_AGG, TObject((flagsAsInt shr 1) and 1));
  flags.AddObject(JBIG2_SD_HUFF_DH, TObject((flagsAsInt shr 2) and 3));
  flags.AddObject(JBIG2_SD_HUFF_DW, TObject((flagsAsInt shr 4) and 3));
  flags.AddObject(JBIG2_SD_HUFF_BM_SIZE, TObject((flagsAsInt shr 6) and 1));
  flags.AddObject(JBIG2_SD_HUFF_AGG_INST, TObject((flagsAsInt shr 7) and 1));
  flags.AddObject(JBIG2_BITMAP_CC_USED, TObject((flagsAsInt shr 8) and 1));
  flags.AddObject(JBIG2_BITMAP_CC_RETAINED, TObject((flagsAsInt shr 9) and 1));
  flags.AddObject(JBIG2_SD_TEMPLATE, TObject((flagsAsInt shr 10) and 3));
  flags.AddObject(JBIG2_SD_R_TEMPLATE, TObject((flagsAsInt shr 12) and 1));
end;


{ TSymbolDictionarySegment }

constructor TSymbolDictionarySegment.Create(
  streamDecoder: TJBIG2StreamDecoder);
begin
  inherited Create(streamDecoder);
  SetLength(symbolDictionaryAdaptiveTemplateX, 4);
  SetLength(symbolDictionaryAdaptiveTemplateY, 4);
  symbolDictionaryFlags := TSymbolDictionaryFlags.Create;
end;

procedure TSymbolDictionarySegment.readSegment;
var
  codeTables: TJBIG2List;
  numberOfInputSymbols: Integer;
  noOfReferredToSegments: Integer;
  referredToSegments: TJBIG2IntegerArray;
  i: Integer;
  k: Integer;
  j: Integer;
  x: Integer;
  seg: TSegment;
  segType: Integer;
  symbolCodeLength: Integer;
  bitmaps: array of TJBIG2Bitmap;
  inputSymbolDictionary: TSymbolDictionarySegment;
  huffmanDHTable: THuffmanTableArray;
  huffmanDWTable: THuffmanTableArray;
  huffmanBMSizeTable: THuffmanTableArray;
  huffmanAggInstTable: THuffmanTableArray;
  sdHuffman: Boolean;
  sdHuffmanDifferenceHeight: Integer;
  sdHuffmanDiferrenceWidth: Integer;
  sdHuffBitmapSize: Integer;
  sdHuffAggregationInstances: Integer;
  contextUsed: Integer;
  sdTemplate: Integer;
  sdRefinementAggregate: Integer;
  sdRefinementTemplate: Integer;
  deltaWidths: TJBIG2IntegerArray;
  deltaHeight: Integer;
  instanceDeltaHeight: Integer;
  symbolWidth: Integer;
  totalWidth: Integer;
  deltaWidth: Integer;
  decodeIntResult: TDecodeIntResult;
  refAggNum: Integer;
  symbolID: Integer;
  referenceDX: Integer;
  referenceDY: Integer;
  referredToBitmap: TJBIG2Bitmap;
  bitmap: TJBIG2Bitmap;
  bmSize: Integer;
  padding: Integer;
  bytesPerRow: Integer;
  size: Integer;
  bitmapData: TJBIG2SmallintArray;
  logicalMap: array of array of Smallint;
  LogicalMapIndex: Integer;
  count: Integer;
  row: Integer;
  col: Integer;
  collectiveBitmap: TJBIG2Bitmap;
  collectiveBitmapRow: Integer;
  collectiveBitmapCol: Integer;
  currentByte: Smallint;
  bitPointer: Integer;
  mask: Smallint;
  bit: Integer;
  MustExport: Boolean;
  run: Integer;
  cnt: Integer;
  contextRetained: Integer;
begin
  // read symbol dictionary flags
  readSymbolDictionaryFlags;

  codeTables := TJBIG2List.Create;
  try
    numberOfInputSymbols := 0;
    noOfReferredToSegments := segmentHeader.getReferredToSegmentCount;
    referredToSegments := segmentHeader.getReferredToSegments;

    for i := 0 to noOfReferredToSegments - 1 do
    begin
      seg := decoder.findSegment(referredToSegments[i]);
      segType := seg.getSegmentHeader.getSegmentType;

      if (segType = JBIG2_SYMBOL_DICTIONARY) then
      begin
        Inc(numberOfInputSymbols, TSymbolDictionarySegment(seg).noOfExportedSymbols);
      end else
      if (segType = JBIG2_TABLES) then
      begin
        codeTables.add(seg);
      end;
    end;

    symbolCodeLength := 0;
    i := 1;
    while (i < numberOfInputSymbols + noOfNewSymbols) do
    begin
      Inc(symbolCodeLength);
      i := i shl 1;
    end;

    SetLength(bitmaps, numberOfInputSymbols + noOfNewSymbols);

    k := 0;
    inputSymbolDictionary := nil;
    for i := 0 to noOfReferredToSegments - 1 do
    begin
      seg := decoder.findSegment(referredToSegments[i]);
      if (seg.getSegmentHeader.getSegmentType = JBIG2_SYMBOL_DICTIONARY) then
      begin
        inputSymbolDictionary := TSymbolDictionarySegment(seg);
        for j := 0 to inputSymbolDictionary.noOfExportedSymbols - 1 do
        begin
          bitmaps[k] := inputSymbolDictionary.bitmaps[j];
          Inc(k);
        end;
      end;
    end;

    huffmanDHTable := nil;
    huffmanDWTable := nil;

    huffmanBMSizeTable := nil;
    huffmanAggInstTable := nil;

    sdHuffman := symbolDictionaryFlags.getFlagValue(JBIG2_SD_HUFF) <> 0;
    sdHuffmanDifferenceHeight := symbolDictionaryFlags.getFlagValue(JBIG2_SD_HUFF_DH);
    sdHuffmanDiferrenceWidth := symbolDictionaryFlags.getFlagValue(JBIG2_SD_HUFF_DW);
    sdHuffBitmapSize := symbolDictionaryFlags.getFlagValue(JBIG2_SD_HUFF_BM_SIZE);
    sdHuffAggregationInstances := symbolDictionaryFlags.getFlagValue(JBIG2_SD_HUFF_AGG_INST);

    i := 0;
    if (sdHuffman) then
    begin
      if (sdHuffmanDifferenceHeight = 0) then
      begin
        huffmanDHTable := GetHuffmanTableD;
      end else
      if (sdHuffmanDifferenceHeight = 1) then
      begin
        huffmanDHTable := GetHuffmanTableE;
      end else
      begin
        huffmanDHTable := THuffmanTableArray(codeTables.Items[i]);
        Inc(i);
      end;

      if (sdHuffmanDiferrenceWidth = 0) then
      begin
        huffmanDWTable := GetHuffmanTableB;
      end else
      if (sdHuffmanDiferrenceWidth = 1) then
      begin
        huffmanDWTable := GetHuffmanTableC;
      end else
      begin
        huffmanDWTable := THuffmanTableArray(codeTables.Items[i]);
        Inc(i);
      end;

      if (sdHuffBitmapSize = 0) then
      begin
        huffmanBMSizeTable := GetHuffmanTableA;
      end else
      begin
        huffmanBMSizeTable := THuffmanTableArray(codeTables.Items[i]);
        Inc(i);
      end;

      if (sdHuffAggregationInstances = 0) then
      begin
        huffmanAggInstTable := GetHuffmanTableA;
      end else
      begin
        huffmanAggInstTable := THuffmanTableArray(codeTables.Items[i]);
      end;
    end;

    contextUsed := symbolDictionaryFlags.getFlagValue(JBIG2_BITMAP_CC_USED);
    sdTemplate := symbolDictionaryFlags.getFlagValue(JBIG2_SD_TEMPLATE);

    if (not sdHuffman) then
    begin
      if ((contextUsed <> 0) and Assigned(inputSymbolDictionary)) then
      begin
        arithmeticDecoder.resetGenericStats(sdTemplate, inputSymbolDictionary.genericRegionStats);
      end else
      begin
        arithmeticDecoder.resetGenericStats(sdTemplate, nil);
      end;
      arithmeticDecoder.resetIntStats(symbolCodeLength);
      arithmeticDecoder.start;
    end;

    sdRefinementAggregate := symbolDictionaryFlags.getFlagValue(JBIG2_SD_REF_AGG);
    sdRefinementTemplate := symbolDictionaryFlags.getFlagValue(JBIG2_SD_R_TEMPLATE);
    if (sdRefinementAggregate <> 0) then
    begin
      if ((contextUsed <> 0) and Assigned(inputSymbolDictionary)) then
      begin
        arithmeticDecoder.resetRefinementStats(sdRefinementTemplate, inputSymbolDictionary.refinementRegionStats);
      end else
      begin
        arithmeticDecoder.resetRefinementStats(sdRefinementTemplate, nil);
      end;
    end;

    SetLength(deltaWidths, noOfNewSymbols);

    deltaHeight := 0;
    i := 0;

    while (i < noOfNewSymbols) do
    begin
      if (sdHuffman) then
      begin
        instanceDeltaHeight := huffmanDecoder.decodeInt(huffmanDHTable).intResult;
      end else
      begin
        instanceDeltaHeight := arithmeticDecoder.decodeInt(arithmeticDecoder.iadhStats).intResult;
      end;

      if ((instanceDeltaHeight < 0) and (-instanceDeltaHeight >= deltaHeight)) then
      begin
        // Bad delta-height value in JBIG2 symbol dictionary
      end;

      Inc(deltaHeight, instanceDeltaHeight);
      symbolWidth := 0;
      totalWidth := 0;
      j := i;

      while (True) do
      begin
        if (sdHuffman) then
        begin
          decodeIntResult := huffmanDecoder.decodeInt(huffmanDWTable);
        end else
        begin
          decodeIntResult := arithmeticDecoder.decodeInt(arithmeticDecoder.iadwStats);
        end;

        if (not decodeIntResult.booleanResult) then
        begin
          Break;
        end;

        deltaWidth := decodeIntResult.intResult;

        if ((deltaWidth < 0) and (-deltaWidth >= symbolWidth)) then
        begin
          // Bad delta-width value in JBIG2 symbol dictionary
        end;

        Inc(symbolWidth, deltaWidth);

        if (sdHuffman and (sdRefinementAggregate = 0)) then
        begin
          deltaWidths[i] := symbolWidth;
          Inc(totalWidth, symbolWidth);
        end else
        if (sdRefinementAggregate = 1) then
        begin
          //refAggNum := 0;

          if (sdHuffman) then
          begin
            refAggNum := huffmanDecoder.decodeInt(huffmanAggInstTable).intResult;
          end else
          begin
            refAggNum := arithmeticDecoder.decodeInt(arithmeticDecoder.iaaiStats).intResult;
          end;

          if (refAggNum = 1) then
          begin
            symbolID := 0;
            referenceDX := 0;
            referenceDY := 0;

            if (sdHuffman) then
            begin
              symbolID := decoder.readBits(symbolCodeLength);
              referenceDX := huffmanDecoder.decodeInt(GetHuffmanTableO).intResult;
              referenceDY := huffmanDecoder.decodeInt(GetHuffmanTableO).intResult;

              decoder.consumeRemainingBits;
              arithmeticDecoder.start;
            end else
            begin
              symbolID := Integer(arithmeticDecoder.decodeIAID(symbolCodeLength, arithmeticDecoder.iaidStats));
              referenceDX := arithmeticDecoder.decodeInt(arithmeticDecoder.iardxStats).intResult;
              referenceDY := arithmeticDecoder.decodeInt(arithmeticDecoder.iardyStats).intResult;
            end;

            referredToBitmap := bitmaps[symbolID];

            bitmap := decoder.BitmapFactory.CreateBitmap(symbolWidth, deltaHeight, arithmeticDecoder, huffmanDecoder, mmrDecoder);
            bitmap.readGenericRefinementRegion(sdRefinementTemplate, False, referredToBitmap, referenceDX, referenceDY, symbolDictionaryRAdaptiveTemplateX,
                symbolDictionaryRAdaptiveTemplateY);

            bitmaps[numberOfInputSymbols + i] := bitmap;
          end else
          begin
            bitmap := decoder.BitmapFactory.CreateBitmap(symbolWidth, deltaHeight, arithmeticDecoder, huffmanDecoder, mmrDecoder);
            bitmap.readTextRegion(sdHuffman, True, refAggNum, 0, numberOfInputSymbols + i, nil, symbolCodeLength, bitmaps, 0, 0, False, 1, 0,
                GetHuffmanTableF, GetHuffmanTableH, GetHuffmanTableK, GetHuffmanTableO, GetHuffmanTableO,
                GetHuffmanTableO, GetHuffmanTableO, GetHuffmanTableA, sdRefinementTemplate, symbolDictionaryRAdaptiveTemplateX,
                symbolDictionaryRAdaptiveTemplateY);

            bitmaps[numberOfInputSymbols + i] := bitmap;
          end;
        end else
        begin
          bitmap := decoder.BitmapFactory.CreateBitmap(symbolWidth, deltaHeight, arithmeticDecoder, huffmanDecoder, mmrDecoder);
          bitmap.readBitmap(False, sdTemplate, False, False, nil, symbolDictionaryAdaptiveTemplateX, symbolDictionaryAdaptiveTemplateY, 0);
          bitmaps[numberOfInputSymbols + i] := bitmap;
        end;

        Inc(i);
      end;

      if (sdHuffman and (sdRefinementAggregate = 0)) then
      begin
        bmSize := huffmanDecoder.decodeInt(huffmanBMSizeTable).intResult;
        decoder.consumeRemainingBits;

        collectiveBitmap := decoder.BitmapFactory.CreateBitmap(totalWidth, deltaHeight, arithmeticDecoder, huffmanDecoder, mmrDecoder);

        if (bmSize = 0) then
        begin
          padding := totalWidth mod 8;
          bytesPerRow := JBIG2Ceil(totalWidth / 8);

          size := deltaHeight * ((totalWidth + 7) shr 3);
          SetLength(bitmapData, size);
          decoder.readByte(bitmapData);

          SetLength(logicalMap, deltaHeight);
          for LogicalMapIndex := 0 to deltaHeight - 1 do
          begin
            SetLength(logicalMap[logicalMapIndex], bytesPerRow);
          end;

          count := 0;
          for row := 0 to deltaHeight - 1 do
          begin
            for col := 0 to bytesPerRow - 1 do
            begin
              logicalMap[row][col] := bitmapData[count];
              Inc(count);
            end;
          end;

          collectiveBitmapRow := 0;
          collectiveBitmapCol := 0;

          for row := 0 to deltaHeight - 1 do
          begin
            for col := 0 to bytesPerRow - 1 do
            begin
              if (col = (bytesPerRow - 1)) then
              begin
                // this is the last byte in the row
                currentByte := logicalMap[row][col];
                for bitPointer := 7 downto padding do
                begin
                  mask := Smallint(1 shl bitPointer);
                  bit := (currentByte and mask) shr bitPointer;

                  collectiveBitmap.setPixel(collectiveBitmapCol, collectiveBitmapRow, bit);
                  Inc(collectiveBitmapCol);
                end;
                Inc(collectiveBitmapRow);
                collectiveBitmapCol := 0;
              end else
              begin
                currentByte := logicalMap[row][col];
                for bitPointer := 7 downto 0 do
                begin
                  mask := Smallint(1 shl bitPointer);
                  bit := (currentByte and mask) shr bitPointer;

                  collectiveBitmap.setPixel(collectiveBitmapCol, collectiveBitmapRow, bit);
                  Inc(collectiveBitmapCol);
                end;
              end;
            end;
          end;
        end else
        begin
          collectiveBitmap.readBitmap(True, 0, False, False, nil, nil, nil, bmSize);
        end;

        x := 0;
        while (j < i) do
        begin
          bitmaps[numberOfInputSymbols + j] := collectiveBitmap.getSlice(x, 0, deltaWidths[j], deltaHeight);
          Inc(x, deltaWidths[j]);
          Inc(j);
        end;
      end;
    end;

    SetLength(Self.bitmaps, noOfExportedSymbols);

    i := 0;
    j := 0;
    MustExport := False;
    while (i < (numberOfInputSymbols + noOfNewSymbols)) do
    begin
      run := 0;
      if (sdHuffman) then
      begin
        run := huffmanDecoder.decodeInt(GetHuffmanTableA).intResult;
      end else
      begin
        run := arithmeticDecoder.decodeInt(arithmeticDecoder.iaexStats).intResult;
      end;

      if (mustExport) then
      begin
        for cnt := 0 to run - 1 do
        begin
          Self.bitmaps[j] := bitmaps[i];
          Inc(i);
          Inc(j);
        end;
      end else
      begin
        Inc(i, run);
      end;

      mustExport := not mustExport;
    end;

    contextRetained := symbolDictionaryFlags.getFlagValue(JBIG2_BITMAP_CC_RETAINED);
    if ((not sdHuffman) and (contextRetained = 1)) then
    begin
      genericRegionStats := genericRegionStats.copy;
      if (sdRefinementAggregate = 1) then
      begin
        refinementRegionStats := refinementRegionStats.copy;
      end;
    end;

    decoder.consumeRemainingBits;
  finally
    codeTables.Free;
  end;
end;

procedure TSymbolDictionarySegment.readSymbolDictionaryFlags;
var
  symbolDictionaryFlagsField: TJBIG2SmallintArray;
  flags: Integer;
  sdHuff: Integer;
  sdTemplate: Integer;
  refAgg: Integer;
  sdrTemplate: Integer;
  noOfExportedSymbolsField: TJBIG2SmallintArray;
  noOfExportedSymbols: Integer;
  noOfNewSymbolsField: TJBIG2SmallintArray;
  noOfNewSymbols: Integer;
begin
  SetLength(symbolDictionaryFlagsField, 2);
  decoder.readByte(symbolDictionaryFlagsField);

  flags := getInt16(symbolDictionaryFlagsField);
  symbolDictionaryFlags.setFlags(flags);

  sdHuff := symbolDictionaryFlags.getFlagValue(JBIG2_SD_HUFF);
  sdTemplate := symbolDictionaryFlags.getFlagValue(JBIG2_SD_TEMPLATE);
  if (sdHuff = 0) then
  begin
    if (sdTemplate = 0) then
    begin
      symbolDictionaryAdaptiveTemplateX[0] := readATValue;
      symbolDictionaryAdaptiveTemplateY[0] := readATValue;
      symbolDictionaryAdaptiveTemplateX[1] := readATValue;
      symbolDictionaryAdaptiveTemplateY[1] := readATValue;
      symbolDictionaryAdaptiveTemplateX[2] := readATValue;
      symbolDictionaryAdaptiveTemplateY[2] := readATValue;
      symbolDictionaryAdaptiveTemplateX[3] := readATValue;
      symbolDictionaryAdaptiveTemplateY[3] := readATValue;
    end else
    begin
      symbolDictionaryAdaptiveTemplateX[0] := readATValue;
      symbolDictionaryAdaptiveTemplateY[0] := readATValue;
    end;
  end;

  // Symbol dictionary refinement AT flags
  refAgg := symbolDictionaryFlags.getFlagValue(JBIG2_SD_REF_AGG);
  sdrTemplate := symbolDictionaryFlags.getFlagValue(JBIG2_SD_R_TEMPLATE);
  if ((refAgg <> 0) and (sdrTemplate = 0)) then
  begin
    SetLength(symbolDictionaryRAdaptiveTemplateX, 2);
    SetLength(symbolDictionaryRAdaptiveTemplateY, 2);
    symbolDictionaryRAdaptiveTemplateX[0] := readATValue;
    symbolDictionaryRAdaptiveTemplateY[0] := readATValue;
    symbolDictionaryRAdaptiveTemplateX[1] := readATValue;
    symbolDictionaryRAdaptiveTemplateY[1] := readATValue;
  end;

  // Extract no of exported symbols
  SetLength(noOfExportedSymbolsField, 4);
  decoder.readByte(noOfExportedSymbolsField);

  noOfExportedSymbols := getInt32(noOfExportedSymbolsField);
  Self.noOfExportedSymbols := noOfExportedSymbols;

  // Extract no of new symbols
  SetLength(noOfNewSymbolsField, 4);
  decoder.readByte(noOfNewSymbolsField);

  noOfNewSymbols := getInt32(noOfNewSymbolsField);
  Self.noOfNewSymbols := noOfNewSymbols;
end;

function TSymbolDictionarySegment.getGenericRegionStats: TArithmeticDecoderStats;
begin
  Result := genericRegionStats;
end;

procedure TSymbolDictionarySegment.setGenericRegionStats(
  genericRegionStats: TArithmeticDecoderStats);
begin
  Self.genericRegionStats := genericRegionStats;
end;

function TSymbolDictionarySegment.getRefinementRegionStats: TArithmeticDecoderStats;
begin
  Result := refinementRegionStats;
end;

procedure TSymbolDictionarySegment.setRefinementRegionStats(
  refinementRegionStats: TArithmeticDecoderStats);
begin
  Self.refinementRegionStats := refinementRegionStats;
end;

function TSymbolDictionarySegment.getNoOfExportedSymbols: Integer;
begin
  Result := noOfExportedSymbols;
end;

procedure TSymbolDictionarySegment.setNoOfExportedSymbols(
  noOfExportedSymbols: Integer);
begin
  Self.noOfExportedSymbols := noOfExportedSymbols;
end;

function TSymbolDictionarySegment.getBitmaps: TJBIG2BitmapArray;
begin
  Result := bitmaps;
end;

function TSymbolDictionarySegment.getNoOfNewSymbols: Integer;
begin
  Result := noOfNewSymbols;
end;

procedure TSymbolDictionarySegment.setNoOfNewSymbols(
  noOfNewSymbols: Integer);
begin
  Self.noOfNewSymbols := noOfNewSymbols;
end;

function TSymbolDictionarySegment.getSymbolDictionaryFlags: TSymbolDictionaryFlags;
begin
  Result := symbolDictionaryFlags;
end;

procedure TSymbolDictionarySegment.setSymbolDictionaryFlags(
  symbolDictionaryFlags: TSymbolDictionaryFlags);
begin
  Self.symbolDictionaryFlags := symbolDictionaryFlags;
end;

destructor TSymbolDictionarySegment.Destroy;
begin
  symbolDictionaryFlags.Free;
  inherited;
end;


{ TTextRegionFlags }

procedure TTextRegionFlags.setFlags(flagsAsInt: Integer);
var
  sOffset: Integer;
begin
  Self.flagsAsInt := flagsAsInt;
  flags.AddObject(JBIG2_SB_HUFF, TObject(flagsAsInt and 1));
  flags.AddObject(JBIG2_SB_REFINE, TObject((flagsAsInt shr 1) and 1));
  flags.AddObject(JBIG2_LOG_SB_STRIPES, TObject((flagsAsInt shr 2) and 3));
  flags.AddObject(JBIG2_REF_CORNER, TObject((flagsAsInt shr 4) and 3));
  flags.AddObject(JBIG2_TRANSPOSED, TObject((flagsAsInt shr 6) and 1));
  flags.AddObject(JBIG2_SB_COMB_OP, TObject((flagsAsInt shr 7) and 3));
  flags.AddObject(JBIG2_SB_DEF_PIXEL, TObject((flagsAsInt shr 9) and 1));

  sOffset := (flagsAsInt shr 10) and $1f;
  if ((sOffset and $10) <> 0) then
  begin
    sOffset := sOffset or (-1 - $0f);
  end;

  flags.AddObject(JBIG2_SB_DS_OFFSET, TObject(sOffset));
  flags.AddObject(JBIG2_SB_R_TEMPLATE, TObject((flagsAsInt shr 15) and 1));
end;


{ TTextRegionHuffmanFlags }

procedure TTextRegionHuffmanFlags.setFlags(intFlags: Integer);
begin
  Self.flagsAsInt := flagsAsInt;

  flags.AddObject(JBIG2_SB_HUFF_FS, TObject(flagsAsInt and 3));
  flags.AddObject(JBIG2_SB_HUFF_DS, TObject((flagsAsInt shr 2) and 3));
  flags.AddObject(JBIG2_SB_HUFF_DT, TObject((flagsAsInt shr 4) and 3));
  flags.AddObject(JBIG2_SB_HUFF_RDW, TObject((flagsAsInt shr 6) and 3));
  flags.AddObject(JBIG2_SB_HUFF_RDH, TObject((flagsAsInt shr 8) and 3));
  flags.AddObject(JBIG2_SB_HUFF_RDX, TObject((flagsAsInt shr 10) and 3));
  flags.AddObject(JBIG2_SB_HUFF_RDY, TObject((flagsAsInt shr 12) and 3));
  flags.AddObject(JBIG2_SB_HUFF_RSIZE, TObject((flagsAsInt shr 14) and 1));
end;

{ TTextRegionSegment }

constructor TTextRegionSegment.Create(streamDecoder: TJBIG2StreamDecoder;
  inlineImage: Boolean);
begin
  inherited Create(streamDecoder);
  Self.inlineImage := inlineImage;
  textRegionFlags := TTextRegionFlags.Create;
  textRegionHuffmanFlags := TTextRegionHuffmanFlags.Create;
  SetLength(symbolRegionAdaptiveTemplateX, 2);
  SetLength(symbolRegionAdaptiveTemplateY, 2);
end;

destructor TTextRegionSegment.Destroy;
begin
  textRegionFlags.Free;
  textRegionHuffmanFlags.Free;
  inherited;
end;

function TTextRegionSegment.getTextRegionFlags: TTextRegionFlags;
begin
  Result := textRegionFlags;
end;

function TTextRegionSegment.getTextRegionHuffmanFlags: TTextRegionHuffmanFlags;
begin
  Result := textRegionHuffmanFlags;
end;

procedure TTextRegionSegment.readSegment;
var
  buff: TJBIG2SmallintArray;
  noOfReferredToSegments: Integer;
  referredToSegments: TJBIG2IntegerArray;
  codeTables: TJBIG2List;
  segmentsReferenced: TJBIG2List;
  noOfSymbols: Integer;
  i: Integer;
  j: Integer;
  seg: TSegment;
  segType: Integer;
  symbolCodeLength: Integer;
  count: Integer;
  currentSymbol: Integer;
  symbols: TJBIG2BitmapArray;
  bitmaps: TJBIG2BitmapArray;
  sbHuffman: Boolean;
  sbHuffFS: Integer;
  sbHuffDS: Integer;
  sbHuffDT: Integer;
  sbHuffRDW: Integer;
  sbHuffRDH: Integer;
  sbHuffRDX: Integer;
  sbHuffRDY: Integer;
  sbHuffRSize: Integer;
  runLengthTable: THuffmanTableArray;
  symbolCodeTable: THuffmanTableArray;
  symbolRefine: Boolean;
  logStrips: Integer;
  defaultPixel: Integer;
  combinationOperator: Integer;
  transposed: Boolean;
  referenceCorner: Integer;
  sOffset: Integer;
  template: Integer;
  bitmap: TJBIG2Bitmap;
  pageSegment: TPageInformationSegment;
  pageBitmap: TJBIG2Bitmap;
  externalCombinationOperator: Integer;
  huffmanFSTable: THuffmanTableArray;
  huffmanDSTable: THuffmanTableArray;
  huffmanDTTable: THuffmanTableArray;
  huffmanRDWTable: THuffmanTableArray;
  huffmanRDHTable: THuffmanTableArray;
  huffmanRDXTable: THuffmanTableArray;
  huffmanRDYTable: THuffmanTableArray;
  huffmanRSizeTable: THuffmanTableArray;
begin
  inherited readSegment;

  // read text region Segment flags
  readTextRegionFlags;

  SetLength(bitmaps, 0);

  SetLength(buff, 4);
  decoder.readByte(buff);
  noOfSymbolInstances := getInt32(buff);

  noOfReferredToSegments := segmentHeader.getReferredToSegmentCount;
  referredToSegments := segmentHeader.getReferredToSegments;

  noOfSymbols := 0;
  codeTables := TJBIG2List.Create;
  segmentsReferenced := TJBIG2List.Create;
  try
    for i := 0 to noOfReferredToSegments - 1 do
    begin
      seg := decoder.findSegment(referredToSegments[i]);
      segType := seg.getSegmentHeader.getSegmentType;

      if (segType = JBIG2_SYMBOL_DICTIONARY) then
      begin
        segmentsReferenced.Add(seg);
        Inc(noOfSymbols, TSymbolDictionarySegment(seg).getNoOfExportedSymbols);
      end else
      if (segType = JBIG2_TABLES) then
      begin
        codeTables.Add(seg);
      end;
    end;

    symbolCodeLength := 0;
    count := 1;

    while (count < noOfSymbols) do
    begin
      Inc(symbolCodeLength);
      count := count shl 1;
    end;

    currentSymbol := 0;
    SetLength(symbols, noOfSymbols);

    for i := 0 to segmentsReferenced.Count - 1 do
    begin
      seg := TSegment(segmentsReferenced.Items[i]);
      if (seg.getSegmentHeader.getSegmentType = JBIG2_SYMBOL_DICTIONARY) then
      begin
        bitmaps := TSymbolDictionarySegment(seg).getBitmaps;
        for j := 0 to Length(bitmaps) - 1 do
        begin
          symbols[currentSymbol] := bitmaps[j];
          Inc(currentSymbol);
        end;
      end;
    end;

    huffmanFSTable := nil;
    huffmanDSTable := nil;
    huffmanDTTable := nil;

    huffmanRDWTable := nil;
    huffmanRDHTable := nil;

    huffmanRDXTable := nil;
    huffmanRDYTable := nil;
    huffmanRSizeTable := nil;

    sbHuffman := textRegionFlags.getFlagValue(JBIG2_SB_HUFF) <> 0;

    if (sbHuffman) then
    begin
      sbHuffFS := textRegionHuffmanFlags.getFlagValue(JBIG2_SB_HUFF_FS);
      if (sbHuffFS = 0) then
      begin
        huffmanFSTable := GetHuffmanTableF;
      end else
      if (sbHuffFS = 1) then
      begin
        huffmanFSTable := GetHuffmanTableG;
      end else
      begin

      end;

      sbHuffDS := textRegionHuffmanFlags.getFlagValue(JBIG2_SB_HUFF_DS);
      if (sbHuffDS = 0) then
      begin
        huffmanDSTable := GetHuffmanTableH;
      end else
      if (sbHuffDS = 1) then
      begin
        huffmanDSTable := GetHuffmanTableI;
      end else
      if (sbHuffDS = 2) then
      begin
        huffmanDSTable := GetHuffmanTableJ;
      end else
      begin

      end;

      sbHuffDT := textRegionHuffmanFlags.getFlagValue(JBIG2_SB_HUFF_DT);
      if (sbHuffDT = 0) then
      begin
        huffmanDTTable := GetHuffmanTableK;
      end else
      if (sbHuffDT = 1) then
      begin
        huffmanDTTable := GetHuffmanTableL;
      end else
      if (sbHuffDT = 2) then
      begin
        huffmanDTTable := GetHuffmanTableM;
      end else
      begin

      end;

      sbHuffRDW := textRegionHuffmanFlags.getFlagValue(JBIG2_SB_HUFF_RDW);
      if (sbHuffRDW = 0) then
      begin
        huffmanRDWTable := GetHuffmanTableN;
      end else
      if (sbHuffRDW = 1) then
      begin
        huffmanRDWTable := GetHuffmanTableO;
      end else
      begin

      end;

      sbHuffRDH := textRegionHuffmanFlags.getFlagValue(JBIG2_SB_HUFF_RDH);
      if (sbHuffRDH = 0) then
      begin
        huffmanRDHTable := GetHuffmanTableN;
      end else
      if (sbHuffRDH = 1) then
      begin
        huffmanRDHTable := GetHuffmanTableO;
      end else
      begin

      end;

      sbHuffRDX := textRegionHuffmanFlags.getFlagValue(JBIG2_SB_HUFF_RDX);
      if (sbHuffRDX = 0) then
      begin
        huffmanRDXTable := GetHuffmanTableN;
      end else
      if (sbHuffRDX = 1) then
      begin
        huffmanRDXTable := GetHuffmanTableO;
      end else
      begin

      end;

      sbHuffRDY := textRegionHuffmanFlags.getFlagValue(JBIG2_SB_HUFF_RDY);
      if (sbHuffRDY = 0) then
      begin
        huffmanRDYTable := GetHuffmanTableN;
      end else
      if (sbHuffRDY = 1) then
      begin
        huffmanRDYTable := GetHuffmanTableO;
      end else
      begin

      end;

      sbHuffRSize := textRegionHuffmanFlags.getFlagValue(JBIG2_SB_HUFF_RSIZE);
      if (sbHuffRSize = 0) then
      begin
        huffmanRSizeTable := GetHuffmanTableA;
      end else
      begin

      end;
    end;

    SetLength(runLengthTable, 36);
    SetLength(symbolCodeTable, noOfSymbols + 1);

    if (sbHuffman) then
    begin
      decoder.consumeRemainingBits;

      for i := 0 to 31 do
      begin
        runLengthTable[i].val := i;
        runLengthTable[i].prefixLen := decoder.readBits(4);
        runLengthTable[i].rangeLen := 0;
        runLengthTable[i].prefix := 0;
      end;

      runLengthTable[32].val := $103;
      runLengthTable[32].prefixLen := decoder.readBits(4);
      runLengthTable[32].rangeLen := 2;
      runLengthTable[32].prefix := 0;

      runLengthTable[33].val := $203;
      runLengthTable[33].prefixLen := decoder.readBits(4);
      runLengthTable[33].rangeLen := 3;
      runLengthTable[33].prefix := 0;

      runLengthTable[34].val := $20b;
      runLengthTable[34].prefixLen := decoder.readBits(4);
      runLengthTable[34].rangeLen := 7;
      runLengthTable[34].prefix := 0;

      runLengthTable[35].val := 0;
      runLengthTable[35].prefixLen := 0;
      runLengthTable[35].rangeLen := jbig2HuffmanEOT;
      runLengthTable[35].prefix := 0;

      runLengthTable := huffmanDecoder.buildTable(runLengthTable, 35);

      for i := 0 to noOfSymbols - 1 do
      begin
        symbolCodeTable[i].val := i;
        symbolCodeTable[i].prefixLen := 0;
        symbolCodeTable[i].rangeLen := 0;
        symbolCodeTable[i].prefix := 0;
      end;

      i := 0;
      while (i < noOfSymbols) do
      begin
        j := huffmanDecoder.decodeInt(runLengthTable).intResult;
        if (j > $200) then
        begin
          Dec(j, $200);
          while ((j <> 0) and (i < noOfSymbols)) do
          begin
            symbolCodeTable[i].prefixLen := 0;
            Inc(i);
            Dec(j);
          end;
        end else
        if (j > $100) then
        begin
          Dec(j, $100);
          while ((j <> 0) and (i < noOfSymbols)) do
          begin
            symbolCodeTable[i].prefixLen := symbolCodeTable[i - 1].prefixLen;
            Inc(i);
            Dec(j);
          end;
        end else
        begin
          symbolCodeTable[i].prefixLen := j;
          Inc(i);
        end;
      end;

      symbolCodeTable[noOfSymbols].val := 0;
      symbolCodeTable[noOfSymbols].prefixLen := 0;
      symbolCodeTable[noOfSymbols].rangeLen := jbig2HuffmanEOT;
      symbolCodeTable[noOfSymbols].prefix := 0;
      symbolCodeTable := huffmanDecoder.buildTable(symbolCodeTable, noOfSymbols);

      decoder.consumeRemainingBits;
    end else
    begin
      symbolCodeTable := nil;
      arithmeticDecoder.resetIntStats(symbolCodeLength);
      arithmeticDecoder.start;
    end;

    symbolRefine := textRegionFlags.getFlagValue(JBIG2_SB_REFINE) <> 0;
    logStrips := textRegionFlags.getFlagValue(JBIG2_LOG_SB_STRIPES);
    defaultPixel := textRegionFlags.getFlagValue(JBIG2_SB_DEF_PIXEL);
    combinationOperator := textRegionFlags.getFlagValue(JBIG2_SB_COMB_OP);
    transposed := textRegionFlags.getFlagValue(JBIG2_TRANSPOSED) <> 0;
    referenceCorner := textRegionFlags.getFlagValue(JBIG2_REF_CORNER);
    sOffset := textRegionFlags.getFlagValue(JBIG2_SB_DS_OFFSET);
    template := textRegionFlags.getFlagValue(JBIG2_SB_R_TEMPLATE);

    if (symbolRefine) then
    begin
      arithmeticDecoder.resetRefinementStats(template, nil);
    end;

    bitmap := decoder.BitmapFactory.CreateBitmap(regionBitmapWidth, regionBitmapHeight, arithmeticDecoder, huffmanDecoder, mmrDecoder);

    bitmap.readTextRegion(sbHuffman, symbolRefine, noOfSymbolInstances, logStrips, noOfSymbols, symbolCodeTable, symbolCodeLength, symbols, defaultPixel, combinationOperator, transposed, referenceCorner, sOffset, huffmanFSTable, huffmanDSTable, huffmanDTTable, huffmanRDWTable, huffmanRDHTable, huffmanRDXTable, huffmanRDYTable, huffmanRSizeTable, template, symbolRegionAdaptiveTemplateX, symbolRegionAdaptiveTemplateY);

    if (inlineImage) then
    begin
      pageSegment := decoder.findPageSegment(segmentHeader.getPageAssociation);
      pageBitmap := pageSegment.getPageBitmap;

      externalCombinationOperator := regionFlags.getFlagValue(JBIG2_EXTERNAL_COMBINATION_OPERATOR);
      pageBitmap.combine(bitmap, regionBitmapXLocation, regionBitmapYLocation, externalCombinationOperator);
    end else
    begin
      bitmap.setBitmapNumber(getSegmentHeader.getSegmentNumber);
      decoder.appendBitmap(bitmap);
    end;

    decoder.consumeRemainingBits;
  finally
    codeTables.Free;
    segmentsReferenced.Free;
  end;
end;

procedure TTextRegionSegment.readTextRegionFlags;
var
  textRegionFlagsField: TJBIG2SmallintArray;
  flags: Integer;
  sbHuff: Boolean;
  textRegionHuffmanFlagsField: TJBIG2SmallintArray;
  sbRefine: Boolean;
  sbrTemplate: Integer;
begin
  SetLength(textRegionFlagsField, 2);
  decoder.readByte(textRegionFlagsField);

  flags := getInt16(textRegionFlagsField);
  textRegionFlags.setFlags(flags);

  sbHuff := textRegionFlags.getFlagValue(JBIG2_SB_HUFF) <> 0;
  if (sbHuff) then
  begin
    SetLength(textRegionHuffmanFlagsField, 2);
    decoder.readByte(textRegionHuffmanFlagsField);

    flags := getInt16(textRegionHuffmanFlagsField);
    textRegionHuffmanFlags.setFlags(flags);
  end;

  sbRefine := textRegionFlags.getFlagValue(JBIG2_SB_REFINE) <> 0;
  sbrTemplate := textRegionFlags.getFlagValue(JBIG2_SB_R_TEMPLATE);
  if (sbRefine and (sbrTemplate = 0)) then
  begin
    symbolRegionAdaptiveTemplateX[0] := readATValue;
    symbolRegionAdaptiveTemplateY[0] := readATValue;
    symbolRegionAdaptiveTemplateX[1] := readATValue;
    symbolRegionAdaptiveTemplateY[1] := readATValue;
  end;
end;

{ TQPLJBIG2Decoder }

constructor TQPLJBIG2Decoder.Create;
begin
  FWidth := 0;
  FHeight := 0;
  SetLength(FScanlines, 0);
end;

function TQPLJBIG2Decoder.GetScanline(Row: Integer;
  var Data: TJBIG2ByteArray): Boolean;
begin
  if (Row >= 0) and (Row < FHeight) then
  begin
    Result := True;
    SetLength(Data, FWidth);
    Move(FScanlines[Row][0], Data[0], FWidth);
  end else
  begin
    Result := False;
    SetLength(Data, FWidth);
    FillChar(Data[0], FWidth, 0);
  end;
end;

function TQPLJBIG2Decoder.LoadFromByteArray(ImageData,
  GlobalData: TJBIG2ByteArray): Boolean;
var
  Decoder: TJBIG2StreamDecoder;
  Bitmap: TJBIG2Bitmap;
  Row: Integer;
begin
  Result := False;
  Decoder := TJBIG2StreamDecoder.Create;
  try
    if Length(ImageData) > 0 then
    begin
      if Length(GlobalData) > 0 then
      begin
        Decoder.setGlobalData(GlobalData);
      end;
      Decoder.decodeJBIG2(ImageData);
      if Decoder.getNoOfPages >= 1 then
      begin
        Bitmap := Decoder.getPageAsJBIG2Bitmap(0);
        FWidth := Bitmap.width;
        FHeight := Bitmap.height;
        if (FWidth > 0) and (FHeight > 0) then
        begin
          Result := True;
          SetLength(FScanlines, FHeight);
          for Row := 0 to FHeight - 1 do
          begin
            SetLength(FScanlines[Row], FWidth);
            Move(Bitmap.getRow(Row)[0], FScanlines[Row][0], FWidth);
          end;
        end;
      end;
    end;
  finally
    Decoder.Free;
  end;
end;

function TQPLJBIG2Decoder.LoadFromByteArray(
  ImageData: TJBIG2ByteArray): Boolean;
var
  GlobalData: TJBIG2ByteArray;
begin
  SetLength(GlobalData, 0);
  Result := LoadFromByteArray(ImageData, GlobalData);
end;

end.
