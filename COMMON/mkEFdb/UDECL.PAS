unit Udecl;

{=============================================================}
interface
{=============================================================}

uses WinTypes, classes, DBTables, Graphics;

const

  AppName = 'EFCOM';
  AppTitle = 'Visual Tax - '+ AppName;
  ClientsTable = 'CLIENTS.DBF';
  DefFontName =  'Arial';
Type
 ACfgRec = Record
   Dir_Cur      : String[40];
   Dir_Deflt    : String[40];
   Dir_LastYr   : String[40];
   Dir_PrvLYr   : String[40];
   Dir_Train    : String[40];
   Dir_Sample   : String[40];

   Prp_Name     : String[30];
   Prp_Street   : String[30];
   Prp_City     : String[30];
   Prp_Prov     : String[2];
   Prp_Postal   : String[8];
   Prp_Countr   : String[8];
   Prp_Area     : String[3];
   Prp_Tel      : String[8];
   Prp_Fax      : String[8];
   Prp_DiscNo   : String[10];
   Prp_GSTNo    : String[10];
   Prp_Bill     : String[1];
   Prp_VSFee    : Integer;
   Prp_SFee     :Integer;
   Prp_AFee     :Integer;
   Prp_CFee     :Integer;
   Prp_VCFee    :Integer;
   Prp_Kstrk    :Real;
   Prp_Hour     :Real;
   Prp_Elect    :Boolean;
   Prp_EfRepr   :Boolean;
   Prp_Dates    :Boolean;

   Nfl_Prov     : String[2]; {New File defqaults}
   Nfl_City     : String[20];
   Nfl_Disced   : String[1];
   Nfl_Efile    : Boolean;

   Ef_PrepNo   : String[30];
   Ef_TransNo  : String[30];
   Ef_PsWord   : String[30];
   Ef_ProdNo   : String[12];
   Ef_TestNo   : String[12];
   Ef_DataDir  : String[30];
   Ef_EncDir   : String[30];
   Ef_DialNo   : String[13];
   Ef_NUI      : String[20];
   Ef_NuiPass  : String[10];
   Ef_Port     : Integer;
   Ef_Baud     : Integer;
   Ef_Protocl  : String[1];
   Ef_Centre   : String[2];
   Ef_PrepId   : String[10];
   Ef_PrnPort  : Integer;
   Ef_Carrier  : String[10];
   Ef_Stage    : String[10];

   Prn_Shade   : Boolean;
   Prn_Head    : Boolean;
   Prn_NameH   : Boolean;
   Prn_SinH    : Boolean;
   Prn_DateH   : Boolean;
   Prn_Disclm  : String[80];
   Prn_Logo    : Boolean;
   Prn_logoln  : integer;
   Opr_Recalc  : Boolean;
   Opr_Close   : Boolean;
   Opr_FPres   : Integer;
  end;


 (*
 Type
 ACfgRec = Record
   Dir_Cur      : String[40];
   Dir_Deflt    : String[40];
   Dir_LastYr   : String[40];
   Dir_PrvLYr   : String[40];
   Dir_Train    : String[40];
   Dir_Sample   : String[40];

   Prp_Name     : String[30];
   Prp_Street   : String[30];
   Prp_City     : String[30];
   Prp_Prov     : String[2];
   Prp_Postal   : String[8];
   Prp_Countr   : String[8];
   Prp_Area     : String[3];
   Prp_Tel      : String[8];
   Prp_Fax      : String[8];
   Prp_DiscNo   : String[10];
   Prp_GSTNo    : String[10];
   Prp_Bill     : String[1];
   Prp_VSFee    : Integer;
   Prp_SFee     :Integer;
   Prp_AFee     :Integer;
   Prp_CFee     :Integer;
   Prp_VCFee    :Integer;
   Prp_Kstrk    :Real;
   Prp_Hour     :Real;
   Prp_Elect    :Boolean;
   Prp_EfRepr   :Boolean;
   Prp_Dates    :Boolean;

   Nfl_Prov     : String[2]; {New File defqaults}
   Nfl_City     : String[20];
   Nfl_Disced   : String[1];
   Nfl_Efile    : Boolean;

   Ef_PrepNo   : String[30];
   Ef_TransNo  : String[30];
   Ef_PsWord   : String[30];
   Ef_ProdNo   : String[30];
   Ef_TestNo   : String[30];
   Ef_DataDir  : String[30];
   Ef_EncDir   : String[30];
   Ef_DialNo   : String[13];
   Ef_NUI      : String[10];
   Ef_NuiPass  : String[8];
   Ef_Port     : Integer;
   Ef_Baud     : Integer;
   Ef_Protocl  : String[1];
   Ef_Centre   : String[2];
   Ef_PrepId   : String[10];
   Ef_PrnPort  : Integer;

   Prn_Shade   : Boolean;
   Prn_Head    : Boolean;
   Prn_NameH   : Boolean;
   Prn_SinH    : Boolean;
   Prn_DateH   : Boolean;
   Prn_Disclm  : String[80];
   Prn_Logo    : Boolean;
   Prn_logoln  : integer;
   Opr_Recalc  : Boolean;
   Opr_Close   : Boolean;
   Opr_FPres   : Integer;
  end;
 *)
 Type
  AUserProfile = Record
   M_Office     : String[4];
   Branch       : String[2];
   Prep_Intls   : String[2];
   Login_Id     : String[10];
   Pswd         : string[10];
   Auth_Level   : string[2];
   Inv_No       : integer;
   Prep_Name    : String[20];
   Tax_dir      : String[40];
   EFile_dir    : String[40];
   CODE         : String[4];
   CrProfile    : Boolean;
   CrReturn     : boolean;
   PrReturn     : Boolean;
   PrReport     : boolean;
   PrInvoice    : Boolean;
   MkAppoint    : boolean;
   CrRTU        : boolean;
   EFile        : boolean;
   MkPay        : boolean;
   Upload       : Boolean;
  end;

 (*
  MxT2124 = 1;
  MxT2032 = 1; MxT2042 = 1; MxT2121 = 1;MxT776 = 1;
  MxT4 =1;
  MxT4A =1;
  MxT4AP =1;
  MxT4RSP =1;
  MxT4RIF =1;
  MxT4PS =1;
  MxT4F =1;
  MxT4AOAS =1;
  MxT4U =1;
  MxT3 =1;
  MxT5 =1;
  MxT5007 =1;
  MxT5013 =1;
  MxFPENS =1;



  ReturnsLimit = 50;  FormsLimit   = 300; MaxBuckets = 5000;
  LnLowBound   = 1;  LnHighBound  = 600;
  LabelProperties = 9;  LineProperties  = 8;  FieldProperties = 12;
  LabelsLimit  = 200;  FieldsLimit  = 250;  LinesLimit   = 200;

  FirstFormName = 'PAGE_1';
  BoxHeight    = 15; {height of edit box}
  DefFontName =  'Arial';
  RepaintSw    : Boolean = True;
  CreatingNew  : Boolean = True;
  ClosingReturn : Boolean = False;
  Delimiter    : String[1] = Chr(127);  {in file i/o between variables}
  KeyWDelimiter1 : String[1] = '{';
  KeyWDelimiter2 : String[1] = '}';
  KeyWDelimiter3 : String[1] = '^';

  Relationships : Array[1..12] of string[12] =
   ('Child','Daughter','Son','Parent','GrandParent',
   'GrandChild','Brother','Sister','Niece','Nephew',
   'Aunt','Uncle');

  MarDescr : Array[1..6] of string[13] =
   ('Married','Common-law','Widowed','Divorced',
    'Separated','Single');

  Titles : Array[1..6] of string[5] =
   ('Mr.','Mrs.','Miss','Dr.','Ms','');
  PrvShort : Array[1..13] of string[2] =
   ('NF','PE','NS','NB','QC','ON','MB','SK','AB','BC','NT','YT','ZZ');
  PrvRate : Array[1..13] of real =
   (0.69,0.595,0.585,0.63,0.00,0.48,0.52,0.50,0.455,0.51,0.50,0.45,0.52);

 PrvLong : Array[1..13] of string[22] =
   ('NEWFOUNDLAND','PRINCE EDWARD ISLAND','NOVA SCOTIA',
    'NEW BRUNSWICK','QUEBEC','ONTARIO','MANITOBA',
    'SASKATCHEWAN','ALBERTA','BRITISH COLUMBIA',
    'NORTHWEST TERRITORIES','YUKON TERRITORY','NON RESIDENT');

  EFStatusCodes : array [0..4] of string[2] =
   ('00','01','02','03','04');
  EFStatusDescr : array [0..4] of string[20] =
   ('EF not started','EF Ready For RTU','EF Accepted','EF Rejected','EF Waiting Ack');

  EFQueries : array [0..4] of string[8] =
   ('Efnostrt','EFReady','EFAccept','EFReject','EFRtu');

  PRPStatusCodes : array [0..7] of string[2] =
   ('00','01','02','03','04','05','06','07');
  PRPStatusDescr : array [0..7] of string[20] =
   ('W.I.P.','Not Started','Missing Data','Printed','Ready To Print', 'Review Stage',
     'Finished','Re-assessed');
  PRPQueries : array [0..7] of string[8] =
   ('WIP','NotStart','MissData','Printed','ReadyPr','InReview',
    'Finish','Reasses');


 type    {1=line,2=rectangle, etc}
  TDrawingTool = (dtLine,dtRectangle,dtEllipse,dtRoundRect);
 type
 {Define a record of data for each color}

   PColorList  = ^AColorRec;
   AColorRec   = record
     ColorRef       : Longint;
     ColorInUse     : boolean;
 end;

 type
 {Define a record of data for each loaded form and a pointer to it}
  {a Pointer to form record}
   PFormList  = ^AFormRec;
   AFormRec   = record
     FormHandle    : THandle;
     FormNo        : Integer;
     FormName      : String[10];
     RetNo         : Integer;
     FormStatus    : Integer;
     TabNo         : Integer;
     FieldId       : Integer;
 end;

 Type           {all DataDict names}
  PDataDictList      = ^ADataDict;
  ADataDict   = Record
   Name      : String[40];
   FormName  : String[10];
   Elm       : Integer;
   LineNo   : integer;
 end;

 Type          {all forms offerd in the Tax program}
   PFList      = ^AFRec;
   AFRec       = Record
     FormNo       : Integer;
     FormName     : string[8];
     FormInst     : string[3];   {#nn}
     FormMxInst   : string[3];
     FormDescr    : string[65];
     FormMxPg     : integer;
     FormAbrev    : String[18];
     FormRlNm     : String[9];
     FormShow      : Boolean;
     FormType     : String[2];
     FormFields   : integer;
     IsSlip       : Boolean;
     Preload      : Boolean;
     DataIndic    : String[20];
     WhiteBoxes   : Boolean;
     ShowFlag     : Boolean;
     ShowHdr      : Boolean;
     PrnSeq       : String;
     Fee          : String;
     FeeAddItem   : String;
 end;

 type
  {Define a record layout for data of A return and A pointer to it}
  PRetList  = ^ARetRec;
  ARetRec    = record
    RetNo         : Integer;
    RetColorRef   : Longint;
    {RetSin        : String[9];}
 end;

type
POverList     = ^AOverRec;
AOverRec   = Record
  RetNo      : Integer;
  FormNo     : Integer;
  OverrideSw : Boolean;
  FieldId   : Integer;
  Value      : String[60];
end;

type
PReviewList     = ^AReviewRec;
AReviewRec   = Record
  RetNo      : Integer;
  FormNo     : Integer;
  ReviewSw   : Boolean;
  FieldId    : Integer;
  Symbol     : integer;
end;



{--------------- Data storage definition---------}

type
RetPtr = ^ARetData;
ARetData    = Record
   CalcStatus   : Boolean;
   Changed      : boolean;
   MarStatus    : Integer;
   SpouseIncome : Real;
   Province    : String[2];
   PrvTaxBfrT2036 :Real;
   Age         : Integer;
   CppMonths   : Integer;
   PartYear    : Real;
   Deceased    : Boolean;
   Bankrupt    : Integer; {0=no bankcruptcy, 1-pre 2=Post 3=trustee}
   Balance     : Real;
   Frm         : Array[0..FormsLimit] of TStringList; {max 150 forms}
   FrmHasData  : Array[0..FormsLimit] of boolean;
   Ln          : Array[LnLowBound..LnHighBound] of real;
   SourceDataDir : string[30];  {dir it came from}
   SourceFlName : string[12];  {file name it came from via readreturn}
  { from ClienTtable}
   EFStatus    : String[2];
   PrpStatus   : string[2];
   RTuFile     : String[12];
   AckFile     : String[12];
   Notes       : string[80];
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
   T4NorthA, T4NorthB : real;
   T4UiWeeks : integer;T4PastRPPW :real;T4PastRPPWNot :real;

   T4AOthInc,T4APens,T4ARPP,T4APAdj,T4AOthEmpl,T4ADon,T4ATax,
   T4ANorthA, T4ANorthB : real;T4APastRppW : real;T4APastRppWNot : real;

   T4RIFOthInc,T4RIFPens: real;

   T4APOAS,T4APCppBnf,T4APDisabBnf,T4APTax : real;
   T4APCppMonths :integer;

   T3OthInc,T3Pens,T3ITC,T3Xii,T3ElgblQSB,T3ElgblQFP,T3ElgblOTH,
   T3NonElgblGains,T3Dividends,
   T3FNonBusInc1,T3FNonBusInc2,T3FNonBusInc3,
   T3FNonBusTax1,T3FNonBusTax2,T3FNonBusTax3,
   T3FBusInc1,T3FBusInc2,T3FBusInc3,
   T3FBusTax1,T3FBusTax2,T3FBusTax3,
   T3Farmelgbl,T3OthElgbl,T3QFPElgbl :real;

   LaborSpCost,LaborSpFedCredit,LaborSpPrvCredit:real;
   LaborSpOnEo,LaborSpBcEsop:real;

   T5013OthInc,T5013ITC,T5013ElgblQSB,T5013ElgblQFP,T5013ElgblOTH,
   T5013NonElgblGains, T5013ActDiv,T5013CarrCharg,
   T5013CDE,T5013CEE,T5013COGPE,T5013FDE,T5013RecapDepl,
   T5013FedPol, T5013ProvPol,T5013Don,T5013Gifts,T5013Abil,
   T5013FNonBusInc1,T5013FNonBusInc2,T5013FNonBusInc3,
   T5013FNonBusTax1,T5013FNonBusTax2,T5013FNonBusTax3,
   T5013FBusInc1,T5013FBusInc2,T5013FBusInc3,
   T5013FBusTax1,T5013FBusTax2,T5013FBusTax3,
   T5013Interest, T5013Tax,
   T5013ResAllow,T5013FInterest:real;
   {T101/102}
   T101CEE,T101COGPE,T101AllowCEE,T101AllowCOGPE: real;

   T102CEE,T102CDE,T102COGPE,T102AllowCEE,
   T102AllowCDE,T102AllowCOGPE,T102PShipInc: real;

   T5Interest,T5Pens,
   T5NonElgblGains,T5Dividends,
   T5FNonBusInc1,T5FNonBusInc2,T5FNonBusInc3,
   T5FNonBusTax1,T5FNonBusTax2,T5FNonBusTax3 : real;
   T4RspIncome, T4RspOthDed, T4RspTax : real;
 end;

  {-----------   FORM DEFINITION -------------------}

type
 PHeaderList     = ^AHeaderRec;
 AHeaderRec  = record
    NumbLabels   : integer;
    NumbLines    : integer;
    NumbFields   : integer;
    GapFields    : Integer;
    FormHeight   : integer;
    Bucket       : Array[1..MaxBuckets] of integer;
  end;


 type
 PLabelList  = ^ALabelRec;  {list of pointers to records}
 ALabelRec = record
   Left       : integer;
   Top        : integer;
   LabelId    : Integer;
   FontSize   : integer;
   FontId     : integer;   {0=default font, 1=System font}
   FontStyle  : integer;   {0=normal,1=Italic}
   FontColor  : integer;   {0=normal, 1=Bold, 2:bold/colored, 3:reversed}
   SectionId  : Integer;    {0=no section label, 1+section label}
   Visible    : integer;   {1=Visible, 0=not visible}
 end;

 type
 PLblTextList  = ^ALblTextRec;  {list of pointers to records}
 ALblTextRec = record
   Text    : string;
 end;

 type
   PLineList  = ^ALineRec;  {list of pointers to records}
   ALineRec   = record
     X1     : integer;
     Y1     : integer;
     Width  : integer;
     Height : integer;
     Pen    : integer;
     Brush  : Integer;    {0 := White, 1=clGray 2=clBlack}
     ShapeStyle : Integer;  {0=Rectangle, 1=Circle, 2,3,4,5= Triangle}
     Visible: integer;
 end;

 type
    PFieldList  = ^AFieldRec;  {list of pointers to records}
    AFieldRec  = record
    Left        : integer;
    Top         : integer;
    MaxLength   : integer;
    FieldId     : integer;  {A field no}
    TabNo       : integer;
    TabStop     : integer;  {1 = Yes   0=no}
    Tag         : integer;  {from tag: 0=Alphanumeric, 1=Integer 2=2 dec}
    Width       : integer;
    Visible     : integer;  {1=visible, 0=not visible}
    HelpContext : integer;  {Form id to link to}
    BoxStyle    : integer;
      {0=Underline, 1=Bold Underline 2= Double Line, 3=Box, 4=bold box,5=checkbox}
    FontStyle   : integer;  {0=Normal  1=bold }
   end;

  {Tax constants}
  Type
   ConstantsRec = Record
   FullYear          : Integer;
   MaxAgeAmount      : Integer;
   AgeBaseAmount     : Integer;
   AgeNIThreshHold   : LongInt;
   BasicPersonalAmount : Integer;
   DisabilityAmount : Integer;
   MedicalLimit : Integer;
   MaxSpousalAmount : Integer;
   EducPerMonth     : Integer;
   EducLimit        : Integer;
   DonPercent       : Integer;
   SpousalBase : Integer;  {No claim above this base}
   DependBase : Integer;  {No claim above this base}
   MaxDependAmount : Integer;
   MaxCpp : Real;
   CPPRate : Real;
   MaxCppPensionable : LongInt;
   BasicCppExemption : Integer;
   MaxCppEarnings : Integer;
   RSPLimit : Integer;
   UIRate : Real;
   MaxUI52 : Real;
   MaxUI53 : Real;
   MaxUI54 : Real;
   MaxUIEarn52 :Real;
   MaxUIEarn53 :Real;
   MaxUIEarn54 :Real;
   UIBaseRep : Real;
   OASBaseRep : Real;
  end;
*)
 {============================== VARIABLES ======================}
 var
  AppDir{,TaxPgmDir} : String[66];   AppVersion : string[5];
  Licensee : String[40];  LicenseLevel : String[5];
  BatchOper : String[20]; BatchFilter : String[20];
  CfgTbl: TTable; {congig data base table}
  CfgRec : ACfgRec;

  SomeList : TstringList; SomeCaption: String[60]; SomeFilter: String[60];
  SomeFileMask : String[10];  SelectedString : String[120];
  SomeDir :String[60];

  User : AUserProfile;
  ValidUser :Boolean;
  MasterPswd : string[10]; {used in setting up new users}
  UserName : String[10];
 (*
  CouplingSw   : Boolean;
  AppYear :String[4];
  LogoBmp :TBitmap;
  RY : Integer;  {Rate year: 0= current, 1= next year}
  FullPaint :Boolean; {True:paint all, else dara only}
  XRefFormName, XRefFormNo : TStringList; {holds sorted xref of formname and FormNo}
  XRefMultName, XRefMultNo : TStringList; {holds sorted xref of multiple formname and FormNo}

  LetterType :String[6];  {Cover or Other:if Cover it calcs}
  CCAClasses :Array[1..50] of string[4];
  CCARates   :Array[1..50] of string[3];

  AbortSw :Boolean; {progress on printing etc}
  PauseSw :Boolean; {pause printing printing etc}
  InfoMsg : String[60];  {For messages on MDI/InfoOn/InfoOff}
  ActiveHandle : THandle;
  LinkSw : Boolean; LinkFormNo : Integer; LinkField :Integer;
  LinkTabNo : integer;


  FixDbName : String[12];

  ShowFieldIdSw : Boolean;

  {Somelist : create and free in any unit}
  VList :TStringList; {stores validation rules for current form:
      i.e. YN,??????}
  TaxSumList : TstringList; {holds x-ref for TaxSumList}
  AffectedList : TStringList; {holds affected schedules in calcs}
  User : AUserProfile;
  Ret : Array[0..ReturnsLimit] of RetPtr;
  Constant : Array[0..1] of ConstantsRec;
  {Letters}
  LetterMxParagraphLines: Integer;
  LetterName : string;
  LetterReturnType : string;
  LetterParagraphName :String;


  DD,MM,YYYY : integer; {returned by Calndr}

  TV    : Array[1..FieldsLimit] of real;  {temp variable for numeric form fields}
  MDIHandle : THandle; {used to update the status line}
  ToolBarSw,StatusBarSw,FormsBarSw: Boolean;
  OriginalMemory : LongInt;
  MemNow         : LongInt;
  DrawingTool  :  TDrawingTool;
  MaintSw      : Boolean;  {not used}
  RetInMem, RetNo,ErrorCount,SeriousErrorCount,WndHeight,LineHeight : Integer;

  {-- current form properties ---}
  FormNo       : Integer;
  FormName     : string[10];
  PrevFormName : string[10];
  PrevReturnNo : Integer;
  FormDescr    : string[50];
  FormHandle   : THandle;
  FormHeight   : Integer;
  FormOvrSw    : Boolean;
  NumbLabels  : Integer;
  NumbLines   : Integer;
  NumbFields  : integer;
  GapFields   : Integer;
  FormPtr     : pointer;
  TextPtr     : PChar;
  WhiteBoxes  : Boolean;
  BucketArray : Array[1..300] of integer;
  {  -- current Field properties --}
  FieldId      : integer;
  TabNo       : integer;
  OpenAtFieldId : integer;
  OpenAtTabNo : integer;

  FormObjects : TStringList;  {list of all formnames & associated form object}
 {List of Returns opened during operation}
   RetList   : TList;     {behaves like base object TList}
   RetRec    : PRetList;  {define A pointer to A return record}
  {List of overrides for all returns}
   OverList   : TList;     {behaves like base object TList}
   OverRec    : POverList;  {define A pointer to A return record}
  {List of Review marks}
   ReviewList   : TList;     {behaves like base object TList}
   ReviewRec    : PReviewList;  {define A pointer to A return record}

  {list of forms opened during operation}
   FormList  : TList;
   FormRec   : PFormList;
   {List of DataDict }
   DataDictList    : TList;
   DataDictRec     : PDataDictList;
  {List of all predefined forms in program}
   FList     : TList;
   FRec      : PFList;
  {List of predefined colors}
   ColorList     : TList;
   ColorRec      : PColorList;
  {header of active form}
   HeaderList  : TList;
   HeaderRec   : PHeaderList;
  {list of labels of active form}
   LabelList   : TList;
   LabelRec    : PLabelList;
  {list of label text of active form}
   LblTextList   : TList;
   LblTextRec    : PLblTextList;
  {list of lines of active form}
   LineList    : TList;
   LineRec     : PLineList;
  {list of fields of active form}
   FieldList   : TList;
   FieldRec    : PFieldList;
  *)

implementation

end.
