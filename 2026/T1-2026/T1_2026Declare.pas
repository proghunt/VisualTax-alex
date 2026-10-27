unit T1_2026Declare;

interface

uses
  WinTypes, ComCtrls, Controls, classes, Graphics, ExtCtrls, Contnrs, VtEditBox,
  vtMulti, vtShared, vtDataBase, System.Generics.Collections, uADCompClient; // 20150923 Igor
//Apr 11: fixed Prv sch 2

const //update every year/release
  //20161130 Igor
  {TODO -oIgor : Change the value of the result after start or end DRAFT period.}
  //HideOverrides = FALSE;   //20250308 //jz//20260331 - I do not think this does anything,
                                        //               overrides are stopped in common vtMulti with var craTestingVersion
                                       //               vtBase, amd executable must be rebuilt to take effect
  isDraft: Boolean = FALSE;
  MyRollover       = FALSE;  //TRUE; SPECIAL ROLLOVER to OPen and retain all previous yers data

  AppRelease = '0.0';  //20161112   //20170217
  AppYear = '2026'; //20190907 //20150623   //to FOOL the program //20190711 CON
  AppYearInt = 2026;  //to FOOL the program //20190711 CON
  DataVersion = '1.0'; //20260221cz //20200511 //'1.0'; //20170212

  AppUpdateDate ='2026/08/15'; //'2026/05/10'; //'2026/04/15'; //'2026/03/28'; //'2026/03/21'; //'2026/03/15'; //'2026/03/09'; //'2026/02/28'; //20260221 //'2025/12/17'; //'2025/12/08'; // '2025/11/26'; //'2025/11/05'; //'2025/06/13';//20260613 //'2025/05/16';
   //'2025/05/01'; //'2025/04/28'; //'2025/04/09'; //'2025/04/03'; //20250408//19'; //'2025/02/15'; //'2025/02/01'; //20241223 //2024/05/20';
  //------------------------------------------------------------------

  //EfileSoftReleaseDate = '2025-06-13'; //'2025-05-12'; //'2025-05-01';  //'2025-05-13'; //20260409 //'2025-03-28'; //065F //'20250317
  EfileSoftReleaseDate = '2026-03-31'; //20260221  //'2025-06-13'; //'2025-05-12'; / //20260131

  vtClientUpdateDate = '2021/03/09'; //'2021/01/19'; //20210118 Igor   //20210312
  // AppUpdateDate = '2019/03/12'; //'2018/06/05'; //20181120
  CraOpensForEfileDate = '2026-02-23'; //20260131 '2025-02-19'; //'2019-02-18';  //20180122
  LimitedVersionDir = 'C:\VT-T1DATA25';//'C:\VT-T1DATA24';//20171218  //'C:\VT-T1DATA16'; //'C:\VTDATA15'; //20160718 Igor  //20170210   uppercase
  LimitedVersionReturns = 50;
  NetFileVersionReturns = 20;
  AuthorizationPosition = 9;
  {Capacity}
{$IFDEF ReturnsLimit}
  ReturnsLimit = 20;
{$ELSE}
{$ENDIF}
  FormsLimit   = 1000; //20180324 //700; //20170416 //600; //20101115 //600; //FormsLimit   = 700;  //20100603 //20160505 Igor
  LnLowBound   = 10100; LnHighBound  = 48500; //20190728
  LastYrLnLowBound=101; LastYrLnHighBound=486;   //LnLowBound   = 101; LnHighBound  = 486;
  //LabelProperties = 9;  LineProperties  = 8;  FieldProperties = 12;
 // LabelsLimit  = 200;
  FieldsLimit  = 1300; //20221211 //1250;  //600;  //20100603
  //LinesLimit   = 200;

  //DBForms = 'T1SCR.DBF'; //'FormsList.dbf'; //T1-2010: 'T1SCR.DBF';
  FormsDBLite    = 'T1SCR.DB'; //20150915 Igor
  FormsTableLite = 'T1SCR';    //20150915 Igor
  FormsFeesDBLite    = 'T1Fees.DB'; //20150915 Igor
  FormsFeesTableLite = 'T1Fees';    //20150915 Igor
  FormsScrDBLite    = 'T1Scr.DB'; //20150915 Igor
  FormsScrTableLite = 'T1Scr';    //20150915 Igor
  FormsCfgDBLite    = 'T1Cfg.DB'; //20150916 Igor
  FormsCfgTableLite = 'T1Cfg';    //20150916 Igor

  TaxByteDBLite    = 'TaxByteT1.DB'; //20150923 Igor
  TaxByteTableLite = 'TaxByteT1';    //20150923 Igor
  TddElmsDBLite = 'TddElms.db'; //20160505 Igor
  TddElmsTableLite = 'TddElms'; //20160505 Igor
  vtCourierKey = 'tUySkeCmL9bR5Cc4'; //20201026 Igor
  vtClientCreated = 'VTCLIENTCREATED'; //20210115 Igor

  T1134_FA_LIST = 52; //20230712 Igor  //20230801

var

  forCRATestMode   : Boolean;
  inJZtestmode     : Boolean;

  PlanYear:String;
  RealTemp,xx,yy,zz:Real; //or XX//define onc as global. Used to show Intermediate result in calcs as TV is not accessible //20240112
  XXString: String;  //20250328
  is23600Negative       : boolean = false;
  Lnn23600NegativeAmount:  real;  //20250221 to capture te Negative ni
  //20250223
  is26000Negative       : boolean = false;
  Lnn26000NegativeAmount:  real;  //20250223 to capture te Negative txbl income

                            //if true
                            //  - activates extended listbal
                            //  - turns off Efile warnings / Password
                            //  - turns off printing Password


  const
  //YesNoSet =['Y','y','N','n',' '];
  SELDIRHELP = 1000;
  DeveloperCode='064';   //20111207
  SoftCodeSuffix='F';  //only for EOL

  EfDelim='!';
  RecentDelim='¦'; //20200914 Igor
  //Ditto='"';
  AppName = 'T1';
  //RecentRFlName='Recent.txt';
  //OptionsFlName='Options.txt';
//box background color
  DarkShade=$00B4B4B4; //rgb(180,180,180);
  brightGreen=$0097FF97; //rgb(151,255,151
  PinkishColor=$00AEAEFF;//$008080FF; //255,174,174 //rgb(255,128,128)
  BluishColor=$00FADDA0; //rgb (160,221,250)
  FirstRetColor=$00FFFFC3; //Rgb(195,255,255)
  //----
  MyBlue  = $00AC7400;
  MyLightBlue = $00FFFFCA; //$00FFFF80; //$00FFFFE1;
  MyBeige =$00C8D0D8;
  MyBronze = $A6CAF0;
  LightGreen=$0097FFFF; //$00B7FFFF; // $00D2FFFF; //$00A7FCE2; //$00C0FEEF; //$00DFFFBF;
  //LightYellow = $00C1FFFF;
  MyYellow =$00C5EEFE;
  {light brown $009098A8}
 { clCream = TColor($A6CAF0);}
 { clSkyBlue = TColor($FFFBF0);}
 { clMoneyGreen = TColor($C0DCC0);}
  {Top fp step color = $00D2FDB7}
 { NormalHaki =$00C5EEFE;}  {haki}
   {Light yellow $00DFFFFF}
  {Haki $00C5EEFE;}
  NoteColor=$00E7CFCF;  //light haki
  //TapeColor=MyBronze; //$009098A8; //light brown //20220121 Igor
  {Light blue $00FFFFE1}
  {Light grey $00E6E6E6}

  BoxHeight    = 15; {height of edit box}
  DefFontName =  'Arial';
  RepaintSw    : Boolean = True;
  //CreatingNew  : Boolean = True;
 // ClosingReturn : Boolean = False;
  //Delimiter    : String [1] = Chr(127);  {in file i/o between va riables}
  KeyWDelimiter1 : String [1] = '\';
  KeyWDelimiter2 : String [1] = '\';

  //added T1C_ON //20260425
  AutoSignedForms : Array[1..9] of string =
     ('T183','T183I','T1135','AUTHREP','CONSENT','T2091','T1032','RC71','T1C_ON'); //20200618   //20200517

{  
AutoSignedForms : Array[1..7] of string =
   ('T183','T183I','T1135','AUTHREP','CONSENT','T2091','T1032'); //20200517
}

  MarDescr : Array[1..6] of string =
   ('Married','Common-law','Widowed','Divorced',
    'Separated','Single');

  PrvShort : Array[1..14] of string =
   ('NL','PE','NS','NB','QC','ON','MB','SK','AB','BC','NT','YT','ZZ','NU');
  {must also chane the PrvRate array}

  PrvLong : Array[1..14] of string =
   ('NEWFOUNDLAND AND LABRADOR','PRINCE EDWARD ISLAND','NOVA SCOTIA',
    'NEW BRUNSWICK','QUEBEC','ONTARIO','MANITOBA',
    'SASKATCHEWAN','ALBERTA','BRITISH COLUMBIA',
    'NORTHWEST TERRITORIES','YUKON TERRITORY',
    'NON RESIDENT','NUNAVUT');


  AltAddrCodes:  Array[1..5] of string =
   ('00 Taxpayer address',
    '01 Fwd to preparer address (NOA and/or refund)',
    '02 Fwd to preparer address (NOA only)',
    '03 Fwd to preparer business address(NOA and/or refund)',
    '04 Fwd to preparer business address(NOA only)');

  TypeOfRet:  Array[1..3] of string =
   ('1 Prepared for compensation',
    '2 Prepared by client',
    '3 Discounted return');

  EFStatusCodes : array [0..6] of string =
   ('00','01','02','03','04','05','06');
  EFStatusDescr : array [0..6] of string =
   ('EF not started','EF Ready For EFILE','EF Accepted','EF Rejected',
    'EF Waiting Ack','EF Ready For SEND','Paper Filed');

  EFQueries : array [0..6] of string =
   ('Efnostrt','EFReady','EFAccept','EFReject','EFRtu','EFSEND','PFiled');

  PRPStatusCodes : array [0..7] of string =
   ('00','01','02','03','04','05','06','07');
  PRPStatusDescr : array [0..7] of string =
   ('W.I.P.','Not Started','Missing Data','Printed','Ready To Print', 'Review Stage',
     'Finished','Re-assessed');
  PRPQueries : array [0..7] of string =
   ('WIP','NotStart','MissData','Printed','ReadyPr','InReview',
    'Finish','Reasses');
  MaxDynamicElmsPerForm =400; //20150119 Igor


 type TRichTextMeasurements = (rtmNone, rtmInches, rtmCentimetres);
 type
  ShortcutType = (_DESKTOP, _QUICKLAUNCH, _SENDTO, _STARTMENU, _OTHERFOLDER);



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
  //20190202
  AiiPAdditions   : Real;
  AiiPProceeds    : Real;
  AiiPUccAdj      : Real;
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
   CCAClaimed      : Real;  //20200511
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
 TLogRec = Record
   Pay_dt       : string; //[10];
   OfficeCode   : string; //[4];
   AgentCode    : string; //[4];
   Pay_InvNo    : string; //[14];
   Pay_Type     : string; //[7];
   Pay_amount   : string; //[9];
   ReturnType   : string; //[1];
   RefundOrDue  : string; //[9];
   LastName     : string; //[30];
   FirstName    : string; //[10];
   SinNo        : string; //[9];
   Phone        : string; //[13];
   Filler       : string; //[20]; {for fut use}
 end;

 Type  //20121120  //collects from T4PS and T4
 TRc359Rec = Record
   EmployerName   : string; //[60];
   Contr      : Real;
   EmplInc    : Real;
   EmplDed    : Real;
 end;

 Type
 ACfgRec = Record
   Dir_Cur      : string; //[70];
   Dir_Deflt    : string; //[70];
  // Dir_Refile   : string; //[70]; //20240606
   Dir_LastYr   : string; //[70];
   Dir_PrvLYr   : string; //[70];
   Dir_Train    : string; //[40];
   Dir_Sample   : string; //[40];

   Prp_Name     : string; //[50];
   Prp_Street   : string; //[35]; //string; //[30]; //20100312
   Prp_City     : string; //[30];
   Prp_Prov     : string; //[2];
   Prp_Postal   : string; //[8];
   Prp_Countr   : string; //[8];
   Prp_Area     : string; //[3];
   Prp_Tel      : string; //[8];
   Prp_FxArea   : string; //[3];
   Prp_Fax      : string; //[8];
   Prp_DiscNo   : string; //[10];
   Prp_DiscNm   : string; //[30];
   Prp_GSTNo    : string; //[17];
   Prp_Bill     : string; //[1];
   Prp_VSFee    : Real; //20100624
   Prp_SFee     :Real;
   Prp_AFee     :Real;
   Prp_CFee     :Real;
   Prp_VCFee    :Real;
   Prp_Kstrk    :Real;
   Prp_Hour     :Real;
   Prp_Elect    :Boolean;
   Prp_EfRepr   :Boolean;
   Prp_Dates    :Boolean;

   Nfl_Prov     : string; //[2]; {New File defqaults}
   Nfl_City     : string; //[20];
   Nfl_Disced   : string; //[1];
   Nfl_Efile    : Boolean;

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

   Prn_Shade   : Boolean;
   Prn_Head    : Boolean;
   Prn_NameH   : Boolean;
   Prn_SinH    : Boolean;
   Prn_HideSin : Boolean;
   Prn_DateH   : Boolean;
   Prn_Disclm  : string; //[130];
   Bus_Disclm  : string; //[130];
   Prn_Logo    : Boolean;
   Prn_logoln  : integer;
   Opr_Recalc  : Boolean;
   Opr_Close   : Boolean;
   Opr_FPres   : Integer;
   Opr_GstHst  : Real;
  end;

var
  ColorList: TColorTable;

{$IFDEF nonshared}
type
  {a Pointer to form record}
   //PExtractedAutoList  = ^AExtractedAutoRec;
   TExtractedAutoRec   = class
     StatementId, //      : string; //[12];
     ClassId, //          : string; //[4];
     Description      :String;  //[40];
     KmDrove          :Integer;
     KmTotal          :Integer;
     DateAcquired     :String;  //[10];
     Cost             : Real;
     KmPercent  : Real;
     StatementPercent :Real;
     ExpensesClaimed  : Real;
     CCAForTheYear    :Real;
     UccStart         : Real;
     Additions        : Real;
     AdditionsPersonal: Real;
     Proceeds         : Real;
     ProceedsPersonal : Real;
     UccAfter         : Real; //20190217
     Adjustments      : Real;
     BaseAmount       : Real;
     Rate             : Real;
     CCAClaimed       :Real;
     CCA              : Real;
     UCCEnd           : Real;
     TerminalLossAmount : Real;
     RecaptureAmount  : Real;
     AutoCCAForStatement  : Real;
     PartnerFlag      : string; //[1];
     //20190215
     AiiPAdditions   : Real;
     AiiPProceeds    : Real;
     AiiPUccAdj      : Real;

     { add new fields to vtShare in Common and rebuild vtBase
     //new field //20230424
     Col1Val:String[3];
     Col2Val,Col3Val,col4Val,col5Val,col6Val,col7Val,col8Val,col9Val,col10Val,col11Val,col12Val,
     col13Val,col14Val,col15Val,col16Val,col17Val,col18Val,col19Val:Real;
     }

 end;

type
   TExtractedCCARec   = class
     StatementId, //      : string; //[12];
     ClassId, //          : string; //[4];
     Description, //      :String;  //[40];
     DateAcquired     :String;  //[10];
     PersonalPercent  :Real;
     Cost             : Real;
     StatementPercent :Real;
     CCAForTheYear    :Real;
     UccStart         : Real;
     Additions        : Real;
     AdditionsPersonal: Real;
     Proceeds         : Real;
     ProceedsPersonal : Real;
     Adjustments      : Real;
     AdjUCC           : Real;
     BaseAmount       : Real;
     Rate             : Real;
     CCAClaimed       :Real;
     CCA              : Real;
     UCCEnd           : Real;
     RecordKeeping    : string; //[1];  //20110109
     TermLossFlag     : string; //[1];
     TerminalLossAmount : Real;
     RecaptureAmount  : Real;
     CCAForStatement  : Real;
     //20190202
     AiiPAdditions    : Real;
     AiiPProceeds     : Real;
     AiiPUccAdj       : Real;
    { add new fields to vtShare in Common and rebuild vtBase //20230424
     //new field //20230424
     Col1Val:String[3];
     Col2Val,Col3Val,col4Val,col5Val,col6Val,col7Val,col8Val,col9Val,col10Val,col11Val,col12Val,
     col13Val,col14Val,col15Val,col16Val,col17Val,col18Val,col19Val:Real;
     }
  end;
{$ELSE}
{$ENDIF}
var
  ExtractedAutoRec   : TExtractedAutoRec;
  ExtractedCCARec   : TExtractedCCARec;
  ExtractedCCAList  : TExtractedCCAList;
  ExtractedAutoList  : TExtractedAutoList;

(* //20170410 Igor
var {List of DataDict }
  DataDictList    : TDataDictList;
  DataDictRec     : TDataDict;
*)

var
  FList, FLastYearList: TFList;
  FRec, FLastYearRec: TFRec;


var
   FeesList     : TFeesList;

Type
 TDepRec = Record
   Id,  //          : string; //[3];
   FirstNm, //     : string; //[15];
   LastNm,  //      : string; //[40];
   BirthDate, //   : string; //[10];
   Sin, //         : string; //[11];
   Relationship,  //:string; //[15];
   Infirmity   : String;  //[1];
   Caregiver   : String; //20171209
   NetInc      : Real;
   Street,  //      : string; //[40];
   City,  //        : string; //[40];
   Prov,  //        : string; //[2];
   Postal,  //      : string; //[7];
   EligibleDepend: String;  //[1];  //20101106
 end;

 //type TEfResponse=(Accepted,ReturnError,WebServicesError,XmlSyntaxError); //20140126


 var tempAckRecDescription          : ansistring;  //20170130
 var tempAckRecErrorCodeMsg         : Array[1..6] of array[1..12] of ansistring;  //20181802 //var tempAckRecErrorCodeMsg         : Array[1..6] of ansistring;

 Type
  TEFresultType = (EFaccepted,EFrejected,EFwebServiceError,EFNotSent);   //20140124 //jz//20250321- add EFNotSent
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
   HyperlinkLink        : Array[1..5] of String[255]; //String[255]; //jz //20230217
   HyperlinkText        : Array[1..5] of String[255]; //String[255];
   ErrorCode            : Array[1..6] of String[6];
   ErrorCodeMsg         : Array[1..6] of array[1..12] of String[255]; //20181802 //ErrorCodeMsg         : Array[1..6] of String[255];
   Accepted             : Boolean; { TODO 1 -oCon : used in T1_2026T1135efile }
   EFresultType         : TEFresultType; //EfR
 end;

 TAckRec2 = Record //20160329 Igor
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
   EFresultType         : TEFresultType;
 end;

  {
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
   //Accepted             : Boolean;
   EFresultType         : TEFresultType; //EfR
 end;
 }

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



{  //20150102
 Type T1135AckRec = Record  //20160120 Igor
   Name                 : String;
   DateTimeReceived     : String;
   TransmitterID        : String;
   ConfirmationID       : String;
   Response             : String;
   ResponseCode         : String;
   ResponseText         : ansiString;
   additionalText       : ansiString;
   T1135resultType      : TT1135resultType;
 end;
}

//20220113 Igor >>>
 type FormLevelResponse = Record
   FormID               : Integer;
   Name                 : String;
   ResponseCodes        : TArray<String>;
   ResponseTexts        : TArray<String>;
 End;

 Type TT1013resultType = (T1013accepted,T1013rejected,T1013Delayed,T1013webserviceError); //20160119 Igor
 Type T1013AckRec = Record
   Name                 : String;
   DateTimeReceived     : String;
   TransmitterID        : String;
   ConfirmationID       : String;
   Response             : String;
   ResponseCode         : String;
   ResponseText         : ansiString;
   ResponseCodes        : TArray<String>;
   ResponseTexts        : TArray<String>;
   FormLevelResponses   : TArray<FormLevelResponse>;
   ReceivedFormsCount   : Integer;
   AcceptedFormsCount   : Integer;
   RejectedFormsCount   : Integer;
   additionalText       : ansiString;
   T1013resultType      : TT1013resultType;

 end;
//20220113 Igor <<<
(*
 Type TT1013resultType = (T1013accepted,T1013rejected,T1013Delayed,T1013webserviceError); //20160119 Igor
 Type T1013AckRec = Record
   Name                 : String;
   DateTimeReceived     : String;
   TransmitterID        : String;
   ConfirmationID       : String;
   Response             : String;
   ResponseCode         : String;
   ResponseText         : ansiString;
   additionalText       : ansiString;
   T1013resultType      : TT1013resultType;
 end;
*)
Type
 TMedSum330 = Record
   PeriodPaid :Real;
   //Claim     :Real;
 end;

Type
 TMedSum331 = Record
   DependId   :String;  //[3];
   PeriodPaid : Real;
   //Claim     :Real;
 end;

  {Tax constants}
Type
   ConstantsRec = Record
   {Federal}
   Bracket1, Bracket2,Bracket3  :Real;
   Bracket4,Bracket5:Real;   //20201108
   Rate1,Rate2,Rate3,Rate4:String;  //[6];
   Rate5,Rate6: String;
   BracketTax1,BracketTax2,BracketTax3,BracketTax4  :Real;
   BracketTax5,Bracket6: Real;  //20201108 //bracket6
   FullYear          : Integer;
   MaxAgeAmount      : Integer;
   MaxInfirmAmount : Integer;   //20150708
   AgeBaseAmount     : Integer;
   AgeNIThreshHold   : LongInt;
   BasicPersonalAmount : Integer;
   MaxDisability     : Integer;
   MaxDisabSupl18    : Integer;
   DisabSuplBase     : Real;
   MedicalLimit      : Integer;
   MaxMedicalExpense : Real;
   CanEmplAmount     :Real;
   MedicalRefundMinThreshHold  :Real;
   MedicalRefundBase    :Real;
   MedicalRefundSupplement   :Real;
   KidClaim             : Real;
   MaxAdoption      : Real;
   MaxSpousalAmount : Integer;
   EducPerMonth     : Integer;
   PartEducPerMonth  : Integer;
   EducLimit        : Integer;
   DonPercent       : Integer;
 //  SpousalBase : Integer;  {No claim above this base}  //20210805
   InfirmDependBase : Real;  {No claim above this base}
   MaxDependAmount : Integer;
   //----
   MaxCpp : Real;
   CPPRate : Real;
   MaxCppPensionableEarnings : LongInt;  //20241120
   BasicCppExemption : Integer;
   MaxCppEarnings : real;
   //additional cpp related //20241120
   MaxAdditionalCPPPensionableEarnings: Real;
   MaxAdditionalCppContributions:Real;
   //additional Qpp related //20241120
   MaxAdditionalQppPensionableEarnings: Real;
   MaxAdditionalQppContributions:Real;
   //----
   UIRate : Real;
   MaxUI52 : Real;
   MaxUIEarn52 :Real;
   UIBaseRep : Real;
   OASBaseRep : Real;

   RSPLimit : Integer;
   CareGvrBase : Real;
   MaxCareGvr  :Real;
   DonRate1 : Real;
   DonRate2 : Real;
   MoneyPurchaseLimit: Real;
   FcaAmount : Real;  //20130523
   DivOtherThanElig:Real;
   DivElig: Real;

   //QC related //20140614
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
  Constant : Array[0..1] of ConstantsRec;

Type
   PRVConstantsRec = Record
   {Ontario}
   PrvBracket1  : Real;
   PrvBracket2  : Real;
   PrvBracket3  : Real;
   PrvBracket4  : Real;
   PrvBracket5  : Real;   //  20181112 for BC
   PrvBracket6  : Real;   //?  20201108 for BC
   PrvBracket7  : Real;

   PrvBracketTax1 : Real;
   PrvBracketTax2 : Real;
   PrvBracketTax3 : Real;
   PrvBracketTax4 : Real;
   PrvBracketTax5 : Real;
   PrvBracketTax6 : Real;  //20181112
   PrvBracketTax7 : Real;  //20201108 //for BC
   PrvBracketTax8 : Real;

   PrvPersAmount  : Real;
   PrvSpouseBasicAmount : Real;
   PrvNonRefundRate : Real;
   PrvRate1,PrvRate2, PrvRate3, PrvRate4,  PrvRate5, PrvRate6,PrvRate7,PrvRate8 : String;  //20201108 added prvrate7

   PrvMaxAgeAmount      : Integer;
   PrvAgeBaseAmount     : Integer;
   PrvAgeNIThreshHold   : LongInt;
   PrvMaxPensionAmount  : Real;
   //PrvMedicalAdjBase    : Real;
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
   PrvDivRate          : String; //Real;  //20161129
   PrvDivRateBig       : String; //Real;  //20161129  Real;
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
  InfoFNo,S8FNo:Integer;  //20241222

  PrintingCondensed: boolean = False; //20200129
  L50320Val:String;   //20200206
  WatermarkText: String;   //20191216  CON
  PrecalcS6Sw: Boolean;  //witb
  Ln30000FNo:Integer;  //20201118 //for speed reasons
  T2203Prov:String;  //20170505
  //20180406
  T2203NLAgeDed:Real;
  T2203PEAgeDed:Real;
  T2203NSAgeDed:Real;
  T2203NBAgeDed:Real;
  T2203ONAgeDed:Real;
  T2203MBAgeDed:Real;
  T2203SKAgeDed:Real;
  T2203ABAgeDed:Real;
  T2203BCAgeDed:Real;
  T2203YTAgeDed:Real;
  T2203NTAgeDed:Real;
  T2203NUAgeDed:Real;


  //20170508
  T2203NLDisabxfer:Real;  //20170505
  T2203PEDisabxfer:Real;  //20170505
  T2203NSDisabxfer:Real;  //20170505
  T2203NBDisabxfer:Real;  //20170505
  T2203ONDisabxfer:Real;  //20170505
  T2203MBDisabxfer:Real;  //20170505
  T2203SKDisabxfer:Real;  //20170505
  T2203ABDisabxfer:Real;  //20170505
  T2203BCDisabxfer:Real;  //20170505
  T2203YTDisabxfer:Real;  //20170505
  T2203NTDisabxfer:Real;  //20170505
  T2203NUDisabxfer:Real;  //20170505

  T2203NLTuitionxfer:Real;  //20170505
  T2203PETuitionxfer:Real;  //20170505
  T2203NSTuitionxfer:Real;  //20170505
  T2203NBTuitionxfer:Real;  //20170505
  T2203ONTuitionxfer:Real;  //20170505
  T2203MBTuitionxfer:Real;  //20170505
  T2203SKTuitionxfer:Real;  //20170505
  T2203ABTuitionxfer:Real;  //20170505
  T2203BCTuitionxfer:Real;  //20170505
  T2203YTTuitionxfer:Real;  //20170505
  T2203NTTuitionxfer:Real;  //20170505
  T2203NUTuitionxfer:Real;  //20170505

  T2203NLSpousexfer:Real;  //20170505
  T2203PESpousexfer:Real;  //20170505
  T2203NSSpousexfer:Real;  //20170505
  T2203NBSpousexfer:Real;  //20170505
  T2203ONSpousexfer:Real;  //20170505
  T2203MBSpousexfer:Real;  //20170505
  T2203SKSpousexfer:Real;  //20170505
  T2203ABSpousexfer:Real;  //20170505
  T2203BCSpousexfer:Real;  //20170505
  T2203YTSpousexfer:Real;  //20170505
  T2203NTSpousexfer:Real;  //20170505
  T2203NUSpousexfer:Real;  //20170505


  T2203NLCareGiver:Real;  //20170509
  T2203PECareGiver:Real;  //20170509
  T2203NSCareGiver:Real;  //20170509
  T2203NBCareGiver:Real;  //20170509
  T2203ONCareGiver:Real;  //20170509
  T2203MBCareGiver:Real;  //20170509
  T2203SKCareGiver:Real;  //20170509
  T2203ABCareGiver:Real;  //20170509
  T2203BCCareGiver:Real;  //20170509
  T2203YTCareGiver:Real;  //20170509
  T2203NTCareGiver:Real;  //20170509
  T2203NUCareGiver:Real;  //20170509

  T2203NLInfirmAmount:Real;  //20170510
  T2203PEInfirmAmount:Real;  //20170510
  T2203NSInfirmAmount:Real;  //20170510
  T2203NBInfirmAmount:Real;  //20170510
  T2203ONInfirmAmount:Real;  //20170510
  T2203MBInfirmAmount:Real;  //20170510
  T2203SKInfirmAmount:Real;  //20170510
  T2203ABInfirmAmount:Real;  //20170510
  T2203BCInfirmAmount:Real;  //20170510
  T2203YTInfirmAmount:Real;  //20170510
  T2203NTInfirmAmount:Real;  //20170510
  T2203NUInfirmAmount:Real;  //20170510

  //20180323
  T2203NLEligDepend:Real;  //20170510
  T2203PEEligDepend:Real;  //20170510
  T2203NSEligDepend:Real;  //20170510
  T2203NBEligDepend:Real;  //20170510
  T2203ONEligDepend:Real;  //20170510
  T2203MBEligDepend:Real;  //20170510
  T2203SKEligDepend:Real;  //20170510
  T2203ABEligDepend:Real;  //20170510
  T2203BCEligDepend:Real;  //20170510
  T2203YTEligDepend:Real;  //20170510
  T2203NTEligDepend:Real;  //20170510
  T2203NUEligDepend:Real;  //20170510

  //20170515  Line 5816
  T2203NLDisab:Real;  //20170510
  T2203PEDisab:Real;  //20170510
  T2203NSDisab:Real;  //20170510
  T2203NBDisab:Real;  //20170510
  T2203ONDisab:Real;  //20170510
  T2203MBDisab:Real;  //20170510
  T2203SKDisab:Real;  //20170510
  T2203ABDisab:Real;  //20170510
  T2203BCDisab:Real;  //20170510
  T2203YTDisab:Real;  //20170510
  T2203NTDisab:Real;  //20170510
  T2203NUDisab:Real;  //20170510



  TddCapGainLossDeductionIndicator: Boolean;  //20170305
  TddElmsConnection: TADConnection;
  TddElmsTable: TADTable;
  T1PropDynList:TStringList; //replaces the older array of properties  //20110131
  XmlList:TStringList; //used to create contents of Xml for a single return
  ProdOrTest:String; //during transmision 'P' ot 'T'
  OnlineMethod: String; //'EOL' or 'EOLP' during transmission
  EolPFileName : String;  //name of batch file (TED)
  T1013SubmittedFlName:String;
  TransmitDelay:Integer;
  //---
  PrevAppHandle:THandle;
  OpenedViaExplorer: Boolean;
  CurrentRoutine: String;
  ExplorerFileName:String; //to use when opening via explorer associated file
  OptimizeBtnClicked:Boolean; //in optimizenor refund sw=off
  PlanningRY        :Integer; //0 = current year, 1=next year i.e. 2007
  IncomingAssetForm : String;  //for asset conversion 2005 to 2006
  PrevBorderType: TBorderType;
  ElmsInError:TStringList;
  //ReviewMarkColor: TColor;
  //PrintShade:TColor; //RGB(245,245,245);
//  ScaleType:String;//20171031 Igor
  //FormElmArray : array of array of array of String;
  //FormElmDollar : array of array of boolean; //[Frm][Elm]
  OldScreenWidth,OldScreenHeight:Integer;
  TrFolder:String;
//  BorderShape:TShape;//20171031 igor
//  ReviewShape:TShape;//20171031 igor
  CfT4:Boolean;
  CfT5:Boolean;
  CfT3:Boolean;
  BarData:AnsiString;
  CfEfileIndic:Boolean;
  //ServerMode:Boolean;
  BlackBoxFunctionLine,
  NetSoftCode,
  ReportInvoiceDate:String;
  //20180501
  ReportInvoiceDateStart:String;
  ReportInvoiceDateEnd:String;
//  FastPrint: boolean;//20171031 igor
//  PdfPrint :Boolean;//20171031 igor
  QrLtrName:String;

  MedSum330:TMedSum330;
  MedSum331: Array[1..9] of TMedSum331;

  CanTaxAppCreated:Boolean;
  CanTaxFile1:Variant;
  CanTaxdata1:Variant;
  CanTaxClient1:Variant;

  FrmDict:TStringList;

  {timed messages}
  {DelayTime:Integer;}
  DelayMsg:String;
  BatchOper, BatchFilter : String;

  TaxByteDb:TADConnection;
  {oth options}
  ShowTreeView :Boolean;
  ShowFinancialWarning :Boolean;
  ShowConsultantOnInvoice :Boolean;
  //ShowOpenedForms : Boolean;
 // AuditList : TStringList;
  AuditEfileList:TStringList;
  Sc, ScChar,ScChange:Real;
  LogRec: TLogRec;
  AutoExpRec:TAutoExpRec;
  SelfAutoExpRec:TSelfAutoExpRec;
  AssetsBRec:TAssetsBRec;
  {c/f from prv year}
  CF_AuthRepIndic:String;  //20210227
  //CF_T1013Indic:String;
  CF_Climate2018,CF_Climate2017,   //20200208
  Cf_Invoice,CF_LPLoss,CF_AddAmtTax,CF_T1005,CF_OSHPTG,
  cf_HBPTotWithdrawal,cf_LLPTotWithdrawal,
  Cf_HBP,Cf_LLP,Cf_Don,Cf_UnclaimedRRSP,CF_CNILINC,Cf_CNILExp,cf_CNILAddInv,
  CF_AMT, CF_Earned,CF_Moving, CF_Regular,CF_CgdFarmQsb,CF_txblGain,CF_Abil,
  Cf_Ln253,CF_StudentLoan,CF_NetCapLoss,CF_StockOptionBnf,CF_EducationPrv: real;
  CF_PriorYearStudentLoan:Real; //20230311
  Cf_HBPYears,Cf_LLPYears:Integer;
  cf_HBPBalance,cf_LLPBalance:Real; cf_HBPT4RSP,cf_LLPT4RSP:Real;
  cf_HBPRepayment,cf_LLPRepayment:Real;
  {CF_FarmLoss,CF_RestrFarmLoss,Cf_NonCapLoss,CF_NetCapLoss,}
  CF_Itc, CF_GSTRebate, CF_PensAdj,CF_DeductionRoom:real;
  Cf_SpouseBirth,Cf_Area,Cf_Phone :String;
  //CF_T1013Submitted:string; //[1];      //20200313
  Cf_ReserveA,Cf_Reserve6684,Cf_ReserveB,Cf_ReserveC,Cf_ReserveD,Cf_Reserve2:Real;
  CF_Education:real;
  CF_2000InclusionRate:String;
  CF_T1DDLastYear:String;  //20140127
  Cf_RetPassword:String;
  CF_ON6115In2009 :Real;
  CF_T1163MandAdj,CF_T1163OptAdj,CF_T1273MandAdj,CF_T1273OptAdj:Real;
  CF_2013CapGainDed:Real;
  CF_CRAEmail:String;     //20151213
  PrvRate : Array[1..14,0..1] of real;  {prvndx and RY yr}
  LogoBmp :TBitmap;
  RY : Integer;  {Rate year: 0= current, 1= next year}
  FullPaint :Boolean; {True:paint all, else dara only}
  //20171216
  CCAClasses :Array[1..62] of string;  //202022
  CCARates   :Array[1..62] of string;  //202022

 (* Ret      : array[1..ReturnsLimit] of ARetData;   {data for all returns}*)
  AppDir : String;
  {AppRelease : string; //[5];}
  //CfgTbl: TADTable; {congig data base table} //rem 20150916 Igor
  FixDbName : String;

  {Somelist : create and free in any unit or usage}
  //SomeList : TstringList;

//20160907 igor >>>
//  SomeCaption,  //: string; //[60];
//  SomeFilter, //: string; //[60];
//  SomeFileMask, // : string; //[10];
//  SelectedString, //: string; //[120];
//  SomeDir,  // :string; //[70];
//  SomeFile  :String;
//  SomeLabel,  //:string; //[250];
//  SomeIndicator,  //:string; //[10];
//  SomeString:String;
//  SomeResult:Boolean;
//  SomeEMail:String;
//20160907 igor <<<

 // VList :TStringList; {stores validation rules for current form:
   //   i.e. YN,??????}
  TaxSumList : TstringList; {holds x-ref for TaxSumList}
  {Letters}
  LetterMxParagraphLines: Integer;
  LetterName : string;
  SomeLetterName:String;
  LetterReturnType : string;
  LetterParagraphName :String;

  WhiteBoxes  : Boolean;

   FrmTreeDescr  : TStringList;
   FrmTreeForms  : TStringList;

 //20152801
  //t1efile AckRec TAckRec = Record
  AckRecResultDescription : ansistring;
  ErrorDescription     : array[1..6] of array[1..12] of string; //20181802//ErrorDescription     : Array[1..6] of ansiString;

  //TddFilesDir:String; //20160126 Igor //20170222 Igor {not changed after change settings}
  TddSinsReceived: TStringList; //20160126 Igor
  TddRNo:Integer; //20160126 Igor
  PrintingFilingCopy:Boolean;//20160120

  FullPathT1Scr_LastYear: String; //Igor

  ExportForms: TExportForms; //20161229 Igor
//20170219 Igor >>>

  OldToNewLnDict: TDictionary<Integer, Integer>; //20190709 Igor
const // form Status
  PswElm = 17;
  c_LastYearElm = 32;
  c_ReturnColorElm = 50;
//20170219 Igor <<<
  SHARE_WITH_PEOPLE = 51; //20171224 Igor
  COURIER_PASSWORD = 52; //20201023 Igor  

implementation

uses SysUtils;

procedure InitExportForms; //20161229 Igor
var
  F: Integer;
  E: Integer;
  procedure AddForm(AFormName: String);
  begin
    inc(F);
    SetLength(ExportForms, F + 1);
    ExportForms[F].FormName := AFormName;
    E := -1;
  end;
  procedure AddElement(AElementNo: Integer; ADescription: String);
  begin
    inc(E);
    SetLength(ExportForms[F].ExportElements, E + 1);
    ExportForms[F].ExportElements[E].ElemNo := AElementNo;
    ExportForms[F].ExportElements[E].Description := ADescription;
  end;
begin
  F := -1;
  AddForm('INFO');
  AddElement(	2	,'First Name');
  AddElement(	4	,'Spouse SIN');
  AddElement(	5	,'Last Name');
  AddElement(	6	,'Mailing Address: Street No. Street name');
  AddElement(	8	,'Address - C/O');
  AddElement(	10	,'Address – City');
  AddElement(	14	,'Address – Province/Terr.');
  AddElement(	15	,'Address - Postal Code');
  AddElement(	22	,'Address – Apt. No');
  AddElement(	24	,'Date of Death');  //20230313
  AddElement(	38	,'Printing – Print Discounter’s Consent Form (T1153)');
  AddElement(	46	,'E-Filing – Is this Efiled return?');
  AddElement(	48	,'Printing – Print ‘In care of preparer’s address’ on T1 page1');
  AddElement(	51	,'Printing – Print discounter’s number on T1 page 1');
  AddElement(	54	,'Phone – Home – Area');
  AddElement(	55	,'Phone – Home – Phone');
  AddElement(	64	,'Contact Information of taxpayer/client – Email Addresses – For CRA');
  AddElement(	68	,'Address – P.O. Box');
  AddElement(	71	,'Phone – Work – Area');
  AddElement(	72	,'Phone – Work – Phone');
  AddElement(	74	,'Phone – Cell – Area');
  AddElement(	75	,'Phone – Cell – Phone');
  AddElement(	96	,'Preparer Address NOA and/or Refund');
  AddElement(	100	,'Compensation for return preparation – Prepared for compensation');
  AddElement(	102	,'Compensation for return preparation – Discounted (Under the Discounting ACT)');
  AddElement(	105	,'Pre-assessment review contact (CW) – Contact preparer by Mail');   //20170106 CON
  AddElement(	107	,'Refund – Transfer Refund to Next Year’s Instalment Account');
  AddElement(	113	,'Phone – Home – Extension');
  AddElement(	114	,'Phone – Work – Extension');
  AddElement(	115	,'Phone – Cell – Extension');
  AddElement(	134	,'Post-assessment review contact – Contact Preparer by mail');
  AddElement(	140	,'Contact Information of taxpayer/client – Email Addresses – Personal');
  AddElement(	163	,'Address – RR');


  AddForm('CDE');
  AddElement(	1	,'Refund Examination Indicator');
  AddElement(	2	,'GSTHST Return Indicator');
  AddElement(	3	,'Working Income Tax Benefit Indicator');
  AddElement(	4	,'Current Year Return Indicator');
  AddElement(	5	,'Bankrupt Indicator');
  AddElement(	9	,'Refund SetOff code');   //20190404
  AddElement(	10	,'CDE - Balance Owing Amount');
  AddElement(	13	,'CDE - There are unfiled returns for this client.');
  AddElement(	43	,'CDE - Reassessment in progress (if not blank)');  //20190311
  AddElement(	53	,'CDE - Reassessment for year');

  AddForm('T1');
  AddElement(	430	,'T1 Jacket – Refund[484]');
  AddElement(	431	,'T1 Jacket – Balance Owing [431]');

  AddForm('INV');
  AddElement(	5	,'Invoice – Forms Charged – Total Form Charges ($)');

  AddForm('INVFORMS');
  AddElement(	5	,'Total Forms Charges');

  AddForm('INVOICE');
  AddElement(	222	,'Invoice – Invoice Total');
  AddElement(	221	,'Invoice – GST/HST');
  AddElement(	219	,'Invoice – Subtotal');
  AddElement(	210	,'Invoice – Invoice No.');

  AddForm('STATUS');
  AddElement(	1	,'Name');
  AddElement(	2	,'File Name');
  AddElement(	3	,'SIN');
  AddElement(	4	,'Preparation Status  (Numeric Field)');
  AddElement(	5	,'Created – By');
  AddElement(	6	,'Date Created');
  AddElement(	7	,'Time Created');
  AddElement(	11	,'Last Update – By');
  AddElement(	12	,'Last Updated – Date');
  AddElement(	15	,'Efile Status');
  AddElement(	22	,'Ack Received Date');
  AddElement(	23	,'Ack Received Time');
  AddElement(	31	,'Batch Ack');
  AddElement(	37	,'Transmission Number');

  AddForm('T1132');
  AddElement(	5	,'T1132 - Field 1');
  AddElement(	9	,'T1132 - Business Name');
  AddElement(	10,'T1132 - Mailing Address');
  AddElement(	13,'T1132 - City');
  AddElement(	14,'T1132 - Province');
  AddElement(	15,'T1132 - Postal Code');
  AddElement(	16,'T1132 - Country');
  //20170219 Igor
  AddForm('T4#1');
  AddElement( 3   ,'CPP');
  AddElement( 2   ,'Employment');
  //20170219 Igor <<<
end;

procedure Done;
begin
(* How are these done in other AppIds???
*)
  FreeAndNil(T1PropDynList);
  FreeAndNil(XmlList);
  FreeAndNil(ElmsInError);
  //FreeAndNil(BorderShape);
  //FreeAndNil(ReviewShape);
  FreeAndNil(FrmDict);
  FreeAndNil(AuditEfileList);
  FreeAndNil(LogoBmp);
//  FreeAndNil(SomeList); //!!!??? //20160907 Igor
  FreeAndNil(TaxSumList);
  //FreeAndNil(AffectedList);
  //FreeAndNil(FormObjects);
  //FreeAndNil(CplList);
  //FreeAndNil(OverList);
  //FreeAndNil(ReviewList);
  FreeAndNil(ExtractedAutoList);
  FreeAndNil(ExtractedCCAList);
//  FreeAndNil(DataDictList); //20170410 Igor
  //FreeAndNil(FList);
  FreeAndNil(FLastYearList);
  FreeAndNil(FeesList);
  //FreeAndNil(FieldList);
  FreeAndNil(FrmTreeDescr);
  FreeAndNil(FrmTreeForms);
  FreeAndNil(TddSinsReceived); //20170512 Igor
  If Assigned(OldToNewLnDict) then OldToNewLnDict.Free; //20190709 Igor
end;

initialization
//create all lists only once?
  InitExportForms; //20161229 Igor
finalization
  Done;
end.
