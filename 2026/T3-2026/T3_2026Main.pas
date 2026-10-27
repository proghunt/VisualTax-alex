unit T3_2026main;
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

uses WinTypes,FileCtrl,WinProcs,SysUtils,Classes,Graphics,Forms,Controls,Menus,
  StdCtrls,Dialogs,Buttons,Messages,ExtCtrls,ShellApi,DbCtrls,Grids,Calendar,
  ColorGrd,Printers,ComObj,MAPI,ClipBrd,ComCtrls,DB,VclTee.TeeProcs,VclTee.TeEngine,
  VclTee.Chart,//20150805 Igor
  Mask,StdActns,ActnList,EKRTF,Spin,ekbasereport,ekfunc,
  VtEditBox,vtLabel,vtShape,//wwriched,
  vtChild,OleCtrls,SHDocVw,ImgList,ToolWin, System.Actions, //20180118 Igor >>>
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.Ribbon,
  Vcl.ActnMenus, Vcl.RibbonActnMenus, Vcl.RibbonLunaStyleActnCtrls, System.IOUTils, vtPDFPrinter, //20180503 Igor
  VirtualUI_Mediator, //20190211 Igor
  vtHelperManager, vtCommonIntf, //20190228 Igor
  T3_2026ListBal, //20260109 Igor
  Vcl.RibbonSilverStyleActnCtrls, UIRibbon, UIRibbonCommands, T3_UIRibbonUnit; //20190415 Igor
  //20180118 Igor <<<

  //UHtmlTest;
  //UTestFrm;

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;


Type
  TDFMorTXT = (ConvertToForm, ConvertToText);

type

  TMainFormT3_2026 = class(TForm)
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
    N21: TMenuItem;
    InternetWebSite1: TMenuItem;
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
    AppLabel: TLabel;
    WWWLbl: TLabel;
    Label5: TLabel;
    Image2: TImage;
    TradeMarkLbl: TLabel;
    N3: TMenuItem;
    PrepareDistr1: TMenuItem;
    LicLevel1: TMenuItem;
    PrintAllForms1: TMenuItem;
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
    EmailTheReturn: TMenuItem;
    OpenItBtn: TBitBtn;
    EMailItBtn: TBitBtn;
    N12: TMenuItem;
    TUTORIALS1: TMenuItem;
    N19: TMenuItem;
    Backupthetaxdata1: TMenuItem;
    Restoredatafrombackup1: TMenuItem;
    N34: TMenuItem;
    CopyAReturnBtn: TBitBtn;
    Label4: TLabel;
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
    AppUpdateDateLbl: TLabel;
    AppUpdateDate2Lbl: TLabel;
    Label9: TLabel;
    AppLabel2: TLabel;
    PrintMailingLabelcurrentclient1: TMenuItem;
    Importfromlastyear1: TMenuItem;
    T3coveringletter1: TMenuItem;
    TrustReturn1: TMenuItem;
    T3SupplementarySlips1: TMenuItem;
    CCRAT3GuideT4013PDFformat1: TMenuItem;
    N23: TMenuItem;
    NAICSCodes1: TMenuItem;
    CurrentFormAllInstances1: TMenuItem;
    INTERNETFiling1: TMenuItem;
    Panel7: TPanel;
    LicenseLevelLbl: TLabel;
    Panel8: TPanel;
    Panel3: TPanel;
    AppReleaseLbl: TLabel;
    KnownissuesLbl: TLabel;
    KnownIssues1: TMenuItem;
    Changetaxmodule: TMenuItem;
    N11: TMenuItem;
    FormPopup: TPopupMenu;
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
    FieldPopup: TPopupMenu;
    Copy1: TMenuItem;
    Copy2: TMenuItem;
    EditCut1: TEditCut;
    Cut1: TMenuItem;
    N29: TMenuItem;
    AddRow1: TMenuItem;
    DeleteRow1: TMenuItem;
    DeleteRow2: TMenuItem;
    AddtoDataDictionaryforclientletters1: TMenuItem;
    SetResetReviewMark1: TMenuItem;
    SetResetReviewMark2: TMenuItem;
    AttachNote1: TMenuItem;
    AttachAddingTape1: TMenuItem;
    AttachAddingTape2: TMenuItem;
    TRVisualTaxResearchWebbased1: TMenuItem;
    CICAWebbasedsubscriptionrequired1: TMenuItem;
    SetResetOverride1: TMenuItem;
    Timer: TTimer;
    ImportfromProduction1: TMenuItem;
    ResetclientDBpassword1: TMenuItem;
    buttonAvailableWidth: TSpeedButton;
    ConvertDataandOptionstoMultipAppversion1: TMenuItem;
    ResetReturnpassword1: TMenuItem; //20170409 Igor
    //20170418 Igor >>>
    Image1: TImage;
    Label8: TLabel;
    Label6: TLabel;
    QuickFindBtn: TEdit;
    RolloverfromTacCycle1: TMenuItem;
    //20170418 Igor <<<
    //20180118 Igor >>>
    amT3: TActionManager;
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
    actGoToaFormSection1: TAction;
    actFindaline1: TAction;
    actJacket: TAction;
    actFindKeyWordintheform1: TAction;
    actClearCurrentPage: TAction;
    actClearCurrentform: TAction;
    actCopyForm1: TAction;
    actSwitchforms1: TAction;
    actCurrentPage1: TAction;
    actPrintForm1: TAction;
    actCurrentFormAllInstances1: TAction;
    actShowBarCodedata1: TAction;
    actT3coveringletter1: TAction;
    actTrustReturn1: TAction;
    actT3SupplementarySlips1: TAction;
    actPrintMailingLabelcurrentclient1: TAction;
    actEmailCurrentForm: TAction;
    actEmailTheReturn: TAction;
    actClientListings1: TAction;
    actPrinterSetup: TAction;
    actAllforms1: TAction;
    actOptions2: TAction;
    actPrintTemplates1: TAction;
    actFeeSchedule1: TAction;            
    actClientLetter1: TAction;
    actDataDictionary1: TAction;
    actExportConfiguration1: TAction;
    actImportConfiguration1: TAction;
    actUserSetUp1: TAction;
    actShowCellNumbers1: TAction;
    actINTERNETFiling1: TAction;
    actRecalc1: TAction;
    actDiagnostics: TAction;            
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
    actTestBlBox: TAction;            
    actReIndextheClientDataBase1: TAction;
    actFixClientDataBaseData1: TAction;
    actRestructuretheClientsDataBase1: TAction;
    actFixFormSpecifications1: TAction;
    actUpgrade1: TAction;	
    actDeveloperOnly1: TAction;
    //20180122 Igor >>>
    actPrepareDistr1: TAction;
    actLicLevel1: TAction;
    actPrintAllForms1: TAction;
    actResetclientDBpassword1: TAction;
    actResetpasswordwithreturn1: TAction;
    //20180122 Igor <<<
    actRestoreReturn: TAction;
    actRestoreAll: TAction;
    actTUTORIALS1: TAction;
    actYourLatestRelease: TAction;
    actVisualTaxGuide1: TAction;
    actKnownIssues1: TAction;
    actVisualTaxForum1: TAction;
    actInternetWebSite1: TAction;
    actCheckupdates1: TAction;
    actUsefulLinks: TAction;
    actCheckupdate1: TAction;
    actCCRAT3GuideT4013PDFformat1: TAction;
    actNAICSCodes1: TAction;
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
    sep3: TToolButton;
    tbtnJacket: TToolButton;
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
    il16: TImageList;
    il32: TImageList;
    actNextPage: TAction;
    actPrevPage: TAction;
    actFindForm: TAction;
    actReviewMark: TAction;
    actAvailableWidth: TAction;
    tbtnSwapReturn: TToolButton;
    actSwap: TAction;
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
    tbtnJacket2: TToolButton;
    tbtnPreviousPage2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    edtSearchForm2: TEdit;
    tbtnFindForm2: TToolButton;
    ToolButton7: TToolButton;
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
    actHelpCurrentForm: TAction;
    actChangeSkin: TAction;
    ChangeSkinBtn: TSpeedButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    //20180206 Igor <<<
    //20180424 Igor >>>
    N4: TMenuItem;
    Buildreport1: TMenuItem;
    //20180424 Igor <<<
	//20190211 Igor >>>
    btnUpload: TBitBtn;
    btnUploadWithoutOpen: TBitBtn;
    btnDownload: TBitBtn;
    btnDownloadAll: TBitBtn;
    //20190211 Igor <<<
    actForCloud: TAction;
    //20190415 Igor >>>
    MainUIRibbon: TUIRibbon;
    actFileNewButton: TAction;
    actFileOpenButton: TAction;
    actFileCloseButton: TAction;
    actSelectFormButton: TAction;
    //20210906 Igor >>>
    EfileOnLine1: TMenuItem;
    EFILECURRENTRETURN1: TMenuItem;
    SetupEOLEfilerNumberandPassword1: TMenuItem;
    actEOL: TAction;
    actSetupEOL: TAction;
    HistoryofEFilesubmissions1: TMenuItem;
    EfileT3slips1: TMenuItem;
    EfiletheT11351: TMenuItem;
    N20: TMenuItem;
    RC4657: TMenuItem;
    N5: TMenuItem;
    Recaculateandsaveallreturns1: TMenuItem;
    T3WebServicesErrors: TMenuItem;
    EfileErr1: TMenuItem;
    OpentheClientsDocsfolder1: TMenuItem;
    N17: TMenuItem;
    PrintReturnBalances1: TMenuItem; //20190228 Igor
    //20210906 Igor <<<
    //20190415 Igor <<<
    //procedure PrintCt23Short(Retno:integer;FormName:String);

    //Function GetPrintTemplate(IncludeFiling:Boolean):string;
    Procedure GetFormsToPrint(RetNo:integer;Template:string;FormsToPrint:TStrings;FrmType:String);
    //Procedure PrintCCRAT3Slips(RetNo:Integer;CopyType:Integer);
    //Procedure PrintT3Slips(RetNo:Integer;CopyType:Integer);
    Procedure PrintT5013Slip(RetNo:Integer;SlipInstanceToPrint:String;CopyId:String);
    //Procedure PrintT5013Slip(RetNo:Integer;SlipId:String;CopyId:String);
    procedure PrintAReturn(WhichFormType:String;Template:String);
    Procedure PrintStudentT2202(RetNo:Integer;CopyType:Integer);
    Procedure PrintDesignatedT2202(RetNo:Integer;CopyType:Integer);
    Procedure PrintEducationalT2202(RetNo:Integer;CopyType:Integer);
    function SendMAPIMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
    Procedure PrintReturnForEMail(RetNo:Integer;Template:String);
    procedure PrintFormForEmail(RetNo:Integer;FormName:String);
    procedure AuditOpenBtnClick(Sender: TObject);
    function FormsTreeView1Click(SourceNode: TTreeNode; fUsedForms: boolean): integer;
    procedure TreeViewBtnClick(Sender: TObject);
    //Procedure GetListOfLoadedReturns(SomeList:TStringList);
    procedure ProcessBlackBoxFile;
    function ConvertFormOrText(FileToConvertFrom:string;ConversionType:TDFMorTXT):Boolean;
    procedure SetHorScrollBarInListBox(ListBox: TListBox; MaxWidth: Integer);
    procedure WidePanelBtnClick(Sender: TObject);
    procedure AppException(Sender: TObject; E: Exception);
    procedure AdjustFontSize;
    Procedure ListBunchOfForms(TypeOfForm:string;ListCaption:String);
    procedure StartPrintForm(Retno:integer;FormName:String;WhichPage:integer);
    Procedure UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
    procedure PrintReturn(RetNo:integer;FormsToPrint:TstringList;DataDir:string;FlName:string);
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
    procedure PrintFBtnClick(Sender: TObject);
    procedure Modem1Click(Sender: TObject);
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
    procedure UserSetUp2Click(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure Calculator1Click(Sender: TObject);
    procedure Appointments2Click(Sender: TObject);
    procedure TransmitRTU1Click(Sender: TObject);
    procedure Contents2Click(Sender: TObject);
    procedure SearchForHelpOnClick(Sender: TObject);
    procedure VisualTaxGuide1Click(Sender: TObject);
    procedure Allforms1Click(Sender: TObject);
    procedure EFileerrorsCurrentReturn1Click(Sender: TObject);
    procedure MultipleDnBtnClick(Sender: TObject);
    procedure MultipleUpBtnClick(Sender: TObject);
    procedure Restructure1Click(Sender: TObject);
    procedure DependBtnClick(Sender: TObject);
    procedure ReviewBtnClick(Sender: TObject);
    procedure ABCBtnClick(Sender: TObject);
    procedure PrintManager1Click(Sender: TObject);
    procedure ClientLetters1Click(Sender: TObject);
    procedure TaxReturnCoveringletter1Click(Sender: TObject);
    procedure ShowOverridesClick(Sender: TObject);
    procedure ListReviewmarks1Click(Sender: TObject);
    procedure SystemInformation1Click(Sender: TObject);
    procedure RebuildtheClientDataBase1Click(Sender: TObject);
    procedure MergeDataBases1Click(Sender: TObject);
    procedure FileViewerEditor1Click(Sender: TObject);
    procedure CurrentPage1Click(Sender: TObject);
    procedure CplBtnClick(Sender: TObject);
    procedure MinTaxBtnClick(Sender: TObject);
    procedure ClientListings1Click(Sender: TObject);
    procedure CopyBackUp1Click(Sender: TObject);
    procedure RecalcBtnClick(Sender: TObject);
    procedure PreselNextBtnClick(Sender: TObject);
    procedure PreSelPrvBtnClick(Sender: TObject);
    procedure NISAcodes1Click(Sender: TObject);
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
    Procedure ShowMultiOfficeMsg;
    Function  EditBeforeSave(RetNo:Integer):Boolean;
    procedure InternetWebSite1Click(Sender: TObject);
    procedure WWWLblClick(Sender: TObject);
    procedure WorldButtonClick(Sender: TObject);
    procedure AlphabeticalFormsIndex1Click(Sender: TObject);
    procedure Zoomin1Click(Sender: TObject);
    procedure Zoomout1Click(Sender: TObject);
    procedure Toolbandswitch1Click(Sender: TObject);
    procedure Color1Click(Sender: TObject);
    procedure Recalc1Click(Sender: TObject);

    procedure ReIndextheClientDataBase1Click(Sender: TObject);
    procedure RestructuretheClientsDataBase1Click(Sender: TObject);

    procedure ExchageRatesAverage1Click(Sender: TObject);

    procedure Checkupdate1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure CheckUpdatesLblClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure ClearCurrentformClick(Sender: TObject);
    procedure ClearCurrentPageClick(Sender: TObject);
//    Function  SelectFromLoadedReturns(RetNo:Integer):Integer; //20161216 Igor

    procedure ShowMostRecentReturns;
    procedure OpenPreviousYearsT11Click(Sender: TObject);
    procedure ImportConfiguration1Click(Sender: TObject);
    procedure ExportConfiguration1Click(Sender: TObject);
    procedure Findaline1Click(Sender: TObject);
    procedure LinesBtnClick(Sender: TObject);
    procedure UsefulLinksClick(Sender: TObject);
    procedure SetReturnPassword1Click(Sender: TObject);
    procedure RemoveReturnPassword1Click(Sender: TObject);
    procedure SetProgramPassword1Click(Sender: TObject);
    procedure RemoveProgramPassword1Click(Sender: TObject);
    procedure PrintAuditBtnClick(Sender: TObject);
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
    procedure CCArates1Click(Sender: TObject);
    procedure Checkupdates1Click(Sender: TObject);
    procedure Frequentlyaskedquestions1Click(Sender: TObject);
    procedure VisualTaxForum1Click(Sender: TObject);
    procedure HowoftentocheckInternetUpdates1Click(Sender: TObject);
    procedure TrEngineLoadClick(Sender: TObject);
    procedure ListMultipleBtnClick(Sender: TObject);
    procedure TrGuide1Click(Sender: TObject);
    procedure DefinetheTRfolder1Click(Sender: TObject);
    procedure TileVertical1Click(Sender: TObject);
    procedure TileHorizontally1Click(Sender: TObject);
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
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyPress(Sender: TObject; var Key: Char);
    procedure Options2Click(Sender: TObject);
    procedure QuestionMarkLblMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure LicLevel1Click(Sender: TObject);
    procedure PrepareDistr1Click(Sender: TObject);
    procedure EmailTheReturnClick(Sender: TObject);
    procedure OpenItBtnClick(Sender: TObject);
    procedure EMailItBtnClick(Sender: TObject);
    procedure TUTORIALS1Click(Sender: TObject);
    procedure HelpIndexBtnClick(Sender: TObject);
    procedure Backupthetaxdata1Click(Sender: TObject);
    procedure Restoredatafrombackup1Click(Sender: TObject);
    procedure CopyAReturnBtnClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure ShowBarCodedata1Click(Sender: TObject);
    procedure StatusBarBtnClick(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure NewBtnToolBarClick(Sender: TObject);
    procedure OpenBtnToolBarClick(Sender: TObject);
    procedure CloseBtnToolBarClick(Sender: TObject);
    procedure SaveBtnToolBarClick(Sender: TObject);
    procedure SwapBtnClick(Sender: TObject);
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

    procedure T2202AEducationSlips1Click(Sender: TObject);
    procedure CharityReturn1Click(Sender: TObject);
    procedure CCRAT3GuideT4013PDFformat1Click(Sender: TObject);
   // procedure CCRAT5013PartnershipGuideT4068PDFformat1Click(Sender: TObject);
    procedure ImportBtnClick(Sender: TObject);
    procedure RollOvrerLblClick(Sender: TObject);
    procedure NAICSCodes1Click(Sender: TObject);
    procedure N2008TaxRatesanddraftlegislation1Click(Sender: TObject);
   procedure CurrentFormAllInstances1Click(Sender: TObject);
    procedure INTERNETFiling1Click(Sender: TObject);
    procedure KnownIssues1Click(Sender: TObject);
    procedure KnownissuesLblClick(Sender: TObject);
    procedure PrintAllForms1Click(Sender: TObject);
    procedure mnSelAppId(Sender: TObject);
    procedure Notepad1Click(Sender: TObject);
    procedure Notepadwithamounts1Click(Sender: TObject);
    procedure PrivateNotepad1Click(Sender: TObject);
    procedure AddtoDataDictionaryforclientletters1Click(Sender: TObject);
    procedure DeleteRow1Click(Sender: TObject);
    procedure AttachNote1Click(Sender: TObject);
    procedure AttachAddingTape1Click(Sender: TObject);
    procedure TRVisualTaxResearchWebbased1Click(Sender: TObject);
    procedure AddRow1Click(Sender: TObject);
    procedure FormSections1Click(Sender: TObject);
    procedure SetResetOverride1Click(Sender: TObject);
    procedure DeveloperOnly1Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ImportfromProduction1Click(Sender: TObject);  //20160305 Igor
    procedure ResetclientDBpassword1Click(Sender: TObject);
    procedure buttonAvailableWidthClick(Sender: TObject);
    procedure ConvertDataandOptionstoMultipAppversion1Click(Sender: TObject);  //20160305 Igor
    procedure ResetReturnpassword1Click(Sender: TObject); //20160409 Igor
    procedure QuickFindBtnKeyPress(Sender: TObject; var Key: Char); //20170418 Igor
    procedure RolloverfromTacCycle1Click(Sender: TObject); //20170712 Igor
    //20180118 Igor >>>
    procedure amT3StateChange(Sender: TObject);
    procedure actFindFormExecute(Sender: TObject);
    procedure edtSearchFormChange(Sender: TObject);
    procedure actColor1Execute(Sender: TObject);
    //20180118 Igor <<<
    procedure actChangeSkinExecute(Sender: TObject); //20180206 Igor
    procedure Buildreport1Click(Sender: TObject);//20180424 Igor
    //20190211 Igor >>>
    procedure btnUploadClick(Sender: TObject);
    procedure btnUploadWithoutOpenClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    //20190211 Igor <<<
    //20190228 Igor >>>
    procedure actForCloudExecute(Sender: TObject);
    procedure OpenFromCloudClick(Sender: TObject);
    //20190415 Igor >>>
    procedure MainUIRibbonCommandCreate(const Sender: TUIRibbon;
      const Command: TUICommand);
    procedure SearchFormSelect(const Args: TUICommandCollectionEventArgs);
	//20190415 Igor <<<
	//20210906 Igor >>>
    procedure actEOLExecute(Sender: TObject);
    procedure actSetupEOLExecute(Sender: TObject);
    procedure HistoryofEFilesubmissions1Click(Sender: TObject);
    procedure EfileT3slips1Click(Sender: TObject);
    procedure EfiletheT11351Click(Sender: TObject);
    procedure RC4657Click(Sender: TObject);
    procedure RecalcandSaveClick(Sender: TObject);
    procedure T3WebServicesErrorsClick(Sender: TObject);
    procedure EfileErr1Click(Sender: TObject);
    procedure OpentheClientsDocsfolder1Click(Sender: TObject);
    procedure PrintReturnBalances1Click(Sender: TObject);
    //20210906 Igor <<<    
  private
    FRetNo: integer;
    FName: string; //here also FName seems to be used for FormName
    //20180117 Igor >>>
    FSearchStr: string;
    FSearchForm1, FSearchForm2: TUICommandCollection; //20190415 Igor
    procedure SetSearchStr(const AValue: String);
    function GetZoomStr: String;
    procedure SetZoomStr(const Value: String);
    //20180117 Igor <<<
    property FormName: string read FName;
    property RetNo: integer read FRetNo;

    Function ButtonInactive:Boolean;
    procedure ShowHint(Sender: TObject);
    function NotEditCommand: boolean;
    procedure ShowReturn(ARetNo: integer); //20190211 Igor
    procedure OnCreateMenuItem(const aName: string; const aHelperID: Integer);//20190228 Igor
  public
    MyChild: TMyChild;
    function DoSaveAllReturns(RNo: integer): Boolean;
    function FileSaveAs(RetNo: integer): boolean;
    function RefreshAuditPanel(RetNo: integer; ReturnsHeaderPanel: TPanel;
      ErrorView: TTreeView): string;
    //20180117 Igor >>>
    property SearchStr: String read FSearchStr write SetSearchStr;
    property ZoomStr: String read GetZoomStr write SetZoomStr;
    //20180117 Igor <<<
    procedure ReloadMainMenu; //20190228 Igor
  end;

function FileNew: integer;

var
  MainFormT3: TMainFormT3_2026;
  T3Menu: TMainMenu;
  TutorialFile:TFileName;
  TutorialScript:String;
  ToolBarSw: boolean;

Implementation

{$R *.DFM}

uses
  vtMulti,vtCommon,vtMain,vtDialogs,vtForm,
  T3_2026,T3_2026Declare,
  T3_2026Common,T3_2026Common2,T3_2026TrimStr,T3_2026InternetFrm,
  T3_2026OptionsFrm,T3_2026PrT5013,T3_2026OpFlNm,T3_2026ClientBook,
  T3_2026SaveAs,T3_2026BackupFrm,T3_2026RestoreFrm,T3_2026Fees,T3_2026Dict,
  T3_2026SIC,
//T3_2026ShowAnyFile,
  T3_2026CntErr,T3_2026Print,T3_2026CopyMoveFrm,
  T3_2026StatBox,
//T3_2026PopList,T3_2026PopComboList,
  T3_2026Users,T3_2026CopyFrm,
  T3_2026FileVu,T3_2026Calc,T3_2026Progres,T3_2026DBRestr,
  T3_2026FRMType,T3_2026ABList,T3_2026PrSet,T3_2026Rebuild,T3_2026Merge,
  T3_2026Import,T3_2026RichForm,T3_2026ReindexDb,T3_2026Features,T3_2026FtpFrm,
  T3_2026ImportConfig,T3_2026ExportConfig,T3_2026FindALine,T3_2026PdfFrm,
  T3_2026SetFilePsw,T3_2026UpdateSchedule,T3_2026DataDictFrm,
//T3_2026ChildWinNew,
//T3_2026HeaderFrame,
  T3_2026PrintSelectedT3Slips,
  T3_2026EOLSetup, T3_2026Efile, //20210906 Igor
  //T3_2026PrintSelectedNR4Slips,
  vtTrimStr, vtShared, vtDataModuleUnit
, vtDataBase, uADCompClient, // 20150923 Igor
//  T3_2026t5013Efile,  //20160410
  T3_2026ImportDbfData, //20160305 Igor
  fConvertToMultiApp, //20160627 Igor
  TaxCycleUtil, //20170712 Igor
  vtReportBuilder, //20180424 Igor
  vtChooseFileForm, //20190211 Igor
  vtShowMessageHTML, //20211227 Igor
  fCaseDo,
  T3_2026ListBaljz //jz//20260206
; //20180206 Igor
//var MyTab:TPageControl; MyTabSheet:TTabSheet;MyScrollBox:TScrollbox;MyPanel:Tpanel;

procedure TMainFormT3_2026.FormCreate(Sender: TObject);
Var i:Integer;TempList:TStringList;
begin
  //20190415 Igor >>>
  MainUIRibbon.ResourceInstance := LoadLibraryEx('T3_UIRibbonUnit.dll', 0, LOAD_LIBRARY_AS_DATAFILE);
  if (MainUIRibbon.ResourceInstance = 0) then
   MainUIRibbon.ResourceName := '';

  //20190415 Igor <<<
  //main app year labels
  AppLabel.Caption          :=AppName+'-'+AppYear;        //20210823 Igor
  AppUpdateDateLbl.Caption  := 'As of: '+AppUpdateDate;

  //top app year labels
  AppLabel2.Caption         := AppName+'-'+AppYear;       //jz//20260308 - add var for top tax year label
  AppUpdateDate2Lbl.Caption := 'As of: '+AppUpdateDate;

  ZoomStr:=IntToStr(OptRec.FormZoom)+'%'; //20180118 Igor
  //20180411 Igor >>>

  If FileExists(AppDir+'\'+RecentRFlName) = False then
   InitMostRecentFiles(50); //put them in RecentFlName
  //20180411 Igor <<<
  ShowMostRecentReturns;
  T3Menu := Menu;
  Menu := nil; //to be shown in Main
  InitColorPanel;
  ReloadMainMenu; //20190228 Igor
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

//never called, move essential parts somewhere else!
procedure TMainFormT3_2026.FormPaint(Sender: TObject);
Var i : integer;
RetNo:Integer;
begin

end; //paint


function TMainFormT3_2026.RefreshAuditPanel(RetNo: integer; ReturnsHeaderPanel: TPanel;
      ErrorView: TTreeView): string;
Var i:Integer; TempList:TStringList;
begin
 If RetNo=0 then exit;
 CountDiagnostics(RetNo);
  Ret[RetNo].AuditRecsToTreeView(ErrorView,'MEWRTDN');
end; {procedure}


Function TMainFormT3_2026.ButtonInactive:Boolean;
var
    MyForm: TvtScrollBox; //20151106 Igor
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
  MyChild := Ret[RetNo].MyChild;

  //add 20151106 Igor
  MyForm := MyChild.ActiveForm;
  if MyForm <> nil then
  begin
    FName := MyForm.FormName;
    FormNo := MyForm.FormNo;
  end
  else
  begin
    FName := '';
    FormNo := 0;
  end;

 end;
end;

procedure TMainFormT3_2026.ShowHint(Sender: TObject);
begin
 { StatusLine.Caption := Application.Hint;}
end;


procedure TMainFormT3_2026.FileNewItem_Click(Sender: TObject);
begin
  FileNew;
end;

function FileNew: integer;
Var
  RetNo:Integer absolute Result;
begin
 If (OptRec.Dir_Deflt = '') or
  (Not FileExists(OptRec.Dir_Deflt+'\'+ClientsDBLite)) then //20150923 Igor
  begin
   showMessage('Data directory has not been defined'+
   Chr(13)+'Click on Configure | General Options \ Data Directories');
   exit;
  end;
  //20170901 Igor>>>
  If AppT3_2026.ExceedsMaxReturnsAllowed(True) then
    Exit;
  //20170901 Igor<<<

{$IFDEF ReturnsLimit}
  if RetInMem >= ReturnsLimit then
     begin
     ShowMessage('Exceeded maximum number of returns that fit in memory');
     exit;
     end
   If ResourcesLow then
    begin
    ShowMessage('Cannot open more...Overloaded!'+
      Chr(13)+'Close some windows or returns or other applications'
      +Chr(13)+ 'and Retry');
    exit;
  end;
{$ELSE}
{$ENDIF}
  //CreatingNew := True;
  Result:=CreateNewReturn;
  if Result < 1 then
  begin ShowOpenReturnFailure(Result,'',''); exit; end;
  //if k>0 then
  begin
    //RetNo:=k;
    OpenForm(RetNo,GetFormNo('T3'),0);
    MainForm.GuiCommand(gcShowLeftPanel);
  end;
end;

procedure TMainFormT3_2026.actSetupEOLExecute(Sender: TObject); //20210906 Igor
begin
  ExecuteForm(TEOLSetUpT3_2026);
end;

procedure TMainFormT3_2026.FileOpenItemClick(Sender: TObject);
Var RetNo,PrvRNo:Integer;
begin
  if ExecuteForm(TClientBookT3_2026) = mrOk then //20160612 Igor
    MainForm.GuiCommand(gcHideFlash);
  Done;
end;

procedure TMainFormT3_2026.FileSaveItemClick(Sender: TObject);
begin
If ButtonInactive then exit;
FileSaveAsItemClick(Sender);
end;

procedure TMainFormT3_2026.FileSaveAsItemClick(Sender: TObject);
begin
 If ButtonInactive then exit;
  FileSaveAs(RetNo);
end;

function TMainFormT3_2026.FileSaveAs(RetNo: integer): boolean;
//procedure TMainFormT3_2026.FileSaveAsItemClick(Sender: TObject);
begin
  if Ret[RetNo].isAppendix then exit; //20160629 Igor
  
  Result := False;
 CalcAll(RetNo);
 UpdateAllDataIndicators(RetNo);
 UpdateChildTaxPanelOnly(RetNo);

 If EditBeforeSave(RetNo) = false then
 begin
    MainForm.GuiCommand(gcAuditOpenBtnClick);
   ShowMessage('Please enter Mandatory data before saving');
   exit;
 end;
 Application.CreateForm(TSaveAsT3_2026,SaveAs);
 Result := SaveAs.ShowModal = mrOk; //or always True?
 SaveAs.Free;
end;

procedure TMainFormT3_2026.FileCloseItemClick(Sender: TObject);
Begin
  If ButtonInactive then exit;
  RetList[Self.RetNo].Close(True);
end;

Function TMainFormT3_2026.EditBeforeSave(RetNo:Integer):Boolean;
begin
 Result:=False;
 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount > 0 then Exit;
 Result :=true;
end;

procedure TMainFormT3_2026.edtSearchFormChange(Sender: TObject); //20180118 Igor
begin
  SearchStr := (Sender as TEdit).Text;
end;

procedure TMainFormT3_2026.ShowWarnings;
begin
  if ButtonInactive then exit;
  SignOffWarnings(RetNo);
end;

procedure TMainFormT3_2026.FileExitItemClick(Sender: TObject);
begin
  MainForm.FileExitItemClick(Sender);
end;

procedure TMainFormT3_2026.ConvertDataandOptionstoMultipAppversion1Click(
  Sender: TObject); //20160627 Igor
begin
  ConvertToMultiApp(AppT3_2026, true);
end;

function TMainFormT3_2026.ConvertFormOrText(FileToConvertFrom:string;ConversionType:TDFMorTXT):Boolean;
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
  InputStream := nil;
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


procedure TMainFormT3_2026.CutItemClick(Sender: TObject);
begin
  {cut selection to clipboard}
end;


procedure TMainFormT3_2026.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveFormChange := nil;
end;

procedure TMainFormT3_2026.RestoreReturnClick(Sender: TObject);
var
i: Integer;
WinList : TStringList;
CurHandle : Thandle;
begin
end;

procedure TMainFormT3_2026.ResetclientDBpassword1Click(Sender: TObject); //20160305 Igor
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

procedure TMainFormT3_2026.ResetReturnpassword1Click(Sender: TObject); //20170409 Igor
begin
  if not OpenDialog.execute then exit;
  if RemovePasswordReturn(OpenDialog.FileName) then
    MessageDlg('Reset password completed', mtInformation, [mbOk],0);
end;

procedure TMainFormT3_2026.RestoreAllClick(Sender: TObject);
var
i : Integer;
CurHandle : Thandle;
begin
end;


procedure TMainFormT3_2026.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 {}
end;

procedure TMainFormT3_2026.SelectFormClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 //UpdateAllDataIndicators(GetCurrentRetNo);
  ExecuteForm(TFrmtypeT3_2026);
end;

procedure TMainFormT3_2026.ListBunchOfForms(TypeOfForm:string;ListCaption:String);
Var I: integer;//RetNo:Integer;
begin
  if ButtonInactive then exit;
 //RetNo:=GetCurrentRetNo;
 SomeList.Clear;  // := TStringList.Create;
 SomeList.Sorted := True;
 SomeCaption := ListCaption;
 for i :=0 to (FList.Count - 1) do
 begin
   FRec := FList.Items[i];
   If (Frec.FormShow) and (Frec.FormType = TypeOfForm) then
       SomeList.Add(Frec.FormAbrev); {FormRlNm); }
 end;
  SelectedString := PopSomeList(SomeList,ListCaption);
 If SelectedString > '' then
 begin
   FName := Rtrim(GetFName(SelectedString));  {using Real Name}
   OpenForm(RetNo,FName,0);
 end;
end;



procedure TMainFormT3_2026.PrinterSetupClick(Sender: TObject);
begin
  if CheckIsCloud then Exit; //20180503 Igor
  PrintDialogItem.Execute;
end;

procedure TMainFormT3_2026.NewBtnClick(Sender: TObject);
begin
  FileNewItem_Click(Sender);

end;



procedure TMainFormT3_2026.PrintRBtnClick(Sender: TObject);
Var I : integer;
begin
  If ButtonInactive then exit;
  SomeList.Clear; // := TStringList.Create;
  SomeCaption := 'Print';
  SomeList.Add('Current Page');
  SomeList.Add('Current Form');
  SomeList.Add('Current Return');
  SelectedString := PopSomeList(SomeList,SomeCaption);
  If SelectedString = '' then exit;
  {PrintDialogItem.Options := [poWarning];}
  If SelectedString = 'Current Page' then CurrentPage1Click(Sender)
  else If SelectedString = 'Current Form' then PrintForm1Click(Sender);
  //else if SelectedString = 'Current Return' then PrintCurrentReturn1Click(Sender);
end;


procedure TMainFormT3_2026.StatusBarBtnClick(Sender: TObject);
begin
EXIT;
end;

procedure TMainFormT3_2026.ToolBarBtnClick(Sender: TObject);
begin
  ToolBarSw := not ToolBarSw;
  If ToolBarSw then
   begin
    ToolBarBtn.Glyph.LoadFromFile(AppDir+'\'+'SwitchOn.BMP');
    ToolBarSw := True;

    If ButtonInactive then exit;
    CalcAll(RetNo);
    UpdateAllDataIndicators(RetNo);
    MyChild.UpdateChildTaxPanel();
   end
  else
   begin
   ToolBarBtn.Glyph.LoadFromFile(AppDir+'\'+'SwitchOf.BMP');
   ToolBarSw := false;
   //ToolBar.Height :=(ToolBar.Height div 2)+3+5; //(ToolBar.Height div 2)+3+1;
   end;

end;

procedure TMainFormT3_2026.AboutItemClick(Sender: TObject);
begin
  ShowAbout;
end;

procedure TMainFormT3_2026.actChangeSkinExecute(Sender: TObject); //20180206 Igor
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

procedure TMainFormT3_2026.actColor1Execute(Sender: TObject); //20180118 Igor
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

procedure TMainFormT3_2026.actEOLExecute(Sender: TObject); //20210906 Igor
Var s:String;i:Integer;OnlineNo,TransmitterNo,Password,Url,NetFileDir:String;
T183FNo:Integer;
begin
 //20260308
 if not inJZtestmode then
 Begin
  //ShowMessage('The T3 is currently under CRA Review/Certification. You should not Efile T3 returns with this version');
  //Exit;
 end;

 //If (UpperCase(InputBox('Enter password', 'PSW', '')) <> 'N/A') then Exit; //20250409

 (*
   //stop MJ in feb - march unles developer
   //20231223
   if (GetEfilerNo='B0865')  //t3 efile to be releasaed in Feb
   then
   //ok
   Else
   begin  //20240215
    If (UpperCase(InputBox('Enter password', 'PSW', '')) <> 'CRA') then Exit;
   end;
 *)

  If ButtonInactive then exit;   //20101218
  //if IsAuthorizedPreparer=False then Exit;  //20190401
  //If IsCraOpenForEfile=False then begin ShowCraIsClosed;exit;end;  //20160205 //20160216 Igor

  T183Fno:=GetFormNo('T183TRUST');  //20240327
  s:=FetchElmFNo(RetNo,T183FNo,17)+FetchElmFNo(RetNo,T183FNo,41)+FetchElmFNo(RetNo,T183FNo,4)+FetchElmFNo(RetNo,T183FNo,12)+
     FetchElmFNo(RetNo,T183FNo,40)+FetchElmFNo(RetNo,T183FNo,42)+FetchElmFNo(RetNo,T183FNo,14)+FetchElmFNo(RetNo,T183FNo,13)+
     FetchElmFNo(RetNo,T183FNo,43)+FetchElmFNo(RetNo,T183FNo,44)+FetchElmFNo(RetNo,T183FNo,45);
  If s='' then //no selection
  begin
   ShowMessage('Please tick the proper box on Part B of the T183TRUST before Efiling'); //20230101
   OpenForm(RetNo,GetFormNo('T183TRUST'),17);
   Exit;
  End;

  GetEOLParms(OnlineNo,Password,Url,NetFileDir);
  If Length(OnlineNo)<>5 then
  begin
    ShowMessage('Efiler number not entered correctly. Please complete the Efile Online Setup');
    actSetupEOL.Execute();
    Exit;
  end;

  RecalcEverything(RetNo);

   If Ret[RetNo].EfStatus = '02' then
   begin
     If (OnlineNo='B0865') then  //allow developer if T3 efaccepted
     //ok
     else
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


    If (Ret[RetNo].SeriousErrorCount>0) and (not inJZtestmode) then
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

    {
    If Ret[ARetNo].FrmHasData[GetFormNo('T3A')] then
    Begin
     ShowMessage('CRA does not accept Efile as it contains a T3A
     exit;
    End;
   }

  //20220120 Igor >>>
  If Not IsReadyForEfile(RetNo) then
  begin
     ShowMessage('Not ready for Efiling. Please fix errors first');
     exit;
  end;

  if FetchElm(RetNo,'T183TRUST',21).IsEmpty then
  begin
    ShowMessage('Dcn number in T183TRUST is empty');
    exit;
  end;
  //20220120 Igor <<<

  Screen.Cursor:=CrHourGlass;
  //If IsAuthorizedPreparer=false then exit;
  ExecuteForm(TEfileT3_2026);
end;

procedure TMainFormT3_2026.actFindFormExecute(Sender: TObject); //20180117 Igor
begin
  If ButtonInactive then exit;
  If Trim(SearchStr) = '' then exit;
  QuickFormFind(RetNo, SearchStr);
end;

procedure TMainFormT3_2026.actForCloudExecute(Sender: TObject); //20190228 Igor
begin
  OpenFromCloudClick(Sender);
end;

procedure TMainFormT3_2026.CloseBtnClick(Sender: TObject);
begin
  FileCloseItemClick(Sender);
end;

procedure TMainFormT3_2026.MainUIRibbonCommandCreate(const Sender: TUIRibbon; //20190415 Igor
  const Command: TUICommand);
begin
  case Command.CommandId of
	    T3_UIRibbonUnit.CommandSearchForm1:
	      begin
          FSearchForm1 := TUICommandCollection(Command);
          FSearchForm1.OnSelect := SearchFormSelect;
	      end;
      T3_UIRibbonUnit.CommandSearchForm2:
	      begin
          FSearchForm2 := TUICommandCollection(Command);
          FSearchForm2.OnSelect := SearchFormSelect;
	      end;
  end;
end;

procedure TMainFormT3_2026.MemGaugeClick(Sender: TObject);
begin
//ShowMem;
end;

procedure TMainFormT3_2026.StatusBarClick(Sender: TObject);
begin
 {UpdateTaxPanel;}
end;

procedure TMainFormT3_2026.ClrCustomClick(Sender: TObject);
begin
 Clr0Click(Sender);
end;

procedure TMainFormT3_2026.clr0Click(Sender: TObject);
begin
 If ButtonInactive then exit;
  MainForm.ClrClick(RetNo,Sender, c_ReturnColorElm); //20170219 Igor
end;

Procedure TMainFormT3_2026.InitColorPanel;
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

procedure TMainFormT3_2026.clr1Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormT3_2026.clr2Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormT3_2026.clr3Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormT3_2026.clr4Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormT3_2026.clr5Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormT3_2026.clr6Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormT3_2026.clr7Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormT3_2026.clr8Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormT3_2026.clr9Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormT3_2026.clr10Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormT3_2026.clr11Click(Sender: TObject);
begin
Clr0Click(Sender);
end;

procedure TMainFormT3_2026.OpenbyFileName1Click(Sender: TObject);
//20170628 Igor >>>
var
  RetNo: integer;
  FullFlName: String;
  s: String;
  FlName, Sin, Dir: String; //20190211 Igor
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
  OpenDialog.InitialDir := OptRec.Dir_Cur;
  If OpenDialog.Execute then
  begin
    FullFlName := OpenDialog.FileName;
    FlName := ExtractFileName(FullFlName);
    Sin := RemoveChar(FlName, '.');
    If IsOkToOpenReturn(ExtractFileDir(FullFlName), FlName, Sin) = False then
      Exit;
    RetNo := OpenReturn(ExtractFileDir(FullFlName),FlName,True);
    If RetNo < 1 then
      exit;
    vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
    try
      LockWindowUpdate(MainForm.Handle);
      CountDiagnostics(RetNo);
      //MainForm.LeftPanel.Visible:=True;
      MainForm.GuiCommand(gcShowLeftPanel);
      OpenForm(RetNo,'T3',0);
      LockWindowUpdate(MainForm.Handle);  //20130217
      OpenUsedForms(RetNo);
      MainForm.FormPaint(Application);
      LockWindowUpdate(0);  //20130217
      MainForm.RefreshAuditPanel(RetNo); //If AuditPanel.Visible then RefreshAuditPanel;
      //If FormsPanel.Visible then RefreshFormsPanel(RetNo);
    finally
      vtChild.CreateNewMDIChild(RetNo, '').ShowAllControls;
    end;
  end;
//20170628 Igpor <<<
end;

procedure TMainFormT3_2026.OpenFromCloudClick(Sender: TObject); //20190228 Igor
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
    hconf := HelperManager.Config(mi.HelperID, AppT3_2026.AppId, User.UserName);
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
    hconf := HelperManager.Config((Sender as TAction).Tag, AppT3_2026.AppId, User.UserName);
    CloudFile := '';
    ClientID := HelperManager.Config((Sender as TAction).Tag).ClientID;
    CloudPath := hconf.Path;
    Token := hconf.Token;
    LoadFromCloud((Sender as TAction).Tag);
  end;
end;

procedure TMainFormT3_2026.Calendar1Click(Sender: TObject);
begin
GetCalendar;
end;

procedure TMainFormT3_2026.ClientLetter1Click(Sender: TObject);
begin
{Screen.Cursor := crHourGlass;}
//20160819 Igor >>>
  ShowLetterEditor(RetNo);
// Application.CreateForm(TRichFormT3_2026,RichForm);
// RichForm.ShowModal;
// RichForm.Free;
//20160819 Igor <<<
end;

procedure TMainFormT3_2026.PrintForm1Click(Sender: TObject);
Var i:integer;RetNo:Integer;
    //20180503 Igor >>>
    PDFFullfileName: string;
    PDF: TvtPDFPrinter;
    //20180503 Igor <<<
begin
 RetNo:=GetCurrentRetNo;
 FastPrint := GetFastPrintIndicator; //False; //20160901 igor
 isCraFilingCopy := false;           //jz//20260305 - only true when is filling copy

 If ButtonInactive then exit;
 If AllowPrinting(RetNo)=False then exit;
 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  MainForm.GuiCommand(gcAuditOpenBtnClick);
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
  //20180503 Igor >>>
  if CheckIsCloud(true) then //20180503 Igor
  begin
    PDFFullfileName := TPath.Combine(AppDir, 'tmp' + TPath.DirectorySeparatorChar + TPath.GetGUIDFileName + '.pdf');
    if not ForceDirectories(ExtractFileDir(PDFFullfileName)) then
    begin
      MessageDlg('Can not create temp folder', mtError, [mbOk], 0);
      Exit;
    end;
    PDF := TvtPDFPrinter.Create(AppT3_2026);
    try
      PDF.PrintForm(RetNo, FormName, 99, T3_2026Print.AfterReadComponentForPrint,
          T3_2026Print.PrintEditBox, nil, nil, nil);

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
        StartPrintForm(RetNo, FormName, 99);
    finally
      if Printer.Printing then //20160905 Igor
        Printer.EndDoc;        //20160905 Igor
    end;
  end;
  //20180503 Igor <<<
end;

procedure TMainFormT3_2026.StartPrintForm(Retno:integer;FormName:String;WhichPage:integer);
begin
   if not Assigned(Progress) then Progress:=TProgressT3_2026.Create(nil); //20151106 Igor

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
    Begin
     If CertificationMode = False then Calc(RetNo,FormName) //20120318
    end
    else
    Begin
     If CertificationMode = False then CalcMultiPageForm(RetNo,FormName);
    end;

    PrintForm(RetNo,FormName,WhichPage,'');
//    if Printer.Printing then  //20160901 Igor //20160905 Igor
//      Printer.EndDoc;         //20160901 Igor //20160905 Igor
 Progress.Close;
end;

procedure TMainFormT3_2026.PrintFBtnClick(Sender: TObject);
begin
PrintForm1Click(Sender);
{If RetNo>0 then PrintForm(RetNo,FormName);}
end;



procedure TMainFormT3_2026.Modem1Click(Sender: TObject);
begin
 (*
 Application.CreateForm(TCommFrm, CommFrm);
 CommFrm.ShowModal;
 CommFrm.Free;
 *)
end;

procedure TMainFormT3_2026.CreateDataDirectory1Click(Sender: TObject);
var s:sTring; //DataDir : string; //[60];Result : integer;ClickedOK: Boolean;
begin
 if CheckIsCloud then Exit; //20180503 Igor
 s:=CreateNewDataDir;
 If s>'' then
 begin
  SaveSingleOption('Dir_Cur',s);
  InitOptions;
 end;
end;



procedure TMainFormT3_2026.PrintTemplates1Click(Sender: TObject);
begin
Application.CreateForm(TPrSetT3_2026,PrSet);
PrSet.ShowModal;
PrSet.Free;

end;

procedure TMainFormT3_2026.FeeSchedule1Click(Sender: TObject);
begin
// If RetInMem>0 then  begin ShowMessage('Close all returns first');exit;end;
 Application.CreateForm(TFeesT3_2026,Fees);
 Fees.ShowModal;
 Fees.Free;
end;

procedure TMainFormT3_2026.Fonts1Click(Sender: TObject);
var
TempFont : TFont;
begin

end;




procedure TMainFormT3_2026.RemovecurrentreturnOverridesClick(Sender: TObject);
begin
  if ButtonInactive then exit;
  RemoveReturnOverrides(RetNo);
end;



procedure TMainFormT3_2026.CouplBtnClick(Sender: TObject);
begin
//SetCurrentFieldOverrideClick(Sender);
end;

procedure TMainFormT3_2026.OverrideBtnClick(Sender: TObject);
begin

{ShowOverridesClick(Sender);}
{SetCurrentFieldOverrideClick(Sender);}
end;

procedure TMainFormT3_2026.DataDictionary1Click(Sender: TObject);
begin
  FixDbForm(AppDir, DictDBLite, DictTableLite, dbtDataDict); //20150918 Igor
end;




procedure TMainFormT3_2026.DiagnosticsClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 MainForm.AuditOpenBtnClick(Sender);
 {If not AuditPanel.Visible then AuditBtnClick(Sender);}
end;

procedure TMainFormT3_2026.SamplesBtnClick(Sender: TObject);
begin
OptRec.Dir_Cur := OptRec.Dir_Sample;
FileOpenItemClick(Sender);
end;



Procedure TMainFormT3_2026.FullPrint(RetNo:Integer;Template:String);
Var i,j: integer; FormsToPrint :TstringList;
    Copies : string; //[1];
begin
end;


procedure TMainFormT3_2026.PrintReturn(RetNo:integer;FormsToPrint:TstringList;
 DataDir:string;FlName:string);
var i,j,FCopies:integer; FName :string; //[10];
begin
   Screen.Cursor := crHourGlass;

   if not Assigned(Progress) then Progress:=TProgressT3_2026.Create(nil); //20151106 Igor
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
   If Printer.Printing then Printer.EndDoc; //20160901 Igor
   NeedNewPage := False; //20160901 Igor
   Progress.Close;
   Ret[RetNo].Frm[GetFormNo('STATUS')].Strings[4] := '03';
   Ret[RetNo].PrpStatus :='03';
   UpdatePrintDate(RetNo,DataDir,FlName);
   Screen.Cursor := crDefault;
end;

Procedure TMainFormT3_2026.UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
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
  Ret[RetNo].Changed := True; //20170329 Igor
 (* //20170329 Igor
 If FileExists(DataDir+'\'+FlName) then
 begin
  TempList := TstringList.Create;
  Templist.LoadFromFile(DataDir+'\'+FlName);
  Templist.Add( 'F'+Delimiter+'STATUS'+Delimiter+Delimiter);
  TempList.Add('D'+Delimiter+'4'+Delimiter+'03'+Delimiter);
  TempList.Add('D'+Delimiter+'8'+Delimiter+User.UserName+Delimiter); //20170112 Igor
  TempList.Add('D'+Delimiter+'9'+Delimiter+FormatDateTime('yyyy-mm-dd',Now)+Delimiter);
  TempList.Add('D'+Delimiter+'10'+Delimiter+TimeToStr(Time)+Delimiter);
  Templist.SaveToFile(DataDir+'\'+FlName);
  TempList.Free;
 end;

 {now update the data base with RTU dates}
 //20150923 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'FILE_NAME');

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
 ADConnection.Free;
 *)
end;


(*
Procedure TMainFormT3_2026.UpdatePrintDate(RetNo:Integer;DataDir:string;FlName:string);
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
  TempList.Add('D'+Delimiter+'8'+Delimiter+User.UserName+Delimiter); //20170112 Igor
  TempList.Add('D'+Delimiter+'9'+Delimiter+FormatDateTime('yyyy-mm-dd',Now)+Delimiter);
  TempList.Add('D'+Delimiter+'10'+Delimiter+TimeToStr(Time)+Delimiter);
  Templist.SaveToFile(DataDir+'\'+FlName);
  TempList.Free;
 end;

 {now update the data base with RTU dates}
 //20150923 Igor
 ADConnection:= TADConnection.Create(Application);
 Table1 := TADTable.Create(Application);
 SetTableName(ADConnection, Table1, DataDir + '\' + ClientsDBLite, ClientsTableLite, 'FILE_NAME');

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
 ADConnection.Free;
end;
*)
procedure TMainFormT3_2026.Line1Click(Sender: TObject);
var
  s: string; //[4];
  // Table1 :TADTable;
begin
end;

procedure TMainFormT3_2026.JacketClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(RetNo,'T3',0);
end;

procedure TMainFormT3_2026.PersonaldataClick(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(RetNo,'T3',0);
end;

procedure TMainFormT3_2026.FixDataDictionary1Click(Sender: TObject);
begin
  FixDbForm(AppDir, DictDBLite, DictTableLite, dbtDataDict); //20150918 Igor
end;

procedure TMainFormT3_2026.FixFormSpecifications1Click(Sender: TObject);
begin
  FixDbForm(AppDir, FormsDBLite, FormsTableLite, dbtForms); //20150918 Igor
  InitFormsTable;
end;

procedure TMainFormT3_2026.FixClientDataBaseData1Click(Sender: TObject);
begin
  FixDbForm(OptRec.Dir_Cur, ClientsDBLite, ClientsTableLite, dbtClients); //20150918 Igor
end;

procedure TMainFormT3_2026.ShowCellNumbers1Click(Sender: TObject);
begin
  MainForm.ShowCellNumbers1Click(ShowCellNumbers1);
end;

procedure TMainFormT3_2026.ChangeDataDirectory1Click(Sender: TObject);
begin
 if CheckIsCloud then Exit; //20180503 Igor
 Application.CreateForm(TOptionsFrmT3_2026,OptionsFrm);
 OptionsFrm.ShowModal;
 OptionsFrm.Free;
//DataDirectories1Click(Sender);
end;

procedure TMainFormT3_2026.ClientListing1Click(Sender: TObject);
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

procedure TMainFormT3_2026.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 //If ServerMode=True then Application.Terminate;
 Action :=caNone;
 FileExitItemClick(Application);
end;



procedure TMainFormT3_2026.LoadSpousalReturnfromdatabaseCreate1Click(Sender: TObject);
begin
If ButtonInactive then exit;
end;



procedure TMainFormT3_2026.SwapReturns1Click(Sender: TObject);
Var RetNo,PrevRNo,PrevFNo :integer;
begin
  RetNo:=GetCurrentRetNo;
  If RetInMem(AppT3_2026, True) < 2 then //20161216 Igor //20170307 igor
  begin
   ShowMessage('To swap, you must have 2 or more returns in memory');
   exit;
  end;
  PrevRNo := RetNo;
  PrevFNo:= FormNo;

  If RetInMem(AppT3_2026, true) = 2 then  //20161216 Igor //20170307 igor
   RetNo:=GetNextReturn(RetNo, True) //20170307 igor
  else
   RetNo := SelectFromLoadedReturns(RetNo, True); //20170307 igor
  LockWindowUpdate(MainForm.Handle);
  If Ret[Retno].CalcStatus = false then CalcAll(retNo);
  OpenForm(RetNo, PrevFNo,0);
  If MainForm.LeftPanel.Visible then MainForm.RefreshAuditPanel(RetNo);
  LockWindowUpdate(0);
end;

procedure TMainFormT3_2026.Switchforms1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 If (PrevRetNo>0) and (PrevFormNo>0) then OpenForm(PrevRetNo,PrevFormNo,0);
end;

procedure TMainFormT3_2026.SwapFrmClick(Sender: TObject);
begin
 Switchforms1Click(Sender);
end;

procedure TMainFormT3_2026.FormsBtnClick(Sender: TObject);
begin
 //LetterType := 'Cover';
 SelectFormClick(Sender);
end;

procedure TMainFormT3_2026.UserSetUp1Click(Sender: TObject);
begin
Application.CreateForm(TUserSetupT3_2026,UserSetUp);
UserSetUp.ShowModal;
UserSetUp.Free;
end;

procedure TMainFormT3_2026.TipsBtnClick(Sender: TObject);
begin
 QuickStarterGuide1Click(Sender);
end;

procedure TMainFormT3_2026.CopyForm1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 If RetInMem<2 then
 begin
  ShowMessage('Form Copy allowed only between different returns in memory');
  exit;
 end;
 Application.CreateForm(TCopyFrmT3_2026,CopyFrm);
 CopyFrm.ShowModal;
 CopyFrm.Free;
end;

procedure TMainFormT3_2026.CopyBtnClick(Sender: TObject);
begin
CopyForm1Click(Sender);
end;

procedure TMainFormT3_2026.SchedBtnClick(Sender: TObject);
Var I:integer;
begin
  //If RetNo < 1 then exit;
  SomeList.Clear; // := TStringList.Create;
  SomeCaption := 'Schedules';
  for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];
      If Frec.FormType = 'SC' then
      SomeList.Add(Frec.FormInstName);
   end;
  SelectedString := PopSomeList(SomeList,SomeCaption);
end;


procedure TMainFormT3_2026.FrmSumBtnClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 OpenForm(GetCurrentRetNo,GetFormNo('BSUM'),0);

end;



Procedure TMainFormT3_2026.ShowMultiOfficeMsg;
begin
 ShowMessage('This option is available only to firms'+Chr(13)+
   'with Multi-operator and/or Multi-office operations');
end;

procedure TMainFormT3_2026.UserSetUp2Click(Sender: TObject);
begin
  if not isAdmin
 then
  begin
   ShowMessage('Only the Administrator can perform this function');
   exit;
  end;
 Application.CreateForm(TUserSetupT3_2026,UserSetUp);
 UserSetUp.ShowModal;
 UserSetUp.Free;
end;

procedure TMainFormT3_2026.HelpBtnClick(Sender: TObject);
Var HlpContextString :string;
begin
  ShowHelp(AppT3_2026.ModuleHelpFile, 'HELP_CONTENTS', True); //20161220 Igor
end;

procedure TMainFormT3_2026.Calculator1Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'Calc.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainFormT3_2026.Appointments2Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'Calendar.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainFormT3_2026.TransmitRTU1Click(Sender: TObject);
begin
{
Application.CreateForm(TPhone, Phone);
Phone.ShowModal;
Phone.Free;
}
end;

procedure TMainFormT3_2026.Contents2Click(Sender: TObject);
begin
  ShowHelp(AppT3_2026.ModuleHelpFile,'HELP_CONTENTS', True); //20161220 Igor
end;

procedure TMainFormT3_2026.SearchForHelpOnClick(Sender: TObject);
begin
 ShowHelp(AppT3_2026.ModuleHelpFile, 'HELP_CONTENTS', True); //20161220 Igor
end;

procedure TMainFormT3_2026.SearchFormSelect( //20190415 Igor
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

procedure TMainFormT3_2026.VisualTaxGuide1Click(Sender: TObject);
begin
  ConnectToWeb('www.visualtax.com/Vt2020HELP/TFHelp/Website/index.html');  //20210703
 //ConnectToWeb('www.visualtax.com/Vt2019HELP/T3Help/Website/Index.html'); //20191227
end;

procedure TMainFormT3_2026.Allforms1Click(Sender: TObject);
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
         PrintForm(RetNo,Frec.FormInstName,99,'');
      end;
    end;
 end;
end;


procedure TMainFormT3_2026.EfileErr1Click(Sender: TObject);
begin
//If UpperCase(InputBox('Input Box', 'PSW', '')) <> 'N/A' then exit;  //20230227 //20241229
ShowPdf(AppDir,'ch2-22e.pdf');   //20230225
end;

procedure TMainFormT3_2026.EFileerrorsCurrentReturn1Click(Sender: TObject);
begin
  If ButtonInactive then exit;
  OpenForm(GetCurrentRetNo,GetFormNo('STATUS'),0);
  (*
  Application.CreateForm(TEFMErrors,EFMErrors);
  EFMErrors.ShowModal;
  EFMErrors.Free;
  *)
end;

procedure TMainFormT3_2026.EfileT3slips1Click(Sender: TObject);
begin

//20260323
 If (LicenseLevel = llPower = false)
 and (IsEnterpriseVersion = false) then
 begin
  ShowMessage('Internet Filing of slips is available only in the T3-Power version');
  Exit;
 end;


 If ButtonInactive then exit;

 //20180311
 Ret[RetNo].SeriousErrorCount:=0;
 CountDiagnostics(RetNo);

 If Ret[RetNo].SeriousErrorCount>0 then
 begin
  ShowMessage('Please Fix Errors before Efiling');
  Exit;
 end;

 If ValidatePreparerInfo = false then Exit;  //20180317
 //20180317
 if OptRec.Prp_Email=''  then
 begin
   ShowMessage('Please Enter an Email Address in Configure -> General Options -> Preparer');
   Exit;
 end;


 Application.CreateForm(TInternetFrmT3_2026,InternetFrm);
 InternetFrm.ShowModal;
 InternetFrm.Free;
end;

procedure TMainFormT3_2026.EfiletheT11351Click(Sender: TObject);
begin
 //If UpperCase(InputBox('Expected release: Feb 20', 'PSW', '')) <> 'N/A' then exit;  //202202215
 {
 //20220320
 ShowMessage('The T3-T1135: expected release March 25 - March 31'+
       chr(13)+'It is currently with CRA for Review and Certification');
 }

 If ButtonInactive then exit; //20220128 Igor
// If UpperCase(InputBox('Expected release: Feb 20', 'PSW', '')) <> 'N/A' then exit;  //20220313

 OpenForm(RetNo,GetFormNo('T1135'),0); //20220116
end;

procedure TMainFormT3_2026.MultipleDnBtnClick(Sender: TObject);
begin
  if NoActiveForm then exit;
  OpenPrevInstance(RetNo, FormName);
end;

procedure TMainFormT3_2026.MultipleUpBtnClick(Sender: TObject);
begin
  if NoActiveForm then exit;
  OpenNextInstance(RetNo, FormName);
end;

procedure TMainFormT3_2026.Restructure1Click(Sender: TObject);
begin
(*
Application.CreateForm(TRestruct,Restruct);
Restruct.ShowModal;
Restruct.Free;
*)
end;

procedure TMainFormT3_2026.DependBtnClick(Sender: TObject);
begin
If ButtonInactive then exit;
OpenForm(GetCurrentRetNo,GetFormNo('DEPEND'),0);
end;

procedure TMainFormT3_2026.ABCBtnClick(Sender: TObject);
begin
 AlphabeticalFormsIndex1Click(Sender);
end;

procedure TMainFormT3_2026.PrintManager1Click(Sender: TObject);
Var h : THandle;
begin
 h := ShellExecute(MainForm.Handle, Nil, 'PrintMan.Exe', Nil,
  Nil, SW_RESTORE);
end;

procedure TMainFormT3_2026.ClientLetters1Click(Sender: TObject);
begin
  { Ucletter.PrintLetter(RetNo, Table2.Fields[0].DisplayText);}
end;

procedure TMainFormT3_2026.TaxReturnCoveringletter1Click(Sender: TObject);
begin
(*
Application.CreateForm(TCustLtr,CustLtr);
CustLtr.ShowModal;
CustLtr.Free;
*)
end;




procedure TMainFormT3_2026.ShowOverridesClick(Sender: TObject);
 Var I: integer;
begin
 //If RetInMem < 1 then exit;
 if ButtonInactive then exit;
 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'Forms with Overrides';
  OverList.EnumRecs(AppT3_2026,SomeList);
  SelectedString := PopSomeList(SomeList, SomeCaption);
 If SelectedString > '' then
   OpenForm(GetCurrentRetNo,GetFormNo(SelectedString),0);
end;

procedure TMainFormT3_2026.ShowReturn(ARetNo: integer); //20190211 Igor
begin
  If ARetNo > 0 then
  begin
    vtChild.CreateNewMDIChild(ARetNo, '').HideAllControls;
    try
      LockWindowUpdate(MainForm.Handle);
      MainForm.GuiCommand(gcRetNoChanged);
      CountDiagnostics(ARetNo);
      OpenForm(ARetNo, 'T3', 0); //20190313 Igor
    //  OpenForm(RetNo, 'T3', 0);
      //MainForm.LeftPanel.Visible:=True;
      MainForm.GuiCommand(gcShowLeftPanel);

      If Ret[ARetNo].FrmHasData[GetFormNo('T5013SUM')] then
        OpenForm(ARetNo, GetFormNo('T5013SUM'), 0);

      OpenUsedForms(ARetNo);

      MainForm.FormPaint(Application);
    finally
      vtChild.CreateNewMDIChild(ARetNo, '').ShowAllControls;
    end;
  end;
end;

procedure TMainFormT3_2026.ListReviewmarks1Click(Sender: TObject);
Var I: integer;
begin
 If ButtonInactive then exit;
 {AuditOption.ItemIndex :=1;}
 {If not AuditPanel.Visible then AuditBtnClick(Sender);}

end;

procedure TMainFormT3_2026.SystemInformation1Click(Sender: TObject);
//20170901 Igor>>>
//Var h : THandle;
begin
// h := ShellExecute(MainForm.Handle, Nil, 'WINFO.Exe', Nil,
//  Nil, SW_RESTORE);
// if h<=32 then ShowMessage('Info cannot be displayed. Code '+IntToStr(h));
  MessageDlg(OSTest, mtInformation, [mbOk], 0);
//20170901 Igor<<<
end;

procedure TMainFormT3_2026.RC4657Click(Sender: TObject);
begin
 ShowPdf(AppDir,'rc4657-ch1-22e.pdf');   //20230225
end;

procedure TMainFormT3_2026.RebuildtheClientDataBase1Click(Sender: TObject);
begin
 If RetInMem>0 then
  begin ShowMessage('Please close all returns first');exit;end;
 Application.CreateForm(TRebuildT3_2026,Rebuild);
 Rebuild.ShowModal;
 Rebuild.Free;
end;

procedure TMainFormT3_2026.MergeDataBases1Click(Sender: TObject);
begin
{ If Not FeatureAllowed then exit;}
 If RetInMem>0 then
  begin ShowMessage('Please close all returns first');exit;end;
 Application.CreateForm(TMergeT3_2026,Merge);
 Merge.ShowModal;
 Merge.Free;
end;

procedure TMainFormT3_2026.FileViewerEditor1Click(Sender: TObject);
begin
Application.CreateForm(TFileVuT3_2026,FileVu);
FileVu.ShowModal;
FileVu.Free;
end;

procedure TMainFormT3_2026.CurrentPage1Click(Sender: TObject);
var i,whichPage:integer;
    //20180503 Igor >>>
    PDFFullfileName: string;
    PDF: TvtPDFPrinter;
    //20180503 Igor <<<
begin
 FastPrint := False;
 If ButtonInactive then exit;
 If AllowPrinting(RetNo)=False then exit;
 isCraFilingCopy := false; //jz//20260305 - only true when is filling copy

 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'Select Page to Print';

 for i:=1 to GetFormMxPg(FormName) do
 begin
  SomeList.Add(inttostr(i));
 end;
  SelectedString := PopSomeList(SomeList,SomeCaption);

 If SelectedString > '' then
 begin
     whichPage := strToInt(Trim(SelectedString)) //20210629 Igor
    //whichPage := strToInt(LeftStr(SelectedString,1))
 end
 else
    exit;

 CountDiagnostics(GetCurrentRetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  If not MainForm.WizardPanel.visible then MainForm.AuditOpenBtnClick(Sender);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;
 If Not AllowedToFormPrint(GetCurrentRetNo,FormName) then exit;
 //LetterType := 'Cover';
 //20180503 Igor >>>
  if CheckIsCloud(true) then //20180503 Igor
  begin
    PDFFullfileName := TPath.Combine(AppDir, 'tmp' + TPath.DirectorySeparatorChar + TPath.GetGUIDFileName + '.pdf');
    if not ForceDirectories(ExtractFileDir(PDFFullfileName)) then
    begin
      MessageDlg('Can not create temp folder', mtError, [mbOk], 0);
      Exit;
    end;
    PDF := TvtPDFPrinter.Create(AppT3_2026);
    try
      PDF.PrintForm(RetNo, FormName, whichPage, T3_2026Print.AfterReadComponentForPrint,
          T3_2026Print.PrintEditBox, nil, nil, nil);

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
 //20180503 Igor <<<
end;


procedure TMainFormT3_2026.CplBtnClick(Sender: TObject);
begin
 //EndCoupling1Click(Sender);
 {UpdateMenuItems(Sender);}
end;

procedure TMainFormT3_2026.MinTaxBtnClick(Sender: TObject);
begin
 //OpenForm(GetCurrentRetNo,GetFormNo('T691_1'),0);
end;

procedure TMainFormT3_2026.ClientListings1Click(Sender: TObject);
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

procedure TMainFormT3_2026.CopyBackUp1Click(Sender: TObject);
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

procedure TMainFormT3_2026.RecalcBtnClick(Sender: TObject);
Var FNo:integer;
begin
 If ButtonInactive then exit;
 Screen.Cursor := crHourGlass;
 CalcAll(RetNo);
 Screen.Cursor := crDefault;
 If FormNo>0 then MyChild.ShowFormData(FormName,FormNo);
 MyChild.UpdateChildTaxPanel();
end;


procedure TMainFormT3_2026.PreselNextBtnClick(Sender: TObject);
Var j:Integer;MyPageControl:TPageControl;
begin
  If ButtonInactive then exit;
  MyPageControl:=MyChild.MyPageControl; // GetPageControl(MyChild);
  j:=MyPageControl.ActivePageIndex;
  If J<MyPageControl.PageCount-1 then
    OpenForm(RetNo,GetFormNo(MyPageControl.Pages[j+1].Caption),0);
end;

procedure TMainFormT3_2026.PreSelPrvBtnClick(Sender: TObject);
Var j:Integer;MyPageControl:TPageControl;
begin
  If ButtonInactive then exit;
  MyPageControl:=MyChild.MyPageControl; // GetPageControl(MyChild);
  j:=MyPageControl.ActivePageIndex;
  If J>0 then OpenForm(RetNo,GetFormNo(MyPageControl.Pages[j-1].Caption),0);
end;



procedure TMainFormT3_2026.ChangeLicenseLevel;
Var K,Psw:string;// PgmNames,ProductIds,PgmFactors:TstringList;
begin
  if not IsDeveloperLogin then exit;
  AppT3_2026.SetLicense(InputBox('Input Box', '', ''));
 Licensee:='Some Multi-user';
 SelectFeatures;
 MainForm.FormPaint(Application);
End;


procedure TMainFormT3_2026.NISAcodes1Click(Sender: TObject);
begin
 SomeList.Clear;  // := TStringList.Create;
 //SomeList.Sorted := True;
 SomeCaption := 'CAIS CODES';
 {ListCaption;}
  SelectedString := PopSomeFile(AppDir+'\'+'CAIS.D',SomeCaption);
end;

procedure TMainFormT3_2026.OnCreateMenuItem(const aName: string; //20190228 Igor //20190415 Igor
  const aHelperID: Integer);
var
  Item: TActionClientItem;
begin
//  Item := RBGReturn_Help.Items[1].Items.Add;
//  Item.Action := actForCloud;
//  Item.Caption := aName;
//  Item.Tag := aHelperID;
end;

procedure TMainFormT3_2026.OpenBtnClick(Sender: TObject);
begin
 FileOpenItemClick(Application);
end;

procedure TMainFormT3_2026.YourLatestReleaseClick(Sender: TObject);
begin
 ConnectToWeb('https://www.visualtax.com/T3-2023-WhatsNew.html'); //20231223
 // ConnectToWeb('http://www.visualtax.com/VT2020HELP/T3help/T3upd/WhatsNew.html');  //202020
 // ConnectToWeb('http://visualtax.com/Vt2018HELP/T3Help/T3UPD/T3UpdHlp.html'); //20190313
 // ShowHelp(AppT3_2026.ModuleHelpUpdFile,'HELP_CONTENTS', true); //20160810 Igor //20161220 Igor //20170219 CON
 // ShowHelp(AppT3_2026.ModuleHelpUpdFile,'CONTENTS', True); //20160801 Igor
end;
(*
procedure TMainFormT3_2026.YourLatestReleaseClick(Sender: TObject);
begin
  ConnectToWeb('http://visualtax.com/Vt2016HELP/T3Help/T3UPD/T3UpdHelp.htm'); //20170219 CON
 // ShowHelp(AppT3_2026.ModuleHelpUpdFile,'HELP_CONTENTS', true); //20160810 Igor //20161220 Igor //20170219 CON
 // ShowHelp(AppT3_2026.ModuleHelpUpdFile,'CONTENTS', True); //20160801 Igor
end;
*)

procedure TMainFormT3_2026.ZoomBtnPlusClick(Sender: TObject);
begin
  ZoomBtnClicked(+5); //20160209 Igor
//  if ZoomBtnClicked(+5) then
//    ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
end;

procedure TMainFormT3_2026.ZoomBtnMinusClick(Sender: TObject);
begin
  ZoomBtnClicked(-5); //20160209 Igor
//  if ZoomBtnClicked(-5) then
//    ZoomPercentLbl.Caption:=IntToStr(OptRec.FormZoom)+'%';
end;

procedure TMainFormT3_2026.Image2Click(Sender: TObject);
begin
 //WizardPanel.Visible :=False;
end;


procedure TMainFormT3_2026.Upgrade1Click(Sender: TObject);
//Const ActivationFile = 'LVerf.EX_';
begin
  ShowAbout;
end;

procedure TMainFormT3_2026.AuditListBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If  (Key = VK_F5) then MainForm.AuditOpenBtnClick(Sender);
end;

procedure TMainFormT3_2026.BitBtn1Click(Sender: TObject);
begin
  EXIT;
end;


procedure TMainFormT3_2026.btnDownloadClick(Sender: TObject); //20190211 Igor
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

procedure TMainFormT3_2026.btnUploadClick(Sender: TObject); //20190211 Igor
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

procedure TMainFormT3_2026.btnUploadWithoutOpenClick(Sender: TObject); //20190211 Igor
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

procedure TMainFormT3_2026.Buildreport1Click(Sender: TObject); //20180424 Igor
begin
  if LicenseLevel in [llPower..llMultiPower] then
    ReportBuilder(AppT3_2026)
  else
  begin
    ShowMessage('Available only in the Power version of the program');
    Exit;
  end;
end;

procedure TMainFormT3_2026.buttonAvailableWidthClick(Sender: TObject);
begin
  MainForm.GuiCommand(gcAvailableWidth);
end;

procedure TMainFormT3_2026.InternetWebSite1Click(Sender: TObject);
Var h:THandle;
begin
 ConnectToWeb('HTTP://www.VisualTax.com');
end;

procedure TMainFormT3_2026.WWWLblClick(Sender: TObject);
begin
 InternetWebSite1Click(Sender);
end;

function TMainFormT3_2026.FormsTreeView1Click(SourceNode: TTreeNode; fUsedForms: boolean): integer;
//procedure TMainFormT3_2026.FormsTreeView1Click(Sender: TObject);
Var Fname:String; Ndx: integer;
begin
  Result := 0;
  If ButtonInactive then exit;
  If fUsedForms then
   Fname:=GetFName(SourceNode.Text)
  else
  begin
    Ndx :=SourceNode.AbsoluteIndex;
    Fname := AllTrim(FrmTreeForms[ndx]);
  end;

  If FName >'' then //OpenForm(GetCurrentRetNo,GetFormNo(FName),0);
    Result := GetFormNo(FName);
end;


procedure TMainFormT3_2026.WorldButtonClick(Sender: TObject);
begin
InternetWebSite1Click(Sender);
end;


procedure TMainFormT3_2026.AlphabeticalFormsIndex1Click(Sender: TObject);
begin
EXIT;
 If ButtonInactive then exit;
 Application.CreateForm(TABListT3_2026,ABList);
 ABList.ShowModal;
 ABList.Free;
end;

procedure TMainFormT3_2026.amT3StateChange(Sender: TObject); //20180108 Igor //20190415 Igor
var
  I: Integer;
begin
  if (MainOptions.Skin = skRibbon) and (amT3.State = TActionListState.asNormal) then
  begin
    for I := 0 to amT3.ActionCount - 1 do
    begin
      amT3.Actions[I].Enabled := not amT3.Actions[I].Enabled;
      amT3.Actions[I].Enabled := not amT3.Actions[I].Enabled;
    end;
  end;
end;

procedure TMainFormT3_2026.Zoomin1Click(Sender: TObject);
begin
ZoomBtnPlusClick(Sender);
end;

procedure TMainFormT3_2026.Zoomout1Click(Sender: TObject);
begin
ZoomBtnMinusClick(Sender);
end;

procedure TMainFormT3_2026.Toolbandswitch1Click(Sender: TObject);
begin
 ToolBarBtnClick(Sender);
end;

procedure TMainFormT3_2026.Color1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
  MainForm.ClrClick(RetNo, Sender, c_ReturnColorElm); //20170219 Igor
end;

procedure TMainFormT3_2026.RecalcandSaveClick(Sender: TObject); //20230101
begin
EXIT;
If RetInMem(AppT3_2026) > 0 then  //20161223 Igor
 begin
   ShowMessage('Please close all returns first');
   exit;
 end;
// Application.CreateForm(TRecalcT3_2026,Recalc);
// Recalc.ShowModal;
// Recalc.Free;
end;

procedure TMainFormT3_2026.Recalc1Click(Sender: TObject);
begin
RecalcBtnClick(Sender);
end;

procedure TMainFormT3_2026.AdjustFontSize;
begin
EXIT;
end;

procedure TMainFormT3_2026.AppException(Sender: TObject; E: Exception);
begin
  Application.ShowException(E);
end;


procedure TMainFormT3_2026.ReIndextheClientDataBase1Click(Sender: TObject);
begin
ExecuteForm(TReindexDbT3_2026);
end;

procedure TMainFormT3_2026.ReloadMainMenu; //20190228 Igor
begin
  LoadPluginActions(Self, MainMenu, OpenFromCloudClick, OnCreateMenuItem);
end;

procedure TMainFormT3_2026.TreeViewBtnClick(Sender: TObject);
begin
If ButtonInactive then exit;
If RetInMem<2 then
begin
 ShowTimedMsg('Window tiling is effective only when multiple returns are loaded',1800);
end;
 SomeList.Clear;  // := TStringList.Create;
 SomeList.Add('1. Tile Horizontally');
 SomeList.Add('2. Tile Vertically');
  SelectedString := PopSomeList(SomeList);
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

procedure TMainFormT3_2026.RestructuretheClientsDataBase1Click(Sender: TObject);
begin
(*
 Application.CreateForm(TRestructure,Restructure);
 Restructure.ShowModal;
 Restructure.Free;
 *)
end;



procedure TMainFormT3_2026.WidePanelBtnClick(Sender: TObject);
Var Denom:Integer;
begin
end;

procedure TMainFormT3_2026.AuditOpenBtnClick(Sender:TObject);
begin
 If ButtonInactive then exit;
 //LockWindowUpdate(MainForm.Handle);
 MainForm.RefreshAuditPanel(RetNo);
 //MainForm.LeftPanel.Visible := not MainForm.LeftPanel.Visible;
 MainForm.GuiCommand(gcToggleLeftPanel);
 //LockWindowUpdate(0);
end;

procedure TMainFormT3_2026.ExchageRatesAverage1Click(Sender: TObject);
begin
 SomeList.Clear;  // := TStringList.Create;
 SomeList.Sorted := True;
 SomeCaption := 'Average Exchange Rates';  //for 2005';
  SelectedString := PopSomeFile(AppDir+'\'+'EXCHRATE.D', SomeCaption,True);
end;

procedure TMainFormT3_2026.Checkupdate1Click(Sender: TObject);
Var h:THandle;
begin
  ConnectToWeb('https://www.visualtax.com/download.php');
end;

procedure TMainFormT3_2026.Image1Click(Sender: TObject);
 Var h : Thandle;
begin
 Checkupdates1Click(Sender);
end;

procedure TMainFormT3_2026.CheckUpdatesLblClick(Sender: TObject);
begin
 Checkupdates1Click(Sender);
end;

procedure TMainFormT3_2026.Label1Click(Sender: TObject);
begin
 InternetWebSite1Click(Sender);
end;

procedure TMainFormT3_2026.ClearCurrentformClick(Sender: TObject);
Var i,n:Integer;Root:string; //[10];
begin
  ClearCurrentPageClick(Sender);
end;

procedure TMainFormT3_2026.ClearCurrentPageClick(Sender: TObject);
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
 Ret[RetNo].MyChild.ActiveForm.RebuildDynamicRows; //20160527 Igor
 MyChild.ShowFormData(FormName,FormNo);
 Ret[RetNo].FrmHasData[GetFormNo(FormName)]:=False;
 MainForm.RefreshAuditPanel(RetNo);//If AuditPanel.Visible then RefreshAuditPanel;
 //If FormsPanel.Visible then RefreshFormsPanel(RetNo);
end;

//20161216 Igor
//Function TMainFormT3_2026.SelectFromLoadedReturns(RetNo:Integer):Integer;
//Var i:Integer;
//begin
// Result:=RetNo;
// SomeList.Clear;  // := TStringList.Create;
// SomeList.Sorted := True;
// SomeCaption := 'Select from Loaded returns';
//  RetList.GetListOfLoadedReturns(SomeList, AppT3_2026); //20161216 Igor
//  SelectedString := PopSomeList(SomeList,SomeCaption);
// If SelectedString > '' then
//   Result:=MyStrToInt(AllTrim(LeftStr(SelectedString,2)));
//end;


procedure TMainFormT3_2026.OpenPreviousYearsT11Click(Sender: TObject);
 Var h : Thandle;
   PgmPathS,PgmS,PgmParmsS:String;
   PgmPathZ : Array[0..254] of Char;
   PgmParmsZ : Array[0..254] of Char;
   PgmZ: Array[0..254] of Char;
   s:String;
begin
 if CheckIsCloud then Exit; //20180503 Igor
 S:= InputBox('Input Box', 'Program path and name (not necessarily VisualTax)', 'C:\T3-2016\T32016.EXE');
 PgmPathS := ExtractFileDir(S); StrPCopy(PgmPathZ,PgmPathS);
 PgmS:=ExtractFileName(S); StrPCopy(PgmZ,PgmS);
 PgmParmsS:=''; StrPCopy(PgmParmsZ,PgmParmsS);
 h := ShellExecute(MainForm.Handle, Nil, PgmZ, PgmParmsZ,PgmPathz, SW_RESTORE);
 If H<=32 then ShowMessage('Program not found');
end;

procedure TMainFormT3_2026.ImportConfiguration1Click(Sender: TObject);
begin
 if CheckIsCloud then Exit; //20180503 Igor
 Application.CreateForm(TImportConfigT3_2026,ImportConfig);
 ImportConfig.ShowModal;
 ImportConfig.Free;
end;


procedure TMainFormT3_2026.ExportConfiguration1Click(Sender: TObject);
begin
 if CheckIsCloud then Exit; //20180503 Igor
 Application.CreateForm(TExportConfigT3_2026,ExportConfig);
 ExportConfig.ShowModal;
 ExportConfig.Free;

end;

procedure TMainFormT3_2026.Findaline1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 Application.CreateForm(TFindALineT3_2026,FindALine);
 FindALine.ShowModal;
 FindALine.Free;
end;



procedure TMainFormT3_2026.LinesBtnClick(Sender: TObject);
begin
Findaline1Click(Sender);
end;


procedure TMainFormT3_2026.UsefulLinksClick(Sender: TObject);
Var h:THandle;
begin
  ConnectToWeb('https://www.visualtax.com/links.php');
end;

procedure TMainFormT3_2026.SetReturnPassword1Click(Sender: TObject);
Var s:String;
begin
  If buttonInactive then exit;
  Application.CreateForm(TSetFilePswT3_2026,SetFilePsw);
  SetFilePsw.ShowModal;
  SetFilePsw.Free;
end;

procedure TMainFormT3_2026.SetSearchStr(const AValue: String); //20180117 Igor //20190415 Igor
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

procedure TMainFormT3_2026.SetZoomStr(const Value: String); //20180117 Igor
begin
  ZoomPercentLbl.Caption := Value;
  lblZoom.Caption := Value;
  lblZoom2.Caption := Value;
end;

procedure TMainFormT3_2026.RemoveReturnPassword1Click(Sender: TObject);
begin
 If buttonInactive then exit;
 RemoveReturnPsw(RetNo);
 ShowTimedMsg('Password Removed',1000);
end;

procedure TMainFormT3_2026.SetProgramPassword1Click(Sender: TObject);
Var s:String;
begin
  SetThePgmPsw;
end;

procedure TMainFormT3_2026.RemoveProgramPassword1Click(Sender: TObject);
begin
 RemovePgmPsw;
 ShowTimedMsg('Program Password Removed',1000);
end;

procedure TMainFormT3_2026.PrintAuditBtnClick(Sender: TObject);
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


procedure TMainFormT3_2026.EmailCurrentFormClick(Sender: TObject);
begin
 If buttoninactive then exit;
 If AllowPrinting(RetNo)=False then exit;
 If not IsFormMultipage(FormName) then
  Calc(RetNo,FormName)
 else
  CalcMultiPageForm(RetNo,FormName);
 PrintFormForEmail(RetNo,FormName);
end;

procedure TMainFormT3_2026.PrintFormForEmail(RetNo:Integer;FormName:String);
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
  Application.CreateForm(TPDFFrmT3_2026,PdfFrm);
  PdfFrm.ShowModal;
  PdfFrm.Free;
 end;
end;


procedure TMainFormT3_2026.SaveALLopenedreturns1Click(Sender: TObject);
begin
EXIT;
 SaveAllReturns;
end;

Function TMainFormT3_2026.SaveAllReturns:Boolean;
begin
  Result:=False;
 If RY=1 then
 begin
  ShowMessage('A return is in Planning mode. Please use one-by-one Save (F3)');
  Exit;
 end;
  Result := MainForm.SaveAllReturns;
end;

Function TMainFormT3_2026.DoSaveAllReturns(RNo: integer):Boolean;
Var
  i:Integer;FlName,DataDir:String;
  RetNo: boolean; //force errors, use RNo!
begin
  if Ret[RNo].isAppendix then //20160629 Igor
    exit;

 Result:=False;
 If RY=1 then
 begin
  ShowMessage('A return is in Planning mode. Please use one-by-one Save (F3)');
  Exit;
 end;

 //Screen.Cursor:=CrHourGlass;
 //for i :=0 to (RetList.Count - 1) do
 begin
   //RetRec := RetList.Items[i];
   //RNo:=RetRec.RetNo;
   CalcAll(RNo);
   Ret[RNo].CalcStatus := True;
   CountDiagnostics(RNo);
   If RetList[RNo].MandatoryErrorCount > 0 then
   begin
    OpenForm(RNo,GetFormNo('T3'),0);
    //If not LeftPanel.Visible then begin LeftPanel.Visible:=True; AuditOpenBtnClick(Application);End;
    //RefreshAuditPanel(GetCurrentRetNo);
    MainForm.AuditOpenBtnClick(nil);
    ShowMessage('Please enter Mandatory data before saving and try again');
    Screen.Cursor:=CrDefault;
    exit;
   end;
   FlName := Ret[RNo].SourceFlName;
   If FlName = '' then
   FlName := LeftStr(FetchElm(RNo,'T3',3),8)+
    '.'+RightStr(FetchElm(RNo,'T3',3),1);
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
   If FileExists(DataDir+'\'+ClientsDBLite) = False then //20150923 Igor
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
     Result:=True;
   end
   else
   begin
      ShowMessage('Return was not saved... Press any key');
      exit;
   end;
  END;
 end;  //i
end;


procedure TMainFormT3_2026.SaveandCloseAllopenedreturns1Click(Sender: TObject);
begin
(*  //20260631  Non on the menu
 EXIT; //?
 If RY=1 then
 begin
  ShowMessage('A return is in Planning mode. Please use one-by-one Save (F3)');
  Exit;
 end;
 If SaveAllReturns= True then CloseAllReturns;
*)
end;

procedure TMainFormT3_2026.CloseallreturnsWITHOUTSaving1Click(Sender: TObject);
Var i:Integer;RetNo:Integer; //FHandle:THandle
begin
 if MessageDlg('Close ALL returns without saving them?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then CloseAllReturns;
end;


Procedure TMainFormT3_2026.CloseAllReturns;
Var i:Integer; TempList:TStringList;RetNo:Integer;
begin
  MainForm.CloseAllReturns;
end;

procedure TMainFormT3_2026.TestBlBoxClick(Sender: TObject);
Var FrmNm:String;RetNo:Integer;
begin
end;


procedure TMainFormT3_2026.CloseBlackBoxBtnClick(Sender: TObject);
Var Templist:TStringList;
begin
end;

procedure TMainFormT3_2026.ProcessBlackBoxFile;
Var RetNo:Integer;
begin
end;  //end blackbox


procedure TMainFormT3_2026.FormsBlackBoxBtnClick(Sender: TObject);
begin
 SelectFormClick(Sender);
end;



procedure TMainFormT3_2026.Provincialnews1Click(Sender: TObject);
begin
 ShowHelp(AppT3_2026.ModuleHelpFile, 'HELP_CONTENTS', True); //20161220 Igor

end;


Function TMainFormT3_2026.CountFiles(Dir:String;FileExt:String):Integer;
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



procedure TMainFormT3_2026.CICALineByLineInternethelpNONResidents1Click(Sender: TObject);
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

procedure TMainFormT3_2026.OtherGuides1Click(Sender: TObject);
Var PgmPath,PgmFile:String;
begin
 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'CRA GUIDES';
  SelectedString := PopSomeFile(AppDir+'\'+'GUIDES.d', SomeCaption);
 If SelectedString > '' then
 begin
  PgmPath:=AppDir;
  PgmFile:=AllTrim(LeftStr(SelectedString,8))+'.PDF';
  ShowPdf(PgmPath,PgmFile);
 end;

end;


procedure TMainFormT3_2026.CCArates1Click(Sender: TObject);
begin
 //SomeList.Sorted := True;
 SomeCaption := 'CCA RATES (Class  Rate  Description)';
 {ListCaption;}
  PopSomeFile(AppDir+'\'+'CCARATES.D',SomeCaption);
end;



procedure TMainFormT3_2026.Checkupdates1Click(Sender: TObject);
Var h:THandle;
begin
  CheckUpdates(Self.Handle,AppName+'-'+AppYear);
end;

procedure TMainFormT3_2026.Frequentlyaskedquestions1Click(Sender: TObject);
Var h:THandle;
begin
 
end;

procedure TMainFormT3_2026.VisualTaxForum1Click(Sender: TObject);
Var h:THandle;
begin
  ConnectToWeb('http://www.visualtax2.com/cgi-bin/dcforum/dcboard.cgi');
end;

procedure TMainFormT3_2026.HowoftentocheckInternetUpdates1Click(Sender: TObject);
begin
 Application.CreateForm(TUpdateScheduleT3_2026,UpdateSchedule);
 UpdateSchedule.ShowModal;
 UpdateSchedule.Free;
end;

procedure TMainFormT3_2026.TrEngineLoadClick(Sender: TObject);
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


procedure TMainFormT3_2026.ListMultipleBtnClick(Sender: TObject);
Var I,J,MxPg,k,FNo:Integer; FName,FNonInst,FRootName,FInst:string;
//RetNo:Integer;
s:String;
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
      FInst:=Frec.FormInst;
      If Ret[RetNo].FrmHasData[FNo] then
      Begin
        If (LeftStr(FormName,7)='T3SUPL#') then
         Somelist.Add(PaddR(FNonInst+FInst,10)+' '+FetchElmFNo(RetNo,FNo,26))
        //20120328
        else
         Somelist.Add(PaddR(FNonInst+FInst,10));
      end;
    end; //found the form
   end;  //i
   SomeCaption := 'List of multi-instance forms';
    SelectedString := PopSomeList(SomeList,SomeCaption);
   If SelectedString > '' then OpenForm(RetNo,GetFormNo(AllTrim(LeftStr(SelectedString,10))),0);
   Exit;
 end;  //check slips

end;

procedure TMainFormT3_2026.TrGuide1Click(Sender: TObject);
begin
ConnectToWeb('http://www.visualtax.com/TrGuide-2005.htm');
end;

procedure TMainFormT3_2026.DefinetheTRfolder1Click(Sender: TObject);
Var TempList:TStringList;Prompt:String;
begin
 Prompt:=GetTrFolder;
 If Prompt='' then Prompt:='C:\TR-2017';
 TrFolder:= InputBox('Input Box', 'Enter your TR installation folder', Prompt);
 If UpperCase(TrFolder)=UpperCase(AppDir) then
 begin
  ShowMessage('The TR must be installed outside the T1 or T2 or T3 program folder');
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

procedure TMainFormT3_2026.TileHorizontally1Click(Sender: TObject);
begin
  MainForm.TileHorizontally1Click;
end;


procedure TMainFormT3_2026.TileVertical1Click(Sender: TObject);
begin
  MainForm.TileVertical1Click;
end;


//20151017 Igor
procedure TMainFormT3_2026.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := false;
  // 20151017 Convert *.dbf => *.db on OptRec.Dir_Cur and AppDir
  //20160118 Igor
  vtDataModuleUnit.{vtDataModule.}DataBaseCreate(AppT3_2026.SQLLitePassword,AppT3_2026.ClientsDBLite,IncludeTrailingPathDelimiter(OptRec.Dir_Cur), IncludeTrailingPathDelimiter(AppDir));
end;

procedure TMainFormT3_2026.NewReturnLblClick(Sender: TObject);
begin
  FileNewItem_Click(Sender);
end;

procedure TMainFormT3_2026.OpenReturnLblClick(Sender: TObject);
begin
FileOpenItemClick(Sender);
end;

procedure TMainFormT3_2026.OpentheClientsDocsfolder1Click(Sender: TObject);
Var InitDir,FullFlName,FlName:String;h:Word;PgmPath:String;PgmFile:String;
   RetNo:Integer;
   dir:string;
begin
 if CheckIsCloud then Exit; //20180503 Igor
 RetNo:=GetCurrentRetNo;
 If ButtonInactive then exit;
  {
  case CaseDo('',
   [
    'Open Document Folder',
    'Open Permanent Folder'
    ], nil) of
   // vtScan
   1: Dir := optRec.Dir_PermanentDocs+'\'+MkDirforClientDocs(RetNo);//optRec.Dir_PermanentDocs + '\' + GetLastName(retNo) + ','+ GetFirstName(retNo);
  else
  }
  //20230312
  LoadOptionsFileToMem;  //20230312
  Dir := optRec.Dir_ClientDocs + '\' +MkDirforClientDocs(RetNo);

  if not DirectoryExists(Dir) then ForceDirectories(Dir); //20200322
  if not DirectoryExists(Dir) then
    ShowMessage('Directory does not exist')
  else
    ShellExecute(Application.Handle, 'open', PChar(Dir), nil, nil, SW_SHOWNORMAL) ;
end;


procedure TMainFormT3_2026.ShowMostRecentReturns;
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
  If MainOptions.HideMostRecent then Exit;
  With ListView1 do
  begin
    ListView1.Items.BeginUpdate; //20170127 Igor
    try                          //20170127 Igor
      ListView1.Items.Clear;
      ListView1.Columns.Clear; //20170130 Igor
  //    ListView1.Visible:=False; //20170127 Igor
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
      try  //20170127 Igor
        If FileExists(AppDir+'\'+RecentRFlName) then
        begin
         SomeList.LoadFromFile(AppDir+'\'+RecentRFlName);
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
//20170127 Igor >>>
      finally
        SomeList.Free;
      end;
    finally
      ListView1.Items.EndUpdate
    end;
  end; //with
//  ListView1.Visible:=True;
//20170127 Igor <<<
end;

procedure TMainFormT3_2026.WhatsNewLblClick(Sender: TObject);
begin
YourLatestReleaseClick(Sender);
end;

procedure TMainFormT3_2026.FaQLblClick(Sender: TObject);
begin
Frequentlyaskedquestions1Click(Sender);
end;

procedure TMainFormT3_2026.HelpLblClick(Sender: TObject);
begin
VisualTaxGuide1Click(Sender);
end;

procedure TMainFormT3_2026.HistoryofEFilesubmissions1Click(Sender: TObject); //20211227 Igor
Var OnlineNo,Password,Url,NetFileDir:String;
FlNm:String;
h: THandle;
begin
 GetEOLParms(OnlineNo,Password,Url,NetFileDir);
 OpenDialog.Title    := 'History of Efile submissions';
 OpenDialog.InitialDir := NetFileDir;
 //20140130
 OpenDialog.Filter:='All Files|*.*|Displayed Acknowledgement|*.htm|Actual JSON files|*.json';
 OpenDialog.FileName := '*.*';
 If OpenDialog.Execute then
 begin
  FlNm:=OpenDialog.FileName;
  if SameText(ExtractFileExt(flNm), '.json') then
    ShowMessageHTMLFromFile(flNm)
  else
  begin
    h := ShellExecute(Application.Handle,'open',Pchar(''+flNm),Nil,Nil,Sw_Show);
    If h<=32 then ShowMessage('File not found');
  end;
 end;
end;

procedure TMainFormT3_2026.ForumLblClick(Sender: TObject);
begin
VisualTaxForum1Click(Sender);
end;

procedure TMainFormT3_2026.TRLblClick(Sender: TObject);
begin
TrEngineLoadClick(Sender);
end;


procedure TMainFormT3_2026.Lockreturnagaistchanges1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 LockReturn(GetCurrentRetNo);
end;

procedure TMainFormT3_2026.UnlockReturn1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 UnlockReturn(RetNo);
 Ret[RetNo].Locked:=False;
end;

procedure TMainFormT3_2026.SetHorScrollBarInListBox(ListBox: TListBox; MaxWidth: Integer);
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


procedure TMainFormT3_2026.ListView1DblClick(Sender: TObject);
Begin
 OpenItBtnClick(Sender);
end;

procedure TMainFormT3_2026.ListView1KeyPress(Sender: TObject; var Key: Char);
begin
 if (Key = #13) then {Return key}
   ListView1DblClick(Sender);
end;

procedure TMainFormT3_2026.Options2Click(Sender: TObject);
begin

 Application.CreateForm(TOptionsFrmT3_2026,OptionsFrm);
 OptionsFrm.ShowModal;
 OptionsFrm.Free;
end;


procedure TMainFormT3_2026.QuestionMarkLblMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if Button = mbLeft then  { drag only if left button pressed }
 with Sender as TvtLabel do  {treat Sender as ??TFileListBox }
 begin
 end;

end;

procedure TMainFormT3_2026.LicLevel1Click(Sender: TObject);
begin
ChangeLicenseLevel;
end;

procedure TMainFormT3_2026.PrepareDistr1Click(Sender: TObject);
Var Psw:String;
begin
 if not IsDeveloper then exit;
 ShowTimedMsg('Rebuilding properties: dollars, please wait',1000);
 AppT3_2026.PrepareDistribution;
end;


procedure TMainFormT3_2026.EmailTheReturnClick(Sender: TObject);
 Var i,j: integer; FormsToPrint :TstringList;
    Copies,Template,s:String;//RetNo:Integer;
begin
 If ButtonInactive then exit;
 If AllowPrinting(RetNo)=False then exit;
 CalcAll(RetNo);
 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  If not MainForm.WizardPanel.visible then MainForm.AuditOpenBtnClick(Sender);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Not AllowedToFullPrint(RetNo) then begin PdfPrint:=False;exit;end;

 Calc(RetNo,'DIAGNO');
 If Ret[RetNo].CalcStatus = False then CalcAll(RetNo);
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

Procedure TMainFormT3_2026.PrintReturnForEmail(RetNo:Integer;Template:String);
Var i,j: integer; FormsToPrint :TstringList;
    Copies : string; //[1];
    OldPrinterName:String;
begin
  EXIT;
end;

procedure TMainFormT3_2026.OpenItBtnClick(Sender: TObject);
//20170628 Igor >>>
Var
  i: Integer;
  Dir, FlName, Sin: String;
  AListItem: TListItem;
  RetNo: Integer;
begin
  AListItem := ListView1.ItemFocused;
  If AListItem = Nil then
  begin
    ShowTimedMsg('You must select a file first',1200);
    Exit;
  end;
  FlName := AllTrim(AListItem.SubItems[2]);
  Dir := AllTrim(AListItem.SubItems[3]);
  Sin := FlName;
  If FlName = '' then
    exit;
  If IsOkToOpenReturn(Dir, FlName, Sin) = False then
    Exit;
  If Not ReturnFileExists(Dir+'\'+FlName) then //20160415 Igor
  begin
    ShowMessage('File '+Dir+'\'+FlName+' does not exist');
    Exit;
  end;
  Screen.cursor := crHourGlass;
  try
    RetNo := OpenReturn(Dir, FlName, False);
    //20190211 Igor >>>
    ShowReturn(RetNo);
    {If RetNo > 0 then
    begin
      vtChild.CreateNewMDIChild(RetNo, '').HideAllControls;
      try
        LockWindowUpdate(MainForm.Handle);
        MainForm.GuiCommand(gcRetNoChanged);
        CountDiagnostics(RetNo);
        OpenForm(RetNo, 'T3', 0);
        //MainForm.LeftPanel.Visible:=True;
        MainForm.GuiCommand(gcShowLeftPanel);

        If Ret[RetNo].FrmHasData[GetFormNo('T5013SUM')] then
          OpenForm(RetNo, GetFormNo('T5013SUM'), 0);

        OpenUsedForms(RetNo);

        MainForm.FormPaint(Application);
      finally
        vtChild.CreateNewMDIChild(RetNo, '').ShowAllControls;
      end;
    end;}
    //20190211 Igor <<<
  finally
    Screen.Cursor := crDefault;
  end;
//20170628 Igor <<<
end;

procedure TMainFormT3_2026.EMailItBtnClick(Sender: TObject);
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

 SomeList.Clear;  // := TStringList.Create;
 SomeCaption := 'Double click on item 1, 2, 3 or 4';
 SomeList.Add('1. Email the tax return (raw data file) to your own EMail...');
 SomeList.Add('2. Email the tax return (raw data file) to tax return Reviewer...');
 SomeList.Add('3. Email the tax return (raw data file) to VisualTax support...');
 SomeList.Add('4. Email the tax return (raw data file) to any Email address...');
 SomeList.Add('________________________________________________________________');
 SomeList.Add('5. EMail the tax return (Printout only) to any Email address...');
 SomeList.Add('   See also: Print|Email current form...(after opening the return)');
  SelectedString := PopSomeList(SomeList,SomeCaption);
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

function TMainFormT3_2026.SendMAPIMail(const Subject, Body, FileName,SenderName, SenderEMail,RecipientName, RecipientEMail: string): Integer;
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
      lpszSubject := PAnsiChar(''+Subject);   //20150805 Igor

    if (Body <> '') then
      lpszNoteText := PAnsiChar(''+Body);     //20150805 Igor

    if (SenderEmail <> '') then
    begin
      lpSender.ulRecipClass := MAPI_ORIG;
      if (SenderName = '') then
        lpSender.lpszName := PAnsiChar(''+SenderEMail) //20150805 Igor
      else
        lpSender.lpszName := PAnsiChar(''+SenderName); //20150805 Igor
      lpSender.lpszAddress := PAnsiChar(''+SenderEmail);  //20150805 Igor
      lpSender.ulReserved := 0;
      lpSender.ulEIDSize := 0;
      lpSender.lpEntryID := nil;
      lpOriginator := @lpSender;
    end;

    if (RecipientEmail <> '') then
    begin
      lpRecipient.ulRecipClass := MAPI_TO;
      if (RecipientName = '') then
        lpRecipient.lpszName := PAnsiChar(''+RecipientEMail) //20150805 Igor
      else
        lpRecipient.lpszName := PAnsiChar(''+RecipientName); //20150805 Igor
      lpRecipient.lpszAddress := PAnsiChar(''+RecipientEmail); //20150805 Igor
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
      FileAttach.lpszPathName := PAnsiChar(''+FileName); //20150805 Igor

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


procedure TMainFormT3_2026.TUTORIALS1Click(Sender: TObject);
Var i:Integer;Url:String;TempList,TempList1:TStringList; //it loads the helpkeyw in a list
    PrevNo:String;
begin
  MainForm.GuiCommand(gcTutorials);
end;

procedure TMainFormT3_2026.HelpIndexBtnClick(Sender: TObject);
begin
 ShowHelp(AppT3_2026.ModuleHelpFile, 'HELP_CONTENTS', True); //20161220 Igor
end;

procedure TMainFormT3_2026.Backupthetaxdata1Click(Sender: TObject);
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

procedure TMainFormT3_2026.Restoredatafrombackup1Click(Sender: TObject);
Var i:Integer;LastBackUp,Dir:String;  TempList:TStringList; DoneOk:Boolean;
  ClickedOK: Boolean;  NewDir: string;
begin
 If OptRec.BackUpDir='' then
 begin
  ShowMessage('Please enter the backup directory in Configure | General Options | Data directories');
  Exit;
 end;
 Application.CreateForm(TRestoreFrmT3_2026,RestoreFrm);
 RestoreFrm.ShowModal;
 RestoreFrm.Free;
end;

procedure TMainFormT3_2026.CopyAReturnBtnClick(Sender: TObject);
Var i,ThisResult:Integer;Dir,FlName,Sin:String;
 AListItem:TListItem;
 RetNo:Integer;
begin
  if CheckIsCloud then Exit; //20180503 Igor
  AListItem:=ListView1.ItemFocused;
  If AListItem = Nil then
  begin
   ShowTimedMsg('You must select a file first',1200);
   Exit;
  end;
  SomeFile:=AllTrim(AListItem.SubItems[2]);   //FlName
  SomeString:=AllTrim(AListItem.SubItems[3]); //from dir
  SomeCaption:=AllTrim(AListItem.Caption); //return name
  Application.CreateForm(TCopyMoveFrmT3_2026,CopyMoveFrm);
  CopyMoveFrm.ShowModal;
  CopyMoveFrm.Free;
  If SomeResult=True then
    ShowMessage('Done')
  Else
   ShowMessage('Failed!');
  ShowMostRecentReturns; //updates the main menu
end;

procedure TMainFormT3_2026.Label4Click(Sender: TObject);
begin
TUTORIALS1Click(Sender);
end;

procedure TMainFormT3_2026.ShowBarCodedata1Click(Sender: TObject);
Var FlNm:String;
begin
  Flnm :=Appdir+'\'+'BarCodeData.Txt';
  If FileExists(FlNm) then
  begin
    PopSomeFile(FlNm,SomeCaption);
 end;
end;


procedure TMainFormT3_2026.ToolButton1Click(Sender: TObject);
begin
  FileNewItem_Click(Sender);
end;

procedure TMainFormT3_2026.NewBtnToolBarClick(Sender: TObject);
begin
  FileNewItem_Click(Sender);
end;

procedure TMainFormT3_2026.OpenBtnToolBarClick(Sender: TObject);
begin
 FileOpenItemClick(Application);
end;

procedure TMainFormT3_2026.CloseBtnToolBarClick(Sender: TObject);
begin
  FileCloseItemClick(Sender);
end;

procedure TMainFormT3_2026.SaveBtnToolBarClick(Sender: TObject);
begin
 If ButtonInactive then exit;
 FileSaveAsItemClick(Sender);
end;


Procedure TMainFormT3_2026.GetFormsToPrint
 (RetNo:integer;Template:string;FormsToPrint:Tstrings;FrmType:String);
var i,j,FNo:integer;Copies :string; //[1];
  TemplCopies: TTemplCopies;
begin
  If not FileExists(AppDir+'\'+Template) then
  begin
   ShowMessage('Print Template: '+AppDir+'\'+Template+
             chr(13)+'does not exist');
   exit;
  end;
  TemplCopies := TTemplCopies.Create(RetNo, AppDir, Template);

  For i:=0 to FList.Count-1 do {run thru all forms available}
  begin
    FRec := FList.Items[i];
    FNo :=Frec.FormNo;
    if FNo = 0 then continue;

    If (Ret[RetNo].FrmHasData[FNo])
    and (Frec.FormName <>'ALETTER') //and not ALETTER
    and (TemplCopies.IsExactlyInList(Frec.FormName)>-1) {and it is in template}
    then
    begin
      If FrmType='T3' then
      begin
       If (Frec.FormType = FrmType)
       or (Frec.FormType = 'TP')
       or (Frec.FormName = 'T3SUM') then FormsToPrint.Add(Frec.FormInstName);
      end

      Else If FrmType='PA' then
      begin
       If (Frec.FormType = FrmType) then
       begin
         //If ((Frec.FormName = 'POTHINFO')
         if (Frec.FormName = 'T5013')
         or (Frec.FormName = 'PS50')    //20120324
         then
         // excluded - do not print here
         else
          FormsToPrint.Add(Frec.FormInstName);
       end
      end

      else
      begin
      If Frec.FormType = FrmType then FormsToPrint.Add(Frec.FormInstName);
      end;
    end;
  end; //i
  {match and attach number of copies}
  TemplCopies.FinishPrintList(FormsToPrint);
  TemplCopies.Free;
end;


function TMainFormT3_2026.GetZoomStr: String; //20180117 Igor
begin
  Result := ZoomPercentLbl.Caption;
end;

procedure TMainFormT3_2026.SwapBtnClick(Sender: TObject);
begin
SwapReturns1Click(Sender);
end;

procedure TMainFormT3_2026.QuickFindBtnKeyPress(Sender: TObject; var Key: Char); //20170418 Igor
begin
  //20180117 Igor >>>
  If key = #13 then
    actFindFormExecute(nil);
  //20180117 Igor <<<
end;

procedure TMainFormT3_2026.QuickStarterGuide1Click(Sender: TObject);
begin
 ShowHelp(AppT3_2026.ModuleHelpFile, 'Quick_Starter_Guide', True); //20161220 Igor
end;

procedure TMainFormT3_2026.PrintMailingLabelcurrentclient1Click(Sender: TObject);
Var Line1,Line2,Line3,Line4,Line5:String;
  LabelPosX, LabelPosY : Integer;
  TopMargin,LeftMargin,LabelHeight, LabelWidth, VertIncr, HorizLabelGap:Integer;
begin
end;

procedure TMainFormT3_2026.QuickStartLblClick(Sender: TObject);
begin
QuickStarterGuide1Click(Sender);
end;

procedure TMainFormT3_2026.Importfromlastyear1Click(Sender: TObject);
begin
  //20160226 Igor >>>>>>
(* //20170227 Igor
  If getCurrentRetNo > 0 then
  begin
    ShowMessage('Please close all returns first');
    Exit;
  end;*)

  If OptRec.Dir_LastYr='' then
  begin
    ShowMessage('You should first enter the data directory you used last year'
                +Chr(13)+'See Configure | General Options | Data Directories');
    Exit;
  end;
  //20170226 Igor >>>
  If not FileExists(OptRec.Dir_LastYr+'\' + ClientsDBLite) and
    not FileExists(OptRec.Dir_LastYr+'\' + 'Clients_T3.db') then //2018
    //and not FileExists(OptRec.Dir_LastYr+'\' + ClientsTable_dbf)
  begin
    ShowMessage('Last Year'+Chr(39)+'s directory does not have a VisualTax Client data base'
                  +Chr(13)+'See Configure | General Options | Data Directories');
    Exit;
  end;
  (*
  If not FileExists(OptRec.Dir_LastYr+'\' + ClientsDBLite) then // 20150909 Igor
  begin
    if FileExists(OptRec.Dir_LastYr+'\' + ClientsTable_dbf) then
    Begin
      if MessageDlg('Rollover client database have old format.'+#13#10+
                    'Create a copy of the database in the new format?',
                    mtConfirmation,[mbYes,mbNo],0) <> mrYes then exit;
      if not ConvertOneTable(OptRec.Dir_LastYr+'\' + ClientsTable_dbf,
                             OptRec.Dir_LastYr+'\' + ClientsDBLite,
                             OptRec.SQLLitePassword.CurrentPassword) then exit;
    End
    else
    Begin
      ShowMessage('Last Year'+Chr(39)+'s directory does not have a VisualTax Client data base'
                  +Chr(13)+'See Configure | General Options | Data Directories');
      Exit;
    End;
  end; *)
  //20170226 Igor <<<
  //20160226 Igor <<<<<<<

  Application.CreateForm(TImportT3_2026,Import);
  Import.ShowModal;
  Import.Free;
end;


procedure TMainFormT3_2026.ImportfromProduction1Click(Sender: TObject); //20160305 Igor
begin
  If getCurrentRetNo > 0 then
  begin
    ShowMessage('Please close all returns first');
    Exit;
  end;

  If OptRec.Dir_DBFData = '' then
  begin
    ShowMessage('You should first enter the Data Directory of the T3-2017 Production data'
                +Chr(13)+'See Configure | General Options | Data Directories');
    Exit;
  end;
  MainForm.GuiCommand(gcHideLastYear); //20160311 Igor
  ExecuteForm(TImportDBFT3_2026);

end;

procedure TMainFormT3_2026.T3coveringletter1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
 If AllowPrinting(RetNo)=False then exit;
 CalcAll(RetNo);
 SomeLetterName:='T3Letter.RTF';
 OpenForm(GetCurrentRetNo,GetFormNo('ALETTER'),0);
end;

procedure TMainFormT3_2026.TrustReturn1Click(Sender: TObject);
Var i,j: integer; FormsToPrint :TstringList;
    Copies,Template :string;
begin
 If ButtonInactive then exit;
 CalcAll(RetNo);
 If AllowPrinting(RetNo)=False then exit;
 Template:=GetPrintTemplate;

 PrintAReturn('T3',Template); //PrintAReturn('T3',Template);
end;

procedure TMainFormT3_2026.T3SupplementarySlips1Click(Sender: TObject);
var
//f:TPrintSelectedT3Slips;
FormName, FInst, FNonInst:String;
i, FNo:integer;
selectedT3SlipsList:TStringList;
begin
  if ButtonInactive then exit;
 If AllowPrinting(RetNo)=False then exit;

 FormName := 'T3SUPL#';
 FNonInst:= ExtractNonInstFormName(FormName);

 //add info
 SomeList.Clear;  // := TStringList.Create;
 Somelist.Add(PaddR('Select all',10));
 for i :=0 to (FList.Count - 1) do
 begin
  FRec := FList.Items[i];
  If FNonInst = Frec.FormName then
  begin
   FNo:=Frec.FormNo;
   FInst:=Frec.FormInst;
   If Ret[RetNo].FrmHasData[FNo] then
   Begin
    If (LeftStr(FormName,7)='T3SUPL#')
    and (UpperCase(FetchElmFNo(RetNo,FNo,41)) = 'Y')   //20120416
    then
        Somelist.Add(PaddR(FRec.FormInstName,10)+' '+FetchElmFNo(RetNo,FNo,26))
   end; //found the form
  end;
 end;  //i

 CalcAll(RetNo);
 SomeCaption := 'T3 Slips Printing';

 ExecuteForm(TPrintSelectedT3SlipsT3_2026);
end;

procedure TMainFormT3_2026.T3WebServicesErrorsClick(Sender: TObject);
begin
ShowPdf(AppDir,'T3EFILE Web Service Messages.pdf');   //20230225
end;

procedure TMainFormT3_2026.Partnershipcoveringletter1Click(Sender: TObject);
begin
 If ButtonInactive then exit;
 CalcAll(RetNo);
 If AllowPrinting(RetNo)=False then exit;
 SomeLetterName:='T5013Letter.RTF';
 OpenForm(GetCurrentRetNo,GetFormNo('ALETTER'),0);
 //PrintRichLetter(RetNo,'Tt5013Letter.Rtf');
end;

procedure TMainFormT3_2026.Partnershipreturn1Click(Sender: TObject);
Var i,j: integer; FormsToPrint :TstringList;
    Copies,Template :string;

begin
 If ButtonInactive then exit;
 CalcAll(RetNo);
 If AllowPrinting(RetNo)=False then exit;

 Template:=GetPrintTemplate;
 PrintAReturn('PA',Template);
end;


procedure TMainFormT3_2026.PrintAReturn(WhichFormType:String;Template:String);
Var i,j: integer; FormsToPrint :TstringList;
    Copies : string; //[1]; //Template :string; //[30];

begin
 If ButtonInactive then exit;
 LetterType := 'Cover';

 Screen.Cursor := crHourGlass;
 If Ret[RetNo].CalcStatus = False then CalcAll(RetNo);
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
 FormsToPrint := TstringList.Create;
 GetFormsToPrint(RetNo,Template,FormsToPrint,WhichFormType);
 If FormsToPrint.Count =0 then
    begin
    ShowMessage('Selected template has no forms for printing');
    FormsToPrint.Free;
    exit;
  end;

 If PrintDialogItem.Execute then
   PrintReturn(RetNo,FormsToPrint,Ret[RetNo].SourceDataDir,Ret[RetNo].SourceFlName);
 FormsToPrint.Free;
end;


procedure TMainFormT3_2026.T5013Slips1Click(Sender: TObject);
Var SlipToPrint,CopyId:String;j,NumberOfSlips:Integer;
begin
  If ButtonInactive then exit;
  If AllowPrinting(RetNo)=False then exit;
  CalcAll(RetNo);
  Application.CreateForm(TPrT5013T3_2026,PrT5013);
  PrT5013.ShowModal;
  PrT5013.Free;
end;



procedure TMainFormT3_2026.T2202AEducationSlips1Click(Sender: TObject);
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
  SomeList.Clear; // := TStringList.Create;
  SomeCaption := 'Print T2202A Slips';
  SomeList.Add('Student - Copy 1');
  SomeList.Add('Designated individual - Copy 2');
  SomeList.Add('Educational institution - Copy 3');
  //SomeList.Add('All Copies');
  SelectedString := PopSomeList(SomeList,SomeCaption);

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

procedure TMainFormT3_2026.CharityReturn1Click(Sender: TObject);
Var Template:String;
begin
 If ButtonInactive then exit;
 If AllowPrinting(RetNo)=False then exit;
 Template:=GetPrintTemplate;
 PrintAReturn('CH',Template);
end;

procedure TMainFormT3_2026.CCRAT3GuideT4013PDFformat1Click(Sender: TObject);
begin
  ShowPdf(AppDir,'T4013-24e.pdf');   //20231129
end;


(*
procedure TMainFormT3_2026.CCRAT5013PartnershipGuideT4068PDFformat1Click(
  Sender: TObject);
begin
 ShowPdf(AppDir,'T4068-15e.pdf');
end;
*)

Procedure TMainFormT3_2026.PrintStudentT2202(RetNo:Integer;CopyType:Integer);
Var i,j,WSFNo,FNo,DestFNo,Cnt,SlipsOnPage : integer; FromForm,DestForm:string; //[12];
    PrintedSw :Boolean;
begin
  Cnt:=CountT2202Slips(RetNo);
  DestForm := 'T2202S1';  //single page - re-used
  DestFNo := GetFormNo(DestForm);
  If DestFNo=0 then exit;
  If Ret[RetNo].Frm[DestFno].Count =0 then InitFormData(RetNo,DestFNo);
  For i:=0 to Cnt-1 do
  begin
     WsFNo:=GetFormNo('T2202WS#'+AllTrim(IntToStr(i+1)));
     If Ret[RetNo].FrmHasData[WsFNo] then
     begin
      For j:=1 to 50 do StoreElm(RetNo,DestFNo,j,''); //clear it
      //copy data
      For j:=1 to 50 do StoreElm(RetNo,DestFNo,j,FetchElmFNo(RetNo,WsFNo,j));
      PrintForm(RetNo,DestForm,1,'');
     end; //has data
  end; //end i
end;

Procedure TMainFormT3_2026.PrintDesignatedT2202(RetNo:Integer;CopyType:Integer);
Var i,j,WSFNo,FNo,DestFNo,Cnt,SlipsOnPage : integer; FromForm,DestForm:string; //[12];
    PrintedSw :Boolean;
begin
  Cnt:=CountT2202Slips(RetNo);
  DestForm := 'T2202S2';  //single page - re-used
  DestFNo := GetFormNo(DestForm);
  If DestFNo=0 then exit;
  If Ret[RetNo].Frm[DestFno].Count =0 then InitFormData(RetNo,DestFNo);

  For i:=0 to Cnt-1 do
  begin
     WsFNo:=GetFormNo('T2202WS#'+AllTrim(IntToStr(i+1)));
     If Ret[RetNo].FrmHasData[WsFNo] then
     begin
      For j:=1 to 56 do StoreElm(RetNo,DestFNo,j,''); //clear it
      //copy data
      For j:=1 to 56 do StoreElm(RetNo,DestFNo,j,FetchElmFNo(RetNo,WsFNo,j));
      PrintForm(RetNo,DestForm,1,'');
     end; //has data
  end; //end i
end;

Procedure TMainFormT3_2026.PrintEducationalT2202(RetNo:Integer;CopyType:Integer);
Var i,j,WSFNo,FNo,DestFNo,Cnt,SlipsOnPage : integer; FromForm,DestForm:string; //[12];
    PrintedSw :Boolean;
begin
  Cnt:=CountT2202Slips(RetNo);
  DestForm := 'T2202S3';  //single page - re-used
  DestFNo := GetFormNo(DestForm);
  If DestFNo=0 then exit;
  If Ret[RetNo].Frm[DestFno].Count =0 then InitFormData(RetNo,DestFNo);

  For j:=1 to 150 do StoreElm(RetNo,DestFNo,j,''); //clear it all

  i:=0;
  Repeat  //number of ws-slips
  //begin
     WsFNo:=GetFormNo('T2202WS#'+AllTrim(IntToStr(i+1)));
     If Ret[RetNo].FrmHasData[WsFNo] then
     begin
      //clear and copy  top skip
      For j:=1 to 50 do StoreElm(RetNo,DestFNo,j,FetchElmFNo(RetNo,WsFNo,j));
     end;

     WsFNo:=GetFormNo('T2202WS#'+AllTrim(IntToStr(i+2)));
     If Ret[RetNo].FrmHasData[WsFNo] then
     begin
      //clear and copy  top skip
      For j:=51 to 100 do StoreElm(RetNo,DestFNo,j,''); //clear it
      For j:=51 to 100 do StoreElm(RetNo,DestFNo,j,FetchElmFNo(RetNo,WsFNo,j-50));
     end;

     WsFNo:=GetFormNo('T2202WS#'+AllTrim(IntToStr(i+3)));
     If Ret[RetNo].FrmHasData[WsFNo] then
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

Procedure TMainFormT3_2026.PrintT5013Slip(RetNo:Integer;SlipInstanceToPrint:String;CopyId:String);
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
   //If GetT5013SlipType(RetNo)='T5013' then StartPrintForm(Retno,'T5013I',1)
   end;
   {copy 4}
   If (CopyId ='4') or (UpperCase(CopyId) = 'ALL') then
   begin
    StoreElm(RetNo,FNo,3,'For Partnership records');
    StoreElm(RetNo,FNo,6,'4');
    StartPrintForm(Retno,FName,1);
   end;
end;


procedure TMainFormT3_2026.ImportBtnClick(Sender: TObject);
begin
Importfromlastyear1Click(Sender);
end;

procedure TMainFormT3_2026.RolloverfromTacCycle1Click(Sender: TObject); //20170712 Igor
begin
  RollOverFromTaxCycle(AppT3_2026, '2017T3;2017T5013');
end;

procedure TMainFormT3_2026.RollOvrerLblClick(Sender: TObject);
begin
Importfromlastyear1Click(Sender);
end;

procedure TMainFormT3_2026.NAICSCodes1Click(Sender: TObject);
begin
Application.CreateForm(TSICT3_2026,SIC);
SIC.ShowModal;
SIC.Free;
end;

procedure TMainFormT3_2026.N2008TaxRatesanddraftlegislation1Click(
  Sender: TObject);
begin
  ShowPdf(AppDir,'2008-TaxRates.pdf');
end;

procedure TMainFormT3_2026.CurrentFormAllInstances1Click(Sender: TObject);
Var i:Integer;
    //20180503 Igor >>>
    PDFFullfileName: string;
    PDF: TvtPDFPrinter;
    //20180503 Igor <<<
begin
 FastPrint := False;
 If ButtonInactive then exit;
 CountDiagnostics(RetNo);
 If Ret[RetNo].MandatoryErrorCount+Ret[RetNo].SeriousErrorCount>0 then
 begin
  If not MainForm.WizardPanel.visible then MainForm.AuditOpenBtnClick(Application);
  ShowMessage('Return has errors. Please fix before printing/filing');
 end;

 If Not AllowedToFormPrint(RetNo,FormName) then exit;
 //20180503 Igor >>>
  if CheckIsCloud(true) then //20180503 Igor
  begin
    PDFFullfileName := TPath.Combine(AppDir, 'tmp' + TPath.DirectorySeparatorChar + TPath.GetGUIDFileName + '.pdf');
    if not ForceDirectories(ExtractFileDir(PDFFullfileName)) then
    begin
      MessageDlg('Can not create temp folder', mtError, [mbOk], 0);
      Exit;
    end;
    PDF := TvtPDFPrinter.Create(AppT3_2026);
    try
      for i := 0 to (FList.Count - 1) do
      begin
        FRec := FList.Items[i];
        if Frec.FormName = ExtractNonInstFormName(FormName) then
          PDF.PrintForm(RetNo, Frec.FormInstName, 99, T3_2026Print.AfterReadComponentForPrint,
              T3_2026Print.PrintEditBox, nil, nil, nil);
      end;
      PDF.SaveToFile(PDFFullfileName, false);
      OpenAnyFile(ExtractFileDir(PdfFullfileName), ExtractFileName(PdfFullfileName));
    finally
      PDF.free;
    end;
  end
  else
  begin
   If Not PrintDialogItem.Execute then exit;

   for i :=0 to (FList.Count - 1) do
   begin
      FRec := FList.Items[i];
      If Frec.FormName =ExtractNonInstFormName(FormName) then
      begin
        If Ret[RetNo].FrmHasData[Frec.FormNo] = true then   //20090422
         StartPrintForm(Retno,Frec.FormInstName,99);
      end;
   end;
   if Printer.Printing then //20160905 Igor
     Printer.EndDoc;        //20160905 Igor
 end;
 //20180503 Igor <<<
end;


procedure TMainFormT3_2026.INTERNETFiling1Click(Sender: TObject);
begin
 //20260323
 If (LicenseLevel = llPower = false)
 and (IsEnterpriseVersion = false)
 then
 begin
  ShowMessage('Internet Filing of slips is available only in the T3-Power / Or Enterprise version'); //20260323
  Exit;
 end;
 If ButtonInactive then exit;

 //20180311
 Ret[RetNo].SeriousErrorCount:=0;
 CountDiagnostics(RetNo);

 If Ret[RetNo].SeriousErrorCount>0 then
 begin
  ShowMessage('Please Fix Errors before Efiling');
  Exit;
 end;

 If ValidatePreparerInfo = false then Exit;  //20180317
 //20180317
 if OptRec.Prp_Email=''  then
 begin
   ShowMessage('Please Enter an Email Address in Configure -> General Options -> Preparer');
   Exit;
 end;


 Application.CreateForm(TInternetFrmT3_2026,InternetFrm);
 InternetFrm.ShowModal;
 InternetFrm.Free;
end;


procedure TMainFormT3_2026.KnownIssues1Click(Sender: TObject);
begin
 ConnectToWeb('https://www.visualtax.com/tfknownissues.php');
end;

procedure TMainFormT3_2026.KnownissuesLblClick(Sender: TObject);
begin
KnownIssues1Click(Sender);
end;

procedure TMainFormT3_2026.mnSelAppId(Sender: TObject);
begin
  ShowSplash;
end;

procedure TMainFormT3_2026.Notepad1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  OpenForm(RetNo,GetFormNo('NPAD#1'),0);
end;

procedure TMainFormT3_2026.Notepadwithamounts1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  OpenForm(RetNo,GetFormNo('NPADC#1'),0);
end;

procedure TMainFormT3_2026.PrivateNotepad1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  OpenForm(RetNo,GetFormNo('PRIVAT#1'),0);
end;

// --------- Field Popup ----------------------

var //initialized by NotEditCommand
  SenderClass: string;
  MyEditBox: TvtEdit;
  MyScrollBox: TvtScrollBox;
  FieldId: integer;
  //FormName: string;

function TMainFormT3_2026.NotEditCommand: boolean;
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
  //FormNameNo(RetNo, MyScrollBox.FormName); //set global vars
  FName := MyScrollBox.FormName;
  MyChild := RetList[RetNo].MyChild;
end;

procedure TMainFormT3_2026.RemovecurrentfieldoverrideClick(Sender: TObject);
begin
  if NotEditCommand then exit;
 //RetNo:=GetCurrentRetNo;
 If (RetNo >0) and (FormNo >0) and (FieldId >0) then
  begin
   RemoveFieldOverride(RetNo,FormNo,FieldId);
   Calc(RetNo,FormName);
   CalcAll(RetNo);
  end;
end;

procedure TMainFormT3_2026.Lockamountoncurrentfield1Click(Sender: TObject);
begin
  if NotEditCommand then exit;
  //RetNo:=GetCurrentRetNo;
  If (RetNo >0) and (FormNo >0) and (FieldId >0) then
     SetFieldOverride(RetNo,FormNo,FieldId);
end;

procedure TMainFormT3_2026.ReviewBtnClick(Sender: TObject);
begin
  if NotEditCommand then exit;
  MyScrollBox.ToggleReview(MyEditBox);
end;

procedure TMainFormT3_2026.AddtoDataDictionaryforclientletters1Click(
  Sender: TObject);
begin
  if NotEditCommand then exit;
  InsertKeyWToDataDict(FormName,MyEditBox);
end;

procedure TMainFormT3_2026.DeleteRow1Click(Sender: TObject);
begin
  if NotEditCommand then exit;
  DeleteDynamicRow(MyScrollBox,FieldId); //(RetNo,FormName,FieldId,myScrollBox);   //data only
{
  ShowDynamicData(RetNo,FormName,MyScrollBox);
  OpenForm(RetNo,FormNo,0); //does not add anything //20120108    end;
}
end;

procedure TMainFormT3_2026.AddRow1Click(Sender: TObject);
begin
  if NotEditCommand then exit;
  AddDynamicRow(MyScrollBox,FieldId); //(RetNo,FormName,FieldId,myScrollBox);   //data only
end;

procedure TMainFormT3_2026.AttachNote1Click(Sender: TObject);
var
    RefFormName:String;RefFieldId:String;
    FNo:Integer;Cinst:Integer;
begin
  if NotEditCommand then exit;
     RefFormName:=FormName;
     RefFieldId:=IntToStr(FieldId);
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

procedure TMainFormT3_2026.AttachAddingTape1Click(Sender: TObject);
var
    RefFormName:String;RefFieldId:String;
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
       UserMsg('Cannot create more adding tapes');
     end; {not existing}
end;

procedure TMainFormT3_2026.TRVisualTaxResearchWebbased1Click(
  Sender: TObject);
var
  HelpTopic:string;
begin
  if NotEditCommand then exit;
     HelpTopic:=GetTrTopicFromLineRef(FormName,FieldId);
     If Length(HelpTopic)>3 then  //only lines 000 to 999
       HelpTopic:=''
     else
       HelpTopic:='Line '+HelpTopic;
     LinkToTr(HelpTopic);
end;

procedure TMainFormT3_2026.FormSections1Click(Sender: TObject);
begin
  if ButtonInactive then exit;
  MyChild.GoToSection('');
end;

procedure TMainFormT3_2026.SetResetOverride1Click(Sender: TObject);
begin
  if NotEditCommand then exit;
  MyScrollBox.ToggleOverride(MyEditBox);
end;

procedure TMainFormT3_2026.PrintAllForms1Click(Sender: TObject);
Var I:integer; Psw:String; //20130325
begin
 If ButtonInactive then exit;
 if not IsDeveloperLogin then exit; // Psw:= InputBox('Input Box', '', '');

 ShowFieldIdSw := True;

 If PrintDialogItem.Execute then
 begin
   for i :=0 to (FList.Count - 1) do
    begin
      FRec := FList.Items[i];
      If Frec.FormNo > 0 then
      begin
      If FRec.FormInst < '#2' then
       {ShowMessage(Frec^.FormName+Frec^.FormInst);}
        PrintForm(RetNo,Frec.FormInstName,99,'');
      end;
    end;
 end;
end;

procedure TMainFormT3_2026.DeveloperOnly1Click(Sender: TObject); //20190415 Igor
begin
  //20180121 Igor >>>
  if GetDeveloperPwd then
  begin
    DeveloperOnly1.OnClick := nil;
  end;
  //20180121 Igor <<<
end;

procedure TMainFormT3_2026.PrintReturnBalances1Click(Sender: TObject);
var
  chooseUseExpanedListBal: integer;
begin
  if RetInMem > 0 then
  begin
    ShowMessage('Please close all returns first');
    exit;
  end;

  try

    //jz//20250205 - show one with more functionality when in debug mode,
    //jz//20250205 - $IFDEF DEBUG used so it only prompts for expanded listbal in DEBUG
    //$IFDEF DEBUG - doesnt seem to work --> find another way to show when debugging
    //jz//20260206 - add T3 listbal jz version
    if inJZtestmode then
    begin
      //chooseUseExpanedListBal := MessageDlg('Do you want to use expanded listbal?', mtConfirmation, [mbYes, mbNo], 1); //20251225
      //if chooseUseExpanedListBal = mrYes  then
      begin
          Application.CreateForm(TListBalT3jz_2025,ListBal);
          //ListBal.ShowModal;
          //ListBal.Free;
          //exit;
      end;
    end //$ENDIF
    else
      Application.CreateForm(TListBalT3_2026, ListBal);
  finally
    ListBal.ShowModal;
    ListBal.Free;
  end;
end;

end.

