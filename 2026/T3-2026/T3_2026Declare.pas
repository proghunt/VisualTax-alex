unit T3_2026Declare;

interface

uses
  WinTypes, ComCtrls, Controls, Classes, Graphics, ExtCtrls, vtMulti, vtShared, VtEditBox;

const //update every release
  isDraft: Boolean = FALSE; //20151217 //false; //false; //True; //True; //False; //20220215  //20230212
  CertificationMode= FALSE; //True; //FALSE; //TRUE; //FALSE; // false; //true;  //use TRUE for CRA CERTIFICATION: T3 jacket, Fed schedues S1 to s15
  // and prov tax schedulews T3ON, T3BC etc.and click New reurn. Do jot enter ant data
  // for T3 SLIPS /T3SUM Certification use false but enter T3 account = 00000000 Trust Name=For CRA Certification
  //and beneficiary SIN=111111118 and Strett='STR1, etc husr dummt data

  DisableRollOver = FALSE; //false //TRUE; //JZ  //20260104  If TRue; Temporary to skip rollover

  inJZtestmode    = FALSE; //mode to help with test cases / debugging //jz//20260123
                          //if true
                            //- activates extrended listbal
                            //- disables rollover like DisableRollOver does
                            //TODO - things I want to implement
                              //- turns off Efile warnings / Password
                              //- turns off printing Password

  //Use False for provincial and FFT /PFT   //20191218 Set the T3 type to the one that prints tax details table
  //ONT CERTIFICATION  20201209 dummy out the table rates section Open New, set ONT provinve, open T3ON and click Recalc

  PrintShade=clSilver;  //20170122
  {
  //for Certification   //20180218
  CertificationMode=True;  //show / print all constants
  isDraft: Boolean = False;  //allow to print with no banner
  }

  //20150623
  AppYear = '2026'; //20280827 Alex
  AppYearInt = 2026; //20280827 Alex
  AppRelease = '0.0';

  AppUpdateDate = '2026/08/15'; //'2026/03/28'; //'2026/03/21'; //'2026/02/11'; //'2025/12/17'; //'2024/03/15'; //'2024/03/08'; //'2023/12/23'; //20231128 //2023/10/28';//'2023/04/03'; //'2023/03/20'; //'2023/03/11'; //'2023/03/01/'; //'2023/02/24'; //'2023/02/15'; //'2023/02/10'; //'2023/01/08'; //'2023/01/07';   //20230107 for distribution

  TRYear = '2026'; //20280827 Alex
  LimitedVersionDir = 'C:\VT-T3Data26'; //20280827 Alex

  //DBForms = 'TFSCR.DBF'; //20150918 Igor //'FormsList.dbf'; //T1-2010: 'T1SCR.DBF';
  FormsDBLite    = 'T3Scr.DB'; //20150918 Igor
  FormsTableLite = 'T3Scr';    //20150918 Igor

  FormsCfgDBLite    = 'T3CFG.db';  // 20150923 Igor
  FormsCfgTableLite = 'T3CFG';     // 20150923 Igor

  FormsFeesDBLite    = 'Fees.DB'; //20150923 Igor
  FormsFeesTableLite = 'Fees';    //20150923 Igor
  T1134_FA_LIST = 52; //20260115 Igor
  RSIApprovalCode = 'VT52'; //20260817 Alex

const
  //RecentFlName='Recent.txt';
  BlackBoxDir='C:\temp';
  //OptionsFlName='Options.txt';
  //YesNoSet =['Y','y','N','n'];

  AppName = 'T3'; //-FORMS';
  AuthorizationPosition = 9;
  AppTitle = 'Visual Tax - '+ AppName;   {for win caption}

  MaxDynamicArraysPerForm = 7; //20150105 5;  //20111231
  MaxDynamicElmsPerForm =400;  //20150105 300 ; //20111231

  MyBlue  = $00AC7400;
  MyLightBlue = $00FFFFE1;
  MyBeige =$00C8D0D8;
  MyBronze = $A6CAF0;
  MyYellow =$00C5EEFE;
  PinkishColor=$00AEAEFF;//$008080FF; //255,174,174 //rgb(255,128,128)
  LightGreen=$00A7FCE2; //$00E6FFCC;
  brightGreen=$0097FF97; //rgb(151,255,151
  BluishColor=$00FADDA0; //rgb (160,221,250)
  FirstRetColor=$00FFFFC3; //Rgb(195,255,255)
  DarkShade=$00B4B4B4; //rgb(180,180,180);

  FormsLimit   = 800; //1500; //800;
  LowAvlbleAlloc = 21; HiAvlbleAlloc = 52; //51;  20150117
  FieldsLimit  = 999; //450;  //20130112

  FirstFormName = 'T3';
  BoxHeight    = 15; {height of edit box}
  DefFontName =  'Arial';
  RepaintSw    : Boolean = True;
  ClosingReturn : Boolean = False;
  Delimiter    : String [1] = Chr(127);  {in file i/o between variables}

  KeyWDelimiter1 : String [1] = '\';
  KeyWDelimiter2 : String [1] = '\';

  //KeyWDelimiter1 : String [1] = '[';
  //KeyWDelimiter2 : String [1] = ']';
  KeyWDelimiter3 : String [1] = '^';


  //FILES
  //https://www.bankofcanada.ca/rates/exchange/annual-average-exchange-rates/
  //ExchRateFile:= AppDir + '\' + 'ExchRate.d';



  Titles : Array[1..5] of string =
   ('','Mr','Mrs','Miss','Dr');
  PrvShort : Array[1..14] of string =
   ('NL','PE','NS','NB','QC','ON','MB','SK','AB','BC','NT','YT','ZZ','NU');
  {current year}
  PrvRate : Array[1..14] of real =
   (62, 57.5, 57.5, 60, 0, 39.50, 48.50, 48, 44, 49.50, 45, 49, 48, 45);
  {next year}
  PrvRate1 : Array[1..14] of real =
   (62, 57.5, 57.5, 58.5, 0, 38.50, 48.50, 48, 44, 49.50, 45, 49, 48, 45);

  //20220127 Igor >>>
  PrvRate184 : Array[1..14] of real =
      (62.10, 57.50, 57.50, 57.00, 00.00, 00.00, 00.00, 43.94, 00.00, 62.12, 42.58, 45.71, 00.00, 34.85); //20260930 Alex
     //NL     PE     NS     NB                          SK            BC     NT     YK            NU
     //1      2      3      4      5      6      7      8      9      10     11     12     13     14
    //jz2025update-rev1:hard to decipher so added provincial rates references
  //20220127 Igor <<<

  PrvLong : Array[1..14] of string =       //28 instead of 22
   ('NEWFOUNDLAND AND LABRADOR','PRINCE EDWARD ISLAND','NOVA SCOTIA',
    'NEW BRUNSWICK','QUEBEC','ONTARIO','MANITOBA',
    'SASKATCHEWAN','ALBERTA','BRITISH COLUMBIA',
    'NORTHWEST TERRITORIES','YUKON TERRITORY','NON RESIDENT','NUNAVUT');

  //20180315
  PRPStatusCodes : array [0..8] of string =
   ('00','01','02','03','04','05','06','07','08');
  PRPStatusDescr : array [0..8] of string =
   ('W.I.P.','Not Started','Missing Data','Printed','Ready To Print', 'Review Stage',
     'Finished','Re-assessed','Efiled');
  PRPQueries : array [0..8] of string =
   ('WIP','NotStart','MissData','Printed','ReadyPr','InReview',
    'Finish','Reasses','Efiled');

  PrivacyAgreementDoNotShowFileName = 'PrivacyAgreementMessageDoNotShowList.d'; //20260817 Alex

  {Tax constants}
  Type
   ConstantsRec = Record
   //miscellaneous amounts are included but not used in TF
   //because values are copied every year from the T1 trimstr
   {Federal}
   InterVivosRate: Real;  //only for TF - the rest as per T1
   Bracket1, Bracket2,Bracket3  :Real;
   Bracket4:Real; //20160807
   Rate1,Rate2,Rate3,Rate4,Rate5:string; //[6];
   BracketTax1,BracketTax2,BracketTax3,BracketTax4,BracketTax5,BracketTax6  :Real;
   FullYear          : Integer;
   {//20260118
   MaxAgeAmount      : Integer;
   AgeBaseAmount     : Integer;
   AgeNIThreshHold   : LongInt;
   BasicPersonalAmount : Integer;
   MaxDisability     : Integer;
   MaxDisabSupl18    : Integer;
   DisabSuplBase     : Real;
   MedicalLimit      : Integer;
   MaxMedicalExpense : Real;
   MaxAdoption       : Real;

   MedicalRefundMinThreshHold  :Real;
   MedicalRefundBase    :Real;
   MedicalRefundSupplement   :Real;
   MaxSpousalAmount : Integer;
   EducPerMonth     : Integer;
   PartEducPerMonth  : Integer;
   }
   EducLimit        : Integer;
   DonPercent       : Integer;
   (*
   SpousalBase : Integer;  {No claim above this base}
   InfirmDependBase : Real;  {No claim above this base}
   DependBase : Integer;  {No claim above this base}
   MaxDependAmount : Integer;
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
   *)
   DonRate1 : Real;
   DonRate2 : Real;
   //miscellaneous amount not neded.
   {
   FCAAmount : Real;
   MoneyPurchaseLimit :Real;
   CanEmplAmount  :Real;
   KidClaim       :Real;

   QCUIRate            :Real;
   QCMaxUI52           :Real;
   QPPRate             :Real;
   MaxQpp              :Real;
   MaxPPIPEarnings     :Real;
   PPIPRate            :Real;
   MaxPPIP             :Real;
   SEPPIPRate          :Real;
   MaxSEPPIP           :Real;
   PPIPDeductionRate   :Real;
   }
  end;

 Type  //20111231
 TDynamicFormParameters = Record
   ArrayNo        : Integer;
   FirstFieldId   : Integer;
   BoxesPerRow    : Integer;
 end;

 Type TT1135resultType = (T1135accepted,T1135rejected,T1135Delayed,T1135webserviceError);
 Type TT1135AckRec = Record       //20150710 instead of T1135...
    Name                           : String;
    DateTimeReceived               : String;
    Status                         : String;
    StatusColor                    : String;
    ResultCode                     : String;
    TransmissionNumber             : String;
    TaxPreparerEfilerNumber        : String;
    TaxPreparerReturnControlNumber : String;
    DocumentControlNumber          : String;
    FamilyName                     : String;
    GivenName                      : String;
    MessageText                    : ansiString;
    additionalText                 : ansiString;
    T1135resultType                : TT1135resultType;

    //Response                     : String;
    //additionalText               : ansiString;
  end;


 Type
 TAssetsBRec = Record
  Cls         :string; //[10];
  UccStart    :real;
  Additions   :real;
  Proceeds    :real;
  Adjustments :real;
  BaseForCCA  :real;
  Rate        :string; //[10];
  CCA         :real;
  UccEnd      :real;
  OvrCCA      :string; //[1];
  OvrUCC      :string; //[10];
  ClaimIt     :Boolean;
  Rule50Exempt:string; //[1];
  TerminalLoss: string; //[1];
  BusPercent  :Real;
  MaxCCA      :Real;
  TerminalLossAmount : Real;
  RecaptureAmount : Real;
 end;

 Type
 TSelfAutoExpRec = Record
   NumofCars     : Integer;
   Descr         : Array[1..6] of string; //[50];
   KMDrove       : Array[1..6] of Integer;
   KmTotal       : Array[1..6] of Integer;
   Stmt          : Array[1..6] of string; //[10];
   StmtPercent   : Array[1..6] of Real;
   PartnerFlag   : Array[1..6] of String;
   ExpensesClaim : Array[1..6] of Real;
   CCAClaim      : Array[1..6] of Real;
 end;

Type
 TAutoExpRec = Record
   NumofCars     : Integer;
   KMDrove       : Integer;
   KmTotal       : Integer;
   KMPercent     :Real;
   StatementPercent:Real;
   Cost          :Real;
   TotalCCAClaimed : Real;
   Fuel          : Real;
   Maintenance   : Real;
   Insurance     : Real;
   License       : Real;
   Interest      : Real;
   Leasing       : Real;
   Other         : Real;
   Rebates       : Real;
 end;

Type
   PRVConstantsRec = Record
   PrvInterVivosRate: Real;  //only for TF - the rest as per T1
   {Ontario}
   PrvBracket1  : Real;
   PrvBracket2  : Real;
   PrvBracket3  : Real;
   PrvBracket4  : Real;
   PrvBracket5  : Real;  //20150729
   PrvBracket6  : Real;  //20201207
   PrvBracket7  : Real;  //2021


   PrvBracketTax1 : Real;
   PrvBracketTax2 : Real;
   PrvBracketTax3 : Real;
   PrvBracketTax4 : Real;
   PrvBracketTax5 : Real;      //20150729
   PrvBracketTax6 : Real;
   PrvBracketTax7 : Real;
   PrvBracketTax8 : Real; //new jz2022

   (*
   PrvPersAmount  : Real;
   PrvSpouseBasicAmount : Real;
   PrvNonRefundRate : Real;
   *)
   PrvRate1,  //    : string; //[5];
   PrvRate2,  //    : string; //[5];
   PrvRate3,  //    : string; //[5];
   PrvRate4,  //    : string; //[5];
   PrvRate5    : String;  //[5];
   PrvRate6    : String;  //20150729
   PrvRate7    : String;  //20201207
   PrvRate8    : String;  //new jz2022
   (*
   PrvMaxAgeAmount      : Integer;
   PrvAgeBaseAmount     : Integer;
   PrvAgeNIThreshHold   : LongInt;
   PrvMaxPensionAmount  : Real;
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
   *)
   PrvDonRate1         : Real;
   PrvDonRate2         : Real;

   //20231203
   PrvDivRate          : String; //Real;
   PrvDivRateBig       : String; //Real;
   PrvDivRateStart2013 : String; //20231203
   PrvOverseasRate     : Real;
   PrvAmtCarryOverRate : Real;
   (*
   PrvMedicalLimit     : Real;
   PrvMaxMedicalExpense: Real;
   PrvMaxAdoption      : Real;
   *)
  end;

Type TTrustTypes=(
   TestamSpousal,
   TestamOther,
   IVSpousal,
   IvUnit,
   IvMutualFund,
   IvCommunal,
   IvEBP,
   IvInsSegrReg,
   IvInsSegrNonReg,
   IvNonProfit,
   IvEmplTrust,
   IvPersTrust,
   IvOther,
   IvJointPartner,
   IvAlterEgo
 );

type    {1=line,2=rectangle, etc}
  TDrawingTool = (dtLine,dtRectangle,dtEllipse,dtRoundRect);

Type
  TFederalRates = Record
   Rate1            : Real;
   Rate2            : Real;
   Rate3            : Real;
   Rate4            : Real;

   Base2            : Real;
   Base3            : Real;
   Base4            : Real;
   BaseTax2         : Real;
   BaseTax3         : Real;
   BaseTax4         : Real;
  end;

  Type
  TONToniRates = Record
   Base1            : Real;
   Base2            : Real;
   Base3            : Real;
   Rate1            : Real;
   Rate2            : Real;
   Rate3            : Real;
   BaseTax1         : Real;
   BaseTax2         : Real;
   BaseTax3         : Real;
   IntervRate       : Real;
   DonRate1         : Real;
   DonRate2         : Real;
   DividendRate      : Real;
   AMTCarryOverRate : Real;
   SurTaxRate1      : Real;
   SurTaxRate2      : Real;
   SurTaxThresh1    : Real;
   SurTaxThresh2    : Real;
   ReductionThresh  : Real;
  end;

  Type
  TBCToniRates = Record
   Base1            : Real;
   Base2            : Real;
   Base3            : Real;
   Rate1            : Real;
   Rate2            : Real;
   Rate3            : Real;
   BaseTax1         : Real;
   BaseTax2         : Real;
   BaseTax3         : Real;
   IntervRate       : Real;
   DonRate1         : Real;
   DonRate2         : Real;
   DividendRate      : Real;
   AMTCarryOverRate : Real;
   SurTaxRate1      : Real;
   SurTaxRate2      : Real;
   SurTaxThresh1    : Real;
   SurTaxThresh2    : Real;
   ReductionThresh  : Real;
  end;

//jz 20240405 add specialreturns efile button
 Type TspecialReturnEfileStatus = (spNotEfiled, spOriginalEfiled, spOriginalEfileAmended, spAmendedEfileRetransmitted);

//jz 20240406 add specialreturns r1
 TSpecialEfileStatusElms = Record
   //spFormName             : string[10];
   spAmendedIndicatorElm  : integer;
   spRevisionIndicatorElm : integer;
   spConfirmationNumElm   : integer;
 End;

//20211013 Igor >>>
Type
  TEFresultType = (EFaccepted,EFrejected,EFwebServiceError);   //20140124
//Type   //20140118  //efile ackknowledgement file
 TAckRec = Record
   returnTypeName       : string[10];   //20150207 ??
   CVIndicator          : String[250];  //20150127
   FamilyName           : String[40];
   GivenName            : String[20];
   TransmitBatchName    : String[40];
   ResultCode           : String[30];
   Description          : String[255];  //20170130
   DateTransmitted      : String[10];
   TimeTransmitted      : String[10];
   DateReceived         : String[10];
   TimeReceived         : String[10];
   EfilerNumber         : String[5];
   DocumentNo           : String[15];
   TransmissionNo       : String[15];
   HyperlinkLink        : String[255];
   HyperlinkText        : String[255];
   ErrorCode            : Array[1..6] of String[6];
   ErrorCodeMsg         : Array[1..6] of array[1..12] of String[255]; //20181802 //ErrorCodeMsg         : Array[1..6] of String[255];
   Accepted             : Boolean; { TODO 1 -oCon : used in T1_2026T1135efile }
   EFresultType         : TEFresultType; //EfR
   TransmissionName     : String[4]; //20240129 Igor
 end;
//20211013 Igor <<< 

 {============================== VARIABLES ======================}

var {Lists of common types }
  DataDictList    : TDataDictList;
  DataDictRec     : TDataDict;

  {-----------   FORM DEFINITION -------------------}

  FList, FLastYearList: TFList; //20160629 Igor
  FRec, FLastYearRec: TFRec; //20160629 Igor

  ExtractedAutoList  : TExtractedAutoList;
  ExtractedAutoRec   : TExtractedAutoRec;

  ExtractedCCAList  : TExtractedCCAList;
  ExtractedCCARec   : TExtractedCCARec;
  ProdOrTest: string; //during transmision 'P' ot 'T' //20260817 Alex

  //--------------------
 // TArrayOfElms:0..200;  //20180226  to set a set of elm numbers to clear or do something
  //------------------
 var
   HomeProv:String;
   xx, yy: Real;   //20260118
   T3PropDynList:TStringList; //replaces the older array of properties  //20110131
    //really global???

   isCraFilingCopy : boolean;

   CurrentRoutine: String;

   AutoExpRec:TAutoExpRec;
   SelfAutoExpRec:TSelfAutoExpRec;
   AssetsBRec:TAssetsBRec;

   SomeLetterName: String;
  QrLtrName:String;
  ElmsInError:TStringList;
  //FormElmArray : array of array of array of String;
  //FormElmDollar : array of array of boolean; //[Frm][Elm]
  ReviewMarkColor: TColor;
  BorderShape:TShape;
  ReviewShape:TShape;
 // PrintShade:TColor;   //20170122
  SomeString:String;
  SomeResult:Boolean;
  ScaleType:String;
  TrFolder:String;
  Sc,ScChar,ScChange:real; {scaling}
  FieldChange : Boolean;
  PdfFormsDir:String;

  Cf_Itc, CF_CNILInc,CF_CNILExp: Real;  
  Cf_TrustType:String;     //20160207
  CF_NonCapLossPrior:Real; //20170326

  Var ONToni: Array[0..1] of TOnToniRates;
  Var BCToni: Array[0..1] of TBCToniRates;
  Var FedRates: Array[0..1] of TFederalRates;
  (*
  Global Variables, known to all units using this unit
  instances of objects
    An instance of an object type is a dynamically
    allocated block of memory with a layout defined by the
    object type. It is a pointer to a memory location
  *)
  {Switches : on-off}
  {Low high index for slip strings All in the same array}

  LogoBmp :TBitmap;
  RY : Integer;  {Rate year: 0= current, 1= next year}
  FullPaint :Boolean;

  LetterType :String; //[6];  {Cover or Other:if Cover it calcs}
  CCAClasses :Array[1..50] of string; //[4];
  CCARates   :Array[1..50] of string; //[3];

  AppDir, //: string; //[66];   {AppVersion : string; //[5];}
  BatchOper, //: string; //[20];
  BatchFilter, //: string; //[20];
  FileDescr,  // :string; //[60];
  FixDbName: String; //20170328 igor

(* //20170328 Igor
  SomeFilter, //: string; //[60];
  SomeFileMask, // : string; //[10];
  SelectedString, // : string; //[120]; //20170328 Igor
  SomeLabel,  //:string; //[120];
  SomeFile, //:string; //[60];
  SomeDir:  string; // :string; //[60];
*)
  VList :TStringList; {stores validation rules for current form:
      i.e. YN,??????}
  TaxSumList : TstringList; {holds x-ref for TaxSumList}
  NewForm : Boolean;

  Constant : Array[0..1] of ConstantsRec;
  PrvConstant : Array[0..1] of PrvConstantsRec;

  {Letters}
  LetterMxParagraphLines: Integer;
  LetterName : string;
  LetterReturnType : string;
  LetterParagraphName :String;

  DD,MM,YYYY : integer; {returned by Calndr} //20160216 Igor

  FinishedLetterName:String;
  {-- current form properties ---}
  FormNo       : Integer;
  FormName     : string;
  PrevFormName : string;
  PrevRetNo : integer;
  PrevFormNo:Integer;
//???
  GapFields   : Integer;
  WhiteBoxes  : Boolean;

  ColorList     : TColorTable;
  FrmTreeForms  : TStringList;
  FullPathT3Scr_LastYear: String; //20160629 Igor

  //20210906 Igor >>>
  AckRecResultDescription : string; //20211201 Igor
  ErrorDescription     : array[1..6] of array[1..12] of string; //20181802//ErrorDescription     : Array[1..6] of ansiString;
  tempAckRecDescription          : ansistring;  //20170130
  tempAckRecErrorCodeMsg         : Array[1..6] of array[1..12] of ansistring;  //20181802 //var tempAckRecErrorCodeMsg         : Array[1..6] of ansistring;
  //20210906 Igor <<<  
  //20170225 Igor >>>
const  //Status form elements
  PswElm = 25;
  c_LastYearElm = 32;
  c_ReturnColorElm = 50;
  c_FileDescription = 51; //20180314 Igor
  SHARE_WITH_PEOPLE = 51; //20190228 Igor
//20170225 Igor <<<

  //20210906 Igor >>>
  EFStatusCodes : array [0..6] of string =
   ('00','01','02','03','04','05','06');
  EFStatusDescr : array [0..6] of string =
   ('EF not started','EF Ready For EFILE','EF Accepted','EF Rejected',
    'EF Waiting Ack','EF Ready For SEND','Paper Filed');
  //20210906 Igor <<<

implementation

uses SysUtils;

procedure Done;
var
  i: integer;
begin
//see Common.InitLists
  FreeAndNil(ElmsInError);
  //FreeAndNil(FrmDict);
  //FreeAndNil(OverList);
  //FreeAndNil(ReviewList);
  //FreeAndNil(FormList);
  //FreeAndNil(AffectedList);
  //FreeAndNil(LogoBmp);
  //FreeAndNil(SomeList); //!!!???
  FreeAndNil(TaxSumList);
  //FreeAndNil(FormObjects);
  FreeAndNil(VList);
  FreeAndNil(ExtractedAutoList);
  FreeAndNil(ExtractedCCAList);
  FreeAndNil(DataDictList);

  //FreeAndNil(FList);
//LoadEditBoxProperties
  FreeAndNil(T3PropDynList);
  //FreeAndNil(FieldList);
  //FreeAndNil(FrmTreeDescr); ?
  FreeAndNil(FrmTreeForms);
end;

initialization
//by code
finalization
  Done;
end.

