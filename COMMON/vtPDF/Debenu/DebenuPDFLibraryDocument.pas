{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibraryDocument.pas                           }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibraryDocument;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
  DebenuPDFLibraryStructure, DebenuPDFLibraryPageTree, DebenuPDFLibraryImage,
  Classes,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  DebenuPDFLibraryFont,
  DebenuPDFLibraryForm,
{$IFNDEF VER120}
  contnrs,
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  Types,
{$ENDIF}
{$IFDEF QPL_OS_WINDOWS}
{$IFDEF QPL_XE3_HIGHER}
  System.Types,
{$ENDIF}
{$ENDIF}
  DebenuPDFLibraryExtra, DebenuPDFLibraryPainter, DebenuPDFLibraryAscii85, DebenuPDFLibraryXRef, DebenuPDFLibraryImageDecoder,
  DebenuPDFLibraryImageList, DebenuPDFLibraryTextList, DebenuPDFLibraryPicasso, DebenuPDFLibraryLayout,
  DebenuPDFLibraryColorManagement, DebenuPDFLibraryTypes, DebenuPDFLibraryRenderer, DebenuPDFLibraryXMP;

type
  TPDFXRefEntry = record
    ObjNum: Integer;
    GenNum: Integer;
    ObjPos: Int64;
    InUse: Boolean;
    ObjStrNum: Integer;
    ObjStrIndex: Integer;
    Compact: Boolean;
  end;

  TPDFTransparencyGS = record
    Transparency: Integer;
    GSName: AnsiString;
    GS: TPDFIndRef;
  end;

  TPDFBlendModeGS = record
    BlendMode: TPDFBlendMode;
    GSName: AnsiString;
    GS: TPDFIndRef;
  end;

  TPDFOverprintGS = record
    StrokingOverprint: Boolean;
    OtherOverprint: Boolean;
    OverprintMode: Integer;
    OverprintKey: AnsiString;
    GSName: AnsiString;
    GS: TPDFIndRef;
  end;

  TPDFSeparationColor = record
    ColorName: AnsiString;
    C, M, Y, K: Double;
    CSName: AnsiString;
    CS: TPDFIndRef;
  end;

  TPDFShader = class
  public
    ShaderName: AnsiString;
    CSName: AnsiString;
    CS: TPDFIndRef;
  end;

  TPDFTilingPattern = class
  public
    TilingPatternName: AnsiString;
    CSName: AnsiString;
    CS: TPDFIndRef;
    procedure SetMatrix(M11, M12, M21, M22, MDX, MDY: Double);
  end;

  TPDFRGBAxialShader = class(TPDFShader)
  public
    StartX, StartY: Double;
    StartRed, StartGreen, StartBlue: Double;
    EndX, EndY: Double;
    EndRed, EndGreen, EndBlue: Double;
  end;

  TPDFStyle = record
    StyleName: AnsiString;
    Font: TPDFFont;
    FontSize: Double;
    FontColor: AnsiString;
    TextAlign: TPDFAlignment;
    TextScaling: Double;
    TextCharSpacing: Double;
    TextWordSpacing: Double;
    TextSpacing: Double;
    TextHighlight: TPDFHighlightStyle;
    TextUnderline: TPDFUnderlineStyle;
    TextHighlightColor: AnsiString;
    TextUnderlineColor: AnsiString;
    TextUnderlineDashOn: Double;
    TextUnderlineDashOff: Double;
    TextMode: Integer;
    LineColor: AnsiString;
    LineWidth: Double;
    LineDash: AnsiString;
    TextRise: Double;
    UnderlineWidth: Double;
    UnderlineDistance: Double;
    UseKerning: Boolean;
    UnderlineCustomDash: AnsiString;
  end;

  TPDFDocument = class;

  TPDFPermission = (ppCanPrint, ppCanCopy, ppCanChange, ppCanAddNotes);
  TPDFPermissions = set of TPDFPermission;

  TPDFExtraPermission = (ppCanFillFields, ppCanCopyAccess, ppCanAssemble,
    ppCanPrintFull);
  TPDFExtraPermissions = set of TPDFExtraPermission;

  TPDFEncryptionStrength = (esStd, es128Bit, esAES128Bit, esAES256Bit, es48Bit, esVariable, esAES256BitAcroX);

  TPDFStorageMode = (smString, smStream, smCompressedStream);

  TQPLLoadResult = (lrOkay, lrWrongPassword, lrError);

  TPDFIndObj = class
  private
    FParent: TPDFDocument;
    function PopNumber(var S: AnsiString): AnsiString;
    function PopText(var S: AnsiString): AnsiString;
    function PopNumberPos(const S: AnsiString; var PopPos: Int64): AnsiString;
    function PopTextPos(const S: AnsiString; var PopPos: Int64): AnsiString;
  protected
    FObjNum: Integer;
    FGenNum: Integer;
    FDecoded: Boolean;
    FObj: TPDFObject;
    FPosition: Integer;
    FLength: Integer;
    FDecrypted: Boolean;
    FRecoded: Boolean;
    FNewSource: AnsiString;
    FSpooled: Boolean;
    FCompact: Boolean;
    FObjStrNum: Integer;
    FObjStrIndex: Integer;
    FDecodeError: Boolean;
    FDecodeMode: Integer;

    function GetObj: TPDFObject;
    function IsStream(const Content: AnsiString; var SStart, SLen: Integer): Boolean;
    function IsStreamU(const Content: AnsiString; var SStart, SLen: Integer): Boolean;
    function IsStreamD(const Content: AnsiString; var SStart, SLen: Integer; Dict: TPDFDictionary; DictLength: Integer): Boolean;
    procedure Decode;
    procedure DecodeDirect;
  public
    constructor Create(AParent: TPDFDocument);
    function Output: AnsiString;
    function Source: AnsiString;

    procedure Decrypt;
    procedure Encrypt;
    procedure Recode;
    function HasChanged: Boolean;
    property Decrypted: Boolean read FDecrypted;
    property ObjNum: Integer read FObjNum;
    property GenNum: Integer read FGenNum;
    property Decoded: Boolean read FDecoded;
    property Recoded: Boolean read FRecoded;
    property Obj: TPDFObject read GetObj;
    property Compact: Boolean read FCompact;
    property DecodeError: Boolean read FDecodeError;
    property DecodeMode: Integer read FDecodeMode write FDecodeMode;
  end;

  TPDFEncrypted = (peDecrypted, peEncrypted, peUnknownEncryption);

  TPDFEncryptionAlgorithm = (eaRC4, eaAES128, eaAES256);

  TPDFEncryption = record
    DictionaryPresent: Boolean;
    Extracted: Boolean;
    Length: Integer;
    R: Integer;
    V: Integer;
    O: AnsiString;
    U: AnsiString;
    OE: AnsiString;
    UE: AnsiString;
    Perms: AnsiString;
    P: Cardinal;
    Algorithm: TPDFEncryptionAlgorithm;
    DictionaryObjNum: Integer;
    EncryptMetadata: Boolean;
  end;

  TPDFStdFont = (sfCourier, sfCourierBold, sfCourierBoldOblique,
    sfCourierOblique, sfHelvetica, sfHelveticaBold, sfHelveticaBoldOblique,
    sfHelveticaOblique, sfTimesRoman, sfTimesBold, sfTimesItalic,
    sfTimesBoldItalic, sfSymbol, sfZapfDingbats);

  TPDFPageMode = (pmUseNone, pmUseOutlines, pmUseThumbs, pmFullScreen, pmUseOC, pmUseAttachments);
  TPDFPageLayout = (plSinglePage, plOneColumn, plTwoColumnLeft, plTwoColumnRight, plTwoPageLeft, plTwoPageRight, plNone);

  TPDFObjectStream = class
  public
    DecodedStream: AnsiString;
    IndexArray: TPDFArray;
    First: Integer;
    N: Integer;
  end;

  TPDFOCGConfigOrderItem = record
    ItemType: Integer;
    ItemOCG: TPDFIndRef;
    ItemLabel: WideString;
    ItemLevel: Integer;
  end;

  TPDFOCGConfigOrderItems = array of TPDFOCGConfigOrderItem;

  TQPLValidSourceResult = (vsOkay, vsWrongPassword, vsError);

  TPDFDocument = class
  private
    XRefObjLoaded: TQPLSortedUniqueIntegerList;
    XRefTable: array of TPDFXRefEntry;
    XRefTableIndex: Integer;
    IndexCount: Integer;
    HTMLFont: array[1..4] of TPDFFont;
    HTMLEquivalentTags: array of AnsiString;
    FLastDataPos: Integer;
    FXRefPos: Integer;
    FStyles: array of TPDFStyle;
    XRefPosList: array of Int64;
    FTables: array of TPDFTable;
    FObjectStreams: array of TPDFObjectStream;
    FNoEmbedFontList: array of AnsiString;
    XMP: TDebenuPDFLibraryXMP;
    FIncludedFonts: TObjectList;

    procedure BuildObjPos;
    procedure BuildIndObjIndex;
    //function PopNumber(var S: AnsiString): AnsiString;
    function ReadHeader: Boolean;
    function ReadTrailer: Boolean;
    //function ReadXRef(Start: Integer): Boolean;
    procedure GetIndObj(Sender: TObject; ObjNum, GenNum: Integer;
      var Obj: TPDFObject);
    procedure NewIndObj(Sender: TObject; var ObjNum, GenNum: Integer;
      Obj: TPDFObject);
    procedure DeleteObj(ObjNum, GenNum: Integer);
    procedure DecodePermKey(PKey: Cardinal);
    function GetFont(FontIndex: Integer): TPDFFont;
    function GetFontCount: Integer;
  protected
    FChanged: Boolean;
    FUserModDate: Boolean;
    FVersion: AnsiString;
    FSource: AnsiString;
    FStructure: TPDFStructure;
    FIndObjList: TObjectList;
    FIndObjIndex: array of Integer;
    FIndObjKey: array of Integer;
    FTrailer: TPDFDictionary;
    FPageTree: TPDFPageTree;
    FImages: TObjectList;
    FImageLists: TObjectList;
    FTextLists: TObjectList;
    FFonts: TObjectList;
    FEncryption: TPDFEncryption;
    FCachedEncryption: TPDFEncryption;
    FPassword: WideString;
    FIsUserPassword: Boolean;
    FIsOwnerPassword: Boolean;
    FLinearized: Boolean;
    FHasDefaultHTMLFonts: Boolean;
    FScale: Double;
    FOrigin: Integer;
    FCompressImages: Integer;
    FCompressFonts: Integer;
    FUseExistingFonts: Integer;
    FTempFileName: WideString;
    FMainFS: TQuickPDFWideFileStream;
    FJavaScriptMode: TPDFStorageMode;
    FUseUnsafeLayers: Boolean;
    FNoPagesDict: Boolean;
    FMaxObjNum: Integer;
    FHeaderComments: AnsiString;

    IndObjEncKey: AnsiString;
    EncryptionKey: AnsiString;
    PermKey: Cardinal;
    FPermissions: TPDFPermissions;
    FExtraPermissions: TPDFExtraPermissions;
    FEncryptionStrength: TPDFEncryptionStrength;
    OwnerKey: AnsiString;
    UserKey: AnsiString;
    OwnerEncKey: AnsiString;
    UserEncKey: AnsiString;
    PermsKey: AnsiString;
    FOwnerPassword: AnsiString;
    FOwnerPasswordBlank: Boolean;
    FUserPassword: AnsiString;
    FUserPasswordBlank: Boolean;
    MalformedPermKey: Boolean;
    FormSearched: Boolean;
    FAcroForm: TPDFForm;
    FTransparencyList: array of TPDFTransparencyGS;
    FBlendModeList: array of TPDFBlendModeGS;
    FOverprintList: array of TPDFOverprintGS;
    FLastImageFontList: TObjectList;
    FPDFAMode: Integer;
    FPDFAModePossible: Boolean;
    FDecodeMode: Integer;

    FSeparationColors: array of TPDFSeparationColor;
    FShaders: array of TPDFShader;
    FTilingPatterns: array of TPDFTilingPattern;
    CapturedPages: TObjectList;
    FRepaired: Boolean;
    FOnProgress: TQuickPDFProgressEvent;

    procedure Clear;
    procedure Init;
    function GetObjCount: Integer;
    procedure SetVersion(const NewVersion: AnsiString);
    function ValidPDFSource(const Password: WideString): TQPLValidSourceResult;
    function GetObjSource(IndObj: TPDFIndObj): AnsiString;
    function ObjSourcePosition(IndObj: TPDFIndObj): Int64;
    function GetInfoDict: TPDFDictionary;
    function GetInfoIndObj: TPDFIndObj;
    function GetRootDict: TPDFDictionary;
    function GetPagesDict: TPDFDictionary;
    function GetPagesRef: TPDFIndRef;
    function GetNameTree(const Category: AnsiString): TPDFDictionary;
    function NewObj(AObj: TPDFObject; BuildIndex: Boolean = True): TPDFIndObj;
    function GetPageCount: Integer;
    procedure ExtractEncryption;
    function GetEncrypted: TPDFEncrypted;
    procedure GenerateEncryptionKeys(ForFP: Boolean = False);
    procedure GenerateEncryptionKeys256;
    procedure EncodePermKey;
    function MakeKey(ObjNum, GenNum: Integer): AnsiString;
    procedure EncryptContent(Recode: Boolean);
    procedure DecryptContent(Recode: Boolean);
    procedure SetPassword(const NewPassword: WideString);
    procedure EncryptObject(const Key: AnsiString; Obj: TPDFObject);
    procedure DecryptObject(const Key: AnsiString; Obj: TPDFObject);
    procedure PageDecrypt(ObjNum: Integer; GenNum: Integer);
    procedure DecryptObj(Obj: TPDFObject);
    function GetOutlineDictionary: TPDFIndRef;
    procedure SetRef(Ref: TPDFIndRef; Key: AnsiString; NewValue: TPDFIndRef);
    procedure SetUseUnsafeLayers(NewValue: Boolean);
    procedure EncryptFromRec(E: TPDFEncryption);
    procedure ReplaceFontsInFontDict(F: TPDFDictionary; IsFormFont: Boolean; Options: Integer);
  public
    FillSet: Boolean;
    BreakString: WideString;
    ImageGDIPlusSettings: TGDIPlusSettings;
    XFAFormFields: AnsiString;
    SourceFileName: WideString;
    SourceFileSize: Cardinal;
    TextExtractOptions: TQPLExtractionOptions;

    constructor Create;
    destructor Destroy; override;
    function CreateBlank: Boolean;
    function LoadFromFile(const FileName, Password: WideString): TQPLLoadResult;
    function LoadFromString(const Source: AnsiString; const Password: WideString): TQPLLoadResult;
    function LoadFromStream(InStream: TStream; const Password: WideString): TQPLLoadResult;
    function SaveToFile(const FileName: WideString): Boolean;
    function AppendToFile(const FileName: WideString): Boolean;
    function AppendToString(AppendMode: Integer; const InputString: AnsiString): AnsiString;
    function SaveToString: AnsiString;
    function SaveToStream(Stream: TStream; AppendMode: Boolean): Boolean;
    function GetInfo(const Key: AnsiString): WideString;
    function GetRawInfo(const Key: AnsiString): AnsiString;
    procedure SetInfo(const Key: AnsiString; const Value: WideString; Mode: TPDFStorageMode = smString);
    function SetXMPInformation(const Key, Value, Delimiter: WideString): Boolean;
    function GetXMPInformation(const Key, Delimiter: WideString): WideString;
    procedure SetRawInfo(const Key, Value: AnsiString; Mode: TPDFStorageMode = smString);
    procedure RemoveInfo(const Key: AnsiString);
    function GetCatalogInfo(const Key: AnsiString): WideString;
    function GetRawCatalogInfo(const Key: AnsiString): AnsiString;
    procedure SetRawCatalogInfo(const Key, Value: AnsiString; Mode: TPDFStorageMode = smString);
    procedure SetCatalogInfo(const Key: AnsiString; const ValueW: WideString; Mode: TPDFStorageMode = smString);
    function GetInfoKeys: AnsiString;
    function GetCatalogKeys: AnsiString;
    function EncryptionStrength: Integer;
    function EncryptionAlgorithm: Integer;
    function EncryptionAcroX: Boolean;
    function NewImageDirectFromString(const Source: AnsiString; Width, Height, BitsPerComponent: Integer;
      const ColorSpace, Filter, Decode: WideString; Interpolate: Boolean): TPDFImage;
    function NewImageFromStream(InStream: TStream; Options: Integer;
      Compress: Integer): TPDFImage;
    function NewImageFromMetafile(InMetafile: TMetafile; Options: Integer;
      Compress: Integer): TPDFImage;
    function NewEMFFromStream(InStream: TStream; FontOptions, GeneralOptions: Integer): TPDFImage;
    function NewEMFFromStreamEx(InStream: TStream; FontOptions,
      GeneralOptions, Options: Integer): TPDFImage;

    function Encrypt(const Owner, User: AnsiString; Strength: TPDFEncryptionStrength;
      Perm: TPDFPermissions; ExtraPerm: TPDFExtraPermissions): Boolean;
    function EncryptWithFingerprint(const Fingerprint: AnsiString): Boolean;
    function EncryptionFingerprint: AnsiString;
    function Decrypt: Boolean;
    function ImageCount: Integer;
    function Image(Index: Integer): TPDFImage;
    function IsImage(Image: TPDFImage): Boolean;
    function IsImageList(ImageList: TPDFImageList): Boolean;
    function IsTextList(TextList: TPDFTextList): Boolean;
    function ReleaseTextList(TextList: TPDFTextList): Boolean;
    function ReleaseImage(Image: TPDFImage): Boolean;
    function ReleaseImageList(ImageList: TPDFImageList): Boolean;
    function IsFont(Font: TPDFFont): Boolean;
    function NewStdFont(StdFont: TPDFStdFont): TPDFFont;
    function NewTrueTypeFont(const FontName: AnsiString; Embed, Force, LoadKernPairs: Boolean): TPDFFont;
    function NewOpenTypeFont(Source: TStream): TPDFFont;
    function NewTrueTypeFontFromStream(Source: TStream): TPDFFont;
    function NewType1Font(const FileName: WideString): TPDFFont;
    function NewSubsettedFont(const FontName: AnsiString; CharSet: Integer; const SubsetChars: WideString): TPDFFont;
    function NewSubsettedTrueTypeFont(const FontName, SubsetChars: WideString;
      Options: Integer): TPDFFont;
    function NewCJKFont(CJKFontID: Integer): TPDFFont;
    function Compress: Boolean;
    procedure CompressPage(PageNumber: Integer);
    function CheckUserPassword(const Password: WideString): Boolean;
    function CheckOwnerPassword(const Password: WideString): Boolean;
    function CalculateVer6Hash(var SHAInput: TQPLByteArray; const PasswordA: AnsiString; TruncLength: Integer; const UK: AnsiString): AnsiString;
    procedure CheckObjects;
    procedure SetMetadata(const NewXMP: AnsiString);
    function GetMetadata: AnsiString;
    function NewPostScriptXObject(const PS: AnsiString): TPDFIndRef;
    function CanDecrypt: Boolean;

    function NewRGBAxialShader(const ShaderName: AnsiString; StartX, StartY,
      StartRed, StartGreen, StartBlue, EndX, EndY, EndRed, EndGreen,
      EndBlue: Double; Extend: Boolean): TPDFRGBAxialShader;
    function HasShader(const ShaderName: AnsiString): Boolean;
    function FindShader(const ShaderName: AnsiString): TPDFShader;

    function NewTilingPattern(const TilingPatternName: AnsiString; XObjectStream: TPDFStream): TPDFTilingPattern;
    function HasTilingPattern(const TilingPatternName: AnsiString): Boolean;
    function FindTilingPattern(const TilingPatternName: AnsiString): TPDFTilingPattern;

    procedure SetBaseURL(const NewBaseURL: AnsiString);
    function GetBaseURL: AnsiString;

    function NewOutline(ParentRef: TPDFIndRef; const Title: WideString;
      DestPage: Integer; DestPosition: Double): TPDFIndRef;
    function NewStaticOutline(ParentRef: TPDFIndRef; const Title: WideString): TPDFIndRef;
    function MoveOutline(OutlineRef, SiblingRef: TPDFIndRef; Before: Boolean): Boolean;
    function FirstOutline: TPDFIndRef;
    function FirstChildOutline(OutlineRef: TPDFIndRef): TPDFIndRef;
    function GetOutlinePage(OutlineRef: TPDFIndRef): Integer;
    function GetOutlineDest(OutlineRef: TPDFIndRef): TPDFObject;
    function GetAnnotDest(AnnotRef: TPDFIndRef): TPDFArray;
    function GetPageFromRef(Ref: TPDFIndRef): Integer;
    function NextOutline(OutlineRef: TPDFIndRef): TPDFIndRef;
    function PrevOutline(OutlineRef: TPDFIndRef): TPDFIndRef;
    function ParentOutline(OutlineRef: TPDFIndRef): TPDFIndRef;
    function OutlineCount: Integer;
    function OutlineTitle(OutlineRef: TPDFIndRef): WideString;
    function GetOutlineFromIndex(Index: Integer): TPDFIndRef;
    procedure SetOutlineColor(OutlineRef: TPDFIndRef;
      Red, Green, Blue: Double);
    function GetOutlineColor(OutlineRef: TPDFIndRef; ColorComponent: Integer): Double;
    procedure SetOutlineStyle(OutlineRef: TPDFIndRef;
      Italic, Bold: Boolean);
    function OutlineIsBold(OutlineRef: TPDFIndRef): Boolean;
    function OutlineIsItalic(OutlineRef: TPDFIndRef): Boolean;
    procedure SetOutlineDest(OutlineRef: TPDFIndRef; DestPage: Integer;
      DestPosition: Double; Zoom: Integer = 0);
    procedure SetOutlineDestFull(OutlineRef: TPDFIndRef; DestPage, Zoom, DestType: Integer;
      Left, Top, Right, Bottom: Double);
    procedure SetOutlineNamedDest(OutlineRef: TPDFIndRef; const DestName: AnsiString);
    procedure SetOutlineOpenFile(OutlineRef: TPDFIndRef; const FileName: AnsiString);
    function GetOutlineOpenFile(OutlineRef: TPDFIndRef): AnsiString;
    procedure SetOutlineRemoteDestination(OutlineRef: TPDFIndRef;
      const FileName: AnsiString; OpenPage, Zoom, DestType: Integer; Left, Top,
      Right, Bottom: Double; NewWindow: Boolean);
    procedure SetOutlineJS(OutlineRef: TPDFIndRef; const JavaScript: WideString);
    function GetOutlineJS(OutlineRef: TPDFIndRef): WideString;
    procedure SetOutlineWebLink(OutlineRef: TPDFIndRef; const Link: AnsiString);
    function GetOutlineWebLink(OutlineRef: TPDFIndRef): AnsiString;
    procedure SetOutlineTitle(OutlineRef: TPDFIndRef; const NewTitle: WideString);
    function RemoveOutline(OutlineRef: TPDFIndRef): Boolean;
    procedure OpenOutline(OutlineRef: TPDFIndRef);
    procedure CloseOutline(OutlineRef: TPDFIndRef);
    function GetOutlineAction(OutlineRef: TPDFIndRef): TPDFDictionary;
    procedure CloneOutlineAction(OutlineRef: TPDFIndRef);
    procedure UnlinkOutlineFromPageList(OutlineRef: TPDFIndRef; DeletedPageRefs: array of TPDFIndRef);

    procedure ClearPageLabels;
    procedure AddPageLabelEntry(Start: Integer; const Style: AnsiString;
      Offset: Integer; const Prefix: WideString);
    function GetPageLabel(Page: Integer): WideString;

    procedure XRefItem(O: Integer; N: Int64; G: Integer; T: AnsiChar);
    procedure XRefTrailer(const Trailer: AnsiString);
    procedure XRefRead(Pos: Int64);

    function SetPageMode(NewMode: TPDFPageMode): Boolean;
    function GetPageMode: TPDFPageMode;
    function SetPageLayout(NewLayout: TPDFPageLayout): Boolean;
    function GetPageLayout: TPDFPageLayout;
    function SetBoolViewerPreferences(const Key: AnsiString; Value: Boolean): Boolean;
    function SetNameViewerPreferences(const Key, Value: AnsiString): Boolean;
    function SetNumberViewerPreferences(const Key: AnsiString; Value: Integer): Boolean;
    function GetViewerPreferences(const Key: AnsiString): TPDFObject;
    function SetOpenActionMenu(const MenuItem: AnsiString): Boolean;
    function SetOpenActionDestination(Page, Zoom: Integer): Boolean;
    function SetOpenActionDestinationFull(Page, Zoom, DestType: Integer;
      Left, Top, Right, Bottom: Double): Boolean;
    function CreateDestination(TargetPage: TPDFObject; Zoom, DestType: Integer;
      Left, Top, Right, Bottom: Double; CreateReference: Boolean = False): TPDFArray;
    function GetOpenActionDestination: TPDFArray;
    function GetNamedDestination(const DestName: AnsiString): TPDFObject;
    function NewNamedDestination(const DestName: AnsiString; Dest: TPDFArray): Boolean;
    function GetDestName(const Dest: TPDFArray): AnsiString;
    function SetOpenActionJavaScript(const JavaScript: WideString): Boolean;
    function GetOpenActionJavaScript: WideString;
    function RemoveOpenAction: Boolean;
    function DocJavaScriptAction(const ActionType: AnsiString; const JavaScript: WideString): Boolean;
    function GetDocJavaScript(const ActionType: AnsiString): WideString;
    procedure AddGlobalJavaScript(const PackageName, JavaScript: WideString);
    function AttachFile(const Title: AnsiString; EmbeddedFile: TPDFIndRef): Boolean;
    function MakeEmbeddedFileSpec(const FileName: WideString; const MIMEType: AnsiString): TPDFIndRef;
    function EmbeddedFileCount: Integer;
    function GetEmbeddedFileStrProperty(Index, Tag: Integer): WideString;
    function SetEmbeddedFileStrProperty(Index, Tag: Integer; NewValue: WideString): Boolean;
    function GetEmbeddedFileIntProperty(Index, Tag: Integer): Integer;
    function GetEmbeddedFile(Index: Integer): TPDFIndRef;
    function GetEmbeddedFileStream(Index: Integer; var FileName: WideString;
      var Title: WideString; var Description: WideString): TPDFStream;
    procedure SetEmbeddedDescription(Index: Integer; const NewDescription: WideString);
    procedure SetEmbeddedFileName(Index: Integer; const NewFileName: WideString);
    procedure SetEmbeddedTitle(Index: Integer; const NewTitle: WideString);
    function GetEmbeddedFileContentToString(Index: Integer): AnsiString;
    function RemoveEmbeddedFile(Index: Integer): Boolean;
    function GetGlobalJavaScript(const PackageName: WideString): WideString;
    function RemoveGlobalJavaScript(const PackageName: WideString): Boolean;
    function GlobalJavaScriptCount: Integer;
    function GlobalJavaScriptPackageName(Index: Integer): WideString;
    function SetPageActionMenu(const MenuItem: AnsiString): Boolean;
    function Merge(Next: TPDFDocument): Boolean;
    function HasFormData: Boolean;
    function ReloadFormData: Boolean;
    function HasFontResources(PageNumber: Integer = 0): Boolean;
    function GetResourceList: AnsiString;
    procedure ResetForm;
    procedure ReserveIndObj(Count: Integer);
    function RotatePage(PageRotation: Integer): Boolean;
    function PageRotation: Integer;
    function GetPageInheritedValue(Start: TPDFDictionary; const Key: AnsiString): TPDFObject;
    function IsTaggedPDF: Boolean;

    procedure AddDefaultHTMLFonts;
    procedure SetHTMLFonts;
    procedure SetHTMLFont(const FontSet: AnsiString; Index: Integer; AFont: TPDFFont);
    function GetHTMLFont(Index: Integer): TPDFFont;
    function SetHTMLOption(const OptionName, OptionValue: AnsiString): Boolean;
    procedure AddTransparency(TransPer: Integer);
    procedure AddBlendMode(BlendMode: TPDFBlendMode);
    procedure AddOverprint(StrokingOverprint, OtherOverprint: Boolean;
      OverprintMode: Integer);
    function AddSeparationColor(const ColorName: AnsiString; C, M, Y, K: Double): Boolean;
    function FindSeparation(const ColorName: AnsiString): TPDFSeparationColor;
    procedure Compact;
    procedure ReplaceFonts(Options: Integer);
    procedure NewAcroForm;
    function NewEmptyDictRef: TPDFIndRef;
    procedure StoreData(ObjNum: Integer; Data: AnsiString);
    function GetData(ObjNum: Integer): AnsiString;
    function SetTempFileName(const FN: WideString): Boolean;
    function HasTempFile: Boolean;
    procedure Reload;
    function FindImagesMode1(FullConvert: Boolean = False): Integer;
    function FindImagesMode2(FullConvert: Boolean = False): Integer;
    procedure AddImageFromStream(ImageStream: TPDFStream; ObjNum, GenNum: Integer; FullConvert: Boolean = False);
    function FindFonts: Integer;
    function FontExists(ObjNum, GenNum: Integer): Boolean;
    function CopyPagesFromDoc(SourceDoc: TPDFDocument; const PageRanges: AnsiString;
      SortList: Boolean = True;
      AllowDuplicates: Boolean = False): Boolean;
    function CapturePage(Options: Integer): TPDFCapturedPage;
    function HasCapturedPage(Capture: TPDFCapturedPage): Boolean;
    procedure FixPageResources;
    function TempFileName: WideString;
    function IndObjects: AnsiString;
    function ApplyStyle(const Style: AnsiString): Boolean;
    function RemoveStyle(const Style: AnsiString): Boolean;
    procedure SaveStyle(const Style: AnsiString);
    function GetColorSpace(Dict: TPDFDictionary; const Key: AnsiString): AnsiString;
    function FindStyle(const Style: AnsiString): Integer;
    function GetDocID(Part, Options: Integer): AnsiString;
    function GetObjectSource(ObjNum: Integer): AnsiString;
    procedure SetObjectSource(ObjNum: Integer; const NewObjectSource: AnsiString);
    function GetObjectDecodeError(ObjNum: Integer): Boolean;
    function NewStream(const D, S: AnsiString): Integer;
    function FindObj(ObjNum, GenNum: Integer): TPDFIndObj;
    procedure ReplaceObj(ObjNum, GenNum: Integer; NewObject: TPDFObject);

    function GetID: TPDFArray;
    function NewOCG(const GroupName: WideString): TPDFIndRef;
    function OCGCount: Integer;
    function OCGName(OCGRef: TPDFIndRef): WideString;
    function SetOCGName(OCGRef: TPDFIndRef; const NewName: WideString): Boolean;
    function OCGRef(Index: Integer): TPDFIndRef;
    function SetOCGVisible(OCGRef: TPDFIndRef; Visible: Boolean): Boolean;
    function SetOCGPrintable(OCGRef: TPDFIndRef; Printable: Integer): Boolean;
    function GetOCGVisible(OCGRef: TPDFIndRef): Boolean;
    function GetOCGPrintable(OCGRef: TPDFIndRef): Boolean;
    function GetOCGState(OCGRef: TPDFIndRef; const Key: AnsiString): Boolean;
    function SetOCGUsage(OCGRef: TPDFIndRef; const Key, Value: AnsiString): Boolean;
    function RemoveOCGUsage(OCGRef: TPDFIndRef; const Key: AnsiString): Boolean;
    function SetOCGAutoState(OCGRef: TPDFIndRef; const Key: AnsiString; Include: Boolean): Boolean;
    function DeleteOCG(OCGRef: TPDFIndRef): Boolean;
    function StandardFont(StandardFontID: Integer): TPDFIndRef;
    function RemoveSharedLayers: Boolean;
    function FirstPage: TPDFDictionary;
    function FirstPageFrom(Start: TPDFDictionary): TPDFDictionary;
    function NextPage(Start: TPDFDictionary): TPDFDictionary;
    procedure SetMinimumVersion(const MinVer: AnsiString);
    procedure SetExtensionLevel(const ExtensionLevel: AnsiString);
    function CreateTable(RowCount, ColumnCount: Integer): TPDFTable;
    function FindTable(Table: TPDFTable): TPDFTable;
    function DrawTableRows(Table: TPDFTable; Left, Top, Height: Double; FirstRow, LastRow: Integer): Double;
    function FindPage(PageRef: TPDFIndRef): Integer;
    function GetOptionalContentConfigCount: Integer;
    function GetOptionalContentConfigState(ConfigID: Integer; OCGRef: TPDFIndRef): Integer;
    function SetOptionalContentConfigState(ConfigID: Integer; OCGRef: TPDFIndRef; NewState: Integer): Boolean;
    function GetOptionalContentConfigLocked(ConfigID: Integer; OCGRef: TPDFIndRef): Boolean;
    function SetOptionalContentConfigLocked(ConfigID: Integer; OCGRef: TPDFIndRef; Locked: Boolean): Boolean;
    function GetOptionalContentConfigDict(ConfigID: Integer): TPDFDictionary;
    procedure BuildOptionalContentConfigOrderArray(Source: TPDFArray; var ItemList: TPDFOCGConfigOrderItems; Level: Integer);
    function GetOptionalContentConfigOrderCount(ConfigID: Integer): Integer;
    function GetOptionalContentConfigOrderItemType(ConfigID, ItemIndex: Integer): Integer;
    function GetOptionalContentConfigOrderItemLabel(ConfigID, ItemIndex: Integer): WideString;
    function GetOptionalContentConfigOrderItemOCG(ConfigID, ItemIndex: Integer): TPDFIndRef;
    function GetOptionalContentConfigOrderItemLevel(ConfigID, ItemIndex: Integer): Integer;
    procedure SetNoEmbedFontList(FontList: TQuickPDFStringList);
    procedure ClearNoEmbedFontList;
    function GetTabOrderMode: AnsiString;
    function SetTabOrderMode(Value: AnsiString): Integer;

    function RemoveUsageRights: Boolean;
    function CreateNewObject: Integer;
    procedure SetOldFormat;
    function SetPDFAMode(NewMode: Integer): Boolean;
    procedure AddOutputIntent(const ColorSpace: AnsiString);
    procedure SetMarkInfo(NewMarkInfo: Boolean);
    function IndObjSummary: WideString;
    function HasUserPassword: Boolean;
    function HasOwnerPassword: Boolean;
    function GetViewOCGList: TQPLOCGStateList;
    function GetPrintOCGList: TQPLOCGStateList;
    procedure BalancePageTree;
    procedure SetHeaderComments(const Source: AnsiString);

    function NewObjRef(AObj: TPDFObject): TPDFIndRef;

    property Changed: Boolean read FChanged;
    property UserModDate: Boolean read FUserModDate write FUserModDate;
    property Version: AnsiString read FVersion write SetVersion;
    property PageCount: Integer read GetPageCount;
    property PageTree: TPDFPageTree read FPageTree;
    property Encrypted: TPDFEncrypted read GetEncrypted;
    property PermissionsKey: Cardinal read PermKey;
    property Linearized: Boolean read FLinearized;
    property FontCount: Integer read GetFontCount;
    property Font[FontIndex: Integer]: TPDFFont read GetFont;
    property AcroForm: TPDFForm read FAcroForm;
    property ObjCount: Integer read GetObjCount;
    property MaxObjNum: Integer read FMaxObjNum;
    property Trailer: TPDFDictionary read FTrailer;
    property InfoDict: TPDFDictionary read GetInfoDict;
    property RootDict: TPDFDictionary read GetRootDict;
    property PagesDict: TPDFDictionary read GetPagesDict;
    property Structure: TPDFStructure read FStructure;
    property Scale: Double read FScale write FScale;
    property CompressImages: Integer read FCompressImages write FCompressImages;
    property CompressFonts: Integer read FCompressFonts write FCompressFonts;
    property UseExistingFonts: Integer read FUseExistingFonts write FUseExistingFonts;
    property Origin: Integer read FOrigin write FOrigin;
    property JavaScriptMode: TPDFStorageMode read FJavaScriptMode write FJavaScriptMode;
    property UseUnsafeLayers: Boolean read FUseUnsafeLayers write SetUseUnsafeLayers;
    property OnProgress: TQuickPDFProgressEvent read FOnProgress write FOnProgress;
    property NoPagesDict: Boolean read FNoPagesDict;
    property PDFAMode: Integer read FPDFAMode;
    property IsUserPassword: Boolean read FIsUserPassword;
    property IsOwnerPassword: Boolean read FIsOwnerPassword;
    property Repaired: Boolean read FRepaired;
    property Source: AnsiString read FSource;
    property DecodeMode: Integer read FDecodeMode write FDecodeMode;

    property IncludedFonts: TObjectList read FIncludedFonts;
  end;

implementation

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  SysUtils, DebenuPDFLibraryDigest, DebenuPDFLibraryEncrypt, DebenuPDFLibraryFlate,
  Math, DebenuPDFLibraryTIFF, DebenuPDFLibraryNameTree, DebenuPDFLibraryFontConst, DebenuPDFLibraryAES,
  DebenuPDFLibraryEncoding, DebenuPDFLibraryRebuild;

procedure FindNextNumber(var S: AnsiString);
const
  Valid: AnsiString = '0123456789.';
begin
  if Length(S) > 1 then
  begin
    while (QPLPos(S[1], Valid) = 0) and (Length(S) > 1) do
      Delete(S, 1, 1);
  end;
end;

procedure FindNextNumberPos(const S: AnsiString; var PopPos: Int64);
const
  Valid: AnsiString = '0123456789.';
begin
  while (PopPos < Length(S)) and (QPLPos(S[PopPos], Valid) = 0) do
  begin
    Inc(PopPos);
  end;
end;

{ TPDFIndObj }

constructor TPDFIndObj.Create(AParent: TPDFDocument);
begin
  FParent := AParent;
  FDecoded := False;
  FObj := nil;
  FDecrypted := False;
  FRecoded := False;
  FNewSource := '';
  FSpooled := False;
  FDecodeError := False;
  FDecodeMode := 2;
end;

procedure TPDFIndObj.Decode;
var
  ObjSource: AnsiString;
  AObjNum: Integer;
  AGenNum: Integer;
  PDFObject: TPDFObject;
  StreamStart: Integer;
  StreamLength: Integer;
  StreamData: AnsiString;
  PDFStream: TPDFStream;
  ShiftObjNum: AnsiString;
  AShiftObjNum: Integer;
  ThirdPop: AnsiString;
begin

  if (FDecodeMode >= 2) then
  begin
    DecodeDirect;
    Exit;
  end;

  FDecoded := True;
  ObjSource := Source;
  if Assigned(FObj) then FObj.Free;
  if FCompact then FDecrypted := True;

  AObjNum := QPLStrToIntDef(PopNumber(ObjSource), 0);
  AGenNum := QPLStrToIntDef(PopNumber(ObjSource), 0);
  ThirdPop := PopText(ObjSource);

  ShiftObjNum := QPLIntToStr(FObjNum);
  Delete(ShiftObjNum, 1, 1);
  AShiftObjNum := QPLStrToIntDef(ShiftObjNum, 0);

  if (AObjNum <> FObjNum) and (AObjNum = AShiftObjNum) and (AGenNum = FGenNum) and
    (ThirdPop = 'obj') then
  begin
    Dec(FPosition);

    ObjSource := Source;

    AObjNum := QPLStrToIntDef(PopNumber(ObjSource), 0);
    AGenNum := QPLStrToIntDef(PopNumber(ObjSource), 0);
    ThirdPop := PopText(ObjSource);

    if (AObjNum = FObjNum) and (AGenNum = FGenNum) and
      (ThirdPop = 'obj') then
    begin
      // We found a valid object at the shifted position
    end else
    begin
      Inc(FPosition);
      AObjNum := 0;
      AGenNum := 0;
      ThirdPop := '';
    end;
  end;

  if (AObjNum = FObjNum) and (AGenNum = FGenNum) and
    (ThirdPop = 'obj') then
  begin
    PDFObject := FParent.FStructure.Decode(ObjSource);

    StreamStart := 0;
    if (PDFObject is TPDFDictionary) and IsStream(ObjSource, StreamStart, StreamLength) then
    begin
      StreamData := QPLCopy(ObjSource, StreamStart, StreamLength);
      PDFStream := FParent.FStructure.NewStream(StreamData);
      PDFStream.Dictionary.Assign(TPDFDictionary(PDFObject));
      PDFStream.Dictionary.Add('Length',
        FParent.FStructure.NewNumeric(Length(StreamData)));
      PDFObject := PDFStream;
    end;
  end else
  begin
    PDFObject := FParent.FStructure.NewNull;
    FDecodeError := True;
  end;

  FObj := PDFObject;
  PDFObject.Own(AObjNum, AGenNum);
end;

procedure TPDFIndObj.DecodeDirect;
var
  AObjNum: Integer;
  AGenNum: Integer;
  PDFObject: TPDFObject;
  StreamStart: Integer;
  StreamLength: Integer;
  StreamData: AnsiString;
  PDFStream: TPDFStream;
  ThirdPop: AnsiString;
  TempObjSource: AnsiString;
  ObjectPosition: Int64;
  ObjIsStream: Boolean;
  FoundAdjustment: Boolean;
  StartTestPos: Int64;
begin
  FDecoded := True;

  if Recoded then
  begin
    TempObjSource := Source;
    ObjectPosition := 1;
  end else
  begin
    TempObjSource := '';
    ObjectPosition := FParent.ObjSourcePosition(Self);
    if (ObjectPosition = 0) then
    begin
      TempObjSource := Source;
      ObjectPosition := 1;
    end;
  end;

  if Assigned(FObj) then FObj.Free;
  if FCompact then FDecrypted := True;

  if (Length(TempObjSource) = 0) then
  begin
    AObjNum := QPLStrToIntDef(PopNumberPos(FParent.Source, ObjectPosition), 0);
    AGenNum := QPLStrToIntDef(PopNumberPos(FParent.Source, ObjectPosition), 0);
    ThirdPop := PopTextPos(FParent.Source, ObjectPosition);

    if (AObjNum <> FObjNum) or (AGenNum <> FGenNum) or
      (ThirdPop <> 'obj') then
    begin
      FoundAdjustment := False;
      StartTestPos := FParent.ObjSourcePosition(Self) - 6;
      repeat
        ObjectPosition := StartTestPos;
        if (ObjectPosition < 1) then
          ObjectPosition := 1;
        AObjNum := QPLStrToIntDef(PopNumberPos(FParent.Source, ObjectPosition), 0);
        AGenNum := QPLStrToIntDef(PopNumberPos(FParent.Source, ObjectPosition), 0);
        ThirdPop := PopTextPos(FParent.Source, ObjectPosition);
        if (AObjNum = FObjNum) and (AGenNum = FGenNum) and
          (ThirdPop = 'obj') then
        begin
          FoundAdjustment := True;
        end;
        Inc(StartTestPos);
      until (FoundAdjustment) or (StartTestPos >= (FParent.ObjSourcePosition(Self) + 6));
    end;
  end else
  begin
    AObjNum := QPLStrToIntDef(PopNumber(TempObjSource), 0);
    AGenNum := QPLStrToIntDef(PopNumber(TempObjSource), 0);
    ThirdPop := PopText(TempObjSource);
  end;

  if (AObjNum = FObjNum) and (AGenNum = FGenNum) and
    (ThirdPop = 'obj') then
  begin
    if (Length(TempObjSource) > 0) then
    begin
      PDFObject := FParent.FStructure.Decode(TempObjSource);
    end else
    begin
      PDFObject := FParent.FStructure.DecodeWithLength(FParent.Source, Self.FLength, ObjectPosition);
    end;

    ObjIsStream := False;
    if (PDFObject is TPDFDictionary) then
    begin
      if (Length(TempObjSource) > 0) then
      begin
        StreamStart := 0;
        if (FDecodeMode = 2) then
        begin
          ObjIsStream := IsStreamU(TempObjSource, StreamStart, StreamLength);
        end else
        begin
          ObjIsStream := IsStream(TempObjSource, StreamStart, StreamLength);
        end;
      end else
      begin
        StreamStart := ObjectPosition;
        if (FDecodeMode = 3) then
        begin
          ObjIsStream := IsStreamD(FParent.Source, StreamStart, StreamLength, TPDFDictionary(PDFObject), Self.FLength);
        end else
        if (FDecodeMode = 2) then
        begin
          ObjIsStream := IsStreamU(FParent.Source, StreamStart, StreamLength);
        end else
        begin
          ObjIsStream := IsStream(FParent.Source, StreamStart, StreamLength);
        end;
      end;
    end;

    if (ObjIsStream) then
    begin
      if (Length(TempObjSource) > 0) then
      begin
        StreamData := QPLCopy(TempObjSource, StreamStart, StreamLength);
      end else
      begin
        StreamData := QPLCopy(FParent.Source, StreamStart, StreamLength);
      end;
      PDFStream := FParent.FStructure.NewStream(StreamData);
      PDFStream.Dictionary.Assign(TPDFDictionary(PDFObject));
      PDFStream.Dictionary.Add('Length',
        FParent.FStructure.NewNumeric(Length(StreamData)));
      PDFObject := PDFStream;
    end;
  end else
  begin
    PDFObject := FParent.FStructure.NewNull;
    FDecodeError := True;
  end;

  FObj := PDFObject;
  PDFObject.Own(AObjNum, AGenNum);
end;

procedure TPDFIndObj.Encrypt;
begin
  if FDecrypted then
  begin
    FParent.EncryptObject(FParent.MakeKey(FObjNum, FGenNum), GetObj);
    FDecrypted := False;
  end;
end;

function TPDFIndObj.GetObj: TPDFObject;
begin
  if not FDecoded then Decode;
  Result := FObj;
  if (FObj <> nil) and (not FDecrypted) then Decrypt;
end;

function TPDFIndObj.HasChanged: Boolean;
begin
  if (Assigned(FObj)) then
  begin
    Result := FObj.HasChanged;
  end else
  begin
    Result := False;
  end;
end;

function TPDFIndObj.IsStreamU(const Content: AnsiString; var SStart, SLen: Integer): Boolean;

  function PositionIsValid(const AContent: AnsiString; const APosition: Integer): Boolean;
  begin
    Result := (APosition >= 0) and (APosition < Length(AContent));
  end;

  procedure ProcessWhitespaceForeward(const AContent: AnsiString; var ASP: Integer; const AEP: integer);
  var
    InWhitespace: Boolean;
    EP: Integer;
  begin
    EP := min(AEP, Length(AContent));
    if (ASP >= 0) and (ASP < EP) then
    begin
      repeat
        InWhitespace := (AContent[ASP] = #0) or (AContent[ASP] = #9) or
          (AContent[ASP] = #12) or (AContent[ASP] = #32);
        if (InWhitespace) then
        begin
          Inc(ASP);
        end;
      until (ASP >= EP) or (not InWhitespace);
    end;
  end;

  procedure ProcessWhitespaceBackward(const AContent: AnsiString; var ASP: integer; const AEP: integer);
  var
    InWhitespace: Boolean;
    EP: Integer;
  begin
    if PositionIsValid(AContent, ASP) then
    begin
      EP := max(0, AEP);
      repeat
        InWhitespace := (AContent[ASP] = #0) or (AContent[ASP] = #9) or
          (AContent[ASP] = #12) or (AContent[ASP] = #32);
        if (InWhitespace) then
        begin
          Dec(ASP);
        end;
      until (ASP <= EP) or (not InWhitespace);
    end;
  end;

  procedure ProcessNewLineMarker(const AContent: AnsiString; AForward: Boolean; var APosition: integer);
  begin
    if PositionIsValid(AContent, APosition) then
    begin
      if AContent[APosition] = #10 then
      begin
        if AForward then
          Inc(APosition)
        else
          Dec(APosition);
      end;

      if PositionIsValid(AContent, APosition) then
      begin
        if AContent[APosition] = #13 then
        begin
          if AForward then
            Inc(APosition)
          else
            Dec(APosition);

          if PositionIsValid(AContent, APosition) then
          begin
            if AContent[APosition] = #10 then
            begin
              if AForward then
                Inc(APosition)
              else
                Dec(APosition);
            end;
          end;
        end;
      end;
    end;
  end;

  procedure ProcessStreamStartNewLineMarker(const AContent: AnsiString; var APosition: integer);
  begin
    // if stream data starts on newline, this new line marker has to be LF, CR+LF
    // but not CR alone!
    if PositionIsValid(AContent, APosition) then
    begin
      if AContent[APosition] = #13 then
      begin
        Inc(APosition);

        if PositionIsValid(AContent, APosition) then
        begin
          if AContent[APosition] = #10 then
          begin
            Inc(APosition);
          end else
          begin
            // This is an invalid stream keyword. It is followed by
            // a CR but the next character is not a LF
            // Process it anyway
          end;
        end;
      end else
      if AContent[APosition] = #10 then
      begin
        Inc(APosition);
      end else
      begin
        // this is definitely an invalid stream so do not allow to process it
        // Stream data has to start on new line.
        APosition := 0;
      end;
    end;
  end;

var
  CP: Integer;
  SP: Integer;
  EP: Integer;
  TempStruc: TPDFStructure;
  Dict: TPDFObject;
  LengthObj: TPDFObject;
  FilterObj: TPDFObject;
  Filter: AnsiString;
  IndObj: TPDFIndObj;
  FoundStreamKeyword: Boolean;
  FoundEndstreamKeyword: Boolean;
begin
  Result := False;
  SLen := 0;

  TempStruc := TPDFStructure.Create;
  try
    Dict := nil;
    if (SStart > 0) then
    begin
      Dict := TempStruc.DecodeWithLength(Content, SP, SStart);
      SP := SP + SStart;
      SStart := 0;
    end else
    begin
      SStart := 0;
      if QPLPos('stream', Content) > 0 then
      begin
        Dict := TempStruc.DecodeWithLength(Content, SP);
        Inc(SP);
      end;
    end;

    EP := Length(Content);
    FoundStreamKeyword := False;

    // There must be at least enough content left for the
    // stream and endstream tokens
    // do not worry about setting it to nil. Also DecodeWithLength always results
    //      in a new object <> nil, this object is maintained by TPDFStructure.Objects!
    if (EP - SP) < 13 then Dict := nil;

    // now check, that the content contain some kind of valid data: a stream has
    // to start with 'stream' keyword and is not allowed to have an 'endobj' found
    // before 'stream'
    if (Dict is TPDFDictionary) then
    begin
      repeat
        if (Content[SP] = 's') then
        begin
          if QPLCopy(Content, SP, 6) = 'stream' then
          begin
            FoundStreamKeyword := True;
          end;
        end else
        if (Content[SP] = 'e') then
        begin
          if QPLCopy(Content, SP, 6) = 'endobj' then
          begin
            FoundStreamKeyword := False;
            EP := SP;
          end;
        end;
        if (not FoundStreamKeyword) then
        begin
          Inc(SP);
        end;
      until (SP >= EP) or (FoundStreamKeyword);
    end;

    if (FoundStreamKeyword) then
    begin
      // adjust start of stream to point on next byte after 'stream' keyword.
      Inc(SP, 6);

      // Remove invalid whitespace
      ProcessWhitespaceForeward(Content, SP, EP);

      // process special NewLine Marker for beginning of stream
      ProcessStreamStartNewLineMarker(Content, SP);

      if SP > 0 then
      begin
        // now read Length and Filter from object dictionary
        LengthObj := (Dict as TPDFDictionary).FindValueByKeyName('Length');
        FilterObj := (Dict as TPDFDictionary).FindValueByKeyName('Filter');
        if Assigned(FilterObj) then Filter := FilterObj.Output else Filter := '';

        if LengthObj is TPDFIndRef then
        begin
          IndObj := FParent.FindObj(TPDFIndRef(LengthObj).ObjNum,
            TPDFIndRef(LengthObj).GenNum);
          if Assigned(IndObj) then
            LengthObj := IndObj.Obj
          else
            LengthObj := nil;
        end;

        // Length is a required property of any stream, so allow processing only if valid
        if LengthObj is TPDFNumeric then
        begin
          SLen := Round((LengthObj as TPDFNumeric).AsDouble);
          EP := SP + SLen;

          // At first, be optimistic and assume that the Length value is correct
          // then look for 'endstream' keyword at SP+Length + a small offset due to EOL markers

          // first remove any NewLine marker in front as they are not included on Length
          ProcessNewLineMarker(Content, True, EP);

          // now remove any following whitespace (50 bytes ahead)
          ProcessWhitespaceForeward(Content, EP, EP + 50);

          // at this EP position, we have to find 'endstream', if Length is valid
          FoundEndstreamKeyword := False;
          if QPLCopy(Content, EP, 9) = 'endstream' then
          begin
            // Fine, we found the keyword, but now check, that it's the right one
            // and not from a later stream

            // FIX : Flate Encoded PDF files will often include 'endstream' in
            // clear text in the Flate encoded data so the following check is
            // not valid for PDF files.  So assume it is correct.

            //if QPLPos('endstream', QPLCopy(Content, SP, EP - SP)) <= 0 then
            begin
              FoundEndstreamKeyword := true;
              Result := true;
              SStart := SP;
            end;
          end;

          if not FoundEndstreamKeyword then
          begin
            // endstream was not found at this position, then the next step has to be to find
            // the matching 'endstream' keyword inside given content stream.
            // Do not assume that it is on end of content string, as the content may be the
            // entire PDF data and not only the stream objects string!

            // the only way I found to do this is starting from beginning and looking for
            // 'endstream' keyword. Why this: we cannot trust on Length value to be nearly correct
            // (it may point to a position to far from start point, so that intermediate
            // endstream/endobj is not found)
            // and searching from end of content will not work if content is entire PDF
            // but not the object data source only.
            FoundEndstreamKeyword := False;
            CP := SP;
            repeat
              if (Content[CP] = 'e') then
              begin
                // do we have found the endstream?
                if QPLCopy(Content, CP, 9) = 'endstream' then
                  FoundEndstreamKeyword := true
                else
                  if QPLCopy(Content, CP, 6) = 'endobj' then
                  begin
                    // in this situation we have a totally invalid stream and have
                    // to stop it processing
                    // (Objects' source ends before end of stream)
                    FoundEndstreamKeyword := False;
                    CP := Length(Content);
                  end;
              end;

              if (not FoundEndstreamKeyword) then
                inc(CP);
            until (FoundEndstreamKeyword) or (CP >= Length(Content));

            // do we have found the end of stream?
            if FoundEndstreamKeyword then
            begin
              // now check the already stored Length and correct it to adapt
              // to real stream data
              EP := CP - 1;

              // For this, remove any special whitespace and newlines that
              // immediately precede the endstream keyword
              ProcessWhitespaceBackward(Content, EP, SP);

              // preceding optional NewLine Marker also needs to be removed (max. 2 steps)
              ProcessNewLineMarker(Content, False, EP);

              // now we can calculate the real data length
              Result := true;
              SStart := SP;
              SLen := EP - SP + 1;

              // here we also have chance to check the Length value: if it do not
              // coinsistent with our calculated value, there is a problem with PDF that
              // should be fixed.
            end
            else
            begin
              // this is not a valid stream, so report this back
              Result := False;
              SStart := SP;
              SLen := 0;
            end;
          end;
        end;
      end;
    end;
  finally
    TempStruc.Free;
  end;
end;

function TPDFIndObj.IsStreamD(const Content: AnsiString; var SStart, SLen: Integer; Dict: TPDFDictionary; DictLength: Integer): Boolean;
begin
  Result := False;
  SLen := 0;

end;

function TPDFIndObj.IsStream(const Content: AnsiString; var SStart, SLen: Integer): Boolean;
var
  SP: Integer;
  EP: Integer;
  OldEP: Integer;
  TempStruc: TPDFStructure;
  Dict: TPDFObject;
  LengthObj: TPDFObject;
  FilterObj: TPDFObject;
  Filter: AnsiString;
  IndObj: TPDFIndObj;
  InWhitespace: Boolean;
  FoundStreamKeyword: Boolean;
  EndStreamLocation: Integer;
begin
  Result := False;
  SLen := 0;

  TempStruc := TPDFStructure.Create;
  try
    Dict := nil;
    if (SStart > 0) then
    begin
      Dict := TempStruc.DecodeWithLength(Content, SP, SStart);
      SP := SP + SStart;
      SStart := 0;
    end else
    begin
      SStart := 0;
      if QPLPos('stream', Content) > 0 then
      begin
        Dict := TempStruc.DecodeWithLength(Content, SP);
        Inc(SP);
      end;
    end;

    EP := Length(Content);
    FoundStreamKeyword := False;

    // There must be at least enough content left for the
    // stream and endstream tokens
    if (EP - SP) < 13 then Dict := nil;

    if (Dict is TPDFDictionary) then
    begin
      repeat
        if (Content[SP] = 's') then
        begin
          if QPLCopy(Content, SP, 6) = 'stream' then
          begin
            FoundStreamKeyword := True;
          end;
        end else
        if (Content[SP] = 'e') then
        begin
          if QPLCopy(Content, SP, 6) = 'endobj' then
          begin
            FoundStreamKeyword := False;
            EP := SP;
          end;
        end;
        if (not FoundStreamKeyword) then
        begin
          Inc(SP);
        end;
      until (SP >= EP) or (FoundStreamKeyword);
    end;

    if (FoundStreamKeyword) then
    begin
      Inc(SP, 6);

      repeat
        InWhitespace := (Content[SP] = #0) or (Content[SP] = #9) or
          (Content[SP] = #12) or (Content[SP] = #32);
        if (InWhitespace) then
        begin
          Inc(SP);
        end;
      until (SP >= EP) or (not InWhitespace);

      if Content[SP] = #13 then
      begin
        Inc(SP);
        if Content[SP] = #10 then
        begin
          Inc(SP);
        end else
        begin
          // This is an invalid stream keyword. It is followed by
          // a CR but the next character is not a LF
          // Process it anyway
        end;
      end else
      if Content[SP] = #10 then
      begin
        Inc(SP);
      end else
      begin
        SP := 0;
      end;

      if SP > 0 then
      begin
        LengthObj := (Dict as TPDFDictionary).FindValueByKeyName('Length');
        FilterObj := (Dict as TPDFDictionary).FindValueByKeyName('Filter');
        if Assigned(FilterObj) then Filter := FilterObj.Output else Filter := '';

        if LengthObj is TPDFIndRef then
        begin
          IndObj := FParent.FindObj(TPDFIndRef(LengthObj).ObjNum,
            TPDFIndRef(LengthObj).GenNum);
          if Assigned(IndObj) then
            LengthObj := IndObj.Obj
          else
            LengthObj := nil;
        end;

        if LengthObj is TPDFNumeric then
        begin
          SLen := Round((LengthObj as TPDFNumeric).AsDouble);
          EP := SP + SLen;

          if (EP > Length(Content)) then
          begin
            // The /Length indicator was greater than the number of bytes
            // between the "stream" and "endstream" tokens.
            // Start at the end of the Contents string, and cycle back until
            // the "endstream" token is found (max 20 bytes)
            EP := Length(Content);
            repeat
              Dec(EP);
            until (EP < (Length(Content) - 20)) or (QPLCopy(Content, EP, 9) = 'endstream');
          end;

          OldEP := EP;
          repeat
            InWhitespace := (Content[EP] = #0) or (Content[EP] = #9) or
              (Content[EP] = #12) or (Content[EP] = #32);
            if (InWhitespace) then
            begin
              Inc(EP);
            end;
          until (EP >= OldEP) or (not InWhitespace);

          // Check for a /Length value that is one byte too long
          if QPLCopy(Content, EP, 1) = 'n' then Dec(EP);

          if QPLCopy(Content, EP, 1) = #13 then Inc(EP);
          if QPLCopy(Content, EP, 1) = #10 then Inc(EP);

          EndStreamLocation := QPLPos('endstream', QPLCopy(Content, EP, MaxInt));

          if (EndStreamLocation = 0) then
          begin
            // No "endstream" token was found, cycle back up to 10 bytes to check
            OldEP := EP;
            repeat
              Dec(EP);
              EndStreamLocation := QPLPos('endstream', QPLCopy(Content, EP, MaxInt));
            until (EP < (OldEP - 20)) or (EndStreamLocation = 1);
          end;

          if EndStreamLocation = 1 then
          begin
            Result := True;
            SStart := SP;
          end else
          if EndStreamLocation > 1 then
          begin
            // The endstream keyword was found but it was not in the
            // expected location. Attempt to process this malformed
            // stream object anyway

            Result := True;
            SStart := SP;
            Inc(SLen, EndStreamLocation - 1);
          end
          else
          begin // Now check to see if endstream is in the middle somewhere
            EndStreamLocation := QPLPos('endstream', QPLCopy(Content, SP, EP - SP));
            Result := True;
            SStart := SP;
            SLen := EndStreamLocation - 1;
          end;
        end;
      end;
    end;
  finally
    TempStruc.Free;
  end;
end;

function TPDFIndObj.Output: AnsiString;
begin
  if not Decoded then Decode;
  Result := QPLIntToStr(FObjNum) + ' ' + QPLIntToStr(FGenNum) + ' obj' + #10 +
    FObj.Output;
  if QPLCopy(Result, Length(Result), 1) <> #10 then Result := Result + #10;
  Result := Result + 'endobj' + #10;
end;

function TPDFIndObj.PopNumber(var S: AnsiString): AnsiString;
var
  X: Integer;
const
  Valid: AnsiString = '0123456789.';
begin
  Result := '';
  FindNextNumber(S);
  if Length(S) > 1 then
  begin
    X := 1;
    while (QPLPos(S[X], Valid) > 0) and (X < Length(S)) do
    begin
      Result := Result + S[X];
      Inc(X);
    end;
    Delete(S, 1, Length(Result));
  end;
end;

function TPDFIndObj.PopNumberPos(const S: AnsiString;
  var PopPos: Int64): AnsiString;
var
  StartPos: Int64;
const
  Valid: AnsiString = '0123456789.';
begin
  Result := '';
  FindNextNumberPos(S, PopPos);
  StartPos := PopPos;
  if (PopPos < Length(S)) then
  repeat
    Inc(PopPos);
  until (PopPos >= Length(S)) or (QPLPos(S[PopPos], Valid) = 0);
  if (PopPos < Length(S)) then
  begin
    Result := QPLCopy(S, StartPos, PopPos - StartPos);
  end;
end;

function TPDFIndObj.PopText(var S: AnsiString): AnsiString;
var
  P: Integer;
  MP: Integer;
  X: Integer;
const
  Whitespace: AnsiString = #0#9#10#12#13#32;
begin
  Result := '';
  if Length(S) > 1 then
  begin
    while (QPLPos(S[1], Whitespace) > 0) and (Length(S) > 1) do
      Delete(S, 1, 1);
    if Length(S) > 1 then
    begin
      MP := 0;
      if QPLCopy(S, 1, 4) = 'obj(' then
      begin
        MP := 4;
      end else
      if QPLCopy(S, 1, 5) = 'obj<<' then
      begin
        MP := 4;
      end else
      if QPLCopy(S, 1, 4) = 'obj[' then
      begin
        MP := 4;
      end else
      if QPLCopy(S, 1, 4) = 'obj/' then
      begin
        MP := 4;
      end else
      for X := 1 to Length(Whitespace) do
      begin
        P := QPLPos(Whitespace[X], S);
        if (P > 0) and ((MP = 0) or (P < MP)) then
          MP := P;
      end;
      Result := QPLCopy(S, 1, MP - 1);
      Delete(S, 1, MP - 1);
      while (QPLPos(S[1], Whitespace) > 0) and (Length(S) > 1) do
        Delete(S, 1, 1);
    end;
  end;
end;

function TPDFIndObj.PopTextPos(const S: AnsiString;
  var PopPos: Int64): AnsiString;
var
  MP: Integer;
const
  Whitespace: AnsiString = #0#9#10#12#13#32;
begin
  Result := '';
  if ((Length(S) > 1) and (PopPos < Length(S)) and (PopPos >= 1)) then
  begin
    while (QPLPos(S[PopPos], Whitespace) > 0) and (PopPos < Length(S)) do
    begin
      Inc(PopPos);
    end;
    if (PopPos < Length(S)) then
    begin
      MP := 0;
      if QPLCopy(S, PopPos, 4) = 'obj(' then
      begin
        MP := 4;
      end else
      if QPLCopy(S, PopPos, 5) = 'obj<<' then
      begin
        MP := 4;
      end else
      if QPLCopy(S, PopPos, 4) = 'obj[' then
      begin
        MP := 4;
      end else
      if QPLCopy(S, PopPos, 4) = 'obj/' then
      begin
        MP := 4;
      end else
      begin
        while (QPLPos(S[PopPos + MP], Whitespace) = 0) and ((PopPos + MP) < Length(S)) do
        begin
          Inc(MP);
        end;
        if ((PopPos + MP) < Length(S)) then
        begin
          Inc(MP);
        end;
      end;
      Result := QPLCopy(S, PopPos, MP - 1);
      Inc(PopPos, MP - 1);
      while (QPLPos(S[PopPos], Whitespace) > 0) and (PopPos < Length(S)) do
      begin
        Inc(PopPos);
      end;
    end;
  end;
end;

procedure TPDFIndObj.Recode;
begin
  FDecoded := False;
  FRecoded := True;
  try
    FNewSource := QPLIntToStr(FObjNum) + ' ' + QPLIntToStr(FGenNum) + ' obj'#10 + FObj.Output;
  except
    FNewSource := FObj.Output;
  end;
  if not (FObj is TPDFDictionary) then
    FNewSource := FNewSource + #10;
  FNewSource := FNewSource + 'endobj'#10;
  FObj.Purge;
  FObj := nil;
  if (Length(FNewSource) > 1024) and (FParent.FTempFileName <> '') then
  begin
    FParent.StoreData(FObjNum, FNewSource);
    FNewSource := '';
    FSpooled := True;
  end;
end;

function TPDFIndObj.Source: AnsiString;
begin
  if Recoded then
  begin
    if FSpooled then
      Result := FParent.GetData(FObjNum)
    else
      Result := FNewSource;
  end else
    Result := FParent.GetObjSource(Self);
end;

procedure TPDFIndObj.Decrypt;
var
  Key: AnsiString;
begin
  if (Assigned(FObj) and (not Decrypted) and FParent.CanDecrypt) then
  begin
    FDecrypted := True;
    Key := FParent.MakeKey(FObjNum, FGenNum);
    if (Key <> '') then
    begin
      FParent.DecryptObject(Key, FObj);
    end;
  end;
end;

{ TPDFDocument }

procedure TPDFDocument.BuildObjPos;
var
  X: Integer;
  IndObj: TPDFIndObj;
  SourceLen: Integer;
  SL: TQuickPDFStringList;
  Entry: TPDFXRefEntry;
  NextPos: Integer;
  DupEntry: TPDFXRefEntry;
begin
  // Sort the list by object position
  SL := TQuickPDFStringList.Create;
  try
    // Add the position of all the cross reference tables / object streams
    for X := 0 to Length(XRefPosList) - 1 do
    begin
      SL.AddObject(QPLPaddedInt(XRefPosList[X], 10), TObject(-1));
    end;

    // Add the position of each object
    for X := 0 to Length(XRefTable) - 1 do
    begin
      if XRefTable[X].InUse then
      begin
        SL.AddObject(QPLPaddedInt(XRefTable[X].ObjPos, 10), TObject(X));
      end;
    end;
    SL.Sort;

    // Look for duplicates
    for X := 0 to SL.Count - 2 do
    begin
      if (SL[X] = SL[X + 1]) then
      begin
        if Integer(SL.Objects[X]) >= 0 then
        begin
          Entry := XRefTable[Integer(SL.Objects[X])];
          if Integer(SL.Objects[X + 1]) >= 0 then
          begin
            DupEntry := XRefTable[Integer(SL.Objects[X + 1])];
            if (DupEntry.ObjNum < Entry.ObjNum) then
            begin
              XRefTable[Integer(SL.Objects[X])] := DupEntry;
              XRefTable[Integer(SL.Objects[X + 1])] := Entry;
            end;
          end;
        end;
      end;
    end;

    SourceLen := Length(FSource);
    FIndObjList.Clear;
    for X := 0 to SL.Count - 1 do
    begin
      if Integer(SL.Objects[X]) >= 0 then
      begin
        Entry := XRefTable[Integer(SL.Objects[X])];
        if X < (SL.Count - 1) then
        begin
          NextPos := QPLStrToIntDef(SL[X + 1], SourceLen);
          if (NextPos = Entry.ObjPos) then
          begin
            if X < (SL.Count - 2) then
            begin
              NextPos := QPLStrToIntDef(SL[X + 2], SourceLen);
            end;
          end;
        end else
          NextPos := SourceLen;
        if Entry.InUse and (Entry.GenNum >= 0) then
        begin
          IndObj := TPDFIndObj.Create(Self);
          IndObj.DecodeMode := FDecodeMode;
          IndObj.FPosition := Entry.ObjPos;
          IndObj.FLength := NextPos - Entry.ObjPos;
          IndObj.FObjNum := Entry.ObjNum;
          IndObj.FGenNum := Entry.GenNum;
          IndObj.FCompact := Entry.Compact;
          IndObj.FObjStrNum := Entry.ObjStrNum;
          IndObj.FObjStrIndex := Entry.ObjStrIndex;
          FIndObjList.Add(IndObj);
        end;
      end;
    end;
    BuildIndObjIndex;

  finally
    SL.Free;
  end;
end;

constructor TPDFDocument.Create;
begin
  Init;
  Clear;
  BreakString := #13#10;
  SourceFileName := '';
  SourceFileSize := 0;
  FLastImageFontList := TObjectList.Create(False);
  FDecodeMode := 2;

  // The Document object will free all the fonts
  FIncludedFonts := TObjectList.Create(False);

  TextExtractOptions.WordGap := 0.7;
  TextExtractOptions.IgnoreFont := False;
  TextExtractOptions.IgnoreColor := False;
  TextExtractOptions.IgnoreBlocks := False;
  TextExtractOptions.SortBlocks := False;
  TextExtractOptions.SplitOnDoubleSpace := False;
  TextExtractOptions.TrimCharsOutsideArea := False;
  TextExtractOptions.SpecialMatch := False;
  TextExtractOptions.IgnoreDescenders := False;
  TextExtractOptions.IgnoreOverlaps := False;
  TextExtractOptions.IgnoreDuplicates := False;
  TextExtractOptions.IgnoreRotated := False;
  TextExtractOptions.TrimWhitespace := False;
  TextExtractOptions.OutputNonAscii := False;
  TextExtractOptions.HasArea := False;
  TextExtractOptions.OutputCMYK := False;
  TextExtractOptions.HorzScaleFactor := 5;
  TextExtractOptions.VertScaleFactor := 8;
end;

destructor TPDFDocument.Destroy;
var
  X: Integer;
begin
  for X := 0 to Length(FShaders) - 1 do
    FShaders[X].Free;
  SetLength(FShaders, 0);

  for X := 0 to Length(FTilingPatterns) - 1 do
  begin
    FTilingPatterns[X].Free;
  end;
  SetLength(FTilingPatterns, 0);

  for X := 0 to Length(FTables) - 1 do
    FTables[X].Free;
  SetLength(FTables, 0);

  for X := 0 to Length(FObjectStreams) - 1 do
    FObjectStreams[X].Free;
  SetLength(FObjectStreams, 0);

  FStructure.Free;
  FIndObjList.Free;
  FImages.Free;
  FImageLists.Free;
  FTextLists.Free;
  FFonts.Free;
  CapturedPages.Free;
  XRefObjLoaded.Free;
  if Assigned(FPageTree) then FPageTree.Free;
  if Assigned(FAcroForm) then FAcroForm.Free;
  if Assigned(XMP) then XMP.Free;

  if (FTempFileName <> '') and QPLFileExists(FTempFileName) then
  try
    QPLDeleteFile(FTempFileName);
  except
  end;


  FLastImageFontList.Free;
  FIncludedFonts.Free;

  inherited Destroy;
end;

function TPDFDocument.GetObjCount: Integer;
begin
  Result := FIndObjList.Count;
end;

function TPDFDocument.GetObjSource(IndObj: TPDFIndObj): AnsiString;
var
  ObjStm: TPDFStream;
  Obj: TPDFObject;
  ObjStmIndObj: TPDFIndObj;
  First: Integer;
  N: Integer;
  TempArray: TPDFArray;
  S: AnsiString;
  ObjPos: Integer;
  NextPos: Integer;
begin
  Result := '';
  if IndObj.FCompact then
  begin
    Result := QPLIntToStr(IndObj.ObjNum) + ' ' + QPLIntToStr(IndObj.GenNum) +
      ' obj'#13'null'#13'endobj';
    ObjStmIndObj := FindObj(IndObj.FObjStrNum, 0);
    if Assigned(ObjStmIndObj) then
    begin
      if ObjStmIndObj.Obj is TPDFStream then
      begin
        ObjStm := TPDFStream(ObjStmIndObj.Obj);
        if ObjStm.Dictionary.DictType = 'ObjStm' then
        begin
          if (ObjStm.LinkedObject is TPDFObjectStream) then
          begin
            S := TPDFObjectStream(ObjStm.LinkedObject).DecodedStream;
            TempArray := TPDFObjectStream(ObjStm.LinkedObject).IndexArray;
            First := TPDFObjectStream(ObjStm.LinkedObject).First;
            N := TPDFObjectStream(ObjStm.LinkedObject).N;
          end else
          begin
            if (GetEncrypted = peEncrypted) then
            begin
              ObjStmIndObj.Decrypt;
            end;
            Obj := ObjStm.Dictionary.FindValueByKeyName('First');
            if Obj is TPDFNumeric then
              First := TPDFNumeric(Obj).AsInteger
            else
              First := 0;
            Obj := ObjStm.Dictionary.FindValueByKeyName('N');
            if Obj is TPDFNumeric then
              N := TPDFNumeric(Obj).AsInteger
            else
              N := 0;
            S := ObjStm.GetDecodedStream;
            Obj := FStructure.Decode('[ ' + QPLCopy(S, 1, First) + ' ]');
            if (Obj is TPDFArray) then
            begin
              TempArray := TPDFArray(Obj);
            end else
            begin
              TempArray := nil;
            end;
            ObjStm.LinkedObject := TPDFObjectStream.Create;
            TPDFObjectStream(ObjStm.LinkedObject).DecodedStream := S;
            TPDFObjectStream(ObjStm.LinkedObject).IndexArray := TempArray;
            TPDFObjectStream(ObjStm.LinkedObject).First := First;
            TPDFObjectStream(ObjStm.LinkedObject).N := N;
            SetLength(FObjectStreams, Length(FObjectStreams) + 1);
            FObjectStreams[Length(FObjectStreams) - 1] := TPDFObjectStream(ObjStm.LinkedObject);
          end;

          Obj := nil;
          if (First > 0) and (N > 0) and (IndObj.FObjStrIndex < N) then
          begin
            if TempArray.Count >= (N * 2) then
            begin
              Obj := TempArray.Item[IndObj.FObjStrIndex * 2];
            end;
          end;
          
          if (Obj is TPDFNumeric) and (TPDFNumeric(Obj).AsInteger = IndObj.ObjNum) then
          begin
            Obj := TempArray.Item[IndObj.FObjStrIndex * 2 + 1];
            if Obj is TPDFNumeric then
            begin
              ObjPos := TPDFNumeric(Obj).AsInteger;
              if IndObj.FObjStrIndex < (N - 1) then
              begin
                Obj := TempArray.Item[IndObj.FObjStrIndex * 2 + 3];
                if Obj is TPDFNumeric then
                  NextPos := TPDFNumeric(Obj).AsInteger
                else
                  NextPos := Length(S);
              end else
                NextPos := Length(S);
              Result := QPLIntToStr(IndObj.ObjNum) + ' ' +
                QPLIntToStr(IndObj.GenNum) + ' obj'#13 +
                QPLCopy(S, First + ObjPos + 1, NextPos - ObjPos);
            end;
          end;
        end;
      end;
    end;
  end else
  begin
    if IndObj.FPosition > 0 then
      Result := QPLCopy(FSource, IndObj.FPosition + 1, IndObj.FLength);
  end;
end;

function TPDFDocument.ObjSourcePosition(IndObj: TPDFIndObj): Int64;
begin
  Result := 0;
  if (not IndObj.FCompact) then
  begin
    if (IndObj.FPosition > 0) then
    begin
      Result := IndObj.FPosition;
    end;
  end;
end;

function TPDFDocument.GetOCGPrintable(OCGRef: TPDFIndRef): Boolean;
begin
  Result := GetOCGState(OCGRef, 'Print');
end;

function TPDFDocument.GetOCGVisible(OCGRef: TPDFIndRef): Boolean;
begin
  Result := GetOCGState(OCGRef, 'View');
end;

function TPDFDocument.GetOCGState(OCGRef: TPDFIndRef; const Key: AnsiString): Boolean;
var
  Root: TPDFDictionary;
  Obj: TPDFObject;
  OCPropertiesDict: TPDFDictionary;
  DDict, ADict: TPDFDictionary;
  BaseState: Boolean;
  InOff: Boolean;
  InOn: Boolean;
  ASArray, OCGArray: TPDFArray;
  I, X: Integer;
  OCGName: AnsiString;
  //Found: Boolean;
begin
  Result := True;

  if Key = 'Print' then
  begin
    if (OCGRef is TPDFIndRef) then
    begin
      Obj := TPDFIndRef(OCGRef).Obj;
      if (Obj is TPDFDictionary) then
      begin
        OCGName := TPDFDictionary(Obj).StringValue('Name');
        Obj := TPDFDictionary(Obj).FindValueByKeyName('Usage', True);
        if (Obj is TPDFDictionary) then
        begin
          Obj := TPDFDictionary(Obj).FindValueByKeyName('Print', True);
          if (Obj is TPDFDictionary) then
          begin
            Obj := TPDFDictionary(Obj).FindValueByKeyName('PrintState', True);
            if TPDFName(Obj).Name = 'OFF' then
              Result := false
            else
              Result := True;
          end;
        end;
      end;
    end;
  end
  else
  begin
    Root := GetRootDict;
    if Assigned(Root) then
    begin
      Obj := Root.FindValueByKeyName('OCProperties', True);
      if (Obj is TPDFDictionary) then
      begin
        OCPropertiesDict := TPDFDictionary(Obj);
        Obj := OCPropertiesDict.FindValueByKeyName('D', True);
        if (Obj is TPDFDictionary) then
        begin
          DDict := TPDFDictionary(Obj);
          Obj := DDict.FindValueByKeyName('BaseState', True);
          BaseState := True;
          if Obj is TPDFName then
          begin
            if TPDFName(Obj).Name = 'OFF' then
            begin
              BaseState := False;
            end;
          end;

          InOff := False;
          Obj := DDict.FindValueByKeyName('OFF', True);
          if (Obj is TPDFArray) then
          begin
            if (TPDFArray(Obj).HasMatchingChild(OCGRef.Output)) then
            begin
              InOff := True;
            end;
          end;

          InOn := False;
          Obj := DDict.FindValueByKeyName('ON', True);
          if (Obj is TPDFArray) then
          begin
            if (TPDFArray(Obj).HasMatchingChild(OCGRef.Output))  then
            begin
              InOn := True;
            end;
          end;

          if (BaseState) then
          begin
            // BaseState is ON, return False if the OCG is in the /OFF array
            Result := not InOff;
          end else
          begin
            // BaseState is OFF, return True if the OCG is in the /ON array
            Result := InOn;
          end;
        end;

        // Check the 'Event' 'View' which overrides the above code.
        if  (OCGRef is TPDFIndRef) then
          Obj := TPDFIndRef(OCGRef).Obj;

        if (Obj is TPDFDictionary) then
          OCGName := TPDFDictionary(Obj).StringValue('Name');

        Obj := OCPropertiesDict.FindValueByKeyName('D', True);
        if (Obj is TPDFDictionary) then
        begin
          DDict := TPDFDictionary(Obj);
          Obj := DDict.FindValueByKeyName('AS');
          if not Assigned(Obj) then
          begin
            Obj := FStructure.NewArray;
            DDict.Add('AS', Obj);
          end;
          if Obj is TPDFArray then
          begin
            ASArray := TPDFArray(Obj);
            for X := 0 to ASArray.Count - 1 do
            begin
              Obj := ASArray.Item[X];
              if Obj is TPDFDictionary then
              begin
                ADict := TPDFDictionary(Obj);
                if ADict.StringValue('Event') = Key then
                begin
                  obj := ADict.FindValueByKeyName('OCGs');
                  if (obj is TPDFArray) then
                  begin
                    OCGArray := TPDFArray(obj);
                    //Found := False;
                    for I := 0 to OCGArray.Count - 1 do
                    begin
                      Obj := OCGArray.Item[I];
                      if (Obj is TPDFIndRef) then
                        Obj := TPDFIndRef(Obj).Obj;
                      if (Obj is TPDFDictionary) then
                      begin
                        if TPDFDictionary(Obj).StringValue('Name') = OCGName then
                          Result := True;
                          //Found := True;
                      end;
                    end;

                    //if (not Found) and (OCGArray.Count >= 1) then
                    //  Result := False
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.FindObj(ObjNum, GenNum: Integer): TPDFIndObj;
var
  Min, Max: Integer;
  Mid: Integer;
begin
  Min := 0;
  Max := Length(FIndObjIndex);
  while (Min < Max) do
  begin
    Mid := Min + ((Max - Min) div 2);
    if (FIndObjIndex[Mid] < ObjNum) then
    begin
      Min := Mid + 1;
    end else
    begin
      Max := Mid;
    end;
  end;
  if ((Min < Length(FIndObjIndex)) and (FIndObjIndex[Min] = ObjNum)) then
  begin
    Result := TPDFIndObj(FIndObjList[FIndObjKey[Min]]);
  end else
  begin
    Result := nil;
  end;
end;

function TPDFDocument.ReadHeader: Boolean;
var
  S: AnsiString;
  X: Integer;
  PPDF: Integer;
  PPS: Integer;
  Ver: AnsiString;
const
  Valid: AnsiString = '0123456789.';
begin
  Result := False;
  S := QPLCopy(FSource, 1, 1024);
  PPDF := QPLPos('%PDF-', S);
  PPS := QPLPos('%!PS-Adobe-', S);
  if (PPDF > 0) or (PPS > 0) then
  begin
    if PPDF > 0 then
    begin
      S := QPLCopy(S, PPDF + 5, 10);
      if Length(S) > 0 then
      begin
        X := 1;
        Ver := '';
        while QPLPos(S[X], Valid) > 0 do
        begin
          Ver := Ver + S[X];
          Inc(X);
        end;
        if TazzIsFloat(Ver) then
        begin
          FVersion := Ver;
          Result := True;
        end;
      end;
    end;

    if PPS > 0 then
    begin
      S := QPLCopy(S, PPS + 11, 20);
      PPDF := QPLPos('PDF-', S);
      if PPDF > 0 then
      begin
        S := QPLCopy(S, PPDF + 4, 10);
        if Length(S) > 0 then
        begin
          X := 1;
          Ver := '';
          while QPLPos(S[X], Valid) > 0 do
          begin
            Ver := Ver + S[X];
            Inc(X);
          end;
          if TazzIsFloat(Ver) then
          begin
            FVersion := Ver;
            Result := True;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.ReadTrailer: Boolean;
var
  XR: TPDFXRefReader;
  StartXRef: Integer;
  SS: TStringStream;
  Obj: TPDFObject;
  FixX: Integer;
  FixBuffer: AnsiString;
  Raw: TQPLRawAnalyser;
  RawX: Integer;
  CheckZeroX: Integer;
  CheckZeroCount: Integer;
begin
  SS := TStringStream.Create(FSource);
  try
    XR := TPDFXRefReader.Create(SS);
    try
      XR.OnXRefItem := XRefItem;
      XR.OnXRefTrailer := XRefTrailer;
      XR.OnXRefRead := XRefRead;

      FTrailer := nil;
      FXRefPos := -1;
      SetLength(XRefTable, 1000);
      XRefTableIndex := 0;
      StartXRef := XR.FindXRefPos;
      Result := XR.ReadXRef(StartXRef);
      if (Result) then FXRefPos := StartXRef;

      SetLength(XRefTable, XRefTableIndex);

      if (XRefTableIndex > 0) then
      begin
        if ((XRefTable[0].ObjNum = 2)) then
        begin
          Obj := FTrailer.FindValueByKeyName('Size');
          if (Obj is TPDFNumeric) then
          begin
            if Length(XRefTable) = (TPDFNumeric(Obj).AsInteger - 1) then
            begin
              SS.Seek(XRefTable[0].ObjPos, soBeginning);
              SetLength(FixBuffer, 7);
              SS.Read(FixBuffer[1], 7);
              if (FixBuffer = '1 0 obj') then
              begin
                for FixX := 0 to Length(XRefTable) - 1 do
                begin
                  Dec(XRefTable[FixX].ObjNum);
                end;
              end;
            end;
          end;
        end;
      end;

      BuildObjPos;
    finally
      XR.Free;
    end;

    // Check for all objects (more than 5) having a 0000000000 position
    CheckZeroCount := 0;
    for CheckZeroX := 0 to Length(XRefTable) - 1 do
    begin
      if (XRefTable[CheckZeroX].InUse) then
      begin
        if (XRefTable[CheckZeroX].ObjPos = 0) then
        begin
          Inc(CheckZeroCount);
        end;
      end;
    end;
    if (CheckZeroCount > 5) and (CheckZeroCount = Length(XRefTable)) then
    begin
      Result := False;
    end;

    if (not Result) then
    begin
      SS.Seek(0, soFromBeginning);
      Raw := TQPLRawAnalyser.Create;
      try
        Raw.LoadFromStream(SS);
        SetLength(XRefTable, Raw.ObjectCount);
        for RawX := 0 to Raw.ObjectCount - 1 do
        begin
          XRefTable[RawX].ObjNum := Raw.GetObjNum(RawX);
          XRefTable[RawX].GenNum := Raw.GetGenNum(RawX);
          XRefTable[RawX].ObjPos := Raw.GetLocation(RawX);
          XRefTable[RawX].InUse := True;
          XRefTable[RawX].ObjStrNum := 0;
          XRefTable[RawX].ObjStrIndex := 0;
          XRefTable[RawX].Compact := False;
        end;
        Obj := FStructure.Decode(Raw.Trailer);
        if (Obj is TPDFDictionary) then
        begin
          FTrailer := TPDFDictionary(Obj);
        end;
        FRepaired := True;
      finally
        Raw.Free;
      end;

      BuildObjPos;

      if (Assigned(FTrailer)) then
        Result := True;
    end;
  finally
    SS.Free;
  end;
end;

procedure TPDFDocument.SetVersion(const NewVersion: AnsiString);
begin
  FVersion := NewVersion;
  FChanged := True;
end;

function TPDFDocument.SetXMPInformation(const Key, Value,
  Delimiter: WideString): Boolean;
begin
  Result := False;

  if (not Assigned(XMP)) then
  begin
    XMP := TDebenuPDFLibraryXMP.Create;
    XMP.LoadFromString(GetMetadata);
  end;

  if (Key = 'dc:subject') then
  begin
    XMP.DCSubject := Value;
    Result := True;
  end;
end;

function TPDFDocument.ValidPDFSource(const Password: WideString): TQPLValidSourceResult;
var
  LinData: AnsiString;
  OP: Integer;
  LinObj: AnsiString;
  LinGen: AnsiString;
  LinIO: TPDFIndObj;
  LinDict: TPDFDictionary;
  TestObj: TPDFObject;
begin
  Result := vsError;
  if ReadHeader then
  begin
    if ReadTrailer then
    begin
      TestObj := Trailer.FindValueByKeyName('Encrypt');
      if ((TestObj is TPDFDictionary) or (TestObj is TPDFIndRef)) then
      begin
        SetPassword('');
        FUserPasswordBlank := FIsUserPassword;
        SetPassword(Password);
        FOwnerPasswordBlank := FIsOwnerPassword and FIsUserPassword;
        if (not (FIsOwnerPassword or FIsUserPassword)) then
        begin
          Result := vsWrongPassword;
        end else
        begin
          if (not Assigned(FTrailer.FindValueByKeyName('ID'))) then
          begin
            Decrypt;
            GetID;
          end;
        end;
      end;
      FNoPagesDict := False;

      if ((Result <> vsWrongPassword) and (GetPagesDict <> nil)) then
      begin
        Result := vsOkay;
        if Assigned(FPageTree) then FPageTree.Free;

        FPageTree := TPDFPageTree.Create(GetPagesDict, FImages, FImageLists, FTextLists, FIncludedFonts);
        FPageTree.OnDecrypt := PageDecrypt;
        FPageTree.OnDeleteObj := DeleteObj;
        FPageTree.OnFindPage := FindPage;
        FPageTree.Page := 1;

        LinData := QPLCopy(FSource, 1, 1024);
        if QPLPos('/Linearized', LinData) > 0 then
        begin
          OP := QPLPos(' obj', LinData);
          repeat
            Dec(OP);
          until (LinData[OP] >= '0') and (LinData[OP] <= '9');
          repeat
            Dec(OP);
          until (LinData[OP] < '0') or (LinData[OP] > '9');
          repeat
            Dec(OP);
          until (LinData[OP] >= '0') or (LinData[OP] <= '9');
          repeat
            Dec(OP);
          until (LinData[OP] < '0') or (LinData[OP] > '9');
          LinObj := '';
          LinGen := '';
          Inc(OP);
          repeat
            LinObj := LinObj + LinData[OP];
            Inc(OP);
          until (LinData[OP] < '0') or (LinData[OP] > '9');
          repeat
            Inc(OP);
          until (LinData[OP] >= '0') or (LinData[OP] <= '9');
          repeat
            LinGen := LinGen + LinData[OP];
            Inc(OP);
          until (LinData[OP] < '0') or (LinData[OP] > '9');
          LinIO := FindObj(QPLStrToIntDef(LinObj, 0), QPLStrToIntDef(LinGen, 0));
          if LinIO.Obj is TPDFDictionary then
          begin
            LinDict := TPDFDictionary(LinIO.Obj);
            TestObj := LinDict.FindValueByKeyName('Linearized');
            if Assigned(TestObj) then
            begin
              FLinearized := True;
              LinDict.Clear;
            end;
          end;
        end else
          FLinearized := False;
      end else
        FNoPagesDict := True;
    end;
  end;
end;

function TPDFDocument.GetInfoDict: TPDFDictionary;
var
  Obj: TPDFObject;
  IndObj: TPDFIndObj;
begin
  Obj := FTrailer.FindValueByKeyName('Info', True);
  if not (Obj is TPDFDictionary) then
  begin
    Result := FStructure.NewDictionary;
    IndObj := NewObj(Result);
    FTrailer.Add('Info', FStructure.NewIndirectRef(IndObj.ObjNum, IndObj.GenNum));
  end else
    Result := TPDFDictionary(Obj);
end;

function TPDFDocument.NewObj(AObj: TPDFObject; BuildIndex: Boolean): TPDFIndObj;
var
  Size: TPDFObject;
  NewObjNum: Integer;
  X: Integer;
begin
  Size := FTrailer.FindValueByKeyName('Size');
  if not (Size is TPDFNumeric) then
  begin
    Size := FStructure.NewNumeric(1);
    FTrailer.Add('Size', Size);
  end;

  NewObjNum := 0;
  for X := 0 to FIndObjList.Count - 1 do
  begin
    if TPDFIndObj(FIndObjList[X]).FObjNum > NewObjNum then
      NewObjNum := TPDFIndObj(FIndObjList[X]).FObjNum;
  end;
  Inc(NewObjNum);

  Result := TPDFIndObj.Create(Self);
  Result.DecodeMode := FDecodeMode;
  FIndObjList.Add(Result);

  Result.FObjNum := NewObjNum;
  Result.FGenNum := 0;
  Result.FObj := AObj;
  AObj.Own(Result.FObjNum, Result.FGenNum);
  Result.FDecoded := True;
  Result.FDecrypted := True;
  Result.FPosition := 0;
  Result.FLength := 0;

  if (BuildIndex) then
  begin
    BuildIndObjIndex;
  end;

  FMaxObjNum := NewObjNum + 1;
  TPDFNumeric(Size).SetTo(FMaxObjNum);
end;

function TPDFDocument.LoadFromFile(const FileName, Password: WideString): TQPLLoadResult;
var
  FS: TQuickPDFWideFileStream;
begin
  FPDFAModePossible := False;
  FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := LoadFromStream(FS, Password);
  finally
    FS.Free;
  end;
end;

function TPDFDocument.LoadFromStream(InStream: TStream; const Password: WideString): TQPLLoadResult;
var
  CheckShift: Integer;
  Valid: TQPLValidSourceResult;
begin
  FPDFAModePossible := False;
  Result := lrOkay;
  try
    SourceFileSize := InStream.Size;
    SetLength(FSource, InStream.Size);
    if (InStream.Size > 0) then
    begin
      InStream.Seek(0, soFromBeginning);
      InStream.Read(FSource[1], Length(FSource));
    end;
    Valid := ValidPDFSource(Password);
    if (Valid = vsError) then
    begin
      CheckShift := QPLPos('%PDF-', FSource);
      if CheckShift > 1 then
      begin
        XRefObjLoaded.Clear;
        Delete(FSource, 1, CheckShift - 1);
        Valid := ValidPDFSource(Password);
      end;
    end;
    if (Valid = vsWrongPassword) then
    begin
      Result := lrWrongPassword;
      Clear;
    end else
    if (Valid = vsError) then
    begin
       Result := lrError;
       Clear;
    end;
  except
    Clear;
    Result := lrError;
  end;
//  Password := '';
end;

procedure TPDFDocument.Clear;
var
  X: Integer;
begin
  for X := 0 to Length(FShaders) - 1 do
  begin
    FShaders[X].Free;
  end;
  SetLength(FShaders, 0);

  for X := 0 to Length(FTilingPatterns) - 1 do
  begin
    FTilingPatterns[X].Free;
  end;
  SetLength(FTilingPatterns, 0);

  FStructure.Clear;
  FTrailer := FStructure.NewDictionary;
  FIndObjList.Clear;
  FSource := '';
  if Assigned(FPageTree) then FPageTree.Free;
  FPageTree := TPDFPageTree.Create(nil, FImages, FImageLists, FTextLists, FIncludedFonts);
  FPageTree.OnFindPage := FindPage;

  FImages.Clear;
  FImageLists.Clear;
  FTextLists.Clear;
  FFonts.Clear;
  FPassword := '';
  FIsUserPassword := False;
  FIsOwnerPassword := False;
  FPDFAModePossible := True;
  FHeaderComments := '';

  with FEncryption do
  begin
    Length := 0;
    R := 0;
    V := 0;
    O := '';
    U := '';
    P := 0;
    Extracted := False;
    DictionaryPresent := False;
    DictionaryObjNum := 0;
  end;
end;

function TPDFDocument.SaveToFile(const FileName: WideString): Boolean;
var
  FS: TQuickPDFWideFileStream;
begin
  try
    FS := QPLCreateFileStream(FileName, fmCreate or fmShareDenyWrite);
    try
      Result := SaveToStream(FS, False);
    finally
      FS.Free;
    end;
  except
    Result := False;
  end;
end;

function TPDFDocument.GetRootDict: TPDFDictionary;
var
  Obj: TPDFObject;
  IndObj: TPDFIndObj;
begin
  Obj := FTrailer.FindValueByKeyName('Root');
  if Obj is TPDFIndRef then
    Obj := TPDFIndRef(Obj).Obj;
  if not (Obj is TPDFDictionary) then
  begin
    Result := FStructure.NewDictionary;
    IndObj := NewObj(Result);
    FTrailer.Add('Root', FStructure.NewIndirectRef(IndObj.ObjNum, IndObj.GenNum));
  end else
    Result := TPDFDictionary(Obj);
end;

function TPDFDocument.GetPageCount: Integer;
begin
  Result := FPageTree.PageCount;
end;

function TPDFDocument.GetPagesDict: TPDFDictionary;
var
  Obj: TPDFObject;
  IndObj: TPDFIndObj;
  S: AnsiString;
  I: Integer;
begin
  Result := nil;
  Obj := RootDict.FindValueByKeyName('Pages');
  if Obj is TPDFIndRef then
    Obj := TPDFIndRef(Obj).Obj;
  if Obj is TPDFDictionary then
    Result := TPDFDictionary(Obj);

  if (Assigned(Result)) then
  begin
    Obj := Result.FindValueByKeyName('Type');
    if (Obj is TPDFName) then
    begin
      if (TPDFName(Obj).Output <> '/Pages') then
      begin

        for I := 0 to FIndObjList.Count - 1 do
        begin
          IndObj := TPDFIndObj(FIndObjList[I]);

          if Assigned(IndObj) then
          begin
            Obj := IndObj.GetObj;

            if Obj is TPDFDictionary then
            begin
              Obj := TPDFDictionary(Obj).FindValueByKeyName('Type');
              if (Obj is TPDFName) then
              begin
                S := TPDFName(Obj).Output;
                if (TPDFName(Obj).Output = '/Pages') then
                  Result := TPDFDictionary(IndObj.GetObj);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TPDFDocument.GetIndObj(Sender: TObject; ObjNum,
  GenNum: Integer; var Obj: TPDFObject);
var
  IndObj: TPDFIndObj;
begin
  IndObj := FindObj(ObjNum, GenNum);
  if IndObj <> nil then
    Obj := IndObj.Obj
  else
    Obj := nil;
end;

procedure TPDFDocument.NewIndObj(Sender: TObject; var ObjNum,
  GenNum: Integer; Obj: TPDFObject);
var
  IndObj: TPDFIndObj;
begin
  IndObj := NewObj(Obj);
  ObjNum := IndObj.ObjNum;
  GenNum := IndObj.GenNum;
end;

function TPDFDocument.GetInfo(const Key: AnsiString): WideString;
begin
  Result := QPLDecodeTextString(GetRawInfo(Key));
end;

function TPDFDocument.GetRawInfo(const Key: AnsiString): AnsiString;
var
  ID: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := '';

  ID := InfoDict;
  if Assigned(ID) then
  begin
    Obj := ID.FindValueByKeyName(Key, True);
    if Obj is TPDFString then
      Result := TPDFString(Obj).AsString;
    if Obj is TPDFStream then
      Result := TPDFStream(Obj).GetDecodedStream;
  end;
end;

function TPDFDocument.GetEncrypted: TPDFEncrypted;
begin
  with FEncryption do
  begin
    if not Extracted then ExtractEncryption;
    if DictionaryPresent then
    begin
      if V <> 0 then
        Result := peEncrypted
      else
        Result := peUnknownEncryption;
    end else
      Result := peDecrypted;
  end;
end;

procedure TPDFDocument.SetInfo(const Key: AnsiString; const Value: WideString; Mode: TPDFStorageMode);
begin
  if (not Assigned(XMP)) then
  begin
    XMP := TDebenuPDFLibraryXMP.Create;
    XMP.LoadFromString(GetMetadata);
  end;

  if (Key <> 'dc:subject') then
  begin
    SetRawInfo(Key, QPLEncodeTextString(Value), Mode);
  end;

{$IFNDEF QPL_NOVCL}
  if (Key = 'Title') then
  begin
    XMP.Title := Value;
  end else
  if (Key = 'Author') then
  begin
    XMP.Author := Value;
  end else
  if (Key = 'Subject') then
  begin
    XMP.Subject := Value;
  end else
  if (Key = 'Keywords') then
  begin
    XMP.Keywords := Value;
  end else
  if (Key = 'Creator') then
  begin
    XMP.Creator := Value;
  end else
  if (Key = 'Producer') then
  begin
    XMP.Producer := Value;
  end else
  if (Key = 'CreationDate') then
  begin
    XMP.CreationDate := Value;
  end else
  if (Key = 'ModDate') then
  begin
    XMP.ModDate := Value;
  end else
  if (Key = 'dc:subject') then
  begin
    XMP.DCSubject := Value;
  end;
{$ENDIF}
end;

procedure TPDFDocument.SetRawInfo(const Key, Value: AnsiString; Mode: TPDFStorageMode);
var
  ID: TPDFDictionary;
  Obj: TPDFObject;
begin
  ID := InfoDict;
  Obj := ID.FindValueByKeyName(Key, True);
  if Obj is TPDFStream then
  begin
    TPDFStream(Obj).SetTo('', False);
    ID.Add(Key, FStructure.NewString(Value))
  end else
  if Obj is TPDFString then
  begin
    TPDFString(Obj).SetTo(Value);
  end else
    ID.Add(Key, FStructure.NewString(Value));
end;

function TPDFDocument.CreateBlank: Boolean;
var
  Info: TPDFDictionary;
  Root: TPDFDictionary;
  Page: TPDFDictionary;
  Pages: TPDFDictionary;
  Resources: TPDFDictionary;
  PagesRef: TPDFIndRef;
  ID: TPDFArray;
  IDS: TPDFString;
begin
  Result := True;
  Clear;
  FVersion := '1.4';

  Info := FStructure.NewDictionary;
  Root := FStructure.NewDictionary;
  Pages := FStructure.NewDictionary;
  Page := FStructure.NewDictionary;
  Resources := FStructure.NewDictionary;
  PagesRef := NewObjRef(Pages);
  Page.Add('Type', FStructure.NewCommonName('Page'));
  Page.Add('Parent', PagesRef);
  Page.Add('MediaBox', FStructure.NewIntArray([0, 0, 612, 792]));
  Page.Add('CropBox', FStructure.NewIntArray([0, 0, 612, 792]));
  Page.Add('Resources', Resources);
  Resources.Add('ProcSet', FStructure.NewArray(
    [FStructure.NewName('PDF'),
     FStructure.NewName('Text'),
     FStructure.NewName('ImageB'),
     FStructure.NewName('ImageC'),
     FStructure.NewName('ImageI')]));
  Pages.Add('Type', FStructure.NewCommonName('Pages'));
  Pages.Add('Count', FStructure.NewNumeric(1));
  Pages.Add('Kids', FStructure.NewArray([NewObjRef(Page)]));
  Root.Add('Type', FStructure.NewCommonName('Catalog'));
  Root.Add('Pages', PagesRef);
  IDS := FStructure.NewString(MD5DigestToString(MD5String(
    QPLFloatToStr(Now))), smHex);
  ID := FStructure.NewArray([IDS, IDS]);

  FTrailer.Add('Root', NewObjRef(Root));
  FTrailer.Add('Info', NewObjRef(Info));
  FTrailer.Add('ID', ID);

  if Assigned(FPageTree) then FPageTree.Free;
  FPageTree := TPDFPageTree.Create(GetPagesDict, FImages, FImageLists, FTextLists, FIncludedFonts);
  FPageTree.OnDecrypt := PageDecrypt;
  FPageTree.OnFindPage := FindPage;
  FPageTree.Page := 1;

  FPDFAMode := 0;
end;

function TPDFDocument.NewObjRef(AObj: TPDFObject): TPDFIndRef;
var
  IndObj: TPDFIndObj;
begin
  IndObj := NewObj(AObj);
  Result := FStructure.NewIndirectRef(IndObj.ObjNum, IndObj.GenNum);
end;

function TPDFDocument.EncryptionStrength: Integer;
begin
  if not FEncryption.Extracted then ExtractEncryption;
  Result := FEncryption.Length;
end;

procedure TPDFDocument.ExtractEncryption;
var
  Obj: TPDFObject;
  ED: TPDFDictionary;
  Filter: AnsiString;
  V: Integer;
  R: Integer;
  O: AnsiString;
  U: AnsiString;
  P: Cardinal;
  OE: AnsiString;
  UE: AnsiString;
  Perms: AnsiString;
  Length: Integer;
  StrF: AnsiString;
  StmF: AnsiString;
  CFDict: TPDFDictionary;
  StdCFDict: TPDFDictionary;
  CFM: AnsiString;
begin
  with FEncryption do
  begin
    Length := 0;
    R := 0;
    V := 0;
    O := '';
    U := '';
    P := 0;
    OE := '';
    UE := '';
    Perms := '';
    Extracted := True;
    DictionaryPresent := False;
    DictionaryObjNum := 0;
    EncryptMetadata := True;
  end;
  Obj := FTrailer.FindValueByKeyName('Encrypt');
  FEncryption.DictionaryPresent := Obj <> nil;
  if Obj <> nil then
  begin
    if Obj is TPDFIndRef then
    begin
      FEncryption.DictionaryObjNum := TPDFIndRef(Obj).ObjNum;
      Obj := TPDFIndRef(Obj).Obj;
    end;
    if Obj is TPDFDictionary then
    begin
      ED := TPDFDictionary(Obj);
      Obj := ED.FindValueByKeyName('Filter');
      if Obj is TPDFName then Filter := TPDFName(Obj).Name else Filter := '';
      Obj := ED.FindValueByKeyName('V');
      if Obj is TPDFNumeric then V := TPDFNumeric(Obj).AsInteger else V := 0;
      Obj := ED.FindValueByKeyName('R');
      if Obj is TPDFNumeric then R := TPDFNumeric(Obj).AsInteger else R := 0;
      Obj := ED.FindValueByKeyName('Length');
      if Obj is TPDFNumeric then Length := TPDFNumeric(Obj).AsInteger else Length := 40;
      Obj := ED.FindValueByKeyName('O');
      if Obj is TPDFString then O := TPDFString(Obj).AsString else O := '';
      Obj := ED.FindValueByKeyName('U');
      if Obj is TPDFString then U := TPDFString(Obj).AsString else U := '';
      Obj := ED.FindValueByKeyName('P');

      if (Obj is TPDFNumeric) then
      begin
        if (TPDFNumeric(Obj).AsDouble < 0) then
        begin
          P := Cardinal(TPDFNumeric(Obj).AsInteger);
        end else
        begin
          P := Round(TPDFNumeric(Obj).AsDouble);
        end;
      end else
      begin
        P := 0;
      end;

      Obj := ED.FindValueByKeyName('OE');
      if Obj is TPDFString then OE := TPDFString(Obj).AsString else OE := '';
      Obj := ED.FindValueByKeyName('UE');
      if Obj is TPDFString then UE := TPDFString(Obj).AsString else UE := '';
      Obj := ED.FindValueByKeyName('Perms');
      if Obj is TPDFString then Perms := TPDFString(Obj).AsString else Perms := '';

      if Filter = 'Standard' then
      begin
        if ((V = 1) or (V = 2)) and ((R = 2) or (R = 3)) then
        begin
          FEncryption.R := R;
          FEncryption.V := V;
          FEncryption.O := O;
          FEncryption.U := U;
          FEncryption.P := P;
          FEncryption.Length := 40;
          if ((V > 1) or ((V = 1) and (R = 3))) then
          begin
            FEncryption.Length := Length;
          end;
        end;
        if (V = 4) and (R = 4) then
        begin
          Obj := ED.FindValueByKeyName('EncryptMetadata');
          if (Obj is TPDFBoolean) then
          begin
            FEncryption.EncryptMetadata := TPDFBoolean(Obj).AsBoolean;
          end;

          Obj := ED.FindValueByKeyName('StrF');
          if Obj is TPDFName then
            StrF := TPDFName(Obj).Name
          else
            StrF := '';
          Obj := ED.FindValueByKeyName('StmF');
          if Obj is TPDFName then
            StmF := TPDFName(Obj).Name
          else
            StmF := '';
          Obj := ED.FindValueByKeyName('CF');
          if (StrF = 'StdCF') and (StmF = 'StdCF') and (Obj is TPDFDictionary) then
          begin
            CFDict := TPDFDictionary(Obj);
            Obj := CFDict.FindValueByKeyName('StdCF');
            if Obj is TPDFDictionary then
            begin
              StdCFDict := TPDFDictionary(Obj);
              Obj := StdCFDict.FindValueByKeyName('CFM');
              if Obj is TPDFName then
                CFM := TPDFName(Obj).Name
              else
                CFM := '';
              if CFM = 'AESV2' then
              begin
                FEncryption.R := R;
                FEncryption.V := V;
                FEncryption.O := O;
                FEncryption.U := U;
                FEncryption.P := P;
                Obj := StdCFDict.FindValueByKeyName('Length');
                if Obj is TPDFNumeric then
                  FEncryption.Length := TPDFNumeric(Obj).AsInteger * 8
                else
                  FEncryption.Length := 128;
                FEncryption.Algorithm := eaAES128;
                FEncryptionStrength := esAES128Bit;
              end else
              if CFM = 'V2' then
              begin
                FEncryption.R := R;
                FEncryption.V := V;
                FEncryption.O := O;
                FEncryption.U := U;
                FEncryption.P := P;
                Obj := StdCFDict.FindValueByKeyName('Length');
                if Obj is TPDFNumeric then
                  FEncryption.Length := TPDFNumeric(Obj).AsInteger * 8
                else
                  FEncryption.Length := 40;
              end;
            end;
          end;
        end;
        if ((V = 5) and ((R = 5) or (R = 6))) then
        begin
          Obj := ED.FindValueByKeyName('EncryptMetadata');
          if (Obj is TPDFBoolean) then
          begin
            FEncryption.EncryptMetadata := TPDFBoolean(Obj).AsBoolean;
          end;

          Obj := ED.FindValueByKeyName('StrF');
          if Obj is TPDFName then
            StrF := TPDFName(Obj).Name
          else
            StrF := '';
          Obj := ED.FindValueByKeyName('StmF');
          if Obj is TPDFName then
            StmF := TPDFName(Obj).Name
          else
            StmF := '';
          Obj := ED.FindValueByKeyName('CF');
          if (StrF = 'StdCF') and (StmF = 'StdCF') and (Obj is TPDFDictionary) then
          begin
            CFDict := TPDFDictionary(Obj);
            Obj := CFDict.FindValueByKeyName('StdCF');
            if Obj is TPDFDictionary then
            begin
              StdCFDict := TPDFDictionary(Obj);
              Obj := StdCFDict.FindValueByKeyName('CFM');
              if Obj is TPDFName then
                CFM := TPDFName(Obj).Name
              else
                CFM := '';
              if CFM = 'AESV3' then
              begin
                FEncryption.R := R;
                FEncryption.V := V;
                FEncryption.O := O;
                FEncryption.U := U;
                FEncryption.P := P;
                FEncryption.OE := OE;
                FEncryption.UE := UE;
                FEncryption.Perms := Perms;
                Obj := StdCFDict.FindValueByKeyName('Length');
                if Obj is TPDFNumeric then
                  FEncryption.Length := TPDFNumeric(Obj).AsInteger * 8
                else
                  FEncryption.Length := 128;
                FEncryption.Algorithm := eaAES256;
                if (R = 5) then
                begin
                  FEncryptionStrength := esAES256Bit;
                end else
                if (R = 6) then
                begin
                  FEncryptionStrength := esAES256BitAcroX;
                end;
              end;
            end;
          end;
        end;
      end;
      
      DecodePermKey(P);
    end;
  end;
end;

function TPDFDocument.Encrypt(const Owner, User: AnsiString;
  Strength: TPDFEncryptionStrength; Perm: TPDFPermissions;
  ExtraPerm: TPDFExtraPermissions): Boolean;
var
  ED: TPDFDictionary;
  StdCFDict: TPDFDictionary;
  CFDict: TPDFDictionary;
  IndObjIndex: Integer;
  EncRef: TPDFIndRef;
begin
  Result := True;
  FOwnerPassword := Owner;
  FUserPassword := User;
  FPermissions := Perm;
  FExtraPermissions := ExtraPerm;
  FIsOwnerPassword := True;
  FIsUserPassword := False;
  FUserPasswordBlank := User = '';
  FOwnerPasswordBlank := Owner = User;

  OwnerKey := '';
  UserKey := '';

  FEncryptionStrength := Strength;

  EncodePermKey;

  GenerateEncryptionKeys;

  IndObjEncKey := EncryptionKey;

  //EncryptContent(FTempFileName <> '');

  for IndObjIndex := 0 to FIndObjList.Count - 1 do
  begin
    TPDFIndObj(FIndObjList[IndObjIndex]).FDecrypted := True;
  end;

  FTrailer.PurgeKey('Encrypt');
  ED := FStructure.NewDictionary;
  ED.Add('Filter', FStructure.NewName('Standard'));
  if FEncryptionStrength = esAES128Bit then
  begin
    ED.Add('V', FStructure.NewNumeric(4));
    ED.Add('R', FStructure.NewNumeric(4));
    ED.Add('Length', FStructure.NewNumeric(128));
    ED.Add('StrF', FStructure.NewCommonName('StdCF'));
    ED.Add('StmF', FStructure.NewCommonName('StdCF'));
    StdCFDict := FStructure.NewDictionary;
    StdCFDict.Add('AuthEvent', FStructure.NewCommonName('DocOpen'));
    StdCFDict.Add('Length', FStructure.NewNumeric(16));
    StdCFDict.Add('CFM', FStructure.NewCommonName('AESV2'));
    CFDict := FStructure.NewDictionary;
    CFDict.Add('StdCF', StdCFDict);
    ED.Add('CF', CFDict);
  end else
  if FEncryptionStrength = esAES256Bit then
  begin
    ED.Add('V', FStructure.NewNumeric(5));
    ED.Add('R', FStructure.NewNumeric(5));
    ED.Add('Length', FStructure.NewNumeric(256));
    ED.Add('StrF', FStructure.NewCommonName('StdCF'));
    ED.Add('StmF', FStructure.NewCommonName('StdCF'));
    StdCFDict := FStructure.NewDictionary;
    StdCFDict.Add('AuthEvent', FStructure.NewCommonName('DocOpen'));
    StdCFDict.Add('Length', FStructure.NewNumeric(32));
    StdCFDict.Add('CFM', FStructure.NewCommonName('AESV3'));
    CFDict := FStructure.NewDictionary;
    CFDict.Add('StdCF', StdCFDict);
    ED.Add('CF', CFDict);
  end else
  if FEncryptionStrength = esAES256BitAcroX then
  begin
    ED.Add('V', FStructure.NewNumeric(5));
    ED.Add('R', FStructure.NewNumeric(6));
    ED.Add('Length', FStructure.NewNumeric(256));
    ED.Add('StrF', FStructure.NewCommonName('StdCF'));
    ED.Add('StmF', FStructure.NewCommonName('StdCF'));
    StdCFDict := FStructure.NewDictionary;
    StdCFDict.Add('AuthEvent', FStructure.NewCommonName('DocOpen'));
    StdCFDict.Add('Length', FStructure.NewNumeric(32));
    StdCFDict.Add('CFM', FStructure.NewCommonName('AESV3'));
    CFDict := FStructure.NewDictionary;
    CFDict.Add('StdCF', StdCFDict);
    ED.Add('CF', CFDict);
  end else
  begin
    if FEncryptionStrength = esStd then
    begin
      ED.Add('V', FStructure.NewNumeric(1));
      ED.Add('R', FStructure.NewNumeric(2));
    end else
    {if FEncryptionStrength = esVariable then
    begin
      ED.Add('V', FStructure.NewNumeric(2));
      ED.Add('R', FStructure.NewNumeric(3));
      ED.Add('Length', FStructure.NewNumeric(??));
    end else}
    begin
      ED.Add('V', FStructure.NewNumeric(2));
      ED.Add('R', FStructure.NewNumeric(3));
      ED.Add('Length', FStructure.NewNumeric(128));
    end;
  end;
  ED.Add('O', FStructure.NewString(OwnerKey, smHex));
  ED.Add('U', FStructure.NewString(UserKey, smHex));
  if ((FEncryptionStrength = esAES256Bit) or (FEncryptionStrength = esAES256BitAcroX)) then
  begin
    ED.Add('OE', FStructure.NewString(OwnerEncKey, smHex));
    ED.Add('UE', FStructure.NewString(UserEncKey, smHex));
    ED.Add('Perms', FStructure.NewString(PermsKey, smHex));
  end;
  ED.Add('P', FStructure.NewNumeric(Integer(PermKey)));
  EncRef := NewObjRef(ED);
  FTrailer.Add('Encrypt', EncRef);

  FEncryption.Extracted := False;
  FEncryption.DictionaryObjNum := EncRef.ObjNum;
end;

function TPDFDocument.MakeKey(ObjNum, GenNum: Integer): AnsiString;
var
  S: AnsiString;
  Digest: MD5Digest;
  X: Integer;
  L: Integer;
begin
  if (ObjNum = FEncryption.DictionaryObjNum) then
  begin
    Result := '';
  end else
  begin
    if (FEncryption.Algorithm = eaAES256) then
    begin
      Result := EncryptionKey;
      Exit;
    end;
    S := IndObjEncKey;
    L := Length(S);
    SetLength(S, L + 5);
    S[L + 1] := AnsiChar(ObjNum and $FF);
    S[L + 2] := AnsiChar((ObjNum and $FF00) shr 8);
    S[L + 3] := AnsiChar((ObjNum and $FF0000) shr 16);
    S[L + 4] := AnsiChar(GenNum and $FF);
    S[L + 5] := AnsiChar((GenNum and $FF00) shr 8);
    if FEncryptionStrength = esAES128Bit then
      S := S + 'sAlT';
    Digest := MD5String(S);
    SetLength(Result, L + 5);
    if Length(Result) > 16 then SetLength(Result, 16);
    for X := 0 to Length(Result) - 1 do
      Result[X + 1] := AnsiChar(Digest[X]);
  end;
end;

procedure TPDFDocument.GenerateEncryptionKeys(ForFP: Boolean);
var
  Digest: MD5Digest;
  ARC4Key: AnsiString;
  Padding: AnsiString;
  X: Integer;
  DX: Integer;
  KeyLength: Integer;
  OriginalKey: AnsiString;
  FileID: AnsiString;
const
  PadData: array[1..32] of Byte = ($28, $BF, $4E, $5E, $4E, $75, $8A, $41,
    $64, $00, $4E, $56, $FF, $FA, $01, $08, $2E, $2E, $00, $B6, $D0, $68,
    $3E, $80, $2F, $0C, $A9, $FE, $64, $53, $69, $7A);
begin
  if ((FEncryptionStrength = esAES256Bit) or (FEncryptionStrength = esAES256BitAcroX)) then
  begin
    FEncryption.Algorithm := eaAES256;
    GenerateEncryptionKeys256;
    Exit;
  end;

  EncryptionKey := '';

  case FEncryptionStrength of
    esStd: KeyLength := 5;
    es128Bit: KeyLength := 16;
    esAES128Bit: KeyLength := 16;
    esVariable: KeyLength := FEncryption.Length div 8;
  else
    KeyLength := 5;
  end;

  SetLength(Padding, 32);
  for X := 1 to 32 do
    Padding[X] := AnsiChar(PadData[X]);

  if (Assigned(FTrailer.FindValueByKeyName('ID'))) then
  begin
    FileID := TPDFString(GetID.Item[0]).AsString;
  end else
  begin
    FileID := '';
  end;

  // Algorithm 3.3
  if OwnerKey = '' then
  begin
    if FOwnerPassword = '' then OwnerKey := FUserPassword else
      OwnerKey := FOwnerPassword;

    if Length(OwnerKey) > 32 then OwnerKey := QPLCopy(OwnerKey, 1, 32);
    OwnerKey := OwnerKey + Padding;
    OwnerKey := QPLCopy(OwnerKey, 1, 32);

    Digest := MD5String(OwnerKey);

    if ((FEncryptionStrength <> esStd) or (FEncryption.R >= 3)) then
    begin
      for X := 1 to 50 do
      begin
        Digest := MD5String(MD5DigestToString(Digest));
      end;
    end;

    SetLength(ARC4Key, KeyLength);
    for X := 1 to KeyLength do
      ARC4Key[X] := AnsiChar(Digest[X - 1]);

    if UserKey = '' then
      UserKey := FUserPassword
    else
      EncryptionKey := ARC4Key;

    if Length(UserKey) > 32 then UserKey := QPLCopy(UserKey, 1, 32);
    UserKey := UserKey + Padding;
    UserKey := QPLCopy(UserKey, 1, 32);

    OwnerKey := ARC4Encrypt(ARC4Key, UserKey);

    if ((FEncryptionStrength <> esStd) or (FEncryption.R >= 3)) then
    begin
      OriginalKey := ARC4Key;
      for X := 1 to 19 do
      begin
        for DX := 1 to Length(OriginalKey) do
          ARC4Key[DX] := AnsiChar(Ord(OriginalKey[DX]) xor X);
        OwnerKey := ARC4Encrypt(ARC4Key, OwnerKey);
      end;
    end;
  end;

  if MalformedPermKey then PermKey := PermKey and $FFFF;

  UserKey := FUserPassword;
  if Length(UserKey) > 32 then UserKey := QPLCopy(UserKey, 1, 32);
  UserKey := UserKey + Padding;
  UserKey := QPLCopy(UserKey, 1, 32);
  UserKey := UserKey + OwnerKey;
  UserKey := UserKey + AnsiChar(PermKey and $FF);
  UserKey := UserKey + AnsiChar((PermKey and $FF00) shr 8);
  UserKey := UserKey + AnsiChar((PermKey and $FF0000) shr 16);
  UserKey := UserKey + AnsiChar((PermKey and $FF000000) shr 24);
  UserKey := UserKey + FileID;

  if (not FEncryption.EncryptMetadata) then
  begin
    UserKey := UserKey + #255#255#255#255;
  end;

  Digest := MD5String(UserKey);

  if ((FEncryptionStrength <> esStd) or (FEncryption.R >= 3)) then
  begin
    for X := 1 to 50 do
      Digest := MD5String(QPLCopy(MD5DigestToString(Digest), 1, KeyLength));
  end;

  SetLength(ARC4Key, KeyLength);
  for X := 1 to KeyLength do
  begin
    ARC4Key[X] := AnsiChar(Digest[X - 1]);
  end;
  if (EncryptionKey = '') then
  begin
    EncryptionKey := ARC4Key;
  end;

  if ((FEncryptionStrength <> esStd) or (FEncryption.R >= 3)) then
  begin
    Digest := MD5String(Padding + FileID);
    UserKey := ARC4Encrypt(ARC4Key, MD5DigestToString(Digest));

    OriginalKey := ARC4Key;
    for X := 1 to 19 do
    begin
      for DX := 1 to Length(OriginalKey) do
        ARC4Key[DX] := AnsiChar(Ord(OriginalKey[DX]) xor X);
      UserKey := ARC4Encrypt(ARC4Key, UserKey);
    end;

    for X := 1 to 16 do
      UserKey := UserKey + #0;
  end else
  begin
    UserKey := ARC4Encrypt(ARC4Key, Padding);
  end;
end;

procedure TPDFDocument.GenerateEncryptionKeys256;
var
  RandDWords: array[0..7] of Cardinal;
  Salt: AnsiString;
  TruncLength: Integer;
  SHA256Input: TQPLByteArray;
  SHA256Digest: TQPLSHA256Digest;
  AESKey: AnsiString;
  IV: AnsiString;
  EncPerms: AnsiString;
  PermExpand: AnsiString;
  Ver6Hash: AnsiString;
begin
  // Generate the random 256-bit key
  SetLength(EncryptionKey, 32);
  RandDWords[0] := Random($7FFFFFFF);
  RandDWords[1] := Random($7FFFFFFF);
  RandDWords[2] := Random($7FFFFFFF);
  RandDWords[3] := Random($7FFFFFFF);
  RandDWords[4] := Random($7FFFFFFF);
  RandDWords[5] := Random($7FFFFFFF);
  RandDWords[6] := Random($7FFFFFFF);
  RandDWords[7] := Random($7FFFFFFF);
  Move(RandDWords[0], EncryptionKey[1], 32);

  // Generate the random salt for the user password
  SetLength(Salt, 16);
  RandDWords[0] := Random($7FFFFFFF);
  RandDWords[1] := Random($7FFFFFFF);
  RandDWords[2] := Random($7FFFFFFF);
  RandDWords[3] := Random($7FFFFFFF);
  Move(RandDWords[0], Salt[1], 16);

  TruncLength := Length(FUserPassword);
  if (TruncLength > 127) then
  begin
    TruncLength := 127;
  end;

  // Generate the /U entry
  SetLength(SHA256Input, TruncLength + 8);
  if (Length(FUserPassword) > 0) then
  begin
    Move(FUserPassword[1], SHA256Input[0], TruncLength);
  end;
  Move(Salt[1], SHA256Input[TruncLength], 8);

  if (FEncryptionStrength = esAES256Bit) then
  begin
    SHA256Digest := SHA256ByteArray(SHA256Input);
  end else
  if (FEncryptionStrength = esAES256BitAcroX) then
  begin
    Ver6Hash := CalculateVer6Hash(SHA256Input, FUserPassword, TruncLength, '');
    if (Length(Ver6Hash) = 32) then
    begin
      Move(Ver6Hash[1], SHA256Digest[0], 32);
    end;
  end;

  SetLength(UserKey, 48);
  Move(SHA256Digest[0], UserKey[1], 32);
  Move(Salt[1], UserKey[33], 16);

  // Generate the /UE entry
  SetLength(SHA256Input, TruncLength + 8);
  if (Length(FUserPassword) > 0) then
  begin
    Move(FUserPassword[1], SHA256Input[0], TruncLength);
  end;
  Move(Salt[9], SHA256Input[TruncLength], 8);

  if (FEncryptionStrength = esAES256Bit) then
  begin
    SHA256Digest := SHA256ByteArray(SHA256Input);
  end else
  if (FEncryptionStrength = esAES256BitAcroX) then
  begin
    Ver6Hash := CalculateVer6Hash(SHA256Input, FUserPassword, TruncLength, '');
    if (Length(Ver6Hash) = 32) then
    begin
      Move(Ver6Hash[1], SHA256Digest[0], 32);
    end;
  end;

  SetLength(AESKey, 32);
  Move(SHA256Digest[0], AESKey[1], 32);

  IV := StringOfChar(AnsiChar(0), 16);
  UserEncKey := AES256EncryptString(AESKey, IV, EncryptionKey);

  // Generate the random salt for the owner password
  RandDWords[0] := Random($7FFFFFFF);
  RandDWords[1] := Random($7FFFFFFF);
  RandDWords[2] := Random($7FFFFFFF);
  RandDWords[3] := Random($7FFFFFFF);
  Move(RandDWords[0], Salt[1], 16);

  TruncLength := Length(FOwnerPassword);
  if (TruncLength > 127) then
  begin
    TruncLength := 127;
  end;

  // Generate the /O entry
  SetLength(SHA256Input, TruncLength + 8 + 48);
  FillChar(SHA256Input[0], TruncLength + 8 + 48, 0);
  if (Length(FOwnerPassword) > 0) then
  begin
    Move(FOwnerPassword[1], SHA256Input[0], TruncLength);
  end;
  Move(Salt[1], SHA256Input[TruncLength], 8);
  Move(UserKey[1], SHA256Input[TruncLength + 8], 48);

  if (FEncryptionStrength = esAES256Bit) then
  begin
    SHA256Digest := SHA256ByteArray(SHA256Input);
  end else
  if (FEncryptionStrength = esAES256BitAcroX) then
  begin
    Ver6Hash := CalculateVer6Hash(SHA256Input, FOwnerPassword, TruncLength, UserKey);
    if (Length(Ver6Hash) = 32) then
    begin
      Move(Ver6Hash[1], SHA256Digest[0], 32);
    end;
  end;

  SetLength(OwnerKey, 48);
  Move(SHA256Digest[0], OwnerKey[1], 32);
  Move(Salt[1], OwnerKey[33], 16);

  // Generate the /OE entry
  SetLength(SHA256Input, TruncLength + 8 + 48);
  FillChar(SHA256Input[0], TruncLength + 8 + 48, 0);
  if (Length(FOwnerPassword) > 0) then
  begin
    Move(FOwnerPassword[1], SHA256Input[0], TruncLength);
  end;
  Move(Salt[9], SHA256Input[TruncLength], 8);
  Move(UserKey[1], SHA256Input[TruncLength + 8], 48);

  if (FEncryptionStrength = esAES256Bit) then
  begin
    SHA256Digest := SHA256ByteArray(SHA256Input);
  end else
  if (FEncryptionStrength = esAES256BitAcroX) then
  begin
    Ver6Hash := CalculateVer6Hash(SHA256Input, FOwnerPassword, TruncLength, UserKey);
    if (Length(Ver6Hash) = 32) then
    begin
      Move(Ver6Hash[1], SHA256Digest[0], 32);
    end;
  end;

  Move(SHA256Digest[0], AESKey[1], 32);

  IV := StringOfChar(AnsiChar(0), 16);
  OwnerEncKey := AES256EncryptString(AESKey, IV, EncryptionKey);

  // Generate the /Perms entry
  SetLength(EncPerms, 16);
  Move(PermKey, EncPerms[1], 4);
  PermExpand := StringOfChar(AnsiChar(255), 4);
  Move(PermExpand[1], EncPerms[5], 4);
  EncPerms[9] := 'T';
  EncPerms[10] := 'a';
  EncPerms[11] := 'd';
  EncPerms[12] := 'b';
  EncPerms[13] := AnsiChar(Random($FF));
  EncPerms[14] := AnsiChar(Random($FF));
  EncPerms[15] := AnsiChar(Random($FF));
  EncPerms[16] := AnsiChar(Random($FF));

  IV := StringOfChar(AnsiChar(0), 16);
  PermsKey := AES256EncryptString(EncryptionKey, IV, EncPerms);
end;

function TPDFDocument.GetID: TPDFArray;
var
  Obj: TPDFObject;
  IDS: TPDFString;
begin
  Obj := FTrailer.FindValueByKeyName('ID');
  if not (Obj is TPDFArray) then
  begin
    FTrailer.PurgeKey('ID');
    IDS := FStructure.NewString(MD5DigestToString(MD5String(
      QPLFloatToStr(Now))), smHex);
    Result := FStructure.NewArray([IDS, IDS]);
    FTrailer.Add('ID', Result);
  end else
    Result := TPDFArray(Obj);
end;

procedure TPDFDocument.EncryptContent(Recode: Boolean);
var
  X: Integer;
  IndObj: TPDFIndObj;
  Key: AnsiString;
begin
  if FTempFileName <> '' then
  begin
    if QPLFileExists(FTempFileName) then
    try
      QPLDeleteFile(FTempFileName);
    except
    end;
    FMainFS := QPLCreateFileStream(FTempFileName, fmCreate or fmShareExclusive)
  end;
  try
    for X := 0 to FIndObjList.Count - 1 do
    begin
      IndObj := TPDFIndObj(FIndObjList[X]);
      Key := MakeKey(IndObj.ObjNum, IndObj.GenNum);
      try
        if not IndObj.FDecrypted then
          EncryptObject(Key, IndObj.Obj);
        if Recode then IndObj.Recode;
      except
      end;
    end;
  finally
    if Assigned(FMainFS) then FMainFS.Free;
    FMainFS := nil;
  end;
end;

function TPDFDocument.ImageCount: Integer;
begin
  Result := FImages.Count;
end;

function TPDFDocument.Image(Index: Integer): TPDFImage;
begin
  if (Index >= 0) and (Index < FImages.Count) then
    Result := TPDFImage(FImages[Index])
  else
    Result := nil;
end;

function TPDFDocument.IsImage(Image: TPDFImage): Boolean;
begin
  Result := FImages.IndexOf(Image) >= 0;
end;

function TPDFDocument.IsImageList(ImageList: TPDFImageList): Boolean;
begin
  Result := FImageLists.IndexOf(ImageList) >= 0;
end;

function TPDFDocument.NewStdFont(StdFont: TPDFStdFont): TPDFFont;
var
  Font: TPDFFont;
  FontName: AnsiString;
const
  BaseFonts: array[TPDFStdFont] of AnsiString = ('Courier', 'Courier-Bold',
    'Courier-BoldOblique', 'Courier-Oblique', 'Helvetica', 'Helvetica-Bold',
    'Helvetica-BoldOblique', 'Helvetica-Oblique', 'Times-Roman', 'Times-Bold',
    'Times-Italic', 'Times-BoldItalic', 'Symbol', 'ZapfDingbats');
begin
  Inc(IndexCount);
  FontName := 'QuickPDFF' + QPLRandomID;

  Font := TPDFFont.Create(FStructure, FontName);
  Font.NewStandardFont(BaseFonts[StdFont], Ord(StdFont) + 1);
  FFonts.Add(Font);
  Result := Font;
end;

function TPDFDocument.Compress: Boolean;
var
  X: Integer;
  PC: Integer;
begin
  PC := GetPageCount;
  for X := 1 to PC do
  begin
    CompressPage(X);
    if Assigned(FOnProgress) then
      FOnProgress(X * 100 div PC);    
  end;
  Result := True;
end;

function TPDFDocument.CheckOwnerPassword(const Password: WideString): Boolean;
var
  PE: TPDFEncrypted;
  TempKey: AnsiString;
  X, D: Integer;
  TruncLength: Integer;
  SHA256Input: TQPLByteArray;
  SHA256Digest: TQPLSHA256Digest;
  TestHash: AnsiString;
  IntermediateOwnerKey: AnsiString;
  ZeroInit: AnsiString;
  DecryptedPerms: AnsiString;
  PermTest: Cardinal;
  PasswordA: AnsiString;
begin
  PE := GetEncrypted;

  PasswordA := AnsiString(Password);
  if (FEncryption.Algorithm = eaAES256) then
  begin
    PasswordA := QPLUTF8Encode(Password);
  end else
  begin
    PasswordA := AnsiString(Password);
  end;

  if (PE = peDecrypted) then
  begin
    Result := PasswordA = '';
  end else
  begin
    if FEncryption.Length = 40 then
      FEncryptionStrength := esStd
    else
      FEncryptionStrength := es128Bit;
    if FEncryption.Algorithm = eaAES128 then
      FEncryptionStrength := esAES128Bit;

    if (FEncryption.Algorithm = eaAES256) then
    begin
      if (FEncryption.R = 6) then
      begin
        FEncryptionStrength := esAES256BitAcroX;
      end else
      begin
        FEncryptionStrength := esAES256Bit;
      end;

      TruncLength := Length(PasswordA);
      if (Length(PasswordA) > 127) then
      begin
        TruncLength := 127;
      end;

      SetLength(SHA256Input, TruncLength + 56);
      if (Length(PasswordA) > 0) then
      begin
        Move(PasswordA[1], SHA256Input[0], TruncLength);
      end;
      if (Length(FEncryption.O) >= 48) then
      begin
        Move(FEncryption.O[33], SHA256Input[TruncLength], 8);
      end;
      if (Length(FEncryption.U) >= 48) then
      begin
        Move(FEncryption.U[1], SHA256Input[TruncLength + 8], 48);
      end;

      if (FEncryption.R = 5) then
      begin
        // Start R = 5
        SHA256Digest := SHA256ByteArray(SHA256Input);
        SetLength(TestHash, 32);
        Move(SHA256Digest[0], TestHash[1], 32);
          // End R = 5
      end else
      if (FEncryption.R = 6) then
      begin
        // Start R = 6
        TestHash := CalculateVer6Hash(SHA256Input, PasswordA, TruncLength, QPLCopy(FEncryption.U, 1, 48));
        // End R = 6
      end;

      if (TestHash = QPLCopy(FEncryption.O, 1, 32)) then
      begin
        // The supplied Password is the owner password
        Result := True;

        SetLength(SHA256Input, TruncLength + 56);
        if (Length(PasswordA) > 0) then
        begin
          Move(PasswordA[1], SHA256Input[0], TruncLength);
        end;
        if (Length(FEncryption.O) >= 48) then
        begin
          Move(FEncryption.O[41], SHA256Input[TruncLength], 8);
        end;
        if (Length(FEncryption.U) >= 48) then
        begin
          Move(FEncryption.U[1], SHA256Input[TruncLength + 8], 48);
        end;

        if (FEncryption.R = 5) then
        begin
          SHA256Digest := SHA256ByteArray(SHA256Input);
          SetLength(IntermediateOwnerKey, 32);
          Move(SHA256Digest[0], IntermediateOwnerKey[1], 32);
        end else
        if (FEncryption.R = 6) then
        begin
          IntermediateOwnerKey := CalculateVer6Hash(SHA256Input, PasswordA, TruncLength, QPLCopy(FEncryption.U, 1, 48));
        end;

        ZeroInit := AnsiString(StringOfChar(#0, 16));
        EncryptionKey := AES256DecryptString(IntermediateOwnerKey,
          ZeroInit, FEncryption.OE);

        ZeroInit := AnsiString(StringOfChar(#0, 16));
        DecryptedPerms := AES256DecryptString(EncryptionKey, ZeroInit,
          FEncryption.Perms);
        if (Length(DecryptedPerms) > 0) then
        begin
          if (QPLPos('adb', DecryptedPerms) = 10) then
          begin
            Move(DecryptedPerms[1], PermTest, 4);
            if (PermTest <> FEncryption.P) then
            begin
              FEncryption.P := PermTest;
            end;
          end;
        end;
      end else
      begin
        Result := False;
      end;

      Exit;
    end;

    FOwnerPassword := PasswordA;
    FUserPassword := PasswordA;
    OwnerKey := '';
    UserKey := FEncryption.U;
    GenerateEncryptionKeys;

    if (FEncryption.R = 2) then
      FUserPassword := ARC4Encrypt(EncryptionKey, FEncryption.O);
    if (FEncryption.R = 3) or (FEncryption.R = 4) then
    begin
      TempKey := EncryptionKey;
      FUserPassword := FEncryption.O;
      for X := 19 downto 0 do
      begin
        for D := 1 to Length(TempKey) do
          TempKey[D] := AnsiChar(Ord(EncryptionKey[D]) xor X);
        FUserPassword := ARC4Encrypt(TempKey, FUserPassword);
      end;
    end;

    FUserPassword := FUserPassword;
    OwnerKey := FEncryption.O;
    UserKey := '';
    GenerateEncryptionKeys;

    if ((FEncryption.Length = 40) and (FEncryption.R < 3)) then
    begin
      Result := UserKey = FEncryption.U;
    end else
    begin
      Result := QPLCopy(UserKey, 1, 16) = QPLCopy(FEncryption.U, 1, 16);
    end;
  end;
end;

function TPDFDocument.IsTaggedPDF: Boolean;
var
  Obj: TPDFObject;
begin
  Result := false;
  Obj := RootDict.FindValueByKeyName('MarkInfo', True);
  if Obj is TPDFDictionary then
  begin
    Obj := TPDFDictionary(Obj).FindValueByKeyName('Marked', True);
    if (Obj is TPDFBoolean) then
    begin
      Result := TPDFBoolean(Obj).AsBoolean;
    end;
  end;
end;

function TPDFDocument.IsTextList(TextList: TPDFTextList): Boolean;
begin
  Result := FTextLists.IndexOf(TextList) >= 0;
end;

function TPDFDocument.CheckUserPassword(const Password: WideString): Boolean;
var
  PE: TPDFEncrypted;
  IntermediateUserKey: AnsiString;
  ZeroInit: AnsiString;
  DecryptedPerms: AnsiString;
  PermTest: Cardinal;

  SHAInput: TQPLByteArray;
  TestHash: AnsiString;
  SHA256Digest: TQPLSHA256Digest;
  TruncLength: Integer;
  PasswordA: AnsiString;
begin
  PE := GetEncrypted;

  if (FEncryption.Algorithm = eaAES256) then
  begin
    PasswordA := QPLUTF8Encode(Password);
  end else
  begin
    PasswordA := AnsiString(Password);
  end;

  if (PE = peDecrypted) then
  begin
    Result := PasswordA = '';
  end else
  begin
    if FEncryption.Length = 40 then
    begin
      FEncryptionStrength := esStd;
    end else
    if ((FEncryption.Length > 40) and (FEncryption.Length < 128)) then
    begin
      FEncryptionStrength := esVariable;
    end else
    begin
      FEncryptionStrength := es128Bit;
    end;

    if FEncryption.Algorithm = eaAES128 then
    begin
      FEncryptionStrength := esAES128Bit;
    end;

    if (FEncryption.Algorithm = eaAES256) then
    begin
      if (FEncryption.R = 6) then
      begin
        FEncryptionStrength := esAES256BitAcroX;
      end else
      begin
        FEncryptionStrength := esAES256Bit;
      end;

      TruncLength := Length(PasswordA);
      if (Length(PasswordA) > 127) then
      begin
        TruncLength := 127;
      end;

      SetLength(SHAInput, TruncLength + 8);
      if (Length(PasswordA) > 0) then
      begin
        Move(PasswordA[1], SHAInput[0], TruncLength);
      end;
      if (Length(FEncryption.U) >= 48) then
      begin
        Move(FEncryption.U[33], SHAInput[TruncLength], 8);
      end;

      if (FEncryption.R = 5) then
      begin
        // Start R = 5
        SHA256Digest := SHA256ByteArray(SHAInput);
        SetLength(TestHash, 32);
        Move(SHA256Digest[0], TestHash[1], 32);
        // End R = 5
      end else
      if (FEncryption.R = 6) then
      begin
        // Start R = 6
        TestHash := CalculateVer6Hash(SHAInput, PasswordA, TruncLength, '');
        // End R = 6
      end;

      if (TestHash = QPLCopy(FEncryption.U, 1, 32)) then
      begin
        // The supplied Password is the user password
        Result := True;

        SetLength(SHAInput, TruncLength + 8);
        if (Length(PasswordA) > 0) then
        begin
          Move(PasswordA[1], SHAInput[0], TruncLength);
        end;
        if (Length(FEncryption.U) >= 48) then
        begin
          Move(FEncryption.U[41], SHAInput[TruncLength], 8);
        end;

        if (FEncryption.R = 5) then
        begin
          SHA256Digest := SHA256ByteArray(SHAInput);
          SetLength(IntermediateUserKey, 32);
          Move(SHA256Digest[0], IntermediateUserKey[1], 32);
        end else
        if (FEncryption.R = 6) then
        begin
          IntermediateUserKey := CalculateVer6Hash(SHAInput, PasswordA, TruncLength, '');
        end;

        ZeroInit := AnsiString(StringOfChar(#0, 16));
        EncryptionKey := AES256DecryptString(IntermediateUserKey,
          ZeroInit, FEncryption.UE);

        ZeroInit := AnsiString(StringOfChar(#0, 16));
        DecryptedPerms := AES256DecryptString(EncryptionKey, ZeroInit,
          FEncryption.Perms);
        if (Length(DecryptedPerms) > 0) then
        begin
          if (QPLPos('adb', DecryptedPerms) = 10) then
          begin
            Move(DecryptedPerms[1], PermTest, 4);
            if (PermTest <> FEncryption.P) then
            begin
              FEncryption.P := PermTest;
            end;
          end;
        end;
      end else
      begin
        Result := False;
      end;

      Exit;
    end;

    FUserPassword := PasswordA;
    FOwnerPassword := '';
    OwnerKey := FEncryption.O;
    UserKey := '';

    GenerateEncryptionKeys;

    if ((FEncryption.Length = 40) and (FEncryption.R < 3)) then
    begin
      Result := UserKey = FEncryption.U;
    end else
    begin
      Result := QPLCopy(UserKey, 1, 16) = QPLCopy(FEncryption.U, 1, 16);
    end;
  end;
end;

function TPDFDocument.CalculateVer6Hash(var SHAInput: TQPLByteArray; const PasswordA: AnsiString; TruncLength: Integer; const UK: AnsiString): AnsiString;
var
  TestHash: AnsiString;
  SHA256Digest: TQPLSHA256Digest;
  SHA384Digest: TQPLSHA384Digest;
  SHA512Digest: TQPLSHA512Digest;
  K: AnsiString;
  RoundNumber: Integer;
  Remainder: Cardinal;
  RepeatLoop: Integer;
  K1: AnsiString;
  BigEndian128: TQuickPDFInt128;
  E: AnsiString;
begin
  // Generate the SHA-256 hash of the password input
  SHA256Digest := SHA256ByteArray(SHAInput);
  SetLength(K, 32);
  Move(SHA256Digest[0], K[1], 32);

  RoundNumber := -1;
  repeat
    Inc(RoundNumber);

    // We're checking the user password, so K1 should
    // just be the input password concatenated with K
    SetLength(K1, TruncLength + Length(K) + Length(UK));
    if (TruncLength > 0) then
    begin
      Move(PasswordA[1], K1[1], TruncLength);
    end;
    Move(K[1], K1[TruncLength + 1], Length(K));
    if (Length(UK) > 0) then
    begin
      Move(UK[1], K1[TruncLength + Length(K) + 1], Length(UK));
    end;

    // Double the string six times (effectively repeats it 64 times)
    for RepeatLoop := 1 to 6 do
    begin
      K1 := K1 + K1;
    end;

    // Encrypt K1 with AES-128
    E := AESEncryptStringNoPadding(QPLCopy(K, 1, 16), QPLCopy(K, 17, 16), K1);

    BigEndian128[3] := Ord(E[1]) shl 24 + Ord(E[2]) shl 16 + Ord(E[3]) shl 8 + Ord(E[4]);
    BigEndian128[2] := Ord(E[5]) shl 24 + Ord(E[6]) shl 16 + Ord(E[7]) shl 8 + Ord(E[8]);
    BigEndian128[1] := Ord(E[9]) shl 24 + Ord(E[10]) shl 16 + Ord(E[11]) shl 8 + Ord(E[12]);
    BigEndian128[0] := Ord(E[13]) shl 24 + Ord(E[14]) shl 16 + Ord(E[15]) shl 8 + Ord(E[16]);

    // Compute the remainder, modulo 3, on the first 128 bits
    Remainder := DPLInt128Mod(BigEndian128, 3);

    // Compute the SHA-256, SHA-384 or SHA-512 hash as determined by
    // the value of Remainder
    if (Remainder = 0) then
    begin
      // Remainder is 0, use the SHA-256 hash
      SetLength(SHAInput, Length(E));
      Move(E[1], SHAInput[0], Length(E));
      SHA256Digest := SHA256ByteArray(SHAInput);
      SetLength(K, 32);
      Move(SHA256Digest[0], K[1], 32);
    end else
    if (Remainder = 1) then
    begin
      // Remainder is 1, use the SHA-384 hash
      SetLength(SHAInput, Length(E));
      Move(E[1], SHAInput[0], Length(E));
      SHA384Digest := SHA384ByteArray(SHAInput);
      SetLength(K, 48);
      Move(SHA384Digest[0], K[1], 48);
    end else
    if (Remainder = 2) then
    begin
      // Remainder is 2, use the SHA-512 hash
      SetLength(SHAInput, Length(E));
      Move(E[1], SHAInput[0], Length(E));
      SHA512Digest := SHA512ByteArray(SHAInput);
      SetLength(K, 64);
      Move(SHA512Digest[0], K[1], 64);
    end;
  until (RoundNumber >= 63) and (Byte(E[Length(E)]) <= (RoundNumber - 31));

  TestHash := QPLCopy(K, 1, 32);
  Result := TestHash;
end;

procedure TPDFDocument.DecodePermKey(PKey: Cardinal);
begin
  PermKey := Cardinal(PKey);
  MalformedPermKey := (PermKey and $FFFF0000) = 0;

  FPermissions := [];
  FExtraPermissions := [];

  if (PermKey and 4) = 4 then
    FPermissions := FPermissions + [ppCanPrint];
  if (PermKey and 8) = 8 then
    FPermissions := FPermissions + [ppCanChange];
  if (PermKey and 16) = 16 then
    FPermissions := FPermissions + [ppCanCopy];
  if (PermKey and 32) = 32 then
    FPermissions := FPermissions + [ppCanAddNotes];

  if (PermKey and $0100) = $0100 then
    FExtraPermissions := FExtraPermissions + [ppCanFillFields];
  if (PermKey and $0200) = $0200 then
    FExtraPermissions := FExtraPermissions + [ppCanCopyAccess];
  if (PermKey and $0400) = $0400 then
    FExtraPermissions := FExtraPermissions + [ppCanAssemble];
  if (PermKey and $0800) = $0800 then
    FExtraPermissions := FExtraPermissions + [ppCanPrintFull];
end;

procedure TPDFDocument.SetPassword(const NewPassword: WideString);
begin
  FIsUserPassword := False;
  FIsOwnerPassword := False;
  if (CheckUserPassword(NewPassword)) then
  begin
    FIsUserPassword := True;
    FPassword := NewPassword;
    IndObjEncKey := EncryptionKey;
  end;
  //AES256TempSolution
  //if (CheckOwnerPassword(NewPassword)) then
  if (CheckOwnerPassword(NewPassword) and (not( ( (FEncryptionStrength = esAES256Bit) or (FEncryptionStrength = esAES256BitAcroX) ) and (NewPassword = '')))) then
  begin
    FIsOwnerPassword := True;
    FPassword := NewPassword;
    IndObjEncKey := EncryptionKey;
  end;

  if ((not FIsUserPassword) and (not FIsOwnerPassword)) then
  begin
    FPassword := '';
    IndObjEncKey := '';
  end;
end;

function TPDFDocument.SetPDFAMode(NewMode: Integer): Boolean;
begin
  Result := False;
  if (FPDFAModePossible) then
  begin
    if (NewMode = 2) then
    begin
      Result := True;
      FPDFAMode := 2;

      if (not Assigned(XMP)) then
      begin
        XMP := TDebenuPDFLibraryXMP.Create;
        XMP.LoadFromString(GetMetadata);
      end;

      XMP.PDFAID := '1B';
    end;
  end;
end;

procedure TPDFDocument.EncryptObject(const Key: AnsiString; Obj: TPDFObject);
var
  Value: AnsiString;
  DX: Integer;
begin
  if Obj is TPDFDictionary then
  begin
    for DX := 0 to TPDFDictionary(Obj).Count - 1 do
      EncryptObject(Key, TPDFDictionary(Obj).Entry[DX].Value);
  end else
  if Obj is TPDFArray then
  begin
    for DX := 0 to TPDFArray(Obj).Count - 1 do
      EncryptObject(Key, TPDFArray(Obj).Item[DX]);
  end else
  if Obj is TPDFString then
  begin
    Value := TPDFString(Obj).AsString;
    if (FEncryption.Algorithm = eaRC4) then
    begin
      Value := ARC4Encrypt(Key, Value);
    end else
    begin
      Value := AESEncryptString(Key, Value);
    end;

    TPDFString(Obj).SetTo(Value);
  end else
  if Obj is TPDFStream then
  begin
    Value := TPDFStream(Obj).Stream;
    if (FEncryption.Algorithm = eaRC4) then
    begin
      Value := ARC4Encrypt(Key, Value);
    end else
    begin
      Value := AESEncryptString(Key, Value);
    end;

    TPDFStream(Obj).Stream := Value;
    EncryptObject(Key, TPDFStream(Obj).Dictionary);
  end;
end;

function TPDFDocument.GetInfoIndObj: TPDFIndObj;
var
  Obj: TPDFObject;
begin
  Obj := FTrailer.FindValueByKeyName('Info');
  if Obj is TPDFIndRef then
    Result := FindObj(TPDFIndRef(Obj).ObjNum, TPDFIndRef(Obj).GenNum)
  else
  begin
    Obj := FStructure.NewDictionary;
    Result := NewObj(Obj);
    FTrailer.Add('Info', FStructure.NewIndirectRef(Result.ObjNum, Result.GenNum));
  end;
end;

procedure TPDFDocument.PageDecrypt(ObjNum, GenNum: Integer);
var
  IndObj: TPDFIndObj;
begin
  IndObj := FindObj(ObjNum, GenNum);
  if Assigned(IndObj) then
  begin
    if not IndObj.Decrypted then
    begin
      IndObj.Decrypt;
      DecryptObj(IndObj.Obj);
    end;
  end;
end;

procedure TPDFDocument.DecryptObj(Obj: TPDFObject);
var
  X: Integer;
begin
  if Obj is TPDFDictionary then
  begin
    for X := 0 to TPDFDictionary(Obj).Count - 1 do
      DecryptObj(TPDFDictionary(Obj).Entry[X].Value);
  end;
  if Obj is TPDFArray then
  begin
    for X := 0 to TPDFArray(Obj).Count - 1 do
      DecryptObj(TPDFArray(Obj).Item[X]);
  end;
  if Obj is TPDFIndRef then
    PageDecrypt(TPDFIndRef(Obj).ObjNum, TPDFIndRef(Obj).GenNum);
end;

function TPDFDocument.GetFont(FontIndex: Integer): TPDFFont;
begin
  if (FontIndex >= 0) and (FontIndex < FFonts.Count) and
    (FFonts[FontIndex] is TPDFFont) then
      Result := TPDFFont(FFonts[FontIndex])
    else
      Result := nil;
end;

function TPDFDocument.GetFontCount: Integer;
begin
  Result := FFonts.Count;
end;

function TPDFDocument.NewTilingPattern(const TilingPatternName: AnsiString;
  XObjectStream: TPDFStream): TPDFTilingPattern;
var
  L: Integer;
  X: Integer;
  PatternStream: TPDFStream;
  TilingPattern: TPDFTilingPattern;
  PatternDict: TPDFDictionary;
  Obj: TPDFObject;
  Rect: TPDFRectangle;
begin
  Result := nil;
  L := -1;
  for X := 0 to Length(FTilingPatterns) - 1 do
  begin
    if FTilingPatterns[X].TilingPatternName = TilingPatternName then L := X;
  end;
  if L < 0 then
  begin
    L := Length(FTilingPatterns);
    SetLength(FTilingPatterns, L + 1);
    TilingPattern := TPDFTilingPattern.Create;
    FTilingPatterns[L] := TilingPattern;
    TilingPattern.TilingPatternName := TilingPatternName;
    TilingPattern.CSName := 'QuickPDFTilingPattern' + QPLRandomID;

    Obj := XObjectStream.Dictionary.FindValueByKeyName('BBox', True);
    if (Obj is TPDFArray) then
    begin
      Rect := TPDFRectangle.Create(TPDFArray(Obj));
      try
        if (Rect.IsRectangle) then
        begin
          Obj := FStructure.Decode(XObjectStream.Dictionary.Output);
          if (Obj is TPDFDictionary) then
          begin
            PatternStream := FStructure.NewStreamWithDict(XObjectStream.Stream, TPDFDictionary(Obj));
            PatternDict := PatternStream.Dictionary;
            PatternDict.DeleteEntryByKeyName('Subtype');
            PatternDict.DeleteEntryByKeyName('FormType');
            PatternDict.Add('Type', FStructure.NewCommonName('Pattern'));
            PatternDict.Add('PatternType', FStructure.NewNumeric(1));
            PatternDict.Add('PaintType', FStructure.NewNumeric(1));
            PatternDict.Add('TilingType', FStructure.NewNumeric(1));
            PatternDict.Add('XStep', FStructure.NewNumeric(Rect.Width));
            PatternDict.Add('YStep', FStructure.NewNumeric(Rect.Height));

            TilingPattern.CS := NewObjRef(PatternStream);

            Result := TilingPattern;
          end;
        end;
      finally
        Rect.Free;
      end;
    end;
  end;
end;

function TPDFDocument.NewTrueTypeFont(const FontName: AnsiString;
  Embed, Force, LoadKernPairs: Boolean): TPDFFont;
var
  Font: TPDFFont;
  FN: AnsiString;
begin
  Inc(IndexCount);
  FN := 'QuickPDFF' + QPLRandomID;

  Font := TPDFFont.Create(FStructure, FN);
  Font.Compress := FCompressFonts = 1;
  if Font.NewTrueTypeFont(FontName, Embed, Force, LoadKernPairs) then
  begin
    FFonts.Add(Font);
    Result := Font;
  end else
  begin
    Font.Free;
    Result := nil;
  end;
end;

function TPDFDocument.NewTrueTypeFontFromStream(Source: TStream): TPDFFont;
var
  Font: TPDFFont;
  FN: AnsiString;
begin
  Inc(IndexCount);
  FN := 'QuickPDFF' + QPLRandomID;

  Font := TPDFFont.Create(FStructure, FN);
  Font.Compress := FCompressFonts = 1;
  if Font.NewTrueTypeFontFromStream(Source) then
  begin
    FFonts.Add(Font);
    Result := Font;
  end else
  begin
    Font.Free;
    Result := nil;
  end;
end;

function TPDFDocument.Decrypt: Boolean;
var
  Obj: TPDFObject;
  IO: TPDFIndObj;
begin
  Result := False;
  if (GetEncrypted = peEncrypted) and ((FIsUserPassword) or (FIsOwnerPassword)) then
  begin
    DecryptContent(False);
    Obj := FTrailer.FindValueByKeyName('Encrypt');
    if Obj <> nil then
    begin
      FTrailer.DeleteEntryByKeyName('Encrypt');
      if Obj is TPDFIndRef then
      begin
        IO := FindObj(TPDFIndRef(Obj).ObjNum, TPDFIndRef(Obj).GenNum);
        FStructure.RemoveObject(Obj);
        Obj := IO.Obj;
        if Assigned(Obj) and (Obj is TPDFDictionary) then
          FIndObjList.Remove(IO);
        BuildIndObjIndex;
      end;
    end;
    FEncryption.Extracted := False;
    Result := True;
  end;
end;

procedure TPDFDocument.SetOldFormat;
begin
  FStructure.OldFormat := True;
end;

function TPDFDocument.NewOutline(ParentRef: TPDFIndRef; const Title: WideString;
  DestPage: Integer; DestPosition: Double): TPDFIndRef;
var
  Obj: TPDFObject;
  ParentDict: TPDFDictionary;
  LastRef: TPDFIndRef;
  NewRef: TPDFIndRef;
  NewDict: TPDFDictionary;
  Dest: TPDFArray;
  PageDict: TPDFDictionary;

  procedure IncCount(ParentRef: TPDFIndRef);
  var
    C: Integer;
    O: TPDFObject;
    D: TPDFDictionary;
  begin
    if Assigned(ParentRef) and (ParentRef is TPDFIndRef) then
    begin
      O := ParentRef.Obj;
      if O is TPDFDictionary then
      begin
        D := TPDFDictionary(O);
        O := D.FindValueByKeyName('Count');
        if Assigned(O) and (O is TPDFNumeric) then
          C := TPDFNumeric(O).AsInteger
        else
          C := 0;
        if C < 0 then Dec(C) else Inc(C);
        D.PurgeKey('Count');
        D.Add('Count', FStructure.NewNumeric(C));
        O := D.FindValueByKeyName('Parent');
        if O is TPDFIndRef then IncCount(TPDFIndRef(O));
      end;
    end;
  end;

begin
  PageDict := FPageTree.GetPage(DestPage);

  NewRef := nil;
  if (not Assigned(ParentRef)) or (not (ParentRef is TPDFIndRef)) then
    ParentRef := GetOutlineDictionary;
  if ParentRef is TPDFIndRef then
  begin
    Obj := ParentRef.Obj;
    if Obj is TPDFDictionary then
    begin
      NewDict := FStructure.NewDictionary;
      NewDict.Add('Title', FStructure.NewTextString(Title));
      NewDict.Add('Parent', ParentRef);
      Dest := FStructure.NewArray;
      if Assigned(PageDict) then
      begin
        Dest.Add(FStructure.NewIndirectRef(PageDict.IndObjNum,
          PageDict.IndGenNum));
      end else
        Dest.Add(FStructure.NewNumeric(DestPage - 1));
      Dest.Add(FStructure.NewCommonName('XYZ'));
      Dest.Add(FStructure.NewNumeric(0));
      Dest.Add(FStructure.NewNumeric(DestPosition));
      Dest.Add(FStructure.NewNumeric(0));
      NewDict.Add('Dest', Dest);
      NewRef := NewObjRef(NewDict);
      ParentDict := TPDFDictionary(Obj);
      Obj := ParentDict.FindValueByKeyName('Last');
      if (Obj is TPDFIndRef) then
      begin
        LastRef := TPDFIndRef(Obj);
        NewDict.Add('Prev', LastRef);
        SetRef(LastRef, 'Next', NewRef);
        ParentDict.Add('Last', NewRef);
      end else
      begin
        ParentDict.Add('First', NewRef);
        ParentDict.Add('Last', NewRef);
      end;
      IncCount(ParentRef);
    end;
  end;
  Result := NewRef;
end;

function TPDFDocument.LoadFromString(const Source: AnsiString; const Password: WideString): TQPLLoadResult;
var
  CheckShift: Integer;
  Valid: TQPLValidSourceResult;
begin
  FPDFAModePossible := False;
  Result := lrOkay;
  try
    SourceFileSize := Length(Source);
    FSource := Source;
    Valid := ValidPDFSource(Password);
    if (Valid = vsError) then
    begin
      CheckShift := QPLPos('%PDF-', FSource);
      if CheckShift > 1 then
      begin
        XRefObjLoaded.Clear;
        Delete(FSource, 1, CheckShift - 1);
        Valid := ValidPDFSource(Password);
      end;
    end;
    if (Valid = vsWrongPassword) then
    begin
      Result := lrWrongPassword;
      Clear;
    end else
    if (Valid = vsError) then
    begin
      Result := lrError;
      Clear;
    end;
  except
    Clear;
    Result := lrError;
  end;
//  Password := '';
end;

function TPDFDocument.SaveToString: AnsiString;
var
  MS: TMemoryStream;
begin
  Result := '';
  MS := TMemoryStream.Create;
  try
    if SaveToStream(MS, False) then
    begin
      SetLength(Result, MS.Size);
      MS.Seek(0, soFromBeginning);
      MS.Read(Result[1], Length(Result));
    end;
  finally
    MS.Free;
  end;
end;

function TPDFDocument.SaveToStream(Stream: TStream; AppendMode: Boolean): Boolean;
var
  S: AnsiString;
  X: Integer;
  IndObj: TPDFIndObj;
  MaxObj: Integer;
  XRefStart: Integer;
  E: TPDFEncrypted;
  T: AnsiChar;
  ObjStrNums: TQPLSortedUniqueIntegerList;
  OldPage: Integer;
  ObjectNum: TQuickPDFIntegerList;
  Start: Integer;
  Check: Integer;
  Max: Integer;
  Fnt: TPDFFont;
begin
  // Save the XMP Metadata
  if Assigned(XMP) then
    SetMetadata(XMP.SaveToString);

  // Save the XFA Formfields
  if Assigned(FAcroForm) then
    FAcroForm.UpdateXFA;

  // Update the added subsetted TrueType fonts
  for X := 0 to FFonts.Count - 1 do
  begin
    Fnt := TPDFFont(FFonts[X]);
    Fnt.UpdateSubsettedFont;
  end;

  OldPage := FPageTree.Page;
  SetLength(XRefTable, 0);
  Result := True;
  try
    if (not AppendMode) then
    begin
      S := '%PDF-' + FVersion + #10;
      Stream.Write(S[1], Length(S));
      S := '%' + AnsiChar(226) + AnsiChar(227) + AnsiChar(207) + AnsiChar(211) + #10;
      Stream.Write(S[1], Length(S));
      if (Length(FHeaderComments) > 0) then
      begin
        S := FHeaderComments;
        if (not QPLEndsWith(S, #10)) then
        begin
          S := S + #10;
        end;
        Stream.Write(S[1], Length(S));
      end;
    end;
    S := '';

    ObjectNum := TQuickPDFIntegerList.Create;
    ObjStrNums := TQPLSortedUniqueIntegerList.Create;
    try
      MaxObj := 0;
      for X := 0 to FIndObjList.Count - 1 do
      begin
        if FIndObjList[X] is TPDFIndObj then
        begin
          if TPDFIndObj(FIndObjList[X]).ObjNum > MaxObj then
            MaxObj := TPDFIndObj(FIndObjList[X]).ObjNum;
          if TPDFIndObj(FIndObjList[X]).FObjStrNum > 0 then
            ObjStrNums.AddUnique(TPDFIndObj(FIndObjList[X]).FObjStrNum);
        end;
      end;

      SetLength(XRefTable, MaxObj + 1);
      with XRefTable[0] do
      begin
        ObjNum := 0;
        ObjPos := 0;
        GenNum := 65535;
        InUse := False;
      end;

      for X := 1 to Length(XRefTable) - 1 do
        with XRefTable[X] do
        begin
          ObjNum := X;
          ObjPos := 0;
          GenNum := 0;
          InUse := True;
        end;

      E := GetEncrypted;
      for X := 0 to FIndObjList.Count - 1 do
      begin
        S := '';
        if FIndObjList[X] is TPDFIndObj then
        begin
          IndObj := TPDFIndObj(FIndObjList[X]);
          S := '';

          if (IndObj.HasChanged) or (not AppendMode) then
          begin
            if ObjStrNums.Contains(IndObj.ObjNum) then
            begin
              S := '';
            end else
            begin
              ObjectNum.Add(IndObj.ObjNum);
              if ((not IndObj.Decoded) and IndObj.FCompact) then
              begin
                IndObj.Decode;
              end;
              if (E = peEncrypted) then
              begin
                IndObj.Obj;
                if (IndObj.ObjNum <> FEncryption.DictionaryObjNum) then
                begin
                  IndObj.Encrypt;
                  S := IndObj.Output;
                  IndObj.Decrypt;
                end else
                begin
                  S := IndObj.Output;
                end;
              end else
              begin
                S := IndObj.Output;
              end;
            end;
          end;
          if Length(S) > 0 then
          begin
            T := S[Length(S)];
            if (T <> #10) and (T <> #13) then
              S := S + #10;
            with XRefTable[IndObj.ObjNum] do
            begin
              ObjPos := Stream.Position;
              GenNum := IndObj.GenNum;
              if GenNum < 0 then GenNum := 0;
            end;
            Stream.Write(S[1], Length(S));
          end else
          begin
            if IndObj.FCompact then
            begin
              with XRefTable[IndObj.ObjNum] do
              begin
                ObjStrNum := IndObj.FObjStrNum;
                ObjStrIndex := IndObj.FObjStrIndex;              
              end;
            end else
            begin
              with XRefTable[IndObj.ObjNum] do
              begin
                ObjPos := 0;
                GenNum := 0;
                InUse := False;
                if GenNum < 0 then GenNum := 0;
              end;
            end;
          end;
        end;
      end;

      ObjectNum.SortList;
      XRefStart := Stream.Position;
      S := 'xref' + #10;
      Stream.Write(S[1], Length(S));
      Max := Length(XRefTable);

      if (AppendMode) then
      begin
        Start := 0;
        repeat
          Check := Start;
          repeat
            Inc(Check);
          until (ObjectNum.IndexOf(Check) < 0) or (Check > Max);
          Dec(Check);

          S := QPLIntToStr(Start) + ' ' + QPLIntToStr(Check - Start + 1) + #10;
          Stream.Write(S[1], Length(S));
          for X := Start to Check do
          begin
            if X = 0 then S := '0000000000 65535 f '#10 else
            begin
              S := QPLFormatFloat('0000000000', XRefTable[X].ObjPos);
              S := S + ' ';
              S := S + QPLFormatFloat('00000', XRefTable[X].GenNum);
              S := S + ' n '#10;
            end;
            Stream.Write(S[1], Length(S));
          end;
          Start := Check;
          repeat
            Inc(Start);
          until (ObjectNum.IndexOf(Start) >= 0) or (Start > Max);
          if Start > Max then Check := Max;
        until Check = Max;
      end else
      begin
        S := '0 ' + QPLIntToStr(Length(XRefTable)) + #10;
        Stream.Write(S[1], Length(S));

        for X := 0 to Length(XRefTable) - 1 do
        begin
          S := QPLPaddedInt(XRefTable[X].ObjPos, 10) + ' ' +
            QPLPaddedInt(XRefTable[X].GenNum, 5) + ' ';
          if XRefTable[X].InUse then S := S + 'n' else S := S + 'f';
          S := S + ' ' + #10;
          Stream.Write(S[1], Length(S));
        end;
      end;

      FTrailer.DeleteEntryByKeyName('XRefStm');
      if (AppendMode) then
      begin
        FTrailer.Add('Prev', FStructure.NewNumeric(FXRefPos));
      end;

      S := 'trailer' + #10 + FTrailer.Output;
      Stream.Write(S[1], Length(S));
      S := 'startxref' + #10 + QPLIntToStr(XRefStart) + #10 + '%%EOF' + #10;
      Stream.Write(S[1], Length(S));
    finally
      ObjStrNums.Free;
      ObjectNum.Free;
    end;
  except
    Result := False;
  end;
  SourceFileSize := Stream.Size;
  FPageTree.Page := OldPage;
end;

function TPDFDocument.SetPageMode(NewMode: TPDFPageMode): Boolean;
var
  Root: TPDFDictionary;
  S: AnsiString;
begin
  Root := GetRootDict;
  Result := False;
  if Assigned(Root) then
  begin
    Root.PurgeKey('PageMode');
    case NewMode of
      pmUseNone: S := 'UseNone';
      pmUseOutlines: S := 'UseOutlines';
      pmUseThumbs: S := 'UseThumbs';
      pmFullScreen: S := 'FullScreen';
      pmUseOC: S := 'UseOC';
      pmUseAttachments: S := 'UseAttachments';
    end;
    Root.Add('PageMode', FStructure.NewName(S));
    Result := True;
  end;
end;

function TPDFDocument.SetPageLayout(NewLayout: TPDFPageLayout): Boolean;
var
  Root: TPDFDictionary;
  S: AnsiString;
begin
  Root := GetRootDict;
  Result := False;
  if Assigned(Root) then
  begin
    Root.PurgeKey('PageLayout');
    if (NewLayout <> plNone) then
    begin
      case NewLayout of
        plSinglePage: S := 'SinglePage';
        plOneColumn: S := 'OneColumn';
        plTwoColumnLeft: S := 'TwoColumnLeft';
        plTwoColumnRight: S := 'TwoColumnRight';
        plTwoPageLeft: S := 'TwoPageLeft';
        plTwoPageRight: S := 'TwoPageRight';
      end;
      Root.Add('PageLayout', FStructure.NewName(S));
    end;
    Result := True;
  end;
end;

function TPDFDocument.SetBoolViewerPreferences(const Key: AnsiString;
  Value: Boolean): Boolean;
var
  Root: TPDFDictionary;
  O: TPDFObject;
  VP: TPDFDictionary;
begin
  Root := GetRootDict;
  Result := False;
  if Assigned(Root) then
  begin
    O := Root.FindValueByKeyName('ViewerPreferences');
    if O is TPDFDictionary then
    begin
      VP := TPDFDictionary(O);
      VP.PurgeKey(Key);
    end else
    begin
      VP := FStructure.NewDictionary;
      Root.Add('ViewerPreferences', VP);
    end;
    VP.Add(Key, FStructure.NewBoolean(Value));
    Result := True;
  end;
end;

function TPDFDocument.SetNameViewerPreferences(const Key,
  Value: AnsiString): Boolean;
var
  Root: TPDFDictionary;
  O: TPDFObject;
  VP: TPDFDictionary;
begin
  Root := GetRootDict;
  Result := False;
  if Assigned(Root) then
  begin
    O := Root.FindValueByKeyName('ViewerPreferences');
    if O is TPDFDictionary then
    begin
      VP := TPDFDictionary(O);
      VP.PurgeKey(Key);
    end else
    begin
      VP := FStructure.NewDictionary;
      Root.Add('ViewerPreferences', VP);
    end;
    VP.Add(Key, FStructure.NewName(Value));
    Result := True;
  end;
end;

function TPDFDocument.SetOpenActionMenu(const MenuItem: AnsiString): Boolean;
var
  Root: TPDFDictionary;
  OpenAction: TPDFDictionary;
begin
  Root := GetRootDict;
  Result := False;
  if Assigned(Root) then
  begin
    Root.PurgeKey('OpenAction');
    OpenAction := FStructure.NewDictionary;
    Root.Add('OpenAction', OpenAction);
    OpenAction.Add('Type', FStructure.NewName('Action'));
    OpenAction.Add('S', FStructure.NewName('Named'));
    OpenAction.Add('N', FStructure.NewName(MenuItem));
    Result := True;
  end;
end;

type
  TPageContent = record
    Resources: TPDFDictionary;
    PageWidth: Double;
    PageHeight: Double;
    Content: AnsiString;
  end;

function TPDFDocument.Merge(Next: TPDFDocument): Boolean;
var
  X: Integer;
  IndObj: TPDFIndObj;
  Offset: Integer;
  ObjSource: AnsiString;
  Stream: TPDFStream;
  StreamData: AnsiString;
  OldPages: TPDFIndRef;
  OldPageCount: Integer;
  NewPages: TPDFArray;
  Max: Integer;
  FirstMax: Integer;

  procedure MergeDicts(Target, Source: TPDFDictionary);
  var
    F1: TPDFDictionary;
    F2: TPDFDictionary;
    Obj: TPDFObject;
    X: Integer;
  begin
    F1 := nil;
    F2 := nil;
    Obj := Target.FindValueByKeyName('Font', True);
    if Obj is TPDFDictionary then F1 := TPDFDictionary(Obj);
    Obj := Source.FindValueByKeyName('Font', True);
    if Obj is TPDFDictionary then F2 := TPDFDictionary(Obj);
    if (Assigned(F1) and Assigned(F2)) then
    begin
      for X := 0 to F2.Count - 1 do
        F1.Add(F2.Entry[X].Key.Name, FStructure.Decode(F2.Entry[X].Value.Output));
    end else
    if (not Assigned(F1) and Assigned(F2)) then
    begin
      Target.Add('Font', FStructure.Decode(F2.Output));
    end;
  end;

begin
  // If the second document has form fields but the first one doesn't, then
  // add an AcroForm to the first document
  if (not HasFormData) and (Next.HasFormData) then
  begin
    NewAcroForm;
    HasFormData;
    AcroForm.NeedAppearances(Next.AcroForm.GetNeedAppearances = 'true');
  end;

  Max := 0;
  for X := 0 to FIndObjList.Count - 1 do
    if TPDFIndObj(FIndObjList[X]).ObjNum > Max then
      Max := TPDFIndObj(FIndObjList[X]).ObjNum;
  Offset := Max;
  FirstMax := Max;

  // Put resources into each page if only stored in the parent node
  Next.FixPageResources;

  OldPageCount := Next.PageCount;
  OldPages := Next.GetPagesRef;
  NewPages := PageTree.KidsArray;
  if OldPages.Obj is TPDFDictionary then
    TPDFDictionary(OldPages.Obj).Add('Parent', GetPagesRef);

  // Decode all the objects first, before shifting the object number
  for X := 0 to Next.FIndObjList.Count - 1 do
  begin
    IndObj := TPDFIndObj(Next.FIndObjList[X]);
    if (not IndObj.Decoded) then
    begin
      IndObj.Obj;
    end;
  end;

  // Once all the objects have been decoded, shift the object number
  for X := 0 to Next.FIndObjList.Count - 1 do
  begin
    IndObj := TPDFIndObj(Next.FIndObjList[X]);
    IndObj.FObjNum := IndObj.FObjNum + Offset;
    IndObj.FGenNum := 0;
    IndObj.Obj.Own(IndObj.FObjNum, IndObj.FGenNum);
  end;

  // Shift the object numbers of all references
  Next.FStructure.ShiftIndRef(Offset, True);

  // Rebuild the indirect object index of the Next document
  Next.BuildIndObjIndex;

  // Merge the form fields
  if HasFormData and Assigned(AcroForm.FieldsArray) and
    Next.HasFormData and Assigned(Next.AcroForm.FieldsArray) then
  begin
    for X := 0 to Next.AcroForm.FieldsArray.Count - 1 do
      AcroForm.FieldsArray.Add(FStructure.NewIndirectRef(
        TPDFIndRef(Next.AcroForm.FieldsArray.Item[X]).ObjNum,
          TPDFIndRef(Next.AcroForm.FieldsArray.Item[X]).GenNum));
  end;

  // Merge the Calculation Order array
  if HasFormData and Assigned(AcroForm.COArray) and
    Next.HasFormData and Assigned(Next.AcroForm.COArray) then
  begin
    for X := 0 to Next.AcroForm.COArray.Count - 1 do
      AcroForm.COArray.Add(FStructure.NewIndirectRef(
        TPDFIndRef(Next.AcroForm.COArray.Item[X]).ObjNum,
          TPDFIndRef(Next.AcroForm.COArray.Item[X]).GenNum));
  end;

  // Merge the DR dictionary (field resources), fonts
  if HasFormData and Assigned(AcroForm.DRDict) and
    Next.HasFormData and Assigned(Next.AcroForm.DRDict) then
      MergeDicts(AcroForm.DRDict, Next.AcroForm.DRDict);

  Max := 0;
  for X := 0 to Next.FIndObjList.Count - 1 do
  begin
    IndObj := TPDFIndObj(Next.FIndObjList[X]);
    if Assigned(IndObj) and (IndObj.FObjNum > Max) then
      Max := IndObj.FObjNum;
  end;

  for X := FirstMax + 1 to Max do
  begin
    try
      IndObj := Next.FindObj(X, 0);
    except
      IndObj := nil;
    end;

    if Assigned(IndObj) then
    begin
      if Assigned(IndObj.Obj) then
      begin
        if IndObj.Obj is TPDFStream then
        begin
          ObjSource := IndObj.Obj.Output;
          StreamData := TPDFStream(IndObj.Obj).Stream;
          Stream := FStructure.NewStream(StreamData);
          Stream.SetDict(TPDFDictionary(FStructure.Decode(ObjSource)));
          ObjSource := Stream.Dictionary.Output;
          NewObj(Stream, False);
        end else
        begin
          ObjSource := IndObj.Obj.Output;
          NewObj(FStructure.Decode(ObjSource), False);
        end;
      end else
        NewObj(FStructure.NewNull, False);
    end else
      NewObj(FStructure.NewNull, False);
  end;
  BuildIndObjIndex;

  NewPages.Add(FStructure.Decode(OldPages.Output));
  PageTree.SetPageCount(PageTree.PageCount + OldPageCount);
  Result := True;
end;

procedure TPDFDocument.CompressPage(PageNumber: Integer);
begin
  FPageTree.Page := PageNumber;
  FPageTree.Compress;
end;

procedure TPDFDocument.ReserveIndObj(Count: Integer);
begin
  FIndObjList.Capacity := FIndObjList.Count + Count;
end;

function TPDFDocument.HasFormData: Boolean;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
begin
  if not FormSearched then
  begin
    FormSearched := True;
    Root := RootDict;
    if Root <> nil then
    begin
      Obj := Root.FindValueByKeyName('AcroForm', True);
      if (not (Obj is TPDFDictionary)) then
      begin
        Obj := Root.FindValueByKeyName('Acroform', True);
        if (Obj is TPDFDictionary) then
        begin
          // This document has an "Acroform" dictionary, but no
          // "AcroForm" dictionary. So rename the key.
          Root.RenameKey('Acroform', 'AcroForm');
        end;
        Obj := Root.FindValueByKeyName('AcroForm', True);
      end;

      if (Obj is TPDFDictionary) then
      begin
        if Assigned(FAcroForm) then
        begin
          FAcroForm.Free;
          FAcroForm := nil;
        end;
        FAcroForm := TPDFForm.Create;
        FAcroForm.Load(TPDFDictionary(Obj));
        FAcroForm.OnNewIndObj := NewIndObj;
        FAcroForm.OnStandardFont := StandardFont;
      end;
    end;
  end;
  Result := Assigned(FAcroForm);
end;

function TPDFDocument.HasOwnerPassword: Boolean;
begin
  if (GetEncrypted = peEncrypted) then
  begin
    Result := not FOwnerPasswordBlank;
  end else
  begin
    Result := False;
  end;
end;

function TPDFDocument.SetPageActionMenu(const MenuItem: AnsiString): Boolean;
var
  Root: TPDFDictionary;
  AA: TPDFDictionary;
  OpenAction: TPDFDictionary;
begin
  Root := PageTree.ThisPage;
  Result := False;
  if Assigned(Root) then
  begin
    Root.PurgeKey('AA');
    AA := FStructure.NewDictionary;
    OpenAction := FStructure.NewDictionary;
    AA.Add('O', OpenAction);
    Root.Add('AA', AA);
    OpenAction.Add('S', FStructure.NewName('Named'));
    OpenAction.Add('N', FStructure.NewName(MenuItem));
    Result := True;
  end;
end;

function TPDFDocument.HasFontResources(PageNumber: Integer): Boolean;
var
  X: Integer;
  D: TPDFDictionary;
  R: TPDFObject;
  F: TPDFObject;
  StartPage: Integer;
  LastPage: Integer;
begin
  Result := False;

  if (PageNumber = 0) then
  begin
    StartPage := 1;
    LastPage := FPageTree.PageCount;
  end else
  begin
    StartPage := PageNumber;
    LastPage := PageNumber;
  end;

  for X := StartPage to LastPage do
  begin
    D := FPageTree.GetPage(X);
    if Assigned(D) then
    try
      R := D.FindValueByKeyName('Resources');
      if R is TPDFIndRef then
        R := TPDFIndRef(R).Obj;
      if R is TPDFDictionary then
      begin
        F := TPDFDictionary(R).FindValueByKeyName('Font');
        if F is TPDFIndRef then
          F := TPDFIndRef(F).Obj;
        if F is TPDFDictionary then Result := True;
      end;
    except
    end;
  end;

  // Check the pages Dict for a Resources/Font global dictionary
  D := GetPagesDict();
  R := D.FindValueByKeyName('Resources');
  if R is TPDFIndRef then
    R := TPDFIndRef(R).Obj;

  if (R is TPDFDictionary) then
  begin
    F := TPDFDictionary(R).FindValueByKeyName('Font', True);
    if F is TPDFIndRef then
      F := TPDFIndRef(F).Obj;

    if (F is TPDFDictionary) and (TPDFDictionary(F).Count > 0) then
      Result := True;
  end;
end;

function TPDFDocument.RotatePage(PageRotation: Integer): Boolean;
var
  D: TPDFDictionary;
begin
  Result := False;
  if PageRotation mod 90 = 0 then
  begin
    D := FPageTree.GetPage(FPageTree.Page);
    if Assigned(D) then
    try
      Result := True;
      D.PurgeKey('Rotate');
      D.Add('Rotate', FStructure.NewNumeric(PageRotation));
    except
    end;
  end;
end;

procedure TPDFDocument.AddDefaultHTMLFonts;
begin
  if not FHasDefaultHTMLFonts then
  begin
    HTMLFont[1] := NewStdFont(sfHelvetica);
    FPageTree.UseFont(HTMLFont[1]);
    HTMLFont[2] := NewStdFont(sfHelveticaBold);
    FPageTree.UseFont(HTMLFont[2]);
    HTMLFont[3] := NewStdFont(sfHelveticaOblique);
    FPageTree.UseFont(HTMLFont[3]);
    HTMLFont[4] := NewStdFont(sfHelveticaBoldOblique);
    FPageTree.UseFont(HTMLFont[4]);
    FHasDefaultHTMLFonts := True;
  end;
end;

procedure TPDFDocument.SetHTMLFonts;
var
  X: Integer;
  P: Integer;
  S1: AnsiString;
  S2: AnsiString;
begin
  if (HTMLFont[1] = nil) or (HTMLFont[2] = nil) or (HTMLFont[3] = nil)
    or (HTMLFont[4] = nil) then AddDefaultHTMLFonts;
  FPageTree.Painter.SetHTMLNormalFont(HTMLFont[1]);
  FPageTree.Painter.SetHTMLBoldFont(HTMLFont[2]);
  FPageTree.Painter.SetHTMLItalicFont(HTMLFont[3]);
  FPageTree.Painter.SetHTMLBoldItalicFont(HTMLFont[4]);
  FPageTree.UseFont(HTMLFont[1]);
  FPageTree.UseFont(HTMLFont[2]);
  FPageTree.UseFont(HTMLFont[3]);
  FPageTree.UseFont(HTMLFont[4]);
  for X := 0 to Length(HTMLEquivalentTags) - 1 do
  begin
    P := QPLPos('=', HTMLEquivalentTags[X]);
    if P > 0 then
    begin
      S1 := QPLTrim(QPLCopy(HTMLEquivalentTags[X], 1, P - 1));
      S2 := QPLTrim(QPLCopy(HTMLEquivalentTags[X], P + 1, MaxInt));
      FPageTree.Painter.SetHTMLTagEquivalent(S1, S2);      
    end;
  end;
end;

procedure TPDFDocument.SetHeaderComments(const Source: AnsiString);
begin
  FHeaderComments := Source;
end;

procedure TPDFDocument.SetHTMLFont(const FontSet: AnsiString; Index: Integer;
  AFont: TPDFFont);
begin
  if (Index >= 1) and (Index <= 4) then
    HTMLFont[Index] := AFont;
  if not FHasDefaultHTMLFonts then
  begin
    HTMLFont[1] := AFont;
    HTMLFont[2] := AFont;
    HTMLFont[3] := AFont;
    HTMLFont[4] := AFont;
    FHasDefaultHTMLFonts := True;
  end;
end;

function TPDFDocument.SetOpenActionDestination(Page, Zoom: Integer): Boolean;
var
  Root: TPDFDictionary;
  OpenAction: TPDFDictionary;
  Dest: TPDFArray;
begin
  Result := False;
  if (Page > 0) and (Page <= PageCount) then
  begin
    FPageTree.Page := Page;
    Root := GetRootDict;
    if Assigned(Root) then
    begin
      Root.PurgeKey('OpenAction');
      OpenAction := FStructure.NewDictionary;
      Root.Add('OpenAction', OpenAction);
      OpenAction.Add('Type', FStructure.NewName('Action'));
      OpenAction.Add('S', FStructure.NewName('GoTo'));
      Dest := FStructure.NewArray;
      Dest.Add(FStructure.NewIndirectRef(FPageTree.ThisPage.IndObjNum, FPageTree.ThisPage.IndGenNum));
      if (Zoom = -1) then
      begin
        Dest.Add(FStructure.NewName('Fit'));
      end;
      if (Zoom = -2) then
      begin
        Dest.Add(FStructure.NewName('FitH'));
        Dest.Add(FStructure.NewNumeric(FPageTree.PageHeight));
      end;
      if (Zoom >= 0) and (Zoom <= 1600) then
      begin
        Dest.Add(FStructure.NewName('XYZ'));
        case PageRotation of
          90:
          begin
            Dest.Add(FStructure.NewNumeric(0));
            Dest.Add(FStructure.NewNumeric(0));
          end;
          180:
          begin
            Dest.Add(FStructure.NewNumeric(FPageTree.PageWidth));
            Dest.Add(FStructure.NewNumeric(0));
          end;
          270:
          begin
            Dest.Add(FStructure.NewNumeric(FPageTree.PageWidth));
            Dest.Add(FStructure.NewNumeric(FPageTree.PageHeight));
          end;
        else
          Dest.Add(FStructure.NewNumeric(0));
          Dest.Add(FStructure.NewNumeric(FPageTree.PageHeight));
        end;
        Dest.Add(FStructure.NewNumeric(Zoom / 100));
      end;
      OpenAction.Add('D', Dest);
      Result := True;
    end;
  end;
end;

function TPDFDocument.IsFont(Font: TPDFFont): Boolean;
begin
  Result := FFonts.IndexOf(Font) >= 0;
end;

procedure TPDFDocument.AddTransparency(TransPer: Integer);
var
  X: Integer;
  I: Integer;
  TransDict: TPDFDictionary;
begin
  I := -1;
  X := 0;
  while (I < 0) and (X < Length(FTransparencyList)) do
  begin
    if FTransparencyList[X].Transparency = TransPer then
      I := X
    else
      Inc(X);
  end;
  if I < 0 then
  begin
    I := Length(FTransparencyList);
    SetLength(FTransparencyList, I + 1);
    FTransparencyList[I].Transparency := TransPer;
    Inc(IndexCount);    
    FTransparencyList[I].GSName := 'QuickPDFGS' +  QPLRandomID;
    TransDict := FStructure.NewDictionary;
    TransDict.Add('Type', FStructure.NewName('ExtGState'));
    TransDict.Add('SMask', FStructure.NewName('None'));
    TransDict.Add('ca', FStructure.NewNumeric(TransPer / 100));
    TransDict.Add('CA', FStructure.NewNumeric(TransPer / 100));
    FTransparencyList[I].GS := NewObjRef(TransDict);
  end;
  FPageTree.UseGS(FTransparencyList[I].GSName, FTransparencyList[I].GS);
  FPageTree.Painter.SetGS(FTransparencyList[I].GSName);
end;

procedure TPDFDocument.Compact;
var
  X: Integer;
begin
  for X := 0 to FIndObjList.Count - 1 do
    TPDFIndObj(FIndObjList[X]).Recode;
end;

procedure TPDFDocument.DeleteObj(ObjNum, GenNum: Integer);
var
  X: Integer;
  O: TPDFIndObj;
  Kill: Integer;
begin
  Kill := -1;
  X := 0;
  repeat
    O := TPDFIndObj(FIndObjList[X]);
    if (O.ObjNum = ObjNum) and (O.GenNum = GenNum) then
      Kill := X;
    Inc(X);
  until (X = FIndObjList.Count) or (Kill >= 0);
  if Kill >= 0 then FIndObjList.Delete(Kill);

  // Rebuild the indirect object index
  BuildIndObjIndex;
end;

procedure TPDFDocument.ReplaceFontsInFontDict(F: TPDFDictionary; IsFormFont: Boolean; Options: Integer);
const
  StandardFontNames: array[0..13] of AnsiString = ('Cour', 'CoBo', 'CoBO',
    'CoOb', 'Helv', 'HeBo', 'HeBO', 'HeOb', 'Time', 'TiBo', 'TiIt', 'TiBI',
    'Symb', 'ZaDb');
  BaseFonts: array[0..13] of AnsiString = ('Courier', 'Courier-Bold',
    'Courier-BoldOblique', 'Courier-Oblique', 'Helvetica', 'Helvetica-Bold',
    'Helvetica-BoldOblique', 'Helvetica-Oblique', 'Times-Roman', 'Times-Bold',
    'Times-Italic', 'Times-BoldItalic', 'Symbol', 'ZapfDingbats');
var
  DI: Integer;
  Obj, FontObj: TPDFObject;
  BaseFont: AnsiString;
  D: TPDFDictionary;
  X: Integer;
begin
  for DI := 0 to TPDFDictionary(F).Count - 1 do
  begin
    FontObj := TPDFDictionary(F).Entry[DI].Value;
    if FontObj is TPDFIndRef then FontObj := TPDFIndRef(FontObj).Obj;
    if FontObj is TPDFDictionary then
    begin
      D := TPDFDictionary(FontObj);
      if (D.StringValue('Type') = 'Font') and
        ((D.StringValue('Subtype') = 'TrueType') or (D.StringValue('Subtype') = 'Type1')) then
      begin
        if (Options < 10) then
        begin
          BaseFont := D.StringValue('BaseFont');
          for X := 1 to 14 do
          begin
            if QPLPos(BaseFont + '*', DebenuPDFLibraryFont.BaseFonts[X]) > 0 then
            begin
              FontObj := D.FindValueByKeyName('FontDescriptor');
              if FontObj is TPDFIndRef then FontObj := TPDFIndRef(FontObj).Obj;
              if FontObj is TPDFDictionary then
                FontObj := TPDFDictionary(FontObj).FindValueByKeyName('FontFile2');
              if FontObj is TPDFIndRef then FontObj := TPDFIndRef(FontObj).Obj;
              if FontObj is TPDFStream then
                TPDFStream(FontObj).SetTo('', False);

              D.PurgeKey('FirstChar');
              D.PurgeKey('LastChar');
              D.PurgeKey('Widths');
              D.PurgeKey('FontDescriptor');
              D.PurgeKey('Subtype');
              D.Add('Subtype', FStructure.NewName('Type1'));

              D.PurgeKey('BaseFont');
              if (IsFormFont) then
                D.Add('BaseFont', FStructure.NewName(StandardFontNames[X - 1]))
              else
                D.Add('BaseFont', FStructure.NewName(BaseFonts[X - 1]));

              if (Options = 1) then
              begin
                D.PurgeKey('ToUnicode');
                D.Add('Encoding', FStructure.NewName('WinAnsiEncoding'));
              end;
            end;
          end;

          if (Options = 1) then
          begin
            // Now remove the ToUnicode entry from and subsetted fonts.
            BaseFont := D.StringValue('BaseFont');

            if ((Length(BaseFont) > 7) and (BaseFont[7] = '+')) then
            begin
              D.PurgeKey('FirstChar');
              D.PurgeKey('LastChar');

              D.PurgeKey('ToUnicode');
              D.Add('Encoding', FStructure.NewName('WinAnsiEncoding'));
            end;
          end;
        end;

        // Remove FontFile (TTF font outlines) to basically un-embed the font.
        if (Options = 10) then
        begin
          for X := 1 to 14 do
          begin
            BaseFont := D.StringValue('BaseFont');

            if QPLPos(BaseFont + '*', DebenuPDFLibraryFont.BaseFonts[X]) > 0 then
            begin
              FontObj := D.FindValueByKeyName('FontDescriptor', True);

              if FontObj is TPDFDictionary then
              begin
                Obj := TPDFDictionary(FontObj).FindValueByKeyName('FontFile2', True);
                if Obj is TPDFStream then
                  DeleteObj(Obj.IndObjNum, Obj.IndGenNum);

                TPDFDictionary(FontObj).DeleteEntryByKeyName('FontFile2');
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TPDFDocument.ReplaceFonts(Options: Integer);
var
  D: TPDFDictionary;
  X: Integer;
  R: TPDFObject;
  F: TPDFObject;
begin
  for X := 1 to FPageTree.PageCount do
  begin
    D := FPageTree.GetPage(X);
    if Assigned(D) then
    try
      R := D.FindValueByKeyName('Resources');
      if R is TPDFIndRef then
        R := TPDFIndRef(R).Obj;
      if R is TPDFDictionary then
      begin
        F := TPDFDictionary(R).FindValueByKeyName('Font');
        if F is TPDFIndRef then
          F := TPDFIndRef(F).Obj;
        if F is TPDFDictionary then
          ReplaceFontsInFontDict(TPDFDictionary(F), False, Options);
      end;
    except
    end;
  end;

  if HasFormData and Assigned(AcroForm) then
  begin
    D := AcroForm.GetFormFontDict;
    if Assigned(D) then
      ReplaceFontsInFontDict(D, False, Options);
  end;
end;

procedure TPDFDocument.ReplaceObj(ObjNum, GenNum: Integer;
  NewObject: TPDFObject);
var
  Min, Max: Integer;
  Mid: Integer;
begin
  Min := 0;
  Max := Length(FIndObjIndex);
  while (Min < Max) do
  begin
    Mid := Min + ((Max - Min) div 2);
    if (FIndObjIndex[Mid] < ObjNum) then
    begin
      Min := Mid + 1;
    end else
    begin
      Max := Mid;
    end;
  end;
  if ((Min < Length(FIndObjIndex)) and (FIndObjIndex[Min] = ObjNum)) then
  begin
    TPDFIndObj(FIndObjList[FIndObjKey[Min]]).FObj := NewObject;
    TPDFIndObj(FIndObjList[FIndObjKey[Min]]).FDecoded := True;
    TPDFIndObj(FIndObjList[FIndObjKey[Min]]).FCompact := False;
  end;
end;

procedure TPDFDocument.NewAcroForm;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  AcroFormDict: TPDFDictionary;
  Ref: TPDFIndRef;
begin
  Root := GetRootDict;
  if Root <> nil then
  begin
    FormSearched := False;
    AcroFormDict := FStructure.NewDictionary;
    AcroFormDict.Add('Fields', FStructure.NewArray);

    Obj := Root.FindValueByKeyName('AcroForm');
    if (not (Obj is TPDFDictionary)) then
    begin
      Ref := NewObjRef(AcroFormDict);
      Root.Add('AcroForm', Ref);
    end;
  end;
end;

function TPDFDocument.NewEmptyDictRef: TPDFIndRef;
begin
  Result := NewObjRef(FStructure.NewDictionary);
end;

function TPDFDocument.NewType1Font(const FileName: WideString): TPDFFont;
var
  Font: TPDFFont;
  FN: AnsiString;
begin
  Inc(IndexCount);
  FN := 'QuickPDFF' + QPLRandomID;

  Font := TPDFFont.Create(FStructure, FN);
  Font.Compress := FCompressFonts = 1;
  if Font.NewType1Font(FileName) then
  begin
    FFonts.Add(Font);
    Result := Font;
  end else
  begin
    Font.Free;
    Result := nil;
  end;
end;

function TPDFDocument.GetData(ObjNum: Integer): AnsiString;
var
  ONum: Integer;
  OLen: Integer;
  FS: TQuickPDFWideFileStream;
begin
  Result := '';

  if (FTempFileName <> '') and Assigned(FMainFS) then
  begin
    FS := FMainFS;
    ONum := 0;
    try
      if FS.Size > 0 then
      begin
        FS.Seek(FLastDataPos, soFromBeginning);
        repeat
          FS.Read(ONum, 4);
          FS.Read(OLen, 4);
          if (ONum <> ObjNum) then
            FS.Seek(OLen, soFromCurrent);
        until (ONum = ObjNum) or (FS.Position > FS.Size - 8);
        if ONum <> ObjNum then
        begin
          FS.Seek(FLastDataPos, soFromBeginning);
          repeat
            FS.Read(ONum, 4);
            FS.Read(OLen, 4);
            if (ONum <> ObjNum) then
              FS.Seek(OLen, soFromCurrent);
          until (ONum = ObjNum) or (FS.Position > FS.Size - 8);
        end;
      end;
      if ONum = ObjNum then
      begin
        SetLength(Result, OLen);
        FS.Read(Result[1], OLen);
        FLastDataPos := FS.Position;
      end;
    finally
    end;
  end;
end;

procedure TPDFDocument.StoreData(ObjNum: Integer; Data: AnsiString);
var
  OLen: Integer;
  FS: TQuickPDFWideFileStream;
begin
  if (FTempFileName <> '') and Assigned(FMainFS) then
  begin
    FS := FMainFS;
    try
      FS.Seek(FS.Size, soBeginning);
      if Data <> '' then
      begin
        FS.Write(ObjNum, 4);
        OLen := Length(Data);
        FS.Write(OLen, 4);
        FS.Write(Data[1], Length(Data));
      end;
    finally
    end;
  end;
end;

function TPDFDocument.SetTempFileName(const FN: WideString): Boolean;
var
  FS: TQuickPDFWideFileStream;
begin
  FTempFileName := '';
  Result := True;
  if QPLFileExists(FN) then
  begin
    try
      QPLDeleteFile(FN);
    except
      Result := False;
    end;
  end;
  if not QPLFileExists(FN) then
  begin
    try
      FS := QPLCreateFileStream(FN, fmCreate or fmShareExclusive);
      try
      finally
        FS.Free;
      end;
    except
      Result := False;
    end;
  end else
    Result := False;
  if Result then FTempFileName := FN;
end;

function TPDFDocument.HasTempFile: Boolean;
begin
  Result := FTempFileName <> '';
end;

function TPDFDocument.HasUserPassword: Boolean;
begin
  if (GetEncrypted = peEncrypted) then
  begin
    Result := not FUserPasswordBlank;
  end else
  begin
    Result := False;
  end;
end;

function TPDFDocument.ReleaseImage(Image: TPDFImage): Boolean;
begin
  Result := FImages.Remove(Image) >= 0;
end;

function TPDFDocument.ReleaseImageList(ImageList: TPDFImageList): Boolean;
begin
  Result := FImageLists.Remove(ImageList) >= 0;
end;

function TPDFDocument.ReleaseTextList(TextList: TPDFTextList): Boolean;
begin
  Result := FTextLists.Remove(TextList) >= 0;
end;

procedure TPDFDocument.Reload;
var
  S: AnsiString;
begin
  if FTempFileName <> '' then
  begin

    if QPLFileExists(FTempFileName) then
      FMainFS := QPLCreateFileStream(FTempFileName, fmOpenRead or fmShareExclusive)
    else
      FMainFS := QPLCreateFileStream(FTempFileName, fmCreate or fmShareExclusive);

    try
      S := SaveToString;
    finally
      if Assigned(FMainFS) then FMainFS.Free;
      FMainFS := nil;
    end;

    FStructure.Free;
    FStructure := nil;
    FIndObjList.Free;
    FIndObjList := nil;
    FImages.Free;
    FImages := nil;
    FImageLists.Free;
    FImageLists := nil;
    FTextLists.Free;
    FTextLists := nil;
    FFonts.Free;
    FFonts := nil;
    CapturedPages.Free;
    CapturedPages := nil;
    XRefObjLoaded.Free;
    XRefObjLoaded := nil;

    if Assigned(FPageTree) then FPageTree.Free;
    FPageTree := nil;
    if Assigned(FAcroForm) then FAcroForm.Free;
    FAcroForm := nil;
    FTrailer := nil;
    if Assigned(XMP) then XMP.Free;
    XMP := nil;

    if (FTempFileName <> '') and QPLFileExists(FTempFileName) then
    try
      QPLDeleteFile(FTempFileName);
    except
    end;

    Init;
    Clear;

    LoadFromString(S, FPassword);
  end;
end;

function TPDFDocument.ReloadFormData: Boolean;
begin
  FormSearched := False;
  Result := HasFormData;
end;

procedure TPDFDocument.Init;
begin
  FMainFS := nil;
  FillSet := False;
  IndexCount := 0;
  FChanged := False;
  FPassword := '';
  FSource := '';
  FLastDataPos := 0;
  FUserModDate := False;
  FStructure := TPDFStructure.Create;
  FStructure.OnIndObjLookup := GetIndObj;
  FStructure.OnNewIndObj := NewIndObj;
  FIndObjList := TObjectList.Create(True);
  FImages := TObjectList.Create(True);
  FImageLists := TObjectList.Create(True);
  FTextLists := TObjectList.Create(True);
  FFonts := TObjectList.Create(True);
  CapturedPages := TObjectList.Create(True);
  XRefObjLoaded := TQPLSortedUniqueIntegerList.Create;

  FormSearched := False;
  FAcroForm := nil;
  FHasDefaultHTMLFonts := False;
  FScale := 1;
  FOrigin := 0;
  FCompressImages := 0;
  FCompressFonts := 0;
  FUseExistingFonts := 0;
  FJavaScriptMode := smString;
  FUseUnsafeLayers := False;
  FTempFileName := '';
  SetLength(XRefTable, 0);
  IndexCount := 0;
  HTMLFont[1] := nil;
  HTMLFont[2] := nil;
  HTMLFont[3] := nil;
  HTMLFont[4] := nil;
  FLastDataPos := 0;
  FRepaired := False;
  XMP := nil;
end;

procedure TPDFDocument.AddImageFromStream(ImageStream: TPDFStream; ObjNum,
  GenNum: Integer; FullConvert: Boolean = False);
var
  ID: TPDFImageDecoder;
  ImWidth: Integer;
  ImHeight: Integer;
  ImageName: AnsiString;
  Image: TPDFImage;
begin
  ID := TPDFImageDecoder.Create;
  try
    ID.GDIPlusSettings := ImageGDIPlusSettings;
    if (FullConvert) then
    begin
      ID.DecodeMode := dmToBitmap;
    end else
    begin
      ID.DecodeMode := dmToNative;
    end;
    ID.LoadFromPDFStream(ImageStream);
    ImWidth := ID.Width;
    ImHeight := ID.Height;
    Inc(IndexCount);
    ImageName := 'QuickPDFIm' + QPLRandomID;
    Image := TPDFImage.Create(FStructure, ImageName, FIncludedFonts);

    if ID.NativeType = nitTIFF then
    begin
      Image.ImageType := itTIFF;
      Image.ImageData := ID.NativeImageData;
    end else
    if ID.NativeType = nitJPEG then
    begin
      Image.ImageType := itJPEG;
      Image.ImageData := ID.NativeImageData;
    end else
    if ID.NativeType = nitPNG then
    begin
      Image.ImageType := itPNG;
      Image.ImageData := ID.NativeImageData;
    end else
    begin
      Image.ImageType := itBMP;
      Image.ImageData := ID.BitmapAsString;
    end;

    Image.FillColor := ID.GetCenterColor;
    Image.Populate(ObjNum, GenNum, ImWidth, ImHeight);
    FImages.Add(Image);
  finally
    ID.Free;
  end;
end;

function TPDFDocument.FindImagesMode1(FullConvert: Boolean = False): Integer;
var
  X: Integer;
  ImgObj: TPDFObject;
  ObjNum: Integer;
  GenNum: Integer;
  PageNum: Integer;
  PageDict: TPDFDictionary;
  ImageList: TQuickPDFStringList;

  procedure ProcessResourcesDict(RD: TPDFDictionary);
  var
    Obj: TPDFObject;
    Dict: TPDFDictionary;
    Subtype: TPDFObject;
    XObjectNum: Integer;
    XObjectDict: TPDFDictionary;
    ImageRef: TPDFIndRef;
    ImageRefStr: AnsiString;
    PatternNum: Integer;
    PatternDict: TPDFDictionary;
    PatternRef: TPDFIndRef;
  begin
    Obj := RD.FindValueByKeyName('Resources', True);
    if Obj is TPDFDictionary then
    begin
      Dict := TPDFDictionary(Obj);

      // XObject dictionary
      Obj := Dict.FindValueByKeyName('XObject', True);
      if Obj is TPDFDictionary then
      begin
        XObjectDict := TPDFDictionary(Obj);
        for XObjectNum := 0 to XObjectDict.Count - 1 do
        begin
          Obj := XObjectDict.Entry[XObjectNum].Value;
          if Obj is TPDFIndRef then
          begin
            ImageRef := TPDFIndRef(Obj);
            ImageRefStr := ImageRef.Output;
            Obj := ImageRef.Obj;
            if Obj is TPDFStream then
            begin
              Dict := TPDFStream(Obj).Dictionary;
              Subtype := Dict.FindValueByKeyName('Subtype', True);
              if (Subtype is TPDFName) and (TPDFName(Subtype).Name = 'Image') then
              begin
                if ImageList.IndexOf(ImageRefStr) < 0 then
                begin
                  ImageList.AddObject(ImageRefStr, ImageRef);
                  if ImageList.Count = ImageList.Capacity then
                  begin
                    ImageList.Capacity := ImageList.Capacity + 100;
                  end;
                end;
              end;
              if (Subtype is TPDFName) and (TPDFName(Subtype).Name = 'Form') then
              begin
                if (Dict.IndObjNum <> 0) then
                  ProcessResourcesDict(Dict);
              end;
            end;
          end;
        end;
      end;

      // Pattern dictionary
      Obj := Dict.FindValueByKeyName('Pattern', True);
      if Obj is TPDFDictionary then
      begin
        PatternDict := TPDFDictionary(Obj);
        for PatternNum := 0 to PatternDict.Count - 1 do
        begin
          Obj := PatternDict.Entry[PatternNum].Value;
          if Obj is TPDFIndRef then
          begin
            PatternRef := TPDFIndRef(Obj);
            Obj := PatternRef.Obj;
            if Obj is TPDFStream then
            begin
              Dict := TPDFStream(Obj).Dictionary;
              if Dict.DictType = 'Pattern' then
              begin
                ProcessResourcesDict(Dict);
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  procedure ProcessAnnotsArrays(RD: TPDFDictionary);
  var
    Obj: TPDFObject;
    Dict: TPDFDictionary;
    AX: Integer;
    AR: TPDFArray;
  begin
    Obj := RD.FindValueByKeyName('Annots', True);
    if Obj is TPDFArray then
    begin
      AR := TPDFArray(Obj);
      for AX := 0 to AR.Count - 1 do
      begin
        Obj := AR.Item[AX];
        if Obj is TPDFIndRef then
        begin
          Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFDictionary then
          begin
            Dict := TPDFDictionary(Obj);
            Obj := Dict.FindValueByKeyName('AP', False);
            if Obj is TPDFIndRef then
            begin
              Obj := TPDFIndRef(Obj).Obj;
            end;
            if Obj is TPDFDictionary then
            begin
              Dict := TPDFDictionary(Obj);
              Obj := Dict.FindValueByKeyName('N', False);
              if Obj is TPDFIndRef then
                Obj := TPDFIndRef(Obj).Obj;
              if Obj is TPDFStream then
              begin
                ProcessResourcesDict(TPDFStream(Obj).Dictionary);
              end;
            end;
          end;
        end;
      end;
    end;
  end;

begin
  Result := 0;
  ImageList := TQuickPDFStringList.Create;
  try
    ImageList.Capacity := 100;
    for PageNum := 1 to FPageTree.PageCount do
    begin
      PageDict := FPageTree.GetPage(PageNum);
      if Assigned(PageDict) then
      begin
        // Processing /Resources
        ProcessResourcesDict(PageDict);
        // Processing /Annots
        ProcessAnnotsArrays(PageDict);
      end;
    end;

    for X := 0 to ImageList.Count - 1 do
    begin
      if ImageList.Objects[X] is TPDFIndRef then
      begin
        ImgObj := TPDFObject(ImageList.Objects[X]);
        ObjNum := TPDFIndRef(ImgObj).ObjNum;
        GenNum := TPDFIndRef(ImgObj).GenNum;
        ImgObj := TPDFIndRef(ImgObj).Obj;
        if ImgObj is TPDFStream then
        begin
          AddImageFromStream(TPDFStream(ImgObj), ObjNum, GenNum, FullConvert);
          Inc(Result);
        end;
      end;
    end;
  finally
    ImageList.Free;
  end;
end;

function TPDFDocument.FindImagesMode2(FullConvert: Boolean = False): Integer;
var
  X: Integer;
  Obj: TPDFObject;
  Dict: TPDFDictionary;
  Stream: TPDFStream;
  DictType: AnsiString;
  Subtype: AnsiString;
begin
  Result := 0;
  for X := 0 to FIndObjList.Count - 1 do
  begin
    Obj := TPDFIndObj(FIndObjList[X]).Obj;
    if Obj is TPDFStream then
    begin
      Stream := TPDFStream(Obj);

      Dict := Stream.Dictionary;
      DictType := Dict.DictType;
      if ((DictType = '') or (DictType = 'XObject')) then
      begin
        Obj := Dict.FindValueByKeyName('Subtype');
        if (Obj is TPDFName) then
        begin
          Subtype := TPDFName(Obj).Name;
        end else
        begin
          Subtype := '';
        end;

        if (Subtype = 'Image') then
        begin
          AddImageFromStream(Stream, TPDFIndObj(FIndObjList[X]).ObjNum, TPDFIndObj(FIndObjList[X]).GenNum, FullConvert);
          Inc(Result);
        end;
      end;
    end;
  end;
end;

type
  TNewIndObj = record
    OldObjNum: Integer;
    NewObjNum: Integer;
  end;

  TValidPage = record
    OldObjNum: Integer;
    NewObjNum: Integer;
  end;

function TPDFDocument.CopyPagesFromDoc(SourceDoc: TPDFDocument;
  const PageRanges: AnsiString;
  SortList: Boolean = True;
  AllowDuplicates: Boolean = False): Boolean;
var
  Page: Integer;
  NewIndObjList: array of TNewIndObj;
  DestDict: TPDFDictionary;
  SourceDict: TPDFDictionary;
  InvalidPages: array of Integer;
  PageList: TQuickPDFPageList;
  ValidPages: AnsiString;
  StartIndex: Integer;
  Processed: AnsiString;
  Obj: TPDFObject;
  OldParent: TPDFObject;
  SourceStructure: TPDFStructure;
  FieldIndex: Integer;

  function FindNewIndObj(OldObjNum: Integer): Integer;
  var
    X: Integer;
    Found: Boolean;
  begin
    Result := -1;
    Found := False;
    X := 0;
    while (X < Length(NewIndObjList)) and (not Found) do
    begin
      if NewIndObjList[X].OldObjNum = OldObjNum then
      begin
        Result := NewIndObjList[X].NewObjNum;
        Found := True;
      end else
        Inc(X);
    end;
  end;

  function InvalidPage(TestPage: Integer): Boolean;
  var
    Found: Boolean;
    X: Integer;
  begin
    X := 0;
    Found := False;
    Result := False;
    while (X < Length(InvalidPages)) and (not Found) do
    begin
      if InvalidPages[X] = TestPage then
      begin
        Result := True;
        Found := True;
      end else
        Inc(X);
    end;
  end;

  function Process(const Input: AnsiString): AnsiString;
  var
    X: Integer;
    I: Integer;
    IR: TPDFIndRef;
    Obj: TPDFObject;
    GetObj: TPDFObject;
    NewObjNum: Integer;
    NewGenNum: Integer;
    TempStructure: TPDFStructure;
    NewStream: TPDFStream;
    StreamData: AnsiString;
    TempIndObj: TPDFIndObj;
    TempObj: TPDFObject;
  begin
    TempStructure := TPDFStructure.Create;
    try
      Obj := TempStructure.Decode(Input);
      for X := 0 to TempStructure.ObjectCount - 1 do
      begin
        if TempStructure.GetObject(X) is TPDFIndRef then
        begin
          IR := TPDFIndRef(TempStructure.GetObject(X));
          I := FindNewIndObj(IR.ObjNum);
          if InvalidPage(IR.ObjNum) then
          begin
            IR.ObjNum := 1;
            IR.GenNum := 0;
          end else
          begin
            if (I < 0) and (QPLPos('[' + IR.Output + ']', Processed) = 0) then
            begin
              SourceDoc.GetIndObj(Self, IR.ObjNum, IR.GenNum, GetObj);
              if Assigned(GetObj) then
              begin
                Processed := Processed + '[' + IR.Output + ']';
                if GetObj is TPDFStream then
                begin
                  StreamData := TPDFStream(GetObj).Stream;
                  NewStream := FStructure.NewStream(StreamData);

                  TempIndObj := NewObj(NewStream);
                  NewObjNum := TempIndObj.ObjNum;
                  NewGenNum := TempIndObj.GenNum;
                  SetLength(NewIndObjList, Length(NewIndObjList) + 1);
                  NewIndObjList[Length(NewIndObjList) - 1].OldObjNum := IR.ObjNum;
                  NewIndObjList[Length(NewIndObjList) - 1].NewObjNum := NewObjNum;
                  NewStream.SetDict(TPDFDictionary(FStructure.Decode(Process(TPDFStream(GetObj).Dictionary.Output))));
                end else
                begin
                  TempObj := FStructure.Decode('1');
                  TempIndObj := NewObj(TempObj);
                  NewObjNum := TempIndObj.ObjNum;
                  NewGenNum := TempIndObj.GenNum;
                  SetLength(NewIndObjList, Length(NewIndObjList) + 1);
                  NewIndObjList[Length(NewIndObjList) - 1].OldObjNum := IR.ObjNum;
                  NewIndObjList[Length(NewIndObjList) - 1].NewObjNum := NewObjNum;

                  FStructure.RemoveObject(TempObj);
                  TempObj := FStructure.Decode(Process(GetObj.Output));
                  TempIndObj.FObj := TempObj;
                  TempObj.Own(NewObjNum, NewGenNum);
                end;
                IR.ObjNum := NewObjNum;
                IR.GenNum := NewGenNum;
              end;
            end else
            begin
              IR.ObjNum := I;
              IR.GenNum := 0;
            end;
          end;
        end;
      end;
      Result := Obj.Output;
    finally
      TempStructure.Free;
    end;
  end;

  procedure CloneDict(Source, Dest: TPDFDictionary);
  var
    X: Integer;
  begin
    for X := 0 to Source.Count - 1 do
      Dest.Add(Source.Entry[X].Key.Name, FStructure.Decode(Process(Source.Entry[X].Value.Output)));
  end;

  function GetInheritedObject(Start: TPDFDictionary; const Key: AnsiString): TPDFObject;
  var
    O: TPDFObject;
  begin
    Result := nil;
    if Assigned(Start) then
    begin
      O := Start.FindValueByKeyName(Key, True);
      if Assigned(O) then Result := O else
      begin
        O := Start.FindValueByKeyName('Parent', True);
        if O is TPDFDictionary then
          Result := GetInheritedObject(TPDFDictionary(O), Key);
      end;
    end;
  end;

  procedure MergeDicts(Target, Source: TPDFDictionary);
  var
    F1: TPDFDictionary;
    F2: TPDFDictionary;
    Obj: TPDFObject;
    X: Integer;
  begin
    F1 := nil;
    F2 := nil;
    Obj := Target.FindValueByKeyName('Font', True);
    if Obj is TPDFDictionary then F1 := TPDFDictionary(Obj);
    Obj := Source.FindValueByKeyName('Font', True);
    if Obj is TPDFDictionary then F2 := TPDFDictionary(Obj);
    if (Assigned(F1) and Assigned(F2)) then
    begin
      for X := 0 to F2.Count - 1 do
        F1.Add(F2.Entry[X].Key.Name, FStructure.Decode(Process(F2.Entry[X].Value.Output)));
    end else
    if (not Assigned(F1) and Assigned(F2)) then
    begin
      Target.Add('Font', FStructure.Decode(Process(F2.Output)));
    end;
  end;

begin
  PageList := QPLParsePageRangeList(
    PageRanges,
    1, SourceDoc.PageCount,  // Valid page range
    False,  // Silently ignore invalid pages
    False,  // Silently ignore invalid characters
    False,  // Silently ignore duplicate pages
    AllowDuplicates,  // Allow/don't add duplicate pages to the returned page list
    SortList);  // Sort/don't sort the returned page list

  if (Length(PageList) > 0) then
  begin
    Result := True;
    StartIndex := FPageTree.PageCount;
    FPageTree.NewPages(FPageTree.PageCount + 1, Length(PageList), 612, 792);
    FPageTree.DeletePages(StartIndex, 1);

    ValidPages := '';
    for Page := 0 to Length(PageList) - 1 do
    begin
      ValidPages := ValidPages + '#' + QPLIntToStr(PageList[Page]) + '*';
    end;

    SetLength(NewIndObjList, 0);
    SetLength(InvalidPages, 0);
    for Page := 1 to SourceDoc.PageCount do
    begin
      if QPLPos('#' + QPLIntToStr(Page) + '*', ValidPages) > 0 then
      begin
        SetLength(NewIndObjList, Length(NewIndObjList) + 1);
        NewIndObjList[Length(NewIndObjList) - 1].NewObjNum := FPageTree.GetPage(Length(NewIndObjList) + StartIndex - 1).IndObjNum;
        NewIndObjList[Length(NewIndObjList) - 1].OldObjNum := SourceDoc.PageTree.GetPage(Page).IndObjNum;
      end else
      begin
        SetLength(InvalidPages, Length(InvalidPages) + 1);
        InvalidPages[Length(InvalidPages) - 1] :=
          SourceDoc.PageTree.GetPage(Page).IndObjNum;
      end;
    end;

    SourceStructure := SourceDoc.FStructure;

    for Page := 0 to Length(PageList) - 1 do
    begin
      SourceDict := SourceDoc.PageTree.GetPage(PageList[Page]);
      DestDict := FPageTree.GetPage(Page + StartIndex);

      Obj := GetInheritedObject(SourceDict, 'MediaBox');
      if Assigned(Obj) then
        SourceDict.Add('MediaBox', Obj)
      else
        SourceDict.Add('MediaBox', SourceStructure.Decode('[ 0 0 612 792 ]'));

      Obj := GetInheritedObject(SourceDict, 'CropBox');
      if Assigned(Obj) then
        SourceDict.Add('CropBox', Obj)
      else
      begin
        Obj := GetInheritedObject(SourceDict, 'MediaBox');
        SourceDict.Add('CropBox', Obj);
      end;

      Obj := GetInheritedObject(SourceDict, 'Rotate');
      if Assigned(Obj) then
        SourceDict.Add('Rotate', Obj)
      else
        SourceDict.Add('Rotate', SourceStructure.NewNumeric(0));

      Obj := GetInheritedObject(SourceDict, 'Resources');
      if Assigned(Obj) then
      begin
        SourceDict.Add('Resources', Obj);
      end else
      begin
        SourceDict.Add('Resources', SourceStructure.NewDictionary);
      end;

      OldParent := DestDict.FindValueByKeyName('Parent');
      CloneDict(SourceDict, DestDict);
      DestDict.Add('Parent', OldParent);
    end;

    if SourceDoc.HasFormData then
    begin
      if (not HasFormData) then
      begin
        NewAcroForm;
        HasFormData;
      end;

      if Assigned(AcroForm.FieldsArray) and
        Assigned(SourceDoc.AcroForm.FieldsArray) then
      begin
        for FieldIndex := 0 to SourceDoc.AcroForm.FieldsArray.Count - 1 do
        begin
          if (FindNewIndObj(TPDFIndRef(SourceDoc.AcroForm.FieldsArray.Item[FieldIndex]).ObjNum) > 0) then
          begin
            AcroForm.FieldsArray.Add(FStructure.NewIndirectRef(
              FindNewIndObj(TPDFIndRef(SourceDoc.AcroForm.FieldsArray.Item[FieldIndex]).ObjNum),
                TPDFIndRef(SourceDoc.AcroForm.FieldsArray.Item[FieldIndex]).GenNum));
          end;
        end;
      end;

      // Merge the Calculation Order array
      if Assigned(AcroForm.COArray) and
        Assigned(SourceDoc.AcroForm.COArray) then
      begin
        for FieldIndex := 0 to SourceDoc.AcroForm.COArray.Count - 1 do
        begin
          if (FindNewIndObj(TPDFIndRef(SourceDoc.AcroForm.COArray.Item[FieldIndex]).ObjNum) > 0) then
          begin
            AcroForm.COArray.Add(FStructure.NewIndirectRef(
              FindNewIndObj(TPDFIndRef(SourceDoc.AcroForm.COArray.Item[FieldIndex]).ObjNum),
                TPDFIndRef(SourceDoc.AcroForm.COArray.Item[FieldIndex]).GenNum));
          end;
        end;
      end;

      // Merge the DR dictionary (field resources), fonts
      if Assigned(AcroForm.DRDict) and
        Assigned(SourceDoc.AcroForm.DRDict) then
          MergeDicts(AcroForm.DRDict, SourceDoc.AcroForm.DRDict);

      ReloadFormData;
    end;
  end else
  begin
    Result := False;
  end;
end;

function TPDFDocument.CanDecrypt: Boolean;
begin
  Result := (GetEncrypted = peEncrypted) and (FIsUserPassword or FIsOwnerPassword);
end;

function TPDFDocument.CapturePage(Options: Integer): TPDFCapturedPage;
var
  I: TPDFIndRef;
  DS: TPDFDictionary;
  DD: TPDFStream;
  XObjectName: AnsiString;
  PC: TPDFCapturedPage;
  ObjNum: Integer;
  GenNum: Integer;
  Content: AnsiString;
  Obj: TPDFObject;
  Box: TPDFArray;
  Group: TPDFObject;
  Rectangle: TPDFRectangle;
  PageBox: AnsiString;
begin
  Inc(IndexCount);
  XObjectName := 'QuickPDFXO' + QPLRandomID;

  DS := FPageTree.GetPage(FPageTree.Page);
  FPageTree.CombineLayers;
  FPageTree.CloneResources(True);

  case Options of
    1: PageBox := 'CropBox';
    2: PageBox := 'BleedBox';
    3: PageBox := 'TrimBox';
    4: PageBox := 'ArtBox';
  else
    PageBox := 'MediaBox';
  end;

  Obj := DS.FindValueByKeyName(PageBox, True);

  if Obj is TPDFArray then Box := TPDFArray(Obj) else Box := nil;

  if Assigned(Box) then
    Rectangle := TPDFRectangle.Create(Box)
  else
    Rectangle := nil;

  Content := FPageTree.ExtractContent;
  FPageTree.SetContent('');
  DD := FStructure.NewStream(DeflateStr(Content));
  NewIndObj(Self, ObjNum, GenNum, DD);
  if Assigned(DS) and DD.IsIndirect and Assigned(Rectangle)
    and (Rectangle.IsRectangle) then
  begin
    DD.Dictionary.Add('Type', FStructure.NewName('XObject'));
    DD.Dictionary.Add('Subtype', FStructure.NewName('Form'));
    DD.Dictionary.Add('FormType', FStructure.NewNumeric(1));
    DD.Dictionary.Add('BBox', FStructure.Decode(Box.Output));
    Obj := DS.FindValueByKeyName('Resources');
    if not Assigned(Obj) then Obj := FStructure.Decode('<< /ProcSet [ /PDF /Text /ImageB /ImageC /ImageI ] >>');
    DD.Dictionary.Add('Resources', Obj);
    DD.Dictionary.Add('Filter', FStructure.Decode('[ /FlateDecode ]'));
    Group := DS.FindValueByKeyName('Group');
    if Assigned(Group) then
      DD.Dictionary.Add('Group', FStructure.Decode(Group.Output));
    I := FStructure.NewIndirectRef(ObjNum, GenNum);
    PC := TPDFCapturedPage.Create;
    PC.XObject := I;
    PC.XObjectName := XObjectName;
    CapturedPages.Add(PC);
    Result := PC;
    PC.OriginalWidth := Rectangle.Width;
    PC.OriginalHeight := Rectangle.Height;
    PC.XOffset := Rectangle.Left;
    PC.YOffset := Rectangle.Bottom;
  end else
    Result := nil;
  if Assigned(Rectangle) then Rectangle.Free;
end;

function TPDFDocument.HasCapturedPage(Capture: TPDFCapturedPage): Boolean;
begin
  Result := CapturedPages.IndexOf(Capture) >= 0;
end;

function TPDFDocument.GetCatalogInfo(const Key: AnsiString): WideString;
begin
  Result := QPLDecodeTextString(GetRawCatalogInfo(Key));
end;

function TPDFDocument.GetRawCatalogInfo(const Key: AnsiString): AnsiString;
var
  ID: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := '';
  ID := RootDict;
  Obj := ID.FindValueByKeyName(Key, True);
  if Obj is TPDFString then
    Result := TPDFString(Obj).AsString;
  if Obj is TPDFStream then
    Result := TPDFStream(Obj).GetDecodedStream;
end;

procedure TPDFDocument.SetCatalogInfo(const Key: AnsiString; const ValueW: WideString; Mode: TPDFStorageMode);
begin
  SetRawCatalogInfo(Key, QPLEncodeTextString(ValueW), Mode);
end;

procedure TPDFDocument.SetRawCatalogInfo(const Key, Value: AnsiString; Mode: TPDFStorageMode);
var
  ID: TPDFDictionary;
  Stream: TPDFStream;
  Obj: TPDFObject;
begin
  if (GetEncrypted = peDecrypted) then
  begin
    ID := RootDict;
    if Value <> '' then
    begin
      if Mode = smString then
      begin
        Obj := ID.FindValueByKeyName(Key, True);
        if Obj is TPDFStream then
        begin
          TPDFStream(Obj).SetTo('', False);
          ID.Add(Key, FStructure.NewString(Value));
        end else
        if Obj is TPDFString then
        begin
          TPDFString(Obj).SetTo(Value);
        end else
          ID.Add(Key, FStructure.NewString(Value));
      end;

      if (Mode = smStream) or (Mode = smCompressedStream) then
      begin
        Obj := ID.FindValueByKeyName(Key, True);
        if Obj is TPDFStream then
        begin
          TPDFStream(Obj).SetTo(Value, Mode = smCompressedStream);
        end else
        begin
          Stream := FStructure.NewStream('');
          Stream.SetTo(Value, Mode = smCompressedStream);
          ID.Add(Key, NewObjRef(Stream));
        end;
      end;
    end else
      ID.DeleteEntryByKeyName(Key);
  end;
end;

function TPDFDocument.SetOpenActionJavaScript(
  const JavaScript: WideString): Boolean;
var
  Root: TPDFDictionary;
  OpenAction: TPDFDictionary;
  JSStream: TPDFStream;
  JSRef: TPDFIndRef;
begin
  Result := False;
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Root.PurgeKey('OpenAction');
    OpenAction := FStructure.NewDictionary;
    Root.Add('OpenAction', OpenAction);
    OpenAction.Add('Type', FStructure.NewName('Action'));
    OpenAction.Add('S', FStructure.NewName('JavaScript'));
    if FJavaScriptMode = smString then
    begin
      OpenAction.Add('JS', FStructure.NewTextString(JavaScript))
    end else
    begin
      JSStream := FStructure.NewTextStream(JavaScript,
        FJavaScriptMode = smCompressedStream);
      JSRef := NewObjRef(JSStream);
      OpenAction.Add('JS', JSRef);
    end;
    Result := True;
  end;
end;

procedure TPDFDocument.FixPageResources;
var
  P: Integer;
begin
  for P := 1 to FPageTree.PageCount do
  begin
    FPageTree.Page := P;
    FPageTree.CloneResources;
  end;
end;

function TPDFDocument.DocJavaScriptAction(const ActionType: AnsiString;
  const JavaScript: WideString): Boolean;
var
  Root: TPDFDictionary;
  ActionDict: TPDFDictionary;
  JSStream: TPDFStream;
  JSRef: TPDFIndRef;
  Obj: TPDFObject;
  AADict: TPDFDictionary;
begin
  Result := False;
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('AA');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if not Assigned(Obj) then
    begin
      AADict := FStructure.NewDictionary;
      Root.Add('AA', AADict);
    end else
      AADict := TPDFDictionary(Obj);

    AADict.PurgeKey(ActionType);
    ActionDict := FStructure.NewDictionary;
    AADict.Add(ActionType, ActionDict);
    ActionDict.Add('Type', FStructure.NewName('Action'));
    ActionDict.Add('S', FStructure.NewName('JavaScript'));
    if FJavaScriptMode = smString then
    begin
      ActionDict.Add('JS', FStructure.NewTextString(JavaScript));
    end else
    begin
      JSStream := FStructure.NewTextStream(JavaScript,
        FJavaScriptMode = smCompressedStream);
      JSRef := NewObjRef(JSStream);
      ActionDict.Add('JS', JSRef);
    end;
    Result := True;
  end;
end;

procedure TPDFDocument.AddGlobalJavaScript(const PackageName,
  JavaScript: WideString);
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  NamesDict: TPDFDictionary;
  JSNameDict: TPDFDictionary;
  A: TPDFArray;
  NT: TPDFNameTree;
  JSRef: TPDFIndRef;
  JSDict: TPDFDictionary;
  JSStream: TPDFStream;
  PackageNameU: AnsiString;
begin
  PackageNameU := QPLEncodeTextString(PackageName);
  
  Root := GetRootDict;
  Obj := Root.FindValueByKeyName('Names');
  if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
  if Obj is TPDFDictionary then
  begin
    NamesDict := TPDFDictionary(Obj);
  end else
  begin
    NamesDict := FStructure.NewDictionary;
    Root.Add('Names', NamesDict);
  end;

  Obj := NamesDict.FindValueByKeyName('JavaScript');
  if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
  if Obj is TPDFDictionary then
  begin
    JSNameDict := TPDFDictionary(Obj);
  end else
  begin
    JSNameDict := FStructure.NewDictionary;
    NamesDict.Add('JavaScript', JSNameDict);
    A := FStructure.NewArray;
    JSNameDict.Add('Names', A);
  end;
  NT := TPDFNameTree.Create(FStructure, JSNameDict);
  try
    if NT.HasKey(PackageNameU) then
    begin
      JSRef := NT.FindKey(PackageNameU);
      Obj := JSRef.Obj;
      if Obj is TPDFDictionary then
      begin
        JSDict := TPDFDictionary(Obj);
        Obj := JSDict.FindValueByKeyName('JS');
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFString then
        begin
          TPDFString(Obj).SetToTextString(JavaScript);
        end;
        if Obj is TPDFStream then
        begin
          TPDFStream(Obj).SetToTextString(JavaScript,
            FJavaScriptMode = smCompressedStream);
        end;
      end;
    end else
    begin
      JSDict := FStructure.NewDictionary;
      JSDict.Add('S', FStructure.NewCommonName('JavaScript'));
      if FJavaScriptMode = smString then
      begin
        JSDict.Add('JS', FStructure.NewTextString(JavaScript));
      end else
      begin
        JSStream := FStructure.NewTextStream(JavaScript,
          FJavaScriptMode = smCompressedStream);
        JSDict.Add('JS', NewObjRef(JSStream));
      end;
      NT.AddKey(PackageNameU, NewObjRef(JSDict));
    end;
  finally
    NT.Free;
  end;
end;

function TPDFDocument.GetGlobalJavaScript(
  const PackageName: WideString): WideString;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  NamesDict: TPDFDictionary;
  JSNameDict: TPDFDictionary;
  NT: TPDFNameTree;
  JSRef: TPDFIndRef;
  JSDict: TPDFDictionary;
  PackageNameU: AnsiString;
begin
  Result := '';
  PackageNameU := QPLEncodeTextString(PackageName);
  Root := GetRootDict;
  Obj := Root.FindValueByKeyName('Names');
  if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
  if Obj is TPDFDictionary then
  begin
    NamesDict := TPDFDictionary(Obj);
    Obj := NamesDict.FindValueByKeyName('JavaScript');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
    begin
      JSNameDict := TPDFDictionary(Obj);
      NT := TPDFNameTree.Create(FStructure, JSNameDict);
      try
        if NT.HasKey(PackageNameU) then
        begin
          JSRef := NT.FindKey(PackageNameU);
          Obj := JSRef.Obj;
          if Obj is TPDFDictionary then
          begin
            JSDict := TPDFDictionary(Obj);
            Obj := JSDict.FindValueByKeyName('JS');
            if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
            if Obj is TPDFString then
              Result := TPDFString(Obj).AsTextString;
            if Obj is TPDFStream then
              Result := TPDFStream(Obj).GetDecodedTextStream;
          end;
        end;
      finally
        NT.Free;
      end;
    end;
  end;
end;

function TPDFDocument.GetDocJavaScript(const ActionType: AnsiString): WideString;
var
  Root: TPDFDictionary;
  ActionDict: TPDFDictionary;
  Obj: TPDFObject;
  AADict: TPDFDictionary;
begin
  Result := '';
  begin
    Root := GetRootDict;
    if Assigned(Root) then
    begin
      Obj := Root.FindValueByKeyName('AA');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if Obj is TPDFDictionary then
      begin
        AADict := TPDFDictionary(Obj);
        Obj := AADict.FindValueByKeyName(ActionType);
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFDictionary then
        begin
          ActionDict := TPDFDictionary(Obj);
          Obj := ActionDict.FindValueByKeyName('JS');
          if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFString then Result := TPDFString(Obj).AsTextString;
          if Obj is TPDFStream then Result := TPDFStream(Obj).GetDecodedTextStream;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.GetOpenActionJavaScript: WideString;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  OpenAction: TPDFDictionary;
begin
  Result := '';
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('OpenAction');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
    begin
      OpenAction := TPDFDictionary(Obj);
      Obj := OpenAction.FindValueByKeyName('JS');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if Obj is TPDFString then Result := TPDFString(Obj).AsTextString;
      if Obj is TPDFStream then Result := TPDFStream(Obj).GetDecodedTextStream;
    end;
  end;
end;

function TPDFDocument.PageRotation: Integer;
var
  Obj: TPDFObject;
  Dict: TPDFDictionary;
begin
  Result := 0;
  Dict := FPageTree.GetPage(FPageTree.Page);
  if Assigned(Dict) then
  begin
    Obj := GetPageInheritedValue(Dict, 'Rotate');
    if Obj is TPDFIndRef then
    begin
      Obj := TPDFIndRef(Obj).Obj;
    end;
    if Obj is TPDFNumeric then
    begin
      Result := TPDFNumeric(Obj).AsInteger;
    end;
  end;
end;

function TPDFDocument.FindFonts: Integer;
var
  X: Integer;
  Obj: TPDFObject;
  FontName: AnsiString;
  Dict: TPDFDictionary;
  Font: TPDFFont;
begin
  Result := 0;
  for X := 0 to FIndObjList.Count - 1 do
  begin
    Obj := TPDFIndObj(FIndObjList[X]).Obj;
    if Obj is TPDFDictionary then
    begin
      Dict := TPDFDictionary(Obj);
      if (Dict.DictType = 'Font') then
      begin
        if not FontExists(TPDFIndObj(FIndObjList[X]).ObjNum,
          TPDFIndObj(FIndObjList[X]).GenNum) then
        begin
          Inc(Result);
          Inc(IndexCount);
          FontName := 'QuickPDFF' + QPLRandomID;
          Font := TPDFFont.Create(FStructure, FontName);
          Font.PopulateFromIndRef(FStructure.NewIndirectRef(
            TPDFIndObj(FIndObjList[X]).ObjNum, TPDFIndObj(FIndObjList[X]).GenNum));
          if (Font.HasDescendantFont = False) then
          begin
            FFonts.Add(Font);
          end else
            Font.Free;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.NewImageDirectFromString(const Source: AnsiString; Width,
  Height, BitsPerComponent: Integer; const ColorSpace,
  Filter, Decode: WideString; Interpolate: Boolean): TPDFImage;
var
  Image: TPDFImage;
  ImageName: AnsiString;
begin
  Inc(IndexCount);
  ImageName := 'QuickPDFIm' + QPLRandomID;

  Image := TPDFImage.Create(FStructure, ImageName, FIncludedFonts);

  if Image.NewImageDirectFromString(Source, Width, Height, BitsPerComponent, ColorSpace, Filter, Decode, Interpolate) then
  begin
    FImages.Add(Image);
    Result := Image;
  end else
  begin
    Image.Free;
    Result := nil;
  end;
end;

function TPDFDocument.NewImageFromMetafile(InMetafile: TMetafile; Options,
  Compress: Integer): TPDFImage;
var
  Image: TPDFImage;
  ImageName: AnsiString;
  X: Integer;
begin
  Inc(IndexCount);
  ImageName := 'QuickPDFIm' + QPLRandomID;

  Image := TPDFImage.Create(FStructure, ImageName, FIncludedFonts);
  Image.Compress := Compress;
  Image.CompressFonts := FCompressFonts = 1;

  if (FUseExistingFonts = 1) then
  begin
    for X := 0 to FLastImageFontList.Count - 1 do
    begin
      IncludedFonts.Add(FLastImageFontList[X]);
    end;
  end;

  for X := 0 to Length(FNoEmbedFontList) - 1 do
  begin
    Image.NoEmbedFontList := Image.NoEmbedFontList + '<QPLNoEmbedFont>' +
      FNoEmbedFontList[X] + '</QPLNoEmbedFont>';
  end;

  if Options = -1 then
  begin
    Image.GDIPlusSettings := ImageGDIPlusSettings;
  end;

  if Image.NewImageFromMetafile(InMetafile, Options, (Compress = 2)) then
  begin
    FImages.Add(Image);
    Result := Image;

    FLastImageFontList.Clear;
    for X := 0 to FIncludedFonts.Count - 1 do
    begin
      if (FFonts.IndexOf(FIncludedFonts[X]) < 0) then
      begin
        FFonts.Add(FIncludedFonts[X]);
      end;
      FLastImageFontList.Add(FIncludedFonts[X]);
    end;

  end else
  begin
    Image.Free;
    Result := nil;
  end;
end;

function TPDFDocument.NewImageFromStream(InStream: TStream; Options,
  Compress: Integer): TPDFImage;
var
  Image: TPDFImage;
  ImageName: AnsiString;
  X: Integer;
begin
  Inc(IndexCount);
  ImageName := 'QuickPDFIm' + QPLRandomID;

  Image := TPDFImage.Create(FStructure, ImageName, FIncludedFonts);
  Image.Compress := Compress;
  Image.CompressFonts := FCompressFonts = 1;

  if (Options = 2) then
    Image.RecompressImage := True;

  if (FUseExistingFonts = 1) then
  begin
    for X := 0 to FLastImageFontList.Count - 1 do
    begin
      IncludedFonts.Add(FLastImageFontList[X]);
    end;
  end;

  for X := 0 to Length(FNoEmbedFontList) - 1 do
  begin
    Image.NoEmbedFontList := Image.NoEmbedFontList + '<QPLNoEmbedFont>' +
      FNoEmbedFontList[X] + '</QPLNoEmbedFont>';
  end;

  if Options = -1 then
  begin
    Image.GDIPlusSettings := ImageGDIPlusSettings;
  end;

  if Image.NewImageFromStream(InStream, Options) then
  begin
    FImages.Add(Image);
    Result := Image;

    FLastImageFontList.Clear;
    for X := 0 to FIncludedFonts.Count - 1 do
    begin
      if (FFonts.IndexOf(IncludedFonts[X]) < 0) then
      begin
        FFonts.Add(IncludedFonts[X]);
      end;
      FLastImageFontList.Add(IncludedFonts[X]);
    end;

  end else
  begin
    Image.Free;
    Result := nil;
  end;
end;

function TPDFDocument.TempFileName: WideString;
begin
  Result := FTempFileName;
end;

procedure TPDFDocument.UnlinkOutlineFromPageList(OutlineRef: TPDFIndRef;
  DeletedPageRefs: array of TPDFIndRef);
var
  OutlineDict: TPDFDictionary;
  Obj: TPDFObject;
  Dest: TPDFArray;
  PageRef: TPDFIndRef;
  OutlineActionDict: TPDFDictionary;

  function InPageList: Boolean;
  var
    X: Integer;
  begin
    Result := False;
    X := 0;
    while (X < Length(DeletedPageRefs)) and (not Result) do
    begin
      if (DeletedPageRefs[X].ObjNum = PageRef.ObjNum) then
      begin
        if (DeletedPageRefs[X].GenNum = PageRef.GenNum) then
        begin
          Result := True;
        end;
      end;
      Inc(X);
    end;
  end;

begin
  if (Assigned(OutlineRef)) then
  begin
    Obj := OutlineRef.Obj;
    if (Obj is TPDFDictionary) then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('Dest', True);
      if Assigned(Obj) then
      begin
        if Obj is TPDFArray then
        begin
          Dest := TPDFArray(Obj);
          if Dest.Count >= 1 then
          begin
            Obj := Dest.Item[0];
            if Obj is TPDFIndRef then
            begin
              PageRef := TPDFIndRef(Obj);
              if (InPageList) then
              begin
                OutlineDict.PurgeKey('Dest');
              end;
            end;
          end;
        end;
      end else
      begin
        Obj := OutlineDict.FindValueByKeyName('A', True);
        if Obj is TPDFDictionary then
        begin
          OutlineActionDict := TPDFDictionary(Obj);
          Obj := OutlineActionDict.FindValueByKeyName('S');
          if (Obj is TPDFName) and (TPDFName(Obj).Name = 'GoTo') then
          begin
            Obj := OutlineActionDict.FindValueByKeyName('D', True);

            if Obj is TPDFArray then
            begin
              Dest := TPDFArray(Obj);
              if Dest.Count >= 1 then
              begin
                Obj := Dest.Item[0];
                if Obj is TPDFIndRef then
                begin
                  PageRef := TPDFIndRef(Obj);
                  if (InPageList) then
                  begin
                    OutlineDict.PurgeKey('A');
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.GetOutlineDictionary: TPDFIndRef;
var
  Obj: TPDFObject;
  OutlineDictionary: TPDFDictionary;
  OutlineDictType: AnsiString;
begin
  Result := nil;

  Obj := RootDict.FindValueByKeyName('Outlines');
  if Obj is TPDFIndRef then
  begin
    Result := TPDFIndRef(Obj);
    Obj := Result.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDictionary := TPDFDictionary(Obj);
      OutlineDictType := OutlineDictionary.DictType;
      if (OutlineDictType = 'Outline') then
      begin
        Obj := OutlineDictionary.FindValueByKeyName('Type');
        if (Obj is TPDFName) then
        begin
          TPDFName(Obj).SetTo('Outlines');
        end;
        OutlineDictType := 'Outlines';
      end;
      if (OutlineDictType <> '') then
      begin
        if (OutlineDictType <> 'Outlines') then
        begin
          Result := nil;
        end;
      end;
    end;
  end;

  if not Assigned(Result) then
  begin
    OutlineDictionary := FStructure.NewDictionary;
    Result := NewObjRef(OutlineDictionary);
    RootDict.Add('Outlines', Result);
  end;
end;

function TPDFDocument.OutlineCount: Integer;
var
  Ref: TPDFIndRef;

  function Count(Ref: TPDFIndRef): Integer;
  var
    D: TPDFDictionary;
    O: TPDFObject;
    R: TPDFIndRef;
  begin
    Result := 1;
    O := Ref.Obj;
    if O is TPDFDictionary then
    begin
      D := TPDFDictionary(O);
      O := D.FindValueByKeyName('First');
      if O is TPDFIndRef then
      begin
        R := TPDFIndRef(O);
        Result := Result + Count(R);
      end;
      O := D.FindValueByKeyName('Next');
      if O is TPDFIndRef then
      begin
        R := TPDFIndRef(O);
        Result := Result + Count(R);
      end;
    end;
  end;

begin
  Result := 0;
  Ref := GetOutlineDictionary;
  if Assigned(Ref) then Result := Count(Ref) - 1;
end;

function TPDFDocument.GetOutlineFromIndex(Index: Integer): TPDFIndRef;
var
  Ref: TPDFIndRef;
  Start: Integer;

  function Find(Ref: TPDFIndRef; var This: Integer; Match: Integer): TPDFIndRef;
  var
    D: TPDFDictionary;
    O: TPDFObject;
    R: TPDFIndRef;
  begin
    Result := nil;
    This := This + 1;
    if This = Match then Result := Ref;
    O := Ref.Obj;
    if (O is TPDFDictionary) and (not Assigned(Result)) then
    begin
      D := TPDFDictionary(O);
      O := D.FindValueByKeyName('First');
      if O is TPDFIndRef then
      begin
        R := TPDFIndRef(O);
        R := Find(R, This, Match);
        if Assigned(R) then Result := R;
      end;
      O := D.FindValueByKeyName('Next');
      if O is TPDFIndRef then
      begin
        R := TPDFIndRef(O);
        R := Find(R, This, Match);
        if Assigned(R) then Result := R;
      end;
    end;
  end;

begin
  Result := nil;
  Ref := GetOutlineDictionary;
  Start := -1;
  if ((Index > 0) and Assigned(Ref)) then
  begin
    Result := Find(Ref, Start, Index);
  end;
end;

function TPDFDocument.OutlineTitle(OutlineRef: TPDFIndRef): WideString;
var
  OutlineDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := '';
  Obj := OutlineRef.Obj;
  if Obj is TPDFDictionary then
  begin
    OutlineDict := TPDFDictionary(Obj);
    Obj := OutlineDict.FindValueByKeyName('Title');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFString then
    begin
      Result := TPDFString(Obj).AsTextString;
    end;
  end;
end;

procedure TPDFDocument.SetOutlineColor(OutlineRef: TPDFIndRef;
  Red, Green, Blue: Double);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  ColorArray: TPDFArray;
begin
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      OutlineDict.PurgeKey('C');
      ColorArray := FStructure.NewArray([
        FStructure.NewNumeric(Red),
        FStructure.NewNumeric(Green),
        FStructure.NewNumeric(Blue)
      ]);
      OutlineDict.Add('C', ColorArray);
    end;
  end;
end;

procedure TPDFDocument.SetOutlineStyle(OutlineRef: TPDFIndRef; Italic,
  Bold: Boolean);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  F: Integer;
begin
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      OutlineDict.PurgeKey('F');
      F := 0;
      if Italic then F := F + 1;
      if Bold then F := F + 2;
      OutlineDict.Add('F', FStructure.NewNumeric(F));
    end;
  end;
end;

procedure TPDFDocument.SetOutlineDest(OutlineRef: TPDFIndRef;
  DestPage: Integer; DestPosition: Double; Zoom: Integer);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  Dest: TPDFArray;
  PageDict: TPDFDictionary;
begin
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      OutlineDict.PurgeKey('Dest');
      
      PageDict := FPageTree.GetPage(DestPage);
      Dest := FStructure.NewArray;
      Dest.Add(FStructure.NewIndirectRef(PageDict.IndObjNum,
        PageDict.IndGenNum));

      if (Zoom = -1) then
      begin
        Dest.Add(FStructure.NewName('Fit'));
      end;
      if (Zoom = -2) then
      begin
        Dest.Add(FStructure.NewName('FitH'));
        Dest.Add(FStructure.NewNumeric(DestPosition));
      end;
      if (Zoom >= 0) and (Zoom <= 1600) then
      begin
        Dest.Add(FStructure.NewName('XYZ'));
        Dest.Add(FStructure.NewNumeric(0));
        Dest.Add(FStructure.NewNumeric(DestPosition));
        Dest.Add(FStructure.NewNumeric(Zoom / 100));
      end;

      OutlineDict.Add('Dest', Dest);
      OutlineDict.PurgeKey('A');
    end;
  end;
end;

procedure TPDFDocument.SetOutlineTitle(OutlineRef: TPDFIndRef;
  const NewTitle: WideString);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
begin
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      OutlineDict.PurgeKey('Title');
      OutlineDict.Add('Title', FStructure.NewTextString(NewTitle));
    end;
  end;
end;

function TPDFDocument.RemoveOpenAction: Boolean;
var
  Root: TPDFDictionary;
begin
  Result := False;
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Root.PurgeKey('OpenAction');
    Result := True;
  end;
end;

function TPDFDocument.RemoveOutline(OutlineRef: TPDFIndRef): Boolean;
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  NextRef: TPDFIndRef;
  PrevRef: TPDFIndRef;
  ParentRef: TPDFIndRef;
  FirstRef: TPDFIndRef;
  LastRef: TPDFIndRef;
  ParentDict: TPDFDictionary;

  procedure DecCount(ParentRef: TPDFIndRef; DC: Integer);
  var
    C: Integer;
    O: TPDFObject;
    D: TPDFDictionary;
  begin
    if Assigned(ParentRef) and (ParentRef is TPDFIndRef) then
    begin
      O := ParentRef.Obj;
      if O is TPDFDictionary then
      begin
        D := TPDFDictionary(O);
        O := D.FindValueByKeyName('Count');
        if Assigned(O) and (O is TPDFNumeric) then
          C := TPDFNumeric(O).AsInteger
        else
          C := 0;
        if C < 0 then Inc(C, DC) else Dec(C, DC);
        D.Add('Count', FStructure.NewNumeric(C));
        O := D.FindValueByKeyName('Parent');
        if O is TPDFIndRef then DecCount(TPDFIndRef(O), DC);
      end;
    end;
  end;
  
begin
  Result := False;
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('Next');
      if Obj is TPDFIndRef then NextRef := TPDFIndRef(Obj)
        else NextRef := nil;
      Obj := OutlineDict.FindValueByKeyName('Prev');
      if Obj is TPDFIndRef then PrevRef := TPDFIndRef(Obj)
        else PrevRef := nil;
      Obj := OutlineDict.FindValueByKeyName('Parent');
      if Obj is TPDFIndRef then ParentRef := TPDFIndRef(Obj)
        else ParentRef := nil;

      OutlineDict.PurgeKey('Next');
      OutlineDict.PurgeKey('Prev');
      OutlineDict.PurgeKey('Parent');
      OutlineDict.PurgeKey('First');
      OutlineDict.PurgeKey('Last');

      FirstRef := nil;
      LastRef := nil;
      if Assigned(ParentRef) then
      begin
        Obj := ParentRef.Obj;
        if Obj is TPDFDictionary then
        begin
          ParentDict := TPDFDictionary(Obj);
          Obj := ParentDict.FindValueByKeyName('First');
          if Obj is TPDFIndRef then FirstRef := TPDFIndRef(Obj);
          Obj := ParentDict.FindValueByKeyName('Last');
          if Obj is TPDFIndRef then LastRef := TPDFIndRef(Obj);
        end;
      end;

      if Assigned(NextRef) then
        SetRef(NextRef, 'Prev', PrevRef);
      if Assigned(PrevRef) then
        SetRef(PrevRef, 'Next', NextRef);

      if Assigned(ParentRef) then
      begin
        if (Assigned(LastRef)) then
        begin
          if LastRef.Output = OutlineRef.Output then
            SetRef(ParentRef, 'Last', PrevRef);
        end;
        if (Assigned(FirstRef)) then
        begin
          if FirstRef.Output = OutlineRef.Output then
            SetRef(ParentRef, 'First', NextRef);
        end;
        Obj := OutlineDict.FindValueByKeyName('Count', True);
        if Obj is TPDFNumeric then
          DecCount(ParentRef, TPDFNumeric(Obj).AsInteger + 1)
        else
          DecCount(ParentRef, 1);        
      end;

      Result := True;
    end;
  end;
end;

procedure TPDFDocument.SetRef(Ref: TPDFIndRef; Key: AnsiString; NewValue: TPDFIndRef);
var
  O: TPDFObject;
  D: TPDFDictionary;
begin
  O := Ref.Obj;
  if O is TPDFDictionary then
  begin
    D := TPDFDictionary(O);
    D.PurgeKey(Key);
    if Assigned(NewValue) then
      D.Add(Key, NewValue);
  end;
end;

procedure TPDFDocument.CloseOutline(OutlineRef: TPDFIndRef);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  Count: Integer;
begin
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('Count');
      if Obj is TPDFNumeric then
      begin
        Count := TPDFNumeric(Obj).AsInteger;
        if Count > 0 then
          TPDFNumeric(Obj).SetTo(-Count);
      end;
    end;
  end;
end;

procedure TPDFDocument.OpenOutline(OutlineRef: TPDFIndRef);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  Count: Integer;
begin
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('Count');
      if Obj is TPDFNumeric then
      begin
        Count := TPDFNumeric(Obj).AsInteger;
        if Count < 0 then
          TPDFNumeric(Obj).SetTo(-Count);
      end;
    end;
  end;
end;

function TPDFDocument.NewStaticOutline(ParentRef: TPDFIndRef; const Title: WideString): TPDFIndRef;
var
  Obj: TPDFObject;
  ParentDict: TPDFDictionary;
  LastRef: TPDFIndRef;
  NewRef: TPDFIndRef;
  NewDict: TPDFDictionary;

  procedure IncCount(ParentRef: TPDFIndRef);
  var
    C: Integer;
    O: TPDFObject;
    D: TPDFDictionary;
  begin
    if Assigned(ParentRef) and (ParentRef is TPDFIndRef) then
    begin
      O := ParentRef.Obj;
      if O is TPDFDictionary then
      begin
        D := TPDFDictionary(O);
        O := D.FindValueByKeyName('Count');
        if Assigned(O) and (O is TPDFNumeric) then
          C := TPDFNumeric(O).AsInteger
        else
          C := 0;
        if C < 0 then Dec(C) else Inc(C);
        D.PurgeKey('Count');
        D.Add('Count', FStructure.NewNumeric(C));
        O := D.FindValueByKeyName('Parent');
        if O is TPDFIndRef then IncCount(TPDFIndRef(O));
      end;
    end;
  end;

begin
  NewRef := nil;
  if (not Assigned(ParentRef)) or (not (ParentRef is TPDFIndRef)) then
    ParentRef := GetOutlineDictionary;
  if ParentRef is TPDFIndRef then
  begin
    Obj := ParentRef.Obj;
    if Obj is TPDFDictionary then
    begin
      NewDict := FStructure.NewDictionary;
      NewDict.Add('Title', FStructure.NewTextString(Title));
      NewDict.Add('Parent', ParentRef);
      NewRef := NewObjRef(NewDict);
      ParentDict := TPDFDictionary(Obj);
      Obj := ParentDict.FindValueByKeyName('Last');
      if (Obj is TPDFIndRef) then
      begin
        LastRef := TPDFIndRef(Obj);
        NewDict.Add('Prev', LastRef);
        SetRef(LastRef, 'Next', NewRef);
        ParentDict.Add('Last', NewRef);
      end else
      begin
        ParentDict.Add('First', NewRef);
        ParentDict.Add('Last', NewRef);
      end;
      IncCount(ParentRef);
    end;
  end;
  Result := NewRef;
end;

function TPDFDocument.FirstOutline: TPDFIndRef;
var
  Ref: TPDFIndRef;
  Obj: TPDFObject;
  Dict: TPDFDictionary;
begin
  Result := nil;
  Ref := GetOutlineDictionary;
  Obj := Ref.Obj;
  if Obj is TPDFDictionary then
  begin
    Dict := TPDFDictionary(Obj);
    Obj := Dict.FindValueByKeyName('First');
    if (Obj is TPDFIndRef) then
    begin
      Result := TPDFIndRef(Obj);
    end;
  end;
end;

function TPDFDocument.FirstChildOutline(OutlineRef: TPDFIndRef): TPDFIndRef;
var
  Obj: TPDFObject;
  Dict: TPDFDictionary;
begin
  Result := nil;
  Obj := OutlineRef.Obj;
  if (Obj is TPDFDictionary) then
  begin
    Dict := TPDFDictionary(Obj);
    Obj := Dict.FindValueByKeyName('First');
    if (Obj is TPDFIndRef) then
    begin
      Result := TPDFIndRef(Obj);
    end;
  end;
end;

function TPDFDocument.NextOutline(OutlineRef: TPDFIndRef): TPDFIndRef;
var
  Obj: TPDFObject;
  Dict: TPDFDictionary;
begin
  Result := nil;
  Obj := OutlineRef.Obj;
  if (Obj is TPDFDictionary) then
  begin
    Dict := TPDFDictionary(Obj);
    Obj := Dict.FindValueByKeyName('Next');
    if (Obj is TPDFIndRef) then
    begin
      Result := TPDFIndRef(Obj);
    end;
  end;
end;

function TPDFDocument.ParentOutline(OutlineRef: TPDFIndRef): TPDFIndRef;
var
  Obj: TPDFObject;
  Dict: TPDFDictionary;
begin
  Result := nil;
  Obj := OutlineRef.Obj;
  if (Obj is TPDFDictionary) then
  begin
    Dict := TPDFDictionary(Obj);
    Obj := Dict.FindValueByKeyName('Parent');
    if Obj is TPDFIndRef then
    begin
      Result := TPDFIndRef(Obj);
      Obj := Result.Obj;
      if (Obj is TPDFDictionary) then
      begin
        if (not (TPDFDictionary(Obj).FindValueByKeyName('Parent') is TPDFIndRef)) then
        begin
          Result := nil;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.PrevOutline(OutlineRef: TPDFIndRef): TPDFIndRef;
var
  Obj: TPDFObject;
  Dict: TPDFDictionary;
begin
  Result := nil;
  Obj := OutlineRef.Obj;
  if (Obj is TPDFDictionary) then
  begin
    Dict := TPDFDictionary(Obj);
    Obj := Dict.FindValueByKeyName('Prev');
    if (Obj is TPDFIndRef) then
    begin
      Result := TPDFIndRef(Obj);
    end;
  end;
end;

procedure TPDFDocument.SetOutlineJS(OutlineRef: TPDFIndRef;
  const JavaScript: WideString);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  JSStream: TPDFStream;
  JSRef: TPDFIndRef;
  ActionRef: TPDFIndRef;
begin
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      OutlineDict.PurgeKey('Dest');
      Obj := OutlineDict.FindValueByKeyName('A', True);
      if Obj is TPDFDictionary then
      begin
        ActionDict := TPDFDictionary(Obj);
        Obj := ActionDict.FindValueByKeyName('JS', True);
        if Obj is TPDFStream then
        begin
          TPDFStream(Obj).SetToTextString(JavaScript,
            FJavaScriptMode = smCompressedStream);
        end else
        if Obj is TPDFString then
        begin
          TPDFString(Obj).SetToTextString(JavaScript);
        end else
        begin
          if FJavaScriptMode = smString then
          begin
            ActionDict.Add('JS', FStructure.NewTextString(JavaScript));
          end else
          begin
            JSStream := FStructure.NewTextStream(JavaScript,
              FJavaScriptMode = smCompressedStream);
            JSRef := NewObjRef(JSStream);
            ActionDict.Add('JS', JSRef);
          end;
        end;
      end else
      begin
        ActionDict := FStructure.NewDictionary;
        ActionRef := NewObjRef(ActionDict);
        OutlineDict.Add('A', ActionRef);
        ActionDict.Add('Type', FStructure.NewName('Action'));
        ActionDict.Add('S', FStructure.NewName('JavaScript'));
        if FJavaScriptMode = smString then
        begin
          ActionDict.Add('JS', FStructure.NewTextString(JavaScript));
        end else
        begin
          JSStream := FStructure.NewTextStream(JavaScript,
            FJavaScriptMode = smCompressedStream);
          JSRef := NewObjRef(JSStream);
          ActionDict.Add('JS', JSRef);
        end;
      end;
    end;
  end;
end;

procedure TPDFDocument.SetOutlineWebLink(OutlineRef: TPDFIndRef;
  const Link: AnsiString);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
begin
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      OutlineDict.PurgeKey('Dest');
      OutlineDict.PurgeKey('A');
      ActionDict := FStructure.NewDictionary;
      ActionDict.Add('Type', FStructure.NewName('Action'));
      ActionDict.Add('S', FStructure.NewName('URI'));
      ActionDict.Add('URI', FStructure.NewString(Link));
      OutlineDict.Add('A', ActionDict)
    end;
  end;
end;

function TPDFDocument.GetOutlinePage(OutlineRef: TPDFIndRef): Integer;
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  OutlineActionDict: TPDFDictionary;
  Dest: TPDFArray;
  PageRef: TPDFIndRef;
  DD: TPDFDictionary;
begin
  Result := 0;
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('Dest', True);
      if Assigned(Obj) then
      begin
        if Obj is TPDFArray then
        begin
          Dest := TPDFArray(Obj);
          if Dest.Count >= 1 then
          begin
            Obj := Dest.Item[0];
            if Obj is TPDFIndRef then
            begin
              PageRef := TPDFIndRef(Obj);
              Result := GetPageFromRef(PageRef) + 1;
            end;

            // Work around buggy PDFs created with
            // older versions of iSEDQuickPDF (prior to 3.78)
            if Obj is TPDFNumeric then
            begin
              Result := TPDFNumeric(Obj).AsInteger + 1;
              DD := FPageTree.GetPage(Result);
              if Assigned(DD) and DD.IsIndirect then
                Dest.Replace(0, FStructure.NewIndirectRef(DD.IndObjNum, DD.IndGenNum));
            end;
          end;
        end;
      end else
      begin
        Obj := OutlineDict.FindValueByKeyName('A', True);
        if Obj is TPDFDictionary then
        begin
          OutlineActionDict := TPDFDictionary(Obj);
          Obj := OutlineActionDict.FindValueByKeyName('S');
          if (Obj is TPDFName) and (TPDFName(Obj).Name = 'GoTo') then
          begin
            Obj := OutlineActionDict.FindValueByKeyName('D', True);

            if Obj is TPDFArray then
            begin
              Dest := TPDFArray(Obj);
              if Dest.Count >= 1 then
              begin
                Obj := Dest.Item[0];
                if Obj is TPDFIndRef then
                begin
                  PageRef := TPDFIndRef(Obj);
                  Result := GetPageFromRef(PageRef) + 1;
                end;
              end;
            end;

          end;
        end;
      end;
    end;
  end;
end;

procedure TPDFDocument.SetUseUnsafeLayers(NewValue: Boolean);
begin
  FUseUnsafeLayers := NewValue;
  FPageTree.UseUnsafeLayers := NewValue;
end;

function TPDFDocument.GetOutlineDest(
  OutlineRef: TPDFIndRef): TPDFObject;
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
begin
  Result := nil;
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('Dest', True);
      if Assigned(Obj) then
      begin
        Result := Obj;
      end;
    end;
  end;
end;

function TPDFDocument.GetPageFromRef(Ref: TPDFIndRef): Integer;
var
  O: TPDFObject;
  D: TPDFDictionary;
  P: TPDFDictionary;
  PRef: TPDFIndRef;
  Kids: TPDFArray;
  KRef: TPDFIndRef;
  K: TPDFDictionary;
  X: Integer;
  Match: AnsiString;
begin
  Result := 0;
  Match := Ref.Output;
  O := Ref.Obj;
  if O is TPDFDictionary then
  begin
    D := TPDFDictionary(O);
    O := D.FindValueByKeyName('Parent');
    if O is TPDFIndRef then
    begin
      PRef := TPDFIndRef(O);
      O := PRef.Obj;
      if O is TPDFDictionary then
      begin
        P := TPDFDictionary(O);
        O := P.FindValueByKeyName('Kids', True);
        if O is TPDFArray then
        begin
          Kids := TPDFArray(O);
          X := 0;
          while X < Kids.Count do
          begin
            O := Kids.Item[X];
            if O is TPDFIndRef then
            begin
              KRef := TPDFIndRef(O);
              if KRef.Output <> Match then
              begin
                O := KRef.Obj;
                if O is TPDFDictionary then
                begin
                  K := TPDFDictionary(O);
                  if K.DictType = 'Pages' then
                  begin
                    O := K.FindValueByKeyName('Count', True);
                    if O is TPDFNumeric then
                      Result := Result + TPDFNumeric(O).AsInteger;
                  end;
                  if K.DictType = 'Page' then
                    Result := Result + 1;
                end;
              end else
              begin
                X := Kids.Count;
              end;
            end;
            X := X + 1;
          end;
          Result := Result + GetPageFromRef(PRef);
        end;
      end;
    end;
  end;
end;

procedure TPDFDocument.ResetForm;
begin
  FormSearched := False;
  HasFormData;
end;

function TPDFDocument.GetPageLayout: TPDFPageLayout;
var
  Root: TPDFDictionary;
  Obj: TPDFObject;
begin
  Root := GetRootDict;
  Result := plNone;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('PageLayout');
    if Obj is TPDFName then
    begin
      if TPDFName(Obj).Name = 'SinglePage' then Result := plSinglePage;
      if TPDFName(Obj).Name = 'OneColumn' then Result := plOneColumn;
      if TPDFName(Obj).Name = 'TwoColumnLeft' then Result := plTwoColumnLeft;
      if TPDFName(Obj).Name = 'TwoColumnRight' then Result := plTwoColumnRight;
      if TPDFName(Obj).Name = 'TwoPageLeft' then Result := plTwoPageLeft;
      if TPDFName(Obj).Name = 'TwoPageRight' then Result := plTwoPageRight;
    end;
  end;
end;

function TPDFDocument.GetPageMode: TPDFPageMode;
var
  Root: TPDFDictionary;
  Obj: TPDFObject;
begin
  Root := GetRootDict;
  Result := pmUseNone;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('PageMode');
    if Obj is TPDFName then
    begin
      if TPDFName(Obj).Name = 'UseNone' then Result := pmUseNone;
      if TPDFName(Obj).Name = 'UseOutlines' then Result := pmUseOutlines;
      if TPDFName(Obj).Name = 'UseThumbs' then Result := pmUseThumbs;
      if TPDFName(Obj).Name = 'FullScreen' then Result := pmFullScreen;
      if TPDFName(Obj).Name = 'UseOC' then Result := pmUseOC;
      if TPDFName(Obj).Name = 'UseAttachments' then Result := pmUseAttachments;
    end;
  end;
end;

function TPDFDocument.GetPagesRef: TPDFIndRef;
var
  Obj: TPDFObject;
begin
  Result := nil;
  Obj := RootDict.FindValueByKeyName('Pages');
  if Obj is TPDFIndRef then
    Result := TPDFIndRef(Obj);
end;

function TPDFDocument.GetPrintOCGList: TQPLOCGStateList;
var
  SX: Integer;
begin
  SetLength(Result, OCGCount);
  for SX := 0 to OCGCount - 1 do
  begin
    Result[SX].OCGIndRef := OCGRef(SX + 1);
    Result[SX].Show := GetOCGPrintable(Result[SX].OCGIndRef);
  end;
end;

function TPDFDocument.IndObjects: AnsiString;
var
  X: Integer;
begin
  Result := '';
  for X := 0 to FIndObjList.Count - 1 do
  begin
    Result := Result + QPLIntToStr(TPDFIndObj(FIndObjList.Items[X]).ObjNum) + ' ' +
      QPLIntToStr(TPDFIndObj(FIndObjList.Items[X]).GenNum) + ' obj'#13#10;
  end;
end;

function TPDFDocument.IndObjSummary: WideString;
var
  X: Integer;
  IndObj: TPDFIndObj;

  function Prep(const A: AnsiString): WideString;
  begin
    Result := WideString(A);
    Delete(Result, 1, Pos(WideString('obj'), Result) + 3);
    Result := StringReplace(Result, #10, ' ', [rfReplaceAll]);
    if (Pos(#0, Result) > 0) then
    begin
      Delete(Result, Pos(#0, Result), Maxint);
    end;
    if (Length(Result) > 80) then
    begin
      SetLength(Result, 80);
    end;
  end;

begin
  Result := '';
  for X := 0 to FIndObjList.Count - 1 do
  begin
    IndObj := TPDFIndObj(FIndObjList[X]);
    Result := Result + IntToStr(IndObj.FObjNum) + ' ';
    if IndObj.Decoded then
    begin
      Result := Result + 'Decoded ';
    end else
    begin
      Result := Result + '------- ';
    end;
    if IndObj.Decrypted then
    begin
      Result := Result + 'Decrypted ';
    end else
    begin
      Result := Result + '--------  ';
    end;
    if IndObj.Recoded then
    begin
      Result := Result + 'Recoded ';
    end else
    begin
      Result := Result + '------- ';
    end;
    if ((IndObj.Decoded) or (IndObj.Recoded)) then
    begin
      Result := Result + Prep(IndObj.Output);
    end;
    Result := Result + #13#10;
  end;
end;

function TPDFDocument.NewSubsettedFont(const FontName: AnsiString;
  Charset: Integer; const SubsetChars: WideString): TPDFFont;
var
  Font: TPDFFont;
  FN: AnsiString;
begin
  Inc(IndexCount);
  FN := 'QuickPDFF' + QPLRandomID;

  Font := TPDFFont.Create(FStructure, FN);
  Font.Compress := FCompressFonts = 1;
  if Font.NewSubsettedFont(FontName, CharSet, SubsetChars) then
  begin
    FFonts.Add(Font);
    Result := Font;
  end else
  begin
    Font.Free;
    Result := nil;
  end;
end;

function TPDFDocument.NewSubsettedTrueTypeFont(const FontName,
  SubsetChars: WideString; Options: Integer): TPDFFont;
var
  Font: TPDFFont;
  FN: AnsiString;
begin
  Inc(IndexCount);
  FN := 'QuickPDFF' + QPLRandomID;

  Font := TPDFFont.Create(FStructure, FN);
  Font.Compress := FCompressFonts = 1;
  if Font.NewSubsettedTrueTypeFont(AnsiString(FontName), SubsetChars, Options, False, 0, True) then
  begin
    FFonts.Add(Font);
    Result := Font;
  end else
  begin
    Font.Free;
    Result := nil;
  end;
end;

function TPDFDocument.GetNameTree(const Category: AnsiString): TPDFDictionary;
var
  Dict: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := nil;
  Dict := GetRootDict;
  if Assigned(Dict) then
  begin
    Obj := Dict.FindValueByKeyName('Names', True);
    if Assigned(Obj) and (Obj is TPDFDictionary) then
    begin
      Dict := TPDFDictionary(Obj);
      Obj := Dict.FindValueByKeyName(Category, True);
      if Assigned(Obj) and (Obj is TPDFDictionary) then
        Result := TPDFDictionary(Obj);
    end;
  end;
end;

procedure TPDFDocument.CheckObjects;
var
  X: Integer;
begin
  for X := 0 to FIndObjList.Count - 1 do
  begin
    if not TPDFIndObj(FIndObjList[X]).Decoded then
    begin
      TPDFIndObj(FIndObjList[X]).Obj;
    end;
  end;
end;

function TPDFDocument.GetOpenActionDestination: TPDFArray;
var
  Obj: TPDFObject;
  DictType: AnsiString;
  Root: TPDFDictionary;
  OpenAction: TPDFDictionary;
begin
  Result := nil;
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('OpenAction', True);
    if Obj is TPDFDictionary then
    begin
      OpenAction := TPDFDictionary(Obj);
      DictType := OpenAction.DictType;
      if (DictType = 'Action') or (DictType = '') then
      begin
        Obj := OpenAction.FindValueByKeyName('S', True);
        if (Obj is TPDFName) and (TPDFName(Obj).Name = 'GoTo') then
        begin
          Obj := OpenAction.FindValueByKeyName('D', True);
          if Obj is TPDFArray then
            Result := TPDFArray(Obj);
        end;
      end;
    end
    else if Obj is TPDFArray then
      Result := TPDFArray(Obj);
  end;
end;

function TPDFDocument.AppendToFile(const FileName: WideString): Boolean;
var
  FS: TQuickPDFWideFileStream;
begin
  try
    FS := QPLCreateFileStream(FileName, fmOpenReadWrite or fmShareDenyWrite);
    try
      FS.Seek(FS.Size, soBeginning);
      Result := SaveToStream(FS, True);
    finally
      FS.Free;
    end;
  except
    Result := False;
  end;
end;

function TPDFDocument.AppendToString(AppendMode: Integer;
  const InputString: AnsiString): AnsiString;
var
  MS: TMemoryStream;
begin
  Result := '';
  try
    MS := TMemoryStream.Create;
    try
      if (AppendMode = 0) then
      begin
        if (FSource <> '') then
        begin
          MS.Write(FSource[1], Length(FSource));
          SaveToStream(MS, True);
          SetLength(Result, MS.Size);
          MS.Seek(0, soFromBeginning);
          MS.Read(Result[1], Length(Result));
        end;
      end else
      if (AppendMode = 1) then
      begin
        if (FSource <> '') then
        begin
          MS.Write(FSource[1], Length(FSource));
          SaveToStream(MS, True);
          SetLength(Result, MS.Size - Length(FSource));
          MS.Seek(Length(FSource), soFromBeginning);
          MS.Read(Result[1], Length(Result));
        end;
      end else
      if (AppendMode = 2) then
      begin
        if (Length(InputString) > 0) then
        begin
          MS.Write(InputString[1], Length(InputString));
        end;
        SaveToStream(MS, True);
        SetLength(Result, MS.Size);
        MS.Seek(0, soFromBeginning);
        MS.Read(Result[1], Length(Result));
      end;
    finally
      MS.Free;
    end;
  except
  end;
end;

function TPDFDocument.ApplyStyle(const Style: AnsiString): Boolean;
var
  I: Integer;
begin
  Result := False;
  I := FindStyle(Style);
  if I >= 0 then
  begin
    Result := True;
    FPageTree.UseFont(FStyles[I].Font);
    FPageTree.Painter.SelectFont(FStyles[I].Font, FStyles[I].FontSize);
    FPageTree.Painter.SetTextColor(FStyles[I].FontColor);
    FPageTree.Painter.TextAlign := FStyles[I].TextAlign;
    FPageTree.Painter.SetTextScaling(FStyles[I].TextScaling);
    FPageTree.Painter.SetTextCharSpacing(FStyles[I].TextCharSpacing);
    FPageTree.Painter.SetTextWordSpacing(FStyles[I].TextWordSpacing);
    FPageTree.Painter.SetTextSpacing(FStyles[I].TextSpacing);
    FPageTree.Painter.TextHighlight := FStyles[I].TextHighlight;
    FPageTree.Painter.TextUnderline := FStyles[I].TextUnderline;
    FPageTree.Painter.SetHighlightColor(FStyles[I].TextHighlightColor);
    FPageTree.Painter.SetUnderlineColor(FStyles[I].TextUnderlineColor);
    FPageTree.Painter.SetUnderlineDash(FStyles[I].TextUnderlineDashOn,
      FStyles[I].TextUnderlineDashOff);
    FPageTree.Painter.SetTextMode(FStyles[I].TextMode);
    if (FStyles[I].TextMode = 1) or (FStyles[I].TextMode = 2) or (FStyles[I].TextMode = 5) or (FStyles[I].TextMode = 6) then
    begin
      FPageTree.Painter.SetLineColor(FStyles[I].LineColor);
      FPageTree.Painter.SetLineWidth(FStyles[I].LineWidth);
      FPageTree.Painter.SetLineDash(FStyles[I].LineDash);
    end;
    FPageTree.Painter.SetTextRise(FStyles[I].TextRise);
    FPageTree.Painter.SetUnderlineWidth(FStyles[I].UnderlineWidth);
    FPageTree.Painter.SetUnderlineDistance(FStyles[I].UnderlineDistance);
    FPageTree.Painter.UseKerning := FStyles[I].UseKerning;
    FPageTree.Painter.SetUnderlineCustomDashFull(FStyles[I].UnderlineCustomDash);
  end;
end;

function TPDFDocument.RemoveStyle(const Style: AnsiString): Boolean;
var
  I: Integer;
begin
  Result := False;
  I := FindStyle(Style);
  if I >= 0 then
  begin
    Result := True;
    for I := I to Length(FStyles) - 2 do
      FStyles[I] := FStyles[I + 1];
    SetLength(FStyles, Length(FStyles) - 1);
  end;
end;

function TPDFDocument.RemoveUsageRights: Boolean;
var
  Obj: TPDFObject;
  PermsDict: TPDFDictionary;
begin
  Result := False;
  Obj := RootDict.FindValueByKeyName('Perms', True);
  if Obj is TPDFDictionary then
  begin
    Result := True;
    PermsDict := TPDFDictionary(Obj);

    PermsDict.DeleteEntryByKeyName('UR');
    PermsDict.DeleteEntryByKeyName('UR3');

    if PermsDict.Count = 0 then
    begin
      RootDict.DeleteEntryByKeyName('Perms');
    end;
  end;
end;

procedure TPDFDocument.SaveStyle(const Style: AnsiString);
var
  I: Integer;
begin
  I := FindStyle(Style);
  if I < 0 then
  begin
    SetLength(FStyles, Length(FStyles) + 1);
    I := Length(FStyles) - 1;
  end;
  FStyles[I].StyleName := Style;
  FStyles[I].Font := FPageTree.Painter.SelFont;
  FStyles[I].FontSize := FPageTree.Painter.TextSize;
  FStyles[I].FontColor := FPageTree.Painter.TextColor;
  FStyles[I].TextAlign := FPageTree.Painter.TextAlign;
  FStyles[I].TextScaling := FPageTree.Painter.TextScaling;
  FStyles[I].TextCharSpacing := FPageTree.Painter.TextCharSpacing;
  FStyles[I].TextWordSpacing := FPageTree.Painter.TextWordSpacing;
  FStyles[I].TextSpacing := FPageTree.Painter.TextSpacing;
  FStyles[I].TextHighlight := FPageTree.Painter.TextHighlight;
  FStyles[I].TextUnderline := FPageTree.Painter.TextUnderline;
  FStyles[I].TextHighlightColor := FPageTree.Painter.HighlightColor;
  FStyles[I].TextUnderlineColor := FPageTree.Painter.UnderlineColor;
  FStyles[I].TextUnderlineDashOn := FPageTree.Painter.TextUnderlineDashOn;
  FStyles[I].TextUnderlineDashOff := FPageTree.Painter.TextUnderlineDashOff;
  FStyles[I].TextMode := FPageTree.Painter.GetTextMode;
  FStyles[I].LineColor := FPageTree.Painter.LineColor;
  FStyles[I].LineWidth := FPageTree.Painter.GetLineWidth;
  FStyles[I].LineDash := FPageTree.Painter.LineDash;
  FStyles[I].TextRise := FPageTree.Painter.TextRise;
  FStyles[I].UnderlineWidth := FPageTree.Painter.UnderlineWidth;
  FStyles[I].UnderlineDistance := FPageTree.Painter.UnderlineDistance;
  FStyles[I].UseKerning := FPageTree.Painter.UseKerning;
  FStyles[I].UnderlineCustomDash := FPageTree.Painter.TextUnderlineCustomDash;
end;

function TPDFDocument.FindStyle(const Style: AnsiString): Integer;
var
  X: Integer;
begin
  X := 0;
  Result := -1;
  while (X < Length(FStyles)) and (Result < 0) do
  begin
    if FStyles[X].StyleName = Style then
      Result := X
    else
      Inc(X);
  end;
end;

function TPDFDocument.GlobalJavaScriptCount: Integer;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  NamesDict: TPDFDictionary;
  JSNameDict: TPDFDictionary;
  NT: TPDFNameTree;
begin
  Result := 0;
  Root := GetRootDict;
  Obj := Root.FindValueByKeyName('Names');
  if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
  if Obj is TPDFDictionary then
  begin
    NamesDict := TPDFDictionary(Obj);
    Obj := NamesDict.FindValueByKeyName('JavaScript');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
    begin
      JSNameDict := TPDFDictionary(Obj);
      NT := TPDFNameTree.Create(FStructure, JSNameDict);
      try
        Result := NT.KeyCount;
      finally
        NT.Free;
      end;
    end;
  end;
end;

function TPDFDocument.GlobalJavaScriptPackageName(Index: Integer): WideString;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  NamesDict: TPDFDictionary;
  JSNameDict: TPDFDictionary;
  NT: TPDFNameTree;
begin
  Result := '';
  Root := GetRootDict;
  Obj := Root.FindValueByKeyName('Names');
  if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
  if Obj is TPDFDictionary then
  begin
    NamesDict := TPDFDictionary(Obj);
    Obj := NamesDict.FindValueByKeyName('JavaScript');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
    begin
      JSNameDict := TPDFDictionary(Obj);
      NT := TPDFNameTree.Create(FStructure, JSNameDict);
      try
        Result := QPLDecodeTextString(NT.KeyName(Index));
      finally
        NT.Free;
      end;
    end;
  end;
end;

procedure TPDFDocument.SetOutlineOpenFile(OutlineRef: TPDFIndRef;
  const FileName: AnsiString);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  ActionRef: TPDFIndRef;
  FileSpec: AnsiString;
begin
  if (QPLPos(':', FileName) > 0) or (QPLPos('\', FileName) > 0) then
  begin
    FileSpec := QPLStringReplace(FileName, '/', #255, [rfReplaceAll]);
    FileSpec := QPLStringReplace(FileSpec, '\', '/', [rfReplaceAll]);
    FileSpec := QPLStringReplace(FileSpec, #255, '\/', [rfReplaceAll]);
    if QPLCopy(FileSpec, 2, 1) = ':' then
    begin
      FileSpec := '/' + QPLCopy(FileSpec, 1, 1) + '/' + QPLCopy(FileSpec, 3, MaxInt);
      if QPLCopy(FileSpec, 3, 2) = '//' then Delete(FileSpec, 3, 1);
    end;
  end else
    FileSpec := FileName;
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      OutlineDict.PurgeKey('Dest');

      Obj := OutlineDict.FindValueByKeyName('A', True);
      if Obj is TPDFDictionary then
        ActionDict := TPDFDictionary(Obj)
      else
      begin
        ActionDict := FStructure.NewDictionary;
        ActionRef := NewObjRef(ActionDict);
        OutlineDict.Add('A', ActionRef);
      end;
      ActionDict.Add('Type', FStructure.NewName('Action'));
      ActionDict.Add('S', FStructure.NewName('Launch'));
      ActionDict.Add('F', FStructure.NewString(FileSpec));
    end;
  end;
end;

function TPDFDocument.MoveOutline(OutlineRef,
  SiblingRef: TPDFIndRef; Before: Boolean): Boolean;
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  NextRef: TPDFIndRef;
  PrevRef: TPDFIndRef;
  ParentRef: TPDFIndRef;
  FirstRef: TPDFIndRef;
  LastRef: TPDFIndRef;
  ParentDict: TPDFDictionary;
  SiblingDict: TPDFDictionary;

  procedure DecCount(ParentRef: TPDFIndRef; DC: Integer);
  var
    C: Integer;
    O: TPDFObject;
    D: TPDFDictionary;
  begin
    if Assigned(ParentRef) and (ParentRef is TPDFIndRef) then
    begin
      O := ParentRef.Obj;
      if O is TPDFDictionary then
      begin
        D := TPDFDictionary(O);
        O := D.FindValueByKeyName('Count');
        if Assigned(O) and (O is TPDFNumeric) then
          C := TPDFNumeric(O).AsInteger
        else
          C := 0;
        if C < 0 then Inc(C, DC) else Dec(C, DC);
        D.Add('Count', FStructure.NewNumeric(C));
        O := D.FindValueByKeyName('Parent');
        if O is TPDFIndRef then DecCount(TPDFIndRef(O), DC);
      end;
    end;
  end;

  procedure IncCount(ParentRef: TPDFIndRef; IC: Integer);
  var
    C: Integer;
    O: TPDFObject;
    D: TPDFDictionary;
  begin
    if Assigned(ParentRef) and (ParentRef is TPDFIndRef) then
    begin
      O := ParentRef.Obj;
      if O is TPDFDictionary then
      begin
        D := TPDFDictionary(O);
        O := D.FindValueByKeyName('Count');
        if Assigned(O) and (O is TPDFNumeric) then
          C := TPDFNumeric(O).AsInteger
        else
          C := 0;
        if C < 0 then Dec(C, IC) else Inc(C, IC);
        D.Add('Count', FStructure.NewNumeric(C));
        O := D.FindValueByKeyName('Parent');
        if O is TPDFIndRef then IncCount(TPDFIndRef(O), IC);
      end;
    end;
  end;
  
begin
  Result := False;
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);

      // Next sibling
      Obj := OutlineDict.FindValueByKeyName('Next');
      if Obj is TPDFIndRef then NextRef := TPDFIndRef(Obj)
        else NextRef := nil;

      // Previous sibling
      Obj := OutlineDict.FindValueByKeyName('Prev');
      if Obj is TPDFIndRef then PrevRef := TPDFIndRef(Obj)
        else PrevRef := nil;

      // Parent
      Obj := OutlineDict.FindValueByKeyName('Parent');
      if Obj is TPDFIndRef then ParentRef := TPDFIndRef(Obj)
        else ParentRef := nil;

      OutlineDict.PurgeKey('Next');
      OutlineDict.PurgeKey('Prev');
      OutlineDict.PurgeKey('Parent');

      // Get the parent's first and last items
      FirstRef := nil;
      LastRef := nil;
      if Assigned(ParentRef) then
      begin
        Obj := ParentRef.Obj;
        if Obj is TPDFDictionary then
        begin
          ParentDict := TPDFDictionary(Obj);
          Obj := ParentDict.FindValueByKeyName('First');
          if Obj is TPDFIndRef then FirstRef := TPDFIndRef(Obj);
          Obj := ParentDict.FindValueByKeyName('Last');
          if Obj is TPDFIndRef then LastRef := TPDFIndRef(Obj);
        end;
      end;

      // If the original position had siblings before or
      // after then join them together to close the space
      if Assigned(NextRef) then
        SetRef(NextRef, 'Prev', PrevRef);
      if Assigned(PrevRef) then
        SetRef(PrevRef, 'Next', NextRef);

      // If this node was the parent's first or last entry then
      // update them to the previous sibling of this node
      if Assigned(ParentRef) then
      begin
        if LastRef.Output = OutlineRef.Output then
          SetRef(ParentRef, 'Last', PrevRef);
        if FirstRef.Output = OutlineRef.Output then
          SetRef(ParentRef, 'First', NextRef);
        Obj := OutlineDict.FindValueByKeyName('Count', True);
        if Obj is TPDFNumeric then
          DecCount(ParentRef, TPDFNumeric(Obj).AsInteger + 1)
        else
          DecCount(ParentRef, 1);
      end;

      if SiblingRef is TPDFIndRef then
      begin
        Obj := SiblingRef.Obj;
        if Obj is TPDFDictionary then
        begin
          SiblingDict := TPDFDictionary(Obj);
          Obj := SiblingDict.FindValueByKeyName('Next');
          if Obj is TPDFIndRef then NextRef := TPDFIndRef(Obj)
            else NextRef := nil;
          Obj := SiblingDict.FindValueByKeyName('Prev');
          if Obj is TPDFIndRef then PrevRef := TPDFIndRef(Obj)
            else PrevRef := nil;
          Obj := SiblingDict.FindValueByKeyName('Parent');
          if Obj is TPDFIndRef then ParentRef := TPDFIndRef(Obj)
            else ParentRef := nil;

          FirstRef := nil;
          LastRef := nil;
          if Assigned(ParentRef) then
          begin
            Obj := ParentRef.Obj;
            if Obj is TPDFDictionary then
            begin
              ParentDict := TPDFDictionary(Obj);
              Obj := ParentDict.FindValueByKeyName('First');
              if Obj is TPDFIndRef then FirstRef := TPDFIndRef(Obj);
              Obj := ParentDict.FindValueByKeyName('Last');
              if Obj is TPDFIndRef then LastRef := TPDFIndRef(Obj);
            end;
          end;

          if Before then
          begin
            if Assigned(PrevRef) then
            begin
              SetRef(PrevRef, 'Next', OutlineRef);
              SetRef(OutlineRef, 'Prev', PrevRef);
            end;
            SetRef(SiblingRef, 'Prev', OutlineRef);
            SetRef(OutlineRef, 'Next', SiblingRef);
          end else
          begin
            if Assigned(NextRef) then
            begin
              SetRef(NextRef, 'Prev', OutlineRef);
              SetRef(OutlineRef, 'Next', NextRef);
            end;
            SetRef(SiblingRef, 'Next', OutlineRef);
            SetRef(OutlineRef, 'Prev', SiblingRef);
          end;

          if Assigned(ParentRef) then
          begin
            if Before then
            begin
              if FirstRef.Output = SiblingRef.Output then
                SetRef(ParentRef, 'First', OutlineRef);
            end else
            begin
              if LastRef.Output = SiblingRef.Output then
                SetRef(ParentRef, 'Last', OutlineRef);
            end;
            Obj := OutlineDict.FindValueByKeyName('Count', True);
            if Obj is TPDFNumeric then
              IncCount(ParentRef, TPDFNumeric(Obj).AsInteger + 1)
            else
              IncCount(ParentRef, 1);
            OutlineDict.Add('Parent', ParentRef);
          end;

          Result := True;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.GetColorSpace(Dict: TPDFDictionary;
  const Key: AnsiString): AnsiString;
var
  Obj: TPDFObject;
  CSA: TPDFArray;
  CSN: AnsiString;
  ICC: TPDFStream;
begin
  Result := '';
  Obj := Dict.FindValueByKeyName(Key, True);
  if Obj is TPDFName then
  begin
    Result := TPDFName(Obj).Name;
  end else
  if (Obj is TPDFArray) and (TPDFArray(Obj).Count > 0) then
  begin
    CSA := TPDFArray(Obj);
    Obj := CSA.Item[0];
    if Obj is TPDFName then
    begin
      CSN := TPDFName(Obj).Name;
      if (CSN = 'ICCBased') and (CSA.Count > 1) then
      begin
        Obj := CSA.Item[1];
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFStream then
        begin
          ICC := TPDFStream(Obj);
          Obj := ICC.Dictionary.FindValueByKeyName('Alternate', True);
          if Obj is TPDFName then
            Result := TPDFName(Obj).Name;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.AddSeparationColor(const ColorName: AnsiString; C, M, Y,
  K: Double): Boolean;
var
  X: Integer;
  I: Integer;
  CS: TPDFArray;
  TD: TPDFDictionary;
begin
  I := -1;
  for X := 0 to Length(FSeparationColors) - 1 do
  begin
    if FSeparationColors[X].ColorName = ColorName then
      I := X;
  end;
  if I < 0 then
  begin
    I := Length(FSeparationColors);
    SetLength(FSeparationColors, I + 1);
    FSeparationColors[I].ColorName := ColorName;
    Inc(IndexCount);    
    FSeparationColors[I].CSName := 'QuickPDFCS' + QPLRandomID;
    TD := FStructure.NewDictionary;
    TD.Add('FunctionType', FStructure.NewNumeric(2));
    TD.Add('Domain', FStructure.NewDoubleArray([0, 1]));
    TD.Add('Range', FStructure.NewDoubleArray([0, 1, 0, 1, 0, 1, 0, 1]));
    TD.Add('N', FStructure.NewNumeric(1));
    TD.Add('C0', FStructure.NewDoubleArray([0, 0, 0, 0]));
    TD.Add('C1', FStructure.NewDoubleArray([C, M, Y, K]));
    CS := FStructure.NewArray;
    CS.Add(FStructure.NewName('Separation'));
    CS.Add(FStructure.NewName(ColorName));
    CS.Add(FStructure.NewName('DeviceCMYK'));
    CS.Add(NewObjRef(TD));
    FSeparationColors[I].CS := NewObjRef(CS);
    Result := True;
  end else
    Result := False;
end;

function TPDFDocument.FindSeparation(
  const ColorName: AnsiString): TPDFSeparationColor;
var
  X: Integer;
  I: Integer;
begin
  I := -1;
  for X := 0 to Length(FSeparationColors) - 1 do
  begin
    if FSeparationColors[X].ColorName = ColorName then
      I := X;
  end;
  if I >= 0 then
  begin
    Result := FSeparationColors[I];
  end else
    Result.ColorName := '';
end;

function TPDFDocument.EncryptionFingerprint: AnsiString;
var
  S: AnsiString;
  X: Integer;
  ID: AnsiString;
begin
  if not (FEncryption.Extracted) then ExtractEncryption;
  if (FEncryption.DictionaryPresent) then
  begin
    ID := GetID.Output;
    S := 'QuickPDFFingerprint' + QPLIntToHex(Length(FEncryption.O), 8) + FEncryption.O +
      QPLIntToHex(Length(FEncryption.U), 8) + FEncryption.U +
      QPLIntToHex(FEncryption.Length, 8) + QPLIntToHex(Integer(FEncryption.P), 8) +
      QPLIntToHex(FEncryption.V, 8) + QPLIntToHex(FEncryption.R, 8) +
      QPLIntToHex(Length(ID), 8) + ID +
      QPLIntToHex(Length(EncryptionKey), 8) + EncryptionKey +
      QPLIntToHex(Ord(FEncryption.Algorithm), 8) +
      QPLIntToHex(Length(FEncryption.UE), 8) + FEncryption.UE +
      QPLIntToHex(Length(FEncryption.OE), 8) + FEncryption.OE +
      QPLIntToHex(Length(FEncryption.Perms), 8) + FEncryption.Perms;
    S := ARC4Encrypt('QuickPDFEncFP', S);
    Result := '';
    for X := 1 to Length(S) do
      Result := Result + QPLIntToHex(Ord(S[X]), 2);
  end else
    Result := '';
end;

function TPDFDocument.EncryptWithFingerprint(
  const Fingerprint: AnsiString): Boolean;
var
  S1: AnsiString;
  S2: AnsiString;
  X: Integer;
  E: TPDFEncryption;
  ID: AnsiString;
  IDS: TPDFString;
  IDA: TPDFArray;

  function PopInt: Integer;
  var
    N: AnsiString;
  begin
    N := QPLCopy(S1, 1, 8);
    Delete(S1, 1, 8);
    Result := QPLStrToIntDef('$' + N, 0);
  end;

  function PopString: AnsiString;
  var
    L: Integer;
  begin
    L := PopInt;
    Result := QPLCopy(S1, 1, L);
    Delete(S1, 1, L);
  end;

const
  H: AnsiString = '0123456789ABCDEF';
begin
  Result := False;
  S1 := QPLUpperCase(Fingerprint);
  S2 := '';
  for X := 1 to Length(S1) do
    if QPLPos(S1[X], H) > 0 then S2 := S2 + S1[X];
  S1 := '';
  for X := 1 to Length(S2) div 2 do
    S1 := S1 + AnsiChar(QPLStrToIntDef('$' + QPLCopy(S2, X * 2 - 1, 2), 0));
  S1 := ARC4Encrypt('QuickPDFEncFP', S1);
  if QPLCopy(S1, 1, 19) = 'QuickPDFFingerprint' then
  begin
    Delete(S1, 1, 19);
    E.O := PopString;
    E.U := PopString;
    E.Length := PopInt;
    E.P := Cardinal(PopInt);
    E.V := PopInt;
    E.R := PopInt;
    ID := PopString;
    EncryptionKey := PopString;
    FTrailer.Add('ID', FStructure.Decode(ID));

    //PopString; // EncrptionKey

    E.Algorithm := TPDFEncryptionAlgorithm(PopInt);

    E.UE := PopString;
    E.OE := PopString;
    E.Perms := PopString;

    IDS := FStructure.NewString(MD5DigestToString(MD5String(
      QPLFloatToStr(Now))), smHex);
    IDA := GetID;
    if IDA.Count = 2 then
    begin
      IDA.Delete(1);
      IDA.Add(IDS);
    end;

    EncryptFromRec(E);
    Result := True;
  end;
end;

procedure TPDFDocument.EncryptFromRec(E: TPDFEncryption);
var
  ED: TPDFDictionary;
  CFDict: TPDFDictionary;
  StdCFDict: TPDFDictionary;
  EncRef: TPDFIndRef;
begin
  E.Extracted := True;
  E.DictionaryPresent := True;
  FEncryption := E;

  FUserPassword := FEncryption.O;
  FOwnerPassword := FEncryption.U;
  OwnerKey := FEncryption.O;
  UserKey := FEncryption.U;
  DecodePermKey(FEncryption.P);

  if FEncryption.Length = 40 then
    FEncryptionStrength := esStd
  else
    FEncryptionStrength := es128Bit;
  if (E.Algorithm = eaAES128) and ((E.V = 4) and (E.R = 4)) then
    FEncryptionStrength := esAES128Bit;
  if (E.Algorithm = eaAES256) then
  begin
    if (E.R = 5) then
    begin
      FEncryptionStrength := esAES256Bit;
    end else
    if (E.R = 6) then
    begin
      FEncryptionStrength := esAES256BitAcroX;
    end;
  end;

  IndObjEncKey := EncryptionKey;
  EncryptContent(False);

  FTrailer.PurgeKey('Encrypt');
  ED := FStructure.NewDictionary;
  ED.Add('Filter', FStructure.NewName('Standard'));
  ED.Add('V', FStructure.NewNumeric(E.V));
  ED.Add('R', FStructure.NewNumeric(E.R));
  ED.Add('Length', FStructure.NewNumeric(E.Length));
  ED.Add('O', FStructure.NewString(OwnerKey, smHex));
  ED.Add('U', FStructure.NewString(UserKey, smHex));
  ED.Add('P', FStructure.NewNumeric(Integer(E.P)));
  if FEncryptionStrength = esAES128Bit then
  begin
    ED.Add('StrF', FStructure.NewCommonName('StdCF'));
    ED.Add('StmF', FStructure.NewCommonName('StdCF'));
    StdCFDict := FStructure.NewDictionary;
    StdCFDict.Add('AuthEvent', FStructure.NewCommonName('DocOpen'));
    StdCFDict.Add('Length', FStructure.NewNumeric(16));
    StdCFDict.Add('CFM', FStructure.NewCommonName('AESV2'));
    CFDict := FStructure.NewDictionary;
    CFDict.Add('StdCF', StdCFDict);
    ED.Add('CF', CFDict);
  end else
  if ((FEncryptionStrength = esAES256Bit) or (FEncryptionStrength = esAES256BitAcroX)) then
  begin
    ED.Add('StrF', FStructure.NewCommonName('StdCF'));
    ED.Add('StmF', FStructure.NewCommonName('StdCF'));
    StdCFDict := FStructure.NewDictionary;
    StdCFDict.Add('AuthEvent', FStructure.NewCommonName('DocOpen'));
    StdCFDict.Add('Length', FStructure.NewNumeric(32));
    StdCFDict.Add('CFM', FStructure.NewCommonName('AESV3'));
    CFDict := FStructure.NewDictionary;
    CFDict.Add('StdCF', StdCFDict);
    ED.Add('CF', CFDict);
    ED.Add('OE', FStructure.NewString(E.OE, smHex));
    ED.Add('UE', FStructure.NewString(E.OE, smHex));
    ED.Add('Perms', FStructure.NewString(E.Perms, smHex));
  end else
  if FEncryptionStrength = es128Bit then
  begin
    ED.Add('StrF', FStructure.NewCommonName('StdCF'));
    ED.Add('StmF', FStructure.NewCommonName('StdCF'));
    StdCFDict := FStructure.NewDictionary;
    StdCFDict.Add('AuthEvent', FStructure.NewCommonName('DocOpen'));
    StdCFDict.Add('Length', FStructure.NewNumeric(16));
    StdCFDict.Add('CFM', FStructure.NewCommonName('V2'));
    CFDict := FStructure.NewDictionary;
    CFDict.Add('StdCF', StdCFDict);
    ED.Add('CF', CFDict);
  end;
  EncRef := NewObjRef(ED);
  FTrailer.Add('Encrypt', EncRef);
  FEncryption.Extracted := False;
  FEncryption.DictionaryObjNum := EncRef.ObjNum;
end;

procedure TPDFDocument.ClearPageLabels;
begin
  RootDict.PurgeKey('PageLabels');
end;

procedure TPDFDocument.AddPageLabelEntry(Start: Integer; const Style: AnsiString;
  Offset: Integer; const Prefix: WideString);
var
  PL: TPDFDictionary;
  Obj: TPDFObject;
  Root: TPDFDictionary;
  V: TPDFDictionary;
begin
  Root := RootDict;
  Obj := Root.FindValueByKeyName('PageLabels', True);
  if not (Obj is TPDFDictionary) then
  begin
    Obj := FStructure.NewDictionary;
    Root.Add('PageLabels', NewObjRef(Obj));
  end;
  if Obj is TPDFDictionary then
  begin
    PL := TPDFDictionary(Obj);
    V := FStructure.NewDictionary;
    if Style <> '' then
      V.Add('S', FStructure.NewName(Style));
    if Prefix <> '' then
    begin
      V.Add('P', FStructure.NewTextString(Prefix));
    end;
    if Offset > 0 then
      V.Add('St', FStructure.NewNumeric(Offset));
    NumTreeSet(PL, Start - 1, V);
  end;
end;

function TPDFDocument.GetPageLabel(Page: Integer): WideString;
var
  Obj: TPDFObject;
  List: TPDFNumTreeList;
  Root: TPDFDictionary;
  X: Integer;
  V: TPDFObject;
  D: TPDFDictionary;
  S: AnsiString;
  P: WideString;
  St: Integer;
  O: Integer;

  function Alpha(X: Integer): AnsiString;
  var
    C: Integer;
    A: AnsiString;
    AX: Integer;
  begin
    Result := '';
    C := (X - 1) div 26 + 1;
    A := AnsiChar((X - 1) mod 26 + 65);
    for AX := 1 to C do
      Result := Result + A;
  end;

  function Roman(X: Integer): AnsiString;
  var
    Val: array[1..5] of Integer;
    XS: AnsiString;
    MC: Integer;

    procedure Parse(Prec, Center, Follow: AnsiString; Num: Integer);
    begin
      case Num of
        1: Result := Result + Prec;
        2: Result := Result + Prec + Prec;
        3: Result := Result + Prec + Prec + Prec;
        4: Result := Result + Prec + Center;
        5: Result := Result + Center;
        6: Result := Result + Center + Prec;
        7: Result := Result + Center + Prec + Prec;
        8: Result := Result + Center + Prec + Prec + Prec;
        9: Result := Result + Prec + Follow;
      end;
    end;

  begin
    Result := '';
    XS := QPLIntToStr(X);
    while Length(XS) < 5 do XS := '0' + XS;
    Val[5] := Ord(XS[1]) - 48;
    Val[4] := Ord(XS[2]) - 48;
    Val[3] := Ord(XS[3]) - 48;
    Val[2] := Ord(XS[4]) - 48;
    Val[1] := Ord(XS[5]) - 48;
    MC := Val[5] * 10 + Val[4];
    while MC > 0 do
    begin
      Result := Result + 'M';
      Dec(MC);
    end;
    Parse('C', 'D', 'M', Val[3]);
    Parse('X', 'L', 'C', Val[2]);
    Parse('I', 'V', 'X', Val[1]);
  end;

begin
  Result := WideString(QPLIntToStr(Page));
  Root := RootDict;
  Obj := Root.FindValueByKeyName('PageLabels', True);
  if Obj is TPDFDictionary then
  begin
    Result := '';
    SetLength(List, 0);
    EnumNumTree(TPDFDictionary(Obj), List);
    for X := 0 to Length(List) - 1 do
    begin
      if (Page - 1) >= List[X].Num then
      begin
        V := List[X].Obj;
        if V is TPDFIndRef then V := TPDFIndRef(V).Obj;
        if V is TPDFDictionary then
        begin
          S := '';        
          P := '';
          St := 1;
          D := TPDFDictionary(V);
          Obj := D.FindValueByKeyName('S');
          if Obj is TPDFName then
            S := TPDFName(Obj).Name;
          Obj := D.FindValueByKeyName('P');
          if Obj is TPDFString then
            P := TPDFString(Obj).AsTextString;
          Obj := D.FindValueByKeyName('St');
          if Obj is TPDFNumeric then
            St := TPDFNumeric(Obj).AsInteger;
          O := (Page - 1) - List[X].Num;
          if S = '' then Result := P;
          if S = 'D' then Result := P + WideString(QPLIntToStr(O + St));
          if S = 'R' then Result := P + WideString(QPLUpperCase(Roman(O + St)));
          if S = 'r' then Result := P + WideString(QPLLowerCase(Roman(O + St)));
          if S = 'A' then Result := P + WideString(QPLUpperCase(Alpha(O + St)));
          if S = 'a' then Result := P + WideString(QPLLowerCase(Alpha(O + St)));
        end;
      end;
    end;
  end;
end;

function TPDFDocument.GetObjectDecodeError(ObjNum: Integer): Boolean;
var
  IndObj: TPDFIndObj;
begin
  Result := False;
  IndObj := FindObj(ObjNum, 0);
  if (Assigned(IndObj)) then
  begin
    if (not IndObj.Decoded) then
    begin
      IndObj.Decode;
    end;
    if (IndObj.DecodeError) then
    begin
      Result := True;
    end;
  end;
end;

function TPDFDocument.GetObjectSource(ObjNum: Integer): AnsiString;
var
  IndObj: TPDFIndObj;
  O: TPDFObject;
begin
  IndObj := FindObj(ObjNum, 0);
  if (Assigned(IndObj)) then
  begin
    O := IndObj.Obj;
    if Assigned(O) then
    begin
      Result := O.Output;
    end else
    begin
      Result := '';
    end;
  end;
end;

function TPDFDocument.NewStream(const D, S: AnsiString): Integer;
var
  O, G: Integer;
  St: TPDFStream;
  Obj: TPDFObject;
begin
  St := FStructure.NewStream(S);
  Obj := FStructure.Decode(D);
  if Obj is TPDFDictionary then
    St.SetDict(TPDFDictionary(Obj));
  NewIndObj(Self, O, G, St);
  Result := O;
end;

procedure TPDFDocument.XRefItem(O: Integer; N: Int64; G: Integer; T: AnsiChar);
begin
  if O > FMaxObjNum then FMaxObjNum := O;
  
  if (T = 'n') then
  begin
    if XRefObjLoaded.AddUnique(O) then
    begin
      XRefTable[XRefTableIndex].ObjNum := O;
      XRefTable[XRefTableIndex].ObjPos := N;
      XRefTable[XRefTableIndex].GenNum := G;
      XRefTable[XRefTableIndex].InUse := True;
      XRefTable[XRefTableIndex].Compact := False;
      Inc(XRefTableIndex);
      if XRefTableIndex > (Length(XRefTable) - 10) then
        SetLength(XRefTable, Length(XRefTable) * 2);
    end;
  end else
  if (T = 'c') then
  begin
    if XRefObjLoaded.AddUnique(O) then
    begin
      XRefTable[XRefTableIndex].ObjNum := O;
      XRefTable[XRefTableIndex].ObjPos := 0;
      XRefTable[XRefTableIndex].GenNum := 0;
      XRefTable[XRefTableIndex].InUse := True;
      XRefTable[XRefTableIndex].Compact := True;
      XRefTable[XRefTableIndex].ObjStrNum := N;
      XRefTable[XRefTableIndex].ObjStrIndex := G;
      Inc(XRefTableIndex);
      if XRefTableIndex > (Length(XRefTable) - 10) then
        SetLength(XRefTable, Length(XRefTable) * 2);
    end;
  end;
end;

procedure TPDFDocument.XRefTrailer(const Trailer: AnsiString);
var
  O: TPDFObject;
begin
  if not Assigned(FTrailer) then
  begin
    O := FStructure.Decode(Trailer);
    if O is TPDFDictionary then FTrailer := TPDFDictionary(O);
    if Assigned(FTrailer) then
    begin
      FTrailer.PurgeKey('Prev');
      FTrailer.PurgeKey('Type');
      FTrailer.PurgeKey('W');
      FTrailer.PurgeKey('Index');
      FTrailer.PurgeKey('Length');
      FTrailer.PurgeKey('Filter');      
    end;
  end;
end;

procedure TPDFDocument.SetMarkInfo(NewMarkInfo: Boolean);
var
  Obj: TPDFObject;
  MarkInfo: TPDFDictionary;
begin
  Obj := RootDict.FindValueByKeyName('MarkInfo', True);
  if (Obj is TPDFDictionary) then
  begin
    MarkInfo := TPDFDictionary(Obj);
  end else
  begin
    MarkInfo := FStructure.NewDictionary;
    RootDict.Add('MarkInfo', MarkInfo);
  end;
  MarkInfo.Add('Marked', FStructure.NewBoolean(NewMarkInfo));
end;

procedure TPDFDocument.SetMetadata(const NewXMP: AnsiString);
var
  ID: TPDFDictionary;
  Stream: TPDFStream;
  Obj: TPDFObject;
  IR: TPDFIndRef;
begin
  Stream := nil;
  if (GetEncrypted = peDecrypted) then
  begin
    ID := RootDict;
    Obj := ID.FindValueByKeyName('Metadata', True);
    if not (Obj is TPDFStream) then
    begin
      Stream := FStructure.NewStream('');
      IR := NewObjRef(Stream);
      ID.Add('Metadata', IR);
    end;

    if Obj is TPDFStream then
      Stream := TPDFStream(Obj);

    if Assigned(Stream) then
    begin
      Stream.Dictionary.Add('Type', FStructure.NewName('Metadata'));
      Stream.Dictionary.Add('Subtype', FStructure.NewName('XML'));
      Stream.SetTo(NewXMP, False);
    end;
  end;

  if (Assigned(XMP)) then
    XMP.Free;

  XMP := TDebenuPDFLibraryXMP.Create;
  XMP.LoadFromString(NewXMP);
end;

function TPDFDocument.GetDocID(Part, Options: Integer): AnsiString;
var
  ID: TPDFArray;
  Obj: TPDFObject;
  Temp: AnsiString;
  X: Integer;
begin
  Result := '';
  ID := GetID;
  if (Part >= 0) and (Part < ID.Count) then
  begin
    Obj := ID.Item[Part];
    if Obj is TPDFString then
    begin
      Result := TPDFString(Obj).AsString;
      if Options = 1 then
      begin
        Temp := Result;
        Result := '';
        for X := 1 to Length(Temp) do
          Result := Result + QPLIntToHex(Ord(Temp[X]), 2);
      end;
    end;
  end;
end;

function TPDFDocument.NewOCG(const GroupName: WideString): TPDFIndRef;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  OCPropertiesDict: TPDFDictionary;
  OCGsArray: TPDFArray;
  OrderArray: TPDFArray;
  OCGDict: TPDFDictionary;
  DDict: TPDFDictionary;
begin
  Result := nil;
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('OCProperties', True);
    if not (Obj is TPDFDictionary) then
    begin
      OCPropertiesDict := FStructure.NewDictionary;
      Root.Add('OCProperties', NewObjRef(OCPropertiesDict));
    end else
      OCPropertiesDict := TPDFDictionary(Obj);
    if Assigned(OCPropertiesDict) then
    begin
      Obj := OCPropertiesDict.FindValueByKeyName('D', True);
      if not (Obj is TPDFDictionary) then
      begin
        DDict := FStructure.NewDictionary;
        OCPropertiesDict.Add('D', DDict);
      end else
        DDict := TPDFDictionary(Obj);

      Obj := OCPropertiesDict.FindValueByKeyName('OCGs', True);
      if not (Obj is TPDFArray) then
      begin
        OCGsArray := FStructure.NewArray;
        OCPropertiesDict.Add('OCGs', OCGsArray);
      end else
        OCGsArray := TPDFArray(Obj);

      Obj := DDict.FindValueByKeyName('Order', True);
      if not (Obj is TPDFArray) then
      begin
        OrderArray := FStructure.NewArray;
        DDict.Add('Order', OrderArray);
      end else
        OrderArray := TPDFArray(Obj);

      if Assigned(OCGsArray) and Assigned(OrderArray) then
      begin
        OCGDict := FStructure.NewDictionary;
        OCGDict.Add('Type', FStructure.NewName('OCG'));
        OCGDict.Add('Name', FStructure.NewTextString(GroupName));
        Result := NewObjRef(OCGDict);
        OCGsArray.Add(Result);
        OrderArray.Add(Result);
      end;

      SetOCGAutoState(Result, 'View', True);
      SetOCGAutoState(Result, 'Print', True);            
    end;
  end;
end;

function TPDFDocument.NewOpenTypeFont(Source: TStream): TPDFFont;
var
  Font: TPDFFont;
  FN: AnsiString;
begin
  Inc(IndexCount);
  FN := 'QuickPDFF' + QPLRandomID;

  Font := TPDFFont.Create(FStructure, FN);
  Font.Compress := FCompressFonts = 1;
  if Font.NewOpenTypeFont(Source) then
  begin
    FFonts.Add(Font);
    Result := Font;
  end else
  begin
    Font.Free;
    Result := nil;
  end;
end;

function TPDFDocument.OCGCount: Integer;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  OCPropertiesDict: TPDFDictionary;
  OCGsArray: TPDFArray;
begin
  Result := 0;
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('OCProperties', True);
    if Obj is TPDFDictionary then
    begin
      OCPropertiesDict := TPDFDictionary(Obj);
      Obj := OCPropertiesDict.FindValueByKeyName('OCGs', True);
      if Obj is TPDFArray then
      begin
        OCGsArray := TPDFArray(Obj);
        Result := OCGsArray.Count;
      end;
    end;
  end;
end;

function TPDFDocument.OCGName(OCGRef: TPDFIndRef): WideString;
var
  Obj: TPDFObject;
  OCG: TPDFDictionary;
begin
  Result := '';
  if Assigned(OCGRef) then
  begin
    Obj := OCGRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OCG := TPDFDictionary(Obj);
      Obj := OCG.FindValueByKeyName('Name', True);
      if Obj is TPDFString then
        Result := TPDFString(Obj).AsTextString;
    end;
  end;
end;

function TPDFDocument.OCGRef(Index: Integer): TPDFIndRef;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  OCPropertiesDict: TPDFDictionary;
  OCGsArray: TPDFArray;
begin
  Result := nil;
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('OCProperties', True);
    if Obj is TPDFDictionary then
    begin
      OCPropertiesDict := TPDFDictionary(Obj);
      Obj := OCPropertiesDict.FindValueByKeyName('OCGs', True);
      if Obj is TPDFArray then
      begin
        OCGsArray := TPDFArray(Obj);
        if (Index >= 1) and (Index <= OCGsArray.Count) then
        begin
          Obj := OCGsArray.Item[Index - 1];
          if Obj is TPDFIndRef then
            Result := TPDFIndRef(Obj);
        end;
      end;
    end;
  end;
end;

function TPDFDocument.SetOCGVisible(OCGRef: TPDFIndRef; Visible: Boolean): Boolean;
var
  Root: TPDFDictionary;
  Obj: TPDFObject;
  OCPropertiesDict: TPDFDictionary;
  DDict: TPDFDictionary;
  OnArray: TPDFArray;
  OffArray: TPDFArray;
begin
  Result := False;
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('OCProperties', True);
    if Obj is TPDFDictionary then
    begin
      OCPropertiesDict := TPDFDictionary(Obj);
      Obj := OCPropertiesDict.FindValueByKeyName('D', True);
      if Obj is TPDFDictionary then
      begin
        DDict := TPDFDictionary(Obj);

        Obj := DDict.FindValueByKeyName('ON', True);
        if not (Obj is TPDFArray) then
        begin
          OnArray := FStructure.NewArray;
          DDict.Add('ON', OnArray);
        end else
        begin
          OnArray := TPDFArray(Obj);
        end;

        Obj := DDict.FindValueByKeyName('OFF', True);
        if not (Obj is TPDFArray) then
        begin
          OffArray := FStructure.NewArray;
          DDict.Add('OFF', OffArray);
        end else
        begin
          OffArray := TPDFArray(Obj);
        end;

        if (Visible) then
        begin
          if (not OnArray.HasMatchingChild(OCGRef.Output)) then
          begin
            OnArray.Add(OCGRef);
          end;
          if (OffArray.HasMatchingChild(OCGRef.Output)) then
          begin
            OffArray.DeleteObj(OCGRef, True);
          end;
        end else
        begin
          if (not OffArray.HasMatchingChild(OCGRef.Output)) then
          begin
            OffArray.Add(OCGRef);
          end;
          if (OnArray.HasMatchingChild(OCGRef.Output)) then
          begin
            OnArray.DeleteObj(OCGRef, True);
          end;
        end;
        SetOCGAutoState(OCGRef, 'View', Visible);
        Result := True;
      end;
    end;
  end;
  if Visible then
    SetOCGUsage(OCGRef, 'View', 'ON')
  else
    SetOCGUsage(OCGRef, 'View', 'OFF');
end;

function TPDFDocument.DeleteOCG(OCGRef: TPDFIndRef): Boolean;
var
  Root: TPDFDictionary;
  Obj: TPDFObject;
  OCPropertiesDict: TPDFDictionary;
  DDict: TPDFDictionary;
  OFFArray: TPDFArray;
  OCGsArray: TPDFArray;
begin
  Result := False;
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('OCProperties', True);
    if Obj is TPDFDictionary then
    begin
      OCPropertiesDict := TPDFDictionary(Obj);
      Obj := OCPropertiesDict.FindValueByKeyName('OCGs', True);
      if Obj is TPDFArray then
      begin
        OCGsArray := TPDFArray(Obj);
        OCGsArray.DeleteObj(OCGRef, True);
        Result := True;
      end;

      Obj := OCPropertiesDict.FindValueByKeyName('D', True);
      if Obj is TPDFDictionary then
      begin
        DDict := TPDFDictionary(Obj);
        Obj := DDict.FindValueByKeyName('OFF', True);
        if Obj is TPDFArray then
        begin
          OFFArray := TPDFArray(Obj);
          OFFArray.DeleteObj(OCGRef, True);
        end;
      end;
    end;
  end;
end;

function TPDFDocument.StandardFont(StandardFontID: Integer): TPDFIndRef;
var
  StdFont: TPDFStdFont;
  Font: TPDFFont;
  FontName: AnsiString;
const
  StandardFontNames: array[0..13] of AnsiString = ('Cour', 'CoBo', 'CoBO',
    'CoOb', 'Helv', 'HeBo', 'HeBO', 'HeOb', 'Time', 'TiBo', 'TiIt', 'TiBI',
    'Symb', 'ZaDb');
  BaseFonts: array[TPDFStdFont] of AnsiString = ('Courier', 'Courier-Bold',
    'Courier-BoldOblique', 'Courier-Oblique', 'Helvetica', 'Helvetica-Bold',
    'Helvetica-BoldOblique', 'Helvetica-Oblique', 'Times-Roman', 'Times-Bold',
    'Times-Italic', 'Times-BoldItalic', 'Symbol', 'ZapfDingbats');
begin
  if (StandardFontID >= 0) and (StandardFontID <= 13) then
    StdFont := TPDFStdFont(StandardFontID)
  else
    StdFont := sfHelvetica;

  FontName := StandardFontNames[StandardFontID];

  Font := TPDFFont.Create(FStructure, FontName);
  Font.NewStandardFont(BaseFonts[StdFont], Ord(StdFont) + 1);
  FFonts.Add(Font);
  AcroForm.AddFont(Font);  
  Result := Font.IndRef;
end;

procedure TPDFDocument.XRefRead(Pos: Int64);
var
  X: Integer;
begin
  if Pos < 0 then
  begin
    for X := 0 to Length(XRefPosList) - 1 do
      if XRefPosList[X] = -Pos then
        XRefPosList[X] := 0;
  end else
  begin
    SetLength(XRefPosList, Length(XRefPosList) + 1);
    XRefPosList[Length(XRefPosList) - 1] := Pos;
  end;
end;

procedure TPDFDocument.AddBlendMode(BlendMode: TPDFBlendMode);
var
  X: Integer;
  I: Integer;
  BlendModeDict: TPDFDictionary;
  S: AnsiString;
begin
  I := -1;
  X := 0;
  while (I < 0) and (X < Length(FBlendModeList)) do
  begin
    if FBlendModeList[X].BlendMode = BlendMode then
      I := X
    else
      Inc(X);
  end;
  if I < 0 then
  begin
    I := Length(FBlendModeList);
    SetLength(FBlendModeList, I + 1);
    FBlendModeList[I].BlendMode := BlendMode;
    Inc(IndexCount);
    FBlendModeList[I].GSName := 'QuickPDFGS' + QPLRandomID;
    BlendModeDict := FStructure.NewDictionary;
    BlendModeDict.Add('Type', FStructure.NewName('ExtGState'));
    S := 'Normal';
    case BlendMode of
      bmNormal: S := 'Normal';
      bmMultiply: S := 'Multiply';
      bmScreen: S := 'Screen';
      bmOverlay: S := 'Overlay';
      bmDarken: S := 'Darken';
      bmLighten: S := 'Lighten';
      bmColorDodge: S := 'ColorDodge';
      bmColorBurn: S := 'ColorBurn';
      bmHardLight: S := 'HardLight';
      bmSoftLight: S := 'SoftLight';
      bmDifference: S := 'Difference';
      bmExclusion: S := 'Exclusion';
      bmHue: S := 'Hue';
      bmSaturation: S := 'Saturation';
      bmColor: S := 'Color';
      bmLuminosity: S := 'Luminosity';
    end;
    BlendModeDict.Add('BM', FStructure.NewName(S));
    FBlendModeList[I].GS := NewObjRef(BlendModeDict);
  end;
  FPageTree.UseGS(FBlendModeList[I].GSName, FBlendModeList[I].GS);
  FPageTree.Painter.SetGS(FBlendModeList[I].GSName);
end;

function TPDFDocument.GetMetadata: AnsiString;
var
  ID: TPDFDictionary;
  Stream: TPDFStream;
  Obj: TPDFObject;
begin
  Result := '';
  Stream := nil;

  if (Assigned(XMP)) then
    Result := XMP.SaveToString
  else
  begin
    ID := RootDict;
    Obj := ID.FindValueByKeyName('Metadata', True);

    if Obj is TPDFStream then
      Stream := TPDFStream(Obj);

    if Assigned(Stream) then
    begin
      if Stream.Dictionary.DictType = 'Metadata' then
      begin
        // Check for both "Subtype" and "SubType"
        Obj := Stream.Dictionary.FindValueByKeyName('Subtype', True);
        if Obj is TPDFName and (TPDFName(Obj).Name = 'XML') then
          Result := Stream.GetDecodedStream;
        Obj := Stream.Dictionary.FindValueByKeyName('SubType', True);
        if Obj is TPDFName and (TPDFName(Obj).Name = 'XML') then
          Result := Stream.GetDecodedStream;
      end;
    end;
  end;
end;

function TPDFDocument.GetCatalogKeys: AnsiString;
var
  ID: TPDFDictionary;
  X: Integer;
  N: AnsiString;
const
  BadList: AnsiString = '/Type/Version/Pages/PageLabels/Names/Dests' +
    '/ViewerPreferences/PageLayout/PageMode/Outlines/Threads' +
    '/OpenAction/AA/URI/AcroForm/Metadata/StructTreeRoot' +
    '/MarkInfo/Lang/SpiderInfo/OuputIntents/PieceInfo/OCProperties' +
    '/Perms/Legal';
begin
  Result := '';

  ID := RootDict;
  if Assigned(ID) then
  begin
    for X := 0 to ID.Count - 1 do
    begin
      N := ID.Entry[X].Key.Name;
      if QPLPos('/' + N, BadList) = 0 then
        Result := Result + '"' + N + '",';
    end;
  end;
end;

function TPDFDocument.GetInfoKeys: AnsiString;
var
  ID: TPDFDictionary;
  X: Integer;
  N: AnsiString;
const
  BadList: AnsiString = '/Author/Title/Subject/Keywords/Creator/Producer/CreationDate/ModDate';
begin
  Result := '';
  ID := InfoDict;
  if Assigned(ID) then
  begin
    for X := 0 to ID.Count - 1 do
    begin
      N := ID.Entry[X].Key.Name;
      if QPLPos('/' + N, BadList) = 0 then
        Result := Result + '"' + N + '",';
    end;
  end;
  if QPLCopy(Result, Length(Result), 1) = ',' then
    Delete(Result, Length(Result), 1);
end;

function TPDFDocument.RemoveSharedLayers: Boolean;
var
  ThisPage: TPDFDictionary;
  UsedLayerList: TQuickPDFIntegerList;
  SharedLayerList: TQuickPDFIntegerList;
  Obj: TPDFObject;
  CRef: TPDFIndRef;
  CArray: TPDFArray;
  I: Integer;
  SI: Integer;
  X: Integer;
  NewStream: TPDFStream;
  NewStreamRef: TPDFIndRef;
  SharedStreams: TQuickPDFStringList;
  ObjNum: Integer;
begin
  Result := False;
  UsedLayerList := TQuickPDFIntegerList.Create;
  SharedLayerList := TQuickPDFIntegerList.Create;
  SharedStreams := TQuickPDFStringList.Create;
  try
    ThisPage := FirstPage;
    if Assigned(ThisPage) then
    repeat
      ThisPage := NextPage(ThisPage);
      if Assigned(ThisPage) then
      begin
        CArray := nil;
        Obj := ThisPage.FindValueByKeyName('Contents', False);
        if Obj is TPDFIndRef then
        begin
          CRef := TPDFIndRef(Obj);
          Obj := CRef.Obj;
          if Obj is TPDFArray then
          begin
            CArray := TPDFArray(Obj);
          end else
          if Obj is TPDFStream then
          begin
            I := UsedLayerList.IndexOf(CRef.ObjNum);
            if I < 0 then
              UsedLayerList.Add(CRef.ObjNum)
            else
            begin
              if SharedLayerList.IndexOf(CRef.ObjNum) < 0 then
              begin
                ObjNum := CRef.ObjNum;
                Obj := CRef.Obj;
                if Obj is TPDFStream then
                begin
                  SharedLayerList.Add(ObjNum);
                  SharedStreams.AddObject(TPDFStream(Obj).GetDecodedStream, TObject(ObjNum));
                end;
              end;
            end;
          end;
        end else
        if Obj is TPDFArray then
          CArray := TPDFArray(Obj);
        if Assigned(CArray) then
        begin
          for X := 0 to CArray.Count - 1 do
          begin
            Obj := CArray.Item[X];
            if Obj is TPDFIndRef then
            begin
              CRef := TPDFIndRef(Obj);
              I := UsedLayerList.IndexOf(CRef.ObjNum);
              if I < 0 then
                UsedLayerList.Add(CRef.ObjNum)
              else
              begin
                if SharedLayerList.IndexOf(CRef.ObjNum) < 0 then
                begin
                  ObjNum := CRef.ObjNum;
                  Obj := CRef.Obj;
                  if Obj is TPDFStream then
                  begin
                    SharedLayerList.Add(ObjNum);
                    SharedStreams.AddObject(TPDFStream(Obj).GetDecodedStream, TObject(ObjNum));
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    until not Assigned(ThisPage);

    if SharedLayerList.Count > 0 then
    begin
      Result := True;
      ThisPage := FirstPage;
      if Assigned(ThisPage) then
      repeat
        ThisPage := NextPage(ThisPage);
        if Assigned(ThisPage) then
        begin
          CArray := nil;
          Obj := ThisPage.FindValueByKeyName('Contents', False);
          if Obj is TPDFIndRef then
          begin
            CRef := TPDFIndRef(Obj);
            Obj := CRef.Obj;
            if Obj is TPDFArray then
            begin
              CArray := TPDFArray(Obj);
            end else
            if Obj is TPDFStream then
            begin
              I := SharedLayerList.IndexOf(CRef.ObjNum);
              if I >= 0 then
              begin
                ObjNum := CRef.ObjNum;
                SI := SharedStreams.IndexOfObject(TObject(ObjNum));
                if SI >= 0 then
                begin
                  NewStream := FStructure.NewStream('');
                  NewStream.SetTo(SharedStreams[SI], True);
                  NewStreamRef := NewObjRef(NewStream);
                  ThisPage.Add('Contents', NewStreamRef);
                end;
              end;
            end;
          end else
          if Obj is TPDFArray then
            CArray := TPDFArray(Obj);
          if Assigned(CArray) then
          begin
            for X := 0 to CArray.Count - 1 do
            begin
              Obj := CArray.Item[X];
              if Obj is TPDFIndRef then
              begin
                CRef := TPDFIndRef(Obj);
                I := SharedLayerList.IndexOf(CRef.ObjNum);
                if I >= 0 then
                begin
                  ObjNum := CRef.ObjNum;
                  SI := SharedStreams.IndexOfObject(TObject(ObjNum));
                  if SI >= 0 then
                  begin
                    NewStream := FStructure.NewStream('');
                    NewStream.SetTo(SharedStreams[SI], True);
                    NewStreamRef := NewObjRef(NewStream);
                    CArray.ReplaceNoKill(X, NewStreamRef);
                  end;
                end;
              end;
            end;
          end;
        end;
      until not Assigned(ThisPage);
    end;
  finally
    UsedLayerList.Free;
    SharedLayerList.Free;
    SharedStreams.Free;
  end;
end;

function TPDFDocument.FirstPage: TPDFDictionary;
var
  Obj: TPDFObject;
  Pages: TPDFDictionary;
  Catalog: TPDFDictionary;
begin
  Result := nil;
  Catalog := RootDict;
  if Assigned(Catalog) then
  begin
    Obj := Catalog.FindValueByKeyName('Pages', True);
    if Obj is TPDFDictionary then
    begin
      Pages := TPDFDictionary(Obj);
      Result := FirstPageFrom(Pages);
    end;
  end;
end;

function TPDFDocument.NextPage(Start: TPDFDictionary): TPDFDictionary;
var
  Recurse: Boolean;
  PageIndRef: TPDFIndRef;
  Obj: TPDFObject;
  Parent: TPDFDictionary;
  Kids: TPDFArray;
  I: Integer;
  Node: TPDFDictionary;
begin
  Result := nil;
  Recurse := Assigned(Start);
  while Recurse do
  begin
    Recurse := False;
    PageIndRef := FStructure.NewIndirectRef(Start.IndObjNum, Start.IndGenNum);
    Obj := Start.FindValueByKeyName('Parent', True);
    if Obj is TPDFDictionary then
    begin
      Parent := TPDFDictionary(Obj);
      Obj := Parent.FindValueByKeyName('Kids', True);
      if Obj is TPDFArray then
      begin
        Kids := TPDFArray(Obj);
        if Kids.Count > 0 then
        begin
          I := Kids.ItemIndexMatch(PageIndRef);
          if (I >= 0) and (I < Kids.Count - 1) then
          begin
            Obj := Kids.Item[I + 1];
            if Obj is TPDFIndRef then
            begin
              Obj := TPDFIndRef(Obj).Obj;
              if Obj is TPDFDictionary then
              begin
                Node := TPDFDictionary(Obj);
                if Node.DictType = 'Pages' then
                begin
                  Result := FirstPageFrom(Node)
                end else
                if Node.DictType = 'Page' then
                  Result := Node;
              end;
            end;
          end else
          if (I = Kids.Count - 1) then
          begin
            Start := Parent;
            Recurse := True;
          end;
        end;
      end;
    end;
    FStructure.RemoveObject(PageIndRef);
  end;
end;

function TPDFDocument.FirstPageFrom(Start: TPDFDictionary): TPDFDictionary;
var
  Pages: TPDFDictionary;
  Obj: TPDFObject;
  Kids: TPDFArray;
  NoPages: Boolean;
  Node: TPDFDictionary;
begin
  Result := nil;
  NoPages := False;
  Pages := Start;
  repeat
    Obj := Pages.FindValueByKeyName('Kids', True);
    if Obj is TPDFArray then
    begin
      Kids := TPDFArray(Obj);
      if Kids.Count > 0 then
      begin
        Obj := Kids.Item[0];
        if Obj is TPDFIndRef then
        begin
          Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFDictionary then
          begin
            Node := TPDFDictionary(Obj);
            if Node.DictType = 'Page' then
              Result := Node
            else
              Pages := Node;
          end else
            NoPages := True;
        end else
          NoPages := True;
      end else
        NoPages := True;
    end else
      NoPages := True;
  until NoPages or Assigned(Result);
end;

function TPDFDocument.GetOutlineOpenFile(OutlineRef: TPDFIndRef): AnsiString;
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  FileSpecDict: TPDFDictionary;
begin
  Result := '';
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('A', True);
      if Obj is TPDFDictionary then
      begin
        ActionDict := TPDFDictionary(Obj);
        repeat
          if (ActionDict.DictType = '') or (ActionDict.DictType = 'Action') then
          begin
            Obj := ActionDict.FindValueByKeyName('S', True);
            if (Obj is TPDFName) and ((TPDFName(Obj).Name = 'Launch') or (TPDFName(Obj).Name = 'GoToR')) then
            begin
              Obj := ActionDict.FindValueByKeyName('F', True);
              if Obj is TPDFString then
              begin
                Result := TPDFString(Obj).AsString;
              end else
              if Obj is TPDFDictionary then
              begin
                FileSpecDict := TPDFDictionary(Obj);
                Obj := FileSpecDict.FindValueByKeyName('F', True);
                if Obj is TPDFString then
                begin
                  Result := TPDFString(Obj).AsString;
                end else
                begin
                  Obj := FileSpecDict.FindValueByKeyName('DOS', True);
                  if Obj is TPDFString then Result := TPDFString(Obj).AsString;
                end;
              end;
            end;
          end;
          Obj := ActionDict.FindValueByKeyName('Next', True);
          if Obj is TPDFDictionary then
            ActionDict := TPDFDictionary(Obj)
          else
            ActionDict := nil;
        until (not Assigned(ActionDict)) or (Result <> '');
      end;
    end;
  end;
end;

function TPDFDocument.GetOutlineWebLink(OutlineRef: TPDFIndRef): AnsiString;
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
begin
  Result := '';
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('A', True);
      if Obj is TPDFDictionary then
      begin
        ActionDict := TPDFDictionary(Obj);
        repeat
          if (ActionDict.DictType = '') or (ActionDict.DictType = 'Action') then
          begin
            Obj := ActionDict.FindValueByKeyName('S', True);
            if (Obj is TPDFName) and (TPDFName(Obj).Name = 'URI') then
            begin
              Obj := ActionDict.FindValueByKeyName('URI', True);
              if Obj is TPDFString then Result := TPDFString(Obj).AsString;
            end;
          end;
          Obj := ActionDict.FindValueByKeyName('Next', True);
          if Obj is TPDFDictionary then
            ActionDict := TPDFDictionary(Obj)
          else
            ActionDict := nil;
        until (not Assigned(ActionDict)) or (Result <> '');
      end;
    end;
  end;
end;

function TPDFDocument.GetViewerPreferences(const Key: AnsiString): TPDFObject;
var
  Root: TPDFDictionary;
  O: TPDFObject;
  VP: TPDFDictionary;
begin
  Root := GetRootDict;
  Result := nil;
  if Assigned(Root) then
  begin
    O := Root.FindValueByKeyName('ViewerPreferences', True);
    if O is TPDFDictionary then
    begin
      VP := TPDFDictionary(O);
      Result := VP.FindValueByKeyName(Key, True);
    end;
  end;
end;

function TPDFDocument.GetViewOCGList: TQPLOCGStateList;
var
  SX: Integer;
begin
  SetLength(Result, OCGCount);
  for SX := 0 to OCGCount - 1 do
  begin
    Result[SX].OCGIndRef := OCGRef(SX + 1);
    Result[SX].Show := GetOCGVisible(Result[SX].OCGIndRef);
  end;
end;

function TPDFDocument.GetXMPInformation(const Key,
  Delimiter: WideString): WideString;
begin
  Result := '';
  if (not Assigned(XMP)) then
  begin
    XMP := TDebenuPDFLibraryXMP.Create;
    XMP.LoadFromString(GetMetadata);
  end;

  if (Key = 'dc:subject') then
  begin
    Result := XMP.DCSubject;
  end;
end;

function TPDFDocument.NewPostScriptXObject(const PS: AnsiString): TPDFIndRef;
var
  PSStream: TPDFStream;
begin
  PSStream := FStructure.NewStream('');
  PSStream.SetTo(PS, True);
  PSStream.Dictionary.Add('Subtype', FStructure.NewName('PS'));
  Result := NewObjRef(PSStream);
end;

function TPDFDocument.MakeEmbeddedFileSpec(const FileName: WideString;
  const MIMEType: AnsiString): TPDFIndRef;
var
  FSDict: TPDFDictionary;
  EFDict: TPDFDictionary;
  EFStream: TPDFStream;
  EFStreamRef: TPDFIndRef;
  FS: TQuickPDFWideFileStream;
  EFParams: TPDFDictionary;
  CT: TFileTime;
  MT: TFileTime;
  FileOkay: Boolean;
  FileNameAnsi: AnsiString;

   function Win32FileTimeToDateTime(Time: TFileTime): TDateTime;
   begin
     Result := (Time.dwLowDateTime / 86400.0E7) +
       (Time.dwHighDateTime * 65536.0 * 65536.0 / 86400.0E7) - 109205;
   end;

begin
  Result := nil;
  FileOkay := True;
  try
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    try
    finally
      FS.Free;
    end;
  except
    FileOkay := False;
  end;

  if FileOkay then
  begin
    FSDict := FStructure.NewDictionary;
    Result := NewObjRef(FSDict);
    FSDict.Add('Type', FStructure.NewName('Filespec'));

    FileNameAnsi := QPLWideStringToAnsiString(FileName);
    FSDict.Add('UF', FStructure.NewTextString(FileName));
    FSDict.Add('F', FStructure.NewString(FileNameAnsi));
    EFDict := FStructure.NewDictionary;
    FSDict.Add('EF', EFDict);
    EFStream := FStructure.NewStream('');
    EFStreamRef := NewObjRef(EFStream);
    EFDict.Add('F', EFStreamRef);
    EFParams := FStructure.NewDictionary;
    EFStream.Dictionary.Add('Params', EFParams);
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    try
      EFStream.ReadFromStream(FS, True);
      EFParams.Add('Size', FStructure.NewNumeric(FS.Size));
{$IFDEF QPL_OS_WINDOWS}
      GetFileTime(FS.Handle, @CT, nil, @MT);
{$ENDIF}
      EFParams.Add('CreationDate', FStructure.NewString(MakePDFDateTime(
        Win32FileTimeToDateTime(CT), True)));
      EFParams.Add('ModDate', FStructure.NewString(MakePDFDateTime(
        Win32FileTimeToDateTime(MT), True)));
    finally
      FS.Free;
    end;
    EFStream.Dictionary.Add('Subtype', FStructure.NewName(MIMEType));
  end;
end;

function TPDFDocument.AttachFile(const Title: AnsiString; EmbeddedFile: TPDFIndRef): Boolean;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  NamesDict: TPDFDictionary;
  EFNameDict: TPDFDictionary;
  A: TPDFArray;
  NT: TPDFNameTree;
begin
  Result := False;
  if Assigned(EmbeddedFile) then
  begin
    Root := GetRootDict;
    Obj := Root.FindValueByKeyName('Names');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
    begin
      NamesDict := TPDFDictionary(Obj);
    end else
    begin
      NamesDict := FStructure.NewDictionary;
      Root.Add('Names', NamesDict);
    end;
    Obj := NamesDict.FindValueByKeyName('EmbeddedFiles');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
    begin
      EFNameDict := TPDFDictionary(Obj);
    end else
    begin
      EFNameDict := FStructure.NewDictionary;
      NamesDict.Add('EmbeddedFiles', EFNameDict);
      A := FStructure.NewArray;
      EFNameDict.Add('Names', A);
    end;
    NT := TPDFNameTree.Create(FStructure, EFNameDict);
    try
      if not NT.HasKey(Title) then
      begin
        NT.AddKey(Title, EmbeddedFile);
        Result := True;
      end;
    finally
      NT.Free;
    end;
  end;
end;

function TPDFDocument.GetResourceList: AnsiString;
var
  X: Integer;
  Y: Integer;
  D: TPDFDictionary;
  R: TPDFObject;
  RN: AnsiString;
  ResourceList: TQuickPDFStringList;
begin
  ResourceList := TQuickPDFStringList.Create;
  try
    for X := 1 to FPageTree.PageCount do
    begin
      D := FPageTree.GetPage(X);
      if Assigned(D) then
      try
        R := D.FindValueByKeyName('Resources');
        if R is TPDFIndRef then
          R := TPDFIndRef(R).Obj;
        if R is TPDFDictionary then
        begin
          D := TPDFDictionary(R);
          for Y := 0 to D.Count - 1 do
          begin
            RN := D.Entry[Y].Key.Name;
            if ResourceList.IndexOf(RN) < 0 then
              ResourceList.Add(RN);
          end;
        end;
      except
      end;
    end;
  finally
    Result := ResourceList.Text;
    ResourceList.Free;
  end;
end;

function TPDFDocument.NewCJKFont(CJKFontID: Integer): TPDFFont;
var
  Font: TPDFFont;
  FontName: AnsiString;
begin
  Inc(IndexCount);
  FontName := 'QuickPDFF' + QPLRandomID;

  Font := TPDFFont.Create(FStructure, FontName);
  Font.NewCJKFont(CJKFontID);
  FFonts.Add(Font);
  Result := Font;
end;

function TPDFDocument.SetHTMLOption(const OptionName,
  OptionValue: AnsiString): Boolean;
var
  P: Integer;
begin
  Result := False;
  if OptionName = 'EquivalentTag' then
  begin
    P := QPLPos('=', OptionValue);
    if P > 0 then
    begin
      SetLength(HTMLEquivalentTags, Length(HTMLEquivalentTags) + 1);
      HTMLEquivalentTags[Length(HTMLEquivalentTags) - 1] := QPLLowerCase(OptionValue);
    end;
  end;
end;

function TPDFDocument.GetHTMLFont(Index: Integer): TPDFFont;
begin
  if (Index >= 1) and (Index <= 4) then
    Result := HTMLFont[Index]
  else
    Result := nil;
end;

procedure TPDFDocument.DecryptObject(const Key: AnsiString;
  Obj: TPDFObject);
var
  Value: AnsiString;
  DX: Integer;
begin
  if ((FIsUserPassword) or (FIsOwnerPassword)) then
  begin
    if Obj is TPDFDictionary then
    begin
      for DX := 0 to TPDFDictionary(Obj).Count - 1 do
        DecryptObject(Key, TPDFDictionary(Obj).Entry[DX].Value);
    end else
    if Obj is TPDFArray then
    begin
      for DX := 0 to TPDFArray(Obj).Count - 1 do
        DecryptObject(Key, TPDFArray(Obj).Item[DX]);
    end else
    if Obj is TPDFString then
    begin
      Value := TPDFString(Obj).AsString;
      if FEncryption.Algorithm = eaRC4 then
        Value := ARC4Encrypt(Key, Value)
      else
        Value := AESDecryptString(Key, Value);
      TPDFString(Obj).SetTo(Value);
    end else
    if Obj is TPDFStream then
    begin
      Value := TPDFStream(Obj).Stream;
      if FEncryption.Algorithm = eaRC4 then
        Value := ARC4Encrypt(Key, Value)
      else
        Value := AESDecryptString(Key, Value);
      TPDFStream(Obj).Stream := Value;
      DecryptObject(Key, TPDFStream(Obj).Dictionary);
    end;
  end;
end;

procedure TPDFDocument.DecryptContent(Recode: Boolean);
var
  X: Integer;
  IndObj: TPDFIndObj;
//  Key: AnsiString;
begin
  if FTempFileName <> '' then
  begin
    if QPLFileExists(FTempFileName) then
    try
      QPLDeleteFile(FTempFileName);
    except
    end;
    FMainFS := QPLCreateFileStream(FTempFileName, fmCreate or fmShareExclusive)
  end;
  try
    for X := 0 to FIndObjList.Count - 1 do
    begin
      IndObj := TPDFIndObj(FIndObjList[X]);
      if not IndObj.Compact then
      begin
        //Key := MakeKey(IndObj.ObjNum, IndObj.GenNum);
        try
          IndObj.Obj;
          //IndObj.Decrypt;
          ///if not IndObj.FDecrypted then
          //  DecryptObject(Key, IndObj.Obj);
          if Recode then IndObj.Recode;
        except
        end;
      end else
      begin
        //IndObj.Decode;
        //IndObj.FDecrypted := False;
      end;
      IndObj.FDecrypted := False;
    end;
  finally
    if Assigned(FMainFS) then FMainFS.Free;
    FMainFS := nil;
  end;
end;

procedure TPDFDocument.SetMinimumVersion(const MinVer: AnsiString);
var
  NewVer: Integer;
  OldVer: Integer;
begin
  if (Length(MinVer) = 3) and (MinVer[2] = '.') then
  begin
    NewVer := QPLStrToIntDef(QPLCopy(MinVer, 1, 1) + QPLCopy(MinVer, 3, 1), 0);
    if NewVer > 0 then
    begin
      OldVer := QPLStrToIntDef(QPLCopy(FVersion, 1, 1) + QPLCopy(FVersion, 3, 1), 0);
      if NewVer > OldVer then
        SetVersion(MinVer);
    end;
  end;
end;

function TPDFDocument.EncryptionAcroX: Boolean;
begin
  if not FEncryption.Extracted then ExtractEncryption;
  Result := (FEncryption.V = 5) and (FEncryption.R = 6);
end;

function TPDFDocument.EncryptionAlgorithm: Integer;
begin
  if not FEncryption.Extracted then ExtractEncryption;
  if FEncryption.V <> 0 then
    Result := Ord(FEncryption.Algorithm) + 1
  else
    Result := 0;
end;

function TPDFDocument.NewRGBAxialShader(const ShaderName: AnsiString; StartX,
  StartY, StartRed, StartGreen, StartBlue, EndX, EndY, EndRed, EndGreen,
  EndBlue: Double; Extend: Boolean): TPDFRGBAxialShader;
var
  L: Integer;
  X: Integer;
  Shader: TPDFRGBAxialShader;
  PatternDict: TPDFDictionary;
  ShadingDict: TPDFDictionary;
  FunctionDict: TPDFDictionary;
begin
  Result := nil;
  L := -1;
  for X := 0 to Length(FShaders) - 1 do
  begin
    if FShaders[X].ShaderName = ShaderName then L := X;
  end;
  if L < 0 then
  begin
    L := Length(FShaders);
    SetLength(FShaders, L + 1);
    Shader := TPDFRGBAxialShader.Create;
    FShaders[L] := Shader;
    Shader.ShaderName := ShaderName;
    Shader.CSName := 'QuickPDFShader' + QPLRandomID;

    PatternDict := FStructure.NewDictionary;
    PatternDict.Add('Type', FStructure.NewCommonName('Pattern'));
    PatternDict.Add('PatternType', FStructure.NewNumeric(2));

    Shader.CS := NewObjRef(PatternDict);    

    ShadingDict := FStructure.NewDictionary;
    PatternDict.Add('Shading', ShadingDict);

    ShadingDict.Add('ShadingType', FStructure.NewNumeric(2));
    ShadingDict.Add('ColorSpace', FStructure.NewCommonName('DeviceRGB'));
    ShadingDict.Add('Coords', FStructure.NewDoubleArray([StartX, StartY, EndX, EndY]));
    ShadingDict.Add('Domain', FStructure.NewIntArray([0, 1]));
    if Extend then
      ShadingDict.Add('Extend', FStructure.Decode('[ true true ]'));

    FunctionDict := FStructure.NewDictionary;
    ShadingDict.Add('Function', NewObjRef(FunctionDict));

    FunctionDict.Add('FunctionType', FStructure.NewNumeric(2));
    FunctionDict.Add('Domain', FStructure.NewIntArray([0, 1]));
    FunctionDict.Add('C0',
      FStructure.NewDoubleArray([StartRed, StartGreen, StartBlue]));
    FunctionDict.Add('C1',
      FStructure.NewDoubleArray([EndRed, EndGreen, EndBlue]));
    FunctionDict.Add('N', FStructure.NewNumeric(1));

    Shader.StartX := StartX;
    Shader.StartY := StartY;
    Shader.StartRed := StartRed;
    Shader.StartGreen := StartGreen;
    Shader.StartBlue := StartBlue;
    Shader.EndX := EndX;
    Shader.EndY := EndY;
    Shader.EndRed := EndRed;
    Shader.EndGreen := EndGreen;
    Shader.EndBlue := EndBlue;
    Result := Shader;
  end;
end;

function TPDFDocument.HasShader(const ShaderName: AnsiString): Boolean;
var
  X: Integer;
  L: Integer;
begin
  L := -1;
  for X := 0 to Length(FShaders) - 1 do
  begin
    if FShaders[X].ShaderName = ShaderName then L := X;
  end;
  Result := L >= 0;
end;

function TPDFDocument.HasTilingPattern(const TilingPatternName: AnsiString): Boolean;
var
  X: Integer;
  L: Integer;
begin
  L := -1;
  for X := 0 to Length(FTilingPatterns) - 1 do
  begin
    if (FTilingPatterns[X].TilingPatternName = TilingPatternName) then
    begin
      L := X;
    end;
  end;
  Result := L >= 0;
end;

function TPDFDocument.FindShader(const ShaderName: AnsiString): TPDFShader;
var
  X: Integer;
  L: Integer;
begin
  L := -1;
  for X := 0 to Length(FShaders) - 1 do
  begin
    if FShaders[X].ShaderName = ShaderName then L := X;
  end;
  if L >= 0 then
    Result := FShaders[L]
  else
    Result := nil;
end;

function TPDFDocument.FindTilingPattern(const TilingPatternName: AnsiString): TPDFTilingPattern;
var
  X: Integer;
  L: Integer;
begin
  L := -1;
  for X := 0 to Length(FTilingPatterns) - 1 do
  begin
    if (FTilingPatterns[X].TilingPatternName = TilingPatternName) then
    begin
      L := X;
    end;
  end;
  if L >= 0 then
    Result := FTilingPatterns[L]
  else
    Result := nil;
end;

function TPDFDocument.GetOutlineColor(OutlineRef: TPDFIndRef;
  ColorComponent: Integer): Double;
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  ColorArray: TPDFArray;
begin
  Result := 0;
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('C');
      if Obj is TPDFArray then
      begin
        ColorArray := TPDFArray(Obj);
        Obj := nil;
        if ColorArray.Count = 1 then
        begin
          Obj := ColorArray.Item[0];
        end;
        if ColorArray.Count = 3 then
        begin
          if (ColorComponent < 0) then ColorComponent := 0;
          if (ColorComponent > 2) then ColorComponent := 2;
          Obj := ColorArray.Item[ColorComponent];
        end;
        if Assigned(Obj) and (Obj is TPDFNumeric) then
          Result := TPDFNumeric(Obj).AsDouble;
      end;
    end;
  end;
end;

function TPDFDocument.GetOutlineJS(OutlineRef: TPDFIndRef): WideString;
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
begin
  Result := '';
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('A', True);
      if Obj is TPDFDictionary then
      begin
        ActionDict := TPDFDictionary(Obj);
        Obj := ActionDict.FindValueByKeyName('JS', True);
        if Obj is TPDFStream then
        begin
          Result := TPDFStream(Obj).GetDecodedTextStream;
        end else
        if Obj is TPDFString then
        begin
          Result := TPDFString(Obj).AsTextString;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.OutlineIsBold(OutlineRef: TPDFIndRef): Boolean;
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  F: Integer;
begin
  Result := False;
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('F');
      if Obj is TPDFNumeric then
      begin
        F := TPDFNumeric(Obj).AsInteger;
        Result := F and 2 = 2;
      end;
    end;
  end;
end;

function TPDFDocument.OutlineIsItalic(OutlineRef: TPDFIndRef): Boolean;
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  F: Integer;
begin
  Result := False;
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('F');
      if Obj is TPDFNumeric then
      begin
        F := TPDFNumeric(Obj).AsInteger;
        Result := F and 1 = 1;
      end;
    end;
  end;
end;

function TPDFDocument.SetOCGPrintable(OCGRef: TPDFIndRef;
  Printable: Integer): Boolean;
begin
  Result := True;
  if Printable = 2 then
  begin
    RemoveOCGUsage(OCGRef, 'Print');
  end
  else
  begin
    if Printable = 1 then
      SetOCGUsage(OCGRef, 'Print', 'ON')
    else
      SetOCGUsage(OCGRef, 'Print', 'OFF');

    SetOCGAutoState(OCGRef, 'Print', True);
  end;
end;

function TPDFDocument.RemoveOCGUsage(OCGRef: TPDFIndRef; const Key:AnsiString): Boolean;
var
  Obj: TPDFObject;
  OCG: TPDFDictionary;
begin
  Result := False;
  if Assigned(OCGRef) then
  begin
    Obj := OCGRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OCG := TPDFDictionary(Obj);
      Obj := OCG.FindValueByKeyName('Usage', True);

      if Obj is TPDFDictionary then
      begin
        if Obj is TPDFDictionary then
          TPDFDictionary(Obj).DeleteEntryByKeyName(Key);
        Result := True;
      end;
    end;
  end;
end;

function TPDFDocument.SetOCGUsage(OCGRef: TPDFIndRef; const Key,
  Value: AnsiString): Boolean;
var
  Obj: TPDFObject;
  OCG: TPDFDictionary;
  Usage: TPDFDictionary;
  KeyDict: TPDFDictionary;
begin
  Result := False;
  if Assigned(OCGRef) then
  begin
    Obj := OCGRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OCG := TPDFDictionary(Obj);
      Obj := OCG.FindValueByKeyName('Usage', True);
      if not Assigned(Obj) then
      begin
        Obj := FStructure.NewDictionary;
        OCG.Add('Usage', Obj);
      end;
      if Obj is TPDFDictionary then
      begin
        Usage := TPDFDictionary(Obj);
        Obj := Usage.FindValueByKeyName(Key);
        if not Assigned(Obj) then
        begin
          Obj := FStructure.NewDictionary;
          Usage.Add(Key, Obj);
        end;
        if Obj is TPDFDictionary then
        begin
          KeyDict := TPDFDictionary(Obj);
          Obj := KeyDict.FindValueByKeyName(Key + 'State', True);
          if not Assigned(Obj) then
          begin
            Obj := FStructure.NewName(Value);
            KeyDict.Add(Key + 'State', Obj);
          end;
          if Obj is TPDFName then
          begin
            Result := True;
            TPDFName(Obj).SetTo(Value);
          end;
        end;
      end;
    end;
  end;
end;

procedure TPDFDocument.SetObjectSource(ObjNum: Integer; const
  NewObjectSource: AnsiString);
var
  O: TPDFObject;
  ObjectLength: Integer;
  StreamStart: Integer;
  StreamLength: Integer;
  StreamData: AnsiString;
  PDFStream: TPDFStream;
  IndObj: TPDFIndObj;
begin
  IndObj := FindObj(ObjNum, 0);
  if (Assigned(IndObj)) then
  begin
    O := FStructure.DecodeWithLength(NewObjectSource, ObjectLength);
    if (O is TPDFDictionary) then
    begin
      StreamStart := 1;
      if (O is TPDFDictionary) and IndObj.IsStream(NewObjectSource, StreamStart, StreamLength) then
      begin
        StreamData := QPLCopy(NewObjectSource, StreamStart, StreamLength);
        PDFStream := FStructure.NewStream(StreamData);
        PDFStream.Dictionary.Assign(TPDFDictionary(O));
        PDFStream.Dictionary.Add('Length',
          FStructure.NewNumeric(Length(StreamData)));
        O := PDFStream;
      end;
    end;

    if (not (O is TPDFNull)) then
    begin
      ReplaceObj(ObjNum, 0, O);
    end;
  end;
end;

function TPDFDocument.SetOCGAutoState(OCGRef: TPDFIndRef;
  const Key: AnsiString; Include: Boolean): Boolean;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  OCPropertiesDict: TPDFDictionary;
  DDict: TPDFDictionary;
  ASArray: TPDFArray;
  X: Integer;
  ADict: TPDFDictionary;
  I: Integer;
  OCGs: TPDFArray;
begin
  Result := True;
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('OCProperties', True);
    if Obj is TPDFDictionary then
    begin
      OCPropertiesDict := TPDFDictionary(Obj);
      Obj := OCPropertiesDict.FindValueByKeyName('D', True);
      if Obj is TPDFDictionary then
      begin
        DDict := TPDFDictionary(Obj);
        Obj := DDict.FindValueByKeyName('AS');
        if not Assigned(Obj) then
        begin
          Obj := FStructure.NewArray;
          DDict.Add('AS', Obj);
        end;
        if Obj is TPDFArray then
        begin
          ASArray := TPDFArray(Obj);
          I := -1;
          for X := 0 to ASArray.Count - 1 do
          begin
            Obj := ASArray.Item[X];
            if Obj is TPDFDictionary then
            begin
              ADict := TPDFDictionary(Obj);
              if ADict.StringValue('Event') = Key then
                I := X;
            end;
          end;
          if I < 0 then
          begin
            ADict := FStructure.NewDictionary;
            ADict.Add('Event', FStructure.NewName(Key));
            ADict.Add('Category', FStructure.Decode('[/' + Key + ']'));
            ADict.Add('OCGs', FStructure.NewArray);
            ASArray.Add(ADict);
            I := ASArray.Count - 1;
          end;
          if I >= 0 then
          begin
            Obj := ASArray.Item[I];
            if Obj is TPDFDictionary then
            begin
              ADict := TPDFDictionary(Obj);
              Obj := ADict.FindValueByKeyName('OCGs', True);
              if not Assigned(Obj) then
              begin
                Obj := FStructure.NewArray;
                ADict.Add('OCGs', Obj);
              end;
              if Obj is TPDFArray then
              begin
                OCGs := TPDFArray(Obj);
                if Include then
                begin
                  if not OCGs.HasMatchingChild(OCGRef.Output) then
                    OCGs.Add(OCGRef);
                end else
                begin
                  if OCGs.HasMatchingChild(OCGRef.Output) then
                    OCGs.DeleteObj(OCGRef, True);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.SetOCGName(OCGRef: TPDFIndRef;
  const NewName: WideString): Boolean;
var
  Obj: TPDFObject;
  OCG: TPDFDictionary;
begin
  Result := False;
  if Assigned(OCGRef) then
  begin
    Obj := OCGRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OCG := TPDFDictionary(Obj);
      Obj := OCG.FindValueByKeyName('Name', True);
      if Obj is TPDFString then
      begin
        TPDFString(Obj).SetToTextString(NewName);
        Result := True;
      end;
    end;
  end;
end;

function TPDFDocument.SetOpenActionDestinationFull(Page, Zoom,
  DestType: Integer; Left, Top, Right, Bottom: Double): Boolean;
var
  Root: TPDFDictionary;
  OpenAction: TPDFDictionary;
  TargetPageRef: TPDFIndRef;
begin
  Result := False;
  if (Page > 0) and (Page <= PageCount) then
  begin
    FPageTree.Page := Page;
    Root := GetRootDict;
    if Assigned(Root) then
    begin
      Root.PurgeKey('OpenAction');
      OpenAction := FStructure.NewDictionary;
      Root.Add('OpenAction', OpenAction);
      OpenAction.Add('Type', FStructure.NewName('Action'));
      OpenAction.Add('S', FStructure.NewName('GoTo'));

      TargetPageRef := FStructure.NewIndirectRef(FPageTree.ThisPage.IndObjNum, FPageTree.ThisPage.IndGenNum);

      OpenAction.Add('D', CreateDestination(TargetPageRef, Zoom, DestType, Left, Top, Right, Bottom));
      Result := True;
    end;
  end;
end;

procedure TPDFDocument.SetOutlineDestFull(OutlineRef: TPDFIndRef; DestPage,
  Zoom, DestType: Integer; Left, Top, Right, Bottom: Double);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  Dest: TPDFArray;
  PageDict: TPDFDictionary;
begin
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      OutlineDict.PurgeKey('Dest');

      PageDict := FPageTree.GetPage(DestPage);
      Dest := FStructure.NewArray;
      Dest.Add(FStructure.NewIndirectRef(PageDict.IndObjNum,
        PageDict.IndGenNum));

      case DestType of
        1:
        begin
          Dest.Add(FStructure.NewName('XYZ'));
          Dest.Add(FStructure.NewNumeric(Left));
          Dest.Add(FStructure.NewNumeric(Top));
          Dest.Add(FStructure.NewNumeric(Zoom / 100));
         end;
        2: Dest.Add(FStructure.NewName('Fit'));
        3:
        begin
          Dest.Add(FStructure.NewName('FitH'));
          Dest.Add(FStructure.NewNumeric(Top));
        end;
        4:
        begin
          Dest.Add(FStructure.NewName('FitV'));
          Dest.Add(FStructure.NewNumeric(Left));
        end;
        5:
        begin
          Dest.Add(FStructure.NewName('FitR'));
          Dest.Add(FStructure.NewNumeric(Left));
          Dest.Add(FStructure.NewNumeric(Bottom));
          Dest.Add(FStructure.NewNumeric(Right));
          Dest.Add(FStructure.NewNumeric(Top));
        end;
        6: Dest.Add(FStructure.NewName('FitB'));
        7:
        begin
          Dest.Add(FStructure.NewName('FitBH'));
          Dest.Add(FStructure.NewNumeric(Top));
        end;
        8:
        begin
          Dest.Add(FStructure.NewName('FitBV'));
          Dest.Add(FStructure.NewNumeric(Left));
        end;
      end;

      OutlineDict.Add('Dest', Dest);
      OutlineDict.PurgeKey('A');
    end;
  end;
end;

function TPDFDocument.GetNamedDestination(const DestName: AnsiString): TPDFObject;
var
  Dests: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := nil;

  // Check the Dests dictionary in the Catalog
  Obj := RootDict.FindValueByKeyName('Dests', True);
  if (Obj is TPDFDictionary) then
  begin
    Obj := TPDFDictionary(Obj).FindValueByKeyName(DestName, True);
    if (Assigned(Obj)) then
    begin
      Result := Obj;
    end;
  end;

  // If not found, check the Dests name tree
  if (not Assigned(Result)) then
  begin
    Dests := GetNameTree('Dests');
    if Assigned(Dests) then
    begin
      Obj := NameTreeLookup(Dests, DestName);
      if (Obj is TPDFIndRef) then
      begin
        Obj := TPDFIndRef(Obj).Obj;
      end;
      if (Assigned(Obj)) then
      begin
        Result := Obj;
      end;
    end;
  end;
end;

function TPDFDocument.EmbeddedFileCount: Integer;
var
  EmbeddedFilesDict: TPDFDictionary;
  EmbeddedFilesNameTree: TPDFNameTree;
begin
  Result := 0;
  EmbeddedFilesDict := GetNameTree('EmbeddedFiles');
  if Assigned(EmbeddedFilesDict) then
  begin
    EmbeddedFilesNameTree := TPDFNameTree.Create(FStructure, EmbeddedFilesDict);
    try
      Result := EmbeddedFilesNameTree.KeyCount;
    finally
      EmbeddedFilesNameTree.Free;
    end;
  end;
end;

function TPDFDocument.GetEmbeddedFileStrProperty(Index,
  Tag: Integer): WideString;
var
  FStream: TPDFStream;
  FileName: WideString;
  Title: WideString;
  Description: WideString;
  Obj: TPDFObject;
  Params: TPDFDictionary;
begin
  Result := '';
  FStream := GetEmbeddedFileStream(Index, FileName, Title, Description);
  if Tag = 1 then
  begin
    Result := FileName;
  end else
  if Tag = 5 then
  begin
    Result := Title;
  end else
  if Tag = 7 then
  begin
    Result := Description;
  end else
  if Assigned(FStream) then
  begin
    if Tag = 2 then
    begin
      Obj := FStream.Dictionary.FindValueByKeyName('Subtype', True);
      if Obj is TPDFName then
        Result := QPLDecodeTextString(TPDFName(Obj).Name);
    end else
    begin
      Obj := FStream.Dictionary.FindValueByKeyName('Params', True);
      if Obj is TPDFDictionary then
      begin
        Params := TPDFDictionary(Obj);
        if Tag = 3 then
        begin
          Obj := Params.FindValueByKeyName('CreationDate', True);
          if Obj is TPDFString then
            Result := TPDFString(Obj).AsTextString;
        end else
        if Tag = 4 then
        begin
          Obj := Params.FindValueByKeyName('ModDate', True);
          if Obj is TPDFString then
            Result := TPDFString(Obj).AsTextString;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.GetEmbeddedFileStream(Index: Integer;
  var FileName: WideString; var Title: WideString;
  var Description: WideString): TPDFStream;
var
  EmbeddedFilesDict: TPDFDictionary;
  EmbeddedFilesNameTree: TPDFNameTree;
  EFNameRef: TPDFIndRef;
  FileSpecDict: TPDFDictionary;
  Obj: TPDFObject;
  EFDict: TPDFDictionary;
  KeyName: AnsiString;
begin
  Result := nil;
  FileName := '';
  EmbeddedFilesDict := GetNameTree('EmbeddedFiles');
  if Assigned(EmbeddedFilesDict) then
  begin
    EmbeddedFilesNameTree := TPDFNameTree.Create(FStructure, EmbeddedFilesDict);
    try
      KeyName := EmbeddedFilesNameTree.KeyName(Index);
      Title := QPLDecodeTextString(KeyName);
      EFNameRef := EmbeddedFilesNameTree.FindKey(KeyName);
      if Assigned(EFNameRef) then
      begin
        if EFNameRef.Obj is TPDFDictionary then
        begin
          FileSpecDict := TPDFDictionary(EFNameRef.Obj);
          Obj := FileSpecDict.FindValueByKeyName('Desc');
          if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFString then
            Description := QPLDecodeTextString(TPDFString(Obj).AsString);
          Obj := FileSpecDict.FindValueByKeyName('UF');
          if (not Assigned(Obj)) then
          begin
            Obj := FileSpecDict.FindValueByKeyName('F');
            if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
            if Obj is TPDFString then
              FileName := WideString(TPDFString(Obj).AsString);
          end else
          begin
            if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
            if Obj is TPDFString then
              FileName := TPDFString(Obj).AsTextString;
          end;
          Obj := FileSpecDict.FindValueByKeyName('EF');
          if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFDictionary then
          begin
            EFDict := TPDFDictionary(Obj);
            Obj := EFDict.FindValueByKeyName('F');
            if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
            if Obj is TPDFStream then
              Result := TPDFStream(Obj);
          end;
        end;
      end;
    finally
      EmbeddedFilesNameTree.Free;
    end;
  end;
end;

function TPDFDocument.GetEmbeddedFileIntProperty(Index,
  Tag: Integer): Integer;
var
  FStream: TPDFStream;
  FileName: WideString;
  Title: WideString;
  Description: WideString;
  Obj: TPDFObject;
  Params: TPDFDictionary;
begin
  Result := 0;
  FStream := GetEmbeddedFileStream(Index, FileName, Title, Description);
  if Assigned(FStream) then
  begin
    Obj := FStream.Dictionary.FindValueByKeyName('Params', True);
    if Obj is TPDFDictionary then
    begin
      Params := TPDFDictionary(Obj);
      if (Tag = 5) or (Tag = 6) then
      begin
        Obj := Params.FindValueByKeyName('Size', True);
        if Obj is TPDFNumeric then
          Result := TPDFNumeric(Obj).AsInteger;
      end;
    end;
  end;
end;

function TPDFDocument.GetEmbeddedFile(Index: Integer): TPDFIndRef;
var
  EmbeddedFilesDict: TPDFDictionary;
  EmbeddedFilesNameTree: TPDFNameTree;
  KeyName: AnsiString;
begin
  Result := nil;
  EmbeddedFilesDict := GetNameTree('EmbeddedFiles');
  if Assigned(EmbeddedFilesDict) then
  begin
    EmbeddedFilesNameTree := TPDFNameTree.Create(FStructure, EmbeddedFilesDict);
    try
      KeyName := EmbeddedFilesNameTree.KeyName(Index);
      Result := EmbeddedFilesNameTree.FindKey(KeyName);
    finally
      EmbeddedFilesNameTree.Free;
    end;
  end;
end;

function TPDFDocument.GetEmbeddedFileContentToString(
  Index: Integer): AnsiString;
var
  FStream: TPDFStream;
  FileName: WideString;
  Title: WideString;
  Description: WideString;
begin
  Result := '';
  FStream := GetEmbeddedFileStream(Index, FileName, Title, Description);
  if Assigned(FStream) then
    Result := FStream.GetDecodedStream;
end;

function TPDFDocument.CreateTable(RowCount, ColumnCount: Integer): TPDFTable;
begin
  Result := nil;
  if ((RowCount > 0) and (ColumnCount > 0)) then
  begin
    Result := TPDFTable.Create(RowCount, ColumnCount);
    SetLength(FTables, Length(FTables) + 1);
    FTables[Length(FTables) - 1] := Result;
  end;
end;

function TPDFDocument.FindTable(Table: TPDFTable): TPDFTable;
var
  X: Integer;
begin
  Result := nil;
  X := 0;
  while (X < Length(FTables)) and (not Assigned(Result)) do
  begin
    if (FTables[X] = Table) then
    begin
      Result := FTables[X];
    end else
    begin
      Inc(X);
    end;
  end;
end;

function TPDFDocument.DrawTableRows(Table: TPDFTable; Left, Top, Height: Double;
  FirstRow, LastRow: Integer): Double;
begin
  Result := Table.DrawTableRows(Left, Top, Height, FirstRow, LastRow, Self);
end;

procedure TPDFDocument.SetBaseURL(const NewBaseURL: AnsiString);
var
  ID: TPDFDictionary;
  Obj: TPDFObject;
begin
  ID := RootDict;
  Obj := ID.FindValueByKeyName('URI', True);
  if not (Obj is TPDFDictionary) then
  begin
    Obj := FStructure.NewDictionary;
    ID.Add('URI', Obj);
  end;
  TPDFDictionary(Obj).Add('Base', FStructure.NewString(NewBaseURL));
end;

function TPDFDocument.NewEMFFromStream(InStream: TStream; FontOptions,
  GeneralOptions: Integer): TPDFImage;
var
  Image: TPDFImage;
  ImageName: AnsiString;
  X: Integer;
begin
  Inc(IndexCount);
  ImageName := 'QuickPDFIm' + QPLRandomID;

  Image := TPDFImage.Create(FStructure, ImageName, FIncludedFonts);
  Image.Compress := 1;
  if GeneralOptions = 1 then
    Image.GDIPlusSettings := ImageGDIPlusSettings;

  if (FUseExistingFonts = 1) then
  begin
    for X := 0 to FLastImageFontList.Count - 1 do
    begin
      FIncludedFonts.Add(FLastImageFontList[X]);
    end;
  end;

  if Image.NewEMFFromStream(InStream, FontOptions, GeneralOptions) then
  begin
    FLastImageFontList.Clear;
    for X := 0 to IncludedFonts.Count - 1 do
    begin
      if (FFonts.IndexOf(IncludedFonts[X]) < 0) then
      begin
        FFonts.Add(IncludedFonts[X]);
      end;
      FLastImageFontList.Add(IncludedFonts[X]);
    end;

    if (GeneralOptions = 1) then
    begin
      Image.ImageType := itBMP;
    end else
    begin
      Image.ImageType := itEMF;
    end;

    FImages.Add(Image);
    Result := Image;
  end else
  begin
    Image.Free;
    Result := nil;
  end;
end;

function TPDFDocument.NewEMFFromStreamEx(InStream: TStream; FontOptions,
  GeneralOptions, Options: Integer): TPDFImage;
var
  Image: TPDFImage;
  ImageName: AnsiString;
  X: Integer;
begin
  Inc(IndexCount);
  ImageName := 'QuickPDFIm' + QPLRandomID;

  Image := TPDFImage.Create(FStructure, ImageName, FIncludedFonts);
  Image.Compress := 1;
  if GeneralOptions = 1 then
    Image.GDIPlusSettings := ImageGDIPlusSettings;
  if (GeneralOptions = 2) then
    Image.RecompressImage := True;

  if (FUseExistingFonts = 1) then
  begin
    for X := 0 to FLastImageFontList.Count - 1 do
    begin
      IncludedFonts.Add(FLastImageFontList[X]);
    end;
  end;

  //if FFonts.Count > 0 then
  //  Image.DefaultFont := GetFont(0);

  if Image.NewEMFFromStream(InStream, FontOptions, GeneralOptions) then
  begin
    FLastImageFontList.Clear;
    //for X := 0 to Image.IncludedFonts.Count - 1 do
    for X := 0 to IncludedFonts.Count - 1 do
    begin
      //if (FFonts.IndexOf(Image.IncludedFonts[X]) < 0) then
      if (FFonts.IndexOf(IncludedFonts[X]) < 0) then
      begin
        //FFonts.Add(Image.IncludedFonts[X]);
        FFonts.Add(IncludedFonts[X]);
      end;
      //FLastImageFontList.Add(Image.IncludedFonts[X]);
      FLastImageFontList.Add(IncludedFonts[X]);
    end;

    if (GeneralOptions = 1) then
    begin
      Image.ImageType := itBMP;
    end else
    begin
      Image.ImageType := itEMF;
    end;

    FImages.Add(Image);
    Result := Image;
  end else
  begin
    Image.Free;
    Result := nil;
  end;
end;


function TPDFDocument.GetAnnotDest(AnnotRef: TPDFIndRef): TPDFArray;
var
  Obj: TPDFObject;
  AnnotDict: TPDFDictionary;
  AnnotActionDict: TPDFDictionary;
  S: AnsiString;
  DestNames: TPDFDictionary;
begin
  Result := nil;
  if AnnotRef is TPDFIndRef then
  begin
    Obj := AnnotRef.Obj;
    if Obj is TPDFDictionary then
    begin
      AnnotDict := TPDFDictionary(Obj);
      Obj := AnnotDict.FindValueByKeyName('Dest', True);
      if Assigned(Obj) then
      begin
        if Obj is TPDFString then
        begin
          DestNames := GetNameTree('Dests');
          if Assigned(DestNames) then
            Obj := NameTreeLookup(DestNames, TPDFString(Obj).AsString);
          if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFDictionary then
            Obj := TPDFDictionary(Obj).FindValueByKeyName('D', True);
        end;
        if Assigned(Obj) then
        begin
          S := Obj.Output;
          if Obj is TPDFArray then
            Result := TPDFArray(Obj);
        end;
      end else
      begin
        Obj := AnnotDict.FindValueByKeyName('A', True);
        if Obj is TPDFDictionary then
        begin
          AnnotActionDict := TPDFDictionary(Obj);
          Obj := AnnotActionDict.FindValueByKeyName('S');
          if (Obj is TPDFName) and (TPDFName(Obj).Name = 'GoTo') then
          begin
            Obj := AnnotActionDict.FindValueByKeyName('D', True);
            if Obj is TPDFArray then
              Result := TPDFArray(Obj);
          end else
          if (Obj is TPDFName) and (TPDFName(Obj).Name = 'GoToR') then
          begin
            Obj := AnnotActionDict.FindValueByKeyName('D', True);
            if Obj is TPDFArray then
              Result := TPDFArray(Obj);
          end;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.GetBaseURL: AnsiString;
var
  ID: TPDFDictionary;
  Obj: TPDFObject;
  URIDict: TPDFDictionary;
begin
  Result := '';
  ID := RootDict;
  Obj := ID.FindValueByKeyName('URI', True);
  if (Obj is TPDFDictionary) then
  begin
    URIDict := TPDFDictionary(Obj);
    Obj := URIDict.FindValueByKeyName('Base', True);
    if (Obj is TPDFString) then
    begin
      Result := TPDFString(Obj).AsString;
    end;
  end;
end;

function TPDFDocument.GetOutlineAction(OutlineRef: TPDFIndRef): TPDFDictionary;
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
begin
  Result := nil;
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('A', True);
      if Obj is TPDFDictionary then
      begin
        Result := TPDFDictionary(Obj);
      end;
    end;
  end;
end;

procedure TPDFDocument.CloneOutlineAction(OutlineRef: TPDFIndRef);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  NewDict: TPDFDictionary;
  ReplacementDict: TPDFDictionary;
  IR: TPDFIndRef;
  X: Integer;
begin
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      Obj := OutlineDict.FindValueByKeyName('A', True);
      if Obj is TPDFDictionary then
      begin
        ActionDict := TPDFDictionary(Obj);
        NewDict := FStructure.NewDictionary;
        NewDict.AddDict(ActionDict);
        OutlineDict.Add('A', NewObjRef(NewDict));

        for X := 0 to NewDict.Count - 1 do
        begin
          if NewDict.Entry[X].Value is TPDFIndRef then
          begin
            IR := TPDFIndRef(NewDict.Entry[X].Value);
            Obj := IR.Obj;
            if Obj is TPDFDictionary then
            begin
              ReplacementDict := FStructure.NewDictionary;
              ReplacementDict.AddDict(TPDFDictionary(Obj));
              NewDict.Add(NewDict.Entry[X].Key.Name, NewObjRef(ReplacementDict));
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.FindPage(PageRef: TPDFIndRef): Integer;
var
  PageNumber: Integer;
  Found: Boolean;
  TestRef: TPDFIndRef;
begin
  Result := 0;
  PageNumber := 0;
  Found := False;
  repeat
    Inc(PageNumber);
    TestRef := FPageTree.GetPageRef(PageNumber);
    if (TestRef.ObjNum = PageRef.ObjNum) and
      (TestRef.GenNum = PageRef.GenNum) then
    begin
      Found := True;
      Result := PageNumber;
    end;
  until Found or (PageNumber = FPageTree.PageCount);
end;

procedure TPDFDocument.EncodePermKey;
begin
  PermKey := $FFFFFFFC;

  if not (ppCanPrint in FPermissions) then
    PermKey := PermKey and $FFFFFFF8;
  if not (ppCanChange in FPermissions) then
    PermKey := PermKey and $FFFFFFF4;
  if not (ppCanCopy in FPermissions) then
    PermKey := PermKey and $FFFFFFEC;
  if not (ppCanAddNotes in FPermissions) then
    PermKey := PermKey and $FFFFFFDC;

  if FEncryptionStrength <> esStd then
  begin
    if not (ppCanFillFields in FExtraPermissions) then
      PermKey := PermKey and $FFFFFEFF;
    if not (ppCanCopyAccess in FExtraPermissions) then
      PermKey := PermKey and $FFFFFDFF;
    if not (ppCanAssemble in FExtraPermissions) then
      PermKey := PermKey and $FFFFFBFF;
    if not (ppCanPrintFull in FExtraPermissions) then
      PermKey := PermKey and $FFFFF7FF;
  end;
end;

function TPDFDocument.RemoveEmbeddedFile(Index: Integer): Boolean;
var
  EmbeddedFilesDict: TPDFDictionary;
  EmbeddedFilesNameTree: TPDFNameTree;
  EFNameRef: TPDFIndRef;
  FileSpecDict: TPDFDictionary;
  Obj: TPDFObject;
  EFDict: TPDFDictionary;
  KeyName: AnsiString;
begin
  Result := False;
  EmbeddedFilesDict := GetNameTree('EmbeddedFiles');
  if Assigned(EmbeddedFilesDict) then
  begin
    EmbeddedFilesNameTree := TPDFNameTree.Create(FStructure, EmbeddedFilesDict);
    try
      KeyName := EmbeddedFilesNameTree.KeyName(Index);
      EFNameRef := EmbeddedFilesNameTree.FindKey(KeyName);
      if Assigned(EFNameRef) then
      begin
        if EFNameRef.Obj is TPDFDictionary then
        begin
          FileSpecDict := TPDFDictionary(EFNameRef.Obj);
          Obj := FileSpecDict.FindValueByKeyName('EF');
          if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFDictionary then
          begin
            EFDict := TPDFDictionary(Obj);
            Obj := EFDict.FindValueByKeyName('F');
            if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
            if Obj is TPDFStream then
            begin
              TPDFStream(Obj).SetTo('');
            end;
          end;
        end;
        EmbeddedFilesNameTree.DeleteKey(KeyName);
        Result := True;
      end;
    finally
      EmbeddedFilesNameTree.Free;
    end;
  end;
end;

function TPDFDocument.RemoveGlobalJavaScript(
  const PackageName: WideString): Boolean;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  NamesDict: TPDFDictionary;
  JSNameDict: TPDFDictionary;
  A: TPDFArray;
  NT: TPDFNameTree;
  JSRef: TPDFIndRef;
  JSDict: TPDFDictionary;
  PackageNameU: AnsiString;
begin
  PackageNameU := QPLEncodeTextString(PackageName);

  Result := False;
  Root := GetRootDict;
  Obj := Root.FindValueByKeyName('Names');
  if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
  if Obj is TPDFDictionary then
  begin
    NamesDict := TPDFDictionary(Obj);
  end else
  begin
    NamesDict := FStructure.NewDictionary;
    Root.Add('Names', NamesDict);
  end;

  Obj := NamesDict.FindValueByKeyName('JavaScript');
  if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
  if Obj is TPDFDictionary then
  begin
    JSNameDict := TPDFDictionary(Obj);
  end else
  begin
    JSNameDict := FStructure.NewDictionary;
    NamesDict.Add('JavaScript', JSNameDict);
    A := FStructure.NewArray;
    JSNameDict.Add('Names', A);
  end;
  NT := TPDFNameTree.Create(FStructure, JSNameDict);
  try
    if NT.HasKey(PackageNameU) then
    begin
      Result := True;
      JSRef := NT.FindKey(PackageNameU);
      Obj := JSRef.Obj;
      if Obj is TPDFDictionary then
      begin
        JSDict := TPDFDictionary(Obj);
        Obj := JSDict.FindValueByKeyName('JS');
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFString then
        begin
          TPDFString(Obj).SetToTextString('');
        end;
        if Obj is TPDFStream then
        begin
          TPDFStream(Obj).SetToTextString('', False);
        end;
      end;
      NT.DeleteKey(PackageNameU);
    end;
  finally
    NT.Free;
  end;
end;

procedure TPDFDocument.RemoveInfo(const Key: AnsiString);
var
  ID: TPDFDictionary;
  Obj: TPDFObject;
begin
  if (GetEncrypted = peDecrypted) then
  begin
    ID := InfoDict;
    ID.DeleteEntryByKeyName(Key);
    Obj := ID.FindValueByKeyName(Key, True);
    if Obj is TPDFStream then
    begin
      TPDFStream(Obj).SetTo('', False);
    end;
    ID.DeleteEntryByKeyName(Key);
  end;
end;

function TPDFDocument.SetEmbeddedFileStrProperty(Index, Tag: Integer;
  NewValue: WideString): Boolean;
var
  FStream: TPDFStream;
  FileName: WideString;
  Title: WideString;
  Description: WideString;
  Obj: TPDFObject;
  Params: TPDFDictionary;
begin
  Result := False;
  FStream := GetEmbeddedFileStream(Index, FileName, Title, Description);
  if Tag = 1 then
  begin
    if FileName <> NewValue then
    begin
      SetEmbeddedFileName(Index, NewValue);
      Result := True;
    end;
  end else
  if Tag = 5 then
  begin
    if Title <> NewValue then
    begin
      SetEmbeddedTitle(Index, NewValue);
      Result := True;
    end;
  end else
  if Tag = 7 then
  begin
    if Description <> NewValue then
    begin
      SetEmbeddedDescription(Index, NewValue);
      Result := True;
    end;
  end else
  if Assigned(FStream) then
  begin
    if Tag = 2 then
    begin
      Obj := FStream.Dictionary.FindValueByKeyName('Subtype', True);
      if Obj is TPDFName then
      begin
        TPDFName(Obj).SetTo(QPLEncodeTextString(NewValue));
        Result := True;
      end;
    end else
    begin
      Obj := FStream.Dictionary.FindValueByKeyName('Params', True);
      if Obj is TPDFDictionary then
      begin
        Params := TPDFDictionary(Obj);
        if Tag = 3 then
        begin
          Obj := Params.FindValueByKeyName('CreationDate', True);
          if Obj is TPDFString then
          begin
            TPDFString(Obj).SetToTextString(NewValue);
            Result := True;
          end;
        end else
        if Tag = 4 then
        begin
          Obj := Params.FindValueByKeyName('ModDate', True);
          if Obj is TPDFString then
          begin
            TPDFString(Obj).SetToTextString(NewValue);
            Result := True;
          end;
        end;
      end;
    end;
  end;
end;

procedure TPDFDocument.SetEmbeddedDescription(Index: Integer;
  const NewDescription: WideString);
var
  EmbeddedFilesDict: TPDFDictionary;
  EmbeddedFilesNameTree: TPDFNameTree;
  EFNameRef: TPDFIndRef;
  FileSpecDict: TPDFDictionary;
  Obj: TPDFObject;
  KeyName: AnsiString;
begin
  EmbeddedFilesDict := GetNameTree('EmbeddedFiles');
  if Assigned(EmbeddedFilesDict) then
  begin
    EmbeddedFilesNameTree := TPDFNameTree.Create(FStructure, EmbeddedFilesDict);
    try
      KeyName := EmbeddedFilesNameTree.KeyName(Index);
      EFNameRef := EmbeddedFilesNameTree.FindKey(KeyName);
      if Assigned(EFNameRef) then
      begin
        if EFNameRef.Obj is TPDFDictionary then
        begin
          FileSpecDict := TPDFDictionary(EFNameRef.Obj);
          Obj := FileSpecDict.FindValueByKeyName('Desc');
          if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFString then
            TPDFString(Obj).SetTo(QPLEncodeTextString(NewDescription));
          if Obj = nil then
            FileSpecDict.Add('Desc', FStructure.NewString(QPLEncodeTextString(NewDescription)));
        end;
      end;
    finally
      EmbeddedFilesNameTree.Free;
    end;
  end;
end;

procedure TPDFDocument.SetEmbeddedFileName(Index: Integer;
  const NewFileName: WideString);
var
  EmbeddedFilesDict: TPDFDictionary;
  EmbeddedFilesNameTree: TPDFNameTree;
  EFNameRef: TPDFIndRef;
  FileSpecDict: TPDFDictionary;
  Obj: TPDFObject;
  KeyName: AnsiString;
begin
  EmbeddedFilesDict := GetNameTree('EmbeddedFiles');
  if Assigned(EmbeddedFilesDict) then
  begin
    EmbeddedFilesNameTree := TPDFNameTree.Create(FStructure, EmbeddedFilesDict);
    try
      KeyName := EmbeddedFilesNameTree.KeyName(Index);
      EFNameRef := EmbeddedFilesNameTree.FindKey(KeyName);
      if Assigned(EFNameRef) then
      begin
        if EFNameRef.Obj is TPDFDictionary then
        begin
          FileSpecDict := TPDFDictionary(EFNameRef.Obj);
          Obj := FileSpecDict.FindValueByKeyName('F');
          if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFString then
            TPDFString(Obj).SetTo(QPLWideStringToLatin1(NewFileName));

          Obj := FileSpecDict.FindValueByKeyName('UF');
          if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFString then
            TPDFString(Obj).SetToTextString(NewFileName);
        end;
      end;
    finally
      EmbeddedFilesNameTree.Free;
    end;
  end;
end;

procedure TPDFDocument.SetEmbeddedTitle(Index: Integer;
  const NewTitle: WideString);
var
  EmbeddedFilesDict: TPDFDictionary;
  EmbeddedFilesNameTree: TPDFNameTree;
  EFNameRef: TPDFIndRef;
  KeyName: AnsiString;
begin
  EmbeddedFilesDict := GetNameTree('EmbeddedFiles');
  if Assigned(EmbeddedFilesDict) then
  begin
    EmbeddedFilesNameTree := TPDFNameTree.Create(FStructure, EmbeddedFilesDict);
    try
      KeyName := EmbeddedFilesNameTree.KeyName(Index);
      EFNameRef := EmbeddedFilesNameTree.FindKey(KeyName);
      if Assigned(EFNameRef) then
      begin
        EmbeddedFilesNameTree.AddKey(QPLEncodeTextString(NewTitle), EFNameRef);
        EmbeddedFilesNameTree.DeleteKey(KeyName);
      end;
    finally
      EmbeddedFilesNameTree.Free;
    end;
  end;
end;

procedure TPDFDocument.SetExtensionLevel(const ExtensionLevel: AnsiString);
var
  Root: TPDFDictionary;
begin
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Root.Add('Extensions',
      FStructure.Decode('<</ADBE<</BaseVersion/1.7/ExtensionLevel ' +
      ExtensionLevel + '>>>>'));
  end;
end;

function TPDFDocument.SetNumberViewerPreferences(const Key: AnsiString;
  Value: Integer): Boolean;
var
  Root: TPDFDictionary;
  O: TPDFObject;
  VP: TPDFDictionary;
begin
  Root := GetRootDict;
  Result := False;
  if Assigned(Root) then
  begin
    O := Root.FindValueByKeyName('ViewerPreferences');
    if O is TPDFDictionary then
    begin
      VP := TPDFDictionary(O);
      VP.PurgeKey(Key);
    end else
    begin
      VP := FStructure.NewDictionary;
      Root.Add('ViewerPreferences', VP);
    end;
    VP.Add(Key, FStructure.NewNumeric(Value));
    Result := True;
  end;
end;

function TPDFDocument.GetOptionalContentConfigCount: Integer;
var
  Root: TPDFDictionary;
  Obj: TPDFObject;
  OCPropertiesDict: TPDFDictionary;
begin
  Result := 0;
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('OCProperties', True);
    if (Obj is TPDFDictionary) then
    begin
      OCPropertiesDict := TPDFDictionary(Obj);
      Obj := OCPropertiesDict.FindValueByKeyName('D', True);
      if (Obj is TPDFDictionary) then
      begin
        Result := 1;
        Obj := OCPropertiesDict.FindValueByKeyName('Configs', True);
        if Obj is TPDFArray then
        begin
          Inc(Result, TPDFArray(Obj).Count);
        end;
      end;
    end;
  end;
end;

// ConfigID = 1 is the default configuration dictionary (/D entry)
// ConfigID >= 2 is for other configuration dictionaries (/Configs entry)
// Returns 0 for an error
// Returns 1 if the OCG is ON
// Returns 2 if the OCG is OFF
// Returns 3 if the OCG is unchanged
function TPDFDocument.GetOptionalContentConfigState(ConfigID: Integer;
  OCGRef: TPDFIndRef): Integer;
var
  ConfigDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := 0;

  ConfigDict := GetOptionalContentConfigDict(ConfigID);
  if (Assigned(ConfigDict)) then
  begin
    // Base state for default config is ON
    Result := 1;

    if (ConfigID > 1) then
    begin
      Obj := ConfigDict.FindValueByKeyName('BaseState', True);
      if (Obj is TPDFName) then
      begin
        if (TPDFName(Obj).Name = 'ON') then
        begin
          Result := 1;
        end;
        if (TPDFName(Obj).Name = 'OFF') then
        begin
          Result := 2;
        end;
        if (TPDFName(Obj).Name = 'Unchanged') then
        begin
          Result := 3;
        end;
      end;
    end;

    Obj := ConfigDict.FindValueByKeyName('ON', True);
    if Obj is TPDFArray then
    begin
      if (TPDFArray(Obj).HasMatchingChild(OCGRef.Output)) then
      begin
        // The OCG is in the /ON array
        Result := 1;
      end;
    end;

    Obj := ConfigDict.FindValueByKeyName('OFF', True);
    if Obj is TPDFArray then
    begin
      if (TPDFArray(Obj).HasMatchingChild(OCGRef.Output)) then
      begin
        // The OCG is in the /OFF array
        Result := 2;
      end;
    end;
  end;
end;

function TPDFDocument.SetOptionalContentConfigLocked(ConfigID: Integer;
  OCGRef: TPDFIndRef; Locked: Boolean): Boolean;
var
  ConfigDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := False;
  ConfigDict := GetOptionalContentConfigDict(ConfigID);
  if (Assigned(ConfigDict)) then
  begin
    Obj := ConfigDict.FindValueByKeyName('Locked', True);
    if (not Assigned(Obj)) then
    begin
      Obj := FStructure.NewArray;
      ConfigDict.Add('Locked', Obj);
    end;
    if (Obj is TPDFArray) then
    begin
      if (TPDFArray(Obj).HasMatchingChild(OCGRef.Output)) then
      begin
        // The OCG is in the /Locked array
        if (not Locked) then
        begin
          // Remove it
          TPDFArray(Obj).DeleteObj(OCGRef, True);
        end;
      end else
      begin
        // The OCG is not in the /Locked array
        if (Locked) then
        begin
          // Add it
          TPDFArray(Obj).Add(OCGRef);
        end;
      end;
    end;
  end;
end;

function TPDFDocument.SetOptionalContentConfigState(ConfigID: Integer;
  OCGRef: TPDFIndRef; NewState: Integer): Boolean;
var
  ConfigDict: TPDFDictionary;
  Obj: TPDFObject;
  BaseState: Integer;
  InON: Boolean;
  InOFF: Boolean;
begin
  Result := False;
  ConfigDict := GetOptionalContentConfigDict(ConfigID);
  if (Assigned(ConfigDict)) then
  begin
    // Base state for default config is ON
    BaseState := 1;

    if (ConfigID > 1) then
    begin
      Obj := ConfigDict.FindValueByKeyName('BaseState', True);
      if (Obj is TPDFName) then
      begin
        if (TPDFName(Obj).Name = 'ON') then
        begin
          BaseState := 1;
        end;
        if (TPDFName(Obj).Name = 'OFF') then
        begin
          BaseState := 2;
        end;
        if (TPDFName(Obj).Name = 'Unchanged') then
        begin
          BaseState := 3;
        end;
      end;
    end;

    if (NewState = 3) and (BaseState <> 3) then
    begin
      // (NewState = Unchanged) but BaseState isn't Unchanged, so
      // the change isn't possible
      Result := False;
    end else
    begin
      // Default for (NewState = BaseState)
      InON := False;
      InOFF := False;

      if (NewState <> BaseState) then
      begin
        if ((BaseState = 1) and (NewState = 2)) then
        begin
          // BaseState is ON, NewState is OFF
          InON := False;
          InOFF := True;
        end else
        if ((BaseState = 2) and (NewState = 1)) then
        begin
          // BaseState is OFF, NewState is ON
          InON := True;
          InOFF := False;
        end;
      end;

      Obj := ConfigDict.FindValueByKeyName('ON', True);
      if (not Assigned(Obj)) then
      begin
        Obj := FStructure.NewArray;
        ConfigDict.Add('ON', Obj);
      end;
      if Obj is TPDFArray then
      begin
        if (TPDFArray(Obj).HasMatchingChild(OCGRef.Output)) then
        begin
          // The OCG is in the /ON array
          if (not InON) then
          begin
            // Remove it
            TPDFArray(Obj).DeleteObj(OCGRef, True);
          end;
        end else
        begin
          // The OCG is not in the /ON array
          if (InON) then
          begin
            // Add it
            TPDFArray(Obj).Add(OCGRef);
          end;
        end;
      end;

      Obj := ConfigDict.FindValueByKeyName('OFF', True);
      if (not Assigned(Obj)) then
      begin
        Obj := FStructure.NewArray;
        ConfigDict.Add('OFF', Obj);
      end;
      if Obj is TPDFArray then
      begin
        if (TPDFArray(Obj).HasMatchingChild(OCGRef.Output)) then
        begin
          // The OCG is in the /OFF array
          if (not InOFF) then
          begin
            // Remove it
            TPDFArray(Obj).DeleteObj(OCGRef, True);
          end;
        end else
        begin
          // The OCG is not in the /OFF array
          if (InOFF) then
          begin
            // Add it
            TPDFArray(Obj).Add(OCGRef);
          end;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.GetOptionalContentConfigDict(
  ConfigID: Integer): TPDFDictionary;
var
  Root: TPDFDictionary;
  Obj: TPDFObject;
  OCPropertiesDict: TPDFDictionary;
  ConfigsArray: TPDFArray;
begin
  Result := nil;
  Root := GetRootDict;
  if Assigned(Root) then
  begin
    Obj := Root.FindValueByKeyName('OCProperties', True);
    if (Obj is TPDFDictionary) then
    begin
      OCPropertiesDict := TPDFDictionary(Obj);
      if (ConfigID = 1) then
      begin
        Obj := OCPropertiesDict.FindValueByKeyName('D', True);
        if (Obj is TPDFDictionary) then
        begin
          Result := TPDFDictionary(Obj);
        end;
      end else
      if (ConfigID > 1) then
      begin
        Obj := OCPropertiesDict.FindValueByKeyName('Configs', True);
        if (Obj is TPDFArray) then
        begin
          ConfigsArray := TPDFArray(Obj);
          if (ConfigID >= (ConfigsArray.Count + 1)) then
          begin
            Obj := ConfigsArray.Item[ConfigID - 1];
            if Obj is TPDFIndRef then
            begin
              Obj := TPDFIndRef(Obj).Obj;
            end;
            if (Obj is TPDFDictionary) then
            begin
              Result := TPDFDictionary(Obj);
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TPDFDocument.GetOptionalContentConfigLocked(ConfigID: Integer;
  OCGRef: TPDFIndRef): Boolean;
var
  ConfigDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := False;

  ConfigDict := GetOptionalContentConfigDict(ConfigID);
  if (Assigned(ConfigDict)) then
  begin
    Obj := ConfigDict.FindValueByKeyName('Locked', True);
    if (Obj is TPDFArray) then
    begin
      if (TPDFArray(Obj).HasMatchingChild(OCGRef.Output)) then
      begin
        Result := True;
      end;
    end;
  end;
end;

function TPDFDocument.GetPageInheritedValue(Start: TPDFDictionary;
  const Key: AnsiString): TPDFObject;
var
  O: TPDFObject;
begin
  Result := nil;
  if Assigned(Start) then
  begin
    O := Start.FindValueByKeyName(Key, True);
    if Assigned(O) then
    begin
      Result := O;
    end else
    begin
      O := Start.FindValueByKeyName('Parent', True);
      if O is TPDFDictionary then
      begin
        Result := GetPageInheritedValue(TPDFDictionary(O), Key);
      end;
    end;
  end;
end;

procedure TPDFDocument.BalancePageTree;
var
  PageList: array of TPDFIndRef;
  Balancer: TDPLTreeBalancer;
  PageNumber: Integer;
  OldPage: Integer;
begin
  SetLength(PageList, GetPageCount);
  for PageNumber := 1 to Length(PageList) do
  begin
    PageList[PageNumber - 1] := FPageTree.GetPageRef(PageNumber);
  end;
  Balancer := TDPLTreeBalancer.Create;
  try
    Balancer.OnNewIndObj := NewIndObj;
    Balancer.OnIndObjLookup := GetIndObj;
    Balancer.Structure := FStructure;
    RootDict.Add('Pages', Balancer.Balance(PageList, 10));
  finally
    Balancer.Free;
  end;

  OldPage := FPageTree.Page;
  if Assigned(FPageTree) then FPageTree.Free;
  FPageTree := TPDFPageTree.Create(GetPagesDict, FImages, FImageLists, FTextLists, FIncludedFonts);
  FPageTree.OnDecrypt := PageDecrypt;
  FPageTree.OnDeleteObj := DeleteObj;
  FPageTree.OnFindPage := FindPage;
  FPageTree.Page := OldPage;
end;

procedure TPDFDocument.BuildIndObjIndex;
var
  X: Integer;
  K: Integer;
  I: Integer;
  J: Integer;
  N: Integer;
  Temp1: Integer;
  Temp2: Integer;
begin
  SetLength(FIndObjIndex, FIndObjList.Count);
  SetLength(FIndObjKey, FIndObjList.Count);
  for X := 0 to FIndObjList.Count - 1 do
  begin
    FIndObjIndex[X] := TPDFIndObj(FIndObjList[X]).FObjNum;
    FIndObjKey[X] := X;
  end;

  N := FIndObjList.Count;
  K := N div 2;
  while K > 0 do
  begin
    for I := K to N - 1 do
    begin
      Temp1 := FIndObjIndex[I];
      Temp2 := FIndObjKey[I];
      J := I;
      while (J >= K) and (FIndObjIndex[J - K] > Temp1) do
      begin
        FIndObjIndex[J] := FIndObjIndex[J - K];
        FIndObjKey[J] := FIndObjKey[J - K];
        J := J - K;
      end;
      FIndObjIndex[J] := Temp1;
      FIndObjKey[J] := Temp2;
    end;
    K := Round(K / 2.2);
  end;
end;

function TPDFDocument.GetOptionalContentConfigOrderCount(
  ConfigID: Integer): Integer;
var
  ConfigDict: TPDFDictionary;
  Obj: TPDFObject;
  OrderItems: TPDFOCGConfigOrderItems;
begin
  SetLength(OrderItems, 0);

  ConfigDict := GetOptionalContentConfigDict(ConfigID);
  if (Assigned(ConfigDict)) then
  begin
    Obj := ConfigDict.FindValueByKeyName('Order', True);
    if Obj is TPDFArray then
    begin
      BuildOptionalContentConfigOrderArray(TPDFArray(Obj), OrderItems, 1);
    end;
  end;

  Result := Length(OrderItems);
end;

function TPDFDocument.GetOptionalContentConfigOrderItemOCG(ConfigID,
  ItemIndex: Integer): TPDFIndRef;
var
  ConfigDict: TPDFDictionary;
  Obj: TPDFObject;
  OrderItems: TPDFOCGConfigOrderItems;
begin
  SetLength(OrderItems, 0);

  ConfigDict := GetOptionalContentConfigDict(ConfigID);
  if (Assigned(ConfigDict)) then
  begin
    Obj := ConfigDict.FindValueByKeyName('Order', True);
    if Obj is TPDFArray then
    begin
      BuildOptionalContentConfigOrderArray(TPDFArray(Obj), OrderItems, 1);
    end;
  end;

  Result := nil;
  if ((ItemIndex >= 1) and (ItemIndex <= Length(OrderItems))) then
  begin
    if (OrderItems[ItemIndex - 1].ItemType = 1) then
    begin
      Result := OrderItems[ItemIndex - 1].ItemOCG;
    end;
  end;
end;

function TPDFDocument.GetOptionalContentConfigOrderItemLabel(ConfigID,
  ItemIndex: Integer): WideString;
var
  ConfigDict: TPDFDictionary;
  Obj: TPDFObject;
  OrderItems: TPDFOCGConfigOrderItems;
begin
  SetLength(OrderItems, 0);

  ConfigDict := GetOptionalContentConfigDict(ConfigID);
  if (Assigned(ConfigDict)) then
  begin
    Obj := ConfigDict.FindValueByKeyName('Order', True);
    if Obj is TPDFArray then
    begin
      BuildOptionalContentConfigOrderArray(TPDFArray(Obj), OrderItems, 1);
    end;
  end;

  Result := '';
  if ((ItemIndex >= 1) and (ItemIndex <= Length(OrderItems))) then
  begin
    Result := OrderItems[ItemIndex - 1].ItemLabel;
  end;
end;

function TPDFDocument.GetOptionalContentConfigOrderItemLevel(ConfigID,
  ItemIndex: Integer): Integer;
var
  ConfigDict: TPDFDictionary;
  Obj: TPDFObject;
  OrderItems: TPDFOCGConfigOrderItems;
begin
  SetLength(OrderItems, 0);

  ConfigDict := GetOptionalContentConfigDict(ConfigID);
  if (Assigned(ConfigDict)) then
  begin
    Obj := ConfigDict.FindValueByKeyName('Order', True);
    if Obj is TPDFArray then
    begin
      BuildOptionalContentConfigOrderArray(TPDFArray(Obj), OrderItems, 1);
    end;
  end;

  Result := 0;
  if ((ItemIndex >= 1) and (ItemIndex <= Length(OrderItems))) then
  begin
    Result := OrderItems[ItemIndex - 1].ItemLevel;
  end;
end;

function TPDFDocument.GetOptionalContentConfigOrderItemType(ConfigID,
  ItemIndex: Integer): Integer;
var
  ConfigDict: TPDFDictionary;
  Obj: TPDFObject;
  OrderItems: TPDFOCGConfigOrderItems;
begin
  SetLength(OrderItems, 0);

  ConfigDict := GetOptionalContentConfigDict(ConfigID);
  if (Assigned(ConfigDict)) then
  begin
    Obj := ConfigDict.FindValueByKeyName('Order', True);
    if Obj is TPDFArray then
    begin
      BuildOptionalContentConfigOrderArray(TPDFArray(Obj), OrderItems, 1);
    end;
  end;

  Result := 0;
  if ((ItemIndex >= 1) and (ItemIndex <= Length(OrderItems))) then
  begin
    Result := OrderItems[ItemIndex - 1].ItemType;
  end;
end;

procedure TPDFDocument.BuildOptionalContentConfigOrderArray(
  Source: TPDFArray; var ItemList: TPDFOCGConfigOrderItems; Level: Integer);
var
  X: Integer;
  LevelOffset: Integer;
  Obj: TPDFObject;
  ValidItem: Boolean;
begin
  // Start with items having the same level
  LevelOffset := 0;

  for X := 0 to Source.Count - 1 do
  begin
    ValidItem := False;

    if ((X = 0) and (Source.Item[X] is TPDFString)) then
    begin
      ValidItem := True;
      SetLength(ItemList, Length(ItemList) + 1);
      ItemList[Length(ItemList) - 1].ItemType := 2;  // Text label
      ItemList[Length(ItemList) - 1].ItemOCG := nil;
      ItemList[Length(ItemList) - 1].ItemLabel := OCGName(TPDFIndRef(Source.Item[X]));
      ItemList[Length(ItemList) - 1].ItemLevel := Level + LevelOffset;

      // The following items will be one level down
      Inc(LevelOffset);
    end else
    if (Source.Item[X] is TPDFIndRef) then
    begin
      Obj := TPDFIndRef(Source.Item[X]).Obj;
      if Obj is TPDFArray then
      begin
        // Nested array
        ValidItem := True;
        BuildOptionalContentConfigOrderArray(TPDFArray(Obj), ItemList,
          Level + LevelOffset + 1);
      end else
      if Obj is TPDFDictionary then
      begin
        ValidItem := True;
        SetLength(ItemList, Length(ItemList) + 1);
        ItemList[Length(ItemList) - 1].ItemType := 1;  // OCG item
        ItemList[Length(ItemList) - 1].ItemOCG := TPDFIndRef(Source.Item[X]);
        ItemList[Length(ItemList) - 1].ItemLabel := OCGName(TPDFIndRef(Source.Item[X]));
        ItemList[Length(ItemList) - 1].ItemLevel := Level + LevelOffset;
      end;
    end else
    if (Source.Item[X] is TPDFArray) then
    begin
      Obj := Source.Item[X];
      // Nested array
      ValidItem := True;
      BuildOptionalContentConfigOrderArray(TPDFArray(Obj), ItemList,
        Level + LevelOffset + 1);
    end;

    if (not ValidItem) then
    begin
      SetLength(ItemList, Length(ItemList) + 1);
      ItemList[Length(ItemList) - 1].ItemType := 0;  // Invalid item
      ItemList[Length(ItemList) - 1].ItemOCG := nil;
      ItemList[Length(ItemList) - 1].ItemLabel := '';
      ItemList[Length(ItemList) - 1].ItemLevel := Level + LevelOffset;
    end;
  end;
end;

function TPDFDocument.FontExists(ObjNum, GenNum: Integer): Boolean;
var
  X: Integer;
  Found: Boolean;
  FontIndRef: TPDFIndRef;
begin
  X := 0;
  Found := False;
  while (X < FFonts.Count) and (not Found) do
  begin
    FontIndRef := TPDFFont(FFonts.Items[X]).IndRef;
    if ((FontIndRef.ObjNum = ObjNum) and (FontIndRef.GenNum = GenNum)) then
    begin
      Found := True;
    end else
    begin
      Inc(X);
    end;
  end;
  Result := Found;
end;

procedure TPDFDocument.SetOutlineRemoteDestination(OutlineRef: TPDFIndRef;
  const FileName: AnsiString; OpenPage, Zoom, DestType: Integer; Left, Top,
  Right, Bottom: Double; NewWindow: Boolean);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
  ActionDict: TPDFDictionary;
  ActionRef: TPDFIndRef;
  FileSpec: AnsiString;
  Dest: TPDFArray;
begin
  if (QPLPos(':', FileName) > 0) or (QPLPos('\', FileName) > 0) then
  begin
    FileSpec := QPLStringReplace(FileName, '/', #255, [rfReplaceAll]);
    FileSpec := QPLStringReplace(FileSpec, '\', '/', [rfReplaceAll]);
    FileSpec := QPLStringReplace(FileSpec, #255, '\/', [rfReplaceAll]);
    if QPLCopy(FileSpec, 2, 1) = ':' then
    begin
      FileSpec := '/' + QPLCopy(FileSpec, 1, 1) + '/' + QPLCopy(FileSpec, 3, MaxInt);
      if QPLCopy(FileSpec, 3, 2) = '//' then Delete(FileSpec, 3, 1);
    end;
  end else
    FileSpec := FileName;
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      OutlineDict.PurgeKey('Dest');

      Obj := OutlineDict.FindValueByKeyName('A', True);
      if Obj is TPDFDictionary then
        ActionDict := TPDFDictionary(Obj)
      else
      begin
        ActionDict := FStructure.NewDictionary;
        ActionRef := NewObjRef(ActionDict);
        OutlineDict.Add('A', ActionRef);
      end;
      ActionDict.Add('Type', FStructure.NewName('Action'));
      ActionDict.Add('S', FStructure.NewName('GoToR'));
      ActionDict.Add('F', FStructure.NewString(FileSpec));

      Dest := CreateDestination(FStructure.NewNumeric(OpenPage), Zoom, DestType, Left, Top, Right, Bottom);

      ActionDict.Add('D', Dest);
      ActionDict.Add('NewWindow', FStructure.NewBoolean(NewWindow));
    end;
  end;
end;

function TPDFDocument.CreateDestination(TargetPage: TPDFObject;
  Zoom, DestType: Integer; Left, Top, Right, Bottom: Double;
  CreateReference: Boolean): TPDFArray;
var
  Dest: TPDFArray;
begin
  Dest := FStructure.NewArray;
  Dest.Add(TargetPage);

  case DestType of
    1:
    begin
      Dest.Add(FStructure.NewName('XYZ'));
      Dest.Add(FStructure.NewNumeric(Left));
      Dest.Add(FStructure.NewNumeric(Top));
      Dest.Add(FStructure.NewNumeric(Zoom / 100));
     end;
    2: Dest.Add(FStructure.NewName('Fit'));
    3:
    begin
      Dest.Add(FStructure.NewName('FitH'));
      Dest.Add(FStructure.NewNumeric(Top));
    end;
    4:
    begin
      Dest.Add(FStructure.NewName('FitV'));
      Dest.Add(FStructure.NewNumeric(Left));
    end;
    5:
    begin
      Dest.Add(FStructure.NewName('FitR'));
      Dest.Add(FStructure.NewNumeric(Left));
      Dest.Add(FStructure.NewNumeric(Bottom));
      Dest.Add(FStructure.NewNumeric(Right));
      Dest.Add(FStructure.NewNumeric(Top));
    end;
    6: Dest.Add(FStructure.NewName('FitB'));
    7:
    begin
      Dest.Add(FStructure.NewName('FitBH'));
      Dest.Add(FStructure.NewNumeric(Top));
    end;
    8:
    begin
      Dest.Add(FStructure.NewName('FitBV'));
      Dest.Add(FStructure.NewNumeric(Left));
    end;
  end;

  Result := Dest;

  if (CreateReference) then
  begin
    NewObjRef(Result);
  end;
end;

function TPDFDocument.CreateNewObject: Integer;
begin
  Result := NewObj(FStructure.NewNull).ObjNum;
end;

procedure TPDFDocument.AddOutputIntent(const ColorSpace: AnsiString);
var
  Obj: TPDFObject;
  OutputIntentsArray: TPDFArray;
  Dict: TPDFDictionary;
  ProfileStream: TPDFStream;
  I: Integer;
begin
  Obj := RootDict.FindValueByKeyName('OutputIntents', True);
  if (Obj is TPDFArray) then
  begin
    OutputIntentsArray := TPDFArray(Obj);
  end else
  begin
    OutputIntentsArray := FStructure.NewArray;
    RootDict.Add('OutputIntents', OutputIntentsArray);
  end;

  for I := 0 to OutputIntentsArray.Count do
    OutputIntentsArray.Delete(0);

  Dict := FStructure.NewDictionary;
  OutputIntentsArray.Add(Dict);
  Dict.Add('Type', FStructure.NewName('OutputIntent'));
  Dict.Add('S', FStructure.NewName('GTS_PDFA1'));
  Dict.Add('OutputConditionIdentifier', FStructure.NewString('sRGB'));

  ProfileStream := FStructure.NewStream(DefaultRGBProfile, False);
  ProfileStream.Dictionary.Add('N', FStructure.NewNumeric(3));
  Dict.Add('DestOutputProfile', NewObjRef(ProfileStream));
end;

procedure TPDFDocument.AddOverprint(StrokingOverprint,
  OtherOverprint: Boolean; OverprintMode: Integer);
var
  X: Integer;
  I: Integer;
  OverprintKey: AnsiString;
  OverprintDict: TPDFDictionary;
begin
  if (StrokingOverprint) then
  begin
    OverprintKey := OverprintKey + 'T';
  end else
  begin
    OverprintKey := OverprintKey + 'F';
  end;
  if (OtherOverprint) then
  begin
    OverprintKey := OverprintKey + 'T';
  end else
  begin
    OverprintKey := OverprintKey + 'F';
  end;
  OverprintKey := OverprintKey + QPLIntToStr(OverprintMode);

  I := -1;
  X := 0;
  while (I < 0) and (X < Length(FOverprintList)) do
  begin
    if FOverprintList[X].OverprintKey = OverprintKey then
      I := X
    else
      Inc(X);
  end;
  if I < 0 then
  begin
    I := Length(FOverprintList);
    SetLength(FOverprintList, I + 1);
    FOverprintList[I].OverprintKey := OverprintKey;
    Inc(IndexCount);
    FOverprintList[I].GSName := 'QuickPDFGS' + QPLRandomID;
    OverprintDict := FStructure.NewDictionary;
    OverprintDict.Add('Type', FStructure.NewName('ExtGState'));
    OverprintDict.Add('OP', FStructure.NewBoolean(StrokingOverprint));
    OverprintDict.Add('op', FStructure.NewBoolean(OtherOverprint));
    OverprintDict.Add('OPM', FStructure.NewNumeric(OverprintMode));
    FOverprintList[I].GS := NewObjRef(OverprintDict);
  end;
  FPageTree.UseGS(FOverprintList[I].GSName, FOverprintList[I].GS);
  FPageTree.Painter.SetGS(FOverprintList[I].GSName);
end;

function TPDFDocument.NewNamedDestination(const DestName: AnsiString;
  Dest: TPDFArray): Boolean;
var
  Obj: TPDFObject;
  Root: TPDFDictionary;
  NamesDict: TPDFDictionary;
  NDNameDict: TPDFDictionary;
  A: TPDFArray;
  NT: TPDFNameTree;
  DestRef: TPDFIndRef;
  ObjNum: Integer;
  GenNum: Integer;
begin
  Result := False;
  if Assigned(Dest) then
  begin
    Root := GetRootDict;
    Obj := Root.FindValueByKeyName('Names');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
    begin
      NamesDict := TPDFDictionary(Obj);
    end else
    begin
      NamesDict := FStructure.NewDictionary;
      Root.Add('Names', NamesDict);
    end;
    Obj := NamesDict.FindValueByKeyName('Dests');
    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if Obj is TPDFDictionary then
    begin
      NDNameDict := TPDFDictionary(Obj);
    end else
    begin
      NDNameDict := FStructure.NewDictionary;
      NamesDict.Add('Dests', NDNameDict);
      A := FStructure.NewArray;
      NDNameDict.Add('Names', A);
    end;

    if (Dest.IndObjNum > 0) then
    begin
      DestRef := FStructure.NewIndirectRef(Dest.IndObjNum,
        Dest.IndGenNum);
    end else
    begin
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, Dest);
      DestRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    end;

    NT := TPDFNameTree.Create(FStructure, NDNameDict);
    try
      if (not NT.HasKey(DestName)) then
      begin
        NT.AddKey(DestName, DestRef);
        Result := True;
      end else
      begin
        // The named destination already exists, set it to the new
        // indirect reference
        Obj := NameTreeLookup(NDNameDict, DestName);
        if (Obj is TPDFIndRef) then
        begin
          TPDFIndRef(Obj).CopyRef(DestRef);
        end;
      end;
    finally
      NT.Free;
    end;

  end;
end;

function TPDFDocument.GetDestName(const Dest: TPDFArray): AnsiString;
var
  NamedDestinationsDict: TPDFDictionary;
  NamedDestinationsNameTree: TPDFNameTree;
  Index: Integer;
  Found: Boolean;
  KeyName: AnsiString;
  DestRef: TPDFIndRef;
  TestDestRef: TPDFIndRef;
  ObjNum: Integer;
  GenNum: Integer;
begin
  Result := '';
  NamedDestinationsDict := GetNameTree('Dests');
  if Assigned(NamedDestinationsDict) then
  begin
    if (Dest.IndObjNum > 0) then
    begin
      DestRef := FStructure.NewIndirectRef(Dest.IndObjNum,
        Dest.IndGenNum);
    end else
    begin
      FStructure.OnNewIndObj(Self, ObjNum, GenNum, Dest);
      DestRef := FStructure.NewIndirectRef(ObjNum, GenNum);
    end;

    NamedDestinationsNameTree := TPDFNameTree.Create(FStructure, NamedDestinationsDict);
    try
      Found := False;
      Index := 1;
      while (not Found) and (Index <= NamedDestinationsNameTree.KeyCount) do
      begin
        KeyName := NamedDestinationsNameTree.KeyName(Index);
        if (KeyName <> '') then
        begin
          TestDestRef := NamedDestinationsNameTree.FindKey(KeyName);
          if Assigned(TestDestRef) then
          begin
            if (TestDestRef.GenNum = DestRef.GenNum) and
              (TestDestRef.ObjNum = DestRef.ObjNum) then
            begin
              Found := True;
              Result := KeyName;
            end else
            begin
              Inc(Index);
            end;
          end;
        end;
      end;
    finally
      NamedDestinationsNameTree.Free;
    end;
  end;
end;

procedure TPDFDocument.SetOutlineNamedDest(OutlineRef: TPDFIndRef;
  const DestName: AnsiString);
var
  Obj: TPDFObject;
  OutlineDict: TPDFDictionary;
begin
  if OutlineRef is TPDFIndRef then
  begin
    Obj := OutlineRef.Obj;
    if Obj is TPDFDictionary then
    begin
      OutlineDict := TPDFDictionary(Obj);
      OutlineDict.Add('Dest', FStructure.NewString(DestName));
    end;
  end;
end;

procedure TPDFDocument.SetNoEmbedFontList(FontList: TQuickPDFStringList);
var
  X: Integer;
begin
  SetLength(FNoEmbedFontList, FontList.Count);
  for X := 0 to FontList.Count - 1 do
  begin
    FNoEmbedFontList[X] := FontList[X];
  end;
end;

procedure TPDFDocument.ClearNoEmbedFontList;
begin
  SetLength(FNoEmbedFontList, 0);
end;

function TPDFDocument.GetTabOrderMode: AnsiString;
var
  Obj: TPDFObject;
  Dict: TPDFDictionary;
begin
  Result := '';
  Dict := FPageTree.GetPage(FPageTree.Page);
  if Assigned(Dict) then
  begin
    Result := '';
    Obj := Dict.FindValueByKeyName('Tabs', True);
    if Obj is TPDFName then
      Result := TPDFName(Obj).Name;
  end;
end;

function TPDFDocument.SetTabOrderMode(Value: AnsiString): Integer;
var
  Obj: TPDFObject;
  Dict: TPDFDictionary;
begin
  Result := 0;

  Dict := FPageTree.GetPage(FPageTree.Page);
  if Assigned(Dict) then
  begin
    Obj := Dict.FindValueByKeyName('Tabs', True);

    if Obj = nil then
    begin
      Dict.Add('Tabs', FStructure.NewName(Value));
      Result := 1;
    end
    else if Obj is TPDFName then
    begin
      TPDFName(Obj).SetTo(Value);
      Result := 1;
    end;
  end;
end;

{ TPDFTilingPattern }

procedure TPDFTilingPattern.SetMatrix(M11, M12, M21, M22, MDX, MDY: Double);
var
  Obj: TPDFObject;
begin
  Obj := CS.Obj;
  if (Obj is TPDFStream) then
  begin
    TPDFStream(Obj).Dictionary.Add('Matrix', Obj.Owner.NewDoubleArray([M11, M12, M21, M22, MDX, MDY]));
  end;
end;

end.
