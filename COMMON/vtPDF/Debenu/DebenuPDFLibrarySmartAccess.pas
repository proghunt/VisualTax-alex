{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibrarySmartAccess.pas                        }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibrarySmartAccess;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  Classes,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
{$ELSE}
  Vcl.Graphics,
{$ENDIF}
  DebenuPDFLibraryStructure, DebenuPDFLibraryExtractor, DebenuPDFLibraryFontRasterizer,
  DebenuPDFLibraryImageList, DebenuPDFLibraryTextList,
{$IFNDEF VER120}
  contnrs,
{$ENDIF}
  DebenuPDFLibraryExtra, DebenuPDFLibraryPicasso, DebenuPDFLibraryTextFunnel, DebenuPDFLibraryForm,
  DebenuPDFLibraryTypes, DebenuPDFLibraryRenderer, DebenuPDFLibraryPrinting;

type
  TSmartPDFErrorCode = (ecNone, ecBadHeader, ecBadTrailer);

  TPDFXRefEntry = record
    O: Integer;
    N: Int64;
    G: Integer;
    T: AnsiChar;
  end;

  TPDFRawIndRef = record
    ObjNum: Integer;
    GenNum: Integer;
  end;

  TPDFRawIndRefList = array of TPDFRawIndRef;

  TPDFPageInfo = record
    Width: Double;
    Height: Double;
    Rotate: Double;
  end;

  TPDFPageInfoList = array of TPDFPageInfo;

  TPDFDAPageMode = (pmUseNone, pmUseOutlines, pmUseThumbs, pmFullScreen, pmUseOC, pmUseAttachments);
  TPDFDAPageLayout = (plSinglePage, plOneColumn, plTwoColumnLeft, plTwoColumnRight, plTwoPageLeft, plTwoPageRight, plNone);

  TObjStreamDecryptEvent = procedure(ObjNum: Integer; Stream: TPDFStream) of object;

  TSmartPDFReader = class
  private
    FVersion: AnsiString;
    FStream: TStream;
    FStructure: TPDFStructure;
    FTrailerDict: TPDFDictionary;
    FErrorCode: TSmartPDFErrorCode;
    FObjectStreams: array of TPDFStream;
    FObjectStreamNumbers: array of Integer;
    FLastXRefPos: Int64;
    FOnIDChange: TNotifyEvent;
    FOnObjStreamDecrypt: TObjStreamDecryptEvent;
    FIsEncrypted: Boolean;
    XRefEntries: array of TPDFXRefEntry;
    ObjectPosList: TQPLSortedInt64List;
    PreviousTrailers: array of TPDFDictionary;
    FObjectCache: array of TPDFObject;
    FObjectCacheIndex: array of Integer;
    FObjectCacheSize: Integer;
    FHasXRefStream: Boolean;
    FHeaderPosition: Integer;
    FShiftedHeader: Boolean;
  protected
    procedure AnalyseFile;
    function ReadHeader: Boolean;
    function ReadTrailer: Boolean;
    function ReadXRef(Start: Int64): Boolean;
    function ReadXRefWithOffset(Start, Offset: Int64): Boolean;

    procedure XRefItem(O: Integer; N: Int64; G: Integer; T: AnsiChar);
    procedure XRefTrailer(const Trailer: AnsiString);
    procedure XRefRead(Pos: Int64);

    function ReadTrailerDict(Start: Int64; GuessLength: Integer): TPDFDictionary;
    function GetObjectCount: Integer;
    function GetPreviousTrailer: TPDFDictionary;
  public
    constructor Create(InputStream: TStream); virtual;
    destructor Destroy; override;
    function IsStream(const Content: AnsiString; var SStart, SLen: Integer): Boolean;
    function GetObjectPosition(ObjectNumber: Integer): Integer;
    function GetObjectSource(ObjectNumber: Integer): AnsiString;
    function GetObject(ObjectNumber: Integer; Structure: TPDFStructure = nil): TPDFObject;
    function GetRawObject(ObjectNumber: Integer; Structure: TPDFStructure = nil): TPDFObject;
    function GetCachedObject(ObjectNumber: Integer): TPDFObject;
    function GetObjectSourceFromStream(StreamObjectNum, ObjNum, Index: Integer): AnsiString;
    function FindDict(const Name: AnsiString): TPDFDictionary;
    function FindDictRef(const Name: AnsiString): TPDFIndRef;
    function GetGenNum(ObjectNumber: Integer): Integer;
    procedure FixTrailer;
    function IsCompact(ObjNum: Integer): Boolean;
    property ObjectCount: Integer read GetObjectCount;
    property Version: AnsiString read FVersion;
    property TrailerDict: TPDFDictionary read FTrailerDict;
    property PreviousTrailer: TPDFDictionary read GetPreviousTrailer;
    property ErrorCode: TSmartPDFErrorCode read FErrorCode;
    property ReaderStructure: TPDFStructure read FStructure;
    property LastXRefPos: Int64 read FLastXRefPos;
    property HasXRefStream: Boolean read FHasXRefStream;
    property HeaderPosition: Integer read FHeaderPosition;
    property ShiftedHeader: Boolean read FShiftedHeader;
    property OnIDChange: TNotifyEvent read FOnIDChange write FOnIDChange;
    property OnObjStreamDecrypt: TObjStreamDecryptEvent read FOnObjStreamDecrypt write FOnObjStreamDecrypt;
  end;

  TSmartPDFWriter = class
  private
    FStream: TStream;
    ObjectPos: array of Int64;
    ObjectGen: TQuickPDFIntegerList;
    ObjectNum: TQuickPDFIntegerList;
    ObjectLength: TQuickPDFIntegerList;
  public
    constructor Create(OutputStream: TStream); virtual;
    destructor Destroy; override;
    function GetObjectPosition(ObjectNumber: Integer): Int64;
    function GetObjectLength(ObjectNumber: Integer): Integer;
    procedure New(const Version: AnsiString = '1.4');
    procedure Append;
    procedure AddObject(ObjNum, GenNum: Integer; const ObjectData: AnsiString);
    procedure AddTrailer(TrailerDict: TPDFDictionary; Offset: Int64 = 0; AddFree: Boolean = False; PreviousXRefPos: Int64 = 0);
    procedure AddXRefStream(TrailerDict: TPDFDictionary; Offset: Int64 = 0; AddFree: Boolean = False; PreviousXRefPos: Int64 = 0);
    procedure Serialize(StoreStream: TStream);
    procedure Unserialize(StoreStream: TStream);
    procedure Reset;
  end;

  TSmartPDFEncrypted = (spDecrypted, spEncrypted, spUnknownEncryption);

  TSmartPDFEncryptionAlgorithm = (eaRC4, eaAES);

  TSmartPDFEncryption = record
    Length: Integer;
    R: Integer;
    V: Integer;
    O: AnsiString;
    U: AnsiString;
    P: Cardinal;
    Algorithm: TSmartPDFEncryptionAlgorithm;
    OE: AnsiString;
    UE: AnsiString;
    Perms: AnsiString;
    EncryptMetadata: Boolean;
  end;

  TSmartPDFPermission = (spCanPrint, spCanCopy, spCanChange, spCanAddNotes);
  TSmartPDFPermissions = set of TSmartPDFPermission;
  TSmartPDFExtraPermission = (spCanFillFields, spCanCopyAccess, spCanAssemble, spCanPrintFull);
  TSmartPDFExtraPermissions = set of TSmartPDFExtraPermission;
  TSmartPDFEncryptionStrength = (ssStd, ss128Bit, ssAES128Bit, ssAES256Bit, ssVariable, ssAES256BitAcroX);

  TSmartPDFCrypt = class
  private
    IndObjEncKey: AnsiString;
    EncryptionKey: AnsiString;
    FPassword: WideString;
    FEncryption: TSmartPDFEncryption;
    FEncrypted: TSmartPDFEncrypted;
    PermKey: Cardinal;
    FPermissions: TSmartPDFPermissions;
    FExtraPermissions: TSmartPDFExtraPermissions;
    FEncryptionStrength: TSmartPDFEncryptionStrength;
    OwnerKey: AnsiString;
    UserKey: AnsiString;
    FOwnerPassword: AnsiString;
    FUserPassword: AnsiString;
    MalformedPermKey: Boolean;
    OwnerEncKey: AnsiString;
    UserEncKey: AnsiString;
    PermsKey: AnsiString;
    FFileID: AnsiString;
  protected
    procedure DecodePermKey(PKey: Cardinal);
    procedure GenerateEncryptionKeys;
    procedure GenerateEncryptionKeys256;
    procedure EncodePermKey;
    function MakeKey(ObjNum, GenNum: Integer): AnsiString;
    procedure EncryptObject(const Key: AnsiString; Obj: TPDFObject);
    procedure DecryptObject(const Key: AnsiString; Obj: TPDFObject);
    function CalculateVer6Hash(var SHAInput: TQPLByteArray;
      const PasswordA: AnsiString; TruncLength: Integer;
      const UK: AnsiString): AnsiString;
  public
    procedure SetupEncryption(const OwnerPassword, UserPassword: AnsiString;
      Strength: TSmartPDFEncryptionStrength; Perm:
      TSmartPDFPermissions; ExtraPerm: TSmartPDFExtraPermissions);
    procedure SetPassword(const NewPassword: WideString);
    function IsUserPassword(const Password: WideString): Boolean;
    function IsOwnerPassword(const Password: WideString): Boolean;
    function SecurityInfo(SecurityItem: Integer): Integer;
    constructor Create(Parm: TSmartPDFEncryption; Encrypted: TSmartPDFEncrypted; const FileID: AnsiString);
    property Encrypted: TSmartPDFEncrypted read FEncrypted;
    property GetOwnerKey: AnsiString read OwnerKey;
    property GetUserKey: AnsiString read UserKey;
    property GetPermKey: Cardinal read PermKey;
    property GetOwnerEncKey: AnsiString read OwnerEncKey;
    property GetUserEncKey: AnsiString read UserEncKey;
    property GetPermsKey: AnsiString read PermsKey;
  end;

  TSmartPDFInfo = class
  private
    FPageCount: Integer;
    FRootDict: TPDFDictionary;
    FRootRef: TPDFIndRef;
    FInfoDict: TPDFDictionary;
    FInfoRef: TPDFIndRef;
    FPagesDict: TPDFDictionary;
    FPagesRef: TPDFIndRef;
    FEncryptDict: TPDFDictionary;
    FAcroFormDict: TPDFDictionary;
    FReader: TSmartPDFReader;
    FVersion: AnsiString;
    FEncrypted: TSmartPDFEncrypted;
    FEncryption: TSmartPDFEncryption;
    FPassword: WideString;
    FFieldCount: Integer;
    FLastPageNode: TPDFDictionary;
    FLastPageNodeRef: TPDFIndRef;
    Crypt: TSmartPDFCrypt;
    FDocID: AnsiString;
  protected
    procedure GetBasicProperties;
    procedure GetEncryption;
    procedure GetFormFields;
    function GetFileID: AnsiString;
    function NiceFileID: AnsiString;
    procedure SetPassword(const NewPassword: WideString);
    function FindPageRef(Page: Integer): TPDFIndRef;
    function FindPageDict(Page: Integer): TPDFDictionary;
    function GetFieldName(FieldRef: TPDFIndRef): WideString;
  public
    constructor Create(Reader: TSmartPDFReader; const InitialPassword: WideString; NoBasic: Boolean = False); virtual;
    destructor Destroy; override;
    function GetInfoValue(const Key: AnsiString): WideString;
    function GetMetadata: AnsiString;
    function CheckPassword(const Password: WideString): Boolean;
    procedure CryptObject(Obj: TPDFObject; ObjNum, GenNum: Integer);
    procedure DecryptObject(Obj: TPDFObject; ObjNum, GenNum: Integer);
    function Encrypt(const Owner, User: AnsiString; Strength:
      TSmartPDFEncryptionStrength; Perm: TSmartPDFPermissions;
      ExtraPerm: TSmartPDFExtraPermissions; NewObjNum: Integer): TPDFDictionary;
    function SecurityInfo(Item: Integer): AnsiString;
    procedure GetBlankSignatureNames(SL: TQuickPDFStringList);
    procedure ReaderIDChange(Sender: TObject);
    procedure ReaderObjStreamDecrypt(ObjNum: Integer; Stream: TPDFStream);
    function IsOwnerPassword: Boolean;
    function ContainsUsageRights: Boolean;
    function GetUsageRightsName: WideString;
    procedure GetBasic;
    property PageCount: Integer read FPageCount;
    property Version: AnsiString read FVersion;
    property Encrypted: TSmartPDFEncrypted read FEncrypted;
    property Password: WideString read FPassword write SetPassword;
    property DocID: AnsiString read FDocID;
    property FormFieldCount: Integer read FFieldCount;
  end;

  TSmartPDFDocument = class
  private
    FLocalStructure: TPDFStructure;
    FRootDict: TPDFDictionary;
    FRootRef: TPDFIndRef;
    FInfoDict: TPDFDictionary;
    FInfoRef: TPDFIndRef;
    FPagesRef: TPDFIndRef;
    FPagesDict: TPDFDictionary;
    FAcroFormRef: TPDFIndRef;
    FAcroFormDict: TPDFDictionary;
    FReader: TSmartPDFReader;
    FNewObjects: array of TPDFObject;
    FNewObjNums: TQuickPDFIntegerList;
    FSmartInfo: TSmartPDFInfo;
    FLastPageNode: TPDFDictionary;
    FLastPageNodeRef: TPDFIndRef;
    FOnProgress: TQuickPDFProgressEvent;
    FTempStruct: TPDFStructure;
    FFontCol: TPDFFontCollection;
    FImageListArray: array of TPDFImageList;
    FAcroForm: TPDFForm;
    FUserModDate: Boolean;

    LastPage: Integer;
    LastPageRef: TPDFIndRef;
  protected
    ExtractList: TQuickPDFIntegerList2;
    procedure GetRootInfoPages;
    procedure GetFormFields;
    procedure ChangeObject(ObjNum: Integer; NewObject: TPDFObject);
    function NewObject(Obj: TPDFObject): TPDFIndRef;
    function GetFieldsArray: TPDFArray;
    function GetCOArray: TPDFArray;
    function FindPageRef(Page: Integer): TPDFIndRef;
    function FindPageDict(Page: Integer): TPDFDictionary;
    function PageDictFromRef(PageRef: TPDFIndRef): TPDFDictionary;
    function FindField(const FieldName: WideString): TPDFIndRef;
  public
    constructor Create(Reader: TSmartPDFReader); virtual;
    destructor Destroy; override;
    function PageCount: Integer;
    function ObjectCount: Integer;
    function LSObjectCount: Integer;
    function GetObject(ObjectNumber: Integer; Structure: TPDFStructure = nil): TPDFObject;
    function GetGenNum(ObjectNumber: Integer): Integer;
    function PageKids: TPDFArray;
    function HasFields: Boolean;
    function FormNeedAppearances: Boolean;
    function HasOutline: Boolean;
    procedure SetOutline(OutlineRef: TPDFIndRef; Offset: Integer);
    procedure GetTopLevelOutlines(List: TObjectList);
    procedure SetOutlineParent(List: TObjectList; NewParentObjNum, NewParentGenNum: Integer);
    procedure AppendOutline(Source: TSmartPDFDocument; Offset: Integer);
    procedure GetPageInfo(var PageInfoList: TPDFPageInfoList);
    function GetNamedOutlineDict(const Key: AnsiString): TPDFDictionary;
    function GetNamedOutlineRef(const Key: AnsiString): TPDFIndRef;
    function GetOutlineRef: TPDFIndRef;
    function GetOutlineDict: TPDFDictionary;
    function CapturePage(PageRef: TPDFIndRef; Options: Integer): TPDFIndRef;
    function WriteNewObjects(Writer: TSmartPDFWriter): TPDFDictionary;
    function GetInformation(const Key: AnsiString): WideString;
    function UseXObject(XObjectRef, PageRef: TPDFIndRef): AnsiString;
    function XObjectBBox(XObjectRef: TPDFIndRef): TPDFArray;
    function GetPageContents(PageRef: TPDFIndRef; Structure: TPDFStructure = nil): AnsiString;
    function GetEncodedPageContents(PageRef: TPDFIndRef; Structure: TPDFStructure = nil): AnsiString;
    function GetPageTextList(PageRef: TPDFIndRef;
      Options: Integer; ExtractOptions: TQPLExtractionOptions): TPDFTextList;
    function ExtractPageText(PageRef: TPDFIndRef; Options: Integer; ExtractOptions: TQPLExtractionOptions): WideString;
    procedure ExtractPageTextToFunnel(PageRef: TPDFIndRef; Funnel: TPDFTextFunnel);
    function RenderPageToString(PageRef: TPDFIndRef; Options: Integer;
      DPI: Double; JPEGQuality: Integer; GDIPlusSettings: TGDIPlusSettings;
      var RenderError: AnsiString; OCGStateList: TQPLOCGStateList): AnsiString;
    procedure RenderPageToStream(PageRef: TPDFIndRef; Options: Integer;
      DPI: Double; JPEGQuality: Integer; GDIPlusSettings: TGDIPlusSettings;
      Target: TStream; var RenderError: AnsiString; OCGStateList: TQPLOCGStateList);
{$IFDEF QPL_DPLR}
    procedure RenderPageToDPLRStream(PageRef: TPDFIndRef; Options: Integer;
      DPI: Double; JPEGQuality: Integer; const DPLRFileName: WideString;
      Target: TStream; var RenderError: AnsiString; OCGStateList: TQPLOCGStateList);
{$ENDIF}
    procedure RenderPageAreaToBitmap(PageRef: TPDFIndRef; Left, Top,
      Width, Height: Double; DPI: Double; BM: TBitmap; GDIPlusSettings: TGDIPlusSettings;
      var RenderError: AnsiString; OCGStateList: TQPLOCGStateList);
    procedure RenderPageToDC(PageRef: TPDFIndRef; DPI: Double; JPEGQuality: Integer;
      GDIPlusSettings: TGDIPlusSettings; TargetDC: HDC; var RenderError: AnsiString;
      RenderCropType, OffsetX, OffsetY: Integer; ErasePage: Boolean; OCGStateList: TQPLOCGStateList);
{$IFDEF QPL_CAIRO}
    procedure RenderPageToCairoDC(PageRef: TPDFIndRef; DPI: Double; JPEGQuality: Integer;
      const CairoFileName: WideString; TargetDC: HDC; var RenderError: AnsiString;
      RenderCropType, OffsetX, OffsetY: Integer; ErasePage: Boolean; OCGStateList: TQPLOCGStateList);
{$ENDIF}
{$IFDEF QPL_DPLR}
    procedure RenderPageToDPLRDC(PageRef: TPDFIndRef; DPI: Double; JPEGQuality: Integer;
      const DPLRFileName: WideString; TargetDC: HDC; var RenderError: AnsiString;
      RenderCropType, OffsetX, OffsetY: Integer; ErasePage: Boolean; OCGStateList: TQPLOCGStateList);
{$ENDIF}
    procedure RenderPageToPrinter(QPLPrinter: TQPLPrinter; StartPage, EndPage,
      Options: Integer; GDIPlusSettings: TGDIPlusSettings);
    function NewPage: TPDFIndRef;
    function FindPage(Page: Integer): TPDFIndRef;
    function FindObject(Ref: TPDFIndRef): TPDFObject;
    function DirectFindObject(Ref: TPDFIndRef): TPDFObject;
    function FindTempObject(Ref: TPDFIndRef): TPDFObject;
    function GetInheritedValue(Dict: TPDFDictionary; const Key: AnsiString): TPDFObject;
    function ReadInheritedValue(Dict: TPDFDictionary; const Key: AnsiString): TPDFObject;
    procedure SetInformation(const Key: AnsiString; const NewValue: WideString);
    procedure SetPagesParent(ObjNum, GenNum: Integer);
    procedure AddPages(ObjNum, GenNum, Count: Integer);
    procedure AddAcroForm;
    procedure AddFields(SourceFields, SourceCO: TPDFArray; Offset: Integer;
      NeedAppearances: Boolean = False);
    procedure AddFieldFonts(FontDictionary: TPDFDictionary; Offset: Integer);
    procedure NewPages(PageCount: Integer);
    procedure HidePage(PageRef: TPDFIndRef);
    function MovePage(PageRef, TargetPageRef: TPDFIndRef; Before: Boolean): Boolean;
    procedure AdjustPageCount(PageNodeRef: TPDFIndRef; Change: Integer);
    procedure ClearContents(PageRef: TPDFIndRef);
    procedure DrawCapturedPage(DestPage: TPDFIndRef; XObjectRef: TPDFIndRef;
      PntLeft, PntBottom, PntWidth, PntHeight: Double);
    procedure DrawRotatedCapturedPage(DestPage: TPDFIndRef; XObjectRef: TPDFIndRef;
      PntLeft, PntBottom, PntWidth, PntHeight, Angle: Double);
    procedure SetPageSize(Page: TPDFIndRef; PntWidth, PntHeight: Double);
    procedure SetPageBox(Page: TPDFIndRef; BoxIndex: Integer; X1, Y1, X2, Y2: Double);
    function HasPageBox(Page: TPDFIndRef; BoxIndex: Integer): Boolean;
    function GetPageBox(Page: TPDFIndRef; BoxIndex: Integer; Dimension: TPDFDimension): Double;
    procedure SetSignatureValue(const FieldName: WideString; const NewDict: AnsiString);
    procedure SetSignatureImage(const FieldName: WideString; const ImageData: AnsiString; ImageOptions: Integer);
    procedure SetSignatureBounds(const FieldName: WideString; Left, Top, Width, Height: Double);
    procedure SetSignatureFlags(NewFlags: Integer);
    function HasSignatureField(const FieldName: WideString): Boolean;
    function GetSignatureObjectNumber(const FieldName: WideString): Integer;
    function GetSignatureValueObjectNumber(const FieldName: WideString): Integer;
    function AddSignatureField(const FieldName: WideString; PageRef: TPDFIndRef): Integer;
    procedure GetSignatures(List: TQuickPDFStringList);
    function GetSignatureValue(FieldRef: TPDFIndRef; ValueKey: Integer): AnsiString;
    function GetFieldName(FieldRef: TPDFIndRef): WideString;
    function GetFieldValue(FieldRef: TPDFIndRef): WideString;
    function AddNewField(const FieldName: WideString): TPDFIndRef;
    procedure LinkFieldToPage(PageRef, FieldRef: TPDFIndRef);
    procedure ExtractObjects(PageList: TQuickPDFPageList; IgnoreOutlines: Boolean);
    function GetEncryptionDictObjNum: Integer;
    function GetExtractObjectNumber(ExtractIndex: Integer): Integer;
    function ExtractObjectCount: Integer;
    function IsPage(Ref: TPDFIndRef): Boolean;
    function GetPageInheritedValue(PageRef: TPDFIndRef; const Name: AnsiString): TPDFObject;
    function GetPageWidth(PageRef: TPDFIndRef): Double;
    function GetPageHeight(PageRef: TPDFIndRef): Double;
    function GetPageDXPageHash1(PageRef: TPDFIndRef): AnsiString;
    function GetPageRotation(PageRef: TPDFIndRef): Integer;
    function SetPageRotation(PageRef: TPDFIndRef; Angle, Options: Integer): Boolean;
    procedure FixPages;
    procedure RendererDecrypt(Source: TPDFStream; Ref: TPDFIndRef);
    procedure RendererEncrypt(Source: TPDFStream; Ref: TPDFIndRef);
    procedure GetReferencedObjects(Resources: TPDFDictionary; List, Searched: TQuickPDFStringList); overload;
    procedure GetReferencedObjects(Ref: TPDFIndRef; List, Searched: TQuickPDFStringList); overload;
    function GetPageResources(PageRef: TPDFIndRef): TPDFDictionary;
    function GetNextPageRef(Page: Integer; PrevRef: TPDFIndRef): TPDFIndRef;
    function MoveLayer(PageRef: TPDFIndRef; FromLayer, ToLayer:Integer): Boolean;
    function NewLayer(PageRef: TPDFIndRef): Integer;
    function SetContentStream(PageRef: TPDFIndRef; Index: Integer; const Source: AnsiString): Boolean;
    function ContentStreamCount(PageRef: TPDFIndRef): Integer;

    function Status: AnsiString;

    function GetPageImages(PageRef: TPDFIndRef): TPDFImageList;
    function FastGetPageImageData(PageRef: TPDFIndRef; var ImageWidth, ImageHeight: Integer): AnsiString;
    function GetImageIntProperty(ImageList: TPDFImageList; ImageIndex, PropertyID: Integer): Integer;
    function GetImageDblProperty(ImageList: TPDFImageList; ImageIndex, PropertyID: Integer): Double;
    function GetImageListCount(ImageList: TPDFImageList): Integer;
    function ReleaseImageList(ImageList: TPDFImageList): Boolean;
    function GetImageData(ImageList: TPDFImageList; ImageIndex: Integer): AnsiString;
    function HasImageList(ImageList: TPDFImageList): Boolean;
    function AcroFormFonts: TPDFDictionary;

    function GetAnnotationCount(PageRef: TPDFIndRef): Integer;
    function EmbedFileStreams(const RootPath: WideString): Boolean;

    function RemoveUsageRights: Boolean;
    function SetPageMode(NewMode: TPDFDAPageMode): Boolean;
    function SetPageLayout(NewLayout: TPDFDAPageLayout): Boolean;

    function HasCatalogEntry(const EntryName: AnsiString): Boolean;
    function SearchForFilter(const FilterName: AnsiString; StopOnFirst: Boolean): Boolean;
    function GetViewOCGList: TQPLOCGStateList;
    procedure NewSigImageObj(Sender: TObject; var ObjNum, GenNum: Integer; Obj: TPDFObject);
    procedure PartialDecrypt;
    procedure SetFileID;

    property PagesDict: TPDFDictionary read FPagesDict;
    property RootDict: TPDFDictionary read FRootDict;
    property RootRef: TPDFIndRef read FRootRef;
    property PagesRef: TPDFIndRef read FPagesRef;
    property AcroFormDict: TPDFDictionary read FAcroFormDict;
    property AcroForm: TPDFForm read FAcroForm;
    property FieldsArray: TPDFArray read GetFieldsArray;
    property COArray: TPDFArray read GetCOArray;
    property SmartInfo: TSmartPDFInfo read FSmartInfo write FSmartInfo;
    property ReaderStructure: TPDFStructure read FLocalStructure;
    property UserModDate: Boolean read FUserModDate write FUserModDate;
    property OnProgress: TQuickPDFProgressEvent read FOnProgress write FOnProgress;
  end;

  TSmartPDFLink = class
  private
    FReader: TSmartPDFReader;
    FInfo: TSmartPDFInfo;
    FDoc: TSmartPDFDocument;
    FOkay: Boolean;
    FInputStream: TStream;
    FReadOnlyAccess: Boolean;
    FOpenProblem: AnsiString;
  public
    constructor Create(InputStream: TStream; const Password: WideString); overload; virtual;
    constructor Create(const InputFile: WideString; const Password: WideString; ReadOnly: Boolean = False); overload; virtual;
    destructor Destroy; override;
    property Okay: Boolean read FOkay;
    property Info: TSmartPDFInfo read FInfo;
    property Doc: TSmartPDFDocument read FDoc;
    property Reader: TSmartPDFReader read FReader;
    property Stream: TStream read FInputStream;
    property ReadOnlyAccess: Boolean read FReadOnlyAccess;
    property OpenProblem: AnsiString read FOpenProblem;
  end;

implementation

uses
  SysUtils, DebenuPDFLibraryDigest, DebenuPDFLibraryEncrypt, DebenuPDFLibraryFlate,
  Math, DebenuPDFLibraryFontConst,
{$IFDEF WIN64}
  DebenuPDFLibraryJPEGWin64,
{$ELSE}
  DebenuPDFLibraryJPEG,
{$ENDIF}
  DebenuPDFLibraryPNG,
  DebenuPDFLibraryGIF, DebenuPDFLibraryAES, DebenuPDFLibraryTIFF, DebenuPDFLibraryXRef,
  DebenuPDFLibraryImage;

{ TSmartPDFReader }

procedure TSmartPDFReader.AnalyseFile;
var
  Obj: TPDFObject;
begin
  if ReadHeader then
  begin
    if ReadTrailer and (Length(PreviousTrailers) > 0) then
    begin
      FTrailerDict := PreviousTrailers[0];
    end else
      FErrorCode := ecBadTrailer;
  end else
    FErrorCode := ecBadHeader;
  FIsEncrypted := False;
  if Assigned(FTrailerDict) then
  begin
    Obj := FTrailerDict.FindValueByKeyName('Encrypt');
    if Assigned(Obj) then FIsEncrypted := True;
  end;
end;

constructor TSmartPDFReader.Create(InputStream: TStream);
begin
  ObjectPosList := TQPLSortedInt64List.Create;
  FStructure := TPDFStructure.Create;
  FErrorCode := ecNone;
  FStream := InputStream;
  FTrailerDict := nil;
  FShiftedHeader := False;
  FHasXRefStream := False;
  SetLength(XRefEntries, 0);
  SetLength(PreviousTrailers, 0);
  SetLength(FObjectStreams, 0);
  SetLength(FObjectStreamNumbers, 0);

  SetLength(FObjectCache, 0);
  SetLength(FObjectCacheIndex, 0);
  FObjectCacheSize := 100;

  AnalyseFile;
end;

destructor TSmartPDFReader.Destroy;
begin
  FStructure.Free;
  ObjectPosList.Free;
  inherited;
end;

function TSmartPDFReader.GetObjectSource(ObjectNumber: Integer): AnsiString;
var
  Len: Int64;
  ObjPos: Int64;
  EndPos: Int64;
  P1, P2: Int64;
begin
  Result := '';
  if (ObjectNumber >= 1) and (ObjectNumber < Length(XRefEntries)) then
  begin
    if XRefEntries[ObjectNumber].T = 'c' then
    begin
      Result := GetObjectSourceFromStream(XRefEntries[ObjectNumber].N,
        ObjectNumber, XRefEntries[ObjectNumber].G);
    end else
    if XRefEntries[ObjectNumber].T <> 'f' then
    begin
      ObjPos := XRefEntries[ObjectNumber].N;
      EndPos := ObjectPosList.GetNextNum(ObjPos) - 1;
      if EndPos <= ObjPos then EndPos := FStream.Size;
      Len := EndPos - ObjPos + 1;
      if ObjPos >= 0 then
      begin
        if (FShiftedHeader) then
        begin
          FStream.Seek(ObjPos + FHeaderPosition, soBeginning);
        end else
        begin
          FStream.Seek(ObjPos, soBeginning);
        end;
        SetLength(Result, Len);
        if (Len > 0) then
        begin
          FStream.Read(Result[1], Len);
        end;
      end;

      P1 := QPLPos('obj', Result);
      P2 := QPLPos('endobj', Result);
      if (P2 > 0) and (P1 > 0) and (P2 < P1) then
      begin
        Delete(Result, 1, QPLPos('endobj', Result) + 5);
      end;

      if QPLPos('obj', Result) > 0 then
        Delete(Result, 1, QPLPos('obj', Result) + 2)
      else
        Result := '';
    end;
  end;
end;

function TSmartPDFReader.GetObjectCount: Integer;
begin
  Result := Length(XRefEntries) - 1;
end;

function TSmartPDFReader.ReadHeader: Boolean;
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
  FStream.Seek(0, soBeginning);
  SetLength(S, 1024);
  FStream.Read(S[1], 1024);
  PPDF := QPLPos('%PDF-', S);
  PPS := QPLPos('%!PS-Adobe-', S);
  if (PPDF > 0) or (PPS > 0) then
  begin
    FHeaderPosition := PPDF - 1;
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

function TSmartPDFReader.ReadTrailer: Boolean;
var
  XRefReader: TPDFXRefReader;
  StartXRef: Int64;
  FixBuffer: AnsiString;
  FixObjNum: Integer;
begin
  Result := False;

  try
    XRefReader := TPDFXRefReader.Create(FStream);
    try
      StartXRef := XRefReader.FindXRefPos;
      FLastXRefPos := StartXRef;
    finally
      XRefReader.Free;
    end;
  except
    StartXRef := 0;
  end;

  if (StartXRef > 0) then
  begin
    Result := ReadXRef(StartXRef);

    if ((Length(XRefEntries) = 0) and (FHeaderPosition > 0)) then
    begin
      Result := ReadXRefWithOffset(StartXRef, FHeaderPosition);
      if (Length(XRefEntries) > 0) then
      begin
        FShiftedHeader := True;
      end;
    end;

    if (Length(XRefEntries) > 0) then
    begin
      if ((XRefEntries[0].G = 0) and (XRefEntries[0].N = 0) and
        (XRefEntries[1].G = 65535) and (XRefEntries[1].N = 0)) then
      begin
        FStream.Seek(XRefEntries[2].N, soBeginning);
        SetLength(FixBuffer, 7);
        FStream.Read(FixBuffer[1], 7);
        if (FixBuffer = '1 0 obj') then
        begin
          // Malformed shifted xref table
          for FixObjNum := 0 to Length(XRefEntries) - 2 do
          begin
            XRefEntries[FixObjNum] := XRefEntries[FixObjNum + 1];
            Dec(XRefEntries[FixObjNum].O);
          end;
        end;
      end;
    end;
    ObjectPosList.Sort;
  end;
end;

function TSmartPDFReader.ReadTrailerDict(Start: Int64; GuessLength: Integer): TPDFDictionary;
var
  Obj: TPDFObject;
  S: AnsiString;
begin
  Result := nil;
  if GuessLength <= 0 then GuessLength := 2048;
  FStream.Seek(Start, soBeginning);
  SetLength(S, GuessLength);
  SetLength(S, FStream.Read(S[1], GuessLength));
  if (QPLPos('<<', S) > 0) and (QPLPos('>>', S) > 0) then
  begin
    Delete(S, 1, QPLPos('<<', S) - 1);
    repeat
      Delete(S, Length(S), 1);
    until (QPLCopy(S, Length(S) - 1, 2) = '>>') or (Length(S) = 0);
    if (QPLCopy(S, 1, 2) = '<<') and (QPLCopy(S, Length(S) - 1, 2) = '>>') then
    begin
      Obj := FStructure.Decode(S);
      if Obj is TPDFDictionary then
        Result := TPDFDictionary(Obj);
    end;
  end;
end;

procedure TSmartPDFReader.XRefItem(O: Integer; N: Int64; G: Integer;
  T: AnsiChar);
begin
  if (Length(XRefEntries) < (O + 1)) then
  begin
    SetLength(XRefEntries, O + 1);
  end;

  if (N > Self.FStream.Size) then  // NEEDS REVIEWING
  begin
    T := 'n';
    N := 0;
    G := 0;
  end;

  if (T = 'n') then
  begin
    ObjectPosList.Add(N);
  end;
  if (XRefEntries[O].O <> O) then
  begin
    XRefEntries[O].N := N;
    XRefEntries[O].G := G;
    XRefEntries[O].T := T;
    XRefEntries[O].O := O;
  end;
end;

procedure TSmartPDFReader.XRefRead(Pos: Int64);
begin

end;

procedure TSmartPDFReader.XRefTrailer(const Trailer: AnsiString);
var
  TempDict: TPDFObject;
begin
  TempDict := FStructure.Decode(Trailer);
  if (TempDict is TPDFDictionary) then
  begin
    SetLength(PreviousTrailers, Length(PreviousTrailers) + 1);
    PreviousTrailers[Length(PreviousTrailers) - 1] := TPDFDictionary(TempDict);
  end;
end;

function TSmartPDFReader.ReadXRef(Start: Int64): Boolean;
var
  XRef: TPDFXRefReader;
begin
  XRef := TPDFXRefReader.Create(FStream);
  try
    XRef.OnXRefItem := XRefItem;
    XRef.OnXRefTrailer := XRefTrailer;
    Result := XRef.ReadXRef(Start);
    FHasXRefStream := XRef.HasXRefStream;
  finally
    XRef.Free;
  end;
end;

function TSmartPDFReader.ReadXRefWithOffset(Start, Offset: Int64): Boolean;
var
  XRef: TPDFXRefReader;
begin
  XRef := TPDFXRefReader.Create(FStream);
  try
    XRef.Offset := Offset;
    XRef.OnXRefItem := XRefItem;
    XRef.OnXRefTrailer := XRefTrailer;
    Result := XRef.ReadXRef(Start);
    FHasXRefStream := XRef.HasXRefStream;
  finally
    XRef.Free;
  end;
end;

function TSmartPDFReader.GetObject(ObjectNumber: Integer; Structure: TPDFStructure): TPDFObject;
begin
  if not Assigned(Structure) then
    Result := GetCachedObject(ObjectNumber)
  else
    Result := GetRawObject(ObjectNumber, Structure);
end;

function TSmartPDFReader.FindDict(const Name: AnsiString): TPDFDictionary;
var
  X: Integer;
  Obj: TPDFObject;
begin
  Result := nil;
  if Assigned(FTrailerDict) then
  begin
    Obj := FTrailerDict.FindValueByKeyName(Name);
    if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
    if not Assigned(Obj) then
    begin
      X := 0;
      while (X < Length(PreviousTrailers)) and (not Assigned(Obj)) do
      begin
        Obj := PreviousTrailers[X].FindValueByKeyName(Name);
        if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
        Inc(X);
      end;
    end;
    if Obj is TPDFDictionary then Result := TPDFDictionary(Obj);    
  end;
end;

function TSmartPDFReader.FindDictRef(const Name: AnsiString): TPDFIndRef;
var
  X: Integer;
  Obj: TPDFObject;
begin
  Result := nil;
  if Assigned(FTrailerDict) then
  begin
    Obj := FTrailerDict.FindValueByKeyName(Name);
    if not Assigned(Obj) then
    begin
      X := 0;
      while (X < Length(PreviousTrailers)) and (not Assigned(Obj)) do
      begin
        Obj := PreviousTrailers[X].FindValueByKeyName(Name);
        Inc(X);
      end;
    end;
    if Obj is TPDFIndRef then Result := TPDFIndRef(Obj);
  end;
end;

procedure TSmartPDFReader.FixTrailer;
var
  Obj: TPDFObject;
  S: TPDFString;
  Ref: TPDFIndRef;
begin
  FTrailerDict.PurgeKey('Size');
  FTrailerDict.Add('Size', FStructure.NewNumeric(ObjectCount + 1));
  Obj := FTrailerDict.FindValueByKeyName('Info');
  if not Assigned(Obj) then
  begin
    Ref := FindDictRef('Info');
    if Assigned(Ref) then
      FTrailerDict.Add('Info', Ref)
    else
      FTrailerDict.PurgeKey('Info');
  end;
  Obj := FTrailerDict.FindValueByKeyName('Root');
  if not Assigned(Obj) then FTrailerDict.Add('Root', FindDictRef('Root'));

  Obj := FTrailerDict.FindValueByKeyName('ID');
  S := FStructure.NewString(MD5DigestToString(MD5String(QPLRandomID)), smHex);
  if not Assigned(Obj) then
  begin
    FTrailerDict.Add('ID', FStructure.NewArray([S, S]));
    if Assigned(FOnIDChange) then FOnIDChange(Self);
  end else
  begin
    if Obj is TPDFIndRef then
      Obj := GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFArray then
    begin
      if TPDFArray(Obj).Count >= 2 then
      begin
        if TPDFArray(Obj).Item[1] is TPDFString then
        begin
          TPDFString(TPDFArray(Obj).Item[1]).SetTo(S.AsString);
          TPDFString(TPDFArray(Obj).Item[1]).StringMode := smHex;
        end;
      end;
    end;
  end;

  FTrailerDict.PurgeKey('Prev');
  FTrailerDict.PurgeKey('DecodeParms');
  FTrailerDict.PurgeKey('Filter');
  FTrailerDict.PurgeKey('Length');
  FTrailerDict.PurgeKey('Type');
  FTrailerDict.PurgeKey('W');
  FTrailerDict.PurgeKey('Index');  
end;

function TSmartPDFReader.IsStream(const Content: AnsiString; var SStart,
  SLen: Integer): Boolean;
var
  SP: Integer;
  EP: Integer;
  OldEP: Integer;  
  TempStruc: TPDFStructure;
  Dict: TPDFObject;
  LengthObj: TPDFObject;
  FilterObj: TPDFObject;
  Filter: AnsiString;
  InWhitespace: Boolean;
  FoundStreamKeyword: Boolean;
  EndStreamLocation: Integer;
begin
  Result := False;
  SStart := 0;
  SLen := 0;

  TempStruc := TPDFStructure.Create;
  try
    Dict := nil;
    if QPLPos('stream', Content) > 0 then
    begin
      Dict := TempStruc.DecodeWithLength(Content, SP);
      Inc(SP);
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
          LengthObj := GetObject(TPDFIndRef(LengthObj).ObjNum);

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
          end;
        end;
      end;
    end;
  finally
    TempStruc.Free;
  end;
end;

function TSmartPDFReader.GetGenNum(ObjectNumber: Integer): Integer;
begin
  Result := 0;
  if (ObjectNumber >= 1) and (ObjectNumber < Length(XRefEntries)) then
  begin
    // Check if the object is stored inside an object stream
    if XRefEntries[ObjectNumber].T = 'c' then
    begin
      // 'c' = compressed (object is inside and object stream)
      // Objects inside an object stream always have a generation number
      // of zero
      Result := 0;
    end else
    begin
      // Normal object
      Result := XRefEntries[ObjectNumber].G;
    end;
  end;
end;

function TSmartPDFReader.GetPreviousTrailer: TPDFDictionary;
begin
  if Length(PreviousTrailers) > 0 then
    Result := PreviousTrailers[0]
  else
    Result := nil;
end;

function TSmartPDFReader.GetObjectSourceFromStream(StreamObjectNum, ObjNum,
  Index: Integer): AnsiString;
var
  X: Integer;
  N: Integer;
  First: Integer;
  Obj: TPDFObject;
  ObjStream: TPDFStream;
  S: AnsiString;
  TempStruct: TPDFStructure;
  Offsets: array of Integer;
  NArray: TPDFArray;
  Start: Integer;
  Len: Integer;
begin
  X := 0;
  Result := '';
  ObjStream := nil;
  while (not Assigned(ObjStream)) and (X < Length(FObjectStreams)) do
  begin
    if FObjectStreamNumbers[X] = StreamObjectNum then
      ObjStream := FObjectStreams[X];
    Inc(X);
  end;
  if not Assigned(ObjStream) then
  begin
    Obj := GetObject(StreamObjectNum);
    if Obj is TPDFStream then
    begin
      ObjStream := TPDFStream(Obj);
      X := Length(FObjectStreams);
      SetLength(FObjectStreams, X + 1);
      SetLength(FObjectStreamNumbers, X + 1);
      FObjectStreams[X] := ObjStream;
      FObjectStreamNumbers[X] := StreamObjectNum;
      if FIsEncrypted and Assigned(FOnObjStreamDecrypt) then
        FOnObjStreamDecrypt(StreamObjectNum, ObjStream);
      ObjStream.SetTo(ObjStream.GetDecodedStream, False);        
    end;
  end;
  if Assigned(ObjStream) then
  begin
    if ObjStream.Dictionary.DictType = 'ObjStm' then
    begin
      Obj := ObjStream.Dictionary.FindValueByKeyName('N');
      if Obj is TPDFNumeric then
      begin
        N := TPDFNumeric(Obj).AsInteger;
        if Index < N then
        begin
          Obj := ObjStream.Dictionary.FindValueByKeyName('First');
          if Obj is TPDFNumeric then
          begin
            First := TPDFNumeric(Obj).AsInteger;
            S := '[ ' + QPLCopy(ObjStream.Stream, 1, First) + ' ]';
            TempStruct := TPDFStructure.Create;
            try
              Obj := TempStruct.Decode(S);
              if (Obj is TPDFArray) and (TPDFArray(Obj).Count >= N * 2) then
              begin
                NArray := TPDFArray(Obj);
                SetLength(Offsets, N * 2);
                for X := 0 to (N * 2) - 1 do
                begin
                  Obj := NArray.Item[X];
                  if Obj is TPDFNumeric then
                    Offsets[X] := TPDFNumeric(Obj).AsInteger
                  else
                    Offsets[X] := 0;
                end;
                if Offsets[Index * 2] = ObjNum then
                begin
                  Start := Offsets[Index * 2 + 1] + First + 1;
                  if Index = (N - 1) then
                    Len := Length(ObjStream.Stream) - Start + 1
                  else
                    Len := (Offsets[Index * 2 + 3] + First) - Start + 1;
                  Result := QPLCopy(ObjStream.Stream, Start, Len);
                end;
              end;
            finally
              TempStruct.Free;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TSmartPDFReader.IsCompact(ObjNum: Integer): Boolean;
begin
  if ((ObjNum >= 1) and (ObjNum < Length(XRefEntries))) then
  begin
    Result := XRefEntries[ObjNum].T = 'c';
  end else
  begin
    Result := False;
  end;
end;

function TSmartPDFReader.GetObjectPosition(ObjectNumber: Integer): Integer;
begin
  Result := -1;
  if (ObjectNumber >= 1) and (ObjectNumber < Length(XRefEntries)) then
  begin
    if XRefEntries[ObjectNumber].T <> 'c' then
      Result := XRefEntries[ObjectNumber].N;
  end;
end;

function TSmartPDFReader.GetCachedObject(
  ObjectNumber: Integer): TPDFObject;
var
  X: Integer;
begin
  Result := nil;
  X := 0;
  while (not Assigned(Result)) and (X < Length(FObjectCacheIndex)) do
  begin
    if FObjectCacheIndex[X] = ObjectNumber then
      Result := FObjectCache[X];
    Inc(X);
  end;
  if not Assigned(Result) then
  begin
    Result := GetRawObject(ObjectNumber);
    if Length(FObjectCacheIndex) >= FObjectCacheSize then
    begin
      for X := 0 to FObjectCacheSize - 2 do
      begin
        FObjectCacheIndex[X] := FObjectCacheIndex[X + 1];
        FObjectCache[X] := FObjectCache[X + 1];
      end;
      SetLength(FObjectCacheIndex, FObjectCacheSize);
      SetLength(FObjectCache, FObjectCacheSize);
      FObjectCacheIndex[FObjectCacheSize - 1] := ObjectNumber;
      FObjectCache[FObjectCacheSize - 1] := Result;
    end else
    begin
      SetLength(FObjectCacheIndex, Length(FObjectCacheIndex) + 1);
      SetLength(FObjectCache, Length(FObjectCache) + 1);
      FObjectCacheIndex[Length(FObjectCacheIndex) - 1] := ObjectNumber;
      FObjectCache[Length(FObjectCache) - 1] := Result;
    end;
  end;
end;

function TSmartPDFReader.GetRawObject(ObjectNumber: Integer;
  Structure: TPDFStructure): TPDFObject;
var
  Source: AnsiString;
  StreamStart: Integer;
  StreamLength: Integer;
  ObjStream: TPDFStream;
begin
  Result := nil;
  if not Assigned(Structure) then Structure := FStructure;
  Source := GetObjectSource(ObjectNumber);
  if Source <> '' then
  begin
    Result := Structure.Decode(Source);
    StreamLength := 0;
    if (Result is TPDFDictionary) then
    begin
      if IsStream(Source, StreamStart, StreamLength) then
      begin
        ObjStream := Structure.NewStreamWithDict(QPLCopy(Source, StreamStart, StreamLength), TPDFDictionary(Result));
        Result := ObjStream;
      end;
    end;
  end;
end;

{ TSmartPDFInfo }

function TSmartPDFInfo.CheckPassword(const Password: WideString): Boolean;
begin
  Result := False;
  if Crypt.IsUserPassword(Password) or Crypt.IsOwnerPassword(Password) then
  begin
    Result := True;
  end;
end;

constructor TSmartPDFInfo.Create(Reader: TSmartPDFReader; const InitialPassword: WideString; NoBasic: Boolean = False);
begin
  FReader := Reader;
  FReader.OnIDChange := ReaderIDChange;
  FReader.OnObjStreamDecrypt := ReaderObjStreamDecrypt;
  FVersion := FReader.Version;
  FPageCount := 0;
  FRootDict := nil;
  FPagesDict := nil;
  FPagesRef := nil;
  FEncryptDict := nil;
  FAcroFormDict := nil;
  FEncrypted := spDecrypted;
  FFieldCount := 0;
  GetEncryption;
  Crypt := TSmartPDFCrypt.Create(FEncryption, FEncrypted, GetFileID);
  Crypt.SetPassword(InitialPassword);
  if (NoBasic and (((Encrypted = spEncrypted) and CheckPassword(InitialPassword)) or
    (Encrypted = spDecrypted))) then
  begin
    GetBasicProperties;
    GetFormFields;
  end;
end;

procedure TSmartPDFInfo.CryptObject(Obj: TPDFObject; ObjNum,
  GenNum: Integer);
begin
  Crypt.EncryptObject(Crypt.MakeKey(ObjNum, GenNum), Obj);
end;

destructor TSmartPDFInfo.Destroy;
begin
  Crypt.Free;
  inherited;
end;

function TSmartPDFInfo.Encrypt(const Owner, User: AnsiString;
  Strength: TSmartPDFEncryptionStrength; Perm: TSmartPDFPermissions;
  ExtraPerm: TSmartPDFExtraPermissions; NewObjNum: Integer): TPDFDictionary;
var
  OldSize: TPDFObject;
  CFDict: TPDFDictionary;
  StdCFDict: TPDFDictionary;
begin
  Crypt.SetupEncryption(Owner, User, Strength, Perm, ExtraPerm);

  FReader.TrailerDict.Add('Encrypt', FReader.TrailerDict.Owner.NewIndirectRef(NewObjNum, 0));
  OldSize := FReader.TrailerDict.FindValueByKeyName('Size', False);
  if OldSize is TPDFNumeric then
    TPDFNumeric(OldSize).SetTo(TPDFNumeric(OldSize).AsInteger + 1);
  FEncryptDict := FReader.TrailerDict.Owner.NewDictionary;
  Result := FEncryptDict;

  FEncryptDict.PurgeKey('Filter');
  FEncryptDict.PurgeKey('V');
  FEncryptDict.PurgeKey('R');
  FEncryptDict.PurgeKey('Length');
  FEncryptDict.PurgeKey('O');
  FEncryptDict.PurgeKey('UI');
  FEncryptDict.PurgeKey('P');

  FEncryptDict.Add('Filter', FEncryptDict.Owner.NewName('Standard'));
  if Strength = ssAES128Bit then
  begin
    FEncryptDict.Add('V', FEncryptDict.Owner.NewNumeric(4));
    FEncryptDict.Add('R', FEncryptDict.Owner.NewNumeric(4));
    FEncryptDict.Add('Length', FEncryptDict.Owner.NewNumeric(128));
    FEncryptDict.Add('StrF', FEncryptDict.Owner.NewCommonName('StdCF'));
    FEncryptDict.Add('StmF', FEncryptDict.Owner.NewCommonName('StdCF'));
    StdCFDict := FEncryptDict.Owner.NewDictionary;
    StdCFDict.Add('AuthEvent', FEncryptDict.Owner.NewCommonName('DocOpen'));
    StdCFDict.Add('Length', FEncryptDict.Owner.NewNumeric(16));
    StdCFDict.Add('CFM', FEncryptDict.Owner.NewCommonName('AESV2'));
    CFDict := FEncryptDict.Owner.NewDictionary;
    CFDict.Add('StdCF', StdCFDict);
    FEncryptDict.Add('CF', CFDict);
    FEncryption.Algorithm := eaAES;
  end else
  if Strength = ssAES256Bit then
  begin
    FEncryptDict.Add('V', FEncryptDict.Owner.NewNumeric(5));
    FEncryptDict.Add('R', FEncryptDict.Owner.NewNumeric(5));
    FEncryptDict.Add('Length', FEncryptDict.Owner.NewNumeric(256));
    FEncryptDict.Add('StrF', FEncryptDict.Owner.NewCommonName('StdCF'));
    FEncryptDict.Add('StmF', FEncryptDict.Owner.NewCommonName('StdCF'));
    StdCFDict := FEncryptDict.Owner.NewDictionary;
    StdCFDict.Add('AuthEvent', FEncryptDict.Owner.NewCommonName('DocOpen'));
    StdCFDict.Add('Length', FEncryptDict.Owner.NewNumeric(32));
    StdCFDict.Add('CFM', FEncryptDict.Owner.NewCommonName('AESV3'));
    CFDict := FEncryptDict.Owner.NewDictionary;
    CFDict.Add('StdCF', StdCFDict);
    FEncryptDict.Add('CF', CFDict);
    FEncryption.Algorithm := eaAES;
  end else
  if (Strength = ssAES256BitAcroX) then
  begin
    FEncryptDict.Add('V', FEncryptDict.Owner.NewNumeric(5));
    FEncryptDict.Add('R', FEncryptDict.Owner.NewNumeric(6));
    FEncryptDict.Add('Length', FEncryptDict.Owner.NewNumeric(256));
    FEncryptDict.Add('StrF', FEncryptDict.Owner.NewCommonName('StdCF'));
    FEncryptDict.Add('StmF', FEncryptDict.Owner.NewCommonName('StdCF'));
    StdCFDict := FEncryptDict.Owner.NewDictionary;
    StdCFDict.Add('AuthEvent', FEncryptDict.Owner.NewCommonName('DocOpen'));
    StdCFDict.Add('Length', FEncryptDict.Owner.NewNumeric(32));
    StdCFDict.Add('CFM', FEncryptDict.Owner.NewCommonName('AESV3'));
    CFDict := FEncryptDict.Owner.NewDictionary;
    CFDict.Add('StdCF', StdCFDict);
    FEncryptDict.Add('CF', CFDict);
    FEncryption.Algorithm := eaAES;
  end else
  begin
    if (Strength = ssStd) then
    begin
      FEncryptDict.Add('V', FEncryptDict.Owner.NewNumeric(1));
      FEncryptDict.Add('R', FEncryptDict.Owner.NewNumeric(2));
    end else
    {if (Strength = ssVariable) then
    begin
      FEncryptDict.Add('V', FEncryptDict.Owner.NewNumeric(2));
      FEncryptDict.Add('R', FEncryptDict.Owner.NewNumeric(3));
      FEncryptDict.Add('Length', FEncryptDict.Owner.NewNumeric(??));
    end else}
    begin
      FEncryptDict.Add('V', FEncryptDict.Owner.NewNumeric(2));
      FEncryptDict.Add('R', FEncryptDict.Owner.NewNumeric(3));
      FEncryptDict.Add('Length', FEncryptDict.Owner.NewNumeric(128));
    end;
  end;
  FEncryptDict.Add('O', FEncryptDict.Owner.NewString(Crypt.GetOwnerKey, smHex));
  FEncryptDict.Add('U', FEncryptDict.Owner.NewString(Crypt.GetUserKey, smHex));
  if ((Strength = ssAES256Bit) or (Strength = ssAES256BitAcroX)) then
  begin
    FEncryptDict.Add('OE', FEncryptDict.Owner.NewString(Crypt.GetOwnerEncKey, smHex));
    FEncryptDict.Add('UE', FEncryptDict.Owner.NewString(Crypt.GetUserEncKey, smHex));
    FEncryptDict.Add('Perms', FEncryptDict.Owner.NewString(Crypt.GetPermsKey, smHex));
  end;
  FEncryptDict.Add('P', FEncryptDict.Owner.NewNumeric(Integer(Crypt.GetPermKey)));
end;

function TSmartPDFInfo.FindPageRef(Page: Integer): TPDFIndRef;
var
  PC: Integer;
  Count: Integer;
  ThisDict: TPDFDictionary;
  Obj: TPDFObject;
  KidIndex: Integer;
  KidsArray: TPDFArray;

  function GetPageCount(Ref: TPDFIndRef): Integer;
  var
    O: TPDFObject;
    D: TPDFDictionary;
  begin
    Result := 0;
    O := FReader.GetObject(Ref.ObjNum);
    if O is TPDFDictionary then
    begin
      D := TPDFDictionary(O);
      if D.DictType = 'Pages' then
      begin
        O := D.FindValueByKeyName('Count');
        if O is TPDFIndRef then O := FReader.GetObject(TPDFIndRef(O).ObjNum);
        if O is TPDFNumeric then
          Result := TPDFNumeric(O).AsInteger;
      end;
      if D.DictType = 'Page' then
      begin
        Result := 1;
      end;
    end;
  end;

begin
  Count := 0;
  Result := nil;
  KidIndex := -1;
  KidsArray := nil;
  FLastPageNode := FPagesDict;
  FLastPageNodeRef := FPagesRef;
  ThisDict := FPagesDict;
  while Assigned(ThisDict) do
  begin
    Obj := ThisDict.FindValueByKeyName('Kids');
    if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFArray then
    begin
      KidsArray := TPDFArray(Obj);
      KidIndex := 0;
      PC := 0;
      while (KidIndex < KidsArray.Count) and (Count < Page) do
      begin
        Obj := KidsArray.Item[KidIndex];
        if Obj is TPDFIndRef then
          PC := GetPageCount(TPDFIndRef(Obj))
        else
          PC := 0;
        Count := Count + PC;
        Inc(KidIndex);
      end;
      if (Count >= Page) and (KidIndex > 0) then
      begin
        if PC = 1 then
        begin
          ThisDict := nil;
        end else
        begin
          Count := Count - PC;
          Obj := KidsArray.Item[KidIndex - 1];
          if Obj is TPDFIndRef then
          begin
            FLastPageNodeRef := TPDFIndRef(Obj);
            Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
          end;
          if Obj is TPDFDictionary then
          begin
            ThisDict := TPDFDictionary(Obj);
            FLastPageNode := ThisDict;
          end else
            ThisDict := nil;
        end;
      end else
        ThisDict := nil;
    end;
  end;
  if Assigned(KidsArray) and (Count = Page) and (KidIndex > 0) then
  begin
    Obj := KidsArray.Item[KidIndex - 1];
    if Obj is TPDFIndRef then
    begin
      Result := TPDFIndRef(Obj);
      Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
      if (Obj is TPDFDictionary) and (TPDFDictionary(Obj).DictType <> 'Page') then
        Result := nil;
    end;
  end;
end;

function TSmartPDFInfo.FindPageDict(Page: Integer): TPDFDictionary;
var
  Obj: TPDFObject;
  PageRef: TPDFIndRef;
begin
  Result := nil;
  PageRef := FindPageRef(Page);
  if Assigned(PageRef) then
  begin
    Obj := FReader.GetObject(PageRef.ObjNum);
    if Obj is TPDFDictionary then Result := TPDFDictionary(Obj);
  end;
end;

procedure TSmartPDFInfo.GetBasic;
begin
  GetBasicProperties;
  GetFormFields;
end;

procedure TSmartPDFInfo.GetBasicProperties;
var
  Obj: TPDFObject;
begin
  if Assigned(FReader.TrailerDict) then
  begin
    FRootRef := FReader.FindDictRef('Root');
    FRootDict := FReader.FindDict('Root');
    FInfoRef := FReader.FindDictRef('Info');
    FInfoDict := FReader.FindDict('Info');
    if Assigned(FRootDict) then
    begin
      // COMPLIANCE CHECK //
      //if FRootDict.DictType = 'Catalog' then
      begin
        Obj := FRootDict.FindValueByKeyName('Pages');
        if Obj is TPDFIndRef then
        begin
          FPagesRef := TPDFIndRef(Obj);
          Obj := FReader.GetObject(FPagesRef.ObjNum);
        end;
        if Obj is TPDFDictionary then
        begin
          FPagesDict := TPDFDictionary(Obj);
          if (FPagesDict.DictType = 'Pages') or (FPagesDict.FindValueByKeyName('Kids') <> nil) then
          begin
            Obj := FPagesDict.FindValueByKeyName('Count');
            if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
            if Obj is TPDFNumeric then
              FPageCount := TPDFNumeric(Obj).AsInteger;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSmartPDFInfo.GetEncryption;
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
    OE := '';
    UE := '';
    P := 0;
    EncryptMetadata := True;
  end;
  FEncryption.Algorithm := eaRC4;
  FEncryptDict := FReader.FindDict('Encrypt');
  if Assigned(FEncryptDict) then
  begin
    ED := FEncryptDict;
    Obj := ED.FindValueByKeyName('Filter');
    if Obj is TPDFName then Filter := TPDFName(Obj).Name else Filter := '';
    Obj := ED.FindValueByKeyName('V');
    if Obj is TPDFNumeric then V := TPDFNumeric(Obj).AsInteger else V := 0;
    Obj := ED.FindValueByKeyName('R');
    if Obj is TPDFNumeric then R := TPDFNumeric(Obj).AsInteger else R := 0;
    Obj := ED.FindValueByKeyName('Length');
    if Obj is TPDFNumeric then Length := TPDFNumeric(Obj).AsInteger else Length := 0;
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
              FEncryption.Algorithm := eaAES;
              Obj := StdCFDict.FindValueByKeyName('Length');
              if Obj is TPDFNumeric then
                FEncryption.Length := TPDFNumeric(Obj).AsInteger
              else
                FEncryption.Length := 128;
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
                FEncryption.Length := TPDFNumeric(Obj).AsInteger
              else
                FEncryption.Length := 40;
            end;
          end;
        end;
      end;
      if (V = 5) and ((R = 5) or (R = 6)) then
      begin
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
              FEncryption.Algorithm := eaAES;
              Obj := StdCFDict.FindValueByKeyName('Length');
              if Obj is TPDFNumeric then
                FEncryption.Length := TPDFNumeric(Obj).AsInteger
              else
                FEncryption.Length := 32;
              if (FEncryption.Length = 256) then
              begin
                FEncryption.Length := 32;
              end;
            end;
          end;
        end;
      end;
    end;
    if V <> 0 then
      FEncrypted := spEncrypted
    else
      FEncrypted := spUnknownEncryption;
  end else
    FEncrypted := spDecrypted;
end;

function TSmartPDFInfo.GetFileID: AnsiString;
var
  Obj: TPDFObject;
begin
  Result := '';
  Obj := FReader.TrailerDict.FindValueByKeyName('ID');
  if (Obj is TPDFArray) and (TPDFArray(Obj).Count > 0) then
  begin
    Obj := TPDFArray(Obj).Item[0];
    if Obj is TPDFString then Result := TPDFString(Obj).AsString;
  end;
end;

procedure TSmartPDFInfo.GetFormFields;
var
  Obj: TPDFObject;
begin
  if Assigned(FRootDict) then
  begin
    Obj := FRootDict.FindValueByKeyName('AcroForm');
    if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFDictionary then
    begin
      FAcroFormDict := TPDFDictionary(Obj);
      Obj := FAcroFormDict.FindValueByKeyName('Fields');
      if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
      if Obj is TPDFArray then
        FFieldCount := TPDFArray(Obj).Count;
    end;
  end;
end;

function TSmartPDFInfo.GetInfoValue(const Key: AnsiString): WideString;
var
  Obj: TPDFObject;
  IR: TPDFIndRef;
begin
  Result := '';
  if Assigned(FInfoDict) then
  begin
    IR := FInfoRef;
    Obj := FInfoDict.FindValueByKeyName(Key);
    if Obj is TPDFIndRef then
    begin
      IR := TPDFIndRef(Obj);
      Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
    end;
    if Obj is TPDFString then
    begin
      if (Crypt.Encrypted = spEncrypted) and (not FReader.IsCompact(IR.ObjNum)) then
      begin
        Crypt.DecryptObject(Crypt.MakeKey(IR.ObjNum, IR.GenNum), Obj);
        Result := TPDFString(Obj).AsTextString;
        Crypt.EncryptObject(Crypt.MakeKey(IR.ObjNum, IR.GenNum), Obj);
      end else
        Result := TPDFString(Obj).AsTextString;
    end;
    if Obj is TPDFStream then
    begin
      if (Crypt.Encrypted = spEncrypted) and (not FReader.IsCompact(IR.ObjNum)) then
      begin
        Crypt.DecryptObject(Crypt.MakeKey(IR.ObjNum, IR.GenNum), Obj);
        Result := TPDFStream(Obj).GetDecodedTextStream;
        Crypt.EncryptObject(Crypt.MakeKey(IR.ObjNum, IR.GenNum), Obj);
      end else
        Result := TPDFStream(Obj).GetDecodedTextStream;
    end;
  end;
end;

function TSmartPDFInfo.NiceFileID: AnsiString;
var
  X: Integer;
  S: AnsiString;
begin
  S := GetFileID;
  Result := '';
  for X := 1 to Length(Result) do
    Result := Result + QPLIntToHex(Ord(S[X]), 2);
end;

function TSmartPDFInfo.SecurityInfo(Item: Integer): AnsiString;
begin
  Result := QPLIntToStr(Crypt.SecurityInfo(Item));
end;

procedure TSmartPDFInfo.SetPassword(const NewPassword: WideString);
begin
  FPassword := NewPassword;
  Crypt.SetPassword(NewPassword);
  GetBasicProperties;
end;

// Returns the field names of all the blank signature fields.
// Field names placed into the string list are UTF-8 encoded
procedure TSmartPDFInfo.GetBlankSignatureNames(SL: TQuickPDFStringList);
var
  X: Integer;
  I: Integer;
  Obj: TPDFObject;
  Fields: TPDFArray;
  Count: Integer;

  function IsBlankSignature(Ref: TPDFIndRef): Boolean;
  var
    O: TPDFObject;
    D: TPDFDictionary;
    C: Boolean;
  begin
    Result := False;
    O := FReader.GetObject(Ref.ObjNum);
    if O is TPDFDictionary then
    begin
      D := TPDFDictionary(O);
      C := True;
      if C then
      begin
        O := D.FindValueByKeyName('Type');
        if O is TPDFName then C := TPDFName(O).Name = 'Annot';
      end;
      if C then
      begin
        O := D.FindValueByKeyName('Subtype');
        if O is TPDFName then C := TPDFName(O).Name = 'Widget';
      end;
      if C then
      begin
        O := D.FindValueByKeyName('FT');
        if O is TPDFName then C := TPDFName(O).Name = 'Sig';
      end;
      if C then
      begin
        Result := True;
        O := D.FindValueByKeyName('V');
        if (O is TPDFIndRef) or (O is TPDFDictionary) then Result := False;
      end;
    end;
  end;

begin
  I := SL.Count;
  SL.Add('0');
  Count := 0;
  if Assigned(FAcroFormDict) then
  begin
    Obj := FAcroFormDict.FindValueByKeyName('Fields');
    if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFArray then
    begin
      Fields := TPDFArray(Obj);
      for X := 0 to Fields.Count - 1 do
      begin
        if Fields.Item[X] is TPDFIndRef then
        begin
          if IsBlankSignature(TPDFIndRef(Fields.Item[X])) then
          begin
            Inc(Count);
            SL.Add(QPLUTF8Encode(GetFieldName(TPDFIndRef(Fields.Item[X]))));
          end;
        end;
      end;
    end;
    SL[I] := QPLIntToStr(Count);
  end;
end;

procedure TSmartPDFInfo.ReaderIDChange(Sender: TObject);
begin
  Crypt.FFileID := GetFileID;
end;

function TSmartPDFInfo.IsOwnerPassword: Boolean;
begin
  Result := Crypt.IsOwnerPassword(FPassword);
end;

procedure TSmartPDFInfo.ReaderObjStreamDecrypt(ObjNum: Integer;
  Stream: TPDFStream);
begin
  if Crypt.Encrypted = spEncrypted then
    Crypt.DecryptObject(Crypt.MakeKey(ObjNum, 0), Stream);
end;

function TSmartPDFInfo.GetMetadata: AnsiString;
var
  Obj: TPDFObject;
  Stream: TPDFStream;
begin
  Result := '';
  if Assigned(FRootDict) then
  begin
    Obj := FRootDict.FindValueByKeyName('Metadata', False);
    if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFStream then
    begin
      Stream := TPDFStream(Obj);
      if TPDFStream(Obj).Dictionary.DictType = 'Metadata' then
      begin
        // Check for both "Subtype" and "SubType"
        Obj := Stream.Dictionary.FindValueByKeyName('Subtype', False);
        if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
        if Obj is TPDFName and (TPDFName(Obj).Name = 'XML') then
          Result := Stream.GetDecodedStream;
        Obj := Stream.Dictionary.FindValueByKeyName('SubType', False);
        if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
        if Obj is TPDFName and (TPDFName(Obj).Name = 'XML') then
          Result := Stream.GetDecodedStream;
      end;
    end;
  end;
end;

procedure TSmartPDFInfo.DecryptObject(Obj: TPDFObject; ObjNum,
  GenNum: Integer);
begin
  Crypt.DecryptObject(Crypt.MakeKey(ObjNum, GenNum), Obj);
end;

function TSmartPDFInfo.GetFieldName(FieldRef: TPDFIndRef): WideString;
var
  O: TPDFObject;
  D: TPDFDictionary;
begin
  Result := '';
  O := FReader.GetObject(FieldRef.ObjNum);
  if O is TPDFDictionary then
  begin
    D := TPDFDictionary(O);
    O := D.FindValueByKeyName('Parent');
    if O is TPDFIndRef then Result := GetFieldName(TPDFIndRef(O)) + '.';
    O := D.FindValueByKeyName('T');

    if O is TPDFString then
    begin
      if (Crypt.Encrypted = spEncrypted) and (not FReader.IsCompact(FieldRef.ObjNum)) then
      begin
        Crypt.DecryptObject(Crypt.MakeKey(FieldRef.ObjNum, FieldRef.GenNum), O);
        Result := Result + TPDFString(O).AsTextString;
        Crypt.EncryptObject(Crypt.MakeKey(FieldRef.ObjNum, FieldRef.GenNum), O);
      end else
        Result := Result + TPDFString(O).AsTextString;        
    end;
  end;
end;


function TSmartPDFInfo.ContainsUsageRights: Boolean;
var
  Obj: TPDFObject;
  PermsDict: TPDFDictionary;
begin
  Result := False;
  if Assigned(FRootDict) then
  begin
    Obj := FRootDict.FindValueByKeyName('Perms', False);
    if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFDictionary then
    begin
      PermsDict := TPDFDictionary(Obj);
      Obj := PermsDict.FindValueByKeyName('UR3', False);
      if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
      if Obj is TPDFDictionary then
      begin
        Result := True;
      end;
    end;
  end;
end;

function TSmartPDFInfo.GetUsageRightsName: WideString;
var
  Obj: TPDFObject;
  PermsDict: TPDFDictionary;
  UR3Dict: TPDFDictionary;
begin
  Result := '';
  if Assigned(FRootDict) then
  begin
    Obj := FRootDict.FindValueByKeyName('Perms', False);
    if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFDictionary then
    begin
      PermsDict := TPDFDictionary(Obj);
      Obj := PermsDict.FindValueByKeyName('UR3', False);
      if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
      if Obj is TPDFDictionary then
      begin
        UR3Dict := TPDFDictionary(Obj);
        Obj := UR3Dict.FindValueByKeyName('Name', False);
        if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
        if Obj is TPDFString then
        begin
          Result := TPDFString(Obj).AsTextString;
        end;
      end;
    end;
  end;
end;

{ TSmartPDFCrypt }

constructor TSmartPDFCrypt.Create(Parm: TSmartPDFEncryption; Encrypted: TSmartPDFEncrypted; const FileID: AnsiString);
begin
  FEncryption := Parm;
  FEncrypted := Encrypted;
  FFileID := FileID;
  FPassword := '';
  DecodePermKey(Parm.P);
end;

procedure TSmartPDFCrypt.SetPassword(const NewPassword: WideString);
begin
  if IsUserPassword(NewPassword) or IsOwnerPassword(NewPassword) then
  begin
    FPassword := '!' + NewPassword;
    IndObjEncKey := EncryptionKey;
  end else
    FPassword := '';
end;

function TSmartPDFCrypt.CalculateVer6Hash(var SHAInput: TQPLByteArray; const PasswordA: AnsiString; TruncLength: Integer; const UK: AnsiString): AnsiString;
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
  until (Byte(E[Length(E)]) <= (RoundNumber - 31)) and (RoundNumber >= 63);
  TestHash := QPLCopy(K, 1, 32);

  Result := TestHash;
end;

function TSmartPDFCrypt.IsOwnerPassword(const Password: WideString): Boolean;
var
  PE: TSmartPDFEncrypted;
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
  PE := Encrypted;
  if (PE = spDecrypted) then
  begin
    Result := Password = '';
  end else
  begin
    if (FEncryption.Length = 40) then
    begin
      FEncryptionStrength := ssStd;
    end else
    if ((FEncryption.Length > 40) and (FEncryption.Length < 128)) then
    begin
      FEncryptionStrength := ssVariable;
    end else
    begin
      FEncryptionStrength := ss128Bit;
    end;

    if FEncryption.Algorithm = eaAES then
    begin
      FEncryptionStrength := ssAES128Bit;
    end;

    if ((FEncryption.Algorithm = eaAES) and (FEncryption.Length = 32)) then
    begin
      if (FEncryption.R = 6) then
      begin
        FEncryptionStrength := ssAES256BitAcroX;
      end else
      begin
        FEncryptionStrength := ssAES256Bit;
      end;

      PasswordA := QPLUTF8Encode(Password);

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

    FOwnerPassword := AnsiString(Password);
    FUserPassword := AnsiString(Password);
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

function TSmartPDFCrypt.IsUserPassword(const Password: WideString): Boolean;
var
  PE: TSmartPDFEncrypted;
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
  PE := FEncrypted;

  if (PE = spDecrypted) then
  begin
    Result := Password = '';
  end else
  begin
    if (FEncryption.Length = 40) then
    begin
      FEncryptionStrength := ssStd;
    end else
    if ((FEncryption.Length > 40) and (FEncryption.Length < 128)) then
    begin
      FEncryptionStrength := ssVariable;
    end else
    begin
      FEncryptionStrength := ss128Bit;
    end;

    if FEncryption.Algorithm = eaAES then
    begin
      FEncryptionStrength := ssAES128Bit;
    end;

    if ((FEncryption.Algorithm = eaAES) and (FEncryption.Length = 32)) then
    begin
      if (FEncryption.R = 6) then
      begin
        FEncryptionStrength := ssAES256BitAcroX;
      end else
      begin
        FEncryptionStrength := ssAES256Bit;
      end;

      PasswordA := QPLUTF8Encode(Password);
      TruncLength := Length(PasswordA);
      if (Length(PasswordA) > 127) then
      begin
        TruncLength := 127;
      end;

      SetLength(SHA256Input, TruncLength + 8);
      if (Length(PasswordA) > 0) then
      begin
        Move(PasswordA[1], SHA256Input[0], TruncLength);
      end;
      if (Length(FEncryption.U) >= 48) then
      begin
        Move(FEncryption.U[33], SHA256Input[TruncLength], 8);
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
        TestHash := CalculateVer6Hash(SHA256Input, PasswordA, TruncLength, '');
        // End R = 6
      end;

      if (TestHash = QPLCopy(FEncryption.U, 1, 32)) then
      begin
        // The supplied Password is the user password
        Result := True;

        SetLength(SHA256Input, TruncLength + 8);
        if (Length(PasswordA) > 0) then
        begin
          Move(PasswordA[1], SHA256Input[0], TruncLength);
        end;
        if (Length(FEncryption.U) >= 48) then
        begin
          Move(FEncryption.U[41], SHA256Input[TruncLength], 8);
        end;

        if (FEncryption.R = 5) then
        begin
          SHA256Digest := SHA256ByteArray(SHA256Input);
          SetLength(IntermediateOwnerKey, 32);
          Move(SHA256Digest[0], IntermediateOwnerKey[1], 32);
        end else
        if (FEncryption.R = 6) then
        begin
          IntermediateOwnerKey := CalculateVer6Hash(SHA256Input, PasswordA, TruncLength, '');
        end;

        ZeroInit := AnsiString(StringOfChar(#0, 16));
        EncryptionKey := AES256DecryptString(IntermediateOwnerKey,
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

    FUserPassword := AnsiString(Password);
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

procedure TSmartPDFCrypt.DecodePermKey(PKey: Cardinal);
begin
  PermKey := Cardinal(PKey);
  MalformedPermKey := (PermKey and $FFFF0000) = 0;

  FPermissions := [];
  FExtraPermissions := [];

  if (PermKey and 4) = 4 then
    FPermissions := FPermissions + [spCanPrint];
  if (PermKey and 8) = 8 then
    FPermissions := FPermissions + [spCanChange];
  if (PermKey and 16) = 16 then
    FPermissions := FPermissions + [spCanCopy];
  if (PermKey and 32) = 32 then
    FPermissions := FPermissions + [spCanAddNotes];

  if (PermKey and $0100) = $0100 then
    FExtraPermissions := FExtraPermissions + [spCanFillFields];
  if (PermKey and $0200) = $0200 then
    FExtraPermissions := FExtraPermissions + [spCanCopyAccess];
  if (PermKey and $0400) = $0400 then
    FExtraPermissions := FExtraPermissions + [spCanAssemble];
  if (PermKey and $0800) = $0800 then
    FExtraPermissions := FExtraPermissions + [spCanPrintFull];
end;

procedure TSmartPDFCrypt.GenerateEncryptionKeys;
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
  EncryptionKey := '';
  SetLength(Padding, 32);
  for X := 1 to 32 do
    Padding[X] := AnsiChar(PadData[X]);

  FileID := FFileID;

  case FEncryptionStrength of
    ssStd: KeyLength := 5;
    ss128Bit: KeyLength := 16;
    ssAES128Bit: KeyLength := 16;
    ssVariable: KeyLength := (FEncryption.Length div 8);
  else
    KeyLength := 5;
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

    if ((FEncryptionStrength <> ssStd) or (FEncryption.R >= 3)) then
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

    if ((FEncryptionStrength <> ssStd) or (FEncryption.R >= 3)) then
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

  if ((FEncryptionStrength <> ssStd) or (FEncryption.R >= 3)) then
  begin
    for X := 1 to 50 do
    begin
      Digest := MD5String(QPLCopy(MD5DigestToString(Digest), 1, KeyLength));
    end;
  end;

  SetLength(ARC4Key, KeyLength);
  for X := 1 to KeyLength do
    ARC4Key[X] := AnsiChar(Digest[X - 1]);
  if EncryptionKey = '' then
    EncryptionKey := ARC4Key;

  if ((FEncryptionStrength <> ssStd) or (FEncryption.R >= 3)) then
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
    UserKey := ARC4Encrypt(ARC4Key, Padding);
end;

procedure TSmartPDFCrypt.GenerateEncryptionKeys256;
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

  if (FEncryptionStrength = ssAES256Bit) then
  begin
    SHA256Digest := SHA256ByteArray(SHA256Input);
  end else
  if (FEncryptionStrength = ssAES256BitAcroX) then
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

  if (FEncryptionStrength = ssAES256Bit) then
  begin
    SHA256Digest := SHA256ByteArray(SHA256Input);
  end else
  if (FEncryptionStrength = ssAES256BitAcroX) then
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

  if (FEncryptionStrength = ssAES256Bit) then
  begin
    SHA256Digest := SHA256ByteArray(SHA256Input);
  end else
  if (FEncryptionStrength = ssAES256BitAcroX) then
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

  if (FEncryptionStrength = ssAES256Bit) then
  begin
    SHA256Digest := SHA256ByteArray(SHA256Input);
  end else
  if (FEncryptionStrength = ssAES256BitAcroX) then
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

function TSmartPDFCrypt.MakeKey(ObjNum, GenNum: Integer): AnsiString;
var
  S: AnsiString;
  Digest: MD5Digest;
  X: Integer;
  L: Integer;
begin
  if ((FEncryptionStrength = ssAES256Bit) or (FEncryptionStrength = ssAES256BitAcroX)) then
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
  if FEncryption.Algorithm = eaAES then
    S := S + 'sAlT';
  Digest := MD5String(S);
  SetLength(Result, L + 5);
  if Length(Result) > 16 then SetLength(Result, 16);
  for X := 0 to Length(Result) - 1 do
    Result[X + 1] := AnsiChar(Digest[X]);
end;

procedure TSmartPDFCrypt.EncryptObject(const Key: AnsiString; Obj: TPDFObject);
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
    if FEncryption.Algorithm = eaRC4 then
      Value := ARC4Encrypt(Key, Value)
    else
      Value := AESEncryptString(Key, Value);
    TPDFString(Obj).SetTo(Value);
  end else
  if Obj is TPDFStream then
  begin
    Value := TPDFStream(Obj).Stream;
    if FEncryption.Algorithm = eaRC4 then
      Value := ARC4Encrypt(Key, Value)
    else
      Value := AESEncryptString(Key, Value);
    TPDFStream(Obj).Stream := Value;
    EncryptObject(Key, TPDFStream(Obj).Dictionary);
  end;
end;

procedure TSmartPDFCrypt.SetupEncryption(const OwnerPassword,
  UserPassword: AnsiString; Strength: TSmartPDFEncryptionStrength;
  Perm: TSmartPDFPermissions; ExtraPerm: TSmartPDFExtraPermissions);
begin
  FOwnerPassword := OwnerPassword;
  FUserPassword := UserPassword;
  FEncryptionStrength := Strength;
  FPermissions := Perm;
  FExtraPermissions := ExtraPerm;
  EncodePermKey;
  if (Strength = ssAES256Bit) then
  begin
    FEncryption.Algorithm := eaAES;
    GenerateEncryptionKeys256;
    IndObjEncKey := EncryptionKey;
    Exit;
  end;
  if (Strength = ssAES256BitAcroX) then
  begin
    FEncryption.Algorithm := eaAES;
    GenerateEncryptionKeys256;
    IndObjEncKey := EncryptionKey;
    Exit;
  end;
  GenerateEncryptionKeys;
  IndObjEncKey := EncryptionKey;
  if Strength = ssAES128Bit then
    FEncryption.Algorithm := eaAES;
end;

function TSmartPDFCrypt.SecurityInfo(SecurityItem: Integer): Integer;
var
  P: Cardinal;
  Enc: TSmartPDFEncrypted;
begin
  P := PermKey;
  Enc := FEncrypted;
  Result := 11;
  case Enc of
    spDecrypted:
    begin
      case SecurityItem of
        0: Result := 0;
        1..2: Result := 2;
        3: Result := 4;
        4..9: Result := 6;
        10: Result := 11;
      end;
    end;

    spUnknownEncryption:
      Result := 9;

    spEncrypted:
    begin
      case SecurityItem of
         0: Result := 1;
         1: begin
              if IsUserPassword('') then
                Result := 2
              else
                Result := 3;
            end;
         2: begin
              if IsOwnerPassword('') then
                Result := 2
              else
              begin
                if FPassword <> '' then
                begin
                  if IsOwnerPassword(Copy(FPassword, 2, 32)) then
                    Result := 2
                  else
                    Result := 3;
                end else
                  Result := 3;
              end;
            end;
         3: begin
              if P and 4 = 4 then
              begin
                if FEncryptionStrength = ssStd then
                  Result := 4 else
                begin
                  if P and $0800 = $0800 then
                    Result := 4
                  else
                    Result := 10;
                end;
              end else
                Result := 5;
            end;
         4: if P and 8 = 8 then Result := 6
              else Result := 5;
         5: if P and 16 = 16 then Result := 6
              else Result := 5;
         6: if P and 32 = 32 then Result := 6
              else Result := 5;
         7: if ((FEncryptionStrength = ss128Bit) or (FEncryptionStrength = ssAES128Bit)) and
              (P and $0100 = $0100) then Result := 6
                else Result := 5;
         8: if ((FEncryptionStrength = ss128Bit) or (FEncryptionStrength = ssAES128Bit)) and
              (P and $0200 = $0200) then Result := 6
                else Result := 5;
         9: if ((FEncryptionStrength = ss128Bit) or (FEncryptionStrength = ssAES128Bit)) and
              (P and $0400 = $0400) then Result := 6
                else Result := 5;
        10: begin
              if (FEncryptionStrength = ssStd) then
              begin
                Result := 7;
              end;
              if (FEncryptionStrength = ss128Bit) then
              begin
                Result := 8;
              end;
              if (FEncryptionStrength = ssAES128Bit) then
              begin
                Result := 12;
              end;
              if (FEncryptionStrength = ssAES256Bit) then
              begin
                Result := 13;
              end;
              if (FEncryptionStrength = ssAES256BitAcroX) then
              begin
                Result := 15;
              end;
              if ((FEncryption.Length > 40) and (FEncryption.Length < 128)) then
              begin
                Result := 14;
              end;
            end;
        11:
        begin
          if (IsUserPassword(Copy(FPassword, 2, 32))) then
          begin
            Result := 3;  // Yes
          end else
          begin
            Result := 2;  // No
          end;
        end;
        12:
        begin
          if (IsOwnerPassword(Copy(FPassword, 2, 32))) then
          begin
            Result := 3;  // Yes
          end else
          begin
            Result := 2;  // No
          end;
        end;
        13:
        begin
          if ((FEncryption.Length > 40) and (FEncryption.Length < 128)) then
          begin
            Result := FEncryption.Length;
          end else
          begin
            Result := 0;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSmartPDFCrypt.DecryptObject(const Key: AnsiString;
  Obj: TPDFObject);
var
  Value: AnsiString;
  DX: Integer;
  DictType: AnsiString;
  MustDecrypt: Boolean;
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
    DictType := TPDFStream(Obj).Dictionary.DictType;
    if (DictType = 'Metadata') then
    begin
      MustDecrypt := FEncryption.EncryptMetadata;
    end else
    if (DictType = 'XRef') then
    begin
      MustDecrypt := False;
    end else
    begin
      MustDecrypt := True;
    end;
    if (MustDecrypt) then
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

procedure TSmartPDFCrypt.EncodePermKey;
begin
  PermKey := $FFFFFFFC;

  if not (spCanPrint in FPermissions) then
    PermKey := PermKey and $FFFFFFF8;
  if not (spCanChange in FPermissions) then
    PermKey := PermKey and $FFFFFFF4;
  if not (spCanCopy in FPermissions) then
    PermKey := PermKey and $FFFFFFEC;
  if not (spCanAddNotes in FPermissions) then
    PermKey := PermKey and $FFFFFFDC;

  if FEncryptionStrength <> ssStd then
  begin
    if not (spCanFillFields in FExtraPermissions) then
      PermKey := PermKey and $FFFFFEFF;
    if not (spCanCopyAccess in FExtraPermissions) then
      PermKey := PermKey and $FFFFFDFF;
    if not (spCanAssemble in FExtraPermissions) then
      PermKey := PermKey and $FFFFFBFF;
    if not (spCanPrintFull in FExtraPermissions) then
      PermKey := PermKey and $FFFFF7FF;
  end;
end;

{ TSmartPDFWriter }

procedure TSmartPDFWriter.AddObject(ObjNum, GenNum: Integer;
  const ObjectData: AnsiString);
var
  Buffer: AnsiString;
  Start: Int64;
begin
  ObjectNum.Add(ObjNum);
  ObjectGen.Add(GenNum);
  Start := FStream.Position;
  if Length(ObjectPos) < (ObjectNum.Count + 10) then
    SetLength(ObjectPos, ObjectNum.Count + 100);
  ObjectPos[ObjectNum.Count - 1] := Start;

  Buffer := QPLIntToStr(ObjNum) + ' ' + QPLIntToStr(GenNum) + ' obj'#10;
  FStream.Write(Buffer[1], Length(Buffer));
  Buffer := ObjectData;

  if QPLCopy(Buffer, Length(Buffer), 1) <> #10 then Buffer := Buffer + #10;
  FStream.Write(Buffer[1], Length(Buffer));
  Buffer := 'endobj'#10;
  FStream.Write(Buffer[1], Length(Buffer));

  ObjectLength.Add(FStream.Position - Start);
end;

procedure TSmartPDFWriter.AddTrailer(TrailerDict: TPDFDictionary; Offset: Int64;
  AddFree: Boolean; PreviousXRefPos: Int64);
var
  XRefPos: Int64;
  Buffer: AnsiString;
  X: Integer;
  Start: Integer;
  Check: Integer;
  Max: Integer;
  I: Integer;
  Next: Integer;
  FreeGen: Integer;
  BigBuffer: AnsiString;
  UniqueList: TQPLSortedUniqueIntegerList;
  NumPosList: TQPLInt64PairList;
  ObjPos: Int64;
  ObjPosGen: Int64;

  function NextFree(SX, MX: Integer): Integer;
  begin
    Result := 0;
    while (Result = 0) and (SX < MX) do
    begin
      if ObjectNum.IndexOf(SX) < 0 then Result := SX;
      Inc(SX);
    end;
  end;

begin
  XRefPos := FStream.Position + Offset;

  Buffer := 'xref'#10;
  FStream.Write(Buffer[1], Length(Buffer));

  UniqueList := TQPLSortedUniqueIntegerList.Create;
  NumPosList := TQPLInt64PairList.Create;

  Max := 0;
  for X := 0 to ObjectNum.Count - 1 do
  begin
    if ObjectNum[X] > Max then Max := ObjectNum[X];
    UniqueList.AddUnique(ObjectNum[X]);
  end;

  if AddFree then
  begin
    Buffer := '0 ' + QPLIntToStr(Max + 1) + #10;
    FStream.Write(Buffer[1], Length(Buffer));

    SetLength(BigBuffer, (Max + 1) * 20);
    for X := 0 to Max do
    begin
      I := ObjectNum.IndexOf(X);
      if I < 0 then
      begin
        if X = 0 then
          FreeGen := 65535
        else
          FreeGen := 1;
        Next := NextFree(X + 1, Max);
        Buffer := QPLFormatFloat('0000000000', Next);
        Buffer := Buffer + ' ';
        Buffer := Buffer + QPLFormatFloat('00000', FreeGen);
        Buffer := Buffer + ' f '#10;
      end else
      begin
        Buffer := QPLFormatFloat('0000000000', ObjectPos[I] + Offset);
        Buffer := Buffer + ' ';
        Buffer := Buffer + QPLFormatFloat('00000', ObjectGen[I]);
        Buffer := Buffer + ' n '#10;
      end;
      Move(Buffer[1], BigBuffer[X * 20 + 1], 20);
    end;
    FStream.Write(BigBuffer[1], Length(BigBuffer));

{    for X := 0 to Max do
    begin
      I := ObjectNum.IndexOf(X);
      if I < 0 then
      begin
        if X = 0 then
          FreeGen := 65535
        else
          FreeGen := 1;
        Next := NextFree(X + 1, Max);
        Buffer := QPLFormatFloat('0000000000', Next);
        Buffer := Buffer + ' ';
        Buffer := Buffer + QPLFormatFloat('00000', FreeGen);
        Buffer := Buffer + ' f '#10;
      end else
      begin
        Buffer := QPLFormatFloat('0000000000', ObjectPos[I] + Offset);
        Buffer := Buffer + ' ';
        Buffer := Buffer + QPLFormatFloat('00000', ObjectGen[I]);
        Buffer := Buffer + ' n '#10;
      end;
      FStream.Write(Buffer[1], Length(Buffer));
    end;}



  end else
  begin
    Start := 0;
    repeat
      Check := Start;
      repeat
        Inc(Check);
      until (not UniqueList.Contains(Check)) or (Check > Max);
      Dec(Check);

      for X := 0 to ObjectNum.Count - 1 do
      begin
        ObjPosGen := ObjectGen[X];
        ObjPosGen := ObjPosGen shl 56;
        ObjPos := ObjectPos[X] and $FFFFFFFFFFFFFF;
        NumPosList.Add(ObjectNum[X], ObjPos or ObjPosGen);
      end;
      NumPosList.Sort;

      Buffer := QPLIntToStr(Start) + ' ' + QPLIntToStr(Check - Start + 1) + #10;
      FStream.Write(Buffer[1], Length(Buffer));
      SetLength(BigBuffer, ((Check - Start) + 1) * 20);
      for X := Start to Check do
      begin
        if X = 0 then Buffer := '0000000000 65535 f '#10 else
        begin
          ObjPosGen := NumPosList.GetValue(X);
          Buffer := QPLFormatFloat('0000000000', (ObjPosGen and $FFFFFFFFFFFFFF) + Offset);
          Buffer := Buffer + ' ';
          Buffer := Buffer + QPLFormatFloat('00000', ObjPosGen shr 56);
          Buffer := Buffer + ' n '#10;
        end;
        Move(Buffer[1], BigBuffer[(X - Start) * 20 + 1], 20);
      end;
      FStream.Write(BigBuffer[1], Length(BigBuffer));
      Start := Check;
      repeat
        Inc(Start);
      until (UniqueList.Contains(Start)) or (Start > Max);
      if Start > Max then Check := Max;
    until Check = Max;
  end;

  Buffer := 'trailer'#10;
  FStream.Write(Buffer[1], Length(Buffer));
  if AddFree then
    TrailerDict.Add('Size', TrailerDict.Owner.NewNumeric(Max + 1));
  Buffer := TrailerDict.Output;
  if QPLCopy(Buffer, Length(Buffer), 1) <> #10 then
    Buffer := Buffer + #10;
  FStream.Write(Buffer[1], Length(Buffer));
  Buffer := 'startxref'#10 + AnsiString(IntToStr(XRefPos)) + #10'%%EOF'#10;
  FStream.Write(Buffer[1], Length(Buffer));

  UniqueList.Free;
  NumPosList.Free;
end;

procedure TSmartPDFWriter.AddXRefStream(TrailerDict: TPDFDictionary;
  Offset: Int64; AddFree: Boolean; PreviousXRefPos: Int64);
var
  XRefPos: Int64;
  Buffer: AnsiString;
  X: Integer;
  Start: Integer;
  Check: Integer;
  Max: Integer;
  I: Integer;
  Next: Int64;
  FreeGen: Integer;
  XRefStream: AnsiString;
  Index: AnsiString;
  Stream: TPDFStream;
  Obj: TPDFObject;
  MaxPos: Int64;
  PosWidth: Integer;
  TrailerObjNum: Integer;

  function NextFree(SX, MX: Integer): Integer;
  begin
    Result := 0;
    while (Result = 0) and (SX < MX) do
    begin
      if ObjectNum.IndexOf(SX) < 0 then Result := SX;
      Inc(SX);
    end;
  end;

  procedure AddWord(ThisNum: Cardinal);
  begin
    XRefStream := XRefStream +
      AnsiChar((ThisNum and $FF00) shr 8) +
      AnsiChar(ThisNum and $FF);
  end;

  procedure Add3Byte(ThisNum: Cardinal);
  begin
    XRefStream := XRefStream +
      AnsiChar((ThisNum and $FF0000) shr 16) +
      AnsiChar((ThisNum and $FF00) shr 8) +
      AnsiChar(ThisNum and $FF);
  end;

  procedure AddCardinal(ThisNum: Cardinal);
  begin
    XRefStream := XRefStream +
      AnsiChar((ThisNum and $FF000000) shr 24) +
      AnsiChar((ThisNum and $FF0000) shr 16) +
      AnsiChar((ThisNum and $FF00) shr 8) +
      AnsiChar(ThisNum and $FF);
  end;

  procedure Add5Byte(ThisNum: Int64);
  begin
    XRefStream := XRefStream +
      AnsiChar((ThisNum and $FF00000000) shr 32) +
      AnsiChar((ThisNum and $FF000000) shr 24) +
      AnsiChar((ThisNum and $FF0000) shr 16) +
      AnsiChar((ThisNum and $FF00) shr 8) +
      AnsiChar(ThisNum and $FF);
  end;

  procedure Add6Byte(ThisNum: Int64);
  begin
    XRefStream := XRefStream +
      AnsiChar((ThisNum and $FF0000000000) shr 40) +
      AnsiChar((ThisNum and $FF00000000) shr 32) +
      AnsiChar((ThisNum and $FF000000) shr 24) +
      AnsiChar((ThisNum and $FF0000) shr 16) +
      AnsiChar((ThisNum and $FF00) shr 8) +
      AnsiChar(ThisNum and $FF);
  end;

  procedure AddByte(ThisNum: Cardinal);
  begin
    XRefStream := XRefStream + AnsiChar(ThisNum and $FF);
  end;

begin
  XRefPos := FStream.Position + Offset;

  Max := 0;
  for X := 0 to ObjectNum.Count - 1 do
    if ObjectNum[X] > Max then Max := ObjectNum[X];

  TrailerObjNum := Max + 1;

  Obj := TrailerDict.FindValueByKeyName('Size');
  if Obj is TPDFNumeric then
  begin
    TPDFNumeric(Obj).SetTo(TrailerObjNum + 1);
  end else
  begin
    TrailerDict.Add('Size', TrailerDict.Owner.NewNumeric(TrailerObjNum + 1));
  end;

  ObjectNum.Add(TrailerObjNum + 1);
  ObjectGen.Add(0);
  if Length(ObjectPos) < (ObjectNum.Count + 10) then
    SetLength(ObjectPos, ObjectNum.Count + 100);
  ObjectPos[ObjectNum.Count - 1] := FStream.Position;
  ObjectLength.Add(0);

  XRefStream := '';
  Index := '';

  MaxPos := 0;
  for X := 0 to Max do
  begin
    I := ObjectNum.IndexOf(X);
    if (I >= 0) then
    begin
      if ((ObjectPos[I] + Offset) > MaxPos) then
      begin
        MaxPos := ObjectPos[I] + Offset;
      end;
    end;
  end;
  PosWidth := 2;
  if (MaxPos > $FFFFFFFFFF) then
  begin
    PosWidth := 6;
  end else
  if (MaxPos > $FFFFFFFF) then
  begin
    PosWidth := 5;
  end else
  if (MaxPos > $FFFFFF) then
  begin
    PosWidth := 4;
  end else
  if (MaxPos > $FFFF) then
  begin
    PosWidth := 3;
  end;

  if AddFree then
  begin
    Index := Index + '0 ' + QPLIntToStr(Max + 1) + ' ';
    for X := 0 to Max do
    begin
      I := ObjectNum.IndexOf(X);
      if I < 0 then
      begin
        if X = 0 then
          FreeGen := 65535
        else
          FreeGen := 1;
        Next := NextFree(X + 1, Max);
        AddByte(0);
        case PosWidth of
          2: AddWord(Next);
          3: Add3Byte(Next);
          4: AddCardinal(Next);
          5: Add5Byte(Next);
          6: Add6Byte(Next);
        end;
        AddWord(FreeGen);
      end else
      begin
        AddByte(1);
        case PosWidth of
          2: AddWord(ObjectPos[I] + Offset);
          3: Add3Byte(ObjectPos[I] + Offset);
          4: AddCardinal(ObjectPos[I] + Offset);
          5: Add5Byte(ObjectPos[I] + Offset);
          6: Add6Byte(ObjectPos[I] + Offset);
        end;
        AddWord(ObjectGen[I]);
      end;
    end;
  end else
  begin
    Start := 0;
    if (ObjectNum.Count > 0) then
    begin
      Start := ObjectNum[0];
      for X := 1 to ObjectNum.Count - 1 do
      begin
        if (ObjectNum[X] < Start) then
        begin
          Start := ObjectNum[X];
        end;
      end;
    end;

    repeat
      Check := Start;
      repeat
        Inc(Check);
      until (ObjectNum.IndexOf(Check) < 0) or (Check > Max);
      Dec(Check);

      if (Start > 0) then
      begin
        Index := Index + QPLIntToStr(Start) + ' ' + QPLIntToStr(Check - Start + 1) + ' ';
      end;
      for X := Start to Check do
      begin
        if X = 0 then
        begin
          //AddByte(0);
          //Add3Byte(0);
          //AddWord(65535);
        end else
        begin
          I := ObjectNum.IndexOf(X);
          AddByte(1);
          case PosWidth of
            2: AddWord(ObjectPos[I] + Offset);
            3: Add3Byte(ObjectPos[I] + Offset);
            4: AddCardinal(ObjectPos[I] + Offset);
            5: Add5Byte(ObjectPos[I] + Offset);
            6: Add6Byte(ObjectPos[I] + Offset);
          end;
          AddWord(ObjectGen[I]);
        end;
      end;
      Start := Check;
      repeat
        Inc(Start);
      until (ObjectNum.IndexOf(Start) >= 0) or (Start > Max);
      if Start > Max then Check := Max;
    until Check = Max;
  end;

  XRefStream := DeflateStr(XRefStream);

  TrailerDict.Add('Type', TrailerDict.Owner.NewName('XRef'));
  TrailerDict.Add('Filter', TrailerDict.Owner.NewName('FlateDecode'));
  TrailerDict.Add('Index', TrailerDict.Owner.Decode('[ ' + Index + ']'));
  TrailerDict.Add('W', TrailerDict.Owner.Decode('[ 1 ' + QPLIntToStr(PosWidth) + ' 2 ]'));
  TrailerDict.Add('Length', TrailerDict.Owner.NewNumeric(Length(XRefStream)));
  if (PreviousXRefPos > 0) then
  begin
    TrailerDict.Add('Prev', TrailerDict.Owner.NewNumeric(PreviousXRefPos));
  end;

  Stream := TPDFStream.CreateFull(TrailerDict.Owner, XRefStream, TrailerDict);
  AddObject(TrailerObjNum, 0, Stream.Output);
  Stream.Free;

  Buffer := 'startxref'#10 + QPLInt64ToStr(XRefPos) + #10'%%EOF'#10;
  FStream.Write(Buffer[1], Length(Buffer));
end;

procedure TSmartPDFWriter.Append;
begin
  FStream.Seek(FStream.Size, soBeginning);
end;

constructor TSmartPDFWriter.Create(OutputStream: TStream);
begin
  FStream := OutputStream;
  ObjectGen := TQuickPDFIntegerList.Create;
  ObjectNum := TQuickPDFIntegerList.Create;
  ObjectLength := TQuickPDFIntegerList.Create;
end;

destructor TSmartPDFWriter.Destroy;
begin
  ObjectGen.Free;
  ObjectNum.Free;
  ObjectLength.Free;
  inherited;
end;

function TSmartPDFWriter.GetObjectLength(ObjectNumber: Integer): Integer;
var
  I: Integer;
begin
  I := ObjectNum.IndexOf(ObjectNumber);
  if I >= 0 then
  begin
    Result := ObjectLength[I];
  end else
    Result := 0;
end;

function TSmartPDFWriter.GetObjectPosition(ObjectNumber: Integer): Int64;
var
  I: Integer;
begin
  I := ObjectNum.IndexOf(ObjectNumber);
  if I >= 0 then
  begin
    Result := ObjectPos[I];
  end else
    Result := 0;
end;

procedure TSmartPDFWriter.New(const Version: AnsiString = '1.4');
var
  Buffer: AnsiString;
begin
  Buffer := '%PDF-' + Version + #10;
  FStream.Write(Buffer[1], Length(Buffer));
  Buffer := '%‚„œ”'#10;
  FStream.Write(Buffer[1], Length(Buffer));
end;

procedure TSmartPDFWriter.Reset;
begin
  SetLength(ObjectPos, 0);
  ObjectNum.Free;
  ObjectNum := TQuickPDFIntegerList.Create;
  ObjectGen.Free;
  ObjectGen := TQuickPDFIntegerList.Create;
end;

procedure TSmartPDFWriter.Serialize(StoreStream: TStream);
var
  I64: Int64;
  I32: Integer;
  X: Integer;
  C: Integer;
begin
  I64 := FStream.Position;
  StoreStream.Write(I64, 8);
  C := ObjectNum.Count;
  StoreStream.Write(C, 4);
  for X := 0 to C - 1 do
  begin
    I32 := ObjectPos[X];
    StoreStream.Write(I32, 4);
    I32 := ObjectNum[X];
    StoreStream.Write(I32, 4);
    I32 := ObjectGen[X];
    StoreStream.Write(I32, 4);
  end;
end;

procedure TSmartPDFWriter.Unserialize(StoreStream: TStream);
var
  I64: Int64;
  I32: Integer;
  X: Integer;
  C: Integer;
begin
  StoreStream.Read(I64, 8);
  FStream.Seek(I64, soBeginning);
  StoreStream.Read(C, 4);
  SetLength(ObjectPos, C);
  ObjectNum.Clear;
  ObjectGen.Clear;
  ObjectNum.Capacity := C;
  ObjectGen.Capacity := C;  
  for X := 0 to C - 1 do
  begin
    StoreStream.Read(I32, 4);
    ObjectPos[X] := I32;
    StoreStream.Read(I32, 4);
    ObjectNum.Add(I32);
    StoreStream.Read(I32, 4);
    ObjectGen.Add(I32);
  end;
end;

{ TSmartPDFDocument }

procedure TSmartPDFDocument.AddFields(SourceFields, SourceCO: TPDFArray;
  Offset: Integer; NeedAppearances: Boolean);
var
  X: Integer;
  Obj: TPDFObject;
  Fields: TPDFArray;
  CO: TPDFArray;
  F: TPDFIndRef;
begin
  Fields := GetFieldsArray;
  if Assigned(Fields) and Assigned(SourceFields) then
  begin
    for X := 0 to SourceFields.Count - 1 do
    begin
      Obj := SourceFields.Item[X];
      if Obj is TPDFIndRef then
      begin
        F := TPDFIndRef(Obj);
        Fields.Add(FLocalStructure.NewIndirectRef(F.ObjNum + Offset, F.GenNum));
      end;
    end;

    CO := GetCOArray;
    if Assigned(CO) and Assigned(SourceCO) then
    begin
      for X := 0 to SourceCO.Count - 1 do
      begin
        Obj := SourceCO.Item[X];
        if Obj is TPDFIndRef then
        begin
          F := TPDFIndRef(Obj);
          CO.Add(FLocalStructure.NewIndirectRef(F.ObjNum + Offset, F.GenNum));
        end;
      end;
    end;

    if NeedAppearances then
      FAcroFormDict.Add('NeedAppearances', FLocalStructure.NewBoolean(True));

    ChangeObject(FAcroFormRef.ObjNum, FAcroFormDict);
  end;
end;

procedure TSmartPDFDocument.AddPages(ObjNum, GenNum, Count: Integer);
begin
  PageKids.Add(FLocalStructure.NewIndirectRef(ObjNum, GenNum));
  FPagesDict.Add('Count', FLocalStructure.NewNumeric(PageCount + Count));
  ChangeObject(PagesRef.ObjNum, PagesDict);
end;

procedure TSmartPDFDocument.ChangeObject(ObjNum: Integer; NewObject: TPDFObject);
var
  I: Integer;
begin
  I := FNewObjNums.IndexOf(ObjNum);
  if I < 0 then
  begin
    SetLength(FNewObjects, FNewObjNums.Count + 1);
    FNewObjects[FNewObjNums.Count] := NewObject;
    FNewObjNums.Add(ObjNum);
  end else
    FNewObjects[I] := NewObject;
end;

constructor TSmartPDFDocument.Create(Reader: TSmartPDFReader);
begin
  FRootDict := nil;
  FRootRef := nil;
  FInfoDict := nil;
  FInfoRef := nil;
  FPagesDict := nil;
  FPagesRef := nil;
  FAcroFormDict := nil;
  FAcroFormRef := nil;
  FReader := Reader;
  FNewObjNums := TQuickPDFIntegerList.Create;
  FLocalStructure := TPDFStructure.Create;
  FFontCol := TPDFFontCollection.Create;
  FFontCol.OnFindObject := DirectFindObject;
  FFontCol.InstallFonts := True;
  FUserModDate := False;

  ExtractList := TQuickPDFIntegerList2.Create;
  GetRootInfoPages;
  GetFormFields;
end;

procedure TSmartPDFDocument.PartialDecrypt;
var
  ObjNum: Integer;
  Obj: TPDFObject;
begin
  for ObjNum := 1 to FReader.ObjectCount do
  begin
    Obj := FReader.GetObject(ObjNum);
    if (Assigned(Obj)) then
    begin
      FSmartInfo.DecryptObject(Obj, ObjNum, FReader.GetGenNum(ObjNum));
      ChangeObject(ObjNum, Obj);
    end;
  end;
  FReader.TrailerDict.DeleteEntryByKeyName('Encrypt');
end;

destructor TSmartPDFDocument.Destroy;
var
  X: Integer;
begin
  FNewObjNums.Free;
  FLocalStructure.Free;
  ExtractList.Free;
  FFontCol.Free;
  for X := 0 to Length(FImageListArray) - 1 do
    FImageListArray[X].Free;
  if Assigned(FAcroForm) then
    FAcroForm.Free;
  inherited;
end;

procedure TSmartPDFDocument.ExtractObjects(PageList: TQuickPDFPageList; IgnoreOutlines: Boolean);
var
  PX: Integer;
  Obj: TPDFObject;
  PageRef: TPDFIndRef;
  PageDict: TPDFDictionary;
  Kids: TPDFArray;
  PageRefList: TPDFArray;
  PageRefObj: TQuickPDFStringList;
  EncryptObjNum: Integer;

  procedure Add(ObjNum: Integer);
  var
    O: TPDFObject;
    X: Integer;
    TempStruct: TPDFStructure;
    Recurse: Boolean;
  begin
    if (not ExtractList.Contains(ObjNum)) then
    begin
      ExtractList.Add(ObjNum);
      TempStruct := TPDFStructure.Create;
      try
        O := GetObject(ObjNum, TempStruct);
        if Assigned(O) and (O.Owner <> TempStruct) then
          TempStruct.Decode(O.Output);
        Recurse := True;
        if (O is TPDFDictionary) and (TPDFDictionary(O).DictType = 'Page') then
        begin
          Recurse := PageRefObj.IndexOf(QPLIntToStr(ObjNum)) >= 0;
        end;

        if Recurse then
        for X := 0 to TempStruct.ObjectCount - 1 do
        begin
          O := TempStruct.GetObject(X);
          if O is TPDFIndRef then
            Add(TPDFIndRef(O).ObjNum);
        end;
      finally
        TempStruct.Free;
      end;
    end;
  end;

begin
  Kids := nil;
  PageRefList := FLocalStructure.NewArray;
  PageRefObj := TQuickPDFStringList.Create;
  try
    ChangeObject(FRootRef.ObjNum, FRootDict);

    if (SmartInfo.Crypt.Encrypted = spEncrypted) then
    begin
      EncryptObjNum := GetEncryptionDictObjNum;
      if (EncryptObjNum > 0) then
      begin
        ExtractList.Add(EncryptObjNum);
      end;
    end;

    FPagesDict.Add('Count', FLocalStructure.NewNumeric(Length(PageList)));
    ChangeObject(FPagesRef.ObjNum, FPagesDict);
    Obj := FPagesDict.FindValueByKeyName('Kids');
    if Obj is TPDFIndRef then
      Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFArray then
      Kids := TPDFArray(Obj);
    if Assigned(Kids) then
    begin
      PageRefList.ReserveItems(Length(PageList));
      for PX := 0 to Length(PageList) - 1 do
      begin
        if Assigned(FOnProgress) then
          FOnProgress(PX * 33 div Length(PageList));
        if (PX > 0) and (PageList[PX] = (PageList[PX - 1] + 1)) then
          PageRef := GetNextPageRef(PageList[PX], TPDFIndRef(PageRefList.Item[PageRefList.Count - 1]))
        else
          PageRef := FindPageRef(PageList[PX]);
        PageRefList.Add(PageRef);
        PageRefObj.Add(QPLIntToStr(PageRef.ObjNum));
      end;
      PageRefObj.Sort;
      if Assigned(FOnProgress) then
        FOnProgress(33);
      for PX := 0 to Length(PageList) - 1 do
      begin
        if Assigned(FOnProgress) then
          FOnProgress(PX * 33 div Length(PageList) + 33);
        PageRef := TPDFIndRef(PageRefList.Item[PX]);
        Obj := FReader.GetObject(PageRef.ObjNum);
        if Obj is TPDFDictionary then
        begin
          PageDict := TPDFDictionary(Obj);
          if Assigned(PageDict) then
          begin
            PageDict.Add('Parent', FPagesRef);
          end;
          ChangeObject(PageRef.ObjNum, PageDict);
        end;
      end;
      FPagesDict.Add('Kids', FLocalStructure.Decode(PageRefList.Output));
      if (IgnoreOutlines) then
      begin
        FRootDict.PurgeKey('Outlines');
        ChangeObject(FRootRef.ObjNum, FRootDict);
      end;
    end;
    Add(FRootRef.ObjNum);
    if Assigned(FOnProgress) then
      FOnProgress(88);
    if Assigned(FInfoRef) then
      Add(FInfoRef.ObjNum);
    if Assigned(FOnProgress) then
      FOnProgress(100);
  finally
    PageRefObj.Free;
  end;
end;

function TSmartPDFDocument.GetExtractObjectNumber(
  ExtractIndex: Integer): Integer;
begin
  Result := ExtractList.GetValue(ExtractIndex - 1);
end;

function TSmartPDFDocument.EmbedFileStreams(
  const RootPath: WideString): Boolean;
var
  Obj: TPDFObject;
  ObjNum: Integer;
  TempStructure: TPDFStructure;
  StreamDict: TPDFDictionary;
  NewStream: TPDFStream;
  FEntry: TPDFObject;
  FS: TQuickPDFWideFileStream;
  FileName: WideString;
  SlashPos: Integer;
  Buffer: AnsiString;
begin
  Result := False;
  TempStructure := TPDFStructure.Create;
  try
    for ObjNum := 1 to ObjectCount do
    begin
      Obj := GetObject(ObjNum, TempStructure);
      if (Obj is TPDFStream) then
      begin
        StreamDict := TPDFStream(Obj).Dictionary;
        if (Assigned(StreamDict)) then
        begin
          Obj := StreamDict.FindValueByKeyName('F');
          if (Obj is TPDFIndRef) then
          begin
            Obj := GetObject(TPDFIndRef(Obj).ObjNum);
          end;
          if (Assigned(Obj)) then
          begin
            Result := True;
            FEntry := TPDFObject(Obj);

            FileName := '';
            if (FEntry is TPDFString) then
            begin
              FileName := TPDFString(FEntry).AsTextString;
            end;

            SlashPos := Pos('/', FileName);
            while (SlashPos > 0) do
            begin
              FileName[SlashPos] := '\';
              SlashPos := Pos('/', FileName);
            end;

            if (Copy(RootPath, Length(RootPath), 1) <> '\') then
            begin
              FileName := '\' + FileName;
            end;

            if (QPLFileExists(RootPath + FileName)) then
            begin
              try
                FS := TQuickPDFWideFileStream.Create(RootPath + FileName,
                  fmOpenRead or fmShareDenyWrite);
              except
                FS := nil;
              end;
              if (Assigned(FS)) then
              begin
                try
                  SetLength(Buffer, FS.Size);
                  if (FS.Size > 0) then
                  begin
                    FS.Read(Buffer[1], Length(Buffer));

                    Obj := FLocalStructure.Decode(StreamDict.Output);
                    if (Obj is TPDFDictionary) then
                    begin
                      StreamDict := TPDFDictionary(Obj);
                      StreamDict.DeleteEntryByKeyName('F');
                      Obj := StreamDict.FindValueByKeyName('FFilter');
                      if (Obj is TPDFIndRef) then
                      begin
                        Obj := GetObject(TPDFIndRef(Obj).ObjNum);
                      end;
                      if (Assigned(Obj)) then
                      begin
                        StreamDict.Add('Filter', Obj);
                        StreamDict.DeleteEntryByKeyName('FFilter');
                      end;
                      Obj := StreamDict.FindValueByKeyName('Length');
                      if (Obj is TPDFIndRef) then
                      begin
                        Obj := GetObject(TPDFIndRef(Obj).ObjNum);
                      end;
                      if (Obj is TPDFNumeric) then
                      begin
                        TPDFNumeric(Obj).SetTo(Length(Buffer));
                      end;

                      NewStream := FLocalStructure.NewStreamWithDict(Buffer,
                        StreamDict);

                      ChangeObject(ObjNum, NewStream);
                    end;
                  end;
                finally
                  FS.Free;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    TempStructure.Free;
  end;
end;

function TSmartPDFDocument.ExtractObjectCount: Integer;
begin
  Result := ExtractList.Count;
end;

function TSmartPDFDocument.GetNextPageRef(Page: Integer;
  PrevRef: TPDFIndRef): TPDFIndRef;
var
  Obj: TPDFObject;
  I: Integer;
  Kids: TPDFArray;
begin
  Result := nil;
  if Assigned(PrevRef) then
  begin
    Obj := GetObject(PrevRef.ObjNum);
    if Obj is TPDFDictionary then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName('Parent');
      if Obj is TPDFIndRef then
      begin
        Obj := GetObject(TPDFIndRef(Obj).ObjNum);
        if Obj is TPDFDictionary then
        begin
          Obj := TPDFDictionary(Obj).FindValueByKeyName('Kids');
          if Obj is TPDFIndRef then
            Obj := GetObject(TPDFIndRef(Obj).ObjNum);
          if Obj is TPDFArray then
          begin
            Kids := TPDFArray(Obj);
            I := Kids.ItemIndexMatch(PrevRef);
            if I < (Kids.Count - 1) then
            begin
              Obj := Kids.Item[I + 1];
              if Obj is TPDFIndRef then
              begin
                Result := TPDFIndRef(Obj);
                if not IsPage(TPDFIndRef(Obj)) then
                  Result := nil;
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  if not Assigned(Result) then
    Result := FindPageRef(Page);
end;

function TSmartPDFDocument.FindPageRef(Page: Integer): TPDFIndRef;
var
  PC: Integer;
  Count: Integer;
  ThisDict: TPDFDictionary;
  Obj: TPDFObject;
  KidIndex: Integer;
  KidsArray: TPDFArray;
  LastDict: TPDFDictionary;
  TempStruct: TPDFStructure;
  IsPage: Boolean;

  function GetPageCount(Ref: TPDFIndRef): Integer;
  var
    O: TPDFObject;
    D: TPDFDictionary;
  begin
    Result := 0;
    IsPage := False;
    O := GetObject(Ref.ObjNum, TempStruct);
    if O is TPDFDictionary then
    begin
      D := TPDFDictionary(O);
      if D.DictType = 'Pages' then
      begin
        O := D.FindValueByKeyName('Count');
        if O is TPDFIndRef then O := GetObject(TPDFIndRef(O).ObjNum, TempStruct);
        if O is TPDFNumeric then
          Result := TPDFNumeric(O).AsInteger;
      end
      else if (D.DictType = 'Page') then
      begin
        Result := 1;
        IsPage := True;
      end  // The PDF must be missing /Type entry so lets try to determine the type.
      else if (Assigned(D.FindValueByKeyName('Count'))) then
      begin
        O := D.FindValueByKeyName('Count');
        if O is TPDFIndRef then O := GetObject(TPDFIndRef(O).ObjNum, TempStruct);
        if O is TPDFNumeric then
          Result := TPDFNumeric(O).AsInteger;
      end
      else if Assigned(D.FindValueByKeyName('Contents')) then
      begin
        Result := 1;
        IsPage := True;
      end

    end;
  end;

begin
  TempStruct := TPDFStructure.Create;
  try
    Count := 0;
    Result := nil;
    KidIndex := -1;
    KidsArray := nil;
    FLastPageNode := FPagesDict;
    FLastPageNodeRef := FPagesRef;
    ThisDict := FPagesDict;

    if (Assigned(ThisDict)) then
    begin
      Obj := ThisDict.FindValueByKeyName('Kids');
      if (not Assigned(Obj)) then
      begin
        Obj := ThisDict.FindValueByKeyName('Contents');
        if (Assigned(Obj)) then
        begin
          Result := FPagesRef;
          FPagesDict := FLocalStructure.NewDictionary;
          FPagesDict.Add('Type', FLocalStructure.NewName('Pages'));
          FPagesDict.Add('Kids', FLocalStructure.NewArray([FPagesRef]));
          FPagesDict.Add('count', FLocalStructure.NewNumeric(1));
          FPagesRef := NewObject(Obj);
          FRootDict.Add('Pages', FAcroFormRef);
          ChangeObject(FRootRef.ObjNum, FRootDict);
          ThisDict := nil;
        end;
      end;
    end;

    while Assigned(ThisDict) do
    begin
      Obj := ThisDict.FindValueByKeyName('Kids');
      if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum, TempStruct);
      if Obj is TPDFArray then
      begin
        KidsArray := TPDFArray(Obj);
        KidIndex := 0;
        PC := 0;
        while (KidIndex < KidsArray.Count) and (Count < Page) do
        begin
          Obj := KidsArray.Item[KidIndex];
          if Obj is TPDFIndRef then
            PC := GetPageCount(TPDFIndRef(Obj))
          else
            PC := 0;
          Count := Count + PC;
          Inc(KidIndex);
        end;
        if (Count >= Page) and (KidIndex > 0) then
        begin
          if (PC = 1) and IsPage then
          begin
            ThisDict := nil;
          end else
          begin
            Count := Count - PC;
            Obj := KidsArray.Item[KidIndex - 1];
            if Obj is TPDFIndRef then
            begin
              if (Assigned(FLastPageNodeRef)) then
              begin
                if ((TPDFIndRef(Obj).ObjNum = FLastPageNodeRef.ObjNum) and
                  (TPDFIndRef(Obj).GenNum = FLastPageNodeRef.GenNum)) then
                begin
                  Obj := nil;
                end;
              end;
              if (Assigned(Obj)) then
              begin
                FLastPageNodeRef := TPDFIndRef(Obj);
                Obj := GetObject(TPDFIndRef(Obj).ObjNum, TempStruct);
              end;
            end;
            if Obj is TPDFDictionary then
            begin
              ThisDict := TPDFDictionary(Obj);
              FLastPageNode := ThisDict;
            end else
              ThisDict := nil;
          end;
        end else
          ThisDict := nil;
      end;
    end;
    if Assigned(KidsArray) and (Count = Page) and (KidIndex > 0) then
    begin
      Obj := KidsArray.Item[KidIndex - 1];
      if Obj is TPDFIndRef then
      begin
        Result := TPDFIndRef(Obj);
        Obj := GetObject(TPDFIndRef(Obj).ObjNum, TempStruct);
        if (Obj is TPDFDictionary) then
        begin
          LastDict := TPDFDictionary(Obj);
          if (LastDict.DictType = 'Pages') or (Assigned(LastDict.FindValueByKeyName('Contents'))) then
          begin
            Obj := LastDict.FindValueByKeyName('Kids');
            if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum, TempStruct);
            if Obj is TPDFArray then
            begin
              Obj := TPDFArray(Obj).Item[0];
              if Obj is TPDFIndRef then Result := TPDFIndRef(Obj);
            end;
          end;
        end;
      end;
    end;
    if Assigned(Result) then
      Result := FLocalStructure.NewIndirectRef(Result.ObjNum, Result.GenNum);
  finally
    TempStruct.Free;
  end;
end;

procedure TSmartPDFDocument.GetPageInfo(var PageInfoList: TPDFPageInfoList);
var
  ThisDict: TPDFDictionary;
  Obj: TPDFObject;
  TempStruct: TPDFStructure;
  CurrentPage: Integer;

  procedure ProcessBranch(Dict: TPDFDictionary);
  var
    KidIndex: Integer;
    KidsArray: TPDFArray;
    CurrentIndRef: TPDFIndRef;
    PageRect: TPDFRectangle;
  begin
    Obj := Dict.FindValueByKeyName('Kids');
    if (Obj is TPDFIndRef) then
    begin
      Obj := GetObject(TPDFIndRef(Obj).ObjNum, TempStruct);
    end;
    if Obj is TPDFArray then
    begin
      KidsArray := TPDFArray(Obj);
      for KidIndex := 0 to KidsArray.Count - 1 do
      begin
        Obj := KidsArray.Item[KidIndex];
        if (Obj is TPDFIndRef) then
        begin
          CurrentIndRef := TPDFIndRef(Obj);
          Obj := GetObject(CurrentIndRef.ObjNum, TempStruct);
          if (Obj is TPDFDictionary) then
          begin
            ThisDict := TPDFDictionary(Obj);
            if (ThisDict.DictType) = 'Pages' then
            begin
              ProcessBranch(ThisDict);
            end else
            begin
              Obj := GetInheritedValue(ThisDict, 'MediaBox');
              if (Obj is TPDFArray) then
              begin
                PageRect := TPDFRectangle.Create(TPDFArray(Obj));
                try
                  PageInfoList[CurrentPage].Width := PageRect.Width;
                  PageInfoList[CurrentPage].Height := PageRect.Height;
                finally
                  PageRect.Free;
                end;
                Obj := GetInheritedValue(ThisDict, 'Rotate');
                if (Obj is TPDFNumeric) then
                begin
                  PageInfoList[CurrentPage].Rotate := TPDFNumeric(Obj).AsInteger;
                end;
              end;
              Inc(CurrentPage);
            end;
          end;
        end;
      end;
    end;
  end;

begin
  SetLength(PageInfoList, PageCount);
  TempStruct := TPDFStructure.Create;
  try
    CurrentPage := 0;
    ProcessBranch(FPagesDict);
  finally
    TempStruct.Free;
  end;
end;

function TSmartPDFDocument.FindPageDict(Page: Integer): TPDFDictionary;
var
  Obj: TPDFObject;
  PageRef: TPDFIndRef;
begin
  Result := nil;
  PageRef := FindPageRef(Page);
  if Assigned(PageRef) then
  begin
    Obj := GetObject(PageRef.ObjNum);
    if Obj is TPDFDictionary then Result := TPDFDictionary(Obj);
  end;
end;

function TSmartPDFDocument.GetCOArray: TPDFArray;
var
  Obj: TPDFObject;
begin
  Result := nil;
  if Assigned(FAcroFormDict) then
  begin
    Obj := FAcroFormDict.FindValueByKeyName('CO');
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      FAcroFormDict.Add('CO', Obj);
    end;
    if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFArray then Result := TPDFArray(Obj);
  end;
end;

function TSmartPDFDocument.GetFieldsArray: TPDFArray;
var
  Obj: TPDFObject;
begin
  Result := nil;
  if Assigned(FAcroFormDict) then
  begin
    Obj := FAcroFormDict.FindValueByKeyName('Fields');
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      FAcroFormDict.Add('Fields', Obj);
    end;
    if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFArray then Result := TPDFArray(Obj);
  end;
end;

procedure TSmartPDFDocument.GetFormFields;
var
  Obj: TPDFObject;
begin
  if Assigned(FRootDict) then
  begin
    Obj := FRootDict.FindValueByKeyName('AcroForm');
    if (Obj is TPDFDictionary) then
    begin
      // Put the AcroForm dictionary into a separate object
      FAcroFormRef := NewObject(Obj);
      FRootDict.Add('AcroForm', FAcroFormRef);
      ChangeObject(FRootRef.ObjNum, FRootDict);
    end else
    if Obj is TPDFIndRef then
    begin
      FAcroFormRef := TPDFIndRef(Obj);
      Obj := GetObject(TPDFIndRef(Obj).ObjNum);
    end;
    if Obj is TPDFDictionary then
    begin
      FAcroFormDict := TPDFDictionary(Obj);
      FAcroForm := TPDFForm.Create;
      FAcroForm.OnFindObject := FindObject;
      FAcroForm.Load(FAcroFormDict);
    end;
  end;
end;

function TSmartPDFDocument.GetGenNum(ObjectNumber: Integer): Integer;
begin
  Result := FReader.GetGenNum(ObjectNumber);
end;

function TSmartPDFDocument.GetInformation(const Key: AnsiString): WideString;
var
  Obj: TPDFObject;
begin
  Result := '';
  if Assigned(FInfoDict) then
  begin
    Obj := FInfoDict.FindValueByKeyName(Key);
    if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFString then
    begin
      if (SmartInfo.Crypt.Encrypted = spEncrypted) and (not FReader.IsCompact(FInfoRef.ObjNum)) then
      begin
        SmartInfo.Crypt.DecryptObject(SmartInfo.Crypt.MakeKey(FInfoRef.ObjNum, FInfoRef.GenNum), Obj);
        Result := TPDFString(Obj).AsTextString;
        SmartInfo.Crypt.EncryptObject(SmartInfo.Crypt.MakeKey(FInfoRef.ObjNum, FInfoRef.GenNum), Obj);
      end else
        Result := TPDFString(Obj).AsTextString;
    end;
    if Obj is TPDFStream then
    begin
      if (SmartInfo.Crypt.Encrypted = spEncrypted) and (not FReader.IsCompact(FInfoRef.ObjNum)) then
      begin
        SmartInfo.Crypt.DecryptObject(SmartInfo.Crypt.MakeKey(FInfoRef.ObjNum, FInfoRef.GenNum), Obj);
        Result := TPDFStream(Obj).GetDecodedTextStream;
        SmartInfo.Crypt.EncryptObject(SmartInfo.Crypt.MakeKey(FInfoRef.ObjNum, FInfoRef.GenNum), Obj);
      end else
        Result := TPDFStream(Obj).GetDecodedTextStream;
    end;
  end;
end;

function TSmartPDFDocument.GetObject(ObjectNumber: Integer;
  Structure: TPDFStructure): TPDFObject;
var
  X: Integer;
begin
  X := FNewObjNums.IndexOf(ObjectNumber);
  if X >= 0 then
  begin
    if (Assigned(Structure)) then
    begin
      if (FNewObjects[X] is TPDFStream) then
      begin
        Result := FNewObjects[X];
      end else
      begin
        Result := Structure.Decode(FNewObjects[X].Output);
      end;
    end else
    begin
      Result := FNewObjects[X];
    end;
  end else
  begin
    if (Assigned(Structure)) then
    begin
      Result := FReader.GetObject(ObjectNumber, Structure);
    end else
    begin
      Result := FReader.GetCachedObject(ObjectNumber);
    end;
  end;
end;

procedure TSmartPDFDocument.GetRootInfoPages;
var
  Obj: TPDFObject;
begin
  if Assigned(FReader.TrailerDict) then
  begin
    FRootRef := FReader.FindDictRef('Root');
    FRootDict := FReader.FindDict('Root');
    FInfoRef := FReader.FindDictRef('Info');
    FInfoDict := FReader.FindDict('Info');
    if Assigned(FRootDict) then
    begin
      // COMPLIANCE CHECK //
      //if FRootDict.DictType = 'Catalog' then
      begin
        Obj := FRootDict.FindValueByKeyName('Pages');
        if Obj is TPDFIndRef then
        begin
          FPagesRef := TPDFIndRef(Obj);
          Obj := GetObject(TPDFIndRef(Obj).ObjNum);
          if Obj is TPDFDictionary then
            FPagesDict := TPDFDictionary(Obj);
        end;
      end;
    end;
  end;
end;

function TSmartPDFDocument.HasCatalogEntry(
  const EntryName: AnsiString): Boolean;
var
  Obj: TPDFObject;
begin
  Result := False;
  if (Assigned(FRootDict)) then
  begin
    Obj := FRootDict.FindValueByKeyName(EntryName);
    Result := Assigned(Obj);
  end;
end;

function TSmartPDFDocument.HasFields: Boolean;
begin
  Result := Assigned(FAcroFormDict);
end;

function TSmartPDFDocument.HasImageList(ImageList: TPDFImageList): Boolean;
var
  X: Integer;
begin
  Result := False;
  X := 0;
  while (not Result) and (X < Length(FImageListArray)) do
  begin
    if (FImageListArray[X] = ImageList) then
    begin
      Result := True;
    end else
    begin
      Inc(X);
    end;
  end;
end;

procedure TSmartPDFDocument.HidePage(PageRef: TPDFIndRef);
var
  Obj: TPDFObject;
  PageDict: TPDFDictionary;
  PageNode: TPDFDictionary;
  PageNodeRef: TPDFIndRef;
  ChangeObj: TPDFObject;
  ChangeRef: TPDFIndRef;
begin
  PageNode := nil;
  PageNodeRef := nil;
  PageDict := PageDictFromRef(PageRef);
  Obj := PageDict.FindValueByKeyName('Parent');
  if Obj is TPDFIndRef then
  begin
    PageNodeRef := TPDFIndRef(Obj);
    Obj := GetObject(PageNodeRef.ObjNum);
    if Obj is TPDFDictionary then PageNode := TPDFDictionary(Obj);
  end;

  if Assigned(PageNode) and Assigned(PageNodeRef) then
  begin
    ChangeRef := PageNodeRef;
    ChangeObj := PageNode;
    Obj := PageNode.FindValueByKeyName('Kids');
    if Obj is TPDFIndRef then
    begin
      ChangeRef := TPDFIndRef(Obj);
      Obj := GetObject(ChangeRef.ObjNum);
      ChangeObj := Obj;
    end;
    if Obj is TPDFArray then
    begin
      TPDFArray(Obj).DeleteObj(PageRef, True);
      ChangeObject(ChangeRef.ObjNum, ChangeObj);
    end;
    AdjustPageCount(PageNodeRef, -1);
  end;
end;

function TSmartPDFDocument.NewObject(Obj: TPDFObject): TPDFIndRef;
begin
  Result := FLocalStructure.NewIndirectRef(ObjectCount + 1, 0);
  SetLength(FNewObjects, FNewObjNums.Count + 1);
  FNewObjects[FNewObjNums.Count] := Obj;
  FNewObjNums.Add(Result.ObjNum);
end;

procedure TSmartPDFDocument.NewPages(PageCount: Integer);
var
  PageDict: TPDFDictionary;
  PageRef: TPDFIndRef;
  PageKidsArray: TPDFArray;
  P: Integer;
begin
  PageKidsArray := PageKids;
  if Assigned(PageKidsArray) then
  begin
    for P := 1 to PageCount do
    begin
      PageDict := FLocalStructure.NewDictionary;
      PageDict.Add('Type', FLocalStructure.NewCommonName('Page'));
      PageDict.Add('Parent', FPagesRef);            
      PageDict.Add('MediaBox', FLocalStructure.NewIntArray([0, 0, 612, 792]));
      PageDict.Add('Resources', FLocalStructure.NewDictionary);      
      PageRef := NewObject(PageDict);
      PageKidsArray.Add(PageRef);
    end;
    FPagesDict.Add('Count', FLocalStructure.NewNumeric(Self.PageCount + PageCount));
    ChangeObject(FPagesRef.ObjNum, FPagesDict);
  end;
end;

procedure TSmartPDFDocument.NewSigImageObj(Sender: TObject; var ObjNum,
  GenNum: Integer; Obj: TPDFObject);
var
  IndRef: TPDFIndRef;
begin
  IndRef := NewObject(Obj);
  ObjNum := IndRef.ObjNum;
  GenNum := IndRef.GenNum;
end;

function TSmartPDFDocument.ObjectCount: Integer;
var
  X: Integer;
  Max: Integer;
begin
  if FNewObjNums.Count > 0 then
  begin
    Max := 0;
    for X := 0 to FNewObjNums.Count - 1 do
      if FNewObjNums[X] > Max then Max := FNewObjNums[X];
  end else
    Max := 0;
  if Max > FReader.ObjectCount then
    Result := Max
  else
    Result := FReader.ObjectCount;
end;

function TSmartPDFDocument.PageCount: Integer;
var
  Obj: TPDFObject;
begin
  Result := 1;
  if Assigned(FPagesDict) then
  begin
    Obj := FPagesDict.FindValueByKeyName('Count');
    if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFNumeric then
      Result := TPDFNumeric(Obj).AsInteger;
  end;
end;

function TSmartPDFDocument.PageKids: TPDFArray;
var
  ChangeObj: TPDFObject;
  ChangeRef: TPDFIndRef;
  Obj: TPDFObject;
begin
  Result := nil;
  if Assigned(FPagesDict) then
  begin
    ChangeObj := FPagesDict;
    ChangeRef := FPagesRef;
    Obj := FPagesDict.FindValueByKeyName('Kids');
    if Obj is TPDFIndRef then
    begin
      ChangeRef := TPDFIndRef(Obj);
      Obj := GetObject(TPDFIndRef(Obj).ObjNum);
      ChangeObj := Obj;
    end;
    if Obj is TPDFArray then Result := TPDFArray(Obj);
    ChangeObject(ChangeRef.ObjNum, ChangeObj);    
  end;
end;

function TSmartPDFDocument.SearchForFilter(
  const FilterName: AnsiString; StopOnFirst: Boolean): Boolean;
var
  Obj: TPDFObject;
  ObjectNumber: Integer;
  TempStructure: TPDFStructure;
  Continue: Boolean;
  FilterArray: TPDFArray;
  ArrayIndex: Integer;
begin
  Result := False;
  TempStructure := TPDFStructure.Create;
  try
    ObjectNumber := 0;
    Continue := True;
    while ((ObjectNumber < ObjectCount) and Continue) do
    begin
      Inc(ObjectNumber);
      Obj := GetObject(ObjectNumber, TempStructure);
      if (Obj is TPDFStream) then
      begin
        Obj := TPDFStream(Obj).Dictionary.FindValueByKeyName('Filter');
        if (Obj is TPDFIndRef) then
        begin
          Obj := FindObject(TPDFIndRef(Obj));
        end;
        if (Obj is TPDFName) then
        begin
          if (TPDFName(Obj).Name = FilterName) then
          begin
            Result := True;
            if (StopOnFirst) then
            begin
              Continue := False;
            end;
          end;
        end else
        if (Obj is TPDFArray) then
        begin
          FilterArray := TPDFArray(Obj);
          for ArrayIndex := 0 to FilterArray.Count - 1 do
          begin
            Obj := FilterArray.Item[ArrayIndex];
            if (Obj is TPDFIndRef) then
            begin
              Obj := FindObject(TPDFIndRef(Obj));
            end;
            if (Obj is TPDFName) then
            begin
              if (TPDFName(Obj).Name = FilterName) then
              begin
                Result := True;
                if (StopOnFirst) then
                begin
                  Continue := False;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    TempStructure.Free;
  end;
end;

procedure TSmartPDFDocument.SetFileID;
var
  S1: TPDFString;
  S2: TPDFString;
begin
  S1 := FReader.FStructure.NewString(MD5DigestToString(MD5String(QPLRandomID)), smHex);
  S2 := FReader.FStructure.NewString(MD5DigestToString(MD5String(QPLRandomID)), smHex);
  FReader.TrailerDict.Add('ID', FReader.FStructure.NewArray([S1, S2]));
end;

procedure TSmartPDFDocument.SetInformation(const Key: AnsiString; const NewValue: WideString);
var
  Obj: TPDFObject;
begin
  Obj := FLocalStructure.NewTextString(NewValue);
  if (SmartInfo.Crypt.Encrypted = spEncrypted) and (not FReader.IsCompact(FInfoRef.ObjNum)) then
    SmartInfo.Crypt.EncryptObject(SmartInfo.Crypt.MakeKey(FInfoRef.ObjNum, FInfoRef.GenNum), Obj);
  FInfoDict.Add(Key, Obj);
  ChangeObject(FInfoRef.ObjNum, FInfoDict);
end;

procedure TSmartPDFDocument.SetPagesParent(ObjNum, GenNum: Integer);
begin
  ChangeObject(FPagesRef.ObjNum, FPagesDict);
  FPagesDict.Add('Parent', FLocalStructure.NewIndirectRef(ObjNum, GenNum));
  if (FPagesDict.DictType <> 'Pages') then
  begin
    FPagesDict.Add('Type', FLocalStructure.NewName('Pages'));
  end;
end;

function TSmartPDFDocument.WriteNewObjects(Writer: TSmartPDFWriter): TPDFDictionary;
var
  X: Integer;
  Max: Integer;
begin
  Max := FReader.GetObjectCount;
  for X := 0 to Length(FNewObjects) - 1 do
  begin
    if FNewObjNums[X] > Max then Max := FNewObjNums[X];
    Writer.AddObject(FNewObjNums[X], 0, FNewObjects[X].Output);
  end;

  Result := FReader.PreviousTrailer;
  Result.Add('Size', FLocalStructure.NewNumeric(Max + 1));
  Result.Add('Prev', FLocalStructure.NewNumeric(FReader.LastXRefPos));
end;

function TSmartPDFDocument.CapturePage(PageRef: TPDFIndRef; Options: Integer): TPDFIndRef;
var
  Obj: TPDFObject;
  XStream: TPDFStream;
  XStreamRef: TPDFIndRef;
  PageDict: TPDFDictionary;
  PageBox: AnsiString;
begin
  LastPage := -1;
  Result := nil;
  PageDict := PageDictFromRef(PageRef);
  if Assigned(PageDict) then
  begin
    XStream := FLocalStructure.NewStream(DeflateStr(GetPageContents(PageRef)));
    XStreamRef := NewObject(XStream);

    XStream.Dictionary.Add('Type', FLocalStructure.NewCommonName('XObject'));
    XStream.Dictionary.Add('Subtype', FLocalStructure.NewCommonName('Form'));
    XStream.Dictionary.Add('FormType', FLocalStructure.NewNumeric(1));
    XStream.Dictionary.Add('Filter', FLocalStructure.Decode('[ /FlateDecode ]'));

    case Options of
      1: PageBox := 'CropBox';
      2: PageBox := 'BleedBox';
      3: PageBox := 'TrimBox';
      4: PageBox := 'ArtBox';
    else
      PageBox := 'MediaBox';
    end;

    repeat
      Obj := GetInheritedValue(PageDict, PageBox);
      if Obj is TPDFIndRef then
      begin
        Obj := GetObject(TPDFIndRef(Obj).ObjNum);
      end;
      if not (Obj is TPDFArray) then
      begin
        if PageBox = 'MediaBox' then
        begin
          Obj := FLocalStructure.NewDoubleArray([0, 0, 612, 792]);
        end else
        if PageBox = 'CropBox' then
        begin
          PageBox := 'MediaBox';
        end else
        begin
          PageBox := 'CropBox';
        end;
      end;
    until (Obj is TPDFArray);

    XStream.Dictionary.Add('BBox', FLocalStructure.Decode(TPDFArray(Obj).Output));

    Obj := GetInheritedValue(PageDict, 'Resources');
    if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFDictionary then
      XStream.Dictionary.Add('Resources', FLocalStructure.Decode(TPDFDictionary(Obj).Output));

    ClearContents(PageRef);
    HidePage(PageRef);

    Result := XStreamRef;
  end;
end;

procedure TSmartPDFDocument.ClearContents(PageRef: TPDFIndRef);
var
  X: Integer;
  Obj: TPDFObject;
  Contents: TPDFArray;
  PageDict: TPDFDictionary;
  Ref: TPDFIndRef;
begin
  PageDict := PageDictFromRef(PageRef);
  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('Contents');
    if Obj is TPDFIndRef then
    begin
      Ref := TPDFIndRef(Obj);
      Obj := GetObject(Ref.ObjNum);
    end else
      Ref := nil;
    if Obj is TPDFStream then
    begin
      TPDFStream(Obj).SetTo('', False);
      if Assigned(Ref) then
        ChangeObject(Ref.ObjNum, Obj);
    end;
    if Obj is TPDFArray then
    begin
      Contents := TPDFArray(Obj);
      for X := 0 to Contents.Count - 1 do
      begin
        Obj := Contents.Item[X];
        if Obj is TPDFIndRef then
        begin
          Ref := TPDFIndRef(Obj);
          Obj := GetObject(Ref.ObjNum);
        end else
          Ref := nil;
        if Obj is TPDFStream then
          TPDFStream(Obj).SetTo('', False);
        if Assigned(Ref) then ChangeObject(Ref.ObjNum, Obj);
      end;
    end;
  end;
end;

procedure TSmartPDFDocument.DrawCapturedPage(DestPage: TPDFIndRef;
  XObjectRef: TPDFIndRef; PntLeft, PntBottom, PntWidth, PntHeight: Double);
var
  Obj: TPDFObject;
  Ref: TPDFIndRef;
  PageRef: TPDFIndRef;
  PageDict: TPDFDictionary;
  NewStream: TPDFStream;
  XRef: AnsiString;
  BBox: TPDFArray;
  BBoxRect: TPDFRectangle;
begin
  NewStream := nil;
  PageRef := DestPage;
  PageDict := PageDictFromRef(PageRef);
  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('Contents');
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      PageDict.Add('Contents', Obj);
      ChangeObject(PageRef.ObjNum, PageDict);
    end;
    if Obj is TPDFArray then
    begin
      NewStream := FLocalStructure.NewStream('');
      TPDFArray(Obj).Add(NewObject(NewStream));
      ChangeObject(PageRef.ObjNum, PageDict);      
    end;
    if Obj is TPDFIndRef then
    begin
      Ref := TPDFIndRef(Obj);
      Obj := GetObject(Ref.ObjNum);
      if Obj is TPDFStream then
      begin
        Obj := FLocalStructure.NewArray([Ref]);
        PageDict.Add('Contents', Obj);
        ChangeObject(PageRef.ObjNum, PageDict);
        NewStream := FLocalStructure.NewStream('');
        TPDFArray(Obj).Add(NewObject(NewStream));
      end else
      if Obj is TPDFArray then
      begin
        NewStream := FLocalStructure.NewStream('');
        TPDFArray(Obj).Add(NewObject(NewStream));
        ChangeObject(Ref.ObjNum, Obj);
      end;
    end;
  end;
  if Assigned(NewStream) then
  begin
    XRef := UseXObject(XObjectRef, PageRef);
    BBox := XObjectBBox(XObjectRef);
    BBoxRect := TPDFRectangle.Create(BBox);
    try
      if BBoxRect.IsRectangle then
      begin
        NewStream.SetTo('q ' + QPLDoubleToStrConst(PntWidth / BBoxRect.Width, 5) +
          ' 0 0 ' + QPLDoubleToStrconst(PntHeight / BBoxRect.Height, 5) +
          ' ' + QPLDoubleToStrConst(PntLeft - BBoxRect.Left * PntWidth / BBoxRect.Width, 5) +
          ' ' + QPLDoubleToStrConst(PntBottom - BBoxRect.Bottom * PntHeight / BBoxRect.Height, 5) +
          ' cm /' + XRef + ' Do Q ', False);
      end;
    finally
      BBoxRect.Free;
    end;
  end;
end;

function TSmartPDFDocument.UseXObject(XObjectRef,
  PageRef: TPDFIndRef): AnsiString;
var
  X: Integer;
  Obj: TPDFObject;
  ChangeRef: TPDFIndRef;
  ChangeDict: TPDFDictionary;
  PageDict: TPDFDictionary;
  ResourcesDict: TPDFDictionary;
  XObjectResources: TPDFDictionary;
  XName: AnsiString;
  QuickPDFCapVal: Integer;
  QuickPDFCapMax: Integer;
begin
  Result := '';
  QuickPDFCapMax := 0;  
  if Assigned(PageRef) then
  begin
    Obj := GetObject(PageRef.ObjNum);
    if Obj is TPDFDictionary then
    begin
      PageDict := TPDFDictionary(Obj);
      ChangeRef := PageRef;      
      ChangeDict := PageDict;
      Obj := PageDict.FindValueByKeyName('Resources');
      if not Assigned(Obj) then
      begin
        Obj := FLocalStructure.NewDictionary;
        PageDict.Add('Resources', Obj);
      end;
      if Obj is TPDFIndRef then
      begin
        ChangeRef := TPDFIndRef(Obj);
        Obj := GetObject(ChangeRef.ObjNum);
        if Obj is TPDFDictionary then ChangeDict := TPDFDictionary(Obj);
      end;
      if Obj is TPDFDictionary then
      begin
        ResourcesDict := TPDFDictionary(Obj);
        Obj := ResourcesDict.FindValueByKeyName('XObject');
        if not Assigned(Obj) then
        begin
          Obj := FLocalStructure.NewDictionary;
          ResourcesDict.Add('XObject', Obj);
        end;
        if Obj is TPDFIndRef then
        begin
          ChangeRef := TPDFIndRef(Obj);
          Obj := GetObject(ChangeRef.ObjNum);
          if Obj is TPDFDictionary then ChangeDict := TPDFDictionary(Obj);
        end;
        if Obj is TPDFDictionary then
        begin
          XObjectResources := TPDFDictionary(Obj);
          for X := 0 to XObjectResources.Count - 1 do
          begin
            XName := XObjectResources.Entry[X].Key.Name;
            if QPLCopy(XName, 1, 11) = 'QuickPDFCap' then
            begin
              QuickPDFCapVal := QPLStrToIntDef(QPLCopy(XName, 12, MaxInt), 0);
              if QuickPDFCapVal > QuickPDFCapMax then
                QuickPDFCapMax := QuickPDFCapVal;
            end;
            if XObjectResources.Entry[X].Value.Output = XObjectRef.Output then
              Result := XName;
          end;
          if Result = '' then
          begin
            QuickPDFCapMax := QuickPDFCapMax + 1;
            Result := 'QuickPDFCap' + QPLIntToStr(QuickPDFCapMax);
            XObjectResources.Add(Result, XObjectRef);
            ChangeObject(ChangeRef.ObjNum, ChangeDict);
          end;
        end;
      end;
    end;
  end;
end;

function TSmartPDFDocument.PageDictFromRef(PageRef: TPDFIndRef): TPDFDictionary;
var
  Obj: TPDFObject;
begin
  Result := nil;
  if Assigned(PageRef) then
  begin
    Obj := GetObject(PageRef.ObjNum);
    if Obj is TPDFDictionary then Result := TPDFDictionary(Obj);
  end;
end;

function TSmartPDFDocument.XObjectBBox(XObjectRef: TPDFIndRef): TPDFArray;
var
  Obj: TPDFObject;
begin
  Result := nil;
  if Assigned(XObjectRef) then
  begin
    Obj := GetObject(XObjectRef.ObjNum);
    if Obj is TPDFStream then
    begin
      Obj := TPDFStream(Obj).Dictionary.FindValueByKeyName('BBox');
      if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
      if Obj is TPDFArray then
        Result := TPDFArray(Obj);
    end;
  end;
end;

procedure TSmartPDFDocument.SetPageSize(Page: TPDFIndRef; PntWidth,
  PntHeight: Double);
var
  Obj: TPDFObject;
  PageDict: TPDFDictionary;
  ChangeRef: TPDFIndRef;
  ChangeObj: TPDFObject;
begin
  ChangeRef := Page;
  PageDict := PageDictFromRef(ChangeRef);
  ChangeObj := PageDict;
  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('MediaBox');
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      PageDict.Add('MediaBox', Obj);
    end;
    if Obj is TPDFIndRef then
    begin
      ChangeRef := TPDFIndRef(Obj);
      Obj := GetObject(ChangeRef.ObjNum);
      ChangeObj := Obj;
    end;
    if Obj is TPDFArray then
    begin
      if (TPDFArray(Obj).Count = 4) and
        (TPDFArray(Obj).Item[0] is TPDFNumeric) and
        (TPDFArray(Obj).Item[1] is TPDFNumeric) and
        (TPDFArray(Obj).Item[2] is TPDFNumeric) and
        (TPDFArray(Obj).Item[3] is TPDFNumeric) then
      begin
        TPDFNumeric(TPDFArray(Obj).Item[0]).SetTo(0);
        TPDFNumeric(TPDFArray(Obj).Item[1]).SetTo(0);
        TPDFNumeric(TPDFArray(Obj).Item[2]).SetTo(PntWidth);
        TPDFNumeric(TPDFArray(Obj).Item[3]).SetTo(PntHeight);
      end else
      begin
        TPDFArray(Obj).Clear;
        TPDFArray(Obj).Add(FLocalStructure.NewNumeric(0));
        TPDFArray(Obj).Add(FLocalStructure.NewNumeric(0));
        TPDFArray(Obj).Add(FLocalStructure.NewNumeric(PntWidth));
        TPDFArray(Obj).Add(FLocalStructure.NewNumeric(PntHeight));
      end;
    end;
    ChangeObject(ChangeRef.ObjNum, ChangeObj);
  end;

  ChangeRef := Page;
  PageDict := PageDictFromRef(ChangeRef);
  ChangeObj := PageDict;
  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('CropBox');
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      PageDict.Add('CropBox', Obj);
    end;
    if Obj is TPDFIndRef then
    begin
      ChangeRef := TPDFIndRef(Obj);
      Obj := GetObject(ChangeRef.ObjNum);
      ChangeObj := Obj;
    end;
    if Obj is TPDFArray then
    begin
      if (TPDFArray(Obj).Count = 4) and
        (TPDFArray(Obj).Item[0] is TPDFNumeric) and
        (TPDFArray(Obj).Item[1] is TPDFNumeric) and
        (TPDFArray(Obj).Item[2] is TPDFNumeric) and
        (TPDFArray(Obj).Item[3] is TPDFNumeric) then
      begin
        TPDFNumeric(TPDFArray(Obj).Item[0]).SetTo(0);
        TPDFNumeric(TPDFArray(Obj).Item[1]).SetTo(0);
        TPDFNumeric(TPDFArray(Obj).Item[2]).SetTo(PntWidth);
        TPDFNumeric(TPDFArray(Obj).Item[3]).SetTo(PntHeight);
      end else
      begin
        TPDFArray(Obj).Clear;
        TPDFArray(Obj).Add(FLocalStructure.NewNumeric(0));
        TPDFArray(Obj).Add(FLocalStructure.NewNumeric(0));
        TPDFArray(Obj).Add(FLocalStructure.NewNumeric(PntWidth));
        TPDFArray(Obj).Add(FLocalStructure.NewNumeric(PntHeight));
      end;
    end;
    ChangeObject(ChangeRef.ObjNum, ChangeObj);
  end;
end;

function TSmartPDFDocument.GetPageContents(PageRef: TPDFIndRef; Structure: TPDFStructure): AnsiString;
var
  X: Integer;
  Obj: TPDFObject;
  Ref: TPDFIndRef;
  PageDict: TPDFDictionary;
  ContentsArray: TPDFArray;
  Contents: array of TPDFIndRef;
  LastIR: TPDFIndRef;
begin
  Result := '';
  if not Assigned(Structure) then Structure := FLocalStructure;
  SetLength(Contents, 0);
  PageDict := PageDictFromRef(PageRef);
  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('Contents');
    if Obj is TPDFIndRef then
    begin
      LastIR := TPDFIndRef(Obj);
      Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum, Structure);
    end else
      LastIR := nil;
    if Obj is TPDFIndRef then
    begin
      SetLength(Contents, 1);
      Contents[0] := TPDFIndRef(Obj);
    end;
    if Obj is TPDFStream then
    begin
      SetLength(Contents, 1);
      Contents[0] := LastIR;
    end;
    if Obj is TPDFArray then
    begin
      ContentsArray := TPDFArray(Obj);
      SetLength(Contents, ContentsArray.Count);
      for X := 0 to Length(Contents) - 1 do
      begin
        Obj := ContentsArray.Item[X];
        if Obj is TPDFIndRef then
          Contents[X] := TPDFIndRef(Obj)
        else
          Contents[X] := nil;
      end;
    end;
    for X := 0 to Length(Contents) - 1 do
    begin
      if Assigned(Contents[X]) then
      begin
        Ref := Contents[X];
        Obj := FReader.GetObject(Ref.ObjNum, Structure);
        if Obj is TPDFStream then
        begin
          if (SmartInfo.Crypt.Encrypted = spEncrypted) and (not FReader.IsCompact(Ref.ObjNum)) then
          begin
            SmartInfo.Crypt.DecryptObject(SmartInfo.Crypt.MakeKey(Ref.ObjNum, Ref.GenNum), Obj);
            Result := Result + TPDFStream(Obj).GetDecodedStream;
            SmartInfo.Crypt.EncryptObject(SmartInfo.Crypt.MakeKey(Ref.ObjNum, Ref.GenNum), Obj);
          end else
            Result := Result + TPDFStream(Obj).GetDecodedStream;          
        end;
      end;
    end;
  end;
end;

function TSmartPDFDocument.FindPage(Page: Integer): TPDFIndRef;
begin
  if Page = LastPage + 1 then
    Result := GetNextPageRef(Page, LastPageRef)
  else
    Result := FindPageRef(Page);
  LastPage := Page;
  LastPageRef := Result;
end;

function TSmartPDFDocument.NewPage: TPDFIndRef;
var
  PageDict: TPDFDictionary;
  PageRef: TPDFIndRef;
  PageKidsArray: TPDFArray;
begin
  Result := nil;
  PageKidsArray := PageKids;
  if Assigned(PageKidsArray) then
  begin
    PageDict := FLocalStructure.NewDictionary;
    PageDict.Add('Type', FLocalStructure.NewCommonName('Page'));
    PageDict.Add('Parent', FPagesRef);
    PageDict.Add('MediaBox', FLocalStructure.NewIntArray([0, 0, 612, 792]));
    PageDict.Add('Resources', FLocalStructure.NewDictionary);
    PageRef := NewObject(PageDict);
    PageKidsArray.Add(PageRef);
    FPagesDict.Add('Count', FLocalStructure.NewNumeric(Self.PageCount + 1));
    ChangeObject(FPagesRef.ObjNum, FPagesDict);
    Result := PageRef;
  end;
end;

function TSmartPDFDocument.GetPageTextList(PageRef: TPDFIndRef;
  Options: Integer; ExtractOptions: TQPLExtractionOptions): TPDFTextList;
var
  Contents: AnsiString;
  PageDict: TPDFDictionary;
  TempStruct: TPDFStructure;
  Renderer: TPDFRenderer;
  LocalFontCol: TPDFFontCollection;
begin
  Result := nil;

  TempStruct := TPDFStructure.Create;
  try
    PageDict := PageDictFromRef(PageRef);
    Contents := GetPageContents(PageRef, TempStruct);

    if Assigned(PageDict) and (Length(Contents) > 0) then
    begin
      if (Options = 3) or (Options = 4) then
      begin
        LocalFontCol := TPDFFontCollection.Create;
        LocalFontCol.InstallFonts := True;
        LocalFontCol.OnFindObject := DirectFindObject;
        LocalFontCol.UsingTextFunnel := True;

        Renderer := TPDFRenderer.Create(LocalFontCol);
        try
          FTempStruct := TempStruct;
          Renderer.OnFindObject := DirectFindObject;
          if SmartInfo.Crypt.Encrypted = spEncrypted then
          begin
            Renderer.OnDecrypt := RendererDecrypt;
            Renderer.OnEncrypt := RendererEncrypt;
          end;
          Renderer.Destination := rdTextFunnel;
          Renderer.PageDict := PageDict;
          Renderer.TextFunnel.PageWidth := GetPageWidth(PageRef);
          Renderer.TextFunnel.PageHeight := GetPageHeight(PageRef);
          Renderer.TextFunnel.SplitWords := (Options = 4);
          Renderer.TextFunnel.WordGap := ExtractOptions.WordGap;
          Renderer.TextFunnel.IgnoreFont := ExtractOptions.IgnoreFont;
          Renderer.TextFunnel.IgnoreColor := ExtractOptions.IgnoreColor;
          Renderer.TextFunnel.IgnoreBlocks := ExtractOptions.IgnoreBlocks;
          Renderer.TextFunnel.SortBlocks := ExtractOptions.SortBlocks;
          Renderer.TextFunnel.SplitOnDoubleSpace := ExtractOptions.SplitOnDoubleSpace;
          Renderer.TextFunnel.TrimCharsOutsideArea := ExtractOptions.TrimCharsOutsideArea;
          Renderer.TextFunnel.SpecialMatch := ExtractOptions.SpecialMatch;
          Renderer.TextFunnel.IgnoreRotated := ExtractOptions.IgnoreRotated;
          Renderer.TextFunnel.TrimWhitespace := ExtractOptions.TrimWhitespace;
          Renderer.TextFunnel.OutputNonAscii := ExtractOptions.OutputNonAscii;
          Renderer.TextFunnel.OutputCMYK := ExtractOptions.OutputCMYK;
          Renderer.TextFunnel.IgnoreDescenders := ExtractOptions.IgnoreDescenders;
          Renderer.TextFunnel.IgnoreOverlaps := ExtractOptions.IgnoreOverlaps;
          Renderer.TextFunnel.IgnoreDuplicates := ExtractOptions.IgnoreDuplicates;
          Renderer.TextFunnel.HorzScaleFactor := ExtractOptions.HorzScaleFactor;
          Renderer.TextFunnel.VertScaleFactor := ExtractOptions.VertScaleFactor;

          if (ExtractOptions.HasArea) then
          begin
            Renderer.TextFunnel.SetArea(ExtractOptions.AreaLeft,
              ExtractOptions.AreaTop, ExtractOptions.AreaWidth,
              ExtractOptions.AreaHeight);
          end;

          Renderer.Render;
          Result := Renderer.TextFunnel.GetTextList;
        finally
          Renderer.Free;
          LocalFontCol.Free;
        end;
      end;
    end;
  finally
    TempStruct.Free;
  end;
end;

function TSmartPDFDocument.ExtractPageText(PageRef: TPDFIndRef;
  Options: Integer; ExtractOptions: TQPLExtractionOptions): WideString;
var
  Obj: TPDFObject;
  Contents: AnsiString;
  PageDict: TPDFDictionary;
  Extractor: TPDFExtractor;
  Resources: TPDFDictionary;
  TempStruct: TPDFStructure;
  Renderer: TPDFRenderer;
  LocalFontCol: TPDFFontCollection;
begin
  SetLength(Result, 0);

  TempStruct := TPDFStructure.Create;
  try
    PageDict := PageDictFromRef(PageRef);
    Contents := GetPageContents(PageRef, TempStruct);

    if Assigned(PageDict) and (Length(Contents) > 0) then
    begin
      Obj := ReadInheritedValue(PageDict, 'Resources');
      if Obj is TPDFIndRef then Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum, TempStruct);
      if Obj is TPDFDictionary then
        Resources := TPDFDictionary(Obj)
      else
        Resources := nil;

      if Options = 1 then Options := 2;

      if ((Options >= 3) and (Options <= 8)) then
      begin
        LocalFontCol := TPDFFontCollection.Create;
        LocalFontCol.InstallFonts := True;
        LocalFontCol.OnFindObject := DirectFindObject;
        LocalFontCol.UsingTextFunnel := True;

        Renderer := TPDFRenderer.Create(LocalFontCol);
        try
          FTempStruct := TempStruct;
          Renderer.OnFindObject := DirectFindObject;
          if SmartInfo.Crypt.Encrypted = spEncrypted then
          begin
            Renderer.OnDecrypt := RendererDecrypt;
            Renderer.OnEncrypt := RendererEncrypt;
          end;
          Renderer.Destination := rdTextFunnel;
          Renderer.PageDict := PageDict;
          Renderer.TextFunnel.PageWidth := GetPageWidth(PageRef);
          Renderer.TextFunnel.PageHeight := GetPageHeight(PageRef);
          Renderer.TextFunnel.SplitWords := (Options = 4) or (Options = 6);
          Renderer.TextFunnel.OutputWidths := (Options = 5) or (Options = 6);
          Renderer.TextFunnel.WordGap := ExtractOptions.WordGap;
          Renderer.TextFunnel.IgnoreFont := ExtractOptions.IgnoreFont;
          Renderer.TextFunnel.IgnoreColor := ExtractOptions.IgnoreColor;
          Renderer.TextFunnel.IgnoreBlocks := ExtractOptions.IgnoreBlocks;
          Renderer.TextFunnel.SortBlocks := ExtractOptions.SortBlocks;
          Renderer.TextFunnel.SplitOnDoubleSpace := ExtractOptions.SplitOnDoubleSpace;
          Renderer.TextFunnel.TrimCharsOutsideArea := ExtractOptions.TrimCharsOutsideArea;
          Renderer.TextFunnel.SpecialMatch := ExtractOptions.SpecialMatch;
          Renderer.TextFunnel.IgnoreRotated := ExtractOptions.IgnoreRotated;
          Renderer.TextFunnel.TrimWhitespace := ExtractOptions.TrimWhitespace;
          Renderer.TextFunnel.OutputNonAscii := ExtractOptions.OutputNonAscii;
          Renderer.TextFunnel.OutputCMYK := ExtractOptions.OutputCMYK;
          Renderer.TextFunnel.IgnoreDescenders := ExtractOptions.IgnoreDescenders;
          Renderer.TextFunnel.IgnoreOverlaps := ExtractOptions.IgnoreOverlaps;
          Renderer.TextFunnel.IgnoreDuplicates := ExtractOptions.IgnoreDuplicates;
          Renderer.TextFunnel.HorzScaleFactor := ExtractOptions.HorzScaleFactor;
          Renderer.TextFunnel.VertScaleFactor := ExtractOptions.VertScaleFactor;

          if (Options = 7) then
          begin
            Renderer.TextFunnel.IgnoreFont := True;
            Renderer.TextFunnel.IgnoreColor := True;
            Renderer.TextFunnel.IgnoreBlocks := True;
            Renderer.TextFunnel.IgnoreDescenders := True;
          end;

          if (ExtractOptions.HasArea) then
          begin
            Renderer.TextFunnel.SetArea(ExtractOptions.AreaLeft,
              ExtractOptions.AreaTop, ExtractOptions.AreaWidth,
              ExtractOptions.AreaHeight);
          end;

          Renderer.Render;
          if (Options <= 6) then
          begin
            Result := Renderer.TextFunnel.GetCSV;
          end else
          if (Options = 7) then
          begin
            Renderer.TextFunnel.SetTokenAdjacency;
            Result := Renderer.TextFunnel.CreateTextLines;
          end else
          if (Options = 8) then
          begin
            Result := Renderer.TextFunnel.GetRawText;
          end;
        finally
          Renderer.Free;
          LocalFontCol.Free;
        end;
      end else
      begin
        LocalFontCol := TPDFFontCollection.Create;
        LocalFontCol.InstallFonts := True;
        LocalFontCol.OnFindObject := DirectFindObject;
        LocalFontCol.UsingTextFunnel := True;

        Extractor := TPDFExtractor.Create(Resources, LocalFontCol);
        try
          FTempStruct := TempStruct;
          Extractor.OnFindObject := DirectFindObject;
          Result := Extractor.ExtractTextW(Contents, Options);
        finally
          LocalFontCol.Free;
          Extractor.Free;
        end;
      end;
    end;
  finally
    TempStruct.Free;
  end;
end;

function TSmartPDFDocument.FindObject(Ref: TPDFIndRef): TPDFObject;
begin
  Result := FReader.GetObject(Ref.ObjNum);
end;

function TSmartPDFDocument.GetInheritedValue(Dict: TPDFDictionary;
  const Key: AnsiString): TPDFObject;
var
  Obj: TPDFObject;
  HasParent: Boolean;
  IR: TPDFIndRef;
begin
  Result := nil;
  HasParent := False;
  if Assigned(Dict) then
  begin
    repeat
      Result := Dict.FindValueByKeyName(Key);
      if not Assigned(Result) then
      begin
        HasParent := False;
        Obj := Dict.FindValueByKeyName('Parent');
        if Obj is TPDFIndRef then
        begin
          IR := TPDFIndRef(Obj);
          HasParent := True;
          Obj := GetObject(IR.ObjNum);
          ChangeObject(IR.ObjNum, Obj);
          if Obj is TPDFDictionary then
            Dict := TPDFDictionary(Obj)
          else
            HasParent := False;
        end;
      end;
    until Assigned(Result) or (not HasParent);
  end;
end;

procedure TSmartPDFDocument.SetSignatureBounds(const FieldName: WideString;
  Left, Top, Width, Height: Double);
var
  FieldRef: TPDFIndRef;
  FieldDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  FieldRef := FindField(FieldName);
  if Assigned(FieldRef) then
  begin
    Obj := GetObject(FieldRef.ObjNum);
    if Obj is TPDFDictionary then
    begin
      FieldDict := TPDFDictionary(Obj);
      ChangeObject(FieldRef.ObjNum, FieldDict);
      FieldDict.Add('Rect', FLocalStructure.NewDoubleArray([Left, Top - Height, Left + Width, Top]));
    end;
  end;
end;

procedure TSmartPDFDocument.SetSignatureFlags(NewFlags: Integer);
var
  Obj: TPDFObject;
begin
  if Assigned(FAcroFormDict) then
  begin
    Obj := FAcroFormDict.FindValueByKeyName('SigFlags');
    if (Obj is TPDFNumeric) then
    begin
      TPDFNumeric(Obj).SetTo(NewFlags);
    end else
    begin
      FAcroFormDict.Add('SigFlags', FLocalStructure.NewNumeric(NewFlags));
    end;
    ChangeObject(FAcroFormRef.ObjNum, FAcroFormDict);
  end;
end;

procedure TSmartPDFDocument.SetSignatureImage(const FieldName: WideString;
  const ImageData: AnsiString; ImageOptions: Integer);
var
  FieldRef: TPDFIndRef;
  FieldDict: TPDFDictionary;
  Obj: TPDFObject;
  NewRef: TPDFIndRef;
  APDict: TPDFDictionary;
  NStream: TPDFStream;
  XObjectDict: TPDFDictionary;
  ResourcesDict: TPDFDictionary;
  FRMStream: TPDFStream;
  FieldRect: TPDFRectangle;
  FieldWidth: Double;
  FieldHeight: Double;
  PDFImage: TPDFImage;
  ImageDataStream: TMemoryStream;
  OldEvent: TNewIndObjEvent;
begin
  FieldRef := FindField(FieldName);
  if Assigned(FieldRef) and (Length(ImageData) > 0) then
  begin
    Obj := GetObject(FieldRef.ObjNum);
    if Obj is TPDFDictionary then
    begin
      FieldDict := TPDFDictionary(Obj);

      FieldWidth := 100;
      FieldHeight := 100;
      Obj := FieldDict.FindValueByKeyName('Rect');
      if (Obj is TPDFArray) then
      begin
        FieldRect := TPDFRectangle.Create(TPDFArray(Obj));
        try
          FieldWidth := FieldRect.Width;
          FieldHeight := FieldRect.Height;
        finally
          FieldRect.Free;
        end;
      end;

      ChangeObject(FieldRef.ObjNum, FieldDict);
      APDict := FLocalStructure.NewDictionary;
      FieldDict.Add('AP', APDict);
      NStream := FLocalStructure.NewStream('/FRM Do', False);
      NewRef := NewObject(NStream);
      APDict.Add('N', NewRef);
      NStream.Dictionary.Add('BBox', FLocalStructure.NewDoubleArray([0, 0, FieldWidth, FieldHeight]));
      ResourcesDict := FLocalStructure.NewDictionary;
      NStream.Dictionary.Add('Resources', ResourcesDict);
      XObjectDict := FLocalStructure.NewDictionary;
      ResourcesDict.Add('XObject', XObjectDict);
      FRMStream := FLocalStructure.NewStream('q ' + QPLDoubleToStrConst(FieldWidth, 5) + ' 0 0 ' +
        QPLDoubleToStrConst(FieldHeight, 5) + ' 0 0 cm /Im1 Do Q', False);
      NewRef := NewObject(FRMStream);
      XObjectDict.Add('FRM', NewRef);
      FRMStream.Dictionary.Add('Type', FLocalStructure.NewName('XObject'));
      FRMStream.Dictionary.Add('Subtype', FLocalStructure.NewName('Form'));
      ResourcesDict := FLocalStructure.NewDictionary;
      FRMStream.Dictionary.Add('Resources', ResourcesDict);
      XObjectDict := FLocalStructure.NewDictionary;
      ResourcesDict.Add('XObject', XObjectDict);

      PDFImage := TPDFImage.Create(FLocalStructure, 'Im1', nil);  // ADC
      try
        PDFImage.Compress := 1;
        ImageDataStream := TMemoryStream.Create;
        try
          ImageDataStream.Write(ImageData[1], Length(ImageData));
          ImageDataStream.Seek(0, soBeginning);
          OldEvent := FLocalStructure.OnNewIndObj;
          FLocalStructure.OnNewIndObj := NewSigImageObj;
          PDFImage.NewImageFromStream(ImageDataStream, ImageOptions);
          FLocalStructure.OnNewIndObj := OldEvent;
          XObjectDict.Add('Im1', PDFImage.IndRef);
        finally
          ImageDataStream.Free;
        end;
      finally
        PDFImage.Free;
      end;

      FRMStream.Dictionary.Add('BBox', FLocalStructure.NewDoubleArray([0, 0, FieldWidth, FieldHeight]));
    end;
  end;
end;

procedure TSmartPDFDocument.SetSignatureValue(const FieldName: WideString;
  const NewDict: AnsiString);
var
  FieldRef: TPDFIndRef;
  FieldDict: TPDFDictionary;
  Obj: TPDFObject;
  NewRef: TPDFIndRef;
begin
  FieldRef := FindField(FieldName);
  if Assigned(FieldRef) then
  begin
    Obj := GetObject(FieldRef.ObjNum);
    if Obj is TPDFDictionary then
    begin
      FieldDict := TPDFDictionary(Obj);
      ChangeObject(FieldRef.ObjNum, FieldDict);
      Obj := FLocalStructure.Decode(NewDict);
      NewRef := NewObject(Obj);
      if (SmartInfo.Crypt.Encrypted = spEncrypted) and (not FReader.IsCompact(NewRef.ObjNum)) then
        SmartInfo.Crypt.EncryptObject(SmartInfo.Crypt.MakeKey(NewRef.ObjNum, NewRef.GenNum), Obj);
      FieldDict.Add('V', NewRef);
    end;
  end;
end;

function TSmartPDFDocument.FindField(const FieldName: WideString): TPDFIndRef;
var
  X: Integer;
  Obj: TPDFObject;
  Fields: TPDFArray;
begin
  Result := nil;
  if Assigned(FAcroFormDict) then
  begin
    Obj := FAcroFormDict.FindValueByKeyName('Fields');
    if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFArray then
    begin
      Fields := TPDFArray(Obj);
      X := 0;
      while (X < Fields.Count) and (not Assigned(Result)) do
      begin
        if Fields.Item[X] is TPDFIndRef then
        begin
          if GetFieldName(TPDFIndRef(Fields.Item[X])) = FieldName then
            Result := TPDFIndRef(Fields.Item[X]);
        end;
        Inc(X);
      end;
    end;
  end;
end;

function TSmartPDFDocument.AddSignatureField(const FieldName: WideString; PageRef: TPDFIndRef): Integer;
var
  Obj: TPDFObject;
  FieldRef: TPDFIndRef;
  FieldDict: TPDFDictionary;
begin
  FieldRef := AddNewField(FieldName);
  if Assigned(FieldRef) then
  begin
    Obj := GetObject(FieldRef.ObjNum);
    if Obj is TPDFDictionary then
    begin
      FieldDict := TPDFDictionary(Obj);
      FieldDict.Add('Type', FLocalStructure.NewName('Annot'));
      FieldDict.Add('Subtype', FLocalStructure.NewName('Widget'));
      FieldDict.Add('FT', FLocalStructure.NewName('Sig'));
      FieldDict.Add('F', FLocalStructure.NewNumeric(4));
      FieldDict.Add('Rect', FLocalStructure.NewIntArray([0, 0, 0, 0]));
      FieldDict.Add('P', PageRef);
      LinkFieldToPage(PageRef, FieldRef);
    end;
  end;
  Result := FieldRef.ObjNum;
end;

function TSmartPDFDocument.AddNewField(
  const FieldName: WideString): TPDFIndRef;
var
  Obj: TPDFObject;
  FieldDict: TPDFDictionary;
  FieldRef: TPDFIndRef;
  Fields: TPDFArray;
  ChangeRef: TPDFIndRef;
  ChangeObj: TPDFObject;
begin
  Result := nil;
  if not Assigned(FAcroFormDict) then
  begin
    FAcroFormDict := FLocalStructure.NewDictionary;
    FAcroFormRef := NewObject(FAcroFormDict);
    FRootDict.Add('AcroForm', FAcroFormRef);
    ChangeObject(FRootRef.ObjNum, FRootDict);
  end;
  if Assigned(FAcroFormDict) then
  begin
    ChangeObj := FAcroFormDict;
    ChangeRef := FAcroFormRef;
    Obj := FAcroFormDict.FindValueByKeyName('Fields');
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      FAcroFormDict.Add('Fields', Obj);
    end;
    if Obj is TPDFIndRef then
    begin
      ChangeRef := TPDFIndRef(Obj);
      Obj := GetObject(TPDFIndRef(Obj).ObjNum);
      ChangeObj := Obj;
    end;
    if Obj is TPDFArray then
    begin
      Fields := TPDFArray(Obj);
      FieldDict := FLocalStructure.NewDictionary;
      FieldRef := NewObject(FieldDict);
      Fields.Add(FieldRef);

      Obj := FLocalStructure.NewTextString(FieldName);
      if (SmartInfo.Crypt.Encrypted = spEncrypted) and (not FReader.IsCompact(FieldRef.ObjNum)) then
        SmartInfo.Crypt.EncryptObject(SmartInfo.Crypt.MakeKey(FieldRef.ObjNum, FieldRef.GenNum), Obj);
      FieldDict.Add('T', Obj);

      ChangeObject(ChangeRef.ObjNum, ChangeObj);
      Result := FieldRef;
    end;
  end;
end;

procedure TSmartPDFDocument.LinkFieldToPage(PageRef, FieldRef: TPDFIndRef);
var
  Obj: TPDFObject;
  PageDict: TPDFDictionary;
  ChangeRef: TPDFIndRef;
  ChangeObj: TPDFObject;
begin
  PageDict := PageDictFromRef(PageRef);
  if Assigned(PageDict) then
  begin
    ChangeRef := PageRef;
    ChangeObj := PageDict;
    Obj := PageDict.FindValueByKeyName('Annots');
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      PageDict.Add('Annots', Obj);
      ChangeObject(PageRef.ObjNum, PageDict);
    end;
    if Obj is TPDFIndRef then
    begin
      ChangeRef := TPDFIndRef(Obj);
      Obj := GetObject(TPDFIndRef(Obj).ObjNum);
      ChangeObj := Obj;
    end;
    if Obj is TPDFArray then
    begin
      TPDFArray(Obj).Add(FieldRef);
      ChangeObject(ChangeRef.ObjNum, ChangeObj);
    end;
  end;
end;

// Returns a list of the names of the signature fields.
// Field names placed into the string list are UTF-8 encoded.
procedure TSmartPDFDocument.GetSignatures(List: TQuickPDFStringList);
var
  X: Integer;
  Obj: TPDFObject;
  FieldDict: TPDFDictionary;
  FieldRef: TPDFIndRef;
  Fields: TPDFArray;
begin
  List.Clear;
  if Assigned(FAcroFormDict) then
  begin
    Obj := FAcroFormDict.FindValueByKeyName('Fields');
    if Obj is TPDFIndRef then
      Obj := GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFArray then
    begin
      Fields := TPDFArray(Obj);
      for X := 0 to Fields.Count - 1 do
      begin
        Obj := Fields.Item[X];
        if Obj is TPDFIndRef then
        begin
          FieldRef := TPDFIndRef(Obj);
          Obj := GetObject(FieldRef.ObjNum);
          if Obj is TPDFDictionary then
          begin
            FieldDict := TPDFDictionary(Obj);
            Obj := FieldDict.FindValueByKeyName('FT');
            if (Obj is TPDFName) and (TPDFName(Obj).Name = 'Sig') then
              List.AddObject(QPLUTF8Encode(GetFieldName(FieldRef)), FieldRef);
          end;
        end;
      end;
    end;
  end;
end;

function TSmartPDFDocument.GetFieldName(FieldRef: TPDFIndRef): WideString;
var
  Obj: TPDFObject;
  IR: TPDFIndRef;
  FieldDict: TPDFDictionary;
begin
  Result := '';
  Obj := GetObject(FieldRef.ObjNum);
  if Obj is TPDFDictionary then
  begin
    IR := FieldRef;
    FieldDict := TPDFDictionary(Obj);
    Obj := FieldDict.FindValueByKeyName('Parent');
    if Obj is TPDFIndRef then
    begin
      Result := GetFieldName(TPDFIndRef(Obj));
      if Result <> '' then Result := Result + WideString('.');
    end;
    Obj := FieldDict.FindValueByKeyName('T');
    if Obj is TPDFIndRef then
    begin
      IR := TPDFIndRef(Obj);
      Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
    end;
    if Obj is TPDFString then
    begin
      if (FSmartInfo.Crypt.Encrypted = spEncrypted) and (not FReader.IsCompact(IR.ObjNum)) then
      begin
        FSmartInfo.Crypt.DecryptObject(FSmartInfo.Crypt.MakeKey(IR.ObjNum, IR.GenNum), Obj);
        Result := Result + TPDFString(Obj).AsTextString;
        FSmartInfo.Crypt.EncryptObject(FSmartInfo.Crypt.MakeKey(IR.ObjNum, IR.GenNum), Obj);
      end else
        Result := TPDFString(Obj).AsTextString;
    end;
  end;
end;

function TSmartPDFDocument.GetSignatureValue(FieldRef: TPDFIndRef;
  ValueKey: Integer): AnsiString;
var
  Obj: TPDFObject;
  FieldDict: TPDFDictionary;
  ValueDict: TPDFDictionary;
  ByteRange: TPDFArray;
begin
  Result := '';
  Obj := GetObject(FieldRef.ObjNum);
  if Obj is TPDFDictionary then
  begin
    FieldDict := TPDFDictionary(Obj);
    Obj := FieldDict.FindValueByKeyName('V');
    if Obj is TPDFIndRef then
    begin
      Obj := GetObject(TPDFIndRef(Obj).ObjNum);
      if Obj is TPDFDictionary then
      begin
        ValueDict := TPDFDictionary(Obj);
        if ValueKey = 0 then
        begin
          Obj := ValueDict.FindValueByKeyName('Contents');
          if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
          if Obj is TPDFString then
            Result := TPDFString(Obj).AsString;
        end;
        if ValueKey = 1 then
        begin
          Obj := ValueDict.FindValueByKeyName('Cert');
          if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
          if Obj is TPDFString then
            Result := TPDFString(Obj).AsString;
        end;
        if ValueKey = 2 then
        begin
          Obj := ValueDict.FindValueByKeyName('Filter');
          if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
          if Obj is TPDFName then
            Result := TPDFName(Obj).Name;
        end;
        if ValueKey = 3 then
        begin
          Obj := ValueDict.FindValueByKeyName('SubFilter');
          if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
          if Obj is TPDFName then
            Result := TPDFName(Obj).Name;
        end;
        if (ValueKey >= 11) and (ValueKey <= 14) then
        begin
          Obj := ValueDict.FindValueByKeyName('ByteRange');
          if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
          if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 4) then
          begin
            ByteRange := TPDFArray(Obj);
            Obj := ByteRange.Item[ValueKey - 11];
            if Obj is TPDFNumeric then
              Result := QPLIntToStr(TPDFNumeric(Obj).AsInteger);
          end;
        end;
      end;
    end;
  end;
end;

function TSmartPDFDocument.IsPage(Ref: TPDFIndRef): Boolean;
var
  Obj: TPDFObject;
begin
  Result := False;
  if Assigned(Ref) then
  begin
    Obj := GetObject(Ref.ObjNum);
    if Obj is TPDFDictionary then
      Result := (TPDFDictionary(Obj).DictType = 'Page') or (Assigned(TPDFDictionary(Obj).FindValueByKeyName('Contents')));
  end;
end;

function TSmartPDFDocument.GetPageWidth(PageRef: TPDFIndRef): Double;
var
  Obj: TPDFObject;
  R: TPDFRectangle;
begin
  Result := 0;
  Obj := GetPageInheritedValue(PageRef, 'MediaBox');
  if Obj is TPDFArray then
  begin
    R := TPDFRectangle.Create(TPDFArray(Obj));
    try
      Result := R.Width;
    finally
      R.Free;
    end;
  end;
end;

function TSmartPDFDocument.GetPageHeight(PageRef: TPDFIndRef): Double;
var
  Obj: TPDFObject;
  R: TPDFRectangle;
begin
  Result := 0;
  Obj := GetPageInheritedValue(PageRef, 'MediaBox');
  if Obj is TPDFArray then
  begin
    R := TPDFRectangle.Create(TPDFArray(Obj));
    try
      Result := R.Height;
    finally
      R.Free;
    end;
  end;
end;

procedure TSmartPDFDocument.FixPages;
var
  X: Integer;
  D: TPDFDictionary;
  O: TPDFObject;
  R: TPDFIndRef;
  MB: TPDFObject;
  PC: Integer;
  DefaultMB: TPDFObject;
  Changed: Boolean;
begin
  PC := PageCount;
  DefaultMB := FLocalStructure.Decode('[ 0 0 612 792 ]');
  R := nil;
  for X := 1 to PC do
  begin
    try
      R := GetNextPageRef(X, R);
      if Assigned(R) then O := GetObject(R.ObjNum) else O := nil;
      if O is TPDFDictionary then D := TPDFDictionary(O) else D := nil;
      if Assigned(D) then
      begin
        Changed := False;
        O := D.FindValueByKeyName('MediaBox');
        if not Assigned(O) then
        begin
          MB := GetInheritedValue(D, 'MediaBox');
          if MB is TPDFIndRef then MB := GetObject(TPDFIndRef(MB).ObjNum);
          if not (MB is TPDFArray) then MB := DefaultMB;
          D.Add('MediaBox', MB);
          Changed := True;
        end else
        begin
          MB := O;
          if MB is TPDFIndRef then MB := GetObject(TPDFIndRef(MB).ObjNum);
          if not (MB is TPDFArray) then MB := DefaultMB;
        end;
        O := D.FindValueByKeyName('CropBox');
        if not Assigned(O) then
        begin
          O := GetInheritedValue(D, 'CropBox');
          if O is TPDFIndRef then O := GetObject(TPDFIndRef(O).ObjNum);
          if not (O is TPDFArray) then O := MB;
          D.Add('CropBox', O);
          Changed := True;
        end;
        O := D.FindValueByKeyName('Rotate');
        if not Assigned(O) then
        begin
          O := GetInheritedValue(D, 'Rotate');
          if O is TPDFIndRef then O := GetObject(TPDFIndRef(O).ObjNum);
          if not (O is TPDFNumeric) then O := FLocalStructure.NewNumeric(0);
          D.Add('Rotate', O);
        end;
        if Changed then
          ChangeObject(R.ObjNum, D);
      end;
    except
    end;
  end;
end;

function TSmartPDFDocument.Status: AnsiString;
begin
  Result := QPLIntToStr(FLocalStructure.ObjectCount);
end;

function TSmartPDFDocument.FindTempObject(Ref: TPDFIndRef): TPDFObject;
begin
  if Assigned(FTempStruct) then
  begin
    Result := FReader.GetObject(Ref.ObjNum, FTempStruct);
  end else
    Result := nil;
end;

function TSmartPDFDocument.DirectFindObject(Ref: TPDFIndRef): TPDFObject;
begin
  Result := GetObject(Ref.ObjNum);
end;

procedure TSmartPDFDocument.RenderPageToStream(PageRef: TPDFIndRef;
  Options: Integer; DPI: Double; JPEGQuality: Integer; GDIPlusSettings: TGDIPlusSettings;
  Target: TStream; var RenderError: AnsiString; OCGStateList: TQPLOCGStateList);
var
  Renderer: TPDFRenderer;
  TempStruct: TPDFStructure;
  JI: TPDFJPEGImage;
  PW: TPNGWriter;
  GW: TPDFGIFWriter;
  PPM: Integer;
  LocalFontCol: TPDFFontCollection;
begin
  TempStruct := TPDFStructure.Create;
  try
    FTempStruct := TempStruct;

    LocalFontCol := TPDFFontCollection.Create;
    LocalFontCol.InstallFonts := True;
    LocalFontCol.OnFindObject := DirectFindObject;

    Renderer := TPDFRenderer.Create(LocalFontCol);
    try
      Renderer.GDIPlusSettings := GDIPlusSettings;
      Renderer.DPI := DPI;
      Renderer.OCGStateList := OCGStateList;
      Renderer.PageDict := PageDictFromRef(PageRef);
      Renderer.OnFindObject := DirectFindObject;
      if SmartInfo.Crypt.Encrypted = spEncrypted then
      begin
        Renderer.OnDecrypt := RendererDecrypt;
        Renderer.OnEncrypt := RendererEncrypt;
      end;
      case Options of
        2: Renderer.Destination := rdWMF;
        3: Renderer.Destination := rdEMF;
        4: Renderer.Destination := rdEPS;
        8: Renderer.Destination := rdEMFPlus;
        9: Renderer.Destination := rdHTML5;
      else
        Renderer.Destination := rdBitmap;
      end;
      if Options = 8 then
      begin
        Renderer.SetEMFPlusTarget(Target);
      end else
      if Options = 9 then
      begin
        Renderer.SetHTML5Target(Target);
      end;
      Renderer.Render;
      RenderError := Renderer.ErrorDesc;
      if Options = 0 then
      begin
        Renderer.Bitmap.SaveToStream(Target);
        Target.Seek($26, soBeginning);
        PPM := Trunc((DPI * 1000) / 25.4);
        Target.Write(PPM, 4);
        Target.Write(PPM, 4);
      end else
      if Options = 1 then
      begin
        JI := TPDFJPEGImage.Create;
        try
          JI.LoadFromBitmap(Renderer.Bitmap);
          JI.CompressionQuality := JPEGQuality;
          JI.DPI := Round(DPI);
          JI.SaveToStream(Target);
        finally
          JI.Free;
        end;
      end else
      if Options = 2 then
      begin
        Renderer.Metafile.SaveToStream(Target);
      end else
      if Options = 3 then
      begin
        Renderer.Metafile.SaveToStream(Target);
      end else
      if Options = 4 then
      begin
        Renderer.EPS.SaveToStream(Target);
      end else
      if Options = 5 then
      begin
        PW := TPNGWriter.Create(Renderer.Bitmap);
        try
          PW.SetDPI(Round(DPI));
          PW.SaveToStream(Target);
        finally
          PW.Free;
        end;
      end else
      if Options = 6 then
      begin
        GW := TPDFGIFWriter.Create;
        try
          GW.Assign(Renderer.Bitmap);
          GW.SaveToStream(Target);
        finally
          GW.Free;
        end;
      end else
      if Options = 7 then
      begin
        ConvertBitmapToTIFF(Renderer.Bitmap, Target, GDIPlusSettings, DPI);
      end else
      if Options = 8 then
      begin
        // EMFPlus written directly to the stream
      end else
      if Options = 9 then
      begin
        // HTML5 written directly to the stream
      end else
      if Options = 10 then
      begin
        ConvertBitmapToG4TIFF(Renderer.Bitmap, Target, GDIPlusSettings, DPI);
      end;
    finally
      LocalFontCol.Free;
      Renderer.Free;
    end;
  finally
    TempStruct.Free;
    FTempStruct := nil;
  end;
end;

procedure TSmartPDFDocument.RendererDecrypt(Source: TPDFStream;
  Ref: TPDFIndRef);
begin
  if not FReader.IsCompact(Ref.ObjNum) then
    SmartInfo.Crypt.DecryptObject(SmartInfo.Crypt.MakeKey(Ref.ObjNum, Ref.GenNum), Source);
end;

procedure TSmartPDFDocument.RendererEncrypt(Source: TPDFStream;
  Ref: TPDFIndRef);
begin
  if not FReader.IsCompact(Ref.ObjNum) then
    SmartInfo.Crypt.EncryptObject(SmartInfo.Crypt.MakeKey(Ref.ObjNum, Ref.GenNum), Source);
end;

function TSmartPDFDocument.MovePage(PageRef, TargetPageRef: TPDFIndRef;
  Before: Boolean): Boolean;
var
  Obj: TPDFObject;
  PageNodeRef: TPDFIndRef;
  PageNode: TPDFDictionary;
  PageDict: TPDFDictionary;
  Kids: TPDFArray;
  Index: Integer;
  ChangeRef: TPDFIndRef;
  ChangeObj: TPDFObject;
begin
  Result := False;

  PageNode := nil;
  PageDict := PageDictFromRef(TargetPageRef);
  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('Parent');
    if Obj is TPDFIndRef then
    begin
      PageNodeRef := TPDFIndRef(Obj);
      Obj := GetObject(PageNodeRef.ObjNum);
      if Obj is TPDFDictionary then PageNode := TPDFDictionary(Obj);
    end else
      PageNodeRef := nil;
    if Assigned(PageNode) and Assigned(PageNodeRef) then
    begin
      ChangeRef := PageNodeRef;
      ChangeObj := PageNode;
      Obj := PageNode.FindValueByKeyName('Kids');
      if Obj is TPDFIndRef then
      begin
        ChangeRef := TPDFIndRef(Obj);
        Obj := GetObject(TPDFIndRef(Obj).ObjNum);
        ChangeObj := Obj;        
      end;
      if Obj is TPDFArray then
      begin
        ChangeObject(ChangeRef.ObjNum, ChangeObj);
        Kids := TPDFArray(Obj);
        HidePage(PageRef);
        Index := Kids.ItemIndexMatch(TargetPageRef);
        if Index >= 0 then
        begin
          if not Before then Inc(Index);
          Kids.Insert(Index, PageRef);
          AdjustPageCount(PageNodeRef, 1);
        end;
        PageDict := PageDictFromRef(PageRef);
        PageDict.Add('Parent', PageNodeRef);
        ChangeObject(PageRef.ObjNum, PageDict);
        Result := True;
      end;
    end;
  end;
end;

procedure TSmartPDFDocument.AdjustPageCount(PageNodeRef: TPDFIndRef;
  Change: Integer);
var
  Obj: TPDFObject;
  PageNode: TPDFDictionary;
begin
  Obj := GetObject(PageNodeRef.ObjNum);
  if Obj is TPDFDictionary then
  begin
    PageNode := TPDFDictionary(Obj);
    ChangeObject(PageNodeRef.ObjNum, PageNode);
    Obj := PageNode.FindValueByKeyName('Count');
    if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFNumeric then
      TPDFNumeric(Obj).SetTo(TPDFNumeric(Obj).AsInteger + Change);
    Obj := PageNode.FindValueByKeyName('Parent');
    if Obj is TPDFIndRef then
      AdjustPageCount(TPDFIndRef(Obj), Change);
  end;
end;

function TSmartPDFDocument.GetPageRotation(PageRef: TPDFIndRef): Integer;
var
  Obj: TPDFObject;
begin
  Result := 0;
  Obj := GetPageInheritedValue(PageRef, 'Rotate');
  if Obj is TPDFNumeric then
    Result := TPDFNumeric(Obj).AsInteger;
end;

function TSmartPDFDocument.GetPageInheritedValue(PageRef: TPDFIndRef;
  const Name: AnsiString): TPDFObject;
var
  Obj: TPDFObject;
  ThisDict: TPDFDictionary;
begin
  Result := nil;
  ThisDict := nil;
  if Assigned(PageRef) then
  begin
    Obj := GetObject(PageRef.ObjNum);
    if Obj is TPDFDictionary then
      ThisDict := TPDFDictionary(Obj);
    Result := nil;
    repeat
      if Assigned(ThisDict) then
      begin
        Obj := ThisDict.FindValueByKeyName(Name);
        if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
        if not Assigned(Obj) then
        begin
          Obj := ThisDict.FindValueByKeyName('Parent');
          if Obj is TPDFIndRef then Obj := GetObject(TPDFIndRef(Obj).ObjNum);
          if Obj is TPDFDictionary then ThisDict := TPDFDictionary(Obj)
            else ThisDict := nil;
        end else
          Result := Obj;
      end;
    until Assigned(Result) or (ThisDict = nil);
  end;
end;

function TSmartPDFDocument.SetPageRotation(PageRef: TPDFIndRef; Angle,
  Options: Integer): Boolean;
var
  Obj: TPDFObject;
  IndObj: TPDFObject;
  PageDict: TPDFDictionary;
  ChangeObj: TPDFObject;
  ChangeRef: TPDFIndRef;
begin
  Result := False;
  PageDict := PageDictFromRef(PageRef);
  ChangeObj := PageDict;
  ChangeRef := PageRef;
  Obj := PageDict.FindValueByKeyName('Rotate');
  if Obj is TPDFIndRef then
  begin
    IndObj := GetObject(TPDFIndRef(Obj).ObjNum);
    if IndObj is TPDFNumeric then
    begin
      ChangeObj := IndObj;
      ChangeRef := TPDFIndRef(Obj);
      TPDFNumeric(IndObj).SetTo(Angle);
      ChangeObject(ChangeRef.ObjNum, ChangeObj);
      Result := True;
    end;
  end;
  if not Result then
  begin
    PageDict.Add('Rotate', FLocalStructure.NewNumeric(Angle));
    ChangeObject(ChangeRef.ObjNum, ChangeObj);
    Result := True;
  end;
end;

function TSmartPDFDocument.GetPageImages(
  PageRef: TPDFIndRef): TPDFImageList;
var
  L: Integer;
  Renderer: TPDFRenderer;
  TempStruct: TPDFStructure;
  LocalFontCol: TPDFFontCollection;
begin
  L := Length(FImageListArray);
  SetLength(FImageListArray, L + 1);
  Result := TPDFImageList.Create;
  FImageListArray[L] := Result;

  TempStruct := TPDFStructure.Create;
  try
    FTempStruct := TempStruct;
    LocalFontCol := TPDFFontCollection.Create;
    LocalFontCol.InstallFonts := True;
    LocalFontCol.OnFindObject := DirectFindObject;

    Renderer := TPDFRenderer.Create(LocalFontCol);
    try
      Renderer.DPI := 72;
      Renderer.Destination := rdImageList;
      Renderer.ImageList := Result;
      Renderer.PageDict := PageDictFromRef(PageRef);
      Renderer.OnFindObject := DirectFindObject;
      if SmartInfo.Crypt.Encrypted = spEncrypted then
      begin
        Renderer.OnDecrypt := RendererDecrypt;
        Renderer.OnEncrypt := RendererEncrypt;
      end;
      Renderer.Render;
    finally
      Renderer.Free;
      LocalFontCol.Free;
    end;
  finally
    TempStruct.Free;
    FTempStruct := nil;
  end;
end;

function TSmartPDFDocument.GetImageIntProperty(ImageList: TPDFImageList; ImageIndex,
  PropertyID: Integer): Integer;
begin
  Result := 0;
  if Assigned(ImageList) then
  begin
    case PropertyID of
      400: Result := Integer(ImageList.ImageType(ImageIndex));
      401: Result := ImageList.ImagePixelWidth(ImageIndex);
      402: Result := ImageList.ImagePixelHeight(ImageIndex);
    end;
  end;
end;

function TSmartPDFDocument.GetImageListCount(
  ImageList: TPDFImageList): Integer;
begin
  if Assigned(ImageList) then
  begin
    Result := ImageList.ImageCount;
  end else
  begin
    Result := 0;
  end;
end;

function TSmartPDFDocument.GetImageData(ImageList: TPDFImageList;
  ImageIndex: Integer): AnsiString;
begin
  if (Assigned(ImageList)) then
  begin
    Result := ImageList.ImageData(ImageIndex);
  end else
  begin
    Result := '';
  end;
end;

function TSmartPDFDocument.GetImageDblProperty(ImageList: TPDFImageList; ImageIndex,
  PropertyID: Integer): Double;
begin
  Result := 0;
  if Assigned(ImageList) then
  begin
    case PropertyID of
      501: Result := ImageList.ImageCorner(ImageIndex, icTopLeft, True);
      502: Result := ImageList.ImageCorner(ImageIndex, icTopLeft, False);
      503: Result := ImageList.ImageCorner(ImageIndex, icTopRight, True);
      504: Result := ImageList.ImageCorner(ImageIndex, icTopRight, False);
      505: Result := ImageList.ImageCorner(ImageIndex, icBottomRight, True);
      506: Result := ImageList.ImageCorner(ImageIndex, icBottomRight, False);
      507: Result := ImageList.ImageCorner(ImageIndex, icBottomLeft, True);
      508: Result := ImageList.ImageCorner(ImageIndex, icBottomLeft, False);
    end;
  end;
end;

function TSmartPDFDocument.AcroFormFonts: TPDFDictionary;
var
  Obj: TPDFObject;
  DR: TPDFDictionary;
begin
  Result := nil;
  if Assigned(AcroFormDict) then
  begin
    Obj := AcroFormDict.FindValueByKeyName('DR');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFDictionary then
    begin
      DR := TPDFDictionary(Obj);
      Obj := DR.FindValueByKeyName('Font');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if Obj is TPDFDictionary then
        Result := TPDFDictionary(Obj);
    end;
  end;
end;

procedure TSmartPDFDocument.AddFieldFonts(FontDictionary: TPDFDictionary;
  Offset: Integer);
var
  D: TPDFDictionary;
  Obj: TPDFObject;
  DR: TPDFDictionary;
  FontDict: TPDFDictionary;
  X: Integer;
  N: TPDFName;
  R: TPDFIndRef;
begin
  D := AcroFormDict;
  if Assigned(D) and Assigned(FontDictionary) then
  begin
    Obj := D.FindValueByKeyName('DR');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if not (Obj is TPDFDictionary) then
    begin
      Obj := FLocalStructure.NewDictionary;
      AcroFormDict.Add('DR', Obj);
    end;
    if Obj is TPDFDictionary then
    begin
      DR := TPDFDictionary(Obj);
      Obj := DR.FindValueByKeyName('Font');
      if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
      if not (Obj is TPDFDictionary) then
      begin
        Obj := FLocalStructure.NewDictionary;
        DR.Add('Font', Obj);
      end;
      if Obj is TPDFDictionary then
      begin
        FontDict := TPDFDictionary(Obj);
        for X := 0 to FontDictionary.Count - 1 do
        begin
          N := FontDictionary.Entry[X].Key;
          if FontDictionary.FindIndexByKeyName(N.Name) < 0 then
          begin
            Obj := FontDictionary.Entry[X].Value;
            if Obj is TPDFIndRef then
            begin
              R := TPDFIndRef(Obj);
              FontDict.Add(N.Name, FLocalStructure.NewIndirectRef(R.ObjNum + Offset, R.GenNum));
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TSmartPDFDocument.ExtractPageTextToFunnel(PageRef: TPDFIndRef;
  Funnel: TPDFTextFunnel);
var
  PageDict: TPDFDictionary;
  TempStruct: TPDFStructure;
  Renderer: TPDFRenderer;
  LocalFontCol: TPDFFontCollection;
begin
  TempStruct := TPDFStructure.Create;
  try
    PageDict := PageDictFromRef(PageRef);

    LocalFontCol := TPDFFontCollection.Create;
    LocalFontCol.InstallFonts := True;
    LocalFontCol.OnFindObject := DirectFindObject;
    LocalFontCol.UsingTextFunnel := True;

    if Assigned(PageDict) then
    begin
      Renderer := TPDFRenderer.Create(LocalFontCol);
      try
        FTempStruct := TempStruct;
        Renderer.OnFindObject := DirectFindObject;
        if SmartInfo.Crypt.Encrypted = spEncrypted then
        begin
          Renderer.OnDecrypt := RendererDecrypt;
          Renderer.OnEncrypt := RendererEncrypt;
        end;
        Renderer.Destination := rdTextFunnel;
        Renderer.PageDict := PageDict;
        Renderer.TextFunnel := Funnel;
        Renderer.Render;
      finally
        LocalFontCol.Free;
        Renderer.Free;
      end;
    end;
  finally
    TempStruct.Free;
  end;
end;

procedure TSmartPDFDocument.RenderPageAreaToBitmap(PageRef: TPDFIndRef;
  Left, Top, Width, Height: Double; DPI: Double; BM: TBitmap;
  GDIPlusSettings: TGDIPlusSettings; var RenderError: AnsiString;
  OCGStateList: TQPLOCGStateList);
var
  Renderer: TPDFRenderer;
  TempStruct: TPDFStructure;
  OldCrop: TPDFObject;
  LocalFontCol: TPDFFontCollection;
begin
  TempStruct := TPDFStructure.Create;
  try
    FTempStruct := TempStruct;

    LocalFontCol := TPDFFontCollection.Create;
    LocalFontCol.InstallFonts := True;
    LocalFontCol.OnFindObject := DirectFindObject;

    Renderer := TPDFRenderer.Create(LocalFontCol);
    try
      Renderer.GDIPlusSettings := GDIPlusSettings;
      Renderer.DPI := DPI;
      Renderer.OCGStateList := OCGStateList;
      Renderer.PageDict := PageDictFromRef(PageRef);
      OldCrop := Renderer.PageDict.FindValueByKeyName('CropBox', False);
      Renderer.PageDict.Add('CropBox', TempStruct.NewDoubleArray([Left, Top - Height, Left + Width, Top]));
      Renderer.OnFindObject := DirectFindObject;
      if SmartInfo.Crypt.Encrypted = spEncrypted then
      begin
        Renderer.OnDecrypt := RendererDecrypt;
        Renderer.OnEncrypt := RendererEncrypt;
      end;
      Renderer.Destination := rdBitmap;
      Renderer.Render;
      RenderError := Renderer.ErrorDesc;
      if Assigned(OldCrop) then
        Renderer.PageDict.Add('CropBox', OldCrop)
      else
        Renderer.PageDict.DeleteEntryByKeyName('CropBox');
      BM.Assign(Renderer.Bitmap);
    finally
      Renderer.Free;
      LocalFontCol.Free;
    end;
  finally
    TempStruct.Free;
    FTempStruct := nil;
  end;
end;

procedure TSmartPDFDocument.GetReferencedObjects(Resources: TPDFDictionary;
  List, Searched: TQuickPDFStringList);
var
  Obj: TPDFObject;
  St: TPDFStructure;
  X: Integer;
begin
  if Assigned(Resources) then
  begin
    St := TPDFStructure.Create;
    try
      St.Decode(Resources.Output);
      for X := 0 to St.ObjectCount - 1 do
      begin
        Obj := St.GetObject(X);
        if Obj is TPDFIndRef then
          GetReferencedObjects(TPDFIndRef(Obj), List, Searched);
      end;
    finally
      St.Free;
    end;
  end;
end;

function TSmartPDFDocument.GetPageResources(
  PageRef: TPDFIndRef): TPDFDictionary;
var
  Obj: TPDFObject;
  PageDict: TPDFDictionary;
  PageList: TObjectList;
begin
  PageList := TObjectList.Create(False);
  try
    Result := nil;
    Obj := FindObject(PageRef);
    if Obj is TPDFDictionary then
    begin
      PageDict := TPDFDictionary(Obj);
      while Assigned(PageDict) do
      begin
        Obj := PageDict.FindValueByKeyName('Resources');
        if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
        if Obj is TPDFDictionary then
          Result := TPDFDictionary(Obj);
        if not Assigned(Result) then
        begin
          Obj := PageDict.FindValueByKeyName('Parent');
          PageDict := nil;
          if Obj is TPDFIndRef then
          begin
            Obj := FindObject(TPDFIndRef(Obj));
            if Obj is TPDFDictionary then
              PageDict := TPDFDictionary(Obj);
          end;
        end else
          PageDict := nil;
        if Assigned(PageDict) and (PageList.IndexOf(PageDict) > 0) then
          PageDict := nil;
        PageList.Add(PageDict);
      end;
    end;
  finally
    PageList.Free;
  end;
end;

procedure TSmartPDFDocument.GetReferencedObjects(Ref: TPDFIndRef; List,
  Searched: TQuickPDFStringList);
var
  Obj: TPDFObject;
  DictType: AnsiString;
  Process: Boolean;
  St: TPDFStructure;
  X: Integer;
begin
  if Searched.IndexOf(Ref.Output) < 0 then
  begin
    Searched.Add(Ref.Output);
    Obj := FindObject(Ref);
    Process := List.IndexOf(Ref.Output) < 0;
    if Obj is TPDFDictionary then
    begin
      DictType := TPDFDictionary(Obj).DictType;
      if (DictType = 'Page') or (DictType = 'Pages') or (DictType = 'Catalog') then
        Process := False;
    end;
    if Assigned(Obj) and Process then
    begin
      List.Add(Ref.Output);
      St := TPDFStructure.Create;
      try
        St.Decode(Obj.Output);
        for X := 0 to St.ObjectCount - 1 do
        begin
          Obj := St.GetObject(X);
          if Obj is TPDFIndRef then
            GetReferencedObjects(TPDFIndRef(Obj), List, Searched);
        end;
      finally
        St.Free;
      end;
    end;
  end;
end;

function TSmartPDFDocument.LSObjectCount: Integer;
begin
  Result := FLocalStructure.ObjectCount;
end;

function TSmartPDFDocument.FastGetPageImageData(
  PageRef: TPDFIndRef; var ImageWidth, ImageHeight: Integer): AnsiString;
var
  X: Integer;
  Dict: TPDFDictionary;
  FoundX: Boolean;
  Obj: TPDFObject;
  TM: TPDFTIFFMaker;
  MS: TMemoryStream;
  FilterStr: AnsiString;
begin
  Result := '';
  ImageWidth := 0;
  ImageHeight := 0;
  Dict := GetPageResources(PageRef);
  X := 0;
  FoundX := False;
  while (X < Dict.Count) and (not FoundX) do
  begin
    if Dict.Entry[X].Key.Name = 'XObject' then
    begin
      Dict := TPDFDictionary(Dict.Entry[X].Value);
      FoundX := True;
    end else
      Inc(X);
  end;
  if Dict.Count > 0 then
  begin
    if Dict.Entry[0].Value is TPDFIndRef then
    begin
      Obj := FindObject(TPDFIndRef(Dict.Entry[0].Value));
      if Obj is TPDFStream then
      begin
        Dict := TPDFStream(Obj).Dictionary;
        FilterStr := Dict.StringValue('Filter');
        if FilterStr = '[ /FlateDecode ]' then
        begin
          Result := 'Flate';
        end else
        if FilterStr = 'CCITTFaxDecode' then
        begin
          TM := TPDFTIFFMaker.Create;
          try
            TM.Width := Dict.IntValue('Width');
            TM.Height := Dict.IntValue('Height');
            ImageWidth := TM.Width;
            ImageHeight := TM.Height;
            TM.Compression := ttCCITT4;
            TM.HorizontalDPI := Round(TM.Width / 8.5);
            TM.VerticalDPI := Round(TM.Height / 11);
            TM.Source := TPDFStream(Obj).Stream;
            MS := TMemoryStream.Create;
            try
              TM.WriteTIFFToStream(MS);
              MS.Seek(0, soBeginning);
              SetLength(Result, MS.Size);
              MS.Read(Result[1], Length(Result));
            finally
              MS.Free;
            end;
          finally
            TM.Free;
          end;
        end;
      end;
    end;
  end;
end;

function TSmartPDFDocument.GetPageDXPageHash1(PageRef: TPDFIndRef): AnsiString;
var
  Obj: TPDFObject;
  PageDict: TPDFDictionary;
  ResourcesDict: TPDFDictionary;
  XObjectDict: TPDFDictionary;
  XObjectIndex: Integer;
  PageObjectNumber: AnsiString;
  ParentObjectNumber: AnsiString;
  PageRotation: AnsiString;
  PageWidth: AnsiString;
  PageHeight: AnsiString;
  EncodedPageContents: AnsiString;
  EncodedXObjectContents: AnsiString;
begin
  PageObjectNumber := QPLIntToStr(PageRef.ObjNum);
  Obj := GetObject(PageRef.ObjNum);
  if (Obj is TPDFDictionary) then
  begin
    PageDict := TPDFDictionary(Obj);
    Obj := PageDict.FindValueByKeyName('Parent', False);
    if (Obj is TPDFIndRef) then
    begin
      ParentObjectNumber := QPLIntToStr(TPDFIndRef(Obj).ObjNum);
    end;
    PageRotation := QPLIntToStr(GetPageRotation(PageRef));
    PageWidth := QPLIntToStr(Trunc(GetPageWidth(PageRef)));
    PageHeight := QPLIntToStr(Trunc(GetPageHeight(PageRef)));
    EncodedPageContents := GetEncodedPageContents(PageRef);
    EncodedXObjectContents := '';
    ResourcesDict := GetPageResources(PageRef);
    if Assigned(ResourcesDict) then
    begin
      Obj := ResourcesDict.FindValueByKeyName('XObject', True);
      if Obj is TPDFDictionary then
      begin
        XObjectDict := TPDFDictionary(Obj);
        for XObjectIndex := 0 to XObjectDict.Count - 1 do
        begin
          Obj := XObjectDict.Entry[XObjectIndex].Value;
          if Obj is TPDFIndRef then
          begin
            Obj := GetObject(TPDFIndRef(Obj).ObjNum);
            if Obj is TPDFStream then
            begin
              EncodedXObjectContents := EncodedXObjectContents + TPDFStream(Obj).Stream;
            end;
          end;
        end;
      end;
    end;
  end;
  Result := QPLUpperCase(MD5Print(MD5String(PageObjectNumber + ParentObjectNumber +
    PageRotation + PageWidth + PageHeight + EncodedPageContents + EncodedXObjectContents)));
end;

function TSmartPDFDocument.GetEncodedPageContents(PageRef: TPDFIndRef;
  Structure: TPDFStructure): AnsiString;
var
  X: Integer;
  Obj: TPDFObject;
  Ref: TPDFIndRef;
  PageDict: TPDFDictionary;
  ContentsArray: TPDFArray;
  Contents: array of TPDFIndRef;
  LastIR: TPDFIndRef;
begin
  Result := '';
  if not Assigned(Structure) then Structure := FLocalStructure;
  SetLength(Contents, 0);
  PageDict := PageDictFromRef(PageRef);
  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('Contents');
    if Obj is TPDFIndRef then
    begin
      LastIR := TPDFIndRef(Obj);
      Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum, Structure);
    end else
      LastIR := nil;
    if Obj is TPDFIndRef then
    begin
      SetLength(Contents, 1);
      Contents[0] := TPDFIndRef(Obj);
    end;
    if Obj is TPDFStream then
    begin
      SetLength(Contents, 1);
      Contents[0] := LastIR;
    end;
    if Obj is TPDFArray then
    begin
      ContentsArray := TPDFArray(Obj);
      SetLength(Contents, ContentsArray.Count);
      for X := 0 to Length(Contents) - 1 do
      begin
        Obj := ContentsArray.Item[X];
        if Obj is TPDFIndRef then
          Contents[X] := TPDFIndRef(Obj)
        else
          Contents[X] := nil;
      end;
    end;
    for X := 0 to Length(Contents) - 1 do
    begin
      if Assigned(Contents[X]) then
      begin
        Ref := Contents[X];
        Obj := FReader.GetObject(Ref.ObjNum, Structure);
        if Obj is TPDFStream then
        begin
          if (SmartInfo.Crypt.Encrypted = spEncrypted) and (not FReader.IsCompact(Ref.ObjNum)) then
          begin
            SmartInfo.Crypt.EncryptObject(SmartInfo.Crypt.MakeKey(Ref.ObjNum, Ref.GenNum), Obj);
            Result := Result + TPDFStream(Obj).Stream;
            SmartInfo.Crypt.EncryptObject(SmartInfo.Crypt.MakeKey(Ref.ObjNum, Ref.GenNum), Obj);
          end else
            Result := Result + TPDFStream(Obj).Stream;
        end;
      end;
    end;
  end;
end;

function TSmartPDFDocument.GetEncryptionDictObjNum: Integer;
var
  Obj: TPDFObject;
begin
  Obj := FReader.FTrailerDict.FindValueByKeyName('Encrypt');
  if (Obj is TPDFIndRef) then
  begin
    Result := TPDFIndRef(Obj).ObjNum;
  end else
  begin
    Result := 0;
  end;
end;

function TSmartPDFDocument.RenderPageToString(PageRef: TPDFIndRef;
  Options: Integer; DPI: Double; JPEGQuality: Integer;
  GDIPlusSettings: TGDIPlusSettings; var RenderError: AnsiString;
  OCGStateList: TQPLOCGStateList): AnsiString;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    RenderPageToStream(PageRef, Options, DPI, JPEGQuality, GDIPlusSettings, MS,
      RenderError, OCGStateList);
    SetLength(Result, MS.Size);
    MS.Seek(0, soBeginning);
    MS.Read(Result[1], Length(Result));
    MS.Clear;
  finally
    MS.Free;
  end;
end;

function TSmartPDFDocument.GetSignatureObjectNumber(const FieldName: WideString): Integer;
var
  FieldRef: TPDFIndRef;
begin
  Result := 0;
  FieldRef := FindField(FieldName);
  if Assigned(FieldRef) then
  begin
    Result := FieldRef.ObjNum;
  end;
end;

function TSmartPDFDocument.GetSignatureValueObjectNumber(
  const FieldName: WideString): Integer;
var
  FieldRef: TPDFIndRef;
  Obj: TPDFObject;
begin
  Result := 0;
  FieldRef := FindField(FieldName);
  if Assigned(FieldRef) then
  begin
    Obj := GetObject(FieldRef.ObjNum);
    if Obj is TPDFDictionary then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName('V');
      if Obj is TPDFIndRef then
        Result := TPDFIndRef(Obj).ObjNum;
    end;
  end;
end;

function TSmartPDFDocument.HasSignatureField(
  const FieldName: WideString): Boolean;
var
  FieldRef: TPDFIndRef;
  FieldDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := False;
  FieldRef := FindField(FieldName);
  if Assigned(FieldRef) then
  begin
    Obj := GetObject(FieldRef.ObjNum);
    if Obj is TPDFDictionary then
    begin
      FieldDict := TPDFDictionary(Obj);
      Obj := FieldDict.FindValueByKeyName('FT');
      if Obj is TPDFName then
      begin
        Result := TPDFName(Obj).Name = 'Sig';
      end;
    end;
  end;
end;

{$IFDEF QPL_CAIRO}
procedure TSmartPDFDocument.RenderPageToCairoDC(PageRef: TPDFIndRef;
  DPI: Double; JPEGQuality: Integer; const CairoFileName: WideString;
  TargetDC: HDC; var RenderError: AnsiString; RenderCropType, OffsetX, OffsetY: Integer;
  ErasePage: Boolean; OCGStateList: TQPLOCGStateList);
var
  Renderer: TPDFRenderer;
  TempStruct: TPDFStructure;
  LocalFontCol: TPDFFontCollection;
begin
  TempStruct := TPDFStructure.Create;
  try
    FTempStruct := TempStruct;

    LocalFontCol := TPDFFontCollection.Create;
    LocalFontCol.InstallFonts := True;
    LocalFontCol.OnFindObject := DirectFindObject;

    Renderer := TPDFRenderer.Create(LocalFontCol);
    try
      Renderer.DPI := DPI;
      Renderer.CropType := RenderCropType;
      Renderer.OCGStateList := OCGStateList;
      Renderer.PageDict := PageDictFromRef(PageRef);
      Renderer.OnFindObject := DirectFindObject;
      if SmartInfo.Crypt.Encrypted = spEncrypted then
      begin
        Renderer.OnDecrypt := RendererDecrypt;
        Renderer.OnEncrypt := RendererEncrypt;
      end;
      Renderer.Destination := rdCairo;
      Renderer.SetCairoTarget(CairoFileName, TargetDC, ErasePage, OffsetX, OffsetY);
      Renderer.SetDeviceContextTarget(TargetDC, ErasePage, OffsetX, OffsetY);
      Renderer.Render;
      RenderError := Renderer.ErrorDesc;
    finally
      Renderer.Free;
      LocalFontCol.Free;
    end;
  finally
    TempStruct.Free;
    FTempStruct := nil;
  end;
end;
{$ENDIF}

{$IFDEF QPL_DPLR}
procedure TSmartPDFDocument.RenderPageToDPLRDC(PageRef: TPDFIndRef;
  DPI: Double; JPEGQuality: Integer; const DPLRFileName: WideString;
  TargetDC: HDC; var RenderError: AnsiString; RenderCropType, OffsetX, OffsetY: Integer;
  ErasePage: Boolean; OCGStateList: TQPLOCGStateList);
var
  Renderer: TPDFRenderer;
  TempStruct: TPDFStructure;
  LocalFontCol: TPDFFontCollection;
begin
  TempStruct := TPDFStructure.Create;
  try
    FTempStruct := TempStruct;

    LocalFontCol := TPDFFontCollection.Create;
    LocalFontCol.InstallFonts := True;
    LocalFontCol.OnFindObject := DirectFindObject;

    Renderer := TPDFRenderer.Create(LocalFontCol);
    try
      Renderer.DPI := DPI;
      Renderer.CropType := RenderCropType;
      Renderer.OCGStateList := OCGStateList;
      Renderer.PageDict := PageDictFromRef(PageRef);
      Renderer.OnFindObject := DirectFindObject;
      if SmartInfo.Crypt.Encrypted = spEncrypted then
      begin
        Renderer.OnDecrypt := RendererDecrypt;
        Renderer.OnEncrypt := RendererEncrypt;
      end;
      Renderer.Destination := rdDPLR;
      Renderer.SetDPLRTarget(DPLRFileName, TargetDC, ErasePage, OffsetX, OffsetY);
      Renderer.SetDeviceContextTarget(TargetDC, ErasePage, OffsetX, OffsetY);
      Renderer.Render;
      RenderError := Renderer.ErrorDesc;
    finally
      Renderer.Free;
      LocalFontCol.Free;
    end;
  finally
    TempStruct.Free;
    FTempStruct := nil;
  end;
end;
{$ENDIF}

procedure TSmartPDFDocument.RenderPageToDC(PageRef: TPDFIndRef; DPI: Double;
  JPEGQuality: Integer; GDIPlusSettings: TGDIPlusSettings; TargetDC: HDC;
  var RenderError: AnsiString; RenderCropType, OffsetX, OffsetY: Integer; ErasePage: Boolean;
  OCGStateList: TQPLOCGStateList);
var
  Renderer: TPDFRenderer;
  TempStruct: TPDFStructure;
  LocalFontCol: TPDFFontCollection;
begin
  TempStruct := TPDFStructure.Create;
  try
    FTempStruct := TempStruct;

    LocalFontCol := TPDFFontCollection.Create;
    LocalFontCol.InstallFonts := True;
    LocalFontCol.OnFindObject := DirectFindObject;

    Renderer := TPDFRenderer.Create(LocalFontCol);
    try
      Renderer.GDIPlusSettings := GDIPlusSettings;
      Renderer.DPI := DPI;
      Renderer.CropType := RenderCropType;
      Renderer.OCGStateList := OCGStateList;
      Renderer.PageDict := PageDictFromRef(PageRef);
      Renderer.OnFindObject := DirectFindObject;
      if SmartInfo.Crypt.Encrypted = spEncrypted then
      begin
        Renderer.OnDecrypt := RendererDecrypt;
        Renderer.OnEncrypt := RendererEncrypt;
      end;
      Renderer.Destination := rdDeviceContext;
      Renderer.SetDeviceContextTarget(TargetDC, ErasePage, OffsetX, OffsetY);
      Renderer.Render;
      RenderError := Renderer.ErrorDesc;
    finally
      Renderer.Free;
      LocalFontCol.Free;
    end;
  finally
    TempStruct.Free;
    FTempStruct := nil;
  end;
end;

{$IFDEF QPL_DPLR}
procedure TSmartPDFDocument.RenderPageToDPLRStream(PageRef: TPDFIndRef;
  Options: Integer; DPI: Double; JPEGQuality: Integer;
  const DPLRFileName: WideString; Target: TStream; var RenderError: AnsiString;
  OCGStateList: TQPLOCGStateList);
var
  Renderer: TPDFRenderer;
  TempStruct: TPDFStructure;
  JI: TPDFJPEGImage;
  PW: TPNGWriter;
  GW: TPDFGIFWriter;
  PPM: Integer;
  LocalFontCol: TPDFFontCollection;
  TempGDIPlusSettings: TGDIPlusSettings;
begin
  TempStruct := TPDFStructure.Create;
  try
    FTempStruct := TempStruct;

    LocalFontCol := TPDFFontCollection.Create;
    LocalFontCol.InstallFonts := True;
    LocalFontCol.OnFindObject := DirectFindObject;

    Renderer := TPDFRenderer.Create(LocalFontCol);
    try
      Renderer.DPI := DPI;
      Renderer.OCGStateList := OCGStateList;
      Renderer.PageDict := PageDictFromRef(PageRef);
      Renderer.OnFindObject := DirectFindObject;
      if SmartInfo.Crypt.Encrypted = spEncrypted then
      begin
        Renderer.OnDecrypt := RendererDecrypt;
        Renderer.OnEncrypt := RendererEncrypt;
      end;
      case Options of
        2: Renderer.Destination := rdWMF;
        3: Renderer.Destination := rdEMF;
        4: Renderer.Destination := rdEPS;
        8: Renderer.Destination := rdEMFPlus;
        9: Renderer.Destination := rdHTML5;
      else
        Renderer.Destination := rdDPLRBitmap;
        Renderer.SetDPLRTarget(DPLRFileName, 0, True, 0, 0);
      end;
      if Options = 8 then
      begin
        Renderer.SetEMFPlusTarget(Target);
      end else
      if Options = 9 then
      begin
        Renderer.SetHTML5Target(Target);
      end;
      Renderer.Render;
      RenderError := Renderer.ErrorDesc;
      if Options = 0 then
      begin
        Renderer.Bitmap.SaveToStream(Target);
        Target.Seek($26, soBeginning);
        PPM := Trunc((DPI * 1000) / 25.4);
        Target.Write(PPM, 4);
        Target.Write(PPM, 4);
      end else
      if Options = 1 then
      begin
        JI := TPDFJPEGImage.Create;
        try
          JI.LoadFromBitmap(Renderer.Bitmap);
          JI.CompressionQuality := JPEGQuality;
          JI.DPI := Round(DPI);
          JI.SaveToStream(Target);
        finally
          JI.Free;
        end;
      end else
      if Options = 2 then
      begin
        Renderer.Metafile.SaveToStream(Target);
      end else
      if Options = 3 then
      begin
        Renderer.Metafile.SaveToStream(Target);
      end else
      if Options = 4 then
      begin
        Renderer.EPS.SaveToStream(Target);
      end else
      if Options = 5 then
      begin
        PW := TPNGWriter.Create(Renderer.Bitmap);
        try
          PW.SetDPI(Round(DPI));
          PW.SaveToStream(Target);
        finally
          PW.Free;
        end;
      end else
      if Options = 6 then
      begin
        GW := TPDFGIFWriter.Create;
        try
          GW.Assign(Renderer.Bitmap);
          GW.SaveToStream(Target);
        finally
          GW.Free;
        end;
      end else
      if Options = 7 then
      begin
        DefaultGDIPlusSettings(TempGDIPlusSettings);
        ConvertBitmapToTIFF(Renderer.Bitmap, Target, TempGDIPlusSettings, DPI);
      end else
      if Options = 8 then
      begin
        // EMFPlus written directly to the stream
      end else
      if Options = 9 then
      begin
        // HTML5 written directly to the stream
      end else
      if Options = 10 then
      begin
        DefaultGDIPlusSettings(TempGDIPlusSettings);
        ConvertBitmapToG4TIFF(Renderer.Bitmap, Target, TempGDIPlusSettings, DPI);
      end;
    finally
      LocalFontCol.Free;
      Renderer.Free;
    end;
  finally
    TempStruct.Free;
    FTempStruct := nil;
  end;
end;
{$ENDIF}

procedure TSmartPDFDocument.RenderPageToPrinter(QPLPrinter: TQPLPrinter;
  StartPage, EndPage, Options: Integer; GDIPlusSettings: TGDIPlusSettings);
var
  Renderer: TPDFRenderer;
  TempStruct: TPDFStructure;
  DPI: Integer;
  PO: TPDFPrintOptions;
  Page: Integer;
  LocalFontCol: TPDFFontCollection;
begin
  DPI := QPLPrinter.Canvas.Font.PixelsPerInch;
  TempStruct := TPDFStructure.Create;
  try
    FTempStruct := TempStruct;

    LocalFontCol := TPDFFontCollection.Create;
    LocalFontCol.InstallFonts := True;
    LocalFontCol.OnFindObject := DirectFindObject;

    Renderer := TPDFRenderer.Create(LocalFontCol);
    try
      Renderer.GDIPlusSettings := GDIPlusSettings;
      Renderer.DPI := DPI;

      PO.PageScaling := psNone;
      if Options and $F = 1 then PO.PageScaling := psFitToPaper;
      if Options and $F = 2 then PO.PageScaling := psShrinkLargePages;
      PO.AutoRotateCenter := Options and $10 = $10;
      Renderer.PrintOptions := PO;
      Renderer.Destination := rdPrinter;
      Renderer.QPLPrinter := QPLPrinter;
      Renderer.OnFindObject := DirectFindObject;
      if SmartInfo.Crypt.Encrypted = spEncrypted then
      begin
        Renderer.OnDecrypt := RendererDecrypt;
        Renderer.OnEncrypt := RendererEncrypt;
      end;

      for Page := StartPage to EndPage do
      begin
        if Page > StartPage then QPLPrinter.NewPage;
        Renderer.PageDict := FindPageDict(Page);
        Renderer.Render;
      end;
    finally
      Renderer.Free;
      LocalFontCol.Free;
    end;
  finally
    TempStruct.Free;
    FTempStruct := nil;
  end;
end;

function TSmartPDFDocument.GetFieldValue(FieldRef: TPDFIndRef): WideString;
var
  Obj: TPDFObject;
  IR: TPDFIndRef;
  FieldDict: TPDFDictionary;
begin
  Result := '';
  Obj := GetObject(FieldRef.ObjNum);
  if Obj is TPDFDictionary then
  begin
    IR := FieldRef;
    FieldDict := TPDFDictionary(Obj);
    Obj := ReadInheritedValue(FieldDict, 'V');
    if Obj is TPDFIndRef then
    begin
      IR := TPDFIndRef(Obj);
      Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
    end;
    if Obj is TPDFString then
    begin
      if (FSmartInfo.Crypt.Encrypted = spEncrypted) and (not FReader.IsCompact(IR.ObjNum)) then
      begin
        FSmartInfo.Crypt.DecryptObject(FSmartInfo.Crypt.MakeKey(IR.ObjNum, IR.GenNum), Obj);
        Result := Result + TPDFString(Obj).AsTextString;
        FSmartInfo.Crypt.EncryptObject(FSmartInfo.Crypt.MakeKey(IR.ObjNum, IR.GenNum), Obj);
      end else
        Result := TPDFString(Obj).AsTextString;
    end;
  end;
end;

function TSmartPDFDocument.ReadInheritedValue(Dict: TPDFDictionary;
  const Key: AnsiString): TPDFObject;
var
  Obj: TPDFObject;
  HasParent: Boolean;
  IR: TPDFIndRef;
begin
  Result := nil;
  HasParent := False;
  if Assigned(Dict) then
  begin
    repeat
      Result := Dict.FindValueByKeyName(Key);
      if not Assigned(Result) then
      begin
        HasParent := False;
        Obj := Dict.FindValueByKeyName('Parent');
        if Obj is TPDFIndRef then
        begin
          IR := TPDFIndRef(Obj);
          HasParent := True;
          Obj := GetObject(IR.ObjNum);
          if Obj is TPDFDictionary then
            Dict := TPDFDictionary(Obj)
          else
            HasParent := False;
        end;
      end;
    until Assigned(Result) or (not HasParent);
  end;
end;

function TSmartPDFDocument.ReleaseImageList(ImageList: TPDFImageList): Boolean;
var
  X: Integer;
  FoundIndex: Integer;
begin
  X := 0;
  FoundIndex := -1;
  while ((X < Length(FImageListArray)) and (FoundIndex < 0)) do
  begin
    if (FImageListArray[X] = ImageList) then
    begin
      FoundIndex := X;
    end else
    begin
      Inc(X);
    end;
  end;
  if (FoundIndex >= 0) then
  begin
    Result := True;
    FImageListArray[FoundIndex].Free;
    for X := FoundIndex to Length(FImageListArray) - 2 do
    begin
      FImageListArray[X] := FImageListArray[X + 1];
    end;
    SetLength(FImageListArray, Length(FImageListArray) - 1);
  end else
  begin
    Result := False;
  end;
end;

function TSmartPDFDocument.RemoveUsageRights: Boolean;
var
  Obj: TPDFObject;
  PermsDict: TPDFDictionary;
  ChangeRef: TPDFIndRef;
  ChangeObj: TPDFObject;
begin
  Result := False;
  if Assigned(FRootDict) then
  begin
    ChangeRef := FRootRef;
    ChangeObj := FRootDict;
    Obj := FRootDict.FindValueByKeyName('Perms', False);
    if Obj is TPDFIndRef then
    begin
      ChangeRef := TPDFIndRef(Obj);
      Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
      ChangeObj := Obj;
    end;
    if Obj is TPDFDictionary then
    begin
      Result := True;
      PermsDict := TPDFDictionary(Obj);

      PermsDict.DeleteEntryByKeyName('UR');
      PermsDict.DeleteEntryByKeyName('UR3');

      ChangeObject(ChangeRef.ObjNum, ChangeObj);

      if PermsDict.Count = 0 then
      begin
        FRootDict.DeleteEntryByKeyName('Perms');
        ChangeObject(FRootRef.ObjNum, FRootDict);
      end;
    end;
  end;
end;

function TSmartPDFDocument.SetPageMode(NewMode: TPDFDAPageMode): Boolean;
var
  S: AnsiString;
begin
  Result := False;
  if Assigned(FRootDict) then
  begin
    RootDict.PurgeKey('PageMode');
    case NewMode of
      pmUseNone: S := 'UseNone';
      pmUseOutlines: S := 'UseOutlines';
      pmUseThumbs: S := 'UseThumbs';
      pmFullScreen: S := 'FullScreen';
      pmUseOC: S := 'UseOC';
      pmUseAttachments: S := 'UseAttachments';
    end;

    if (Length(S) <> 0) then
      RootDict.Add('PageMode', FLocalStructure.NewName(S));
    ChangeObject(FRootRef.ObjNum, FRootDict);
    Result := True;
  end;
end;

function TSmartPDFDocument.SetPageLayout(NewLayout: TPDFDAPageLayout): Boolean;
var
  S: AnsiString;
begin
  Result := False;
  if Assigned(FRootDict) then
  begin
    FRootDict.PurgeKey('PageLayout');
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
    end;
    if (Length(S) <> 0) then
        FRootDict.Add('PageLayout', FLocalStructure.NewName(S));
    ChangeObject(FRootRef.ObjNum, FRootDict);
    Result := True;
  end;
end;

function TSmartPDFDocument.HasOutline: Boolean;
var
  Obj: TPDFObject;
  OutlinesDictionary: TPDFDictionary;
begin
  Result := False;
  Obj := FRootDict.FindValueByKeyName('Outlines');
  if Obj is TPDFIndRef then
  begin
    Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
    if Obj is TPDFDictionary then
    begin
      OutlinesDictionary := TPDFDictionary(Obj);
      Result := (OutlinesDictionary.FindValueByKeyName('First') is TPDFIndRef)
        and (OutlinesDictionary.FindValueByKeyName('First') is TPDFIndRef);
    end;
  end;
end;

function TSmartPDFDocument.GetOutlineRef: TPDFIndRef;
var
  Obj: TPDFObject;
begin
  Result := nil;
  Obj := FRootDict.FindValueByKeyName('Outlines');
  if Obj is TPDFIndRef then
    Result := TPDFIndRef(Obj);
end;

procedure TSmartPDFDocument.SetOutline(OutlineRef: TPDFIndRef; Offset: Integer);
begin
  FRootDict.Add('Outlines', FLocalStructure.NewIndirectRef(
    OutlineRef.ObjNum + Offset, OutlineRef.GenNum));
  ChangeObject(FRootRef.ObjNum, FRootDict);
end;

procedure TSmartPDFDocument.GetTopLevelOutlines(List: TObjectList);
var
  OutlineDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  OutlineDict := GetOutlineDict;
  if Assigned(OutlineDict) then
  begin
    Obj := OutlineDict.FindValueByKeyName('First');
    while Obj is TPDFIndRef do
    begin
      List.Add(Obj);
      Obj := FReader.GetObject(TPDFIndRef(Obj).ObjNum);
      if Obj is TPDFDictionary then
      begin
        Obj := TPDFDictionary(Obj).FindValueByKeyName('Next');
      end;
    end;
  end;
end;

function TSmartPDFDocument.GetViewOCGList: TQPLOCGStateList;
begin
  SetLength(Result, 0);
end;

function TSmartPDFDocument.GetOutlineDict: TPDFDictionary;
var
  Ref: TPDFindRef;
  Obj: TPDFObject;
begin
  Result := nil;
  Ref := GetOutlineRef;
  if Assigned(Ref) then
  begin
    Obj := FReader.GetObject(Ref.ObjNum);
    if Obj is TPDFDictionary then
    begin
      Result := TPDFDictionary(Obj);
    end;
  end;
end;

procedure TSmartPDFDocument.SetOutlineParent(List: TObjectList;
  NewParentObjNum, NewParentGenNum: Integer);
var
  X: Integer;
  OutlineDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  for X := 0 to List.Count - 1 do
  begin
    if List[X] is TPDFIndRef then
    begin
      Obj := FReader.GetObject(TPDFIndRef(List[X]).ObjNum);
      if Obj is TPDFDictionary then
      begin
        OutlineDict := TPDFDictionary(Obj);
        Obj := OutlineDict.FindValueByKeyName('Parent');
        if Obj is TPDFIndRef then
        begin
          TPDFIndRef(Obj).ObjNum := NewParentObjNum;
          TPDFIndRef(Obj).GenNum := NewParentGenNum;
          ChangeObject(TPDFIndRef(List[X]).ObjNum, OutlineDict);
        end;
      end;
    end;
  end;
end;

procedure TSmartPDFDocument.AppendOutline(Source: TSmartPDFDocument; Offset: Integer);
var
  List: TObjectList;
  Ref: TPDFIndRef;
  FirstDict: TPDFDictionary;
  FirstRef: TPDFIndRef;
  LastRef: TPDFIndRef;
  LastDict: TPDFDictionary;
  SourceOutlineDict: TPDFDictionary;
  Obj: TPDFObject;
  SourceCount: Integer;
  OutlineDict: TPDFDictionary;
begin
  // Set the /Parent key of the second (source) document's root outline entries
  List := TObjectList.Create;
  try
    List.OwnsObjects := False;
    Source.GetTopLevelOutlines(List);
    Ref := GetOutlineRef;
    Source.SetOutlineParent(List, Ref.ObjNum - Offset, Ref.GenNum);
  finally
    List.Free;
  end;

  List := TObjectList.Create;
  try
    // Set the /Prev key of the /First outline item in the second (source) document
    // to point to the last top level outline items of the first document
    List.OwnsObjects := False;
    GetTopLevelOutlines(List);
    if (List.Count > 0) then
    begin
      LastRef := TPDFIndRef(List[List.Count - 1]);
      FirstDict := Source.GetNamedOutlineDict('First');
      FirstRef := Source.GetNamedOutlineRef('First');
      FirstDict.Add('Prev', Source.FLocalStructure.NewIndirectRef(LastRef.ObjNum - Offset, LastRef.GenNum));
      Source.ChangeObject(FirstRef.ObjNum, FirstDict);

      // Set the /Next key of the last top level outline item in the first document
      // to point to the /First entry of the first document
      Obj := FindObject(LastRef);
      if (Obj is TPDFDictionary) then
      begin
        LastDict := TPDFDictionary(Obj);
        LastDict.Add('Next', FLocalStructure.NewIndirectRef(FirstRef.ObjNum + Offset, FirstRef.GenNum));
        ChangeObject(LastRef.ObjNum, LastDict);
      end;
    end;
  finally
    List.Free;
  end;

  // Update the /Count entry in the first document
  SourceCount := 0;
  SourceOutlineDict := Source.GetOutlineDict;
  if Assigned(SourceOutlineDict) then
  begin
    Obj := SourceOutlineDict.FindValueByKeyName('Count');
    if Obj is TPDFNumeric then
      SourceCount := TPDFNumeric(Obj).AsInteger;
  end;
  OutlineDict := GetOutlineDict;
  if Assigned(OutlineDict) then
  begin
    Obj := OutlineDict.FindValueByKeyName('Count');
    if Obj is TPDFNumeric then
    begin
      TPDFNumeric(Obj).SetTo(TPDFNumeric(Obj).AsInteger + SourceCount);
    end else
    begin
      OutlineDict.Add('Count', FLocalStructure.NewNumeric(SourceCount));
    end;

    // Update the /Last entry in the first document to point to the /Last entry
    // in the second (source) document
    LastRef := Source.GetNamedOutlineRef('Last');
    Obj := OutlineDict.FindValueByKeyName('Last');
    if Obj is TPDFIndRef then
    begin
      TPDFIndRef(Obj).ObjNum := LastRef.ObjNum + Offset;
      TPDFIndRef(Obj).GenNum := LastRef.GenNum;      
    end;

    // Mark the outline dictionary as changed
    ChangeObject(GetOutlineRef.ObjNum, OutlineDict);
  end;
end;

function TSmartPDFDocument.GetNamedOutlineDict(
  const Key: AnsiString): TPDFDictionary;
var
  Ref: TPDFIndRef;
  Obj: TPDFObject;
begin
  Result := nil;
  Ref := GetNamedOutlineRef(Key);
  if Assigned(Ref) then
  begin
    Obj := FReader.GetObject(Ref.ObjNum);
    if Obj is TPDFDictionary then
      Result := TPDFDictionary(Obj);
  end;
end;

function TSmartPDFDocument.GetNamedOutlineRef(
  const Key: AnsiString): TPDFIndRef;
var
  OutlineDict: TPDFDictionary;
  Obj: TPDFObject;
begin
  Result := nil;
  OutlineDict := GetOutlineDict;
  if Assigned(OutlineDict) then
  begin
    Obj := OutlineDict.FindValueByKeyName(Key);
    if Obj is TPDFIndRef then
      Result := TPDFIndRef(Obj);
  end;
end;

function TSmartPDFDocument.FormNeedAppearances: Boolean;
var
  Obj: TPDFObject;
begin
  Result := False;
  if Assigned(FAcroFormDict) then
  begin
    Obj := FAcroFormDict.FindValueByKeyName('NeedAppearances');
    if Obj is TPDFIndRef then Obj := FindObject(TPDFIndRef(Obj));
    if Obj is TPDFBoolean then
    begin
      Result := TPDFBoolean(Obj).AsBoolean;
    end;
  end;
end;

procedure TSmartPDFDocument.AddAcroForm;
begin
  if not Assigned(FAcroFormDict) then
  begin
    FAcroFormDict := FLocalStructure.NewDictionary;
    FAcroFormRef := NewObject(FAcroFormDict);
    FRootDict.Add('AcroForm', FAcroFormRef);
    ChangeObject(FRootRef.ObjNum, FRootDict);
    FAcroFormDict.Add('Fields', FLocalStructure.NewArray);
    FAcroFormDict.Add('CO', FLocalStructure.NewArray);
    FAcroFormDict.Add('NeedAppearances', FLocalStructure.NewBoolean(False));
  end;
end;

function TSmartPDFDocument.GetAnnotationCount(
  PageRef: TPDFIndRef): Integer;
var
  Obj: TPDFObject;
  PageDict: TPDFDictionary;
begin
  Result := 0;
  PageDict := PageDictFromRef(PageRef);
  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('Annots');
    if Obj is TPDFIndRef then
    begin
      Obj := GetObject(TPDFIndRef(Obj).ObjNum);
    end;
    if Obj is TPDFArray then
    begin
      Result := TPDFArray(Obj).Count;
    end;
  end;
end;

procedure TSmartPDFDocument.SetPageBox(Page: TPDFIndRef; BoxIndex: Integer;
  X1, Y1, X2, Y2: Double);
var
  Obj: TPDFObject;
  PageDict: TPDFDictionary;
  ChangeRef: TPDFIndRef;
  ChangeObj: TPDFObject;
  BoxName: AnsiString;
begin
  case BoxIndex of
    1: BoxName := 'MediaBox';
    2: BoxName := 'CropBox';
    3: BoxName := 'BleedBox';
    4: BoxName := 'TrimBox';
    5: BoxName := 'ArtBox';
  end;

  ChangeRef := Page;
  PageDict := PageDictFromRef(ChangeRef);
  ChangeObj := PageDict;
  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName(BoxName);
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      PageDict.Add(BoxName, Obj);
    end;
    if Obj is TPDFIndRef then
    begin
      ChangeRef := TPDFIndRef(Obj);
      Obj := GetObject(ChangeRef.ObjNum);
      ChangeObj := Obj;
    end;
    if Obj is TPDFArray then
    begin
      if (TPDFArray(Obj).Count = 4) and
        (TPDFArray(Obj).Item[0] is TPDFNumeric) and
        (TPDFArray(Obj).Item[1] is TPDFNumeric) and
        (TPDFArray(Obj).Item[2] is TPDFNumeric) and
        (TPDFArray(Obj).Item[3] is TPDFNumeric) then
      begin
        TPDFNumeric(TPDFArray(Obj).Item[0]).SetTo(X1);
        TPDFNumeric(TPDFArray(Obj).Item[1]).SetTo(Y1);
        TPDFNumeric(TPDFArray(Obj).Item[2]).SetTo(X2);
        TPDFNumeric(TPDFArray(Obj).Item[3]).SetTo(Y2);
      end else
      begin
        TPDFArray(Obj).Clear;
        TPDFArray(Obj).Add(FLocalStructure.NewNumeric(X1));
        TPDFArray(Obj).Add(FLocalStructure.NewNumeric(Y1));
        TPDFArray(Obj).Add(FLocalStructure.NewNumeric(X2));
        TPDFArray(Obj).Add(FLocalStructure.NewNumeric(Y2));
      end;
    end;
    ChangeObject(ChangeRef.ObjNum, ChangeObj);
  end;
end;

function TSmartPDFDocument.HasPageBox(Page: TPDFIndRef;
  BoxIndex: Integer): Boolean;
var
  Obj: TPDFObject;
  PageDict: TPDFDictionary;
  BoxName: AnsiString;
begin
  Result := False;

  case BoxIndex of
    1: BoxName := 'MediaBox';
    2: BoxName := 'CropBox';
    3: BoxName := 'BleedBox';
    4: BoxName := 'TrimBox';
    5: BoxName := 'ArtBox';
  end;

  PageDict := PageDictFromRef(Page);
  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName(BoxName);
    if Assigned(Obj) then Result := True;
  end;
end;

function TSmartPDFDocument.GetPageBox(Page: TPDFIndRef; BoxIndex: Integer;
  Dimension: TPDFDimension): Double;
var
  Obj: TPDFObject;
  PageDict: TPDFDictionary;
  R: TPDFRectangle;
  BoxName: AnsiString;
begin
  Result := 0;

  case BoxIndex of
    1: BoxName := 'MediaBox';
    2: BoxName := 'CropBox';
    3: BoxName := 'BleedBox';
    4: BoxName := 'TrimBox';
    5: BoxName := 'ArtBox';
  end;

  PageDict := PageDictFromRef(Page);
  if Assigned(PageDict) then
  begin
    if BoxName = 'MediaBox' then
    begin
      Obj := GetInheritedValue(PageDict, 'MediaBox');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    end else
    if BoxName = 'CropBox' then
    begin
      Obj := GetInheritedValue(PageDict, 'CropBox');
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if not Assigned(Obj) then
      begin
        Obj := GetInheritedValue(PageDict, 'MediaBox');
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      end;
    end else
    begin
      Obj := GetInheritedValue(PageDict, BoxName);
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if not Assigned(Obj) then
      begin
        Obj := GetInheritedValue(PageDict, 'CropBox');
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      end;
      if not Assigned(Obj) then
      begin
        Obj := GetInheritedValue(PageDict, 'MediaBox');
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      end;
    end;
    if Obj is TPDFArray then
    begin
      R := TPDFRectangle.Create(TPDFArray(Obj));
      try
        if R.IsRectangle then
        begin
          Result := R.GetDimension(Dimension);
        end;
      finally
        R.Free;
      end;
    end;
  end;
end;

procedure TSmartPDFDocument.DrawRotatedCapturedPage(DestPage,
  XObjectRef: TPDFIndRef; PntLeft, PntBottom, PntWidth, PntHeight,
  Angle: Double);
var
  Obj: TPDFObject;
  Ref: TPDFIndRef;
  PageRef: TPDFIndRef;
  PageDict: TPDFDictionary;
  NewStream: TPDFStream;
  XRef: AnsiString;
  BBox: TPDFArray;
  BBoxRect: TPDFRectangle;
  CosA: AnsiString;
  SinA: AnsiString;
  NegSinA: AnsiString;
  RadAngle: Double;
  ContentStream: AnsiString;
  ScaledWidth: Double;
  ScaledHeight: Double;
begin
  RadAngle := DegToRad(Angle);
  CosA := QPLDoubleToStrConst(Cos(RadAngle), 5);
  SinA := QPLDoubleToStrConst(Sin(RadAngle), 5);
  NegSinA := QPLDoubleToStrConst(-Sin(RadAngle), 5);

  NewStream := nil;
  PageRef := DestPage;
  PageDict := PageDictFromRef(PageRef);
  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('Contents');
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      PageDict.Add('Contents', Obj);
      ChangeObject(PageRef.ObjNum, PageDict);
    end;
    if Obj is TPDFArray then
    begin
      NewStream := FLocalStructure.NewStream('');
      TPDFArray(Obj).Add(NewObject(NewStream));
      ChangeObject(PageRef.ObjNum, PageDict);
    end;
    if Obj is TPDFIndRef then
    begin
      Ref := TPDFIndRef(Obj);
      Obj := GetObject(Ref.ObjNum);
      if Obj is TPDFStream then
      begin
        Obj := FLocalStructure.NewArray([Ref]);
        PageDict.Add('Contents', Obj);
        ChangeObject(PageRef.ObjNum, PageDict);
        NewStream := FLocalStructure.NewStream('');
        TPDFArray(Obj).Add(NewObject(NewStream));
      end else
      if Obj is TPDFArray then
      begin
        NewStream := FLocalStructure.NewStream('');
        TPDFArray(Obj).Add(NewObject(NewStream));
        ChangeObject(Ref.ObjNum, Obj);
      end;
    end;
  end;
  if Assigned(NewStream) then
  begin
    XRef := UseXObject(XObjectRef, PageRef);
    BBox := XObjectBBox(XObjectRef);
    BBoxRect := TPDFRectangle.Create(BBox);
    try
      if BBoxRect.IsRectangle then
      begin
        ScaledWidth := PntWidth / BBoxRect.Width;
        ScaledHeight := PntHeight / BBoxRect.Height;

        ContentStream := 'q ' + CosA + ' ' + SinA + ' ' + NegSinA + ' ' +
          CosA + ' ' +
          QPLDoubleToStrConst(PntLeft - BBoxRect.Left * ScaledWidth, 5) + ' ' +
          QPLDoubleToStrConst(PntBottom - BBoxRect.Bottom * ScaledHeight, 5) +
          ' cm ' +
          QPLDoubleToStrConst(ScaledWidth, 5) + ' 0 0 ' +
          QPLDoubleToStrConst(ScaledHeight, 5) + ' 0 0 cm ' +
          '/' + XRef + ' Do Q ';

        NewStream.SetTo(ContentStream, False);
      end;
    finally
      BBoxRect.Free;
    end;
  end;
end;

function TSmartPDFDocument.MoveLayer(PageRef: TPDFIndRef; FromLayer, ToLayer:Integer): Boolean;
var
  Obj: TPDFObject;
  Ref: TPDFIndRef;
  PageDict: TPDFDictionary;
begin

  Result := False;
  PageDict := PageDictFromRef(PageRef);

  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('Contents');
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      PageDict.Add('Contents', Obj);
      ChangeObject(PageRef.ObjNum, PageDict);
    end;
    if Obj is TPDFArray then
    begin
      TPDFArray(Obj).Move(FromLayer - 1, ToLayer - 1);
      ChangeObject(PageRef.ObjNum, PageDict);
      Result := True;
    end;
    if Obj is TPDFIndRef then
    begin
      Ref := TPDFIndRef(Obj);
      Obj := GetObject(Ref.ObjNum);
      if Obj is TPDFArray then
      begin
        TPDFArray(Obj).Move(FromLayer - 1, ToLayer - 1);
        ChangeObject(Ref.ObjNum, Obj);
        Result := True;
      end;
    end;
  end;
end;

function TSmartPDFDocument.NewLayer(PageRef: TPDFIndRef): Integer;
var
  Obj: TPDFObject;
  Ref: TPDFIndRef;
  PageDict: TPDFDictionary;
  NewStream: TPDFStream;
begin
  Result := 0;
  PageDict := PageDictFromRef(PageRef);

  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('Contents');
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      PageDict.Add('Contents', Obj);
      ChangeObject(PageRef.ObjNum, PageDict);
      Result := 1;
    end;
    if Obj is TPDFArray then
    begin
      NewStream := FLocalStructure.NewStream('');
      TPDFArray(Obj).Add(NewObject(NewStream));
      ChangeObject(PageRef.ObjNum, PageDict);
      Result := 1;
    end;
    if Obj is TPDFIndRef then
    begin
      Ref := TPDFIndRef(Obj);
      Obj := GetObject(Ref.ObjNum);
      if Obj is TPDFStream then
      begin
        Obj := FLocalStructure.NewArray([Ref]);
        PageDict.Add('Contents', Obj);
        ChangeObject(PageRef.ObjNum, PageDict);
        NewStream := FLocalStructure.NewStream('');
        TPDFArray(Obj).Add(NewObject(NewStream));
        Result := 1;
      end else
      if Obj is TPDFArray then
      begin
        NewStream := FLocalStructure.NewStream('');
        TPDFArray(Obj).Add(NewObject(NewStream));
        ChangeObject(Ref.ObjNum, Obj);
        Result := 1;
      end;
    end;
  end;
end;

function TSmartPDFDocument.SetContentStream(PageRef: TPDFIndRef; Index: Integer; const Source: AnsiString): Boolean;
var
  Obj: TPDFObject;
  Ref: TPDFIndRef;
  PageDict: TPDFDictionary;
  StreamObj: TPDFObject;
begin
  Result := False;
  PageDict := PageDictFromRef(PageRef);

  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('Contents');
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      PageDict.Add('Contents', Obj);
      ChangeObject(PageRef.ObjNum, PageDict);
    end;

    if Obj is TPDFArray then
    begin
      StreamObj := TPDFArray(Obj).Item[Index-1];
      if (StreamObj is TPDFIndRef) then
        StreamObj := GetObject(TPDFIndRef(StreamObj).ObjNum);

      if (StreamObj is TPDFStream) then
      begin
        TPDFStream(StreamObj).SetTo(Source);
        ChangeObject(StreamObj.IndObjNum, StreamObj);
      end;
      //ChangeObject(PageRef.ObjNum, PageDict);   // Should not be needed.
      Result := True;
    end;

    if Obj is TPDFIndRef then
    begin
      Ref := TPDFIndRef(Obj);
      Obj := GetObject(Ref.ObjNum);
      if Obj is TPDFStream then
      begin
        Obj := FLocalStructure.NewArray([Ref]);
        PageDict.Add('Contents', Obj);
        ChangeObject(PageRef.ObjNum, PageDict);

        if (Index = 1) then
        begin
          TPDFStream(Obj).SetTo(Source);
          ChangeObject(Obj.IndObjNum, Obj);
          Result := True;
        end;
      end else
      if Obj is TPDFArray then
      begin
        if (Index >= 1) and (Index <= TPDFArray(Obj).Count) then
        begin
          StreamObj := TPDFArray(Obj).Item[Index-1];
          if (StreamObj is TPDFIndRef) then
            StreamObj := GetObject(TPDFIndRef(StreamObj).ObjNum);

          TPDFStream(StreamObj).SetTo(Source);
          ChangeObject(StreamObj.IndObjNum, StreamObj);
          Result := True;

          // ChangeObject(Ref.ObjNum, Obj);  // Should not be needed.
        end;
      end;
    end;
  end;
end;

function TSmartPDFDocument.ContentStreamCount(PageRef: TPDFIndRef): Integer;
var
  Obj: TPDFObject;
  Ref: TPDFIndRef;
  PageDict: TPDFDictionary;
begin
  Result := 0;
  PageDict := PageDictFromRef(PageRef);

  if Assigned(PageDict) then
  begin
    Obj := PageDict.FindValueByKeyName('Contents');
    if not Assigned(Obj) then
    begin
      Obj := FLocalStructure.NewArray;
      PageDict.Add('Contents', Obj);
      ChangeObject(PageRef.ObjNum, PageDict);
    end;

    if Obj is TPDFArray then
      Result := TPDFArray(Obj).Count;

    if Obj is TPDFIndRef then
    begin
      Ref := TPDFIndRef(Obj);
      Obj := GetObject(Ref.ObjNum);
      if Obj is TPDFStream then
      begin
        Obj := FLocalStructure.NewArray([Ref]);
        PageDict.Add('Contents', Obj);
        ChangeObject(PageRef.ObjNum, PageDict);

        Result := 1;
      end else
      begin
        if Obj is TPDFArray then
          Result := TPDFArray(Obj).Count;
      end;
    end;
  end;
end;



{ TSmartPDFLink }

constructor TSmartPDFLink.Create(InputStream: TStream; const Password: WideString);
begin
  FOpenProblem := '';
  FInfo := nil;
  FReader := nil;
  FDoc := nil;
  FOkay := False;
  FReadOnlyAccess := False;

  FReader := TSmartPDFReader.Create(InputStream);
  if FReader.ErrorCode = ecNone then
  begin
    FInfo := TSmartPDFInfo.Create(FReader, Password);
    if (FInfo.Encrypted = spEncrypted) then
    begin
      if FInfo.CheckPassword(Password) then
      begin
        FOkay := True;
      end else
      begin
        FOpenProblem := 'BadPassword';
      end;
    end else
    if (FInfo.Encrypted = spDecrypted) then
    begin
      FOkay := True;
    end;

    if FOkay then
    begin
      FInfo.Password := Password;
      FDoc := TSmartPDFDocument.Create(FReader);
      FDoc.SmartInfo := FInfo;

      if ((FInfo.Encrypted = spEncrypted) and (FInfo.GetFileID = '')) then
      begin
        FDoc.PartialDecrypt;
        FDoc.SetFileID;
        FInfo.Free;
        FInfo := TSmartPDFInfo.Create(FReader, Password);
        FDoc.SmartInfo := FInfo;
      end;
    end else
    begin
      FInfo.Free;
      FInfo := nil;
      FReader.Free;
      FReader := nil;
    end;
  end else
  begin
    FOpenProblem := 'BadStructure';
    FReader.Free;
    FReader := nil;
  end;
end;

constructor TSmartPDFLink.Create(const InputFile: WideString; const Password: WideString; ReadOnly: Boolean = False);
var
  FileOpenedOkay: Boolean;
begin
  FOpenProblem := '';
  FOkay := False;
  FReadOnlyAccess := False;
  FileOpenedOkay := False;
  if QPLFileExists(InputFile) then
  begin
    try
      if ReadOnly then
      begin
        if QPLCanCreateFileStream(InputFile, fmOpenRead or fmShareDenyWrite) then
        begin
          try
            FInputStream := QPLCreateFileStream(InputFile, fmOpenRead or fmShareDenyWrite);
            FileOpenedOkay := True;
          except
          end;
        end;
      end else
      begin
        if QPLCanCreateFileStream(InputFile, fmOpenReadWrite or fmShareDenyWrite) then
        begin
          try
            FInputStream := QPLCreateFileStream(InputFile, fmOpenReadWrite or fmShareDenyWrite);
            FileOpenedOkay := True;
          except
          end;
        end;
        if not FileOpenedOkay then
        begin
          if QPLCanCreateFileStream(InputFile, fmOpenRead or fmShareDenyWrite) then
          begin
            try
              FInputStream := QPLCreateFileStream(InputFile, fmOpenRead or fmShareDenyWrite);
              FileOpenedOkay := True;
              FReadOnlyAccess := True;
            except
            end;
          end;
        end;
      end;

      if FileOpenedOkay then
      begin
        FInfo := nil;
        FReader := nil;
        FDoc := nil;
        FOkay := False;

        FReader := TSmartPDFReader.Create(FInputStream);
        if FReader.ErrorCode = ecNone then
        begin
          FInfo := TSmartPDFInfo.Create(FReader, Password);

          if (FInfo.Encrypted = spEncrypted) then
          begin
            if FInfo.CheckPassword(Password) then
            begin
              FOkay := True;
            end else
            begin
              FOpenProblem := 'BadPassword';
            end;
          end else
          if (FInfo.Encrypted = spDecrypted) then
          begin
            FOkay := True;
          end;

          if FOkay then
          begin
            FInfo.Password := Password;
            FDoc := TSmartPDFDocument.Create(FReader);
            FDoc.SmartInfo := FInfo;

            if ((FInfo.Encrypted = spEncrypted) and (FInfo.GetFileID = '')) then
            begin
              FDoc.PartialDecrypt;
              FDoc.SetFileID;
              FInfo.Free;
              FInfo := TSmartPDFInfo.Create(FReader, Password);
              FDoc.SmartInfo := FInfo;
            end;
          end else
          begin
            FInfo.Free;
            FInfo := nil;
            FReader.Free;
            FReader := nil
          end;
        end else
        begin
          FOpenProblem := 'BadStructure';
          FReader.Free;
          FReader := nil;
        end;
      end else
      begin
        FOpenProblem := 'CouldNotOpen';
      end;
    except
    end;
  end else
  begin
    FOpenProblem := 'FileNotFound';
  end;
end;

destructor TSmartPDFLink.Destroy;
begin
  if Assigned(FDoc) then FDoc.Free;
  if Assigned(FInfo) then FInfo.Free;
  if Assigned(FReader) then FReader.Free;
  if Assigned(FInputStream) then FInputStream.Free;
  inherited;
end;

end.
