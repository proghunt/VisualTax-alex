unit FP_2027main;
(* FP GUI components.

- show/hide ModuleButtonsPanel where?
  Depends on open return - in FormShow??? in SelectFeatures?
*)

interface

uses WinTypes,FileCtrl,WinProcs,SysUtils,Classes,Graphics,Forms,Controls,Menus,
  StdCtrls,Dialogs,Buttons,Messages,ExtCtrls,ShellApi,DbCtrls,Grids,Calendar,
  ColorGrd,Printers,ComObj,MAPI,DB,ClipBrd,ComCtrls,OleCtrls,SHDocVw,
  ImgList,ToolWin, Spin,
  QuickRpt, qrextra, VCLTee.TeeProcs, VCLTee.TeEngine, VCLTee.Chart,  //20150818 igor
  System.IOUtils, vtPDFPrinter, //20180503 Igor
  Mask,StdActns,
  ActnList,EKRTF,ekbasereport,ekfunc,VtEditBox,vtLabel,vtChild,vtShape,
  //20180206 Igor >>>
  System.Actions, Vcl.RibbonLunaStyleActnCtrls, Vcl.ActnMan, Vcl.Ribbon,
  VirtualUI_Mediator, //20190212 Igor
  vtHelperManager, vtCommonIntf, //20190228 Igor
  Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.RibbonActnMenus, UIRibbon, UIRibbonCommands, FP_UIRibbonUnit,
  Vcl.PlatformDefaultStyleActnCtrls; //,wwriched; //20190415 Igor
  //20180206 Igor <<<


const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;


Type
  TDFMorTXT = (ConvertToForm, ConvertToText);

type

  TMainFormFP_2027 = class(TForm)
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
    Line1: TMenuItem;
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
    AlphabeticalFormsIndex1: TMenuItem;
    Presentation1: TMenuItem;
    Zoomin1: TMenuItem;
    Zoomout1: TMenuItem;
    Toolbandswitch1: TMenuItem;
    Review1: TMenuItem;
    Color1: TMenuItem;
    BitBtn1: TBitBtn;
    Timer1: TTimer;
    ReIndextheClientDataBase1: TMenuItem;
    RestructuretheClientsDataBase1: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N22: TMenuItem;
    Checkupdate1: TMenuItem;
    ClearCurrentPage: TMenuItem;
    N32: TMenuItem;
    MOSTRECENTFILES1: TMenuItem;
    CharityOrganizations1: TMenuItem;
    SuperEntry1: TMenuItem;
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
    UsefulLinks: TMenuItem;
    SetReturnPassword1: TMenuItem;
    RemoveReturnPassword1: TMenuItem;
    N41: TMenuItem;
    N42: TMenuItem;
    EmailCurrentForm: TMenuItem;
    N43: TMenuItem;
    SaveALLopenedreturns1: TMenuItem;
    SaveandCloseAllopenedreturns1: TMenuItem;
    N50: TMenuItem;
    Checkupdates1: TMenuItem;
    N52: TMenuItem;
    VisualTaxontheWEB1: TMenuItem;
    VisualTaxForum1: TMenuItem;
    Frequentlyaskedquestions1: TMenuItem;
    N39: TMenuItem;
    N45: TMenuItem;
    TileVertical1: TMenuItem;
    TileHorizontally1: TMenuItem;
    CloseallreturnsWITHOUTSaving1: TMenuItem;
    Setdisplayresolution1: TMenuItem;
    N53: TMenuItem;
    N54: TMenuItem;
    Lockreturnagaistchanges1: TMenuItem;
    UnlockReturn1: TMenuItem;
    Options2: TMenuItem;
    N3: TMenuItem;
    PrepareDistr1: TMenuItem;
    LicLevel1: TMenuItem;
    N57: TMenuItem;
    ActionList1: TActionList;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EkRTF1: TEkRTF;
    EkUDFList1: TEkUDFList;
    Image1: TImage;
    EmailTheReturn: TMenuItem;
    TUTORIALS1: TMenuItem;
    N19: TMenuItem;
    Backupthetaxdata1: TMenuItem;
    Restoredatafrombackup1: TMenuItem;
    N34: TMenuItem;
    N1: TMenuItem;
    RolloverVisualTax1: TMenuItem;
    N17: TMenuItem;
    N24: TMenuItem;
    N26: TMenuItem;
    QuickStarterGuide1: TMenuItem;
    ImportTaxData1: TMenuItem;
    BackOfficetasks1: TMenuItem;
    FundAnalyser1: TMenuItem;
    MutualFundsDBmaintenance1: TMenuItem;
    PostMFpricestoBalanceSheet1: TMenuItem;
    PostcompletedtransactionstoBS1: TMenuItem;
    TrustAccountReconciliation1: TMenuItem;
    PortfolioBuilder1: TMenuItem;
    ModelPortfolios1: TMenuItem;
    ClientPortfolios1: TMenuItem;
    ProcessPanel: TChart;
    ProcessButtons: TChart;
    CopyrightLbl: TLabel;
    ExecutiveSummary1: TMenuItem;
    CoveringLetter1: TMenuItem;
    EnngagementLetter1: TMenuItem;
    PIPEDAPrivacyLetter1: TMenuItem;
    AttachmentsCoverPage1: TMenuItem;
    DetailSchedules1: TMenuItem;
    PIPEDAPrivacyletter2: TMenuItem;
    N2: TMenuItem;
    FnclCalculators1: TMenuItem;
    NestEggCalculator1: TMenuItem;
    SavingsCalculator1: TMenuItem;
    Debtrepaymentcalculator1: TMenuItem;
    PresentValueCalculator1: TMenuItem;
    FutureValueCalculator1: TMenuItem;
    MortgageAmortizationCalculator1: TMenuItem;
    ProbateFeesCalculator1: TMenuItem;
    N5: TMenuItem;
    MathematicalCalculator1: TMenuItem;
    N6: TMenuItem;
    IncomeGrowthCalculator1: TMenuItem;
    RRIFCalculator1: TMenuItem;
    N11: TMenuItem;
    N4: TMenuItem;
    WebCallCentre1: TMenuItem;
    AllBars: TPanel;
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
    CopyBtn: TSpeedButton;
    SwapBtn: TSpeedButton;
    ReviewBox: TGroupBox;
    AuditOpenBtn: TSpeedButton;
    ReviewBtn: TSpeedButton;
    RecalcBtn: TSpeedButton;
    DesktopBox: TGroupBox;
    ToolBarBtn: TSpeedButton;
    ZoomBtnPlus: TSpeedButton;
    ZoomBtnMinus: TSpeedButton;
    HelpBtn: TSpeedButton;
    ZoomPercentLbl: TLabel;
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
    GroupBox1: TGroupBox;
    SpeedButton5: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Image3: TImage;
    AppUpdateDate2: TLabel;
    Label9: TLabel;
    FpUpdDateLbl: TLabel;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    ModuleButtonsPanel: TScrollBox;
    PresentSituationBtn: TChart;
    Image4: TImage;
    GoalsAssumptionsBtn: TChart;
    GoalsImgBtn: TImage;
    ProblemAnalysisBtn: TChart;
    ProblemAnalysisImgBtn: TImage;
    PlanOfActionBtn: TChart;
    PlanOfActionImgBtn: TImage;
    ImplementationBtn: TChart;
    ImplementationImgBtn: TImage;
    PerformanceReviewBtn: TChart;
    PerformanceReviewImgBtn: TImage;
    ClientPresentationBtn: TChart;
    ExecSumImgBtn: TImage;
    Change1: TMenuItem;
    N12: TMenuItem;
    FormPopup: TPopupMenu;
    FieldPopup: TPopupMenu;
    EditCut1: TEditCut;
    Help1: TMenuItem;
    Help3: TMenuItem;
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
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Cut1: TMenuItem;
    N15: TMenuItem;
    AddtoDataDictionaryforclientletters1: TMenuItem;
    SetResetReviewMark1: TMenuItem;
    SetResetReviewMark2: TMenuItem;
    AttachNote1: TMenuItem;
    AttachAddingTape1: TMenuItem;
    AttachAddingTape2: TMenuItem;
    Help4: TMenuItem;
    SetResetOverride1: TMenuItem;
    Timer: TTimer;
    ImportfromProduction1: TMenuItem;
    ResetclientDBpassword1: TMenuItem;
    ListView2: TListView;
    MostRecentLbl: TLabel;
    OpenItBtn: TBitBtn;
    EMailItBtn: TBitBtn;
    CopyAReturnBtn: TBitBtn;
    Label8: TLabel;
    lblNewReturn: TLabel;
    lblOpenReturn: TLabel;
    lblRolloverReturn: TLabel;
    buttonAvailableWidth: TSpeedButton;
    ConvertDataandOptionstoMultipAppversion1: TMenuItem;
    Resetpasswordwithreturn1: TMenuItem;//20170409 Igor
    //20170418 Igor >>>
    Image2: TImage;
    Label1: TLabel;
    QuickFindBtn: TEdit;
    //20170418 Igor <<<
    //20180206 Igor >>>
    il16: TImageList;
    il32: TImageList;
    amFP: TActionManager;
    actChange1: TAction;
    actFileNewItem: TAction;
    actFileOpenItem: TAction;
    actOpenbyFileName1: TAction;
    actRolloverVisualTax1: TAction;
    actImportfromProduction1: TAction;
    actConvertDataandOptionstoMultipAppversion1: TAction;
    actFileSaveAsItem: TAction;
    actSaveALLopenedreturns1: TAction;
    actSaveandCloseAllopenedreturns1: TAction;
    actFileCloseItem: TAction;
    actCloseallreturnsWITHOUTSaving1: TAction;
    actLockreturnagaistchanges1: TAction;
    actUnlockReturn1: TAction;
    actCreateDataDirectory1: TAction;
    actChangeDataDirectory1: TAction;
    actSetReturnPassword1: TAction;
    actRemoveReturnPassword1: TAction;
    actFileExitItem: TAction;
    actSelectForm: TAction;
    actClearCurrentPage: TAction;
    actClearCurrentform: TAction;
    actCopyForm1: TAction;
    actSwitchforms1: TAction;      
    actCurrentPage1: TAction;
    actPrintForm1: TAction;
    actPIPEDAPrivacyLetter1: TAction;
    actExecutiveSummary1: TAction;
    actCoveringLetter1: TAction;
    actEnngagementLetter1: TAction;
    actAttachmentsCoverPage1: TAction;
    actPIPEDAPrivacyletter2: TAction;
    actDetailSchedules1: TAction;
    actEmailCurrentForm: TAction;
    actEmailTheReturn: TAction;
    actOptions2: TAction;
    actPrintTemplates1: TAction;
    actFeeSchedule1: TAction;
    actClientLetter1: TAction;
    actDataDictionary1: TAction;
    actExportConfiguration1: TAction;
    actImportConfiguration1: TAction;
    actShowCellNumbers1: TAction;
    actDiagnostics: TAction;
    actFundAnalyser1: TAction;
    actMutualFundsDBmaintenance1: TAction;
    actPostMFpricestoBalanceSheet1: TAction;
    actPostcompletedtransactionstoBS1: TAction;
    actTrustAccountReconciliation1: TAction;
    actModelPortfolios1: TAction;
    actClientPortfolios1: TAction;
    actNestEggCalculator1: TAction;
    actSavingsCalculator1: TAction;
    actDebtrepaymentcalculator1: TAction;
    actPresentValueCalculator1: TAction;
    actFutureValueCalculator1: TAction;
    actMortgageAmortizationCalculator1: TAction;
    actProbateFeesCalculator1: TAction;
    actMathematicalCalculator1: TAction;
    actIncomeGrowthCalculator1: TAction;
    actRRIFCalculator1: TAction;      
    actZoomin1: TAction;
    actZoomout1: TAction;      
    actColor1: TAction;
    actTileVertical1: TAction;
    actTileHorizontally1: TAction;      
    actCalculator1: TAction;
    actCalendar1: TAction;
    actBackupthetaxdata1: TAction;
    actRestoredatafrombackup1: TAction;
    actRebuildtheClientDataBase1: TAction;
    actMergeDataBases1: TAction;
    actFileViewerEditor1: TAction;      
    actReIndextheClientDataBase1: TAction;
    actFixClientDataBaseData1: TAction;
    actFixFormSpecifications1: TAction;
    actUpgrade1: TAction;       
    actPrepareDistr1: TAction;
    actLicLevel1: TAction;
    actResetclientDBpassword1: TAction;
    actResetpasswordwithreturn1: TAction;    
    actTUTORIALS1: TAction;
    actYourLatestRelease: TAction;
    actVisualTaxGuide1: TAction;
    actFrequentlyaskedquestions1: TAction;
    actVisualTaxForum1: TAction;
    actInternetWebSite1: TAction;
    actCheckupdates1: TAction;
    actUsefulLinks: TAction;
    actCheckupdate1: TAction;
    actWebCallCentre1: TAction;
    actSystemInformation1: TAction;
    actAboutItem: TAction;
    pnlSmallToolBar: TPanel;
    actAvailableWidth: TAction;
    actNextPage: TAction;
    actPrevPage: TAction;
    actFindForm: TAction;
    actSwap: TAction;
    actHelpCurrentForm: TAction;
    actRecalc1: TAction;
    actReviewMark: TAction;
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
    sep3: TToolButton;
    tbtnSwapReturn: TToolButton;
    tbtnSwapForm: TToolButton;
    tbtnNextPage: TToolButton;
    tbtnPreviousPage: TToolButton;
    sep1: TToolButton;
    edtSearchForm: TEdit;
    tbtnFindForm: TToolButton;
    ToolButton2: TToolButton;
    ToolButton1: TToolButton;
    tbReview: TToolBar;
    tbtnRecalc: TToolButton;
    tbtnDiagnostics: TToolButton;
    tbtnReview: TToolButton;
    tbDesctop: TToolBar;
    tbtnZoomout: TToolButton;
    lblZoom: TLabel;
    tbtnZoomin: TToolButton;
    ToolButton4: TToolButton;
    tbtnAvailableWidth: TToolButton;
    tbHelp: TToolBar;
    tbtnHelpCurrentForm: TToolButton;
    tbtnTips: TToolButton;
    pnlLargeToolbar: TPanel;
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
    tbtnAlphabeticalFormsIndex2: TToolButton;
    tbtnPreviousPage2: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    edtSearchForm2: TEdit;
    tbtnFindForm2: TToolButton;
    ToolButton8: TToolButton;
    tbReview2: TToolBar;
    tbtnRecalc2: TToolButton;
    tbtnDiagnostics2: TToolButton;
    tbtnReview2: TToolButton;
    tbDesctop2: TToolBar;
    tbtnZoomout2: TToolButton;
    lblZoom2: TLabel;
    tbtnZoomin2: TToolButton;
    tbtnAvailableWidth2: TToolButton;
    tbHelp2: TToolBar;
    tbtnHelpCurrentForm2: TToolButton;
    tbtnTips2: TToolButton;
    actDeveloperOnly1: TAction;
    actChangeSkin: TAction;
    ChangeSkinBtn: TSpeedButton;
    ToolButton3: TToolButton;
    ToolButton9: TToolButton;
    Buildreport1: TMenuItem; //20180424 Igor
    //20190212 Igor >>>
    btnUpload: TBitBtn;
    btnUploadWithoutOpen: TBitBtn;
    btnDownload: TBitBtn;
    btnDownloadAll: TBitBtn;
    //20190212 Igor <<<
    //20180206 Igor <<<
    actForCloud: TAction;
    //20190415 Igor >>>
    MainUIRibbon: TUIRibbon;
    actFileNewButton: TAction;
    actFileOpenButton: TAction;
    actFileCloseButton: TAction;
    actSelectFormButton: TAction;
    il24: TImageList; //20190228 Igor
    //20190415 Igor <<<
   // procedure SelectTreeViewSection(SectionId:Integer);
  //  Function GetPrintTemplate(IncludeFiling:Boolean):string;
  //  Procedure GetFormsToPrint(RetNo:integer;Template:string;var FormsToPrint:TstringList;Prov:String);

    Procedure OpenDelphiForm(RetNo:Integer;FName:String);
   // procedure Individualsnames1Click(Sender: TObject);
  //  procedure CorporationNames1Click(Sender: TObject);
  //  procedure BusinessNumbers1Click(Sender: TObject);
    function SendMAPIMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
    procedure PrintReturn(RetNo:integer;FormsToPrint:TstringList;Template:string);
    Procedure PrintReturnForEMail(RetNo:Integer;Template:String);
    procedure PrintFormForEmail(RetNo:Integer;FormName:String);
    Procedure GetGraphic;
    Procedure GetListOfLoadedReturns(SomeList:TStringList);
    procedure ProcessBlackBoxFile;
    function ConvertFormOrText(FileToConvertFrom:string;ConversionType:TDFMorTXT):Boolean;
    procedure AuditOpenBtnClick(Sender: TObject);
    procedure SetHorScrollBarInListBox(ListBox: TListBox; MaxWidth: Integer);
    procedure WidePanelBtnClick(Sender: TObject);
    Procedure ListBunchOfForms(TypeOfForm:string;ListCaption:String);
    procedure StartPrintForm(Retno:integer;FormName:String;WhichPage:integer);
    Procedure UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
    Function ButtonInactive:Boolean;
    procedure FormCreate(Sender: TObject);
    procedure FileNewItem_Click(Sender: TObject);
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
    procedure PrintFBtnClick(Sender: TObject);
    procedure CreateDataDirectory1Click(Sender: TObject);
    procedure PrintTemplates1Click(Sender: TObject);
    procedure FeeSchedule1Click(Sender: TObject);
    procedure Fonts1Click(Sender: TObject);
    procedure RemovecurrentreturnOverridesClick(Sender: TObject);
    procedure RemovecurrentfieldoverrideClick(Sender: TObject);
    procedure Lockamountoncurrentfield1Click(Sender: TObject);
    procedure CouplBtnClick(Sender: TObject);
    procedure OverrideBtnClick(Sender: TObject);
    procedure DataDictionary1Click(Sender: TObject);
    procedure DiagnosticsClick(Sender: TObject);
    procedure SamplesBtnClick(Sender: TObject);
    procedure AddinstanceofForm1Click(Sender: TObject);
    procedure PersonaldataClick(Sender: TObject);
    procedure FixTextoncurrentForm1Click(Sender: TObject);
    procedure FixDataDictionary1Click(Sender: TObject);
    procedure FixFormSpecifications1Click(Sender: TObject);
    procedure FixClientDataBaseData1Click(Sender: TObject);
    procedure ShowCellNumbers1Click(Sender: TObject);
    procedure ChangeDataDirectory1Click(Sender: TObject);
    procedure ClientListing1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
//    procedure UserSetUp2Click(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure Calculator1Click(Sender: TObject);
    procedure Appointments2Click(Sender: TObject);
    procedure TransmitRTU1Click(Sender: TObject);
    procedure Contents2Click(Sender: TObject);
    procedure SearchForHelpOnClick(Sender: TObject);
    procedure VisualTaxGuide1Click(Sender: TObject);
    procedure Allforms1Click(Sender: TObject);
    procedure MultipleDnBtnClick(Sender: TObject);
    procedure MultipleUpBtnClick(Sender: TObject);
    procedure DependBtnClick(Sender: TObject);
    procedure ReviewBtnClick(Sender: TObject);
    procedure ABCBtnClick(Sender: TObject);
    procedure PrintManager1Click(Sender: TObject);
    procedure ShowOverridesClick(Sender: TObject);
    procedure ListReviewmarks1Click(Sender: TObject);
    procedure SystemInformation1Click(Sender: TObject);
    procedure RebuildtheClientDataBase1Click(Sender: TObject);
    procedure MergeDataBases1Click(Sender: TObject);
    procedure FileViewerEditor1Click(Sender: TObject);
    procedure CurrentPage1Click(Sender: TObject);
    procedure RecalcBtnClick(Sender: TObject);
    procedure PreselNextBtnClick(Sender: TObject);
    procedure PreSelPrvBtnClick(Sender: TObject);
    procedure OpenBtnClick(Sender: TObject);
    procedure YourLatestReleaseClick(Sender: TObject);

    procedure ZoomBtnPlusClick(Sender: TObject);
    procedure ZoomBtnMinusClick(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    Procedure FullPrint(RetNo:Integer;Template:String);
    procedure Upgrade1Click(Sender: TObject);
    procedure AuditListBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure InternetWebSite1Click(Sender: TObject);
    procedure WWWLblClick(Sender: TObject);
    procedure WorldButtonClick(Sender: TObject);
    procedure AlphabeticalFormsIndex1Click(Sender: TObject);
    procedure Zoomin1Click(Sender: TObject);
    procedure Zoomout1Click(Sender: TObject);
    procedure Toolbandswitch1Click(Sender: TObject);
    procedure Color1Click(Sender: TObject);
    procedure ReIndextheClientDataBase1Click(Sender: TObject);
    procedure Checkupdate1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure CheckUpdatesLblClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure ClearCurrentformClick(Sender: TObject);
    procedure ClearCurrentPageClick(Sender: TObject);
    procedure ShowMostRecentReturns;
    procedure CharityOrganizations1Click(Sender: TObject);
    procedure CompanyLogo1Click(Sender: TObject);
    procedure ImportConfiguration1Click(Sender: TObject);
    procedure ExportConfiguration1Click(Sender: TObject);
    procedure UsefulLinksClick(Sender: TObject);
    procedure SetReturnPassword1Click(Sender: TObject);
    procedure RemoveReturnPassword1Click(Sender: TObject);
    procedure SetProgramPassword1Click(Sender: TObject);
    procedure RemoveProgramPassword1Click(Sender: TObject);
    procedure PrintAuditBtnClick(Sender: TObject);
    procedure PrintAuditWizardDiagnostics1Click(Sender: TObject);
    procedure EmailCurrentFormClick(Sender: TObject);
    Function  SaveAllReturns:Boolean;
    Procedure CloseAllReturns;
    procedure SaveALLopenedreturns1Click(Sender: TObject);
    procedure SaveandCloseAllopenedreturns1Click(Sender: TObject);
    procedure TestBlBoxClick(Sender: TObject);
    procedure CloseBlackBoxBtnClick(Sender: TObject);
    procedure FormsBlackBoxBtnClick(Sender: TObject);
    procedure Provincialnews1Click(Sender: TObject);
    Function  CountFiles(Dir:String;FileExt:String):Integer;
    procedure CICALineByLineInternethelpNONResidents1Click(
      Sender: TObject);
    procedure OtherGuides1Click(Sender: TObject);
    procedure Checkupdates1Click(Sender: TObject);
    procedure Frequentlyaskedquestions1Click(Sender: TObject);
    procedure VisualTaxForum1Click(Sender: TObject);
    procedure HowoftentocheckInternetUpdates1Click(Sender: TObject);
    procedure ListMultipleBtnClick(Sender: TObject);
    procedure VerticalSplitter2CanResize(Sender: TObject;
      var NewSize: Integer; var Accept: Boolean);
    procedure CloseallreturnsWITHOUTSaving1Click(Sender: TObject);

    procedure NewReturnLblClick(Sender: TObject);
    procedure OpenReturnLblClick(Sender: TObject);
    procedure WhatsNewLblClick(Sender: TObject);
    procedure FaQLblClick(Sender: TObject);
    procedure HelpLblClick(Sender: TObject);
    procedure ForumLblClick(Sender: TObject);
    procedure Lockreturnagaistchanges1Click(Sender: TObject);
    procedure UnlockReturn1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView2KeyPress(Sender: TObject; var Key: Char);
    procedure Options2Click(Sender: TObject);
    procedure QuestionMarkLblMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LicLevel1Click(Sender: TObject);
    procedure PrepareDistr1Click(Sender: TObject);
    procedure ActionList1Execute(Action: TBasicAction;var Handled: Boolean);
    procedure EkUDFList1Functions0Calculate(Sender: TObject;Args: TEkUDFArgs; ArgCount: Integer;
              UDFResult: TObject);
    procedure GoToaFormSection1Click(Sender: TObject);
    procedure EmailTheReturnClick(Sender: TObject);
    procedure OpenItBtnClick(Sender: TObject);
    procedure EMailItBtnClick(Sender: TObject);
    procedure HelpIndexBtnClick(Sender: TObject);
    procedure Backupthetaxdata1Click(Sender: TObject);
    procedure Restoredatafrombackup1Click(Sender: TObject);
    procedure CopyAReturnBtnClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure StatusBarBtnClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure NewBtnToolBarClick(Sender: TObject);
    procedure OpenBtnToolBarClick(Sender: TObject);
    procedure CloseBtnToolBarClick(Sender: TObject);
    procedure SaveBtnToolBarClick(Sender: TObject);
    procedure SwapBtnClick(Sender: TObject);
    procedure QuickStarterGuide1Click(Sender: TObject);
    procedure QuickStartLblClick(Sender: TObject);
    procedure ImportTaxData1Click(Sender: TObject);
    procedure FundAnalyser1Click(Sender: TObject);
    procedure MutualFundsDBmaintenance1Click(Sender: TObject);
    procedure PostMFpricestoBalanceSheet1Click(Sender: TObject);
    procedure PostcompletedtransactionstoBS1Click(Sender: TObject);
    procedure ModelPortfolios1Click(Sender: TObject);
    procedure ClientPortfolios1Click(Sender: TObject);
    procedure ExecutiveSummary1Click(Sender: TObject);
    procedure CoveringLetter1Click(Sender: TObject);
    procedure EnngagementLetter1Click(Sender: TObject);
    procedure PIPEDAPrivacyletter2Click(Sender: TObject);
    procedure ClientPresentationBtnClick(Sender: TObject);
    procedure GoalsAssumptionsBtnClick(Sender: TObject);
    procedure PresentSituationBtnClick(Sender: TObject);
    procedure ProblemAnalysisBtnClick(Sender: TObject);
    procedure PlanOfActionBtnClick(Sender: TObject);
    procedure ImplementationBtnClick(Sender: TObject);
    procedure PerformanceReviewBtnClick(Sender: TObject);
    procedure DetailSchedules1Click(Sender: TObject);
    procedure PIPEDAPrivacyLetter1Click(Sender: TObject);
    procedure AttachmentsCoverPage1Click(Sender: TObject);
    procedure ClientListings1Click(Sender: TObject);
    procedure Assets1Click(Sender: TObject);
    procedure Liabilitie1Click(Sender: TObject);
    procedure NestEggCalculator1Click(Sender: TObject);
    procedure SavingsCalculator1Click(Sender: TObject);
    procedure Debtrepaymentcalculator1Click(Sender: TObject);
    procedure PresentValueCalculator1Click(Sender: TObject);
    procedure FutureValueCalculator1Click(Sender: TObject);
    procedure MortgageAmortizationCalculator1Click(Sender: TObject);
    procedure ProbateFeesCalculator1Click(Sender: TObject);
    procedure MathematicalCalculator1Click(Sender: TObject);
    procedure IncomeGrowthCalculator1Click(Sender: TObject);
    procedure RRIFCalculator1Click(Sender: TObject);
    procedure RolloverVisualTax1Click(Sender: TObject);
    procedure GatherDataBtnClick(Sender: TObject);
    procedure GoalsObjectivesBtnClick(Sender: TObject);
    procedure AnalyseBtnClick(Sender: TObject);
    procedure ActionPlanBtnClick(Sender: TObject);
    procedure ImplementationStepBtnClick(Sender: TObject);
    procedure MonitorPlanBtnClick(Sender: TObject);
    procedure WebCallCentre1Click(Sender: TObject);
  //added/modified
    procedure mnSelAppIdClick(Sender: TObject);
    procedure TileHorizontally1Click(Sender: TObject);
    procedure TileVertical1Click(Sender: TObject);
    procedure TUTORIALS1Click(Sender: TObject);
    procedure Notepad1Click(Sender: TObject);
    procedure Notepadwithamounts1Click(Sender: TObject);
    procedure PrivateNotepad1Click(Sender: TObject);
    procedure AddtoDataDictionaryforclientletters1Click(Sender: TObject);
    procedure AttachNote1Click(Sender: TObject);
    procedure AttachAddingTape1Click(Sender: TObject);
    procedure FormSections1Click(Sender: TObject);
    procedure SetResetOverride1Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ImportfromProduction1Click(Sender: TObject); //20160305 Igor
    procedure ResetclientDBpassword1Click(Sender: TObject);
    procedure buttonAvailableWidthClick(Sender: TObject);
    procedure ConvertDataandOptionstoMultipAppversion1Click(Sender: TObject); //20160305 Igor
    procedure Resetpasswordwithreturn1Click(Sender: TObject);
    procedure lblRolloverReturnClick(Sender: TObject); //20170409 Igor
    procedure QuickFindBtnKeyPress(Sender: TObject; var Key: Char);//20170418 Igor
    //20180206 Igor >>>
    procedure amFPStateChange(Sender: TObject);
    procedure actColor1Execute(Sender: TObject);
    procedure actFindFormExecute(Sender: TObject);
    procedure edtSearchFormChange(Sender: TObject);
    procedure DeveloperOnly1Click(Sender: TObject);
    procedure actChangeSkinExecute(Sender: TObject);
    //20180206 Igor <<<
    procedure Buildreport1Click(Sender: TObject); //20180424 Igor
    //20190212 Igor >>>
    procedure btnUploadClick(Sender: TObject);
    procedure btnUploadWithoutOpenClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    //20190212 Igor <<<
    //20190228 Igor >>>
    procedure actForCloudExecute(Sender: TObject);
    procedure OpenFromCloudClick(Sender: TObject);
    //20190415 Igor >>>
    procedure MainUIRibbonCommandCreate(const Sender: TUIRibbon;
      const Command: TUICommand);
    procedure SearchFormSelect(const Args: TUICommandCollectionEventArgs);
    //20190415 Igor <<<
  private
    MyChild: TMyChild;
    MyForm: TvtScrollBox;
    //FormName: string; //20160405 Igor
    //FormNo: integer; //20160405 Igor
    FRetNo: integer;
    ToolBarSw: boolean;
    //20180206 Igor >>>
    FSearchStr: string;
    FSearchForm1, FSearchForm2: TUICommandCollection; //20190415 Igor
    procedure SetSearchStr(const AValue: String);
    function GetZoomStr: String;
    procedure SetZoomStr(const Value: String);
    //20180206 Igor <<<
    function NotEditCommand: boolean;
    function GetMyFormName: String; //20160405 Igor
    function GetMyFormNo: Integer; //20160405 Igor
    procedure ShowReturn(ARetNo: integer); //20190212 Igor
    property FormName: String read GetMyFormName;
    property FormNo: Integer read GetMyFormNo;
    procedure OnCreateMenuItem(const aName: string; const aHelperID: Integer);//20190228 Igor
  public //non-handlers
    Procedure ShowMultiOfficeMsg;
    Function  EditBeforeSave(RetNo:Integer):Boolean;
  public
    Function DoSave(RNo: integer):Boolean;
    procedure DoSaveAs(RetNo: integer);
    property RetNo: integer read FRetNo;
    procedure SelectFeatures;
    //20180122 Igor >>>
    property SearchStr: String read FSearchStr write SetSearchStr;
    property ZoomStr: String read GetZoomStr write SetZoomStr;
    //20180122 Igor <<<
    procedure ReloadMainMenu; //20190228 Igor
  end;

function FileNew: integer;

var
  MainFormFP: TMainFormFP_2027;
  MainMenuFP: TMainMenu;

  Report : TQuickRep;
  AQRReport : TQuickRep; //20150818 igor
  TutorialFile:TFileName;
  TutorialScript:String;

Implementation

{$R *.DFM}

uses vtCommon,vtMulti,vtDialogs,vtMain,FP_2027,FP_2027Common,FP_2027Common2,
  FP_2027TrimStr,FP_2027Declare,FP_2027Import,FP_2027FundsInWeb,
  FP_2027RepAssets,FP_2027RepLiabilities,FP_2027OptionsFrm,FP_2027AssetsFrame,
  FP_2027LiabFrame,FP_2027CalcT1Import,FP_2027CalcTax,FP_2027OpFlNm,
  FP_2027ClientBook,FP_2027SaveAs,FP_2027BackupFrm,FP_2027RestoreFrm,
  FP_2027Fees,FP_2027Dict,FP_2027SIC,FP_2027DFiles,FP_2027CntErr,FP_2027Print,
  FP_2027DeskTop,FP_2027CopyMoveFrm,FP_2027StatBox,FP_2027PopList,
  FP_2027PopComboList,FP_2027SearchList,FP_2027Users,FP_2027CopyFrm,
  FP_2027FrmTree,FP_2027FileVu,FP_2027Calc,fProgres,FP_2027DBRestr,
  FP_2027FRMType,FP_2027ABList,FP_2027PrSet,FP_2027Rebuild,FP_2027Merge,
  FP_2027RichForm,FP_2027ReindexDb,FP_2027FormsExplorer,FP_2027Features,
  FP_2027FtpFrm,FP_2027ImportConfig,FP_2027ExportConfig,FP_2027PdfFrm,
  FP_2027SetFilePsw,FP_2027UpdateSchedule,FP_2027DataDictFrm,
  FP_2027DealerBackOffice,FP_2027BranchBackOffice,FP_2027AssetSummary,
  FP_2027LiabilitiesChart,FP_2027NetWorthChart,FP_2027FixedAssetsChart,
  FP_2027DataGather,FP_2027GoalsObjectives,FP_2027Analysis,FP_2027ActionPlan,
  FP_2027PlanImplementation,FP_2027MonitorPlan,FP_2027EditSuppliers,
  FP_2027AssetProjectionCharts,
{$IFDEF ADO}
  FP_2012HoSetUp,FP_2012FundBase,FP_2012Accounts,
  FP_2012Buy,FP_2012SwitchTransaction,FP_2012Sell,FP_2012ReviewActionPlan,
  FP_2012Organization,FP_2012TrustDeposits,
  FP_2027wwSelectFund,
{$ELSE}
{$ENDIF}
  FP_2027Objectives,FP_2027GeneralActionPlan,FP_2027DevelopActionPlan,
  FP_2027FundAnalyser,FP_2027PortfolioChart,FP_2027PortfolioCreator,
  FP_2027InvestmentStrategy,FP_2027LifeInsur,FP_2027ReportMenu,FP_2027FpProcess,
  FP_2027SavingsCalculator,FP_2027NestEggCalculator,
  FP_2027DebtRepaymentCalculator,FP_2027RIFFRM,FP_2027MortgageCalculator,
  FP_2027FutureValueCalculator,FP_2027PresentValueCalculator,
  FP_2027UpdateMfPrices,FP_2027ClientPresentation,FP_2027EmptyFpTables,
  FP_2027Probate,FP_2027FundReport2,FP_2027PortfolioReport,
  FP_2027PostTransactions,FP_2027SelectAgent,FP_2027Commissions,
  FP_2027ExportClient,FP_2027ExportToFs,FP_2027BuyTransaction,
  FP_2027SellTransaction,FP_2027ProposedAssetSummary,FP_2027LifeEvents,
  FP_2027Restructure,FP_2027PayCodes,FP_2027PickADate,FP_2027RemoveNullValues,
  FP_2027CommissionsMenu,FP_2027PortFolioMenu,FP_2027ChartAFund,
  FP_2027CurrentPortfolioSummary,FP_2027PostPrices,FP_2027TrustReconciliation,
  FP_2027ShortFall,FP_2027IncomeStreamCalculator,//FP_2027Analyse, //20180714 CON did not compile
  FP_2027ChildWinNew,FP_2027HeaderFrame
, vtTrimStr,vtShared, vtDataModuleUnit
, vtDataBase, uADCompClient, // 20150922 Igor
  FP_2027ImportDBFData, //20160305 Igor
  fConvertToMultiApp, //20160627 Igor
  vtReportBuilder, //20180424 Igor
  vtChooseFileForm, //20190212 Igor
  fCaseDo; //20180206 Igor

//var MyTab:TPageControl; MyTabSheet:TTabSheet;MyScrollBox:TScrollbox; MyPanel:Tpanel;

procedure TMainFormFP_2027.FormCreate(Sender: TObject);
Var i:Integer;TempList:TStringList; aNode:TTreeNode;
begin
//20190415 Igor >>>
  MainUIRibbon.ResourceInstance := LoadLibraryEx('FP_UIRibbonUnit.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
  if (MainUIRibbon.ResourceInstance = 0) then
    MainUIRibbon.ResourceName := '';
  //20190415 Igor <<<
  AppUpdateDate2.Caption:= 'As of: '+AppUpdateDate;
  FpUpdDateLbl.Caption:= AppUpdateDate;
  ModuleButtonsPanel.Visible:=RetInMem>0;
  ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
  If FileExists(AppDir+'\'+RecentFlName) = False then
   InitMostRecentFiles(30); //put them in RecentFlName
  ShowMostRecentReturns;
  InitColorPanel;
  ReloadMainMenu; //20190228 Igor
  MainMenuFP := Menu;
  Menu := nil; //to be shown in Main
  //20190212 Igor >>>
  if CheckIsCloud(true) then
  begin
    OpenbyFileName1.Caption := 'Open by &File Name ...';
    btnUpload.Visible := true;
    btnDownload.Visible := true;
    btnUploadWithoutOpen.Visible := true;
    ListView2.CheckBoxes := true;
    btnDownloadAll.Visible := true;
  end
  else
  begin
    btnUpload.Visible := false;
    btnDownload.Visible := false;
    btnUploadWithoutOpen.Visible := false;
    ListView2.CheckBoxes := false;
    btnDownloadAll.Visible := false;
  end;
  //20190212 Igor <<<
end;

procedure TMainFormFP_2027.FormPaint(Sender: TObject);
begin
 ModuleButtonsPanel.Visible:=RetInMem>0;
 ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
 ProcessPanel.left := (Screen.Width - ProcessPanel.Width) div 2;
 ProcessPanel.Visible:=RetInMem=0;
{ AboutPanel2.left := (Screen.Width - AboutPanel2.Width) div 2;
 AboutPanel2.Visible:=RetInMem=0;}
 SelectFeatures;
 Screen.Cursor := crDefault;
end; //paint

//Initialization  InitFP;
procedure TMainFormFP_2027.SelectFeatures;
begin
  if Application.Terminated then exit; //20161110 Igor

//called from FormPaint
  ProcessPanel.Visible := True;
  ModuleButtonsPanel.Visible := RetInMem > 0;

 //If ProcessPanel.Visible then
 begin
//20170127 Igor >>>
//  AppReleaseLbl.Caption:= 'Release: '+AppVersion; //'Release: '+AppRelease;
//  AppUpdateDateLbl.Caption:= 'Updated: '+AppUpdateDate;
 // VisualFpLbl.Caption := '   Visual FP';
//  TradeMarkLbl.Font.Size :=20;
//  LicenseLevelLbl.Caption := 'Version: '+LicenseName;
//20170127 Igor <<<
 // VisualFpLbl.Caption := '   Visual FP';

 (* //20170313
  If IsRocheSystem then
  begin
   VisualFpLbl.Caption := 'The Roche System';
   VisualFpLbl.Font.Size :=18;
  end;
 *)

  (* //20170312
  LicenseLevelLbl2.Caption := 'Version: '+LicenseName;
  AppReleaseLbl2.Caption:=Apprelease;
  AppUpdateDateLbl2.Caption:=AppUpdateDate;
  *)

  //If LeftStr(LicenseLevel,8) = 'T1 Multi' then
//20170127 Igor >>>
//  If LicenseLevel in anyMulti then
//  begin
//    If Length(Licensee) >0 then
//    begin
//     If Length(Licensee) < Length('Visual FP') then
//         TradeMarkLbl.Font.Size :=20
//     else
//         TradeMarkLbl.Font.Size :=20;
//     TradeMarkLbl.Caption := Licensee;
//     TradeMarkSymbolLbl.Visible := False;
//   end;
//  end;
//20170127 Igor <<<
  ShowMostRecentReturns; //20170112 Igor
 end;
end;


Function TMainFormFP_2027.ButtonInactive:Boolean;
begin
  FRetNo := GetCurrentRetNo;
  if RetNo < 1 then
  Begin
  Result := True;
  ShowMessage('You must open a new or existing FP file first');
  end
 Else if Ret[RetNo] = nil then begin
  Result := True; //wrong return type!
  MyChild := nil;
 end else
 begin
  Result := false;
  MyChild := vtMulti.RetList[RetNo].MyChild;
 end;
end;

procedure TMainFormFP_2027.FileNewItem_Click(Sender: TObject);
begin
  FRetNo := FileNew;
end;

function FileNew: integer;
//20170731 Igor >>>
Var
  RetNo: Integer absolute Result;
  FormNo: Integer;
  FormName: string;
begin
  RetNo:=CreateNewReturn;
  if RetNo < 1 then
  begin
    ShowOpenReturnFailure(RetNo, '', '');
    exit;
  end;
  If (ServerMode=False) then
  begin
    vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
    try
      LockWindowUpdate(MainForm.Handle);
      //MainForm.Visible:=False;

      FormName := 'PROFILE';
      FormNo := GetFormNo(FormName);
      InitFormData(RetNo,FormNo);
      CountDiagnostics(RetNo);
      MainForm.GuiCommand(gcReduceTutorialHeight); //.ReduceTutorialHeight(Application);
      Calc(RetNo,'PROFILE');
      OpenForm(RetNo,FormNo,0); //new child
      CalcAll(RetNo);
      OpenOtherImportantForms(RetNo);
      UpdateAllDataIndicators(RetNo);
      LockWindowUpdate(0);
    finally
      vtChild.CreateNewMDIChild(RetNo, '').ShowAllControls;
    end;
    //MainForm.Visible:=True;
  end;
  MainForm.FormPaint(nil);
  MainForm.GuiCommand(gcShowLeftPanel);  //MainForm.LeftPanel.Visible:=True; //20160222 Igor
//20170731 Igor <<<
end;

procedure TMainFormFP_2027.FileOpenItemClick(Sender: TObject);
//Var RetNo,PrvRNo:Integer;
begin
  if ExecuteForm(TClientBookFP_2012) = mrOk then //20160612 Igor
    MainForm.GuiCommand(gcHideFlash);
  Done;

{
  RetNo:=GetCurrentRetNo;
  If RetNo=0 then exit;
}
end;


procedure TMainFormFP_2027.FileSaveItemClick(Sender: TObject);
begin
//If ButtonInactive then exit;
  FileSaveAsItemClick(Sender);
end;

procedure TMainFormFP_2027.FileSaveAsItemClick(Sender: TObject);
begin
  If ButtonInactive then exit;
    DoSaveAs(RetNo);
end;

procedure TMainFormFP_2027.DoSaveAs(RetNo: integer);
//procedure TMainFormFP_2012.FileSaveAsItemClick(Sender: TObject);
begin
  if Ret[RetNo].isAppendix then //20160704 Igor
    exit;
 UpdateAllDataIndicators(RetNo);
 MyChild.UpdateChildTaxPanel;

 If EditBeforeSave(RetNo) = false then
 begin
   If not MainForm.WizardPanel.Visible then MainForm.AuditOpenBtnClick(Application);
   ShowMessage('Please enter Mandatory data before saving');
   exit;
 end;
 //T4Sum(RetNo,'T4SUM',GetFormno('T4SUM'));
 Application.CreateForm(TSaveAsFP_2012,SaveAs);
 SaveAs.ShowModal;
 SaveAs.Free;
end;

procedure TMainFormFP_2027.FileCloseItemClick(Sender: TObject);
Begin
  If ButtonInactive then exit;
  RetList[RetNo].Close(True);
end;

Function TMainFormFP_2027.EditBeforeSave(RetNo:Integer):Boolean;
begin
 Result:=False;
 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount > 0 then
 begin
   Exit;
 {
   If not AuditPanel.Visible then AuditOpenBtnClick(Application);
   ShowTimedMsg('Mandatory data must be entered before Saving',1400);
   Result:=False;
   Exit;
 }
 end;
 {
 else If (ErrorCount > 0) and (AuditPanel.Visible = False) then
 begin
   If not WizardPanel.Visible then
    begin AuditOpenBtnClick(Application);exit;end;
 end;
 }
 Result :=true;
end;

procedure TMainFormFP_2027.edtSearchFormChange(Sender: TObject); //20180206 Igor
begin
  SearchStr := (Sender as TEdit).Text;
end;

procedure TMainFormFP_2027.ShowWarnings;
begin
{
    Application.CreateForm(TWarning,Warning);
    Warning.ShowModal;
    Warning.Free;
    exit;
 }
end;

procedure TMainFormFP_2027.FileExitItemClick(Sender: TObject);
begin
 // SuperAuditBox.Checked := False;
  If CountUnsavedReturns = 0 then
    Application.Terminate {Close}
  else
   if MessageDlg(
     IntToStr(CountUnsavedReturns)
     + ' files(s) still in memory.'
     + Chr(13)+' Exit without closing the file(s)?',
     mtWarning, [mbNo, mbYes], 0) = mrYes then
        Application.Terminate; {Close;}
end;

procedure TMainFormFP_2027.ConvertDataandOptionstoMultipAppversion1Click(
  Sender: TObject); //20160627 Igor
begin
  ConvertToMultiApp(AppFP, true);
end;

function TMainFormFP_2027.ConvertFormOrText(FileToConvertFrom:string;ConversionType:TDFMorTXT):Boolean;
var
  InputStream, OutputStream : TFileStream;
  FileToConvertTo : string;
begin
  Result := True;
  InputStream := nil;
  OutputStream := nil;
 
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


procedure TMainFormFP_2027.CutItemClick(Sender: TObject);
begin
  {cut selection to clipboard}
end;

procedure TMainFormFP_2027.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveFormChange := nil;
end;

procedure TMainFormFP_2027.RestoreReturnClick(Sender: TObject);
var
i: Integer;
WinList : TStringList;
CurHandle : Thandle;
begin
end;

procedure TMainFormFP_2027.ResetclientDBpassword1Click(Sender: TObject); //20160305 Igor
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

procedure TMainFormFP_2027.Resetpasswordwithreturn1Click(Sender: TObject);//20170409 Igor
begin
  if not OpenDialog.execute then exit;
  if RemovePasswordReturn(OpenDialog.FileName) then
    MessageDlg('Reset password completed', mtInformation, [mbOk],0);
end;

procedure TMainFormFP_2027.RestoreAllClick(Sender: TObject);
var
i : Integer;
CurHandle : Thandle;
begin
end;


procedure TMainFormFP_2027.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 {}
end;

procedure TMainFormFP_2027.SelectFormClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 UpdateAllDataIndicators(RetNo);

 LoadTreeView('TreeView.d',1);
 Application.CreateForm(TFrmTreeFP_2012,FrmTree);
 //20180206 Igor >>>
 FrmTree.ShowModal;
 FrmTree.Free;
 //20180206 Igor <<<
end;


procedure TMainFormFP_2027.ListBunchOfForms(TypeOfForm:string;ListCaption:String);
Var I: integer; FName: string;
begin
 If ButtonInactive then exit;
 SomeList.Clear;  // := TStringList.Create;
 SomeList.Sorted := True;
 SomeCaption := ListCaption;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormShow) and (Frec.FormType = TypeOfForm) then
       SomeList.Add(Frec.FormAbrev);
 end;
 Application.CreateForm(TPopListFP_2012,PopList);
 PopList.ShowModal;
 //SomeList.Free;  //20160704 Igor
 PopList.Release;
 If SelectedString > '' then
 begin
   FName := Rtrim(GetFName(SelectedString));  {using Real Name}
   OpenForm(RetNo,GetFormNo(FName),0);
 end;
end;



procedure TMainFormFP_2027.PrinterSetupClick(Sender: TObject);
begin
  if CheckIsCloud then Exit; //20180503 Igor
  PrintDialogItem.Execute;
end;

procedure TMainFormFP_2027.NewBtnClick(Sender: TObject);
begin
  FileNewItem_Click(Sender);
end;


procedure TMainFormFP_2027.PrintRBtnClick(Sender: TObject);
Var I : integer;
begin
  {If RetNo < 1 then exit;}
  If ButtonInactive then exit;
  SomeList.Clear; // := TStringList.Create;
  SomeCaption := 'Print';
  SomeList.Add('Current Page');
  SomeList.Add('Current Form');
  SomeList.Add('Current Return');
  Application.CreateForm(TPopListFP_2012,PopList);
  PopList.ShowModal;
  //SomeList.Free; //20160704 Igor
  PopList.Release;
  If SelectedString = '' then exit;
  {PrintDialogItem.Options := [poWarning];}
  If SelectedString = 'Current Page' then CurrentPage1Click(Sender)
  else If SelectedString = 'Current Form' then PrintForm1Click(Sender);
  //else if SelectedString = 'Current Return' then PrintCurrentReturn1Click(Sender);
end;


procedure TMainFormFP_2027.StatusBarBtnClick(Sender: TObject);
begin
EXIT;
end;

procedure TMainFormFP_2027.ToolBarBtnClick(Sender: TObject);
begin
  if ButtonInactive then exit;
  If noclient(RetNo) then exit;
  ToolBarSw := not ToolBarSw;
  //20230307 Igor >>>
  ToolBarBtn.Glyph := Nil;
  If ToolBarSw then
   begin
    il24.GetBitmap(1, ToolBarBtn.Glyph);
    //ToolBarBtn.Glyph.LoadFromFile(AppDir+'\'+'SwitchOn.BMP');
    ToolBarSw := True;
    ModuleButtonsPanel.Visible:=True;
   // ToolBar.Height := 75;
   end
  else
   begin
   il24.GetBitmap(0, ToolBarBtn.Glyph);
   //ToolBarBtn.Glyph.LoadFromFile(AppDir+'\'+'SwitchOf.BMP');
   ToolBarSw := false;
   ModuleButtonsPanel.Visible:=False;
   //ToolBar.Height :=(ToolBar.Height div 2)+3+5; //(ToolBar.Height div 2)+3+1;
   end;
   //20230307 Igor <<<
end;


procedure TMainFormFP_2027.AboutItemClick(Sender: TObject);
begin
  ShowAbout;
end;

procedure TMainFormFP_2027.actChangeSkinExecute(Sender: TObject); //20180206 Igor
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

procedure TMainFormFP_2027.actColor1Execute(Sender: TObject); //20180206 Igor
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

procedure TMainFormFP_2027.actFindFormExecute(Sender: TObject); //20180206 Igor
begin
  If ButtonInactive then exit;
  If Trim(SearchStr) = '' then exit;
  QuickFormFind(RetNo, SearchStr);
end;

procedure TMainFormFP_2027.actForCloudExecute(Sender: TObject); //20190228 Igor
begin
  OpenFromCloudClick(Sender);
end;

procedure TMainFormFP_2027.CloseBtnClick(Sender: TObject);
begin
  FileCloseItemClick(Sender);
end;

procedure TMainFormFP_2027.StatusBarClick(Sender: TObject);
begin
 {UpdateTaxPanel;}
end;

procedure TMainFormFP_2027.ClrCustomClick(Sender: TObject);
begin
 Clr0Click(Sender);
end;

procedure TMainFormFP_2027.clr0Click(Sender: TObject);
begin
 If ButtonInactive then exit;
  MainForm.clrClick(RetNo, Sender, c_ReturnColorElm); //20170225 Igor
end;

Procedure TMainFormFP_2027.InitColorPanel;
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

procedure TMainFormFP_2027.clr1Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormFP_2027.clr2Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormFP_2027.clr3Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormFP_2027.clr4Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormFP_2027.clr5Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormFP_2027.clr6Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormFP_2027.clr7Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormFP_2027.clr8Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormFP_2027.clr9Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormFP_2027.clr10Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormFP_2027.clr11Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormFP_2027.OpenbyFileName1Click(Sender: TObject);
var RetNo,result : integer;FullFlName:String;s:String;FlName,Sin,Dir:String; //20190212 Igor
begin
  //20190212 Igor >>>
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
  //20190212 Igor <<<
 //ShowUnprocessedEfiles;
 OpenDialog.InitialDir:= OptRec.Dir_Cur;
 If OpenDialog.Execute then
 begin
   FullFlName :=OpenDialog.FileName;
   FlName:=ExtractFileName(FullFlName);
   Sin:=RemoveChar(FlName,'.');
   If IsOkToOpenReturn(ExtractFileDir(FullFlName),FlName,Sin) = False then Exit;
   RetNo:=OpenReturn(ExtractFileDir(FullFlName),FlName,True);
   If RetNo > 0 then
   begin
    LockWindowUpdate(MainForm.Handle);
    CountDiagnostics(RetNo);
    MainForm.GuiCommand(gcShowLeftPanel); //MainForm.LeftPanel.Visible:=True; //20160222 Igor
    OpenForm(RetNo,'PROFILE',0);
    MainForm.FormPaint(Application);
    MainForm.RefreshAuditPanel(RetNo); //If AuditPanel.Visible then RefreshAuditPanel;
   //If FormsPanel.Visible then RefreshFormsPanel(RetNo);
   end;
 end;
end;

procedure TMainFormFP_2027.Calendar1Click(Sender: TObject);
begin
GetCalendar;
end;

procedure TMainFormFP_2027.ClientLetter1Click(Sender: TObject);
begin
{Screen.Cursor := crHourGlass;}
//20160819 Igor >>>
  ShowLetterEditor(RetNo);
// Application.CreateForm(TRichFormFP_2012,RichForm);
// RichForm.ShowModal;
// RichForm.Free;
//20160819 Igor <<<
end;

procedure TMainFormFP_2027.PrintForm1Click(Sender: TObject);
Var i:integer;
    //20180503 Igor >>>
    PDFFullfileName: string;
    PDF: TvtPDFPrinter;
    //20180503 Igor <<<
begin
 If ButtonInactive then exit;
 FastPrint := GetFastPrintIndicator; //False; //20160901 Igor
 CountDiagnostics(RetNo);
 If IsDemoVersion then
 begin
  ShowMessage('The FP Demo program does not allow printing');
  Exit;
 end;
with Ret[RetNo] do
 If MandatoryErrorCount+SeriousErrorCount>0 then
 begin
  If not MainForm.WizardPanel.visible then MainForm.AuditOpenBtnClick(Application);
  ShowMessage('FP plan has errors. Please fix before printing/filing');
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
    PDF := TvtPDFPrinter.Create(AppFP);
    try
      PDF.PrintForm(RetNo, FormName, 99, nil,
          FP_2027Print.PrintEditBox, nil, nil, nil);

      PDF.SaveToFile(PDFFullfileName, false);
      OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
    finally
      PDF.free;
    end;
  end
  else
  begin
     //LetterType := 'Cover';
     If PrintDialogItem.Execute then
     begin
       StartPrintForm(Retno,FormName,99);
       if Printer.Printing then //20160905 Igor
         Printer.EndDoc;        //20160905 Igor
     end;
  end;
  //20180503 Igor <<<
end;

procedure TMainFormFP_2027.StartPrintForm(Retno:integer;FormName:String;WhichPage:integer);
begin
   Progress.Show;  {Show progress window}
   AbortSw := False;  {Initialize}
   PauseSw := False;
   Progress.Caption := 'Print progress...';
   Progress.Label1.Caption := 'Printing FP Plan:';
   Progress.Label2.Caption := GetRetName(RetNo);
   Progress.ListBox1.Visible := false;
   Progress.Gauge1.Visible := false;
  { Progress.BiGauge1.Visible := false;}
   Application.ProcessMessages;  {allows abort click on progrees screen }
   If AbortSw then
    begin
       Progress.Close;
       If Printer.Printing then
         begin Printer.Abort; {Printer.EndDoc;}exit;end; //20160910 igor
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

    PrintForm(RetNo,FormName,WhichPage);
//    if Printer.Printing then //20160901 Igor //20160905 Igor
//      Printer.EndDoc;        //20160901 Igor //20160905 Igor
 Progress.Close;
end;

procedure TMainFormFP_2027.PrintFBtnClick(Sender: TObject);
begin
PrintForm1Click(Sender);
end;

procedure TMainFormFP_2027.CreateDataDirectory1Click(Sender: TObject);
var s:sTring;
begin
 if CheckIsCloud then Exit; //20180503 Igor
 If LicenseLevel in anyMulti then
 begin
//  If YouKnowTheAdminPassword = False then exit;
 end;
 s:=CreateNewDataDir;
 If s>'' then
 begin
  SaveSingleOption('Dir_Cur',s);
  InitOptions;
 end;
end;



procedure TMainFormFP_2027.PrintTemplates1Click(Sender: TObject);
begin
Application.CreateForm(TPrSetFP_2012,PrSet);
PrSet.ShowModal;
PrSet.Free;

end;

procedure TMainFormFP_2027.FeeSchedule1Click(Sender: TObject);
begin
 {
 If LeftStr(LicenseLevel,8) = 'T1 Multi' then
 begin
  If YouKnowTheAdminPassword = False then exit;
 end;

 If RetInMem>0 then
  begin ShowMessage('Close all FP files first');exit;end;
  }
 Application.CreateForm(TFeesFP_2012,Fees);
 Fees.ShowModal;
 Fees.Free;
end;

procedure TMainFormFP_2027.Fonts1Click(Sender: TObject);
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




procedure TMainFormFP_2027.RemovecurrentreturnOverridesClick(Sender: TObject);
Var I,FNo:integer;RetNo:Integer;
begin
  RetNo:=GetCurrentRetNo;
  If RetNo >0 then {RemoveRetOverrides(RetNo);}
  begin
   If OverList.Count =0 then exit;
   i :=0;
   Repeat
     TObject(OverRec) := OverList.Items[i];
     if OverRec.RetNo = RetNo then
       begin
       FNo := OverRec.FormNo;
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


procedure TMainFormFP_2027.CouplBtnClick(Sender: TObject);
begin
//SetCurrentFieldOverrideClick(Sender);
end;

procedure TMainFormFP_2027.OverrideBtnClick(Sender: TObject);
begin

{ShowOverridesClick(Sender);}
{SetCurrentFieldOverrideClick(Sender);}
end;

procedure TMainFormFP_2027.DataDictionary1Click(Sender: TObject);
begin
  FixDbForm(AppDir, DictDBLite, DictTableLite, dbtDataDict);//20150918 Igor
end;

procedure TMainFormFP_2027.DiagnosticsClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 AuditOpenBtnClick(Sender);
 {If not AuditPanel.Visible then AuditBtnClick(Sender);}
end;

procedure TMainFormFP_2027.SamplesBtnClick(Sender: TObject);
begin
OptRec.Dir_Cur := OptRec.Dir_Sample;
FileOpenItemClick(Sender);
end;


procedure TMainFormFP_2027.DetailSchedules1Click(Sender: TObject);
Var Template:String;
begin
 If IsDemoVersion then
 begin
  ShowMessage('The FP Demo program does not allow printing');
  Exit;
 end;
 If ButtonInactive then exit;
 //Template:=GetPrintTemplate;
 FullPrint(RetNo,Template); //,FormsToPrint,Template:string);
end;


procedure TMainFormFP_2027.DeveloperOnly1Click(Sender: TObject); //20180206 Igor //20190415 Igor
begin
  if GetDeveloperPwd then
  begin
    DeveloperOnly1.OnClick := nil;
  end;
end;

Procedure TMainFormFP_2027.FullPrint(RetNo:Integer;Template:String);
Var i,j: integer; FormsToPrint :TstringList;
begin
 FormsToPrint := TstringList.Create;
 FormsToPrint.Sorted :=False;
 Template:=GetPrintTemplate;
 GetFormsToPrint(RetNo,Template,FormsToPrint);

 ResortFormsToPrint(FormsToPrint);
 If FormsToPrint.Count =0 then
    begin
    ShowMessage('Selected template has no forms for printing');
    FormsToPrint.Free;
    exit;
  end;
 FastPrint := GetFastPrintIndicator; //20160901 Igor
 If PrintDialogItem.Execute then PrintReturn(RetNo,FormsToPrint,Template);
 FormsToPrint.Free;
 PdfPrint:=False;
end;


procedure TMainFormFP_2027.PrintReturn(RetNo:integer;FormsToPrint:TstringList;Template:string);
//procedure TMainForm.PrintReturn(RetNo:integer;FormsToPrint:TstringList; DataDir:string;FlName:string);
var i,j,FCopies:integer; FName :string;
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
//   If FastPrint = True then Printer.BeginDoc; //20160901 Igor
   NeedNewPage := False; //20160901 Igor
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
         NeedNewPage := False; //20160901 Igor
       end;
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
      Try //20110228
      For j:=1 to FCopies do
       begin
        //ShowMessage('Printing '+Fname);
        PrintForm(RetNo,FName,1);
       end;
      Except
      end;
      Progress.Gauge1.Progress :=i+1;
      Progress.Gauge1.Refresh;
   end;
   If Printer.Printing then Printer.EndDoc; //20160901 Igor
   NeedNewPage := False; //20160901 Igor
   Progress.Close;
   {
   Ret[RetNo].Frm[GetFormNo('STATUS')].Strings[4] := '03';
   Ret[RetNo].PrpStatus :='03';
   UpdatePrintDate(RetNo,DataDir,FlName);
   }
   Screen.Cursor := crDefault;
end;

Procedure TMainFormFP_2027.UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
var FNo :integer;
    (* //20170329 Igor
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
  Ret[RetNo].Changed := True;
  (* //20170329 Igor
 If FileExists(DataDir+'\'+FlName) then
 begin
  TempList := TstringList.Create;
  Templist.LoadFromFile(DataDir+'\'+FlName);
  Templist.Add( 'F'+Delimiter+'STATUS'+Delimiter+Delimiter);
  TempList.Add('D'+Delimiter+'4'+Delimiter+'03'+Delimiter);
  TempList.Add('D'+Delimiter+'8'+Delimiter+User.UserName+Delimiter);//20170112 Igor
  TempList.Add('D'+Delimiter+'9'+Delimiter+FormatDateTime('yyyy-mm-dd',Now)+Delimiter);
  TempList.Add('D'+Delimiter+'10'+Delimiter+TimeToStr(Time)+Delimiter);
  Templist.SaveToFile(DataDir+'\'+FlName);
  TempList.Free;
 end;

 {now update the data base with RTU dates}
 //20150922 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'File_Name');

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
 *)
end;


(*
Procedure TMainFormFP_2027.UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
var FNo :integer; TempList :TStringList;
    ADConnection: TADConnection;
    Table1: TADTable;
begin
 FNo := GetFormNo('STATUS');
 Ret[RetNo].Frm[Fno].Strings[4] := '03';
 Ret[RetNo].Frm[Fno].Strings[8] := User.UserName; //20170112 Igor
 Ret[RetNo].Frm[Fno].Strings[9] := FormatDateTime('yyyy-mm-dd',Date);
 Ret[RetNo].Frm[Fno].Strings[10] := TimeToStr(Time);

 If FileExists(DataDir+'\'+FlName) then
 begin
  TempList := TstringList.Create;
  Templist.LoadFromFile(DataDir+'\'+FlName);
  Templist.Add( 'F'+Delimiter+'STATUS'+Delimiter+Delimiter);
  TempList.Add('D'+Delimiter+'4'+Delimiter+'03'+Delimiter);
  TempList.Add('D'+Delimiter+'8'+Delimiter+User.UserName+Delimiter);//20170112 Igor
  TempList.Add('D'+Delimiter+'9'+Delimiter+FormatDateTime('yyyy-mm-dd',Now)+Delimiter);
  TempList.Add('D'+Delimiter+'10'+Delimiter+TimeToStr(Time)+Delimiter);
  Templist.SaveToFile(DataDir+'\'+FlName);
  TempList.Free;
 end;

 {now update the data base with RTU dates}
 //20150922 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'File_Name');

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
*)




procedure TMainFormFP_2027.AddinstanceofForm1Click(Sender: TObject);
Begin
(*
 If RetInMem <1 then exit;
 ShowMessage('Instance added = '+IntTostr(AddNextFormInstance(FormName)));
 *)
end;

procedure TMainFormFP_2027.PersonaldataClick(Sender: TObject);
begin
If ButtonInactive then exit;
OpenForm(GetCurrentRetNo,GetFormNo('PROFILE'),0);
end;

procedure TMainFormFP_2027.FixTextoncurrentForm1Click(Sender: TObject);
begin
 (*
 If (FormNo = 0) or (RetInMem = 0) then exit;
 Application.CreateForm(TFrmText, FrmText);
 FrmText.ShowModal;
 FrmText.Free;
 *)
end;

procedure TMainFormFP_2027.FixDataDictionary1Click(Sender: TObject);
begin
  FixDbForm(AppDir, DictDBLite, DictTableLite, dbtDataDict);//20150918 Igor
end;

procedure TMainFormFP_2027.FixFormSpecifications1Click(Sender: TObject);
begin
  FixDbForm(AppDir, FormsDBLite, FormsTableLite, dbtForms);//20150918 Igor
  InitFormsTable;
end;

procedure TMainFormFP_2027.FixClientDataBaseData1Click(Sender: TObject);
begin
  FixDbForm(OptRec.Dir_Cur, ClientsDBLite, ClientsTableLite, dbtClients);//20150918 Igor
end;

procedure TMainFormFP_2027.ShowCellNumbers1Click(Sender: TObject);
begin
  MainForm.ShowCellNumbers1Click(Sender as TMenuItem);
end;

procedure TMainFormFP_2027.Operational1Click(Sender: TObject);
begin
Application.CreateForm(TDeskTopFP_2012,DeskTop);
DeskTop.ShowModal;
DeskTop.Free;
end;


procedure TMainFormFP_2027.ChangeDataDirectory1Click(Sender: TObject);
begin
 if CheckIsCloud then Exit; //20180503 Igor
 If LicenseLevel in anyMulti then
 begin
//  If YouKnowTheAdminPassword = False then exit;
 end;
 Application.CreateForm(TOptionsFrmFP_2012,OptionsFrm);
 OptionsFrm.ShowModal;
 OptionsFrm.Free;
//DataDirectories1Click(Sender);
end;

procedure TMainFormFP_2027.ClientListing1Click(Sender: TObject);
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

procedure TMainFormFP_2027.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 //If ServerMode=True then Application.Terminate;
 Action :=caNone;
 FileExitItemClick(Application);
end;



procedure TMainFormFP_2027.LoadSpousalReturnfromdatabaseCreate1Click(Sender: TObject);
begin
If ButtonInactive then exit;
end;



procedure TMainFormFP_2027.SwapReturns1Click(Sender: TObject);
Var RetNo,PrevRNo,PrevFNo :integer;
begin
  RetNo:=GetCurrentRetNo;
  If RetInMem(AppFP, True) < 2 then  //20161216 Igor //20170307 igor
  begin
   ShowMessage('To swap, you must have 2 or more FP files in memory');
   exit;
  end;
  PrevRNo := RetNo;
  PrevFNo:= FormNo;

  If RetInMem(AppFP, True) = 2 then //20161216 Igor //20170307 igor
   RetNo:=GetNextReturn(RetNo, True) //20170307 igor
  else
   RetNo := SelectFromLoadedReturns(RetNo, True); //20170307 igor
  LockWindowUpdate(MainForm.Handle);
  If Ret[Retno].CalcStatus = false then CalcAll(RetNo);
  OpenForm(RetNo, PrevFNo,0);
  If MainForm.LeftPanel.Visible then MainForm.RefreshAuditPanel(RetNo);
  LockWindowUpdate(0);
end;

procedure TMainFormFP_2027.Switchforms1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
   Switchforms;
end;

procedure TMainFormFP_2027.SwapFrmClick(Sender: TObject);
begin
 Switchforms1Click(Sender);
end;

procedure TMainFormFP_2027.FormsBtnClick(Sender: TObject);
begin
 //LetterType := 'Cover';
 SelectFormClick(Sender);
end;

procedure TMainFormFP_2027.UserSetUp1Click(Sender: TObject);
begin
Application.CreateForm(TUserSetup,UserSetUp);
UserSetUp.ShowModal;
UserSetUp.Free;
end;

procedure TMainFormFP_2027.TipsBtnClick(Sender: TObject);
begin
 QuickStarterGuide1Click(Sender);
end;


procedure TMainFormFP_2027.CopyForm1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 If RetInMem<2 then
 begin
  ShowMessage('Form Copy allowed only between different FP files in memory');
  exit;
 end;
 Application.CreateForm(TCopyFrmFP_2012,CopyFrm);
 CopyFrm.ShowModal;
 CopyFrm.Free;
end;

procedure TMainFormFP_2027.CopyBtnClick(Sender: TObject);
begin
CopyForm1Click(Sender);
end;

procedure TMainFormFP_2027.SchedBtnClick(Sender: TObject);
Var I:integer;
begin
  If ButtonInactive then exit;
  SomeList.Clear; //:= TStringList.Create;
  SomeCaption := 'Schedules';
  for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];
      If Frec.FormType = 'SC' then
      SomeList.Add(Frec.FormInstName);
   end;
  Application.CreateForm(TPopListFP_2012,PopList);
  PopList.ShowModal;
  //SomeList.Free; //20160704 Igor
  PopList.Release;
  If SelectedString = '' then exit;

end;



Procedure TMainFormFP_2027.ShowMultiOfficeMsg;
begin
 ShowMessage('This option is available only to firms'+Chr(13)+
   'with Multi-operator and/or Multi-office operations');
end;

(*
procedure TMainForm.UserSetUp2Click(Sender: TObject);
begin
If LeftStr(LicenseLevel,8) <> 'FP Multi' then
 begin
 ShowMessage('Option availably only in multi-office licenses');
 exit;
 end;
 Application.CreateForm(TMPswd,MPswd);
 MPswd.ShowModal;
 MPswd.Free;

 If UpperCase(GetAdminPassword('ADMIN')) <> UpperCase(MasterPswd) then
  begin
   ShowMessage('Only the Administrator can perform this function');
   exit;
  end;
 Application.CreateForm(TUserSetup,UserSetUp);
 UserSetUp.ShowModal;
 UserSetUp.Free;
end;
*)
procedure TMainFormFP_2027.HelpBtnClick(Sender: TObject);
Var HlpContextString :string;
begin
  If RetInMem(AppFP) > 0 then //20161220 Igor
   ShowHelp(AppFP.ModuleHelpFile, StripInstNo(ExtractFormRootName(FormName)), True) //20161220 Igor
 else
  ShowHelp(AppFP.ModuleHelpFile,'HELP_CONTENTS', true); //20161220 Igor
end;

procedure TMainFormFP_2027.Calculator1Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'Calc.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainFormFP_2027.Appointments2Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'Calendar.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainFormFP_2027.TransmitRTU1Click(Sender: TObject);
begin
{
Application.CreateForm(TPhone, Phone);
Phone.ShowModal;
Phone.Free;
}
end;

procedure TMainFormFP_2027.Contents2Click(Sender: TObject);
begin
  Application.HelpFile := 'T1Help.HLP';
  Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TMainFormFP_2027.SearchForHelpOnClick(Sender: TObject);
begin
 Application.HelpFile := 'T1Help.HLP';
 Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TMainFormFP_2027.SearchFormSelect(
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

procedure TMainFormFP_2027.VisualTaxGuide1Click(Sender: TObject);
begin
  ConnectToWeb('www.visualtax.com/Vt2020HELP/FpHelp/Website/index.html'); //20210703
  (*
  //20161220 Igor >>>
// ShowHelp('FpHelp','HELP_CONTENTS');
 //HelpBtnClick(Sender);
// ShowHelp('FpHelp','HELP_CONTENTS');
  if (RetInMem(AppFP) > 0) and
     (RetList[GetCurrentRetNo] <> nil) and
     (RetList[GetCurrentRetNo].MyChild <> nil) and
     (RetList[GetCurrentRetNo].MyChild.ActiveForm <> nil) then
    ShowHelp(AppFP.ModuleHelpFile, StripInstNo(ExtractFormRootName(RetList[GetCurrentRetNo].MyChild.ActiveForm.FormName)), True)
  else
    ShowHelp(AppFP.ModuleHelpFile, 'HELP_CONTENTS', True);
//20161220 Igor <<<
*)

end;

procedure TMainFormFP_2027.Allforms1Click(Sender: TObject);
Var I:integer;
begin
 If ButtonInactive then exit;
 ShowFieldIdSw := True;
 If PrintDialogItem.Execute then
 begin
   for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      If Frec.FormNo > 114 then
      begin
      If FRec.FormInst < '#2' then
       {ShowMessage(Frec.FormInstName);}
        PrintForm(GetCurrentRetNo,Frec.FormName+Frec.FormInst,99);
      end;
    end;
 end;
end;



procedure TMainFormFP_2027.MultipleDnBtnClick(Sender: TObject);
begin
  if NoActiveForm then exit;
  OpenPrevInstance(RetNo, FormName);
end;

procedure TMainFormFP_2027.MultipleUpBtnClick(Sender: TObject);
begin
  if NoActiveForm then exit;
  OpenNextInstance(RetNo,FormName);
end;


procedure TMainFormFP_2027.DependBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(RetNo,GetFormNo('DEPEND'),0);
end;

procedure TMainFormFP_2027.ABCBtnClick(Sender: TObject);
begin
 AlphabeticalFormsIndex1Click(Sender);
end;

procedure TMainFormFP_2027.PrintManager1Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'PrintMan.Exe', Nil,
  Nil, SW_RESTORE);
end;


procedure TMainFormFP_2027.ShowOverridesClick(Sender: TObject);
begin
  if ButtonInactive then exit;
  SomeCaption := 'Forms with Overrides';
  OverList.EnumRecs(AppFP, SomeList);
  SelectedString := PopSomeList(someList, SomeCaption);
 If SelectedString > '' then
   OpenForm(GetCurrentRetNo,GetFormNo(SelectedString),0);
end;

procedure TMainFormFP_2027.ShowReturn(ARetNo: integer); //20190212 Igor
begin
  if ARetNo > 0 then
  begin
    LockWindowUpdate(MainForm.Handle);
    CountDiagnostics(ARetNo);
    MainForm.GuiCommand(gcShowLeftPanel); //MainForm.LeftPanel.Visible:=True; //20160222 Igor
    //FormName := 'PROFILE';
    //FormNo := GetFormNo(FormName);
    OpenForm(ARetNo,'PROFILE',0);
    MainForm.FormPaint(Application);
  end;
end;

procedure TMainFormFP_2027.ListReviewmarks1Click(Sender: TObject);
Var I: integer;
begin
 If ButtonInactive then exit;
 {AuditOption.ItemIndex :=1;}
 {If not AuditPanel.Visible then AuditBtnClick(Sender);}

end;

procedure TMainFormFP_2027.SystemInformation1Click(Sender: TObject);
//20170901 Igor>>>
//Var h : THandle;
begin
// h := ShellExecute(MainForm.Handle, Nil, 'WINFO.Exe', Nil,
//  Nil, SW_RESTORE);
// if h<=32 then ShowMessage('Info cannot be displayed. Code '+IntToStr(h));
  MessageDlg(OSTest, mtInformation, [mbOk], 0);
//20170901 Igor<<<
end;

procedure TMainFormFP_2027.RebuildtheClientDataBase1Click(Sender: TObject);
begin
 If RetInMem>0 then
  begin ShowMessage('Please close all files first');exit;end;
 Application.CreateForm(TRebuildFP_2012,Rebuild);
 Rebuild.ShowModal;
 Rebuild.Free;
end;

procedure TMainFormFP_2027.MergeDataBases1Click(Sender: TObject);
begin
{ If Not FeatureAllowed then exit;}
 If RetInMem>0 then
  begin ShowMessage('Please close all files first');exit;end;
 Application.CreateForm(TMerge,Merge);
 Merge.ShowModal;
 Merge.Free;
end;

procedure TMainFormFP_2027.FileViewerEditor1Click(Sender: TObject);
begin
Application.CreateForm(TFileVuFP_2012,FileVu);
FileVu.ShowModal;
FileVu.Free;
end;

procedure TMainFormFP_2027.CurrentPage1Click(Sender: TObject);
//20180503 Igor >>>
var PDFFullfileName: string;
    PDF: TvtPDFPrinter;
//20180503 Igor <<<
begin
 If ButtonInactive then exit;
 FastPrint := False;
 If IsDemoVersion then
 begin
  ShowMessage('The FP Demo program does not allow printing');
  Exit;
 end;
 CountDiagnostics(GetCurrentRetNo);
  with Ret[RetNo] do
   If MandatoryErrorCount+SeriousErrorCount>0 then
   begin
    If not MainForm.WizardPanel.visible then MainForm.AuditOpenBtnClick(Sender);
    ShowMessage('FP plan has errors. Please fix before printing/filing');
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
    PDF := TvtPDFPrinter.Create(AppFP);
    try
      PDF.PrintForm(RetNo, FormName, 1, nil,
          FP_2027Print.PrintEditBox, nil, nil, nil);

      PDF.SaveToFile(PDFFullfileName, false);
      OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
    finally
      PDF.free;
    end;
  end
  else
  begin
    //LetterType := 'Cover';
    If PrintDialogItem.Execute then
    begin
     StartPrintForm(GetCurrentRetno,FormName,1);
     if Printer.Printing then //20160905 Igor
       Printer.EndDoc;        //20160905 Igor
    end;
  end;
  //20180503 Igor <<<
end;


procedure TMainFormFP_2027.RecalcBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 Screen.Cursor := crHourGlass;
 CalcAll(RetNo);
 Screen.Cursor := crDefault;
 If FormNo>0 then MyChild.ShowFormData(FormName,FormNo);
 MyChild.UpdateChildTaxPanel;
end;


procedure TMainFormFP_2027.PreselNextBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  MyChild.Pages.SelectNextPage(True);
end;

procedure TMainFormFP_2027.PreSelPrvBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  MyChild.Pages.SelectNextPage(False);
end;

procedure TMainFormFP_2027.ChangeLicenseLevel;
Var K,Psw:string;// PgmNames,ProductIds,PgmFactors:TstringList;
begin
  AppFP.SetLicense(InputBox('Input Box', '', ''));
 Licensee:='Some Multi-user';
 SelectFeatures;
 MainForm.FormPaint(Application);
End;

procedure TMainFormFP_2027.OnCreateMenuItem(const aName: string; //20190228 Igor //20190415 Igor
  const aHelperID: Integer);
var
  Item: TActionClientItem;
begin
//  Item := RBGReturn_Help.Items[1].Items.Add;
//  Item.Action := actForCloud;
//  Item.Caption := aName;
//  Item.Tag := aHelperID;
end;

procedure TMainFormFP_2027.OpenBtnClick(Sender: TObject);
begin
 FileOpenItemClick(Application);
end;

procedure TMainFormFP_2027.YourLatestReleaseClick(Sender: TObject);
// Var h : THandle;
begin
ConnectToWeb('www.visualtax.com/Vt2018HELP/FPHelp/FpUPD/Website/index.html'); //20190303
 //ShowHelp(AppFP.ModuleHelpUpdFile, 'HELP_CONTENTS', True); //20160801 Igor
end;


procedure TMainFormFP_2027.ZoomBtnPlusClick(Sender: TObject);
begin
  ZoomBtnClicked(+5); //20160209 Igor
//  if ZoomBtnClicked(+5) then
//    ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
end;

procedure TMainFormFP_2027.ZoomBtnMinusClick(Sender: TObject);
begin
  ZoomBtnClicked(-5); //20160209 Igor
//  if ZoomBtnClicked(-5) then
//    ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
end;

procedure TMainFormFP_2027.Image2Click(Sender: TObject);
begin
 MainForm.WizardPanel.Visible :=False;
end;


procedure TMainFormFP_2027.Upgrade1Click(Sender: TObject);
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

procedure TMainFormFP_2027.AuditListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If  (Key = VK_F5) then MainForm.AuditOpenBtnClick(Sender);
end;

procedure TMainFormFP_2027.BitBtn1Click(Sender: TObject);
begin
  EXIT;
end;

procedure TMainFormFP_2027.btnDownloadClick(Sender: TObject); //20190212 Igor
var Dir, FlName: String;
    AListItem: TListItem;
    Files: TArray<String>;
    I: integer;
begin
  if not CheckIsCloud(true) then Exit;
  for I := 0 to ListView2.Items.Count - 1 do
    if ListView2.Items[i].Checked or (Sender = btnDownloadAll) then
    begin
      FlName := TPath.Combine(AllTrim(ListView2.Items[i].SubItems[3]), AllTrim(ListView2.Items[i].SubItems[2]));
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

procedure TMainFormFP_2027.btnUploadClick(Sender: TObject); //20190212 Igor
var Files: TArray<String>;
    RetNo, I: Integer;
begin
  if not CheckIsCloud(true) then Exit;
  Files := UploadFile(OptRec.Dir_Cur, false);
  for I := 0 to Length(Files) - 1 do
  begin
    RetNo := OpenReturn(OptRec.Dir_Cur, Files[I], True);
    if RetNo <> 0 then
    begin
      ShowReturn(RetNo);
      SaveReturn(RetNo, OptRec.Dir_Cur, Files[I], true, true);
    end;
  end;
end;

procedure TMainFormFP_2027.btnUploadWithoutOpenClick(Sender: TObject); //20190212 Igor
var Files: TArray<String>;
    RetNo, I, Count: Integer;
begin
  if not CheckIsCloud(true) then Exit;
  Files := UploadFile(OptRec.Dir_Cur, false);
  Count := 0;
  for I := 0 to Length(Files) - 1 do
  begin
    RetNo := OpenReturn(OptRec.Dir_Cur, Files[I], False);
    if RetNo <> 0 then
    begin
      SaveReturn(RetNo, OptRec.Dir_Cur, Files[I], true, true);
      CloseReturn(RetNo, false);
      inc(Count);
    end;
  end;
  if Count > 0 then
    ShowMessage(IntToStr(Count) + ' returns have been uploaded to vtCloud' +chr(13)+'You can now open them via the Client book');
end;

procedure TMainFormFP_2027.Buildreport1Click(Sender: TObject); //20180424 Igor
begin
  if LicenseLevel in [llPower..llMultiPower] then
    ReportBuilder(AppFP)
  else
  begin
    ShowMessage('Available only in the Power version of the program');
    Exit;
  end;
end;

procedure TMainFormFP_2027.buttonAvailableWidthClick(Sender: TObject);
begin
  MainForm.GuiCommand(gcAvailableWidth);
end;

procedure TMainFormFP_2027.InternetWebSite1Click(Sender: TObject);
Var h:THandle;
begin
 ConnectToWeb('HTTP://www.VisualTax.com');
end;

procedure TMainFormFP_2027.WWWLblClick(Sender: TObject);
begin
 InternetWebSite1Click(Sender);
end;


procedure TMainFormFP_2027.WorldButtonClick(Sender: TObject);
begin
InternetWebSite1Click(Sender);
end;


procedure TMainFormFP_2027.AlphabeticalFormsIndex1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 Application.CreateForm(TABListFP_2012,ABList);
 ABList.ShowModal;
 ABList.Free;

//ABCBtnClick(Sender);
end;

procedure TMainFormFP_2027.amFPStateChange(Sender: TObject); //20180206 Igor //20190415 Igor
var
  I: Integer;
begin
  if (MainOptions.Skin = skRibbon) and (amFP.State = TActionListState.asNormal) then
  begin
    for I := 0 to amFP.ActionCount - 1 do
    begin
      amFP.Actions[I].Enabled := not amFP.Actions[I].Enabled;
      amFP.Actions[I].Enabled := not amFP.Actions[I].Enabled;
    end;
  end;
end;

procedure TMainFormFP_2027.Zoomin1Click(Sender: TObject);
begin
ZoomBtnPlusClick(Sender);
end;

procedure TMainFormFP_2027.Zoomout1Click(Sender: TObject);
begin
ZoomBtnMinusClick(Sender);
end;

procedure TMainFormFP_2027.Toolbandswitch1Click(Sender: TObject);
begin
 ToolBarBtnClick(Sender);
end;

procedure TMainFormFP_2027.Color1Click(Sender: TObject);
//Var Clr : Tcolor; RetNo:Integer;
begin
 If ButtonInactive then exit;
  MainForm.ClrClick(RetNo, Sender, c_ReturnColorElm); //20170225 Igor
end;

procedure TMainFormFP_2027.ReIndextheClientDataBase1Click(Sender: TObject);
begin
ExecuteForm(TReindexDbFP_2012);
end;


procedure TMainFormFP_2027.ReloadMainMenu; //20190228 Igor
begin
  LoadPluginActions(Self, MainMenu, OpenFromCloudClick, OnCreateMenuItem);
end;

procedure TMainFormFP_2027.WidePanelBtnClick(Sender: TObject);
Var Denom:Integer;
begin
end;

procedure TMainFormFP_2027.AuditOpenBtnClick(Sender:TObject);
begin
 If ButtonInactive then exit;
 //LockWindowUpdate(MainForm.Handle);
 MainForm.GuiCommand(gcToggleLeftPanel); // MainForm.LeftPanel.Visible := not MainForm.LeftPanel.Visible; //20160222 Igor
 MainForm.RefreshAuditPanel(GetCurrentRetNo);
 //LockWindowUpdate(0);
end;

procedure TMainFormFP_2027.Checkupdate1Click(Sender: TObject);
Var h:THandle;
begin
 ConnectToWeb('https://www.visualtax.com/download.php');
end;

procedure TMainFormFP_2027.Image1Click(Sender: TObject);
 Var h : Thandle;
begin
 Checkupdates1Click(Sender);
end;

procedure TMainFormFP_2027.CheckUpdatesLblClick(Sender: TObject);
begin
 Checkupdates1Click(Sender);
end;

procedure TMainFormFP_2027.Label1Click(Sender: TObject);
begin
 InternetWebSite1Click(Sender);
end;

procedure TMainFormFP_2027.ClearCurrentformClick(Sender: TObject);
Var i,n:Integer;Root:String;
begin
  ClearCurrentPageClick(Sender);
end;

procedure TMainFormFP_2027.ClearCurrentPageClick(Sender: TObject);
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
 MyChild.ActiveForm.RebuildDynamicRows; //20160527 Igor
 MyChild.ShowFormData(FormName,FormNo);
 Ret[RetNo].FrmHasData[GetFormNo(FormName)]:=False;
 MainForm.RefreshAuditPanel(RetNo);//If AuditPanel.Visible then RefreshAuditPanel;
 //If FormsPanel.Visible then RefreshFormsPanel(RetNo);
end;

Procedure TMainFormFP_2027.GetListOfLoadedReturns(SomeList:TStringList);
Var i:Integer;
Begin
 SomeList.Clear;
 SomeList.Sorted := True;
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   SomeList.Add(GetReturnCaption(RetRec.RetNo));
 end;
end;

procedure TMainFormFP_2027.CharityOrganizations1Click(Sender: TObject);
begin
 SomeCaption:='Charity Organizations';
 SomeLabel:='Used for predictive entry in the Donations list';
 SomeFile:='Charity.Txt';
 Application.CreateForm(TDFilesFP_2012,DFiles);
 DFiles.ShowModal;
 DFiles.Free;
end;

procedure TMainFormFP_2027.CompanyLogo1Click(Sender: TObject);
begin
  if (LicenseLevel in anyMulti)
 then
 //ok
 else
 begin
  ShowMessage('Available only in the Power version of the program');
  Exit;
 end;
end;

procedure TMainFormFP_2027.ImportConfiguration1Click(Sender: TObject);
begin
 if CheckIsCloud then Exit; //20180503 Igor
 Application.CreateForm(TImportConfigFP_2012,ImportConfig);
 ImportConfig.ShowModal;
 ImportConfig.Free;
end;


procedure TMainFormFP_2027.ImportfromProduction1Click(Sender: TObject); //20160305 Igor
begin
  If getCurrentRetNo > 0 then
  begin
    ShowMessage('Please close all returns first');
    Exit;
  end;

  If OptRec.Dir_DBFData = '' then
  begin
    ShowMessage('You should first enter the Data Directory of the FP-2018 Production data'
                +Chr(13)+'See Configure | General Options | Data Directories');
    Exit;
  end;

  ExecuteForm(TImportDBFFP_2027);

end;

procedure TMainFormFP_2027.ExportConfiguration1Click(Sender: TObject);
begin
 if CheckIsCloud then Exit; //20180503 Igor
 Application.CreateForm(TExportConfigFP_2012,ExportConfig);
 ExportConfig.ShowModal;
 ExportConfig.Free;

end;


procedure TMainFormFP_2027.UsefulLinksClick(Sender: TObject);
Var h:THandle;
begin
  ConnectToWeb('https://www.visualtax.com/links.php');
end;

procedure TMainFormFP_2027.SetReturnPassword1Click(Sender: TObject);
Var s:String;
begin
  If buttonInactive then exit;
  Application.CreateForm(TSetFilePswFP_2012,SetFilePsw);
  SetFilePsw.ShowModal;
  SetFilePsw.Free;
end;

procedure TMainFormFP_2027.SetSearchStr(const AValue: String); //20180206 Igor //20190415 Igor
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

procedure TMainFormFP_2027.SetZoomStr(const Value: String); //20180206 Igor
begin
  ZoomPercentLbl.Caption := Value;
  lblZoom.Caption := Value;
  lblZoom2.Caption := Value;
end;

procedure TMainFormFP_2027.RemoveReturnPassword1Click(Sender: TObject);
begin
 If buttonInactive then exit;
 RemoveReturnPsw(RetNo);
 ShowTimedMsg('Password Removed',1000);
end;

procedure TMainFormFP_2027.SetProgramPassword1Click(Sender: TObject);
begin
  SetThePgmPsw;
end;

procedure TMainFormFP_2027.RemoveProgramPassword1Click(Sender: TObject);
begin
 RemovePgmPsw;
 ShowTimedMsg('Program Password Removed',1000);
end;

procedure TMainFormFP_2027.PrintAuditBtnClick(Sender: TObject);
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

procedure TMainFormFP_2027.PrintAuditWizardDiagnostics1Click(Sender: TObject);
begin
If ButtonInactive then exit;
If IsDemoVersion then
 begin
  ShowMessage('The FP Demo program does not allow printing');
  Exit;
 end;
 CountDiagnostics(RetNo);
 PrintAuditBtnClick(Sender);
end;

procedure TMainFormFP_2027.EmailCurrentFormClick(Sender: TObject);
Var RetNo:Integer;
begin
 If buttoninactive then exit;
 If IsDemoVersion then
 begin
  ShowMessage('The FP Demo program does not allow printing');
  Exit;
 end;
 RetNo:=GetCurrentRetNo;
 If not IsFormMultipage(FormName) then
  Calc(RetNo,FormName)
 else
  CalcMultiPageForm(RetNo,FormName);
 PrintFormForEmail(RetNo,FormName);
end;

procedure TMainFormFP_2027.PrintFormForEmail(RetNo:Integer;FormName:String);
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
  Application.CreateForm(TPDFFrmFP_2012,PdfFrm);
  PdfFrm.ShowModal;
  PdfFrm.Free;
 end;
end;

procedure TMainFormFP_2027.SaveALLopenedreturns1Click(Sender: TObject);
begin
 SaveAllReturns;
end;


Function TMainFormFP_2027.SaveAllReturns:Boolean;
begin
(* multi-app: done in vtMain
*)
  If RY=1 then
  begin
    ShowMessage('A FP file is in Planning mode. Please use one-by-one Save (F3)');
    Result := False;
    Exit;
  end;
  Result := MainForm.SaveAllReturns;
end;

Function TMainFormFP_2027.DoSave(RNo: integer):Boolean;
//Function TMainFormFP_2012.SaveAllReturns:Boolean;
Var i:Integer;FlName,DataDir:String;
  //RetNoBk:Integer;RetNo:Integer;
begin
 //If RetInMem=0 then exit;
 Result:=False;
  if Ret[RNo].isAppendix then //20160704 Igor
    exit;
 // RetNo:=GetCurrentRetNo;
// RetNoBk:=RetNo;
{
 Screen.Cursor:=CrHourGlass;
 for i :=0 to (RetList.Count - 1) do
 begin
   RetRec := RetList.Items[i];
   RNo:=RetRec.RetNo;
}
   CalcAll(RNo);

   Ret[RNo].CalcStatus := True;
   {
   Ret[RNo].FedCalcStatus := True;
   Ret[RNo].OntCalcStatus := True;
   Ret[RNo].AlbCalcStatus := True;
   }
   CountDiagnostics(RNo);
   If Ret[RNo].MandatoryErrorCount > 0 then
   begin
    OpenForm(RNo,GetFormNo('PROFILE'),0);
    If not MainForm.LeftPanel.Visible then
    begin 
      MainForm.GuiCommand(gcShowLeftPanel); // MainForm.LeftPanel.Visible:=True;  //20160222 Igor
      MainForm.AuditOpenBtnClick(Application);
    End;
    MainForm.RefreshAuditPanel(RNo);
    ShowMessage('Please enter Mandatory data before saving and try again');
    Screen.Cursor:=CrDefault;
    exit;
   end;
   FlName := Ret[RNo].SourceFlName;
   If FlName = '' then
   FlName := LeftStr(FetchElm(RNo,'PROFILE',3),8)+
    '.'+RightStr(FetchElm(RNo,'PAGE_1',3),1);
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
    ShowMessage('Data directory '+DataDir + ' was not configured for FP plans');
    Exit;
   End;

   If Ret[RNo].Locked = true then
   begin
   ShowMessage('Cannot save: '+ GetRetName(RNo)+
     chr(13)+'This file has been locked');
   //exit;
   end
  else
  BEGIN
  {put changed STATUS form data}
  with Ret[RNo].Frm[GetFormNo('STATUS')] do
  begin
   {last update}
   Strings[11] := User.UserName; //20170112 Igor
   Strings[12] := FormatDateTime('yyyy-mm-dd',Now);
   Strings[13] := TimeToStr(Time);
  end;

  If SaveReturn(RNo,DataDir,FlName,True,True) = 0 then
  begin
     Ret[RNo].SourceDataDir := DataDir;
     Ret[RNo].SourceFlName := FlName;
     Ret[RNo].changed:=False;
   end
   else
   begin
      ShowMessage('FP plan was not saved... Press any key');
      exit;
   end;
  END;
{
 end;  //i
 Screen.Cursor:=CrDefault;
 ShowTimedMsg('All files saved',1200);
}
 Result:=True;
end;


procedure TMainFormFP_2027.SaveandCloseAllopenedreturns1Click(Sender: TObject);
begin
(* ??? - see CloseAllReturn
*)
 If RY=1 then
 begin
  ShowMessage('A file is in Planning mode. Please use one-by-one Save (F3)');
  Exit;
 end;
  if MainForm.SaveAllReturns then
    MainForm.CloseAllReturns;
end;

procedure TMainFormFP_2027.CloseallreturnsWITHOUTSaving1Click(Sender: TObject);
Var i:Integer;RetNo:Integer; //FHandle:THandle
begin
 if MessageDlg('Close ALL returns without saving them?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes
 then
    MainForm.CloseAllReturns;
end;


Procedure TMainFormFP_2027.CloseAllReturns;
begin
 If MainForm.SaveAllReturns= True then
  MainForm.CloseAllReturns;
end;

procedure TMainFormFP_2027.TestBlBoxClick(Sender: TObject);
Var FrmNm:String;RetNo:Integer;
begin


end;


procedure TMainFormFP_2027.CloseBlackBoxBtnClick(Sender: TObject);
Var Templist:TStringList;
begin
(*
 *)
end;

procedure TMainFormFP_2027.ProcessBlackBoxFile;
Var RetNo:Integer;
begin
(*
 *)
end;  //end blackbox


procedure TMainFormFP_2027.FormsBlackBoxBtnClick(Sender: TObject);
begin
 SelectFormClick(Sender);
end;



procedure TMainFormFP_2027.Provincialnews1Click(Sender: TObject);
begin
 Application.HelpFile := AppDir+'\'+'PROVNEWS.HLP';
 Application.HelpCommand(HELP_CONTENTS, 0);
end;

Function TMainFormFP_2027.CountFiles(Dir:String;FileExt:String):Integer;
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

procedure TMainFormFP_2027.CICALineByLineInternethelpNONResidents1Click(Sender: TObject);
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

procedure TMainFormFP_2027.OtherGuides1Click(Sender: TObject);
Var PgmPath,PgmFile:String;
begin
 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'CRA GUIDES';
 SomeList.LoadFromFile(AppDir+'\'+'GUIDES.d');
 Application.CreateForm(TPopListFP_2012,PopList);
 Poplist.Height:=500;
 PopList.ShowModal;
 //SomeList.Free; //20160704 Igor
 PopList.Release;
 If SelectedString > '' then
 begin
  PgmPath:=AppDir;
  PgmFile:=AllTrim(LeftStr(SelectedString,8))+'.PDF';
  ShowPdf(PgmPath,PgmFile);
 end;
end;

procedure TMainFormFP_2027.Checkupdates1Click(Sender: TObject);
Var h:THandle;
begin
  CheckUpdates(Self.Handle,AppName+'-'+AppYear);
end;

procedure TMainFormFP_2027.Frequentlyaskedquestions1Click(Sender: TObject);
Var h:THandle;
begin
  ConnectToWeb('http://www.visualtax.com/FPfaq.htm');
end;

procedure TMainFormFP_2027.VisualTaxForum1Click(Sender: TObject);
Var h:THandle;
begin
  ConnectToWeb('http://www.visualtax.com/cgi-bin/dcforum/dcboard.cgi');

end;

procedure TMainFormFP_2027.HowoftentocheckInternetUpdates1Click(Sender: TObject);
begin
 Application.CreateForm(TUpdateScheduleFP_2012,UpdateSchedule);
 UpdateSchedule.ShowModal;
 UpdateSchedule.Free;
end;

procedure TMainFormFP_2027.ListMultipleBtnClick(Sender: TObject);
Var I,J,MxPg,k,FNo:Integer; FName,FNonInst,FRootName,FInst:string;RetNo:Integer;
begin
RetNo:=GetCurrentRetNo;
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
      FInst:=Frec.FormInst;
      If Ret[RetNo].FrmHasData[FNo] then
      Begin
//        Somelist.Add(PaddR(FNonInst+FInst,10)); //20160704 Igor
        If LeftStr(FormName,10)='PORTFOLIO#' then
          Somelist.Add(PaddR(FNonInst+FInst,10)+' '+FetchElmFNo(RetNo,FNo,1)+' '+FetchElmFNo(RetNo,FNo,2))
        else
         Somelist.Add(PaddR(FNonInst+FInst,10));
      end;
    end; //found the form
   end;  //i
   SomeCaption := 'List of multi-instance forms';
   Application.CreateForm(TPopListFP_2012,PopList);
   PopList.ShowModal;
   //SomeList.Free; //20160704 Igor
   PopList.Release;
   If SelectedString > '' then OpenForm(RetNo,GetFormNo(AllTrim(LeftStr(SelectedString,10))),0);
   Exit;
 end;  //check slips
end;

procedure TMainFormFP_2027.VerticalSplitter2CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
// If TreeViewPanel.Width < 50 then Exit;
 If NewSize <35 then begin NewSize :=35;Accept := True;end;
end;

procedure TMainFormFP_2027.TileHorizontally1Click(Sender: TObject);
begin
  MainForm.TileHorizontally1Click;
end;

procedure TMainFormFP_2027.TileVertical1Click(Sender: TObject);
begin
  MainForm.TileVertical1Click;
end;


//20151017 Igor
procedure TMainFormFP_2027.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := false;
  // 20151017 Convert *.dbf => *.db on OptRec.Dir_Cur and AppDir
  //20160118 Igor
  vtDataModuleUnit.{vtDataModule.}DataBaseCreate(AppFP.SQLLitePassword,AppFP.ClientsDBLite,IncludeTrailingPathDelimiter(OptRec.Dir_Cur), IncludeTrailingPathDelimiter(AppDir));
end;

procedure TMainFormFP_2027.NewReturnLblClick(Sender: TObject);
begin
  FileNewItem_Click(Sender);
end;

procedure TMainFormFP_2027.OpenReturnLblClick(Sender: TObject);
begin
FileOpenItemClick(Sender);
end;

procedure TMainFormFP_2027.ShowMostRecentReturns;
Var I:Integer;SomeList:TStringList;
    AColumn:TListColumn;
    AListItem:TListItem;
    MaxReturns:Integer;
    SL: TStringList;
Begin
  if Application.Terminated then exit; //20170113 Igor
  //20170127 Igor >>>
  MostRecentLbl.Visible := not MainOptions.HideMostRecent;
  ListView2.Visible :=  not MainOptions.HideMostRecent;
  OpenItBtn.Visible :=  not MainOptions.HideMostRecent;
  EMailItBtn.Visible :=  not MainOptions.HideMostRecent;
  CopyAReturnBtn.Visible :=  not MainOptions.HideMostRecent;
  //20170127 Igor <<<

  If MainOptions.HideMostRecent then Exit;
  With ListView2 do
  begin
    ListView2.Items.BeginUpdate; //20170127 Igor
    try                          //20170127 Igor
      ListView2.Items.Clear;
      ListView2.Columns.Clear; //20170130 Igor
  //    ListView2.Visible:=False;
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
      try //20170127 Igor
        If FileExists(AppDir+'\'+RecentFlName) then
        begin
         SomeList.LoadFromFile(AppDir+'\'+RecentFlName);
         MaxReturns:=SomeList.Count-1;
         If MaxReturns>30 then MaxReturns:=30;
         //20160321 Igor >>>>
         SL := TStringList.Create;
         SL.Delimiter := RecentDelimiter;
         SL.QuoteChar := RecentQuoteChar;
         try
           For i:=0 to MaxReturns do //SomeList.count-1 do
           begin
             //ListBox1.Items.Add(SomeList[i]);
             SL.DelimitedText := SomeList[i];
             if SL.Count > 4 then
             Begin
               AListItem := Items.Add;
               if SL.Count > 0 then
                 AListItem.Caption := SL[0];
               if SL.Count > 1 then
                 AListItem.SubItems.Add(SL[1]);
               if SL.Count > 2 then
                 AListItem.SubItems.Add(SL[2]);
               if SL.Count > 3 then
                 AListItem.SubItems.Add(SL[3]);
               if SL.Count > 4 then
                 AListItem.SubItems.Add(SL[4]);
             End;
           end;
         finally
           SL.Free;
         end;
         //20160321 Igor <<<<
        end;
//20170127 Igor >>>
      finally
        SomeList.Free;
      end;
    finally
      ListView2.Items.EndUpdate
    end;
  end; //with
//  ListView2.Visible:=True;
//20170127 Igor <<<
end;

procedure TMainFormFP_2027.WhatsNewLblClick(Sender: TObject);
begin
YourLatestReleaseClick(Sender);
end;

procedure TMainFormFP_2027.FaQLblClick(Sender: TObject);
begin
Frequentlyaskedquestions1Click(Sender);
end;

procedure TMainFormFP_2027.HelpLblClick(Sender: TObject);
begin
VisualTaxGuide1Click(Sender);
end;

procedure TMainFormFP_2027.ForumLblClick(Sender: TObject);
begin
VisualTaxForum1Click(Sender);
end;


procedure TMainFormFP_2027.Lockreturnagaistchanges1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 LockReturn(GetCurrentRetNo);
end;

procedure TMainFormFP_2027.UnlockReturn1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 UnlockReturn(GetCurrentRetNo);
end;

procedure TMainFormFP_2027.SetHorScrollBarInListBox(ListBox: TListBox; MaxWidth: Integer);
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


procedure TMainFormFP_2027.ListView1DblClick(Sender: TObject);
Begin
 OpenItBtnClick(Sender);
end;

procedure TMainFormFP_2027.ListView2KeyPress(Sender: TObject; var Key: Char);
begin
 if (Key = #13) then {Return key}
   ListView1DblClick(Sender);
end;

procedure TMainFormFP_2027.Options2Click(Sender: TObject);
begin
 //If LeftStr(LicenseLevel,8) = 'FP Multi' then
 If LicenseLevel in anyMulti then
 begin
//  If YouKnowTheAdminPassword = False then exit;
 end;
 Application.CreateForm(TOptionsFrmFP_2012,OptionsFrm);
 OptionsFrm.ShowModal;
 OptionsFrm.Free;
end;


procedure TMainFormFP_2027.QuestionMarkLblMouseDown(Sender: TObject;
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

procedure TMainFormFP_2027.LicLevel1Click(Sender: TObject);
begin
ChangeLicenseLevel;
end;

procedure TMainFormFP_2027.PrepareDistr1Click(Sender: TObject);
begin
  AppFP.PrepareDistribution;
end;


procedure TMainFormFP_2027.ActionList1Execute(Action: TBasicAction; var Handled: Boolean);
begin
 //DataChanged:=True;
end;


procedure TMainFormFP_2027.EkUDFList1Functions0Calculate(Sender: TObject;
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

function TMainFormFP_2027.GetMyFormName: String; //20160405 Igor
begin
  //20180206 Igor >>>
  FRetNo := GetCurrentRetNo;
  if RetNo > 0 then
    MyChild := RetList[RetNo].MyChild;
  //20180206 Igor <<<
  if MyChild <> nil then
    MyForm := MyChild.ActiveForm
  else
    MyForm := nil;

  if MyForm <> nil then
    result := MyForm.FormName
  else
    Result := '';
end;

function TMainFormFP_2027.GetMyFormNo: Integer; //20160405 Igor
begin
  MyChild := RetList[RetNo].MyChild;
  if MyChild <> nil then
    MyForm := MyChild.ActiveForm
  else
    MyForm := nil;

  if MyForm <> nil then
    result := MyForm.FormNo
  else
    Result := 0;
end;

function TMainFormFP_2027.GetZoomStr: String; //20180206 Igor
begin
  Result := ZoomPercentLbl.Caption;
end;

Procedure TMainFormFP_2027.GetGraphic;
begin
 //ShowMessage('In GetGraphic');
end;

procedure TMainFormFP_2027.GoToaFormSection1Click(Sender: TObject);
begin
 //UHeaderFrame.SectionBtnClick(Sender);
end;

procedure TMainFormFP_2027.EmailTheReturnClick(Sender: TObject);
Var i,j: integer; FormsToPrint :TstringList;
    Template :string;
    s:String;
begin
 If ButtonInactive then exit;
 If IsDemoVersion then
 begin
  ShowMessage('The FP Demo program does not allow printing');
  Exit;
 end;
 //Template:='OTHER3';
 CalcAll(RetNo);
 CountDiagnostics(RetNo);
with Ret[RetNo] do
 If MandatoryErrorCount+SeriousErrorCount>0 then
 begin
  If not MainForm.WizardPanel.visible then MainForm.AuditOpenBtnClick(Sender);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Not AllowedToFullPrint(RetNo) then begin PdfPrint:=False;exit;end;

 Calc(RetNo,'DIAGNO');
 //LetterType := 'Cover';
 If Ret[Retno].CalcStatus = false then CalcAll(RetNo);
 UpdateAllDataIndicators(RetNo);
 //If SlipsAvailable(RetNo) then Ret[RetNo].FrmHasData[GetFormNo('T4SUM#1')] := True;

 //Template := GetPrintTemplate(True);

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

Procedure TMainFormFP_2027.PrintReturnForEmail(RetNo:Integer;Template:String);
begin
EXIT;
end;


procedure TMainFormFP_2027.OpenItBtnClick(Sender: TObject);
Var i:Integer;Dir,FlName,Sin:String;
 AListItem:TListItem;
 RetNo:Integer;
begin
  AListItem:=ListView2.ItemFocused;
  If AListItem = Nil then
  begin
   ShowTimedMsg('You must select a file first',1200);
   Exit;
  end;
  FlName := AllTrim(AListItem.SubItems[2]);
  Dir:=AllTrim(AListItem.SubItems[3]);
  Sin:=FlName;
  If FlName = '' then exit;
  If Length(FlName) = 10 then Sin := LeftStr(FlName,8)+MidStr(FlName,10,1);
  If IsOkToOpenReturn(Dir,FlName,Sin) = False then Exit;

  If Not ReturnFileExists(Dir+'\'+FlName) then //20160415 Igor
  begin
    ShowMessage('File '+Dir+'\'+FlName+' does not exist');
    Exit;
  end;
  RetNo:=OpenReturn(Dir,FlName,False);
  //20190212 Igor >>>
  ShowReturn(RetNo);
  {If RetNo > 0 then
  begin
    LockWindowUpdate(MainForm.Handle);
   CountDiagnostics(RetNo);
   MainForm.GuiCommand(gcShowLeftPanel); //MainForm.LeftPanel.Visible:=True; //20160222 Igor
   //FormName := 'PROFILE';
   //FormNo := GetFormNo(FormName);
   OpenForm(RetNo,'PROFILE',0);
   MainForm.FormPaint(Application);
  end;}
  //20190212 Igor <<<
end;

procedure TMainFormFP_2027.EMailItBtnClick(Sender: TObject);
Var i:Integer;Dir,FlName:String; AListItem:TListItem;
SomeSubject,SomeRecipientEMail,SomeSenderEMail,SomeAttachment:String;
SomeText:String;
begin
  AListItem:=ListView2.ItemFocused;
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

 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'Double click on item 1, 2, 3 or 4';
 SomeList.Add('1. Email the file (raw data file) to your own EMail...');
 SomeList.Add('2. Email the file (raw data file) to tax return Reviewer...');
 SomeList.Add('3. Email the file (raw data file) to VisualTax support...');
 SomeList.Add('4. Email the file (raw data file) to any Email address...');
 SomeList.Add('________________________________________________________________');
 SomeList.Add('5. EMail the file (Printout only) to any Email address...');
 SomeList.Add('   See also: Print|Email current form...(after opening the file)');

 Application.CreateForm(TPopListFP_2012,PopList);
 PopList.ShowModal;
 //SomeList.Free; //20160704 igor
 PopList.Release;
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

  If SelectedString='3' then SomeRecipientEmail:='VisualTax@Sympatico.ca';
  If SelectedString='4' then SomeRecipientEmail:='';

  FlName := AllTrim(AListItem.SubItems[2]);
  Dir:=AllTrim(AListItem.SubItems[3]);

  SomeSenderEmail:='';  //default?  'VisualTax@Sympatico.ca';
  SomeSubject:='A FP file';
  SomeAttachment:=Dir+'\'+FlName;
  SomeText:=Chr(13)
                +'The FP file is attached'
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

function TMainFormFP_2027.SendMAPIMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
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
      lpszSubject := PAnsiChar(''+Subject);   //20150819  Igor

    if (Body <> '') then
      lpszNoteText := PAnsiChar(''+Body);       //20150819  Igor

    if (SenderEmail <> '') then
    begin
      lpSender.ulRecipClass := MAPI_ORIG;
      if (SenderName = '') then
        lpSender.lpszName := PAnsiChar(''+SenderEMail)   //20150819  Igor
      else
        lpSender.lpszName := PAnsiChar(''+SenderName);     //20150819  Igor
      lpSender.lpszAddress := PAnsiChar(''+SenderEmail);     //20150819  Igor
      lpSender.ulReserved := 0;
      lpSender.ulEIDSize := 0;
      lpSender.lpEntryID := nil;
      lpOriginator := @lpSender;
    end;

    if (RecipientEmail <> '') then
    begin
      lpRecipient.ulRecipClass := MAPI_TO;
      if (RecipientName = '') then
        lpRecipient.lpszName := PAnsiChar(''+RecipientEMail)   //20150819  Igor
      else
        lpRecipient.lpszName := PAnsiChar(''+RecipientName);    //20150819  Igor
      lpRecipient.lpszAddress := PAnsiChar(''+RecipientEmail);   //20150819  Igor
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
      FileAttach.lpszPathName := PAnsiChar(''+FileName);    //20150819  Igor

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

procedure TMainFormFP_2027.HelpIndexBtnClick(Sender: TObject);
begin
 ShowHelp(AppFP.ModuleHelpFile,'HELP_CONTENTS', True); //20161220 Igor
end;

procedure TMainFormFP_2027.Backupthetaxdata1Click(Sender: TObject);
Var i:Integer;LastBackUp,Dir:String;  TempList:TStringList; DoneOk:Boolean;
  ClickedOK: Boolean;  NewDir: string;
begin
 If OptRec.BackUpDir='' then
 begin
  ShowMessage('Please enter the backup directory in Configure | General Options | Data directories');
  Exit;
 end;
 Application.CreateForm(TBackupFrmFP_2012,BackUpFrm);
 BackUpFrm.ShowModal;
 BackUpFrm.Free;
end;

procedure TMainFormFP_2027.Restoredatafrombackup1Click(Sender: TObject);
Var i:Integer;LastBackUp,Dir:String;  TempList:TStringList; DoneOk:Boolean;
  ClickedOK: Boolean;  NewDir: string;
begin
 If OptRec.BackUpDir='' then
 begin
  ShowMessage('Please enter the backup directory in Configure | General Options | Data directories');
  Exit;
 end;
 Application.CreateForm(TRestoreFrmFP_2012,RestoreFrm);
 RestoreFrm.ShowModal;
 RestoreFrm.Free;
end;

procedure TMainFormFP_2027.CopyAReturnBtnClick(Sender: TObject);
Var i,ThisResult:Integer;Dir,FlName,Sin:String;
 AListItem:TListItem;
 RetNo:Integer;
begin
  if CheckIsCloud then Exit; //20180503 Igor
  If LicenseLevel in anyMulti then
  begin
//   If YouKnowTheAdminPassword = false then exit;
  end;

  AListItem:=ListView2.ItemFocused;
  If AListItem = Nil then
  begin
   ShowTimedMsg('You must select a file first',1200);
   Exit;
  end;
  SomeFile:=AllTrim(AListItem.SubItems[2]);   //FlName
  SomeString:=AllTrim(AListItem.SubItems[3]); //from dir
  SomeCaption:=AllTrim(AListItem.Caption); //return name
  Application.CreateForm(TCopyMoveFrmFP_2027,CopyMoveFrm); //20160327 Igor
  CopyMoveFrm.ShowModal;
  CopyMoveFrm.Free;
  If SomeResult=True then
    ShowMessage('Done')
  Else
   ShowMessage('Failed!');
  ShowMostRecentReturns; //updates the main menu
end;

procedure TMainFormFP_2027.Label4Click(Sender: TObject);
begin
TUTORIALS1Click(Sender);
end;


procedure TMainFormFP_2027.lblRolloverReturnClick(Sender: TObject);
begin
 RolloverVisualTax1Click(Sender);   //20170411
end;

procedure TMainFormFP_2027.ToolButton1Click(Sender: TObject);
begin
  FileNewItem_Click(Sender);
end;

procedure TMainFormFP_2027.NewBtnToolBarClick(Sender: TObject);
begin
  FileNewItem_Click(Sender);
end;

procedure TMainFormFP_2027.OpenBtnToolBarClick(Sender: TObject);
begin
 FileOpenItemClick(Application);
end;

procedure TMainFormFP_2027.CloseBtnToolBarClick(Sender: TObject);
begin
  FileCloseItemClick(Sender);
end;

procedure TMainFormFP_2027.SaveBtnToolBarClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 FileSaveAsItemClick(Sender);
end;

procedure TMainFormFP_2027.SwapBtnClick(Sender: TObject);
begin
SwapReturns1Click(Sender);
end;


procedure TMainFormFP_2027.QuickFindBtnKeyPress(Sender: TObject; var Key: Char); //20170418 Igor
begin
  If ButtonInactive then exit;
  If key = #13 then
  begin
    If QuickFindBtn.text = '' then
      exit;
    QuickFormFind(RetNo, QuickFindBtn.text);
  end;
end;

procedure TMainFormFP_2027.QuickStarterGuide1Click(Sender: TObject);
begin
 ShowHelp(AppFP.ModuleHelpFile,'Quick_Start_Guide', True); //20161220 Igor
end;


procedure TMainFormFP_2027.QuickStartLblClick(Sender: TObject);
begin
QuickStarterGuide1Click(Sender);
end;

Procedure TMainFormFP_2027.OpenDelphiForm(RetNo:Integer;FName:String);
Var  FClass : TFormClass;
     FormObject : TForm;
begin
 If NoClient(RetNo) then exit;
 FName:= UpperCase(FName);

 If FName = 'SHORTFALL' then ExecuteForm(TShortFallFrmFP_2012);
 If FName = 'MORTGAGE' then ExecuteForm(TMortgageCalculatorFP_2012);
 If FName = 'SAVINGS' then ExecuteForm(TSavingsCalculatorFP_2012);
 If FName = 'NESTEGG' then ExecuteForm(TNestEggCalculatorFP_2012);
 If FName = 'FUTVAL' then ExecuteForm(TFutureValueCalculatorFP_2012);
 If FName = 'PRESVAL' then ExecuteForm(TPresentValueCalculatorFP_2012);
 If FName = 'INCPROJECTION' then ExecuteForm(TIncomeStreamCalculatorFP_2012);
 If FName = 'DEBTREP' then ExecuteForm(TDebtRepaymentCalculatorFP_2012);
 If FName = 'RIFFRM' then ExecuteForm(TRIFFrmFP_2012);
 If FName = 'PROBATE' then ExecuteForm(TProbateFP_2012);
end;


procedure TMainFormFP_2027.OpenFromCloudClick(Sender: TObject); //20190228 Igor
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
      CloudFile := PopSomeList(SomeList, SomeCaption);
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
    hconf := HelperManager.Config(mi.HelperID, AppFP.AppId, User.UserName);
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
    hconf := HelperManager.Config((Sender as TAction).Tag, AppFP.AppId, User.UserName);
    CloudFile := '';
    ClientID := HelperManager.Config((Sender as TAction).Tag).ClientID;
    CloudPath := hconf.Path;
    Token := hconf.Token;
    LoadFromCloud((Sender as TAction).Tag);
  end;
end;

procedure TMainFormFP_2027.ImportTaxData1Click(Sender: TObject);
Var FromDataDir, FlName:String; FNo :integer;
FormsNeeded : TStringList; X:real;

begin
  FRetNo := GetCurrentRetNo; //20160323 Igor
  If RetNo< 1 then
  begin
    ShowMessage('You must open a new or existing client file'+
    Chr(13)+ 'before you can import tax return data');
    exit;
  end;

 FromDataDir:=OptRec.T1DataDir;
 If FromDataDir='' then
 begin
  ShowMessage('T1 data directory not found. Check Config | General Options | Data Directories');
  exit;
 end;

 FlName:='';
 If GetSinNo(RetNo) = '' then
 begin
  ShowMessage('You must enter the SIN of the client');
  exit;
 end
 else
  FlName:=LeftStr(GetSinNo(RetNo),8)+'.'+RightStr(GetSinNo(RetNo),1);

 if FileExists(FromDataDir+'\'+FlName) = false then
 begin
      ShowMessage('Tax file was not found.'+Chr(13)+
      'File names in T1 folder must be in the standard format 99999999.9 (SIN)');
      exit;
 end;
 ImportT1(RetNo,FromDataDir,FlName);
 RetList[RetNo].MyChild.RefreshActiveForm; //20160323 Igor
 ShowTimedMsg('Done',1000);
end;

procedure TMainFormFP_2027.FundAnalyser1Click(Sender: TObject);
begin
// ExecuteForm(TFundAnalyser);
 ExecuteForm(TFundsInWebFP_2012);
end;

procedure TMainFormFP_2027.MutualFundsDBmaintenance1Click(Sender: TObject);
begin
{$IFDEF ADO}
// If YouKnowTheAdminPassword = False then exit;
 If (IsPowerVersion) or (IsAgentVersion) or (isDealerVersion) then
 //ok
 Else
 begin
  ShowMessage('Available only in the Power, Agent and M/F Dealer version');
  Exit;
 end;

 ExecuteForm(TFundBase);
{$ELSE}
  ADOMsg('TFundBase');
{$ENDIF}
end;

procedure TMainFormFP_2027.PostMFpricestoBalanceSheet1Click(Sender: TObject);
begin
 If (Not IsAgentVersion) and (Not IsDealerVersion) then
 begin
  ShowMessage('Available only in the Investment Agent/Dealer version of the progam');
  exit;
 end;

// If YouKnowTheAdminPassword = False then exit;
 //ExecuteForm(TPostPrices);
end;

procedure TMainFormFP_2027.PostcompletedtransactionstoBS1Click(Sender: TObject);
begin
If (Not IsAgentVersion) and (Not IsDealerVersion)
 and (Not IsAgentDemo)  then
 begin
  ShowMessage('Available only in the Investment Agent/Dealer version of the progam');
  exit;
 end;
// If YouKnowTheAdminPassword = False then exit;
 //ExecuteForm(TPostTransactions);
end;

procedure TMainFormFP_2027.ModelPortfolios1Click(Sender: TObject);
var
  RetNo, FormNo: integer;
  FormName: string;
begin
 If GetRetNoFromSin(ModelPortfoliosSin)>0 then
 begin
  //ShowTimedMsg('Return of SIN '+RemoveChar(FlName,'.') +' is already loaded. Skipped',1200);
  Exit;
 end;

 If (IsPowerVersion) or (IsAgentVersion) and (IsDealerVersion)
 then
 //ok
 else
 begin
  ShowMessage('Available only in the Power version and Investment Agent/Dealer version of the progam');
  exit;
 end;
 If FileExists(AppDir+'\'+ModelPortfoliosFlName) = false then
 begin
   InitModelPortfolioFile;
 end;
 If Not FileExists(AppDir+'\'+ModelPortfoliosFlName) then Exit;
 RetNo:=OpenReturn(AppDir,ModelPortfoliosFlName,True);
 if RetNo < 1 then exit;

 FormName := 'PORTFOLIO#1';
 FormNo := GetFormNo(FormName);
 InitFormData(RetNo,FormNo);
 MainForm.GuiCommand(gcShowLeftPanel); //MainForm.LeftPanel.Visible:=True; //20160222 Igor
 OpenForm(RetNo,FormNo,0);
 MainForm.FormPaint(Application);
 MainForm.RefreshAuditPanel(RetNo);
end;

procedure TMainFormFP_2027.ClientPortfolios1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
 If (IsPowerVersion) or (IsAgentVersion) and (IsDealerVersion)
 then
 //ok
 else
 begin
  ShowMessage('Available only in the Power, Agent and Dealer version of the progam');
  exit;
 end;
 If NoClient(RetNo) then exit;
 OpenForm(RetNo,GetFormNo('PORTFOLIO#1'),0);
end;

procedure TMainFormFP_2027.ExecutiveSummary1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 If IsDemoVersion then
 begin
  ShowMessage('The FP Demo program does not allow printing');
  Exit;
 end;
 OpenForm(GetCurrentRetNo,GetFormNo('EXECSUM'),0)
end;

procedure TMainFormFP_2027.CoveringLetter1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 If IsDemoVersion then
 begin
  ShowMessage('The FP Demo program does not allow printing');
  Exit;
 end;
 OpenForm(GetCurrentRetNo,GetFormNo('CLETTER'),0)
end;

procedure TMainFormFP_2027.EnngagementLetter1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 OpenForm(GetCurrentRetNo,GetFormNo('ENGAGE'),0)
end;

procedure TMainFormFP_2027.PIPEDAPrivacyletter2Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 If IsDemoVersion then
 begin
  ShowMessage('The FP Demo program does not allow printing');
  Exit;
 end;
 OpenForm(GetCurrentRetNo,GetFormNo('PIPEDA'),0)
end;

procedure TMainFormFP_2027.ClientPresentationBtnClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(GetCurrentRetNo,GetFormNo('EXECSUM'),0);
end;

procedure ShowTVSection(id: integer);
begin
 LoadTreeView('TreeView.d',id);
  MainForm.GuiCommand(gcRefreshFormsPanel); //shows Treeview2.d
  MainForm.GuiCommand(gcShowFormsPanel); //20230307 Igor
end;

procedure TMainFormFP_2027.PresentSituationBtnClick(Sender: TObject);
begin
  ShowTVSection(1);
end;

procedure TMainFormFP_2027.GoalsAssumptionsBtnClick(Sender: TObject);
begin
  ShowTVSection(2);
end;

procedure TMainFormFP_2027.ProblemAnalysisBtnClick(Sender: TObject);
begin
  ShowTVSection(3);
end;

procedure TMainFormFP_2027.PlanOfActionBtnClick(Sender: TObject);
begin
  ShowTVSection(4);
end;

procedure TMainFormFP_2027.ImplementationBtnClick(Sender: TObject);
begin
 If (IsAgentVersion) or (IsDealerVersion) then
 //ok
 else
 begin
  ShowMessage('Available only in Agent or M/F Dealer version');
  Exit;
 end;

  ShowTVSection(5);
end;

procedure TMainFormFP_2027.PerformanceReviewBtnClick(Sender: TObject);
begin
  ShowTVSection(6);
end;


procedure TMainFormFP_2027.PIPEDAPrivacyLetter1Click(Sender: TObject);
begin
 If IsDemoVersion then
 begin
  ShowMessage('The FP Demo program does not allow printing');
  Exit;
 end;
 SomeLetterName:='COVER.RTF';
 OpenForm(GetCurrentRetNo,GetFormNo('ALETTER'),0)
end;

procedure TMainFormFP_2027.AttachmentsCoverPage1Click(Sender: TObject);
begin
 If IsDemoVersion then
 begin
  ShowMessage('The FP Demo program does not allow printing');
  Exit;
 end;
 SomeLetterName:='ATTACH.RTF';
  OpenForm(GetCurrentRetNo,GetFormNo('ALETTER'),0)
end;

procedure TMainFormFP_2027.ClientListings1Click(Sender: TObject);
begin
 If IsDemoVersion then
 begin
  ShowMessage('The FP Demo program does not allow printing');
  Exit;
 end;
end;

procedure TMainFormFP_2027.Assets1Click(Sender: TObject);
//20170803 Igor>>>
var
  Err: String;
begin
  if ButtonInactive then
    exit;
  if not CopyDB('Assets', AppDir, OptRec.Dir_Cur, Err) then
  begin
    ShowMessage(Err);
    Exit;
  end;
  PopulateAssetsDbf(RetNo);
  if IsDemoVersion then
    ShowMessage('Printing Not available in the demo version');
  Application.CreateForm(TRepAssetsFP_2027, RepAssets);
  try
  //20150819  Igor Report := RepAssets.QuickRep1;
  //20150819  Igor Report.Preview;
  finally
    RepAssets.Free;
  end;
//20170803 Igor<<<
end;

procedure TMainFormFP_2027.Liabilitie1Click(Sender: TObject);
begin
 If IsDemoVersion then ShowMessage('Printing Not available in the demo version');
 CopyFile(AppDir+'\'+LiabilitiesDBLite,OptRec.Dir_Cur+'\'+LiabilitiesDBLite); //20150923 Igor
 Application.CreateForm(TRepLiabilities,RepLiabilities);
  //20150819  Igor Report := RepLiabilities.QuickRep1;
  //20150819  Igor Report.Preview;
 RepLiabilities.Free;
end;

procedure TMainFormFP_2027.NestEggCalculator1Click(Sender: TObject);
begin
 ExecuteForm(TNestEggCalculatorFP_2012);
end;

procedure TMainFormFP_2027.SavingsCalculator1Click(Sender: TObject);
begin
 ExecuteForm(TSavingsCalculatorFP_2012);
end;

procedure TMainFormFP_2027.Debtrepaymentcalculator1Click(Sender: TObject);
begin
 ExecuteForm(TDebtRepaymentCalculatorFP_2012);
end;

procedure TMainFormFP_2027.PresentValueCalculator1Click(Sender: TObject);
begin
 ExecuteForm(TPresentValueCalculatorFP_2012);
end;

procedure TMainFormFP_2027.FutureValueCalculator1Click(Sender: TObject);
begin
 ExecuteForm(TFutureValueCalculatorFP_2012);
end;

procedure TMainFormFP_2027.MortgageAmortizationCalculator1Click(Sender: TObject);
begin
 ExecuteForm(TMortgageCalculatorFP_2012);
end;

procedure TMainFormFP_2027.ProbateFeesCalculator1Click(Sender: TObject);
begin
 ExecuteForm(TProbateFP_2012);
end;

procedure TMainFormFP_2027.MainUIRibbonCommandCreate(const Sender: TUIRibbon; //20190415 Igor
  const Command: TUICommand);
begin
  case Command.CommandId of
	    FP_UIRibbonUnit.CommandSearchForm1:
	      begin
          FSearchForm1 := TUICommandCollection(Command);
          FSearchForm1.OnSelect := SearchFormSelect;
	      end;
      FP_UIRibbonUnit.CommandSearchForm2:
	      begin
          FSearchForm2 := TUICommandCollection(Command);
          FSearchForm2.OnSelect := SearchFormSelect;
	      end;
  end;
end;

procedure TMainFormFP_2027.MathematicalCalculator1Click(Sender: TObject);
Var h : THandle;
begin
  h := ShellExecute(MainForm.Handle, Nil, 'Calc.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainFormFP_2027.IncomeGrowthCalculator1Click(Sender: TObject);
begin
 ExecuteForm(TIncomeStreamCalculatorFP_2012);
end;

procedure TMainFormFP_2027.RRIFCalculator1Click(Sender: TObject);
begin
 If ButtonInactive or NoClient(RetNo) then exit;
 ExecuteForm(TRIFFrmFP_2012);
end;

procedure TMainFormFP_2027.RolloverVisualTax1Click(Sender: TObject);
Var RetNo:Integer;
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
  //20170310 Igor >>>
  if not FileExists(OptRec.Dir_LastYr+'\' + ClientsDBLite) and
     not FileExists(OptRec.Dir_LastYr+'\' + ClientsTable_dbf) then
  begin
    ShowMessage('Last Year'+Chr(39)+'s directory does not have a VisualTax Client data base'
                +Chr(13)+'See Configure | General Options | Data Directories');
    Exit;
  end;
  //20170310 Igor
  OptRec.Dir_Cur:=OptRec.Dir_LastYr;
  ApplicationState := ApplicationState + [asConvertFromLastYear]; //20170412 Igor
  try
    FileOpenItemClick(Sender);
    RetNo:=GetCurrentRetNo;
    if RetNo = 0 then exit; //20170307 Igor
    StoreElm(RetNo,GetFormNo('PROFILE'),80,FormatDateTime('yyyy-mm-dd',Date));
    OpenForm(RetNo,GetFormNo('PROFILE'),0);
    Ret[RetNo].SourceDataDir:=OptRec.Dir_Deflt;
  finally
    OptRec.Dir_Cur:=OptRec.Dir_Deflt;
    ApplicationState := ApplicationState - [asConvertFromLastYear];//20170412 Igor
  end;
end;

procedure TMainFormFP_2027.GatherDataBtnClick(Sender: TObject);
begin
ShowHelp(AppFP.ModuleHelpFile,'Present_Situation', true); //20161220 Igor
end;

procedure TMainFormFP_2027.GoalsObjectivesBtnClick(Sender: TObject);
begin
ShowHelp(AppFP.ModuleHelpFile,'Goals', True); //20161220 Igor
end;

procedure TMainFormFP_2027.AnalyseBtnClick(Sender: TObject);
begin
ShowHelp(AppFP.ModuleHelpFile,'Projections_and_assessment', True); //20161220 Igor
end;

procedure TMainFormFP_2027.ActionPlanBtnClick(Sender: TObject);
begin
ShowHelp(AppFP.ModuleHelpFile,'Strategies_and_Plans', true); //20161220 Igor
end;

procedure TMainFormFP_2027.ImplementationStepBtnClick(Sender: TObject);
begin
ShowHelp(AppFP.ModuleHelpFile,'Implementation', true); //20161220 Igor
end;

procedure TMainFormFP_2027.MonitorPlanBtnClick(Sender: TObject);
begin
ShowHelp(AppFP.ModuleHelpFile,'Review', true); //20161220 Igor
end;

procedure TMainFormFP_2027.WebCallCentre1Click(Sender: TObject);
Var h:Word;
begin
h :=ShellExecute(MainForm.Handle, Nil, 'WebSites.exe', Nil,
  Nil, SW_RESTORE);
  if h <=32 then
   ShowMessage('Cannot execute. Error '+IntToStr(h));
end;

procedure TMainFormFP_2027.mnSelAppIdClick(Sender: TObject);
begin
  ShowSplash;
end;

procedure TMainFormFP_2027.TUTORIALS1Click(Sender: TObject);
begin
  MainForm.GuiCommand(gcTutorials);
end;

// --------- Field Popup ----------------------

var //initialized by NotEditCommand
  SenderClass: string;
  MyEditBox: TvtEdit;
  MyScrollBox: TvtScrollBox;
  FieldId: integer;
  //FormName: string;

function TMainFormFP_2027.NotEditCommand: boolean;
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
  MyScrollBox := GetMyScrollBox(MyEditBox);
  FieldId := MyEditBox.FieldId;
  FRetNo := MyScrollBox.RetNo; //private in this class
  FormNameNo(RetNo, MyScrollBox.FormName); //set global vars
  MyChild := RetList[RetNo].MyChild;
end;


procedure TMainFormFP_2027.RemovecurrentfieldoverrideClick(Sender: TObject);
begin
  if NotEditCommand then exit;
 //RetNo:=GetCurrentRetNo;
 If (RetNo >0) and (FormNo >0) and (MyEditBox.FieldId >0) then
  begin
   RemoveFieldOverride(RetNo,FormNo,FieldId);
   Calc(RetNo,FormName);
   CalcAll(RetNo);
  end;

end;

(*
procedure TMainForm.SetCurrentFieldOverrideClick(Sender: TObject);
begin
  if NotEditCommand then exit;
 If (RetNo >0) and (FormNo >0) and (FieldId >0) then
    If IsAProtectedField(FormNo,FieldId) then
     SetFieldOverride(RetNo,FormNo,FieldId)
    else
     ShowMessage('You can only Override or Lock '+
     chr(13)+'Calculated and Linked fields');
end;
*)
procedure TMainFormFP_2027.Lockamountoncurrentfield1Click(Sender: TObject);
begin
  if NotEditCommand then exit;
  If (RetNo >0) and (FormNo >0) and (FieldId >0) then
     SetFieldOverride(RetNo,FormNo,FieldId);
end;

procedure TMainFormFP_2027.ReviewBtnClick(Sender: TObject);
begin
  if NotEditCommand then exit;
  MyScrollBox.ToggleReview(MyEditBox);
end;

procedure TMainFormFP_2027.SetResetOverride1Click(Sender: TObject);
begin
  if NotEditCommand then exit;
  MyScrollBox.ToggleOverride(MyEditBox);
end;

// ------------------ FormPopup -------------------

procedure TMainFormFP_2027.Notepad1Click(Sender: TObject);
begin
  OpenForm(RetNo,GetFormNo('NPAD#1'),0);
end;

procedure TMainFormFP_2027.Notepadwithamounts1Click(Sender: TObject);
begin
  OpenForm(RetNo,GetFormNo('NPADC#1'),0);
end;

procedure TMainFormFP_2027.PrivateNotepad1Click(Sender: TObject);
begin
  OpenForm(RetNo,GetFormNo('PRIVAT#1'),0);
end;

procedure TMainFormFP_2027.AddtoDataDictionaryforclientletters1Click(
  Sender: TObject);
begin
  if NotEditCommand then exit;
  InsertKeyWToDataDict(FormName,MyEditBox);
end;

procedure TMainFormFP_2027.AttachNote1Click(Sender: TObject);
var
    FName,RefFormName,RefFieldId:String;
    FNo:Integer;Cinst:Integer;
begin
  if NotEditCommand then exit;
     RefFormName:=FormName;
     RefFieldId:=IntToStr(FieldId);
     FNo:=GetFldMemFormNo(RetNo,RefFormName,RefFieldId);
     If FNo>0 then
      begin
      OpenForm(RetNo,FNo,0);
      FLDMEM(RetNo,FormName,FNo);
      end
     else {not existing}
     begin
      CInst:=GetEmptyInstance(RetNo,'FLDMEM');
      If CInst>0 then
      begin
       FNo := AddPageInstance(RetNo, 'FLDMEM','#'+AllTrim(IntToStr(CInst)));
       if FNo > 0
       then
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

procedure TMainFormFP_2027.AttachAddingTape1Click(Sender: TObject);
var
    FName,RefFormName,RefFieldId:String;
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
     FNo:=GetFldTapeFormNo(RetNo,RefFormName,RefFieldId);
     If FNo>0 then
       OpenForm(RetNo,FNo,0)
     else {new fldtape}
     begin
      CInst:=GetEmptyInstance(RetNo,'FLDTAPE');
      If CInst>0 then
      begin
       FNo := AddPageInstance(RetNo, 'FLDTAPE','#'+AllTrim(IntToStr(CInst)));
       if FNo > 0
       then
       begin
         FName:='FLDTAPE'+'#'+AllTrim(IntToStr(CInst));
         FNo:=GetFormNo(FName);
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

procedure TMainFormFP_2027.FormSections1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  MyChild.GoToSection('');
end;

end.

