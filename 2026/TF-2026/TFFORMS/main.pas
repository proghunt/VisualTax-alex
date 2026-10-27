 unit Main;
(*    SEE SUMT3Boxes
Cannot make a viible window modal: skip the show and free
or make it invisible first

TRY/EXCEPT: on E: Exception do MessageDlg(E.Message, mtError, [mbok], 0);
Jan 20, Letter switch fixed
{Null terminated strings and pointer to a string
 Var ZString := Array[0..80] of Char;
     PZString : Pchar;
  Begin
    PZString := StrPCopy(ZString,anyPascalString);

 FormatDateTime('yyyy-mm-dd',Date);
 ==== ShelExecute
 Var h : Thandle;
   PgmPathS,PgmS,PgmParmsS:String;
   PgmPathZ : Array[0..254] of Char;
   PgmParmsZ : Array[0..254] of Char;
   PgmZ: Array[0..254] of Char;
begin
 PgmPathS := AppDir; StrPCopy(PgmPathZ,PgmPathS);
 PgmS:='5000-g-01e.pdf'; StrPCopy(PgmZ,PgmS);
 PgmParmsS:=''; StrPCopy(PgmParmsZ,PgmParmsS);
 h := ShellExecute(MainForm.Handle, Nil, PgmZ, PgmParmsZ,PgmPathz, SW_RESTORE);
 If H<=32 then ShowMessage('File not found');
 =====
*)
interface

uses WinTypes,FileCtrl, WinProcs, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ShellApi,DbCtrls,
  Grids, Calendar, ColorGrd, DBTables,
  Common,Common2,TrimStr,{T1Rtns,UClients,}Uabout,Printers,ComObj,MAPI,{UT7DRA,}
  UDeclare,ClipBrd,
  VtEditBox,vtLabel,vtScrollBox,vtShape, wwriched,UInternetFrm,
  {UOptions,} {UTESTFRM,UTESTFORM,}
  {UCHILDWinFrame,}UOptionsFrm,{USlipsFrame,}
  UPrT5013,
//Ut5013Efile,  //20160410   //20160806 WAS NOT COMPILING
  //frames
  {UAcbFrame,}UDummyFrame,
  UFlagFrameCanada,
  UCanFlagFrame,  //20131225
  UFlagFrameCan,UFlagFrameAB,UFlagFrameBC,UFlagFrameMB,
  UFlagFrameNS,UFlagFrameNB,UFlagFrameNF,UFlagFrameNW,UFlagFrameNU,UFlagFrameON,
  UFlagFramePE,UFlagFrameSK,UFlagFrameYK,
  {UPrpOpt,}{UDirOpt,}{UEfOpt, ekfunc, ekbasereport, ekrtf, StdActns, ActnList,
  OleCtrls, SHDocVw, ComCtrls,}UOpFlNm,UCalndr, {UCletter,}{UFormScale,} ComCtrls,
  UClientBook,{UOpen,} USaveAs,Ulogon,USetDisplay,UBackupFrm,URestoreFrm,
  UFees,UDict, {UEFMErr,} USIC,{UGuides,}
  {UDFiles,}UShowAnyFile,{UBanks,UCharity,UEmployers,UMedExp,UDoctors,UFirstNm,}
  UWarning,UCntErr, UFixDb, UPrint, {UDeskTop,} UCopyMoveFrm,
  UStatBox, {UCpl,} UPopList,UPopComboList,{USearchList,}
  UUsers, {UCashR,} {UrSum,UTips,}UCopyFrm, {UAnalyse,}
  UFileVu, UMPswd,UCalc,UCalcT5013,
  {UCalcCpl,}Spin, UProgres, UDBRestr, UFRMType,
  UABList,UPrSet,URebuild,UMerge,UOutline,
  {URtu,}{USelOpen,}{UChart,}{UImportC,}{URecalc,}{UListBal,UPresel,}
  {UNISACd,}UImport,{UUpgrade,}DB, {UYTDSet,UYTDCash,Logging,}{UCopyDly,}{T1Rtns2,}
  {UBrowserForm,} URichForm,{UEditRich,}UAskForKey, TeeProcs,
  TeEngine,{UChartClients,} Chart,{UOthOpt,}
  UReindexDb,{UTaxByte,}{UEOL,} {UHtmlEOL,}{UEOLP,UHtmlSEND,}{URestructure,}
  {UFormsExplorer,}{UImportGpT1,URollGpT1, URollCtxT1,}UAuthorization,
  UFeatures,{UInvAdj,}UTimedMsg,UFtpFrm,
  {UQRLetter,}QuickRpt,qrextra,{UCompLogo,} UImportConfig,UExportConfig,
  UFindALine,
  UPdfFrm,USetPgmPsw,USetFilePsw,UUpdateSchedule, Mask, StdActns, ActnList,
  EKRTF, ekbasereport, ekfunc,UDataDictFrm, OleCtrls, SHDocVw, ImgList,
  ToolWin;

  //UHtmlTest;
  //UTestFrm;

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;


Type
  TDFMorTXT = (ConvertToForm, ConvertToText);

type

  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveAsItem: TMenuItem;
    Edit: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    MinimizeAll: TMenuItem;
    RestoreReturn: TMenuItem;
    Forms: TMenuItem;
    ClearCurrentform: TMenuItem;
    SelectForm: TMenuItem;
    Jacket: TMenuItem;
    N6: TMenuItem;
    Diagnostics: TMenuItem;
    Minimizeform: TMenuItem;
    RestoreAll: TMenuItem;
    Options1: TMenuItem;
    N10: TMenuItem;
    Print1: TMenuItem;
    Utilities: TMenuItem;
    Help2: TMenuItem;
    AboutItem: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    PrinterSetup: TMenuItem;
    PrintDialogItem: TPrintDialog;
    MinimizeReturn: TMenuItem;
    ColorDialog1: TColorDialog;
    OpenbyFileName1: TMenuItem;
    Calendar1: TMenuItem;
    ClientLetter1: TMenuItem;
    PrintForm1: TMenuItem;
    CreateDataDirectory1: TMenuItem;
    PrintTemplates1: TMenuItem;
    FeeSchedule1: TMenuItem;
    N16: TMenuItem;
    DataDictionary1: TMenuItem;
    N25: TMenuItem;
    EmergencyToolKit1: TMenuItem;
    FixFormSpecifications1: TMenuItem;
    FixClientDataBaseData1: TMenuItem;
    ShowCellNumbers1: TMenuItem;
    ChangeDataDirectory1: TMenuItem;
    Switchforms1: TMenuItem;
    N27: TMenuItem;
    N7: TMenuItem;
    CopyForm1: TMenuItem;
    N18: TMenuItem;
    N31: TMenuItem;
    UserSetUp1: TMenuItem;
    Calculator1: TMenuItem;
    VisualTaxGuide1: TMenuItem;
    Allforms1: TMenuItem;
    SystemInformation1: TMenuItem;
    N33: TMenuItem;
    RebuildtheClientDataBase1: TMenuItem;
    MergeDataBases1: TMenuItem;
    FileViewerEditor1: TMenuItem;
    CurrentPage1: TMenuItem;
    ClientListings1: TMenuItem;
    DeveloperOnly1: TMenuItem;
    YourLatestRelease: TMenuItem;
    Upgrade1: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    InternetWebSite1: TMenuItem;
    VerticalSplitter1: TSplitter;
    ToolBoxSplitter: TSplitter;
    AlphabeticalFormsIndex1: TMenuItem;
    Presentation1: TMenuItem;
    Zoomin1: TMenuItem;
    Zoomout1: TMenuItem;
    Review1: TMenuItem;
    Color1: TMenuItem;
    Recalc1: TMenuItem;
    ToolBar: TPanel;
    FileMgtBox: TGroupBox;
    OpenBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    ExitBtn: TSpeedButton;
    NewBtn: TSpeedButton;
    CloseBtn: TSpeedButton;
    NavigationBox: TGroupBox;
    FormsBtn: TSpeedButton;
    SwapFrm: TSpeedButton;
    PreselNextBtn: TSpeedButton;
    PreSelPrvBtn: TSpeedButton;
    ReviewBox: TGroupBox;
    AuditOpenBtn: TSpeedButton;
    ReviewBtn: TSpeedButton;
    RecalcBtn: TSpeedButton;
    DesktopBox: TGroupBox;
    ToolBarBtn: TSpeedButton;
    ZoomBtnPlus: TSpeedButton;
    ZoomBtnMinus: TSpeedButton;
    ColorPanel: TPanel;
    clr0: TPanel;
    clr8: TPanel;
    clr6: TPanel;
    clr7: TPanel;
    clr9: TPanel;
    clr1: TPanel;
    Panel14: TPanel;
    clr2: TPanel;
    clrcustom: TPanel;
    clr3: TPanel;
    clr4: TPanel;
    clr5: TPanel;
    clr10: TPanel;
    clr11: TPanel;
    BitBtn1: TBitBtn;
    Timer1: TTimer;
   // ShowTreeview1: TMenuItem;
    ReIndextheClientDataBase1: TMenuItem;
    RestructuretheClientsDataBase1: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N22: TMenuItem;
    Checkupdate1: TMenuItem;
    ClearCurrentPage: TMenuItem;
    N32: TMenuItem;
    ImportBtn: TSpeedButton;
    CharityOrganizations1: TMenuItem;
    Employers1: TMenuItem;
    DoctorsHospitalsPharmacies1: TMenuItem;
    MedicalExpenseDescriptions1: TMenuItem;
    FirstNames1: TMenuItem;
    Cities1: TMenuItem;
    OpenPreviousYearsT11: TMenuItem;
    N35: TMenuItem;
    CompanyLogo1: TMenuItem;
    ImportConfiguration1: TMenuItem;
    N36: TMenuItem;
    ExportConfiguration1: TMenuItem;
    Findaline1: TMenuItem;
    LinesBtn: TSpeedButton;
    UsefulLinks: TMenuItem;
    SetReturnPassword1: TMenuItem;
    RemoveReturnPassword1: TMenuItem;
    EmailCurrentForm: TMenuItem;
    N43: TMenuItem;
    SaveALLopenedreturns1: TMenuItem;
    SaveandCloseAllopenedreturns1: TMenuItem;
    TestBlBox: TMenuItem;
    Checkupdates1: TMenuItem;
    N52: TMenuItem;
    VisualTaxontheWEB1: TMenuItem;
    GUIDES1: TMenuItem;
    VisualTaxForum1: TMenuItem;
    N15: TMenuItem;
    N39: TMenuItem;
    N45: TMenuItem;
    TileVertical1: TMenuItem;
    LeftPanel: TPanel;
    WizardPanelSplitter: TSplitter;
    FormsPanel: TPanel;
    Panel2: TPanel;
    ExpandPanel: TPanel;
    SpeedButton1: TSpeedButton;
    ExpandBtn: TBitBtn;
    Collapse: TBitBtn;
    UsedFormsBox: TCheckBox;
    FormsTreeView1: TTreeView;
    FormsPanelSplitter: TSplitter;
    ReturnsPanel: TPanel;
    ReturnsHeaderPanel: TPanel;
    ReturnsListBox: TListBox;
    WizardPanel: TPanel;
    WizardHeaderPanel: TPanel;
    Panel1: TPanel;
    SuperFeaturesLbl: TLabel;
    PrintAuditBtn: TSpeedButton;
    AuditPanel: TScrollBox;
    ErrorView: TTreeView;
    TileHorizontally1: TMenuItem;
    StatusBarBtn: TSpeedButton;
    HelpBtn: TSpeedButton;
    CloseBlackBoxBtn: TBitBtn;
    FormsBlackBoxBtn: TBitBtn;
    CloseallreturnsWITHOUTSaving1: TMenuItem;
    Setdisplayresolution1: TMenuItem;
    N53: TMenuItem;
    Label14: TLabel;
    AboutPanel: TPanel;
    NewReturnLbl: TLabel;
    OpenReturnLbl: TLabel;
    MostRecentLbl: TLabel;
    RollOvrerLbl: TLabel;
    WhatsNewLbl: TLabel;
    HelpLbl: TLabel;
    CheckUpdatesLbl: TLabel;
    ForumLbl: TLabel;
    Label7: TLabel;
    N54: TMenuItem;
    Lockreturnagaistchanges1: TMenuItem;
    UnlockReturn1: TMenuItem;
    Label1: TLabel;
    Label3: TLabel;
    ListView1: TListView;
    Options2: TMenuItem;
    Label2: TLabel;
    WWWLbl: TLabel;
    Label5: TLabel;
    Image2: TImage;
    TradeMarkLbl: TLabel;
    N3: TMenuItem;
    PrepareDistr1: TMenuItem;
    LicLevel1: TMenuItem;
    N57: TMenuItem;
    ActionList1: TActionList;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    ZoomPercentLbl: TLabel;
    vtShape2: TvtShape;
    vtShape6: TvtShape;
    EkRTF1: TEkRTF;
    EkUDFList1: TEkUDFList;
    GoToaFormSection1: TMenuItem;
    Image1: TImage;
    EmailTheReturn: TMenuItem;
    OpenItBtn: TBitBtn;
    EMailItBtn: TBitBtn;
    TutorialsPanel: TPanel;
    TutLeftPanel: TPanel;
    Panel4: TPanel;
    N12: TMenuItem;
    TUTORIALS1: TMenuItem;
    N19: TMenuItem;
    WebBrowser1: TWebBrowser;
    Panel5: TPanel;
    TutorialNameLbl: TvtLabel;
    TutorialZoomInBtn: TSpeedButton;
    TutorialZoomOutBtn: TSpeedButton;
    Panel6: TPanel;
    CloseTutorialBtn: TBitBtn;
    NextTutorialBtn: TBitBtn;
    PrevTutorialBtn: TBitBtn;
    DemonstrateTutorialBtn: TBitBtn;
    URLs: TComboBox;
    Splitter1: TSplitter;
    HelpIndexBtn: TBitBtn;
    vtLabel1: TvtLabel;
    Backupthetaxdata1: TMenuItem;
    Restoredatafrombackup1: TMenuItem;
    N34: TMenuItem;
    CopyAReturnBtn: TBitBtn;
    Label4: TLabel;
    TutorialListBox: TListBox;
    ShowBarCodedata1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    CopyBtn: TSpeedButton;
    TreeViewBtn: TSpeedButton;
    SwapBtn: TSpeedButton;
    FindKeyWordintheform1: TMenuItem;
    N24: TMenuItem;
    N26: TMenuItem;
    GroupBox1: TGroupBox;
    SpeedButton5: TSpeedButton;
    SpeedButton8: TSpeedButton;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Image3: TImage;
    AppUpdateDate2Lbl: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    PrintMailingLabelcurrentclient1: TMenuItem;
    Importfromlastyear1: TMenuItem;
    T3coveringletter1: TMenuItem;
    TrustReturn1: TMenuItem;
    T3SupplementarySlips1: TMenuItem;
    Partnershipcoveringletter1: TMenuItem;
    Partnershipreturn1: TMenuItem;
    T5013Slips1: TMenuItem;
    FillableForms1: TMenuItem;
    AboutFillableForms1: TMenuItem;
    FilableFormsWeb1: TMenuItem;
    N4: TMenuItem;
    T2202AEducationSlips1: TMenuItem;
    N5: TMenuItem;
    CharityReturn1: TMenuItem;
    CCRAT3GuideT4013PDFformat1: TMenuItem;
    CCRAT5013PartnershipGuideT4068PDFformat1: TMenuItem;
    N23: TMenuItem;
    NAICSCodes1: TMenuItem;
    CurrentFormAllInstances1: TMenuItem;
    N17: TMenuItem;
    ContractPaymentsT50181: TMenuItem;
    T5018Summary1: TMenuItem;
    T5018AllGovermentslips1: TMenuItem;
    T5018AllRecipientslips1: TMenuItem;
    CRACharityGuideT1033B1: TMenuItem;
    N28: TMenuItem;
    NR4Slips1: TMenuItem;
    INTERNETFiling1: TMenuItem;
    T5013PartnersS501: TMenuItem;
    Panel7: TPanel;
    LicenseLevelLbl: TLabel;
    Panel8: TPanel;
    AppUpdateDateLbl: TLabel;
    Panel3: TPanel;
    AppReleaseLbl: TLabel;
    KnownissuesLbl: TLabel;
    KnownIssues1: TMenuItem;
    PrintAllForms1: TMenuItem;
    FlagFrameAB1: TFlagFrameAB;
    FlagFrameBC1: TFlagFrameBC;
    FlagFrameSK1: TFlagFrameSK;
    FlagFrameAB2: TFlagFrameAB;
    FlagFrameSK2: TFlagFrameSK;

    //procedure PrintCt23Short(Retno:integer;FormName:String);

    //Function GetPrintTemplate(IncludeFiling:Boolean):string;
    Procedure GetFormsToPrint(RetNo:integer;Template:string;var FormsToPrint:TstringList;FrmType:String);
    //Procedure PrintCCRAT3Slips(RetNo:Integer;CopyType:Integer);
    //Procedure PrintT3Slips(RetNo:Integer;CopyType:Integer);
    Procedure PrintT5013Slip(RetNo:Integer;SlipInstanceToPrint:String;CopyId:String);
    //Procedure PrintT5013Slip(RetNo:Integer;SlipId:String;CopyId:String);
    procedure PrintAReturn(WhichFormType:String;Template:String);
    Procedure PrintStudentT2202(RetNo:Integer;CopyType:Integer);
    Procedure PrintDesignatedT2202(RetNo:Integer;CopyType:Integer);
    Procedure PrintEducationalT2202(RetNo:Integer;CopyType:Integer);
    procedure WebBrowser1BeforeNavigate2(Sender: TObject;
             const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
             Headers: OleVariant; var Cancel: WordBool);
    procedure ReduceTutorialHeight(Sender: TObject);
    Function GetTutorialFileName:String;
   // procedure FindUrlAddress(Url:String);
    function SendMAPIMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
    Procedure PrintReturnForEMail(RetNo:Integer;Template:String);
    procedure PrintFormForEmail(RetNo:Integer;FormName:String);
    procedure DelphiZoom(ScalePercent:Integer);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
     MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
           MousePos: TPoint; var Handled: Boolean);
    //function IsReturnOpen(const AFormName: TForm; const AMDIChildName : string): Boolean;
    function  IsReturnOpen(RNo:Integer): Boolean;
    Procedure GetListOfLoadedReturns(SomeList:TStringList);
    //Procedure ShowUnprocessedEfiles;
    procedure ProcessBlackBoxFile;
    Procedure UsedFormsOnTreeView(RetNo:Integer);
    function ConvertFormOrText(FileToConvertFrom:string;ConversionType:TDFMorTXT):Boolean;
    procedure FormsTreeView1KeyPress(Sender: TObject; var Key: Char);
    procedure AuditOpenBtnClick(Sender: TObject);
    procedure SetHorScrollBarInListBox(ListBox: TListBox; MaxWidth: Integer);
    procedure WidePanelBtnClick(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
    procedure AdjustFontSize;
    Procedure ListBunchOfForms(TypeOfForm:string;ListCaption:String);
    procedure StartPrintForm(Retno:integer;FormName:String;WhichPage:integer);
   // procedure GetFormSections(FName:String;Var SomeList:TstringList; Var TopList:TstringList);
    Procedure UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
    procedure PrintReturn(RetNo:integer;FormsToPrint:TstringList;DataDir:string;FlName:string);
    Function ButtonInactive:Boolean;
    procedure FormCreate(Sender: TObject);
    procedure FileNewItemClick(Sender: TObject);
    procedure FileCloseItemClick(Sender: TObject);
    procedure FileOpenItemClick(Sender: TObject);
    procedure FileExitItemClick(Sender: TObject);
    procedure FileSaveItemClick(Sender: TObject);
    procedure FileSaveAsItemClick(Sender: TObject);
    procedure CutItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SelectFormClick(Sender: TObject);
    procedure RestoreReturnClick(Sender: TObject);
    procedure RestoreAllClick(Sender: TObject);
   // procedure Operational1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ChangeLicenseLevel;
   // procedure SlipsItemClick(Sender: TObject);
    procedure PrinterSetupClick(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    //procedure SlipsBtnClick(Sender: TObject);
    procedure PrintRBtnClick(Sender: TObject);
    procedure ToolBarBtnClick(Sender: TObject);
   // procedure ImportBtnClick(Sender: TObject);
    procedure AboutItemClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure MemGaugeClick(Sender: TObject);

    procedure FormPaint(Sender: TObject);
    procedure StatusBarClick(Sender: TObject);
    Procedure InitColorPanel;
    procedure clrcustomClick(Sender: TObject);
    procedure clr0Click(Sender: TObject);
    procedure clr1Click(Sender: TObject);
    procedure clr2Click(Sender: TObject);
    procedure clr3Click(Sender: TObject);
    procedure clr4Click(Sender: TObject);
    procedure clr5Click(Sender: TObject);
    procedure clr6Click(Sender: TObject);
    procedure clr7Click(Sender: TObject);
    procedure clr8Click(Sender: TObject);
    procedure clr9Click(Sender: TObject);
    procedure clr10Click(Sender: TObject);
    procedure clr11Click(Sender: TObject);
    procedure OpenbyFileName1Click(Sender: TObject);
    procedure Calendar1Click(Sender: TObject);
    procedure ClientLetter1Click(Sender: TObject);
    procedure PrintForm1Click(Sender: TObject);
   // procedure BatchPrinting1Click(Sender: TObject);
  //  procedure CopyReturns1Click(Sender: TObject);
  //  procedure MoveReturns1Click(Sender: TObject);
   // procedure DeleteReturns1Click(Sender: TObject);
    procedure PrintFBtnClick(Sender: TObject);
    //procedure CreateRTU1Click(Sender: TObject);
    procedure Modem1Click(Sender: TObject);
    procedure CreateDataDirectory1Click(Sender: TObject);
    procedure PrintTemplates1Click(Sender: TObject);
    procedure FeeSchedule1Click(Sender: TObject);
   // procedure OpenSpecificTypes1Click(Sender: TObject);
    procedure Fonts1Click(Sender: TObject);
    //procedure OverrideText1Click(Sender: TObject);
    procedure RemovecurrentreturnOverridesClick(Sender: TObject);
    procedure RemovecurrentfieldoverrideClick(Sender: TObject);
 //   procedure SetCurrentFieldOverrideClick(Sender: TObject);
    procedure Lockamountoncurrentfield1Click(Sender: TObject);
    //procedure EFRejectBtnClick(Sender: TObject);
    procedure CouplBtnClick(Sender: TObject);
    procedure OverrideBtnClick(Sender: TObject);
    procedure DataDictionary1Click(Sender: TObject);
    //procedure EFErrorsMasterList1Click(Sender: TObject);
    //procedure SICCodes1Click(Sender: TObject);
    //procedure FinancialInstitutions1Click(Sender: TObject);
    procedure DiagnosticsClick(Sender: TObject);
    {procedure AuditBtnClick(Sender: TObject);}
    procedure SamplesBtnClick(Sender: TObject);
    procedure Line1Click(Sender: TObject);
    procedure JacketClick(Sender: TObject);
    procedure PersonaldataClick(Sender: TObject);
    procedure FixDataDictionary1Click(Sender: TObject);
    procedure FixFormSpecifications1Click(Sender: TObject);
    procedure FixClientDataBaseData1Click(Sender: TObject);
    procedure ShowCellNumbers1Click(Sender: TObject);
    procedure ChangeDataDirectory1Click(Sender: TObject);
    procedure ClientListing1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    //procedure StartCoupling1Click(Sender: TObject);
    //procedure EndCoupling1Click(Sender: TObject);
    procedure LoadSpousalReturnfromdatabaseCreate1Click(Sender: TObject);
    //procedure SwapBtnClick(Sender: TObject);
    procedure SwapReturns1Click(Sender: TObject);
    procedure Switchforms1Click(Sender: TObject);
    procedure SwapFrmClick(Sender: TObject);
    procedure FormsBtnClick(Sender: TObject);
    procedure UserSetUp1Click(Sender: TObject);
    //procedure CashReports1Click(Sender: TObject);
    procedure TipsBtnClick(Sender: TObject);
   // procedure Tips1Click(Sender: TObject);
    //procedure EFErrorBtnClick(Sender: TObject);
    procedure CopyForm1Click(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    //procedure DataBaseAnalyser1Click(Sender: TObject);
    procedure SchedBtnClick(Sender: TObject);
   // procedure ImportLastYearClick(Sender: TObject);
   // procedure TaxandEFileGuides1Click(Sender: TObject);
    procedure ShowWarnings;
    procedure FrmSumBtnClick(Sender: TObject);
   // procedure TSumBtnClick(Sender: TObject);
    //procedure EFileBtnClick(Sender: TObject);
    procedure UserSetUp2Click(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure Calculator1Click(Sender: TObject);
    procedure Appointments2Click(Sender: TObject);
    procedure TransmitRTU1Click(Sender: TObject);
    procedure Contents2Click(Sender: TObject);
    procedure SearchForHelpOnClick(Sender: TObject);
    procedure VisualTaxGuide1Click(Sender: TObject);
    procedure Allforms1Click(Sender: TObject);
    //procedure Pg1Click(Sender: TObject);
    //procedure SectionBtnClick(Sender: TObject);
    procedure EFileerrorsCurrentReturn1Click(Sender: TObject);
    procedure MultipleDnBtnClick(Sender: TObject);
    procedure MultipleUpBtnClick(Sender: TObject);
    procedure Restructure1Click(Sender: TObject);
    procedure DependBtnClick(Sender: TObject);
    procedure ReviewBtnClick(Sender: TObject);
    procedure ABCBtnClick(Sender: TObject);
    //procedure BusnBtnClick(Sender: TObject);
    {procedure RemoveUnusedWindows1Click(Sender: TObject);}
    procedure PrintManager1Click(Sender: TObject);
    procedure ClientLetters1Click(Sender: TObject);
    procedure TaxReturnCoveringletter1Click(Sender: TObject);
    //procedure MailingLabels1Click(Sender: TObject);
    procedure ShowOverridesClick(Sender: TObject);
    procedure ListReviewmarks1Click(Sender: TObject);
    procedure SystemInformation1Click(Sender: TObject);
    procedure RebuildtheClientDataBase1Click(Sender: TObject);
    procedure MergeDataBases1Click(Sender: TObject);
    procedure FileViewerEditor1Click(Sender: TObject);
    procedure CurrentPage1Click(Sender: TObject);
    //procedure PlanNextYearClick(Sender: TObject);
   // procedure YSumBtnClick(Sender: TObject);
    //procedure SelfEmployment1Click(Sender: TObject);
   // procedure ComparativeSummaryClick(Sender: TObject);
    //procedure OptimizeFamilyprocessing1Click(Sender: TObject);
    //procedure ViewLastYearClick(Sender: TObject);
    //Procedure PaintFirstReturn;
    procedure CplBtnClick(Sender: TObject);
    procedure MinTaxBtnClick(Sender: TObject);
    //procedure Openselectively1Click(Sender: TObject);
    //procedure ListEFileRejectedReturns1Click(Sender: TObject);
    //procedure SSumBtnClick(Sender: TObject);
    procedure ClientListings1Click(Sender: TObject);
    procedure CopyBackUp1Click(Sender: TObject);
    procedure RecalcBtnClick(Sender: TObject);
   // procedure ListBalances1Click(Sender: TObject);
    //procedure PresSelBtnClick(Sender: TObject);
   // procedure PreSelForms1Click(Sender: TObject);
    procedure PreselNextBtnClick(Sender: TObject);
    procedure PreSelPrvBtnClick(Sender: TObject);
    //procedure PrintEFilereportsACKACXTSRERR1Click(Sender: TObject);
    //procedure OnestepEFile1Click(Sender: TObject);
    //procedure PrintReturnBalances1Click(Sender: TObject);
    procedure DeveloperOnly1Click(Sender: TObject);
    procedure NISAcodes1Click(Sender: TObject);
   // procedure ONESTEPModemCommunications1Click(Sender: TObject);
    {Function  FeatureAllowed:Boolean;}
    //procedure UpdateT1MasterfromRTURTX1Click(Sender: TObject);
    //procedure UpdateT1MasterfromACKACXfiles1Click(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure YourLatestReleaseClick(Sender: TObject);

    procedure ZoomBtnPlusClick(Sender: TObject);
    procedure ZoomBtnMinusClick(Sender: TObject);
   // procedure RefreshOpenedForms(RetNo:Integer);
    //procedure AuditCloseBtnClick(Sender: TObject);

    Procedure RefreshAuditPanel(RetNo:Integer);
    procedure AuditOptionClick(Sender: TObject);
    {
    procedure ZoomBtnDownClick(Sender: TObject);
    procedure ZoomBtnUpClick(Sender: TObject);
    }
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure AuditPanelDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure AuditListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure AuditHeaderDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure AuditListBoxDragDrop(Sender, Source: TObject; X,
      Y: Integer);
    procedure StatusBarDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure StatusBarDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure AuditPanelDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure AuditSpinBtnDownClick(Sender: TObject);
    procedure AuditSpinBtnUpClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    Procedure FullPrint(RetNo:Integer;Template:String);
    procedure Upgrade1Click(Sender: TObject);
   // procedure ReviseLook;
    procedure AuditListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    //procedure YTDCashreports1Click(Sender: TObject);
    //procedure YTDdirectorySetup1Click(Sender: TObject);
    Procedure ShowMultiOfficeMsg;
    //procedure Submitdailycashreport1Click(Sender: TObject);
    //procedure CopyDailyCashReport1Click(Sender: TObject);
    Function  EditBeforeSave(RetNo:Integer):Boolean;
    procedure InternetWebSite1Click(Sender: TObject);
    procedure WWWLblClick(Sender: TObject);
    procedure ExpandBtnClick(Sender: TObject);
    procedure CollapseClick(Sender: TObject);
    procedure FormsTreeView1Click(Sender: TObject);
    //procedure EfileSetupBtnClick(Sender: TObject);
    procedure WorldButtonClick(Sender: TObject);
  //  Procedure OpenNonModalForm(RetNo:Integer;FName:String);
   // Procedure PrintRichLetter(RetNo:Integer;LetterName:String);
    //procedure ClientStatistics1Click(Sender: TObject);
    procedure AlphabeticalFormsIndex1Click(Sender: TObject);
    procedure Zoomin1Click(Sender: TObject);
    procedure Zoomout1Click(Sender: TObject);
    procedure Toolbandswitch1Click(Sender: TObject);
    procedure Color1Click(Sender: TObject);
    procedure Recalc1Click(Sender: TObject);
    //procedure SlipSummary1Click(Sender: TObject);
    //procedure ExportData1Click(Sender: TObject);

    procedure VerticalSplitter1CanResize(Sender: TObject;
      var NewSize: Integer; var Accept: Boolean);
   // procedure OtherOptions1Click(Sender: TObject);
   // procedure ShowTreeview1Click(Sender: TObject);
    procedure ReIndextheClientDataBase1Click(Sender: TObject);
    procedure TreeViewBtnClick(Sender: TObject);
    //procedure CreateSENDRTU1Click(Sender: TObject);
    //procedure ExplorerBtnClick(Sender: TObject);
    procedure RestructuretheClientsDataBase1Click(Sender: TObject);
    //procedure NetFileForindividuals1Click(Sender: TObject);
    //procedure StartEOL;
    //procedure StartEOLP;
    procedure ErrorViewClick(Sender: TObject);
    procedure ExchageRatesAverage1Click(Sender: TObject);
    //procedure InvoiceAdjustments1Click(Sender: TObject);
    //procedure OpenbyFileNameSIN1Click(Sender: TObject);
    //procedure AgentSetup1Click(Sender: TObject);
    //procedure ListofEfileErrors1Click(Sender: TObject);
    procedure Checkupdate1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure CheckUpdatesLblClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure ClearCurrentformClick(Sender: TObject);
    procedure ClearCurrentPageClick(Sender: TObject);
    Function  SelectFromLoadedReturns(RetNo:Integer):Integer;
    //procedure WizardBtnClick(Sender: TObject);
    procedure UsedFormsBoxClick(Sender: TObject);
    procedure ErrorViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ErrorViewCustomDrawItem(Sender: TCustomTreeView;
      Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    //procedure MOSTRECENTFILES1Click(Sender: TObject);
    procedure ShowMostRecentReturns;
   // procedure RollForwardfromgreenPoint1Click(Sender: TObject);
   // procedure RollForwardfromCanTaxT120011Click(Sender: TObject);
    procedure SuperAuditBoxClick(Sender: TObject);
    Procedure PutFrmDictOnFrmGrid(FrmNm:String;FileFound:Boolean);
    Procedure RefreshSuperAudit(RetNo:Integer);
    Procedure PutLastYearValueOnFrmGrid(Frmnm:String;FileFound:Boolean;LnNo:Integer;Description:String;Value:String);
  //  procedure T1GuideCCRA1Click(Sender: TObject);
    //procedure SuperReviewBoxClick(Sender: TObject);
    procedure OpenPreviousYearsT11Click(Sender: TObject);
    procedure ImportConfiguration1Click(Sender: TObject);
    procedure ExportConfiguration1Click(Sender: TObject);
    procedure Findaline1Click(Sender: TObject);
    //procedure SENDErrors1Click(Sender: TObject);
    procedure LinesBtnClick(Sender: TObject);
    //procedure EFILEONLINEPLUS1Click(Sender: TObject);
    //procedure EOLClick(Sender: TObject);
    //procedure EOLPClick(Sender: TObject);
    //procedure EOLPLUS1Click(Sender: TObject);
    //procedure SetupEOL1Click(Sender: TObject);
    //procedure SetupEOLPlus1Click(Sender: TObject);
    procedure UsefulLinksClick(Sender: TObject);
    procedure SetReturnPassword1Click(Sender: TObject);
    procedure RemoveReturnPassword1Click(Sender: TObject);
    procedure SetProgramPassword1Click(Sender: TObject);
    procedure RemoveProgramPassword1Click(Sender: TObject);
    //procedure ProcessAcknowledgements1Click(Sender: TObject);
    procedure PrintAuditBtnClick(Sender: TObject);
  //  procedure PrintAuditWizardDiagnostics1Click(Sender: TObject);
    procedure EmailCurrentFormClick(Sender: TObject);
    //procedure Processtransmittedfiles1Click(Sender: TObject);
    //procedure PrintAcknowledgementreport1Click(Sender: TObject);
    //procedure DisplayAcknowledgementfile1Click(Sender: TObject);
    //procedure PrintTEDfile1Click(Sender: TObject);
    Function  SaveAllReturns:Boolean;
    Procedure CloseAllReturns;
    procedure SaveALLopenedreturns1Click(Sender: TObject);
    procedure SaveandCloseAllopenedreturns1Click(Sender: TObject);
    procedure TestBlBoxClick(Sender: TObject);
    procedure CloseBlackBoxBtnClick(Sender: TObject);
    procedure FormsBlackBoxBtnClick(Sender: TObject);
    //procedure Familysetup1Click(Sender: TObject);
    //procedure SENDtransaction1Click(Sender: TObject);
    procedure Provincialnews1Click(Sender: TObject);
    //procedure TakeShapshotforT1Adj1Click(Sender: TObject);
    //procedure CreatetheT1ADJform1Click(Sender: TObject);
   // procedure LineByLinehelp1Click(Sender: TObject);
    Function  CountFiles(Dir:String;FileExt:String):Integer;
    procedure CICALineByLineInternethelpNONResidents1Click(
      Sender: TObject);
    procedure OtherGuides1Click(Sender: TObject);
    procedure CCArates1Click(Sender: TObject);
    procedure Checkupdates1Click(Sender: TObject);
    procedure Frequentlyaskedquestions1Click(Sender: TObject);
    procedure VisualTaxForum1Click(Sender: TObject);
    procedure HowoftentocheckInternetUpdates1Click(Sender: TObject);
  //  procedure CICA1Click(Sender: TObject);
  //  procedure CICAHelpbyline1Click(Sender: TObject);
//    procedure CICAReferencematerials1Click(Sender: TObject);
   // procedure IncomeTaxAct1Click(Sender: TObject);
   // procedure InterpretationBulletinsITs1Click(Sender: TObject);
   // procedure InformationCircularsICs1Click(Sender: TObject);
   // procedure IncomeTaxRegulations1Click(Sender: TObject);
    procedure TrEngineLoadClick(Sender: TObject);
   // procedure OpenedFormsTabChange(Sender: TObject);
   // procedure ClearOpenedFormsListClick(Sender: TObject);
   // procedure OpenedFormsTabDrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure ListMultipleBtnClick(Sender: TObject);
    procedure TrGuide1Click(Sender: TObject);
    procedure DefinetheTRfolder1Click(Sender: TObject);
    procedure TileVertical1Click(Sender: TObject);
    procedure VerticalSplitter2CanResize(Sender: TObject;
      var NewSize: Integer; var Accept: Boolean);
    procedure ReturnsListBoxClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure TileHorizontally1Click(Sender: TObject);
    procedure CloseallreturnsWITHOUTSaving1Click(Sender: TObject);
    //procedure ShowLastYearForm1Click(Sender: TObject);
    procedure Setdisplayresolution1Click(Sender: TObject);
    //procedure PORTFOLIOACBTRACKER1Click(Sender: TObject);
    procedure NewReturnLblClick(Sender: TObject);
    procedure OpenReturnLblClick(Sender: TObject);
    //procedure MostRecentLblClick(Sender: TObject);
   // procedure RollOvrerLblClick(Sender: TObject);
    procedure WhatsNewLblClick(Sender: TObject);
    procedure FaQLblClick(Sender: TObject);
    procedure HelpLblClick(Sender: TObject);
    procedure ForumLblClick(Sender: TObject);
    procedure TRLblClick(Sender: TObject);
    //procedure ListBox1DblClick(Sender: TObject);
    procedure Lockreturnagaistchanges1Click(Sender: TObject);
    procedure UnlockReturn1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyPress(Sender: TObject; var Key: Char);
    procedure Options2Click(Sender: TObject);
    procedure QuestionMarkLblMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
   // procedure RateBtnClick(Sender: TObject);
    //procedure SpeedButton2Click(Sender: TObject);
    procedure LicLevel1Click(Sender: TObject);
    procedure PrepareDistr1Click(Sender: TObject);
    procedure ActionList1Execute(Action: TBasicAction;var Handled: Boolean);
    //procedure SetupEOL1Click(Sender: TObject);
    //procedure SetupEOLPlus1Click(Sender: TObject);
    procedure EkUDFList1Functions0Calculate(Sender: TObject;Args: TEkUDFArgs; ArgCount: Integer;
              UDFResult: TObject);
    procedure EmailTheReturnClick(Sender: TObject);
    procedure OpenItBtnClick(Sender: TObject);
    procedure EMailItBtnClick(Sender: TObject);
    procedure TUTORIALS1Click(Sender: TObject);
    procedure CloseTutorialBtnClick(Sender: TObject);
    procedure NextTutorialBtnClick(Sender: TObject);
    procedure PrevTutorialBtnClick(Sender: TObject);
    procedure ToolBoxSplitterCanResize(Sender: TObject;
      var NewSize: Integer; var Accept: Boolean);
    procedure DemonstrateTutorialBtnClick(Sender: TObject);
    procedure TutorialZoomInBtnClick(Sender: TObject);
    procedure TutorialZoomOutBtnClick(Sender: TObject);
    //procedure TutBackwardBtnClick(Sender: TObject);
    //procedure TutForwardBtnClick(Sender: TObject);
    procedure HelpIndexBtnClick(Sender: TObject);
    procedure Backupthetaxdata1Click(Sender: TObject);
    procedure Restoredatafrombackup1Click(Sender: TObject);
    procedure CopyAReturnBtnClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure TutorialListBoxClick(Sender: TObject);
    procedure ShowBarCodedata1Click(Sender: TObject);
    procedure StatusBarBtnClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure NewBtnToolBarClick(Sender: TObject);
    procedure OpenBtnToolBarClick(Sender: TObject);
    procedure CloseBtnToolBarClick(Sender: TObject);
    procedure SaveBtnToolBarClick(Sender: TObject);
  //  procedure FilingCopy1Click(Sender: TObject);
  //  procedure ClientPreparerCopy1Click(Sender: TObject);
 //   procedure T2BtnClick(Sender: TObject);
  //  procedure OntBtnClick(Sender: TObject);
//    procedure AlbBtnClick(Sender: TObject);
 //   procedure GifiIsBtnClick(Sender: TObject);
//    procedure FNotesBtnClick(Sender: TObject);
//    procedure OntarioExemptfromfiling1Click(Sender: TObject);
//    procedure OntarioShortCT231Click(Sender: TObject);
//    procedure OntarioLongCT231Click(Sender: TObject);
 //   procedure FilingcopyAlbertaRSI1Click(Sender: TObject);
//    procedure ClientPreparercopy2Click(Sender: TObject);
//    procedure T183CORPInformationonEFiling1Click(Sender: TObject);
 //   procedure BuildandTransmit1Click(Sender: TObject);
 //   procedure SetupEOLInternetFiling1Click(Sender: TObject);
//    procedure CreateEfileEDI1Click(Sender: TObject);
//    procedure EfileSetup1Click(Sender: TObject);
    procedure SwapBtnClick(Sender: TObject);
//    procedure EFileBtnClick(Sender: TObject);
  //  procedure RolloverVisualTax1Click(Sender: TObject);
  //  procedure RolloverCanTax1Click(Sender: TObject);
//    procedure RolloverProfile1Click(Sender: TObject);
//    procedure ImportBtnClick(Sender: TObject);
//    procedure RollOvrerLblClick(Sender: TObject);
//    procedure GIFIBSFullChartofAccountsreference1Click(Sender: TObject);
//    procedure GIFIBSFullChartofAccountsreference2Click(Sender: TObject);
//    procedure Builda5yearcomarativesummary1Click(Sender: TObject);
//    procedure GIFIGuide1Click(Sender: TObject);
//    procedure AlbertaAT1GuidePart11Click(Sender: TObject);
    //procedure AlbertaAT1GuidePart21Click(Sender: TObject);
//    procedure CT23Guide1Click(Sender: TObject);
//    procedure FindKeyWordintheform1Click(Sender: TObject);
 //   procedure ResourceTaxation1Click(Sender: TObject);
//    procedure ProvincialRates1Click(Sender: TObject);
//    procedure Builda5yearsummaryFromVisualTax1Click(Sender: TObject);
//    procedure AlbertaTaxGuidePart21Click(Sender: TObject);
//    procedure YSumBtnClick(Sender: TObject);
    procedure QuickStarterGuide1Click(Sender: TObject);
    procedure PrintMailingLabelcurrentclient1Click(Sender: TObject);
    procedure QuickStartLblClick(Sender: TObject);
    procedure Importfromlastyear1Click(Sender: TObject);
    procedure T3coveringletter1Click(Sender: TObject);
    procedure TrustReturn1Click(Sender: TObject);
    procedure T3SupplementarySlips1Click(Sender: TObject);
    procedure Partnershipcoveringletter1Click(Sender: TObject);
    procedure Partnershipreturn1Click(Sender: TObject);
    procedure T5013Slips1Click(Sender: TObject);
    procedure AboutFillableForms1Click(Sender: TObject);
    procedure FilableFormsWeb1Click(Sender: TObject);
    procedure T2202AEducationSlips1Click(Sender: TObject);
    procedure CharityReturn1Click(Sender: TObject);
    procedure CCRAT3GuideT4013PDFformat1Click(Sender: TObject);
    procedure CCRAT5013PartnershipGuideT4068PDFformat1Click(
      Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure RollOvrerLblClick(Sender: TObject);
    procedure NAICSCodes1Click(Sender: TObject);
    procedure N2008TaxRatesanddraftlegislation1Click(Sender: TObject);
    procedure CRAT5013SupplementaryGuideT406811Click(Sender: TObject);
    procedure CurrentFormAllInstances1Click(Sender: TObject);
    procedure ContractPaymentsT50181Click(Sender: TObject);
    procedure T5018Summary1Click(Sender: TObject);
    procedure T5018AllGovermentslips1Click(Sender: TObject);
    procedure T5018AllRecipientslips1Click(Sender: TObject);
    procedure CRACharityGuideT1033B1Click(Sender: TObject);
    procedure NR4Slips1Click(Sender: TObject);
    procedure INTERNETFiling1Click(Sender: TObject);
    procedure T5013PartnersS501Click(Sender: TObject);
    procedure PrintT5013PS50(RetNo:Integer);
    procedure KnownIssues1Click(Sender: TObject);
    procedure KnownissuesLblClick(Sender: TObject);
    procedure PrintAllForms1Click(Sender: TObject);

  private
   Count : Integer;   {for timer}
   TutHistoryIndex: Integer;
   TutHistoryList: TStringList;
   TutUpdateCombo: Boolean;
   HelpKeyW:TStringList;

   procedure FindUrlAddress;

   { Procedure MyMsgHandler(Var Msg:TMsg; Var Handled:Boolean);}

    { Private declarations }
    {procedure CreateMDIChild(Formno: integer);}
    procedure ShowHint(Sender: TObject);
    {Procedure CMDialogKey(Var Msg: TWMKey); message CM_DIALOGKEY;}

  public
    { Public declarations }

  end;

var
  MainForm: TMainForm;
  Report : TQuickRep;
  AQRReport : TQuickRep;
  TutorialFile:TFileName;
  TutorialScript:String;
Implementation

{$R *.DFM}

(* {$R CPLCURS.RES} *)
uses ChildWinNew,UHeaderFrame, uPrintSelectedT3Slips,uPrintSelectedNR4Slips;
var MyTab:TPageControl; MyTabSheet:TTabSheet;MyScrollBox:TScrollbox;MyPanel:Tpanel;

procedure TMainForm.FormCreate(Sender: TObject);
Var i:Integer;TempList:TStringList;
begin
 AppUpdateDate2Lbl.Caption:= 'As of: '+AppUpdateDate;
 TutHistoryIndex := -1;
 TutHistoryList := TStringList.Create;
 TutUpdateCombo:=True;
 HelpKeyW:=TStringList.Create;

  ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
 // If FileExists(AppDir+'\'+RecentFlName) = False then InitMostRecentFiles(30); //put them in RecentFlName
  ShowMostRecentReturns;
  Application.OnException := AppException;
  FormsTreeview1.LoadFromFile(AppDir+'\Treeview2.D');
  SuperFeaturesLbl.Caption:='';
  ToolBoxSplitter.Align := alTop;
  VerticalSplitter1.Align:=alNone; //initially

  ReturnsPanel.Align:=alTop;
  WizardPanel.Align:=alClient;
  ReturnsListBox.Align:=alClient;
  InitColorPanel;
  Application.OnHint := ShowHint;
  AdjustFontSize;

  If (Screen.width <800) then
  begin
   ShowMessage('Screen resolution of at least 800 x 600 is recommended'+
     Chr(13) + 'Set with Start|Settings|Control Panel|Display|Settings');
  end;
  If OptRec.FormZoom=0 then OptRec.FormZoom:=GetDefaultScaling;
 AboutPanel.Visible:=False;
 WizardPanel.visible:=True; //False;
 FormsPanel.visible:=True;
 FormsTreeView1.Align := alClient;

 AuditPanel.Align:=alClient;
 ErrorView.Align := alClient;
 LeftPanel.visible:=RetInMem>0; //True;   //RetInMem>0;
 LeftPanel.Width:=Screen.Width div 7;
 //FiscalPeriodsLbl.Caption:=MinStartPeriod+'   - '+MaxEndPeriod;
 end;

procedure TMainForm.FormPaint(Sender: TObject);
Var i : integer;
RetNo:Integer;
begin

 If TutorialsPanel.Visible then
 begin
  TutorialZoomInBtn.Visible:=RetInMem>0;
  TutorialZoomOutBtn.Visible:=RetInMem>0;
  If RetInMem =0 then
   TutorialsPanel.Height:=Screen.height * 3 div 4;
 end;

 //LockWindowUpdate(AboutPanel.Handle); //bad
 ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
 RetNo:=GetCurrentRetNo;
 AboutPanel.left := (Screen.Width - AboutPanel.Width) div 2;
 AboutPanel.Visible:=RetInMem=0;
 FormsTreeView1.Align := alClient;
 LeftPanel.Align:=alLeft;
 VerticalSplitter1.Visible:=RetInMem>0;
 WizardPanel.Visible:=True; //RetInMem>0;
 VerticalSplitter1.Align:=alLeft;

 AuditPanel.Align:=alClient;
 ErrorView.Align := alClient;

 Forms.Enabled := retInMem >0;

 ReturnsPanel.Height:=ReturnsHeaderPanel.Height+RetInMem * ReturnsListBox.ItemHeight+10;

 SelectFeatures;
 SomeList:=TStringList.Create;
 GetListOfLoadedReturns(SomeList);
 ReturnsListBox.Clear;
 For i:=0 to SomeList.count-1 do ReturnsListBox.Items.Add(SomeList[i]);
 SomeList.Free;

 If AboutPanel.Visible then
 begin
  AppReleaseLbl.Caption:= 'Release: '+AppRelease; //'Release: '+AppRelease;
  AppUpdateDateLbl.Caption:= 'Updated: '+AppUpdateDate;
  TradeMarkLbl.Caption := 'VisualTax';
  TradeMarkLbl.Font.Size :=20;
  //TradeMarkSymbolLbl.Visible := True;
  LicenseLevelLbl.Caption := 'Version: '+LicenseLevel;
 end;  //aboutpanel
 If RetInMem=0 then LeftPanel.Visible:=False;
 //LeftPanel.Visible :=RetInMem>0;
 Screen.Cursor := crDefault;
end; //paint


Procedure TMainForm.RefreshAuditPanel(RetNo:Integer);
Var i:Integer; TempList:TStringList;
begin
 If RetNo=0 then exit;
 LockWindowUpdate(MainForm.Handle);
 TempList:=TStringList.Create;
 ErrorCount := CountDiagnostics(RetNo);

 AuditListToTreeView(Ret[RetNo]^.AuditList,TempList);
 TempList.SaveToFile(AppDir+'\'+'Temp');
 LockWindowUpdate(ErrorView.Handle);
 ErrorView.LoadFromFile(AppDir+'\'+'Temp');
 ErrorView.FullExpand;
 ErrorView.TopItem:=ErrorView.Items[0];

 TempList.Free;

 If RetInMem >1 then
  ErrorView.Color := GetRetColor(RetNo)
 else
  ErrorView.Color := Rgb(255,255,240);//AuditPanel.Color;

 LockWindowUpdate(0);
end; {procedure}


Function TMainForm.ButtonInactive:Boolean;
begin
 If RetInMem <1 then
  Begin
  Result := True;
  ShowMessage('You must open a return first');
  end
 Else
  Result := false;
end;

procedure TMainForm.ShowHint(Sender: TObject);
begin
 { StatusLine.Caption := Application.Hint;}
end;


procedure TMainForm.FileNewItemClick(Sender: TObject);
Var k,RetNo:Integer;
begin
 If (OptRec.Dir_Deflt = '') or
  (Not FileExists(OptRec.Dir_Deflt+'\'+'Clients.DBF')) then
  begin
   showMessage('Data directory has not been defined'+
   Chr(13)+'Click on Configure | General Options \ Data Directories');
   exit;
  end;

  if RetInMem >= ReturnsLimit then
     begin
     ShowMessage('Exceeded maximum number of returns that fit in memory');
     exit;
     end
  else
  begin
   If ResourcesLow then
    begin
    ShowMessage('Cannot open more...Overloaded!'+
      Chr(13)+'Close some windows or returns or other applications'
      +Chr(13)+ 'and Retry');
    exit;
  end;
  CreatingNew := True;
  k:=InitNewReturn;
  if k>0 then
  begin
    RetNo:=k;
    OpenForm(RetNo,GetFormNo('T3'),0);
    LeftPanel.Visible:=True;
   {
    Application.CreateForm(TFrmTypes,FrmTypes);
    FrmTypes.ShowModal;
    FrmTypes.Free;
    }
  end;
 end;
end;

procedure TMainForm.FileOpenItemClick(Sender: TObject);
Var RetNo,PrvRNo:Integer;
begin
 (*
  ExecuteForm(TClientBook);
  RetNo:=GetCurrentRetNo;
  If RetNo=0 then exit;
 *)

   Application.CreateForm(TClientBook,ClientBook);
   ClientBook.ShowModal;
   ClientBook.Free;

end;

procedure TMainForm.FileSaveItemClick(Sender: TObject);
begin
If ButtonInactive then exit;
FileSaveAsItemClick(Sender);
end;

procedure TMainForm.FileSaveAsItemClick(Sender: TObject);
Var RetNo:Integer;
begin
 If ButtonInactive then exit;
 RetNo:=GetCurrentRetNo;
 CalcAll(RetNo);
 UpdateAllDataIndicators(RetNo);
 MyChild.UpdateChildTaxPanel(RetNo);

 If EditBeforeSave(RetNo) = false then
 begin
   If not WizardPanel.Visible then AuditOpenBtnClick(Application);
   ShowMessage('Please enter Mandatory data before saving');
   exit;
 end;
 Application.CreateForm(TSaveAs,SaveAs);
 SaveAs.ShowModal;
 SaveAs.Free;
end;

procedure TMainForm.FileCloseItemClick(Sender: TObject);
Var i:Integer;FHandle:THandle;Action:TCloseAction;RetNo:Integer;
Begin
 If ButtonInactive then exit;
 FHandle:=GetWinHandleOfRetNo(GetCurrentRetNo);
 for i := MainForm.MDIChildCount - 1 DownTo 0 do
 begin
    If FHandle=MainForm.MDIChildren[i].Handle then
    begin
      MainForm.MDIChildren[i].Close;
      break;
    end;
 end;
 FormPaint(Sender);
end;

Function TMainForm.EditBeforeSave(RetNo:Integer):Boolean;
begin
 Result:=False;
 ErrorCount := CountDiagnostics(RetNo);
 If MandatoryErrorCount > 0 then Exit;
 Result :=true;
end;

procedure TMainForm.ShowWarnings;
begin
    Application.CreateForm(TWarning,Warning);
    Warning.ShowModal;
    Warning.Free;
    exit;
end;

procedure TMainForm.FileExitItemClick(Sender: TObject);
begin
 // SuperAuditBox.Checked := False;
  If CountUnsavedReturns = 0 then
    Application.Terminate {Close}
  else
   if MessageDlg(
     IntToStr(CountUnsavedReturns)
     + ' return(s) still in memory.'
     + Chr(13)+' Exit without closing the return(s)?',
     mtWarning, [mbNo, mbYes], 0) = mrYes then
        Application.Terminate; {Close;}
end;

function TMainForm.ConvertFormOrText(FileToConvertFrom:string;ConversionType:TDFMorTXT):Boolean;
var
  InputStream, OutputStream : TFileStream;
  FileToConvertTo : string;
begin
  Result := True;
 
  FileToConvertFrom := FileToConvertFrom;//ExtractFileName(FileToConvertFrom);
 
  FileToConvertTo := FileToConvertFrom;
 
  { change file extensions as appropriate }
  case ConversionType of
    ConvertToForm:
    begin
      FileToConvertFrom := ChangeFileext(FileToConvertFrom, '.TXT');
      FileToConvertTo := ChangeFileext(FileToConvertFrom, '.DFM');
    end;
    ConvertToText:
    begin
      FileToConvertFrom := ChangeFileExt(FileToConvertFrom, '.DFM');
      FileToConvertTo := ChangeFileExt(FileToConvertFrom, '.TXT');
    end;
  end;
  if not fileexists(FileToConvertFrom) then
  begin
   showmessage('File ' + FileToConvertFrom + ' does not exist');
   result := false;
   exit;
  end;
  try
    try
      // Create a file stream for the specified file
      InputStream  := TFileStream.Create(FileToConvertFrom, fmOpenRead);
      OutputStream := TFileStream.Create(FileToConvertTo, fmCreate);
 
      // perform the selected conversion
      case ConversionType of
       ConvertToForm :
       begin
           ObjectTextToResource(InputStream, OutputStream);
       end;
       ConvertToText :
       begin
           ObjectResourceToText(InputStream, OutputStream);
       end;
      end;
    except
      On EStreamError do
      begin
       Result := False;
       showmessage('Form Failed: ' + FileToConvertFrom);
      end;
    end;
  finally
    InputStream.Free;
    OutputStream.Free;
  end;
end;


procedure TMainForm.CutItemClick(Sender: TObject);
begin
  {cut selection to clipboard}
end;

(*
procedure TMainForm.CopyItemClick(Sender: TObject);
Var MyEditBox:TvtEdit;
begin
//MainForm.ActionList1.Actions[0];

{
 If RetNo<1 then exit;

 If MyChild.ActiveControl is TvtEdit
 then
 begin

  MyEditBox:=MyChild.ActiveControl as TvtEdit;
  MyEditBox.SelectAll;
  MyEditBox.CopyToClipboard;
 // Mychild.EditBox.CopyToClipboard;
 end;

}
end;
*)

(*
procedure TMainForm.PasteItemClick(Sender: TObject);
begin

 If RetNo<1 then exit;
{
 Mychild.EditBox.Clear;
 Mychild.EditBox.PasteFromClipboard;
}
end;
*)

(*
procedure TMainForm.WindowTileItemClick(Sender: TObject);
begin
  Tile;
  FormHandle := Screen.ActiveForm.Handle;
  //OpenFormViaHandle(FormHandle);
end;
*)
(*
procedure TMainForm.WindowCascadeItemClick(Sender: TObject);
Var CurHandle : Thandle;
begin
  Cascade;
  FormHandle := Screen.ActiveForm.Handle;
  //OpenFormViaHandle(FormHandle);
end;
*)
(*
procedure TMainForm.WindowArrangeItemClick(Sender: TObject);
begin
  ArrangeIcons;
end;
*)
(*
procedure TMainForm.MinimizeAllClick(Sender: TObject);
var
  I: Integer;
begin
  { Must be done backwards through the MDIChildren array }
  for I := (MainForm.MDIChildCount - 1) downto 0 do
      MainForm.MDIChildren[I].WindowState := wsMinimized;
 {UpdateInfoPanel;}
end;
*)
(*
Procedure TmainForm.UpdateInfoPanel;
 begin
  iRetNo.Caption := IntToStr(RetNo);
  iFormNo.Caption := IntToStr(FormNo);
  iHandle.Caption := IntToStr(ActiveHandle);
  iFormName.Caption := FormName;
  iFieldId.Caption := IntToStr(FieldId);
  iTabNo.Caption := IntToStr(TabNo);
  iMaxAvail.Caption := IntToStr(MaxAvail);
  iMemAvail.Caption := IntToStr(MemAvail);
  iRetInMem.Caption := IntToStr(RetInMem);
  iOriginalMemory.Caption := IntToStr(OriginalMemory);
  iFSysRes.caption :=inttostr(GetFreeSystemResources(GFSR_SYSTEMRESOURCES)) + '%';
  iFgdiRes.caption :=inttostr(GetFreeSystemResources(GFSR_GDIRESOURCES)) + '%';
  iFUserRes.caption :=inttostr(GetFreeSystemResources(GFSR_USERRESOURCES)) + '%';
  iTotFreeMem.caption :=inttostr((GetFreeSpace( WF_ENHANCED) div 100)) + ' kb ';
 end;
 *)

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveFormChange := nil;
end;

procedure TmainForm.RestoreReturnClick(Sender: TObject);
var
i: Integer;
WinList : TStringList;
CurHandle : Thandle;
begin
end;

procedure TMainForm.RestoreAllClick(Sender: TObject);
var
i : Integer;
CurHandle : Thandle;
begin
end;


procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 {}
end;

procedure TMainForm.SelectFormClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 //UpdateAllDataIndicators(GetCurrentRetNo);
 Application.CreateForm(TFrmType,FrmType);
 FrmType.ShowModal;
 FrmType.Free;
end;

procedure TMainForm.ListBunchOfForms(TypeOfForm:string;ListCaption:String);
Var I: integer;RetNo:Integer;
begin
 If RetInMem < 1 then exit;
 RetNo:=GetCurrentRetNo;
 SomeList := TStringList.Create;
 SomeList.Sorted := True;
 SomeCaption := ListCaption;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec^.FormShow) and (Frec^.FormType = TypeOfForm) then
       SomeList.Add(Frec^.FormAbrev); {FormRlNm); }
 end;
 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 SomeList.Free; PopList.Release;
 If SelectedString > '' then
 begin
   FName := Rtrim(GetFName(SelectedString));  {using Real Name}
   OpenForm(RetNo,GetFormNo(FName),0);
 end;
end;



procedure TMainForm.PrinterSetupClick(Sender: TObject);
begin
  PrintDialogItem.Execute;
end;

procedure TMainForm.NewBtnClick(Sender: TObject);
begin
FileNewItemClick(Sender);

end;



procedure TMainForm.PrintRBtnClick(Sender: TObject);
Var I : integer;
begin
  {If RetNo < 1 then exit;}
  If ButtonInactive then exit;
  SomeList := TStringList.Create;
  SomeCaption := 'Print';
  SomeList.Add('Current Page');
  SomeList.Add('Current Form');
  SomeList.Add('Current Return');
  Application.CreateForm(TPoplist,PopList);
  PopList.ShowModal;
  SomeList.Free; PopList.Release;
  If SelectedString = '' then exit;
  {PrintDialogItem.Options := [poWarning];}
  If SelectedString = 'Current Page' then CurrentPage1Click(Sender)
  else If SelectedString = 'Current Form' then PrintForm1Click(Sender);
  //else if SelectedString = 'Current Return' then PrintCurrentReturn1Click(Sender);
end;


procedure TMainForm.StatusBarBtnClick(Sender: TObject);
begin
EXIT;
 (*
 If RetInMem=0 then exit;
 RetNo:=GetCurrentRetNo;
 MyChild:=MainForm.ActiveMdiChild as TMyChild;
 StatusBarSw := not StatusBarSw;
  If StatusBarSw then
  begin
   StatusBarBtn.Glyph.LoadFromFile(AppDir+'\'+'SwitchOn.BMP');
   CalcAll(RetNo);
   StatusBarSw := True;
   //MyChild.MonitorFrame.Visible:=True;
  end
  else
  begin
   StatusBarBtn.Glyph.LoadFromFile(AppDir+'\'+'SwitchOf.BMP');
   StatusBarSw := false;
   //MonitorFrame.Visible:=False;
   //StatusBar.Visible := False;
  end;
 *)
end;

procedure TMainForm.ToolBarBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  ToolBarSw := not ToolBarSw;
  If ToolBarSw then
   begin
    ToolBarBtn.Glyph.LoadFromFile(AppDir+'\'+'SwitchOn.BMP');
    ToolBarSw := True;
    CalcAll(RetNo);
    UpdateAllDataIndicators(RetNo);
    MyChild.UpdateChildTaxPanel(RetNo);
   end
  else
   begin
   ToolBarBtn.Glyph.LoadFromFile(AppDir+'\'+'SwitchOf.BMP');
   ToolBarSw := false;
   //ToolBar.Height :=(ToolBar.Height div 2)+3+5; //(ToolBar.Height div 2)+3+1;
   end;

end;


(*
procedure TMainForm.ImportBtnClick(Sender: TObject);
var CurHandle : Thandle;
begin
  If OptRec.RolloverProgram='' then
  begin
   ShowMessage('Please enter Last year'+Chr(39)+'s program name in'
   +Chr(13)+'Configure | General Options | Data Directories');
   Exit;
  end;
  SelectedString:=OptRec.RolloverProgram;
  If LeftStr(SelectedString,6) = 'Visual' then ImportLastYearClick(Sender)
  else If LeftStr(SelectedString,7) = 'Profile' then
     RollForwardfromgreenPoint1Click(Sender)
  else If LeftStr(SelectedString,6) = 'CanTax' then
     RollForwardfromCanTaxT120011Click(Sender)
end;
*)
(*
procedure TMainForm.TileBtnClick(Sender: TObject);
begin
//WindowTileItemClick(Sender);
end;

procedure TMainForm.CascadeBtnClick(Sender: TObject);
begin
//WindowCascadeItemClick(Sender);
end;


procedure TMainForm.MiniBtnClick(Sender: TObject);
begin
MinimizeAllClick(Sender);
end;

procedure TMainForm.RestoreBtnClick(Sender: TObject);
begin
RestoreAllClick(Sender);
end;
*)
procedure TMainForm.AboutItemClick(Sender: TObject);
begin
Application.CreateForm(TAbout,About);
About.ShowModal;
About.Free;
end;

procedure TMainForm.CloseBtnClick(Sender: TObject);
begin
  FileCloseItemClick(Sender);
end;

procedure TMainForm.MemGaugeClick(Sender: TObject);
begin
ShowMem;
end;
(*
procedure TMainForm.StatusBarBtnClick(Sender: TObject);
begin
 StatusBarSw := not StatusBarSw;
  If StatusBarSw then begin StatusBarBtn.Glyph.LoadFromFile('SwitchOn.BMP');
                    StatusBarSw := True; StatusBar.Visible := true;end
  else begin StatusBarBtn.Glyph.LoadFromFile('SwitchOf.BMP');
             StatusBarSw := false; StatusBar.Visible := false;end;

end;
*)




(*
procedure TMainForm.SpeedButton5Click(Sender: TObject);
begin
OpenForm(GetFormNo(SpeedButton5.Caption));
end;
*)
(*
procedure TMainForm.FormsBarBtnClick(Sender: TObject);
begin
  FormsBarSw := not FormsBarSw;
  If FormsBarSw then begin FormsBarBtn.Glyph.LoadFromFile('SwitchOn.BMP');
                   { FormsBarSw := True; FormsBar.Visible := true;end}
                      FrmTool.Show;
                      FrmTool.Visible := True;
                      end
  else begin FormsBarBtn.Glyph.LoadFromFile('SwitchOf.BMP');
              FrmTool.Visible := False;
              end;

end;
*)
procedure TMainForm.StatusBarClick(Sender: TObject);
begin
 {UpdateTaxPanel;}
end;

(*
procedure TMainForm.PreparerClick(Sender: TObject);
begin
 If LeftStr(LicenseLevel,8) = 'T1 Multi' then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;
 Application.CreateForm(TPrpOpt,PrpOpt);
 PrpOpt.ShowModal;
 PrpOpt.Free;
end;
*)

procedure TMainForm.ClrCustomClick(Sender: TObject);
begin
 Clr0Click(Sender);
end;

procedure TMainForm.clr0Click(Sender: TObject);
var
Clr : Tcolor;
FormNoBk,FieldIdBk,TabNoBk : integer;
{FormHandleBk : word;}
CurHandle : Thandle;
begin
 If ButtonInactive then exit;
 if RetInMem >0 then CurHandle := FormHandle;
 FieldIdBk := FieldId;
 {FormHandleBk := FormHandle; FormNoBk:=FormNo;FieldIdBk := FieldId;}
 {TabNoBk := TabNo;}
 If Sender = Clr0 then clr := (Sender as TPanel).Color
 Else If Sender = Clr1 then clr := (Sender as TPanel).Color
 Else If Sender = Clr2 then clr := (Sender as TPanel).Color
 Else If Sender = Clr3 then clr := (Sender as TPanel).Color
 Else If Sender = Clr4 then clr := (Sender as TPanel).Color
 Else If Sender = Clr5 then clr := (Sender as TPanel).Color
 Else If Sender = Clr6 then clr := (Sender as TPanel).Color
 Else If Sender = Clr7 then clr := (Sender as TPanel).Color
 Else If Sender = Clr8 then clr := (Sender as TPanel).Color
 Else If Sender = Clr9 then clr := (Sender as TPanel).Color
 Else If Sender = Clr10 then clr := (Sender as TPanel).Color
 Else If Sender = Clr11 then clr := (Sender as TPanel).Color
 Else If Sender = ClrCustom then
      if ColorDialog1.Execute then
         IF CLR <> clBlack then Clr := ColorDialog1.Color;

 If RetInMem <1 then Exit;

 If IsColorInUse(Clr) then
  ShowTimedMsg('Color already in use',1000)
 else
 begin
  FreeUpColor(GetRetColor(GetCurrentRetNo));
  If RecolorReturn(GetCurrentRetNo,clr) = false then
   begin ShowMessage('Return Not found');exit;end;
  SetColorInUse(Clr);
  If WizardPanel.Visible then RefreshAuditPanel(GetCurrentRetNo);

  MyChild:=MainForm.ActiveMdiChild as TMyChild;
  MyChild.Color:=clr;
  (GetFormHeaderFrame(MyChild)).Color:=clr;
  (GetScrollbox(MyChild,FormName)).Color:=clr;
  //(GetPageControl(MyChild) as TPageControl).Canvas.brush.Color:=clr; //does nothing
  (GetMonitorFrame(MyChild)).Color:=clr;
 end;
end;

Procedure TmainForm.InitColorPanel;
begin
  ColorRec := ColorList.Items[0]; Clr0.Color := ColorRec^.ColorRef;
  ColorRec := ColorList.Items[1]; Clr1.Color := ColorRec^.ColorRef;
  ColorRec := ColorList.Items[2]; Clr2.Color := ColorRec^.ColorRef;
  ColorRec := ColorList.Items[3]; Clr3.Color := ColorRec^.ColorRef;
  ColorRec := ColorList.Items[4]; Clr4.Color := ColorRec^.ColorRef;
  ColorRec := ColorList.Items[5]; Clr5.Color := ColorRec^.ColorRef;
  ColorRec := ColorList.Items[6]; Clr6.Color := ColorRec^.ColorRef;
  ColorRec := ColorList.Items[7]; Clr7.Color := ColorRec^.ColorRef;
  ColorRec := ColorList.Items[8]; Clr8.Color := ColorRec^.ColorRef;
  ColorRec := ColorList.Items[9]; Clr9.Color := ColorRec^.ColorRef;
  ColorRec := ColorList.Items[10]; Clr10.Color := ColorRec^.ColorRef;
  ColorRec := ColorList.Items[11]; Clr11.Color := ColorRec^.ColorRef;

end;

procedure TMainForm.clr1Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainForm.clr2Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainForm.clr3Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainForm.clr4Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainForm.clr5Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainForm.clr6Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainForm.clr7Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainForm.clr8Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainForm.clr9Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainForm.clr10Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainForm.clr11Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainForm.OpenbyFileName1Click(Sender: TObject);
var result : integer;FullFlName:String;s:String;FlName,Sin:String;
begin
 OpenDialog.InitialDir:= OptRec.Dir_Cur;
 If OpenDialog.Execute then
 begin
   FullFlName :=OpenDialog.FileName;
   FlName:=ExtractFileName(FullFlName);
   Sin:=RemoveChar(FlName,'.');
   If IsOkToOpenReturn(ExtractFileDir(FullFlName),FlName,Sin) = False then Exit;
   RetNo:=InitNewReturn;
   If RetNo=0 then exit;
   result := OpenReturn(RetNo,ExtractFileDir(FullFlName),FlName,True);
   If result = 0 then
   begin
    LockWindowUpdate(MainForm.Handle);
    CountDiagnostics(RetNo);
    MainForm.LeftPanel.Visible:=True;
    FormName := 'T3';
    FormNo := GetFormNo(FormName);
    OpenForm(RetNo,FormNo,0);
    LockWindowUpdate(MainForm.Handle);  //20130217
    OpenUsedForms(RetNo);
    MainForm.FormPaint(Application);
    LockWindowUpdate(0);  //20130217
   end
   else
   begin
    ShowOpenReturnFailure(Result,ExtractFileDir(FullFlName),
       ExtractFileName(FullFlName));
    exit;
   end;
   RefreshAuditPanel(RetNo); //If AuditPanel.Visible then RefreshAuditPanel;
   //If FormsPanel.Visible then RefreshFormsPanel(RetNo);
 end;
end;

procedure TMainForm.Calendar1Click(Sender: TObject);
begin
GetCalendar;
end;

(*
procedure TMainForm.ViewFileClick(Sender: TObject);
var
h : Thandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'NotePad.Exe', Nil,
  '', SW_RESTORE);

end;
*)
procedure TMainForm.ClientLetter1Click(Sender: TObject);
begin
{Screen.Cursor := crHourGlass;}

 Application.CreateForm(TRichForm,RichForm);
 RichForm.ShowModal;
 RichForm.Free;
end;

procedure TMainForm.PrintForm1Click(Sender: TObject);
Var i:integer;RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 FastPrint := False;
 If ButtonInactive then exit;
 If AllowPrinting(RetNo)=False then exit;
 ErrorCount := CountDiagnostics(RetNo);
 If MandatoryErrorCount+SeriousErrorCount>0 then
 begin
  If not WizardPanel.visible then AuditOpenBtnClick(Application);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Not AllowedToFormPrint(RetNo,FormName) then exit;
 //LetterType := 'Cover';
(*{
 If CertificationMode=True then  //20120318
 begin
   StoreElm(RetNo,GetFormNo('PS10'),5,'7');
  end;
 *)
 If PrintDialogItem.Execute then StartPrintForm(Retno,FormName,99);
end;

procedure TMainForm.StartPrintForm(Retno:integer;FormName:String;WhichPage:integer);
begin
   Progress.Show;  {Show progress window}
   AbortSw := False;  {Initialize}
   PauseSw := False;
   Progress.Caption := 'Print progress...';
   Progress.Label1.Caption := 'Printing Return:';
   Progress.Label2.Caption := GetRetName(RetNo);
   Progress.ListBox1.Visible := false;
   Progress.Gauge1.Visible := false;
  { Progress.BiGauge1.Visible := false;}
   Application.ProcessMessages;  {allows abort click on progrees screen }
   If AbortSw then
    begin
       Progress.Close;
       If Printer.Printing then
         begin Printer.Abort; Printer.EndDoc;exit;end;
       if MessageDlg('Printing interrupted by operator'+
          Chr(13)+'Review pending Print Manager jobs?',
          mtInformation, [mbYes, mbNo], 0) = mrYes then
          PrintManager1Click(Application);
       exit;
    end;
    Progress.Label3.Caption := 'Form Name:';
    Progress.Label4.Caption := FormName;
    Progress.Label5.Caption := '';
    Progress.Label6.Caption := '';
    Progress.Refresh;
    If not IsFormMultipage(FormName) then
    Begin
     If CertificationMode = False then Calc(RetNo,FormName) //20120318
    end
    else
    Begin
     If CertificationMode = False then CalcMultiPageForm(RetNo,FormName);
    end;

    PrintForm(RetNo,FormName,WhichPage,'');

 Progress.Close;
end;

(*
procedure TMainForm.BatchPrinting1Click(Sender: TObject);
Var W : THandle;
I : longInt;
begin
 If RetInMem>0 then
  begin ShowMessage('Please close all returns first'); exit;end;
 Screen.Cursor := crHourglass;
 BatchOper:='Print';
 BatchFilter := 'Ready To Print';
 Application.CreateForm(TClients,Clients);
 Clients.ShowModal;
 Clients.Free;
end;

procedure TMainForm.CopyReturns1Click(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  BatchOper := 'Copy'; BatchFilter := 'All Clients';
  Application.CreateForm(TClients,Clients);
  Clients.ShowModal;
  Clients.Free;
end;

procedure TMainForm.MoveReturns1Click(Sender: TObject);
begin
 Screen.Cursor := crHourglass;
 BatchOper := 'Move'; BatchFilter := 'All Clients';
 Application.CreateForm(TClients,Clients);
 Clients.Show;
 Clients.Free;
end;

procedure TMainForm.DeleteReturns1Click(Sender: TObject);
begin
 Screen.Cursor := crHourglass;
 BatchOper := 'Delete'; BatchFilter := 'All Clients';
 Application.CreateForm(TClients,Clients);
 Clients.ShowModal;
 Clients.Free;
end;
*)
procedure TMainForm.PrintFBtnClick(Sender: TObject);
begin
PrintForm1Click(Sender);
{If RetNo>0 then PrintForm(RetNo,FormName);}
end;



procedure TMainForm.Modem1Click(Sender: TObject);
begin
 (*
 Application.CreateForm(TCommFrm, CommFrm);
 CommFrm.ShowModal;
 CommFrm.Free;
 *)
end;

procedure TMainForm.CreateDataDirectory1Click(Sender: TObject);
var s:sTring; //DataDir : string[60];Result : integer;ClickedOK: Boolean;
begin
 s:=CreateNewDataDir;
 If s>'' then
 begin
  SaveSingleOption('Dir_Cur',s);
  InitOptions;
 end;
(*
  DataDir := Appdir+'\Data';
  DataDir := InputBox('Create Data Directory','Enter Full path', DataDir);
      Result := CreateDataDirectory(AppDir,DataDir);
      Case Result of
        0 : ShowMessage('Directory successfully created');
        -1: ShowMessage('Directory already exists!');
        -2: ShowMessage('Directory already contains a client data base');
        -3: ShowMessage('Directory cannot be created');
        -4: ShowMessage('Cannot initialize the Data Base');
      end;
 *)
end;



procedure TMainForm.PrintTemplates1Click(Sender: TObject);
begin
Application.CreateForm(TPrSet,PrSet);
PrSet.ShowModal;
PrSet.Free;

end;

procedure TMainForm.FeeSchedule1Click(Sender: TObject);
begin
// If RetInMem>0 then  begin ShowMessage('Close all returns first');exit;end;
 Application.CreateForm(TFees,Fees);
 Fees.ShowModal;
 Fees.Free;
end;

(*
procedure TMainForm.OpenSpecificTypes1Click(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  BatchOper := 'Open'; BatchFilter := 'All';
  Application.CreateForm(TClients,Clients);
  Clients.ShowModal;
  Clients.Free;
end;
*)
procedure TMainForm.Fonts1Click(Sender: TObject);
var
TempFont : TFont;
begin
  (*
  FontDialog1.Font.Name := DefFontName;
  FontDialog1.Font.Size := 8;
  if FontDialog1.Execute then
   begin
   { TempFont.Assign(FontDialog1.Font);}
    {DefFontName.Assign(TempFont.Name);}
    {
    MainForm.Font.Assign(FontDialog1.Font);
    ShowMessage(MainForm.Font.Name);
    }

   end;
   *)
end;




procedure TMainForm.RemovecurrentreturnOverridesClick(Sender: TObject);
Var I,FNo:integer;RetNo:Integer;
begin
  RetNo:=GetCurrentRetNo;
  If RetNo >0 then {RemoveRetOverrides(RetNo);}
  begin
   If OverList.Count =0 then exit;
   i :=0;
   Repeat
     OverRec := OverList.Items[i];
     if OverRec^.RetNo = RetNo then
       begin
       FNo := OverRec^.FormNo;
       OverList.Remove(OverRec);
       Calc(RetNo,GetFormName(FNo));
       //CalcAll(RetNo);
       end
     else
      inc(i);
   until i > OverList.Count - 1;
   OverList.Pack;
  end;
  //ChildWin.MyChild.FormPaint(Sender);
end;

procedure TMainForm.RemovecurrentfieldoverrideClick(Sender: TObject);
Var REtNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 If (RetNo >0) and (FormNo >0) and (FieldId >0) then
  begin
   RemoveFieldOverride(RetNo,FormNo,FieldId);
   Calc(RetNo,FormName);
   CalcAll(RetNo);
  end;

end;

(*
procedure TMainForm.SetCurrentFieldOverrideClick(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 If (RetNo >0) and (FormNo >0) and (FieldId >0) then
    If IsAProtectedField(FormNo,FieldId) then
     SetFieldOverride(RetNo,FormNo,FieldId)
    else
     ShowMessage('You can only Override or Lock '+
     chr(13)+'Calculated and Linked fields');
end;
*)
procedure TMainForm.Lockamountoncurrentfield1Click(Sender: TObject);
Var RetNo:Integer;
begin
RetNo:=GetCurrentRetNo;
If (RetNo >0) and (FormNo >0) and (FieldId >0) then
   SetFieldOverride(RetNo,FormNo,FieldId);
end;



procedure TMainForm.CouplBtnClick(Sender: TObject);
begin
//SetCurrentFieldOverrideClick(Sender);
end;

procedure TMainForm.OverrideBtnClick(Sender: TObject);
begin

{ShowOverridesClick(Sender);}
{SetCurrentFieldOverrideClick(Sender);}
end;

procedure TMainForm.DataDictionary1Click(Sender: TObject);
begin
 {
 Application.CreateForm(TDataDictFrm,DataDictFrm);
 DataDictFrm.ShowModal;
 DataDictFrm.Free;
 }

 FixDbName := 'DataDict.dbf';
 Application.CreateForm(TFixDBForm,FixDBForm);
 FixDbForm.ShowModal;
 FixDbForm.Free;

end;







procedure TMainForm.DiagnosticsClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 AuditOpenBtnClick(Sender);
 {If not AuditPanel.Visible then AuditBtnClick(Sender);}
end;

(*
procedure TMainForm.Panel3Click(Sender: TObject);
begin
iFSysRes.caption :=inttostr(GetFreeSystemResources(GFSR_GDIRESOURCES)) + '%';
iFgdiRes.caption :=inttostr(GetFreeSystemResources(GFSR_GDIRESOURCES)) + '%';
iFUserRes.caption :=inttostr(GetFreeSystemResources(GFSR_USERRESOURCES)) + '%';
iTotFreeMem.caption :=inttostr((GetFreeSpace( WF_ENHANCED) div 100)) + ' kb ';
end;
*)
procedure TMainForm.SamplesBtnClick(Sender: TObject);
begin
OptRec.Dir_Cur := OptRec.Dir_Sample;
FileOpenItemClick(Sender);
end;



Procedure TMainForm.FullPrint(RetNo:Integer;Template:String);
Var i,j: integer; FormsToPrint :TstringList;
    Copies : string[1];
begin
end;


procedure TMainForm.PrintReturn(RetNo:integer;FormsToPrint:TstringList;
 DataDir:string;FlName:string);
var i,j,FCopies:integer; FName :string[10];
begin
   Screen.Cursor := crHourGlass;
   Progress.Show;  {Show progress window}
   AbortSw := False;  {Initialize}
   PauseSw := False;
   Progress.Caption := 'Print progress...';
   Progress.Label1.Caption := 'Printing Return:'+IntToStr(RetNo);
   Progress.Label2.Caption := GetRetName(RetNo);
   Progress.Gauge1.MinValue := 0;
   Progress.Gauge1.MaxValue := FormsToPrint.Count;
   Progress.Gauge1.Progress :=0;
   Progress.ListBox1.Visible := True;
   Progress.Gauge1.Visible := True;
   Progress.ListBox1.Clear;
   Progress.ListBox1.Clear;
   For j :=0 to FormsToPrint.Count-1 do  {show list to be done}
     begin
      //Progress.ListBox1.Items.Add(AllTrim(Midstr(FormsToPrint[j],2,10)));
      Progress.ListBox1.Items.Add(Midstr(FormsToPrint[j],5,10));
     end;

   If FastPrint = True then Printer.BeginDoc;
   for i :=0 to (FormsToPrint.Count - 1) do
   begin
      Application.ProcessMessages;  {allows abort click on progrees screen }
      If AbortSw then
      begin
       Progress.Close;

       If Printer.Printing then
       begin
         Printer.Abort;
         Printer.EndDoc;
       end;

       if MessageDlg('Printing interrupted by operator'+
          Chr(13)+'Review pending Print Manager jobs?',
          mtInformation, [mbYes, mbNo], 0) = mrYes then
          PrintManager1Click(Application);
       exit;
      end;
      FName := Midstr(FormsToPrint[i],5,10);
      FCopies := MyStrToInt(Midstr(FormsToPrint[i],4,1));
      Progress.Label3.Caption := 'Form Name:';
      Progress.Label4.Caption := FName;
      Progress.Label5.Caption := '';
      Progress.Label6.Caption := '';
      Progress.ListBox1.ItemIndex :=i;  {movable focus on list}
      Progress.Refresh;

      Calc(RetNo,FName);
      For j:=1 to FCopies do
       begin
        PrintForm(RetNo,FName,99,'');  //99 to print all pages of form 20130218
       end;
      Progress.Gauge1.Progress :=i+1;
      Progress.Gauge1.Refresh;
   end;
   If FastPrint = True then Printer.EndDoc;
   Progress.Close;
   Ret[RetNo]^.Frm[GetFormNo('STATUS')].Strings[4] := '03';
   Ret[RetNo]^.PrpStatus :='03';
   UpdatePrintDate(RetNo,DataDir,FlName);
   Screen.Cursor := crDefault;
end;

Procedure TMainForm.UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
var FNo :integer; TempList :TStringList; Table1:TTable;
begin
 FNo := GetFormNo('STATUS');
 Ret[RetNo]^.Frm[Fno].Strings[4] := '03';
 Ret[RetNo]^.Frm[Fno].Strings[8] := UserName;
 Ret[RetNo]^.Frm[Fno].Strings[9] := FormatDateTime('yyyy-mm-dd',Date);
 Ret[RetNo]^.Frm[Fno].Strings[10] := TimeToStr(Time);

 If FileExists(DataDir+'\'+FlName) then
 begin
  TempList := TstringList.Create;
  Templist.LoadFromFile(DataDir+'\'+FlName);
  Templist.Add( 'F'+Delimiter+'STATUS'+Delimiter+Delimiter);
  TempList.Add('D'+Delimiter+'4'+Delimiter+'03'+Delimiter);
  TempList.Add('D'+Delimiter+'8'+Delimiter+UserName+Delimiter);
  TempList.Add('D'+Delimiter+'9'+Delimiter+FormatDateTime('yyyy-mm-dd',Now)+Delimiter);
  TempList.Add('D'+Delimiter+'10'+Delimiter+TimeToStr(Time)+Delimiter);
  Templist.SaveToFile(DataDir+'\'+FlName);
  TempList.Free;
 end;

 {now update the data base with RTU dates}
 Table1              := TTable.Create(Application);
 Table1.DataBaseName := DataDir;
 Table1.TableName    := ClientsTable;
 Table1.IndexName    := 'File_Name';
 if Table1.State = dsInactive then Table1.Active := True;

 Table1.DataBaseName := DataDir;
 Table1.TableName    := ClientsTable;
 Table1.IndexName    := 'File_Name';
 if Table1.State = dsInactive then Table1.Active := True;
 if Table1.FindKey([FlName]) then
 begin
  Table1.Edit;
  Table1.FieldByName('Prp_Status').AsString := FetchElm(RetNo,'STATUS',4);
  Table1.FieldByName('Printed_by').AsString := FetchElm(RetNo,'STATUS',8);
  Table1.FieldByName('Printed_dt').AsString := FetchElm(RetNo,'STATUS',9);
  Table1.FieldByName('Printed_tm').AsString := FetchElm(RetNo,'STATUS',10);
  Table1.Post;
 end;
 Table1.Free;
end;

procedure TMainForm.Line1Click(Sender: TObject);
var
  s: string[4];
  Table1 :TTable;
begin
end;

procedure TMainForm.JacketClick(Sender: TObject);
begin
If ButtonInactive then exit;
OpenForm(GetCurrentRetNo,GetFormNo('T3'),0);
end;

procedure TMainForm.PersonaldataClick(Sender: TObject);
begin
If ButtonInactive then exit;
OpenForm(GetCurrentRetNo,GetFormNo('T3'),0);
end;

procedure TMainForm.FixDataDictionary1Click(Sender: TObject);
begin
FixDbName := 'DataDict.dbf';
Application.CreateForm(TFixDBForm,FixDBForm);
FixDbForm.ShowModal;
FixDbForm.Free;
end;

procedure TMainForm.FixFormSpecifications1Click(Sender: TObject);
begin

FixDbName := 'TFSCR.dbf';
Application.CreateForm(TFixDBForm,FixDBForm);
FixDbForm.ShowModal;
FixDbForm.Free;

end;

procedure TMainForm.FixClientDataBaseData1Click(Sender: TObject);
begin
 FixDbName := 'Clients.DBF';
 Application.CreateForm(TFixDBForm,FixDBForm);
 FixDbForm.ShowModal;
 FixDbForm.Free;

end;

procedure TMainForm.ShowCellNumbers1Click(Sender: TObject);
begin
 ShowCellNumbers1.Checked := not ShowCellNumbers1.Checked;
 ShowFieldIdSw := ShowCellNumbers1.Checked;
 If RetInMem >0 then
  MyChild.ShowFormData(MyChild,GetCurrentRetNo,FormName,FormNo);
end;

(*
procedure TMainForm.DataDirectories1Click(Sender: TObject);
begin
Application.CreateForm(TDirOpt,DirOpt);
DirOpt.ShowModal;
DirOpt.Free;
end;
*)

procedure TMainForm.ChangeDataDirectory1Click(Sender: TObject);
begin

 Application.CreateForm(TOptionsFrm,OptionsFrm);
 OptionsFrm.ShowModal;
 OptionsFrm.Free;
//DataDirectories1Click(Sender);
end;

procedure TMainForm.ClientListing1Click(Sender: TObject);
begin
(*
 Application.CreateForm(TReports,Reports);
 Reports.ShowModal;
 Reports.Free;
 *)
 (* Report Smith
 Report1.ReportName := 'Clients1';
 Report1.ReportDir := AppDir;
 Report1.Preview := True;
 Report1.Run;
 *)

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 //If ServerMode=True then Application.Terminate;
 Action :=caNone;
 FileExitItemClick(Application);
end;



procedure TMainForm.LoadSpousalReturnfromdatabaseCreate1Click(Sender: TObject);
begin
If ButtonInactive then exit;
end;



procedure TMainForm.SwapReturns1Click(Sender: TObject);
Var RetNo,PrevRNo,PrevFNo :integer;
begin
  RetNo:=GetCurrentRetNo;
  If RetInMem <2 then
  begin
   ShowMessage('To swap, you must have 2 or more returns in memory');
   exit;
  end;
  PrevRNo := RetNo;
  PrevFNo:= FormNo;

  If RetInMem <4 then
   RetNo:=GetNextReturn(RetNo)
  else
   RetNo := SelectFromLoadedReturns(RetNo);
  LockWindowUpdate(MainForm.Handle);
  If Ret[Retno]^.CalcStatus = false then CalcAll(retNo);
  OpenForm(RetNo, PrevFNo,0);
  If LeftPanel.Visible then RefreshAuditPanel(RetNo);
  LockWindowUpdate(0);
end;

procedure TMainForm.Switchforms1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 If (PrevRetNo>0) and (PrevFormNo>0) then OpenForm(PrevRetNo,PrevFormNo,0);
end;

procedure TMainForm.SwapFrmClick(Sender: TObject);
begin
 Switchforms1Click(Sender);
end;

procedure TMainForm.FormsBtnClick(Sender: TObject);
begin
 //LetterType := 'Cover';
 SelectFormClick(Sender);
end;

procedure TMainForm.UserSetUp1Click(Sender: TObject);
begin
Application.CreateForm(TUserSetup,UserSetUp);
UserSetUp.ShowModal;
UserSetUp.Free;
end;

(*
procedure TMainForm.CashReports1Click(Sender: TObject);
begin
{If Not FeatureAllowed then exit;}
Application.CreateForm(TCashrep,CashRep);
CashRep.ShowModal;
CashRep.Free;
end;
*)
procedure TMainForm.TipsBtnClick(Sender: TObject);
begin
 QuickStarterGuide1Click(Sender);
end;

(*
procedure TMainForm.Tips1Click(Sender: TObject);
begin
Application.CreateForm(TTip,Tip);
Tip.ShowModal;
Tip.Free;
end;
*)


procedure TMainForm.CopyForm1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 If RetInMem<2 then
 begin
  ShowMessage('Form Copy allowed only between different returns in memory');
  exit;
 end;
 Application.CreateForm(TCopyFrm,CopyFrm);
 CopyFrm.ShowModal;
 CopyFrm.Free;
end;

procedure TMainForm.CopyBtnClick(Sender: TObject);
begin
CopyForm1Click(Sender);
end;

procedure TMainForm.SchedBtnClick(Sender: TObject);
Var I:integer;
begin
  If RetNo < 1 then exit;
  SomeList := TStringList.Create;
  SomeCaption := 'Schedules';
  for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];
      If Frec^.FormType = 'SC' then
      SomeList.Add(Frec^.FormName+Frec^.FormInst);
   end;
  Application.CreateForm(TPoplist,PopList);
  PopList.ShowModal;
  SomeList.Free; PopList.Release;
  If SelectedString = '' then exit;

end;


procedure TMainForm.FrmSumBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 OpenForm(GetCurrentRetNo,GetFormNo('BSUM'),0);
 
end;



Procedure TMainForm.ShowMultiOfficeMsg;
begin
 ShowMessage('This option is available only to firms'+Chr(13)+
   'with Multi-operator and/or Multi-office operations');
end;

procedure TMainForm.UserSetUp2Click(Sender: TObject);
begin
 Application.CreateForm(TMPswd,MPswd);
 MPswd.ShowModal;
 MPswd.Free;

 If UpperCase(GetAdminPswrd('ADMIN')) <> UpperCase(MasterPswd) then
  begin
   ShowMessage('Only the Administrator can perform this function');
   exit;
  end;
 Application.CreateForm(TUserSetup,UserSetUp);
 UserSetUp.ShowModal;
 UserSetUp.Free;
end;

procedure TMainForm.HelpBtnClick(Sender: TObject);
Var HlpContextString :string;
begin
  ShowHelp('TfHelp','HELP_CONTENTS');
end;

procedure TMainForm.Calculator1Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'Calc.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainForm.Appointments2Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'Calendar.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainForm.TransmitRTU1Click(Sender: TObject);
begin
{
Application.CreateForm(TPhone, Phone);
Phone.ShowModal;
Phone.Free;
}
end;

procedure TMainForm.Contents2Click(Sender: TObject);
begin
  ShowHelp('TfHelp','HELP_CONTENTS');
end;

procedure TMainForm.SearchForHelpOnClick(Sender: TObject);
begin
 ShowHelp('TfHelp','HELP_CONTENTS');
end;

procedure TMainForm.VisualTaxGuide1Click(Sender: TObject);
begin
 ShowHelp('TfHelp','HELP_CONTENTS');
end;

procedure TMainForm.Allforms1Click(Sender: TObject);
Var I:integer;
begin
 If ButtonInactive then exit;
 ShowFieldIdSw := True;
 If PrintDialogItem.Execute then
 begin
   for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      If Frec^.FormNo > 114 then
      begin
      If FRec^.FormInst < '#2' then
         PrintForm(GetCurrentRetNo,Frec^.FormName+Frec^.FormInst,99,'');
      end;
    end;
 end;
end;


(*
procedure TMainForm.SectionBtnClick(Sender: TObject);
Var I,J,MxPg,k,FNo:Integer; FName,FNonInst,FRootName,FInst:string[10];
TopList: TStringList; {Top of each label}
begin
 {
 SomeList := TStringList.Create;
 TopList := TStringList.Create;
 SomeCaption := 'Form Sections';
 If IsFormMultipage(FormName) then
 begin
    FRootName := ExtractFormRootName(FormName);
    MxPg := GetFormMxPg(FormName);
    For i:=1 to MxPg do
    begin
     FName := FRootName + '_' + IntToStr(i);
     If IsFormMultiInst(FormName) then FName := FName +'#1';
     GetFormSections(FName,SomeList,TopList);
    end;
  end
  else
   GetFormSections(GetNextFormPage(FormName),SomeList,TopList);

 Application.CreateForm(TOutLnlist,OutLnList);
 OutLnList.ShowModal;
 If AllTrim(SelectedString) = '' then
  begin TopList.Free;SomeList.Free;exit;end;

 For i:=0 to SomeList.Count-1 do  //find string again
 begin
   If TopList[i] = '' then FName :=SomeList[i]; //Form before finding section
   If SelectedString = Ltrim(SomeList[i]) then
     begin
      OpenForm(RetNo,GetFormNo(FName));
      If Numeric(TopList[i]) then
        begin
        GotoLabel(StrToInt(TopList[i]),MyChild);
        TopList.Free;  SomeList.Free;
        exit;
        end
     end;
 end;
 TopList.Free;  SomeList.Free;
}
end;
*)
(*
procedure TMainForm.ShowFormSections(FName:String);
Var I,J:Integer;
TopList: TStringList; {Top of each label}
begin
  SomeList := TStringList.Create;
  TopList := TStringList.Create;
  SomeCaption := 'Form Sections';
  j := 1;
  {scan all labels}
  FormPtr := GetFormPtr(FName);
  TextPtr := GetTextPtr(FName);
  {Add form name header}
  SomeList.Add(FName);
  TopList.Add('');
  for i :=1 to NumbLabels do
   begin
     LabelRec := Addr(HeaderRec^.Bucket[j]);
     If LabelRec^.SectionId >0 then
       begin
         SomeList.Add(' '+AllTrim(StrPas(TextPtr)));
         TopList.Add(IntToStr(LabelRec^.Top));
       end;
     inc(j,LabelProperties);     {increment bucket by size of label rec}
     inc(TextPtr,StrLen(TextPtr)+1);  {increment text pointer}
   end;
  Application.CreateForm(TOutLnlist,OutLnList);
  {OutLnList.Width := 400;}
  OutLnList.ShowModal;

  If AllTrim(SelectedString) > '' then
  begin
    For i:=0 to SomeList.Count-1 do  {find string again}
     begin
      If SelectedString  = AllTrim(Somelist[i]) then
        begin
          MyChild.ScrollBar1.Position := StrToInt(TopList[i]);
          MyChild.ScrollBar2.Position := 0;
        end;
     end;
  end;
  TopList.Free;
  SomeList.Free;
end;
*)
procedure TMainForm.EFileerrorsCurrentReturn1Click(Sender: TObject);
begin
If ButtonInactive then exit;
OpenForm(GetCurrentRetNo,GetFormNo('STATUS'),0);
(*
Application.CreateForm(TEFMErrors,EFMErrors);
EFMErrors.ShowModal;
EFMErrors.Free;
*)
end;

procedure TMainForm.MultipleDnBtnClick(Sender: TObject);
Var CInst : integer;
begin
 OpenPrevInstance(FormName);
end;

procedure TMainForm.MultipleUpBtnClick(Sender: TObject);
Var CInst : integer;
NewFormName : String[10];
begin
  OpenNextInstance(FormName);
end;

procedure TMainForm.Restructure1Click(Sender: TObject);
begin
(*
Application.CreateForm(TRestruct,Restruct);
Restruct.ShowModal;
Restruct.Free;
*)
end;

procedure TMainForm.DependBtnClick(Sender: TObject);
begin
If ButtonInactive then exit;
OpenForm(GetCurrentRetNo,GetFormNo('DEPEND'),0);
end;

procedure TMainForm.ReviewBtnClick(Sender: TObject);
Var RetNo:Integer;MyEditBox:TvtEdit;
ElmsInError:TStringList;
MyScrollBox:TvtScrollBox;MyImage:TImage;
begin
 If ButtonInactive then exit;
 RetNo:=GetCurrentRetNo;
 If MyChild.ActiveControl <> Nil then
 begin
  If MyChild.ActiveControl is TvtEdit then
  begin
   MyEditBox:=MyChild.ActiveControl as TvtEdit;
   FieldId :=GetFieldId(MyEditBox.Name);
   If ReviewOn(RetNo,FormNo,FieldId) then
   begin
     RemoveReviewMark(RetNo,FormNo,FieldId);
     MyEditBox.vtReviewOn:=False;
     MyChild.ShowFormData(MyChild,RetNo,FormName,FormNo);
   end
   else
   begin
     SetReviewMark(RetNo,FormNo,FieldId);
     MyEditBox.vtReviewOn:=True;
     MyChild.ShowFormData(MyChild,RetNo,FormName,FormNo);
   end;
   Ret[RetNo]^.Changed := True;
   RefreshAuditPanel(RetNo);
   //If FormsPanel.Visible then RefreshFormsPanel(RetNo);

   //paint;

  end;
 end;
end;

procedure TMainForm.ABCBtnClick(Sender: TObject);
begin
 AlphabeticalFormsIndex1Click(Sender);
end;

procedure TMainForm.PrintManager1Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'PrintMan.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainForm.ClientLetters1Click(Sender: TObject);
begin
  { Ucletter.PrintLetter(RetNo, Table2.Fields[0].DisplayText);}
end;

procedure TMainForm.TaxReturnCoveringletter1Click(Sender: TObject);
begin
(*
Application.CreateForm(TCustLtr,CustLtr);
CustLtr.ShowModal;
CustLtr.Free;
*)
end;




procedure TMainForm.ShowOverridesClick(Sender: TObject);
 Var I: integer;
begin
 If RetInMem < 1 then exit;
 SomeList := TStringList.Create;
 SomeCaption := 'Forms with Overrides';
 for i :=0 to (OverList.Count - 1) do
 begin
    OverRec := OverList.Items[i];
    SomeList.Add(GetFormName(OverRec^.FormNo));
 end;
 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 SomeList.Free; PopList.Release;
 If SelectedString > '' then
   OpenForm(GetCurrentRetNo,GetFormNo(SelectedString),0);
end;

procedure TMainForm.ListReviewmarks1Click(Sender: TObject);
Var I: integer;
begin
 If ButtonInactive then exit;
 {AuditOption.ItemIndex :=1;}
 {If not AuditPanel.Visible then AuditBtnClick(Sender);}

end;

procedure TMainForm.SystemInformation1Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'WINFO.Exe', Nil,
  Nil, SW_RESTORE);
 if h<=32 then ShowMessage('Info cannot be displayed. Code '+IntToStr(h));
end;

procedure TMainForm.RebuildtheClientDataBase1Click(Sender: TObject);
begin
 If RetInMem>0 then
  begin ShowMessage('Please close all returns first');exit;end;
 Application.CreateForm(TRebuild,Rebuild);
 Rebuild.ShowModal;
 Rebuild.Free;
end;

procedure TMainForm.MergeDataBases1Click(Sender: TObject);
begin
{ If Not FeatureAllowed then exit;}
 If RetInMem>0 then
  begin ShowMessage('Please close all returns first');exit;end;
 Application.CreateForm(TMerge,Merge);
 Merge.ShowModal;
 Merge.Free;
end;

procedure TMainForm.FileViewerEditor1Click(Sender: TObject);
begin
Application.CreateForm(TFileVu,FileVu);
FileVu.ShowModal;
FileVu.Free;
end;

procedure TMainForm.CurrentPage1Click(Sender: TObject);
var i,whichPage:integer;
begin
 FastPrint := False;
 If ButtonInactive then exit;
 If AllowPrinting(RetNo)=False then exit;

 SomeList := TStringList.Create;
 SomeCaption := 'Select Page to Print';

 for i:=1 to GetFormMxPg(FormName) do
 begin
  SomeList.Add(inttostr(i));
 end;

 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 //SomeList.Free;
 PopList.Release;

 If SelectedString > '' then
 begin
    whichPage := strToInt(LeftStr(SelectedString,1))
 end
 else
    exit;

 ErrorCount := CountDiagnostics(GetCurrentRetNo);
 If MandatoryErrorCount+SeriousErrorCount>0 then
 begin
  If not WizardPanel.visible then AuditOpenBtnClick(Sender);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;
 If Not AllowedToFormPrint(GetCurrentRetNo,FormName) then exit;
 //LetterType := 'Cover';

 If PrintDialogItem.Execute then
  StartPrintForm(GetCurrentRetno,FormName,whichPage);

end;







(*
procedure TMainForm.ViewLastYearClick(Sender: TObject);
begin
 ComparativeSummaryClick(Application);
end;
*)
procedure TMainForm.CplBtnClick(Sender: TObject);
begin
 //EndCoupling1Click(Sender);
 {UpdateMenuItems(Sender);}
end;

procedure TMainForm.MinTaxBtnClick(Sender: TObject);
begin
 //OpenForm(GetCurrentRetNo,GetFormNo('T691_1'),0);
end;

procedure TMainForm.ClientListings1Click(Sender: TObject);
begin
 (*
 Screen.Cursor := crHourGlass;
 try
 Application.CreateForm(TSelOpen,SelOpen);
 SelOpen.ShowModal;
 SelOpen.Free;
 finally
  Screen.Cursor := crDefault;
 end;
 *)
end;

procedure TMainForm.CopyBackUp1Click(Sender: TObject);
begin
 (*
 Screen.Cursor := crHourGlass;
 try
 BatchOper := 'Print'; BatchFilter := 'Ready To Print';
 Application.CreateForm(TSelOpen,SelOpen);
 SelOpen.ShowModal;
 SelOpen.Free;
 finally
  Screen.Cursor := crDefault;
 end;
*)
end;

procedure TMainForm.RecalcBtnClick(Sender: TObject);
Var FNo:integer;RetNo:Integer;
begin
 If ButtonInactive then exit;
 Screen.Cursor := crHourGlass;
 RetNo:=GetCurrentRetNo;
 CalcAll(RetNo);
 Screen.Cursor := crDefault;
 If FormNo>0 then MyChild.ShowFormData(MyChild,RetNo,FormName,FormNo);
 MyChild.UpdateChildTaxPanel(GetCurrentRetNo);
end;


procedure TMainForm.PreselNextBtnClick(Sender: TObject);
Var j,RetNo:Integer;MyPageControl:TPageControl;
begin

  If ButtonInactive then exit;
  MyChild:=MainForm.ActiveMdiChild as TMyChild;
  RetNo:=GetWinRetNo(MyChild.Handle);
  MyPageControl:=GetPageControl(MyChild);
  j:=MyPageControl.ActivePageIndex;
  If J<MyPageControl.PageCount-1 then
    OpenForm(RetNo,GetFormNo(MyPageControl.Pages[j+1].Caption),0);

end;

procedure TMainForm.PreSelPrvBtnClick(Sender: TObject);
Var j,RetNo:Integer;MyPageControl:TPageControl;
begin
  If ButtonInactive then exit;
  MyChild:=MainForm.ActiveMdiChild as TMyChild;
  RetNo:=GetWinRetNo(MyChild.Handle);
  MyPageControl:=GetPageControl(MyChild);
  j:=MyPageControl.ActivePageIndex;
  If J>0 then OpenForm(RetNo,GetFormNo(MyPageControl.Pages[j-1].Caption),0);

end;




procedure TMainForm.DeveloperOnly1Click(Sender: TObject);
Var K,Psw:string;
 PgmNames,ProductIds,PgmFactors:TstringList;
begin
(*
 Psw:= InputBox('Input Box', 'Enter PSW', '');
 If UpperCase(PSW) <> 'DODI1' then exit;

 PgmNames:=TstringList.Create;
 ProductIds:=TstringList.Create;
 PgmFactors:=TstringList.Create;
 LoadProducts(PgmNames,ProductIds,PgmFactors);
  K:=InputBox('Input Box', '', '');
 LicenseLevel:=GetProductName(LeftStr(K,4),PgmNames,ProductIds,PgmFactors);
 PgmNames.Free;
 ProductIds.Free;
 PgmFactors.Free;
 MainForm.FormPaint(Application);
 *)
end;

procedure TMainForm.ChangeLicenseLevel;
Var K,Psw:string;// PgmNames,ProductIds,PgmFactors:TstringList;
begin
 Psw:= InputBox('Input Box', '', '');
 If UpperCase(PSW) <> 'DODI1' then exit;
 LicenseLevel:=InputBox('Input Box', '', '');
 Licensee:='Some Multi-user';
 SelectFeatures;
 MainForm.FormPaint(Application);
End;


procedure TMainForm.NISAcodes1Click(Sender: TObject);
begin
 SomeList := TStringList.Create;
 //SomeList.Sorted := True;
 SomeCaption := 'CAIS CODES';
 {ListCaption;}
 SomeList.LoadFromFile(AppDir+'\'+'CAIS.D');
 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 SomeList.Free; PopList.Release;
(*
Application.CreateForm(TNISACd,NISACd);
NISACD.ShowModal;
NISACd.Free;
*)
end;

(*
procedure TMainForm.ONESTEPModemCommunications1Click(Sender: TObject);
begin
OneStepCom;
end;
*)


procedure TMainForm.OpenBtnClick(Sender: TObject);
begin
 FileOpenItemClick(Application);
end;

procedure TMainForm.YourLatestReleaseClick(Sender: TObject);
 Var h : THandle;
begin
 ShowHelp('TFUPDHLP','CONTENTS');
end;


procedure TMainForm.ZoomBtnPlusClick(Sender: TObject);
Var i,j,RNo,FNo:integer;Reply:String;
AChild:TMyChild;
APageControl:TPageControl;
begin
If ButtonInactive then exit;
If OptRec.FormZoom>200 then exit;
Screen.Cursor:=crHourGlass;
OptRec.FormZoom:=OptRec.FormZoom+5;
ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
SaveSingleOption('FormZoom',IntToStr(OptRec.FormZoom));
RescaleAllOpenedForms;

RNo:=GetCurrentRetNo;
AChild:=MainForm.ActiveMdiChild as TMyChild;
APageControl:=GetPageControl(AChild);
Ret[RNo]^.FrmScaled[FormNo]:=True;
MyChild.ShowFormData(AChild,RNo,FormName,FormNo);
Screen.Cursor:=crDefault;

end;

procedure TMainForm.ZoomBtnMinusClick(Sender: TObject);
Var i,j,RNo,FNo:integer;Reply:String;
AChild:TMyChild;APageControl:TPageControl;
begin
 If ButtonInactive then exit;
 If OptRec.FormZoom < 50 then exit;
 Screen.Cursor:=crHourGlass;
 OptRec.FormZoom:=OptRec.FormZoom-5;
 ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
 SaveSingleOption('FormZoom',IntToStr(OptRec.FormZoom));
 RescaleAllOpenedForms;

 RNo:=GetCurrentRetNo;
 AChild:=MainForm.ActiveMdiChild as TMyChild;
 MyChild.ShowFormData(AChild,RNo,FormName,FormNo);
 Screen.Cursor:=crDefault;
(*
If Sc>0.80 then
begin
  ScChange := ScChange-0.05;
  Sc       := 1+ScChange;
  ScChar   := 1+ScChange;
  ResizeForm(1);
end;
*)
end;

procedure TMainForm.DelphiZoom(ScalePercent:Integer); //NOT USED
//see http://www.undu.com/DN970301/00000061.htm
Const ScreenWidth: LongInt = 800; {I designed my form in 800x600 mode.}
      ScreenHeight: LongInt = 600;
Var i:Integer;
 DfmFileName:String;
 MyChild:TMychild;
 RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 MyChild:=MainForm.ActiveMdiChild as TMyChild;
 LockWindowUpdate(MyChild.Handle);
 //abends
 GetTabSheet(MyChild,GetFormName(FormNo)).Free; //Free removes form so it opens original
 OpenForm(RetNo,FormNo,0);
 MyChild.ScaleBy(ScalePercent+100,100);
 LockWindowUpdate(0);
 EXIT;
 (*
 //delphi
 for i := MainForm.MDIChildCount - 1 DownTo 0 do
 begin
  if (screen.width <> ScreenWidth) then
  begin
    MainForm.MDIChildren[i].height := longint(height) * longint(screen.height) div ScreenHeight;
    MainForm.MDIChildren[i].width := longint(width) * longint(screen.width) div ScreenWidth;
    MainForm.MDIChildren[i].scaleBy(screen.width, ScreenWidth);
  end;
 end;
 EXIT;
 *)
 (*
  //Then, you will want to have something that checks to see that the font sizes are OK.
   You can iterate over each child control's font to adjust its size as necessary.
   This can be done as follows:

 type
  TFooClass = class(TControl); { needed to get at protected }
                               { font property }

 var
  i: integer;
 begin
  for i := ControlCount - 1 downto 0 do
    TFooClass(Controls[i]).Font.Size :=
        (NewFormWidth div OldFormWidth) *
        TFooClass(Controls[i]).Font.Size;
 end;
 *)
end;



procedure TMainForm.AuditOptionClick(Sender: TObject);
Var FNo:Integer;InputString:String[1];Msg:String[40];
begin
 RefreshAuditPanel(GetCurrentRetNo);
 //If FormsPanel.Visible then RefreshFormsPanel(GetCurrentRetNo);
end;

procedure TMainForm.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
{Accept :=True;}
end;

procedure TMainForm.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
{
if (Sender is TForm) and (Source is TPanel) then
  begin
   AuditPanel.Height := Screen.Height-y;
   end;
}
end;

procedure TMainForm.AuditPanelDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
{AuditPanel.Height := Screen.Height-y;}
end;

procedure TMainForm.AuditListBoxDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
{Accept :=True;}
end;

procedure TMainForm.AuditHeaderDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
{Accept :=True;}
end;

procedure TMainForm.AuditListBoxDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
 {AuditPanel.Height := Screen.Height-y;}

end;

procedure TMainForm.StatusBarDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
{Accept := True;}
end;

procedure TMainForm.StatusBarDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
{AuditPanel.Height := Screen.Height-y;}
end;

procedure TMainForm.AuditPanelDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
{Accept:=True;}
end;

procedure TMainForm.AuditSpinBtnDownClick(Sender: TObject);
begin
If AuditPanel.Height >80 then
 AuditPanel.Height := AuditPanel.Height - 40;

end;

procedure TMainForm.AuditSpinBtnUpClick(Sender: TObject);
begin
If AuditPanel.Height <ClientHeight -80 then
 AuditPanel.Height := AuditPanel.Height + 40;
end;


procedure TMainForm.Image2Click(Sender: TObject);
begin
 //WizardPanel.Visible :=False;
end;


procedure TMainForm.Upgrade1Click(Sender: TObject);
Const ActivationFile = 'LVerf.EX_';
begin
 if MessageDlg('BE CAREFUL'+
    Chr(13)+'If you click Yes the program will terminate and ask you for a new key',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 begin
  If FileExists(AppDir+'\'+ActivationFile) then
    Sysutils.DeleteFile(AppDir+'\'+ActivationFile);
  Application.Terminate;
 end;

 {
 Application.CreateForm(TUpgrade,Upgrade);
 Upgrade.ShowModal;
 Upgrade.Free;
 }
 //MainForm.ReviseLook;
end;

procedure TMainForm.AuditListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If  (Key = VK_F5) then MainForm.AuditOpenBtnClick(Sender);
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
Var
    i,j,k,FNo,NumbFrames:Integer; s,s1,s2,s3:String;tbl:TTable;H:THandle;
    TempList,TempList1,TempList2,WList:TstringList;
    File1,File2:String;
    DT: TDateTime;
    ElmList:TStringList;
    FullFlName:String;
    BigList:TStringList;
    TDate1,TDate2:TDate;
    D1,D2:String;
    LinesList,ValueList:TStringList;
    x,Y:real;
    ZString  : Array[0..80] of Char;
    PZString : Pchar;
    CopyResult:Boolean;

    Forms:Array[0..500] of TForm;
    DfmFileName:String;

    MyLabel:TLabel;
    AForm:TForm;
    AcbTable:TStringList;
    StartPushPos:LongInt;
    MyFrame:TFrame;
    NewFrame:TFrame;
    MyShape:TShape;
    MyScrollBox:TvtScrollBox;
    MyEditBox,NewEditBox:TVtEdit;

    F1, PrnFile: TextFile;
    Ch: Char;
    SA:AnsiString;
    FlName:String;
    BusName,Address,Telephone,Fax,FirmSize,Email:String;
    Table1:TTable;
    RetNo:Integer;

    vtCalcElmName:String;
    vtCalcList:Tstringlist;
    StartPos:Integer;
  begin
  (*
   TempList := TstringList.Create;
   Templist.sorted:=True;
   TempList2 := TstringList.Create;
   TempList.LoadFromFile('C:\Test1\CharityCountries.d');
   For i:=0 to TempList.Count-1 do
   begin
    s:=LeftStr(TempList[i],Length(TempList[i])-1);
    Templist2.Add(s);
   end;
   TempList2.SaveToFile('C:\Test1\CharCountries.d');
   TempList.Free;
   TempList2.Free;
   ShowMessage('Done');
  *) 
  {
   TempList := TstringList.Create;
   Templist.sorted:=True;
   TempList2 := TstringList.Create;
   TempList.LoadFromFile('C:\Test1\CharityCountries.txt');
   For i:=0 to TempList.Count-1 do
   begin
    s:=LeftStr(LTrim(TempList[i]),10);
    If UpperCase(LeftStr(s,7))='CAPTION' then
      Templist2.Add(AllTrim(MidStr(TempList[i],14,60)));
   end;
   TempList2.SaveToFile('C:\Test1\CharityCountries.d');
   TempList.Free;
   TempList2.Free;
   ShowMessage('Done');
  }
  {
    RemoveEmptyInstances(1,'PS50',60);
    ShowMessage('Done');
    Exit;
  }
 //   GenerateT5013PS50Forms(1);
 //   ShowMessage('Done');
  // FixAProperty;
   //ModifyAllForms;  //i.e remove vertical separator
   //ShowMessage('Done');

  //RetNo:=GetCurrentRetNo;   MyChild.ShowUsedForms(RetNo);
  (*
   RetNo:=GetCurrentRetNo;
   s1:=GetDcnSeqNoEOL(RetNo,'A1111');
   S2:=GetDcnSeqNoEOL(RetNo,'A1111');
   ShowMessage(S1+'   '+S2);
   *)
 // ShowMessage(ConvertToProper('con Zant john'));
   //TimeForBackUp;
   //ShowMessage(IntToStr(GetWindowsFontSize(MainForm.Handle)));
  (*
  s:=InputBox('Input Box', 'Prompt', '100');
  ShowMessage(ubuild813.Format1273Numerics(s,3));
  *)
  //remove ubuild813 from uses
 (*
   File1:=InputBox('Input Box', 'Prompt', 'Test.d');
   TempList := TstringList.Create;
   TempList2 := TstringList.Create;
   TempList.LoadFromFile('D:\wip\tf\'+File1);
   For i:=0 to TempList.Count-1 do
   begin
    s:=LTrim(TempList[i]);
    Templist2.Add(S);
   end;
   TempList2.SaveToFile('D:\wip\TF\'+File1);
   TempList.Free;
   TempList2.Free;
   ShowMessage('Done');
 *)
  (* KEEP -it builds a dbf from CA firms *)
(*
 File1 :='CA-Firms.txt';
 TempList := TstringList.Create;
 TempList2 := TstringList.Create;
 TempList.LoadFromFile('C:\DOCTax-PRODUCTION\Promotions-2005\'+File1);

 Table1 := TTable.Create(Application);
 Table1.DataBaseName :='C:\DOCTax-PRODUCTION\Promotions-2005';
 Table1.TableName    := 'CaFirms.DBF';
 Table1.Open; //Table1.IndexName := 'FORMNAME';

 WList:=TStringList.Create;
 For i:=0 to TempList.Count-1 do
 begin
    s:=LeftStr(TempList[i],254)+'|';
    ParseWords(s,'|',Wlist);
    For j:=0 to Wlist.count-1 do
    begin
     S1:=AllTrim(WList[j]);
     if j=0 then BusName:=AllTrim(S1)
     else
     begin
      If LeftStr(S1,17)='Business Address:' then Address:=MidStr(S1,18,120);
      If LeftStr(S1,7)='E-mail:' then  Email:=MidStr(S1,8,120);
      If LeftStr(S1,10)='Telephone:' then Telephone:=MidStr(S1,11,120);
      If LeftStr(S1,4)='Fax:' then Fax:=MidStr(S1,5,120);
      If LeftStr(S1,10)='Firm Size:' then Firmsize:=MidStr(S1,11,120);
     end;
    end;
    //TempList2.Add(s);
    Table1.Edit;
    Table1.Insert;
    With Table1 do
    begin
     FieldByName('Busname').AsString:=BusName;
     FieldByName('Address').AsString:=Address;
     FieldByName('Email').AsString:=Email;
     FieldByName('Telephone').AsString:=Telephone;
     FieldByName('Fax').AsString:=Fax;
     FieldByName('FirmSize').AsString:=FirmSize;
     Post;
    end;
 end; //i
 Table1.Close;
 Table1.Free;


 //TempList2.SaveToFile('C:\DOCTax-PRODUCTION\Promotions-2005\'+'test.txt');
 TempList.Free;
 TempList2.Free;
 WList.Free;
 ShowMessage('Done');
*)
  (*
   flName:='C:\CanTax\t1-2004\Returns\a cantax  rollover.p04';
    AssignFile(F1, FlName);
    Reset(F1);
    AssignPrn(PrnFile);
    Rewrite(PrnFile);
    WriteLn(PrnFile,'==============================================');
    s:='';
    while not Eof(F1) do
    begin
      Read(F1, Ch);
      If Length(s) <80 then
        s:=s+Ch
      else
       begin WriteLn(PrnFile,s);s:='';s:=s+Ch;end;
    end;
    If Length(s)>0 then WriteLn(PrnFile,s);
    CloseFile(PrnFile);
  *)
   // SuperAuditBoxClick(Sender);
   (* Fine Print if ever needed
    ShowMessage(
        GetRegistryValue(
        HKEY_CURRENT_USER,
       'Software\FinePrint Software\pdfFactory2',
       'OutputFile')
      );
      //ShowDlg
      //'Software\FinePrint Software\pdfFactory2\FinePrinters\pdfFactory\PrinterDriverData\',
      ShowTimedMsg('Done',1500);
      Exit;
   *)
  // GetRegistryValue(RootName:HKEY;KeyName:String;KeyValueName:String)

  //  SendEMail('VisualTax@sympatico.ca','Tax return','C;\Wip\T1\Data\00000000.0','Please check file');
   {
   //ShellExecute(Handle, 'open', 'control', 'date/time', nil, SW_SHOW);
   ShellExecute(Handle, 'open', 'control', 'Display', nil, SW_SHOW);
   Exit;
   }

   //PrintWithMsWord(RetNo,AppDir+'\'+'RegForm.doc',False);
  (*
    FName:='INFO';
    DfmFileName:=GetDfmFileName(FName);
    AForm:=TForm.Create(Application);
    AForm.FormStyle:=fsNormal;
    ReadComponentResFile(DfmFileName, AForm);
    AForm.ShowModal;
    Exit;
  *)
  (* my forms explorer
   Application.CreateForm(TFExplore,FExplore);
   FExplore.ShowModal;
   FExplore.Free;
  *)
  (*
  ShiftUpDFM(FormName);
  Exit;
  *)
 // ShowMessage(WinVersionNumberToName(GetWindowsVersion));

  (*
   //preload all forms
  Screen.Cursor := crHourGlass;
   for i :=0 to 20 do //(FList.Count - 1) do
   begin
    FRec := FList.Items[i];
    FormName := Frec^.FormName;
    Forms[i]:=TForm.Create(Application);
    //AForm.FormStyle := fsMDIChild;
    DfmFileName:=GetDfmFileName(FormName);
    ReadComponentResFile(DfmFileName,Forms[i]);
  end;
  ShowMessage('Done');
  Screen.Cursor := crDefault;
  For i:=0 to 5 do Forms[i].Show;
  Exit;
  *)

  EXIT;
 (*
  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If Frec^.FormNo=2 then
   begin
    ShowMessage(FormElmArray[2,19,0]);
    ShowMessage(FormElmArray[2,5,0]);
   end;
  end;
 *)
  //ShowMessage(GetWinIniString('http://www.visualtax.com/downloads/vtversions.ini','T1','UpdateDate'));
  //ShowMessage(GetWinIniString('C:\Test\vtversions.ini','T1','updateDate'));

   (*
  s2:=InputBox('','enter psw','');
  s:=EncryptPsw(s2,9999);
  ShowMessage('encrypted='+s);
  s1:=DecryptPsw(s,9999);
  ShowMessage('decrypted:='+s1);
  *)


 //ShowMessage(CanTaxJulianDaysToYYYYMMDD('52972'));


 (*
 Try
 File1 :='eferr.txt';
 TempList := TstringList.Create;
 TempList2 := TstringList.Create;
 TempList.LoadFromFile('C:\Delphi\T1\mkefdb\'+File1);
 For i:=0 to TempList.Count-1 do
 begin
   s:='';
   s1:=AllTrim(LeftStr(TempList[i],8));
   For j:=1 to Length(S1) do
    If Numeric(S1[j]) then s:=s+s1[j];
   S1:=PaddR(S1,8);
   s2:=MidStr(TempList[i],9,254);
   Templist2.Add(S1+S2);
 end;
 TempList2.SaveToFile('C:\Delphi\T1\mkefdb\'+'temperr.txt');
 TempList.Free;
 TempList2.Free;
 ShowMessage('Done');
 except
  ShowMessage('Failed');
 end;
 *)

 {ShowMessage(GetTheTime(now));}

  {
  h := ShellExecute(MainForm.Handle, Nil, 'WebBrowser.Exe', Nil,
  Nil, SW_RESTORE);
  }
(*
{reset the EF indicators}
if MessageDlg('Change EF status to Ready?',
    mtInformation, [mbYes, mbNo], 0) = mrNo then exit;

Tbl := TTable.Create(Application);
Tbl.DataBaseName := OptRec.Dir_cur;
Tbl.TableName := 'CLIENTS.DBF';
Tbl.Open;
Repeat
 Tbl.Edit;
 If Tbl.FieldByName('EF_Status').AsString <> '02' then
  begin
   Tbl.FieldByName('EF_Status').AsString := '02';
   {01=ready for RTU,02 accepted}
   Tbl.Post;
  end;
 Tbl.Next;
until Tbl.Eof;
Tbl.Close;
Tbl.Free;
ShowMessage('Ef status done');
*)
end;


procedure TMainForm.InternetWebSite1Click(Sender: TObject);
Var h:THandle;
begin
 ConnectToWeb('HTTP://www.VisualTax.com');
end;

procedure TMainForm.WWWLblClick(Sender: TObject);
begin
 InternetWebSite1Click(Sender);
end;

procedure TMainForm.ExpandBtnClick(Sender: TObject);
begin
 FormsTreeView1.FullExpand;
 FormsTreeView1.TopItem:=FormsTreeView1.Items[0];
end;

procedure TMainForm.CollapseClick(Sender: TObject);
begin
FormsTreeView1.FullCollapse;
end;

procedure TMainForm.FormsTreeView1Click(Sender: TObject);
Var SourceNode : TTreeNode; Ndx :Integer;Fname:String[15];
begin
 Try
  SourceNode:= FormsTreeView1.Selected;
  Ndx :=SourceNode.AbsoluteIndex;

  If SourceNode.Expanded then
   begin SourceNode.Collapse(True);exit;end
  else
   begin
    If SourceNode.HasChildren then begin SourceNode.Expand(True);exit;end;
  end;

   //If ButtonInactive then exit;
  If RetInMem=0 then   //open return first
  begin
    If (OptRec.Dir_Deflt = '') or
    (Not FileExists(OptRec.Dir_Deflt+'\'+'Clients.DBF')) then
    begin
     showMessage('Data directory has not been defined'+
     Chr(13)+'Click on Configure | General Options \ Data Directories');
     exit;
    end;

    CreatingNew := True;
    RetNo:=InitNewReturn;
    OpenForm(RetNo,GetFormNo('T3'),0);
  end;

  Ndx :=SourceNode.AbsoluteIndex;

  If Uppercase(FormsTreeView1.items.Item[ndx].Text)='FILLABLE CRA FORMS' then
  Begin
   SelectFormClick(Sender);
  // ConnectToWeb('http://www.cra-arc.gc.ca/menu/FIL-e.html');
   Exit;
  End;

  //FName:= AllTrim(RightStr(FormsTreeView1.items.Item[ndx].Text,15));
  If UsedFormsBox.checked then
   Fname:=GetFName(FormsTreeView1.items.Item[ndx].Text)
  else
   Fname := AllTrim(FrmTreeForms[ndx]);

  If FName >'' then OpenForm(GetCurrentRetNo,GetFormNo(FName),0);
 except
 end;
end;


procedure TMainForm.WorldButtonClick(Sender: TObject);
begin
InternetWebSite1Click(Sender);
end;


procedure TMainForm.AlphabeticalFormsIndex1Click(Sender: TObject);
begin
EXIT;
 If ButtonInactive then exit;
 Application.CreateForm(TABList,ABList);
 ABList.ShowModal;
 ABList.Free;
end;

procedure TMainForm.Zoomin1Click(Sender: TObject);
begin
ZoomBtnPlusClick(Sender);
end;

procedure TMainForm.Zoomout1Click(Sender: TObject);
begin
ZoomBtnMinusClick(Sender);
end;

procedure TMainForm.Toolbandswitch1Click(Sender: TObject);
begin
 ToolBarBtnClick(Sender);
end;

procedure TMainForm.Color1Click(Sender: TObject);
Var Clr : Tcolor; RetNo:Integer;
begin
 If ButtonInactive then exit;
 RetNo:=GetCurrentRetNo;
 if ColorDialog1.Execute then
     IF CLR <> clBlack then Clr := ColorDialog1.Color;
 If IsColorInUse(Clr) then
  ShowMessage('Color already in use')
 else
  begin
  FreeUpColor(GetRetColor(RetNo));
  If RecolorReturn(RetNo,clr) = false then
   begin ShowMessage('Return Not found');exit;end;
  SetColorInUse(Clr);
  end;

{Clr0Click(Sender);}
end;

procedure TMainForm.Recalc1Click(Sender: TObject);
begin
RecalcBtnClick(Sender);
end;


procedure TMainForm.VerticalSplitter1CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
 LockWindowUpdate(MainForm.Handle);
 If NewSize <35 then NewSize :=35;
 Accept:=True;
 LeftPanel.width:=NewSize;
 LockWindowUpdate(0);
end;

procedure TMainForm.AdjustFontSize;
begin
EXIT;
end;

procedure TMainForm.AppException(Sender: TObject; E: Exception);
begin
  Application.ShowException(E);
end;


procedure TMainForm.ReIndextheClientDataBase1Click(Sender: TObject);
begin
ExecuteForm(TReindexDb);
end;

procedure TMainForm.TreeViewBtnClick(Sender: TObject);
begin
If ButtonInactive then exit;
If RetInMem<2 then
begin
 ShowTimedMsg('Window tiling is effective only when multiple returns are loaded',1800);
end;
 SomeList := TStringList.Create;
 SomeList.Add('1. Tile Horizontally');
 SomeList.Add('2. Tile Vertically');
 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 SomeList.Free; PopList.Release;
 If SelectedString > '' then
 begin
  If LeftStr(SelectedString,1)='1' then
   TileHorizontally1Click(Sender)
  else If LeftStr(SelectedString,1)='2' then
   TileVertical1Click(Sender)
  else
  Exit;
 end;
end;

procedure TMainForm.RestructuretheClientsDataBase1Click(Sender: TObject);
begin
(*
 Application.CreateForm(TRestructure,Restructure);
 Restructure.ShowModal;
 Restructure.Free;
 *)
end;



procedure TMainForm.WidePanelBtnClick(Sender: TObject);
Var Denom:Integer;
begin
end;

procedure TMainForm.AuditOpenBtnClick(Sender:TObject);
begin
 If ButtonInactive then exit;
 LockWindowUpdate(MainForm.Handle);
 RefreshAuditPanel(GetCurrentRetNo);
 LeftPanel.Visible := not LeftPanel.Visible;
 LockWindowUpdate(0);
end;


procedure TMainForm.ErrorViewClick(Sender: TObject);
Var SourceNode : TTreeNode; Ndx :Integer;ErrorMsg:String;
 FrmNm:String[10];i,FNo:Integer; AtFieldId:Integer;
 TheEnterKey:Char;
 //for superaudit
 LnNo:Integer;
 Value:String;
 FileFound:Boolean;
 FlName:String;
 RetNo:Integer;
begin

 SourceNode:= ErrorView.Selected;
 Ndx :=SourceNode.AbsoluteIndex;
 ErrorMsg:=SourceNode.text;

 AtFieldId := MyStrToInt(AllTrim(MidStr(ErrorMsg,71,3)));
 FrmNm := AllTrim(MidStr(ErrorMsg,61,10));
 If FrmNm='' then exit;

 FNo:= GetFormNo(FrmNm);
 If FNo<1 then exit;
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,FNo,AtFieldId);
end;

procedure TMainForm.FormsTreeView1KeyPress(Sender: TObject; var Key: Char);
begin
 FormsTreeView1Click(Sender);
end;

procedure TMainForm.ExchageRatesAverage1Click(Sender: TObject);
begin
 SomeList := TStringList.Create;
 SomeList.Sorted := True;
 SomeCaption := 'Average Exchange Rates for 2005';
 SomeList.LoadFromFile(AppDir+'\'+'EXCHRATE.D');
 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 SomeList.Free; PopList.Release;
end;

procedure TMainForm.Checkupdate1Click(Sender: TObject);
Var h:THandle;
begin
 ConnectToWeb('HTTP://www.VisualTax.com/Download.asp');
end;

procedure TMainForm.Image1Click(Sender: TObject);
 Var h : Thandle;
begin
 Checkupdates1Click(Sender);
end;

procedure TMainForm.CheckUpdatesLblClick(Sender: TObject);
begin
 Checkupdates1Click(Sender);
end;

procedure TMainForm.Label1Click(Sender: TObject);
begin
 InternetWebSite1Click(Sender);
end;

procedure TMainForm.ClearCurrentformClick(Sender: TObject);
Var i,n:Integer;Root:String[10];AChild:TMyChild;
RetNo:Integer;
begin
 If ButtonInactive then exit;
 RetNo:=GetCurrentRetNo;
 If not IsFormMultipage(FormName) then
  ClearForm(RetNo,FormName)
 else
 begin
   n:=GetFormMxPg(FormName);
   Root := ExtractFormRootName(FormName);
   For i:=1 to n do ClearForm(RetNo,Root+'_'+IntToStr(i)+ExtractFormInst(FormName));
 end;

 RecalcBtnClick(Application);
 AChild:=MainForm.ActiveMDIChild as TMyChild;
 AChild.ShowFormData(AChild,RetNo,FormName,FormNo);
 Ret[RetNo]^.FrmHasData[GetFormNo(FormName)]:=False;
 RefreshAuditPanel(RetNo);//If AuditPanel.Visible then RefreshAuditPanel;
 //If FormsPanel.Visible then RefreshFormsPanel(RetNo);
end;

procedure TMainForm.ClearCurrentPageClick(Sender: TObject);
Var RefFNo:Integer;RefFormName:String;RetNo:Integer;AChild:TMyChild;
begin
 If ButtonInactive then exit;
 RetNo:=GetCurrentRetNo;
 If (LeftStr(FormName,7) = 'FLDTAPE') and
 (UpperCase(FetchElm(RetNo,FormName,123))='X') then {post it first}
  begin
   RefFormName:=FetchElm(RetNo,FormName,121);
   RefFNo:=GetFormNo(RefFormName);
   StoreElm(RetNo,RefFNo,
    MyStrToInt(FetchElm(RetNo,FormName,122)),'0');
 end;
 ClearForm(RetNo,FormName);
 RecalcBtnClick(Application);
 AChild:=MainForm.ActiveMDIChild as TMyChild;
 AChild.ShowFormData(AChild,RetNo,FormName,FormNo);
 Ret[RetNo]^.FrmHasData[GetFormNo(FormName)]:=False;
 RefreshAuditPanel(RetNo);//If AuditPanel.Visible then RefreshAuditPanel;
 //If FormsPanel.Visible then RefreshFormsPanel(RetNo);
end;

Function TMainForm.SelectFromLoadedReturns(RetNo:Integer):Integer;
Var i:Integer;
begin
 Result:=RetNo;
 SomeList := TStringList.Create;
 SomeList.Sorted := True;
 SomeCaption := 'Select from Loaded returns';
 GetListOfLoadedReturns(SomeList);
 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 SomeList.Free; PopList.Release;
 If SelectedString > '' then
   Result:=MyStrToInt(AllTrim(LeftStr(SelectedString,2)));
end;

Procedure TMainForm.GetListOfLoadedReturns(SomeList:TStringList);
Var i:Integer;
Begin
 SomeList.Clear;
 SomeList.Sorted := True;
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   SomeList.Add(GetReturnCaption(RetRec^.RetNo));
 end;
end;

procedure TMainForm.UsedFormsBoxClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  If UsedFormsBox.checked= False then
  begin
   FormsTreeView1.items.clear;
   FormsTreeview1.LoadFromFile(AppDir+'\Treeview2.D');
   exit;
  end
 Else
  UsedFormsOnTreeview(GetCurrentRetNo);
end;

Procedure TMainForm.UsedFormsOnTreeView(RetNo:Integer);
Var SourceNode : TTreeNode; Ndx :Integer;Fname:String[10];
    i:integer;TempList:TStringList;
begin
  FormsTreeView1.items.clear;
  TempList:=TStringList.Create;
  TempList.Add('USED FORMS');

  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If (Frec^.FormShow) and (Ret[RetNo].FrmHasData[Frec^.FormNo])
    then TempList.Add(' '+AllTrim(Frec^.FormAbrev));
 end;
  TempList.SaveToFile(AppDir+'\'+'Temp');
  FormsTreeView1.LoadFromFile(AppDir+'\'+'Temp');
  FormsTreeView1.FullExpand;
  FormsTreeView1.TopItem:=FormsTreeView1.Items[0];
  TempList.Free;
End;

procedure TMainForm.ErrorViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var SourceNode : TTreeNode; Ndx :Integer;ErrorMsg:String;
 FrmNm:String[10];i,FNo:Integer; AtFieldId:Integer;
 TheEnterKey:Char;
 FrmHandle:Integer;
begin

end;

procedure TMainForm.ErrorViewCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  NodeRect: TRect;
begin
end;



procedure TMainForm.SuperAuditBoxClick(Sender: TObject);
begin
 If (LeftStr(LicenseLevel,8) = 'T1 Power')
 or (LeftStr(LicenseLevel,8) = 'T1 Multi')
 or (LeftStr(LicenseLevel,8) = 'T1 Demo')
 then
   //ok
 else
 begin
  ShowMessage('Available only in the Power version of the program');
  Exit;
 end;

 Screen.Cursor:=crHourGlass;
 SuperFeaturesLbl.Caption:='Missing this year';
 RefreshAuditPanel(GetCurrentRetNo);
 Screen.Cursor:=crDefault;

end;

Procedure TMainForm.RefreshSuperAudit(RetNo:Integer);
Var i,ElmNo:Integer;FrmNm,FldName,FullFlname:String;Xref:TStringList;
    FileFound:Boolean;
begin
end;

Procedure TMainForm.PutLastYearValueOnFrmGrid(Frmnm:String;FileFound:Boolean;LnNo:Integer;Description:String;Value:String);
Var i:Integer;
begin
end;


Procedure TMainForm.PutFrmDictOnFrmGrid(Frmnm:String;FileFound:Boolean);
Var i:Integer;
begin
end;

procedure TMainForm.OpenPreviousYearsT11Click(Sender: TObject);
 Var h : Thandle;
   PgmPathS,PgmS,PgmParmsS:String;
   PgmPathZ : Array[0..254] of Char;
   PgmParmsZ : Array[0..254] of Char;
   PgmZ: Array[0..254] of Char;
   s:String;
begin
 S:= InputBox('Input Box', 'Program path and name (not necessarily VisualTax)', 'C:\TF-2007\TF2007.EXE');
 PgmPathS := ExtractFileDir(S); StrPCopy(PgmPathZ,PgmPathS);
 PgmS:=ExtractFileName(S); StrPCopy(PgmZ,PgmS);
 PgmParmsS:=''; StrPCopy(PgmParmsZ,PgmParmsS);
 h := ShellExecute(MainForm.Handle, Nil, PgmZ, PgmParmsZ,PgmPathz, SW_RESTORE);
 If H<=32 then ShowMessage('Program not found');
end;

procedure TMainForm.ImportConfiguration1Click(Sender: TObject);
begin
 Application.CreateForm(TImportConfig,ImportConfig);
 ImportConfig.ShowModal;
 ImportConfig.Free;
end;


procedure TMainForm.ExportConfiguration1Click(Sender: TObject);
begin

 Application.CreateForm(TExportConfig,ExportConfig);
 ExportConfig.ShowModal;
 ExportConfig.Free;

end;

procedure TMainForm.Findaline1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 Application.CreateForm(TFindALine,FindALine);
 FindALine.ShowModal;
 FindALine.Free;
end;



procedure TMainForm.LinesBtnClick(Sender: TObject);
begin
Findaline1Click(Sender);
end;


procedure TMainForm.UsefulLinksClick(Sender: TObject);
Var h:THandle;
begin
  ConnectToWeb('HTTP://www.VisualTax.com/links.asp');
end;

procedure TMainForm.SetReturnPassword1Click(Sender: TObject);
Var s:String;
begin
  If buttonInactive then exit;
  Application.CreateForm(TSetFilePsw,SetFilePsw);
  SetFilePsw.ShowModal;
  SetFilePsw.Free;
end;

procedure TMainForm.RemoveReturnPassword1Click(Sender: TObject);
begin
 If buttonInactive then exit;
 RemoveReturnPsw(RetNo);
 ShowTimedMsg('Password Removed',1000);
end;

procedure TMainForm.SetProgramPassword1Click(Sender: TObject);
Var s:String;
begin
 Application.CreateForm(TSetPgmPsw,SetPgmPsw);
 SetPgmPsw.ShowModal;
 SetPgmPsw.Free;
end;

procedure TMainForm.RemoveProgramPassword1Click(Sender: TObject);
begin
 RemovePgmPsw;
 ShowTimedMsg('Program Password Removed',1000);
end;

procedure TMainForm.PrintAuditBtnClick(Sender: TObject);
Var i:Integer;FileNm,Hdr1,Hdr2,Hdr3,s:string;TempList:TStringList;
begin
 If PrintDialogItem.Execute then
 begin
  Calc(GetCurrentRetNo,'DIAGNO');
  StartPrintForm(GetCurrentRetno,'DIAGNO',1);
 end;
end;


procedure TMainForm.EmailCurrentFormClick(Sender: TObject);
Var RetNo:Integer;
begin
 If buttoninactive then exit;
 If AllowPrinting(RetNo)=False then exit;
 RetNo:=GetCurrentRetNo;
 If not IsFormMultipage(FormName) then
  Calc(RetNo,FormName)
 else
  CalcMultiPageForm(RetNo,FormName);
 PrintFormForEmail(RetNo,FormName);
end;

procedure TMainForm.PrintFormForEmail(RetNo:Integer;FormName:String);
Var OldPrinterName:String;
begin
 OldPrinterName:=GetDefaultPrinterName;
 If ButtonInactive then exit;

 If IsPrinterInstalled('PDFFactory') then
 begin
  ShowMessage('The forms(s) will be printed in PDF format.'+
               Chr(13)+'Once completed, click SEND to EMAIL it');
  SetDefaultPrinter('PdfFactory');
  If FormName>'' then
  begin
   StartPrintForm(RetNo,FormName,99);
   SetDefaultPrinter(OldPrinterName);
  end
 end
 Else
 begin
  ShowMessage('The PDFFactory printer Driver has not been installed');
  Application.CreateForm(TPdfFrm,PdfFrm);
  PdfFrm.ShowModal;
  PdfFrm.Free;
 end;
end;


procedure TMainForm.SaveALLopenedreturns1Click(Sender: TObject);
begin
EXIT;
 SaveAllReturns;
end;


Function TMainForm.SaveAllReturns:Boolean;
Var i:Integer;FlName,DataDir:String;RNo:Integer;
begin
 If RetInMem=0 then exit;
 If RY=1 then
 begin
  ShowMessage('A return is in Planning mode. Please use one-by-one Save (F3)');
  Exit;
 end;

 Result:=False;
 Screen.Cursor:=CrHourGlass;
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   RNo:=RetRec^.RetNo;
   CalcAll(RetNo);
   Ret[RNo]^.CalcStatus := True;
   ErrorCount := CountDiagnostics(RNo);
   If MandatoryErrorCount > 0 then
   begin
    OpenForm(RNo,GetFormNo('T3'),0);
    If not LeftPanel.Visible then begin LeftPanel.Visible:=True; AuditOpenBtnClick(Application);End;
    RefreshAuditPanel(GetCurrentRetNo);
    ShowMessage('Please enter Mandatory data before saving and try again');
    Screen.Cursor:=CrDefault;
    exit;
   end;
   FlName := Ret[RNo]^.SourceFlName;
   If FlName = '' then
   FlName := LeftStr(FetchElm(RNo,'T3',3),8)+
    '.'+RightStr(FetchElm(RNo,'T3',3),1);
   DataDir := Ret[RNo]^.SourceDataDir;
   If IsDataDirectoryGood(DataDir) = False then exit;
   If DirectoryExists(DataDir) = False then
   begin
    ShowMessage('Directory does not exist');
    Exit;
   End;
   If FileExists(DataDir+'\'+ClientsTable) = False then
   begin
    ShowMessage('Data directory '+DataDir + ' was not configured for tax returns');
    Exit;
   End;

   If Ret[RNo].Locked = true then
   begin
   ShowMessage('Cannot save: '+ GetRetName(RNo)+
     chr(13)+'This return has been locked');
   //exit;
   end
  else
  BEGIN
  {put changed STATUS form data}
  with Ret[RNo]^.Frm[GetFormNo('STATUS')] do
  begin
   {last update}
   Strings[11] := UserName;
   Strings[12] := FormatDateTime('yyyy-mm-dd',Now);
   Strings[13] := TimeToStr(Time);
  end;

  If SaveReturn(RNo,DataDir,FlName,True,True) = 0 then
  begin
     Ret[RNo]^.SourceDataDir := DataDir;
     Ret[RNo]^.SourceFlName := FlName;
     Ret[RNo]^.changed:=False;
   end
   else
   begin
      ShowMessage('Return was not saved... Press any key');
      exit;
   end;
  END;
 end;  //i
 Screen.Cursor:=CrDefault;
 ShowTimedMsg('All returns saved',1200);
 Result:=True;
end;


procedure TMainForm.SaveandCloseAllopenedreturns1Click(Sender: TObject);
begin
EXIT;
 If RY=1 then
 begin
  ShowMessage('A return is in Planning mode. Please use one-by-one Save (F3)');
  Exit;
 end;
 If SaveAllReturns= True then CloseAllReturns;
end;

procedure TMainForm.CloseallreturnsWITHOUTSaving1Click(Sender: TObject);
Var i:Integer;RetNo:Integer; //FHandle:THandle
begin
 if MessageDlg('Close ALL returns without saving them?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then CloseAllReturns;
end;


Procedure TMainForm.CloseAllReturns;
Var i:Integer; TempList:TStringList;RetNo:Integer;
begin
  For i:=RetList.count-1 downto 0 do
  begin
    RetRec := RetList.Items[i];
    RetNo:=RetRec^.RetNo;
    Ret[RetNo]^.Changed:=False;
    CloseReturn(RetNo);
  end;
  //now close all windows
  for i := MainForm.MDIChildCount - 1 DownTo 0 do
  begin
    MainForm.MDIChildren[i].destroy;
  end;
  RetList.Clear;
  If RetInMem = 0 then
  begin
      ColorList.Free; InitColorTable;
      RetNo :=0;FormNo := 0;Formname :='';
      MainForm.FormPaint(Application);
  end;
end;

procedure TMainForm.TestBlBoxClick(Sender: TObject);
Var FrmNm:String;RetNo:Integer;
begin
end;


procedure TMainForm.CloseBlackBoxBtnClick(Sender: TObject);
Var Templist:TStringList;
begin
end;

procedure TMainForm.ProcessBlackBoxFile;
Var RetNo:Integer;
begin
end;  //end blackbox


procedure TMainForm.FormsBlackBoxBtnClick(Sender: TObject);
begin
 SelectFormClick(Sender);
end;



procedure TMainForm.Provincialnews1Click(Sender: TObject);
begin
 ShowHelp('TfHelp','HELP_CONTENTS');

end;


Function TMainForm.CountFiles(Dir:String;FileExt:String):Integer;
Var i:Integer; FileListBox1:TFileListBox;
begin
  FileListBox1:=TFileListBox.Create(Application);
  FileListBox1.Parent:=Self;
  FileListBox1.Visible:=False;
  FileListBox1.Mask:='*.'+FileExt;
  FileListBox1.Directory:=Dir;
  Result:=FileListBox1.Items.Count;
  FileListBox1.Free;
end;



procedure TMainForm.CICALineByLineInternethelpNONResidents1Click(Sender: TObject);
Var h:THandle;
begin
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(MainForm.Handle,'open',
  'http://www.knotia.ca/Knowledge/LBL/Home.cfm?kType=93&LBLGuideID=2',
  Nil,Nil,Sw_Show);
  If H<=32 then
   ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

procedure TMainForm.OtherGuides1Click(Sender: TObject);
Var PgmPath,PgmFile:String;
begin
 SomeList := TStringList.Create;
 SomeCaption := 'CRA GUIDES';
 SomeList.LoadFromFile(AppDir+'\'+'GUIDES.d');
 Application.CreateForm(TPoplist,PopList);
 Poplist.Height:=500;
 PopList.ShowModal;
 SomeList.Free; PopList.Release;
 If SelectedString > '' then
 begin
  PgmPath:=AppDir;
  PgmFile:=AllTrim(LeftStr(SelectedString,8))+'.PDF';
  ShowPdf(PgmPath,PgmFile);
 end;

end;


procedure TMainForm.CCArates1Click(Sender: TObject);
begin
 SomeList := TStringList.Create;
 //SomeList.Sorted := True;
 SomeCaption := 'CCA RATES (Class  Rate  Description)';
 {ListCaption;}
 SomeList.LoadFromFile(AppDir+'\'+'CCARATES.D');
 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 SomeList.Free; PopList.Release;
end;



procedure TMainForm.Checkupdates1Click(Sender: TObject);
Var h:THandle;
begin
  CheckUpdates(Self.Handle,AppName+'-'+AppYear);
end;

procedure TMainForm.Frequentlyaskedquestions1Click(Sender: TObject);
Var h:THandle;
begin
 
end;

procedure TMainForm.VisualTaxForum1Click(Sender: TObject);
Var h:THandle;
begin
  ConnectToWeb('http://www.visualtax2.com/cgi-bin/dcforum/dcboard.cgi');
end;

procedure TMainForm.HowoftentocheckInternetUpdates1Click(Sender: TObject);
begin
 Application.CreateForm(TUpdateSchedule,UpdateSchedule);
 UpdateSchedule.ShowModal;
 UpdateSchedule.Free;
end;

procedure TMainForm.TrEngineLoadClick(Sender: TObject);
Var h : Thandle;Dir:String;TempList:TstringList;
begin
 TrFolder:=GetTrFolder;
 If fileExists(TrFolder+'\'+'TR'+TRYear+'.EXE') = false then
 begin
  ShowMessage('TR was not installed in '+TrFolder
   +Chr(13)+' Please see Configure | TR (Tax Research) program directory');
  Exit;
 end;

 h:=GetTrHandle;
 If h <> 0 then
   ShowWindow(h,SW_SHOWMAXIMIZED)
 else
   LoadTr(TrFolder);
end;


procedure TMainForm.ListMultipleBtnClick(Sender: TObject);
Var I,J,MxPg,k,FNo:Integer; FName,FNonInst,FRootName,FInst:string[10];RetNo:Integer;
s:String;
begin
 RetNo:=GetCurrentRetNo;
 If IsFormMultiInst(FormName) then
 begin
   SomeList := TStringList.Create;
   FNonInst:= ExtractNonInstFormName(FormName);
   for i :=0 to (FList.Count - 1) do
   begin
    FRec := FList.Items[i];
    If FNonInst = Frec^.FormName then
    begin
      FNo:=Frec^.FormNo;
      FInst:=Frec^.FormInst;
      If Ret[RetNo]^.FrmHasData[FNo] then
      Begin
        If (LeftStr(FormName,6)='T5013#')
        then Somelist.Add(PaddR(FNonInst+FInst,10)+' '+FetchElmFNo(RetNo,FNo,15))
        else If (LeftStr(FormName,7)='T3SUPL#') then
          Somelist.Add(PADDR(AllTrim(FetchElmFNo(RetNo,FNo,26)),39)   //lastname
                      +PADDR(AllTrim(FetchElmFNo(RetNo,FNo,64)),20)   //first name
                      +' '+PaddR(FNonInst+FInst,10))                  //slipid
         // Somelist.Add(PaddR(FNonInst+FInst,10)+' '+FetchElmFNo(RetNo,FNo,26))
        //20120328
        else
         If (LeftStr(FormName,7)='T5018L#') then
         begin
          s:=PaddR(FNonInst+FInst,10)+' '+FetchElmFNo(RetNo,FNo,6)
          +' '+FetchElmFNo(RetNo,FNo,7)+' '+FetchElmFNo(RetNo,FNo,9);
         Somelist.Add(PaddR(s,50)+' '+FormatFloat('###,###,###.##',Vl(FetchElmFNo(RetNo,FNo,2))))
         end
        else
         Somelist.Add(PaddR(FNonInst+FInst,10));
      end;
    end; //found the form
   end;  //i


   //20150106  ColumnSortAscending DOES NOT WORK See alternate method below
   If SomeList.count>0 then
   Begin
    IF LeftStr(SomeList[0],7) ='T3SUPL#' then
    begin
    // ColumnSortAscending(Somelist,11,20);  //does not work
     Somelist.sorted:=True;  //20140106
    end;
 end;

   SomeCaption := 'List of multi-instance forms';
   Application.CreateForm(TPoplist,PopList);
   PopList.ShowModal;
   SomeList.Free; PopList.Release;
   If SelectedString > '' then
   begin
    If (LeftStr(FormName,7)='T3SUPL#') then //20150106
       OpenForm(RetNo,GetFormNo(AllTrim(MidStr(SelectedString,60,10))),0)
    else
       OpenForm(RetNo,GetFormNo(AllTrim(LeftStr(SelectedString,10))),0);
   end;
   Exit;
 end;  //check slips

end;

procedure TMainForm.TrGuide1Click(Sender: TObject);
begin
ConnectToWeb('http://www.visualtax.com/TrGuide-2005.htm');
end;

procedure TMainForm.DefinetheTRfolder1Click(Sender: TObject);
Var TempList:TStringList;Prompt:String;
begin
 Prompt:=GetTrFolder;
 If Prompt='' then Prompt:='C:\TR-2005';
 TrFolder:= InputBox('Input Box', 'Enter your TR installation folder', Prompt);
 If UpperCase(TrFolder)=UpperCase(AppDir) then
 begin
  ShowMessage('The TR must be installed outside the T1 or T2 or TF program folder');
  If fileExists(AppDir+'\'+'Trfolder.d') then
    sysutils.DeleteFile(AppDir+'\'+'Trfolder.d');
  Exit;
 end;
 TempList:=TStringList.Create;
 TempList.add(TrFolder);
 TempList.SaveToFile(AppDir+'\'+'TrFolder.d');
 TempList.Free;
 If FileExists(TrFolder+'\'+'TR'+TRYear+'.exe') = false then
  ShowMessage('TR wan not installed in '+TrFolder+' directory');
end;

procedure TMainForm.TileVertical1Click(Sender: TObject);
begin
TileMode:=tbVertical;
Tile;
end;

procedure TMainForm.VerticalSplitter2CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
 If NewSize <35 then begin NewSize :=35;Accept := True;end;
end;

procedure TMainForm.ReturnsListBoxClick(Sender: TObject);
Var SelectedRetNo:Integer;RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 SelectedRetNo:=MyStrToInt(AllTrim(LeftStr(ReturnsListBox.Items[ReturnsListBox.ItemIndex],2)));
 If SelectedRetNo > 0 then
 Begin
  PrevRetNo := RetNo;
  PrevFormNo:= FormNo;
  RetNo := SelectedRetNo;
  CalcAll(RetNo);
  LockWindowUpdate(MainForm.Handle);
  OpenForm(RetNo, PrevFormNo,0);
  RefreshAuditPanel(RetNo);
  LockWindowUpdate(0);
 end;
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
 FormsPanel.width:=2;
end;

function TMainForm.IsReturnOpen(RNo:Integer): Boolean;
Var i:Integer;
begin
 Result:=False;
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   if (RetRec^.RetNo = RNo) and (RetRec^.RetHandle <> 0) then
   begin
    Result:=True;
    Exit;
   end;
 end;
end;

procedure TMainForm.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;MousePos: TPoint; var Handled: Boolean);
var i:integer;
begin
   for i := 0 to activemdichild.ComponentCount - 1 do
    begin
     if activemdichild.Components[i].Name = FormName then
     begin
      (activemdichild.Components[i] as TvtScrollBox).VertScrollBar.Position := (activemdichild.Components[i] as tvtscrollbox).VertScrollBar.Position + 100;
     end
    end;
end;

procedure TMainForm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;MousePos: TPoint; var Handled: Boolean);
var i:integer;
begin
    for i := 0 to activemdichild.ComponentCount - 1 do
    begin
     if activemdichild.Components[i].Name = FormName then
     begin
      (activemdichild.Components[i] as tvtscrollbox).VertScrollBar.Position := (activemdichild.Components[i] as tvtscrollbox).VertScrollBar.Position - 100;
     end
    end
end;

procedure TMainForm.TileHorizontally1Click(Sender: TObject);
begin
TileMode:=tbHorizontal;
Tile;
end;


procedure TMainForm.Setdisplayresolution1Click(Sender: TObject);
begin
 Application.CreateForm(TSetDisplay,SetDisplay);
 SetDisplay.ShowModal;
 SetDisplay.Free;
end;

procedure TMainForm.NewReturnLblClick(Sender: TObject);
begin
FileNewItemClick(Sender);
end;

procedure TMainForm.OpenReturnLblClick(Sender: TObject);
begin
FileOpenItemClick(Sender);
end;

procedure TMainForm.ShowMostRecentReturns;
Var I:Integer;SomeList:TStringList;
    AColumn:TListColumn;
    AListItem:TListItem;
    MaxReturns:Integer;
Begin
  If OptRec.HideMostRecent then Exit;
  With ListView1 do
  begin
    ListView1.Items.Clear;
    ListView1.Visible:=False;
    ViewStyle := vsReport;
    //add column names
    AColumn := Columns.Add;
    AColumn.Caption := 'Name';
    AColumn.Width:=200;

    AColumn := Columns.Add;
    AColumn.Caption := 'Date';
    AColumn.Width:=80;

    AColumn := Columns.Add;
    AColumn.Caption := 'Time';
    AColumn.Width:=80;

    AColumn := Columns.Add;
    AColumn.Caption := 'File Name';
    AColumn.Width:=100;

    AColumn := Columns.Add;
    AColumn.Caption := 'Folder';
    AColumn.Width:=200;

    SomeList := TStringList.Create;
    If FileExists(AppDir+'\'+RecentFlName) then
    begin
     SomeList.LoadFromFile(AppDir+'\'+RecentFlName);
     MaxReturns:=SomeList.Count-1;
     If MaxReturns>30 then MaxReturns:=30;
     For i:=0 to MaxReturns do //SomeList.count-1 do
     begin
      AListItem := Items.Add;
      AListItem.Caption := LeftStr(SomeList[i],30);
      AListItem.SubItems.Add(LTrim(MidStr(SomeList[i],31,11)));
      AListItem.SubItems.Add(LTrim(MidStr(SomeList[i],42,12)));
      AListItem.SubItems.Add(LTrim(MidStr(SomeList[i],54,50)));
      AListItem.SubItems.Add(LTrim(MidStr(SomeList[i],104,100)));   //20100216
     end;
    end;
    SomeList.Free;
  end; //with
  ListView1.Visible:=True;
end;

procedure TMainForm.WhatsNewLblClick(Sender: TObject);
begin
YourLatestReleaseClick(Sender);
end;

procedure TMainForm.FaQLblClick(Sender: TObject);
begin
Frequentlyaskedquestions1Click(Sender);
end;

procedure TMainForm.HelpLblClick(Sender: TObject);
begin
VisualTaxGuide1Click(Sender);
end;

procedure TMainForm.ForumLblClick(Sender: TObject);
begin
VisualTaxForum1Click(Sender);
end;

procedure TMainForm.TRLblClick(Sender: TObject);
begin
TrEngineLoadClick(Sender);
end;


procedure TMainForm.Lockreturnagaistchanges1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 LockReturn(GetCurrentRetNo);
end;

procedure TMainForm.UnlockReturn1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 UnlockReturn(GetCurrentRetNo);
end;

procedure TMainForm.SetHorScrollBarInListBox(ListBox: TListBox; MaxWidth: Integer);
var
  i, w: Integer;
begin
  if MaxWidth = 0 then
    SendMessage(ListBox.Handle, LB_SETHORIZONTALEXTENT, MaxWidth, 0)
  else
  begin
    { get largest item }
    for i := 0 to ListBox.Items.Count - 1 do
      with ListBox do
      begin
        w := Canvas.TextWidth(Items[i]);
        if w > MaxWidth then
          MaxWidth := w;
      end;
    SendMessage(ListBox.Handle, LB_SETHORIZONTALEXTENT,
      MaxWidth + GetSystemMetrics(SM_CXFRAME), 0);
  end;
end;


procedure TMainForm.ListView1DblClick(Sender: TObject);
Begin
 OpenItBtnClick(Sender);
end;

procedure TMainForm.ListView1KeyPress(Sender: TObject; var Key: Char);
begin
 if (Key = #13) then {Return key}
   ListView1DblClick(Sender);
end;

procedure TMainForm.Options2Click(Sender: TObject);
begin

 Application.CreateForm(TOptionsFrm,OptionsFrm);
 OptionsFrm.ShowModal;
 OptionsFrm.Free;
end;


procedure TMainForm.QuestionMarkLblMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if Button = mbLeft then  { drag only if left button pressed }
 with Sender as TvtLabel do  {treat Sender as ??TFileListBox }
 begin
 end;

end;

procedure TMainForm.LicLevel1Click(Sender: TObject);
begin
ChangeLicenseLevel;
end;

procedure TMainForm.PrepareDistr1Click(Sender: TObject);
Var Psw:String;
begin
 Psw:= InputBox('Input Box', '', '');
 If UpperCase(PSW) <> 'DODI1' then exit;
 ShowTimedMsg('Rebuilding properties: dollars, please wait',1000);
 BuildPropertiesFile;
 CheckVtComponents;
end;


procedure TMainForm.ActionList1Execute(Action: TBasicAction; var Handled: Boolean);
begin
 DataChanged:=True;
end;


procedure TMainForm.EkUDFList1Functions0Calculate(Sender: TObject;
  Args: TEkUDFArgs; ArgCount: Integer; UDFResult: TObject);
begin
  If UdfResult is  TPicture then
  begin
    //image1 uknkown
    With UDFResult as TPicture do
    begin
       Bitmap.Width:=Image1.Width;
       Bitmap.Height:=Image1.Height;
       Bitmap.Canvas.Draw(0,0,Image1.Picture.Graphic);
    end;
  end;

end;

procedure TMainForm.EmailTheReturnClick(Sender: TObject);
 Var i,j: integer; FormsToPrint :TstringList;
    Copies : string[1]; Template :string[30];
    s:String[1];RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 If ButtonInactive then exit;
 If AllowPrinting(RetNo)=False then exit;
 CalcAll(RetNo);
 ErrorCount := CountDiagnostics(RetNo);
 If MandatoryErrorCount+SeriousErrorCount>0 then
 begin
  If not WizardPanel.visible then AuditOpenBtnClick(Sender);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Not AllowedToFullPrint(RetNo) then begin PdfPrint:=False;exit;end;

 Calc(RetNo,'DIAGNO');
 If Ret[RetNo]^.CalcStatus = False then CalcAll(RetNo);
 UpdateAllDataIndicators(RetNo);
 Template := GetPrintTemplate;//(True);

 FastPrint:= GetFastPrintIndicator;
 If PdfPrint then FastPrint:=True;

 If Template ='' then begin PdfPrint:=False;exit;end;

 If Template = 'ALL' then
 begin
  Template := 'CRASET.D';
  PrintReturnForEmail(RetNo,Template);

  Template := 'CLINTSET.D';
  PrintReturnForEmail(RetNo,Template);

  Template := 'PREPSET.D';
  PrintReturnForEmail(RetNo,Template);
 end
 else If Template = 'C+P' then
 begin
  Template := 'CLINTSET.D';
  PrintReturnForEmail(RetNo,Template);

  Template := 'PREPSET.D';
  PrintReturnForEmail(RetNo,Template);
 end
 else
  PrintReturnForEmail(RetNo,Template);
end;

Procedure TMainForm.PrintReturnForEmail(RetNo:Integer;Template:String);
Var i,j: integer; FormsToPrint :TstringList;
    Copies : string[1];
    OldPrinterName:String;
begin
EXIT;
end;

procedure TMainForm.OpenItBtnClick(Sender: TObject);
Var i,ThisResult:Integer;Dir,FlName,Sin:String;
 AListItem:TListItem;
 RetNo:Integer;
 begin
  AListItem:=ListView1.ItemFocused;
  If AListItem = Nil then
  begin
   ShowTimedMsg('You must select a file first',1200);
   Exit;
  end;
  FlName := AllTrim(AListItem.SubItems[2]);
  Dir:=AllTrim(AListItem.SubItems[3]);
  Sin:=FlName;
  If FlName = '' then exit;
  If IsOkToOpenReturn(Dir,FlName,Sin) = False then Exit;

  If Not FileExists(Dir+'\'+FlName) then
  begin
   ShowMessage('File '+Dir+'\'+FlName+' does not exist');
   Exit;
  end;
  RetNo:=InitNewReturn;
  If RetNo=0 then exit;
  Screen.cursor:=crHourGlass;
  ThisResult := OpenReturn(RetNo,Dir,FlName,False);
  If ThisResult = 0 then
  begin
    LockWindowUpdate(MainForm.Handle);
   CountDiagnostics(RetNo);
   MainForm.LeftPanel.Visible:=True;
   FormName := 'T3';
   FormNo := GetFormNo(FormName);
   OpenForm(RetNo,FormNo,0);

   If Ret[RetNo]^.FrmHasData[GetFormNo('T5013SUM')] then
     OpenForm(RetNo,GetFormNo('T5013SUM'),0);
  
   OpenUsedForms(RetNo);

   MainForm.FormPaint(Application);

   Screen.Cursor:=crDefault;
  end //result
  else
  begin
    ShowOpenReturnFailure(ThisResult,Dir,FlName);
    exit;
  end;
end;

procedure TMainForm.EMailItBtnClick(Sender: TObject);
Var i:Integer;Dir,FlName:String; AListItem:TListItem;
SomeSubject,SomeRecipientEMail,SomeSenderEMail,SomeAttachment:String;
SomeText:String;
begin
  AListItem:=ListView1.ItemFocused;
  If AListItem = Nil then
  begin
   ShowTimedMsg('You must select a file first',1200);
   Exit;
  end;

 Dir:=AllTrim(AListItem.SubItems[3]);


 If AListItem = Nil then
 begin
   ShowTimedMsg('You must select a file first',1200);
   Exit;
 end;

 SomeList := TStringList.Create;
 SomeCaption := 'Double click on item 1, 2, 3 or 4';
 SomeList.Add('1. Email the tax return (raw data file) to your own EMail...');
 SomeList.Add('2. Email the tax return (raw data file) to tax return Reviewer...');
 SomeList.Add('3. Email the tax return (raw data file) to VisualTax support...');
 SomeList.Add('4. Email the tax return (raw data file) to any Email address...');
 SomeList.Add('________________________________________________________________');
 SomeList.Add('5. EMail the tax return (Printout only) to any Email address...');
 SomeList.Add('   See also: Print|Email current form...(after opening the return)');

 Application.CreateForm(TPoplist,PopList);
 PopList.ShowModal;
 SomeList.Free; PopList.Release;
 If SelectedString > '' then SelectedString:=LeftStr(SelectedString,1);
 If (SelectedString='1') or (SelectedString='2')
 or (SelectedString='3') or (SelectedString='4')
 or (SelectedString='5')
 then
  //ok
 else
 begin
  ShowTimedMsg('Invalid selection',1200);
  Exit;
 end;


 If (SelectedString ='1') or (SelectedString ='2') or (SelectedString ='3')
 or (SelectedString ='4') then
 begin
  If SelectedString='1' then  //yourself
  begin
     SomeRecipientEmail:=OptRec.Prp_Email; //youself
     If SomeRecipientEMail='' then
       ShowMessage('Preparer'+Chr(39)+'s Email not entered.'
         +Chr(13)+'You may enter it in Configure | General Options');
  end;

  If SelectedString='2' then  //to reviewer
  begin
     SomeRecipientEmail:=OptRec.Reviewer_EMail; //reviewer
     If SomeRecipientEMail='' then
       ShowMessage('Reviewer'+Chr(39)+'s Email not entered.'
         +Chr(13)+'You may enter it in Configure | General Options');
  end;

  If SelectedString='3' then SomeRecipientEmail:='visualtax@sympatico.ca';
  If SelectedString='4' then SomeRecipientEmail:='';

  FlName := AllTrim(AListItem.SubItems[2]);
  Dir:=AllTrim(AListItem.SubItems[3]);

  SomeSenderEmail:='';  //default? 
  SomeSubject:='A tax return';
  SomeAttachment:=Dir+'\'+FlName;
  SomeText:=Chr(13)
                +'The tax return is attached'
                +Chr(13)+' '
                +Chr(13)+' '
                +Chr(13)+'Thank you '
                +Chr(13)+' '
                +Chr(13)+OptRec.Prp_Name
                +Chr(13)+' ('+OptRec.Prp_Area+') '+OptRec.Prp_Tel;
   SendMapiMail(SomeSubject,SomeText,SomeAttachment,'','','',SomeRecipientEMail);
 end;
 If (SelectedString ='5') then
 begin
   OpenItBtnClick(Sender);
   EmailTheReturnClick(Sender);
 end;
end;

function TMainForm.SendMAPIMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
// scalabium.com/faq/dct0115.htm
var
  Message: TMapiMessage;
  lpSender, lpRecipient: TMapiRecipDesc;
  FileAttach: TMapiFileDesc;

  SM: TFNMapiSendMail;
  MAPIModule: HModule;
begin
  FillChar(Message, SizeOf(Message), 0);
  with Message do
  begin
    if (Subject <> '') then
      lpszSubject := PChar(''+Subject);

    if (Body <> '') then
      lpszNoteText := PChar(''+Body);

    if (SenderEmail <> '') then
    begin
      lpSender.ulRecipClass := MAPI_ORIG;
      if (SenderName = '') then
        lpSender.lpszName := PChar(''+SenderEMail)
      else
        lpSender.lpszName := PChar(''+SenderName);
      lpSender.lpszAddress := PChar(''+SenderEmail);
      lpSender.ulReserved := 0;
      lpSender.ulEIDSize := 0;
      lpSender.lpEntryID := nil;
      lpOriginator := @lpSender;
    end;

    if (RecipientEmail <> '') then
    begin
      lpRecipient.ulRecipClass := MAPI_TO;
      if (RecipientName = '') then
        lpRecipient.lpszName := PChar(''+RecipientEMail)
      else
        lpRecipient.lpszName := PChar(''+RecipientName);
      lpRecipient.lpszAddress := PChar(''+RecipientEmail);
      lpRecipient.ulReserved := 0;
      lpRecipient.ulEIDSize := 0;
      lpRecipient.lpEntryID := nil;
      nRecipCount := 1;
      lpRecips := @lpRecipient;
    end
    else
      lpRecips := nil;

    if (FileName = '') then
    begin
      nFileCount := 0;
      lpFiles := nil;
    end
    else
    begin
      FillChar(FileAttach, SizeOf(FileAttach), 0);
      FileAttach.nPosition := Cardinal($FFFFFFFF);
      FileAttach.lpszPathName := PChar(''+FileName);

      nFileCount := 1;
      lpFiles := @FileAttach;
    end;
  end;

  MAPIModule := LoadLibrary(PChar(MAPIDLL));
  if MAPIModule = 0 then
    Result := -1
  else
    try
      @SM := GetProcAddress(MAPIModule, 'MAPISendMail');
      if @SM <> nil then
      begin
        Result := SM(0, Application.Handle, Message, MAPI_DIALOG or MAPI_LOGON_UI, 0);
      end
      else
        Result := 1;
    finally
      FreeLibrary(MAPIModule);
    end;

  if Result <> 0 then
    MessageDlg('Error sending mail (' + IntToStr(Result) + ').', mtError,[mbOK], 0);
end;


procedure TMainForm.TUTORIALS1Click(Sender: TObject);
Var i:Integer;Url:String;TempList,TempList1:TStringList; //it loads the helpkeyw in a list
    PrevNo:String;
begin
  Urls.Items.Clear;
  TutorialsPanel.Visible:=True;
  TempList:=TStringList.Create;
  TempList1:=TStringList.Create;
  TempList:=GetFileList(AppDir+'\','T-*.htm');
  TempList.Sorted:=True;
  TutorialsPanel.Width:=Screen.Width div 7;
  If RetInMem =0 then
   TutorialsPanel.Height:=Screen.height * 2 div 3
  else
   ReduceTutorialHeight(Application);

  // insert dividers in between
  TempList1.Add(ExtractFileName(TempList[0]));
  PrevNo:=LeftStr(ExtractFileName(TempList[0]),4);  //i.e 'T-00';
  For i:=1 to TempList.Count-1 do
  begin
   If (LeftStr(ExtractFileName(TempList[i]),4) > PrevNo)
   and (RightStr(LeftStr(ExtractFileName(TempList[i]),4),1)='0') then
   begin
    PrevNo:=LeftStr(ExtractFileName(TempList[i]),4);
    TempList1.Add(' ');
   end;
   TempList1.Add(ExtractFileName(TempList[i]));
  end;
  TempList.Clear;
  TempList.Sorted:=False;
  For i:=0 to TempList1.Count-1 do TempList.Add(ChangeFileExt(TempList1[i],''));
  TempList1.Free;

  TutorialListBox.Items.Clear;
  For i:=0 to TempList.Count-1 do   //not from 0
    TutorialListBox.Items.Add(TempList[i]);

  TempList.Free;
  If TutorialListBox.Items.Count>0 then
  begin
    TutorialListBox.ItemIndex:=0;
    TutorialListBoxClick(Sender);
    TutHistoryIndex:=0;
  end;
end;

Function TMainForm.GetTutorialFileName:String;
begin
 Result:='';
 If TutorialListBox.ItemIndex <0 then exit;
 If TutorialListBox.Items.Count = 0 then exit;
 If AllTrim(TutorialListBox.Items[TutorialListBox.ItemIndex])>'' then
    Result:=AppDir+'\'+TutorialListBox.Items[TutorialListBox.ItemIndex]+'.htm';
end;

procedure TMainForm.CloseTutorialBtnClick(Sender: TObject);
begin
 TutorialsPanel.Visible:=False;
end;


procedure TMainForm.NextTutorialBtnClick(Sender: TObject);
begin
 If TutorialListBox.ItemIndex < TutorialListBox.Items.Count then
 begin
   TutorialListBox.ItemIndex:=TutorialListBox.ItemIndex+1;
   If AllTrim(TutorialListBox.Items[TutorialListBox.ItemIndex]) = '' then
     TutorialListBox.ItemIndex:=TutorialListBox.ItemIndex+1;
   TutorialListBoxClick(Sender);
 end;
end;

procedure TMainForm.PrevTutorialBtnClick(Sender: TObject);
begin
 If TutorialListBox.ItemIndex >0 then
 begin
   TutorialListBox.ItemIndex:=TutorialListBox.ItemIndex-1;
   If AllTrim(TutorialListBox.Items[TutorialListBox.ItemIndex]) = '' then
     TutorialListBox.ItemIndex:=TutorialListBox.ItemIndex-1;

   TutorialListBoxClick(Sender);
 end;

end;

procedure TMainForm.ReduceTutorialHeight(Sender: TObject);
begin
 TutorialsPanel.Height:=Screen.Height div 3;
end;

procedure TMainForm.ToolBoxSplitterCanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
 Accept:=True;
 If NewSize <70 then begin NewSize :=35;Accept := True;end;

end;

procedure TMainForm.DemonstrateTutorialBtnClick(Sender: TObject);
Var h : THandle;
begin

 If FileExists(TutorialScript) then
 Begin
  h := ShellExecute(MainForm.Handle, Nil, PChar(''+TutorialScript), Nil, Nil, SW_RESTORE);
  ReduceTutorialHeight(Sender);
 end;

 If h<32 then
   ShowMessage('File not found');
end;

procedure TMainForm.TutorialZoomInBtnClick(Sender: TObject);
begin
 TutorialsPanel.Height:=TutorialsPanel.Height+150;
end;

procedure TMainForm.TutorialZoomOutBtnClick(Sender: TObject);
begin
 If TutorialsPanel.Height <= 70 then exit;
 If TutorialsPanel.Height < 200 then
   TutorialsPanel.Height:=70
 else
  TutorialsPanel.Height:=TutorialsPanel.Height-150;
end;


procedure TMainForm.FindUrlAddress;
var
  Flags: OLEVariant;
begin
  Flags := 0;
  TutUpdateCombo := True;
  WebBrowser1.Navigate(WideString(Urls.Text), Flags, Flags, Flags, Flags);
end;

procedure TMainForm.WebBrowser1BeforeNavigate2(Sender: TObject;
   const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
   Headers: OleVariant; var Cancel: WordBool);
var
  NewIndex: Integer;
begin
  NewIndex := TutHistoryList.IndexOf(URL);
  if NewIndex = -1 then
  begin
    { Remove entries in HistoryList between last address and current address }
    if (TutHistoryIndex >= 0) and (TutHistoryIndex < TutHistoryList.Count - 1) then
      while TutHistoryList.Count > TutHistoryIndex do
        TutHistoryList.Delete(TutHistoryIndex);
    TutHistoryIndex := TutHistoryList.Add(URL);
  end
  else
    TutHistoryIndex := NewIndex;
  if TutUpdateCombo then
  begin
    TutUpdateCombo := False;
    NewIndex := URLs.Items.IndexOf(URL);
    if NewIndex = -1 then
      URLs.Items.Insert(0, URL)
    else
      URLs.Items.Move(NewIndex, 0);
  end;
  URLs.Text := URL;
end;


procedure TMainForm.HelpIndexBtnClick(Sender: TObject);
begin
 ShowHelp('TfHelp','HELP_CONTENTS');
end;

procedure TMainForm.Backupthetaxdata1Click(Sender: TObject);
Var i:Integer;LastBackUp,Dir:String;  TempList:TStringList; DoneOk:Boolean;
  ClickedOK: Boolean;  NewDir: string;
begin
 If OptRec.BackUpDir='' then
 begin
  ShowMessage('Please enter the backup directory in Configure | General Options | Data directories');
  Exit;
 end;
 Application.CreateForm(TBackUpFrm,BackUpFrm);
 BackUpFrm.ShowModal;
 BackUpFrm.Free;
end;

procedure TMainForm.Restoredatafrombackup1Click(Sender: TObject);
Var i:Integer;LastBackUp,Dir:String;  TempList:TStringList; DoneOk:Boolean;
  ClickedOK: Boolean;  NewDir: string;
begin
 If OptRec.BackUpDir='' then
 begin
  ShowMessage('Please enter the backup directory in Configure | General Options | Data directories');
  Exit;
 end;
 Application.CreateForm(TRestoreFrm,RestoreFrm);
 RestoreFrm.ShowModal;
 RestoreFrm.Free;
end;

procedure TMainForm.CopyAReturnBtnClick(Sender: TObject);
Var i,ThisResult:Integer;Dir,FlName,Sin:String;
 AListItem:TListItem;
 RetNo:Integer;
begin

  AListItem:=ListView1.ItemFocused;
  If AListItem = Nil then
  begin
   ShowTimedMsg('You must select a file first',1200);
   Exit;
  end;
  SomeFile:=AllTrim(AListItem.SubItems[2]);   //FlName
  SomeString:=AllTrim(AListItem.SubItems[3]); //from dir
  SomeCaption:=AllTrim(AListItem.Caption); //return name
  Application.CreateForm(TCopyMoveFrm,CopyMoveFrm);
  CopyMoveFrm.ShowModal;
  CopyMoveFrm.Free;
  If SomeResult=True then
    ShowMessage('Done')
  Else
   ShowMessage('Failed!');
  ShowMostRecentReturns; //updates the main menu
end;

procedure TMainForm.Label4Click(Sender: TObject);
begin
TUTORIALS1Click(Sender);
end;

procedure TMainForm.TutorialListBoxClick(Sender: TObject);
begin
 TutorialFile:=GetTutorialFileName;  //full path
 If TutorialFile='' then exit;
 If TutorialFile>'' then
  TutorialNameLbl.Caption := ChangeFileExt(ExtractFileName(TutorialFile),'')
 else
   TutorialNameLbl.Caption := '';
 TutorialScript:=ChangeFileExt(TutorialFile,'.EXE');
 If FileExists(TutorialScript) then
  DemonstrateTutorialBtn.Enabled := True
 else
  DemonstrateTutorialBtn.Enabled := False;

 Urls.Text:=TutorialFile;
 FindUrlAddress; //(TutorialFile);
end;

procedure TMainForm.ShowBarCodedata1Click(Sender: TObject);
Var FlNm:String;
begin
  Flnm :=Appdir+'\'+'BarCodeData.Txt';
  If FileExists(FlNm) then
  begin
   Try
   SomeList := TStringList.Create;
   SomeCaption := 'BarCode contents';
   SomeList.LoadFromFile(Flnm);
   Application.CreateForm(TPoplist,PopList);
   PopList.ShowModal;
  Finally
   SomeList.Clear;  //Free;
   PopList.Release;
  end;
 end;
end;


procedure TMainForm.ToolButton1Click(Sender: TObject);
begin
FileNewItemClick(Sender);
end;

procedure TMainForm.NewBtnToolBarClick(Sender: TObject);
begin
 FileNewItemClick(Sender);
end;

procedure TMainForm.OpenBtnToolBarClick(Sender: TObject);
begin
 FileOpenItemClick(Application);
end;

procedure TMainForm.CloseBtnToolBarClick(Sender: TObject);
begin
  FileCloseItemClick(Sender);
end;

procedure TMainForm.SaveBtnToolBarClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 FileSaveAsItemClick(Sender);
end;


Procedure TMainForm.GetFormsToPrint(RetNo:integer;Template:string;var FormsToPrint:TstringList;FrmType:String);
var i,j,FNo:integer;Copies :string[1];
    FName,FType,Inst:String;   //20140220
    TemplList,TemplForms,TemplCopies:TstringList;
begin
 If not FileExists(AppDir+'\'+Template) then
  begin
   ShowMessage('Print Template: '+AppDir+'\'+Template+
             chr(13)+'does not exist');
   exit;
  end;
  TemplList:= TStringList.Create;
  TemplCopies:= TStringList.Create;
  TemplForms:= TStringList.Create;
  {split: templist has nFFFFFF where n=copies and FFFF=form without instance}
  TemplList.LoadFromFile(AppDir+'\'+Template);
  For i:=0 to TemplList.Count-1 do
   begin
     TemplCopies.Add(LeftStr(TemplList[i],1));
     TemplForms.Add(MidStr(TemplList[i],2,10));
   end;

  For i:=0 to FList.Count-1 do {run thru all forms available}
  begin
   FRec := FList.Items[i];
   FNo :=Frec^.FormNo;
   //20140220
   FName:=Frec^.FormName;
   Inst:=Frec^.FormInst;
   FType:=Frec^.FormType;

   If (Ret[RetNo]^.FrmHasData[FNo])
    and (IsInList(FName,TemplForms)>-1) {and it is in template}
    and (FName <>'ALETTER') //and not ALETTER
    then
    begin
      If FrmType='T3' then
      begin
       If (FType = FrmType)
       or (FType = 'TP')
       or (FName = 'T3SUM') then FormsToPrint.Add(FName+Inst);
      end

      Else If FrmType='PA' then
      begin
       If (FType = FrmType) then
       begin
         //If ((FName = 'POTHINFO')
         If ((FName = 'T5013')
         or (FName = 'PS50'))    //20120324
         then
         // excluded - do not print here
         else
          FormsToPrint.Add(FName+Inst);
       end
      end

      else
      begin
      If FType = FrmType then FormsToPrint.Add(FName+Inst);
      end;
    end;
  end; //i
  {match and attach number of copies}
  For i:=0 to FormsToPrint.Count-1 do
  begin
   FormsToPrint[i]:=          {sssnFFFFFFFFF}
    GetPrintSequence(ExtractNonInstFormName(FormsToPrint[i]))
    + GetCopiesToPrint(FormsToPrint[i],TemplForms,TemplCopies)
    + FormsToPrint[i];
   //ShowMessage(FormsToPrint[i]);
  end;
  FormsToPrint.Sorted := True;
  //For i:=0 to FormsToPrint.Count-1 do ShowMessage(FormsToPrint[i]);
  TemplList.Free;
  TemplForms.Free;
  TemplCopies.Free;
end;


procedure TMainForm.SwapBtnClick(Sender: TObject);
begin
SwapReturns1Click(Sender);
end;

procedure TMainForm.QuickStarterGuide1Click(Sender: TObject);
begin
 ShowHelp('TFHelp','Quick_Starter_Guide');
end;

procedure TMainForm.PrintMailingLabelcurrentclient1Click(Sender: TObject);
Var Line1,Line2,Line3,Line4,Line5:String;
  LabelPosX, LabelPosY : Integer;
  TopMargin,LeftMargin,LabelHeight, LabelWidth, VertIncr, HorizLabelGap:Integer;
begin
end;

procedure TMainForm.QuickStartLblClick(Sender: TObject);
begin
QuickStarterGuide1Click(Sender);
end;

procedure TMainForm.Importfromlastyear1Click(Sender: TObject);
begin
Application.CreateForm(TImport,Import);
Import.ShowModal;
Import.Free;
end;


procedure TMainForm.T3coveringletter1Click(Sender: TObject);
begin
 If AllowPrinting(RetNo)=False then exit;
 CalcAll(RetNo);
 SomeLetterName:='T3Letter.RTF';
 OpenForm(GetCurrentRetNo,GetFormNo('ALETTER'),0);
end;

procedure TMainForm.TrustReturn1Click(Sender: TObject);
 Var i,j: integer; FormsToPrint :TstringList;
    Copies : string[1]; Template :string[30];
begin
 If ButtonInactive then exit;

 CalcAll(RetNo);
 If AllowPrinting(RetNo)=False then exit;
  //20150117
 If (GetT3StartYear(RetNo)< '2014-01-01') and (GetT3EndYear(RetNo)> '2013-12-31')
 and (Vl(FetchElm(RetNo,'S8',4))>0)
 then //straddle
 begin
    if MessageDlg(
   'Any of the non-eligible dividends in Line 1A of S8 received in 2013?'
    +Chr(13)+ '(If yes, please enter them on line 1B of S8)',
     mtWarning, [mbNo, mbYes], 0) = mrYes then
     Begin
      OpenForm(RetNo,GetFormNo('S8'),42);
      Exit;
     end;
    {
    If Vl(FetchElm(RetNo,'S8',42)) = 0 then
    ShowMessage('If you received any non-eligible dividends in 2013'
    +Chr(13)+ 'ensure you enter them on line 1A of S8');
    }
 end;

 Template:=GetPrintTemplate;
 PrintAReturn('T3',Template); //PrintAReturn('T3',Template);
end;

procedure TMainForm.T3SupplementarySlips1Click(Sender: TObject);
var
f:TPrintSelectedT3Slips;
FInst, FNonInst:String;
i, FNo:integer;
selectedT3SlipsList:TStringList;
begin
 RetNo:=GetCurrentRetNo;
 If AllowPrinting(RetNo)=False then exit;

 //20150117
 If (GetT3StartYear(RetNo)< '2014-01-01') and (GetT3EndYear(RetNo)> '2013-12-31')
 and (Vl(FetchElm(RetNo,'S8',4))>0)
 and (Vl(FetchElm(RetNo,'S8',42))=0)
 then //straddle
 begin
    if MessageDlg(
   'Any of the non-eligible dividends in Line 1A of S8 received in 2013?'
    +Chr(13)+ '(If yes, please enter them on line 1B of S8)',
     mtWarning, [mbNo, mbYes], 0) = mrYes then
     Begin
      OpenForm(RetNo,GetFormNo('S8'),42);
      Exit;
     end;
 end;

 FormName := 'T3SUPL#';
 FNonInst:= ExtractNonInstFormName(FormName);

 //add info
 SomeList := TStringList.Create;
 Somelist.Add(PaddR('Select all',10));
 for i :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[i];
  If FNonInst = Frec^.FormName then
  begin
   FNo:=Frec^.FormNo;
   FInst:=Frec^.FormInst;
   If Ret[RetNo]^.FrmHasData[FNo] then
   Begin
    If (LeftStr(FormName,7)='T3SUPL#')
    and (UpperCase(FetchElmFNo(RetNo,FNo,41)) = 'Y')   //20120416
    then
        Somelist.Add(PaddR(FNonInst+FInst,10)+' '+FetchElmFNo(RetNo,FNo,26))
   end; //found the form
  end;
 end;  //i

 CalcAll(RetNo);
 SomeCaption := 'T3 Slips Printing';

 Application.CreateForm(TPrintSelectedT3Slips,PrintSelectedT3Slips);
 PrintSelectedT3Slips.ShowModal;

 PrintSelectedT3Slips.Free;
end;

procedure TMainForm.Partnershipcoveringletter1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 CalcAll(RetNo);
 If AllowPrinting(RetNo)=False then exit;
 SomeLetterName:='T5013Letter.RTF';
 OpenForm(GetCurrentRetNo,GetFormNo('ALETTER'),0);
 //PrintRichLetter(RetNo,'Tt5013Letter.Rtf');
end;

procedure TMainForm.Partnershipreturn1Click(Sender: TObject);
Var i,j: integer; FormsToPrint :TstringList;
    Copies : string[1]; Template :string[30];

begin
 If ButtonInactive then exit;
 CalcAll(RetNo);
 If AllowPrinting(RetNo)=False then exit;

 Template:=GetPrintTemplate;
 PrintAReturn('PA',Template);
end;


procedure TMainForm.PrintAReturn(WhichFormType:String;Template:String);
Var i,j: integer; FormsToPrint :TstringList;
    Copies : string[1]; //Template :string[30];

begin
 If ButtonInactive then exit;
 LetterType := 'Cover';

 Screen.Cursor := crHourGlass;
 If Ret[RetNo]^.CalcStatus = False then CalcAll(RetNo);
 UpdateAllDataIndicators(RetNo);
 Screen.Cursor := crDefault;

 ErrorCount := CountDiagnostics(RetNo);
 If MandatoryErrorCount+SeriousErrorCount>0 then
 begin
  If not LeftPanel.visible then AuditOpenBtnClick(Application);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Template ='' then exit;

 FastPrint:= GetFastPrintIndicator;
 FormsToPrint := TstringList.Create;
 GetFormsToPrint(RetNo,Template,FormsToPrint,WhichFormType);
 If FormsToPrint.Count =0 then
    begin
    ShowMessage('Selected template has no forms for printing');
    FormsToPrint.Free;
    exit;
  end;

 If PrintDialogItem.Execute then
   PrintReturn(RetNo,FormsToPrint,Ret[RetNo]^.SourceDataDir,Ret[RetNo]^.SourceFlName);
 FormsToPrint.Free;
end;


procedure TMainForm.T5013Slips1Click(Sender: TObject);
Var SlipToPrint:String[5];CopyId:String;j,NumberOfSlips:Integer;
begin
  If ButtonInactive then exit;
  If AllowPrinting(RetNo)=False then exit;
  CalcAll(RetNo);
  Application.CreateForm(TPrT5013,PrT5013);
  PrT5013.ShowModal;
  PrT5013.Free;
end;

procedure TMainForm.AboutFillableForms1Click(Sender: TObject);
begin
ConnectToWeb('http://www.cra-arc.gc.ca/formspubs/hlp/bt_fllbl-eng.html');
end;

procedure TMainForm.FilableFormsWeb1Click(Sender: TObject);
begin
ConnectToWeb('http://www.cra-arc.gc.ca/menu/FIL-e.html');
end;

procedure TMainForm.T2202AEducationSlips1Click(Sender: TObject);
Var SlipsCnt:Integer;
begin
If ButtonInactive then exit;
If AllowPrinting(RetNo)=False then exit;
SlipsCnt:=CountT2202Slips(RetNo);
  If SlipsCnt <1 then
  begin
   ShowMessage(' There are No T2202 slips to print');
   exit;
  end;
  SomeList := TStringList.Create;
  SomeCaption := 'Print T2202A Slips';
  SomeList.Add('Student - Copy 1');
  SomeList.Add('Designated individual - Copy 2');
  SomeList.Add('Educational institution - Copy 3');
  //SomeList.Add('All Copies');
  Application.CreateForm(TPoplist,PopList);
  PopList.ShowModal;
  SomeList.Free; PopList.Release;

  If SelectedString = '' then exit;

  If LeftStr(SelectedString,7) = 'Student' then
     begin
      If not PrintDialogItem.Execute then exit;
      PrintStudentT2202(RetNo,1);  {print copy 1}
     end
  else If LeftStr(SelectedString,10) = 'Designated' then
    begin
     If not PrintDialogItem.Execute then exit;
     PrintDesignatedT2202(RetNo,2);  {print copy 2}
    end
  else if LeftStr(SelectedString,11) = 'Educational' then
   begin
     If not PrintDialogItem.Execute then exit;
     PrintEducationalT2202(RetNo,3);  //print copy 1 same as ccra
   end;

end;

procedure TMainForm.CharityReturn1Click(Sender: TObject);
Var Template:String;
begin
 If ButtonInactive then exit;
 If AllowPrinting(RetNo)=False then exit;
 Template:=GetPrintTemplate;
 PrintAReturn('CH',Template);
end;

procedure TMainForm.CCRAT3GuideT4013PDFformat1Click(Sender: TObject);
begin
  ShowPdf(AppDir,'T4013-15e.pdf');   //20150225
end;


procedure TMainForm.CCRAT5013PartnershipGuideT4068PDFformat1Click(
  Sender: TObject);
begin
 ShowPdf(AppDir,'T4068-15e.pdf');
end;

Procedure TMainForm.PrintStudentT2202(RetNo:Integer;CopyType:Integer);
Var i,j,WSFNo,FNo,DestFNo,Cnt,SlipsOnPage : integer; FromForm,DestForm:String[12];
    PrintedSw :Boolean;
begin
  Cnt:=CountT2202Slips(RetNo);
  DestForm := 'T2202S1';  //single page - re-used
  DestFNo := GetFormNo(DestForm);
  If DestFNo=0 then exit;
  If Ret[RetNo]^.Frm[DestFno].Count =0 then InitFormData(RetNo,DestFNo);
  For i:=0 to Cnt-1 do
  begin
     WsFNo:=GetFormNo('T2202WS#'+AllTrim(IntToStr(i+1)));
     If Ret[RetNo]^.FrmHasData[WsFNo] then
     begin
      For j:=1 to 52 do StoreElm(RetNo,DestFNo,j,''); //clear it  //20150307

      //copy data
      For j:=1 to 50 do StoreElm(RetNo,DestFNo,j,FetchElmFNo(RetNo,WsFNo,j));
      StoreElm(RetNo,DestFNo,51,FetchElmFNo(RetNo,WsFNo,58));
      StoreElm(RetNo,DestFNo,52,FetchElmFNo(RetNo,WsFNo,59));  //20150307
      PrintForm(RetNo,DestForm,1,'');
     end; //has data
  end; //end i
end;

Procedure TMainForm.PrintDesignatedT2202(RetNo:Integer;CopyType:Integer);
Var i,j,WSFNo,FNo,DestFNo,Cnt,SlipsOnPage : integer; FromForm,DestForm:String[12];
    PrintedSw :Boolean;
begin
  Cnt:=CountT2202Slips(RetNo);
  DestForm := 'T2202S2';  //single page - re-used
  DestFNo := GetFormNo(DestForm);
  If DestFNo=0 then exit;
  If Ret[RetNo]^.Frm[DestFno].Count =0 then InitFormData(RetNo,DestFNo);

  For i:=0 to Cnt-1 do
  begin
     WsFNo:=GetFormNo('T2202WS#'+AllTrim(IntToStr(i+1)));
     If Ret[RetNo]^.FrmHasData[WsFNo] then
     begin
      For j:=1 to 56 do StoreElm(RetNo,DestFNo,j,''); //clear it
      //copy data
      For j:=1 to 56 do StoreElm(RetNo,DestFNo,j,FetchElmFNo(RetNo,WsFNo,j));
      StoreElm(RetNo,DestFNo,57,FetchElmFNo(RetNo,WsFNo,57));  //20150207
      PrintForm(RetNo,DestForm,1,'');
     end; //has data
  end; //end i
end;

Procedure TMainForm.PrintEducationalT2202(RetNo:Integer;CopyType:Integer);
Var i,j,WSFNo,FNo,DestFNo,Cnt,SlipsOnPage : integer; FromForm,DestForm:String[12];
    PrintedSw :Boolean;
begin
  Cnt:=CountT2202Slips(RetNo);
  DestForm := 'T2202S3';  //single page - re-used
  DestFNo := GetFormNo(DestForm);
  If DestFNo=0 then exit;
  If Ret[RetNo]^.Frm[DestFno].Count =0 then InitFormData(RetNo,DestFNo);

  For j:=1 to 150 do StoreElm(RetNo,DestFNo,j,''); //clear it all

  i:=0;
  Repeat  //number of ws-slips
  //begin
     WsFNo:=GetFormNo('T2202WS#'+AllTrim(IntToStr(i+1)));
     If Ret[RetNo]^.FrmHasData[WsFNo] then
     begin
      //clear and copy  top skip
      For j:=1 to 50 do StoreElm(RetNo,DestFNo,j,FetchElmFNo(RetNo,WsFNo,j));

     end;

     WsFNo:=GetFormNo('T2202WS#'+AllTrim(IntToStr(i+2)));
     If Ret[RetNo]^.FrmHasData[WsFNo] then
     begin
      //clear and copy  top skip
      For j:=51 to 100 do StoreElm(RetNo,DestFNo,j,''); //clear it
      For j:=51 to 100 do StoreElm(RetNo,DestFNo,j,FetchElmFNo(RetNo,WsFNo,j-50));
     end;

     WsFNo:=GetFormNo('T2202WS#'+AllTrim(IntToStr(i+3)));
     If Ret[RetNo]^.FrmHasData[WsFNo] then
      begin
      //clear and copy  top skip
      For j:=101 to 150 do StoreElm(RetNo,DestFNo,j,''); //clear it
      For j:=101 to 150 do StoreElm(RetNo,DestFNo,j,FetchElmFNo(RetNo,WsFNo,j-100));
      end;
      PrintForm(RetNo,DestForm,1,'');
      For j:=1 to 150 do StoreElm(RetNo,DestFNo,j,''); //clear it all
    Inc(i,3);
  until i>Cnt-1;
end;

Procedure TmainForm.PrintT5013Slip(RetNo:Integer;SlipInstanceToPrint:String;CopyId:String);
Var FName:string;FNo:Integer;
begin
   FName:='T5013'+AllTrim(SlipInstanceToPrint);
   FNo:=GetFormNo(FName);
   If FNo =0 then exit;
   {copy 1}
   If (CopyId ='1') or (UpperCase(CopyId) = 'ALL') then
   begin
   StoreElm(RetNo,FNo,3,'For Tax Centre');
   StoreElm(RetNo,FNo,6,'1');
   StoreElm(RetNo,FNo,8,' ');
   StartPrintForm(Retno,FName,1);
   end;
   {copy 2}
   If (CopyId ='2') or (UpperCase(CopyId) = 'ALL') then
   begin
   StoreElm(RetNo,FNo,3,'Attach this slip to the income tax return');
   StoreElm(RetNo,FNo,6,'2');
   StoreElm(RetNo,FNo,8,' ');
   StartPrintForm(Retno,FName,1);
   end;
   {copy 3}
   If (CopyId ='3') or (UpperCase(CopyId) = 'ALL') then
   begin
   StoreElm(RetNo,FNo,3,'Keep this slip for your records');
   StoreElm(RetNo,FNo,6,'3'); //'For instructions, see the pages attached');
   StoreElm(RetNo,FNo,8,'');
   StartPrintForm(Retno,FName,1);
   //If GetT5013SlipType(RetNo)='T5013' then StartPrintForm(Retno,'T5013I',1);
   end;
   {copy 4}
   If (CopyId ='4') or (UpperCase(CopyId) = 'ALL') then
   begin
    StoreElm(RetNo,FNo,3,'For Partnership records');
    StoreElm(RetNo,FNo,6,'4');
    StartPrintForm(Retno,FName,1);
   end;
end;

(*
procedure TMainForm.PrintT5013PS50(RetNo:Integer);
Var FName:string;i,j,FNo:Integer;NumberOfPartners,ParnersWithDisposition:Integer;
PagePrinting:Integer; Cnt:Integer;
begin
 GenerateT5013PS50Forms(RetNo);
 NumberOfPartners:=CountT5013Partners(RetNo);
 ParnersWithDisposition:=CountT5013PartnersWithDisposition(RetNo);
 PagePrinting:=1;
 Printer.BeginDoc;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec^.FormName='PS50')
   and (Ret[RetNo]^.FrmHasData[Frec^.FormNo]) then
   Begin
    If PagePrinting=1 then
    begin
     FName:='PS50PG1';
     FNo:=GetFormNo(FName);
     StartPrintForm(Retno,FName,1);
    end
    Else
     begin
      //copy to bottom part
      FName:='PS50PG2';
      FNo:=GetFormNo(FName);
      StartPrintForm(Retno,FName,1);
      PagePrinting:=2;
     end
   end;  //has data
 end;
 Printer.EndDoc;
end;
*)

procedure TMainForm.PrintT5013PS50(RetNo:Integer);
Var i:Integer;OldPrinterName:String; FName,FInst:String; FNo:Integer;
NumPages:Integer;
begin
 RetNo:=GetCurrentRetNo;
 FastPrint := False;
 If ButtonInactive then exit;
 ErrorCount := CountDiagnostics(RetNo);
 //NumPages:=
 OldPrinterName:=GetDefaultPrinterName;
 If Not PrintDialogItem.Execute then exit;

 If CertificationMode=True then
 begin
   StoreElm(RetNo, GetFormNo('PS50PG1'),10,'1');
   StoreElm(RetNo, GetFormNo('PS50PG1'),110,'2');
   StoreElm(RetNo, GetFormNo('PS50PG1'),135,'1'); //pages
   StoreElm(RetNo, GetFormNo('PS50PG1'),136,'2');
   StartPrintForm(Retno,'PS50PG1',1);

   StoreElm(RetNo, GetFormNo('PS50PG2#1'),10,'3');
   StoreElm(RetNo, GetFormNo('PS50PG2#1'),110,'4');
   StoreElm(RetNo, GetFormNo('PS50PG2#1'),135,'2'); //pages
   StoreElm(RetNo, GetFormNo('PS50PG2#1'),136,'2');
   StartPrintForm(Retno,'PS50PG2#1',1);

  Exit;
 end;

 StartPrintForm(Retno,'PS50PG1',99);

 for i :=0 to (FList.Count - 1) do
 begin
    FRec := FList.Items[i];
    FName:=FRec^.FormName;
    FNo:=FRec^.FormNo;
    FInst:=FRec^.FormInst;
    If (FName ='PS50PG2') then
    begin
     If (Ret[RetNo]^.FrmHasData[FNo]) then //20120321
     begin
        StartPrintForm(Retno,FName+FInst,99);
     end;
    end;
 end;

end;

procedure TMainForm.ImportBtnClick(Sender: TObject);
begin
Importfromlastyear1Click(Sender);
end;

procedure TMainForm.RollOvrerLblClick(Sender: TObject);
begin
Importfromlastyear1Click(Sender);
end;

procedure TMainForm.NAICSCodes1Click(Sender: TObject);
begin
Application.CreateForm(TSIC,SIC);
SIC.ShowModal;
SIC.Free;
end;

procedure TMainForm.N2008TaxRatesanddraftlegislation1Click(
  Sender: TObject);
begin
  ShowPdf(AppDir,'2008-TaxRates.pdf');
end;

procedure TMainForm.CRAT5013SupplementaryGuideT406811Click(
  Sender: TObject);
Var h : Thandle;
   PgmPathS,PgmS,PgmParmsS:String;
   PgmPathZ : Array[0..254] of Char;
   PgmParmsZ : Array[0..254] of Char;
   PgmZ: Array[0..254] of Char;
begin
 PgmPathS := AppDir; StrPCopy(PgmPathZ,PgmPathS);
 PgmS:='T4068-1-10e.pdf'; StrPCopy(PgmZ,PgmS);
 PgmParmsS:=''; StrPCopy(PgmParmsZ,PgmParmsS);
 h := ShellExecute(MainForm.Handle, Nil, PgmZ, PgmParmsZ,PgmPathz, SW_RESTORE);
end;

procedure TMainForm.CurrentFormAllInstances1Click(Sender: TObject);
Var i:Integer;RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 FastPrint := False;
 If ButtonInactive then exit;
 ErrorCount := CountDiagnostics(RetNo);
 If MandatoryErrorCount+SeriousErrorCount>0 then
 begin
  If not WizardPanel.visible then AuditOpenBtnClick(Application);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Not AllowedToFormPrint(RetNo,FormName) then exit;

 If Not PrintDialogItem.Execute then exit;

 for i :=0 to (FList.Count - 1) do
 begin
    FRec := FList.Items[i];
    If Frec^.FormName =ExtractNonInstFormName(FormName) then
    begin
      If Ret[RetNo]^.FrmHasData[Frec^.FormNo] = true then   //20090422
       StartPrintForm(Retno,Frec^.FormName+Frec^.FormInst,99);
    end;
 end;

end;

procedure TMainForm.ContractPaymentsT50181Click(Sender: TObject);
begin
 ShowMessage('Please select a print option below the item you clicked');
 Exit;
end;

procedure TMainForm.T5018Summary1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
  If AllowPrinting(RetNo)=False then exit;
 OpenForm(RetNo,GetFormNo('T5018S'),0);
 PrintForm1Click(Sender);
end;

procedure TMainForm.T5018AllGovermentslips1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 If AllowPrinting(RetNo)=False then exit;
 OpenForm(RetNo,GetFormNo('T5018G#1'),0);
 CurrentFormAllInstances1Click(Sender);
end;

procedure TMainForm.T5018AllRecipientslips1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 If AllowPrinting(RetNo)=False then exit;
 OpenForm(RetNo,GetFormNo('T5018L#1'),0);
 CurrentFormAllInstances1Click(Sender);
end;

procedure TMainForm.CRACharityGuideT1033B1Click(Sender: TObject);

begin
 ShowPdf(AppDir,'t4033-15e.pdf');
end;


procedure TMainForm.NR4Slips1Click(Sender: TObject);
var
f:TPrintSelectedNR4Slips;
FInst, FNonInst:String;
i, FNo:integer;
selectedNR4SlipsList:TStringList;
begin
 RetNo:=GetCurrentRetNo;
 If AllowPrinting(RetNo)=False then exit;

 FormName := 'NR4DET#';
 FNonInst:= ExtractNonInstFormName(FormName);

 //add info
 SomeList := TStringList.Create;
 Somelist.Add(PaddR('Select all',10));
 for i :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[i];
  If FNonInst = Frec^.FormName then
  begin
   FNo:=Frec^.FormNo;
   FInst:=Frec^.FormInst;
   If Ret[RetNo]^.FrmHasData[FNo] then
   Begin
    If (LeftStr(FormName,7)='NR4DET#') then
        Somelist.Add(PaddR(FNonInst+FInst,10)+' '+FetchElmFNo(RetNo,FNo,16)) //nm
   end; //found the form
  end;
 end;  //i

 CalcAll(RetNo);
 SomeCaption := 'NR4 Slips Printing';

 Application.CreateForm(TPrintSelectedNR4Slips,PrintSelectedNR4Slips);
 PrintSelectedNR4Slips.ShowModal;

 PrintSelectedNR4Slips.Free;
end;

procedure TMainForm.INTERNETFiling1Click(Sender: TObject);
begin
 If LeftStr(LicenseLevel,8) <> 'TF Power' then
 begin
  ShowMessage('Internet Filing of slips is available only in the TF-Power version');
  Exit;
 end;
 If ButtonInactive then exit;
 If SeriousErrorCount>0 then
 begin
  ShowMessage('Please Fix Errors before Efiling');
  Exit;
 end;
 Application.CreateForm(TInternetFrm,InternetFrm);
 InternetFrm.ShowModal;
 InternetFrm.Free;
end;


procedure TMainForm.T5013PartnersS501Click(Sender: TObject);
Var NumberOfPartners,ParnersWithDisposition:Integer;
begin

 //GenerateT5013Slips(RetNo);         //20140325
 OpenForm(RetNo,GetFormNo('PS50#1'),0);   //20140325

 NumberOfPartners:=CountT5013Partners(RetNo);
 If CertificationMode =False then   //20120318
 Begin
  If NumberOfPartners=0 then
  begin
   ShowMessage('There are no partners to print');
   Exit;
  end;
 end;
 PrintT5013PS50(RetNo);
end;

procedure TMainForm.KnownIssues1Click(Sender: TObject);
begin
 ConnectToWeb('HTTP://www.VisualTax.com/TfKnownIssues.Asp');
end;

procedure TMainForm.KnownissuesLblClick(Sender: TObject);
begin
KnownIssues1Click(Sender);
end;

procedure TMainForm.PrintAllForms1Click(Sender: TObject);
Var I:integer; Psw:String; //20130325
begin
 If ButtonInactive then exit;
 Psw:= InputBox('Input Box', '', '');

 ShowFieldIdSw := True;

 If PrintDialogItem.Execute then
 begin
   for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      If Frec^.FormNo > 0 then
      begin
      If FRec^.FormInst < '#2' then
       {ShowMessage(Frec^.FormName+Frec^.FormInst);}
        PrintForm(GetCurrentRetNo,Frec^.FormName+Frec^.FormInst,99,'');
      end;
    end;
 end;
end;


Initialization
begin
RegisterClasses([TdbEdit,TImage,TShape,TSpeedButton,TEdit,TBitBtn,
    TPanel,TRichEdit,TLabel,TShape,TListBox,TFileListBox,TButton,
    TPageControl,TFrame,TMemo,TComboBox,TCheckBox,TLabel,TvtLabel,
    TvtScrollBox,TvtEdit,TvtShape,TFrame,{TAcbFrame,}TEKRTF,
    TFlagFrameCanada,TFlagFrameCan,
    TCanFlagFrame,  //20131225
    TFlagFrameAB,TFlagFrameBC,TFlagFrameMB,TFlagFrameNS,
    TFlagFrameNB,TFlagFrameNF,TFlagFrameNW,TFlagFrameNU,TFlagFrameON,
    TFlagFramePE,TFlagFrameSK,TFlagFrameYK,TwwDbRichEdit]);
 (*
 If FormatDateTime('yyyy/mm/dd',Date) > '2006/02/15' then
 begin
   ShowMessage('The pre-production program release has expired');
   Application.Terminate;
   exit;
  end;
 *)
 DecimalSeparator:='.';
 ScaleType:='ALL'; //'HORIZ';
 FastPrint := False;
 DataChanged:=False;
 BorderShape:=TShape.Create(Application);
 ReviewShape:=TShape.Create(Application);
 {scale}
 OptRec.FormZoom:=0;  //for delphi style scaling
 Sc:=1; ScChar :=1; ScChange :=0;
 RY :=0; {0:current year;Rate year = next year/prelim}
 AppDir := ExtractFilePath(Application.ExeName); {where the Exe is}
 AppDir := LeftStr(AppDir,Length(AppDir)-1); {Remove slash at end}
 Application.Icon.LoadFromFile(AppDir+'\'+'Visual.Ico');
 Application.HelpFile := AppDir;

 ServerMode:=False;

 If CertificationMode then ShowMessage('Certification Mode'
   +Chr(13)+'Open new then activate a non T3 form such as TX19');

  //PrevBorderType:=
  GetLicenseLevel;
  InitOptions;
  If OptRec.SkipLogin = False then
  begin
   Application.CreateForm(TLogon,Logon);
   Logon.ShowModal;
   Logon.Free;
  end;
  If (LeftStr(LicenseLevel,8) ='T1 Multi') and
   (ValidUser=False) then
    Application.Terminate;
   OptRec.Dir_Cur :=OptRec.Dir_Deflt;
   If (LeftStr(LicenseLevel,8) ='T1 Multi')
   {and (UserName <> 'ADMIN')}
   then
   begin
     OptRec.Dir_Cur :=User.Tax_Dir;
     OptRec.Dir_Deflt :=User.Tax_Dir;
    // OptRec.Ef_DataDir :=  User.EFile_Dir;
   end;


  InitFormsTable;  {all forms available}
  LoadEditBoxProperties;
  InitColorTable;  {all colors available}
  ReviewMarkColor :=clRed; //RGB(255,0,128);
  PrintShade      :=RGB(230,230,230);
  InitLists;       {Forms and return lists}
  InitSwitches;
  InitBmps;
  PrevFormName := 'T3';PrevRetNo:=1;PrevFormNo:=1;
  TutorialFile:='';
end;


end.

