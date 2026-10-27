unit T2_2027Declare;

interface

uses
  WinTypes, ComCtrls, Controls, classes, Graphics, ExtCtrls, VtEditBox, vtChild,
  vtMulti, vtShared, uADCompClient; // 20150923 Igor

const //update every release
 ////20220903 -------------------------
  AppYear = '2027'; //20280827 Alex
  AppYearInt = 2027; //20280827 Alex
  TRYear = '2027'; //20280827 Alex
  AppRelease = '1.0'; //20230917 //20230603 //20181029 '2.0'; //'1.0'; //20180502  //for Oct 31 2018
  AppVersion = '2027'; //20280827 Alex

  MyRollover = FALSE; //TRUE; SPECIAL ROLLOVER to OPen and retain all previous yers data //20281016 Alex

  //======//20250517';  //to Oct 31, 2025 ==============================================
  AppUpdateDate ='2026/08/15'; //'2026/07/31'; //202609-360620

  RsiVersion = '2027.1'; //20280827 Alex //'2026.1'; //'2025.2'; //20250517';  //'2024.2'; //jz 20240523 //20241016
  MinStartPeriod = '2025/01/01'; //start 2024 //20251014    //20260525
  MaxEndPeriod = '2027/10/31'; //20280827 Alex //'2026/05/31';//'2025/10/31'; //06/01'; '2025/06/01'; //'2025/05/31';   //20250517
  RSIApprovalCode = 'VT53'; //20280827 Alex //20250918 //'VT50';//'VT49'; //jz 20240426 //'VT47';
  FRRMSsoftwareid = 'VT53'; //20280827 Alex //20250918; ////'VT50'; //'VT49'; //jz 20240426 //'VT47';

  S8ApplicableVersion='For Y/E 2025 and beyond';//20260531  //KEEP it  // RevisionDate='2026/05/31';  //20260530
  //S8RevisionDate='2026/05/31';  //20260530
  //--------------------------------------------
  LimitedVersionDir = 'C:\VT-T2DATA27'; //20280827 Alex //Not in Effect  LimitedVersionDir='C:\VT2DATA16'; //20160716
  //----------------------------------------
  AlbertaNetFileCode_Test= 'HL2026';  //20260626 'SC2025'; //20251112  'NN2024'; //jz 20241212 - as per CRA email//20230625 'HL2022'; //??? //'JW2021'; //'TW2020'; //20220526
  AlbertaNetFileCode_Approval ='VT2165'; //20260804 //'VT1054'; //20250204 //production ab production //20251112  'VT4501';  //20250702 //'VT3490'; //'VT2389';

  OntDFileSoftCode = '080E';
  t2enterpriseflname = 't2enterprise.html'; //20231031 //reT2ADDONFeatures.txt';  //for ad on schedules features

var //written const!
  ClosingReturn : Boolean = False;

const
  AppName = 'T2';
  AppTitle = 'Visual Tax - '+ AppName;   {for win caption}

  FormsDBLite      = 'T2Scr.db';  // 20150920 Igor
  FormsTableLite   = 'T2Scr';     // 20150920 Igor

  FormsCfgDBLite    = 'T2CFG.db';  // 20150922 Igor
  FormsCfgTableLite = 'T2CFG';     // 20150922 Igor

  FormsCfgT1DBLite    = 'T1CFG.db';  // 20150922 Igor
  FormsCfgT1TableLite = 'T1CFG';     // 20150922 Igor

  FormsFeesDBLite    = 'Fees.DB'; //20150922 Igor
  FormsFeesTableLite = 'Fees';    //20150922 Igor

  TaxByteDBLite    = 'TaxByteT2.DB'; //20150923 Igor
  TaxByteTableLite = 'TaxByteT2';    //20150923 Igor

  LimitedBN = 'LimitedBN.D'; //20191015 Igor

  //RecentFlName='Recent.txt';
  BlackBoxDir='C:\temp';
  //OptionsFlName='Options.txt';
  //YesNoSet =['Y','y','N','n'];
  MxYears=38;  //from app year to appyear+mxYears  so up to 2050  //reduce it in 2012 to 37

  LimitedVersionReturns = 2;
  LimitedWithEfileVersionReturns = 4;
//  20170628
  Limited1Returns=1;
  Limited2Returns=2;
  Limited3Returns=3;
  Limited4Returns=4;
  Limited5Returns=5;

  AuthorizationPosition =9;

  DarkShade=$00B4B4B4; //rgb(180,180,180);
  LightGreen=$00A7FCE2; //$00E6FFCC;
  MyBlue  = $00AC7400;
  MyLightBlue = $00FFFFE1;
  PinkishColor=$00AEAEFF;//$008080FF; //255,174,174 //rgb(255,128,128)
  brightGreen=$0097FF97; //rgb(151,255,151
  BluishColor=$00FADDA0; //rgb (160,221,250)
  FirstRetColor=$00E8FFFF;  //$00FFFFC3; //Rgb(195,255,255)  //20160602    NOT USED?
  MyBeige =$00C8D0D8;
  MyBronze = $A6CAF0;
  MyYellow =$00C5EEFE; //light yellow original
  {Capacity}
{$IFDEF ReturnsLimit}
  ReturnsLimit = 8;
{$ELSE}
{$ENDIF}
  FormsLimit   = 705; //MaxBuckets = 5500;
  LnLowBound   = 1;  LnHighBound  = 900;
  GifiBsLines =340;
  //LabelProperties = 9;  LineProperties  = 8;  FieldProperties = 12;
  //LabelsLimit  = 200;LinesLimit   = 200;
  FieldsLimit  = 1800; //1500 //20180611

  FirstFormName = 'T2';
  BoxHeight    = 15;  {height of edit box}
  DefFontName =  'Arial';
  DefBarFontName = 'Times New Roman';
  RepaintSw    : Boolean = True;
  CreatingNew  : Boolean = True;
  //Delimiter    : string; //[1] = Chr(127);  {in file i/o between v ariables}
  //KeyWDelimiter1 : String [1] = '\'; //20150702
  //KeyWDelimiter2 : String [1] = '\'; //20150702
  KeyWDelimiter1: char = '\'; //20150702
  KeyWDelimiter2: char = '\'; //20150702
  RecentDelim='¦'; //20201015 Igor
  {KeyWDelimiter3 : string [1] = '^';}



    //Const //20140704
  acceptedEfSet =
   [
   '-' , '''' , '/' , '&' , '*' , '#' , '!' , '@' , '+' , '=' , '?' , '$' , '%' , '(' , ')' ,
   '_' , ';' , ':' , '"' , ',' , '.' , '<' , '>' , '~' , '`' , '^' , '{' , '}' , '[' , ']' ,
   '|' , '\' , ' ' , '?' , '?' ,
   'A' , 'B' , 'C' , 'D' , 'E' , 'F' , 'G' , 'H' , 'I' , 'J' , 'K' , 'L' , 'M' , 'N' , 'O' ,
   'P' , 'Q' , 'R' , 'S' , 'T' , 'U' , 'V' , 'W' , 'X' , 'Y' , 'Z' ,
   'a' , 'b' , 'c' , 'd' , 'e' , 'f' , 'g' , 'h' , 'i' , 'j' , 'k' , 'l' , 'm' , 'n' , 'o' ,
   'p' , 'q' , 'r' , 's' , 't' , 'u' , 'v' , 'w' , 'x' , 'y' , 'z' ,
   '0' , '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9', '°'  // 20181106 Igor
   ];

  (*
  //Const //20140704
  acceptedEfSet =
   [
   '-' , '''' , '/' , '&' , '*' , '#' , '!' , '@' , '+' , '=' , '?' , '$' , '%' , '(' , ')' ,
   '_' , ';' , ':' , '"' , ',' , '.' , '<' , '>' , '~' , '`' , '^' , '{' , '}' , '[' , ']' ,
   '|' , '\' , ' ' , '?' , '?' ,
   'A' , 'B' , 'C' , 'D' , 'E' , 'F' , 'G' , 'H' , 'I' , 'J' , 'K' , 'L' , 'M' , 'N' , 'O' ,
   'P' , 'Q' , 'R' , 'S' , 'T' , 'U' , 'V' , 'W' , 'X' , 'Y' , 'Z' ,
   'a' , 'b' , 'c' , 'd' , 'e' , 'f' , 'g' , 'h' , 'i' , 'j' , 'k' , 'l' , 'm' , 'n' , 'o' ,
   'p' , 'q' , 'r' , 's' , 't' , 'u' , 'v' , 'w' , 'x' , 'y' , 'z' ,
   '0' , '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9'
   ];
  *)


  ItcCodes: Array[1..3] of string =
  (
   '12 - at 15%, Qualified Property',
   '14 - at 10%, Qualified Property',
   '3A - at 30%, Certified Property'
   );

  Titles : Array[1..5] of string =
   ('','Mr','Mrs','Miss','Dr');

  PrvCodes : Array[1..16] of string =
   (' ','NL','PE','NS','NB','QC','ON','MB','SK','AB','BC','NT','YT','NU','NO','XO');

  PrvShort : Array[1..17] of string =
   ('NL','PE','NS','NB','QC','ON','MB','SK','AB','BC','NT','YT',
   'NO','XO','NU','OC','MJ');
  PrvLong : Array[1..17] of string =
   ('Newfoundland','Prince Edward Island','Nova Scotia',
    'New Brunswick','Quebec','Ontario','Manitoba',
    'Saskatchewan','Alberta','British Columbia',
    'Northwest Territories','Yukon Territory',
    'N.S. Offshore','NFLD Offshore','Nunavut','Outside Canada','Multiple');

  PRPStatusCodes : array [0..10] of string =
   ('00','01','02','03','04','05','06','07','08','09','10');
  PRPStatusDescr : array [0..10] of string =
   ('W.I.P.','Not Started','Missing Data','Printed','Ready To Print', 'Review Stage',
     'Finished','Re-assessed','Ready E-file','EFile Accepted','EFile Rejected');
  PRPQueries : array [0..7] of string =
   ('WIP','NotStart','MissData','Printed','ReadyPr','InReview',
    'Finish','Reasses');
  MaxDynamicElmsPerForm =400; //20160222 Igor

  //20160721 Igor STATUS elements
  PswElm = 25; //STATUS ElmNo
  c_LastYearElm = 32;
  c_OldGifiDataConvertedElm = 33; //20160721 Igor
  c_ReturnColorElm = 50; //20170219 Igor
  SHARE_WITH_PEOPLE = 51; //20190221 Igor

  T1134_FA_LIST = 52; //20230712 Igor

  TddElmsDBLite = 'TddElms.db'; //20171124 Igor
  TddElmsTableLite = 'TddElms'; //20171124 Igor


  PrivacyAgreementDoNotShowFileName = 'PrivacyAgreementMessageDoNotShowList.d'; //jz 20250108

Type  //20200810
   T1ConstantsRec = Record
   EligDivGrossUpRate:Real;
   NonEligDivGrossUpRate:Real;

   CPPRate : Real;
   MaxCppEarnings:Real;
   MaxCppPensionable: LongInt;
   BasicCppExemption : Integer;
   MaxCppPremium:Real;
   UIRate : Real;
   MaxUI52 : Real;
   MaxUIEarn52:Real;

   QPPRate             :Real;
   QCMaxUI52           :Real;
   MaxQpp              :Real;
   MaxPPIPEarnings     :Real;  //67500
   PPIPRate            :Real;  //0.559
   SEPPIPRate          :Real;
   MaxPPIP             :Real;  //377
   MaxSEPPIP           :Real;  //720
   PPIPDeductionRate   :Real;  //43
   QCUIRate            :Real;
  end;
var
  T1Constant : Array[0..1] of T1ConstantsRec;


Type
  TCorpTypes=(CCPC,ControlledByPublic,OtherPrivate,PublicCorp,Other);

Type
 TEFresultType = (EFaccepted,EFrejected,EFwebServiceError);  //20160523 Igor
 TT1135resultType = (T1135accepted,T1135rejected,T1135Delayed,T1135webserviceError);  //20160523 Igor

 TAckRec = Record  //20160523 Igor
   returnTypeName       : string[10];
   CVIndicator          : String[250];
   FamilyName           : String[40];
   GivenName            : String[20];
   TransmitBatchName    : String[40];
   ResultCode           : String[5];
   DateTransmitted      : String[10];
   TimeTransmitted      : String[10];
   DateReceived         : String[10];
   TimeReceived         : String[10];
   EfilerNumber         : String[5];
   DocumentNo           : String[15];
   TransmissionNo       : String[15];
   ErrorCode            : Array[1..6] of String[6];
   Accepted             : Boolean;
   EFresultType         : TEFresultType;
 end;

 T1135AckRec = Record  //20160523 Igor
   Name                 : String;
   BNnumber             : String;
   TxYear               : String;
   DateTimeReceived     : String;
   TransmitterID        : String;
   ConfirmationID       : String;
   Response             : String;
   ResponseCode         : String;
   ResponseText         : ansiString;
   additionalText       : ansiString;
   T1135resultType      : TT1135resultType;
 end;

var {List of DataDict }
  DataDictList    : TDataDictList;
  DataDictRec     : TDataDict;

  {-----------   FORM DEFINITION -------------------}
  FList : TFList; //20160712
  FLastYearList: TFList absolute FList; //20160712
  FRec, FLastYearRec: TFRec;

  ColorList: TColorTable;

  AckRecResultDescription : ansistring; //20160523 Igor
  ErrorDescription     : Array[1..6] of ansiString; //20160523 Igor
  XmlList:TStringList; //used to create contents of Xml for a single return

 {============================== VARIABLES ======================}
var
  //20250621
  ABStep1,ABStep2,ABStep3:Boolean; //2026062040620:Boolean;  //controlsthe calc of Alberta Innovation Credit 3 steps
  ABIeg,AbNetIeg :Real;   //see craSpecs Alberta:  CRA-Guide-Claiming-The-Innovation
  // see also IsIbstep1 and IsAbStep2
  // --------------------------

  T2FormNo:   Integer;
  RY:Integer;
  XX,YY,ZZ:Real; //debugging when needed  //2024
  SalDivMode:Boolean;  //20200811
  AddOnEnabled:Boolean;     //20231031
  MaxShareHolders:Integer;  //20200819
  InVersion:String; //version of data being read  //20111130
  T2FNo:Integer;   //20200724
  CAISYrT1163:String;
  CAISYrT1273:String;
  GifiRetNo:Integer;
  BarCodePrinted:Boolean;
  QrLtrName:String;
  AmendCnt, S88Cnt:Integer;
  //FormElmArray : array of array of array of String;
  //FormElmDollar : array of array of boolean; //[Frm][Elm]
  IsPdfDocumentOpen:Boolean;

  BarData:AnsiString;

  PdfFormsDir:String;
  DelayMsg:String;
  TaxByteDb: TADConnection; //20150923 Igor

  GifiStmNoToPrint:Integer;
  GifiCallingBatchEntry:String;

  Sc,ScChar,ScChange:Real;LeftPanelWidth:LongInt; {scaling}
  FieldChange : boolean;
  {Switches : on-off}
  {Low high index for slip strings All in the same array}
  ValidUser :Boolean;

  (*
  Global Variables, known to all units using this unit
  instances of objects
    An instance of an object type is a dynamically
    allocated block of memory with a layout defined by the
    object type. It is a pointer to a memory location
  *)
  {Switches : on-off}

  {Low high index for slip strings All in the same array}
  PrvLowRate  : Array[1..17] of real;   //jz//20260628 - PrvLowRate  : Array[1..15] of real; - extra entries added as having them causing range check error -
  PrvHighRate : Array[1..17] of real;   //jz//20260628 - PrvHighRate : Array[1..15] of real;


  PrintBoxHeight : Integer;
  LogoBmp :TBitmap;
  FullPaint :Boolean;
  {RepaintDataOnly :Boolean;}  {need to show only the data?}

  LetterType :string; //[6];  {Cover or Other:if Cover it calcs}
  CCAClasses,
  CCARates   :Array of string; //20190930 //Array[1..59] of string;    //20160504  //20170306  //20220107 Igor
  //CCARates   :Array[1..62] of string; //20210917 added a new class //Array[1..61] of string;    //20160504  //20170306

  AppDir, //string; //[66];   {AppVersion : string; //[5];}
  BatchOper,  // : string; //[20];
  BatchFilter: string;  // : string; //[20];
  //CfgTbl: TADTable; {congig data base table} //rem 20150916 Igor
  FixDbName : String;
  {Somelist : create and free in any unit}
//20160907 Igor >>>
//  SomeList : TSingleStringList;
//  SomeCaption,  //: string; //[60];
//  SomeFilter, //: string; //[60];
//  SomeFileMask, // : string; //[10];
//  SelectedString, // : string; //[120];
//  SomeLabel,  //:string; //[120];
//  SomeFile, //:string; //[60];
//  SomeDir: string;  // :string; //[60];
//20160907 Igor <<<

  VList :TSingleStringList; {stores validation rules for current form:
      i.e. YN,??????}
  TaxSumList : TSingleStringList; {holds x-ref for TaxSumList}

  NewForm : Boolean;
  {Letters}
  LetterMxParagraphLines: Integer;
  LetterName : string;
  FinishedLetterName:String;
  LetterReturnType : string;

  StatusBarSw: Boolean;

  FrmTreeDescr  : TSingleStringList;
  FrmTreeForms  : TSingleStringList;

  FullPathT2Scr_LastYear: String; //20160424 Igor       //20160425 Con


const
  isDraft: Boolean = False; //20161213 True; //20161212 Igor
implementation

end.
