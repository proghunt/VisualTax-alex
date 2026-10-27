unit TF_2026Declare;

interface

uses
  WinTypes, ComCtrls, Controls, Classes, Graphics, ExtCtrls, vtMulti, vtShared,
  VtEditBox;

const //update every release
  isDraft: Boolean = FALSE; //2026019 True; //20251217  False; //True;  //20250119
  PrintShade = clSilver;  //20170122
  CertificationMode = False; //True; //False; //True; //False;   //20170123
  //If true: Print T3 jacket without province, the provincial T3ON etc by selecting a province
   //20150623
  AppYear = '2025';
  AppYearInt = 2025;
  AppRelease = '0.0';

  AppUpdateDate ='2026/08/15'; //'2025/12/17'; //'2024/03/18'; //'2024/03/15'; //'2024/01/11'; // '2023/10/28'; //20231028 //'2023/04/03';  //20231223

  TRYear = '2025';
  LimitedVersionDir = 'C:\VT-TFData25'; //20161112  con

  FormsDBLite = 'TFScr.DB'; //20150918 Igor
  FormsTableLite = 'TFScr';    //20150918 Igor

  FormsCfgDBLite = 'TFCFG.db';  // 20150923 Igor
  FormsCfgTableLite = 'TFCFG';     // 20150923 Igor

  FormsFeesDBLite = 'Fees.DB'; //20150923 Igor
  FormsFeesTableLite = 'Fees';    //20150923 Igor
  T1134_FA_LIST = 52; //20260817 Alex

const
  //RecentFlName='Recent.txt';
  BlackBoxDir='C:\temp';
  //OptionsFlName='Options.txt';
  //YesNoSet =['Y','y','N','n'];

  AppName = 'TF'; //-FORMS';
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

  FirstFormName = 'T3010'; //'T3010';   //20180212 instead if T3 or T3010
  BoxHeight    = 15; {height of edit box}
  DefFontName =  'Arial';
  RepaintSw    : Boolean = True;
  ClosingReturn : Boolean = False;
  Delimiter    : String [1] = Chr(127);  {in file i/o between variables}

  KeyWDelimiter1 : String [1] = '\';
  KeyWDelimiter2 : String [1] = '\';
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
   ('W.I.P.','Not Started','Missing Data','Printed','Ready To Print', 'Review Stage',
     'Finished','Re-assessed');
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


 {============================== VARIABLES ======================}

var {Lists of common types }
  xx,yy:Real;  //20240519  //20260423
  ss:String; //for general use  //20260906
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
  T5013PartnersList: TstringList; //20260909 Con
  OpenedFormsList: array of string; //20260909 Alex

var
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

 // Var ONToni: Array[0..1] of TOnToniRates;
 // Var BCToni: Array[0..1] of TBCToniRates;
 // Var FedRates: Array[0..1] of TFederalRates;
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

  CCAClasses :Array[1..51] of string; //[4];  //20180211 from 50
  CCARates   :Array[1..51] of string; //[3];  //20180211 from 50

  AppDir, //: string; //[66];   {AppVersion : string; //[5];}
  BatchOper, //: string; //[20];
  BatchFilter, //: string; //[20];
  FileDescr,  // :string; //[60];
  FixDbName: String; //20170328 igor

  VList :TStringList; {stores validation rules for current form:
      i.e. YN,??????}
  TaxSumList : TstringList; {holds x-ref for TaxSumList}
  NewForm : Boolean;


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
  FullPathTFScr_LastYear: String; //20160629 Igor

  //20170225 Igor >>>
const  //Status form elements
  PswElm = 25;
  c_LastYearElm = 32;
  c_ReturnColorElm = 50;
  c_FileDescription = 51; //20180314 Igor
  SHARE_WITH_PEOPLE = 52; //20190228 Igor
//20170225 Igor <<<
implementation

uses SysUtils;

procedure Done;
var
  i: integer;
begin
//see Common.InitLists
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

