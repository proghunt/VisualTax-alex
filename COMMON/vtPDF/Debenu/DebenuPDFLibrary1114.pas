{ ******************************************************* }
{                                                         }
{  Debenu Quick PDF Library                               }
{  DebenuPDFLibrary1114.pas                               }
{  Copyright © 1999-2015 Debenu Pty Ltd                   }
{                                                         }
{ ******************************************************* }

unit DebenuPDFLibrary1114;

{$I DebenuPDFLibraryDefines.inc}

interface

uses
{$IFNDEF QPL_OS_WINDOWS}
  DebenuPDFLibraryWindows,
{$ELSE}
  Windows,
{$ENDIF}
  DebenuPDFLibraryDocument, DebenuPDFLibraryImage, DebenuPDFLibraryFont, DebenuPDFLibraryPainter,
  DebenuPDFLibraryStructure,
  DebenuPDFLibraryRenderer,
{$IFNDEF VER120}
  contnrs,
{$ENDIF}
  DebenuPDFLibraryExtra,
{$IFDEF QPL_NOVCL}
  DebenuPDFLibraryGraphics,
  DebenuPDFLibraryPrinters,
{$ELSE}
  Vcl.Graphics,
  Vcl.Printers,
{$ENDIF}
{$IFDEF QPL_OS_MAC}
  Types,
  Posix.Unistd,
{$ENDIF}
{$IFDEF QPL_OS_WINDOWS}
{$IFDEF QPL_XE3_HIGHER}
  System.Types,
{$ENDIF}
{$ENDIF}
  DebenuPDFLibrarySmartAccess, DebenuPDFLibraryForm,
  DebenuPDFLibraryTypes, DebenuPDFLibraryLayout, DebenuPDFLibraryImageList, DebenuPDFLibraryTextList,
  DebenuPDFLibraryPicasso, DebenuPDFLibraryDigitalSignatures, Classes;

const
  LibVer: AnsiString = '11.14';
  FullLibVer: AnsiString = '11.14.1.0';
  LibVerNum = 11.14;
  ProductID: AnsiString = 'Debenu Quick PDF Library 11.14 (www.debenu.com)';

type
  TQuickPDF = class
  private
    FDocs: TObjectList;
    FSelDoc: TPDFDocument;
    FSelImage: TPDFImage;
    FSelFont: TPDFFont;
    FUnlocked: Boolean;
    FLastErrorCode: Integer;
    FLicenseInfo: AnsiString;
    FAnalysisInfo: TObjectList;
    FFileLists: TQuickPDFStringList;
    FTempPath: WideString;
    FOpenFiles: TObjectList;
    FOnProgress: TQuickPDFProgressEvent;
    FSubProgressScale: Double;
    FSubProgressOffset: Integer;
    FSubProgressPiece: Integer;
    FSubProgressCount: Integer;
    FLastProgress: Integer;
    FLastRenderError: AnsiString;
    FGDIPlusSettings: TGDIPlusSettings;
    FJPEGQuality: Integer;
    FPrintTitles: TQuickPDFStringList;
    FCustomPrinters: TQuickPDFStringList;
    FKernSupport: TKernSupport;
    FMetafile: TMetafile;
    FMetafileCanvas: TMetafileCanvas;
    FMetafileWidth: Integer;
    FMetafileHeight: Integer;
    FPrintToFile: WideString;
    FPrintPreview: Boolean;
    FPrintPreviewMaxDimension: Integer;
    FPrintPreviewBitmapData: AnsiString;
    FPrinterDevMode: AnsiString;
    FPrinterStatusNeeded: Boolean;
    FPrinterStartPaused: Boolean;
    FPrinterJobID: Integer;
    FPrinterJobPrinterName: AnsiString;
    FCompatibility: AnsiString;
    FDATextExtractOptions: TQPLExtractionOptions;
    FImageLists: TObjectList;
    FRenderDCOffsetX: Integer;
    FRenderDCOffsetY: Integer;
    FRenderDCErasePage: Boolean;
    FRenderScale: Double;
    FFindImagesMode: Integer;
    FNoEmbedFontList: TQuickPDFStringList;
    FRenderCropType: Integer;
    FStringLists: TObjectList;
    FIntCasts: TObjectList;
    FSignProcessList: TObjectList;
    FTextBlockLists: TObjectList;
    FPrinter: TPrinter;
    FAppendInput: AnsiString;
    FDefaultDecodeMode: Integer;
{$IFDEF QPL_OS_WINDOWS}
    FNeedCoUninit: Boolean;
{$ENDIF}
{$IFDEF QPL_CAIRO}
    FCairoFileName: WideString;
    FUseCairo: Boolean;
{$ENDIF}
{$IFDEF QPL_DPLR}
    FDPLRFileName: WideString;
    FUseDPLR: Boolean;
{$ENDIF}

    function TranslateX(XPos: Double): Double;
    function TranslateY(YPos: Double): Double;
    function GetScale(Dist: Double): Double;
    function CopyFile(const Source, Target: WideString): Boolean;
    function FixWideDelimited(const Text, Delimiter: WideString): WideString;
    function ValidFileHandle(FileHandle: Integer): TSmartPDFLink;
    function ValidCaptureID(CaptureID: Integer): TPDFCapturedPage;
    function ValidDACaptureID(CaptureID: Integer): TPDFIndRef;
    function ValidOCG(OptionalContentGroupID: Integer): TPDFIndRef;
    function ValidOutlineID(OutlineID: Integer): TPDFIndRef;
    function ValidActionID(ActionID: Integer): TPDFDictionary;
    function GetDestArray(DestID: Integer): TPDFArray;
    function ValidPageRef(Link: TSmartPDFLink; PageRef: Integer): TPDFIndRef;
    function ValidFontID(FontID: Integer): TPDFFont;
    function ValidDocumentID(DocumentID: Integer): TPDFDocument;
    function ValidImageID(ImageID: Integer): TPDFImage;
    function ValidTableID(TableID: Integer): TPDFTable;
    function ValidMeasureDictID(MeasureDictID: Integer): TPDFDictionary;
    function ValidCSDictID(CSDictID: Integer): TPDFDictionary;
    function ValidAnalysisID(AnalysisID: Integer): TQuickPDFStringList;
    function ValidImageListID(Link: TSmartPDFLink; ImageListID: Integer): TPDFImageList;
    function ValidDATextBlockListID(TextBlockListID: Integer): TPDFTextList;
    function ValidTextBlockListID(TextBlockListID: Integer): TPDFTextList;
    function ValidViewPortID(ViewPortID: Integer): TPDFDictionary;
    function ValidSignProcessID(SignProcessID: Integer): TQuickPDFSignProcess;
    procedure CheckFontSelection;
    procedure SubProgress(Progress: Integer);
    procedure EndProgress;
    function IntCast(VCLObj: TObject): Integer;
    function IntUncast(IntCast: Integer): TObject;
    function ValidPrinterName(const PrinterName: WideString): Boolean;
    function UpdateFlatten(Index: Integer; Update: Boolean): Integer;
    function GetPrinter: TPrinter;
  protected
    PNGTransparencyColor: TColor;
    HasPNGTransparency: Boolean;
    function FindFormField(Index: Integer): TPDFField;
    function MinTW: Double;
    function CheckCompatibility(CompatibilityItem: Integer): Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    // Library
    function LibraryVersion: WideString;
    function LibraryVersionEx: WideString;
    function Unlocked: Integer;
    function LicenseInfo: WideString;
    function LastErrorCode: Integer;
    //function ToPDFUnicode(const Input: WideString): AnsiString;
    function SetTempPath(const NewPath: WideString): Integer;
    function GetTempPath: WideString;
    function TestTempPath: Integer;
    function UnlockKey(const LicenseKey: WideString): Integer;
    function SetCompatibility(CompatibilityItem, CompatibilityMode: Integer): Integer;

    // Document management
    function DocumentCount: Integer;
    function GetDocumentID(Index: Integer): Integer;
    function SelectedDocument: Integer;
    function SelectDocument(DocumentID: Integer): Integer;
    function RemoveDocument(DocumentID: Integer): Integer;
    function NewDocument: Integer;
    function LoadFromFile(const FileName, Password: WideString): Integer;
    function LoadFromStream(InStream: TStream; const Password: WideString): Integer;
    function LoadFromString(const Source: AnsiString; const Password: WideString): Integer;
    function LoadFromCanvasDC(DPI: Double; Options: Integer): Integer;
    function NoEmbedFontListCount: Integer;
    function NoEmbedFontListAdd(const FontName: WideString): Integer;
    function NoEmbedFontListGet(Index: Integer): WideString;
    function NoEmbedFontListRemoveIndex(Index: Integer): Integer;
    function NoEmbedFontListRemoveName(const FontName: WideString): Integer;
    function NoEmbedFontListRemoveAll: Integer;
    function SaveToFile(const FileName: WideString): Integer;
    function SaveToString: AnsiString;
    function SaveToStream(OutStream: TStream): Integer;
    function AppendToFile(const FileName: WideString): Integer;
    function SetAppendInputFromString(const Source: AnsiString): Integer;
    function AppendToString(AppendMode: Integer): AnsiString;
    function CompressContent: Integer;
    function CompressPage: Integer;
    function IsLinearized: Integer;
    function MergeDocument(DocumentID: Integer): Integer;
    function SetTempFile(const FileName: WideString): Integer;
    function SetJavaScriptMode(JSMode: Integer): Integer;
    function CheckObjects: Integer;
    function GetDocumentIdentifier(Part, Options: Integer): WideString;
    function GetDocumentFileName: WideString;
    function GetDocumentFileSize: Integer;
    function GetDocumentRepaired: Integer;
    function BalancePageTree(Options: Integer): Integer;

    // Encryption
    function EncryptionAlgorithm: Integer;
    function EncryptionStatus: Integer;
    function EncryptionStrength: Integer;
    function Encrypt(const Owner, User: WideString; Strength, Permissions: Integer): Integer;
    function Decrypt: Integer;
    function EncodePermissions(CanPrint, CanCopy, CanChange, CanAddNotes,
      CanFillFields, CanCopyAccess, CanAssemble, CanPrintFull: Integer): Integer;
    function SecurityInfo(SecurityItem: Integer): Integer;
    function GetEncryptionFingerprint: WideString;
    function EncryptWithFingerprint(const Fingerprint: WideString): Integer;
    function CheckPassword(const Password: WideString): Integer;

    // Document properties
    function SetInformation(Key: Integer; const NewValue: WideString): Integer;
    function GetInformation(Key: Integer): WideString;
    function SetPageMode(NewPageMode: Integer): Integer;
    function GetPageMode: Integer;
    function SetPageLayout(NewPageLayout: Integer): Integer;
    function GetPageLayout: Integer;
    function SetViewerPreferences(Option, NewValue: Integer): Integer;
    function GetViewerPreferences(Option: Integer): Integer;
    function SetOpenActionMenu(const MenuItem: WideString): Integer;
    function SetOpenActionDestination(OpenPage, Zoom: Integer): Integer;
    function SetOpenActionDestinationFull(OpenPage, Zoom, DestType: Integer;
      Left, Top, Right, Bottom: Double): Integer;
    function GetOpenActionDestination: Integer;
    function SetOpenActionJavaScript(const JavaScript: WideString): Integer;
    function GetOpenActionJavaScript: WideString;
    function RemoveOpenAction: Integer;
    function HasFontResources: Integer;
    function GetDocumentResourceList: WideString;
    function SetCustomInformation(const Key, NewValue: WideString): Integer;
    function GetCustomInformation(const Key: WideString): WideString;
    function RemoveCustomInformation(const Key: WideString): Integer;
    function SetCatalogInformation(const Key, NewValue: WideString): Integer;
    function GetCatalogInformation(const Key: WideString): WideString;
    function StoreCustomDataFromString(const Key, NewValue: AnsiString; Location, Options: Integer): Integer;
    function RetrieveCustomDataToString(const Key: AnsiString; Location: Integer): AnsiString;
    function StoreCustomDataFromFile(const Key, FileName: WideString; Location, Options: Integer): Integer;
    function RetrieveCustomDataToFile(const Key, FileName: WideString; Location: Integer): Integer;
    function GetCustomKeys(Location: Integer): WideString;
    function DocJavaScriptAction(const ActionType, JavaScript: WideString): Integer;
    function GetDocJavaScript(const ActionType: WideString): WideString;
    function AddGlobalJavaScript(const PackageName, JavaScript: WideString): Integer;
    function GetGlobalJavaScript(const PackageName: WideString): WideString;
    function RemoveGlobalJavaScript(const PackageName: WideString): Integer;
    function GlobalJavaScriptCount: Integer;
    function GlobalJavaScriptPackageName(Index: Integer): WideString;
    function SetBaseURL(const NewBaseURL: WideString): Integer;
    function GetBaseURL: WideString;
    function GetObjectCount: Integer;
    function GetMaxObjectNumber: Integer;
    function GetObjectToString(ObjectNumber: Integer): AnsiString;
    function SetObjectFromString(ObjectNumber: Integer; const Source: AnsiString): Integer;
    function GetObjectDecodeError(ObjectNumber: Integer): Integer;
    function CreateNewObject: Integer;
    function IsTaggedPDF: Integer;
    function RemoveUsageRights: Integer;
    function SetPDFAMode(NewMode: Integer): Integer;
    function SetHeaderCommentsFromString(const Source: AnsiString): Integer;
    function SetDecodeMode(NewDecodeMode: Integer): Integer;

    // Embedded files
    function EmbedFile(const Title, FileName, MIMEType: WideString): Integer;
    function AddEmbeddedFile(const FileName, MIMEType: WideString): Integer;
    function AddFileAttachment(const Title: WideString; EmbeddedFileID: Integer): Integer;
    function EmbeddedFileCount: Integer;
    function GetEmbeddedFileStrProperty(Index, Tag: Integer): WideString;
    function GetEmbeddedFileIntProperty(Index, Tag: Integer): Integer;
    function GetEmbeddedFileContentToFile(Index: Integer; const FileName: WideString): Integer;
    function GetEmbeddedFileContentToString(Index: Integer): AnsiString;
    function GetEmbeddedFileContentToStream(Index: Integer; OutStream: TStream): Integer;
    function SetEmbeddedFileStrProperty(Index, Tag: Integer; NewValue: WideString): Integer;
    function RemoveEmbeddedFile(Index: Integer): Integer;
    function GetEmbeddedFileID(Index: Integer): Integer;

    // Metadata
    function SetDocumentMetadata(const XMP: WideString): Integer;
    function GetDocumentMetadata: WideString;

    // Misc
    function NewPostScriptXObject(const PS: WideString): Integer;
    function SetTextExtractionWordGap(NewWordGap: Double): Integer;
    function SetTextExtractionOptions(OptionID, NewValue: Integer): Integer;
    function SetTextExtractionArea(Left, Top, Width, Height: Double): Integer;
    function SetTextExtractionScaling(Options: Integer; Horizontal, Vertical: Double): Integer;
    function GetStringListCount(StringListID: Integer): Integer;
    function GetStringListItem(StringListID, ItemIndex: Integer): WideString;
    function ReleaseStringList(StringListID: Integer): Integer;

    // Text extraction
    function GetPageText(ExtractOptions: Integer): WideString;
    function ExtractPageTextBlocks(ExtractOptions: Integer): Integer;
    function GetTextBlockCount(TextBlockListID: Integer): Integer;
    function GetTextBlockFontName(TextBlockListID, Index: Integer): WideString;
    function GetTextBlockFontSize(TextBlockListID, Index: Integer): Double;
    function GetTextBlockBound(TextBlockListID, Index, BoundIndex: Integer): Double;
    function GetTextBlockColorType(TextBlockListID, Index: Integer): Integer;
    function GetTextBlockColor(TextBlockListID, Index, ColorComponent: Integer): Double;
    function GetTextBlockText(TextBlockListID, Index: Integer): WideString;
    function GetTextBlockCharWidth(TextBlockListID, Index, CharIndex: Integer): Double;
    function GetTextBlockAsString(TextBlockListID, Index: Integer): WideString;
    function ReleaseTextBlocks(TextBlockListID: Integer): Integer;

    // Page management
    function PageCount: Integer;
    function SelectedPage: Integer;
    function SelectPage(PageNumber: Integer): Integer;
    function NewPage: Integer;
    function NewPageFromCanvasDC(DPI: Double; Options: Integer): Integer;
    function ClonePages(StartPage, EndPage, RepeatCount: Integer): Integer;
    function NewPages(PageCount: Integer): Integer;
    function InsertPages(StartPage, PageCount: Integer): Integer;
    function DeletePages(StartPage, PageCount: Integer): Integer;
    function ExtractPages(StartPage, PageCount: Integer): Integer;
    function ExtractPageRanges(const RangeList: WideString): Integer;
    function CopyPageRanges(DocumentID: Integer; const RangeList: WideString): Integer;
    function CopyPageRangesEx(DocumentID: Integer; const RangeList: WideString; Options: Integer): Integer;
    function PageWidth: Double;
    function PageHeight: Double;
    function GetPageUserUnit: Double;
    function SetPageDimensions(NewPageWidth, NewPageHeight: Double): Integer;
    function SetPageSize(const PaperName: WideString): Integer;
    function SetPageUserUnit(UserUnit: Double): Integer;
    function SetCropBox(Left, Top, Width, Height: Double): Integer;
    function GetPageBox(BoxType, Dimension: Integer): Double;
    function SetPageBox(BoxType: Integer; Left, Top, Width, Height: Double): Integer;
    function RemovePageBox(BoxType: Integer): Integer;
    function HasPageBox(BoxType: Integer): Integer;
    function PageRotation: Integer;
    function RotatePage(PageRotation: Integer): Integer;
    function GetPageContentToString: AnsiString;
    function SetPageContentFromString(const Source: AnsiString): Integer;
    function ReplaceTag(const Tag, NewValue: WideString): Integer;
    function SetPageActionMenu(const MenuItem: WideString): Integer;
    function MovePage(NewPosition: Integer): Integer;
    function HidePage: Integer;
    function CapturePage(Page: Integer): Integer;
    function CapturePageEx(Page, Options: Integer): Integer;
    function SetCapturedPageTransparencyGroup(CaptureID, CS, Isolate, Knockout: Integer): Integer;
    function DrawCapturedPage(CaptureID: Integer; Left, Top, Width, Height: Double): Integer;
    function DrawRotatedCapturedPage(CaptureID: Integer; Left, Bottom, Width, Height, Angle: Double): Integer;
    function DrawCapturedPageMatrix(CaptureID: Integer; M11, M12, M21, M22, MDX, MDY: Double): Integer;
    function PageJavaScriptAction(const ActionType, JavaScript: WideString): Integer;
    function GetPageJavaScript(const ActionType: WideString): WideString;
    function SetPageThumbnail: Integer;
    function SetPageTransparencyGroup(CS, Isolate, Knockout: Integer): Integer;
    function SplitPageText(Options: Integer): Integer;
    function AddPageLabels(Start, Style, Offset: Integer; const Prefix: WideString): Integer;
    function GetPageLabel(Page: Integer): WideString;
    function ClearPageLabels: Integer;
    function NormalizePage(NormalizeOptions: Integer): Integer;
    function GetPageViewPortCount: Integer;
    function GetPageViewPortID(Index: Integer): Integer;
    function GetViewPortName(ViewPortID: Integer): WideString;
    function GetViewPortBBox(ViewPortID, Dimension: Integer): Double;
    function GetPageColorSpaces(Options: Integer): WideString;
    function GetPageMetricsToString(StartPage, EndPage, Options: Integer): AnsiString;
    function PageHasFontResources(PageNumber: Integer): Integer;
    function AddPageMatrix(XScale, YScale, XOffset, YOffset: Double): Integer;

    // Geospatial
    function AddLGIDictToPage(const DictContent: WideString): Integer;
    function GetPageLGIDictCount: Integer;
    function GetPageLGIDictContent(DictIndex: Integer): WideString;
    function DeletePageLGIDict(DictIndex: Integer): Integer;
    function GetImageMeasureDict: Integer;
    function GetImagePtDataDict: Integer;
    function SetMeasureDictCoordinateSystem(MeasureDictID, CoordinateSystemID: Integer): Integer;
    function GetMeasureDictCoordinateSystem(MeasureDictID: Integer): Integer;
    function SetMeasureDictBoundsCount(MeasureDictID, NewCount: Integer): Integer;
    function GetMeasureDictBoundsCount(MeasureDictID: Integer): Integer;
    function SetMeasureDictBoundsItem(MeasureDictID, ItemIndex: Integer; NewValue: Double): Integer;
    function GetMeasureDictBoundsItem(MeasureDictID, ItemIndex: Integer): Double;
    function SetMeasureDictPDU(MeasureDictID, LinearUnit, AreaUnit, AngularUnit: Integer): Integer;
    function GetMeasureDictPDU(MeasureDictID, UnitIndex: Integer): Integer;
    function GetMeasureDictGCSDict(MeasureDictID: Integer): Integer;
    function GetMeasureDictDCSDict(MeasureDictID: Integer): Integer;
    function SetMeasureDictGPTSCount(MeasureDictID, NewCount: Integer): Integer;
    function GetMeasureDictGPTSCount(MeasureDictID: Integer): Integer;
    function SetMeasureDictGPTSItem(MeasureDictID, ItemIndex: Integer; NewValue: Double): Integer;
    function GetMeasureDictGPTSItem(MeasureDictID, ItemIndex: Integer): Double;
    function SetMeasureDictLPTSCount(MeasureDictID, NewCount: Integer): Integer;
    function GetMeasureDictLPTSCount(MeasureDictID: Integer): Integer;
    function SetMeasureDictLPTSItem(MeasureDictID, ItemIndex: Integer; NewValue: Double): Integer;
    function GetMeasureDictLPTSItem(MeasureDictID, ItemIndex: Integer): Double;
    function GetCSDictType(CSDictID: Integer): Integer;
    function SetCSDictType(CSDictID, NewDictType: Integer): Integer;
    function GetCSDictEPSG(CSDictID: Integer): Integer;
    function SetCSDictEPSG(CSDictID, NewEPSG: Integer): Integer;
    function GetCSDictWKT(CSDictID: Integer): WideString;
    function SetCSDictWKT(CSDictID: Integer; const NewWKT: WideString): Integer;
    function GetViewPortMeasureDict(ViewPortID: Integer): Integer;
    function GetViewPortPtDataDict(ViewPortID: Integer): Integer;

    // PDF Rendering
    function SelectRenderer(RendererID: Integer): Integer;
    function SelectedRenderer: Integer;
    function SetGDIPlusFileName(const DLLFileName: WideString): Integer;
    function SetGDIPlusOptions(OptionID, NewValue: Integer): Integer;
    function SetRenderOptions(OptionID, NewValue: Integer): Integer;
    function SetJPEGQuality(Quality: Integer): Integer;
    function SetRenderScale(NewScale: Double): Integer;
    function GetRenderScale: Double;
    function RenderDocumentToFile(DPI: Double; StartPage, EndPage, Options: Integer; const FileName: WideString): Integer;
    function RenderPageToStream(DPI: Double; Page, Options: Integer; Target: TStream): Integer;
    function RenderPageToString(DPI: Double; Page, Options: Integer): AnsiString;
    function RenderPageToFile(DPI: Double; Page, Options: Integer; const FileName: WideString): Integer;
    function SetRenderDCOffset(NewOffsetX, NewOffsetY: Integer): Integer;
    function SetRenderDCErasePage(NewErasePage: Integer): Integer;
    function SetRenderCropType(NewCropType: Integer): Integer;
    function CreateRenderer: Integer;
    function DestroyRenderer: Integer;
    function RenderPageToDCClip(DPI: Double; Page: Integer; DC: HDC; const Clip: AnsiString): Integer;
    function RenderPageToDC(DPI: Double; Page: Integer; DC: HDC): Integer;
    function RenderPageToMemory(DPI: Double; Page: Integer; Target: Pointer; Width, Height, BitsPerPixel: Integer): Integer;
    function RenderAsMultipageTIFFToFile(DPI: Double; const PageRanges: WideString; ImageOptions, OutputOptions: Integer; const FileName: WideString): Integer;
    function PrintDocument(const PrinterName: WideString; StartPage, EndPage, Options: Integer): Integer;
    function PrintPages(const PrinterName, PageRanges: WideString; Options: Integer): Integer;
    function PrintDocumentToFile(const PrinterName: WideString; StartPage, EndPage, Options: Integer; const FileName: WideString): Integer;
    function PrintPagesToFile(const PrinterName, PageRanges: WideString; Options: Integer; const FileName: WideString): Integer;
    function PrintDocumentToPrinterObject(APrinter: TPrinter; StartPage, EndPage, Options: Integer): Integer;
    function PrintPagesToPrinterObject(APrinter: TPrinter; const PageRanges: WideString; Options: Integer): Integer;
    function PrintOptions(PageScaling, AutoRotateCenter: Integer; const Title: WideString): Integer;
    function PrintMode(Mode: Integer): Integer;
    function GetPrintPreviewBitmapToString(const PrinterName: WideString; PreviewPage, PrintOptions, MaxDimension, PreviewOptions: Integer): AnsiString;
    function NewCustomPrinter(const OriginalPrinterName: WideString): WideString;
    function SetupCustomPrinter(const CustomPrinterName: WideString; Setting, NewValue: Integer): Integer;
    function RequestPrinterStatus(StatusCommand: Integer): Integer;
    function NewInternalPrinterObject(Options: Integer): Integer;
    function GetPrinterNames: WideString;
    function GetLatestPrinterNames: WideString;
    function GetDefaultPrinterName: WideString;
    function GetPrinterBins(const PrinterName: WideString): WideString;
    function GetPrinterMediaTypes(const PrinterName: WideString): WideString;
    function GetPrinterDevModeToString(const PrinterName: WideString): AnsiString;
    function SetPrinterDevModeFromString(const Source: AnsiString): Integer;
    function SetPNGTransparencyColor(RedByte, GreenByte, BlueByte: Integer): Integer;
    function LastRenderError: WideString;
    function SetCairoFileName(const FileName: WideString): Integer;
    function SetDPLRFileName(const FileName: WideString): Integer;

    // Optional Content Groups
    function NewOptionalContentGroup(const GroupName: WideString): Integer;
    function SetCapturedPageOptional(CaptureID, OptionalContentGroupID: Integer): Integer;
    function SetContentStreamOptional(OptionalContentGroupID: Integer): Integer;
    function SetFormFieldOptional(Index, OptionalContentGroupID: Integer): Integer;
    function OptionalContentGroupCount: Integer;
    function GetOptionalContentGroupName(OptionalContentGroupID: Integer): WideString;
    function SetOptionalContentGroupName(OptionalContentGroupID: Integer; NewGroupName: WideString): Integer;
    function GetOptionalContentGroupID(Index: Integer): Integer;
    function SetOptionalContentGroupVisible(OptionalContentGroupID, Visible: Integer): Integer;
    function SetOptionalContentGroupPrintable(OptionalContentGroupID, Printable: Integer): Integer;
    function GetOptionalContentGroupVisible(OptionalContentGroupID: Integer): Integer;
    function GetOptionalContentGroupPrintable(OptionalContentGroupID: Integer): Integer;
    function DeleteOptionalContentGroup(OptionalContentGroupID: Integer): Integer;
    function SetImageOptional(OptionalContentGroupID: Integer): Integer;
    function GetOptionalContentConfigCount: Integer;
    function GetOptionalContentConfigState(OptionalContentConfigID, OptionalContentGroupID: Integer): Integer;
    function SetOptionalContentConfigState(OptionalContentConfigID, OptionalContentGroupID, NewState: Integer): Integer;
    function GetOptionalContentConfigOrderCount(OptionalContentConfigID: Integer): Integer;
    function GetOptionalContentConfigOrderItemType(OptionalContentConfigID, ItemIndex: Integer): Integer;
    function GetOptionalContentConfigOrderItemLabel(OptionalContentConfigID, ItemIndex: Integer): WideString;
    function GetOptionalContentConfigOrderItemID(OptionalContentConfigID, ItemIndex: Integer): Integer;
    function GetOptionalContentConfigOrderItemLevel(OptionalContentConfigID, ItemIndex: Integer): Integer;
    function GetOptionalContentConfigLocked(OptionalContentConfigID, OptionalContentGroupID: Integer): Integer;
    function SetOptionalContentConfigLocked(OptionalContentConfigID, OptionalContentGroupID, NewLocked: Integer): Integer;
    function SetAnnotOptional(Index, OptionalContentGroupID: Integer): Integer;

    // Content stream parts
    function ContentStreamCount: Integer;
    function CombineContentStreams: Integer;
    function NewContentStream: Integer;
    function SelectContentStream(NewIndex: Integer): Integer;
    function EditableContentStream: Integer;
    function MoveContentStream(FromPosition, ToPosition: Integer): Integer;
    function DeleteContentStream: Integer;
    function ContentStreamSafe: Integer;
    function UseUnsafeContentStreams(SafetyLevel: Integer): Integer;
    function EncapsulateContentStream: Integer;
    function BalanceContentStream: Integer;
    function RemoveSharedContentStreams: Integer;
    function GetContentStreamToString: AnsiString;
    function SetContentStreamFromString(const Source: AnsiString): Integer;

    // Fonts
    function FontCount: Integer;
    function GetFontID(Index: Integer): Integer;
    function SelectedFont: Integer;
    function SelectFont(FontID: Integer): Integer;
    function FontName: WideString;
    function FontFamily: WideString;
    function FontReference: WideString;
    function FontType: Integer;
    function GetFontObjectNumber: Integer;
    function AddStandardFont(StandardFontID: Integer): Integer;
    function AddTrueTypeFont(const FontName: WideString; Embed: Integer): Integer;
    function AddTrueTypeFontFromFile(const FileName: WideString): Integer;
    function AddOpenTypeFontFromFile(const FileName: WideString; Options: Integer): Integer;
    function AddType1Font(const FileName: WideString): Integer;
    function AddSubsettedFont(const FontName: WideString; CharsetIndex: Integer; const SubsetChars: WideString): Integer;
    function AddTrueTypeSubsettedFont(const FontName, SubsetChars: WideString; Options: Integer): Integer;
    function UpdateTrueTypeSubsettedFont(const SubsetChars: WideString): Integer;
    function AddCJKFont(CJKFontID: Integer): Integer;
    function SetFontEncoding(Encoding: Integer): Integer;
    function GetFontEncoding: Integer;
    function CharWidth(CharCode: Integer): Integer;
    function SetCharWidth(CharCode, NewWidth: Integer): Integer;
    function ReplaceFonts(Options: Integer): Integer;
    function CompressFonts(Compress: Integer): Integer;
    function FindFonts: Integer;
    //function GetSubsetString(const InputStr: WideString): AnsiString;
    function SaveFontToFile(const FileName: WideString): Integer;
    function SetFontFlags(Fixed, Serif, Symbolic, Script, Italic, AllCap,
      SmallCap, ForceBold: Integer): Integer;
    function GetFontFlags(FontFlagItemID: Integer): Integer;
    function FontSize: Integer;
    function GetInstalledFontsByCharset(CharsetIndex, Options: Integer): WideString;
    function GetInstalledFontsByCodePage(CodePage, Options: Integer): WideString;
    function GetUnicodeCharactersFromEncoding(Encoding: Integer): WideString;
    function GetFontMetrics(MetricType: Integer): Integer;
    function GetFontIsSubsetted: Integer;
    function GetFontIsEmbedded: Integer;

    // Outlines
    function OutlineCount: Integer;
    function OutlineTitle(OutlineID: Integer): WideString;
    function GetOutlineID(Index: Integer): Integer;
    function NewOutline(Parent: Integer; const Title: WideString; DestPage: Integer;
      DestPosition: Double): Integer;
    function NewStaticOutline(Parent: Integer; const Title: WideString): Integer;
    function SetOutlineJavaScript(OutlineID: Integer; const JavaScript: WideString): Integer;
    function GetOutlineJavaScript(OutlineID: Integer): WideString;
    function SetOutlineWebLink(OutlineID: Integer; const Link: WideString): Integer;
    function GetOutlineWebLink(OutlineID: Integer): WideString;
    function SetOutlineColor(OutlineID: Integer; Red, Green, Blue: Double): Integer;
    function GetOutlineColor(OutlineID, ColorComponent: Integer): Double;
    function SetOutlineStyle(OutlineID, SetItalic, SetBold: Integer): Integer;
    function GetOutlineStyle(OutlineID: Integer): Integer;
    function SetOutlineDestination(OutlineID, DestPage: Integer; DestPosition: Double): Integer;
    function SetOutlineDestinationZoom(OutlineID, DestPage: Integer; DestPosition: Double; Zoom: Integer): Integer;
    function SetOutlineDestinationFull(OutlineID, DestPage, Zoom, DestType: Integer;
      Left, Top, Right, Bottom: Double): Integer;
    function SetOutlineNamedDestination(OutlineID: Integer; const DestName: WideString): Integer;
    function SetOutlineTitle(OutlineID: Integer; const NewTitle: WideString): Integer;
    function GetOutlinePage(OutlineID: Integer): Integer;
    function RemoveOutline(OutlineID: Integer): Integer;
    function OpenOutline(OutlineID: Integer): Integer;
    function CloseOutline(OutlineID: Integer): Integer;
    function GetFirstOutline: Integer;
    function GetPrevOutline(OutlineID: Integer): Integer;
    function GetNextOutline(OutlineID: Integer): Integer;
    function GetFirstChildOutline(OutlineID: Integer): Integer;
    function GetParentOutline(OutlineID: Integer): Integer;
    function GetOutlineDest(OutlineID: Integer): Integer;
    function SetOutlineOpenFile(OutlineID: Integer; const FileName: WideString): Integer;
    function GetOutlineOpenFile(OutlineID: Integer): WideString;
    function SetOutlineRemoteDestination(OutlineID: Integer;
      const FileName: WideString; OpenPage, Zoom, DestType: Integer; PntLeft,
      PntTop, PntRight, PntBottom: Double; NewWindow: Integer): Integer;
    function MoveOutlineBefore(OutlineID, SiblingID: Integer): Integer;
    function MoveOutlineAfter(OutlineID, SiblingID: Integer): Integer;
    function CompareOutlines(FirstOutlineID, SecondOutlineID: Integer): Integer;
    function GetOutlineActionID(OutlineID: Integer): Integer;
    function CloneOutlineAction(OutlineID: Integer): Integer;
    function GetOutlineObjectNumber(OutlineID: Integer): Integer;

    // Destinations and actions
    function GetDestPage(DestID: Integer): Integer;
    function GetDestType(DestID: Integer): Integer;
    function GetDestValue(DestID, ValueKey: Integer): Double;
    function GetDestName(DestID: Integer): WideString;
    function SetDestProperties(DestID, Zoom, DestType: Integer;
      Left, Top, Right, Bottom: Double): Integer;
    function SetDestValue(DestID, ValueKey: Integer; NewValue: Double): Integer;
    function GetActionType(ActionID: Integer): WideString;
    function GetActionDest(ActionID: Integer): Integer;
    function GetActionURL(ActionID: Integer): WideString;
    function SetActionURL(ActionID: Integer; const NewURL: WideString): Integer;
    function NewDestination(DestPage, Zoom, DestType: Integer; Left, Top, Right, Bottom: Double): Integer;
    function GetNamedDestination(const DestName: WideString): Integer;
    function NewNamedDestination(const DestName: WideString; DestID: Integer): Integer;

    // Images
    function ImageCount: Integer;
    function GetImageID(Index: Integer): Integer;
    function SelectedImage: Integer;
    function SelectImage(ImageID: Integer): Integer;
    function ImageWidth: Integer;
    function ImageHeight: Integer;
    function ImageType: Integer;
    function ImageFillColor: Integer;
    function ImageHorizontalResolution: Integer;
    function ImageVerticalResolution: Integer;
    function ImageResolutionUnits: Integer;
    function SetImageResolution(Horizontal, Vertical, Units: Integer): Integer;
    function ReplaceImage(OriginalImageID, NewImageID: Integer): Integer;
    function ClearImage(ImageID: Integer): Integer;
    function AddImageFromFile(const FileName: WideString; Options: Integer): Integer;
    function AddImageFromFileOffset(const FileName: WideString; Offset, DataLength, Options: Integer): Integer;
    function AddImageFromStream(InStream: TStream; Options: Integer): Integer;
    function AddImageFromString(const Source: AnsiString; Options: Integer): Integer;
    function AddImageDirectFromString(const Source: AnsiString; Width, Height, BitsPerComponent: Integer;
      const ColorSpace, Filter, Decode: WideString; Interpolate: Integer): Integer;
    function ImportEMFFromFile(const FileName: WideString; FontOptions, GeneralOptions: Integer): Integer;
    function ImportEMFFromStream(InStream: TStream; FontOptions, GeneralOptions: Integer): Integer;
    function CompressImages(Compress: Integer): Integer;
    function FindImages: Integer;
    function SetFindImagesMode(NewFindImagesMode: Integer): Integer;
    function SaveImageToFile(const FileName: WideString): Integer;
    function SaveImageToStream(OutStream: TStream): Integer;
    function SaveImageToString: AnsiString;
    function GetImagePageCount(const FileName: WideString): Integer;
    function GetImagePageCountFromString(const Source: AnsiString): Integer;
    function SetImageMask(FromRed, FromGreen, FromBlue, ToRed, ToGreen, ToBlue: Double): Integer;
    function SetImageMaskCMYK(FromC, FromM, FromY, FromK, ToC, ToM, ToY, ToK: Double): Integer;
    function SetImageMaskFromImage(ImageID: Integer): Integer;
    function SetImageAsMask(MaskType: Integer): Integer;
    function ReleaseImage(ImageID: Integer): Integer;
    function ReverseImage(Reset: Integer): Integer;
    function GetPageImageList(Options: Integer): Integer;
    function GetImageListCount(ImageListID: Integer): Integer;
    function GetImageListItemIntProperty(ImageListID, ImageIndex, PropertyID: Integer): Integer;
    function GetImageListItemDblProperty(ImageListID, ImageIndex, PropertyID: Integer): Double;
    function GetImageListItemDataToString(ImageListID, ImageIndex, Options: Integer): AnsiString;
    function SaveImageListItemDataToFile(ImageListID, ImageIndex, Options: Integer; const ImageFileName: WideString): Integer;
    function GetImageListItemFormatDesc(ImageListID, ImageIndex, Options: Integer): WideString;
    function ReleaseImageList(ImageListID: Integer): Integer;

    // Drawing (General)
    function SetOrigin(Origin: Integer): Integer;
    function GetOrigin: Integer;
    function SetMeasurementUnits(MeasurementUnits: Integer): Integer;
    function SetPrecision(NewPrecision: Integer): Integer;
    function SetScale(NewScale: Double): Integer;
    function MultiplyScale(MultScaleBy: Double): Integer;
    function SaveState: Integer;
    function LoadState: Integer;
    function SetTransparency(Transparency: Integer): Integer;
    function SetBlendMode(BlendMode: Integer): Integer;
    function SetOverprint(StrokingOverprint, OtherOverprint, OverprintMode: Integer): Integer;
    function DrawPostScriptXObject(PSRef: Integer): Integer;
    function BeginPageUpdate: Integer;
    function EndPageUpdate: Integer;

    // Drawing (Text)
    function SetTextColor(Red, Green, Blue: Double): Integer;
    function SetTextColorCMYK(C, M, Y, K: Double): Integer;
    function SetTextColorSep(const ColorName: WideString; Tint: Double): Integer;
    function SetTextShader(const ShaderName: WideString): Integer;
    function SetTextAlign(TextAlign: Integer): Integer;
    function SetTextSize(TextSize: Double): Integer;
    function SetTextSpacing(Spacing: Double): Integer;
    function SetTextMode(TextMode: Integer): Integer;
    function SetTextScaling(ScalePercentage: Double): Integer;
    function SetTextRise(Rise: Double): Integer;
    function SetTextHighlight(Highlight: Integer): Integer;
    function SetTextUnderline(Underline: Integer): Integer;
    function SetTextHighlightColor(Red, Green, Blue: Double): Integer;
    function SetTextHighlightColorCMYK(C, M, Y, K: Double): Integer;
    function SetTextHighlightColorSep(const ColorName: WideString; Tint: Double): Integer;
    function SetTextWordSpacing(WordSpacing: Double): Integer;
    function SetTextCharSpacing(CharSpacing: Double): Integer;
    function SetTextUnderlineColor(Red, Green, Blue: Double): Integer;
    function SetTextUnderlineColorCMYK(C, M, Y, K: Double): Integer;
    function SetTextUnderlineColorSep(const ColorName: WideString; Tint: Double): Integer;
    function SetTextUnderlineDash(DashOn, DashOff: Double): Integer;
    function SetTextUnderlineWidth(UnderlineWidth: Double): Integer;
    function SetTextUnderlineDistance(UnderlineDistance: Double): Integer;
    function SetTextUnderlineCustomDash(const DashPattern: WideString; DashPhase: Double): Integer;
    function SetBreakString(const NewBreakString: WideString): Integer;
    function ClearTextFormatting: Integer;

    function GetTextSize: Double;
    function GetTextHeight: Double;
    function GetTextAscent: Double;
    function GetTextDescent: Double;
    function GetTextBound(Edge: Integer): Double;
    function GetTextWidth(const Text: WideString): Double;

    function DrawText(XPos, YPos: Double; const Text: WideString): Integer;
    function DrawSpacedText(XPos, YPos, Spacing: Double; const Text: WideString): Integer;
    function DrawRotatedText(XPos, YPos, Angle: Double; const Text: WideString): Integer;
    function FitRotatedTextBox(Left, Top, Width, Height, Angle: Double; const Text: WideString; Options: Integer): Integer;
    function DrawTextBox(Left, Top, Width, Height: Double; const Text: WideString; Options: Integer): Integer;
    function DrawTextBoxMatrix(Width, Height: Double; const Text: WideString; Options: Integer; M11, M12, M21, M22, MDX, MDY: Double): Integer;
    function FitTextBox(Left, Top, Width, Height: Double; const Text: WideString; Options: Integer): Integer;
    function DrawTextArc(XPos, YPos, Radius, Angle: Double; const Text: WideString; DrawOptions: Integer): Integer;
    function AppendText(const Text: WideString): Integer;
    function AppendSpace(RelativeSpace: Double): Integer;
    function DrawRotatedTextBox(Left, Top, Width, Height, Angle: Double; const Text: WideString; Options: Integer): Integer;
    function DrawRotatedTextBoxEx(Left, Top, Width, Height, Angle: Double; const Text: WideString; Options: Integer; Border, Radius, DrawOptions:Integer): Integer;

    function SetHTMLNormalFont(const FontSet: WideString; FontID: Integer): Integer;
    function SetHTMLBoldFont(const FontSet: WideString; FontID: Integer): Integer;
    function SetHTMLItalicFont(const FontSet: WideString; FontID: Integer): Integer;
    function SetHTMLBoldItalicFont(const FontSet: WideString; FontID: Integer): Integer;
    function DrawHTMLText(Left, Top, Width: Double; const HTMLText: WideString): Integer;
    function DrawHTMLTextBox(Left, Top, Width, Height: Double; const HTMLText: WideString): WideString;
    function DrawHTMLTextBoxMatrix(Width, Height: Double; const HTMLText: WideString; M11, M12, M21, M22, MDX, MDY: Double): WideString;
    function DrawHTMLTextMatrix(Width: Double; const HTMLText: WideString; M11, M12, M21, M22, MDX, MDY: Double): Integer;
    function GetHTMLTextHeight(Width: Double; const HTMLText: WideString): Double;
    function GetHTMLTextWidth(MaxWidth: Double; const HTMLText: WideString): Double;
    function GetHTMLTextLineCount(Width: Double; const HTMLText: WideString): Integer;

    function DrawMultiLineText(XPos, YPos: Double; const Delimiter, Text: WideString): Integer;
    function DrawRotatedMultiLineText(XPos, YPos, Angle: Double; const Delimiter, Text: WideString): Integer;
    function DrawWrappedText(XPos, YPos, Width: Double; const Text: WideString): Integer;
    function GetWrappedText(Width: Double; const Delimiter, Text: WideString): WideString;
    function GetWrappedTextHeight(Width: Double; const Text: WideString): Double;
    function GetWrappedTextLineCount(Width: Double; const Text: WideString): Integer;
    function GetWrappedTextBreakString(Width: Double; const Delimiter, Text: WideString): WideString;

    function SaveStyle(const StyleName: WideString): Integer;
    function ApplyStyle(const StyleName: WideString): Integer;
    function RemoveStyle(const StyleName: WideString): Integer;

    function UseKerning(Kern: Integer): Integer;
    function FontHasKerning: Integer;
    function GetKerning(const CharPair: WideString): Integer;
    function SetKerning(const CharPair: WideString; Adjustment: Integer): Integer;

    // Drawing (Lines and shapes)
    function AddSeparationColor(const ColorName: WideString; C, M, Y, K: Double; Options: Integer): Integer;
    function SetFillColor(Red, Green, Blue: Double): Integer;
    function SetFillColorCMYK(C, M, Y, K: Double): Integer;
    function SetFillColorSep(const ColorName: WideString; Tint: Double): Integer;
    function SetFillShader(const ShaderName: WideString): Integer;
    function SetFillTilingPattern(const PatternName: WideString): Integer;
    function SetLineColor(Red, Green, Blue: Double): Integer;
    function SetLineColorCMYK(C, M, Y, K: Double): Integer;
    function SetLineColorSep(const ColorName: WideString; Tint: Double): Integer;
    function SetLineShader(const ShaderName: WideString): Integer;
    function SetLineWidth(LineWidth: Double): Integer;
    function SetLineDash(DashOn, DashOff: Double): Integer;
    function SetLineDashEx(const DashValues: WideString): Integer;
    function SetCustomLineDash(const DashPattern: WideString; DashPhase: Double): Integer;
    function SetLineCap(LineCap: Integer): Integer;
    function SetLineJoin(LineJoin: Integer): Integer;
    function StartPath(StartX, StartY: Double): Integer;
    function AddLineToPath(EndX, EndY: Double): Integer;
    function AddCurveToPath(CtAX, CtAY, CtBX, CtBY, EndX, EndY: Double): Integer;
    function AddArcToPath(CenterX, CenterY, TotalAngle: Double): Integer;
    function AddBoxToPath(Left, Top, Width, Height: Double): Integer;
    function DrawPath(PathOptions: Integer): Integer;
    function SetClippingPath: Integer;
    function ClosePath: Integer;
    function MovePath(NewX, NewY: Double): Integer;
    function DrawPathEvenOdd(PathOptions: Integer): Integer;
    function SetClippingPathEvenOdd: Integer;
    function DrawLine(StartX, StartY, EndX, EndY: Double): Integer;
    function DrawBox(Left, Top, Width, Height: Double; DrawOptions: Integer): Integer;
    function DrawRotatedBox(Left, Bottom, Width, Height, Angle: Double; DrawOptions: Integer): Integer;
    function DrawRoundedBox(Left, Top, Width, Height, Radius: Double; DrawOptions: Integer): Integer;
    function DrawRoundedRotatedBox(Left, Bottom, Width, Height, Radius, Angle: Double; DrawOptions: Integer): Integer;
    function DrawCircle(XPos, YPos, Radius: Double; DrawOptions: Integer): Integer;
    function DrawBarcode(Left, Top, Width, Height: Double; const Text: WideString; Barcode, Options: Integer): Integer;
    function GetBarcodeWidth(NominalWidth: Double; const Text: WideString; Barcode: Integer): Double;
    function DrawDataMatrixSymbol(Left, Top, ModuleSize: Double; const Text: WideString; Encoding, SymbolSize, Options: Integer): Integer;
    function DrawPDF417Symbol(Left, Top: Double; const Text: WideString; Options: Integer): Integer;
    function DrawPDF417SymbolEx(Left, Top: Double; const Text: WideString; Options, FixedColumns, FixedRows, ErrorLevel: Integer; ModuleSize, HeightWidthRatio: Double): Integer;
    function DrawQRCode(Left, Top, SymbolSize: Double; const Text: WideString; EncodeOptions, DrawOptions: Integer): Integer;
    function DrawIntelligentMailBarcode(Left, Top, BarWidth, FullBarHeight, TrackerHeight, SpaceWidth: Double; const BarcodeData: WideString; Options: Integer): Integer;
    function DrawArc(XPos, YPos, Radius, StartAngle, EndAngle: Double; Pie, DrawOptions: Integer): Integer;
    function DrawEllipse(XPos, YPos, Width, Height: Double; DrawOptions: Integer): Integer;
    function DrawEllipticArc(XPos, YPos, Width, Height, StartAngle, EndAngle: Double; Pie, DrawOptions: Integer): Integer;

    // Drawing (patterns and shading)
    function NewRGBAxialShader(const ShaderName: WideString; StartX, StartY,
      StartRed, StartGreen, StartBlue, EndX, EndY, EndRed, EndGreen,
      EndBlue: Double; Extend: Integer): Integer;
    function NewTilingPatternFromCapturedPage(const PatternName: WideString;
      CaptureID: Integer): Integer;
    function SetTilingPatternMatrix(const PatternName: WideString; M11, M12, M21, M22, MDX, MDY: Double): Integer;

    // Drawing (images)
    function DrawImage(Left, Top, Width, Height: Double): Integer;
    function DrawRotatedImage(Left, Bottom, Width, Height, Angle: Double): Integer;
    function DrawScaledImage(Left, Top, Scale: Double): Integer;
    function DrawImageMatrix(M11, M12, M21, M22, MDX, MDY: Double): Integer;
    function FitImage(Left, Top, Width, Height: Double; HAlign, VAlign, Rotate: Integer): Integer;

    // Annotations
    function AddLinkToWeb(Left, Top, Width, Height: Double; const Link: WideString;
      Options: Integer): Integer;
    function AddLinkToPage(Left, Top, Width, Height: Double; Page: Integer;
      Position: Double; Options: Integer): Integer;
    function AddLinkToJavaScript(Left, Top, Width, Height: Double; const JavaScript: WideString;
      Options: Integer): Integer;
    function AddLinkToFile(Left, Top, Width, Height: Double; const FileName: WideString;
      Page: Integer; Position: Double; NewWindow, Options: Integer): Integer;
    function AddRelativeLinkToFile(Left, Top, Width, Height: Double; const FileName: WideString;
      Page: Integer; Position: Double; NewWindow, Options: Integer): Integer;
    function AddLinkToFileDest(Left, Top, Width, Height: Double; const FileName: WideString;
      NamedDest: WideString; Position: Double; NewWindow, Options: Integer): Integer;
    function AddRelativeLinkToFileDest(Left, Top, Width, Height: Double; const FileName: WideString;
      NamedDest: WideString; Position: Double; NewWindow, Options: Integer): Integer;
    function AddLinkToFileEx(Left, Top, Width, Height: Double; const FileName: WideString;
      DestPage: Integer; NewWindow, Options, Zoom, DestType: Integer;
      DestLeft, DestTop, DestRight, DestBottom: Double): Integer;
    function AddRelativeLinkToFileEx(Left, Top, Width, Height: Double; const FileName: WideString;
      DestPage: Integer; NewWindow, Options, Zoom, DestType: Integer;
      DestLeft, DestTop, DestRight, DestBottom: Double): Integer;
    function AddLinkToEmbeddedFile(Left, Top, Width, Height: Double; EmbeddedFileID: Integer;
      const Title, Contents: WideString; IconType, Transparency: Integer): Integer;
    function AddLinkToLocalFile(Left, Top, Width, Height: Double;
      const FileName: WideString; Options: Integer): Integer;
    function AddRelativeLinkToLocalFile(Left, Top, Width, Height: Double;
      const FileName: WideString; Options: Integer): Integer;
    function AddLinkToDestination(Left, Top, Width, Height: Double; DestID, Options: Integer): Integer;
    function AddNoteAnnotation(Left, Top: Double; AnnotType: Integer; PopupLeft, PopupTop,
      PopupWidth, PopupHeight: Double; const Title, Contents: WideString; Red, Green,
      Blue: Double; Open: Integer): Integer;
    function AddSVGAnnotationFromFile(Left, Top, Width, Height: Double;
      const FileName: WideString; Options: Integer): Integer;
    function AddU3DAnnotationFromFile(Left, Top, Width, Height: Double;
      const FileName: WideString; Options: Integer): Integer;
    function AddSWFAnnotationFromFile(Left, Top, Width, Height: Double;
      const FileName, Title: WideString; Options: Integer): Integer;
    function AddTextMarkupAnnotation(MarkupType: Integer; Left, Top, Width,
      Height: Double): Integer;
    function AddStampAnnotation(Left, Top, Width, Height: Double;
      StampType: Integer; const Title, Contents: WideString; Red, Green,
      Blue: Double; Options: Integer): Integer;
    function AddStampAnnotationFromImage(Left, Top, Width, Height: Double;
      const FileName: WideString; const Title, Contents: WideString; Red, Green,
      Blue: Double; Options: Integer): Integer;
    function AddStampAnnotationFromImageID(Left, Top, Width, Height: Double;
      ImageID: Integer; const Title, Contents: WideString; Red, Green,
      Blue: Double; Options: Integer): Integer;
    function AddFreeTextAnnotation(Left, Top, Width, Height: Double; const Text: WideString; Angle, Options: Integer): Integer;
    function AddFreeTextAnnotationEx(Left, Top, Width, Height: Double; const Text: WideString; Angle, Options: Integer; Transparency: Integer): Integer;
    function AnnotationCount: Integer;
    function GetAnnotStrProperty(Index, Tag: Integer): WideString;
    function SetAnnotStrProperty(Index, Tag: Integer; const NewValue: WideString): Integer;
    function GetAnnotIntProperty(Index, Tag: Integer): Integer;
    function SetAnnotIntProperty(Index, Tag, NewValue: Integer): Integer;
    function GetAnnotDblProperty(Index, Tag: Integer): Double;
    function SetAnnotDblProperty(Index, Tag: Integer; NewValue: Double): Integer;
    function SetAnnotBorderColor(Index: Integer; Red, Green, Blue: Double): Integer;
    function SetAnnotContents(Index: Integer; const NewContents: WideString): Integer;
    function SetAnnotRect(Index: Integer; Left, Top, Width, Height: Double): Integer;
    function CheckPageAnnots: Integer;
    function DeleteAnnotation(Index: Integer): Integer;
    function GetAnnotActionID(Index: Integer): Integer;
    function GetAnnotDest(Index: Integer): Integer;
    function IsAnnotFormField(Index: Integer): Integer;
    function AttachAnnotToForm(Index: Integer): Integer;
    function SetAnnotQuadPoints(Index, QuadNumber: Integer; X1, Y1, X2, Y2,
      X3, Y3, X4, Y4: Double): Integer;
    function GetAnnotQuadPoints(Index, QuadNumber, PointNumber: Integer): Double;
    function GetAnnotQuadCount(Index: Integer): Integer;
    function SetAnnotBorderStyle(Index: Integer; Width: Double; Style: Integer;
      DashOn, DashOff: Double): Integer;
    function SetMarkupAnnotStyle(Index: Integer; Red, Green, Blue, Transparency: Double): Integer;
    function GetAnnotSoundToString(Index, Options: Integer): AnsiString;
    function GetAnnotSoundToFile(Index, Options: Integer; const SoundFileName: WideString): Integer;
    function FlattenAnnot(Index, Options: Integer): Integer;
    function GetTabOrderMode: WideString;
    function SetTabOrderMode(Mode: WideString): Integer;
    function GetAnnotEmbeddedFileName(Index, Options: Integer): WideString;
    function GetAnnotEmbeddedFileToString(Index, Options: Integer): AnsiString;
    function GetAnnotEmbeddedFileToFile(Index, Options: Integer; const FileName: WideString): Integer;

    // Form field functions
    function FormFieldCount: Integer;
    function GetFormFieldType(Index: Integer): Integer;
    function FindFormFieldByTitle(const Title: WideString): Integer;
    function GetFormFieldSubCount(Index: Integer): Integer;
    function GetFormFieldSubName(Index, SubIndex: Integer): WideString;
    function GetFormFieldSubDisplayName(Index, SubIndex: Integer): WideString;
    function AddFormFieldSub(Index: Integer; const SubName: WideString): Integer;
    function AddFormFieldChoiceSub(Index: Integer; const SubName, DisplayName: WideString): Integer;
    function NewFormField(const Title: WideString; FieldType: Integer): Integer;
    function NewChildFormField(Index: Integer; const Title: WideString; FieldType: Integer): Integer;
    function DeleteFormField(Index: Integer): Integer;
    function SetNeedAppearances(NewValue: Integer): Integer;
    function SetFormFieldIcon(Index, IconType, CaptureID: Integer): Integer;
    function SetFormFieldIconStyle(Index, Placement, Scale, ScaleType,
      HorizontalShift, VerticalShift: Integer): Integer;
    function SetFormFieldHighlightMode(Index, NewMode: Integer): Integer;
    function SetFormFieldCalcOrder(Index, Order: Integer): Integer;
    function RemoveAppearanceStream(Index: Integer): Integer;
    function UpdateAppearanceStream(Index: Integer): Integer;
    function GetFormFieldFontName(Index: Integer): WideString;
    function GetFormFontCount: Integer;
    function GetFormFontName(FontIndex: Integer): WideString;
    function SetFormFieldFont(Index, FontIndex: Integer): Integer;
    function SetFormFieldStandardFont(Index, StandardFontID: Integer): Integer;
    function AddFormFont(FontID: Integer): Integer;
    function FlattenFormField(Index: Integer): Integer;
    function UpdateAndFlattenFormField(Index: Integer): Integer;
    function GetFormFieldKidCount(Index: Integer): Integer;
    function GetFormFieldKidTempIndex(Index, KidIndex: Integer): Integer;
    function FormFieldHasParent(Index: Integer): Integer;
    function GetFormFieldChoiceType(Index: Integer): Integer;
    function SetFormFieldChoiceType(Index, ChoiceType: Integer): Integer;
    function GetFormFieldBound(Index, Edge: Integer): Double;
    function SetFormFieldBounds(Index: Integer; Left, Top, Width, Height: Double): Integer;
    function GetFormFieldVisible(Index: Integer): Integer;
    function SetFormFieldVisible(Index, Visible: Integer): Integer;
    function GetFormFieldPrintable(Index: Integer): Integer;
    function SetFormFieldPrintable(Index, Printable: Integer): Integer;
    function GetFormFieldReadOnly(Index: Integer): Integer;
    function SetFormFieldReadOnly(Index, ReadOnly: Integer): Integer;
    function GetFormFieldRequired(Index: Integer): Integer;
    function SetFormFieldRequired(Index, Required: Integer): Integer;
    function GetFormFieldNoExport(Index: Integer): Integer;
    function SetFormFieldNoExport(Index, NoExport: Integer): Integer;
    function GetFormFieldTitle(Index: Integer): WideString;
    function GetFormFieldChildTitle(Index: Integer): WideString;
    function SetFormFieldChildTitle(Index: Integer; const NewTitle: WideString): Integer;
    function GetFormFieldValue(Index: Integer): WideString;
    function SetFormFieldValue(Index: Integer; const NewValue: WideString): Integer;
    function GetFormFieldValueByTitle(const Title: WideString): WideString;
    function SetFormFieldValueByTitle(const Title, NewValue: WideString): Integer;
    function SetFormFieldDefaultValue(Index: Integer; const NewDefaultValue: WideString): Integer;
    function GetFormFieldDefaultValue(Index: Integer): WideString;
    function GetFormFieldPage(Index: Integer): Integer;
    function SetFormFieldPage(Index, NewPage: Integer): Integer;
    function GetFormFieldFlags(Index: Integer): Integer;
    function SetFormFieldFlags(Index, NewFlags: Integer): Integer;
    function GetFormFieldAnnotFlags(Index: Integer): Integer;
    function SetFormFieldAnnotFlags(Index, NewFlags: Integer): Integer;
    function GetFormFieldJavaScript(Index: Integer; const ActionType: WideString): WideString;
    function FormFieldJavaScriptAction(Index: Integer; const ActionType, JavaScript: WideString): Integer;
    function GetFormFieldWebLink(Index: Integer; const ActionType: WideString): WideString;
    function FormFieldWebLinkAction(Index: Integer; const ActionType, Link: WideString): Integer;
    function GetFormFieldDescription(Index: Integer): WideString;
    function SetFormFieldDescription(Index: Integer; const NewDescription: WideString): Integer;
    function GetFormFieldBorderColor(Index, ColorComponent: Integer): Double;
    function SetFormFieldBorderColor(Index: Integer; Red, Green, Blue: Double): Integer;
    function SetFormFieldBorderColorGray(Index: Integer; G: Double): Integer;
    function SetFormFieldBorderColorCMYK(Index: Integer; C, M, Y, K: Double): Integer;
    function SetFormFieldBorderColorSep(Index: Integer; const ColorName: WideString; Tint: Double): Integer;
    function RemoveFormFieldBorderColor(Index: Integer): Integer;
    function RemoveFormFieldBackgroundColor(Index: Integer): Integer;
    function GetFormFieldBackgroundColor(Index, ColorComponent: Integer): Double;
    function SetFormFieldBackgroundColor(Index: Integer; Red, Green, Blue: Double): Integer;
    function SetFormFieldBackgroundColorCMYK(Index: Integer; C, M, Y, K: Double): Integer;
    function SetFormFieldBackgroundColorGray(Index: Integer; G: Double): Integer;
    function SetFormFieldBackgroundColorSep(Index: Integer; const ColorName: WideString; Tint: Double): Integer;
    function GetFormFieldBorderColorType(Index: Integer): Integer;
    function GetFormFieldBackgroundColorType(Index: Integer): Integer;
    function GetFormFieldSubmitActionString(Index: Integer; const ActionType: WideString): WideString;

    function GetFormFieldCaption(Index: Integer): WideString;
    function GetFormFieldCaptionEx(Index: Integer; StringType: Integer): WideString;
    function SetFormFieldCaption(Index: Integer; const NewCaption: WideString): Integer;
    function GetFormFieldBorderStyle(Index: Integer): Integer;
    function GetFormFieldBorderProperty(Index, PropKey: Integer): Double;
    function SetFormFieldBorderStyle(Index: Integer; Width: Double;
      Style: Integer; DashOn, DashOff: Double): Integer;
    function GetFormFieldAlignment(Index: Integer): Integer;
    function SetFormFieldAlignment(Index, Alignment: Integer): Integer;
    function GetFormFieldMaxLen(Index: Integer): Integer;
    function SetFormFieldMaxLen(Index, NewMaxLen: Integer): Integer;
    function GetFormFieldComb(Index: Integer): Integer;
    function SetFormFieldComb(Index, Comb: Integer): Integer;
    function GetFormFieldColor(Index, ColorComponent: Integer): Double;
    function SetFormFieldColor(Index: Integer; Red, Green, Blue: Double): Integer;
    function SetFormFieldColorCMYK(Index: Integer; C, M, Y, K: Double): Integer;
    function SetFormFieldColorSep(Index: Integer; const ColorName: WideString; Tint: Double): Integer;
    function GetFormFieldTextSize(Index: Integer): Double;
    function SetFormFieldTextSize(Index: Integer; NewTextSize: Double): Integer;
    function GetFormFieldTextFlags(Index, ValueKey: Integer): Integer;
    function SetFormFieldTextFlags(Index, Multiline, Password, FileSelect, DoNotSpellCheck, DoNotScroll: Integer): Integer;
    function GetFormFieldRotation(Index: Integer): Integer;
    function SetFormFieldRotation(Index, Angle: Integer): Integer;
    function GetFormFieldTabOrder(Index: Integer): Integer;
    function GetFormFieldTabOrderEx(Index, Options: Integer): Integer;
    function SetFormFieldTabOrder(Index, Order: Integer): Integer;
    function SetFormFieldCheckStyle(Index, CheckStyle, Position: Integer): Integer;
    function GetFormFieldCheckStyle(Index: Integer): Integer;
    function GetFormFieldActionID(Index: Integer; const TriggerEvent: WideString): Integer;
    function SetFormFieldSubmitAction(Index: Integer; const ActionType, Link: WideString): Integer;
    function SetFormFieldSubmitActionEx(Index: Integer; const ActionType, Link: WideString; Flags: Integer): Integer;
    function SetFormFieldResetAction(Index: Integer; const ActionType: WideString): Integer;
    function GetFormFieldObjectNumber(Index: Integer): Integer;
    function SetFormFieldSignatureImage(Index, ImageID, Options: Integer): Integer;
    function GetFormFieldRichTextString(Index: Integer; const Key: WideString): WideString;
    function SetFormFieldRichTextString(Index: Integer; const Key, NewValue: WideString): Integer;
    function SetFormFieldChoiceSub(Index, SubIndex: Integer; const SubName, DisplayName: WideString): Integer;
    function RemoveFormFieldChoiceSub(Index: Integer; const SubName: WideString): Integer;
    function SetFormFieldTitle(Index: Integer; NewTitle: WideString): Integer;

    // XFA form field functions
    function GetXFAFormFieldValue(const XFAFieldName: WideString): WideString;
    function SetXFAFormFieldValue(const XFAFieldName, NewValue: WideString): Integer;
    function SetXFAFormFieldBorderWidth(const XFAFieldName: WideString; BorderWidth: Double): Integer;
    function SetXFAFormFieldBorderColor(const XFAFieldName: WideString; Red, Green, Blue: Double): Integer;
    function SetXFAFormFieldBorderPresence(const XFAFieldName: WideString; NewPresence: Integer): Integer;
    function SetXFAFormFieldAccess(const XFAFieldName: WideString; NewAccess: Integer): Integer;
    function GetXFAFormFieldNames(const Delimiter: WideString): WideString;
    function GetXFAFormFieldCount: Integer;
    function GetXFAFormFieldName(Index: Integer): WideString;
    function RemoveXFAEntries(Options: Integer): Integer;
    function GetXFAToString(Options: Integer): AnsiString;
    function SetXFAFromString(const Source: AnsiString; Options: Integer): Integer;

    // Digital Signature functions
    function SignFile(const InputFileName, OpenPassword, SignatureFieldName,
      OutputFileName, PFXFileName, PFXPassword, Reason, Location, ContactInfo: WideString): Integer;

    // These functions return a SignProcessID from various inputs
    function NewSignProcessFromFile(const InputFile, Password: WideString): Integer;
    function NewSignProcessFromStream(InputStream: TStream; const Password: WideString): Integer;
    function NewSignProcessFromString(const Source: AnsiString; const Password: WideString): Integer;

    // These functions are for setting up the signing process options
    function SetSignProcessField(SignProcessID: Integer; const SignatureFieldName: WideString): Integer;
    function SetSignProcessPassthrough(SignProcessID, SignatureLength: Integer): Integer;
    function SetSignProcessPFXFromFile(SignProcessID: Integer; const PFXFileName, PFXPassword: WideString): Integer;
    function SetSignProcessInfo(SignProcessID: Integer; const Reason, Location, ContactInfo: WideString): Integer;
    function SetSignProcessFieldImageFromFile(SignProcessID: Integer; const ImageFileName: WideString; Options: Integer): Integer;
    function SetSignProcessFieldBounds(SignProcessID: Integer; Left, Top, Width, Height: Double): Integer;
    function SetSignProcessSubFilter(SignProcessID, SubFilter: Integer): Integer;
    function SetSignProcessKeyset(SignProcessID, KeysetID: Integer): Integer;
    function SetSignProcessFieldPage(SignProcessID, SignaturePage: Integer): Integer;
    function SetSignProcessCustomSubFilter(SignProcessID: Integer; SubFilterStr: WideString): Integer;

    // These functions write the final output file
    function EndSignProcessToFile(SignProcessID: Integer; const OutputFile: WideString): Integer;
    function EndSignProcessToString(SignProcessID: Integer): AnsiString;
    function EndSignProcessToStream(SignProcessID: Integer; OutputStream: TStream): Integer;

    // These functions give the signing result, other info and release the signing process
    function GetSignProcessResult(SignProcessID: Integer): Integer;
    function GetSignProcessByteRange(SignProcessID, ArrayPosition: Integer): Integer;
    function ReleaseSignProcess(SignProcessID: Integer): Integer;

    // Standalone functions
    function EncryptFile(const InputFileName, OutputFileName,
      Owner, User: WideString; Strength, Permissions: Integer): Integer;
    function DecryptFile(const InputFileName, OutputFileName,
      Password: WideString): Integer;
    function AnalyseFile(const InputFileName, Password: WideString): Integer;
    function GetAnalysisInfo(AnalysisID, AnalysisItem: Integer): WideString;
    function DeleteAnalysis(AnalysisID: Integer): Integer;
    function MergeFiles(const FirstFileName, SecondFileName, OutputFileName: WideString): Integer;
    function MergeStreams(FirstStream, SecondStream, OutputStream: TStream): Integer;
    function AddToFileList(const ListName, FileName: WideString): Integer;
    function ClearFileList(const ListName: WideString): Integer;
    function MergeFileList(const ListName, OutputFileName: WideString): Integer;
    function MergeFileListFast(const ListName, OutputFileName: WideString): Integer;
    function FileListItem(const ListName: WideString; Index: Integer): WideString;
    function FileListCount(const ListName: WideString): Integer;
    function ExtractFilePageText(const InputFileName, Password: WideString; Page, Options: Integer): WideString;
    function ExtractFilePageTextBlocks(const InputFileName, Password: WideString; Page, Options: Integer): Integer;
    function ExtractFilePageContentToString(const InputFileName, Password: WideString; Page: Integer): AnsiString;
    function ExtractFilePages(const InputFileName, Password, OutputFileName, RangeList: WideString): Integer;
    function ExtractFilePagesEx(const InputFileName, Password, OutputFileName, RangeList: WideString; Options: Integer): Integer;
    function GetFileMetadata(const InputFileName, Password: WideString): WideString;
    function CheckFileCompliance(const InputFileName, Password: WideString; ComplianceTest, Options: Integer): Integer;
    function TransformFile(const InputFileName, Password, OutputFileName: WideString; TransformType, Options: Integer): Integer;
    function LinearizeFile(const InputFileName, Password, OutputFileName: WideString; Options: Integer): Integer;

    // Direct Access functions
    function DAOpenFile(const InputFileName, Password: WideString): Integer;
    function DAOpenFileReadOnly(const InputFileName, Password: WideString): Integer;
    function DAOpenFromStream(InStream: TStream; const Password: WideString): Integer;
    function DACloseFile(FileHandle: Integer): Integer;
    function DAAppendFile(FileHandle: Integer): Integer;
    function DAShiftedHeader(FileHandle: Integer): Integer;
    function DASaveAsFile(FileHandle: Integer; const OutputFileName: WideString): Integer;
    function DASaveToStream(FileHandle: Integer; OutStream: TStream): Integer;
    function DASaveCopyToStream(FileHandle: Integer; OutStream: TStream): Integer;
    function DAGetPageContentToString(FileHandle, PageRef: Integer): AnsiString;
    function DAExtractPageText(FileHandle, PageRef, Options: Integer): WideString;
    function DAExtractPageTextBlocks(FileHandle, PageRef, ExtractOptions: Integer): Integer;
    function DAGetInformation(FileHandle: Integer; const Key: WideString): WideString;
    function DASetInformation(FileHandle: Integer; const Key, NewValue: WideString): Integer;
    function DANewPages(FileHandle, PageCount: Integer): Integer;
    function DACapturePage(FileHandle, PageRef: Integer): Integer;
    function DACapturePageEx(FileHandle, PageRef, Options: Integer): Integer;
    function DAHidePage(FileHandle, PageRef: Integer): Integer;
    function DADrawCapturedPage(FileHandle, DACaptureID, DestPageRef: Integer; PntLeft, PntBottom, PntWidth, PntHeight: Double): Integer;
    function DADrawRotatedCapturedPage(FileHandle, DACaptureID, DestPageRef: Integer; PntLeft, PntBottom, PntWidth, PntHeight, Angle: Double): Integer;
    function DAGetPageCount(FileHandle: Integer): Integer;
    function DASetPageSize(FileHandle, PageRef: Integer; PntWidth, PntHeight: Double): Integer;
    function DASetPageBox(FileHandle, PageRef, BoxIndex: Integer; X1, Y1, X2, Y2: Double): Integer;
    function DAGetPageBox(FileHandle, PageRef, BoxIndex, Dimension: Integer): Double;
    function DAHasPageBox(FileHandle, PageRef, BoxIndex: Integer): Integer;
    function DANewPage(FileHandle: Integer): Integer;
    function DAFindPage(FileHandle, Page: Integer): Integer;
    function DAGetPageWidth(FileHandle, PageRef: Integer): Double;
    function DAGetPageHeight(FileHandle, PageRef: Integer): Double;
    function DARenderPageToString(FileHandle, PageRef, Options: Integer; DPI: Double): AnsiString;
    function DARenderPageToStream(FileHandle, PageRef, Options: Integer; DPI: Double; Target: TStream): Integer;
    function DARenderPageToFile(FileHandle, PageRef, Options: Integer; DPI: Double; const FileName: WideString): Integer;
    function DARenderPageToDC(FileHandle, PageRef: Integer; DPI: Double; DC: HDC): Integer;
    function DAMovePage(FileHandle, PageRef, TargetPageRef, Options: Integer): Integer;
    function DAPageRotation(FileHandle, PageRef: Integer): Integer;
    function DARotatePage(FileHandle, PageRef, Angle, Options: Integer): Integer;
    function DAGetPageImageList(FileHandle, PageRef: Integer): Integer;
    function DAGetImageListCount(FileHandle, ImageListID: Integer): Integer;
    function DAGetImageIntProperty(FileHandle, ImageListID, ImageIndex, PropertyID: Integer): Integer;
    function DAGetImageDblProperty(FileHandle, ImageListID, ImageIndex, PropertyID: Integer): Double;
    function DAGetImageDataToString(FileHandle, ImageListID, ImageIndex: Integer): AnsiString;
    function DASaveImageDataToFile(FileHandle, ImageListID, ImageIndex: Integer; const ImageFileName: WideString): Integer;
    function DAReleaseImageList(FileHandle, ImageListID: Integer): Integer;
    function DAGetObjectCount(FileHandle: Integer): Integer;
    function DAGetObjectToString(FileHandle, ObjectNumber: Integer): AnsiString;
    function DAGetFormFieldCount(FileHandle: Integer): Integer;
    function DAGetFormFieldTitle(FileHandle, FieldIndex: Integer): WideString;
    function DAGetFormFieldValue(FileHandle, FieldIndex: Integer): WideString;
    function DAGetAnnotationCount(FileHandle, PageRef: Integer): Integer;
    function DAEmbedFileStreams(FileHandle: Integer; const RootPath: WideString): Integer;
    function DARemoveUsageRights(FileHandle: Integer): Integer;
    function DASetTextExtractionWordGap(NewWordGap: Double): Integer;
    function DASetTextExtractionOptions(OptionID, NewValue: Integer): Integer;
    function DASetTextExtractionArea(Left, Top, Width, Height: Double): Integer;
    function DASetTextExtractionScaling(Options: Integer; Horizontal, Vertical: Double): Integer;
    function DAGetTextBlockCount(TextBlockListID: Integer): Integer;
    function DAGetTextBlockFontName(TextBlockListID, Index: Integer): WideString;
    function DAGetTextBlockFontSize(TextBlockListID, Index: Integer): Double;
    function DAGetTextBlockBound(TextBlockListID, Index, BoundIndex: Integer): Double;
    function DAGetTextBlockColorType(TextBlockListID, Index: Integer): Integer;
    function DAGetTextBlockColor(TextBlockListID, Index, ColorComponent: Integer): Double;
    function DAGetTextBlockText(TextBlockListID, Index: Integer): WideString;
    function DAGetTextBlockCharWidth(TextBlockListID, Index, CharIndex: Integer): Double;
    function DAReleaseTextBlocks(TextBlockListID: Integer): Integer;
    function DASetPageMode(FileHandle: Integer; NewMode: Integer): Integer;
    function DASetPageLayout(FileHandle: Integer; NewLayout: Integer): Integer;
    function DANormalizePage(FileHandle, PageRef: Integer; NormalizeOptions: Integer): Integer;
    function DAGetTextBlockAsString(TextBlockListID, Index: Integer): WideString;

    // Layout functions
    function CreateTable(RowCount, ColumnCount: Integer): Integer;
    function SetTableColumnWidth(TableID, FirstColumn, LastColumn: Integer; NewWidth: Double): Integer;
    function SetTableRowHeight(TableID, FirstRow, LastRow: Integer; NewHeight: Double): Integer;
    function SetTableCellBorderColor(TableID, FirstRow, FirstColumn, LastRow, LastColumn, BorderIndex: Integer; Red, Green, Blue: Double): Integer;
    function SetTableCellBorderColorCMYK(TableID, FirstRow, FirstColumn, LastRow, LastColumn, BorderIndex: Integer; C, M, Y, K: Double): Integer;
    function SetTableCellBorderWidth(TableID, FirstRow, FirstColumn, LastRow, LastColumn, BorderIndex: Integer; NewWidth: Double): Integer;
    function SetTableCellBackgroundColor(TableID, FirstRow, FirstColumn, LastRow, LastColumn: Integer; Red, Green, Blue: Double): Integer;
    function SetTableCellBackgroundColorCMYK(TableID, FirstRow, FirstColumn, LastRow, LastColumn: Integer; C, M, Y, K: Double): Integer;
    function SetTableCellPadding(TableID, FirstRow, FirstColumn, LastRow, LastColumn, BorderIndex: Integer; NewPadding: Double): Integer;
    function SetTableCellAlignment(TableID, FirstRow, FirstColumn, LastRow, LastColumn, NewCellAlignment: Integer): Integer;
    function SetTableCellContent(TableID, RowNumber, ColumnNumber: Integer; const HTMLText: WideString): Integer;
    function SetTableCellTextColor(TableID, FirstRow, FirstColumn, LastRow, LastColumn: Integer; Red, Green, Blue: Double): Integer;
    function SetTableCellTextColorCMYK(TableID, FirstRow, FirstColumn, LastRow, LastColumn: Integer; C, M, Y, K: Double): Integer;
    function SetTableCellTextSize(TableID, FirstRow, FirstColumn, LastRow, LastColumn: Integer; NewTextSize: Double): Integer;
    function SetTableBorderColor(TableID, BorderIndex: Integer; Red, Green, Blue: Double): Integer;
    function SetTableBorderColorCMYK(TableID, BorderIndex: Integer; C, M, Y, K: Double): Integer;
    function SetTableBorderWidth(TableID, BorderIndex: Integer; NewWidth: Double): Integer;
    function MergeTableCells(TableID, FirstRow, FirstColumn, LastRow, LastColumn: Integer): Integer;
    function DrawTableRows(TableID: Integer; Left, Top, Height: Double; FirstRow, LastRow: Integer): Double;
    function GetTableLastDrawnRow(TableID: Integer): Integer;
    function GetTableCellStrProperty(TableID, RowNumber, ColumnNumber, Tag: Integer): WideString;
    function GetTableCellIntProperty(TableID, RowNumber, ColumnNumber, Tag: Integer): Integer;
    function GetTableCellDblProperty(TableID, RowNumber, ColumnNumber, Tag: Integer): Double;
    function GetTableRowCount(TableID: Integer): Integer;
    function GetTableColumnCount(TableID: Integer): Integer;
    function AppendTableRows(TableID, NewRowCount: Integer): Integer;
    function AppendTableColumns(TableID, NewColumnCount: Integer): Integer;
    function InsertTableRows(TableID, Position, NewRowCount: Integer): Integer;
    function InsertTableColumns(TableID, Position, NewColumnCount: Integer): Integer;
    function SetTableThinBorders(TableID, ThinBorders: Integer; Red, Green, Blue: Double): Integer;
    function SetTableThinBordersCMYK(TableID, ThinBorders: Integer; C, M, Y, K: Double): Integer;

    // Metafile
    function GetCanvasDC(CanvasWidth, CanvasHeight: Integer): Cardinal;
    function GetCanvasDCEx(CanvasWidth, CanvasHeight: Integer; ReferenceDC: Cardinal): Cardinal;

    // Delphi events
    property OnProgress: TQuickPDFProgressEvent read FOnProgress write FOnProgress;
  end;

  TDebenuPDFLibrary1114 = class(TQuickPDF);

const
  ObjCountLimit = 100;

implementation

uses
  SysUtils, Math,
{$IFDEF QPL_OS_WINDOWS}
  ActiveX,
{$ENDIF}
  DebenuPDFLibraryEncrypt, DebenuPDFLibraryDigest, DebenuPDFLibraryPageTree,
  DebenuPDFLibraryFontConst, DebenuPDFLibraryTextFunnel, DebenuPDFLibraryBarcode, DebenuPDFLibraryPrinting,
  DebenuPDFLibraryRegistry,
  DebenuPDFLibraryEncoding, DebenuPDFLibraryAnnots, DebenuPDFLibraryFileSpec, DebenuPDFLibraryCompliancePDFA,
  DebenuPDFLibraryTIFF,
{$IFDEF QPL_CAIRO}
  DebenuPDFLibraryCairo,
{$ENDIF}
{$IFDEF QPL_DPLR}
  DebenuPDFLibraryDPLR,
{$ENDIF}
  DebenuPDFLibraryGeospatial, DebenuPDFLibraryTransformation, DebenuPDFLibraryContentStreamProcessor,
  DebenuPDFLibraryLinearization;

{ TQuickPDF }

function TQuickPDF.UnlockKey(const LicenseKey: WideString): Integer;
begin
  Result := 1;
end;

function TQuickPDF.ValidFileHandle(FileHandle: Integer): TSmartPDFLink;
var
  Index: Integer;
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(FileHandle);
  if (Assigned(VCLObj)) then
  begin
    Index := FOpenFiles.IndexOf(TSmartPDFLink(VCLObj));
    if Index >= 0 then
      Result := TSmartPDFLink(VCLObj);
  end;
end;

function TQuickPDF.ValidCaptureID(CaptureID: Integer): TPDFCapturedPage;
var
  CP: TPDFCapturedPage;
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(CaptureID);
  if (VCLObj is TPDFCapturedPage) then
  begin
    CP := TPDFCapturedPage(VCLObj);
    if (FSelDoc.HasCapturedPage(CP)) then
    begin
      Result := CP;
    end;
  end;
end;

function TQuickPDF.ValidDACaptureID(CaptureID: Integer): TPDFIndRef;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(CaptureID);
  if (VCLObj is TPDFIndRef) then
  begin
    Result := TPDFIndRef(VCLObj);
  end;
end;

function TQuickPDF.ValidOCG(OptionalContentGroupID: Integer): TPDFIndRef;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(OptionalContentGroupID);
  if (VCLObj is TPDFIndRef) then
  begin
    Result := TPDFIndRef(VCLObj);
  end;
end;

function TQuickPDF.ValidOutlineID(OutlineID: Integer): TPDFIndRef;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(OutlineID);
  if (VCLObj is TPDFIndRef) then
  begin
    Result := TPDFIndRef(VCLObj);
  end;
end;

function TQuickPDF.ValidActionID(ActionID: Integer): TPDFDictionary;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(ActionID);
  if (VCLObj is TPDFDictionary) then
  begin
    Result := TPDFDictionary(VCLObj);
  end;
end;

function TQuickPDF.ValidPageRef(Link: TSmartPDFLink; PageRef: Integer): TPDFIndRef;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(PageRef);
  if (Assigned(VCLObj)) then
  begin
    if (Link.Doc.IsPage(TPDFIndRef(VCLObj))) then
    begin
      Result := TPDFIndRef(VCLObj);
    end;
  end;
end;

function TQuickPDF.ValidFontID(FontID: Integer): TPDFFont;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(FontID);
  if (VCLObj is TPDFFont) then
  begin
    Result := TPDFFont(VCLObj);
  end;
end;

function TQuickPDF.ValidDocumentID(DocumentID: Integer): TPDFDocument;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(DocumentID);
  if (VCLObj is TPDFDocument) then
  begin
    Result := TPDFDocument(VCLObj);
  end;
end;

function TQuickPDF.ValidImageID(ImageID: Integer): TPDFImage;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(ImageID);
  if (VCLObj is TPDFImage) then
  begin
    Result := TPDFImage(VCLObj);
  end;
end;

function TQuickPDF.ValidTableID(TableID: Integer): TPDFTable;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(TableID);
  if (VCLObj is TPDFTable) then
  begin
    Result := FSelDoc.FindTable(TPDFTable(VCLObj));
  end;
end;

function TQuickPDF.ValidViewPortID(ViewPortID: Integer): TPDFDictionary;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(ViewPortID);
  if (VCLObj is TPDFDictionary) then
  begin
    Result := TPDFDictionary(VCLObj);
  end;
end;

function TQuickPDF.ValidMeasureDictID(MeasureDictID: Integer): TPDFDictionary;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(MeasureDictID);
  if (VCLObj is TPDFDictionary) then
  begin
    Result := TPDFDictionary(VCLObj);
  end;
end;

function TQuickPDF.ValidCSDictID(CSDictID: Integer): TPDFDictionary;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(CSDictID);
  if (VCLObj is TPDFDictionary) then
  begin
    Result := TPDFDictionary(VCLObj);
  end;
end;

function TQuickPDF.ValidAnalysisID(AnalysisID: Integer): TQuickPDFStringList;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(AnalysisID);
  if (VCLObj is TQuickPDFStringList) then
  begin
    Result := TQuickPDFStringList(VCLObj);
  end;
end;

function TQuickPDF.ValidImageListID(Link: TSmartPDFLink; ImageListID: Integer): TPDFImageList;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(ImageListID);
  if (VCLObj is TPDFImageList) then
  begin
    if (Link.Doc.HasImageList(TPDFImageList(VCLObj))) then
    begin
      Result := TPDFImageList(VCLObj);
    end;
  end;
end;

function TQuickPDF.ValidDATextBlockListID(TextBlockListID: Integer): TPDFTextList;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(TextBlockListID);
  if (VCLObj is TPDFTextList) then
  begin
    if (FTextBlockLists.IndexOf(TPDFTextList(VCLObj)) >= 0) then
    begin
      Result := TPDFTextList(VCLObj);
    end;
  end;
end;

function TQuickPDF.ValidTextBlockListID(TextBlockListID: Integer): TPDFTextList;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(TextBlockListID);
  if (VCLObj is TPDFTextList) then
  begin
    Result := TPDFTextList(VCLObj);
  end;
end;

function TQuickPDF.IntCast(VCLObj: TObject): Integer;
var
  I: Integer;
  X: Integer;
begin
  if (Assigned(VCLObj)) then
  begin
    I := -1;
    X := 0;
    while ((I < 0) and (X < FIntCasts.Count)) do
    begin
      if (FIntCasts[X] = VCLObj) then
      begin
        I := X;
      end else
      begin
        Inc(X);
      end;
    end;
    if (I < 0) then
    begin
      FIntCasts.Add(VCLObj);
      I := FIntCasts.Count - 1;
    end;
    Result := $58000000 + I;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.IntUncast(IntCast: Integer): TObject;
begin
  Result := nil;
  if (IntCast and $58000000 = $58000000) then
  begin
    IntCast := IntCast and $07FFFFFF;
    if ((IntCast >= 0) and (IntCast < FIntCasts.Count)) then
    begin
      Result := FIntCasts[IntCast];
    end;
  end;
end;

function TQuickPDF.GetPrinter: TPrinter;
begin
{$IFDEF QPL_OS_MAC}
  Result := nil;
{$ELSE}
  if (Assigned(FPrinter)) then
  begin
    Result := FPrinter;
  end else
  begin
{$IFDEF QPL_BUILD_DLLORACTIVEX}
    FPrinter := TPrinter.Create;
    Result := FPrinter;
{$ELSE}
    Result := Printer;
{$ENDIF}
  end;
{$ENDIF}
end;

function TQuickPDF.DAExtractPageText(FileHandle, PageRef, Options: Integer): WideString;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := '';
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
    begin
      Result := Link.Doc.ExtractPageText(Page, Options, FDATextExtractOptions);
    end;
  end;
end;

function TQuickPDF.DAGetPageContentToString(FileHandle, PageRef: Integer): AnsiString;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := '';
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
    begin
      Result := Link.Doc.GetPageContents(Page);
    end;
  end;
end;

function TQuickPDF.DAAppendFile(FileHandle: Integer): Integer;
var
  Link: TSmartPDFLink;
  OutStream: TMemoryStream;
  Writer: TSmartPDFWriter;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    if Link.ReadOnlyAccess then
    begin
      Result := 2;
    end else
    if (Link.Reader.ShiftedHeader) then
    begin
      Result := 3;
    end else
    begin
      OutStream := TMemoryStream.Create;
      try
        if (not Link.Doc.UserModDate) then
        begin
          Link.Doc.SetInformation('ModDate', WideString(GetPDFDateTime));
        end;
        Writer := TSmartPDFWriter.Create(OutStream);
        try
          Link.Reader.FixTrailer;
          if (Link.Reader.HasXRefStream) then
          begin
            Writer.AddXRefStream(Link.Doc.WriteNewObjects(Writer), Link.Stream.Size);
          end else
          begin
            Writer.AddTrailer(Link.Doc.WriteNewObjects(Writer), Link.Stream.Size);
          end;

          Link.Stream.Seek(Link.Stream.Size, soBeginning);
          OutStream.Seek(0, soBeginning);
          Link.Stream.CopyFrom(OutStream, OutStream.Size);
          DACloseFile(FileHandle);
          Result := 1;
        finally
          Writer.Free;
        end;
      finally
        OutStream.Free;
      end;
    end;
  end;
end;

function TQuickPDF.DACloseFile(FileHandle: Integer): Integer;
var
  Index: Integer;
  Link: TSmartPDFLink;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Index := FOpenFiles.IndexOf(Link);
    if Index >= 0 then
    begin
      Link.Free;
      FOpenFiles.Delete(Index);
      Result := 1;
    end;
  end;
end;

function TQuickPDF.DAOpenFile(const InputFileName,
  Password: WideString): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  if FUnlocked then
  begin
    Link := TSmartPDFLink.Create(InputFileName, Password);
    if Link.Okay then
    begin
      FOpenFiles.Add(Link);
      Result := IntCast(Link);
    end else
    begin
      if Link.OpenProblem = 'CouldNotOpen' then FLastErrorCode := 401;
      if Link.OpenProblem = 'BadPassword' then FLastErrorCode := 404;
      if Link.OpenProblem = 'BadStructure' then FLastErrorCode := 409;
      if Link.OpenProblem = 'FileNotFound' then FLastErrorCode := 411;
      Link.Free;
    end;
  end;
end;

function TQuickPDF.DAOpenFileReadOnly(const InputFileName,
  Password: WideString): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  if FUnlocked then
  begin
    Link := TSmartPDFLink.Create(InputFileName, Password, True);
    if Link.Okay then
    begin
      FOpenFiles.Add(Link);
      Result := IntCast(Link);
    end else
    begin
      if Link.OpenProblem = 'CouldNotOpen' then FLastErrorCode := 401;
      if Link.OpenProblem = 'BadPassword' then FLastErrorCode := 404;
      if Link.OpenProblem = 'BadStructure' then FLastErrorCode := 409;
      if Link.OpenProblem = 'FileNotFound' then FLastErrorCode := 411;      
      Link.Free;
    end;
  end;
end;

function TQuickPDF.DASaveAsFile(FileHandle: Integer;
  const OutputFileName: WideString): Integer;
var
  Link: TSmartPDFLink;
  Writer: TSmartPDFWriter;
  TempStruct: TPDFStructure;
  FS: TQuickPDFWideFileStream;
  X: Integer;
  Obj: TPDFObject;
  OC: Integer;
begin
  Result := 0;
  FLastErrorCode := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    if QPLFileExists(OutputFileName) then
    begin
      if QPLDeleteFile(OutputFileName) then FLastErrorCode := 0 else
        FLastErrorCode := 402;
    end;
    if FLastErrorCode <> 402 then
    try
      FS := QPLCreateFileStream(OutputFileName, fmCreate or fmShareExclusive);
      try
        Writer := TSmartPDFWriter.Create(FS);
        try
          Writer.New(Link.Reader.Version);
          TempStruct := TPDFStructure.Create;
          try
            FSubProgressScale := 1;
            FSubProgressOffset := 0;
            if (not Link.Doc.UserModDate) then
            begin
              Link.Doc.SetInformation('ModDate', WideString(GetPDFDateTime));
            end;
            OC := Link.Doc.ObjectCount;
            for X := 1 to OC do
            begin
              SubProgress(X * 100 div OC);
              Obj := Link.Doc.GetObject(X, TempStruct);
              if Assigned(Obj) then
                Writer.AddObject(X, Link.Doc.GetGenNum(X), Obj.Output)
              else
                Writer.AddObject(X, Link.Doc.GetGenNum(X), 'null');
              if TempStruct.ObjectCount > ObjCountLimit then
              begin
                TempStruct.Free;
                TempStruct := TPDFStructure.Create;
              end;
            end;
            EndProgress;
            Result := 1;
          finally
            TempStruct.Free;
          end;
          Link.Reader.FixTrailer;
          Writer.AddTrailer(Link.Reader.TrailerDict, 0, True);
          DACloseFile(FileHandle);
        finally
          Writer.Free;
        end;
      finally
        FS.Free;
      end;
    except
      FLastErrorCode := 403;
    end;
  end else
    FLastErrorCode := 501;
end;

function TQuickPDF.DAGetInformation(FileHandle: Integer;
  const Key: WideString): WideString;
var
  Link: TSmartPDFLink;
  Len: Integer;
begin
  Result := '';
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
    Result := Link.Doc.GetInformation(AnsiString(Key));

  if (Key = 'ModDate') or (Key = 'CreationDate') then
  begin
    if not QPLStartsWith(AnsiString(Result), 'D:') then
      Result := 'D:' + Result;

    Len := Length(Result);
    if (Len >= 6) and (Len < 23) then
      Result := Result + WideString(QPLCopy('0101000000-00''00''', Len-6+1, MaxInt));
    if (Length(Result) <> 23) then
    begin
      Result := '';
      FLastErrorCode := 999;
    end;
  end;
end;

function TQuickPDF.DASetInformation(FileHandle: Integer; const Key,
  NewValue: WideString): Integer;
var
  Link: TSmartPDFLink;
  KeyA: AnsiString;
begin
  KeyA := AnsiString(Key);

  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Result := 1;
    Link.Doc.SetInformation(KeyA, NewValue);
    if (Key = 'ModDate') then
    begin
      Link.Doc.UserModDate := True;
    end;
  end;
end;

function TQuickPDF.DANewPages(FileHandle, PageCount: Integer): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Link.Doc.NewPages(PageCount);
    Result := Link.Doc.PageCount;
  end;
end;

function TQuickPDF.DAHidePage(FileHandle, PageRef: Integer): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
    begin
      Result := 1;
      Link.Doc.HidePage(Page);
    end;
  end;
end;

function TQuickPDF.DACapturePage(FileHandle, PageRef: Integer): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
      Result := IntCast(Link.Doc.CapturePage(Page, 0));
  end;
end;

function TQuickPDF.DADrawCapturedPage(FileHandle, DACaptureID,
  DestPageRef: Integer; PntLeft, PntBottom, PntWidth, PntHeight: Double): Integer;
var
  Link: TSmartPDFLink;
  DestPage: TPDFIndRef;
  CapturePageRef: TPDFIndRef;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    DestPage := ValidPageRef(Link, DestPageRef);
    if Assigned(DestPage) then
    begin
      CapturePageRef := ValidDACaptureID(DACaptureID);
      if Assigned(CapturePageRef) then
      begin
        Result := 1;
        Link.Doc.DrawCapturedPage(DestPage, CapturePageRef,
          PntLeft, PntBottom, PntWidth, PntHeight);
      end;
    end;
  end;
end;

function TQuickPDF.DAGetPageCount(FileHandle: Integer): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
    Result := Link.Doc.PageCount;
end;

function TQuickPDF.DASetPageSize(FileHandle, PageRef: Integer; PntWidth,
  PntHeight: Double): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
    begin
      Result := 1;
      Link.Doc.SetPageSize(Page, PntWidth, PntHeight);
    end;
  end;
end;

function TQuickPDF.DANewPage(FileHandle: Integer): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
    Result := IntCast(Link.Doc.NewPage);
end;

function TQuickPDF.DAFindPage(FileHandle, Page: Integer): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
    Result := IntCast(Link.Doc.FindPage(Page));
end;

function TQuickPDF.DAGetPageHeight(FileHandle, PageRef: Integer): Double;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
      Result := Link.Doc.GetPageHeight(Page);
  end;
end;

function TQuickPDF.DAGetPageWidth(FileHandle, PageRef: Integer): Double;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
    begin
      Result := Link.Doc.GetPageWidth(Page);
    end;
  end;
end;

function TQuickPDF.AddCurveToPath(CtAX, CtAY, CtBX, CtBY, EndX,
  EndY: Double): Integer;
begin
  FSelDoc.PageTree.Painter.AddCurveToPath(TranslateX(CtAX), TranslateY(CtAY),
    TranslateX(CtBX), TranslateY(CtBY), TranslateX(EndX), TranslateY(EndY));
  Result := 1;
end;

function TQuickPDF.AddLineToPath(EndX, EndY: Double): Integer;
begin
  FSelDoc.PageTree.Painter.AddLineToPath(TranslateX(EndX), TranslateY(EndY));
  Result := 1;
end;

function TQuickPDF.AddLinkToPage(Left, Top, Width, Height: Double;
  Page: Integer; Position: Double; Options: Integer): Integer;
begin
  FSelDoc.PageTree.AddLinkToPage(TranslateX(Left), TranslateY(Top),
    GetScale(Width), GetScale(Height), Page, TranslateY(Position), Options);
  Result := 1;
end;

function TQuickPDF.AddLinkToWeb(Left, Top, Width, Height: Double;
  const Link: WideString; Options: Integer): Integer;
begin
  FSelDoc.PageTree.AddLinkToWeb(TranslateX(Left), TranslateY(Top),
    GetScale(Width), GetScale(Height), AnsiString(Link), Options);
  Result := 1;
end;

function TQuickPDF.AddStandardFont(StandardFontID: Integer): Integer;
var
  Font: TPDFFont;
begin
  Font := FSelDoc.NewStdFont(TPDFStdFont(StandardFontID));
  if Font <> nil then
  begin
    Result := IntCast(Font);
    SelectFont(Result);
  end else
    Result := 0;
end;

function TQuickPDF.AddTrueTypeFont(const FontName: WideString;
  Embed: Integer): Integer;
var
  Font: TPDFFont;
begin
  Font := FSelDoc.NewTrueTypeFont(AnsiString(FontName), (Embed = 1) or (Embed = 2),
    Embed = 2, FKernSupport <> ksNoLoad);
  if Font <> nil then
  begin
    Result := IntCast(Font);
    SelectFont(Result);
  end else
    Result := 0;
end;

function TQuickPDF.CharWidth(CharCode: Integer): Integer;
begin
  if Assigned(FSelFont) then
    Result := FSelFont.CharWidth(CharCode)
  else
    Result := 0;
end;

function TQuickPDF.ClonePages(StartPage, EndPage,
  RepeatCount: Integer): Integer;
begin
  if (StartPage >= 1) and (EndPage >= 1) and
    (EndPage >= StartPage) and (EndPage <= PageCount) then
  begin
    FSelDoc.PageTree.ClonePages(StartPage, EndPage, RepeatCount);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.ClosePath: Integer;
begin
  FSelDoc.PageTree.Painter.ClosePath;
  Result := 1;
end;

function TQuickPDF.CombineContentStreams: Integer;
begin
  if FSelDoc.PageTree.CombineLayers then
    Result := 1
  else
    Result := 0;
  SelectPage(SelectedPage);
end;

function TQuickPDF.CompressContent: Integer;
var
  OldPage: Integer;
begin
  OldPage := SelectedPage;
  try
    FSelDoc.Compress;
    Result := 1;
  finally
    SelectPage(OldPage);
  end;
end;

function TQuickPDF.CompressImages(Compress: Integer): Integer;
begin
  if (Compress >= 0) and (Compress <= 1) then
  begin
    FSelDoc.CompressImages := Compress;
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.CompressPage: Integer;
begin
  FSelDoc.CompressPage(FSelDoc.PageTree.Page);
  Result := 1;
  SelectPage(SelectedPage);
end;

constructor TQuickPDF.Create;
var
  Doc: TPDFDocument;
{$IFDEF QPL_OS_WINDOWS}
  CoInitResult: HRESULT;
{$ENDIF}
begin
  FSubProgressPiece := 1;
  FSubProgressCount := 1;
  FLicenseInfo := 'Source Code License';
  FUnlocked := True;
  FLastErrorCode := 0;
  FAnalysisInfo := TObjectList.Create(True);
  FFileLists := TQuickPDFStringList.Create;
  FStringLists := TObjectList.Create(True);
  FIntCasts := TObjectList.Create(False);
  FImageLists := TObjectList.Create(True);
  FSignProcessList := TObjectList.Create(True);
  FTextBlockLists := TObjectList.Create(True);
  FPrintToFile := '';
  FPrintPreview := False;
  FPrintPreviewMaxDimension := 0;
  FPrintPreviewBitmapData := '';
  FAppendInput := '';
  FDefaultDecodeMode := 2;

  FOpenFiles := TObjectList.Create(False);

  DefaultGDIPlusSettings(FGDIPlusSettings);

  FJPEGQuality := 75;
  FPrintTitles := TQuickPDFStringList.Create;
  FCustomPrinters := TQuickPDFStringList.Create;
  FNoEmbedFontList := TQuickPDFStringList.Create;
  FKernSupport := ksLoadNoUse;
  FMetafile := nil;
  FMetafileCanvas := nil;
  FMetafileWidth := 0;
  FMetafileHeight := 0;
  PNGTransparencyColor := clWhite;
  HasPNGTransparency := False;

  FDATextExtractOptions.WordGap := 0.7;
  FDATextExtractOptions.IgnoreFont := False;
  FDATextExtractOptions.IgnoreColor := False;
  FDATextExtractOptions.IgnoreBlocks := False;
  FDATextExtractOptions.SortBlocks := False;
  FDATextExtractOptions.SplitOnDoubleSpace := False;
  FDATextExtractOptions.TrimCharsOutsideArea := False;
  FDATextExtractOptions.IgnoreDescenders := False;
  FDATextExtractOptions.IgnoreOverlaps := False;
  FDATextExtractOptions.IgnoreDuplicates := False;
  FDATextExtractOptions.HasArea := False;
  FDATextExtractOptions.OutputCMYK := False;
  FDATextExtractOptions.HorzScaleFactor := 5;
  FDATextExtractOptions.VertScaleFactor := 8;

  FRenderDCOffsetX := 0;
  FRenderDCOffsetY := 0;
  FRenderDCErasePage := True;
  FRenderScale := 1;
  FFindImagesMode := 1;
  FRenderCropType := 2;  // CropBox

  FTempPath := QPLGetTempFolder;

  FPrinter := nil;

{$IFDEF QPL_CAIRO}
  FCairoFileName := '';
  FUseCairo := False;
{$ENDIF}

{$IFDEF QPL_DPLR}
  FDPLRFileName := '';
  FUseDPLR := False;
{$ENDIF}

{$IFDEF QPL_OS_WINDOWS}
  CoInitResult := CoInitialize(nil);
  FNeedCoUninit := (CoInitResult = S_OK) or (CoInitResult = S_FALSE);
{$ENDIF}

  FDocs := TObjectList.Create(True);
  Doc := TPDFDocument.Create;
  Doc.DecodeMode := FDefaultDecodeMode;
  Doc.CreateBlank;
  Doc.SetInfo('Producer', WideString(ProductID));
  Doc.SetInfo('Creator', WideString(ProductID));
  Doc.SetInfo('CreationDate', WideString(GetPDFDateTime));
  Doc.SetInfo('ModDate', WideString(GetPDFDateTime));
  FDocs.Add(Doc);
  SelectDocument(IntCast(Doc));
  SelectPage(1);
end;

function TQuickPDF.DeleteContentStream: Integer;
begin
  Result := 0;
  if FSelDoc.PageTree.LayerCount > 1 then
  begin
    if FSelDoc.PageTree.DeleteLayer then Result := 1;
  end;
end;

function TQuickPDF.DeletePages(StartPage, PageCount: Integer): Integer;
var
  OldPageCount: Integer;
  DeletedPageRefs: array of TPDFIndRef;
  PageNum: Integer;
  OutlineIndex: Integer;
begin
  Result := 0;
  if PageCount > 0 then
  begin
    OldPageCount := FSelDoc.PageCount;
    if (StartPage > 0) and (StartPage <= OldPageCount) then
    begin
      if (StartPage + PageCount - 1) > OldPageCount then
        PageCount := (OldPageCount - StartPage) + 1;
      if PageCount < 1 then PageCount := 1;
      if StartPage = 1 then
      begin
        if PageCount = OldPageCount then Dec(PageCount);
      end;
      if PageCount >= 1 then
      begin
        // Store the page refs of the pages that will be deleted
        SetLength(DeletedPageRefs, PageCount);
        for PageNum := StartPage to StartPage + PageCount - 1 do
        begin
          DeletedPageRefs[PageNum - StartPage] := FSelDoc.PageTree.GetPageRef(PageNum);
        end;

        // Delete the page
        FSelDoc.PageTree.DeletePages(StartPage, PageCount);

        // Setup the return and clean up the page tree
        if FSelDoc.PageCount = OldPageCount - PageCount then
          Result := FSelDoc.PageCount;
        FSelDoc.PageTree.ForgetPages;
        SelectPage(1);
        SelectFont(SelectedFont);

        // Update any outlines that pointed to the deleted pages
        for OutlineIndex := 1 to FSelDoc.OutlineCount do
        begin
          FSelDoc.UnlinkOutlineFromPageList(FSelDoc.GetOutlineFromIndex(OutlineIndex), DeletedPageRefs);
        end;
      end;
    end;
  end;
end;

destructor TQuickPDF.Destroy;
var
  X: Integer;
begin
  try
    FDocs.Free;
  except
  end;

  FAnalysisInfo.Free;
  FStringLists.Free;
  FIntCasts.Free;
  FImageLists.Free;
  FSignProcessList.Free;
  FTextBlockLists.Free;

  for X := 0 to FFileLists.Count - 1 do
  begin
    if Assigned(FFileLists.Objects[X]) then
      FFileLists.Objects[X].Free;
  end;
  FFileLists.Free;

  for X := 0 to FOpenFiles.Count - 1 do
    FOpenFiles[X].Free;
  FOpenFiles.Free;

  FPrintTitles.Free;
  FNoEmbedFontList.Free;

  for X := 0 to FCustomPrinters.Count - 1 do
    FCustomPrinters.Objects[X].Free;
  FCustomPrinters.Free;

  if Assigned(FMetafileCanvas) then
    FMetafileCanvas.Free;

  if Assigned(FMetafile) then
    FMetafile.Free;

  if (Assigned(FPrinter)) then
  begin
    FPrinter.Free;
  end;

{$IFDEF QPL_OS_WINDOWS}
  if (FNeedCoUninit) then
  begin
    CoUninitialize;
  end;
{$ENDIF}

  inherited Destroy;
end;

function TQuickPDF.DocumentCount: Integer;
begin
  Result := FDocs.Count;
end;

function TQuickPDF.GetDocumentID(Index: Integer): Integer;
begin
  if ((Index > 0) and (Index <= FDocs.Count)) then
  begin
    Result := IntCast(FDocs.Items[Index - 1]);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.DrawArc(XPos, YPos, Radius, StartAngle,
  EndAngle: Double; Pie, DrawOptions: Integer): Integer;
var
  Fill: Boolean;
  Outline: Boolean;
  Close: Boolean;
begin
  if Abs(StartAngle - EndAngle) <= 360 then
  begin
    Fill := (DrawOptions = 1) or (DrawOptions = 2) or (DrawOptions = 3);
    Outline := (DrawOptions = 0) or (DrawOptions = 2) or (DrawOptions = 3);
    Close := (DrawOptions = 3);
    FSelDoc.PageTree.Painter.Arc(TranslateX(XPos), TranslateY(YPos),
      GetScale(Radius), StartAngle, EndAngle, Pie = 1, Fill, Outline, Close);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.DrawBarcode(Left, Top, Width, Height: Double;
  const Text: WideString; Barcode, Options: Integer): Integer;
var
  X: Integer;
  ValidChar: AnsiString;
  Valid: Boolean;
  CheckTotal: Integer;
  CheckDigit: Integer;
  BarText: AnsiString;
  Rotation: TBarcodeRotation;
  PainterState: AnsiString;
  BarWidthReduction: Boolean;
begin
  BarWidthReduction := Options >= 10;
  if BarWidthReduction then Dec(Options, 10);
  if (not Assigned(FSelFont)) then AddStandardFont(4);
  PainterState := FSelDoc.PageTree.Painter.GetState;
  try
    BarText := AnsiString(Text);
    Rotation := brNormal;

    if QPLCopy(BarText, Length(BarText) - 2, 3) = '/RC' then Rotation := brClockwise;
    if QPLCopy(BarText, Length(BarText) - 2, 3) = '/RA' then Rotation := brAntiClockwise;
    if QPLCopy(BarText, Length(BarText) - 2, 3) = '/RU' then Rotation := brUpsideDown;
    if Rotation <> brNormal then
      Delete(BarText, Length(BarText) - 2, 3);

    if not (FSelDoc.FillSet) then
    begin
      SetFillColor(0, 0, 0);
      FSelDoc.FillSet := False;
    end;
    FLastErrorCode := 0;

    if ((Barcode = 1) and (Options = 0)) or
      ((Barcode = 2) and (Options >= 0) and (Options <= 3)) or
      ((Barcode = 3) and (Options = 0)) or
      ((Barcode = 4) and (Options = 0)) or
      ((Barcode = 5) and (Options >= 0) and (Options <= 3)) then
    begin
      Valid := False;
      if Barcode = 1 then Valid := True;
      if Barcode = 2 then
      begin
        Valid := Length(BarText) = 13;
        for X := 1 to Length(BarText) do
        begin
          if (BarText[X] < '0') or (BarText[X] > '9') then
          begin
            Valid := False;
            FLastErrorCode := 302;
          end;
        end;
        if Valid then
        begin
          CheckTotal := 0;
          for X := 1 to 12 do
          begin
            if (X mod 2) = 1 then
              CheckTotal := CheckTotal + Ord(BarText[X]) - 48
            else
              CheckTotal := CheckTotal + (Ord(BarText[X]) - 48) * 3;
          end;
          CheckDigit := 0;
          while (CheckDigit + CheckTotal) mod 10 <> 0 do
            Inc(CheckDigit);
          if QPLIntToStr(CheckDigit) <> BarText[13] then
          begin
            Valid := False;
            FLastErrorCode := 303;
          end;
        end;
      end else
      if Barcode = 3 then
      begin
        Valid := True;
        ValidChar := '';
        for X := 32 to 126 do
          ValidChar := ValidChar + AnsiChar(X);
        for X := 1 to Length(BarText) do
        begin
          if QPLPos(BarText[X], ValidChar) = 0 then
            Valid := False;
        end;
      end else
      if Barcode = 4 then
      begin
        BarText := '';
        for X := 1 to Length(Text) do
          if (Text[X] >= '0') and (Text[X] <= '9') then BarText := BarText + AnsiChar(Text[X]);
        Valid := (Length(BarText) = 5) or (Length(BarText) = 9) or
          (Length(BarText) = 11);
      end else
      if Barcode = 5 then
      begin
        BarText := '';
        for X := 1 to Length(Text) do
          if (Text[X] >= '0') and (Text[X] <= '9') then BarText := BarText + AnsiChar(Text[X]);
        if (Options = 0) or (Options = 2) then
        begin
          if (Length(BarText) >= 2) and (Length(BarText) mod 2 = 0) then
            Valid := True;
        end else
        if (Options = 1) or (Options = 3) then
        begin
          if (Length(BarText) >= 1) and (Length(BarText) mod 2 = 1) then
          begin
            Valid := True;
            CheckTotal := 0;
            for X := 1 to Length(BarText) do
              if X mod 2 = 1 then
                CheckTotal := CheckTotal + 3 * QPLStrToInt(BarText[X])
              else
                CheckTotal := CheckTotal + QPLStrToInt(BarText[X]);
            CheckDigit := 0;
            while (CheckDigit + CheckTotal) mod 10 <> 0 do
              Inc(CheckDigit);
            BarText := BarText + QPLIntToStr(CheckDigit);
          end;
        end;
      end;
      if Valid then
      begin
        Result := 1;
        FLastErrorCode := 0;
        FSelDoc.PageTree.Painter.DrawBarcode(TranslateX(Left), TranslateY(Top),
          GetScale(Width), GetScale(Height), BarText, Barcode, Options, Rotation,
          BarWidthReduction);
      end else
        Result := 0;
    end else
    begin
      FLastErrorCode := 301;
      Result := 0;
    end;
  finally
    FSelDoc.PageTree.Painter.SetState(PainterState);
  end;
end;

function TQuickPDF.DrawBox(Left, Top, Width, Height: Double;
  DrawOptions: Integer): Integer;
var
  Fill: Boolean;
  Outline: Boolean;
begin
  Fill := (DrawOptions = 1) or (DrawOptions = 2);
  Outline := (DrawOptions = 0) or (DrawOptions = 2);
  FSelDoc.PageTree.Painter.Rectangle(TranslateX(Left), TranslateY(Top),
    GetScale(Width), GetScale(Height), Fill, Outline);
  Result := 1;
end;

function TQuickPDF.DrawCircle(XPos, YPos, Radius: Double;
  DrawOptions: Integer): Integer;
var
  Fill: Boolean;
  Outline: Boolean;
begin
  Fill := (DrawOptions = 1) or (DrawOptions = 2);
  Outline := (DrawOptions = 0) or (DrawOptions = 2);
  FSelDoc.PageTree.Painter.Circle(TranslateX(XPos), TranslateY(YPos),
    GetScale(Radius), Fill, Outline);
  Result := 1;
end;

function TQuickPDF.DrawHTMLText(Left, Top, Width: Double;
  const HTMLText: WideString): Integer;
var
  PainterState: AnsiString;
begin
  if Width > 0 then
  begin
    CheckFontSelection;
    PainterState := FSelDoc.PageTree.Painter.GetState;
    try
      FSelDoc.PageTree.Painter.Reset;
      FSelDoc.PageTree.Painter.ClearTextFormatting;
      if HTMLText <> '' then
      begin
        FSelDoc.SetHTMLFonts;
        FSelDoc.PageTree.Painter.DrawHTMLText(TranslateX(Left), TranslateY(Top),
          GetScale(Width), HTMLText);
      end;
    finally
      FSelDoc.PageTree.Painter.SetState(PainterState);
    end;
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.DrawImage(Left, Top, Width, Height: Double): Integer;
begin
  if Assigned(FSelImage) then
  begin
    FSelDoc.PageTree.UseImage(FSelImage);
    FSelDoc.PageTree.Painter.DrawImage(FSelImage, TranslateX(Left),
      TranslateY(Top), GetScale(Width), GetScale(Height));
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.DrawLine(StartX, StartY, EndX, EndY: Double): Integer;
begin
  FSelDoc.PageTree.Painter.DrawLine(TranslateX(StartX), TranslateY(StartY),
    TranslateX(EndX), TranslateY(EndY));
  Result := 1;
end;

function TQuickPDF.DrawMultiLineText(XPos, YPos: Double;
  const Delimiter, Text: WideString): Integer;
begin
  if Text <> '' then
  begin
    CheckFontSelection;
    FSelDoc.PageTree.Painter.DrawMultiLineWideText(TranslateX(XPos),
      TranslateY(YPos), Delimiter, FixWideDelimited(Text, Delimiter));
  end;
  Result := 1;
end;

function TQuickPDF.DrawPath(PathOptions: Integer): Integer;
var
  Fill: Boolean;
  Outline: Boolean;
begin
  Fill := (PathOptions = 1) or (PathOptions = 2);
  Outline := (PathOptions = 0) or (PathOptions = 2);
  FSelDoc.PageTree.Painter.DrawPath(Fill, Outline);
  Result := 1;
end;

function TQuickPDF.DrawRotatedText(XPos, YPos, Angle: Double;
  const Text: WideString): Integer;
begin
  if (Text <> '') and (Angle >= 0) and (Angle <= 360) then
  begin
    CheckFontSelection;
    FSelDoc.PageTree.Painter.DrawRotatedWideText(TranslateX(XPos),
      TranslateY(YPos), Angle, FSelFont.FixWideText(Text));
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.DrawRoundedBox(Left, Top, Width, Height,
  Radius: Double; DrawOptions: Integer): Integer;
var
  Fill: Boolean;
  Outline: Boolean;
begin
  Fill := (DrawOptions = 1) or (DrawOptions = 2);
  Outline := (DrawOptions = 0) or (DrawOptions = 2);
  FSelDoc.PageTree.Painter.RoundedRectangle(TranslateX(Left), TranslateY(Top),
    GetScale(Width), GetScale(Height), GetScale(Radius), Fill, Outline);
  Result := 1;
end;

function TQuickPDF.DrawRoundedRotatedBox(Left, Bottom, Width, Height,
  Radius, Angle: Double; DrawOptions: Integer): Integer;
var
  Fill: Boolean;
  Outline: Boolean;
begin
  Fill := (DrawOptions = 1) or (DrawOptions = 2);
  Outline := (DrawOptions = 0) or (DrawOptions = 2);
  FSelDoc.PageTree.Painter.RoundedRotatedRectangle(TranslateX(Left), TranslateY(Bottom),
    GetScale(Width), GetScale(Height), GetScale(Radius), Angle, Fill, Outline);
  Result := 1;
end;

function TQuickPDF.DrawScaledImage(Left, Top, Scale: Double): Integer;
var
  Width, Height: Double;
begin
  if Assigned(FSelImage) then
  begin
    Width := FSelImage.Width * Scale;
    Height := FSelImage.Height * Scale;
    FSelDoc.PageTree.UseImage(FSelImage);
    FSelDoc.PageTree.Painter.DrawImage(FSelImage, TranslateX(Left),
      TranslateY(Top), Width, Height);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.DrawSpacedText(XPos, YPos, Spacing: Double;
  const Text: WideString): Integer;
var
  X: Integer;
begin
  CheckFontSelection;
  for X := 1 to Length(Text) do
  begin
    DrawText(XPos + (X - 1) * Spacing, YPos, FSelFont.FixWideText(Text[X]));
  end;
  Result := 1;
end;

function TQuickPDF.DrawText(XPos, YPos: Double;
  const Text: WideString): Integer;
begin
  if Text <> '' then
  begin
    CheckFontSelection;
    FSelDoc.PageTree.Painter.DrawWideText(TranslateX(XPos), TranslateY(YPos),
      FSelFont.FixWideText(Text));
  end;
  Result := 1;
end;

function TQuickPDF.DrawTextBox(Left, Top, Width, Height: Double;
  const Text: WideString; Options: Integer): Integer;
begin
  if (Options >= 0) and (Options <= 5) and (Width >= MinTW) then
  begin
    CheckFontSelection;

    Result := FSelDoc.PageTree.Painter.DrawWideTextBox(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), FixWideDelimited(Text, FSelDoc.BreakString),
      Options, FSelDoc.BreakString);
  end else
    Result := 0;
end;

function TQuickPDF.DrawWrappedText(XPos, YPos, Width: Double;
  const Text: WideString): Integer;
begin
  CheckFontSelection;
  if Width < MinTW then
    Result := 0
  else
  begin
    if Text <> '' then
    begin
      FSelDoc.PageTree.Painter.DrawWrappedWideText(TranslateX(XPos),
        TranslateY(YPos), GetScale(Width), FixWideDelimited(Text, FSelDoc.BreakString), FSelDoc.BreakString);
    end;
    Result := 1;
  end;
end;

function TQuickPDF.EditableContentStream: Integer;
begin
  if FSelDoc.PageTree.CanDraw then Result := 1 else Result := 0;
end;

function TQuickPDF.Encrypt(const Owner, User: WideString; Strength,
  Permissions: Integer): Integer;
var
  Perm: TPDFPermissions;
  ExtraPerm: TPDFExtraPermissions;
  EncStrength: TPDFEncryptionStrength;
  OwnerA: AnsiString;
  UserA: AnsiString;
begin
  if ((Strength = 3) or (Strength = 4)) then
  begin
    OwnerA := QPLUTF8Encode(Owner);
    UserA := QPLUTF8Encode(User);
  end else
  begin
    OwnerA := AnsiString(Owner);
    UserA := AnsiString(User);
  end;

  Result := 0;
  FLastErrorCode := 0;

  if ((FSelDoc.PDFAMode <> 1) and (FSelDoc.PDFAMode <> 2)) then
  begin
    if EncryptionStatus = 0 then
    begin
      if ((Strength >= 0) and (Strength <= 4)) then
      begin
        if (((Permissions and $FFFF) xor $ABCD) and $FF) = ((Permissions and $FF0000) shr 16) then
        begin
          Perm := [];
          ExtraPerm := [];
          if Permissions and 1 = 1 then Perm := Perm + [ppCanPrint];
          if Permissions and 2 = 2 then Perm := Perm + [ppCanCopy];
          if Permissions and 4 = 4 then Perm := Perm + [ppCanChange];
          if Permissions and 8 = 8 then Perm := Perm + [ppCanAddNotes];
          if Permissions and 16 = 16 then ExtraPerm := ExtraPerm + [ppCanFillFields];
          if Permissions and 32 = 32 then ExtraPerm := ExtraPerm + [ppCanCopyAccess];
          if Permissions and 64 = 64 then ExtraPerm := ExtraPerm + [ppCanAssemble];
          if Permissions and 128 = 128 then ExtraPerm := ExtraPerm + [ppCanPrintFull];

          EncStrength := esStd;
          if Strength = 1 then EncStrength := es128Bit;
          if Strength = 2 then
          begin
            EncStrength := esAES128Bit;
            FSelDoc.SetMinimumVersion('1.6');
          end;
          if Strength = 3 then
          begin
            EncStrength := esAES256Bit;
            FSelDoc.SetMinimumVersion('1.7');
          end;
          if Strength = 4 then
          begin
            EncStrength := esAES256BitAcroX;
            FSelDoc.SetMinimumVersion('1.7');
            FSelDoc.SetExtensionLevel('8');
          end;

          if FSelDoc.Encrypt(OwnerA, UserA, EncStrength, Perm, ExtraPerm)
            then Result := 1 else FLastErrorCode := 104;

          //FSelDoc.Reload;
        end else
          FLastErrorCode := 102;
      end else
        FLastErrorCode := 101;
    end else
      FLastErrorCode := 103;
  end else
  begin
    Result := 0;
    FLastErrorCode := 601;
  end;
end;

function TQuickPDF.EncryptionStatus: Integer;
begin
  Result := Ord(FSelDoc.Encrypted);
end;

function TQuickPDF.EncryptionStrength: Integer;
begin
  Result := FSelDoc.EncryptionStrength;
end;

function TQuickPDF.ExtractPages(StartPage,
  PageCount: Integer): Integer;
var
  DocID: Integer;
  OldDoc: TPDFDocument;
begin
  FLastErrorCode := 0;
  if StartPage > FSelDoc.PageCount then StartPage := FSelDoc.PageCount;
  if (StartPage + PageCount - 1) > FSelDoc.PageCount then
    PageCount := FSelDoc.PageCount - StartPage + 1;
  OldDoc := FSelDoc;
  DocID := NewDocument;
  if (FSelDoc.CopyPagesFromDoc(OldDoc, QPLIntToStr(StartPage) + '-' +
    QPLIntToStr(StartPage + PageCount - 1))) then
  begin
    Result := LoadFromString(SaveToString, '');
    RemoveDocument(IntCast(OldDoc));
  end else
  begin
    Result := 0;
    FLastErrorCode := 412;
    SelectDocument(IntCast(OldDoc));
  end;
  RemoveDocument(DocID);
end;

function TQuickPDF.FindFormFieldByTitle(const Title: WideString): Integer;
var
  Field: TPDFField;
  Index: Integer;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    Index := 0;
    while (Index < FSelDoc.AcroForm.Count) and (Result = 0) do
    begin
      Field := FSelDoc.AcroForm.Field[Index];
      if Assigned(Field) then
        if Field.Title = Title then Result := Index + 1;
      Inc(Index);
    end;
  end;
end;

function TQuickPDF.FontCount: Integer;
begin
  Result := FSelDoc.FontCount;
end;

function TQuickPDF.GetFontID(Index: Integer): Integer;
begin
  Result := IntCast(FSelDoc.Font[Index - 1]);
end;

function TQuickPDF.FontName: WideString;
begin
  if Assigned(FSelFont) then
    Result := WideString(FSelFont.FontName)
  else
    Result := '';
end;

function TQuickPDF.FontReference: WideString;
begin
  if Assigned(FSelFont) then
    Result := WideString(FSelFont.Name)
  else
    Result := '';
end;

function TQuickPDF.FontType: Integer;
begin
  if Assigned(FSelFont) then
    Result := Ord(FSelFont.FontType) + 1
  else
    Result := 0;
end;

function TQuickPDF.FormFieldCount: Integer;
begin
  if FSelDoc.HasFormData then
    Result := FSelDoc.AcroForm.Count
  else
    Result := 0;
end;

function TQuickPDF.GetCustomInformation(const Key: WideString): WideString;
const
  BadList: AnsiString = '/Author/Title/Subject/Keywords/Creator/Producer/';
var
  KeyA: AnsiString;
begin
  KeyA := AnsiString(Key);
  if QPLPos('/' + KeyA, BadList) > 0 then
  begin
    Result := '';
  end else
  begin
    Result := FSelDoc.GetInfo(KeyA);
  end;
end;

function TQuickPDF.GetFormFieldBound(Index, Edge: Integer): Double;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    case Edge of
      0: Result := Field.Left;
      1: Result := Field.Top;
      2: Result := Field.Width;
      3: Result := Field.Height;
    end;

    Result := Result * FSelDoc.Scale;

    case Edge of
      0: if (FSelDoc.Origin = 2) or (FSelDoc.Origin = 3) then
           Result := PageWidth - Result;
      1: if (FSelDoc.Origin = 1) or (FSelDoc.Origin = 2) then
           Result := PageHeight - Result;
    end;
    
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldChildTitle(Index: Integer): WideString;
var
  Field: TPDFField;
begin
  Result := '';
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Result := Field.ChildTitle;
      end;
    end;
  end;
end;

function TQuickPDF.GetFormFieldPage(Index: Integer): Integer;
var
  X: Integer;
  A: TPDFArray;
  D: TPDFDictionary;
  Obj: TPDFObject;
  Page: Integer;
  OldPage: Integer;
  Field: TPDFField;
  S: AnsiString;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.Page;
    if Result = -1 then
    begin
      Result := 0;
      OldPage := SelectedPage;
      Page := 1;
      while (Page <= PageCount) and (Result = 0) do
      begin
        D := FSelDoc.PageTree.GetPage(Page);
        Obj := D.FindValueByKeyName('Annots');
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFArray then
        begin
          S := Field.FieldRef.Output;
          A := TPDFArray(Obj);
          X := 0;
          while (X < A.Count) and (Result = 0) do
          begin
            if (A.Item[X].Output = S) then
            begin
              Result := Page;
              Field.Page := Page;
            end else
            begin
              Inc(X);
            end;
          end;
        end;
        Inc(Page);
      end;
      SelectPage(OldPage);
    end;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldSubCount(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    Field := FindFormField(Index);
    if Assigned(Field) then
      Result := Field.SubCount;

    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldSubName(Index,
  SubIndex: Integer): WideString;
var
  Field: TPDFField;
begin
  Result := '';
  if FSelDoc.HasFormData then
  begin
    Field := FindFormField(Index);
    if Assigned(Field) then
      Result := QPLUTF8Decode(Field.GetSubName(SubIndex - 1));

    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldTitle(Index: Integer): WideString;
var
  Field: TPDFField;
  FieldIndex, KidIndex: Integer;
  I: Integer;
  S0: WideString;
begin
  Result := '';
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Result := Field.Title;
      end;
    end
    else
    if (Index and $55000000) = $55000000 then
    begin
      FieldIndex := (Index and $00FFFFFF) shr 8;
      KidIndex := Index and $FF;
      if (FieldIndex > 0) and (FieldIndex <= FSelDoc.AcroForm.Count) then
      begin
        Field := FSelDoc.AcroForm.Field[FieldIndex - 1];
        Field := Field.MakeTempChild(KidIndex);

        if (Field.FieldType = ftRadioButton) then
        begin
          for I := Field.SubCount - 1 downto 0 do
          begin
            S0 := WideString(Field.GetSubName(I));
            if (S0 <> 'Off') then
              Result := S0;
          end;
        end;

        if (Field.FieldType = ftText) then
          Result := Field.Title + WideString(QPLIntToStr(KidIndex));

        if Field.TempField then Field.Free;
      end;
    end;
  end;
end;

function TQuickPDF.GetFormFieldType(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Ord(Field.FieldType);
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldValue(Index: Integer): WideString;
var
  Field: TPDFField;
begin
  Result := '';
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Result := Field.Value;
      end;
    end;
  end;
end;

function TQuickPDF.GetInformation(Key: Integer): WideString;
var
  Len: Integer;
begin
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    Result := '';
    case Key of
      0: Result := QPLLatin1ToWideString(FSelDoc.Version);
      1: Result := FSelDoc.GetInfo('Author');
      2: Result := FSelDoc.GetInfo('Title');
      3: Result := FSelDoc.GetInfo('Subject');
      4: Result := FSelDoc.GetInfo('Keywords');
      5: Result := FSelDoc.GetInfo('Creator');
      6: Result := FSelDoc.GetInfo('Producer');
      7: Result := FSelDoc.GetInfo('CreationDate');
      8: Result := FSelDoc.GetInfo('ModDate');
    end;

    if (Key = 7) or (Key = 8) then
    begin
      if not QPLStartsWith(AnsiString(Result), 'D:') then
        Result := 'D:' + Result;

      Len := Length(Result);
      if (Len >= 6) and (Len < 23) then
        Result := Result + WideString(QPLCopy('0101000000-00''00''', Len-6+1, MaxInt));
      if (Length(Result) <> 23) then
      begin
        Result := '';
        FLastErrorCode := 999;
      end;
    end;

  end else
  begin
    Result := '';
    FLastErrorCode := 999;
  end;
end;

function TQuickPDF.GetPageContentToString: AnsiString;
var
  OldLayer: Integer;
  TempLayer: Integer;
begin
  OldLayer := FSelDoc.PageTree.Layer;
  try
    FLastErrorCode := 0;
    Result := '';
    for TempLayer := 1 to FSelDoc.PageTree.LayerCount do
    begin
      FSelDoc.PageTree.Layer := TempLayer;
      if (TempLayer > 1) then
      begin
        Result := Result + ' ' + FSelDoc.PageTree.ExtractContent;
      end else
      begin
        Result := FSelDoc.PageTree.ExtractContent;
      end;
    end;
  finally
    FSelDoc.PageTree.Layer := OldLayer;
  end;
end;

function TQuickPDF.GetPageText(ExtractOptions: Integer): WideString;
var
  Prefix: AnsiString;
  Funnel: TPDFTextFunnel;
begin
  Result := '';
  FLastErrorCode := 0;
  if (ExtractOptions >= 0) and (ExtractOptions <= 8) then
  begin
    Prefix := '';
    if (ExtractOptions >= 3) and (ExtractOptions <= 8) then
    begin
      Funnel := TPDFTextFunnel.Create;
      Funnel.Origin := FSelDoc.Origin;
      Funnel.Scale := FSelDoc.Scale;
      Funnel.PageWidth := FSelDoc.PageTree.PageWidth;
      Funnel.PageHeight := FSelDoc.PageTree.PageHeight;
      Funnel.WordGap := FSelDoc.TextExtractOptions.WordGap;
      Funnel.IgnoreFont := FSelDoc.TextExtractOptions.IgnoreFont;
      Funnel.IgnoreColor := FSelDoc.TextExtractOptions.IgnoreColor;
      Funnel.IgnoreBlocks := FSelDoc.TextExtractOptions.IgnoreBlocks;
      Funnel.SortBlocks := FSelDoc.TextExtractOptions.SortBlocks;
      Funnel.SplitOnDoubleSpace := FSelDoc.TextExtractOptions.SplitOnDoubleSpace;
      Funnel.TrimCharsOutsideArea := FSelDoc.TextExtractOptions.TrimCharsOutsideArea;
      Funnel.IgnoreDescenders := FSelDoc.TextExtractOptions.IgnoreDescenders;
      Funnel.IgnoreOverlaps := FSelDoc.TextExtractOptions.IgnoreOverlaps;
      Funnel.IgnoreDuplicates := FSelDoc.TextExtractOptions.IgnoreDuplicates;
      Funnel.OutputCMYK := FSelDoc.TextExtractOptions.OutputCMYK;
      Funnel.HorzScaleFactor := FSelDoc.TextExtractOptions.HorzScaleFactor;
      Funnel.VertScaleFactor := FSelDoc.TextExtractOptions.VertScaleFactor;
      Funnel.SpecialMatch := FSelDoc.TextExtractOptions.SpecialMatch;
      Funnel.IgnoreRotated := FSelDoc.TextExtractOptions.IgnoreRotated;
      Funnel.TrimWhitespace := FSelDoc.TextExtractOptions.TrimWhitespace;
      Funnel.OutputNonAscii := FSelDoc.TextExtractOptions.OutputNonAscii;
      Funnel.RemoveUnderscoreLines := FSelDoc.TextExtractOptions.RemoveUnderscoreLines;

      if (ExtractOptions = 7) then
      begin
        Funnel.IgnoreFont := True;
        Funnel.IgnoreColor := True;
        Funnel.IgnoreBlocks := True;
        Funnel.IgnoreDescenders := True;
      end;

      if (FSelDoc.TextExtractOptions.HasArea) then
      begin
        Funnel.SetArea(FSelDoc.TextExtractOptions.AreaLeft,
          FSelDoc.TextExtractOptions.AreaTop, FSelDoc.TextExtractOptions.AreaWidth,
          FSelDoc.TextExtractOptions.AreaHeight);
      end;
      if (ExtractOptions = 4) or (ExtractOptions = 6) then
        Funnel.SplitWords := True;
      if (ExtractOptions = 5) or (ExtractOptions = 6) then
        Funnel.OutputWidths := True;
    end else
      Funnel := nil;
    Result := FSelDoc.PageTree.ExtractText(ExtractOptions, Funnel);
    if Assigned(Funnel) then Funnel.Free;
  end;
end;

function TQuickPDF.GetScale(Dist: Double): Double;
begin
  Result := Dist / FSelDoc.Scale;
end;

function TQuickPDF.GetTextAscent: Double;
begin
  CheckFontSelection;
  FLastErrorCode := 0;
  Result := FSelDoc.PageTree.Painter.TextAscent;
  Result := Result * FSelDoc.Scale;
end;

function TQuickPDF.GetTextBound(Edge: Integer): Double;
begin
  CheckFontSelection;
  FLastErrorCode := 0;
  Result := FSelDoc.PageTree.Painter.TextBound(Edge);
  Result := Result * FSelDoc.Scale;
end;

function TQuickPDF.GetTextDescent: Double;
begin
  CheckFontSelection;
  FLastErrorCode := 0;
  Result := FSelDoc.PageTree.Painter.TextDescent;
  Result := Result * FSelDoc.Scale;
end;

function TQuickPDF.GetTextHeight: Double;
begin
  CheckFontSelection;
  FLastErrorCode := 0;
  Result := FSelDoc.PageTree.Painter.TextHeight;
  Result := Result * FSelDoc.Scale;
end;

function TQuickPDF.GetTextWidth(const Text: WideString): Double;
begin
  CheckFontSelection;
  FLastErrorCode := 0;
  Result := FSelDoc.PageTree.Painter.WideTextWidth(FSelFont.FixWideText(Text));
  Result := Result * FSelDoc.Scale;
end;

function TQuickPDF.GetWrappedText(Width: Double; const Delimiter,
  Text: WideString): WideString;
begin
  CheckFontSelection;
  if Width <= MinTW then Result := '' else
    Result := FSelDoc.PageTree.Painter.GetWrappedWideText(GetScale(Width),
      FixWideDelimited(Text, FSelDoc.BreakString), Delimiter, FSelDoc.BreakString);
end;

function TQuickPDF.GetWrappedTextHeight(Width: Double;
  const Text: WideString): Double;
begin
  CheckFontSelection;
  if Width <= MinTW then Result := 0 else
    Result := FSelDoc.PageTree.Painter.GetWrappedWideTextHeight(
      GetScale(Width), FixWideDelimited(Text, FSelDoc.BreakString), FSelDoc.BreakString);
  Result := Result * FSelDoc.Scale;
end;

function TQuickPDF.GetWrappedTextLineCount(Width: Double;
  const Text: WideString): Integer;
begin
  CheckFontSelection;
  if Width <= MinTW then Result := 0 else
    Result := FSelDoc.PageTree.Painter.GetWrappedWideTextLineCount(
      GetScale(Width), FixWideDelimited(Text, FSelDoc.BreakString), FSelDoc.BreakString);
end;

function TQuickPDF.HasFontResources: Integer;
begin
  if FSelDoc.HasFontResources then Result := 1 else Result := 0;
end;

function TQuickPDF.ImageCount: Integer;
begin
  FLastErrorCode := 0;
  Result := FSelDoc.ImageCount;
end;

function TQuickPDF.ImageHeight: Integer;
begin
  FLastErrorCode := 0;
  if Assigned(FSelImage) then
    Result := FSelImage.Height
  else
    Result := 0;
end;

function TQuickPDF.GetImageID(Index: Integer): Integer;
begin
  FLastErrorCode := 0;
  Result := IntCast(FSelDoc.Image(Index - 1));
end;

function TQuickPDF.ImageType: Integer;
begin
  FLastErrorCode := 0;
  if Assigned(FSelImage) then
    Result := Ord(FSelImage.ImageType)
  else
    Result := 0;
end;

function TQuickPDF.ImageWidth: Integer;
begin
  FLastErrorCode := 0;
  if Assigned(FSelImage) then
    Result := FSelImage.Width
  else
    Result := 0;
end;

function TQuickPDF.InsertPages(StartPage, PageCount: Integer): Integer;
var
  OldPageCount: Integer;
  OldPageWidth: Double;
  OldPageHeight: Double;
begin
  Result := 0;
  if (PageCount > 0) and (PageCount < 10000) then
  begin
    OldPageCount := FSelDoc.PageCount;
    OldPageWidth := FSelDoc.PageTree.PageWidth;
    OldPageHeight := FSelDoc.PageTree.PageHeight;
    FSelDoc.PageTree.NewPages(StartPage, PageCount, OldPageWidth, OldPageHeight);
    if FSelDoc.PageCount = OldPageCount + PageCount then
      Result := FSelDoc.PageCount;
    SelectFont(SelectedFont);
  end;
end;

function TQuickPDF.InsertTableColumns(TableID, Position,
  NewColumnCount: Integer): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table) and (NewColumnCount >= 1)) then
  begin
    if ((Position >= 1) and (Position <= (Table.GetColumnCount + 1))) then
    begin
      Result := Table.InsertColumns(Position, NewColumnCount);
    end;
  end;
end;

function TQuickPDF.InsertTableRows(TableID, Position,
  NewRowCount: Integer): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table) and (NewRowCount >= 1)) then
  begin
    if (Position >= 1) and (Position <= (Table.GetRowCount + 1)) then
    begin
      Result := Table.InsertRows(Position, NewRowCount);
    end;
  end;
end;

function TQuickPDF.LastErrorCode: Integer;
begin
  Result := FLastErrorCode;
  FLastErrorCode := 0;
end;

function TQuickPDF.ContentStreamCount: Integer;
begin
  Result := FSelDoc.PageTree.LayerCount;
end;

function TQuickPDF.LibraryVersion: WideString;
begin
  FLastErrorCode := 0;
  Result := WideString(LibVer);
end;

function TQuickPDF.IsLinearized: Integer;
begin
  FLastErrorCode := 0;
  if FSelDoc.Linearized then
    Result := 1
  else
    Result := 0;
end;

function TQuickPDF.LoadFromFile(const FileName, Password: WideString): Integer;
var
  FS: TQuickPDFWideFileStream;
begin
  FLastErrorCode := 0;
  Result := 0;
  if QPLFileExists(FileName) then
  begin
    try
      FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
      try
        Result := LoadFromStream(FS, Password);
      finally
        FS.Free;
      end;
    except
      Result := 0;
      FLastErrorCode := 401;
    end;
  end;

  if Result = 1 then
    FSelDoc.SourceFileName := FileName
  else
    FLastErrorCode := 401;

end;

function TQuickPDF.LoadFromStream(InStream: TStream; const Password: WideString): Integer;
var
  Doc: TPDFDocument;
begin
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    Doc := TPDFDocument.Create;
    Doc.DecodeMode := FDefaultDecodeMode;
    try
      case (Doc.LoadFromStream(InStream, Password)) of
        lrOkay:
        begin
          Result := 1;
          FDocs.Add(Doc);
          SelectDocument(IntCast(Doc));
          Doc := nil;
        end;
        lrWrongPassword:
        begin
          Result := 0;
          FLastErrorCode := 404;
        end;
      else
        Result := 0;
        FLastErrorCode := 401;
      end;
    finally
      if (Assigned(Doc)) then
      begin
        Doc.Free;
      end;
    end;
  end else
  begin
    Result := 0;
    FLastErrorCode := 999;
  end;
end;

function TQuickPDF.LoadFromString(const Source: AnsiString; const Password: WideString): Integer;
var
  Doc: TPDFDocument;
begin
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    Doc := TPDFDocument.Create;
    Doc.DecodeMode := FDefaultDecodeMode;
    try
      case (Doc.LoadFromString(Source, Password)) of
        lrOkay:
        begin
          Result := 1;
          FDocs.Add(Doc);
          SelectDocument(IntCast(Doc));
          Doc := nil;
        end;
        lrWrongPassword:
        begin
          Result := 0;
          FLastErrorCode := 404;
        end;
      else
        Result := 0;
        FLastErrorCode := 401;
      end;
    finally
      if (Assigned(Doc)) then
      begin
        Doc.Free;
      end;
    end;
  end else
  begin
    Result := 0;
    FLastErrorCode := 999;
  end;
end;

function TQuickPDF.LoadState: Integer;
begin
  FSelDoc.PageTree.Painter.LoadState;
  Result := 1;
end;

function TQuickPDF.MergeDocument(DocumentID: Integer): Integer;
var
  Doc1: TPDFDocument;
  Doc2: TPDFDocument;
begin
  Result := 0;
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    try
      Doc2 := ValidDocumentID(DocumentID);
      if (Assigned(Doc2)) then
      begin
        Doc1 := FSelDoc;
        if (FDocs.IndexOf(Doc2) >= 0) and (Doc1 <> Doc2) then
        begin
          if Doc1.Merge(Doc2) then
          begin
            if (Doc2.Version > Doc1.Version) then
            begin
              Doc1.Version := Doc2.Version;
            end;
            Result := 1;
            RemoveDocument(DocumentID);
            FSelDoc.SetInfo('Producer', WideString(ProductID));
            FSelDoc.ResetForm;
          end;
        end;
      end;
    except
    end;
  end else
  begin
    Result := 0;
    FLastErrorCode := 999;
  end;
end;

function TQuickPDF.MoveContentStream(FromPosition,
  ToPosition: Integer): Integer;
begin
  if FSelDoc.PageTree.MoveLayer(FromPosition, ToPosition) then Result := 1
    else Result := 0;
end;

function TQuickPDF.MultiplyScale(MultScaleBy: Double): Integer;
begin
  FSelDoc.Scale := FSelDoc.Scale / MultScaleBy;
  Result := 1;
end;

function TQuickPDF.NewDocument: Integer;
var
  Doc: TPDFDocument;
begin
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    Result := 0;
    Doc := nil;
    try
      Doc := TPDFDocument.Create;
      Doc.DecodeMode := FDefaultDecodeMode;
      Doc.CreateBlank;
      Doc.SetInfo('Producer', WideString(ProductID));
      Doc.SetInfo('Creator', WideString(ProductID));
      Doc.SetInfo('CreationDate', WideString(GetPDFDateTime));
      Doc.SetInfo('ModDate', WideString(GetPDFDateTime));
      FDocs.Add(Doc);
      SelectDocument(IntCast(Doc));
      SelectPage(1);
      Result := IntCast(Doc);
    except
      if Assigned(Doc) then Doc.Free;
    end;
  end else
  begin
    Result := 0;
    FLastErrorCode := 999;
  end;
end;

function TQuickPDF.NewContentStream: Integer;
begin
  Result := FSelDoc.PageTree.NewLayer;
  SelectFont(IntCast(FSelFont));
end;

function TQuickPDF.NewOutline(Parent: Integer; const Title: WideString;
  DestPage: Integer; DestPosition: Double): Integer;
var
  ParentOutline: TPDFIndRef;
begin
  ParentOutline := ValidOutlineID(Parent);
  if ((Parent = 0) or Assigned(ParentOutline)) then
  begin
    Result := IntCast(FSelDoc.NewOutline(ParentOutline, Title, DestPage,
      TranslateY(DestPosition)));
  end else
    Result := 0;
end;

function TQuickPDF.NewPage: Integer;
var
  OldPageCount: Integer;
  OldPageWidth: Double;
  OldPageHeight: Double;
begin
  Result := 0;
  OldPageCount := FSelDoc.PageCount;
  OldPageWidth := FSelDoc.PageTree.PageWidth;
  OldPageHeight := FSelDoc.PageTree.PageHeight;
  FSelDoc.PageTree.NewPages(OldPageCount + 1, 1, OldPageWidth, OldPageHeight);
  if FSelDoc.PageCount = OldPageCount + 1 then Result := OldPageCount + 1;
  SelectFont(SelectedFont);
end;

function TQuickPDF.NewPages(PageCount: Integer): Integer;
var
  OldPageCount: Integer;
  OldPageWidth: Double;
  OldPageHeight: Double;
begin
  Result := 0;
  if (PageCount > 0) and (PageCount < 100000) then
  begin
    OldPageCount := FSelDoc.PageCount;
    OldPageWidth := FSelDoc.PageTree.PageWidth;
    OldPageHeight := FSelDoc.PageTree.PageHeight;
    FSelDoc.ReserveIndObj(PageCount * 2);
    FSelDoc.PageTree.NewPages(FSelDoc.PageTree.PageCount + 1, PageCount, OldPageWidth, OldPageHeight);
    if FSelDoc.PageCount = OldPageCount + PageCount then
      Result := FSelDoc.PageCount;
    SelectFont(SelectedFont);
  end;
end;

function TQuickPDF.PageCount: Integer;
begin
  Result := FSelDoc.PageTree.PageCount;
end;

function TQuickPDF.PageHeight: Double;
begin
  Result := FSelDoc.PageTree.PageHeight;
  Result := Result * FSelDoc.Scale;
end;

function TQuickPDF.PageWidth: Double;
begin
  Result := FSelDoc.PageTree.PageWidth;
  Result := Result * FSelDoc.Scale;
end;

function TQuickPDF.GetPageUserUnit: Double;
begin
  Result := FSelDoc.PageTree.UserUnit;
end;

function TQuickPDF.EncodePermissions(CanPrint, CanCopy, CanChange,
  CanAddNotes, CanFillFields, CanCopyAccess, CanAssemble,
  CanPrintFull: Integer): Integer;
begin
  Result := 0;
  if CanPrint = 1 then Result := Result + 1;
  if CanCopy = 1 then Result := Result + 2;
  if CanChange = 1 then Result := Result + 4;
  if CanAddNotes = 1 then Result := Result + 8;
  if CanFillFields = 1 then Result := Result + 16;
  if CanCopyAccess = 1 then Result := Result + 32;
  if CanAssemble = 1 then Result := Result + 64;
  if CanPrintFull = 1 then Result := Result + 128;  
  Result := Result + ((Result xor $ABCD) and $FF) shl 16;
end;

function TQuickPDF.RemoveDocument(DocumentID: Integer): Integer;
var
  I: Integer;
  Document: TPDFDocument;
begin
  Result := 0;
  if FUnlocked then
  begin
    Document := ValidDocumentID(DocumentID);
    I := FDocs.IndexOf(Document);
    if I >= 0 then
    begin
      if FDocs.Count = 1 then
      begin
        NewDocument;
      end;
      if (FSelDoc = Document) then
      begin
        if (I = 0) then
        begin
          I := 1;
        end else
        begin
          I := I - 1;
        end;
        SelectDocument(IntCast(FDocs[I]));
      end;
      FDocs.Remove(Document);
      Result := 1;
    end;
  end;
end;

function TQuickPDF.ReplaceTag(const Tag, NewValue: WideString): Integer;
var
  Content: AnsiString;
begin
  Result := 0;
  Content := GetPageContentToString;
  while QPLPos(AnsiString(Tag), Content) > 0 do
  begin
    Inc(Result);
    Content := QPLCopy(Content, 1, QPLPos(AnsiString(Tag), Content) - 1) + AnsiString(NewValue) +
      QPLCopy(Content, QPLPos(AnsiString(Tag), Content) + Length(Tag), MaxInt);
  end;
  SetPageContentFromString(Content);
end;

function TQuickPDF.RotatePage(PageRotation: Integer): Integer;
begin
  if FSelDoc.RotatePage(PageRotation) then Result := 1 else Result := 0;
end;

function TQuickPDF.SaveState: Integer;
begin
  FSelDoc.PageTree.Painter.SaveState;
  Result := 1;
end;

function TQuickPDF.SaveToFile(const FileName: WideString): Integer;
begin
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    FSelFont := nil;
    if (not FSelDoc.UserModDate) then
    begin
      FSelDoc.SetInfo('ModDate', WideString(GetPDFDateTime));
    end;
    if FSelDoc.SaveToFile(FileName) then
      Result := 1
    else
      Result := 0;
  end else
  begin
    Result := 0;
    FLastErrorCode := 999;
  end;
end;

function TQuickPDF.SaveToString: AnsiString;
begin
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    FSelFont := nil;
    if (not FSelDoc.UserModDate) then
    begin
      FSelDoc.SetInfo('ModDate', WideString(GetPDFDateTime));
    end;
    Result := FSelDoc.SaveToString;
    if Result = '' then
      FLastErrorCode := 999;
  end;
end;

function TQuickPDF.SecurityInfo(SecurityItem: Integer): Integer;
var
  P: Cardinal;
  Enc: TPDFEncrypted;
begin
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    P := FSelDoc.PermissionsKey;
    Enc := FSelDoc.Encrypted;
    Result := 11;
    case Enc of
      peDecrypted:
      begin
        case SecurityItem of
          0: Result := 0;
          1..2: Result := 2;
          3: Result := 4;
          4..9: Result := 6;
          10: Result := 11;
          11..12: Result := 2;
          13: Result := 0;
        end;
      end;

      peUnknownEncryption:
        Result := 9;

      peEncrypted:
      begin
        case SecurityItem of
           0: Result := 1;
           1: begin
                if (FSelDoc.HasUserPassword) then
                begin
                  Result := 3;
                end else
                begin
                  Result := 2;
                end;
              end;
           2: begin
                if (FSelDoc.HasOwnerPassword) then
                begin
                  Result := 3;
                end else
                begin
                  Result := 2;
                end;
              end;
           3: begin
                if P and 4 = 4 then
                begin
                  if FSelDoc.EncryptionStrength = 40 then
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
           7: if (FSelDoc.EncryptionStrength = 128) and
                (P and $0100 = $0100) then Result := 6
                  else Result := 5;
           8: if (FSelDoc.EncryptionStrength = 128) and
                (P and $0200 = $0200) then Result := 6
                  else Result := 5;
           9: if (FSelDoc.EncryptionStrength = 128) and
                (P and $0400 = $0400) then Result := 6
                  else Result := 5;
          10: begin
                if FSelDoc.EncryptionStrength = 40 then
                begin
                  Result := 7;
                end else
                if FSelDoc.EncryptionStrength = 128 then
                begin
                  if FSelDoc.EncryptionAlgorithm = 2 then
                  begin
                    Result := 12;
                  end else
                  begin
                    Result := 8;
                  end;
                end else
                if FSelDoc.EncryptionStrength = 256 then
                begin
                  if FSelDoc.EncryptionAcroX then
                  begin
                    Result := 15;
                  end else
                  begin
                    Result := 13;
                  end;
                end else
                if ((FSelDoc.EncryptionStrength > 40) and (FSelDoc.EncryptionStrength < 128)) then
                begin
                  Result := 14;
                end;
              end;
          11:
          begin
            if (FSelDoc.IsUserPassword) then
            begin
              Result := 3;  // Yes
            end else
            begin
              Result := 2;  // No
            end;
          end;
          12:
          begin
            if (FSelDoc.IsOwnerPassword) then
            begin
              Result := 3;  // Yes
            end else
            begin
              Result := 2;  // No
            end;
          end;
          13:
          begin
            if ((FSelDoc.EncryptionStrength > 40) and (FSelDoc.EncryptionStrength < 128)) then
            begin
              Result := FSelDoc.EncryptionStrength;
            end else
            begin
              Result := 0;
            end;
          end;
        end;
      end;
    end;
  end else
  begin
    Result := 0;
    FLastErrorCode := 999;
  end;
end;

function TQuickPDF.SelectDocument(DocumentID: Integer): Integer;
var
  Document: TPDFDocument;
begin
  Result := 0;
  Document := ValidDocumentID(DocumentID);
  if (FDocs.IndexOf(Document) >= 0) then
  begin
    Result := 1;
    FSelDoc := Document;
    if (FSelDoc.ImageCount = 0) then
    begin
      FSelImage := nil;
    end else
    begin
      FSelImage := FSelDoc.Image(0);
    end;
    if (FSelDoc.FontCount = 0) then
    begin
      FSelFont := nil;
    end else
    begin
      FSelFont := FSelDoc.Font[0];
    end;
  end;
end;

function TQuickPDF.SelectedDocument: Integer;
begin
  Result := IntCast(FSelDoc);
end;

function TQuickPDF.SelectedFont: Integer;
begin
  Result := IntCast(FSelFont);
end;

function TQuickPDF.SelectedImage: Integer;
begin
  Result := IntCast(FSelImage);
end;

function TQuickPDF.SelectedPage: Integer;
begin
  Result := FSelDoc.PageTree.Page;
end;

function TQuickPDF.SelectFont(FontID: Integer): Integer;
var
  Font: TPDFFont;
begin
  Font := ValidFontID(FontID);
  if (Assigned(Font) and (FSelDoc.IsFont(Font))) then
  begin
    FSelFont := Font;
    FSelDoc.PageTree.UseFont(FSelFont);
    FSelDoc.PageTree.Painter.SelectFont(FSelFont, 12);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SelectImage(ImageID: Integer): Integer;
var
  Image: TPDFImage;
begin
  Image := ValidImageID(ImageID);
  if (Assigned(Image) and FSelDoc.IsImage(Image)) then
  begin
    Result := 1;
    FSelImage := Image;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SelectContentStream(NewIndex: Integer): Integer;
begin
  FSelDoc.PageTree.Layer := NewIndex;
  if FSelDoc.PageTree.Layer = NewIndex then Result := 1 else Result := 0;
  SelectFont(IntCast(FSelFont));
end;

function TQuickPDF.SelectPage(PageNumber: Integer): Integer;
var
  OldSize: Double;
begin
  FSelDoc.PageTree.Page := PageNumber;
  if FSelDoc.PageTree.Page = PageNumber then
    Result := 1
  else
    Result := 0;

  OldSize := GetTextSize;
  SelectFont(SelectedFont);
  if OldSize > 0 then
    SetTextSize(OldSize);
end;

function TQuickPDF.SetClippingPath: Integer;
begin
  FSelDoc.PageTree.Painter.SetClippingPath;
  Result := 1;
end;

function TQuickPDF.SetCustomInformation(const Key,
  NewValue: WideString): Integer;
const
  BadList: AnsiString = '/Author/Title/Subject/Keywords/Creator/Producer/';
var
  KeyA: AnsiString;
begin
  KeyA := AnsiString(Key);

  if QPLPos('/' + KeyA, BadList) > 0 then Result := 0 else
  begin
    Result := 1;
    FSelDoc.SetInfo(KeyA, NewValue, smString);
  end;
end;

function TQuickPDF.SetFillColor(Red, Green, Blue: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetFillColor(Red, Green, Blue);
  FSelDoc.FillSet := True;
  Result := 1;
end;

function TQuickPDF.SetFillColorCMYK(C, M, Y, K: Double): Integer;
begin
  if ((FSelDoc.PDFAMode <> 1) and (FSelDoc.PDFAMode <> 2)) then
  begin
    FSelDoc.FillSet := True;
    FSelDoc.PageTree.Painter.SetFillColor(C, M, Y, K);
    Result := 1;
  end else
  begin
    Result := 0;
    FLastErrorCode := 601;
  end;
end;

function TQuickPDF.SetFormFieldChildTitle(Index: Integer;
  const NewTitle: WideString): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Field.SetTitle(NewTitle);
        Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.SetFormFieldReadOnly(Index,
  ReadOnly: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Result := 1;
        Field.ReadOnly := ReadOnly <> 0;
      end;
    end;
  end;
end;

function TQuickPDF.SetFormFieldValue(Index: Integer;
  const NewValue: WideString): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Field.Value := NewValue;
        Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.SetFormFieldValueByTitle(const Title,
  NewValue: WideString): Integer;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if FSelDoc.AcroForm.SetFormFieldByTitle(Title, NewValue) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.SetFormFieldVisible(Index,
  Visible: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Result := 1;
        Field.Visible := Visible = 1;
      end;
    end;
  end;
end;

function TQuickPDF.SetHTMLBoldFont(const FontSet: WideString;
  FontID: Integer): Integer;
var
  Font: TPDFFont;
begin
  Font := ValidFontID(FontID);
  if (Assigned(Font) and FSelDoc.IsFont(Font)) then
  begin
    FSelDoc.SetHTMLFont(AnsiString(FontSet), 2, Font);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetHTMLBoldItalicFont(const FontSet: WideString;
  FontID: Integer): Integer;
var
  Font: TPDFFont;
begin
  Font := ValidFontID(FontID);
  if (Assigned(Font) and FSelDoc.IsFont(Font)) then
  begin
    FSelDoc.SetHTMLFont(AnsiString(FontSet), 4, Font);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetHTMLItalicFont(const FontSet: WideString;
  FontID: Integer): Integer;
var
  Font: TPDFFont;
begin
  Font := ValidFontID(FontID);
  if (Assigned(Font) and FSelDoc.IsFont(Font)) then
  begin
    FSelDoc.SetHTMLFont(AnsiString(FontSet), 3, Font);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.SetHTMLNormalFont(const FontSet: WideString;
  FontID: Integer): Integer;
var
  Font: TPDFFont;
begin
  Font := ValidFontID(FontID);
  if (Assigned(Font) and FSelDoc.IsFont(Font)) then
  begin
    FSelDoc.SetHTMLFont(AnsiString(FontSet), 1, Font);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetImageMask(FromRed, FromGreen, FromBlue,
  ToRed, ToGreen, ToBlue: Double): Integer;
begin
  Result := 0;
  if Assigned(FSelImage) then
  begin
    FSelImage.SetImageMask(FromRed, FromGreen, FromBlue, ToRed, ToGreen, ToBlue);
    Result := 1;
  end;
end;

function TQuickPDF.SetInformation(Key: Integer;
  const NewValue: WideString): Integer;
var
  TestValue: WideString;
begin
  Result := 0;
  FLastErrorCode := 0;
  case Key of
    0:
    begin
      if (NewValue = '1.0') or (NewValue = '1.1') or (NewValue = '1.2') or
        (NewValue = '1.3') or (NewValue = '1.4') or (NewValue = '1.5') or
        (NewValue = '1.6') or (NewValue = '1.7') then
          FSelDoc.Version := AnsiString(NewValue);
    end;
    1: FSelDoc.SetInfo('Author', NewValue);
    2: FSelDoc.SetInfo('Title', NewValue);
    3: FSelDoc.SetInfo('Subject', NewValue);
    4: FSelDoc.SetInfo('Keywords', NewValue);
    5: FSelDoc.SetInfo('Creator', NewValue);
    6: FSelDoc.SetInfo('Producer', NewValue);
    7: FSelDoc.SetInfo('CreationDate', NewValue);
    8:
    begin
      FSelDoc.UserModDate := True;
      FSelDoc.SetInfo('ModDate', NewValue);
    end;
    9: FSelDoc.SetInfo('dc:subject', NewValue);
  end;
  if (Key < 0) or (Key > 9) then
  begin
    FLastErrorCode := 202;
  end else
  begin
    if (Key = 9) then
    begin
      Result := 1;
    end else
    begin
      TestValue := GetInformation(Key);
      if TestValue = NewValue then Result := 1;
    end;
  end;
end;

function TQuickPDF.SetLineColor(Red, Green, Blue: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetLineColor(Red, Green, Blue);
  Result := 1;
end;

function TQuickPDF.SetLineColorCMYK(C, M, Y, K: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetLineColor(C, M, Y, K);
  Result := 1;
end;

function TQuickPDF.SetLineDash(DashOn, DashOff: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetLineDash(GetScale(DashOn), GetScale(DashOff));
  Result := 1;
end;

function TQuickPDF.SetLineWidth(LineWidth: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetLineWidth(GetScale(LineWidth));
  Result := 1;
end;

function TQuickPDF.SetMeasurementUnits(
  MeasurementUnits: Integer): Integer;
begin
  if (MeasurementUnits < 0) or (MeasurementUnits > 2) then
    MeasurementUnits := 0;
  case MeasurementUnits of
    0: FSelDoc.Scale := 1;
    1: FSelDoc.Scale := 25.4 / 72;
    2: FSelDoc.Scale := 1 / 72;
  end;
  Result := 1;
end;

function TQuickPDF.SetOpenActionMenu(const MenuItem: WideString): Integer;
begin
  Result := 0;
  if (FSelDoc.SetOpenActionMenu(AnsiString(MenuItem))) then
  begin
    Result := 1;
  end;
end;

function TQuickPDF.SetOpenActionDestination(OpenPage, Zoom: Integer): Integer;
begin
  Result := 0;
  if (Zoom >= -2) and (Zoom <= 6400) then
  begin
    if FSelDoc.SetOpenActionDestination(OpenPage, Zoom) then Result := 1;
  end;
end;

function TQuickPDF.SetOrigin(Origin: Integer): Integer;
begin
  if Origin > 3 then Origin := 0;
  if Origin < 0 then Origin := 0;
  FSelDoc.Origin := Origin;
  Result := 1;
end;

function TQuickPDF.SetPageActionMenu(const MenuItem: WideString): Integer;
begin
  Result := 0;
  if (FSelDoc.SetPageActionMenu(AnsiString(MenuItem))) then
  begin
    Result := 1;
  end;
end;

function TQuickPDF.SetPageContentFromString(const Source: AnsiString): Integer;
begin
  CombineContentStreams;
  FSelDoc.PageTree.SetContent(Source);
  FSelDoc.PageTree.Painter.SetSource(Source);
  Result := 1;
end;

function TQuickPDF.SetPageDimensions(NewPageWidth,
  NewPageHeight: Double): Integer;
var
  OldPageWidth, OldPageHeight: Double;
begin
  NewPageWidth := NewPageWidth / FSelDoc.Scale;
  NewPageHeight := NewPageHeight / FSelDoc.Scale;

  OldPageWidth := FSelDoc.PageTree.PageWidth;
  OldPageHeight := FSelDoc.PageTree.PageHeight;
  FSelDoc.PageTree.PageWidth := NewPageWidth;
  FSelDoc.PageTree.PageHeight := NewPageHeight;
  if (FSelDoc.PageTree.PageWidth = NewPageWidth) and (FSelDoc.PageTree.PageHeight = NewPageHeight) then
    Result := 1
  else
  begin
    FSelDoc.PageTree.PageWidth := OldPageWidth;
    FSelDoc.PageTree.PageHeight := OldPageHeight;
    Result := 0;
  end;
end;

function TQuickPDF.SetPageUserUnit(UserUnit: Double): Integer;
begin
  Result := 0;
  if (UserUnit >= 1.0) and (UserUnit < 75000) then
  begin
    FSelDoc.PageTree.UserUnit := UserUnit;
    Result := 1;
  end;
end;

function TQuickPDF.SetPageLayout(NewPageLayout: Integer): Integer;
begin
  Result := 0;
  if (NewPageLayout < 0) or (NewPageLayout > Ord(High(TPDFPageLayout))) then NewPageLayout := 0;
  if FSelDoc.SetPageLayout(TPDFPageLayout(NewPageLayout)) then
  begin
    Result := 1;
    if ((NewPageLayout = Ord(plTwoPageLeft)) or (NewPageLayout = Ord(plTwoPageRight))) then
    begin
      if FSelDoc.Version < '1.5' then FSelDoc.Version := '1.5';
    end;
  end;
end;

function TQuickPDF.SetPageMode(NewPageMode: Integer): Integer;
begin
  Result := 0;
  if (NewPageMode < 0) or (NewPageMode > 5) then NewPageMode := 0;
  if FSelDoc.SetPageMode(TPDFPageMode(NewPageMode)) then Result := 1;
end;

function TQuickPDF.SetPrecision(NewPrecision: Integer): Integer;
begin
  if (NewPrecision > 1) and (NewPrecision < 9) then
  begin
    Result := 1;
    FSelDoc.Structure.PDFPrecision := QPLCopy('0.00000000', 1, NewPrecision + 2);
    FSelDoc.Structure.PDFPrecNum := NewPrecision;
    FSelDoc.PageTree.Painter.PDFPrecNum := NewPrecision;
  end else
    Result := 0;
end;

function TQuickPDF.SetScale(NewScale: Double): Integer;
begin
  FSelDoc.Scale := 1 / NewScale;
  Result := 1;
end;

function TQuickPDF.SetTextAlign(TextAlign: Integer): Integer;
begin
  case TextAlign of
    1: FSelDoc.PageTree.Painter.TextAlign := paCenter;
    2: FSelDoc.PageTree.Painter.TextAlign := paRight;
    3: FSelDoc.PageTree.Painter.TextAlign := paJustified;
    4: FSelDoc.PageTree.Painter.TextAlign := paForceJustified;
    5: FSelDoc.PageTree.Painter.TextAlign := paLastJustified;
  else
    FSelDoc.PageTree.Painter.TextAlign := paLeft;      
  end;
  Result := 1;
end;

function TQuickPDF.SetTextColor(Red, Green, Blue: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetTextColor(Red, Green, Blue);
  Result := 1;
end;

function TQuickPDF.SetTextColorCMYK(C, M, Y, K: Double): Integer;
begin
  if ((FSelDoc.PDFAMode <> 1) and (FSelDoc.PDFAMode <> 2)) then
  begin
    FSelDoc.PageTree.Painter.SetTextColor(C, M, Y, K);
    Result := 1;
  end else
  begin
    Result := 0;
    FLastErrorCode := 601;
  end;
end;

function TQuickPDF.SetTextMode(TextMode: Integer): Integer;
begin
  FSelDoc.PageTree.Painter.SetTextMode(TextMode);
  Result := 1;
end;

function TQuickPDF.SetTextSize(TextSize: Double): Integer;
begin
  CheckFontSelection;
  if FSelFont <> nil then
  begin
    FSelDoc.PageTree.Painter.SelectFont(FSelFont, TextSize);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.SetTextSpacing(Spacing: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetTextSpacing(GetScale(Spacing));
  Result := 1;
end;

function TQuickPDF.SetViewerPreferences(Option, NewValue: Integer): Integer;
const
  VPOptions: array[1..16] of AnsiString = ('HideToolbar', 'HideMenubar',
    'HideWindowUI', 'FitWindow', 'CenterWindow', 'DisplayDocTitle',
    'NonFullScreenPageMode', 'Direction', 'ViewArea', 'ViewClip',
    'PrintArea', 'PrintClip', 'PrintScaling', 'Duplex', 'PickTrayByPDFSize',
    'NumCopies');
  Bool: array[0..1] of AnsiString = ('false', 'true');
  NonFull: array[0..3] of AnsiString = ('UseNone', 'UseOutlines', 'UseThumbs',
    'UseOC');
  Direction: array[0..1] of AnsiString = ('L2R', 'R2L');
  Boundary: array[0..4] of AnsiString = ('MediaBox', 'CropBox', 'BleedBox',
    'TrimBox', 'ArtBox');
  PrintScaling: array[0..1] of AnsiString = ('None', 'AppDefault');
  Duplex: array[0..2] of AnsiString = ('Simplex', 'DuplexFlipShortEdge',
    'DuplexFlipLongEdge');
begin
  Result := 0;
  case Option of
    1..6, 15:
    begin
      // HideToolbar to DisplayDocTitle and PickTrayByPDFSize
      if (NewValue = 0) or (NewValue = 1) then
      begin
        FSelDoc.SetBoolViewerPreferences(VPOptions[Option], NewValue = 1);
        Result := 1;
      end;
    end;
    7:
    begin
      // NonFullScreenPageMode
      if (NewValue >= 0) and (NewValue <= 3) then
      begin
        FSelDoc.SetNameViewerPreferences(VPOptions[Option], NonFull[NewValue]);
        Result := 1;
      end;
    end;
    8:
    begin
      // Direction
      if (NewValue = 0) or (NewValue = 1) then
      begin
        FSelDoc.SetNameViewerPreferences(VPOptions[Option], Direction[NewValue]);
        Result := 1;
      end;
    end;
    9..12:
    begin
      // ViewArea to PrintClip
      if (NewValue >= 0) and (NewValue <= 4) then
      begin
        FSelDoc.SetNameViewerPreferences(VPOptions[Option], Boundary[NewValue]);
        Result := 1;
      end;
    end;
    13:
    begin
      // PrintScaling
      if (NewValue >= 0) and (NewValue <= 1) then
      begin
        FSelDoc.SetNameViewerPreferences(VPOptions[Option], PrintScaling[NewValue]);
        Result := 1;
      end;
    end;
    14:
    begin
      // Duplex
      if (NewValue >= 0) and (NewValue <= 2) then
      begin
        FSelDoc.SetNameViewerPreferences(VPOptions[Option], Duplex[NewValue]);
        Result := 1;
      end;
    end;
    16:
    begin
      if NewValue >= 1 then
      begin
        FSelDoc.SetNumberViewerPreferences(VPOptions[Option], NewValue);
        Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.StartPath(StartX, StartY: Double): Integer;
begin
  FSelDoc.PageTree.Painter.StartPath(TranslateX(StartX), TranslateY(StartY));
  Result := 1;
end;

function TQuickPDF.TranslateX(XPos: Double): Double;
begin
  XPos := XPos / FSelDoc.Scale;

  if (FSelDoc.Origin = 2) or (FSelDoc.Origin = 3) then
    Result := FSelDoc.PageTree.PageWidth - XPos
  else
    Result := XPos;
end;

function TQuickPDF.TranslateY(YPos: Double): Double;
begin
  YPos := YPos / FSelDoc.Scale;

  if (FSelDoc.Origin = 1) or (FSelDoc.Origin = 2) then
    Result := FSelDoc.PageTree.PageHeight - YPos
  else
    Result := YPos;
end;

function TQuickPDF.Decrypt: Integer;
begin
  if FSelDoc.Decrypt then
  begin
    Result := 1;
    SelectPage(SelectedPage);
  end else
    Result := 0;
end;

function TQuickPDF.Unlocked: Integer;
begin
  if FUnlocked then Result := 1 else Result := 0;
end;

function TQuickPDF.SetTransparency(Transparency: Integer): Integer;
begin
  if (Transparency >= 0) and (Transparency <= 100) then
  begin
    FSelDoc.AddTransparency(100 - Transparency);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.ReplaceFonts(Options: Integer): Integer;
begin
  FSelDoc.ReplaceFonts(Options);
  Result := 1;
end;

function TQuickPDF.SetFormFieldDefaultValue(Index: Integer;
  const NewDefaultValue: WideString): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.DefaultValue := NewDefaultValue;
    Result := 1;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.NewFormField(const Title: WideString;
  FieldType: Integer): Integer;
var
  Field: TPDFField;
  AFontID: Integer;
  FieldIndex: Integer;
begin
  Result := 0;
  if not FSelDoc.HasFormData then
  begin
    FSelDoc.NewAcroForm;
    FSelDoc.HasFormData;
    if FSelDoc.FontCount = 0 then
    begin
      AFontID := AddStandardFont(4);
    end else
    begin
      AFontID := GetFontID(1);
    end;
    FSelDoc.AcroForm.AddFont(ValidFontID(AFontID));
  end;
  if FSelDoc.HasFormData then
  begin
    if (FieldType >= 1) and (FieldType <= Ord(High(TPDFFieldType))) then
    begin
      Field := FSelDoc.AcroForm.NewField(
        Title,
        TPDFFieldType(FieldType), FSelDoc.NewEmptyDictRef);
      if ((TPDFFieldType(FieldType) <> ftRadioButton) and
        (TPDFFieldType(FieldType) <> ftParent)) then
      begin
        if Assigned(Field) then
          FSelDoc.PageTree.UseField(Field);
        Field.SetPageRef(SelectedPage, FSelDoc.PageTree.PageRef);
      end;
      Field.FontSize := 10;

      FieldIndex := 0;
      while (FieldIndex < FSelDoc.AcroForm.Count) and (Result = 0) do
      begin
        if (FSelDoc.AcroForm.Field[FieldIndex] = Field) then
        begin
          Result := FieldIndex + 1;
        end;
        Inc(FieldIndex);
      end;
    end;
  end;
end;

function TQuickPDF.SetFormFieldBounds(Index: Integer; Left, Top, Width,
  Height: Double): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := 1;
    Field.SetBounds(TranslateX(Left), TranslateY(Top),
     GetScale(Width), GetScale(Height));
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.LicenseInfo: WideString;
begin
  Result := WideString(FLicenseInfo);
end;

function TQuickPDF.AddType1Font(const FileName: WideString): Integer;
var
  Font: TPDFFont;
begin
  Font := FSelDoc.NewType1Font(FileName);
  if Font <> nil then
  begin
    Result := IntCast(Font);
    SelectFont(Result);
  end else
    Result := 0;
end;

function TQuickPDF.MovePage(NewPosition: Integer): Integer;
begin
  if (NewPosition <> SelectedPage) and (NewPosition >= 1) and
    (NewPosition <= PageCount) then
  begin
    FSelDoc.PageTree.MovePage(SelectedPage, NewPosition);
    FSelDoc.PageTree.ForgetPages;
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.SetTempFile(const FileName: WideString): Integer;
begin
  if (FSelDoc.SetTempFileName(FileName)) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.HidePage: Integer;
var
  OldPage: Integer;
begin
  if PageCount > 1 then
  begin
    OldPage := SelectedPage;
    SelectPage(OldPage);
    FSelDoc.PageTree.HidePage;
    if OldPage > PageCount then Dec(OldPage);
    if OldPage <= 0 then OldPage := 1;
    FSelDoc.PageTree.ForgetPages;
    SelectPage(OldPage);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.AddLinkToJavaScript(Left, Top, Width,
  Height: Double; const JavaScript: WideString; Options: Integer): Integer;
begin
  FSelDoc.PageTree.AddLinkToJavaScript(TranslateX(Left), TranslateY(Top),
    GetScale(Width), GetScale(Height), JavaScript, Options,
    FSelDoc.JavaScriptMode = smString, FSelDoc.JavaScriptMode = smCompressedStream);
  Result := 1;
end;

function TQuickPDF.FormFieldJavaScriptAction(Index: Integer;
  const ActionType, JavaScript: WideString): Integer;
var
  Count: Integer;
  Field: TPDFField;
  ActionTypeA: AnsiString;
begin
  ActionTypeA := AnsiString(ActionType);

  Result := 0;
  if FSelDoc.HasFormData then
  begin
    Count := FSelDoc.AcroForm.Count;
    if (Index > 0) and (Index <= Count) then
    begin
      Result := 1;
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
        Field.AddJavaScriptAction(ActionTypeA, JavaScript,
          FSelDoc.JavaScriptMode = smString,
          FSelDoc.JavaScriptMode = smCompressedStream);
    end;
  end;
end;

function TQuickPDF.GetFormFieldFlags(Index: Integer): Integer;
var
  Count: Integer;
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    Count := FSelDoc.AcroForm.Count;
    if (Index > 0) and (Index <= Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
        Result := Field.Flags;
    end;
  end;
end;

function TQuickPDF.SetFormFieldFlags(Index,
  NewFlags: Integer): Integer;
var
  Count: Integer;
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    Count := FSelDoc.AcroForm.Count;
    if (Index > 0) and (Index <= Count) then
    begin
      Result := 1;
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
        Field.Flags := NewFlags;
    end;
  end;
end;

function TQuickPDF.SetImageMaskCMYK(FromC, FromM, FromY, FromK, ToC,
  ToM, ToY, ToK: Double): Integer;
begin
  Result := 0;
  if Assigned(FSelImage) then
  begin
    FSelImage.SetImageMaskCMYK(FromC, FromM, FromY, FromK, ToC, ToM, ToY, ToK);
    Result := 1;
  end;
end;

function TQuickPDF.GetHTMLTextHeight(Width: Double;
  const HTMLText: WideString): Double;
var
  PainterState: AnsiString;
begin
  Result := 0;
  if Width > 0 then
  begin
    CheckFontSelection;
    PainterState := FSelDoc.PageTree.Painter.GetState;
    try
      FSelDoc.PageTree.Painter.Reset;
      if HTMLText <> '' then
      begin
        FSelDoc.SetHTMLFonts;
        Result := FSelDoc.PageTree.Painter.GetHTMLTextHeight(GetScale(Width), HTMLText);
        Result := Result * FSelDoc.Scale;
      end;
    finally
      FSelDoc.PageTree.Painter.SetState(PainterState);
    end;
  end;
end;

function TQuickPDF.SetFontEncoding(Encoding: Integer): Integer;
begin
  Result := 0;
  if Assigned(FSelFont) and (FSelFont is TPDFFont) then
  begin
    Result := 1;
    case Encoding of
      0: FSelFont.SetEncoding('');
      1: FSelFont.SetEncoding('MacRomanEncoding');
      2: FSelFont.SetEncoding('WinAnsiEncoding');
      3: Result := 0;  // Deprecated, was PDFDocEncoding
      4: FSelFont.SetEncoding('MacExpertEncoding');
      5: FSelFont.SetEncoding('');
    else
      Result := 0;
    end;
  end;
end;

function TQuickPDF.FindImages: Integer;
begin
  case FFindImagesMode of
    1: Result := FSelDoc.FindImagesMode1;
    2: Result := FSelDoc.FindImagesMode2;
    3: Result := FSelDoc.FindImagesMode1(True);
    4: Result := FSelDoc.FindImagesMode2(True);
  else
    Result := 0;
  end;
end;

function TQuickPDF.SetPageSize(const PaperName: WideString): Integer;
var
  X: Integer;
  UPN: AnsiString;
  Portrait: Boolean;
begin
  Portrait := True;
  Result := 0;
  UPN := QPLUpperCase(AnsiString(PaperName));
  if QPLPos('LANDSCAPE', UPN) > 0 then
  begin
    Portrait := False;
    Delete(UPN, QPLPos('LANDSCAPE', UPN), 9);
    UPN := QPLTrim(UPN);
  end;
  if (UPN = 'LEDGER') and (not Portrait) then Portrait := True;
  for X := 1 to 49 do
  begin
    if PaperNames[X] = UPN then
    begin
      Result := 1;
      if Portrait then
      begin
        FSelDoc.PageTree.PageWidth := PaperWidths[X] / 25.4 * 72;
        FSelDoc.PageTree.PageHeight := PaperHeights[X] / 25.4 * 72;
      end else
      begin
        FSelDoc.PageTree.PageWidth := PaperHeights[X] / 25.4 * 72;
        FSelDoc.PageTree.PageHeight := PaperWidths[X] / 25.4 * 72;
      end;
    end;
  end;
end;

function TQuickPDF.DrawHTMLTextBox(Left, Top, Width, Height: Double;
  const HTMLText: WideString): WideString;
var
  PainterState: AnsiString;
begin
  Result := '';
  if Width > 0 then
  begin
    CheckFontSelection;
    PainterState := FSelDoc.PageTree.Painter.GetState;
    try
      FSelDoc.PageTree.Painter.Reset;
      FSelDoc.PageTree.Painter.ClearTextFormatting;
      Result := '';
      if HTMLText <> '' then
      begin
        FSelDoc.SetHTMLFonts;
        Result := FSelDoc.PageTree.Painter.DrawHTMLTextBox(TranslateX(Left),
          TranslateY(Top), GetScale(Width), GetScale(Height), HTMLText);
      end;
    finally
      FSelDoc.PageTree.Painter.SetState(PainterState);
    end;
  end;
end;

function TQuickPDF.ExtractPageRanges(const RangeList: WideString): Integer;
var
  DocID: Integer;
  OldDoc: TPDFDocument;
begin
  FLastErrorCode := 0;
  OldDoc := FSelDoc;
  DocID := NewDocument;
  if (FSelDoc.CopyPagesFromDoc(OldDoc, AnsiString(RangeList))) then
  begin
    Result := LoadFromString(SaveToString, '');
  end else
  begin
    Result := 0;
    FLastErrorCode := 412;
    SelectDocument(IntCast(OldDoc));
  end;
  RemoveDocument(DocID);
end;

function TQuickPDF.CopyPageRanges(DocumentID: Integer;
  const RangeList: WideString): Integer;
var
  OldPage: Integer;
  Document: TPDFDocument;
begin
  Result := 0;
  OldPage := SelectedPage;
  try
    Document := ValidDocumentID(DocumentID);
    if (FDocs.IndexOf(Document) >= 0) then
    begin
      if (Document <> FSelDoc) then
      begin
        NewPage;
        if (FSelDoc.CopyPagesFromDoc(Document, AnsiString(RangeList))) then
        begin
          Result := 1;
        end else
        begin
          FLastErrorCode := 412;
          DeletePages(SelectedPage, 1);
          SelectPage(OldPage);
        end;
      end;
    end;
  except
  end;
end;

function TQuickPDF.CapturePage(Page: Integer): Integer;
begin
  if (Page >= 1) and (Page <= FSelDoc.PageCount) and (FSelDoc.PageCount > 1) then
  begin
    SelectPage(Page);
    Result := IntCast(FSelDoc.CapturePage(0));
    HidePage;
  end else
    Result := 0;
end;

function TQuickPDF.DrawCapturedPage(CaptureID: Integer; Left, Top, Width, Height: Double): Integer;
var
  CP: TPDFCapturedPage;
begin
  Result := 0;
  try
    CP := ValidCaptureID(CaptureID);
    if Assigned(CP) then
    begin
      FSelDoc.PageTree.UseXObject(CP.XObjectName, CP.XObject);
      FSelDoc.PageTree.Painter.DrawXObject(CP, TranslateX(Left),
        TranslateY(Top), GetScale(Width), GetScale(Height));
      Result := 1;
    end;
  except
  end;
end;

function TQuickPDF.GetFormFieldValueByTitle(const Title: WideString): WideString;
begin
  Result := '';
  if FSelDoc.HasFormData then
  begin
    Result := FSelDoc.AcroForm.GetFormFieldByTitle(Title);
  end;
end;

function TQuickPDF.GetOrigin: Integer;
begin
  Result := FSelDoc.Origin;
end;

function TQuickPDF.DeleteFormField(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;

  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    if (Field.TempField) then
    begin
      Field.DeleteFromParent;
    end else
    begin
      FSelDoc.PageTree.ReleaseFieldFromPage(Field, Field.GetPageRef);
      FSelDoc.AcroForm.DeleteField(Index - 1);
      Result := 1;
      Field.Free;
      Field := nil;
    end;

    if (Assigned(Field) and (Field.TempField)) then
    begin
      Field.Free;
    end;
  end;
end;

function TQuickPDF.GetFormFieldJavaScript(Index: Integer;
  const ActionType: WideString): WideString;
var
  Field: TPDFField;
begin

  Result := '';
  if FSelDoc.HasFormData then
  begin
    Field := FindFormField(Index);
    if Assigned(Field) then
    begin
      Result := Field.GetJavaScriptAction(AnsiString(ActionType));
      if Field.TempField then Field.Free;
    end;
  end;
end;

function TQuickPDF.GetTextSize: Double;
begin
  Result := FSelDoc.PageTree.Painter.TextSize;
end;

//function TQuickPDF.ToPDFUnicode(const Input: WideString): AnsiString;
//begin
//  Result := QPLEncodeTextString(Input);
//end;

function TQuickPDF.SetNeedAppearances(NewValue: Integer): Integer;
var
  AFontID: Integer;
begin
  Result := 1;
  if (not FSelDoc.HasFormData) then
  begin
    FSelDoc.NewAcroForm;
  end;
  if FSelDoc.HasFormData then
  begin
    if (FSelDoc.AcroForm.FontCount = 0) then
    begin
      if FSelDoc.FontCount = 0 then
      begin
        AFontID := AddStandardFont(4);
      end else
      begin
        AFontID := GetFontID(1);
      end;
      FSelDoc.AcroForm.AddFont(ValidFontID(AFontID));
    end;
    FSelDoc.AcroForm.NeedAppearances(NewValue <> 0);
  end;
end;

function TQuickPDF.GetCatalogInformation(const Key: WideString): WideString;
const
  BadList: AnsiString = '/Type/Version/Extensions/Pages/PageLabels/Names' +
    '/Dests/ViewerPreferences/PageLayout/PageMode/Outlines/Threads' +
    '/OpenAction/AA/URI/AcroForm/Metadata/StructTreeRoot/MarkInfo/Lang' +
    '/SpiderInfo/OuputIntents/PieceInfo/OCProperties/Perms/Legal/Requirements' +
    '/Collection/NeedsRendering';
var
  KeyA: AnsiString;
begin
  KeyA := AnsiString(Key);

  if QPLPos('/' + KeyA, BadList) > 0 then
  begin
    Result := '';
  end else
  begin
    Result := FSelDoc.GetCatalogInfo(KeyA);
  end;
end;

function TQuickPDF.SetCatalogInformation(const Key,
  NewValue: WideString): Integer;
const
  BadList: AnsiString = '/Type/Version/Extensions/Pages/PageLabels/Names' +
    '/Dests/ViewerPreferences/PageLayout/PageMode/Outlines/Threads' +
    '/OpenAction/AA/URI/AcroForm/Metadata/StructTreeRoot/MarkInfo/Lang' +
    '/SpiderInfo/OuputIntents/PieceInfo/OCProperties/Perms/Legal/Requirements' +
    '/Collection/NeedsRendering';
var
  KeyA: AnsiString;
begin
  KeyA := AnsiString(Key);

  if QPLPos('/' + KeyA, BadList) > 0 then
  begin
    Result := 0;
  end else
  begin
    Result := 1;
    FSelDoc.SetCatalogInfo(KeyA, NewValue, smString);
  end;
end;

function TQuickPDF.DrawEllipse(XPos, YPos, Width, Height: Double;
  DrawOptions: Integer): Integer;
var
  Fill: Boolean;
  Outline: Boolean;
begin
  Fill := (DrawOptions = 1) or (DrawOptions = 2);
  Outline := (DrawOptions = 0) or (DrawOptions = 2);
  FSelDoc.PageTree.Painter.Ellipse(TranslateX(XPos), TranslateY(YPos),
    GetScale(Width), GetScale(Height), Fill, Outline);
  Result := 1;
end;

function TQuickPDF.DrawEllipticArc(XPos, YPos, Width, Height,
  StartAngle, EndAngle: Double; Pie, DrawOptions: Integer): Integer;
var
  Fill: Boolean;
  Outline: Boolean;
  Close: Boolean;
begin

  StartAngle := StartAngle + 90;   // Allow for Origin change.
  EndAngle := EndAngle + 90;

  if Abs(StartAngle - EndAngle) <= 360 then
  begin
    Fill := (DrawOptions = 1) or (DrawOptions = 2) or (DrawOptions = 3);
    Outline := (DrawOptions = 0) or (DrawOptions = 2) or (DrawOptions = 3);
    Close := (DrawOptions = 3);
    FSelDoc.PageTree.Painter.EllipticArc(TranslateX(XPos), TranslateY(YPos),
      GetScale(Width), GetScale(Height), StartAngle, EndAngle, Pie = 1, Fill,
        Outline, Close);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.SetOpenActionJavaScript(
  const JavaScript: WideString): Integer;
begin
  if (FSelDoc.SetOpenActionJavaScript(JavaScript)) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetFormFieldDescription(Index: Integer): WideString;
var
  Field: TPDFField;
begin
  Result := '';
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Result := Field.Description;
      end;
    end;
  end;
end;

function TQuickPDF.SetFormFieldDescription(Index: Integer;
  const NewDescription: WideString): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Field.Description := NewDescription;
        Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.CompressFonts(Compress: Integer): Integer;
begin
  if (Compress >= 0) and (Compress <= 1) then
  begin
    FSelDoc.CompressFonts := Compress;
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.SetJavaScriptMode(JSMode: Integer): Integer;
begin
  if (JSMode < 0) then JSMode := 0;
  if (JSMode > 2) then JSMode := 0;
  case JSMode of
    0: FSelDoc.JavaScriptMode := smString;
    1: FSelDoc.JavaScriptMode := smStream;
    2: FSelDoc.JavaScriptMode := smCompressedStream;
  end;
  Result := 1;
end;

function TQuickPDF.PageJavaScriptAction(const ActionType,
  JavaScript: WideString): Integer;
var
  ActionTypeA: AnsiString;
begin
  ActionTypeA := AnsiString(ActionType);

  if (ActionType = 'O') or (ActionType = 'C') then
  begin
    Result := 1;
    FSelDoc.PageTree.PageActionJavaScript(ActionTypeA, JavaScript,
      FSelDoc.JavaScriptMode = smString,
      FSelDoc.JavaScriptMode = smCompressedStream);
  end else
    Result := 0;
end;

function TQuickPDF.DocJavaScriptAction(const ActionType,
  JavaScript: WideString): Integer;
begin
  if (ActionType = 'WC') or (ActionType = 'WS') or (ActionType = 'DS') or
    (ActionType = 'WP') or (ActionType = 'DP') then
  begin
    Result := 1;
    FSelDoc.DocJavaScriptAction(AnsiString(ActionType), JavaScript);
  end else
    Result := 0;
end;

function TQuickPDF.AddGlobalJavaScript(const PackageName,
  JavaScript: WideString): Integer;
begin
  if PackageName <> '' then
  begin
    Result := 1;
    FSelDoc.AddGlobalJavaScript(PackageName, JavaScript);
  end else
    Result := 0;
end;

function TQuickPDF.GetGlobalJavaScript(
  const PackageName: WideString): WideString;
begin
  Result := FSelDoc.GetGlobalJavaScript(PackageName);
end;

function TQuickPDF.GetPageJavaScript(const ActionType: WideString): WideString;
begin
  Result := FSelDoc.PageTree.GetPageJavaScript(AnsiString(ActionType));
end;

function TQuickPDF.GetDocJavaScript(const ActionType: WideString): WideString;
begin
  Result := FSelDoc.GetDocJavaScript(AnsiString(ActionType));
end;

function TQuickPDF.GetOpenActionJavaScript: WideString;
begin
  Result := FSelDoc.GetOpenActionJavaScript;
end;

function TQuickPDF.EncryptFile(const InputFileName, OutputFileName,
  Owner, User: WideString; Strength, Permissions: Integer): Integer;
var
  X: Integer;
  FS: TQuickPDFWideFileStream;
  Obj: TPDFObject;
  FSOut: TQuickPDFWideFileStream;
  Info: TSmartPDFInfo;
  Reader: TSmartPDFReader;
  Writer: TSmartPDFWriter;
  TempStruct: TPDFStructure;
  Perm: TSmartPDFPermissions;
  ExtraPerm: TSmartPDFExtraPermissions;
  EncStrength: TSmartPDFEncryptionStrength;
  D: TPDFDictionary;
  OC: Integer;
  OwnerA: AnsiString;
  UserA: AnsiString;
begin
  if ((Strength = 3) or (Strength = 4)) then
  begin
    OwnerA := QPLUTF8Encode(Owner);
    UserA := QPLUTF8Encode(User);
  end else
  begin
    OwnerA := AnsiString(Owner);
    UserA := AnsiString(User);
  end;

  Result := 0;
  FLastErrorCode := 0;
  if (FUnlocked) then
  begin
    if ((Strength >= 0) and (Strength <= 4)) then
    begin
      if (((Permissions and $FFFF) xor $ABCD) and $FF) = ((Permissions and $FF0000) shr 16) then
      begin
        Perm := [];
        ExtraPerm := [];
        if Permissions and 1 = 1 then Perm := Perm + [spCanPrint];
        if Permissions and 2 = 2 then Perm := Perm + [spCanCopy];
        if Permissions and 4 = 4 then Perm := Perm + [spCanChange];
        if Permissions and 8 = 8 then Perm := Perm + [spCanAddNotes];
        if Permissions and 16 = 16 then ExtraPerm := ExtraPerm + [spCanFillFields];
        if Permissions and 32 = 32 then ExtraPerm := ExtraPerm + [spCanCopyAccess];
        if Permissions and 64 = 64 then ExtraPerm := ExtraPerm + [spCanAssemble];
        if Permissions and 128 = 128 then ExtraPerm := ExtraPerm + [spCanPrintFull];

        EncStrength := ssStd;
        if Strength = 1 then EncStrength := ss128Bit;
        if Strength = 2 then EncStrength := ssAES128Bit;
        if Strength = 3 then EncStrength := ssAES256Bit;
        if Strength = 4 then EncStrength := ssAES256BitAcroX;       

        try
          FS := QPLCreateFileStream(InputFileName, fmOpenRead or fmShareDenyWrite);
          try
            if QPLFileExists(OutputFileName) then
            begin
              if QPLDeleteFile(OutputFileName) then FLastErrorCode := 0 else
                FLastErrorCode := 402;
            end;
            if FLastErrorCode <> 402 then
            try
              FSOut := QPLCreateFileStream(OutputFileName, fmCreate or fmShareExclusive);
              try
                Reader := TSmartPDFReader.Create(FS);
                try
                  if Reader.ErrorCode = ecNone then
                  begin
                    Info := TSmartPDFInfo.Create(Reader, '');
                    try
                      if Info.Encrypted = spDecrypted then
                      begin
                        Result := 1;
                        Reader.FixTrailer;
                        Reader.TrailerDict.PurgeKey('Prev');
                        D := Info.Encrypt(OwnerA, UserA, EncStrength, Perm, ExtraPerm, Reader.ObjectCount + 1);
                        Writer := TSmartPDFWriter.Create(FSOut);
                        try
                          if ((Strength = 3) or (Strength = 4)) then
                          begin
                            Writer.New('1.7');
                          end else
                          if Strength = 2 then
                          begin
                            Writer.New('1.6');
                          end else
                          begin
                            Writer.New;
                          end;
                          TempStruct := TPDFStructure.Create;
                          try
                            FSubProgressScale := 1;
                            FSubProgressOffset := 0;
                            OC := Reader.ObjectCount;
                            for X := 1 to OC do
                            begin
                              SubProgress(X * 100 div OC);
                              Obj := Reader.GetObject(X, TempStruct);
                              Info.CryptObject(Obj, X, Reader.GetGenNum(X));
                              if Assigned(Obj) then
                                Writer.AddObject(X, Reader.GetGenNum(X), Obj.Output)
                              else
                                Writer.AddObject(X, Reader.GetGenNum(X), 'null');
                              if TempStruct.ObjectCount > ObjCountLimit then
                              begin
                                TempStruct.Free;
                                TempStruct := TPDFStructure.Create;
                              end;
                            end;
                            SubProgress(100);
                            Writer.AddObject(Reader.ObjectCount + 1, 0,
                              D.Output);
                          finally
                            TempStruct.Free;
                          end;
                          Writer.AddTrailer(Reader.TrailerDict);
                        finally
                          Writer.Free;
                        end;
                      end else
                        FLastErrorCode := 406;
                    finally
                      Info.Free;
                    end;
                  end else
                    FLastErrorCode := 409;
                finally
                  Reader.Free;
                end;
              finally
                FSOut.Free;
              end;
            except
              FLastErrorCode := 403;
            end;
          finally
            FS.Free;
          end;
        except
          FLastErrorCode := 401;
        end;


      end else
        FLastErrorCode := 408;
    end else
      FLastErrorCode := 407;
  end else
    FLastErrorCode := 999;

  if ((Result = 0) and (FLastErrorCode <> 402)) then
  begin
    if QPLFileExists(OutputFileName) then
    begin
      QPLDeleteFile(OutputFileName);
    end;
  end;
end;

function TQuickPDF.DecryptFile(const InputFileName,
  OutputFileName, Password: WideString): Integer;
var
  FS: TQuickPDFWideFileStream;
  FSOut: TQuickPDFWideFileStream;
  Reader: TSmartPDFReader;
  Writer: TSmartPDFWriter;
  Info: TSmartPDFInfo;
  X: Integer;
  TempStruct: TPDFStructure;
  Obj: TPDFObject;
  OC: Integer;
begin
  Result := 0;
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    try
      FS := QPLCreateFileStream(InputFileName, fmOpenRead or fmShareDenyWrite);
      try
        if QPLFileExists(OutputFileName) then
        begin
          if QPLDeleteFile(OutputFileName) then FLastErrorCode := 0 else
            FLastErrorCode := 402;
        end;
        if FLastErrorCode <> 402 then
        try
          FSOut := QPLCreateFileStream(OutputFileName, fmCreate or fmShareExclusive);
          try
            Reader := TSmartPDFReader.Create(FS);
            try
              if Reader.ErrorCode = ecNone then
              begin
                Info := TSmartPDFInfo.Create(Reader, Password);
                try
                  if Info.Encrypted = spEncrypted then
                  begin
                    if Info.CheckPassword(Password) then
                    begin
                      Result := 1;
                      Info.Password := Password;
                      Reader.FixTrailer;
                      Reader.TrailerDict.PurgeKey('Encrypt');
                      Writer := TSmartPDFWriter.Create(FSOut);
                      try
                        Writer.New;
                        TempStruct := TPDFStructure.Create;
                        try
                          OC := Reader.ObjectCount;
                          FSubProgressScale := 1;
                          FSubProgressOffset := 0;
                          for X := 1 to OC do
                          begin
                            SubProgress(X * 100 div OC);
                            Obj := Reader.GetObject(X, TempStruct);
                            Info.DecryptObject(Obj, X, Reader.GetGenNum(X));
                            if Assigned(Obj) then
                              Writer.AddObject(X, Reader.GetGenNum(X), Obj.Output)
                            else
                              Writer.AddObject(X, Reader.GetGenNum(X), 'null');
                            if TempStruct.ObjectCount > ObjCountLimit then
                            begin
                              TempStruct.Free;
                              TempStruct := TPDFStructure.Create;
                            end;
                          end;
                          SubProgress(100);
                        finally
                          TempStruct.Free;
                        end;
                        Writer.AddTrailer(Reader.TrailerDict);
                      finally
                        Writer.Free;
                      end;
                    end else
                      FLastErrorCode := 404;
                  end else
                    FLastErrorCode := 405;
                finally
                  Info.Free;
                end;
              end else
                FLastErrorCode := 409;
            finally
              Reader.Free;
            end;
          finally
            FSOut.Free;
          end;
        except
          FLastErrorCode := 403;
        end;
      finally
        FS.Free;
      end;
    except
      FLastErrorCode := 401;
    end;
  end else
    FLastErrorCode := 999;

  if ((Result = 0) and (FLastErrorCode <> 402)) then
  begin
    if QPLFileExists(OutputFileName) then
    begin
      QPLDeleteFile(OutputFileName);
    end;
  end;
end;

function TQuickPDF.SetFormFieldBackgroundColor(Index: Integer; Red,
  Green, Blue: Double): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.SetBackgroundColor(Red, Green, Blue);
    Result := 1;

    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldBorderColor(Index: Integer; Red, Green,
  Blue: Double): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.SetBorderColor(Red, Green, Blue);
    Result := 1;

    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.FindFormField(Index: Integer): TPDFField;
var
  FieldIndex: Integer;
  KidIndex: Integer;
begin
  Result := nil;
  if FSelDoc.HasFormData then
  begin
    if (Index and $55000000) = $55000000 then
    begin
      FieldIndex := (Index and $00FFFFFF) shr 8;
      KidIndex := Index and $FF;
      if (FieldIndex > 0) and (FieldIndex <= FSelDoc.AcroForm.Count) then
      begin
        Result := FSelDoc.AcroForm.Field[FieldIndex - 1];
        Result := Result.MakeTempChild(KidIndex);
      end;
    end else
    begin
      if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
        Result := FSelDoc.AcroForm.Field[Index - 1];
    end;
  end;
end;

function TQuickPDF.SetFormFieldCaption(Index: Integer;
  const NewCaption: WideString): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.SetCaption(NewCaption);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldBorderStyle(Index: Integer;
  Width: Double; Style: Integer; DashOn, DashOff: Double): Integer;
var
  Field: TPDFField;
const
  StyleKeys: array[0..4] of AnsiString = ('S', 'D', 'B', 'I', 'U');
begin
  if Style > 4 then Style := 0;
  if Style < 0 then Style := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.SetBorderStyle(GetScale(Width), StyleKeys[Style], GetScale(DashOn), GetScale(DashOff));
    Result := 1;

    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldIcon(Index, IconType,
  CaptureID: Integer): Integer;
var
  Field: TPDFField;
  CP: TPDFCapturedPage;
const
  IconKey: array[0..2] of AnsiString = ('I', 'RI', 'IX');
begin
  CP := ValidCaptureID(CaptureID);

  Field := FindFormField(Index);
  if Assigned(Field) and (IconType >= 0) and (IconType <= 2) and Assigned(CP) then
  begin
    Field.SetIcon(IconKey[IconType], CP.XObject);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldIconStyle(Index, Placement, Scale, ScaleType,
  HorizontalShift, VerticalShift: Integer): Integer;
var
  Field: TPDFField;
const
  ScaleKey: array[0..3] of AnsiString = ('A', 'B', 'S', 'N');
  ScaleTypeKey: array[0..1] of AnsiString = ('A', 'P');
begin
  if HorizontalShift < 0 then HorizontalShift := 0;
  if VerticalShift < 0 then VerticalShift := 0;
  if HorizontalShift > 100 then HorizontalShift := 100;
  if VerticalShift > 100 then VerticalShift := 100;
  if Placement > 6 then Placement := 0;
  if Placement < 0 then Placement := 0;
  Field := FindFormField(Index);
  if Scale > 3 then Scale := 0;
  if Scale < 0 then Scale := 0;
  if ScaleType > 1 then ScaleType := 0;
  if ScaleType < 0 then ScaleType := 0;
  if Assigned(Field) then
  begin
    Field.SetIconStyle(Placement, ScaleKey[Scale], ScaleTypeKey[ScaleType],
      HorizontalShift / 100, VerticalShift / 100);
    Result := 1;

    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldHighlightMode(Index,
  NewMode: Integer): Integer;
var
  Field: TPDFField;
const
  ModeKey: array[0..3] of AnsiString = ('N', 'I', 'O', 'P');
begin
  Field := FindFormField(Index);
  if NewMode < 0 then NewMode := 0;
  if NewMode > 3 then NewMode := 0;
  if Assigned(Field) then
  begin
    Field.SetHighlightMode(ModeKey[NewMode]);
    Result := 1;

    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.AnalyseFile(const InputFileName,
  Password: WideString): Integer;
var
  FS: TQuickPDFWideFileStream;
  Reader: TSmartPDFReader;
  Info: TSmartPDFInfo;
  SL: TQuickPDFStringList;
begin
  Result := 0;
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    if QPLFileExists(InputFileName) then
    begin
      try
        FS := QPLCreateFileStream(InputFileName, fmOpenRead or fmShareDenyWrite);
        try
          Reader := TSmartPDFReader.Create(FS);
          try
            if Reader.ErrorCode = ecNone then
            begin
              Info := TSmartPDFInfo.Create(Reader, '');
              try
                if ((Info.Encrypted = spEncrypted) and Info.CheckPassword(Password)) or
                  (Info.Encrypted = spDecrypted) then
                begin
                  Result := 1;
                  Info.Password := Password;
                  Info.GetBasic;
                  SL := TQuickPDFStringList.Create;
                  FAnalysisInfo.Add(SL);
                  Result := IntCast(SL);
                  SL.Add(QPLUTF8Encode(QPLExpandFileName(InputFileName)));
                  SL.Add(QPLIntToStr(FS.Size));
                  SL.Add(QPLUTF8Encode(Info.GetInfoValue('Author')));
                  SL.Add(QPLUTF8Encode(Info.GetInfoValue('Title')));
                  SL.Add(QPLUTF8Encode(Info.GetInfoValue('Subject')));
                  SL.Add(QPLUTF8Encode(Info.GetInfoValue('Keywords')));
                  SL.Add(QPLUTF8Encode(Info.GetInfoValue('Creator')));
                  SL.Add(QPLUTF8Encode(Info.GetInfoValue('Producer')));
                  SL.Add(Info.Version);    // 8
                  SL.Add(QPLIntToStr(Info.PageCount));
                  SL.Add(QPLUTF8Encode(Info.GetInfoValue('CreationDate')));
                  SL.Add(QPLUTF8Encode(Info.GetInfoValue('ModDate')));
                  SL.Add(Info.DocID);      // 12
                  if Info.SecurityInfo(0) = '0' then
                  begin
                    SL.Add('None');        // 13
                  end else
                  begin
                    if Info.IsOwnerPassword then
                    begin
                      SL.Add('Owner');
                    end else
                    begin
                      SL.Add('User');
                    end;
                  end;

                  // 14 and 15
                  if (Info.ContainsUsageRights) then
                  begin
                    SL.Add('Yes');
                    SL.Add(QPLUTF8Encode(Info.GetUsageRightsName));
                  end else
                  begin
                    SL.Add('No');
                    SL.Add('');
                  end;

                  SL.Add('');
                  SL.Add('');
                  SL.Add('');
                  SL.Add('');

                  // 20 to 30
                  SL.Add(Info.SecurityInfo(0));
                  SL.Add(Info.SecurityInfo(1));
                  SL.Add(Info.SecurityInfo(2));
                  SL.Add(Info.SecurityInfo(3));
                  SL.Add(Info.SecurityInfo(4));
                  SL.Add(Info.SecurityInfo(5));
                  SL.Add(Info.SecurityInfo(6));
                  SL.Add(Info.SecurityInfo(7));
                  SL.Add(Info.SecurityInfo(8));
                  SL.Add(Info.SecurityInfo(9));
                  SL.Add(Info.SecurityInfo(10));

                  // 31
                  SL.Add(QPLIntToStr(Info.FormFieldCount));

                  // 32 to 40
                  SL.Add('');
                  SL.Add('');
                  SL.Add('');
                  SL.Add('');
                  SL.Add('');
                  SL.Add('');
                  SL.Add('');
                  SL.Add('');
                  SL.Add('');

                  // 41 to 43
                  SL.Add(Info.SecurityInfo(11));
                  SL.Add(Info.SecurityInfo(12));
                  SL.Add(Info.SecurityInfo(13));


                  //Info.GetBlankSignatureNames(SL);
                end else
                  FLastErrorCode := 404;
              finally
                Info.Free;
              end;
            end else
              FLastErrorCode := 409;
          finally
            Reader.Free;
          end;
        finally
          FS.Free;
        end;
      except
        FLastErrorCode := 401;
      end;
    end else
      FLastErrorCode := 401;
  end else
    FLastErrorCode := 999;
end;

function TQuickPDF.DeleteAnalysis(AnalysisID: Integer): Integer;
var
  SL: TQuickPDFStringList;
begin
  Result := 0;
  SL := ValidAnalysisID(AnalysisID);
  if (Assigned(SL)) then
  begin
    FAnalysisInfo.Remove(SL);
    Result := 1;
  end;
end;

function TQuickPDF.GetAnalysisInfo(AnalysisID, AnalysisItem: Integer): WideString;
var
  SL: TQuickPDFStringList;
begin
  Result := '';
  SL := ValidAnalysisID(AnalysisID);
  if (Assigned(SL) and (AnalysisItem >= 0) and (AnalysisItem < SL.Count)) then
  begin
    Result := QPLUTF8Decode(SL[AnalysisItem]);
  end;
end;

function TQuickPDF.MergeFiles(const FirstFileName, SecondFileName,
  OutputFileName: WideString): Integer;
var
  FS1: TQuickPDFWideFileStream;
  FS2: TQuickPDFWideFileStream;
  FSOut: TQuickPDFWideFileStream;
begin
  Result := 0;
  if (FUnlocked) then
  begin
    try
      FS1 := QPLCreateFileStream(FirstFileName, fmOpenRead or fmShareDenyWrite);
      FS2 := QPLCreateFileStream(SecondFileName, fmOpenRead or fmShareDenyWrite);
      try
        if QPLFileExists(OutputFileName) then
        begin
          if QPLDeleteFile(OutputFileName) then FLastErrorCode := 0 else
            FLastErrorCode := 402;
        end;
        if FLastErrorCode <> 402 then
        try
          FSOut := QPLCreateFileStream(OutputFileName, fmCreate or fmShareExclusive);
          try
            Result := MergeStreams(FS1, FS2, FSOut);
          finally
            FSOut.Free;
          end;
        except
          FLastErrorCode := 403;
        end;
      finally
        FS1.Free;
        FS2.Free;
      end;
    except
      FLastErrorCode := 401;
    end;
  end else
    FLastErrorCode := 999;
end;

function TQuickPDF.GetFormFieldAnnotFlags(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.AnnotFlags;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldAnnotFlags(Index,
  NewFlags: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.AnnotFlags := NewFlags;
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldPrintable(Index,
  Printable: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Result := 1;
        Field.Printable := Printable = 1;
      end;
    end;
  end;
end;

function TQuickPDF.SetFormFieldCalcOrder(Index,
  Order: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    FSelDoc.AcroForm.SetCalcOrder(Field.FieldRef, Order);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetLineCap(LineCap: Integer): Integer;
begin
  if (LineCap >= 0) and (LineCap <= 3) then
  begin
    FSelDoc.PageTree.Painter.SetLineCap(LineCap);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.SetLineJoin(LineJoin: Integer): Integer;
begin
  if (LineJoin >= 0) and (LineJoin <= 3) then
  begin
    FSelDoc.PageTree.Painter.SetLineJoin(LineJoin);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.PageRotation: Integer;
begin
  Result := FSelDoc.PageRotation;
end;

function TQuickPDF.FindFonts: Integer;
begin
  Result := FSelDoc.FindFonts;
end;

function TQuickPDF.SaveImageToFile(const FileName: WideString): Integer;
begin
  Result := 0;
  if (Assigned(FSelImage)) then
  begin
    if (FSelImage.SaveToFile(FileName)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.AddNoteAnnotation(Left, Top: Double; AnnotType: Integer;
  PopupLeft, PopupTop, PopupWidth, PopupHeight: Double; const Title,
  Contents: WideString; Red, Green, Blue: Double; Open: Integer): Integer;
begin
  FSelDoc.PageTree.AddNoteAnnotation(TranslateX(Left), TranslateY(Top),
    AnnotType, TranslateX(PopupLeft), TranslateY(PopupTop),
    GetScale(PopupWidth), GetScale(PopupHeight),
    Title, Contents, Red, Green,
    Blue, Open = 1);
  Result := 1;
end;

function TQuickPDF.MovePath(NewX, NewY: Double): Integer;
begin
  FSelDoc.PageTree.Painter.MovePath(TranslateX(NewX), TranslateY(NewY));
  Result := 1;
end;

function TQuickPDF.DrawPathEvenOdd(PathOptions: Integer): Integer;
var
  Fill: Boolean;
  Outline: Boolean;
begin
  Fill := (PathOptions = 1) or (PathOptions = 2);
  Outline := (PathOptions = 0) or (PathOptions = 2);
  FSelDoc.PageTree.Painter.DrawPathEvenOdd(Fill, Outline);
  Result := 1;
end;

function TQuickPDF.SetClippingPathEvenOdd: Integer;
begin
  FSelDoc.PageTree.Painter.SetClippingPathEvenOdd;
  Result := 1;
end;

function TQuickPDF.SetCropBox(Left, Top, Width,
  Height: Double): Integer;
begin
  FSelDoc.PageTree.SetCropBox(TranslateX(Left), TranslateY(Top),
    GetScale(Width), GetScale(Height));
  Result := 1;
end;

function TQuickPDF.DrawRotatedImage(Left, Bottom, Width, Height,
  Angle: Double): Integer;
begin
  if Assigned(FSelImage) then
  begin
    FSelDoc.PageTree.UseImage(FSelImage);
    FSelDoc.PageTree.Painter.DrawRotatedImage(FSelImage, TranslateX(Left),
      TranslateY(Bottom), GetScale(Width), GetScale(Height), Angle);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.DrawRotatedCapturedPage(CaptureID: Integer; Left,
  Bottom, Width, Height, Angle: Double): Integer;
var
  CP: TPDFCapturedPage;
begin
  Result := 0;
  try
    CP := ValidCaptureID(CaptureID);
    if Assigned(CP) then
    begin
      FSelDoc.PageTree.UseXObject(CP.XObjectName, CP.XObject);
      FSelDoc.PageTree.Painter.DrawXObjectAngle(CP.XObjectName, TranslateX(Left),
        TranslateY(Bottom), GetScale(Width),
        GetScale(Height), CP.OriginalWidth, CP.OriginalHeight, Angle);
      Result := 1;
    end;
  except
  end;
end;

function TQuickPDF.SetPageThumbnail: Integer;
begin
  if Assigned(FSelImage) then
  begin
    FSelDoc.PageTree.SetThumb(FSelImage.IndRef);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.AddImageFromFile(const FileName: WideString;
  Options: Integer): Integer;
var
  Image: TPDFImage;
  FS: TQuickPDFWideFileStream;
begin
  Result := 0;
  if QPLFileExists(FileName) then
  try
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    try
      if Options = -1 then
      begin
        FSelDoc.ImageGDIPlusSettings := FGDIPlusSettings;
      end;

      Image := FSelDoc.NewImageFromStream(FS, Options, FSelDoc.CompressImages);

      if Image <> nil then
      begin
        if (Image.Contains16Bit) then
        begin
          if FSelDoc.Version < '1.5' then FSelDoc.Version := '1.5';
        end;

        Result := IntCast(Image);
        FSelImage := Image;
      end;
    finally
      FS.Free;
    end;
  except
  end;
end;

function TQuickPDF.AddImageFromStream(InStream: TStream;
  Options: Integer): Integer;
var
  Image: TPDFImage;
begin
  Result := 0;

  Image := FSelDoc.NewImageFromStream(InStream, Options,
    FSelDoc.CompressImages);

  if Image <> nil then
  begin
    if (Image.Contains16Bit) then
    begin
      if FSelDoc.Version < '1.5' then FSelDoc.Version := '1.5';
    end;

    Result := IntCast(Image);
    FSelImage := Image;
  end;
end;

function TQuickPDF.MergeStreams(FirstStream, SecondStream,
  OutputStream: TStream): Integer;
var
  X: Integer;
  Obj: TPDFObject;
  Offset: Integer;
  Doc1: TSmartPDFDocument;
  Doc2: TSmartPDFDocument;
  Reader1: TSmartPDFReader;
  Reader2: TSmartPDFReader;
  Info1: TSmartPDFInfo;
  Info2: TSmartPDFInfo;
  PagesRef1: TPDFIndRef;
  PagesRef2: TPDFIndRef;
  Writer: TSmartPDFWriter;
  TempStruct: TPDFStructure;
  OC: Integer;
begin
  Result := 0;
  if (FUnlocked) then
  begin
    Reader1 := TSmartPDFReader.Create(FirstStream);
    Doc1 := TSmartPDFDocument.Create(Reader1);
    Info1 := TSmartPDFInfo.Create(Reader1, '');
    Reader2 := TSmartPDFReader.Create(SecondStream);
    Doc2 := TSmartPDFDocument.Create(Reader2);
    Info2 := TSmartPDFInfo.Create(Reader2, '');            
    try
      if (Info1.SecurityInfo(0) = '0') and (Info2.SecurityInfo(0) = '0') then
      begin
        if (Reader1.ErrorCode = ecNone) and (Reader2.ErrorCode = ecNone) then
        begin
          Reader1.FixTrailer;
          Reader2.FixTrailer;
          Writer := TSmartPDFWriter.Create(OutputStream);
          try
            Writer.New;
            TempStruct := TPDFStructure.Create;
            try
              PagesRef1 := Doc1.PagesRef;
              PagesRef2 := Doc2.PagesRef;
              Doc1.AddAcroForm;
              Offset := Doc1.ObjectCount;

              Doc2.FixPages;
              Doc2.SetPagesParent(PagesRef1.ObjNum - Offset, PagesRef1.GenNum);
              Doc1.AddPages(PagesRef2.ObjNum + Offset, PagesRef2.GenNum, Doc2.PageCount);

              if Doc2.HasFields then
                Doc1.AddFields(Doc2.FieldsArray, Doc2.COArray, Offset,
                  Doc2.FormNeedAppearances);

              if Doc2.HasOutline then
              begin
                if Doc1.HasOutline then
                begin
                  Doc1.AppendOutline(Doc2, Offset);
                end else
                begin
                  Doc1.SetOutline(Doc2.GetOutlineRef, Offset);
                end;
              end;

              FSubProgressScale := 0.75;
              FSubProgressOffset := 0;
              OC := Doc1.ObjectCount;
              for X := 1 to OC do
              begin
                SubProgress(X * 100 div OC);
                Obj := Doc1.GetObject(X, TempStruct);
                if Assigned(Obj) then
                  Writer.AddObject(X, Doc1.GetGenNum(X), Obj.Output)
                else
                  Writer.AddObject(X, Doc1.GetGenNum(X), 'null');
                if TempStruct.ObjectCount > ObjCountLimit then
                begin
                  TempStruct.Free;
                  TempStruct := TPDFStructure.Create;
                end;
              end;
              SubProgress(100);
              TempStruct.Free;
              TempStruct := TPDFStructure.Create;
              OC := Doc2.ObjectCount;
              FSubProgressScale := 0.25;
              FSubProgressOffset := 75;
              for X := 1 to OC do
              begin
                SubProgress(X * 100 div OC);
                Obj := Doc2.GetObject(X, TempStruct);
                if Assigned(Obj) then
                begin
                  Obj.ShiftIndRef(Offset);
                  Writer.AddObject(X + Offset, Doc2.GetGenNum(X), Obj.Output);
                end else
                  Writer.AddObject(X + Offset, Doc2.GetGenNum(X), 'null');
                if TempStruct.ObjectCount > ObjCountLimit then
                begin
                  TempStruct.Free;
                  TempStruct := TPDFStructure.Create;
                end;
              end;
              SubProgress(100);
            finally
              TempStruct.Free;
            end;
            Reader1.TrailerDict.Add('Size', Reader1.ReaderStructure.NewNumeric(Doc1.ObjectCount + Doc2.ObjectCount + 1));
            Writer.AddTrailer(Reader1.TrailerDict);
            Result := 1;
          finally
            Writer.Free;
          end;
        end else
          FLastErrorCode := 409;
      end else
        FLastErrorCode := 410;
    finally
      Doc1.Free;
      Info1.Free;
      Reader1.Free;
      Doc2.Free;
      Info2.Free;
      Reader2.Free;
    end;
  end;
end;

function TQuickPDF.SaveToStream(OutStream: TStream): Integer;
var
  S: AnsiString;
begin
  S := SaveToString;
  if S <> '' then Result := 1 else Result := 0;
  OutStream.Write(S[1], Length(S));
end;

function TQuickPDF.AddToFileList(const ListName,
  FileName: WideString): Integer;
var
  I: Integer;
  List: TQuickPDFStringList;
begin
  Result := 1;
  List := nil;
  I := FFileLists.IndexOf(AnsiString(ListName));
  if I >= 0 then
  begin
    if FFileLists.Objects[I] is TQuickPDFStringList then
      List := TQuickPDFStringList(FFileLists.Objects[I]);
  end;
  if not Assigned(List) then
  begin
    if I >= 0 then FFileLists.Delete(I);
    List := TQuickPDFStringList.Create;
    FFileLists.AddObject(AnsiString(ListName), List);
  end;

  List.Add(QPLUTF8Encode(FileName));
end;

function TQuickPDF.ClearFileList(const ListName: WideString): Integer;
var
  I: Integer;
begin
  Result := 0;
  I := FFileLists.IndexOf(AnsiString(ListName));
  if I >= 0 then
  begin
    if Assigned(FFileLists.Objects[I]) then
      FFileLists.Objects[I].Free;
    FFileLists.Delete(I);
    Result := 1;
  end;
end;

function TQuickPDF.MergeFileList(const ListName,
  OutputFileName: WideString): Integer;
var
  I: Integer;
  X: Integer;
  List: TQuickPDFStringList;
  Temp1: WideString;
  Temp2: WideString;
  MergeResult: Integer;
  ListNameA: AnsiString;
begin
  ListNameA := AnsiString(ListName);

  Result := 0;

  if (QPLFileExists(OutputFileName)) then
    if not (QPLCanCreateFileStream(OutputFileName, fmOpenReadWrite)) then
      exit;

  if TestTempPath = 1 then
  begin
    Temp2 := FTempPath + WideString('QuickPDFMergeTemp2' + QPLRandomID + '.dat');
    Temp1 := FTempPath + WideString('QuickPDFMergeTemp1' + QPLRandomID + '.dat');
    List := nil;
    I := FFileLists.IndexOf(ListNameA);
    if I >= 0 then
    begin
      if FFileLists.Objects[I] is TQuickPDFStringList then
        List := TQuickPDFStringList(FFileLists.Objects[I]);
      if Assigned(List) then
      begin
        if (List.Count = 1) then
        begin
          if (CopyFile(QPLUnicodeParm(List[0]), OutputFileName)) then
          begin
            FSubProgressPiece := 1;
            FSubProgressCount := 1;
            FSubProgressScale := 1;
            FSubProgressOffset := 0;
            SubProgress(100);
            Result := 1;
          end;
        end else
        if (List.Count >= 2) then
        begin
          FSubProgressPiece := 1;
          FSubProgressCount := List.Count - 1;
          try
            if QPLFileExists(Temp1) then QPLDeleteFile(Temp1);
            MergeResult := MergeFiles(QPLUTF8Decode(List[0]),
              QPLUTF8Decode(List[1]), Temp1);
            if MergeResult = 1 then Result := 2;
            X := 1;
            while (X < List.Count - 1) and (MergeResult = 1) do
            begin
              Inc(X);
              FSubProgressPiece := X;
              CopyFile(Temp1, Temp2);
              if QPLFileExists(Temp1) then QPLDeleteFile(Temp1);
              MergeResult := MergeFiles(Temp2, QPLUTF8Decode(List[X]),
                Temp1);
              if MergeResult = 1 then Result := X + 1;
            end;

            if MergeResult = 1 then
              if (CopyFile(Temp1, OutputFileName) = False) then
                Result := 0;

            QPLDeleteFile(Temp1);
            QPLDeleteFile(Temp2);
          finally
            FSubProgressPiece := 1;
            FSubProgressCount := 1;
            FSubProgressScale := 1;
            FSubProgressOffset := 0;
            SubProgress(100);
          end;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.CopyFile(const Source, Target: WideString): Boolean;
var
  FSIn, FSOut: TQuickPDFWideFileStream;
begin
  Result := False;
  if QPLFileExists(Source) then
  begin
    if QPLFileExists(Target) then QPLDeleteFile(Target);
    if not QPLFileExists(Target) then
    begin
      try
        FSIn := QPLCreateFileStream(Source, fmOpenRead or fmShareDenyWrite);
        try
          FSOut := QPLCreateFileStream(Target, fmCreate);
          try
            FSOut.CopyFrom(FSIn, FSIn.Size);
            if FSOut.Size = FSIn.Size then Result := True;
          finally
            FSOut.Free;
          end;
        finally
          FSIn.Free;
        end;
      except
      end;
    end;
  end;
end;

function TQuickPDF.AddImageFromString(const Source: AnsiString; Options: Integer): Integer;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    MS.Write(Source[1], System.Length(Source));
    Result := AddImageFromStream(MS, Options);
  finally
    MS.Free;
  end;
end;

function TQuickPDF.FileListItem(const ListName: WideString;
  Index: Integer): WideString;
var
  I: Integer;
  List: TQuickPDFStringList;
begin
  Result := '';
  List := nil;
  I := FFileLists.IndexOf(AnsiString(ListName));
  if I >= 0 then
  begin
    if FFileLists.Objects[I] is TQuickPDFStringList then
      List := TQuickPDFStringList(FFileLists.Objects[I]);
    if Assigned(List) then
    begin
      if (Index > 0) and (Index <= List.Count) then
        Result := QPLUTF8Decode(List[Index - 1]);
    end;
  end;
end;

function TQuickPDF.OutlineCount: Integer;
begin
  Result := FSelDoc.OutlineCount;
end;

function TQuickPDF.OutlineTitle(OutlineID: Integer): WideString;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := FSelDoc.OutlineTitle(Outline);
  end else
  begin
    Result := '';
  end;
end;

function TQuickPDF.GetOutlineID(Index: Integer): Integer;
begin
  Result := IntCast(FSelDoc.GetOutlineFromIndex(Index));
end;

function TQuickPDF.SetOutlineColor(OutlineID: Integer; Red, Green,
  Blue: Double): Integer;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    FSelDoc.SetOutlineColor(Outline, Red, Green, Blue);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetOutlineStyle(OutlineID, SetItalic,
  SetBold: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    FSelDoc.SetOutlineStyle(Outline, SetItalic = 1, SetBold = 1);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetOutlineDestination(OutlineID, DestPage: Integer;
  DestPosition: Double): Integer;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    FSelDoc.SetOutlineDest(Outline, DestPage, TranslateY(DestPosition));
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetOutlineTitle(OutlineID: Integer;
  const NewTitle: WideString): Integer;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    FSelDoc.SetOutlineTitle(Outline, NewTitle);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.RemoveOutline(OutlineID: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    if FSelDoc.RemoveOutline(Outline) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.OpenOutline(OutlineID: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := 1;
    FSelDoc.OpenOutline(Outline);
  end;
end;

function TQuickPDF.CloseOutline(OutlineID: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := 1;
    FSelDoc.CloseOutline(Outline);
  end;
end;

function TQuickPDF.RemoveAppearanceStream(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.RemoveAppearanceStream;
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.GetFormFieldAlignment(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.Alignment;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldAlignment(Index,
  Alignment: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) and (Alignment >= 0) and (Alignment <= 3) then
  begin
    Field.Alignment := Alignment;
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.GetFormFieldMaxLen(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.MaxLen;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldMaxLen(Index,
  NewMaxLen: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) and (NewMaxLen >= 0) then
  begin
    Field.MaxLen := NewMaxLen;
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetTextScaling(ScalePercentage: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetTextScaling(ScalePercentage);
  Result := 1;
end;

function TQuickPDF.GetTempPath: WideString;
begin
  Result := FTempPath;
end;

function TQuickPDF.SetTempPath(const NewPath: WideString): Integer;
var
  OldTempPath: WideString;
begin
  Result := 0;
  OldTempPath := FTempPath;
  FTempPath := NewPath;
{$IFDEF QPL_OS_MAC}
  if Copy(FTempPath, Length(FTempPath), 1) <> '/' then
    FTempPath := FTempPath + WideString('/');
{$ELSE}
  if Copy(FTempPath, Length(FTempPath), 1) <> '\' then
    FTempPath := FTempPath + WideString('\');
{$ENDIF}
  if QPLDirectoryExists(FTempPath) then
    Result := TestTempPath;
  if Result = 0 then FTempPath := OldTempPath;
end;

function TQuickPDF.TestTempPath: Integer;
var
  FS: TQuickPDFWideFileStream;
  WIn: Word;
  WOut: Word;
  TestFileName: WideString;
begin
  Result := 0;
  if QPLDirectoryExists(FTempPath) then
  begin
    TestFileName := FTempPath + WideString(QPLRandomID + '.dat');

    // Check if the random file already exists
    // and if it does then delete it
    if QPLFileExists(TestFileName) then
    try
      QPLDeleteFile(TestFileName);
    except
    end;

    // Make sure the random file does not exist
    if not QPLFileExists(TestFileName) then
    try
      // Generate a random 16-bit value that isn't zero
      WIn := Random($FFFE) + 1;

      // Try to create the file and write a random 16-bit value
      FS := QPLCreateFileStream(TestFileName, fmCreate);
      try
        FS.Write(WIn, 2);
      finally
        FS.Free;
      end;

      // Make sure the test value is different to the random input
      WOut := 0;

      // Try to read the output word from the file
      FS := QPLCreateFileStream(TestFileName, fmOpenRead);
      try
        FS.Read(WOut, 2);
      finally
        FS.Free;
      end;

      if (WOut = WIn) then Result := 1;
    except
    end;

    // Check again if the random file exists
    // and if it does then try to delete it
    if QPLFileExists(TestFileName) then
    try
      QPLDeleteFile(TestFileName);
    except
    end;
  end;
end;

function TQuickPDF.SetBreakString(
  const NewBreakString: WideString): Integer;
begin
  FSelDoc.BreakString := NewBreakString;
  Result := 1;
end;

function TQuickPDF.FixWideDelimited(const Text,
  Delimiter: WideString): WideString;
var
  Start: WideString;
  P: Integer;
  L: Integer;
begin
  L := Length(Delimiter) - 1;
  Start := Text;
  Result := '';
  repeat
    P := Pos(Delimiter, Start);
    if (P > 0) then
    begin
      if (P > 1) then
      begin
        Result := Result + FSelFont.FixWideText(Copy(Start, 1, P - 1)) + Delimiter;
      end else
      begin
        Result := Result + Delimiter;
      end;
      Delete(Start, 1, P + L);
    end else
    begin
      Result := Result + FSelFont.FixWideText(Start);
    end;
  until P = 0;
end;

function TQuickPDF.FitTextBox(Left, Top, Width, Height: Double;
  const Text: WideString; Options: Integer): Integer;
begin
  if ((Options >= 0) and (Options <= 2)) or ((Options >= 100) and (Options <= 102)) or ((Options >= 1000) and (Options <= 1002)) then
  begin
    CheckFontSelection;
    FSelDoc.PageTree.Painter.FitWideTextBox(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), FixWideDelimited(Text, FSelDoc.BreakString),
      Options, FSelDoc.BreakString);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.GetFormFieldFontName(Index: Integer): WideString;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := WideString(Field.FontName);
    if Field.TempField then Field.Free;
  end else
    Result := '';
end;

function TQuickPDF.GetFormFieldTextSize(Index: Integer): Double;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.FontSize;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.GetFormFontCount: Integer;
begin
  if FSelDoc.HasFormData then
    Result := FSelDoc.AcroForm.FontCount
  else
    Result := 0;
end;

function TQuickPDF.GetFormFontName(FontIndex: Integer): WideString;
begin
  if FSelDoc.HasFormData then
  begin
    Result := WideString(FSelDoc.AcroForm.GetFormFontName(FontIndex));
  end else
  begin
    Result := '';
  end;
end;

function TQuickPDF.SetFormFieldFont(Index,
  FontIndex: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) and (FontIndex >= 1) and (FontIndex <= GetFormFontCount) then
  begin
    Field.SetFontIndex(FontIndex);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.AddFormFont(FontID: Integer): Integer;
var
  Font: TPDFFont;
begin
  Result := 0;
  Font := ValidFontID(FontID);
  if (Assigned(Font) and FSelDoc.IsFont(Font)) then
  begin
    if (not FSelDoc.HasFormData) then
    begin
      FSelDoc.NewAcroForm;
    end;
    if (FSelDoc.HasFormData) then
    begin
      Result := FSelDoc.AcroForm.AddFont(Font);
    end;
  end;
end;

function TQuickPDF.GetFormFieldColor(Index,
  ColorComponent: Integer): Double;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) and (ColorComponent >= 1) and (ColorComponent <= 3) then
  begin
    Result := Field.GetFontColor(ColorComponent);
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldColor(Index: Integer; Red, Green,
  Blue: Double): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) and (Red >= 0) and (Red <= 1)
    and (Green >= 0) and (Green <= 1) and (Blue >= 0) and (Blue <= 1) then
  begin
    Field.SetFontColor(Red, Green, Blue);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldTextSize(Index: Integer;
  NewTextSize: Double): Integer;
var
  Field: TPDFField;
  FontID: Integer;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    if GetFormFontCount = 0 then
    begin
      FontID := AddStandardFont(4);
      AddFormFont(FontID);
    end;
    Field.FontSize := NewTextSize;
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldTextFlags(Index, Multiline, Password,
  FileSelect, DoNotSpellCheck, DoNotScroll: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.SetTextFlags(MultiLine = 1, Password = 1, FileSelect = 1,
      DoNotSpellCheck = 1, DoNotScroll = 1, False);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldRotation(Index,
  Angle: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) and (Angle mod 90 = 0) then
  begin
    Field.SetRotation(Angle);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.UpdateAppearanceStream(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.UpdateAppearanceStream;
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.UpdateFlatten(Index: Integer; Update: Boolean): Integer;
var
  CP: TPDFCapturedPage;
  Field: TPDFField;
  Ref: TPDFIndRef;
  OldPage: Integer;
  FieldType: TPDFFieldType;
  ParentField: TPDFField;
  X: Integer;

  procedure DrawAnnot;
  var
    CheckObj: TPDFObject;
    Page, J: Integer;
    Dict: TPDFDictionary;
    Obj: TPDFObject;
    A: TPDFArray;
  begin
    if Field.Page < 0 then
      SetFormFieldPage(Index, GetFormFieldPage(Index));
    if Assigned(Ref) and Assigned(Field) and (Field.Page > 0) and
      (Field.Width > 0) and (Field.Height > 0) then
    begin
      CheckObj := Ref.Obj;
      if CheckObj is TPDFStream then
      begin
        TPDFStream(CheckObj).Dictionary.Add('Subtype', FSelDoc.Structure.NewCommonName('Form'));

        if (Field.FieldType = ftSignature) then
        begin
          // We need to find the matching Annot entry as Field.Page is always 1 for a signature.
          // We will match by title and assume only 1 annot per Signature.

          for Page := 1 to FSelDoc.PageCount do
          begin
            Dict := FSelDoc.PageTree.GetPage(Page);
            if Assigned(Dict) then
            begin
              Obj := Dict.FindValueByKeyName('Annots', True);
              if Obj is TPDFArray then
              begin
                A := TPDFArray(Obj);

                for J := A.Count downto 1 do
                begin
                  Obj := A.Item[J-1];
                  if (Obj is TPDFIndRef) then
                    Obj := TPDFIndRef(Obj).Obj;
                  if (Obj is TPDFDictionary) then
                  begin
                    Dict := TPDFDictionary(Obj);
                    Obj := Dict.FindValueByKeyName('T', True);
                    if (Obj is TPDFString) then
                      if (TPDFString(Obj).AsTextString = Field.Title) then
                      begin
                        SelectPage(Page);
                      end;
                  end;
                end;
              end;
            end;
          end
        end
        else
          SelectPage(Field.Page);

        CP := TPDFCapturedPage.Create;
        try
          CP.XObject := Ref;
          CP.XObjectName := 'QuickPDFField' + QPLRandomID;
          CP.OriginalWidth := Field.Width;
          CP.OriginalHeight := Field.Height;

          if (CheckObj is TPDFStream) then
          begin
            Obj := TPDFStream(CheckObj).Dictionary.FindValueByKeyName('BBox', True);
            if (Obj is TPDFArray) then
            begin
              A := TPDFArray(Obj);
              if (A.Item[0] is TPDFNumeric) and (A.Item[1] is TPDFNumeric) and
                 (A.Item[2] is TPDFNumeric) and (A.Item[3] is TPDFNumeric) then
              begin
                CP.OriginalWidth := TPDFNumeric(A.Item[2]).AsDouble - TPDFNumeric(A.Item[0]).AsDouble;
                CP.OriginalHeight := TPDFNumeric(A.Item[3]).AsDouble - TPDFNumeric(A.Item[1]).AsDouble;
              end;
            end;
          end;

          CP.XOffset := 0;
          CP.YOffset := 0;
          FSelDoc.PageTree.UseXObject(CP.XObjectName, CP.XObject);
          FSelDoc.PageTree.Painter.DrawXObject(CP, Field.Left,
            Field.Top, Field.Width, Field.Height);
        finally
          CP.Free;
        end;
      end;
    end;
  end;

begin
  Result := 0;
  OldPage := SelectedPage;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    FieldType := Field.FieldType;
    if ((FieldType = ftText) or (FieldType = ftPushButton) or
      (FieldType = ftCheckbox) or (FieldType = ftChoice) or
      (FieldType = ftRadioButton) or (FieldType = ftSignature)) then
    begin
      Ref := nil;

      if (Field.KidCount > 0) then    // we have two fields with the same name.
      begin
        ParentField := Field;
        for X := 1 to ParentField.KidCount do
        begin
          Field := ParentField.MakeTempChild(X);
          try
            Ref := nil;
            if Assigned(Field) then
            begin
              if (FieldType = ftRadioButton) or (FieldType = ftCheckbox) then
                Ref := Field.GetSelectedAPDictRef
              else
                Ref := Field.GetNormalAPDictRef(Update);

              if Assigned(Ref) then DrawAnnot;
            end;
          finally
            Field.Free;
          end;
        end;
        Field := ParentField;
      end else                        // Single field.
      begin
        if (FieldType = ftRadioButton) or (FieldType = ftCheckbox) then
          Ref := Field.GetSelectedAPDictRef
        else
          Ref := Field.GetNormalAPDictRef(Update);
        DrawAnnot;
      end;

      DeleteFormField(Index);
      Field := nil;
      Result := 1;
    end;

    if Assigned(Field) and Field.TempField then Field.Free;
  end;

  SelectPage(OldPage);
end;

function TQuickPDF.FlattenFormField(Index: Integer): Integer;
begin
  Result := UpdateFlatten(Index, False);
end;

function TQuickPDF.ImageHorizontalResolution: Integer;
begin
  if Assigned(FSelImage) then
    Result := FSelImage.HorizontalDPI
  else
    Result := 0;
end;

function TQuickPDF.ImageVerticalResolution: Integer;
begin
  if Assigned(FSelImage) then
    Result := FSelImage.VerticalDPI
  else
    Result := 0;
end;

function TQuickPDF.ImageResolutionUnits: Integer;
begin
  if Assigned(FSelImage) then
    Result := FSelImage.DPIUnits
  else
    Result := 0;
end;

function TQuickPDF.GetFirstOutline: Integer;
begin
  Result := IntCast(FSelDoc.FirstOutline);
end;

function TQuickPDF.GetFirstChildOutline(OutlineID: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := IntCast(FSelDoc.FirstChildOutline(Outline));
  end;
end;

function TQuickPDF.GetNextOutline(OutlineID: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := IntCast(FSelDoc.NextOutline(Outline));
  end;
end;

function TQuickPDF.GetPrevOutline(OutlineID: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := IntCast(FSelDoc.PrevOutline(Outline));
  end;
end;

function TQuickPDF.GetParentOutline(OutlineID: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := IntCast(FSelDoc.ParentOutline(Outline));
  end;
end;

function TQuickPDF.SetOutlineJavaScript(OutlineID: Integer;
  const JavaScript: WideString): Integer;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    FSelDoc.SetOutlineJS(Outline, JavaScript);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetOutlineWebLink(OutlineID: Integer;
  const Link: WideString): Integer;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    FSelDoc.SetOutlineWebLink(Outline, AnsiString(Link));
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.NewStaticOutline(Parent: Integer;
  const Title: WideString): Integer;
var
  ParentOutline: TPDFIndRef;
begin
  ParentOutline := ValidOutlineID(Parent);
  if ((Parent = 0) or Assigned(ParentOutline)) then
  begin
    Result := IntCast(FSelDoc.NewStaticOutline(ParentOutline, Title));
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetOutlinePage(OutlineID: Integer): Integer;
var
  Dest: TPDFObject;
  DestID: Integer;
  Action: TPDFDictionary;
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    // First see if the outline has a /Dest entry
    Dest := FSelDoc.GetOutlineDest(Outline);
    if (Assigned(Dest)) then
    begin
      Result := GetDestPage(IntCast(Dest));
    end else
    begin
      // The outline does not have a /Dest entry, so look for an action
      Action := FSelDoc.GetOutlineAction(Outline);
      if (Assigned(Action)) then
      begin
        DestID := GetActionDest(IntCast(Action));
        Result := GetDestPage(DestID);
      end;
    end;
  end;
end;

function TQuickPDF.FormFieldWebLinkAction(Index: Integer;
  const ActionType, Link: WideString): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.AddWebLinkAction(AnsiString(ActionType), AnsiString(Link));
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.GetFormFieldWebLink(Index: Integer;
  const ActionType: WideString): WideString;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := WideString(Field.GetWebLinkAction(AnsiString(ActionType)));
    if Field.TempField then Field.Free;
  end else
    Result := '';
end;

function TQuickPDF.SetFormFieldTabOrder(Index,
  Order: Integer): Integer;
var
  Field: TPDFField;
  Page: Integer;
  A: TPDFArray;
  O: TPDFObject;
  D: TPDFDictionary;
  OldAnnotPos: Integer;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    OldAnnotPos := GetFormFieldTabOrder(Index);

    if (OldAnnotPos > 0) and Assigned(Field) then
    begin
      Page := Field.Page;
      D := FSelDoc.PageTree.GetPage(Page);
      if Assigned(D) then
      begin
        O := D.FindValueByKeyName('Annots', True);
        if O is TPDFArray then
        begin
          A := TPDFArray(O);
          if (Order >= 1) and (Order <= A.Count) then
          begin
            A.Move(OldAnnotPos - 1, Order - 1);
            Result := 1;
          end;
        end;
      end;
    end;
    if Field.TempField then Field.Free;    
  end;
end;

function TQuickPDF.GetFormFieldTabOrder(Index: Integer): Integer;
var
  Field: TPDFField;
  Page: Integer;
  A: TPDFArray;
  O: TPDFObject;
  D: TPDFDictionary;
  X: Integer;
  Test: AnsiString;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Page := Field.Page;
    D := FSelDoc.PageTree.GetPage(Page);
    if Assigned(D) then
    begin
      O := D.FindValueByKeyName('Annots', True);
      if O is TPDFArray then
      begin
        A := TPDFArray(O);
        X := 0;
        Test := Field.FieldRef.Output;
        while (X < A.Count) and (Result = 0) do
        begin
          if A.Item[X].Output = Test then
            Result := X + 1;
          X := X + 1;
        end;
      end;
    end;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.ContentStreamSafe: Integer;
begin
  if FSelDoc.PageTree.QuickPDFLayer then Result := 1 else Result := 0;
end;

function TQuickPDF.UseUnsafeContentStreams(SafetyLevel: Integer): Integer;
begin
  Result := 0;
  if (SafetyLevel >= 0) and (SafetyLevel <= 1) then
  begin
    Result := 1;
    FSelDoc.UseUnsafeLayers := SafetyLevel = 1;
    if FSelDoc.PageTree.LayerCount > 1 then
    begin
      if (FSelDoc.PageTree.Layer = FSelDoc.PageTree.LayerCount)
        and (FSelDoc.PageTree.ExtractContent = '') then
      begin
        DeleteContentStream;
      end;
    end;
  end;
end;

{$IFNDEF QPL_OS_WINDOWS}
function TQuickPDF.AddTrueTypeFontFromFile(
  const FileName: WideString): Integer;
var
  FS: TQuickPDFWideFileStream;
  Font: TPDFFont;
begin
  Result := 0;
  if (QPLFileExists(FileName)) then
  begin
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    try
      Font := FSelDoc.NewTrueTypeFontFromStream(FS);
      if (Assigned(Font)) then
      begin
        Result := IntCast(Font);
        SelectFont(Result);
      end;
    finally
      FS.Free;
    end;
  end;
end;
{$ELSE}
function TQuickPDF.AddTrueTypeFontFromFile(
  const FileName: WideString): Integer;
var
  Font: TPDFFont;
  FontName: AnsiString;
  TempFile: WideString;
  FS: TQuickPDFWideFileStream;
  P: Integer;
  Continue: Boolean;
begin
  Result := 0;
  Continue := True;
  TempFile := FTempPath + WideString('QuickPDFTempFont' + QPLRandomID + '.fot');
  if (QPLFileExists(TempFile)) then
  begin
    QPLDeleteFile(TempFile);
  end;
  if (QPLFileExists(FileName)) then
  begin
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    try
      if (IsOpenType(FS)) then
      begin
        Font := FSelDoc.NewOpenTypeFont(FS);
        if (Assigned(Font)) then
        begin
          Result := IntCast(Font);
          SelectFont(Result);
        end;
        Continue := False;
      end;
    finally
      FS.Free;
    end;

    if (Continue) then
    begin
      if CreateScalableFontResourceW(1, PWideChar(TempFile), PWideChar(FileName), nil) then
      begin
        FS := QPLCreateFileStream(TempFile, fmOpenRead or fmShareDenyWrite);
        try
          SetLength(FontName, FS.Size);
          FS.Read(FontName[1], Length(FontName));
          P := QPLPos('FONTRES:', FontName);
          if P > 0 then
          begin
            Delete(FontName, 1, P + 7);
            P := QPLPos(#0, FontName);
            if P > 0 then
            begin
              Delete(FontName, P, MaxInt);
            end else
              FontName := '';
          end else
            FontName := '';
        finally
          FS.Free;
        end;

        if FontName <> '' then
        begin
          AddFontResourceW(PWideChar(FileName));
          try
            Font := FSelDoc.NewTrueTypeFont(FontName, True, False, FKernSupport <> ksNoLoad);
            if Font <> nil then
            begin
              Result := IntCast(Font);
              SelectFont(Result);
            end;
          finally
            RemoveFontResourceW(PWideChar(FileName));
          end;
        end;
      end;
      if QPLFileExists(TempFile) then QPLDeleteFile(TempFile);
    end;
  end;
end;
{$ENDIF}

function TQuickPDF.SetFormFieldPage(Index, NewPage: Integer): Integer;
var
  OldPage: Integer;
  OldFieldPage: Integer;
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    OldPage := SelectedPage;
    try
      OldFieldPage := Field.Page;
      if OldFieldPage > 0 then
      begin
        if SelectPage(OldFieldPage) = 1 then
          FSelDoc.PageTree.ReleaseField(Field);
      end;
      if SelectPage(NewPage) = 1 then
      begin
        Result := 1;
        Field.SetPageRef(SelectedPage, FSelDoc.PageTree.PageRef);
        FSelDoc.PageTree.UseField(Field);
      end;
    finally
      SelectPage(OldPage);
    end;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldPrintable(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    if Field.Printable then Result := 1;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldVisible(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    if Field.Visible then Result := 1;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.SetOutlineDestinationZoom(OutlineID,
  DestPage: Integer; DestPosition: Double; Zoom: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline) and (Zoom >= -2) and (Zoom <= 6400)) then
  begin
    FSelDoc.SetOutlineDest(Outline, DestPage, TranslateY(DestPosition), Zoom);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.GetFormFieldKidTempIndex(Index,
  KidIndex: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    //if (Field.FieldType = ftRadioButton) or (Field.FieldType = ftCheckbox) or (Field.FieldType = ftParent) then
    if (Field.KidCount > 0) then
    begin
      if (KidIndex > 0) and (KidIndex <= Field.KidCount) then                   // ADC
        Result := $55000000 + Index * 256 + KidIndex;
    end;
  end;
end;

function TQuickPDF.GetFormFieldRotation(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.GetRotation;
    if Field.TempField then Field.Free;
  end;
end;

type
  TPDFMergeData = record
    FileNameIndex: Integer;
    ObjectCount: Integer;
    PagesRefObjNum: Integer;
    PagesRefGenNum: Integer;
    PageCount: Integer;
    FieldsArray: AnsiString;
    FieldsCOArray: AnsiString;
    FormNeedAppearances: Boolean;
    AcroFormFonts: AnsiString;
  end;

function TQuickPDF.MergeFileListFast(const ListName,
  OutputFileName: WideString): Integer;
var
  X: Integer;
  Obj, TempObj: TPDFObject;
  Offset: Integer;
  Doc1: TSmartPDFDocument;
  Doc2: TSmartPDFDocument;
  Reader1: TSmartPDFReader;
  Reader2: TSmartPDFReader;
  Info1: TSmartPDFInfo;
  PagesRef1: TPDFIndRef;
  Writer: TSmartPDFWriter;
  TempStruct: TPDFStructure;
  MergeData: array of TPDFMergeData;
  Stream1: TQuickPDFWideFileStream;
  Stream2: TQuickPDFWideFileStream;
  OutputStream: TQuickPDFWideFileStream;
  List: TQuickPDFStringList;
  I: Integer;
  L: Integer;
  Verdict: AnsiString;
  D: Integer;
  OC: Integer;
  TempA: TPDFArray;
  TempA2: TPDFArray;
  TempD: TPDFDictionary;
  ListNameA: AnsiString;
begin
  ListNameA := AnsiString(ListName);

  Result := 0;

  if (FileExists(OutputFileName)) then
    if (DeleteFile(OutputFileName) =  False) then
      Exit;

  SetLength(MergeData, 0);
  if (FUnlocked) then
  begin
    List := nil;
    I := FFileLists.IndexOf(ListNameA);
    if I >= 0 then
    begin
      if FFileLists.Objects[I] is TQuickPDFStringList then
        List := TQuickPDFStringList(FFileLists.Objects[I]);
      ClearFileList(ListName + 'Result');
      if Assigned(List) then
      begin
        if (List.Count = 1) then
        begin
          if QPLFileExists(QPLUnicodeParm(List[0])) then
          begin
            Stream1 := QPLCreateFileStream(QPLUnicodeParm(List[0]), fmOpenRead or fmShareDenyWrite);
            try
              Reader1 := TSmartPDFReader.Create(Stream1);
              Doc1 := TSmartPDFDocument.Create(Reader1);
              Info1 := TSmartPDFInfo.Create(Reader1, '');
              try
                if (Info1.SecurityInfo(0) = '0') and (Reader1.ErrorCode = ecNone) then
                begin
                  if Doc1.ObjectCount > 0 then
                  begin
                    I := Doc1.PageCount;
                  end;
                end;
              finally
                Info1.Free;
                Doc1.Free;
                Reader1.Free;
              end;
            finally
              Stream1.Free;
            end;

            if (CopyFile(QPLUnicodeParm(List[0]), OutputFileName)) then
            begin
              Verdict := 'File merged successfully, ' + QPLIntToStr(I) + ' page';
              if (I <> 1) then
              begin
                Verdict := Verdict + 's';
              end;
              AddToFileList(WideString(ListName + 'Result'), WideString(Verdict));
              Result := 1;
            end else
            begin
              Verdict := 'File does not exist';
              AddToFileList(WideString(ListName + 'Result'), WideString(Verdict));
            end;
          end;
        end else
        begin
          for X := 0 to List.Count - 1 do
          begin
            Verdict := '';

            if QPLFileExists(QPLUnicodeParm(List[X])) then
            begin
              try
                Stream1 := QPLCreateFileStream(QPLUnicodeParm(List[X]), fmOpenRead or fmShareDenyWrite);
                try
                  Reader1 := TSmartPDFReader.Create(Stream1);
                  Doc1 := TSmartPDFDocument.Create(Reader1);
                  Info1 := TSmartPDFInfo.Create(Reader1, '');
                  try
                    if (Info1.SecurityInfo(0) = '0') and (Reader1.ErrorCode = ecNone) then
                    begin
                      if Doc1.ObjectCount > 0 then
                      begin
                        L := Length(MergeData);
                        SetLength(MergeData, L + 1);
                        MergeData[L].FileNameIndex := X;

                        if L = 0 then
                        begin
                          // Add a blank /AcroForm to the first document
                          Doc1.AddAcroForm;
                        end;

                        MergeData[L].ObjectCount := Doc1.ObjectCount;
                        MergeData[L].PageCount := Doc1.PageCount;
                        MergeData[L].PagesRefObjNum := Doc1.PagesRef.ObjNum;
                        MergeData[L].PagesRefGenNum := Doc1.PagesRef.GenNum;
                        TempA := Doc1.FieldsArray;
                        if Assigned(TempA) then
                          MergeData[L].FieldsArray := TempA.Output
                        else
                          MergeData[L].FieldsArray := '';
                        TempA := Doc1.COArray;
                        if Assigned(TempA) then
                          MergeData[L].FieldsCOArray := TempA.Output
                        else
                          MergeData[L].FieldsCOArray := '';
                        MergeData[L].FormNeedAppearances := Doc1.FormNeedAppearances;
                        TempD := Doc1.AcroFormFonts;
                        if Assigned(TempD) then
                          MergeData[L].AcroFormFonts := TempD.Output
                        else
                          MergeData[L].AcroFormFonts := '';

                        Verdict := 'File merged successfully, ' + QPLIntToStr(Doc1.PageCount) + ' page';
                        if Doc1.PageCount <> 1 then Verdict := Verdict + 's';
                      end else
                        Verdict := 'File is corrupt';
                    end else
                      Verdict := 'File is encrypted or may be corrupt';
                  finally
                    Info1.Free;
                    Doc1.Free;
                    Reader1.Free;
                  end;
                finally
                  Stream1.Free;
                end;
              except
                Verdict := 'File could not be opened';
              end;
            end else
              Verdict := 'File does not exist';
            AddToFileList(WideString(ListName + 'Result'), WideString(Verdict));
          end;
          if Length(MergeData) >= 2 then
          begin
            if QPLFileExists(OutputFileName) then
            begin
              if QPLDeleteFile(OutputFileName) then FLastErrorCode := 0 else
                FLastErrorCode := 402;
            end;
            if FLastErrorCode <> 402 then
            try
              OutputStream := QPLCreateFileStream(OutputFileName, fmCreate or fmShareExclusive);
              try
                Result := Length(MergeData);
                Stream1 := QPLCreateFileStream(QPLUnicodeParm(List[MergeData[0].FileNameIndex]), fmOpenRead or fmShareDenyWrite);
                try
                  Reader1 := TSmartPDFReader.Create(Stream1);
                  Doc1 := TSmartPDFDocument.Create(Reader1);

                  // Add the /AcroForm again to keep in sync
                  Doc1.AddAcroForm;

                  Info1 := TSmartPDFInfo.Create(Reader1, '');
                  try
                    Writer := TSmartPDFWriter.Create(OutputStream);
                    try
                      Writer.New;
                      TempStruct := TPDFStructure.Create;
                      try
                        Offset := Doc1.ObjectCount;
                        PagesRef1 := Doc1.PagesRef;

                        for D := 1 to Length(MergeData) - 1 do
                        begin
                          Doc1.AddPages(MergeData[D].PagesRefObjNum + Offset, MergeData[D].PagesRefGenNum, MergeData[D].PageCount);
                          Obj := TempStruct.Decode(MergeData[D].FieldsArray);
                          if Obj is TPDFArray then TempA := TPDFArray(Obj) else TempA := nil;
                          Obj := TempStruct.Decode(MergeData[D].FieldsCOArray);
                          if Obj is TPDFArray then TempA2 := TPDFArray(Obj) else TempA2 := nil;
                          Doc1.AddFields(TempA, TempA2, Offset, MergeData[D].FormNeedAppearances);
                          Obj := TempStruct.Decode(MergeData[D].AcroFormFonts);
                          if Obj is TPDFDictionary then TempD := TPDFDictionary(Obj) else TempD := nil;
                          Doc1.AddFieldFonts(TempD, Offset);
                          Offset := Offset + MergeData[D].ObjectCount;
                        end;

                        for X := 1 to Doc1.ObjectCount do
                        begin
                          Obj := Doc1.GetObject(X, TempStruct);

                          if (Obj is TPDFDictionary) then
                             TPDFDictionary(Obj).DeleteEntryByKeyName('StructTreeRoot');

                          if Assigned(Obj) then
                            Writer.AddObject(X, Doc1.GetGenNum(X), Obj.Output);
                          if TempStruct.ObjectCount > ObjCountLimit then
                          begin
                            TempStruct.Free;
                            TempStruct := TPDFStructure.Create;
                          end;
                        end;

                        Offset := Doc1.ObjectCount;
                        FSubProgressCount := Length(MergeData) - 1;
                        try
                          FSubProgressScale := 1;
                          FSubProgressOffset := 0;
                          for D := 1 to Length(MergeData) - 1 do
                          begin
                            FSubProgressPiece := D;
                            TempStruct.Free;
                            TempStruct := TPDFStructure.Create;
                            Stream2 := QPLCreateFileStream(QPLUnicodeParm(List[MergeData[D].FileNameIndex]), fmOpenRead or fmShareDenyWrite);
                            try
                              Reader2 := TSmartPDFReader.Create(Stream2);
                              Doc2 := TSmartPDFDocument.Create(Reader2);
                              try
                                Doc2.RootDict.DeleteEntryByKeyName('StructTreeRoot');
                                Doc2.FixPages;
                                Doc2.SetPagesParent(PagesRef1.ObjNum - Offset, PagesRef1.GenNum);
                                OC := Doc2.ObjectCount;
                                for X := 1 to OC do
                                begin
                                  SubProgress(X * 100 div OC);
                                  Obj := Doc2.GetObject(X, TempStruct);

                                  if (Obj is TPDFDictionary) then
                                  begin
                                    TempObj := TPDFDictionary(Obj).FindValueByKeyName('Type');
                                    if Assigned(TempObj) and (TempObj.SpyType = 'N') then
                                    begin
                                      if (TPDFName(TempObj).Name = 'StructTreeRoot') then
                                        Obj := nil;
                                      if (TPDFName(TempObj).Name = 'StructElem') then
                                        Obj := nil;
                                    end;
                                  end;

                                  if Assigned(Obj) then
                                  begin
                                    Obj.ShiftIndRef(Offset);
                                    Writer.AddObject(X + Offset, Doc2.GetGenNum(X), Obj.Output);
                                  end
                                  else
                                    Writer.AddObject(X + Offset, Doc2.GetGenNum(X), 'null');

                                  if TempStruct.ObjectCount > ObjCountLimit then
                                  begin
                                    TempStruct.Free;
                                    TempStruct := TPDFStructure.Create;
                                  end;
                                end;
                              finally
                                Doc2.Free;
                                Reader2.Free;
                              end;
                            finally
                              Stream2.Free;
                            end;
                            Offset := Offset + MergeData[D].ObjectCount;
                          end;
                        finally
                          FSubProgressPiece := 1;
                          FSubProgressCount := 1;
                        end;
                      finally
                        TempStruct.Free;
                      end;

                      Reader1.FixTrailer;
                      Reader1.TrailerDict.Add('Size', Reader1.ReaderStructure.NewNumeric(Offset + 1));
                      Writer.AddTrailer(Reader1.TrailerDict);

                    finally
                      Writer.Free;
                    end;
                  finally
                    Doc1.Free;
                    Info1.Free;
                    Reader1.Free;
                  end;
                finally
                  Stream1.Free;
                end;
              finally
                OutputStream.Free;
              end;
            except
              FLastErrorCode := 403;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.FileListCount(const ListName: WideString): Integer;
var
  I: Integer;
  List: TQuickPDFStringList;
begin
  Result := 0;
  List := nil;
  I := FFileLists.IndexOf(AnsiString(ListName));
  if I >= 0 then
  begin
    if FFileLists.Objects[I] is TQuickPDFStringList then
      List := TQuickPDFStringList(FFileLists.Objects[I]);
    if Assigned(List) then
      Result := List.Count;
  end;
end;

function TQuickPDF.GetOutlineDest(OutlineID: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := IntCast(FSelDoc.GetOutlineDest(Outline));
  end;
end;

function TQuickPDF.GetDestPage(DestID: Integer): Integer;
var
  DD: TPDFDictionary;
  Dest: TPDFArray;
begin
  Result := 0;
  Dest := GetDestArray(DestID);
  if (Assigned(Dest)) then
  begin
    if (Dest.Count >= 1) then
    begin
      if (Dest.Item[0] is TPDFNumeric) then
      begin
        Result := TPDFNumeric(Dest.Item[0]).AsInteger + 1;
        DD := FSelDoc.PageTree.GetPage(Result);
        if Assigned(DD) and DD.IsIndirect then
        begin
          Dest.Replace(0, FSelDoc.Structure.NewIndirectRef(DD.IndObjNum, DD.IndGenNum));
        end;
      end;
      if (Dest.Item[0] is TPDFIndRef) then
      begin
        Result := FSelDoc.GetPageFromRef(TPDFIndRef(Dest.Item[0])) + 1;
      end;
    end;
  end;
end;

function TQuickPDF.GetDestType(DestID: Integer): Integer;
var
  X: Integer;
  Name: AnsiString;
  Dest: TPDFArray;
const
  DestNames: array[1..8] of AnsiString = ('XYZ', 'Fit', 'FitH', 'FitV', 'FitR',
    'FitB', 'FitBH', 'FitBV');
begin
  Result := 0;
  Dest := GetDestArray(DestID);
  if (Dest is TPDFArray) then
  begin
    if Dest.Count >= 2 then
    begin
      if Dest.Item[1] is TPDFName then
      begin
        Name := TPDFName(Dest.Item[1]).Name;
        for X := 1 to 8 do
          if DestNames[X] = Name then Result := X;
      end;
    end;
  end;
end;

function TQuickPDF.GetDestValue(DestID, ValueKey: Integer): Double;
var
  Count: Integer;
  Dest: TPDFArray;
  DestType: Integer;
begin
  Result := 0;
  Dest := GetDestArray(DestID);
  if (Assigned(Dest)) then
  begin
    DestType := GetDestType(DestID);
    Count := Dest.Count;
    case ValueKey of
      1: // Left
      begin
        if ((DestType = 1) or (DestType = 4) or (DestType = 5) or (DestType = 8)) and
          (Count >= 3) and (Dest.Item[2] is TPDFNumeric) then
            Result := TPDFNumeric(Dest.Item[2]).AsDouble;
        Result := Result * FSelDoc.Scale;
        if (FSelDoc.Origin = 2) or (FSelDoc.Origin = 3) then
          Result := PageWidth - Result;
      end;

      2: // Top
      begin
        if (DestType = 1) and
          (Count >= 4) and (Dest.Item[3] is TPDFNumeric) then
            Result := TPDFNumeric(Dest.Item[3]).AsDouble;

        if ((DestType = 3) or (DestType = 7)) and
          (Count >= 3) and (Dest.Item[2] is TPDFNumeric) then
            Result := TPDFNumeric(Dest.Item[2]).AsDouble;

        if (DestType = 5) and
          (Count >= 6) and (Dest.Item[5] is TPDFNumeric) then
            Result := TPDFNumeric(Dest.Item[5]).AsDouble;

        Result := Result * FSelDoc.Scale;
        if (FSelDoc.Origin = 1) or (FSelDoc.Origin = 2) then
          Result := PageHeight - Result;
      end;

      3: // Bottom
      begin
        if (DestType = 5) and
          (Count >= 4) and (Dest.Item[3] is TPDFNumeric) then
            Result := TPDFNumeric(Dest.Item[3]).AsDouble;
        Result := Result * FSelDoc.Scale;
        if (FSelDoc.Origin = 1) or (FSelDoc.Origin = 2) then
          Result := PageHeight - Result;
      end;

      4: // Right
      begin
        if (DestType = 5) and
          (Count >= 5) and (Dest.Item[4] is TPDFNumeric) then
            Result := TPDFNumeric(Dest.Item[4]).AsDouble;
        Result := Result * FSelDoc.Scale;
        if (FSelDoc.Origin = 2) or (FSelDoc.Origin = 3) then
          Result := PageWidth - Result;
      end;

      5: // Zoom
      begin
        if (DestType = 1) and
          (Count >= 5) and (Dest.Item[4] is TPDFNumeric) then
            Result := TPDFNumeric(Dest.Item[4]).AsDouble * 100;
      end;
    end;
  end;
end;

function TQuickPDF.ExtractFilePageContentToString(const InputFileName,
  Password: WideString; Page: Integer): AnsiString;
var
  FS: TQuickPDFWideFileStream;
  Reader: TSmartPDFReader;
  Info: TSmartPDFInfo;
  Doc: TSmartPDFDocument;
begin
  Result := '';
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    try
      FS := QPLCreateFileStream(InputFileName, fmOpenRead or fmShareDenyWrite);
      try
        Reader := TSmartPDFReader.Create(FS);
        try
          if Reader.ErrorCode = ecNone then
          begin
            Info := TSmartPDFInfo.Create(Reader, '');
            try
              if ((Info.Encrypted = spEncrypted) and Info.CheckPassword(Password)) or
                (Info.Encrypted = spDecrypted) then
              begin
                Info.Password := Password;
                Info.GetBasic;
                Doc := TSmartPDFDocument.Create(Reader);
                try
                  Doc.SmartInfo := Info;
                  Result := Doc.GetPageContents(Doc.FindPage(Page));
                finally
                  Doc.Free;
                end;
              end else
                FLastErrorCode := 404;
            finally
              Info.Free;
            end;
          end else
            FLastErrorCode := 409;
        finally
          Reader.Free;
        end;
      finally
        FS.Free;
      end;
    except
      FLastErrorCode := 401;
    end;
  end else
    FLastErrorCode := 999;
end;

function TQuickPDF.ExtractFilePageText(const InputFileName,
  Password: WideString; Page, Options: Integer): WideString;
var
  FS: TQuickPDFWideFileStream;
  Reader: TSmartPDFReader;
  Info: TSmartPDFInfo;
  Doc: TSmartPDFDocument;
begin
  Result := '';
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    try
      FS := QPLCreateFileStream(InputFileName, fmOpenRead or fmShareDenyWrite);
      try
        Reader := TSmartPDFReader.Create(FS);
        try
          if Reader.ErrorCode = ecNone then
          begin
            Info := TSmartPDFInfo.Create(Reader, '');
            try
              if ((Info.Encrypted = spEncrypted) and Info.CheckPassword(Password)) or
                (Info.Encrypted = spDecrypted) then
              begin
                Info.Password := Password;
                Info.GetBasic;
                Doc := TSmartPDFDocument.Create(Reader);
                try
                  Doc.SmartInfo := Info;
                  Result := Doc.ExtractPageText(Doc.FindPage(Page), Options,
                    FDATextExtractOptions);
                finally
                  Doc.Free;
                end;
              end else
                FLastErrorCode := 404;
            finally
              Info.Free;
            end;
          end else
            FLastErrorCode := 409;
        finally
          Reader.Free;
        end;
      finally
        FS.Free;
      end;
    except
      FLastErrorCode := 401;
    end;
  end else
    FLastErrorCode := 999;
end;

function TQuickPDF.GetFormFieldTextFlags(Index,
  ValueKey: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    case ValueKey of
      1: if Field.GetFieldFlags(13) then Result := 1;
      2: if Field.GetFieldFlags(14) then Result := 1;
      3: if Field.GetFieldFlags(21) then Result := 1;
      4: if Field.GetFieldFlags(23) then Result := 1;
      5: if Field.GetFieldFlags(24) then Result := 1;
      6: if Field.GetFieldFlags(25) then Result := 1;
    end;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.AddArcToPath(CenterX, CenterY,
  TotalAngle: Double): Integer;
begin
  if TotalAngle <> 0 then
  begin
    FSelDoc.PageTree.Painter.AddArcToPath(TranslateX(CenterX),
      TranslateY(CenterY), TotalAngle);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.GetImagePageCount(const FileName: WideString): Integer;
var
  FS: TQuickPDFWideFileStream;
begin
  Result := 0;
  if QPLFileExists(FileName) then
  begin
    try
      FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
      try
        Result := CountImagePages(FS);
      finally
        FS.Free;
      end;
    except
    end;
  end;
end;

function TQuickPDF.AddImageFromFileOffset(const FileName: WideString;
  Offset, DataLength, Options: Integer): Integer;
var
  Image: TPDFImage;
  S: AnsiString;
  FS: TQuickPDFWideFileStream;
  SS: TStringStream;
begin
  Result := 0;
  try
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    try
      FS.Seek(Offset, soFromBeginning);
      SetLength(S, DataLength);
      FS.Read(S[1], Length(S));
      SS := TStringStream.Create(S);
      try
        Image := FSelDoc.NewImageFromStream(SS, Options,
          FSelDoc.CompressImages);

        if Image <> nil then
        begin
          if (Image.Contains16Bit) then
          begin
            if FSelDoc.Version < '1.5' then FSelDoc.Version := '1.5';
          end;

          Result := IntCast(Image);
          FSelImage := Image;
        end;
      finally
        SS.Free;
      end;
    finally
      FS.Free;
    end;
  except
  end;
end;

function TQuickPDF.SetImageAsMask(MaskType: Integer): Integer;
begin
  Result := 0;  
  if Assigned(FSelImage) and ((MaskType = 1) or (MaskType = 2)) then
  begin
    if FSelImage.SetImageAsMask(TPDFMaskType(MaskType)) then      
      Result := 1;
  end;
end;

function TQuickPDF.SetImageMaskFromImage(ImageID: Integer): Integer;
var
  ObjNum: Integer;
  GenNum: Integer;
  Image: TPDFImage;
begin
  Result := 0;
  Image := ValidImageID(ImageID);
  if (Assigned(Image) and FSelDoc.IsImage(Image)) then
  begin
    ObjNum := Image.IndRef.ObjNum;
    GenNum := Image.IndRef.GenNum;
    if (FSelImage.SetImageMaskFromImage(ObjNum, GenNum,
      Image.GetMaskType)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.SetPageTransparencyGroup(CS, Isolate,
  Knockout: Integer): Integer;
const
  ColorSpaces: array[1..2] of AnsiString = ('DeviceRGB', 'DeviceCMYK');
begin
  if (CS >= 1) and (CS <= 2) then
  begin
    Result := 1;
    FSelDoc.PageTree.SetPageTransparencyGroup(ColorSpaces[CS],
      Isolate = 1, Knockout = 1);
  end else
    Result := 0;
end;

function TQuickPDF.ReverseImage(Reset: Integer): Integer;
begin
  Result := 0;
  if Assigned(FSelImage) then
    if FSelImage.Reverse(Reset = 1) then Result := 1;
end;

function TQuickPDF.GetPageLayout: Integer;
begin
  Result := Ord(FSelDoc.GetPageLayout);
end;

function TQuickPDF.GetPageMode: Integer;
begin
  Result := Ord(FSelDoc.GetPageMode);
end;

{$IFDEF QPL_NOVCL}
const
  JOHAB_CHARSET = 130;
  VIETNAMESE_CHARSET = 163;
  MAC_CHARSET = 77;
{$ENDIF}

function TQuickPDF.AddSubsettedFont(const FontName: WideString;
  CharsetIndex: Integer; const SubsetChars: WideString): Integer;
var
  OX: Integer;
  UX: Integer;
  IsUnique: Boolean;
  UniqueSubsetChars: WideString;
  Font: TPDFFont;
const
  CharSets: array[1..19] of Integer = (ANSI_CHARSET, DEFAULT_CHARSET,
    SYMBOL_CHARSET, SHIFTJIS_CHARSET, HANGEUL_CHARSET, GB2312_CHARSET,
    CHINESEBIG5_CHARSET, OEM_CHARSET, JOHAB_CHARSET, HEBREW_CHARSET,
    ARABIC_CHARSET, GREEK_CHARSET, TURKISH_CHARSET, VIETNAMESE_CHARSET,
    THAI_CHARSET, EASTEUROPE_CHARSET, RUSSIAN_CHARSET, MAC_CHARSET,
    BALTIC_CHARSET);
begin
  Result := 0;
  if (CharsetIndex >= 1) and (CharsetIndex <= 19) then
  begin
    SetLength(UniqueSubsetChars, 0);
    for OX := 1 to Length(SubsetChars) do
    begin
      if Length(UniqueSubsetChars) < 255 then
      begin
        IsUnique := True;
        UX := 1;
        while IsUnique and (UX <= Length(UniqueSubsetChars)) do
        begin
          if UniqueSubsetChars[UX] = SubsetChars[OX] then IsUnique := False;
          Inc(UX);
        end;
        if IsUnique then
          UniqueSubsetChars := UniqueSubsetChars + SubsetChars[OX];
      end;
    end;
    Font := FSelDoc.NewSubsettedFont(AnsiString(FontName), CharSets[CharsetIndex], UniqueSubsetChars);
    if Font <> nil then
    begin
      Result := IntCast(Font);
      SelectFont(Result);
    end;
  end;
end;

//function TQuickPDF.GetSubsetString(const InputStr: WideString): AnsiString;
//begin
//  if Assigned(FSelFont) then
//    Result := FSelFont.GetSubsetString(InputStr)
//  else
//    Result := AnsiString(InputStr);
//end;

function TQuickPDF.FitImage(Left, Top, Width, Height: Double; HAlign,
  VAlign, Rotate: Integer): Integer;
var
  W, H: Integer;
  Scale: Double;
  AdWidth, AdHeight: Integer;
begin
  if Assigned(FSelImage) and (HAlign >= 0) and (HAlign <= 2) and
    (VAlign >= 0) and (VAlign <= 2) and (Rotate >= 0) and (Rotate <= 3) then
  begin
    AdWidth := FSelImage.Width;
    AdHeight := FSelImage.Height;
    if (FSelImage.HorizontalDPI <> FSelImage.VerticalDPI) and
      (FSelImage.HorizontalDPI <> 0) and
      (FSelImage.VerticalDPI <> 0) then
    begin
      AdWidth := Round(AdWidth * FSelImage.VerticalDPI / FSelImage.HorizontalDPI);
    end;
    if (Rotate = 0) or (Rotate = 3) then
    begin
      W := AdWidth;
      H := AdHeight;
    end else
    begin
      H := AdWidth;
      W := AdHeight;
    end;
    Left := TranslateX(Left);
    Top := TranslateY(Top);
    Width := GetScale(Width);
    Height := GetScale(Height);
    Scale := Height / H;
    if (Width / W) < Scale then
      Scale := Width / W;
    case HAlign of
      1: Left := Left + (Width - W * Scale) / 2;
      2: Left := Left + Width - W * Scale;
    end;
    case VAlign of
      1: Top := Top - (Height - H * Scale) / 2;
      2: Top := Top - Height + H * Scale;
    end;
    FSelDoc.PageTree.UseImage(FSelImage);
    Width := AdWidth * Scale;
    Height := AdHeight * Scale;
    case Rotate of
      0: FSelDoc.PageTree.Painter.DrawImage(FSelImage, Left, Top, Width, Height);
      1: FSelDoc.PageTree.Painter.DrawRotatedImage(FSelImage, Left + Height, Top - Width, Width, Height, 90);
      2: FSelDoc.PageTree.Painter.DrawRotatedImage(FSelImage, Left, Top, Width, Height, -90);
      3: FSelDoc.PageTree.Painter.DrawRotatedImage(FSelImage, Left + Width, Top, Width, Height, 180);
    end;
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.SaveFontToFile(const FileName: WideString): Integer;
begin
  Result := 0;
  if Assigned(FSelFont) then
  begin
    if FSelFont.SaveToFile(FileName) then
      Result := 1;
  end;
end;

function TQuickPDF.DrawTextArc(XPos, YPos, Radius, Angle: Double;
  const Text: WideString; DrawOptions: Integer): Integer;
begin
  if (Text <> '') and (DrawOptions >= 0) and (DrawOptions <= 1) then
  begin
    CheckFontSelection;
    FSelDoc.PageTree.Painter.DrawWideTextArc(TranslateX(XPos), TranslateY(YPos),
      GetScale(Radius), Angle, FSelFont.FixWideText(Text), DrawOptions);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.CheckObjects: Integer;
begin
  if Assigned(FSelDoc) then
    FSelDoc.CheckObjects;
  Result := 1;
end;

function TQuickPDF.ExtractFilePagesEx(const InputFileName, Password,
  OutputFileName, RangeList: WideString; Options: Integer): Integer;
var
  X: Integer;
  OC: Integer;
  FS: TQuickPDFWideFileStream;
  Obj: TPDFObject;
  FSOut: TQuickPDFWideFileStream;
  Reader: TSmartPDFReader;
  Writer: TSmartPDFWriter;
  TempStruct: TPDFStructure;
  Doc: TSmartPDFDocument;
  Info: TSmartPDFInfo;
  ObjNum: Integer;
  PageList: TQuickPDFPageList;
  RangeListA: AnsiString;
  ObjectMapping: TQPLIntegerPairList;
  RenumberObj: TPDFObject;
  RenumberX: Integer;
  NewTrailer: TPDFObject;
begin
  RangeListA := AnsiString(RangeList);

  Result := 0;
  FLastErrorCode := 0;
  SetLength(PageList, 0);
  if (FUnlocked) then
  begin
    try
      FS := QPLCreateFileStream(InputFileName, fmOpenRead or fmShareDenyWrite);
      try
        if QPLFileExists(OutputFileName) then
        begin
          if QPLDeleteFile(OutputFileName) then FLastErrorCode := 0 else
            FLastErrorCode := 402;
        end;
        if FLastErrorCode <> 402 then
        try
          FSOut := QPLCreateFileStream(OutputFileName, fmCreate or fmShareDenyWrite);
          try
            Reader := TSmartPDFReader.Create(FS);
            try
              if Reader.ErrorCode = ecNone then
              begin
                Info := TSmartPDFInfo.Create(Reader, '');
                try
                  if ((Info.Encrypted = spEncrypted) and Info.CheckPassword(Password)) or
                    (Info.Encrypted = spDecrypted) then
                  begin
                    Info.Password := Password;
                    Info.GetBasic;
                  end;
                  Result := 1;
                  Reader.FixTrailer;
                  Reader.TrailerDict.PurgeKey('Prev');
                  Writer := TSmartPDFWriter.Create(FSOut);
                  ObjectMapping := TQPLIntegerPairList.Create;
                  try
                    if (Options and 1 = 1) then
                    begin
                      Writer.New('1.7');
                    end else
                    begin
                      Writer.New;
                    end;
                    TempStruct := TPDFStructure.Create;
                    try
                      Doc := TSmartPDFDocument.Create(Reader);
                      try
                        Doc.SmartInfo := Info;
                        PageList := QPLParsePageRangeList(
                          RangeListA,
                          1, Doc.PageCount,  // Valid page range
                          False,  // Silently ignore invalid pages
                          False,  // Silently ignore invalid characters
                          False,  // Silently ignore duplicate pages
                          True,   // Don't add duplicate pages to the returned page list
                          False); // Don't sort the returned page list

                        if Length(PageList) > 0 then
                        begin
                          if Assigned(Doc.RootDict) then
                            if Assigned(Doc.RootDict.FindValueByKeyName('OpenAction')) then
                              Doc.RootDict.DeleteEntryByKeyName('OpenAction');

                          if Assigned(Doc.RootDict) then
                            if Assigned(Doc.RootDict.FindValueByKeyName('StructTreeRoot')) then
                              Doc.RootDict.DeleteEntryByKeyName('StructTreeRoot');

                          if (Options and 2 = 2) then
                          begin
                            if Assigned(Doc.RootDict) then
                            begin
                              if Assigned(Doc.RootDict.FindValueByKeyName('AcroForm')) then
                                Doc.RootDict.DeleteEntryByKeyName('AcroForm');

                              // Remove XFA usage rights
                              if Assigned(Doc.RootDict.FindValueByKeyName('Extensions')) then
                                Doc.RootDict.DeleteEntryByKeyName('Extensions');

                              if Assigned(Doc.RootDict.FindValueByKeyName('Perms')) then
                                Doc.RootDict.DeleteEntryByKeyName('Perms');
                            end;
                          end;

                          FSubProgressScale := 0.5;
                          FSubProgressOffset := 0;
                          Doc.OnProgress := SubProgress;
                          Doc.ExtractObjects(PageList, True);
                          OC := Doc.ExtractObjectCount;
                          FSubProgressOffset := 50;
                          FSubProgressScale := 0.5;

                          for X := 1 to OC do
                          begin
                            ObjNum := Doc.GetExtractObjectNumber(X);
                            ObjectMapping.Add(ObjNum, X);
                          end;
                          ObjectMapping.Sort;

                          for X := 1 to OC do
                          begin
                            SubProgress(X * 100 div OC);

                            TempStruct.Free;
                            TempStruct := TPDFStructure.Create;

                            ObjNum := Doc.GetExtractObjectNumber(X);
                            Obj := Doc.GetObject(ObjNum, TempStruct);
                            if Assigned(Obj) then
                            begin
                              for RenumberX := 1 to TempStruct.ObjectCount do
                              begin
                                RenumberObj := TempStruct.GetObject(RenumberX);
                                if (RenumberObj is TPDFIndRef) then
                                begin
                                  TPDFIndRef(RenumberObj).ObjNum := ObjectMapping.GetValue(TPDFIndRef(RenumberObj).ObjNum);
                                  TPDFIndRef(RenumberObj).GenNum := 0;
                                end;
                              end;

                              Writer.AddObject(ObjectMapping.GetValue(ObjNum), 0, Obj.Output)
                            end else
                            begin
                              Writer.AddObject(ObjectMapping.GetValue(ObjNum), 0, 'null');
                            end;
                          end;
                          EndProgress;
                        end else
                        begin
                          FLastErrorCode := 412;
                        end;
                      finally
                        Doc.Free;
                      end;
                    finally
                      TempStruct.Free;
                    end;

                    TempStruct := TPDFStructure.Create;
                    try
                      NewTrailer := TempStruct.Decode(Reader.TrailerDict.Output);
                      for RenumberX := 1 to TempStruct.ObjectCount do
                      begin
                        RenumberObj := TempStruct.GetObject(RenumberX);
                        if (RenumberObj is TPDFIndRef) then
                        begin
                          TPDFIndRef(RenumberObj).ObjNum := ObjectMapping.GetValue(TPDFIndRef(RenumberObj).ObjNum);
                          TPDFIndRef(RenumberObj).GenNum := 0;
                        end;
                      end;
                      if (NewTrailer is TPDFDictionary) then
                      begin

                        if (Options = 0) then
                        begin
                          Writer.AddTrailer(TPDFDictionary(NewTrailer), 0, True);
                        end else
                        begin
                          Writer.AddXRefStream(TPDFDictionary(NewTrailer), 0, True);
                        end;
                      end;
                    finally
                      TempStruct.Free;
                    end;
                  finally
                    Writer.Free;
                    ObjectMapping.Free;
                  end;
                finally
                  Info.Free;
                end;
              end else
                FLastErrorCode := 409;
            finally
              Reader.Free;
            end;
          finally
            FSOut.Free;
          end;
        except
          FLastErrorCode := 403;
        end;
      finally
        FS.Free;
      end;
    except
      FLastErrorCode := 401;
    end;
  end else
    FLastErrorCode := 999;
end;

function TQuickPDF.SetFontFlags(Fixed, Serif, Symbolic, Script, Italic,
  AllCap, SmallCap, ForceBold: Integer): Integer;
begin
  if Assigned(FSelFont) then
  begin
    FSelFont.SetFlags(Fixed <> 0, Serif <> 0, Symbolic <> 0, Script <> 0,
      Italic <> 0, AllCap <> 0, SmallCap <> 0, ForceBold <> 0);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.GetOpenActionDestination: Integer;
begin
  Result := IntCast(FSelDoc.GetOpenActionDestination);
end;

procedure TQuickPDF.SubProgress(Progress: Integer);
var
  P: Integer;
begin
  if Assigned(FOnProgress) then
  begin
    P := Round(Progress * FSubProgressScale + FSubProgressOffset);
    P := ((FSubProgressPiece - 1) * 100 div FSubProgressCount) +
      Round(P div FSubProgressCount);
    if P <> FLastProgress then
    begin
      FOnProgress(P);
      FLastProgress := P;
    end;
  end;
end;

procedure TQuickPDF.EndProgress;
begin
  if Assigned(FOnProgress) then FOnProgress(100);
end;

function TQuickPDF.SaveImageToStream(OutStream: TStream): Integer;
begin
  Result := 0;
  if Assigned(FSelImage) then
    if FSelImage.SaveToStream(OutStream) then Result := 1;
end;

function TQuickPDF.SetTextHighlight(Highlight: Integer): Integer;
begin
  case Highlight of
    1: FSelDoc.PageTree.Painter.TextHighlight := hsSquare;
    2: FSelDoc.PageTree.Painter.TextHighlight := hsRounded;
  else
    FSelDoc.PageTree.Painter.TextHighlight := hsNone;
  end;
  Result := 1;
end;

function TQuickPDF.SetTextUnderline(Underline: Integer): Integer;
begin
  case Underline of
    1: FSelDoc.PageTree.Painter.TextUnderline := usSingle;
    2: FSelDoc.PageTree.Painter.TextUnderline := usDouble;
    3: FSelDoc.PageTree.Painter.TextUnderline := usStrikeout;
    4: FSelDoc.PageTree.Painter.TextUnderline := usOver;
  else
    FSelDoc.PageTree.Painter.TextUnderline := usNone;
  end;
  Result := 1;
end;

function TQuickPDF.SetTextHighlightColor(Red, Green, Blue: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetHighlightColor(Red, Green, Blue);
  Result := 1;
end;

function TQuickPDF.SetTextHighlightColorCMYK(C, M, Y, K: Double): Integer;
begin
  if ((FSelDoc.PDFAMode <> 1) and (FSelDoc.PDFAMode <> 2)) then
  begin
    FSelDoc.PageTree.Painter.SetHighlightColor(C, M, Y, K);
    Result := 1;
  end else
  begin
    Result := 0;
    FLastErrorCode := 601;
  end;
end;

function TQuickPDF.SetTextWordSpacing(WordSpacing: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetTextWordSpacing(GetScale(WordSpacing));
  Result := 1;
end;

function TQuickPDF.SetTextCharSpacing(CharSpacing: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetTextCharSpacing(GetScale(CharSpacing));
  Result := 1;
end;

function TQuickPDF.ClearTextFormatting: Integer;
begin
  FSelDoc.PageTree.Painter.ClearTextFormatting;
  Result := 1;
end;

function TQuickPDF.SetTextUnderlineColor(Red, Green, Blue: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetUnderlineColor(Red, Green, Blue);
  Result := 1;
end;

function TQuickPDF.SetTextUnderlineColorCMYK(C, M, Y, K: Double): Integer;
begin
  if ((FSelDoc.PDFAMode <> 1) and (FSelDoc.PDFAMode <> 2)) then
  begin
    FSelDoc.PageTree.Painter.SetUnderlineColor(C, M, Y, K);
    Result := 1;
  end else
  begin
    Result := 0;
    FLastErrorCode := 601;
  end;
end;

function TQuickPDF.FontSize: Integer;
begin
  if Assigned(FSelFont) then
    Result := FSelFont.FontSize
  else
    Result := 0;
end;

function TQuickPDF.GetFontMetrics(MetricType: Integer): Integer;
begin
  if Assigned(FSelFont) then
    Result := FSelDoc.PageTree.Painter.GetTextMetrics(MetricType)
  else
    Result := 0;
end;

function TQuickPDF.GetFontIsSubsetted: Integer;
begin
  if Assigned(FSelFont) then
    Result := FSelFont.GetFontIsSubsetted
  else
    Result := 0;
end;

function TQuickPDF.GetFontIsEmbedded: Integer;
begin
  if Assigned(FSelFont) then
    Result := FSelFont.GetFontIsEmbedded
  else
    Result := 0;
end;

function TQuickPDF.EncapsulateContentStream: Integer;
begin
  SetContentStreamFromString('q ' + GetContentStreamToString + ' Q ');
  FSelDoc.PageTree.Painter.ChangeAll;
  Result := 1;
end;

function TQuickPDF.SetTextUnderlineDash(DashOn,
  DashOff: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetUnderlineDash(DashOn, DashOff);
  Result := 1;
end;

function TQuickPDF.AppendText(const Text: WideString): Integer;
begin
  if Text <> '' then
  begin
    CheckFontSelection;
    FSelDoc.PageTree.Painter.AppendText(FSelFont.FixWideText(Text));
  end;
  Result := 1;
end;

function TQuickPDF.ApplyStyle(const StyleName: WideString): Integer;
begin
  if (FSelDoc.ApplyStyle(AnsiString(StyleName))) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.RemoveStyle(const StyleName: WideString): Integer;
begin
  if (FSelDoc.RemoveStyle(AnsiString(StyleName))) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.RemoveUsageRights: Integer;
begin
  if (FSelDoc.RemoveUsageRights) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SaveStyle(const StyleName: WideString): Integer;
begin
  CheckFontSelection;
  FSelDoc.SaveStyle(AnsiString(StyleName));
  Result := 1;  
end;

function TQuickPDF.DrawRotatedTextBox(Left, Top, Width, Height,
  Angle: Double; const Text: WideString; Options: Integer): Integer;
begin
  if (Options >= 0) and (Options <= 5) and (Width >= MinTW) then
  begin
    CheckFontSelection;
    Result := FSelDoc.PageTree.Painter.DrawRotatedWideTextBox(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), Angle, FixWideDelimited(Text, FSelDoc.BreakString),
      Options, FSelDoc.BreakString);
  end else
    Result := 0;
end;

function TQuickPDF.DrawRotatedTextBoxEx(Left, Top, Width, Height,
  Angle: Double; const Text: WideString; Options: Integer; Border, Radius, DrawOptions: Integer): Integer;
var
  Fill: Boolean;
  Outline: Boolean;
begin
  Fill := (DrawOptions = 1) or (DrawOptions = 2);
  Outline := (DrawOptions = 0) or (DrawOptions = 2);
  if (Options >= 0) and (Options <= 5) and (Width >= MinTW) then
  begin
    CheckFontSelection;
    Result := FSelDoc.PageTree.Painter.DrawRotatedWideTextBoxEx(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), Angle, FixWideDelimited(Text, FSelDoc.BreakString),
      Options, FSelDoc.BreakString, Border, Radius, Fill, Outline);
  end else
    Result := 0;
end;

function TQuickPDF.GlobalJavaScriptCount: Integer;
begin
  Result := FSelDoc.GlobalJavaScriptCount;  
end;

function TQuickPDF.GlobalJavaScriptPackageName(Index: Integer): WideString;
begin
  Result := FSelDoc.GlobalJavaScriptPackageName(Index);
end;

function TQuickPDF.GetWrappedTextBreakString(Width: Double; const Delimiter,
  Text: WideString): WideString;
begin
  CheckFontSelection;
  if Width <= MinTW then Result := '' else
  Result := FSelDoc.PageTree.Painter.GetWrappedWideTextBreakString(GetScale(Width),
    FixWideDelimited(Text, FSelDoc.BreakString), Delimiter, FSelDoc.BreakString);
end;

function TQuickPDF.SetOutlineOpenFile(OutlineID: Integer;
  const FileName: WideString): Integer;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    FSelDoc.SetOutlineOpenFile(Outline, AnsiString(FileName));
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.RetrieveCustomDataToString(const Key: AnsiString;
  Location: Integer): AnsiString;
const
  BadList: AnsiString = '/Author/Title/Subject/Keywords/Creator/Producer/';
  BadCatalogList: AnsiString = '/Type/Version/Extensions/Pages/PageLabels/Names' +
    '/Dests/ViewerPreferences/PageLayout/PageMode/Outlines/Threads' +
    '/OpenAction/AA/URI/AcroForm/Metadata/StructTreeRoot/MarkInfo/Lang' +
    '/SpiderInfo/OuputIntents/PieceInfo/OCProperties/Perms/Legal/Requirements' +
    '/Collection/NeedsRendering';
begin
  case Location of
    1:
    begin
      if QPLPos('/' + Key, BadList) > 0 then Result := '' else
        Result := FSelDoc.GetRawInfo(Key);
    end;
    2:
    begin
      if QPLPos('/' + Key, BadList) > 0 then Result := '' else
        Result := FSelDoc.GetRawCatalogInfo(Key);
    end;
  else
    Result := '';
  end;
end;

function TQuickPDF.StoreCustomDataFromString(const Key, NewValue: AnsiString;
  Location, Options: Integer): Integer;
var
  Mode: TPDFStorageMode;
const
  BadInfoList: AnsiString = '/Author/Title/Subject/Keywords/Creator/Producer/';
  BadCatalogList: AnsiString = '/Type/Version/Extensions/Pages/PageLabels/Names' +
    '/Dests/ViewerPreferences/PageLayout/PageMode/Outlines/Threads' +
    '/OpenAction/AA/URI/AcroForm/Metadata/StructTreeRoot/MarkInfo/Lang' +
    '/SpiderInfo/OuputIntents/PieceInfo/OCProperties/Perms/Legal/Requirements' +
    '/Collection/NeedsRendering';
begin
  Result := 0;
  case Options of
    1: Mode := smStream;
    2: Mode := smCompressedStream
  else
   Mode := smString;
  end;
  case Location of
    1: begin
         Mode := smString;
         if QPLPos('/' + Key, BadInfoList) > 0 then Result := 0 else
         begin
           Result := 1;
           FSelDoc.SetRawInfo(Key, NewValue, Mode);
         end;
       end;
    2: begin
         if QPLPos('/' + Key, BadCatalogList) > 0 then Result := 0 else
         begin
           Result := 1;
           FSelDoc.SetRawCatalogInfo(Key, NewValue, Mode);
         end;
       end;
  end;
end;

function TQuickPDF.SetTextRise(Rise: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetTextRise(Rise);
  Result := 1;
end;

function TQuickPDF.MoveOutlineAfter(OutlineID,
  SiblingID: Integer): Integer;
var
  Outline: TPDFIndRef;
  Sibling: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  Sibling := ValidOutlineID(SiblingID);
  if (Assigned(Outline) and Assigned(Sibling) and (Outline <> Sibling)) then
  begin
    FSelDoc.MoveOutline(Outline, Sibling, False);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.MoveOutlineBefore(OutlineID,
  SiblingID: Integer): Integer;
var
  Outline: TPDFIndRef;
  Sibling: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  Sibling := ValidOutlineID(SiblingID);
  if (Assigned(Outline) and Assigned(Sibling) and (Outline <> Sibling)) then
  begin
    FSelDoc.MoveOutline(Outline, Sibling, True);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.PrintDocument(const PrinterName: WideString; StartPage,
  EndPage, Options: Integer): Integer;
var
  LocalPrinter: TPrinter;
  CustomPrinterIndex: Integer;
  OriginalPrinterName: WideString;
{$IFNDEF UNICODE}
  PrinterNameA: AnsiString;
  OriginalPrinterNameA: AnsiString;
{$ENDIF}
  CustomPrinter: TPDFCustomPrinter;
begin
  if (ValidPrinterName(PrinterName)) then
  begin
    FLastRenderError := '';
    LocalPrinter := GetPrinter;
    CustomPrinterIndex := FCustomPrinters.IndexOf(QPLUpperCase(AnsiString(PrinterName)));
    if (CustomPrinterIndex >= 0) then
    begin
      CustomPrinter := TPDFCustomPrinter(FCustomPrinters.Objects[CustomPrinterIndex]);
      OriginalPrinterName := CustomPrinter.OriginalPrinterName;
{$IFDEF UNICODE}
      LocalPrinter.SetPrinter(@OriginalPrinterName[1], 'WINSPOOL', '', 0);
{$ELSE}
      OriginalPrinterNameA := AnsiString(OriginalPrinterName);
      LocalPrinter.SetPrinter(@OriginalPrinterNameA[1], 'WINSPOOL', '', 0);
{$ENDIF}
      CustomPrinter.SetPrinter(LocalPrinter, FPrinterDevMode);
    end else
    begin
{$IFDEF UNICODE}
      LocalPrinter.SetPrinter(@PrinterName[1], 'WINSPOOL', '', 0);
{$ELSE}
      PrinterNameA := AnsiString(PrinterName);
      LocalPrinter.SetPrinter(@PrinterNameA[1], 'WINSPOOL', '', 0);
{$ENDIF}
    end;
    Result := PrintDocumentToPrinterObject(LocalPrinter, StartPage, EndPage, Options);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.PrintDocumentToPrinterObject(APrinter: TPrinter;
  StartPage, EndPage, Options: Integer): Integer;
var
  OldPage: Integer;
  TitleIndex: Integer;
  LocalPrinter: TPrinter;
  QPLPrinter: TQPLPrinter;
  UseLocal: Boolean;
  PrintingCancelled: Boolean;

  procedure ReportProgress(Code: Integer);
  begin
{$IFDEF QPL_OS_WINDOWS}
    if (FGDIPlusSettings.ProgressWindow > 0) then
    begin
      SendMessage(FGDIPlusSettings.ProgressWindow, FGDIPlusSettings.ProgressMessage,
        FGDIPlusSettings.ProgressData, Code);
    end;
{$ENDIF}
  end;

begin
  FLastRenderError := '';
  FPrinterJobID := 0;
  LocalPrinter := APrinter;
  OldPage := SelectedPage;
  try
    Result := 1;
    if StartPage < 1 then StartPage := 1;
    if EndPage < StartPage then EndPage := StartPage;
    if EndPage > PageCount then EndPage := PageCount;

    if Result > 0 then
    begin
      UseLocal := False;

      // Check conditions to use local printing
      if Length(FPrintToFile) > 0 then UseLocal := True;
      if FPrinterStatusNeeded then UseLocal := True;
      if FPrinterStartPaused then UseLocal := True;

      QPLPrinter := TQPLPrinter.Create(LocalPrinter, FPrintToFile, UseLocal);
      try
        if (FPrintPreview) then
        begin
          QPLPrinter.SetupPreview(FPrintPreviewMaxDimension);
        end;

        if FPrinterStartPaused then
        begin
          QPLPrinter.SetStartPaused(True);
        end;

        TitleIndex := Options and $FFFF00 shr 8;
        Dec(TitleIndex, 450);
        if (TitleIndex >= 0) and (TitleIndex < FPrintTitles.Count) then
          QPLPrinter.Title := QPLAnsiToNative(FPrintTitles[TitleIndex])
        else
          QPLPrinter.Title := 'Quick PDF Library Document';

        PrintingCancelled := False;
        QPLPrinter.BeginDoc;
        ReportProgress(1020);
        try
          if QPLPrinter.Printing then
          begin
            QPLPrinter.Canvas.Font.Name := 'Arial';
            QPLPrinter.Canvas.Font.Size := 12;
            QPLPrinter.Canvas.Font.Color := clWhite;
            QPLPrinter.Canvas.Brush.Style := bsClear;
            QPLPrinter.Canvas.TextOut(0, 0, ' ');

{$IFDEF QPL_DPLR}
            if (FUseDPLR) then
            begin
              if not FSelDoc.PageTree.RenderPageToPrinter(
                QPLPrinter, StartPage, EndPage,
                  Options and $FF, FGDIPlusSettings , FSelDoc.GetPrintOCGList,
                  FDPLRFileName) then Result := 0;
            end else
{$ENDIF}
            begin
              if not FSelDoc.PageTree.RenderPageToPrinter(
                QPLPrinter, StartPage, EndPage,
                  Options and $FF, FGDIPlusSettings, FSelDoc.GetPrintOCGList) then Result := 0;
            end;
          end else
          begin
            PrintingCancelled := True;
            Result := 0;
            ReportProgress(1080);
          end;
        finally
          if (not PrintingCancelled) then
          begin
            QPLPrinter.EndDoc;
            ReportProgress(1090);
          end;
        end;
        if FPrinterStatusNeeded then
        begin
          FPrinterJobID := QPLPrinter.PrinterJobID;
          FPrinterJobPrinterName := QPLPrinter.PrinterName;
        end;
      finally
        if (FPrintPreview) then
        begin
          FPrintPreviewBitmapData := QPLPrinter.SavePreviewToString;
        end;
        QPLPrinter.Free;
      end;
    end;
  finally
    SelectPage(OldPage);
  end;
end;

function TQuickPDF.RenderDocumentToFile(DPI: Double; StartPage, EndPage,
  Options: Integer; const FileName: WideString): Integer;
var
  OldPage: Integer;
  Temp: Integer;
begin
  FLastRenderError := '';
  OldPage := SelectedPage;
  try
    Result := 1;
    if EndPage < StartPage then
    begin
      Temp := EndPage;
      EndPage := StartPage;
      StartPage := Temp;
    end;
    if StartPage < 1 then StartPage := 1;
    if EndPage > PageCount then EndPage := PageCount;

{$IFDEF QPL_CAIRO}
    if (FUseCairo) then
    begin
      if not FSelDoc.PageTree.RenderPageToCairoFile(FRenderScale * DPI, StartPage,
        EndPage, Options, FJPEGQuality, FCairoFileName, FileName,
        HasPNGTransparency, PNGTransparencyColor,
        FLastRenderError, FSelDoc.GetViewOCGList) then Result := 0;
    end else
{$ENDIF}
{$IFDEF QPL_DPLR}
    if (FUseDPLR) then
    begin
      if not FSelDoc.PageTree.RenderPageToDPLRFile(FRenderScale * DPI, StartPage,
        EndPage, Options, FJPEGQuality, FDPLRFileName, FileName, FGDIPlusSettings,
        HasPNGTransparency, PNGTransparencyColor,
        FLastRenderError, FSelDoc.GetViewOCGList) then Result := 0;
    end else
{$ENDIF}
    begin
      if not FSelDoc.PageTree.RenderPageToFile(FRenderScale * DPI, StartPage,
        EndPage, Options, FJPEGQuality, FileName, FGDIPlusSettings,
        HasPNGTransparency, PNGTransparencyColor,
        FLastRenderError, FSelDoc.GetViewOCGList) then Result := 0;
    end;
  finally
    SelectPage(OldPage);
  end;
end;

function TQuickPDF.GetFormFieldBorderProperty(Index,
  PropKey: Integer): Double;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    case PropKey of
      1: Result := Field.GetBorderProperty(bpWidth) * FSelDoc.Scale;
      2: Result := Field.GetBorderProperty(bpDashOn) * FSelDoc.Scale;
      3: Result := Field.GetBorderProperty(bpDashOff) * FSelDoc.Scale;
    end;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldBorderStyle(Index: Integer): Integer;
var
  Field: TPDFField;
  BS: AnsiString;
  X: Integer;
const
  StyleKeys: array[0..4] of AnsiString = ('S', 'D', 'B', 'I', 'U');
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    BS := Field.GetBorderStyle;
    for X := 1 to 4 do
      if StyleKeys[X] = BS then Result := X;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldBorderColor(Index,
  ColorComponent: Integer): Double;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) and (ColorComponent >= 1) and (ColorComponent <= 4) then
  begin
    Result := Field.GetBorderColor(ColorComponent);
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.GetFormFieldBackgroundColor(Index,
  ColorComponent: Integer): Double;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) and (ColorComponent >= 1) and (ColorComponent <= 4) then
  begin
    Result := Field.GetBackgroundColor(ColorComponent);
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.AddSeparationColor(const ColorName: WideString; C, M, Y,
  K: Double; Options: Integer): Integer;
begin
  if ((FSelDoc.PDFAMode <> 1) and (FSelDoc.PDFAMode <> 2)) then
  begin
    if (FSelDoc.AddSeparationColor(AnsiString(ColorName), C, M, Y, K)) then
    begin
      Result := 1;
    end else
    begin
      Result := 0;
    end;
  end else
  begin
    Result := 0;
    FLastErrorCode := 601;
  end;
end;

function TQuickPDF.SetFillColorSep(const ColorName: WideString;
  Tint: Double): Integer;
var
  Sep: TPDFSeparationColor;
begin
  if ((FSelDoc.PDFAMode <> 1) and (FSelDoc.PDFAMode <> 2)) then
  begin
    Sep := FSelDoc.FindSeparation(AnsiString(ColorName));
    if (WideString(Sep.ColorName) = ColorName) then
    begin
      Result := 1;
      FSelDoc.PageTree.UseColorSpace(Sep.CSName, Sep.CS);
      FSelDoc.PageTree.Painter.SetFillColor(Sep.CSName, Tint);
    end else
    begin
      Result := 0;
    end;
  end else
  begin
    Result := 0;
    FLastErrorCode := 601;
  end;
end;

function TQuickPDF.SetLineColorSep(const ColorName: WideString;
  Tint: Double): Integer;
var
  Sep: TPDFSeparationColor;
begin
  if ((FSelDoc.PDFAMode <> 1) and (FSelDoc.PDFAMode <> 2)) then
  begin
    Sep := FSelDoc.FindSeparation(AnsiString(ColorName));
    if (WideString(Sep.ColorName) = ColorName) then
    begin
      Result := 1;
      FSelDoc.PageTree.UseColorSpace(Sep.CSName, Sep.CS);
      FSelDoc.PageTree.Painter.SetLineColor(Sep.CSName, Tint);
    end else
    begin
      Result := 0;
    end;
  end else
  begin
    Result := 0;
    FLastErrorCode := 601;
  end;
end;

function TQuickPDF.SetTextHighlightColorSep(
  const ColorName: WideString; Tint: Double): Integer;
var
  Sep: TPDFSeparationColor;
begin
  if ((FSelDoc.PDFAMode <> 1) and (FSelDoc.PDFAMode <> 2)) then
  begin
    Sep := FSelDoc.FindSeparation(AnsiString(ColorName));
    if (WideString(Sep.ColorName) = ColorName) then
    begin
      Result := 1;
      FSelDoc.PageTree.UseColorSpace(Sep.CSName, Sep.CS);
      FSelDoc.PageTree.Painter.SetHighlightColor(Sep.CSName, Tint);
    end else
      Result := 0;
  end else
  begin
    Result := 0;
    FLastErrorCode := 601;
  end;
end;

function TQuickPDF.SetTextColorSep(const ColorName: WideString;
  Tint: Double): Integer;
var
  Sep: TPDFSeparationColor;
begin
  if ((FSelDoc.PDFAMode <> 1) and (FSelDoc.PDFAMode <> 2)) then
  begin
    Sep := FSelDoc.FindSeparation(AnsiString(ColorName));
    if (WideString(Sep.ColorName) = ColorName) then
    begin
      Result := 1;
      FSelDoc.PageTree.UseColorSpace(Sep.CSName, Sep.CS);
      FSelDoc.PageTree.Painter.SetTextColor(Sep.CSName, Tint);
    end else
      Result := 0;
  end else
  begin
    Result := 0;
    FLastErrorCode := 601;
  end;
end;

function TQuickPDF.SetTextUnderlineColorSep(
  const ColorName: WideString; Tint: Double): Integer;
var
  Sep: TPDFSeparationColor;
begin
  if ((FSelDoc.PDFAMode <> 1) and (FSelDoc.PDFAMode <> 2)) then
  begin
    Sep := FSelDoc.FindSeparation(AnsiString(ColorName));
    if (WideString(Sep.ColorName) = ColorName) then
    begin
      Result := 1;
      FSelDoc.PageTree.UseColorSpace(Sep.CSName, Sep.CS);
      FSelDoc.PageTree.Painter.SetUnderlineColor(Sep.CSName, Tint);
    end else
      Result := 0;
  end else
  begin
    Result := 0;
    FLastErrorCode := 601;
  end;
end;

function TQuickPDF.SetFormFieldBorderColorSep(Index: Integer;
  const ColorName: WideString; Tint: Double): Integer;
var
  Field: TPDFField;
  Sep: TPDFSeparationColor;
begin
  Result := 0;
  Sep := FSelDoc.FindSeparation(AnsiString(ColorName));
  if (WideString(Sep.ColorName) = ColorName) then
  begin
    FSelDoc.AcroForm.UseSeparationColor(Sep.CSName, Sep.CS);
    Field := FindFormField(Index);
    if Assigned(Field) then
    begin
      Field.SetBorderColor(Sep.CSName, Tint);
      Result := 1;
      if Field.TempField then Field.Free;
    end;
  end;
end;

function TQuickPDF.SetFormFieldBackgroundColorSep(Index: Integer;
  const ColorName: WideString; Tint: Double): Integer;
var
  Field: TPDFField;
  Sep: TPDFSeparationColor;
begin
  Result := 0;
  Sep := FSelDoc.FindSeparation(AnsiString(ColorName));
  if (WideString(Sep.ColorName) = ColorName) then
  begin
    FSelDoc.AcroForm.UseSeparationColor(Sep.CSName, Sep.CS);
    Field := FindFormField(Index);
    if Assigned(Field) then
    begin
      Field.SetBackgroundColor(Sep.CSName, Tint);
      Result := 1;
      if Field.TempField then Field.Free;
    end;
  end;
end;

function TQuickPDF.SetFormFieldColorSep(Index: Integer;
  const ColorName: WideString; Tint: Double): Integer;
var
  Field: TPDFField;
  Sep: TPDFSeparationColor;
begin
  Result := 0;
  Sep := FSelDoc.FindSeparation(AnsiString(ColorName));
  if (WideString(Sep.ColorName) = ColorName) then
  begin
    FSelDoc.AcroForm.UseSeparationColor(Sep.CSName, Sep.CS);
    Field := FindFormField(Index);
    if Assigned(Field) then
    begin
      Field.SetFontColor(Sep.CSName, Tint);
      Result := 1;
      if Field.TempField then Field.Free;
    end;
  end;
end;

function TQuickPDF.SetFormFieldBackgroundColorCMYK(Index: Integer; C,
  M, Y, K: Double): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.SetBackgroundColor(C, M, Y, K);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldColorCMYK(Index: Integer; C, M, Y,
  K: Double): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) and (C >= 0) and (C <= 1) and (M >= 0) and
    (M <= 1) and (Y >= 0) and (Y <= 1) and (K >= 0) and (K <= 1) then
  begin
    Field.SetFontColor(C, M, Y, K);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldBorderColorCMYK(Index: Integer; C, M, Y,
  K: Double): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.SetBorderColor(C, M, Y, K);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.AddSVGAnnotationFromFile(Left, Top, Width,
  Height: Double; const FileName: WideString; Options: Integer): Integer;
var
  FS: TQuickPDFWideFileStream;
begin
  Result := 0;
  if QPLFileExists(FileName) then
  try
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    try
      FSelDoc.PageTree.AddSVGAnnotation(TranslateX(Left), TranslateY(Top),
        GetScale(Width), GetScale(Height), FS, AnsiString(QPLExtractFileName(FileName)), Options);
      Result := 1;
    finally
      FS.Free;
    end;
  except
  end;
end;

function TQuickPDF.GetFormFieldReadOnly(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        if Field.ReadOnly then
          Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.AnnotationCount: Integer;
begin
  Result := FSelDoc.PageTree.Annots.Count;
end;

function TQuickPDF.GetAnnotDblProperty(Index, Tag: Integer): Double;
begin
  FSelDoc.PageTree.Annots.AnalyseAnnot(Index - 1);
  Result := FSelDoc.PageTree.Annots.GetDoubleProp(Tag);
  if (((Tag >= 105) and (Tag <= 108)) or (Tag = 132)) then
  begin
    Result := Result * FSelDoc.Scale;
    case Tag of
      105: if (FSelDoc.Origin = 2) or (FSelDoc.Origin = 3) then
           Result := PageWidth - Result;
      106: if (FSelDoc.Origin = 1) or (FSelDoc.Origin = 2) then
           Result := PageHeight - Result;
    end;
  end;
end;

function TQuickPDF.GetAnnotIntProperty(Index, Tag: Integer): Integer;
begin
  FSelDoc.PageTree.Annots.AnalyseAnnot(Index - 1);
  Result := FSelDoc.PageTree.Annots.GetIntegerProp(Tag);
end;

function TQuickPDF.GetAnnotStrProperty(Index, Tag: Integer): WideString;
begin
  FSelDoc.PageTree.Annots.AnalyseAnnot(Index - 1);
  Result := FSelDoc.PageTree.Annots.GetStringProp(Tag);
end;

function TQuickPDF.DARenderPageToString(FileHandle, PageRef,
  Options: Integer; DPI: Double): AnsiString;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
  MS: TMemoryStream;
begin
  FLastRenderError := '';
  Result := '';
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
    begin
      MS := TMemoryStream.Create;
      try
{$IFDEF QPL_DPLR}
        if (FUseDPLR) then
        begin
          Link.Doc.RenderPageToDPLRStream(Page, Options, FRenderScale * DPI,
            FJPEGQuality, FDPLRFileName, MS, FLastRenderError, Link.Doc.GetViewOCGList);
        end else
{$ENDIF}
        begin
          Link.Doc.RenderPageToStream(Page, Options, FRenderScale * DPI,
            FJPEGQuality, FGDIPlusSettings, MS, FLastRenderError, Link.Doc.GetViewOCGList);
        end;
        MS.Seek(0, soBeginning);
        SetLength(Result, MS.Size);
        if (MS.Size > 0) then
        begin
          MS.Read(Result[1], Length(Result))
        end;
      finally
        MS.Free;
      end;
    end;
  end;
end;

function TQuickPDF.GetKerning(
  const CharPair: WideString): Integer;
begin
  Result := 0;
  if Assigned(FSelFont) and (Length(CharPair) = 2) then
    Result := FSelFont.GetKernAmount(CharPair[1], CharPair[2]);
end;

function TQuickPDF.FontHasKerning: Integer;
begin
  if Assigned(FSelFont) and (FSelFont.HasKernData) then
    Result := 1
  else
    Result := 0;
end;

function TQuickPDF.SetKerning(const CharPair: WideString;
  Adjustment: Integer): Integer;
begin
  Result := 0;
  if Assigned(FSelFont) and (Length(CharPair) = 2) then
  begin
    FSelFont.SetKernAmount(CharPair[1], CharPair[2], Adjustment);
    Result := 1;
  end;
end;

function TQuickPDF.UseKerning(Kern: Integer): Integer;
begin
  if (Kern >= 0) and (Kern <= 2) then
  begin
    FKernSupport := TKernSupport(Kern);
    FSelDoc.PageTree.Painter.UseKerning := Kern = 1;
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.AppendSpace(RelativeSpace: Double): Integer;
begin
  CheckFontSelection;
  FSelDoc.PageTree.Painter.AppendSpace(RelativeSpace *
    FSelDoc.PageTree.Painter.TextHeight);
  Result := 1;
end;

function TQuickPDF.SetGDIPlusFileName(
  const DLLFileName: WideString): Integer;
begin
  if QPLFileExists(DLLFileName) then
  begin
    FGDIPlusSettings.FileName := DLLFileName;
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.SetJPEGQuality(Quality: Integer): Integer;
begin
  if Quality < 1 then Quality := 1;
  if Quality > 100 then Quality := 100;
  FJPEGQuality := Quality;
  Result := 1;
end;

function TQuickPDF.EncryptWithFingerprint(
  const Fingerprint: WideString): Integer;
begin
  Result := 0;
  FLastErrorCode := 0;
  if EncryptionStatus = 0 then
  begin
    if FSelDoc.EncryptWithFingerprint(AnsiString(Fingerprint)) then
      Result := 1;
  end else
    FLastErrorCode := 103;
end;

function TQuickPDF.GetEncryptionFingerprint: WideString;
begin
  Result := WideString(FSelDoc.EncryptionFingerprint);
end;

function TQuickPDF.AddPageLabels(Start, Style, Offset: Integer;
  const Prefix: WideString): Integer;
var
  StyleStr: AnsiString;
const
  NumStyle: array[1..5] of AnsiString = ('D', 'R', 'r', 'A', 'a');
begin
  if (Style >= 0) and (Style <= 5) then
  begin
    if Style = 0 then StyleStr := '' else StyleStr := NumStyle[Style];
    FSelDoc.AddPageLabelEntry(Start, StyleStr, Offset, Prefix);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.GetPageLabel(Page: Integer): WideString;
begin
  Result := FSelDoc.GetPageLabel(Page);
end;

function TQuickPDF.ClearPageLabels: Integer;
begin
  FSelDoc.ClearPageLabels;
  Result := 1;
end;

function TQuickPDF.EmbedFile(const Title, FileName,
  MIMEType: WideString): Integer;
var
  EFS: TPDFIndRef;
  TitleA: AnsiString;
  MIMETypeA: AnsiString;
begin
  TitleA := AnsiString(Title);
  MIMETypeA := AnsiString(MIMEType);

  Result := 0;
  if (Title <> '') and QPLFileExists(FileName) then
  begin
    EFS := FSelDoc.MakeEmbeddedFileSpec(FileName, MIMETypeA);
    if FSelDoc.AttachFile(TitleA, EFS) then
      Result := 1;
  end;
end;

function TQuickPDF.FitRotatedTextBox(Left, Top, Width, Height,
  Angle: Double; const Text: WideString; Options: Integer): Integer;
begin
  if ((Options >= 0) and (Options <= 2)) or ((Options >= 100) and (Options <= 102)) or ((Options >= 1000) and (Options <= 1002)) then
  begin
    CheckFontSelection;
    FSelDoc.PageTree.Painter.FitRotatedWideTextBox(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), Angle, FixWideDelimited(Text, FSelDoc.BreakString),
      Options, FSelDoc.BreakString);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.SetDocumentMetadata(const XMP: WideString): Integer;
begin
  Result := 1;
  FSelDoc.SetMetadata(QPLUTF8Encode(XMP));
end;

function TQuickPDF.GetFormFieldKidCount(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.KidCount;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.FormFieldHasParent(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    if Field.HasParent then Result := 1;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.PrintOptions(PageScaling,
  AutoRotateCenter: Integer; const Title: WideString): Integer;
var
  TitleIndex: Integer;
begin
  Result := PageScaling and 15;
  if AutoRotateCenter <> 0 then Result := Result + 16;
  if AutoRotateCenter = -1 then Result := Result + 32;
  FPrintTitles.Add(AnsiString(Title));
  TitleIndex := FPrintTitles.Count + 450 - 1;
  Result := Result or TitleIndex shl 8;
end;

function TQuickPDF.PrintMode(Mode: Integer): Integer;
begin
  if (Mode > 0) then
    FGDIPlusSettings.PrintMode := Mode;
  Result := FGDIPlusSettings.PrintMode;
end;

function TQuickPDF.CapturePageEx(Page, Options: Integer): Integer;
begin
  if (Page >= 1) and (Page <= FSelDoc.PageCount) and (FSelDoc.PageCount > 1) then
  begin
    SelectPage(Page);
    Result := IntCast(FSelDoc.CapturePage(Options));
    HidePage;
  end else
    Result := 0;
end;

function TQuickPDF.DACapturePageEx(FileHandle, PageRef,
  Options: Integer): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
      Result := IntCast(Link.Doc.CapturePage(Page, Options));
  end;
end;

function TQuickPDF.DAMovePage(FileHandle, PageRef, TargetPageRef,
  Options: Integer): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
  TargetPage: TPDFIndRef;
  Before: Boolean;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    TargetPage := ValidPageRef(Link, TargetPageRef);
    Before := Options = 0;
    if Assigned(Page) and Assigned(TargetPage) then
      if Link.Doc.MovePage(Page, TargetPage, Before) then
        Result := 1;
  end;
end;

function TQuickPDF.DAPageRotation(FileHandle,
  PageRef: Integer): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
      Result := Link.Doc.GetPageRotation(Page);
  end;
end;

function TQuickPDF.DARotatePage(FileHandle, PageRef, Angle,
  Options: Integer): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  if Angle mod 90 = 0 then
  begin
    Link := ValidFileHandle(FileHandle);
    if Assigned(Link) then
    begin
      Page := ValidPageRef(Link, PageRef);
      if Assigned(Page) then
        if Link.Doc.SetPageRotation(Page, Angle, Options) then Result := 1;
    end;
  end;
end;

function TQuickPDF.GetPageBox(BoxType, Dimension: Integer): Double;
const
  BoxNames: array[1..5] of AnsiString = ('MediaBox', 'CropBox', 'BleedBox',
    'TrimBox', 'ArtBox');
var
  D: TPDFDimension;
begin
  Result := 0;
  if (BoxType >= 1) and (BoxType <= 5) and (Dimension >= 0) and (Dimension <= 5) then
  begin
    D := TPDFDimension(Dimension);
    Result := FSelDoc.PageTree.PageBoxProperties(BoxNames[BoxType], D);
    Result := Result * FSelDoc.Scale;
    case D of
      pdLeft,pdRight: if (FSelDoc.Origin = 2) or (FSelDoc.Origin = 3) then
           Result := PageWidth - Result;
      pdTop,pdBottom: if (FSelDoc.Origin = 1) or (FSelDoc.Origin = 2) then
           Result := PageHeight - Result;
    end;
  end;
end;

function TQuickPDF.HasPageBox(BoxType: Integer): Integer;
const
  BoxNames: array[1..5] of AnsiString = ('MediaBox', 'CropBox', 'BleedBox',
    'TrimBox', 'ArtBox');
begin
  Result := 0;
  if (BoxType >= 1) and (BoxType <= 5) then
    Result := FSelDoc.PageTree.HasPageBox(BoxNames[BoxType]);
end;

function TQuickPDF.AddLinkToFile(Left, Top, Width, Height: Double;
  const FileName: WideString; Page: Integer; Position: Double; NewWindow,
  Options: Integer): Integer;
var
  lConvertedFileName: WideString;
begin
  if Page > 0 then
  begin
    lConvertedFileName := FSelDoc.PageTree.ConvertToFileSpecString(FileName);
    FSelDoc.PageTree.AddLinkToFile(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), FileName, Page, TranslateY(Position),
      NewWindow = 1, Options);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.AddRelativeLinkToFile(Left, Top, Width, Height: Double;
  const FileName: WideString; Page: Integer; Position: Double; NewWindow,
  Options: Integer): Integer;
var
  lConvertedFileName: WideString;
begin
  if Page > 0 then
  begin
    lConvertedFileName := FSelDoc.PageTree.ConvertToFileSpecString(FileName, FSelDoc.SourceFileName);
    FSelDoc.PageTree.AddLinkToFile(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), lConvertedFileName, Page, TranslateY(Position),
      NewWindow = 1, Options);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.AddLinkToFileDest(Left, Top, Width, Height: Double;
  const FileName: WideString; NamedDest: WideString; Position: Double; NewWindow,
  Options: Integer): Integer;
begin
  if Length(NamedDest) > 0 then
  begin
    FSelDoc.PageTree.AddLinkToFileDest(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), FileName, NamedDest, TranslateY(Position),
      NewWindow = 1, Options);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.AddRelativeLinkToFileDest(Left, Top, Width, Height: Double;
  const FileName: WideString; NamedDest: WideString; Position: Double; NewWindow,
  Options: Integer): Integer;
var
  lConvertedFileName: WideString;
begin
  if Length(NamedDest) > 0 then
  begin
    lConvertedFileName := FSelDoc.PageTree.ConvertToFileSpecString(FileName, FSelDoc.SourceFileName);
    FSelDoc.PageTree.AddLinkToFileDest(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), lConvertedFileName, NamedDest, TranslateY(Position),
      NewWindow = 1, Options);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.CheckPageAnnots: Integer;
begin
  if FSelDoc.PageTree.CheckPageAnnots then Result := 1 else Result := 0;
end;

function TQuickPDF.GetDocumentIdentifier(Part,
  Options: Integer): WideString;
begin
  Result := WideString(FSelDoc.GetDocID(Part, Options));
end;

function TQuickPDF.NewOptionalContentGroup(
  const GroupName: WideString): Integer;
begin
  if (FSelDoc.Version < '1.5') then
  begin
    FSelDoc.Version := '1.5';
  end;
  Result := IntCast(FSelDoc.NewOCG(GroupName));
end;

function TQuickPDF.SetCapturedPageOptional(CaptureID,
  OptionalContentGroupID: Integer): Integer;
var
  CP: TPDFCapturedPage;
  OCG: TPDFIndRef;
  Obj: TPDFObject;
  CapStream: TPDFStream;
begin
  Result := 0;
  CP := ValidCaptureID(CaptureID);
  OCG := ValidOCG(OptionalContentGroupID);
  if (Assigned(CP) and Assigned(OCG)) then
  begin
    Obj := CP.XObject.Obj;
    if Obj is TPDFStream then
    begin
      CapStream := TPDFStream(Obj);
      CapStream.Dictionary.Add('OC', OCG);
      Result := 1;
    end;
  end;
end;

function TQuickPDF.SetContentStreamOptional(
  OptionalContentGroupID: Integer): Integer;
var
  OCGRef: TPDFIndRef;
  OCGName: AnsiString;
begin
  Result := 0;
  OCGRef := ValidOCG(OptionalContentGroupID);
  if Assigned(OCGRef) then
  begin
    Result := 1;
    OCGName := FSelDoc.PageTree.UseOCG(OCGRef);
    SetContentStreamFromString('q /OC /' + OCGName + ' BDC ' + GetContentStreamToString + ' EMC Q ');
    FSelDoc.PageTree.Painter.ChangeAll;
  end;
end;

function TQuickPDF.GetOptionalContentGroupID(Index: Integer): Integer;
begin
  Result := IntCast(FSelDoc.OCGRef(Index));
end;

function TQuickPDF.GetOptionalContentGroupName(OptionalContentGroupID: Integer): WideString;
var
  OCGRef: TPDFIndRef;
begin
  OCGRef := ValidOCG(OptionalContentGroupID);
  if Assigned(OCGRef) then
  begin
    Result := FSelDoc.OCGName(OCGRef);
  end else
  begin
    Result := '';
  end;
end;

function TQuickPDF.OptionalContentGroupCount: Integer;
begin
  Result := FSelDoc.OCGCount;
end;

function TQuickPDF.SetOptionalContentGroupVisible(
  OptionalContentGroupID, Visible: Integer): Integer;
var
  OCGRef: TPDFIndRef;
begin
  OCGRef := ValidOCG(OptionalContentGroupID);
  if Assigned(OCGRef) then
  begin
    if FSelDoc.SetOCGVisible(OCGRef, Visible = 1) then
      Result := 1
    else
      Result := 0;
  end else
    Result := 0;
end;

function TQuickPDF.DeleteOptionalContentGroup(
  OptionalContentGroupID: Integer): Integer;
var
  OCGRef: TPDFIndRef;
begin
  OCGRef := ValidOCG(OptionalContentGroupID);
  if Assigned(OCGRef) then
  begin
    if FSelDoc.DeleteOCG(OCGRef) then
      Result := 1
    else
      Result := 0;
  end else
    Result := 0;
end;

function TQuickPDF.ImageFillColor: Integer;
begin
  FLastErrorCode := 0;
  if Assigned(FSelImage) then
    Result := Ord(FSelImage.FillColor)
  else
    Result := 0;
end;

function TQuickPDF.ReplaceImage(OriginalImageID,
  NewImageID: Integer): Integer;
var
  OriginalImage: TPDFImage;
  NewImage: TPDFImage;
begin
  Result := 0;
  OriginalImage := ValidImageID(OriginalImageID);
  NewImage := ValidImageID(NewImageID);
  if (Assigned(OriginalImage) and Assigned(NewImage) and
    FSelDoc.IsImage(OriginalImage) and
    FSelDoc.IsImage(NewImage)) then
  begin
    if FSelDoc.PageTree.ReplaceImage(OriginalImage, NewImage) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.GetFormFieldComb(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    if Field.Comb then Result := 1 else Result := 0;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldComb(Index, Comb: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.Comb := Comb = 1;
    if Field.TempField then Field.Free;
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.GetBarcodeWidth(NominalWidth: Double; const Text: WideString;
  Barcode: Integer): Double;
var
  X: Integer;
  Valid: Boolean;
  BarText: AnsiString;
  CheckTotal: Integer;
  CheckDigit: Integer;
  ValidChar: AnsiString;
  Bars: TBarArray;
begin
  Result := 0;
  BarText := AnsiString(Text);
  if (Barcode >= 1) and (Barcode <= 5) then
  begin
    Valid := False;
    if Barcode = 1 then
    begin
      Valid := True;
    end;
    if Barcode = 2 then
    begin
      Valid := Length(BarText) = 13;
      for X := 1 to Length(BarText) do
      begin
        if (BarText[X] < '0') or (BarText[X] > '9') then
        begin
          Valid := False;
          FLastErrorCode := 302;
        end;
      end;
      if Valid then
      begin
        CheckTotal := 0;
        for X := 1 to 12 do
        begin
          if (X mod 2) = 1 then
            CheckTotal := CheckTotal + Ord(BarText[X]) - 48
          else
            CheckTotal := CheckTotal + (Ord(BarText[X]) - 48) * 3;
        end;
        CheckDigit := 0;
        while (CheckDigit + CheckTotal) mod 10 <> 0 do
          Inc(CheckDigit);
        if QPLIntToStr(CheckDigit) <> BarText[13] then
        begin
          Valid := False;
          FLastErrorCode := 303;
        end;
      end;
    end;
    if Barcode = 3 then
    begin
      Valid := True;
      ValidChar := '';
      for X := 32 to 126 do
        ValidChar := ValidChar + AnsiChar(X);
      for X := 1 to Length(BarText) do
      begin
        if QPLPos(BarText[X], ValidChar) = 0 then
          Valid := False;
      end;
    end;
    if Barcode = 4 then
    begin
      BarText := '';
      for X := 1 to Length(Text) do
        if (Text[X] >= '0') and (Text[X] <= '9') then BarText := BarText + AnsiChar(Text[X]);
      Valid := (Length(BarText) = 5) or (Length(BarText) = 9) or
        (Length(BarText) = 11);
    end;
    if Barcode = 5 then
    begin
      BarText := '';
      for X := 1 to Length(Text) do
        if (Text[X] >= '0') and (Text[X] <= '9') then BarText := BarText + AnsiChar(Text[X]);
      if (Length(BarText) >= 2) and (Length(BarText) mod 2 = 0) then
        Valid := True;
      if (Length(BarText) >= 1) and (Length(BarText) mod 2 = 1) then
      begin
        Valid := True;
        CheckTotal := 0;
        for X := 1 to Length(BarText) do
          if X mod 2 = 1 then
            CheckTotal := CheckTotal + 3 * QPLStrToInt(BarText[X])
          else
            CheckTotal := CheckTotal + QPLStrToInt(BarText[X]);
        CheckDigit := 0;
        while (CheckDigit + CheckTotal) mod 10 <> 0 do
          Inc(CheckDigit);
        BarText := BarText + QPLIntToStr(CheckDigit);
      end;
    end;
  end else
    Valid := False;
  if Valid then
  begin
    case Barcode of
      1: Result := Code39(BarText, Bars) * NominalWidth / 4;
      2: Result := EAN13(BarText, Bars) * NominalWidth;
      3: Result := Code128(BarText, Bars) * NominalWidth;
      4: Result := PostNet(BarText, Bars) * NominalWidth;
      5: Result := Interleaved2of5(BarText, Bars) * NominalWidth / 2;
    end;
  end;
  Result := GetScale(Result);
end;

function TQuickPDF.GetBaseURL: WideString;
begin
  Result := WideString(FSelDoc.GetBaseURL);
end;

function TQuickPDF.SetAnnotContents(Index: Integer;
  const NewContents: WideString): Integer;
begin
  if (FSelDoc.PageTree.Annots.SetContents(
    Index - 1, AnsiString(NewContents))) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetFormFieldStandardFont(Index,
  StandardFontID: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) and (StandardFontID >= 0) and (StandardFontID <= 13) then
  begin
    Field.SetStandardFont(StandardFontID);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.RenderPageToStream(DPI: Double; Page, Options: Integer;
  Target: TStream): Integer;
var
  OldPage: Integer;
begin
  FLastRenderError := '';
  OldPage := SelectedPage;
  try
    Result := 1;
    if Page < 1 then Page := 1;
    if Page > PageCount then Page := PageCount;
{$IFDEF QPL_CAIRO}
    if (FUseCairo) then
    begin
      if not FSelDoc.PageTree.RenderPageToCairoStream(FRenderScale * DPI, Page,
        Options, FJPEGQuality, FCairoFileName, Target,
        FLastRenderError, FRenderCropType, FSelDoc.GetViewOCGList) then Result := 0;
    end else
{$ENDIF}
{$IFDEF QPL_DPLR}
    if (FUseDPLR) then
    begin
      if not FSelDoc.PageTree.RenderPageToDPLRStream(FRenderScale * DPI, Page,
        Options, FJPEGQuality, FGDIPlusSettings, FDPLRFileName, Target,
        FLastRenderError, FRenderCropType, FSelDoc.GetViewOCGList) then Result := 0;
    end else
{$ENDIF}
    begin
      if not FSelDoc.PageTree.RenderPageToStream(FRenderScale * DPI, Page,
        Options, FJPEGQuality, FGDIPlusSettings, Target,
        FLastRenderError, FRenderCropType, FSelDoc.GetViewOCGList) then Result := 0;
    end;
  finally
    SelectPage(OldPage);
  end;
end;

function TQuickPDF.SetImageOptional(
  OptionalContentGroupID: Integer): Integer;
var
  OCG: TPDFIndRef;
begin
  Result := 0;
  if Assigned(FSelImage) then
  begin
    OCG := ValidOCG(OptionalContentGroupID);
    if Assigned(OCG) then
    begin
      FSelImage.SetOCG(OCG);
      Result := 1;
    end;
  end;
end;

function TQuickPDF.SetBlendMode(BlendMode: Integer): Integer;
begin
  if (BlendMode >= 0) and (BlendMode <= 15) then
  begin
    FSelDoc.AddBlendMode(TPDFBlendMode(BlendMode));
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.DAGetPageImageList(FileHandle,
  PageRef: Integer): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
    begin
      Result := IntCast(Link.Doc.GetPageImages(Page));
    end;
  end;
end;

function TQuickPDF.DAGetImageDataToString(FileHandle, ImageListID,
  ImageIndex: Integer): AnsiString;
var
  Link: TSmartPDFLink;
  ImageList: TPDFImageList;
begin
  Result := '';
  Link := ValidFileHandle(FileHandle);
  if (Assigned(Link)) then
  begin
    ImageList := ValidImageListID(Link, ImageListID);
    if Assigned((ImageList)) then
    begin
      Result := Link.Doc.GetImageData(ImageList, ImageIndex);
    end;
  end;
end;

function TQuickPDF.DAGetImageDblProperty(FileHandle, ImageListID,
  ImageIndex, PropertyID: Integer): Double;
var
  Link: TSmartPDFLink;
  ImageList: TPDFImageList;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if (Assigned(Link)) then
  begin
    ImageList := ValidImageListID(Link, ImageListID);
    if (Assigned(ImageList)) then
    begin
      Result := Link.Doc.GetImageDblProperty(ImageList, ImageIndex, PropertyID);
    end;
  end;
end;

function TQuickPDF.DAGetImageIntProperty(FileHandle, ImageListID,
  ImageIndex, PropertyID: Integer): Integer;
var
  Link: TSmartPDFLink;
  ImageList: TPDFImageList;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if (Assigned(Link)) then
  begin
    ImageList := ValidImageListID(Link, ImageListID);
    if (Assigned(ImageList)) then
    begin
      Result := Link.Doc.GetImageIntProperty(ImageList, ImageIndex, PropertyID);
    end;
  end;
end;

function TQuickPDF.DAGetImageListCount(FileHandle,
  ImageListID: Integer): Integer;
var
  Link: TSmartPDFLink;
  ImageList: TPDFImageList;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if (Assigned(Link)) then
  begin
    ImageList := ValidImageListID(Link, ImageListID);
    if (Assigned(ImageList)) then
    begin
      Result := Link.Doc.GetImageListCount(ImageList);
    end;
  end;
end;

function TQuickPDF.DASaveImageDataToFile(FileHandle, ImageListID,
  ImageIndex: Integer; const ImageFileName: WideString): Integer;
var
  Link: TSmartPDFLink;
  FS: TQuickPDFWideFileStream;
  ImageData: AnsiString;
  ImageList: TPDFImageList;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    ImageList := ValidImageListID(Link, ImageListID);
    if (Assigned(ImageList)) then
    begin
      ImageData := Link.Doc.GetImageData(ImageList, ImageIndex);
    end;
    if Length(ImageData) > 0 then
    begin
      try
        FS := QPLCreateFileStream(ImageFileName, fmCreate);
        try
          FS.Write(ImageData[1], Length(ImageData));
        finally
          FS.Free;
        end;
        Result := 1;
      except
      end;
    end;
  end;
end;

function TQuickPDF.RenderPageToString(DPI: Double; Page,
  Options: Integer): AnsiString;
var
  MS: TMemoryStream;
begin
  FLastRenderError := '';
  MS := TMemoryStream.Create;
  try
    RenderPageToStream(DPI, Page, Options, MS);
    MS.Seek(0, soFromBeginning);
    SetLength(Result, MS.Size);
    if (Length(Result) > 0) then
    begin
      MS.Read(Result[1], Length(Result));
    end;
  finally
    MS.Free;
  end;
end;

function TQuickPDF.GetDocumentMetadata: WideString;
begin
  Result := DPLXMPToWideString(FSelDoc.GetMetadata);
end;

function TQuickPDF.GetFileMetadata(
  const InputFileName, Password: WideString): WideString;
var
  FS: TQuickPDFWideFileStream;
  Reader: TSmartPDFReader;
  Info: TSmartPDFInfo;
begin
  Result := '';
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    try
      FS := QPLCreateFileStream(InputFileName, fmOpenRead or fmShareDenyWrite);
      try
        Reader := TSmartPDFReader.Create(FS);
        try
          if Reader.ErrorCode = ecNone then
          begin
            Info := TSmartPDFInfo.Create(Reader, '');
            try
              if ((Info.Encrypted = spEncrypted) and Info.CheckPassword(Password)) or
                (Info.Encrypted = spDecrypted) then
              begin
                Info.Password := Password;
                Result := DPLXMPToWideString(Info.GetMetadata);
              end else
                FLastErrorCode := 404;
            finally
              Info.Free;
            end;
          end else
            FLastErrorCode := 409;
        finally
          Reader.Free;
        end;
      finally
        FS.Free;
      end;
    except
      FLastErrorCode := 401;
    end;
  end else
    FLastErrorCode := 999;
end;

function TQuickPDF.GetCustomKeys(Location: Integer): WideString;
begin
  Result := '';
  if Location = 1 then Result := WideString(FSelDoc.GetInfoKeys);
  if Location = 2 then Result := WideString(FSelDoc.GetCatalogKeys);
end;

function TQuickPDF.NewCustomPrinter(
  const OriginalPrinterName: WideString): WideString;
var
  CustomPrinter: TPDFCustomPrinter;
begin
  if (ValidPrinterName(OriginalPrinterName)) then
  begin
    Result := WideString('QPLPrinter' + QPLRandomID);
    CustomPrinter := TPDFCustomPrinter.Create(OriginalPrinterName);
    FCustomPrinters.AddObject(AnsiString(Result), CustomPrinter);
  end else
  begin
    Result := '';
  end;
end;

function TQuickPDF.SetupCustomPrinter(const CustomPrinterName: WideString;
  Setting, NewValue: Integer): Integer;
var
  I: Integer;
  CP: TPDFCustomPrinter;
begin
  Result := 0;
  I := FCustomPrinters.IndexOf(QPLUpperCase(AnsiString(CustomPrinterName)));
  if I >= 0 then
  begin
    CP := TPDFCustomPrinter(FCustomPrinters.Objects[I]);
    if CP.Setup(Setting, NewValue) then Result := 1;
  end;
end;

function TQuickPDF.GetPrinterNames: WideString;
var
  X: Integer;
begin
  Result := '';
  for X := 0 to Printer.Printers.Count - 1 do
  begin
    Result := Result + '"' + WideString(Printer.Printers[X]) + '"';
    if X < Printer.Printers.Count - 1 then Result := Result + ',';
  end;
end;

function TQuickPDF.SetCustomLineDash(
  const DashPattern: WideString; DashPhase: Double): Integer;
var
  CutDash: AnsiString;
  ThisDash: Double;
  DashArray: AnsiString;

  function Pop: AnsiString;
  var
    P1: Integer;
  begin
    if Length(CutDash) > 0 then
    begin
      P1 := QPLPos(',', CutDash);
      if P1 > 0 then
      begin
        if P1 = Length(CutDash) then
        begin
          Result := QPLTrim(QPLCopy(CutDash, 1, P1 - 1));
          CutDash := '';
        end else
        begin
          Result := QPLTrim(QPLCopy(CutDash, 1, P1 - 1));
          Delete(CutDash, 1, P1);
        end;
      end else
      begin
        Result := CutDash;
        CutDash := '';
      end;
    end else
      Result := '';
  end;

begin
  CutDash := AnsiString(DashPattern);
  DashArray := '[ ';
  repeat
    ThisDash := TazzToFloat(Pop);
    if ThisDash > 0 then
      DashArray := DashArray + QPLDoubleToStrConst(GetScale(ThisDash),
        FSelDoc.PageTree.Painter.PDFPrecNum) + ' ';
  until ThisDash <= 0;
  if DashArray <> '[ ' then
  begin
    DashArray := DashArray + '] ' + QPLDoubleToStrConst(GetScale(DashPhase),
      FSelDoc.PageTree.Painter.PDFPrecNum);
    FSelDoc.PageTree.Painter.SetCustomLineDash(DashArray);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.RemoveSharedContentStreams: Integer;
begin
  if EncryptionStatus = 0 then
  begin
    if FSelDoc.RemoveSharedLayers then Result := 1 else Result := 0;
  end else
    Result := 0;
end;

function TQuickPDF.GetPrinterBins(const PrinterName: WideString): WideString;
var
  LocalPrinter: TPrinter;
  CustomPrinterIndex: Integer;
  OriginalPrinterName: WideString;
{$IFNDEF UNICODE}
  PrinterNameA: AnsiString;
  OriginalPrinterNameA: AnsiString;
{$ENDIF}
  CustomPrinter: TPDFCustomPrinter;
begin
  LocalPrinter := GetPrinter;
  CustomPrinterIndex := FCustomPrinters.IndexOf(QPLUpperCase(AnsiString(PrinterName)));
  if (CustomPrinterIndex >= 0) then
  begin
    CustomPrinter := TPDFCustomPrinter(FCustomPrinters.Objects[CustomPrinterIndex]);
    OriginalPrinterName := CustomPrinter.OriginalPrinterName;
{$IFDEF UNICODE}
    LocalPrinter.SetPrinter(@OriginalPrinterName[1], 'WINSPOOL', '', 0);
{$ELSE}
    OriginalPrinterNameA := AnsiString(OriginalPrinterName);
    LocalPrinter.SetPrinter(@OriginalPrinterNameA[1], 'WINSPOOL', '', 0);
{$ENDIF}
  end else
  begin
{$IFDEF UNICODE}
    LocalPrinter.SetPrinter(@PrinterName[1], 'WINSPOOL', '', 0);
{$ELSE}
    PrinterNameA := AnsiString(PrinterName);
    LocalPrinter.SetPrinter(@PrinterNameA[1], 'WINSPOOL', '', 0);
{$ENDIF}
  end;
  Result := WideString(DebenuPDFLibraryPrinting.GetPrinterBins(LocalPrinter));
end;

function TQuickPDF.GetFormFieldChoiceType(Index: Integer): Integer;
var
  Count: Integer;
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    Count := FSelDoc.AcroForm.Count;
    if (Index > 0) and (Index <= Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        if (Field.FieldType = ftChoice) then
        begin
          if ((Field.Flags and $20000) = $20000) then
          begin
            if ((Field.Flags and $40000) = $40000) then
            begin
              Result := 4;
            end else
            begin
              Result := 2;
            end;
          end else
          begin
            if ((Field.Flags and $200000) = $200000) then
            begin
              Result := 3;
            end else
            begin
              Result := 1;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.SetGDIPlusOptions(OptionID,
  NewValue: Integer): Integer;
begin
  Result := 0;
  case OptionID of
    0: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      FGDIPlusSettings.UseGDIPlus := NewValue = 1;
    end;
    1: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      FGDIPlusSettings.Smoothing := NewValue = 1;
    end;
    2: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      FGDIPlusSettings.AccurateInterpolation := NewValue = 1;
    end;
    3: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      FGDIPlusSettings.SmoothImages := NewValue = 1;
    end;
    4: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      FGDIPlusSettings.ProcessNullPath := NewValue = 1;
    end;
    5: if (NewValue >= 0) and (NewValue <= 255) then
    begin
      Result := 1;
      FGDIPlusSettings.MonoThreshold := NewValue;
    end;
    6: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      FGDIPlusSettings.DLLAllowPiggyBack := NewValue = 1;
    end;
    7: if (NewValue >= 0) and (NewValue <= 2) then
    begin
      Result := 1;
      FGDIPlusSettings.DLLStartup := TGDIPlusDLLStartup(NewValue);
    end;
    8: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      FGDIPlusSettings.DLLSuppressBackgroundThread := NewValue = 1;
    end;
    9: if (NewValue >= 0) and (NewValue <= 10) then
    begin
      Result := 1;
      FGDIPlusSettings.EnhanceThinLines := NewValue;
    end;

    // TGPSmoothingMode = (smInvalid = -1, smDefault, smHighSpeed, smHighQuality, smNone, smAntiAlias);
    10: if (NewValue >= 1) and (NewValue <= 4) then
    begin
      Result := 1;
      FGDIPlusSettings.SmoothingMode := NewValue;
    end;

    // TGPInterpolationMode = (imInvalid = -1, imDefault, imLowQuality, imHighQuality, imBilinear, imBicubic,
    // NearestNeighbor, imHighQualityBilinear, imHighQualityBicubic);
    11: if (NewValue >= 1) and (NewValue <= 7) then
    begin
      Result := 1;
      FGDIPlusSettings.InterpolationMode := NewValue;
    end;

    // TGPPixelOffsetMode = (poInvalid = -1, poDefault, poHighSpeed, poHighQuality, poNone, poHalf);
    12: if (NewValue >= 1) and (NewValue <= 4) then
    begin
      Result := 1;
      FGDIPlusSettings.PixelOffsetMode := NewValue;
    end;

  end;
end;

function TQuickPDF.GetDefaultPrinterName: WideString;
begin
  Result := DebenuPDFLibraryPrinting.GetDefaultPrinter;
end;

function TQuickPDF.GetFormFieldCaption(Index: Integer): WideString;
var
  Field: TPDFField;
begin
  Result := '';
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.GetCaption;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldCaptionEx(Index: Integer; StringType: Integer): WideString;
var
  Field: TPDFField;
begin
  Result := '';
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.GetCaptionEx(StringType);
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldDefaultValue(Index: Integer): WideString;
var
  Field: TPDFField;
begin
  Result := '';
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.DefaultValue;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.SplitPageText(Options: Integer): Integer;
begin
  Result := 1;
  FSelDoc.PageTree.SplitPageText(Options);
end;

function TQuickPDF.SetFormFieldCheckStyle(Index,
  CheckStyle, Position: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) and (CheckStyle >= 0) and (CheckStyle <= 8) and
    (Position >= 0) and (Position <= 2) then
  begin
    Field.SetCheckStyle(TPDFFormFieldCheckStyle(CheckStyle),
      TPDFFormFieldCheckPosition(Position));
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.AddFormFieldSub(Index: Integer; const SubName: WideString): Integer;
var
  Field: TPDFField;
  SubField: TPDFField;
  SubIndex: Integer;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) and (Field.FieldType = ftRadioButton) then
  begin
    SubIndex := Field.AddRadioButtonChild(SubName);
    if (SubIndex > 0) and (SubIndex <= Field.SubCount) then
      Result := $55000000 + Index * 256 + SubIndex;
    SubField := FindFormField(Result);
    if Assigned(SubField) then
    begin
      FSelDoc.PageTree.UseField(SubField);
      SubField.SetPageRef(SelectedPage, FSelDoc.PageTree.PageRef);
      if SubField.TempField then SubField.Free;
    end;
    if Field.TempField then Field.Free;
  end else
  if Assigned(Field) and (Field.FieldType = ftChoice) then
  begin
    Field.AddOpt(SubName);
  end;
end;

function TQuickPDF.GetOutlineOpenFile(OutlineID: Integer): WideString;
var
  Outline: TPDFIndRef;
begin
  Result := '';
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := WideString(FSelDoc.GetOutlineOpenFile(Outline));
  end;
end;

function TQuickPDF.GetOutlineWebLink(OutlineID: Integer): WideString;
var
  Outline: TPDFIndRef;
begin
  Result := '';
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := WideString(FSelDoc.GetOutlineWebLink(Outline));
  end;
end;

function TQuickPDF.SetFormFieldOptional(Index,
  OptionalContentGroupID: Integer): Integer;
var
  OCGRef: TPDFIndRef;
  Field: TPDFField;
begin
  Result := 0;
  OCGRef := ValidOCG(OptionalContentGroupID);
  if Assigned(OCGRef) then
  begin
    Field := FindFormField(Index);
    if Assigned(Field) then
    begin
      Result := 1;
      Field.SetOptional(OCGRef);
      if Field.TempField then Field.Free;
    end;
  end;
end;

function TQuickPDF.DrawDataMatrixSymbol(Left, Top, ModuleSize: Double;
  const Text: WideString; Encoding, SymbolSize, Options: Integer): Integer;
var
  PainterState: AnsiString;
begin
  Result := 0;
  if (not Assigned(FSelFont)) then AddStandardFont(4);
  if (Encoding = 1) and (SymbolSize >= 0) and (SymbolSize < 30) and
    (Options mod 100 >= 0) and (Options mod 100 <= 3) and
    (Options div 100 >= 0) and (Options div 100 <= 9) then
  begin
    PainterState := FSelDoc.PageTree.Painter.GetState;
    try
      Result := 1;

      if not (FSelDoc.FillSet) then
      begin
        SetFillColor(0, 0, 0);
        FSelDoc.FillSet := False;
      end;

      FSelDoc.PageTree.Painter.DrawDataMatrixSymbol(TranslateX(Left),
        TranslateY(Top), GetScale(ModuleSize), AnsiString(Text), Encoding, SymbolSize,
        Options);
    finally
      FSelDoc.PageTree.Painter.SetState(PainterState);
    end;
  end;
end;

function TQuickPDF.GetXFAFormFieldValue(
  const XFAFieldName: WideString): WideString;
begin
  if FSelDoc.HasFormData then
  begin
    if (Copy(XFAFieldName, 1, 7) = 'getxfa:') then
      Result := WideString(FSelDoc.AcroForm.GetXFA(AnsiString(Copy(XFAFieldName, 8, MaxInt))))
    else
      Result := FSelDoc.AcroForm.GetXFAFormFieldValue(AnsiString(XFAFieldName));
  end else
    Result := '';
end;

function TQuickPDF.SetXFAFormFieldBorderWidth(const XFAFieldName: WideString;
  BorderWidth: Double): Integer;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if FSelDoc.AcroForm.SetXFAFormFieldBorderWidth(AnsiString(XFAFieldName), GetScale(BorderWidth)) then
      Result := 1;
  end;
end;

function TQuickPDF.SetXFAFormFieldAccess(const XFAFieldName: WideString;
  NewAccess: Integer): Integer;
const
  AccessValues: array[1..4] of AnsiString = ('nonInteractive', 'open',
    'protected', 'readOnly');
begin
  Result := 0;
  if (NewAccess >= 1) and (NewAccess <= 4) and FSelDoc.HasFormData then
  begin
    if FSelDoc.AcroForm.SetXFAFormFieldAttribute(AnsiString(XFAFieldName),
      'access', AccessValues[NewAccess]) then
        Result := 1;
  end;
end;

function TQuickPDF.SetXFAFormFieldValue(const XFAFieldName,
  NewValue: WideString): Integer;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Copy(XFAFieldName, 1, 7) = 'setxfa:') then
    begin
      FSelDoc.AcroForm.SetXFA(AnsiString(Copy(XFAFieldName, 8, MaxInt)), AnsiString(NewValue));
      Result := 1;
    end else
    begin
      if FSelDoc.AcroForm.SetXFAFormFieldValue(AnsiString(XFAFieldName), NewValue) then
        Result := 1;
    end;
  end;
end;

function TQuickPDF.SetXFAFormFieldBorderColor(
  const XFAFieldName: WideString; Red, Green, Blue: Double): Integer;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if FSelDoc.AcroForm.SetXFAFormFieldBorderColor(AnsiString(XFAFieldName), Red, Green, Blue) then
      Result := 1;
  end;
end;

function TQuickPDF.SetXFAFormFieldBorderPresence(const XFAFieldName: WideString;
  NewPresence: Integer): Integer;
const
  PresenceValues: array[1..3] of AnsiString = ('visible', 'invisible', 'hidden');
begin
  Result := 0;
  if (NewPresence >= 1) and (NewPresence <= 3) and FSelDoc.HasFormData then
  begin
    if FSelDoc.AcroForm.SetXFAFormFieldBorderPresence(AnsiString(XFAFieldName),
      PresenceValues[NewPresence]) then Result := 1;
  end;
end;

function TQuickPDF.GetViewerPreferences(Option: Integer): Integer;
const
  VPOptions: array[1..16] of AnsiString = ('HideToolbar', 'HideMenubar',
    'HideWindowUI', 'FitWindow', 'CenterWindow', 'DisplayDocTitle',
    'NonFullScreenPageMode', 'Direction', 'ViewArea', 'ViewClip',
    'PrintArea', 'PrintClip', 'PrintScaling', 'Duplex', 'PickTrayByPDFSize',
    'NumCopies');
  Bool: array[0..1] of AnsiString = ('false', 'true');
  NonFull: array[0..3] of AnsiString = ('UseNone', 'UseOutlines', 'UseThumbs', 'UseOC');
  Direction: array[0..1] of AnsiString = ('L2R', 'R2L');
  Boundary: array[0..4] of AnsiString = ('MediaBox', 'CropBox', 'BleedBox',
    'TrimBox', 'ArtBox');
  PrintScaling: array[0..1] of AnsiString = ('None', 'AppDefault');
  Duplex: array[0..2] of AnsiString = ('Simplex', 'DuplexFlipShortEdge',
    'DuplexFlipLongEdge');
var
  O: TPDFObject;
  X: Integer;
begin
  Result := 0;
  if (Option >= 1) and (Option <= 16) then
  begin
    O := FSelDoc.GetViewerPreferences(VPOptions[Option]);

    case Option of
      1..6, 15:
      begin
        // HideToolbar to DisplayDocTitle and PickTrayByPDFSize
        if O is TPDFBoolean then
        begin
          if TPDFBoolean(O).AsBoolean then Result := 1;
        end;
      end;
      7:
      begin
        // NonFullScreenPageMode
        if O is TPDFName then
        begin
          for X := 0 to 3 do
          begin
            if TPDFName(O).Name = NonFull[X] then Result := X;
          end;
        end;
      end;
      8:
      begin
        // Direction
        if O is TPDFName then
        begin
          for X := 0 to 1 do
          begin
            if TPDFName(O).Name = Direction[X] then Result := X;
          end;
        end;
      end;
      9..12:
      begin
        // ViewArea to PrintClip
        if O is TPDFName then
        begin
          for X := 0 to 4 do
          begin
            if TPDFName(O).Name = Boundary[X] then Result := X;
          end;
        end;
      end;
      13:
      begin
        // PrintScaling
        if O is TPDFName then
        begin
          for X := 0 to 1 do
          begin
            if TPDFName(O).Name = PrintScaling[X] then Result := X;
          end;
        end;
      end;
      14:
      begin
        // Duplex
        if O is TPDFName then
        begin
          for X := 0 to 2 do
          begin
            if TPDFName(O).Name = Duplex[X] then Result := X;
          end;
        end;
      end;
      16:
      begin
        if O is TPDFNumeric then
        begin
          Result := TPDFNumeric(O).AsInteger;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.NewPostScriptXObject(const PS: WideString): Integer;
begin
  Result := IntCast(FSelDoc.NewPostScriptXObject(QPLTrim(AnsiString(PS)) + #10));
end;

function TQuickPDF.DrawPostScriptXObject(PSRef: Integer): Integer;
var
  PS: TPDFIndRef;
  PSName: AnsiString;
  PSRefObj: TObject;
begin
  Result := 0;
  PSRefObj := IntUncast(PSRef);
  if (PSRefObj is TPDFIndRef) then
  begin
    PS := TPDFIndRef(PSRefObj);
    PSName := MD5Print(MD5String(QPLIntToStr(PSRef)));
    FSelDoc.PageTree.UseXObject(PSName, PS);
    FSelDoc.PageTree.Painter.DrawPSXObject(PSName);
    Result := 1;
  end;
end;

function TQuickPDF.RetrieveCustomDataToFile(const Key,
  FileName: WideString; Location: Integer): Integer;
var
  FS: TQuickPDFWideFileStream;
  S: AnsiString;
  KeyA: AnsiString;
begin
  KeyA := AnsiString(Key);

  Result := 0;
  if QPLFileExists(FileName) then QPLDeleteFile(FileName);
  if not QPLFileExists(FileName) then
  begin
    S := RetrieveCustomDataToString(KeyA, Location);
    if Length(S) > 0 then
    begin
      try
        FS := QPLCreateFileStream(FileName, fmCreate);
        try
          FS.Write(S[1], Length(S));
          Result := 1;
        finally
          FS.Free;
        end;
      except
      end;
    end;
  end;
end;

function TQuickPDF.StoreCustomDataFromFile(const Key, FileName: WideString;
  Location, Options: Integer): Integer;
var
  FS: TQuickPDFWideFileStream;
  S: AnsiString;
  KeyA: AnsiString;
begin
  KeyA := AnsiString(Key);
  
  Result := 0;
  if QPLFileExists(FileName) then
  begin
    try
      FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
      try
        SetLength(S, FS.Size);
        FS.Read(S[1], Length(S));
        Result := StoreCustomDataFromString(KeyA, S, Location, Options);
      finally
        FS.Free;
      end;
    except
    end;
  end;
end;

function TQuickPDF.AddFileAttachment(const Title: WideString; EmbeddedFileID: Integer): Integer;
var
  EFS: TPDFIndRef;
  EFSObj: TObject;
begin
  Result := 0;
  EFSObj := IntUncast(EmbeddedFileID);
  if Title <> '' then
  begin
    if (EFSObj is TPDFIndRef) then
    begin
      EFS := TPDFIndRef(EFSObj);
      if FSelDoc.AttachFile(AnsiString(Title), EFS) then
      begin
        Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.AddLinkToEmbeddedFile(Left, Top, Width,
  Height: Double; EmbeddedFileID: Integer; const Title, Contents: WideString;
  IconType, Transparency: Integer): Integer;
var
  EFS: TPDFIndRef;
  EFSObj: TObject;
begin
  Result := 0;
  EFSObj := IntUncast(EmbeddedFileID);
  if (EFSObj is TPDFIndRef) then
  begin
    EFS := TPDFIndRef(EFSObj);
    FSelDoc.PageTree.AddLinkToEmbeddedFile(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), EFS,
      Title, Contents, IconType, Transparency);
    Result := 1;
  end;
end;

function TQuickPDF.AddEmbeddedFile(const FileName,
  MIMEType: WideString): Integer;
var
  EFS: TPDFIndRef;
begin
  Result := 0;
  if QPLFileExists(FileName) then
  begin
    EFS := FSelDoc.MakeEmbeddedFileSpec(FileName, AnsiString(MIMEType));
    if Assigned(EFS) then
    begin
      Result := IntCast(EFS);
    end;
  end;
end;

function TQuickPDF.SetCharWidth(CharCode, NewWidth: Integer): Integer;
begin
  if Assigned(FSelFont) then
  begin
    Result := 1;
    FSelFont.SetCharWidth(CharCode, NewWidth);
  end else
    Result := 0;
end;

function TQuickPDF.GetDocumentResourceList: WideString;
begin
  Result := WideString(FSelDoc.GetResourceList);
end;

function TQuickPDF.AddCJKFont(CJKFontID: Integer): Integer;
var
  Font: TPDFFont;
begin
  Result := 0;
  if ((CJKFontID >= 1) and (CJKFontID <= 8)) then
  begin
    Font := FSelDoc.NewCJKFont(CJKFontID);
    if Font <> nil then
    begin
      Result := IntCast(Font);
      SelectFont(Result);
    end;
  end;
end;

function TQuickPDF.MinTW: Double;
begin
  Result := 0;
  if Assigned(FSelFont) then
  begin
    if FSelFont.FontType = ftCJK then
      Result := GetTextWidth(#0'W')
    else
      Result := GetTextWidth('W');
  end;
end;

function TQuickPDF.SetPNGTransparencyColor(RedByte, GreenByte,
  BlueByte: Integer): Integer;
begin
  HasPNGTransparency := True;
  PNGTransparencyColor := (RedByte and $FF) + (GreenByte and $FF) shl 8 +
    (BlueByte and $FF) shl 16;
  Result := 1;
end;

function TQuickPDF.GetHTMLTextWidth(MaxWidth: Double;
  const HTMLText: WideString): Double;
var
  PainterState: AnsiString;
begin
  Result := 0;
  if MaxWidth > 0 then
  begin
    CheckFontSelection;
    PainterState := FSelDoc.PageTree.Painter.GetState;
    try
      FSelDoc.PageTree.Painter.Reset;
      if HTMLText <> '' then
      begin
        FSelDoc.SetHTMLFonts;
        Result := FSelDoc.PageTree.Painter.GetHTMLTextWidth(GetScale(MaxWidth), HTMLText);
        Result := Result * FSelDoc.Scale;
      end;
    finally
      FSelDoc.PageTree.Painter.SetState(PainterState);
    end;
  end;
end;

function TQuickPDF.GetHTMLTextLineCount(Width: Double;
  const HTMLText: WideString): Integer;
var
  PainterState: AnsiString;
begin
  Result := 0;
  if Width > 0 then
  begin
    CheckFontSelection;
    PainterState := FSelDoc.PageTree.Painter.GetState;
    try
      FSelDoc.PageTree.Painter.Reset;
      if HTMLText <> '' then
      begin
        FSelDoc.SetHTMLFonts;
        Result := FSelDoc.PageTree.Painter.GetHTMLTextLineCount(GetScale(Width), HTMLText);
      end;
    finally
      FSelDoc.PageTree.Painter.SetState(PainterState);
    end;
  end;
end;

function TQuickPDF.RenderPageToFile(DPI: Double; Page, Options: Integer;
  const FileName: WideString): Integer;
var
  OldPage: Integer;
  FS: TQuickPDFWideFileStream;
begin
  FLastRenderError := '';
  Result := 0;
  OldPage := SelectedPage;
  try
    if Page < 1 then Page := 1;
    if Page > PageCount then Page := PageCount;
    try
      FS := QPLCreateFileStream(FileName, fmCreate);
    except
      Result := 2;
      FS := nil;
    end;
    if Assigned(FS) then
    try
{$IFDEF QPL_CAIRO}
      if (FUseCairo) then
      begin
        if FSelDoc.PageTree.RenderPageToCairoStream(FRenderScale * DPI, Page, Options,
          FJPEGQuality, FCairoFileName, FS, FLastRenderError,
          FRenderCropType, FSelDoc.GetViewOCGList) then Result := 1;
      end else
{$ENDIF}
{$IFDEF QPL_DPLR}
      if (FUseDPLR and (Options <> 2) and (Options <> 3) and (Options <> 4) and
        (Options <> 8) and (Options <> 9)) then
      begin
        if FSelDoc.PageTree.RenderPageToDPLRStream(FRenderScale * DPI, Page, Options,
          FJPEGQuality, FGDIPlusSettings, FDPLRFileName, FS, FLastRenderError,
          FRenderCropType, FSelDoc.GetViewOCGList) then Result := 1;
      end else
{$ENDIF}
      begin
        if FSelDoc.PageTree.RenderPageToStream(FRenderScale * DPI, Page, Options,
          FJPEGQuality, FGDIPlusSettings, FS, FLastRenderError,
          FRenderCropType, FSelDoc.GetViewOCGList) then Result := 1;
      end;
    finally
      FS.Free;
    end;
  finally
    SelectPage(OldPage);
  end;
end;

function TQuickPDF.EncryptionAlgorithm: Integer;
begin
  Result := Ord(FSelDoc.EncryptionAlgorithm);
end;

function TQuickPDF.DARenderPageToStream(FileHandle, PageRef, Options: Integer;
  DPI: Double; Target: TStream): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  FLastRenderError := '';
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
    begin
{$IFDEF QPL_DPLR}
      if (FUseDPLR) then
      begin
        Link.Doc.RenderPageToDPLRStream(Page, Options, FRenderScale * DPI,
          FJPEGQuality, FDPLRFileName, Target, FLastRenderError, Link.Doc.GetViewOCGList);
        Result := 1;
      end else
{$ENDIF}
      begin
        Link.Doc.RenderPageToStream(Page, Options, FRenderScale * DPI,
          FJPEGQuality, FGDIPlusSettings, Target, FLastRenderError, Link.Doc.GetViewOCGList);
        Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.DARenderPageToFile(FileHandle, PageRef, Options: Integer;
  DPI: Double; const FileName: WideString): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
  FS: TQuickPDFWideFileStream;
begin
  FLastRenderError := '';
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
    begin
      try
        FS := QPLCreateFileStream(FileName, fmCreate);
      except
        Result := 2;
        FS := nil;
      end;
      if Assigned(FS) then
      try
{$IFDEF QPL_DPLR}
        if (FUseDPLR) then
        begin
          Link.Doc.RenderPageToDPLRStream(Page, Options, FRenderScale * DPI,
            FJPEGQuality, FDPLRFileName, FS, FLastRenderError, Link.Doc.GetViewOCGList);
        end else
{$ENDIF}
        begin
          Link.Doc.RenderPageToStream(Page, Options, FRenderScale * DPI,
            FJPEGQuality, FGDIPlusSettings, FS, FLastRenderError, Link.Doc.GetViewOCGList);
        end;
        Result := 1;
      finally
        FS.Free;
      end;
    end;
  end;
end;

function TQuickPDF.NewRGBAxialShader(const ShaderName: WideString; StartX,
  StartY, StartRed, StartGreen, StartBlue, EndX, EndY, EndRed, EndGreen,
  EndBlue: Double; Extend: Integer): Integer;
begin
  Result := 0;
  if (Assigned(FSelDoc.NewRGBAxialShader(AnsiString(ShaderName), TranslateX(StartX),
    TranslateY(StartY), StartRed, StartGreen, StartBlue, TranslateX(EndX),
    TranslateY(EndY), EndRed, EndGreen, EndBlue, Extend = 1))) then
  begin
    Result := 1;
  end;
end;

function TQuickPDF.SetFillShader(const ShaderName: WideString): Integer;
var
  Shader: TPDFShader;
begin
  Shader := FSelDoc.FindShader(AnsiString(ShaderName));
  if Assigned(Shader) then
  begin
    Result := 1;
    FSelDoc.PageTree.UsePattern(Shader.CSName, Shader.CS);
    FSelDoc.PageTree.Painter.SetFillShader(Shader.CSName);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetLineShader(const ShaderName: WideString): Integer;
var
  Shader: TPDFShader;
begin
  Shader := FSelDoc.FindShader(AnsiString(ShaderName));
  if Assigned(Shader) then
  begin
    Result := 1;
    FSelDoc.PageTree.UsePattern(Shader.CSName, Shader.CS);
    FSelDoc.PageTree.Painter.SetLineShader(Shader.CSName);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetTextShader(
  const ShaderName: WideString): Integer;
var
  Shader: TPDFShader;
begin
  if ((FSelDoc.PDFAMode <> 1) and (FSelDoc.PDFAMode <> 2)) then
  begin
    Shader := FSelDoc.FindShader(AnsiString(ShaderName));
    if Assigned(Shader) then
    begin
      Result := 1;
      FSelDoc.PageTree.UsePattern(Shader.CSName, Shader.CS);
      FSelDoc.PageTree.Painter.SetTextShader(Shader.CSName);
    end else
      Result := 0;
  end else
  begin
    Result := 0;
    FLastErrorCode := 601;
  end;
end;

function TQuickPDF.SignFile(const InputFileName, OpenPassword,
  SignatureFieldName, OutputFileName, PFXFileName, PFXPassword, Reason,
  Location, ContactInfo: WideString): Integer;
var
  Signer: TQuickPDFSigner;
  PFXPasswordA: AnsiString;
  ReasonA: AnsiString;
  LocationA: AnsiString;
  ContactInfoA: AnsiString;
begin
  PFXPasswordA := AnsiString(PFXPassword);
  ReasonA := AnsiString(Reason);
  LocationA := AnsiString(Location);
  ContactInfoA := AnsiString(ContactInfo);

  if SignatureFieldName = '' then
  begin
    Result := 12;
  end else
  if (InputFileName = OutputFileName) then
  begin
    Result := 10;
  end else
  begin
    Result := 0;
    Signer := TQuickPDFSigner.Create;
    try
      if (OutputFileName = '') then
      begin
        Signer.SetInPlace;
      end;
      case Signer.OpenPDF(InputFileName, OpenPassword) of
        srOkay:
        begin
          case Signer.OpenPFX(PFXFileName, PFXPasswordA, False) of
            srOkay:
            begin
              Signer.SelectField(SignatureFieldName, 1);
              Signer.SetSignatureProperty(spReason, ReasonA);
              Signer.SetSignatureProperty(spLocation, LocationA);
              Signer.SetSignatureProperty(spContactInfo, ContactInfoA);
              if Signer.AppendToFile(OutputFileName) then
              begin
                if Signer.ApplySignature then
                  Result := 1   // Success
                else
                  Result := 11; // Could not apply signature
              end else
                Result := 10;   // Could not write output file
            end;
            srFileNotFound: Result := 5;  // Certificate file not found
            srCannotRead: Result := 6;    // Certificate file is invalid
            srWrongPassword: Result := 7; // Incorrect certificate password
            srBadFormat: Result := 8;     // Unknown certificate format
            srNoPrivateKey: Result := 9;  // No private key found in certificate file
          end;
        end;
        srFileNotFound: Result := 2;  // Input PDF not found
        srCannotRead: Result := 3;    // Input PDF cannot be read
        srWrongPassword: Result := 4; // Input PDF password incorrect
      end;
    finally
      Signer.Free;
    end;
  end;
end;

function TQuickPDF.BeginPageUpdate: Integer;
begin
  FSelDoc.PageTree.Painter.BeginUpdate;
  Result := 1;
end;

function TQuickPDF.EndPageUpdate: Integer;
begin
  FSelDoc.PageTree.Painter.EndUpdate;
  Result := 1;
end;

function TQuickPDF.DARenderPageToDC(FileHandle, PageRef: Integer; DPI: Double; DC: HDC): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  FLastRenderError := '';
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
    begin
{$IFDEF QPL_CAIRO}
      if (FUseCairo) then
      begin
        Link.Doc.RenderPageToCairoDC(Page, FRenderScale * DPI, FJPEGQuality,
          FCairoFileName, DC, FLastRenderError, FRenderCropType, FRenderDCOffsetX,
          FRenderDCOffsetY, FRenderDCErasePage, Link.Doc.GetViewOCGList);
        Result := 1;
      end else
{$ENDIF}
{$IFDEF QPL_DPLR}
      if (FUseDPLR) then
      begin
        Link.Doc.RenderPageToDPLRDC(Page, FRenderScale * DPI, FJPEGQuality,
          FDPLRFileName, DC, FLastRenderError, FRenderCropType, FRenderDCOffsetX,
          FRenderDCOffsetY, FRenderDCErasePage, Link.Doc.GetViewOCGList);
        Result := 1;
      end else
{$ENDIF}
      begin
        Link.Doc.RenderPageToDC(Page, FRenderScale * DPI, FJPEGQuality,
          FGDIPlusSettings, DC, FLastRenderError, FRenderCropType, FRenderDCOffsetX,
          FRenderDCOffsetY, FRenderDCErasePage, Link.Doc.GetViewOCGList);
        Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.CreateRenderer: Integer;
begin
  DestroyRenderer;
  FSelDoc.PageTree.Renderer := TPDFRenderer.Create(FSelDoc.PageTree.RRenderFontCol);
  if Assigned(FSelDoc.PageTree.Renderer) then
  begin
    FSelDoc.PageTree.Renderer.DPI := -1;
    Result := 1;
  end
  else
    Result := 0;
end;

function TQuickPDF.DestroyRenderer: Integer;
begin
  if Assigned(FSelDoc.PageTree.Renderer) then
    FSelDoc.PageTree.Renderer.Free;
  FSelDoc.PageTree.Renderer := nil;
  Result := 1;
end;

function TQuickPDF.RenderPageToDCClip(DPI: Double; Page: Integer; DC: HDC;
  const Clip: AnsiString): Integer;
var
  OldPage: Integer;
begin
  FLastRenderError := '';
  OldPage := SelectedPage;
  try
    Result := 1;
    if Page < 1 then Page := 1;
    if Page > PageCount then Page := PageCount;
{$IFDEF QPL_CAIRO}
    if (FUseCairo) then
    begin
      if not FSelDoc.PageTree.RenderPageToCairoDC(FRenderScale * DPI, Page,
        FJPEGQuality, FCairoFileName, DC, FLastRenderError, FRenderCropType,
        FRenderDCOffsetX, FRenderDCOffsetY, FRenderDCErasePage, FSelDoc.GetViewOCGList) then Result := 0;
    end else
{$ENDIF}
{$IFDEF QPL_DPLR}
    if (FUseDPLR) then
    begin
      if not FSelDoc.PageTree.RenderPageToDPLRDC(FRenderScale * DPI, Page,
        FJPEGQuality, FGDIPlusSettings, FDPLRFileName, DC, FLastRenderError, FRenderCropType,
        FRenderDCOffsetX, FRenderDCOffsetY, FRenderDCErasePage, FSelDoc.GetViewOCGList,
        Clip) then Result := 0;
    end else
{$ENDIF}
    begin
      if not FSelDoc.PageTree.RenderPageToDC(FRenderScale * DPI, Page,
        FJPEGQuality, FGDIPlusSettings, DC, FLastRenderError, FRenderCropType,
        FRenderDCOffsetX, FRenderDCOffsetY, FRenderDCErasePage, FSelDoc.GetViewOCGList,
        Clip) then Result := 0;
    end;
  finally
    SelectPage(OldPage);
  end;
end;

function TQuickPDF.RenderPageToDC(DPI: Double; Page: Integer; DC: HDC): Integer;
var
  OldPage: Integer;
begin
  FLastRenderError := '';
  OldPage := SelectedPage;
  try
    Result := 1;
    if Page < 1 then Page := 1;
    if Page > PageCount then Page := PageCount;
{$IFDEF QPL_CAIRO}
    if (FUseCairo) then
    begin
      if not FSelDoc.PageTree.RenderPageToCairoDC(FRenderScale * DPI, Page,
        FJPEGQuality, FCairoFileName, DC, FLastRenderError, FRenderCropType,
        FRenderDCOffsetX, FRenderDCOffsetY, FRenderDCErasePage, FSelDoc.GetViewOCGList) then Result := 0;
    end else
{$ENDIF}
{$IFDEF QPL_DPLR}
    if (FUseDPLR) then
    begin
      if not FSelDoc.PageTree.RenderPageToDPLRDC(FRenderScale * DPI, Page,
        FJPEGQuality, FGDIPlusSettings, FDPLRFileName, DC, FLastRenderError, FRenderCropType,
        FRenderDCOffsetX, FRenderDCOffsetY, FRenderDCErasePage, FSelDoc.GetViewOCGList, '') then Result := 0;
    end else
{$ENDIF}
    begin
      if not FSelDoc.PageTree.RenderPageToDC(FRenderScale * DPI, Page,
        FJPEGQuality, FGDIPlusSettings, DC, FLastRenderError, FRenderCropType,
        FRenderDCOffsetX, FRenderDCOffsetY, FRenderDCErasePage, FSelDoc.GetViewOCGList, '') then Result := 0;
    end;
  finally
    SelectPage(OldPage);
  end;
end;

function TQuickPDF.AddU3DAnnotationFromFile(Left, Top, Width,
  Height: Double; const FileName: WideString; Options: Integer): Integer;
var
  FS: TQuickPDFWideFileStream;
begin
  Result := 0;
  if QPLFileExists(FileName) then
  try
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    try
      FSelDoc.PageTree.AddU3DAnnotation(TranslateX(Left), TranslateY(Top),
        GetScale(Width), GetScale(Height), FS, AnsiString(QPLExtractFileName(FileName)), Options);
      Result := 1;
    finally
      FS.Free;
    end;
  except
  end;
end;

function TQuickPDF.GetOutlineColor(OutlineID,
  ColorComponent: Integer): Double;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := FSelDoc.GetOutlineColor(Outline, ColorComponent);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetOutlineJavaScript(
  OutlineID: Integer): WideString;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := FSelDoc.GetOutlineJS(Outline);
  end else
  begin
    Result := '';
  end;
end;

function TQuickPDF.GetOutlineStyle(OutlineID: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    if (FSelDoc.OutlineIsItalic(Outline)) then
    begin
      Result := Result + 1;
    end;
    if (FSelDoc.OutlineIsBold(Outline)) then
    begin
      Result := Result + 2;
    end;
  end;
end;

function TQuickPDF.LastRenderError: WideString;
begin
  Result := WideString(FLastRenderError);
end;

function TQuickPDF.SetOptionalContentGroupPrintable(
  OptionalContentGroupID, Printable: Integer): Integer;
var
  OCGRef: TPDFIndRef;
begin
  OCGRef := ValidOCG(OptionalContentGroupID);
  if Assigned(OCGRef) then
  begin
    if FSelDoc.SetOCGPrintable(OCGRef, Printable) then
      Result := 1
    else
      Result := 0;
  end else
    Result := 0;
end;

function TQuickPDF.SetOpenActionDestinationFull(OpenPage, Zoom,
  DestType: Integer; Left, Top, Right, Bottom: Double): Integer;
begin
  Result := 0;
  if (Zoom >= 0) and (Zoom <= 6400) and (DestType >= 1) and (DestType <= 8) then
  begin
    if FSelDoc.SetOpenActionDestinationFull(OpenPage, Zoom, DestType,
      TranslateX(Left), TranslateY(Top), TranslateX(Right),
      TranslateY(Bottom)) then Result := 1;
  end;
end;

function TQuickPDF.SetOutlineDestinationFull(OutlineID, DestPage, Zoom,
  DestType: Integer; Left, Top, Right, Bottom: Double): Integer;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline) and (Zoom >= 0) and (Zoom <= 6400)) then
  begin
    FSelDoc.SetOutlineDestFull(Outline, DestPage, Zoom, DestType,
      TranslateX(Left), TranslateY(Top), TranslateX(Right),
      TranslateY(Bottom));
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetNamedDestination(
  const DestName: WideString): Integer;
begin
  Result := IntCast(FSelDoc.GetNamedDestination(AnsiString(DestName)));
end;

function TQuickPDF.EmbeddedFileCount: Integer;
begin
  Result := FSelDoc.EmbeddedFileCount;
end;

function TQuickPDF.GetEmbeddedFileStrProperty(Index, Tag: Integer): WideString;
begin
  Result := FSelDoc.GetEmbeddedFileStrProperty(Index, Tag);
end;

function TQuickPDF.GetEmbeddedFileID(Index: Integer): Integer;
begin
  Result := IntCast(FSelDoc.GetEmbeddedFile(Index));
end;

function TQuickPDF.GetEmbeddedFileIntProperty(Index, Tag: Integer): Integer;
begin
  Result := FSelDoc.GetEmbeddedFileIntProperty(Index, Tag);
end;

function TQuickPDF.GetEmbeddedFileContentToFile(Index: Integer; const FileName: WideString): Integer;
var
  FS: TQuickPDFWideFileStream;
  FileContent: AnsiString;
begin
  Result := 0;
  try
    FS := QPLCreateFileStream(FileName, fmCreate);
    try
      FileContent := GetEmbeddedFileContentToString(Index);
      if Length(FileContent) > 0 then
      begin
        FS.Write(FileContent[1], Length(FileContent));
        Result := 1;
      end;
    finally
      FS.Free;
    end;
  except
  end;
end;

function TQuickPDF.GetEmbeddedFileContentToString(Index: Integer): AnsiString;
begin
  Result := FSelDoc.GetEmbeddedFileContentToString(Index);
end;

function TQuickPDF.GetEmbeddedFileContentToStream(Index: Integer; OutStream: TStream): Integer;
var
  FileContent: AnsiString;
begin
  Result := 0;
  FileContent := FSelDoc.GetEmbeddedFileContentToString(Index);
  if Length(FileContent) > 0 then
  begin
    OutStream.Write(FileContent[1], Length(FileContent));
    Result := 1;
  end;
end;

function TQuickPDF.GetXFAFormFieldNames(const Delimiter: WideString): WideString;
begin
  if FSelDoc.HasFormData then
  begin
    Result := WideString(FSelDoc.AcroForm.GetXFAFormFieldNames(AnsiString(Delimiter)));
  end else
    Result := '';
end;

function TQuickPDF.GetXFAFormFieldCount: Integer;
var
  SL: TQuickPDFStringList;
begin
  Result := 0;

  if (FSelDoc.XFAFormFields = '') then
  begin
    FSelDoc.XFAFormFields := AnsiString(GetXFAFormFieldNames(#13#10));
  end;

  if (FSelDoc.XFAFormFields <> '') then
  begin
    SL := TQuickPDFStringList.Create;
    try
      SL.Text := FSelDoc.XFAFormFields;
      Result := SL.Count;
    finally
      SL.Free;
    end;
  end;
end;

function TQuickPDF.GetXFAFormFieldName(Index: Integer): WideString;
var
  SL: TQuickPDFStringList;
begin
  Result := '';
  if FSelDoc.XFAFormFields = '' then
    FSelDoc.XFAFormFields := AnsiString(GetXFAFormFieldNames(#13#10));
  SL := TQuickPDFStringList.Create;
  try
    SL.Text := FSelDoc.XFAFormFields;
    if (Index > 0) and (Index <= SL.Count) then
      Result := WideString(SL[Index - 1]);
  finally
    SL.Free;
  end;
end;

function TQuickPDF.GetFontObjectNumber: Integer;
begin
  if Assigned(FSelFont) then
    Result := FSelFont.IndRef.ObjNum
  else
    Result := 0;
end;

function TQuickPDF.CreateTable(RowCount,
  ColumnCount: Integer): Integer;
begin
  Result := IntCast(FSelDoc.CreateTable(RowCount, ColumnCount));
end;

function TQuickPDF.DrawTableRows(TableID: Integer; Left, Top,
  Height: Double; FirstRow, LastRow: Integer): Double;
var
  Table: TPDFTable;
  PainterState: AnsiString;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    CheckFontSelection;
    PainterState := FSelDoc.PageTree.Painter.GetState;
    try
      FSelDoc.PageTree.Painter.Reset;
      FSelDoc.PageTree.Painter.ClearTextFormatting;
      FSelDoc.SetHTMLFonts;
      Result := FSelDoc.DrawTableRows(Table, TranslateX(Left), TranslateY(Top),
        GetScale(Height), FirstRow, LastRow);

      // == Compatibility Mode 100 ==
      // In QPL 7.18 and earlier the result of DrawTableRows
      // was not multiplied by the co-ordinate system scaling factor.
      // Bug fixed in QPL 7.19 and later, with compatibility mode 100 turned on
      // the behaviour will be the same as QPL 7.18 and earlier.
      if not CheckCompatibility(100) then
      begin
        Result := Result * FSelDoc.Scale;
      end;
    finally
      FSelDoc.PageTree.Painter.SetState(PainterState);
    end;
  end;
end;

function TQuickPDF.SetTableCellAlignment(TableID, FirstRow, FirstColumn,
  LastRow, LastColumn, NewCellAlignment: Integer): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if (Table.SetCellAlignment(FirstRow, FirstColumn, LastRow, LastColumn,
      NewCellAlignment)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.SetTableCellBackgroundColor(TableID, FirstRow,
  FirstColumn, LastRow, LastColumn: Integer; Red, Green, Blue: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if (Table.SetBackgroundColor(FirstRow, FirstColumn, LastRow, LastColumn, Red,
      Green, Blue)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.SetTableCellBackgroundColorCMYK(TableID, FirstRow,
  FirstColumn, LastRow, LastColumn: Integer; C, M, Y,
  K: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if (Table.SetBackgroundColorCMYK(FirstRow, FirstColumn, LastRow, LastColumn,
      C, M, Y, K)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.SetTableCellBorderColor(TableID, FirstRow, FirstColumn,
  LastRow, LastColumn, BorderIndex: Integer; Red, Green, Blue: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetBorderColor(FirstRow, FirstColumn, LastRow, LastColumn,
      BorderIndex, Red, Green, Blue) then
        Result := 1;
  end;
end;

function TQuickPDF.SetTableCellBorderColorCMYK(TableID, FirstRow,
  FirstColumn, LastRow, LastColumn, BorderIndex: Integer; C, M, Y,
  K: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetBorderColorCMYK(FirstRow, FirstColumn, LastRow, LastColumn,
      BorderIndex, C, M, Y, K) then
        Result := 1;
  end;
end;

function TQuickPDF.SetTableCellBorderWidth(TableID, FirstRow, FirstColumn,
  LastRow, LastColumn, BorderIndex: Integer; NewWidth: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetBorderWidth(FirstRow, FirstColumn, LastRow, LastColumn,
      BorderIndex, GetScale(NewWidth)) then
        Result := 1;
  end;
end;

function TQuickPDF.SetTableCellContent(TableID, RowNumber,
  ColumnNumber: Integer; const HTMLText: WideString): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetCellContent(RowNumber, ColumnNumber, HTMLText) then
      Result := 1;
  end;
end;

function TQuickPDF.SetTableCellPadding(TableID, FirstRow, FirstColumn,
  LastRow, LastColumn, BorderIndex: Integer; NewPadding: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetBorderPadding(FirstRow, FirstColumn, LastRow, LastColumn,
      BorderIndex, GetScale(NewPadding)) then
        Result := 1;
  end;
end;

function TQuickPDF.SetTableColumnWidth(TableID, FirstColumn,
  LastColumn: Integer; NewWidth: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetColumnWidth(FirstColumn, LastColumn, GetScale(NewWidth)) then
      Result := 1;
  end;
end;

function TQuickPDF.SetTableRowHeight(TableID, FirstRow, LastRow: Integer;
  NewHeight: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetRowHeight(FirstRow, LastRow, GetScale(NewHeight)) then
      Result := 1;
  end;
end;

function TQuickPDF.MergeTableCells(TableID, FirstRow, FirstColumn,
  LastRow, LastColumn: Integer): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.MergeCells(FirstRow, FirstColumn, LastRow, LastColumn) then
      Result := 1;
  end;
end;

function TQuickPDF.SetTableBorderColor(TableID, BorderIndex: Integer;
  Red, Green, Blue: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetTableBorderColor(BorderIndex, Red, Green, Blue) then
      Result := 1;
  end;
end;

function TQuickPDF.SetTableBorderColorCMYK(TableID,
  BorderIndex: Integer; C, M, Y, K: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetTableBorderColorCMYK(BorderIndex, C, M, Y, K) then
      Result := 1;
  end;
end;

function TQuickPDF.SetTableBorderWidth(TableID, BorderIndex: Integer;
  NewWidth: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetTableBorderWidth(BorderIndex, GetScale(NewWidth)) then
      Result := 1;
  end;
end;

function TQuickPDF.SetTableCellTextColor(TableID, FirstRow,
  FirstColumn, LastRow, LastColumn: Integer; Red, Green,
  Blue: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetTextColor(FirstRow, FirstColumn, LastRow, LastColumn, Red,
      Green, Blue) then
        Result := 1;
  end;
end;

function TQuickPDF.SetTableCellTextColorCMYK(TableID, FirstRow,
  FirstColumn, LastRow, LastColumn: Integer; C, M, Y, K: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetTextColorCMYK(FirstRow, FirstColumn, LastRow, LastColumn,
      C, M, Y, K) then
        Result := 1;
  end;
end;

function TQuickPDF.SetTableCellTextSize(TableID, FirstRow, FirstColumn,
  LastRow, LastColumn: Integer; NewTextSize: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    if Table.SetTextSize(FirstRow, FirstColumn, LastRow, LastColumn,
      NewTextSize) then
        Result := 1;
  end;
end;

function TQuickPDF.GetTableLastDrawnRow(TableID: Integer): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
    Result := Table.GetLastDrawnRow;
end;

function TQuickPDF.GetTableCellDblProperty(TableID, RowNumber, ColumnNumber,
  Tag: Integer): Double;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    Result := Table.GetCellDblProperty(RowNumber, ColumnNumber, Tag);
    if ((Tag >= 101) and (Tag <= 104)) or ((Tag >= 130) and (Tag <= 137)) then
    begin
      Result := Result * FSelDoc.Scale;
      case Tag of
        101: if (FSelDoc.Origin = 2) or (FSelDoc.Origin = 3) then
             Result := PageWidth - Result;
        102: if (FSelDoc.Origin = 1) or (FSelDoc.Origin = 2) then
             Result := PageHeight - Result;
      end;
    end;
  end;
end;

function TQuickPDF.GetTableCellIntProperty(TableID, RowNumber, ColumnNumber,
  Tag: Integer): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
    Result := Table.GetCellIntProperty(RowNumber, ColumnNumber, Tag);
end;

function TQuickPDF.GetTableCellStrProperty(TableID, RowNumber, ColumnNumber,
  Tag: Integer): WideString;
var
  Table: TPDFTable;
begin
  Result := '';
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    Result := Table.GetCellStrProperty(RowNumber, ColumnNumber, Tag);
  end;
end;

function TQuickPDF.GetCanvasDC(CanvasWidth, CanvasHeight: Integer): Cardinal;
begin
  if Assigned(FMetafileCanvas) then
  begin
    FMetafileCanvas.Free;
    FMetafileCanvas := nil;
    FMetafileWidth := 0;
    FMetafileHeight := 0;
  end;

  if Assigned(FMetafile) then
  begin
    FMetafile.Free;
    FMetafile := nil;
  end;

  if (CanvasWidth > 0) and (CanvasHeight > 0) then
  begin
    FMetafile := TMetafile.Create;
    // Set the metafile to the same width and height for now
    FMetafile.Width := Max(CanvasWidth, CanvasHeight);
    FMetafile.Height := FMetafile.Width;
    FMetafileWidth := CanvasWidth;
    FMetafileHeight := CanvasHeight;

    FMetafileCanvas := TMetafileCanvas.Create(FMetafile, 0);

    Result := FMetafileCanvas.Handle;
  end else
    Result := 0;
end;

function TQuickPDF.GetCanvasDCEx(CanvasWidth, CanvasHeight: Integer; ReferenceDC: Cardinal): Cardinal;
begin
  if Assigned(FMetafileCanvas) then
  begin
    FMetafileCanvas.Free;
    FMetafileCanvas := nil;
    FMetafileWidth := 0;
    FMetafileHeight := 0;
  end;

  if Assigned(FMetafile) then
  begin
    FMetafile.Free;
    FMetafile := nil;
  end;

  if (CanvasWidth > 0) and (CanvasHeight > 0) then
  begin
    FMetafile := TMetafile.Create;
    // Set the metafile to the same width and height for now
    FMetafile.Width := Max(CanvasWidth, CanvasHeight);
    FMetafile.Height := FMetafile.Width;
    FMetafileWidth := CanvasWidth;
    FMetafileHeight := CanvasHeight;

    FMetafileCanvas := TMetafileCanvas.Create(FMetafile, ReferenceDC);

    Result := FMetafileCanvas.Handle;
  end else
    Result := 0;
end;

function TQuickPDF.LoadFromCanvasDC(DPI: Double; Options: Integer): Integer;
var
  Image: TPDFImage;
  MS: TMemoryStream;
begin
  Result := 0;
  if Assigned(FMetafileCanvas) and Assigned(FMetafile) then
  begin
    FMetafileCanvas.Free;
    FMetafileCanvas := nil;

    NewDocument;
    AddStandardFont(4);

    Result := 1;
    FSelDoc.PageTree.PageWidth := FMetafileWidth / DPI * 72;
    FSelDoc.PageTree.PageHeight := FMetafileHeight / DPI * 72;

    if (Options = -1) then
    begin
      MS := TMemoryStream.Create;
      FMetafile.SaveToStream(MS);
      MS.Seek(0, soFromBeginning);
    end else
    begin
      MS := nil;
    end;

    if Options = 2 then
    begin
      Options := 1;
      FSelDoc.CompressFonts := 1;
    end else
    if Options = 3 then
    begin
      Options := 1;
      FSelDoc.CompressFonts := 1;
      FSelDoc.SetNoEmbedFontList(FNoEmbedFontList);
    end;

    if (Options = -1) then
    begin
      Image := FSelDoc.NewImageFromStream(MS, Options, FSelDoc.CompressImages);
    end else
    begin
      Image := FSelDoc.NewImageFromMetafile(FMetafile, Options, FSelDoc.CompressImages);
    end;
    FSelDoc.ClearNoEmbedFontList;

    FSelDoc.PageTree.UseImage(Image);
    FSelDoc.PageTree.Painter.DrawImage(Image, 0,
      FSelDoc.PageTree.PageHeight,
      Max(FSelDoc.PageTree.PageWidth, FSelDoc.PageTree.PageHeight),
      Max(FSelDoc.PageTree.PageWidth, FSelDoc.PageTree.PageHeight));

    if (Options = -1) then
    begin
      MS.Free;
    end;

    FMetafile.Free;
    FMetafile := nil;
  end;
end;

function TQuickPDF.SetBaseURL(const NewBaseURL: WideString): Integer;
begin
  FSelDoc.SetBaseURL(AnsiString(NewBaseURL));
  Result := 1;
end;

function TQuickPDF.AddLGIDictToPage(
  const DictContent: WideString): Integer;
begin
  if FSelDoc.PageTree.AddLGIDict(AnsiString(DictContent)) then
    Result := 1
  else
    Result := 0;
end;

function TQuickPDF.DeletePageLGIDict(DictIndex: Integer): Integer;
begin
  if (FSelDoc.PageTree.DeleteLGIDict(DictIndex - 1)) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetPageLGIDictContent(
  DictIndex: Integer): WideString;
begin
  Result := WideString(FSelDoc.PageTree.GetLGIDictContent(DictIndex - 1));
end;

function TQuickPDF.GetPageLGIDictCount: Integer;
begin
  Result := FSelDoc.PageTree.GetLGIDictCount;
end;

function TQuickPDF.SetAnnotStrProperty(Index, Tag: Integer;
  const NewValue: WideString): Integer;
begin
  if FSelDoc.PageTree.Annots.SetStringProp(Index - 1, Tag, NewValue) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.ImportEMFFromFile(const FileName: WideString;
  FontOptions, GeneralOptions: Integer): Integer;
var
  FS: TQuickPDFWideFileStream;
begin
  Result := 0;
  if QPLFileExists(FileName) then
  try
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    try
      Result := ImportEMFFromStream(FS, FontOptions, GeneralOptions);
    finally
      FS.Free;
    end;
  except
  end;
end;

function TQuickPDF.DeleteAnnotation(Index: Integer): Integer;
begin
  if FSelDoc.PageTree.DeleteAnnotation(Index - 1) then
    Result := 1
  else
    Result := 0;
end;

function TQuickPDF.FontFamily: WideString;
begin
  if Assigned(FSelFont) then
    Result := WideString(FSelFont.FontFamily)
  else
    Result := '';
end;

function TQuickPDF.GetAnnotActionID(Index: Integer): Integer;
begin
  Result := IntCast(FSelDoc.PageTree.Annots.GetAnnotAction(Index - 1));
end;

function TQuickPDF.GetOutlineActionID(OutlineID: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := IntCast(FSelDoc.GetOutlineAction(Outline));
  end;
end;

function TQuickPDF.GetActionType(ActionID: Integer): WideString;
var
  Obj: TPDFObject;
  Action: TPDFDictionary;
begin
  Result := '';
  Action := ValidActionID(ActionID);
  if (Assigned(Action)) then
  begin
    Obj := Action.FindValueByKeyName('S', True);
    if (Obj is TPDFName) then
    begin
      Result := WideString(TPDFName(Obj).Name);
    end;
  end;
end;

function TQuickPDF.CloneOutlineAction(OutlineID: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    FSelDoc.CloneOutlineAction(Outline);
    Result := 1; 
  end;
end;

function TQuickPDF.AppendTableColumns(TableID,
  NewColumnCount: Integer): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if Assigned(Table) and (NewColumnCount >= 1) then
  begin
    Result := Table.InsertColumns(Table.GetColumnCount + 1, NewColumnCount);
  end;
end;

function TQuickPDF.AppendTableRows(TableID,
  NewRowCount: Integer): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if Assigned(Table) and (NewRowCount >= 1) then
  begin
    Result := Table.InsertRows(Table.GetRowCount + 1, NewRowCount);
  end;
end;

function TQuickPDF.GetTableColumnCount(TableID: Integer): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    Result := Table.GetColumnCount;
  end;
end;

function TQuickPDF.GetTableRowCount(TableID: Integer): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table)) then
  begin
    Result := Table.GetRowCount;
  end;
end;

function TQuickPDF.DAGetObjectCount(FileHandle: Integer): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
    Result := Link.Doc.ObjectCount;
end;

function TQuickPDF.DAGetObjectToString(FileHandle,
  ObjectNumber: Integer): AnsiString;
var
  Obj: TPDFObject;
  Link: TSmartPDFLink;
begin
  Result := '';
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Obj := Link.Doc.GetObject(ObjectNumber);
    if Assigned(Obj) then Result := Obj.Output;
  end;
end;

function TQuickPDF.GetObjectCount: Integer;
begin
  Result := FSelDoc.ObjCount;
end;

function TQuickPDF.GetObjectToString(ObjectNumber: Integer): AnsiString;
begin
  Result := FSelDoc.GetObjectSource(ObjectNumber);
end;

function TQuickPDF.DAOpenFromStream(InStream: TStream;
  const Password: WideString): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  if FUnlocked then
  begin
    Link := TSmartPDFLink.Create(InStream, Password);
    if Link.Okay then
    begin
      FOpenFiles.Add(Link);
      Result := IntCast(Link);
    end else
    begin
      if Link.OpenProblem = 'CouldNotOpen' then FLastErrorCode := 401;
      if Link.OpenProblem = 'BadPassword' then FLastErrorCode := 404;
      if Link.OpenProblem = 'BadStructure' then FLastErrorCode := 409;
      if Link.OpenProblem = 'FileNotFound' then FLastErrorCode := 411;      
      Link.Free;
    end;
  end;
end;

function TQuickPDF.DASaveToStream(FileHandle: Integer;
  OutStream: TStream): Integer;
var
  Link: TSmartPDFLink;
  Writer: TSmartPDFWriter;
  TempStruct: TPDFStructure;
  X: Integer;
  Obj: TPDFObject;
  OC: Integer;
begin
  Result := 0;
  FLastErrorCode := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    try
      Writer := TSmartPDFWriter.Create(OutStream);
      try
        Writer.New;
        TempStruct := TPDFStructure.Create;
        try
          FSubProgressScale := 1;
          FSubProgressOffset := 0;
          if (not Link.Doc.UserModDate) then
          begin
            Link.Doc.SetInformation('ModDate', WideString(GetPDFDateTime));
          end;
          OC := Link.Doc.ObjectCount;
          for X := 1 to OC do
          begin
            SubProgress(X * 100 div OC);
            Obj := Link.Doc.GetObject(X, TempStruct);
            if Assigned(Obj) then
              Writer.AddObject(X, Link.Doc.GetGenNum(X), Obj.Output)
            else
              Writer.AddObject(X, Link.Doc.GetGenNum(X), 'null');
            if TempStruct.ObjectCount > ObjCountLimit then
            begin
              TempStruct.Free;
              TempStruct := TPDFStructure.Create;
            end;
          end;
          EndProgress;
          Result := 1;
        finally
          TempStruct.Free;
        end;
        Link.Reader.FixTrailer;
        Writer.AddTrailer(Link.Reader.TrailerDict, 0, True);
        DACloseFile(FileHandle);
      finally
        Writer.Free;
      end;
    except
      FLastErrorCode := 403;
    end;
  end else
    FLastErrorCode := 501;
end;

function TQuickPDF.DAGetFormFieldCount(FileHandle: Integer): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    if Assigned(Link.Doc.AcroForm) then
    begin
      Result := Link.Doc.AcroForm.Count;
    end;
  end;
end;

function TQuickPDF.DAGetFormFieldTitle(FileHandle,
  FieldIndex: Integer): WideString;
var
  Link: TSmartPDFLink;
  Field: TPDFField;
begin
  Result := '';
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    if Assigned(Link.Doc.AcroForm) then
    begin
      if (FieldIndex >= 1) and (FieldIndex <= Link.Doc.AcroForm.Count) then
      begin
        Field := Link.Doc.AcroForm.Field[FieldIndex - 1];
        if Assigned(Field) then
        begin
          Result := Field.Title;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.DAGetFormFieldValue(FileHandle,
  FieldIndex: Integer): WideString;
var
  Link: TSmartPDFLink;
  Field: TPDFField;
begin
  Result := '';
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    if Assigned(Link.Doc.AcroForm) then
    begin
      if (FieldIndex >= 1) and (FieldIndex <= Link.Doc.AcroForm.Count) then
      begin
        Field := Link.Doc.AcroForm.Field[FieldIndex - 1];
        if Assigned(Field) then
          Result := Field.Value;
      end;
    end;
  end;
end;

function TQuickPDF.GetDocumentFileName: WideString;
begin
  Result := FSelDoc.SourceFileName;
end;

function TQuickPDF.NewChildFormField(Index: Integer;
  const Title: WideString; FieldType: Integer): Integer;
var
  ParentField: TPDFField;
  ChildField: TPDFField;
begin
  Result := 0;
  ParentField := FindFormField(Index);
  if Assigned(ParentField) then
  begin
    Result := NewFormField(Title, FieldType);
    ChildField := FindFormField(Result);
    if Assigned(ChildField) then
    begin
      ParentField.AddChild(ChildField);
      FSelDoc.AcroForm.DetachField(Result - 1);
    end else
      Result := 0;
  end;
end;

function TQuickPDF.SetPageBox(BoxType: Integer; Left, Top, Width,
  Height: Double): Integer;
const
  BoxNames: array[1..5] of AnsiString = ('MediaBox', 'CropBox', 'BleedBox',
    'TrimBox', 'ArtBox');
begin
  Result := 0;
  if (BoxType >= 1) and (BoxType <= 5) then
  begin
    FSelDoc.PageTree.SetPageBoxProperties(BoxNames[BoxType], TranslateX(Left),
      TranslateY(Top), GetScale(Width), GetScale(Height));
    Result := 1;
  end;
end;

function TQuickPDF.RemovePageBox(BoxType: Integer): Integer;
const
  BoxNames: array[1..5] of AnsiString = ('MediaBox', 'CropBox', 'BleedBox',
    'TrimBox', 'ArtBox');
begin
  Result := 0;
  if (BoxType >= 2) and (BoxType <= 5) then  // Option 1 disabled for now
  begin
  FSelDoc.PageTree.RemovePageBox(BoxNames[BoxType]);
    Result := 1;
  end;
end;

function TQuickPDF.PrintDocumentToFile(const PrinterName: WideString;
  StartPage, EndPage, Options: Integer;
  const FileName: WideString): Integer;
begin
  if (ValidPrinterName(PrinterName)) then
  begin
    FPrintToFile := FileName;
    try
      Result := PrintDocument(PrinterName, StartPage, EndPage, Options);
    finally
      FPrintToFile := '';
    end;
  end else
  begin
    Result := 0;
  end;
end;

// Tries to attach the specified annotation to the document's form
function TQuickPDF.AttachAnnotToForm(Index: Integer): Integer;
var
  AnnotRef: TPDFIndRef;
begin
  Result := 0;
  // Default return value of 0 indicates that the annotation could not
  // be attached to the form

  // Check if this is a widget annotation that is
  // not currently linked to the /AcroForm
  if IsAnnotFormField(Index) = 2 then
  begin
    AnnotRef := FSelDoc.PageTree.Annots.GetAnnotRef(Index - 1);
    if Assigned(AnnotRef) then
    begin
      // Try to attach the annotation to the form
      if FSelDoc.AcroForm.AttachField(AnnotRef) then
      begin
        // Annotation was attached
        Result := 1;
      end;
    end;
  end;
end;

// Checks if the specified annotation is attached to the document form
function TQuickPDF.IsAnnotFormField(Index: Integer): Integer;
var
  AnnotRef: TPDFIndRef;
  Field: TPDFField;
begin
  Result := 0;
  // Default return code of 0 indicates that the annotation cannot be
  // attached to the form because it is not a Widget annotation or
  // it is the child of another annotation or the document does not
  // have an /AcroForm entry

  if (FSelDoc.HasFormData) then
  begin
    // Check that the annotation's /Subtype entry is /Widget
    if FSelDoc.PageTree.Annots.AnnotSubtype(Index - 1) = 'Widget' then
    begin

      // Check that the annotation is not a child of another annotation
      if not FSelDoc.PageTree.Annots.AnnotHasParent(Index - 1) then
      begin

        // Get the annotation's indirect reference
        AnnotRef := FSelDoc.PageTree.Annots.GetAnnotRef(Index - 1);

        // Look for an existing field with this indirect reference
        Field := FSelDoc.AcroForm.FindFormField(AnnotRef);
        if Assigned(Field) then
        begin
          // An existing field exists - this annotation is attached to
          // the form
          Result := 1;
        end else
        begin
          // This annotation is not attached to the form
          Result := 2;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.IsTaggedPDF: Integer;
begin
  if (FSelDoc.IsTaggedPDF) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.RemoveEmbeddedFile(Index: Integer): Integer;
begin
  if FSelDoc.RemoveEmbeddedFile(Index) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.RequestPrinterStatus(
  StatusCommand: Integer): Integer;
begin
  Result := 0;
  case StatusCommand of
    100:
    begin
      FPrinterStatusNeeded := False;
      Result := 1;
    end;
    101:
    begin
      FPrinterStatusNeeded := True;
      Result := 1;
    end;
    102:
    begin
      if FPrinterStatusNeeded then
      begin
        Result := 1;
      end;
    end;
    103:
    begin
      FPrinterStartPaused := True;
      FPrinterStatusNeeded := True;
      Result := 1;
    end;
    104:
    begin
      FPrinterStartPaused := False;
      Result := 1;
    end;
    105:
    begin
      if FPrinterStartPaused then
      begin
        Result := 1;
      end;
    end;
    200..207, 300..314, 401..403:
    begin
      if FPrinterStatusNeeded then
      begin
        Result := GetPrintJobStatus(StatusCommand, FPrinterJobID,
          FPrinterJobPrinterName);
      end;
    end;
  end;
end;

function TQuickPDF.AddLinkToLocalFile(Left, Top, Width, Height: Double;
  const FileName: WideString; Options: Integer): Integer;
var
  lConvertedFileName: WideString;
begin
  lConvertedFileName := FSelDoc.PageTree.ConvertToFileSpecString(FileName);
  FSelDoc.PageTree.AddLinkToLocalFile(TranslateX(Left), TranslateY(Top),
    GetScale(Width), GetScale(Height), FileName, Options);
  Result := 1;
end;

function TQuickPDF.AddRelativeLinkToLocalFile(Left, Top, Width, Height: Double;
  const FileName: WideString; Options: Integer): Integer;
var
  lConvertedFileName: WideString;
begin
  lConvertedFileName := FSelDoc.PageTree.ConvertToFileSpecString(FileName, FSelDoc.SourceFileName);
  FSelDoc.PageTree.AddLinkToLocalFile(TranslateX(Left), TranslateY(Top),
    GetScale(Width), GetScale(Height), lConvertedFileName, Options);
  Result := 1;
end;

function TQuickPDF.SetCompatibility(CompatibilityItem,
  CompatibilityMode: Integer): Integer;
var
  ComKey: AnsiString;
  ComKeyPos: Integer;
begin
  Result := 0;

  if (CompatibilityItem >= 100) and (CompatibilityItem <= 199) then
  begin
    ComKey := '[' + QPLIntToStr(CompatibilityItem) + ']';
    ComKeyPos := QPLPos(ComKey, FCompatibility);

    if CompatibilityMode = 0 then
    begin
      Result := 1;
      if ComKeyPos > 0 then
      begin
        Delete(FCompatibility, ComKeyPos, Length(ComKey));
      end;
    end else
    if CompatibilityMode = 1 then
    begin
      Result := 1;
      if ComKeyPos = 0 then
      begin
        FCompatibility := FCompatibility + ComKey;
      end;
    end;
  end;
end;

function TQuickPDF.CheckCompatibility(
  CompatibilityItem: Integer): Boolean;
var
  ComKey: AnsiString;
begin
  ComKey := '[' + QPLIntToStr(CompatibilityItem) + ']';
  Result := QPLPos(ComKey, FCompatibility) > 0;
end;

procedure TQuickPDF.CheckFontSelection;
begin
  if (FSelFont = nil) or (FSelDoc.FontCount = 0) then AddStandardFont(4)
end;

function TQuickPDF.GetFontEncoding: Integer;
var
  EncodingName: AnsiString;
begin
  if Assigned(FSelFont) and (FSelFont is TPDFFont) then
  begin
    Result := 0;
    EncodingName := FSelFont.GetEncoding;
    if EncodingName = 'MacRomanEncoding' then Result := 1;
    if EncodingName = 'WinAnsiEncoding' then Result := 2;
    if EncodingName = 'MacExpertEncoding' then Result := 3;
    if EncodingName = '' then Result := 5;
  end else
    Result := 0;
end;

function TQuickPDF.RemoveGlobalJavaScript(
  const PackageName: WideString): Integer;
begin
  Result := 0;
  if (PackageName <> '') then
  begin
    if (FSelDoc.RemoveGlobalJavaScript(PackageName)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.SetEmbeddedFileStrProperty(Index, Tag: Integer;
  NewValue: WideString): Integer;
begin
  if FSelDoc.SetEmbeddedFileStrProperty(Index, Tag, NewValue) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetImagePageCountFromString(
  const Source: AnsiString): Integer;
var
  MS: TMemoryStream;
begin
  MS := TMemoryStream.Create;
  try
    MS.Write(Source[1], Length(Source));
    Result := CountImagePages(MS);
  finally
    MS.Free;
  end;
end;

function TQuickPDF.SetAnnotBorderColor(Index: Integer; Red, Green,
  Blue: Double): Integer;
begin
  if FSelDoc.PageTree.Annots.SetBorderColor(Index - 1, Red, Green, Blue) then
    Result := 1
  else
    Result := 0;
end;

function TQuickPDF.GetOptionalContentConfigCount: Integer;
begin
  Result := FSelDoc.GetOptionalContentConfigCount;
end;

function TQuickPDF.AddTextMarkupAnnotation(MarkupType: Integer; Left,
  Top, Width, Height: Double): Integer;
begin
  if ((MarkupType >= 1) and (MarkupType <= 4)) then
  begin
    FSelDoc.PageTree.AddTextMarkupAnnotation(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), MarkupType);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetAnnotQuadPoints(Index, QuadNumber,
  PointNumber: Integer): Double;
begin
  Result := FSelDoc.PageTree.Annots.GetAnnotQuadPoints(Index - 1,
    QuadNumber, PointNumber);
end;

function TQuickPDF.GetAnnotQuadCount(Index: Integer): Integer;
begin
  Result := FSelDoc.PageTree.Annots.GetAnnotQuadCount(Index - 1);
end;

function TQuickPDF.SetAnnotQuadPoints(Index, QuadNumber: Integer; X1,
  Y1, X2, Y2, X3, Y3, X4, Y4: Double): Integer;
begin
  if (QuadNumber >= 1) then
  begin
    FSelDoc.PageTree.Annots.SetAnnotQuadPoints(Index - 1, QuadNumber,
      TranslateX(X1), TranslateY(Y1), TranslateX(X2), TranslateY(Y2),
      TranslateX(X3), TranslateY(Y3), TranslateX(X4), TranslateY(Y4));
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetOptionalContentConfigState(
  OptionalContentConfigID, OptionalContentGroupID: Integer): Integer;
var
  OCGRef: TPDFIndRef;
begin
  OCGRef := ValidOCG(OptionalContentGroupID);
  if Assigned(OCGRef) then
  begin
    Result := FSelDoc.GetOptionalContentConfigState(OptionalContentConfigID,
      OCGRef);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetDocumentFileSize: Integer;
begin
  Result := FSelDoc.SourceFileSize;
end;

function TQuickPDF.GetAnnotDest(Index: Integer): Integer;
begin
  Result := IntCast(FSelDoc.PageTree.Annots.GetAnnotDest(Index - 1));
end;

function TQuickPDF.GetActionDest(ActionID: Integer): Integer;
var
  Obj: TPDFObject;
  Action: TPDFDictionary;
begin
  Result := 0;
  Action := ValidActionID(ActionID);
  if (Assigned(Action)) then
  begin
    Obj := Action.FindValueByKeyName('D', True);
    if Assigned(Obj) then
    begin
      Result := IntCast(Obj);
    end;
  end;
end;

function TQuickPDF.GetMaxObjectNumber: Integer;
begin
  Result := FSelDoc.MaxObjNum;
end;

function TQuickPDF.ImportEMFFromStream(InStream: TStream; FontOptions,
  GeneralOptions: Integer): Integer;
var
  Image: TPDFImage;
begin
  Result := 0;
  if GeneralOptions = 1 then
    FSelDoc.ImageGDIPlusSettings := FGDIPlusSettings;
  Image := FSelDoc.NewEMFFromStream(InStream, FontOptions, GeneralOptions);
  if Image <> nil then
  begin
    Result := IntCast(Image);
    FSelImage := Image;
  end;
end;

function TQuickPDF.DAGetAnnotationCount(FileHandle,
  PageRef: Integer): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
    begin
      Result := Link.Doc.GetAnnotationCount(Page);
    end;
  end;
end;

function TQuickPDF.ClearImage(ImageID: Integer): Integer;
var
  Image: TPDFImage;
begin
  Result := 0;
  Image := ValidImageID(ImageID);
  if (Assigned(Image) and FSelDoc.IsImage(Image)) then
  begin
    Image.ClearImage;
    Result := 1;
  end;
end;

function TQuickPDF.DASetPageBox(FileHandle, PageRef, BoxIndex: Integer; X1,
  Y1, X2, Y2: Double): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  if ((BoxIndex >= 1) and (BoxIndex <= 5)) then
  begin
    Link := ValidFileHandle(FileHandle);
    if Assigned(Link) then
    begin
      Page := ValidPageRef(Link, PageRef);
      if Assigned(Page) then
      begin
        Result := 1;
        Link.Doc.SetPageBox(Page, BoxIndex, X1, Y1, X2, Y2);
      end;
    end;
  end;
end;

function TQuickPDF.RemoveXFAEntries(Options: Integer): Integer;
begin
  if FSelDoc.HasFormData then
  begin

    if Assigned(FSelDoc.RootDict) then
      if Assigned(FSelDoc.RootDict.FindValueByKeyName('NeedsRendering')) then
        FSelDoc.RootDict.DeleteEntryByKeyName('NeedsRendering');

    if Assigned(FSelDoc.RootDict) then
      if Assigned(FSelDoc.RootDict.FindValueByKeyName('StructTreeRoot')) then
        FSelDoc.RootDict.DeleteEntryByKeyName('StructTreeRoot');

    if Assigned(FSelDoc.RootDict) then
      if Assigned(FSelDoc.RootDict.FindValueByKeyName('Extensions')) then
        FSelDoc.RootDict.DeleteEntryByKeyName('Extensions');

    Result := FSelDoc.AcroForm.RemoveXFAEntries(Options);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetTextExtractionWordGap(NewWordGap: Double): Integer;
begin
  FSelDoc.TextExtractOptions.WordGap := NewWordGap;
  Result := 1;
end;

function TQuickPDF.GetFormFieldActionID(Index: Integer;
  const TriggerEvent: WideString): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := IntCast(Field.GetAction(AnsiString(TriggerEvent)));
    if Field.TempField then
    begin
      Field.Free;
    end;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetActionURL(ActionID: Integer): WideString;
var
  Obj: TPDFObject;
  FileSpec: TQPLFileSpec;
  Action: TPDFDictionary;
begin
  Result := '';
  Action := ValidActionID(ActionID);
  if (Assigned(Action)) then
  begin
    Obj := Action.FindValueByKeyName('F', True);
    FileSpec := TQPLFileSpec.Create(Obj);
    try
      Result := FileSpec.GetURL;
    finally
      FileSpec.Free;
    end;
  end;
end;

function TQuickPDF.SetActionURL(ActionID: Integer;
  const NewURL: WideString): Integer;
var
  Obj: TPDFObject;
  FileSpec: TQPLFileSpec;
  Action: TPDFDictionary;
begin
  Action := ValidActionID(ActionID);
  if (Assigned(Action)) then
  begin
    Result := 1;
    Obj := Action.FindValueByKeyName('F', True);
    if (not Assigned(Obj)) then
    begin
      Obj := Action.Owner.NewDictionary;
      Action.Add('F', Obj);
    end;
    FileSpec := TQPLFileSpec.Create(Obj);
    try
      FileSpec.SetURL(NewURL);
    finally
      FileSpec.Free;
    end;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetOptionalContentConfigOrderCount(
  OptionalContentConfigID: Integer): Integer;
begin
  Result := FSelDoc.GetOptionalContentConfigOrderCount(
    OptionalContentConfigID);
end;

function TQuickPDF.GetOptionalContentConfigOrderItemID(
  OptionalContentConfigID, ItemIndex: Integer): Integer;
begin
  Result := IntCast(FSelDoc.GetOptionalContentConfigOrderItemOCG(
    OptionalContentConfigID, ItemIndex));
end;

function TQuickPDF.GetOptionalContentConfigOrderItemLabel(
  OptionalContentConfigID, ItemIndex: Integer): WideString;
begin
  Result := FSelDoc.GetOptionalContentConfigOrderItemLabel(
    OptionalContentConfigID, ItemIndex);
end;

function TQuickPDF.GetOptionalContentConfigOrderItemLevel(
  OptionalContentConfigID, ItemIndex: Integer): Integer;
begin
  Result := FSelDoc.GetOptionalContentConfigOrderItemLevel(
    OptionalContentConfigID, ItemIndex);
end;

function TQuickPDF.GetOptionalContentConfigOrderItemType(
  OptionalContentConfigID, ItemIndex: Integer): Integer;
begin
  Result := FSelDoc.GetOptionalContentConfigOrderItemType(
    OptionalContentConfigID, ItemIndex);
end;

function TQuickPDF.GetInstalledFontsByCharset(CharsetIndex,
  Options: Integer): WideString;
const
  CharSets: array[1..19] of Integer = (ANSI_CHARSET, DEFAULT_CHARSET,
    SYMBOL_CHARSET, SHIFTJIS_CHARSET, HANGEUL_CHARSET, GB2312_CHARSET,
    CHINESEBIG5_CHARSET, OEM_CHARSET, JOHAB_CHARSET, HEBREW_CHARSET,
    ARABIC_CHARSET, GREEK_CHARSET, TURKISH_CHARSET, VIETNAMESE_CHARSET,
    THAI_CHARSET, EASTEUROPE_CHARSET, RUSSIAN_CHARSET, MAC_CHARSET,
    BALTIC_CHARSET);
var
  X: Integer;
  FontList: TQuickPDFStringList;
  ThisFont: AnsiString;
begin
  Result := '';
  if ((CharsetIndex >= 1) and (CharsetIndex <= 19)) then
  begin
    FontList := ScreenFonts(CharSets[CharsetIndex]);
    for X := 0 to FontList.Count - 1 do
    begin
      ThisFont := FontList[X];
      if (Options = 0) then
      begin
        ThisFont := QPLStringReplace(ThisFont, '\', '\\', [rfReplaceAll]);
        ThisFont := QPLStringReplace(ThisFont, '"', '\"', [rfReplaceAll]);
        if (X < (FontList.Count - 1)) then
        begin
          Result := Result + '"' + WideString(ThisFont) + '",';
        end else
        begin
          Result := Result + '"' + WideString(ThisFont) + '"';
        end;
      end else
      if (Options = 1) then
      begin
        Result := Result + WideString(ThisFont) + #13#10;
      end;
    end;
  end;
end;

function TQuickPDF.GetInstalledFontsByCodePage(CodePage,
  Options: Integer): WideString;
var
  CharsetIndex: Integer;
begin
  case CodePage of
    0: CharsetIndex := 1;      // ANSI_CHARSET
    437: CharsetIndex := 8;    // OEM_CHARSET
    850: CharsetIndex := 8;    // OEM_CHARSET
    852: CharsetIndex := 8;    // OEM_CHARSET
    874: CharsetIndex := 15;   // THAI_CHARSET
    932: CharsetIndex := 4;    // SHIFTJIS_CHARSET
    936: CharsetIndex := 6;    // GB2312_CHARSET
    949: CharsetIndex := 5;    // HANGEUL_CHARSET
    950: CharsetIndex := 7;    // CHINESEBIG5_CHARSET
    1250: CharsetIndex := 16;  // EASTEUROPE_CHARSET
    1251: CharsetIndex := 17;  // RUSSIAN_CHARSET
    1252: CharsetIndex := 1;   // ANSI_CHARSET
    1253: CharsetIndex := 12;  // GREEK_CHARSET
    1254: CharsetIndex := 13;  // TURKISH_CHARSET
    1255: CharsetIndex := 10;  // HEBREW_CHARSET
    1256: CharsetIndex := 11;  // ARABIC_CHARSET
    1257: CharsetIndex := 19;  // BALTIC_CHARSET
    1258: CharsetIndex := 14;  // VIETNAMESE_CHARSET
    1361: CharsetIndex := 9;   // JOHAB_CHARSET
  else
    CharsetIndex := 0;
  end;
  Result := GetInstalledFontsByCharset(CharsetIndex, Options);
end;

function TQuickPDF.SetImageResolution(Horizontal, Vertical,
  Units: Integer): Integer;
begin
  if Assigned(FSelImage) then
  begin
    Result := 1;
    FSelImage.HorizontalDPI := Horizontal;
    FSelImage.VerticalDPI := Vertical;
    FSelImage.DPIUnits := Units;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetOutlineRemoteDestination(OutlineID: Integer;
  const FileName: WideString; OpenPage, Zoom, DestType: Integer; PntLeft,
  PntTop, PntRight, PntBottom: Double; NewWindow: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    FSelDoc.SetOutlineRemoteDestination(Outline, AnsiString(FileName),
      OpenPage, Zoom, DestType, PntLeft, PntTop, PntRight, PntBottom,
      NewWindow = 1);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetRenderDCOffset(NewOffsetX,
  NewOffsetY: Integer): Integer;
begin
  FRenderDCOffsetX := NewOffsetX;
  FRenderDCOffsetY := NewOffsetY;
  Result := 1;
end;

function TQuickPDF.SetOverprint(StrokingOverprint, OtherOverprint,
  OverprintMode: Integer): Integer;
begin
  if ((StrokingOverprint >= 0) and (StrokingOverprint <= 1) and
      (OtherOverprint >= 0) and (OtherOverprint <= 1) and
      (OverprintMode >= 0) and (OverprintMode <= 1)) then
  begin
    FSelDoc.AddOverprint(StrokingOverprint = 1,
      OtherOverprint = 1, OverprintMode);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.CompareOutlines(FirstOutlineID,
  SecondOutlineID: Integer): Integer;
var
  FirstOutline: TPDFIndRef;
  SecondOutline: TPDFIndRef;
begin
  Result := 0;
  FirstOutline := ValidOutlineID(FirstOutlineID);
  SecondOutline := ValidOutlineID(SecondOutlineID);
  if (Assigned(FirstOutline) and Assigned(SecondOutline)) then
  begin
    if ((FirstOutline.ObjNum = SecondOutline.ObjNum) and
      (FirstOutline.GenNum = SecondOutline.GenNum)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.GetOutlineObjectNumber(OutlineID: Integer): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    Result := Outline.ObjNum;
  end;
end;

function TQuickPDF.NewDestination(DestPage, Zoom, DestType: Integer; Left,
  Top, Right, Bottom: Double): Integer;
var
  DestArray: TPDFArray;
  TargetPage: TPDFIndRef;
begin
  Result := 0;
  if ((DestType >= 1) and (DestType <= 8)) then
  begin
    TargetPage := FSelDoc.PageTree.CreatePageRef(DestPage);

    if Assigned(TargetPage) then
    begin
      DestArray := FSelDoc.CreateDestination(TargetPage, Zoom, DestType,
        TranslateX(Left), TranslateY(Top), TranslateX(Right), TranslateY(Bottom),
        True);
      Result := IntCast(DestArray);
    end;
  end;
end;

function TQuickPDF.AddLinkToDestination(Left, Top, Width, Height: Double;
  DestID, Options: Integer): Integer;
var
  Dest: TPDFArray;
begin
  Result := 0;
  Dest := GetDestArray(DestID);
  if (Assigned(Dest)) then
  begin
    FSelDoc.PageTree.AddLinkToDestination(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), Dest, Options);
    Result := 1;
  end;
end;

function TQuickPDF.NewNamedDestination(const DestName: WideString;
  DestID: Integer): Integer;
var
  Dest: TPDFArray;
begin
  Result := 0;
  Dest := GetDestArray(DestID);
  if (Assigned(Dest)) then
  begin
    if FSelDoc.NewNamedDestination(AnsiString(DestName), Dest) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.GetDestName(DestID: Integer): WideString;
var
  Obj: TPDFObject;
  VCLObj: TObject;
begin
  Result := '';
  VCLObj := IntUncast(DestID);
  if (VCLObj is TPDFObject) then
  begin
    Obj := TPDFObject(VCLObj);
    if (Obj is TPDFName) then
    begin
      Result := WideString(TPDFName(Obj).Name);
    end else
    if (Obj is TPDFString) then
    begin
      Result := WideString(TPDFString(Obj).AsString);
    end;
  end;
end;

function TQuickPDF.SetOutlineNamedDestination(OutlineID: Integer;
  const DestName: WideString): Integer;
var
  Outline: TPDFIndRef;
begin
  Result := 0;
  Outline := ValidOutlineID(OutlineID);
  if (Assigned(Outline)) then
  begin
    FSelDoc.SetOutlineNamedDest(Outline, AnsiString(DestName));
    Result := 1;
  end;
end;

function TQuickPDF.GetRenderScale: Double;
begin
  Result := FRenderScale;
end;

function TQuickPDF.SetRenderScale(NewScale: Double): Integer;
begin
  FRenderScale := NewScale;
  Result := 1;
end;

function TQuickPDF.SetFindImagesMode(NewFindImagesMode: Integer): Integer;
begin
  if (NewFindImagesMode >= 1) and (NewFindImagesMode <= 4) then
  begin
    FFindImagesMode := NewFindImagesMode;
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.NoEmbedFontListAdd(const FontName: WideString): Integer;
var
  FontNameA: AnsiString;
begin
  FontNameA := AnsiString(FontName);
  if FNoEmbedFontList.IndexOf(FontNameA) < 0 then
  begin
    FNoEmbedFontList.Add(FontNameA);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.NoEmbedFontListCount: Integer;
begin
  Result := FNoEmbedFontList.Count;
end;

function TQuickPDF.NoEmbedFontListGet(Index: Integer): WideString;
begin
  if ((Index >= 1) and (Index <= FNoEmbedFontList.Count)) then
  begin
    Result := WideString(FNoEmbedFontList[Index - 1]);
  end else
  begin
    Result := '';
  end;
end;

function TQuickPDF.NoEmbedFontListRemoveIndex(Index: Integer): Integer;
begin
  if ((Index >= 1) and (Index <= FNoEmbedFontList.Count)) then
  begin
    FNoEmbedFontList.Delete(Index - 1);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.NoEmbedFontListRemoveName(
  const FontName: WideString): Integer;
var
  Index: Integer;
  FontNameA: AnsiString;
begin
  FontNameA := AnsiString(FontName);
  Index := FNoEmbedFontList.IndexOf(FontNameA);
  if (Index >= 0) then
  begin
    FNoEmbedFontList.Delete(Index);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.NoEmbedFontListRemoveAll: Integer;
begin
  FNoEmbedFontList.Clear;
  Result := 1;
end;

function TQuickPDF.NewPageFromCanvasDC(DPI: Double;
  Options: Integer): Integer;
var
  Image: TPDFImage;
  MS: TMemoryStream;
begin
  Result := 0;
  if Assigned(FMetafileCanvas) and Assigned(FMetafile) then
  begin
    FMetafileCanvas.Free;
    FMetafileCanvas := nil;

    if (DPI > 1000000) then
      DPI := DPI / 1000000;

    NewPage;

    Result := 1;
    FSelDoc.PageTree.PageWidth := FMetafileWidth / DPI * 72;
    FSelDoc.PageTree.PageHeight := FMetafileHeight / DPI * 72;

    if (Options = -1) then
    begin
      MS := TMemoryStream.Create;
      FMetafile.SaveToStream(MS);
      MS.Seek(0, soFromBeginning);
    end else
    begin
      MS := nil;
    end;

    if Options = 2 then
    begin
      Options := 1;
      FSelDoc.CompressFonts := 1;
    end else
    if Options = 3 then
    begin
      Options := 1;
      FSelDoc.CompressFonts := 1;
      FSelDoc.SetNoEmbedFontList(FNoEmbedFontList);
    end else
    if Options = 4 then
    begin
      Options := 1;
      FSelDoc.CompressFonts := 1;
      FSelDoc.UseExistingFonts := 1;
      FSelDoc.SetNoEmbedFontList(FNoEmbedFontList);
    end;

    if (Options = -1) then
    begin
      Image := FSelDoc.NewImageFromStream(MS, Options, FSelDoc.CompressImages);
    end else
    begin
      Image := FSelDoc.NewImageFromMetafile(FMetafile, Options, FSelDoc.CompressImages);
    end;

    FSelDoc.ClearNoEmbedFontList;

    FSelDoc.PageTree.UseImage(Image);
    FSelDoc.PageTree.Painter.DrawImage(Image, 0,
      FSelDoc.PageTree.PageHeight,
      Max(FSelDoc.PageTree.PageWidth, FSelDoc.PageTree.PageHeight),
      Max(FSelDoc.PageTree.PageWidth, FSelDoc.PageTree.PageHeight));

    if (Options = -1) then
    begin
      MS.Free;
    end;

    FMetafile.Free;
    FMetafile := nil;
  end;
end;

function TQuickPDF.SaveImageToString: AnsiString;
var
  MS: TMemoryStream;
begin
  Result := '';
  if Assigned(FSelImage) then
  begin
    MS := TMemoryStream.Create;
    try
      if FSelImage.SaveToStream(MS) then
      begin
        MS.Seek(0, soFromBeginning);
        SetLength(Result, MS.Size);
        if (Length(Result) > 0) then
        begin
          MS.Read(Result[1], Length(Result));
        end;
      end;
    finally
      MS.Free;
    end;
  end;
end;

function TQuickPDF.DAGetPageBox(FileHandle, PageRef, BoxIndex,
  Dimension: Integer): Double;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
  D: TPDFDimension;
begin
  Result := 0;
  if ((BoxIndex >= 1) and (BoxIndex <= 5) and (Dimension >= 0) and
    (Dimension <= 5)) then
  begin
    Link := ValidFileHandle(FileHandle);
    if Assigned(Link) then
    begin
      Page := ValidPageRef(Link, PageRef);
      if Assigned(Page) then
      begin
        D := TPDFDimension(Dimension);
        Result := Link.Doc.GetPageBox(Page, BoxIndex, D);
      end;
    end;
  end;
end;

function TQuickPDF.DAHasPageBox(FileHandle, PageRef,
  BoxIndex: Integer): Integer;
var
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  if ((BoxIndex >= 1) and (BoxIndex <= 5)) then
  begin
    Link := ValidFileHandle(FileHandle);
    if Assigned(Link) then
    begin
      Page := ValidPageRef(Link, PageRef);
      if Assigned(Page) then
      begin
        if (Link.Doc.HasPageBox(Page, BoxIndex)) then
        begin
          Result := 1;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.DADrawRotatedCapturedPage(FileHandle, DACaptureID,
  DestPageRef: Integer; PntLeft, PntBottom, PntWidth, PntHeight,
  Angle: Double): Integer;
var
  Link: TSmartPDFLink;
  DestPage: TPDFIndRef;
  CapturePageRef: TPDFIndRef;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    DestPage := ValidPageRef(Link, DestPageRef);
    if Assigned(DestPage) then
    begin
      CapturePageRef := ValidDACaptureID(DACaptureID);
      if Assigned(CapturePageRef) then
      begin
        Result := 1;
        Link.Doc.DrawRotatedCapturedPage(DestPage, CapturePageRef,
          PntLeft, PntBottom, PntWidth, PntHeight, Angle);
      end;
    end;
  end;
end;

function TQuickPDF.GetFormFieldNoExport(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        if Field.NoExport then
          Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.GetFormFieldRequired(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        if Field.Required then
          Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.SetFormFieldNoExport(Index, NoExport: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Result := 1;
        Field.NoExport := NoExport <> 0;
      end;
    end;
  end;
end;

function TQuickPDF.SetFormFieldRequired(Index, Required: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Result := 1;
        Field.Required := Required <> 0;
      end;
    end;
  end;
end;

function TQuickPDF.GetDestArray(DestID: Integer): TPDFArray;
var
  VCLObj: TObject;
  Obj: TPDFObject;
begin
  Result := nil;
  VCLObj := IntUncast(DestID);
  if (VCLObj is TPDFObject) then
  begin
    Obj := TPDFObject(VCLObj);
    if (Obj is TPDFIndRef) then
    begin
      Obj := TPDFIndRef(Obj).Obj;
    end;
    if (Obj is TPDFArray) then
    begin
      Result := TPDFArray(Obj);
    end else
    if (Obj is TPDFDictionary) then
    begin
      Obj := TPDFDictionary(Obj).FindValueByKeyName('D', True);
      if (Obj is TPDFArray) then
      begin
        Result := TPDFArray(Obj);
      end;
    end else
    if (Obj is TPDFString) then
    begin
      Obj := FSelDoc.GetNamedDestination(TPDFString(Obj).AsString);
      if (Obj is TPDFIndRef) then
      begin
        Obj := TPDFIndRef(Obj).Obj;
      end;
      if (Obj is TPDFArray) then
      begin
        Result := TPDFArray(Obj);
      end else
      if (Obj is TPDFDictionary) then
      begin
        Obj := TPDFDictionary(Obj).FindValueByKeyName('D', True);
        if (Obj is TPDFArray) then
        begin
          Result := TPDFArray(Obj);
        end;
      end;
    end else
    if (Obj is TPDFName) then
    begin
      Obj := FSelDoc.GetNamedDestination(TPDFName(Obj).Name);
      if (Obj is TPDFArray) then
      begin
        Result := TPDFArray(Obj);
      end else
      if (Obj is TPDFDictionary) then
      begin
        Obj := TPDFDictionary(Obj).FindValueByKeyName('D', True);
        if (Obj is TPDFArray) then
        begin
          Result := TPDFArray(Obj);
        end;
      end;
    end;
  end;
end;

function TQuickPDF.SetFormFieldChoiceType(Index, ChoiceType: Integer): Integer;
var
  Count: Integer;
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    Count := FSelDoc.AcroForm.Count;
    if (Index > 0) and (Index <= Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        if Field.FieldType = ftChoice then
        begin
          if ChoiceType = 1 then
          begin
            Field.Flags := Field.Flags and (not $260000);
            Result := 1;
          end;
          if ChoiceType = 2 then
          begin
            Field.Flags := (Field.Flags and (not $240000)) or $20000;
            Result := 1;
          end;
          if ChoiceType = 3 then
          begin
            Field.Flags := (Field.Flags and (not $60000)) or $200000;
            Result := 1;
          end;
          if ChoiceType = 4 then
          begin
            Field.Flags := (Field.Flags and (not $200000)) or $60000;
            Result := 1;
          end;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.SetAnnotBorderStyle(Index: Integer; Width: Double;
  Style: Integer; DashOn, DashOff: Double): Integer;
const
  StyleKeys: array[0..4] of AnsiString = ('S', 'D', 'B', 'I', 'U');
begin
  if Style > 4 then Style := 0;
  if Style < 0 then Style := 0;
  if (FSelDoc.PageTree.Annots.SetBorderStyle(Index - 1, GetScale(Width),
    StyleKeys[Style], GetScale(DashOn), GetScale(DashOff))) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.DAEmbedFileStreams(FileHandle: Integer;
  const RootPath: WideString): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Link.Doc.EmbedFileStreams(RootPath);
    Result := 1;
  end;
end;

function TQuickPDF.RemoveCustomInformation(const Key: WideString): Integer;
begin
  FSelDoc.RemoveInfo(AnsiString(Key));
  Result := 1;
end;

function TQuickPDF.NormalizePage(NormalizeOptions: Integer): Integer;
var
  OldWidth: Double;
  OldHeight: Double;
  OldRotation: Integer;
  OldOrigin: Integer;
  OldScale: Double;
  NewWidth: Double;
  NewHeight: Double;
  CropXOffset: Double;
  CropYOffset: Double;
  CropWidth: Double;
  CropHeight: Double;
  Transform: AnsiString;
  AnnotIndex: Integer;
  AnnotRect: TPDFArray;
  PDFRect: TPDFRectangle;
  AnnotLeft: Double;
  AnnotTop: Double;
  AnnotRight: Double;
  AnnotBottom: Double;
  AnnotRotation: Integer;
  Balancer: TPDFContentStreamStackBalancer;
  CS: AnsiString;
  Obj: TPDFObject;
  Dict: TPDFDictionary;
  I: Integer;

  procedure ResetMatrixEntries(Obj: TPDFObject; Rotation: Integer);
  const
    R: Array[1..16] of Integer =
      (  1,  0,  0,  1,      // 0
         0, -1,  1,  0,      // 90
        -1,  0,  0, -1,      // 180
         0,  1, -1,  0       // 270
      );
  var
    Offset: Integer;
    A: TPDFArray;
  begin
    Offset := (((Rotation + 360) mod 360) div 90) * 4;

    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 6) then
    begin
      A := TPDFArray(Obj);
      if (A.Item[0] is TPDFNumeric) then TPDFNumeric(A.Item[0]).SetTo(R[Offset + 1]);
      if (A.Item[1] is TPDFNumeric) then TPDFNumeric(A.Item[1]).SetTo(R[Offset + 2]);
      if (A.Item[2] is TPDFNumeric) then TPDFNumeric(A.Item[2]).SetTo(R[Offset + 3]);
      if (A.Item[3] is TPDFNumeric) then TPDFNumeric(A.Item[3]).SetTo(R[Offset + 4]);
    end;
  end;

begin
  Result := 0;
  if ((NormalizeOptions >= 0) and (NormalizeOptions <= 3)) then
  begin

    // Reset the origin and scale
    OldOrigin := FSelDoc.Origin;
	  OldScale := FSelDoc.Scale;
    FSelDoc.Origin := 0;
	  FSelDoc.Scale := 1;

    // Get the CropBox offset and size
    CropXOffset := GetPageBox(2, 0);
    CropWidth := GetPageBox(2, 2);
    CropHeight := GetPageBox(2, 3);
    CropYOffset := GetPageBox(2, 5);
    OldWidth := CropWidth;
    OldHeight := CropHeight;

    // Get the page's rotation
    OldRotation := PageRotation;

    // Normalize the rotation
    OldRotation := ((OldRotation div 90) mod 4) * 90;
    if (OldRotation < 0) then OldRotation := 360 + OldRotation;

    // Determine the new width/height based on the rotation
    if (OldRotation = 90) or (OldRotation = 270) then
    begin
      NewWidth := OldHeight;
      NewHeight := OldWidth;
    end else
    begin
      NewWidth := OldWidth;
      NewHeight := OldHeight;
    end;

    // Remove the page rotation attribute
    RotatePage(0);

    // Set all the page boxes to be the same
    SetPageBox(1, 0, NewHeight, NewWidth, NewHeight);
    SetPageBox(2, 0, NewHeight, NewWidth, NewHeight);
    SetPageBox(3, 0, NewHeight, NewWidth, NewHeight);
    SetPageBox(4, 0, NewHeight, NewWidth, NewHeight);
    SetPageBox(5, 0, NewHeight, NewWidth, NewHeight);

    // Calculate an appropriate transformation
    Transform := '';
    case OldRotation of
      0:
      begin
        Transform := '1 0 0 1 ' + QPLDoubleToStrConst(-CropXOffset, 4) + ' ' +
          QPLDoubleToStrConst(-CropYOffset, 4) + ' cm';
      end;
      90:
      begin
        Transform := '0 -1 1 0 0 ' + QPLDoubleToStrConst(NewHeight, 4) + ' cm ' +
          '1 0 0 1 ' + QPLDoubleToStrConst(-CropXOffset, 4) + ' ' +
          QPLDoubleToStrConst(-CropYOffset, 4) + ' cm';
      end;
      180:
      begin
        Transform := '-1 0 0 -1 ' + QPLDoubleToStrConst(NewWidth, 4) + ' ' +
          QPLDoubleToStrConst(NewHeight, 4) + ' cm ' +
          '1 0 0 1 ' + QPLDoubleToStrConst(-CropXOffset, 4) +
          ' ' + QPLDoubleToStrConst(-CropYOffset, 4) + ' cm';
      end;
      270:
      begin
        Transform := '0 1 -1 0 ' + QPLDoubleToStrConst(NewWidth, 4) + ' 0 cm ' +
          '1 0 0 1 ' + QPLDoubleToStrConst(-CropXOffset, 4) +
          ' ' + QPLDoubleToStrConst(-CropYOffset, 4) + ' cm';
      end;
    end;

    if (NormalizeOptions = 1) or (NormalizeOptions = 3) then
    begin
      // Balance the save/restore state commands
      Balancer := TPDFContentStreamStackBalancer.Create(0);
      try
        CS := GetPageContentToString;
        Balancer.Process(CS);

        NewContentStream;
        SetContentStreamFromString('q ' + Transform + ' ');
        MoveContentStream(ContentStreamCount, 1);

        NewContentStream;
        SetContentStreamFromString(' Q ' + Balancer.GetBalancingSuffix);
      finally
        Balancer.Free;
      end;
    end else
    begin
      if (NewContentStream <> 0) then
      begin
        SetContentStreamFromString('q ' + Transform + ' ');
        MoveContentStream(ContentStreamCount, 1);

        NewContentStream;
        SetContentStreamFromString(' Q ')
      end
      else
        Exit;
    end;

    if (OldRotation <> 0) then
    begin

      // Adjust the annotations
      for AnnotIndex := 0 to FSelDoc.PageTree.Annots.Count - 1 do
      begin
        AnnotRect := FSelDoc.PageTree.Annots.GetAnnotRect(AnnotIndex);

        AnnotRotation := FSelDoc.PageTree.Annots.GetRotation(AnnotIndex);
        FSelDoc.PageTree.Annots.SetRotation(AnnotIndex, AnnotRotation - OldRotation);

        if (Assigned(AnnotRect) and (AnnotRect.Count = 4)) then
        begin

          PDFRect := TPDFRectangle.Create(AnnotRect);
          AnnotLeft := PDFRect.Left;
          AnnotTop := PDFRect.Top;
          AnnotRight := PDFRect.Right;
          AnnotBottom := PDFRect.Bottom;
          try
            case OldRotation of
              0:
              begin
                PDFRect.Left := AnnotLeft - CropXOffset;
                PDFRect.Top := AnnotTop - CropYOffset;
                PDFRect.Right := AnnotRight - CropXOffset;
                PDFRect.Bottom := AnnotBottom - CropYOffset;
              end;

              90:
              begin
                PDFRect.Left := CropHeight - ((CropYOffset + CropHeight) - AnnotTop);
                PDFRect.Top := CropWidth - (AnnotRight - CropXOffset);
                PDFRect.Right := CropHeight - ((CropYOffset + CropHeight) - AnnotBottom);
                PDFRect.Bottom := CropWidth - (AnnotLeft - CropXOffset);
              end;

              180:
              begin
                PDFRect.Left := (CropXOffset + CropWidth) - AnnotRight;
                PDFRect.Top := (CropYOffset + CropHeight) - AnnotBottom;
                PDFRect.Right := (CropXOffset + CropWidth) - AnnotLeft;
                PDFRect.Bottom := (CropYOffset + CropHeight) - AnnotTop;
              end;

              270:
              begin
                PDFRect.Left := CropHeight - (AnnotBottom - CropYOffset);
                PDFRect.Top := CropWidth - ((CropXOffset + CropWidth) - AnnotLeft);
                PDFRect.Right := CropHeight - (AnnotTop - CropYOffset);
                PDFRect.Bottom := CropWidth - ((CropXOffset + CropWidth) - AnnotRight);
              end;
            end;
          finally
            PDFRect.Free;
          end;
        end;

        Obj := FSelDoc.PageTree.Annots.GetAnnotRef(AnnotIndex);
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if (Obj is TPDFDictionary) then
        begin
          if (TPDFDictionary(Obj).FindValueByKeyName('MK') = nil) then
          begin
            Obj := TPDFDictionary(Obj).FindValueByKeyName('AP', True);
            if (Obj is TPDFDictionary) then
            begin
              Obj := TPDFDictionary(Obj).FindValueByKeyName('N');
              if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
              if (Obj is TPDFStream) then
              begin
                Obj := TPDFStream(Obj).Dictionary.FindValueByKeyName('Matrix', True);
                if (Obj is TPDFArray) then
                  ResetMatrixEntries(Obj, OldRotation);
              end;
              if (Obj is TPDFDictionary) then
              begin
                Dict := TPDFDictionary(Obj);
                for I := 0 to Dict.Count do
                begin
                  Obj := Dict.Entry[I].Value;
                  if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;

                  if (Obj is TPDFStream) then
                  begin
                    Obj := TPDFStream(Obj).Dictionary.FindValueByKeyName('Matrix', True);
                    if (Obj is TPDFArray) then
                    begin
                      ResetMatrixEntries(Obj, OldRotation);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      end;

      if FSelDoc.HasFormData then
      begin
        for AnnotIndex := 0 to FSelDoc.AcroForm.Count - 1 do
        begin
          AnnotRotation := FSelDoc.AcroForm.Field[AnnotIndex].GetRotation;
          FSelDoc.AcroForm.Field[AnnotIndex].SetRotation(AnnotRotation - OldRotation);
        end;
      end;
    end; // Rotation <> 0

    FSelDoc.Origin := OldOrigin;
	  FSelDoc.Scale := OldScale;
    FSelDoc.ReloadFormData;

    Result := 1;
  end;
end;

function TQuickPDF.DARemoveUsageRights(FileHandle: Integer): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    if (Link.Doc.RemoveUsageRights) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.DASetPageMode(FileHandle: Integer; NewMode: Integer): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    if (Link.Doc.SetPageMode(TPDFDAPageMode(NewMode))) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.DASetPageLayout(FileHandle: Integer; NewLayout: Integer): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    if (Link.Doc.SetPageLayout(TPDFDAPageLayout(NewLayout))) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.DrawImageMatrix(M11, M12, M21, M22, MDX,
  MDY: Double): Integer;
begin
  if Assigned(FSelImage) then
  begin
    FSelDoc.PageTree.UseImage(FSelImage);
    FSelDoc.PageTree.Painter.DrawImageMatrix(FSelImage, M11, M12, M21, M22,
      MDX, MDY);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetObjectFromString(ObjectNumber: Integer;
  const Source: AnsiString): Integer;
begin
  if ((ObjectNumber >= 1) and (ObjectNumber <= GetMaxObjectNumber)) then
  begin
    FSelDoc.SetObjectSource(ObjectNumber, Source);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetRenderDCErasePage(NewErasePage: Integer): Integer;
begin
  FRenderDCErasePage := NewErasePage <> 0;
  Result := 1;
end;

function TQuickPDF.SetFormFieldSubmitAction(Index: Integer; const ActionType,
  Link: WideString): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := 1;
    Field.AddSubmitAction(AnsiString(ActionType), AnsiString(Link), -1);
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldSubmitActionString(Index: Integer; const ActionType: WideString): WideString;
var
  Field: TPDFField;
begin
  Result := '';
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.GetSubmitActionString(ActionType);
    if Field.TempField then Field.Free;
  end;
end;



function TQuickPDF.SetMarkupAnnotStyle(Index: Integer; Red, Green, Blue,
  Transparency: Double): Integer;
begin
  if (FSelDoc.PageTree.Annots.SetMarkupAnnotStyle(Index - 1, Red, Green, Blue,
    Transparency)) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.CreateNewObject: Integer;
begin
  Result := FSelDoc.CreateNewObject;
end;

function TQuickPDF.GetOptionalContentGroupPrintable(
  OptionalContentGroupID: Integer): Integer;
var
  OCGRef: TPDFIndRef;
begin
  Result := 0;
  OCGRef := ValidOCG(OptionalContentGroupID);
  if Assigned(OCGRef) then
  begin
    if FSelDoc.GetOCGPrintable(OCGRef) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.GetOptionalContentGroupVisible(
  OptionalContentGroupID: Integer): Integer;
var
  OCGRef: TPDFIndRef;
begin
  Result := 0;
  OCGRef := ValidOCG(OptionalContentGroupID);
  if Assigned(OCGRef) then
  begin
    if FSelDoc.GetOCGVisible(OCGRef) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.AddTrueTypeSubsettedFont(const FontName,
  SubsetChars: WideString; Options: Integer): Integer;
var
  Font: TPDFFont;
begin
  Result := 0;
  if (Options >= 0) and (Options <= 5) then
  begin
    if (SubsetChars = '') then
      Font := FSelDoc.NewSubsettedTrueTypeFont(FontName, ' ', Options)
    else
      Font := FSelDoc.NewSubsettedTrueTypeFont(FontName, SubsetChars, Options);
    if Font <> nil then
    begin
      Result := IntCast(Font);
      SelectFont(Result);
    end;
  end;
end;

function TQuickPDF.SetLineDashEx(const DashValues: WideString): Integer;
begin
  if (FSelDoc.PageTree.Painter.SetLineDashEx(AnsiString(DashValues))) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetRenderCropType(NewCropType: Integer): Integer;
begin
  if ((NewCropType >= 1) and (NewCropType <= 5)) then
  begin
    Result := 1;
    FRenderCropType := NewCropType;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.CheckFileCompliance(const InputFileName,
  Password: WideString; ComplianceTest, Options: Integer): Integer;
var
  ResultList: TStringList;
  FS: TQuickPDFWideFileStream;
begin
  Result := 0;
  ResultList := TStringList.Create;
  try
    FS := QPLCreateFileStream(InputFileName, fmOpenRead or fmShareDenyWrite);
    try
      case ComplianceTest of
        1: CheckCompliancePDFA(FS, Password, Options, ResultList);
      end;

      if (ResultList.Count > 0) then
      begin
        FStringLists.Add(ResultList);
        Result := IntCast(ResultList);
        ResultList := nil;
      end;
    finally
      FS.Free;
    end;
  finally
    if (Assigned(ResultList)) then
    begin
      ResultList.Free;
    end;
  end;
end;

function TQuickPDF.GetStringListCount(StringListID: Integer): Integer;
var
  VCLObj: TObject;
  ListIndex: Integer;
begin
  Result := 0;
  VCLObj := IntUncast(StringListID);
  if (VCLObj is TStringList) then
  begin
    ListIndex := FStringLists.IndexOf(TObject(VCLObj));
    if (ListIndex >= 0) then
    begin
      Result := TStringList(VCLObj).Count;
    end;
  end;
end;

function TQuickPDF.GetStringListItem(StringListID,
  ItemIndex: Integer): WideString;
var
  ListIndex: Integer;
  VCLObj: TObject;
begin
  VCLObj := IntUncast(StringListID);
  if (VCLObj is TStringList) then
  begin
    ListIndex := FStringLists.IndexOf(TObject(VCLObj));
    if (ListIndex >= 0) then
    begin
      if (ItemIndex >= 1) and (ItemIndex <= TStringList(VCLObj).Count) then
      begin
        Result := TStringList(VCLObj)[ItemIndex - 1];
      end;
    end else
    begin
      Result := '';
    end;
  end;
end;

function TQuickPDF.SetContentStreamFromString(const Source: AnsiString): Integer;
begin
  FSelDoc.PageTree.SetContent(Source);
  FSelDoc.PageTree.Painter.SetSource(Source);
  Result := 1;
end;

function TQuickPDF.GetContentStreamToString: AnsiString;
begin
  Result := FSelDoc.PageTree.ExtractContent;
end;

function TQuickPDF.SetPDFAMode(NewMode: Integer): Integer;
begin
  Result := 0;
  if (FSelDoc.SetPDFAMode(NewMode)) then
  begin
    if (NewMode = 1) then
    begin
      FSelDoc.SetMarkInfo(True);
      FSelDoc.AddOutputIntent('DeviceRGB');
      Result := 1;
    end else
    if (NewMode = 2) then
    begin
      FSelDoc.AddOutputIntent('DeviceRGB');
      Result := 1;
    end;
  end;
end;

function TQuickPDF.DrawPDF417Symbol(Left, Top: Double; const Text: WideString;
  Options: Integer): Integer;
var
  PainterState: AnsiString;
begin
  Result := 0;
  if ((Options >= 0) and (Options <= 3)) then
  begin
    if (not Assigned(FSelFont)) then AddStandardFont(4);
    PainterState := FSelDoc.PageTree.Painter.GetState;
    try
      Result := 1;

      if not (FSelDoc.FillSet) then
      begin
        SetFillColor(0, 0, 0);
        FSelDoc.FillSet := False;
      end;

      if (not FSelDoc.PageTree.Painter.DrawPDF417Symbol(TranslateX(Left),
        TranslateY(Top), Text, Options, 0, 0, -1, 2, 1)) then
      begin
        Result := 0;
      end;
    finally
      FSelDoc.PageTree.Painter.SetState(PainterState);
    end;
  end;
end;

function TQuickPDF.SetTextExtractionOptions(OptionID,
  NewValue: Integer): Integer;
begin
  Result := 0;
  if ((NewValue = 0) or (NewValue = 1)) then
  begin
    if (OptionID = 1) then
    begin
      FSelDoc.TextExtractOptions.IgnoreFont := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 2) then
    begin
      FSelDoc.TextExtractOptions.IgnoreColor := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 3) then
    begin
      FSelDoc.TextExtractOptions.IgnoreBlocks := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 4) then
    begin
      FSelDoc.TextExtractOptions.OutputCMYK := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 5) then
    begin
      FSelDoc.TextExtractOptions.SortBlocks := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 6) then
    begin
      FSelDoc.TextExtractOptions.IgnoreDescenders := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 7) then
    begin
      FSelDoc.TextExtractOptions.IgnoreOverlaps := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 8) then
    begin
      FSelDoc.TextExtractOptions.IgnoreDuplicates := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 9) then
    begin
      FSelDoc.TextExtractOptions.SplitOnDoubleSpace := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 10) then
    begin
      FSelDoc.TextExtractOptions.TrimCharsOutsideArea := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 11) then
    begin
      FSelDoc.TextExtractOptions.SpecialMatch := NewValue = 1;
      Result := 1;
    end;
    if (OptionID = 12) then
    begin
      FSelDoc.TextExtractOptions.IgnoreRotated := NewValue = 1;
      Result := 1;
    end;
    if (OptionID = 13) then
    begin
      FSelDoc.TextExtractOptions.TrimWhitespace := NewValue = 1;
      Result := 1;
    end;
    if (OptionID = 14) then
    begin
      FSelDoc.TextExtractOptions.OutputNonAscii := NewValue = 1;
      Result := 1;
    end;
    if (OptionID = 15) then
    begin
      FSelDoc.TextExtractOptions.RemoveUnderscoreLines := NewValue = 1;
      Result := 1;
    end;
  end;
end;

function TQuickPDF.GetImageMeasureDict: Integer;
begin
  if Assigned(FSelImage) then
  begin
    Result := IntCast(FSelImage.GetMeasureDict);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetImagePtDataDict: Integer;
begin
  if Assigned(FSelImage) then
  begin
    Result := IntCast(FSelImage.GetPtDataDict);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetMeasureDictCoordinateSystem(MeasureDictID, CoordinateSystemID: Integer): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      if (Dict.SetCoordinateSystem(CoordinateSystemID)) then
      begin
        Result := 1;
      end;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetMeasureDictCoordinateSystem(MeasureDictID: Integer): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      Result := Dict.GetCoordinateSystem;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.SetMeasureDictBoundsCount(MeasureDictID, NewCount: Integer): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      if (Dict.SetBoundsCount(NewCount)) then
      begin
        Result := 1;
      end;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetMeasureDictBoundsCount(MeasureDictID: Integer): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      Result := Dict.GetBoundsCount;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.SetMeasureDictBoundsItem(MeasureDictID, ItemIndex: Integer; NewValue: Double): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      if (Dict.SetBoundsItem(ItemIndex - 1, NewValue)) then
      begin
        Result := 1;
      end;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetMeasureDictBoundsItem(MeasureDictID, ItemIndex: Integer): Double;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      Result := Dict.GetBoundsItem(ItemIndex - 1);
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.SetMeasureDictPDU(MeasureDictID, LinearUnit, AreaUnit, AngularUnit: Integer): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      if (Dict.SetPDU(LinearUnit, AreaUnit, AngularUnit)) then
      begin
        Result := 1;
      end;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetMeasureDictPDU(MeasureDictID, UnitIndex: Integer): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      Result := Dict.GetPDU(UnitIndex - 1);
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetMeasureDictGCSDict(MeasureDictID: Integer): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      Result := IntCast(Dict.GetGCSDict);
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetMeasureDictDCSDict(MeasureDictID: Integer): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      Result := IntCast(Dict.GetDCSDict);
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.SetMeasureDictGPTSCount(MeasureDictID, NewCount: Integer): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      if (Dict.SetGPTSCount(NewCount)) then
      begin
        Result := 1;
      end;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetMeasureDictGPTSCount(MeasureDictID: Integer): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      Result := Dict.GetGPTSCount;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.SetMeasureDictGPTSItem(MeasureDictID, ItemIndex: Integer; NewValue: Double): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      if (Dict.SetGPTSItem(ItemIndex - 1, NewValue)) then
      begin
        Result := 1;
      end;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetMeasureDictGPTSItem(MeasureDictID, ItemIndex: Integer): Double;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      Result := Dict.GetGPTSItem(ItemIndex - 1);
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.SetMeasureDictLPTSCount(MeasureDictID, NewCount: Integer): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      if (Dict.SetLPTSCount(NewCount)) then
      begin
        Result := 1;
      end;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetMeasureDictLPTSCount(MeasureDictID: Integer): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      Result := Dict.GetLPTSCount;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.SetMeasureDictLPTSItem(MeasureDictID, ItemIndex: Integer; NewValue: Double): Integer;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      if (Dict.SetLPTSItem(ItemIndex - 1, NewValue)) then
      begin
        Result := 1;
      end;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetMeasureDictLPTSItem(MeasureDictID, ItemIndex: Integer): Double;
var
  MeasureDict: TPDFDictionary;
  Dict: TQuickPDFMeasureDict;
begin
  Result := 0;
  MeasureDict := ValidMeasureDictID(MeasureDictID);
  if (Assigned(MeasureDict)) then
  begin
    Dict := TQuickPDFMeasureDict.Create(MeasureDict, FSelDoc.Structure);
    try
      Result := Dict.GetLPTSItem(ItemIndex - 1);
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetCSDictEPSG(CSDictID: Integer): Integer;
var
  CSDict: TPDFDictionary;
  Dict: TQuickPDFCoordinateSystemDict;
begin
  Result := 0;
  CSDict := ValidCSDictID(CSDictID);
  if (Assigned(CSDict)) then
  begin
    Dict := TQuickPDFCoordinateSystemDict.Create(CSDict, FSelDoc.Structure);
    try
      Result := Dict.GetEPSG;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.SetCSDictEPSG(CSDictID, NewEPSG: Integer): Integer;
var
  CSDict: TPDFDictionary;
  Dict: TQuickPDFCoordinateSystemDict;
begin
  Result := 0;
  CSDict := ValidCSDictID(CSDictID);
  if (Assigned(CSDict)) then
  begin
    Dict := TQuickPDFCoordinateSystemDict.Create(CSDict, FSelDoc.Structure);
    try
      if (Dict.SetEPSG(NewEPSG)) then
      begin
        Result := 1;
      end;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetCSDictWKT(CSDictID: Integer): WideString;
var
  CSDict: TPDFDictionary;
  Dict: TQuickPDFCoordinateSystemDict;
begin
  Result := '';
  CSDict := ValidCSDictID(CSDictID);
  if (Assigned(CSDict)) then
  begin
    Dict := TQuickPDFCoordinateSystemDict.Create(CSDict, FSelDoc.Structure);
    try
      Result := Dict.GetWKT;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.SetCSDictWKT(CSDictID: Integer; const NewWKT: WideString): Integer;
var
  CSDict: TPDFDictionary;
  Dict: TQuickPDFCoordinateSystemDict;
begin
  Result := 0;
  CSDict := ValidCSDictID(CSDictID);
  if (Assigned(CSDict)) then
  begin
    Dict := TQuickPDFCoordinateSystemDict.Create(CSDict, FSelDoc.Structure);
    try
      if (Dict.SetWKT(NewWKT)) then
      begin
        Result := 1;
      end;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetCSDictType(CSDictID: Integer): Integer;
var
  CSDict: TPDFDictionary;
  Dict: TQuickPDFCoordinateSystemDict;
begin
  Result := 0;
  CSDict := ValidCSDictID(CSDictID);
  if (Assigned(CSDict)) then
  begin
    Dict := TQuickPDFCoordinateSystemDict.Create(CSDict, FSelDoc.Structure);
    try
      Result := Dict.GetDictType;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.SetCSDictType(CSDictID, NewDictType: Integer): Integer;
var
  CSDict: TPDFDictionary;
  Dict: TQuickPDFCoordinateSystemDict;
begin
  Result := 0;
  CSDict := ValidCSDictID(CSDictID);
  if (Assigned(CSDict)) then
  begin
    Dict := TQuickPDFCoordinateSystemDict.Create(CSDict, FSelDoc.Structure);
    try
      if (Dict.SetDictType(NewDictType)) then
      begin
        Result := 1;
      end;
    finally
      Dict.Free;
    end;
  end;
end;

function TQuickPDF.GetUnicodeCharactersFromEncoding(
  Encoding: Integer): WideString;
var
  X: Integer;
  Swapped: Boolean;
  Temp: WideChar;
begin
  Result := '';
  if (Encoding = 2) then
  begin
    // WinAnsi
    for X := 1 to 229 do
    begin
      if (WinAnsiEncodingVector[X] >= 0) then
      begin
        Result := Result + WideChar(UnicodeValues[X]);
      end;
    end;
  end;
  Swapped := True;
  while (Swapped) do
  begin
    Swapped := False;
    for X := 1 to Length(Result) - 1 do
    begin
      if (Result[X] > Result[X + 1]) then
      begin
        Temp := Result[X];
        Result[X] := Result[X + 1];
        Result[X + 1] := Temp;
      end;
    end;
  end;
end;

function TQuickPDF.SetTextExtractionArea(Left, Top, Width,
  Height: Double): Integer;
begin
  FSelDoc.TextExtractOptions.HasArea := (Width <> 0) and (Height <> 0);
  if (FSelDoc.TextExtractOptions.HasArea) then
  begin
    Result := 1;
    FSelDoc.TextExtractOptions.AreaLeft := TranslateX(Left);
    FSelDoc.TextExtractOptions.AreaTop := TranslateY(Top);
    FSelDoc.TextExtractOptions.AreaWidth := GetScale(Width);
    FSelDoc.TextExtractOptions.AreaHeight := GetScale(Height);
  end else
  begin
    Result := 2;
  end;
end;

function TQuickPDF.GetPrinterDevModeToString(
  const PrinterName: WideString): AnsiString;
var
  LocalPrinter: TPrinter;
  CustomPrinterIndex: Integer;
  OriginalPrinterName: WideString;
{$IFNDEF UNICODE}
  PrinterNameA: AnsiString;
  OriginalPrinterNameA: AnsiString;
{$ENDIF}
  CustomPrinter: TPDFCustomPrinter;
begin
  FLastRenderError := '';
  LocalPrinter := GetPrinter;
  CustomPrinterIndex := FCustomPrinters.IndexOf(QPLUpperCase(AnsiString(PrinterName)));
  if (CustomPrinterIndex >= 0) then
  begin
    CustomPrinter := TPDFCustomPrinter(FCustomPrinters.Objects[CustomPrinterIndex]);
    OriginalPrinterName := CustomPrinter.OriginalPrinterName;
{$IFDEF UNICODE}
    LocalPrinter.SetPrinter(@OriginalPrinterName[1], 'WINSPOOL', '', 0);
{$ELSE}
    OriginalPrinterNameA := AnsiString(OriginalPrinterName);
    LocalPrinter.SetPrinter(@OriginalPrinterNameA[1], 'WINSPOOL', '', 0);
{$ENDIF}
    CustomPrinter.SetPrinter(LocalPrinter, '');
  end else
  begin
{$IFDEF UNICODE}
    LocalPrinter.SetPrinter(@PrinterName[1], 'WINSPOOL', '', 0);
{$ELSE}
    PrinterNameA := AnsiString(PrinterName);
    LocalPrinter.SetPrinter(@PrinterNameA[1], 'WINSPOOL', '', 0);
{$ENDIF}
  end;
  Result := GetDevModeToString(LocalPrinter);
end;

function TQuickPDF.SetPrinterDevModeFromString(
  const Source: AnsiString): Integer;
begin
  FPrinterDevMode := Source;
  Result := 1;
end;

function TQuickPDF.AddOpenTypeFontFromFile(
  const FileName: WideString; Options: Integer): Integer;
begin
  if (Options = 0) then
  begin
    Result := AddTrueTypeFontFromFile(FileName);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetLatestPrinterNames: WideString;
var
  X: Integer;
  PrinterList: TQuickPDFStringList;
begin
  Result := '';
  PrinterList := TQuickPDFStringList.Create;
  try
    GetPrinterList(PrinterList);
    for X := 0 to PrinterList.Count - 1 do
    begin
      Result := Result + '"' + QPLUTF8Decode(PrinterList[X]) + '"';
      if (X < PrinterLIst.Count - 1) then
      begin
        Result := Result + ',';
      end;
    end;
  finally
    PrinterList.Free;
  end;
end;

function TQuickPDF.GetPageImageList(Options: Integer): Integer;
var
  ImageList: TPDFImageList;
begin
  ImageList := FSelDoc.PageTree.GetImageList;
  if (Assigned(ImageList)) then
  begin
    Result := IntCast(ImageList);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetImageListCount(ImageListID: Integer): Integer;
var
  VCLObj: TObject;
  ImageList: TPDFImageList;
begin
  VCLObj := IntUncast(ImageListID);
  if (VCLObj is TPDFImageList) then
  begin
    ImageList := TPDFImageList(VCLObj);
    Result := ImageList.ImageCount;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetImageListItemIntProperty(ImageListID, ImageIndex, PropertyID: Integer): Integer;
var
  VCLObj: TObject;
  ImageList: TPDFImageList;
  ImgRef: TPDFIndRef;
  ObjNum: Integer;
  GenNum: Integer;
  ImgObj: TPDFObject;
begin
  Result := 0;
  VCLObj := IntUncast(ImageListID);
  if (VCLObj is TPDFImageList) then
  begin
    ImageList := TPDFImageList(VCLObj);
    case PropertyID of
      400: Result := Integer(ImageList.ImageType(ImageIndex));
      401: Result := ImageList.ImagePixelWidth(ImageIndex);
      402: Result := ImageList.ImagePixelHeight(ImageIndex);
      403: Result := ImageList.ImageBitsPerPixel(ImageIndex);
      404: Result := ImageList.ImageColorSpaceType(ImageIndex);
      405:
      begin
        ImgRef := ImageList.ImageRef(ImageIndex);
        if (Assigned(ImgRef)) then
        begin
          ObjNum := ImgRef.ObjNum;
          GenNum := ImgRef.GenNum;
          ImgObj := ImgRef.Obj;
          if ImgObj is TPDFStream then
          begin
            FSelDoc.AddImageFromStream(TPDFStream(ImgObj), ObjNum, GenNum);
            Result := IntCast(FSelDoc.Image(FSelDoc.ImageCount - 1));
          end;
        end;
      end;
      406:
      begin
        Result := ImageList.ImageID(ImageIndex);
        if (Result = -1) then
        begin
          ImgRef := ImageList.ImageRef(ImageIndex);
          if (Assigned(ImgRef)) then
          begin
            ObjNum := ImgRef.ObjNum;
            GenNum := ImgRef.GenNum;
            ImgObj := ImgRef.Obj;
            if ImgObj is TPDFStream then
            begin
              FSelDoc.AddImageFromStream(TPDFStream(ImgObj), ObjNum, GenNum);
              Result := IntCast(FSelDoc.Image(FSelDoc.ImageCount - 1));
              ImageList.SetImageID(ImageIndex, Result);
            end;
          end;
        end;
      end;
      407:
      begin
        ImgRef := ImageList.ImageRef(ImageIndex);
        if (Assigned(ImgRef)) then
        begin
          Result := ImgRef.ObjNum;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.GetImageListItemDblProperty(ImageListID, ImageIndex, PropertyID: Integer): Double;
var
  VCLObj: TObject;
  ImageList: TPDFImageList;
begin
  Result := 0;
  VCLObj := IntUncast(ImageListID);
  if (VCLObj is TPDFImageList) then
  begin
    ImageList := TPDFImageList(VCLObj);
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

    Result := Result * FSelDoc.Scale;
    case PropertyID of
      501, 503, 505, 507:
        if (FSelDoc.Origin = 2) or (FSelDoc.Origin = 3) then
          Result := PageWidth - Result;
      502, 504, 506, 508:
        if (FSelDoc.Origin = 1) or (FSelDoc.Origin = 2) then
          Result := PageHeight - Result;
    end;
  end;
end;

function TQuickPDF.GetImageListItemDataToString(ImageListID, ImageIndex, Options: Integer): AnsiString;
var
  VCLObj: TObject;
  ImageList: TPDFImageList;
begin
  Result := '';
  VCLObj := IntUncast(ImageListID);
  if (VCLObj is TPDFImageList) then
  begin
    ImageList := TPDFImageList(VCLObj);
    Result := ImageList.ImageData(ImageIndex);
  end;
end;

function TQuickPDF.SaveImageListItemDataToFile(ImageListID, ImageIndex, Options: Integer; const ImageFileName: WideString): Integer;
var
  FS: TQuickPDFWideFileStream;
  ImageData: AnsiString;
begin
  Result := 0;
  ImageData := GetImageListItemDataToString(ImageListID, ImageIndex, Options);
  if (Length(ImageData) > 0) then
  begin
    try
      FS := TQuickPDFWideFileStream.Create(ImageFileName, fmCreate);
      FS.Write(ImageData[1], Length(ImageData));
      FS.Free;
      Result := 1;
    except
    end;
  end;
end;

function TQuickPDF.DASetTextExtractionWordGap(NewWordGap: Double): Integer;
begin
  FDATextExtractOptions.WordGap := NewWordGap;
  Result := 1;
end;

function TQuickPDF.DASetTextExtractionOptions(OptionID, NewValue: Integer): Integer;
begin
  Result := 0;
  if ((NewValue = 0) or (NewValue = 1)) then
  begin
    if (OptionID = 1) then
    begin
      FDATextExtractOptions.IgnoreFont := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 2) then
    begin
      FDATextExtractOptions.IgnoreColor := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 3) then
    begin
      FDATextExtractOptions.IgnoreBlocks := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 4) then
    begin
      FDATextExtractOptions.OutputCMYK := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 5) then
    begin
      FDATextExtractOptions.SortBlocks := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 6) then
    begin
      FDATextExtractOptions.IgnoreDescenders := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 7) then
    begin
      FDATextExtractOptions.IgnoreOverlaps := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 8) then
    begin
      FDATextExtractOptions.IgnoreDuplicates := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 9) then
    begin
      FDATextExtractOptions.SplitOnDoubleSpace := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 10) then
    begin
      FDATextExtractOptions.TrimCharsOutsideArea := NewValue = 1;
      Result := 1;
    end else
    if (OptionID = 11) then
    begin
      FDATextExtractOptions.SpecialMatch := NewValue = 1;
      Result := 1;
    end;
    if (OptionID = 12) then
    begin
      FDATextExtractOptions.IgnoreRotated := NewValue = 1;
      Result := 1;
    end;
    if (OptionID = 13) then
    begin
      FDATextExtractOptions.TrimWhitespace := NewValue = 1;
      Result := 1;
    end;
    if (OptionID = 14) then
    begin
      FDATextExtractOptions.OutputNonAscii := NewValue = 1;
      Result := 1;
    end;
    if (OptionID = 15) then
    begin
      FDATextExtractOptions.RemoveUnderscoreLines := NewValue = 1;
      Result := 1;
    end;
  end;
end;

function TQuickPDF.DASetTextExtractionArea(Left, Top, Width, Height: Double): Integer;
begin
  FDATextExtractOptions.HasArea := (Width <> 0) and (Height <> 0);
  if (FDATextExtractOptions.HasArea) then
  begin
    Result := 1;
    FDATextExtractOptions.AreaLeft := Left;
    FDATextExtractOptions.AreaTop := Top;
    FDATextExtractOptions.AreaWidth := Width;
    FDATextExtractOptions.AreaHeight := Height;
  end else
  begin
    Result := 2;
  end;
end;

{$IFDEF QPL_CAIRO}
function TQuickPDF.SetCairoFileName(const FileName: WideString): Integer;
var
  CairoDLL: TCairoDLL;
begin
  Result := 0;
  CairoDLL := TCairoDLL.Create;
  try
    if (CairoDLL.Attach(FileName)) then
    begin
      Result := 1;
      FCairoFileName := FileName;
    end;
  finally
    CairoDLL.Free;
  end;
end;
{$ELSE}
function TQuickPDF.SetCairoFileName(const FileName: WideString): Integer;
begin
  Result := 0;
end;
{$ENDIF}

{$IFDEF QPL_DPLR}
function TQuickPDF.SetDPLRFileName(const FileName: WideString): Integer;
var
  RendererDLL: TDebenuPDFLibraryDPLR;
begin
  Result := 0;
  RendererDLL := TDebenuPDFLibraryDPLR.Create;
  try
    if (RendererDLL.Attach(FileName)) then
    begin
      Result := 1;
      FDPLRFileName := FileName;
    end;
  finally
    RendererDLL.Free;
  end;
end;
{$ELSE}
function TQuickPDF.SetDPLRFileName(const FileName: WideString): Integer;
begin
  Result := 0;
end;
{$ENDIF}

function TQuickPDF.SelectRenderer(RendererID: Integer): Integer;
begin
  Result := 0;
{$IFDEF QPL_CAIRO}
  FUseCairo := RendererID = 2;
  if (RendererID = 2) then
  begin
    Result := RendererID;
  end;
{$ENDIF}
{$IFDEF QPL_DPLR}
  FUseDPLR := RendererID = 3;
  if (RendererID = 3) then
  begin
    Result := RendererID;
  end;
{$ENDIF}
  if (RendererID = 1) then
  begin
    Result := 1;
  end
end;

function TQuickPDF.SelectedRenderer: Integer;
begin
  Result := 1;
{$IFDEF QPL_CAIRO}
    if(FUseCairo) then Result := 2;
{$ENDIF}
{$IFDEF QPL_DPLR}
    if(FUseDPLR) then Result := 3;
{$ENDIF}
end;

function TQuickPDF.GetPageViewPortID(Index: Integer): Integer;
begin
  Result := IntCast(FSelDoc.PageTree.GetViewPort(Index - 1));
end;

function TQuickPDF.GetPageViewPortCount: Integer;
begin
  Result := FSelDoc.PageTree.GetViewPortCount;
end;

function TQuickPDF.GetViewPortMeasureDict(ViewPortID: Integer): Integer;
var
  Obj: TPDFObject;
  ViewPortDict: TPDFDictionary;
begin
  Result := 0;
  ViewPortDict := ValidViewPortID(ViewPortID);
  if (Assigned(ViewPortDict)) then
  begin
    Obj := ViewPortDict.FindValueByKeyName('Measure', True);
    if (Obj is TPDFDictionary) then
    begin
      Result := IntCast(TPDFDictionary(Obj));
    end;
  end;
end;

function TQuickPDF.GetViewPortName(ViewPortID: Integer): WideString;
var
  Obj: TPDFObject;
  ViewPortDict: TPDFDictionary;
begin
  Result := '';
  ViewPortDict := ValidViewPortID(ViewPortID);
  if (Assigned(ViewPortDict)) then
  begin
    Obj := ViewPortDict.FindValueByKeyName('Name', True);
    if (Obj is TPDFString) then
    begin
      Result := TPDFString(Obj).AsTextString;
    end;
  end;
end;

function TQuickPDF.GetViewPortPtDataDict(ViewPortID: Integer): Integer;
var
  Obj: TPDFObject;
  ViewPortDict: TPDFDictionary;
begin
  Result := 0;
  ViewPortDict := ValidViewPortID(ViewPortID);
  if (Assigned(ViewPortDict)) then
  begin
    Obj := ViewPortDict.FindValueByKeyName('PtData', True);
    if (Obj is TPDFDictionary) then
    begin
      Result := IntCast(TPDFDictionary(Obj));
    end;
  end;
end;

function TQuickPDF.GetViewPortBBox(ViewPortID, Dimension: Integer): Double;
var
  Obj: TPDFObject;
  ViewPortDict: TPDFDictionary;
  BBoxRect: TPDFRectangle;
  D: TPDFDimension;
begin
  Result := 0;
  if ((Dimension >= 0) and (Dimension <= 5)) then
  begin
    D := TPDFDimension(Dimension);
    ViewPortDict := ValidViewPortID(ViewPortID);
    if (Assigned(ViewPortDict)) then
    begin
      Obj := ViewPortDict.FindValueByKeyName('BBox', True);
      if (Obj is TPDFArray) then
      begin
        BBoxRect := TPDFRectangle.Create(TPDFArray(Obj));
        try
          Result := BBoxRect.GetDimension(D);
        finally
          BBoxRect.Free;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.ValidPrinterName(const PrinterName: WideString): Boolean;
var
  PrinterList: TQuickPDFStringList;
begin
  // Check for a custom printer
  Result := FCustomPrinters.IndexOf(QPLUpperCase(AnsiString(PrinterName))) >= 0;

  // If a custom printer wasn't found, check for a regular printer name
  if (not Result) then
  begin
    PrinterList := TQuickPDFStringList.Create;
    try
      GetPrinterList(PrinterList);
      if (PrinterList.IndexOf(QPLUTF8Encode(PrinterName)) >= 0) then
      begin
        Result := True;
      end;
    finally
      PrinterList.Free;
    end;
  end;
end;

function TQuickPDF.ValidSignProcessID(SignProcessID: Integer): TQuickPDFSignProcess;
var
  VCLObj: TObject;
begin
  Result := nil;
  VCLObj := IntUncast(SignProcessID);
  if (VCLObj is TQuickPDFSignProcess) then
  begin
    Result := TQuickPDFSignProcess(VCLObj);
  end;
end;

function TQuickPDF.SetOptionalContentConfigState(OptionalContentConfigID,
  OptionalContentGroupID, NewState: Integer): Integer;
var
  OCGRef: TPDFIndRef;
begin
  Result := 0;
  OCGRef := ValidOCG(OptionalContentGroupID);
  if (Assigned(OCGRef) and (NewState >= 1) and (NewState <= 3)) then
  begin
    if (FSelDoc.SetOptionalContentConfigState(OptionalContentConfigID,
      OCGRef, NewState)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.SetCapturedPageTransparencyGroup(CaptureID, CS, Isolate,
  Knockout: Integer): Integer;
var
  CP: TPDFCapturedPage;
const
  ColorSpaces: array[1..2] of AnsiString = ('DeviceRGB', 'DeviceCMYK');
begin
  Result := 0;
  CP := ValidCaptureID(CaptureID);
  if ((CS >= 1) and (CS <= 2) and Assigned(CP)) then
  begin
    CP.SetTransparencyGroup(ColorSpaces[CS], Isolate = 1, Knockout = 1);
  end;
end;

function TQuickPDF.SetTableThinBorders(TableID, ThinBorders: Integer; Red, Green, Blue: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table) and ((ThinBorders = 0) or (ThinBorders = 1))) then
  begin
    Table.SetThinBorders(ThinBorders = 1, Red, Green, Blue);
    Result := 1;
  end;
end;

function TQuickPDF.SetTableThinBordersCMYK(TableID, ThinBorders: Integer; C, M, Y, K: Double): Integer;
var
  Table: TPDFTable;
begin
  Result := 0;
  Table := ValidTableID(TableID);
  if (Assigned(Table) and ((ThinBorders = 0) or (ThinBorders = 1))) then
  begin
    Table.SetThinBordersCMYK(ThinBorders = 1, C, M, Y, K);
    Result := 1;
  end;
end;

function TQuickPDF.RemoveFormFieldBorderColor(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.RemoveBorderColor;
    Result := 1;
    if Field.TempField then
    begin
      Field.Free;
    end;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetTextUnderlineCustomDash(const DashPattern: WideString;
  DashPhase: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetUnderlineCustomDash(AnsiString(DashPattern), DashPhase);
  Result := 1;
end;

function TQuickPDF.SetTextUnderlineWidth(UnderlineWidth: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetUnderlineWidth(UnderlineWidth);
  Result := 1;
end;

function TQuickPDF.SetTextUnderlineDistance(UnderlineDistance: Double): Integer;
begin
  FSelDoc.PageTree.Painter.SetUnderlineDistance(UnderlineDistance);
  Result := 1;
end;

function TQuickPDF.DrawRotatedBox(Left, Bottom, Width, Height, Angle: Double;
  DrawOptions: Integer): Integer;
var
  Fill: Boolean;
  Outline: Boolean;
begin
  Fill := (DrawOptions = 1) or (DrawOptions = 2);
  Outline := (DrawOptions = 0) or (DrawOptions = 2);
  FSelDoc.PageTree.Painter.RotatedRectangle(TranslateX(Left), TranslateY(Bottom),
    GetScale(Width), GetScale(Height), Angle, Fill, Outline);
  Result := 1;
end;

function TQuickPDF.DrawRotatedMultiLineText(XPos, YPos, Angle: Double;
  const Delimiter, Text: WideString): Integer;
begin
  if (Text <> '') and (Angle >= 0) and (Angle <= 360) then
  begin
    CheckFontSelection;
    FSelDoc.PageTree.Painter.DrawRotatedMultiLineWideText(TranslateX(XPos),
      TranslateY(YPos), Angle, Delimiter, FixWideDelimited(Text, Delimiter));
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.GetPrinterMediaTypes(
  const PrinterName: WideString): WideString;
var
  LocalPrinter: TPrinter;
  CustomPrinterIndex: Integer;
  OriginalPrinterName: WideString;
{$IFNDEF UNICODE}
  PrinterNameA: AnsiString;
  OriginalPrinterNameA: AnsiString;
{$ENDIF}
  CustomPrinter: TPDFCustomPrinter;
begin
  LocalPrinter := GetPrinter;
  CustomPrinterIndex := FCustomPrinters.IndexOf(QPLUpperCase(AnsiString(PrinterName)));
  if (CustomPrinterIndex >= 0) then
  begin
    CustomPrinter := TPDFCustomPrinter(FCustomPrinters.Objects[CustomPrinterIndex]);
    OriginalPrinterName := CustomPrinter.OriginalPrinterName;
{$IFDEF UNICODE}
    LocalPrinter.SetPrinter(@OriginalPrinterName[1], 'WINSPOOL', '', 0);
{$ELSE}
    OriginalPrinterNameA := AnsiString(OriginalPrinterName);
    LocalPrinter.SetPrinter(@OriginalPrinterNameA[1], 'WINSPOOL', '', 0);
{$ENDIF}
  end else
  begin
{$IFDEF UNICODE}
    LocalPrinter.SetPrinter(@PrinterName[1], 'WINSPOOL', '', 0);
{$ELSE}
    PrinterNameA := AnsiString(PrinterName);
    LocalPrinter.SetPrinter(@PrinterNameA[1], 'WINSPOOL', '', 0);
{$ENDIF}
  end;
  Result := WideString(DebenuPDFLibraryPrinting.GetPrinterMediaTypes(LocalPrinter));
end;

function TQuickPDF.GetPageColorSpaces(Options: Integer): WideString;
begin
  Result := WideString(FSelDoc.PageTree.FindColorSpaces(Options));
end;

function TQuickPDF.SetDestProperties(DestID, Zoom, DestType: Integer;
  Left, Top, Right, Bottom: Double): Integer;
var
  Dest: TPDFArray;
begin
  Result := 0;
  Dest := GetDestArray(DestID);
  if ((Zoom >= 0) and (Zoom <= 6400) and (DestType >= 1) and (DestType <= 8) and
    Assigned(Dest)) then
  begin
    if (Dest.Count >= 1) then
    begin
      while (Dest.Count > 1) do
      begin
        Dest.Delete(1);
      end;
      case DestType of
        1:
        begin
          Dest.Add(Dest.Owner.NewName('XYZ'));
          Dest.Add(Dest.Owner.NewNumeric(Left));
          Dest.Add(Dest.Owner.NewNumeric(Top));
          Dest.Add(Dest.Owner.NewNumeric(Zoom / 100));
         end;
        2: Dest.Add(Dest.Owner.NewName('Fit'));
        3:
        begin
          Dest.Add(Dest.Owner.NewName('FitH'));
          Dest.Add(Dest.Owner.NewNumeric(Top));
        end;
        4:
        begin
          Dest.Add(Dest.Owner.NewName('FitV'));
          Dest.Add(Dest.Owner.NewNumeric(Left));
        end;
        5:
        begin
          Dest.Add(Dest.Owner.NewName('FitR'));
          Dest.Add(Dest.Owner.NewNumeric(Left));
          Dest.Add(Dest.Owner.NewNumeric(Bottom));
          Dest.Add(Dest.Owner.NewNumeric(Right));
          Dest.Add(Dest.Owner.NewNumeric(Top));
        end;
        6: Dest.Add(Dest.Owner.NewName('FitB'));
        7:
        begin
          Dest.Add(Dest.Owner.NewName('FitBH'));
          Dest.Add(Dest.Owner.NewNumeric(Top));
        end;
        8:
        begin
          Dest.Add(Dest.Owner.NewName('FitBV'));
          Dest.Add(Dest.Owner.NewNumeric(Left));
        end;
      end;
    end;
  end;
end;

function TQuickPDF.SetDestValue(DestID, ValueKey: Integer; NewValue: Double): Integer;
var
  Count: Integer;
  Dest: TPDFArray;
  DestType: Integer;
begin
  Result := 0;
  Dest := GetDestArray(DestID);
  if (Assigned(Dest)) then
  begin
    DestType := GetDestType(DestID);
    Count := Dest.Count;
    case ValueKey of
      1: // Left
      begin
        if ((DestType = 1) or (DestType = 4) or (DestType = 5) or (DestType = 8)) and
          (Count >= 3) and (Dest.Item[2] is TPDFNumeric) then
        begin
          TPDFNumeric(Dest.Item[2]).SetTo(TranslateX(NewValue));
          Result := 1;
        end;
      end;

      2: // Top
      begin
        if (DestType = 1) and
          (Count >= 4) and (Dest.Item[3] is TPDFNumeric) then
        begin
          TPDFNumeric(Dest.Item[3]).SetTo(TranslateY(NewValue));
          Result := 1;
        end;

        if ((DestType = 3) or (DestType = 7)) and
          (Count >= 3) and (Dest.Item[2] is TPDFNumeric) then
        begin
          TPDFNumeric(Dest.Item[2]).SetTo(TranslateY(NewValue));
          Result := 1;
        end;

        if (DestType = 5) and
          (Count >= 6) and (Dest.Item[5] is TPDFNumeric) then
        begin
          TPDFNumeric(Dest.Item[5]).SetTo(TranslateY(NewValue));
          Result := 1;
        end;
      end;

      3: // Bottom
      begin
        if (DestType = 5) and
          (Count >= 4) and (Dest.Item[3] is TPDFNumeric) then
        begin
          TPDFNumeric(Dest.Item[3]).SetTo(TranslateY(NewValue));
          Result := 1;
        end;
      end;

      4: // Right
      begin
        if (DestType = 5) and
          (Count >= 5) and (Dest.Item[4] is TPDFNumeric) then
        begin
          TPDFNumeric(Dest.Item[4]).SetTo(TranslateX(NewValue));
          Result := 1;
        end;
      end;

      5: // Zoom
      begin
        if (DestType = 1) and
          (Count >= 5) and (Dest.Item[4] is TPDFNumeric) then
        begin
          TPDFNumeric(Dest.Item[4]).SetTo(NewValue / 100);
          Result := 1;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.DrawIntelligentMailBarcode(Left, Top, BarWidth,
  FullBarHeight, TrackerHeight, SpaceWidth: Double;
  const BarcodeData: WideString; Options: Integer): Integer;
var
  BarText: WideString;
  Rotation: TBarcodeRotation;
  PainterState: AnsiString;
  BarWidthReduction: Boolean;
begin
  FLastErrorCode := 0;

  PainterState := FSelDoc.PageTree.Painter.GetState;
  try
    BarWidthReduction := Options >= 10;
    if (BarWidthReduction) then
    begin
      Dec(Options, 10);
    end;

    Rotation := brNormal;

    BarText := BarcodeData;
    if (Copy(BarText, Length(BarText) - 2, 3)) = '/RC' then Rotation := brClockwise;
    if (Copy(BarText, Length(BarText) - 2, 3)) = '/RA' then Rotation := brAntiClockwise;
    if (Copy(BarText, Length(BarText) - 2, 3)) = '/RU' then Rotation := brUpsideDown;
    if (Rotation <> brNormal) then
    begin
      Delete(BarText, Length(BarText) - 2, 3);
    end;

    if not (FSelDoc.FillSet) then
    begin
      SetFillColor(0, 0, 0);
      FSelDoc.FillSet := False;
    end;

    Result := FSelDoc.PageTree.Painter.DrawIntelligentMailBarcode(TranslateX(Left), TranslateY(Top),
      GetScale(BarWidth), GetScale(FullBarHeight), GetScale(TrackerHeight), GetScale(SpaceWidth),
      BarText, Options, Rotation,
      BarWidthReduction);
  finally
    FSelDoc.PageTree.Painter.SetState(PainterState);
  end;
end;

function TQuickPDF.ReleaseImage(ImageID: Integer): Integer;
var
  Image: TPDFImage;
begin
  Result := 0;
  Image := ValidImageID(ImageID);
  if (Assigned(Image) and FSelDoc.IsImage(Image)) then
  begin
    if (FSelDoc.ReleaseImage(Image)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.ReleaseImageList(ImageListID: Integer): Integer;
var
  VCLObj: TObject;
  ImageList: TPDFImageList;
begin
  Result := 0;
  VCLObj := IntUncast(ImageListID);
  if (VCLObj is TPDFImageList) then
  begin
    ImageList := TPDFImageList(VCLObj);
    if (FSelDoc.IsImageList(ImageList)) then
    begin
      if (FSelDoc.ReleaseImageList(ImageList)) then
      begin
        Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.DAReleaseImageList(FileHandle,
  ImageListID: Integer): Integer;
var
  Link: TSmartPDFLink;
  ImageList: TPDFImageList;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if (Assigned(Link)) then
  begin
    ImageList := ValidImageListID(Link, ImageListID);
    if (Assigned(ImageList)) then
    begin
      if (Link.Doc.ReleaseImageList(ImageList)) then
      begin
        Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.GetOptionalContentConfigLocked(OptionalContentConfigID,
  OptionalContentGroupID: Integer): Integer;
var
  OCGRef: TPDFIndRef;
begin
  Result := 0;
  OCGRef := ValidOCG(OptionalContentGroupID);
  if Assigned(OCGRef) then
  begin
    if (FSelDoc.GetOptionalContentConfigLocked(OptionalContentConfigID,
      OCGRef)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.SetOptionalContentConfigLocked(OptionalContentConfigID,
  OptionalContentGroupID, NewLocked: Integer): Integer;
var
  OCGRef: TPDFIndRef;
begin
  Result := 0;
  OCGRef := ValidOCG(OptionalContentGroupID);
  if (Assigned(OCGRef) and (NewLocked >= 0) and (NewLocked <= 1)) then
  begin
    if (FSelDoc.SetOptionalContentConfigLocked(OptionalContentConfigID,
      OCGRef, NewLocked = 1)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.AddSWFAnnotationFromFile(Left, Top, Width, Height: Double;
  const FileName, Title: WideString; Options: Integer): Integer;
var
  FS: TQuickPDFWideFileStream;
begin
  Result := 0;
  if QPLFileExists(FileName) then
  try
    FS := QPLCreateFileStream(FileName, fmOpenRead or fmShareDenyWrite);
    try
      FSelDoc.PageTree.AddSWFAnnotation(TranslateX(Left), TranslateY(Top),
        GetScale(Width), GetScale(Height), FS,
        Title, AnsiString(QPLExtractFileName(FileName)), Options);
      Result := 1;
    finally
      FS.Free;
    end;
  except
  end;
end;

function TQuickPDF.SetAnnotIntProperty(Index, Tag, NewValue: Integer): Integer;
var
  PageRef: TPDFIndRef;
begin
  Result := 0;
  if (Tag = 131) then
  begin
    PageRef := FSelDoc.PageTree.GetPageRef(NewValue);
    if (FSelDoc.PageTree.Annots.SetIndRefProp(Index - 1, Tag, PageRef)) then
    begin
      Result := 1;
    end;
  end else
  begin
    if (FSelDoc.PageTree.Annots.SetIntegerProp(Index - 1, Tag, NewValue)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.NewTilingPatternFromCapturedPage(
  const PatternName: WideString; CaptureID: Integer): Integer;
var
  CP: TPDFCapturedPage;
  Obj: TPDFObject;
begin
  Result := 0;
  try
    CP := ValidCaptureID(CaptureID);
    if Assigned(CP) then
    begin
      Obj := CP.XObject.Obj;
      if (Obj is TPDFStream) then
      begin
        if (Assigned(FSelDoc.NewTilingPattern(AnsiString(PatternName),
          TPDFStream(Obj)))) then
        begin
          Result := 1;
        end;
      end;
    end;
  except
  end;
end;

function TQuickPDF.SetFillTilingPattern(const PatternName: WideString): Integer;
var
  TilingPattern: TPDFTilingPattern;
begin
  TilingPattern := FSelDoc.FindTilingPattern(AnsiString(PatternName));
  if Assigned(TilingPattern) then
  begin
    Result := 1;
    FSelDoc.PageTree.UsePattern(TilingPattern.CSName, TilingPattern.CS);
    FSelDoc.PageTree.Painter.SetFillPattern(TilingPattern.CSName);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetXFAToString(Options: Integer): AnsiString;
begin
  Result := '';
  if (FSelDoc.HasFormData) then
  begin
    Result := FSelDoc.AcroForm.GetCompleteXFA;
  end;
end;

function TQuickPDF.SetXFAFromString(const Source: AnsiString;
  Options: Integer): Integer;
var
  Stream: TPDFStream;
begin
  Result := 0;
  if (FSelDoc.HasFormData) then
  begin
    Result := 1;
    Stream := FSelDoc.Structure.NewStream(Source, True);
    FSelDoc.AcroForm.SetCompleteXFA(FSelDoc.NewObjRef(Stream));
  end;
end;

function TQuickPDF.GetFormFieldObjectNumber(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.FieldRef.ObjNum;
    if Field.TempField then
    begin
      Field.Free;
    end;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetTextExtractionScaling(Options: Integer; Horizontal,
  Vertical: Double): Integer;
begin
  Result := 0;
  if (Options = 0) then
  begin
    if ((Horizontal >= 1) and (Vertical >= 1)) then
    begin
      FSelDoc.TextExtractOptions.HorzScaleFactor := Horizontal;
      FSelDoc.TextExtractOptions.VertScaleFactor := Vertical;
      Result := 1;
    end;
  end;
end;

function TQuickPDF.DASetTextExtractionScaling(Options: Integer; Horizontal,
  Vertical: Double): Integer;
begin
  Result := 0;
  if (Options = 0) then
  begin
    if ((Horizontal >= 1) and (Vertical >= 1)) then
    begin
      FDATextExtractOptions.HorzScaleFactor := Horizontal;
      FDATextExtractOptions.VertScaleFactor := Vertical;
      Result := 1;
    end;
  end;
end;

function TQuickPDF.SetAnnotDblProperty(Index, Tag: Integer;
  NewValue: Double): Integer;
begin
  Result := 0;

  case Tag of
    105: NewValue := TranslateX(NewValue);
    106: NewValue := TranslateY(NewValue);
    107: NewValue := GetScale(NewValue);
    108: NewValue := GetScale(NewValue);
  end;

  if (FSelDoc.PageTree.Annots.SetDoubleProp(Index - 1, Tag, NewValue)) then
  begin
    Result := 1;
  end;
end;

function TQuickPDF.TransformFile(const InputFileName, Password,
  OutputFileName: WideString; TransformType, Options: Integer): Integer;
var
  Transform: TQuickPDFTransformer;
begin
  Result := 0;
  if ((TransformType = 1) or (TransformType = 2)) then
  begin
    Transform := TQuickPDFTransformer.Create;
    try
      case Transform.OpenPDF(InputFileName, Password) of
        ptOkay:
        begin
          Transform.SetTransformType(TransformType, Options);
          if (Transform.SaveToFile(OutputFileName)) then
          begin
            Result := 1;  // Success
          end else
          begin
            Result := 5;  // Could not write output file
          end;
        end;
        ptFileNotFound: Result := 2;  // Input PDF not found
        ptCannotRead: Result := 3;    // Input PDF cannot be read
        ptWrongPassword: Result := 4; // Input PDF password incorrect
      end;
    finally
      Transform.Free;
    end;
  end;
end;

function TQuickPDF.SetAnnotRect(Index: Integer; Left, Top, Width,
  Height: Double): Integer;
begin
  if (FSelDoc.PageTree.Annots.SetRect(Index - 1, TranslateX(Left),
    TranslateY(Top), GetScale(Width), GetScale(Height))) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.AddStampAnnotation(Left, Top, Width, Height: Double;
  StampType: Integer; const Title, Contents: WideString; Red, Green,
  Blue: Double; Options: Integer): Integer;
begin
  Result := 0;
  if (FSelDoc.PageTree.AddStampAnnotation(TranslateX(Left), TranslateY(Top),
    GetScale(Width), GetScale(Height), StampType, Title, Contents,
    Red, Green, Blue, Options)) then
  begin
    Result := 1;
  end;
end;

function TQuickPDF.AddStampAnnotationFromImage(Left, Top, Width, Height: Double;
  const FileName: WideString; const Title, Contents: WideString; Red, Green,
  Blue: Double; Options: Integer): Integer;
  var
  ImageData: AnsiString;
  ImageFile: TQuickPDFWideFileStream;
  begin
  Result := 0;
  try
    if (FileName <> '') then
    begin
      try
        ImageFile := TQuickPDFWideFileStream.Create(FileName, fmOpenRead);
        SetLength(ImageData, ImageFile.Size);
        if (Length(ImageData) > 0) then
        begin
          ImageFile.Read(ImageData[1], ImageFile.Size);
        end;
        ImageFile.Free;
      finally
      end;
    end;
   if (FSelDoc.PageTree.AddStampAnnotationFromImage(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), ImageData, 0, Title, Contents,
      Red, Green, Blue, Options)) then
    begin
      Result := 1;
    end;
  finally
  end;
end;

function TQuickPDF.AddStampAnnotationFromImageID(Left, Top, Width, Height: Double;
  ImageID: Integer; const Title, Contents: WideString; Red, Green,
  Blue: Double; Options: Integer): Integer;
  var
   PDFImage: TPDFImage;
  begin
  Result := 0;
  try
    PDFImage := ValidImageID(ImageID);
    if (FSelDoc.PageTree.AddStampAnnotationFromImageID(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), PDFImage, 0, Title, Contents,
      Red, Green, Blue, Options)) then
    begin
      Result := 1;
    end;
  finally
  end;
end;

function TQuickPDF.GetDocumentRepaired: Integer;
begin
  if (FSelDoc.Repaired) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.CopyPageRangesEx(DocumentID: Integer;
  const RangeList: WideString; Options: Integer): Integer;
var
  OldPage: Integer;
  Document: TPDFDocument;
  SortList: Boolean;
  AllowDuplicates: Boolean;
begin
  Result := 0;
  OldPage := SelectedPage;
  try
    Document := ValidDocumentID(DocumentID);
    if (FDocs.IndexOf(Document) >= 0) then
    begin
      if (Document <> FSelDoc) then
      begin
        NewPage;
        SortList := True;
        AllowDuplicates := False;
        if (Options = 1) then
        begin
          SortList := False;
          AllowDuplicates := True;
        end;
        if (FSelDoc.CopyPagesFromDoc(Document, AnsiString(RangeList), SortList, AllowDuplicates)) then
        begin
          Result := 1;
        end else
        begin
          FLastErrorCode := 412;
          DeletePages(SelectedPage, 1);
          SelectPage(OldPage);
        end;
      end;
    end;
  except
  end;
end;

function TQuickPDF.UpdateAndFlattenFormField(Index: Integer): Integer;
begin
  Result := UpdateFlatten(Index, True);
end;

function TQuickPDF.BalanceContentStream: Integer;
var
  Balancer: TPDFContentStreamStackBalancer;
  CS: AnsiString;
begin
  Balancer := TPDFContentStreamStackBalancer.Create(0);
  try
    CS := GetContentStreamToString;
    Balancer.Process(CS);
    SetContentStreamFromString('q ' + CS + ' Q ' + Balancer.GetBalancingSuffix);
  finally
    Balancer.Free;
  end;
  FSelDoc.PageTree.Painter.ChangeAll;
  Result := 1;
end;

function TQuickPDF.AddFormFieldChoiceSub(Index: Integer; const SubName,
  DisplayName: WideString): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) and (Field.FieldType = ftChoice) then
  begin
    Field.AddChoiceOpt(SubName, DisplayName);
  end;
end;

function TQuickPDF.GetFormFieldSubDisplayName(Index,
  SubIndex: Integer): WideString;
var
  Field: TPDFField;
begin
  Result := '';
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
        Result := QPLUTF8Decode(Field.GetDisplayName(SubIndex - 1));
    end;
  end;
end;

function TQuickPDF.SetOptionalContentGroupName(OptionalContentGroupID: Integer;
  NewGroupName: WideString): Integer;
var
  OCGRef: TPDFIndRef;
begin
  Result := 0;
  OCGRef := ValidOCG(OptionalContentGroupID);
  if Assigned(OCGRef) then
  begin
    if (FSelDoc.SetOCGName(OCGRef, NewGroupName)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.RemoveOpenAction: Integer;
begin
  if FSelDoc.RemoveOpenAction then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.RemoveFormFieldBackgroundColor(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.RemoveBackgroundColor;
    Result := 1;
    if Field.TempField then
    begin
      Field.Free;
    end;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetFormFieldBorderColorType(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.GetBorderColorType;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.GetFormFieldBackgroundColorType(Index: Integer): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.GetBackgroundColorType;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldBackgroundColorGray(Index: Integer;
  G: Double): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.SetBackgroundColor(G);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldBorderColorGray(Index: Integer;
  G: Double): Integer;
var
  Field: TPDFField;
begin
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Field.SetBorderColor(G);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.SetFormFieldSignatureImage(Index, ImageID, Options: Integer): Integer;
var
  Field: TPDFField;
  Image: TPDFImage;
begin
  Field := FindFormField(Index);
  Image := ValidImageID(ImageID);
  if (Assigned(Field) and Assigned(Image) and FSelDoc.IsImage(Image)) then
  begin
    Field.SetSignatureImage(Image.IndRef, Options);
    Result := 1;
    if Field.TempField then Field.Free;
  end else
    Result := 0;
end;

function TQuickPDF.GetFormFieldCheckStyle(Index: Integer): Integer;
var
  Field: TPDFField;
  CheckStyle: TPDFFormFieldCheckStyle;
begin
  CheckStyle := csNone;
  Result := Ord(CheckStyle);
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    CheckStyle := Field.GetCheckStyle;
    Result := Ord(CheckStyle);
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.GetFormFieldTabOrderEx(Index, Options: Integer): Integer;
var
  Field: TPDFField;
  Page: Integer;
  A: TPDFArray;
  O: TPDFObject;
  D: TPDFDictionary;
  X, I: Integer;
  TempField: TPDFField;
  Obj: TPDFObject;
  AnnotList: array of TPDFFormTabOrder;
  CurrTabOrder: Integer;
begin
  Result := 0;
  Field := FindFormField(Index);

  if Assigned(Field) and ((Options = 0) or (Options = 1)) then
  begin
    Page := Field.Page;
    if (Field.Page = -1) then
    begin
      if Field.KidCount >= 1 then
      begin

        I := 1;
        if (Index and $55000000) = $55000000 then
          I := Index and $FF;

        TempField := Field.MakeTempChild(I);
        if Assigned(TempField) then
        begin
          Page := TempField.Page;
        end;
      end;
    end;

    D := FSelDoc.PageTree.GetPage(Page);
    if Assigned(D) then
    begin
      O := D.FindValueByKeyName('Annots', True);
      if O is TPDFArray then
      begin
        A := TPDFArray(O);
        SetLength(AnnotList, A.Count);

        for X := 0 to A.Count - 1 do
        begin
          Obj := A.Item[X];

          if (Obj is TPDFIndRef) then
            Obj := TPDFIndRef(Obj).Obj;

          AnnotList[X].ObjNum := 0;
          AnnotList[X].ParentObjNum := 0;
          AnnotList[X].TabOrder := 0;

          if (Obj is TPDFDictionary) then
          begin
            AnnotList[X].ObjNum := Obj.IndObjNum + Obj.IndGenNum shl 32;
            Obj := TPDFDictionary(Obj).FindValueByKeyName('Parent', true);
            if Assigned(Obj) then
              AnnotList[X].ParentObjNum := Obj.IndObjNum + Obj.IndGenNum shl 32;
          end;
        end;

        for I := 1 to FSelDoc.AcroForm.FieldsArray.Count do
        begin
          Field := FindFormField(I);
          for X := 0 to A.Count - 1 do
          begin
             if Field.FieldRef.ObjNum + Field.FieldRef.GenNum shl 32 = AnnotList[X].ObjNum then
             begin
               AnnotList[X].FieldType := Field.FieldType;
             end else
             if Field.FieldRef.ObjNum + Field.FieldRef.GenNum shl 32 = AnnotList[X].ParentObjNum then
             begin
               AnnotList[X].FieldType := Field.FieldType;
             end;
          end;
        end;

        CurrTabOrder := 1;
        AnnotList[0].TabOrder := 1;

        for X := 1 to A.Count - 1 do
        begin
          if (Options = 0) then
          begin
            if (AnnotList[X].ParentObjNum = 0) or (AnnotList[X].ParentObjNum <> AnnotList[X-1].ParentObjNum) then
              Inc(CurrTabOrder)
            else if (AnnotList[X].FieldType = ftCheckBox) then
              Inc(CurrTabOrder);
          end else
          if (Options = 1) then
          begin
            Inc(CurrTabOrder);
          end;

          AnnotList[X].TabOrder := CurrTabOrder;
        end;

        Field := FindFormField(Index);

        for X := 0 to A.Count - 1 do
          if Field.FieldRef.ObjNum + Field.FieldRef.GenNum shl 32 = AnnotList[X].ObjNum then
            Result := AnnotList[X].TabOrder
          else if (Result = 0) and (Field.FieldRef.ObjNum + Field.FieldRef.GenNum shl 32 = AnnotList[X].ParentObjNum) then
            Result := AnnotList[X].TabOrder;

      end;
    end;
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.SetSignProcessField(SignProcessID: Integer;
  const SignatureFieldName: WideString): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    SignProcess.SignatureFieldName := SignatureFieldName;
    Result := 1;
  end;
end;

function TQuickPDF.SetSignProcessInfo(SignProcessID: Integer; const Reason,
  Location, ContactInfo: WideString): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    SignProcess.Reason := Reason;
    SignProcess.Location := Location;
    SignProcess.ContactInfo := ContactInfo;
    Result := 1;
  end;
end;

function TQuickPDF.SetSignProcessPFXFromFile(SignProcessID: Integer; const PFXFileName,
  PFXPassword: WideString): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    SignProcess.PFXDataType := dtFile;
    SignProcess.PFXFileName := PFXFileName;
    SignProcess.PFXPassword := PFXPassword;
    Result := 1;
  end;
end;

function TQuickPDF.NewSignProcessFromFile(const InputFile,
  Password: WideString): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  if QPLFileExists(InputFile) then
  begin
    SignProcess := TQuickPDFSignProcess.Create;
    SignProcess.SourceDataType := dtFile;
    SignProcess.SourceFileName := InputFile;
    SignProcess.SourcePassword := Password;
    FSignProcessList.Add(SignProcess);
    Result := IntCast(SignProcess);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.NewSignProcessFromStream(InputStream: TStream; const Password: WideString): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  SignProcess := TQuickPDFSignProcess.Create;
  SignProcess.SourceDataType := dtStream;
  SignProcess.SourceStream := InputStream;
  SignProcess.SourcePassword := Password;
  FSignProcessList.Add(SignProcess);
  Result := IntCast(SignProcess);
end;

function TQuickPDF.NewSignProcessFromString(
  const Source: AnsiString; const Password: WideString): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  SignProcess := TQuickPDFSignProcess.Create;
  SignProcess.SourceDataType := dtString;
  SignProcess.SourceString := Source;
  SignProcess.SourcePassword := Password;
  FSignProcessList.Add(SignProcess);
  Result := IntCast(SignProcess);
end;

function TQuickPDF.EndSignProcessToFile(SignProcessID: Integer;
  const OutputFile: WideString): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    SignProcess.TargetDataType := dtFile;
    SignProcess.TargetFileName := OutputFile;
    SignProcess.Sign;
  end;
end;

function TQuickPDF.EndSignProcessToStream(SignProcessID: Integer;
  OutputStream: TStream): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    SignProcess.TargetDataType := dtStream;
    SignProcess.TargetStream := OutputStream;
    SignProcess.Sign;
  end;
end;

function TQuickPDF.EndSignProcessToString(SignProcessID: Integer): AnsiString;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := '';
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    SignProcess.TargetDataType := dtString;
    SignProcess.Sign;
    Result := SignProcess.TargetString;
  end;
end;

function TQuickPDF.DAExtractPageTextBlocks(FileHandle, PageRef, ExtractOptions: Integer): Integer;
var
  TextList: TPDFTextList;
  Link: TSmartPDFLink;
  Page: TPDFIndRef;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    Page := ValidPageRef(Link, PageRef);
    if Assigned(Page) then
    begin
      TextList := Link.Doc.GetPageTextList(Page, ExtractOptions, FDATextExtractOptions);
      if Assigned(TextList) then
      begin
        FTextBlockLists.Add(TextList);
        Result := IntCast(TextList);
      end;
    end;
  end;
end;

function TQuickPDF.ExtractPageTextBlocks(ExtractOptions: Integer): Integer;
var
  Prefix: AnsiString;
  Funnel: TPDFTextFunnel;
  TextList: TPDFTextList;
begin
  Result := 0;
  FLastErrorCode := 0;
  if (ExtractOptions >= 3) and (ExtractOptions <= 4) then
  begin
    Prefix := '';

    Funnel := TPDFTextFunnel.Create;
    Funnel.Origin := FSelDoc.Origin;
    Funnel.Scale := FSelDoc.Scale;
    Funnel.PageWidth := FSelDoc.PageTree.PageWidth;
    Funnel.PageHeight := FSelDoc.PageTree.PageHeight;
    Funnel.WordGap := FSelDoc.TextExtractOptions.WordGap;
    Funnel.IgnoreFont := FSelDoc.TextExtractOptions.IgnoreFont;
    Funnel.IgnoreColor := FSelDoc.TextExtractOptions.IgnoreColor;
    Funnel.IgnoreBlocks := FSelDoc.TextExtractOptions.IgnoreBlocks;
    Funnel.SortBlocks := FSelDoc.TextExtractOptions.SortBlocks;
    Funnel.IgnoreDescenders := FSelDoc.TextExtractOptions.IgnoreDescenders;
    Funnel.IgnoreOverlaps := FSelDoc.TextExtractOptions.IgnoreOverlaps;
    Funnel.IgnoreDuplicates := FSelDoc.TextExtractOptions.IgnoreDuplicates;
    Funnel.OutputCMYK := FSelDoc.TextExtractOptions.OutputCMYK;
    Funnel.HorzScaleFactor := FSelDoc.TextExtractOptions.HorzScaleFactor;
    Funnel.VertScaleFactor := FSelDoc.TextExtractOptions.VertScaleFactor;
    Funnel.SpecialMatch := FSelDoc.TextExtractOptions.SpecialMatch;
    Funnel.IgnoreRotated := FSelDoc.TextExtractOptions.IgnoreRotated;
    Funnel.TrimWhitespace := FSelDoc.TextExtractOptions.TrimWhitespace;
    Funnel.OutputNonAscii := FSelDoc.TextExtractOptions.OutputNonAscii;
    Funnel.RemoveUnderscoreLines := FSelDoc.TextExtractOptions.RemoveUnderscoreLines;
    if (FSelDoc.TextExtractOptions.HasArea) then
    begin
      Funnel.SetArea(FSelDoc.TextExtractOptions.AreaLeft,
        FSelDoc.TextExtractOptions.AreaTop, FSelDoc.TextExtractOptions.AreaWidth,
        FSelDoc.TextExtractOptions.AreaHeight);
    end;
    if (ExtractOptions = 4) then
      Funnel.SplitWords := True;

    TextList := FSelDoc.PageTree.GetTextList(ExtractOptions, Funnel);
    if (Assigned(TextList)) then
    begin
      Result := IntCast(TextList);
    end else
    begin
      Result := 0;
    end;

    if Assigned(Funnel) then Funnel.Free;
  end;
end;

function TQuickPDF.GetTextBlockCount(TextBlockListID: Integer): Integer;
var
  TextList: TPDFTextList;
begin
  TextList := ValidTextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextCount;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetTextBlockFontName(TextBlockListID, Index: Integer): WideString;
var
  TextList: TPDFTextList;
begin
  TextList := ValidTextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := WideString(TextList.TextFontName(Index));
  end else
  begin
    Result := '';
  end;
end;

function TQuickPDF.GetTextBlockFontSize(TextBlockListID, Index: Integer): Double;
var
  TextList: TPDFTextList;
begin
  TextList := ValidTextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextFontSize(Index);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetTextBlockBound(TextBlockListID, Index, BoundIndex: Integer): Double;
var
  TextList: TPDFTextList;
begin
  TextList := ValidTextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
      Result := TextList.TextBounds(Index, BoundIndex);

      case (BoundIndex mod 2) of
        0: if (FSelDoc.Origin = 1) or (FSelDoc.Origin = 2) then  // Y values
           Result := FSelDoc.PageTree.PageHeight - Result;
        1: if (FSelDoc.Origin = 2) or (FSelDoc.Origin = 3) then  // X values
           Result := FSelDoc.PageTree.PageWidth - Result;
      end;
      Result := Result * FSelDoc.Scale;
  end
  else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetTextBlockColorType(TextBlockListID, Index: Integer): Integer;
var
  TextList: TPDFTextList;
begin
  TextList := ValidTextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextColorType(Index);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetTextBlockColor(TextBlockListID, Index, ColorComponent: Integer): Double;
var
  TextList: TPDFTextList;
begin
  TextList := ValidTextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextColor(Index, ColorComponent);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetTextBlockText(TextBlockListID, Index: Integer): WideString;
var
  TextList: TPDFTextList;
begin
  TextList := ValidTextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextString(Index);
  end else
  begin
    Result := '';
  end;
end;

function TQuickPDF.GetTextBlockCharWidth(TextBlockListID, Index, CharIndex: Integer): Double;
var
  TextList: TPDFTextList;
begin
  TextList := ValidTextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextCharWidth(Index, CharIndex) * FSelDoc.Scale;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.GetTextBlockAsString(TextBlockListID, Index: Integer): WideString;
var
  TextList: TPDFTextList;
begin
  TextList := ValidTextBlockListID(TextBlockListID);
  Result := '';
  if (Assigned(TextList)) then
    Result := TextList.TextBlockAsString(Index, FSelDoc.Origin, FSelDoc.PageTree.PageWidth, FSelDoc.PageTree.PageHeight, FSelDoc.Scale)
  else
    Result := '';
end;

function TQuickPDF.ReleaseTextBlocks(TextBlockListID: Integer): Integer;
var
  TextList: TPDFTextList;
begin
  Result := 0;
  TextList := ValidTextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    if (FSelDoc.ReleaseTextList(TextList)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.DAGetTextBlockAsString(TextBlockListID, Index: Integer): WideString;
var
  TextList: TPDFTextList;
begin
  TextList := ValidDATextBlockListID(TextBlockListID);
  Result := '';
  if (Assigned(TextList)) then
    Result := TextList.TextBlockAsString(Index, 0, 0, 0, 1) // DA Mode uses raw data
  else
    Result := '';
end;

function TQuickPDF.DAGetTextBlockBound(TextBlockListID, Index,
  BoundIndex: Integer): Double;
var
  TextList: TPDFTextList;
begin
  Result := 0;
  TextList := ValidDATextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextBounds(Index, BoundIndex);
  end;
end;

function TQuickPDF.DAGetTextBlockCharWidth(TextBlockListID, Index,
  CharIndex: Integer): Double;
var
  TextList: TPDFTextList;
begin
  Result := 0;
  TextList := ValidDATextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextCharWidth(Index, CharIndex);
  end;
end;

function TQuickPDF.DAGetTextBlockColor(TextBlockListID, Index,
  ColorComponent: Integer): Double;
var
  TextList: TPDFTextList;
begin
  Result := 0;
  TextList := ValidDATextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextColor(Index, ColorComponent);
  end;
end;

function TQuickPDF.DAGetTextBlockColorType(TextBlockListID,
  Index: Integer): Integer;
var
  TextList: TPDFTextList;
begin
  Result := 0;
  TextList := ValidDATextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextColorType(Index);
  end;
end;

function TQuickPDF.DAGetTextBlockCount(TextBlockListID: Integer): Integer;
var
  TextList: TPDFTextList;
begin
  Result := 0;
  TextList := ValidDATextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextCount;
  end;
end;

function TQuickPDF.DAGetTextBlockFontName(TextBlockListID,
  Index: Integer): WideString;
var
  TextList: TPDFTextList;
begin
  Result := '';
  TextList := ValidDATextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := WideString(TextList.TextFontName(Index));
  end;
end;

function TQuickPDF.DAGetTextBlockFontSize(TextBlockListID,
  Index: Integer): Double;
var
  TextList: TPDFTextList;
begin
  Result := 0;
  TextList := ValidDATextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextFontSize(Index);
  end;
end;

function TQuickPDF.DAGetTextBlockText(TextBlockListID,
  Index: Integer): WideString;
var
  TextList: TPDFTextList;
begin
  Result := '';
  TextList := ValidDATextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    Result := TextList.TextString(Index);
  end;
end;

function TQuickPDF.DAReleaseTextBlocks(TextBlockListID: Integer): Integer;
var
  TextList: TPDFTextList;
begin
  Result := 0;
  TextList := ValidDATextBlockListID(TextBlockListID);
  if (Assigned(TextList)) then
  begin
    if (FTextBlockLists.IndexOf(TextList) >= 0) then
    begin
      FTextBlockLists.Remove(TextList);
      Result := 1;
    end;
  end;
end;

function TQuickPDF.ExtractFilePageTextBlocks(const InputFileName,
  Password: WideString; Page, Options: Integer): Integer;
var
  FS: TQuickPDFWideFileStream;
  Reader: TSmartPDFReader;
  Info: TSmartPDFInfo;
  Doc: TSmartPDFDocument;
  TextList: TPDFTextList;
begin
  Result := 0;
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    try
      FS := QPLCreateFileStream(InputFileName, fmOpenRead or fmShareDenyWrite);
      try
        Reader := TSmartPDFReader.Create(FS);
        try
          if Reader.ErrorCode = ecNone then
          begin
            Info := TSmartPDFInfo.Create(Reader, '');
            try
              if ((Info.Encrypted = spEncrypted) and Info.CheckPassword(Password)) or
                (Info.Encrypted = spDecrypted) then
              begin
                Info.Password := Password;
                Info.GetBasic;
                Doc := TSmartPDFDocument.Create(Reader);
                try
                  Doc.SmartInfo := Info;
                  TextList := Doc.GetPageTextList(Doc.FindPage(Page), Options,
                    FDATextExtractOptions);
                  FTextBlockLists.Add(TextList);
                  Result := IntCast(TextList);
                finally
                  Doc.Free;
                end;
              end else
                FLastErrorCode := 404;
            finally
              Info.Free;
            end;
          end else
            FLastErrorCode := 409;
        finally
          Reader.Free;
        end;
      finally
        FS.Free;
      end;
    except
      FLastErrorCode := 401;
    end;
  end else
    FLastErrorCode := 999;
end;

function TQuickPDF.ReleaseStringList(StringListID: Integer): Integer;
var
  VCLObj: TObject;
begin
  VCLObj := IntUncast(StringListID);
  if (VCLObj is TStringList) then
  begin
    FStringLists.Remove(VCLObj);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.ExtractFilePages(const InputFileName, Password,
  OutputFileName, RangeList: WideString): Integer;
begin
  Result := ExtractFilePagesEx(InputFileName, Password, OutputFileName,
    RangeList, 0);
end;

function TQuickPDF.AddBoxToPath(Left, Top, Width, Height: Double): Integer;
begin
  FSelDoc.PageTree.Painter.AddBoxToPath(TranslateX(Left), TranslateY(Top),
    GetScale(Width), GetScale(Height));
  Result := 1;
end;

function TQuickPDF.SetSignProcessFieldImageFromFile(SignProcessID: Integer;
  const ImageFileName: WideString; Options: Integer): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    SignProcess.FieldImageFileName := ImageFileName;
    SignProcess.FieldImageOptions := Options;
    Result := 1;
  end;
end;

function TQuickPDF.SetSignProcessFieldBounds(SignProcessID: Integer; Left, Top,
  Width, Height: Double): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    SignProcess.SetFieldBounds := True;
    SignProcess.FieldBoundsLeft := Left;
    SignProcess.FieldBoundsTop := Top;
    SignProcess.FieldBoundsWidth := Width;
    SignProcess.FieldBoundsHeight := Height;
    Result := 1;
  end;
end;

function TQuickPDF.GetAnnotSoundToFile(Index, Options: Integer;
  const SoundFileName: WideString): Integer;
var
  SoundData: AnsiString;
  FileStream: TQuickPDFWideFileStream;
begin
  Result := 0;
  SoundData := GetAnnotSoundToString(Index, Options);
  if (SoundData <> '') then
  begin
    try
      FileStream := TQuickPDFWideFileStream.Create(SoundFileName, fmCreate);
    except
      FileStream := nil;
    end;
    if (Assigned(FileStream)) then
    begin
      try
        FileStream.Write(SoundData[1], Length(SoundData));
        Result := 1;
      finally
        FileStream.Free;
      end;
    end;
  end;
end;

function TQuickPDF.GetAnnotSoundToString(Index, Options: Integer): AnsiString;
begin
  Result := FSelDoc.PageTree.Annots.GetSound(Index - 1, Options);
end;

function TQuickPDF.GetFontFlags(FontFlagItemID: Integer): Integer;
begin
  if Assigned(FSelFont) then
  begin
    Result := FSelFont.GetFlags(FontFlagItemID);
  end else
    Result := 0;
end;

function TQuickPDF.GetPageMetricsToString(StartPage, EndPage,
  Options: Integer): AnsiString;
var
  PageNumber: Integer;
  PageDict: TPDFDictionary;
  Obj: TPDFObject;
  MediaBox: TPDFArray;
  CropBox: TPDFArray;
  Rotation: TPDFNumeric;
  ThisDict: TPDFDictionary;
  PageMetrics: array of array of Double;
  DoubleSize: Integer;
  ItemIndex: Integer;
  OutputPos: Integer;
  DoubleText: AnsiString;
begin
  Result := '';
  if (EndPage > PageCount) then
  begin
    EndPage := PageCount;
  end;
  if (EndPage < 1) then
  begin
    EndPage := 1;
  end;
  if (StartPage > PageCount) then
  begin
    StartPage := PageCount;
  end;
  if (StartPage < 1) then
  begin
    StartPage := 1;
  end;
  if ((Options = 1) or (Options = 2)) then
  begin
    if (EndPage >= StartPage) then
    begin
      SetLength(PageMetrics, EndPage - StartPage + 1);
    end;
    for PageNumber := StartPage to EndPage do
    begin
      SetLength(PageMetrics[PageNumber - StartPage], 9);
      PageDict := FSelDoc.PageTree.GetPage(PageNumber);

      // Get the MediaBox values
      ThisDict := PageDict;
      MediaBox := nil;
      repeat
        Obj := ThisDict.FindValueByKeyName('MediaBox');
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFArray then
        begin
          MediaBox := TPDFArray(Obj);
        end else
        begin
          Obj := ThisDict.FindValueByKeyName('Parent');
          if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFDictionary then ThisDict := TPDFDictionary(Obj)
            else ThisDict := nil;
        end;
      until (MediaBox is TPDFArray) or (ThisDict = nil);
      if (Assigned(MediaBox) and (MediaBox.Count = 4)) then
      begin
        Obj := MediaBox.Item[0];
        if Obj is TPDFNumeric then
          PageMetrics[PageNumber - StartPage][0] := TPDFNumeric(Obj).AsDouble;
        Obj := MediaBox.Item[1];
        if Obj is TPDFNumeric then
          PageMetrics[PageNumber - StartPage][1] := TPDFNumeric(Obj).AsDouble;
        Obj := MediaBox.Item[2];
        if Obj is TPDFNumeric then
          PageMetrics[PageNumber - StartPage][2] := TPDFNumeric(Obj).AsDouble;
        Obj := MediaBox.Item[3];
        if Obj is TPDFNumeric then
          PageMetrics[PageNumber - StartPage][3] := TPDFNumeric(Obj).AsDouble;
      end else
      begin
        PageMetrics[PageNumber - StartPage][0] := 0;
        PageMetrics[PageNumber - StartPage][1] := 0;
        PageMetrics[PageNumber - StartPage][2] := 0;
        PageMetrics[PageNumber - StartPage][3] := 0;
      end;

      // Get the CropBox values
      ThisDict := PageDict;
      CropBox := nil;
      repeat
        Obj := ThisDict.FindValueByKeyName('CropBox');
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFArray then
        begin
          CropBox := TPDFArray(Obj);
        end else
        begin
          Obj := ThisDict.FindValueByKeyName('Parent');
          if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFDictionary then ThisDict := TPDFDictionary(Obj)
            else ThisDict := nil;
        end;
      until (CropBox is TPDFArray) or (ThisDict = nil);
      if (Assigned(CropBox) and (CropBox.Count = 4)) then
      begin
        Obj := CropBox.Item[0];
        if Obj is TPDFNumeric then
          PageMetrics[PageNumber - StartPage][4] := TPDFNumeric(Obj).AsDouble;
        Obj := CropBox.Item[1];
        if Obj is TPDFNumeric then
          PageMetrics[PageNumber - StartPage][5] := TPDFNumeric(Obj).AsDouble;
        Obj := CropBox.Item[2];
        if Obj is TPDFNumeric then
          PageMetrics[PageNumber - StartPage][6] := TPDFNumeric(Obj).AsDouble;
        Obj := CropBox.Item[3];
        if Obj is TPDFNumeric then
          PageMetrics[PageNumber - StartPage][7] := TPDFNumeric(Obj).AsDouble;
      end else
      begin
        PageMetrics[PageNumber - StartPage][4] := PageMetrics[PageNumber - StartPage][0];
        PageMetrics[PageNumber - StartPage][5] := PageMetrics[PageNumber - StartPage][1];
        PageMetrics[PageNumber - StartPage][6] := PageMetrics[PageNumber - StartPage][2];
        PageMetrics[PageNumber - StartPage][7] := PageMetrics[PageNumber - StartPage][3];
      end;

      // Get the Rotation value
      ThisDict := PageDict;
      Rotation := nil;
      repeat
        Obj := ThisDict.FindValueByKeyName('Rotate');
        if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
        if Obj is TPDFNumeric then
        begin
          Rotation := TPDFNumeric(Obj);
        end else
        begin
          Obj := ThisDict.FindValueByKeyName('Parent');
          if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
          if Obj is TPDFDictionary then ThisDict := TPDFDictionary(Obj)
            else ThisDict := nil;
        end;
      until (Rotation is TPDFNumeric) or (ThisDict = nil);
      if (Assigned(Rotation)) then
      begin
        PageMetrics[PageNumber - StartPage][8] := Rotation.AsDouble;
      end else
      begin
        PageMetrics[PageNumber - StartPage][8] := 0;
      end;
    end;

    if (Length(PageMetrics) > 0) then
    begin
      if (Options = 1) then
      begin
        // Binary output
        DoubleSize := SizeOf(Double);
        SetLength(Result, DoubleSize * Length(PageMetrics) * 9);

        OutputPos := 1;
        for PageNumber := 0 to Length(PageMetrics) - 1 do
        begin
          for ItemIndex := 0 to 8 do
          begin
            Move(PageMetrics[PageNumber][ItemIndex], Result[OutputPos], DoubleSize);
            Inc(OutputPos, DoubleSize);
          end;
        end;
      end else
      if (Options = 2) then
      begin
        // Text output
        Result := '';

        for PageNumber := 0 to Length(PageMetrics) - 1 do
        begin
          DoubleText := '';
          for ItemIndex := 0 to 8 do
          begin
            DoubleText := DoubleText + QPLDoubleToStr(PageMetrics[PageNumber][ItemIndex], 4) + #9;
          end;
          if (QPLEndsWith(DoubleText, #9)) then
          begin
            Delete(DoubleText, Length(DoubleText), 1);
          end;
          Result := Result + DoubleText + #13#10;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.SetSignProcessSubFilter(SignProcessID,
  SubFilter: Integer): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    if (SubFilter = 1) then
    begin
      SignProcess.SubFilter := 'adbe.pkcs7.sha1';
      Result := 1;
    end else
    if (SubFilter = 2) then
    begin
      SignProcess.SubFilter := 'adbe.pkcs7.detached';
      Result := 1;
    end;
  end;
end;

function TQuickPDF.SetSignProcessCustomSubFilter(SignProcessID: Integer;
  SubFilterStr: WideString): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    SignProcess.SubFilter := AnsiString(SubFilterStr);
    Result := 1;
  end;
end;

function TQuickPDF.GetSignProcessResult(SignProcessID: Integer): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    Result := SignProcess.SignResult;
  end;
end;

function TQuickPDF.ReleaseSignProcess(SignProcessID: Integer): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    FSignProcessList.Remove(SignProcess);
    //SignProcess.Free;   // DPL-344 D14394 - Causing crash in Delphi
    Result := 1;
  end;
end;

function TQuickPDF.PrintPages(const PrinterName, PageRanges: WideString;
  Options: Integer): Integer;
var
  LocalPrinter: TPrinter;
  CustomPrinterIndex: Integer;
  OriginalPrinterName: WideString;
{$IFNDEF UNICODE}
  PrinterNameA: AnsiString;
  OriginalPrinterNameA: AnsiString;
{$ENDIF}
  CustomPrinter: TPDFCustomPrinter;
begin
  if (ValidPrinterName(PrinterName)) then
  begin
    FLastRenderError := '';
    LocalPrinter := GetPrinter;
    CustomPrinterIndex := FCustomPrinters.IndexOf(QPLUpperCase(AnsiString(PrinterName)));
    if (CustomPrinterIndex >= 0) then
    begin
      CustomPrinter := TPDFCustomPrinter(FCustomPrinters.Objects[CustomPrinterIndex]);
      OriginalPrinterName := CustomPrinter.OriginalPrinterName;
{$IFDEF UNICODE}
      LocalPrinter.SetPrinter(@OriginalPrinterName[1], 'WINSPOOL', '', 0);
{$ELSE}
      OriginalPrinterNameA := AnsiString(OriginalPrinterName);
      LocalPrinter.SetPrinter(@OriginalPrinterNameA[1], 'WINSPOOL', '', 0);
{$ENDIF}
      CustomPrinter.SetPrinter(LocalPrinter, FPrinterDevMode);
    end else
    begin
{$IFDEF UNICODE}
      LocalPrinter.SetPrinter(@PrinterName[1], 'WINSPOOL', '', 0);
{$ELSE}
      PrinterNameA := AnsiString(PrinterName);
      LocalPrinter.SetPrinter(@PrinterNameA[1], 'WINSPOOL', '', 0);
{$ENDIF}
    end;
    Result := PrintPagesToPrinterObject(LocalPrinter, PageRanges, Options);
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.PrintPagesToPrinterObject(APrinter: TPrinter;
  const PageRanges: WideString; Options: Integer): Integer;
var
  OldPage: Integer;
  TitleIndex: Integer;
  LocalPrinter: TPrinter;
  QPLPrinter: TQPLPrinter;
  UseLocal: Boolean;
  PrintingCancelled: Boolean;

  procedure ReportProgress(Code: Integer);
  begin
{$IFDEF QPL_OS_WINDOWS}
    if (FGDIPlusSettings.ProgressWindow > 0) then
    begin
      SendMessage(FGDIPlusSettings.ProgressWindow, FGDIPlusSettings.ProgressMessage,
        FGDIPlusSettings.ProgressData, Code);
    end;
{$ENDIF}
  end;

begin
  FLastRenderError := '';
  FPrinterJobID := 0;
  LocalPrinter := APrinter;
  OldPage := SelectedPage;
  try
    Result := 1;

    if Result > 0 then
    begin
      UseLocal := False;

      // Check conditions to use local printing
      if Length(FPrintToFile) > 0 then UseLocal := True;
      if FPrinterStatusNeeded then UseLocal := True;
      if FPrinterStartPaused then UseLocal := True;

      QPLPrinter := TQPLPrinter.Create(LocalPrinter, FPrintToFile, UseLocal);
      try
        if (FPrintPreview) then
        begin
          QPLPrinter.SetupPreview(FPrintPreviewMaxDimension);
        end;

        if FPrinterStartPaused then
        begin
          QPLPrinter.SetStartPaused(True);
        end;

        TitleIndex := Options and $FFFF00 shr 8;
        Dec(TitleIndex, 450);
        if (TitleIndex >= 0) and (TitleIndex < FPrintTitles.Count) then
          QPLPrinter.Title := QPLAnsiToNative(FPrintTitles[TitleIndex])
        else
          QPLPrinter.Title := 'Quick PDF Library Document';

        PrintingCancelled := False;
        QPLPrinter.BeginDoc;
        ReportProgress(1020);
        try
          if QPLPrinter.Printing then
          begin
            QPLPrinter.Canvas.Font.Name := 'Arial';
            QPLPrinter.Canvas.Font.Size := 12;
            QPLPrinter.Canvas.Font.Color := clWhite;
            QPLPrinter.Canvas.Brush.Style := bsClear;
            QPLPrinter.Canvas.TextOut(0, 0, ' ');

{$IFDEF QPL_DPLR}
            if (FUseDPLR) then
            begin
              if not FSelDoc.PageTree.RenderPageToPrinter(
                QPLPrinter, PageRanges,
                  Options and $FF, FGDIPlusSettings, FSelDoc.GetPrintOCGList,
                  FDPLRFileName) then Result := 0;
            end else
{$ENDIF}
            begin
              if not FSelDoc.PageTree.RenderPageToPrinter(
                QPLPrinter, PageRanges,
                  Options and $FF, FGDIPlusSettings, FSelDoc.GetPrintOCGList) then Result := 0;
            end;
          end else
          begin
            PrintingCancelled := True;
            Result := 0;
            ReportProgress(1080);
          end;
        finally
          if (not PrintingCancelled) then
          begin
            QPLPrinter.EndDoc;
            ReportProgress(1090);
          end;
        end;
        if FPrinterStatusNeeded then
        begin
          FPrinterJobID := QPLPrinter.PrinterJobID;
          FPrinterJobPrinterName := QPLPrinter.PrinterName;
        end;
      finally
        if (FPrintPreview) then
        begin
          FPrintPreviewBitmapData := QPLPrinter.SavePreviewToString;
        end;
        QPLPrinter.Free;
      end;
    end;
  finally
    SelectPage(OldPage);
  end;
end;

function TQuickPDF.FlattenAnnot(Index, Options: Integer): Integer;
var
  CP: TPDFCapturedPage;
  Ref: TPDFIndRef;
  X, Y, W, H: Double;
  ARect: TPDFArray;
  AnnotDict: TPDFDictionary;
  Obj: TPDFObject;

  procedure DrawAnnot;
  begin
    if Assigned(Ref) and (W > 0) and (H > 0) then
    begin
      if Obj is TPDFStream then
      begin
        TPDFStream(Obj).Dictionary.Add('Subtype', FSelDoc.Structure.NewCommonName('Form'));
        CP := TPDFCapturedPage.Create;
        try
          CP.XObject := Ref;
          CP.XObjectName := 'QuickPDFAnnot' + QPLRandomID;
          CP.OriginalWidth := W;
          CP.OriginalHeight := H;
          CP.XOffset := 0;
          CP.YOffset := 0;
          FSelDoc.PageTree.UseXObject(CP.XObjectName, CP.XObject);
          FSelDoc.PageTree.Painter.DrawXObject(CP, X, Y + H, W, H);
        finally
          CP.Free;
        end;
      end;
    end;
  end;

begin
  Result := 0;

  if (Index >= 1) and (Index <= FSelDoc.PageTree.Annots.Count) and (IsAnnotFormField(Index) = 0) then
  begin

    ARect := FSelDoc.PageTree.Annots.GetAnnotRect(Index-1);
    if (ARect is TPDFArray) and (ARect.Count = 4) then
    begin
      X := TPDFNumeric(ARect.Item[0]).AsDouble;
      Y := TPDFNumeric(ARect.Item[1]).AsDouble;

      W := TPDFNumeric(ARect.Item[2]).AsDouble - X;
      H := TPDFNumeric(ARect.Item[3]).AsDouble - Y;

      Ref := FSelDoc.PageTree.Annots.GetAnnotRef(Index-1);
      if (Assigned(Ref)) then
      begin
        AnnotDict := TPDFDictionary(Ref.Obj);

        Obj := AnnotDict.FindValueByKeyName('AP', True);
        if Obj is TPDFDictionary then
        begin
          Obj := TPDFDictionary(Obj).FindValueByKeyName('N');

          if (Obj is TPDFIndRef) then
          begin
            Ref := TPDFIndRef(Obj);
            Obj := Ref.Obj;

            DrawAnnot;
            DeleteAnnotation(Index);
            Result := 1;
          end;
        end
        else
        begin  // Must be a popup annotation with no AP entry.
          DeleteAnnotation(Index);
          Result := 1;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.PrintPagesToFile(const PrinterName, PageRanges: WideString;
  Options: Integer; const FileName: WideString): Integer;
begin
  if (ValidPrinterName(PrinterName)) then
  begin
    FPrintToFile := FileName;
    try
      Result := PrintPages(PrinterName, PageRanges, Options);
    finally
      FPrintToFile := '';
    end;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetFormFieldSubmitActionEx(Index: Integer; const ActionType,
  Link: WideString; Flags: Integer): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := 1;
    Field.AddSubmitAction(AnsiString(ActionType), AnsiString(Link), Flags);
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.SetFormFieldResetAction(Index: Integer; const ActionType: WideString): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := 1;
    Field.AddResetAction(AnsiString(ActionType));
    if Field.TempField then Field.Free;
  end;
end;

function TQuickPDF.DAShiftedHeader(FileHandle: Integer): Integer;
var
  Link: TSmartPDFLink;
begin
  Result := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    if (Link.Reader.ShiftedHeader) then
    begin
      Result := Link.Reader.HeaderPosition;
    end;
  end;
end;

function TQuickPDF.GetFormFieldRichTextString(Index: Integer; const Key: WideString): WideString;
var
  Field: TPDFField;
begin
  Result := '';
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Result := Field.GetRichTextValue(Key);
      end;
    end;
  end;
end;

function TQuickPDF.SetFormFieldRichTextString(Index: Integer; const Key, NewValue: WideString): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Field.SetRichTextValue(Key, NewValue);
        Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.SetFormFieldChoiceSub(Index, SubIndex: Integer; const SubName, DisplayName: WideString): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  if FSelDoc.HasFormData then
  begin
    if (Index > 0) and (Index <= FSelDoc.AcroForm.Count) then
    begin
      Field := FSelDoc.AcroForm.Field[Index - 1];
      if Assigned(Field) then
      begin
        Result := Field.SetSubName(SubIndex - 1, SubName, DisplayName);
      end;
    end;
  end;
end;

function TQuickPDF.GetObjectDecodeError(ObjectNumber: Integer): Integer;
begin
  if (FSelDoc.GetObjectDecodeError(ObjectNumber)) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetRenderOptions(OptionID, NewValue: Integer): Integer;
begin
  Result := 0;
  case OptionID of
    1: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      FGDIPlusSettings.RenderFormFields := NewValue = 1;
    end;
    2: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      FGDIPlusSettings.RenderAnnotations := NewValue = 1;
    end;
    3: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      FGDIPlusSettings.RenderFormFieldsOnly := NewValue = 1;
    end;
    4: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      FGDIPlusSettings.UseGammaCorrection := NewValue = 1;
    end;
    5: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      FGDIPlusSettings.IgnoreICCProfiles := NewValue = 1;
    end;
    6:
    begin
{$IFDEF QPL_OS_WINDOWS}
      FGDIPlusSettings.ProgressWindow := HWND(NewValue);
{$ELSE}
      FGDIPlusSettings.ProgressWindow := NewValue;
{$ENDIF}
    end;
    7:
    begin
      FGDIPlusSettings.ProgressMessage := NewValue;
    end;
    8:
    begin
      FGDIPlusSettings.ProgressData := NewValue;
    end;
    9: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      if (NewValue = 0) then
      begin
        FGDIPlusSettings.PathCombineMode := cmNormalPaths;
      end else
      begin
        FGDIPlusSettings.PathCombineMode := cmCombinePaths;
      end;
    end;
    10: if (NewValue >= 0) and (NewValue <= 1) then
    begin
      Result := 1;
      if (NewValue = 0) then
      begin
        FGDIPlusSettings.DirectFonts := False;
      end else
      begin
        FGDIPlusSettings.DirectFonts := True;
      end;
    end;
  end;
end;

function TQuickPDF.BalancePageTree(Options: Integer): Integer;
begin
  if (Options = 0) then
  begin
    FSelDoc.BalancePageTree;
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.DrawPDF417SymbolEx(Left, Top: Double; const Text: WideString;
  Options, FixedColumns, FixedRows, ErrorLevel: Integer; ModuleSize,
  HeightWidthRatio: Double): Integer;
var
  PainterState: AnsiString;
begin
  Result := 0;
  if ((Options >= 0) and (Options <= 3)) then
  begin
    if (not Assigned(FSelFont)) then AddStandardFont(4);
    PainterState := FSelDoc.PageTree.Painter.GetState;
    try
      Result := 1;

      if not (FSelDoc.FillSet) then
      begin
        SetFillColor(0, 0, 0);
        FSelDoc.FillSet := False;
      end;

      if not (FSelDoc.PageTree.Painter.DrawPDF417Symbol(TranslateX(Left),
        TranslateY(Top), Text, Options, FixedColumns, FixedRows,
        ErrorLevel,
        GetScale(ModuleSize), HeightWidthRatio)) then
      begin
        Result := 0;
      end;
    finally
      FSelDoc.PageTree.Painter.SetState(PainterState);
    end;
  end;
end;

function TQuickPDF.SetSignProcessFieldPage(SignProcessID,
  SignaturePage: Integer): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    SignProcess.FieldPage := SignaturePage;
    Result := 1;
  end;
end;

function TQuickPDF.SetSignProcessPassthrough(SignProcessID, SignatureLength: Integer): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    SignProcess.Passthrough := True;
    SignProcess.PassthroughSignatureLength := SignatureLength;
    Result := 1;
  end;
end;

function TQuickPDF.GetSignProcessByteRange(SignProcessID,
  ArrayPosition: Integer): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  if ((ArrayPosition >= 1) and (ArrayPosition <= 8)) then
  begin
    SignProcess := ValidSignProcessID(SignProcessID);
    if (Assigned(SignProcess)) then
    begin
      if (SignProcess.Passthrough) then
      begin
        if (ArrayPosition <= 4) then
        begin
          Result := SignProcess.ByteRange[ArrayPosition - 1];
        end else
        begin
          Result := (SignProcess.ByteRange[ArrayPosition - 5] shr 32);
        end;
      end;
    end;
  end;
end;

function TQuickPDF.DrawCapturedPageMatrix(CaptureID: Integer; M11, M12, M21,
  M22, MDX, MDY: Double): Integer;
var
  CP: TPDFCapturedPage;
begin
  Result := 0;
  try
    CP := ValidCaptureID(CaptureID);
    if Assigned(CP) then
    begin
      FSelDoc.PageTree.UseXObject(CP.XObjectName, CP.XObject);
      FSelDoc.PageTree.Painter.DrawXObjectMatrix(CP.XObjectName,
        M11, M12, M21, M22, MDX, MDY, CP.OriginalWidth, CP.OriginalHeight);
      Result := 1;
    end;
  except
  end;
end;

function TQuickPDF.DrawTextBoxMatrix(Width, Height: Double;
  const Text: WideString; Options: Integer; M11, M12, M21, M22, MDX,
  MDY: Double): Integer;
begin
  if (Options >= 0) and (Options <= 5) and (Width >= MinTW) then
  begin
    CheckFontSelection;
    Result := FSelDoc.PageTree.Painter.DrawWideTextBoxMatrix(GetScale(Width),
      GetScale(Height), FixWideDelimited(Text, FSelDoc.BreakString),
      Options, FSelDoc.BreakString, M11, M12, M21, M22, MDX, MDY);
  end else
    Result := 0;
end;

function TQuickPDF.DrawHTMLTextBoxMatrix(Width, Height: Double;
  const HTMLText: WideString; M11, M12, M21, M22, MDX, MDY: Double): WideString;
var
  PainterState: AnsiString;
begin
  Result := '';
  if Width > 0 then
  begin
    CheckFontSelection;
    PainterState := FSelDoc.PageTree.Painter.GetState;
    try
      FSelDoc.PageTree.Painter.Reset;
      FSelDoc.PageTree.Painter.ClearTextFormatting;
      Result := '';
      if HTMLText <> '' then
      begin
        FSelDoc.SetHTMLFonts;
        Result := FSelDoc.PageTree.Painter.DrawHTMLTextBoxMatrix(
          GetScale(Width), GetScale(Height), HTMLText,
          M11, M12, M21, M22, MDX, MDY);
      end;
    finally
      FSelDoc.PageTree.Painter.SetState(PainterState);
    end;
  end;
end;

function TQuickPDF.NewInternalPrinterObject(Options: Integer): Integer;
begin
  Result := 0;
{$IFNDEF QPL_OS_MAC}
  if (Options = 0) then
  begin
    if (Assigned(FPrinter)) then
    begin
      FPrinter.Free;
    end;
    FPrinter := TPrinter.Create;
     Result := 1;
  end;
{$ENDIF}
end;

function TQuickPDF.GetPrintPreviewBitmapToString(const PrinterName: WideString;
  PreviewPage, PrintOptions, MaxDimension, PreviewOptions: Integer): AnsiString;
begin
  Result := '';
  if (ValidPrinterName(PrinterName)) then
  begin
    FPrintPreviewMaxDimension := MaxDimension;
    FPrintPreview := True;
    try
      if (PrintDocument(PrinterName, PreviewPage, PreviewPage, PrintOptions) = 1) then
      begin
        Result := FPrintPreviewBitmapData;
        FPrintPreviewBitmapData := '';
      end;
    finally
      FPrintPreview := False;
    end;
  end;
end;

function TQuickPDF.AddLinkToFileEx(Left, Top, Width, Height: Double;
  const FileName: WideString; DestPage: Integer; NewWindow,
  Options, Zoom, DestType: Integer; DestLeft, DestTop, DestRight, DestBottom: Double): Integer;
var
  lConvertedFileName: WideString;
begin
  if (DestPage > 0) then
  begin
    lConvertedFileName := FSelDoc.PageTree.ConvertToFileSpecString(FileName);
    FSelDoc.PageTree.AddLinkToFileEx(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), lConvertedFileName, DestPage, Zoom, DestType,
      DestLeft, DestTop, DestRight, DestBottom,
      NewWindow = 1, Options);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.AddRelativeLinkToFileEx(Left, Top, Width, Height: Double;
  const FileName: WideString; DestPage: Integer; NewWindow,
  Options, Zoom, DestType: Integer; DestLeft, DestTop, DestRight, DestBottom: Double): Integer;
var
  lConvertedFileName: WideString;
begin
  if (DestPage > 0) then
  begin
    lConvertedFileName := FSelDoc.PageTree.ConvertToFileSpecString(FileName, FSelDoc.SourceFileName);
    FSelDoc.PageTree.AddLinkToFileEx(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), lConvertedFileName, DestPage, Zoom, DestType,
      DestLeft, DestTop, DestRight, DestBottom,
      NewWindow = 1, Options);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.SetSignProcessKeyset(SignProcessID,
  KeysetID: Integer): Integer;
var
  SignProcess: TQuickPDFSignProcess;
begin
  Result := 0;
  SignProcess := ValidSignProcessID(SignProcessID);
  if (Assigned(SignProcess)) then
  begin
    if (KeysetID = 1) then
    begin
      SignProcess.UseMachineKeyset := False;
      Result := 1;
    end else
    if (KeysetID = 2) then
    begin
      SignProcess.UseMachineKeyset := True;
      Result := 1;
    end;
  end;
end;

function TQuickPDF.PageHasFontResources(PageNumber: Integer): Integer;
begin
  if (FSelDoc.HasFontResources(PageNumber)) then
  begin
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;
function TQuickPDF.SetHeaderCommentsFromString(
  const Source: AnsiString): Integer;
begin
  Result := 1;
  FSelDoc.SetHeaderComments(Source);
end;


function TQuickPDF.AddPageMatrix(XScale, YScale, XOffset, YOffset: Double): Integer;
var
  C: Integer;
  S: AnsiString;
begin
  if (FSelDoc.PageCount > 0) then
  begin
    C := NewContentStream();
    S := QPLFloatToStr(XScale) + ' 0 0 ' + QPLFloatToStr(YScale) + ' ' +
           QPLFloatToStr(XOffset) + ' ' + QPLFloatToStr(YOffset) + ' cm ';
    SetContentStreamFromString(S);
    MoveContentStream(C, 1);
    Result := 1;
  end else
    Result := 0;
end;

function TQuickPDF.GetTabOrderMode: WideString;
begin
  Result := WideString(FSelDoc.GetTabOrderMode);
end;

function TQuickPDF.SetTabOrderMode(Mode: WideString): Integer;
begin
  Result := FSelDoc.SetTabOrderMode(ANsiString(Mode));
end;

function TQuickPDF.DASaveCopyToStream(FileHandle: Integer;
  OutStream: TStream): Integer;
var
  Link: TSmartPDFLink;
  Writer: TSmartPDFWriter;
  TempStruct: TPDFStructure;
  X: Integer;
  Obj: TPDFObject;
  OC: Integer;
begin
  Result := 0;
  FLastErrorCode := 0;
  Link := ValidFileHandle(FileHandle);
  if Assigned(Link) then
  begin
    try
      Writer := TSmartPDFWriter.Create(OutStream);
      try
        Writer.New;
        TempStruct := TPDFStructure.Create;
        try
          FSubProgressScale := 1;
          FSubProgressOffset := 0;
          if (not Link.Doc.UserModDate) then
          begin
            Link.Doc.SetInformation('ModDate', WideString(GetPDFDateTime));
          end;
          OC := Link.Doc.ObjectCount;
          for X := 1 to OC do
          begin
            SubProgress(X * 100 div OC);
            Obj := Link.Doc.GetObject(X, TempStruct);
            if Assigned(Obj) then
              Writer.AddObject(X, Link.Doc.GetGenNum(X), Obj.Output)
            else
              Writer.AddObject(X, Link.Doc.GetGenNum(X), 'null');
            if TempStruct.ObjectCount > ObjCountLimit then
            begin
              TempStruct.Free;
              TempStruct := TPDFStructure.Create;
            end;
          end;
          EndProgress;
          Result := 1;
        finally
          TempStruct.Free;
        end;
        Link.Reader.FixTrailer;
        Writer.AddTrailer(Link.Reader.TrailerDict, 0, True);
      finally
        Writer.Free;
      end;
    except
      FLastErrorCode := 403;
    end;
  end else
    FLastErrorCode := 501;
end;

function TQuickPDF.RenderAsMultipageTIFFToFile(DPI: Double;
  const PageRanges: WideString; ImageOptions, OutputOptions: Integer;
  const FileName: WideString): Integer;
var
  TempPageList: TQuickPDFPageList;
  PX: Integer;
  PageNumber: Integer;
  MS: TMemoryStream;
  OutputStream: TQuickPDFWideFileStream;
  RenderFormat: Integer;
begin
  Result := 0;
  SetLength(TempPageList, 0);

  if (((ImageOptions = 0) or (ImageOptions = 1)) and (OutputOptions = 0)) then
  begin
    TempPageList := QPLParsePageRangeList(
      AnsiString(PageRanges),
      1, PageCount,  // Valid page range
      False,  // Silently ignore invalid pages
      False,  // Silently ignore invalid characters
      False,  // Silently ignore duplicate pages
      True,  // Allow/don't add duplicate pages to the returned page list
      False);  // Sort/don't sort the returned page list

    if (Length(TempPageList) > 0) then
    begin
      OutputStream := QPLCreateFileStream(FileName, fmCreate or fmShareExclusive);
      if (Assigned(OutputStream)) then
      begin
        Result := 1;
        try
          for PX := 0 to Length(TempPageList) - 1 do
          begin
            PageNumber := TempPageList[PX];
            MS := TMemoryStream.Create;
            try
              if (ImageOptions = 0) then
              begin
                RenderFormat := 7;  // 24-bit RGB TIFF
              end else
              begin
                RenderFormat := 10; // G4 Mono TIFF
              end;
              RenderPageToStream(DPI, PageNumber, RenderFormat, MS);
              MS.Seek(0, soBeginning);
              if (PX = 0) then
              begin
                OutputStream.CopyFrom(MS, MS.Size);
              end else
              begin
                ConcatenateTIFFStream(OutputStream, MS);
              end;
            finally
              MS.Free;
            end;
          end;
        finally
          OutputStream.Free;
        end;
      end;
    end;
  end;
end;

function TQuickPDF.AppendToFile(const FileName: WideString): Integer;
begin
  FLastErrorCode := 0;
  if FUnlocked then
  begin
    FSelFont := nil;
    if (not FSelDoc.UserModDate) then
    begin
      FSelDoc.SetInfo('ModDate', WideString(GetPDFDateTime));
    end;
    if FSelDoc.AppendToFile(FileName) then
      Result := 1
    else
      Result := 0;
  end else
  begin
    Result := 0;
    FLastErrorCode := 999;
  end;
end;

function TQuickPDF.DrawHTMLTextMatrix(Width: Double; const HTMLText: WideString;
  M11, M12, M21, M22, MDX, MDY: Double): Integer;
var
  PainterState: AnsiString;
begin
  Result := 0;
  if Width > 0 then
  begin
    CheckFontSelection;
    PainterState := FSelDoc.PageTree.Painter.GetState;
    try
      FSelDoc.PageTree.Painter.Reset;
      FSelDoc.PageTree.Painter.ClearTextFormatting;
      Result := 1;
      if HTMLText <> '' then
      begin
        FSelDoc.SetHTMLFonts;
        FSelDoc.PageTree.Painter.DrawHTMLTextMatrix(
          GetScale(Width), HTMLText,
          M11, M12, M21, M22, MDX, MDY);
      end;
    finally
      FSelDoc.PageTree.Painter.SetState(PainterState);
    end;
  end;
end;

function TQuickPDF.DrawQRCode(Left, Top, SymbolSize: Double;
  const Text: WideString; EncodeOptions, DrawOptions: Integer): Integer;
var
  PainterState: AnsiString;
begin
  Result := 0;
  if ((EncodeOptions >= 0) and (EncodeOptions <= 5) and
    (DrawOptions >= 0) and (DrawOptions <= 3)) then
  begin
    PainterState := FSelDoc.PageTree.Painter.GetState;
    try
      Result := 1;

      if not (FSelDoc.FillSet) then
      begin
        SetFillColor(0, 0, 0);
        FSelDoc.FillSet := False;
      end;

      if (not FSelDoc.PageTree.Painter.DrawQRCode(TranslateX(Left),
        TranslateY(Top), GetScale(SymbolSize), Text, EncodeOptions, DrawOptions)) then
      begin
        Result := 0;
      end;
    finally
      FSelDoc.PageTree.Painter.SetState(PainterState);
    end;
  end;
end;

function TQuickPDF.AddFreeTextAnnotation(Left, Top, Width, Height: Double;
  const Text: WideString; Angle, Options: Integer): Integer;
begin
  Result := 1;
  CheckFontSelection;
  if (Angle mod 90 = 0) then
  begin
    FSelDoc.PageTree.AddFreeTextAnnotation(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), Text, Options, Angle);
  end;
end;

function TQuickPDF.AddFreeTextAnnotationEx(Left, Top, Width, Height: Double;
  const Text: WideString; Angle, Options: Integer; Transparency: Integer): Integer;
begin
  Result := 1;
  CheckFontSelection;
  if (Angle mod 90 = 0) then
  begin
    FSelDoc.PageTree.AddFreeTextAnnotationEx(TranslateX(Left), TranslateY(Top),
      GetScale(Width), GetScale(Height), Text, Options, Angle, Transparency);
  end;
end;

function TQuickPDF.UpdateTrueTypeSubsettedFont(
  const SubsetChars: WideString): Integer;
begin
  Result := 0;
  if (Assigned(FSelFont)) then
  begin
    if (FSelFont.CanUpdate) then
    begin
      FSelFont.AddToSubset(SubsetChars);
      FSelFont.UpdateSubsettedFont();
    end;
  end;
end;

function TQuickPDF.CheckPassword(const Password: WideString): Integer;
begin
  Result := 0;
  if (FSelDoc.Encrypted = peEncrypted) then
  begin
    if (FSelDoc.CheckOwnerPassword(Password)) then
    begin
      if (FSelDoc.CheckUserPassword(Password)) then
      begin
        Result := 3;
      end else
      begin
        Result := 2;
      end;
    end else
    begin
      if (FSelDoc.CheckUserPassword(Password)) then
      begin
        Result := 1;
      end;
    end;
  end;
end;

function TQuickPDF.AddImageDirectFromString(const Source: AnsiString; Width,
  Height, BitsPerComponent: Integer; const ColorSpace, Filter, Decode: WideString;
  Interpolate: Integer): Integer;
var
  Image: TPDFImage;
begin
  Result := 0;

  Image := FSelDoc.NewImageDirectFromString(Source, Width, Height, BitsPerComponent,
    ColorSpace, Filter, Decode, Interpolate <> 0);

  if Image <> nil then
  begin
    Result := IntCast(Image);
    FSelImage := Image;
  end;
end;

function TQuickPDF.SetTilingPatternMatrix(const PatternName: WideString; M11,
  M12, M21, M22, MDX, MDY: Double): Integer;
var
  TilingPattern: TPDFTilingPattern;
begin
  TilingPattern := FSelDoc.FindTilingPattern(AnsiString(PatternName));
  if Assigned(TilingPattern) then
  begin
    TilingPattern.SetMatrix(M11, M12, M21, M22, MDX, MDY);
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.RemoveFormFieldChoiceSub(Index: Integer;
  const SubName: WideString): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := Field.DeleteSubName(SubName);
  end;
end;

function TQuickPDF.SetFormFieldTitle(Index: Integer; NewTitle: WideString): Integer;
var
  Field: TPDFField;
begin
  Result := 0;
  Field := FindFormField(Index);
  if Assigned(Field) then
  begin
    Result := 1;
    Field.Title := NewTitle;
  end;
end;

function TQuickPDF.RenderPageToMemory(DPI: Double; Page: Integer;
  Target: Pointer; Width, Height, BitsPerPixel: Integer): Integer;
var
  OldPage: Integer;
begin
  Result := 0;
  if ((BitsPerPixel = 24) or (BitsPerPixel = 32)) then
  begin
    FLastRenderError := '';
    OldPage := SelectedPage;
    try
      Result := 1;
      if Page < 1 then Page := 1;
      if Page > PageCount then Page := PageCount;
{$IFDEF QPL_CAIRO}
      if (FUseCairo) then
      begin
        //Result := 0;
      end else
{$ENDIF}
{$IFDEF QPL_DPLR}
      if (FUseDPLR) then
      begin
        if not FSelDoc.PageTree.RenderPageToDPLRMemory(FRenderScale * DPI, Page,
          FJPEGQuality, FGDIPlusSettings, FDPLRFileName, Target, Width, Height, BitsPerPixel,
          FLastRenderError, FRenderCropType, FSelDoc.GetViewOCGList) then Result := 0;
      end else
{$ENDIF}
      begin
        //Result := 0;
      end;
    finally
      SelectPage(OldPage);
    end;
  end;
end;

function TQuickPDF.GetAnnotEmbeddedFileName(Index, Options: Integer): WideString;
begin
  Result := FSelDoc.PageTree.Annots.GetEmbeddedFileName(Index - 1);
end;

function TQuickPDF.GetAnnotEmbeddedFileToFile(Index, Options: Integer;
  const FileName: WideString): Integer;
var
  FileData: AnsiString;
  FileStream: TQuickPDFWideFileStream;
begin
  Result := 0;
  FileData := GetAnnotEmbeddedFileToString(Index, Options);
  if (FileData <> '') then
  begin
    try
      FileStream := TQuickPDFWideFileStream.Create(FileName, fmCreate);
    except
      FileStream := nil;
    end;
    if (Assigned(FileStream)) then
    begin
      try
        FileStream.Write(FileData[1], Length(FileData));
        Result := 1;
      finally
        FileStream.Free;
      end;
    end;
  end;
end;

function TQuickPDF.GetAnnotEmbeddedFileToString(Index, Options: Integer): AnsiString;
begin
  Result := FSelDoc.PageTree.Annots.GetFile(Index - 1);
end;

function TQuickPDF.SetAppendInputFromString(const Source: AnsiString): Integer;
begin
  FAppendInput := Source;
  Result := 1;
end;

// AppendMode 0 = Return original source plus update section
// AppendMode 1 = Return just update section
// AppendMode 2 = Return input string set with SetAppendInputFromString plus update section
function TQuickPDF.AppendToString(AppendMode: Integer): AnsiString;
begin
  Result := FSelDoc.AppendToString(AppendMode, FAppendInput);
end;

function TQuickPDF.LinearizeFile(const InputFileName, Password,
  OutputFileName: WideString; Options: Integer): Integer;
var
  Linearizer: TDPLLinearizer;
  InputStream: TQuickPDFWideFileStream;
  OutputStream: TQuickPDFWideFileStream;
begin
  Result := 0;
  if (QPLFileExists(InputFileName)) then
  begin
    Linearizer := TDPLLinearizer.Create;
    try
      InputStream := TQuickPDFWideFileStream.Create(InputFileName, fmOpenRead);
      try
        case Linearizer.OpenPDF(InputStream, Password) of
          plOkay:
          begin
            Linearizer.SetOptions(Options);
            OutputStream := TQuickPDFWideFileStream.Create(OutputFileName, fmCreate);
            try
              if (Linearizer.SaveToStream(OutputStream)) then
              begin
                Result := 1;  // Success
              end else
              begin
                Result := 5;  // Could not write output file
              end;
            finally
              OutputStream.Free;
            end;
          end;
          //plFileNotFound: Result := 2;  // Input PDF not found
          plCannotRead: Result := 3;    // Input PDF cannot be read
          plWrongPassword: Result := 4; // Input PDF password incorrect
        end;
      finally
        InputStream.Free;
      end;
    finally
      Linearizer.Free;
    end;
  end else
  begin
    Result := 2;
  end;
end;

function TQuickPDF.DANormalizePage(FileHandle, PageRef: Integer; NormalizeOptions: Integer): Integer;
var
  OldWidth: Double;
  OldHeight: Double;
  OldRotation: Integer;
  NewWidth: Double;
  NewHeight: Double;
  CropXOffset: Double;
  CropYOffset: Double;
  CropWidth: Double;
  CropHeight: Double;
  Transform: AnsiString;
  {
  AnnotIndex: Integer;
  AnnotRect: TPDFArray;
  PDFRect: TPDFRectangle;
  AnnotLeft: Double;
  AnnotTop: Double;
  AnnotRight: Double;
  AnnotBottom: Double;
  AnnotRotation: Integer;
  Obj: TPDFObject;
  Dict: TPDFDictionary;
  I: Integer;
  }

  Link: TSmartPDFLink;
  Page: TPDFIndRef;

  procedure ResetMatrixEntries(Obj: TPDFObject; Rotation: Integer);
  const
    R: Array[1..16] of Integer =
      (  1,  0,  0,  1,      // 0
         0, -1,  1,  0,      // 90
        -1,  0,  0, -1,      // 180
         0,  1, -1,  0       // 270
      );
  var
    Offset: Integer;
    A: TPDFArray;
  begin
    Offset := (((Rotation + 360) mod 360) div 90) * 4;

    if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
    if (Obj is TPDFArray) and (TPDFArray(Obj).Count = 6) then
    begin
      A := TPDFArray(Obj);
      if (A.Item[0] is TPDFNumeric) then TPDFNumeric(A.Item[0]).SetTo(R[Offset + 1]);
      if (A.Item[1] is TPDFNumeric) then TPDFNumeric(A.Item[1]).SetTo(R[Offset + 2]);
      if (A.Item[2] is TPDFNumeric) then TPDFNumeric(A.Item[2]).SetTo(R[Offset + 3]);
      if (A.Item[3] is TPDFNumeric) then TPDFNumeric(A.Item[3]).SetTo(R[Offset + 4]);
    end;
  end;

begin
  Link := ValidFileHandle(FileHandle);
  Page := nil;

  if Assigned(Link) then
    Page := ValidPageRef(Link, PageRef);

  if Assigned(Link) and Assigned(Page) then
  begin

    // Get the CropBox offset and size
    { TPDFDimension = (pdLeft, pdTop, pdWidth, pdHeight, pdRight, pdBottom); }
    CropXOffset := Link.Doc.GetPageBox(Page, 2, pdLeft);
    CropWidth   := Link.Doc.GetPageBox(Page, 2, pdWidth);
    CropHeight  := Link.Doc.GetPageBox(Page, 2, pdHeight);
    CropYOffset := Link.Doc.GetPageBox(Page, 2, pdBottom);
    OldWidth    := CropWidth;
    OldHeight   := CropHeight;

    // Get the page's rotation
    OldRotation := Link.Doc.GetPageRotation(Page);

    // Normalize the rotation
    OldRotation := ((OldRotation div 90) mod 4) * 90;
    if (OldRotation < 0) then OldRotation := 360 + OldRotation;

    // Determine the new width/height based on the rotation
    if (OldRotation = 90) or (OldRotation = 270) then
    begin
      NewWidth := OldHeight;
      NewHeight := OldWidth;
    end else
    begin
      NewWidth := OldWidth;
      NewHeight := OldHeight;
    end;

    // Remove the page rotation attribute
    Link.Doc.SetPageRotation(page, 0, 0);

    // Set all the page boxes to be the same
    Link.Doc.SetPageBox(Page, 1, 0, 0, NewWidth, NewHeight);
    Link.Doc.SetPageBox(Page, 2, 0, 0, NewWidth, NewHeight);
    Link.Doc.SetPageBox(Page, 3, 0, 0, NewWidth, NewHeight);
    Link.Doc.SetPageBox(Page, 4, 0, 0, NewWidth, NewHeight);
    Link.Doc.SetPageBox(Page, 5, 0, 0, NewWidth, NewHeight);

    // Calculate an appropriate transformation
    case OldRotation of
      0:
      begin
        Transform := '1 0 0 1 ' + QPLDoubleToStrConst(-CropXOffset, 4) + ' ' +
          QPLDoubleToStrConst(-CropYOffset, 4) + ' cm';
      end;
      90:
      begin
        Transform := '0 -1 1 0 0 ' + QPLDoubleToStrConst(NewHeight, 4) + ' cm ' +
          '1 0 0 1 ' + QPLDoubleToStrConst(-CropXOffset, 4) + ' ' +
          QPLDoubleToStrConst(-CropYOffset, 4) + ' cm';
      end;
      180:
      begin
        Transform := '-1 0 0 -1 ' + QPLDoubleToStrConst(NewWidth, 4) + ' ' +
          QPLDoubleToStrConst(NewHeight, 4) + ' cm ' +
          '1 0 0 1 ' + QPLDoubleToStrConst(-CropXOffset, 4) +
          ' ' + QPLDoubleToStrConst(-CropYOffset, 4) + ' cm';
      end;
      270:
      begin
        Transform := '0 1 -1 0 ' + QPLDoubleToStrConst(NewWidth, 4) + ' 0 cm ' +
          '1 0 0 1 ' + QPLDoubleToStrConst(-CropXOffset, 4) +
          ' ' + QPLDoubleToStrConst(-CropYOffset, 4) + ' cm';
      end;
    else
      Transform := '';
    end;

    Link.Doc.NewLayer(Page);
    Link.Doc.MoveLayer(Page, Link.Doc.ContentStreamCount(Page), 1);
    Link.Doc.SetContentStream(Page, 1, 'q ' + Transform + ' ');

    Link.Doc.NewLayer(Page);
    Link.Doc.SetContentStream(Page, Link.Doc.ContentStreamCount(Page), ' Q ');

    // TODO ....
    // Adjust the annotations
    {
    for AnnotIndex := 0 to FSelDoc.PageTree.Annots.Count - 1 do
    begin
      AnnotRect := FSelDoc.PageTree.Annots.GetAnnotRect(AnnotIndex);

      if (Assigned(AnnotRect) and (AnnotRect.Count = 4)) then
      begin

        PDFRect := TPDFRectangle.Create(AnnotRect);
        AnnotLeft := PDFRect.Left;
        AnnotTop := PDFRect.Top;
        AnnotRight := PDFRect.Right;
        AnnotBottom := PDFRect.Bottom;
        try
          case OldRotation of
            0:
            begin
              PDFRect.Left := AnnotLeft - CropXOffset;
              PDFRect.Top := AnnotTop - CropYOffset;
              PDFRect.Right := AnnotRight - CropXOffset;
              PDFRect.Bottom := AnnotBottom - CropYOffset;
            end;

            90:
            begin
              PDFRect.Left := CropHeight - ((CropYOffset + CropHeight) - AnnotTop);
              PDFRect.Top := CropWidth - (AnnotRight - CropXOffset);
              PDFRect.Right := CropHeight - ((CropYOffset + CropHeight) - AnnotBottom);
              PDFRect.Bottom := CropWidth - (AnnotLeft - CropXOffset);
            end;

            180:
            begin
              PDFRect.Left := (CropXOffset + CropWidth) - AnnotRight;
              PDFRect.Top := (CropYOffset + CropHeight) - AnnotBottom;
              PDFRect.Right := (CropXOffset + CropWidth) - AnnotLeft;
              PDFRect.Bottom := (CropYOffset + CropHeight) - AnnotTop;
            end;

            270:
            begin
              PDFRect.Left := CropHeight - (AnnotBottom - CropYOffset);
              PDFRect.Top := CropWidth - ((CropXOffset + CropWidth) - AnnotLeft);
              PDFRect.Right := CropHeight - (AnnotTop - CropYOffset);
              PDFRect.Bottom := CropWidth - ((CropXOffset + CropWidth) - AnnotRight);
            end;
          end;
        finally
          PDFRect.Free;
        end;
      end;

      Obj := FSelDoc.PageTree.Annots.GetAnnotRef(AnnotIndex);
      if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
      if (Obj is TPDFDictionary) then
      begin
        if (TPDFDictionary(Obj).FindValueByKeyName('MK') = nil) then
        begin
          Obj := TPDFDictionary(Obj).FindValueByKeyName('AP', True);
          if (Obj is TPDFDictionary) then
          begin
            Obj := TPDFDictionary(Obj).FindValueByKeyName('N');
            if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;
            if (Obj is TPDFStream) then
            begin
              Obj := TPDFStream(Obj).Dictionary.FindValueByKeyName('Matrix', True);
              if (Obj is TPDFArray) then
                ResetMatrixEntries(Obj, OldRotation);
            end;
            if (Obj is TPDFDictionary) then
            begin
              Dict := TPDFDictionary(Obj);
              for I := 0 to Dict.Count do
              begin
                Obj := Dict.Entry[I].Value;
                if Obj is TPDFIndRef then Obj := TPDFIndRef(Obj).Obj;

                if (Obj is TPDFStream) then
                begin
                  Obj := TPDFStream(Obj).Dictionary.FindValueByKeyName('Matrix', True);
                  if (Obj is TPDFArray) then
                  begin
                    ResetMatrixEntries(Obj, OldRotation);
                  end;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    }

    {
    if FSelDoc.HasFormData then
    begin
      for AnnotIndex := 0 to FSelDoc.AcroForm.Count - 1 do
      begin
        AnnotRotation := FSelDoc.AcroForm.Field[AnnotIndex].GetRotation;
        FSelDoc.AcroForm.Field[AnnotIndex].SetRotation(AnnotRotation - OldRotation);
      end;
    end;
    }

    {
    FSelDoc.ReloadFormData;
    }

    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetDecodeMode(NewDecodeMode: Integer): Integer;
begin
  if ((NewDecodeMode >= 1) and (NewDecodeMode <= 3)) then
  begin
    FDefaultDecodeMode := NewDecodeMode;
    Result := 1;
  end else
  begin
    Result := 0;
  end;
end;

function TQuickPDF.SetAnnotOptional(Index,
  OptionalContentGroupID: Integer): Integer;
var
  OCG: TPDFIndRef;
begin
  Result := 0;
  OCG := ValidOCG(OptionalContentGroupID);
  if Assigned(OCG) then
  begin
    if (FSelDoc.PageTree.Annots.SetOCG(Index - 1, OCG)) then
    begin
      Result := 1;
    end;
  end;
end;

function TQuickPDF.LibraryVersionEx: WideString;
begin
  FLastErrorCode := 0;
  Result := WideString(FullLibVer);
end;

function TQuickPDF.GetImageListItemFormatDesc(ImageListID, ImageIndex,
  Options: Integer): WideString;
var
  VCLObj: TObject;
  ImageList: TPDFImageList;
begin
  Result := '';
  VCLObj := IntUncast(ImageListID);
  if (VCLObj is TPDFImageList) then
  begin
    ImageList := TPDFImageList(VCLObj);
    Result := WideString(ImageList.FormatDesc(ImageIndex, Options));
  end;
end;

end.

