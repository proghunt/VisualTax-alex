unit TF_2026;

interface

uses Classes,Forms,Controls,Windows,ComCtrls,Menus,ExtCtrls,vtMulti,
  DB,vtForm,vtChild,vtMain,TF_2026Declare,
  Dialogs, //20171031 Igor
  IOUtils, //20180503 Igor
  rxRichEd; //20160819 Igor (Must be last)

const //update every year
//  LimitedVersionDir = 'C:\VTDATA14'; //?  //20150623 //20160718 Igor Move to Declare
//license keys
//2013 factors (inc every year)
  //TFF2012 = 16;
  TFF2025 = 59; //20280827 Alex

 PgmLicenses: array[0..5] of RPgmLicenseData = (//20171031 Igor //20231211 Igor
  //TF
    //20280827 Alex >>>
    (Name:'TF Demo';        Id:'TF00'; Factor: 43; Level:llDemo),   //20160223 Igor //20240905 Igor
    (Name:'TF Standard';    Id:'TF01'; Factor: 44; Level:llStd),   //20160223 Igor //20240905 Igor
    (Name:'TF Power';       Id:'TF02'; Factor: 45; Level:llPower),   //20160223 Igor //20240905 Igor
    (Name:'TF Limited Forms';  Id:'TF03'; Factor: 46; Level:llLimitedForms), //20171031 Igor//20171018 Igor //20240905 Igor
    (Name:'TF Enterprise';  Id:'TF04'; Factor: 47; Level:llEnterprise),   //20231211 Igor //20240905 Igor
  //dummy for invalid license
    (Name:'Unlicensed'; Id:''; Factor:0; Level:llNone; Caps:[])
    //20280827 Alex <<<
  );

{--------------- Data storage definition---------}

type
  TFListTF = class(TFList)
  protected
    function LoadFromTable(Table1: TDataSet): TFRec; override;//20150917 Igor
  end;

type
  TRetTF_2026 = class(TRetData)
  public
   DaysInYear  : Integer;
  {
   CouplingSw  : Boolean;
   OntAlloc    : Real;
   TrustType   : TTrustTypes;
   TrustYear   : String;  //[4];
   PartYear    : Real;
   }
   Bankrupt    : Boolean;
   Balance     : Real;
  (*
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
   *)
   (*
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
  *)
  { from ClienTtable}
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

  TRetListTF_2026 = class(TRetList)
  private
    function GetRetTF(RetNo: integer): TRetTF_2026;
  public
    property RetTF[RetNo: integer]: TRetTF_2026 read GetRetTF; default;
  end;

  TAppTF_2026 = class(TApp2018)
  public //OptRec
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

   Prp_EfilerNo,  //20240616
   Prp_EfPassword,

   //Prp_TransmitterType,  // : string; //[1];  //jz//20250324 field removed
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

   //Prp_Name,  //     : string; //[50];

   //Prp_Street,  //   : string; //[30];
   //Prp_City,  //     : string; //[30];
   // Prp_Postal,  //   : string; //[8];
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
    function GetAppDir: string; override;
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
    function GetRightTabSheets: TRightTabSheets; Override;//20180108 Con
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
    procedure ReloadMainMenu; override; //20190307 Igor
  public //cross-app adds
    function  InitNewReturn(ForLoad: boolean = False): integer; override;
    function  OpenReturn(DirName,FlName: string; fShow: boolean; AIsAppendix: Boolean = False): integer; override;
    function SaveReturn(RetNo: Integer; DataDir: string; FlName: string;
      OverrideSW: boolean; UpdMostRecent: boolean; ATextFormat: boolean = False;
      AUpdateClientTable: boolean = True; AClouds: TArrayOfInteger = nil): Integer; override; //20200914 Igor
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
  end;

  TRetTF_LastYear = class(TRetTF_2026) //20160629 Igor
  public
    constructor Create(TheApp: TApp); override;
  end;

function  Calc(RetNo: integer; FName: string; FNo: integer=-1): TCalcRtn; overload;
Procedure CalcAffectedBy(RetNo: integer;FName: string);

var
  AppTF_2026: TAppTF_2026;
  OptRec: TAppTF_2026 absolute AppTF_2026;
  Ret: TRetListTF_2026 absolute RetList;

implementation

uses SysUtils,vtCommon,vtDialogs,vtAuthorization,vtEditBox,
  TF_2026Features,
  TF_2026TrimStr,TF_2026Common,TF_2026Common2,TF_2026CntErr,TF_2026ChildWinNew,
  TF_2026main,TF_2026Calc,TF_2026Calc1,TF_2026Calc2,TF_2026Calc3,TF_2026CalcT5013,
  TF_2026CalcSers,   //20240615
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
     //some parnership
    If FName = 'PS50PG1'  then MyCalc := @PS50Pg1
    else if LeftStr(FName,8) = 'PS50PG2#'  then MyCalc := @PS50PG2
    else if LeftStr(FName,8) = 'PS50PG3#'  then MyCalc := @PS50PG3;

    If CertificationMode=True then MyCalc := nil;               {
    {Partenership}
    If   FName = 'T5013SUM'  then MyCalc := @T5013SUM
    else if FName = 'T5013FIN'  then MyCalc := @T5013FIN
    else if FName = 'T5013WS'  then MyCalc := @T5013WS
    else if FName = 'PS1'  then MyCalc := @PS1
    else if leftstr(FName,4) = 'PS2#'  then MyCalc := @PS2
    else if FName = 'PS5'  then MyCalc := @PS5
    else if FName = 'PS6'  then MyCalc := @PS6
    else if LeftStr(FName,8) = 'PS6DTL1#'  then MyCalc := @PS6DTL1
    else if LeftStr(FName,8) = 'PS6DTL2#'  then MyCalc := @PS6DTL2
    else if LeftStr(FName,8) = 'PS6DTL3#'  then MyCalc := @PS6DTL3
    else if LeftStr(FName,4) = 'PS8#'  then MyCalc := @PS8
    else if LeftStr(FName,4) ='PS9#'  then MyCalc := @PS9

    else if FName = 'PS12'  then MyCalc := @PS12
    else if LeftStr(FName,6) = 'T5013#'  then MyCalc := @T5013  //20260903
    else if LeftStr(FName,5) = 'PS50#'  then MyCalc := @PS50
    else if FName = 'PS52'  then MyCalc := @PS52
    else if FName = 'PS56'  then MyCalc := @PS56    //20260815
    else if FName = 'PS58'  then MyCalc := @PS58
    else if FName = 'PS63'  then MyCalc := @PS63
    else if FName = 'PS65'  then MyCalc := @PS65
    else if FName = 'PS75'  then MyCalc:= @PS75
    else if LeftStr(FName,4) = 'PS78' then MyCalc:= @PS78
    else if LeftStr(FName, 5) = 'PS130' then MyCalc:= @PS130
    else if LeftStr(FName, 5) = 'PS140' then MyCalc:= @PS140

    else if FName = 'PS100'  then MyCalc := @PS100
    else if FName = 'PS141'  then MyCalc := @PS141
    else if LeftStr(FName,6) = 'PS125#'  then MyCalc := @PS125
    //else if FName = 'POTHINFO'  then begin POTHINFO(RetNo,FName,GetFormno(FName));exit; end
    else if FName = 'USEDFRM' then MyCalc := @UsedFrm
    {Schedules}

    else if FName = 'GST74'   then MyCalc := @GST74
    else if FName = 'GS176'   then MyCalc := @GS176
    else if FName = 'GS303'   then MyCalc := @GS303
    else if FName = 'T106'    then MyCalc := @T106
    else if LeftStr(FName,6) = 'T106SL#' then MyCalc := @T106SL

    //else if FName = 'T106S'    then MyCalc := @T106S  //jz//20251221 - temp remove to compile

    else if FName = 'T1134'   then MyCalc:= @T1134 //20260817 Alex
    else if FName = 'T1134S'  then MyCalc:= @T1134S //20260817 Alex

    else if FName = 'T1135'   then MyCalc := @T1135   //20180422
    //else if FName = 'PT1135'   then MyCalc := @PT1135
    else if LeftStr(Fname,7) = 'NR4DET#'   then MyCalc := @NR4DET
    else if Fname = 'NR4SUM'   then MyCalc := @NR4SUM
    else if LeftStr(Fname,5) = 'NPAD#'     then MyCalc := @NPAD
    else if LeftStr(Fname,5) = 'NPADC'    then MyCalc := @NPADC
    else if LeftStr(Fname,6) = 'PRIVAT'   then MyCalc := @PRIVAT
    //else if LeftStr(FName,6) = 'INVSTM'    then MyCalc := @INVSTM

    else if LeftStr(FName,4) = 'T3G#'    then MyCalc := @T3G
    //else if FName = 'FINVSTM'  then MyCalc := @FINVSTM
    else if LeftStr(Fname,6) = 'FLDMEM'   then MyCalc := @FLDMEM
    else if LeftStr(Fname,7) = 'FLDTAPE'   then MyCalc := @FLDTAPE
    else if FName = 'ADDINFO'  then MyCalc := @ADDINFO
    //else if FName = 'DON'  then begin DON

//    else if FName = 'POLIT'    then MyCalc := @POLIT

    else if FName = 'INVOICE'    then MyCalc := @INVOICE
    else if FName = 'INVFORMS'    then MyCalc := @INVFORMS

    else if LeftStr(FName,6) = 'T1013#'  then MyCalc := @T1013
    else if FName = 'T2081'  then MyCalc := @T2081    //20250115

    else if LeftStr(FName,6) = 'T5013#'  then MyCalc := @T5013
    else if FName = 'T5011'    then MyCalc := @T5011

    else if FName = 'T661'    then MyCalc := @T661

    else if FName = 'T5018S'  then MyCalc := @T5018S
    else if LeftStr(Fname,7) = 'T5018L#'  then MyCalc := @T5018L
    else if LeftStr(FName,7) = 'T5018G#'  then MyCalc := @T5018G
    {Charity}
    else if FName = 'T3010'    then MyCalc := @T3010

    else if LeftStr(FName,6) = 'T1235#'  then MyCalc := @T1235
    else if LeftStr(FName,6) = 'T1236#'  then MyCalc := @T1236

    else if LeftStr(FName,6) = 'T1441#'  then MyCalc := @T1441   //20230621

    {NPO}
    else if FName = 'T1044'  then MyCalc := @T1044

    else if FName = 'T3P'  then MyCalc := @T3P
    //else if FName = 'T3P_1'  then begin T3P_1
    //else if FName = 'T3P_2'  then begin T3P_2
    else if LeftStr(FName,5) = 'T3GR#'  then MyCalc := @T3GR

    {Elections}
    else if FName = 'T123'  then MyCalc := @T123

    else if FName = 'T2019'  then MyCalc := @T2019
    else if FName = 'T2022'  then MyCalc := @T2022
    else if FName = 'T2047'  then MyCalc := @T2047
    else if LeftStr(FName,7) = 'T2202WS'  then MyCalc := @T2202WS

    else if LeftStr(FName,6) = 'T2057#'  then MyCalc := @T2057  //20240519
    else if FName = 'T2054'  then MyCalc := @T2054
    else if FName = 'T2058'  then MyCalc := @T2058   //20240613
    else if FName = 'T2059'  then MyCalc := @T2059   //20240613 Igor
    else if FName = 'UHT2900'  then MyCalc := @UHT2900   //20240708 Igor

    else if FName = 'TD3'  then MyCalc := @TD3

    else if FName = 'T1OVP'  then MyCalc := @T1OVP

    else if FName = 'T137'  then MyCalc := @T137

    else if FName = 'BNK'  then MyCalc := @BNK

   // else if FName = 'T4_1'  then MyCalc := @T4_1

    else if FName = 'CUTPAST'  then MyCalc := @CUTPAST
    else if FName = 'TESTFRM'   then MyCalc := @TestFRM

    else exit;

    if not assigned(MyCalc) then
      exit; //certification mode

    FRec.Calc := MyCalc;
  end;

  if RetNo > 0 then
  begin
    FNo := FRec.FormNo;
    If (FNo > 0) then
      if (RetList[RetNo].MyApp = AppTF_2026) then //20160323 Igor
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
procedure InitTF; //from main.initialization
begin

 If CertificationMode then userMsg('Certification Mode'
   +Chr(13)+'Open new then activate a non T3 form such as TX19');

  //GetLicenseLevel;

  InitOptions;
  AppTF_2026.InitFList;
  InitFolders; //20230116 Igor
  //  OptRec.Dir_Cur :=OptRec.Dir_Deflt;
//
//  FList := TFListTF.Create(AppTF_2026, FormsLimit,FieldsLimit,FormsDBLite,FormsTableLite);//20150119 Igor
////  AppTF_2026.FList := FList;
////  AppTF_2026.lFormsDBLite    := FormsDBLite;    //20150920 Igor
////  AppTF_2026.lFormsTableLite := FormsTableLite; //20150920 Igor
//  AppTF_2026.ConvertDataBase; //20160304 Igor
//  InitFormsTable;  {all forms available}
//  InitColorTable;  {all colors available}
//  //PrintShade      :=RGB(230,230,230);
//  InitLists;       {Forms and return lists}
//  InitSwitches;
//  InitBmps;

end;

{ TRetListTF_2026 }

function TRetListTF_2026.GetRetTF(RetNo: integer): TRetTF_2026;
begin
  TObject(Result) := TypedReturn(RetNo,TRetTF_2026, False); //warnings???
end;

{ TRetTF_2026 }

constructor TRetTF_2026.Create(TheApp: TApp);

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
      //CouplingSw := False;
    
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

destructor TRetTF_2026.Destroy;

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

function TRetTF_2026.BeforeOpenForm(var FormName: string;
  var FormNo: integer): string;
begin
  //20171031 Igor>>>
  if not FList.ByFormName(FormName).Allowed then
  begin
    Result := '';
    ShowMessage(cLicenseDenied);
  end else
  //20171031 Igor<<<
    Result := TF_2026ChildWinNew.BeforeOpenForm(RetNo,FormName,FormNo);
end;

procedure TRetTF_2026.Calc(RNo: integer; const FName: string;
  FNo: integer);
begin
(* When called from within WITH with a different RetNo,
  call the virtual method of THAT return.
*)
  if RNo = 0 then exit;
  if RNo = RetNo then
    TF_2026.Calc(RNo,FName)
  else
    RetList[RNo].Calc(RNo,FName);
end;

procedure TRetTF_2026.CalcAll;
begin
  TF_2026Calc.CALCALL(RetNo);
end;

function TRetTF_2026.Close(fRemove: boolean): boolean;
begin
  if RetList[RetNo].LastYearRetNo <> 0 then //20160305 Igor
    CloseReturn(RetList[RetNo].LastYearRetNo, fRemove); //20160305 Igor
  Result := CloseReturn(RetNo, fRemove);
end;

procedure TRetTF_2026.CountDiagnostics;
begin
  TF_2026CntErr.CountDiagnostics(RetNo);
end;

function TRetTF_2026.GetDefaultFileName: String;
begin
   Result := '';
  {
  If IsT3Return(RetNo) = True then
  begin
    If Length(GetAccountNumber(RetNo)) =0 then
      Result :=RemoveSpaces(LeftStr(GetRetName(RetNo),8))+'.'+
               MidStr(GetYearEnd(RetNo),3,2)
    else
  }
      Result := LeftStr(GetAccountNumber(RetNo),8)+'.'+
                MidStr(GetYearEnd(RetNo),3,2);
end;

function TRetTF_2026.GetDfmFileName(const FName: string): string;
begin
  //20160629 Igor >>>
  //Result:=TF_2026ChildWinNew.GetDfmFileName(FName)
  If ShowUnconvertedLastYear(RetNo) = False then
    Result:=TF_2026ChildWinNew.GetDfmFileName(FName)
  else
    Result:=TF_2026ChildWinNew.GetLastYearDfmFileName(FName);
  //20160629 Igor <<<
end;


function TRetTF_2026.GetFirstName: string;
begin
  Result := FirstFormName; //RTrim(FetchElm(RetNo,'T3010',1));
end;

procedure TRetTF_2026.GetFrmTree(TreeView: TTreeView; fUsedForms: boolean);
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

function TRetTF_2026.GetFrmTreeFNo(SourceNode: TTreeNode;
  fUsedForms: boolean): integer;
begin
  Result := 0;
  //If Uppercase(FormsTreeView1.items.Item[ndx].Text)='FILLABLE CRA FORMS' then
  If Uppercase(SourceNode.Text)='FILLABLE CRA FORMS' then
  Begin
   MainFormTF.SelectFormClick(nil);
  // ConnectToWeb('http://www.cra-arc.gc.ca/menu/FIL-e.html');
   Exit;
  End;
  Result := MainFormTF.FormsTreeView1Click(SourceNode, fUsedForms);
end;

function TRetTF_2026.GetInterpetedRichEdit(LetterName: string;
  ARichEdit: TRichEdit): boolean; //20160819 Igor
begin
  Result := TF_2026TrimStr.GetInterpetedRichEdit(Self.RetNo, LetterName, ARichEdit);
end;

function TRetTF_2026.GetLastName: string;
begin
  Result := '';
end;

function TRetTF_2026.GetLastYearFile: String; //20160701 Igor
begin
  Result := TF_2026TrimStr.GetLastYearFile(Self.RetNo);
end;

function TRetTF_2026.GetReturnCaption: string;
begin
  Result := TF_2026ChildWinNew.GetReturnCaption(RetNo);
end;

function TRetTF_2026.GetReturnName: string;
begin
  Result := TF_2026TrimStr.GetRetName(RetNo);
end;

function TRetTF_2026.IsLetterForm(AFormName: String): Boolean; //20180503 Igor
begin
  Result := TF_2026TrimStr.IsFormAClientLetter(AFormName);
end;

function TRetTF_2026.NewChild: TMyChild;
begin
  Result := TMyChildTF_2026.CreateNew(Application,RetNo);
end;

function TRetTF_2026.RefreshAuditPanel(ReturnsHeaderPanel: TPanel;
  ErrorView: TTreeView; AuditMode: eAuditMode): string;
begin
  Result := MainFormTF.RefreshAuditPanel(RetNo, ReturnsHeaderPanel, ErrorView);
end;

function TRetTF_2026.DoSave: boolean;
begin
  Result := MainFormTF.DoSaveAllReturns(RetNo);  //20160223 Igor
end;

procedure TRetTF_2026.DoSaveAs;
begin
  MainFormTF.FileSaveAs(RetNo);
end;

function TRetTF_2026.FormClass: TvtFormClass; //20180503 Igor
begin
  Result := TFormTF_2026;
end;

procedure TRetTF_2026.SetLastYearFile(const AValue: String);
begin
  TF_2026TrimStr.SetLastYearFile(Self.RetNo, AValue);
end;

procedure TRetTF_2026.StartPrintForm(FormName: String; WhichPage: integer);
begin
  MainFormTF.StartPrintForm(RetNo,FormName,WhichPage);
end;

function TRetTF_2026.AddPageInstance(NonInstFormName,
  FormInst: string): integer;
begin
  Result := TF_2026Common2.AddPageInstance(RetNo, NonInstFormName,FormInst);
end;

procedure TRetTF_2026.CloneForm(FromFormName: string; ToRetNo: integer;
  ToFormName: String; fAll: boolean);
begin
  inherited CloneForm(FromFormName, ToRetNo, ToFormName, True);
  Ret[ToRetNo].Calc(ToRetNo, ToFormName);
end;

procedure TRetTF_2026.CloneReturn(ToRetNo: integer);
begin
  inherited;
{copy other data}
  Ret[ToRetNo].Bankrupt := Bankrupt;
end;

{ TAppTF_2026 }

function TAppTF_2026.AllowFormForBuildReport(const AFormName: String): Boolean; //20180424 Igor
begin
  {define forms that are visible in report builder}
  Result := false;
end;

function TAppTF_2026.MaskFormDataForBuildReport(const AFormName: String; //20180424 Igor
  AFieldNo: Integer; AFieldValue: String): String;
begin
  {mask field values}
  Result := AFieldValue;
end;


function TAppTF_2026.CheckLastYearDataFolder(
  out AErrorMessage: String): Boolean;
begin
  Result := isValidLastYearDataFolder(false,AErrorMessage); //20160629 Igor
end;

function TAppTF_2026.CheckLastYearPgmFolder(out AErrorMessage: String): Boolean; //20160516 Igor
begin
  Result := isValidLastYearPgmFolder(false,AErrorMessage); //20160629 Igor
end;

constructor TAppTF_2026.Create (AppList: TAppList); // 20151118 Igor
begin
  assert(AppTF_2026=nil,'dupe TF.Create');
  InitMulti;
  CurrentApp := self;
  AppTF_2026 := self; //required in initialization!
  AppIdx := aiTF;
  AppId := 'TF-2026';   //20150628
  ClientsDBLite:=lClientsDBLite+'_'+AppName+'.db'; //20151017 Igor !!!after AppId!!!
//  SQLLitePassword:=TFSQLLitePassword;                      //20151017 Igor //20160226 Igor
  FSQLitePassword := TSQLitePassword.Create(Self); //20160303 Igor
  //20180503 Igor >>>
  if CheckIsCloud(true) then
    TF_2026Declare.AppDir := CloudDir + '\' + AppId //20190213 Igor
  else
    TF_2026Declare.AppDir := ExeDir + '\' + AppId;
  //20180503 Igor <<<
  FFirstForm := FirstFormName; //
  //FCalcs := TCalcsT1_2012;
  InitStorage; //20180503 Igor
  InitTF; //init uDeclare
  inherited Create (AppList); // 20151118 Igor //register the AppId
  //RegisterClasses([TSlipsFrame]);
  MainFormTF := TMainFormTF_2026.Create(Application);
  AddReviewStaticForm('T5018S'); //20180210 Con
  AddReviewStaticForm('NR4SUM'); //20180210 Con
  //AddReviewStaticForm('T5013SUM'); //20180214 Con
end;

procedure TAppTF_2026.CreateDefaultDataDirectories;//20170803 Igor
begin
  TF_2026TrimStr.CreateDefaultDataDirectories;
end;

function TAppTF_2026.Factor2: Byte; //20180215 Igor
begin
  Result := TFF2025;
end;

function TAppTF_2026.GetAppDir: string;
begin
  Result := TF_2026declare.AppDir;
end;

function TAppTF_2026.GetAppName: string;
begin
  Result := TF_2026declare.AppName;
end;

function TAppTF_2026.GetAppRelease: string;
begin
   Result := TF_2026declare.AppRelease;
end;

function TAppTF_2026.GetAppUpdateDate: string;
begin
  Result := TF_2026declare.AppUpdateDate;
end;

function TAppTF_2026.GetAppYear: string;
begin
  Result := TF_2026declare.AppYear;
end;

function TAppTF_2026.GetMenu: TMainMenu;
begin
  Result := TFMenu;
  MainFormTF.ShowCellNumbers1.Checked := ShowFieldIdSw;
end;

function TAppTF_2026.GetSplash: TCustomControl;
begin
  Result := MainFormTF.AboutPanel;
end;

function TAppTF_2026.GetSQLLitePassword(const Version: Integer = GC_SQLLitePasswordVersion): String; //20160303 Igor
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

function TAppTF_2026.GetSQLLiteRFPassword(const Version: Integer): String; //20160415 Igor
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

function TAppTF_2026.GetSubstituteLastYearForm(AFormName: String): String; //20160302 Igor
begin
  Result := SubstituteLastYearForm(AFormName);
end;

function TAppTF_2026.GetToolBar: TControl; //20180122 Igor
begin
  //MainFormTF.SelectFeatures;
  MainFormTF.ZoomStr:=IntToStr(OptRec.FormZoom)+'%';
  case MainOptions.Skin of
    skSmallToolbar:
      Result := MainFormTF.CoolBar1;
	  skLargeToolbar:
      Result := MainFormTF.CoolBar2;
    skRibbon:
      Result := MainFormTF.MainUIRibbon; //20190415 Igor
  else
    Result := MainFormTF.ToolBar;
  end;
end;

function TAppTF_2026.GetValidLastYearDataFolder: Boolean; //20160302 Igor
begin
  Result := False;
end;

function TAppTF_2026.GetValidLastYearPgmFolder: Boolean; //20160302 Igor
begin
  Result := False;
end;

function TAppTF_2026.HaveOptions(AOptionsName: String): Boolean; //20170112 Igor
begin
  Result := TF_2026TrimStr.HaveOptions(AOptionsName);
end;

function TAppTF_2026.Licenses: PPgmLicenseData;
begin
  Result := @PgmLicenses[0];
end;

procedure TAppTF_2026.LoadOptionsFileToMem;
begin
  TF_2026TrimStr.LoadOptionsFileToMem;
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
  'T':  f2 := TFF2025; //key  factor2     20150623
  //'S':  f2 := S1F2013; //S1 key
  else
    exit;
  end;
  Result := MakeHashString(AKey, f1, f2);
end;

function TAppTF_2026.ImportOneReturn(ADS: TDataSet; ASrcDir, ADstDir: String; //20160627 Igor
  var AErr: String; AOverride: Boolean): Boolean;
begin
  Result := TF_2026TrimStr.ImportOneReturn(ADS, ASrcDir, ADstDir, AErr, AOverride);
end;

procedure TAppTF_2026.InitFList;
begin
  inherited;
  if not assigned(FList) then
  begin
    OptRec.Dir_Cur :=OptRec.Dir_Deflt;

    TF_2026Declare.FList := TFListTF.Create(AppTF_2026, FormsLimit,FieldsLimit,FormsDBLite,FormsTableLite);//20150119 Igor
    AppTF_2026.ConvertDataBase; //20160304 Igor
    TF_2026TrimStr.InitFormsTable;  {all forms available}
    InitColorTable;  {all colors available}
    InitLists;       {Forms and return lists}
    InitSwitches;
    InitBmps;
  end;

end;

function TAppTF_2026.InitNewReturn(ForLoad: boolean): integer;
begin
  Result := TF_2026Common.CreateNewReturn; //(ForLoad);
end;

procedure TAppTF_2026.InitStorage; //20180503 Igor
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

function TAppTF_2026.isMyreturn(const AAppName: String): Boolean;
begin
  Result := AAppName = 'TAXFORMS';
end;

procedure TAppTF_2026.OpenClientBook; //20200916 Igor
var FSaveApp: TApp;
begin
  inherited;
  FSaveApp := CurrentApp;
  try
    CurrentApp := AppTF_2026;
    MainformTF.OpenReturnLblClick(nil);
  finally
    CurrentApp := FSaveApp;
  end;
end;

function TAppTF_2026.OpenForeignForm(const ADir, AFile, AForm: String;
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
    R := TF_2026Common2.OpenReturn(ADir, AFile, False, False);
  if R <=0 then
    exit(nil);
  F := OpenForm(R, AForm, AElement);
  if Assigned(F) then
    Result := RetList[R].Form[AForm]
  else
    Result := nil;
end;

function TAppTF_2026.OpenReturn(DirName, FlName: string;
  fShow: boolean; AIsAppendix: Boolean = False): integer; //20160305 Igor
begin
  Result := TF_2026Common2.OpenReturn(DirName,FlName,fShow,AIsAppendix); //20160305 Igor
end;

procedure TAppTF_2026.ReloadMainMenu; //20190307 Igor
begin
  inherited;
  MainFormTF.ReloadMainMenu;
end;

function TAppTF_2026.SaveReturn(RetNo: Integer; DataDir: string; FlName: string;  //20200916 Igor
      OverrideSW: boolean; UpdMostRecent: boolean; ATextFormat: boolean;
      AUpdateClientTable: boolean; AClouds: TArrayOfInteger): Integer;
var FSaveApp: TApp;
begin
  FSaveApp := CurrentApp;
  try
    CurrentApp := AppTF_2026;
    Result := TF_2026Common2.SaveReturn(RetNo, DataDir, FlName, OverrideSW, UpdMostRecent, ATextFormat, AUpdateClientTable, AClouds);
  finally
    CurrentApp := FSaveApp;
  end;
end;

procedure TAppTF_2026.SaveSingleOptions(const AOptionName, AValue: String;
  AOptionsFileName: String);
begin
  inherited;
  TF_2026TrimStr.SaveSingleOption(AOptionName, AValue, AOptionsFileName);
end;

procedure TAppTF_2026.SelectFeatures;
begin
  TF_2026Features.SelectFeatures;
end;

procedure TAppTF_2026.SetZoomCaption(AZoom: Integer);
begin
  MainFormTF.ZoomStr := IntToStr(AZoom)+'%'; //20180122 Igor
end;

function TAppTF_2026.ValidateKey(AKey: String): boolean;
begin
  result:= inherited ValidateKey(AKey); //checks length and hash
  if not Result then
    exit;
  //expired/retracted
  //TF-2017
  If (LeftStr(AKey,19) = 'TF02-1785-2981-1974') //ALISON WASKUL  //20240427
  or (LeftStr(AKey,19) = 'TF02-0733-0652-1313') //HARLEY MAH  got free CRA T5013  //2023330
  or (LeftStr(AKey,19) = 'TF02-8626-7667-1950') //MICHAELG G PINNOCK
  or (LeftStr(AKey,19) = 'TF02-9019-8017-1482') //COMPUTAX SYSTEMS-C/O RICHARD HESTERMAN //20180326
  or (LeftStr(AKey,19) = 'TF02-2820-2507-1158') //MAHBOOB AHMAD CPA
  //Tf-2015  //20160209
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


function TAppTF_2026.GetRightTabSheets: TRightTabSheets; //20180108 Igor
begin
  Result := [rtsReview, rtsPrevYear]; //20180208 CON
end;


function TAppTF_2026.GetDefaultOptions: TStringList;
begin
  result := TF_2026TrimStr.GetDefaultOptions;
end;

function TAppTF_2026.GetDefaultOptionsValue(AOptionName: String): String;
begin
  result := TF_2026TrimStr.GetDefaultOptionsValue(AOptionName);
end;

function TAppTF_2026.GetOptionsCaption(AOptionName: String): String;
begin
  result := TF_2026TrimStr.GetOptionsCaption(AOptionName);
end;

function TAppTF_2026.GetDfmFileName(const FName: string): string;
begin
  Result:=TF_2026ChildWinNew.GetDfmFileName(FName)
end;

function TAppTF_2026.GetDfmFileNameLY(const FormName: string): string;
begin
  Result:=TF_2026ChildWinNew.GetLastYearDfmFileName(FormName)
end;

function TAppTF_2026.GetHelpFile: String; //20180122 Igor
begin
  //ConnectToWeb(AppTF_2026.ModuleHelpFile); //20161020 CON
  Result := 'http://www.visualtax.com/Vt2018HELP/TFHelp/Website/TFHelp.html'; //20161220 Igor
end;

function TAppTF_2026.GetHelpUpdFile: String;
begin
  Result := 'http://visualtax.com/Vt2018HELP/TFHelp/TFUPD/TFUpdHlp.html'; //20160801 Igor //20161220 Igor
end;

function TAppTF_2026.GetInitLastYear: Boolean;
begin
  if Assigned(FLastYearList) then
    Result := True
  else
  Begin
    InitLastYearFormsTable;
    result := Assigned(FLastYearList);
  End;
end;

function TAppTF_2026.GetLastYearDataFolder: String; //20160302 Igor
begin
  if Dir_LastYr[length(Dir_LastYr)] = '\' then   //20160424 Igor
    Delete(Dir_LastYr,length(Dir_LastYr)-1,1);
  Result := Dir_LastYr;
end;

function TAppTF_2026.GetLastYearFormNo(AFormName: String): Integer; //20160302 Igor
begin
  Result := TF_2026TrimStr.GetLastYearFormNo(AFormName); //20160629 Igor
end;

function TAppTF_2026.GetLimitedVersionDir: String; //20160718 Igor
begin
  Result := TF_2026Declare.LimitedVersionDir;
end;

{ TFListTF }

function TFListTF.LoadFromTable(Table1: TDataSet): TFRec;
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

{ TRetTF_LastYear }

constructor TRetTF_LastYear.Create(TheApp: TApp);
begin
  FList := FLastYearList;
  inherited Create(TheApp);
  FIsLastYearReturn := True;
end;

initialization
{$IFDEF isbpl}
   Classes.RegisterClass(TAppTF_2026);   // 20151118 Igor
{$ELSE}
//   AppTF_2026 := TAppTF_2026.Create(AppList); //20170927 Igor
{$ENDIF}
end.
