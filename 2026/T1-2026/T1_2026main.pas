unit T1_2026main;
//merged 07-25
(* List of records see PrintTedFile*)

(* - Added combined CFR
// CHANGE MAINFORM based on parameters: http://www.swissdelphicenter.ch/torry/showcode.php?id=665
*)

// Pointer to a form:  Ptr:=@MainForm
(*
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

uses WinTypes,{$WARN UNIT_PLATFORM OFF}FileCtrl{$WARN UNIT_PLATFORM ON},WinProcs,SysUtils,Classes,Graphics,Forms,Controls,Menus,
  StdCtrls,Dialogs,Buttons,Messages,ExtCtrls,ShellApi,DbCtrls,Grids,Calendar,
  ColorGrd,Printers,ComObj,MAPI,ComCtrls,
  T1_2026AutoFillPrint,  //20160327
  Mask,StdActns,ActnList,EKRTF,ekbasereport,ekfunc,OleCtrls,SHDocVw,
  vtShape,vtLabel,vtChild, System.Actions, Vcl.ImgList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ToolWin,
  Vcl.Ribbon, Vcl.ActnMenus, Vcl.RibbonActnMenus, //Vcl.RibbonLunaStyleActnCtrls,
  VirtualUI_Mediator, fCaseDo, System.IOUtils, vtPDFPrinter, UIRibbon, UIRibbonCommands, T1_UIRibbonUnit;//20171031 igor //20190415 Igor

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;

type
  TRibbonApplicationMenuBar = class(Vcl.RibbonActnMenus.TRibbonApplicationMenuBar)
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  end;



  TGuiT1_2026 = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window: TMenuItem;
    N1: TMenuItem;
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
    ImportLastYear: TMenuItem;
    ClearCurrentform: TMenuItem;
    SelectForm: TMenuItem;
    SlipsItem: TMenuItem;
    Jacket: TMenuItem;
    Line1: TMenuItem;
    N6: TMenuItem;
    Diagnostics: TMenuItem;
    ComparativeSummary: TMenuItem;
    Minimizeform: TMenuItem;
    RestoreAll: TMenuItem;
    Options1: TMenuItem;
    N10: TMenuItem;
    Efile: TMenuItem;
    Coupling: TMenuItem;
    Print1: TMenuItem;
    Utilities: TMenuItem;
    Help2: TMenuItem;
    AboutItem: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    EFile2: TMenuItem;
    PrinterSetup: TMenuItem;
    PrintDialogItem: TPrintDialog;
    TaxSummary: TMenuItem;
    MinimizeReturn: TMenuItem;
    ColorDialog1: TColorDialog;
    OpenbyFileName1: TMenuItem;
    Calendar1: TMenuItem;
    ClientLetter1: TMenuItem;
    BatchPrinting1: TMenuItem;
    PrintForm1: TMenuItem;
    PrintCurrentReturn1: TMenuItem;
    CreateRTU1: TMenuItem;
    CreateDataDirectory1: TMenuItem;
    PrintTemplates1: TMenuItem;
    FeeSchedule1: TMenuItem;
    MailingLabels1: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    DataDictionary1: TMenuItem;
    EFErrorsMasterList1: TMenuItem;
    N23: TMenuItem;
    SICCodes1: TMenuItem;
    FinancialInstitutions1: TMenuItem;
    StartCoupling1: TMenuItem;
    EndCoupling1: TMenuItem;
    N25: TMenuItem;
    EmergencyToolKit1: TMenuItem;
    FixFormSpecifications1: TMenuItem;
    FixClientDataBaseData1: TMenuItem;
    ShowCellNumbers1: TMenuItem;
    ChangeDataDirectory1: TMenuItem;
    SwapReturns1: TMenuItem;
    N26: TMenuItem;
    Switchforms1: TMenuItem;
    N27: TMenuItem;
    N7: TMenuItem;
    CashReports1: TMenuItem;
    Tips1: TMenuItem;
    CopyForm1: TMenuItem;
    N18: TMenuItem;
    DataBaseAnalyser1: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    UserSetUp1: TMenuItem;
    Calculator1: TMenuItem;
    VisualTaxDemoGuide1: TMenuItem;
    Allforms1: TMenuItem;
    SystemInformation1: TMenuItem;
    N33: TMenuItem;
    RebuildtheClientDataBase1: TMenuItem;
    MergeDataBases1: TMenuItem;
    FileViewerEditor1: TMenuItem;
    CurrentPage1: TMenuItem;
    OptimizeFamilyprocessing1: TMenuItem;
    SelfEmployment1: TMenuItem;
    N24: TMenuItem;
    Openselectively1: TMenuItem;
    ListEFileRejectedReturns1: TMenuItem;
    ClientListings1: TMenuItem;
    CopyBackUp1: TMenuItem;
    RecalculateandsaveALLtaxreturns1: TMenuItem;
    OnestepEFile1: TMenuItem;
    PreSelForms1: TMenuItem;
    PrintEFilereportsACKACXTSRERR1: TMenuItem;
    PrintReturnBalances1: TMenuItem;
    DeveloperOnly1: TMenuItem;
    NISAcodes1: TMenuItem;
    UpdateT1MasterfromRTURTX1: TMenuItem;
    UpdateT1MasterfromACKACXfiles1: TMenuItem;
    YourLatestRelease: TMenuItem;
    Upgrade1: TMenuItem;
    YTDCashreports1: TMenuItem;
    N20: TMenuItem;
    YTDdirectorySetup1: TMenuItem;
    N21: TMenuItem;
    Submitdailycashreport1: TMenuItem;
    CopyDailyCashReport1: TMenuItem;
    InternetWebSite1: TMenuItem;
    ClientStatistics1: TMenuItem;
    AlphabeticalFormsIndex1: TMenuItem;
    Presentation1: TMenuItem;
    Zoomin1: TMenuItem;
    Zoomout1: TMenuItem;
    Review1: TMenuItem;
    Color1: TMenuItem;
    Recalc1: TMenuItem;
    SlipSummary1: TMenuItem;
    ToolBar: TPanel;
    Efilebox: TGroupBox;
    EFRejectBtn: TSpeedButton;
    EFileBtn: TSpeedButton;
    EfileSetupBtn: TSpeedButton; //20170307 Igor
    NavigationBox: TGroupBox;
    FormsBtn: TSpeedButton;
    SlipsBtn: TSpeedButton;
    T1Btn: TSpeedButton;
    ABCBtn: TSpeedButton;
    SwapFrm: TSpeedButton;
    PresSelBtn: TSpeedButton;
    PreselNextBtn: TSpeedButton;
    PreSelPrvBtn: TSpeedButton;
    ReviewBox: TGroupBox;
    TSumBtn: TSpeedButton;
    AuditOpenBtn: TSpeedButton;
    ReviewBtn: TSpeedButton;
    YSumBtn: TSpeedButton;
    SSumBtn: TSpeedButton;
    RecalcBtn: TSpeedButton;
    CouplingBox: TGroupBox;
    CoupleBtn: TSpeedButton;
    SwapBtn: TSpeedButton;
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
    ExportData1: TMenuItem;
    Timer: TTimer;
    N4: TMenuItem;
   // ShowTreeview1: TMenuItem;
    ReIndextheClientDataBase1: TMenuItem;
    CreateSENDRTU1: TMenuItem;
    EfileOnLine: TMenuItem;
    EOL: TMenuItem;
    RestructuretheClientsDataBase1: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    NetFileForindividuals1: TMenuItem;
    ExchageRatesAverage1: TMenuItem;
    InvoiceAdjustments1: TMenuItem;
    OpenbyFileNameSIN1: TMenuItem;
    N28: TMenuItem;
    Checkupdate1: TMenuItem;
    ClearCurrentPage: TMenuItem;
    N32: TMenuItem;
    MOSTRECENTFILES1: TMenuItem;
    RollForwardfromgreenPoint1: TMenuItem;
    RollForwardfromCanTaxT120011: TMenuItem;
    CharityOrganizations1: TMenuItem;
    SuperEntry1: TMenuItem;
    Employers1: TMenuItem;
    DoctorsHospitalsPharmacies1: TMenuItem;
    MedicalExpenseDescriptions1: TMenuItem;
    FirstNames1: TMenuItem;
    Cities1: TMenuItem;
    SuperEntryLastyearsformsselection1: TMenuItem;
    T1GuideCCRA1: TMenuItem;
    OpenPreviousYearsT11: TMenuItem;
    N35: TMenuItem;
    CompanyLogo1: TMenuItem;
    ImportConfiguration1: TMenuItem;
    N36: TMenuItem;
    ExportConfiguration1: TMenuItem;
    Findaline1: TMenuItem;
    LinesBtn: TSpeedButton;
    EOLPLUS1: TMenuItem;
    SetupEOL1: TMenuItem;
    SetupEOLPlus1: TMenuItem;
    UsefulLinks: TMenuItem;
    SetReturnPassword1: TMenuItem;
    RemoveReturnPassword1: TMenuItem;
    N40: TMenuItem;
    N41: TMenuItem;
    N43: TMenuItem;
    N38: TMenuItem;
    SaveALLopenedreturns1: TMenuItem;
    SaveandCloseAllopenedreturns1: TMenuItem;
    N44: TMenuItem;
    Familysetup1: TMenuItem;
    N46: TMenuItem;
    TakeShapshotforT1Adj1: TMenuItem;
    CreatetheT1ADJform1: TMenuItem;
    N48: TMenuItem;
    LineByLinehelp1: TMenuItem;
    BusinessSummary1: TMenuItem;
    RentalSummary1: TMenuItem;
    N50: TMenuItem;
    EFileHelpDesk1: TMenuItem;
    CCArates1: TMenuItem;
    FSumBtn: TSpeedButton;
    FamilySummary1: TMenuItem;
    N51: TMenuItem;
    Checkupdates1: TMenuItem;
    N52: TMenuItem;
    VisualTaxontheWEB1: TMenuItem;
    GUIDES1: TMenuItem;
    VisualTaxForum1: TMenuItem;
    Frequentlyaskedquestions1: TMenuItem;
    CICA1: TMenuItem;
    TaxResearch1: TMenuItem;
    N15: TMenuItem;
    CICAHelpbyline1: TMenuItem;
    CICAReferencematerials1: TMenuItem;
    CICA2: TMenuItem;
    TrEngineLoad: TMenuItem;
    TrGuide1: TMenuItem;
    DefinetheTRfolder1: TMenuItem;
    N39: TMenuItem;
    N45: TMenuItem;
    TheWindows: TMenuItem;
    StatusBarBtn: TSpeedButton;
    HelpBtn: TSpeedButton;
    TipsBtn: TSpeedButton;
    CloseBlackBoxBtn: TBitBtn;
    FormsBlackBoxBtn: TBitBtn;
    CloseallreturnsWITHOUTSaving1: TMenuItem;
    ShowLastYearForm1: TMenuItem;
    RSumBtn: TSpeedButton;
    Label14: TLabel;
    AboutPanel: TPanel;
    NewReturnLbl: TLabel;
    OpenReturnLbl: TLabel;
    MostRecentLbl: TLabel;
    RollOvrerLbl: TLabel;
    WhatsNewLbl: TLabel;
    HelpLbl: TLabel;
    FaQLbl: TLabel;
    TRLbl: TLabel;
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
    N2: TMenuItem;
    SpeedButton2: TSpeedButton;
    AppLabel: TLabel;
    WWWLbl: TLabel;
    Label5: TLabel;
    Image2: TImage;
    TradeMarkLbl: TLabel;
    N3: TMenuItem;
    PrepareDistr1: TMenuItem;
    LicLevel1: TMenuItem;
    N57: TMenuItem;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    ZoomPercentLbl: TLabel;
    vtShape2: TvtShape;
    vtShape6: TvtShape;
    EkRTF1: TEkRTF;
    EkUDFList1: TEkUDFList;
    GoToaFormSection1: TMenuItem;
    Image1: TImage;
    OpenItBtn: TBitBtn;
    EMailItBtn: TBitBtn;
    N12: TMenuItem;
    TUTORIALS1: TMenuItem;
    N19: TMenuItem;
    Backupthetaxdata1: TMenuItem;
    Restoredatafrombackup1: TMenuItem;
    N34: TMenuItem;
    CopyAReturnBtn: TBitBtn;
    TutorialsLbl: TLabel;
    ShowBarCodedata1: TMenuItem;
    N47: TMenuItem;
    FinancialInstitutionsforT1DD1: TMenuItem;
    T7DRA1: TMenuItem;
    N49: TMenuItem;
    ForeignExchangeconverter1: TMenuItem;
    T4044GuideEmploymentExpenses1: TMenuItem;
    OTHERGUIDES1: TMenuItem;
    CurrentFormallinstances1: TMenuItem;
    SignffWarnings1: TMenuItem;
    N22: TMenuItem;
    TaxPlanner1: TMenuItem;
    CreateNewPlan1: TMenuItem;
    OpenExistingTaxPlan1: TMenuItem;
    NextYearsRates: TMenuItem;
    N11: TMenuItem;
    OptimizeBtn: TSpeedButton;
    SpecialGpT11: TMenuItem;
    ACBPortfolioSummary1: TMenuItem;
    CopyreturnsfromT1Draft1: TMenuItem;
    SaveDialog: TSaveDialog;
    SaveprintoutofreturninPDFformatinClientDocumentsfolder1: TMenuItem;
    VTSCAN1: TMenuItem;
    N56: TMenuItem;
    EFmemofieldadditionalfields1: TMenuItem;
    EfileErrorMessagesPDF1: TMenuItem;
    NetFilenow1: TMenuItem;
    SetUpNetFile1: TMenuItem;
    Findbaspasswords1: TMenuItem;
    FileMgtBox: TGroupBox;
    OpenBtn: TSpeedButton;
    SaveBtn: TSpeedButton;
    ExitBtn: TSpeedButton;
    NewBtn: TSpeedButton;
    CloseBtn: TSpeedButton;
    ImportBtn: TSpeedButton;
    ShowFList1: TMenuItem;
    T2125YearlySummary1: TMenuItem;
    CheckALLforms1: TMenuItem;
    T1013Efile1: TMenuItem;
    PrintAllFormsBtn: TMenuItem;
    T1013EfileErrors1: TMenuItem;
    PrintSequence1: TMenuItem;
    T1EfileBtn: TMenuItem;
    ShowXMLcontentsbeforetransmission1: TMenuItem;
    N58: TMenuItem;
    ResetEfilestatusToWIP: TMenuItem;
    BuildXMLAllFiles1: TMenuItem;
    PrintCondencedT11: TMenuItem;
    N59: TMenuItem;
    ClientPHOTOID1: TMenuItem;
    EFILERSMANUAL1: TMenuItem;
    MassEmail1: TMenuItem;
    Panel8: TPanel;
    AppUpdateDateLbl: TLabel;
    Panel7: TPanel;
    LicenseLevelLbl: TLabel;
    Panel3: TPanel;
    AppReleaseLbl: TLabel;
    Label6: TLabel;
    KnownIssues1: TMenuItem;
    Label8: TLabel;
    QuickFindBtn: TEdit;
    Label10: TLabel;
    Image3: TImage;
    BirthDateClients1: TMenuItem;
    HistoryofEfilesubmissions1: TMenuItem;
    HistoryofBatchAcknowledgements1: TMenuItem;
    FormPopup: TPopupMenu;
    RefreshALLdependants1: TMenuItem;
    RefreshALLdependants2: TMenuItem;
    SortMedical1: TMenuItem;
    SortMedical2: TMenuItem;
    SortACBBydate1: TMenuItem;
    SortACBBydate2: TMenuItem;
    ShowLastYearsdata1: TMenuItem;
    ShowLastYearsdata2: TMenuItem;
    NextStatement1: TMenuItem;
    PreviousStatement1: TMenuItem;
    PreviousStatement2: TMenuItem;
    SignOffWarnings1: TMenuItem;
    SignOffWarnings2: TMenuItem;
    Help1: TMenuItem;
    Help3: TMenuItem;
    TRTaxResearch1: TMenuItem;
    TRTaxResearch2: TMenuItem;
    PrintPage1: TMenuItem;
    PrintForm2: TMenuItem;
    PrintAllInstancesofcurrentform1: TMenuItem;
    EMailForm1: TMenuItem;
    N61: TMenuItem;
    ClearCurrentPage1: TMenuItem;
    ClearCurrentForm1: TMenuItem;
    N62: TMenuItem;
    CopyMoveFormdata1: TMenuItem;
    FormSections1: TMenuItem;
    N63: TMenuItem;
    Notepad1: TMenuItem;
    Notepadwithamounts1: TMenuItem;
    PrivateNotepad1: TMenuItem;
    N64: TMenuItem;
    TaxPlannerUsenextyearrates1: TMenuItem;
    N65: TMenuItem;
    TileReturns1: TMenuItem;
    TileHorizontally1: TMenuItem;
    TileVertically1: TMenuItem;
    FieldPopup: TPopupMenu;
    SortACBBydate3: TMenuItem;
    SortACBBydate4: TMenuItem;
    RefreshALLdependantsaddressesfromparent1: TMenuItem;
    RefreshALLdependantsaddressesfromparent2: TMenuItem;
    Refreshaddressfromotherspouse1: TMenuItem;
    Refreshaddressfromotherspouse2: TMenuItem;
    ShowLastYearsdata3: TMenuItem;
    ShowLastYearsdata4: TMenuItem;
    Showwhatthevaluewaslastyear1: TMenuItem;
    Showwhatthevaluewaslastyear2: TMenuItem;
    SignOffWarningerrors1: TMenuItem;
    SignOffWarningerrors2: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Cut2: TMenuItem;
    AddRow1: TMenuItem;
    DeleteRow1: TMenuItem;
    DeleteRow2: TMenuItem;
    AddtoDataDictionaryforclientletters1: TMenuItem;
    AddtoDataDictionaryforclientletters2: TMenuItem;
    Override1: TMenuItem;
    SetResetReviewMark1: TMenuItem;
    SetResetReviewMark2: TMenuItem;
    AttachNote1: TMenuItem;
    AttachAddingTape1: TMenuItem;
    AttachAddingTape2: TMenuItem;
    Help4: TMenuItem;
    TRVisualTaxResearchWebbased1: TMenuItem;
    CICAWebbasedsubscriptionrequired1: TMenuItem;
    WindowArrange1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    ChangetaxmoduleT1T2TFFP1: TMenuItem;
    N37: TMenuItem;
    AutoFill: TMenuItem; //20160126 Igor
    RequestTDDBtn: TMenuItem; //20160126 Igor
    AutofillfromCRABtn: TMenuItem;//20160126 Igor
    ShowAutofillStatusBtn: TMenuItem; //20160126 Igor
    AuditTrailHistoryOfAutoFill1: TMenuItem; //20160216 Igor
    LogintoCRAforAutoFill1: TMenuItem; //20160216 Igor
    ReviewAutoFilldatareceivedfromCRA1: TMenuItem; //20160216 Igor
    N55: TMenuItem; //20160216 Igor
    mniT1135Efile: TMenuItem; //20160216 Igor
    HistoryofT1013submissions1: TMenuItem; //20160216 Igor
    HistoryofT1135Submissions1: TMenuItem; //20160216 Igor
    EfileAppendicesExclusionsandotherinfo1: TMenuItem; //20160216 Igor
    CDEClientDataEnquireShowdata1: TMenuItem; //20160216 Igor
    IntroductionbyCRA1: TMenuItem; //20160216 Igor
    HelpByVisualTax1: TMenuItem;
    ImportdatafromProductionDataBases1: TMenuItem;
    ResetpasswordfromclientDB1: TMenuItem;
    buttonAvailableWidth: TSpeedButton;
    PrintableAutofilldata1: TMenuItem;
    Convertoptionsfromoldversion1: TMenuItem;
    UploadtoDropBox1: TMenuItem; //20160126 Igor
    ResetpasswordwithReturn1: TMenuItem;
    PADPreauthorizedDebit1: TMenuItem;
    Exporttofile1: TMenuItem;//20161028 Igor
    ReviewfilesinPermanentClientDocumentsfolder1: TMenuItem;
    ReFILEthisreturn1: TMenuItem;
    HisttoryOfReFILEDreturns1: TMenuItem;
    N66: TMenuItem;
    AlertsNotifications1: TMenuItem;
    RepairReturn1: TMenuItem; //20170130 Igor
    RollOverfromTaxCycle1: TMenuItem;//20170428 igor
    Buildreport1: TMenuItem;
    N67: TMenuItem; //20170909 Igor
    amT1: TActionManager;
    il16: TImageList;
    il32: TImageList;
    actChangeTaxModule: TAction;
    actNewReturn: TAction;
    actOpenReturn: TAction;
    actOpenReturnSelectively: TAction;
    actOpenReturnBySIN: TAction;
    actOpenReturnByFileName: TAction;
    actOpenPreviousYears: TAction;
    actSaveReturnAs: TAction;
    actSaveALLopenedReturns: TAction;
    actSaveAndCloseAllOpenedReturns: TAction;
    actUploadToDropBox: TAction;
    actCloseReturn: TAction;
    actCloseAllReturnsWITHOUTSaving: TAction;
    actImportLastYear: TAction;
    actRollForwardFromCanTax: TAction;
    actRollForwardFromProfile: TAction;
    actRollOverFromTaxCycle: TAction;
    actImportDataFromProductionDataBase: TAction;
    actConvertOptionsFromOldVersion: TAction;
    actLockReturn: TAction;
    actUnlockReturn: TAction;
    actDataBaseAnalyser: TAction;
    actClientStatistics: TAction;
    actCreateDataDirectory: TAction;
    actChangeDataDirectory: TAction;
    actSetReturnPassword: TAction;
    actRemoveReturnPassword: TAction;
    actExportToFile: TAction;
    actExit: TAction;
    actShowLastYear: TAction;
    actRequestTDD: TAction;
    actAutofillfromCRA: TAction;
    actPrintableAutofilldata: TAction;
    actCDEClientDataEnquireShowdata: TAction;
    actShowAutofillStatus: TAction;
    actAuditTrailHistoryOfAutoFill: TAction;
    actIntroductionbyCRA: TAction;
    actHelpByVisualTax: TAction;
    actNOA: TAction;
    actTakeShapshotforT1Adj: TAction;
    actCreatetheT1ADJform: TAction;
    actSelectForm: TAction;
    actGoToaFormSection: TAction;
    actFindaline: TAction;
    actAlphabeticalFormsIndex: TAction;
    actPreSelForms: TAction;
    actSuperEntryLastyearsformsselection: TAction;
    actSlipsItem: TAction;
    actSelfEmployment: TAction;
    actJacket: TAction;
    actLine: TAction;
    actClearCurrentPage: TAction;
    actClearCurrentform: TAction;
    actCopyForm: TAction;
    actSwitchforms: TAction;
    actSignffWarnings: TAction;
    actCurrentPage: TAction;
    actCurrentFormallinstances: TAction;
    actPrintForm: TAction;
    actClientPHOTOID: TAction;
    actPrintCondencedT1: TAction;
    actPrintCurrentReturn: TAction;
    actBatchPrinting: TAction;
    actShowBarCodedata: TAction;
    actT7DRA: TAction;
    actSaveprintoutofreturninPDFformatinClientDocumentsfolder: TAction;
    actReviewfilesinClientDocumentFolder: TAction;
    actReviewfilesinPermanentClientDocumentsfolder: TAction;
    actPrintAuditWizardDiagnostics: TAction;
    actMassEmail: TAction;
    actBirthDateClients: TAction;
    actClientListings: TAction;
    actMailingLabels: TAction;
    actPrintReturnBalances: TAction;
    actPrinterSetup: TAction;
    actAllforms: TAction;
    actCashReports: TAction;
    actCopyDailyCashReport: TAction;
    actSubmitdailycashreport: TAction;
    actYTDCashreports: TAction;
    actBuildreport: TAction;
    actVTSCAN: TAction;
    actOptions2: TAction;
    actDefinetheTRfolder: TAction;
    actPrintTemplates: TAction;
    actPrintSequence: TAction;
    actFeeSchedule: TAction;
    actSuperEntry: TAction;
    actFinancialInstitutions: TAction;
    actDoctorsHospitalsPharmacies: TAction;
    actCharityOrganizations: TAction;
    actMedicalExpenseDescriptions: TAction;
    actEmployers: TAction;
    actFirstNames: TAction;
    actCities: TAction;
    actCompanyLogo: TAction;
    actClientLetter: TAction;
    actDataDictionary: TAction;
    actExportConfiguration: TAction;
    actImportConfiguration: TAction;
    actUserSetUp: TAction;
    actYTDdirectorySetup: TAction;
    actInvoiceAdjustments: TAction;
    actShowCellNumbers: TAction;
    actFamilysetup: TAction;
    actStartCoupling: TAction;
    actEndCoupling: TAction;
    actFamilySummary: TAction;
    actSwapReturns: TAction;
    actOptimizeFamilyprocessing: TAction;
    actEOL: TAction;
    actEOLPLUS: TAction;
    actT1013Efile: TAction;
    actmniT1135Efile: TAction;
    actPADPreauthorizedDebit: TAction;
    actReFILEthisreturn: TAction;
    actSENDtransaction: TAction;
    actSetupEOL: TAction;
    actSetupEOLPlus: TAction;
    actHistoryofEfilesubmissions: TAction;
    actHistoryofT1013submissions: TAction;
    actHistoryofT1135Submissions: TAction;
    actHisttoryOfReFILEDreturns: TAction;
    actHistoryofBatchAcknowledgements: TAction;
    actEfileAppendicesExclusionsandotherinfo: TAction;
    actEFILERSMANUAL: TAction;
    actEfileErrorMessagesPDF: TAction;
    actWebServiceErrorMessages: TAction;
    actT1013EfileErrors: TAction;
    actSENDErrors: TAction;
    actListEFileRejectedReturns: TAction;
    actEFmemofieldadditionalfields: TAction;
    actT1Efile: TAction;
    actShowXMLcontentsbeforetransmission: TAction;
    actCreateRTU: TAction;
    actCreateSENDRTU: TAction;
    actOnestepEFile: TAction;
    actEFErrorsMasterList: TAction;
    actUpdateT1MasterfromRTURTX: TAction;
    actUpdateT1MasterfromACKACXfiles: TAction;
    actPrintEFilereportsACKACXTSRERR: TAction;
    actEFile2: TAction;
    actNetFilenow: TAction;
    actSetUpNetFile: TAction;
    actRecalc: TAction;
    actDiagnostics: TAction;
    actTaxSummary: TAction;
    actComparativeSummary: TAction;
    actSlipSummary: TAction;
    actBusinessSummary: TAction;
    actRentalSummary: TAction;
    actACBPortfolioSummary: TAction;
    actT2125YearlySummary: TAction;
    actCreateNewPlan: TAction;
    actNextYearsRates: TAction;
    actOpenExistingTaxPlan: TAction;
    actShowTreeview: TAction;
    actZoomin: TAction;
    actZoomout: TAction;
    actToolbandswitch: TAction;
    actColor: TAction;
    actTheWindows: TAction;
    actSetdisplayresolution: TAction;
    actForeignExchangeconverter: TAction;
    actCalculator: TAction;
    actCalendar: TAction;
    actBackupthetaxdata: TAction;
    actRestoredatafrombackup: TAction;
    actCopyBackUp: TAction;
    actMergeDataBases: TAction;
    actRebuildtheClientDataBase: TAction;
    actRecalculateandsaveALLtaxreturns: TAction;
    actFileViewerEditor: TAction;
    actReIndextheClientDataBase: TAction;
    actFixClientDataBaseData: TAction;
    actRestructuretheClientsDataBase: TAction;
    actFixFormSpecifications: TAction;
    actUpgrade: TAction;
    actPrepareDistr: TAction;
    actLicLevel: TAction;
    actSpecialGpT1: TAction;
    actShowFList: TAction;
    actCheckALLforms: TAction;
    actPrintAllForms: TAction;
    actResetEfilestatusToWIP: TAction;
    actBuildXMLAllFiles: TAction;
    actResetpasswordfromclientDB: TAction;
    actResetpasswordwithReturn: TAction;
    actFindbaspasswords: TAction;
    actRepairReturn: TAction;
    actCopyreturnsfromT1Draft: TAction;
    actWindowTileItem: TAction;
    actWindowCascadeItem: TAction;
    actWindowArrangeItem: TAction;
    actMinimizeform: TAction;
    actMinimizeReturn: TAction;
    actMinimizeAll: TAction;
    actRestoreReturn: TAction;
    actRestoreAll: TAction;
    actTUTORIALS: TAction;
    actAlertsNotifications: TAction;
    actYourLatestRelease: TAction;
    actVisualTaxDemoGuide: TAction;
    actLineByLinehelp: TAction;
    actTips: TAction;
    actEFileHelpDesk: TAction;
    actKnownIssues: TAction;
    actCheckupdates: TAction;
    actCheckupdate: TAction;
    actFrequentlyaskedquestions: TAction;
    actVisualTaxForum: TAction;
    actInternetWebSite: TAction;
    actUsefulLinks: TAction;
    actTrEngineLoad: TAction;
    actTrGuide: TAction;
    actCICAHelpbyline: TAction;
    actCICA: TAction;
    actCICAReferencematerials: TAction;
    actT1GuideCCRA: TAction;
    actOTHERGUIDES: TAction;
    actT4044GuideEmploymentExpenses: TAction;
    actSICCodes: TAction;
    actExchageRatesAverage: TAction;
    actNISAcodes: TAction;
    actCCArates: TAction;
    actFinancialInstitutionsforT1DD: TAction;
    actSystemInformation: TAction;
    actAboutItem: TAction;
    actNextPage: TAction;
    actPreviousPage: TAction;
    actFindForm: TAction;
    actReview: TAction;
    actAvailableWidth: TAction;
    actHelpCurrentForm: TAction;
    CoolBar1: TCoolBar;
    edtSearchForm: TEdit;
    tbFileManagement: TToolBar;
    tbtnNewReturn: TToolButton;
    tbtnOpenReturn: TToolButton;
    tbtnSaveReturnAs: TToolButton;
    tbtnImportLastYear: TToolButton;
    tbtnCloseReturn: TToolButton;
    tbtnExit: TToolButton;
    tbEFile: TToolBar;
    tbtnEOL: TToolButton;
    tbtnEOLPLUS: TToolButton;
    tbtnListEFileRejectedReturns: TToolButton;
    tbFormsNavigation: TToolBar;
    tbtnSelectForm: TToolButton;
    tbtnFindaline: TToolButton;
    tbtnAlphabeticalFormsIndex: TToolButton;
    tbtnPreSelForms: TToolButton;
    tbtnSlipsItem: TToolButton;
    tbtnJacket: TToolButton;
    tbtnSwitchforms: TToolButton;
    tbtnNextPage: TToolButton;
    tbtnPreviousPage: TToolButton;
    tbtnFindForm: TToolButton;
    sep1: TToolButton;
    sep2: TToolButton;
    sep3: TToolButton;
    tbReview: TToolBar;
    tbtnRecalc: TToolButton;
    tbtnDiagnostics: TToolButton;
    sep4: TToolButton;
    tbtnBusinessSummary: TToolButton;
    tbtnRentalSummary: TToolButton;
    tbtnTaxSummary: TToolButton;
    tbtnFamilySummary: TToolButton;
    tbtnSlipSummary: TToolButton;
    tbtnComparativeSummary: TToolButton;
    tbtnReview: TToolButton;
    tbCoupling: TToolBar;
    tbtnStartCoupling: TToolButton;
    tbtnSwapReturns: TToolButton;
    tbtnOptimizeFamilyprocessing: TToolButton;
    tbDesctop: TToolBar;
    tbtnZoomin: TToolButton;
    tbtnZoomout: TToolButton;
    tbtnAvailableWidth: TToolButton;
    ToolButton4: TToolButton;
    lblZoom: TLabel;
    tbHelp: TToolBar;
    tbtnHelpCurrentForm: TToolButton;
    tbtnTips: TToolButton;
    CoolBar2: TCoolBar;
    tbFileManagement2: TToolBar;
    tbtnNewReturn2: TToolButton;
    tbtnOpenReturn2: TToolButton;
    tbtnSaveReturnAs2: TToolButton;
    tbtnImportLastYear2: TToolButton;
    tbtnCloseReturn2: TToolButton;
    tbtnExit2: TToolButton;
    tbEFile2: TToolBar;
    tbtnEOL2: TToolButton;
    tbtnEOLPLUS2: TToolButton;
    tbtnListEFileRejectedReturns2: TToolButton;
    tbFormsNavigation2: TToolBar;
    tbtnSelectForm2: TToolButton;
    tbtnFindaline2: TToolButton;
    tbtnAlphabeticalFormsIndex2: TToolButton;
    tbtnPreSelForms2: TToolButton;
    tbtnSlipsItem2: TToolButton;
    tbtnJacket2: TToolButton;
    tbtnSwitchforms2: TToolButton;
    tbtnNextPage2: TToolButton;
    tbtnPreviousPage2: TToolButton;
    edtSearchForm2: TEdit;
    tbtnFindForm2: TToolButton;
    tbReview2: TToolBar;
    tbtnRecalc2: TToolButton;
    tbtnDiagnostics2: TToolButton;
    tbtnReview2: TToolButton;
    tbtnBusinessSummary2: TToolButton;
    tbtnRentalSummary2: TToolButton;
    tbtnTaxSummary2: TToolButton;
    tbtnFamilySummary2: TToolButton;
    tbtnSlipSummary2: TToolButton;
    tbtnComparativeSummary2: TToolButton;
    tbCoupling2: TToolBar;
    tbtnStartCoupling2: TToolButton;
    tbtnSwapReturns2: TToolButton;
    tbtnOptimizeFamilyprocessing2: TToolButton;
    tbDesctop2: TToolBar;
    tbtnZoomout2: TToolButton;
    lblZoom2: TLabel;
    tbtnZoomin2: TToolButton;
    tbtnAvailableWidth2: TToolButton;
    tbHelp2: TToolBar;
    tbtnHelpCurrentForm2: TToolButton;
    tbtnTips2: TToolButton;
    actDeveloperOnly: TAction;
    actDataExtract: TAction;
    N68: TMenuItem;
    DataExtract1: TMenuItem;
    actForCloud: TAction;
    N69: TMenuItem;
    actChangeSkin: TAction;
    ChangeSkinBtn: TSpeedButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    AutofillandNoa: TMenuItem;
    CreateNAICS1: TMenuItem;
    //20180206 Igor <<<
    //20181130 Igor >>>
    btnUpload: TBitBtn;
    btnDownload: TBitBtn;
    //20181130 Igor <<<
    //20190213 Igor >>>
    btnUploadWithoutOpen: TBitBtn;
    btnDownloadAll: TBitBtn;
    //20190415 Igor >>>
    MainUIRibbon: TUIRibbon;
    actOpenReturnButton: TAction;
    actSaveReturnAsButton: TAction;
    actCloseReturnButton: TAction;
    actSelectFormButton: TAction;
    ListView2: TListView; //20190507 IGOR?
    //20190415 Igor <<<
    //20190213 Igor <<<
    //20190522 Igor >>>
    actRebuilDatabaseCloud: TAction;
    RebuildtheClientDataBaseCloud1: TMenuItem;
    //20191129 Igor >>>
    actCreateClientsFolders: TAction;
    actCopyClientsFolders: TAction;
    actScan: TAction;
    //20191129 Igor <<<
    CreateClientDocumentFolders1: TMenuItem;
    ScanClientDocuments1: TMenuItem;
    CopyfilestoClientFolders1: TMenuItem;
    UsePrintWatermark1: TMenuItem;
    Action1: TAction;
    N71: TMenuItem;
    N72: TMenuItem;
    OpentClientDocumentsfolder1: TMenuItem;
    N73: TMenuItem;
    eSignaturesandCOVID191: TMenuItem;
    N74: TMenuItem;
    ElectronicSignature1: TMenuItem;
    Submit1: TMenuItem;
    N77: TMenuItem;
    N78: TMenuItem;
    RequestESignatureConfirmation1: TMenuItem;
    //20201208 Igor >>>
    vtCourier_Office: TMenuItem;
    mmVirtualTaxOffice: TMenuItem;
    VTO_Login: TMenuItem;
    EditTaxPayerProfile_Payer: TMenuItem;
    EditTaxOfficeProfile_Office: TMenuItem;
    VTO_LogOut_Both: TMenuItem;
    N5: TMenuItem;
    VTO_ChangePassword_Both: TMenuItem;
    MassRegistration_Office: TMenuItem;
    vtCourier_Payer: TMenuItem;
    SingleRegistration_Office: TMenuItem; //20201216 Igor
    //20201222 Igor >>>
    VirtualTaxOfficeBox: TGroupBox;
    btnVTO_Open: TSpeedButton;
    btnVTO_Close: TSpeedButton;
    btnVTO_Forms: TSpeedButton;
    btnVTO_vtCourier: TSpeedButton;
    actvtCourier: TAction;
    actSendSignature: TAction;
    btnVTO_Sign: TSpeedButton;
    btnVTO_Profile: TSpeedButton;
    actProfile: TAction;
    ColourSettings_Office: TMenuItem;
    btnVTO_Save: TSpeedButton;
    btnVTO_Other: TSpeedButton;
    actOther: TAction;
    VirtualOfficeIntro1: TMenuItem;
    //20210115 Igor >>>
    N42: TMenuItem;
    Help_Office: TMenuItem;
    FAQ_Office: TMenuItem;
    actHelpVTO: TAction;
    actFaqVTO: TAction;
    btnVTODocumentsFolder: TSpeedButton;
    btnVTOHelp: TSpeedButton;
    btnVTOFaq: TSpeedButton;
    actDocumentsFolder: TAction;
    pmDocumentsFolder: TPopupMenu;
    OpenDocumentsFolder1: TMenuItem;
    ChangeDocumentfolder1: TMenuItem;
    SignPDFwithESignature1: TMenuItem;
    pmSign: TPopupMenu;
    Signforms1: TMenuItem;
    SignPDFdocument1: TMenuItem;
    //20210201 Igor >>>
    btnVTO_VTScan: TSpeedButton;
    actVtScanVTO: TAction;
    SpeedButton1: TSpeedButton;
    actStartVirtualMeetingVTO: TAction;
    StartVirtualMeeting_Office: TMenuItem;
    N75: TMenuItem;
    MassEmailtoTaxPreparers1: TMenuItem;
    btnVTO_Exit: TSpeedButton;
    MassEmailtoVirtualClients_Office: TMenuItem;//20210210 Igor
    CreatePDFforsigning_Office: TMenuItem;//20210318 Igor
    //20210330 Igor >>>
    N76: TMenuItem;
    N79: TMenuItem;
    N80: TMenuItem;
    N81: TMenuItem;
    RequestSignature_Office: TMenuItem;
    AccepttheClientssignature_Office: TMenuItem;
    SendTaxReturnPDFprintoutstoClient_Office: TMenuItem;
    SendtheActualTaxReturn_Office: TMenuItem;
    VirtualClientsandAppointments_Office: TMenuItem;
    ServiceRequests_Office: TMenuItem;
    N82: TMenuItem;
    N83: TMenuItem;
    N84: TMenuItem;
    N85: TMenuItem;
    actArchives: TAction;
    Archives1: TMenuItem;
    N86: TMenuItem;
    DeveloperMode1: TMenuItem;
    //20210330 Igor <<<
    //20210201 Igor <<<
    //20210115 Igor <<<
    //20201224 Igor
    //20201222 Igor <<<
    //20201208 Igor <<<
    //20201019 Igor
    //20191216 Igor <<<
  //  Function ChangeAckToXmlExtension(flName:String):String; //20120117
    Procedure PrintAllForms(RetNo:Integer);
//v2013 added
    procedure WebServiceErrorMessages1Click(Sender: TObject);
    procedure QuickFindBtnExit(Sender: TObject);
    procedure QuickFindBtnKeyPress(Sender: TObject; var Key: Char);
    procedure BirthDateClients1Click(Sender: TObject);
    procedure HistoryofEfilesubmissions1Click(Sender: TObject);
    procedure HistoryofBatchAcknowledgements1Click(Sender: TObject);
    procedure TutorialsLblClick(Sender: TObject);
  //not for use
    procedure T1EfileBtnClick(Sender: TObject);
   // procedure FindUrlAddress(Url:String);
    function SendMAPIMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
    Procedure PrintReturnForEMail(RetNo:Integer;Template:String);
   // procedure PrintFormForEmail(RetNo:Integer;FormName:String);
    Procedure GetGraphic;
    procedure ChangeRates;
    //function IsReturnOpen(const AFormName: TForm; const AMDIChildName : string): Boolean;
    procedure AuditOpenBtnClick(Sender: TObject);
    procedure SetHorScrollBarInListBox(ListBox: TListBox; MaxWidth: Integer);
    procedure WidePanelBtnClick(Sender: TObject);
    procedure StartPrintForm(Retno:integer;FormName:String;WhichPage:integer);
   // procedure GetFormSections(FName:String;Var SomeList:TstringList; Var TopList:TstringList);
    Procedure UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
    procedure FormCreate(Sender: TObject);
    Procedure OpenViaExplorer;
    procedure FileNewItemClick(Sender: TObject);
    procedure FileCloseItemClick(Sender: TObject);
    procedure FileOpenItemClick(Sender: TObject);
    procedure FileExitItemClick(Sender: TObject);
    procedure FileSaveItemClick(Sender: TObject);
    procedure FileSaveAsItemClick(Sender: TObject);
    procedure SelectFormClick(Sender: TObject);
    procedure Operational1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ChangeLicenseLevel;
    procedure SlipsItemClick(Sender: TObject);
    procedure PrinterSetupClick(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    procedure SlipsBtnClick(Sender: TObject);
    procedure PrintRBtnClick(Sender: TObject);
    procedure ToolBarBtnClick(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure AboutItemClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
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
    procedure BatchPrinting1Click(Sender: TObject);
    procedure CopyReturns1Click(Sender: TObject);
    procedure MoveReturns1Click(Sender: TObject);
    procedure DeleteReturns1Click(Sender: TObject);
    procedure PrintFBtnClick(Sender: TObject);
    procedure CreateRTU1Click(Sender: TObject);
    procedure CreateDataDirectory1Click(Sender: TObject);
    procedure PrintTemplates1Click(Sender: TObject);
    procedure FeeSchedule1Click(Sender: TObject);
    procedure OpenSpecificTypes1Click(Sender: TObject);
    procedure Fonts1Click(Sender: TObject);
    procedure OverrideText1Click(Sender: TObject);
    procedure RemovecurrentreturnOverridesClick(Sender: TObject);
    procedure RemovecurrentfieldoverrideClick(Sender: TObject);
 //   procedure SetCurrentFieldOverrideClick(Sender: TObject);
    procedure Lockamountoncurrentfield1Click(Sender: TObject);
    procedure EFRejectBtnClick(Sender: TObject);
    procedure CouplBtnClick(Sender: TObject);
    procedure OverrideBtnClick(Sender: TObject);
    procedure DataDictionary1Click(Sender: TObject);
    procedure EFErrorsMasterList1Click(Sender: TObject);
    procedure SICCodes1Click(Sender: TObject);
    procedure FinancialInstitutions1Click(Sender: TObject);
    procedure DiagnosticsClick(Sender: TObject);
    {procedure AuditBtnClick(Sender: TObject);}
    procedure SamplesBtnClick(Sender: TObject);
    procedure T1BtnClick(Sender: TObject);
    procedure PrintCurrentReturn1Click(Sender: TObject);
    procedure CoupleBtnClick(Sender: TObject);
    procedure AddinstanceofForm1Click(Sender: TObject);
    procedure Line1Click(Sender: TObject);
    procedure JacketClick(Sender: TObject);
    procedure PersonaldataClick(Sender: TObject);
    procedure TaxSummaryClick(Sender: TObject);
    procedure SampleReturns1Click(Sender: TObject);
    procedure FixTextoncurrentForm1Click(Sender: TObject);
    procedure FixDataDictionary1Click(Sender: TObject);
    procedure FixFormSpecifications1Click(Sender: TObject);
    procedure FixClientDataBaseData1Click(Sender: TObject);
    procedure ShowCellNumbers1Click(Sender: TObject);
   // procedure DataDirectories1Click(Sender: TObject);
//    procedure EFile2Click(Sender: TObject);
    procedure ChangeDataDirectory1Click(Sender: TObject);
    procedure StartCoupling1Click(Sender: TObject);
    procedure EndCoupling1Click(Sender: TObject);
    procedure LoadSpousalReturnfromdatabaseCreate1Click(Sender: TObject);
    procedure SwapBtnClick(Sender: TObject);
    procedure SwapReturns1Click(Sender: TObject);
    procedure Switchforms1Click(Sender: TObject);
    procedure SwapFrmClick(Sender: TObject);
    procedure FormsBtnClick(Sender: TObject);
    procedure UserSetUp1Click(Sender: TObject);
    procedure CashReports1Click(Sender: TObject);
    procedure TipsBtnClick(Sender: TObject);
    procedure Tips1Click(Sender: TObject);
    procedure EFErrorBtnClick(Sender: TObject);
    procedure CopyForm1Click(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure RSumBtnClick(Sender: TObject);
    procedure DataBaseAnalyser1Click(Sender: TObject);
    procedure SchedBtnClick(Sender: TObject);
    procedure ImportLastYearClick(Sender: TObject);
    procedure ShowWarnings;
    procedure FrmSumBtnClick(Sender: TObject);
    procedure TSumBtnClick(Sender: TObject);
    procedure EFileBtnClick(Sender: TObject);
    procedure UserSetUp2Click(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure Calculator1Click(Sender: TObject);
    procedure Appointments2Click(Sender: TObject);
    procedure TransmitRTU1Click(Sender: TObject);
    procedure Contents2Click(Sender: TObject);
    procedure SearchForHelpOnClick(Sender: TObject);
    procedure VisualTaxDemoGuide1Click(Sender: TObject);
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
    procedure BusnBtnClick(Sender: TObject);
    {procedure RemoveUnusedWindows1Click(Sender: TObject);}
    procedure PrintManager1Click(Sender: TObject);
    procedure ClientLetters1Click(Sender: TObject);
    procedure TaxReturnCoveringletter1Click(Sender: TObject);
    procedure MailingLabels1Click(Sender: TObject);
    procedure ShowOverridesClick(Sender: TObject);
    procedure ListReviewmarks1Click(Sender: TObject);
    procedure SystemInformation1Click(Sender: TObject);
    procedure RebuildtheClientDataBase1Click(Sender: TObject);
    procedure MergeDataBases1Click(Sender: TObject);
    procedure FileViewerEditor1Click(Sender: TObject);
    procedure CurrentPage1Click(Sender: TObject);
    procedure PlanNextYearClick(Sender: TObject);
    procedure YSumBtnClick(Sender: TObject);
    procedure SelfEmployment1Click(Sender: TObject);
    procedure ComparativeSummaryClick(Sender: TObject);
    procedure OptimizeFamilyprocessing1Click(Sender: TObject);
    //procedure ViewLastYearClick(Sender: TObject);
    //Procedure PaintFirstReturn;
    procedure CplBtnClick(Sender: TObject);
    procedure MinTaxBtnClick(Sender: TObject);
    procedure Openselectively1Click(Sender: TObject);
    procedure ListEFileRejectedReturns1Click(Sender: TObject);
    procedure SSumBtnClick(Sender: TObject);
    procedure ClientListings1Click(Sender: TObject);
    procedure CopyBackUp1Click(Sender: TObject);
    procedure RecalcBtnClick(Sender: TObject);
   //procedure Importfromothertaxsoftware1Click(Sender: TObject);
    procedure RecalculateandsaveALLtaxreturns1Click(Sender: TObject);
    procedure ListBalances1Click(Sender: TObject);
    procedure PresSelBtnClick(Sender: TObject);
    procedure PreSelForms1Click(Sender: TObject);
    procedure PreselNextBtnClick(Sender: TObject);
    procedure PreSelPrvBtnClick(Sender: TObject);
    procedure PrintEFilereportsACKACXTSRERR1Click(Sender: TObject);
    procedure OnestepEFile1Click(Sender: TObject);
    procedure PrintReturnBalances1Click(Sender: TObject);
    procedure NISAcodes1Click(Sender: TObject);
   // procedure ONESTEPModemCommunications1Click(Sender: TObject);
    {Function  FeatureAllowed:Boolean;}
    procedure UpdateT1MasterfromRTURTX1Click(Sender: TObject);
    procedure UpdateT1MasterfromACKACXfiles1Click(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure YourLatestReleaseClick(Sender: TObject);

    procedure ZoomBtnPlusClick(Sender: TObject);
    procedure ZoomBtnMinusClick(Sender: TObject);
   // procedure RefreshOpenedForms(RetNo:Integer);
    //procedure AuditCloseBtnClick(Sender: TObject);

    procedure Image2Click(Sender: TObject);
    procedure Upgrade1Click(Sender: TObject);
   // procedure ReviseLook;
    procedure AuditListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure YTDCashreports1Click(Sender: TObject);
    procedure YTDdirectorySetup1Click(Sender: TObject);
    Procedure ShowMultiOfficeMsg;
    procedure Submitdailycashreport1Click(Sender: TObject);
    procedure CopyDailyCashReport1Click(Sender: TObject);
    Function  EditBeforeSave(RetNo:Integer):Boolean;
    Function  EditBeforePrint(RetNo:Integer):Boolean;  //20260315
    procedure InternetWebSite1Click(Sender: TObject);
    procedure WWWLblClick(Sender: TObject);
    procedure EfileSetupBtnClick(Sender: TObject);
    procedure WorldButtonClick(Sender: TObject);
  //  Procedure OpenNonModalForm(RetNo:Integer;FName:String);
   // Procedure PrintRichLetter(RetNo:Integer;LetterName:String);
    procedure ClientStatistics1Click(Sender: TObject);
    procedure AlphabeticalFormsIndex1Click(Sender: TObject);
    procedure Zoomin1Click(Sender: TObject);
    procedure Zoomout1Click(Sender: TObject);
    procedure Toolbandswitch1Click(Sender: TObject);
    procedure Color1Click(Sender: TObject);
    procedure Recalc1Click(Sender: TObject);
    procedure SlipSummary1Click(Sender: TObject);
    procedure ExportData1Click(Sender: TObject);

    procedure OtherOptions1Click(Sender: TObject);
   // procedure ShowTreeview1Click(Sender: TObject);
    procedure ReIndextheClientDataBase1Click(Sender: TObject);
   // procedure TreeViewBtnClick(Sender: TObject);
    procedure CreateSENDRTU1Click(Sender: TObject);
    //procedure ExplorerBtnClick(Sender: TObject);
    procedure RestructuretheClientsDataBase1Click(Sender: TObject);
    //procedure StartEOL;
    procedure StartEOLP;
    //procedure CloseExplorerBtnClick(Sender: TObject);
    //procedure ImportfromTaxByte1Click(Sender: TObject);
    procedure ExchageRatesAverage1Click(Sender: TObject);
    procedure InvoiceAdjustments1Click(Sender: TObject);
    procedure OpenbyFileNameSIN1Click(Sender: TObject);
    //procedure AgentSetup1Click(Sender: TObject);
    procedure ListofEfileErrors1Click(Sender: TObject);
    procedure Checkupdate1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure CheckUpdatesLblClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure ClearCurrentformClick(Sender: TObject);
    procedure ClearCurrentPageClick(Sender: TObject);
    procedure MOSTRECENTFILES1Click(Sender: TObject);
    procedure ShowMostRecentReturns;
    procedure RollForwardfromgreenPoint1Click(Sender: TObject);
    procedure RollForwardfromCanTaxT120011Click(Sender: TObject);
    Procedure PutFrmDictOnFrmGrid(FrmNm:String;FileFound:Boolean);
    procedure CharityOrganizations1Click(Sender: TObject);
    procedure SuperEntry1Click(Sender: TObject);
    procedure Employers1Click(Sender: TObject);
    procedure DoctorsHospitalsPharmacies1Click(Sender: TObject);
    procedure MedicalExpenseDescriptions1Click(Sender: TObject);
    procedure FirstNames1Click(Sender: TObject);
    procedure Cities1Click(Sender: TObject);
    procedure CloseSuperBtnClick(Sender: TObject);
    procedure SuperEntryLastyearsformsselection1Click(Sender: TObject);
    Procedure ArrangeSuperAuditPanel;
    procedure SuperAuditUpBtnClick(Sender: TObject);
    procedure SuperAuditDnBtnClick(Sender: TObject);
   // Procedure RefreshSuperAudit(RetNo:Integer);
    Procedure PutLastYearValueOnFrmGrid(Frmnm:String;FileFound:Boolean;LnNo:Integer;Description:String;Value:String);
    procedure T1GuideCCRA1Click(Sender: TObject);
    //procedure SuperReviewBoxClick(Sender: TObject);
    procedure OpenPreviousYearsT11Click(Sender: TObject);
    //procedure SuperReviewsetup1Click(Sender: TObject);
    procedure CompanyLogo1Click(Sender: TObject);
    procedure ImportConfiguration1Click(Sender: TObject);
    procedure ExportConfiguration1Click(Sender: TObject);
    procedure Findaline1Click(Sender: TObject);
    procedure SENDErrors1Click(Sender: TObject);
    procedure LinesBtnClick(Sender: TObject);
    //procedure EFILEONLINEPLUS1Click(Sender: TObject);
    procedure EOLClick(Sender: TObject);
    //procedure EOLPClick(Sender: TObject);
    procedure EOLPLUS1Click(Sender: TObject);
    //procedure SetupEOL1Click(Sender: TObject);
    //procedure SetupEOLPlus1Click(Sender: TObject);
    procedure UsefulLinksClick(Sender: TObject);
    procedure SetReturnPassword1Click(Sender: TObject);
    procedure RemoveReturnPassword1Click(Sender: TObject);
    procedure SetProgramPassword1Click(Sender: TObject);
    procedure RemoveProgramPassword1Click(Sender: TObject);
 //   procedure ProcessAcknowledgements1Click(Sender: TObject);
    procedure PrintAuditBtnClick(Sender: TObject);
    procedure PrintAuditWizardDiagnostics1Click(Sender: TObject);
  //  procedure EmailCurrentFormClick(Sender: TObject);
  //  procedure Processtransmittedfiles1Click(Sender: TObject);
    procedure PrintAcknowledgementreport1Click(Sender: TObject);
//    procedure DisplayAcknowledgementfile1Click(Sender: TObject);
//    procedure PrintTEDfile1Click(Sender: TObject);
    procedure SaveALLopenedreturns1Click(Sender: TObject);
    procedure SaveandCloseAllopenedreturns1Click(Sender: TObject);
//    procedure TestBlBoxClick(Sender: TObject);
//    procedure CloseBlackBoxBtnClick(Sender: TObject);
//    procedure FormsBlackBoxBtnClick(Sender: TObject);
    procedure Familysetup1Click(Sender: TObject);
    procedure SENDtransaction1Click(Sender: TObject);
    procedure Provincialnews1Click(Sender: TObject);
    procedure TakeShapshotforT1Adj1Click(Sender: TObject);
    procedure CreatetheT1ADJform1Click(Sender: TObject);
    procedure LineByLinehelp1Click(Sender: TObject);
    Function  CountFiles(Dir:String;FileExt:String):Integer;
    procedure BusinessSummary1Click(Sender: TObject);
    procedure RentalSummary1Click(Sender: TObject);
    //procedure Rollover2001summaryfromVisualTax1Click(Sender: TObject);
    //procedure CICALineByLineInternethelp1Click(Sender: TObject);
    procedure CICALineByLineInternethelpNONResidents1Click(
      Sender: TObject);
    procedure OtherGuides1Click(Sender: TObject);
    procedure EFileHelpDesk1Click(Sender: TObject);
    procedure CCArates1Click(Sender: TObject);
    procedure FSumBtnClick(Sender: TObject);
    procedure FamilySummary1Click(Sender: TObject);
   // procedure CheckCNILcontinuity1Click(Sender: TObject);
    procedure Checkupdates1Click(Sender: TObject);
    procedure Frequentlyaskedquestions1Click(Sender: TObject);
    procedure VisualTaxForum1Click(Sender: TObject);
    procedure HowoftentocheckInternetUpdates1Click(Sender: TObject);
    procedure CICA1Click(Sender: TObject);
    procedure CICAHelpbyline1Click(Sender: TObject);
    procedure CICAReferencematerials1Click(Sender: TObject);
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
    procedure TheWindowsClick(Sender: TObject);
    procedure CloseallreturnsWITHOUTSaving1Click(Sender: TObject);
    procedure ShowLastYearForm1Click(Sender: TObject);
    procedure NewReturnLblClick(Sender: TObject);
    procedure OpenReturnLblClick(Sender: TObject);
    //procedure MostRecentLblClick(Sender: TObject);
    procedure RollOvrerLblClick(Sender: TObject);
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
    procedure SpeedButton2Click(Sender: TObject);
    procedure LicLevel1Click(Sender: TObject);
    procedure PrepareDistr1Click(Sender: TObject);
    procedure ReturnsHeaderPanelClick(Sender: TObject);
    procedure SetupEOL1Click(Sender: TObject);
    procedure SetupEOLPlus1Click(Sender: TObject);
    procedure EkUDFList1Functions0Calculate(Sender: TObject;Args: TEkUDFArgs; ArgCount: Integer;
              UDFResult: TObject);
    procedure GoToaFormSection1Click(Sender: TObject);
    procedure EmailTheReturnClick(Sender: TObject);
    procedure OpenItBtnClick(Sender: TObject);
    procedure EMailItBtnClick(Sender: TObject);
    procedure TUTORIALS1Click(Sender: TObject);
    procedure Backupthetaxdata1Click(Sender: TObject);
    procedure Restoredatafrombackup1Click(Sender: TObject);
    procedure CopyAReturnBtnClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure TrBtnClick(Sender: TObject);
    procedure ShowBarCodedata1Click(Sender: TObject);
    procedure FinancialInstitutionsforT1DD1Click(Sender: TObject);
    procedure T7DRA1Click(Sender: TObject);
    procedure ForeignExchangeconverter1Click(Sender: TObject);
    procedure T4044GuideEmploymentExpenses1Click(Sender: TObject);
    //procedure SignOffWarningsBtnClick(Sender: TObject);
    procedure CurrentFormallinstances1Click(Sender: TObject);
    procedure SignffWarnings1Click(Sender: TObject);
    procedure CreateNewPlan1Click(Sender: TObject);
    procedure NextYearsRatesClick(Sender: TObject);
    procedure OpenExistingTaxPlan1Click(Sender: TObject);
    procedure TileThem;
    procedure OptimizeBtnClick(Sender: TObject);
    procedure SpecialGpT11Click(Sender: TObject);
    procedure TaxPlanner1Click(Sender: TObject);
    procedure ACBPortfolioSummary1Click(Sender: TObject);
    procedure N2008TaxRatesandDrafytLegislation1Click(Sender: TObject);
    procedure CopyreturnsfromT1Draft1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure SaveprintoutofreturninPDFformatinClientDocumentsfolder1Click(
      Sender: TObject);
    procedure ReviewfilesinClientDocumentFolder1Click(Sender: TObject);
    procedure VTSCAN1Click(Sender: TObject);
    procedure EFmemofieldadditionalfields1Click(Sender: TObject);
    procedure EfileErrorMessagesPDF1Click(Sender: TObject);
    procedure SetupEfile1Click(Sender: TObject);
  //  procedure NetFilenow1Click(Sender: TObject);
    procedure SetUpNetFile1Click(Sender: TObject);
    procedure Findbaspasswords1Click(Sender: TObject);
    procedure ShowFList1Click(Sender: TObject);
    procedure T2125YearlySummary1Click(Sender: TObject);
    procedure CheckALLforms1Click(Sender: TObject);
    procedure T1013Efile1Click(Sender: TObject);
    procedure PrintAllFormsBtnClick(Sender: TObject);
    procedure T1013EfileErrors1Click(Sender: TObject);
    procedure PrintSequence1Click(Sender: TObject);
    procedure ResetEfilestatusToWIPClick(Sender: TObject);
    procedure PrintCondencedT11Click(Sender: TObject);
//    procedure ShowTEDfiles1Click(Sender: TObject);
    procedure ClientPHOTOID1Click(Sender: TObject);
    procedure EFILERSMANUAL1Click(Sender: TObject);
    procedure MassEmail1Click(Sender: TObject);
    procedure KnownIssues1Click(Sender: TObject);
//added/renamed
    procedure mnSelAppClick(Sender: TObject);
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
      
    procedure TileHorizontally1Click(Sender: TObject);
    procedure TileVertically1Click(Sender: TObject);
    procedure TRTaxResearch1Click(Sender: TObject);
    procedure NextStatement1Click(Sender: TObject);
    procedure PreviousStatement1Click(Sender: TObject);
    procedure EMailForm1Click(Sender: TObject);
    procedure Notepad1Click(Sender: TObject);
    procedure Notepadwithamounts1Click(Sender: TObject);
    procedure PrivateNotepad1Click(Sender: TObject);
    procedure SortMedical1Click(Sender: TObject);
    procedure SortACBBydate1Click(Sender: TObject);
    procedure RefreshALLdependants1Click(Sender: TObject);
    procedure RefreshALLdependantsaddressesfromparent1Click(
      Sender: TObject);
    procedure Refreshaddressfromotherspouse1Click(Sender: TObject);
    procedure TaxPlannerUsenextyearrates1Click(Sender: TObject);
    
    procedure Showwhatthevaluewaslastyear1Click(Sender: TObject);
    procedure AddtoDataDictionaryforclientletters1Click(Sender: TObject);
    procedure SortACBBydate3Click(Sender: TObject);
    procedure AddRow1Click(Sender: TObject);
    procedure DeleteRow1Click(Sender: TObject);
    procedure AttachNote1Click(Sender: TObject);
    procedure AttachAddingTape1Click(Sender: TObject);
    procedure Help4Click(Sender: TObject);
    procedure CICAWebbasedsubscriptionrequired1Click(Sender: TObject);
    procedure TRVisualTaxResearchWebbased1Click(Sender: TObject);
    procedure FormSections1Click(Sender: TObject);
    procedure Override1Click(Sender: TObject);
    procedure EFile2Click(Sender: TObject);
    procedure ShowTreeview1Click(Sender: TObject);
    procedure WindowCascadeItemClick(Sender: TObject);
    procedure WindowArrangeItemClick(Sender: TObject);
    procedure MinimizeformClick(Sender: TObject);
    procedure MinimizeReturnClick(Sender: TObject);
    procedure MinimizeAllClick(Sender: TObject);
    procedure RestoreReturnClick(Sender: TObject);
    procedure RestoreAllClick(Sender: TObject);
    procedure ChangetaxmoduleT1T2TFFP1Click(Sender: TObject);
    procedure DeveloperOnly1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure RequestTDDBtnClick(Sender: TObject);//20160121 Igor
    procedure OpenAutoFillLogin;
    procedure AutofillfromCRABtnClick(Sender: TObject); //20160126 Igor
    procedure ShowTddStatus;
    procedure ShowAutofillStatusBtnClick(Sender: TObject);
    procedure AuditTrailHistoryOfAutoFill1Click(Sender: TObject);
    procedure LogintoCRAforAutoFill1Click(Sender: TObject);//20160216 Igor
    procedure ReviewAutoFilldatareceivedfromCRA1Click(Sender: TObject);//20160216 Igor
    procedure mniT1135EfileClick(Sender: TObject);//20160216 Igor
    procedure HistoryofT1013submissions1Click(Sender: TObject);//20160216 Igor
    procedure HistoryofT1135Submissions1Click(Sender: TObject);//20160216 Igor
    procedure EfileAppendicesExclusionsandotherinfo1Click(Sender: TObject); //20160216 Igor
    procedure CDEClientDataEnquireShowdata1Click(Sender: TObject); //20160216 Igor
    procedure IntroductionbyCRA1Click(Sender: TObject); //20160216 Igor
    procedure HelpByVisualTax1Click(Sender: TObject);
    procedure ImportdatafromProductionDataBases1Click(Sender: TObject);
    procedure ResetpasswordfromclientDB1Click(Sender: TObject);
    procedure buttonAvailableWidthClick(Sender: TObject);
    procedure PrintableAutofilldata1Click(Sender: TObject);
    procedure Convertoptionsfromoldversion1Click(Sender: TObject);
    procedure UploadtoDropBox1Click(Sender: TObject); //20160126 Igor
    procedure ResetpasswordwithReturn1Click(Sender: TObject);
    procedure PADPreauthorizedDebit1Click(Sender: TObject); //20161028 Igor
    procedure Exporttofile1Click(Sender: TObject); //20161229 Igor
    procedure ReviewfilesinPermanentClientDocumentsfolder1Click(
      Sender: TObject);
    procedure ReFILEthisreturn1Click(Sender: TObject);//20170130 Igor
    procedure NOA1Click(Sender: TObject);
    procedure HistoryOfReFILEDreturns1Click(Sender: TObject);
    procedure AlertsNotifications1Click(Sender: TObject);//20170314 igor
    procedure RepairReturn1Click(Sender: TObject);//20170420 Igor
    procedure RollOverfromTaxCycle1Click(Sender: TObject);//20170428 Igor
    procedure Buildreport1Click(Sender: TObject);
    procedure actFindFormExecute(Sender: TObject);
    procedure edtSearchFormChange(Sender: TObject);
    procedure actOpenRecentExecute(Sender: TObject);
    procedure rbnT1RecentItemClick(Sender: TObject; FileName: string;
      Index: Integer);
    procedure amT1StateChange(Sender: TObject);
    procedure edtSearchForm3Click(Sender: TObject);
    procedure actDataExtractExecute(Sender: TObject);//20171128 Igor
    procedure actForCloudExecute(Sender: TObject);//20171215 Igor
    procedure actChangeSkinExecute(Sender: TObject);
    procedure CreateNAICS1Click(Sender: TObject); //20180206 Igor
    //20181130 Igor >>>
    procedure btnUploadClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    procedure AutoFillClick(Sender: TObject);
    //procedure btnUploadWithoutOpenClick(Sender: TObject); //20190529 Igor
    //20181130 Igor <<<
    //20190415 Igor >>>
    procedure MainUIRibbonCommandCreate(const Sender: TUIRibbon;
      const Command: TUICommand);
    procedure SearchFormSelect(const Args: TUICommandCollectionEventArgs);
    procedure Clients_With_Mail_NOAClick(Sender: TObject);
    procedure actRebuilDatabaseCloudExecute(Sender: TObject); //20190522 Igor
    //20190415 Igor <<<
    //20191129 Igor >>>
    procedure actCreateClientsFoldersExecute(Sender: TObject);
    procedure actScanExecute(Sender: TObject);
    procedure actCopyClientsFoldersExecute(Sender: TObject); //20190522 Igor
    procedure actWatermarkExecute(Sender: TObject);
    procedure UsePrintWatermark1Click(Sender: TObject);
    procedure OpentClientDocumentsfolder1Click(Sender: TObject);
    procedure eSignaturesandCOVID191Click(Sender: TObject);
    procedure ElectronicSignature1Click(Sender: TObject);
    procedure Submit1Click(Sender: TObject);
    procedure RequestESignatureConfirmation1Click(Sender: TObject);
    //20201208 Igor >>>
    procedure vtCourier_OfficeClick(Sender: TObject);
    procedure VTO_LogOut_BothClick(Sender: TObject);
    procedure VTO_LoginClick(Sender: TObject);
    procedure EditTaxPayerProfile_PayerClick(Sender: TObject);
    procedure mmVirtualTaxOfficeClick(Sender: TObject);
    procedure EditTaxOfficeProfile_OfficeClick(Sender: TObject);
    procedure VTO_ChangePassword_BothClick(Sender: TObject);
    procedure MassRegistration_OfficeClick(Sender: TObject);
    procedure vtCourier_PayerClick(Sender: TObject);//20201019 Igor
    procedure SingleRegistration_OfficeClick(Sender: TObject); //20201216 Igor
    procedure ColourSettings_OfficeClick(Sender: TObject); //20201224 Igor
    procedure actOtherExecute(Sender: TObject);
    procedure VirtualOfficeIntro1Click(Sender: TObject);
    //20210115 Igor >>>
    procedure actHelpVTOExecute(Sender: TObject);
    procedure actFaqVTOExecute(Sender: TObject);
    procedure actDocumentsFolderExecute(Sender: TObject);
    procedure OpenDocumentsFolder1Click(Sender: TObject);
    procedure ChangeDocumentfolder1Click(Sender: TObject);
    procedure SignPDFwithESignature1Click(Sender: TObject);
  	//20210115 Igor <<<
    procedure actSendSignatureExecute(Sender: TObject);//20210126 Igor
    procedure actVtScanVTOExecute(Sender: TObject); //20210201 Igor
    //20210203 Igor >>
    procedure actStartVirtualMeetingVTOExecute(Sender: TObject);
    procedure StartVirtualMeeting_OfficeClick(Sender: TObject);
    procedure MassEmailtoTaxPreparers1Click(Sender: TObject); //20210204 Igor
    procedure MassEmailtoVirtualClients_OfficeClick(Sender: TObject);//20210216 Igor
    procedure CreatePDFforsigning_OfficeClick(Sender: TObject);//20210318 Igor
    procedure RequestSignature_OfficeClick(Sender: TObject); //20210407 Igor
    procedure AccepttheClientssignature_OfficeClick(Sender: TObject); //20210208 Igor
    procedure SendTaxReturnPDFprintoutstoClient_OfficeClick(Sender: TObject); //20210426 Igor
    //20210430 Igor >>>
    procedure VirtualClientsandAppointments_OfficeClick(Sender: TObject);
    procedure ServiceRequests_OfficeClick(Sender: TObject);
    procedure actArchivesExecute(Sender: TObject);
    procedure DeveloperMode1Click(Sender: TObject); //20241024 Igor
    //20210430 Igor <<<
    //20210203 Igor <<<
    //20210112 Igor
    //20201208 Igor <<<
  //  procedure SaveAsPDF1Click(Sender: TObject);
   // procedure SaveAsPDF1Click(Sender: TObject); //20200414
    //procedure CopyFormasPDF1Click(Sender: TObject); //20191216 Igor
    //20191129 Igor <<<
  private
    FRetNo: integer;
    MyChild: TMyChild;
    MyForm: TvtScrollBox;
    FormName: string;
    FormNo: integer;
    ToolBarSw: boolean;
    FPluginLoaded: Boolean; //20161210 Igor
    //20170824 Igor>>>
    FSearchStr: String;
    slRecentCloud : TStringList; //20190507 Igor
    FSearchForm1, FSearchForm2: TUICommandCollection; //20190415 Igor
    procedure SetSearchStr(const AValue: String);
    property SearchStr: String read FSearchStr write SetSearchStr;
    function GetZoomStr: String;
    procedure SetZoomStr(const Value: String);
    //20170824 Igor<<<
    procedure OnCreateMenuItem(const aName: string; const aHelperID: Integer);//20171215 Igor
  private
    Function ButtonInactive(AShowMessage: Boolean = True):Boolean;
    Procedure FullPrint(RetNo:Integer;Template:String;Sender:TObject);
    Procedure ListBunchOfForms(TypeOfForm:string;ListCaption:String);
    Procedure InitColorPanel;
    procedure PrintReturn(RetNo:integer;FormsToPrint:TstringList;DataDir:string;FlName:string);
    procedure ShowHint(Sender: TObject);
    Procedure UsedFormsOnTreeView(RetNo:Integer);
    procedure Done;
    function NotEditCommand(Sender: TObject): boolean;
    //procedure OpenFromCloudClick(Sender: TObject);//20161210 Igor
    function GetStateForDataExtract: boolean;//20171128 Igor
    procedure SetMainMenuTitle; //20191202 Igor
  public
    procedure OpenFromCloudClick(Sender: TObject); //20190517 Igor
    function GetCoupleFromCloud(ASourceDir, AFileName: string): string; //20190528 Igor //20200914 Igor
    property RetNo: integer read FRetNo;
    property ZoomStr: String read GetZoomStr write SetZoomStr;//20170824 Igor
  public
    function DoSaveAllReturns(RNo: integer): Boolean;
    procedure SelectFeatures;
    procedure ErrorViewClick(RetNo: integer; SourceNode : TTreeNode);

    function FormsTreeView1Click(SourceNode: TTreeNode; fUsedForms: boolean): integer;
    function RefreshAuditPanel(RetNo: integer; ReturnsHeaderPanel: TPanel;
      ErrorView: TTreeView;fSuper:boolean): string;
    procedure RefreshFormsPanel(TreeView: TTreeView; fUsedForms: boolean; RetNo: integer);
    function SuperAuditBoxClick(RetNo: integer; ReturnsHeaderPanel: TPanel;
      ErrorView: TTreeView): string;
    function SuperVerificationBtnClick(RetNo: integer; ReturnsHeaderPanel: TPanel;
      ErrorView: TTreeView): string;
    procedure InitialDB;
    //20170628 Igor >>>
    procedure CallExecuteForm(AFormID: Integer);
    //20170628 Igor <<<
    procedure ReloadMainMenu; //20180111 Igor
    procedure InitMostRecentFilesCloud;       //20190507 Igor
    procedure UpdateMostRecentFilesCloud(ARetNo : integer; AFileName : string);       //20190507 Igor
    procedure InitVirtualTaxOfficeMenu; //20201119 Igor
  end;

var
  MainFormT1: TGuiT1_2026;
  T1Menu: TMainMenu;

Const HelpRoot='www.visualtax.com/VT2023HELP/T1HELP/Website/T1Help.html';  //jz//20230219 //20211220

function FileNew: integer;

Implementation

{$R *.DFM}

uses
  HtmlHelp,ClipBrd,
  vtMulti,vtForm,vtMain,vtCommon,vtDialogs,fProgres,
  T1_2026,
  T1_2026T1Pad, //20161201
  T1_2026T1013Efile,T1_2026PrintSeqFrm,T1_2026Common,T1_2026Common2,
  T1_2026TrimStr,T1_2026T1Rtns,T1_2026Clients,T1_2026T7DRA,T1_2026Declare,
  T1_2026VtScan,T1_2026EfileRtns,VtEditBox,T1_2026BadPsw,
  T1_2026Signature, //20200324
  T1_2026printReturnFrm,T1_2026TESTFRM,T1_2026TESTFORM,T1_2026OptionsFrm,
  T1_2026SaveAsPdf,  //20200424
  {T1_2026SlipsFrame,}T1_2026AcbFrame,{T1_2026FrameElections,}T1_2026OpFlNm,
  T1_2026ClientBook,T1_2026SaveAs,T1_2026BackupFrm,T1_2026RestoreFrm,
  T1_2026Fees,T1_2026Dict,T1_2026EFMErr,T1_2026SIC,T1_2026CopyFromDraftFrm,
  T1_2026DFiles,T1_2026Warning,T1_2026CntErr,T1_2026Print,T1_2026DeskTop,
  T1_2026CopyMoveFrm,
//T1_2026StatBox,
  T1_2026Cpl,T1_2026PopComboList,
  T1_2026SearchList,T1_2026Users,T1_2026CashR,T1_2026rSum,T1_2026Tips,
  T1_2026CopyFrm,T1_2026Analyse,T1_2026FileVu,T1_2026Calc,T1_2026FixCnil,
  T1_2026CalcCpl,T1_2026DBRestr,
  //T1_2026FormsExplorer,//
  T1_2026FRMType,
  T1_2026ABList,T1_2026PrSet,
  T1_2026Rebuild,T1_2026Merge,T1_2026Optim,T1_2026Rtu,T1_2026SelOpen,T1_2026CloudRebuild, //20190522 Igor
  T1_2026Chart,T1_2026Recalc,T1_2026ResetEF,
  T1_2026ListBal,T1_2026ListBaljz, //jz//20250207
  T1_2026Presel,
  T1_2026ClientsWithMailNoa,  //20190501
  T1_2026NISACd,T1_2026Import,DB,T1_2026YTDSet,T1_2026YTDCash,T1_2026Logging,
  T1_2026CopyDly,T1_2026T1Rtns2,
//T1_2026RichForm,
  T1_2026ChartClients,
  T1_2026OthOpt,T1_2026ReindexDb,T1_2026TaxByte,
  T1_2026EOLP,
  T1_2026HtmlSEND,T1_2026Restructure,//T1_2026ImportGpT1,
  T1_2026RollGpT1,T1_2026SpecialGpT1,T1_2026RollCtxT1,T1_2026Features,
  T1_2026InvAdj,T1_2026FtpFrm,T1_2026SuperEntry,T1_2026QRLetter,
  T1_2026ImportConfig,T1_2026ExportConfig,T1_2026FindALine,T1_2026SendErrors,
  T1_2026EOLSetup,T1_2026EOLPSetup,T1_2026eolpAck,T1_2026PdfFrm,
  T1_2026SetFilePsw,T1_2026UpdateSchedule,T1_2026DataDictFrm,T1_2026ChildWinNew,
  T1_2026ExportData,T1_2026HeaderFrame,
  T1_2026ClientBookCloud, //20190503 Igor
//added T1-2013
{really added?
  T1_2026AdvFnd,
  T1_2026OpFlNm,
}
  T1_2026WebServiceSEND,
//removed
{
  T1_2026HtmlEOL,
}
//not removed
  T1_2026T1Efile,
  T1_2026ReFILE,  //20170319
//multi-app
  vtPrints,
  vtTrimStr,vtShared, uADCompClient, vtDataModuleUnit, vtDataBase, //20150826 igor
  T1_2026AutoFillLogin, T1_2026AutoFillFrm, T1_2026ImportDBFData, //20160126 Igor
  fAnyPassword, T1_2026MobileUtils, //20160227 Igor
  fConvertToMultiApp, //20160602 Igor
  vtHelperManager, vtCommonIntf, vtUsers, //20170112 Igor
  vtFillDBMain, //20170308 Igor
  vtNOA, //20170320 Igor
  TaxCycleUtil, //20170428 Igor
  vtReportBuilder, //20170504 Igor
  T1_2026DataExtract, //20171127 Igor
  vtChooseFileForm, //20181130 Igor
  fSelectCloudFile, //20201015 Igor
  vtCourier, //20201019 Igor
  //20201119 Igor >>>
  vtVirtualTaxOffice, vtVirtualTaxOfficeLogin, vtVirtualTaxOfficePayer,
  vtVirtualTaxOfficeOffice, vtVirtualTaxOfficeChangePassword,
  T1_2026MassRegistration, vtVirtualTaxOfficeColourSettings, //20201224 Igor
  //20201119 Igor <<<
  T1_2026SignPDF, //20210125 Igor
  T1_2026MassEmailToTaxPreparers, //20210204 Igor
  T1_2026MassEmailToTaxPayers, //20210216 Igor
  T1_2026SaveAsPdfForVC, //20210318 Igor
  vtControlIntf; //20170727 Igor

procedure TGuiT1_2026.FormCreate(Sender: TObject);
Var i:Integer;TempList:TStringList;
begin
 MainUIRibbon.ResourceInstance := LoadLibraryEx('T1_UIRibbonUnit.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
 if (MainUIRibbon.ResourceInstance = 0) then
  MainUIRibbon.ResourceName := '';
 //20101212
 AppLabel.Caption:=AppName+'-'+AppYear;
 AppUpdateDateLbl.Caption:= 'As of: '+AppUpdateDate;

{$IFDEF Tutorials}
 TutHistoryIndex := -1;
 TutHistoryList := TStringList.Create;
 TutUpdateCombo:=True;
 HelpKeyW:=TStringList.Create;
{$ELSE}
{$ENDIF}
//20170824 Igor>>>
  ZoomStr := IntToStr(OptRec.FormZoom)+'%';
//20170824 Igor<<<
  ConvertMostRecentFiles; //20200914 Igor
 //20190507 Igor >>>
  if CheckIsCloud(true) and IsCloudStorageEnabled then begin
    InitMostRecentFilesCloud;
  end else begin
    If FileExists(AppDir+'\'+RecentRFlName) = False then
      InitMostRecentFiles(50); //put them in RecentFlName
  end;
//20190507 Igor <<<
  {???
  If FileExists(AppDir+'\'+RecentRFlName) = False then
   InitMostRecentFiles(50); //put them in RecentFlName
  }
  ShowMostRecentReturns;

  T1Menu := Menu;
  Menu := nil; //to be shown in Main
  InitColorPanel;
  //20180111 Igor >>>
  //LoadPluginActions(Self, MainMenu, OpenFromCloudClick, OnCreateMenuItem);//20171215 Igor //20161210 Igor
  ReloadMainMenu;
  //20180111 Igor <<<
  //20181130 Igor >>>
  //20190529 Igor >>>
  if CheckIsCloud(true) then
  begin
    OpenbyFileName1.Caption := 'Open by &File Name ...';
    //20190213 Igor >>>
    ListView1.CheckBoxes := true;
    //20190213 Igor <<<
    actRebuilDatabaseCloud.Visible := true; //20190522 Igor
    btnDownload.Visible := true;
    btnDownloadAll.Visible := true;

    //20190605 Igor >>>
    actPrinterSetup.Enabled := false;
    actCreateDataDirectory.Enabled := false;
    actChangeDataDirectory.Enabled := false;
    actOpenPreviousYears.Enabled := false;
    actImportConfiguration.Enabled := false;
    actExportConfiguration.Enabled := false;
    CopyAReturnBtn.Enabled := false;
    actReviewfilesinClientDocumentFolder.Enabled := false;
    actReviewfilesinPermanentClientDocumentsfolder.Enabled := false;
    actMassEmail.Enabled := false;
    //20190605 Igor <<<

    //20200630 Igor >>>
    actOpenPreviousYears.Enabled := false;
    actShowLastYear.Enabled := false;
    actUploadtoDropBox.Enabled := false;
    actImportLastYear.Enabled := false;
    actRollForwardFromCanTax.Enabled := false;
    actRollForwardFromProfile.Enabled := false;
    actRollOverfromTaxCycle.Enabled := false;
    actImportDataFromProductionDataBase.Enabled := false;
    actConvertoptionsfromoldversion.Enabled := false;
    actDataBaseAnalyser.Enabled := false;
    //actClientStatistics.Enabled := false;
    actCreateDataDirectory.Enabled := false;
    actChangeDataDirectory.Enabled := false;
    actDataExtract.Enabled := false;
    actCalculator.Enabled := false;
    actBackupthetaxdata.Enabled := false;
    actRestoredatafrombackup.Enabled := false;
    actCopyBackUp.Enabled := false;
    actMergeDataBases.Enabled := false;
    actRecalculateandsaveALLtaxreturns.Enabled := false;
    actFileViewerEditor.Enabled := false;
    actCopyreturnsfromT1Draft.Enabled := false;
    EmergencyToolKit1.Enabled := false;
    //20200630 Igor <<<
  end
  //20201117 Igor >>>
  else if IsvtClient then //20210112 Igor
  begin
    //20201222 Igor >>>
    {for I := 0 to amT1.ActionCount - 1 do
      amT1.Actions[I].Visible := false;
    AutoFill.Visible := false;
    Edit.Visible := false;
    VTSCAN1.Visible := false;
    Coupling.Visible := false;
    EfileOnLine.Visible := false;
    Efile.Visible := false;
    NetFileForindividuals1.Visible := false;
    TaxPlanner1.Visible := false;
    Utilities.Visible := false;

    actOpenReturn.Visible := true;
    actExit.Visible := true;
    actCloseReturn.Visible := true;
    actSelectForm.Visible := true;
    actJacket.Visible := true;
    actSlipsItem.Visible := true;
    actFindaline.Visible := true;
    actAlphabeticalFormsIndex.Visible := true;
    actSwitchforms.Visible := true;
    actPreSelForms.Visible := true;
    actNextPage.Visible := true;
    actPreviousPage.Visible := true;
    actZoomin.Visible := true;
    actZoomout.Visible := true;
    actAvailableWidth.Visible := true;
    actHelpCurrentForm.Visible := true;
    actTips.Visible := true;

    EFileBox.Visible := false;
    CouplingBox.Visible := false;
    ReviewBox.Visible := false;
    DeskTopBox.Width := TipsBtn.Left + TipsBtn.Width + ZoomBtnPlus.Left;

    OpenBtn.Left := NewBtn.Left;
    OpenBtn.Height := ExitBtn.Top + ExitBtn.Height - NewBtn.Top;
    OpenBtn.Width := ImportBtn.Left + ImportBtn.Width - NewBtn.Left;
    CloseBtn.Top := SaveBtn.Top;
    ExitBtn.Left := SaveBtn.Left;  }
    Menu := nil;
    T1Menu := nil;
    FileMgtBox.Visible := false;
    Efilebox.Visible := false;
    NavigationBox.Visible := false;
    CouplingBox.Visible := false;
    ReviewBox.Visible := false;
    DesktopBox.Visible := false;
    VirtualTaxOfficeBox.Visible := true;
    //20201222 Igor <<<
  end
  //20201117 Igor <<<
  else
  begin
    //20190213 Igor >>>
    ListView1.CheckBoxes := false;
    //20190213 Igor <<<
    actRebuilDatabaseCloud.Visible := false; //20190522 Igor
    btnDownload.Visible := false;
    btnDownloadAll.Visible := false;
    //20190605 Igor >>>
    btnUpload.Visible := false;
    btnUploadWithoutOpen.Left := OpenItBtn.Left;
    btnUploadWithoutOpen.Caption := 'Upload returns to vtCloud';
    //20190605 Igor <<<
  end;
  //20181130 Igor <<<
  if IsCloudStorageEnabled then
  begin
    //btnUpload.Visible := true; //20190605 Igor
    btnUploadWithoutOpen.Visible := true;
  end
  else
  begin
    btnUpload.Visible := false;
    btnUploadWithoutOpen.Visible := false;
  end;
  //20190529 Igor <<<
  //20220512 Igor >>>
  if IsInternetConnectionActive then
    AutoLoginToVirtualTaxOffice; //20210426 Igor
  //20220512 Igor <<<
  //AutoLoginToVirtualTaxOffice; //20210426 Igor
  InitVirtualTaxOfficeMenu; //20201118 Igor
 // AppT1_2026.GetScanLicenseLevel; // 20250527 Igor //20250602 CZ
end;


Procedure TGuiT1_2026.OpenViaExplorer;
Var  //Following needed for Explorer Read
FullFlName,DataDir,FlName:String;ThisResult:Integer;Sin:String; //20101224
RetNo:Integer;FormName:String;FormNo:Integer;//CplList:TList;
begin
  ExplorerFileName:=ParamStr(1);
  FullFlName:=ParamStr(1);
  FlName:=ExtractFileName(FullFlName);
  DataDir:=ExtractFileDir(FullFlName);
  OpenReturnCoupled(DataDir,FlName, True); //assume always visible
end;


function TGuiT1_2026.RefreshAuditPanel(RetNo: integer; ReturnsHeaderPanel: TPanel;
      ErrorView: TTreeView;fSuper:boolean): string;
//Procedure TGuiT1_2026.RefreshAuditPanel(RetNo:Integer);
Var i,k:Integer; TempList:TStringList;
  //AuditMode: eAuditMode;
  Categories: string;
begin
(* don't recurse in CountDiagnostics! (done by caller!)
  fSuper means SuperAudit
*)
  Result := ''; //???
 If RetNo=0 then exit;

 If Ret[RetNo].IsTaxPlan then
 begin
  Ry:=PlanningRy;
  ReturnsHeaderPanel.Caption:=PlanYear+' Tax rates';
  ReturnsHeaderPanel.Color:=clRed;
  ReturnsHeaderPanel.Font.Color:=clWhite;
  ReturnsHeaderPanel.Font.size:=10;  //20160813
 end
 else
 begin
  Ry:=0;
  //20160805 Igor >>>
  MainForm.GuiCommand(gcSetReturnsHeaderPanelNormalState);
//  ReturnsHeaderPanel.Caption:='Returns';
//  ReturnsHeaderPanel.Color:=$00AC7400;
//  ReturnsHeaderPanel.Font.Color:=$00A6CAF0;
  //20160805 Igor <<<
 end;
  Categories := 'MEWFTRDNO';
  if fSuper then
    Categories := 'S'+Categories;
  RetList[RetNo].AuditRecsToTreeView(ErrorView,Categories);
end; {procedure}


Function TGuiT1_2026.ButtonInactive(AShowMessage: Boolean = True):Boolean; //20160714 Igor
begin
  FRetNo := GetCurrentRetNo;
  if RetNo < 1 then
  Begin
    Result := True;
    if AShowMessage then //20160714 Igor
      ShowMessage('You must open a return first');
  end
 Else if Ret[RetNo] = nil then begin
  Result := True; //wrong return type!
  MyChild := nil;
 end else
 begin
  Result := false;
  MyChild := vtMulti.RetList[RetNo].MyChild;
  MyForm := MyChild.ActiveForm;
  if MyForm <> nil then
  begin
    FormName := MyForm.FormName;
    FormNo := MyForm.FormNo;
  end
  else
  begin
    FormName := '';
    FormNo := 0;
  end;
 end;
end;

procedure TGuiT1_2026.ShowHint(Sender: TObject);
begin
 { StatusLine.Caption := Application.Hint;}
end;


function FileNew: integer;
Var
  RetNo: integer absolute Result;
  FormNo:Integer;
  k:Integer;
  FormName: string;
begin
  Result := iorReported;
//20170901 Igor>>>
  if AppT1_2026.ExceedsMaxReturnsAllowed(True) then
    exit;
// If LicenseLevel in anyLimited then  //20110407
// begin
//   If CountDBRecords >= LimitedVersionReturns then
//   begin
//     ShowMessage('Number of returns would exceed maximum allowed '
//     +'('+IntToStr(LimitedVersionReturns)+')'+
//     Chr(13)+' in the T1 Limited version'+
//     Chr(13)+'Please contact VisualTax for Upgrade');
//    Exit;
//   end;
// end;
//20170901 Igor<<<

   RetNo:=CreateNewReturn;

  //20241203 If UpperCase(InputBox('T1 Not released yet', 'PSW', '')) <> 'N/A' then exit;  //20241126

   if RetNo < 1 then begin ShowOpenReturnFailure(RetNo, '', ''); exit; end;

   //If K>0 then
   begin
     //RetNo := Result;
     //LockWindowUpdate(MainForm.Handle);
     //MainForm.LeftPanel.Visible:=True;
     MainForm.GuiCommand(gcShowLeftPanel);

     FormName := 'INFO';
     FormNo := GetFormNo(FormName);
     InitFormData(RetNo,FormNo);
     If OptRec.NFL_EFile then  StoreElm(RetNo,FormNo,46,'X'); //Efiled
     If OptRec.Prp_Elect then  StoreElm(RetNo,FormNo,43,'X'); //election
     If OptRec.PRP_EfRepr then StoreElm(RetNo,FormNo,58,'X'); //T183 represent
     if IsVtClient then StoreElm(RetNo, 'STATUS', 33, vtClientCreated); //20210115 Igor

     CountDiagnostics(RetNo);
     MainForm.GuiCommand(gcReduceTutorialHeight);
     OpenForm(RetNo,FormNo,0); //new child
     MainForm.UsedFormsBox.Checked:=False;
     UpdateAllDataIndicators(RetNo);

      MainForm.FormPaint(nil);
     //MainForm.LeftPanel.Visible:=True;
      MainForm.GuiCommand(gcShowLeftPanel);
      MainForm.GuiCommand(gcMDIArrange);//20160223 Igor
   end;
end;

procedure TGuiT1_2026.FileNewItemClick(Sender: TObject);
begin
 (*
   //20231217
  ShowMessage(
     'This Draft T1 release includes expected tax rates and other changes, but it has not been reviewed nor approved by CRA.'
     +Chr(13)+Chr(13)+'Details for the following new schedules, are hidden for now to comply with the Non-disclosure Ageement of CRA:'
     +Chr(13)+'S12 (Multigenerational home renovation), First Home Savings Account (S15),'
     +' First Home Contributions (T4FHSA)  and Flipping Property details (S3).'
     +Chr(13)+'The T1-2023 Guide is not yet available by CRA.'
     +Chr(13)+' For now, you can rollover selectively VT T1-2022 returns only one at a time. Batch rollover will be released later.'
     +Chr(13)+Chr(13)+'You can use this product for tax planning, data entry, selective roll-over from last year or training purposes.'
     +' The CRA-certified version is expected to be released the second week of February, 2024.'
     );
 *)

  FRetNo:=FileNew;
end;

procedure TGuiT1_2026.FileOpenItemClick(Sender: TObject);
//Var RetNo,PrvRNo:Integer;
//20200305 Igor >>>
var mi: TMenuItemEx;
    I: integer;
//20200305 Igor <<<          5
begin
  //20201117 Igor >>>
  if IsvtClient then //20210112 Igor
  begin
    actOpenReturnByFileName.Execute;
    Exit;
  end;
  //20201117 Igor <<<
  //PrvRNo := GetCurrentRetNo; //???
  //20200305 Igor >>>
  if CheckIsCloud(true) then
  begin
    for I := 0 to MainMenu.Items[0].Count -1 do begin
      if Pos('Open return from cloud',MainMenu.Items[0].Items[i].Caption) > 0 then begin
        mi := (MainMenu.Items[0].Items[i] as TMenuItemEx);
        break;
      end;
    end;
    if mi = nil then exit;
    OpenFromCloudClick(mi);
    Exit;
  end;
  //20200305 Igor <<<
 //20190503 Igor >>>>>>>>
  if CheckIsCloud(True) then begin
    if ExecuteForm(TClientBookCloudT1_2026) = mrOk then
       MainForm.GuiCommand(gcHideFlash);
  end else begin
    if ExecuteForm(TClientBookT1_2026) = mrOk then //20160612 Igor
       MainForm.GuiCommand(gcHideFlash);
  end;
 //20190503 Igor <<<<<<<<<<
  {
  if ExecuteForm(TClientBookT1_2026) = mrOk then //20160612 Igor
    MainForm.GuiCommand(gcHideFlash);
  }
  Done;
 // TileVertical1Click(Sender);
end;


procedure TGuiT1_2026.FileSaveItemClick(Sender: TObject);
begin
  FileSaveAsItemClick(Sender);
end;

procedure TGuiT1_2026.FileSaveAsItemClick(Sender: TObject);
begin
 {
 If EditBeforeSave(RetNo) = false then //20250315
 begin
   If not MainForm.WizardPanel.Visible then MainForm.AuditOpenBtnClick(Application);
   ShowMessage('Please fix Mandatory data before Saving the return');
   exit;
 end;
 }

 If ButtonInactive then exit;
 If (Ret[RetNo].IsLastYearReturn) or (Ret[RetNo].IsAppendix) then Exit;  //20110227 //20160314 Igor
 RecalcEverything(RetNo);
 If (LicenseLevel in anyMulti) and (ShowFinancialWarning = True) then
    begin
     If  (Vl(FetchElm(RetNo,'FPCHECK',35)) =0)
     and (Vl(FetchElm(RetNo,'FPCHECK',36)) >0)
     then
      begin
       ShowMessage('Financial Planning Assistance may be required'+
        Chr(13)+'Please enter at least one Y or N on the follow-up box'
        +Chr(13)+'of the following window');
       OpenForm(RetNo,'FPCHECK',0);
       Exit;
      end;
    end;

 If EditBeforeSave(RetNo) = false then
 begin
   If not MainForm.WizardPanel.Visible then MainForm.AuditOpenBtnClick(Application);
   ShowMessage('Please fix Mandatory data before saving');
   exit;
 end;
 T4Sum(RetNo,'T4SUM',GetFormno('T4SUM'));
  ExecuteForm(TSaveAsT1_2026);
end;

procedure TGuiT1_2026.FileCloseItemClick(Sender: TObject);
Begin
 If ButtonInactive then exit;

 EndCoupling1Click(Sender);  //20100307
  //MyChild := RetList[RetNo].MyChild;
  RetList[Self.RetNo].Close(True);
 //MainForm.FormPaint(Sender); --> RetNoChanged()
end;

Function TGuiT1_2026.EditBeforeSave(RetNo:Integer):Boolean;
begin
 Result:=False;
 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount > 0 then
 begin
   Exit;
 end;
 Result :=true;
end;

Function TGuiT1_2026.EditBeforePrint(RetNo:Integer):Boolean;
begin
 Result:=False;
 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount > 0 then
 begin
   Exit;
 end;
 Result :=true;
end;


procedure TGuiT1_2026.EditTaxOfficeProfile_OfficeClick(Sender: TObject); //20201208 Igor
begin
  EditVirtualTaxOfficeOffice;
end;

procedure TGuiT1_2026.EditTaxPayerProfile_PayerClick(Sender: TObject); //20201208 Igor
begin
  EditVirtualTaxOfficePayer;
end;

procedure TGuiT1_2026.edtSearchForm3Click(Sender: TObject);//20170825 Igor
begin
//dummy
end;

procedure TGuiT1_2026.edtSearchFormChange(Sender: TObject);//20170824 Igor
begin
  SearchStr := (Sender as TEdit).Text;
end;

procedure TGuiT1_2026.ShowWarnings;
begin
  if ButtonInactive then exit;
  Warning(RetNo);
end;

procedure TGuiT1_2026.FileExitItemClick(Sender: TObject);
begin
  MainForm.FileExitItemClick(Sender);
end;


procedure TGuiT1_2026.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 {}
end;

procedure TGuiT1_2026.SelectFormClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 UpdateAllDataIndicators(RetNo);
 //FormsExplorer(RetNo,FormName);
 FrmTypes(RetNo,{MyForm.}FormName);
 Done;
end;


procedure TGuiT1_2026.ListBunchOfForms(TypeOfForm:string;ListCaption:String);
Var I: integer;  FName: string;
begin
 If ButtonInactive then exit;
 SomeList.Clear;  // := TStringList.Create;
 SomeList.Sorted := True;
 SomeCaption := ListCaption;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormShow) and (Frec.FormType = TypeOfForm) then
       SomeList.Add(Frec.FormAbrev); {FormRlNm); }
 end;
 SelectedString := PopSomeList(SomeList, SomeCaption);
 //SomeList.Free; //20160628 Igor
 If SelectedString > '' then
 begin
   FName := Rtrim(GetFName(SelectedString));  {using Real Name}
   OpenForm(RetNo,FName,0);
   Done;
 end;
end;

procedure TGuiT1_2026.SlipsItemClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 ListBunchOfForms('SL','Slips');
end;

procedure TGuiT1_2026.PrinterSetupClick(Sender: TObject);
begin
{
//20171031 igor>>>
  if StartParams.isCloud then
  begin
    MessageDlg(c_NotAvailable, mtInformation, [mbOk], 0);
    Exit;
  end;
//20171031 igor<<<
}
  if CheckIsCloud then Exit; //20180503 Igor
  PrintDialogItem.Execute;
end;

procedure TGuiT1_2026.NewBtnClick(Sender: TObject);
begin
  FileNewItemClick(Sender);
end;

procedure TGuiT1_2026.SlipsBtnClick(Sender: TObject);
begin
  //If RetInMem > 0 then
  SlipsItemClick(Sender);
end;

procedure TGuiT1_2026.PrintRBtnClick(Sender: TObject);
Var I : integer;
begin
  If ButtonInactive then exit;
  SomeList.Clear; // := TStringList.Create;
  SomeCaption := 'Print';
  SomeList.Add('Current Page');
  SomeList.Add('Current Form');
  SomeList.Add('Current Return');
 SelectedString := PopSomeList(SomeList, SomeCaption);
  //SomeList.Free;
  If SelectedString = '' then exit;
  {PrintDialogItem.Options := [poWarning];}
  If SelectedString = 'Current Page' then CurrentPage1Click(Sender)
  else If SelectedString = 'Current Form' then PrintForm1Click(Sender)
  else if SelectedString = 'Current Return' then
      PrintCurrentReturn1Click(Sender);
end;


procedure TGuiT1_2026.ToolBarBtnClick(Sender: TObject);
begin
EXIT;   //20180130
 ToolBarSw := not ToolBarSw;
  If ToolBarSw then begin ToolBarBtn.Glyph.LoadFromFile(AppDir+'\'+'SwitchOn.BMP');
                    ToolBarSw := True; ToolBar.Height := 75;end
  else
   begin
   ToolBarBtn.Glyph.LoadFromFile(AppDir+'\'+'SwitchOf.BMP');
   ToolBarSw := false;
   ToolBar.Height :=ToolBar.Height div 2+3+1;
   end;

end;

procedure TGuiT1_2026.ImportBtnClick(Sender: TObject);
begin
  If OptRec.RolloverProgram = '' then
  begin
    ShowMessage('Please enter Last year' + Chr(39) + 's program name in' +Chr(13) +
                'Configure | General Options | Data Directories');
    Exit;
  end;
  SelectedString:=OptRec.RolloverProgram;
  If LeftStr(SelectedString,6) = 'Visual' then
     ImportLastYearClick(Sender)
  else If LeftStr(SelectedString,7) = 'Profile' then
     RollForwardfromgreenPoint1Click(Sender)
  else If LeftStr(SelectedString,6) = 'CanTax' then
     RollForwardfromCanTaxT120011Click(Sender)
end;

procedure TGuiT1_2026.AboutItemClick(Sender: TObject);
begin
  ShowAbout;
end;

procedure TGuiT1_2026.CloseBtnClick(Sender: TObject);
begin
  FileCloseItemClick(Sender);
end;

procedure TGuiT1_2026.ClrCustomClick(Sender: TObject);
var
  Clr : Tcolor;
begin
  if ColorDialog1.Execute then begin
    Clr := ColorDialog1.Color;
    IF CLR = clBlack then
      exit;
    clrcustom.Color := clr;
    Clr0Click(clrcustom);
  end;
end;

procedure TGuiT1_2026.clr0Click(Sender: TObject);
begin
 If ButtonInactive then exit;
  MainForm.clrClick(RetNo, Sender, c_ReturnColorElm); //20170219 Igor
end;

Procedure TGuiT1_2026.InitColorPanel;
begin
  Clr0.Color := ColorList[0];
  Clr1.Color := ColorList[1];
  Clr2.Color := ColorList[2];
  Clr3.Color := ColorList[3];
  Clr4.Color := ColorList[4];
  Clr5.Color := ColorList[5];
  Clr6.Color := ColorList[6];
  Clr7.Color := ColorList[7];
  Clr8.Color := ColorList[8];
  Clr9.Color := ColorList[9];
  Clr10.Color := ColorList[10];
  Clr11.Color := ColorList[11];
end;

procedure TGuiT1_2026.InitialDB;
begin
end;

procedure TGuiT1_2026.clr1Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TGuiT1_2026.clr2Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TGuiT1_2026.clr3Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TGuiT1_2026.clr4Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TGuiT1_2026.clr5Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TGuiT1_2026.clr6Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TGuiT1_2026.clr7Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TGuiT1_2026.clr8Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TGuiT1_2026.clr9Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TGuiT1_2026.clr10Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TGuiT1_2026.clr11Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TGuiT1_2026.OpenbyFileName1Click(Sender: TObject);
var
  FullFlName:String;FlName,Dir,Sin:String;
begin
{
//20171031 igor>>>
  if StartParams.isCloud then
  begin
    MessageDlg(c_NotAvailable, mtInformation, [mbOk], 0);
    Exit;
  end;
//20171031 igor<<<
} 
  //20181130 Igor >>>
  if CheckIsCloud(true) then
  begin
    Dir := OptRec.Dir_Cur;
    FlName := '';
    if not ChooseFile(Dir, FlName) then Exit;
    OpenReturnCoupled(Dir,FlName, True);
    Done;
    Exit;
  end;
  //20181130 Igor <<<

  OpenDialog.InitialDir := OptRec.Dir_Cur;
  If OpenDialog.Execute then
  begin
    FullFlName :=OpenDialog.FileName;
    FlName:=ExtractFileName(FullFlName);
    Dir := ExtractFileDir(FullFlName);
    OpenReturnCoupled(Dir,FlName, True); //assume always visible
    Done;
  end;
end;

procedure TGuiT1_2026.Calendar1Click(Sender: TObject);
begin
GetCalendar;
end;

procedure TGuiT1_2026.CallExecuteForm(AFormID: Integer); //20170628 Igor
var
  C: TFormClass;
begin
  case AFormID of
    EF_OPTIONS:
      C := TOptionsFrmT1_2026;
  else
    C := nil;
  end;
  if C <> nil then
      ExecuteForm(C);
end;

procedure TGuiT1_2026.ClientLetter1Click(Sender: TObject);
begin
  ShowLetterEditor(RetNo);
end;

procedure TGuiT1_2026.PrintForm1Click(Sender: TObject);
//20171031 igor>>>
Var
  i: integer;
  PDF: TvtPDFPrinter;
begin
  if ButtonInactive then
    exit;
  if Ret[RetNo].IsLastYearReturn then
    Exit; //20110227
  FastPrint := True; //20160905 Con  // //GetFastPrintIndicator; //False; //20160901 Igor
  try
    CountDiagnostics(RetNo);
    if Ret[RetNo].MandatoryErrorCount + Ret[RetNo].SeriousErrorCount > 0 then
    begin
      if not MainForm.WizardPanel.visible then
        MainForm.AuditOpenBtnClick(Application);
      MessageDlg('Return has errors. Please fix before printing/filing', mtWarning, [mbOk], 0);
    end;

    if not AllowedToFormPrint(RetNo, FormName) then
      exit;
    if CheckIsCloud(true) then //20180503 Igor
    begin
      PDFFullfileName := TPath.Combine(AppDir, 'tmp' + TPath.DirectorySeparatorChar + TPath.GetGUIDFileName + '.pdf');
      if not ForceDirectories(ExtractFileDir(PDFFullfileName)) then
      begin
        MessageDlg('Can not create temp folder', mtError, [mbOk], 0);
        Exit;
      end;
      PDF := TvtPDFPrinter.Create(AppT1_2026);
      try
        PDF.PrintForm(RetNo, FormName, 99, T1_2026Print.AfterReadComponentForPrint,
            T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
            T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);

        PDF.SaveToFile(PDFFullfileName, false);
        OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
      finally
        PDF.free;
      end;
    end
    else
    begin
      try
        if PrintDialogItem.Execute then
        begin  //20220220
          //if (Ret[RetNo].Province='YT') and (FormName='S11PRV') then FormName='S11PRVYT');
          StartPrintForm(RetNo, FormName, 99);
        end;
      finally

      end;
    end;
  finally
    if Printer.Printing then //20160905 Igor
      Printer.EndDoc;        //20160905 Igor

    FastPrint := False; //20160901 Igor
  end;
//20171031 igor<<<
end;

procedure TGuiT1_2026.StartPrintForm(Retno:integer;FormName:String;WhichPage:integer);
var
  OwnProgress: Boolean; //20160905 Igor
begin
//   Progress.Show;  {Show progress window} //20160905 Igor
   AbortSw := False;  {Initialize}
   PauseSw := False;
   if not Progress.visible then //20160905 Igor
   begin
     OwnProgress := True;
     Progress.Show;  {Show progress window} //20160905 Igor
     Progress.Caption := 'Print progress...';
     Progress.Label1.Caption := 'Printing Return:';
     Progress.Label2.Caption := GetRetName(RetNo);
     Progress.ListBox1.Visible := false;
     Progress.Gauge1.Visible := false;
    { Progress.BiGauge1.Visible := false;}
     Application.ProcessMessages;  {allows abort click on progrees screen }
   end
   else
     OwnProgress := False; //20160905 Igor
   If AbortSw then
    begin
       Progress.Close;
       If Printer.Printing then
         begin Printer.Abort; {Printer.EndDoc;}exit;end; //20160910 Igor
       if MessageDlg('Printing interrupted by operator'+
          Chr(13)+'Review pending Print Manager jobs?',
          mtInformation, [mbYes, mbNo], 0) = mrYes then
          PrintManager1Click(Application);
       exit;
    end;
    if OwnProgress then //20160905 Igor
    begin
      Progress.Label3.Caption := 'Form Name:';
      Progress.Label4.Caption := FormName;
      Progress.Label5.Caption := '';
      Progress.Label6.Caption := '';
      Progress.Refresh;
    end;
    If not IsFormMultipage(FormName) then
        Calc(RetNo,FormName)
    else
        CalcMultiPageForm(RetNo,FormName);
    Try
    PrintForm(RetNo,FormName,WhichPage,'');
    except on e: Exception do ExceptMsg(e);
    end;
//  If Printer.Printing then //20160831 Igor //20160905 Igor
//    Printer.EndDoc;        //20160831 Igor //20160905 Igor
    if OwnProgress then //20160905 Igor
      Progress.Close;
end;

procedure TGuiT1_2026.StartVirtualMeeting_OfficeClick(Sender: TObject); //20210203 Igor
begin
  actStartVirtualMeetingVTO.Execute;
end;

procedure TGuiT1_2026.BatchPrinting1Click(Sender: TObject);
begin
 if IsAuthorizedPreparer=False then Exit;  //20190401 //reloc from below
 If RetInMem>0 then
  begin ShowMessage('Please close all returns first'); exit;end;
  ClientsBatch('Print', 'Ready To Print');
end;

procedure TGuiT1_2026.CopyReturns1Click(Sender: TObject);
begin
  ClientsBatch('Copy', 'All Clients');
end;

procedure TGuiT1_2026.MoveReturns1Click(Sender: TObject);
begin
  ClientsBatch('Move', 'All Clients');
end;

procedure TGuiT1_2026.DeleteReturns1Click(Sender: TObject);
begin
  ClientsBatch('Delete', 'All Clients');
end;

procedure TGuiT1_2026.PrintFBtnClick(Sender: TObject);
begin
  PrintForm1Click(Sender);
end;

procedure TGuiT1_2026.CreateRTU1Click(Sender: TObject);
Var s,EFileDir, EncDir:String;
begin
 EFileDir   := LTRIM(RTRIM(OptRec.EF_DataDir));
 EncDir     := LTRIM(RTRIM(OptRec.EF_EncDir));

 s:=GetAnyPathMoreThan8Chars(OptRec.Dir_Cur);
 If s>'' then
 begin
  ShowMessage('Sub-path name '+ Chr(39)+S+Chr(39) +' should be reduced to 8 characters max');
  exit;
 end;

 If not DirectoryExists(EfileDir) then
   begin
    ShowMessage('Efile directory '+EfileDir +' does not exist');
    exit;
   end;


 If (OptRec.Ef_PrepNo = '') or
    (OptRec.Ef_TransNo = '') or
    (OptRec.Ef_PsWord = '') or
    (OptRec.Ef_EncDir = '') or
    (OptRec.Ef_TransNo = '') or
    (OptRec.Ef_TransNo = '') or
    (OptRec.Ef_TransNo = '') then
   begin
   ShowMessage('Missing Proprietary EFile set up data. Please complete them first');
   exit;
   end;

  ClientsBatch('Create Efile RTU', 'EF Ready For EFILE');
end;

procedure TGuiT1_2026.CreateSENDRTU1Click(Sender: TObject);
begin
  ClientsBatch('Create SEND RTU', 'EF Ready For EFILE');
end;

procedure TGuiT1_2026.CreateDataDirectory1Click(Sender: TObject);
var s:sTring; //DataDir : string; //[60];Result : integer;ClickedOK: Boolean;
begin
{
//20171031 igor>>>
  if StartParams.IsDemo or StartParams.isCloud then
  begin
    MessageDlg(c_NotAvailable, mtInformation, [mbOk], 0);
    Exit;
  end;
//20171031 igor<<<
}
 if CheckIsCloud then Exit; //20180503 Igor
 If LicenseLevel in anyMulti then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;
 s:=CreateNewDataDir;
 If s>'' then
 begin
  SaveSingleOption('Dir_Cur',s);
  InitOptions;
 end;
end;



procedure TGuiT1_2026.PrintTemplates1Click(Sender: TObject);
begin
  ExecuteForm(TPrSetT1_2026);
end;

procedure TGuiT1_2026.FeeSchedule1Click(Sender: TObject);
begin
 If LicenseLevel in anyMulti then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;
// If RetInMem>0 then begin ShowMessage('Close all returns first');exit;end;
 Application.CreateForm(TFeesT1_2026,Fees);
 Fees.ShowModal;
 Fees.Free;
end;

procedure TGuiT1_2026.OpenSpecificTypes1Click(Sender: TObject);
begin
  ClientsBatch('Open', 'All');
end;

procedure TGuiT1_2026.OpentClientDocumentsfolder1Click(Sender: TObject);
begin
actCopyClientsFoldersExecute(Sender);  //20200322
end;

procedure TGuiT1_2026.Fonts1Click(Sender: TObject);
//var TempFont : TFont;
begin
  (*
   *)
end;

procedure TGuiT1_2026.OverrideText1Click(Sender: TObject);
begin
 (*
 *)
end;


procedure TGuiT1_2026.RemovecurrentreturnOverridesClick(Sender: TObject);
begin
  if ButtonInactive then exit;
  RemoveReturnOverrides(RetNo);
end;

procedure TGuiT1_2026.EFRejectBtnClick(Sender: TObject);
begin
  Openselectively1Click(Sender);
{OneStepCom;}
end;

procedure TGuiT1_2026.CouplBtnClick(Sender: TObject);
begin
//SetCurrentFieldOverrideClick(Sender);
end;

procedure TGuiT1_2026.OverrideBtnClick(Sender: TObject);
begin

{ShowOverridesClick(Sender);}
{SetCurrentFieldOverrideClick(Sender);}
end;

procedure TGuiT1_2026.DataDictionary1Click(Sender: TObject);
begin
  FixDbForm(AppDir, DictDBLite, DictTableLite, dbtDataDict); //20150918 Igor
end;

procedure TGuiT1_2026.EFErrorsMasterList1Click(Sender: TObject);
begin
  If ButtonInactive then exit;
  Application.CreateForm(TEFMErrorsT1_2026,EFMErrors);
  EFMErrors.ShowModal;
  EFMErrors.Free;
end;

procedure TGuiT1_2026.SICCodes1Click(Sender: TObject);
begin
  Application.CreateForm(TSICT1_2026,SIC);
  SIC.ShowModal;
  SIC.Free;
end;

procedure TGuiT1_2026.FinancialInstitutions1Click(Sender: TObject);
begin
  SomeCaption:='Financial Institutions';
  SomeLabel:='Used for predictive entry in T5, T3 and Sch. 4';
  SomeFile:='Banks.Txt';

  Application.CreateForm(TDFilesT1_2026,DFiles);
  DFiles.ShowModal;
  DFiles.Free;
end;

procedure TGuiT1_2026.DiagnosticsClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 MainForm.AuditOpenBtnClick(Sender);
 {If not AuditPanel.Visible then AuditBtnClick(Sender);}
end;

procedure TGuiT1_2026.SamplesBtnClick(Sender: TObject);
begin
  OptRec.Dir_Cur := OptRec.Dir_Sample;
  FileOpenItemClick(Sender);
end;

procedure TGuiT1_2026.T1BtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(RetNo,'T1',0);
end;

procedure TGuiT1_2026.PrintCurrentReturn1Click(Sender: TObject);
Var i,j: integer; FormsToPrint :TstringList;
    Copies, Template :string; //[30];
    s:String;
begin

 ////20260215 if not inJZtestmode then If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit;  //20251216

 If ButtonInactive then exit;
 If Ret[RetNo].IsLastYearReturn then Exit; //20110227
 if IsAuthorizedPreparer=False then Exit;  //20190401

 RecalcEverything(RetNo);
 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  If not MainForm.WizardPanel.visible then MainForm.AuditOpenBtnClick(Sender);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Not AllowedToFullPrint(RetNo) then begin PdfPrint:=False;exit;end;
 Calc(RetNo,'DIAGNO');
 //LetterType := 'Cover';
 If Ret[RetNo].CalcStatus = False then CalcAll(RetNo);
 UpdateAllDataIndicators(RetNo);
 If SlipsAvailable(RetNo) then Ret[RetNo].FormHasData['T4SUM#1'] := True;

 {
 //20200127
 ShowMessage('Tax Return printing is not reviewed  or approved by CRA yet.'
   +Chr(13)+'Please print for internal use only.');
 }
 Application.CreateForm(TPrintReturnFrmT1_2026,PrintReturnFrm);
 PrintReturnFrm.ShowModal;
 PrintReturnFrm.Free;
end;

Procedure TGuiT1_2026.FullPrint(RetNo:Integer;Template:String;Sender:TObject);
Var i,j: integer; FormsToPrint :TstringList;
    Copies : string; //[1];
begin
 If SlipsAvailable(RetNo) then Ret[RetNo].FormHasData['T4SUM#1'] := True;
 FormsToPrint := TstringList.Create;
 FormsToPrint.Sorted :=False;
 GetFormsToPrint(RetNo,Template,FormsToPrint);

 ResortFormsToPrint(FormsToPrint);

 If FormsToPrint.Count =0 then
    begin
    ShowMessage('Selected template has no forms for printing');
    FormsToPrint.Free;
    exit;
  end;

 if (Sender as TComponent).Name = 'SaveprintoutofreturninPDFformatinClientDocumentsfolder1' then
   PrintReturn(RetNo,FormsToPrint,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName)
 else
 begin
   If PrintDialogItem.Execute then
     PrintReturn(RetNo,FormsToPrint,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName);
 end;
 FormsToPrint.Free;
 PdfPrint:=False;
end;



procedure TGuiT1_2026.PrintReturn(RetNo:integer;FormsToPrint:TstringList;DataDir:string;FlName:string);
var i,j,FCopies:integer; FName :string; //[12];
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
      If AllTrim(Midstr(FormsToPrint[j],5,10))>'' then
       Progress.ListBox1.Items.Add(Midstr(FormsToPrint[j],5,10));  //20100113
     end;
   //If FastPrint = True then Printer.BeginDoc; //20160721 Igor
   NeedNewPage := False;
   for i :=0 to (FormsToPrint.Count - 1) do
   begin
      Application.ProcessMessages;  {allows abort click on progrees screen }
      If AbortSw then
      begin
       Progress.Close;

       If Printer.Printing then
       begin
         Printer.Abort;
         //Printer.EndDoc; //20160910 igor
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
        PrintForm(RetNo,FName,99,''); //PrintForm(RetNo,FName,1);
        //If UpperCase(GetAddBlankPg(FName))='Y' then PrintForm(RetNo,'BLANKPG',1,'');  // 20100210
        If GetAddBlankPg(FName) then PrintForm(RetNo,'BLANKPG',1,'');  // 20100210
        //20100210
       end;
      Progress.Gauge1.Progress :=i+1;
      Progress.Gauge1.Refresh;
   end;
   If Printer.Printing then Printer.EndDoc; //20160901 Igor
   NeedNewPage := False; //20160721 Igor
   Progress.Close;
   Ret[RetNo].Frm[GetFormNo('STATUS')].Strings[4] := '03';
   Ret[RetNo].PrpStatus :='03';
   UpdatePrintDate(RetNo,DataDir,FlName);
   Screen.Cursor := crDefault;
end;


Procedure TGuiT1_2026.UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
var FNo :integer;
(* //20170329 Igor
TempList :TStringList;
  FDConnection: TADConnection;
  Table1: TADTable;
  *)
begin
 FNo := GetFormNo('STATUS');
 Ret[RetNo].Frm[Fno].Strings[4] := '03';
 Ret[RetNo].Frm[Fno].Strings[8] := User.UserName;//20170811 Igor
 Ret[RetNo].Frm[Fno].Strings[9] := FormatDateTime('yyyy-mm-dd',Date);
 Ret[RetNo].Frm[Fno].Strings[10] := TimeToStr(Time);
 Ret[RetNo].Changed := True;
//20160411 Igor
// If FileExists(DataDir+'\'+FlName) then
// begin
//  TempList := TstringList.Create;
//  Templist.LoadFromFile(DataDir+'\'+FlName);
//  Templist.Add( 'F'+Delimiter+'STATUS'+Delimiter+Delimiter);
//  TempList.Add('D'+Delimiter+'4'+Delimiter+'03'+Delimiter);
//  TempList.Add('D'+Delimiter+'8'+Delimiter+UserName+Delimiter);
//  TempList.Add('D'+Delimiter+'9'+Delimiter+FormatDateTime('yyyy-mm-dd',Now)+Delimiter);
//  TempList.Add('D'+Delimiter+'10'+Delimiter+TimeToStr(Time)+Delimiter);
//  Templist.SaveToFile(DataDir+'\'+FlName);
//  TempList.Free;
// end;
//
// {now update the data base with RTU dates}
////20150826 igor
//  FDConnection := TADConnection.Create(nil);
//  Table1 := TADTable.Create(nil);
//  try
//    //20150925 igor
//    SetTableName(FDConnection, Table1, AppDir + '\' + ClientsDBLite, ClientsTableLite, 'FILE_NAME');
//
// if Table1.FindKey([FlName]) then
// begin
//  Table1.Edit;
//  Table1.FieldByName('Prp_Status').AsString := FetchElm(RetNo,'STATUS',4);
//  Table1.FieldByName('Printed_by').AsString := FetchElm(RetNo,'STATUS',8);
//  Table1.FieldByName('Printed_dt').AsString := FetchElm(RetNo,'STATUS',9);
//  Table1.FieldByName('Printed_tm').AsString := FetchElm(RetNo,'STATUS',10);
//  Table1.Post;
// end;
//  finally
//    FDConnection.Free;
//    Table1.Free;
//  end;
end;


(*
Procedure TGuiT1_2026.UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
var FNo :integer; TempList :TStringList;
  FDConnection: TADConnection;
  Table1: TADTable;
begin
 FNo := GetFormNo('STATUS');
 Ret[RetNo].Frm[Fno].Strings[4] := '03';
 Ret[RetNo].Frm[Fno].Strings[8] := UserName;
 Ret[RetNo].Frm[Fno].Strings[9] := FormatDateTime('yyyy-mm-dd',Date);
 Ret[RetNo].Frm[Fno].Strings[10] := TimeToStr(Time);
//20160411 Igor
// If FileExists(DataDir+'\'+FlName) then
// begin
//  TempList := TstringList.Create;
//  Templist.LoadFromFile(DataDir+'\'+FlName);
//  Templist.Add( 'F'+Delimiter+'STATUS'+Delimiter+Delimiter);
//  TempList.Add('D'+Delimiter+'4'+Delimiter+'03'+Delimiter);
//  TempList.Add('D'+Delimiter+'8'+Delimiter+UserName+Delimiter);
//  TempList.Add('D'+Delimiter+'9'+Delimiter+FormatDateTime('yyyy-mm-dd',Now)+Delimiter);
//  TempList.Add('D'+Delimiter+'10'+Delimiter+TimeToStr(Time)+Delimiter);
//  Templist.SaveToFile(DataDir+'\'+FlName);
//  TempList.Free;
// end;
//
// {now update the data base with RTU dates}
////20150826 igor
//  FDConnection := TADConnection.Create(nil);
//  Table1 := TADTable.Create(nil);
//  try
//    //20150925 igor
//    SetTableName(FDConnection, Table1, AppDir + '\' + ClientsDBLite, ClientsTableLite, 'FILE_NAME');
//
// if Table1.FindKey([FlName]) then
// begin
//  Table1.Edit;
//  Table1.FieldByName('Prp_Status').AsString := FetchElm(RetNo,'STATUS',4);
//  Table1.FieldByName('Printed_by').AsString := FetchElm(RetNo,'STATUS',8);
//  Table1.FieldByName('Printed_dt').AsString := FetchElm(RetNo,'STATUS',9);
//  Table1.FieldByName('Printed_tm').AsString := FetchElm(RetNo,'STATUS',10);
//  Table1.Post;
// end;
//  finally
//    FDConnection.Free;
//    Table1.Free;
//  end;
end;
*)


procedure TGuiT1_2026.CoupleBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  StartCoupling1Click(Sender);
end;

procedure TGuiT1_2026.AddinstanceofForm1Click(Sender: TObject);
Begin
(*
 If RetInMem <1 then exit;
 ShowMessage('Instance added = '+IntTostr(AddNextFormInstance(FormName)));
 *)
end;

procedure TGuiT1_2026.Line1Click(Sender: TObject);
begin
(*
*)
end;

procedure TGuiT1_2026.JacketClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(RetNo,'T1',0);
end;

procedure TGuiT1_2026.PADPreauthorizedDebit1Click(Sender: TObject);
begin

 //If UpperCase(InputBox('PAD will be available by CRA on Feb 20', 'PSW', '')) <> 'N/A' then exit;  //20200121
 // If UpperCase(InputBox('PAD functionality has been disabled until a subsequent version', 'PSW', '')) <> 'N/A' then exit; //20250315


  //20161201
  If ButtonInactive then Exit;
  //20170316  relocated from below
  //if (FetchElm(RetNo,'T183',27)='')

  //20170316
  GetEOLParms(OnlineNo,Password,Url,NetFileDir);
  If Length(OnlineNo)<>5 then
  begin
    ShowMessage('Efiler number not entered correctly. Please complete the Efile Online Setup');
    SetupEOL1Click(Sender);
    Exit;
  end;

  //20210220
  If (FetchElm(RetNo,'T185',15)='')
  Or (FetchElm(RetNo,'T185',14)='')
  then
  Begin
   ShowMessage('Please complete the PAD Payment date and Amount on the T185');
   //OpenForm*RetNo,'T183',
   Exit;
  End;

  //20170210
  if Ret[Retno].FrmHasData[GetFormNo('PADINFO')]=false then
  begin
   ShowMessage('Please complete the bank information on the PADInfo form first');
   OpenForm(RetNo,GetFormNo('PADINFO'),0);   //20170315
   Exit;
  end;


  //20170316
  If Ret[RetNo].SeriousErrorCount>0 then
  begin
    //20200421
     if MessageDlg('Return has important errors.'+
         Chr(13)+'The errors must be fixed before filing'+
         Chr(13)+'If you do not see the errors: Click the Audit tab on the left panel.'+
         Chr(13)+'Proceed anyway?',
         mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     //proceed
     Else
     exit;
  end;

 //-----------------
  Application.CreateForm(TT1PadT1_2026, T1PadT1_2026);
  T1PadT1_2026.ShowModal;
  T1PadT1_2026.Free;
end;

procedure TGuiT1_2026.PersonaldataClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(RetNo,'INFO',0);
end;

procedure TGuiT1_2026.TaxSummaryClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 OpenForm(RetNo,'TAXSUM',8);
end;

procedure TGuiT1_2026.SampleReturns1Click(Sender: TObject);
begin
 (*
 *)
end;

procedure TGuiT1_2026.FixTextoncurrentForm1Click(Sender: TObject);
begin
 (*
 *)
end;

procedure TGuiT1_2026.FixDataDictionary1Click(Sender: TObject);
begin
  FixDbForm(AppDir, DictDBLite, DictTableLite, dbtDataDict); //20150918 Igor
end;

procedure TGuiT1_2026.FixFormSpecifications1Click(Sender: TObject);
begin
  //20150918 Igor
  FixDbForm(AppDir, FormsDBLite, FormsTableLite, dbtForms); // 'T1Scr.db f';
  SaveFormsTableToFile; //Scr.d used in InitFormsTable!
  InitFormsTable;
end;

procedure TGuiT1_2026.FixClientDataBaseData1Click(Sender: TObject);
begin
 //20150826 igor
 // FixDbForm(OptRec.Dir_Cur, ClientsTable, dbtClients);
end;

procedure TGuiT1_2026.ShowCellNumbers1Click(Sender: TObject);
begin
  MainForm.ShowCellNumbers1Click(actShowCellNumbers);//20170907 Igor
end;

procedure TGuiT1_2026.Operational1Click(Sender: TObject);
begin
  Application.CreateForm(TDeskTopT1_2026,DeskTop);
  DeskTop.ShowModal;
  DeskTop.Free;
end;


procedure TGuiT1_2026.ChangeDataDirectory1Click(Sender: TObject);
begin
{
//20171031 igor>>>
  if StartParams.IsDemo or StartParams.isCloud then
  begin
    MessageDlg(c_NotAvailable, mtInformation, [mbOk], 0);
    Exit;
  end;
//20171031 igor<<<
}
 if CheckIsCloud then Exit; //20180503 Igor
 If LicenseLevel in anyMulti then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;
 ExecuteForm(TOptionsFrmT1_2026);
//DataDirectories1Click(Sender);
end;

procedure TGuiT1_2026.ChangeDocumentfolder1Click(Sender: TObject); //20210115 Igor
var cFolder: string;
begin
  cFolder := OptRec.Dir_ClientDocs;
  if SelectDirectory('Choose Folder', '', cFolder) then
  begin
    OptRec.Dir_ClientDocs := cFolder;
    SaveSingleOption('Dir_ClientDocs', cFolder);
  end;
end;

procedure TGuiT1_2026.StartCoupling1Click(Sender: TObject);
Var
  i,CurRetNo,RNo : Integer;s:String;
Begin
 if ButtonInactive then exit;
 If Ret[RetNo].CouplingSw = True then
 begin
   if not Assigned(SomeList) then
     SomeList := TStringList.Create; //20160227 Igor
   SomeList.Clear; // := TStringList.Create;
   SomeCaption := 'Already in Family Coupling mode!  Select option...';
   SomeList.Add('0 No action');
   SomeList.Add('1 Revise family setup');
   SomeList.Add('2 Stop coupling');
   SelectedString := PopSomeList(someList, SomeCaption);
   //SomeList.Free; //20160227 Igor
   If SelectedString > '' then
   begin
    If LeftStr(SelectedString,1)='1' then ClearForm(RetNo,'FAMSET')
    Else If LeftStr(SelectedString,1)='2' then
      begin EndCoupling1Click(Sender);OpenForm(RetNo,FormNo,0);exit;end
    Else Exit;
   end
   else
    Exit;
 end;

 If Ret[RetNo].MandatoryErrorCount>0 then
 begin
   If not MainForm.LeftPanel.Visible then MainForm.AuditOpenBtnClick(Sender);
   ShowMessage('Mandatory(M) items must be fixed before coupling');
   exit;
 end;

 CurRetNo := RetNo;

 //single parent
 If Ret[RetNo].MarStatus>2 then
 begin
  If Ret[RetNo].FormHasData['DEPEND']=false then
  begin
   ShowMessage('Coupling can start only from the return of a married person');
   Exit;
  end;
  Application.CreateForm(TCoupleT1_2026,Couple);
  Couple.ShowModal;
  Couple.OkBtnClick(Application);
  Couple.Free;
  Exit;
 end;


 If RetInMem <1 then
  begin ShowMessage('You must open a spousal return first' +Chr(13)+
  'and complete the dependants form');
  exit;
  end;


  If (Ret[RetNo].MarStatus >2) then
  begin
   ShowMessage('Coupling can only start from a spousal return (Married/Common-law)'
     +Chr(13)+'You need to complete:'
     +Chr(13)+'Spouse SIN, Name and'
     +Chr(13)+'BirthDate on the Info form');
   exit;
  end;


 {find a spouse to start coupling}
 If (Ret[RetNo].MarStatus <3) then
   RNo := RetNo
 else
   RNo := FindAnySpouseRetNo;

 If RNo =0 then
 begin
    ShowMessage('Cannot couple. Current return must be a spouse (Married/Common-law');
    exit;
 end;


 If FetchElm(RetNo,'INFO',4) ='' then
 begin
  ShowMessage('Spouse SIN required on Info page');
  OpenForm(RetNo,'INFO',4);
  exit;
 end;

 If FetchElm(RetNo,'INFO',20) ='' then
 begin
  ShowMessage('Spouse First name required on the Info page');
  OpenForm(RetNo,'INFO',20);
  exit;
 end;

 If FetchElm(RetNo,'INFO',59) ='' then
 begin
  ShowMessage('Spouse birthdate required on Info page');
  OpenForm(RetNo,'INFO',59);
  exit;
 end;

 //RetNo :=RNo;  {? not enough to switch, unless I open a form}
 //OpenForm(CurRetNo,GetFormNo('INFO'),0); {dec 1}

 Application.CreateForm(TCoupleT1_2026,Couple);

 Couple.ShowModal;
 Couple.Free;
end;

procedure TGuiT1_2026.EndCoupling1Click(Sender: TObject);
Var RNo,i:Integer;CouplingSins:TStringList;
begin
 If ButtonInactive then exit;

  Ret[RetNo].CouplingSw := False;
  //other members in coupling
  CouplingSins:=TStringList.Create;
  GetCouplingSins(RetNo,CouplingSins);
  For i:=0 to CouplingSins.Count-1 do
  begin
   RNo:=GetRetNoFromSin(CouplingSins[i]);
   If RNo>0 then
   begin
    {20110202
    //20100424 //means current year return
    If (Ret[RetNo].LastYearRetNo > 0)
    and (Ret[RetNo].LastYearData = True)
    then
    }
      Ret[RNo].CouplingSw := False;   //if last year do not???
   end;
  end;
  CouplingSins.free;

 MainForm.FormPaint(Sender);
end;

procedure TGuiT1_2026.LoadSpousalReturnfromdatabaseCreate1Click(Sender: TObject);
begin
If ButtonInactive then exit;
end;

procedure TGuiT1_2026.SwapBtnClick(Sender: TObject);
begin
 //If ButtonInactive then exit;
 SwapReturns1Click(Sender);
end;

procedure TGuiT1_2026.SwapReturns1Click(Sender: TObject);
Var RetNo,PrevRNo,PrevFNo :integer;
begin
 if ButtonInactive then exit;
 RetNo := FRetNo; //DoDi: copy into local var

  If RetInMem(AppT1_2026, True) < 2 then  //20161216 Igor //20170307 Igor
  begin
   ShowMessage('To swap, you must have 2 or more returns in memory');
   exit;
  end;
  PrevRNo := RetNo;
  PrevFNo:= FormNo;

  If RetInMem(AppT1_2026, True) = 2 then  //20161216 Igor //20170307 Igor
   RetNo := GetNextReturn(RetNo, True) //20170307 Igor
  else
   RetNo := SelectFromLoadedReturns(RetNo, True); //20170307 Igor
  LockWindowUpdate(MainForm.Handle);
  CalcFullReturn(RetNo);
//  If Ret[RetNo].IsLastYearRetNo then PrevFNo:=GetLastYearFormNo(FormName); //20110220
  If PrevFNo=42 then   //taxsum
    OpenForm(RetNo, PrevFNo,8)
  else
   OpenForm(RetNo, PrevFNo,0);
  If MainForm.LeftPanel.Visible then MainForm.RefreshAuditPanel(RetNo);
  LockWindowUpdate(0);
end;

procedure TGuiT1_2026.Switchforms1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 vtChild.SwitchForms;
end;

procedure TGuiT1_2026.SwapFrmClick(Sender: TObject);
begin
 Switchforms1Click(Sender);
end;

procedure TGuiT1_2026.FormsBtnClick(Sender: TObject);
begin
 //LetterType := 'Cover';
 SelectFormClick(Sender);
end;

procedure TGuiT1_2026.UserSetUp1Click(Sender: TObject);
begin
  Application.CreateForm(TUserSetupT1_2026,UserSetUp);
  UserSetUp.ShowModal;
  UserSetUp.Free;
end;

procedure TGuiT1_2026.CashReports1Click(Sender: TObject);
begin
  {If Not FeatureAllowed then exit;}
  Application.CreateForm(TCashRepT1_2026,CashRep);
  CashRep.ShowModal;
  CashRep.Free;
end;

procedure TGuiT1_2026.TipsBtnClick(Sender: TObject);
begin
  Tips1Click(Sender);
end;

procedure TGuiT1_2026.Tips1Click(Sender: TObject);
begin
  ExecuteForm(TTipT1_2026);
end;

procedure TGuiT1_2026.EFErrorBtnClick(Sender: TObject);
begin
 EFErrorsMasterList1Click(Sender);
end;

procedure TGuiT1_2026.CopyForm1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
  CopyFrm(RetNo, FormName);
end;

(*
procedure TGuiT1_2026.CopyFormasPDF1Click(Sender: TObject);
begin
  If ButtonInactive then exit;
  //----------------------------
  Dir := TPath.Combine(optRec.Dir_ClientDocs, GetLastName(retNo) + ','+ GetFirstName(retNo));//20171031 igor
  ForceDirectories(Dir);
  FlName:=GetLastName(retNo) + ','+ GetFirstName(retNo)+'-'+FormName;
  SaveDialog.Title    := 'Save to PDF';
  SaveDialog.InitialDir := Dir;
  SaveDialog.Filter :=  'PDF|*.pdf';
  SaveDialog.FileName :=FlName;
  SaveDialog.DefaultExt := '.pdf';
  SaveDialog.Options := [ofOverwritePrompt,ofPathMustExist];
  PDFFullfileName := SaveDialog.FileName;
  PrintForm1Click(Sender);

   If not SaveDialog.Execute then exit;
  //PDFFullfileName := SaveDialog.FileName;

  //20180503 Igor <<<
  //PrintBtnClick(Sender);
  //20170310 Igor >>>
  //if chbAutoSaveToMobileDB.Checked then SilentAddFile(AppT1_2026, RetList[GetCurrentRetNo].SourceFlName, PDFFullfileName); ???
  //20170310 Igor <<<

  if MessageDlg('Return printout has been saved in "' + PDFFullfileName + '".'+#13+
                'Review it?', mtInformation, [mbYes, mbCancel], 0) = mrYes then
    OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
  exit;
end;
*)
procedure TGuiT1_2026.CopyBtnClick(Sender: TObject);
begin
  CopyForm1Click(Sender);
end;

procedure TGuiT1_2026.RSumBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 CalcAll(RetNo);
 Application.CreateForm(TRetSumT1_2026,RetSum);
 RetSum.ShowModal;
 RetSum.Free;
end;

procedure TGuiT1_2026.DataBaseAnalyser1Click(Sender: TObject);
begin
 If RetInMem>0 then begin ShowMessage('Please close all returns first'); exit;end;
  SomeCaption := 'Client Data Base Analyser';
  Application.CreateForm(TAnalyseT1_2026,Analyse);
  Analyse.ShowModal;
  Analyse.Free;
end;

procedure TGuiT1_2026.SchedBtnClick(Sender: TObject);
Var I:integer;
begin
  if ButtonInactive then exit;
  //If RetNo < 1 then exit; //which retNo???
  SomeList.Clear; // := TStringList.Create;
  SomeCaption := 'Schedules';
  for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];
      If Frec.FormType = 'SC' then
      SomeList.Add(Frec.FormInstName);
   end;
   SelectedString := PopSomeList(someList, SomeCaption);
  If SelectedString = '' then exit;
end;

procedure TGuiT1_2026.ImportLastYearClick(Sender: TObject);
begin
  {
  ShowMessage('Batch rollover (all returns) is not enabled in this early version.'
      +Chr(13)+'as the data forms are still evolving.'
      +Chr(13)+Chr(13)+'Just rollover one at a time');
  }
  if not OptRec.ValidLastYearDataFolder then
    exit;
  if not fileexists(OptRec.Dir_LastYr+'\' + OptRec.ClientsDBLite) AND
     not fileexists(OptRec.Dir_LastYr+'\' + ClientsTable_dbf) then
  Begin
      ShowMessage('Last Year'+Chr(39)+'s directory does not have a VisualTax Client data base'
                  +Chr(13)+'See Configure | General Options | Data Directories');
  End;
  MainForm.GuiCommand(gcHideLastYear);
  FRetNo := Import();
  MainForm.RefreshAuditPanel(RetNo);
  If MainForm.FormsPanel.Visible then
    MainForm.RefreshFormsPanel(RetNo);
end;

procedure TGuiT1_2026.FrmSumBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 OpenForm(RetNo,'BSUM',0);
end;

procedure TGuiT1_2026.TSumBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 Screen.Cursor:=CrHourGlass;
 CalcAll(RetNo);
 RecalcEverything(RetNo);
 Screen.Cursor:=CrDefault;
 OpenForm(RetNo,'TAXSUM',8);
end;

procedure TGuiT1_2026.EFileBtnClick(Sender: TObject);
begin
  EOLClick(Sender);
end;

Procedure TGuiT1_2026.ShowMultiOfficeMsg;
begin
 ShowMessage('This option is available only to firms'+Chr(13)+
   'with Multi-operator and/or Multi-office operations');
end;

procedure TGuiT1_2026.UserSetUp2Click(Sender: TObject);
begin
  If not(LicenseLevel in anyMulti) then
  begin
   ShowMultiOfficeMsg;
   exit;
  end;

  If YouKnowTheAdminPassword = false then
  begin
    ShowMessage('Only the Administrator can perform this function');
    exit;
   end;

  //20170112 Igor >>>
  ExecuteForm(TfrmvtUsers);
//  Application.CreateForm(TUserSetupT1_2026,UserSetUp);
//  UserSetUp.ShowModal;
//  UserSetUp.Free;
  //20170112 Igor <<<
end;

procedure TGuiT1_2026.HelpBtnClick(Sender: TObject);
Var HelpTopic:String;
begin

  if (RetInMem(AppT1_2026) > 0) and
     (RetList[GetCurrentRetNo] <> nil) and
     (RetList[GetCurrentRetNo].MyChild <> nil) and
     (RetList[GetCurrentRetNo].MyChild.ActiveForm <> nil) then
   begin
    HelpTopic:=StripInstNo(ExtractFormRootName(RetList[GetCurrentRetNo].MyChild.ActiveForm.FormName));
    ConnectToWeb(HelpRoot+'?'+HelpTopic);
      //+StripInstNo(ExtractFormRootName(RetList[GetCurrentRetNo].MyChild.ActiveForm.FormName)))
   end
   // ShowHelp(AppT1_2026.ModuleHelpFile, StripInstNo(ExtractFormRootName(RetList[GetCurrentRetNo].MyChild.ActiveForm.FormName)), True)
  else
   ConnectToWeb(HelpRoot); //20171215  CON
   // ConnectToWeb('www.visualtax.com/Vt2017HELP/T1Help/Website/T1Help.html'); //20171215
   // ShowHelp(AppT1_2026.ModuleHelpFile, 'HELP_CONTENTS', True);

   //20161220 Igor <<<
{
If RetInMem>0 then
 if not ButtonInactive(False) then //20160714 Igor
   ShowHelp('T1Help', StripInstNo(ExtractFormRootName(FormName)))
 else
  ShowHelp('T1Help','HELP_CONTENTS');
 }
(*
Var HlpContextString :string;
begin
 //If RetInMem>0 then
 if not ButtonInactive then
 begin
   HlpContextString := StripInstNo(ExtractFormRootName(FormName));
   ShowHelp(AppT1_2026.ModuleHelpFile, HlpContextString, True);//20161220 Igor
 end
 else
  ShowHelp(AppT1_2026.ModuleHelpFile, 'HELP_CONTENTS', True);//20161220 Igor
*)
end;

procedure TGuiT1_2026.Calculator1Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'Calc.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TGuiT1_2026.Appointments2Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'Calendar.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TGuiT1_2026.TransmitRTU1Click(Sender: TObject);
begin
{
}
end;

procedure TGuiT1_2026.Contents2Click(Sender: TObject);
begin
  ShowHelp(AppT1_2026.ModuleHelpFile,'HELP_CONTENTS', True); //20161220 Igor
end;

procedure TGuiT1_2026.Convertoptionsfromoldversion1Click(Sender: TObject);
begin
 //not in use in 2017 or later
 // ConvertToMultiApp(AppT1_2026, true);
end;

procedure TGuiT1_2026.SearchForHelpOnClick(Sender: TObject);
begin
 ShowHelp(AppT1_2026.ModuleHelpFile, 'HELP_CONTENTS', True); //20161220 Igor
end;

procedure TGuiT1_2026.SearchFormSelect(
  const Args: TUICommandCollectionEventArgs); //20190415 Igor
    procedure AddToItems(AText: string; ACommand: TUICommandCollection);
    var Item: TUIGalleryCollectionItem;
        I: integer;
        bFound: boolean;
    begin
      bFound := false;
      for I := 0 to ACommand.Items.Count - 1 do
        if SameText(TUIGalleryCollectionItem(ACommand.Items.Items[I]).LabelText, AText) then
        begin
          bFound := true;
          break;
        end;
      if not bFound then
      begin
        Item := TUIGalleryCollectionItem.Create;
        Item.LabelText := AText;
        ACommand.Items.Add(Item);
      end;
    end;
begin
  if Args.Command = FSearchForm1 then
  begin
    SearchStr := FSearchForm1.Text;
    if Assigned(FSearchForm2) then
      FSearchForm2.Text := FSearchForm1.Text;
  end
  else if Args.Command = FSearchForm2 then
  begin
    SearchStr := FSearchForm2.Text;
    if Assigned(FSearchForm1) then
      FSearchForm1.Text := FSearchForm2.Text;
  end;
  if Assigned(FSearchForm1) then
    AddToItems(SearchStr, FSearchForm1);
  if Assigned(FSearchForm2) then
    AddToItems(SearchStr, FSearchForm2);
  actFindFormExecute(nil);
end;

procedure TGuiT1_2026.HelpByVisualTax1Click(Sender: TObject); //20160216 Igor
begin
   //20160211
 ConnectToWeb('www.visualtax.com/Autofill-Guide.pdf');  //20160211
end;



procedure TGuiT1_2026.LineByLinehelp1Click(Sender: TObject);
Var HelpTopic:String;
begin
  ShowMessage('Use Ctrl F to enter and search each line or other item of the T1 Guide');
  ShowPdf(AppDir,'5000-g-24e.pdf');     //20241118
//  ShowPdf(AppDir,'https://www.canada.ca/content/dam/cra-arc/formspubs/pub/5000-g/5000-g-23e.pdf');
  Exit;
  {
  HelpTopic :='Line_101';
  ConnectToWeb(HelpRoot+'?'+HelpTopic);  //20171215 COn
 // ShowHelp(AppT1_2026.ModuleHelpFile, HelpTopic, True); //20161220 Igor
 }
end;

procedure TGuiT1_2026.VirtualClientsandAppointments_OfficeClick( //20210430 Igor
  Sender: TObject);
begin
  VirtualTaxOfficeInfo.ShowVirtualClientsAndAppointments;
end;

procedure TGuiT1_2026.VirtualOfficeIntro1Click(Sender: TObject);
begin
 ConnectToWeb('https://www.visualtax.com/voVirtualOfficeIntro.php');  //20210113
end;

procedure TGuiT1_2026.VisualTaxDemoGuide1Click(Sender: TObject);
Var HelpTopic:String;
begin
 ShowMessage('Use only for general operational help');
 ConnectToWeb('https://www.visualtax.com/Vt2021HELP/T1Help/Website/T1Help.html');
{
  if (RetInMem(AppT1_2026) > 0) and
     (RetList[GetCurrentRetNo] <> nil) and
     (RetList[GetCurrentRetNo].MyChild <> nil) and
     (RetList[GetCurrentRetNo].MyChild.ActiveForm <> nil) then
   begin
    HelpTopic:=StripInstNo(ExtractFormRootName(RetList[GetCurrentRetNo].MyChild.ActiveForm.FormName)); //+'.html';
    ConnectToWeb(HelpRoot+'?'+HelpTopic);
      //+StripInstNo(ExtractFormRootName(RetList[GetCurrentRetNo].MyChild.ActiveForm.FormName)))
   end
   // ShowHelp(AppT1_2026.ModuleHelpFile, StripInstNo(ExtractFormRootName(RetList[GetCurrentRetNo].MyChild.ActiveForm.FormName)), True)
  else
   ConnectToWeb(HelpRoot); //20171215  CON
   // ConnectToWeb('www.visualtax.com/Vt2017HELP/T1Help/Website/T1Help.html'); //20171215
   // ShowHelp(AppT1_2026.ModuleHelpFile, 'HELP_CONTENTS', True);
}
   //20161220 Igor <<<
{
If RetInMem>0 then
 if not ButtonInactive(False) then //20160714 Igor
   ShowHelp('T1Help', StripInstNo(ExtractFormRootName(FormName)))
 else
  ShowHelp('T1Help','HELP_CONTENTS');
 }
end;

procedure TGuiT1_2026.AlertsNotifications1Click(Sender: TObject);
begin
 ConnectToWeb('https://www.visualTax.com/vtAlert.html'); //20210701 Con
 //ConnectToWeb('www.VisualTax.com/vtAlert.html');  //20170405
end;

procedure TGuiT1_2026.Allforms1Click(Sender: TObject);
Var I:integer;
begin
 If ButtonInactive then exit;
// ShowFieldIdSw := True;
 If PrintDialogItem.Execute then
 begin
   for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      If FRec.FormInst < '#2' then
      begin
          If (Frec.FormName ='ALETTER')  //20101208
          or (Frec.FormName ='CLETTER')
          or (Frec.FormName ='ENGAGE')
          or (Frec.FormName ='PIPEDA')
          or (Frec.FormName ='BARCODE')
          or (Frec.FormName ='BLANKPG')
          or (Frec.FormName ='CUSTINV')
          or (Frec.FormName ='LABELS3')
          then  //20101208
           //skip
          Else
          begin
            //ShowMessage(Frec.FormName);   //20101209
            PrintForm(RetNo,Frec.FormInstName,99,'');
          end;
      end;
    end;
 end;
end;

procedure TGuiT1_2026.EFileerrorsCurrentReturn1Click(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(RetNo,'STATUS',0);
end;

procedure TGuiT1_2026.MultipleDnBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenPrevInstance(RetNo, FormName);
end;

procedure TGuiT1_2026.MultipleUpBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenNextInstance(RetNo, FormName);
end;

procedure TGuiT1_2026.Restructure1Click(Sender: TObject);
begin
(*
Application.CreateForm(TRestruct,Restruct);
Restruct.ShowModal;
Restruct.Free;
*)
end;

procedure TGuiT1_2026.DependBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(RetNo,'DEPEND',0);
end;

procedure TGuiT1_2026.ABCBtnClick(Sender: TObject);
begin
 AlphabeticalFormsIndex1Click(Sender);
end;

procedure TGuiT1_2026.BusnBtnClick(Sender: TObject);
begin
{
If ButtonInactive then exit;
 BatchOper := 'Open';
 CfgRec.Opr_Fpres := 0;
 Application.CreateForm(TFrmPick,FrmPick);
 FrmPick.ShowModal;
 FrmPick.Free;
}
end;

procedure TGuiT1_2026.buttonAvailableWidthClick(Sender: TObject);
begin
  MainForm.GuiCommand(gcAvailableWidth);
end;

procedure TGuiT1_2026.PrintManager1Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'PrintMan.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TGuiT1_2026.ClientLetters1Click(Sender: TObject);
begin
  { Ucletter.PrintLetter(RetNo, Table2.Fields[0].DisplayText);}
end;

procedure TGuiT1_2026.TaxReturnCoveringletter1Click(Sender: TObject);
begin
(*
Application.CreateForm(TCustLtr,CustLtr);
CustLtr.ShowModal;
CustLtr.Free;
*)
end;

procedure TGuiT1_2026.MailingLabels1Click(Sender: TObject);
begin
{If Not FeatureAllowed then exit;}
SomeCaption := 'Print Letters, Labels, Listings';
Application.CreateForm(TAnalyseT1_2026,Analyse);
Analyse.ShowModal;
Analyse.Free;
end;

procedure TGuiT1_2026.MainUIRibbonCommandCreate(const Sender: TUIRibbon; //20190415 Igor
  const Command: TUICommand);
begin
  case Command.CommandId of
	    T1_UIRibbonUnit.CommandSearchForm1:
	      begin
          FSearchForm1 := TUICommandCollection(Command);
          FSearchForm1.OnSelect := SearchFormSelect;
	      end;
      T1_UIRibbonUnit.CommandSearchForm2:
	      begin
          FSearchForm2 := TUICommandCollection(Command);
          FSearchForm2.OnSelect := SearchFormSelect;
	      end;
  end;
end;

procedure TGuiT1_2026.ShowOverridesClick(Sender: TObject);
begin
  if ButtonInactive then exit;
  SomeCaption := 'Forms with Overrides';
  OverList.EnumRecs(AppT1_2026, SomeList);
  SelectedString := PopSomeList(someList, SomeCaption);
  If SelectedString > '' then
   OpenForm(RetNo,SelectedString,0);
end;

procedure TGuiT1_2026.ListReviewmarks1Click(Sender: TObject);
Var I: integer;
begin
 If ButtonInactive then exit;
 {AuditOption.ItemIndex :=1;}
 {If not AuditPanel.Visible then AuditBtnClick(Sender);}

end;

procedure TGuiT1_2026.SystemInformation1Click(Sender: TObject);
//20170901 Igor>>>
//Var h : THandle;
begin
// h := ShellExecute(MainForm.Handle, Nil, 'WINFO.Exe', Nil,
//  Nil, SW_RESTORE);
// if h<=32 then ShowMessage('Info cannot be displayed. Code '+IntToStr(h));
  MessageDlg(OSTest, mtInformation, [mbOk], 0);
//20170901 Igor<<<
end;

procedure TGuiT1_2026.RebuildtheClientDataBase1Click(Sender: TObject);
begin
 If RetInMem>0 then
  begin ShowMessage('Please close all returns first');exit;end;
 Application.CreateForm(TRebuildT1_2026,Rebuild);
 Rebuild.ShowModal;
 Rebuild.Free;
end;

procedure TGuiT1_2026.MergeDataBases1Click(Sender: TObject);
begin
{ If Not FeatureAllowed then exit;}
 If RetInMem>0 then
  begin ShowMessage('Please close all returns first');exit;end;
 Application.CreateForm(TMergeT1_2026,Merge);
 Merge.ShowModal;
 Merge.Free;
end;

procedure TGuiT1_2026.FileViewerEditor1Click(Sender: TObject);
begin
Application.CreateForm(TFileVuT1_2026,FileVu);
FileVu.ShowModal;
FileVu.Free;
end;

procedure TGuiT1_2026.CurrentPage1Click(Sender: TObject);
//20171031 igor>>>
var
  i, whichPage: integer; //SomeList :TStringList;
  PDF: TvtPDFPrinter;
begin
 //print page
 //showmessage(sender.classname);
  if ButtonInactive then
    exit;
  if Ret[RetNo].IsLastYearReturn then
    Exit; //20110227
  SomeList.Clear; // := TStringList.Create;

  SomeCaption := 'Select Page to Print';

  for i := 1 to GetFormMxPg(FormName) do
  begin
    SomeList.Add(inttostr(i));
  end;

  SelectedString := PopSomeList(someList, SomeCaption);
  if SelectedString > '' then
  begin
    whichPage := strToInt(Trim(SelectedString)) //20210629 Igor
    //whichPage := strToInt(LeftStr(SelectedString, 1))
  end
  else
    exit;

  FastPrint := False;
  if ButtonInactive then
    exit;
  CountDiagnostics(RetNo);
  if Ret[RetNo].MandatoryErrorCount + Ret[RetNo].SeriousErrorCount > 0 then
  begin
    if not MainForm.WizardPanel.visible then
      MainForm.AuditOpenBtnClick(Sender);
    ShowMessage('Return has errors. Please fix before printing/filing');
  end;

  if not AllowedToFormPrint(RetNo, FormName) then
    exit;
  if CheckIsCloud(true) then //20180503 Igor
  begin
    PDFFullfileName := TPath.Combine(AppDir, 'tmp' + TPath.DirectorySeparatorChar + TPath.GetGUIDFileName + '.pdf');
    if not ForceDirectories(ExtractFileDir(PDFFullfileName)) then
    begin
      MessageDlg('Can not create temp folder', mtError, [mbOk], 0);
      Exit;
    end;
    PDF := TvtPDFPrinter.Create(AppT1_2026);
    try
      PDF.PrintForm(RetNo, FormName, whichPage, T1_2026Print.AfterReadComponentForPrint,
          T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
          T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);

      PDF.SaveToFile(PDFFullfileName, false);
      OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
    finally
      PDF.free;
    end;
  end
  else
  begin
    if PrintDialogItem.Execute then
      StartPrintForm(RetNo, FormName, whichPage);
    if Printer.Printing then //20160905 Igor
      Printer.EndDoc;        //20160905 Igor
  end;

// If OptRec.RetainDefaultPrinter = True then SetDefaultPrinter(OldPrinterName);  //20110225
//20171031 igor<<<
end;

procedure TGuiT1_2026.PlanNextYearClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  ChangeRates;
end;

procedure TGuiT1_2026.YSumBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 Screen.Cursor:=CrHourGlass;
 CalcAll(RetNo);
 RecalcEverything(RetNo);
 Screen.Cursor:=CrDefault;
 If OptRec.Use2YearSummary then
  OpenForm(RetNo,'YRSUM2',0)
 else
  OpenForm(RetNo,'YRSUM',0);
end;

procedure TGuiT1_2026.SelfEmployment1Click(Sender: TObject);
begin
 //If RetInMem < 1 then exit;
 if ButtonInactive then exit;
 ListBunchOfForms('SE','Self Employment and Rental');
end;

procedure TGuiT1_2026.ComparativeSummaryClick(Sender: TObject);
begin
If ButtonInactive then exit;
//20180302
If OptRec.Use2YearSummary then
  OpenForm(RetNo,'YRSUM2',0)
 else
  OpenForm(RetNo,'YRSUM',0);
//OpenForm(RetNo,'YRSUM2',0); //20180123
end;

procedure TGuiT1_2026.OptimizeFamilyprocessing1Click(Sender: TObject);
Var RNo,SpRNo,HigherTxblRNo:Integer;
begin
 If ButtonInactive then exit;
  if LicenseLevel in [llNetFile..llStd]
 then
 begin
  ShowMessage('The Family Optimization feature is only available in the T1 Power version');
  Exit;
 end;

 RNo:=RetNo;
 If (GetSpRetNo(RNo)=0) Or (Ret[RNo].CouplingSw=False)
 then
 begin
  ShowMessage('Two spouses must be coupled before using this feature,'+
  Chr(13)+'and the current return must be one of the spouses');
  exit;
 end;
 OpenForm(RNo,'OPTIMIZE',0);
end;


procedure TGuiT1_2026.CplBtnClick(Sender: TObject);
begin
 EndCoupling1Click(Sender);
 {UpdateMenuItems(Sender);}
end;

procedure TGuiT1_2026.IntroductionbyCRA1Click(Sender: TObject); //20160216 Igor
begin
 ConnectToWeb('http://www.cra-arc.gc.ca/auto-fill/');  //20160211
end;

procedure TGuiT1_2026.MinTaxBtnClick(Sender: TObject);
begin
  if ButtonInactive then exit;
 OpenForm(RetNo,'T691',0);
end;

procedure TGuiT1_2026.Openselectively1Click(Sender: TObject);
begin
//20171031 Igor>>>
  Screen.Cursor := crHourGlass;
  try
    Application.CreateForm(TSelOpenT1_2026,SelOpen);
    try
      SelOpen.ShowSw := true;//20160126 Igor
      SelOpen.ShowModal;
    finally
      SelOpen.Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
//20171031 Igor<<<
 //If LeftPanel.Visible then RefreshAuditPanel(RetNo);
 //If FormsPanel.Visible then RefreshFormsPanel(RetNo);
end;

procedure TGuiT1_2026.ListEFileRejectedReturns1Click(Sender: TObject);
begin
 Openselectively1Click(Application);
end;

procedure TGuiT1_2026.SSumBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 OpenForm(RetNo,'T4SUM#1',0);
end;

procedure TGuiT1_2026.ClientListings1Click(Sender: TObject);
begin
 Screen.Cursor := crHourGlass;
 try
 Application.CreateForm(TSelOpenT1_2026,SelOpen);
 SelOpen.ShowModal;
 SelOpen.Free;
 finally
  Screen.Cursor := crDefault;
 end;

end;

procedure TGuiT1_2026.CopyBackUp1Click(Sender: TObject);
begin
{ If Not FeatureAllowed then exit;}
 Screen.Cursor := crHourGlass;
 try
 BatchOper := 'Print'; BatchFilter := 'Ready To Print';
 Application.CreateForm(TSelOpenT1_2026,SelOpen);
 SelOpen.ShowModal;
 SelOpen.Free;
 finally
  Screen.Cursor := crDefault;
 end;

end;

procedure TGuiT1_2026.RecalcBtnClick(Sender: TObject);
Var FNo:integer;
begin
 If ButtonInactive then exit;
 Screen.Cursor := crHourGlass;
 RecalcEverything(RetNo);
 CountDiagnostics(RetNo);
 Screen.Cursor := crDefault;
 If FormNo>0 then MyChild.ShowFormData(FormName,FormNo);  //20090525
 MyChild.UpdateChildTaxPanel;
end;


procedure TGuiT1_2026.RecalculateandsaveALLtaxreturns1Click(Sender: TObject);
begin
 If RetInMem(AppT1_2026) > 0 then  //20161223 Igor
 begin
   ShowMessage('Please close all returns first');
   exit;
 end;
 Application.CreateForm(TRecalcT1_2026,Recalc);
 Recalc.ShowModal;
 Recalc.Free;
end;

procedure TGuiT1_2026.ReFILEthisreturn1Click(Sender: TObject);
//I have already a refile.  But what //??? I have not installed refile module you sent me
//  is the relationship of NOA with Refile?
begin
 //If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit;  //20180126

 //20180302
 if MessageDlg('Review the CRA requirements and restrictions before ReFILE?',
     mtInformation, [mbYes, mbNo], 0) = mrYes then
   ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/e-services/e-services-businesses/refile-online-t1-adjustments-efile-service-providers.html');

{
 //20180301 Con
 if MessageDlg('The Re-File function of the program is under Review by CRA and you should not transmit it'
          +Chr(13)+'until the CRA completes its Review/Certification. You will be notified by a program Update when ready.'
          +Chr(13)+'Open it for orientation only?',
          mtInformation, [mbYes, mbNo], 0) = mrYes then
   //ok
 Else
  Exit;
}

// If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit;  //20180126
  //Application.CreateForm(TREFILET1_2026, Refile);  //20170319
 //20170327
 If ButtonInactive then exit;
 OpenForm(RetNo,'REFILEQ',0);
end;

procedure TGuiT1_2026.ListBalances1Click(Sender: TObject);
begin
  Application.CreateForm(TListBalT1_2026,ListBal);
  ListBal.ShowModal;
  ListBal.Free;
end;


procedure TGuiT1_2026.PresSelBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 PreSelForms1Click(Application);
end;

procedure TGuiT1_2026.PreSelForms1Click(Sender: TObject);
begin
  If ButtonInactive then exit;//20170823 Igor
  Application.CreateForm(TPreSelT1_2026,PreSel);
  PreSel.ShowModal;
  PreSel.Free;
end;

procedure TGuiT1_2026.PreselNextBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  MyChild.Pages.SelectNextPage(True);
end;

procedure TGuiT1_2026.PreSelPrvBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  //MyChild:=vtMulti.RetList[RetNo].MyChild;
  MyChild.Pages.SelectNextPage(False);
end;

procedure TGuiT1_2026.PrintEFilereportsACKACXTSRERR1Click(Sender: TObject);
Var FlName:String;Ext :string; //[4];
begin
 OpenDialog.Title    := 'List Files of Type ACK,ACX,TSR,ERR,TXT,RTU,RTX';
 OpenDialog.InitialDir := OptRec.EF_DataDir;
 OpenDialog.Filter :=  'Ack rep.|*.ACK|Updated Acks|*.ACX|TSR Rep.|*.TSR|RTU File|*.RTU|Encr Err|*.ERR|RCT News|*.TXT|All|*.*';
 OpenDialog.FileName := '*.ACK';
 If OpenDialog.Execute then
 begin
  FlName := OpenDialog.FileName;
  If FlName>'' then
   If PrintDialogItem.Execute then
     begin
      Screen.Cursor := crHourGlass;
      Ext:= AllTrim(UpperCase(ExtractFileExt(FlName)));
      If (Ext = '.ACK') or (Ext = '.ACX') then
       begin AccReport(FlName);Screen.Cursor := crDefault;exit;end;
      If Ext = '.ERR' then begin ERRReport(FlName);Screen.Cursor := crDefault;exit;end;
      If Ext = '.TSR' then begin TSRReport(FlName);Screen.Cursor := crDefault;exit;end;
      If (Ext = '.RTU') or (Ext = '.RTX') then
        begin RTUReport(FlName);Screen.Cursor := crDefault;exit;end;
      PrintSomeFile(FlName);  {news files}
      Screen.Cursor := crDefault;
     end;
 end;
end;
//20171215 Igor>>
procedure TGuiT1_2026.OnCreateMenuItem(const aName: string;  //20190415 Igor
  const aHelperID: Integer);
var
  Item: TActionClientItem;
begin
//  Item := rgReturn.Items[1].Items.Add;
//  Item.Action := actForCloud;
//  Item.Caption := aName;
//  Item.Tag := aHelperID;
end;
//20171215 Igor<<
procedure TGuiT1_2026.OnestepEFile1Click(Sender: TObject);
begin
  OneStepEFile;
end;

procedure TGuiT1_2026.PrintReturnBalances1Click(Sender: TObject);
var
  chooseUseExpanedListBal:integer;
begin

 If RetInMem>0 then begin ShowMessage('Please close all returns first'); exit;end;
 Application.CreateForm(TListBalT1_2026,ListBal);

  //jz//20250205 - show one with more functionality when in debug mode,
  //jz//20250205 - $IFDEF DEBUG used so it only prompts for expanded listbal in DEBUG
  //$IFDEF DEBUG - doesnt seem to work --> find another way to show when debugging
  //
  if inJZtestmode then
  begin
    //chooseUseExpanedListBal := MessageDlg('Do you want to use expanded listbal?', mtConfirmation, [mbYes, mbNo], 1); //20251225
    //if chooseUseExpanedListBal = mrYes  then
    begin
        Application.CreateForm(TListBalT1JZ_2024,ListBal);
        ListBal.ShowModal;
        ListBal.Free;
        exit;
    end;
   end;
  //$ENDIF

 ListBal.ShowModal;
 ListBal.Free;
end;

procedure TGuiT1_2026.ChangeLicenseLevel;
begin
  //AppT1_2026.SetLicense(InputBox(AppT1_2026.AppId, 'License Level', ''));
  if not AppT1_2026.AskChangeLicenseLevel then
    exit;
 Licensee:='Some Multi-user';
 SelectFeatures;
 MainForm.FormPaint(Application);
End;


procedure TGuiT1_2026.NISAcodes1Click(Sender: TObject);
begin
  SomeList.Clear; // := TStringList.Create;
 //SomeList.Sorted := True;
 SomeCaption := 'CAIS CODES';
 {ListCaption;}
 PopSomeFile(AppDir+'\'+'CAIS.D',SomeCaption);
end;

procedure TGuiT1_2026.NOA1Click(Sender: TObject); //20170320 igor
begin
  ShowMessage('NOA is not acceptable by CRA via the T1 programm any longer');
  Exit;
  {
  if ButtonInactive(True) then Exit;
  NOA(AppT1_2026, Ret[GetCurrentRetNo]);
  }
end;

procedure TGuiT1_2026.UpdateT1MasterfromRTURTX1Click(Sender: TObject);
Var FlName:String;
begin
 OpenDialog.Title    := 'Use only if Updates failed during transmission. ** Do oldest to most recent**';
 OpenDialog.InitialDir := OptRec.EF_DataDir;
 OpenDialog.Filter :=  'RTU reports|*.RTU|RTX reports|*.RTX';
 OpenDialog.FileName := '*.RTU';
 If OpenDialog.Execute then
 begin
  FlName := OpenDialog.FileName;
  If FlName>'' then
  begin
    UpdateRTUDate(FlName,OptRec.Dir_Cur);
    ShowMessage('Update Completed');
  end;
end;
end;

procedure TGuiT1_2026.UpdateT1MasterfromACKACXfiles1Click(Sender: TObject);
Var FlName:String;
begin
 OpenDialog.Title    := 'Use only if Updates failed during transmission. ** Do oldest to most recent**';
 OpenDialog.InitialDir := OptRec.EF_DataDir;
 OpenDialog.Filter :=  'ACK reports|*.ACK|ACX reports|*.ACX';
 OpenDialog.FileName := '*.ACK';
 If OpenDialog.Execute then
 begin
   FlName := OpenDialog.FileName;
   If FlName>'' then
   begin
     UpdateACKDate(FlName,OptRec.Dir_Cur);
     ShowMessage('Update Completed');
   end;
 end;
end;

procedure TGuiT1_2026.OpenAutoFillLogin; //20160126 Igor
begin
 Application.CreateForm(TAutoFillLoginT1_2026,AutoFillLogin);
 try
   AutoFillLogin.ShowModal;
 finally
   AutoFillLogin.Free;
 end;
end;

procedure TGuiT1_2026.OpenBtnClick(Sender: TObject);
begin
 FileOpenItemClick(Application);
end;

procedure TGuiT1_2026.YourLatestReleaseClick(Sender: TObject);
 Var h : THandle;
begin
ConnectToWeb('https://www.visualtax.com/T1-2025-WhatsNew.html'); //20241223
//('www.visualtax.com/VT2023Help/T1Help/Website/T1UPD/T1UpdHlp.html');  //20211224
end;


procedure TGuiT1_2026.ZoomBtnPlusClick(Sender: TObject);
begin
  ZoomBtnClicked(+5); //20160209 Igor
//  if ZoomBtnClicked(+5) then
//    ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
end;

procedure TGuiT1_2026.ZoomBtnMinusClick(Sender: TObject);
begin
  ZoomBtnClicked(-5); //20160209 Igor
//  if ZoomBtnClicked(-5) then
//    ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
end;

procedure TGuiT1_2026.Image2Click(Sender: TObject);
begin
 MainForm.WizardPanel.Visible :=False;
end;


procedure TGuiT1_2026.Upgrade1Click(Sender: TObject);
begin
  ShowAbout;
end;

procedure TGuiT1_2026.UploadtoDropBox1Click(Sender: TObject); //20160614 Igor
var
  RStart: TFillDBStartRec;
begin
  //20170308 Igor>>>
  //vtShared.UploadToDropBox(MainForm.Handle, AppT1_2026.Dir_ClientDocs);
  vtFillDBMain.StartFillDB(AppT1_2026);
  //20170308 Igor <<<
end;

procedure TGuiT1_2026.AuditListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If  (Key = VK_F5) then MainForm.AuditOpenBtnClick(Sender);
end;


procedure TGuiT1_2026.BitBtn1Click(Sender: TObject);
BEGIN
  exit; //nop
END;

procedure TGuiT1_2026.YTDCashreports1Click(Sender: TObject);
begin
 If not (LicenseLevel in anyMulti) then
 begin
  ShowMultiOfficeMsg;
  exit;
 end;
 If not FileExists(AppDir+'\'+'YtDSetUp.CFG') then
 begin
  ShowMessage('Please use the YTD set-up screen first');
  exit;
 end;
  ExecuteForm(TYTDCashFrmT1_2026);
end;

procedure TGuiT1_2026.YTDdirectorySetup1Click(Sender: TObject);
begin
 If not (LicenseLevel in anyMulti) then
 begin
  ShowMultiOfficeMsg;
  exit;
 end;
  ExecuteForm(TYTDSetUpT1_2026);
end;

procedure TGuiT1_2026.Submit1Click(Sender: TObject);
Var FName,FlName:String; i, RetNo:Integer;
PDFFullfileName:String;
PDF: TvtPDFPrinter;
FrmList:TStringList;
begin
//20200422
 If ButtonInactive then exit;
 RetNo:=GetCurrentRetNo;
//ShowMessage('Under development');
 Dir := TPath.Combine(optRec.Dir_ClientDocs, GetLastName(retNo) + ','+ GetFirstName(retNo));//20171031 igor
 ForceDirectories(Dir);

 FrmList:=TStringList.Create;

 If Ret[RetNo].FrmHasData[GetFormNo('T183')]    then FrmList.Add('T183');
 If Ret[RetNo].FrmHasData[GetFormNo('T1032')]   then FrmList.Add('T1032');
 If Ret[RetNo].FrmHasData[GetFormNo('T1135')]   then FrmList.Add('T1135');
 If Ret[RetNo].FrmHasData[GetFormNo('T2091')]   then FrmList.Add('T2091');   //20200430
 If Ret[RetNo].FrmHasData[GetFormNo('AUTHREP')] then FrmList.Add('AUTHREP');
 If Ret[RetNo].FrmHasData[GetFormNo('CONSENT')] then FrmList.Add('CONSENT');

 PDF := TvtPDFPrinter.Create(AppT1_2026);
 FLName:='For Signature Approval.PDF';
 Try
  for i:=0 to FrmList.count-1 do
  Begin
   FName:=FrmList[i];
   PDF.PrintForm(RetNo, FName, 99, T1_2026Print.AfterReadComponentForPrint,
             T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
             T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);
  end;
  PDF.SaveToFile(Dir+'/'+FlName, false);
 Finally
  Pdf.Free;
 End;
 //ShowMessage('Pdf File Saved in '+Dir+'/'+FlName);
 if MessageDlg('Pdf File Saved in the Client Documents folder as'+
      Chr(13)+Dir+'/'+FlName+
      Chr(13)+'Show the file?',
      mtInformation, [mbYes, mbNo], 0) = mrYes then
     ShellExecute(Application.Handle,'open',Pchar(''+Dir+'/'+flName),Nil,Nil,Sw_Show);
 ShowMessage('You can Email it now to your Client and request acceptance of signature used and content.');

end;

procedure TGuiT1_2026.Submitdailycashreport1Click(Sender: TObject);
Var LogDir,FullLogName,DailyLogName,
    Office,Agent:string; //[4];
begin
 If not (LicenseLevel in anyMulti) then
 begin
  ShowMultiOfficeMsg;
  exit;
 end;
 Office := User.M_Office;
 Agent  := User.Code;
 LogDir       := MkLogDirName(Office,Agent);
 DailyLogName := MkLogFileName(Office,Agent);
 FullLogName  := LogDir+'\'+DailyLogName;
 ShowMessage('In the following window, enter as follows: '+Chr(13)
             +'Transmit from dir: '+LogDir+Chr(13)
             +'and transmit file: '+DailyLogName);
 //OneStepCom;
end;

procedure TGuiT1_2026.CopyDailyCashReport1Click(Sender: TObject);
begin
 If not (LicenseLevel in anyMulti) then
 begin
  ShowMultiOfficeMsg;
  exit;
 end;
  ExecuteForm(TCopyDlyT1_2026);
end;


procedure TGuiT1_2026.InternetWebSite1Click(Sender: TObject);
Var h:THandle;
begin
 ConnectToWeb('www.VisualTax.com');
end;

procedure TGuiT1_2026.WWWLblClick(Sender: TObject);
begin
 InternetWebSite1Click(Sender);
end;

function TGuiT1_2026.FormsTreeView1Click(SourceNode: TTreeNode; fUsedForms: boolean): integer;
//procedure TGuiT1_2026.FormsTreeView1Click(Sender: TObject);
Var
  Ndx :Integer;Fname:String;
//PrevFormNo:Integer;
begin
(* only return selected FormNo
*)
  Result := 0;
  If ButtonInactive then exit;
 Try
  If ret[RetNo].IsLastYearReturn then
  begin
   ShowMessage('Function not available for last year'+Chr(39)+'s forms. Press F2 instead');
  end;
  //SourceNode:= FormsTreeView1.Selected;
  Ndx :=SourceNode.AbsoluteIndex;

 //If UsedFormsBox.checked then
 If fUsedForms then
  Fname:=GetFName(SourceNode.Text)
 else
  Fname := AllTrim(FrmTreeForms[ndx]);
 Result := GetFormNo(FName);
 except on e: Exception do ExceptMsg(e);
 end;
end;

procedure TGuiT1_2026.EfileSetupBtnClick(Sender: TObject);
begin //20170307 igor
 EOLPLUS1Click(Sender);
end;

procedure TGuiT1_2026.WorldButtonClick(Sender: TObject);
begin
InternetWebSite1Click(Sender);
end;


procedure TGuiT1_2026.ClientStatistics1Click(Sender: TObject);
begin
  Application.CreateForm(TChartClientsT1_2026,ChartClients);
  ChartClients.ShowModal;
  ChartClients.Free;
end;

procedure TGuiT1_2026.Clients_With_Mail_NOAClick(Sender: TObject);
begin
 If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'NOA' then exit;  //20190509
 If RetInMem>0 then begin ShowMessage('Please close all returns first'); exit;end;
 Application.CreateForm(TClientsWithMailNoaT1_2026,ClientsWithMailNoa);
 ClientsWithMailNoa.ShowModal;
 ClientsWithMailNoa.Free;
end;

procedure TGuiT1_2026.AlphabeticalFormsIndex1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 Application.CreateForm(TABListT1_2026,ABList);
 ABList.ShowModal;
 ABList.Free;

//ABCBtnClick(Sender);
end;

procedure TGuiT1_2026.amT1StateChange(Sender: TObject);//20170825 Igor //20190415 Igor
var
  I: Integer;
begin
  if (MainOptions.Skin = skRibbon) and (amT1.State = TActionListState.asNormal) then
  begin
    for I := 0 to amT1.ActionCount - 1 do
    begin
      amT1.Actions[I].Enabled := not amT1.Actions[I].Enabled;
      amT1.Actions[I].Enabled := not amT1.Actions[I].Enabled;
    end;
  end;
end;

procedure TGuiT1_2026.Zoomin1Click(Sender: TObject);
begin
  ZoomBtnPlusClick(Sender);
end;

procedure TGuiT1_2026.Zoomout1Click(Sender: TObject);
begin
  ZoomBtnMinusClick(Sender);
end;

procedure TGuiT1_2026.Toolbandswitch1Click(Sender: TObject);
begin
 ToolBarBtnClick(Sender);
end;

procedure TGuiT1_2026.Color1Click(Sender: TObject);
Var Clr : Tcolor;
begin
 If ButtonInactive then exit;
  mainform.ClrClick(RetNo, Sender, c_ReturnColorElm); //20170219 Igor
end;

procedure TGuiT1_2026.ColourSettings_OfficeClick(Sender: TObject); //20201224 Igor
begin
  EditVirtualTaxOfficeColourSettings;
end;

procedure TGuiT1_2026.Recalc1Click(Sender: TObject);
begin
  RecalcBtnClick(Sender);
end;

procedure TGuiT1_2026.SlipSummary1Click(Sender: TObject);
begin
  SSumBtnClick(Sender);
end;

procedure TGuiT1_2026.ExportData1Click(Sender: TObject);
begin
  {If Not FeatureAllowed then exit;}
  If RetInMem>0 then
    begin ShowMessage('Please close all returns first'); exit;end;
  Application.CreateForm(TExportDataT1_2026,ExportData);
  ExportData.ShowModal;
  ExportData.Free;
end;


procedure TGuiT1_2026.Exporttofile1Click(Sender: TObject); //20170104 Igor
var
  lFileName: String;
  Answer: Array of String;
  lRetNo: Integer;
  lOutFileName: String;
  CurRetNo:Integer;  //20160106
begin

 //20170106 This Routine MUST be called by the SAVERETURN function  CON

  (*  20170106   CON
  if RetInMem(AppT1_2026) > 0 then
  Begin
    UserMsg('Please close all returns first');
    exit;
  End;
  *)
  SetLength(Answer, 3);
  Answer[0] := OptRec.Dir_Cur;

  //20160106  CON
  CurRetNo:=GetCurrentRetNo;
  if GetCurrentRetNo>0 then
   Answer[1] := GetSinNo(CurRetNo)
  Else
  Begin
   Answer[1] := '';
   ShowMessage('SIN is not known.'
    +Chr(13)+'Export Data works only after SAVE RETURN and SIN is known');
   Exit;   //con
  end;
  Answer[2] := IncludeTrailingPathDelimiter(OptRec.Dir_Cur) + 'ExportedData';

  (* NOT USED BUT KEEP. IT IS A BEUTIFULL USE OF MULTILINE InputQuery by IGOR
  if not InputQuery('Export return to file', ['Input folder','Enter SIN as 9 digits','Output folder'], Answer,
                    function (const Values: array of string): Boolean
                    begin
                      //check input folder
                      if (Values[0] = '') or
                         not DirectoryExists(ExcludeTrailingPathDelimiter(Values[0])) or
                         not FileExists(IncludeTrailingPathDelimiter(Values[0])+AppT1_2026.ClientsDBLite) then
                      begin
                        UserMsg('Please enter the correct input folder');
                        Result := False;
                      end
                      else
                      //check sin
                      if length(Values[1]) <> 9 then
                      begin
                        UserMsg('Please enter the correct sin number as 9 digit');
                        Result := False;
                      end
                      else
                      if not FileExists(IncludeTrailingPathDelimiter(Values[0])+LeftStr(Values[1],8) + '.' + RightStr(Values[1],1)) then
                      begin
                        UserMsg('File "'+IncludeTrailingPathDelimiter(Values[0])+LeftStr(Values[1],8) + '.' + RightStr(Values[1],1)+'" not found.');
                        Result := False;
                      end
                      //check output folder
                      else
                      if (Values[2] = '') or
                         SameText(ExcludeTrailingPathDelimiter(Values[0]), ExcludeTrailingPathDelimiter(Values[2])) or
                         not ForceDirectories(ExcludeTrailingPathDelimiter(Values[2])) then
                      begin
                        UserMsg('Please enter the correct output folder');
                        Result := False;
                      end
                      else
                        Result := True;
                    end) then
    exit;
  *)
  lFileName := LeftStr(Answer[1],8) + '.' + RightStr(Answer[1],1);
  //20170106
  if CurRetNo>0 then
  Begin
   lRetNo:=CurRetNo;
   //20170106
   lOutFileName := IncludeTrailingPathDelimiter(Answer[2]) +GetSinNo(lRetNo)+'.txt';
   //lOutFileName := IncludeTrailingPathDelimiter(Answer[2]) + GetLastName(lRetNo)+'  '+GetFirstName(lRetNo)+'-'+GetSinNo(lRetNo)+'.txt';
   RetList[lRetNo].ExportToFile(AppT1_2026.GetExportForms, lOutFileName);
  End
  Else
  Begin
  lRetNo := OpenReturn(ExcludeTrailingPathDelimiter(Answer[0]), lFileName, False);
  if lRetNo > 0 then
    try
     //20170106
      lOutFileName := IncludeTrailingPathDelimiter(Answer[2]) +GetSinNo(lRetNo)+'.txt';
      //lOutFileName := IncludeTrailingPathDelimiter(Answer[2]) + GetLastName(lRetNo)+'  '+GetFirstName(lRetNo)+'-'+GetSinNo(lRetNo)+'.txt'; //20170106
      RetList[lRetNo].ExportToFile(AppT1_2026.GetExportForms, lOutFileName);
    finally
     CloseReturn(lRetNo,true);
    end;
  End;
//20171031 igor>>>
  if CheckIsCloud then //20180503 Igor
  begin
    VirtualUI_Mediator.DownloadFile(lOutFileName, ExtractFileName(lOutFileName));
  end;
//20171031 igor<<<
end;

procedure TGuiT1_2026.OtherOptions1Click(Sender: TObject);
begin
 ExecuteForm(TOthOptT1_2026);
end;


procedure TGuiT1_2026.ReIndextheClientDataBase1Click(Sender: TObject);
begin
  ExecuteForm(TReindexDbT1_2026);
end;

procedure TGuiT1_2026.ReloadMainMenu; //20180111 Igor
begin
  LoadPluginActions(Self, MainMenu, OpenFromCloudClick, OnCreateMenuItem);
  SetMainMenuTitle; //20191202 Igor
end;

procedure TGuiT1_2026.RestructuretheClientsDataBase1Click(Sender: TObject);
begin
 ExecuteForm(TRestructureT1_2026);
end;

procedure TGuiT1_2026.WidePanelBtnClick(Sender: TObject);
Var Denom:Integer;
begin
end;

procedure TGuiT1_2026.AuditOpenBtnClick(Sender:TObject);
begin
 If ButtonInactive then exit;
 LockWindowUpdate(MainForm.Handle);
 //MainForm.LeftPanel.Visible := not MainForm.LeftPanel.Visible;
 MainForm.GuiCommand(gcToggleLeftPanel);
 MainForm.RefreshAuditPanel(RetNo);
 LockWindowUpdate(0);
end;


procedure TGuiT1_2026.AuditTrailHistoryOfAutoFill1Click(Sender: TObject); //20160126 Igor
Var FileNm:String;h:Word;
begin
  If IsTDDOpenForUse=false then begin ShowTddNotAvailableForUse;Exit;end;  //20160205 //20160216 Igor
  //GetEOLPParms(OnlineNo,TransmitterNo,Password,Url,NetFileDir);
  OpenDialog.Title    := 'Audit Trail History of Autofill with CRA';
  OpenDialog.InitialDir := OptRec.Dir_AutoFill; //20170222 Igor
  OpenDialog.Filter :=  'All Files|*.*';
  OpenDialog.FileName := '*.*';
  If OpenDialog.Execute then
  begin
    FileNm:=OpenDialog.FileName;
    h := ShellExecute(Application.Handle,'open',Pchar(''+fileNm),Nil,Nil,Sw_Show);
    If h<=32 then ShowMessage('File not found');
  end;
end;

procedure TGuiT1_2026.AutoFillClick(Sender: TObject);
begin
 //If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit;
 //ShowMessage('Autofill is not available in this draft version of the program');Exit;
 //If UpperCase(InputBox('Press Enter', 'Press Enter', '')) <> 'N/A' then  exit; //201812
 end;

procedure TGuiT1_2026.AutofillfromCRABtnClick(Sender: TObject); //20160126 Igor
Var
  RetNo:Integer;
  FlName:String;
  I: IvtAdoptableControl;
begin
 If IsTDDOpenForUse=false then begin ShowTddNotAvailableForUse;Exit;end;  //20160205 //20160216 Igor
  If ButtonInactive then Exit;
  RetNo:=GetCurrentRetNo;
  If RetNo=0 then
  begin
    ShowMessage('Return number not found');
    Exit;
  end;

  FlName:=MkTddFileName(RetNo,GetSinNo(RetNo));
  If FileExists(FlName) then    //RequestAutoFill(RetNo);   //201160120
  Begin
    //RetNo:=GetCurrentRetNo;
    TddRNo:=RetNo;  //20160120
    Application.CreateForm(TAutoFillFrmT1_2026,AutoFillFrm);
    try
      AutoFillFrm.ShowModal;
    finally
      AutoFillFrm.Free;
    end;
  end
  Else
    ShowMessage(FlName+' was not found');   //20160121
end;

procedure TGuiT1_2026.ErrorViewClick(RetNo: integer; SourceNode : TTreeNode);
Var
  //SourceNode : TTreeNode;
  Ndx :Integer;ErrorMsg:String;
 FrmNm:String;i,FNo:Integer; AtFieldId:Integer;
 TheEnterKey:Char;
 //for superaudit
 LnNo,k:Integer;
 Value:String;
 FileFound:Boolean;
 FlName:String;
begin
 If Ret[RetNo].IsLastYearReturn then Exit;
 
 Ndx :=SourceNode.AbsoluteIndex;
 ErrorMsg:=SourceNode.text;

 //for k:=low(Ret[RetNo].AuditRec) to high(Ret[RetNo].AuditRec) do
 For k:=0 to Ret[Retno].AuditList.Count - 1 do
 begin
    if Ret[RetNo].AuditRec[k].Description = ErrorMsg then
    begin
        OpenForm(RetNo,Ret[RetNo].AuditRec[k].Form,Ret[RetNo].AuditRec[k].Elm);
        //FocusOnElm(MyChild,RetNo,Ret[RetNo].AuditRec[k].Form,Ret[RetNo].AuditRec[k].Elm);
        exit;
    end;
 end;

 AtFieldId := MyStrToInt(AllTrim(MidStr(ErrorMsg,71,3)));
 FrmNm := AllTrim(MidStr(ErrorMsg,61,10));
 If FrmNm='' then exit;

 OpenForm(RetNo,FrmNm,AtFieldId);
 If SuperAuditSw = True then
 begin
   If LeftStr(ErrorMsg,2) = 'S-' then
   begin
    //SuperAuditPanel.Visible := True;
    LnNo:= MyStrToInt(MidStr(ErrorMsg,4,3));
    Value:=GetLastYearValueFromYrSum(LnNo);

    ShowMessage(MidStr(ErrorMsg,4,50)+
     Chr(13)+'--------------------------------------------------------------------'+
     Chr(13)+'Last year: '+FormatFloat('###,###,###.00',Vl(Value))
     +Chr(13)+'This year: '+'Nil');

    //PutLastYearValueOnFrmGrid(FrmNm,FileFound,LnNo,MidStr(ErrorMsg,4,50),Value);
   end;
 end
end;

procedure TGuiT1_2026.eSignaturesandCOVID191Click(Sender: TObject);
begin
 ConnectToWeb('www.VisualTax.com/e-signature.php');  //20170405
end;

procedure TGuiT1_2026.ExchageRatesAverage1Click(Sender: TObject);
begin
 SomeCaption := 'Average Exchange Rates for '+AppYear;
 PopSomeFile(AppDir+'\'+'EXCHRATE.D',SomeCaption,True);
end;

procedure TGuiT1_2026.InvoiceAdjustments1Click(Sender: TObject);
begin
 If not (LicenseLevel in anyMulti) then
 begin
  ShowMultiOfficeMsg;
  exit;
 end;

 If YouKnowTheAdminPassword = false then
 begin
  ShowMessage('Only the Administrator can perform this function');
  exit;
 end;
  ExecuteForm(TInvAdjT1_2026);
end;

procedure TGuiT1_2026.OpenbyFileNameSIN1Click(Sender: TObject);
begin
  ExecuteForm(TOpenFlNameT1_2026);
end;


procedure TGuiT1_2026.OpenDocumentsFolder1Click(Sender: TObject); //20210115 Igor
var FRetNo: integer;
    cFolder: string;
begin
  FRetNo := GetCurrentRetNo;
  if FRetNo = 0 then
    cFolder := OptRec.Dir_ClientDocs
  else
    cFolder := OptRec.Dir_ClientDocs + '\' + GetLastName(FRetNo) + ',' + GetFirstName(FRetNo);
  ForceDirectories(cFolder);
  ShellExecute(handle,'explore', PChar(cFolder), nil, nil, SW_SHOWNORMAL);
end;

procedure TGuiT1_2026.ListofEfileErrors1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
  ExecuteForm(TEFMErrorsT1_2026);
end;

procedure TGuiT1_2026.Checkupdate1Click(Sender: TObject);
begin
 ConnectToWeb('www.visualtax.com/download.php'); //20140304//small d on download //20140211
end;

procedure TGuiT1_2026.Image1Click(Sender: TObject);
begin
 Checkupdates1Click(Sender);
end;

procedure TGuiT1_2026.CheckUpdatesLblClick(Sender: TObject);
begin
 Checkupdates1Click(Sender);
 //Image1Click(Sender);
end;

procedure TGuiT1_2026.Label1Click(Sender: TObject);
begin
 InternetWebSite1Click(Sender);
end;

procedure TGuiT1_2026.ClearCurrentformClick(Sender: TObject);
Var i,n:Integer;Root:string; //[10];//AChild:TMyChild;
begin
  ClearCurrentPageClick(Sender);
end;

procedure TGuiT1_2026.ClearCurrentPageClick(Sender: TObject);
Var RefFNo:Integer;RefFormName:String;
begin
 If ButtonInactive then exit;
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
 //Calc(RetNo,FormName);
 Ret[RetNo].MyChild.ActiveForm.RebuildDynamicRows; //20160527 Igor
 ShowFormData(RetNo, FormName,FormNo);
 Ret[RetNo].FormHasData[FormName]:=False;
 MainForm.RefreshAuditPanel(RetNo);//If AuditPanel.Visible then RefreshAuditPanel;
 If MainForm.FormsPanel.Visible then MainForm.RefreshFormsPanel(RetNo);
end;


Procedure TGuiT1_2026.UsedFormsOnTreeView(RetNo:Integer);
Var //SourceNode : TTreeNode; Ndx :Integer;Fname:string; //[12];
    i:integer;TempList:TStringList;
begin
  //FormsTreeView1.items.clear;
  TempList:=TStringList.Create;
  //TempList.Sorted:=True;  screws up
  TempList.Add('USED FORMS');

  for i :=0 to (FList.Count - 1) do
  begin
   FRec := FList.Items[i];
   If (Frec.FormShow) and (Ret[RetNo].FormHasData[Frec.FormName+Frec.FormInst])      //20160813
    then TempList.Add(' '+AllTrim(Frec.FormAbrev));
 end;
 TempList.SaveToFile(AppDir+'\'+'Temp');
  TempList.Free;
End;

Procedure TGuiT1_2026.RefreshFormsPanel(TreeView: TTreeView; fUsedForms: boolean; RetNo: integer);
//procedure TGuiT1_2026.UsedFormsBoxClick(Sender: TObject);
var
  FormsTreeView1: TTreeView absolute TreeView;
begin
   FormsTreeView1.items.clear;
  If fUsedForms = False then
  begin
   FormsTreeview1.LoadFromFile(AppDir+'\Treeview2.D');
  end
 Else
 begin
  UsedFormsOnTreeview(RetNo);
  FormsTreeView1.LoadFromFile(AppDir+'\'+'Temp');
  FormsTreeView1.FullExpand;
  FormsTreeView1.TopItem:=FormsTreeView1.Items[0];
 end;
end;


Procedure TGuiT1_2026.MOSTRECENTFILES1Click(Sender: TObject);
Var sin:String;ThisResult:Integer;Dir,FlName:String;s:String;
Var RetNo:Integer;
begin
(* Use a single dir name throughout!
*)
  //DataDir:=OptRec.Dir_cur;
  SomeCaption := 'Most recently updated tax returns (max 50)';
  SelectedString := PopSomeFile(AppDir+'\'+RecentRFlName,SomeCaption);
  If SelectedString = '' then exit;

  FlName := AllTrim(MidStr(SelectedString,54,15));
  Dir:=AllTrim(MidStr(SelectedString,70,150));
  If FlName = '' then exit;

  OpenReturnCoupled(Dir,FlName, True); //assume always visible
end;

procedure TGuiT1_2026.RollForwardfromgreenPoint1Click(Sender: TObject);
begin
{
  //20191217
 ShowMessage('Batch rollover (all returns) should be avoided with this early version'
      +Chr(13)+'as the data forms are still evolving.'
      +Chr(13)+Chr(13)+'Just rollover what you need now');
 }
  ExecuteForm(TRollGpT1_2026);
end;

procedure TGuiT1_2026.RollForwardfromCanTaxT120011Click(Sender: TObject);
begin
{
 //20191217
 ShowMessage('Batch rollover (all returns) should be avoided with this early version'
      +Chr(13)+'as the data forms are still evolving.'
      +Chr(13)+Chr(13)+'Just rollover what you need now');
 }
 ExecuteForm(TRollCtxT1_2026);
end;

function TGuiT1_2026.SuperAuditBoxClick(RetNo: integer; ReturnsHeaderPanel: TPanel;
      ErrorView: TTreeView): string;
//procedure TGuiT1_2026.SuperAuditBoxClick(Sender: TObject);
begin
  if (LicenseLevel in [llDemo,llPower..llMultiPower])
  or (isEnterpriseVersion) //20250119
 then
   //ok
 else
 begin
  ShowMessage('Available only in the Power/Enrterprise versions of the program');
  Exit;
 end;

 Screen.Cursor:=crHourGlass;
 //SuperFeaturesLbl.Caption:='Missing this year';
 Result:='Missing this year';
 RefreshAuditPanel(RetNo,ReturnsHeaderPanel,ErrorView,True);
 Screen.Cursor:=crDefault;
end;


Procedure TGuiT1_2026.PutLastYearValueOnFrmGrid(Frmnm:String;FileFound:Boolean;LnNo:Integer;Description:String;Value:String);
Var i:Integer;
begin
end;


Procedure TGuiT1_2026.PutFrmDictOnFrmGrid(Frmnm:String;FileFound:Boolean);
Var i:Integer;
begin
end;

procedure TGuiT1_2026.CharityOrganizations1Click(Sender: TObject);
begin
 SomeCaption:='Charity Organizations';
 SomeLabel:='Used for predictive entry in the Donations list';
 SomeFile:='Charity.Txt';
 Application.CreateForm(TDFilesT1_2026,DFiles);
 DFiles.ShowModal;
 DFiles.Free;
end;

procedure TGuiT1_2026.SuperEntry1Click(Sender: TObject);
begin
  if (LicenseLevel in [llDemo,llPower..llMultiPower])
  Or (isEnterpriseversion)    //20250219
 then
 Begin
  ExecuteForm(TSuperEntryT1_2026);
 end
 Else
  ShowMessage('Feature avalilable only in the Power Version of the program');
end;

procedure TGuiT1_2026.Employers1Click(Sender: TObject);
begin
 SomeCaption:='Employers';
 SomeLabel:='Used for predictive entry in the T4, T4PS';
 SomeFile:='Employers.Txt';
 Application.CreateForm(TDFilesT1_2026,DFiles);
 DFiles.ShowModal;
 DFiles.Free;end;

procedure TGuiT1_2026.DoctorsHospitalsPharmacies1Click(Sender: TObject);
begin
 SomeCaption:='Doctors-Hospitals-Pharmacies';
 SomeLabel:='Used for predictive entry in the Donations list';
 SomeFile:='Doctors.Txt';
 Application.CreateForm(TDFilesT1_2026,DFiles);
 DFiles.ShowModal;
 DFiles.Free;
end;

procedure TGuiT1_2026.MedicalExpenseDescriptions1Click(Sender: TObject);
begin
 SomeCaption:='Medical Expense Types';
 SomeLabel:='Used for predictive entry in the Medical expenses';
 SomeFile:='MedExp.Txt';
 Application.CreateForm(TDFilesT1_2026,DFiles);
 DFiles.ShowModal;
 DFiles.Free;end;

procedure TGuiT1_2026.FirstNames1Click(Sender: TObject);
begin
 SomeCaption:='First Names';
 SomeLabel:='Used for predictive entry when entering first names (Taxpayer, Dependants, etc';
 SomeFile:='FirstNm.Txt';
 Application.CreateForm(TDFilesT1_2026,DFiles);
 DFiles.ShowModal;
 DFiles.Free;
end;

procedure TGuiT1_2026.Cities1Click(Sender: TObject);
begin
 SomeCaption:='Cities';
 SomeLabel:='Used for predictive entry when entering the name of a city';
 SomeFile:='Cities.Txt';
 Application.CreateForm(TDFilesT1_2026,DFiles);
 DFiles.ShowModal;
 DFiles.Free;
end;

procedure TGuiT1_2026.CloseSuperBtnClick(Sender: TObject);
begin
 {KEEP
 SuperAuditBox.Checked:=False;
 SuperAuditBoxClick(Sender);
 }
end;

procedure TGuiT1_2026.SuperEntryLastyearsformsselection1Click(Sender: TObject);
Var
  i:Integer;
  FullFlName:String;
begin
  if ButtonInactive then exit;
  //Calc(RetNo,'INFO');
  //20160819 Igor >>>
  FullFlName := RetList[GetCurrentRetNo].GetLastYearFile;
  if (FullFlName = '') or not (FileExists(FullFlName)) then
    FullFlName := IncludeTrailingPathDelimiter(OptRec.Dir_LastYr) +
      RetList[GetCurrentRetNo].MyApp.ConvertToLastYearName(RetList[GetCurrentRetNo].GetDefaultFileName);
  //FullFlName:=OptRec.Dir_LastYr+'\'+LeftStr(GetSinNo(RetNo),8)
  //  +'.'+RightStr(GetSinNo(RetNo),1);
  //20160819 igor <<<
  If not FileExists(FullFlName) then //option 1, check file
  begin
    ShowMessage('Cannot locate last year'+Chr(39)+'s file or directory ('+FullFlName+')');//20160819 Igor
    exit;
  end
  else
  begin
    GetUsedFormsFromDisk(FullFlName);
    For i:=0 to Ret[RetNo].PreselForms.count-1 do
      OpenForm(RetNo,Ret[RetNo].PreSelForms[i],0);
  end;
end;

Procedure TGuiT1_2026.ArrangeSuperAuditPanel;
Begin
(*
*)
end;

procedure TGuiT1_2026.SuperAuditUpBtnClick(Sender: TObject);
begin
 (*
 *)
end;

procedure TGuiT1_2026.SuperAuditDnBtnClick(Sender: TObject);
begin
 (*
 *)
end;

procedure TGuiT1_2026.T1GuideCCRA1Click(Sender: TObject);
begin
 ShowPdf(AppDir,'5000-g-24e.pdf');     //20240318
 //ShowPdf(AppDir,'https://www.canada.ca/content/dam/cra-arc/formspubs/pub/5000-g/5000-g-23e.pdf');
 //If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit;  //20180124
end;


procedure TGuiT1_2026.OpenPreviousYearsT11Click(Sender: TObject);
 Var h : Thandle;
   PgmPathS,PgmS,PgmParmsS:String;
   PgmPathZ : Array[0..254] of Char;
   PgmParmsZ : Array[0..254] of Char;
   PgmZ: Array[0..254] of Char;
   s:String;
begin
 if CheckIsCloud then Exit; //20180503 Igor
 If OptRec.Dir_PgmLastYr='' then
 begin
  ShowMessage('Please Enter PROGRAM DIRECTORY LAST YEAR in Configure | General Options | Data Directories');
  Exit;
 end;
 S:=OptRec.Dir_PgmLastYr+'\'+'T1'+IntToStr((StrToInt(AppYear)-1))+'.exe';
 PgmPathS := ExtractFileDir(S); StrPCopy(PgmPathZ,PgmPathS);
 PgmS:=ExtractFileName(S); StrPCopy(PgmZ,PgmS);
 PgmParmsS:=''; StrPCopy(PgmParmsZ,PgmParmsS);
 h := ShellExecute(MainForm.Handle, Nil, PgmZ, PgmParmsZ,PgmPathz, SW_RESTORE);
 If H<=32 then ShowMessage('Program not found');
end;


function TGuiT1_2026.SuperVerificationBtnClick(RetNo: integer; ReturnsHeaderPanel: TPanel;
      ErrorView: TTreeView): string;
//procedure TGuiT1_2026.SuperVerificationBtnClick(Sender: TObject);
Var i,j,k,n,FNo:Integer; CYrValue,LYrValue:String;
  ElmList,ValueList,CompFrmList,DataList,FrmDataList:TStringList;
  FullFlName:String;FileFound:Boolean;
begin
  if (LicenseLevel in [llDemo,llPower..llMultiPower])
  or (isEnterpriseVersion) //20250119
 then
  //ok
 else
 begin
  ShowMessage('Available only in the Power version of the program');
  Exit;
 end;
 //SuperAuditBox.Checked:=False;
 Result:='This vs Last Year';

 Screen.Cursor:=crHourGlass;

 ElmList:=TStringList.Create;
 ValueList:=TStringList.Create;  //holds the values
 CompFrmList:=TStringList.Create; //has the forms and elms to compare with last year
 DataList:=TStringList.Create;  //data from the tax return file image
 FrmDataList:=TStringList.Create;  //only portion of the data list, given form
try //finally destroy lists
 //load forms and elms to compare
 Fno:=GetFormNo(FormName);
 n:=GetFormNumberFields(GetFormNo(ExtractNonInstFormName(FormName)));
 CompFrmList.Add(PaddR(ExtractNonInstFormName(FormName),10)+'1-'+AllTrim(IntToStr(n)));
 //get lat year's datalist
 FullFlName:=OptRec.Dir_LastYr+'\'+LeftStr(GetSinNo(RetNo),8)
         +'.'+RightStr(GetSinNo(RetNo),1);
 FileFound:=FileExists(FullFlName);
 If not FileFound then
  begin
   DataList.Clear;
   FrmDataList.Clear;
   ShowMessage('Last year'+Chr(39) +'s file was not found in'+
       Chr(13)+'last year'+Chr(39)+ 's directory:'+
       Chr(13)+OptRec.Dir_LastYr+
       Chr(13)+'OR it was not a VisualTax return');
   Exit;
  end
 Else
  DataList.LoadFromFile(FullFlName);

 //Super review
 for i :=0 to FList.Count - 1 do
 begin
   FRec := FList.Items[i];
   Fno:=Frec.FormNo;
   k:=IsInList(FRec.FormName,CompFrmList); //position in list
   If K>-1 then
   begin
      ValueList.Add(FRec.FormInstName);
      GetElmListFromCompFrmRec(MidStr(CompFrmList[k],11,50),ElmList);
      //Get value
      For j:=0 to ElmList.Count-1 do
      begin
        CYrValue:=AllTrim(FetchElmFNo(RetNo,Frec.FormNo,MyStrToInt(ElmList[j])));
        //now Get Last year's value:
        If FileFound then
        begin
          FrmDataList.Clear;
          GetFrmDataListFromFullDataList(FRec.FormInstName,DataList,FrmDataList);
          LYrValue:= GetLastYearValue(MyStrToInt(ElmList[j]),FrmDataList);
        //GetFrmDataFromDataList(FRec.FormInstName,DataList,ElmList,ValueListLastYear);
        end
        else
          LYrValue:='??';
        If ((CYrValue='') and (LYrValue=''))
        or ((CYrValue='') and (LYrValue='??'))
        or ((CYrValue='') and (LYrValue='Nil'))
        then
        // nothing
        else
        begin
         If CYrValue='' then CYrValue:='Nil';
         If LYrValue='' then
         begin
          If FileFound then LYrValue:='Nil' else LYrValue:='??';
         end;
         ValueList.Add(' '+PaddR(CYrValue+' vs '+ LYrValue,60)+
                      PaddR(FRec.FormInstName,10)
                     +PaddR(ElmList[j],3));
        end;
      end;
   end; //is inCompfrm
 end; //i forms loop

 ValueList.SaveToFile(AppDir+'\'+'temp');
 LockWindowUpdate(MainForm.Handle);
 //ErrorView.Items.Clear;
 ErrorView.LoadFromFile(AppDir+'\'+'temp');
finally
   ElmList.free;
   ValueList.Free;
   FrmDataList.Free;
   CompFrmList.Free;
   DataList.Free;
   Screen.Cursor:=crDefault;
   LockWindowUpdate(0);
end;
end;

procedure TGuiT1_2026.CompanyLogo1Click(Sender: TObject);
begin
  if (LicenseLevel in [llPower..llMultiPower])
  or (isEnterpriseVersion) //20250119
 then
 //ok
 else
 begin
  ShowMessage('Available only in the Power/Enterprise versions of the program');
  Exit;
 end;
end;

procedure TGuiT1_2026.ImportConfiguration1Click(Sender: TObject);
begin
 if CheckIsCloud then Exit; //20180503 Igor
 Application.CreateForm(TImportConfigT1_2026,ImportConfig);
 ImportConfig.ShowModal;
 ImportConfig.Free;
end;


procedure TGuiT1_2026.ImportdatafromProductionDataBases1Click(Sender: TObject);
begin
(* Not in use in 2017 or later
//20171031 igor>>>
  if StartParams.IsDemo or StartParams.isCloud then
  begin
    MessageDlg(c_NotAvailable, mtInformation, [mbOk], 0);
    Exit;
  end;
//20171031 igor<<<
  If getCurrentRetNo > 0 then
  begin
    ShowMessage('Please close all returns first');
    Exit;
  end;

  If OptRec.Dir_DBFData = '' then
  begin
    ShowMessage('You should first enter the Data Directory of the T1-2017 Production data'
                +Chr(13)+'See Configure | General Options | Data Directories');
    Exit;
  end;
  MainForm.GuiCommand(gcHideLastYear);  //20160311 Igor
  ExecuteForm(TImportDBFT1_2026);
 *)
end;

procedure TGuiT1_2026.ExportConfiguration1Click(Sender: TObject);
begin
 if CheckIsCloud then Exit; //20180503 Igor
 Application.CreateForm(TExportConfigT1_2026,ExportConfig);
 ExportConfig.ShowModal;
 ExportConfig.Free;
end;

procedure TGuiT1_2026.Findaline1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 Application.CreateForm(TFindALineT1_2026,FindALine);
 FindALine.ShowModal;
 FindALine.Free;
end;

procedure TGuiT1_2026.SENDErrors1Click(Sender: TObject);
begin
 //If ButtonInactive then exit;
 ShowPdf(AppDir,'SEND-13b.pdf');
end;

procedure TGuiT1_2026.LinesBtnClick(Sender: TObject);
begin
  Findaline1Click(Sender);
end;


procedure TGuiT1_2026.EOLClick(Sender: TObject);
Var s:String;i:Integer;
  OnlineNo,TransmitterNo,Password,Url,NetFileDir:String;
begin
  If ButtonInactive then exit;   //20101218

  if IsAuthorizedPreparer=False then Exit;  //20190401

  (*
  //jz//20260121
  if not(inJZtestmode) then
  begin
    //20260103
     ShowMessage('CRA is expected to open for Efile on Feb 23, 2026' //ShowMessage('CRA is expected to open for Efile around Feb 20, 2026'
     +Chr(13)+'DO NOT FILE any return (in Paper format or Efile) using any draft program until CRA gives us the go ahead.'
     +Chr(13)+' '
     +Chr(13)+'We will inform you via the program login Alerts / Notifications messages.'
     +Chr(13)+' ');
  end;

  If IsCraOpenForEfile=False then begin ShowCraIsClosed;exit;end;  //20160205 //20160216 Igor
  *)

  (* //20250408
  if Immigrant(retNo) then //20240428C
  begin
   if (Ret[Retno].FrmHasData[GetFormNo('T1243')])
   or (Ret[Retno].FrmHasData[GetFormNo('T1244')])
   or (Ret[Retno].FrmHasData[GetFormNo('T1161')])
   then
   begin
     ShowMessage('This return is not eligible for Efile, as it includes forms T1243, T1244 or T1161. You must paper file it');
     Exit;
   end;
  end;
 *)


 //20250428
  if Ret[RetNo].Province='QC' then  //20250317
  Begin
   ShowMessage('QC returns can only be used for Federal purposes and without technical support.');
  End;

  If (FetchElmFNo(RetNo,InfoFNo,228)>'') then //20250408
  begin
    //ShowMessage('This type of return can only be paper-filed for now. Use Print -> Print Current return'); //20250408
    //Exit; // Temp
  end;

  //jz//20250423
  If
      (FetchElmFNo(RetNo,InfoFNo,253)>'')   or

      (FetchElmFNo(RetNo,InfoFNo,205)>'')   or    //jz//20250422

      (FetchElmFNo(RetNo,InfoFNo,244)>'')   or
      (FetchElmFNo(RetNo,InfoFNo,237)>'')   or
      (FetchElmFNo(RetNo,InfoFNo,239)>'')   or
      (FetchElmFNo(RetNo,InfoFNo,240)>'')   or
      (FetchElmFNo(RetNo,InfoFNo,241)>'')
  then
  begin
    //ShowMessage('This type of return can only be paper-filed for now'); //20250408
    ShowMessage('This type of return is not eligible for Efile. You must paper-file it');
    //Exit;
  end;
  //20240402
  If (FetchElmFNo(RetNo,InfoFNo,230)>'') then //20240302
  Begin
   if (Ret[Retno].FrmHasData[GetFormNo('T1243')]=True)
   or (Ret[Retno].FrmHasData[GetFormNo('T1161')]=True)
   or (Ret[Retno].FrmHasData[GetFormNo('T1244')]=True) then
   begin
    ShowMessage('This type of return is not eligible for Efile. You must paper-file it');
    Exit;
   end;
  end;

  //20240213
  s:=GetResidencyType(RetNo);

  {//20240402
  if (FetchElmFNo(RetNo,InfoFNo,238)>'') then    //20240402
   begin
    ShowMessage('Residency Type 3 is allowed for Efile only for Section 116');     //20240319
    Exit;          //20240319
  end;

  if (s='6') or (s='7') then
  begin
     ShowMessage('This type of return is not eligible for Efile. You must paper-file it');
      //Residency Type 6 or 7, are not eligible for Efile');
     Exit;
  end;
  }

  //20211216
  if IsMultJurisdiction(RetNo) then
  Begin
  // If UpperCase(InputBox('T2203 returns will be released in March/April', 'PSW', '')) <> 'N/A' then exit; //20230409
  End;

  GetEOLParms(OnlineNo,Password,Url,NetFileDir);

  If OnlineNo<>'B0865' then //20221224
  Begin
   // If UpperCase(InputBox('Enter password', 'PSW', '')) <> 'N/A' then exit; //20221212
  end;

  If Length(OnlineNo)<>5 then
  begin
    ShowMessage('Efiler number not entered correctly. Please complete the Efile Online Setup');
    SetupEOL1Click(Sender);
    Exit;
  end;




 (* //20260429
 if IsMultJurisdiction(RetNo) then  //20200223
 Begin
  //2026022100408
  if OnlineNo<>'B0865' then
  begin
   If UpperCase(InputBox('You cannot currently Efile a Multiple Jurisdiction return (T2203)', 'PSW', '')) <> 'N/A' then exit;  //20200327  //Showmessage('You cannot currently Efile a Multiple Jurisdiction return (T2203)');
  end;
 end;
 *)

 If (LicenseLevel in anyMulti) and (isBCJ=False) then
 begin
   //If Ret[RetNo].Saved = false then
   If Ret[RetNo].Changed then
   begin
    ShowMessage('Please Save the return first');
    Exit;
   end;
 end;

 If (LicenseLevel in anyMulti) and (isBCJ=False) then   //20170101
 begin
   If IsReturnPaid(RetNo)=False then
   begin
    ShowMessage('Return must be set to Paid before Efiling');
    exit;
   end;
 end;  //multi-office

  If (OptRec.Prp_Name ='') or (OptRec.Prp_Street ='') then
  begin
   ShowMessage('Please Enter Preparer Name/Address in Configure -> General Options -> Preparer');
   Exit;
  end;


  If LicenseLevel=llLimited then  //20090125
  begin
   ShowMessage('Efile not available in the Limited version');
   Exit;
  end;

  If RY=1 then
  begin
    ShowMessage('You are in tax planner mode. You cannot Efile it');
    Exit;
  end;

  if AllowSaSB(RetNo) then  //20200313
  Begin
   // ShowMessage('You cannot Efile a Non-Resident return');
   // Exit;
  end;


   //20170402
   If UpperCase(OnlineNo) <> UpperCase(LeftStr(FetchElm(RetNo,'T183',21),5)) then
   begin
    //20170402  removed the delete option  and added ReFile noe
    ShowMessage('There may be errors that need to be fixed (Audit Wizard)'
      +Chr(13)+'OR'
      +' the T183 has different Efiler no in Part G than SetUp EOL (click button Make New DCN)'
      +Chr(13)+'OR'
      +Chr(13)+'the return has been already submitted and accepted'
      +Chr(13)+' '
      +Chr(13)+'NOTE: When you ReFILE, the correct DCN of the initial return must be entered on rhe ReFILEQ form'
      );
    OpenForm(RetNo,'T183',21);
    Exit;
   end;


   //20170218
   If ValidateDcn(RetNo)=False then
   begin
     //20170329
     ShowMessage('The DCN in Part G of the T183 is incorrect'
      +Chr(13)+' '
      +Chr(13)+'CRA requires now that the 2 characters after the Efiler Number'
      +Chr(13)+'must be the 2 digit of the tax year, such as 16'
      +Chr(13)+' '
      +Chr(13)+'On the T183, click the button Make New DCN to get an acceptable number'
      +Chr(13)+' '
      +Chr(13)+'NOTE: When you ReFILE, the correct DCN of the initial return must be entered on rhe ReFILEQ form'
      );
     OpenForm(RetNo,'T183',21);
     Exit;
   end;

  RecalcEverything(RetNo);
  Calc(RetNo,'T183');


   If IsEFiledReturn(RetNo) = False then
   begin
     ShowTimedMsg('Return NOT set for Efiling',1700);
     OpenForm(RetNo,'INFO',46);
     Exit;
   end;

   If Ret[RetNo].EfStatus = '02' then
   begin
     if OnlineNo<>'B0865' then  //unlees development efiler no
     Begin
      ShowTimedMsg('Return has been already accepted by EFile',1700);
      Exit;
     end;
   end;

   If Ret[RetNo].EfStatus = '04' then
   begin
     ShowTimedMsg('Return submitted already and waiting Acknowledgement',1500);
     Exit;
   end;



   If EditBeforeSave (RetNo)= false then exit;


  {
   If UpperCase(FetchElmFNo(RetNo,InfoFNo,144))='Y' then  //use e-sign.
   begin
    If UpperCase(FetchElmFNo(RetNo,InfoFNo,153))='' then
    Begin
      if MessageDlg('Electronic signature appears to be available,'
         +Chr(13)+ 'but NO client confirmation date to use it has been entered yet on the INFO form.'
         +Chr(13)+'Efile anyway?',
         mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     ; //do nothing
    end
    Else
    exit;
   end;
   }


   for i:=1 to 3 do  //20200223
   Begin
    //20240319
    (*
    If Ret[RetNo].SeriousErrorCount>0 then
    begin
     //20140420
     if MessageDlg('Return has important errors.'
         +Chr(13)+'The errors must be fixed before filing'
         +Chr(13)+'Efile anyway?',
         mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     //proceed
     Else
     exit;
    end;
   *)
   End;

   If Not IsReadyForEfile(RetNo) then
   begin
     ShowMessage('Not ready for Efiling. See error(s) on the Audit -> Efile-cannot Efile section'); //2024030
     exit;     //20240319
   end;

   //20131219
   If (CountCropEntries(RetNo,'#1')>50)
   then
   begin
     ShowMessage('T1273 Crop Inventory entries exceed 50. You must Paper-file this return');
     Exit;
   end;

   If (CountLiveStockEntries(RetNo,'#1')>50)
   then
   begin
     ShowMessage('T1273 LiveStock Inventory entries exceed 50. You must Paper-file this return');
     Exit;
   end;

   Screen.Cursor:=CrHourGlass;
   If IsAuthorizedPreparer=false then exit;
  //20180228 Igor >>>
  //Application.CreateForm(TT1EfileT1_2026,T1Efile);  //20131117
  ExecuteForm(TT1EfileT1_2026);
  //20180228 Igor <<<
end;

procedure TGuiT1_2026.EOLPLUS1Click(Sender: TObject);
begin
  //If UpperCase(InputBox('Efile will be available by CRA on Feb 20', 'PSW', '')) <> 'N/A' then exit;  //202021

 if IsAuthorizedPreparer=False then Exit;  //20190401
 If IsCraOpenForEfile=False then begin ShowCraIsClosed;exit;end;  //20160205 //20160216 Igor
 { //20250407
 if LicenseLevel in [llNetFile..llStd]
 then
 begin
  ShowMessage('Batch Efile is available only in the T1 Power version');
  Exit;
 end;
 }
 If LicenseLevel = llDemo then
 begin
  ShowMessage('The Demo version does not allow Production T1 Efile');
  exit;
 end;

 {
   //20171217
 ShowMessage('Efile is expected to open by CRA in the second or third week of February 2018'
      +chr(13)+''
      +chr(13)+'Please DO NOT SUBMIT until then');
 }
 If RetInMem>0 then
 begin
  ShowTimedMsg('Please close all returns first', 1200);
  Exit;
 end;

 If (OptRec.Prp_Name ='') or (OptRec.Prp_Street ='') then
 begin
   ShowMessage('Please Enter Preparer Name/Address in Configure -> General Options -> Preparer');
   Exit;
 end;

 NetSoftCode := '064F';
 StartEOLP;
end;

procedure TGuiT1_2026.StartEOLP;
//20160722 Igor >>>
var
  r: Integer;
begin
  r := GetCurrentRetNo;
  if assigned(RetList[r]) and (RetList[r] is TRetT1_2026) then
  begin
    If EditBeforeSave(r)= false then exit;
    If RetList[r].SeriousErrorCount>0 then
    begin
      ShowMessage('Return has important ommissions. Fix before Efiling On-line');
      exit;
    end;
    If Not IsReadyForEfile(r) then
    begin
      ShowMessage('Not ready for Efiling. See error(s) on the Audit -> Efile-cannot Efile section'); //2024030
      exit;
    end;
  end;
  //20160722 Igor <<<
  If IsAuthorizedPreparer = false then
    exit;
  ExecuteForm(TEOLPT1_2026);
end;

procedure TGuiT1_2026.UsefulLinksClick(Sender: TObject);
begin
  ConnectToWeb('www.visualtax.com/links.php');    //20140303  //ufetr feb26 update
end;

procedure TGuiT1_2026.UsePrintWatermark1Click(Sender: TObject);
begin
 //20191216 CON
 WatermarkText:='';
 WaterMarktext:=InputBox('Enter the text of desired Watermak', 'Text', '');
end;

procedure TGuiT1_2026.SetReturnPassword1Click(Sender: TObject);
Var s:String;
begin
  If buttonInactive then exit;
  ExecuteForm(TSetFilePswT1_2026);
end;

procedure TGuiT1_2026.SetSearchStr(const AValue: String);//20170824 Igor //20190415 Igor
begin
  if AValue <> FSearchStr then
  begin
    FSearchStr := AValue;
    if edtSearchForm.Text <> FSearchStr then
      edtSearchForm.Text := FSearchStr;
    if edtSearchForm2.Text <> FSearchStr then
      edtSearchForm2.Text := FSearchStr;
    if QuickFindBtn.Text <> FSearchStr then
      QuickFindBtn.Text := FSearchStr;
  end;
end;

procedure TGuiT1_2026.RemoveReturnPassword1Click(Sender: TObject);
begin
 If buttonInactive then exit;
 RemoveReturnPsw(RetNo);
 ShowTimedMsg('Password Removed',1000);
end;

procedure TGuiT1_2026.SetProgramPassword1Click(Sender: TObject);
begin
  SetThePgmPsw;
end;

procedure TGuiT1_2026.RemoveProgramPassword1Click(Sender: TObject);
begin
 RemovePgmPsw;
 ShowTimedMsg('Program Password Removed',1000);
end;

procedure TGuiT1_2026.PrintAuditBtnClick(Sender: TObject);
begin
  if ButtonInactive then exit;
 If PrintDialogItem.Execute then
 begin
  Calc(RetNo,'DIAGNO');
  StartPrintForm(Retno,'DIAGNO',1);
  If Printer.Printing then //20160905 Igor
    Printer.EndDoc;        //20160905 Igor

 end;
end;

procedure TGuiT1_2026.PrintAuditWizardDiagnostics1Click(Sender: TObject);
begin
  If ButtonInactive then exit;
 CountDiagnostics(RetNo);
 PrintAuditBtnClick(Sender);
end;

procedure TGuiT1_2026.PrintableAutofilldata1Click(Sender: TObject);
Var FileNm,FileNm2,s:String;h:Word;
  i:integer;PrnFile: TextFile;
  //TempList:TstringList;
  TempList:TListBox;
  Hdr1,Hdr2,Hdr3:String;
begin
 //20160327
 ExecuteForm(TAutoFillPrintT1_2026);
 (*
 If IsTDDOpenForUse=false then begin ShowTddNotAvailableForUse;Exit;end;  //20160205
 OpenDialog.Title    := 'Audit Trail History of Autofill with CRA';
 OpenDialog.InitialDir := TddFilesDir;
 OpenDialog.Filter :=  '*.txt';
 OpenDialog.FileName := '*.txt';

 Hdr1 := Space(30)+'Auto-fill data '+FlName;
 Hdr2 := ' ';
 Hdr3 := ' ';

 If OpenDialog.Execute then
 begin
  FileNm:=OpenDialog.FileName;


  TempList := TListBox.Create(Self);
 // TempList.ParentOwner
  TempList.Items.LoadFromFile(FileNm);

  {open output file}
  FileNm2:=AppDir+'\'+'TempFile';
  AssignFile(F1,FileNm2);
  Rewrite(F1);
  For i:=0 To TempList.Items.Count-1 do
  begin
    s:=PaddR(MidStr(TempList.Items[i],47,36),36)+MidStr(TempList.Items[i],81,100);
    WriteLn(F1,s);
  end;
  CloseFile(F1);
  TempList.free;
  If PrintDialogItem.Execute then
  begin
   If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
   ShowMessage('Printing Completed');
  end;
 end; //openDialog
*)

 (*
 If OpenDialog.Execute then
 begin
  FileNm:=OpenDialog.FileName;
  TempList := TstringList.Create;
  TempList.LoadFromFile(FileNm);
  AssignPrn(PrnFile);
  Rewrite(PrnFile);
  Writeln(PrnFile, 'Auto-fill data '+FlName);
  Writeln(PrnFile, '-----------------------------------------------------------');

  For i:=0 To TempList.Count-1 do
  begin
   //s:=MidStr(TempList[i],46,150);
   s:=PaddR(MidStr(TempList[i],46,36),36)+MidStr(TempList[i],81,100);
   Writeln(PrnFile, s);
  end;
  System.CloseFile(PrnFile);
  TempList.Free;
 *)


 (*
 Hdr1 := Space(30)+'Auto-fill data '+FlName;
 Hdr2 := ' ';
 Hdr3 := ' ';

 If OpenDialog.Execute then
 begin
  FileNm:=OpenDialog.FileName;
  TempList := TstringList.Create;
  TempList.LoadFromFile(FileNm);

  {open output file}
  FileNm2:=AppDir+'\'+'TempFile';
  AssignFile(F1,FileNm2);
  Rewrite(F1);
  For i:=0 To TempList.Count-1 do
  begin
    s:=PaddR(MidStr(TempList[i],47,36),36)+MidStr(TempList[i],81,100);
    WriteLn(F1,s);
  end;
  CloseFile(F1);
  TempList.free;
  If PrintDialogItem.Execute then
  begin
   If PrintAListing(FileNm,Hdr1,Hdr2,Hdr3) = True then
   ShowMessage('Printing Completed');
  end;
 end; //openDialog
 *)
end;

procedure TGuiT1_2026.PrintAcknowledgementreport1Click(Sender: TObject);
Var FlNm:String;
begin
 OpenDialog.Title    := 'Acknowledgement files';
 OpenDialog.InitialDir := GetEolPNetFileDir;
 OpenDialog.Filter :=  'Acknowledgements|*.ACK';
 OpenDialog.FileName :='*.*'; // '*.ACK';  //20120117
 If OpenDialog.Execute then
 begin
  FlNm:=OpenDialog.FileName;
  If Flnm>'' then
  begin
   If PrintDialogItem.Execute then
   Begin
    //Try
    // AckNamesList:=TList.Create;    //20140119
     ReadAckFileHeaderInfo(FlNm);
     SelectAckReport(FlNm);
    //Finally
    // AckNamesList.Free;  //20120120           //20140119
    //end; //try
   end; //printer
  end;//file selected
 end; //open dialog
end;

procedure TGuiT1_2026.SaveALLopenedreturns1Click(Sender: TObject);
Var PrvFNo,PrvRetNo:integer;
begin
  if ButtonInactive then exit;
 PrvRetNo:=RetNo;
 PrvFNo:=FormNo;
  MainForm.GuiCommand(gcSaveAll); //SaveAllReturns;
 OpenForm(PrvRetNo,PrvFNo,0);
end;

 //20190506 Igor
Function TGuiT1_2026.DoSaveAllReturns(RNo: integer):Boolean;
//Function TMainForm.SaveAllReturns:Boolean;
Var
  i:Integer;FlName,DataDir:String;
  //RNo:Integer;
  OldCouplingSw:Boolean;
  Clouds: TArrayOfInteger;      //20190506 Igor
  iCloud, vSaveResult : integer;//20190506 Igor
begin
  (* From SaveAllReturns, save single return only
  *)
  //If RetInMem=0 then exit;
  if Ret[RNo].IsLastYearReturn or Ret[RNo].isAppendix then exit(True); //20170811 Igor

  Result:=False;
  //Screen.Cursor:=CrHourGlass;
  //for i :=0 to (RetList.Count - 1) do
  begin
    //RetRec := RetList.Items[i];
    //RNo:=RetRec^.RetNo;

    //20091226
    OldCouplingSw:=Ret[RNo].CouplingSw;
    Ret[RNo].CouplingSw:=False;

    CalcFullReturn(RNo);
    RecalcEverything(RNo);
    //CalcUsedFrm(RNo);  // NO GOOD - picks up the same
    Ret[RNo].CalcStatus := True;
    CountDiagnostics(RNo);
    If RetList[RNo].MandatoryErrorCount > 0 then
    begin
      //20170628 Igor >>>
      if not (asSilentSave in ApplicationState) then
      begin
        OpenForm(RNo,GetFormNo('INFO'),0);
        If not MainForm.LeftPanel.Visible then
        begin
          //MainForm.LeftPanel.Visible:=True;
          //AuditOpenBtnClick(Application);
          MainForm.GuiCommand(gcToggleLeftPanel);
        End;
        MainForm.RefreshAuditPanel(RNo);
        ShowMessage('Please fix Mandatory data before saving and try again');
      end;
      //20170628 Igor <<<
      Screen.Cursor:=CrDefault;
      Ret[RNo].CouplingSw:=OldCouplingSw;  //20091226
      exit;
    end;
    FlName := Ret[RNo].SourceFlName;
    If (FlName = '') or CheckIsCloud(True) then //20190517 Igor
    FlName := LeftStr(FetchElm(RNo,'INFO',3),8)+
      '.'+RightStr(FetchElm(RNo,'INFO',3),1);
    DataDir := Ret[RNo].SourceDataDir;
    If IsDataDirectoryGood(DataDir) = False then exit;
    If DirectoryExists(DataDir) = False then
    begin
      ShowMessage('Directory does not exist');
      Ret[RNo].CouplingSw:=OldCouplingSw;  //20091226
      Exit;
    End;
    //20160327 Igor >>>
    If FileExists(DataDir+'\'+ClientsTable_dbf) then
    begin
      ShowMessage(DataDir + CHR(13)
                +'The data directory is NOT compatible with the Multi-App version.'+#13+
                 'Please use another data directory, such as ' + OptRec.Dir_Cur  +' in the  Save As  window');
      exit;
    end;
    //20160327 Igor <<<
    //20150826 igor
    If FileExists(DataDir+'\'+ClientsDbLite) = False then
    begin
      ShowMessage('Data directory '+DataDir + ' was not configured for tax returns');
      Ret[RNo].CouplingSw:=OldCouplingSw;  //20091226
      Exit;
    End;

    If Ret[RNo].Locked = true then
    begin
      ShowMessage('Cannot save: '+ GetFirstName(RNo)+' '+GetLastName(RNo)+
        chr(13)+'This return has been locked');
      //exit;
    end
    else
    BEGIN
      {put changed STATUS form data}
      with Ret[RNo].Frm[GetFormNo('STATUS')] do
      begin
        {last update}
        Strings[11] := User.UserName;
        Strings[12] := FormatDateTime('yyyy-mm-dd',Now);
        Strings[13] := TimeToStr(Time);
      end;

      //may 15 2008
      //20170628 Igor >>>
      if not (asSilentSave in ApplicationState) then
      begin
        OpenForm(RNo,GetFormNo('INFO'),0);  //may 15 2008
        CalcUsedFrm(RNo);  //may 15 2008
      end;
      //20170628 Igor <<<

//20190506 Igor >>>
      if IsCloudStorageEnabled then begin  //20190522 Igor
        SetLength(Clouds, 0);
        with HelperManager do
        begin
          for iCloud := 0 to HelperClassList.Count - 1 do
          begin
            //20190522 Igor >>>
            if HelperManager.Config(HelperClassList.Keys.ToArray[iCloud].ClassName,
                     AppT1_2026.AppId, User.UserName).SaveReturnToCloud or CheckIsCloud then
              if HelperManager.AllowSend(iCloud) then
              begin
                SetLength(Clouds, length(Clouds) + 1);
                Clouds[length(Clouds) - 1] := iCloud;
              end;
            //20190522 Igor <<<
          end;
        end;
        vSaveResult := SaveReturn(RNo, DataDir, FlName, false, True, false, True, Clouds);
        if CheckIsCloud(True) and (vSaveResult = 0) then begin //20190522 Igor
          TFile.Delete(TPath.Combine(DataDir, FlName));
        end;
      end else begin
        vSaveResult := SaveReturn(RNo,DataDir,FlName,True,True);
      end;
      If vSaveResult = 0 then
//      If SaveReturn(RNo,DataDir,FlName,True,True) = 0 then
//20190506 Igor <<<
      begin
        Ret[RNo].SourceDataDir := DataDir;
        Ret[RNo].SourceFlName := FlName;
        If (LicenseLevel in anyMulti) and (Vl(FetchElm(RNo,'FPCHECK',35)) >0)
          then UpdateFpAssist(RNo,DataDir,FlName);
        Ret[RNo].changed:=False;
      end
      else
      begin
        //20170628 Igor >>>
        if not (asSilentSave in ApplicationState) then
        begin
          ShowMessage('Return was not saved... Press any key');
        end;
        //20170628 Igor <<<
        Ret[RNo].CouplingSw:=OldCouplingSw;  //20091226
        exit;
      end;
      Ret[RNo].CouplingSw:=OldCouplingSw;  //20091226
    END;
  end;  //i
  //Screen.Cursor:=CrDefault;
  //ShowTimedMsg('All returns saved',1200);
  Result:=True;
end;

(*
Function TGuiT1_2026.DoSaveAllReturns(RNo: integer):Boolean;
//Function TMainForm.SaveAllReturns:Boolean;
Var
  i:Integer;FlName,DataDir:String;
  //RNo:Integer;
  OldCouplingSw:Boolean;
begin
  { From SaveAllReturns, save single return only
  }
  //If RetInMem=0 then exit;
  if Ret[RNo].IsLastYearReturn or Ret[RNo].isAppendix then exit(True); //20170811 Igor

  Result:=False;
  //Screen.Cursor:=CrHourGlass;
  //for i :=0 to (RetList.Count - 1) do
  begin
    //RetRec := RetList.Items[i];
    //RNo:=RetRec^.RetNo;

    //20091226
    OldCouplingSw:=Ret[RNo].CouplingSw;
    Ret[RNo].CouplingSw:=False;

    CalcFullReturn(RNo);
    RecalcEverything(RNo);
    //CalcUsedFrm(RNo);  // NO GOOD - picks up the same
    Ret[RNo].CalcStatus := True;
    CountDiagnostics(RNo);
    If RetList[RNo].MandatoryErrorCount > 0 then
    begin
      //20170628 Igor >>>
      if not (asSilentSave in ApplicationState) then
      begin
        OpenForm(RNo,GetFormNo('INFO'),0);
        If not MainForm.LeftPanel.Visible then
        begin
          //MainForm.LeftPanel.Visible:=True;
          //AuditOpenBtnClick(Application);
          MainForm.GuiCommand(gcToggleLeftPanel);
        End;
        MainForm.RefreshAuditPanel(RNo);
        ShowMessage('Please fix Mandatory data before saving and try again');
      end;
      //20170628 Igor <<<
      Screen.Cursor:=CrDefault;
      Ret[RNo].CouplingSw:=OldCouplingSw;  //20091226
      exit;
    end;
    FlName := Ret[RNo].SourceFlName;
    If FlName = '' then
    FlName := LeftStr(FetchElm(RNo,'INFO',3),8)+
      '.'+RightStr(FetchElm(RNo,'INFO',3),1);
    DataDir := Ret[RNo].SourceDataDir;
    If IsDataDirectoryGood(DataDir) = False then exit;
    If DirectoryExists(DataDir) = False then
    begin
      ShowMessage('Directory does not exist');
      Ret[RNo].CouplingSw:=OldCouplingSw;  //20091226
      Exit;
    End;
    //20160327 Igor >>>
    If FileExists(DataDir+'\'+ClientsTable_dbf) then
    begin
      ShowMessage(DataDir + CHR(13)
                +'The data directory is NOT compatible with the Multi-App version.'+#13+
                 'Please use another data directory, such as ' + OptRec.Dir_Cur  +' in the  Save As  window');
      exit;
    end;
    //20160327 Igor <<<
    //20150826 igor
    If FileExists(DataDir+'\'+ClientsDbLite) = False then
    begin
      ShowMessage('Data directory '+DataDir + ' was not configured for tax returns');
      Ret[RNo].CouplingSw:=OldCouplingSw;  //20091226
      Exit;
    End;

    If Ret[RNo].Locked = true then
    begin
      ShowMessage('Cannot save: '+ GetFirstName(RNo)+' '+GetLastName(RNo)+
        chr(13)+'This return has been locked');
      //exit;
    end
    else
    BEGIN
      {put changed STATUS form data}
      with Ret[RNo].Frm[GetFormNo('STATUS')] do
      begin
        {last update}
        Strings[11] := User.UserName;
        Strings[12] := FormatDateTime('yyyy-mm-dd',Now);
        Strings[13] := TimeToStr(Time);
      end;

      //may 15 2008
      //20170628 Igor >>>
      if not (asSilentSave in ApplicationState) then
      begin
        OpenForm(RNo,GetFormNo('INFO'),0);  //may 15 2008
        CalcUsedFrm(RNo);  //may 15 2008
      end;
      //20170628 Igor <<<

      If SaveReturn(RNo,DataDir,FlName,True,True) = 0 then
      begin
        Ret[RNo].SourceDataDir := DataDir;
        Ret[RNo].SourceFlName := FlName;
        If (LicenseLevel in anyMulti) and (Vl(FetchElm(RNo,'FPCHECK',35)) >0)
          then UpdateFpAssist(RNo,DataDir,FlName);
        Ret[RNo].changed:=False;
      end
      else
      begin
        //20170628 Igor >>>
        if not (asSilentSave in ApplicationState) then
        begin
          ShowMessage('Return was not saved... Press any key');
        end;
        //20170628 Igor <<<
        Ret[RNo].CouplingSw:=OldCouplingSw;  //20091226
        exit;
      end;
      Ret[RNo].CouplingSw:=OldCouplingSw;  //20091226
    END;
  end;  //i
  //Screen.Cursor:=CrDefault;
  //ShowTimedMsg('All returns saved',1200);
  Result:=True;
end;
*)
procedure TGuiT1_2026.SaveandCloseAllopenedreturns1Click(Sender: TObject);
Var i:Integer;
begin
 If MainForm.SaveAllReturns= True then
  MainForm.CloseAllReturns;
end;


procedure TGuiT1_2026.CloseallreturnsWITHOUTSaving1Click(Sender: TObject);
begin
 if MessageDlg('Close ALL returns without saving them?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then MainForm.CloseAllReturns;
end;

procedure TGuiT1_2026.Familysetup1Click(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(RetNo,'FAMSET',0);
end;

procedure TGuiT1_2026.SENDtransaction1Click(Sender: TObject);
Var RetNo:Integer;
begin
end;

procedure TGuiT1_2026.Provincialnews1Click(Sender: TObject);
begin
 ShowHelp('PROVNEWS','HELP_CONTENTS');
end;

procedure TGuiT1_2026.TakeShapshotforT1Adj1Click(Sender: TObject);
Var i,FNo:Integer;
begin
 If ButtonInactive then exit;

 If GetSinNo(RetNo) ='' then
 begin
   ShowMessage('Please complete the Client Identification data first (SIN, etc)');
   Exit;
 end;

 if MessageDlg('The current return must have the BEFORE adjustments data. Proceed?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;
 CreateSnapshot(RetNo,'B');
 ShowMessage('Done. Now revise the return and'+
     Chr(13)+'either click on Show full variance on the T1ADJ form'+
     Chr(13)+'Or prepare manually the T1ADJ form');

 end;

procedure TGuiT1_2026.CreatetheT1ADJform1Click(Sender: TObject);
Var i,FNo:Integer;
begin
   If ButtonInactive then exit;
   CreatetheT1ADJform(RetNo);
   FNo:=GetFormNo('T1ADJ#1');
   StoreElm(RetNo,FNo,21,'N');
   OpenForm(RetNo,FNo,0);
   Ret[RetNo].FormHasData['T1ADJ#1']:=True;
end;

Function TGuiT1_2026.CountFiles(Dir:String;FileExt:String):Integer;
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

procedure TGuiT1_2026.Buildreport1Click(Sender: TObject); //20170504 igor
begin
 //ShowMessage('Custom Report Builder coming soon...');   //20170515
//20180130  If UpperCase(InputBox('Input Box', 'Enter Password', '')) <> 'N/A' then exit;  //20170515    //20170810 Password instead of Passwod
 //20170509
 if (LicenseLevel in [llPower..llMultiPower])
 or (isEnterpriseVersion) //20250119
 then     //20180130
 ReportBuilder(AppT1_2026)
 else
 begin
  ShowMessage('Available only in the Power/Enterprise versions of the program');
  Exit;
 end;
end;

procedure TGuiT1_2026.BusinessSummary1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 OpenForm(RetNo,'BUSSUM',0);
end;

procedure TGuiT1_2026.RentalSummary1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 OpenForm(RetNo,'RENTSUM',0);
end;


procedure TGuiT1_2026.RepairReturn1Click(Sender: TObject);//20170420 Igor
var
  S: String;
begin
  if not OpenDialog.execute then exit;
  if RepairReturn(OpenDialog.FileName, S) then
    MessageDlg('Repair return completed. Please check forms:' + S, mtInformation, [mbOk],0);
end;

procedure TGuiT1_2026.RequestESignatureConfirmation1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 ExecuteForm(TSaveAsPdfT1_2026);
end;

procedure TGuiT1_2026.RequestSignature_OfficeClick(Sender: TObject); //20210407 Igor
begin
  If ButtonInactive then exit;
  RequestSignature(RetNo); //20210408 Igor
end;

procedure TGuiT1_2026.RequestTDDBtnClick(Sender: TObject);
begin
// If UpperCase(InputBox('Autofill will be available by CRA on Feb 20', 'PSW', '')) <> 'N/A' then exit;  //20200121
//If IsTDDOpenForUse=false then begin ShowTddNotAvailableForUse;Exit;end;  //20160205 //20160216 Igor
OpenAutoFillLogin; //20160126 Igor;
end;

procedure TGuiT1_2026.CICALineByLineInternethelpNONResidents1Click(Sender: TObject);
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


procedure TGuiT1_2026.OtherGuides1Click(Sender: TObject);
Var PgmPath,PgmFile:String;
begin
  SomeList.Clear; // := TStringList.Create;
 SomeCaption := 'CRA GUIDES';
 (*
 If DirectoryExists(AppDir+'\GUIDES') = false then
 begin
  ShowMessage('The new Guides should be downloadeded from the VisualTax Downloads page');
  Exit;
 end
 Else
 *)
 //20240316
 If DirectoryExists(AppDir+'\guides') = false then ForceDirectories(AppDir+'\guides');

 If FileExists(AppDir+'\guides'+'\guides.d') = false then
 begin
  ShowMessage('The new Guides should be downloaded from the VisualTax Downloads page, when available,'
  +Chr(13)+'and unzipped into '+AppDir+'\guides');

  if MessageDlg('Download now?', mtInformation, [mbYes, mbNo], 0) = mrYes then  //20240316
  begin
   ConnectToWeb('http://www.visualtax.com/downloads/guides.exe');
  end
  Else
   Exit;
 end;

 SelectedString := PopSomeFile(AppDir+'\guides'+'\guides.d',SomeCaption);
 If SelectedString > '' then ShowPdf(AppDir+'\guides',AllTrim(LeftStr(SelectedString,20)));

end;

procedure TGuiT1_2026.EFileHelpDesk1Click(Sender: TObject);
Var HelpTopic:String;
begin

 ConnectToWeb('https://www.canada.ca/en/revenue-agency/services/e-services/e-services-businesses/efile-electronic-filers/efile-helpdesk-support-t1-returns.html'); //20180208

 // HelpTopic := 'EFileHelpDesk';
 // ShowHelp(AppT1_2026.ModuleHelpFile, HelpTopic, True); //20161220 Igor
end;

procedure TGuiT1_2026.CCArates1Click(Sender: TObject);
begin
  SomeList.Clear; // := TStringList.Create;
 //SomeList.Sorted := True;
 SomeCaption := 'CCA RATES (Class  Rate  Description)';
 SelectedString := PopSomeFile(AppDir+'\'+'CCARATES.D',SomeCaption);
end;

procedure TGuiT1_2026.CDEClientDataEnquireShowdata1Click(Sender: TObject);
Var RetNo:Integer;  //20160213
begin
 //20160213 //20160216 Igor
 If ButtonInactive then Exit;
 RetNo:=GetCurrentRetNo;
 If RetNo>0 then OpenForm(RetNo,GetFormNo('CDE'),0);
end;

procedure TGuiT1_2026.FSumBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 Screen.Cursor:=CrHourGlass;
 CalcAll(RetNo);
 RecalcEverything(RetNo);
 Screen.Cursor:=CrDefault;
 OpenForm(RetNo,'FAMSUM',0);
end;

procedure TGuiT1_2026.FamilySummary1Click(Sender: TObject);
begin
FSumBtnClick(Sender);
end;

procedure TGuiT1_2026.Checkupdates1Click(Sender: TObject);
begin
 CheckUpdates(Self.Handle,AppName+'-'+AppYear);
end;

procedure TGuiT1_2026.Frequentlyaskedquestions1Click(Sender: TObject);
Var h:THandle;
begin
  ConnectToWeb('www.visualtax.com/t1faq.php'); //20140228 //changed from .htm to .asp
end;

procedure TGuiT1_2026.VisualTaxForum1Click(Sender: TObject);
Var h:THandle;
begin
  ConnectToWeb('http://www.visualtax2.com/cgi-bin/dcforum/dcboard.cgi');

end;

procedure TGuiT1_2026.HowoftentocheckInternetUpdates1Click(Sender: TObject);
begin
 Application.CreateForm(TUpdateScheduleT1_2026,UpdateSchedule);
 UpdateSchedule.ShowModal;
 UpdateSchedule.Free;
end;

procedure TGuiT1_2026.CICA1Click(Sender: TObject);
Var h:THandle;
begin
  ConnectToWeb('http://www.knotia.ca/Knowledge/LBL/Index.cfm?kType=93&LBLGuideID=1');
end;

procedure TGuiT1_2026.CICAHelpbyline1Click(Sender: TObject);
Var ln:String;
begin
 ln:= InputBox('Input Box', 'Enter a line: 101 to 479', '101');
 LinkToCICA(Ln);
end;

procedure TGuiT1_2026.CICAReferencematerials1Click(Sender: TObject);
Var h:THandle;
begin
 ConnectToWeb('http://www.knotia.ca/Knowledge/LBL/Reference.cfm?kType=93&LBLGuideID=1&bAppendices=1');
end;

procedure TGuiT1_2026.TrEngineLoadClick(Sender: TObject);
//20170904 Igor>>>
//Var h : Thandle;
begin
  LoadTr(GetTrFolder);
// TrFolder:=GetTrFolder;
// If fileExists(TrFolder+'\'+'TR2017'+'.EXE') = false then
// begin
//  ShowMessage('The TR-2017 was not installed in '+TrFolder+
//   Chr(13)+' Please click Configure -> TR (Tax Research) program directory on the top menu');
//  Exit;
// end;
//
// h:=GetTrHandle;
// If h <> 0 then
//   ShowWindow(h,SW_SHOWMAXIMIZED)
// else
//   LoadTr(TrFolder);
//20170904 Igor<<<
end;

procedure TGuiT1_2026.ListMultipleBtnClick(Sender: TObject);
Var I,J,MxPg,k,FNo:Integer; FName,FNonInst,FRootName:string; //[10];
begin
  if ButtonInactive then exit;
  If IsFormMultiInst(FormName) then //IsFormASlip(FormName) then
  begin
   If (LeftStr(FormName,6) ='T2125_')
   or (LeftStr(FormName,6) ='T2042_')
   or (LeftStr(FormName,5) ='T2121')
   or (LeftStr(FormName,5) ='T1163')  then
   begin
     BusinessSummary1Click(Sender);
     Exit;
   end;
   If (LeftStr(FormName,4) ='T776') then
   begin
     RentalSummary1Click(Sender);
     Exit;
   end;

   If (LeftStr(FormName,7) ='ACBFRM#') then
   begin
     ACBPortfolioSummary1Click(Sender);
     Exit;
   end;

  SomeList.Clear; // := TStringList.Create;
   FNonInst:= ExtractNonInstFormName(FormName);
   for i :=0 to (FList.Count - 1) do
   begin
    FRec := FList.Items[i];
    If FNonInst = Frec.FormName then
    begin
      FNo:=Frec.FormNo;
      //FInst:=Frec.FormInst;
      If Ret[RetNo].FormHasData[Frec.FormInstName] then //20160703 Igor
      Begin
        If LeftStr(FormName,3)='T5#' then Somelist.Add(PaddR(FRec.FormInstName,10)+' '+FetchElmFNo(RetNo,FNo,1)+' '+FetchElmFNo(RetNo,FNo,14))
        else If LeftStr(FormName,3)='T4#' then Somelist.Add(PaddR(FRec.FormInstName,10)+' '+FetchElmFNo(RetNo,FNo,1))
       // else If LeftStr(FormName,3)='T3#' then Somelist.Add(PaddR(FNonInst+FInst,10)+' '+FetchElmFNo(RetNo,FNo,1)+' '+FetchElmFNo(RetNo,FNo,17))
        else If LeftStr(FormName,7)='T3MULT#' then Somelist.Add(PaddR(FRec.FormInstName,10)+' '+FetchElmFNo(RetNo,FNo,1)+' '+FetchElmFNo(RetNo,FNo,17))
        else If LeftStr(FormName,3)='T4A#' then Somelist.Add(PaddR(FRec.FormInstName,10)+' '+FetchElmFNo(RetNo,FNo,15))
        else If LeftStr(FormName,3)='T4PS#' then Somelist.Add(PaddR(FRec.FormInstName,10)+' '+FetchElmFNo(RetNo,FNo,1))
        else If LeftStr(FormName,3)='T5013#' then Somelist.Add(PaddR(FRec.FormInstName,10)+' '+FetchElmFNo(RetNo,FNo,41))
        else If LeftStr(FormName,7)='INVGEN#' then
           Somelist.Add(PaddR(FRec.FormInstName,10)+' '+PaddR(FetchElmFNo(RetNo,FNo,211),30)
           +' Issued: '+PaddR(FetchElmFNo(RetNo,FNo,203),15)
           +' For $'+PaddR(FormatFloat('###,###.00',Vl(FetchElmFNo(RetNo,FNo,284))),8)
           +' Paid: '+FetchElmFNo(RetNo,FNo,209))
        else If LeftStr(FormName,6)='AUTOS#' then
           Somelist.Add(PaddR(FRec.FormInstName,10)+' '+PaddR(FetchElmFNo(RetNo,FNo,1),25)
           +' CLAIMED on '
           +PaddR(FetchElmFNo(RetNo,FNo,215),7)+' '+PaddR(FetchElmFNo(RetNo,FNo,216),6)+'% '
           +PaddR(FetchElmFNo(RetNo,FNo,221),7)+' '+PaddR(FetchElmFNo(RetNo,FNo,222),6)+'% '
           +PaddR(FetchElmFNo(RetNo,FNo,227),7)+' '+PaddR(FetchElmFNo(RetNo,FNo,228),6)+'% ')

        else If LeftStr(FormName,5)='T777#' then        //20200513
         Begin
            Somelist.Add(PaddR(FRec.FormInstName,12)+' '+PaddR(FetchElmFNo(RetNo,FNo,68),25)); //20200513 Empl name
         End

        else If LeftStr(FormName,8)='AUTO777#' then        //20200512
         Begin
            Somelist.Add(PaddR(FRec.FormInstName,12)+' '+PaddR(FetchElmFNo(RetNo,FNo,1),25)
            +PaddR(' CLAIMED on ',13)
            +PaddR(FetchElmFNo(RetNo,FNo,215),7)+' '+PaddR(FetchElmFNo(RetNo,FNo,216),6)+'% '
            +PaddR(' CCA class ',10)+PaddR(FetchElmFNo(RetNo,FNo,134),7))
         End

        else If LeftStr(FormName,8)='ASSETSB#' then
            Somelist.Add(PaddR(FRec.FormInstName,10)+' '+PaddR(FetchElmFNo(RetNo,FNo,1),50)
            +' CLAIMED on '
            +PaddR(FetchElmFNo(RetNo,FNo,215),7)+' '+PaddR(FetchElmFNo(RetNo,FNo,216),6)+'% '
            +PaddR(FetchElmFNo(RetNo,FNo,221),7)+' '+PaddR(FetchElmFNo(RetNo,FNo,222),6)+'% '
            +PaddR(FetchElmFNo(RetNo,FNo,227),7)+' '+PaddR(FetchElmFNo(RetNo,FNo,228),6)+'% ')
        else If LeftStr(FormName,7)='ACBFRM#' then
          Somelist.Add(PaddR(FRec.FormInstName,10)+
          ' '+PaddR(FetchElmFNo(RetNo,FNo,4),15)+
          ' '+PaddR(FetchElmFNo(RetNo,FNo,2),15)+
          ' '+'UNITS '+PaddR(FetchElmFNo(RetNo,FNo,12),15)+
          ' '+PaddR(FetchElmFNo(RetNo,FNo,3),35))
        else If LeftStr(FormName,5)='S2MJ#' then Somelist.Add(PaddR(FRec.FormInstName,10)+' '+FetchElmFNo(RetNo,FNo,15))
        else If LeftStr(FormName,6)='S11MJ#' then Somelist.Add(PaddR(FRec.FormInstName,10)+' '+FetchElmFNo(RetNo,FNo,32))
        else Somelist.Add(PaddR(FRec.FormInstName,12));
      end;
    end; //found the form
   end;  //i
   SomeCaption := 'List of multi-instance forms';
   SelectedString := PopSomeList(SomeList,SomeCaption);
   If SelectedString > '' then
    OpenForm(RetNo,GetFormNo(AllTrim(LeftStr(SelectedString,11))),0);  //20160307  10 to 12  //20150617
     //OpenForm(RetNo,GetFormNo(AllTrim(LeftStr(SelectedString,12))),0);  //20160307  10 to 12
   Exit;
 end;  //check slips
end;

procedure TGuiT1_2026.TrGuide1Click(Sender: TObject);
begin
ConnectToWeb('www.visualtax.com/TR/TRGuide/TRGuide-2017.htm');  //20160203 //20160216 Igor
end;

procedure TGuiT1_2026.DefinetheTRfolder1Click(Sender: TObject);
//20170904 Igor>>>
//Var TempList:TStringList;Prompt:String;
begin
  SetupTrFolder;
// Prompt:=GetTrFolder;
// If Prompt='' then Prompt:='C:\TR-2017';
// TrFolder:= InputBox('Input Box', 'Enter your TR installation folder', Prompt);
// If UpperCase(TrFolder)=UpperCase(AppDir) then
// begin
//  ShowMessage('The TR must be installed outside the T1 or T2 program folder');
//  If fileExists(AppDir+'\'+'Trfolder.d') then
//    sysutils.DeleteFile(AppDir+'\'+'Trfolder.d');
//  Exit;
// end;
// TempList:=TStringList.Create;
// TempList.add(TrFolder);
// TempList.SaveToFile(AppDir+'\'+'TrFolder.d');
// TempList.Free;
// If FileExists(TrFolder+'\'+'TR'+AppYear+'.exe') = false then  //20130511
// ShowMessage('The TR-'+AppYear + ' was not installed in '+TrFolder+' directory'); //20130511
//20170904 Igor<<<
end;

procedure TGuiT1_2026.TheWindowsClick(Sender: TObject);
begin
  TileThem;
end;

procedure TGuiT1_2026.ShowLastYearForm1Click(Sender: TObject);
//Var
//  FlName:String;
//  i, ThisYearRetNo:Integer;
//  LastYearFormNo:Integer;
//  PrevCouplingSw:Boolean;
//  ThisYearFormNo,RetNo:Integer;
begin
  MainForm.GuiCommand(gcShowLastYear);
//  If ButtonInactive then exit;
//  RetNo := FRetNo; //DoDi: copy into local var
//  //Start with current return and look it up
//  If IsValidLastYearPgmFolder= false then
//  begin
//    ShowMessage('Last year'+Chr(39)+'s program folder is incorrect'
//                +Chr(13)+'See Configure -> General Options -> Data Directories');
//    Exit;
//  end;
//  //20110228
//  If FileExists(OptRec.Dir_PgmLastYr+'\'+FormsDBLite)= false then
//  begin
//    ShowMessage('Last year'+Chr(39)+'s program folder does not have'
//                +Chr(13)+'the required files such as '+FormsDBLite
//                +Chr(13)+'See Configure -> General Options -> Data Directories'
//                +Chr(13)+' '
//                +Chr(13)+'After proper set up, CLOSE the program and run it again');
//    Exit;
//  end;
//
//  ThisYearRetNo:=RetNo;
//  If ShowUnconvertedLastYear(ThisYearRetNo) = True then Exit; //applies only to current returns
//  If ThisYearRetNo=0 then
//  begin
//   ShowMessage('You need to open this year'+Chr(39)+'s return first');
//   Exit;
//  end;
//  LastYearFormNo:=GetLastYearFormNo(SubstituteLastYearForm(FormName));
//  If LastYearFormNo=0 then
//  begin
//   ShowMessage('Form not found');
//   Exit;
//  end;
//
//
//  If Ret[ThisYearRetNo].LastYearRetNo > 0 then
//  begin
//   RetNo:=Ret[ThisYearRetNo].LastYearRetNo;
//   OpenForm(RetNo,LastYearFormNo,0);
//   Exit;
//  end;
//
//  FlName := Ret[ThisYearRetNo].GetDefaultFileName; // LeftStr(GetSinNo(ThisYearRetNo),8)+'.'+RightStr(GetSinNo(ThisYearRetNo),1); //20160305 Igor
//  If not FileExists(OptRec.Dir_LastYr+'\'+FlName) then
//  begin
//   ShowMessage('SIN '+GetSinNo(ThisYearRetNo)+ ' not found in last year'+Chr(39)+'s folder '+
//    Chr(13)+OptRec.Dir_LastYr
//    +Chr(13)+'See Configure | Data Directories');
//  Exit;
// end;
// //March 15 2008
// PrevCouplingSw:=Ret[ThisYearRetNo].CouplingSw;  //March 17 2008
//
//{ TODO : OpenLastYearReturn }
//
//(* Production code configures the return for reading last year
//  BEFORE reading the data!
//
// RetNo:=InitNewReturn;
//// ret[RetNo].IsLastYearRetNo:=True;     //20110215
// //last year's return just opening
// ret[RetNo].IsLastYearRetNo:=True;
// ret[RetNo].LastYearData:=True;
//// ret[RetNo].LastYearRetNo:=0;  //20110220
//
// OpenResult := OpenReturn(RetNo,OptRec.Dir_LastYr,FlName,False);
//
//*)
//
// RetNo := OpenReturn(OptRec.Dir_LastYr,FlName,False);
// If RetNo > 0 then
// begin
//   Ret[ThisYearRetNo].CouplingSw:=PrevCouplingSw;
//   //This Year's return
//   Ret[ThisYearRetNo].LastYearRetNo:=RetNo;
//   //last year's return just opening
//   OpenForm(RetNo,LastYearFormNo,0);
//
//  MainForm.FormPaint(Application); //required? flicker?
//
// end
// else
//  ShowOpenReturnFailure(RetNo,OptRec.Dir_LastYr,FlName);
end;

procedure TGuiT1_2026.NewReturnLblClick(Sender: TObject);
begin
  FileNewItemClick(Sender);
  Done;
end;

procedure TGuiT1_2026.OpenReturnLblClick(Sender: TObject);
begin
  //Openselectively1Click(Sender);
  FileOpenItemClick(Sender);
  Done;
end;

//20190507 IGOR
procedure TGuiT1_2026.ShowMostRecentReturns;
Var I:Integer;
    SomeList, vStringList:TStringList;  //20190507 Igor
    AColumn:TListColumn;
    AListItem:TListItem;
    MaxReturns:Integer;
    vListView : TListView; //20190507 Igor
    A: TArray<string>; //20200914 Igor
Begin
  if Application.Terminated then exit; //20170113 Igor
  //20170127 Igor >>>
  MostRecentLbl.Visible := not MainOptions.HideMostRecent;
  ListView1.Visible :=  not MainOptions.HideMostRecent;
  ListView2.Visible :=  not MainOptions.HideMostRecent; //20190507 Igor
  OpenItBtn.Visible :=  not MainOptions.HideMostRecent;
  EMailItBtn.Visible :=  not MainOptions.HideMostRecent;
  CopyAReturnBtn.Visible :=  not MainOptions.HideMostRecent;
//20190507 Igor >>>
  SetMainMenuTitle; //20191202 Igor
  if CheckIsCloud(true) and IsCloudStorageEnabled then begin
    ListView1.Visible := false;
  end else begin
    ListView2.Visible := false;
  end;
//20190507 Igor <<<

  //20170127 Igor <<<
  //rbnT1.ClearRecentItems;//20170825 Igor //20190415 Igor

  If MainOptions.HideMostRecent then Exit;
//20190507 Igor >>>
  if CheckIsCloud(true) and IsCloudStorageEnabled then
  With ListView2 do
  begin
    Items.BeginUpdate;
    try
      Items.Clear;
      Columns.Clear;
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
      AColumn.Width:=300;

      vStringList := TStringList.Create;

      MaxReturns:=slRecentCloud.Count-1;
      If MaxReturns>30 then MaxReturns:=30;
      For i:=0 to MaxReturns do
      begin
          AListItem := Items.Add;
          vStringList.CommaText := slRecentCloud[i];
          AListItem.Caption := vStringList[0];
          AListItem.SubItems.Add(vStringList[1]);
          AListItem.SubItems.Add(vStringList[2]);
          AListItem.SubItems.Add(vStringList[3]);
      end;
      vStringList.Free;
    finally
      Items.EndUpdate;
    end;
  end //with
  else
//20190507 Igor <<<
  With ListView1 do
  begin
    ListView1.Items.BeginUpdate; //20170127 Igor
    try                          //20170127 Igor
      ListView1.Items.Clear;
      ListView1.Columns.Clear; //20170130 Igor

  //    ListView1.Visible:=False;
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
      If FileExists(AppDir+'\'+RecentRFlName) then
      begin
       SomeList.LoadFromFile(AppDir+'\'+RecentRFlName);
       MaxReturns:=SomeList.Count-1;
       If MaxReturns>30 then MaxReturns:=30;
       For i:=0 to MaxReturns do //SomeList.count-1 do
       begin
        //ListBox1.Items.Add(SomeList[i]);
        //20200914 Igor >>>
        A := SomeList[i].Split([RecentDelim]);
        if Length(A) >= 5 then
        begin
          AListItem := Items.Add;
          AListItem.Caption := A[0];
          AListItem.SubItems.Add(A[1]);
          AListItem.SubItems.Add(A[2]);
          AListItem.SubItems.Add(A[3]);
          AListItem.SubItems.Add(A[4]);
        end;
        //20200914 Igor <<<
        //rbnT1.AddRecentItem(Trim(LeftStr(SomeList[MaxReturns - i],30)));//20170911 Igor //20190415 Igor
       end;
      end;
      SomeList.Free;
    //20170127 >>>
    finally
      ListView1.Items.EndUpdate;
    end;
    //20170127 <<<
  end; //with
  //ListView1.Visible:=True; //20170127 Igor
end;


(*
procedure TGuiT1_2026.ShowMostRecentReturns;
Var I:Integer;SomeList:TStringList;
    AColumn:TListColumn;
    AListItem:TListItem;
    MaxReturns:Integer;
Begin
  if Application.Terminated then exit; //20170113 Igor
  //20170127 Igor >>>
  MostRecentLbl.Visible := not MainOptions.HideMostRecent;
  ListView1.Visible :=  not MainOptions.HideMostRecent;
  OpenItBtn.Visible :=  not MainOptions.HideMostRecent;
  EMailItBtn.Visible :=  not MainOptions.HideMostRecent;
  CopyAReturnBtn.Visible :=  not MainOptions.HideMostRecent;
  //20170127 Igor <<<
  //rbnT1.ClearRecentItems;//20170825 Igor //20190415 Igor

  If MainOptions.HideMostRecent then Exit;
  With ListView1 do
  begin
    ListView1.Items.BeginUpdate; //20170127 Igor
    try                          //20170127 Igor
      ListView1.Items.Clear;
      ListView1.Columns.Clear; //20170130 Igor
  //    ListView1.Visible:=False;
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
      If FileExists(AppDir+'\'+RecentRFlName) then
      begin
       SomeList.LoadFromFile(AppDir+'\'+RecentRFlName);
       MaxReturns:=SomeList.Count-1;
       If MaxReturns>30 then MaxReturns:=30;
       For i:=0 to MaxReturns do //SomeList.count-1 do
       begin
        //ListBox1.Items.Add(SomeList[i]);
        AListItem := Items.Add;
        AListItem.Caption := LeftStr(SomeList[i],30);
        AListItem.SubItems.Add(LTrim(MidStr(SomeList[i],31,11)));
        AListItem.SubItems.Add(LTrim(MidStr(SomeList[i],42,12)));
        AListItem.SubItems.Add(LTrim(MidStr(SomeList[i],53,17)));
        AListItem.SubItems.Add(LTrim(MidStr(SomeList[i],66,100)));
        //rbnT1.AddRecentItem(Trim(LeftStr(SomeList[MaxReturns - i],30)));//20170911 Igor //20190415 Igor
       end;
      end;
      SomeList.Free;
    //20170127 >>>
    finally
      ListView1.Items.EndUpdate;
    end;
    //20170127 <<<
  end; //with
  //ListView1.Visible:=True; //20170127 Igor
end;
*)
procedure TGuiT1_2026.RollOverfromTaxCycle1Click(Sender: TObject); //20170428 Igor
begin

  //20170909 Igor<<<
 //20191217
 ShowMessage('Batch rollover (all returns) should be avoided with this early version'
      +Chr(13)+'as the data forms are still evolving.'
      +Chr(13)+Chr(13)+'Just rollover what you need now');

  RollOverFromTaxCycle(AppT1_2026, '2022T1'); //20170712 Igor  //20181228 //20211215
end;

procedure TGuiT1_2026.RollOvrerLblClick(Sender: TObject);
begin
  ImportBtnClick(Sender);
  Done;
end;

procedure TGuiT1_2026.WhatsNewLblClick(Sender: TObject);
begin
YourLatestReleaseClick(Sender);
end;

procedure TGuiT1_2026.FaQLblClick(Sender: TObject);
begin
Frequentlyaskedquestions1Click(Sender);
end;

procedure TGuiT1_2026.HelpLblClick(Sender: TObject);
begin
VisualTaxDemoGuide1Click(Sender);
end;

procedure TGuiT1_2026.ForumLblClick(Sender: TObject);
begin
VisualTaxForum1Click(Sender);
end;

procedure TGuiT1_2026.TRLblClick(Sender: TObject);
begin
TrEngineLoadClick(Sender);
end;

procedure TGuiT1_2026.Lockreturnagaistchanges1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 LockReturn(RetNo);
end;

procedure TGuiT1_2026.LogintoCRAforAutoFill1Click(Sender: TObject);//20160216 Igor
begin
  RequestTDDBtnClick(Application);
end;

procedure TGuiT1_2026.UnlockReturn1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 UnlockReturn(RetNo);
end;

procedure TGuiT1_2026.ServiceRequests_OfficeClick(Sender: TObject); //20210430 Igor
begin
  VirtualTaxOfficeInfo.ShowServiceRequests;
end;

procedure TGuiT1_2026.SetHorScrollBarInListBox(ListBox: TListBox; MaxWidth: Integer);
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

//20191202 Igor >>>
procedure TGuiT1_2026.SetMainMenuTitle;
begin
  {needs OptRec.Prp_NameAsTitle done by igor but not defined anywhere
  if (LicenseLevel in anyMulti) and (OptRec.Prp_NameAsTitle) then
    TradeMarkLbl.Caption := OptRec.Prp_Name
  else
  }
    TradeMarkLbl.Caption := 'VisualTax';
end;
//20191202 Igor <<<

procedure TGuiT1_2026.ListView1DblClick(Sender: TObject);
Begin
 OpenItBtnClick(Sender);
end;

procedure TGuiT1_2026.ListView1KeyPress(Sender: TObject; var Key: Char);
begin
 if (Key = #13) then {Return key}
   ListView1DblClick(Sender);
end;

procedure TGuiT1_2026.Options2Click(Sender: TObject);
begin
 If LicenseLevel in anyMulti then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;
 ExecuteForm(TOptionsFrmT1_2026);
end;


procedure TGuiT1_2026.QuestionMarkLblMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if Button = mbLeft then  { drag only if left button pressed }
 with Sender as TvtLabel do  {treat Sender as ??TFileListBox }
 begin
   (*
        if ItemAtPos(Point(X, Y), True) >= 0 then  { is there an item here? }
          BeginDrag(False);  { if so, drag it }
   *)
 end;

end;

procedure TGuiT1_2026.NextYearsRatesClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 ChangeRates;
end;

procedure TGuiT1_2026.ChangeRates;
begin
  if ButtonInactive then exit;
   //reverse/toggle
   If PlanningRy = 0  then
    begin
     PlanningRY:=1;PlanYear :=IntToStr(StrToInt(AppYear)+1); // '2013';    //20130511
     ShowTimedMsg(PlanYear+' tax rates selected',1200);
    end
   else if PlanningRY = 1 then
    begin
     PlanningRY:=0;PlanYear:=AppYear; //'2012';  //20130511
     ShowTimedMsg(PlanYear+' tax rates selected',1200);
   end;

 Calc(Retno,FormName);
 RecalcEverything(RetNo);
 CalcAll(RetNo);
 If GetSpRetNo(RetNo) >0 then
  begin
   RecalcEverything(GetSpRetNo(RetNo));
   CalcAll(GetSpRetNo(RetNo));
  end;
 OpenForm(Retno,FormNo,0);
 If FormNo>0 then MyChild.ShowFormData(FormName,FormNo);  //20160730

 MainForm.RefreshAuditPanel(RetNo);
 MainForm.FormPaint(Application);
 MyChild.UpdateChildTaxPanel;

end;

procedure TGuiT1_2026.SpeedButton2Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 Screen.Cursor:=CrHourGlass;
 CalcAll(RetNo);
 RecalcEverything(RetNo);
 Screen.Cursor:=CrDefault;
 OpenForm(RetNo,'BUSSUM',0);
end;

procedure TGuiT1_2026.LicLevel1Click(Sender: TObject);
begin
ChangeLicenseLevel;
end;

procedure TGuiT1_2026.PrepareDistr1Click(Sender: TObject);
//Var Psw:String;
begin
  if not GetDeveloperPwd then exit;
  AppT1_2026.PrepareDistribution;
  { TODO : prepare LastYearDistribution }
end;


procedure TGuiT1_2026.ReturnsHeaderPanelClick(Sender: TObject);
begin
  if LicenseLevel in [llNetFile..llStd]
 then exit;
 NextYearsRatesClick(Sender);
end;

procedure TGuiT1_2026.SetupEOL1Click(Sender: TObject);
begin
  ExecuteForm(TEOLSetUpT1_2026);
end;

procedure TGuiT1_2026.SetupEOLPlus1Click(Sender: TObject);
begin
  ExecuteForm(TEOLPSetUpT1_2026);
end;


procedure TGuiT1_2026.EkUDFList1Functions0Calculate(Sender: TObject;
  Args: TEkUDFArgs; ArgCount: Integer; UDFResult: TObject);
begin
  //ShowMessage('In UDF calculate routine');
  If UdfResult is  TPicture then
  begin
    //ShowMessage('it is image');  //ok
    //image1 uknkown - in MainForm?
    With UDFResult as TPicture do
    begin
       Bitmap.Width:=Image1.Width;
       Bitmap.Height:=Image1.Height;
       Bitmap.Canvas.Draw(0,0,Image1.Picture.Graphic);
    end;
  end;
end;

procedure TGuiT1_2026.ElectronicSignature1Click(Sender: TObject);
begin
ExecuteForm(TSignatureT1_2026);  //20200324
end;

Procedure TGuiT1_2026.GetGraphic;
begin
 //ShowMessage('In GetGraphic');
end;
//20171128 Igor>>
function TGuiT1_2026.GetStateForDataExtract: boolean;
begin
  {to-do calc state for TaxTyme client}
  Result := AllowImportExport; //True; 20171202
end;
//20171128 Igor<<
function TGuiT1_2026.GetZoomStr: String;//20170824 Igor
begin
  Result := ZoomPercentLbl.Caption;
end;

procedure TGuiT1_2026.GoToaFormSection1Click(Sender: TObject);
begin
 //UHeaderFrame.SectionBtnClick(Sender);
end;

procedure TGuiT1_2026.EmailTheReturnClick(Sender: TObject);
 Var i,j: integer; FormsToPrint :TstringList;
    Copies, Template, s:String;
begin
 If ButtonInactive then exit;
 RecalcEverything(RetNo);
 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  If not MainForm.WizardPanel.visible then MainForm.AuditOpenBtnClick(Sender);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Not AllowedToFullPrint(RetNo) then begin PdfPrint:=False;exit;end;

 Calc(RetNo,'DIAGNO');
 //LetterType := 'Cover';
 If Ret[RetNo].CalcStatus = False then CalcAll(RetNo);
 UpdateAllDataIndicators(RetNo);
 If SlipsAvailable(RetNo) then
   Ret[RetNo].FormHasData['T4SUM#1'] := True;

 Template := GetPrintTemplate;

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

Procedure TGuiT1_2026.PrintReturnForEmail(RetNo:Integer;Template:String);
Var i,j: integer; FormsToPrint :TstringList;
    Copies : string; //[1];
    OldPrinterName:String;
    PDFFullfileName:String;
begin
 If IsPrinterInstalled('PDFFactory') then
 begin
  ShowMessage('The forms(s) will be printed in PDF format.'+
               Chr(13)+'Once completed, click SEND to EMAIL it');
 end
 Else
 begin
  ShowMessage('the PDFFactory printer Driver has not been installed');
  ExecuteForm(TPDFFrmT1_2026);
  Exit;
 end;
 OldPrinterName:=GetDefaultPrinterName;
 SetDefaultPrinter('PdfFactory');

 If SlipsAvailable(RetNo) then
   Ret[RetNo].FormHasData['T4SUM#1'] := True;
 FormsToPrint := TstringList.Create;
 FormsToPrint.Sorted :=False;
 GetFormsToPrint(RetNo,Template,FormsToPrint);

 ResortFormsToPrint(FormsToPrint);

 If FormsToPrint.Count =0 then
 begin
    ShowMessage('Selected template has no forms for printing');
    FormsToPrint.Free;
    exit;
  end;
 PrintReturn(RetNo,FormsToPrint,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName);
 FormsToPrint.Free;
 PdfPrint:=False;
 SetDefaultPrinter(OldPrinterName);
end;

//20190506 Igor
procedure TGuiT1_2026.OpenItBtnClick(Sender: TObject);
Var i,ThisResult:Integer;Dir,FlName,Sin:String;
 AListItem:TListItem;
 RetNo:Integer;
//
  mi: TMenuItemEx;
//
begin
  (* //20200306 Igor
  //20200305 Igor >>>
  if CheckIsCloud(true) then
  begin
    FileOpenItemClick(FileOpenItem);
    Exit;
  end;
  //20200305 Igor <<<
  *)
  If OptRec.Dir_Planner = OptRec.Dir_Cur then
  begin
    ShowMessage('Click on Configure | General Options | Data Directories'+
    Chr(13)+'Change the Tax planner Dir to be different than the Current Directory'+
    Chr(13)+'i.e. enter it as C:\T1-'+AppYear+'\Planner');
    Exit;
  end;
//20190506 Igor >>>
  if ListView1.Visible then begin
    AListItem:=ListView1.ItemFocused;
  end else begin
    AListItem:=ListView2.ItemFocused;
  end;
//  AListItem:=ListView1.ItemFocused;
//20190506 Igor <<<
  If AListItem = Nil then
  begin
   ShowTimedMsg('You must select a file first',1200);
   Exit;
  end;

//20190506 Igor >>>
  FlName := AllTrim(AListItem.SubItems[2]);
  if CheckIsCloud(true) and IsCloudStorageEnabled then begin
    OpenFromCloudClick(AListItem);
  end else begin
    Dir:=AllTrim(AListItem.SubItems[3]);
    OpenReturnCoupled(Dir,FlName, True); //assume always visible
  end;
//20190506 Igor <<<
end;


(*
procedure TGuiT1_2026.OpenItBtnClick(Sender: TObject);
Var i,ThisResult:Integer;Dir,FlName,Sin:String;
 AListItem:TListItem;
 RetNo:Integer;

begin
  If OptRec.Dir_Planner = OptRec.Dir_Cur then
  begin
    ShowMessage('Click on Configure | General Options | Data Directories'+
    Chr(13)+'Change the Tax planner Dir to be different than the Current Directory'+
    Chr(13)+'i.e. enter it as C:\T1-'+AppYear+'\Planner');
    Exit;
  end;
  AListItem:=ListView1.ItemFocused;
  If AListItem = Nil then
  begin
   ShowTimedMsg('You must select a file first',1200);
   Exit;
  end;

  FlName := AllTrim(AListItem.SubItems[2]);
  Dir:=AllTrim(AListItem.SubItems[3]);
  OpenReturnCoupled(Dir,FlName, True); //assume always visible
end;
*)
procedure TGuiT1_2026.EMailItBtnClick(Sender: TObject);
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
 If LicenseLevel in anyMulti then
 begin
   If not User.EqualOverloadProperty(AppT1_2026, 'Dir_Cur', Dir, true) then //20170112 Igor
   begin
    If YouKnowTheAdminPassword = false then exit;
   end;
 end;

 If AListItem = Nil then
 begin
   ShowTimedMsg('You must select a file first',1200);
   Exit;
 end;

  SomeList.Clear; // := TStringList.Create;
 SomeCaption := 'Double click on item 1, 2, 3 or 4';
 SomeList.Add('1. Email the tax return (raw data file) to your own EMail...');
 SomeList.Add('2. Email the tax return (raw data file) to tax return Reviewer...');
 SomeList.Add('3. Email the tax return (raw data file) to VisualTax support...');
 SomeList.Add('4. Email the tax return (raw data file) to any Email address...');
 SomeList.Add('________________________________________________________________');
 SomeList.Add('5. EMail the tax return (Printout only) to any Email address...');
 SomeList.Add('   See also: Print|Email current form...(after opening the return)');
  SelectedString := PopSomeList(SomeList,SomeCaption);
  //SomeList.Free; //20160628 Igor
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

  If SelectedString='3' then SomeRecipientEmail:='support@visualtax.com';     //20180311
  If SelectedString='4' then SomeRecipientEmail:='';

  FlName := AllTrim(AListItem.SubItems[2]);
  Dir:=AllTrim(AListItem.SubItems[3]);

  SomeSenderEmail:='';  //default?  'VisualTax@Sympatico.ca';
  SomeSubject:='A tax return';
  SomeAttachment:=Dir+'\'+FlName;
  SomeText:='The tax return is attached'
                +chr(10)+Chr(13)+' '
                +chr(10)+Chr(13)+' '
                +chr(10)+Chr(13)+'Thank you '
                +chr(10)+Chr(13)+' '
                +chr(10)+Chr(13)+OptRec.Prp_Name
                +chr(10)+Chr(13)+' ('+OptRec.Prp_Area+') '+OptRec.Prp_Tel;
  SendMapiMail(SomeSubject,SomeText,SomeAttachment,'','','',SomeRecipientEmail); //20111211
 //SendMapiMail(SomeSubject,SomeText,SomeAttachment,'','','',SomeRecipientEMail);
 end;
 If (SelectedString ='5') then
 begin
   OpenItBtnClick(Sender);
   EmailTheReturnClick(Sender);
 end;
end;

function TGuiT1_2026.SendMAPIMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
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
      lpszSubject := PAnsiChar(AnsiString('' + Subject));

    if (Body <> '') then
      lpszNoteText := PAnsiChar(AnsiString('' + Body));

    if (SenderEmail <> '') then
    begin
      lpSender.ulRecipClass := MAPI_ORIG;
      if (SenderName = '') then
        lpSender.lpszName := PAnsiChar(AnsiString(''+SenderEMail))
      else
        lpSender.lpszName := PAnsiChar(AnsiString(''+SenderName));
      lpSender.lpszAddress := PAnsiChar(AnsiString(''+SenderEmail));
      lpSender.ulReserved := 0;
      lpSender.ulEIDSize := 0;
      lpSender.lpEntryID := nil;
      lpOriginator := @lpSender;
    end;

    if (RecipientEmail <> '') then
    begin
      lpRecipient.ulRecipClass := MAPI_TO;
      if (RecipientName = '') then
        lpRecipient.lpszName := PAnsiChar(AnsiString(''+RecipientEMail))
      else
        lpRecipient.lpszName := PAnsiChar(AnsiString(''+RecipientName));
      lpRecipient.lpszAddress := PAnsiChar(AnsiString('SMTP:'+RecipientEmail));//20210217 Igor
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
      FileAttach.lpszPathName := PAnsiChar(AnsiString(''+FileName));

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


procedure TGuiT1_2026.SendTaxReturnPDFprintoutstoClient_OfficeClick( //20210426 Igor
  Sender: TObject);
begin
  PrintCurrentReturn1Click(nil);
end;

procedure TGuiT1_2026.TUTORIALS1Click(Sender: TObject);
begin
  MainForm.GuiCommand(gcTutorials);
end;

procedure TGuiT1_2026.Backupthetaxdata1Click(Sender: TObject);
Var i:Integer;LastBackUp,Dir:String;  TempList:TStringList; DoneOk:Boolean;
  ClickedOK: Boolean;  NewDir: string;
begin
 If OptRec.BackUpDir='' then
 begin
  ShowMessage('Please enter the backup directory in Configure | General Options | Data directories');
  Exit;
 end;
 Application.CreateForm(TBackupFrmT1_2026,BackUpFrm);
 BackUpFrm.ShowModal;
 BackUpFrm.Free;
end;

procedure TGuiT1_2026.Restoredatafrombackup1Click(Sender: TObject);
Var i:Integer;LastBackUp,Dir:String;  TempList:TStringList; DoneOk:Boolean;
  ClickedOK: Boolean;  NewDir: string;
begin
 If OptRec.BackUpDir='' then
 begin
  ShowMessage('Please enter the backup directory in Configure | General Options | Data directories');
  Exit;
 end;
 Application.CreateForm(TRestoreFrmT1_2026,RestoreFrm);
 RestoreFrm.ShowModal;
 RestoreFrm.Free;
end;

procedure TGuiT1_2026.CopyAReturnBtnClick(Sender: TObject);
Var i,ThisResult:Integer;Dir,FlName,Sin:String;
 AListItem:TListItem;
 //RetNo:Integer;
begin
  {
  //20180427 Igor >>>
  if StartParams.isCloud then
  begin
    MessageDlg(c_NotAvailable, mtInformation, [mbOk], 0);
    Exit;
  end;
  //20180427 Igor <<<
  }
  if CheckIsCloud then Exit; //20180503 Igor
  If LicenseLevel in anyMulti then
  begin
   If YouKnowTheAdminPassword = false then exit;
  end;

  AListItem:=ListView1.ItemFocused;
  If AListItem = Nil then
  begin
   ShowTimedMsg('You must select a file first',1200);
   Exit;
  end;
  SomeFile:=AllTrim(AListItem.SubItems[2]);   //FlName
  SomeString:=AllTrim(AListItem.SubItems[3]); //from dir
  SomeCaption:=AllTrim(AListItem.Caption); //return name
  Application.CreateForm(TCopyMoveFrmT1_2026,CopyMoveFrm);
  CopyMoveFrm.ShowModal;
  CopyMoveFrm.Free;
  If SomeResult=True then
    ShowMessage('Done')
  Else
   ShowMessage('Failed!');
  ShowMostRecentReturns; //updates the main menu
end;

procedure TGuiT1_2026.Label4Click(Sender: TObject);
begin
 KnownIssues1Click(Sender);
end;

procedure TGuiT1_2026.TutorialsLblClick(Sender: TObject);
begin
 TUTORIALS1Click(Sender); //20140130
end;

procedure TGuiT1_2026.TrBtnClick(Sender: TObject);
begin
 TrEngineLoadClick(Sender);
end;

procedure TGuiT1_2026.ShowAutofillStatusBtnClick(Sender: TObject); //20160126 Igor
begin
  If IsTDDOpenForUse=false then begin ShowTddNotAvailableForUse;Exit;end;  //20160205 //20160216 Igor
  If TddSinsReceived.Count=0 then
  begin
    ShowMessage('There is no Auto-fill My Return active session with CRA at this moment');
    Exit;
  End;
  ShowTddStatus;
end;

procedure TGuiT1_2026.ShowBarCodedata1Click(Sender: TObject);
Var FlNm:String;
begin
  Flnm :=Appdir+'\'+'BarCodeData.Txt';
  If FileExists(FlNm) then
  begin
  SomeList.Clear; // := TStringList.Create;
   SomeCaption := 'BarCode contents';
   SelectedString := PopSomeFile(Flnm,SomeCaption);
 end;
end;



procedure TGuiT1_2026.FinancialInstitutionsforT1DD1Click(Sender: TObject);
begin
 SomeCaption := 'Financial Institutions - Guide for T1DD';
  SelectedString := PopSomeFile(AppDir+'\'+'FININST.D',SomeCaption,True);
end;

procedure TGuiT1_2026.T7DRA1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 If IsEfiledReturn(RetNo) = false then
 begin
  ShowTimedMsg('This is not an Efiled return', 1500);
  Exit;
 end;

 If Ret[RetNo].Lnn[48500]=0 then
 begin
  ShowMessage('There is no amount owing. T7DR(A) will not print');
  Exit;
 end;

 Application.CreateForm(TT7DRAT1_2026,T7DRA);
 T7DRA.ShowModal;
 T7DRA.Free;
 //20180308 Igor >>>
 Exit;
 PrintForm(RetNo,'T7DRQR',1,'');
 //20180308 Igor <<<
end;

procedure TGuiT1_2026.ForeignExchangeconverter1Click(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(RetNo,'FECONV',1);
end;

procedure TGuiT1_2026.T4044GuideEmploymentExpenses1Click(Sender: TObject);
begin
 ShowPdf(AppDir,'T4044-25e.pdf');  //202600325
end;


procedure TGuiT1_2026.CurrentFormallinstances1Click(Sender: TObject);
//20171031 igor>>>
var
  i: Integer;
  PDF: TvtPDFPrinter;
begin
  if ButtonInactive then
    exit;
  if Ret[RetNo].IsLastYearReturn then
    Exit; //20110227
  FastPrint := False;
  CountDiagnostics(RetNo);
  if Ret[RetNo].MandatoryErrorCount + Ret[RetNo].SeriousErrorCount > 0 then
  begin
    if not MainForm.WizardPanel.visible then
      MainForm.AuditOpenBtnClick(Application);
    ShowMessage('Return has errors. Please fix before printing/filing');
  end;

  if not AllowedToFormPrint(RetNo, FormName) then
    exit;
  if CheckIsCloud(true) then //20180503 Igor
  begin
    PDFFullfileName := TPath.Combine(AppDir, 'tmp' + TPath.DirectorySeparatorChar + TPath.GetGUIDFileName + '.pdf');
    if not ForceDirectories(ExtractFileDir(PDFFullfileName)) then
    begin
      MessageDlg('Can not create temp folder', mtError, [mbOk], 0);
      Exit;
    end;
    PDF := TvtPDFPrinter.Create(AppT1_2026);
    try
      for i := 0 to (FList.Count - 1) do
      begin
        FRec := FList.Items[i];
        if Frec.FormName = ExtractNonInstFormName(FormName) then
          PDF.PrintForm(RetNo, Frec.FormInstName, 99, T1_2026Print.AfterReadComponentForPrint,
              T1_2026Print.PrintEditBox, T1_2026Print.PrepareRichEdit,
              T1_2026Print.PrintImageT1, T1_2026Print.PrintHeader);
      end;
      PDF.SaveToFile(PDFFullfileName, false);
      OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
    finally
      PDF.free;
    end;
  end
  else
  begin
    if not PrintDialogItem.Execute then
      exit;
    for i := 0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      if Frec.FormName = ExtractNonInstFormName(FormName) then
        StartPrintForm(RetNo, Frec.FormInstName, 99);
    end;
    if Printer.Printing then //20160905 Igor
      Printer.EndDoc;        //20160905 Igor
  end;
//20171031 igor<<<
end;

procedure TGuiT1_2026.SignffWarnings1Click(Sender: TObject);
begin
  if ButtonInactive then exit; //?
  SignOffAWarning(RetNo);
end;

procedure TGuiT1_2026.SignPDFwithESignature1Click(Sender: TObject);
begin
  ExecuteForm(TSignPDFT1_2026);
end;

procedure TGuiT1_2026.SingleRegistration_OfficeClick(Sender: TObject); //20201216 Igor
var FRetNo: integer;
begin
  FRetNo := GetCurrentRetNo;
  If FRetNo = 0 then
  begin
    ShowMessage('Open return first');
    exit;
  end;
  if FetchElm(FRetNo,'INFO', 140) = '' then
  begin
    ShowMessage('Email is not specified. Please, enter email before registration');
    GetChild(FRetNo).BringExistingTabSheetToFront('INFO', GetFormNo('INFO'), 140); //20201218 Igor
    exit;
  end;
  SingleRegistration(FRetNo);
end;

procedure TGuiT1_2026.CreateNAICS1Click(Sender: TObject);
begin
 CreateNaicsFile; //20180417
end;

procedure TGuiT1_2026.CreateNewPlan1Click(Sender: TObject);
begin
  //20240517
  ShowMessage('Planner is released usually in August, after the Federal/Provincial budgets are available.');
  Exit;

  If ButtonInactive then exit;
  Ret[RetNo].IsTaxPlan:=True;
  Ret[RetNo].Locked:=False;
  RY:=PlanningRy; //1;
  If Ry=0 then
  begin
   PlanYear:=AppYear;
  end
  else
  begin
   PlanYear:=IntToStr(StrToInt(AppYear)+1); // '2013';  //20130511
  end;

  Calc(Retno,FormName);
  RecalcEverything(RetNo);
  CalcAll(RetNo);
  OpenForm(Retno,FormNo,0);
  MainForm.RefreshAuditPanel(RetNo);
  MainForm.FormPaint(Application);
  MyChild.UpdateChildTaxPanel;
  Ret[RetNo].SourceDataDir:=OptRec.Dir_Planner;
end;


procedure TGuiT1_2026.CreatePDFforsigning_OfficeClick(Sender: TObject); //20210318 Igor
begin
  If ButtonInactive then exit;
  ExecuteForm(TSaveAsPdfForVCT1_2026);
end;

procedure TGuiT1_2026.OpenExistingTaxPlan1Click(Sender: TObject);
begin
 ShowMessage('On the Client Book check the box Tax Plans');
 FileOpenItemClick(Sender);
end;

procedure TGuiT1_2026.OptimizeBtnClick(Sender: TObject);
begin
 OptimizeFamilyprocessing1Click(Sender);
end;

Procedure TGuiT1_2026.TileThem;
begin
 If RetInMem<2 then
 begin
 ShowTimedMsg('Window tiling is effective only when multiple returns are loaded',1800);
 end;
  SomeList.Clear; // := TStringList.Create;
 SomeList.Add('1. Tile Horizontally');
 SomeList.Add('2. Tile Vertically');
  SelectedString := PopSomeList(SomeList,SomeCaption);
  //SomeList.Free; //20160628 Igor
 If SelectedString > '' then
 begin
  If LeftStr(SelectedString,1)='1' then
    MainForm.TileHorizontally1Click
  else
  If LeftStr(SelectedString,1)='2' then
    MainForm.TileVertical1Click
  else
  Exit;
 end;
end;


procedure TGuiT1_2026.SpecialGpT11Click(Sender: TObject);
begin
  if not GetDeveloperPwd then exit;
  ExecuteForm(TSpecialGpT1_2026);
end;

procedure TGuiT1_2026.TaxPlanner1Click(Sender: TObject);
begin
 {
 ShowMessage('The 2008 rates are not available yet.'+
  Chr(13)+'Expected June or July');
 Exit;
 }
end;

procedure TGuiT1_2026.ACBPortfolioSummary1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 OpenForm(RetNo,'ACBSUM#1',0);
end;

procedure TGuiT1_2026.AccepttheClientssignature_OfficeClick(Sender: TObject); //20210208 Igor
var FTaxPayerEmail: string;
    FTaxPayerCyberId: string;
begin
  If ButtonInactive then exit;
  If RetNo = 0 then
  begin
    ShowMessage('Open return first');
    exit;
  end;
  FTaxPayerEmail := FetchElm(RetNo,'INFO', 140);
  if FTaxPayerEmail.IsEmpty then
  begin
    ShowMessage('Email is not specified. Please, enter email before signature request');
    GetChild(RetNo).BringExistingTabSheetToFront('INFO', GetFormNo('INFO'), 140);
  end;
  FTaxPayerCyberId := VirtualTaxOfficeInfo.GetTaxPayerCyberIdByEmail(FTaxPayerEmail);
  if not GetSignatureFilePath(GetLastName(RetNo),GetFirstName(RetNo)).IsEmpty then
  begin
    ShowMessage('You already have signature in Client Docs. Click File -> Open the Client Documents Folder.. -> Open Document Folder and delete or rename signature file'); //20210409 Igor
    Exit;
  end;
  VirtualTaxOfficeInfo.GetSignature(FTaxPayerCyberId, GetSignatureFolderPath(GetLastName(FRetNo),GetFirstName(FRetNo)));
  if not GetSignatureFilePath(GetLastName(RetNo),GetFirstName(RetNo)).IsEmpty then
    ShowMessage('Signature was downloaded successfully!');
end;

//20241024 Igor >>>
procedure TGuiT1_2026.actArchivesExecute(Sender: TObject);
begin
  if ButtonInactive then exit;
  AppT1_2026.GetArchLicenseLevel;
  if AppT1_2026.ArchLicenseLevel = llNone then
    exit
  else
    ShowMessage('Key valid');
end;
//20241024 Igor <<<

procedure TGuiT1_2026.actChangeSkinExecute(Sender: TObject); //20180206 Igor
var FResult: Integer;
begin

  FResult := CaseDo('Choose interface',
                   ['VisualTax Classic',
                    'Small ToolBar',
                    'Large Toolbar',
                    'Ribbon'], nil);
  if FResult <> -1 then
  begin
   // ShowMessage('Only Classic Interface is allowed in this early version');
   // Fresult:=0; //20191215
    MainOptions.Skin := TSkin(FResult);
    MainOptions.Save;
  end;
end;

//20191129 Igor >>>
procedure TGuiT1_2026.actCreateClientsFoldersExecute(Sender: TObject);
var
  Dir: string;
begin
  If ButtonInactive then exit;
  Dir := optRec.Dir_ClientDocs + '\' + GetLastName(retNo) + ',' + GetFirstName(retNo);
  if not DirectoryExists(Dir) then ForceDirectories(Dir);

  Dir := optRec.Dir_PermanentDocs + '\' + GetLastName(retNo) + ','+ GetFirstName(retNo);
  if not DirectoryExists(Dir) then ForceDirectories(Dir);
end;
//20191129 Igor <<<

//20171128 igor>>
procedure TGuiT1_2026.actDataExtractExecute(Sender: TObject);
begin
  if AllowImportExport=false then exit;  //20171130 CON
  DataExtract(AppT1_2026);
end;

procedure TGuiT1_2026.actDocumentsFolderExecute(Sender: TObject); //20210115 Igor
begin
  with btnVTODocumentsFolder.ClientToScreen(point(0, btnVTODocumentsFolder.Height)) do
    pmDocumentsFolder.Popup(X, Y);
end;

//20171128 igor<<
procedure TGuiT1_2026.actFaqVTOExecute(Sender: TObject); //20210115 Igor
begin
  //20210120 Igor >>>
  if IsVtClient then
    ConnectToWeb('https://www.visualtax.com/vcFAQ.php')
  else
    ConnectToWeb('https://www.visualtax.com/voFAQ.php');
  //20210120 Igor <<<
end;

procedure TGuiT1_2026.actFindFormExecute(Sender: TObject);//20170823 Igor
begin
  If ButtonInactive then exit;
  If Trim(SearchStr) = '' then exit;
  QuickFormFind(RetNo, SearchStr);
end;

procedure TGuiT1_2026.actForCloudExecute(Sender: TObject);//20171215 Igor
begin
  OpenFromCloudClick(Sender);
end;

procedure TGuiT1_2026.actHelpVTOExecute(Sender: TObject); //20210115 Igor
begin
  //20210120 Igor >>>
  if IsVtClient then
    ConnectToWeb('https://www.visualtax.com/vcHelp.php')
  else
    ConnectToWeb('https://www.visualtax.com/voHelp.php');
  //20210120 Igor <<<
end;

//20191129 Igor >>>
procedure TGuiT1_2026.actCopyClientsFoldersExecute(Sender: TObject);
var
  Dir: string;
begin
  If ButtonInactive then exit;
  case CaseDo('', [
    'Open Document Folder',
    'Open Permanent Folder'
    ], nil) of
    // vtScan
   1: Dir := optRec.Dir_PermanentDocs + '\' + GetLastName(retNo) + ','+ GetFirstName(retNo);
  else
    Dir := optRec.Dir_ClientDocs + '\' + GetLastName(retNo) + ',' + GetFirstName(retNo);
  end;
  if not DirectoryExists(Dir) then ForceDirectories(Dir); //20200322
  if not DirectoryExists(Dir) then
    ShowMessage('Directory does not exist')
  else
    ShellExecute(Application.Handle, 'open', PChar(Dir), nil, nil, SW_SHOWNORMAL) ;
end;
//20191129 Igor <<<

procedure TGuiT1_2026.actOpenRecentExecute(Sender: TObject);
begin
//
end;

procedure TGuiT1_2026.actOtherExecute(Sender: TObject); //20210112 Igor
begin
  If UpperCase(InputBox('Reserved for testing by software developer', 'PSW', '')) <> FormatDateTime('yyyy-mm-dd', Date) then exit;
  ShowMessage('Success!');
end;

procedure TGuiT1_2026.actRebuilDatabaseCloudExecute(Sender: TObject); //20190522 Igor
var CloudId, I: integer;
begin
  If RetInMem>0 then
  begin
    ShowMessage('Please close all returns first');
    exit;
  end;
  CloudId := -1;
  with HelperManager do
    for I := 0 to HelperClassList.Count - 1 do
      if HelperManager.AllowSend(I) then
      begin
        CloudId := I;
        break;
      end;
  if CloudId = -1 then
  begin
    ShowMessage('No helpers avaiable');
    Exit;
  end;
  Application.CreateForm(TCloudRebuildT1_2026, CloudRebuild);
  try
    CloudRebuild.CloudId := CloudId;
    CloudRebuild.ShowModal;
  finally
    CloudRebuild.Free;
  end
end;

//20191129 Igor >>>
procedure TGuiT1_2026.actScanExecute(Sender: TObject);
begin
  if ButtonInactive then exit;
  AppT1_2026.GetScanLicenseLevel;
  if AppT1_2026.ScanLicenseLevel=llNone then exit;
  ExecuteForm(TVtScanT1_2026);
  if FormName='INFO' then  //20120128
    if RetNo>0 then
      OpenForm(RetNo,'INFO',187);
end;

procedure TGuiT1_2026.actSendSignatureExecute(Sender: TObject); //20210126 Igor
begin
  with btnVTO_Sign.ClientToScreen(point(0, btnVTO_Sign.Height)) do
    pmSign.Popup(X, Y);
end;

procedure TGuiT1_2026.actStartVirtualMeetingVTOExecute(Sender: TObject); //20210203 Igor
var FResult, FRetNo: Integer;
    A: TArray<string>;
    FEmail, FTeamViewerId, FUltraViewerId, FPrograms, FChooseValue: string;
    FName, FPhone: string; //20210204 Igor
begin
  if VirtualTaxOfficeInfo.AccountType = vtoPayer then
  begin
    FTeamViewerId := VirtualTaxOfficeInfo.TaxOffice.TeamViewerId;
    FUltraViewerId := VirtualTaxOfficeInfo.TaxOffice.UltraViewerId;
    //20210204 Igor >>>
    FName := VirtualTaxOfficeInfo.TaxOffice.Name;
    FPhone := VirtualTaxOfficeInfo.TaxOffice.Phone;
    //20210204 Igor <<<
  end
  else if VirtualTaxOfficeInfo.AccountType = vtoOffice then
  begin
    FRetNo := GetCurrentRetNo;
    If FRetNo = 0 then
    begin
      ShowMessage('Open return first');
      exit;
    end;
    FEmail := FetchElm(FRetNo,'INFO', 140);
    if FEmail.IsEmpty then
    begin
      ShowMessage('Please, enter email first in INFO form');
      exit;
    end;
    with VirtualTaxOfficeInfo.GetTaxPayerInfo(VirtualTaxOfficeInfo.GetTaxPayerCyberIdByEmail(FEmail)) do
    begin
      FTeamViewerId := TeamViewerId;
      FUltraViewerId := UltraViewerId;
      //20210204 Igor >>>
      FName := LastName + ' ' + FirstName;
      FPhone := Phone;
      //20210204 Igor <<<
    end;
  end
  else
    Exit;
  FPrograms := '';
  if not FTeamViewerId.IsEmpty then
    FPrograms := FPrograms + ',TeamViewer';
  if not FUltraViewerId.IsEmpty then
    FPrograms := FPrograms + ',UltraViewer';
  if FPrograms.IsEmpty then
  begin
    //20210204 Igor >>>
    if VirtualTaxOfficeInfo.AccountType = vtoPayer then
      ShowMessage(
        'Please inform your Virtual Office ' + FName +', Phone '+ FPhone +
        ' to install the Ultraviewer or Teamviwer and update his '+
        'Registration Profile with the TeamViewer Id and/or UltraViwer Id as per. '+
        'Then we will be able to hold a Virtual meeting')
    else
      ShowMessage(
        'Please inform your Virtual Client ' + FName +', Phone '+ FPhone +
        ' to install the Ultraviewer or Teamviwer and update his '+
        'Registration Profile with the TeamViewer Id and/or UltraViwer Id as per. '+
        'Then we will be able to hold a Virtual meeting');
    //20210204 Igor <<<
    Exit;
  end;
  A := FPrograms.Split([','], ExcludeEmpty);
  if Length(A) > 1 then
    FResult := CaseDo('Choose program', A, nil)
  else
    FResult := 0;
  if FResult = -1 then Exit;
  FChooseValue := A[FResult];
  if SameText(FChooseValue, 'TeamViewer') then
  begin
    FResult := CaseDo('Choose action', ['Start TeamViewer', 'Connect to '+ FTeamViewerId], nil);
    case FResult of
      0 : OpenTeamViewer;
      1 : OpenTeamViewer(FTeamViewerId);
    end;
  end
  else if SameText(FChooseValue, 'UltraViewer') then
  begin
    // UltraViewer command line is not working, we should uncomment code below when they fix this issue
    {FResult := CaseDo('Choose action', ['Start UltraViewer', 'Connect to '+ FUltraViewerId], nil);
    case FResult of
      0 : OpenUltraViewer;
      1 : OpenUltraViewer(FUltraViewerId);
    end;}
    OpenUltraViewer;
  end;
end;

procedure TGuiT1_2026.actVtScanVTOExecute(Sender: TObject); //20210201 Igor
begin
  //20210202 Igor >>>
  if ReturnsCountInDb > 10 then
  begin
    ShowMessage('vtScan is available only if you have less than 10 returns'); //20210211 Igor
    Exit;
  end;
  if SameText(VirtualTaxOfficeInfo.Email, VirtualTaxOfficeInfo.TaxOffice.Email) then
  begin
    ShowMessage('Virtual Client and Virtual Office have the same emails. vtScan is not available');
    Exit;
  end;
  if ButtonInactive then exit;
//  AppT1_2026.GetScanLicenseLevel;
//  if AppT1_2026.ScanLicenseLevel=llNone then exit;
  ExecuteForm(TVtScanT1_2026);
  if FormName='INFO' then  //20120128
    if RetNo>0 then
      OpenForm(RetNo,'INFO',187);
  //20210202 Igor <<<
end;

//20191129 Igor <<<

//20191216 Igor >>>
procedure TGuiT1_2026.actWatermarkExecute(Sender: TObject);
var
  LValues: TArray<string>;
begin
  SetLength(LValues, 1);
  LValues[0] := OptRec.Prn_Watermark;
  if (InputQuery('Input text for Watermark',['Watermark:'], LValues)) then
    OptRec.Prn_Watermark := LValues[0];
end;
//20191216 Igor <<<


procedure TGuiT1_2026.N2008TaxRatesandDrafytLegislation1Click(Sender: TObject);
begin
 ShowPdf(AppDir,'2009-TaxRates.pdf');
end;

procedure TGuiT1_2026.CopyreturnsfromT1Draft1Click(Sender: TObject);
begin
 If LicenseLevel in anyLimited then
 begin
  ShowMessage('Not applicable for T1 Limited version. The data folder was and is '+LimitedVersionDir); //20170210
  Exit;
 end;

 If UpperCase(OptRec.Dir_Cur)='C:\T1DRAFT10\DATA' then
 begin
  ShowMessage('Please change the draft data directory to a Production directory'+
    Chr(13)+'such as C:\T1-2010\data via Configure | General Options | Data Directories');
  Exit;
 end;

 Application.CreateForm(TCopyFromDraftFrmT1_2026,CopyFromDraftFrm);
 CopyFromDraftFrm.ShowModal;
 CopyFromDraftFrm.Free;
end;

procedure TGuiT1_2026.BitBtn2Click(Sender: TObject);
begin
 SignffWarnings1Click(Sender);
end;

procedure TGuiT1_2026.btnDownloadClick(Sender: TObject); //20181130 Igor
var Dir, FlName: String;
    AListItem: TListItem;
    //20190213 Igor >>>
    Files: TArray<String>;
    I: integer;
    //20190213 Igor <<<
    //20190529 Igor >>>
    CloudFile, CloudPath, ClientId, Token: string;
    hconf: THelperAppUserConfig;
    CloudI: integer;
    //20190529 Igor <<<
begin
  if not CheckIsCloud(true) then Exit;
  //20190213 Igor >>>
  //20190517 Igor >>>
  for I := 0 to ListView2.Items.Count - 1 do
    if ListView2.Items[i].Checked or (Sender = btnDownloadAll) then
    begin
      FlName := TPath.Combine(OptRec.Dir_Cur, Format('%s-{%s}',[AllTrim(ListView2.Items[i].Caption),AllTrim(ListView2.Items[i].SubItems[2])])); //20190517 igor
      //20190529 Igor >>>
      if CheckIsCloud(true) and not FileExists(FlName) then
      begin
        for CloudI := 0 to HelperManager.HelperClassList.Count - 1 do
        begin
          if not HelperManager.AllowSend(CloudI) then continue;
          hconf := HelperManager.Config(CloudI, AppT1_2026.AppId, User.UserName);
          CloudPath := hconf.Path;
          ClientId := HelperManager.Config(CloudI).ClientID;
          Token := hConf.Token;
          CloudFile := ExtractFileName(FlName);
          if HelperManager.Get(CloudI, FlName, CloudPath, CloudFile, ClientID, Token) then
            break;
        end;
      end;
      //20190529 Igor <<<
      if FileExists(FlName) then
      begin
        SetLength(Files, Length(Files) + 1);
        Files[Length(Files) - 1] := FlName;
      end
      else
        ShowMessage('File '+ FlName +' is not found!');
    end;
  if Length(Files) = 0 then
  begin
    AListItem := ListView2.ItemFocused;
    if AListItem = nil then
    begin
      ShowTimedMsg('You must select a file first', 1200);
      Exit;
    end;
    FlName := TPath.Combine(OptRec.Dir_Cur, Format('%s-{%s}',[AllTrim(AListItem.Caption),AllTrim(AListItem.SubItems[2])]));  //20190517 igor //20190529 Igor
    if not FileExists(FlName) then
    begin
      ShowMessage('File '+ FlName +' is not found!');
      Exit;
    end;
    SetLength(Files, Length(Files) + 1);
    Files[Length(Files) - 1] := FlName;
  end;
  DownloadFiles(Files);
  //20190213 Igor <<<
  //20190517 Igor <<<
end;

function GetUploadFiles: TArray<String>; //20190529 Igor
var dlgOpen: TOpenDialog;
    I: integer;
begin
  SetLength(Result, 0);
  dlgOpen := TOpenDialog.Create(nil);
  try
    dlgOpen.Name := 'dlgOpen';
    dlgOpen.InitialDir := OptRec.Dir_Cur;
    dlgOpen.Options := [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing];
    if not dlgOpen.Execute then Exit;
    SetLength(Result, dlgOpen.Files.Count);
    for I := 0 to dlgOpen.Files.Count - 1 do
      Result[I] := dlgOpen.Files[I];
  finally
    dlgOpen.Free;
  end;
end;

procedure TGuiT1_2026.btnUploadClick(Sender: TObject); //20181130 Igor
var Files: TArray<String>;
    //20190529 Igor >>>
    RetNo, I, iCloud, Count: Integer;
    Clouds: TArrayOfInteger;
    cDir, cFile: string;
    bOpen: boolean;
    //20190529 Igor <<<
begin
  ShowMessage('Please use the Utilities -> BackUp All Tax data, and select VtCloud');
  Exit;
  (*
  //20190529 Igor >>>
  bOpen := Sender = btnUpload;
  Count := 0;
  if CheckIsCloud(true) then
    Files := UploadFile(OptRec.Dir_Cur, false)
  else
    Files := GetUploadFiles;
  for I := 0 to Length(Files) - 1 do
  begin
    cDir := ExtractFileDir(Files[I]);
    if cDir.IsEmpty then
      cDir := OptRec.Dir_Cur;
    cFile := ExtractFileName(Files[I]);
    RetNo := OpenReturnCoupled(cDir, cFile, bOpen, true); //20190605 Igor
    if RetNo <> 0 then
    begin
      if IsCloudStorageEnabled then begin
        SetLength(Clouds, 0);
        with HelperManager do
        begin
          for iCloud := 0 to HelperClassList.Count - 1 do
          begin
            if HelperManager.Config(HelperClassList.Keys.ToArray[iCloud].ClassName,
                     AppT1_2026.AppId, User.UserName).SaveReturnToCloud or CheckIsCloud then
              if HelperManager.AllowSend(iCloud) then
              begin
                SetLength(Clouds, length(Clouds) + 1);
                Clouds[length(Clouds) - 1] := iCloud;
              end;
          end;
        end;
        if FileExists(TPath.Combine(OptRec.Dir_Cur, cFile)) then
          TFile.Delete(TPath.Combine(OptRec.Dir_Cur, cFile));
        SaveReturn(RetNo, OptRec.Dir_Cur, cFile, True, True, false, True, Clouds); //20190605 Igor
        if CheckIsCloud(True) then begin
          TFile.Delete(TPath.Combine(OptRec.Dir_Cur, cFile));
        end;
      end
      else
        SaveReturn(RetNo, OptRec.Dir_Cur, cFile, true, true);
      if not bOpen then
        CloseReturn(RetNo);
      inc(Count);
    end;
  end;
  if not bOpen then
    if Count > 0 then
      ShowMessage(IntToStr(Count) + ' returns have been uploaded to vtCloud' +chr(13)+'You can now open them via the Client book');
  //20190529 Igor <<<
 *)
end;

{procedure TGuiT1_2026.btnUploadWithoutOpenClick(Sender: TObject); //20190213 Igor //20190529 Igor
var Files: TArray<String>;
    //20190529 Igor >>>
    RetNo, I, Count, iCloud: Integer;
    Clouds: TArrayOfInteger;
    //20190529 Igor <<<
begin
  //20190529 Igor >>>
  if CheckIsCloud(true) then
    Files := UploadFile(OptRec.Dir_Cur, false)
  else
    Files := GetUploadFiles;
  //20190529 Igor <<<
  Count := 0;
  for I := 0 to Length(Files) - 1 do
  begin
    RetNo := OpenReturnCoupled(OptRec.Dir_Cur, Files[I], False);
    if RetNo <> 0 then
    begin
      //20190529 Igor >>>
      if IsCloudStorageEnabled then begin
        SetLength(Clouds, 0);
        with HelperManager do
        begin
          for iCloud := 0 to HelperClassList.Count - 1 do
          begin
            if HelperManager.Config(HelperClassList.Keys.ToArray[iCloud].ClassName,
                     AppT1_2026.AppId, User.UserName).SaveReturnToCloud or CheckIsCloud then
              if HelperManager.AllowSend(iCloud) then
              begin
                SetLength(Clouds, length(Clouds) + 1);
                Clouds[length(Clouds) - 1] := iCloud;
              end;
          end;
        end;
        SaveReturn(RNo, DataDir, FlName, false, True, false, True, Clouds);
        if CheckIsCloud(True) then begin
          TFile.Delete(TPath.Combine(DataDir, FlName));
        end;
      end
      else
        SaveReturn(RetNo, OptRec.Dir_Cur, Files[I], true, true);
      //20190529 Igor <<<
      CloseReturn(RetNo);
      inc(Count);
    end;
  end;
  if Count > 0 then
    ShowMessage(IntToStr(Count) + ' returns have been uploaded to vtCloud' +chr(13)+'You can now open them via the Client book');
end;}

procedure TGuiT1_2026.SaveprintoutofreturninPDFformatinClientDocumentsfolder1Click(Sender: TObject);
//Var OldPrinterName,PDFFullfileName:String; Dir:String;DlName:String;
Var  i,j: integer; FormsToPrint :TstringList;
    Copies, Template, s:String;
begin
  If ButtonInactive then exit;
 { //20170218
  //20160912 CON
  Showmessage('SaveToPDF function is currently unavailable'
  +Chr(13)+'Use normal print, select the PdfFactory print driver'
  +Chr(13)+'Enter a file path and Click the PdfFactory Save button');
  Exit;
 }
  //-------------------------------------
  RecalcEverything(RetNo);
  CountDiagnostics(RetNo);
  If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
  begin
   If not MainForm.WizardPanel.visible then MainForm.AuditOpenBtnClick(Sender);
   ShowMessage('Return has errors. Please fix before printing/filing');
  end;

  If Not AllowedToFullPrint(RetNo) then begin PdfPrint:=False;exit;end;
  Calc(RetNo,'DIAGNO');
  //LetterType := 'Cover';
  If Ret[RetNo].CalcStatus = False then CalcAll(RetNo);
  UpdateAllDataIndicators(RetNo);
  If SlipsAvailable(RetNo) then Ret[RetNo].FormHasData['T4SUM#1'] := True;

  Application.CreateForm(TPrintReturnFrmT1_2026,PrintReturnFrm);
  PrintReturnFrm.ShowModal;
  PrintReturnFrm.Free;
end;

procedure TGuiT1_2026.ReviewfilesinClientDocumentFolder1Click(Sender: TObject);
Var FullFlName,FlName:String;h:Word;PgmPath:String;PgmFile:String; InitDir:String;
begin
  if CheckIsCloud then Exit; //20180503 Igor
  if ButtonInactive then exit;
  InitDir := RetList[RetNo].GetDirClientDocs;//20170714 Igor

 If DirectoryExists(InitDir) = false then
 begin
  ShowMessage('No documents found');
  Exit;
 end;

 h:=ShellExecute(Handle,'open', Pchar(''+InitDir), nil, nil, SW_SHOWNORMAL) ;
end;

procedure TGuiT1_2026.ReviewfilesinPermanentClientDocumentsfolder1Click(Sender: TObject); //20170130 Igor
Var
  FullFlName, FlName: String;
  h: Word;
  PgmPath: String;
  PgmFile: String;
  InitDir: String;
  RetNo: Integer;
begin
  if CheckIsCloud then Exit; //20180503 Igor
  RetNo := GetCurrentRetNo;
  InitDir := OptRec.Dir_PermanentDocs + '\' + GetLastName(RetNo) + ','+ GetFirstName(retNo);
  If DirectoryExists(InitDir) = false then
  begin
    ShowMessage('No documents found');
    Exit;
  end;
  h := ShellExecute(Handle, 'open', Pchar(''+InitDir), nil, nil, SW_SHOWNORMAL);
end;

procedure TGuiT1_2026.VTO_ChangePassword_BothClick(Sender: TObject); //20201208 Igor
begin
  ChangePasswordForVirtualTaxOffice;
end;

procedure TGuiT1_2026.VTO_LoginClick(Sender: TObject); //20201208 Igor
begin
  if LoginToVirtualTaxOffice then
    InitVirtualTaxOfficeMenu;
end;

procedure TGuiT1_2026.VTO_LogOut_BothClick(Sender: TObject); //20201208 Igor
begin
  VirtualTaxOfficeInfo.CyberId := '';
  InitVirtualTaxOfficeMenu;
end;

procedure TGuiT1_2026.VTSCAN1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
//20191129 Igor >>>
 case CaseDo('', [
   'Create Client Document Folders',
   'Scan Client Documents',
   'Copy files to Client Folders'
    ], nil) of
   // Create Client Document Folders
   0: actCreateClientsFolders.Execute;
   // vtScan
   1: actScan.Execute;
   // Copy files
   2: actCopyClientsFolders.Execute;
 end;
//20191129 Igor <<<
end;

procedure TGuiT1_2026.EFmemofieldadditionalfields1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 OpenForm(RetNo,'EFMEMO',0);
end;

procedure TGuiT1_2026.EfileErrorMessagesPDF1Click(Sender: TObject);
begin
// If UpperCase(InputBox('The 2022 version is not released yet', 'PSW', '')) <> 'N/A' then exit;  //20200121
 //ShowPdf(AppDir,'rc4018-ch2-24e.pdf');  //20250405
 ShowPdf(AppDir,'ch2-25e.pdf');  //20260210
end;

procedure TGuiT1_2026.SetupEfile1Click(Sender: TObject);
begin
  ExecuteForm(TEOLSetUpT1_2026);
end;

procedure TGuiT1_2026.SetUpNetFile1Click(Sender: TObject);
begin
  ExecuteForm(TEOLSetUpT1_2026);
end;

procedure TGuiT1_2026.SetZoomStr(const Value: String);
begin
  ZoomPercentLbl.Caption := Value;
  lblZoom.Caption := Value;
  lblZoom2.Caption := Value;
end;

procedure TGuiT1_2026.Findbaspasswords1Click(Sender: TObject);
begin
  ExecuteForm(TBadPswT1_2026);
end;

procedure TGuiT1_2026.ShowFList1Click(Sender: TObject);
begin
  if not GetDeveloperPwd then exit;
 ShowTheFList;
end;

procedure TGuiT1_2026.T2125YearlySummary1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 OpenForm(RetNo,'T2125SUM#1',0);
end;

procedure TGuiT1_2026.CheckALLforms1Click(Sender: TObject);
//Var psw:String;
begin
  if not GetDeveloperPwd then exit;
 CheckAllForms;
 ShowMessage('All forms done');
end;

procedure TGuiT1_2026.T1013Efile1Click(Sender: TObject);
begin
//20220113 Igor >>>
 If GetCurrentRetNo = 0 then
 begin
   Application.CreateForm(TT1013EfileT1_2026,T1013Efile);
   T1013Efile.ShowModal;
   T1013Efile.Free;
   Exit;
 end;
 //20220113 Igor <<<

 If ButtonInactive then exit;
 // If UpperCase(InputBox('Efile of T1013 will be available by CRA on February 20', 'PSW', '')) <> 'N/A' then exit;  //20200204
 //20140204
 ////20260302 ShowMessage('Use the Efile button available on the AUTHREP form'); //20200123
// 20260302 OpenForm(RetNo,GetFormNo('AUTHREP#1'),0);
 //OpenForm(RetNo,GetFormNo('T1013#1'),0);
 Exit;
 (*
 ShowMessage('T1013 Batch Efile will be available in another release'
 +Chr(13)+'For now, you can Efile T1013 by opening the T1013 form and filing one at a time');
 Exit;

 If (LicenseLevel = 'T1 NetFile')
 Or (LeftStr(LicenseLevel,10) = 'T1 Limited')
 Or (LicenseLevel = 'T1 Standard') then
 begin
  ShowMessage('Batch T1013 Efile is available only in the T1 Power version');
  Exit;
 end;

 Application.CreateForm(TT1013Efile,T1013Efile);
 T1013Efile.ShowModal;
 T1013Efile.Free;
 *)
end;


procedure TGuiT1_2026.PrintAllFormsBtnClick(Sender: TObject);
begin
  if ButtonInactive then
    ShowMessage('Open a return first')
  else
    PrintAllForms(RetNo);
end;

Procedure TGuiT1_2026.PrintAllForms(RetNo:Integer);
Var I:integer; FrmNm:String;
begin
 If Not PrintDialogItem.Execute then exit;
 for i :=0 to FList.Count - 1 do
 begin
   FRec := FList.Items[i];
   FrmNm:= Frec.FormInstName;
   StartPrintForm(Retno,FrmNm,99);
 end;
 If Printer.Printing then //20160905 Igor
   Printer.EndDoc;        //20160905 Igor

end;


procedure TGuiT1_2026.T1013EfileErrors1Click(Sender: TObject);
begin
//If UpperCase(InputBox('The 2022 version is not released yet', 'PSW', '')) <> 'N/A' then exit;  //20200121
 //ShowPdf(AppDir,'ch11-19E.pdf');     //20200221
end;

procedure TGuiT1_2026.PrintSequence1Click(Sender: TObject);
begin
 Application.CreateForm(TPrintSeqFrmT1_2026,PrintSeqFrm);
 PrintSeqFrm.Visible:=False; //20110407
 PrintSeqFrm.ShowModal;
 PrintSeqFrm.Visible:=True;    //20110407
 PrintSeqFrm.Free;
end;

Procedure ReScaleDeskTopBoxes;
Var i:Integer;
Begin
end;

procedure TGuiT1_2026.ResetEfilestatusToWIPClick(Sender: TObject);
begin
 Application.CreateForm(TResetEFT1_2026,ResetEf);
 ResetEf.ShowModal;
 ResetEf.Free;
end;

procedure TGuiT1_2026.ResetpasswordfromclientDB1Click(Sender: TObject);
begin
  if not OpenDialog.execute then exit;
  if ExtractFileName(OpenDialog.FileName) <> OptRec.ClientsDBLite then
  Begin
    MessageDlg('It not Client DB file', mtError, [mbOk],0);
    exit;
  End;
  if RemovePasswordClientDB(OpenDialog.FileName) then
    MessageDlg('Reset password completed', mtInformation, [mbOk],0);
end;

procedure TGuiT1_2026.ResetpasswordwithReturn1Click(Sender: TObject);  //20161028 Igor
begin
  if not OpenDialog.execute then exit;
  if RemovePasswordReturn(OpenDialog.FileName) then
    MessageDlg('Reset password completed', mtInformation, [mbOk],0);
end;

procedure TGuiT1_2026.PrintCondencedT11Click(Sender: TObject);
Var ConfigBarCodeIndicator:Boolean;
begin
 If ButtonInactive then exit;
 If PrintDialogItem.Execute then
 begin
  ConfigBarCodeIndicator:=OptRec.NoBarCode;  //20120115
  OptRec.NoBarCode:=False;
  FastPrint:=False; //20120115
  PrintFilingCopy(RetNo);
  OptRec.NoBarCode:=ConfigBarCodeIndicator;  //20120115
  UpdatePrintDate(RetNo,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName); //20120122
 end;
end;

procedure TGuiT1_2026.ClientPHOTOID1Click(Sender: TObject);
Var s:String;
begin
  If ButtonInactive then exit;
  s:=OptRec.Dir_ClientDocs+'\'+GetLastName(retNo) + ','+ GetFirstName(retNo)+'\Photo Id.bmp';
  If (HasvtScanLicense)
  and (FileExists(s)) then
  Begin
         ShowClientPhotoId(OptRec.Dir_ClientDocs+'\'+GetLastName(retNo) + ','+ GetFirstName(retNo)+'\Photo Id.bmp');
  End
  Else
  ShowMessage('PHOTO ID not found or there is no vtScan program license');
end;

procedure TGuiT1_2026.EFILERSMANUAL1Click(Sender: TObject);
begin
// ShowMessage('The 2019 Efilers Manual is not released yet');  //20200121
 ShowPdf(AppDir,'rc4018-ch1-25e.pdf');  //20260321
  //20160214 //20160216 Igorhttps://www.canada.ca/content/dam/cra-arc/formspubs/pub/rc4018/rc4018ch1-18e.pdf
end;

procedure TGuiT1_2026.MassEmail1Click(Sender: TObject);
Var
TempList:TStringList;  h : Thandle;
flName:String;
  FDConnection: TADConnection;
  Table1: TADTable;
begin
  if CheckIsCloud then Exit; //20180503 Igor
  //20130131
  TempList:=TStringList.Create;

  //20150826 igor
  FDConnection := TADConnection.Create(nil);
  Table1 := TADTable.Create(nil);
  try
    //20150925 Igor
    SetTableName(FDConnection, Table1, OptRec.Dir_Cur + '\' + ClientsDBLite, ClientsTableLite, '');

    Table1.First;
  while not Table1.EOF do
  begin
   //20180311
   If AllTrim(Table1.FieldByName('Email2').AsString)>'' then
     TempList.Add(AllTrim(Table1.FieldByName('Email2').AsString)+';');
   Table1.Next;
  end;
  FlName:='EmailAddresses.txt';
  TempList.SaveToFile(TPath.Combine(AppDir, FlName)); //20180228 Igor
  TempList.Free;
  finally
    FDConnection.Free;
    Table1.Free;
  end;
  ShowMessage('A file by the name '+FlName+' has been built in '+AppDir+' folder.'
  +Chr(13)+'You can copy its contents to the Recipients Box of your Email program'
  +Chr(13)+'and use the same text message or the same attachment for all');

  h := ShellExecute(Mainform.Handle,'open',Pchar(TPath.Combine(AppDir, FlName)),Nil,Nil,Sw_Show); //20180228 Igor
  If H<=32 then ShowMessage('File not found');
end;


procedure TGuiT1_2026.MassEmailtoTaxPreparers1Click(Sender: TObject); //20210204 Igor
begin
 // If UpperCase(InputBox('Enter Password', 'PSW', '')) <> 'N/A' then exit;
  MassEmailToTaxPreparers;
end;

procedure TGuiT1_2026.MassEmailtoVirtualClients_OfficeClick(Sender: TObject); //20210216 Igor
begin
  MassEmailToTaxPayers;
end;

procedure TGuiT1_2026.MassRegistration_OfficeClick(Sender: TObject);  //20201127 Igor
begin
  //20210201 Igor >>>
  //ExecuteForm(TMassRegistrationT1_2026);
  MassRegistration;
  //20210201 Igor <<<
end;

procedure TGuiT1_2026.KnownIssues1Click(Sender: TObject);
begin
 ConnectToWeb('www.visualtax.com/t1knownissues.php');
end;

//20160216 Igor
procedure TGuiT1_2026.mmVirtualTaxOfficeClick(Sender: TObject); //20201208 Igor
begin
  InitVirtualTaxOfficeMenu;
end;

procedure TGuiT1_2026.vtCourier_OfficeClick(Sender: TObject); //20201019 Igor //20201208 Igor
var FTaxPayerCyberId: string;
    FEmail: string;
    FRetNo: integer;
    FFiles: TArray<string>; //20210426 Igor
begin
  FRetNo := GetCurrentRetNo;
  If FRetNo = 0 then
  begin
    ShowMessage('Open return first');
    exit;
  end;
  FEmail := FetchElm(FRetNo,'INFO', 140);
  if FEmail.IsEmpty then
  begin
    ShowMessage('Please, enter email first');
    exit;
  end;
  //20210426 Igor >>>
  if (Sender = SendtheActualTaxReturn_Office) then
  begin
    if RetList[FRetNo].SourceFlName.IsEmpty then
    begin
      ShowMessage('Please, save return before adding to list');
      Exit;
    end;
    SetLength(FFiles, 1);
    FFiles[0] := TPath.Combine(RetList[FRetNo].SourceDataDir, RetList[FRetNo].SourceFlName);
    RunCourier(VirtualTaxOfficeInfo.GetTaxPayerCyberIdByEmail(FEmail), FFiles);
  end
  else
    RunCourier(VirtualTaxOfficeInfo.GetTaxPayerCyberIdByEmail(FEmail));
  //20210426 Igor <<<
end;

procedure TGuiT1_2026.vtCourier_PayerClick(Sender: TObject);
begin
  RunCourier(VirtualTaxOfficeInfo.CyberId);
end;

procedure TGuiT1_2026.mniT1135EfileClick(Sender: TObject);
begin
 If IsCraOpenForEfile=False then begin ShowCraIsClosed;exit;end;
 //If UpperCase(InputBox('Efile will be available by CRA on Feb 20', 'PSW', '')) <> 'N/A' then exit;  //20200121
 //20170305
 If ButtonInactive then exit;
 ShowMessage('Use the Efile button directly from the T1135 form');
 OpenForm(RetNo,GetFormNo('T1135'),0);
 Exit;
end;

procedure TGuiT1_2026.mnSelAppClick(Sender: TObject);
begin
  ShowSplash;
end;

Procedure TGuiT1_2026.SelectFeatures;
Var gap:Longint;
Begin
  if Application.terminated then exit; //20161108 Igor

 {Main Menu}
 {Efile, EFile-online}
 //With MainFormT1 do
 begin
  Efile.Enabled:=True;
  EFileOnline.Enabled:=True;
  EfileBox.Enabled:=True;
  NetFileForindividuals1.Visible:=False;  //non visibe later if netfile

  {netfile for individuals}
 // If (LicenseLevel <> 'T1 NetFile') then NetFileForIndividuals1.Visible:=False;

  //EFILE
  If (LicenseLevel=llLimited) then
  begin
   Efile.Enabled:=False;
   EfileBox.Enabled:=False;
   NetFileForIndividuals1.Visible:=False;
  end;

  If IsHomeUse then
  begin
   LicenseLevelLbl.Caption := 'Home use - Netfile Version';
   Efile.Visible := False;
   Eol.Visible := False;
   NetFileForindividuals1.Visible:=True;  //visible now
   OpenByFileName1.Visible := False;
   FeeSchedule1.Visible := false;
   ClientLetter1.Visible := false;
   DataDictionary1.Visible := false;

   EfileOnLine.Enabled:=False;
   EFileBtn.Enabled:=False;
   EFileSetUpBtn.Enabled:=False;
   EFRejectBtn.Enabled:=False;
  end;

  //super features /optimize
  if LicenseLevel in [llNetFile..llStd]
  then
  begin
   SuperEntry1.Enabled := False;
 //20170208 Igor >>> set in Procedure Tvtnosplash.SelectFeatures;
//   MainForm.SuperAuditBox.Enabled := False;
//   MainForm.SuperVerificationBtn.Enabled := False;
 //20170208 Igor <<<

   SetReturnPassword1.Enabled := False;
   RemoveReturnPassword1.Enabled := False;
//   EmailCurrentForm.Enabled := False;
//   EmailTheReturn.Enabled:=False;
   OptimizeBtn.Enabled:=False;
  end;

 {Open by file Name}
  if LicenseLevel in [llNetfile..llLimEfile]
  then
  begin
    OpenByFileName1.Enabled := False;
    OpenbyFileNameSIN1.Enabled:=False;
  end;

 {PlanNextYear/TrEngine}
  if LicenseLevel in [llNetFile..llStd]
  then
  begin
   TaxPlanner1.Enabled:=False;
   //rpTaxPlaner.Enabled:=False;//20170907 Igor //20190415 Igor
   TrEngineLoad.Enabled:=False;
   TrGuide1.Enabled := False;
   MassEmail1.Enabled:=False;
  end;

 {Data Base Analyser/statistics/mailing labels/return balances}
  if LicenseLevel in [llDemo..llStd]
  then
  begin
    DataBaseAnalyser1.Enabled := False;
    ClientStatistics1.Enabled := False;
    MailingLabels1.Enabled := False;
    PrintReturnBalances1.Enabled :=False;
  end;

  {Cash reports}
  if LicenseLevel in [llDemo..llStd]
  then
    CashReports1.Enabled := False;

  //recalc and save all returns
  If LicenseLevel = llDemo
  then RecalculateandsaveALLtaxreturns1.Enabled := False;

  //Export data
  If LicenseLevel = llDemo
  then ExportData1.Enabled :=false;

  //File viewers, edit supporting files
  If LicenseLevel = llDemo
  then FileViewerEditor1.Enabled := False;

  //multi office features
  If not (LicenseLevel in anyMulti) then
  begin
    CopyDailyCashReport1.Enabled := False;
    SubmitDailyCashReport1.Enabled := False;
    YTDCashReports1.Enabled := False;
    UserSetUp1.Enabled := False;
    YtdDirectorySetUp1.Enabled := False;
    InvoiceAdjustments1.Enabled := False;
  end
  Else
  begin
    CopyDailyCashReport1.Enabled := True;
    SubmitDailyCashReport1.Enabled := True;
    YTDCashReports1.Enabled := True;
    UserSetUp1.Enabled := True;
    YtdDirectorySetUp1.Enabled := True;
    InvoiceAdjustments1.Enabled := True;
  end;

 //backup and merge
  if LicenseLevel in [llDemo..llStd]
  then
  begin
    CopyBackUp1.Enabled := False;
    MergeDataBases1.Enabled := False;
  end;

//toolbar
//20170824 Igor>>>
  ZoomStr := IntToStr(OptRec.FormZoom)+'%';
//20170824 Igor<<<
   //20170104 Igor
  Exporttofile1.Visible := ((IsBCJ = True) AND
    (LicenseList.Keys[AppT1_2026.AppId] = 'T106-2248-1998-1316'))  //t1-2018 only    //20190108
     or IsDeveloperLogin;
  ShowMostRecentReturns; //20170112 Igor
 end; {with}
 //20171128 Igor>>
 //disable\enable Data Extract for client: TaxTyme func
 actDataExtract.Visible := GetStateForDataExtract;
 //rgbAdvanced.Visible := actDataExtract.Visible; //20171208 Igor //20190415 Igor
 //20171128 Igor<<
end;

procedure TGuiT1_2026.Done;
begin
  Application.MainForm.BringToFront;
end;

procedure TGuiT1_2026.FormContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
(* Template for OnContextPopup on tax forms (ChildWin)
*)
  beep; //reached?
  Handled := True;
end;

// -------- some special menu handlers --------------

procedure TGuiT1_2026.TileHorizontally1Click(Sender: TObject);
begin
  MainForm.TileHorizontally1Click;
end;

procedure TGuiT1_2026.TileVertically1Click(Sender: TObject);
begin
  MainForm.TileVertical1Click;
end;

procedure TGuiT1_2026.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := false;
  // 20151017 Convert *.dbf => *.db on OptRec.Dir_Cur and AppDir
  //20160118 Igor
  vtDataModuleUnit.{vtDataModule.}DataBaseCreate(AppT1_2026.SQLLitePassword,
    AppT1_2026.ClientsDBLite,
    IncludeTrailingPathDelimiter(OptRec.Dir_Cur),
    IncludeTrailingPathDelimiter(AppDir));
end;

procedure TGuiT1_2026.TRTaxResearch1Click(Sender: TObject);
begin
  If IsTrLoaded = false then
  begin
    TrFolder:=GetTrFolder;
    LoadTr(TrFolder);
  end
  else
  begin
    //LinkToTr(s);
    LinkToTr(''); { TODO -oCon : which SearchItem? }
  end;
end;

procedure TGuiT1_2026.NextStatement1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  OpenNextInstance(RetNo, FormName);
end;

procedure TGuiT1_2026.PreviousStatement1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  OpenPrevInstance(RetNo, FormName);
end;

procedure TGuiT1_2026.EMailForm1Click(Sender: TObject);
begin
    ShowMessage('Select PdfFactory in the printer selection'
      +Chr(13)+'and then use the Mail/Send button');
     PrintForm1Click(Application);
    //EmailAFormToClient(RetNo,FormName);
end;

procedure TGuiT1_2026.Notepad1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  OpenForm(RetNo,'NPAD#1',0);
end;

procedure TGuiT1_2026.Notepadwithamounts1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  OpenForm(RetNo,'NPADC#1',0);
end;

procedure TGuiT1_2026.PrivateNotepad1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  OpenForm(RetNo,'PRIVAT#1',0);
end;

procedure TGuiT1_2026.SortMedical1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
    SortMedical(RetNo,FormName);
    ShowTimedMsg('Medical Sorted and matched',1000);
end;

procedure TGuiT1_2026.SortACBBydate1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
    SortACBFrm(RetNo,FormName);
    CountDiagnostics(RetNo);
    OpenForm(RetNo,FormNo,0);
    ShowTimedMsg('Sorted',1000);
end;

procedure TGuiT1_2026.RefreshALLdependants1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  RefreshDependAddresses(RetNo);
  //20170224 Igor >>>
  if RetList[RetNo].MyChild.ActiveForm.FormName = 'DEPEND' then
    RetList[RetNo].MyChild.ActiveForm.ShowFormData;
  //20170224 Igor <<<
  ShowTimedMsg('Addresses refreshed',1000);
  If MainForm.LeftPanel.Visible then
    MainForm.RefreshAuditPanel(RetNo);
  MainForm.FormPaint(Application);

  If (FormName = 'INFO') and (Ret[RetNo].CouplingSw = True) then
  begin
    RefreshSpouseAddresses(RetNo);
    RetList[RetNo].MyChild.ActiveForm.ShowFormData; //20170224 Igor
    ShowTimedMsg('Address refreshed',1000);
    If MainForm.LeftPanel.Visible then
      MainForm.RefreshAuditPanel(RetNo);
    MainForm.FormPaint(Application);
  end;
end;

procedure TGuiT1_2026.TaxPlannerUsenextyearrates1Click(Sender: TObject);
begin
exit; //what?
end;

// --------- Field Popup ----------------------

var //initialized by NotEditCommand
  SenderClass: string;
  MyEditBox: TvtEdit;
  //MyScrollBox: TvtScrollBox; --> MyForm
  FieldId: integer;
  //FormName: string;

function TGuiT1_2026.NotEditCommand(Sender: TObject): boolean;
var
  cmp: TComponent;
begin
(* determine commonly used values for vtEdit field
  Sender of popup commands is TMenuItem - use FieldPopup.Component?

  use Screen.ActiveControl?
*)
  //SenderClass := Sender.ClassName; //mostly for debugging, is TMenuItem!
  //cmp := FieldPopup.PopupComponent;
  cmp := Screen.ActiveControl;
  SenderClass := cmp.ClassName;
  Result := not (cmp is TvtEdit);
  if Result then exit; //same exit in caller
  MyEditBox := TvtEdit(cmp);
  MyForm := GetMyScrollBox(MyEditBox);
  FieldId := MyEditBox.FieldId;
  FRetNo := MyForm.RetNo; //private in this class
  FormName := MyForm.FormName;
  FormNo := MyForm.FormNo;
  MyChild := RetList[RetNo].MyChild;
end;

procedure TGuiT1_2026.Showwhatthevaluewaslastyear1Click(Sender: TObject);
var
  DataList, FrmDataList: TStringList;
  FileFound: boolean;
  LYrValue,FullFlName:String;
begin
  if NotEditCommand(Sender) then exit;

   if (LicenseLevel in [llPower..llMultiPower])
   or (isEnterpriseVersion) //20250119
   then
     //ok
   Else
   begin
    ShowMessage('Feature available only in the Power/Enterprise versions of the program');
    Exit;
   end;

   If IsCanTaxReturn(RetNo) or IsProfileReturn(RetNo) then
   begin
    ShowMessage('Feature available only for returns prepared'
     +Chr(13)+'with VisualTax last year');
    Exit;
   end;
   DataList:=TStringList.Create;
   FrmDataList:=TStringList.Create;  //only portion of the data list, given form
   //get last year's datalist
   FullFlName:=OptRec.Dir_LastYr+'\'+LeftStr(GetSinNo(RetNo),8)
       +'.'+RightStr(GetSinNo(RetNo),1);
   FileFound:=FileExists(FullFlName);
   If FileFound then
   begin
    DataList.LoadFromFile(FullFlName);
     GetFrmDataListFromFullDataList(FormName,DataList,FrmDataList);
     LYrValue:= GetLastYearValue(FieldId,FrmDataList);
     If LYrValue='' then LYrValue:='Nil';
     ShowMessage('Last year'+Chr(39)+'s value was:'+ Chr(13)+LYrValue)
   end
   else
     ShowMessage('Last year'+Chr(39) +'s file was not found in'+
     Chr(13)+'last year'+Chr(39)+ 's directory:'+
     Chr(13)+OptRec.Dir_LastYr);
   DataList.Free;
   FrmDataList.Free;
end;

procedure TGuiT1_2026.AddtoDataDictionaryforclientletters1Click(
  Sender: TObject);
begin
  if NotEditCommand(Sender) then exit;
  InsertKeyWToDataDict(FormName,MyEditBox);
end;

procedure TGuiT1_2026.SortACBBydate3Click(Sender: TObject);
begin
  if NotEditCommand(Sender) then exit;
   SortACBFrm(RetNo,FormName);
   CountDiagnostics(RetNo);
   OpenForm(RetNo,FormNo,0);
   ShowTimedMsg('Sorted',1000);
end;

procedure TGuiT1_2026.AddRow1Click(Sender: TObject);
begin
  if NotEditCommand(Sender) then exit;
  AddDynamicRow(MyForm,FieldId);
end;

procedure TGuiT1_2026.DeleteRow1Click(Sender: TObject);
begin
  if NotEditCommand(Sender) then exit;
  DeleteDynamicRow(MyForm,FieldId);
end;

procedure TGuiT1_2026.RefreshALLdependantsaddressesfromparent1Click(
  Sender: TObject);
begin
  if NotEditCommand(Sender) then exit;
   RefreshDependAddresses(RetNo);
   ShowTimedMsg('Addresses refreshed',1000);
   If MainForm.LeftPanel.Visible then MainForm.RefreshAuditPanel(RetNo);
   MainForm.FormPaint(Application);
end;

procedure TGuiT1_2026.Refreshaddressfromotherspouse1Click(Sender: TObject);
begin
  if NotEditCommand(Sender) then exit;
   RefreshSpouseAddresses(RetNo);
   ShowTimedMsg('Address refreshed',1000);
   //If MainForm.AuditPanel.Visible then
     MainForm.RefreshAuditPanel(RetNo);
   OpenForm(RetNo,'INFO',0);  //201011210
   MainForm.FormPaint(Application);
end;

procedure TGuiT1_2026.AttachNote1Click(Sender: TObject);
var
    RefFormName,RefFieldId,FName:String;
    FNo:Integer;Cinst:Integer;
begin
  if NotEditCommand(Sender) then exit;
   RefFormName:=FormName;
   RefFieldId:=IntToStr(FieldId);
   FNo:=GetFldMemFormNo(RetNo,RefFormName,RefFieldId);
   If FNo>0 then
   begin
    OpenForm(RetNo,FNo,0);
    FLDMEM(RetNo,GetFormName(RetNo,FNo),FNo);
   end
   else {not existing}
   begin
    CInst:=GetEmptyInstance(RetNo,'FLDMEM');
    If CInst>0 then
    begin
     FNo := AddPageInstance(RetNo, 'FLDMEM','#'+IntToStr(CInst));
     if FNo > 0
     then
     begin
       FName:='FLDMEM'+'#'+IntToStr(CInst);
       //FNo:=GetFormNo(FName);
       InitFormData(RetNo,FNo);
       StoreElm(RetNo,FNo,17,RefFormName);
       StoreElm(RetNo,FNo,18,RefFieldId);
       OpenForm(RetNo,FNo,0);
       FLDMEM(RetNo,FName,FNo);
     end;
    end
    else
     ShowMessage('Cannot create more field memos');
   end; {not existing}
end;

procedure TGuiT1_2026.AttachAddingTape1Click(Sender: TObject);
var
    RefFormName,RefFieldId,FName:String;
    FNo:Integer;Cinst:Integer;
begin
  if NotEditCommand(Sender) then exit;
   If (MyEditBox.vtInputtype <> vtDollar)
   or (MyEditBox.vtDataSource <> vtUser)
   then
   begin
    ShowMessage('Adding tape is allowed only for un-protected dollars fields');
    Exit;
   end;
   RefFormName:=FormName;
   RefFieldId:=IntToStr(FieldId);
   FNo:=GetFldTapeFormNo(RetNo,RefFormName,RefFieldId);
   If FNo>0 then
     OpenForm(RetNo,FNo,0)
   else {new fldtape}
   begin
    CInst:=GetEmptyInstance(RetNo,'FLDTAPE');
    If CInst>0 then
    begin
     FNo:=AddPageInstance(RetNo, 'FLDTAPE','#'+AllTrim(IntToStr(CInst)));
     If FNo > 0 then
     begin
       FName:='FLDTAPE'+'#'+AllTrim(IntToStr(CInst));
       //FNo:=GetFormNo(FName);
       InitFormData(RetNo,FNo);
       StoreElm(RetNo,FNo,121,RefFormName);
       StoreElm(RetNo,FNo,122,RefFieldId);
       StoreElm(RetNo,FNo,124,'X');
       OpenForm(RetNo,FNo,0);
     end;
    end
    else
     ShowMessage('Cannot create more adding tapes');
   end; {not existing}
end;

procedure TGuiT1_2026.Help4Click(Sender: TObject);
var
  HelpTopic: string;
begin
  if NotEditCommand(Sender) then exit;
  HelpTopic := GetHlpTopicFromLineRef(FormName,FieldId);
  If HelpTopic = '' then {MainFormT1.}HelpBtnClick(Application)
  else
    ShowHelp(AppT1_2026.ModuleHelpFile, HelpTopic, True); //20161220 Igor
end;

procedure TGuiT1_2026.CICAWebbasedsubscriptionrequired1Click(
  Sender: TObject);
var
  HelpTopic: string;
begin
  if NotEditCommand(Sender) then exit;
   HelpTopic:=GetHlpTopicFromLineRef(FormName,FieldId);
   If LeftStr(HelpTopic,5)='Line_' then HelpTopic:=MidStr(HelpTopic,6,3);
   LinkToCICA(HelpTopic);
end;

procedure TGuiT1_2026.TRVisualTaxResearchWebbased1Click(Sender: TObject);
var
  HelpTopic: string;
begin
  if NotEditCommand(Sender) then exit;
   HelpTopic:=GetTrTopicFromLineRef(FormName,FieldId);
   //If LeftStr(HelpTopic,5)='Line_' then HelpTopic:=ReplaceChar(HelpTopic,'_',' ');
   If Length(HelpTopic)>3 then  //only lines 000 to 999
     HelpTopic:=''
   else
     HelpTopic:='Line '+HelpTopic;
   //ShowMessage(Helptopic);
   LinkToTr(HelpTopic);
end;

procedure TGuiT1_2026.RemovecurrentfieldoverrideClick(Sender: TObject);
begin
 //if ButtonInactive then exit;
 if NotEditCommand(ActiveControl) then exit;
 If (RetNo >0) and (FormNo >0) and (FieldId >0) then
 begin
   RemoveFieldOverride(RetNo,FormNo,FieldId);
   Calc(RetNo,FormName);
   CalcAll(RetNo);
   //MyChild.FormPaint(Sender);
   {InvalidateRect(GetFormHandle(RetNo, FormNo),Nil,TRUE);}
  end;
end;

procedure TGuiT1_2026.Lockamountoncurrentfield1Click(Sender: TObject);
begin
 //if ButtonInactive then exit;
  if NotEditCommand(Screen.ActiveControl) then exit;
  If (RetNo >0) and (FormNo >0) and (FieldId >0) then
   SetFieldOverride(RetNo,FormNo,FieldId);
end;
//20160216 Igor
procedure TGuiT1_2026.ReviewAutoFilldatareceivedfromCRA1Click(Sender: TObject);
begin
  AutofillfromCRABtnClick(Application);
end;

procedure TGuiT1_2026.ReviewBtnClick(Sender: TObject);
begin
  if NotEditCommand(Screen.ActiveControl) then exit;
  MyForm.ToggleReview(MyEditBox);
end;

procedure TGuiT1_2026.Override1Click(Sender: TObject);
begin
  if NotEditCommand(Screen.ActiveControl) then exit;
  MyForm.ToggleOverride(MyEditBox);
end;

procedure TGuiT1_2026.FormSections1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  MyChild.GoToSection('');
end;

procedure TGuiT1_2026.FormShow(Sender: TObject);
begin
{}
end;

procedure TGuiT1_2026.WebServiceErrorMessages1Click(Sender: TObject);
begin
 //If UpperCase(InputBox('The 2022 version is not released yet', 'PSW', '')) <> 'N/A' then exit;  //20200121
 ShowPdf(AppDir,'WebServiceErrors.pdf');
end;

procedure TGuiT1_2026.QuickFindBtnExit(Sender: TObject);
begin
  if ButtonInactive then exit;
 If QuickFindBtn.text='' then exit;
 QuickFormFind(RetNo, QuickFindBtn.text);
end;

procedure TGuiT1_2026.QuickFindBtnKeyPress(Sender: TObject; var Key: Char);
begin
//20170823 Igor>>>
  If key = #13 then
    actFindFormExecute(nil);
//20170823 Igor<<<
end;

procedure TGuiT1_2026.rbnT1RecentItemClick(Sender: TObject; FileName: string;
  Index: Integer);
begin
  ListView1.ItemIndex := Index;
  OpenItBtnClick(OpenItBtn);
end;

procedure TGuiT1_2026.BirthDateClients1Click(Sender: TObject);
begin
 if MessageDlg('This function finds all clients whose birthdate is today or some other date.'+
   Chr(13)+'In the upcoming window click the Advanced Filter button and then set the Birthdate button'+
   Chr(13)+'Proceed?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;

 If RetInMem>0 then begin ShowMessage('Please close all returns first'); exit;end;
 SomeCaption := 'Client Data Base Analyser';
 Application.CreateForm(TAnalyseT1_2026,Analyse);
 Analyse.ShowModal;
 Analyse.Free;

(*
 if MessageDlg('This function finds all clients whose birthdate is today.'+
   Chr(13)+'For other dates you may use File->DataBase Analyser->Advanced'+
   Chr(13)+'Proceed?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then exit;

 If RetInMem>0 then begin ShowMessage('Please close all returns first'); exit;end;

 Application.CreateForm(TAnalyse,Analyse);
// Analyse.ShowModal;
 Analyse.AdvancedBtnClick(Sender);
 SomeList := Tstringlist.Create;
 Application.CreateForm(TAdvFnd,AdvFnd);
 //AdvFnd.ShowModal;  //Option do not show it
 Advfnd.BirthdateBtnClick(Sender);
 advfnd.FindBtnClick(Sender);
 AdvFnd.Free;
 Analyse.ShowModal;
 If Somelist <> Nil then
 Begin
  //ShowMessage(IntToStr(Somelist.Count));
  //Application.CreateForm(TAnalyse,Analyse);
  //Analyse.ShowModal;
  //Analyse.Free;
  Somelist.free;
 end;
*)
end;

procedure TGuiT1_2026.HistoryofEfilesubmissions1Click(Sender: TObject);
Var OnlineNo,Password,Url,NetFileDir:String;
FlNm:String;
h: THandle;
begin
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 OpenDialog.Title    := 'History of Efile submissions';
 OpenDialog.InitialDir := NetFileDir;
 //20140130
 OpenDialog.Filter:='All Files|*.*|Displayed Acknowledgement|*.htm|Actual XML files|*.xml';
 OpenDialog.FileName := '*.*';
 If OpenDialog.Execute then
 begin
  FlNm:=OpenDialog.FileName;
  h := ShellExecute(Application.Handle,'open',Pchar(''+flNm),Nil,Nil,Sw_Show);
  If h<=32 then ShowMessage('File not found');
 end;
end;
//20160216 Igor
procedure TGuiT1_2026.HistoryofT1013submissions1Click(Sender: TObject);
Var OnlineNo,Password,Url,NetFileDir:String;
FlNm:String;
h: THandle;
begin
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 OpenDialog.Title    := 'History of T1013 submissions';
 OpenDialog.InitialDir := AppDir+'\'+'AUTHREPEfile';  //20200209
 OpenDialog.Filter:='All Files|*.*|Displayed Acknowledgement|*.htm|Actual XML files|*.xml';
 OpenDialog.FileName := '*.*';
 If OpenDialog.Execute then
 begin
  FlNm:=OpenDialog.FileName;
  h := ShellExecute(Application.Handle,'open',Pchar(''+flNm),Nil,Nil,Sw_Show);
  If h<=32 then ShowMessage('File not found');
 end;
end;
//20160216 Igor
procedure TGuiT1_2026.HistoryofT1135Submissions1Click(Sender: TObject);
Var OnlineNo,Password,Url,NetFileDir:String;
FlNm:String;
h: THandle;
begin
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 OpenDialog.Title    := 'History of T1013 submissions';
 OpenDialog.InitialDir := AppDir+'\'+'T1135Efile';
 OpenDialog.Filter:='All Files|*.*|Displayed Acknowledgement|*.htm|Actual XML files|*.xml';
 OpenDialog.FileName := '*.*';
 If OpenDialog.Execute then
 begin
  FlNm:=OpenDialog.FileName;
  h := ShellExecute(Application.Handle,'open',Pchar(''+flNm),Nil,Nil,Sw_Show);
  If h<=32 then ShowMessage('File not found');
 end;
end;

//20170402
procedure TGuiT1_2026.HistoryOfReFILEDreturns1Click(Sender: TObject);
Var Dir,FullFlName,FlName:String;
begin
 OpenDialog.Title    := 'History of returns before ReFiling';
 OpenDialog.InitialDir := AppDir+'\'+'RefiledReturns';
 If OpenDialog.Execute then
 begin
   FullFlName :=OpenDialog.FileName;
   FlName:=ExtractFileName(FullFlName);
   Dir := ExtractFileDir(FullFlName);
   OpenReturnCoupled(Dir,FlName, True); //assume always visible
   Done;
 End;
end;

//20140130
procedure TGuiT1_2026.HistoryofBatchAcknowledgements1Click(Sender: TObject);
Var FlleNm:String;
begin
 GetEOLPParms(OnlineNo,TransmitterNo,Password,Url,NetFileDir);
 OpenDialog.Title    := 'History of batch Efile acknowledgement';
 OpenDialog.InitialDir := NetFileDir;
 OpenDialog.Filter :=  'All Files|*.Ack';
 OpenDialog.FileName := '*.Ack';
 If OpenDialog.Execute then
 begin
  FlleNm:=OpenDialog.FileName;
  T1_2026eolPAck.ReadAckFileHeaderInfo(FlleNm);
  //UeolPAck.PrintAckReport(FlleNm,'R');
  T1_2026eolPAck.SelectAckReport(FlleNm);
 end;
end;

procedure TGuiT1_2026.T1EfileBtnClick(Sender: TObject);
begin
//don't use!
{
 Application.CreateForm(TT1Efile,T1Efile);
 T1Efile.ShowModal;
 T1Efile.Free;
}
end;

// --- following were never implemented ---

procedure TGuiT1_2026.EFile2Click(Sender: TObject);
begin
  //NOP - EFile Setup...
end;
//20160216 Igor
procedure TGuiT1_2026.EfileAppendicesExclusionsandotherinfo1Click(
  Sender: TObject);
begin
 ShowMessage ('See the Efiler Manual'); //UserShowPdf(AppDir,'App-17e.pdf'); //20180204
end;

procedure TGuiT1_2026.ShowTreeview1Click(Sender: TObject);
begin
  //NOP
end;

procedure TGuiT1_2026.WindowCascadeItemClick(Sender: TObject);
begin
  //NOP
end;

procedure TGuiT1_2026.WindowArrangeItemClick(Sender: TObject);
begin
  //NOP
end;

procedure TGuiT1_2026.MinimizeformClick(Sender: TObject);
begin
  //NOP
end;

procedure TGuiT1_2026.MinimizeReturnClick(Sender: TObject);
begin
  //NOP
end;

procedure TGuiT1_2026.MinimizeAllClick(Sender: TObject);
begin
  //NOP
end;

procedure TGuiT1_2026.RestoreReturnClick(Sender: TObject);
begin
  //NOP
end;

procedure TGuiT1_2026.RestoreAllClick(Sender: TObject);
begin
  //NOP
end;

procedure TGuiT1_2026.ChangetaxmoduleT1T2TFFP1Click(Sender: TObject);
begin
  ShowSplash;
end;

procedure TGuiT1_2026.DeveloperMode1Click(Sender: TObject);
begin
  if inJZtestmode then
  begin
    inJZtestmode      := false;
    IsDeveloperLogin  := false;     //need to turn this of or will stay logged on and will not ask for PW again on second time after turning off
    ShowTimedMsg('developer mode OFF',2000);
  end
  else
  begin
    if GetDeveloperPwd then
    begin
      inJZtestmode := true;
      ShowTimedMsg('developer mode ON',2000);
    end;
  end;
end;

procedure TGuiT1_2026.DeveloperOnly1Click(Sender: TObject);
begin
  //20190119
  DeveloperOnly1.OnClick := nil; //unlock submenu
  //rgDeveloper.Visible := True; //20190415 Igor
 {
  if rgDeveloper.Visible then
    rgDeveloper.Visible := False
  else
  if GetDeveloperPwd then
  begin
    DeveloperOnly1.OnClick := nil; //unlock submenu
    rgDeveloper.Visible := True;
  end
 }
end;

Procedure TGuiT1_2026.ShowTddStatus; //20160126 Igor
Var i:Integer;s:String;
Begin
 //SomeList := TStringList.Create;  //20170512 Igorr
 SomeList.Clear; //20240205 Igor
 SomeCaption := 'Status of received returns from CRA';
 for i :=0 to (TddSinsReceived.Count - 1) do
   SomeList.Add(TddSinsReceived[i]);
 SelectedString := PopSomeList(SomeList, SomeCaption);
// Application.CreateForm(TPoplist,PopList);
// PopList.ShowModal;
// SomeList.Free; PopList.Release;
End;

function TGuiT1_2026.GetCoupleFromCloud(ASourceDir, AFileName: string): string; //20190528 Igor //20200914 Igor
var
  I, J: Integer;
  fileList: TStringList;
  afileList: TCloudFileList;
  hconf: THelperAppUserConfig;
  FileSin, CloudPath, ClientId, Token, CloudFile: string;
begin
  Result := '';
  FileList := TStringList.Create;
  afileList := TCloudFileList.Create();
  try
    CloudFile := '';
    for I := 0 to HelperManager.HelperClassList.Count - 1 do
    begin
      if not HelperManager.AllowSend(I) then continue;
      hconf := HelperManager.Config(I, AppT1_2026.AppId, User.UserName);
      CloudPath := hconf.Path;
      ClientId := HelperManager.Config(I).ClientID;
      Token := hConf.Token;
      if not HelperManager.List(I, CloudPath, ClientID, Token, FileList) then continue;
      for J := 0 to (FileList.Count - 1) do
        if not FileList[J].IsEmpty then
          If FileList[J][1] <> '*' then
            if SameText(AFileName, FileList[J]) then
            begin
              CloudFile := FileList[J];
              break;
            end;
      if CloudFile.IsEmpty then continue;
      if HelperManager.Get(I, TPath.Combine(ASourceDir, CloudFile), CloudPath, CloudFile, ClientID, Token) then
      begin
        Result := CloudFile;
        break;
      end;
    end;
  finally
    FileList.Free;
    afileList.Free;
  end;
end;

procedure TGuiT1_2026.OpenFromCloudClick(Sender: TObject);//20161210 Igor
var
  CloudPath, CloudFile, ClientID, Token: String;
  mi: TMenuItemEx;
  hconf: THelperAppUserConfig;
  isSuccess: boolean;//20171215 Igor
  i : integer; //20190506 Igor
  //20171215 Igor>>
  function SelectfromList(aCloudID: integer): Boolean;
  var
    i: Integer;
    fileList: TStringList;
    afileList: TCloudFileList;//20171215 Igor
    SelectMode: integer; //20200218 Igor
  begin
    //20200218 Igor >>>
    Result := false;
    SelectMode := 0;
    SelectMode := CaseDo('What files do you want to list?',
                   ['Your own files',
                    'Shared files',
                    'All files'], nil);
    if SelectMode = -1 then Exit;
    //20200218 Igor <<<
    FileList := TStringList.Create;
    afileList := TCloudFileList.Create();
    try
      //20200218 Igor >>>
      StartWait;
      try
        SomeList.Clear;
        SomeList.Sorted := False;                                                                             //20161226 Igor
        SomeCaption := 'Select file';
        if (SelectMode in [0,2]) then
        begin
          SetWaitCaption('Retrieving own files list..');
          if HelperManager.List(aCloudID, CloudPath, ClientID, Token, FileList) then //20161226 Igor
          begin
            for i :=0 to (FileList.Count - 1) do
            begin
              //20190222 Igor  >>>
              if not FileList[i].IsEmpty then
                If FileList[i][1] <> '*' then
                  SomeList.Add(FileList[I]);
              //20190222 Igor <<<
            end;
          end;
        end;
        //20171215 Igor>>
        if (SelectMode in [1,2]) then
        begin
          SetWaitCaption('Retrieving shared files list..');
          if HelperManager.ListReceived(aCloudID, ClientID, Token, afileList) then
          begin
            for i :=0 to (aFileList.Count - 1) do
            begin
              //20190222 Igor >>>
              if not aFileList[i].Path.IsEmpty then
                If aFileList[i].Path[1] <> '*' then
                  SomeList.AddObject('*' + aFileList[I].Path, TObject(i + 1));
              //20190222 Igor <<<
            end;
          end;
        end;
      finally
        EndWait;
      end;
      if SomeList.Count = 0 then
      begin
        ShowMessage('There are no files to show. Make sure that you specify correct folder path in Configuration window');
        Exit;
      end;
       //20200218 Igor <<<
     CloudFile := SelectCloudFile(SomeList, AppName+ '-' + Copy(AppYear, 3, 2)); //20201015 Igor
     //CloudFile := PopSomeList(SomeList, SomeCaption);
      result := CloudFile <> '';
      if Result and Assigned(PopListObject) then
        CloudPath := aFileList[Integer(PopListObject) - 1].Url;
      //20171215 Igor<<
      if hconf.SaveToken and (hconf.Token <> Token) then
        hconf.Token := Token;
    finally
      FileList.Free;
      afileList.Free;
    end;
  end;

  procedure LoadFromCloud(aCloudID: integer);
  begin
    if CloudFile = '' then //20190506 Igor
      if not SelectfromList(aCloudID) then
        exit;
    //20200218 Igor >>>
    StartWait('Downloading file..');
    try
      if CloudFile[1] = '*' then
      begin
        CloudFile := copy(CloudFile, 2, Length(CloudFile));
        if Pos('\', CloudFile) > 0 then
          CloudFile := Copy(CloudFile, Pos('\', CloudFile) + 1, Length(CloudFile));
        isSuccess := HelperManager.GetShared(aCloudID, IncludeTrailingPathDelimiter(optRec.Dir_Cur)+CloudFile,
              CloudPath, ClientID, Token);
      end
      else
        isSuccess := HelperManager.Get(aCloudID, IncludeTrailingPathDelimiter(optRec.Dir_Cur)+CloudFile,
              CloudPath, CloudFile, ClientID, Token);
    finally
      EndWait;
    end;
    //20200218 Igor <<<
    if isSuccess then
    begin
      if hconf.SaveToken and (hconf.Token <> Token) then
        hconf.Token := Token;
      OpenReturnCoupled(optRec.Dir_Cur, CloudFile, True);
//20190506 Igor >>>
      //if run in browser and file is successfullyloaded from Dropbox
      if CheckIsCloud(True) then begin
        TFile.Delete(TPath.Combine(optRec.Dir_Cur, CloudFile));
      end;
//20190506 Igor <<<
      Done;
    end;
    end;
begin
  if Sender is TMenuItemEx then
  begin
    mi := (Sender as TMenuItemEx);
    hconf := HelperManager.Config(mi.HelperID, AppT1_2026.AppId, User.UserName);
    CloudFile := '';
    ClientID := HelperManager.Config(mi.HelperID).ClientID;
    CloudPath := hconf.Path;
    Token := hconf.Token;

    case mi.HelperAction of
      haSaveToCloud:;
      haLoadFromCloud:
        begin
          LoadFromCloud(mi.HelperID);
        end;
      haViewList:
        SelectfromList(mi.HelperID);
    end;
  end;
  if Sender is TAction then
  begin
    hconf := HelperManager.Config((Sender as TAction).Tag, AppT1_2026.AppId, User.UserName);
    CloudFile := '';
    ClientID := HelperManager.Config((Sender as TAction).Tag).ClientID;
    CloudPath := hconf.Path;
    Token := hconf.Token;
    LoadFromCloud((Sender as TAction).Tag);
  end;
  //20171215 Igor<<
//20190506 Igor >>>
  if Sender is TListItem then
  begin
    for I := 0 to MainMenu.Items[0].Count -1 do begin
      if Pos('Open return from cloud',MainMenu.Items[0].Items[i].Caption) > 0 then begin
        mi := (MainMenu.Items[0].Items[i] as TMenuItemEx);
        break;
      end;
    end;
    if mi = nil then exit;
    hconf := HelperManager.Config(mi.HelperID, AppT1_2026.AppId, User.UserName);
    CloudFile := Format('%s-{%s}',[AllTrim(TListItem(Sender).Caption),AllTrim(TListItem(Sender).SubItems[2])]);
    ClientID := HelperManager.Config(mi.HelperID).ClientID;
    CloudPath := hconf.Path;
    Token := hconf.Token;
    LoadFromCloud(mi.HelperID);
  end;
//20190506 Igor <<<
  //20190517 Igor >>>
  if Sender is TClientBookCloudT1_2026 then
  begin
    for I := 0 to MainMenu.Items[0].Count -1 do begin
      if Pos('Open return from cloud',MainMenu.Items[0].Items[i].Caption) > 0 then begin
        mi := (MainMenu.Items[0].Items[i] as TMenuItemEx);
        break;
      end;
    end;
    if mi = nil then exit;
    hconf := HelperManager.Config(mi.HelperID, AppT1_2026.AppId, User.UserName);
    CloudFile := (Sender as TClientBookCloudT1_2026).GetSelectedFileName;
    ClientID := HelperManager.Config(mi.HelperID).ClientID;
    CloudPath := hconf.Path;
    Token := hconf.Token;
    LoadFromCloud(mi.HelperID);
  end;
  //20190517 Igor <<<
end;
//20190507 Igor >>>
procedure TGuiT1_2026.InitMostRecentFilesCloud;
var
  CloudPath, CloudFile, ClientID, Token, vTmpFile: String;
  hconf: THelperAppUserConfig;
  aCloudID : integer;
  vGetResult : boolean;
begin
  slRecentCloud := TStringList.Create;
  aCloudID := 0;
  hconf := HelperManager.Config(aCloudID, AppT1_2026.AppId, User.UserName);
  CloudFile := 'RecentCloud.txt';
  ClientID := HelperManager.Config(aCloudID).ClientID;
  CloudPath := hconf.Path;
  Token := hconf.Token;
  vTmpFile := IncludeTrailingPathDelimiter(optRec.Dir_Cur)+CloudFile;

  vGetResult := HelperManager.Get(aCloudID, vTmpFile, CloudPath, CloudFile, ClientID, Token);

  //20200305 Igor >>>
  if hconf.SaveToken and (hconf.Token <> Token) then hconf.Token := Token;
  if vGetResult then begin
    slRecentCloud.LoadFromFile(vTmpFile);
    TFile.Delete(vTmpFile);
  end;
  //20200305 Igor <<<
end;

procedure TGuiT1_2026.InitVirtualTaxOfficeMenu; //20201119 Igor
var I: integer;
begin
  case VirtualTaxOfficeInfo.AccountType of
    vtoNone: begin
        for I := 0 to mmVirtualTaxOffice.Count - 1 do
          mmVirtualTaxOffice.Items[I].Visible := mmVirtualTaxOffice.Items[I] = VTO_Login;
      end;
    vtoOffice: begin
        for I := 0 to mmVirtualTaxOffice.Count - 1 do
          mmVirtualTaxOffice.Items[I].Visible :=
            String(mmVirtualTaxOffice.Items[I].Name).EndsWith('_Office', true)
            or
            String(mmVirtualTaxOffice.Items[I].Name).EndsWith('_Both', true);
      end;
    vtoPayer: begin
        for I := 0 to mmVirtualTaxOffice.Count - 1 do
          mmVirtualTaxOffice.Items[I].Visible :=
            String(mmVirtualTaxOffice.Items[I].Name).EndsWith('_Payer', true)
            or
            String(mmVirtualTaxOffice.Items[I].Name).EndsWith('_Both', true);
      end;
  end;
end;

procedure TGuiT1_2026.UpdateMostRecentFilesCloud(ARetNo:Integer; AFileName : string);
var
  CloudPath, CloudFile, ClientID, Token, vTmpFile: String;
  hconf: THelperAppUserConfig;
  aCloudID, i : integer;
  vSendResult : boolean;
  vInsertItem : TStringList;
begin
  for i := 0 to slRecentCloud.Count-1 do begin
    if Pos(AFileName,slRecentCloud[i]) > 0 then begin
      slRecentCloud.Delete(i);
      break;
    end;
  end;
  vInsertItem := TStringList.Create;
  vInsertItem.Add(AllTrim(GetLastName(ARetNo))+' '+AllTrim(GetFirstName(ARetNo)));  //20190517 Igor
  vInsertItem.Add(PaddR(FormatDateTime('yyyy-mm-dd',Date),10));
  vInsertItem.Add(PAddR(TimeToStr(Time),10));
  vInsertItem.Add(AFileName);
  //then add it as first
  slRecentCloud.Insert(0,vInsertItem.CommaText);
  If slRecentCloud.Count > 30 then slRecentCloud.Delete(slRecentCloud.Count-1);
  vInsertItem.Free;

  aCloudID := 0;
  hconf := HelperManager.Config(aCloudID, AppT1_2026.AppId, User.UserName);
  CloudFile := 'RecentCloud.txt';
  ClientID := HelperManager.Config(aCloudID).ClientID;
  CloudPath := hconf.Path;
  Token := hconf.Token;
  vTmpFile := IncludeTrailingPathDelimiter(optRec.Dir_Cur)+CloudFile;
  slRecentCloud.SaveToFile(vTmpFile);

  vSendResult := HelperManager.Send(aCloudID,vTmpFile,CloudPath,CloudFile,ClientID,Token);

  if vSendResult then begin
    TFile.Delete(vTmpFile);
  end;
end;
//20190507 Igor <<<

  (*
  procedure LoadFromCloud(aCloudID: integer);
  begin
    if not SelectfromList(aCloudID) then
      exit;
    if CloudFile[1] = '*' then
    begin
      CloudFile := copy(CloudFile, 2, Length(CloudFile));
      isSuccess := HelperManager.GetShared(aCloudID, IncludeTrailingPathDelimiter(optRec.Dir_Cur)+CloudFile,
            CloudPath, ClientID, Token);
    end
    else
      isSuccess := HelperManager.Get(aCloudID, IncludeTrailingPathDelimiter(optRec.Dir_Cur)+CloudFile,
            CloudPath, CloudFile, ClientID, Token);
    if isSuccess then
    begin
      if hconf.SaveToken and (hconf.Token <> Token) then
        hconf.Token := Token;
      OpenReturnCoupled(optRec.Dir_Cur, CloudFile, True);
      Done;
    end;
    end;
begin
  if Sender is TMenuItemEx then
  begin
    mi := (Sender as TMenuItemEx);
    hconf := HelperManager.Config(mi.HelperID, AppT1_2026.AppId, User.UserName);
    CloudFile := '';
    ClientID := HelperManager.Config(mi.HelperID).ClientID;
    CloudPath := hconf.Path;
    Token := hconf.Token;

    case mi.HelperAction of
      haSaveToCloud:;
      haLoadFromCloud:
        begin
          LoadFromCloud(mi.HelperID);
        end;
      haViewList:
        SelectfromList(mi.HelperID);
    end;
  end;
  if Sender is TAction then
  begin
    hconf := HelperManager.Config((Sender as TAction).Tag, AppT1_2026.AppId, User.UserName);
    CloudFile := '';
    ClientID := HelperManager.Config((Sender as TAction).Tag).ClientID;
    CloudPath := hconf.Path;
    Token := hconf.Token;
    LoadFromCloud((Sender as TAction).Tag);
  end;
  //20171215 Igor<<
end;
*)

//20170825 Igor>>>
{ TRibbonApplicationMenuBar }

procedure TRibbonApplicationMenuBar.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = TOperation.opInsert) and
      Assigned(AComponent) and
      (AComponent is TCustomMDIMenuButton) then
   TThread.CreateAnonymousThread(procedure
      begin
        TThread.Synchronize(nil, procedure
          begin
            MDIChildRestored;
            //TCustomMDIMenuButton(AComponent).Visible := False;
          end);
      end).Start;
end;
//20170825 Igor<<<

//20180307 Igor >>>
initialization

  LoadResourceFontByName('OCRA', 'CUSTOMFONT', TGuiT1_2026);
//20180307 Igor <<<

end.

