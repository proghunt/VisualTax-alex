unit T2_2027main;
(* This was the T2-2013 MainForm.
  It has to be split into the T2 menu and toolbar form,
  and a dummy MainForm connecting the packages to the program's MainForm.
*)

interface

uses WinTypes,FileCtrl,WinProcs,SysUtils,Classes,Graphics,Forms,Controls,Menus,
  StdCtrls,Dialogs,Buttons,Messages,ExtCtrls,ShellApi,DbCtrls,Grids,Calendar,
  ColorGrd,Printers,ComObj,MAPI,ClipBrd,ComCtrls,Spin,DB,
  VCLTee.TeeProcs, //20150623
  ekfunc, ekbasereport, ekrtf, Vcl.StdActns, System.Actions, Vcl.ActnList,
  vtShape,
  VCLTee.TeEngine, VCLTee.Chart,//20150623
  Mask,OleCtrls,
  SHDocVw,ImgList,ToolWin,{QuickRpt,qrextra,}vtMulti,vtChild,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.Ribbon, Vcl.ActnCtrls,
  Vcl.ActnMenus, Vcl.RibbonActnMenus, Vcl.RibbonSilverStyleActnCtrls,
  Vcl.RibbonLunaStyleActnCtrls,
  VirtualUI_Mediator, //20190211 Igor
  vtHelperManager, vtCommonIntf, //20190228 Igor
  System.IOUtils, UIRibbon, UIRibbonCommands, T2_UIRibbonUnit;  //20180523 //20190415 Igor


const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;


Type
  TDFMorTXT = (ConvertToForm, ConvertToText);

type

  TMainFormT2_2027 = class(TForm)
    MainMenuT2: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    OpenfromCloudDropBox1: TMenuItem;
    FileCloseItem: TMenuItem;
    Window: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveAsItem: TMenuItem;
    MinimizeAll: TMenuItem;
    RestoreReturn: TMenuItem;
    Forms: TMenuItem;
    ClearCurrentform: TMenuItem;
    SelectForm: TMenuItem;
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
    Print1: TMenuItem;
    Utilities: TMenuItem;
    Help2: TMenuItem;
    AboutItem: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    PrinterSetup: TMenuItem;
    PrintDialogItem: TPrintDialog;
    TaxSummary: TMenuItem;
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
    T183CORPInformationonEFiling1: TMenuItem;
    DataDictionary1: TMenuItem;
    N23: TMenuItem;
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
    N29: TMenuItem;
    N30: TMenuItem;
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
    EFileBtn: TMenuItem;
    ClientListings1: TMenuItem;
    DeveloperOnly1: TMenuItem;
    NISAcodes1: TMenuItem;
    YourLatestRelease: TMenuItem;
    Upgrade1: TMenuItem;
    N21: TMenuItem;
    InternetWebSite1: TMenuItem;
    AlphabeticalFormsIndex1: TMenuItem;
    Presentation1: TMenuItem;
    Zoomin1: TMenuItem;
    Zoomout1: TMenuItem;
    Toolbandswitch1: TMenuItem;
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
    ABCBtn: TSpeedButton;
    SwapFrm: TSpeedButton;
    PreselNextBtn: TSpeedButton;
    PreSelPrvBtn: TSpeedButton;
    ReviewBox: TGroupBox;
    TSumBtn: TSpeedButton;
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
    N4: TMenuItem;
    ReIndextheClientDataBase1: TMenuItem;
    RestructuretheClientsDataBase1: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N22: TMenuItem;
    ExchageRatesAverage1: TMenuItem;
    Checkupdate1: TMenuItem;
    ClearCurrentPage: TMenuItem;
    N32: TMenuItem;
    RolloverProfile1: TMenuItem;
    ImportBtn: TSpeedButton;
    CharityOrganizations1: TMenuItem;
    SuperEntry1: TMenuItem;
    Employers1: TMenuItem;
    DoctorsHospitalsPharmacies1: TMenuItem;
    MedicalExpenseDescriptions1: TMenuItem;
    FirstNames1: TMenuItem;
    Cities1: TMenuItem;
    T1GuideCCRA1: TMenuItem;
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
    N41: TMenuItem;
    PrintAuditWizardDiagnostics1: TMenuItem;
    N42: TMenuItem;
    EmailCurrentForm: TMenuItem;
    SaveALLopenedreturns1: TMenuItem;
    SaveandCloseAllopenedreturns1: TMenuItem;
    TestBlBox: TMenuItem;
    N50: TMenuItem;
    CCArates1: TMenuItem;
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
    TileVertical1: TMenuItem;
    TileHorizontally1: TMenuItem;
    StatusBarBtn: TSpeedButton;
    HelpBtn: TSpeedButton;
    TipsBtn: TSpeedButton;
    CloseBlackBoxBtn: TBitBtn;
    FormsBlackBoxBtn: TBitBtn;
    CloseallreturnsWITHOUTSaving1: TMenuItem;
    Setdisplayresolution1: TMenuItem;
    N53: TMenuItem;
    Label14: TLabel;
    N54: TMenuItem;
    Lockreturnagaistchanges1: TMenuItem;
    UnlockReturn1: TMenuItem;
    Options2: TMenuItem;
    N3: TMenuItem;
    PrepareDistr1: TMenuItem;
    LicLevel1: TMenuItem;
    N57: TMenuItem;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    ZoomPercentLbl: TLabel;
    EkRTF1: TEkRTF;
    EkUDFList1: TEkUDFList;
    GoToaFormSection1: TMenuItem;
    EmailTheReturn: TMenuItem;
    N12: TMenuItem;
    TUTORIALS1: TMenuItem;
    N19: TMenuItem;
    Backupthetaxdata1: TMenuItem;
    Restoredatafrombackup1: TMenuItem;
    N34: TMenuItem;
    ShowBarCodedata1: TMenuItem;
    N1: TMenuItem;
    ClientPreparerCopy1: TMenuItem;
    FilingcopyAlbertaRSI1: TMenuItem;
    ClientPreparercopy2: TMenuItem;
    N5: TMenuItem;
    GIFIBSFullChartofAccountsreference1: TMenuItem;
    N11: TMenuItem;
    GIFIBSFullChartofAccountsreference2: TMenuItem;
    GifiIsBtn: TSpeedButton;
    OntBtn: TSpeedButton;
    FNotesBtn: TSpeedButton;
    T2Btn: TSpeedButton;
    AlbBtn: TSpeedButton;
    SetupEOLInternetFiling1: TMenuItem;
    CopyBtn: TSpeedButton;
    TreeViewBtn: TSpeedButton;
    SwapBtn: TSpeedButton;
    RolloverVisualTax1: TMenuItem;
    RolloverCanTax1: TMenuItem;
    Builda5yearcomarativesummary1: TMenuItem;
    N17: TMenuItem;
    Builda5yearsummaryFromVisualTax1: TMenuItem;
    GIFIGuide1: TMenuItem;
    AlbertaAT1GuidePart11: TMenuItem;
    FindKeyWordintheform1: TMenuItem;
    ResourceTaxation1: TMenuItem;
    ProvincialRates1: TMenuItem;
    N26: TMenuItem;
    AlbertaTaxGuidePart21: TMenuItem;
    YSumBtn: TSpeedButton;
    QuickStarterGuide1: TMenuItem;
    GroupBox1: TGroupBox;
    SpeedButton5: TSpeedButton;
    SpeedButton8: TSpeedButton;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Image3: TImage;
    AppUpdateDate2: TLabel;
    Label9: TLabel;
    AppLabel: TLabel;
    PrintMailingLabelcurrentclient1: TMenuItem;
    Barcodeprinting1: TMenuItem;
    SignOffWarnings1: TMenuItem;
    N28: TMenuItem;
    DividendTaxation1: TMenuItem;
    Special1: TMenuItem;
    ShortDateFormat1: TMenuItem;
    SEQGIFIIS1: TMenuItem;
    SEQGIFIBS1: TMenuItem;
    vtScan1: TMenuItem;
    ReviewFilesinCLIENTDOCS1: TMenuItem;
    N37: TMenuItem;
    SavereturninPDFFormatinClientDocs1: TMenuItem;
    SaveDialog: TSaveDialog;
    AboutPanel: TPanel;
    vtShape2: TvtShape;
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
    Label1: TLabel;
    Label3: TLabel;
    AppLabel3: TLabel;
    WWWLbl: TLabel;
    Label5: TLabel;
    Image2: TImage;
    TradeMarkLbl: TLabel;
    QuickStartLbl: TLabel;
    KnownIssuesLbk: TLabel;
    ListView1: TListView;
    OpenItBtn: TBitBtn;
    EMailItBtn: TBitBtn;
    CopyAReturnBtn: TBitBtn;
    Changetaxmodule: TMenuItem;
    N24: TMenuItem;
    FormPopup: TPopupMenu;
    TileReturnsVertically1: TMenuItem;
    TileReturnsHorizontally1: TMenuItem;
    TileReturnsHorizontally2: TMenuItem;
    SignOffWarnings2: TMenuItem;
    SignOffWarnings3: TMenuItem;
    Help1: TMenuItem;
    Help3: TMenuItem;
    TRTaxResearch1: TMenuItem;
    TRTaxResearch2: TMenuItem;
    PrintPage1: TMenuItem;
    PrintForm2: TMenuItem;
    EMailForm1: TMenuItem;
    EMailForm2: TMenuItem;
    ClearCurrentPage1: TMenuItem;
    ClearCurrentForm1: TMenuItem;
    ClearCurrentForm2: TMenuItem;
    CopyForm2: TMenuItem;
    FormSections1: TMenuItem;
    FormSections2: TMenuItem;
    Notepad1: TMenuItem;
    Notepadwithamounts1: TMenuItem;
    PrivateNotepad1: TMenuItem;
    FieldPopup: TPopupMenu;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    EditCut1: TEditCut;
    Cut1: TMenuItem;
    N38: TMenuItem;
    AddtoDataDictionaryforclientletters1: TMenuItem;
    SetResetReviewMark1: TMenuItem;
    SetResetReviewMark2: TMenuItem;
    AttachNote1: TMenuItem;
    AttachAddingTape1: TMenuItem;
    AttachAddingTape2: TMenuItem;
    Help4: TMenuItem;
    TRVisualTaxResearchWebbased1: TMenuItem;
    CICAWebbasedsubscriptionrequired1: TMenuItem;
    SetResetOverride1: TMenuItem;
    Image1: TImage;
    Panel7: TPanel;
    LicenseLevelLbl: TLabel;
    Panel8: TPanel;
    AppUpdateDateLbl: TLabel;
    Panel3: TPanel;
    AppReleaseLbl: TLabel;
    Timer: TTimer;
    ImportfromProduction1: TMenuItem;
    ResetclientDB1: TMenuItem;
    buttonAvailableWidth: TSpeedButton;
    ConvertDataandOptionstoMultipAppversion1: TMenuItem;
    Image4: TImage;
    Label8: TLabel;
    Label10: TLabel;
    QuickFindBtn: TEdit; //20160617 Igor
    Resetpasswordwithreturn1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Hist1: TMenuItem;
    RollOverfromTaxCycle1: TMenuItem;
    Coupling: TMenuItem;
    Couling1: TMenuItem;
    CreatetheCorporateGroupData1: TMenuItem;
    EdittheCorporateGrouopData1: TMenuItem;
    UsetheCorporateGroupdata1: TMenuItem;
    AppLinks1: TMenuItem;
    Owner1: TMenuItem;
    Recovery1: TMenuItem;
    amT2: TActionManager;
    il16: TImageList;
    il32: TImageList; //20170409 Igor

    actChangetaxmodule: TAction;
    actFileNewItem: TAction;
    actFileOpenItem: TAction;
    actOpenfromCloudDropBox1: TAction;
    actOpenPreviousYearsT11: TAction;
    actOpenbyFileName1: TAction;
    actFileSaveAsItem: TAction;
    actSaveALLopenedreturns1: TAction;
    actSaveandCloseAllopenedreturns1: TAction;
    actFileCloseItem: TAction;
    actCloseallreturnsWITHOUTSaving1: TAction;
    actRolloverVisualTax1: TAction;
    actRolloverCanTax1: TAction;
    actRolloverProfile1: TAction;
    actRollOverfromTaxCycle1: TAction;
    actImportfromProduction1: TAction;
    actConvertDataandOptionstoMultipAppversion1: TAction;
    actBuilda5yearsummaryFromVisualTax1: TAction;
    actBuilda5yearcomarativesummary1: TAction;
    actLockreturnagaistchanges1: TAction;
    actUnlockReturn1: TAction;
    actCreateDataDirectory1: TAction;
    actChangeDataDirectory1: TAction;
    actSetReturnPassword1: TAction;
    actRemoveReturnPassword1: TAction;
    actFileExitItem: TAction;
    actSelectForm: TAction;
    actGoToaFormSection1: TAction;
    actFindaline1: TAction;
    actAlphabeticalFormsIndex1: TAction;
    actJacket: TAction;
    actLine1: TAction;
    actFindKeyWordintheform1: TAction;
    actClearCurrentPage: TAction;
    actClearCurrentform: TAction;
    actCopyForm1: TAction;
    actSwitchforms1: TAction;
    actSignOffWarnings1: TAction;
    actOwner1: TAction;
    actOptions2: TAction;
    actDefinetheTRfolder1: TAction;
    actPrintTemplates1: TAction;
    actFeeSchedule1: TAction;
    actSuperEntry1: TAction;
    actDoctorsHospitalsPharmacies1: TAction;
    actCharityOrganizations1: TAction;
    actMedicalExpenseDescriptions1: TAction;
    actEmployers1: TAction;
    actFirstNames1: TAction;
    actCities1: TAction;
    actCompanyLogo1: TAction;
    actClientLetter1: TAction;
    actDataDictionary1: TAction;
    actProvincialRates1: TAction;
    actExportConfiguration1: TAction;
    actImportConfiguration1: TAction;
    actUserSetUp1: TAction;
    actShowCellNumbers1: TAction;
    actCurrentPage1: TAction;
    actPrintForm1: TAction;
    actShowBarCodedata1: TAction;
    actFederalT21: TAction;
    actBarcodeprinting1: TAction;
    actClientPreparerCopy1: TAction;
    actALBERTAAT11: TAction;
    actFilingcopyAlbertaRSI1: TAction;
    actClientPreparercopy2: TAction;
    actClientListings1: TAction;
    actEmailCurrentForm: TAction;
    actEmailTheReturn: TAction;
    actReviewFilesinCLIENTDOCS1: TAction;
    actSavereturninPDFFormatinClientDocs1: TAction;
    actPrintMailingLabelcurrentclient1: TAction;
    actGIFIBSFullChartofAccountsreference1: TAction;
    actGIFIBSFullChartofAccountsreference2: TAction;
    actPrintAuditWizardDiagnostics1: TAction;
    actN42: TAction;
    actPrinterSetup: TAction;
    actvtScan1: TAction;
    actSetupEOLInternetFiling1: TAction;
    actT183CORPInformationonEFiling1: TAction;
    actEFileBtn: TAction;
    actHist1: TAction;
    actRecalc1: TAction;
    actDiagnostics: TAction;
    actTaxSummary: TAction;
    actComparativeSummary: TAction;
    actShowTreeview1: TAction;
    actZoomin1: TAction;
    actZoomout1: TAction;
    actToolbandswitch1: TAction;
    actColor1: TAction;
    actTileVertical1: TAction;
    actTileHorizontally1: TAction;
    actSetdisplayresolution1: TAction;
    actCalculator1: TAction;
    actCalendar1: TAction;
    actBackupthetaxdata1: TAction;
    actRestoredatafrombackup1: TAction;
    actRebuildtheClientDataBase1: TAction;
    actMergeDataBases1: TAction;
    actFileViewerEditor1: TAction;
    actReIndextheClientDataBase1: TAction;
    actFixClientDataBaseData1: TAction;
    actRestructuretheClientsDataBase1: TAction;
    actFixFormSpecifications1: TAction;
    actUpgrade1: TAction;
    actDeveloperOnly1: TAction;
    actPrepareDistr1: TAction;
    actLicLevel1: TAction;
    actSpecial1: TAction;
    actSEQGIFIIS1: TAction;
    actSEQGIFIBS1: TAction;
    actAllforms1: TAction;
    actResetclientDB1: TAction;
    actResetpasswordwithreturn1: TAction;
    actRecovery1: TAction;
    actTestBlBox: TAction;
    actShortDateFormat1: TAction;
    actWindowTileItem: TAction;
    actWindowCascadeItem: TAction;
    actWindowArrangeItem: TAction;
    actMinimizeform: TAction;
    actMinimizeReturn: TAction;
    actMinimizeAll: TAction;
    actRestoreReturn: TAction;
    actRestoreAll: TAction;
    actQuickStarterGuide1: TAction;
    actTUTORIALS1: TAction;
    actYourLatestRelease: TAction;
    actVisualTaxGuide1: TAction;
    actKnownIssues1: TAction;
    actFrequentlyaskedquestions1: TAction;
    actVisualTaxForum1: TAction;
    actInternetWebSite1: TAction;
    actCheckupdates1: TAction;
    actUsefulLinks: TAction;
    actCheckupdate1: TAction;
    actTrEngineLoad: TAction;
    actTrGuide1: TAction;
    actCICAHelpbyline1: TAction;
    actCICA1: TAction;
    actCICAReferencematerials1: TAction;
    actT1GuideCCRA1: TAction;
    actGIFIGuide1: TAction;
    actCT23Guide1: TAction;
    actAlbertaAT1GuidePart11: TAction;
    actAlbertaTaxGuidePart21: TAction;
    actExchageRatesAverage1: TAction;
    actNISAcodes1: TAction;
    actCCArates1: TAction;
    actResourceTaxation1: TAction;
    actDividendTaxation1: TAction;
    actSystemInformation1: TAction;
    actAboutItem: TAction;
    CoolBar1: TCoolBar;
    tbFileManagement: TToolBar;
    tbtnNewReturn: TToolButton;
    tbtnOpenReturn: TToolButton;
    tbtnSaveReturnAs: TToolButton;
    tbtnImportLastYear: TToolButton;
    tbtnCloseReturn: TToolButton;
    tbtnExit: TToolButton;
    tbFormsNavigation: TToolBar;
    tbtnSelectForm: TToolButton;
    tbtnFindaline: TToolButton;
    tbtnAlphabeticalFormsIndex: TToolButton;
    tbtnGIFI: TToolButton;
    tbtnGIFINotes: TToolButton;
    tbtnJacket: TToolButton;
    sep3: TToolButton;
    tbtnSwapReturn: TToolButton;
    tbtnSwapForm: TToolButton;
    tbtnPreviousPage: TToolButton;
    sep1: TToolButton;
    edtSearchForm: TEdit;
    tbtnFindForm: TToolButton;
    tbReview: TToolBar;
    tbtnRecalc: TToolButton;
    tbtnDiagnostics: TToolButton;
    tbtnReview: TToolButton;
    sep4: TToolButton;
    tbtnTaxSummary: TToolButton;
    tbtnComparativeSummary: TToolButton;
    tbDesctop: TToolBar;
    tbtnZoomout: TToolButton;
    lblZoom: TLabel;
    tbtnZoomin: TToolButton;
    ToolButton4: TToolButton;
    tbtnAvailableWidth: TToolButton;
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
    tbtnTaxSummary2: TToolButton;
    tbtnComparativeSummary2: TToolButton;
    tbDesctop2: TToolBar;
    tbtnZoomout2: TToolButton;
    lblZoom2: TLabel;
    tbtnZoomin2: TToolButton;
    tbtnAvailableWidth2: TToolButton;
    tbHelp2: TToolBar;
    tbtnHelpCurrentForm2: TToolButton;
    tbtnTips2: TToolButton;
    actGifiIsBtn: TAction;
    actGIFINote: TAction;
    actOnt: TAction;
    actAt1_ALB: TAction;
    tbtnAT1ALT: TToolButton;
    tbtnONT: TToolButton;
    actSwap: TAction;
    actNextPage: TAction;
    actPrewPage: TAction;
    tbtnNextPage: TToolButton;
    actFindForm: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    actReviewMark: TAction;
    actAvailableWidth: TAction;
    actHelpCurrentForm: TAction;
    actTips: TAction;
    actAttachaDoc: TAction;
    AttachaDoc1: TMenuItem;
    actAutoFill: TAction;
    actAutoFillGuide: TAction;
    VisualtaxAutoFillGuide1: TMenuItem;
    actApplyAFR: TAction;
    ReviewAcceptdatareceivedfromCRA1: TMenuItem;
    N44: TMenuItem;
    AutoFill1: TMenuItem;
    actViewCOR: TAction;
    ShowtheAFRCorFile1: TMenuItem;
    actChangeSkin: TAction;
    ChangeSkinBtn: TSpeedButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    //20180206 Igor <<<
    //20180424 Igor >>>
    N43: TMenuItem;
    Buildreport1: TMenuItem;
    RC59EfIle1: TMenuItem;
    AUTOFill2: TMenuItem;
    N46: TMenuItem;
    N47: TMenuItem;
    OtherXMLefilefacilitisX1: TMenuItem;
    Countrybycountry1: TMenuItem;
    AutoFill3: TMenuItem;
    N48: TMenuItem;
    T1135Efile1: TMenuItem;
    T106Btn: TMenuItem;
    T1134Btn: TMenuItem;
    FiscalPeriodsLbl: TLabel;
    //20180424 Igor <<<
    //20190212 Igor >>>
    btnUpload: TBitBtn;
    btnUploadWithoutOpen: TBitBtn;
    btnDownload: TBitBtn;
    btnDownloadAll: TBitBtn;
    //20190212 Igor <<<
    actForCloud: TAction;
    //20190415 Igor >>>
    MainUIRibbon: TUIRibbon;
    actFileNewButton: TAction;
    actFileOpenButton: TAction;
    actFileCloseButton: TAction;
    actRolloverVisualTax1Button: TAction;
    actSelectFormButton: TAction;
    Prevalidate1: TMenuItem;
    RequestWACWebAccessCodefromCRA1: TMenuItem;
    SalDiv1: TMenuItem;
    N49: TMenuItem;
    Onlinepayment1: TMenuItem;
    actCreateClientsFolders: TAction;
    actScan: TAction;
    actCopyClientsFolders: TAction;
    CreateClientDocumentFolders1: TMenuItem;
    ScanClientDocuments1: TMenuItem;
    CopyfilestoClientFolders1: TMenuItem;
    //20190228 Igor
    //20200116 Igor >>>
    PrintSequence1: TMenuItem;
    actPrintSequence: TAction;
    PrintCurrentReturn1: TMenuItem;
    actPrintCurrentReturn: TAction;
    EdocServices1: TMenuItem;
    OpenClientDocumentsFolder1: TMenuItem;
    N51: TMenuItem;
    AlertsNotifications1: TMenuItem;
    N56: TMenuItem;
    SavetaxformsinPDFformat1: TMenuItem;
    N2: TMenuItem;
    N20: TMenuItem;
    Entrerpise1: TMenuItem;
    SalaryDividends1: TMenuItem;
    SBDAllocations1: TMenuItem;
    EnterSpecialFeatureskey1: TMenuItem;
    N58: TMenuItem;
    FindDuplicates1: TMenuItem;
    Action1: TAction;
    AddOnHelp: TMenuItem;
    SERSAttachaDocSpecialEfectionsReturns1: TMenuItem;
    N40: TMenuItem;
    DACRequestfromCRA1: TMenuItem;
    //20200116 Igor <<<
    //20190415 Igor <<<

    Function GetPrintTemplate(IncludeFiling:Boolean):string;
    procedure PrintAReturn(Prov:String; Template:String;
      ANotUsePrintDialog: Boolean = False); //20160811 Igor
    procedure Individualsnames1Click(Sender: TObject);
    procedure CorporationNames1Click(Sender: TObject);
    procedure BusinessNumbers1Click(Sender: TObject);
    function SendMAPIMail(const Subject, Body, FileName,SenderName, SenderEMail,
        RecipientName, RecipientEMail: AnsiString): Integer; //20150623
    procedure PrintFormForEmail(RetNo:Integer;FormName:String);
    Procedure GetListOfLoadedReturns(SomeList:TStringList);
    procedure ProcessBlackBoxFile;
    function ConvertFormOrText(FileToConvertFrom:string;ConversionType:TDFMorTXT):Boolean;
    Procedure ListBunchOfForms(TypeOfForm:string;ListCaption:String);
    procedure StartPrintForm(Retno:integer;FormName:String;WhichPage:integer);
    procedure PrintReturn(RetNo:integer;FormsToPrint:TstringList;DataDir:string;FlName:string);
    Function ButtonInactive:Boolean;
    procedure FormCreate(Sender: TObject);
    procedure FileCloseItemClick(Sender: TObject);
    //procedure FileOpenItemClick(Sender: TObject);20171206 Igor
    procedure FileExitItemClick(Sender: TObject);
    procedure FileSaveItemClick(Sender: TObject);
    procedure FileSaveAsItemClick(Sender: TObject);
    procedure CutItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SelectFormClick(Sender: TObject);
    procedure RestoreReturnClick(Sender: TObject);
    procedure RestoreAllClick(Sender: TObject);
    procedure Operational1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ChangeLicenseLevel;
    procedure PrinterSetupClick(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    procedure PrintRBtnClick(Sender: TObject);
    procedure ToolBarBtnClick(Sender: TObject);
    procedure AboutItemClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure StatusBarClick(Sender: TObject);
    Procedure InitColorPanel;
    procedure clrcustomClick(Sender: TObject);
    procedure clr0Click(Sender: TObject);
    procedure OpenbyFileName1Click(Sender: TObject);
    procedure Calendar1Click(Sender: TObject);
    procedure ClientLetter1Click(Sender: TObject);
    procedure PrintForm1Click(Sender: TObject);
    procedure PrintFBtnClick(Sender: TObject);
    procedure CreateDataDirectory1Click(Sender: TObject);
    procedure PrintTemplates1Click(Sender: TObject);
    procedure FeeSchedule1Click(Sender: TObject);
    procedure RemovecurrentreturnOverridesClick(Sender: TObject);
    procedure RemovecurrentfieldoverrideClick(Sender: TObject);
    procedure Lockamountoncurrentfield1Click(Sender: TObject);
    procedure CouplBtnClick(Sender: TObject);
    procedure OverrideBtnClick(Sender: TObject);
    procedure DataDictionary1Click(Sender: TObject);
    procedure DiagnosticsClick(Sender: TObject);
    procedure SamplesBtnClick(Sender: TObject);
    procedure JacketClick(Sender: TObject);
    procedure PersonaldataClick(Sender: TObject);
    procedure TaxSummaryClick(Sender: TObject);
    procedure FixDataDictionary1Click(Sender: TObject);
    procedure FixFormSpecifications1Click(Sender: TObject);
    procedure FixClientDataBaseData1Click(Sender: TObject);
    procedure ShowCellNumbers1Click(Sender: TObject);
    procedure ChangeDataDirectory1Click(Sender: TObject);
    procedure LoadSpousalReturnfromdatabaseCreate1Click(Sender: TObject);
    procedure SwapReturns1Click(Sender: TObject);
    procedure Switchforms1Click(Sender: TObject);
    procedure SwapFrmClick(Sender: TObject);
    procedure FormsBtnClick(Sender: TObject);
    procedure UserSetUp1Click(Sender: TObject);
    procedure TipsBtnClick(Sender: TObject);
    procedure CopyForm1Click(Sender: TObject);
    procedure CopyBtnClick(Sender: TObject);
    procedure SchedBtnClick(Sender: TObject);
    procedure ShowWarnings;
    procedure FrmSumBtnClick(Sender: TObject);
    procedure TSumBtnClick(Sender: TObject);
    procedure UserSetUp2Click(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure Calculator1Click(Sender: TObject);
    procedure Appointments2Click(Sender: TObject);
    procedure Contents2Click(Sender: TObject);
    procedure SearchForHelpOnClick(Sender: TObject);
    procedure VisualTaxGuide1Click(Sender: TObject);
    procedure Allforms1Click(Sender: TObject);
    procedure EFileerrorsCurrentReturn1Click(Sender: TObject);
    procedure MultipleDnBtnClick(Sender: TObject);
    procedure MultipleUpBtnClick(Sender: TObject);
    procedure DependBtnClick(Sender: TObject);
    procedure ReviewBtnClick(Sender: TObject);
    procedure ABCBtnClick(Sender: TObject);
    procedure PrintManager1Click(Sender: TObject);
    procedure ClientLetters1Click(Sender: TObject);
    procedure ShowOverridesClick(Sender: TObject);
    procedure SystemInformation1Click(Sender: TObject);
    procedure RebuildtheClientDataBase1Click(Sender: TObject);
    procedure MergeDataBases1Click(Sender: TObject);
    procedure FileViewerEditor1Click(Sender: TObject);
    procedure CurrentPage1Click(Sender: TObject);
    procedure ComparativeSummaryClick(Sender: TObject);
    procedure CplBtnClick(Sender: TObject);
    procedure MinTaxBtnClick(Sender: TObject);
    procedure ClientListings1Click(Sender: TObject);
    procedure RecalcBtnClick(Sender: TObject);
    procedure PreselNextBtnClick(Sender: TObject);
    procedure PreSelPrvBtnClick(Sender: TObject);
    procedure NISAcodes1Click(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure YourLatestReleaseClick(Sender: TObject);
    procedure ZoomBtnPlusClick(Sender: TObject);
    procedure ZoomBtnMinusClick(Sender: TObject);
    procedure AuditOptionClick(Sender: TObject);
    procedure Upgrade1Click(Sender: TObject);
    procedure AuditListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    Procedure ShowMultiOfficeMsg;
    Function  EditBeforeSave(RetNo:Integer):Boolean;
    procedure InternetWebSite1Click(Sender: TObject);
    procedure WWWLblClick(Sender: TObject);
    procedure WorldButtonClick(Sender: TObject);
    procedure AlphabeticalFormsIndex1Click(Sender: TObject);
    procedure Zoomin1Click(Sender: TObject);
    procedure Zoomout1Click(Sender: TObject);
    procedure Toolbandswitch1Click(Sender: TObject);
    procedure Recalc1Click(Sender: TObject);
    procedure ReIndextheClientDataBase1Click(Sender: TObject);
    procedure ExchageRatesAverage1Click(Sender: TObject);
    procedure Checkupdate1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure CheckUpdatesLblClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure ClearCurrentformClick(Sender: TObject);
    procedure ClearCurrentPageClick(Sender: TObject);
//    Function  SelectFromLoadedReturns(RetNo:Integer):Integer;  //20161216 Igor
    Procedure PutFrmDictOnFrmGrid(FrmNm:String;FileFound:Boolean);
    procedure CharityOrganizations1Click(Sender: TObject);
    procedure SuperEntry1Click(Sender: TObject);
    procedure Employers1Click(Sender: TObject);
    procedure DoctorsHospitalsPharmacies1Click(Sender: TObject);
    procedure MedicalExpenseDescriptions1Click(Sender: TObject);
    procedure FirstNames1Click(Sender: TObject);
    procedure Cities1Click(Sender: TObject);
    Procedure PutLastYearValueOnFrmGrid(Frmnm:String;FileFound:Boolean;LnNo:Integer;Description:String;Value:String);
    procedure T1GuideCCRA1Click(Sender: TObject);
    procedure OpenPreviousYearsT11Click(Sender: TObject);
    procedure CompanyLogo1Click(Sender: TObject);
    procedure ImportConfiguration1Click(Sender: TObject);
    procedure ExportConfiguration1Click(Sender: TObject);
    procedure Findaline1Click(Sender: TObject);
    procedure LinesBtnClick(Sender: TObject);
    procedure UsefulLinksClick(Sender: TObject);
    procedure SetReturnPassword1Click(Sender: TObject);
    procedure RemoveReturnPassword1Click(Sender: TObject);
    procedure PrintAuditBtnClick(Sender: TObject);
    procedure PrintAuditWizardDiagnostics1Click(Sender: TObject);
    procedure EmailCurrentFormClick(Sender: TObject);
    procedure SaveALLopenedreturns1Click(Sender: TObject);
    procedure SaveandCloseAllopenedreturns1Click(Sender: TObject);
    procedure FormsBlackBoxBtnClick(Sender: TObject);
    procedure Provincialnews1Click(Sender: TObject);
    Function  CountFiles(Dir:String;FileExt:String):Integer;
    procedure CICALineByLineInternethelpNONResidents1Click(
      Sender: TObject);
    procedure OtherGuides1Click(Sender: TObject);
    procedure CCArates1Click(Sender: TObject);
    procedure Checkupdates1Click(Sender: TObject);
    procedure Frequentlyaskedquestions1Click(Sender: TObject);
    procedure VisualTaxForum1Click(Sender: TObject);
    procedure HowoftentocheckInternetUpdates1Click(Sender: TObject);
    procedure CICA1Click(Sender: TObject);
    procedure CICAHelpbyline1Click(Sender: TObject);
    procedure CICAReferencematerials1Click(Sender: TObject);
    procedure TrEngineLoadClick(Sender: TObject);
    procedure ListMultipleBtnClick(Sender: TObject);
    procedure TrGuide1Click(Sender: TObject);
    procedure DefinetheTRfolder1Click(Sender: TObject);
    procedure CloseallreturnsWITHOUTSaving1Click(Sender: TObject);
    procedure NewReturnLblClick(Sender: TObject);
    procedure OpenReturnLblClick(Sender: TObject);
    procedure WhatsNewLblClick(Sender: TObject);
    procedure FaQLblClick(Sender: TObject);
    procedure HelpLblClick(Sender: TObject);
    procedure ForumLblClick(Sender: TObject);
    procedure TRLblClick(Sender: TObject);
    procedure Lockreturnagaistchanges1Click(Sender: TObject);
    procedure UnlockReturn1Click(Sender: TObject);
    procedure Options2Click(Sender: TObject);
    procedure QuestionMarkLblMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LicLevel1Click(Sender: TObject);
    procedure PrepareDistr1Click(Sender: TObject);
    procedure EkUDFList1Functions0Calculate(Sender: TObject;Args: TEkUDFArgs; ArgCount: Integer;
              UDFResult: TObject);
    procedure EmailTheReturnClick(Sender: TObject);
    procedure HelpIndexBtnClick(Sender: TObject);
    procedure Backupthetaxdata1Click(Sender: TObject);
    procedure Restoredatafrombackup1Click(Sender: TObject);
    procedure ShowBarCodedata1Click(Sender: TObject);
    procedure StatusBarBtnClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure NewBtnToolBarClick(Sender: TObject);
    procedure OpenBtnToolBarClick(Sender: TObject);
    procedure CloseBtnToolBarClick(Sender: TObject);
    procedure SaveBtnToolBarClick(Sender: TObject);
    procedure ClientPreparerCopy1Click(Sender: TObject);
    procedure T2BtnClick(Sender: TObject);
    procedure OntBtnClick(Sender: TObject);
    procedure AlbBtnClick(Sender: TObject);
    procedure GifiIsBtnClick(Sender: TObject);
    procedure FNotesBtnClick(Sender: TObject);
    procedure FilingcopyAlbertaRSI1Click(Sender: TObject);
    procedure ClientPreparercopy2Click(Sender: TObject);
    procedure T183CORPInformationonEFiling1Click(Sender: TObject);
    procedure BuildandTransmit1Click(Sender: TObject);
    procedure SetupEOLInternetFiling1Click(Sender: TObject);
    procedure EfileSetup1Click(Sender: TObject);
    procedure SwapBtnClick(Sender: TObject);
    procedure EFileBtnClick(Sender: TObject);
    procedure RolloverVisualTax1Click(Sender: TObject);
    procedure RolloverCanTax1Click(Sender: TObject);
    procedure RolloverProfile1Click(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure RollOvrerLblClick(Sender: TObject);
    procedure GIFIBSFullChartofAccountsreference1Click(Sender: TObject);
    procedure GIFIBSFullChartofAccountsreference2Click(Sender: TObject);
    procedure Builda5yearcomarativesummary1Click(Sender: TObject);
    procedure GIFIGuide1Click(Sender: TObject);
    procedure AlbertaAT1GuidePart11Click(Sender: TObject);
    procedure CT23Guide1Click(Sender: TObject);
    procedure FindKeyWordintheform1Click(Sender: TObject);
    procedure ResourceTaxation1Click(Sender: TObject);
    procedure ProvincialRates1Click(Sender: TObject);
    procedure AlbertaTaxGuidePart21Click(Sender: TObject);
    procedure YSumBtnClick(Sender: TObject);
    procedure QuickStarterGuide1Click(Sender: TObject);
    procedure PrintMailingLabelcurrentclient1Click(Sender: TObject);
    procedure QuickStartLblClick(Sender: TObject);
    procedure Barcodeprinting1Click(Sender: TObject);
    procedure SignOffWarnings1Click(Sender: TObject);
    procedure DividendTaxation1Click(Sender: TObject);
    procedure Special1Click(Sender: TObject);
    procedure ShortDateFormat1Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure SEQGIFIIS1Click(Sender: TObject);
    procedure SEQGIFIBS1Click(Sender: TObject);
    procedure vtScan1Click(Sender: TObject);
    procedure ReviewFilesinCLIENTDOCS1Click(Sender: TObject);
    procedure SavereturninPDFFormatinClientDocs1Click(Sender: TObject);
    procedure FileNewItem_Click(Sender: TObject);
    procedure AuditOpenBtnClick(Sender: TObject);
    procedure TutorialsLblClick(Sender: TObject);
    procedure OpenItBtnClick(Sender: TObject);
    procedure EMailItBtnClick(Sender: TObject);
    procedure mnSelAppClick(Sender: TObject);
    procedure TestFrm1Click(Sender: TObject);
    procedure TileVertical1Click(Sender: TObject);
    procedure TileHorizontally1Click(Sender: TObject);
    procedure TUTORIALS1Click(Sender: TObject);
    procedure TileReturnsVertically1Click(Sender: TObject);
    procedure TileReturnsHorizontally1Click(Sender: TObject);
    procedure TRTaxResearch1Click(Sender: TObject);
    procedure Notepad1Click(Sender: TObject);
    procedure Notepadwithamounts1Click(Sender: TObject);
    procedure PrivateNotepad1Click(Sender: TObject);
    procedure AddtoDataDictionaryforclientletters1Click(Sender: TObject);
    procedure SetResetReviewMark1Click(Sender: TObject);
    procedure AttachNote1Click(Sender: TObject);
    procedure AttachAddingTape1Click(Sender: TObject);
    procedure Help4Click(Sender: TObject);
    procedure CICAWebbasedsubscriptionrequired1Click(Sender: TObject);
    procedure TRVisualTaxResearchWebbased1Click(Sender: TObject);
    procedure FormSections1Click(Sender: TObject);
    procedure SetResetOverride1Click(Sender: TObject);
    procedure CloseBlackBoxBtnClick(Sender: TObject);
    procedure KnownIssuesLbkClick(Sender: TObject);
    procedure OpenfromCloudDropBox1Click(Sender: TObject);
    procedure GoToaFormSection1Click(Sender: TObject);
    procedure Line1Click(Sender: TObject);
    procedure RestructuretheClientsDataBase1Click(Sender: TObject);
    procedure TestBlBoxClick(Sender: TObject);
    procedure KnownIssues1Click(Sender: TObject);
    procedure T2GuideCRAWebsite1Click(Sender: TObject);
    procedure DeveloperOnly1Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ImportfromProduction1Click(Sender: TObject); //20160305 Igor
    procedure ResetclientDB1Click(Sender: TObject);  //20160305 Igor
    procedure buttonAvailableWidthClick(Sender: TObject); //20160406 Igor
    procedure ConvertDataandOptionstoMultipAppversion1Click(Sender: TObject);
    procedure QuickFindBtnKeyPress(Sender: TObject; var Key: Char); //20160620 Igor
    procedure Resetpasswordwithreturn1Click(Sender: TObject); //20170409 Igor
    procedure FieldPopupPopup(Sender: TObject);
    procedure Hist1Click(Sender: TObject); //20170409 Igor
    procedure RollOverfromTaxCycle1Click(Sender: TObject);
    procedure Owner1Click(Sender: TObject);
    procedure Recovery1Click(Sender: TObject);
    //20170911 Igor>>>
    procedure actFindFormExecute(Sender: TObject);
    procedure edtSearchFormChange(Sender: TObject);
    procedure edtSearchForm3Click(Sender: TObject);
    procedure rbnT2RecentItemClick(Sender: TObject; FileName: string;
      Index: Integer);
    procedure amT2StateChange(Sender: TObject);
    procedure actAttachaDocExecute(Sender: TObject);
    procedure actAutoFillExecute(Sender: TObject);
    procedure actAutoFillGuideExecute(Sender: TObject);//20171124 Igor
    procedure actApplyAFRExecute(Sender: TObject);
    procedure actFileOpenItemExecute(Sender: TObject);
    procedure AutoFill1Click(Sender: TObject);
    procedure actViewCORExecute(Sender: TObject);//20171219 Igor
    procedure actChangeSkinExecute(Sender: TObject); //20180206 Igor
    procedure Buildreport1Click(Sender: TObject);
    procedure RC59EfIle1Click(Sender: TObject);
    procedure T1135Efile1Click(Sender: TObject);
    procedure AutoFill3Click(Sender: TObject);
    procedure T106BtnClick(Sender: TObject);
    procedure T1134BtnClick(Sender: TObject);
    procedure Countrybycountry1Click(Sender: TObject);
    procedure RC59Xcancellation1Click(Sender: TObject); //20180424 Igor
	//20190211 Igor >>>
    procedure btnUploadClick(Sender: TObject);
    procedure btnUploadWithoutOpenClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
	//20190211 Igor >>>
    //20170911 Igor<<<
    //20190228 Igor >>>
    procedure actForCloudExecute(Sender: TObject);
    procedure OpenFromCloudClick(Sender: TObject);
    //20190415 Igor >>>
    procedure MainUIRibbonCommandCreate(const Sender: TUIRibbon;
      const Command: TUICommand);
    procedure SearchFormSelect(const Args: TUICommandCollectionEventArgs);
    procedure Prevalidate1Click(Sender: TObject);
    procedure RequestWACWebAccessCodefromCRA1Click(Sender: TObject);
    procedure Onlinepayment1Click(Sender: TObject);
    //20190415 Igor <<<
    //20191129 Igor >>>
    procedure actCreateClientsFoldersExecute(Sender: TObject);
    procedure actScanExecute(Sender: TObject);
    procedure actCopyClientsFoldersExecute(Sender: TObject);
    //20200116 Igor >>>
    procedure actPrintSequenceExecute(Sender: TObject);
    procedure actPrintCurrentReturnExecute(Sender: TObject);
    procedure EdocServices1Click(Sender: TObject);
    procedure OpenClientDocumentsFolder1Click(Sender: TObject);
    procedure AlertsNotifications1Click(Sender: TObject);
    procedure SavetaxformsinPDFformat1Click(Sender: TObject);
    procedure SBDAllocations1Click(Sender: TObject);
    procedure SalaryDividends1Click(Sender: TObject);
    procedure EnterSpecialFeatureskey1Click(Sender: TObject);
    procedure Action11Click(Sender: TObject);
    procedure FindDuplicates1Click(Sender: TObject);
    procedure AddOnHelpClick(Sender: TObject);
    procedure SERSAttachaDocSpecialEfectionsReturns1Click(Sender: TObject);
    procedure DACRequestfromCRA1Click(Sender: TObject); // 20250729 Igor
    //20200116 Igor <<<
    //20191129 Igor <<<
  private
    FRetNo: integer;
    FormName: string;
    FormNo: integer;
    ToolBarSw: boolean;
    MyForm: TvtScrollBox;
    MyChild: TMyChild;
    FSearchStr: string;
    FSearchForm1, FSearchForm2: TUICommandCollection; //20190415 Igor
    procedure SetSearchStr(const AValue: String);
    procedure SaveReturnToPDF(RetNo: integer; FormsToPrint: TstringList;
      DataDir, FlName: string);  // 20161211 Igor
    //20170911 Igor>>>
    function GetZoomStr: String;
    procedure SetZoomStr(const Value: String);
    //20170911 Igor<<<
    property RetNo: integer read FRetNo;
    function NotEditCommand: boolean;
    procedure ShowReturn(ARetNo: integer); //20190211 Igor
    property MyScrollBox: TvtScrollBox read MyForm;
    procedure OnCreateMenuItem(const aName: string; const aHelperID: Integer);//20190228 Igor
    procedure SetMainMenuTitle; //20191202 Igor
  public
    Function  SaveAllReturns:Boolean;
    Function  DoSaveAllReturns(RNo: integer):Boolean;
    procedure DoFileSaveAs(RetNo: Integer);
    Procedure CloseAllReturns;
    procedure SelectFeatures;
    procedure SetHorScrollBarInListBox(ListBox: TListBox;
      MaxWidth: Integer);
    procedure ShowMostRecentReturns;
    property SearchStr: String read FSearchStr write SetSearchStr;//20170911 Igor
  public //called from main form
    function  CopyAReturnBtnClick(const FromDir, FlName, ACaption: string): boolean;
    function  OpenIt(const Dir,FlName:String): integer;
    procedure EMailIt(const Dir, FlName: string);
    property ZoomStr: String read GetZoomStr write SetZoomStr;//20170911 Igor
    procedure ReloadMainMenu; //20190228 Igor
  end;

function FileNew: integer;
Procedure UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);

var
  MainFormT2: TMainFormT2_2027;
  T2Menu: TMainMenu;
  //AQRReport : TQuickRep;

implementation

{$R *.DFM}

uses
  vtMain,vtForm,fProgres,vtCommon,vtDialogs,vtAuthorization,
  T2_2027Declare,T2_2027,
  T2_2027RollOver,T2_2027PrvRate,VtEditBox,vtLabel,vtMemoBox,T2_2027vtScan,
  T2_2027PrintReturnFrm,T2_2027OptionsFrm,T2_2027ImportGpT2,
  T2_2027SpecialGpT2,T2_2027RollCtxT2,T2_2027BuildGpHist,{T2_2027RepFSBS,}
  {T2_2027GifiBSEdit,T2_2027GifiISEdit,}{T2_2027RepBsAccounts,T2_2027RepIsAccounts,} //20150622
  {T2_2027RepFsIs,T2_2027QrFsIs,}T2_2027OpFlNm,T2_2027ClientBook,T2_2027SaveAs,
  T2_2027BackupFrm,T2_2027RestoreFrm,T2_2027Fees,T2_2027Dict,T2_2027SIC,
  T2_2027DFiles,T2_2027Warning,T2_2027CntErr,T2_2027Print,T2_2027DeskTop,
  T2_2027CopyMoveFrm,
  T2_2027SaveAsPdf,  //20200502
  T2_2027SearchList,T2_2027Users,
  T2_2027CopyFrm,T2_2027FileVu,T2_2027FSum,T2_2027DBRestr,T2_2027FRMType,
  T2_2027ABList,T2_2027PrSet,T2_2027Rebuild,T2_2027Merge,
//T2_2027RichForm,
  T2_2027ReindexDb,T2_2027TaxByte,T2_2027HtmlEOL,
//T2_2027FormsExplorer,
  T2_2027Features,T2_2027FtpFrm,T2_2027SuperEntry,T2_2027ImportConfig,
  T2_2027ExportConfig,T2_2027FindALine,T2_2027EOLSetup,T2_2027PdfFrm,
  //T2_2027ExportConfig,T2_2027FindALine,T2_2027EOLSetup,T2_2027PdfFrm,
  T2_2027SetFilePsw,T2_2027UpdateSchedule,T2_2027DataDictFrm,
  T2_2027BarDataGen,
  T2_2027T106Efile,   //20170627
  T2_2027ARsiFrm,
//T2_2027RsiFrm,
  T2_2027calc,T2_2027Common,T2_2027Common2,
  T2_2027TrimStr,T2_2027ChildWinNew,T2_2027HeaderFrame,T2_2027Trnsmtr,
  T2_2027ReportMenu,
  vtTrimStr,vtShared, vtDataModuleUnit,
  vtDataBase, uADCompClient, // 20150922 Igor
  T2_2027ImportDbfData, //20160305 Igor
  fConvertToMultiApp, //20160630 Igor
  vtPDFPrinter, //20161211 Igor
  vtControlIntf, //20170409 Igor
  T2_2027PrevalidateEfile, //20190521
  T2_2027WACRequestEfile, //20190521
  T2_2027AttachADoc, //20171107 Igor
  T2_2027AFR, //20171124 Igor
  T2_2027AutoFillFrm,//20171124 Igor
  T2_2027FRRMS, //20191129 Igor
  T2_2027PrintSeqFrm, //20200116 Igor
  TaxCycleUtil, //20170712 Igor
  vtReportBuilder, //20180424 Igor
  vtChooseFileForm, //20190211 Igor
  fSelectCloudFile, //20201015 Igor
  T2_2027DACRequestEfile, // 20250729 Igor
  fCaseDo; //20180206 Igor

procedure TMainFormT2_2027.FormCreate(Sender: TObject);
Var i:Integer;TempList:TStringList;
begin
 //20190415 Igor >>>
 MainUIRibbon.ResourceInstance := LoadLibraryEx('T2_UIRibbonUnit.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
 if (MainUIRibbon.ResourceInstance = 0) then
  MainUIRibbon.ResourceName := '';
 //20190415 Igor <<<
 //ShowMessage('This program contains the UN-CERTIFIED version of the OCT 31 T2 VT35 version');  //20170520

 FiscalPeriodslbl.Caption:='Periods Supported: '+MinStartPeriod+' - '+MaxEndPeriod; //20181213
 AppLabel.Caption:=AppName+'-'+AppYear;
 AppLabel3.Caption:=AppName+'-'+AppYear;
 AppUpdateDate2.Caption:= 'As of: '+AppUpdateDate;
  T2Menu := Menu;
  Menu := nil; //to be shown in Main
  InitColorPanel;
  ReloadMainMenu; //20190228 Igor
  ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
  ConvertMostRecentFiles; //20201015 Igor
  If FileExists(AppDir+'\'+RecentFlName) = False then
   InitMostRecentFiles(30); //put them in RecentFlName
  ShowMostRecentReturns;
  //20190211 Igor >>>
  if CheckIsCloud(true) then
  begin
    OpenbyFileName1.Caption := 'Open by &File Name ...';
    btnUpload.Visible := true;
    btnDownload.Visible := true;
    btnUploadWithoutOpen.Visible := true;
    ListView1.CheckBoxes := true;
    btnDownloadAll.Visible := true;
  end
  else
  begin
    btnUpload.Visible := false;
    btnDownload.Visible := false;
    btnUploadWithoutOpen.Visible := false;
    ListView1.CheckBoxes := false;
    btnDownloadAll.Visible := false;
  end;
  //20190211 Igor <<<
end;


Function TMainFormT2_2027.ButtonInactive:Boolean;
begin
  FRetNo := GetCurrentRetNo;
  if RetNo < 1 then
  Begin
  Result := True;
  ShowMessage('You must open a return first');
  end
 Else if Ret[RetNo] = nil then begin
  Result := True; //wrong return type!
  MyChild := nil;
 end else
 begin
  Result := false;
  MyChild := RetList[RetNo].MyChild;
  if MyChild <> nil then
    MyForm := MyChild.ActiveForm
  else
    MyForm := nil;
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

procedure TMainFormT2_2027.FileNewItem_Click(Sender: TObject);
begin
  if AllTrim(OptRec.Prp_Name)='' then //20200629
  Begin
   ShowMessage('Please click Menu item Configure -> General Options'
   +Chr(13)+'and Complete FULLY the Preparer information');
   Exit;
  End;

  if IsAuthorizedPreparer=False then Exit; //20200615
  FRetNo := FileNew;
end;

function FileNew: integer;
Var
  RetNo: integer absolute Result;
  FormNo:Integer;
  FormName: string;
begin
  Result := iorReported;
  //20170901 Igor>>>
 If AppT2.ExceedsMaxReturnsAllowed(True) then
  begin
//   ShowMessage('Number of returns exceeds maximum allowed '
//   +'('+IntToStr(LimitedVersionReturns)+')'+
//   Chr(13)+' in the Limited version of the program');
   Exit;
  end;
  //20170901 Igor<<<

    RetNo:=CreateNewReturn;
    if RetNo < 1 then begin ShowOpenReturnFailure(RetNo, '', ''); exit; end;
   //If RetNo > 0 then
   begin
    //If (ServerMode=False) then
    begin
     //LockWindowUpdate(Handle);
     //MainForm.LeftPanel.Visible:=True;
     FormName := 'T2';
     FormNo := GetFormNo(FormName);
     InitFormData(RetNo,FormNo);
     CountDiagnostics(RetNo);
     MainForm.ReduceTutorialHeight(Application);
     OpenForm(RetNo,FormNo,0); //new child
     MainForm.GuiCommand(gcShowLeftPanel); //20160222 Igor
     MainForm.UsedFormsBox.Checked:=False;
     UpdateAllDataIndicators(RetNo);
    end;
   end;
   MainForm.FormPaint(nil);
   //MainForm.LeftPanel.Visible:=True;
   MainForm.GuiCommand(gcShowLeftPanel);
end;

//20171206 Igor>>
{procedure TMainFormT2_2027.FileOpenItemClick(Sender: TObject);
begin
  if ExecuteForm(TClientBookT2_2027) = mrOk then //20160612 Igor
    MainForm.GuiCommand(gcHideFlash);
  Done;
  //MainForm.GuiCommand(gcHideFlash); //not always hidden???
end;}
//20171206 Igor<<

procedure TMainFormT2_2027.FileSaveItemClick(Sender: TObject);
begin
If ButtonInactive then exit;
FileSaveAsItemClick(Sender);
end;

procedure TMainFormT2_2027.FileSaveAsItemClick(Sender: TObject);
Var RetNo:Integer;
begin
 If ButtonInactive then exit;
 RetNo:=GetCurrentRetNo;
 DoFileSaveAs(RetNo);
end;

procedure TMainFormT2_2027.DoFileSaveAs(RetNo:Integer);
begin
 RecalcBtnClick(nil);  //20090711
 If EditBeforeSave(RetNo) = false then
 begin
   If not MainForm.WizardPanel.Visible then MainForm.AuditOpenBtnClick(Application);
   ShowMessage('Please enter Mandatory data before saving');
   exit;
 end;
 if //RetList[RetNo].IsLastYearReturn or //20160331 Igor //20160623 Igor
    RetList[RetNo].isAppendix then     //20160331 Igor
 begin
   exit;
 end;

 //T4Sum(RetNo,'T4SUM',GetFormno('T4SUM'));
 ExecuteForm(TSaveAsT2_2027);
end;

procedure TMainFormT2_2027.FieldPopupPopup(Sender: TObject); //20170409 Igor
var
  Obj: IvtPopupedControl;
  PM: TPopupMenu;
  AdditionalMenuItems: TAdditionalMenuItems;
  I: Integer;
  MI: TMenuItem;
begin
  if not (Sender is TPopupMenu) then
    exit;
  PM := (Sender as TPopupMenu);
  for I := PM.Items.Count - 1 downto 0 do
    if PM.Items[I].Tag = C_VtControlsMenuTag then
      PM.Items[I].Free;
  if (Sender as TPopupMenu).PopupComponent.GetInterface(IvtPopupedControl, Obj) then
  begin
    AdditionalMenuItems := Obj.AdditionalMenuItems;
    if length(AdditionalMenuItems) > 0 then
    Begin
      MI := TMenuItem.Create(PM);
      MI.Caption := cLineCaption;
      MI.Tag := C_VtControlsMenuTag;
      PM.Items.Add(MI);
      PM.Items.Add(AdditionalMenuItems);
    End;
  end;
end;

procedure TMainFormT2_2027.FileCloseItemClick(Sender: TObject);
//Var i:Integer;FHandle:THandle;Action:TCloseAction;RetNo:Integer;
Begin
 If ButtonInactive then exit; //? close always?
  RetList[RetNo].Close(True);
 //MainForm.FormPaint(Sender);
end;

Function TMainFormT2_2027.EditBeforeSave(RetNo:Integer):Boolean;
begin
 CountDiagnostics(RetNo);
 Result := Ret[RetNo].MandatoryErrorCount = 0;
end;

procedure TMainFormT2_2027.EdocServices1Click(Sender: TObject);
begin
  if ButtonInactive then Exit;
  //If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit; //20211210
  RunFRRMS(FormName);
end;

procedure TMainFormT2_2027.edtSearchForm3Click(Sender: TObject);//20170911 Igor
begin
//Dummy
end;

procedure TMainFormT2_2027.edtSearchFormChange(Sender: TObject);
begin
SearchStr := (Sender as TEdit).Text;
end;

procedure TMainFormT2_2027.ShowWarnings;
begin
    ExecuteForm(TWarningT2_2027);
end;

procedure TMainFormT2_2027.FileExitItemClick(Sender: TObject);
begin
  MainForm.FileExitItemClick(Sender);
end;

procedure TMainFormT2_2027.ConvertDataandOptionstoMultipAppversion1Click(
  Sender: TObject); //20160617 Igor
begin
  ConvertToMultiApp(AppT2, true);
end;

function TMainFormT2_2027.ConvertFormOrText(FileToConvertFrom:string;ConversionType:TDFMorTXT):Boolean;
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

//init streams
  InputStream  := nil;
  OutputStream := nil;
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


procedure TMainFormT2_2027.CutItemClick(Sender: TObject);
begin
  {cut selection to clipboard}
end;


procedure TMainFormT2_2027.FormDestroy(Sender: TObject);
begin
  //Screen.OnActiveFormChange := nil;
end;

procedure TMainFormT2_2027.RestoreReturnClick(Sender: TObject);
var
i: Integer;
WinList : TStringList;
CurHandle : Thandle;
begin
end;

procedure TMainFormT2_2027.RestoreAllClick(Sender: TObject);
var
i : Integer;
CurHandle : Thandle;
begin
end;


procedure TMainFormT2_2027.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 {}
end;

procedure TMainFormT2_2027.SelectFormClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 UpdateAllDataIndicators(GetCurrentRetNo);
 ExecuteForm(TFrmtypesT2_2027);
end;


procedure TMainFormT2_2027.ListBunchOfForms(TypeOfForm:string;ListCaption:String);
Var I: integer;RetNo:Integer;
  FName: string;
begin
 If RetInMem < 1 then exit;
 RetNo:=GetCurrentRetNo;
 SomeList.Clear;  // := TStringList.Create;
 SomeList.Sorted := True;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormShow) and (Frec.FormType = TypeOfForm) then
       SomeList.Add(Frec.FormAbrev); {FormRlNm); }
 end;
  SelectedString := PopSomeList(SomeList,ListCaption);
 //SomeList.Free; //20160704 Igor
 If SelectedString > '' then
 begin
   FName := Rtrim(GetFName(SelectedString));  {using Real Name}
   OpenForm(RetNo,GetFormNo(FName),0);
 end;
end;



procedure TMainFormT2_2027.PrinterSetupClick(Sender: TObject);
begin
  if CheckIsCloud then Exit; //20180503 Igor
  PrintDialogItem.Execute;
end;

procedure TMainFormT2_2027.NewBtnClick(Sender: TObject);
begin
  FileNewItem_Click(Sender);
end;



procedure TMainFormT2_2027.PrintRBtnClick(Sender: TObject);
Var I : integer;
begin
  {If RetNo < 1 then exit;}
  If ButtonInactive then exit;
  SomeList.Clear; // := TStringList.Create;
  SomeList.Add('Current Page');
  SomeList.Add('Current Form');
  SomeList.Add('Current Return');
  SelectedString := PopSomeList(SomeList,'Print');
  //SomeList.Free; //20160704 Igor
  If SelectedString = '' then exit;
  {PrintDialogItem.Options := [poWarning];}
  If SelectedString = 'Current Page' then CurrentPage1Click(Sender)
  else If SelectedString = 'Current Form' then PrintForm1Click(Sender);
  //else if SelectedString = 'Current Return' then PrintCurrentReturn1Click(Sender);
end;


procedure TMainFormT2_2027.StatusBarBtnClick(Sender: TObject);
begin
EXIT;
end;

procedure TMainFormT2_2027.ToolBarBtnClick(Sender: TObject);
begin

 ToolBarSw := not ToolBarSw;
  If ToolBarSw then begin ToolBarBtn.Glyph.LoadFromFile(AppDir+'\'+'SwitchOn.BMP');
                    ToolBarSw := True; ToolBar.Height := 75;end
  else
   begin
   ToolBarBtn.Glyph.LoadFromFile(AppDir+'\'+'SwitchOf.BMP');
   //ToolBarSw := false;
   ToolBar.Height :=(ToolBar.Height div 2)+3+5; //(ToolBar.Height div 2)+3+1;
   end;

end;

procedure TMainFormT2_2027.AboutItemClick(Sender: TObject);
begin
  ShowAbout;
end;
//20171206 Igor>>
procedure TMainFormT2_2027.actFileOpenItemExecute(Sender: TObject);
begin
  if ExecuteForm(TClientBookT2_2027) = mrOk then //20160612 Igor
    MainForm.GuiCommand(gcHideFlash);
  Done;
end;
//20171206 Igor<<
procedure TMainFormT2_2027.actFindFormExecute(Sender: TObject);
begin
  If ButtonInactive then exit;
  If Trim(SearchStr) = '' then exit;
  QuickFormFind(RetNo, SearchStr);
end;

procedure TMainFormT2_2027.actForCloudExecute(Sender: TObject);
begin
  OpenFromCloudClick(Sender);
end;

procedure TMainFormT2_2027.Action11Click(Sender: TObject);
Var flname:String;
begin
FlName:='';
FindDuplicates(FlName);
end;

procedure TMainFormT2_2027.actPrintCurrentReturnExecute(Sender: TObject); //20200116 Igor
Var i,j: integer; FormsToPrint :TstringList;
    Copies, Template :string; //[30];
    s:String;
begin
 If ButtonInactive then exit;
 If Ret[RetNo].IsLastYearReturn then Exit;
 if IsAuthorizedPreparer=False then Exit; 

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

 PrintReturnFrm(RetNo);
 {Application.CreateForm(TPrintReturnFrmT2_2027,PrintReturnFrm);
 PrintReturnFrm.ShowModal;
 PrintReturnFrm.Free;}

end;

procedure TMainFormT2_2027.actPrintSequenceExecute(Sender: TObject); //20200116 Igor
begin
 Application.CreateForm(TPrintSeqFrmT2_2027,PrintSeqFrm);
 PrintSeqFrm.Visible:=False;
 PrintSeqFrm.ShowModal;
 PrintSeqFrm.Visible:=True;
 PrintSeqFrm.Free;
end;

//20191129 Igor >>>
procedure TMainFormT2_2027.actScanExecute(Sender: TObject);
begin
 If ButtonInactive then exit;
 GetScanLicenseLevel;
 If AppT2.ScanLicenseLevel=llNone then exit;
 ExecuteForm(TVtScanT2_2027);
end;
//20191129 Igor <<<

procedure TMainFormT2_2027.actViewCORExecute(Sender: TObject);//20171219 Igor
Var FileDir,flName,TempFlName:String;TempList:TstringList;
begin

  if FileExists(ChangeFileExt(MkTddFileName(GetCurrentRetNo), '-COR.txt')) then
  Begin    //20180602
    ShellExecute(0, 'open', PWideChar(ChangeFileExt(MkTddFileName(GetCurrentRetNo), '-COR.txt')),
      nil, PWideChar(ExtractFileDir(MkTddFileName(GetCurrentRetNo))), SW_NORMAL)
  End
  else
    ShowMessage('File Not Available');

(*
  FlName:=ChangeFileExt(MkTddFileName(GetCurrentRetNo), '-COR.txt');
  if FileExists(FlName) then
  Begin    //20180602
    TempList.Create;
    TempList.LoadFromFile(FlName);
    Templist.SaveToFile('Temp');
    //ShellExecute(0, 'open', PWideChar(FlName),nil, PWideChar(ExtractFileDir(MkTddFileName(GetCurrentRetNo))), SW_NORMAL)
  End
  else
    ShowMessage('File Not Available');
*)
end;

procedure TMainFormT2_2027.actApplyAFRExecute(Sender: TObject);//20171124 Igor
Var s:String;
begin
  if ButtonInactive then Exit;
  Screen.Cursor := crHourGlass;
  //20180607
  s:=MkTddFileName(GetCurrentRetNo);
  if not FileExists(S) then
  //if not FileExists(MkTddFileName(GetCurrentRetNo)) then
  begin
   case MessageDlg('A file with a response from the CRA was not found: '+S+' Run auto-fill now?',
    //case MessageDlg('A file with a response from the CRA was not found. Run auto-fill now?',
      mtConfirmation, [mbYes, mbCancel], 0) of
      mrYes:
        actAutoFillExecute(actAutoFill);
    end;
    Exit;
  end;
  with TAutoFillFrmT2_2027.Create(Application.MainForm) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TMainFormT2_2027.actAttachaDocExecute(Sender: TObject);
begin
  if IsAuthorizedPreparer = false then Exit; //20190401
  if CheckIsCloud then Exit; //20180503 Igor
  ExecuteForm(TT2_2027AttachADoc);
end;

procedure TMainFormT2_2027.actAutoFillExecute(Sender: TObject);
var
  I: Integer;
begin
  if ButtonInactive then Exit;

  //ShowMessage('Auto-Fill for T2 has not been released yet. Do not submit');
  //AFR(AppT2, Ret[GetCurrentRetNo]);
end;

procedure TMainFormT2_2027.CloseBtnClick(Sender: TObject);
begin
  FileCloseItemClick(Sender);
end;

procedure TMainFormT2_2027.StatusBarClick(Sender: TObject);
begin
 {UpdateTaxPanel;}
end;

procedure TMainFormT2_2027.clr0Click(Sender: TObject);
begin
  If ButtonInactive then exit;
  MainForm.clrClick(RetNo, Sender, c_ReturnColorElm); //20170219 Igor
end;

procedure TMainFormT2_2027.ClrCustomClick(Sender: TObject);
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

Procedure TMainFormT2_2027.InitColorPanel;
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

procedure TMainFormT2_2027.OpenbyFileName1Click(Sender: TObject);  //20130201
var
  i:integer;
  FullFlName:String;s:String;Dir,FlName:String; //20190211 Igor
begin
  //20190211 Igor >>>
  //if CheckIsCloud then Exit; //20180503 Igor
  if CheckIsCloud(true) then
  begin
    Dir := OptRec.Dir_Cur;
    FlName := '';
    if not ChooseFile(Dir, FlName) then Exit;
    FRetNo := OpenReturn(Dir,FlName, True);
    ShowReturn(FRetNo);
    Done;
    Exit;
  end;
  //20190211 Igor <<<

  //ShowUnprocessedEfiles;
 OpenDialog.InitialDir:= OptRec.Dir_Cur;
 OpenDialog.Options := OpenDialog.Options + [Vcl.Dialogs.ofAllowMultiSelect]; //jz 20241123 allow multi selection

 If OpenDialog.Execute then
 begin

   for i := 0 to OpenDialog.Files.Count - 1 do //jz 20241123 allow multi selection
   begin

     //FullFlName :=OpenDialog.FileName;
     FullFlName :=OpenDialog.Files[i];  //jz 20241123 allow multi selection

     FlName:=ExtractFileName(FullFlName);
  //   If IsOkToOpenReturn(ExtractFileDir(FullFlName),FlName) = False then Exit; //20121220 //20160522 Igor
     FRetNo := OpenReturn(ExtractFileDir(FullFlName),FlName,True);
     if RetNo > 0 then
     begin
      //LockWindowUpdate(Handle);
      CountDiagnostics(RetNo);
      If OptRec.ShowUsedForms then  Visible:=False;
      FormName := 'T2';
      FormNo := GetFormNo(FormName);
      //20170511 Igor >>>
      vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
      try
      //20170511 Igor <<<
        OpenForm(RetNo,FormNo,0);
        OpenUsedForms(RetNo);
        MainForm.FormPaint(Application);
        //Visible:=True;
        //MainForm.LeftPanel.Visible:=True;
         MainForm.GuiCommand(gcShowLeftPanel);
         MainForm.RefreshAuditPanel(RetNo); //If AuditPanel.Visible then RefreshAuditPanel;
         //If MainForm.FormsPanel.Visible then
         MainForm.RefreshFormsPanel(RetNo);
      //20170511 Igor >>>
      finally
        vtChild.CreateNewMDIChild(RetNo, '').ShowAllControls;
      end;
      //20170511 Igor <<<
     end;

   end; //end for OpenDialog1.Files.Count

 end; //end OpenDialog.Execute
end;

procedure TMainFormT2_2027.OpenClientDocumentsFolder1Click(Sender: TObject);   //20200325
Var FullFlName,FlName:String;h:Word;PgmPath:String;PgmFile:String;
begin
{
 //20100202
 OpenDialog.InitialDir:=optRec.Dir_ClientDocs+'\'+MkDirforClientDocs(RetNo);
 //20160526  some comments removed  from here
 If OpenDialog.Execute then
 begin
  FullFlName :=OpenDialog.FileName;
  PgmPath:=ExtractFileDir(FullFlName);
  PgmFile:=ExtractFileName(FullFlName);
  OpenAnyFile(PgmPath,PgmFile);
 end;
 }
 actCopyClientsFolders.Execute;   //20200325
 //actCopyClientsFoldersExecute(Sender);  //20200325
end;

procedure TMainFormT2_2027.OpenFromCloudClick(Sender: TObject); //20190228 Igor
var
  CloudPath, CloudFile, ClientID, Token: String;
  mi: TMenuItemEx;
  hconf: THelperAppUserConfig;
  isSuccess: boolean;

  function SelectfromList(aCloudID: integer): Boolean;
  var
    i: Integer;
    fileList: TStringList;
    afileList: TCloudFileList;
  begin
    FileList := TStringList.Create;
    afileList := TCloudFileList.Create();
    try
      if not HelperManager.List(aCloudID, CloudPath, ClientID, Token, FileList) then
        exit(false);
      SomeList.Clear;
      SomeList.Sorted := False;
      SomeCaption := 'Select file';
      for i :=0 to (FileList.Count - 1) do
      begin
        if not FileList[i].IsEmpty then
          If FileList[i][1] <> '*' then
            SomeList.Add(FileList[I]);
      end;

      if not HelperManager.ListReceived(aCloudID, ClientID, Token, afileList) then
        exit(false);
      for i :=0 to (aFileList.Count - 1) do
      begin
        if not aFileList[i].Path.IsEmpty then
          If aFileList[i].Path[1] <> '*' then
            SomeList.AddObject('*' + aFileList[I].Path, TObject(i + 1));
      end;
      CloudFile := SelectCloudFile(SomeList, AppName+ '-' + Copy(AppYear, 3, 2)); //20201015 Igor
      result := CloudFile <> '';
      if Result and Assigned(PopListObject) then
        CloudPath := aFileList[Integer(PopListObject) - 1].Url;
      if hconf.SaveToken and (hconf.Token <> Token) then
        hconf.Token := Token;
    finally
      FileList.Free;
      afileList.Free;
    end;
  end;
  procedure LoadFromCloud(aCloudID: integer);
  var FRetNo: integer;
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
      FRetNo := OpenReturn(OptRec.Dir_Cur, CloudFile, True);
      ShowReturn(FRetNo);
      Done;
    end;
    end;
begin
  if Sender is TMenuItemEx then
  begin
    mi := (Sender as TMenuItemEx);
    hconf := HelperManager.Config(mi.HelperID, AppT2.AppId, User.UserName);
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
    hconf := HelperManager.Config((Sender as TAction).Tag, AppT2.AppId, User.UserName);
    CloudFile := '';
    ClientID := HelperManager.Config((Sender as TAction).Tag).ClientID;
    CloudPath := hconf.Path;
    Token := hconf.Token;
    LoadFromCloud((Sender as TAction).Tag);
  end;
end;

procedure TMainFormT2_2027.Calendar1Click(Sender: TObject);
begin
  GetCalendar;
end;

procedure TMainFormT2_2027.ClientLetter1Click(Sender: TObject);
begin
  ShowLetterEditor(RetNo);
end;

procedure TMainFormT2_2027.PrintForm1Click(Sender: TObject);
Var i:integer;
 //20180503 Igor >>>
    PDF: TvtPDFPrinter;
    PDFFullfileName: string;
  //20180503 Igor <<<

begin
 If ButtonInactive then exit;
 FastPrint := GetFastPrintIndicator; //False; //20160901 Igor
 RecalcBtnClick(Sender);  //20090711
 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  If not MainForm.WizardPanel.visible then MainForm.AuditOpenBtnClick(Application);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Not AllowedToFormPrint(RetNo) then exit;
 
//LetterType := 'Cover';
  //20180503 Igor >>>
  if CheckIsCloud(true) then
  begin
    PDFFullfileName := TPath.Combine(AppDir, 'tmp' + TPath.DirectorySeparatorChar + TPath.GetGUIDFileName + '.pdf');
    if not ForceDirectories(ExtractFileDir(PDFFullfileName)) then
    begin
      MessageDlg('Can not create temp folder', mtError, [mbOk], 0);
      Exit;
    end;
    PDF := TvtPDFPrinter.Create(AppT2);
    try
      PDF.PrintForm(RetNo, FormName, 99, T2_2027Print.AfterReadComponentForPrint,
          T2_2027Print.PrintEditBox, T2_2027Print.PrepareRichEdit,
          T2_2027Print.PrintImageT2, T2_2027Print.PrintHeader);

      PDF.SaveToFile(PDFFullfileName, false);
      OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
    finally
      PDF.free;
    end;
  end
  else
  begin
   If PrintDialogItem.Execute then
   begin
     StartPrintForm(Retno,FormName,99);
     if Printer.Printing then //20160905 Igor
       Printer.EndDoc;        //20160905 Igor
   end;
  end;
  //20180503 Igor <<<
end;

procedure TMainFormT2_2027.StartPrintForm(Retno:integer;FormName:String;WhichPage:integer);
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
         begin Printer.Abort; {Printer.EndDoc;}exit;end; //20160910 Igor
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
     Calc(RetNo,FormName)
    else
     CalcMultiPageForm(RetNo,FormName);

    PrintForm(RetNo,FormName,WhichPage,'');
//    if Printer.Printing then //20160901 Igor //20160905 Igor
//      Printer.EndDoc;        //20160901 Igor //20160905 Igor
 Progress.Close;
end;

procedure TMainFormT2_2027.PrintFBtnClick(Sender: TObject);
begin
PrintForm1Click(Sender);
{If RetNo>0 then PrintForm(RetNo,FormName);}
end;



procedure TMainFormT2_2027.CreateDataDirectory1Click(Sender: TObject);
var s:sTring; //DataDir : string; //[60];Result : integer;ClickedOK: Boolean;
begin
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



procedure TMainFormT2_2027.PrintTemplates1Click(Sender: TObject);
begin
  ExecuteForm(TPrSetT2_2027);
end;

procedure TMainFormT2_2027.FeeSchedule1Click(Sender: TObject);
begin
 If LicenseLevel in anyMulti then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;
 If RetInMem>0 then
  begin ShowMessage('Close all returns first');exit;end;
 ExecuteForm(TFeesT2_2027);
end;

procedure TMainFormT2_2027.RemovecurrentreturnOverridesClick(Sender: TObject);
Var I,FNo:integer;
begin
  if ButtonInactive then exit;
  RemoveReturnOverrides(RetNo);
end;



procedure TMainFormT2_2027.CouplBtnClick(Sender: TObject);
begin
//SetCurrentFieldOverrideClick(Sender);
end;

procedure TMainFormT2_2027.OverrideBtnClick(Sender: TObject);
begin

{ShowOverridesClick(Sender);}
{SetCurrentFieldOverrideClick(Sender);}
end;

procedure TMainFormT2_2027.Owner1Click(Sender: TObject);
begin
 OpenForm(RetNo,'TESTFRM',0);  //20170721
end;

procedure TMainFormT2_2027.DataDictionary1Click(Sender: TObject);
begin
  FixDbForm(AppDir, DictDBLite, DictTableLite, dbtDataDict);
end;



procedure TMainFormT2_2027.AuditOpenBtnClick(Sender:TObject);
begin
  MainForm.AuditOpenBtnClick(Sender);
end;


procedure TMainFormT2_2027.DiagnosticsClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 AuditOpenBtnClick(Sender);
 {If not AuditPanel.Visible then AuditBtnClick(Sender);}
end;

procedure TMainFormT2_2027.SalaryDividends1Click(Sender: TObject);
Var RetNo: Integer;
begin
 if LicenseLevel <> llEnterprise then
 Begin
  ShowMessage('This feature is available only on the Enterprise version of the T2 program.'
  +Chr(13) +'Also, you must have at least the Power version of the T1 program, as they must work together.');
  Exit;
 end;

 // if ValidADDONFeaturesKey=false then Exit; //20231031
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'SALDIVSET',0);
end;


procedure TMainFormT2_2027.EnterSpecialFeatureskey1Click(Sender: TObject);
Var RetNo: Integer; SpecialFeaturesKey:String;List1:TStringList;
EnteredKey,FlName:String;
begin
 (* 20231109
 //20200913
 If ButtonInactive then exit;
 EnteredKey:='';
 FlName:='t2enterprise.html'; //ose 'T2ADDONFEATURES.txt';
 EnteredKey:=UpperCase(InputBox('Enter ADD-ON Schedules and Features Password', '', ''));
 if EnteredKey='' then exit;
 List1:=TStringList.Create;  //20200913
 List1.Add(EnteredKey);
 List1.SaveToFile(Appdir+'\'+FlName);
 List1.Free;
*)
end;



procedure TMainFormT2_2027.SamplesBtnClick(Sender: TObject);
begin
OptRec.Dir_Cur := OptRec.Dir_Sample;
actFileOpenItemExecute(Sender); //20171206 Igor
end;

procedure TMainFormT2_2027.SaveReturnToPDF(RetNo: integer; FormsToPrint: TstringList;
 DataDir: string; FlName: string); //20161211 Igor
var i,j,FCopies:integer; FName :string; //[10];
PDF: TvtPDFPrinter;
begin
   Screen.Cursor := crHourGlass;
   Progress.Show;  {Show progress window}
   AbortSw := False;  {Initialize}
   PauseSw := False;
   Progress.Caption := 'Save PDF progress...';
   Progress.Label1.Caption := 'Save Return:' + IntToStr(RetNo);
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
      Progress.ListBox1.Items.Add(Midstr(FormsToPrint[j],5,10));
     end;
   //If FastPrint = True then Printer.BeginDoc; 20160829 Igor
   PDF := TvtPDFPrinter.Create(AppT2);
   try
     for i :=0 to (FormsToPrint.Count - 1) do
     begin
        Application.ProcessMessages;  {allows abort click on progrees screen }
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
           PDF.PrintForm(RetNo, FName, 99, T2_2027Print.AfterReadComponentForPrint,
              T2_2027Print.PrintEditBox, T2_2027Print.PrepareRichEdit,
              T2_2027Print.PrintImageT2, T2_2027Print.PrintHeader);
         end;
        Progress.Gauge1.Progress :=i+1;
        Progress.Gauge1.Refresh;
     end;
     if FlName <> '' then
      PDF.SaveToFile(FlName, false);
   finally
     PDF.Free;
   end;
   Progress.Close;
   Ret[RetNo].Frm[GetFormNo('STATUS')].Strings[4] := '03';
   Ret[RetNo].PrpStatus :='03';
   UpdatePrintDate(RetNo,DataDir,FlName);
   Screen.Cursor := crDefault;
end;

procedure TMainFormT2_2027.SavetaxformsinPDFformat1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 ExecuteForm(TSaveAsPdfT2_2027);
end;

procedure TMainFormT2_2027.SBDAllocations1Click(Sender: TObject);
Var RetNo:Integer;
begin
 //201200802
 If ButtonInactive then exit;
 if Licenselevel <> llEnterprise then //20231031
 Begin
  ShowMessage('This feature is available only on the Enterprise version of the T2 program');
  Exit;
 End;
 //if ValidADDONFeaturesKey=false then Exit;
 RetNo:=GetCurrentRetNo;
 OpenForm(RetNo,'T2',272);
end;

procedure TMainFormT2_2027.PrintReturn(RetNo:integer;FormsToPrint:TstringList;
 DataDir:string;FlName:string);
var i,j,FCopies:integer; FName :string; //[10];
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
      Progress.ListBox1.Items.Add(Midstr(FormsToPrint[j],5,10));
     end;
   //If FastPrint = True then Printer.BeginDoc; 20160829 Igor
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
         //Printer.EndDoc; //20160910 Igor
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
        PrintForm(RetNo,FName,99,''); //26/11/2012 - change whichpage to 99 so all pages of forms print//PrintForm(RetNo,FName,1,'');
       end;
      Progress.Gauge1.Progress :=i+1;
      Progress.Gauge1.Refresh;
   end;
   If Printer.Printing then Printer.EndDoc; //20160901 Igor
   NeedNewPage := False; //20160829 Igor
   Progress.Close;
   Ret[RetNo].Frm[GetFormNo('STATUS')].Strings[4] := '03';
   Ret[RetNo].PrpStatus :='03';
   UpdatePrintDate(RetNo,DataDir,FlName);
   Screen.Cursor := crDefault;
end;

Procedure UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
var FNo :integer;
(*//20170329 Igor
    TempList :TStringList;
    ADConnection: TADConnection;
    Table1: TADTable;
    *)
begin
 FNo := GetFormNo('STATUS');
 Ret[RetNo].Frm[Fno].Strings[4] := '03';
 Ret[RetNo].Frm[Fno].Strings[8] := User.UserName; //20170112 Igor
 Ret[RetNo].Frm[Fno].Strings[9] := FormatDateTime('yyyy-mm-dd',Date);
 Ret[RetNo].Frm[Fno].Strings[10] := TimeToStr(Time);
 Ret[RetNo].Changed := True; //20170329 igor

{ If FileExists(DataDir+'\'+FlName) then
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
 end;}

 {now update the data base with RTU dates}
 //20150922 Igor
 (*//20170329 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'File_Name');

 //20170223 Igor >>>
 //if Table1.FindKey([FlName]) then
 if Table1.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then
 //20170223 Igor <<<
 begin
  Table1.Edit;
  Table1.FieldByName('Prp_Status').AsString := FetchElm(RetNo,'STATUS',4);
  Table1.FieldByName('Printed_by').AsString := FetchElm(RetNo,'STATUS',8);
  Table1.FieldByName('Printed_dt').AsString := FetchElm(RetNo,'STATUS',9);
  Table1.FieldByName('Printed_tm').AsString := FetchElm(RetNo,'STATUS',10);
  Table1.Post;
 end;
 Table1.Free;
 *)
end;


(*
Procedure UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
var FNo :integer; TempList :TStringList;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
 FNo := GetFormNo('STATUS');
 Ret[RetNo].Frm[Fno].Strings[4] := '03';
 Ret[RetNo].Frm[Fno].Strings[8] := User.UserName; //20170112 Igor
 Ret[RetNo].Frm[Fno].Strings[9] := FormatDateTime('yyyy-mm-dd',Date);
 Ret[RetNo].Frm[Fno].Strings[10] := TimeToStr(Time);

{ If FileExists(DataDir+'\'+FlName) then
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
 end;}

 {now update the data base with RTU dates}
 //20150922 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'File_Name');

 //20170223 Igor >>>
 //if Table1.FindKey([FlName]) then
 if Table1.Locate('FILE_NAME', FlName, [loCaseInsensitive]) then
 //20170223 Igor <<<
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
*)




procedure TMainFormT2_2027.JacketClick(Sender: TObject);
begin
If ButtonInactive then exit;
OpenForm(GetCurrentRetNo,GetFormNo('T2'),0);
end;

procedure TMainFormT2_2027.PersonaldataClick(Sender: TObject);
begin
If ButtonInactive then exit;
OpenForm(GetCurrentRetNo,GetFormNo('T2'),0);
end;

procedure TMainFormT2_2027.TaxSummaryClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 TSumBtnClick(Sender);
 //OpenForm(GetCurrentRetNo,GetFormNo('TAXSUM'),0);
end;

procedure TMainFormT2_2027.FixDataDictionary1Click(Sender: TObject);
begin
  FixDbForm(AppDir, DictDBLite, DictTableLite, dbtDataDict);
end;

procedure TMainFormT2_2027.FixFormSpecifications1Click(Sender: TObject);
begin
  FixDbForm(AppDir, FormsDBLite, FormsTableLite, dbtForms);
  InitFormsTable;
end;

procedure TMainFormT2_2027.FixClientDataBaseData1Click(Sender: TObject);
begin
  FixDbForm(OptRec.Dir_Cur, ClientsDBLite, ClientsTableLite, dbtClients);
end;

procedure TMainFormT2_2027.ShowCellNumbers1Click(Sender: TObject);
begin
  MainForm.ShowCellNumbers1Click(ShowCellNumbers1);
end;

procedure TMainFormT2_2027.Operational1Click(Sender: TObject);
begin
  ExecuteForm(TDeskTopT2_2027);
end;

procedure TMainFormT2_2027.ChangeDataDirectory1Click(Sender: TObject);
begin
 if CheckIsCloud then Exit; //20180503 Igor
 
If LicenseLevel in anyMulti then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;
 ExecuteForm(TOptionsFrmT2_2027);
//DataDirectories1Click(Sender);
end;

procedure TMainFormT2_2027.LoadSpousalReturnfromdatabaseCreate1Click(Sender: TObject);
begin
If ButtonInactive then exit;
end;



procedure TMainFormT2_2027.SwapReturns1Click(Sender: TObject);
Var RetNo,PrevRNo,PrevFNo :integer;
begin
  RetNo:=GetCurrentRetNo;
  If RetInMem(AppT2, True) < 2 then //20161216 Igor //20170307 Igor
  begin
   ShowMessage('To swap, you must have 2 or more returns in memory');
   exit;
  end;
  PrevRNo := RetNo;
  PrevFNo:= FormNo;

  If RetInMem(AppT2, True) = 2 then //20161216 Igor //20170307 Igor
   RetNo:=GetNextReturn(RetNo, True) //20170302 Igor
  else
   RetNo := SelectFromLoadedReturns(RetNo, True); //20170307 Igro
  //LockWindowUpdate(Handle);

  If Ret[Retno].FedCalcStatus = false then CalcFed(retNo);
  If Ret[Retno].OntCalcStatus = false then CalcOnt(RetNo);
  If Ret[Retno].AlbCalcStatus = false then CalcAlb(RetNo);

  OpenForm(RetNo, PrevFNo,0);
  If MainForm.LeftPanel.Visible then MainForm.RefreshAuditPanel(RetNo);
  //LockWindowUpdate(0);
end;

procedure TMainFormT2_2027.Switchforms1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 Switchforms;

end;

procedure TMainFormT2_2027.SwapFrmClick(Sender: TObject);
begin
 Switchforms1Click(Sender);
end;

procedure TMainFormT2_2027.FormsBtnClick(Sender: TObject);
begin
 //LetterType := 'Cover';
 SelectFormClick(Sender);
end;

procedure TMainFormT2_2027.UserSetUp1Click(Sender: TObject);
begin
  ExecuteForm(TUserSetupT2_2027);
end;

procedure TMainFormT2_2027.TipsBtnClick(Sender: TObject);
begin
 QuickStarterGuide1Click(Sender);
end;


procedure TMainFormT2_2027.CopyForm1Click(Sender: TObject);
begin
  If ButtonInactive then exit;
  If RetInMem(AppT2) < 2 then //20170722 Igor
  begin
    ShowMessage('Form Copy allowed only between different returns in memory');
    exit;
  end;
  //20170722 Igor>>>
  T2_2027CopyFrm.CopyFrm(GetCurrentRetNo, FormName);
  //20170722 Igor<<<
end;

procedure TMainFormT2_2027.CopyBtnClick(Sender: TObject);
begin
CopyForm1Click(Sender);
end;

procedure TMainFormT2_2027.SchedBtnClick(Sender: TObject);
Var I:integer;
begin
  If RetNo < 1 then exit;
  SomeList.Clear; // := TStringList.Create;
  for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];
      If Frec.FormType = 'SC' then
      SomeList.Add(Frec.FormInstName);
   end;
  SelectedString := PopSomeList(SomeList,'Schedules');
  SomeList.Clear; //.Free;
  //If SelectedString = '' then exit;

end;

procedure TMainFormT2_2027.FrmSumBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 OpenForm(GetCurrentRetNo,GetFormNo('BSUM'),0);
end;

procedure TMainFormT2_2027.TSumBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 Screen.Cursor:=CrHourGlass;
 //CalcAll(GetCurrentRetNo);
 //RecalcEverything(GetCurrentRetNo);
 CalcFed(RetNo);
 CalcOnt(RetNo);
 CalcAlb(RetNo);
 MainForm.RefreshAuditPanel(RetNo); //20090708
 Screen.Cursor:=CrDefault;
 OpenForm(GetCurrentRetNo,GetFormNo('TAXSUM'),0);
end;

Procedure TMainFormT2_2027.ShowMultiOfficeMsg;
begin
 ShowMessage('This option is available only to firms'+Chr(13)+
   'with Multi-operator and/or Multi-office operations');
end;

procedure TMainFormT2_2027.UserSetUp2Click(Sender: TObject);
begin
If not (LicenseLevel in anyMulti) then
 begin
 ShowMessage('Option availably only in multi-office licenses');
 exit;
 end;
  if not IsAdmin then
  begin
   ShowMessage('Only the Administrator can perform this function');
   exit;
  end;
 ExecuteForm(TUserSetupT2_2027);
end;

procedure TMainFormT2_2027.Calculator1Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(Handle, Nil, 'Calc.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainFormT2_2027.Appointments2Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(Handle, Nil, 'Calendar.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainFormT2_2027.Contents2Click(Sender: TObject);
begin
 // Application.HelpFile := 'T1Help.HLP';
  ShowHelp(AppT2.ModuleHelpFile, 'HELP_CONTENTS', True); //20161220 Igor
end;

procedure TMainFormT2_2027.SearchForHelpOnClick(Sender: TObject);
begin
 //Application.HelpFile := 'T1Help.HLP';
 ShowHelp(AppT2.ModuleHelpFile, 'HELP_CONTENTS', True); //20161220 Igor
end;

procedure TMainFormT2_2027.SearchFormSelect( //20190415 Igor
  const Args: TUICommandCollectionEventArgs);
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

procedure TMainFormT2_2027.VisualTaxGuide1Click(Sender: TObject);
Var s,frmHlpName:String;
begin
  // ConnectToWeb(AppT2.ModuleHelpFile); //20161222 CON
 ConnectToWeb('http://www.visualtax.com/Vt2018HELP/T2Help/Website/index.html');

End;
(*
//20161220 Igor >>>
// ConnectToWeb('www.visualtax.com/Vt2016HELP/T2Help/Website/Index.html');
  if (RetInMem(AppT2) > 0) and
     (RetList[GetCurrentRetNo] <> nil) and
     (RetList[GetCurrentRetNo].MyChild <> nil) and
     (RetList[GetCurrentRetNo].MyChild.ActiveForm <> nil) then
    ShowHelp(AppT2.ModuleHelpFile, StripInstNo(ExtractFormRootName(RetList[GetCurrentRetNo].MyChild.ActiveForm.FormName)), True)
  else
   ConnectToWeb('www.visualtax.com/Vt2016HELP/T2Help/Website/Index.html');  //20161220 con
    //ShowHelp(AppT2.ModuleHelpFile, 'HELP_CONTENTS', True);
//20161220 Igor <<<
end;
*)
{
 //20161219
 FrmHlpName:='';
 If RetInMem>0 then FrmHlpName:=StripInstNo(ExtractFormRootName(FormName));
 if FormName='T2' then FrmHlpName:='PAGE_1.Html';

 s:='www.visualtax.com/Vt2016HELP/T2Help/website/'+FrmHlpName+'.Html';

 If RetInMem>0 then
   ConnectToWeb(S)
 else
  ConnectToWeb('www.visualtax.com/Vt2016HELP/T2Help/Website/Index.html');
 end;
 }

 (*
 If RetInMem>0 then
 begin
  if LeftStr(FormName,5)='T2' then  //20161219
     ShowHelp('T2Help',StripInstNo(FormName))
  else
   ShowHelp('T2Help',StripInstNo(ExtractFormRootName(FormName)));
 end
 else
  ShowHelp('T2Help','HELP_CONTENTS');
end;
*)
procedure TMainFormT2_2027.Allforms1Click(Sender: TObject);
Var I:integer; Psw:String; //20130325
begin
 If ButtonInactive then exit;
 Psw:= InputBox('Input Box', '', ''); If UpperCase(PSW) <> 'DODI1' then exit; //20191026
 ShowFieldIdSw := True;
 If PrintDialogItem.Execute then
 begin
   for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      If Frec.FormNo > 0 then
      begin
      If FRec.FormInst < '#2' then
       {ShowMessage(Frec.FormInstName);}
        PrintForm(RetNo,Frec.FormInstName,99,'');
      end;
    end;
 end;
end;


procedure TMainFormT2_2027.EFileerrorsCurrentReturn1Click(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(RetNo,'STATUS',0);
end;

procedure TMainFormT2_2027.MultipleDnBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenPrevInstance(RetNo, FormName);
end;

procedure TMainFormT2_2027.MultipleUpBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenNextInstance(RetNo, FormName);
end;

procedure TMainFormT2_2027.DependBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(GetCurrentRetNo,'DEPEND',0);
end;

procedure TMainFormT2_2027.ABCBtnClick(Sender: TObject);
begin
 AlphabeticalFormsIndex1Click(Sender);
end;

procedure TMainFormT2_2027.PrintManager1Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(Handle, Nil, 'PrintMan.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainFormT2_2027.ClientLetters1Click(Sender: TObject);
begin
  { Ucletter.PrintLetter(RetNo, Table2.Fields[0].DisplayText);}
end;

procedure TMainFormT2_2027.ShowOverridesClick(Sender: TObject);
 Var I: integer;
begin
 //If RetInMem < 1 then exit;
  if ButtonInactive then exit;
  OverList.EnumRecs(AppT2,SomeList);
  SelectedString := PopSomeList(SomeList, 'Forms with Overrides');
 //SomeList.Free; //20160704 Igor
 If SelectedString > '' then
   OpenForm(GetCurrentRetNo,GetFormNo(SelectedString),0);
end;

procedure TMainFormT2_2027.ShowReturn(ARetNo: integer); //20190211 Igor //20190313 Igor
begin
  If ARetNo > 0 then
  begin
    Screen.Cursor:=crHourGlass;
    FRetNo := ARetNo;
    CountDiagnostics(ARetNo);
    MainForm.RefreshAuditPanel(ARetNo); //does it all
    FormName := 'T2';
    FormNo := GetFormNo(FormName);
    vtChild.CreateNewMDIChild(ARetNo, '').HideAllControls;
    try
      OpenForm(ARetNo,FormNo,0);
      OpenUsedForms(ARetNo);
      Screen.Cursor:=crDefault;
      MainForm.GuiCommand(gcShowLeftPanel);
    finally
      vtChild.CreateNewMDIChild(ARetNo, '').ShowAllControls;
    end;
  end;
end;

(*
procedure TMainFormT2_2027.ShowReturn(ARetNo: integer); //20190211 Igor
begin
  If ARetNo > 0 then
  begin
    Screen.Cursor:=crHourGlass;
    FRetNo := ARetNo;
    CountDiagnostics(RetNo);
    MainForm.RefreshAuditPanel(RetNo); //does it all
    FormName := 'T2';
    FormNo := GetFormNo(FormName);
    vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
    try
      OpenForm(RetNo,FormNo,0);
      OpenUsedForms(RetNo);
      Screen.Cursor:=crDefault;
      MainForm.GuiCommand(gcShowLeftPanel);
    finally
      vtChild.CreateNewMDIChild(RetNo, '').ShowAllControls;
    end;
  end;
end;
*)
procedure TMainFormT2_2027.SystemInformation1Click(Sender: TObject);
//20170901 Igor>>>
//Var h : THandle;
begin
// h := ShellExecute(MainForm.Handle, Nil, 'WINFO.Exe', Nil,
//  Nil, SW_RESTORE);
// if h<=32 then ShowMessage('Info cannot be displayed. Code '+IntToStr(h));
  MessageDlg(OSTest, mtInformation, [mbOk], 0);
//20170901 Igor<<<
end;

procedure TMainFormT2_2027.RC59EfIle1Click(Sender: TObject);
begin
  //20180519
 If ButtonInactive then exit;
 if IsAuthorizedPreparer = false then Exit; //20190401
 //If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit; //20211210
 OpenForm(GetCurrentRetNo,'CONSENT#1',0);   //20201214
 Exit;
end;

procedure TMainFormT2_2027.RC59Xcancellation1Click(Sender: TObject);
begin
 //20201214 OLD form now part of Consent
{
 If ButtonInactive then exit;
 if IsAuthorizedPreparer = false then Exit; //20190401
 OpenForm(GetCurrentRetNo,'RC59X',0);
 Exit;
}
end;

procedure TMainFormT2_2027.RebuildtheClientDataBase1Click(Sender: TObject);
begin
 If RetInMem>0 then
  begin ShowMessage('Please close all returns first');exit;end;
 ExecuteForm(TRebuildT2_2027);
end;

procedure TMainFormT2_2027.MergeDataBases1Click(Sender: TObject);
begin
{ If Not FeatureAllowed then exit;}
 If RetInMem>0 then
  begin ShowMessage('Please close all returns first');exit;end;
 ExecuteForm(TMergeT2_2027);
end;

procedure TMainFormT2_2027.FileViewerEditor1Click(Sender: TObject);
begin
  ExecuteForm(TFileVuT2_2027);
end;

//20121107
procedure TMainFormT2_2027.CurrentPage1Click(Sender: TObject);
var
 i,totalPages,whichPage:integer; //SomeList :TStringList;
 OldPrinterName:String;
 //20180503 Igor >>>
 PDFFullfileName: string;
 PDF: TvtPDFPrinter;
 //20180503 Igor <<<
begin
 //print page
 //showmessage(sender.classname);
 If ButtonInactive then exit;
 //If Ret[GetCurrentRetNo].IsLastYearRetNo then Exit; //20110227
 SomeList.Clear;  // := TStringList.Create;



 totalPages := GetFormMxPg(FormName);
 if totalPages = 0 then
        totalPages := 1;

 for i:=1 to totalPages do
 begin
  SomeList.Add(inttostr(i));
 end;

  SelectedString := PopSomeList(SomeList, 'Select Page to Print');
 //SomeList.Free;
 If SelectedString > '' then
 begin
    whichPage := strToInt(Trim(SelectedString)) //20210629 Igor
    //whichPage := strToInt(AllTrim(LeftStr(SelectedString,2))) //20130102
 end
 else
    exit;

 FastPrint := False;
 If ButtonInactive then exit;

 CountDiagnostics(GetCurrentRetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  If not MainForm.WizardPanel.visible then MainForm.AuditOpenBtnClick(Sender);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Not AllowedToFormPrint(RetNo) then exit;
  //20180503 Igor >>>
  if CheckIsCloud(true) then
  begin
    PDFFullfileName := TPath.Combine(AppDir, 'tmp' + TPath.DirectorySeparatorChar + TPath.GetGUIDFileName + '.pdf');
    if not ForceDirectories(ExtractFileDir(PDFFullfileName)) then
    begin
      MessageDlg('Can not create temp folder', mtError, [mbOk], 0);
      Exit;
    end;
    PDF := TvtPDFPrinter.Create(AppT2);
    try
      PDF.PrintForm(RetNo, FormName, whichPage, T2_2027Print.AfterReadComponentForPrint,
          T2_2027Print.PrintEditBox, T2_2027Print.PrepareRichEdit,
          T2_2027Print.PrintImageT2, T2_2027Print.PrintHeader);

      PDF.SaveToFile(PDFFullfileName, false);
      OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
    finally
      PDF.free;
    end;
  end
  else
  begin
   OldPrinterName:=GetDefaultPrinterName;
   If PrintDialogItem.Execute then
   begin
     StartPrintForm(GetCurrentRetno,FormName,whichPage);
     if Printer.Printing then //20160905 Igor
       Printer.EndDoc;        //20160905 Igor
   end;
  end;
  //20180503 Igor <<<

// If OptRec.RetainDefaultPrinter = True then SetDefaultPrinter(OldPrinterName);  //20110225
end;


procedure TMainFormT2_2027.ComparativeSummaryClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 Screen.Cursor:=CrHourGlass;
 CalcFed(RetNo);
 CalcOnt(RetNo);
 CalcAlb(RetNo);
 Screen.Cursor:=CrDefault;

 OpenForm(GetCurrentRetNo,GetFormNo('COMPSUM'),0);
end;

procedure TMainFormT2_2027.CplBtnClick(Sender: TObject);
begin
 //EndCoupling1Click(Sender);
 {UpdateMenuItems(Sender);}
end;

procedure TMainFormT2_2027.MinTaxBtnClick(Sender: TObject);
begin
 //OpenForm(GetCurrentRetNo,GetFormNo('T691_1'),0);
end;

procedure TMainFormT2_2027.ClientListings1Click(Sender: TObject);
begin
  ExecuteForm(TReportMenuT2_2027);
end;

procedure TMainFormT2_2027.RecalcBtnClick(Sender: TObject);
//Var FNo:integer;//RetNo:Integer;
begin
 If ButtonInactive then exit;
 Screen.Cursor := crHourGlass;
 //RetNo:=GetCurrentRetNo;
 CalcFed(RetNo);
 CalcOnt(RetNo);
 CalcAlb(RetNo);

 CountDiagnostics(RetNo);
 Screen.Cursor := crDefault;
 If FormNo>0 then MyChild.ShowFormData(FormName,FormNo);
 MainForm.RefreshAuditPanel(RetNo);  //20090705
 MyChild.UpdateChildTaxPanel;
end;


procedure TMainFormT2_2027.Recovery1Click(Sender: TObject);
begin
  if not OpenDialog.execute then exit;
  vtDataModuleUnit.TryRecovery(OpenDialog.FileName);
end;

procedure TMainFormT2_2027.PreselNextBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  MyChild:=Ret[RetNo].MyChild; 
  MyChild.Pages.SelectNextPage(True);
end;

procedure TMainFormT2_2027.PreSelPrvBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  MyChild:=Ret[RetNo].MyChild;
  MyChild.Pages.SelectNextPage(False);
end;




procedure TMainFormT2_2027.Prevalidate1Click(Sender: TObject);
begin
// If UpperCase(InputBox('Input Box', 'Not released yet. Enter Password', '')) <> 'N/A' then exit; //20191017
 Application.CreateForm(TPreValidateEfileT2_2027,TPreValidateEfile);
 TPreValidateEfile.ShowModal;
 TPreValidateEfile.Free;
end;

procedure TMainFormT2_2027.ChangeLicenseLevel;
//Var K,Psw:string;// PgmNames,ProductIds,PgmFactors:TstringList;
begin

  if not AppT2.AskChangeLicenseLevel then
    exit;

 Licensee:='Some Multi-user';
 SelectFeatures;
 MainForm.FormPaint(Application);
End;


procedure TMainFormT2_2027.NISAcodes1Click(Sender: TObject);
begin
  PopSomeFile(AppDir+'\'+'CAIS.D','CAIS CODES');
end;


procedure TMainFormT2_2027.OpenBtnClick(Sender: TObject);
begin
 actFileOpenItemExecute(Application);//20171206 Igor
end;

procedure TMainFormT2_2027.YourLatestReleaseClick(Sender: TObject);
 Var h : THandle;
begin
ConnectToWeb('www.visualtax.com/T2-2026-WhatsNew.php');   //20241201
 //ConnectToWeb('www.visualtax.com/Vt2018HELP/T2Help/T2UpdHlp/WebSite/What_s_New.html');   //20171204
// ConnectToWeb('www.visualtax.com/Vt2016HELP/T2Help/T2Upd/website/index.html'); //2016/12/17
// ShowHelp(AppT2.ModuleHelpUpdFile, 'HELP_CONTENTS', True); //20160801 Igor //20161220 Igor
end;


procedure TMainFormT2_2027.ZoomBtnPlusClick(Sender: TObject);
begin
  ZoomBtnClicked(+5);
//  if ZoomBtnClicked(+5) then
//    ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
end;

procedure TMainFormT2_2027.ZoomBtnMinusClick(Sender: TObject);
begin
  ZoomBtnClicked(-5);
//  if ZoomBtnClicked(-5) then
//    ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
end;

procedure TMainFormT2_2027.AuditOptionClick(Sender: TObject);
Var FNo:Integer;InputString,Msg:String;
begin
 MainForm.RefreshAuditPanel(GetCurrentRetNo);
 If MainForm.FormsPanel.Visible then MainForm.RefreshFormsPanel(GetCurrentRetNo);
end;

procedure TMainFormT2_2027.AutoFill1Click(Sender: TObject);
var Rno:Integer;
begin
// If UpperCase(InputBox('Input Box', 'Auto-fill i not released yet. Enter Password', '')) <> 'N/A' then exit;
 //20180513
 FRetNo := GetCurrentRetNo;
 if RetNo < 1 then
 Begin
  ShowMessage('You must open an existing return first'
  + Chr(13)+'OR'
  + Chr(13)+'Open a NEW return and enter the Business Number'
  + Chr(13)
  + Chr(13)+'and then'
  + Chr(13)+'Click Fed-E-file -> Auto-Fill'
  );
  Exit;
 end;

 //if ButtonInactive then Exit;
 //20180511
 // ShowMessage('Auto-Fill for T2 has not been released yet. Do not submit');
 // If UpperCase(InputBox('Input Box', 'Enter Password', '')) <> 'N/A' then exit; //20171211
  AFR(AppT2, Ret[GetCurrentRetNo]);

 {Does not work
  //20201213
  RNo:=GetCurrentRetNo;
  Calc(RNo,'AFRBAL');
 // if Ret[RNo].FrmHasData[GetFormNo('AFRBAL')] then
      OpenForm(RNo,'AFRBAL',0);
 }
end;

procedure TMainFormT2_2027.AutoFill3Click(Sender: TObject);
begin
 if IsAuthorizedPreparer = false then Exit; //20190401
 //20180601
 ShowMessage('Click the main menu item called Auto-fill');
 Exit;
end;

procedure TMainFormT2_2027.Upgrade1Click(Sender: TObject);
Const ActivationFile = 'LVerf.EX_';
begin
  ShowAbout;
end;

procedure TMainFormT2_2027.AuditListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If  (Key = VK_F5) then AuditOpenBtnClick(Sender);
end;


procedure TMainFormT2_2027.InternetWebSite1Click(Sender: TObject);
Var h:THandle;
begin
 ConnectToWeb('HTTP://www.VisualTax.com');
end;


procedure TMainFormT2_2027.WWWLblClick(Sender: TObject);
begin
 InternetWebSite1Click(Sender);
end;

procedure TMainFormT2_2027.WorldButtonClick(Sender: TObject);
begin
InternetWebSite1Click(Sender);
end;


procedure TMainFormT2_2027.AlphabeticalFormsIndex1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 ExecuteForm(TABListT2_2027);
//ABCBtnClick(Sender);
end;

procedure TMainFormT2_2027.amT2StateChange(Sender: TObject);//20170911 Igor //20190415 Igor
var
  I: Integer;
begin
  if (MainOptions.Skin = skRibbon) and (amT2.State = TActionListState.asNormal) then
  begin
    for I := 0 to amT2.ActionCount - 1 do
    begin
      amT2.Actions[I].Enabled := not amT2.Actions[I].Enabled;
      amT2.Actions[I].Enabled := not amT2.Actions[I].Enabled;
    end;
  end;
end;

procedure TMainFormT2_2027.Zoomin1Click(Sender: TObject);
begin
ZoomBtnPlusClick(Sender);
end;

procedure TMainFormT2_2027.Zoomout1Click(Sender: TObject);
begin
ZoomBtnMinusClick(Sender);
end;

procedure TMainFormT2_2027.Toolbandswitch1Click(Sender: TObject);
begin
 ToolBarBtnClick(Sender);
end;

procedure TMainFormT2_2027.Recalc1Click(Sender: TObject);
begin
RecalcBtnClick(Sender);
end;


procedure TMainFormT2_2027.ReIndextheClientDataBase1Click(Sender: TObject);
begin
  ExecuteForm(TReindexDbT2_2027);
end;

procedure TMainFormT2_2027.ReloadMainMenu; //20190228 Igor
begin
  LoadPluginActions(Self, MainMenuT2, OpenFromCloudClick, OnCreateMenuItem);
  SetMainMenuTitle; //20191202 Igor
end;

procedure TMainFormT2_2027.ExchageRatesAverage1Click(Sender: TObject);
begin
  PopSomeFile(AppDir+'\'+'EXCHRATE.D', 'Average Exchange Rates', True);  //20171027
end;


procedure TMainFormT2_2027.Checkupdate1Click(Sender: TObject);
Var h:THandle;
begin
 ConnectToWeb('https://www.visualtax.com/download.php'); //20210630
end;

procedure TMainFormT2_2027.Image1Click(Sender: TObject);
 Var h : Thandle;
begin
 Checkupdates1Click(Sender);
end;

procedure TMainFormT2_2027.CheckUpdatesLblClick(Sender: TObject);
begin
 Checkupdates1Click(Sender);
 //Image1Click(Sender);
end;

procedure TMainFormT2_2027.Label1Click(Sender: TObject);
begin
 InternetWebSite1Click(Sender);
end;

procedure TMainFormT2_2027.ClearCurrentformClick(Sender: TObject);
begin
  ClearCurrentPageClick(Sender);
end;

procedure TMainFormT2_2027.ClearCurrentPageClick(Sender: TObject);
Var RefFNo:Integer;RefFormName:String; AChild:TMyChild;
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
 Ret[RetNo].MyChild.ActiveForm.RebuildDynamicRows; //20160527 Igor
 ShowFormData(RetNo,FormName,FormNo);
 Ret[RetNo].FrmHasData[GetFormNo(FormName)]:=False;
 MainForm.RefreshAuditPanel(RetNo);//If AuditPanel.Visible then RefreshAuditPanel;
 If MainForm.FormsPanel.Visible then MainForm.RefreshFormsPanel(RetNo);
end;

//20161216 Igor
//Function TMainFormT2_2027.SelectFromLoadedReturns(RetNo:Integer):Integer;
//begin
// Result:=RetNo;
// SomeList.Clear;  // := TStringList.Create;
// GetListOfLoadedReturns(SomeList);
// SomeList.Sort;
// SelectedString := PopSomeList(SomeList,'Select from Loaded returns');
// If SelectedString > '' then
//   Result:=MyStrToInt(AllTrim(LeftStr(SelectedString,2)));
//end;

Procedure TMainFormT2_2027.GetListOfLoadedReturns(SomeList:TStringList);
Begin
  RetList.GetListOfLoadedReturns(SomeList, AppT2); //20161216 Igor
  SomeList.Sorted := True;
end;

Procedure TMainFormT2_2027.PutLastYearValueOnFrmGrid(Frmnm:String;FileFound:Boolean;LnNo:Integer;Description:String;Value:String);
Var i:Integer;
begin
end;


Procedure TMainFormT2_2027.PutFrmDictOnFrmGrid(Frmnm:String;FileFound:Boolean);
Var i:Integer;
begin
end;

procedure TMainFormT2_2027.CharityOrganizations1Click(Sender: TObject);
begin
 SomeCaption:='Charity Organizations';
 SomeLabel:='Used for predictive entry in the Donations list';
 SomeFile:='Charity.Txt';
 ExecuteForm(TDFilesT2_2027);
end;

procedure TMainFormT2_2027.SuperEntry1Click(Sender: TObject);
begin
  if LicenseLevel in [llLimited..llStd]
 then
 begin
  ShowMessage('Super Entry is available only in the T2 Power version');
  exit;
 end;
 ExecuteForm(TSuperEntryT2_2027);
end;

procedure TMainFormT2_2027.Employers1Click(Sender: TObject);
begin
 SomeCaption:='Employers';
 SomeLabel:='Used for predictive entry in the T4, T4PS';
 SomeFile:='Employers.Txt';
 ExecuteForm(TDFilesT2_2027);
end;


procedure TMainFormT2_2027.DoctorsHospitalsPharmacies1Click(Sender: TObject);
begin
 SomeCaption:='Doctors-Hospitals-Pharmacies';
 SomeLabel:='Used for predictive entry in the Donations list';
 SomeFile:='Doctors.Txt';
 ExecuteForm(TDFilesT2_2027);
end;

procedure TMainFormT2_2027.MainUIRibbonCommandCreate(const Sender: TUIRibbon; //20190415 Igor
  const Command: TUICommand);
begin
  case Command.CommandId of
	    T2_UIRibbonUnit.CommandSearchForm1:
	      begin
          FSearchForm1 := TUICommandCollection(Command);
          FSearchForm1.OnSelect := SearchFormSelect;
	      end;
      T2_UIRibbonUnit.CommandSearchForm2:
	      begin
          FSearchForm2 := TUICommandCollection(Command);
          FSearchForm2.OnSelect := SearchFormSelect;
	      end;
  end;
end;

procedure TMainFormT2_2027.MedicalExpenseDescriptions1Click(Sender: TObject);
begin
 SomeCaption:='Medical Expense Types';
 SomeLabel:='Used for predictive entry in the Medical expenses';
 SomeFile:='MedExp.Txt';
 ExecuteForm(TDFilesT2_2027);
end;

procedure TMainFormT2_2027.FirstNames1Click(Sender: TObject);
begin
 SomeCaption:='First Names';
 SomeLabel:='Used for predictive entry when entering first names (Taxpayer, Dependants, etc';
 SomeFile:='FirstNm.Txt';
 ExecuteForm(TDFilesT2_2027);
end;

procedure TMainFormT2_2027.Cities1Click(Sender: TObject);
begin
 SomeCaption:='Cities';
 SomeLabel:='Used for predictive entry when entering the name of a city';
 SomeFile:='Cities.Txt';
 ExecuteForm(TDFilesT2_2027);
end;

procedure TMainFormT2_2027.T1GuideCCRA1Click(Sender: TObject);
begin
  ShowPdf(AppDir,'t4012-23e.pdf');         //20210703  //20220318
end;


 procedure TMainFormT2_2027.OpenPreviousYearsT11Click(Sender: TObject);
 Var h : Thandle;
   PgmPathS,PgmS,PgmParmsS:String;
   PgmPathZ : Array[0..254] of Char;
   PgmParmsZ : Array[0..254] of Char;
   PgmZ: Array[0..254] of Char;
   s,S1:String;
begin
 if CheckIsCloud then Exit; //20180503 Igor 
S1:=IntToStr(StrToInt(AppYear)-1);
 S:= InputBox('Input Box', 'Program path and name (not necessarily VisualTax)', 'C:\T2-'+S1+'\'+'T2'+S1+'.Exe'); //20110716
 PgmPathS := ExtractFileDir(S); StrPCopy(PgmPathZ,PgmPathS);
 PgmS:=ExtractFileName(S); StrPCopy(PgmZ,PgmS);
 PgmParmsS:=''; StrPCopy(PgmParmsZ,PgmParmsS);
 h := ShellExecute(Handle, Nil, PgmZ, PgmParmsZ,PgmPathz, SW_RESTORE);
 If H<=32 then ShowMessage('Program not found');
end;

procedure TMainFormT2_2027.CompanyLogo1Click(Sender: TObject);
begin
  if LicenseLevel in anyMulti
 then
 //ok
 else
 begin
  ShowMessage('Available only in the Power version of the program');
  Exit;
 end;
end;

procedure TMainFormT2_2027.ImportConfiguration1Click(Sender: TObject);
begin
 if CheckIsCloud then Exit; //20180503 Igor
 ExecuteForm(TImportConfigT2_2027);
end;


procedure TMainFormT2_2027.ImportfromProduction1Click(Sender: TObject); //20160305 Igor
begin
//20160518 Igor >>>
//  If getCurrentRetNo > 0 then
//  begin
//    ShowMessage('Please close all returns first');
//    Exit;
//  end;
//20160518 Igor <<<
  If OptRec.Dir_DBFData = '' then
  begin
    //20161213
    ShowMessage('You should first enter the Data Directory of the your T2 returns (prior to VT)'
                +Chr(13)+'See Configure | General Options | Data Directories');
    Exit;
  end;
  MainForm.GuiCommand(gcHideLastYear); //20160311 Igor
  ExecuteForm(TImportDBFT2_2027);

end;

procedure TMainFormT2_2027.ExportConfiguration1Click(Sender: TObject);
begin
  if CheckIsCloud then Exit; //20180503 Igor
  ExecuteForm(TExportConfigT2_2027);
end;

procedure TMainFormT2_2027.Findaline1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 ExecuteForm(TFindALineT2_2027);
end;



procedure TMainFormT2_2027.FindDuplicates1Click(Sender: TObject);
Var flName:String;
begin
 //20250524
 ShowMessage('Every year must change the folder in Cor FindDuplicates (Main->Utilities->Advanced-Find Duplicates');
 //Delay(1000);  //non needed it has asn ok button
 FlName:='c:/VtPrograms/2024/DistrFl/T2-2026/Eolfiles/test.cor'; //20250524
 FindDuplicates(flname);
end;

procedure TMainFormT2_2027.LinesBtnClick(Sender: TObject);
begin
Findaline1Click(Sender);
end;


procedure TMainFormT2_2027.UsefulLinksClick(Sender: TObject);
begin
  ConnectToWeb('https://www.visualtax.com/links.php');  //20210630
  //ConnectToWeb('HTTP://www.VisualTax.com/links.asp');  //20140308
end;

procedure TMainFormT2_2027.SetReturnPassword1Click(Sender: TObject);
Var s:String;
begin
  If buttonInactive then exit;
  ExecuteForm(TSetFilePswT2_2027);
end;

procedure TMainFormT2_2027.SetSearchStr(const AValue: String);
begin
  if AValue <> FSearchStr then
  begin
    FSearchStr := AValue;
    if edtSearchForm.Text <> FSearchStr then
      edtSearchForm.Text := FSearchStr;
    if edtSearchForm2.Text <> FSearchStr then
      edtSearchForm2.Text := FSearchStr;
{    if edtSearchForm3.Text <> FSearchStr then
      edtSearchForm3.Text := FSearchStr;
    if edtSearchForm4.Text <> FSearchStr then
      edtSearchForm4.Text := FSearchStr;}
    if QuickFindBtn.Text <> FSearchStr then
      QuickFindBtn.Text := FSearchStr;
  end;
end;

procedure TMainFormT2_2027.RemoveReturnPassword1Click(Sender: TObject);
begin
 If buttonInactive then exit;
 RemoveReturnPsw(RetNo);
 ShowTimedMsg('Password Removed',1000);
end;

procedure TMainFormT2_2027.RequestWACWebAccessCodefromCRA1Click(Sender: TObject);
begin
 { //20260629
 //20190525
 If UpperCase(InputBox('Input Box', 'Not released yet. Call CRA for WAC. Enter Password', '')) <> 'N/A' then exit; //20260625
 If buttonInactive then exit;
 }
 ExecuteForm(TWACRequestEfileT2_2027);

end;

procedure TMainFormT2_2027.PrintAuditBtnClick(Sender: TObject);
Var i:Integer;FileNm,Hdr1,Hdr2,Hdr3,s:string;TempList:TStringList;
begin
 If PrintDialogItem.Execute then
 begin
  Calc(GetCurrentRetNo,'DIAGNO');
  StartPrintForm(GetCurrentRetno,'DIAGNO',1);
  if Printer.Printing then //20160905 Igor
    Printer.EndDoc;        //20160905 Igor

 end;
end;

procedure TMainFormT2_2027.PrintAuditWizardDiagnostics1Click(Sender: TObject);
Var RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
If ButtonInactive then exit;
 CountDiagnostics(GetCurrentRetNo);
 PrintAuditBtnClick(Sender);
end;

procedure TMainFormT2_2027.EmailCurrentFormClick(Sender: TObject);
Var RetNo:Integer;
begin
 If buttoninactive then exit;
 RetNo:=GetCurrentRetNo;
 If not IsFormMultipage(FormName) then
  Calc(RetNo,FormName)
 else
  CalcMultiPageForm(RetNo,FormName);
 PrintFormForEmail(RetNo,FormName);
end;

procedure TMainFormT2_2027.PrintFormForEmail(RetNo:Integer;FormName:String);
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
   if Printer.Printing then //20160905 Igor
     Printer.EndDoc;        //20160905 Igor
   SetDefaultPrinter(OldPrinterName);
  end
 end
 Else
 begin
  ShowMessage('The PDFFactory printer Driver has not been installed');
  ExecuteForm(TPDFFrmT2_2027);
 end;
end;


procedure TMainFormT2_2027.SaveALLopenedreturns1Click(Sender: TObject);
begin
 SaveAllReturns;
end;


Function TMainFormT2_2027.SaveAllReturns:Boolean;
begin
(* Needs modifications for open returns of different kind!
  Let the real main form do the loop.
*)
  Result := MainForm.SaveAllReturns;
end;

function TMainFormT2_2027.DoSaveAllReturns(RNo: integer): boolean;
Var
  FlName,DataDir:String;
begin
(* Extract of SaveAllReturns, saves an single return only.
  Used from the program main form SaveAll
*)
  Result := False;
  begin
   CalcFed(RNo);
   CalcOnt(RNo);
   CalcAlb(RNo);
   //CalcAll(RetNo);

   Ret[RNo].FedCalcStatus := True;
   Ret[RNo].OntCalcStatus := True;
   Ret[RNo].AlbCalcStatus := True;

   CountDiagnostics(RNo);
   If Ret[RNo].MandatoryErrorCount > 0 then
   begin
    OpenForm(RNo,GetFormNo('T2'),0);
    If not MainForm.LeftPanel.Visible then begin
      //MainForm.LeftPanel.Visible:=True;
      MainForm.GuiCommand(gcShowLeftPanel);
      MainForm.AuditOpenBtnClick(Application);
    End;
    MainForm.RefreshAuditPanel(GetCurrentRetNo);
    ShowMessage('Please enter Mandatory data before saving and try again');
    Screen.Cursor:=CrDefault;
    exit;
   end;
   FlName := Ret[RNo].SourceFlName;
   If FlName = '' then
    FlName := LeftStr(GetAccountNumber(RetNo),8)
                 +'.'+MidStr(GetTaxationYearEnd(RetNo),3,2);
    {
    FlName := LeftStr(FetchElm(RNo,'T2',3),8)+
     '.'+RightStr(FetchElm(RNo,'T2',3),1);
     }
   DataDir := Ret[RNo].SourceDataDir;
   If IsDataDirectoryGood(DataDir) = False then exit;
   If DirectoryExists(DataDir) = False then
   begin
    ShowMessage('Directory does not exist');
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
   If FileExists(DataDir+'\'+ClientsDBLite) = False then //20150922 Igor
   begin
    ShowMessage('Data directory '+DataDir + ' was not configured for tax returns');
    Exit;
   End;

   If IsReturnLocked(RNo) = true then
   begin
   ShowMessage('Cannot save: '+ GetCorpName(RNo)+
     chr(13)+'This return has been locked');
   //exit;
   end

  else
  BEGIN
  {put changed STATUS form data}
  with Ret[RNo].Frm[GetFormNo('STATUS')] do
  begin
  end;


  //Aug 8 2008
  OpenForm(RNo,GetFormNo('T2'),0);
  CalcUsedFrm(RNo);

  If SaveReturn(RNo,DataDir,FlName,True,True) = 0 then
  begin
     Ret[RNo].SourceDataDir := DataDir;
     Ret[RNo].SourceFlName := FlName;
     Ret[RNo].changed:=False;
   end
   else
   begin
      ShowMessage('Return was not saved... Press any key');
      Screen.Cursor:=CrDefault;
      exit;
   end;
  END;
 end;  //i
 Result:=True;
end;


procedure TMainFormT2_2027.SaveandCloseAllopenedreturns1Click(Sender: TObject);
begin
 If RY=1 then
 begin
  ShowMessage('A return is in Planning mode. Please use one-by-one Save (F3)');
  Exit;
 end;
 If SaveAllReturns= True then CloseAllReturns;
end;

procedure TMainFormT2_2027.CloseallreturnsWITHOUTSaving1Click(Sender: TObject);
Var i:Integer;RetNo:Integer; //FHandle:THandle
begin
 if MessageDlg('Close ALL returns without saving them?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then CloseAllReturns;
end;


Procedure TMainFormT2_2027.CloseAllReturns;
begin
  MainForm.CloseAllReturns;
end;

procedure TMainFormT2_2027.ProcessBlackBoxFile;
begin
end;  //end blackbox


procedure TMainFormT2_2027.FormsBlackBoxBtnClick(Sender: TObject);
begin
 SelectFormClick(Sender);
end;



procedure TMainFormT2_2027.Provincialnews1Click(Sender: TObject);
begin
 //Application.HelpFile := AppDir+'\'+'PROVNEWS.HLP';
 ShowHelp(AppT2.ModuleHelpFile, 'HELP_CONTENTS', True); //20161220 Igor
end;


Function TMainFormT2_2027.CountFiles(Dir:String;FileExt:String):Integer;
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

procedure TMainFormT2_2027.Countrybycountry1Click(Sender: TObject);
begin
 //20180519
 If ButtonInactive then exit;
 if IsAuthorizedPreparer = false then Exit; //20190401
// If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit; //20211210
 OpenForm(GetCurrentRetNo,'CBCR',0);
 Exit;
end;

procedure TMainFormT2_2027.CICALineByLineInternethelpNONResidents1Click(Sender: TObject);
Var h:THandle;
begin
  Screen.Cursor :=crHourGlass;
  h := ShellExecute(Handle,'open',
  'http://www.knotia.ca/Knowledge/LBL/Home.cfm?kType=93&LBLGuideID=2',
  Nil,Nil,Sw_Show);
  If H<=32 then
   ShowMessage('Connection failed');
  Screen.Cursor :=crDefault;
end;

procedure TMainFormT2_2027.OtherGuides1Click(Sender: TObject);
Var PgmPath,PgmFile:String;
begin
  SelectedString := PopSomeFile(AppDir+'\'+'GUIDES.d', 'CRA GUIDES');
 If SelectedString > '' then
 begin
  PgmPath:=AppDir;
  PgmFile:=AllTrim(LeftStr(SelectedString,8))+'.PDF';
  ShowPdf(PgmPath,PgmFile);
 end;

end;


procedure TMainFormT2_2027.CCArates1Click(Sender: TObject);
begin
  PopSomeFile(AppDir+'\'+'CCARATES.D',
    'CCA RATES (Class  Rate  Description)');
 //SomeList.Sorted := True;
end;



procedure TMainFormT2_2027.Checkupdates1Click(Sender: TObject);
begin
  CheckUpdates(Self.Handle,AppName+'-'+AppYear);
end;

procedure TMainFormT2_2027.Frequentlyaskedquestions1Click(Sender: TObject);
begin
  ConnectToWeb('http://www.visualtax.com/t2faq.php');  //20210630
end;

procedure TMainFormT2_2027.VisualTaxForum1Click(Sender: TObject);
begin
 ConnectToWeb('http://www.visualtax2.com/cgi-bin/dcforum/dcboard.cgi');
 // ConnectToWeb('http://www.visualtax.com/cgi-bin/dcforum/dcboard.cgi'); //2012-925

end;

procedure TMainFormT2_2027.HowoftentocheckInternetUpdates1Click(Sender: TObject);
begin
  ExecuteForm(TUpdateScheduleT2_2027);
end;

procedure TMainFormT2_2027.CICA1Click(Sender: TObject);
Var h:THandle;
begin
  ConnectToWeb('http://www.knotia.ca/Knowledge/LBL/Index.cfm?kType=93&LBLGuideID=1');
end;

procedure TMainFormT2_2027.CICAHelpbyline1Click(Sender: TObject);
Var ln:String;
begin
 ln:= InputBox('Input Box', 'Enter a line: 101 to 479', '101');
 LinkToCICA(Ln);
end;

procedure TMainFormT2_2027.CICAReferencematerials1Click(Sender: TObject);
Var h:THandle;
begin
 ConnectToWeb('http://www.knotia.ca/Knowledge/LBL/Reference.cfm?kType=93&LBLGuideID=1&bAppendices=1');
end;

procedure TMainFormT2_2027.TrEngineLoadClick(Sender: TObject);
//20170904 Igor>>>
//Var h : Thandle;Dir:String;TempList:TstringList;
begin
  LoadTr(GetTrFolder);
// TrFolder:=GetTrFolder;
// If fileExists(TrFolder+'\'+'TR2015.EXE') = false then
// begin
//  ShowMessage('The TR-2015 was not installed in '+TrFolder
//   +Chr(13)+' Please see Configure | TR (Tax Research) program directory');
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

procedure TMainFormT2_2027.ListMultipleBtnClick(Sender: TObject);
Var I,J,MxPg,k,FNo:Integer; FName,FNonInst,FRootName:string;
begin
  if ButtonInactive then exit;
  If IsFormMultiInst(FormName) then
 begin
   SomeList.Clear;  // := TStringList.Create;
   FNonInst:= ExtractNonInstFormName(FormName);
   for i :=0 to (FList.Count - 1) do
   begin
    FRec := FList.Items[i];
    If FNonInst = Frec.FormName then
    begin
      FNo:=Frec.FormNo;
      //FInst:=Frec.FormInst;
      If Ret[RetNo].FrmHasData[FNo] then
      Begin
        Somelist.Add(FRec.FormInstName);
      end;
    end; //found the form
   end;  //i
   SelectedString := PopSomeList(SomeList,'List of multi-instance forms');
   SomeList.Clear; //.Free;
   If SelectedString > '' then OpenForm(RetNo,GetFormNo(SelectedString),0);
   Exit;
 end;  //check slips

end;

procedure TMainFormT2_2027.TrGuide1Click(Sender: TObject);
begin
ConnectToWeb('http://www.visualtax.com/TR/TRGuide/TRGuide-2015.htm'); //20160201 //20140201 //20150210
 // ConnectToWeb('http://www.visualtax.com/Tr/Trguide/TrGuide-2014.htm');  //20140201 //20150210
 // ConnectToWeb('http://www.visualtax.com/Tr/Trguide/TrGuide-2013.htm');  //20140201
end;

procedure TMainFormT2_2027.DefinetheTRfolder1Click(Sender: TObject);
//20170904 Igor>>>
//Var TempList:TStringList;Prompt:String;
begin
  SetupTrFolder;
// Prompt:=GetTrFolder;
// If Prompt='' then Prompt:='C:\TR-2015';       //20160201
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
// If FileExists(TrFolder+'\'+'TR'+TRYear+'.exe') = false then
//  ShowMessage('The TR-2015 wan not installed in '+TrFolder+' directory');
//20170904 Igor<<<
end;

procedure TMainFormT2_2027.NewReturnLblClick(Sender: TObject);
begin
  FileNewItem_Click(Sender);
end;

procedure TMainFormT2_2027.OpenReturnLblClick(Sender: TObject);
begin
actFileOpenItemExecute(Sender);//20171206 Igor
end;

procedure TMainFormT2_2027.ShowMostRecentReturns;
Var I:Integer;SomeList:TStringList;
    AColumn:TListColumn;
    AListItem:TListItem;
    MaxReturns:Integer;
    A: TArray<string>; //20201015 Igor
Begin
  if Application.Terminated then exit; //20170113 Igor
  //20170127 Igor >>>
  MostRecentLbl.Visible := not MainOptions.HideMostRecent;
  ListView1.Visible :=  not MainOptions.HideMostRecent;
  OpenItBtn.Visible :=  not MainOptions.HideMostRecent;
  EMailItBtn.Visible :=  not MainOptions.HideMostRecent;
  CopyAReturnBtn.Visible :=  not MainOptions.HideMostRecent;
  //20170127 Igor <<<
  SetMainMenuTitle; //20191202 Igor
  //rbnT2.ClearRecentItems;//20170911 Igor //20190415 Igor
  If MainOptions.HideMostRecent then Exit;
  With ListView1 do
  begin
    ListView1.Items.BeginUpdate; //20170127 Igor
    try                          //20170127 Igor
      ListView1.Items.Clear;
      ListView1.Columns.Clear; //20170130 Igor
      //ListView1.Visible:=False; //20170127 Igor
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
      try   //20170127 Igor
        If FileExists(AppDir+'\'+RecentFlName) then
        begin
         SomeList.LoadFromFile(AppDir+'\'+RecentFlName);
         MaxReturns:=SomeList.Count-1;
         If MaxReturns>30 then MaxReturns:=30;
         For i:=0 to MaxReturns do //SomeList.count-1 do
         begin
          //ListBox1.Items.Add(SomeList[i]);
          //20201015 Igor >>>
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
          //20201015 Igor <<<
          //20170825 Igor>>>
          //rbnT2.AddRecentItem(Trim(LeftStr(SomeList[MaxReturns - i],30)));//20170911 Igor //20190415 Igor
          //20170825 Igor<<<
         end;
        end;
//20170127 Igor >>>
      finally
        SomeList.Free;
      end;
    finally
      ListView1.Items.EndUpdate;
    end;
  end; //with
//  ListView1.Visible:=True;
//20170127 Igor <<<

end;

procedure TMainFormT2_2027.WhatsNewLblClick(Sender: TObject);
begin
YourLatestReleaseClick(Sender);
end;

procedure TMainFormT2_2027.FaQLblClick(Sender: TObject);
begin
Frequentlyaskedquestions1Click(Sender);
end;

procedure TMainFormT2_2027.HelpLblClick(Sender: TObject);
begin
VisualTaxGuide1Click(Sender);
end;

procedure TMainFormT2_2027.Hist1Click(Sender: TObject);
Var OnlineNo,Password,Url,NetFileDir,FileExt:String;
FlNm:String;
h: THandle;
begin
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 OpenDialog.Title    := 'History of Efile submissions';
 OpenDialog.InitialDir := NetFileDir;
 //OpenDialog.Filter:='All Files|*.*|Displayed Acknowledgement|*.XML|Actual XML files|*.xml';
 OpenDialog.FileName := '*.*';
 If OpenDialog.Execute then
 begin
  FlNm:=OpenDialog.FileName;
  FileExt:=ExtractFileExt(flNm);
  if FileExt='.COR' then
    ShowMessage('To show a COR file, right click the file name and Open with Notepad')
  Else
  Begin
   h := ShellExecute(Application.Handle,'open',Pchar(''+flNm),Nil,Nil,Sw_Show);
   If h<=32 then ShowMessage('File not found');
  end;
 end;
end;


procedure TMainFormT2_2027.ForumLblClick(Sender: TObject);
begin
VisualTaxForum1Click(Sender);
end;

procedure TMainFormT2_2027.TRLblClick(Sender: TObject);
begin
TrEngineLoadClick(Sender);
end;

procedure TMainFormT2_2027.Lockreturnagaistchanges1Click(Sender: TObject);
Var RetNo:Integer;
begin
 If ButtonInactive then exit;
 //20100528
 RetNo:=GetCurrentRetNo;
 If RetNo>0 then
 begin
  LockReturn(GetCurrentRetNo);
 end;
end;

procedure TMainFormT2_2027.UnlockReturn1Click(Sender: TObject);
Var retno:Integer;
begin
 If ButtonInactive then exit;
 //20100528
 RetNo:=GetCurrentRetNo;
 If RetNo>0 then
 begin
  UnlockReturn(GetCurrentRetNo);
  Calc(GetCurrentRetNo,'STATUS');
 end;
end;

procedure TMainFormT2_2027.SetHorScrollBarInListBox(ListBox: TListBox; MaxWidth: Integer);
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
procedure TMainFormT2_2027.SetMainMenuTitle;
begin
  TradeMarkLbl.Caption := 'VisualTax';
 { 20200116 con
  if (LicenseLevel in anyMulti) and (OptRec.Prp_NameAsTitle) then
    TradeMarkLbl.Caption := OptRec.Prp_Name
  else
    TradeMarkLbl.Caption := 'VisualTax';
 }
end;
//20191202 Igor <<<

procedure TMainFormT2_2027.Options2Click(Sender: TObject);
begin
 If LicenseLevel in anyMulti then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;
 ExecuteForm(TOptionsFrmT2_2027);
end;


procedure TMainFormT2_2027.QuestionMarkLblMouseDown(Sender: TObject;
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

procedure TMainFormT2_2027.LicLevel1Click(Sender: TObject);
begin
ChangeLicenseLevel;
end;

procedure TMainFormT2_2027.PrepareDistr1Click(Sender: TObject);
begin
  AppT2.PrepareDistribution;
end;


procedure TMainFormT2_2027.EkUDFList1Functions0Calculate(Sender: TObject;
  Args: TEkUDFArgs; ArgCount: Integer; UDFResult: TObject);
begin
  //ShowMessage('In UDF calculate routine');
  If UdfResult is  TPicture then
  begin
    //ShowMessage('it is image');  //ok
    //image1 uknkown
    With UDFResult as TPicture do
    begin
       Bitmap.Width:=Image1.Width;
       Bitmap.Height:=Image1.Height;
       Bitmap.Canvas.Draw(0,0,Image1.Picture.Graphic);
    end;
  end;
end;

function TMainFormT2_2027.SendMAPIMail(const Subject, Body, FileName,SenderName,
    SenderEMail,RecipientName, RecipientEMail: AnsiString): Integer; //20150623
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
      lpszSubject := PAnsiChar(''+Subject); //20150623

    if (Body <> '') then
      lpszNoteText := PAnsiChar(''+Body); //20150623

    if (SenderEmail <> '') then
    begin
      lpSender.ulRecipClass := MAPI_ORIG;
      if (SenderName = '') then
        lpSender.lpszName := PAnsiChar(''+SenderEMail) //20150623
      else
        lpSender.lpszName := PAnsiChar(''+SenderName); //20150623
      lpSender.lpszAddress := PAnsiChar(''+SenderEmail);
      lpSender.ulReserved := 0;
      lpSender.ulEIDSize := 0;
      lpSender.lpEntryID := nil;
      lpOriginator := @lpSender;
    end;

    if (RecipientEmail <> '') then
    begin
      lpRecipient.ulRecipClass := MAPI_TO;
      if (RecipientName = '') then
        lpRecipient.lpszName := PAnsiChar(''+RecipientEMail)
      else
        lpRecipient.lpszName := PAnsiChar(''+RecipientName);
      lpRecipient.lpszAddress := PAnsiChar(''+RecipientEmail);
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
      FileAttach.lpszPathName := PAnsiChar(''+FileName);

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

procedure TMainFormT2_2027.HelpIndexBtnClick(Sender: TObject);
begin
 //Application.HelpFile := AppDir+'\'+'T2HELP.HLP';
 ShowHelp(AppT2.ModuleHelpFile, 'HELP_CONTENTS', True); //20161220 Igor
end;

procedure TMainFormT2_2027.Backupthetaxdata1Click(Sender: TObject);
Var i:Integer;LastBackUp,Dir:String;  TempList:TStringList; DoneOk:Boolean;
  ClickedOK: Boolean;  NewDir: string;
begin
 If OptRec.BackUpDir='' then
 begin
  ShowMessage('Please enter the backup directory in Configure | General Options | Data directories');
  Exit;
 end;
 ExecuteForm(TBackupFrmT2_2027);
end;

procedure TMainFormT2_2027.Restoredatafrombackup1Click(Sender: TObject);
Var i:Integer;LastBackUp,Dir:String;  TempList:TStringList; DoneOk:Boolean;
  ClickedOK: Boolean;  NewDir: string;
begin
 If OptRec.BackUpDir='' then
 begin
  ShowMessage('Please enter the backup directory in Configure | General Options | Data directories');
  Exit;
 end;
 ExecuteForm(TRestoreFrmT2_2027);
end;

//procedure TMainFormT2_2013.CopyAReturnBtnClick(Sender: TObject);
function TMainFormT2_2027.CopyAReturnBtnClick(const FromDir, FlName, ACaption: string): boolean;
Var i,ThisResult:Integer;//Dir,FlName,Sin:String;
 AListItem:TListItem;
 RetNo:Integer;
begin
  Result := False;
  //if not YouHaveAdminRights then exit; in mainform
  SomeFile:=FlName;
  SomeString:=FromDir;
  SomeCaption:=ACaption; //return name
  ExecuteForm(TCopyMoveFrmT2_2027);
  Result := SomeResult;
end;

procedure TMainFormT2_2027.ShowBarCodedata1Click(Sender: TObject);
Var FlNm:String;
begin
  Flnm :=Appdir+'\'+'BarCodeData.Txt';
  If FileExists(FlNm) then
    PopSomeFile(Flnm, 'BarCode contents');
end;


procedure TMainFormT2_2027.CorporationNames1Click(Sender: TObject);
begin
 SomeCaption:='Corporation Names';
 SomeLabel:='Used for power entry in various schedules';
 SomeFile:='CorpNm.Txt';

 ExecuteForm(TDFilesT2_2027);
end;

procedure TMainFormT2_2027.BusinessNumbers1Click(Sender: TObject);
begin
 SomeCaption:='Business Numbers';
 SomeLabel:='Used for power entry in various schedules';
 SomeFile:='CorpBN.Txt';

 ExecuteForm(TDFilesT2_2027);
end;

procedure TMainFormT2_2027.buttonAvailableWidthClick(Sender: TObject); //20160406 Igor
begin
  MainForm.GuiCommand(gcAvailableWidth);
end;

procedure TMainFormT2_2027.Individualsnames1Click(Sender: TObject);
begin
 SomeCaption:='Names of Individuals';
 SomeLabel:='Used for power entry in various schedules';
 SomeFile:='IndivNm.Txt';

 ExecuteForm(TDFilesT2_2027);
end;


procedure TMainFormT2_2027.ToolButton1Click(Sender: TObject);
begin
  FileNewItem_Click(Sender);
end;

procedure TMainFormT2_2027.NewBtnToolBarClick(Sender: TObject);
begin
  FileNewItem_Click(Sender);
end;

procedure TMainFormT2_2027.OpenBtnToolBarClick(Sender: TObject);
begin
 actFileOpenItemExecute(Application);//20171206 Igor
end;

procedure TMainFormT2_2027.CloseBtnToolBarClick(Sender: TObject);
begin
  FileCloseItemClick(Sender);
end;

procedure TMainFormT2_2027.SaveBtnToolBarClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 FileSaveAsItemClick(Sender);
end;

procedure TMainFormT2_2027.ClientPreparerCopy1Click(Sender: TObject);
Var Prov:String;Template:String;
begin
 if IsAuthorizedPreparer = false then Exit; //20190401
 If LicenseLevel = llDemo then
 begin
  ShowMessage('Printing not included in the demo version');
  exit;
 end;
 If ButtonInactive then exit;
 If BeyondMaxYearEnd(RetNo) then exit;
 If StillOldPrintSets = True then
    RevisePrintSets;

 Template:=GetPrintTemplate(False);
 If Template>'' then PrintAReturn('FED', Template, Sender = SavereturninPDFFormatinClientDocs1); //20160811 Igor
end;

procedure TMainFormT2_2027.PrintAReturn(Prov:String; Template:String;
  ANotUsePrintDialog: Boolean = False); //20160811 Igor
Var i,j: integer; FormsToPrint :TstringList;
    Copies : string; //[1]; //Template :string; //[30];
begin
 If ButtonInactive then exit;
 If BeyondMaxYearEnd(RetNo) then exit;
 LetterType := 'Cover';

 Screen.Cursor := crHourGlass;
 RecalcBtnClick(Application);  //20090711
 UpdateAllDataIndicators(RetNo);
 Screen.Cursor := crDefault;

 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  If not MainForm.LeftPanel.visible then MainForm.AuditOpenBtnClick(Application);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Template ='' then exit;

 FastPrint:= GetFastPrintIndicator;
// If (Prov='FED') and (LandscapeFormsInFEDReturn(RetNo)=True) then FastPrint:=False;  //20160901 Igor
// If (Prov='ALB') and (LandscapeFormsInALBReturn(RetNo)=True) then FastPrint:=False;  //20160901 Igor
 FormsToPrint := TstringList.Create;
 GetFormsToPrint(RetNo,Template,FormsToPrint,Prov);

 ResortFormsToPrint(FormsToPrint);

 If FormsToPrint.Count =0 then
    begin
    ShowMessage('Selected template has no forms for printing');
    FormsToPrint.Free;
    exit;
  end;
 If ANotUsePrintDialog or PrintDialogItem.Execute then
   PrintReturn(RetNo,FormsToPrint,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName);
 FormsToPrint.Free;
end;

Function TMainFormT2_2027.GetPrintTemplate(IncludeFiling:Boolean):string;
begin
  {select print set}
 result :='';
 SomeList.Clear;  // := TStringList.Create;
 If IncludeFiling=True then SomeList.Add('Filing');
 SomeList.Add('Client');
 SomeList.Add('Preparer');
 SomeList.Add('Other 1');
 SomeList.Add('Other 2');
 SomeList.Add('Other 3');
 SelectedString := PopSomeList(SomeList,'Select Print Template');
 // SomeList.Free; //20160329 Igor
 If SelectedString =      'Filing'    then result := 'RvCanSet.d'
 else if SelectedString = 'Client'    then result := 'CLINTSET.D'
 else if SelectedString = 'Preparer'  then result := 'PREPSET.D'
 else if SelectedString = 'Other 1'   then result := 'OTH1SET.D'
 else if SelectedString = 'Other 2'   then result := 'OTH2SET.D'
 else if SelectedString = 'Other 3'   then result := 'OTH3SET.D';
 
end;



function TMainFormT2_2027.GetZoomStr: String;//20170911 Igor
begin
  Result := ZoomPercentLbl.Caption;
end;

procedure TMainFormT2_2027.T2BtnClick(Sender: TObject);
begin
If ButtonInactive then exit;
OpenForm(RetNo,GetFormNo('T2'),0);
end;

procedure TMainFormT2_2027.OnCreateMenuItem(const aName: string;  //20190228 Igor //20190415 Igor
  const aHelperID: Integer);
var
  Item: TActionClientItem;
begin
//  Item := RBGReturn_Help.Items[1].Items.Add;
//  Item.Action := actForCloud;
//  Item.Caption := aName;
//  Item.Tag := aHelperID;
end;

procedure TMainFormT2_2027.Onlinepayment1Click(Sender: TObject);
begin
 ConnectToWeb('https://apps.cra-arc.gc.ca/ebci/fppp/mypymnt/pub/ntr.action');  //20190626
end;

procedure TMainFormT2_2027.OntBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 Screen.Cursor := crHourGlass;

 If Ret[Retno].FedCalcStatus = False then CalcFed(RetNo);
 If Ret[Retno].OntCalcStatus = False then CalcOnt(RetNo);
 UpdateAllDataIndicators(RetNo);
 MyChild.UpdateChildTaxPanel;
 OpenForm(RetNo,GetFormNo('S5'),600);
 Screen.Cursor := crDefault;
end;

procedure TMainFormT2_2027.AlbBtnClick(Sender: TObject);
begin
If ButtonInactive then exit;
If Ret[Retno].FedCalcStatus = False then CalcFed(RetNo);
If Ret[Retno].AlbCalcStatus = False then CalcAlb(RetNo);
UpdateAllDataIndicators(RetNo);
MyChild.UpdateChildTaxPanel;
OpenForm(RetNo,GetFormNo('AT1'),0);
end;

procedure TMainFormT2_2027.GifiIsBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 If GetCorpBusNo(RetNo) ='' then
 begin
  ShowMessage('Please complete Business Number and Corporate Name first');
  Exit;
 end;

 OpenForm(RetNo,GetFormNo('S125#1'),0);

 {
 //ExecuteForm(TGifiISEditT2_2027);
  Application.CreateForm(TGifiISEditT2_2027,GifiISEdit);
  GifiISEdit.ExpandBtn1Click(Sender); //20131026
  GifiISEdit.ShowModal;
  GifiISEdit.Free;
 }
end;

procedure TMainFormT2_2027.FNotesBtnClick(Sender: TObject);
begin
If ButtonInactive then exit;
OpenForm(RetNo,GetFormNo('S141'),0);
end;

procedure TMainFormT2_2027.FilingcopyAlbertaRSI1Click(Sender: TObject);
begin
 If ButtonInactive then exit;


 //If UpperCase(InputBox('Alberta Netfile not released yet', 'Expected soon. Enter Password', '')) <> 'N/A' then exit; //20260731
 {If BeyondMaxYearEnd(RetNo) then exit;}

 If LicenseLevel = llDemo then
 begin
  ShowMessage('Printing of RSI forms is not included in the demo version');
  exit;
 end;

 If StillOldPrintSets then RevisePrintSets;

 Screen.Cursor := crHourGlass;
 RecalcBtnClick(Sender);  //20090711
 UpdateAllDataIndicators(RetNo);

 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  //MainForm.LeftPanel.Visible:=True;
  MainForm.GuiCommand(gcShowLeftPanel);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 ExecuteForm(TARsiFrmT2_2027);
 Screen.Cursor := crDefault;
end;

procedure TMainFormT2_2027.ClientPreparercopy2Click(Sender: TObject);
Var Template:String;
begin
 If ButtonInactive then exit;
 If BeyondMaxYearEnd(RetNo) then exit;
 If LicenseLevel = llDemo then
 begin
  ShowMessage('Printing not included in the demo version');
  exit;
 end;

// If UpperCase(InputBox('WAITING FOR ALBERTA CERTIFICATION', 'PSW', '')) <> 'N/A' then exit; //20211210  //20250808

 If StillOldPrintSets then RevisePrintSets;
 Template:=GetPrintTemplate(False);
 If Template>'' then PrintAReturn('ALB',Template);
end;

procedure TMainFormT2_2027.T106BtnClick(Sender: TObject);
begin
 //20180601
 If ButtonInactive then exit;
 if IsAuthorizedPreparer = false then Exit; //20190401
// If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit; //20250726  20211210
 OpenForm(GetCurrentRetNo,'T106',0);
 Exit;
end;

procedure TMainFormT2_2027.T1134BtnClick(Sender: TObject);
begin
 //20180519
 If ButtonInactive then exit;
 if IsAuthorizedPreparer = false then Exit; //20190401
// If UpperCase(InputBox('WAITING FOR CRA CERTIFICATION', 'PSW', '')) <> 'N/A' then exit; //20250726
 OpenForm(GetCurrentRetNo,'T1134#1',0);     //20180611
 Exit;
end;

procedure TMainFormT2_2027.T1135Efile1Click(Sender: TObject);
begin
//20180519
 If ButtonInactive then exit;
 if IsAuthorizedPreparer = false then Exit; //20190401
 OpenForm(GetCurrentRetNo,'T1135',0);
 Exit;
end;

procedure TMainFormT2_2027.T183CORPInformationonEFiling1Click(Sender: TObject);
begin
 If LicenseLevel = llDemo then
 begin
  ShowMessage('EFile not included in the demo version');
  exit;
 end;

 If ButtonInactive then exit;
 //20130530
 If IsEFiled(RetNo)=False then
 begin
  ShowMessage('Please indicate that Return is Efiled (on T2 page 1)');
 // +Chr(13)+ ' and then Print the T183CORP');
 end;
 If Ret[RetNo].FedCalcStatus = False then CalcFed(RetNo);
 //OpenForm(RetNo,GetFormNo('T2'),0);
  OpenForm(RetNo,GetFormNo('T183CP'),0); //20130621
end;

procedure TMainFormT2_2027.BuildandTransmit1Click(Sender: TObject);
Var OnlineNo,Password,Url,NetFileDir:String;
begin
 if IsAuthorizedPreparer = false then Exit; //20190401

 If RetinMem=0 then
 begin
   ShowMessage('Please open a tax return first');
   Exit;
 end;
 
if not AppT2.CheckAllowedBN(RetNo) then Exit; //20191015 Igor

 Barcodeprinting1Click(Sender);

end;

procedure TMainFormT2_2027.Buildreport1Click(Sender: TObject); //20180424 Igor
begin
  if IsEnterpriseVersion //20250628
  // LicenseLevel in [llPower..llMultiPower]
  then
    ReportBuilder(AppT2)
  else
  begin
    ShowMessage('Available only in the Enterprise version of the program');
    Exit;
  end;
end;

procedure TMainFormT2_2027.SetupEOLInternetFiling1Click(Sender: TObject);
begin
 ExecuteForm(TEOLSetUpT2_2027);
end;

procedure TMainFormT2_2027.SetZoomStr(const Value: String);//20170911 Igor
begin
  ZoomPercentLbl.Caption := Value;
  lblZoom.Caption := Value;
  lblZoom2.Caption := Value;
end;

procedure TMainFormT2_2027.EfileSetup1Click(Sender: TObject);
begin
 ShowMessage('D-File will not be applicable after Dec 31, 2008');

  ExecuteForm(TTransmitterT2_2027);
end;

procedure TMainFormT2_2027.SwapBtnClick(Sender: TObject);
begin
SwapReturns1Click(Sender);
end;

procedure TMainFormT2_2027.EFileBtnClick(Sender: TObject);
begin
//BuildandTransmit1Click(Sender);
end;

procedure TMainFormT2_2027.RolloverVisualTax1Click(Sender: TObject);
begin
  //20160226 Igor >>>>>>
  If getCurrentRetNo > 0 then
  begin
    ShowMessage('Please close all returns first');
    Exit;
  end;

  If OptRec.Dir_LastYr='' then
  begin
    ShowMessage('You should first enter the data directory you used last year'
                +Chr(13)+'See Configure | General Options | Data Directories');
    Exit;
  end;

  If not FileExists(OptRec.Dir_LastYr+'\' + ClientsDBLite) then // 20150909 Igor
  begin
//20160327 Igor >>>
    if not FileExists(OptRec.Dir_LastYr+'\' + ClientsTable_dbf) then
    Begin
//      if MessageDlg('Rollover client database have old format.'+#13#10+
//                    'Create a copy of the database in the new format?',
//                    mtConfirmation,[mbYes,mbNo],0) <> mrYes then exit;
//      if not ConvertOneTable(OptRec.Dir_LastYr+'\' + ClientsTable_dbf,
//                             OptRec.Dir_LastYr+'\' + ClientsDBLite,
//                             OptRec.SQLLitePassword.CurrentPassword) then exit;
//    End
//    else
//    Begin
//20160327 Igor <<<
      ShowMessage('Last Year'+Chr(39)+'s directory does not have a VisualTax Client data base'
                  +Chr(13)+'See Configure | General Options | Data Directories');
      Exit;
    End;
  end;
  //20160226 Igor <<<<<<<

  ExecuteForm(TRolloverT2_2027);
end;

procedure TMainFormT2_2027.RolloverCanTax1Click(Sender: TObject);
begin
// ShowMessage('CanTax rolover will be released soon');  Exit;

 If OptRec.Dir_LastYr='' then
 begin
  ShowMessage('To avoid repetive entry/selection of data directory you used last year'
  +Chr(13)+'You should enter Last Year Data Diretory in the Configuration window'
  +Chr(13)+'See Configure | General Options | Data Directories');
  //Exit;
 end;

 {
 If OptRec.Dir_LastYr='' then
 begin
  ShowMessage('You should first enter the data directory you used last year'
    +Chr(13)+'See Configure | General Options | Data Directories');
 // Exit;
 end;
 }
 ExecuteForm(TRollCtxT2T2_2027);
end;

procedure TMainFormT2_2027.RollOverfromTaxCycle1Click(Sender: TObject); //20170712 Igor
begin
//20170909 Igor>>>
 //20171214
 // ShowMessage('Rollover from TaxCycle coming soon...Contact VisualTax for availability'); //20170830
 // If UpperCase(InputBox('Input Box', 'Enter Password', '')) <> 'N/A' then exit;
//20170909 Igor<<<
    RollOverFromTaxCycle(AppT2, '2026T2,2025T2,2024T2'); //20260805 Alex
end;

procedure TMainFormT2_2027.RolloverProfile1Click(Sender: TObject);
begin
 {20171214
 ShowMessage('Rollover from Profile coming soon...Contact VisualTax for availability'); //20170830
 If UpperCase(InputBox('Input Box', 'Enter Password', '')) <> 'N/A' then exit;
 }
 //20170909 Igor<<<
 //20171214
 If OptRec.Dir_LastYr='' then
 begin
  ShowMessage('To avoid repetive entry/selection of data directory you used last year'
  +Chr(13)+'You should enter Last Year Data Diretory in the Configuration window'
  +Chr(13)+'See Configure | General Options | Data Directories');
  //Exit;
 end;

 ExecuteForm(TImportGpT2_2027);
end;

procedure TMainFormT2_2027.ImportBtnClick(Sender: TObject);
begin
  If OptRec.RolloverProgram='' then
  begin
   ShowMessage('Please enter Last year'+Chr(39)+'s program name in'
   +Chr(13)+'Configure | General Options | Data Directories');
   Exit;
  end;
  SelectedString:=OptRec.RolloverProgram;
  If LeftStr(SelectedString,6) = 'Visual' then
     RolloverVisualTax1Click(Sender)
  else If LeftStr(SelectedString,7) = 'Profile' then
     RolloverProfile1Click(Sender)
  else If LeftStr(SelectedString,6) = 'CanTax' then
     RolloverCanTax1Click(Sender);
end;

procedure TMainFormT2_2027.RollOvrerLblClick(Sender: TObject);
begin
ImportBtnClick(Sender);
end;

procedure TMainFormT2_2027.GIFIBSFullChartofAccountsreference1Click(
  Sender: TObject);
begin //20150623
 {Application.CreateForm(TRepBSAccountsT2_2027,RepBSAccounts);
 AQrReport := RepBSAccounts.QuickRep1;
 AQrReport.Preview;
 RepBSAccounts.Free;}
end;

procedure TMainFormT2_2027.GIFIBSFullChartofAccountsreference2Click(
  Sender: TObject);
begin //20150623
 {Application.CreateForm(TRepIsAccountsT2_2027,RepISAccounts);
 AQrReport := RepISAccounts.QuickRep1;
 AQrReport.Preview;
 //Report.Print;
 RepISAccounts.Free;}
end;

procedure TMainFormT2_2027.Builda5yearcomarativesummary1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 ExecuteForm(TBuildGPHistT2_2027);
end;

procedure TMainFormT2_2027.GIFIGuide1Click(Sender: TObject);
begin
 ShowPdf(AppDir,'RC4088.pdf');
end;

procedure TMainFormT2_2027.AlbertaAT1GuidePart11Click(Sender: TObject);
Var h:Word;
begin
  ShowPdf(AppDir,'2005 AT1Guide Part 1.pdf');
end;

procedure TMainFormT2_2027.CT23Guide1Click(Sender: TObject);
begin
// ShowPdf(AppDir,'CT23-Guide.pdf');
end;

procedure TMainFormT2_2027.FindKeyWordintheform1Click(Sender: TObject);
Var i:Integer;TempList:TStringList;KeyW:String;
begin
  ShowMessage('This feature is not active');
end;

procedure TMainFormT2_2027.ResetclientDB1Click(Sender: TObject); //20160305 Igor
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

procedure TMainFormT2_2027.Resetpasswordwithreturn1Click(Sender: TObject); //20170409 Igor
begin
  if not OpenDialog.execute then exit;
  if RemovePasswordReturn(OpenDialog.FileName) then
    MessageDlg('Reset password completed', mtInformation, [mbOk],0);
end;

procedure TMainFormT2_2027.ResourceTaxation1Click(Sender: TObject);
begin
  ShowPdf(AppDir,'Res-Tax.pdf');
end;

procedure TMainFormT2_2027.ProvincialRates1Click(Sender: TObject);
begin
 ExecuteForm(TPrvRatesT2_2027);
end;

procedure TMainFormT2_2027.AlbertaTaxGuidePart21Click(Sender: TObject);
begin
 ShowPdf(AppDir,'2005 AT1Guide Part 2.pdf');
end;

procedure TMainFormT2_2027.AlertsNotifications1Click(Sender: TObject);
begin
 ConnectToWeb('www.VisualTax.com/vtAlert.html');  //2020048
end;

procedure TMainFormT2_2027.YSumBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 Screen.Cursor:=CrHourGlass;
 //CalcFed(RetNo);
 CalcOnt(RetNo);
 CalcAlb(RetNo);
 MainForm.RefreshAuditPanel(RetNo); //20090708
 Screen.Cursor:=CrDefault;
 Calc(RetNo,'TAXSUM');
 ComparativeSummaryClick(Application);
end;

procedure TMainFormT2_2027.QuickFindBtnKeyPress(Sender: TObject; var Key: Char); //20160711 Igor
begin
  If key = #13 then
    actFindFormExecute(nil);
end;

procedure TMainFormT2_2027.QuickStarterGuide1Click(Sender: TObject);
begin
 ConnectToWeb('www.visualtax.com/Vt2018HELP/T2Help/Website/Quick_Start_guide.html');
//  ShowHelp(AppT2.ModuleHelpFile, 'Quick_Start_Guide', True); //20161220 Igor //20190625
// ConnectToWeb('www.visualtax.com/Vt2017HELP/T2Help/Website/Index.html'); //20161220 Igor

end;

procedure TMainFormT2_2027.PrintMailingLabelcurrentclient1Click(Sender: TObject);
Var Line1,Line2,Line3,Line4,Line5:String;
  LabelPosX, LabelPosY : Integer;
  TopMargin,LeftMargin,LabelHeight, LabelWidth, VertIncr, HorizLabelGap:Integer;
begin
 If ButtonInactive then exit;

 if Printer.Printing then //20160902 Igor
   printer.EndDoc;        //20160902 Igor
 If not PrintDialogItem.Execute then exit;
 Printer.BeginDoc;

 If FetchElm(RetNo,'T2',21)='' then  //same with HO
 begin
  Line1 := FetchElm(RetNo,'T2',3); //corp nm
  Line2 :='';
  Line3 := FetchElm(RetNo,'T2',12)+' '+FetchElm(RetNo,'T2',13); //str
  //Line3 := FetchElm(RetNo,'T2',16);  // city
  Line4 := FetchElm(RetNo,'T2',16)+ ' '+FetchElm(RetNo,'T2',17);
  Line5:=FetchElm(RetNo,'T2',20)
          + ' '+FetchElm(RetNo,'T2',19); //prov and postal, country
 end
 else  //diferent than ho
 begin
  Line1 := FetchElm(RetNo,'T2',3); //corp nm
  If FetchElm(RetNo,'T2',23)>'' then
   Line2:='c/o '+FetchElm(RetNo,'T2',23)
  else
   Line2:=' ';
  Line3 := FetchElm(RetNo,'T2',26)+' '+FetchElm(RetNo,'T2',27); //str
  //Line3 := FetchElm(RetNo,'T2',32);  // city
  Line4 := FetchElm(RetNo,'T2',32)+' '+FetchElm(RetNo,'T2',33);
  Line5:=FetchElm(RetNo,'T2',35)
              + '   '+FetchElm(RetNo,'T2',34); //prov and postal, country
 end;
 PixPerInX := GetDeviceCaps(Printer.Handle,LOGPIXELSX);
 PixPerInY := GetDeviceCaps(Printer.Handle,LOGPIXELSY);
 TopMargin  := Trunc(0.5 *  PixPerInY);
 LeftMargin := Trunc(1/8 *  PixPerInY);
 LabelHeight:= Trunc(1   * PixPerInY);  {1 inch}
 LabelWidth := Trunc(2.5 * PixPerInX);    {2.5 inches}
 VertIncr :=  Trunc(PixPerInY * (1/6));   {6 lines per inch}
 HorizLabelGap := Trunc(1/8 *  PixPerInX);

 LabelPosX := LeftMargin;
 LabelPosY := TopMargin; //+LabelHeight;

 PrintALabel(LabelPosX,LabelPosY,Line1,Line2,Line3,Line4, Line5);
 Printer.EndDoc;
end;

procedure TMainFormT2_2027.QuickStartLblClick(Sender: TObject);
begin
QuickStarterGuide1Click(Sender);
end;

procedure TMainFormT2_2027.rbnT2RecentItemClick(Sender: TObject;
  FileName: string; Index: Integer);
begin
  ListView1.ItemIndex := Index;
  OpenItBtnClick(OpenItBtn);
end;

procedure TMainFormT2_2027.Barcodeprinting1Click(Sender: TObject);
begin
 if IsAuthorizedPreparer = false then Exit; //20190401

 //20200618
 if AllTrim(OptRec.Prp_Name)='' then
 Begin
  ShowMessage('Please complete the Configure -> General Options -> Preparer information');
  Exit;
 End;

If LicenseLevel = llDemo then
 begin
  ShowMessage('Printing of filing copy not included in the demo version');
  exit;
 end;
 If ButtonInactive then exit;
 If BeyondMaxYearEnd(RetNo) then exit;

 //20170301
 if Ret[RetNo].Changed=True then
 Begin
  ShowMessage('Better Save the return before proceeding');
 // Exit;
 End;

 If StillOldPrintSets then RevisePrintSets;

 Screen.Cursor := crHourGlass;
 RecalcBtnClick(Sender);  //20090711
 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  If not MainForm.LeftPanel.visible then MainForm.AuditOpenBtnClick(Application);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;
 AmendCnt:=0; S88Cnt:=0;
{ TODO -oCon : why CountDiagnostics twice? }
(*
 Ret[RetNo].ErrorCount := CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  MainForm.LeftPanel.Visible:=True;
  ShowMessage('Return has Errors as shown in the Audit Wizard.'
  +Chr(13)+'Please fix before printing the filing copy');
  Screen.Cursor := crDefault;
  Exit;
 end;
*)
 Screen.Cursor := crDefault; {HourGlass;}
 ExecuteForm(TBarDataGenT2_2027);
end;

procedure TMainFormT2_2027.SignOffWarnings1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  SignOffAWarning(RetNo);
end;

procedure TMainFormT2_2027.DividendTaxation1Click(Sender: TObject);
begin
  ConnectToWeb('http://www.fin.gc.ca/drleg/ITAdtc06_2e.html#Explanatory Notes');
end;

procedure TMainFormT2_2027.Special1Click(Sender: TObject);
Var psw:String;
begin
 Psw:= InputBox('Input Box', '', '');  If UpperCase(PSW) <> 'DODI1' then exit; //20191026

 ExecuteForm(TSpecialGpT2_2027);
end;

procedure TMainFormT2_2027.ShortDateFormat1Click(Sender: TObject);
begin
 ShowMessage(FormatSettings.ShortDateFormat);
end;

procedure TMainFormT2_2027.BitBtn4Click(Sender: TObject);
begin
  SignOffWarnings1Click(Sender);
  //MainForm.SignOffWarnings1Click(Sender);
end;


procedure TMainFormT2_2027.btnDownloadClick(Sender: TObject); //20190211 Igor
var Dir, FlName: String;
    AListItem: TListItem;
    Files: TArray<String>;
    I: integer;
begin
  if not CheckIsCloud(true) then Exit;
  for I := 0 to ListView1.Items.Count - 1 do
    if ListView1.Items[i].Checked or (Sender = btnDownloadAll) then
    begin
      FlName := TPath.Combine(AllTrim(ListView1.Items[i].SubItems[3]), AllTrim(ListView1.Items[i].SubItems[2]));
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
    AListItem := ListView1.ItemFocused;
    if AListItem = nil then
    begin
      ShowTimedMsg('You must select a file first', 1200);
      Exit;
    end;
    FlName := TPath.Combine(AllTrim(AListItem.SubItems[3]), AllTrim(AListItem.SubItems[2]));
    if not FileExists(FlName) then
    begin
      ShowMessage('File '+ FlName +' is not found!');
      Exit;
    end;
    SetLength(Files, Length(Files) + 1);
    Files[Length(Files) - 1] := FlName;
  end;
  DownloadFiles(Files);
end;

procedure TMainFormT2_2027.btnUploadClick(Sender: TObject); //20190211 Igor
var Files: TArray<String>;
    RetNo, I: Integer;
    Err: string;
begin
  if not CheckIsCloud(true) then Exit;
  if not FileExists(OptRec.Dir_Cur + '\' + ClientsDBLite) then
  begin
    if not InitDataBase(AppDir, OptRec.Dir_Cur, Err) then
    begin
      ShowMessage(Err);
      Exit;
    end;
  end;
  Files := UploadFile(OptRec.Dir_Cur, false);
  for I := 0 to Length(Files) - 1 do
  begin
    RetNo := OpenReturn(OptRec.Dir_Cur, Files[I], True);
    if RetNo <> 0 then
    begin
      SaveReturn(RetNo, OptRec.Dir_Cur, Files[I], true, true);
      ShowReturn(RetNo);
    end;
  end;
end;

procedure TMainFormT2_2027.btnUploadWithoutOpenClick(Sender: TObject); //20190211 Igor
var Files: TArray<String>;
    RetNo, I, Count: Integer;
    Err: string;
begin
  if not CheckIsCloud(true) then Exit;
  if not FileExists(OptRec.Dir_Cur + '\' + ClientsDBLite) then
  begin
    if not InitDataBase(AppDir, OptRec.Dir_Cur, Err) then
    begin
      ShowMessage(Err);
      Exit;
    end;
  end;
  Files := UploadFile(OptRec.Dir_Cur, false);
  Count := 0;
  for I := 0 to Length(Files) - 1 do
  begin
    RetNo := OpenReturn(OptRec.Dir_Cur, Files[I], False);
    if RetNo <> 0 then
    begin
      SaveReturn(RetNo, OptRec.Dir_Cur, Files[I], true, true);
      CloseReturn(RetNo);
      inc(Count);
    end;
  end;
  if Count > 0 then
    ShowMessage(IntToStr(Count) + ' returns have been uploaded to vtCloud' +chr(13)+'You can now open them via the Client book');
end;

procedure TMainFormT2_2027.SEQGIFIIS1Click(Sender: TObject);
Var Seq:String;
    ADConnection: TADConnection;
    Tbl: TADTable;
begin
 if MessageDlg('Are you sure?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 //continue
 else
   Exit;

  //20150923 Igor
  ADConnection:= TADConnection.Create(Application);
  Tbl := TADTable.Create(Application);
  SetTableName(ADConnection, Tbl, AppDir + '\' + GiFiisDBLite, GiFiisTableLite, ''); // Tbl.IndexName:='PRNSEQ'; //20091129


 Seq:='00010';
 Tbl.First;
 while not Tbl.EOF do
 begin
   Tbl.Edit;
   If Tbl.FieldByName('CALCULATED').AsString<>'Y' then
   begin
    Tbl.FieldByName('PRNSEQ').AsString:=Seq;
    Tbl.post;
   end;
   seq:=PaddZero(IntToStr(StrToInt(Seq)+10),5);
   Tbl.Next;
 end;
 Tbl.Close;
 Tbl.free;
 ADConnection.free;
 ShowMessage('Done');
end;

procedure TMainFormT2_2027.SERSAttachaDocSpecialEfectionsReturns1Click(
  Sender: TObject);
begin
 //ShowMessage('SERS Efiling is not released yet'); //20250726
end;

procedure TMainFormT2_2027.SEQGIFIBS1Click(Sender: TObject);
Var Seq:String;
    ADConnection: TADConnection;
    Tbl: TADTable;
begin
 if MessageDlg('Are you sure?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
 //continue
 else
   Exit;

  //20150923 Igor
  ADConnection:= TADConnection.Create(Application);
  Tbl := TADTable.Create(Application);
  SetTableName(ADConnection, Tbl, AppDir + '\' + GiFibsDBLite, GiFibsTableLite, ''); // Tbl.IndexName:='PRNSEQ'; //20091129

 Seq:='00010';
 Tbl.First;
 while not Tbl.EOF do
 begin
   Tbl.Edit;
   If Tbl.FieldByName('CALCULATED').AsString <>'Y' then
   begin
    Tbl.FieldByName('PRNSEQ').AsString:=Seq;
    Tbl.post;
   end;
   seq:=PaddZero(IntToStr(StrToInt(Seq)+10),5);
   Tbl.Next;
 end;
 Tbl.Close;
 Tbl.free;
 ADConnection.free;
 ShowMessage('Done');
end;

procedure TMainFormT2_2027.vtScan1Click(Sender: TObject);
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

procedure TMainFormT2_2027.ReviewFilesinCLIENTDOCS1Click(Sender: TObject);
Var InitDir,FullFlName,FlName:String;h:Word;PgmPath:String;PgmFile:String;
   RetNo:Integer;
begin
 if CheckIsCloud then Exit; //20180503 Igor
 RetNo:=GetCurrentRetNo;
 If ButtonInactive then exit;
  case CaseDo('',
   [
    'Open Document Folder',
    'Open Permanent Folder'
    ], nil) of
   // vtScan
   1: Dir := optRec.Dir_PermanentDocs+'\'+MkDirforClientDocs(RetNo);//optRec.Dir_PermanentDocs + '\' + GetLastName(retNo) + ','+ GetFirstName(retNo);
  else
    Dir := optRec.Dir_ClientDocs + '\' +MkDirforClientDocs(RetNo);
  end;
  if not DirectoryExists(Dir) then ForceDirectories(Dir); //20200322
  if not DirectoryExists(Dir) then
    ShowMessage('Directory does not exist')
  else
    ShellExecute(Application.Handle, 'open', PChar(Dir), nil, nil, SW_SHOWNORMAL) ;

 (* initial fom T2
 if CheckIsCloud then Exit; //20180503 Igor
 RetNo:=GetCurrentRetNo;
 InitDir:=optRec.Dir_ClientDocs+'\'+MkDirforClientDocs(RetNo);
 If DirectoryExists(InitDir) = false then
 begin
  ShowMessage('No documents found');
  Exit;
 end;
 OpenDialog.InitialDir:=InitDir;
 If OpenDialog.Execute then
 begin
  FullFlName :=OpenDialog.FileName;
  PgmPath:=ExtractFileDir(FullFlName);
  PgmFile:=ExtractFileName(FullFlName);
  OpenAnyFile(PgmPath,PgmFile);
 end;
*)
(* From T1
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
 *)
end;

procedure TMainFormT2_2027.SavereturninPDFFormatinClientDocs1Click(Sender: TObject);
Var
  PDFFullfileName: String;
  RetNo:Integer;
  Template, Prov: String; //20161211 Igor
  FormsToPrint: TstringList; //20161211 Igor
begin
  If ButtonInactive then exit;
    RetNo:=GetCurrentRetNo;
    //20180503 Igor >>>
    Dir:=optRec.Dir_ClientDocs+'\'+MkDirforClientDocs(RetNo);
    ForceDirectories(Dir);
    FlName:='T2 Return-YE-'+LeftStr(GetTaxationYearEnd(RetNo),4);
    if CheckIsCloud(true) then
      PDFFullfileName := ChangeFilePath(FlName, Dir)
    else
    begin
      SaveDialog.Title    := 'Save to PDF';
      SaveDialog.InitialDir := Dir;
      SaveDialog.Filter :=  'PDF|*.pdf';
      SaveDialog.FileName :=FlName;
      SaveDialog.DefaultExt := '.pdf';
      SaveDialog.Options := [ofOverwritePrompt,ofPathMustExist];
      //20160910 Igor>>>
      if not SaveDialog.Execute then
        exit;
      PDFFullfileName := SaveDialog.FileName;
    end;
    //20180503 Igor >>>
(* //20161211 Igor
    AdjustFinePrintRegistrySettings(PDFFullfileName);
    try
*)
  //    If SaveDialog.Execute then PDFFullfileName := SaveDialog.FileName;
  //    AdjustFinePrintRegistrySettings(PDFFullfileName,2,0,999);
      //20160910 Igor <<<
    //20161211 Igor >>>
    If LicenseLevel = llDemo then
    begin
      ShowMessage('Printing not included in the demo version');
      exit;
    end;
    If ButtonInactive then exit;
    If BeyondMaxYearEnd(RetNo) then exit;
    Template := GetPrintTemplate(False);
    If Template > '' then
    begin
      FormsToPrint := TstringList.Create;
      try
        prov := 'FED';
        GetFormsToPrint(RetNo, Template, FormsToPrint, Prov);

        ResortFormsToPrint(FormsToPrint);

        If FormsToPrint.Count =0 then
        begin
          ShowMessage('Selected template has no forms for printing');
          exit;
        end;
        SaveReturnToPDF(RetNo, FormsToPrint, optRec.Dir_Cur, PDFFullfileName);

        if MessageDlg('Return printout has been saved in "' + PDFFullfileName + '".'+#13+
                      'Review it?', mtInformation, [mbYes, mbCancel], 0) = mrYes then
          OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
      finally
        FormsToPrint.Free;
      end;
    end;
end;


Procedure TMainFormT2_2027.SelectFeatures;
Var gap:Longint;
Begin
  if Application.Terminated then exit; //20161108 Igor
(* Called when?
  from single:FormPaint
*)
//toolbar
  ZoomStr:=IntToStr(OptRec.FormZoom)+'%'; //20180117 Igor
 {Main Menu}
 {Efile, EFile-online}
 {Open by file Name}
  if LicenseLevel in anyLimited
  then
   OpenByFileName1.Visible := False;


  {multi office}
  If not (LicenseLevel in anyMulti)
  then
  begin
    UserSetUp1.Visible := False;
  end;

//splash
  AppReleaseLbl.Caption:= 'Release: '+AppVersion; //'Release: '+AppRelease;
  AppUpdateDateLbl.Caption:= 'Updated: '+AppUpdateDate;
 // TradeMarkLbl.Caption := 'VisualTax'; //20191202 Igor
  TradeMarkLbl.Font.Size :=20;
 // TradeMarkSymbolLbl.Visible := True;
  LicenseLevelLbl.Caption := 'Version: '+AppT2.ProductName;
  (* //20191202 Igor >>>
  If LicenseLevel in anyMulti then
  begin
    If Length(Licensee) >0 then
    begin
     If Length(Licensee) < Length('VisualTax') then
         TradeMarkLbl.Font.Size :=20
     else
         TradeMarkLbl.Font.Size :=20;
     TradeMarkLbl.Caption := Licensee;
    // TradeMarkSymbolLbl.Visible := False;
   end;
  end;
  //20191202 Igor <<< *)
  ShowMostRecentReturns; //20170112 Igor
end;

// --- 2014-07-29 ---

procedure TMainFormT2_2027.CloseBlackBoxBtnClick(Sender: TObject);
Var Templist:TStringList;
begin
(*
 If FileExists(BlackBoxDir+'\'+'T1BlBox1.txt') then DeleteFile(BlackBoxDir+'\'+'T1BlBox1.txt');
 If GetCurrentRetNo>0 then
 begin
    //CloseRetWindows(RetNo);
    DeEnlistReturn(GetCurrentRetNo);
    dec(RetInMem);
 end;
 ServerMode:=False;
 Application.Terminate;
 *)
end;

procedure TMainFormT2_2027.KnownIssuesLbkClick(Sender: TObject);
begin
//misspelled, forward
  KnownIssues1Click(Sender);
end;

procedure TMainFormT2_2027.OpenfromCloudDropBox1Click(Sender: TObject);
begin
  ConnectToWeb('https://www.dropbox.com/home');
end;

procedure TMainFormT2_2027.GoToaFormSection1Click(Sender: TObject);
begin
 //UHeaderFrame.SectionBtnClick(Sender);
end;

procedure TMainFormT2_2027.Line1Click(Sender: TObject);
var
  s: string[4];
  ADConnection: TADConnection;
  Table1: TADTable;
begin
(*
  If ButtonInactive then exit;
  s := InputBox('Go to Line Number...', 'Line Number (Normal or EFile)', '');
  If s = '' then exit;
  Table1 := TTable.Create(Application);
  Table1.DataBaseName := AppDir;
  Table1.TableName := DataDict.DB F; {EFLines.DB F;}
  Table1.IndexName := 'LineNo';
  Table1.Open;
  if Table1.FindKey([s]) then
    Begin
     OpenAtFieldId := Table1.FieldByName('Elm').AsInteger;
     OpenForm(RetNo,GetFormNo(Table1.FieldByName('FormName').AsString));
     Table1.Close; Table1.Free;
     exit;
    end
   else
    begin
    ShowMessage('Line number Not Found');
    Table1.Close; Table1.Free;
    end;
*)
end;

procedure TMainFormT2_2027.RestructuretheClientsDataBase1Click(
  Sender: TObject);
begin
(*
 Application.CreateForm(TRestructure,Restructure);
 Restructure.ShowModal;
 Restructure.Free;
 *)
end;

procedure TMainFormT2_2027.TestBlBoxClick(Sender: TObject);
Var FrmNm:String;RetNo:Integer;
begin
 (*
 RetNo:=GetCurrentRetNo;
 FileNewItemClick(Sender);
 CalcBlackBox(AppDir+'\'+'T1BlBox1.Txt',RetNo);
 If UpperCase(AllTrim(LeftStr(BlackBoxFunctionLine,10)))='SHOW' then
  begin
   FrmNm:=MidStr(BlackBoxFunctionLine,11,10);
   OpenForm(RetNo,GetFormNo(FrmNm),0);
  end
  else OpenForm(RetNo,GetFormNo('INFO'),0);


 *)
end;

procedure TMainFormT2_2027.KnownIssues1Click(Sender: TObject);
begin

  ConnectToWeb('https://www.visualtax.com/t2knownissues.php'); //20210630
 //ConnectToWeb('HTTP://www.VisualTax.com/T2KnownIssues.Asp');
end;

procedure TMainFormT2_2027.T2GuideCRAWebsite1Click(Sender: TObject);
begin
 ConnectToWeb('http://www.cra-arc.gc.ca/E/pub/tg/t4012-21e.pdf'); //20160629

end;

// ----------------- splash ------------------------

procedure TMainFormT2_2027.TutorialsLblClick(Sender: TObject);
begin //lbl4
(* can this be really uniform for all AppIds?
*)
  //TUTORIALS1Click(Sender);
  MainForm.GuiCommand(gcTutorials);
end;

procedure TMainFormT2_2027.TUTORIALS1Click(Sender: TObject);
begin
  TutorialsLblClick(Sender);
end;


procedure TMainFormT2_2027.OpenItBtnClick(Sender: TObject);
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
  //MyRet := CurApp.OpenReturn(Dir, FlName);
  RetNo := OpenIt(Dir, FlName); // CurApp.OpenReturn(Dir, FlName);
end;

function TMainFormT2_2027.OpenIt(const Dir,FlName:String): integer;
//procedure TMainFormT2_2013.OpenItBtnClick(Sender: TObject);
Var
  i,ThisResult:Integer;//Dir,FlName,
 //AListItem:TListItem;
 //RetNo:Integer;
 MyRet: TRetT2_2027;  // absolute Result;
begin
  //RetNo:=InitNewReturn;
  //If RetNo=0 then exit;
  Result := OpenReturn(Dir,FlName,True); //20220520 Igor
  //Screen.Cursor:=crHourGlass;
  //20190211 Igor >>>
  ShowReturn(Result);
  {If Result > 0 then
  begin
    Screen.Cursor:=crHourGlass;
    FRetNo := Result;
    CountDiagnostics(RetNo);
    MainForm.RefreshAuditPanel(RetNo); //does it all
    FormName := 'T2';
    FormNo := GetFormNo(FormName);
    //20170511 Igor >>>
    vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
    try
    //20170511 Igor <<<
      OpenForm(RetNo,FormNo,0);
      OpenUsedForms(RetNo);
      Screen.Cursor:=crDefault;
      MainForm.GuiCommand(gcShowLeftPanel); //20160220 Igor
    //20170511 Igor >>>
    finally
      vtChild.CreateNewMDIChild(RetNo, '').ShowAllControls;
    end;
    //20170511 Igor <<<
  end; //result    }
  //20190211 Igor <<<
end;

procedure TMainFormT2_2027.EMailItBtnClick(Sender: TObject);
Var i:Integer;Dir,FlName:String; AListItem:TListItem;
begin
  AListItem:=ListView1.ItemFocused;
  If AListItem = Nil then
  begin
   ShowTimedMsg('You must select a file first',1200);
   Exit;
  end;

  FlName := AllTrim(AListItem.SubItems[2]);
  Dir:=AllTrim(AListItem.SubItems[3]);

 If LicenseLevel in anyMulti then
 begin
   If not User.EqualOverloadProperty(AppT2, 'Dir_Cur', Dir, true) then //20170112 Igor
   begin
    If YouKnowTheAdminPassword = false then exit;
   end;
 end;
 EMailIt(Dir, FlName);
end;

procedure TMainFormT2_2027.EMailIt(const Dir, FlName: string);  //: eEmailResult;
//procedure TMainFormT2_2013.EMailItBtnClick(Sender: TObject);
(* Called from main form, removed all mainform component references
*)
Var
  i:Integer;
  SomeSubject,SomeRecipientEMail,SomeSenderEMail,SomeAttachment:String;
  SomeText:String;
begin
 SomeList.Clear;  // := TStringList.Create;
 SomeList.Add('1. Email the tax return (raw data file) to your own EMail...');
 SomeList.Add('2. Email the tax return (raw data file) to tax return Reviewer...');
 SomeList.Add('3. Email the tax return (raw data file) to VisualTax support...');
 SomeList.Add('4. Email the tax return (raw data file) to any Email address...');
 SomeList.Add('________________________________________________________________');
 SomeList.Add('5. EMail the tax return (Printout only) to any Email address...');
 SomeList.Add('   See also: Print|Email current form...(after opening the return)');

  SelectedString := PopSomeList(SomeList,
    'Double click on item 1, 2, 3 or 4');
  //SomeList.Free; //20160704 Igor
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

  SomeSenderEmail:='';  //default?  'VisualTax@Sympatico.ca';
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
   SendMapiMail(AnsiString(SomeSubject), AnsiString(SomeText), AnsiString(SomeAttachment),
      '', '', '', AnsiString(SomeRecipientEMail)); //20150702
 end;
 If (SelectedString ='5') then
 begin
   //OpenItBtnClick(Sender);
   OpenIt(Dir, FlName);
   EmailTheReturnClick(nil);
 end;
end;

procedure PrintReturnForEmail(RetNo: integer;Template: string);
begin
//does nothing
end;

procedure TMainFormT2_2027.EmailTheReturnClick(Sender: TObject);
 Var i,j: integer; FormsToPrint :TstringList;
    Copies,Template :string;
    s:String;RetNo:Integer;
begin
 RetNo:=GetCurrentRetNo;
 If ButtonInactive then exit;
 CalcFed(RetNo);
 CalcOnt(RetNo);
 CalcAlb(RetNo);

 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  If not MainForm.WizardPanel.visible then MainForm.AuditOpenBtnClick(Sender);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Not AllowedToFullPrint(RetNo) then begin PdfPrint:=False;exit;end;

 Calc(RetNo,'DIAGNO');
 //LetterType := 'Cover';

 If Ret[RetNo].FedCalcStatus = False then CalcFed(RetNo);
 If Ret[RetNo].OntCalcStatus = False then CalcOnt(RetNo);
 If Ret[RetNo].AlbCalcStatus = False then CalcAlb(RetNo);

 UpdateAllDataIndicators(RetNo);
 //If SlipsAvailable(RetNo) then Ret[RetNo].FrmHasData[GetFormNo('T4SUM#1')] := True;

 Template := GetPrintTemplate(True);

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

procedure TMainFormT2_2027.mnSelAppClick(Sender: TObject);
begin
  ShowSplash;
end;

procedure TMainFormT2_2027.TestFrm1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  OpenForm(RetNo,'TESTFRM',0);
end;

procedure TMainFormT2_2027.TileVertical1Click(Sender: TObject);
begin
  MainForm.TileVertical1Click;
end;

//20151017 Igor
procedure TMainFormT2_2027.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := false;
  // 20151017 Convert *.dbf => *.db on OptRec.Dir_Cur and AppDir
  //20160118 Igor
  vtDataModuleUnit.{vtDataModule.}DataBaseCreate(AppT2.SQLLitePassword,AppT2.ClientsDBLite,IncludeTrailingPathDelimiter(OptRec.Dir_Cur), IncludeTrailingPathDelimiter(AppDir));
end;

procedure TMainFormT2_2027.TileHorizontally1Click(Sender: TObject);
begin
  MainForm.TileHorizontally1Click;
end;

procedure TMainFormT2_2027.TileReturnsVertically1Click(Sender: TObject);
begin
  MainForm.TileVertical1Click;
end;

procedure TMainFormT2_2027.TileReturnsHorizontally1Click(Sender: TObject);
begin
  MainForm.TileHorizontally1Click;
end;

procedure TMainFormT2_2027.TRTaxResearch1Click(Sender: TObject);
begin
   If IsTrLoaded = false then
   begin
    TrFolder:=GetTrFolder;
    LoadTr(TrFolder);
   end
   else
   begin
    LinkToTr(''); { TODO -oCon : which SearchItem? }
   end;
end;

procedure TMainFormT2_2027.Notepad1Click(Sender: TObject);
begin
  OpenForm(RetNo,GetFormNo('NPAD#1'),0);
end;

procedure TMainFormT2_2027.Notepadwithamounts1Click(Sender: TObject);
begin
  OpenForm(RetNo,GetFormNo('NPADC#1'),0);
end;

procedure TMainFormT2_2027.PrivateNotepad1Click(Sender: TObject);
begin
  OpenForm(RetNo,GetFormNo('PRIVAT#1'),0);
end;

// --------- Field Popup ----------------------

var //initialized by NotEditCommand
  SenderClass: string;
  MyEditBox: TvtEdit;
  //MyScrollBox: TvtScrollBox;
  FieldId: integer;
  //FormName: string;

function TMainFormT2_2027.NotEditCommand: boolean;
var
  cmp: TComponent;
begin
(* determine commonly used values for vtEdit field
  use Screen.ActiveControl
*)
  //SenderClass := Sender.ClassName; //mostly for debugging, is TMenuItem!
  cmp := Screen.ActiveControl;
  SenderClass := cmp.ClassName;
  Result := not (cmp is TvtEdit);
  if Result then exit; //same exit in caller
  MyEditBox := TvtEdit(cmp);
  MyForm := GetMyScrollBox(MyEditBox);
  FieldId := MyEditBox.FieldId;
  FRetNo := MyScrollBox.RetNo; //private in this class
  FormName := MyScrollBox.FormName;
  FormNo := MyScrollBox.FormNo;
  MyChild := RetList[RetNo].MyChild;
end;

procedure TMainFormT2_2027.RemovecurrentfieldoverrideClick(Sender: TObject);
//Var REtNo:Integer;
begin
  if NotEditCommand then exit;

 //RetNo:=GetCurrentRetNo;
 If (RetNo >0) and (FormNo >0) and (FieldId >0) then
  begin
   RemoveFieldOverride(RetNo,FormNo,FieldId);
   Calc(RetNo,FormName);
   CalcFed(RetNo);
   CalcOnt(RetNo);
   CalcAlb(RetNo); //CalcAll(RetNo);
   //MyChild.FormPaint(Sender);
   {InvalidateRect(GetFormHandle(RetNo, FormNo),Nil,TRUE);}
  end;

end;

procedure TMainFormT2_2027.Lockamountoncurrentfield1Click(Sender: TObject);
begin
  if NotEditCommand then exit;
  If (RetNo >0) and (FormNo >0) and (FieldId >0) then
     SetFieldOverride(RetNo,FormNo,FieldId);
end;

procedure TMainFormT2_2027.ReviewBtnClick(Sender: TObject);
begin
  if NotEditCommand then exit;

  MyForm.ToggleReview(MyEditBox);

end;

procedure TMainFormT2_2027.HelpBtnClick(Sender: TObject);
Var HlpContextString :string;
begin
  if NotEditCommand then exit;
 // Application.HelpFile := AppDir+'\'+'T2Help.HLP';
  HlpContextString := StripInstNo(ExtractFormRootName(FormName));
  ShowHelp(AppT2.ModuleHelpFile, HlpContextString, True); //20161220 Igor
end;

// --------- FieldPopups from ChildWin.EditBoxMouseDown ---------------
//20171124 Igor>>
procedure TMainFormT2_2027.actAutoFillGuideExecute(Sender: TObject);
begin
 ConnectToWeb('http://www.visualtax.com/Autofill-Guide.pdf');
end;
//20171124 Igor<<

procedure TMainFormT2_2027.actChangeSkinExecute(Sender: TObject); //20180206 Igor
var FResult: Integer;
begin
  FResult := CaseDo('Choose interface',
                   ['VisualTax Classic',
                    'Small ToolBar',
                    'Large Toolbar',
                    'Ribbon'], nil);
  if FResult <> -1 then
  begin
    MainOptions.Skin := TSkin(FResult);
    MainOptions.Save;
  end;
end;

//20191129 Igor >>>
procedure TMainFormT2_2027.actCopyClientsFoldersExecute(Sender: TObject);
var
  Dir: string;
begin
  if ButtonInactive then Exit;
  Dir := optRec.Dir_ClientDocs+'\'+MkDirforClientDocs(RetNo);
  if not DirectoryExists(Dir) then
  Begin
   ForceDirectories(Dir);  //20200325
  End
  else
    ShellExecute(Application.Handle, 'open', PChar(Dir), nil, nil, SW_SHOWNORMAL) ;
end;
//20191129 Igor <<<

//20191129 Igor >>>
procedure TMainFormT2_2027.actCreateClientsFoldersExecute(Sender: TObject);
var
  Dir: string;
begin
  if ButtonInactive then Exit;
  Dir := optRec.Dir_ClientDocs+'\'+MkDirForClienTdocs(RetNo);
  if not DirectoryExists(Dir) then
    ForceDirectories(Dir);
end;
//20191129 Igor <<<

procedure TMainFormT2_2027.AddtoDataDictionaryforclientletters1Click(
  Sender: TObject);
begin
  if NotEditCommand then exit;
      InsertKeyWToDataDict(FormName,MyEditBox);;
end;

procedure TMainFormT2_2027.SetResetReviewMark1Click(Sender: TObject);
begin
  ReviewBtnClick(Sender);
end;

procedure TMainFormT2_2027.SetResetOverride1Click(Sender: TObject);
begin
  if NotEditCommand then exit;
  MyForm.ToggleOverride(MyEditBox);
end;

procedure TMainFormT2_2027.AttachNote1Click(Sender: TObject);
var
    FName, RefFormName, RefFieldId:String;
    FNo:Integer;Cinst:Integer;
begin
  if NotEditCommand then exit;
     RefFormName:=FormName;
     RefFieldId:=IntToStr(FieldId);
     FName := RefFormName;
     FNo:=GetFldMemFormNo(RetNo,RefFormName,RefFieldId);
     If FNo>0 then
      begin
      OpenForm(RetNo,FNo,0);
      FLDMEM(RetNo,FName,FNo);
      end
     else {not existing}
     begin
      CInst:=GetEmptyInstance(RetNo,'FLDMEM');
      If CInst>0 then
      begin
       FNo:=AddPageInstance(RetNo, 'FLDMEM','#'+AllTrim(IntToStr(CInst)));
       if FNo > 0 then
       begin
         FName:='FLDMEM'+'#'+AllTrim(IntToStr(CInst));
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

procedure TMainFormT2_2027.AttachAddingTape1Click(Sender: TObject);
var
    FName, RefFormName, RefFieldId:String;
    FNo:Integer;Cinst:Integer;
begin
  if NotEditCommand then exit;
     If (MyEditBox.vtInputtype <> vtDollar)
     or (MyEditBox.vtDataSource <> vtUser) then
     begin
      ShowMessage('Adding tape is allowed only for un-protected dollars fields');
      Exit;
     end;
     RefFormName:=FormName;
     RefFieldId:=IntToStr(FieldId);
     FName := RefFormName;
     FNo:=GetFldTapeFormNo(RetNo,RefFormName,RefFieldId);
     If FNo>0 then
       OpenForm(RetNo,FNo,0)
     else {new fldtape}
     begin
      CInst:=GetEmptyInstance(RetNo,'FLDTAPE');
      If CInst>0 then
      begin
       FNo:=AddPageInstance(RetNo, 'FLDTAPE','#'+AllTrim(IntToStr(CInst)));
       if FNo > 0 then
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

procedure TMainFormT2_2027.Help4Click(Sender: TObject);
var
  HelpTopic: string;
begin
  if NotEditCommand then exit;
      HelpTopic := GetHlpTopicFromLineRef(FormName,FieldId);
      If HelpTopic = '' then
        {MainFormT2.}HelpBtnClick(Application)
      else
        //Application.HelpFile := AppDir+'\'+'T2Help.HLP';
        ShowHelp(AppT2.ModuleHelpFile, HelpTopic, True); //20161220 Igor
end;

procedure TMainFormT2_2027.AddOnHelpClick(Sender: TObject);
begin
 ConnectToWeb('https://www.visualtax.com/'+t2enterpriseflname); //.htmlt2addon.html'); //20231031
end;

procedure TMainFormT2_2027.CICAWebbasedsubscriptionrequired1Click(
  Sender: TObject);
var
  HelpTopic: string;
begin
  if NotEditCommand then exit;
     HelpTopic:=GetHlpTopicFromLineRef(FormName,FieldId);
     If LeftStr(HelpTopic,5)='Line_' then HelpTopic:=MidStr(HelpTopic,6,3);
     LinkToCICA(HelpTopic);
end;

procedure TMainFormT2_2027.TRVisualTaxResearchWebbased1Click(
  Sender: TObject);
var
  HelpTopic: string;
begin
  if NotEditCommand then exit;
     HelpTopic:=GetTrTopicFromLineRef(FormName,FieldId);
     If Length(HelpTopic)>3 then  //only lines 000 to 999
       HelpTopic:=''
     else
       HelpTopic:='Line '+HelpTopic;
     LinkToTr(HelpTopic);
end;

procedure TMainFormT2_2027.FormSections1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  MyChild.GoToSection('');
end;

procedure TMainFormT2_2027.DeveloperOnly1Click(Sender: TObject); //20190415 Igor
begin
  if GetDeveloperPwd then
  begin
    DeveloperOnly1.OnClick := nil;
  end;
end;
// 20250729 Igor >>>
procedure TMainFormT2_2027.DACRequestfromCRA1Click(Sender: TObject);
begin
  ExecuteForm(TDACRequestEfileT2_2027);
end;
// 20250729 Igor <<<

end.


