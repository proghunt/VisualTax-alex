unit T1_2026;

interface

{$R 'Fonts\Fonts.res'} //20180307 Igor

uses Classes,Forms,Controls,Windows,ComCtrls,Menus,ExtCtrls,vtMulti,
  vtForm,vtChild,vtMain,T1_2026Declare,T1_2026common,T1_2026common2,
  T1_2026Features,T1_2026t1rtns,T1_2026main,Dialogs,//20200317
  DB,uADCompClient, vtRichText, IOUtils,// 20171031 Igor
  IniFiles, uEncrypt, //20201026 Igor
  RxRichEd, //20160819 Igor (It must be the last)
  T1_2026CalcSers; //20240715 Igor

const //update every year
  ScanId1 = 'S1-2026'; //scan AppId //20280827 Alex
  ArchiveId1 = 'A1-2026'; //scan AppId //20280827 Alex

  T1F2025 = 56; //20280827 Alex
  S1F2025 = 62; //20280827 Alex
  A1F2025 = 85; //20280827 Alex

(* lookup license data:
  step up until Level=llNone.
  Last member must be Unlicensed
*)
  T1StdCaps = [lcMultiData, lcMultiDrive, lcEfile];

  //20190705 Igor >>>
  { T1-2023 }   //20150623
  PgmLicenses: array[0..10] of RPgmLicenseData = (  //20230611 Igor
  //T1
    //20280827 Alex >>>
    (Name:'T1 Demo';        Id:'T100'; Factor:22; Level:llDemo;  //20150223 Igor //20240905 Igor
      Caps:T1StdCaps),  // + [lcDemo, lcLetter]),
    (Name:'T1 NetFile';     Id:'T101'; Factor:23; Level:llHome;  //20150223 Igor //20240905 Igor
      Caps:T1StdCaps + [lcSuperAudit]; //demo???
      Caption:'Home use - Netfile Version'),
    (Name:'T1 Limited';     Id:'T102'; Factor:24; Level:llLimited;  //20150223 Igor //20240905 Igor
      Caps:T1StdCaps - [lcMultiData, lcEFile] + [lcSuperAudit]),
    (Name:'T1 Limited Efile';Id:'T103'; Factor:25; Level:llLimEfile;  //20150223 Igor //20240905 Igor
      Caps:T1StdCaps + [lcSuperAudit]),
    (Name:'T1 Standard';    Id:'T104'; Factor:26; Level:llStd;  //20150223 Igor //20240905 Igor
      Caps:T1StdCaps - [lcMultiDrive] + [lcSuperAudit]),
    (Name:'T1 Power';       Id:'T105'; Factor:27; Level:llPower;  //20150223 Igor //20240905 Igor
      Caps:T1StdCaps + [lcLetter]+ [lcSuperAudit]),  //20170208 Igor
    (Name:'T1 MultiOffice'; Id:'T106'; Factor:29; Level:llMulti;  //20150223 Igor //20240905 Igor
      Caps:T1StdCaps + [lcLetter]+ [lcSuperAudit]),  //20170208 Igor
    (Name:'T1 Enterprise'; Id:'T107'; Factor:30; Level:llEnterprise; //20240905 Igor
      Caps:T1StdCaps + [lcLetter]+ [lcSuperAudit]),
  //scan license
    (Name:'S1 Standard';    Id:'S101'; Factor:81; Level:llStd),  //20150223 Igor //20240905 Igor
  //dummy for invalid license
    (Name:'A1 Standard';    Id:'A101'; Factor:83; Level:llStd), //20241024 Igor
    (Name:'Unlicensed'; Id:''; Factor:0; Level:llNone; Caps:[])
    //20280827 Alex <<<
  );
  //20190705 Igor <<<

{--------------- Data storage definition---------}
type
  TFListT1 = class(TFList)
  protected
    function LoadFromTable(Table1: TDataSet): TFRec; override;
  end;

type
  //ARetData    = Record
  TRetT1_2026 = class(TRetData)
  private
//    FIsLastYearRetNo: Boolean;
    FLastYearRetNo: Integer;
//    procedure SetIsLastYearRetNo(const Value: Boolean);
  public
  {inherited
   AuditRec     :Array of TAuditRec;
   Changed      : boolean;
   Frm         : Array[0..FormsLimit] of TStringList;
   FrmHasData  : Array[0..FormsLimit] of boolean;
   IsTaxPlan    : Boolean;
   Locked       : Boolean;
   Notes       : string; //[80];
   Province    : string; //[2];
  // AuditList   : TStringList;  //20100701
   CalcStatus   : Boolean;
   Saved        : boolean; - dropped
   Dyn         : Array [0..FormsLimit] of Array[1..MaxDynamicArraysPerForm] of TStringList;  //20111231
   DynamicFormParameters: Array of TDynamicFormParameters; //20111231
   PrpStatus   : string; //[2];
  }
   LastYearSin  : string; //[9];
   LastYearFirstName  : string; //[20];
   LastYearLastName   : string; //[35];
   //LastYearData : Boolean;  //true only in last year's return
   CouplingSw   : Boolean;
   DataVersion  : string; //[5];
   //LastYearRetNo:Integer; 20160302 Igor
   AutoOptimize : Boolean;
   MarStatus    : Word;
   Rc359Rec     :Array of TRc359Rec;
   //TapesList   : TSingleStringList; //20220121 Igor
   PreSelForms : TSingleStringList;
   OpenedForms : TSingleStringList;
   PreSelSw    : Boolean;
   PreSelNdx   : Word;
   PrvTaxBfrT2036 :Real;
   Age         : Word;
   CppMonths   : Word;
   PartYear    : Real;
   Deceased    : Boolean;
   Bankrupt    : Word; {0=no bankruptcy, 1-pre 2=Post 3=trustee}
   Balance     : Real;
   //RichFrm     : Array[0..FormsLimit] of TStringList;
  // CletterRichEdit : TRichEdit;
  { from ClienTtable}
   EFStatus    : string; //[2];
   RTuFile     : string; //[12];
   AckFile     : string; //[12];
   {coupling info}
   {CouplingSw   : Boolean;}
   CplOptions   : Boolean;
   CplGst       :Boolean;
   CplMedical   :Boolean;
   CplDependants:Boolean;
   CplPrvCr     :Boolean;
   CplDon       :Boolean;
   CplGstReb    :Boolean;
   CplPolit     :Boolean;

   T4Gross,T4Don,T4Union,T4Commissions,T4PAdj,T4Rpp,
   T4FreeLoan,T4StockOptions,T4Tax,T4UIEarnings,
   T4CppEarnings, T4UIPremium,T4CPPPremium,T4QppPremium,
   T4NorthA, T4NorthB, T4Indian : real;
   T4UiWeeks : integer;T4PastRPPW :real;T4PastRPPWNot :real;

   T4AOthInc,T4APens,T4ARPP,T4APAdj,T4AOthEmpl,T4ADon,T4ATax,
   T4ANorthA, T4ANorthB : real;
   T4APastRppW,T4APastRppWNot,T4AResp,T4ARespEduc,T4AResp22,T4AAnnuity,T4aRDSP, T4ACovidIncome: real;    //20210315

   T4RIFOthInc,T4RIFPens,T4RIFTax,T4RifAnnuity,T4RifSpBox16,T4RifSpBox20,T4RifSpBox24: real;

   T4APOAS,T4APCppBnf,T4APDisabBnf,T4APTax : real;
   T4APCppMonths:Integer;
   T4APDisabMonths:integer;

   T3OthInc,T3Pens,T3ITC,T3Xii,
   T3ElgblQSB1,T3ElgblQSB2,T3ElgblQSB3,
   T3ElgblQFP1,T3ElgblQFP2,T3ElgblQFP3,
   T3ElgblOTH1,T3ElgblOTH2,T3ElgblOTH3,
   T3FarmElgbl,T3OthElgbl,T3QFPElgbl,
   T3NonElgblGains1,T3NonElgblGains2,T3NonElgblGains3,
   T3Dividends,T3DividendsEligible,
   T3FNonBusInc1,T3FNonBusInc2,T3FNonBusInc3,
   T3FNonBusTax1,T3FNonBusTax2,T3FNonBusTax3,
   T3FBusInc1,T3FBusInc2,T3FBusInc3,
   T3FBusTax1,T3FBusTax2,T3FBusTax3,
   //T3Box52,T3Box53,T3Box54,
   T3Box55,
   //T3Box56,
   T3Box57:real;
   //T3Box58,T3Box59:real;

   LaborSpCost,LaborSpFedCredit,LaborSpPrvCredit:real;
   LaborSpOnEo,LaborSpBcEsop:real;

   T5013OthInc,T5013LimitedInc,T5013ITC,
   T5013ElgblQSB1,T5013ElgblQFP1,T5013ElgblOTH1,T5013NonElgblGains1,
   T5013ElgblQSB2,T5013ElgblQFP2,T5013ElgblOTH2,T5013NonElgblGains2,
   T5013ElgblQSB3,T5013ElgblQFP3,T5013ElgblOTH3,T5013NonElgblGains3,
   T5013ActDiv,T5013ActDivEligible,
   T5013CarrCharg,
   T5013CDE,T5013CEE,T5013COGPE,T5013FDE,T5013RecapDepl,
   T5013FedPol, T5013ProvPol,T5013Don,T5013Gifts,T5013Abil,
   T5013FNonBusInc1,T5013FNonBusInc2,T5013FNonBusInc3,
   T5013FNonBusTax1,T5013FNonBusTax2,T5013FNonBusTax3,
   T5013FBusInc1,T5013FBusInc2,T5013FBusInc3,
   T5013FBusTax1,T5013FBusTax2,T5013FBusTax3,
   T5013Interest, T5013Tax,
   T5013ResAllow,T5013FInterest:real;
   {T101/102}
   T101CEE,T101AllowCEE,T101CDE,T101AllowCDE,
   T101COGPE,T101AllowCOGPE: real;

   T102CEE,T102AllowCEE,T102CDE,T102AllowCDE,
   T102COGPE,T102AllowCOGPE,T102PShipInc: real;

   T5Interest,T5Pens,
   T5NonElgblGains,T5Dividends,T5DividendsEligible,
   T5FNonBusInc1,T5FNonBusInc2,T5FNonBusInc3,
   T5FNonBusTax1,T5FNonBusTax2,T5FNonBusTax3,T5OthEmpl : real;
   T4RspIncome, T4RspOthDed, T4RspTax,T4RspSpBox20,T4RspSpBox22,T4RspSpBox26:real;
   //property IsLastYearRetNo : Boolean read FIsLastYearRetNo;  // write SetIsLastYearRetNo;   //20110215
  protected
    procedure SetLocked(const Value: boolean); override;
    function InitFormData(FRec: TFRec): boolean; override;
    function GetReadOnly: Boolean; override; //20210115 Igor
  public //methods, override
    constructor Create(TheApp: TApp); override;
    destructor Destroy; override;
    Function  AddPageInstance(NonInstFormName, FormInst: string): integer; override;
    Procedure CloneForm(FromFormName: string;ToRetNo: integer;ToFormName:String; fAll: boolean); override;
    Procedure CloneReturn(ToRetNo: integer); override;
    function  Close(fRemove: boolean): boolean; override;
    function  NewChild: TMyChild; override;
    function  BeforeOpenForm(var FormName: string; var FormNo: integer): string; override;
    function  GetReturnCaption: string; override;
    function  GetReturnName: string; override; //for printing
    function  DoSave: boolean; override; //part of SaveAllReturns
    procedure DoSaveAs; override; //using SaveAs dialog
    function GetDefaultFileName: String; override; //20160305 Igor
    function GetCloudFileName: String; override; //20190312 Igor
    function GetFirstName: string; override;
    function GetLastName: string; override;
    function GetSIN: string; override; //20170328 Igor
    function GetDCN: string; override; //20170328 igor
    function GetLastYearFile: String; override; //20160701 Igor
    procedure SetLastYearFile(const AValue: String); override; //20160701 Igor
    function GenerateDefaultFileNameForExport: String; override; //20170112 Igor
    function GetDirClientDocs: String; override;//20170714 Igor
  public //forms
    function  GetDfmFileName(const FName: string): string; override;
    procedure GetFrmTree(TreeView: TTreeView; fUsedForms: boolean = False); override;
    function  GetFrmTreeFNo(SourceNode: TTreeNode; fUsedForms: boolean): integer; override;
    function SubstituteForm(AFormName: String): String; override; //20161101 Igor
    function FormClass: TvtFormClass; override;
    function IsLetterForm(AFormName: String): Boolean; override;
  public //calculations
    procedure Calc(RNo: integer; const FName: string; FNo: integer = -1); override;
    procedure CalcAll; override;
    procedure CalcFullReturn; override;
    procedure ReCalcEveryThing; override;
    procedure CountDiagnostics; override;
  public  //letters
    function GetInterpetedRichEdit(LetterName:String;ARichEdit:TRichEdit): boolean; override;
  public //visual feedback
    function RefreshAuditPanel(ReturnsHeaderPanel: TPanel; ErrorView: TTreeView; AuditMode: eAuditMode): string; override;
    procedure StartPrintForm(FormName:String;WhichPage:integer); override;
  end;

  TRetT1_LastYear = class(TRetT1_2026)
  public
    constructor Create(TheApp: TApp); override;
  end;

  TRetListT1_2026 = class(TRetList)
  private
    function GetRetT1(RetNo: integer): TRetT1_2026;
  public
    property RetT1[RetNo: integer]: TRetT1_2026 read GetRetT1; default;
  end;

  TAppT1_2026 = class(TApp2018)
  public //OptRec
   Dir_LastYr,  //   :    string; //[80];
   Dir_PgmLastYr, //:    string; //[80];
   Dir_Planner, //  :    string; //[80];
   Dir_PrvLYr,  //   :    string; //[80];
   BackUpDir, //    :    string; //[80];
   LastBackupDir, //   : string; //[80];
   BackupFrequency, // : string; //[3];
   Dir_Train, //    : string; //[40];
   Dir_Sample,  //   : string; //[40];

   Reviewer_Name, //: string; //[50];
   Prp_BusNo, //    : string; //[15];
   Prp_RepId, //    : string; //[7];
   Reviewer_EMail, // : string; //[50];
   Prp_Prov, //     : string; //[2];
   Prp_Countr, //   : string; //[8];
   Reviewer_Area, //: string; //[3];
   Reviewer_Tel, // : string; //[8];
   Prp_FirstName, //: string; //[20];
   Prp_LastName, // : string; //[40];
   Prp_FxArea, //   : string; //[3];
   Prp_Fax, //      : string; //[8];
   Prp_DiscNo, //   : string; //[10];
   Prp_DiscNm, //   : string; //[30];
   Prp_GSTNo: string; //    : string; //[17];
   Prp_Bill     : string; //[1];
   Prp_VSFee    : Real;
   Prp_SFee     :Real;  //20100623
   Prp_AFee     :Real;
   Prp_CFee     :Real;
   Prp_VCFee    :Real;
   Prp_Hour     :Real;
   Prp_Elect    :Boolean;
   Prp_Citizen  :Boolean;
   Prp_EfRepr   :Boolean;
   Prp_Dates    :Boolean;

   Nfl_Prov     : string; //[2]; {New File defqaults}
   Nfl_City     : string; //[20];
   Nfl_Disced   : string; //[1];
   Nfl_Efile    : Boolean;


   EF_Method   : string; //[4];
   Ef_PrepNo   : string; //[30];
   Ef_TransNo  : string; //[30];
   Ef_PsWord   : string; //[30];
   Ef_ProdNo   : string; //[12];
   Ef_TestNo   : string; //[12];
   Ef_DataDir  : string; //[30];
   Ef_EncDir   : string; //[30];
   Ef_DialNo   : string; //[13];
   Ef_NUI      : string; //[20];
   Ef_NuiPass  : string; //[10];
   Ef_Port     : Integer;
   Ef_Baud     : Integer;
   Ef_Protocl  : string; //[1];
   Ef_Centre   : string; //[2];
   Ef_PrepId   : string; //[10];
   Ef_PrnPort  : Integer;
   Ef_Carrier  : string; //[10];
   Ef_Stage    : string; //[10];

   Prn_Watermark: string;   //20191216 Igor
   Prn_PIPEDAAll: boolean;  // Prn_PIPEDAll: boolean;  //20170401
   Prn_Head    : Boolean;
   Prn_NameH   : Boolean;
   Prn_SinH    : Boolean;
   Prn_HideSin : Boolean;
   Prn_DateH   : Boolean;
   Prn_Disclm,  //  : string; //[130];
   Bus_Disclm  : string; //[130];
   Prn_logoln  : integer;
   Opr_Recalc  : Boolean;
   Opr_FPres   : Integer;
   Opr_GstHst  : Real;
   Opr_PST     : Real;
   //other options
   ShowTreeViewSW      : Boolean;
   ShowFinWarning      : Boolean;
   ShowUsedForms       : Boolean;
   OpenAtLastForm      : Boolean;
   ShowConsultantOnInv : Boolean;
   UseFastPrint        : Boolean;
   UseProperName       : Boolean;
   UseFormSearch       : Boolean;
   Use2YearSummary     : Boolean;
   OpenCouple          : Boolean;
   PstOnInvoice        : Boolean;
   OtherSlipsButtons   : Boolean;  //show the SlipsFrame
   UseCondominiumLine  : Boolean;
   RolloverT4T5        : Boolean;
   ShowVisitedForms    : Boolean;
   ShowInvoiceWarning  : Boolean;
   ShowTaxSavings      : Boolean; //20160119 Igor
   ShowInvoiceEfCharge : Boolean;
   ShowSaluteWarning   : Boolean;
   T1013AuthorLevel    : string; //[1];
   CVSetting           : string; //[1];
   CVPostSetting       : string; //[1];
   FirstReturnColor    : string; //[20];
   RolloverProgram     : string; //[20];

   SerializeInvoice    : Boolean;
   InvPrefix           : string; //[11];
   InvStartNo          : string; //[5];
   InvSuffix           : string; //[4];

   InvFoot1, //            : string; //[100];
   InvFoot2, //            : string; //[100];
   InvFoot3, //            : string; //[100];
   InvFoot4, //            : string; //[100];
   InvFoot5: string; //            : string; //[100];

   RetainRetColor      : Boolean;
   AutoSeniorDiscount  : Boolean;
   DiscountForSeniors  : string; //[6];
   NoBarCode           : Boolean;
   RetainDefaultPrinter: Boolean;
   Capitalization      : string; //[20];
   T1013Warn           : string; //[20];
   FileNameFormat      : string; //20200921 Igor

  protected
  //must override
    function GetAppName: string;  override;
    function GetAppDir: string; override;
    function GetAppRelease: string;  override;
    function GetAppUpdateDate: string;  override;
    function GetVtClientUpdateDate: string; override; //20210118 Igor
    function GetAppYear: string;  override;
    function GetDfmFileName(const FormName: string): string; override;
    function GetDfmFileNameLY(const FormName: string): string; override;   //20160321 Igor
    function GetSQLLitePassword(const Version: Integer = GC_SQLLitePasswordVersion): String; override; //20160226 Igor //20160303 Igor
    function GetSQLLiteRFPassword(const Version: Integer = GC_SQLLitePasswordVersion): String; override; //20160415 Igor
    function GetValidLastYearPgmFolder: Boolean; override; //20160302 Igor
    function GetValidLastYearDataFolder: Boolean; Override; //20160302 Igor
    function GetLastYearFormNo(AFormName: String): Integer; override; //20160302 Igor
    function GetSubstituteLastYearForm(AFormName: String): String; override; //20160302 Igor
    function GetLastYearDataFolder: String; override; //20160302 Igor
    function GetInitLastYear: Boolean; Override; //20160320 Igor
    function GetHelpFile: String; override; //20160526 Igor
    function GetHelpUpdFile: String; override; //20160526 Igor
    function GetLimitedVersionDir: String; override; //20160718 Igor
    procedure CreateDefaultDataDirectories; override;//20170811 Igor
    function GetLimitReturns: Integer; Override;//20170901 Igor
    //20171031 Igor>>>
    procedure InitStorage;
    function Factor2: Byte; override;
    //20171031 Igor<<<
    function GetEfilerNumber: string; override; // 20180712 Igor
    function GenerateReturnFileName(ASIN, AName: string): string; override; //20201015 Igor
  public
    constructor Create(AppList: TAppList); override; // 20151116 Igor
  //implement abstract methods
    function  GetMenu: TMainMenu; override;
    function  GetToolBar: TControl; override;//20170824 Igor
    function  GetSplash: TCustomControl; override;
    procedure SelectFeatures; override;
    //20160114 Igor
    procedure SetZoomCaption(AZoom: Integer); override;
    procedure ReloadMainMenu; override; //20180111 igor
  public //cross-app adds
    function  InitNewReturn(ForLoad: boolean = False): integer; override;
    function  OpenReturn(DirName,FlName: string; fShow: boolean; AIsAppendix: Boolean = False): integer; override;
    function SaveReturn(RetNo: Integer; DataDir: string; FlName: string;
      OverrideSW: boolean; UpdMostRecent: boolean; ATextFormat: boolean = False;
      AUpdateClientTable: boolean = True; AClouds: TArrayOfInteger = nil): Integer; override; //20200914 Igor //20200916 Igor
    function OpenForeignForm(const ADir, AFile, AForm: String; const AElement: Integer): TFormData; override; //20170717 Igor
    function CheckLastYearPgmFolder(out AErrorMessage: String): Boolean; override; //20160516 Igor
    function CheckLastYearDataFolder(out AErrorMessage: String): Boolean; override; //20160516 Igor
    function GetDefaultOptionsValue(AOptionName: String): String; override; //20160530 Igor
    function GetOptionsCaption(AOptionName: String): String; override; //20160530 Igor
    function GetDefaultOptions: TStringList; override; //20160530 Igor
    function HaveOptions(AOptionsName: String): Boolean; override; //20170112 Igor
    function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String;
      var AErr: String; AOverride: Boolean): Boolean; override; //20160530 Igor //20160602 Igor
    procedure LoadOptionsFileToMem; override; //20160530 Igor
    procedure InitFList; override; //20160531 Igor
    procedure SaveSingleOptions(const AOptionName, AValue: String; AOptionsFileName: String = ''); override; //20160602 Igor //20160617 Igor
    function vtMobileFilePath: String; override;  //20160614 Igor
    procedure InitFormsTable; override; //20160616 Igor
    function GetExportForms: TExportForms; override; //20161229 Igor
    function isValidDataDir(const ADir: String): Boolean; override;//20170504 Igor
    function AllowFormForBuildReport(const AFormName: String): Boolean; override; //20170505 Igor
    function MaskFormDataForBuildReport(const AFormName: String; AFieldNo: Integer;
      AFieldValue: String): String; override; //20170505 Igor
    function AllowAllFieldsForBuildReport: boolean; override; //20210121 Igor
    //20170628 Igor >>>
    procedure CallExecuteForm(AFormID: Integer); override;
    //20170628 Igor <<<
    //20170726 Igor>>>
    function AutoFillToVtAddr(const ASection, ASubSection: String;
      out AVTAddr: TVTMapElement): Boolean; override;
    //20170726 Igor<<<
    procedure OpenClientBook; override; //20200916 Igor
  //20200317 Igor >>>
  public
    function CanRebuildCorruptedDatabase: boolean; override;
    procedure RebuildCorruptedDatabase; override;
  //20200317 Igor <<<

  public //client letters
    //function  LoadDataDict: TDataDictList; //virtual;
    procedure HelpOnClientLetter; override;
  public //licenses
    function  Licenses: PPgmLicenseData; override;
    function  ValidateKey(AKey: String): boolean; override;
    function  ValidateScanKey(AKey: String): boolean; override;
    function ValidateArchKey(AKey: string): boolean; override; //20241024 Igor
    //20201019 Igor >>>
    //20201208 Igor >>>
    //function GetCourierPassword(APasswordMode: integer): string; override; //20201026 Igor
    //procedure SetCourierPassword(APassword: string); override; //20201023 Igor
    //20201208 Igor <<<
    function GetCourierRecipientEmail: string; override;
    function GetCourierRecipientSalutation: string; override;
    function GetCourierClientDocumentsFolder: string; override;
    //20201019 Igor <<<
    procedure SetSilentRead(AValue: boolean); override; //20201223 Igor
  end;
var
  AppT1_2026: TAppT1_2026;
  Ret: TRetListT1_2026 absolute RetList;
  OptRec: TAppT1_2026 absolute AppT1_2026;

function  Calc(RetNo: integer; FName: string; FNo: integer=-1): TCalcRtn; overload;
//Function CreateNewReturn:Integer;
Function  CreateNewReturn(DataYear: string = ''; AConvert: Boolean = False):Integer;//20160329 Igor
function  GetAuthorizationKey: string;


implementation

uses
  SysUtils,StdCtrls,
  EkRtf,ekbasereport,ekfunc,
  vtCommon,vtAuthorization,fDfmProgress,T1_2026ChildWinNew,
  T1_2026Calc,T1_2026Calc1,
  T1_2026Calc2,T1_2026Calc3,T1_2026Calc4,T1_2026CalcBus,T1_2026CalcCpl,
  T1_2026CalcMj, T1_2026CalcMJ2, //jz//20260328//MJCERT2025
  T1_2026CntErr,T1_2026TrimStr,{T1_2026SlipsFrame,}
  {T1_2026FrameElections,}vtTrimStr,vtShared, //20160118 Igor //20160212 Igor
  T1_2026Rebuild, //20200317 Igor
  vtVirtualTaxOffice, //20201201 Igor
  T1_2026AutoFillFrm; //20170726 Igor

function GetAuthorizationKey: string;
begin
  Result := AppT1_2026.GetAuthorizationKey;
end;

function MyHashString(const AKey: string): string;
var
  p: PPgmLicenseData;
  id: string;
  f1,f2: integer;
begin
  Result := '';
  if Length(AKey) <> 19 then
    exit; //valid key has exactly 19 chars
  id := LeftStr(AKey, 4); //T10x
  p := @pgmLicenses[0];
  while p.Level > llNone do begin
    if p.Id = id then
      break;
    inc(p);
  end;
  f1 := p.Factor;
  case AKey[1] of
   //20150623
   //20220801 Igor >>>
  'T':  f2 := T1F2025; //T1 key  factor2
  'S':  f2 := S1F2025; //S1 key  Scan key
  'A':  f2 := A1F2025; //20241024 Igor
  //20220801 Igor <<<
  else
    exit;
  end;
  Result := MakeHashString(AKey, f1, f2);
end;

procedure InitBmps;
begin
end;

Function CreateNewReturn(DataYear: string = ''; AConvert: Boolean = False):Integer; //20160329 Igor
Var //InputString:String;
  MyRet: TRetData;  // TRetT1_2026;
begin

//20170902 Igor>>>
//  //20170502 Igor >>>
//  if RetInMem(AppT1_2026, True) >= AppT1_2026.LimitReturns then
//    Exit(-3);
//  //20170502 Igor <<<

  Result:=0;
  If IsDataDirectoryGood(OptRec.Dir_Deflt) = False then exit;
//  If ExceedsMaxReturnsAllowed then
//  begin
//   If IsHomeUse then
//   begin
//    UserMsg('Number of returns exceeds maximum allowed '
//    +'('+IntToStr(NetFileVersionReturns)+')'+
//    Chr(13)+' in the NetFile version');
//    // +Chr(13)+'Please delete some returns');
//    Exit;
//   end
//   else
//   begin
//    UserMsg('Number of returns exceeds maximum allowed '
//    +'('+IntToStr(LimitedVersionReturns)+')'+
//    Chr(13)+' in the T1 Limited version');
//    // +Chr(13)+'Please delete some returns');
//    Exit;
//   end;
//  end;
//20170902 Igor<<<

{$IFDEF ReturnsLimit}
  if RetInMem >= ReturnsLimit then
  begin
     UserMsg('Exceeded maximum number of returns that may fit in memory');
     exit;
  end;
{$ELSE}
{$ENDIF}

  if (DataYear = '') //new return
  or (DataYear = AppT1_2026.AppYear) //from read return
  or AConvert  //20160329 Igor
  then
  begin
    If IsDataDirectoryGood(OptRec.Dir_Deflt) = False then exit;
    MyRet := TRetT1_2026.Create(AppT1_2026);
  end
  else if StrToInt(DataYear) = StrToInt(AppT1_2026.AppYear)-1 then
  begin
  //last year return
    MyRet := TRetT1_LastYear.Create(AppT1_2026);
  end
  else
    exit;

  if MyRet = nil then
    Result := iorCountExceeded
  else
  begin
    Result := MyRet.RetNo
    //more?
  end;
end;



Procedure InitFrmTree;
Var i:Integer;{TempList:TStringList;}
begin
assert(FrmTreeDescr=nil,'duplicate call to T1 InitFrmTree');
  {prepare the forms lists for the list boxes}
  FrmTreeDescr :=TStringList.Create;
  FrmTreeForms :=TStringList.Create;
  FrmTreeDescr.LoadFromFile(AppDir+'\'+'Treeview.d');
  For i:=0 to FrmTreeDescr.Count-1 do
  begin
    FrmTreeForms.Add(AllTrim(MidStr(FrmTreeDescr[i],62,12)));
    FrmTreeDescr[i] := LeftStr(FrmTreeDescr[i],61);
  end;
   FrmTreeDescr.SaveToFile(AppDir+'\'+'TreeView2.d');
end;

procedure InitLists;
{MUST create the data lists AND also initialize them before using them}
var
  AList:TStringList absolute XmlList;
begin
  assert(ExtractedAutoList=nil,'duplicate InitLists');
  //TabNo        := 0;
  InitExtractedAutolist;
  ElmsInError  := TStringList.Create;
  //AffectedList  := TStringList.Create;
  //AffectedList.LoadFromFile(AppDir +'\'+ 'Affected.D');
  FrmDict:=TStringList.Create; //used to fetch last year's data
  T1PropDynList := TStringList.Create;
  TaxSumList := TstringList.Create;
  TaxSumList.LoadFromFile(AppDir +'\'+ 'TAXSUM.D');
  InitCCARates;
  LoadPrvRates;
  {if ServerMode=False then} InitFrmTree;
  //If ServerMode=False then LoadOthOpt;
//init SuperEntry files
  XmlList:=TStringList.Create;  //20111212
  //AList:=TStringList.Create;
  If Not FileExists(AppDir+'\'+'MedExp.txt') then AList.SaveToFile(AppDir+'\'+'MedExp.txt');
  If Not FileExists(AppDir+'\'+'Doctors.txt') then AList.SaveToFile(AppDir+'\'+'Doctors.txt');
  If Not FileExists(AppDir+'\'+'Charity.txt') then AList.SaveToFile(AppDir+'\'+'Charity.txt');
  If Not FileExists(AppDir+'\'+'Banks.txt') then AList.SaveToFile(AppDir+'\'+'Banks.txt');
  If Not FileExists(AppDir+'\'+'Employers.txt') then AList.SaveToFile(AppDir+'\'+'Employers.txt');
  If Not FileExists(AppDir+'\'+'FirstNm.txt') then AList.SaveToFile(AppDir+'\'+'FirstNm.txt');
  If Not FileExists(AppDir+'\'+'Cities.txt') then AList.SaveToFile(AppDir+'\'+'Cities.txt');
  //AList.Free;
  TddSinsReceived:=TStringlist.create;  //20160126 Igor
//20170512 Igor >>>
//  if not assigned(Somelist) then
//    Somelist := TStringList.Create; //20160216 Igor
//20170512 Igor <<<
end;

procedure InitT1; //from main initialization
begin
//20171031 Igor >>>
  OptimizeBtnClicked := False; //turn on when clicked
  PlanningRY := 1;
  Sc := 1;
  ScChar := 1;
  ScChange := 0;
  RY :=0; {0:current year;Rate year = next year/prelim}
  CfT4 := False;
  CfT5 := False;
  CfT3 := false;
  CfEfileIndic := False;
  InitOptions;
  OptRec.Dir_Cur := OptRec.Dir_Deflt;
  UpdateDbStructure; //20200914 Igor
  AppT1_2026.InitFList;

  InfoFNo:=GetFormNo('INFO');  //20181227
  Ln30000FNo:=GetFormNo('LN30000');  //20201118
//20171031 Igor <<<
end;


function TAppT1_2026.AllowFormForBuildReport(const AFormName: String): Boolean; //20170505 Igor
begin
  {!!! if you allow new form for report builder - do not remember mask critical fields in function MaskFormDataForBuildReport}
   //20170514
  //SameText('','')  It allows all forms
  Result := SameText(AFormName, 'TAXSUM')  //20191220
            or SameText(AFormName, 'FAMSUM')
            or SameText(AFormName, 'T1')   //twice why the first one does not show?
            //20170524 Igor >>>
            or SameText(AFormName, 'INFO')
            or SameText(AFormName, 'T1135');
           //20170524 Igor <<<

   end;


function TAppT1_2026.MaskFormDataForBuildReport(const AFormName: String;
  AFieldNo: Integer; AFieldValue: String): String; //20170505 Igor
begin
     //20170514
  If SameText(AFormname, 'TAXSUM') then
  begin
    if (AFieldNo = 11)        //sin
       or (AFieldNo = 6)         //birthdate
       or (AFieldNo = 15)          //spouse birthdate
       or (AFieldNo = 18)          //spouse SIN
       then
      Result := StringOfChar('*', length(AFieldValue))
    //20170524 Igor >>>
    else
      Result := AFieldValue;
    //20170524 Igor <<<
  end

  Else If SameText(AFormname, 'FAMSUM') then
  begin
    if (AFieldNo = 5)       //sin
       or (AFieldNo = 6)    //SIN
       then
      Result := StringOfChar('*', length(AFieldValue))
    //20170524 Igor >>>
    else
      Result := AFieldValue;
    //20170524 Igor <<<
  end

  Else if SameText(AFormname, 'T1') then
  begin
    if (AFieldNo = 3)
       or (AFieldNo = 9)
       or (AFieldNo = 4)
      then
      Result := StringOfChar('*', length(AFieldValue))
    else
      Result := AFieldValue;
  end

//20170524 Igor >>>>
  Else if SameText(AFormname, 'INFO') then
  begin
    if (AFieldNo = 3)
       or (AFieldNo = 9)
       or (AFieldNo = 4)
      then
      Result := StringOfChar('*', length(AFieldValue))
    else
      Result := AFieldValue;
  end
  Else if SameText(AFormname, 'T1135') then
  begin
    if (AFieldNo = 5)
       or (AFieldNo = 8)
       or (AFieldNo = 30)
       or (AFieldNo = 11)
       or (AFieldNo = 14)
       or (AFieldNo = 35)
       or (AFieldNo = 30)
      then
      Result := StringOfChar('*', length(AFieldValue))
    else
      Result := AFieldValue;
  end
//20170524 igor <<<
end;


function TAppT1_2026.AutoFillToVtAddr(const ASection, ASubSection: String;
  out AVTAddr: TVTMapElement): Boolean;//20170726 Igor
begin
  Result := T1_2026AutoFillFrm.AutoFillToVtAddr(ASection, ASubSection, AVTAddr);
end;

procedure TAppT1_2026.CallExecuteForm(AFormID: Integer); //20170628 Igor
begin
  if Assigned(MainFormT1) then
    MainFormT1.CallExecuteForm(AFormID);
end;

function TAppT1_2026.CanRebuildCorruptedDatabase: boolean; //20200317 Igor
begin
  case Self.LicenseLevel of
    llLimited, llLimEfile: Result := true;
  else
    Result := inherited CanRebuildCorruptedDatabase;
  end;
end;

function TAppT1_2026.CheckLastYearDataFolder(
  out AErrorMessage: String): Boolean;
begin
  Result := isValidLastYearDataFolder(false,AErrorMessage);
end;

function TAppT1_2026.CheckLastYearPgmFolder(out AErrorMessage: String): Boolean; //20160516 Igor
begin
  Result := isValidLastYearPgmFolder(false,AErrorMessage);
end;

constructor TAppT1_2026.Create(AppList: TAppList);// 20151116 Igor
begin
  assert(AppT1_2026=nil,'dupe T1.Create');
  InitMulti;
  CurrentApp := self;
  AppT1_2026 := self; //required in initialization!
  //FName := 'T1';
  AppIdx := aiT1;
  AppId := 'T1-2026'; //'T1-2013';       //20150628  !!
  ClientsDBLite:=lClientsDBLite+'_'+AppName+'.db'; //20151017 Igor !!!after AppId!!!//20170731 Igor
//  SQLLitePassword:=T1SQLLitePassword;                      //20151017 Igor //20160226 Igor
  FSQLitePassword := TSQLitePassword.Create(Self); //20160303 Igor
  //20180503 Igor >>>
  if CheckIsCloud(true) then
    T1_2026Declare.AppDir := CloudDir + '\' + AppId //20190213 Igor
  else
    T1_2026Declare.AppDir := ExeDir + '\' + AppId;
  //20180503 Igor <<<
  FFirstForm := 'INFO';
  //FCalcs := TCalcsT1_2026;
  ScanId := ScanId1;  // 'S1-2011';
  ArchiveID := ArchiveId1; //20241024 Igor
  InitStorage;//20171031 igor
  InitT1; //init uDeclare
  inherited Create(AppList); // 20151116 Igor
  if OptRec.Dir_PgmLastYr = '' then
    OptRec.Dir_PgmLastYr := GetInstalledAppDir('T1-2025');   //20171031 Igor
    //OptRec.Dir_PgmLastYr := GetInstalledAppDir('T1-2012');
  //RegisterClasses([TSlipsFrame]);
  //CheckCalcs;
  try
    MainFormT1 := TGuiT1_2026.Create(Application);
  except
    on e: Exception do ExceptMsg(e);
  end;
  AddReviewStaticForm('TAXSUM'); //20160220 Igor
  AddReviewStaticForm('FAMSUM'); //20160220 Igor
  AddReviewStaticForm('BUSSUM'); //20160223 Igor
  AddReviewStaticForm('T4Sum#1'); //20160223 Igor
  AddReviewStaticForm('RentSum'); //20160223 Igor
  AddReviewStaticForm('YRSum2'); //20160223 Igor
  AddReviewStaticForm('YRSum'); //20160223 Igor
end;

procedure TAppT1_2026.CreateDefaultDataDirectories;//20170811 Igor
begin
  T1_2026TrimStr.CreateDefaultDataDirectories;
end;

function TAppT1_2026.Factor2: Byte;//20171031 igor
begin
  Result := T1F2025; //20220801 Igor
end;

function TAppT1_2026.GenerateReturnFileName(ASIN, AName: string): string; //20201015 Igor
begin
  Result := GenerateCloudFileName(ASIN, AName, '', OptRec.FileNameFormat);
end;

function TAppT1_2026.GetAppDir: string;
begin
  Result := T1_2026declare.AppDir;
end;

function TAppT1_2026.GetAppName: string;
begin
  Result := T1_2026declare.AppName;
end;

function TAppT1_2026.GetMenu: TMainMenu;
begin
  Result := T1Menu;
  MainFormT1.ShowCellNumbers1.Checked := ShowFieldIdSw;
end;

function TAppT1_2026.GetToolBar: TControl;//20170824 Igor
begin
//init global settings (SelectFeatures!)
  MainFormT1.ZoomStr:=IntToStr(OptRec.FormZoom)+'%';
  //20170824 Igor>>>
  case MainOptions.Skin of
    skSmallToolbar:
      Result := MainFormT1.CoolBar1;
    skLargeToolbar:
      Result := MainFormT1.CoolBar2;
    skRibbon:
      Result := MainFormT1.MainUIRibbon; //20190415 Igor
  else
    Result := MainFormT1.ToolBar;
  end;
  //20170824 Igor<<<
end;

function TAppT1_2026.GetValidLastYearDataFolder: Boolean; //20160302 Igor
var
  ErrorMessage: String;
begin
  Result := isValidLastYearDataFolder(true,ErrorMessage);
end;

function TAppT1_2026.GetValidLastYearPgmFolder: Boolean; //20160302 Igor
var
  ErrorMessage: String;
begin
  Result := isValidLastYearPgmFolder(true,ErrorMessage);
end;

function TAppT1_2026.GetVtClientUpdateDate: string; //20210118 Igor
begin
  Result := T1_2026Declare.vtClientUpdateDate;
end;

function TAppT1_2026.GetSplash: TCustomControl;
begin
  Result := MainFormT1.AboutPanel;
end;

function TAppT1_2026.GetSQLLitePassword(const Version: Integer = GC_SQLLitePasswordVersion): String; //20160303 Igor
begin
//Do not remove the old version
  case Version of
    0: Result := '';
    1: Result := AppName+Contributor1+Contributor2+Reverse(Contributor3);
    2: Result := AppName+Contributor1+Contributor2+Reverse(Contributor3ver2);
    3: Result := chr(54)+chr(119)+'m'+chr(126)+chr(77)+chr(110)+'Z'+''+chr(71)+        //20161208 Igor
                 chr(67)+chr(53)+''+chr(64)+chr(100)+chr(83)+''+chr(74)+'Y'+chr(65);
    4: Result := '~'+chr(74)+'@'+chr(67)+chr(36)+chr(57)+chr(98)+chr(65)+'t'+
                 chr(80)+chr(81)+chr(99)+chr(125)+chr(69)+chr(109)+chr(118); //20161215 Igor
  end;
end;

function TAppT1_2026.GetSQLLiteRFPassword(const Version: Integer): String; //20160415 Igor
begin
//Do not remove the old version
  case Version of
    0: Result := '';
    1: Result := Contributor1+AppName+Contributor2+Reverse(Contributor3);
    2: Result := Contributor1+AppName+Contributor2+Reverse(Contributor3ver2);
    3: Result := chr(86)+chr(98)+'0'+chr(37)+chr(116)+chr(116)+'n'+chr(116)+'}'+       //20161208 Igor
                 ''+chr(116)+chr(67)+chr(89)+chr(89)+chr(122)+chr(119)+chr(77);
    4: Result := 'n'+chr(81)+'Y'+''+chr(108)+'n'+chr(121)+'X'+chr(53)+chr(57)+
                 ''+chr(82)+'Q'+chr(53)+chr(112)+chr(71)+'M'+chr(77); //20161215 Igor
  end;
end;

function TAppT1_2026.Licenses: PPgmLicenseData;
begin
  Result := @pgmLicenses;
end;

procedure TAppT1_2026.LoadOptionsFileToMem;
begin
  T1_2026TrimStr.LoadOptionsFileToMem;
end;

//20241024 Igor >>>
function TAppT1_2026.ValidateArchKey(AKey: string): boolean;
begin
  Result := False;
  If length(Akey) <> 19 then
    Exit;
  If UpperCase(LeftStr(AKey,2)) <> 'A1' then
    exit;
  If MidStr(AKey, 16, 4) = MyHashString(AKey) then
    result := True;
end;
//20241024 Igor <<<

function TAppT1_2026.ValidateKey(AKey: String): boolean;
begin
(* A default licenseLevel (Demo?) should be set
*)
  result:= inherited ValidateKey(AKey); //checks length and hash
  if not Result then exit;
 //expired/retracted
 //2023 and 2022
  If (UpperCase(AKey)='T105-8330-8799-1624')   //saimakhalil@hotmail.c //20250122
  or (UpperCase(AKey)='T105-1268-2521-1086')   //GSM ACCOUNTING LTD  //20240320
  or (UpperCase(AKey)='T103-8246-0115-0872')   //ARSHDEEP KAUR  //20240401
  or (UpperCase(AKey)='T104-3385-6356-1254')   //Clips Accounting   //20240320
  or (UpperCase(AKey)='T105-7154-7753-1374')   //AOD TAX SERVICES aodtax@rogers.com //20240315
  or (UpperCase(AKey)='T105-1622-2836-1158')   //Paul gerin error //20231211
  or (UpperCase(AKey)='T105-2431-3555-1110')   //JULIUS JAYEOBA -Julius japcinfo@gmail.com  //20240212
  or (UpperCase(AKey)='T105-5971-6702-1326')   //Paul gerin error //20240124
  or (UpperCase(AKey)='T105-7467-8032-1326')   //SVETLANA MAIZEL  //2023 //20240117
  or (UpperCase(AKey)='T102-4240-3769-0896')   //CQ RESEARCH  20230216
  or (UpperCase(AKey)='T102-4240-3769-0896')   //CQ RESEARCH  20230216
  or (UpperCase(AKey)='T103-1757-1562-0985')  //alejandraalme@gmail.com //20230419
  or (UpperCase(AKey)='T104-6080-5404-0942')  //SUKHDEEP THIND   //200330
  or (UpperCase(AKey)='T104-6245-5551-1074')   //  ??          //20230302
  or (UpperCase(AKey)='T105-2048-1820-1002')  //taxes@aysoffice.ca  //20230218 Rosa villar king
  or (UpperCase(AKey)='T105-0174-0155-0956') //bogdan wrong Email //20230129
  or (UpperCase(AKey)='T102-7515-6680-0956') //boparaik@gmail.com  //20230207
 //2021
  or (UpperCase(AKey)='T102-7588-6745-1141') //VP HARDMAN PROFESSIONAL CORPORATION  //20220107
  or (UpperCase(AKey)='T105-3200-2845-0944') //IT matrix 20220319
  //2019
  or (UpperCase(AKey)='T105-0729-0648-1114') //633771 NB LTD OP AS BARTER & ASSOCIATES  //20200209
  or (UpperCase(AKey)='T105-8121-7219-1014')   //bushi and Dee key replaced 20200528
  or (UpperCase(AKey)='T105-7910-7031-0954') //taxbreaks Leeaked hackers //20200514
  or (UpperCase(AKey)='T103-3113-2767-0790') // Allavinkler   //20200331
  //2018
  or (UpperCase(AKey)='T103-8440-7502-0753') //Linda wrightt asked refund //20190311
  //in T1-2017
  or (UpperCase(AKey)='T104-2942-2615-0790') //judy bieman  //20170212
  or (UpperCase(AKey)='T105-8081-7183-1020') //Arib financial not paid  //20180328
  or (UpperCase(AKey)='T105-8435-7498-1236') //Optimum wellnes Jeff Parent  //20180321
  or (UpperCase(AKey)='T105-8948-7954-1279') //JULIUS OLU JAYEOBA CGA  //20170405
  or (UpperCase(AKey)='T102-7612-6766-0740') //zazaroof limited by mistake  //20170218
  //20180225
  or (UpperCase(AKey)='T102-3884-3452-0726') //Bhupinder Singh
  or (UpperCase(AKey)='T102-1336-1188-0636') //DRB TAX SERVICE C/O DENIS R BLONSKY
  or (UpperCase(AKey)='T105-8579-7625-1254') //LOGAN'S ACCOUNTING & TAX SOLUTIONS C/O LOGARAJAH KUMARASAMY
 (*
  //prior yesrs
  or (UpperCase(AKey)='T105-5555-4600-0714')
  or (UpperCase(AKey)='T106-4194-3728-1114') //ABT accounting  //20170105
  or (UpperCase(LeftStr(Optrec.Prp_Name,6))='CORDEV') then Application.Terminate;
//20160119 Igor
//11.	The new T1 Authorizations keys must be implemented  (as shown in the D5 UAuthorization
*)
 (*
 If (LeftStr(AKey,19) = 'T105-9241-0214-0549') //relshedwood
 or (LeftStr(AKey,19) = 'T104-1394-1239-0724') //Castler
 or (LeftStr(AKey,19) = 'T103-4645-4129-0670') //Platinum
 or (LeftStr(AKey,19) = 'T105-6113-5433-0729') //sacrabanty  //20150315
 Or (LeftStr(AKey,19) = 'T105-7913-7033-0834') //50 & PIU FENACOM 2000 INC 1 (angie)
 //in 2013
 or (LeftStr(AKey,19) = 'T105-7609-6763-1554') //KW income tax  //20140121
 or (LeftStr(AKey,19) = 'T105-9930-8827-1530') //Geoff Kwok - returned
 or (LeftStr(AKey,19) = 'T105-0234-0208-0828') //ChartRand - returned
 or (LeftStr(AKey,19) = 'T104-3736-3321-0970') //stan wigg  //20140202 cheque not signed
 or (LeftStr(AKey,19) = 'T105-0728-0647-1218') //consolidated Cyril CHIKWE (obasi?)
 *)
 then
 begin
  result:=False;
  exit;
 end;

 //If MidStr(AKey,16,4) = MakeHashString(AKey,PgmNames,ProductIds,PgmFactors) then
 //20150628
 //If MidStr(AKey,16,4) = MyHashString(AKey) then result:=True;
 Result := MidStr(AKey,16,4) = MyHashString(AKey);
 If UpperCase(LeftStr(AKey,2)) <> UpperCase(LeftStr(AppName,2)) then result:=False;  {T1 key goes with T1, etc}

end;

function TAppT1_2026.ValidateScanKey(AKey: String): boolean;
begin
  Result:=False;
  If Akey='S101-0088-0078-2578' then exit; //20220319

  If length(Akey)<>19 then
    Exit;
  If UpperCase(LeftStr(AKey,2)) <> 'S1' then
    exit; //result:=False;  {T1 key goes with T1, etc}
//factors for S1-2011: 73,19
  If MidStr(AKey,16,4) = MyHashString(AKey) then
    result:=True;
end;

function TAppT1_2026.vtMobileFilePath: String;
begin
  {TODO Generate SQLite File with documents}
  Result := '';
end;

function TRetT1_2026.Close(fRemove: boolean): boolean;
begin
  MainForm.GuiCommand(gcStartCloseReturn); //20160311 Igor
  if RetList[RetNo].LastYearRetNo <> 0 then
    CloseReturn(RetList[RetNo].LastYearRetNo, fRemove);
  Result := CloseReturn(RetNo, fRemove);
  MainForm.GuiCommand(gcDoneCloseReturn); //20160311 Igor

end;


{ TRetListT1_2026 }

function TRetListT1_2026.GetRetT1(RetNo: integer): TRetT1_2026;
begin
  TObject(Result) := TypedReturn(RetNo,TRetT1_2026, False); //warnings???
end;

{ TRetT1_2026 }

constructor TRetT1_2026.Create(TheApp: TApp);

  Procedure EnlistColor(RetNo:Integer);
  Var Clr:LongInt;
  begin
    FRetColor := NextAvailColor(ColorList);
  end;

  procedure InitRetData;
  //Function InitRetData(RetNo: Integer): Boolean;
  var i,j, FNo: integer;
  begin
    //IsLastYearRetNo:=False; //20110215 {for new returns only}
    //LastYearData:= False;
    IsTaxPlan:=False; {for new returns only}
    Changed := False; {for new returns only}
    CouplingSw:= False;
    LastYearRetNo:=0;
    //Saved :=False;
    SourceDataDir := OptRec.Dir_cur;
    SourceFlName := '';
    Balance := 0;
//20170515 Igor >>>
    OpenedForms := TSingleStringList.Create;
    PreSelForms := TSingleStringList.Create;
//    TapesList := TSingleStringList.Create; //20220121 Igor
//    StringLists.AddSingle(@OpenedForms,TSingleStringList);
//    StringLists.AddSingle(@PreSelForms,TSingleStringList);
//    StringLists.AddSingle(@TapesList,TSingleStringList);
//20170515 Igor <<<
    //StringLists.AddSingle(@AuditList,TSingleStringList);
    AuditList.Clear;
    EFStatus := '00';
    PrpStatus := '00';
    MarStatus := 6;
    Province := OptRec.Nfl_Prov;
    Age := 30;
    Deceased := False;
    Bankrupt := 0;
    Notes := '';
    {coupling info}
    CplOptions    := False;
    CplGst        := True;
    CplMedical    := True;
    CplDependants := True;
    CplPrvCr      := True;
    CplPolit      := True;
    CplDon        := True;
    CplGstReb     := True;
    //Locked        := False;

    //create strings for rich forms to hold richedit pointers
    InitRichEditStorage(RetNo);  //???
    SumSlips(RetNo,'ALL'); {it initilizes slip totals}
   //May 15 2008
    EnlistColor(RetNo);
    //RetColor := GetNextAvailColor;
  end;

begin
//preset dynamic arrays
  //SetLength(Ln,LnHighBound+1); //made it dynamic
  //if not IsLastYearRetNo then
  SetLength(Frm, FormsLimit+1);
  SetLength(FrmHasData, FormsLimit+1);
//standard init
  inherited Create(TheApp);
//app-specific init
  InitRetData;
end;


destructor TRetT1_2026.Destroy;
begin
(* nothing new here, right now
*)
//20170515 Igor >>>
  FreeAndNil(OpenedForms);
  FreeAndNil(PreSelForms);
  //FreeAndNil(TapesList); //20220121 Igor
//20170515 Igor <<<
  inherited Destroy;
end;

function TRetT1_2026.GenerateDefaultFileNameForExport: String; //20170112 Igor
begin
  Result := IncludeTrailingPathDelimiter(OptRec.Dir_Cur) + 'ExportedData\' +
    GetSinNo(Self.RetNo)+'.txt';
end;

function TRetT1_2026.GetDefaultFileName: String;
begin
  Result := GenerateCloudFileName(GetSIN, GetLastName, GetFirstName, OptRec.FileNameFormat); //20200914 Igor //20200921 Igor
end;

function TRetT1_2026.GetDfmFileName(const FName: string): string;
begin
  //Result := T1_2026ChildWinNew.GetDFMFileName(FormName);
  If ShowUnconvertedLastYear(RetNo) = False then
    Result:=T1_2026ChildWinNew.GetDfmFileName(FName)
  else
    Result:=T1_2026ChildWinNew.GetLastYearDfmFileName(FName);
end;

function TRetT1_2026.GetDirClientDocs: String; //20170714 Igor
begin
  Result := IncludeTrailingPathDelimiter(OptRec.Dir_ClientDocs) +
    Self.GetLastName + ','+ Self.GetFirstName;
end;

procedure TRetT1_2026.GetFrmTree(TreeView: TTreeView; fUsedForms: boolean);
begin
  MainFormT1.RefreshFormsPanel(TreeView, fUsedForms, RetNo);
end;

function TRetT1_2026.GetFrmTreeFNo(SourceNode: TTreeNode;
  fUsedForms: boolean): integer;
begin
  Result := MainFormT1.FormsTreeView1Click(SourceNode, fUsedForms);
end;

function TRetT1_2026.BeforeOpenForm(var FormName: string; var FormNo: integer): string;
begin
  Result := T1_2026ChildWinNew.BeforeOpenForm(RetNo, FormName, FormNo);
end;

function  Calc(RetNo: integer; FName: string; FNo: integer=-1): TCalcRtn; overload;
//function  TRetT1_2026.NewCalc(FName: string): TCalcRtn;
var
  FRec: TFRec;
  DFMname: string;
begin
  FRec := FList.ByFormName(FName); //FNo may be wrong or missing?
  if not assigned(FRec.Calc) then
  begin
  //check for existing DFM name
    DfmName := GetDfmFileName(FName);
    if not FileExists(DfmName) then
      ErrorMsg('Missing DFM file: '+DfmName);

   if      FName = 'T1' then Result := @T1
 //  else if LeftStr(FName,7) = 'AUTHREP' then Result := @AUTHREP  //20200123
   else if LeftStr(FName,7) = 'CONSENT' then Result := @CONSENT  //20200123
   //else if LeftStr(FName,8) = 'UHT#' then Result := @UHT  //20230626 //20240717 Igor
   else if FName = 'LN30000' then Result := @Ln30000
   else if FName = 'LN34990' then Result := @Ln34990    //20260103
   else if FName = 'REFILEQ' then Result := @REFILEQ
   else if FName = 'T7DRQR' then Result := @T7DRQR   //20180310
   else if FName = 'FAMSET' then Result := @FAMSET
   else if FName = 'FORECLO' then Result := @FORECLO
   else if FName = 'USEDFRM' then Result := @USEDFRM
  // else if FName = 'WARNOFF' then Result := @WARNOFF
   else if FName = 'CLETTER' then Result := @CLETTER
   else if LeftStr(FName,5) = 'RC59#' then Result := @RC59
   else if FName = 'BARCODE' then Result := @BARCODE
   else if FName = 'T1032'   then Result := @T1032
   else if FName = 'T1032WS'   then Result := @T1032WS
   else if FName = 'T1132'   then Result := @T1132
   else if FName = 'T1134'   then Result := @T1134   //20230801
   else if LeftStr(FName,7) = 'T1134S#'   then Result := @T1134S   //20230801 Con
   else if FName = 'T1129'   then Result := @T1129
   else if FName = 'T1232'   then Result := @T1232
   else if FName = 'T1248'   then Result := @T1248    //20240212
   else if FName = 'T2200S'   then Result := @T2200S   //20230309
   else if FName = 'T10142'   then Result := @T10142
   else if FName = 'T1OVP'   then Result  := @T1OVP      //20170623
  // else if FName = 'T1B'     then Result := @T1B      //20240216

   else if LeftStr(FName,7)= 'T10142W'   then Result := @T10142W
   {Slips}
   else if LeftStr(FName,3) = 'T4#' then Result := @T4
   else if LeftStr(FName,7) = 'T4FHSA#' then Result := @T4FHSA  //20231207
   else if LeftStr(FName,4) = 'T4A#' then Result := @T4A
   else if LeftStr(FName,7) = 'T4ARCA#' then Result := @T4ARCA
   else if LeftStr(FName,5) = 'T4AP#' then Result := @T4AP
   else if LeftStr(FName,6) = 'T4RSP#' then Result := @T4RSP
   else if LeftStr(FName,6) = 'T4RIF#' then Result := @T4RIF
   else if LeftStr(FName,7) = 'T4AOAS#' then Result := @T4AOAS
   else if LeftStr(FName,5) = 'T4PS#' then Result := @T4PS
   else if LeftStr(FName,4) = 'T4E#' then Result := @T4E
   else if LeftStr(FName,7) = 'T3MULT#' then Result := @T3MULT
   else if LeftStr(FName,3) = 'T5#' then Result := @T5
   else if LeftStr(FName,7) = 'T5MULT#' then Result := @T5MULT
   else if LeftStr(FName,6) = 'T5007#' then Result := @T5007
   else if LeftStr(FName,6) = 'T5013#' then Result := @T5013
   else if LeftStr(FName,5) = 'T101#' then Result := @T101
   else if LeftStr(FName,5) = 'T102#' then Result := @T102
   else if LeftStr(FName,6) = 'T1204#' then Result := @T1204   //20190208
   else if LeftStr(FName,6) = 'T4SUM#' then Result := @T4SUM
   else if LeftStr(FName,7) = 'OPECGB#' then Result := @OPECGB
   
    //20241110
     //Credits}
   else if FName = 'ABMJ'   then Result := @ABMJ
   else if FName = 'BCMJ'   then Result := @BCMJ
   else if FName = 'MBMJ'   then Result := @MBMJ
   else if FName = 'NBMJ'   then Result := @NBMJ
   else if FName = 'NLMJ'   then Result := @NLMJ
   else if FName = 'ONMJ'   then Result := @ONMJ
   //20240531 //rename all
   else if FName = 'NSMJ'   then Result := @NSMJ
   else if FName = 'NTMJ'   then Result := @NTMJ
   else if FName = 'NUMJ'   then Result := @NUMJ
   else if FName = 'PEMJ'   then Result := @PEMJ
   else if FName = 'SKMJ'   then Result := @SKMJ
   else if FName = 'YTMJ'   then Result := @YTMJ

   (*
   {Credits}
   else if FName = 'ABMJWS'   then Result := @ABMJWS
   else if FName = 'BCMJWS'   then Result := @BCMJWS
   else if FName = 'MBMJWS'   then Result := @MBMJWS
   else if FName = 'NBMJWS'   then Result := @NBMJWS
   else if FName = 'NLMJWS'   then Result := @NLMJWS
   else if FName = 'ONMJWS'   then Result := @ONMJWS
   //20240531 //rename all
   else if FName = 'NSMJWS'   then Result := @NSMJWS
   else if FName = 'NTMJWS'   then Result := @NTMJWS
   else if FName = 'NUMJWS'   then Result := @NUMJWS
   else if FName = 'PEMJWS'   then Result := @PEMJWS
   else if FName = 'SKMJWS'   then Result := @SKMJWS
   else if FName = 'YTMJWS'   then Result := @YTMJWS
 *)
   else if FName = 'ONMTXWS'   then Result := @ONMTXWS
   else if FName = 'ON428'   then Result := @ON428
   else if FName = 'ON479'  then Result := @ON479
  // else if FName = 'ONSTAY'  then Result := @ONSTAY    //20240121
   else if FName = 'ON428A'  then Result := @ON428A    //20191121
   else if FName = 'ON479A'  then Result := @ON479A    //20191121
   else if FName = 'OEPTC'  then Result := @OEPTC
   else if FName = 'ONBEN'  then Result := @ONBEN
   else if FName = 'T1241'   then Result := @T1241
   else if FName = 'T1256'   then Result := @T1256
   else if FName = 'T12561'   then Result := @T12561
   else if FName = 'T1258'   then Result := @T1258
   else if FName = 'T1272'   then Result := @T1272
   else if FName = 'S2PRV'   then Result := @S2PRV
   else if FName = 'S11PRV'  then Result := @S11PRV
   else if LeftStr(FName,4) = 'S12#'  then  Result := @S12   //20161124
   else if FName = 'S12BC'   then Result := @S12BC
   else if FName = 'S12SK'   then Result := @S12SK   //20260103
   else if FName = 'BC428'   then Result := @BC428
   else if FName = 'BC479'   then Result := @BC479
   else if FName = 'NB428'   then Result := @NB428
   else if FName = 'NL428'   then Result := @NL428
   else if FName = 'NT428'   then Result := @NT428
   else if FName = 'NT479'   then Result := @NT479

   else if FName = 'PE428'   then Result := @PE428
   else if FName = 'MB479' then Result := @MB479
   else if FName = 'MB428' then Result := @MB428
  // else if FName = 'MB428WS' then Result := @MB428WS //20250918 Igor //20251224 cz
   else if FName = 'MBARTS' then Result := @MBARTS    //202601095cz
   else if FName = 'MBFITNES' then Result := @MBFITNES

   else if FName = 'SK428' then Result := @SK428
   else if FName = 'SK479' then Result := @SK479  //20211229
   else if FName = 'YT428'   then Result := @YT428
   else if FName = 'YT479'    then Result := @YT479
   else if FName = 'AB428'   then Result := @AB428
   else if FName = 'LN61545' then Result := @LN61545    //ab LN61545
   else if FName = 'NS428'   then Result := @NS428
   else if FName = 'NS479'   then Result := @NS479

   else if FName = 'T89'    then Result := @T89   //20241207
   else if FName = 'T90'    then Result := @T90
   else if FName = 'T224'   then Result := @T224
   else if FName = 'T225'   then Result := @T225

   else if FName = 'NSLS'    then Result := @NSLS
   else if FName = 'NU428'   then Result := @NU428
   else if FName = 'NU479'    then Result := @NU479
   else if FName = 'NL479'    then Result := @NL479  //20211123

   else if FName = 'YT432'  then Result := @YT432

  // else if FName = 'T1005'  then Result := @T1005  //20220130
   else if FName = 'T1014'  then Result := @T1014
   else if LeftStr(FName,8) = 'T10141W#' then Result := @T10141W
   else if LeftStr(FName,8) = 'T10142W#' then Result := @T10142W

 //  else if FName = 'T1284'  then Result := @T1284  //20171217
   else if FName = 'T1285'  then Result := @T1285

    {Schedules}

   else if FName = 'S2'     then Result := @S2

   else if FName = 'S2MJAB'     then Result := @S2MJAB  //20180326
   else if FName = 'S2MJBC'     then Result := @S2MJBC  //20180326
   else if FName = 'S2MJMB'     then Result := @S2MJMB  //20180326
   else if FName = 'S2MJNB'     then Result := @S2MJNB  //20180326
   else if FName = 'S2MJNL'     then Result := @S2MJNL  //20180326
   else if FName = 'S2MJNS'     then Result := @S2MJNS  //20180326
   else if FName = 'S2MJNT'     then Result := @S2MJNT  //20180326
   else if FName = 'S2MJNU'     then Result := @S2MJNU  //20180326
   else if FName = 'S2MJON'     then Result := @S2MJON  //20180326
   else if FName = 'S2MJPE'     then Result := @S2MJPE  //20180324
   else if FName = 'S2MJSK'     then Result := @S2MJSK  //20180326
   else if FName = 'S2MJYT'     then Result := @S2MJYT  //20180326

   else if FName = 'S3' then Result:= @S3
   else if LeftStr(FName,6) = 'S3ACB#' then Result:= @S3ACB

   // 20250912 Igor >>>
   else if LeftStr(FName, 7) = 'S3SUPL#' then Result:= @S3SUPL
   else if LeftStr(FName, 8) = 'S3QSUPL#' then Result:= @S3QSUPL
   // 20250912 Igor <<<

   else if FName = 'S4'      then Result := @S4
   else if FName = 'S5'     then Result := @S5
   else if FName = 'S5SUPL'  then Result := @S5SUPL  //20180120
   else if FName = 'S6'     then Result := @S6
   else if FName = 'S5PRV'   then Result := @S5PRV
   else if FName = 'S7'      then Result := @S7
   else if FName = 'S8'      then Result := @S8
   //else if FName = 'CPPADJ'  then Result := @CPPADJ
   else if FName = 'S8Q'     then Result := @S8Q
   else if FName = 'S9'    then Result := @S9
   else if FName = 'MEDREF'    then Result := @MEDREF
   else if FName = 'S11'     then Result := @S11
   else if FName = 'S13'     then Result := @S13
   else if FName = 'S15'     then Result := @S15  //20231207
  // else if FName = 'S14YT'     then Result := @S14YT //20251227
   {//20220103
   else if FName = 'S14ON'     then Result := @S14ON
   else if FName = 'S14SK'     then Result := @S14SK
   else if FName = 'S14MB'     then Result := @S14MB
   else if FName = 'S14AB'     then Result := @S14AB
   }
   else if FName = 'T1SALDIV'  then Result := @T1SALDIV  //20200821
   else if FName = 'HOMEBUY'     then Result := @HOMEBUY
   else if LeftStr(FName,7) = 'HOMEWS#'  then  Result := @HOMEWS   //jz//20260127 - NOT discontinued //20260106CZ disconttinued
   else if FName = 'AGEDED'   then Result := @AGEDED
   else if FName = 'DTC'   then Result := @DTC
   else if FName = 'CAREGVR'  then Result := @CAREGVR
   else if FName = 'CAREPRV'  then Result := @CAREPRV
   else if FName = 'SNRESA'  then Result := @SNRESA
   else if FName = 'SNRESB'  then Result := @SNRESB
   else if FName = 'SNRC'    then Result := @SNRC
   else if FName = 'CPT20'    then Result := @CPT20
    {Forms}
   else if LeftStr(FName,6) = 'T1013#'   then Result := @T1013
   else if FName = 'RC267'   then Result := @RC267
   else if FName = 'RC268'   then Result := @RC268
   else if FName = 'RC269'   then Result := @RC269
   else if FName = 'T1023'   then Result := @T1023
   else if FName = 'T183'  then Result := @T183
   else if FName = 'T185'  then Result := @T185   //20200212
   else if FName = 'T1A'   then Result := @T1A
   else if FName = 'T1DD'    then Result := @T1DD

   else if LeftStr(FName,4) = 'T1M#'   then Result := @T1M

   else if FName = 'T1033' then Result := @T1033
   else if FName = 'T2017'   then Result := @T2017
   else if FName = 'T2036' then Result := @T2036
   else if FName = 'T2038' then Result := @T2038
   else if FName = 'T2038I' then Result := @T2038I

   else if LeftStr(FName,6) = 'T2091#' then Result := @T2091
   else if LeftStr(FName,6) = 'T1255#' then Result := @T1255  //20180303
   else if FName = 'T209W' then Result := @T209W
   else if FName = 'T2097'   then Result := @T2097
   else if FName = 'T5004'   then Result := @T5004
   else if FName = 'T2202'   then Result := @T2202

   else if FName = 'T2203' then Result := @T2203

   else if FName = 'T1153'   then Result := @T1153

   else if FName = 'T1159'   then Result := @T1159
   else if FName = 'T1161' then Result := @T1161
   else if LeftStr(FName,6) = 'T1161#' then Result := @T1161
   else if LeftStr(FName,6) = 'T1243#' then Result := @T1243

   else if LeftStr(FName,6) = 'T1170#' then Result := @T1170
   else if FName = 'T1172' then Result := @T1172

   else if FName = 'T1198' then Result := @T1198

   else if FName = 'T1212' then Result := @T1212
   else if FName = 'T1221' then Result := @T1221
   else if FName = 'T1297' then Result := @T1297
   else if LeftStr(FName,6) = 'T1299#' then Result := @T1299

   else if FName = 'T1231'  then Result := @T1231
   else if FName = 'STATUS'  then Result := @STATUS
   else if FName = 'PTIMEWS'  then Result := @PTIMEWS
   else if FName = 'YRSUM'  then Result := @YRSUM

   else if FName = 'T1135'    then Result := @T1135
   else if FName = 'FPCHECK'  then Result := @FPCHECK
   else if FName = 'FPINFO'  then Result := @FPINFO
   else if FName = 'DIAGNO'  then Result := @DIAGNO
   else if FName = 'PTRANSIT'  then Result := @PTRANSIT
   else if FName = 'HOMEBUY'  then Result := @HOMEBUY
   //else if FName = 'SPORTS'  then Result := @SPORTS//20160119 Igor
   else if FName = 'FITNESS'  then Result := @FITNESS
  // else if FName = 'ARTS'  then Result := @ARTS  //20171216
   else if FName = 'T1ADJI'  then Result := @T1ADJI
   {Mult statements}
   else if LeftStr(FName,6) = 'ADOPT#'  then Result := @ADOPT
   else if LeftStr(FName,5) = 'RC62#'  then Result := @RC62
   else if LeftStr(FName,6) = 'T1ADJ#'  then Result := @T1ADJ
   else if LeftStr(FName,7) = 'ASSETS#' then Result := @ASSETS
   else if LeftStr(FName,6) = 'FLDMEM' then Result := @FldMem
   else if LeftStr(FName,7) = 'FLDTAPE' then Result := @FldTape

   else if LeftStr(FName,5) = 'T1139' then Result := @T1139

   else if FName = 'T1206' then Result := @T1206  //20181215

   else if LeftStr(FName,6) = 'AUTOS#'   then Result := @AUTOS
   else if LeftStr(FName,8) = 'ASSETSB#'   then Result := @ASSETSB
   else if LeftStr(FName,8) = 'AUTO777#'  then Result := @AUTO777
   else if LeftStr(FName,5) = 'FPENS'   then Result := @FPENS
   else if LeftStr(FName,6) = 'T2125#' then Result := @T2125

   else if LeftStr(FName,9) = 'T2125SUM#' then Result := @T2125SUM
   else if LeftStr(FName,9) = 'T2121SUM#' then Result := @T2121SUM
   else if LeftStr(FName,9) = 'T2042SUM#' then Result := @T2042SUM
   else if LeftStr(FName,9) = 'T1163SUM#' then Result := @T1163SUM
   else if LeftStr(FName,9) = 'T1273SUM#' then Result := @T1273SUM
   else if LeftStr(FName,8) = 'T776SUM#' then Result := @T776SUM

   else if LeftStr(FName,5) = 'T2209'  then Result := @T2209
   else if LeftStr(FName,5) = 'T2042' then Result := @T2042
   else if FName            = 'T2043' then Result := @T2043  //20230106
   else if LeftStr(FName,5) = 'T2043A' then Result := @T2043A  //20230106
   //20221215
  // else if FName = 'T2039' then Result := @T2039
   else if FName = 'T2043' then Result := @T2043  //20220416 if LeftStr(FName,5) = 'T2043' then Result := @T2043
   else if LeftStr(FName,6) = 'T2043A' then Result := @T2043A  //20220220

   else if LeftStr(FName,4) = 'MIA#'    then Result := @MIA


   else if LeftStr(FName,5) = 'T1163' then Result := @T1163

   else if LeftStr(FName,6) = 'T1175#' then Result := @T1175

   else if LeftStr(FName,7) = 'T1175H#' then Result := @T1175H

   else if LeftStr(FName,5) = 'T1275'    then Result := @T1275

   else if FName = 'T1279'  then Result := @T1279  //20231212

   else if LeftStr(FName,6) = 'T1273#' then Result := @T1273
   else if LeftStr(FName,7) = 'T1273A1' then Result := @T1273A1
   else if LeftStr(FName,7) = 'T1273A2' then Result := @T1273A2
   else if LeftStr(FName,8) = 'T1273OTH' then Result := @T1273OTH

   else if LeftStr(FName,5) = 'T2121' then Result := @T2121

   else if LeftStr(FName,4) = 'T776'  then Result := @T776

   else if LeftStr(FName,7) = 'ACBOTHR'  then Result := @ACBOTHR
   else if LeftStr(FName,6) = 'PORTFL'   then Result := @PORTFL
   else if LeftStr(FName,7) = 'ACBFRM#' then Result := @ACBFRM
   else if LeftStr(FName,7) = 'ACBSUM#' then Result := @ACBSUM
   else if LeftStr(FName,6) = 'FLTHRU'   then Result := @FLTHRU
   else if LeftStr(Fname,5) = 'NPAD#'     then Result := @NPAD
   else if LeftStr(Fname,5) = 'NPADC'    then Result := @NPADC
   else if LeftStr(Fname,6) = 'PRIVAT'   then Result := @PRIVAT
   else if LeftStr(Fname,7) = 'MEDSUPL'   then Result := @MEDSUPL
   else if LeftStr(Fname,7) = 'DONSUPL'   then Result := @DONSUPL
   {end multiples}
   else if FName = 'BUSSUM' then Result := @BUSSUM
   else if FName = 'RENTSUM' then Result := @RENTSUM
   {-----}

   else if FName = 'T2204'   then Result := @T2204
   else if FName = 'S10'     then Result := @S10
   else if FName = 'T2205'   then Result := @T2205
   else if FName = 'T2222' then Result := @T2222

   else if FName = 'T400A'   then Result := @T400A
 //  else if LeftStr(FName,4) = 'T626'  then Result := @T626   //20161119

   else if FName = 'T657'  then Result := @T657

   else if FName = 'T664'  then Result := @T664


   else if FName = 'T691'  then Result := @T691
   else if FName = 'T746'    then Result := @T746
   else if LeftStr(FName,5) = 'T777#'  then Result := @T777       //20200511
   else if LeftStr(FName,8) = 'T777MOB#'  then Result := @T777MOB   //20221211
  // else if LeftStr(FName,5) = 'T777S'  then Result := @T777S       //20210101

   else if FName = 'T778'  then Result := @T778

   else if FName = 'T79'     then Result := @T79
   else if FName = 'T81'     then Result := @T81
   else if FName = 'T929'  then Result := @T929

   else If FName = 'T936'  then Result := @T936

   else if LeftStr(FName,4) = 'TL2#'   then Result := @TL2
   {MISCELLANEOUS}
   else if LeftStr(FName,8) = 'CCAMULT#'  then Result := @CCAMULT
   else if FName = 'STLOAN'   then Result := @STLOAN
   else if FName = 'CCALIST' then Result := @CCALIST
   else if FName = 'TOOLEXP'  then Result := @TOOLEXP
   else if LeftStr(FName,6) = 'T5008#'   then Result := @T5008
   else if FName = 'UNIOND'   then Result := @UNIOND
   else if FName = 'MEDICAL'  then Result := @MEDICAL
   else if FName = 'MEDPRV'   then Result := @MEDPRV
   else if FName = 'DEPEND'   then Result := @DEPEND
   else if FName = 'OTHINC'   then Result := @OTHINC
   else if FName = 'OTHDED'   then Result := @OTHDED
   else if FName = 'INVOICE'    then Result := @INVOICE
   else if LeftStr(FName,7) = 'INVGEN#'    then Result := @INVGEN
   else if FName = 'INVFORMS'   then Result := @INVFORMS
   else if FName = 'ADDINFO'  then Result := @ADDINFO
   else if FName = 'TRANSF'    then Result := @TRANSF
   else if FName = 'PTRANSF'  then Result := @PTRANSF
   else if FName = 'DISAB18'  then Result := @DISAB18
   else if FName = 'ABIL'     then Result := @ABIL
   else if FName = 'AJCTC'    then Result := @AJCTC
   else if FName = 'DON'      then Result := @DON
   else if FName = 'DEATH'    then Result := @DEATH
   else if FName = 'TX19'     then Result := @TX19
   else if FName = 'DIRECT'   then Result := @DIRECT
   else if FName = 'PNSDED'   then Result := @PNSDED
   else if FName = 'RRSP'     then Result := @RRSP
   else if FName = 'RRSPNXT'  then Result := @RRSPNXT
   else if FName = 'RPP'      then Result := @RPP
   else if FName = 'BLANKPG'  then Result := @BLANKPG
   else if FName = 'REFILEV'  then Result := @REFILEV  //20170404

   else if FName = 'POLIT'    then Result := @POLIT
   else if FName = 'TAXSUM'   then Result := @TAXSUM
   else if FName = 'PRVSUM'   then Result := @PRVSUM
   else if FName = 'FAMSUM'   then Result := @FAMSUM
   else if FName = 'YRSUM2'   then Result := @YRSUM2
   else if FName = 'RC71'     then Result := @RC71
   else if FName = 'RC72'     then Result := @RC72
   else if FName = 'RC151'    then Result := @RC151  //20230330
   else if FName = 'RC201'    then Result := @RC201
   else if LeftStr(FName,5) = 'RC210'    then Result := @RC210
  // else if FName = 'RC310'    then Result := @RC310  //20170126
   else if LeftStr(FName,6) = 'RC359#'    then Result := @RC359
   else if FName = 'RC360'    then Result := @RC360

   else if FName = 'RC381'    then Result := @RC381
  // else if FName = 'RC381I'    then Result := @RC381I
   else if FName = 'RC383'    then Result := @RC383

   else if FName = 'GST370'   then Result := @GST370

   else if FName = 'MCREDIT'     then Result := @MCREDIT
   else if FName = 'GSTC'     then Result := @GSTC
   else if FName = 'CTB'      then Result := @CTB
   else if FName = 'PROVCTB'      then Result := @PROVCTB
   else if FName = 'FORINC'   then Result := @FORINC
   else if FName = 'BANKRPT'  then Result := @BANKRPT
   else if FName = 'CLAW'     then Result := @CLAW
   else if FName = 'CFR'    then Result := @CFR
   else if FName = 'OLDLOSS'  then Result := @OLDLOSS
   else if FName = 'RESINC'   then Result := @RESINC
   else if FName = 'T1223'  then Result := @T1223

   else if FName = 'T1229'    then Result := @T1229
   else if FName = 'DEPLEXP'  then Result := @DEPLEXP
   else if FName = 'EFADJ'    then Result := @EFADJ
   else if FName = 'EFDOC'    then Result := @EFDOC
   else if FName = 'T5006'  then Result := @T5006
   else if FName = 'EFMEMO'   then Result := @EFMEMO

   else if LeftStr(FName,6) = 'T2200#'  then Result := @T2200

   else if FName = 'T2201'   then Result := @T2201

  // else if FName = 'T2201H'   then Result := @T2201H

   else if FName = 'FECONV'  then Result := @FECONV
   else if FName = 'OPTIMIZE'  then Result := @OPTIMIZE
   else if FName = 'TESTFRM'   then Result := @TestFRM

   //sers //20240715 Igor >>>
    else if LeftStr(FName,6) = 'T2057#'  then Result := @T2057
    else if FName = 'T2054'  then Result := @T2054
    else if FName = 'T2058'  then Result := @T2058
    else if FName = 'T2059'  then Result := @T2059
    else if LeftStr(FName, 3) = 'UHT'  then Result := @UHT  //20250109
    //20240715 Igor <<<
    else if LeftStr(FName, 4) = 'T217' then Result := @T217 //20240723 Igor

    else if LeftStr(FName,6) = 'T2048#' then Result := @T2048   //jz//20260128 - adjust to make multi instance  //jz//20250401 - addded form
    else if FName = 'T24EOT' then Result := @T24EOT             //jz//20250401

    else if FName = 'T106' then Result:= @T106 //20251223 Igor
    else if LeftStr(FName, 7) = 'T106SL#' then Result:= @T106SL  //20251223 Igor

    else Result := @NothingToCalc; //dummy
    FRec.Calc := Result;
  end;

  FNo := FRec.FormNo;
  if (RetNo > 0) and (FNo > 0) then
  begin
    if (RetList[RetNo].MyApp = AppT1_2026) then //20160323 Igor
    Begin
      If  (Ret[RetNo].Frm[Fno].Count =0) then
        InitFormData(RetNo,FNo);
      FRec.Calc(RetNo,FName,FNo);
    End;
  end;
end;

procedure TRetT1_2026.Calc(RNo: integer; const FName: string;
  FNo: integer);
begin
(* When called from within WITH with a different RetNo,
  call the virtual method of THAT return.
*)
  if RNo = 0 then exit;
  if RNo = RetNo then
    T1_2026.Calc(RNo,FName)
  else
    RetList[RNo].Calc(RNo,FName);
end;

procedure TRetT1_2026.CalcAll;
begin
  T1_2026Calc.CALCALL(RetNo);
end;

procedure TRetT1_2026.CountDiagnostics;
begin
  T1_2026CntErr.CountDiagnostics(RetNo);
end;

function TRetT1_2026.GetReadOnly: Boolean; //20210115 Igor
begin
  Result := inherited GetReadOnly;
  if not Result then
    if IsVtClient and not SameText(FetchElm(RetNo, 'STATUS', 33), vtClientCreated) then
      Result := true;
end;

function TRetT1_2026.GetReturnCaption: string;
begin
  Result := T1_2026ChildWinNew.GetReturnCaption(RetNo);
end;

function TRetT1_2026.GetReturnName: string;
begin
  Result := T1_2026Common.GetRetName(RetNo);
end;

function TRetT1_2026.NewChild: TMyChild;
begin
  Result := TMyChildT1_2026.CreateNew(Application,RetNo);
end;

function TRetT1_2026.RefreshAuditPanel(ReturnsHeaderPanel: TPanel;
  ErrorView: TTreeView; AuditMode: eAuditMode): string;
begin
//RefreshAuditPanel, SuperAuditBoxClick
  case AuditMode of
  amStd:  Result := MainFormT1.RefreshAuditPanel(RetNo,ReturnsHeaderPanel, ErrorView,False);
  amSuperAudit: Result := MainFormT1.SuperAuditBoxClick(RetNo,ReturnsHeaderPanel, ErrorView);
  amSuperVericifcation: Result := MainFormT1.SuperVerificationBtnClick(RetNo,ReturnsHeaderPanel, ErrorView);
  end;
end;

function TRetT1_2026.DoSave: boolean;
begin
  Result := MainFormT1.DoSaveAllReturns(RetNo);
end;

procedure TRetT1_2026.DoSaveAs;
begin
  MainFormT1.FileSaveAsItemClick(nil);
end;

function TRetT1_2026.FormClass: TvtFormClass; //20161102 Igor
begin
  Result := TFormT1_2026;
end;


procedure TAppT1_2026.OpenClientBook; //20200916 Igor
var FSaveApp: TApp;
begin
  inherited;
  FSaveApp := CurrentApp;
  try
    CurrentApp := AppT1_2026;
    MainformT1.OpenReturnLblClick(nil);
  finally
    CurrentApp := FSaveApp;
  end;
end;

function TAppT1_2026.OpenForeignForm(const ADir, AFile, AForm: String;
  const AElement: Integer): TFormData;
var
  R, I: Integer;
  F: TvtForm;
begin
  R := -1;
  for I := 0 to RetList.Count - 1 do
    if Assigned(RetList[I]) and
       not RetList[I].Destroying and
       (RetList[I].MyApp = Self) and
       SameText(RetList[I].SourceDataDir, ADir) and
       SameText(RetList[I].SourceFlName, AFile) then
    begin
      R := RetList[I].RetNo;
      break;
    end;
  if R < 0 then
    R := T1_2026Common2.OpenReturn(ADir, AFile, False, False);
  if R <=0 then
    exit(nil);
  F := OpenForm(R, AForm, AElement);
  if Assigned(F) then
    Result := RetList[R].Form[AForm]
  else
    Result := nil;
end;

function TAppT1_2026.OpenReturn(DirName, FlName: string; fShow: boolean; AIsAppendix: Boolean = False): integer;
begin
  Result :=
  T1_2026Common2.OpenReturn(DirName,FlName, fShow, AIsAppendix);
end;

procedure TAppT1_2026.RebuildCorruptedDatabase;
var FRebuildForm: TRebuildT1_2026;
begin
  inherited;
  if MessageDlg(
      'T1 Database does not seem to be initialized properly and we need to rebuild it. Proceed now? ',
      mtWarning, [mbYes, mbNo], 0) <> mrYes then Exit;
  SysUtils.DeleteFile(OptRec.Dir_Cur + '\' + ClientsDbLite);
  FRebuildForm := TRebuildT1_2026.Create(nil);
  try
    FRebuildForm.OKBtnClick(nil);
  finally
    FRebuildForm.Free;
  end;
end;

procedure TAppT1_2026.ReloadMainMenu; //20180111 Igor
begin
  inherited;
  MainFormT1.ReloadMainMenu;
end;

function TAppT1_2026.ImportOneReturn(ADS: TDataSet; ASrcDir,
  ADstDir: String; var AErr: String; AOverride: Boolean): Boolean; //20160602 Igor  //20160615 Igor
begin
  Result := T1_2026TrimStr.ImportOneReturn(ADS, ASrcDir, ADstDir, AErr, AOverride); //20160602 igor //20160615 Igor
end;

procedure TAppT1_2026.InitFList;
begin
  inherited;
  if not assigned(FList) then
  begin
    T1_2026Declare.FList := TFListT1.Create(Self, FormsLimit, FieldsLimit, FormsDBLite, FormsTableLite);
    //Self.ConvertDataBase; //20171031 Igor
    T1_2026TrimStr.InitFormsTable;  {all forms available}
    T1_2026TrimStr.InitLastYearFormsTable;  {all forms available}
    T1_2026TrimStr.InitFeesTable;  //20110129
    InitLists;       {Forms and return lists}
    T1_2026TrimStr.LoadEditBoxProperties;
    InitColorTable;  {all colors available}
    InitConstants;
    InitBmps;
    T1013SubmittedFlName := TPath.Combine(AppDir, 'T1013-Submitted.xml');
    If OptRec.Dir_AutoFill.isEmpty then
      OptRec.Dir_AutoFill := TPath.Combine(AppDir, 'TddData');//20171031 Igor
  end;
end;

procedure TAppT1_2026.InitFormsTable;
begin
  inherited;
  T1_2026TrimStr.InitFormsTable;
end;

function TAppT1_2026.InitNewReturn(ForLoad: boolean): integer;
begin
  Result := T1_2026.CreateNewReturn;  //.InitNewReturn; // TRetT1_2026.Create(self);
end;

procedure TAppT1_2026.InitStorage;//20171031 Igor
var
  EtalonDir, S: String;
  procedure CopyIfNeed(AFileName: String);
  begin
    if not TFile.Exists(TPath.Combine(EtalonDir, AFileName)) then Exit; //20180503 Igor 
    if not TFile.Exists(TPath.Combine(AppDir, AFileName)) or
       (TFile.GetLastWriteTime(TPath.Combine(EtalonDir, AFileName)) > TFile.GetLastWriteTime(TPath.Combine(AppDir, AFileName))) then
      TFile.Copy(TPath.Combine(EtalonDir, AFileName), TPath.Combine(AppDir, AFileName), True);
  end;
begin
  EtalonDir := TPath.Combine(ExtractFilePath(Application.ExeName), AppId);
  if not SamePath(EtalonDir, AppDir) then
  begin
    ForceDirectories(AppDir);
    CopyIfNeed(FormsDBLite);
    CopyIfNeed(FormsFeesDBLite);
    CopyIfNeed(DictDBLite);
    for S in TDirectory.GetFiles(EtalonDir, '*.xml') do
      CopyIfNeed(ExtractFileName(S));
    for S in TDirectory.GetFiles(EtalonDir, '*.rtf') do
      CopyIfNeed(ExtractFileName(S));
    for S in TDirectory.GetFiles(EtalonDir, '*.qry') do
      CopyIfNeed(ExtractFileName(S));
    for S in TDirectory.GetFiles(EtalonDir, '*.d') do
      CopyIfNeed(ExtractFileName(S));
    for S in TDirectory.GetFiles(EtalonDir, '*.dfm') do
      CopyIfNeed(ExtractFileName(S));
    //20190115 Igor >>>
    for S in TDirectory.GetFiles(EtalonDir, '*.htm') do
      CopyIfNeed(ExtractFileName(S));
    for S in TDirectory.GetFiles(EtalonDir, '*.html') do
      CopyIfNeed(ExtractFileName(S));
    //20190115 Igor <<<
    //20200306 Igor >>>
    for S in TDirectory.GetFiles(EtalonDir, '*.db') do
      CopyIfNeed(ExtractFileName(S));
    //20200306 Igor <<<
  end;
end;

function TAppT1_2026.AllowAllFieldsForBuildReport: boolean; //20210121 Igor
begin
  Result :=True; //20230103 2// T1_2026TrimStr.IsTaxTown;
end;

function TAppT1_2026.isValidDataDir(const ADir: String): Boolean; //20170504 Igor
begin
  Result := T1_2026Features.IsDataDirectoryGood(ADir);
end;

function TAppT1_2026.GetAppRelease: string;
begin
  Result := T1_2026Declare.AppRelease;
end;

function TAppT1_2026.GetAppUpdateDate: string;
begin
  Result := T1_2026Declare.AppUpdateDate;
end;

function TAppT1_2026.GetAppYear: string;
begin
  Result := T1_2026Declare.AppYear;
end;

function TAppT1_2026.GetCourierClientDocumentsFolder: string; //20201019 Igor
var FRetNo: integer;
begin
  FRetNo := GetCurrentRetNo;
  if FRetNo = 0 then
    Result := OptRec.Dir_ClientDocs
  else
    Result := OptRec.Dir_ClientDocs + '\' + GetLastName(FRetNo) + ',' + GetFirstName(FRetNo);
end;

function TAppT1_2026.GetCourierRecipientEmail: string; //20201019 Igor //20201208 Igor
var FRetNo: integer;
begin
  inherited;
  if VirtualTaxOfficeInfo.AccountType = vtoPayer then
  begin
    Result := VirtualTaxOfficeInfo.TaxOffice.Email;
  end
  else
  begin
    FRetNo := GetCurrentRetNo;
    if FRetNo = 0 then Exit;
    Result :=  FetchElm(FRetNo, 'INFO', 140);
  end;
end;

function TAppT1_2026.GetCourierRecipientSalutation: string; //20201019 Igor //20201208 Igor
var FRetNo: integer;
begin
  inherited;
  if VirtualTaxOfficeInfo.AccountType = vtoPayer then
  begin
    Result := 'Dear ' + VirtualTaxOfficeInfo.TaxOffice.Contact;
  end
  else
  begin
    FRetNo := GetCurrentRetNo;
    if FRetNo = 0 then Exit;
    if FetchElm(FRetNo, 'INFO', 80) > '' then
      Result := 'Dear ' +
        ConvertToProper(FetchElm(FRetNo, 'INFO', 33)) + ' ' +
        ConvertToProper(FetchElm(FRetNo, 'INFO', 80))
    else
      Result := 'Dear ' +
        ConvertToProper(FetchElm(FRetNo, 'INFO', 33)) + ' ' +
        ConvertToProper(GetFirstName(FRetNo));
  end;
end;

function TAppT1_2026.SaveReturn(RetNo: Integer; DataDir, FlName: string; //20200914 Igor //20200916 Igor
  OverrideSW, UpdMostRecent, ATextFormat, AUpdateClientTable: boolean;
  AClouds: TArrayOfInteger): Integer;
var FSaveApp: TApp;
begin
  FSaveApp := CurrentApp;
  try
    CurrentApp := AppT1_2026;
    Result := T1_2026Common2.SaveReturn(RetNo, DataDir, FlName, OverrideSW, UpdMostRecent, ATextFormat, AUpdateClientTable, AClouds);
  finally
    CurrentApp := FSaveApp;
  end;
end;

procedure TAppT1_2026.SaveSingleOptions(const AOptionName, AValue: String; AOptionsFileName: String = ''); //20160617 Igor
begin
  inherited;
  T1_2026TrimStr.SaveSingleOption(AOptionName, AValue, AOptionsFileName);
end;

procedure TAppT1_2026.SelectFeatures;
begin
  MainFormT1.SelectFeatures;
end;
// 20160114 Igor

procedure TAppT1_2026.SetSilentRead(AValue: boolean); //20201223 Igor
begin
  inherited;
  if AValue then
    StartSilentRead
  else
    EndSilentRead;
end;

procedure TAppT1_2026.SetZoomCaption(AZoom: Integer);
begin
  MainFormT1.ZoomStr := IntToStr(AZoom)+'%';//20170825 Igor
end;

function TAppT1_2026.GetSubstituteLastYearForm(AFormName: String): String;
begin
  Result := SubstituteLastYearForm(AFormName);
end;

procedure TRetT1_2026.SetLastYearFile(const AValue: String);
begin
  T1_2026TrimStr.SetLastYearFile(Self.RetNo, AValue);
end;

procedure TRetT1_2026.SetLocked(const Value: boolean);
begin
  if IsLastYearReturn then //20160314
    FLocked := True
  else
    inherited SetLocked(Value); //20170307 Igor
end;

function TRetT1_2026.AddPageInstance(NonInstFormName,
  FormInst: string): integer;
begin
  Result := T1_2026Common2.AddPageInstance(RetNo, NonInstFormName,FormInst);
end;

function TRetT1_2026.InitFormData(FRec: TFRec): boolean;
var
  s, FName: string;
begin
  Result := inherited InitFormData(FRec); //assert Frm[FNo] created
  if not Result then
    exit; //something wrong
  //if False then  T1_2026Common2.InitFormData(RetNo,FNo);

   With {Ret[RetNo].}Frm[FRec.FormNo] do
   begin
      FName := FRec.FormName;
     If Fname = 'INFO' then
       begin
         Strings[1] := PrvLong[GetPrvIndex(OptRec.Nfl_Prov)];
         Strings[10] := OptRec.Nfl_City;
         Strings[14]:='';
         Strings[9] := '';
         Strings[7] :='';
         Strings[33] :='';
         Strings[43]:='';Strings[44] :='';
         Strings[31]:='';Strings[32]:=''; //cell phone
         s:=GetEfMethod;
         If s='EOL' then begin Strings[77]:='X';Strings[78]:='';Strings[79]:='';end
         else if s='EOLP' then begin Strings[77]:='';Strings[78]:='X';Strings[79]:='';end
         else if s='PROP' then begin Strings[77]:='';Strings[78]:='';Strings[79]:='X';end;
       end;

     If Fname = 'STATUS' then
       begin
        Strings[15]:='00'; {prpst}
        Strings[4]:='00';  {efSt}
       end;
   end; {with}
end;

function TRetT1_2026.IsLetterForm(AFormName: String): Boolean;
begin
  Result := T1_2026TrimStr.IsFormAClientLetter(AFormName);
end;

procedure TRetT1_2026.CalcFullReturn;
begin
  T1_2026Calc.CalcFullReturn(RetNo);
end;

procedure TRetT1_2026.ReCalcEveryThing;
begin
  T1_2026T1Rtns.RecalcEverything(RetNo);
end;

procedure TRetT1_2026.StartPrintForm(FormName: String; WhichPage: integer);
begin
  MainFormT1.StartPrintForm(RetNo,FormName,WhichPage);
end;

function TRetT1_2026.SubstituteForm(AFormName: String): String; //20161101 Igor
begin
  Result := T1_2026T1rtns.SubstituteForm(FRetNo, AFormName);
end;

procedure TRetT1_2026.CloneForm(FromFormName: string; ToRetNo: integer;
  ToFormName: String; fAll: boolean);
var
  i,FromFNo, ToFNo: integer;
  FRec: TFRec;
begin
  ToFNo := GetFormNo(ToFormName);
  FRec := FList.ByFormName(FromFormName);
  FromFNo := FRec.FormNo;

  if fAll then
    inherited
  else
//clone special forms
  //if (FromFNo < 1) or not FrmHasData[FromFNo] then exit; //empty form
  If LeftStr(FRec.FormInstName,6)='T2125#' then //20170131 Igor
  begin
    inherited CloneForm(FromFormName, ToRetNo, ToFormName, False);
    for i := 1 to FRec.FormFields do
    begin
      case i of
      207..215, 275,
    //20110406
      272, 255, //bus use
      231, //c/f last year
      109: //GST rebate  //20110513
        ; //skip it
      else //case
        Ret[ToRetNo].Frm[ToFNo].strings[i] := Frm[FromFNo].Strings[i];
      end;
    end
  end
  else
  If LeftStr(FromFormName,6)='T2042#' then
  begin
    inherited CloneForm(FromFormName, ToRetNo, ToFormName, False);
    for i := 1 to FRec.FormFields do
    begin
      case i of
      147, //bus use     //20110406
      676, 630, //20110406
      632, //c/f from last yr     //20110406
      605..610,
      155,  //GST rebate  //20110513
      681,682,612:
        ; //skip it
      else //case
        Ret[ToRetNo].Frm[ToFNo].strings[i] := Frm[FromFNo].Strings[i];
      end;
    end
  end
  else
  If LeftStr(FromFormName,6)='T2121#' then
  begin
    inherited CloneForm(FromFormName, ToRetNo, ToFormName, False);
    for i := 1 to FRec.FormFields do
    begin
      case i of
      101..106,
      281, 282, 108,
      278, 126, //Bus use % 20110406
      128, //c/f 20110406
      10: //GST rebate  //20110513
        ; //skip it
      else //case
        Ret[ToRetNo].Frm[ToFNo].strings[i] := Frm[FromFNo].Strings[i];
      end;
    end
  end
  else   //20110507
  If LeftStr(FromFormName,6)='T1163#' then
  begin
    inherited CloneForm(FromFormName, ToRetNo, ToFormName, False);
    for i := 1 to FRec.FormFields do
    begin
      case i of
      20, //c/f 20110406
      634,
      679: //GST rebate  //20110513
        ; //skip it
      else //case
        Ret[ToRetNo].Frm[ToFNo].strings[i] := Frm[FromFNo].Strings[i];
      end;
    end
  end
  else   //20110507
  If LeftStr(FromFormName,6)='T1273#' then
  begin
    inherited CloneForm(FromFormName, ToRetNo, ToFormName, False);
    for i := 1 to FRec.FormFields do
    begin
      case i of
      20,  //c/f 20110406
      634,
      966: //GST rebate  //20110513
        ; //skip it
      else //case
        Ret[ToRetNo].Frm[ToFNo].strings[i] := Frm[FromFNo].Strings[i];
      end;
    end
  end;
//finish
  Ret[ToRetNo].Calc(ToRetNo,ToFormName, ToFNo); //Lnn[]
  Ret[ToRetNo].FormHasData[ToFormName]:=True;
end;

procedure TRetT1_2026.CloneReturn(ToRetNo: integer);
begin
  inherited;
{copy other data}
  Ret[ToRetNo].EFStatus := EFStatus;
  Ret[ToRetNo].MarStatus := MarStatus;
  Ret[ToRetNo].Age := Age;
  Ret[ToRetNo].Deceased := Deceased;
  Ret[ToRetNo].Bankrupt := Bankrupt;
end;

//20160314 Igor
//procedure TRetT1_2026.SetIsLastYearRetNo(const Value: Boolean);
//begin
//  FIsLastYearRetNo := Value;
//end;

function TRetT1_2026.GetFirstName: string;
begin
  result := RTrim(FetchElm(RetNo,'INFO',2));
end;

function TRetT1_2026.GetLastName: string;
begin
  result := RTrim(FetchElm(RetNo,'INFO',5));
end;

function TRetT1_2026.GetSIN: string; //20170328 Igor
begin
  Result := GetSinNo(Self.RetNo);
end;

function TRetT1_2026.GetCloudFileName: String; //20190312 Igor
begin
  //Result := GetDefaultFileName; //20200914 Igor
  Result := GenerateCloudFileName(GetSIN, GetLastName, GetFirstName, '1'); //20200914 Igor //20200921 Igor
end;

function TRetT1_2026.GetDCN: string; //20170328 Igor
begin
  Result := FetchElmFNo(GetFormNo('T183'), 21);
end;

function TRetT1_2026.GetLastYearFile: String; //20160701 Igor
begin
  Result := T1_2026TrimStr.GetLastYearFile(Self.RetNo);
end;

function TRetT1_2026.GetInterpetedRichEdit(LetterName: String;
  ARichEdit: TRichEdit): boolean;
//Procedure GetInterpetedRichEdit(RetNo:Integer;LetterName:String;ARichEdit:TRichEdit);
//Procedure GetInterpetedRichEdit(RetNo:Integer;LetterName:String;Var ARichEdit:TwwDbRichEdit);
Var i,j:integer; ErrorC : boolean;txt:string;
   Memo1:TMemo;KeyWList:TStringList;
   TempFileName :String;
   EkRtf1:TEkRtf;
   AStream:TMemoryStream;
   KeyW:String;
   FName,FName1:String;
   Elm:Integer;
   IsAmount:String;
   LineNumber:Integer;
   Args:TEkUdfArgs;
   ArgCount:Integer;
   aResult:TEkReportVariable; //TObject;

   OldVisible: Boolean;//20170410 Igor
Begin
  Result := False;
 if Not FileExists(LetterName) then
 begin
  UserMsg('Template '+LetterName +' was not found');
  Exit;
 end;
 //ARichEdit.ReadOnly:=False;
 //20170410 igor >>>
 OldVisible := ARichEdit.Visible;
 if OldVisible then
   ARichEdit.Visible:=False;
 ARichedit.LoadFromFile(LetterName);
 //20170410 Igor <<<

 KeyWList:=TStringList.Create;
 //20170410 Igor>>>
 //LoadDataDict;
 GetKeyWListFromRichEdit(MyApp.LoadDataDict, ARichEdit, KeyWList);
 //20170410 Iogr<<<

 KeyWList.SaveToFile(AppDir+'\'+'Temp1.txt');
 
 With MainFormT1.EkRtf1 do
 begin
      ClearVars;
      For i:=0 to KeyWList.Count-1 do
      begin
       KeyW:=KeyWList[i];
       GetKeyWAttributes(KeyW,FName,Elm,IsAmount);
       FormatSettings.DecimalSeparator:='.'; // 20150727
       If UpperCase(LeftStr(IsAmount,1))='Y' then
        CreateVar(KeyW,Vl(FetchElm(RetNo,FName,Elm)))

       else If KeyW='Date' then CreateVar(KeyW,DateToMonthDayYear(Date))

       else If LeftStr(KeyW,5)='Line_' then
        begin
         IsAmount:='Y';
         if Length(KeyW)=8 then  LineNumber:=StrToInt(RightStr(KeyW,3));
         if Length(KeyW)=9 then  LineNumber:=StrToInt(RightStr(KeyW,4));
         if Length(KeyW)=10 then  LineNumber:=StrToInt(RightStr(KeyW,5)); //20190709 Igor
          CreateVar(KeyW,Ret[RetNo].Lnn[LineNumber]);
        end

       else If KeyW='This_TaxYear' then CreateVar(KeyW,AppYear)
       else If KeyW='Next_TaxYear' then CreateVar(KeyW,IntToStr(StrToInt(AppYear)+1))

       else If LeftStr(KeyW,5)='Form_' then
        begin
         IsAmount:='';
         FName1:=UpperCase(AllTrim(MidStr(KeyW,6,10)));
         If FormHasInstanceIndicator(RetNo, FName1) then
           FName1:=FName1+'#1';
         If GetFormNo(FName1)>0 then
         begin
           If Ret[RetNo].FormHasData[FName1] then
             CreateVar(KeyW,'Y')  //Form =Yes meaning has data
           else
             CreateVar(KeyW,'N');
         end;
        end  //form_
       Else
       begin
        If ((KeyW='Client_FirstName')
         or (KeyW='Client_LastName')
         or (KeyW='Client_Street')
         or (KeyW='Client_City')
         or (KeyW='Client_Title')
         or (KeyW='Client_Salute'))  then
         begin
          If OptRec.UseProperName then CreateVar(KeyW,ConvertToProper(FetchElm(RetNo,FName,Elm)))
          else
           CreateVar(KeyW,FetchElm(RetNo,FName,Elm));
         end

        //20130421
        else If LeftStr(KeyW,9)='Preparer_' then
        Begin
          If KeyW='Preparer_Name'     then CreateVar(KeyW,OptRec.Prp_Name);
          If KeyW='Preparer_Address1' then CreateVar(KeyW,OptRec.Prp_Street);
          If KeyW='Preparer_Address2' then CreateVar(KeyW,OptRec.Prp_City+', '+OptRec.Prp_Prov+', '+OptRec.Prp_Postal);
          If KeyW='Preparer_Area'     then CreateVar(KeyW,OptRec.Prp_Area);
          If KeyW='Preparer_Phone'    then CreateVar(KeyW,OptRec.Prp_Tel);
        end
        Else
         CreateVar(KeyW,FetchElm(RetNo,FName,Elm));
       end;
      end;

      //NOW REPLACE $+brackets with slashes and currency function for EKRTF formating
      InsertBackFunction(ARichEdit, '$[', ']', ', 2)]') ;
      InsertBackFunction(ARichEdit, '$ [', ']', ', 2)]') ;

      ReplaceRtfDelimiters(ARichEdit, '$[' , '[fcur(' );
      ReplaceRtfDelimiters(ARichEdit, '$ [' , '[fcur(' );


      //NOW REPLACE brackets with slashes for EKRTF
      //and Put the display FIXR for formatting before streaming it
      ReplaceRtfDelimiters(ARichEdit,'[',KeyWDelimiter1);
      ReplaceRtfDelimiters(ARichEdit,']',KeyWDelimiter2);
      //AddDisplayFormatToRTF(ARichEdit, KeyWList); //20170410 Iogr (Empty proc)
      //20170410 Igor >>>
      if OldVisible then
        ARichEdit.Visible:=True;
      //20170410 Igor <<<
      KeyWList.Free;

      ARichEdit.Lines.SaveToFile(AppDir+'\'+'TempRtf.rtf'); //20160819 Igor
      InFile:=AppDir+'\'+'TempRtf.rtf'; //LetterName; //20160819 Igor
      Result := True; //assume okay
      AStream:=TMemoryStream.Create;
      Try
       ExecuteStream([],AStream);
       ARichEdit.Lines.LoadFromStream(AStream);
      Except //on e: Exception do ExceptMsg(e);
        Result := False;
      end;
      AStream.Free;
 end; //with
end;

{ TFListT1 }

function TFListT1.LoadFromTable(Table1: TDataSet): TFRec;
begin
  Result := TFRec.Create;
  Result.FormNo      := Table1.FieldByName('FormNo').AsInteger;
  Result.FormName    := UpperCase(Ltrim(RTrim(UpperCase(Table1.FieldByName('FormName').AsString))));
  Result.FormInst    := LTrim(RTrim(Table1.FieldByName('FormInst').AsString));
  Result.FormMxInst  := Table1.FieldByName('FormMxInst').AsString;
  Result.FormDescr   := Table1.FieldByName('FormDescr').AsString;
  Result.FormMxPg    := Table1.FieldByName('FormMxPg').AsInteger;
  Result.FormRlNm    := Table1.FieldByName('FormRlNm').AsString;
  Result.FormAbrev   := Table1.FieldByName('FormAbrev').AsString;
  Result.FormType    := Table1.FieldByName('FormType').AsString;
  if Table1.FieldByName('FormShow').DataType = ftBoolean then
     Result.FormShow    := Table1.FieldByName('FormShow').AsBoolean
  else
     Result.FormShow    := Boolean(Table1.FieldByName('FormShow').AsInteger);//20150916 - convert

  Result.FormFields  := Table1.FieldByName('FormFields').AsInteger;
  If Result.FormFields = 0 then Result.FormFields := FieldsLimit;

  if Table1.FieldByName('IsSlip').DataType = ftBoolean then
     Result.IsSlip    := Table1.FieldByName('IsSlip').AsBoolean
  else
     Result.IsSlip    := Boolean(Table1.FieldByName('IsSlip').AsInteger);//20150916 - convert

  Result.DataIndic   := Table1.FieldByName('DataIndic').AsString;

  if Table1.FieldByName('WhiteBoxes').DataType = ftBoolean then
     Result.WhiteBoxes    := Table1.FieldByName('WhiteBoxes').AsBoolean
  else
     Result.WhiteBoxes    := Boolean(Table1.FieldByName('WhiteBoxes').AsInteger);//20150916 - convert

  if Table1.FieldByName('ShowFlag').DataType = ftBoolean then
     Result.ShowFlag    := Table1.FieldByName('ShowFlag').AsBoolean
  else
     Result.ShowFlag    := Boolean(Table1.FieldByName('ShowFlag').AsInteger);//20150916 - convert

  if Table1.FieldByName('ShowHdr').DataType = ftBoolean then
     Result.ShowHdr    := Table1.FieldByName('ShowHdr').AsBoolean
  else
     Result.ShowHdr    := Boolean(Table1.FieldByName('ShowHdr').AsInteger);//20150916 - convert

  if Table1.FieldByName('LandScape').DataType = ftBoolean then
     Result.LandScape    := Table1.FieldByName('LandScape').AsBoolean
  else
     Result.LandScape    := Boolean(Table1.FieldByName('LandScape').AsInteger);//20150916 - convert

     //?
  //Result.Preload     := Table1.FieldByName('Preload').As Boolean;
  //Result.PrnSeq      := Table1.FieldByName('PrnSeq').AsString;
    {20110129
    FormRecord.Fee         := Table1.FieldByName('Fee').AsString;
    FormRecord.HowCharged  := Table1.FieldByName('HowCharged').AsString;
    FormRecord.AddnlForm   := Table1.FieldByName('AddnlForm').AsString;
    FormRecord.Each_Item   := Table1.FieldByName('Each_Item').AsString;
    }
  Result.CursorPos   := Table1.FieldByName('CursorPos').AsInteger;
  Result.FormHeight  := Table1.FieldByName('FormHeight').AsInteger;
  Result.AddBlankPg  := StringToBoolean(Table1.FieldByName('AddBlankPg').AsString);
  Result.AddInT1C    := StringToBoolean(Table1.FieldByName('AddInT1C').AsString);
end;

function TAppT1_2026.GetDefaultOptions: TStringList;
begin
  result := T1_2026TrimStr.GetDefaultOptions;
end;

function TAppT1_2026.GetDefaultOptionsValue(AOptionName: String): String;
begin
  result := T1_2026TrimStr.GetDefaultOptionsValue(AOptionName);
end;

function TAppT1_2026.GetOptionsCaption(AOptionName: String): String;
begin
  result := T1_2026TrimStr.GetOptionsCaption(AOptionName);
end;

function TAppT1_2026.GetDfmFileName(const FormName: string): string;
begin
  Result:=T1_2026ChildWinNew.GetDfmFileName(FormName);
end;

function TAppT1_2026.GetDfmFileNameLY(const FormName: string): string; //20160321 Igor
begin
  Result:=T1_2026ChildWinNew.GetLastYearDFMFileName(FormName);
end;

function TAppT1_2026.GetEfilerNumber: string; // 20180712 Igor
var OnlineNo, Password, Url, NetFileDir: string;
begin
  GetEOLParms(OnlineNo, Password, Url, NetFileDir);
  Result := OnlineNo;
end;

function TAppT1_2026.GetExportForms: TExportForms; //20161229 Igor
begin
  Result := T1_2026Declare.ExportForms;
end;

function TAppT1_2026.GetHelpFile: String;
begin
  Result := 'http://www.visualtax.com/VtHELP/T1Help/Website/T1Help.html'; //20161220 Igor
end;

function TAppT1_2026.GetHelpUpdFile: String;
begin
  Result := 'http://visualtax.com/Vt2019HELP/T1Help/T1UPD/T1UpdHlp.html'; //20171205 Igor
end;

function TAppT1_2026.GetInitLastYear: Boolean;
begin
  if Assigned(FLastYearList) then
    Result := True
  else
  Begin
    InitLastYearFormsTable;
    result := Assigned(FLastYearList);
  End;

end;

function TAppT1_2026.GetLastYearDataFolder: String; //20160302 Igor
begin
  if Dir_LastYr[length(Dir_LastYr)] = '\' then   //20160424 Igor
    Delete(Dir_LastYr,length(Dir_LastYr)-1,1);
  Result := Dir_LastYr;
end;

function TAppT1_2026.GetLastYearFormNo(AFormName: String): Integer; //20160302 Igor
begin
  Result := T1_2026TrimStr.GetLastYearFormNo(AFormName);
end;

function TAppT1_2026.GetLimitedVersionDir: String; //20160718 Igor
begin
  result := T1_2026Declare.LimitedVersionDir;
end;

function TAppT1_2026.GetLimitReturns: Integer;//20170901 Igor
begin
  case self.LicenseLevel of
  //20171031 Igor>>>
    llLimited, llLimEfile: Result := LimitedVersionReturns;
    llHome: result := NetFileVersionReturns;
  //20171031 Igor<<<
  else
    Result := inherited GetLimitReturns;
  end;
end;

{ TRetT1_2011 }

constructor TRetT1_LastYear.Create(TheApp: TApp);
begin
  FList := FLastYearList;
//  Create(TheApp); //  inherited; //20160305 Igor
  inherited Create(TheApp); //20160302 Igor
//  FIsLastYearRetNo := True;  //--> ShowUnconvertedLastYear //20160314 Igor
  FIsLastYearReturn := True; //20160314 Igor
end;

function TAppT1_2026.HaveOptions(AOptionsName: String): Boolean; //20170112 Igor
begin
  Result := T1_2026TrimStr.HaveOptions(AOptionsName);
end;

procedure TAppT1_2026.HelpOnClientLetter;
begin
  ShowHelp(AppT1_2026.ModuleHelpFile,'Cletr', True); //20161220
end;

initialization

{$IFDEF isbpl}
   Classes.RegisterClass(TAppT1_2026);        // 20151118 Igor
{$ELSE}
//   AppT1_2026 := TAppT1_2026.Create(AppList); //20170927 Igor
{$ENDIF}

end.

