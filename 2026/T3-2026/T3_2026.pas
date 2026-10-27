unit T3_2026;

interface

uses Classes,Forms,Controls,Windows,ComCtrls,Menus,ExtCtrls,vtMulti,
  DB,vtForm,vtChild,vtMain,T3_2026Declare,
  IOUtils, //20180503 Igor
  rxRichEd; //20160819 Igor (Must be last)

const //update every year
//  LimitedVersionDir = 'C:\VTDATA14'; //?  //20150623 //20160718 Igor Move to Declare
//license keys
//2013 factors (inc every year)
  //T3F2012 = 16;
  T3F2025 = 58; //20280827 Alex //46; //36; //20160220 Igor //20220801 Igor

  PgmLicenses: array[0..4] of RPgmLicenseData = (  //20231211 Igor
  //T3
    //20280827 Alex >>>
    (Name:'T3 Demo';        Id:'T300'; Factor:42; Level:llDemo), //20240905 Igor
    (Name:'T3 Standard';    Id:'T301'; Factor:43; Level:llStd), //20240905 Igor
    (Name:'T3 Power';       Id:'T302'; Factor:44; Level:llPower), //20240905 Igor
    (Name:'T3 Enterprise';  Id:'T303'; Factor:45; Level:llEnterprise), //20231211 Igor //20240905 Igor
    //dummy for invalid license
    (Name:'Unlicensed'; Id:''; Factor:0; Level:llNone; Caps:[])
    //20280827 Alex <<<
  );

{--------------- Data storage definition---------}

type
  TFListT3 = class(TFList)
  protected
    function LoadFromTable(Table1: TDataSet): TFRec; override;//20150917 Igor
  end;

type
  TRetT3_2026 = class(TRetData)
  public
  {inherited
   Locked       : Boolean;
   Changed     : boolean;
   Frm         : Array[0..FormsLimit] of TStringList;
   FrmHasData  : Array[0..FormsLimit] of boolean;
   Notes       : string;  //[80];
   AuditList   : TStringList;
   Province    : string; //[2];
   PrpStatus   : string;  //[2];
   Ln          : Array[LnLowBound..LnHighBound] of real;
   SourceDataDir : string; //[70];  //dir it came from
   SourceFlName : string; //[50];  //file name it came from via readreturn
   CalcStatus  : Boolean;
   Saved       : boolean; - dropped
  }
   DaysInYear  : Integer;
   CouplingSw  : Boolean;
   OntAlloc    : Real;
   TrustType   : TTrustTypes; {integer;}
   TrustYear   : String;  //[4];
   PartYear    : Real;
   Bankrupt    : Boolean;
   Balance     : Real;

   {available for allocations}
   AvlbleAlloc30 : real;
   AvlbleAlloc29 : real;
   AvlbleAlloc : Array[21..52] of real; //Array[21..51] of real;  //20150117
   AvlbleFoot   : Array[1..8] of real;

   AvlbleFootQfp1,AvlbleFootQfp2,AvlbleFootQfp3:Real;
   AvlbleFootQsb1,AvlbleFootQsb2,AvlbleFootQsb3:Real;
   {AvlbleFootBox211,AvlbleFootBox212,AvlbleFootBox213:Real;}

   Avlble_36xfer, Avlble_36RetAllow,Avlble_36Don :Real;
   Avlble_42ITC, Avlble_42LiveStock:Real;
     {footnotes}
   Avlble_FtFTC, Avlble_FtECPQFP,Avlble_FtSelfEmpl,
     Avlble_FtQFP,Avlble_FtQSB:Real;
   // capture income
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
   T3FCapGains:real;

   T4APOthInc,T4APIncTax:Real;  //20211210


   T5Interest,T5FInterest,T5Pens,T5Royalty,
   T5NonElgblGains,T5Dividends,T5DividendsEligible,
   T5FNonBusInc1,T5FNonBusInc2,T5FNonBusInc3,
   T5FNonBusTax1,T5FNonBusTax2,T5FNonBusTax3 : real;

   T5013OthInc,T5013LimitedInc,T5013ITC,
   T5013ActDiv,T5013ActDivEligible, T5013CarrCharg,
   T5013CDE,T5013CEE,T5013COGPE,T5013FDE,T5013RecapDepl,
   T5013FedPol, T5013ProvPol,T5013Don,T5013Gifts,T5013Abil,
   T5013FNonBusInc1,T5013FNonBusInc2,T5013FNonBusInc3,
   T5013FNonBusTax1,T5013FNonBusTax2,T5013FNonBusTax3,
   T5013FBusInc1,T5013FBusInc2,T5013FBusInc3,
   T5013FBusTax1,T5013FBusTax2,T5013FBusTax3,
   T5013Interest, T5013Tax,
   T5013GrossIncome, T5013BusIncome,T5013FarmIncome,T5013FishIncome,T5013RentIncome,
   T5013ResAllow,T5013FInterest:real;

  {used to summarize slips}

  T3Box30:Real;
  T3Box30Res: real;
  T3Box30Pref: real;
  T3Box30NonRes: real;


  //20150117    //52 added to include non elig div in 2013 in 2014 version of T3
  T3BoxRes : Array[21..52] of real;
  T3BoxPref : Array[21..52] of real;
  T3BoxNonRes : Array[21..52] of real;
  {
  T3BoxRes : Array[21..51] of real;
  T3BoxPref : Array[21..51] of real;
  T3BoxNonRes : Array[21..51] of real;
  }
  T3FootRes : Array[1..8] of real;
  T3FootPref : Array[1..8] of real;
  T3FootNonRes : Array[1..8] of real;

  { from ClienTtable}
    EFStatus    : string; //[2]; //20210906 Igor
  public //methods, override
    constructor Create(TheApp: TApp); override;
    destructor Destroy; override;
    Function  AddPageInstance(NonInstFormName, FormInst: string): integer; override;
    Procedure CloneForm(FromFormName: string;ToRetNo: integer;ToFormName:String; fAll: boolean); override;
    Procedure CloneReturn(ToRetNo: integer); override;
    //function InitFormData(FRec: TFRec): boolean; override;
    function  Close(fRemove: boolean): boolean; override;
    function  NewChild: TMyChild; override;
    function  BeforeOpenForm(var FormName: string; var FormNo: integer): string; override;
    function  GetReturnCaption: string; override;
    function  GetReturnName: string; override; //for printing
    function  DoSave: boolean; override; //part of SaveAllReturns
    procedure DoSaveAs; override; //using SaveAs dialog
    function GetDefaultFileName: String; override; //20160305 Igor
    function GetFirstName: string; override;//20160629 Igor
    function GetLastName: string; override;//20160629 Igor
    function GetLastYearFile: String; override; //20160701 Igor
    procedure SetLastYearFile(const AValue: String); override; //20160701 Igor
  public //forms
    function  GetDfmFileName(const FName: string): string; override;
    procedure GetFrmTree(TreeView: TTreeView; fUsedForms: boolean = False); override;
    function  GetFrmTreeFNo(SourceNode: TTreeNode; fUsedForms: boolean): integer; override;
    //20180503 Igor >>>
    function FormClass: TvtFormClass; override;
    function IsLetterForm(AFormName: String): Boolean; override;
    //20180503 Igor <<<
  public //calculations
    procedure Calc(RNo: integer; const FName: string; FNo: integer = -1); override;
    procedure CalcAll; override;
    procedure CountDiagnostics; override;
  public //letters
    function GetInterpetedRichEdit(LetterName: string; ARichEdit: TRichEdit): boolean; override; //20160819 Igor
  public //visual feedback
    function RefreshAuditPanel(ReturnsHeaderPanel: TPanel; ErrorView: TTreeView; AuditMode: eAuditMode): string; override;
    procedure StartPrintForm(FormName:String;WhichPage:integer); override;
  end;

  TRetListT3_2026 = class(TRetList)
  private
    function GetRetT3(RetNo: integer): TRetT3_2026;
  public
    property RetT3[RetNo: integer]: TRetT3_2026 read GetRetT3; default;
  end;

  TAppT3_2026 = class(TApp2018)
  public //OptRec
  {inherited
   DataInBold          : Boolean;
   Dir_Cur      : string; //[70];
   ActiveBoxColor      : string; //[20];
   FormZoom            : Integer;
   NoTypeAhead         : Boolean;
  }
  {shared
   Prn_LMargin,  // : string; //[4];
   Prn_RMargin,  // : string; //[4];
   Prn_FontIncr: String;  //[1];
   UpdateFrequency     : String;
   HideMostRecent      : Boolean;
  }
   //Dir_Deflt,  //    : string; //[70]; //20170310 Igor
   Dir_LastYr,  //   : string; //[70];
   Dir_PgmLastYr, //20160321 Igor
   Dir_PrvLYr,  //   : string; //[70];
   BackUpDir,  //    : string; //[70];
   LastBackupDir,  //   : string; //[70];
   BackupFrequency : String;

   Dir_Train,  //    : string; //[40];
   Dir_Sample   : String;

   Reviewer_Name,  //: string; //[50];
   //Prp_EMail,  //    : string; //[50]; //20190523 Igor
   Prp_BusNo,  //    : string; //[15];
   Prp_RepresentativeId,     //20230101

   //Prp_TransmitterType,  // : string; //[1]; //jz//20250324 field removed
   Prp_TransmitterNo,  // : string; //[15];
   Prp_TransmitterAccountRepId, //jz//20250324 - field added

   Reviewer_EMail,  // : string; //[50];
   // 20180712 Igor >>>
   //Prp_Name,  //     : string; //[50];
   Prp_ContactName,  // : string; //[50];
   //Prp_Street,  //   : string; //[30];
   //Prp_City,  //     : string; //[30];
   Prp_Prov,  //     : string; //[2];
   //Prp_Postal,  //   : string; //[8];
   // 20180712 Igor <<<
   Prp_Countr,  //   : string; //[8];
   //Prp_Area,  //     : string; //[3]; //20190523 Igor
   Reviewer_Area,  //: string; //[3];
   //Prp_Tel,  //      : string; //[8]; //20190523 Igor
   Reviewer_Tel,  // : string; //[8];
   Prp_FxArea,  //   : string; //[3];
   Prp_Fax,  //      : string; //[8];
   Prp_DiscNo,  //   : string; //[10];
   Prp_DiscNm,  //   : string; //[30];
   Prp_GSTNo,  //    : string; //[17];
   Prp_Bill     : String; //[1];
   Prp_VSFee    : Integer;
   Prp_SFee     :Integer;
   Prp_AFee     :Integer;
   Prp_CFee     :Integer;
   Prp_VCFee    :Integer;
   Prp_GSTRat   : String;
   Prp_Hour     :Real;
   Prp_Elect    :Boolean;
   Prp_EfRepr   :Boolean;
   Prp_Dates    :Boolean;

   Nfl_Prov,  //     : string; //[2]; {New File defqaults}
   Nfl_City,  //     : string; //[20];
   Nfl_Disced   : String;

   //Prn_Shade   : Boolean;
   Prn_Head    : Boolean;
   Prn_NameH   : Boolean;
   Prn_SinH    : Boolean;
   Prn_DateH   : Boolean;
   Prn_Disclm  : string; //[80];
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
   FirstReturnColor,  //    : string; //[20];
   RolloverProgram,  //     : string; //[20];

   InvFoot1,  //            : string; //[100];
   InvFoot2,  //            : string; //[100];
   InvFoot3,  //            : string; //[100];
   InvFoot4,  //            : string; //[100];
   InvFoot5            : String;  //[100];

   ShowUsedForms       : Boolean;
   OpenAtLastForm      : Boolean;
   NoBarCode           : Boolean;
   Capitalization      : String;
  protected
  //must override
    function GetAppName: string;  override;
    function GetAppDir: string; override; //20180503 Igor
    function GetAppRelease: string;  override;
    function GetAppUpdateDate: string;  override;
    function GetAppYear: string;  override;
    function  GetDfmFileName(const FName: string): string; override;
    function GetDfmFileNameLY(const FormName: string): string; override; //20160321 Igor
    function GetSQLLitePassword(const Version: Integer = GC_SQLLitePasswordVersion): String; override; //20160226 Igor //20160303 Igor
    function GetSQLLiteRFPassword(const Version: Integer = GC_SQLLitePasswordVersion): String; override; //20160415 Igor
    function GetValidLastYearPgmFolder: Boolean; override; //20160302 Igor
    function GetValidLastYearDataFolder: Boolean; Override; //20160302 Igor
    function GetLastYearFormNo(AFormName: String): Integer; override; //20160302 Igor
    function GetSubstituteLastYearForm(AFormName: String): String; override; //20160302 Igor
    function GetLastYearDataFolder: String; override; //20160302 Igor
    function GetHelpFile: String; override; //20160526 Igor
    function GetHelpUpdFile: String; override; //20160526 Igor
    function GetInitLastYear: Boolean; Override; //20160629 Igor
    function GetLimitedVersionDir: String; override; //20160718 Igor
    procedure CreateDefaultDataDirectories; override;//20170803 Igor
    function GetRightTabSheets: TRightTabSheets; Override;//20180108 Igor
    //20180503 Igor >>>
    procedure InitStorage;
    function Factor2: Byte; override;
    //20180503 Igor <<<
  public
    constructor Create (AppList: TAppList); override; // 20151118 Igor
  //implement abstract methods
    function  GetMenu: TMainMenu; override;
    function  GetToolBar: TControl; override;//20170824 Igor
    function  GetSplash: TCustomControl; override;
    procedure SelectFeatures; override;
    //20160114 Igor
    procedure SetZoomCaption(AZoom: Integer); override;
    function ConvertToLastYearName(AFileName: String): String; override; //20180207 Igor
    procedure ReloadMainMenu; override; //20190307 Igor
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
    function HaveOptions(AOptionsName: String): Boolean; override; //20170112 Igor
    function GetDefaultOptions: TStringList; override; //20160530 Igor
    procedure InitFList; override; //20160531 Igor
    procedure LoadOptionsFileToMem; override; //20160530 Igor
    procedure SaveSingleOptions(const AOptionName, AValue: String; AOptionsFileName: String = ''); override; //20160602 Igor //20160617 Igor
    function ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String; //20160627 Igor
      var AErr: String; AOverride: Boolean): Boolean; override;
    function isMyReturn(const AAppName: String): Boolean; override;
    //20180424 Igor >>>
    function AllowFormForBuildReport(const AFormName: String): Boolean; override;
    function MaskFormDataForBuildReport(const AFormName: String; AFieldNo: Integer;
      AFieldValue: String): String; override;
    //20180424 Igor <<<
    procedure OpenClientBook; override; //20200916 Igor
  public //licenses
    function  Licenses: PPgmLicenseData; override;
    function  ValidateKey(AKey: String): boolean; override;
    function  AllowAllFieldsForBuildReport: boolean; override; //20230103 Igor
  end;

  TRetT3_LastYear = class(TRetT3_2026) //20160629 Igor
  public
    constructor Create(TheApp: TApp); override;
  end;

function  Calc(RetNo: integer; FName: string; FNo: integer=-1): TCalcRtn; overload;
Procedure CalcAffectedBy(RetNo: integer;FName: string);

var
  AppT3_2026: TAppT3_2026;
  OptRec: TAppT3_2026 absolute AppT3_2026;
  Ret: TRetListT3_2026 absolute RetList;

implementation

uses SysUtils,vtCommon,vtDialogs,vtAuthorization,vtEditBox,
  T3_2026Features,
  T3_2026TrimStr,T3_2026Common,T3_2026Common2,T3_2026CntErr,T3_2026ChildWinNew,
  T3_2026main,T3_2026Calc,T3_2026Calc1,T3_2026Calc2,T3_2026Calc3,T3_2026CalcBus,

  vtTrimStr,vtShared;

Procedure CalcAffectedBy(RetNo: integer;FName: string);
begin
  FList.CalcAffectedBy(RetNo,FName);
end;

function  Calc(RetNo: integer; FName: string; FNo: integer=-1): TCalcRtn;
Var
  FRec: TFRec;
  MyCalc: TCalcRtn;
Begin
  FRec := FList.ByFormName(FName);
  if not assigned(FRec.Calc) then
  begin
    If CertificationMode=True then  MyCalc := nil;  //2025
    if      FName = 'T3' then MyCalc := @T3
    else if FName = 'T183TRUST' then MyCalc := @T183TRUST  //20211222
    else if FName = 'EFMEMO' then MyCalc := @EFMEMO
    else if FName = 'USEDFRM' then MyCalc := @UsedFrm
    {Schedules}
    else if FName = 'S1' then MyCalc := @S1
    else if LeftStr(FName,7) = 'S1SUPQ#' then MyCalc := @S1SUPQ
    else if LeftStr(FName,8) = 'S1SUPPL#' then MyCalc := @S1SUPPL
    else if FName = 'S2' then MyCalc := @S2
    else if FName = 'S1A' then MyCalc := @S1A
    else if FName = 'S3' then MyCalc := @S3

    else if FName = 'S4' then MyCalc := @S4

    else if FName = 'S5' then MyCalc := @S5
    else if FName = 'S6' then MyCalc := @S6
    else if FName = 'S7' then MyCalc := @S7
    else if FName = 'S8' then MyCalc := @S8

    else if FName = 'S9' then MyCalc := @S9

    else if FName = 'S10' then MyCalc := @S10

    else if FName = 'S11' then MyCalc := @S11
    else if FName = 'S11A' then MyCalc := @S11A  //20170325
    else if FName = 'S12' then MyCalc := @S12
    else if FName = 'SIFT' then MyCalc := @SIFT  //20230123

    else if LeftStr(FName,4) = 'S15#' then MyCalc := @S15  //20220116 //20240129 Igor

    //20231201
    else if FName = 'T3MJ' then MyCalc := @T3MJ

    else if FName = 'T3ON' then MyCalc := @T3ON
    else if FName = 'T3AB' then MyCalc := @T3AB
    else if FName = 'T3BC' then MyCalc := @T3BC
    else if FName = 'T3NB' then MyCalc := @T3NB
    else if FName = 'T3NS' then MyCalc := @T3NS
    else if FName = 'T3NT' then MyCalc := @T3NT
    else if FName = 'T3MB' then MyCalc := @T3MB
    else if FName = 'T3NL' then MyCalc := @T3NL
    else if FName = 'T3NU' then MyCalc := @T3NU
    else if FName = 'T3PE' then MyCalc := @T3PE
    else if FName = 'T3SK' then MyCalc := @T3SK
    else if FName = 'T3YT' then MyCalc := @T3YT
    //20231202  //20140326 JZ
    else if FName = 'T3MJON' then MyCalc := @T3MJON
    else if FName = 'T3MJAB' then MyCalc := @T3MJAB
    else if FName = 'T3MJBC' then MyCalc := @T3MJBC
    else if FName = 'T3MJNB' then MyCalc := @T3MJNB
    else if FName = 'T3MJNS' then MyCalc := @T3MJNS
    else if FName = 'T3MJNT' then MyCalc := @T3MJNT
    else if FName = 'T3MJMB' then MyCalc := @T3MJMB
    else if FName = 'T3MJNL' then MyCalc := @T3MJNL
    else if FName = 'T3MJNU' then MyCalc := @T3MJNU
    else if FName = 'T3MJPE' then MyCalc := @T3MJPE
    else if FName = 'T3MJSK' then MyCalc := @T3MJSK
    else if FName = 'T3MJYT' then MyCalc := @T3MJYT

    //con 20231129
    else if FName = 'T3RCA' then MyCalc := @T3RCA
    else if FName = 'T3ATH' then MyCalc := @T3ATH
    else if FName = 'T3M' then MyCalc := @T3M
    else if FName = 'T3S' then MyCalc := @T3S
    else if FName = 'T3P' then MyCalc := @T3P
    //20240118 Igor >>>
    else if FName = 'T3PRP' then MyCalc := @T3PRP
    else if FName = 'T3GR' then MyCalc := @T3GR
    //20240118 Igor <<<
    else if FName = 'T3RI' then MyCalc := @T3RI
    else if FName = 'T3D' then MyCalc := @T3D
    else if FName = 'T1159' then MyCalc := @T1159     //202312091
    else if FName = 'T1061' then MyCalc := @T1061     //jz//20260318


    //20170609
    else if FName = 'T1079' then MyCalc := @T1079   //princ res
    else if FName = 'T1255' then MyCalc := @T1255   //princ res Deseased
    else if FName = 'T1079WS' then MyCalc := @T1079WS

    else if FName = 'T1055' then MyCalc := @T1055

    else if LeftStr(FName,6) = 'AUTOS#'  then MyCalc := @AUTOS
    else if LeftStr(FName,8) = 'ASSETSB#' then MyCalc := @ASSETSB

    else if FName = 'ABIL' then MyCalc := @ABIL
    //else if FName = 'S14_1' then begin S14_1
    // else if FName = 'S14_2' then begin S14_2
    else if FName = 'AVLBLE' then MyCalc := @AVLBLE
    else if FName = 'T3SUM' then MyCalc := @T3SUM

    else if FName = 'T3A' then MyCalc := @T3A

    else if FName = 'T3SL1' then MyCalc := @T3SL1
    else if FName = 'T3SL4' then MyCalc := @T3SL4
    else if FName = 'T3SL23' then MyCalc := @T3SL23
    else if FName = 'PENSINC' then MyCalc := @PENSINC
    else if FName = 'LETR_1'   then MyCalc := @LETR_1
    else if FName = 'LETR_2'   then MyCalc := @LETR_2
    else if FName = 'STATUS'   then MyCalc := @STATUS
    else if FName = 'T3ADJ'   then MyCalc := @T3ADJ

    else if FName = 'T3LOSS'   then MyCalc := @T3LOSS
    else if FName = 'T3DON'   then MyCalc := @T3DON

    else if LeftStr(FName,6) = 'T3SUPL' then MyCalc := @T3SUPL
    else if LeftStr(FName,8) = 'T3INCOME' then MyCalc := @T3INCOME
    else if LeftStr(FName,8) = 'T5INCOME' then MyCalc := @T5INCOME
    else if LeftStr(FName,8) = 'T4AP' then MyCalc := @T4AP           //20211210
    else if LeftStr(FName,8) = 'T5013INC' then MyCalc := @T5013INC
    else if FName = 'T3OTHDED'   then MyCalc := @T3OTHDED

    else if LeftStr(FName,5) = 'T2125' then MyCalc := @T2125  //20130217  5 not 7
    else if LeftStr(FName,5) = 'T2042' then MyCalc := @T2042
    else if LeftStr(FName,5) = 'T2121' then MyCalc := @T2121

    else if LeftStr(FName,4) = 'T776'  then MyCalc := @T776

    else if LeftStr(FName,6) = 'PRBNFR'  then MyCalc := @PRBNFR
    else if LeftStr(FName,5) = 'T3FFT'  then MyCalc := @T3FFT
    else if FName = 'T3PFT'   then MyCalc := @T3PFT
    else if FName = 'T2000'   then MyCalc := @T2000  //20231213
    else if FName = 'T2038'   then MyCalc := @T2038

    else if FName = 'T106'                then MyCalc := @T106
    else if LeftStr(FName,6) = 'T106SL'  then MyCalc := @T106SL //20260817 Alex
    //else if FName = 'T106S'               then MyCalc := @T106S //20251220

    else if FName = 'T1134'   then MyCalc := @T1134
    //else if FName = 'T1134S'  then MyCalc := @T1134S //20260817 Alex
    else if LeftStr(FName, 6) = 'T1134S'  then MyCalc:= @T1134S //20260817 Alex

    else if FName = 'T1135'   then MyCalc := @T1135
    //else if FName = 'PT1135'   then MyCalc := @PT1135

    else if LeftStr(Fname,5) = 'NPAD#'     then MyCalc := @NPAD
    else if LeftStr(Fname,5) = 'NPADC'    then MyCalc := @NPADC
    else if LeftStr(Fname,6) = 'PRIVAT'   then MyCalc := @PRIVAT
    else if LeftStr(FName,6) = 'INVSTM'    then MyCalc := @INVSTM

    else if FName = 'FINVSTM'  then MyCalc := @FINVSTM
    else if LeftStr(Fname,6) = 'FLDMEM'   then MyCalc := @FLDMEM
    else if LeftStr(Fname,7) = 'FLDTAPE'   then MyCalc := @FLDTAPE
    else if FName = 'ADDINFO'  then MyCalc := @ADDINFO
    //else if FName = 'DON'  then begin DON

    else if FName = 'POLIT'    then MyCalc := @POLIT

    else if FName = 'INVOICE'    then MyCalc := @INVOICE
    else if FName = 'INVFORMS'    then MyCalc := @INVFORMS

    //else if LeftStr(FName,6) = 'T1013#'  then MyCalc := @T1013
    // else if FName = 'T661'    then MyCalc := @T661

    else if FName = 'CUTPAST'  then MyCalc := @CUTPAST
    else if FName = 'TESTFRM'   then MyCalc := @TestFRM

    else if FName = 'T3QDT' then MyCalc := @T3QDT          //jz//20260320

    else if FName = 'T184' then MyCalc := @T184          //20220127 Igor

    else exit;

    if not assigned(MyCalc) then
      exit; //certification mode

    FRec.Calc := MyCalc;
  end;

  if RetNo > 0 then
  begin
    FNo := FRec.FormNo;
    If (FNo > 0) then
      if (RetList[RetNo].MyApp = AppT3_2026) then //20160323 Igor
      Begin
        if (Ret[RetNo].Frm[Fno].Count =0) then
          InitFormData(RetNo,FNo);
        FRec.Calc(RetNo,FName,FNo);
      End;
  end;
end;

procedure InitLists;
{MUST create the data lists AND also initialize them before using them}
var
i,j,k : integer;
s : string;
begin
  ElmsInError := TStringList.Create;
  TaxSumList := TstringList.Create;
  LoadEditBoxProperties; //20110131
  VList   := TStringList.Create;
//  Somelist := TStringList.Create; //20160216 Igor //20170512 Igor
  InitCCARates;
  InitFrmTree;
  LoadOthOpt;
end;

(*
procedure InitLists;
{MUST create the data lists AND also initialize them before using them}
var
i,j,k : integer;
s : string;
begin
  ElmsInError := TStringList.Create;
  TaxSumList := TstringList.Create;
  LoadEditBoxProperties; //20110131
  VList   := TStringList.Create;
  Somelist := TStringList.Create; //20160216 Igor

  InitCCARates;
  InitFrmTree;
  LoadOthOpt;
end;
*)
procedure InitT3; //from main.initialization
begin

 If CertificationMode then userMsg('T3 is in Certification Mode'
   +Chr(13)+'Open new then activate a non T3 form such as TX19');

  //GetLicenseLevel;

  InitOptions;
  UpdateDbStructure; //20220324 Igor
  AppT3_2026.InitFList;
  //  OptRec.Dir_Cur :=OptRec.Dir_Deflt;
//
//  FList := TFListT3.Create(AppT3_2026, FormsLimit,FieldsLimit,FormsDBLite,FormsTableLite);//20150119 Igor
////  AppT3_2026.FList := FList;
////  AppT3_2026.lFormsDBLite    := FormsDBLite;    //20150920 Igor
////  AppT3_2026.lFormsTableLite := FormsTableLite; //20150920 Igor
//  AppT3_2026.ConvertDataBase; //20160304 Igor
//  InitFormsTable;  {all forms available}
//  InitColorTable;  {all colors available}
//  //PrintShade      :=RGB(230,230,230);
//  InitLists;       {Forms and return lists}
//  InitSwitches;
//  InitBmps;

end;

{ TRetListT3_2026 }

function TRetListT3_2026.GetRetT3(RetNo: integer): TRetT3_2026;
begin
  TObject(Result) := TypedReturn(RetNo,TRetT3_2026, False); //warnings???
end;

{ TRetT3_2026 }

constructor TRetT3_2026.Create(TheApp: TApp);

  //Function InitRetData(RetNo: Integer): Boolean;
  procedure InitRetData;
   var
     i,j: integer;
   begin
      Locked := False; {for new returns only}
      Changed := False; {for new returns only}
      SourceDataDir := OptRec.Dir_cur;
      SourceFlName := '';
      Balance := 0;
      Province := OptRec.Nfl_Prov;
      Bankrupt := False;
      Notes := '';
      PrpStatus := '00';
      EFStatus := '00'; //20220117 Igor
      CouplingSw := False;
    
    {$IFDEF defaults}
      for j := LowAvlbleAlloc to HiAvlbleAlloc do
        begin
          AvlbleAlloc[j] := 0;
          T3BoxRes[j] :=0;
          T3BoxPref[j] :=0;
          T3BoxNonRes[j] :=0;
        end;
      for j := 1 to 8 do
        begin
          T3FootRes[j] := 0;
          T3FootNonRes[j] := 0;
          T3FootPref[j] := 0;
        end;

     AvlbleFootQfp1:=0;
     AvlbleFootQfp2:=0;
     AvlbleFootQfp3:=0;
     AvlbleFootQsb1:=0;
     AvlbleFootQsb2:=0;
     AvlbleFootQsb3:=0;
    {$ELSE}
    {$ENDIF}
    FRetColor := GetNextAvailColor;
  end;

begin
    //SetLength(Ln,LnHighBound+1); //made it dynamic
    SetLength(Frm, FormsLimit+1);
    SetLength(FrmHasData, FormsLimit+1);
  inherited;
  InitRetData;
end;

destructor TRetT3_2026.Destroy;

  procedure DeEnlistReturn;
  var
   i,j : integer;
  begin
    {get rid of the form stringlists}
    //for i := 1 to FormsLimit do Ret[RetNo].Frm[i].free;
    //For j:=1 to MaxDynamicArraysPerForm do
  end;

begin
  DeEnListReturn;
  inherited;
end;

function TRetT3_2026.BeforeOpenForm(var FormName: string;
  var FormNo: integer): string;
begin
  Result := T3_2026ChildWinNew.BeforeOpenForm(RetNo,FormName,FormNo);
end;

procedure TRetT3_2026.Calc(RNo: integer; const FName: string;
  FNo: integer);
begin
(* When called from within WITH with a different RetNo,
  call the virtual method of THAT return.
*)
  if RNo = 0 then exit;
  if RNo = RetNo then
    T3_2026.Calc(RNo,FName)
  else
    RetList[RNo].Calc(RNo,FName);
end;

procedure TRetT3_2026.CalcAll;
begin
  T3_2026Calc.CALCALL(RetNo);
end;

function TRetT3_2026.Close(fRemove: boolean): boolean;
begin
  if RetList[RetNo].LastYearRetNo <> 0 then //20160305 Igor
    CloseReturn(RetList[RetNo].LastYearRetNo, fRemove); //20160305 Igor
  Result := CloseReturn(RetNo, fRemove);
end;

procedure TRetT3_2026.CountDiagnostics;
begin
  T3_2026CntErr.CountDiagnostics(RetNo);
end;

function TRetT3_2026.GetDefaultFileName: String;
begin
  If IsT3Return(RetNo) = True then
  begin
    If Length(GetAccountNumber(RetNo)) =0 then
      Result :=RemoveSpaces(LeftStr(GetRetName(RetNo),8))+'.'+
               MidStr(GetYearEnd(RetNo),3,2)
    else
      Result := LeftStr(GetAccountNumber(RetNo),8)+'.'+
                MidStr(GetYearEnd(RetNo),3,2);
  end
  else
    Result := '';
end;

function TRetT3_2026.GetDfmFileName(const FName: string): string;
begin
  //20160629 Igor >>>
  //Result:=T3_2026ChildWinNew.GetDfmFileName(FName)
  If ShowUnconvertedLastYear(RetNo) = False then
    Result:=T3_2026ChildWinNew.GetDfmFileName(FName)
  else
    Result:=T3_2026ChildWinNew.GetLastYearDfmFileName(FName);
  //20160629 Igor <<<
end;


function TRetT3_2026.GetFirstName: string;
begin
  Result := RTrim(FetchElm(RetNo,'T3',1));
end;

procedure TRetT3_2026.GetFrmTree(TreeView: TTreeView; fUsedForms: boolean);
var
  FormsTreeView1: TTreeView absolute TreeView;
  TempList: TStringList;
  i: integer;
begin
(* this could become a generic function of TRetData,
    provided a unified FList.
  from main.RefreshFormsPanel
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

function TRetT3_2026.GetFrmTreeFNo(SourceNode: TTreeNode;
  fUsedForms: boolean): integer;
begin
  Result := 0;
  //If Uppercase(FormsTreeView1.items.Item[ndx].Text)='FILLABLE CRA FORMS' then
  If Uppercase(SourceNode.Text)='FILLABLE CRA FORMS' then
  Begin
   MainFormT3.SelectFormClick(nil);
  // ConnectToWeb('http://www.cra-arc.gc.ca/menu/FIL-e.html');
   Exit;
  End;
  Result := MainFormT3.FormsTreeView1Click(SourceNode, fUsedForms);
end;

function TRetT3_2026.GetInterpetedRichEdit(LetterName: string;
  ARichEdit: TRichEdit): boolean; //20160819 Igor
begin
  Result := T3_2026TrimStr.GetInterpetedRichEdit(Self.RetNo, LetterName, ARichEdit);
end;

function TRetT3_2026.GetLastName: string;
begin
  Result := '';
end;

function TRetT3_2026.GetLastYearFile: String; //20160701 Igor
begin
  Result := T3_2026TrimStr.GetLastYearFile(Self.RetNo);
end;

function TRetT3_2026.GetReturnCaption: string;
begin
  Result := T3_2026ChildWinNew.GetReturnCaption(RetNo);
end;

function TRetT3_2026.GetReturnName: string;
begin
  Result := T3_2026TrimStr.GetRetName(RetNo);
end;

function TRetT3_2026.IsLetterForm(AFormName: String): Boolean; //20180503 Igor
begin
  Result := T3_2026TrimStr.IsFormAClientLetter(AFormName);
end;

function TRetT3_2026.NewChild: TMyChild;
begin
  Result := TMyChildT3_2026.CreateNew(Application,RetNo);
end;

function TRetT3_2026.RefreshAuditPanel(ReturnsHeaderPanel: TPanel;
  ErrorView: TTreeView; AuditMode: eAuditMode): string;
begin
  Result := MainFormT3.RefreshAuditPanel(RetNo, ReturnsHeaderPanel, ErrorView);
end;

function TRetT3_2026.DoSave: boolean;
begin
  Result := MainFormT3.DoSaveAllReturns(RetNo);  //20160223 Igor
end;

procedure TRetT3_2026.DoSaveAs;
begin
  MainFormT3.FileSaveAs(RetNo);
end;

function TRetT3_2026.FormClass: TvtFormClass; //20180503 Igor
begin
  Result := TFormT3_2026;
end;

procedure TRetT3_2026.SetLastYearFile(const AValue: String);
begin
  T3_2026TrimStr.SetLastYearFile(Self.RetNo, AValue);
end;

procedure TRetT3_2026.StartPrintForm(FormName: String; WhichPage: integer);
begin
  MainFormT3.StartPrintForm(RetNo,FormName,WhichPage);
end;

function TRetT3_2026.AddPageInstance(NonInstFormName,
  FormInst: string): integer;
begin
  Result := T3_2026Common2.AddPageInstance(RetNo, NonInstFormName,FormInst);
end;

procedure TRetT3_2026.CloneForm(FromFormName: string; ToRetNo: integer;
  ToFormName: String; fAll: boolean);
begin
  inherited CloneForm(FromFormName, ToRetNo, ToFormName, True);
  Ret[ToRetNo].Calc(ToRetNo, ToFormName);
end;

procedure TRetT3_2026.CloneReturn(ToRetNo: integer);
begin
  inherited;
{copy other data}
  Ret[ToRetNo].Bankrupt := Bankrupt;
end;

{ TAppT3_2026 }

function TAppT3_2026.AllowAllFieldsForBuildReport: boolean; //20230103 Igor
begin
  Result := true;
end;

function TAppT3_2026.AllowFormForBuildReport(const AFormName: String): Boolean; //20180424 Igor
begin
  {define forms that are visible in report builder}
  Result := false;
end;

function TAppT3_2026.MaskFormDataForBuildReport(const AFormName: String; //20180424 Igor
  AFieldNo: Integer; AFieldValue: String): String;
begin
  {mask field values}
  Result := AFieldValue;
end;

function TAppT3_2026.CheckLastYearDataFolder(
  out AErrorMessage: String): Boolean;
begin
  Result := isValidLastYearDataFolder(false,AErrorMessage); //20160629 Igor
end;

function TAppT3_2026.CheckLastYearPgmFolder(out AErrorMessage: String): Boolean; //20160516 Igor
begin
  Result := isValidLastYearPgmFolder(false,AErrorMessage); //20160629 Igor
end;

function TAppT3_2026.ConvertToLastYearName(AFileName: String): String; //20180207 Igor
var
  Y: Integer;
Begin
  if tryStrToInt(RightStr(AFileName,2),Y) then
    result := LeftStr(AFileName,length(AFileName)-2)+FormatFloat('00',Y-1)
  else
    result := AFileName;
end;

constructor TAppT3_2026.Create (AppList: TAppList); // 20151118 Igor
begin
  assert(AppT3_2026=nil,'dupe T3.Create');
  InitMulti;
  CurrentApp := self;
  AppT3_2026 := self; //required in initialization!
  AppIdx := aiT3;
  AppId := 'T3-2026';   //20150628
  ClientsDBLite:=lClientsDBLite+'_'+AppName+'.db'; //20151017 Igor !!!after AppId!!!
//  SQLLitePassword:=T3SQLLitePassword;                      //20151017 Igor //20160226 Igor
  FSQLitePassword := TSQLitePassword.Create(Self); //20160303 Igor
  //20180503 Igor >>>
  if CheckIsCloud(true) then
    T3_2026Declare.AppDir := CloudDir + '\' + AppId //20190213 Igor
  else
    T3_2026Declare.AppDir := ExeDir + '\' + AppId;
  //20180503 Igor <<<
  FFirstForm := 'T3'; //???
  //FCalcs := TCalcsT1_2012;
  InitStorage; //20180503 Igor
  InitT3; //init uDeclare
  inherited Create (AppList); // 20151118 Igor //register the AppId
  //RegisterClasses([TSlipsFrame]);
  MainFormT3 := TMainFormT3_2026.Create(Application);
//  AddReviewStaticForm('T3'); //20160220 Igor //20160223
  AddReviewStaticForm('T3Sum'); //20160226 Igor
  //20180108 Igor >>>
  //AddReviewStaticForm('T5013Sum'); //20160226 Igor
  AddReviewStaticForm('S11');
  //20180108 Igor <<<
end;

procedure TAppT3_2026.CreateDefaultDataDirectories;//20170803 Igor
begin
  T3_2026TrimStr.CreateDefaultDataDirectories;
end;

function TAppT3_2026.Factor2: Byte; //20180503 Igor
begin
  Result := T3F2025;
end;

function TAppT3_2026.GetAppDir: string; //20180503 Igor
begin
  Result := T3_2026declare.AppDir;
end;

function TAppT3_2026.GetAppName: string;
begin
  Result := T3_2026declare.AppName;
end;

function TAppT3_2026.GetAppRelease: string;
begin
   Result := T3_2026declare.AppRelease;
end;

function TAppT3_2026.GetAppUpdateDate: string;
begin
  Result := T3_2026declare.AppUpdateDate;
end;

function TAppT3_2026.GetAppYear: string;
begin
  Result := T3_2026declare.AppYear;
end;

function TAppT3_2026.GetMenu: TMainMenu;
begin
  Result := T3Menu;
  MainFormT3.ShowCellNumbers1.Checked := ShowFieldIdSw;
end;

function TAppT3_2026.GetSplash: TCustomControl;
begin
  Result := MainFormT3.AboutPanel;
end;

function TAppT3_2026.GetSQLLitePassword(const Version: Integer = GC_SQLLitePasswordVersion): String; //20160303 Igor
begin
//Do not remove the old version
  case Version of
    0: Result := '';
    1: Result := AppName+Contributor1+Reverse(Contributor2)+Contributor3;
    2: Result := AppName+Contributor1+Reverse(Contributor2)+Contributor3ver2;
    3: Result := 'Q'+chr(111)+chr(103)+chr(55)+chr(78)+''+chr(65)+'$'+chr(57)+
                 '4'+chr(82)+chr(78)+chr(82)+''+'v'+chr(63)+'I'+chr(67); //20161208 Igor
    4: Result := 'R'+chr(80)+chr(89)+chr(107)+chr(71)+chr(106)+'1'+chr(107)+'a'+
                 chr(54)+chr(87)+chr(120)+'7'+chr(77)+''+chr(77)+chr(118); //20161215 Igor
  end;
end;

function TAppT3_2026.GetSQLLiteRFPassword(const Version: Integer): String; //20160415 Igor
begin
//Do not remove the old version
  case Version of
    0: Result := '';
    1: Result := Contributor1+AppName+Reverse(Contributor2)+Contributor3;
    2: Result := Contributor1+AppName+Reverse(Contributor2)+Contributor3ver2;
    3: Result := chr(98)+chr(84)+''+'1'+chr(75)+'b'+chr(80)+chr(42)+''+chr(102)+
                 'h'+chr(81)+chr(75)+chr(126)+chr(81)+chr(97)+chr(102)+chr(85); //20161208 Igor
    4: Result := chr(117)+chr(65)+'#'+chr(65)+chr(56)+chr(108)+chr(75)+chr(124)+
                 chr(48)+chr(87)+'8'+chr(88)+'~'+chr(89)+'P'+chr(51); //20161215 Igor
  end;
end;

function TAppT3_2026.GetSubstituteLastYearForm(AFormName: String): String; //20160302 Igor
begin
  Result := SubstituteLastYearForm(AFormName);
end;

function TAppT3_2026.GetToolBar: TControl; //20180117 Igor
begin
  //init global settings (SelectFeatures!)
  MainFormT3.ZoomStr:=IntToStr(OptRec.FormZoom)+'%';
  case MainOptions.Skin of
    skSmallToolbar:
      Result := MainFormT3.CoolBar1;
	  skLargeToolbar:
      Result := MainFormT3.CoolBar2;
    skRibbon:
      Result := MainFormT3.MainUIRibbon; //20190415 Igor
  else
    Result := MainFormT3.ToolBar;
  end;
end;

function TAppT3_2026.GetValidLastYearDataFolder: Boolean; //20160302 Igor
begin
  Result := False;
end;

function TAppT3_2026.GetValidLastYearPgmFolder: Boolean; //20160302 Igor
begin
  Result := False;
end;

function TAppT3_2026.HaveOptions(AOptionsName: String): Boolean; //20170112 Igor
begin
  Result := T3_2026TrimStr.HaveOptions(AOptionsName);
end;

function TAppT3_2026.Licenses: PPgmLicenseData;
begin
  Result := @PgmLicenses[0];
end;

procedure TAppT3_2026.LoadOptionsFileToMem;
begin
  T3_2026TrimStr.LoadOptionsFileToMem;
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
  'T':  f2 := T3F2025; //key  factor2     20150623
  //'S':  f2 := S1F2013; //S1 key
  else
    exit;
  end;
  Result := MakeHashString(AKey, f1, f2);
end;

function TAppT3_2026.ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String; //20160627 Igor
  var AErr: String; AOverride: Boolean): Boolean;
begin
  Result := T3_2026TrimStr.ImportOneReturn(ADS, ASrcDir, ADstDir, AErr, AOverride);
end;

procedure TAppT3_2026.InitFList;
begin
  inherited;
  if not assigned(FList) then
  begin
    OptRec.Dir_Cur :=OptRec.Dir_Deflt;

    T3_2026Declare.FList := TFListT3.Create(AppT3_2026, FormsLimit,FieldsLimit,FormsDBLite,FormsTableLite);//20150119 Igor
    AppT3_2026.ConvertDataBase; //20160304 Igor
    T3_2026TrimStr.InitFormsTable;  {all forms available}
    InitColorTable;  {all colors available}
    InitLists;       {Forms and return lists}
    InitSwitches;
    InitBmps;
  end;

end;

function TAppT3_2026.InitNewReturn(ForLoad: boolean): integer;
begin
  Result := T3_2026Common.CreateNewReturn; //(ForLoad);
end;

procedure TAppT3_2026.InitStorage; //20180503 Igor
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

function TAppT3_2026.isMyreturn(const AAppName: String): Boolean;
begin
  Result := AAppName = 'TAXFORMS';
end;

procedure TAppT3_2026.OpenClientBook; //20200916 Igor
var FSaveApp: TApp;
begin
  inherited;
  FSaveApp := CurrentApp;
  try
    CurrentApp := AppT3_2026;
    MainformT3.OpenReturnLblClick(nil);
  finally
    CurrentApp := FSaveApp;
  end;
end;

function TAppT3_2026.OpenForeignForm(const ADir, AFile, AForm: String;
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
    R := T3_2026Common2.OpenReturn(ADir, AFile, False, False);
  if R <=0 then
    exit(nil);
  F := OpenForm(R, AForm, AElement);
  if Assigned(F) then
    Result := RetList[R].Form[AForm]
  else
    Result := nil;
end;

function TAppT3_2026.OpenReturn(DirName, FlName: string;
  fShow: boolean; AIsAppendix: Boolean = False): integer; //20160305 Igor
begin
  Result := T3_2026Common2.OpenReturn(DirName,FlName,fShow,AIsAppendix); //20160305 Igor
end;

procedure TAppT3_2026.ReloadMainMenu; //20190307 Igor
begin
  inherited;
  MainFormT3.ReloadMainMenu;
end;

function TAppT3_2026.SaveReturn(RetNo: Integer; DataDir, FlName: string; //20200914 Igor //20200916 Igor
  OverrideSW, UpdMostRecent, ATextFormat, AUpdateClientTable: boolean;
  AClouds: TArrayOfInteger): Integer;
var FSaveApp: TApp;
begin
  FSaveApp := CurrentApp;
  try
    CurrentApp := AppT3_2026;
    Result := T3_2026Common2.SaveReturn(RetNo, DataDir, FlName, OverrideSW, UpdMostRecent, ATextFormat, AUpdateClientTable, AClouds);
  finally
    CurrentApp := FSaveApp;
  end;
end;

procedure TAppT3_2026.SaveSingleOptions(const AOptionName, AValue: String;
  AOptionsFileName: String);
begin
  inherited;
  T3_2026TrimStr.SaveSingleOption(AOptionName, AValue, AOptionsFileName);
end;

procedure TAppT3_2026.SelectFeatures;
begin
  T3_2026Features.SelectFeatures;
end;

procedure TAppT3_2026.SetZoomCaption(AZoom: Integer);
begin
  MainFormT3.ZoomStr := IntToStr(AZoom)+'%'; //20180117 Igor
end;

function TAppT3_2026.ValidateKey(AKey: String): boolean;
begin
  result:= inherited ValidateKey(AKey); //checks length and hash
  if not Result then exit;
  //expired/retracted
  If  (LeftStr(AKey,19) = 'T302-1911-3372-1354')   //Lane Radburn //20240523
  //Tf-2015  //20160209
  or (LeftStr(AKey,19) = 'T302-4594-5478-2184')  //ONESOURCE ACCOUNTING & TAX INC //20250327
  or (LeftStr(AKey,19) = 'TF01-7157-6362-1310')   //Ledger Domain Accounting
  //tf-2013
  or (LeftStr(AKey,19) = 'TF02-5218-4638-1785')   //Roy somir
 //TF-2011
  or (LeftStr(AKey,19) = 'TF01-6951-6179-1515')   //jim peters
 //tf-2010
 or (LeftStr(AKey,19) = 'TF01-9622-8553-1340')   //Glenn associates
 //tf-2009
 or (LeftStr(AKey,19) = 'TF01-9192-8171-1235')   //Gurmeet arora by error

 //2008?
 or (LeftStr(AKey,19) = 'TF01-0935-0831-2496')   //carol snow4
 or (LeftStr(AKey,19) = 'TF01-0515-0458-0987') //ABC tax refund
 or (LeftStr(AKey,19) = 'TF01-4711-4187-1152') //Patrick Heal
 then
 begin
  result:=False;
  exit;
 end;

 //If MidStr(AKey,16,4) = MakeHashString(AKey,PgmNames,ProductIds,PgmFactors) then


  //20150628
  Result := MidStr(AKey,16,4) = MyHashString(AKey); //20160220 Igor
  If UpperCase(LeftStr(AKey,2)) <> UpperCase(LeftStr(AppName,2)) then result:=False;  {T1 key goes with T1, etc}
 (* //20150628
 If MidStr(AKey,16,4) = MyHashString(AKey) then
   result:=True
 else
   result:=False;
 If UpperCase(LeftStr(AKey,2)) <> UpperCase(LeftStr(AppName,2)) then
   result:=False;  {T1 key goes with T1, etc}
 *)
end;

function TAppT3_2026.GetDefaultOptions: TStringList;
begin
  result := T3_2026TrimStr.GetDefaultOptions;
end;

function TAppT3_2026.GetDefaultOptionsValue(AOptionName: String): String;
begin
  result := T3_2026TrimStr.GetDefaultOptionsValue(AOptionName);
end;

function TAppT3_2026.GetOptionsCaption(AOptionName: String): String;
begin
  result := T3_2026TrimStr.GetOptionsCaption(AOptionName);
end;

function TAppT3_2026.GetRightTabSheets: TRightTabSheets; //20180108 Igor
begin
  Result := [rtsReview, rtsPrevYear]; //20180205 Igor
end;

function TAppT3_2026.GetDfmFileName(const FName: string): string;
begin
  Result:=T3_2026ChildWinNew.GetDfmFileName(FName)
end;

function TAppT3_2026.GetDfmFileNameLY(const FormName: string): string;
begin
  Result:=T3_2026ChildWinNew.GetLastYearDfmFileName(FormName)
end;

function TAppT3_2026.GetHelpFile: String; //20180118 Igor
begin
  //ConnectToWeb(AppT3_2026.ModuleHelpFile); //20161020 CON
  Result := 'http://www.visualtax.com/Vt2016HELP/TFHelp/Website/TFHelp.html'; //20161220 Igor
end;

function TAppT3_2026.GetHelpUpdFile: String;
begin
  Result := 'http://visualtax.com/Vt2018HELP/T3Help/T3UPD/T3UpdHlp.html'; //20160801 Igor //20161220 Igor
end;

function TAppT3_2026.GetInitLastYear: Boolean;
begin
  if Assigned(FLastYearList) then
    Result := True
  else
  Begin
    InitLastYearFormsTable;
    result := Assigned(FLastYearList);
  End;
end;

function TAppT3_2026.GetLastYearDataFolder: String; //20160302 Igor
begin
  if Dir_LastYr[length(Dir_LastYr)] = '\' then   //20160424 Igor
    Delete(Dir_LastYr,length(Dir_LastYr)-1,1);
  Result := Dir_LastYr;
end;

function TAppT3_2026.GetLastYearFormNo(AFormName: String): Integer; //20160302 Igor
begin
  Result := T3_2026TrimStr.GetLastYearFormNo(AFormName); //20160629 Igor
end;

function TAppT3_2026.GetLimitedVersionDir: String; //20160718 Igor
begin
  Result := T3_2026Declare.LimitedVersionDir;
end;

{ TFListT3 }

function TFListT3.LoadFromTable(Table1: TDataSet): TFRec;
var
  FRec: TFRec absolute Result;
begin
  Result := TFRec.Create;
    FRec.FormNo      := Table1.FieldByName('FormNo').AsInteger;
    FRec.FormName    := UpperCase(Ltrim(RTrim(UpperCase(Table1.FieldByName('FormName').AsString))));
    FRec.FormInst    := LTrim(RTrim(Table1.FieldByName('FormInst').AsString));
    FRec.FormMxInst  := Table1.FieldByName('FormMxInst').AsString;
    FRec.FormDescr   := Table1.FieldByName('FormDescr').AsString;
    FRec.FormMxPg    := Table1.FieldByName('FormMxPg').AsInteger;
    FRec.FormRlNm    := Table1.FieldByName('FormRlNm').AsString;
    FRec.FormAbrev   := Table1.FieldByName('FormAbrev').AsString;
    FRec.FormType    := Table1.FieldByName('FormType').AsString;
    if Table1.FieldByName('FormShow').DataType = ftBoolean then //20160629 Igor
       FRec.FormShow := Table1.FieldByName('FormShow').AsBoolean
    else
       FRec.FormShow := Boolean(Table1.FieldByName('FormShow').AsInteger);
    Frec.FormFields  := Table1.FieldByName('FormFields').AsInteger;
    //If Frec.FormFields = 0 then Frec.FormFields := FieldsLimit;
    if Table1.FieldByName('IsSlip').DataType = ftBoolean then  //20160629 Igor
      Frec.IsSlip      := Table1.FieldByName('IsSlip').AsBoolean
    else
      Frec.IsSlip      := Boolean(Table1.FieldByName('IsSlip').AsInteger);

    if Table1.FieldByName('Preload').DataType = ftBoolean then  //20160629 Igor
      Frec.Preload     := Table1.FieldByName('Preload').AsBoolean
    else
      Frec.Preload     := Boolean(Table1.FieldByName('Preload').AsInteger);

    Frec.DataIndic   := Table1.FieldByName('DataIndic').AsString;

    if Table1.FieldByName('WhiteBoxes').DataType = ftBoolean then  //20160629 Igor
      Frec.WhiteBoxes  := Table1.FieldByName('WhiteBoxes').AsBoolean
    else
      Frec.WhiteBoxes  := Boolean(Table1.FieldByName('WhiteBoxes').AsInteger);

    if Table1.FieldByName('ShowFlag').DataType = ftBoolean then  //20160629 Igor
      Frec.ShowFlag  := Table1.FieldByName('ShowFlag').AsBoolean
    else
      Frec.ShowFlag  := Boolean(Table1.FieldByName('ShowFlag').AsInteger);

    if Table1.FieldByName('ShowHdr').DataType = ftBoolean then  //20160629 Igor
      Frec.ShowHdr  := Table1.FieldByName('ShowHdr').AsBoolean
    else
      Frec.ShowHdr  := Boolean(Table1.FieldByName('ShowHdr').AsInteger);
    Frec.LandScape  := StringToBoolean(Table1.FieldByName('LandScape').AsString);
    Frec.PrnSeq     := Table1.FieldByName('PrnSeq').AsString; //really string!
    Frec.CursorPos  := Table1.FieldByName('CursorPos').AsInteger;
    Frec.FormHeight  := Table1.FieldByName('FormHeight').AsInteger;
    Frec.Fee         := Table1.FieldByName('Fee').AsString;
    Frec.FeeAddItem  := Table1.FieldByName('FeeAddItem').AsString;
end;

{ TRetT3_LastYear }

constructor TRetT3_LastYear.Create(TheApp: TApp);
begin
  FList := FLastYearList;
  inherited Create(TheApp);
  FIsLastYearReturn := True;
end;

initialization
{$IFDEF isbpl}
   Classes.RegisterClass(TAppT3_2026);   // 20151118 Igor
{$ELSE}
   //AppT3_2026 := TAppT3_2026.Create(AppList); // 20151118 Igor
{$ENDIF}
end.
