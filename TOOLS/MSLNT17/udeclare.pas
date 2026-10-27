unit Udeclare;

{=============================================================}
interface
{=============================================================}

uses WinTypes, classes, DBTables, Graphics;

const
  AppYear = '2016'; //20161102 //20151221 '2014';   //20140310
  AppName = 'MCLNT'; //20161102  'T-FORCE 1912'; {AppVersion = '0';} {replaced by T1Parms}
  AppTitle = 'Visual Tax - '+ AppName;   {for win caption}
  ClientsTable = 'CLIENTS.DBF';
  {Capacity}

  ReturnsLimit = 20;  FormsLimit   = 500; MaxBuckets = 5000;
  {LnLowBound   = 1;  LnHighBound  = 600;}
  LowAvlbleAlloc = 21; HiAvlbleAlloc = 45;
  LabelProperties = 9;  LineProperties  = 8;  FieldProperties = 13;
  LabelsLimit  = 200;  FieldsLimit  = 300;  LinesLimit   = 200;

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

  Titles : Array[1..5] of string[5] =
   ('','Mr','Mrs','Miss','Dr');
  //20121126
  PrvShort : Array[1..14] of string[2] =
   ('NL', 'PE', 'NS', 'NB', 'QC',  'ON',  'MB',  'SK',  'AB',   'BC',  'NT',  'YT',  'ZZ',  'NU');

  GSTRate : Array[1..14] of String[5] =
   ('13', '5',  '15', '13',  '0',  '13',  '5',    '5',   '5',   '12',   '5',   '5',   '0',   '5');

  QuickGSTRate : Array[1..14] of String[5] =
  ('8.8', '1.8','10.4','8.8', '0',  '8.8', '1.8', '1.8', '1.8', '8',   '1.8',  '1.8',  '0',  '1.8');
  {current year}
  PrvRate : Array[1..13] of real =
   (69,59.5,59.5,64,0,56,52,50,45.5,52.5,45,50,52);
  {next year}
  PrvRate1 : Array[1..13] of real =
      (69,59.5,59.5,64,0,48,52,50,45.5,52.5,45,50,52);

  PrvLong : Array[1..13] of string[22] =
   ('NEWFOUNDLAND','PRINCE EDWARD ISLAND','NOVA SCOTIA',
    'NEW BRUNSWICK','QUEBEC','ONTARIO','MANITOBA',
    'SASKATCHEWAN','ALBERTA','BRITISH COLUMBIA',
    'NORTHWEST TERRITORIES','YUKON TERRITORY','NON RESIDENT');

  PRPStatusCodes : array [0..7] of string[2] =
   ('00','01','02','03','04','05','06','07');
  PRPStatusDescr : array [0..7] of string[20] =
   ('W.I.P.','Not Started','Missing Data','Printed','Ready To Print', 'Review Stage',
     'Finished','Re-assessed');
  PRPQueries : array [0..7] of string[8] =
   ('WIP','NotStart','MissData','Printed','ReadyPr','InReview',
    'Finish','Reasses');

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


 Type
 ACfgRec = Record
   Dir_Cur      : String[30];
   Dir_Deflt    : String[30];
   Dir_LastYr   : String[30];
   Dir_Train    : String[30];
   Dir_Sample    : String[30];

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
   Prp_TaxCen   :String[20];

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
   Prn_Disclm  : String[60];
   Prn_Logo    : Boolean;
   Prn_logoln  : integer;
   Prn_T5AdjX  : Real;
   Prn_T5AdjY  : Real;
   Prn_SAdjX   : Real; {summary}
   Prn_SAdjY   : Real;

   Opr_Recalc  : Boolean;
   Opr_Close   : Boolean;
   Opr_FPres   : Integer;
   Opr_CopPrv  : String[1];
   Opr_ValT4   : String[1];
   Opr_ValNet  : String[1];
   Opr_CppTol  : Real;
   Opr_EITol   : Real;
   Opr_ShdChr  : Integer;
   Opr_T4SER   : LongInt;
   Opr_T4ASER  : LongInt;
   Opr_EIExmt  : Real;
   Opr_T5Auto  : String[1];
   Opr_CPPRat  : Real;
   Opr_AutoPe  : String[1];
  end;


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
    { FormDescr    : string[50];}
     FormMxPg     : integer;
     FormAbrev    : String[50];
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
    {RetName       : string[30];}
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
   DaysInYear  : Integer;
   CalcStatus  : Boolean;
   Changed     : boolean;
   CouplingSw  : Boolean;
   OntAlloc    : Real;
   Province    : String[2];
   {
   TrustType   : TTrustTypes;
   TrustYear   : String[4];
   }
   PartYear    : Real;
   {Bankrupt    : Boolean;}
   Balance     : Real;
   Frm         : Array[0..FormsLimit] of TStringList; {max 150 forms}
   FrmHasData  : Array[0..FormsLimit] of boolean;
   {Ln          : Array[LnLowBound..LnHighBound] of real;}
   {available for allocations}
   {
   AvlbleAlloc : Array[21..42] of real;
   AvlbleFoot   : Array[1..5] of real;
   Avlble_36xfer, Avlble_36RetAllow,Avlble_36Don :Real;
   Avlble_42ITC, Avlble_42LiveStock:Real;
     {footnotes}
   {
   Avlble_FtFTC, Avlble_FtECPQFP,Avlble_FtSelfEmpl,
     Avlble_FtQFP,Avlble_FtQSB:Real;
   }
  {used to summarize slips}
  {
  T3BoxRes : Array[21..42] of real;
  T3BoxPref : Array[21..42] of real;
  T3BoxNonRes : Array[21..42] of real;
  T3FootRes : Array[1..5] of real;
  T3FootPref : Array[1..5] of real;
  T3FootNonRes : Array[1..5] of real;
  }
   SourceDataDir : string[30];  {dir it came from}
   SourceFlName : string[12];  {file name it came from via readreturn}
  { from ClienTtable}
   PrpStatus   : string[2];
   Notes       : string[80];
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
   FontColor  : integer;   {0=normal, 1=Bold, 2:bold/colored}
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
      {0=Underline, 1=Bold Underline 2= Double Line, 3=Box, 4=bold box}
    FontSize    : Integer;
    FontStyle   : integer;  {0=Normal  1=bold }
   end;

  {Tax constants}
  Type
   ConstantsRec = Record
   FullYear          : Integer;
   DonPercent  : real;

  end;

  {current empl record}
  Type
   TEmplRec    = Record
   EmplNo      : String[3];
   Empl_Name   : String[40];
   Bus_Number  : String[15];
   District    :String[20];
   RemitT4     : Real;
   RemitT4A    : Real;
   NewHires    : Real;
   PayPeriods : String[5];
   UiPeriods  : String[5];
   UIRate     : Real;
   Street     : String[35];
   City       : String[20];
   Prov       : String[2];
   Postal     : String[7];
   T2CorpNo   : String[15];
   PropSin1   : String[9];
   PropSin2   : String[9];
   RppNum1    : String[15];
   RppNum2    : String[15];
   RppNum3    : String[15];
   Telephone  : String[8];
   AreaCode   : String[3];
   FirstName  : String[15];
   LastName   : String[35];
   AuthNAME   : String[40];
   Position   : String[20];
   TaxCentre  : String[20];

   T5_ammend  : String[1];
   T5_Before  : String[1];
   T5_Addit   : String[1];
   T5_UnclDiv : real;
   T5_UnclTax : real;
   T5Filer    : String[15];

   Same_Addr    : String[1];
   Old_Street   : String[40];
   Old_City     : String[30];
   Old_Prov     : String[2];
   Old_Postal   : String[8];
  end;

   {T4 sum}
  Type
   TT4Sum     = Record
   NumSlips   :Integer;
   TotBox14   :real;
   TotBox20   :real;
   TotBox52   :real;
   TotBox24   :real;
   TotBox16   :real;
   TotBox18   :real;
   TotBox22   :real;
   TotCPPAdj  :real;
   TotEIAdj   :real;
   TotTotAdj  :real;
   EmployerCPP :real;
   EmployerEI  :real;
   T4Remit     :real;
   TotDed      :real;
   SubTot      :real;
   Diff        :real;
   OverPay     :real;
   Balance     :real;
   NewHires    :real;
   TotBox83    : real;
  end;

  Type
   TT4ASum     = Record
   NumSlips   :Integer;
   TotBox16   :real;
   TotBox18   :real;
   TotBox20   :real;
   TotBox24   :real;
   TotBox26   :real;
   TotBox28   :real;
   TotBox30   :real;
   TotBox32   :real;
   TotBox34   :real;
   TotBox22   :real;
   T4ARemit   :real;
   TotDed      :real;
   Diff        :real;
   OverPay     :real;
   Balance     :real;
  end;

  {T5 sum}
  Type
   TT5Sum     = Record
   NumSlips   :Integer;
   TotBox10   :real;
   TotBox11   :real;
   TotBox12   :real;
   TotBox13   :real;
   TotBox14   :real;
   TotBox15   :real;
   TotBox16   :real;
   TotBox17   :real;
   TotBox18   :real;
   TotBox19   :real;
   TotBox20   :real;
   {
   TotBox32   :real;
   TotBox33   :real;
   }
  end;



 {============================== VARIABLES ======================}
 var
  T1LogsDir,T2LogsDir:String;
  AlreadyLogged: Boolean;
  PgmNames,ProductIds, PgmFactors:Tstringlist;
  Pgm:String;
  PgmId:String;
  TheKey :String;
  Base1,Base2 :String[4];
  BaseString: String[7];
  Version :String;

  DelayMsg:String;
  ApprovalNo : String[30];
  ScrDBF,CfgDbf : String[20];
  {T4 info}
  EmployerNo : String;
  T4Sin, T4ASin, T5Sin: String;

  {Field for T5 printing}
  InitT5PosX, InitT5PosY : real;
  InitT5SumPosX, InitT5SumPosY : real;
  DataField : Array[1..42] of string[10];  {field name}
  DataVal   : Array[1..42] of string[50];
  XPosition : Array[1..42] of real; {inches}
  YPosition : Array[1..42] of real; {inches}
  RJust     : Array[1..42] of boolean; {for right justif of amounts in summ}
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
  {RepaintDataOnly :Boolean;}  {need to show only the data?}
  XRefFormName, XRefFormNo : TStringList; {holds sorted xref of formname and FormNo}
  XRefMultName, XRefMultNo : TStringList; {holds sorted xref of multiple formname and FormNo}

  LetterType :String[6];  {Cover or Other:if Cover it calcs}
  {
  CCAClasses :Array[1..50] of string[4];
  CCARates   :Array[1..50] of string[3];
  }
  PrintBoxHeight :Integer;
  AbortSw :Boolean; {progress on printing etc}
  PauseSw :Boolean; {pause printing printing etc}
  InfoMsg : String[60];  {For messages on MDI/InfoOn/InfoOff}
  ActiveHandle : THandle;
  LinkSw : Boolean; LinkFormNo : Integer; LinkField :Integer;
  LinkTabNo : integer;

  MasterPswd : string[10]; {used in setting up new users}
 (* Ret      : array[1..ReturnsLimit] of ARetData;   {data for all returns}*)
  AppDir : String[255];   AppVersion : string[5];
  Licensee : String[40];  LicenseLevel : String[5];
  BatchOper : String[20]; BatchFilter : String[20];
  CfgTbl: TTable; {congig data base table}
  FileDescr :string[60];
  FixDbName : String[12];
  UserName : String[10];
  ShowFieldIdSw : Boolean;
  {Somelist : create and free in any unit}
  SomeList : TstringList; SomeCaption: String[60]; SomeFilter: String[60];
  SomeFileMask : String[10];  SelectedString : String[120];
  SomeDir :string[60];
  VList :TStringList; {stores validation rules for current form:
      i.e. YN,??????}
  {TaxSumList : TstringList;} {holds x-ref for TaxSumList}
  AffectedList : TStringList; {holds affected schedules in calcs}
  NewForm : Boolean;
  User : AUserProfile;

  Ret : Array[0..ReturnsLimit] of RetPtr;
  Constant : Array[0..1] of ConstantsRec;
  {Letters}
  LetterMxParagraphLines: Integer;
  LetterName : string;
  LetterReturnType : string;
  LetterParagraphName :String;

  CfgRec : ACfgRec;
  {summary variables for slips}


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
  PrevReturnNo : integer;
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


implementation

end.
