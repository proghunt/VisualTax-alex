unit T4T5_2026Declare;

interface

uses
  WinTypes, ComCtrls, Controls, Classes, Graphics, ExtCtrls, vtMulti, vtShared,
  VtEditBox;

const //update every release
  IsDraft =false; // True; //20251217 //False; //false; //True; //20250115
  CertificationMode = False;   //20150729

  //20150623
  AppYear = '2026'; //20280827 Alex
  AppYearInt = 2026; //20280827 Alex
  AppRelease = '0.0';

  AppUpdateDate ='2026/08/15'; //??? / or - '2026-02-05'; //'2025/12/17'; //'2026/01/13'; //'2025/01/23'; // '2025/01/25'; //20250121

  TRYear = '2026'; //20280827 Alex
  LimitedVersionDir = 'C:\VT-T4T5Data26'; //20280827 Alex


  //quebec source https://www.canada.ca/en/revenue-agency/services/tax/businesses/topics/payroll/payroll-deductions-contributions/employment-insurance-ei/ei-premium-rates-maximums.html#h_2

  //google or taxtips Maximum CPP,  Maximum EI  change every year
  // Only program change every year for T4
  //ALL CHANGED //20241103

   CPPRate           = 0.0595; //20251207  //20241103 0.0595;//20231213
   BasicCPPExempt    = 3500;   //20251207 //20241103  //3500;  //20231213 //3500
   MaxCppPremium     = 4034.10; //20260110 //20251207 //3867.50; //20241103 3754.45; //20231213 3499.80; //20221217    3166.45; //20211209 //2898; //20201017 //2748.90; //20190917 //2593.80; //20181212 //2564.10; //2544.30;     //20171209
   MaxCppEarnings    = 71300; //20251207 //68500;   //20241103 66600; //20231213 64900; //20221217 61600; //20211209 //58700 ///20201017 //57400; //20190917 55900; //20181212 55300; //54900;                           //20171209

   //20241220
   MaxCpp2     = 396; //20260110 not 395 //188; 20251216
   CPP2Rate    = 0.04; //same with 2024 4%
   CPP2MaxCppEarnings  = 81200; //20251216 //73200; //20241103

   //qpp
   QppRate           = 0.0640;  //same as 2024//20241103 //0.0640;  //20231213 0.0615; //20221217     //0.0590; //20211209 0.0570; //BLENDED /20201017 //0.0555; //20190917 0.0540;
   QppQppPremium     = 4339.20; //20251216 4160.00;//20241103 //4038.40; //20231213 3776.10; //20221217    //3427.90; //20211209//3146.40; ////20201017 2991.45; //20190917 2829.60;  //20181212 //2797.20;

   {EI}
   EIRate            = 0.0164; //0.0166;   //20241103 //0.0163; //20231213 0.0158; //SAME //20211209 //20201017 0.0162; //20190917 0.0166; //20181212; //0.0163; //0.0188;                          //20171209
   MaxEIPremium      = 1077.48; //20251207 1049.12; //20241103  //20241103  //1002.45; //20231213 //952.74; //20221217 //889.54; //?? //20211209//856.36; //860.22; //20190917 858.22; //20181212 //836.19; //955.04;                          //20171209

   MaxEIEarnings     = 65700; //20251207  63200; //20241103  61500; //20231213 60300; //20221217 //56300; //20211209 54200; //20201017 //53100; //20190917 51700; //20181212 51300; //50800; //20161120 //49500;        //20171209
   MaxEIEarn53       = 65700; //20251207  63200; //20241103 61500; //20231213 60300; //20221217 //56300; //2021120954200; //53100; //20190917 51700; //51300; //50800; //20161120 49500;          //20171209
   MaxEIEarn54       = 65700; //20251207  63200; //20241103 61500; //2023121360300; //20221217     //56300; //20211209 54200; //53100; //20190917 51700; //51300; //50800;  //20161120 49500;         //20171209

   //quebec ei
   QppEiRate         = 0.0131;//20251207//0.0132; //20241103 //0.0127;//20231213 ////0.0120; //20221217 //0.0118; //??  //20211209//0.0120; //20201017 //0.0125; //20190917 1.30; //20181212  //1.27;
   QppMaxEiPremium   = 860.67; //20251207 834.24; //20241103 //781.05; //20231213 723.60; //20221217 //664.34; //??  //20211209 650.40; //20201017 //663.75; //20190917  672.10; //20181212 //651.51;


  FormsDBLite    = 'T4T5Scr.DB'; //20150918 Igor
  FormsTableLite = 'T4T5Scr';    //20150918 Igor

  FormsCfgDBLite    = 'T4T5CFG.db';  // 20150923 Igor
  FormsCfgTableLite = 'T4T5CFG';     // 20150923 Igor

  FormsFeesDBLite    = 'Fees.DB'; //20150923 Igor
  FormsFeesTableLite = 'Fees';    //20150923 Igor

  Empl_dbf = 'Empl.dbf'; //20170117 Igor

const
  //CertificationMode = False; //True;  //20201227
  //RecentFlName='Recent.txt';
  BlackBoxDir='C:\temp';
  //OptionsFlName='Options.txt';
  //YesNoSet =['Y','y','N','n'];

  AppName = 'T4T5'; //-FORMS';
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

  FirstFormName = 'EMPL';
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
  RecentDelim='¦'; //20230116 Igor
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

  PrvLong : Array[1..14] of string =       //28 instead of 22
   ('NEWFOUNDLAND AND LABRADOR','PRINCE EDWARD ISLAND','NOVA SCOTIA',
    'NEW BRUNSWICK','QUEBEC','ONTARIO','MANITOBA',
    'SASKATCHEWAN','ALBERTA','BRITISH COLUMBIA',
    'NORTHWEST TERRITORIES','YUKON TERRITORY','NON RESIDENT','NUNAVUT');

  PRPStatusCodes : array [0..7] of string =
   ('00','01','02','03','04','05','06','07');
  PRPStatusDescr : array [0..7] of string =
   ('W.I.P.','Not Started','Missing Data','Review Stage','Ready To File','N/A','N/A','N/A');

  {
  PRPStatusCodes : array [0..7] of string =
   ('00','01','02','03','04','05','06','07');
  PRPStatusDescr : array [0..7] of string =
   ('W.I.P.','Not Started','Missing Data','Printed','Ready To Print', 'Review Stage',
     'Finished','Re-assessed');
  }
  PRPQueries : array [0..7] of string =
   ('WIP','NotStart','MissData','Printed','ReadyPr','InReview',
    'Finish','Reasses');

  {Tax constants}


 Type  //20111231
 TDynamicFormParameters = Record
   ArrayNo        : Integer;
   FirstFieldId   : Integer;
   BoxesPerRow    : Integer;
 end;


type    {1=line,2=rectangle, etc}
  TDrawingTool = (dtLine,dtRectangle,dtEllipse,dtRoundRect);


  //20170216 Igor >>>
  TT4Sum     = Record
    NumSlips   :string;
    TotBox14   :real;
    TotBox20   :real;
    TotBox52   :real;
    TotBox55   :real;
    TotBox56   :real;
    TotBox24   :real;
    TotBox16   :real;
    TotBox16e  :real;  //20250124
    TotBox18   :real;
    TotBox22   :real;
    TotCPPAdj  :real;
    TotEIAdj   :real;
    TotTotAdj  :real;
    EmployerCPP :real;
    EmployerCPPe :real; //20250124
    EmployerEI  :real;
    T4Remit     :real;
    TotDed      :real;
    SubTot      :real;
    Diff        :real;
    OverPay     :real;
    Balance     :real;
    NewHires    :real;
    NHires_Flg  :String;
    TotBox83    : real;
    EncloseT4  : Real;
  End;

  TT4ASum = record
    NumSlips:string;
    TotBox16: real;
    TotBox18: real;
    TotBox20: real;
    TotBox22: real;
    TotBox24: real;
    TotBox26: real;
    TotBox27: real;
    TotBox28: real;
    TotBox30: real;
    TotBox32: real;
    TotBox34: real;
    TotBox40: real;
    TotBox42: real;
    TotBox46: real;
    TotBox48: real;
    TotBox101:real;
    T4ARemit: real;
    TotDed  : real;
    Diff    : real;
    OverPay : real;
    Balance : real;
    T4AEnclosed: real;
  end;

  TT5Sum = record
    NumSlips:string;
    TotBox10: real;
    TotBox11: real;
    TotBox12: real;
    TotBox13: real;
    TotBox14: real;
    TotBox15: real;
    TotBox16: real;
    TotBox17: real;
    TotBox18: real;
    TotBox19: real;
    TotBox24: real;
    TotBox25: real;
    TotBox26: real;
  end;


  //20170216 Igor <<<
 {============================== VARIABLES ======================}

var {Lists of common types }
  XX              : Real; //for debugging TV varables //20250124
  DataDictList    : TDataDictList;
  DataDictRec     : TDataDict;

  {-----------   FORM DEFINITION -------------------}

  FList, FLastYearList: TFList; //20160629 Igor
  FRec, FLastYearRec: TFRec; //20160629 Igor

  ExtractedAutoList  : TExtractedAutoList;
  ExtractedAutoRec   : TExtractedAutoRec;

  ExtractedCCAList  : TExtractedCCAList;
  ExtractedCCARec   : TExtractedCCARec;

var
   XmlDir:String;  //20200210
   TfPropDynList:TStringList; //replaces the older array of properties  //20110131
    //really global???

   CurrentRoutine: String;

   SomeLetterName: String;
  QrLtrName:String;
  ElmsInError:TStringList;
  //FormElmArray : array of array of array of String;
  //FormElmDollar : array of array of boolean; //[Frm][Elm]
  ReviewMarkColor: TColor;
  BorderShape:TShape;
  ReviewShape:TShape;
  PrintShade:TColor;
  SomeString:String;
  SomeResult:Boolean;
  ScaleType:String;
  TrFolder:String;
  Sc,ScChar,ScChange:real; {scaling}
  FieldChange : Boolean;
  PdfFormsDir:String;

  {Low high index for slip strings All in the same array}

  LogoBmp :TBitmap;
  RY : Integer;  {Rate year: 0= current, 1= next year}
  FullPaint :Boolean;

  LetterType :String; //[6];  {Cover or Other:if Cover it calcs}
  AppDir, //: string; //[66];   {AppVersion : string; //[5];}
  BatchOper, //: string; //[20];
  BatchFilter, //: string; //[20];
  FileDescr,  // :string; //[60];
  FixDbName,  // : string; //[12];
  SomeFilter, //: string; //[60];
  SomeFileMask, // : string; //[10];
  SelectedString, // : string; //[120];
  SomeLabel,  //:string; //[120];
  SomeFile, //:string; //[60];
  SomeDir:  string; // :string; //[60];

  VList :TStringList; {stores validation rules for current form:
      i.e. YN,??????}
  TaxSumList : TstringList; {holds x-ref for TaxSumList}
  NewForm : Boolean;

  (* //20170721
  Constant : Array[0..1] of ConstantsRec;
  PrvConstant : Array[0..1] of PrvConstantsRec;
  *)
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
  FullPathT4T5Scr_LastYear: String; //20160629 Igor

//20170126 Igor >>>
const
//fieldsID   The numbers below are ELM numbers on the form
  EMPL_EMPL_NAME  = 1;
  EMPL_STREET     = 2;
  EMPL_CITY       = 3;
  EMPL_PROV       = 4;
  EMPL_POSTAL     = 5;
  EMPL_COUNTRY    = 6;
  EMPL_FIRSTNAME  = 7;
  EMPL_LASTNAME   = 8;
  EMPL_AREACODE   = 9;
  EMPL_TELEPHONE  = 10;
  EMPL_AUTHNAME   = 11;
  EMPL_POSITION   = 13;
  EMPL_EMPLNO     = 16;
  EMPL_DISTRICT   = 18;
  EMPL_TAXCENTRE  = 18;  //20171231
  EMPL_T2CORPNO   = 19;
  EMPL_PAYPERIODS = 20;
  EMPL_UIRATE     = 21;
  EMPL_ACCOUNTT4  = 22;
  EMPL_REMITT4    = 23;
  EMPL_ACCOUNTT4A = 24;
  EMPL_REMITT4A   = 25;
  EMPL_RPPNUM1    = 26;
  EMPL_RPPNUM2    = 27;
  EMPL_RPPNUM3    = 28;
  EMPL_PROPSIN1   = 29;
  EMPL_PROPSIN2   = 30;
  EMPL_T5FILER    = 31;

  T4_EMPL_NAME        = 1;
  T4_YEAR             = 2;
  T4_ACCOUNT          = 5;
  T4_PROVINCE         = 6;
  T4_SIN              = 7;
  T4_BOX28A           = 8;
  T4_BOX28B           = 9;
  T4_EMPLCODE         = 10;
  T4_LASTNAME         = 11;
  T4_FIRSTNAME        = 12;
  T4_INITIALS         = 13;
  T4_STREET           = 14;
  T4_CITY             = 15;
  T4_PROV_POSTAL      = 16;
  T4_BOX14            = 18;
  T4_BOX16            = 19;
  T4_BOX16e           = 47;  //20250124  2nd cpp
  T4_BOX17            = 20;
  T4_BOX18            = 21;
  T4_BOX20            = 22;
  T4_BOX52            = 23;
  T4_BOX22            = 24;
  T4_BOX24            = 25;
  T4_BOX26            = 26;
  T4_BOX44            = 27;
  T4_BOX46            = 28;
  T4_BOX50            = 29;
  T4_BOXCODE1         = 30;
  T4_AMOUNT1          = 31;
  T4_BOXCODE2         = 32;
  T4_AMOUNT2          = 33;
  T4_BOXCODE3         = 34;
  T4_AMOUNT3          = 35;
  T4_BOXCODE4         = 36;
  T4_AMOUNT4          = 37;
  T4_BOXCODE5         = 38;
  T4_AMOUNT5          = 39;
  T4_BOXCODE6         = 40;
  T4_AMOUNT6          = 41;
  T4_BOTTOMCOLONTITUL = 42;
  T4_BOX28C           = 44;
  T4_BOX55            = 45;
  T4_BOX56            = 46;

  T4A_YEAR             = 1;
  T4A_EMPL_NAME        = 2;
  T4A_ACCOUNT          = 3;
  T4A_SIN              = 4;
  T4A_RECIP_BN         = 5;
  T4A_LASTNAME         = 6;
  T4A_FIRSTNAME        = 7;
  T4A_STREET           = 9;
  T4A_CITY             = 10;
  T4A_PROV             = 11;
  T4A_POSTAL           = 12;
  T4A_BOX16            = 14;
  T4A_BOX18            = 15;
  T4A_BOX24            = 16;
  T4A_BOX22            = 17;
  T4A_BOX20            = 18;
  T4A_BOX48            = 19;
  T4A_FT_CD1           = 20;
  T4A_FT_AMT1          = 21;
  T4A_FT_CD2           = 22;
  T4A_FT_AMT2          = 23;
  T4A_FT_CD3           = 24;
  T4A_FT_AMT3          = 25;
  T4A_FT_CD4           = 26;
  T4A_FT_AMT4          = 27;
  T4A_FT_CD5           = 28;
  T4A_FT_AMT5          = 29;
  T4A_FT_CD6           = 30;
  T4A_FT_AMT6          = 31;
  T4A_FT_CD7           = 32;
  T4A_FT_AMT7          = 33;
  T4A_FT_CD8           = 34;
  T4A_FT_AMT8          = 35;
  T4A_FT_CD9           = 36;
  T4A_FT_AMT9          = 37;
  T4A_FT_CD10          = 38;
  T4A_FT_AMT10         = 39;
  T4A_FT_CD11          = 40;
  T4A_FT_AMT11         = 41;
  T4A_FT_CD12          = 42;
  T4A_FT_AMT12         = 43;
  T4A_BOTTOMCOLONTITUL = 44;


  T5_YEAR               = 1;
  T5_BOX24              = 2;
  T5_BOX25              = 3;
  T5_BOX26              = 4;
  T5_BOX13              = 5;
  T5_BOX18              = 6;
  T5_BOX10              = 7;
  T5_BOX11              = 8;
  T5_BOX12              = 9;
  T5_RECCODE            = 10;
  T5_SIN                = 11;
  T5_RECTYPE            = 12;
  T5_BOX14_NUMBER       = 13;
  T5_BOX14              = 14;
  T5_BOX15_NUMBER       = 15;
  T5_BOX15              = 16;
  T5_BOX17_NUMBER       = 17;
  T5_BOX17              = 18;
  T5_LASTNAME_FIRSTNAME = 19;
  T5_STREET             = 20;
  T5_CITY               = 21;
  T5_PROV_POSTAL        = 22;
  T5_EMPL_NAME          = 24;
  T5_EMPL_STREET        = 25;
  T5_EMPL_CITY          = 26;
  T5_EMPL_PROV_POSTAL   = 27;
  T5_CURRENCY           = 29;
  T5_TRANSIT            = 30;
  T5_RECACCOUNT         = 31;
  T5_BOTTOMCOLONTITUL1  = 32;
  T5_BOTTOMCOLONTITUL2  = 33;
  T5_PAGE_NO            = 34;
  //20170126 Igor <<<

//20170219 Igor >>>
const //STATUS fields
  PswElm = 25;
  c_LastYearElm = 32;
  c_ReturnColorElm = 50;
  c_FileDescription = 51; //20180314 Igor
  SHARE_WITH_PEOPLE = 52; //20190228 Igor
//20170219 Igor <<<

implementation

uses SysUtils;

procedure Done;
var
  i: integer;
begin
  FreeAndNil(ElmsInError);
  FreeAndNil(TaxSumList);
  FreeAndNil(VList);
  FreeAndNil(ExtractedAutoList);
  FreeAndNil(ExtractedCCAList);
  FreeAndNil(DataDictList);
  FreeAndNil(TfPropDynList);
  FreeAndNil(FrmTreeForms);
end;

initialization
//by code
finalization
  Done;
end.

