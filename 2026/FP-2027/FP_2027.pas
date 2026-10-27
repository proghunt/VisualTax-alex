unit FP_2027;

interface

uses Classes,Controls,ComCtrls,Forms,Menus,ExtCtrls,DB,vtMulti,vtForm,
  vtChild,FP_2027Declare,
  IOUtils, //20180503 Igor
  rxRichEd; //20160819 Igor (Must be last)

const //update every year
//license keys
//20xx F2 factors (inc every year)
  FPF2_2025 = 60; //20280827 Alex

//these are the 2019 factors  //20150731
  PgmLicenses: array[0..8] of RPgmLicenseData = ( //20231211 Igor
    //20280827 Alex >>>
    (Name:'FP Demo';        Id:'FP00'; Factor:62; Level:llDemo), //20160223 Igor //20240905 Igor
    (Name:'FP Limited';     Id:'FP01'; Factor:63; Level:llLimited), //20160223 Igor //20240905 Igor
    (Name:'FP Standard';    Id:'FP02'; Factor:64; Level:llStd), //20160223 Igor //20240905 Igor
    (Name:'FP Power';       Id:'FP03'; Factor:65; Level:llPower), //20160223 Igor //20240905 Igor
    (Name:'FP AgStandard';  Id:'FP04'; Factor:66; Level:llAgStd), //20160223 Igor //20240905 Igor
    (Name:'FP AgPower';     Id:'FP05'; Factor:67; Level:llAgPower), //20160223 Igor //20240905 Igor
    (Name:'FP Dealer';      Id:'FP06'; Factor:68; Level:llDealer), //20160223 Igor //20240905 Igor
    (Name:'FP Enterprise';  Id:'FP07'; Factor:69; Level:llEnterprise), //20231211 Igor //20240905 Igor
  //dummy for invalid license
    (Name:'Unlicensed'; Id:''; Factor:0; Level:llNone; Caps:[])
    //20280827 Alex <<<
  );


type
  TFListFP = class(TFList)
  protected
    function LoadFromTable(Table1: TDataSet): TFRec; override;//20150918 Igor
  end;

type
  TAppFP_2027 = class(TApp2018)
  private
  {inherited
   ActiveBoxColor      : String[20];
   NoTypeAhead         : Boolean;
   DataInBold          : Boolean;
   DecimalAssume       : Boolean;
   Dir_Cur      : String[80];   //20120201  from 70
  }
  {shared
   FormZoom            : Integer;
   HideMostRecent      : Boolean;
   UpdateFrequency     : String[3];
   Prn_LMargin : String[4];
   Prn_RMargin : String[4];
   Prn_FontIncr: String[1];
  }
  public //options
  //from AOptRec = Record
  //20161117 Igor >>>
   //Dir_Deflt    : String;//[70]; //20170310 Igor
   Dir_LastYr   : String;//[70];
   Dir_PgmLastYr: String; //20160321 Igor
   T1DataDir    : String;//[80];
  // Dir_Planner  : String[70];
   Dir_PrvLYr   : String;//[70];
   BackUpDir    : String;//[70];
   LastBackupDir   : String;//[70];
   BackupFrequency : String;//[3];

   Dir_Train    : String;//[40];
   Dir_Sample   : String;//[40];

   Reviewer_Name: String;//[50];
   //Prp_EMail    : String;//[50]; //20190523 Igor
   Prp_BusNo    : String;//[15];
   //Prp_RepId    : String[7];
   Reviewer_EMail : String;//[50];
   // 20180712 Igor >>>
   //Prp_Name     : String;//[50];
   //Prp_Street   : String;//[30];
   //Prp_City     : String;//[30];
   Prp_Prov     : String;//[2];
   //Prp_Postal   : String;//[8];
   // 20180712 Igor <<<
   Prp_Countr   : String;//[8];
   //Prp_Area     : String;//[3]; //20190523 Igor
   Reviewer_Area: String;//[3];
   //Prp_Tel      : String;//[8]; //20190523 Igor
   Reviewer_Tel : String;//[8];
   Prp_FxArea   : String;//[3];
   Prp_Fax      : String;//[8];
   Prp_DiscNo   : String;//[10];
   Prp_DiscNm   : String;//[30];
   Prp_GSTNo    : String;//[17];
   Prp_Bill     : String;//[1];
   Prp_VSFee    : Integer;
   Prp_SFee     :Integer;
   Prp_AFee     :Integer;
   Prp_CFee     :Integer;
   Prp_VCFee    :Integer;
   Prp_GSTRat   : String;//[5];
   //Prp_Kstrk    :Real;
   Prp_Hour     :Real;
   Prp_Elect    :Boolean;
   Prp_EfRepr   :Boolean;
   Prp_Dates    :Boolean;

   Nfl_Prov     : String;//[2]; {New File defaults}
   Nfl_City     : String;//[20];
   Nfl_Disced   : String;//[1];
   Nfl_Efile    : Boolean;

   //Prn_Shade   : Boolean;
   Prn_Head    : Boolean;
   Prn_NameH   : Boolean;
   Prn_SinH    : Boolean;
   Prn_DateH   : Boolean;
  // Prn_Disclm  : String[80];
   Prn_logoln  : integer;
   Opr_Recalc  : Boolean;
   Opr_Close   : Boolean;
   Opr_FPres   : Integer;
   Opr_GstHst  : Real;
   //other options
   ShowTreeViewSW      : Boolean;
   ShowConsultantOnInv : Boolean;
   UseFastPrint        : Boolean;
   UseProperName       : Boolean;
   UseFormSearch       : Boolean;
   ShowVisitedForms    : Boolean;
   ShowInvoiceWarning  : Boolean;
   FirstReturnColor    : String;//[20];

   InvFoot1            : String;//[100];
   InvFoot2            : String;//[100];
   InvFoot3            : String;//[100];
   InvFoot4            : String;//[100];
   InvFoot5            : String;//[100];

   NoBarCode           : Boolean;
   Capitalization      : String;//[20];
   //20161117 Igor <<<
  protected
  //must override
    function GetAppName: string;  override;
    function GetAppDir: string; override; //20180503 Igor
    function GetAppRelease: string;  override;
    function GetAppUpdateDate: string;  override;
    function GetAppYear: string;  override;
    function GetSQLLitePassword(const Version: Integer = GC_SQLLitePasswordVersion): String; override; //20160226 Igor //20160303
    function GetSQLLiteRFPassword(const Version: Integer = GC_SQLLitePasswordVersion): String; override; //20160415 Igor
    function GetValidLastYearPgmFolder: Boolean; override; //20160302 Igor
    function GetValidLastYearDataFolder: Boolean; Override; //20160302 Igor
    function GetLastYearFormNo(AFormName: String): Integer; override; //20160302 Igor
    function GetSubstituteLastYearForm(AFormName: String): String; override; //20160302 Igor
    function GetLastYearDataFolder: String; override; //20160302 Igor
    function GetHelpFile: String; override; //20160526 Igor
    function GetHelpUpdFile: String; override; //20160526 Igor
    function GetInitLastYear: Boolean; Override; //20160704 Igor
    function GetDfmFileName(const FormName: string): string; override;
    function GetDfmFileNameLY(const FormName: string): string; override; //20160321 Igor
    function GetLimitedVersionDir: String; override; //20160718 Igor
    procedure CreateDefaultDataDirectories; override;//20170803 Igor
    function GetRightTabSheets: TRightTabSheets; Override;//20180311
    //20180503 Igor >>>
    procedure InitStorage;
    function Factor2: Byte; override;
    //20180503 Igor <<<
  public
    constructor Create (AppList: TAppList); override; // 20151118 Igor
    destructor Destroy; override; //debug only
  //implement abstract methods
    function  GetMenu: TMainMenu; override;
    function  GetToolBar: TControl; override;//20170824 Igor
    function  GetSplash: TCustomControl; override;
    procedure SelectFeatures; override;
    //20160114 Igor
    procedure SetZoomCaption(AZoom: Integer); override;
    procedure FrmTreeCustomNodeClick(ANode: TTreeNode); override; //20160323 Igor
    //20180424 Igor >>>
    function AllowFormForBuildReport(const AFormName: String): Boolean; override;
    function MaskFormDataForBuildReport(const AFormName: String; AFieldNo: Integer;
      AFieldValue: String): String; override;
    //20180424 Igor <<<
    procedure ReloadMainMenu; override; //20190307 igor
  public //licenses
    //Procedure GetLicenseLevel; virtual;
    function  Licenses: PPgmLicenseData; override;
    //procedure SetLicense(const Key: string);
    function  ValidateKey(AKey: String): boolean; override;
  public //cross-app adds
    function  InitNewReturn(ForLoad: boolean = False): integer; override;
    function  OpenReturn(DirName,FlName: string; fShow: boolean; AIsAppendix: Boolean = False): integer; override; //20160305 Igor
    function SaveReturn(RetNo: Integer; DataDir: string; FlName: string;
      OverrideSW: boolean; UpdMostRecent: boolean; ATextFormat: boolean = False;
      AUpdateClientTable: boolean = True; AClouds: TArrayOfInteger = nil): Integer; override; //20200914 Igor //20200916 Igor
    function OpenForeignForm(const ADir, AFile, AForm: String; const AElement: Integer): TFormData; override; //20170717 Igor
    function CheckLastYearPgmFolder(out AErrorMessage: String): Boolean; override; //20160516 Igor
    function CheckLastYearDataFolder(out AErrorMessage: String): Boolean; override; //20160516 Igor
    function GetDefaultOptionsValue(AOptionName: String): String; override; //20160530 Igor
    function GetOptionsCaption(AOptionName: String): String; override; //20160530 Igor
    function HaveOptions(AOptionsName: String): Boolean; override; //20170112 Igor
    function GetDefaultOptions: TStringList; override; //20160530 Igor
    procedure InitFList; override; //20160531 Igor
    procedure LoadOptionsFileToMem; override; //20160530 Igor
    procedure SaveSingleOptions(const AOptionName, AValue: String; AOptionsFileName: String = ''); override; //20160602 Igor //20160617 Igor
    function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String; //20160627 Igor
      var AErr: String; AOverride: Boolean): Boolean; override;
    procedure OpenClientBook; override; //20200916 Igor
  end;

  TRetFP_2027 = class(TRetData)
  private
  public //frorm ARetData    = Record
  {inherited
   AuditRec     :Array of TAuditRec;
   CalcStatus   : Boolean;
   Changed      : boolean;
   IsTaxPlan    : Boolean;
   Frm         : Array[0..FormsLimit] of TStringList;
   FrmHasData  : Array[0..FormsLimit] of boolean;
   Locked       : Boolean;
   Notes       : string;  //[80];
   Province    : String[2];
   PrpStatus   : string[2];
  //dropped
   Saved        : boolean;
   AuditList      : TStringList;
   SourceDataDir : string[70];
   SourceFlName : string[50];
  }
   ClientStatus, // : String [10];
   PlanStatus    : String;  //[13];
   SpouseInSync :Boolean;
   MarStatus    : Word; {Integer;}
   SpouseIncome : Real;
   Age         : Word; {Integer;}
   CppMonths   : Word; {Integer;}
   PartYear    : Real;
   Deceased    : Boolean;
   //Bankrupt    : Word;
   Balance     : Real;
   //Ln          : Array[LnLowBound..LnHighBound] of real;
   LnTaxPayer  : Array[LnLowBound..LnHighBound] of real;
   LnSpouse    : Array[LnLowBound..LnHighBound] of real;
   PSheltBalance : Real;
   PNonShBalance : Real;
   PSemShBalance : Real;
   POtherBalance : Real;
  { from ClienTtable}
   //RTuFile     : String[12];
   //AckFile     : String[12];
   {coupling info}
   CouplingSw   : Boolean;
   CplOptions   : Boolean;
   CplGst       :Boolean;
   CplMedical   :Boolean;
   CplDependants:Boolean;
   CplPrvCr     :Boolean;
   CplDon       :Boolean;
   CplGstReb    :Boolean;
   CplPolit     :Boolean;
  public
    constructor Create(TheApp: TApp); override; // 20151118 Igor
    destructor Destroy; override;
    Function  AddPageInstance(NonInstFormName, FormInst: string): integer; override;
    Procedure CloneForm(FromFormName: string;ToRetNo: integer;ToFormName:String; fAll: boolean); override;
    Procedure CloneReturn(ToRetNo: integer); override;
    function InitFormData(FRec: TFRec): boolean; override;
    function  Close(fRemove: boolean): boolean; override;
    function GetLastYearFile: String; override; //20160701 Igor
    procedure SetLastYearFile(const AValue: String); override; //20160701 Igor
  public //utils
    function  NewChild: TMyChild; override;
    function  BeforeOpenForm(var FormName: string; var FormNo: integer): string; override;
    //procedure AfterOpenForm; override;
    function  GetReturnCaption: string; override;
    function  GetReturnName: string; override; //for printing
    function  DoSave: boolean; override; //part of SaveAllReturns
    procedure DoSaveAs; override; //using SaveAs dialog
    function GetDefaultFileName: String; override; //20160305 Igor
    function GetDfmFileName(const FormName: string): string; override;
    function GetFirstName: string; override;//20160704 Igor
    function GetLastName: string; override;//20160704 Igor
    //20180503 Igor >>>
    function FormClass: TvtFormClass; override;
    function IsLetterForm(AFormName: String): Boolean; override;
    //20180503 Igor <<<
  public //forms
    function  GetFormNo(const FormName: String):Integer; override;
    function  GetFormName(FormNo: integer):String; override;
    procedure GetFrmTree(TreeView: TTreeView; fUsedForms: boolean); override;
    function  GetFrmTreeFNo(SourceNode: TTreeNode; fUsedForms: boolean): integer; override;
  public //calculations
    procedure Calc(RNo: integer; const FName: string; FNo: integer = -1); override;
    procedure CalcAll; override;
    //procedure CalcFullReturn; override;
    procedure ReCalcEveryThing; override;
    procedure CountDiagnostics; override;
  public  //letters
    function GetInterpetedRichEdit(LetterName:String;ARichEdit:TRichEdit): boolean; override;
  public //visual feedback
    function RefreshAuditPanel(ReturnsHeaderPanel: TPanel; ErrorView: TTreeView; AuditMode: eAuditMode): string; override;
    procedure OpenAuditOrigin(SourceNode: TTreeNode); override;
    procedure StartPrintForm(FormName:String;WhichPage:integer); override;
  end;

  TRetListFP = class(TRetList)
  private
    function GetRet(RetNo: integer): TRetFP_2027;
  public
    property Return[RetNo: integer]: TRetFP_2027 read GetRet; default;
  end;

  TRetFP_LastYear = class(TRetFP_2027) //20160704 Igor
  public
    constructor Create(TheApp: TApp); override;
  end;

var
  Ret: TRetListFP absolute RetList; //fake typed returns
  AppFP: TAppFP_2027;
  OptRec: TAppFP_2027 absolute AppFP;

Procedure Calc(RetNo: integer; FName: string; FNo: integer = -1); overload;
Function GetAuthorizationKey:String;
procedure ADOMsg(const item: string);

implementation

uses
  SysUtils,
  vtMain,vtAuthorization,vtCommon,vtDialogs,vtEditBox,
  FP_2027TrimStr,FP_2027main,FP_2027childwinnew,FP_2027common,FP_2027common2,
  FP_2027Calc,FP_2027Calc1,FP_2027Calc2,FP_2027CALCTAX,FP_2027Calc3,
  FP_2027CntErr,
  vtTrimStr,vtShared;

procedure ADOMsg(const item: string);
begin
  ErrorMsg(item + ' needs ADODB');
end;

Procedure Calc(RetNo: integer; FName: string; FNo: integer); overload;
Var
  FRec: TFRec;
  MyCalc: TCalcRtn;
Begin
FRec := FList.ByFormName(FName);
if not assigned(FRec.Calc) then
begin
// if FName = 'PROFILE' then MyCalc := @Profile
// else if FName = 'LETR_1'   then MyCalc := @LETR_1
// else if FName = 'INV_1'   then MyCalc := @INV_1
// else if FName = 'INV_2'   then MyCalc := @INV_2
// else if FName = 'NETWORTH' then MyCalc := @NETWORTH
// else if FName = 'LIVINGEXP_1'  then MyCalc := @LIVINGEXP_1
// else if FName = 'LIVINGEXP_2'  then MyCalc := @LIVINGEXP_2
// else if FName = 'INVESTSTRATEGY'  then MyCalc := @INVESTSTRATEGY
// else if FName = 'GENOBJ'  then MyCalc := @GENOBJ
// else if FName = 'ACCOUNTS'  then MyCalc := @ACCOUNTS
// else if LeftStr(FName,5) = 'CASH#'  then MyCalc := @CASH
// else if LeftStr(FName,4) = 'GIC#'  then MyCalc := @GIC
// else if LeftStr(FName,6) = 'BONDS#'  then MyCalc := @BONDS
// else if LeftStr(FName,4) = 'CSB#'  then MyCalc := @CSB
// else if LeftStr(FName,9) = 'DEFPLANS#'  then MyCalc := @DEFPLANS
// else if LeftStr(FName,9) = 'BUSINESS#'  then MyCalc := @BUSINESS
// else if LeftStr(FName,10) = 'OTHASSETS#'  then MyCalc := @OTHASSETS
// else if LeftStr(FName,9) = 'OTHFIXED#'  then MyCalc := @OTHFIXED
// else if LeftStr(FName,6) = 'LOANS#'  then MyCalc := @LOANS
// else if LeftStr(FName,8) = 'TERMDEP#'  then MyCalc := @TERMDEP
// else if LeftStr(FName,9) = 'MUTFUNDS#'  then MyCalc := @MUTFUNDS
// else if LeftStr(FName,7) = 'STOCKS#'  then MyCalc := @STOCKS
// else if LeftStr(FName,8) = 'REALEST#'  then MyCalc := @REALEST
// else if LeftStr(FName,6) = 'AUTOS#'  then MyCalc := @AUTOS
// else if LeftStr(FName,8) = 'FLDTAPE#'  then MyCalc := @FLDTAPE
// else if LeftStr(FName,8) = 'LIFEINS#'  then MyCalc := @LIFEINS
//
// else if LeftStr(FName,12) = 'CREDITCARDS#'  then MyCalc := @CREDITCARDS
// else if LeftStr(FName,9) = 'CARLOANS#'  then MyCalc := @CARLOANS
// else if LeftStr(FName,10) = 'MORTGAGES#'  then MyCalc := @MORTGAGES
// else if LeftStr(FName,8) = 'BANKADV#'  then MyCalc := @BANKADV
// else if LeftStr(FName,12) = 'UNPAIDBILLS#'  then MyCalc := @UNPAIDBILLS
// else if LeftStr(FName,11) = 'TAXPAYABLE#'  then MyCalc := @TAXPAYABLE
// else if LeftStr(FName,9) = 'OTHERLTL#'  then MyCalc := @OTHERLTL
//
// else if FName ='INCPROJECTION'  then MyCalc := @INCPROJECTION
// else if FName  ='LIFEEVENTS'  then MyCalc := @LIFEEVENTS
// else if FName = 'CASHFLOW'  then MyCalc := @CASHFLOW
// else if FName = 'ACKNLDG'  then MyCalc := @ACKNLDG
// else if FName = 'ADDINFO'  then MyCalc := @ADDINFO
// else if FName = 'STATUS'  then MyCalc := @STATUS
// else if FName = 'T1LINK'  then MyCalc := @T1Link
// else if FName = 'RETPLAN'  then MyCalc := @RETPLAN
// else if FName = 'CHACCUM'  then MyCalc := @CHACCUM
// else if FName = 'PEVENTS'  then MyCalc := @PEVENTS
// else if LeftStr(FName,7) = 'EDUPLN#'  then MyCalc := @EDUPLN
// else if FName = 'SUMOBJ'  then MyCalc := @SUMOBJ
// else if FName = 'ANNINC'  then MyCalc := @ANNINC
// else if FName = 'INSNEED'  then MyCalc := @INSNEED
// else if FName = 'DISABLT'  then MyCalc := @DISABLT
// else if FName = 'GOALS'  then MyCalc := @GOALS
// else if FName = 'GOALSR'  then MyCalc := @GOALSR
// else if FName = 'WILLS'  then MyCalc := @WILLS
// else if FName = 'OTHASS'  then MyCalc := @OTHASS
//
// else if FName = 'PROJECTIONCHARTS'  then MyCalc := @PROJECTIONCHARTS
//
// else if FName = 'TXSUM_1'  then MyCalc := @TXSUM_1
// else if FName = 'TXSUM_2'  then MyCalc := @TXSUM_2
//
// else if FName = 'PRESVAL'  then MyCalc := @PRESVAL
// else if FName = 'FUTVAL'  then MyCalc := @FUTVAL
//
// else if FName = 'T2033_1'   then MyCalc := @T2033_1
// else if FName = 'T2151_1'   then MyCalc := @T2151_1
// else if FName = 'T2220_1'   then MyCalc := @T2220_1
// else if FName = 'EFORM'   then MyCalc := @EFORM
// else if FName = 'TD2'     then MyCalc := @TD2
// else if FName = 'T1058'   then MyCalc := @T1058
//
// else if FName = 'T1036_1'   then MyCalc := @T1036_1
// else if FName = 'T3012_1'   then MyCalc := @T3012_1
// else if FName = 'T2097'   then MyCalc := @T2097
// else if FName = 'PASSSUM' then MyCalc := @PASSSUM
// else if FName = 'ASSUME'  then MyCalc := @ASSUME
//
//  {multiple pages}
// else if LeftStr(Fname,8) = 'GENPLAN#'   then MyCalc := @GENPLAN
// else if LeftStr(Fname,13) = 'SPECIFICPLAN#' then MyCalc := @SPECIFICPLAN
// else if LeftStr(Fname,5) = 'NPAD#'   then MyCalc := @NPAD
// else if LeftStr(Fname,6) = 'NPADC#'   then MyCalc := @NPADC
// else if LeftStr(Fname,7) = 'PRIVAT#'  then MyCalc := @PRIVAT
// else if LeftStr(FName,7) = 'PSHELT#'  then MyCalc := @PSHELT
// else if LeftStr(FName,7) = 'PNONSH#'  then MyCalc := @PNONSH
// else if LeftStr(FName,7) = 'PSEMSH#'  then MyCalc := @PSEMSH
// else if LeftStr(FName,7) = 'POTHER#'  then MyCalc := @POTHER
//
// else if LeftStr(FName,6) = 'PNETW#'   then MyCalc := @PNETW
// else if LeftStr(FName,6) = 'PLIAB#'   then MyCalc := @PLIAB
// else if LeftStr(FName,7) = 'PSMINV#'  then MyCalc := @PSMINV
// else if LeftStr(FName,10) = 'PCASHFLOW#' then MyCalc := @PCASHFLOW
// else if LeftStr(FName,8) = 'PINVPLN#' then MyCalc := @PINVPLN
// else if LeftStr(FName,6) = 'PRRSP#'   then MyCalc := @PRRSP
//
// else if LeftStr(FName,6) = 'ORD_1#'  then MyCalc := @ORD_1
// else if LeftStr(FName,6) = 'ORD_2#'  then MyCalc := @ORD_2
// else if LeftStr(FName,6) = 'ORD_3#'  then MyCalc := @ORD_3
// else if LeftStr(FName,6) = 'ORD_4#'  then MyCalc := @ORD_4
//
// else if LeftStr(FName,10) = 'PORTFOLIO#'  then MyCalc := @PORTFOLIO
// else if LeftStr(FName,11)  = 'TAXPLANNER#' then MyCalc := @TAXPLANNER
// else if FName              = 'S1' then MyCalc := @S1
// else if LeftStr(FName,7)  = 'TAXP_1#'  then MyCalc := @TAXP_1
// else if LeftStr(FName,7)  = 'TAXP_2#'  then MyCalc := @TAXP_2
//
// else if FName  = 'TAXPL_1'  then MyCalc := @TAXPL_1
// else if FName  = 'TAXPL_2'  then MyCalc := @TAXPL_2
// else if FName  = 'TAXPL_3'  then MyCalc := @TAXPL_3
  if FName = 'PROFILE' then MyCalc := @Profile
  else if FName = 'LETR_1'   then MyCalc := @LETR_1
  else if FName = 'INV_1'   then MyCalc := @INV_1
  else if FName = 'INV_2'   then  MyCalc := @INV_2
  else if FName = 'NETWORTH' then  MyCalc := @NETWORTH
  else if FName = 'LIVINGEXP_1'  then  MyCalc := @LIVINGEXP_1
  else if FName = 'LIVINGEXP_2'  then  MyCalc := @LIVINGEXP_2
  else if FName = 'INVESTSTRATEGY'  then  MyCalc := @INVESTSTRATEGY
  else if FName = 'GENOBJ'  then  MyCalc := @GENOBJ
  else if FName = 'ACCOUNTS'  then  MyCalc := @ACCOUNTS
  else if LeftStr(FName,5) = 'CASH#'  then  MyCalc := @CASH
  else if LeftStr(FName,4) = 'GIC#'  then  MyCalc := @GIC
  else if LeftStr(FName,6) = 'BONDS#'  then  MyCalc := @BONDS
  else if LeftStr(FName,4) = 'CSB#'  then  MyCalc := @CSB
  else if LeftStr(FName,9) = 'DEFPLANS#'  then  MyCalc := @DEFPLANS
  else if LeftStr(FName,9) = 'BUSINESS#'  then  MyCalc := @BUSINESS
  else if LeftStr(FName,10) = 'OTHASSETS#'  then  MyCalc := @OTHASSETS
  else if LeftStr(FName,9) = 'OTHFIXED#'  then  MyCalc := @OTHFIXED
  else if LeftStr(FName,6) = 'LOANS#'  then  MyCalc := @LOANS
  else if LeftStr(FName,8) = 'TERMDEP#'  then  MyCalc := @TERMDEP
  else if LeftStr(FName,9) = 'MUTFUNDS#'  then  MyCalc := @MUTFUNDS
  else if LeftStr(FName,7) = 'STOCKS#'  then  MyCalc := @STOCKS
  else if LeftStr(FName,8) = 'REALEST#'  then  MyCalc := @REALEST
  else if LeftStr(FName,6) = 'AUTOS#'  then  MyCalc := @AUTOS
  else if LeftStr(FName,8) = 'FLDTAPE#'  then  MyCalc := @FLDTAPE
  else if LeftStr(FName,8) = 'LIFEINS#'  then  MyCalc := @LIFEINS

  else if LeftStr(FName,12) = 'CREDITCARDS#'  then  MyCalc := @CREDITCARDS
  else if LeftStr(FName,9) = 'CARLOANS#'  then  MyCalc := @CARLOANS
  else if LeftStr(FName,10) = 'MORTGAGES#'  then  MyCalc := @MORTGAGES
  else if LeftStr(FName,8) = 'BANKADV#'  then  MyCalc := @BANKADV
  else if LeftStr(FName,12) = 'UNPAIDBILLS#'  then  MyCalc := @UNPAIDBILLS
  else if LeftStr(FName,11) = 'TAXPAYABLE#'  then  MyCalc := @TAXPAYABLE
  else if LeftStr(FName,9) = 'OTHERLTL#'  then  MyCalc := @OTHERLTL

  else if FName ='INCPROJECTION'  then  MyCalc := @INCPROJECTION
  else if FName  ='LIFEEVENTS'  then  MyCalc := @LIFEEVENTS
  else if FName = 'DTC'  then  MyCalc := @DTC   //20170411
  else if FName = 'CASHFLOW'  then  MyCalc := @CASHFLOW
  else if FName = 'ACKNLDG'  then  MyCalc := @ACKNLDG
  else if FName = 'ADDINFO'  then  MyCalc := @ADDINFO
  else if FName = 'STATUS'  then  MyCalc := @STATUS
  else if FName = 'T1LINK'  then  MyCalc := @T1Link
  else if FName = 'RETPLAN'  then  MyCalc := @RETPLAN
  else if FName = 'CHACCUM'  then  MyCalc := @CHACCUM
  else if FName = 'PEVENTS'  then  MyCalc := @PEVENTS
  else if LeftStr(FName,7) = 'EDUPLN#'  then  MyCalc := @EDUPLN
  else if FName = 'SUMOBJ'  then  MyCalc := @SUMOBJ
  else if FName = 'ANNINC'  then  MyCalc := @ANNINC
  else if FName = 'INSNEED'  then  MyCalc := @INSNEED
  else if FName = 'DISABLT'  then  MyCalc := @DISABLT
  else if FName = 'GOALS'  then  MyCalc := @GOALS
  else if FName = 'GOALSR'  then  MyCalc := @GOALSR
  {else if FName = 'CRITILL'  then begin CRITILL}
  else if FName = 'WILLS'  then  MyCalc := @WILLS
  else if FName = 'OTHASS'  then  MyCalc := @OTHASS

  else if FName = 'PROJECTIONCHARTS'  then  MyCalc := @PROJECTIONCHARTS

  else if FName = 'TXSUM_1'  then  MyCalc := @TXSUM_1
  else if FName = 'TXSUM_2'  then  MyCalc := @TXSUM_2

  else if FName = 'PRESVAL'  then  MyCalc := @PRESVAL
  else if FName = 'FUTVAL'  then  MyCalc := @FUTVAL

  else if FName = 'T2033_1'   then  MyCalc := @T2033_1
  else if FName = 'T2151_1'   then  MyCalc := @T2151_1
  else if FName = 'T2220_1'   then  MyCalc := @T2220_1
  else if FName = 'EFORM'   then  MyCalc := @EFORM
  else if FName = 'TD2'     then  MyCalc := @TD2
  else if FName = 'T1058'   then  MyCalc := @T1058

  else if FName = 'T1036_1'   then  MyCalc := @T1036_1
  else if FName = 'T3012_1'   then  MyCalc := @T3012_1
  else if FName = 'T2097'   then  MyCalc := @T2097
  else if FName = 'PASSSUM' then  MyCalc := @PASSSUM
  else if FName = 'ASSUME'  then  MyCalc := @ASSUME

  {multiple pages}
  else if LeftStr(Fname,8) = 'GENPLAN#'   then  MyCalc := @GENPLAN
  else if LeftStr(Fname,13) = 'SPECIFICPLAN#' then  MyCalc := @SPECIFICPLAN
  else if LeftStr(Fname,5) = 'NPAD#'   then  MyCalc := @NPAD
  else if LeftStr(Fname,6) = 'NPADC#'   then  MyCalc := @NPADC
  else if LeftStr(Fname,7) = 'PRIVAT#'  then  MyCalc := @PRIVAT
  else if LeftStr(FName,7) = 'PSHELT#'  then  MyCalc := @PSHELT
  else if LeftStr(FName,7) = 'PNONSH#'  then  MyCalc := @PNONSH
  else if LeftStr(FName,7) = 'PSEMSH#'  then  MyCalc := @PSEMSH
  else if LeftStr(FName,7) = 'POTHER#'  then  MyCalc := @POTHER

  //else if LeftStr(FName,6) = 'PFIXA#'   then begin PFIXA
  else if LeftStr(FName,6) = 'PNETW#'   then  MyCalc := @PNETW
  else if LeftStr(FName,6) = 'PLIAB#'   then  MyCalc := @PLIAB
  else if LeftStr(FName,7) = 'PSMINV#'  then  MyCalc := @PSMINV
  else if LeftStr(FName,10) = 'PCASHFLOW#' then  MyCalc := @PCASHFLOW
  else if LeftStr(FName,8) = 'PINVPLN#' then  MyCalc := @PINVPLN
  else if LeftStr(FName,6) = 'PRRSP#'   then  MyCalc := @PRRSP

  else if LeftStr(FName,6) = 'ORD_1#'  then  MyCalc := @ORD_1
  else if LeftStr(FName,6) = 'ORD_2#'  then  MyCalc := @ORD_2
  else if LeftStr(FName,6) = 'ORD_3#'  then  MyCalc := @ORD_3
  else if LeftStr(FName,6) = 'ORD_4#'  then  MyCalc := @ORD_4

  else if LeftStr(FName,10) = 'PORTFOLIO#'  then  MyCalc := @PORTFOLIO
  else if LeftStr(FName,11)  = 'TAXPLANNER#' then  MyCalc := @TAXPLANNER
  else if FName              = 'S1' then  MyCalc := @S1
  else if LeftStr(FName,7)  = 'TAXP_1#'  then  MyCalc := @TAXP_1
  else if LeftStr(FName,7)  = 'TAXP_2#'  then  MyCalc := @TAXP_2

  else if FName  = 'TAXPL_1'  then  MyCalc := @TAXPL_1
  else if FName  = 'TAXPL_2'  then  MyCalc := @TAXPL_2
  else if FName  = 'TAXPL_3'  then  MyCalc := @TAXPL_3

  //20170409 Igor >>>
  else if FName  = 'ASSETSUM'  then  MyCalc := @PreAssetSum
  else if FName  = 'LIABSUM'  then  MyCalc := @PreLiabSum
  //20170409 Igor <<<

  else MyCalc := @NothingToCalc; //dummy

  FRec.Calc := MyCalc;
end; //first time visit

  if RetNo > 0 then
  begin
    FNo := FRec.FormNo;
    If (FNo > 0) then
    if (RetList[RetNo].MyApp = AppFP) then //20160323 Igor
    Begin
      if (Ret[RetNo].Frm[Fno].Count =0) then
        InitFormData(RetNo,FNo);
      if FNo > 0 then // add if 20151215 Igor
        FRec.Calc(RetNo,FName,FNo);
    End;
  end;
end;

procedure InitBmps;
{var LogoBmp:Tbitmap;}
begin
  (*
  LogoBmp := TBitmap.Create;
  LogoBmp.LoadFromFile(AppDir+'\'+'MyLogo.BMP');
  *)
end;

procedure InitLists;
{MUST create the data lists AND also initialize them before using them}
var i:Integer;s : string;
begin
  InitConstants;
  //AuditList    :=TStringList.Create;
  ElmsInError := TStringList.Create;

  //AffectedList  := TStringList.Create;
  //AffectedList.LoadFromFile(AppDir +'\'+ 'Affected.D');
  TaxSumList := TstringList.Create;
  TaxSumList.LoadFromFile(AppDir +'\'+ 'TAXSUM.D');
  VList   := TStringList.Create;
  {InitCCARates;}
 // LoadOthOpt;
  LoadMarginalRates;

  FrmTreeDescr :=TStringList.Create;
  FrmTreeForms :=TStringList.Create;
  FrmTreeFType :=TStringList.Create;
  LoadTreeView('TreeView.d',1);
   {streams}
  BalanceList:=TBalanceList.Create;
  TotInvestmProjectionList := TTotInvestmProjectionList.Create;
  LiabilitiesProjectionList:=TLiabilitiesProjectionList.Create;
  FixedAssetsProjectionList:=TFixedAssetsProjectionList.Create;
  BusinessProjectionList :=TBusinessProjectionList.Create;
  NetWorthProjectionList:=TNetWorthProjectionList.Create;
  CashFlowProjectionList   :=TCashFlowProjectionList.Create;
  InvProjectionList      :=TInvProjectionList.Create;
  RRSPProjectionList      :=TRRSPProjectionList.Create;
  GenBalanceList := TGenBalanceList.Create;
  AllRifList     := TAllRifList.Create;
  AssetSumList   :=TAssetSumList.Create;
  //ProposedAssetSumList   :=TList.Create;
  ContrBenefList := TstringList.Create;
  ContrBenefList.Add('C');ContrBenefList.Add('S');ContrBenefList.Add('E');
  PricesAsOfDate := GetPricesAsOfDate;
end;

Procedure InitSwitches;
begin

end;

procedure InitFP;
begin
(* from main.pas
  shared options moved into vtMain.ProgramInit
*)
  FormatSettings.DecimalSeparator:='.';        //20150819  Igor
  //ScaleType:='ALL'; //'HORIZ';
  //FastPrint := False;
  //DataChanged:=False;
  Sc:=1; ScChar :=1; ScChange :=0;
  RY :=0; {0:current year;Rate year = next year/prelim}

  ServerMode:=False;

  InitOptions;
  OptRec.Dir_Cur :=OptRec.Dir_Deflt;
  AppFP.initFList;
end;

Function GetAuthorizationKey:String;
begin
  Result := AppFP.GetAuthorizationKey;
end;

{ TAppFP_2027 }

function TAppFP_2027.AllowFormForBuildReport(const AFormName: String): Boolean; //20180424 Igor
begin
  {define forms that are visible in report builder}
  Result := false;
end;

function TAppFP_2027.MaskFormDataForBuildReport(const AFormName: String; //20180424 Igor
  AFieldNo: Integer; AFieldValue: String): String;
begin
  {mask field values}
  Result := AFieldValue;
end;

function TAppFP_2027.CheckLastYearDataFolder(
  out AErrorMessage: String): Boolean;
begin
  Result := isValidLastYearDataFolder(false,AErrorMessage); //20160704 Igor
end;

function TAppFP_2027.CheckLastYearPgmFolder(out AErrorMessage: String): Boolean; //20160516 Igor
begin
  Result := isValidLastYearPgmFolder(false,AErrorMessage); //20160704 Igor
end;

constructor TAppFP_2027.Create (AppList: TAppList); // 20151118 Igor
begin
  InitMulti;
  CurrentApp := self;
  AppFP := self;
  //AppIdx := aiFP;
  AppId := 'FP-2027';   //20150731
  ClientsDBLite:=lClientsDBLite+'_'+AppName+'.db'; //20151017 Igor !!!after AppId!!!//20170731 Igor
//  SQLLitePassword:=FPSQLLitePassword;                      //20151017 Igor //20160226 Igor
  FSQLitePassword := TSQLitePassword.Create(Self); //20160303 Igor
  AppIdx := aiFP;
  //20180503 Igor >>>
  if CheckIsCloud(true) then
    FP_2027Declare.AppDir := CloudDir + '\' + AppId //20190213 Igor
  else
    FP_2027Declare.AppDir := ExeDir + '\' + AppId;
  //20180503 Igor <<<
  FFirstForm := FirstFormName; // 'PROFILE';
  //FCalcs := TCalcsFP_2027;
  InitStorage; //20180503 Igor
  InitFP;
  inherited Create (AppList); // 20151118 Igor //register the AppId
  MainFormFP := TMainFormFP_2027.Create(Application);
  AddReviewStaticForm('NETWORTH'); //20160223 Igor
  AddReviewStaticForm('CASHFLOW'); //20160223 Igor
  AddReviewStaticForm('PROJECTIONCHARTS'); //20160223 Igor
  AddReviewStaticForm('EXECSUM'); //20160424 Igor
end;

procedure TAppFP_2027.CreateDefaultDataDirectories;//20170803 Igor
begin
  FP_2027TrimStr.CreateDefaultDataDirectories;
end;

function TAppFP_2027.GetAppDir: string;
begin
  Result := FP_2027Declare.AppDir;
end;

function TAppFP_2027.GetAppName: string;
begin
  Result := FP_2027Declare.AppName;
end;

function TAppFP_2027.GetMenu: TMainMenu;
begin
  Result := MainMenuFP;
  MainFormFP.ShowCellNumbers1.Checked := ShowFieldIdSw;
end;

function TAppFP_2027.GetToolBar: TControl;//20170824 Igor
begin
  //20180206 Igor >>>
  MainFormFP.ZoomStr:=IntToStr(OptRec.FormZoom)+'%';
  case MainOptions.Skin of
    skSmallToolbar:
      Result := MainFormFP.pnlSmallToolBar;
	  skLargeToolbar:
      Result := MainFormFP.pnlLargeToolBar;
    skRibbon:
      Result := MainFormFP.MainUIRibbon; //20190415 Igor
  else
    Result := MainFormFP.AllBars;
  end;
  MainFormFP.ModuleButtonsPanel.Parent := TWinControl(Result);
  //20180206 Igor <<<
end;

function TAppFP_2027.GetValidLastYearDataFolder: Boolean; //20160302 Igor
begin
  Result := False;
end;

function TAppFP_2027.GetValidLastYearPgmFolder: Boolean; //20160302 Igor
begin
  Result := False;
end;

function TAppFP_2027.HaveOptions(AOptionsName: String): Boolean; //20170112 Igor
begin
  Result := FP_2027TrimStr.HaveOptions(AOptionsName);
end;

function TAppFP_2027.GetSplash: TCustomControl;
begin
  Result := MainFormFP.ProcessPanel;
end;

function TAppFP_2027.GetSQLLitePassword(const Version: Integer = GC_SQLLitePasswordVersion): String; //20160303 Igor
begin
//Do not remove the old version
  case Version of
    0: Result := '';
    1: Result := AppName+Contributor1+Reverse(Contributor2)+Reverse(Contributor3);
    2: Result := AppName+Contributor1+Reverse(Contributor2)+Reverse(Contributor3ver2);
    3: Result := '5'+chr(126)+'x'+chr(72)+chr(115)+chr(100)+'g'+chr(49)+chr(118)+chr(87)+
                 '#'+chr(70)+chr(97)+chr(114)+chr(99)+chr(97); //20161208 Igor
    4: Result := chr(100)+chr(106)+chr(106)+chr(105)+'6'+''+chr(86)+''+chr(89)+
                 chr(71)+'L'+chr(99)+chr(48)+chr(53)+''+chr(63)+chr(99)+'j'+chr(85); //20161208 Igor
  end;
end;

function TAppFP_2027.GetSQLLiteRFPassword(const Version: Integer): String; //20160415 Igor
begin
//Do not remove the old version
  case Version of
    0: Result := '';
    1: Result := Contributor1+AppName+Reverse(Contributor2)+Reverse(Contributor3);
    2: Result := Contributor1+AppName+Reverse(Contributor2)+Reverse(Contributor3ver2);
    3: Result := 'X'+chr(86)+chr(125)+chr(37)+chr(98)+chr(71)+'Y'+chr(80)+chr(42)+
                 chr(126)+chr(74)+chr(68)+'Z'+chr(73)+'l'+chr(35); //20161208 Igor
    4: Result := '4'+chr(98)+'X'+chr(55)+chr(113)+chr(117)+chr(57)+chr(113)+chr(125)+
                 chr(99)+chr(107)+chr(53)+''+'y'+chr(49)+'y'+chr(50); //20161215 Igor
  end;
end;

function TAppFP_2027.GetSubstituteLastYearForm(AFormName: String): String; //20160302 Igor
begin
  Result := SubstituteLastYearForm(AFormName); //20160704 Igor
end;

function TAppFP_2027.Licenses: PPgmLicenseData;
begin
  Result := @PgmLicenses;
end;

procedure TAppFP_2027.LoadOptionsFileToMem;
begin
  inherited;
  FP_2027TrimStr.LoadOptionsFileToMem;
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
  id := LeftStr(AKey, 4); //FP0x
  p := @pgmLicenses[0];
  while p.Level > llNone do begin
    if p.Id = id then
      break;
    inc(p);
  end;
  f1 := p.Factor;
  case AKey[1] of
  'F':  f2 := FPF2_2025 //FP key    //20150731
  else
    exit;
  end;
  Result := MakeHashString(AKey, f1, f2);
end;

function TAppFP_2027.ValidateKey(AKey: String): boolean;
begin
  Result := inherited ValidateKey(AKey);
  if not Result then
    exit;
 If MidStr(AKey,16,4) = MyHashString(AKey) then
   result:=True
 else
   result:=False;
 If UpperCase(LeftStr(AKey,2)) <> UpperCase(LeftStr(AppName,2)) then
   result:=False;  {T1 key goes with T1, etc}
end;

function TAppFP_2027.GetAppRelease: string;
begin
  Result := FP_2027Declare.AppRelease;
end;

function TAppFP_2027.GetAppUpdateDate: string;
begin
  Result := FP_2027Declare.AppUpdateDate;
end;

function TAppFP_2027.GetAppYear: string;
begin
  Result := FP_2027Declare.AppYear;
end;

function TAppFP_2027.SaveReturn(RetNo: Integer; DataDir, FlName: string; //20200914 Igor //20200916 Igor
  OverrideSW, UpdMostRecent, ATextFormat, AUpdateClientTable: boolean;
  AClouds: TArrayOfInteger): Integer;
var FSaveApp: TApp;
begin
  FSaveApp := CurrentApp;
  try
    CurrentApp := AppFP;
    Result := FP_2027Common2.SaveReturn(RetNo, DataDir, FlName, OverrideSW, UpdMostRecent, ATextFormat, AUpdateClientTable, AClouds);
  finally
    CurrentApp := FSaveApp;
  end;
end;

procedure TAppFP_2027.SaveSingleOptions(const AOptionName, AValue: String;
  AOptionsFileName: String);
begin
  inherited;
  FP_2027TrimStr.SaveSingleOption(AOptionName, AValue, AOptionsFileName);
end;

procedure TAppFP_2027.SelectFeatures;
begin
  MainFormFP.SelectFeatures;
end;

procedure TAppFP_2027.SetZoomCaption(AZoom: Integer);
begin
  MainFormFP.ZoomStr := IntToStr(AZoom)+'%'; //20180206 Igor
end;

function TAppFP_2027.ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String;
  var AErr: String; AOverride: Boolean): Boolean;
begin
  Result := FP_2027TrimStr.ImportOneReturn(ADS, ASrcDir, ADstDir, AErr, AOverride);
end;

procedure TAppFP_2027.InitFList;
begin
  inherited;
  if not assigned(FList) then
  begin
    InitLists;       {Forms and return lists}

    FP_2027Declare.FList := TFListFP.Create(AppFP, FormsLimit,FieldsLimit, FormsDBLite, FormsTableLite);//20150119 Igor
    AppFP.ConvertDataBase; //20160304 Igor
    FP_2027TrimStr.InitFormsTable;  {all forms available}
    InitColorTable;  {all colors available}
    InitSwitches;
    InitBmps;
    TutorialFile:='';
  end;
end;

function TAppFP_2027.InitNewReturn(ForLoad: boolean): integer;
begin
  Result := FP_2027Common.CreateNewReturn;
end;

procedure TAppFP_2027.InitStorage; //20180503 Igor
var
  EtalonDir, S: String;
  procedure CopyIfNeed(AFileName: String);
  begin
    if not TFile.Exists(TPath.Combine(EtalonDir, AFileName)) then Exit;
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
    CopyIfNeed(ClientsDBLite);
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
  end;
end;

procedure TAppFP_2027.OpenClientBook; //20200916 Igor
var FSaveApp: TApp;
begin
  inherited;
  FSaveApp := CurrentApp;
  try
    CurrentApp := AppFP;
    MainformFP.OpenReturnLblClick(nil);
  finally
    CurrentApp := FSaveApp;
  end;
end;

function TAppFP_2027.OpenForeignForm(const ADir, AFile, AForm: String;
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
    R := FP_2027Common2.OpenReturn(ADir, AFile, False, False);
  if R <=0 then
    exit(nil);
  F := OpenForm(R, AForm, AElement);
  if Assigned(F) then
    Result := RetList[R].Form[AForm]
  else
    Result := nil;
end;

function TAppFP_2027.OpenReturn(DirName, FlName: string;
  fShow: boolean; AIsAppendix: Boolean = False): integer; //20160305 Igor
begin
  Result := FP_2027Common2.OpenReturn(DirName,FlName,fShow,AIsAppendix); //20160305 Igor
end;

procedure TAppFP_2027.ReloadMainMenu; //20190307 Igor
begin
  inherited;
  MainFormFP.ReloadMainMenu;
end;

destructor TAppFP_2027.Destroy;
begin
{$IFDEF dbg}
  if FP_2027declare.flist <> flist then //debugbreak;
    ErrorMsg('flist');
  FList.Clear;
{$ELSE}
{$ENDIF}
  inherited;
end;

function TAppFP_2027.Factor2: Byte;
begin
  Result := FPF2_2025;
end;

procedure TAppFP_2027.FrmTreeCustomNodeClick(ANode: TTreeNode); //20160323 Igor
begin
  inherited;

  if AllTrim(FrmTreeForms[ANode.AbsoluteIndex]) = 'IMPORTT1' then
  begin
    MainFormFP.ImportTaxData1Click(Application);
    Exit;
  end;
end;

function TAppFP_2027.GetDefaultOptions: TStringList;
begin
  result := FP_2027TrimStr.GetDefaultOptions;
end;

function TAppFP_2027.GetDefaultOptionsValue(AOptionName: String): String;
begin
  result := FP_2027TrimStr.GetDefaultOptionsValue(AOptionName);
end;

//20180311
function TAppFP_2027.GetRightTabSheets: TRightTabSheets;//20171228 Igor
begin
  Result := [rtsReview];
end;

function TAppFP_2027.GetDfmFileName(const FormName: string): string;
begin
  Result:=FP_2027ChildWinNew.GetDfmFileName(FormName)
end;

function TAppFP_2027.GetDfmFileNameLY(const FormName: string): string;
begin
  Result := FP_2027ChildWinNew.GetLastYearDFMFileName(FormName);
end;

function TAppFP_2027.GetOptionsCaption(AOptionName: String): String;
begin
  result := FP_2027TrimStr.GetOptionsCaption(AOptionName);
end;

function TAppFP_2027.GetHelpFile: String;
begin
  Result := 'http://www.visualtax.com/Vt2016HELP/FPHelp/Website/FPHelp.html'; //20161220 Igor
end;

function TAppFP_2027.GetHelpUpdFile: String;
begin
  Result := 'http://visualtax.com/Vt2018HELP/FPHelp/FPUPD/FPUpdHlp.html'; //20171205 Igor
end;

function TAppFP_2027.GetInitLastYear: Boolean;
begin
  if Assigned(FLastYearList) then
    Result := True
  else
  Begin
    InitLastYearFormsTable;
    result := Assigned(FLastYearList);
  End;
end;

function TAppFP_2027.GetLastYearDataFolder: String; //20160302 Igor
begin
  if Dir_LastYr[length(Dir_LastYr)] = '\' then   //201600704 Igor
    Delete(Dir_LastYr,length(Dir_LastYr)-1,1);
  Result := Dir_LastYr;
end;

function TAppFP_2027.GetLastYearFormNo(AFormName: String): Integer; //20160302 Igor
begin
  Result := FP_2027TrimStr.GetLastYearFormNo(AFormName); //20160629 Igor
end;

function TAppFP_2027.GetLimitedVersionDir: String; //20160718 Igor
begin
  Result := FP_2027Declare.LimitedVersionDir;
end;

{ TRetListFP }

function TRetListFP.GetRet(RetNo: integer): TRetFP_2027;
begin
(* problem with AppId switching :-(
*)
  TObject(Result) := TypedReturn(RetNo, TRetFP_2027);
end;

{ TRetFP_2027 }

constructor TRetFP_2027.Create(TheApp: TApp);

  procedure InitRetData;
  var
     i,j: integer;
   begin
    Changed := False; {for new returns only}
    SourceFlName := '';
    SourceDataDir:='';
    Locked:=False;
    SpouseIncome := 0;
    PrpStatus := '00';
    MarStatus := 6;
    Province := User.OverloadProperty[AppFP, 'Prp_Prov']; //20170112 Igor
    Age := 30;
    Deceased := False;
    //AuditList:= TStringList.Create;
    PSheltBalance :=0;
    PNonShBalance :=0;
    PSEMShBalance :=0;
   
    for j := LnLowBound to LnHighBound do
      begin
         //Ln[j] := 0;
         LnTaxPayer[j] := 0;  //for txsum
         LnSpouse[j] := 0;
      end;
  end;

begin
  SetLength(Ln,LnHighBound+1); //made it dynamic //20190704 Igor
  SetLength(Frm,FormsLimit + 1);
  SetLength(FrmHasData,FormsLimit + 1);
  inherited Create(TheApp); //add to RetList
//more?
  FRetColor := GetNextAvailColor;
  InitRetData;
end;

destructor TRetFP_2027.Destroy;
begin
  //FreeAndNil(AuditEfileList); - global!!!
//these are automatically destroyed
  //FreeAndNil(auditlist);
  //FreeAndNil(PreselForms);
  //FreeAndNil(OpenedForms);
  //FreeAndNil(TS60Ln240Memo);
  //FreeAndNil(TS60Ln242Memo);
  //FreeAndNil(TS60Ln244Memo);
  //FreeAndNil(TS60Ln250Memo);
  //FreeAndNil(TS60Ln252Memo);
  //FreeAndNil(GifiNotesMemo);
  inherited Destroy;
end;

function TRetFP_2027.GetDefaultFileName: String;
begin
  Result := MkFileName(RetNo);
end;

function TRetFP_2027.GetDfmFileName(const FormName: string): string;
begin
  //20160704 Igor
  If ShowUnconvertedLastYear(RetNo) = False then
    Result:= FP_2027ChildWinNew.GetDfmFileName(FormName)
  else
    Result:= FP_2027ChildWinNew.GetLastYearDfmFileName(FormName);
end;

function TRetFP_2027.GetFirstName: string; //20160704 Igor
begin
  Result := Uppercase(FetchElm(RetNo,'PROFILE',1));
end;

function TRetFP_2027.GetFormName(FormNo: integer): String;
begin
  Result := FList.GetFormName(FormNo); // FP_2027TrimStr.GetFormName(FormNo); //20160704 Igor
end;

function TRetFP_2027.GetFormNo(const FormName: String): Integer;
begin
  Result := FList.GetFormNo(FormName); // FP_2027TrimStr.GetFormNo(FormName);  //20160704 Igor
end;

procedure TRetFP_2027.GetFrmTree(TreeView: TTreeView; fUsedForms: boolean);
var
  FormsTreeView1: TTreeView absolute TreeView;
  TempList: TStringList;
  i: integer;
begin
(* this could become a generic function of TRetData,
    provided a unified FList.
  from main.RefreshFormsPanel
*)
(* Problem: FP shows other items, not (only) forms!
*)
  FormsTreeView1.items.clear;
  if fUsedForms then begin
    TempList:=TStringList.Create;
    TempList.Sorted:=True;
    //TempList.Add('USED FORMS'); screws up!

    for i :=0 to (FList.Count - 1) do
    begin
     FRec := FList.Items[i];
     If (Frec.FormShow) and (Ret[RetNo].FrmHasData[Frec.FormNo])
      then TempList.Add(' '+AllTrim(Frec.FormAbrev));
   end;
    TempList.Sorted := False;
    TempList.Insert(0,'USED FORMS');
    TempList.SaveToFile(AppDir+'\'+'Temp');
    FormsTreeView1.LoadFromFile(AppDir+'\'+'Temp');
    FormsTreeView1.FullExpand;
    TempList.Free;
  end else begin
     FormsTreeview1.LoadFromFile(AppDir+'\Treeview2.D');
  end;
  FormsTreeView1.TopItem:=FormsTreeView1.Items[0];
end;

function TRetFP_2027.GetFrmTreeFNo(SourceNode: TTreeNode;
  fUsedForms: boolean): integer;
var
  FormName: string;
begin
(* Forms TreeView OnClick handler
  //init FrmsTree[] in InitLists
*)
  if fUsedForms then
    FormName := GetFName(SourceNode.Text)
  else
    FormName := AllTrim(FrmTreeForms[SourceNode.AbsoluteIndex]);
  if FormName <> '' then
    Result := GetFormNo(FormName)
  else
    Result := 0;
end;

function TRetFP_2027.GetInterpetedRichEdit(LetterName: String;
  ARichEdit: TRichEdit): boolean;
begin
  Result := FP_2027TrimStr.GetInterpretedRichEdit(Self.RetNo, LetterName, ARichEdit);
end;

function TRetFP_2027.GetLastName: string; //20160704 Igor
begin
  Result := Uppercase(FetchElm(RetNo,'PROFILE',2));
end;

function TRetFP_2027.GetLastYearFile: String;
begin
  Result := FP_2027TrimStr.GetLastYearFile(Self.RetNo);
end;

procedure TRetFP_2027.Calc(RNo: integer; const FName: string; FNo: integer);
begin
(* When called from within WITH with a different RetNo,
  call the virtual method of THAT return.
*)
  if RNo = 0 then exit;
  if RNo = RetNo then
    FP_2027.Calc(RetNo, FName)
  else
    RetList[RNo].Calc(RNo,FName);
end;

procedure TRetFP_2027.CalcAll;
begin
  FP_2027Calc.CALCALL(RetNo);
end;

procedure TRetFP_2027.ReCalcEveryThing;
begin
  inherited; //default to CalcAll
end;

function TRetFP_2027.GetReturnCaption: string;
begin
  Result := FP_2027ChildWinNew.GetReturnCaption(RetNo);
end;

function TRetFP_2027.NewChild: TMyChild;
begin
  Result := TMyChildFP_2027.CreateNew(Application,RetNo);
end;

function TRetFP_2027.RefreshAuditPanel(ReturnsHeaderPanel: TPanel; ErrorView: TTreeView; AuditMode: eAuditMode): string;
begin
  AuditRecsToTreeView(ErrorView,'MEWFRTSDNO');
end;
procedure TRetFP_2027.OpenAuditOrigin(SourceNode: TTreeNode);
var
  r: TAuditRec;
begin
(* override ONLY if special handling is required
  see main.TreeView1Click
*)
  if SourceNode.Data = nil then exit;
  pointer(r) := SourceNode.Data;
  If r.Form='IMPORTT1' then
  begin
    MainFormFP.ImportTaxData1Click(nil);
    Exit;
  end else
  if (r.Form <> '') then
    OpenForm(RetNo,GetFormNo(r.Form),r.Elm);
end;

function TRetFP_2027.DoSave: boolean;
begin
(* single return saving part of SaveAll - SaveAllReturns
*)
  Result := MainFormFP.DoSave(RetNo);
end;

procedure TRetFP_2027.DoSaveAs;
begin
(* FileSaveAsItemClick
*)
  MainFormFP.DoSaveAs(RetNo);
end;

function TRetFP_2027.FormClass: TvtFormClass; //20180503 Igor
begin
  Result := TFormFP_2027;
end;

function TRetFP_2027.BeforeOpenForm(var FormName: string; var FormNo: integer): string;
begin
  Result := FP_2027ChildWinNew.BeforeOpenForm(RetNo, FormName, FormNo);
end;

procedure TRetFP_2027.CountDiagnostics;
begin
  FP_2027cnterr.CountDiagnostics(RetNo);
end;

function TRetFP_2027.Close(fRemove: boolean): boolean;
begin
  if RetList[RetNo].LastYearRetNo <> 0 then //20160305 Igor
    CloseReturn(RetList[RetNo].LastYearRetNo, fRemove); //20160305 Igor
  Result := CloseReturn(RetNo, fRemove);
end;

function TRetFP_2027.GetReturnName: string;
begin
  Result := GetRetName(RetNo);
end;

procedure TRetFP_2027.SetLastYearFile(const AValue: String);
begin
  FP_2027TrimStr.SetLastYearFile(Self.RetNo, AValue);
end;

procedure TRetFP_2027.StartPrintForm(FormName: String; WhichPage: integer);
begin
  MainFormFP.StartPrintForm(RetNo,FormName,WhichPage);
end;

function TRetFP_2027.AddPageInstance(NonInstFormName,
  FormInst: string): integer;
begin
  Result := FP_2027Common2.AddPageInstance(RetNo, NonInstFormName,FormInst);
end;

function TRetFP_2027.InitFormData(FRec: TFRec): boolean;
var
  FName: string;
begin
  Result := inherited InitFormData(FRec);
  if not Result then exit;
  //FP_2027common2.InitFormData(RetNo,FNo);
  FName := FRec.FormInstName;
   With Ret[RetNo].Frm[FRec.FormNo] do
   begin
     If Fname = 'STATUS' then Strings[4]:='00';  {prpstat}
     If FName = 'SUPPL' then Calc(RetNo,'SUPPL');
   end; {with}
end;

function TRetFP_2027.IsLetterForm(AFormName: String): Boolean; //20180503 Igor
begin
  Result := FP_2027TrimStr.IsFormAClientLetter(AFormName);
end;

procedure TRetFP_2027.CloneForm(FromFormName: string; ToRetNo: integer;
  ToFormName: String; fAll: boolean);
begin
  inherited;
  Ret[ToRetNo].Calc(ToRetNo,ToFormName); //Ln[]
end;

procedure TRetFP_2027.CloneReturn(ToRetNo: integer);
begin
  inherited;
{copy other data}
  Ret[ToRetNo].MarStatus := MarStatus;
  Ret[ToRetNo].Age := Age;
  Ret[ToRetNo].Deceased := Deceased;
 // Ret[ToRetNo].Bankrupt := Bankrupt;
end;

{ TFListFP }

function TFListFP.LoadFromTable(Table1: TDataSet): TFRec;
var
  FRec: TFRec absolute Result;
begin
  FRec := TFRec.Create;
  FRec.FormNo      := Table1.FieldByName('FormNo').AsInteger;
  FRec.FormName    := UpperCase(Ltrim(RTrim(UpperCase(Table1.FieldByName('FormName').AsString))));
  FRec.DelphiForm  := StringToBoolean(Table1.FieldByName('DelphiForm').AsString);
  FRec.FormInst    := LTrim(RTrim(Table1.FieldByName('FormInst').AsString));
  FRec.FormMxInst  := Table1.FieldByName('FormMxInst').AsString;
//unused?!
   //FRec.PrintType   := Table1.FieldByName('PrintType').AsString;
  FRec.FormDescr   := Table1.FieldByName('FormDescr').AsString;
  FRec.FormMxPg    := Table1.FieldByName('FormMxPg').AsInteger;
  FRec.FormRlNm    := Table1.FieldByName('FormRlNm').AsString;
  FRec.FormAbrev   := Table1.FieldByName('FormAbrev').AsString;
  FRec.FormType    := Table1.FieldByName('FormType').AsString;
  if Table1.FieldByName('FormShow').DataType = ftBoolean then //20160704 Igor
    FRec.FormShow    := Table1.FieldByName('FormShow').asBoolean
  else
    FRec.FormShow    := Boolean(Table1.FieldByName('FormShow').AsInteger);
  Frec.FormFields  := Table1.FieldByName('FormFields').AsInteger;
  Frec.Modal       := StringToBoolean(Table1.FieldByName('Modal').AsString);
  //If Frec.FormFields = 0 then Frec.FormFields := FieldsLimit;
  if Table1.FieldByName('IsSlip').DataType = ftBoolean then //20160704 Igor
    Frec.IsSlip      := Table1.FieldByName('IsSlip').AsBoolean
  else
    Frec.IsSlip      := Boolean(Table1.FieldByName('IsSlip').AsInteger);
  if Table1.FieldByName('Preload').DataType = ftBoolean then //20160704 Igor
    Frec.Preload     := Table1.FieldByName('Preload').AsBoolean
  else
    Frec.Preload     := Boolean(Table1.FieldByName('Preload').AsInteger);
  Frec.DataIndic   := Table1.FieldByName('DataIndic').AsString;
  if Table1.FieldByName('WhiteBoxes').DataType = ftBoolean then //20160704 Igor
    Frec.WhiteBoxes  := Table1.FieldByName('WhiteBoxes').AsBoolean
  else
    Frec.WhiteBoxes  := Boolean(Table1.FieldByName('WhiteBoxes').AsInteger);
  if Table1.FieldByName('ShowFlag').DataType = ftBoolean then //20160704 Igor
    Frec.ShowFlag    := Table1.FieldByName('ShowFlag').AsBoolean
  else
    Frec.ShowFlag    := Boolean(Table1.FieldByName('ShowFlag').AsInteger);
  if Table1.FieldByName('ShowHdr').DataType = ftBoolean then //20160704 Igor
    Frec.ShowHdr     := Table1.FieldByName('ShowHdr').AsBoolean
  else
    Frec.ShowHdr     := Boolean(Table1.FieldByName('ShowHdr').AsInteger);
  Frec.PrnSeq      := Table1.FieldByName('PrnSeq').AsString;
  //If FRec.FormAbrev = '' then FRec.FormAbrev := FRec.FormName;
  Frec.LandScape   := StringToBoolean(Table1.FieldByName('LandScape').AsString);
  Frec.FormHeight  := Table1.FieldByName('FormHeight').AsInteger;
  Frec.CursorPos   := Table1.FieldByName('CursorPos').AsInteger;
end;

{ TRetFP_LastYear }

constructor TRetFP_LastYear.Create(TheApp: TApp);
begin
  FList := FLastYearList;
  inherited Create(TheApp);
  FIsLastYearReturn := True;
end;

initialization
{$IFDEF isbpl}
   Classes.RegisterClass(TAppFP_2027);   // 20151118 Igor
{$ELSE}
//   AppFP := TAppFP_2027.Create(AppList); //20170927 Igor
{$ENDIF}
end.
