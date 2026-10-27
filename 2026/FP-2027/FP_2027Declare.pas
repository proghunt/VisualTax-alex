unit FP_2027Declare;

interface

uses
  WinTypes, ComCtrls, Controls, Classes, Contnrs, Graphics, ExtCtrls, VtEditBox,
  vtMulti, vtShared, uADCompClient; // 20150921 Igor

const //update every release

  IsDraft=True;  //20251217
  AppUpdateDate= '2026/04/30';

  AppYear = '2027';
  AppYearInt = 2027;
  AppVersion = '2027';
  T1AppYear= '2026';//'2024'; //for interface
  LimitedVersionDir = 'C:\VT-FPData27'; //'C:\FPDATA15'; //20160718 Igor
  AppRelease = '1.0';  // split mortgage on cashflow

const
  AppName = 'FP';
  AppTitle = 'Client Profile';   {for win caption}
  PswNum = 1945;     //not used i belive    //20260505

  //DBForms  = 'FPScr.db f;    //20150918 Igor
  FormsDBLite    = 'FPScr.DB'; //20150918 Igor
  FormsTableLite = 'FPScr';    //20150918 Igor

  FormsCfgDBLite    = 'FPCfg.DB'; //20150921 Igor
  FormsCfgTableLite = 'FPCfg';    //20150921 Igor

  cfgClientsDbLite_noUse = 'FpClients'; //20150920 Igor
  CfgDbLite     = 'FpClients.db';    //20150920 Igor
  CfgTableLite  = 'FpClients';       //20150920 Igor

  FormsFeesDBLite    = 'Fees.DB'; //20150923 Igor
  FormsFeesTableLite = 'Fees';    //20150923 Igor

  //FundsDb       = 'MutualFunds.db f;   //20150922 Igor //'FundBase';
  FundsDbLite     = 'MutualFunds.db';    //20150922 Igor
  FundsTableLite  = 'MutualFunds';       //20150922 Igor

  //MutualFundsdb = 'MutualFunds.db f;         //20150922 Igor
  MutualFundsDbLite     = 'MutualFunds.db';    //20150922 Igor
  MutualFundsTableLite  = 'MutualFunds';       //20150922 Igor

  AgentsDBLite    = 'Agents.db'; //20150920 Igor
  AgentsTableLite = 'Agents';    //20150920 Igor


  //RecentFlName='Recent.txt';
  BlackBoxDir='C:\temp';
  //OptionsFlName='Options.txt';
  //YesNoSet =['Y','y','N','n'];
  LimitedVersionReturns = 3;
  //modelportfolios
  ModelPortfoliosFlName='ModelPortfolios';
  ModelPortfoliosSIN='999999999';

  Dummy      = 'CO';
  ModuleOffColor = ClSilver; (* $00FFB51C; *) (* $00EEA000; *)
  ModuleOnColor = $008080FF; {clRed;}
  SubModuleOffColor = clSilver; (* $00FFDB91; *)
  AuthorizationPosition = 9;
    LightGreen=$00A7FCE2; //$00E6FFCC;
  DarkShade=$00B4B4B4; //rgb(180,180,180);
  MyBlue  = $00AC7400;
  MyBlueGrey = $00E3DCCC;
  MyLightBlue = $00FFFFE1;
  MyBeige =$00C8D0D8;
  MyBronze = $A6CAF0;
  MyYellow =$00C5EEFE;
  MyLightYellow=$00DBFFFF;
  PinkishColor=$00AEAEFF;//$008080FF; //255,174,174 //rgb(255,128,128)
  brightGreen=$0097FF97; //rgb(151,255,151
  BluishColor=$00FADDA0; //rgb (160,221,250)

  {ENCRYPTION parameters}
  C1 = 52845;  C2 = 22719;
  DblQuote = '"';
  MyPassword = Dummy+'STAS2';
  {Capacity}
{$IFDEF ReturnsLimit}
  ReturnsLimit = 10;
{$ELSE}
{$ENDIF}
  FormsLimit   = 400; //MaxBuckets = 6000;
  LnLowBound   = 1;  LnHighBound  = 600;
  //LabelProperties = 9;  LineProperties  = 8;  FieldProperties = 13;
 // LabelsLimit  = 200;  FieldsLimit  = 400;  LinesLimit   = 200;
  FieldsLimit  = 600;
  FirstFormName = 'PROFILE';
  BoxHeight    = 14;{15;} {height of edit box}
  DefFontName =  'Arial';
  ParseDelimiter :  String[1] = '/'; {Chr(254);}
  Delimiter    : String[1] = Chr(127); {Chr(126);}  {in file i/o between vriables}

  KeyWDelimiter1 : String[1] = '\';
  KeyWDelimiter2 : String[1] = '\';
  RecentQuoteChar: Char = '·';
  RecentDelimiter: Char = #9;
 {
  KeyWDelimiter1 : String[1] = '[';
  KeyWDelimiter2 : String[1] = ']';
  }
  MarDescr : Array[1..6] of string =
   ('Married','Common-law','Widowed','Divorced',
    'Separated','Single');

   ClientTblNames : Array[1..12] of string =
  ('Clients',
   'Assets',
   'Liabilities',
   'LifeInsurance',
   'ProblemsSolutions',
   'GoalsObjectives',
   'ActionGeneral',
   'ActionPlan',
   'PortFolios',
   'PortfolioDetails',
   'Accounts',
   'Transactions');

   AssetTypes:  Array[1..6] of string =
   ('Cash',
   'Income',
   'Income & Growth',
   'Balanced',
   'Global Growth',
   'Aggressive Growth');


  AccountTypes : Array[1..13] of string =
  ('01 OPEN',
   '02 RRSP',
   '02 SPOUSAL',
   '04 RRIF',
   '05 RESP-IND',
   '06 RESP-FAM',
   '07 DPSP',
   '08 RHOSP',
   '09 OTHER',
   '10 LIF',
   '11 LIRA',
   '12 LRIF',
   '13 RRTF');

  TransactionStatus : Array[1..11] of string =
  ('WIP',
   'Hold',
   'HO Ready',
   'FS Ready',
   'Xmitted',
   'Accepted',
   'Rejected',
   'Posted',
   'Settled',
   'Confirmed',
   'Cancelled');

  Titles : Array[1..6] of string =
   ('#','Mr','Mrs','Miss','Dr','Prof');
  PrvShort : Array[1..13] of string =
   ('NL','PE','NS','NB','QC','ON','MB','SK','AB','BC','NT','YT','ZZ');
  PrvRate : Array[1..13] of real =
   (0.69,0.595,0.575,0.60,0.00,0.3950,0.4850,0.48,0.44,0.4950,0.45,0.50,0.52);

  PrvLong : Array[1..13] of string =
   ('New Foundland','Prince Edward Island','Nova Scotia',
    'New Brunswick','Quebec','Ontario','Manitoba',
    'Saskatchewan','Alberta','British Columbia',
    'Northwest Territories','Yukon Territory','Non Resident');

  PRPStatusCodes : array [0..6] of string =
   ('00','01','02','03','04','05','06');
  PRPStatusDescr : array [0..6] of string =
   ('WIP','Not Started','Missing Data','Printed','Ready To Print', 'Review Stage',
     'Finished');
  PRPQueries : array [0..7] of string =
   ('WIP','NotStart','MissData','Printed','ReadyPr','InReview',
    'Finish','Reasses');

type
  TProbateRec = class
   Estate      :LongInt;
   Probate     :Real;
  end;
  TProbateList  = class(TObjectList)
  private
    function GetItems(index: integer): TProbateRec;
  public
    property Items[index: integer]: TProbateRec read GetItems; default;
  end;
var
  ProbateList  : TProbateList;
  ProbateRec   : TProbateRec;

type
  TAssetSumRec = class
   AssetType:String;
   TotalValue    :Real;
   TotalYield    :Real;
   YieldPercent  :Real;
  end;
  TAssetSumList  = class(TObjectList)
  private
    function GetItems(index: integer): TAssetSumRec;
  public
    property Items[index: integer]: TAssetSumRec read GetItems; default;
  end;
var
  AssetSumList   : TAssetSumList;
  AssetSumRec    : TAssetSumRec;


type
 TTaxRec = record
   Age: Integer;
   MaritalStatus: Integer;
   Province: String[2];
   PartYear: Real;
   TaxableIncome: Real;
   ActualDividendsNonElig: Real;
   ActualDividendsElig: Real;
   ActualCapitalGains: Real;
   EligiblePensionIncome: Real;
   SpouseNetIncome: Real;
   //clawback is after fed tax
 end;
var
  TaxRec:TTaxRec;

type
 AAssetsSumRec = record
   AutosTotalValueCl: Real;
   CashTotalValueCl: Real;
   HomesTotalValueCl :Real;
   VacPropTotalValueCl :Real;
   InvestPropTotalValueCl :Real;
   OthFixedTotalValueCl: Real;
   NonShTotalValueCl: Real;
   SheltTotalValueCl: Real;
   SemShTotalValueCl: Real;
   BusinessNonIncTotalValueCl :Real;
   BusinessIncTotalValueCl :Real;
   OthAssetsTotalValueCl: Real;

   CashTotalValueSp: Real;
   AutosTotalValueSp: Real;
   HomesTotalValueSp :Real;
   VacPropTotalValueSP :Real;
   OthFixedTotalValueSP :Real;
   InvestPropTotalValueSp :Real;
   NonShTotalValueSp: Real;
   SheltTotalValueSp: Real;
   SemShTotalValueSp: Real;
   BusinessNonIncTotalValueSp :Real;
   BusinessIncTotalValueSp :Real;
   OthAssetsTotalValueSp: Real;


   CashTotalValue: Real;
   AutosTotalValue: Real;
   HomesTotalValue :Real;
   NonShTotalValue: Real;
   SheltTotalValue: Real;
   SemShTotalValue: Real;
   OtherTotalValue: Real;

   NonShYieldPercent: Real;
   SheltYieldPercent: Real;
   SemShYieldPercent: Real;
   OtherYieldPercent: Real;

   SemShTotalYield: Real;
   SheltTotalYield: Real;
   NonShTotalYield: Real;
   OtherTotalYield: Real;
 end;
var
  AssetsSumRec: AAssetsSumRec;

 type
 ADetAssetSumRec = record
   CashTotalValue: Real;
   TermDepTotalValue:Real;
   GICTotalValue: Real;
   CSBTotalValue :Real;
   BondsTotalValue :Real;
   LoansTotalValue: Real;
   MFRRSPTotalValue: Real;
   RRSPOtherTotalValue: Real;
   StocksTotalValue:Real;
   DefPlansTotalValue: Real;
   HomesTotalValue :Real;
   VacationPropTotalValue: Real;
   IncomePropTotalValue: Real;
   AutosTotalValue:Real;
   BusNonIncTotalValue: Real;
   BusIncTotalValue :Real;
   MfOtherTotalValue: Real;
   OtherAssetsTotalValue: Real;
 end;
var
  DetAssetSumRec: ADetAssetSumRec;

type
 ADetLiabilitiesSumRec = record
   BillsTotalValue: Real;
   IncTaxTotalValue:Real;
   CreditCardTotalValue: Real;
   MortgageTotalValue :Real;
   CarLoanTotalValue: Real;
   OtherTotalValue: Real;
   BankAdvTotalValue: Real;
 end;
var
  DetLiabilitiesSumRec: ADetLiabilitiesSumRec;

type
 AProposedBuySellRec = record
  NonShBuy:Real;
  NonShSell :Real;
  SemShBuy  :Real;
  SemShSell :Real;
  SheltBuy  :Real;
  SheltSell :Real;
  OtherBuy  :Real;
  OtherSell :Real;

  AutosBuy  :Real;
  AutosSell : Real;

  HomesBuy  :Real;
  HomesSell : Real;
 end;
var
  ProposedBuySellRec     : AProposedBuySellRec;

type
 ALiabilitySumRec = record
   BankAdvancesCl: Real;
   AccountsPayableCl: Real;
   HomeMortgageCl  : Real;
   VacPropMortgageCl  : Real;
   InvestPropMortgageCl  : Real;
   CarLoanCl         :Real;
   OtherLtlCl       :Real;

  // LongTermDebtCl: Real;

   BankAdvancesSp: Real;
   AccountsPayableSp: Real;
   HomeMortgageSp  : Real;
   VacPropMortgageSP  : Real;
   InvestPropMortgageSp  : Real;
   CarLoanSp         :Real;
   OtherLtlSp       :Real;

  // LongTermDebtSp: Real;

   LongTermMonthlyCl: Real;
   LongTermMonthlySp: Real;
  // LongTermMonthly: Real;
 end;
var
  LiabilitySumRec: ALiabilitySumRec;

type
 TLifeInsuranceRec = record
   CashSurrenderValue: Real;
   AnnualPremium      : Real;
   SelfCoverage     :Real;
   SpouseCoverage     :Real;
 end;
var
  LifeInsuranceRec: TLifeInsuranceRec;

 {Accum Types}
type
 TBalanceRec = class
 public
   PeriodNo     :integer;
   Year         :Integer;
   Age          : Array[0..1] of Integer;
   BegBalance   : Array[1..4] of Real;
   RegContr     : Array[1..4] of Real;
   RegWithdr    : Array[1..4] of Real;
   LumpSumContr : Array[1..4] of Real;
   LumpSumWithDr: Array[1..4] of Real;
   EndBalance   : Array[1..4] of Real;
   EndActual    : Array[1..4] of Real;
   Notes        : Array[1..4] of String;
  end;
  TBalanceList = class(TObjectList)
  private
    function GetItems(index: integer): TBalanceRec;
  public
    property Items[index: integer]: TBalanceRec read GetItems;
  end;
  //PBalanceList = TBalanceRec;
var  {Accum variables}
  BalanceList   : TBalanceList;
  BalanceRec    : TBalanceRec;

type
 TTotInvestmentsRec = class
 public
   PeriodNo    :integer;
   Year        :Integer;
   Age         :Integer;
   BegBalance  :Array[1..4] of real;
   EndBalance  :Array[1..4] of real;
   TotBegBalance     : Real;
   TotEndBalance     : Real;
 end;
 //PTotInvestmProjectionList  = TTotInvestmentsRec;  {list of pointers to records}
 TTotInvestmProjectionList  = class(TObjectList)
  private
    function GetItems(index: integer): TTotInvestmentsRec;
 public
  property Items[index: integer]: TTotInvestmentsRec read GetItems;
 end;
var
  TotInvestmProjectionList   : TTotInvestmProjectionList;
  TotInvestmProjectionRec    : TTotInvestmentsRec;

type
 TLiabilitiesProjectionRec = class
 public
   PeriodNo    :integer;
   Year        :Integer;
   Age         :Integer;
   Mortgages   :Real;
   Automobiles :Real;
   Other       :Real;
   TotLiability: Real;

   MonthlyMortgage :Real;
   MonthlyAuto   :Real;
   MonthlyOther  :Real;
 end;
 //PLiabilitiesProjectionList  = TLiabilitiesProjectionRec;  {list of pointers to records}
 TLiabilitiesProjectionList  = class(TObjectList)
  private
    function GetItems(index: integer): TLiabilitiesProjectionRec;
  public
    property Items[index: integer]: TLiabilitiesProjectionRec read GetItems; default;
  end;
var
  LiabilitiesProjectionList   : TLiabilitiesProjectionList;
  LiabilitiesProjectionRec    : TLiabilitiesProjectionRec;

type
 TFixedAssetsProjectionRec = class
 public
   PeriodNo    :integer;
   Year        :Integer;
   Age         :Integer;
   Autos       :Real;
   Homes       :Real;
   VacationPr  :Real;
   IncomeProp  :Real;
   BusNonIncorp :Real;
   BusIncorp    :Real;
   OtherFixed   :Real;
   Other        :Real;
   Total        :Real;
   AutosOrigCost:Real;
   HomesOrigCost:Real;
   VacationPrOrigCost :Real;
   IncomePropOrigCost :Real;
   BusNonIncorpOrigCost :Real;
   BusIncorpOrigCost    :Real;
   OtherFixedOrigCost   :Real;
   OtherOrigCost        :Real;
   AutosCapGain:Real;
   HomesCapGain:Real;
   VacationPrCapGain :Real;
   IncomePropCapGain :Real;
   BusNonIncorpCapGain :Real;
   BusIncorpCapGain    :Real;
   OtherFixedCapGain   :Real;
   OtherCapGain        :Real;
  end;
  //PFixedAssetsProjectionList  = TFixedAssetsProjectionRec;  {list of pointers to records}
  TFixedAssetsProjectionList  = class(TObjectList)
  private
    function GetItems(index: integer): TFixedAssetsProjectionRec;
  public
    property Items[index: integer]: TFixedAssetsProjectionRec read GetItems; default;
  end;
var
  FixedAssetsProjectionList   : TFixedAssetsProjectionList;
  FixedAssetsProjectionRec    : TFixedAssetsProjectionRec;

type
  TBusinessProjectionRec = class
  public
   PeriodNo    :integer;
   Year        :Integer;
   Age         :Integer;
   BusNonIncorp :Real;
   BusIncorp    :Real;
   Other        :Real;
   Total        :Real;
   BusNonIncorpOrigCost :Real;
   BusIncorpOrigCost    :Real;
   OtherOrigCost        :Real;
   BusNonIncorpCapGain :Real;
   BusIncorpCapGain    :Real;
   OtherCapGain        :Real;
  end;
 //PBusinessProjectionList  = TBusinessProjectionRec;  {list of pointers to records}
  TBusinessProjectionList  = class(TObjectList)
  private
    function GetItems(index: integer): TBusinessProjectionRec;
  public
    property Items[index: integer]: TBusinessProjectionRec read GetItems; default;
  end;
var
  BusinessProjectionList   : TBusinessProjectionList;
  BusinesssProjectionRec   : TBusinessProjectionRec;

type
  TNetWorthProjectionRec = class
  public
   PeriodNo    :integer;
   Year        :Integer;
   Age         :Integer;
   TotAssets   :Real;
   TotLiabilities : Real;
   CapGains     :Real;
   CapGainsTaxes:Real;
   NetWorth    :Real;
   Notes       :String;
  end;
  TNetWorthProjectionList  = class(TObjectList)
  private
    function GetItems(index: integer): TNetWorthProjectionRec;
  public
    property Items[index: integer]: TNetWorthProjectionRec read GetItems; default;
  end;
var
  NetWorthProjectionList   : TNetWorthProjectionList;
  NetWorthProjectionRec    : TNetWorthProjectionRec;

type
 TCashFlowProjectionRec = class
 public
   PeriodNo    :integer;
   Year        :Integer;
   Age         :Integer;
   //0 for client, 1 for spouse
   Empl        : Array[0..1] of Real;
   InvInterest : Array[0..1] of Real;
   InvActualDivNonElig: Array[0..1] of Real;
   InvActualDivElig: Array[0..1] of Real;
   InvOther    : Array[0..1] of Real;
   BusAndOther : Array[0..1] of Real;
   PensCpp     : Array[0..1] of Real;
   PensOAS     : Array[0..1] of Real;
   PensOther   : Array[0..1] of Real;
   OthInc      : Array[0..1] of Real;
   TotIncome   : Array[0..1] of Real;
   NonTaxableIncome  : Array[0..1] of Real;
   EstTax      : Array[0..1] of Real;
   TaxRate     : Array[0..1] of Real;
   //for both
   Cola        : Real;
   LTermDebt   : Real;
   DispInc     : Real; //Array[0..1] of Real;
  end;
 //PCashFlowProjectionList  = TCashFlowProjectionRec;  {list of pointers to records}
  TCashFlowProjectionList  = class(TObjectList)
  private
    function GetItems(index: integer): TCashFlowProjectionRec;
  public
    property Items[index: integer]: TCashFlowProjectionRec read GetItems; default;
  end;
var
  CashFlowProjectionList   : TCashFlowProjectionList;
  CashFlowProjectionRec    : TCashFlowProjectionRec;

type
  TInvProjectionRec = class
  public
   PeriodNo    :integer;
   Year        :Integer;
   //0 for client, 1 for spouse
   Age         : Array[0..1] of Integer;
   DispInc     : Real;
   NonSh       : Real;
   Shelt       : Array[0..1] of Real;
   SemiSh      : Real;
   Other       : Real;
  end;
  //PInvProjectionList  = TInvProjectionRec;  {list of pointers to records}
  TInvProjectionList  = class(TObjectList)
  private
    function GetItems(index: integer): TInvProjectionRec;
  public
    property Items[index: integer]: TInvProjectionRec read GetItems; default;
  end;
var
  InvProjectionList   : TInvProjectionList;
  InvProjectionRec    : TInvProjectionRec;

type
  TRRSPProjectionRec = class
  public
   PeriodNo     :integer;
   Year         :Integer;
   DollarLimit  : Real;
   //0 for client, 1 for spouse
   Age          : Array[0..1] of Integer;
   PriorYrEarned:Array[0..1] of Real;
   PriorYrPA    : Array[0..1] of Real;
   PriorYrUnusedRoom: Array[0..1] of Real;
   DedLimit     : Array[0..1] of Real;
   RRSPContr    : Array[0..1] of Real;
  end;
  //PRRSPProjectionList  = TRRSPProjectionRec;  {list of pointers to records}
  TRRSPProjectionList  = class(TObjectList)
  private
    function GetItems(index: integer): TRRSPProjectionRec;
  public
    property Items[index: integer]: TRRSPProjectionRec read GetItems; default;
  end;
var
  RRSPProjectionList   : TRRSPProjectionList;
  RRSPProjectionRec    : TRRSPProjectionRec;


type
  TGenBalanceRec = class
  public
   PeriodNo     :integer;
   Year         :Integer;
   Age          :Integer;
   BegBalance   : Real;
   RegContr     : Real;
   RegWithdr    : Real;
   LumpSumContr : Real;
   LumpSumWithDr: Real;
   EndBalance   : Real;
   EndActual    : Real;
   Notes        : String[40];
  end;
  TGenBalanceList  = class(TObjectList)
  private
    function GetItems(index: integer): TGenBalanceRec;
  public
    property Items[index: integer]: TGenBalanceRec read GetItems; default;
  end;
var
  GenBalanceList: TGenBalanceList;
  FutValRec,  //     : PgenBalanceList;
  GenBalanceRec : TGenBalanceRec;  //for RIF calcs

type
 TAllRifRec = class
 public
   PeriodNo     :integer;
   Year         :Integer;
   Age          :Integer;
   BegBalance   : Real;
   RegContr     : Real;
   RegWithdr    : Real;
   LumpSumContr : Real;
   LumpSumWithDr: Real;
   EndBalance   : Real;
   EndActual    : Real;
   Notes        : String[40];
 end;
  TAllRifList  = class(TObjectList)
  private
    function GetItems(index: integer): TAllRifRec;
  public
    property Items[index: integer]: TAllRifRec read GetItems; default;
  end;
var
  AllRifList    : TAllRifList;
  AllRifRec      : TAllRifRec;


 Type
   TRetirementParmsRec = Record
    StartYear      : Integer;
    NumbPeriods    : Integer;
    IncShortFall   : Real;
    MinNonShBal    : Real;
    OpeningBalance : Array[1..4] of Real;
    IntRate        : Array[1..4] of String[5];
    RegContr       : Array[1..4] of Real;
    RegWithDr      : Array[1..4] of Real;
    ContrBegOrEnd  : Array[1..4] of String[1];
    WithDrBegOrEnd : Array[1..4] of String[1];
  end;
var
  RetirementParms  : TRetirementParmsRec;



 Type
   TMFundsMastRec    = Record
    FundCode      : String[10];
    FundName      : String[50];
    UnitPrice     : Real;
    Date          : String[10];
  end;

// Type TCorpTypes=(CCPC,ControlledByPublic,OtherPrivate,PublicCorp,Other);

//20170112 Igor
(*
 Type
  AUserProfile = Record
   UserId        : String[10];
   Pswd       : String[8];
   IsAdmin       : String[1];
   Branch       : String[10];
   AgentCode    : String[5];
   BranchPassWord     : string[8];
   BackOfficePassword : string[8];
   Initials      :String[2];
   Lastname      :String[30];
   FirstName      :String[20];
   TaxFilesDir   : String[40];
   InFilesDir    : String[40];
   OutFilesDir    : String[40];
   DefaultProvince :String[2];
   DefaultCity :String[20];
  end;
var
  User,
  FpUser : AUserProfile;
*) //20170112 Igor
 Type
  THORec = Record
   BusinessName : String[40];
   Branch       : String[4];
   Street : String[40];
   City : String[20];
   Province: String[15];
   Postal: String[7];
   Country: String[20];
   DealerCode: String[4];
   GstNo: String[15];
   MinFeRate : Real;
   Phone: String[12];
   Fax: String[12];
   EMail: String[40];
   LogoFile: String[40];
   ContactFirstName: String[30];
   ContactLastName: String[20];
   WebSiteAddress: String[40];
   FsCommunicationProgram: String[40];
   FsInDir       : String[40];
   FsInArchive   : String[40];
   FsOutDir       : String[40];
   FsOutArchive   : String[40];
   FilesInDir       : String[40];
   FilesInArchives  : String[40];
   FilesOutDir      : String[40];
   FilesOutArchives : String[40];

   BillType  :String[1];
   VsFee     :Real;
   SFee     :Real;
   AFee     :Real;
   CFee     :Real;
   VCFee     :Real;
   HourlyRate :Real;
  end;

type
 {Define a record for each field of a Fund Serve layout}
  TFsFldRec   = class
    Layout      : String[8];
    FieldName   : String[50];
    FromPos   : Word;
    ToPos     : Word;
    Length    : Word;
    Pic       : String[1];
    Decimals  : Word;
    Data      : String[100]; {to be filled as needed}
  end;
  //PFsFldList  = TFsFldRec;
  TFsFldList  = TObjectList;
var  {List of Fund serve fields for a layout}
  FsFldList     : TFsFldList;
  FsFldRec      : TFsFldRec;  // PFsFldList;

var {List of DataDict }
  DataDictList    : TDataDictList;
  DataDictRec     : TDataDict;

var
  FList, FLastYearList: TFList; //20160704 Igor
  FRec, FLastYearRec: TFRec; //20160704 Igor

   {Tax constants}
Type
   ConstantsRec = Record
   {Federal}
   Bracket1, Bracket2,Bracket3,Bracket4:Real; Bracket5:Real;Bracket6:Real;//20220306
   Rate1,Rate2,Rate3,Rate4,Rate5,Rate6:String[6];  //20170406
   BracketTax1,BracketTax2,BracketTax3,BracketTax4,BracketTax5:Real; BracketTax6, BracketTax7,BracketTax8:Real;//20220306
   FullYear          : Integer;
   MaxAgeAmount      : Integer;
   AgeBaseAmount     : Integer;
   AgeNIThreshHold   : LongInt;
   BasicPersonalAmount : Integer;
   MaxDisability     : Integer;
   MaxDisabSupl18    : Integer;
   DisabSuplBase     : Real;
   MedicalLimit      : Integer;
   MaxMedicalExpense : Real;
   //MedicalAdjBase    :Real;

   MedicalRefundMinThreshHold  :Real;
   MedicalRefundBase    :Real;
   MedicalRefundSupplement   :Real;
   MaxSpousalAmount : Integer;
   EducPerMonth     : Integer;
   PartEducPerMonth  : Integer;
   EducLimit        : Integer;
   DonPercent       : Integer;
   SpousalBase : Integer;  {No claim above this base}
   InfirmDependBase : Real;  {No claim above this base}
   DependBase : Integer;  {No claim above this base}
   MaxDependAmount : Integer;
   MaxAdoption  : Real;
   MaxCpp : Real;
   CPPRate : Real;
   MaxCppPensionable : LongInt;
   BasicCppExemption : Integer;
   MaxCppEarnings : real;
   RSPLimit : Integer;
   UIRate : Real;
   MaxUI52 : Real;
   MaxUIEarn52 :Real;
   UIBaseRep : Real;
   OASBaseRep : Real;
   CareGvrBase : Real;
   MaxCareGvr  :Real;
   DonRate1 : Real;
   DonRate2 : Real;
   MoneyPurchaseLimit: Real;

   FcaAmount : Real;
   CanEmplAmount :Real;
   KidClaim : Real;
   MaxInfirmAmount : Integer;
   QPPRate : Real;
   MaxQpp  : Real;
   MaxPPIPEarnings : Real;
   PPIPRate : Real;
   SEPPIPRate : Real;
   MaxPPIP : Real;
   MaxSEPPIP : Real;
   PPIPDeductionRate : Real;
   QCUIRate : Real;
   QCMaxUI52 : Real;

  end;
var
  Constant : Array[0..1] of ConstantsRec;

Type
   PRVConstantsRec = Record
   {Ontario}
   PrvBracket1  : Real;
   PrvBracket2  : Real;
   PrvBracket3  : Real;
   PrvBracket4  : Real;
   PrvBracket5  : Real;
   PrvBracket6  : Real;
   PrvBracket7  : Real;     //20230304

   PrvBracketTax1 : Real;
   PrvBracketTax2 : Real;
   PrvBracketTax3 : Real;
   PrvBracketTax4 : Real;
   PrvBracketTax5 : Real;
   PrvBracketTax6 : Real;
   PrvBracketTax7 : Real;    //20220306

   PrvPersAmount  : Real;
   PrvSpouseBasicAmount : Real;
   PrvNonRefundRate : Real;
   PrvRate1    : String[5];
   PrvRate2    : String[5];
   PrvRate3    : String[5];
   PrvRate4    : String[5];
   PrvRate5    : String[5];
   PrvRate6    : String[5];
   PrvRate7    : String[5];  //20220306

   PrvMaxAgeAmount      : Integer;
   PrvAgeBaseAmount     : Integer;
   PrvAgeNIThreshHold   : LongInt;
   PrvMaxPensionAmount  : Real;
   //PrvMedicalAdjBase    : Real;
   PrvMedicalAdjRate    : Real;
   PrvMaxDisability     : Real;
   PrvMaxDisabSupl18   : Real;
   PrvDisabSuplBase     : Real;
   PrvCareGvrBase       : Real;
   PrvMaxCareGvr        :Real;
   {PrvSpousalBase       : Integer;}  {No claim above this base}
   PrvInfirmDependBase  : Integer;  {No claim above this base}
   PrvMaxInfirmDependAmount  : Real;
   PrvMaxSpousalAmount : Integer;
   PrvMaxEducXfer      : Real;
   PrvEducPerMonth     : Integer;
   PrvPartEducPerMonth : Integer;
   PrvDonRate1         : Real;
   PrvDonRate2         : Real;
   PrvDivRate          : String;
   PrvDivRateBig       : String;
   PrvOverseasRate     : Real;
   PrvAmtCarryOverRate : Real;
   PrvMedicalLimit     : Real;
   PrvMaxMedicalExpense: Real;
   PrvMaxAdoption      : Real;
  end;
var
  PrvConstant : Array[0..1] of PrvConstantsRec;

 {============================== VARIABLES ======================}
var
  FinishedLetterName:String;
  PdfPrint :Boolean;
  FastPrint: boolean;
  ServerMode:Boolean;
  QrLtrName:String;
  ElmsInError:TStringList;

  ReviewMarkColor: TColor;
  BorderShape:TShape;
  ReviewShape:TShape;
  PrintShade:TColor;
  SomeLetterName: String;
  SomeString:String;
  SomeResult:Boolean;
  ScaleType:String;

  FpClientsDir:String;
  FundDataDir:String;
  IsT1Open:Boolean;
  WhichSpouse:Integer;   //0=Client 1=spouse to show Prrsppln
  FpClientsConnectionString:String;
  FundBaseConnectionString:String;
  CaptureWebDir:String;
  {for unit communications}
  DelayMsg:String;
  WhichModule:String[1];
  //YearOfTaxData: String[4];
  ThisAmount:Real;
  Client, //:String[13];  {Current client for back office}
  ThisClientName, // : String[50];
  ThisAgent,  //: String[5];
  ThisBranch, //:String[5];
  ThisFilesOutDir,  //: String[40];
  ThisFilesInDir,  //: String[40];
  ThisArchiveDir,  // : String[40];
  ThisProblem,  // : String[10];
  ThisPortfolioName,  //: String[40];
  AccountId,  // : String[20];
  ClientIdName,  //:String[50];
  ThisTransaction,  //:String[15];
  Supplier,  //: String[20];
  {------}
  BalShCategory,  //: String[5];
  PricesAsOfDate: string; //:String[10];
  {TypicalClient:Boolean;}
  IsRocheSystem :Boolean;
  ShowTreeView : Boolean;
  ContrBenefList :TStringList;
  //AuditList :TStringList;
  Sc :Real;  {to scale 800X600 x positions}
  ScChar :Real; {to scale character display}
  ScChange:Real;

  FundToChart,  // : String[10];
  PortfolioNameToChart, // : String[25];
  ClientNameToChart: string; // : String[50];

  StreamId: Integer;
  RepaintSw    : Boolean = True;
  CreatingNew  : Boolean = True;
  ClosingReturn : Boolean = False;

  FieldChange : boolean;
  (*
  Global Variables, known to all units using this unit
  instances of objects
    An instance of an object type is a dynamically
    allocated block of memory with a layout defined by the
    object type. It is a pointer to a memory location
  *)
  {Switches : on-off}
  {Low high index for slip strings All in the same array}

  {Marginal rates lists}
  MarginalFrom: TstringList;
  MarginalTo: TstringList;
  MarginalRate: TstringList;
  FrmTreeDescr  : TStringList;
  FrmTreeForms  : TStringList;
  FrmTreeFType  : TStringList;
  LogoBmp :TBitmap;
  RY : Integer;  {Rate year: 0= current, 1= next year}
  FullPaint :Boolean;

  LetterType, // :String[6];  {Cover or Other:if Cover it calcs}
  AppDir, // : String[66];  { AppVersion : string[5];}
  BatchOper, //: String[20];
  BatchFilter,  // : String[20];
  FixDbName: string;  // : String[12];
  CfgADConnection: TADConnection; {congig data base table} //20150921 Igor
  CfgTbl: TADTable; {congig data base table} //20150921 Igor
  SomeFilter, SomeFileMask,
  SomeDir, SomeFile, SomeLabel,
  SelectedString : String;

  VList :TStringList;
  {stores validation rules for current form:  i.e. YN,??????}
  TaxSumList : TstringList; {holds x-ref for TaxSumList}
  NewForm : Boolean;
  HoRec : THoRec;

  {Letters}
  LetterMxParagraphLines: Integer;
  LetterName : string;
  LetterReturnType : string;
  LetterParagraphName :String;

 { CfgRec : ACfgRec;}
  {summary variables for slips}

  WhiteBoxes  : Boolean;

  {List of predefined colors}
  ColorList     : TColorTable;

  FullPathFPScr_LastYear: String; //20160704 Igor

//20170225 Igor >>>
const //Status Elementd
  PswElm = 17;
  c_LastYearElm = 32;
  c_ReturnColorElm = 50;
  SHARE_WITH_PEOPLE = 51; //20190228 Igor
//20170225 Igor <<<

implementation

uses SysUtils,FP_2027;

procedure Done;
begin
//remove all TLists
  FreeAndNil(FsFldList);
  FreeAndNil(ProbateList);
  FreeAndNil(DataDictList);
  FreeAndNil(AssetSumList);
  FreeAndNil(BalanceList);
  FreeAndNil(GenBalanceList);
  FreeAndNil(AllRifList);
  FreeAndNil(TotInvestmProjectionList);
  FreeAndNil(LiabilitiesProjectionList);
  FreeAndNil(FixedAssetsProjectionList);
  FreeAndNil(BusinessProjectionList);
  FreeAndNil(NetWorthProjectionList);
  FreeAndNil(CashFlowProjectionList);
  FreeAndNil(InvProjectionList);
  FreeAndNil(RRSPProjectionList);
//remove all TStringList
  FreeAndNil(ElmsInError);
  FreeAndNil(ContrBenefList);
  FreeAndNil(MarginalFrom);
  FreeAndNil(MarginalTo);
  FreeAndNil(MarginalRate);
  FreeAndNil(FrmTreeDescr);
  FreeAndNil(FrmTreeForms);
  FreeAndNil(FrmTreeFType);
  FreeAndNil(VList);
  FreeAndNil(TaxSumList);
  //FreeAndNil(AffectedList);
end;

{ TTotInvestmProjectionList }

function TTotInvestmProjectionList.GetItems(
  index: integer): TTotInvestmentsRec;
begin
  TObject(Result) := inherited Get(index);
end;

{ TBalanceList }

function TBalanceList.GetItems(index: integer): TBalanceRec;
begin
  TObject(Result) := inherited Get(index);
end;

{ TFixedAssetsProjectionList }

function TFixedAssetsProjectionList.GetItems(
  index: integer): TFixedAssetsProjectionRec;
begin
  TObject(Result) := inherited Get(index);
end;

{ TLiabilitiesProjectionList }

function TLiabilitiesProjectionList.GetItems(
  index: integer): TLiabilitiesProjectionRec;
begin
  TObject(Result) := inherited Get(index);
end;

{ TInvProjectionList }

function TInvProjectionList.GetItems(index: integer): TInvProjectionRec;
begin
  TObject(Result) := inherited Get(index);
end;

{ TBusinessProjectionList }

function TBusinessProjectionList.GetItems(
  index: integer): TBusinessProjectionRec;
begin
  TObject(Result) := inherited Get(index);
end;

{ TCashFlowProjectionList }

function TCashFlowProjectionList.GetItems(
  index: integer): TCashFlowProjectionRec;
begin
  TObject(Result) := inherited Get(index);
end;

{ TRRSPProjectionList }

function TRRSPProjectionList.GetItems(index: integer): TRRSPProjectionRec;
begin
  TObject(Result) := inherited Get(index);
end;

{ TProbateList }

function TProbateList.GetItems(index: integer): TProbateRec;
begin
  TObject(Result) := inherited Get(index);
end;

{ TAssetSumList }

function TAssetSumList.GetItems(index: integer): TAssetSumRec;
begin
  TObject(Result) := inherited Get(index);
end;

{ TGenBalanceList }

function TGenBalanceList.GetItems(index: integer): TGenBalanceRec;
begin
  TObject(Result) := inherited Get(index);
end;

{ TAllRifList }

function TAllRifList.GetItems(index: integer): TAllRifRec;
begin
  TObject(Result) := inherited Get(index);
end;

{ TNetWorthProjectionList }

function TNetWorthProjectionList.GetItems(
  index: integer): TNetWorthProjectionRec;
begin
  TObject(Result) := inherited Get(index);
end;

initialization
finalization
  Done;
end.
